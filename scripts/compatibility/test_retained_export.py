#!/usr/bin/env python3
"""Focused C9.01 serializer and freshly generated export-envelope tests.

Envelope mutations below test Python validation only, not real Lean signature
compatibility. The separately recorded compiling source-copy regressions establish
the latter. ``check_export`` consumes fresh output from the pinned exporter; it
does not validate arbitrary submitted structural trees recursively. The C9.02
checker owns that future artifact-input boundary.
"""

from __future__ import annotations

import copy
import hashlib
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import export_retained_api as retained

PROBE_MAIN = r'''
namespace SerializerUnitProbe

def require (condition : Bool) (message : String) : IO Unit := do
  unless condition do throw (IO.userError message)

def different (left right : Except String Json) (message : String) : IO Unit := do
  require ((← RetainedExport.liftResult left) != (← RetainedExport.liftResult right)) message

def rejects (value : Except String Json) (expected : String) : IO Unit := do
  match value with
  | .error message => require (message == expected) s!"wrong diagnostic: {message}"
  | .ok _ => throw (IO.userError s!"accepted prohibited form: {expected}")

end SerializerUnitProbe

open RetainedExport SerializerUnitProbe

def main : IO Unit := do
  let nat := Expr.const `Nat []
  let arrow := fun name info => Expr.forallE name nat (.bvar 0) info
  different (exprJson (arrow `x .default)) (exprJson (arrow `renamed .default))
    "binder names were erased"
  let infos := #[BinderInfo.default, .implicit, .strictImplicit, .instImplicit]
  for i in [:infos.size] do
    for j in [:i] do
      different (exprJson (arrow `x infos[i]!)) (exprJson (arrow `x infos[j]!))
        "binder information was erased"
  different (exprJson (.const `F [.param `u, .param `v]))
    (exprJson (.const `F [.param `v, .param `u])) "universe argument order was erased"
  different (levelJson (.param `u)) (levelJson (.param `v)) "universe names were erased"
  different (levelJson (.max (.param `u) (.param `v)))
    (levelJson (.imax (.param `u) (.param `v))) "max and imax were conflated"
  different (levelJson .zero) (levelJson (.succ .zero)) "universe successor was erased"
  require (nameJson (.num .anonymous 1) != nameJson (.str .anonymous "1"))
    "numeric and string name components were conflated"
  require (nameJson .anonymous != nameJson (.str .anonymous ""))
    "anonymous and empty string name components were conflated"
  different (exprJson (.lit (.natVal 1))) (exprJson (.lit (.strVal "1")))
    "literal constructors were conflated"
  different (exprJson (.app (.const `f []) (.const `x [])))
    (exprJson (.app (.const `x []) (.const `f []))) "application order was erased"
  different (exprJson (.letE `x nat (.lit (.natVal 0)) (.bvar 0) true))
    (exprJson (.letE `x nat (.lit (.natVal 0)) (.bvar 0) false)) "let dependency flag was erased"
  different (exprJson (.proj `Prod 0 (.const `p [])))
    (exprJson (.proj `Prod 1 (.const `p []))) "projection index was erased"
  different (exprJson (.proj `Prod 0 (.const `p [])))
    (exprJson (.proj `Other 0 (.const `p []))) "projection owner was erased"
  let _ ← liftResult (exprJson (.lam `x nat (.bvar 0) .default))
  let _ ← liftResult (exprJson (.letE `x nat (.lit (.natVal 0)) (.bvar 0) true))
  rejects (exprJson (.bvar 0)) "unbound de Bruijn index"
  rejects (exprJson (.lam `x nat (.bvar 1) .default)) "unbound de Bruijn index"
  rejects (exprJson (.letE `x nat (.bvar 0) (.bvar 0) true)) "unbound de Bruijn index"
  rejects (exprJson (.fvar ⟨`fixture⟩)) "unresolved free variable"
  rejects (exprJson (.mvar ⟨`fixture⟩)) "unresolved expression metavariable"
  rejects (levelJson (.mvar ⟨`fixture⟩)) "unresolved universe metavariable"
  rejects (exprJson (.const `F [.mvar ⟨`fixture⟩])) "unresolved universe metavariable"
  rejects (exprJson (.mdata {} nat)) "expression metadata requires an explicitly reviewed encoding"
  IO.println "C9_SERIALIZER_UNIT_PROBE_OK"
'''


