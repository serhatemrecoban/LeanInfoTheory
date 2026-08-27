#!/usr/bin/env python3
"""Run the maintained LeanInfoTheory release-validation contract.

The default command is the complete local suite.  Individual subcommands are
available so GitHub Actions and focused development can reuse the same target
list and the same deterministic trust checks.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
import time
import tomllib
from pathlib import Path
from typing import Iterable, Mapping, Sequence

import generate_website_api_index as api_index
import generate_website_blueprint as blueprint


ROOT = Path(__file__).resolve().parents[1]
PUBLIC_API_PATH = ROOT / "docs" / "v0.1-public-api.json"
RELEASE_NOTES_PATH = ROOT / "docs" / "releases" / "v0.1.0.md"
RELEASE_DOCUMENTATION_PHASE = "release-ready"
DOCBUILD_ROOT = ROOT / "docbuild"
DOCBUILD_OUTPUT = DOCBUILD_ROOT / ".lake" / "build"
DOCBUILD_CONFIG_STAMP = DOCBUILD_OUTPUT / "api-doc-build-config.json"
DOCBUILD_ATTESTATION = DOCBUILD_OUTPUT / "api-doc-build-attestation.json"
DOCGEN_REVISION = "e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015"
MATHLIB_REVISION = "0df444a360eaa60ab8c11dca51a86af692955474"
LEAN_REVISION = "819816b2e0a3bf405af45ae5c7af2491d8f5bee6"
WINDOWS_ZIG_SHA256 = "086ce9d47ba42f33a514e1a6e04eb1d4a8fa1d75e0868e0213caad447c91e864"
EXPECTED_GIT_ATTRIBUTES = b"* text=auto eol=lf\n"

EXPECTED_ROOT_GIT_PACKAGES = (
    (
        "mathlib",
        "https://github.com/leanprover-community/mathlib4",
        "leanprover-community",
        MATHLIB_REVISION,
        "v4.33.1",
        False,
        "lakefile.lean",
    ),
    (
        "plausible",
        "https://github.com/leanprover-community/plausible",
        "leanprover-community",
        "b7eb3304aeae834b12dda98993a37f6a41f6f0bb",
        "main",
        True,
        "lakefile.toml",
    ),
    (
        "LeanSearchClient",
        "https://github.com/leanprover-community/LeanSearchClient",
        "leanprover-community",
        "5f4d51b81cbd3f6b32b156bfad9056621a040404",
        "main",
        True,
        "lakefile.toml",
    ),
    (
        "importGraph",
        "https://github.com/leanprover-community/import-graph",
        "leanprover-community",
        "16f02aa7642864af59f1ff0e384a015994db9118",
        "main",
        True,
        "lakefile.toml",
    ),
    (
        "proofwidgets",
        "https://github.com/leanprover-community/ProofWidgets4",
        "leanprover-community",
        "4be2e3d5087eeb272cf5a8853b8f9dd025ef5957",
        "main",
        True,
        "lakefile.lean",
    ),
    (
        "aesop",
        "https://github.com/leanprover-community/aesop",
        "leanprover-community",
        "3448c0bcc5ce01b2d1546e483ec3620e32df3d0e",
        "master",
        True,
        "lakefile.toml",
    ),
    (
        "Qq",
        "https://github.com/leanprover-community/quote4",
        "leanprover-community",
        "92c15be17b7caf78c2ad767ec40f89052d908d81",
        "master",
        True,
        "lakefile.toml",
    ),
    (
        "batteries",
        "https://github.com/leanprover-community/batteries",
        "leanprover-community",
        "4488d40d070b9700d4d5a6aa342f0d40c31b2a2d",
        "main",
        True,
        "lakefile.toml",
    ),
    (
        "Cli",
        "https://github.com/leanprover/lean4-cli",
        "leanprover",
        "6130a47896ce867c6a4a55373441e59e565bad0f",
        "v4.33.0",
        True,
        "lakefile.toml",
    ),
)

EXPECTED_DOCBUILD_GIT_PACKAGES = {
    "«doc-gen4»": (
        "https://github.com/leanprover/doc-gen4",
        DOCGEN_REVISION,
    ),
    "mathlib": (
        "https://github.com/leanprover-community/mathlib4",
        MATHLIB_REVISION,
    ),
    "leansqlite": (
        "https://github.com/leanprover/leansqlite",
        "6168b7549738a19bc837a1625c60c5d1e5dd8aeb",
    ),
    "Cli": (
        "https://github.com/leanprover/lean4-cli",
        "6130a47896ce867c6a4a55373441e59e565bad0f",
    ),
    "UnicodeBasic": (
        "https://github.com/fgdorais/lean4-unicode-basic",
        "37e7d8cb7316a88cd3e91208385c9ec6ae780019",
    ),
    "BibtexQuery": (
        "https://github.com/dupuisf/BibtexQuery",
        "852edafa268eb038a7158551fd580ee8433847b0",
    ),
    "MD4Lean": (
        "https://github.com/acmepjz/md4lean",
        "31907cc18f48a95384f99cee5582c00fb39e0f67",
    ),
    "plausible": (
        "https://github.com/leanprover-community/plausible",
        "b7eb3304aeae834b12dda98993a37f6a41f6f0bb",
    ),
    "LeanSearchClient": (
        "https://github.com/leanprover-community/LeanSearchClient",
        "5f4d51b81cbd3f6b32b156bfad9056621a040404",
    ),
    "importGraph": (
        "https://github.com/leanprover-community/import-graph",
        "16f02aa7642864af59f1ff0e384a015994db9118",
    ),
    "proofwidgets": (
        "https://github.com/leanprover-community/ProofWidgets4",
        "4be2e3d5087eeb272cf5a8853b8f9dd025ef5957",
    ),
    "aesop": (
        "https://github.com/leanprover-community/aesop",
        "3448c0bcc5ce01b2d1546e483ec3620e32df3d0e",
    ),
    "Qq": (
        "https://github.com/leanprover-community/quote4",
        "92c15be17b7caf78c2ad767ec40f89052d908d81",
    ),
    "batteries": (
        "https://github.com/leanprover-community/batteries",
        "4488d40d070b9700d4d5a6aa342f0d40c31b2a2d",
    ),
}

EXPECTED_README_EXAMPLE_IDS = (
    "lightweight-root",
    "full-umbrella",
    "focused-channel",
    "nats-to-bits",
    "guarded-real-kl",
)

README_EXAMPLE_RE = re.compile(
    r"<!--\s*lean-example:(?P<id>[a-z0-9-]+)\s*-->\s*"
    r"```lean\s*\n(?P<source>[\s\S]*?)\n```"
)

EXPECTED_PACKAGE_METADATA = {
    "name": "LeanInfoTheory",
    "version": "0.1.0",
    "description": "A Lean 4 and mathlib library for finite discrete information theory",
    "keywords": ["math", "information-theory", "probability", "formal-verification"],
    "homepage": "https://serhatemrecoban.github.io/LeanInfoTheory/",
    "license": "Apache-2.0",
    "licenseFiles": ["LICENSE"],
    "defaultTargets": ["LeanInfoTheory"],
    "fixedToolchain": True,
}

APACHE_2_0_NORMALIZED_SHA256 = (
    "c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4"
)

MAINTAINED_TARGETS = (
    "LeanInfoTheory",
    "LeanInfoTheory.Shannon",
    "LeanInfoTheory.Shannon.EntropyBounds",
    "LeanInfoTheory.Shannon.Units",
    "LeanInfoTheory.Shannon.SemanticBridge",
    "LeanInfoTheory.Basic",
    "LeanInfoTheory.MathlibFragments",
    "LeanInfoTheory.Examples",
)

ALLOWED_AXIOMS = (
    "propext",
    "Classical.choice",
    "Quot.sound",
)

PROJECT_HEADER = """/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/"""

FORBIDDEN_LEAN_PATTERNS = (
    (
        "proof placeholder or unapproved declaration",
        re.compile(r"\b(?:sorry|admit|axiom|opaque|undefined)\b"),
    ),
    (
        "unsafe or partial declaration",
        re.compile(r"\b(?:unsafe|partial)\b"),
    ),
    (
        "external implementation hook",
        re.compile(r"\b(?:extern|implemented_by)\b|Lean\.ofReduceBool"),
    ),
    (
        "unapproved native or run tactic",
        re.compile(r"\b(?:native_decide|run_tac)\b"),
    ),
)

FORBIDDEN_RELEASE_WORKFLOW_PATTERNS = (
    re.compile(r"lean-release-tag", re.IGNORECASE),
    re.compile(r"\bdo-release\s*:\s*true\b", re.IGNORECASE),
    re.compile(r"\bgh\s+release\s+create\b", re.IGNORECASE),
    re.compile(r"\bhub\s+release\s+create\b", re.IGNORECASE),
    re.compile(r"actions/create-release", re.IGNORECASE),
    re.compile(r"softprops/action-gh-release", re.IGNORECASE),
    re.compile(r"\bgit\s+tag\b", re.IGNORECASE),
)

EXPECTED_WORKFLOWS = frozenset(
    {
        "lean_action_ci.yml",
        "pages.yml",
        "update.yml",
    }
)

# This normalized-content hash turns the Pages workflow into an explicitly
# reviewed publication interlock. Any edit, including a seemingly harmless
# trigger, permission, job, or guard change, requires a deliberate hash update.
EXPECTED_PAGES_WORKFLOW_SHA256 = (
    "4a7e426f5fdf61ffd428503ac9364efdece71a11b9df7354c00e963643ed407c"
)

TEXT_SUFFIXES = {
    ".cff",
    ".css",
    ".html",
    ".js",
    ".json",
    ".lean",
    ".md",
    ".py",
    ".toml",
    ".txt",
    ".yaml",
    ".yml",
}

SCRATCH_NAME_RE = re.compile(
    r"(?:^|/)(?:tmp|temp|scratch|probe)(?:[-_.][^/]*)?"
    r"\.(?:lean|py|txt|json)$",
    re.IGNORECASE,
)

class ValidationError(RuntimeError):
    """A maintained release gate failed."""


def is_redirected_path(path: Path) -> bool:
    if path.is_symlink():
        return True
    try:
        attributes = int(getattr(os.lstat(path), "st_file_attributes", 0))
    except FileNotFoundError:
        return False
    return bool(attributes & 0x400)


def check_docbuild_output_roots(*, require_doc: bool) -> None:
    doc_root = DOCBUILD_OUTPUT / "doc"
    roots = (DOCBUILD_ROOT / ".lake", DOCBUILD_OUTPUT, doc_root)
    for path in roots:
        if path.exists() and is_redirected_path(path):
            raise ValidationError(
                f"documentation build output root is redirected: {path.relative_to(ROOT)}"
            )
    if require_doc and not doc_root.is_dir():
        raise ValidationError(f"missing API documentation tree: {doc_root}")


def display_command(command: Sequence[str]) -> str:
    return shlex.join(str(part) for part in command)


def run_command(
    command: Sequence[str],
    *,
    input_text: str | None = None,
    capture_output: bool = False,
    label: str | None = None,
    cwd: Path = ROOT,
    env: Mapping[str, str | None] | None = None,
) -> subprocess.CompletedProcess[str]:
    rendered = display_command(command)
    try:
        relative_cwd = cwd.relative_to(ROOT).as_posix() or "."
    except ValueError:
        relative_cwd = str(cwd)
    prefix = "" if cwd == ROOT else f"[{relative_cwd}] "
    print(f"+ {prefix}{rendered}" + (f"  # {label}" if label else ""), flush=True)
    process_env = os.environ.copy()
    if env is not None:
        for key, value in env.items():
            if value is None:
                process_env.pop(key, None)
            else:
                process_env[key] = value
    result = subprocess.run(
        [str(part) for part in command],
        cwd=cwd,
        env=process_env,
        input=input_text,
        text=True,
        encoding="utf-8",
        capture_output=capture_output,
        check=False,
    )
    if result.returncode != 0:
        if capture_output:
            if result.stdout:
                print(result.stdout, end="", file=sys.stderr)
            if result.stderr:
                print(result.stderr, end="", file=sys.stderr)
        suffix = f" ({label})" if label else ""
        raise ValidationError(
            f"command failed with exit code {result.returncode}{suffix}: {rendered}"
        )
    return result


def lean_files() -> list[Path]:
    return [
        ROOT / "LeanInfoTheory.lean",
        *sorted((ROOT / "LeanInfoTheory").rglob("*.lean")),
        DOCBUILD_ROOT / "CCShim.lean",
    ]


def check_lean_source() -> None:
    errors: list[str] = []
    files = lean_files()
    for path in files:
        source = path.read_text(encoding="utf-8")
        rel = path.relative_to(ROOT).as_posix()
        if not source.startswith(PROJECT_HEADER + "\n"):
            errors.append(f"{rel}: missing or non-exact EPFL/MIL project header")
        for line_number, line in enumerate(source.splitlines(), start=1):
            for label, pattern in FORBIDDEN_LEAN_PATTERNS:
                if pattern.search(line):
                    errors.append(f"{rel}:{line_number}: {label}: {line.strip()}")

    if errors:
        raise ValidationError("Lean source trust scan failed:\n" + "\n".join(errors))
    print(
        f"Lean source trust scan passed for {len(files)} files "
        "(headers, placeholders, unsafe hooks, and tactic shortcuts)"
    )


def check_toolchain_contract() -> None:
    toolchain = (ROOT / "lean-toolchain").read_text(encoding="utf-8").strip()
    match = re.fullmatch(r"leanprover/lean4:(v\d+\.\d+\.\d+)", toolchain)
    if match is None:
        raise ValidationError(f"unexpected lean-toolchain format: {toolchain!r}")
    release = match.group(1)

    lakefile = (ROOT / "lakefile.toml").read_text(encoding="utf-8")
    mathlib_match = re.search(
        r"\[\[require\]\]\s*"
        r"name\s*=\s*\"mathlib\"[\s\S]*?"
        r"rev\s*=\s*\"([^\"]+)\"",
        lakefile,
    )
    if mathlib_match is None:
        raise ValidationError("could not locate the mathlib revision in lakefile.toml")
    if mathlib_match.group(1) != release:
        raise ValidationError(
            "Lean/mathlib release mismatch: "
            f"lean-toolchain={release}, lakefile mathlib={mathlib_match.group(1)}"
        )

    manifest = json.loads((ROOT / "lake-manifest.json").read_text(encoding="utf-8"))
    mathlib_packages = [
        package for package in manifest.get("packages", []) if package.get("name") == "mathlib"
    ]
    if len(mathlib_packages) != 1:
        raise ValidationError(
            f"expected one mathlib package in lake-manifest.json, found {len(mathlib_packages)}"
        )
    mathlib = mathlib_packages[0]
    if mathlib.get("inputRev") != release:
        raise ValidationError(
            "lake-manifest.json is stale for the frozen mathlib input revision: "
            f"expected {release}, found {mathlib.get('inputRev')!r}"
        )
    if not re.fullmatch(r"[0-9a-f]{40}", str(mathlib.get("rev", ""))):
        raise ValidationError("mathlib manifest revision is not an exact 40-character commit")
    print(
        f"toolchain contract passed: Lean/mathlib {release}, "
        f"mathlib commit {mathlib['rev']}"
    )


def check_docbuild_contract() -> None:
    errors: list[str] = []
    lakefile_path = DOCBUILD_ROOT / "lakefile.toml"
    manifest_path = DOCBUILD_ROOT / "lake-manifest.json"
    ignore_path = DOCBUILD_ROOT / ".gitignore"
    for path in (lakefile_path, manifest_path, ignore_path, DOCBUILD_ROOT / "README.md"):
        if not path.is_file():
            errors.append(f"missing isolated documentation-build file: {path.relative_to(ROOT)}")
    if errors:
        raise ValidationError("documentation-build contract failed:\n" + "\n".join(errors))

    lakefile = tomllib.loads(lakefile_path.read_text(encoding="utf-8"))
    expected_top_level = {
        "name",
        "version",
        "reservoir",
        "packagesDir",
        "fixedToolchain",
        "require",
    }
    if set(lakefile) != expected_top_level:
        errors.append(
            "docbuild/lakefile.toml keys differ from the isolated build contract: "
            f"expected {sorted(expected_top_level)}, found {sorted(lakefile)}"
        )
    expected_scalars = {
        "name": "docbuild",
        "version": "0.1.0",
        "reservoir": False,
        "packagesDir": "../.lake/packages",
        "fixedToolchain": True,
    }
    for key, expected in expected_scalars.items():
        if lakefile.get(key) != expected:
            errors.append(
                f"docbuild/lakefile.toml {key}: expected {expected!r}, "
                f"found {lakefile.get(key)!r}"
            )
    expected_requirements = [
        {"scope": "leanprover", "name": "doc-gen4", "rev": "v4.33.1"},
        {"name": "LeanInfoTheory", "path": "../"},
    ]
    if lakefile.get("require") != expected_requirements:
        errors.append(
            "docbuild requirements must be exactly pinned doc-gen4 plus the parent path package"
        )
    doc_toolchain = (DOCBUILD_ROOT / "lean-toolchain").read_text(encoding="utf-8").strip()
    root_toolchain = (ROOT / "lean-toolchain").read_text(encoding="utf-8").strip()
    if doc_toolchain != root_toolchain or doc_toolchain != "leanprover/lean4:v4.33.1":
        errors.append(
            "docbuild/lean-toolchain must duplicate the exact fixed root v4.33.1 pin"
        )
    if ignore_path.read_text(encoding="utf-8").replace("\r\n", "\n") != "/.lake/\n":
        errors.append("docbuild/.gitignore must ignore exactly the nested /.lake/ directory")

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    expected_manifest_scalars = {
        "version": "1.2.0",
        "packagesDir": "../.lake/packages",
        "name": "docbuild",
        "lakeDir": ".lake",
        "fixedToolchain": True,
    }
    for key, expected in expected_manifest_scalars.items():
        if manifest.get(key) != expected:
            errors.append(
                f"docbuild/lake-manifest.json {key}: expected {expected!r}, "
                f"found {manifest.get(key)!r}"
            )
    packages = list(manifest.get("packages", []))
    path_packages = [package for package in packages if package.get("type") == "path"]
    expected_path_package = {
        "type": "path",
        "scope": "",
        "name": "LeanInfoTheory",
        "manifestFile": "lake-manifest.json",
        "inherited": False,
        "dir": "../",
        "configFile": "lakefile.toml",
    }
    if path_packages != [expected_path_package]:
        errors.append(
            "docbuild manifest must contain exactly one parent LeanInfoTheory path dependency"
        )
    git_packages = [package for package in packages if package.get("type") == "git"]
    actual_git_names = {str(package.get("name")) for package in git_packages}
    if actual_git_names != set(EXPECTED_DOCBUILD_GIT_PACKAGES):
        errors.append(
            "docbuild Git package set differs from the reviewed lock: "
            f"expected {sorted(EXPECTED_DOCBUILD_GIT_PACKAGES)}, "
            f"found {sorted(actual_git_names)}"
        )
    for package in git_packages:
        name = str(package.get("name"))
        expected = EXPECTED_DOCBUILD_GIT_PACKAGES.get(name)
        if expected is None:
            continue
        url, revision = expected
        if package.get("url") != url or package.get("rev") != revision:
            errors.append(
                f"docbuild package {name}: expected {url}@{revision}, "
                f"found {package.get('url')}@{package.get('rev')}"
            )
        if re.fullmatch(r"[0-9a-f]{40}", str(package.get("rev", ""))) is None:
            errors.append(f"docbuild package {name} is not locked to a full commit")
        if not str(package.get("url", "")).startswith("https://github.com/"):
            errors.append(f"docbuild package {name} does not use a reviewed HTTPS origin")
    if len(packages) != 1 + len(EXPECTED_DOCBUILD_GIT_PACKAGES):
        errors.append(
            f"docbuild manifest must contain 15 packages, found {len(packages)}"
        )

    root_lakefile = (ROOT / "lakefile.toml").read_text(encoding="utf-8")
    root_manifest = json.loads((ROOT / "lake-manifest.json").read_text(encoding="utf-8"))
    root_names = {str(package.get("name")) for package in root_manifest.get("packages", [])}
    if "doc-gen4" in root_lakefile or "«doc-gen4»" in root_names:
        errors.append("doc-gen4 leaked into the downstream runtime dependency graph")
    if errors:
        raise ValidationError("documentation-build contract failed:\n" + "\n".join(errors))
    print(
        "isolated documentation-build contract passed: doc-gen4 v4.33.1 at "
        f"{DOCGEN_REVISION}, 14 exact Git pins, root runtime graph unchanged"
    )


def normalized_sha256(path: Path) -> str:
    content = path.read_bytes().replace(b"\r\n", b"\n")
    return hashlib.sha256(content).hexdigest()


def raw_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def check_release_metadata() -> None:
    errors: list[str] = []
    attributes_path = ROOT / ".gitattributes"
    if not attributes_path.is_file():
        errors.append(".gitattributes is missing")
    elif attributes_path.read_bytes() != EXPECTED_GIT_ATTRIBUTES:
        errors.append(
            ".gitattributes must contain exactly '* text=auto eol=lf' with an LF newline"
        )

    toolchain = (ROOT / "lean-toolchain").read_text(encoding="utf-8").strip()
    if toolchain != "leanprover/lean4:v4.33.1":
        errors.append(
            "lean-toolchain must remain leanprover/lean4:v4.33.1 for the "
            f"fixed release package, found {toolchain!r}"
        )
    lakefile = tomllib.loads((ROOT / "lakefile.toml").read_text(encoding="utf-8"))
    for key, expected in EXPECTED_PACKAGE_METADATA.items():
        actual = lakefile.get(key)
        if actual != expected:
            errors.append(f"lakefile.toml {key}: expected {expected!r}, found {actual!r}")

    if lakefile.get("readmeFile", "README.md") != "README.md":
        errors.append("lakefile.toml must expose README.md as the package README")
    if lakefile.get("reservoir", True) is not True:
        errors.append("lakefile.toml must leave Reservoir indexing enabled")

    requirements = lakefile.get("require", [])
    expected_requirement = {
        "name": "mathlib",
        "scope": "leanprover-community",
        "rev": "v4.33.1",
    }
    if requirements != [expected_requirement]:
        errors.append(
            "lakefile.toml must contain exactly the frozen mathlib requirement: "
            f"expected {[expected_requirement]!r}, found {requirements!r}"
        )
    if lakefile.get("lean_lib") != [{"name": "LeanInfoTheory"}]:
        errors.append(
            "lakefile.toml must expose exactly one Lean library named LeanInfoTheory"
        )

    manifest = json.loads((ROOT / "lake-manifest.json").read_text(encoding="utf-8"))
    expected_manifest_scalars = {
        "version": "1.2.0",
        "packagesDir": ".lake/packages",
        "name": "LeanInfoTheory",
        "lakeDir": ".lake",
        "fixedToolchain": True,
    }
    if set(manifest) != {*expected_manifest_scalars, "packages"}:
        errors.append(
            "lake-manifest.json keys differ from the reviewed root lock: "
            f"found {sorted(manifest)}"
        )
    for key, expected in expected_manifest_scalars.items():
        if manifest.get(key) != expected:
            errors.append(
                f"lake-manifest.json {key}: expected {expected!r}, "
                f"found {manifest.get(key)!r}"
            )

    packages = manifest.get("packages")
    if not isinstance(packages, list):
        errors.append("lake-manifest.json packages must be a list")
        packages = []
    elif not all(isinstance(package, dict) for package in packages):
        errors.append("lake-manifest.json packages must contain only objects")
        packages = []
    expected_package_names = [package[0] for package in EXPECTED_ROOT_GIT_PACKAGES]
    actual_package_names = [str(package.get("name")) for package in packages]
    if actual_package_names != expected_package_names:
        errors.append(
            "root runtime package order/set differs from the reviewed nine-package lock: "
            f"expected {expected_package_names!r}, found {actual_package_names!r}"
        )
    for index, expected in enumerate(EXPECTED_ROOT_GIT_PACKAGES):
        if index >= len(packages):
            break
        name, url, scope, revision, input_revision, inherited, config_file = expected
        expected_package = {
            "url": url,
            "type": "git",
            "subDir": None,
            "scope": scope,
            "rev": revision,
            "name": name,
            "manifestFile": "lake-manifest.json",
            "inputRev": input_revision,
            "inherited": inherited,
            "configFile": config_file,
        }
        if packages[index] != expected_package:
            errors.append(
                f"root runtime package {name} differs from the reviewed lock: "
                f"found {packages[index]!r}"
            )

    license_hash = normalized_sha256(ROOT / "LICENSE")
    if license_hash != APACHE_2_0_NORMALIZED_SHA256:
        errors.append(
            "LICENSE does not match the reviewed canonical Apache-2.0 text: "
            f"expected {APACHE_2_0_NORMALIZED_SHA256}, found {license_hash}"
        )

    citation = (ROOT / "CITATION.cff").read_text(encoding="utf-8")
    expected_citation = """cff-version: 1.2.0
