"""Release transition regressions; synthetic artifacts are not qualification."""
from __future__ import annotations

import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import prepare_publication as publication
import release_state
import split_website as split
import stage_website as staging

ROOT = Path(__file__).resolve().parents[1]
COMMIT = "a" * 40


class PublicationTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="release-transition-", dir=ROOT / "tmp")
        self.root = Path(self.temporary.name)
        self.patch = patch.object(publication, "ROOT", self.root)
        self.patch.start()
        self.composition = self.root / "composition"
        self.historical = self.root / "historical"
        self.output = self.root / ".lake/publication-review/pair"
        self.state = {**release_state.FIXED, "phase": "candidate", "retention": "established"}
        self.write(self.root / release_state.STATE_PATH, split.encoded(self.state))
        self.write(self.root / "lakefile.toml", b'name = "LeanInfoTheory"\nversion = "0.2.0"\n')

    def tearDown(self):
        self.patch.stop()
        self.assertTrue(self.root.resolve().is_relative_to((ROOT / "tmp").resolve()))
        self.temporary.cleanup()

    def write(self, path, raw):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(raw)

    def fixture(self):
        proposed = publication.metadata_proposal(self.root, "2026-11-05")
        self.write(self.root / release_state.STATE_PATH, proposed["candidate-release-state.json"])
        identity = release_state.contract_identity(self.root)
        self.write(self.composition / staging.ROOT_MARKER, split.encoded({
            "schema": staging.CANDIDATE_STAGE_SCHEMA, "mode": "candidate", "publishable": False,
            "site_source_identity": COMMIT, "release_contract": identity}))
        self.write(self.composition / "index.html", b"main candidate fixture\n")
        self.write(self.composition / "docs/v0.1.0/index.html", b"later rebuild, must not survive\n")
        self.write(self.composition / "docs/v0.2.0/index.html", b"reserved placeholder\n")
        self.write(self.root / "home_page/index.html", b'<html><body>Final main page</body></html>')
        self.write(self.root / "home_page/docs/api-index.html", (
            '<html><body><a href="https://github.com/serhatemrecoban/LeanInfoTheory/'
            'blob/master/LeanInfoTheory/Shannon.lean#L1">source</a></body></html>').encode())
        self.write(self.root / "home_page/docs/v0.2.0/index.html", publication.version_entry())
        self.write(self.root / "LICENSE", b"fixture project licence\n")
        current = self.composition / staging.CURRENT_ROUTE
        self.write(current / "declarations/declaration-data.bmp", b"\x00fixture-search-data\xff")
        self.write(current / "Mathlib/example.html", b"dependency page\n")
        self.write(current / staging.VERSION_STAGE_METADATA, split.encoded({
            "source_mode": "github", "source_identity": COMMIT}))
        self.write(current / "navbar.html", ('<nav class="nav"><h3>LeanInfoTheory current — unpublished</h3>'
            '<a href="../">Project documentation</a><a href="../../">Project home</a>'
            '<h3>Local candidate — not for publication</h3><a href=".//LeanInfoTheory.html">API</a></nav>').encode())
        self.write(current / "index.html", ('<h1>LeanInfoTheory current API — unpublished</h1>'
            '<p>57 supported modules and 811 declarations. This local candidate is '
            'NOT_FOR_PUBLICATION; the stable release remains v0.1.0.</p>').encode())
        self.write(current / "licenses/index.html", b'<link href="../../../styles.css">'
            b'<a href="../../../">Home</a><a href="../../">Docs</a><a href="../">API</a>'
            b'<a href="../../third-party.html">Provenance</a>')
        self.write(self.historical / "index.html", b"exact historical bytes\r\n")
        self.write(self.historical / "navbar.html", b"historical .// links unchanged\r\n")
        digest, count, _html, size = staging.tree_digest(self.historical)
        return patch.multiple(publication, HISTORICAL_DIGEST=digest,
                              HISTORICAL_FILES=count, HISTORICAL_BYTES=size)

    def pair(self, prepare=True):
        return publication.review_pair(self.composition, self.historical, self.output, COMMIT, prepare=prepare)

    def test_metadata_proposal_does_not_modify_source_or_invent_doi(self):
        before = (self.root / release_state.STATE_PATH).read_bytes()
        proposed = publication.metadata_proposal(self.root, "2026-11-05")
        self.assertEqual((self.root / release_state.STATE_PATH).read_bytes(), before)
        self.assertNotIn(b"doi:", proposed["CITATION.cff"])
        self.assertIn(b"date-released: 2026-11-05", proposed["CITATION.cff"])
        self.assertEqual(json.loads(proposed["candidate-release-state.json"])["phase"], "release-ready")
        publication.write_metadata(self.output, "2026-11-05")
        self.assertIn(b"NOT_FOR_PUBLICATION", (self.output / staging.PREVIEW_MARKER).read_bytes())
        with self.assertRaisesRegex(ValueError, "already exists"):
            publication.write_metadata(self.output, "2026-11-05")

    def test_complete_pair_preserves_history_data_and_blocks_publication(self):
        with self.fixture():
            result = self.pair()
            self.assertFalse(result["publishable"])
            main = self.output / split.MAIN_NAME
            api_site = self.output / publication.API_NAME
            api = api_site / publication.API_VERSION
            self.assertEqual(split.inventory(main / "docs/v0.1.0"), split.inventory(self.historical))
            raw = b"\x00fixture-search-data\xff"
            self.assertEqual((api / "declarations/declaration-data.bmp").read_bytes(), raw)
            self.assertIn(split.MAIN_ROUTE + "docs/", (api / "navbar.html").read_text())
            self.assertNotIn('.//', (api / "navbar.html").read_text())
            licenses = (api / "licenses/index.html").read_text()
            self.assertIn('href="/LeanInfoTheory/styles.css"', licenses)
            self.assertIn('href="/LeanInfoTheory/docs/"', licenses)
            self.assertIn('href="/LeanInfoTheory/docs/third-party.html"', licenses)
            self.assertIn('href="../"', licenses)
            self.assertIn(publication.API_ROUTE, (main / "docs/v0.2.0/index.html").read_text())
            self.assertIn(publication.API_ROUTE, (main / "docs/current/index.html").read_text())
            self.assertIn(publication.API_ROUTE, (api_site / "index.html").read_text())
            self.assertFalse((api_site / "Mathlib").exists())
            self.assertFalse(json.loads((api_site / staging.ROOT_MARKER).read_bytes())["publishable"])
            page = (main / "docs/api-index.html").read_text()
            self.assertIn(f'/blob/{COMMIT}/LeanInfoTheory/Shannon.lean#L1', page)
            self.assertNotIn('/blob/master/', page)
            self.assertIn('data-publication-review="true"', page)
            self.assertIn('Final main page', (main / "index.html").read_text())
            self.assertNotIn('main candidate fixture', (main / "index.html").read_text())
            self.pair(prepare=False)

    def test_marker_removal_output_tampering_and_extra_files_refuse(self):
        with self.fixture():
            self.pair()
            api = self.output / publication.API_NAME / publication.API_VERSION
            for path, raw in ((api / staging.PREVIEW_MARKER, None),
                              (api / "Mathlib/example.html", b"tampered"),
                              (api / "private-evidence.json", b"must not publish")):
                old = path.read_bytes() if path.exists() else None
                if raw is None:
                    path.unlink()
                else:
                    path.write_bytes(raw)
                with self.subTest(path=path.name), self.assertRaisesRegex(ValueError, "output differs"):
                    self.pair(prepare=False)
                if old is None:
                    path.unlink()
                else:
                    path.write_bytes(old)

    def test_rebuilt_or_modified_historical_bytes_are_not_accepted(self):
        self.fixture()  # Deliberately do not enter the fixture's digest override.
        with self.assertRaisesRegex(ValueError, "exact recovered"):
            self.pair()
        self.assertFalse(self.output.exists())

    def test_file_mode_and_different_sha_refuse(self):
        with self.fixture():
            path = self.composition / staging.CURRENT_ROUTE / staging.VERSION_STAGE_METADATA
            for update in ({"source_mode": "file", "source_identity": COMMIT},
                           {"source_mode": "github", "source_identity": "b" * 40}):
                path.write_bytes(split.encoded(update))
                with self.subTest(update=update), self.assertRaisesRegex(ValueError, "exact-SHA"):
                    self.pair()
        self.assertFalse(self.output.exists())

    def test_size_limit_refuses_before_copy(self):
        with self.fixture(), patch.object(split, "LIMIT", 1):
            with self.assertRaisesRegex(ValueError, "size guard"):
                self.pair()
        self.assertFalse(self.output.exists())

    def test_stale_transform_refuses(self):
        with self.assertRaisesRegex(ValueError, "unexpected candidate"):
            publication.release_api_html(b"changed upstream index", "index.html")

    def test_outside_destination_refuses(self):
        self.output = self.root / "outside"
        with self.assertRaisesRegex(ValueError, "child of"):
            publication.write_metadata(self.output, "2026-11-05")
        self.assertFalse(self.output.exists())

    @unittest.skipUnless(os.name == "nt", "Windows junction regression")
    def test_junction_destination_refuses_without_touching_target(self):
        target = self.root / "outside"
        target.mkdir()
        owned = self.root / ".lake/publication-review"
        owned.mkdir(parents=True)
        junction = owned / "redirect"
        subprocess.run(["cmd", "/c", "mklink", "/J", str(junction), str(target)],
                       capture_output=True, check=True)
        try:
            with self.assertRaises(staging.StagingError):
                publication.write_metadata(junction / "new", "2026-11-05")
            self.assertEqual(list(target.iterdir()), [])
        finally:
            junction.rmdir()  # Remove the junction itself, never recurse through it.

    def test_source_gate_refuses_current_candidate_before_api_work(self):
        with patch.object(staging, "validate_candidate_inputs") as validate:
            with self.assertRaisesRegex(ValueError, "release-ready"):
                publication.validate_source(COMMIT)
            validate.assert_not_called()

    def test_ignored_website_file_is_rejected(self):
        self.write(self.root / "home_page/index.html", b"fixture page")
        self.write(self.root / "home_page/private.json", b"fixture secret")
        with patch.object(publication.subprocess, "check_output", return_value=b'home_page/index.html\0'):
            with self.assertRaisesRegex(ValueError, "ignored or untracked"):
                publication.validate_tracked_site_source(self.root)

    def test_release_ready_cannot_use_legacy_maintenance_deployment(self):
        with patch.object(release_state, "load_state", return_value={"phase": "release-ready"}), \
             patch.object(staging, "require_clean_checkout") as clean:
            with self.assertRaisesRegex(staging.StagingError, "two-site"):
                staging.validate_current_maintenance_checkout()
            clean.assert_not_called()

    def test_source_gate_refuses_stale_retained_capture(self):
        self.fixture()
        with patch.object(staging, "validate_candidate_inputs", return_value=({"source_mode": "github"}, {}, {}, {})), \
             patch.object(publication.candidate_contract, "load_approved_contract", return_value={"producer": {"files": {"source": "old"}}}), \
             patch.object(publication.candidate_contract, "producer_identity", return_value={"source": "new"}):
            with self.assertRaisesRegex(ValueError, "not bound"):
                publication.validate_source(COMMIT)


if __name__ == "__main__":
    unittest.main()
