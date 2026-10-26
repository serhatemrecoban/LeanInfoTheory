"""Exact candidate retained contracts, separate from the immutable 601 baseline.

Capturing facts does not approve them. Canonical checks require a separately
reviewed digest envelope; experimental captures never establish a release.
"""

from __future__ import annotations

from pathlib import Path
import json
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
import check_public_api_compatibility as legacy
import release_state

SCHEMA = "lean-info-theory.candidate-retained-contract.v1"
APPROVAL_SCHEMA = "lean-info-theory.candidate-retained-approval.v1"
EXPORT_SCHEMA = "lean-info-theory.retained-types.v1"
OWN_INPUTS = (
    "scripts/compatibility/candidate_contract.py",
    "scripts/check_candidate_api_compatibility.py",
    "scripts/compatibility/test_candidate_contract.py",
    "scripts/compatibility/run_candidate_fixtures.py",
    "scripts/release_state.py", "scripts/current_api.py", "docs/current-public-api.json",
)
RECORD_FIELDS = {"name", "source_kind", "compiled_kind", "owner", "universe_parameters", "type"}
IDENTITY_FIELDS = {"schema", "target_version", "package_version", "current_route",
                   "stable_version", "stable_route", "reserved_route", "publishable"}
CONTRACT_FIELDS = {"schema", "release_identity", "manifest", "manifest_sha256",
                   "declaration_count", "declarations", "boundaries", "expected_boundaries",
                   "producer", "checkpoint", "limitations"}
APPROVAL_FIELDS = {"schema", "target_version", "artifact_path", "artifact_sha256",
                   "manifest_sha256", "declaration_count", "producer_sha256",
                   "export_checkpoint", "review_reference"}
LIMITATIONS = [
    "Exact types do not establish unchanged definition bodies or mathematical semantics.",
    "Cooperative source/build provenance is not hostile-process isolation.",
    "Capture is not approval, publication, independent review or clean-release qualification.",
]


def require(condition: bool, message: str) -> None:
    legacy.require(condition, "CANDIDATE_" + message)


def object_fields(value, fields: set[str], label: str) -> None:
    require(isinstance(value, dict) and set(value) == fields, f"SCHEMA: {label} fields")


def digest(value, label: str) -> None:
    require(isinstance(value, str) and re.fullmatch(r"[0-9a-f]{64}", value) is not None,
            f"SCHEMA: {label} SHA256")


def portable_path(value, label: str) -> None:
    require(isinstance(value, str) and bool(value) and "\\" not in value
            and not value.startswith("/") and ":" not in value
            and all(part not in {"", ".", ".."} for part in value.split("/")),
            f"SCHEMA: {label} portable relative path")


def identity_projection(identity: dict) -> dict:
    """Lifecycle observations are provenance, not a self-referential producer input."""
    object_fields(identity, IDENTITY_FIELDS | {"phase", "retention", "state_sha256"},
                  "observed release identity")
    require(identity["schema"] == "lean-info-theory.candidate-release-identity.v1"
            and identity["target_version"] == release_state.TARGET_VERSION
            and identity["stable_version"] == release_state.STABLE_VERSION
            and identity["phase"] in {"preparation", "candidate"}
            and identity["retention"] in {"pending", "established"}
            and identity["publishable"] is False,
            "IDENTITY: invalid candidate release identity")
    require(identity["package_version"] == (release_state.STABLE_VERSION
            if identity["phase"] == "preparation" else release_state.TARGET_VERSION),
            "IDENTITY: package version and phase disagree")
    require(identity["current_route"] == "/docs/current/"
            and identity["stable_route"] == "/docs/v0.1.0/"
            and identity["reserved_route"] == "/docs/v0.2.0/",
            "IDENTITY: unsupported candidate routes")
    digest(identity["state_sha256"], "observed state")
    return {key: identity[key] for key in sorted(IDENTITY_FIELDS)}