message: "If you use LeanInfoTheory in your work, please cite the software using this metadata."
type: software
title: "LeanInfoTheory"
version: "0.1.0"
date-released: 2026-08-27
authors:
  - family-names: "Coban"
    given-names: "Serhat Emre"
    affiliation: "EPFL, Mathematics of Information Laboratory"
license: Apache-2.0
repository-code: "https://github.com/serhatemrecoban/LeanInfoTheory"
url: "https://serhatemrecoban.github.io/LeanInfoTheory/"
"""
    if citation != expected_citation:
        errors.append(
            "CITATION.cff differs from the exact approved canonical dated template"
        )
    citation_markers = (
        "cff-version: 1.2.0",
        "type: software",
        'title: "LeanInfoTheory"',
        'version: "0.1.0"',
        "date-released: 2026-08-27",
        'family-names: "Coban"',
        'given-names: "Serhat Emre"',
        'affiliation: "EPFL, Mathematics of Information Laboratory"',
        "license: Apache-2.0",
        'repository-code: "https://github.com/serhatemrecoban/LeanInfoTheory"',
        'url: "https://serhatemrecoban.github.io/LeanInfoTheory/"',
    )
    for marker in citation_markers:
        if marker not in citation:
            errors.append(f"CITATION.cff is missing the reviewed field: {marker}")
    expected_author_block = """authors:
  - family-names: "Coban"
    given-names: "Serhat Emre"
    affiliation: "EPFL, Mathematics of Information Laboratory"
