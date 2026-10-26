"""The one unpublished v0.2 candidate and the unchanged historical release.

This policy selects validation contracts. It never authorizes publication,
approves a regenerated baseline, or turns a working tree into a qualified commit.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import re
import subprocess
import tomllib

ROOT = Path(__file__).resolve().parents[1]
STATE_PATH = "docs/compatibility/candidate-release-state.json"
TARGET_VERSION = "0.2.0"
STABLE_VERSION = "0.1.0"
CANDIDATE_CONTRACT_PATH = "docs/compatibility/v0.2.0-candidate-contract.json"
CANDIDATE_APPROVAL_PATH = "docs/compatibility/v0.2.0-candidate-approval.json"
LOCAL_PRIVATE_PATH = "docs/next-website-tasks.md"
STATE_SCHEMA = "lean-info-theory.candidate-release-state.v1"
IDENTITY_SCHEMA = "lean-info-theory.candidate-release-identity.v1"
FIXED = {
    "schema": STATE_SCHEMA,
    "target_version": TARGET_VERSION,
    "stable_version": STABLE_VERSION,
    "current_route": "/docs/current/",
    "stable_route": "/docs/v0.1.0/",
    "reserved_route": "/docs/v0.2.0/",
}
PRODUCTION_INPUTS = (
    "scripts/release_state.py", STATE_PATH,
    "scripts/compatibility/candidate_contract.py",
    "scripts/check_candidate_api_compatibility.py",
    "scripts/compatibility/test_candidate_contract.py",
    "scripts/compatibility/run_candidate_fixtures.py",
    "scripts/compatibility/test_public_api_compatibility.py",
    "scripts/test_release_state.py",
)


def strict_json(raw: bytes) -> object:
    def pairs(items):
        result = {}
        for key, value in items:
            if key in result:
                raise ValueError(f"duplicate release-state key: {key}")
            result[key] = value
        return result
    def invalid(value):
        raise ValueError(f"invalid release-state JSON constant: {value}")
    return json.loads(raw, object_pairs_hook=pairs, parse_constant=invalid)


def require_file(root: Path, relative: str) -> Path:
    path = root
    for part in Path(relative).parts:
        path /= part
        if path.is_symlink() or int(getattr(path.lstat(), "st_file_attributes", 0)) & 0x400:
            raise ValueError(f"redirected release-state input: {relative}")
    if not path.is_file():
        raise ValueError(f"missing release-state input: {relative}")
    return path


def load_state(root: Path = ROOT) -> dict:
    path = root / STATE_PATH
    if not path.exists() and not path.is_symlink():
        return {"phase": "historical", "retention": "not-applicable"}
    data = strict_json(require_file(root, STATE_PATH).read_bytes())
    if not isinstance(data, dict) or set(data) != set(FIXED) | {"phase", "retention"}:
        raise ValueError("candidate release state has missing or unknown fields")
    if any(data[key] != value for key, value in FIXED.items()):
        raise ValueError("candidate version/routes differ from the approved v0.2 contract")
    if not isinstance(data["phase"], str) or data["phase"] not in {"preparation", "candidate"}:
        raise ValueError("unsupported candidate metadata phase")
    if not isinstance(data["retention"], str) or data["retention"] not in {"pending", "established"}:
        raise ValueError("unsupported candidate retention disposition")
    if data["retention"] == "established" and data["phase"] != "candidate":
        raise ValueError("established retention requires unpublished candidate metadata")
    return data


def expected_package_version(state: dict) -> str:
    return TARGET_VERSION if state["phase"] == "candidate" else STABLE_VERSION


def contract_identity(root: Path = ROOT) -> dict:
    state = load_state(root)
    if state["phase"] == "historical":
        raise ValueError("candidate documentation requires an explicit candidate release state")
    package = tomllib.loads(require_file(root, "lakefile.toml").read_text(encoding="utf-8"))
    actual = package.get("version")
    if actual != expected_package_version(state):
        raise ValueError("package version does not match the explicit candidate metadata phase")
    return {
        "schema": IDENTITY_SCHEMA,
        "phase": state["phase"],
        "target_version": TARGET_VERSION,
        "package_version": actual,
        "current_route": state["current_route"],
        "stable_version": STABLE_VERSION,
        "stable_route": state["stable_route"],
        "reserved_route": state["reserved_route"],
        "publishable": False,
        "retention": state["retention"],
        "state_sha256": hashlib.sha256(require_file(root, STATE_PATH).read_bytes()).hexdigest(),
    }


def project_lakefile(raw: bytes, state: dict) -> bytes:
    """Permit exactly the reviewed version-line replacement, never other drift."""
    normalized = raw.replace(b"\r\n", b"\n")
    parsed = tomllib.loads(normalized.decode("utf-8"))
    expected = expected_package_version(state)
    if parsed.get("version") != expected:
        raise ValueError("unapproved package version for release state")
    if state["phase"] != "candidate":
        return normalized
    pattern = rb'(?m)^version = "0\.2\.0"$'
    if len(re.findall(pattern, normalized)) != 1:
        raise ValueError("candidate package version must use the exact reviewed metadata line")
    return re.sub(pattern, b'version = "0.1.0"', normalized, count=1)


def check_legacy_configuration(root: Path, baseline_release_source_sha256: dict) -> None:
    """Protect every original configuration byte after the one permitted projection."""
    if (root / "lakefile.lean").exists():
        raise ValueError("alternate effective Lake configuration")
    state = load_state(root)
    for relative in ("lean-toolchain", "lakefile.toml", "lake-manifest.json"):
        raw = require_file(root, relative).read_bytes().replace(b"\r\n", b"\n")
        if relative == "lakefile.toml":
            raw = project_lakefile(raw, state)
        if hashlib.sha256(raw).hexdigest() != baseline_release_source_sha256[relative]:
            raise ValueError(f"unapproved pinned build configuration change: {relative}")


def validation_inputs(root: Path = ROOT) -> tuple[str, ...]:
    """Outputs bind validation only, never their own producer fingerprint."""
    state = load_state(root)
    paths = ["scripts/release_state.py"]
    if state["phase"] != "historical":
        for relative in PRODUCTION_INPUTS:
            require_file(root, relative)
        paths = list(PRODUCTION_INPUTS)
        for relative in (CANDIDATE_CONTRACT_PATH, CANDIDATE_APPROVAL_PATH):
            path = root / relative
            if path.exists() or path.is_symlink():
                require_file(root, relative)
                paths.append(relative)
            elif state["retention"] == "established":
                raise ValueError(f"established candidate retention is missing {relative}")
    return tuple(paths)


def require_candidate_content(root: Path = ROOT) -> None:
    """Check future candidate Git content without reading/deleting the local file.

    The source tree decision is applied only by separately authorized Git work.
    Historical staging does not call this candidate-only guard.
    """
    result = subprocess.run(
        ["git", "ls-tree", "HEAD", "--", LOCAL_PRIVATE_PATH], cwd=root,
        capture_output=True, check=False,
    )
    if result.returncode:
        raise ValueError("cannot verify candidate Git-content exclusion")
    if result.stdout.strip():
        raise ValueError("candidate Git tree still contains the local private website-task file")


def expected_citation(state: dict) -> str:
    """The unpublished candidate has no issued date or DOI; historical data stays exact."""
    common = '''cff-version: 1.2.0
message: "If you use LeanInfoTheory in your work, please cite the software using this metadata."
type: software
title: "LeanInfoTheory"
'''
    if state["phase"] == "candidate":
        common = common.replace(
            'message: "If you use LeanInfoTheory in your work, please cite the software using this metadata."',
            'message: "Unpublished v0.2.0 candidate; cite the exact source checkpoint used."',
        )
        version = 'version: "0.2.0"\n'
    else:
        version = 'version: "0.1.0"\ndate-released: 2026-09-01\ndoi: "10.5281/zenodo.22229599"\n'
    return common + version + '''authors:
  - family-names: "Coban"
    given-names: "Serhat Emre"
    affiliation: "EPFL, Mathematics of Information Laboratory"
license: Apache-2.0
repository-code: "https://github.com/serhatemrecoban/LeanInfoTheory"
url: "https://serhatemrecoban.github.io/LeanInfoTheory/"
'''