def compiler_identity(value: str) -> dict[str, str]:
    """Keep target provenance while comparing the exact compiler and build mode."""
    require(isinstance(value, str), "COMPILER: missing compiler observation")
    match = re.fullmatch(
        r"Lean \(version ([0-9]+\.[0-9]+\.[0-9]+), ([A-Za-z0-9_.+\-]+), "
        r"commit ([0-9a-f]{40}), (Release|Debug)\)", value)
    require(match is not None and match.group(1) == "4.33.1"
            and match.group(3) == legacy.LEAN_COMMIT,
            f"COMPILER: unexpected effective compiler {value}")
    return {"version": match.group(1), "commit": match.group(3), "build_mode": match.group(4)}


def producer_comparison_identity(producer: dict) -> dict:
    return {**producer, "compiler": compiler_identity(producer["compiler"])}


def validate_export(raw: bytes, manifest: dict) -> list[dict]:
    """Require all and only the complete ordered supplied inventory, not 601."""
    data = legacy.strict_json(raw)
    object_fields(data, {"schema", "declarations"}, "export")
    require(data["schema"] == EXPORT_SCHEMA, "SCHEMA: exporter schema")
    expected = manifest.get("declarations") if isinstance(manifest, dict) else None
    require(isinstance(expected, list) and bool(expected), "INVENTORY: empty manifest")
    require(all(isinstance(entry, dict) and isinstance(entry.get("name"), str)
                and isinstance(entry.get("module"), str)
                and entry.get("kind") in {"def", "abbrev", "theorem", "instance"}
                for entry in expected), "INVENTORY: malformed source declaration")
    names = [entry["name"] for entry in expected]
    require(len(set(names)) == len(names), "INVENTORY: duplicate source name")
    records = data["declarations"]
    require(isinstance(records, list) and len(records) == len(expected),
            "INVENTORY: export must cover the complete current declaration count")
    require(all(isinstance(record, dict) and set(record) == RECORD_FIELDS for record in records),
            "SCHEMA: retained declaration fields")
    require([record["name"] for record in records] == names,
            "INVENTORY: export names/order differ from complete inventory")
    for record, entry in zip(records, expected, strict=True):
        kinds = {"theorem", "definition"} if entry["kind"] == "instance" else (
            {"theorem"} if entry["kind"] == "theorem" else {"definition"})
        require(record["source_kind"] == entry["kind"] and record["owner"] == entry["module"]
                and record["compiled_kind"] in kinds,
                f"INVENTORY: ownership/kind mismatch for {entry['name']}")
    legacy.check_record_types(records)
    return records


def compare_declarations(old: list[dict], current: list[dict]) -> None:
    require([record["name"] for record in old] == [record["name"] for record in current],
            "INVENTORY: retained names/order changed")
    for left, right in zip(old, current, strict=True):
        difference = legacy.first_difference(left, right)
        if difference:
            path, before, after = difference
            shown = lambda value: legacy.encode(value).decode("utf-8").strip()[:220]
            raise ValueError(f"CANDIDATE_TYPE: {left['name']} at {path}; "
                             f"old={shown(before)}; current={shown(after)}")


def excluded_producer_paths() -> set[str]:
    return {release_state.STATE_PATH, release_state.CANDIDATE_CONTRACT_PATH,
            release_state.CANDIDATE_APPROVAL_PATH}


def producer_identity(root: Path = ROOT) -> dict[str, str]:
    """Output-free source identity, deliberately distinct from validation identity."""
    root = Path(root).absolute()
    require(not (root / "lakefile.lean").exists(), "INPUT: alternate effective Lake configuration")
    paths = set(legacy.INPUTS) | set(OWN_INPUTS)
    paths |= {path.relative_to(root).as_posix() for path in (root / "LeanInfoTheory").rglob("*.lean")}
    paths.add("LeanInfoTheory.lean")
    paths -= excluded_producer_paths()
    result = {}
    for rel in sorted(paths):
        portable_path(rel, "producer input")
        path = root / rel
        require(path.is_file() and path.resolve() == path.absolute(),
                f"INPUT: missing or redirected producer input {rel}")
        result[rel] = legacy.sha256(path.read_bytes())
    return result


