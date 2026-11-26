"""Compose the two reviewed citation pages onto a qualified main-site tree."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess

import release3_state as release
from release_state import strict_json
from stage_website import ROOT_MARKER, tree_digest


PAGES = ("index.html", "license.html")
PINS = "docs/compatibility/v0.3.0-promotion.json"


def compose(site: Path, decision: dict, source: str, archive: dict, pins: dict,
            pages: dict[str, bytes]) -> dict:
    """Validate every input before writing to the freshly extracted, disposable site."""
    if not re.fullmatch(r"[0-9a-f]{40}", source) or set(pages) != set(PAGES):
        raise ValueError("expected an exact maintenance revision and the two citation pages")
    base_tree = decision["site_tree_sha256"]
    if tree_digest(site)[0] != base_tree:
        raise ValueError("main site differs from the qualified archive before composition")
    path = site / ROOT_MARKER
    marker = strict_json(path.read_bytes())
    if (marker["schema"] != "lean-info-theory.release3-pages.v1" or marker["purpose"] != "candidate"
            or marker["current_api_url"] != release.API_URL or marker["rehearsal_overlays"]
            or marker["source_identity"] != marker["site_source_identity"]
            or marker["source_identity"] != archive["source_commit"] or marker["source_tree"] != archive["git_tree"]
            or pins["release_commit"] != archive["source_commit"] or pins["annotated_tag"] != archive["tag_object"]):
        raise ValueError("qualified main site, promotion pins, and verified archive identify different releases")
    doi = archive["version_doi"]
    for name in PAGES:
        if not (site / name).is_file() or ("https://doi.org/" + doi).encode() not in pages[name]:
            raise ValueError(f"expected the verified version DOI in {name}")
    for name in PAGES:
        (site / name).write_bytes(pages[name])
    marker.update({
        "schema": "lean-info-theory.release3-citation-maintenance.v1",
        "purpose": "published-maintenance",
        "site_source_identity": source,
        "qualified_site_tree_sha256": base_tree,
        "maintained_pages": list(PAGES),
        "version_doi": doi,
    })
    path.write_bytes((json.dumps(marker, sort_keys=True, indent=2) + "\n").encode())
    return {
        "site_tree_sha256": tree_digest(site)[0],
        "qualified_site_tree_sha256": base_tree,
        "release_commit": archive["source_commit"],
        "maintenance_commit": source,
        "version_doi": doi,
        "maintained_sha256": {name: hashlib.sha256((site / name).read_bytes()).hexdigest()
                              for name in (*PAGES, ROOT_MARKER)},
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--site", required=True, type=Path)
    parser.add_argument("--decision", required=True, type=Path)
    parser.add_argument("--commit", required=True)
    args = parser.parse_args()

    def git(*arguments: str) -> bytes:
        return subprocess.check_output(["git", *arguments])

    if git("rev-parse", "HEAD").decode().strip() != args.commit:
        raise ValueError("maintenance source differs from the dispatch commit")

    def tracked(path: str) -> bytes:
        listing = git("ls-tree", args.commit, "--", path)
        if not listing.startswith(b"100644 blob ") or not listing.endswith(("\t" + path + "\n").encode()):
            raise ValueError("expected a tracked regular file: " + path)
        blob = git("show", args.commit + ":" + path)
        if Path(path).read_bytes() != blob:
            raise ValueError("checkout differs from reviewed source: " + path)
        return blob

    state = release.validate_state(strict_json(tracked(release.STATE_PATH)))
    if state["phase"] != "published-maintenance":
        raise ValueError("verified published-maintenance archive metadata is required")
    pins = strict_json(tracked(PINS))
    pages = {name: tracked("home_page/" + name) for name in PAGES}
    print(json.dumps(compose(args.site, strict_json(args.decision.read_bytes()), args.commit,
                             state["archive"], pins, pages), sort_keys=True))


if __name__ == "__main__":
    main()
