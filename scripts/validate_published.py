"""Validate post-publication maintenance against the immutable v0.2.0 release."""
from __future__ import annotations

import argparse
import hashlib
from html.parser import HTMLParser
from pathlib import Path
import subprocess
import sys
import tempfile

import validate_release as release

ROOT = release.ROOT
SOURCE = "953b785fbdbcc9bffe22834124d5e1cbd14a4835"
TAG = "c3ffcc3e8fd826e19ba354b169b4610d8b8f10c5"
DOI = "10.5281/zenodo.23973538"
WORKFLOW = "https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/promote-release-pages.yml"
# These files are historical release evidence or the fixed package/legal inputs.
# Current documentation and development work use the normal source checks below.
FROZEN_PATHS = (
    ".gitattributes", "LICENSE", "lean-toolchain", "lakefile.toml", "lake-manifest.json",
    "docs/releases/v0.1.0.md", "docs/releases/v0.2.0-publication.md",
    "docs/v0.1-release-contract.md", "docs/v0.1-legal-metadata-audit.md",
    "docs/compatibility/candidate-release-state.json", "home_page/docs/v0.1.0",
    ".github/workflows/pages.yml", ".github/workflows/update.yml",
)
WORKFLOW_HASHES = {
    "lean_action_ci.yml": "0c1a3bec7d7c824f74c0e6a00b7b26c1fd87da3a43dcc22271a69029f159e329",
    "promote-release-pages.yml": "6c14d7d5dd86344a65366fd42fb6c5266aa6934df9f4e84f1a785b72e09c6a93",
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def git(*args: str) -> bytes:
    return subprocess.check_output(["git", *args], cwd=ROOT)


class Page(HTMLParser):
    def __init__(self, path: Path):
        super().__init__()
        self.meta: dict[str, list[str]] = {}
        self.links: list[str] = []
        self.images: list[str] = []
        self.feed(path.read_text(encoding="utf-8"))

    def handle_starttag(self, tag, attrs):
        values = dict(attrs)
        if tag == "meta" and "name" in values:
            self.meta.setdefault(values["name"], []).append(values.get("content", ""))
        if tag == "a":
            self.links.append(values.get("href", ""))
        if tag == "img":
            self.images.append(values.get("src", ""))


def check_maintenance() -> None:
    require(git("rev-parse", "v0.2.0").decode().strip() == TAG and
            git("rev-parse", "v0.2.0^{commit}").decode().strip() == SOURCE,
            "Fetch the immutable v0.2.0 tag before validating maintenance.")
    changed = git("diff", "--name-only", "-z", SOURCE, "--", *FROZEN_PATHS)
    require(not changed, "Immutable release evidence or fixed package inputs changed: " +
            ", ".join(p.decode() for p in changed.split(b"\0") if p))
    workflows = ROOT / ".github/workflows"
    found = {p.name for p in workflows.iterdir() if p.suffix in {".yml", ".yaml"}}
    require(found == set(WORKFLOW_HASHES) | {"pages.yml", "update.yml"},
            "Review changes to the set of GitHub workflows")
    require(not git("ls-files", "--", "docs/next-website-tasks.md", ".zenodo.json", "NOTICE"),
            "Unexpected tracked private file or publication metadata")
    require(not (ROOT / ".zenodo.json").exists() and not (ROOT / "NOTICE").exists(),
            "Unexpected post-release licensing or Zenodo override")
    for name, digest in WORKFLOW_HASHES.items():
        data = (ROOT / ".github/workflows" / name).read_bytes()
        require(hashlib.sha256(data).hexdigest() == digest, f"Review changed workflow: {name}")
    tagged = git("show", SOURCE + ":CITATION.cff")
    require(tagged.count(b"authors:\n") == 1 and b"\ndoi:" not in tagged, "Unexpected tagged CFF")
    expected = tagged.replace(b"authors:\n", f'doi: "{DOI}"\nauthors:\n'.encode())
    require((ROOT / "CITATION.cff").read_bytes() == expected, "Incorrect v0.2.0 citation")
    doi_url = "https://doi.org/" + DOI
    for name in ("index.html", "license.html"):
        page = Page(ROOT / "home_page" / name)
        require(page.meta.get("citation_doi") == [DOI] and
                page.meta.get("citation_publication_date") == ["2026-11-05"] and
                page.meta.get("citation_author") == ["Coban, Serhat Emre"] and
                doi_url in page.links, f"Incorrect visible or indexed citation: {name}")
        if name == "index.html":
            require(WORKFLOW in page.links and WORKFLOW + "/badge.svg" in page.images,
                    "Homepage badge must link to the current deployment")
    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    rights_holder = "École polytechnique fédérale de Lausanne (EPFL)"
    license_page = (ROOT / "home_page/license.html").read_text(encoding="utf-8")
    for text in (readme, license_page):
        require(rights_holder in " ".join(text.split()), "Missing EPFL rights-holder attribution")
    for marker in (doi_url, 'rev = "v0.2.0"', "811 supported declarations. 57 supported modules.",
                   WORKFLOW + "/badge.svg", "youtu.be/CXHebbD7ouA", "#pfr-case-study"):
        require(marker in readme, f"Missing release information in README: {marker}")
    print("Published metadata, release boundaries and reviewed manual deployment passed.", flush=True)


def check_static() -> None:
    check_maintenance()
    # Pre-publication fixtures expect the original, DOI-free tagged pages and CFF.
    # Exercise those fixtures on their actual source, then test the maintained checkout.
    scratch = ROOT / "tmp"
    scratch.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(dir=scratch, prefix="v02-tag-") as temp:
        ref = Path(temp) / "ref"
        subprocess.run(["git", "clone", "--quiet", "--shared", "--no-checkout", str(ROOT), str(ref)], check=True)
        subprocess.run(["git", "checkout", "--quiet", "--detach", SOURCE], cwd=ref, check=True)
        (ref / "tmp").mkdir(exist_ok=True)
        subprocess.run([sys.executable, "scripts/validate_release.py", "metadata"], cwd=ref, check=True)
        subprocess.run([sys.executable, "scripts/test_release_state.py"], cwd=ref, check=True)
    release.check_lean_source()
    release.load_public_manifest()
    release.check_toolchain_contract()
    release.check_docbuild_contract()
    release.check_candidate_release_contract()
    release.check_release_documentation_contract()
    release.check_generated_artifacts()
    release.check_hygiene()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("all", "static"), default="all", nargs="?")
    full = parser.parse_args().command == "all"
    if full:
        release.check_clean_repository_state("before checking the published release")
    check_static()
    if full:
        release.run_complete_build()
        release.check_documentation_examples()
        release.check_trust_contract()
        release.check_hygiene(require_clean=True)


if __name__ == "__main__":
    main()
