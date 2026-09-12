#!/usr/bin/env python3
"""Focused regressions for the historical/current public API inventory split."""

from __future__ import annotations

from collections import Counter
from contextlib import redirect_stderr, redirect_stdout
from dataclasses import replace
import hashlib
import io
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import frozen_public_api as frozen
import generate_current_public_api as current
import validate_release as release


ROOT = Path(__file__).resolve().parents[1]


class InventoryFixture(unittest.TestCase):
    def setUp(self) -> None:
        parent = ROOT / "tmp" / "current-public-api-tests"
        self.assertTrue(parent.resolve().is_relative_to(ROOT.resolve()))
        ignored = subprocess.run(
            ["git", "check-ignore", "-q", "tmp/current-public-api-tests/"],
            cwd=ROOT, capture_output=True, text=True, encoding="utf-8", check=False,
        )
        self.assertEqual(ignored.returncode, 0, "test storage must remain ignored")
        parent.mkdir(parents=True, exist_ok=True)
        temporary = tempfile.TemporaryDirectory(prefix="inventory-", dir=parent)
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.assertTrue(self.root.resolve().is_relative_to(parent.resolve()))
        frozen.verify_frozen_manifest()
        self.lf = frozen.FROZEN_PATH.read_bytes().replace(b"\r\n", b"\n")
        self.crlf = self.lf.replace(b"\n", b"\r\n")

    def assert_unchanged(self, path: Path, before: bytes, mtime: int) -> None:
        self.assertEqual(path.read_bytes(), before)
        self.assertEqual(path.stat().st_mtime_ns, mtime)


class FrozenManifestTests(InventoryFixture):
    def test_only_exact_lf_and_recorded_crlf_are_accepted_without_writes(self) -> None:
        for raw, expected_hash in (
            (self.lf, frozen.GIT_BLOB_SHA256),
            (self.crlf, frozen.INTAKE_CRLF_SHA256),
        ):
            with self.subTest(sha256=expected_hash):
                path = self.root / "historical.json"
                path.write_bytes(raw)
                mtime = path.stat().st_mtime_ns
                self.assertEqual(hashlib.sha256(raw).hexdigest(), expected_hash)
                self.assertEqual(frozen.verify_frozen_manifest(path), json.loads(self.lf))
                self.assert_unchanged(path, raw, mtime)

    def test_mixed_endings_formatting_and_substantive_changes_are_rejected(self) -> None:
        changed = json.loads(self.lf)
        changed["declarations"][0]["name"] += "_changed"
        candidates = {
            "mixed endings": self.lf.replace(b"\n", b"\r\n", 1),
            "equivalent compact JSON": json.dumps(json.loads(self.lf)).encode("utf-8"),
            "equivalent indentation": json.dumps(json.loads(self.lf), indent=4).encode("utf-8"),
            "trailing whitespace": self.lf + b" ",
            "changed declaration": (json.dumps(changed, indent=2, sort_keys=True) + "\n").encode("utf-8"),
        }
        for label, raw in candidates.items():
            with self.subTest(change=label):
                path = self.root / "historical.json"
                path.write_bytes(raw)
                mtime = path.stat().st_mtime_ns
                with self.assertRaisesRegex(ValueError, "identity mismatch"):
                    frozen.verify_frozen_manifest(path)
                self.assert_unchanged(path, raw, mtime)


class HistoricalEntryPointTests(InventoryFixture):
    def setUp(self) -> None:
        super().setUp()
        scripts = self.root / "scripts"
        scripts.mkdir()
        (self.root / "docs").mkdir()
        for name in ("generate_v0_1_public_api.py", "frozen_public_api.py"):
            shutil.copyfile(ROOT / "scripts" / name, scripts / name)
        self.manifest = self.root / "docs" / "v0.1-public-api.json"

    def invoke(self, check: bool) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [sys.executable, "-B", "scripts/generate_v0_1_public_api.py", *(["--check"] if check else [])],
            cwd=self.root, capture_output=True, text=True, encoding="utf-8", check=False,
        )

    def test_both_modes_verify_without_current_source_or_mutation(self) -> None:
        # Only the verifier and frozen helper are copied: no Lean or source parser.
        for raw in (self.lf, self.crlf):
            for check in (False, True):
                with self.subTest(crlf=raw == self.crlf, check=check):
                    self.manifest.write_bytes(raw)
                    mtime = self.manifest.stat().st_mtime_ns
                    before_files = sorted(p.relative_to(self.root) for p in self.root.rglob("*") if p.is_file())
                    result = self.invoke(check)
                    self.assertEqual(result.returncode, 0, result.stderr)
                    self.assertIn("no files written", result.stdout)
                    self.assert_unchanged(self.manifest, raw, mtime)
                    self.assertEqual(before_files, sorted(p.relative_to(self.root) for p in self.root.rglob("*") if p.is_file()))

    def test_both_modes_reject_changes_and_missing_files_without_repair(self) -> None:
        changed = self.lf + b" "
        for check in (False, True):
            with self.subTest(check=check):
                self.manifest.write_bytes(changed)
                mtime = self.manifest.stat().st_mtime_ns
                result = self.invoke(check)
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("identity mismatch", result.stderr)
                self.assert_unchanged(self.manifest, changed, mtime)
                self.manifest.unlink()
                self.assertNotEqual(self.invoke(check).returncode, 0)
                self.assertFalse(self.manifest.exists())