class ExportEnvelopeTests(unittest.TestCase):
    """Validation of fresh exporter envelopes, using the maintained 601 baseline."""

    @classmethod
    def setUpClass(cls):
        artifact = json.loads(retained.ARTIFACT.read_bytes())
        cls.manifest = json.loads(retained.frozen.FROZEN_PATH.read_bytes())
        cls.valid = {"schema": artifact["exporter"]["schema"],
                     "declarations": artifact["declarations"]}

    def check(self, value):
        return retained.check_export(json.dumps(value, ensure_ascii=False).encode("utf-8"), self.manifest)

    def test_maintained_baseline_has_complete_coverage(self):
        records = self.check(self.valid)
        self.assertEqual(len(records), 601)
        self.assertEqual([r["name"] for r in records],
                         [d["name"] for d in self.manifest["declarations"]])

    def test_prop_valued_instance_retains_its_actual_theorem_kind(self):
        records = self.check(self.valid)
        instances = [r for r in records if r["source_kind"] == "instance"]
        self.assertEqual(len(instances), 1)
        self.assertEqual(instances[0]["name"], "LeanInfoTheory.Shannon.pmfChannelKernel.instIsMarkovKernel")
        self.assertEqual(instances[0]["compiled_kind"], "theorem")

    def test_unknown_schema_and_envelope_fields_are_refused(self):
        for mutation in ({**self.valid, "schema": "unknown"}, {**self.valid, "extra": True}):
            with self.subTest(mutation=list(mutation)), self.assertRaisesRegex(ValueError, "schema"):
                self.check(mutation)

    def test_missing_or_added_record_is_refused(self):
        records = self.valid["declarations"]
        for changed in (records[:-1], records + [records[0]]):
            with self.subTest(count=len(changed)), self.assertRaisesRegex(ValueError, "601"):
                self.check({**self.valid, "declarations": changed})

    def test_duplicate_or_reordered_record_is_refused(self):
        original = self.valid["declarations"]
        for changed in ([original[1], original[1]] + original[2:],
                        [original[1], original[0]] + original[2:]):
            with self.subTest(names=[r["name"] for r in changed[:2]]), self.assertRaisesRegex(ValueError, "names/order"):
                self.check({**self.valid, "declarations": changed})

    def test_changed_name_is_refused(self):
        changed = copy.deepcopy(self.valid)
        changed["declarations"][0]["name"] += "_changed"
        with self.assertRaisesRegex(ValueError, "names/order"):
            self.check(changed)

    def test_owner_source_kind_and_compiled_kind_are_checked(self):
        for field, value in (("owner", "Wrong.Owner"), ("source_kind", "axiom"),
                             ("compiled_kind", "axiom")):
            changed = copy.deepcopy(self.valid)
            changed["declarations"][0][field] = value
            with self.subTest(field=field), self.assertRaisesRegex(ValueError, "ownership/kind"):
                self.check(changed)

    def test_ordinary_definition_cannot_report_compiled_theorem_kind(self):
        changed = copy.deepcopy(self.valid)
        record = next(r for r in changed["declarations"] if r["source_kind"] == "def")
        record["compiled_kind"] = "theorem"
        with self.assertRaisesRegex(ValueError, "ownership/kind"):
            self.check(changed)

    def test_missing_or_added_record_field_is_refused(self):
        for remove in (False, True):
            changed = copy.deepcopy(self.valid)
            record = changed["declarations"][0]
            if remove:
                del record["owner"]
            else:
                record["extra"] = True
            with self.subTest(remove=remove), self.assertRaisesRegex(ValueError, "ownership/kind"):
                self.check(changed)

    def test_type_and_universes_require_list_shapes(self):
        for field in ("type", "universe_parameters"):
            changed = copy.deepcopy(self.valid)
            changed["declarations"][0][field] = None
            with self.subTest(field=field), self.assertRaisesRegex(ValueError, "complete retained type"):
                self.check(changed)


class SerializerLeanTests(unittest.TestCase):
    def test_actual_serializer_preserves_contracts_and_refuses_unresolved_forms(self):
        exporter_bytes = retained.EXPORTER.read_bytes()
        source = exporter_bytes.decode("utf-8")
        marker = "\ndef main (args : List String) : IO Unit := do"
        self.assertEqual(source.count(marker), 1, "update the probe boundary after exporter entry-point changes")
        prefix, _ = source.split(marker)
        scratch_root = retained.ROOT / "tmp"
        scratch_root.mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(prefix="c9-serializer-unit-", dir=scratch_root) as scratch:
            scratch_path = Path(scratch)
            self.assertTrue(scratch_path.resolve().is_relative_to(scratch_root.resolve()))
            ignored = subprocess.run(["git", "check-ignore", scratch_path.relative_to(retained.ROOT).as_posix()],
                                     cwd=retained.ROOT, capture_output=True, check=False)
            self.assertEqual(ignored.returncode, 0, "serializer unit probe directory must be ignored")
            probe = scratch_path / "SerializerUnitProbe.lean"
            probe_bytes = (prefix + "\n" + PROBE_MAIN).encode("utf-8")
            probe.write_bytes(probe_bytes)
            command = ["lake", "env", "lean", "-DwarningAsError=true", "--run", str(probe)]
            result = subprocess.run(command, cwd=retained.ROOT, capture_output=True, check=False)
            print(json.dumps({"scope": "standalone serializer unit probe; no project build or mathematical theorem",
                              "command": command, "exporter_sha256": hashlib.sha256(exporter_bytes).hexdigest(),
                              "probe_sha256": hashlib.sha256(probe_bytes).hexdigest(), "exit_code": result.returncode,
                              "stdout_hex": result.stdout.hex(), "stderr_hex": result.stderr.hex()}), flush=True)
            self.assertEqual(retained.EXPORTER.read_bytes(), exporter_bytes, "exporter changed while testing")
            self.assertEqual(result.returncode, 0,
                             result.stdout.decode("utf-8", errors="replace") + result.stderr.decode("utf-8", errors="replace"))
            self.assertEqual(result.stdout.decode("utf-8").strip(), "C9_SERIALIZER_UNIT_PROBE_OK")
            self.assertEqual(result.stderr, b"")
            self.assertTrue(scratch_path.resolve().is_relative_to(scratch_root.resolve()))


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
    unittest.main(verbosity=2)
