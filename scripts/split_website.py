#!/usr/bin/env python3
"""Prepare two nonpublishing Pages previews from a qualified candidate composition.

The input composition is checked by its own exact clean source checkout. Optional
working website pages are an explicitly unqualified overlay. No output from this
command is publishable, even when the input API has GitHub source links.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys

import stage_website as staging

ROOT = Path(__file__).resolve().parents[1]
MAIN_NAME = "LeanInfoTheory"
API_NAME = "LeanInfoTheory-API-v0.2.0"
MAIN_ROUTE = f"/{MAIN_NAME}/"
API_ROUTE = f"/{API_NAME}/"
SCHEMA = "lean-info-theory.split-preview.v1"
MANIFEST = "split-preview.json"
LIMIT = 1_000_000_000
MARKER = "UNQUALIFIED TWO-SITE PREVIEW. NOT_FOR_PUBLICATION. DO NOT DEPLOY.\n"


def encoded(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode("utf-8")


def inventory(root: Path) -> dict[str, dict]:
    staging.require_unredirected_tree(root, label="split input/output")
    result = {}
    for path in sorted(root.rglob("*")):
        if not path.is_file():
            continue
        if path.stat().st_nlink != 1:
            raise ValueError(f"hard-linked input/output: {path.name}")
        raw = path.read_bytes()
        result[path.relative_to(root).as_posix()] = {
            "sha256": hashlib.sha256(raw).hexdigest(), "bytes": len(raw)}
    return result


def check_capacity(files: dict[str, dict]) -> int:
    total = sum(info["bytes"] for info in files.values())
    if total >= LIMIT or any(info["bytes"] > 100 * 1024 * 1024 for info in files.values()):
        raise ValueError("split site exceeds the unchanged Pages size guard")
    return total


def normalized_nav(raw: bytes) -> bytes:
    source = raw.decode("utf-8")
    for old, new in (( '<a href="../">Project documentation</a>',
                       f'<a href="{MAIN_ROUTE}docs/">Project documentation</a>'),
                     ( '<a href="../../">Project home</a>',
                       f'<a href="{MAIN_ROUTE}">Project home</a>')):
        if source.count(old) != 1:
            raise ValueError("candidate navbar has an unexpected project return link")
        source = source.replace(old, new, 1)
    # doc-gen4's getRoot emits .// at the root. Correct only this new API navbar;
    # the historical v0.1.0 bytes are never transformed.
    source = re.sub(r'\b(href|src)="\.//', r'\1="./', source)
    return source.encode("utf-8")


def entry_page() -> bytes:
    return (f'<!doctype html><html lang="en"><head><meta charset="utf-8">'
            '<meta name="viewport" content="width=device-width, initial-scale=1">'
            '<title>LeanInfoTheory API preview</title></head><body>'
            '<h1>LeanInfoTheory v0.2.0 API preview</h1>'
            '<p>Unpublished local preview. NOT_FOR_PUBLICATION.</p>'
            f'<p><a href="{API_ROUTE}">Open the complete API documentation</a></p>'
            f'<p><a href="{MAIN_ROUTE}docs/">Project documentation</a></p>'
            '</body></html>\n').encode("utf-8")


def overlay_files(root: Path | None) -> dict[str, dict]:
    if root is None:
        return {}
    result = inventory(root)
    if any(p.startswith("docs/current/") or p.startswith("docs/v0.2.0/") for p in result):
        raise ValueError("working website overlay must not contain current/reserved API output")
    return {p: v for p, v in result.items() if not p.startswith("docs/v0.1.0/")}


def expected_files(composition: Path, site_source: Path | None) -> tuple[dict, dict, dict]:
    """Derive output hashes from original inputs, not from the output manifest."""
    original = inventory(composition)
    metadata = staging.strict_object(composition / staging.ROOT_MARKER)
    if metadata.get("schema") != staging.CANDIDATE_STAGE_SCHEMA \
            or metadata.get("publishable") is not False or metadata.get("mode") != "candidate":
        raise ValueError("split preview requires an explicitly unpublished candidate composition")
    current = composition / staging.CURRENT_ROUTE
    frozen = composition / staging.VERSION_ROUTE
    for directory, prefix in ((current, "current"), (frozen, "version")):
        digest, count, html, size = staging.tree_digest(directory)
        for suffix, actual in (("sha256", digest), ("files", count),
                               ("html_files", html), ("bytes", size)):
            if metadata.get(f"{prefix}_route_{suffix}") != actual:
                raise ValueError(f"candidate {prefix} bytes differ from input evidence")
    main = {p: v for p, v in original.items() if not p.startswith("docs/current/")}
    api = {p.removeprefix("docs/current/"): v for p, v in original.items()
           if p.startswith("docs/current/")}
    overlay = overlay_files(site_source)
    main.update(overlay)
    changes = {}
    if site_source is not None:
        index, _ = staging.candidate_source_index((site_source / "docs/api-index.html").read_text(encoding="utf-8"))
        landing = staging.candidate_landing((site_source / "docs/index.html").read_text(encoding="utf-8"))
        changes[(MAIN_NAME, "docs/api-index.html")] = index.encode("utf-8")
        changes[(MAIN_NAME, "docs/index.html")] = landing.encode("utf-8")
    changes[(API_NAME, "navbar.html")] = normalized_nav((current / "navbar.html").read_bytes())
    changes[(MAIN_NAME, "docs/current/index.html")] = entry_page()
    for name, files in ((MAIN_NAME, main), (API_NAME, api)):
        changes[(name, staging.PREVIEW_MARKER)] = MARKER.encode()
        changes[(name, ".nojekyll")] = b""
        changes[(name, staging.ROOT_MARKER)] = encoded({
            "schema": SCHEMA, "publishable": False, "role": "main" if name == MAIN_NAME else "api",
            "source_identity": metadata["site_source_identity"],
            "working_site_overlay": site_source is not None,
            "route": f"/{name}/", "peer_route": API_ROUTE if name == MAIN_NAME else MAIN_ROUTE,
        })
        for (owner, rel), raw in changes.items():
            if owner == name:
                files[rel] = {"sha256": hashlib.sha256(raw).hexdigest(), "bytes": len(raw)}
    return main, api, changes


def check_pair(composition: Path, output: Path, site_source: Path | None = None) -> dict:
    main, api, _ = expected_files(composition, site_source)
    actual_top = {p.name for p in output.iterdir()}
    if actual_top != {MAIN_NAME, API_NAME, MANIFEST}:
        raise ValueError("unexpected file or directory in the split bundle")
    sizes = {}
    for name, expected in ((MAIN_NAME, main), (API_NAME, api)):
        actual = inventory(output / name)
        if actual != expected:
            different = sorted(p for p in set(actual) | set(expected) if actual.get(p) != expected.get(p))
            raise ValueError(f"split output differs from trusted input transforms: {name}/{different[0]}")
        sizes[name] = check_capacity(actual)
    expected_manifest = {
        "schema": SCHEMA, "publishable": False, "sites": sizes,
        "source_composition_sha256": hashlib.sha256((composition / staging.ROOT_MARKER).read_bytes()).hexdigest(),
        "working_site_overlay": overlay_files(site_source),
        "tool_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
    }
    if staging.strict_object(output / MANIFEST) != expected_manifest:
        raise ValueError("split manifest differs from its actual inputs and outputs")
    return expected_manifest


def assemble_pair(composition: Path, output: Path, site_source: Path | None = None) -> dict:
    owned = ROOT / ".lake/website-split"
    staging.require_unredirected_components(owned, label="split owned root")
    staging.require_unredirected_components(output, label="split destination")
    if output.exists():
        raise ValueError("split destination already exists; choose a fresh preview directory")
    # Restrict writes to an ignored owned subtree. Never overwrite source or old evidence.
    if not output.resolve().is_relative_to(owned.resolve()) or output.resolve() == owned.resolve():
        raise ValueError("split destination must be a new child of .lake/website-split")
    main, api, changes = expected_files(composition, site_source)
    overlay = overlay_files(site_source)
    for files in (main, api):
        check_capacity(files)
    output.mkdir(parents=True)
    for name, files in ((MAIN_NAME, main), (API_NAME, api)):
        for rel in files:
            target = output / name / rel
            target.parent.mkdir(parents=True, exist_ok=True)
            if (name, rel) in changes:
                target.write_bytes(changes[(name, rel)])
            else:
                source = composition / (staging.CURRENT_ROUTE if name == API_NAME else Path()) / rel
                if name == MAIN_NAME and site_source is not None and rel in overlay:
                    source = site_source / rel
                shutil.copy2(source, target)
    manifest = {
        "schema": SCHEMA, "publishable": False,
        "sites": {MAIN_NAME: check_capacity(main), API_NAME: check_capacity(api)},
        "source_composition_sha256": hashlib.sha256((composition / staging.ROOT_MARKER).read_bytes()).hexdigest(),
        "working_site_overlay": overlay_files(site_source),
        "tool_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
    }
    (output / MANIFEST).write_bytes(encoded(manifest))
    return check_pair(composition, output, site_source)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("prepare", "check"))
    parser.add_argument("--candidate-source-root", required=True, type=Path)
    parser.add_argument("--candidate-site-root", required=True, type=Path)
    parser.add_argument("--expected-commit", required=True)
    parser.add_argument("--frozen-source-root", required=True, type=Path)
    parser.add_argument("--frozen-site-root", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--working-site", action="store_true", help="overlay current local home_page; remains unqualified")
    args = parser.parse_args()
    try:
        for supplied in (args.candidate_source_root, args.candidate_site_root,
                         args.frozen_source_root, args.frozen_site_root, args.output):
            staging.require_unredirected_components(supplied, label="split supplied path")
        source = args.candidate_source_root.resolve()
        composition = args.candidate_site_root.resolve()
        staging.require_clean_checkout(source, label="split input source")
        if staging.exact_commit(source) != args.expected_commit:
            raise ValueError("split input source does not match the expected commit")
        if composition != source / ".lake/website-stage/LeanInfoTheory":
            raise ValueError("input composition must belong to the exact candidate checkout")
        command = [sys.executable, "-B", str(source / "scripts/check_website.py"),
                   "--mode", "candidate", "--site-root", str(composition),
                   "--expected-commit", args.expected_commit,
                   "--frozen-source-root", str(args.frozen_source_root.resolve()),
                   "--frozen-site-root", str(args.frozen_site_root.resolve())]
        subprocess.run(command, cwd=source, check=True)
        site_source = ROOT / "home_page" if args.working_site else None
        operation = assemble_pair if args.action == "prepare" else check_pair
        result = operation(composition, args.output, site_source)
        print(json.dumps({"publishable": False, "sites": result["sites"]}, indent=2))
        return 0
    except (OSError, ValueError, staging.StagingError, subprocess.CalledProcessError) as exc:
        print(f"split preview refused: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
