"""Regressions for public-facing transforms and the integrity of Pages archives."""
from __future__ import annotations

import json
import io
from pathlib import Path
import tarfile
import tempfile
import unittest
from unittest.mock import patch
import zipfile

import archive_release_pages as archive
import package_release_pages as pages
import release3_pages as r3pages


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

    def test_version_entry_and_navbar_target_permanent_sites(self):
        self.assertIn(r3pages.r3.API_URL, r3pages.entry_page().decode())
        nav = ('<a href="../">Project documentation</a><a href="../../">Project home</a>'
               'LeanInfoTheory current — unpublished<h3>Local candidate — not for publication</h3>').encode()
        text = r3pages.release_html(nav, "navbar.html").decode()
        self.assertIn('href="/LeanInfoTheory/docs/"', text)
        self.assertIn("LeanInfoTheory v0.3.0", text)
        self.assertNotIn("unpublished", text)

    def test_pinned_zip_recovery_selects_only_historical_route(self):
        tar_bytes = io.BytesIO()
        with tarfile.open(mode="w", fileobj=tar_bytes) as tar:
            for name in ("./index.html", "./docs/v0.1.0/index.html"):
                info = tarfile.TarInfo(name)
                raw = name.encode()
                info.size = len(raw)
                tar.addfile(info, io.BytesIO(raw))
        zip_bytes = io.BytesIO()
        with zipfile.ZipFile(zip_bytes, "w", zipfile.ZIP_DEFLATED) as bundle:
            bundle.writestr("artifact.tar", tar_bytes.getvalue())
        pins = (r3pages.digest(zip_bytes.getvalue()), r3pages.digest(tar_bytes.getvalue()))
        with tempfile.TemporaryDirectory() as directory, patch.dict(r3pages.BUNDLE_HASHES, main=pins):
            scratch = Path(directory)
            with patch.object(r3pages, "urlopen", return_value=io.BytesIO(zip_bytes.getvalue())):
                recovered = r3pages.recover_bundle("main", scratch)
            self.assertEqual((recovered / "index.html").read_bytes(), b"./docs/v0.1.0/index.html")
            self.assertEqual([p.name for p in recovered.iterdir()], ["index.html"])
            with patch.object(r3pages, "urlopen", return_value=io.BytesIO(b"other bytes")):
                with self.assertRaisesRegex(ValueError, "incorrect historical main ZIP"):
                    r3pages.recover_bundle("main", scratch)

    def test_rehearsal_requires_opt_in_to_archive(self):
        with tempfile.TemporaryDirectory() as directory:
            package = Path(directory) / "sites"
            hosts = {}
            for name in r3pages.SITES:
                root = package / name
                root.mkdir(parents=True)
                if name != r3pages.V02:
                    (root / pages.stage.PREVIEW_MARKER).write_bytes(b"rehearsal")
                if name == r3pages.MAIN:
                    (root / pages.stage.ROOT_MARKER).write_text('{"purpose":"rehearsal"}', encoding="utf-8")
                checksum, count, _, size = pages.stage.tree_digest(root)
                hosts[name] = dict(sha256=checksum, files=count, bytes=size)
            receipt = {"schema": r3pages.SCHEMA, "purpose": "rehearsal", "sites": hosts}
            (package / "receipt.json").write_text(json.dumps(receipt), encoding="utf-8")
            target = Path(directory) / "out/artifact.tar"
            with self.assertRaisesRegex(ValueError, "nonpublishable rehearsal"):
                archive.archive(package, r3pages.API, target)
            file_manifest = Path(directory) / "api-files.json"
            sha = archive.archive(package, r3pages.API, target, allow_rehearsal=True, file_manifest=file_manifest)
            with tarfile.open(target) as bundle:
                self.assertIn("./" + pages.stage.PREVIEW_MARKER, bundle.getnames())
            saved = json.loads(file_manifest.read_bytes())
            self.assertEqual(saved["tree_sha256"], hosts[r3pages.API]["sha256"])
            self.assertEqual(saved["tar_sha256"], sha)
            self.assertEqual(saved["files"], {pages.stage.PREVIEW_MARKER: {
                "bytes": len(b"rehearsal"), "sha256": r3pages.digest(b"rehearsal")}})


if __name__ == "__main__":
    unittest.main()