license: Apache-2.0"""
    if expected_author_block not in citation:
        errors.append("CITATION.cff software-author block differs from the sole reviewed author")
    if len(re.findall(r"(?m)^\s+- family-names:", citation)) != 1:
        errors.append("CITATION.cff must contain exactly one software author")
    release_dates = re.findall(r"(?m)^\s*date-released\s*:\s*(.*?)\s*$", citation)
    if release_dates != ["2026-08-27"]:
        errors.append(
            "CITATION.cff must contain exactly one date-released value: 2026-08-27"
        )
    if re.search(r"(?m)^\s*doi\s*:", citation, re.IGNORECASE):
        errors.append("CITATION.cff DOI must remain absent under the approved post-release route")
    if re.search(r"(?mi)^\s*type\s*:\s*doi\s*$", citation):
        errors.append("CITATION.cff DOI identifier must remain absent under the approved post-release route")

    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    readme_flat = " ".join(readme.split())
    readme_markers = (
        "## AI-assisted development",
        "has been developed with extensive assistance from AI coding agents",
        "does not claim that its Lean proof code was written manually",
        "Lean's kernel checks that accepted formal declarations follow from their",
        "LeanInfoTheory is an EPFL research software project from the Mathematics of Information Laboratory",
        "authored and led by Serhat Emre Coban",
        "École polytechnique fédérale de Lausanne (EPFL), the project rights holder",
        "approved automatic post-release GitHub--Zenodo route",
        "`CITATION.cff` remains the canonical repository metadata source; no `.zenodo.json` is used",
        "will be recorded as `RightsHolder` directly in Zenodo after ingestion",
        "tagged `CITATION.cff` and immutable GitHub Release will intentionally contain no DOI",
        "Its approved `date-released` value is `2026-08-27`",
        "[CITATION.cff](CITATION.cff)",
    )
    for marker in readme_markers:
        if marker not in readme_flat:
            errors.append(f"README.md is missing required release metadata: {marker}")

    release_surfaces = (
        ROOT / "README.md",
        ROOT / "CITATION.cff",
        ROOT / "docs" / "releases" / "v0.1.0.md",
        ROOT / "docs" / "v0.1-release-contract.md",
        ROOT / "docs" / "v0.1-legal-metadata-audit.md",
        ROOT / "home_page" / "index.html",
        ROOT / "home_page" / "license.html",
        ROOT / "home_page" / "docs" / "third-party.html",
    )
    approval_claim = re.compile(r"approved by\s+(?:EPFL|MIL|EPFL TTO)", re.IGNORECASE)
    for path in release_surfaces:
        if approval_claim.search(path.read_text(encoding="utf-8")):
            errors.append(
                f"{path.relative_to(ROOT).as_posix()} contains an unapproved institutional claim"
            )

    decision_surface_markers = {
        ROOT / "docs" / "v0.1-release-contract.md": (
            "the rights holder is École polytechnique fédérale de Lausanne (EPFL)",
            "the software-author affiliation is `EPFL, Mathematics of Information Laboratory`",
            "The approved Zenodo route is automatic post-release GitHub ingestion.",
            "no `.zenodo.json` is added",
            "tagged CFF remain DOI-free",
            "The approved `date-released` value is `2026-08-27`",
            "Step 14 is complete",
            "Step 15 safety landing and reconciliation",
            "81ffef37402909481c5dea51a42973dee9a79ae6",
            "f0d06dfab4f411ced312294e63e96bb67bba859b",
            "Immutable GitHub Releases was not enabled",
            "nonpublishing preflight of the correct GitHub account/repository's Zenodo integration state",
            "an agent must not create an account or alter the integration without explicit authorization",
            "Before accepting the ingested Zenodo record, verify its software type",
            "as a contributor of type `RightsHolder`",
        ),
        ROOT / "docs" / "v0.1-legal-metadata-audit.md": (
            "Step 14 complete; publication date `2026-08-27`",
            "creator/software author: Serhat Emre Coban",
            "affiliation: `EPFL, Mathematics of Information Laboratory`",
            "rights holder: École polytechnique fédérale de Lausanne (EPFL)",
            "The approved deposit route is automatic post-release GitHub--Zenodo ingestion.",
            "`.zenodo.json` remains absent",
            "tagged CFF intentionally remain DOI-free",
            "This closes the sole remaining Step 14 decision",
            "Step 15 publication-safety record",
            "immutable GitHub Releases was not enabled",
            "This audit authorizes no publication",
            "deliberately not encoded in the tagged source snapshot",
        ),
        ROOT / "docs" / "current-lean-state.md": (
            "Release-preparation Step 14 — complete",
            "Step 14 is complete",
            "`v0.1.0` release-candidate source state",
            "Exact candidate identity, remote run identifiers, clean-checkout and external-consumer evidence",
            "This source snapshot neither authorizes nor asserts publication",
            "81ffef37402909481c5dea51a42973dee9a79ae6",
            "f0d06dfab4f411ced312294e63e96bb67bba859b",
        ),
        ROOT / "docs" / "lean-info-theory-living-summary.md": (
            "The source effects of release-preparation Steps 1–16 are incorporated in this snapshot",
            "Exact candidate identity, remote validation evidence, the Step 17 verdict, and live publication state are external records",
            "no Zenodo account or integration action is performed by an agent",
        ),
        ROOT / "docs" / "roadmap.md": (
            "Release-candidate source preparation is represented in this snapshot",
            "this tracked roadmap does not claim them",
        ),
        ROOT / "docs" / "next-website-tasks.md": (
            "Release publication controls",
            "No tracked website text asserts that a GitHub Release, Pages deployment, Zenodo record, or DOI exists",
        ),
        ROOT / "home_page" / "license.html": (
            "Serhat Emre Coban is the author, software creator, and project lead",
            "polytechnique fédérale de Lausanne (EPFL) is the project rights holder",
            "approved automatic post-release GitHub--Zenodo route",
            "tagged CFF remains DOI-free",
            "The approved release date is <code>2026-08-27</code>",
        ),
    }
    for path, markers in decision_surface_markers.items():
        source_flat = " ".join(path.read_text(encoding="utf-8").split())
        for marker in markers:
            if marker not in source_flat:
                errors.append(
                    f"{path.relative_to(ROOT).as_posix()} is missing a reviewed release decision/status marker: {marker}"
                )

    if (ROOT / "NOTICE").exists():
        errors.append("NOTICE exists without a reviewed attribution requirement")
    if (ROOT / ".zenodo.json").exists():
        errors.append(".zenodo.json must remain absent under the canonical-CFF Zenodo route")

    if errors:
        raise ValidationError("package/legal metadata failed:\n" + "\n".join(errors))
    print(
        "package/legal metadata passed: LeanInfoTheory 0.1.0, fixed Lean/mathlib "
        "v4.33.1, Apache-2.0, sole CFF author, canonical CFF/post-release DOI route, "
        "release date 2026-08-27; Steps 14-15 complete and release documentation ready"
    )


def markdown_heading_anchors(path: Path) -> set[str]:
    anchors: set[str] = set()
    duplicates: dict[str, int] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = re.match(r"^#{1,6}\s+(.+?)\s*#*\s*$", line)
        if match is None:
            continue
        heading = re.sub(r"<[^>]+>", "", match.group(1))
        heading = re.sub(r"[`*_~]", "", heading).lower()
        slug = re.sub(r"[^\w\s-]", "", heading, flags=re.UNICODE)
        slug = re.sub(r"\s+", "-", slug.strip())
        count = duplicates.get(slug, 0)
        duplicates[slug] = count + 1
        anchors.add(slug if count == 0 else f"{slug}-{count}")
    return anchors


def check_local_markdown_links(paths: Sequence[Path]) -> None:
    errors: list[str] = []
    link_re = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")
    for path in paths:
        source = path.read_text(encoding="utf-8")
        for target in link_re.findall(source):
            target = target.strip().strip("<>")
            if re.match(r"^[a-z][a-z0-9+.-]*:", target, re.IGNORECASE):
                continue
            relative, separator, anchor = target.partition("#")
            destination = path if not relative else path.parent / relative
            destination = destination.resolve()
            try:
                destination.relative_to(ROOT.resolve())
            except ValueError:
                errors.append(
                    f"{path.relative_to(ROOT).as_posix()}: link escapes the repository: {target}"
                )
                continue
            if not destination.is_file():
                errors.append(
                    f"{path.relative_to(ROOT).as_posix()}: missing local link target: {target}"
                )
                continue
            if separator and destination.suffix.lower() == ".md":
                if anchor not in markdown_heading_anchors(destination):
                    errors.append(
                        f"{path.relative_to(ROOT).as_posix()}: missing Markdown anchor: {target}"
                    )
    if errors:
        raise ValidationError("release-documentation link check failed:\n" + "\n".join(errors))
    print(f"release-documentation local links passed across {len(paths)} files")


def read_readme_examples() -> list[tuple[str, str]]:
    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    examples = [
        (match.group("id"), match.group("source") + "\n")
        for match in README_EXAMPLE_RE.finditer(readme)
    ]
    ids = [example_id for example_id, _ in examples]
    if ids != list(EXPECTED_README_EXAMPLE_IDS):
        raise ValidationError(
            "README compiling-example contract changed: "
            f"expected {list(EXPECTED_README_EXAMPLE_IDS)!r}, found {ids!r}"
        )
    lean_fence_count = len(re.findall(r"(?m)^```lean\s*$", readme))
    if lean_fence_count != len(examples):
        raise ValidationError(
            "every README Lean fence must have one unique maintained lean-example marker: "
            f"found {lean_fence_count} fences and {len(examples)} marked examples"
        )
    for example_id, source in examples:
        if not source.lstrip().startswith("import "):
            raise ValidationError(
                f"README example {example_id!r} must be independently importable"
            )
    return examples


def check_release_documentation_contract() -> None:
    if RELEASE_DOCUMENTATION_PHASE != "release-ready":
        raise ValidationError(
            "release-documentation phase must be 'release-ready' for the v0.1.0 candidate"
        )
    readme_path = ROOT / "README.md"
    readme = readme_path.read_text(encoding="utf-8")
    readme_markers = (
        "## Installation",
        "leanprover/lean4:v4.33.1",
        'name = "LeanInfoTheory"',
        'git = "https://github.com/serhatemrecoban/LeanInfoTheory"',
        'rev = "v0.1.0"',
        "## Release",
        "`v0.1.0` is the first public-library release of LeanInfoTheory",
        "## Five-minute quick start",
        "## Choosing imports",
        "## Supported mathematical scope",
        "## Mathematical conventions and limitations",
        "## Compatibility policy",
        "## Reproducing maintained builds",
        "Python 3.11 or newer",
        "## Controlled release procedure",
        "python scripts/validate_release.py documentation",
        "docs/releases/v0.1.0.md",
        "ordinary branch pushes cannot",
        "create a tag, GitHub Release, or Pages deployment",
        "enable and verify immutable GitHub Releases",
    )
    errors = [
        f"README.md is missing the release-documentation marker: {marker}"
        for marker in readme_markers
        if marker not in readme
    ]

    if not RELEASE_NOTES_PATH.is_file():
        errors.append("docs/releases/v0.1.0.md is missing")
        release_notes = ""
    else:
        release_notes = RELEASE_NOTES_PATH.read_text(encoding="utf-8")
    release_notes_flat = " ".join(
        re.sub(r"(?m)^>\s?", "", release_notes).split()
    )
    release_note_markers = (
        "# LeanInfoTheory v0.1.0",
        "Release date: **2026-08-27**",
        "`v0.1.0` is the first public-library release of LeanInfoTheory",
        "automatic post-release GitHub--Zenodo route",
        "tagged CFF and immutable GitHub Release DOI-free",
        "## Information units",
        "## Certificate boundary",
        "## Compatibility, installation, and imports",
        "## Validation and trust",
        "reproduced from a clean exact checkout and compiled through a minimal external Lake consumer",
        "Release-mode staging binds project source links to the exact release commit",
        "does not claim a manual line-by-line audit",
        "## AI-assisted development",
        "Development used substantial AI coding-agent assistance",
        "AI-generated code is treated as untrusted",
        "Human responsibility remains for",
        "## Authorship, license, and citation",
        "Serhat Emre Coban is the author, software creator, and project lead, affiliated "
        "with EPFL, Mathematics of Information Laboratory.",
        "École polytechnique fédérale de Lausanne (EPFL) is the rights holder.",
        "Apache-2.0",
        "CITATION.cff",
    )
    errors.extend(
        f"docs/releases/v0.1.0.md is missing the release marker: {marker}"
        for marker in release_note_markers
        if marker not in release_notes_flat
    )

    approval_claim = re.compile(r"approved by\s+(?:EPFL|MIL|EPFL TTO)", re.IGNORECASE)
    for path, source in ((readme_path, readme), (RELEASE_NOTES_PATH, release_notes)):
        if approval_claim.search(source):
            errors.append(
                f"{path.relative_to(ROOT).as_posix()} contains an unapproved institutional claim"
            )

    release_facing_paths = (
        readme_path,
        RELEASE_NOTES_PATH,
        ROOT / "home_page" / "index.html",
        ROOT / "home_page" / "docs" / "index.html",
        ROOT / "home_page" / "docs" / "v0.1.0" / "index.html",
        ROOT / "home_page" / "docs" / "v0.1.0" / "licenses" / "index.html",
        ROOT / "home_page" / "docs" / "third-party.html",
        ROOT / "home_page" / "module-guide.html",
        ROOT / "home_page" / "roadmap.html",
        ROOT / "home_page" / "license.html",
        ROOT / "docs" / "v0.1-release-contract.md",
        ROOT / "docs" / "current-lean-state.md",
        ROOT / "docs" / "lean-info-theory-living-summary.md",
        ROOT / "docs" / "roadmap.md",
        ROOT / "docs" / "next-website-tasks.md",
        ROOT / "docs" / "v0.1-legal-metadata-audit.md",
        ROOT / "blueprint" / "README.md",
    )
    obsolete_markers = (
        "the `v0.1.0` tag does not exist yet",
        "# LeanInfoTheory v0.1.0 — draft release notes",
        "**Pre-release draft.**",
        "not an exact committed candidate",
        "has not yet been published",
        "local pre-release preview",
        "Step 15 is next",
        "Step 15 will separately land",
        "Step 16 must rebuild",
        "No DOI is claimed on this preview site",
        "No generated tree has been published",
        "served-preview gate",
        "This baseline is not committed or pushed",
        "locally; not committed or pushed",
        "Commit `1eef228` remains the last validated committed pre-separation state",
        "current generated state is local and has not been committed, pushed, or deployed",
        "staging that output into the website remains release work",
        "website staging and exact-commit publication links pending",
        "Release-preparation Step 15 — complete; Step 16 candidate qualification",
        "Steps 1–15 are complete",
        "Step 16 exact-candidate qualification is current",
        "Step 16 is current. Freeze one exact candidate",
        "the accumulated candidate is reconciled locally at",
        "Step 16 qualification, Step 17 independent dry run",
        "Step 16 candidate qualification, Step 17 independent review",
        "Step 16 converts every current-facing release surface",
        "Step 16 measures GitHub runner and Pages behavior",
        "Step 16 owns the exact release-candidate commit",
        "Current gate: **Step 16",
    )
    for path in release_facing_paths:
        source = " ".join(path.read_text(encoding="utf-8").split())
        for marker in obsolete_markers:
            if marker in source:
                errors.append(
                    f"{path.relative_to(ROOT).as_posix()} retains obsolete release-state text: {marker}"
                )

    if errors:
        raise ValidationError("release-documentation contract failed:\n" + "\n".join(errors))
    examples = read_readme_examples()
    check_local_markdown_links((readme_path, RELEASE_NOTES_PATH))
    print(
        "release-documentation contract passed: tagged dependency guidance, scope, "
        f"units, limitations, compatibility, {RELEASE_DOCUMENTATION_PHASE} notes, "
        f"and {len(examples)} marked examples"
    )


def check_documentation_examples() -> None:
    examples = read_readme_examples()
    for index, (example_id, source) in enumerate(examples, start=1):
        run_command(
            ("lake", "env", "lean", "-DwarningAsError=true", "--stdin"),
            input_text=source,
            capture_output=True,
            label=f"README example {index}/{len(examples)}: {example_id}",
        )
    print(f"independently compiled {len(examples)} README examples with warnings as errors")


def check_release_interlock() -> None:
    automatic_release = ROOT / ".github" / "workflows" / "create-release.yml"
    if automatic_release.exists():
        raise ValidationError(
            ".github/workflows/create-release.yml must remain absent; it can publish a release "
            "when lean-toolchain changes"
        )

    hits: list[str] = []
    mutable_actions: list[str] = []
    action_count = 0
    uses_re = re.compile(r"^\s*(?:-\s*)?uses:\s*([^\s#]+)")
    workflow_dir = ROOT / ".github" / "workflows"
    workflows = sorted(workflow_dir.glob("*.yml")) + sorted(workflow_dir.glob("*.yaml"))
    workflow_names = {path.name for path in workflows}
    if workflow_names != EXPECTED_WORKFLOWS:
        raise ValidationError(
            "workflow set changed and requires explicit release-safety review: "
            f"expected {sorted(EXPECTED_WORKFLOWS)}, found {sorted(workflow_names)}"
        )
    for path in workflows:
        source = path.read_text(encoding="utf-8")
        for pattern in FORBIDDEN_RELEASE_WORKFLOW_PATTERNS:
            if pattern.search(source):
                hits.append(f"{path.relative_to(ROOT).as_posix()}: {pattern.pattern}")
        for line_number, line in enumerate(source.splitlines(), start=1):
            match = uses_re.match(line)
            if match is None:
                continue
            action = match.group(1).strip("'\"")
            if action.startswith("./") or action.startswith("docker://"):
                continue
            action_count += 1
            _, separator, revision = action.rpartition("@")
            if not separator or re.fullmatch(r"[0-9a-f]{40}", revision) is None:
                mutable_actions.append(
                    f"{path.relative_to(ROOT).as_posix()}:{line_number}: {action}"
                )

    pages_path = workflow_dir / "pages.yml"
    pages = pages_path.read_text(encoding="utf-8")
    pages_digest = hashlib.sha256(pages.encode("utf-8")).hexdigest()
    if pages_digest != EXPECTED_PAGES_WORKFLOW_SHA256:
        hits.append(
            ".github/workflows/pages.yml changed from the reviewed manual-publication "
            "shape; perform an explicit release-safety review and update "
            f"EXPECTED_PAGES_WORKFLOW_SHA256 ({pages_digest})"
        )
    pages_markers = (
        "workflow_dispatch:",
        "publish:",
        "default: false",
        "if: ${{ inputs.publish }}",
        "python scripts/stage_website.py release",
        "--mode publishable",
        "path: .lake/website-stage/LeanInfoTheory",
        "actions/upload-pages-artifact@7b1f4a764d45c48632c6b24a0339c27f5614fb0b",
    )
    for marker in pages_markers:
        if marker not in pages:
            hits.append(f".github/workflows/pages.yml: missing manual Pages marker {marker!r}")
    if re.search(r"(?m)^\s{2}push\s*:", pages):
        hits.append(".github/workflows/pages.yml: Pages publication must not have a push trigger")
    if "enablement: true" in pages:
        hits.append(".github/workflows/pages.yml: Pages must not be enabled implicitly")
    if hits:
        raise ValidationError(
            "workflow release-safety interlock failed:\n" + "\n".join(hits)
        )
    if mutable_actions:
        raise ValidationError(
            "workflow actions must use immutable full-commit references:\n"
            + "\n".join(mutable_actions)
        )
    print(
        f"release-safety interlock and {action_count} immutable action references "
        f"passed across {len(workflows)} workflows; Pages shape {pages_digest}"
    )


def check_generated_artifacts() -> None:
    commands = (
        (sys.executable, "scripts/generate_v0_1_public_api.py", "--check"),
        (sys.executable, "scripts/generate_website_blueprint.py", "--check"),
        (sys.executable, "scripts/generate_website_api_index.py", "--check"),
    )
    for pass_number in (1, 2):
        for command in commands:
            run_command(command, label=f"generated-artifact check pass {pass_number}")
    run_command((sys.executable, "scripts/check_website.py", "--mode", "source"))
    print("generated artifact text is current on two independent render passes")


def candidate_text_paths() -> list[Path]:
    result = run_command(
        ("git", "ls-files", "-co", "--exclude-standard"),
        capture_output=True,
    )
    paths: list[Path] = []
    for raw in result.stdout.splitlines():
        path = ROOT / raw
        if path.is_file() and (path.suffix.lower() in TEXT_SUFFIXES or path.name == "lean-toolchain"):
            paths.append(path)
    return sorted(set(paths))


def check_clean_repository_state(context: str) -> None:
    status = run_command(
        ("git", "status", "--porcelain=v1", "-z", "--untracked-files=all"),
        capture_output=True,
        label=f"require clean repository {context}",
    ).stdout
    if status:
        entries = status.rstrip("\0").replace("\0", "\n")
        raise ValidationError(
            f"repository must be clean {context}; staged, unstaged, or unignored "
            f"untracked paths remain:\n{entries}"
        )
    print(f"clean repository state passed {context}")


def check_hygiene(*, require_clean: bool = False) -> None:
    run_command(("git", "diff", "--check"))
    run_command(("git", "diff", "--cached", "--check"))
    conflicts: list[str] = []
    scratch: list[str] = []
    conflict_re = re.compile(r"^(?:<<<<<<<|=======|>>>>>>>)(?:\s.*)?$")
    for path in candidate_text_paths():
        rel = path.relative_to(ROOT).as_posix()
        if SCRATCH_NAME_RE.search(rel) or path.suffix.lower() in {".ilean", ".olean"}:
            scratch.append(rel)
        for line_number, line in enumerate(
            path.read_text(encoding="utf-8", errors="replace").splitlines(), start=1
        ):
            if conflict_re.match(line):
                conflicts.append(f"{rel}:{line_number}: {line}")
    if scratch:
        raise ValidationError(
            "unignored scratch or compiled artifacts found:\n" + "\n".join(scratch)
        )
    if conflicts:
        raise ValidationError("conflict markers found:\n" + "\n".join(conflicts))
    if require_clean:
        check_clean_repository_state("at the final hygiene gate")
    print(
        "repository diff, staged-diff, conflict-marker, scratch-artifact, and "
        "clean-state hygiene passed"
        if require_clean
        else "repository diff, staged-diff, conflict-marker, and scratch-artifact hygiene passed"
    )


def load_public_manifest() -> dict[str, object]:
    data = json.loads(PUBLIC_API_PATH.read_text(encoding="utf-8"))
    if data.get("schema") != "lean-info-theory.public-api.v0.1.v1":
        raise ValidationError(f"unexpected public API schema: {data.get('schema')!r}")
    return data


def module_closure(root: str) -> set[str]:
    infos = blueprint.build_module_infos()
    graph = {info.name: info.local_imports for info in infos}
    seen: set[str] = set()
    stack = [root]
    while stack:
        module = stack.pop()
        if module in seen:
            continue
        if module not in graph:
            raise ValidationError(f"unknown local module in closure: {module}")
        seen.add(module)
        stack.extend(graph[module])
    return seen


def private_supported_names(supported_modules: set[str]) -> list[str]:
    names: list[str] = []
    for path in api_index.lean_files():
        module = api_index.module_name_from_path(path)
        if module not in supported_modules:
            continue
        lines = path.read_text(encoding="utf-8").splitlines()
        namespace_stack: list[str] = []
        index = 0
        while index < len(lines):
            line = lines[index]
            stripped = line.strip()
            if stripped.startswith("/-"):
                index = api_index.skip_block_comment(lines, index) + 1
                continue
            if stripped.startswith("namespace "):
                namespace = stripped.removeprefix("namespace ").strip()
                if namespace:
                    namespace_stack.extend(namespace.split("."))
                index += 1
                continue
            if stripped.startswith("end "):
                name = stripped.removeprefix("end ").strip()
                if name and namespace_stack and namespace_stack[-1] == name.split(".")[-1]:
                    namespace_stack.pop()
                index += 1
                continue
            match = api_index.DECL_RE.match(line)
            if match and match.group("private"):
                names.append(
                    api_index.qualified_name(namespace_stack, match.group("name"))
                )
            index += 1
    return sorted(names)


def lean_name(name: str) -> str:
    if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_']*(?:\.[A-Za-z_][A-Za-z0-9_']*)*", name) is None:
        raise ValidationError(f"cannot render Lean name safely: {name!r}")
    return "``" + name


def lean_raw_name(name: str) -> str:
    if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_']*(?:\.[A-Za-z_][A-Za-z0-9_']*)*", name) is None:
        raise ValidationError(f"cannot render raw Lean name safely: {name!r}")
    return "`" + name


def lean_module_name(name: str) -> str:
    if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)*", name) is None:
        raise ValidationError(f"cannot render Lean module name safely: {name!r}")
    return "`" + name


def lean_array(items: Iterable[str], *, indent: str = "    ") -> str:
    rendered = list(items)
    if not rendered:
        return "#[]"
    return "#[\n" + ",\n".join(indent + item for item in rendered) + "\n  ]"


def run_lean_probe(label: str, source: str, *, show_output: bool = False) -> None:
    result = run_command(
        ("lake", "env", "lean", "--stdin"),
        input_text=source,
        capture_output=True,
        label=label,
    )
    if show_output and result.stdout:
        print(result.stdout, end="")
    print(f"Lean probe passed: {label}")


def check_direct_module_imports(manifest: dict[str, object]) -> None:
    declarations = list(manifest["declarations"])
    modules = sorted(str(module) for module in manifest["supported_modules"])
    for index, module in enumerate(modules, start=1):
        closure = module_closure(module)
        local_modules = lean_array(lean_module_name(name) for name in sorted(closure))
        expected = [
            declaration
            for declaration in declarations
            if str(declaration["module"]) in closure
        ]
        expected_pairs = lean_array(
            f"({lean_name(str(declaration['name']))}, "
            f"{lean_module_name(str(declaration['module']))})"
            for declaration in expected
        )
        source = f"""import {module}
