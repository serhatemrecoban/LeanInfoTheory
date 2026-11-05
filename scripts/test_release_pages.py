"""Regressions for public-facing transforms and the integrity of Pages archives."""
from __future__ import annotations

import json
from pathlib import Path
import tarfile
import tempfile
import unittest

import archive_release_pages as archive
import package_release_pages as pages


class ReleasePagesTests(unittest.TestCase):
    def test_advisory_above_snapshot_keeps_its_href_and_legacy_destination(self):
        validator = pages.SplitLinks(Path.cwd(), "a" * 40)
        for prefix, original in ((validator.frozen, "docs/v0.1.0"), (validator.current, "docs/current")):
            source = prefix + "Mathlib/Analysis/Calculus/FDeriv/Basic.html"
            target = str(Path(prefix.rstrip("/")).parent.as_posix()) + "/Inverse.html"
            actual = source + ": missing local link ../../../../../Inverse.html -> " + target
            self.assertEqual(validator.advisory_coordinates(actual),
                             original + "/Mathlib/Analysis/Calculus/FDeriv/Basic.html: "
                             "missing local link ../../../../../Inverse.html -> docs/Inverse.html")

    def test_only_url_attributes_with_generated_double_slashes_are_rewritten(self):
        with tempfile.TemporaryDirectory() as directory:
            page = Path(directory) / "module.html"
            page.write_text('<link href="../.././/declarations/declaration-data.bmp">'
                            '<a href="https://example.org/a//b">text .//example</a>', encoding="utf-8")
            raw = pages.api_bytes(page.read_bytes(), "Mathlib/Example.html", {}, "a" * 40)
            self.assertIn(b'../.././declarations/declaration-data.bmp', raw)
            self.assertIn(b'https://example.org/a//b', raw)
            self.assertIn(b'text .//example', raw)

    def test_tar_includes_dotfiles_and_rejects_modified_site(self):
        with tempfile.TemporaryDirectory() as temporary:
            base = Path(temporary)
            package = base / "pair"
            name = pages.split.MAIN_NAME
            site = package / name
            site.mkdir(parents=True)
            (site / ".nojekyll").write_bytes(b"")
            (site / "index.html").write_bytes(b"versioned")
            digest, count, _, size = pages.stage.tree_digest(site)
            (package / "receipt.json").write_text(json.dumps({"sites": {
                name: {"bytes": size, "files": count, "sha256": digest}}}), encoding="utf-8")
            target = base / "main/artifact.tar"
            archive.archive(package, name, target)
            with tarfile.open(target) as tar:
                self.assertEqual(tar.getnames(), ["./.nojekyll", "./index.html"])
            (site / "index.html").write_bytes(b"replacement")
            with self.assertRaisesRegex(ValueError, "differs"):
                archive.archive(package, name, base / "changed/artifact.tar")

    def test_historical_inventory_is_path_safe_and_bound_to_known_count(self):
        names = pages.checked_history_files()
        self.assertIn("navbar.html", names)
        self.assertIn("declarations/declaration-data.bmp", names)
        self.assertIn(pages.stage.VERSION_STAGE_METADATA, names)


if __name__ == "__main__":
    unittest.main()