def portable_boundaries(expected: dict, compiled: dict) -> dict:
    """Validate actual paths first, then retain their portable module correspondence."""
    legacy.current_policy.compare_compiled_policy(expected, compiled)
    portable = dict(compiled)
    portable["olean_paths"] = [
        {"module": entry["module"], "expected": entry["module"].replace(".", "/") + ".olean",
         "resolved": entry["module"].replace(".", "/") + ".olean"}
        for entry in compiled["olean_paths"]]
    return portable


def validate_contract(contract: dict) -> dict:
    object_fields(contract, CONTRACT_FIELDS, "contract")
    require(contract["schema"] == SCHEMA, "SCHEMA: contract schema")
    identity_projection(contract["release_identity"])
    manifest = contract["manifest"]
    records = validate_export(legacy.encode({"schema": EXPORT_SCHEMA,
                              "declarations": contract["declarations"]}), manifest)
    require(type(contract["declaration_count"]) is int
            and contract["declaration_count"] == len(records)
            and manifest.get("declaration_count") == len(records), "INVENTORY: contract count")
    digest(contract["manifest_sha256"], "manifest")
    require(contract["manifest_sha256"] == legacy.sha256(
        (json.dumps(manifest, indent=2, sort_keys=True) + "\n").encode("utf-8")),
        "INVENTORY: manifest digest does not bind the stored manifest")
    legacy.current_policy.compare_compiled_policy(contract["expected_boundaries"], contract["boundaries"])
    require(sorted((entry["name"], entry["owner"])
                   for entry in contract["expected_boundaries"]["declarations"])
            == sorted((entry["name"], entry["module"]) for entry in manifest["declarations"])
            and contract["expected_boundaries"]["supported_modules"] == manifest["supported_modules"],
            "BOUNDARY: type inventory differs from compiled boundary inventory")
    for entry in contract["boundaries"]["olean_paths"]:
        wanted = entry["module"].replace(".", "/") + ".olean"
        require(entry["expected"] == entry["resolved"] == wanted,
                "BOUNDARY: nonportable module output identity")
    producer = contract["producer"]
    object_fields(producer, {"files", "dependencies", "compiler", "exporter_sha256"}, "producer")
    require(isinstance(producer["files"], dict) and bool(producer["files"]), "INPUT: empty producer map")
    for rel, value in producer["files"].items():
        portable_path(rel, "producer input")
        require(rel not in excluded_producer_paths(), "INPUT: recursive producer output/state")
        digest(value, "producer " + rel)
    require(set(OWN_INPUTS) <= set(producer["files"]), "INPUT: missing candidate machinery")
    require(isinstance(producer["dependencies"], dict) and bool(producer["dependencies"]),
            "INPUT: empty dependency identity")
    for name, revision in producer["dependencies"].items():
        require(isinstance(name, str) and re.fullmatch(r"[A-Za-z0-9_-]+", name) is not None
                and isinstance(revision, str) and re.fullmatch(r"[0-9a-f]{40}", revision) is not None,
                "INPUT: malformed dependency identity")
    compiler_identity(producer["compiler"])
    digest(producer["exporter_sha256"], "exporter")
    require(producer["files"].get("scripts/compatibility/ExportRetained.lean") == producer["exporter_sha256"],
            "INPUT: exporter identities differ")
    require(producer["files"].get("docs/current-public-api.json") == contract["manifest_sha256"],
            "INPUT: producer manifest differs")
    checkpoint = contract["checkpoint"]
    object_fields(checkpoint, {"kind", "head", "tree", "clean"}, "export checkpoint")
    require(type(checkpoint["clean"]) is bool, "CHECKPOINT: invalid cleanliness flag")
    if checkpoint["kind"] == "git":
        require(all(isinstance(checkpoint[key], str) and re.fullmatch(r"[0-9a-f]{40}", checkpoint[key])
                    for key in ("head", "tree")), "CHECKPOINT: invalid exact Git identity")
    else:
        require(checkpoint == {"kind": "isolated-copy", "head": None, "tree": None, "clean": False},
                "CHECKPOINT: invalid isolated capture")
    require(contract["limitations"] == LIMITATIONS, "SCHEMA: limitations changed")
    return contract


