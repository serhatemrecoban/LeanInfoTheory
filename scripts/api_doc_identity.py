"""Source identity for current API documentation; no output or cache mutation.

Raw bytes, relative paths and clean, locked dependency revisions bind evidence.
This fingerprint detects changes; it does not prove compilation or semantics.
The two successful doc-gen/check passes remain the validator's responsibility.
"""

from __future__ import annotations

import hashlib
import json
import re
import subprocess
from pathlib import Path

import current_api
import frozen_public_api
from check_public_api_compatibility import strict_json

ROOT = Path(__file__).resolve().parents[1]
CONFIG_SCHEMA = "lean-info-theory.api-doc-build-config.v2"
ATTESTATION_SCHEMA = "lean-info-theory.api-doc-attestation.v2"
IDENTITY_SCHEMA = "lean-info-theory.api-doc-source-identity.v1"
DOCGEN_REVISION = "e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015"
LEAN_REVISION = "819816b2e0a3bf405af45ae5c7af2491d8f5bee6"
MATHLIB_REVISION = "0df444a360eaa60ab8c11dca51a86af692955474"
# The existing reviewed 14-Git-package lock, accepting only uniform LF/CRLF bytes.
# Kept independent of validate_release imports so the standalone checker enforces
# the same immutable lock even when no validator command ran first.
DOCBUILD_LOCK_SHA256 = "5081be319cca82f1e3edeae18f9915d724dbc5ff7366f4a16bde12e0d98e09b7"
DOCBUILD_LOCK_CRLF_SHA256 = "78f49822e13bbbfd98f068d86333974bb858dcdc223a91928a76dac0c043abd0"

# Explicit build/checker inputs, in addition to every local Lean source (including
# non-stable modules). No generated outputs, mtimes, absolute paths or Git index
# timestamps enter the digest. Dependency build caches are deliberately excluded.
INPUTS = (
    "lakefile.toml", "lake-manifest.json", "lean-toolchain",
    "docbuild/lakefile.toml", "docbuild/lake-manifest.json",
    "docbuild/lean-toolchain", "docbuild/CCShim.lean",
    "docs/current-public-api.json", "docs/v0.1-public-api.json",
    "docs/compatibility/v0.1.0-retained-contract.json", "docs/compatibility/current-api-policy.json",
    "scripts/api_doc_identity.py", "scripts/check_api_docs.py",
    "scripts/validate_release.py", "scripts/current_api.py",
    "scripts/frozen_public_api.py", "scripts/generate_current_public_api.py",
    "scripts/generate_website_api_index.py", "scripts/generate_website_blueprint.py",
    "scripts/check_public_api_compatibility.py",
    "scripts/compatibility/current_policy.py",
    "scripts/compatibility/ExportRetained.lean",
    "scripts/compatibility/export_retained_api.py",
    "scripts/compatibility/CurrentAudit.lean", "scripts/stage_website.py",
)


def sha256(raw: bytes) -> str:
    return hashlib.sha256(raw).hexdigest()


def encode(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=False, sort_keys=True,
                       separators=(",", ":"), allow_nan=False) + "\n").encode("utf-8")


def require_local_file(root: Path, relative: str) -> Path:
    path = root / relative
    current = root
    for component in Path(relative).parts:
        current /= component
        attributes = int(getattr(current.lstat(), "st_file_attributes", 0))
        if current.is_symlink() or attributes & 0x400:
            raise ValueError(f"redirected API-doc identity input: {relative}")
    if not path.is_file():
        raise ValueError(f"missing API-doc identity input: {relative}")
    return path


def source_inputs(root: Path = ROOT) -> dict[str, str]:
    """Hash the exact maintained inputs, detecting additions/removals of Lean files."""
    paths = set(INPUTS) | {"LeanInfoTheory.lean"}
    paths.update(path.relative_to(root).as_posix()
                 for path in (root / "LeanInfoTheory").rglob("*.lean"))
    return {relative: sha256(require_local_file(root, relative).read_bytes())
            for relative in sorted(paths)}


def git_output(path: Path, *args: str) -> str:
    result = subprocess.run(["git", *args], cwd=path, capture_output=True,
                            encoding="utf-8", check=False)
    if result.returncode:
        raise ValueError(f"API-doc dependency inspection failed in {path}: {result.stderr.strip()}")
    return result.stdout.strip()


