#!/usr/bin/env python3
"""Compare the evolving, compiled API with both released surfaces."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

import check_candidate_api_compatibility as exact

legacy = exact.legacy
candidate = exact.candidate
ROOT = exact.ROOT

# Exact bytes in the published v0.2.0 tag (953b785fbdbcc9bffe22834124d5e1cbd14a4835).
CONTRACT_SHA256 = "740c5b4f165fe1b0b35b75d94f8900103dfa85fbf94732b2a300c4e4f2766921"
APPROVAL_SHA256 = "46c5f5f47c160d011617dc6ff5bfabc77e2163bde4b7f4e40a7813b4b3ab5600"


def require_retained(previous: set, current: set, subject: str) -> None:
    missing = previous - current
    if missing:
        raise ValueError(f"V02_RETAINED: {subject} lost {sorted(missing)!r}")


def compare_retained(release: dict, current: dict) -> list[str]:
    """Both contracts have already passed complete inventory and compiled boundary audits."""
    previous = release["declarations"]
    retained_names = {entry["name"] for entry in previous}
    by_name = {entry["name"]: entry for entry in current["declarations"]}
    require_retained(retained_names, set(by_name), "declarations")
    candidate.compare_declarations(previous, [by_name[entry["name"]] for entry in previous])

    # The current-policy audit checks exact source/compiled agreement and requires
    # approvals for new owners, import lists, simp additions and facade exports.
    # Its historical checks start at v0.1.0; enforce v0.2.0 retention separately.
    old = release["boundaries"]
    new = current["boundaries"]
    require_retained(set(old["supported_modules"]), set(new["supported_modules"]), "modules")
    for owner in old["supported_modules"]:
        for group in ("local", "external"):
            # The validated expected maps exclude Lean's two implicit Init entries.
            former = release["expected_boundaries"]["direct_imports"][owner][group]
            now = current["expected_boundaries"]["direct_imports"][owner][group]
            require_retained(set(former), set(now), f"{owner} direct {group} imports")
        require_retained(set(old["module_closures"][owner]),
                         set(new["module_closures"][owner]), f"{owner} import closure")
        previously_visible = {entry["name"] for entry in old["focused_declarations"][owner]}
        now_visible = {entry["name"] for entry in new["focused_declarations"][owner]}
        require_retained(previously_visible, now_visible, f"{owner} focused declarations")
        # Approved imports can bring further simp lemmas into view. A retained
        # declaration that was visible here must keep its former simp status.
        if set(old["focused_simp"][owner]) != set(new["focused_simp"][owner]) & previously_visible:
            raise ValueError(f"V02_RETAINED: {owner} focused simp membership changed")

    if old["root_closure"] != new["root_closure"]:
        raise ValueError("V02_RETAINED: lightweight root closure changed")
    for key in ("root_exports", "root_resolutions"):
        former = {(entry["alias"], entry["target"]) for entry in old[key]}
        now = {(entry["alias"], entry["target"]) for entry in new[key]}
        require_retained(former, now, key)
    return sorted(set(by_name) - retained_names)


def run_check(evidence: legacy.RunEvidence) -> dict:
    own_source = Path(__file__).resolve()
    own_digest = legacy.sha256(own_source.read_bytes())
    release, artifact, approval = candidate.load_approved_snapshot(ROOT)
    legacy.require(legacy.sha256(artifact) == CONTRACT_SHA256 and
                   legacy.sha256(approval) == APPROVAL_SHA256,
                   "V02_BASELINE: contract or approval differs from the published v0.2.0 bytes")

    third = None
    if (ROOT / exact.r3.STATE_PATH).exists() and exact.r3.load_state(ROOT)["phase"] != "preparation":
        third = candidate.load_release3_snapshot(ROOT)

    # Build once, serialize all current types once, run the independent 601
    # comparison on its own historical records, and audit all focused imports.
    # The producer fingerprint must be stable during this run, but can evolve.
    current = exact.fresh_contract(evidence, deterministic=False)
    if candidate.compiler_identity(current["producer"]["compiler"]) != candidate.compiler_identity(
            release["producer"]["compiler"]):
        raise ValueError("V02_RETAINED: compiler identity changed")
    added_names = compare_retained(release, current)
    third_result = {}
    if third is not None:
        frozen, frozen_raw, review_raw = third
        candidate.compare_contracts(frozen, current)
        candidate.recheck_release3_snapshot(ROOT, frozen_raw, review_raw)
        third_result = {"v0.3.0_retained": frozen["declaration_count"],
                        "v0.3.0_contract_sha256": legacy.sha256(frozen_raw),
                        "v0.3.0_approval_sha256": legacy.sha256(review_raw)}
    legacy.require((ROOT / exact.release_state.CANDIDATE_CONTRACT_PATH).read_bytes() == artifact and
                   (ROOT / exact.release_state.CANDIDATE_APPROVAL_PATH).read_bytes() == approval and
                   legacy.sha256(own_source.read_bytes()) == own_digest,
                   "FRESHNESS: development checker or frozen contract/approval changed during comparison")
    return {
        **third_result,
        "outcome": "PASS",
        "v0.1.0_retained": 601,
        "v0.2.0_retained": release["declaration_count"],
        "current_declarations": current["declaration_count"],
        "added_names_since_v0.2.0": added_names,
        "v0.2.0_contract_sha256": CONTRACT_SHA256,
        "v0.2.0_approval_sha256": APPROVAL_SHA256,
        "development_checker_sha256": own_digest,
        "current_producer_sha256": legacy.sha256(legacy.encode(current["producer"])),
        "checkpoint": current["checkpoint"],
        "qualification": "Compiled structural compatibility. Mathematical semantics and step approval require review.",
    }


def main() -> int:
    argparse.ArgumentParser(description=__doc__).parse_args()
    evidence = legacy.RunEvidence()
    try:
        result = run_check(evidence)
    except (OSError, ValueError, KeyError, TypeError, RecursionError) as error:
        result = {"outcome": "FAIL", "diagnostic": str(error)}
    result.update({"schema": "lean-info-theory.development-compatibility-result.v1",
                   "commands": evidence.commands, "evidence_directory": str(evidence.path)})
    success = result["outcome"] == "PASS"
    evidence.write("result.json" if success else "failure.json", result)
    print(json.dumps(result, ensure_ascii=False, sort_keys=True), file=sys.stdout if success else sys.stderr)
    return 0 if success else 1


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
    raise SystemExit(main())
