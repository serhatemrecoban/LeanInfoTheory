"""Focused Python tests; real Lean evidence belongs to run_candidate_fixtures.py."""

from __future__ import annotations

import copy
from contextlib import ExitStack
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
sys.path.insert(0, str(ROOT / "scripts/compatibility"))
import candidate_contract as candidate
import check_candidate_api_compatibility as command
import check_public_api_compatibility as legacy
import release_state
import run_candidate_fixtures as fixture


def identity() -> dict:
    return {"schema": "lean-info-theory.candidate-release-identity.v1", "phase": "candidate",
            "target_version": "0.2.0", "package_version": "0.2.0", "current_route": "/docs/current/",
            "stable_version": "0.1.0", "stable_route": "/docs/v0.1.0/", "reserved_route": "/docs/v0.2.0/",
            "publishable": False, "retention": "pending", "state_sha256": "1" * 64}


def contract() -> dict:
    """Synthetic grammar/boundary data, explicitly not an elaborated Lean export."""
    modules = ["LeanInfoTheory", "LeanInfoTheory.Shannon"]
    manifest = {"declaration_count": 2, "supported_modules": modules, "declarations": [
        {"name": "LeanInfoTheory.Shannon." + name, "module": modules[1], "kind": "theorem", "attributes": []}
        for name in ("alpha", "beta")]}
    records = [{"name": entry["name"], "owner": entry["module"], "source_kind": entry["kind"],
                "compiled_kind": "theorem", "universe_parameters": [], "type": ["sort", ["zero"]]}
               for entry in manifest["declarations"]]
    pairs = [{"name": entry["name"], "owner": entry["module"]} for entry in manifest["declarations"]]
    closures = {modules[0]: [modules[0]], modules[1]: modules}
    expected = {"schema": legacy.current_policy.EXPECTED_SCHEMA, "supported_modules": modules,
                "direct_imports": {owner: {"local": [], "external": []} for owner in modules},
                "module_closures": closures, "declarations": pairs, "simp": [],
                "root_closure": [modules[0]], "root_exports": []}
    boundaries = {"schema": legacy.current_policy.COMPILED_SCHEMA, "supported_modules": modules,
                  "direct_imports": {owner: {"local": [], "external": ["Init", "Init"]} for owner in modules},
                  "module_closures": closures, "declarations": pairs, "simp": [],
                  "root_closure": [modules[0]], "root_exports": [], "root_resolutions": [],
                  "focused_declarations": {modules[0]: [], modules[1]: pairs},
                  "focused_simp": {owner: [] for owner in modules},
                  "olean_paths": [{"module": owner, "expected": owner.replace(".", "/") + ".olean",
                                   "resolved": owner.replace(".", "/") + ".olean"} for owner in modules]}
    manifest_hash = legacy.sha256((json.dumps(manifest, indent=2, sort_keys=True) + "\n").encode())
    files = {name: "2" * 64 for name in candidate.OWN_INPUTS}
    files.update({"scripts/compatibility/ExportRetained.lean": "3" * 64,
                  "docs/current-public-api.json": manifest_hash})
    return {"schema": candidate.SCHEMA, "release_identity": identity(), "manifest": manifest,
            "manifest_sha256": manifest_hash, "declaration_count": 2, "declarations": records,
            "expected_boundaries": expected, "boundaries": boundaries,
            "producer": {"files": files, "dependencies": {"mathlib": "4" * 40},
                         "compiler": "Lean (version 4.33.1, x86_64-w64-windows-gnu, commit " + legacy.LEAN_COMMIT + ", Release)",
                         "exporter_sha256": "3" * 64},
            "checkpoint": {"kind": "git", "head": "5" * 40, "tree": "6" * 40, "clean": True},
            "limitations": candidate.LIMITATIONS}


def approval(value: dict, raw: bytes) -> dict:
    return {"schema": candidate.APPROVAL_SCHEMA, "target_version": "0.2.0",
            "artifact_path": release_state.CANDIDATE_CONTRACT_PATH, "artifact_sha256": legacy.sha256(raw),
            "manifest_sha256": value["manifest_sha256"], "declaration_count": value["declaration_count"],
            "producer_sha256": legacy.sha256(legacy.encode(value["producer"])),
            "export_checkpoint": value["checkpoint"], "review_reference": ".lit-review/reviews/explicit-review.json"}