def dependency_identity(root: Path = ROOT) -> dict[str, str]:
    """Bind all docbuild Git dependencies to their actual clean locked checkout.

    The validator separately enforces the reviewed lock/configuration. The one
    path dependency is the parent source already covered by source_inputs.
    Lake's escaped package name «doc-gen4» resolves to directory doc-gen4.
    """
    raw_lock = (root / "docbuild/lake-manifest.json").read_bytes()
    if sha256(raw_lock) not in {DOCBUILD_LOCK_SHA256, DOCBUILD_LOCK_CRLF_SHA256}:
        raise ValueError("API-doc dependency lock differs from the reviewed pinned lock")
    lock = strict_json(raw_lock)
    packages = lock["packages"]
    path_packages = [package for package in packages if package.get("type") == "path"]
    if len(path_packages) != 1 or path_packages[0].get("name") != "LeanInfoTheory" \
            or path_packages[0].get("dir") != "../":
        raise ValueError("API-doc identity requires exactly the parent path dependency")
    result = {}
    for package in packages:
        if package.get("type") == "path":
            continue
        name = package.get("name")
        directory = "doc-gen4" if name == "«doc-gen4»" else name
        if package.get("type") != "git" or not isinstance(directory, str) \
                or re.fullmatch(r"[A-Za-z0-9_-]+", directory) is None:
            raise ValueError("unsupported API-doc dependency provenance")
        if name in result or re.fullmatch(r"[0-9a-f]{40}", str(package.get("rev", ""))) is None:
            raise ValueError(f"invalid API-doc dependency pin: {name}")
        path = root / ".lake/packages" / directory
        actual = git_output(path, "rev-parse", "HEAD")
        if actual != package["rev"] or git_output(path, "status", "--porcelain", "--untracked-files=normal"):
            raise ValueError(f"API-doc dependency revision or source differs: {name}")
        result[name] = actual
    return dict(sorted(result.items()))


def current_doc_identity() -> dict[str, object]:
    """Verify current inventory/policy and return a stable content-bound identity."""
    current_api.load_current_manifest()
    for relative in ("lean-toolchain", "docbuild/lean-toolchain"):
        if (ROOT / relative).read_text(encoding="utf-8").strip() != "leanprover/lean4:v4.33.1":
            raise ValueError(f"API-doc toolchain differs from the reviewed pin: {relative}")
    inputs = source_inputs()
    dependencies = dependency_identity()
    return {
        "schema": IDENTITY_SCHEMA,
        "current_manifest_sha256": inputs["docs/current-public-api.json"],
        "retained_contract_sha256": inputs["docs/compatibility/v0.1.0-retained-contract.json"],
        "baseline_identity": frozen_public_api.baseline_identity(),
        "source_content_sha256": sha256(encode({"inputs": inputs, "dependencies": dependencies})),
        "inputs": inputs,
        "dependencies": dependencies,
    }


def verify_configuration(configuration: dict[str, object]) -> None:
    """Refuse stale current evidence, including same-path file-mode evidence."""
    if configuration.get("schema") != CONFIG_SCHEMA:
        raise ValueError("current API docs require a v2 build configuration; rebuild with the maintained api-docs gate")
    expected = {"schema", "docgen_revision", "lean_revision", "mathlib_revision",
                "source_mode", "source_identity", "disable_equations", "api_identity"}
    if set(configuration) != expected:
        raise ValueError("current API-doc configuration has missing or unknown fields")
    for key, value in {"docgen_revision": DOCGEN_REVISION, "lean_revision": LEAN_REVISION,
                       "mathlib_revision": MATHLIB_REVISION}.items():
        if configuration[key] != value:
            raise ValueError(f"current API-doc configuration has an unexpected {key}")
    if configuration["disable_equations"] is not True:
        raise ValueError("current API-doc configuration must disable equations")
    mode = configuration["source_mode"]
    if mode == "file":
        source = str(ROOT.resolve())
    elif mode == "github":
        source = git_output(ROOT, "rev-parse", "HEAD")
        if re.fullmatch(r"[0-9a-f]{40}", source) is None \
                or git_output(ROOT, "status", "--porcelain", "--untracked-files=normal"):
            raise ValueError("GitHub API-doc links require the exact clean current source checkout")
    else:
        raise ValueError("current API-doc source mode must be file or github")
    if configuration["source_identity"] != source:
        raise ValueError("current API-doc source identity differs from this checkout")
    if configuration.get("api_identity") != current_doc_identity():
        raise ValueError("API-doc source-content identity is stale; rebuild current documentation")
