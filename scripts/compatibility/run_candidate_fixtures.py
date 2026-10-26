#!/usr/bin/env python3
"""Exercise a compiling post-v0.1 signature mutation in an owned ignored copy.

This bounded experiment never writes approval or edits production Lean source.
All commands and original output are retained even on failure. Only dependency
caches are shared; project build output is copied and checked for redirects.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import sys
import uuid

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
sys.path.insert(0, str(ROOT / "scripts/compatibility"))
import check_public_api_compatibility as legacy
import candidate_contract as candidate
import release_state
import run_compatibility_fixtures as isolation

OWNER = "LeanInfoTheory/Shannon/ChannelCodingAsymptotic.lean"
TARGET = "not_tendsto_errorProbability_zero_of_frequently_channelCapacity_add_le_codeRate"
QUALIFIED = "LeanInfoTheory.Shannon.BlockChannelCode." + TARGET
MODULE = "LeanInfoTheory.Shannon.ChannelCodingAsymptotic"


def mutate(source: str) -> str:
    anchor = "theorem " + TARGET + "\n    [Fintype A] [Nonempty A] [Fintype B]\n"
    candidate.require(source.count(anchor) == 1, "FIXTURE: final endpoint anchor changed")
    return source.replace(anchor, anchor + "    (_compatProbe : True)\n", 1)


def primary_identity() -> dict:
    files = candidate.producer_identity(ROOT)
    for rel in release_state.validation_inputs(ROOT):
        files[rel] = legacy.sha256((ROOT / rel).read_bytes())
    return {"files": dict(sorted(files.items())),
            "dependencies": legacy.retained.dependency_identity(ROOT),
            "frozen_manifest_sha256": legacy.sha256(legacy.frozen.FROZEN_PATH.read_bytes()),
            "historical_contract_sha256": legacy.sha256(legacy.retained.ARTIFACT.read_bytes())}


def write_new(path: Path, value: object) -> None:
    with path.open("xb") as output:
        output.write(legacy.encode(value))


def export(source: Path, out: Path, label: str, manifest: dict) -> list[dict]:
    isolation.run(["lake", "--wfail", "build", MODULE, "LeanInfoTheory.Shannon"],
                  source, out, label + "-build")
    isolation.run(["lake", "env", "lean", "-DwarningAsError=true", "--run",
                   "scripts/compatibility/ExportRetained.lean", "docs/current-public-api.json"],
                  source, out, label + "-export")
    return candidate.validate_export((out / (label + "-export.stdout")).read_bytes(), manifest)


def unchanged_historical(records: list[dict]) -> None:
    frozen, historical = legacy.load_baseline()
    names = {entry["name"] for entry in frozen["declarations"]}
    legacy.compare_types(historical, legacy.encode({"schema": candidate.EXPORT_SCHEMA,
        "declarations": [record for record in records if record["name"] in names]}), frozen)


def require_target_only(old: list[dict], new: list[dict]) -> str:
    candidate.require([entry["name"] for entry in old] == [entry["name"] for entry in new],
                      "FIXTURE: mutation changed names/order/count")
    differences = [left["name"] for left, right in zip(old, new, strict=True) if left != right]
    candidate.require(differences == [QUALIFIED], "FIXTURE: mutation must change only the final endpoint")
    left = next(entry for entry in old if entry["name"] == QUALIFIED)
    right = next(entry for entry in new if entry["name"] == QUALIFIED)
    candidate.require({key: value for key, value in left.items() if key != "type"}
                      == {key: value for key, value in right.items() if key != "type"},
                      "FIXTURE: mutation changed ownership/kind/universes")
    try:
        candidate.compare_declarations(old, new)
    except ValueError as error:
        message = str(error)
        candidate.require(message.startswith("CANDIDATE_TYPE: " + QUALIFIED + " at type"),
                          "FIXTURE: wrong refusal cause: " + message)
        return message
    raise ValueError("CANDIDATE_FIXTURE: compiling extra premise was not rejected")


def run_fixture(output: Path) -> dict:
    candidate.require(output.absolute().is_relative_to(ROOT / "tmp")
                      and output.parent.resolve() == output.parent.absolute(),
                      "FIXTURE: evidence must remain under unredirected tmp/")
    output.mkdir(parents=True, exist_ok=False)
    before = primary_identity()
    write_new(output / "production-before.json", before)
    source = output / "source"
    originals = isolation.make_source_copy(source)
    extras = {}
    # Deliberately explicit. Never use the growth harness's broad docs/ copy.
    for rel in release_state.validation_inputs(ROOT):
        raw = (ROOT / rel).read_bytes()
        destination = source / rel
        destination.parent.mkdir(parents=True, exist_ok=True)
        if destination.exists():
            candidate.require(destination.read_bytes() == raw, "FIXTURE: copied input mismatch " + rel)
        else:
            with destination.open("xb") as handle:
                handle.write(raw)
        extras[rel] = legacy.sha256(raw)
    write_new(output / "explicit-state-inputs.json", extras)
    manifest = legacy.strict_json((source / "docs/current-public-api.json").read_bytes())
    frozen, _ = legacy.load_baseline()
    candidate.require(QUALIFIED not in {entry["name"] for entry in frozen["declarations"]}
                      and sum(entry["name"] == QUALIFIED for entry in manifest["declarations"]) == 1,
                      "FIXTURE: target is not a unique post-v0.1 declaration")
    original = originals[OWNER]
    baseline = None
    mutated = False
    failure = None
    restored_failure = None
    diagnostic = None
    try:
        isolation.run([sys.executable, "scripts/check_candidate_api_compatibility.py", "capture",
                       "--output", str(source / "tmp/candidate-before.json")],
                      source, output, "unchanged-capture")
        baseline = candidate.validate_contract(legacy.strict_json(
            (source / "tmp/candidate-before.json").read_bytes()))
        candidate.require(baseline["checkpoint"]["kind"] == "isolated-copy",
                          "FIXTURE: experiment borrowed a containing Git checkpoint")
        candidate.compare_contracts(baseline, baseline)
        unchanged_historical(baseline["declarations"])
        changed = mutate(original.decode("utf-8")).encode("utf-8")
        (source / OWNER).write_bytes(changed)
        mutated = True
        with (output / "mutated-owner.lean").open("xb") as handle:
            handle.write(changed)
        records = export(source, output, "mutated", manifest)
        unchanged_historical(records)
        diagnostic = require_target_only(baseline["declarations"], records)
        write_new(output / "expected-type-rejection.json", {
            "outcome": "EXPECTED_REJECTION", "diagnostic": diagnostic,
            "declaration_count": len(records), "historical_retained_count": len(frozen["declarations"]),
            "successful_build_and_export_required": True})
    except Exception as error:
        failure = str(error)
        write_new(output / "experiment-failure.json", {"outcome": "FAIL", "diagnostic": failure})
    finally:
        (source / OWNER).write_bytes(original)
        if mutated and baseline is not None:
            try:
                restored = export(source, output, "restored", manifest)
                candidate.compare_declarations(baseline["declarations"], restored)
                unchanged_historical(restored)
                candidate.require((source / OWNER).read_bytes() == original,
                                  "FIXTURE: source restoration differs")
            except Exception as error:
                restored_failure = str(error)
                write_new(output / "restoration-failure.json", {"outcome": "FAIL", "diagnostic": restored_failure})
        after = primary_identity()
        write_new(output / "production-after.json", after)
        candidate.require(before == after, "FIXTURE: production source/pins/frozen artifacts changed")
    candidate.require(failure is None and restored_failure is None,
                      f"FIXTURE: experiment={failure}; restoration={restored_failure}")
    candidate.require(diagnostic is not None, "FIXTURE: missing actual structural rejection")
    result = {"schema": "lean-info-theory.candidate-fixture-result.v1", "outcome": "PASS",
              "qualification": "EXPERIMENT_ONLY; no candidate approval or release baseline established.",
              "declaration_count": baseline["declaration_count"], "mutated_declaration": QUALIFIED,
              "diagnostic": diagnostic, "production_unchanged": True, "restored_control": "PASS",
              "evidence_directory": str(output)}
    write_new(output / "result.json", result)
    return result


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=None)
    args = parser.parse_args(argv)
    output = (args.output or ROOT / "tmp" / ("candidate-fixtures-" + uuid.uuid4().hex)).absolute()
    try:
        print(legacy.encode(run_fixture(output)).decode("utf-8"), end="", flush=True)
        return 0
    except (OSError, ValueError, KeyError, TypeError, RecursionError) as error:
        failure = {"outcome": "FAIL", "diagnostic": str(error), "evidence_directory": str(output)}
        if output.is_dir() and not (output / "runner-failure.json").exists():
            write_new(output / "runner-failure.json", failure)
        print(legacy.encode(failure).decode("utf-8"), file=sys.stderr, end="")
        return 1


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
    raise SystemExit(main())
