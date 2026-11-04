#!/usr/bin/env python3
"""Prepare review material for v0.2.0; never mutate Git, publish, or deploy.

Metadata proposals do not edit canonical files. Review staging requires a clean,
source-bound candidate with GitHub API links and preserves the recovered live
v0.1.0 route. The output is still NOT_FOR_PUBLICATION: host qualification,
approved deployment packaging and publication approval are separate gates.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path
from urllib.parse import urlsplit
import shutil
import subprocess
import sys

import release_state
import split_website as split
import stage_website as staging
from compatibility import candidate_contract

ROOT = Path(__file__).resolve().parents[1]
SCHEMA = "lean-info-theory.release-review.v1"
MANIFEST = "release-review.json"
HISTORICAL_DIGEST = "cb58864f20938cde83cffae0b230f654135bb3ffa68c4fba489cc6a834d4566f"
HISTORICAL_FILES = 5534
HISTORICAL_BYTES = 660408008
MARKER = b"RELEASE REVIEW ONLY. NOT_FOR_PUBLICATION. Separate deployment approval required.\n"
API_NAME = release_state.PUBLICATION["api_repository"].split("/")[-1]
API_VERSION = "v" + release_state.TARGET_VERSION
API_ROUTE = urlsplit(release_state.PUBLICATION["api_url"]).path
REVIEW_BANNER = ('<aside data-publication-review="true" style="padding:1rem;'
                'background:#fff3cd;color:#222">Unpublished release review. '
                'NOT_FOR_PUBLICATION. These pages describe the intended release; '
                'publication and deployment have not been performed.</aside>')


def review_html(raw: bytes, *, commit: str | None = None) -> bytes:
    source = raw.decode("utf-8")
    if commit is not None:
        source = staging.PROJECT_LEAN_BLOB_RE.sub(
            lambda match: match.group("prefix") + commit + match.group("path"), source)
    source = re.sub(r"(<body\b[^>]*>)", lambda match: match.group(1) + REVIEW_BANNER,
                    source, count=1, flags=re.IGNORECASE)
    return source.encode("utf-8")


def validate_tracked_site_source(root: Path) -> None:
    """Ignored/untracked files inside home_page must never enter the artifact."""
    tracked = subprocess.check_output(["git", "ls-files", "-z", "--", "home_page"], cwd=root)
    names = {p.removeprefix("home_page/") for p in tracked.decode("utf-8").split("\0") if p}
    if set(split.inventory(root / "home_page")) != names:
        raise ValueError("website source contains missing, ignored or untracked files")


def metadata_proposal(root: Path, release_date: str) -> dict[str, bytes]:
    current = release_state.load_state(root)
    if current["phase"] != "candidate" or current["retention"] != "established":
        raise ValueError("metadata proposal requires the established candidate state")
    proposed = release_state.validate_state({**current, "phase": "release-ready",
        "publication": {**release_state.PUBLICATION, "release_date": release_date}})
    return {"candidate-release-state.json": split.encoded(proposed),
            "CITATION.cff": release_state.expected_citation(proposed).encode("utf-8")}


def owned_destination(output: Path) -> None:
    owned = ROOT / ".lake/publication-review"
    # Check lexical components before resolution (including Windows junctions).
    staging.require_unredirected_components(owned, label="publication owned root")
    staging.require_unredirected_components(output, label="publication output")
    if not output.resolve().is_relative_to(owned.resolve()) or output.resolve() == owned.resolve():
        raise ValueError("output must be a child of .lake/publication-review")


def fresh_destination(output: Path) -> None:
    owned_destination(output)
    if output.exists():
        raise ValueError("output already exists; choose a fresh review directory")


def write_metadata(output: Path, release_date: str) -> None:
    fresh_destination(output)
    files = metadata_proposal(ROOT, release_date)
    output.mkdir(parents=True)
    for name, raw in files.items():
        (output / name).write_bytes(raw)
    (output / staging.PREVIEW_MARKER).write_bytes(MARKER)


def historical_inventory(route: Path) -> dict:
    files = split.inventory(route)
    digest, count, _html, size = staging.tree_digest(route)
    if (digest, count, size) != (HISTORICAL_DIGEST, HISTORICAL_FILES, HISTORICAL_BYTES):
        raise ValueError("historical route is not the exact recovered deployed v0.1.0 artifact")
    return files


def release_api_html(raw: bytes, relative: str) -> bytes:
    """Change only release labels/return links; leave declarations and data alone."""
    source = raw.decode("utf-8")
    if relative == "navbar.html":
        source = split.normalized_nav(raw).decode("utf-8")
        for old, new in (
            ("LeanInfoTheory current — unpublished", "LeanInfoTheory v0.2.0"),
            ("Local candidate — not for publication", "Release API reference"),
        ):
            if source.count(old) != 1:
                raise ValueError("unexpected candidate API navbar release label")
            source = source.replace(old, new, 1)
    elif relative == "index.html":
        old = ('<h1>LeanInfoTheory current API — unpublished</h1>'
               '<p>57 supported modules and 811 declarations. This local candidate is '
               'NOT_FOR_PUBLICATION; the stable release remains v0.1.0.</p>')
        if source.count(old) != 1:
            raise ValueError("unexpected candidate API index release label/counts")
        source = source.replace(old, '<h1>LeanInfoTheory v0.2.0 API reference</h1>'
            '<p>57 supported modules and 811 declarations. Imported dependency '
            'pages are included so signatures, navigation and search remain complete.</p>', 1)
    elif relative == "licenses/index.html":
        # This page moves to the API site's versioned snapshot/licenses/.
        for old, new in (
            ('href="../../../styles.css"', f'href="{split.MAIN_ROUTE}styles.css"'),
            ('href="../../../"', f'href="{split.MAIN_ROUTE}"'),
            ('href="../../"', f'href="{split.MAIN_ROUTE}docs/"'),
            ('href="../../third-party.html"', f'href="{split.MAIN_ROUTE}docs/third-party.html"'),
        ):
            if source.count(old) != 1:
                raise ValueError("unexpected API licence-page project link")
            source = source.replace(old, new, 1)
    return source.encode("utf-8")


def version_entry(*, preview: bool = False) -> bytes:
    return (f'<!doctype html><html lang="en"><head><meta charset="utf-8">'
            '<meta name="viewport" content="width=device-width, initial-scale=1">'
            '<title>LeanInfoTheory v0.2.0 API reference</title></head><body>'
            '<h1>LeanInfoTheory v0.2.0 API reference</h1>'
            + ('<p>Unpublished review. NOT_FOR_PUBLICATION.</p>' if preview else '')
            + f'<p><a href="{API_ROUTE}">Open the complete API documentation</a></p>'
            f'<p><a href="{split.MAIN_ROUTE}docs/">Project documentation</a></p>'
            '</body></html>\n').encode()


def expected_files(composition: Path, historical: Path, commit: str) -> tuple[dict, dict]:
    """Return source paths/explicit bytes and bindings; never trust output receipts."""
    source = split.inventory(composition)
    metadata = staging.strict_object(composition / staging.ROOT_MARKER)
    contract = release_state.contract_identity(ROOT)
    if metadata.get("schema") != staging.CANDIDATE_STAGE_SCHEMA \
            or metadata.get("mode") != "candidate" or metadata.get("publishable") is not False \
            or metadata.get("site_source_identity") != commit \
            or metadata.get("release_contract") != contract:
        raise ValueError("composition does not bind the expected unpublished source/contract")
    current = composition / staging.CURRENT_ROUTE
    api_metadata = staging.strict_object(current / staging.VERSION_STAGE_METADATA)
    if api_metadata.get("source_mode") != "github" or api_metadata.get("source_identity") != commit:
        raise ValueError("release review requires exact-SHA GitHub API source links")
    historical_files = historical_inventory(historical)
    files = {split.MAIN_NAME: {}, API_NAME: {}}
    for rel in source:
        if rel.startswith("docs/current/"):
            api_rel = rel.removeprefix("docs/current/")
            files[API_NAME][f"{API_VERSION}/{api_rel}"] = current / api_rel
    # Derive public main pages from this exact clean checkout, rather than the
    # candidate composition's disabled source links and synthetic status notices.
    site_source = split.inventory(ROOT / "home_page")
    for rel in site_source:
        if not rel.startswith(("docs/v0.1.0/", "docs/current/")):
            path = ROOT / "home_page" / rel
            files[split.MAIN_NAME][rel] = review_html(path.read_bytes(), commit=commit) \
                if path.suffix.lower() == ".html" else path
    files[split.MAIN_NAME]["LICENSE.txt"] = ROOT / "LICENSE"
    for rel in historical_files:
        files[split.MAIN_NAME]["docs/v0.1.0/" + rel] = historical / rel
    for rel in ("navbar.html", "index.html", "licenses/index.html"):
        files[API_NAME][f"{API_VERSION}/{rel}"] = review_html(
            release_api_html((current / rel).read_bytes(), rel))
    files[API_NAME]["index.html"] = version_entry(preview=True)
    files[API_NAME][f"{API_VERSION}/{staging.PREVIEW_MARKER}"] = MARKER
    if "docs/v0.2.0/index.html" not in files[split.MAIN_NAME]:
        raise ValueError("publication source is missing the versioned API entry")
    # Keep an explicit review entry for links from candidate evidence; the
    # tracked main-site publication copy uses the versioned release entry.
    files[split.MAIN_NAME]["docs/current/index.html"] = version_entry(preview=True)
    bindings = {"schema": SCHEMA, "publishable": False, "source_identity": commit,
        "release_contract": contract,
        "historical_route_sha256": HISTORICAL_DIGEST,
        "composition_metadata_sha256": hashlib.sha256((composition / staging.ROOT_MARKER).read_bytes()).hexdigest(),
        "tool_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        "publication": release_state.load_state(ROOT)["publication"],
        "pending": ["production-host qualification",
                    "approved deployment packaging", "separate publication approvals"]}
    for name in files:
        files[name][staging.ROOT_MARKER] = split.encoded({**bindings, "site": name})
        files[name][staging.PREVIEW_MARKER] = MARKER
        files[name][".nojekyll"] = b""
    # Candidate evidence is retained, explicitly unchanged and unpublished.
    return files, bindings


def file_hashes(files: dict) -> dict:
    result = {}
    for rel, source in files.items():
        raw = source if isinstance(source, bytes) else source.read_bytes()
        result[rel] = {"sha256": hashlib.sha256(raw).hexdigest(), "bytes": len(raw)}
    return result


def review_pair(composition: Path, historical: Path, output: Path, commit: str, *, prepare: bool) -> dict:
    owned_destination(output)
    if prepare:
        fresh_destination(output)
    files, bindings = expected_files(composition, historical, commit)
    expected = {name: file_hashes(values) for name, values in files.items()}
    sizes = {name: split.check_capacity(values) for name, values in expected.items()}
    receipt = {**bindings, "sites": sizes, "files": expected}
    if prepare:
        output.mkdir(parents=True)
        for name, values in files.items():
            for rel, source in values.items():
                target = output / name / rel
                target.parent.mkdir(parents=True, exist_ok=True)
                if isinstance(source, bytes):
                    target.write_bytes(source)
                else:
                    shutil.copy2(source, target)
        (output / MANIFEST).write_bytes(split.encoded(receipt))
    if {p.name for p in output.iterdir()} != {split.MAIN_NAME, API_NAME, MANIFEST}:
        raise ValueError("unexpected release-review bundle content")
    for name, values in expected.items():
        if split.inventory(output / name) != values:
            raise ValueError("release-review output differs from its input bytes/transforms")
    if staging.strict_object(output / MANIFEST) != receipt:
        raise ValueError("release-review receipt differs from actual inputs")
    # Detect input drift during copying/checking, not merely output corruption.
    final_files, final_bindings = expected_files(composition, historical, commit)
    if final_bindings != bindings or {n: file_hashes(v) for n, v in final_files.items()} != expected:
        raise ValueError("release-review inputs changed during assembly/checking")
    return {"publishable": False, "sites": sizes}


def validate_source(commit: str) -> None:
    state = release_state.load_state(ROOT)
    if state["phase"] != "release-ready":
        raise ValueError("review staging requires explicitly selected release-ready metadata")
    config, _attestation, _manifest, _contract = staging.validate_candidate_inputs(commit)
    if config["source_mode"] != "github":
        raise ValueError("release review requires GitHub-mode API generation")
    retained = candidate_contract.load_approved_contract(ROOT)
    if retained["producer"]["files"] != candidate_contract.producer_identity(ROOT):
        raise ValueError("retained capture is not bound to the current producer sources")
    validate_tracked_site_source(ROOT)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="action", required=True)
    metadata = commands.add_parser("metadata")
    metadata.add_argument("--release-date", required=True)
    metadata.add_argument("--output", required=True, type=Path)
    for action in ("prepare", "check"):
        command = commands.add_parser(action)
        command.add_argument("--expected-commit", required=True)
        command.add_argument("--historical-route", required=True, type=Path)
        command.add_argument("--frozen-source-root", required=True, type=Path)
        command.add_argument("--frozen-site-root", required=True, type=Path)
        command.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    try:
        if args.action == "metadata":
            write_metadata(args.output, args.release_date)
            print("Metadata proposal only; canonical files unchanged; NOT_FOR_PUBLICATION.")
            return 0
        for path in (args.historical_route, args.frozen_source_root, args.frozen_site_root, args.output):
            staging.require_unredirected_components(path, label="publication supplied path")
        owned_destination(args.output)
        validate_source(args.expected_commit)
        subprocess.run([sys.executable, "-B", str(ROOT / "scripts/check_website.py"),
            "--mode", "candidate", "--site-root", str(staging.STAGE_ROOT),
            "--expected-commit", args.expected_commit,
            "--frozen-source-root", str(args.frozen_source_root),
            "--frozen-site-root", str(args.frozen_site_root)], cwd=ROOT, check=True)
        result = review_pair(staging.STAGE_ROOT, args.historical_route, args.output,
                            args.expected_commit, prepare=args.action == "prepare")
        validate_source(args.expected_commit)
        print(json.dumps(result, indent=2))
        return 0
    except (OSError, ValueError, staging.StagingError, subprocess.CalledProcessError) as exc:
        print(f"publication preparation refused: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
