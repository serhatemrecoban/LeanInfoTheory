"""Isolated model-free Git fixtures; no production source or native calls.

Adapted from PFR-C02 for LeanInfoTheory, 2026-09-11; see ../PROVENANCE.md.
Additional cases are local installation regressions.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import sys

sys.path.insert(0, str(Path(__file__).absolute().parents[1]))
import project_source as source


class ProjectSourceTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="lit-source-test-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.git("init", "-q")
        self.git("config", "user.name", "Fixture")
        self.git("config", "user.email", "fixture@example.invalid")
        self.put(".gitignore", ".lit-review/\ntmp/\n.lake/\n__pycache__/\n")
        self.put("lean-toolchain", "leanprover/lean4:v4.33.1\n")
        self.put("lakefile.toml", 'name = "LeanInfoTheory"\n')
        self.put("lake-manifest.json", json.dumps({"packagesDir": ".lake/packages", "packages": []}))
        self.put("LeanInfoTheory.lean", "-- fixture, no mathematical production claim\n")
        self.put(source.BASELINE_PLAN, "# Fixture completed baseline\n\n**Status:** Complete\n")
        self.put("home_page/index.html", "<p>Tracked fixture page</p>\n")
        self.put("CITATION.cff", "cff-version: 1.2.0\ntitle: Fixture\n")
        self.git("add", ".")
        self.git("commit", "-qm", "fixture source baseline")

    def put(self, rel, text):
        path = self.root / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8", newline="")

    def git(self, *args, root=None):
        return subprocess.check_output(["git", "-C", str(root or self.root), *args], stderr=subprocess.STDOUT)

    def snapshot(self, **kwargs):
        return source.snapshot(self.root, **kwargs)

    def test_inspection_is_read_only_and_does_not_authorize(self):
        index = (self.root / ".git/index").read_bytes()
        info = source.inspect_checkout(self.root)
        self.assertEqual(info["git"]["head"], self.git("rev-parse", "HEAD").decode().strip())
        self.assertEqual(index, (self.root / ".git/index").read_bytes())
        self.assertFalse(info["mathematical_execution_authorized"])
        self.assertFalse(info["historical_baseline"]["recognized_historical_baseline"])
        self.assertFalse((self.root / ".lit-review").exists())

    def test_exact_dirty_untracked_and_deleted_contents(self):
        baseline = self.snapshot(label="B")
        self.put("LeanInfoTheory.lean", "-- changed fixture bytes\n")
        self.put("tools/new.py", "# untracked fixture tool\n")
        self.put("docs/new.md", "untracked fixture documentation\n")
        self.put("home_page/index.html", "<p>Dirty fixture page</p>\n")
        self.put("CITATION.cff", "cff-version: 1.2.0\ntitle: Changed fixture\n")
        self.put("home_page/new.html", "<p>Untracked fixture page</p>\n")
        self.put("docs/new.cff", "cff-version: 1.2.0\ntitle: Untracked fixture\n")
        (self.root / source.BASELINE_PLAN).unlink()
        current = self.snapshot(label="R")
        self.assertNotEqual(baseline["inventory"]["LeanInfoTheory.lean"]["hash"],
                            current["inventory"]["LeanInfoTheory.lean"]["hash"])
        self.assertEqual(bytes.fromhex(current["source_bytes"]["tools/new.py"]), b"# untracked fixture tool\n")
        self.assertIn("docs/new.md", current["inventory"])
        self.assertNotIn(source.BASELINE_PLAN, current["inventory"])
        self.assertIn(source.BASELINE_PLAN, current["deleted_tracked"])
        for rel in ("home_page/index.html", "CITATION.cff", "home_page/new.html", "docs/new.cff"):
            self.assertEqual(bytes.fromhex(current["source_bytes"][rel]), (self.root / rel).read_bytes())
        for rel in ("home_page/index.html", "CITATION.cff"):
            self.assertNotEqual(baseline["inventory"][rel]["hash"], current["inventory"][rel]["hash"])
            (self.root / rel).unlink()
        deleted = self.snapshot(label="F")
        for rel in ("home_page/index.html", "CITATION.cff"):
            self.assertIn(rel, deleted["deleted_tracked"])
            self.assertNotIn(rel, deleted["source_bytes"])

    def test_source_bytes_and_hashes_correspond(self):
        result = self.snapshot()
        for path, entry in result["inventory"].items():
            self.assertEqual(hashlib.sha256(bytes.fromhex(result["source_bytes"][path])).hexdigest(), entry["hash"])
            self.assertEqual(entry["hash"], entry["semantic"])

    def test_private_records_and_reference_files_not_read(self):
        self.put(".lit-review/report.json", '{"private":true}')
        self.put("tmp/unrelated.md", "historical evidence")
        self.put("untracked-paper.pdf", "reference placeholder")
        result = self.snapshot()
        self.assertNotIn(".lit-review/report.json", result["source_bytes"])
        self.assertNotIn("tmp/unrelated.md", result["source_bytes"])
        self.assertNotIn("untracked-paper.pdf", result["source_bytes"])
        with self.assertRaisesRegex(ValueError, "EXCLUDED_EXPLICIT_SCOPE"):
            self.snapshot(scope=[".LIT-review/report.json"])
        with self.assertRaisesRegex(ValueError, "EXCLUDED_EXPLICIT_SCOPE"):
            self.snapshot(scope=["untracked-paper.pdf"])

    def test_doc_edit_does_not_fabricate_environment_change(self):
        before = self.snapshot()
        self.put("docs/note.md", "new note")
        after = self.snapshot()
        self.assertEqual(before["inventory"]["@environment"], after["inventory"]["@environment"])
        self.assertNotEqual(before["git"], after["git"])

    def test_config_change_is_source_environment_change(self):
        before = self.snapshot()
        self.put("lean-toolchain", "leanprover/lean4:fixture-other\n")
        after = self.snapshot()
        self.assertNotEqual(before["inventory"]["@environment"], after["inventory"]["@environment"])

    def test_index_identity_is_real_but_not_a_written_tree(self):
        before = source.inspect_checkout(self.root)
        self.put("docs/staged.md", "fixture staged change")
        self.git("add", "docs/staged.md")
        after = source.inspect_checkout(self.root)
        self.assertNotEqual(before["git"]["index_entries_sha256"], after["git"]["index_entries_sha256"])
        self.assertNotEqual(before["git"]["cached_diff_sha256"], after["git"]["cached_diff_sha256"])

    def test_historical_closeout_is_not_new_automation_closure(self):
        commit = self.git("rev-parse", "HEAD").decode().strip()
        with patch.object(source, "BASELINE_COMMIT", commit):
            info = source.inspect_checkout(self.root)
            self.assertTrue(info["historical_baseline"]["recognized_historical_baseline"])
            self.assertFalse(info["historical_baseline"]["automation_closure_created"])
            self.assertFalse(info["historical_baseline"]["validation_rerun"])
            self.put("LeanInfoTheory.lean", "-- later fixture changes")
            info = source.inspect_checkout(self.root)
            self.assertTrue(info["historical_baseline"]["historical_complete"])
            self.assertNotIn("changed_since_closeout", info["historical_baseline"])
            self.assertFalse(info["mathematical_execution_authorized"])

    def test_historical_baseline_uses_release_plan_not_old_source_comparison(self):
        self.assertEqual(source.BASELINE_PLAN, "docs/plans/chapter2-chunk-08.md")
        self.assertEqual(source.BASELINE_COMMIT, "0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f")
        self.put(source.BASELINE_PLAN, "# Fixture completed baseline\n\n**Plan status:** Complete through C8.24\n")
        self.git("add", source.BASELINE_PLAN)
        self.git("commit", "-qm", "Synthetic fixture historical plan status")
        commit = self.git("rev-parse", "HEAD").decode().strip()
        self.put(source.BASELINE_PLAN, "# Later fixture plan note\n\n**Plan status:** Historical\n")
        self.put("LeanInfoTheory.lean", "-- Later source is not compared with release source.\n")
        with patch.object(source, "BASELINE_COMMIT", commit), patch.object(source, "_git", wraps=source._git) as git:
            historical = source._historical_baseline(self.root)
        self.assertTrue(historical["historical_complete"])
        self.assertTrue(historical["recognized_historical_baseline"])
        self.assertEqual(historical["current_plan_status"], "Historical")
        self.assertFalse(historical["automation_closure_created"])
        self.assertFalse(historical["validation_rerun"])
        commands = [call.args[1:] for call in git.call_args_list]
        self.assertEqual([args for args in commands if args[0] == "show"],
                         [("show", f"{commit}:{source.BASELINE_PLAN}")])
        self.assertFalse(any(args[0] in {"diff", "ls-tree"} for args in commands))
        self.assertNotIn("changed_since_closeout", historical)

    def test_scope_escapes_reserved_names_and_missing_files_refused(self):
        for path in ("../escape", "/absolute", "C:/absolute", "docs//x", "docs/./x",
                     "docs/../../x", "docs\\x", "docs/CON", "@environment", "docs/x."):
            with self.subTest(path=path), self.assertRaises(ValueError):
                self.snapshot(scope=[path])
        with self.assertRaisesRegex(ValueError, "EXPLICIT_SOURCE_MISSING"):
            self.snapshot(scope=["docs/no-such-file.md"])

    def test_hardlink_refused(self):
        try:
            os.link(self.root / "lean-toolchain", self.root / "docs/hardlink.md")
        except OSError as error:
            self.skipTest(f"hardlink unavailable: {error}")
        with self.assertRaisesRegex(ValueError, "SOURCE_HARDLINK"):
            self.snapshot()

    def test_symlink_refused_where_available(self):
        try:
            os.symlink(self.root / "lean-toolchain", self.root / "docs/link.md")
        except OSError as error:
            self.skipTest(f"symlink unavailable: {error}")
        with self.assertRaisesRegex(ValueError, "SOURCE_INDIRECTION"):
            self.snapshot()

    def test_concurrent_edit_detected(self):
        original = source._capture_once
        calls = []
        def capture(*args):
            result = original(*args)
            if not calls:
                self.put("docs/concurrent.md", "concurrent fixture edit")
            calls.append(1)
            return result
        with patch.object(source, "_capture_once", side_effect=capture), self.assertRaisesRegex(ValueError, "UNSTABLE_SOURCE_CAPTURE"):
            self.snapshot()

    def dependency(self):
        dep = self.root / ".lake/packages/FixtureDep"
        dep.mkdir(parents=True)
        self.git("init", "-q", root=dep)
        self.git("config", "user.name", "Fixture", root=dep)
        self.git("config", "user.email", "fixture@example.invalid", root=dep)
        self.put(".lake/packages/FixtureDep/Api.lean", "-- fixture dependency\n")
        self.git("add", ".", root=dep)
        self.git("commit", "-qm", "fixture pin", root=dep)
        rev = self.git("rev-parse", "HEAD", root=dep).decode().strip()
        self.put("lake-manifest.json", json.dumps({"packagesDir": ".lake/packages", "packages": [
            {"name": "FixtureDep", "type": "git", "rev": rev, "inputRev": "fixture-release"}]}))
        return dep

    def test_explicit_pinned_dependency_bytes_and_clean_pin(self):
        dep = self.dependency()
        rel = ".lake/packages/FixtureDep/Api.lean"
        result = self.snapshot(scope=[rel])
        self.assertEqual(bytes.fromhex(result["source_bytes"][rel]), (dep / "Api.lean").read_bytes())
        self.assertTrue(result["environment"]["dependencies"]["FixtureDep"]["matches_configured_revision"])
        self.put(rel, "-- dirty fixture dependency")
        info = source.inspect_checkout(self.root)
        self.assertTrue(info["dependencies"]["FixtureDep"]["status_porcelain"])
        with self.assertRaisesRegex(ValueError, "DEPENDENCY_NOT_CLEAN_PIN"):
            self.snapshot(scope=[rel])

    def test_missing_dependency_refused_by_snapshot_not_inspection(self):
        self.put("lake-manifest.json", json.dumps({"packagesDir": ".lake/packages", "packages": [
            {"name": "MissingFixture", "type": "git", "rev": "0" * 40}]}))
        self.assertFalse(source.inspect_checkout(self.root)["dependencies"]["MissingFixture"]["installed"])
        with self.assertRaisesRegex(ValueError, "DEPENDENCY_NOT_CLEAN_PIN"):
            self.snapshot()


if __name__ == "__main__":
    unittest.main()