def compare_contracts(baseline: dict, current: dict) -> None:
    validate_contract(baseline)
    validate_contract(current)
    # The freshly compiled type comparison deliberately precedes source hashes:
    # a compiling API mutation must produce a named structural diagnosis.
    compare_declarations(baseline["declarations"], current["declarations"])
    for label, old, new in (
        ("IDENTITY", identity_projection(baseline["release_identity"]),
         identity_projection(current["release_identity"])),
        ("INVENTORY", baseline["manifest"], current["manifest"]),
        ("BOUNDARY", baseline["boundaries"], current["boundaries"]),
        ("POLICY", baseline["expected_boundaries"], current["expected_boundaries"]),
        ("PROVENANCE", producer_comparison_identity(baseline["producer"]),
         producer_comparison_identity(current["producer"])),
    ):
        difference = legacy.first_difference(old, new)
        require(difference is None, f"{label}: retained contract differs at {difference[0] if difference else ''}")


def validate_approval(approval: dict, raw: bytes, contract: dict) -> None:
    object_fields(approval, APPROVAL_FIELDS, "approval")
    require(approval["schema"] == APPROVAL_SCHEMA
            and approval["target_version"] == release_state.TARGET_VERSION
            and approval["artifact_path"] == release_state.CANDIDATE_CONTRACT_PATH,
            "APPROVAL: wrong schema/version/artifact path")
    require(approval["artifact_sha256"] == legacy.sha256(raw), "APPROVAL: artifact digest mismatch")
    require(approval["manifest_sha256"] == contract["manifest_sha256"]
            and type(approval["declaration_count"]) is int
            and approval["declaration_count"] == contract["declaration_count"]
            and approval["producer_sha256"] == legacy.sha256(legacy.encode(contract["producer"]))
            and approval["export_checkpoint"] == contract["checkpoint"],
            "APPROVAL: reviewed identity does not match captured artifact")
    require(contract["checkpoint"]["kind"] == "git" and contract["checkpoint"]["clean"] is True,
            "APPROVAL: experimental/dirty capture cannot establish a canonical baseline")
    require(contract["release_identity"]["phase"] == "candidate"
            and contract["release_identity"]["package_version"] == release_state.TARGET_VERSION,
            "APPROVAL: preparation capture cannot establish the candidate baseline")
    reference = approval["review_reference"]
    require(isinstance(reference, str) and bool(reference.strip()) and "\n" not in reference
            and reference.startswith(".lit-review/"), "APPROVAL: missing explicit independent review reference")
    portable_path(reference, "review reference")


def load_approved_snapshot(root: Path = ROOT) -> tuple[dict, bytes, bytes]:
    """Return the parsed contract and the exact bytes validated in this load."""
    identity = release_state.contract_identity(root)
    require(identity["retention"] == "established", "NOT_ESTABLISHED: complete candidate retention is pending")
    path = root / release_state.CANDIDATE_CONTRACT_PATH
    approval_path = root / release_state.CANDIDATE_APPROVAL_PATH
    for item in (path, approval_path):
        require(item.is_file() and item.resolve() == item.absolute(), "APPROVAL: missing/redirected input")
    raw = path.read_bytes()
    contract = validate_contract(legacy.strict_json(raw))
    approval_raw = approval_path.read_bytes()
    validate_approval(legacy.strict_json(approval_raw), raw, contract)
    _, historical = legacy.load_baseline()
    require(contract["producer"]["dependencies"] == historical["dependencies"]
            and contract["producer"]["exporter_sha256"] == historical["exporter"]["sha256"],
            "APPROVAL: capture differs from immutable dependency/exporter pins")
    require(identity_projection(contract["release_identity"]) == identity_projection(identity),
            "IDENTITY: approved capture differs from current candidate identity")
    return contract, raw, approval_raw


def load_approved_contract(root: Path = ROOT) -> dict:
    return load_approved_snapshot(root)[0]