class EnvelopeTests(unittest.TestCase):
    def setUp(self):
        self.value = contract()

    def export(self, records=None):
        return legacy.encode({"schema": candidate.EXPORT_SCHEMA,
                              "declarations": records if records is not None else self.value["declarations"]})

    def test_exact_current_coverage_is_not_a_601_quota(self):
        self.assertEqual(len(candidate.validate_export(self.export(), self.value["manifest"])), 2)
        candidate.validate_contract(self.value)

    def test_missing_extra_reordered_duplicate_records_fail(self):
        records = self.value["declarations"]
        for bad in (records[:1], records + [records[0]], records[::-1], [records[0], records[0]]):
            with self.subTest(bad=bad), self.assertRaisesRegex(ValueError, "CANDIDATE_INVENTORY"):
                candidate.validate_export(self.export(bad), self.value["manifest"])

    def test_duplicate_manifest_and_json_keys_fail(self):
        self.value["manifest"]["declarations"][1] = self.value["manifest"]["declarations"][0]
        with self.assertRaisesRegex(ValueError, "duplicate source name"):
            candidate.validate_export(self.export(), self.value["manifest"])
        with self.assertRaisesRegex(ValueError, "duplicate JSON key"):
            candidate.validate_export(b'{"schema":0,"schema":1,"declarations":[]}', {})

    def test_owner_source_kind_compiled_kind_and_extra_fields_fail(self):
        for key, bad in (("owner", "LeanInfoTheory"), ("source_kind", "def"),
                         ("compiled_kind", "definition"), ("extra", True)):
            value = copy.deepcopy(self.value["declarations"])
            value[0][key] = bad
            with self.subTest(key=key), self.assertRaises(ValueError):
                candidate.validate_export(self.export(value), self.value["manifest"])

    def test_structural_grammar_and_unbound_universes_fail(self):
        for bad in (["fvar", "x"], ["bvar", 0], ["sort", ["param", ["str", ["anonymous"], "u"]]]):
            records = copy.deepcopy(self.value["declarations"])
            records[0]["type"] = bad
            with self.subTest(bad=bad), self.assertRaisesRegex(ValueError, "invalid retained type"):
                candidate.validate_export(self.export(records), self.value["manifest"])

    def test_complete_extra_binder_reports_qualified_name_and_path_before_provenance(self):
        changed = copy.deepcopy(self.value)
        changed["declarations"][0]["type"] = ["forall", ["str", ["anonymous"], "_compatProbe"],
                                                "explicit", ["sort", ["zero"]], ["sort", ["zero"]]]
        changed["producer"]["files"]["scripts/release_state.py"] = "7" * 64
        with self.assertRaisesRegex(ValueError, r"CANDIDATE_TYPE: LeanInfoTheory.Shannon.alpha at type"):
            candidate.compare_contracts(self.value, changed)

    def test_same_types_different_source_still_fail_provenance(self):
        changed = copy.deepcopy(self.value)
        changed["producer"]["files"]["scripts/release_state.py"] = "7" * 64
        with self.assertRaisesRegex(ValueError, "CANDIDATE_PROVENANCE"):
            candidate.compare_contracts(self.value, changed)

    def test_lifecycle_transition_does_not_recurse_into_producer(self):
        changed = copy.deepcopy(self.value)
        changed["release_identity"].update(retention="established", state_sha256="8" * 64)
        candidate.compare_contracts(self.value, changed)
        self.assertTrue(candidate.excluded_producer_paths().isdisjoint(self.value["producer"]["files"]))

    def test_recursive_output_state_or_nonportable_paths_fail(self):
        for path in [*candidate.excluded_producer_paths(), "../outside", "C:/absolute"]:
            value = copy.deepcopy(self.value)
            value["producer"]["files"][path] = "8" * 64
            with self.subTest(path=path), self.assertRaises(ValueError):
                candidate.validate_contract(value)

    def test_boundaries_retain_focused_simp_and_root_protection(self):
        for mutate in (
            lambda value: value["boundaries"]["focused_simp"]["LeanInfoTheory"].append("LeanInfoTheory.bad"),
            lambda value: value["boundaries"]["root_resolutions"].append({"alias": "LeanInfoTheory.bad", "target": "LeanInfoTheory.Shannon.alpha"}),
            lambda value: value["boundaries"]["direct_imports"]["LeanInfoTheory"]["local"].append("LeanInfoTheory.Shannon"),
        ):
            value = copy.deepcopy(self.value)
            mutate(value)
            with self.assertRaises(ValueError):
                candidate.validate_contract(value)

    def test_manifest_digest_and_cross_inventory_coverage_fail(self):
        value = copy.deepcopy(self.value)
        value["manifest_sha256"] = "0" * 64
        with self.assertRaisesRegex(ValueError, "manifest digest"):
            candidate.validate_contract(value)
        value = copy.deepcopy(self.value)
        value["declarations"][0]["name"] = "LeanInfoTheory.Shannon.gamma"
        value["manifest"]["declarations"][0]["name"] = "LeanInfoTheory.Shannon.gamma"
        value["manifest_sha256"] = legacy.sha256((json.dumps(value["manifest"], indent=2, sort_keys=True) + "\n").encode())
        with self.assertRaisesRegex(ValueError, "type inventory differs"):
            candidate.validate_contract(value)


    def test_platform_target_is_retained_as_provenance_and_compatible(self):
        value = contract()
        original = value["producer"]["compiler"]
        for target in ("x86_64-unknown-linux-gnu", "aarch64-apple-darwin"):
            current = copy.deepcopy(value)
            current["producer"]["compiler"] = original.replace("x86_64-w64-windows-gnu", target)
            candidate.compare_contracts(value, current)
            self.assertEqual(value["producer"]["compiler"], original)
            self.assertIn(target, current["producer"]["compiler"])

    def test_compiler_version_commit_mode_and_format_drift_are_rejected(self):
        value = contract()
        raw = value["producer"]["compiler"]
        for changed in (
            raw.replace("4.33.1", "4.33.2"),
            raw.replace(legacy.LEAN_COMMIT, "0" * 40),
            raw.replace("Release", "Debug"),
            raw.replace("Release", "Unknown"),
            raw.replace("Lean (", "Unverified ("),
        ):
            current = copy.deepcopy(value)
            current["producer"]["compiler"] = changed
            with self.subTest(compiler=changed), self.assertRaisesRegex(ValueError, "CANDIDATE_(COMPILER|PROVENANCE)"):
                candidate.compare_contracts(value, current)


