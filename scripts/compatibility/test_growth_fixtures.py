#!/usr/bin/env python3
"""Python-only growth fixture construction and refusal-attribution tests.

Source generation and policy loading are real. Mocked gate results below check
the runner's attribution logic only; this suite does not run Lean or doc-gen.
"""

from __future__ import annotations

import copy
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
from compatibility import run_growth_fixtures as growth


class GrowthFixtureTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        (ROOT / "tmp").mkdir(exist_ok=True)
        paths = set(growth.check.INPUTS) | set(growth.GENERATED) | set(growth.ROOT_FILES)
        paths |= {path.relative_to(ROOT).as_posix() for path in growth.check.blueprint.lean_files()}
        paths |= {path.relative_to(ROOT).as_posix() for path in (ROOT / "scripts").rglob("*.py")}
        cls.raw = {relative: (ROOT / relative).read_bytes() for relative in paths}

    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="c903-unit-", dir=ROOT / "tmp")
        self.addCleanup(self.temporary.cleanup)
        self.source = Path(self.temporary.name) / "s"
        self.source.mkdir()
        for relative, raw in self.raw.items():
            path = self.source / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(raw)
        self.originals = {relative: self.raw[relative] for relative in growth.RESTORED}
        self.baseline = json.loads(self.originals[growth.GENERATED[0]])

    def generate(self):
        result = subprocess.run([sys.executable, "-B", "scripts/generate_current_public_api.py"],
                                cwd=self.source, capture_output=True, check=False)
        self.assertEqual(result.returncode, 0, (result.stdout + result.stderr).decode("utf-8"))

    def load_policy(self, *, expected=0):
        code = "import sys; sys.path.insert(0, 'scripts'); import current_api; current_api.load_current_manifest()"
        result = subprocess.run([sys.executable, "-B", "-c", code], cwd=self.source, capture_output=True, check=False)
        self.assertEqual(result.returncode, expected, (result.stdout + result.stderr).decode("utf-8"))
        return (result.stdout + result.stderr).decode("utf-8")

    def test_copy_allowlist_excludes_private_and_cache_paths(self):
        for relative in (".lit-review/journal.json", "tools/lit_review/core/evidence/private.json",
                         "tmp/notes.md", "docbuild/.lake/build/doc/index.html", "scripts/__pycache__/x.pyc",
                         "docs/../private.json", "/docs/absolute.md", "random-untracked.txt"):
            with self.subTest(relative=relative):
                self.assertFalse(growth.permitted_source(relative))
        for relative in ("docs/current-public-api.json", "docbuild/lakefile.toml", "home_page/index.html",
                         "scripts/compatibility/CurrentAudit.lean", ".github/workflows/lean.yml", "README.md"):
            self.assertTrue(growth.permitted_source(relative))

    def test_growth_copy_has_own_git_and_records_exact_static_inputs(self):
        setup = Path(self.temporary.name) / "setup"
        setup.mkdir()
        identity = {relative: growth.check.sha256(raw) for relative, raw in self.raw.items()}
        # Project-output copying is already maintained by C9.02. Avoid copying
        # build caches in this Python-only test; this test exercises the added
        # static-source, evidence and real isolated-Git setup boundary.
        with patch.object(growth.previous, "make_source_copy", return_value={}) as copier:
            originals = growth.make_growth_copy(self.source, setup, identity)
        copier.assert_called_once_with(self.source)
        self.assertEqual(originals, self.originals)
        self.assertEqual(json.loads((setup / "production-inputs.json").read_bytes()), identity)
        observed = (setup / "git-root.stdout").read_text(encoding="utf-8").strip()
        self.assertEqual(Path(observed).resolve(), self.source.resolve())
        self.assertEqual(json.loads((setup / "git-init.result.json").read_bytes())["exit_code"], 0)

    def test_unchanged_inventory_and_policy_pass(self):
        self.generate()
        growth.check_growth_inventory(self.source, self.baseline, "unchanged")
        self.load_policy()

    def test_documented_addition_has_exact_current_owner_and_no_policy_change(self):
        growth.previous.mutate("compatible_addition", self.source)
        self.generate()
        current = growth.check_growth_inventory(self.source, self.baseline, "compatible_addition")
        self.assertEqual(current["declaration_count"], self.baseline["declaration_count"] + 1)
        self.assertEqual((self.source / growth.POLICY).read_bytes(), self.originals[growth.POLICY])
        self.load_policy()

    def test_approved_module_has_exact_two_records_and_grows_current_surface(self):
        growth.add_module(self.source, approved=True)
        self.generate()
        current = growth.check_growth_inventory(self.source, self.baseline, "approved_module")
        self.assertEqual(current["supported_module_count"], self.baseline["supported_module_count"] + 1)
        policy = json.loads((self.source / growth.POLICY).read_bytes())
        old_records = json.loads(self.originals[growth.POLICY])["import_approvals"]
        records = policy["import_approvals"][len(old_records):]
        self.assertEqual({item["kind"] for item in records}, {"umbrella_addition", "new_module"})
        self.assertEqual({item["owner"] for item in records}, {"LeanInfoTheory.Shannon", growth.MODULE})
        self.assertTrue(all(item["consumer"].endswith(growth.NEW_NAME) for item in records))
        self.assertTrue(all(item["approval_reference"].startswith("fixture-only:") for item in records))
        self.assertEqual(growth.source_imports(self.source, growth.MODULE_PATH),
                         {"local": [growth.MODULE_IMPORT], "external": []})
        self.load_policy()

    def test_matched_unapproved_case_keeps_identical_sources_and_inventory(self):
        growth.add_module(self.source, approved=True)
        self.generate()
        self.load_policy()
        paths = (growth.MODULE_PATH, growth.UMBRELLA, growth.GENERATED[0])
        approved = growth.hashes(self.source, paths)
        (self.source / growth.POLICY).write_bytes(self.originals[growth.POLICY])
        self.generate()
        self.assertEqual(growth.hashes(self.source, paths), approved)
        growth.check_growth_inventory(self.source, self.baseline, "unapproved_module")
        text = self.load_policy(expected=1)
        self.assertIn("IMPORT_APPROVAL_REQUIRED: LeanInfoTheory.Shannon", text)

    def test_new_module_does_not_change_root_and_has_header_import(self):
        root_before = (self.source / "LeanInfoTheory.lean").read_bytes()
        growth.add_module(self.source, approved=False)
        text = (self.source / growth.MODULE_PATH).read_text(encoding="utf-8")
        self.assertLess(text.index("import " + growth.MODULE_IMPORT), text.index("namespace "))
        self.assertIn("/-- A documented declaration", text)
        self.assertEqual((self.source / "LeanInfoTheory.lean").read_bytes(), root_before)
        self.assertEqual((self.source / growth.POLICY).read_bytes(), self.originals[growth.POLICY])

    def test_existing_fixture_module_and_conflicting_approval_are_refused(self):
        growth.add_module(self.source, approved=True)
        with self.assertRaisesRegex(ValueError, "must start from restored"):
            growth.add_module(self.source, approved=True)
        growth.restore_source(self.source, self.originals)
        value = json.loads(self.originals[growth.POLICY])
        value["import_approvals"].append({"owner": "LeanInfoTheory.Shannon"})
        (self.source / growth.POLICY).write_text(json.dumps(value), encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "conflicts with existing owner"):
            growth.add_module(self.source, approved=True)

    def test_restoration_removes_only_new_module_and_restores_exact_bytes(self):
        growth.add_module(self.source, approved=True)
        self.generate()
        unrelated = self.source / "tmp/preserved.txt"
        unrelated.parent.mkdir()
        unrelated.write_text("preserve", encoding="utf-8")
        growth.restore_source(self.source, self.originals)
        self.assertFalse((self.source / growth.MODULE_PATH).exists())
        self.assertEqual(unrelated.read_text(encoding="utf-8"), "preserve")
        for relative, raw in self.originals.items():
            self.assertEqual((self.source / relative).read_bytes(), raw)

    def test_inventory_rejects_wrong_addition_owner_and_hidden_extra_name(self):
        growth.previous.mutate("compatible_addition", self.source)
        self.generate()
        path = self.source / growth.GENERATED[0]
        original = json.loads(path.read_bytes())
        value = copy.deepcopy(original)
        next(entry for entry in value["declarations"] if entry["name"] == growth.ADDED_NAME)["module"] = growth.MODULE
        path.write_text(json.dumps(value), encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "owner/attributes"):
            growth.check_growth_inventory(self.source, self.baseline, "compatible_addition")
        original["declarations"].append({"name": "unexpected"})
        path.write_text(json.dumps(original), encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "exactly the intended declaration"):
            growth.check_growth_inventory(self.source, self.baseline, "compatible_addition")

    def test_failed_negative_gate_requires_exact_policy_cause(self):
        out = Path(self.temporary.name)
        for text, exit_code, accepted in (("IMPORT_APPROVAL_REQUIRED: LeanInfoTheory.Shannon; expected=old, actual=current", 1, True),
                                          ("compiler failed", 1, False),
                                          ("IMPORT_APPROVAL_REQUIRED: LeanInfoTheory.Shannon", 0, False),
                                          ("IMPORT_APPROVAL_REQUIRED: LeanInfoTheory.Basic", 1, False),
                                          ("IMPORT_APPROVAL_REQUIRED: LeanInfoTheory.ShannonOther", 1, False)):
            with self.subTest(text=text, exit_code=exit_code), patch.object(growth, "run", return_value={"exit_code": exit_code}), \
                    patch.object(growth, "output_text", return_value=text):
                if accepted:
                    growth.maintained_gate(self.source, out, "static", approved=False)
                else:
                    with self.assertRaisesRegex(ValueError, "specifically for missing import approval"):
                        growth.maintained_gate(self.source, out, "static", approved=False)

    def test_record_creation_is_exclusive(self):
        path = Path(self.temporary.name) / "record.json"
        growth.write_record(path, {"original": True})
        with self.assertRaises(FileExistsError):
            growth.write_record(path, {"original": False})
        self.assertEqual(json.loads(path.read_bytes()), {"original": True})

    def test_schedule_retains_changed_positive_trust_and_explicit_unchanged_omission(self):
        out = Path(self.temporary.name)
        expected_gates = {"unchanged": ["static"], "compatible_addition": ["static", "trust"],
                          "approved_module": ["static", "trust"],
                          "unapproved_module": ["static", "trust", "compatibility"]}
        for case, commands in expected_gates.items():
            with self.subTest(case=case), patch.object(growth, "maintained_gate", return_value={"exit_code": 1 if case == "unapproved_module" else 0}) as gate:
                result = growth.qualification_gates(self.source, out, case)
                self.assertEqual([call.args[2] for call in gate.call_args_list], commands)
                self.assertTrue(all(call.kwargs["approved"] == (case != "unapproved_module")
                                    for call in gate.call_args_list))
                if case == "unchanged":
                    self.assertIsNone(result["trust_exit"])
                    self.assertEqual(result["trust_status"], "NOT_RUN")
                else:
                    self.assertEqual(result["trust_status"], "EXPECTED_POLICY_REFUSAL" if case == "unapproved_module" else "PASS")

    def test_unchanged_consumer_requests_fresh_focused_owner_build(self):
        out = Path(self.temporary.name)
        with patch.object(growth, "run", return_value={"exit_code": 0}) as run:
            growth.consumer(self.source, out, "unchanged")
        self.assertEqual(run.call_args_list[0].args[0],
                         [sys.executable, "-B", "scripts/validate_release.py", "focused", growth.MODULE_IMPORT])
        self.assertEqual(run.call_args_list[1].args[0][:4], ["lake", "env", "lean", "-DwarningAsError=true"])
        self.assertIn("import " + growth.MODULE_IMPORT,
                      (self.source / "tmp/c9-growth-consumer.lean").read_text(encoding="utf-8"))

    def test_documentation_edits_change_source_but_leave_generated_manifest_exact(self):
        owner = self.source / growth.DOC_OWNER
        original, manifest = owner.read_bytes(), (self.source / growth.GENERATED[0]).read_bytes()
        for kind in ("signature", "body", "docstring"):
            with self.subTest(kind=kind):
                with growth.temporary_documentation_edit(self.source, kind) as evidence:
                    self.assertNotEqual(owner.read_bytes(), original)
                    self.assertEqual(bytes.fromhex(evidence["original_bytes_hex"]), original)
                    self.assertEqual(bytes.fromhex(evidence["changed_bytes_hex"]), owner.read_bytes())
                    self.assertFalse(evidence["lean_compilation_claimed"])
                    self.generate()
                    self.assertEqual((self.source / growth.GENERATED[0]).read_bytes(), manifest)
                self.assertEqual(owner.read_bytes(), original)
        with self.assertRaisesRegex(ValueError, "declaration anchor changed"):
            growth.changed_documentation_source("body", "no declaration anchor")

    def test_documentation_edit_restores_source_and_manifest_on_error(self):
        owner, manifest = self.source / growth.DOC_OWNER, self.source / growth.GENERATED[0]
        original_source, original_manifest = owner.read_bytes(), manifest.read_bytes()
        with self.assertRaisesRegex(RuntimeError, "simulated checker failure"):
            with growth.temporary_documentation_edit(self.source, "body"):
                manifest.write_text("deliberately stale", encoding="utf-8")
                raise RuntimeError("simulated checker failure")
        self.assertEqual(owner.read_bytes(), original_source)
        self.assertEqual(manifest.read_bytes(), original_manifest)

    def test_documentation_failure_requires_specific_stale_identity_cause(self):
        growth.require_stale_documentation_refusal(1, "API documentation check failed: " + growth.STALE_DOC_DIAGNOSTIC)
        for code, text in ((0, growth.STALE_DOC_DIAGNOSTIC),
                           (1, "current public API manifest is stale or invalid"),
                           (1, "IMPORT_APPROVAL_REQUIRED: LeanInfoTheory.Shannon")):
            with self.subTest(code=code, text=text), self.assertRaisesRegex(ValueError, "specifically for stale source-content identity"):
                growth.require_stale_documentation_refusal(code, text)

    def test_source_negatives_reach_real_generator_and_source_policy_without_lean(self):
        original = growth.hashes(self.source, (growth.OWNER, growth.GENERATED[0]))
        for kind in growth.SOURCE_NEGATIVES:
            with self.subTest(kind=kind):
                with growth.temporary_source_negative(self.source, kind) as evidence:
                    self.assertFalse(evidence["lean_compilation_claimed"])
                    self.assertEqual(bytes.fromhex(evidence["changed_bytes_hex"]),
                                     (self.source / evidence["path"]).read_bytes())
                    command = [sys.executable, "-B", "scripts/generate_current_public_api.py"]
                    if kind == "unindexed_addition":
                        command.append("--check")
                    result = subprocess.run(command, cwd=self.source, capture_output=True, check=False)
                    output = (result.stdout + result.stderr).decode("utf-8")
                    growth.require_source_negative_refusal(kind, "generator", result.returncode, output)
                    # Static uses this actual loader. Full static/runtime gates
                    # are left to the real runner; this Python test invokes no Lean.
                    text = self.load_policy(expected=1)
                    growth.require_source_negative_refusal(kind, "static", 1, text)
                    self.assertEqual(growth.hashes(self.source, (growth.GENERATED[0],)),
                                     {growth.GENERATED[0]: original[growth.GENERATED[0]]})
                self.assertEqual(growth.hashes(self.source, tuple(original)), original)
                self.assertFalse((self.source / growth.UNCLASSIFIED_PATH).exists())

    def test_source_negative_restores_bytes_and_new_file_after_error(self):
        original = growth.hashes(self.source, (growth.OWNER, growth.GENERATED[0]))
        for kind in ("undocumented_addition", "unclassified_module"):
            with self.subTest(kind=kind), self.assertRaisesRegex(RuntimeError, "interrupted source check"):
                with growth.temporary_source_negative(self.source, kind):
                    (self.source / growth.GENERATED[0]).write_bytes(b"unexpected generator write")
                    raise RuntimeError("interrupted source check")
            self.assertEqual(growth.hashes(self.source, tuple(original)), original)
            self.assertFalse((self.source / growth.UNCLASSIFIED_PATH).exists())
        existing = self.source / growth.UNCLASSIFIED_PATH
        existing.write_bytes(b"preserve unrelated original")
        with self.assertRaisesRegex(ValueError, "fixture path already exists"):
            with growth.temporary_source_negative(self.source, "unclassified_module"):
                self.fail("existing module must not be overwritten")
        self.assertEqual(existing.read_bytes(), b"preserve unrelated original")

    def test_source_negative_failure_requires_subject_and_failure_exit(self):
        kind, stage = "undocumented_addition", "generator"
        correct = "undocumented supported declarations: ['" + growth.ADDED_NAME + "']"
        growth.require_source_negative_refusal(kind, stage, 1, correct)
        for exit_code, output in ((0, correct), (1, "undocumented supported declarations: ['Wrong.name']"),
                                  (1, "IMPORT_APPROVAL_REQUIRED: " + growth.ADDED_NAME), (1, "compiler error")):
            with self.subTest(exit_code=exit_code, output=output), self.assertRaisesRegex(ValueError, "required source/inventory reason"):
                growth.require_source_negative_refusal(kind, stage, exit_code, output)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
    unittest.main()
