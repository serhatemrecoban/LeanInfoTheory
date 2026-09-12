#!/usr/bin/env python3
"""Reproduce retained types from independently built exact-release source.

The source must be an isolated Git-archive copy under this checkout's ignored
tmp directory, with its own project build output. Dependency caches may be shared.
This reproducer is not the current-source compatibility checker planned in C9.02.
"""

from __future__ import annotations

import argparse
import hashlib
import io
import json
import os
import stat
import subprocess
import sys
import tarfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
import frozen_public_api as frozen
import generate_website_blueprint as blueprint

EXPORTER = Path(__file__).with_name("ExportRetained.lean")
ARTIFACT = ROOT / "docs/compatibility/v0.1.0-retained-contract.json"


def sha256(raw: bytes) -> str:
    return hashlib.sha256(raw).hexdigest()


def command(args: list[str], cwd: Path) -> bytes:
    result = subprocess.run(args, cwd=cwd, capture_output=True, check=False,
                            env={**os.environ, "GIT_OPTIONAL_LOCKS": "0"})
    if result.returncode:
        raise RuntimeError(
            f"command failed ({result.returncode}) in {cwd}: {args!r}\n"
            + result.stdout.decode("utf-8", errors="replace")
            + result.stderr.decode("utf-8", errors="replace")
        )
    if result.stderr:
        sys.stderr.buffer.write(result.stderr)
        sys.stderr.buffer.flush()
    return result.stdout


def release_files() -> dict[str, bytes]:
    tag_commit = command(["git", "rev-parse", f"{frozen.RELEASE_TAG}^{{commit}}"], ROOT).decode().strip()
    if tag_commit != frozen.RELEASE_COMMIT:
        raise ValueError("release tag does not resolve to the pinned release commit")
    archive = command(
        ["git", "archive", "--format=tar", frozen.RELEASE_COMMIT,
         "LeanInfoTheory", "LeanInfoTheory.lean", "lakefile.toml",
         "lake-manifest.json", "lean-toolchain", "docs/v0.1-public-api.json"], ROOT
    )
    with tarfile.open(fileobj=io.BytesIO(archive)) as tar:
        return {entry.name: tar.extractfile(entry).read()
                for entry in tar.getmembers() if entry.isfile()}


def source_identity(source: Path, expected: dict[str, bytes]) -> dict[str, str]:
    if source == ROOT or not source.is_relative_to((ROOT / "tmp").resolve()):
        raise ValueError("baseline source must be an isolated copy below the checkout's tmp/")
    command(["git", "check-ignore", source.relative_to(ROOT).as_posix()], ROOT)
    if (source / "lakefile.lean").exists():
        raise ValueError("unexpected alternate Lake configuration in the baseline copy")
    build = source / ".lake/build"
    if build.resolve() != build.absolute():
        raise ValueError("baseline project build output must not be shared or redirected")
    # Reject nested redirects too; sharing dependency caches does not authorize
    # borrowing the current project's oleans beneath an otherwise real directory.
    pending = [build] if build.exists() else []
    while pending:
        directory = pending.pop()
        for item in directory.iterdir():
            info = item.lstat()
            if item.is_symlink() or getattr(info, "st_file_attributes", 0) & stat.FILE_ATTRIBUTE_REPARSE_POINT:
                raise ValueError(f"redirected baseline build entry: {item}")
            if item.is_dir():
                pending.append(item)
    actual_lean = {p.relative_to(source).as_posix()
                   for p in (source / "LeanInfoTheory").rglob("*.lean")}
    actual_lean.add("LeanInfoTheory.lean")
    if actual_lean != {p for p in expected if p.endswith(".lean")}:
        raise ValueError("baseline Lean source inventory differs from the release")
    for path, raw in expected.items():
        if (source / path).read_bytes() != raw:
            raise ValueError(f"baseline is not exact release source: {path}")
    return {path: sha256(raw) for path, raw in sorted(expected.items())}


def dependency_identity(source: Path) -> dict[str, str]:
    manifest = json.loads((source / "lake-manifest.json").read_bytes())
    result = {}
    for package in manifest["packages"]:
        if package["type"] != "git":
            raise ValueError("unsupported dependency provenance")
        path = source / ".lake/packages" / package["name"]
        actual = command(["git", "rev-parse", "HEAD"], path).decode().strip()
        if actual != package["rev"] or command(["git", "status", "--porcelain"], path).strip():
            raise ValueError(f"dependency revision or source differs: {package['name']}")
        result[package["name"]] = actual
    return dict(sorted(result.items()))


