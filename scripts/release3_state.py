"""Verify Release 3 package and citation inputs independently of the historical v0.2 policy."""

from __future__ import annotations

from datetime import date
import hashlib
from pathlib import Path
import re
import subprocess

from release_state import require_file, strict_json
import release_state as historical

ROOT = Path(__file__).resolve().parents[1]
STATE_PATH = "docs/compatibility/v0.3.0-release-state.json"
CONTRACT_PATH = "docs/compatibility/v0.3.0-candidate-contract.json"
APPROVAL_PATH = "docs/compatibility/v0.3.0-candidate-approval.json"
REVIEW_PATH = "docs/v0.3-release-contract.md"
TAG = "v0.3.0"
MAIN_URL = "https://serhatemrecoban.github.io/LeanInfoTheory/"
API_REPOSITORY = "serhatemrecoban/LeanInfoTheory-API-v0.3.0"
API_URL = "https://serhatemrecoban.github.io/LeanInfoTheory-API-v0.3.0/v0.3.0/"
CONCEPT_DOI = "10.5281/zenodo.22229598"
PREVIOUS_DOIS = {"10.5281/zenodo.22229599", "10.5281/zenodo.23973538"}
FIXED = {
    "schema": "lean-info-theory.release-3-state.v1",
    "target_version": TAG[1:],
    "main_url": MAIN_URL,
    "api_repository": API_REPOSITORY,
    "api_url": API_URL,
}
# The two tagged reference files, and the subsequently published v0.2.0 CFF.
V02_LAKE_SHA256 = "6e50c6730196e09a2694da3fac8c87fb1645f8cca82566d3aef03cd4c73bef76"
V02_TAGGED_CFF_SHA256 = "ffd04d0da8613dfca7f8438ce9fac7a488f6536a0b9cebc397ada9dbf3d21a92"
V02_PUBLISHED_CFF_SHA256 = "ad7b7e05b782477f483f801fee615e00a5be1c6e97847b1e554753e9e931f154"
V02_REFERENCE = {
    historical.STATE_PATH: "ee3dfaef11a72dd456735a8dd807fe556d28a19735dfc69a01afe020bd581ad5",
    historical.CANDIDATE_CONTRACT_PATH: "740c5b4f165fe1b0b35b75d94f8900103dfa85fbf94732b2a300c4e4f2766921",
    historical.CANDIDATE_APPROVAL_PATH: "46c5f5f47c160d011617dc6ff5bfabc77e2163bde4b7f4e40a7813b4b3ab5600",
}
IDENTITY_SCHEMA = "lean-info-theory.release-3-metadata-identity.v1"


def identity_projection(identity: dict) -> dict:
    fixed = {**FIXED, "schema": IDENTITY_SCHEMA, "historical_v0.2.0": V02_REFERENCE, "publishable": False}
    observed = {"phase", "package_version", "state_sha256", "citation_sha256"}
    if (set(identity) != set(fixed) | observed or identity.get("publishable") is not False
            or any(identity[k] != v for k, v in fixed.items())):
        raise ValueError("invalid Release 3 producer identity or historical reference")
    phase = identity["phase"]
    if phase not in ("preparation", "candidate-ready", "published-maintenance"):
        raise ValueError("invalid Release 3 producer phase")
    version = "0.2.0" if phase == "preparation" else TAG[1:]
    if identity["package_version"] != version:
        raise ValueError("producer package version differs from its metadata phase")
    for key in ("state_sha256", "citation_sha256"):
        if not isinstance(identity[key], str) or not re.fullmatch("[a-f0-9]{64}", identity[key]):
            raise ValueError("invalid release metadata digest")
    return {**fixed, "package_version": version}


def contract_identity(root: Path) -> dict:
    state = check_metadata(root)
    for path, expected in V02_REFERENCE.items():
        if hashlib.sha256(require_file(root, path).read_bytes()).hexdigest() != expected:
            raise ValueError(f"modified historical v0.2.0 policy or retained reference: {path}")
    identity = {**FIXED, "schema": IDENTITY_SCHEMA, "phase": state["phase"],
                "package_version": "0.2.0" if state["phase"] == "preparation" else TAG[1:],
                "state_sha256": hashlib.sha256(require_file(root, STATE_PATH).read_bytes()).hexdigest(),
                "citation_sha256": hashlib.sha256(require_file(root, "CITATION.cff").read_bytes()).hexdigest(),
                "historical_v0.2.0": dict(V02_REFERENCE), "publishable": False}
    identity_projection(identity)
    return identity


