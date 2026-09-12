#!/usr/bin/env python3
"""Check the retained release contract against freshly built current Lean input.

This focused command preserves the historical artifacts. It does not establish
semantic equivalence of definition bodies or replace the separate trust/doc gates.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import stat
import subprocess
import sys
import uuid

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
sys.path.insert(0, str(ROOT / "scripts/compatibility"))
import frozen_public_api as frozen
import generate_current_public_api as current_api
import generate_website_blueprint as blueprint
import export_retained_api as retained
import current_policy

POLICY = ROOT / "docs/compatibility/current-api-policy.json"
DRIVER = ROOT / "scripts/compatibility/CurrentAudit.lean"
RETAINED_SHA256 = "b4beab492f4b782613dd89b157855a6ca59636a8f35b7f4fa97c15d27653d5ed"
LEAN_COMMIT = "819816b2e0a3bf405af45ae5c7af2491d8f5bee6"
PREFIX_MARKER = "\ndef main (args : List String) : IO Unit := do"
CONFIGURATION = ("lean-toolchain", "lakefile.toml", "lake-manifest.json")
INPUTS = (*CONFIGURATION, "docs/v0.1-public-api.json",
          "docs/compatibility/v0.1.0-retained-contract.json",
          "docs/compatibility/current-api-policy.json",
          "scripts/check_public_api_compatibility.py", "scripts/validate_release.py",
          "scripts/frozen_public_api.py", "scripts/generate_current_public_api.py",
          "scripts/generate_website_api_index.py", "scripts/generate_website_blueprint.py",
          "scripts/compatibility/export_retained_api.py",
          "scripts/compatibility/ExportRetained.lean", "scripts/compatibility/CurrentAudit.lean",
          "scripts/compatibility/current_policy.py")


def sha256(raw: bytes) -> str:
    return hashlib.sha256(raw).hexdigest()


def encode(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, sort_keys=True,
                       separators=(",", ":"), allow_nan=False) + "\n").encode("utf-8")


def strict_json(raw: bytes) -> object:
    def object_pairs(pairs):
        result = {}
        for key, value in pairs:
            if key in result:
                raise ValueError(f"duplicate JSON key: {key}")
            result[key] = value
        return result
    def invalid_constant(value):
        raise ValueError(f"invalid JSON constant: {value}")
    return json.loads(raw, object_pairs_hook=object_pairs, parse_constant=invalid_constant)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def natural(value) -> bool:
    return type(value) is int and value >= 0


def check_name(value) -> None:
    require(isinstance(value, list) and bool(value), "malformed structural name")
    tag = value[0]
    if tag == "anonymous":
        require(len(value) == 1, "malformed anonymous name")
    elif tag in {"str", "num"}:
        require(len(value) == 3, "malformed name component")
        check_name(value[1])
        require(isinstance(value[2], str) if tag == "str" else natural(value[2]),
                "malformed name component value")
    else:
        raise ValueError(f"unsupported structural name tag: {tag!r}")


def check_level(value, parameters: set[bytes]) -> None:
    require(isinstance(value, list) and bool(value), "malformed universe level")
    tag = value[0]
    arities = {"zero": 1, "succ": 2, "max": 3, "imax": 3, "param": 2}
    require(isinstance(tag, str) and tag in arities and len(value) == arities[tag],
            "unsupported or malformed universe level")
    if tag == "param":
        check_name(value[1])
        require(encode(value[1]) in parameters, "unbound universe parameter")
    else:
        for child in value[1:]:
            check_level(child, parameters)


def check_expr(value, parameters: set[bytes], depth: int = 0) -> None:
    require(isinstance(value, list) and bool(value), "malformed retained type")
    tag = value[0]
    arities = {"bvar": 2, "sort": 2, "const": 3, "app": 3,
               "lambda": 5, "forall": 5, "let": 6, "natLiteral": 2,
               "stringLiteral": 2, "projection": 4}
    require(isinstance(tag, str) and tag in arities and len(value) == arities[tag],
            "unsupported or malformed retained type constructor")
    if tag == "bvar":
        require(natural(value[1]) and value[1] < depth, "unbound retained type index")
    elif tag == "sort":
        check_level(value[1], parameters)
    elif tag == "const":
        check_name(value[1])
        require(isinstance(value[2], list), "malformed constant universe arguments")
        for level in value[2]:
            check_level(level, parameters)
    elif tag == "app":
        check_expr(value[1], parameters, depth)
        check_expr(value[2], parameters, depth)
    elif tag in {"lambda", "forall"}:
        check_name(value[1])
        require(value[2] in ("explicit", "implicit", "strictImplicit", "instanceImplicit"),
                "unsupported retained binder mode")
        check_expr(value[3], parameters, depth)
        check_expr(value[4], parameters, depth + 1)
    elif tag == "let":
        check_name(value[1])
        require(type(value[2]) is bool, "malformed let nondependency flag")
        check_expr(value[3], parameters, depth)
        check_expr(value[4], parameters, depth)
        check_expr(value[5], parameters, depth + 1)
    elif tag == "natLiteral":
        require(natural(value[1]), "malformed natural literal")
    elif tag == "stringLiteral":
        require(isinstance(value[1], str), "malformed string literal")
    else:
        check_name(value[1])
        require(natural(value[2]), "malformed projection index")
        check_expr(value[3], parameters, depth)


def check_record_types(records: list[dict]) -> None:
    for record in records:
        try:
            parameters = record["universe_parameters"]
            require(isinstance(parameters, list), "malformed universe parameter list")
            for parameter in parameters:
                check_name(parameter)
            names = {encode(parameter) for parameter in parameters}
            require(len(names) == len(parameters), "duplicate universe parameter")
            check_expr(record["type"], names)
        except (ValueError, KeyError, TypeError, RecursionError) as error:
            raise ValueError(f"invalid retained type for {record.get('name', '<unknown>')}: {error}") from error


def load_baseline() -> tuple[dict, dict]:
    manifest = frozen.verify_frozen_manifest()
    raw = retained.ARTIFACT.read_bytes()
    require(sha256(raw) == RETAINED_SHA256, "immutable retained artifact identity mismatch")
    baseline = strict_json(raw)
    require(baseline["schema"] == "lean-info-theory.retained-contract.v0.1.0.v1",
            "retained artifact schema mismatch")
    require(baseline["release"] == frozen.baseline_identity(), "retained release identity mismatch")
    require(baseline["exporter"]["sha256"] == sha256(retained.EXPORTER.read_bytes()),
            "historical exporter identity mismatch")
    records = retained.check_export(encode({"schema": baseline["exporter"]["schema"],
                                           "declarations": baseline["declarations"]}), manifest)
    check_record_types(records)
    return manifest, baseline


def first_difference(old, new, path: str = ""):
    if type(old) is not type(new):
        return path, old, new
    if isinstance(old, dict):
        if set(old) != set(new):
            return path + ".keys", sorted(old), sorted(new)
        for key in sorted(old):
            result = first_difference(old[key], new[key], f"{path}.{key}".lstrip("."))
            if result:
                return result
    elif isinstance(old, list):
        if len(old) != len(new):
            return path + ".length", len(old), len(new)
        for index, (left, right) in enumerate(zip(old, new, strict=True)):
            result = first_difference(left, right, f"{path}[{index}]")
            if result:
                return result
    elif old != new:
        return path, old, new
    return None


def compare_types(baseline: dict, raw: bytes, manifest: dict) -> None:
    # The original fresh-export envelope check and new recursive grammar check
    # remain distinct from exact historical/current structural equality.
    strict_json(raw)
    records = retained.check_export(raw, manifest)
    check_record_types(records)
    for old, new in zip(baseline["declarations"], records, strict=True):
        difference = first_difference(old, new)
        if difference:
            path, left, right = difference
            shown = lambda value: json.dumps(value, ensure_ascii=False)[:220]
            raise ValueError(f"retained contract changed: {old['name']} at {path}; "
                             f"old={shown(left)}; current={shown(right)}")


def unredirected_tree(path: Path) -> None:
    require(path.resolve() == path.absolute(), f"redirected project output: {path}")
    pending = [path] if path.exists() else []
    while pending:
        directory = pending.pop()
        for item in directory.iterdir():
            info = item.lstat()
            require(not item.is_symlink() and not (getattr(info, "st_file_attributes", 0)
                    & getattr(stat, "FILE_ATTRIBUTE_REPARSE_POINT", 0x400)), f"redirected project output entry: {item}")
            require(not item.is_file() or info.st_nlink == 1, f"shared project output hardlink: {item}")
            if item.is_dir():
                pending.append(item)


def source_identity() -> dict[str, str]:
    require(not (ROOT / "lakefile.lean").exists(), "alternate effective Lake configuration")
    paths = set(INPUTS) | {p.relative_to(ROOT).as_posix() for p in blueprint.lean_files()}
    for rel in paths:
        path = ROOT / rel
        require(path.is_file() and path.resolve() == path.absolute(), f"missing or redirected input: {rel}")
    return {rel: sha256((ROOT / rel).read_bytes()) for rel in sorted(paths)}


def source_header_imports(source: str, owner: str) -> list[str]:
    """Accept the project's plain import header, with normal Lean comments.

    The pinned compiler inserts ordinary and meta Init imports without prelude.
    Refuse other header modes so that exact normalization remains justified.
    This is a bounded header check, not a replacement Lean declaration parser.
    """
    position, imports = 0, []
    while position < len(source):
        if source[position].isspace():
            position += 1
            continue
        if source.startswith("--", position):
            newline = source.find("\n", position)
            position = len(source) if newline < 0 else newline + 1
            continue
        if source.startswith("/-", position):
            depth, position = 1, position + 2
            while position < len(source) and depth:
                pair = source[position:position + 2]
                if pair in ("/-", "-/"):
                    depth += 1 if pair == "/-" else -1
                    position += 2
                else:
                    position += 1
            require(depth == 0, f"unterminated source header comment: {owner}")
            continue
        remaining = source[position:]
        require(re.match(r"(?:prelude|module)\b|(?:(?:public|private|meta)\s+)+import\b", remaining) is None,
                f"unsupported source import header mode: {owner}")
        if re.match(r"import\b", remaining) is None:
            break
        line = remaining.split("\n", 1)[0]
        match = re.fullmatch(r"import[ \t]+([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)*)[ \t\r]*", line)
        require(match is not None, f"unsupported source import syntax: {owner}: {line}")
        imports.append(match.group(1))
        position += len(line)
    return imports


def direct_source_imports() -> dict[str, dict[str, list[str]]]:
    infos = blueprint.build_module_infos()
    local = {info.name for info in infos}
    result = {}
    for info in infos:
        path = ROOT / (info.name.replace(".", "/") + ".lean")
        imports = blueprint.parse_imports(path)
        header = source_header_imports(path.read_text(encoding="utf-8"), info.name)
        require(header == imports, f"source import parser/header disagreement: {info.name}")
        for imported in imports:
            require(re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)*", imported) is not None,
                    f"unsupported source import syntax: {info.name}: {imported}")
        result[info.name] = {"local": sorted(i for i in imports if i in local),
                             "external": sorted(i for i in imports if i not in local)}
    return result


def assemble_driver() -> bytes:
    source = retained.EXPORTER.read_text(encoding="utf-8")
    require(source.count(PREFIX_MARKER) == 1, "historical exporter prefix boundary changed")
    prefix = source.split(PREFIX_MARKER)[0]
    require(prefix.count("\nimport Lean\n") == 1, "historical exporter import boundary changed")
    prefix = prefix.replace("\nimport Lean\n", "\nimport Lean\nimport Lean.AutoDecl\nimport Mathlib.Lean.Meta.Simp\n")
    return (prefix + "\n" + DRIVER.read_text(encoding="utf-8")).encode("utf-8")


class RunEvidence:
    def __init__(self):
        root = ROOT / ".lake/compatibility"
        require(root.resolve() == root.absolute(), "redirected compatibility evidence root")
        root.mkdir(parents=True, exist_ok=True)
        self.path = root / uuid.uuid4().hex
        self.path.mkdir()
        self.commands = []

    def write(self, name: str, value: object) -> None:
        with (self.path / name).open("xb") as output:
            output.write(encode(value))

    def run(self, label: str, args: list[str]) -> bytes:
        print(f"compatibility {label}: {args!r}", flush=True)
        stdout = self.path / f"{label}.stdout"
        stderr = self.path / f"{label}.stderr"
        env = dict(os.environ, GIT_OPTIONAL_LOCKS="0", GIT_TERMINAL_PROMPT="0")
        env.pop("LEAN_PATH", None)
        with stdout.open("xb") as out, stderr.open("xb") as err:
            completed = subprocess.run(args, cwd=ROOT, stdout=out, stderr=err,
                                       env=env, check=False)
        record = {"label": label, "command": args, "cwd": str(ROOT),
                  "exit_code": completed.returncode, "inherited_LEAN_PATH_removed": True,
                  "stdout_sha256": sha256(stdout.read_bytes()),
                  "stderr_sha256": sha256(stderr.read_bytes())}
        self.commands.append(record)
        self.write(f"{label}.result.json", record)
        if completed.returncode:
            diagnostic = (stdout.read_bytes() + b"\n" + stderr.read_bytes()).decode("utf-8", errors="replace")
            raise ValueError(f"{label} failed ({completed.returncode}); {diagnostic[-4000:]}; "
                             f"original output: {self.path}")
        return stdout.read_bytes()


def run_compatibility(evidence: RunEvidence) -> dict:
    manifest, baseline = load_baseline()
    before = source_identity()
    for rel in CONFIGURATION:
        raw = (ROOT / rel).read_bytes().replace(b"\r\n", b"\n")
        require(sha256(raw) == baseline["release_source_sha256"][rel],
                f"unapproved pinned build configuration change: {rel}")
    dependencies = retained.dependency_identity(ROOT)
    require(dependencies == baseline["dependencies"], "retained dependency identity mismatch")
    unredirected_tree(ROOT / ".lake/build")
    evidence.write("source-before.json", {"files": before, "dependencies": dependencies})
    current = current_api.build_manifest()
    evidence.write("current-source-inventory.json", current)
    imports = direct_source_imports()
    policy = strict_json(POLICY.read_bytes())
    expected = current_policy.validate_source_policy(manifest, baseline, current, imports, policy)
    evidence.write("expected-boundaries.json", expected)
    version = evidence.run("compiler", ["lake", "env", "lean", "--version"]).decode("utf-8").strip()
    match = re.search(r"version 4\.33\.1,.*commit ([0-9a-f]{7,40})", version)
    require(match is not None and LEAN_COMMIT.startswith(match.group(1)),
            f"unexpected effective Lean compiler: {version}")
    evidence.run("build", ["lake", "-KwarningAsError=true", "build", "LeanInfoTheory.Shannon"])
    exported = evidence.run("retained", ["lake", "env", "lean", "-DwarningAsError=true", "--run",
                                        str(retained.EXPORTER), str(frozen.FROZEN_PATH)])
    compare_types(baseline, exported, manifest)
    print("compatibility retained types: all 601 match", flush=True)
    request = {"current_declarations": current["declarations"],
               "supported_modules": current["supported_modules"],
               "root_exports": expected["root_exports"],
               "project_build_root": str((ROOT / ".lake/build/lib/lean").resolve())}
    evidence.write("audit-input.json", request)
    driver = evidence.path / "CurrentAudit.lean"
    driver.write_bytes(assemble_driver())
    audit = strict_json(evidence.run("boundaries", ["lake", "env", "lean", "-DwarningAsError=true",
                          "--run", str(driver), str(evidence.path / "audit-input.json")]))
    current_policy.compare_compiled_policy(expected, audit)
    after = source_identity()
    after_dependencies = retained.dependency_identity(ROOT)
    evidence.write("source-after.json", {"files": after, "dependencies": after_dependencies})
    require(before == after and dependencies == after_dependencies,
            "source/configuration/dependencies changed during compatibility build/export")
    unredirected_tree(ROOT / ".lake/build")
    return {"schema": "lean-info-theory.current-compatibility-result.v1", "outcome": "PASS",
            "retained_count": len(baseline["declarations"]), "current_count": len(current["declarations"]),
            "supported_module_count": len(current["supported_modules"]),
            "source_sha256": sha256(encode(before)), "dependencies": dependencies,
            "compiler": version, "retained_artifact_sha256": RETAINED_SHA256,
            "commands": evidence.commands, "evidence_directory": str(evidence.path),
            "limitations": ["Equal retained types do not establish unchanged definition bodies or semantics.",
                            "Source/pin/build checks provide cooperative provenance, not hostile-process isolation.",
                            "Current trust and API-documentation integration remain separate gates."]}


def main(argv: list[str] | None = None) -> int:
    argparse.ArgumentParser(description=__doc__).parse_args(argv)
    evidence = None
    try:
        evidence = RunEvidence()
        result = run_compatibility(evidence)
        evidence.write("result.json", result)
        print(json.dumps(result, ensure_ascii=False, sort_keys=True), flush=True)
        return 0
    except (OSError, ValueError, KeyError, TypeError, RecursionError) as error:
        failure = {"outcome": "FAIL", "diagnostic": str(error),
                   "evidence_directory": str(evidence.path) if evidence else None,
                   "commands": evidence.commands if evidence else []}
        if evidence:
            evidence.write("failure.json", failure)
        print("public API compatibility failed: " + json.dumps(failure, ensure_ascii=False), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
    raise SystemExit(main())