import Lean.AutoDecl

open Lean Elab Command

run_cmd do
  let env <- getEnv
  let localModules : Array Name := {local_modules}
  let expected : Array (Name × Name) := {expected_pairs}
  for moduleName in env.allImportedModuleNames do
    if moduleName.toString.startsWith "LeanInfoTheory" then
      unless localModules.contains moduleName do
        throwError "direct import exposed unexpected local module {{moduleName}}"
  for moduleName in localModules do
    unless env.allImportedModuleNames.contains moduleName do
      throwError "direct import is missing local module {{moduleName}}"

  let mut reviewable : Array (Name × Name) := #[]
  for (name, _) in env.constants.toList do
    if let some moduleIdx := env.getModuleIdxFor? name then
      let moduleName := env.allImportedModuleNames[moduleIdx]!
      if localModules.contains moduleName then
        let isAutomatic <- liftCoreM <| isAutoDeclOrPrivate_Internal name
        unless isAutomatic do
          reviewable := reviewable.push (name, moduleName)
  unless reviewable.size == expected.size do
    throwError "direct import declaration count mismatch: {{reviewable.size}} / {{expected.size}}"
  for entry in reviewable do
    unless expected.contains entry do
      throwError "direct import exposed unexpected reviewable declaration {{entry}}"
  for entry in expected do
    unless reviewable.contains entry do
      throwError "direct import is missing reviewable declaration {{entry}}"
  logInfo m!"direct module import passed: {{localModules.size}} modules, {{expected.size}} declarations"