class ApprovalTests(unittest.TestCase):
    def test_reviewed_clean_exact_capture_and_swapped_bytes(self):
        value = candidate.validate_contract(contract())
        raw = legacy.encode(value)
        reviewed = approval(value, raw)
        candidate.validate_approval(reviewed, raw, value)
        with self.assertRaisesRegex(ValueError, "artifact digest mismatch"):
            candidate.validate_approval(reviewed, raw + b" ", value)
        with self.assertRaisesRegex(ValueError, "reviewed identity"):
            candidate.validate_approval({**reviewed, "producer_sha256": "0" * 64}, raw, value)

    def test_dirty_isolated_and_preparation_capture_cannot_be_approved(self):
        for change in ("dirty", "isolated", "preparation"):
            value = contract()
            if change == "dirty":
                value["checkpoint"]["clean"] = False
            elif change == "isolated":
                value["checkpoint"] = {"kind": "isolated-copy", "head": None, "tree": None, "clean": False}
            else:
                value["release_identity"].update(phase="preparation", package_version="0.1.0")
            raw = legacy.encode(value)
            with self.subTest(change=change), self.assertRaisesRegex(ValueError, "CANDIDATE_APPROVAL"):
                candidate.validate_approval(approval(value, raw), raw, value)

    def test_no_review_reference_or_wrong_path_cannot_approve(self):
        value = contract()
        raw = legacy.encode(value)
        for field, bad in (("review_reference", ""), ("review_reference", ".lit-review/../elsewhere"),
                           ("artifact_path", "tmp/auto-approved.json"), ("target_version", "0.3.0")):
            reviewed = approval(value, raw)
            reviewed[field] = bad
            with self.subTest(field=field), self.assertRaises(ValueError):
                candidate.validate_approval(reviewed, raw, value)

    def test_pending_check_does_not_claim_pass_or_run_a_build(self):
        with patch.object(release_state, "load_state", return_value={"phase": "candidate"}), \
             patch.object(release_state, "contract_identity", return_value=identity()), \
             patch.object(command, "fresh_contract") as fresh:
            result = command.run_check(object())
        self.assertEqual(result["outcome"], "NOT_ESTABLISHED")
        fresh.assert_not_called()

    def test_canonical_loader_requires_approval_and_exact_identity(self):
        value = contract()
        raw = legacy.encode(value)
        active = {**identity(), "retention": "established"}
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory).absolute()
            artifact = root / release_state.CANDIDATE_CONTRACT_PATH
            artifact.parent.mkdir(parents=True)
            artifact.write_bytes(raw)
            historical = {"dependencies": value["producer"]["dependencies"],
                          "exporter": {"sha256": value["producer"]["exporter_sha256"]}}
            with patch.object(release_state, "contract_identity", return_value=active), \
                 patch.object(legacy, "load_baseline", return_value=({}, historical)):
                with self.assertRaisesRegex(ValueError, "missing/redirected"):
                    candidate.load_approved_contract(root)
                (root / release_state.CANDIDATE_APPROVAL_PATH).write_bytes(legacy.encode(approval(value, raw)))
                self.assertEqual(candidate.load_approved_contract(root), value)
                self.assertEqual(candidate.load_approved_snapshot(root),
                                 (value, raw, legacy.encode(approval(value, raw))))
                active["reserved_route"] = "/docs/other/"
                with self.assertRaises(ValueError):
                    candidate.load_approved_contract(root)


    def test_check_compares_and_hashes_the_same_validated_snapshot(self):
        value = contract()
        raw = legacy.encode(value)
        reviewed = legacy.encode(approval(value, raw))
        active = {**identity(), "retention": "established"}
        with tempfile.TemporaryDirectory(dir=ROOT / "tmp") as directory:
            root = Path(directory).absolute()
            path = root / release_state.CANDIDATE_CONTRACT_PATH
            path.parent.mkdir(parents=True)
            path.write_bytes(raw)
            envelope = root / release_state.CANDIDATE_APPROVAL_PATH
            envelope.write_bytes(reviewed)
            with patch.object(command, "ROOT", root), \
                 patch.object(release_state, "load_state", return_value={"phase": "candidate"}), \
                 patch.object(release_state, "contract_identity", return_value=active), \
                 patch.object(candidate, "load_approved_snapshot", return_value=(value, raw, reviewed)) as load, \
                 patch.object(command, "fresh_contract", return_value=value):
                result = command.run_check(object())
                self.assertEqual(result["artifact_sha256"], legacy.sha256(raw))
                load.assert_called_once_with(root)
                # Simulate replacement after validation but before comparison.
                # The validated snapshot must remain the checked/digested input.
                path.write_bytes(raw + b" ")
                with self.assertRaisesRegex(ValueError, "FRESHNESS: approved artifact/envelope changed"):
                    command.run_check(object())


