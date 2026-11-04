"""Regression checks for split previews, including frozen and search-data integrity."""
from pathlib import Path
from contextlib import redirect_stderr
import io
import os
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import split_website as split
import stage_website as staging


class SplitPreviewTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.input = self.root / "candidate"
        self.output = self.root / ".lake/website-split/test"
        self.current = self.input / "docs/current"
        self.frozen = self.input / "docs/v0.1.0"
        self.current.mkdir(parents=True)
        self.frozen.mkdir(parents=True)
        (self.current / "navbar.html").write_text(
            '<nav><a href="../">Project documentation</a>'
            '<a href="../../">Project home</a>'
            '<a href=".//LeanInfoTheory.html">Library</a></nav>', encoding="utf-8")
        (self.current / "LeanInfoTheory.html").write_text('<main id="declaration">type</main>', encoding="utf-8")
        (self.current / "index.html").write_text('<a href="LeanInfoTheory.html#declaration">API</a>', encoding="utf-8")
        (self.current / "declarations").mkdir()
        (self.current / "declarations/declaration-data.bmp").write_bytes(b'{"version":"candidate"}')
        (self.frozen / "index.html").write_bytes(b'unchanged historical .// link\r\n')
        (self.input / "index.html").write_text('main', encoding="utf-8")
        metadata = {"schema": staging.CANDIDATE_STAGE_SCHEMA, "mode": "candidate",
                    "publishable": False, "site_source_identity": "a" * 40}
        for directory, prefix in ((self.current, "current"), (self.frozen, "version")):
            for suffix, value in zip(("sha256", "files", "html_files", "bytes"), staging.tree_digest(directory)):
                metadata[f"{prefix}_route_{suffix}"] = value
        (self.input / staging.ROOT_MARKER).write_bytes(split.encoded(metadata))
        self.patch = patch.object(split, "ROOT", self.root)
        self.patch.start()
        self.addCleanup(self.patch.stop)

    def prepare(self):
        return split.assemble_pair(self.input, self.output)

    def test_split_preserves_historical_bytes_and_search_data(self):
        self.prepare()
        self.assertEqual((self.frozen / "index.html").read_bytes(),
                         (self.output / split.MAIN_NAME / "docs/v0.1.0/index.html").read_bytes())
        self.assertEqual((self.current / "declarations/declaration-data.bmp").read_bytes(),
                         (self.output / split.API_NAME / "declarations/declaration-data.bmp").read_bytes())
        nav = (self.output / split.API_NAME / "navbar.html").read_text()
        self.assertIn('href="/LeanInfoTheory/docs/"', nav)
        self.assertIn('href="./LeanInfoTheory.html"', nav)
        for name in (split.MAIN_NAME, split.API_NAME):
            self.assertFalse(staging.strict_object(self.output / name / staging.ROOT_MARKER)["publishable"])

    def test_frozen_output_tampering_is_rejected(self):
        self.prepare()
        (self.output / split.MAIN_NAME / "docs/v0.1.0/index.html").write_text('changed')
        with self.assertRaisesRegex(ValueError, "differs"):
            split.check_pair(self.input, self.output)

    def test_search_data_tampering_is_rejected(self):
        self.prepare()
        (self.output / split.API_NAME / "declarations/declaration-data.bmp").write_bytes(b'{}')
        with self.assertRaisesRegex(ValueError, "differs"):
            split.check_pair(self.input, self.output)

    def test_unexpected_private_file_is_rejected(self):
        self.prepare()
        (self.output / split.MAIN_NAME / "private-notes.txt").write_text('extra')
        with self.assertRaisesRegex(ValueError, "differs"):
            split.check_pair(self.input, self.output)

    def test_input_drift_is_rejected_before_writing(self):
        (self.current / "index.html").write_text('changed')
        with self.assertRaisesRegex(ValueError, "input evidence"):
            self.prepare()
        self.assertFalse(self.output.exists())

    def test_size_limit_is_not_waived_for_preview(self):
        with patch.object(split, "LIMIT", 20), self.assertRaisesRegex(ValueError, "size guard"):
            self.prepare()
        self.assertFalse(self.output.exists())

    def test_existing_output_is_never_overwritten(self):
        self.prepare()
        before = split.inventory(self.output)
        with self.assertRaisesRegex(ValueError, "already exists"):
            self.prepare()
        self.assertEqual(before, split.inventory(self.output))

    def test_unowned_output_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "new child"):
            split.assemble_pair(self.input, self.root / "source")
        self.assertFalse((self.root / "source").exists())

    def test_redirected_owned_root_is_rejected_by_cli_and_resolved_call(self):
        owned = self.root / ".lake/website-split"
        owned.parent.mkdir(parents=True)
        outside = self.root / "outside-owned-subtree"
        outside.mkdir()
        if os.name == "nt":
            subprocess.run(["cmd", "/c", "mklink", "/J", str(owned), str(outside)],
                           check=True, capture_output=True)
            self.addCleanup(owned.rmdir)  # Remove the junction itself, never its target.
        else:
            owned.symlink_to(outside, target_is_directory=True)
            self.addCleanup(owned.unlink)
        output = owned / "escaped"
        with self.assertRaisesRegex(staging.StagingError, "redirected"):
            split.assemble_pair(self.input, output.resolve())
        args = ["split_website.py", "prepare", "--candidate-source-root", str(self.root),
                "--candidate-site-root", str(self.input), "--expected-commit", "a" * 40,
                "--frozen-source-root", str(self.root), "--frozen-site-root", str(self.input),
                "--output", str(output)]
        errors = io.StringIO()
        with patch.object(sys, "argv", args), redirect_stderr(errors):
            self.assertEqual(split.main(), 1)
        self.assertIn("redirected", errors.getvalue())
        self.assertEqual(list(outside.iterdir()), [])

    def test_working_overlay_keeps_frozen_route_and_disables_mutable_source(self):
        overlay = self.root / "home_page"
        (overlay / "docs/v0.1.0").mkdir(parents=True)
        (overlay / "docs/v0.1.0/index.html").write_text('placeholder must not replace frozen')
        (overlay / "index.html").write_text('updated coverage')
        (overlay / "docs/index.html").write_text('<div class="link-grid"><a href="v0.1.0/">Stable</a></div>')
        (overlay / "docs/api-index.html").write_text(
            'Source links target current <a href="' + staging.REPOSITORY_URL +
            '/blob/master/LeanInfoTheory.lean">source</a>')
        split.assemble_pair(self.input, self.output, overlay)
        self.assertEqual((self.output / split.MAIN_NAME / "index.html").read_text(), 'updated coverage')
        self.assertEqual((self.output / split.MAIN_NAME / "docs/v0.1.0/index.html").read_bytes(),
                         (self.frozen / "index.html").read_bytes())
        self.assertNotIn('/blob/master/', (self.output / split.MAIN_NAME / "docs/api-index.html").read_text())
        (overlay / "index.html").write_text('later changes')
        with self.assertRaisesRegex(ValueError, "differs"):
            split.check_pair(self.input, self.output, overlay)


if __name__ == "__main__":
    unittest.main()
