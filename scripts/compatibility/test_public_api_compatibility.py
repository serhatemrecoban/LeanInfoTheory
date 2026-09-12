#!/usr/bin/env python3
"""Focused structural-input and standalone freshness orchestration regressions.

Mocked command-order cases below are not Lean integration evidence. The separate
run_compatibility_fixtures.py runner exercises real source copies and builds.
"""

from __future__ import annotations

import copy
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
import check_public_api_compatibility as check
import validate_release as validator


class StructuralContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest, cls.baseline = check.load_baseline()
        cls.export = {"schema": cls.baseline["exporter"]["schema"],
                      "declarations": cls.baseline["declarations"]}

    def test_all_maintained_retained_types_validate_and_compare(self):
        check.compare_types(self.baseline, check.encode(self.export), self.manifest)

    def test_named_diagnostic_preserves_structural_change_location(self):
        value = copy.deepcopy(self.export)
        record = next(r for r in value["declarations"] if r["type"][0] == "forall")
        record["type"][1] = ["str", ["anonymous"], "c9Renamed"]
        with self.assertRaisesRegex(ValueError, re_escape(record["name"]) + r" at type\[1\]"):
            check.compare_types(self.baseline, check.encode(value), self.manifest)

    def test_unresolved_and_malformed_types_are_rejected(self):
        original = self.baseline["declarations"][0]
        for value in (["mvar", "hole"], ["bvar", 0], ["bvar", False],
                      ["natLiteral", True], ["sort", ["param", ["str", ["anonymous"], "unbound"]]],
                      ["const", ["anonymous"], [], "extra"], ["let", ["anonymous"], 0, [], [], []]):
            with self.subTest(value=value), self.assertRaisesRegex(ValueError, "invalid retained type"):
                check.check_record_types([{**original, "type": value}])

    def test_duplicate_universe_parameters_are_rejected(self):
        record = copy.deepcopy(self.baseline["declarations"][0])
        record["universe_parameters"] = [["str", ["anonymous"], "u"]] * 2
        with self.assertRaisesRegex(ValueError, "duplicate universe"):
            check.check_record_types([record])

    def test_duplicate_json_keys_and_non_json_constants_are_rejected(self):
        for raw in (b'{"a":1,"a":2}', b'{"a":NaN}', b'{"a":Infinity}'):
            with self.subTest(raw=raw), self.assertRaises(ValueError):
                check.strict_json(raw)

    def test_import_header_refuses_prelude_and_unsupported_modes(self):
        for text in ("prelude\nimport Init\n", "module\nimport Foo\n",
                     "public import Foo\n", "meta import Foo\n",
                     "public meta import Foo\n", "import all Foo\n",
                     "import Foo Bar\n", "import\nFoo\n",
                     "/- nested /- comment -/ -/ prelude\nimport Foo\n"):
            with self.subTest(text=text), self.assertRaisesRegex(ValueError, "unsupported source import"):
                check.source_header_imports(text, "Fixture")
        text = "/- prelude\n/- module -/ -/ -- meta import Fake\nimport Init\nimport Foo\n/-! prelude -/\nprivate theorem x : True := by trivial"
        self.assertEqual(check.source_header_imports(text, "Fixture"), ["Init", "Foo"])

    def test_maintained_headers_match_shared_import_parser(self):
        observed = check.direct_source_imports()
        self.assertEqual(set(observed), {info.name for info in check.blueprint.build_module_infos()})

    def test_changed_retained_artifact_cannot_become_a_new_baseline(self):
        with tempfile.TemporaryDirectory(dir=ROOT / "tmp", prefix="c9-02-input-unit-") as directory:
            artifact = Path(directory) / "retained.json"
            artifact.write_bytes(check.retained.ARTIFACT.read_bytes() + b" ")
            with patch.object(check.retained, "ARTIFACT", artifact), self.assertRaisesRegex(ValueError, "artifact identity"):
                check.load_baseline()

    def test_source_inventory_detects_added_and_removed_files(self):
        with tempfile.TemporaryDirectory(dir=ROOT / "tmp", prefix="c9-02-source-unit-") as directory:
            root = Path(directory)
            one, two = root / "One.lean", root / "Two.lean"
            one.write_text("def one := 1\n", encoding="utf-8")
            with patch.object(check, "ROOT", root), patch.object(check, "INPUTS", ()), \
                 patch.object(check.blueprint, "lean_files", side_effect=lambda: sorted(root.glob("*.lean"))):
                before = check.source_identity()
                two.write_text("def two := 2\n", encoding="utf-8")
                after = check.source_identity()
                self.assertNotEqual(before, after)
                self.assertEqual(set(after) - set(before), {"Two.lean"})
                one.unlink()
                self.assertNotEqual(after, check.source_identity())