class CurrentManifestTests(InventoryFixture):
    def test_generation_is_repeatable_and_check_rejects_stale_or_missing_output(self) -> None:
        output = self.root / "current.json"
        historical = frozen.FROZEN_PATH.read_bytes()
        historical_mtime = frozen.FROZEN_PATH.stat().st_mtime_ns
        with patch.object(current, "OUTPUT", output), redirect_stdout(io.StringIO()), redirect_stderr(io.StringIO()):
            self.assertEqual(current.main([]), 0)
            first = output.read_bytes()
            self.assertNotIn(b"\r", first)
            self.assertEqual(current.main([]), 0)
            self.assertEqual(output.read_bytes(), first)
            mtime = output.stat().st_mtime_ns
            self.assertEqual(current.main(["--check"]), 0)
            self.assert_unchanged(output, first, mtime)
            stale = first + b" "
            output.write_bytes(stale)
            mtime = output.stat().st_mtime_ns
            self.assertEqual(current.main(["--check"]), 1)
            self.assert_unchanged(output, stale, mtime)
            output.unlink()
            self.assertEqual(current.main(["--check"]), 1)
            self.assertFalse(output.exists())
        self.assert_unchanged(frozen.FROZEN_PATH, historical, historical_mtime)

    def test_schema_baseline_identity_and_derived_source_inventory(self) -> None:
        manifest = current.build_manifest()
        self.assertEqual(manifest["schema"], "lean-info-theory.current-public-api.v1")
        self.assertEqual(manifest["baseline_identity"], frozen.baseline_identity())
        supported = set(manifest["supported_modules"])
        parsed = [decl for decl in current.api_index.all_declarations() if decl.module in supported]
        self.assertEqual(
            {(entry["name"], entry["module"], entry["kind"]) for entry in manifest["declarations"]},
            {(decl.name, decl.module, decl.kind) for decl in parsed},
        )
        self.assertEqual(manifest["declaration_count"], len(parsed))
        self.assertEqual(manifest["documented_declaration_count"], sum(bool(decl.doc) for decl in parsed))
        self.assertEqual(manifest["kind_counts"], dict(Counter(decl.kind for decl in parsed)))
        self.assertEqual(sum(manifest["namespace_counts"].values()), len(parsed))
        self.assertEqual(manifest["supported_module_count"], len(supported))
        self.assertEqual(manifest["non_stable_module_count"], len(manifest["non_stable_modules"]))
        self.assertEqual(manifest["local_module_count"], len(current.blueprint.build_module_infos()))
        self.assertEqual(manifest["root_export_count"], len(manifest["root_exports"]))
        self.assertEqual(manifest["simp_declaration_count"], sum("simp" in entry["attributes"] for entry in manifest["declarations"]))

    def test_current_inventory_accepts_an_additional_parsed_declaration(self) -> None:
        before = current.build_manifest()
        parsed = current.api_index.all_declarations()
        owner = next(decl for decl in parsed if decl.module in before["supported_modules"])
        extra = replace(owner, name="LeanInfoTheory.Shannon.inventory_fixture_addition",
                        short_name="inventory_fixture_addition", doc="Synthetic parser-output fixture.")
        with patch.object(current.api_index, "all_declarations", return_value=[*parsed, extra]):
            after = current.build_manifest()
        self.assertEqual(after["declaration_count"], before["declaration_count"] + 1)
        self.assertEqual(after["documented_declaration_count"], before["documented_declaration_count"] + 1)
        self.assertEqual(after["baseline_identity"], before["baseline_identity"])
        self.assertIn(extra.name, [entry["name"] for entry in after["declarations"]])

    def test_current_inventory_rejects_an_undocumented_parsed_addition(self) -> None:
        # Classification fixture only: the input is parser output, not a Lean build.
        before = current.build_manifest()
        parsed = current.api_index.all_declarations()
        owner = next(decl for decl in parsed if decl.module in before["supported_modules"])
        extra = replace(owner, name="LeanInfoTheory.Shannon.inventory_fixture_undocumented",
                        short_name="inventory_fixture_undocumented", doc="")
        with patch.object(current.api_index, "all_declarations", return_value=[*parsed, extra]):
            with self.assertRaises(ValueError) as failure:
                current.build_manifest()
        self.assertIn("undocumented supported declarations", str(failure.exception))
        self.assertIn(extra.name, str(failure.exception))


class GeneratedValidationIntegrationTests(unittest.TestCase):
    def test_both_inventories_are_checked_on_each_render_pass(self) -> None:
        with patch.object(release, "run_command") as run, redirect_stdout(io.StringIO()):
            release.check_generated_artifacts()
        calls = run.call_args_list
        for script in ("generate_v0_1_public_api.py", "generate_current_public_api.py"):
            matches = [call for call in calls if call.args[0] == (sys.executable, "scripts/" + script, "--check")]
            self.assertEqual(len(matches), 2)
            self.assertEqual([call.kwargs["label"] for call in matches],
                             ["generated-artifact check pass 1", "generated-artifact check pass 2"])
        self.assertEqual(release.PUBLIC_API_PATH, current.OUTPUT)
        self.assertNotEqual(release.PUBLIC_API_PATH, frozen.FROZEN_PATH)


if __name__ == "__main__":
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    unittest.main(verbosity=2)