"""
        run_lean_probe(
            f"direct supported module {index}/{len(modules)}: {module} "
            f"({len(closure)}-module closure, {len(expected)} declarations)",
            source,
        )


def check_supported_environment(
    manifest: dict[str, object],
    non_stable_names: list[str],
    private_names: list[str],
) -> None:
    declarations = list(manifest["declarations"])
    manifest_pairs = lean_array(
        f"({lean_name(str(declaration['name']))}, "
        f"{lean_module_name(str(declaration['module']))})"
        for declaration in declarations
    )
    supported_modules = lean_array(
        lean_module_name(str(module)) for module in manifest["supported_modules"]
    )
    simp_names = lean_array(
        lean_name(str(declaration["name"]))
        for declaration in declarations
        if "simp" in declaration["attributes"]
    )
    allowed_axioms = lean_array(lean_name(name) for name in ALLOWED_AXIOMS)
    forbidden_public = lean_array(lean_raw_name(name) for name in non_stable_names)
    forbidden_private = lean_array(lean_raw_name(name) for name in private_names)

    source = f"""import LeanInfoTheory.Shannon
import Lean.AutoDecl
import Lean.Util.CollectAxioms
import Mathlib.Lean.Meta.Simp

open Lean Elab Command

run_cmd do
  let env <- getEnv
  let manifest : Array (Name × Name) := {manifest_pairs}
  let supportedModules : Array Name := {supported_modules}
  let expectedSimp : Array Name := {simp_names}
  let allowedAxioms : Array Name := {allowed_axioms}
  let forbiddenPublic : Array Name := {forbidden_public}
  let forbiddenPrivate : Array Name := {forbidden_private}

  for moduleName in env.allImportedModuleNames do
    if moduleName.toString.startsWith "LeanInfoTheory" then
      unless supportedModules.contains moduleName do
        throwError "full umbrella imported unsupported local module {{moduleName}}"
  for moduleName in supportedModules do
    unless env.allImportedModuleNames.contains moduleName do
      throwError "full umbrella is missing supported module {{moduleName}}"

  let mut reviewable : Array (Name × Name) := #[]
  for (name, _) in env.constants.toList do
    if let some moduleIdx := env.getModuleIdxFor? name then
      let moduleName := env.allImportedModuleNames[moduleIdx]!
      if supportedModules.contains moduleName then
        let isAutomatic <- liftCoreM <| isAutoDeclOrPrivate_Internal name
        unless isAutomatic do
          reviewable := reviewable.push (name, moduleName)

  unless reviewable.size == manifest.size do
    throwError "reviewable environment/manifest count mismatch: {{reviewable.size}} / {{manifest.size}}"
  for entry in reviewable do
    unless manifest.contains entry do
      throwError "reviewable environment declaration is absent or has the wrong owner: {{entry}}"
  for entry in manifest do
    unless reviewable.contains entry do
      throwError "manifest declaration is absent or has the wrong owner: {{entry}}"

  let mut usedAxioms : NameSet := {{}}
  for (name, _) in manifest do
    let axioms <- Lean.collectAxioms name
    for ax in axioms do
      usedAxioms := usedAxioms.insert ax
      unless allowedAxioms.contains ax do
        throwError "{{name}} depends on unapproved axiom {{ax}}"
    let actualSimp <- liftCoreM <| Lean.Meta.isInSimpSet `simp name
    let wantedSimp := expectedSimp.contains name
    unless actualSimp == wantedSimp do
      throwError "simp attribute mismatch for {{name}}: actual={{actualSimp}}, expected={{wantedSimp}}"

  for name in forbiddenPublic do
    if env.contains name then
      throwError "non-stable declaration leaked into the full umbrella: {{name}}"
  for name in forbiddenPrivate do
    if env.contains name then
      throwError "private proof-engine name became public: {{name}}"

  logInfo m!"supported environment passed: {{manifest.size}} declarations, {{expectedSimp.size}} simp declarations, axioms {{usedAxioms.toList}}"
"""
    run_lean_probe(
        "full umbrella inventory, owner, simp, axiom, non-stable, and private checks",
        source,
        show_output=True,
    )


def check_root_boundary(manifest: dict[str, object]) -> None:
    declarations = list(manifest["declarations"])
    root_modules = module_closure(str(manifest["lightweight_root"]))
    opt_in_names = sorted(
        str(declaration["name"])
        for declaration in declarations
        if str(declaration["module"]) not in root_modules
    )
    exports = lean_array(
        f"({lean_raw_name(str(export['alias']))}, {lean_name(str(export['target']))})"
        for export in manifest["root_exports"]
    )
    root_module_array = lean_array(lean_module_name(name) for name in sorted(root_modules))
    opt_in_array = lean_array(lean_raw_name(name) for name in opt_in_names)
    source = f"""import LeanInfoTheory

open Lean Elab Command

run_cmd do
  let env <- getEnv
  let exports : Array (Name × Name) := {exports}
  let rootModules : Array Name := {root_module_array}
  let forbidden : Array Name := {opt_in_array}
  for (aliasName, target) in exports do
    let resolved <- resolveGlobalConstNoOverloadCore aliasName
    unless resolved == target do
      throwError "root export resolved to the wrong target: {{aliasName}} -> {{resolved}}, expected {{target}}"
  for moduleName in env.allImportedModuleNames do
    if moduleName.toString.startsWith "LeanInfoTheory" then
      unless rootModules.contains moduleName do
        throwError "lightweight root imported opt-in local module {{moduleName}}"
  for moduleName in rootModules do
    unless env.allImportedModuleNames.contains moduleName do
      throwError "lightweight root is missing contracted module {{moduleName}}"
  for name in forbidden do
    if env.contains name then
      throwError "opt-in supported declaration leaked into the lightweight root: {{name}}"
  logInfo m!"root boundary passed: {{exports.size}} exports and {{forbidden.size}} opt-in exclusions"
"""
    run_lean_probe(
        "lightweight-root exports, closure, and opt-in exclusions",
        source,
        show_output=True,
    )


def check_all_project_axioms() -> None:
    all_modules = sorted(info.name for info in blueprint.build_module_infos())
    module_array = lean_array(lean_module_name(name) for name in all_modules)
    allowed_axioms = lean_array(lean_name(name) for name in ALLOWED_AXIOMS)
    source = f"""import LeanInfoTheory.Shannon
import LeanInfoTheory.Basic
import LeanInfoTheory.MathlibFragments
import LeanInfoTheory.Examples
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let env <- getEnv
  let localModules : Array Name := {module_array}
  let allowedAxioms : Array Name := {allowed_axioms}
  for moduleName in env.allImportedModuleNames do
    if moduleName.toString.startsWith "LeanInfoTheory" then
      unless localModules.contains moduleName do
        throwError "maintained aggregate imported unknown local module {{moduleName}}"
  for moduleName in localModules do
    unless env.allImportedModuleNames.contains moduleName do
      throwError "maintained aggregate is missing local module {{moduleName}}"

  let mut localConstantCount : Nat := 0
  let mut usedAxioms : NameSet := {{}}
  for (name, _) in env.constants.toList do
    if let some moduleIdx := env.getModuleIdxFor? name then
      let moduleName := env.allImportedModuleNames[moduleIdx]!
      if localModules.contains moduleName then
        localConstantCount := localConstantCount + 1
        let axioms <- Lean.collectAxioms name
        for ax in axioms do
          usedAxioms := usedAxioms.insert ax
          unless allowedAxioms.contains ax do
            throwError "local constant {{name}} depends on unapproved axiom {{ax}}"
  logInfo m!"all-project axiom audit passed: {{localConstantCount}} local constants, axioms {{usedAxioms.toList}}"
"""
    run_lean_probe(
        "all 44 modules and every compiled project constant axiom audit",
        source,
        show_output=True,
    )


def check_trust_contract() -> None:
    run_command(
        (sys.executable, "scripts/generate_v0_1_public_api.py", "--check"),
        label="confirm reviewed public manifest before trust probes",
    )
    run_command(
        (sys.executable, "scripts/generate_website_blueprint.py", "--check"),
        label="confirm checked module graph before trust probes",
    )
    run_maintained_build()
    manifest = load_public_manifest()
    declarations = list(manifest["declarations"])
    supported_modules = set(str(module) for module in manifest["supported_modules"])
    non_stable_modules = set(str(module) for module in manifest["non_stable_modules"])
    source_declarations = api_index.all_declarations()
    non_stable_names = sorted(
        declaration.name
        for declaration in source_declarations
        if declaration.module in non_stable_modules
    )
    private_names = private_supported_names(supported_modules)

    public_names = {str(declaration["name"]) for declaration in declarations}
    leaked_private_names = sorted(public_names.intersection(private_names))
    if leaked_private_names:
        raise ValidationError(
            "private proof-engine names entered the public manifest: "
            + ", ".join(leaked_private_names)
        )

    print(
        f"trust manifest loaded: {len(declarations)} supported declarations, "
        f"{len(non_stable_names)} non-stable exclusions, "
        f"{len(private_names)} private-name exclusions"
    )
    check_direct_module_imports(manifest)
    check_supported_environment(manifest, non_stable_names, private_names)
    check_root_boundary(manifest)
    check_all_project_axioms()
    print("frozen public API trust and import-boundary contract passed")


def unique_targets(targets: Iterable[str]) -> list[str]:
    result: list[str] = []
    for target in targets:
        if target not in result:
            result.append(target)
    return result


def run_maintained_build(extra_targets: Sequence[str] = ()) -> None:
    targets = unique_targets([*MAINTAINED_TARGETS, *extra_targets])
    run_command(("lake", "-KwarningAsError=true", "build", *targets))


def run_complete_build(extra_targets: Sequence[str] = ()) -> None:
    run_command(("lake", "build"), label="default project build")
    run_maintained_build(extra_targets)


def repository_state_snapshot() -> tuple[str, str]:
    status = run_command(
        ("git", "status", "--porcelain=v1", "-z", "--untracked-files=all"),
        capture_output=True,
        label="capture repository state around API-doc generation",
    ).stdout
    worktree_diff = run_command(
        ("git", "diff", "--binary", "--no-ext-diff"),
        capture_output=True,
        label="fingerprint tracked worktree content",
    ).stdout
    index_diff = run_command(
        ("git", "diff", "--cached", "--binary", "--no-ext-diff"),
        capture_output=True,
        label="fingerprint staged content",
    ).stdout
    untracked = run_command(
        ("git", "ls-files", "--others", "--exclude-standard", "-z"),
        capture_output=True,
        label="fingerprint untracked content",
    ).stdout
    digest = hashlib.sha256()
    for label, content in (
        ("status", status),
        ("worktree", worktree_diff),
        ("index", index_diff),
        ("untracked", untracked),
    ):
        digest.update(label.encode("ascii"))
        digest.update(b"\0")
        digest.update(content.encode("utf-8"))
        digest.update(b"\0")
    for relative in sorted(path for path in untracked.split("\0") if path):
        path = ROOT / relative
        digest.update(relative.encode("utf-8"))
        digest.update(b"\0")
        if path.is_symlink():
            digest.update(b"symlink\0")
            digest.update(os.readlink(path).encode("utf-8"))
        elif path.is_file():
            digest.update(b"file\0")
            digest.update(path.read_bytes())
        else:
            digest.update(b"missing-or-special\0")
        digest.update(b"\0")
    display_status = status.replace("\0", "\n").rstrip()
    return display_status, digest.hexdigest()


def documentation_c_environment() -> dict[str, str]:
    if os.name != "nt":
        return {}
    configured = os.environ.get("LEANINFOTHEORY_ZIG", "").strip()
    zig_candidate = Path(configured) if configured else None
    if zig_candidate is None:
        discovered = shutil.which("zig")
        zig_candidate = Path(discovered) if discovered else None
    if zig_candidate is None or not zig_candidate.is_file():
        raise ValidationError(
            "Windows API-doc generation requires official Zig 0.16.0. Set "
            "LEANINFOTHEORY_ZIG to zig.exe; Lean's bundled Windows clang lacks "
            "the general C headers needed by doc-gen4's native dependencies."
        )
    zig = zig_candidate.resolve()
    zig_hash = raw_sha256(zig)
    if zig_hash != WINDOWS_ZIG_SHA256:
        raise ValidationError(
            "Windows API docs require zig.exe from the reviewed official x86_64 "
            f"Zig 0.16.0 archive: expected SHA-256 {WINDOWS_ZIG_SHA256}, "
            f"found {zig_hash}"
        )
    version = run_command(
        (str(zig), "version"),
        capture_output=True,
        label="verify the pinned Windows documentation C toolchain",
    ).stdout.strip()
    if version != "0.16.0":
        raise ValidationError(f"Windows API docs require Zig 0.16.0, found {version!r}")
    lean_version = run_command(
        ("lake", "env", "lean", "-v"),
        cwd=DOCBUILD_ROOT,
        capture_output=True,
        label="verify the docbuild-scoped Lean compiler",
    ).stdout.strip()
    expected_lean = re.compile(
        r"^Lean \(version 4\.33\.1, [^,]+, commit "
        + re.escape(LEAN_REVISION)
        + r", Release\)$"
    )
    if expected_lean.fullmatch(lean_version) is None:
        raise ValidationError(
            "Windows documentation shim compiler is not the pinned Lean 4.33.1 "
            f"toolchain at {LEAN_REVISION}: {lean_version!r}"
        )
    shim_dir = DOCBUILD_ROOT / ".lake" / "toolchain-shims"
    shim_dir.mkdir(parents=True, exist_ok=True)
    shim_c = shim_dir / "CCShim.c"
    shim_olean = shim_dir / "CCShim.olean"
    shim_ilean = shim_dir / "CCShim.ilean"
    cc = shim_dir / "cc.exe"
    run_command(
        (
            "lake",
            "env",
            "lean",
            "-o",
            str(shim_olean),
            "-i",
            str(shim_ilean),
            "-c",
            str(shim_c),
            str(DOCBUILD_ROOT / "CCShim.lean"),
        ),
        cwd=DOCBUILD_ROOT,
        label="compile the Windows cc forwarding source with pinned Lean",
    )
    run_command(
        ("lake", "env", "leanc", "-o", str(cc), str(shim_c)),
        cwd=DOCBUILD_ROOT,
        label="link the Windows cc forwarding executable with pinned Lean",
    )
    if not cc.is_file():
        raise ValidationError(f"Windows documentation cc wrapper was not built: {cc}")
    return {
        "LEANINFOTHEORY_ZIG": str(zig),
        "PATH": str(shim_dir) + os.pathsep + os.environ.get("PATH", ""),
    }


def api_doc_relevant_digest() -> str:
    manifest = load_public_manifest()
    relative_paths = [Path("doc-manifest.json")]
    relative_paths.extend(
        Path("doc") / Path(*str(module).split(".")).with_suffix(".html")
        for module in manifest["supported_modules"]
    )
    relative_paths.extend(
        Path(path)
        for path in (
            "doc/index.html",
            "doc/404.html",
            "doc/search.html",
            "doc/find/index.html",
            "doc/find/find.js",
            "doc/navbar.html",
            "doc/style.css",
            "doc/color-scheme.js",
            "doc/declaration-data.js",
            "doc/expand-nav.js",
            "doc/importedBy.js",
            "doc/instances.js",
            "doc/jump-src.js",
            "doc/mathjax-config.js",
            "doc/nav.js",
            "doc/search.js",
            "doc/declarations/declaration-data.bmp",
        )
    )
    digest = hashlib.sha256()
    for relative in sorted(set(relative_paths), key=lambda path: path.as_posix()):
        path = DOCBUILD_OUTPUT / relative
        if not path.is_file():
            raise ValidationError(f"missing API-doc digest input: {relative.as_posix()}")
        digest.update(relative.as_posix().encode("utf-8"))
        digest.update(b"\0")
        digest.update(path.read_bytes())
        digest.update(b"\0")
    return digest.hexdigest()


def api_doc_tree_digest() -> tuple[str, int, int, int]:
    """Fingerprint every regular file that website staging will copy."""
    check_docbuild_output_roots(require_doc=True)
    doc_root = DOCBUILD_OUTPUT / "doc"
    paths = sorted(
        doc_root.rglob("*"),
        key=lambda path: path.relative_to(doc_root).as_posix(),
    )
    digest = hashlib.sha256()
    file_count = 0
    html_count = 0
    byte_count = 0
    for path in paths:
        relative = path.relative_to(doc_root).as_posix()
        if is_redirected_path(path):
            raise ValidationError(
                f"API documentation tree contains a redirected path: {relative}"
            )
        if path.is_dir():
            continue
        if not path.is_file():
            raise ValidationError(f"unsupported API documentation entry: {relative}")
        content = path.read_bytes()
        digest.update(relative.encode("utf-8"))
        digest.update(b"\0")
        digest.update(content)
        digest.update(b"\0")
        file_count += 1
        html_count += path.suffix.lower() == ".html"
        byte_count += len(content)
    return digest.hexdigest(), file_count, html_count, byte_count


def write_api_doc_attestation(
    configuration: Mapping[str, object],
    relevant_digest: str,
    tree_digest: str,
    file_count: int,
    html_count: int,
    byte_count: int,
) -> None:
    attestation = {
        "schema": "lean-info-theory.api-doc-attestation.v1",
        "configuration": dict(configuration),
        "relevant_output_sha256": relevant_digest,
        "doc_tree_sha256": tree_digest,
        "doc_files": file_count,
        "doc_html_files": html_count,
        "doc_bytes": byte_count,
        "validated_passes": 2,
    }
    temporary = DOCBUILD_ATTESTATION.with_suffix(".json.tmp")
    temporary.write_text(
        json.dumps(attestation, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    temporary.replace(DOCBUILD_ATTESTATION)


def api_doc_build_configuration(source_mode: str) -> dict[str, object]:
    source_identity = str(ROOT.resolve())
    if source_mode == "github":
        source_identity = run_command(
            ("git", "rev-parse", "HEAD"),
            capture_output=True,
            label="capture exact API-doc source revision",
        ).stdout.strip()
        if re.fullmatch(r"[0-9a-f]{40}", source_identity) is None:
            raise ValidationError(f"git HEAD is not a full commit hash: {source_identity!r}")
    return {
        "schema": "lean-info-theory.api-doc-build-config.v1",
        "docgen_revision": DOCGEN_REVISION,
        "lean_revision": LEAN_REVISION,
        "mathlib_revision": MATHLIB_REVISION,
        "source_mode": source_mode,
        "source_identity": source_identity,
        "disable_equations": True,
    }


def write_api_doc_build_configuration(configuration: Mapping[str, object]) -> None:
    DOCBUILD_CONFIG_STAMP.parent.mkdir(parents=True, exist_ok=True)
    DOCBUILD_CONFIG_STAMP.write_text(
        json.dumps(configuration, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )


def invalidate_mode_sensitive_api_doc_output() -> None:
    directories = (DOCBUILD_OUTPUT / "doc", DOCBUILD_OUTPUT / "doc-data")
    files = (
        DOCBUILD_OUTPUT / "api-docs.db",
        DOCBUILD_OUTPUT / "api-docs.db-shm",
        DOCBUILD_OUTPUT / "api-docs.db-wal",
        DOCBUILD_OUTPUT / "doc-manifest.json",
        DOCBUILD_ATTESTATION,
    )
    output_root = DOCBUILD_OUTPUT.resolve()
    for path in (*directories, *files):
        resolved = path.resolve(strict=False)
        if resolved != output_root and output_root not in resolved.parents:
            raise ValidationError(f"refusing to invalidate API-doc output outside {output_root}")
    for path in directories:
        if path.exists():
            shutil.rmtree(path)
    for path in files:
        if path.exists():
            path.unlink()


def prepare_api_doc_build_configuration(configuration: Mapping[str, object]) -> None:
    check_docbuild_output_roots(require_doc=False)
    if DOCBUILD_CONFIG_STAMP.is_file():
        recorded = json.loads(DOCBUILD_CONFIG_STAMP.read_text(encoding="utf-8"))
        if recorded != configuration:
            print(
                "API-doc source/equation configuration changed; invalidating only the "
                "generated documentation database and HTML",
                flush=True,
            )
            invalidate_mode_sensitive_api_doc_output()
            write_api_doc_build_configuration(configuration)
        return
    existing_mode_sensitive_output = any(
        path.exists()
        for path in (
            DOCBUILD_OUTPUT / "doc",
            DOCBUILD_OUTPUT / "doc-data",
            DOCBUILD_OUTPUT / "api-docs.db",
            DOCBUILD_OUTPUT / "doc-manifest.json",
        )
    )
    if existing_mode_sensitive_output:
        print(
            "unversioned API-doc output found; invalidating only the generated "
            "documentation database and HTML before adopting a cache-key contract",
            flush=True,
        )
        invalidate_mode_sensitive_api_doc_output()
    write_api_doc_build_configuration(configuration)


def run_api_docs() -> None:
    check_docbuild_contract()
    source_mode = os.environ.get("DOCGEN_SRC", "file").strip() or "file"
    if source_mode not in {"file", "github"}:
        raise ValidationError("DOCGEN_SRC for the maintained API-doc build must be file or github")
    before_status, before_state = repository_state_snapshot()
    if source_mode == "github" and before_status:
        raise ValidationError(
            "GitHub API-doc source links require a completely clean checkout; "
            "use the default file mode for a dirty development tree"
        )

    build_env: dict[str, str | None] = {
        "DOCGEN_SRC": source_mode,
        "DISABLE_EQUATIONS": "1",
    }
    build_env.update(documentation_c_environment())
    configuration = api_doc_build_configuration(source_mode)
    prepare_api_doc_build_configuration(configuration)
    if DOCBUILD_ATTESTATION.exists():
        DOCBUILD_ATTESTATION.unlink()
    digests: list[str] = []
    elapsed: list[float] = []
    for pass_number in (1, 2):
        started = time.perf_counter()
        run_command(
            ("lake", "build", "+LeanInfoTheory.Shannon:docs"),
            cwd=DOCBUILD_ROOT,
            env=build_env,
            label=f"signature-bearing API documentation pass {pass_number}",
        )
        run_command(
            (
                sys.executable,
                "scripts/check_api_docs.py",
                "--source-mode",
                source_mode,
            ),
            label=f"API documentation semantic check pass {pass_number}",
        )
        elapsed.append(time.perf_counter() - started)
        digests.append(api_doc_relevant_digest())
    if digests[0] != digests[1]:
        raise ValidationError(
            "relevant API documentation output changed across an incremental rebuild: "
            f"{digests[0]} != {digests[1]}"
        )
    after_status, after_state = repository_state_snapshot()
    if after_state != before_state:
        raise ValidationError(
            "API-doc generation changed tracked or unignored repository files:\n"
            f"before status:\n{before_status}\nafter status:\n{after_status}\n"
            f"before fingerprint: {before_state}\nafter fingerprint: {after_state}"
        )
    tree_digest, file_count, html_count, byte_count = api_doc_tree_digest()
    write_api_doc_attestation(
        configuration,
        digests[0],
        tree_digest,
        file_count,
        html_count,
        byte_count,
    )
    mode_note = (
        "local file-linked output; not publication evidence"
        if source_mode == "file"
        else "clean-checkout exact-commit GitHub links"
    )
    print(
        "incrementally stable signature-bearing API documentation passed: "
        f"first pass {elapsed[0]:.1f}s, incremental pass {elapsed[1]:.1f}s, "
        f"relevant digest {digests[0]}, full-tree digest {tree_digest}; {mode_note}"
    )


def run_static_contract() -> None:
    check_lean_source()
    check_release_metadata()
    check_release_documentation_contract()
    check_toolchain_contract()
    check_docbuild_contract()
    check_release_interlock()
    check_generated_artifacts()
    check_hygiene()
    print("static release contract passed")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "command",
        nargs="?",
        default="all",
        choices=(
            "all",
            "static",
            "metadata",
            "trust",
            "build",
            "maintained-build",
            "documentation",
            "api-docs",
            "focused",
            "hygiene",
            "targets",
        ),
    )
    parser.add_argument(
        "targets",
        nargs="*",
        help="extra Lake targets for build, or the exact targets for focused",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        if args.command == "targets":
            print("\n".join(MAINTAINED_TARGETS))
        elif args.command == "static":
            if args.targets:
                raise ValidationError("static does not accept Lake targets")
            run_static_contract()
        elif args.command == "metadata":
            if args.targets:
                raise ValidationError("metadata does not accept Lake targets")
            check_release_metadata()
        elif args.command == "trust":
            if args.targets:
                raise ValidationError("trust does not accept Lake targets")
            check_trust_contract()
        elif args.command == "build":
            run_complete_build(args.targets)
        elif args.command == "maintained-build":
            run_maintained_build(args.targets)
        elif args.command == "documentation":
            if args.targets:
                raise ValidationError("documentation does not accept Lake targets")
            check_release_documentation_contract()
            check_documentation_examples()
        elif args.command == "api-docs":
            if args.targets:
                raise ValidationError("api-docs does not accept Lake targets")
            run_api_docs()
        elif args.command == "focused":
            if not args.targets:
                raise ValidationError("focused requires at least one Lake target")
            run_command(("lake", "-KwarningAsError=true", "build", *unique_targets(args.targets)))
        elif args.command == "hygiene":
            if args.targets:
                raise ValidationError("hygiene does not accept Lake targets")
            check_hygiene(require_clean=True)
        else:
            if args.targets:
                raise ValidationError("all does not accept Lake targets")
            check_clean_repository_state("before the complete suite")
            run_static_contract()
            run_complete_build()
            check_documentation_examples()
            check_trust_contract()
            check_hygiene(require_clean=True)
            print(
                "complete routine release-validation suite passed; run the explicit "
                "api-docs gate for release-candidate documentation"
            )
    except (OSError, ValueError, ValidationError, json.JSONDecodeError) as exc:
        print(f"release validation failed: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
