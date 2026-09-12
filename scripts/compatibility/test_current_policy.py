#!/usr/bin/env python3
"""Focused Python policy regressions; compiled JSON fixtures are synthetic.

These checks do not execute Lean, establish build freshness, or stand in for the
standalone checker's real compiling mutation and stale-artifact qualification.
"""

from __future__ import annotations

import copy
import json
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import current_policy as policy
import frozen_public_api as frozen_api
import generate_current_public_api as current_api
import generate_website_blueprint as blueprint


OPT = "LeanInfoTheory.Shannon.SemanticBridge.Independence"
BRIDGE = "LeanInfoTheory.Shannon.SemanticBridge"
INFO = "LeanInfoTheory.Shannon.InfoMeasures"
ENTROPY = "LeanInfoTheory.Shannon.Entropy"
NEW_MODULE = "LeanInfoTheory.Shannon.PolicyFixture"
NEW_NAME = "LeanInfoTheory.Shannon.policyFixture"
REVIEW = {"rationale": "Synthetic fixture rationale.", "consumer": "Synthetic fixture consumer.",
          "approval_reference": "synthetic-test:explicit-review"}


class PolicyTests(unittest.TestCase):
    def setUp(self) -> None:
        self.imports = {
            "LeanInfoTheory": {"local": sorted(policy.ROOT_DIRECT), "external": []},
            "LeanInfoTheory.Probability.Finite": {"local": [], "external": ["Mathlib.Probability.ProbabilityMassFunction.Basic"]},
            "LeanInfoTheory.InformationMeasures": {"local": [ENTROPY, INFO], "external": []},
            ENTROPY: {"local": ["LeanInfoTheory.Probability.Finite"], "external": []},
            INFO: {"local": [ENTROPY], "external": []},
            policy.FULL_MODULE: {"local": [policy.ROOT_MODULE, BRIDGE], "external": []},
            BRIDGE: {"local": [OPT], "external": []},
            OPT: {"local": [INFO], "external": ["Mathlib.Data.Finset.Basic"]},
            "LeanInfoTheory.Basic": {"local": [], "external": []},
        }
        declarations = [
            {"name": "LeanInfoTheory.Shannon.entropy", "module": ENTROPY, "kind": "def", "attributes": []},
            {"name": "LeanInfoTheory.Shannon.entropy_zero", "module": ENTROPY, "kind": "theorem", "attributes": ["simp"]},
            {"name": "LeanInfoTheory.Shannon.independent", "module": INFO, "kind": "def", "attributes": []},
            {"name": "PMF.policyFixture", "module": OPT, "kind": "theorem", "attributes": []},
        ]
        aliases = [
            {"alias": "LeanInfoTheory.entropy", "target": "LeanInfoTheory.Shannon.entropy"},
            {"alias": "LeanInfoTheory.independent", "target": "LeanInfoTheory.Shannon.independent"},
        ]
        self.frozen = {
            "schema": "lean-info-theory.public-api.v0.1.v1",
            "full_umbrella": policy.FULL_MODULE, "lightweight_root": policy.ROOT_MODULE,
            "lightweight_root_direct_imports": sorted(policy.ROOT_DIRECT),
            "supported_modules": sorted(set(self.imports) - {"LeanInfoTheory.Basic"}),
            "non_stable_modules": ["LeanInfoTheory.Basic"],
            "declaration_count": len(declarations), "declarations": declarations,
            "root_exports": aliases,
        }
        self.retained = {
            "schema": "lean-info-theory.retained-contract.v0.1.0.v1",
            "release": frozen_api.baseline_identity(),
            "direct_imports": {owner: copy.deepcopy(self.imports[owner]) for owner in self.frozen["supported_modules"]},
            "declarations": [{"name": entry["name"], "source_kind": entry["kind"], "owner": entry["module"]}
                             for entry in declarations],
            "reviewed_simp": [entry["name"] for entry in declarations if "simp" in entry["attributes"]],
            "root_exports": copy.deepcopy(aliases),
        }
        self.current = copy.deepcopy(self.frozen)
        self.current["schema"] = "lean-info-theory.current-public-api.v1"
        self.current["baseline_identity"] = frozen_api.baseline_identity()
        self.policy = {"schema": policy.POLICY_SCHEMA, "baseline_identity": frozen_api.baseline_identity(),
                       "import_approvals": [], "simp_additions": [], "root_export_additions": []}
        self.refresh()

    def refresh(self) -> None:
        self.current.update(
            declaration_count=len(self.current["declarations"]),
            documented_declaration_count=len(self.current["declarations"]),
            supported_module_count=len(self.current["supported_modules"]),
            non_stable_module_count=len(self.current["non_stable_modules"]),
            local_module_count=len(self.imports), root_export_count=len(self.current["root_exports"]),
            simp_declaration_count=sum("simp" in entry["attributes"] for entry in self.current["declarations"]),
        )

    def expected(self) -> dict:
        self.refresh()
        return policy.validate_source_policy(self.frozen, self.retained, self.current, self.imports, self.policy)

    def add_declaration(self, *, simp: bool = False, owner: str = OPT) -> None:
        self.current["declarations"].append({"name": NEW_NAME, "module": owner,
                                             "kind": "theorem", "attributes": ["simp"] if simp else []})

    def import_approval(self, owner: str, kind: str) -> dict:
        return {"owner": owner, "kind": kind, "imports": copy.deepcopy(self.imports[owner]), **REVIEW}

    def add_module(self) -> None:
        self.imports[NEW_MODULE] = {"local": [INFO], "external": ["Mathlib.Data.Real.Basic"]}
        self.imports[policy.FULL_MODULE]["local"].append(NEW_MODULE)
        self.current["supported_modules"].append(NEW_MODULE)
        self.add_declaration(owner=NEW_MODULE)

    def compiled(self, expected: dict | None = None) -> dict:
        expected = self.expected() if expected is None else expected
        result = copy.deepcopy(expected)
        result["schema"] = policy.COMPILED_SCHEMA
        for imports in result["direct_imports"].values():
            imports["external"].extend(["Init", "Init"])
        result["focused_declarations"] = {
            owner: [entry for entry in expected["declarations"] if entry["owner"] in closure]
            for owner, closure in expected["module_closures"].items()
        }
        result["focused_simp"] = {
            owner: [entry["name"] for entry in expected["declarations"]
                    if entry["owner"] in closure and entry["name"] in expected["simp"]]
            for owner, closure in expected["module_closures"].items()
        }
        result["root_resolutions"] = copy.deepcopy(expected["root_exports"])
        result["olean_paths"] = [{"module": owner, "resolved": "synthetic/" + owner + ".olean",
                                   "expected": "synthetic/" + owner + ".olean"}
                                  for owner in expected["supported_modules"]]
        return result

    def refuses(self, code: str, callback=None) -> policy.PolicyError:
        with self.assertRaises(policy.PolicyError) as context:
            (self.expected if callback is None else callback)()
        self.assertEqual(context.exception.code, code, str(context.exception))
        return context.exception

    def test_empty_policy_and_compiled_expectations_preserve_inputs(self) -> None:
        inputs = copy.deepcopy((self.frozen, self.retained, self.current, self.imports, self.policy))
        expected = self.expected()
        compiled = self.compiled(expected)
        saved = copy.deepcopy((expected, compiled))
        policy.compare_compiled_policy(expected, compiled)
        self.assertEqual(inputs, (self.frozen, self.retained, self.current, self.imports, self.policy))
        self.assertEqual(saved, (expected, compiled))

    def test_json_duplicate_keys_nonstandard_constants_and_schema_are_rejected(self) -> None:
        for raw, code in ((b'{"schema":1,"schema":2}', "POLICY_DUPLICATE"),
                          ('{"schema":NaN}', "POLICY_SCHEMA"), (b'\xff', "POLICY_SCHEMA")):
            with self.subTest(raw=raw):
                self.refuses(code, lambda: policy.parse_policy(raw))
        for change in ({"extra": []}, {"schema": "unknown"}, {"import_approvals": {}},
                       {"baseline_identity": {}}):
            bad = {**self.policy, **change}
            code = "POLICY_IDENTITY" if "baseline_identity" in change else "POLICY_SCHEMA"
            self.refuses(code, lambda: policy.validate_policy(bad, frozen_api.baseline_identity()))

    def test_approval_metadata_and_conflicting_duplicates_are_rejected(self) -> None:
        records = {
            "import_approvals": self.import_approval(OPT, "focused_exception"),
            "simp_additions": {"name": NEW_NAME, "owner": OPT, **REVIEW},
            "root_export_additions": {"alias": "LeanInfoTheory.extra", "target": "LeanInfoTheory.Shannon.entropy", **REVIEW},
        }
        for group, record in records.items():
            with self.subTest(group=group):
                bad = copy.deepcopy(self.policy)
                bad[group] = [record, {**record, "rationale": "A conflicting review record."}]
                self.refuses("POLICY_DUPLICATE", lambda: policy.validate_policy(bad, frozen_api.baseline_identity()))
                bad[group] = [{**record, "approval_reference": " "}]
                self.refuses("POLICY_REVIEW_REFERENCE", lambda: policy.validate_policy(bad, frozen_api.baseline_identity()))
                bad[group] = [{**record, "wildcard": True}]
                self.refuses("POLICY_SCHEMA", lambda: policy.validate_policy(bad, frozen_api.baseline_identity()))

    def test_regenerated_retained_name_owner_kind_or_simp_changes_still_fail(self) -> None:
        original = copy.deepcopy(self.current)
        changes = (("name", NEW_NAME, "RETAINED_NAME_MISSING"),
                   ("module", OPT, "RETAINED_OWNER_CHANGED"),
                   ("kind", "abbrev", "RETAINED_KIND_CHANGED"),
                   ("attributes", ["simp"], "RETAINED_SIMP_CHANGED"))
        for key, value, code in changes:
            with self.subTest(field=key):
                self.current = copy.deepcopy(original)
                self.current["declarations"][0][key] = value
                self.refuses(code)
        self.current = original
        self.current["declarations"][1]["attributes"] = []
        self.refuses("RETAINED_SIMP_CHANGED")

    def test_compatible_existing_owner_addition_has_no_count_ceiling(self) -> None:
        count = self.expected()["declarations"]
        self.add_declaration()
        expected = self.expected()
        self.assertEqual(len(expected["declarations"]), len(count) + 1)
        policy.compare_compiled_policy(expected, self.compiled(expected))

    def test_umbrella_extension_requires_exact_owner_and_new_module_approvals(self) -> None:
        self.add_module()
        self.refuses("IMPORT_APPROVAL_REQUIRED")
        self.policy["import_approvals"] = [self.import_approval(policy.FULL_MODULE, "umbrella_addition")]
        self.refuses("IMPORT_APPROVAL_REQUIRED")
        self.policy["import_approvals"].append(self.import_approval(NEW_MODULE, "new_module"))
        expected = self.expected()
        self.assertIn(NEW_MODULE, expected["supported_modules"])
        policy.compare_compiled_policy(expected, self.compiled(expected))
        self.policy["import_approvals"][1]["imports"]["external"] = []
        self.refuses("IMPORT_APPROVAL_MISMATCH")

    def test_focused_local_and_external_changes_need_exact_architecture_exception(self) -> None:
        for category, value in (("local", "LeanInfoTheory.Probability.Finite"),
                                ("external", "Mathlib.Data.Real.Basic")):
            with self.subTest(category=category):
                self.imports[OPT][category].append(value)
                self.policy["import_approvals"] = []
                error = self.refuses("IMPORT_APPROVAL_REQUIRED")
                self.assertEqual(error.expected["removed"], {"local": [], "external": []})
                self.assertEqual(error.actual["added"][category], [value])
                self.assertIn(value, str(error))
                self.policy["import_approvals"] = [self.import_approval(OPT, "focused_exception")]
                self.expected()
                self.policy["import_approvals"][0]["kind"] = "umbrella_addition"
                self.refuses("IMPORT_APPROVAL_KIND")
                self.imports[OPT][category].remove(value)

    def test_umbrella_removal_cannot_be_disguised_by_an_alternative_import_route(self) -> None:
        self.imports[OPT]["local"].append(policy.ROOT_MODULE)
        self.imports[policy.FULL_MODULE]["local"].remove(policy.ROOT_MODULE)
        self.policy["import_approvals"] = [self.import_approval(OPT, "focused_exception"),
                                           self.import_approval(policy.FULL_MODULE, "umbrella_addition")]
        error = self.refuses("UMBRELLA_IMPORT_REMOVAL")
        self.assertEqual(error.expected["removed"]["local"], [policy.ROOT_MODULE])
        self.assertIn(policy.ROOT_MODULE, str(error))

    def test_import_diagnostics_show_changed_tail_after_a_long_common_prefix(self) -> None:
        common = [f"Common.Prefix.Module{i:03d}" for i in range(100)]
        removed, added = "Z.RemovedImport", "Z.AddedImport"
        for mode, code in (("missing", "IMPORT_APPROVAL_REQUIRED"),
                           ("approval", "IMPORT_APPROVAL_MISMATCH"),
                           ("compiled", "COMPILED_DIRECT_IMPORT_MISMATCH")):
            with self.subTest(mode=mode):
                self.setUp()
                if mode == "compiled":
                    expected = self.expected()
                    expected["direct_imports"][OPT]["external"] = common + [removed]
                    compiled = self.compiled(expected)
                    compiled["direct_imports"][OPT]["external"] = common + [added, "Init", "Init"]
                    error = self.refuses(code, lambda: policy.compare_compiled_policy(expected, compiled))
                else:
                    self.imports[OPT]["external"] = common + [added]
                    if mode == "missing":
                        self.retained["direct_imports"][OPT]["external"] = common + [removed]
                    else:
                        approval = self.import_approval(OPT, "focused_exception")
                        approval["imports"]["external"] = common + [removed]
                        self.policy["import_approvals"] = [approval]
                    error = self.refuses(code)
                self.assertEqual(error.subject, OPT)
                self.assertEqual(error.expected, {"present": True, "removed": {"local": [], "external": [removed]}})
                self.assertEqual(error.actual, {"present": True, "added": {"local": [], "external": [added]}})
                self.assertIn(removed, str(error))
                self.assertIn(added, str(error))
                self.assertNotIn(common[0], str(error))

    def test_unapproved_empty_import_module_still_fails_with_presence_difference(self) -> None:
        self.add_module()
        self.imports[NEW_MODULE] = {"local": [], "external": []}
        self.policy["import_approvals"] = [self.import_approval(policy.FULL_MODULE, "umbrella_addition")]
        error = self.refuses("IMPORT_APPROVAL_REQUIRED")
        self.assertEqual(error.subject, NEW_MODULE)
        self.assertEqual(error.expected, {"present": False, "removed": {"local": [], "external": []}})
        self.assertEqual(error.actual, {"present": True, "added": {"local": [], "external": []}})

    def test_missing_retained_name_and_alias_show_historical_value_and_current_absence(self) -> None:
        removed = self.current["declarations"].pop(0)
        error = self.refuses("RETAINED_NAME_MISSING")
        self.assertEqual(error.subject, removed["name"])
        self.assertEqual(error.expected, removed)
        self.assertIsNone(error.actual)
        self.assertIn("actual=null", str(error))
        self.setUp()
        alias = self.current["root_exports"].pop()
        error = self.refuses("RETAINED_ALIAS_MISSING")
        self.assertEqual(error.subject, alias["alias"])
        self.assertEqual(error.expected, alias["target"])
        self.assertIsNone(error.actual)
        self.assertIn(alias["target"], str(error))
        self.assertIn("actual=null", str(error))

    def test_root_direct_closure_and_external_boundaries_cannot_be_overridden(self) -> None:
        self.imports[policy.ROOT_MODULE]["local"].append(OPT)
        self.policy["import_approvals"] = [self.import_approval(policy.ROOT_MODULE, "focused_exception")]
        self.refuses("ROOT_IMPORT_BOUNDARY")
        self.imports[policy.ROOT_MODULE]["local"].remove(OPT)
        self.imports[ENTROPY]["external"].append("Mathlib.Analysis.Convex.Jensen")
        self.policy["import_approvals"] = [self.import_approval(ENTROPY, "focused_exception")]
        self.refuses("ROOT_IMPORT_BOUNDARY")

    def test_nonstable_module_cannot_be_reclassified_by_inventory_or_approval(self) -> None:
        self.current["supported_modules"].append("LeanInfoTheory.Basic")
        self.current["non_stable_modules"] = []
        self.imports[policy.FULL_MODULE]["local"].append("LeanInfoTheory.Basic")
        self.policy["import_approvals"] = [self.import_approval(policy.FULL_MODULE, "umbrella_addition"),
                                           self.import_approval("LeanInfoTheory.Basic", "new_module")]
        self.refuses("NON_STABLE_LEAKAGE")

    def test_new_simp_requires_reviewed_name_and_owner_and_cannot_override_retained(self) -> None:
        self.add_declaration(simp=True)
        self.refuses("SIMP_APPROVAL_REQUIRED")
        record = {"name": NEW_NAME, "owner": OPT, **REVIEW}
        self.policy["simp_additions"] = [{**record, "owner": INFO}]
        self.refuses("POLICY_OWNER_MISMATCH")
        self.policy["simp_additions"] = [record]
        self.assertIn(NEW_NAME, self.expected()["simp"])
        self.policy["simp_additions"].append({"name": "LeanInfoTheory.Shannon.entropy_zero", "owner": ENTROPY, **REVIEW})
        self.refuses("POLICY_RETAINED_OVERRIDE")

    def test_removed_retargeted_and_new_root_aliases_have_separate_diagnostics(self) -> None:
        saved = self.current["root_exports"].pop()
        self.refuses("RETAINED_ALIAS_MISSING")
        self.current["root_exports"].append({**saved, "target": "LeanInfoTheory.Shannon.entropy"})
        self.refuses("RETAINED_ALIAS_CHANGED")
        self.current["root_exports"][-1] = saved
        extra = {"alias": "LeanInfoTheory.extra", "target": "LeanInfoTheory.Shannon.entropy"}
        self.current["root_exports"].append(extra)
        self.refuses("ROOT_EXPORT_APPROVAL_REQUIRED")
        self.policy["root_export_additions"] = [{**extra, **REVIEW}]
        expected = self.expected()
        policy.compare_compiled_policy(expected, self.compiled(expected))
        self.current["root_exports"][-1]["target"] = "PMF.policyFixture"
        self.policy["root_export_additions"][0]["target"] = "PMF.policyFixture"
        self.refuses("ROOT_EXPORT_BOUNDARY")

    def test_unused_approvals_cannot_authorize_unspecified_future_changes(self) -> None:
        self.add_declaration()
        candidates = {
            "import_approvals": self.import_approval(OPT, "focused_exception"),
            "simp_additions": {"name": NEW_NAME, "owner": OPT, **REVIEW},
            "root_export_additions": {"alias": "LeanInfoTheory.extra", "target": "LeanInfoTheory.Shannon.entropy", **REVIEW},
        }
        for group, record in candidates.items():
            with self.subTest(group=group):
                self.policy[group] = [record]
                self.refuses("POLICY_UNUSED_APPROVAL")
                self.policy[group] = []

    def test_identity_and_historical_crosslinks_are_required(self) -> None:
        self.current["baseline_identity"] = {}
        self.refuses("POLICY_IDENTITY")
        self.current["baseline_identity"] = frozen_api.baseline_identity()
        self.retained["reviewed_simp"] = []
        self.refuses("RETAINED_ARTIFACT_MISMATCH")

    def test_compiled_imports_require_exact_ordinary_and_meta_init_pair(self) -> None:
        expected = self.expected()
        compiled = self.compiled(expected)
        policy.compare_compiled_policy(expected, compiled)
        for count in (0, 1, 3, 4):
            with self.subTest(count=count):
                compiled = self.compiled(expected)
                compiled["direct_imports"][OPT]["external"] = expected["direct_imports"][OPT]["external"] + ["Init"] * count
                self.refuses("COMPILED_IMPLICIT_INIT_MISMATCH", lambda: policy.compare_compiled_policy(expected, compiled))

    def test_compiled_explicit_init_remains_required_beyond_the_implicit_pair(self) -> None:
        expected = self.expected()
        expected["direct_imports"][OPT]["external"].append("Init")
        compiled = self.compiled(expected)
        self.assertEqual(compiled["direct_imports"][OPT]["external"].count("Init"), 3)
        policy.compare_compiled_policy(expected, compiled)
        explicit_others = [name for name in expected["direct_imports"][OPT]["external"] if name != "Init"]
        for count in (0, 1, 2, 4):
            with self.subTest(count=count):
                compiled = self.compiled(expected)
                compiled["direct_imports"][OPT]["external"] = explicit_others + ["Init"] * count
                self.refuses("COMPILED_IMPLICIT_INIT_MISMATCH", lambda: policy.compare_compiled_policy(expected, compiled))

    def test_compiled_imports_still_refuse_other_duplicates_additions_and_omissions(self) -> None:
        expected = self.expected()
        expected["direct_imports"][OPT]["external"].append("Explicit.Required")
        for change, code in (
            (lambda imports: imports["external"].append("Bogus.Unapproved"), "COMPILED_DIRECT_IMPORT_MISMATCH"),
            (lambda imports: imports["external"].remove("Explicit.Required"), "COMPILED_DIRECT_IMPORT_MISMATCH"),
            (lambda imports: imports["external"].append("Explicit.Required"), "POLICY_DUPLICATE"),
            (lambda imports: imports["local"].extend([ENTROPY, ENTROPY]), "POLICY_DUPLICATE"),
        ):
            with self.subTest(code=code):
                compiled = self.compiled(expected)
                change(compiled["direct_imports"][OPT])
                self.refuses(code, lambda: policy.compare_compiled_policy(expected, compiled))

    def test_compiled_module_owner_focused_coverage_and_simp_are_exact(self) -> None:
        expected = self.expected()
        cases = (
            ("COMPILED_MODULE_COVERAGE", lambda result: result["supported_modules"].pop()),
            ("COMPILED_DECLARATION_COVERAGE", lambda result: result["declarations"].pop()),
            ("COMPILED_DECLARATION_COVERAGE", lambda result: result["declarations"][0].update(owner=INFO)),
            ("COMPILED_FOCUSED_COVERAGE", lambda result: result["focused_declarations"][OPT].pop()),
            ("COMPILED_SIMP_MISMATCH", lambda result: result["simp"].append("PMF.policyFixture")),
            ("COMPILED_CLOSURE_MISMATCH", lambda result: result["module_closures"][OPT].pop()),
            ("COMPILED_IMPORT_COVERAGE", lambda result: result["direct_imports"].pop(OPT)),
        )
        for code, change in cases:
            with self.subTest(code=code):
                compiled = self.compiled(expected)
                change(compiled)
                self.refuses(code, lambda: policy.compare_compiled_policy(expected, compiled))

    def test_compiled_alias_enumeration_and_resolution_are_independent(self) -> None:
        expected = self.expected()
        for field, code in (("root_exports", "COMPILED_ROOT_ALIAS_MISMATCH"),
                            ("root_resolutions", "COMPILED_ROOT_RESOLUTION_MISMATCH")):
            with self.subTest(field=field):
                compiled = self.compiled(expected)
                compiled[field].append({"alias": "LeanInfoTheory.uncatalogued", "target": "LeanInfoTheory.Shannon.entropy"})
                self.refuses(code, lambda: policy.compare_compiled_policy(expected, compiled))
                compiled = self.compiled(expected)
                compiled[field][0]["target"] = "LeanInfoTheory.Shannon.independent"
                self.refuses(code, lambda: policy.compare_compiled_policy(expected, compiled))

    def test_focused_simp_requires_every_module_entry_including_empty_sets(self) -> None:
        expected = self.expected()
        empty_owner = "LeanInfoTheory.Probability.Finite"
        self.assertEqual(self.compiled(expected)["focused_simp"][empty_owner], [])
        for change, code in (
            (lambda result: result.pop("focused_simp"), "POLICY_SCHEMA"),
            (lambda result: result["focused_simp"].pop(empty_owner), "COMPILED_IMPORT_COVERAGE"),
            (lambda result: result["focused_simp"].update({"LeanInfoTheory.Shannon.Unexpected": []}), "COMPILED_IMPORT_COVERAGE"),
            (lambda result: result["focused_simp"].update({"not a module": []}), "POLICY_SCHEMA"),
        ):
            with self.subTest(code=code):
                compiled = self.compiled(expected)
                change(compiled)
                self.refuses(code, lambda: policy.compare_compiled_policy(expected, compiled))

    def test_focused_simp_changes_fail_even_when_full_umbrella_membership_is_restored(self) -> None:
        expected = self.expected()
        retained_simp = "LeanInfoTheory.Shannon.entropy_zero"
        extra_simp = "LeanInfoTheory.Shannon.entropy"
        for removed, added in ((retained_simp, None), (None, extra_simp)):
            with self.subTest(removed=removed, added=added):
                compiled = self.compiled(expected)
                if removed:
                    compiled["focused_simp"][ENTROPY].remove(removed)
                if added:
                    compiled["focused_simp"][ENTROPY].append(added)
                self.assertEqual(compiled["simp"], expected["simp"])
                error = self.refuses("COMPILED_FOCUSED_SIMP_MISMATCH",
                                     lambda: policy.compare_compiled_policy(expected, compiled))
                self.assertEqual(error.subject, ENTROPY)
                self.assertEqual(error.expected, {"removed": [removed] if removed else []})
                self.assertEqual(error.actual, {"added": [added] if added else []})
                self.assertIn(removed or added, str(error))
        policy.compare_compiled_policy(expected, self.compiled(expected))

    def test_focused_simp_rejects_duplicate_malformed_and_out_of_closure_names(self) -> None:
        expected = self.expected()
        for value, code in ((["LeanInfoTheory.Shannon.entropy_zero"] * 2, "POLICY_DUPLICATE"),
                            (["not a name"], "POLICY_SCHEMA"),
                            ([1], "POLICY_SCHEMA"), ("not an array", "POLICY_SCHEMA"),
                            (["LeanInfoTheory.Shannon.entropy_zero", "PMF.policyFixture"], "COMPILED_FOCUSED_SIMP_MISMATCH")):
            with self.subTest(value=value):
                compiled = self.compiled(expected)
                compiled["focused_simp"][ENTROPY] = value
                self.refuses(code, lambda: policy.compare_compiled_policy(expected, compiled))

    def test_compiled_simp_diagnostic_identifies_added_and_removed_after_common_prefix(self) -> None:
        expected = self.expected()
        expected["simp"] = [f"LeanInfoTheory.Shannon.common{i:03d}" for i in range(100)]
        removed = "LeanInfoTheory.Shannon.zzRemoved"
        added = "LeanInfoTheory.Shannon.zzAdded"
        expected["simp"].append(removed)
        compiled = self.compiled(expected)
        compiled["simp"].remove(removed)
        compiled["simp"].append(added)
        with self.assertRaises(policy.PolicyError) as caught:
            policy.compare_compiled_policy(expected, compiled)
        self.assertEqual(caught.exception.code, "COMPILED_SIMP_MISMATCH")
        self.assertEqual(caught.exception.expected, {"removed": [removed]})
        self.assertEqual(caught.exception.actual, {"added": [added]})
        self.assertIn(removed, str(caught.exception))
        self.assertIn(added, str(caught.exception))
        self.assertNotIn("common000", str(caught.exception))

    def test_compiled_pair_diagnostics_identify_changed_owner_and_alias_target(self) -> None:
        for field, code in (("declarations", "COMPILED_DECLARATION_COVERAGE"),
                            ("root_exports", "COMPILED_ROOT_ALIAS_MISMATCH"),
                            ("root_resolutions", "COMPILED_ROOT_RESOLUTION_MISMATCH")):
            with self.subTest(field=field):
                expected = self.expected()
                key, value = ("name", "owner") if field == "declarations" else ("alias", "target")
                expected_field = "root_exports" if field == "root_resolutions" else field
                entries = expected[expected_field]
                entries.extend({key: f"LeanInfoTheory.common{i:03d}", value: ENTROPY} for i in range(100))
                tail = {key: "LeanInfoTheory.zzChanged", value: ENTROPY}
                entries.append(tail)
                compiled = self.compiled(expected)
                changed = next(entry for entry in compiled[field] if entry[key] == tail[key])
                changed[value] = INFO
                with self.assertRaises(policy.PolicyError) as caught:
                    policy.compare_compiled_policy(expected, compiled)
                self.assertEqual(caught.exception.code, code)
                self.assertIn(tail[key], str(caught.exception))
                self.assertIn(ENTROPY, str(caught.exception))
                self.assertIn(INFO, str(caught.exception))
                self.assertNotIn("common000", str(caught.exception))

    def test_compiled_root_and_olean_coverage_refuse_leaks_or_wrong_paths(self) -> None:
        expected = self.expected()
        cases = (
            ("COMPILED_ROOT_CLOSURE_MISMATCH", lambda result: result["root_closure"].append(OPT)),
            ("COMPILED_OLEAN_PATH_MISMATCH", lambda result: result["olean_paths"][0].update(resolved="other/output.olean")),
            ("COMPILED_OLEAN_COVERAGE", lambda result: result["olean_paths"].pop()),
            ("POLICY_DUPLICATE", lambda result: result["olean_paths"].append(result["olean_paths"][0])),
            ("POLICY_SCHEMA", lambda result: result.update(unexpected=True)),
        )
        for code, change in cases:
            with self.subTest(code=code):
                compiled = self.compiled(expected)
                change(compiled)
                self.refuses(code, lambda: policy.compare_compiled_policy(expected, compiled))


class CurrentSourcePolicyTests(unittest.TestCase):
    def test_maintained_source_policy_inputs_agree_without_a_lean_run(self) -> None:
        frozen = frozen_api.verify_frozen_manifest()
        retained = json.loads((ROOT / "docs/compatibility/v0.1.0-retained-contract.json").read_text(encoding="utf-8"))
        current = current_api.build_manifest()
        approvals = policy.parse_policy((ROOT / "docs/compatibility/current-api-policy.json").read_text(encoding="utf-8"))
        imports = {info.name: {"local": list(info.local_imports), "external": list(info.external_imports)}
                   for info in blueprint.build_module_infos()}
        expected = policy.validate_source_policy(frozen, retained, current, imports, approvals)
        self.assertEqual(len(expected["declarations"]), current["declaration_count"])
        self.assertEqual(expected["supported_modules"], sorted(current["supported_modules"]))
        self.assertEqual(expected["root_exports"], sorted(current["root_exports"], key=lambda entry: entry["alias"]))


if __name__ == "__main__":
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    unittest.main(verbosity=2)