class FreshnessOrchestrationTests(unittest.TestCase):
    """Mocked sequencing checks; these do not assert a successful Lean run."""

    def run_mock(self, *, fail_label=None, drifting=False, nondeterministic=False):
        value = contract()
        calls = []
        with tempfile.TemporaryDirectory(dir=ROOT / "tmp") as directory, ExitStack() as stack:
            root = Path(directory).absolute()
            (root / "docs").mkdir()
            (root / "docs/current-public-api.json").write_text(
                json.dumps(value["manifest"], indent=2, sort_keys=True) + "\n", encoding="utf-8", newline="\n")
            exporter = root / "Exporter.lean"
            exporter.write_bytes(b"synthetic driver; never executed")
            digest = legacy.sha256(exporter.read_bytes())
            value["producer"]["files"]["scripts/compatibility/ExportRetained.lean"] = digest
            value["producer"]["exporter_sha256"] = digest
            evidence_path = root / "evidence"
            evidence_path.mkdir()

            class Evidence:
                path = evidence_path

                def write(self, name, data):
                    with (self.path / name).open("xb") as output:
                        output.write(legacy.encode(data))

                def run(self, label, args):
                    calls.append(label)
                    if label == fail_label:
                        raise ValueError("deliberate mocked " + label + " failure")
                    if label == "compiler":
                        return value["producer"]["compiler"].encode()
                    if label.startswith("candidate-types"):
                        raw = legacy.encode({"schema": candidate.EXPORT_SCHEMA,
                                             "declarations": value["declarations"]})
                        return raw + (b" " if nondeterministic and label.endswith("repeat") else b"")
                    if label == "boundaries":
                        return legacy.encode(value["boundaries"])
                    return b""

            files = value["producer"]["files"]
            after = {**files, "scripts/release_state.py": "9" * 64} if drifting else files
            historical = {"release_source_sha256": {}, "dependencies": value["producer"]["dependencies"]}
            replacements = [
                patch.object(command, "ROOT", root),
                patch.object(command, "checkpoint", return_value=value["checkpoint"]),
                patch.object(release_state, "contract_identity", return_value=identity()),
                patch.object(release_state, "check_legacy_configuration"),
                patch.object(release_state, "require_candidate_content"),
                patch.object(legacy, "load_baseline", return_value=(value["manifest"], historical)),
                patch.object(command.current_api, "load_current_manifest", return_value=value["manifest"]),
                patch.object(candidate, "producer_identity", side_effect=[files, after]),
                patch.object(legacy.retained, "dependency_identity", return_value=value["producer"]["dependencies"]),
                patch.object(legacy.retained, "EXPORTER", exporter),
                patch.object(legacy, "unredirected_tree"),
                patch.object(legacy, "direct_source_imports", return_value={}),
                patch.object(legacy.current_policy, "validate_source_policy", return_value=value["expected_boundaries"]),
                patch.object(legacy, "compare_types"),
                patch.object(legacy, "assemble_driver", return_value=b"synthetic boundary driver; never executed"),
            ]
            for replacement in replacements:
                stack.enter_context(replacement)
            try:
                result = command.fresh_contract(Evidence(), deterministic=True)
                return result, calls, None
            except ValueError as error:
                return None, calls, str(error)

    def test_fresh_build_precedes_double_export_and_compiled_boundaries(self):
        result, calls, error = self.run_mock()
        self.assertIsNone(error)
        self.assertEqual(result["declaration_count"], 2)
        self.assertEqual(calls, ["compiler", "build", "candidate-types", "candidate-types-repeat", "boundaries"])

    def test_build_failure_never_reaches_export(self):
        _, calls, error = self.run_mock(fail_label="build")
        self.assertIn("build failure", error)
        self.assertEqual(calls, ["compiler", "build"])

    def test_source_drift_after_successful_commands_is_rejected(self):
        _, calls, error = self.run_mock(drifting=True)
        self.assertEqual(calls[-1], "boundaries")
        self.assertIn("CANDIDATE_FRESHNESS", error)

    def test_nondeterminism_is_not_accepted_as_capture(self):
        _, calls, error = self.run_mock(nondeterministic=True)
        self.assertEqual(calls[-1], "candidate-types-repeat")
        self.assertIn("CANDIDATE_DETERMINISM", error)