def check_export(raw: bytes, manifest: dict) -> list[dict]:
    data = json.loads(raw)
    if set(data) != {"schema", "declarations"} or data["schema"] != "lean-info-theory.retained-types.v1":
        raise ValueError("unsupported exporter result schema")
    records = data["declarations"]
    expected = manifest["declarations"]
    if len(records) != 601 or len(expected) != 601:
        raise ValueError("retained export must cover exactly 601 declarations")
    if [r["name"] for r in records] != [r["name"] for r in expected]:
        raise ValueError("retained export names/order differ from the frozen inventory")
    if len({r["name"] for r in records}) != len(records):
        raise ValueError("duplicate retained export name")
    fields = {"name", "source_kind", "compiled_kind", "owner", "universe_parameters", "type"}
    for record, entry in zip(records, expected, strict=True):
        # A Prop-valued instance is compiled as thmInfo by Lean. Keep both
        # identities; source syntax alone cannot decide that instance's kind.
        allowed_compiled = {"theorem", "definition"} if entry["kind"] == "instance" else (
            {"theorem"} if entry["kind"] == "theorem" else {"definition"})
        if (set(record) != fields or record["owner"] != entry["module"]
                or record["source_kind"] != entry["kind"]
                or record["compiled_kind"] not in allowed_compiled):
            raise ValueError(f"retained ownership/kind mismatch: {entry['name']}")
        if not isinstance(record["type"], list) or not isinstance(record["universe_parameters"], list):
            raise ValueError(f"missing complete retained type: {entry['name']}")
    return records


def import_records(source: Path, manifest: dict) -> dict:
    modules = set(manifest["supported_modules"]) | {"LeanInfoTheory", "LeanInfoTheory.InformationMeasures"}
    local = {p.relative_to(source).with_suffix("").as_posix().replace("/", ".")
             for p in (source / "LeanInfoTheory").rglob("*.lean")} | {"LeanInfoTheory"}
    records = {}
    for module in sorted(modules):
        imports = blueprint.parse_imports(source / (module.replace(".", "/") + ".lean"))
        records[module] = {"local": sorted(i for i in imports if i in local),
                           "external": sorted(i for i in imports if i not in local)}
    return records


def reproduce(source: Path) -> bytes:
    expected = release_files()
    before = source_identity(source, expected)
    dependencies = dependency_identity(source)
    exporter_hash = sha256(EXPORTER.read_bytes())
    raw_manifest = expected["docs/v0.1-public-api.json"]
    if sha256(raw_manifest) != frozen.GIT_BLOB_SHA256:
        raise ValueError("release Git blob disagrees with frozen identity")
    manifest = json.loads(raw_manifest)
    build_output = command(["lake", "-KwarningAsError=true", "build", "LeanInfoTheory.Shannon"], source)
    print(build_output.decode("utf-8", errors="replace").rstrip(), file=sys.stderr)
    invocation = ["lake", "env", "lean", "--run", str(EXPORTER), str(source / "docs/v0.1-public-api.json")]
    first = command(invocation, source)
    second = command(invocation, source)
    records = check_export(first, manifest)
    check_export(second, manifest)
    if first != second:
        raise ValueError("independent retained exports are not byte-repeatable")
    if (source_identity(source, expected) != before
            or dependency_identity(source) != dependencies
            or sha256(EXPORTER.read_bytes()) != exporter_hash):
        raise ValueError("source, dependency or exporter changed during reproduction")
    payload = {
        "schema": "lean-info-theory.retained-contract.v0.1.0.v1",
        "release": frozen.baseline_identity(),
        "exporter": {"path": "scripts/compatibility/ExportRetained.lean", "sha256": exporter_hash,
                     "schema": "lean-info-theory.retained-types.v1"},
        "toolchain": expected["lean-toolchain"].decode().strip(),
        "dependencies": dependencies, "release_source_sha256": before,
        "declaration_count": len(records), "declarations": records,
        "direct_imports": import_records(source, manifest),
        "root_exports": manifest["root_exports"],
        "reviewed_simp": [d["name"] for d in manifest["declarations"] if "simp" in d["attributes"]],
        "limitations": [
            "Types, universe parameters and original source kinds are retained; definition bodies and semantics are not frozen by type comparison.",
            "Raw defnInfo does not distinguish source def/abbrev/instance; source kinds come from the exact frozen release manifest.",
            "Prop-valued instances may compile as thmInfo; both original source kind and actual compiled kind are retained.",
            "Root aliases and direct imports are retained records, not current-environment compatibility verification.",
            "Expression metadata and unresolved variables are rejected rather than normalized or omitted.",
        ],
    }
    return (json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n").encode()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline-source", type=Path, required=True)
    destination = parser.add_mutually_exclusive_group(required=True)
    destination.add_argument("--output", type=Path, help="new comparison artifact; never the frozen manifest")
    destination.add_argument("--check", action="store_true", help="compare with the retained artifact without rewriting it")
    args = parser.parse_args()
    try:
        if args.output and args.output.resolve() in {ARTIFACT.resolve(), frozen.FROZEN_PATH.resolve()}:
            raise ValueError("write a separate comparison artifact; do not overwrite retained baselines")
        if args.output and (args.output.exists()
                            or not args.output.resolve().is_relative_to((ROOT / "tmp").resolve())):
            raise ValueError("comparison output must be a new file below this checkout's tmp/")
        rendered = reproduce(args.baseline_source.resolve())
        if args.check:
            if ARTIFACT.read_bytes() != rendered:
                raise ValueError("retained artifact differs from exact-release reproduction")
            print("retained baseline reproduction matches all 601 contracts")
        else:
            with args.output.open("xb") as output:
                output.write(rendered)
            print(f"wrote independent comparison artifact: {args.output}")
        return 0
    except (OSError, ValueError, RuntimeError, KeyError, TypeError) as error:
        print(f"retained baseline reproduction failed: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
    raise SystemExit(main())