def validate_state(state: object) -> dict:
    if not isinstance(state, dict) or any(state.get(k) != v for k, v in FIXED.items()):
        raise ValueError("unexpected Release 3 version, schema, or documentation destination")
    phase = state.get("phase")
    if phase not in ("preparation", "candidate-ready", "published-maintenance"):
        raise ValueError("unknown Release 3 metadata phase")
    fields = set(FIXED) | {"phase"}
    if phase != "preparation":
        fields.add("release_date")
        issued = state.get("release_date")
        if not isinstance(issued, str) or not re.fullmatch(r"[0-9]{4}-[0-9]{2}-[0-9]{2}", issued):
            raise ValueError("an explicit ISO issue date is required")
        if date.fromisoformat(issued) <= date(2026, 11, 5):
            raise ValueError("issue date must follow v0.2.0")
        if phase == "published-maintenance" or "retained_api" in state:
            fields.add("retained_api")
            pins = state.get("retained_api")
            if (not isinstance(pins, dict) or set(pins) != {CONTRACT_PATH, APPROVAL_PATH}
                    or not all(isinstance(v, str) and re.fullmatch(r"[0-9a-f]{64}", v)
                               for v in pins.values())):
                raise ValueError("invalid reviewed v0.3.0 retained API digests")
    if phase == "published-maintenance":
        fields.add("archive")
        archive = state.get("archive")
        expected = {"version_doi", "concept_doi", "archive_sha256", "tag_object", "source_commit", "git_tree"}
        if not isinstance(archive, dict) or set(archive) != expected:
            raise ValueError("published maintenance requires the reviewed archive and tag identities")
        doi = archive["version_doi"]
        if not isinstance(doi, str) or not re.fullmatch(r"10\.5281/zenodo\.[1-9][0-9]*", doi):
            raise ValueError("invalid Zenodo version DOI")
        if archive["concept_doi"] != CONCEPT_DOI or doi in PREVIOUS_DOIS | {CONCEPT_DOI}:
            raise ValueError("the new version DOI and existing all-versions DOI must be distinct")
        for key in ("archive_sha256", "tag_object", "source_commit", "git_tree"):
            length = 64 if key == "archive_sha256" else 40
            if not isinstance(archive[key], str) or not re.fullmatch("[a-f0-9]{%d}" % length, archive[key]):
                raise ValueError(f"invalid archive verification field: {key}")
    if set(state) != fields:
        raise ValueError(f"unexpected or missing fields for {phase} metadata")
    return state


def load_state(root: Path = ROOT) -> dict:
    return validate_state(strict_json(require_file(root, STATE_PATH).read_bytes()))


def verify_projected_input(raw: bytes, replacements: dict[bytes, bytes], digest: str, name: str) -> None:
    """Accept exactly the canonical reference bytes plus the reviewed whole-line edits."""
    for line, replacement in replacements.items():
        if raw.count(line) != 1:
            raise ValueError(f"unexpected {name} metadata")
        raw = raw.replace(line, replacement, 1)
    if hashlib.sha256(raw).hexdigest() != digest:
        raise ValueError(f"{name} differs from the historical bytes beyond the allowed release fields")


def check_metadata(root: Path = ROOT) -> dict:
    state = load_state(root)
    phase = state["phase"]
    package = require_file(root, "lakefile.toml").read_bytes()
    citation = require_file(root, "CITATION.cff").read_bytes()
    version_edits = {} if phase == "preparation" else {b'\nversion = "0.3.0"\n': b'\nversion = "0.2.0"\n'}
    verify_projected_input(package, version_edits, V02_LAKE_SHA256, "lakefile.toml")
    if any(p.exists() or p.is_symlink() for p in (root / "lakefile.lean", root / ".zenodo.json")):
        raise ValueError("alternate package configuration or Zenodo override")
    if phase == "preparation":
        verify_projected_input(citation, {}, V02_PUBLISHED_CFF_SHA256, "CITATION.cff")
        return state
    lines = {b'version: "0.3.0"\n': b'version: "0.2.0"\n',
             f'date-released: {state["release_date"]}\n'.encode(): b'date-released: 2026-11-05\n'}
    if phase == "published-maintenance":
        doi_line = f'doi: "{state["archive"]["version_doi"]}"\n'.encode()
        lines[doi_line + b"authors:\n"] = b"authors:\n"
    verify_projected_input(citation, lines, V02_TAGGED_CFF_SHA256, "CITATION.cff")
    if phase == "published-maintenance":
        archive = state["archive"]
        check_tag(root, state["release_date"], archive["tag_object"], archive["source_commit"],
                  citation.replace(doi_line, b""), package, tree=archive["git_tree"])
    return state


def check_tag(root: Path, release_date: str, tag_object: str, source_commit: str,
              tagged_citation: bytes, package: bytes, *, tree: str | None = None) -> None:
    """Check local tag provenance for post-tag promotion and subsequent DOI maintenance."""
    ref = "refs/tags/" + TAG

    def git(*args: str) -> bytes:
        command = subprocess.run(["git", *args], cwd=root, capture_output=True)
        if command.returncode != 0:
            raise ValueError(f"cannot verify immutable {TAG}: {' '.join(args)}")
        return command.stdout

    expected_refs = {"tag": tag_object, "commit": source_commit}
    if tree is not None:
        expected_refs["tree"] = tree
    for kind, expected in expected_refs.items():
        if git("rev-parse", f"{ref}^{{{kind}}}").decode().strip() != expected:
            raise ValueError("verification identifies a different Git tag, commit, or tree")
    git("merge-base", "--is-ancestor", source_commit, "HEAD")
    candidate_state = validate_state(strict_json(git("show", ref + ":" + STATE_PATH)))
    current = load_state(root)
    if "retained_api" not in current:
        raise ValueError("the release tag requires reviewed v0.3.0 retained API digests")
    expected = {**FIXED, "phase": "candidate-ready", "release_date": release_date,
                "retained_api": current["retained_api"]}
    if candidate_state != expected:
        raise ValueError("tagged candidate differs from the release date, destinations or retained API digests")
    if git("show", ref + ":CITATION.cff") != tagged_citation or git("show", ref + ":lakefile.toml") != package:
        raise ValueError("published metadata differs from the DOI-free tagged package")