class FixtureTests(unittest.TestCase):
    def test_actual_target_is_new_and_mutation_is_exactly_bounded(self):
        manifest = legacy.strict_json((ROOT / "docs/current-public-api.json").read_bytes())
        frozen, _ = legacy.load_baseline()
        self.assertEqual(sum(entry["name"] == fixture.QUALIFIED for entry in manifest["declarations"]), 1)
        self.assertNotIn(fixture.QUALIFIED, {entry["name"] for entry in frozen["declarations"]})
        source = (ROOT / fixture.OWNER).read_text(encoding="utf-8")
        changed = fixture.mutate(source)
        self.assertEqual(changed.replace("    (_compatProbe : True)\n", "", 1), source)
        self.assertEqual(changed.count("(_compatProbe : True)"), 1)
        with self.assertRaisesRegex(ValueError, "anchor changed"):
            fixture.mutate(source + source)

    def test_fixture_rejects_unrelated_changes(self):
        old = contract()["declarations"]
        new = copy.deepcopy(old)
        new[0]["type"] = ["sort", ["succ", ["zero"]]]
        with self.assertRaisesRegex(ValueError, "only the final endpoint"):
            fixture.require_target_only(old, new)

    def test_existing_capture_is_refused_before_build(self):
        with tempfile.TemporaryDirectory(dir=ROOT / "tmp") as directory:
            output = Path(directory) / "existing.json"
            output.write_text("existing", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "never overwrites"):
                command.capture_destination(output, object())


if __name__ == "__main__":
    unittest.main()