def re_escape(text):
    import re
    return re.escape(text)


class FakeEvidence:
    def __init__(self, path, baseline, failure=None, changed_type=False):
        self.path, self.baseline = path, baseline
        self.failure, self.changed_type = failure, changed_type
        self.labels, self.commands, self.writes = [], [], {}

    def write(self, name, value):
        self.writes[name] = value

    def run(self, label, args):
        self.labels.append(label)
        self.commands.append({"label": label, "command": args, "exit_code": 0})
        if label == self.failure:
            raise ValueError(f"{label} failed (fixture)")
        if label == "compiler":
            return b"Lean (version 4.33.1, x86_64-w64-windows-gnu, commit 819816b2e0a3bf405af45ae5c7af2491d8f5bee6, Release)\n"
        if label == "retained":
            records = copy.deepcopy(self.baseline["declarations"])
            if self.changed_type:
                records[0]["type"] = ["sort", ["zero"]]
            return check.encode({"schema": self.baseline["exporter"]["schema"], "declarations": records})
        return b"{}"


class FreshnessOrchestrationTests(unittest.TestCase):
    def exercise(self, *, failure=None, changed_type=False, drift=False):
        manifest, baseline = check.load_baseline()
        with tempfile.TemporaryDirectory(dir=ROOT / "tmp", prefix="c9-02-order-unit-") as directory:
            evidence = FakeEvidence(Path(directory), baseline, failure, changed_type)
            current = {"declarations": manifest["declarations"], "supported_modules": manifest["supported_modules"]}
            self.evidence = evidence
            with patch.object(check, "source_identity", side_effect=[{"test": "before"}, {"test": "after" if drift else "before"}]), \
                 patch.object(check.retained, "dependency_identity", return_value=baseline["dependencies"]), \
                 patch.object(check, "unredirected_tree"), \
                 patch.object(check.current_api, "build_manifest", return_value=current), \
                 patch.object(check, "direct_source_imports", return_value={}), \
                 patch.object(check.current_policy, "validate_source_policy", return_value={"root_exports": manifest["root_exports"]}), \
                 patch.object(check.current_policy, "compare_compiled_policy"), \
                 patch.object(check, "assemble_driver", return_value=b"-- mocked driver; not executed\n"):
                return check.run_compatibility(evidence)

    def test_success_requires_build_then_retained_export_then_boundaries(self):
        result = self.exercise()
        self.assertEqual(self.evidence.labels, ["compiler", "build", "retained", "boundaries"])
        self.assertEqual(result["outcome"], "PASS")
        self.assertEqual(self.evidence.writes["source-before.json"], self.evidence.writes["source-after.json"])
        build = self.evidence.commands[1]["command"]
        self.assertEqual(build, ["lake", "-KwarningAsError=true", "build", "LeanInfoTheory.Shannon"])

    def test_failed_build_cannot_export_or_pass_old_artifacts(self):
        with self.assertRaisesRegex(ValueError, "build failed"):
            self.exercise(failure="build")
        self.assertEqual(self.evidence.labels, ["compiler", "build"])

    def test_changed_retained_type_fails_before_boundary_sweep(self):
        with self.assertRaisesRegex(ValueError, "retained contract changed"):
            self.exercise(changed_type=True)
        self.assertEqual(self.evidence.labels, ["compiler", "build", "retained"])

    def test_source_change_during_successful_commands_cannot_pass(self):
        with self.assertRaisesRegex(ValueError, "changed during compatibility"):
            self.exercise(drift=True)
        self.assertEqual(self.evidence.labels, ["compiler", "build", "retained", "boundaries"])

    def test_validator_standalone_entry_does_not_require_an_earlier_build(self):
        calls = []
        with patch.object(sys, "argv", ["validate_release.py", "compatibility"]), \
             patch.object(validator, "run_command", side_effect=lambda command: calls.append(command)):
            self.assertEqual(validator.main(), 0)
        self.assertEqual(calls, [(sys.executable, "scripts/check_public_api_compatibility.py")])


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
    (ROOT / "tmp").mkdir(exist_ok=True)
    unittest.main(verbosity=2)
