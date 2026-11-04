#!/usr/bin/env python3
"""Capture or check the complete unpublished candidate retained contract.

Capture writes a new ignored experimental artifact, never approval. Normal
checks use only the canonical separately approved artifact. The historical
601-declaration checker remains a distinct, unchanged release-baseline path.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
sys.path.insert(0, str(ROOT / "scripts/compatibility"))
import check_public_api_compatibility as legacy
import candidate_contract as candidate
import current_api
import release_state


def checkpoint(evidence: legacy.RunEvidence, label: str) -> dict:
    # An ignored nested source copy must not borrow its containing checkout's HEAD.
    if not (ROOT / ".git").exists():
        return {"kind": "isolated-copy", "head": None, "tree": None, "clean": False}
    head = evidence.run(label + "-head", ["git", "rev-parse", "HEAD"]).decode().strip()
    tree = evidence.run(label + "-tree", ["git", "rev-parse", "HEAD^{tree}"]).decode().strip()
    status = evidence.run(label + "-status", ["git", "status", "--porcelain", "--untracked-files=all"])
    return {"kind": "git", "head": head, "tree": tree, "clean": not bool(status.strip())}


def fresh_contract(evidence: legacy.RunEvidence, *, deterministic: bool) -> dict:
    """Own the compiler/build/export commands; never accept supplied success logs."""
    identity = release_state.contract_identity(ROOT)
    frozen, historical = legacy.load_baseline()
    release_state.check_legacy_configuration(ROOT, historical["release_source_sha256"])
    manifest = current_api.load_current_manifest()
    manifest_raw = (ROOT / "docs/current-public-api.json").read_bytes()
    before = candidate.producer_identity(ROOT)
    dependencies = legacy.retained.dependency_identity(ROOT)
    candidate.require(dependencies == historical["dependencies"], "INPUT: historical dependency pins differ")
    start = checkpoint(evidence, "checkpoint-before")
    if deterministic and start["clean"] and identity["phase"] in release_state.SECOND_RELEASE_PHASES:
        release_state.require_candidate_content(ROOT)
    legacy.unredirected_tree(ROOT / ".lake/build")
    evidence.write("producer-before.json", {"files": before, "dependencies": dependencies,
                                           "release_identity": identity, "checkpoint": start})
    evidence.write("current-manifest.json", manifest)
    expected = legacy.current_policy.validate_source_policy(
        frozen, historical, manifest, legacy.direct_source_imports(),
        legacy.strict_json(legacy.POLICY.read_bytes()))
    evidence.write("expected-boundaries.json", expected)
    version = evidence.run("compiler", ["lake", "env", "lean", "--version"]).decode("utf-8").strip()
    candidate.compiler_identity(version)
    evidence.run("build", ["lake", "--wfail", "build", "LeanInfoTheory.Shannon"])
    command = ["lake", "env", "lean", "-DwarningAsError=true", "--run",
               str(legacy.retained.EXPORTER), str(evidence.path / "current-manifest.json")]
    exported = evidence.run("candidate-types", command)
    records = candidate.validate_export(exported, manifest)
    if deterministic:
        again = evidence.run("candidate-types-repeat", command)
        candidate.require(exported == again, "DETERMINISM: repeated complete exports differ")
    old_names = {entry["name"] for entry in frozen["declarations"]}
    legacy.compare_types(historical, legacy.encode({"schema": candidate.EXPORT_SCHEMA,
        "declarations": [entry for entry in records if entry["name"] in old_names]}), frozen)
    request = {"current_declarations": manifest["declarations"],
               "supported_modules": manifest["supported_modules"],
               "root_exports": expected["root_exports"],
               "project_build_root": str((ROOT / ".lake/build/lib/lean").resolve())}
    evidence.write("audit-input.json", request)
    driver = evidence.path / "CandidateBoundaryAudit.lean"
    with driver.open("xb") as output:
        output.write(legacy.assemble_driver())
    actual = legacy.strict_json(evidence.run("boundaries", [
        "lake", "env", "lean", "-DwarningAsError=true", "--run", str(driver),
        str(evidence.path / "audit-input.json")]))
    boundaries = candidate.portable_boundaries(expected, actual)
    after = candidate.producer_identity(ROOT)
    dependencies_after = legacy.retained.dependency_identity(ROOT)
    identity_after = release_state.contract_identity(ROOT)
    end = checkpoint(evidence, "checkpoint-after")
    evidence.write("producer-after.json", {"files": after, "dependencies": dependencies_after,
                                          "release_identity": identity_after, "checkpoint": end})
    candidate.require(before == after and dependencies == dependencies_after
                      and identity == identity_after and start == end,
                      "FRESHNESS: source/pins/state/checkpoint changed during build/export")
    legacy.unredirected_tree(ROOT / ".lake/build")
    return candidate.validate_contract({
        "schema": candidate.SCHEMA, "release_identity": identity,
        "manifest": manifest, "manifest_sha256": legacy.sha256(manifest_raw),
        "declaration_count": len(records), "declarations": records,
        "boundaries": boundaries, "expected_boundaries": expected,
        "producer": {"files": before, "dependencies": dependencies, "compiler": version,
                     "exporter_sha256": legacy.sha256(legacy.retained.EXPORTER.read_bytes())},
        "checkpoint": start, "limitations": candidate.LIMITATIONS,
    })


def capture_destination(output: Path, evidence: legacy.RunEvidence) -> Path:
    path = output.absolute()
    candidate.require(path.is_relative_to(ROOT) and path.parent.resolve() == path.parent.absolute(),
                      "OUTPUT: capture must be inside this unredirected checkout")
    relative = path.relative_to(ROOT).as_posix()
    candidate.require(relative.startswith(("tmp/", ".lit-review/")),
                      "OUTPUT: capture must use a new ignored tmp/ or .lit-review/ file")
    candidate.require(not path.exists() and not path.is_symlink(), "OUTPUT: capture never overwrites a file")
    evidence.run("ignored-output", ["git", "check-ignore", "--", relative])
    path.parent.mkdir(parents=True, exist_ok=True)
    return path


def run_check(evidence: legacy.RunEvidence) -> dict:
    state = release_state.load_state(ROOT)
    if state["phase"] == "historical":
        return {"outcome": "NOT_APPLICABLE", "retention": "not-applicable",
                "message": "Historical state has no candidate retained baseline."}
    identity = release_state.contract_identity(ROOT)
    if identity["retention"] == "pending":
        return {"outcome": "NOT_ESTABLISHED", "retention": "pending", "release_identity": identity,
                "message": "Complete candidate baseline capture/review belongs to C24.07; no retained-baseline PASS is claimed."}
    baseline, baseline_raw, approval_raw = candidate.load_approved_snapshot(ROOT)
    current = fresh_contract(evidence, deterministic=False)
    candidate.compare_contracts(baseline, current)
    candidate.require((ROOT / release_state.CANDIDATE_CONTRACT_PATH).read_bytes() == baseline_raw
                      and (ROOT / release_state.CANDIDATE_APPROVAL_PATH).read_bytes() == approval_raw,
                      "FRESHNESS: approved artifact/envelope changed during check")
    return {"outcome": "PASS", "retention": "established",
            "declaration_count": current["declaration_count"],
            "artifact_sha256": legacy.sha256(baseline_raw),
            "approval_sha256": legacy.sha256(approval_raw), "checkpoint": current["checkpoint"],
            "qualification": "Current structural compatibility; cleanliness/publication remain separate gates."}


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_subparsers(dest="mode")
    capture = modes.add_parser("capture", help="capture complete facts to a NEW ignored file; never approve")
    capture.add_argument("--output", required=True, type=Path)
    modes.add_parser("check", help="check only the canonical separately approved candidate baseline")
    args = parser.parse_args(argv)
    evidence = None
    try:
        evidence = legacy.RunEvidence()
        if args.mode == "capture":
            output = capture_destination(args.output, evidence)
            contract = fresh_contract(evidence, deterministic=True)
            raw = legacy.encode(contract)
            with output.open("xb") as destination:
                destination.write(raw)
            result = {"outcome": "CAPTURED_UNAPPROVED", "artifact_path": str(output),
                      "artifact_sha256": legacy.sha256(raw),
                      "declaration_count": contract["declaration_count"],
                      "checkpoint": contract["checkpoint"],
                      "qualification": "EXPERIMENT_ONLY until separately reviewed and canonically approved; capture never writes approval."}
        else:
            result = run_check(evidence)
        result.update({"schema": "lean-info-theory.candidate-compatibility-result.v1",
                       "commands": evidence.commands, "evidence_directory": str(evidence.path)})
        evidence.write("result.json", result)
        print(json.dumps(result, ensure_ascii=False, sort_keys=True), flush=True)
        return 0
    except (OSError, ValueError, KeyError, TypeError, RecursionError) as error:
        result = {"outcome": "FAIL", "diagnostic": str(error),
                  "commands": evidence.commands if evidence else [],
                  "evidence_directory": str(evidence.path) if evidence else None}
        if evidence:
            evidence.write("failure.json", result)
        print("candidate compatibility failed: " + json.dumps(result, ensure_ascii=False), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
    raise SystemExit(main())
