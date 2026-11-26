"""Exercise the reviewed main-site overlay and its release safeguards."""
import hashlib
import json
import os
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest

import compose_release3_citation_pages as citation


class CitationPagesTests(unittest.TestCase):
    def setUp(self):
        self.temp = TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.site = Path(self.temp.name)
        self.release = "a" * 40
        self.maintenance = "b" * 40
        self.archive = {"source_commit": self.release, "git_tree": "c" * 40, "tag_object": "d" * 40,
                        "version_doi": "10.5281/zenodo.1234"}
        self.pins = {"release_commit": self.release, "annotated_tag": self.archive["tag_object"]}
        self.pages = {name: f"{name} https://doi.org/{self.archive['version_doi']}".encode()
                      for name in citation.CITATION_PAGES}
        self.pages.update({
            "docs/research-projects.html": b'<img src="figures/reuse-layers.svg" alt="Reuse layers">',
            "styles.css": b"figure { margin: 0 }",
            citation.FIGURE: b'<svg xmlns="http://www.w3.org/2000/svg"><title>Reuse</title></svg>',
        })
        self.frozen = self.site / "docs/v0.1.0/index.html"
        self.frozen.parent.mkdir(parents=True)
        self.frozen.write_bytes(b"historical")
        self.historical_entry = self.site / "docs/v0.2.0/index.html"
        self.historical_entry.parent.mkdir()
        self.historical_entry.write_bytes(b"historical bridge")
        for name in self.pages:
            if name != citation.FIGURE:
                (self.site / name).write_bytes(b"qualified")
        self.marker = self.site / citation.ROOT_MARKER
        self.marker.write_text(json.dumps({
            "schema": "lean-info-theory.release3-pages.v1", "purpose": "candidate",
            "current_api_url": citation.release.API_URL, "rehearsal_overlays": {},
            "source_identity": self.release, "site_source_identity": self.release,
            "source_tree": self.archive["git_tree"], "history": {"v0.1.0": "unchanged"},
        }), encoding="utf-8")
        self.decision = {"site_tree_sha256": citation.tree_digest(self.site)[0]}

    def compose(self):
        return citation.compose(self.site, self.decision, self.maintenance, self.archive, self.pins, self.pages)

    def test_composition_keeps_history_and_binds_both_sources(self):
        initial_files = {p.relative_to(self.site).as_posix() for p in self.site.rglob("*") if p.is_file()}
        self.assertFalse((self.site / citation.FIGURE).parent.exists())
        receipt = self.compose()
        actual_files = {p.relative_to(self.site).as_posix() for p in self.site.rglob("*") if p.is_file()}
        self.assertEqual(actual_files, initial_files | {citation.FIGURE})
        for name, data in self.pages.items():
            self.assertEqual((self.site / name).read_bytes(), data)
        self.assertEqual(self.frozen.read_bytes(), b"historical")
        self.assertEqual(self.historical_entry.read_bytes(), b"historical bridge")
        self.assertEqual(receipt["site_tree_sha256"], citation.tree_digest(self.site)[0])
        expected = {name: hashlib.sha256(data).hexdigest() for name, data in self.pages.items()}
        expected[citation.ROOT_MARKER] = hashlib.sha256(self.marker.read_bytes()).hexdigest()
        self.assertEqual(receipt["maintained_sha256"], expected)
        marker = json.loads(self.marker.read_bytes())
        self.assertEqual(marker["maintained_pages"], list(citation.PAGES))
        self.assertEqual(marker["maintained_assets"], list(citation.ASSETS))
        self.assertEqual(marker["schema"], "lean-info-theory.release3-citation-maintenance.v1")
        self.assertEqual(marker["history"], {"v0.1.0": "unchanged"})
        self.assertEqual(marker["source_identity"], self.release)
        self.assertEqual(marker["site_source_identity"], self.maintenance)
        self.assertEqual(marker["qualified_site_tree_sha256"], self.decision["site_tree_sha256"])

    def test_corrupt_qualified_tree_fails_before_writing(self):
        self.frozen.write_bytes(b"unexpected")
        with self.assertRaisesRegex(ValueError, "differs from the qualified"):
            self.compose()
        self.assertEqual((self.site / "index.html").read_bytes(), b"qualified")

    def test_existing_figure_is_replaced_in_place_in_the_site(self):
        figure = self.site / citation.FIGURE
        figure.parent.mkdir()
        figure.write_bytes(b"old figure")
        self.decision["site_tree_sha256"] = citation.tree_digest(self.site)[0]
        self.compose()
        self.assertEqual(figure.read_bytes(), self.pages[citation.FIGURE])

    def assert_rejected_without_writes(self, message):
        before = citation.tree_digest(self.site)[0]
        directories = {p for p in self.site.rglob("*") if p.is_dir()}
        with self.assertRaisesRegex(ValueError, message):
            self.compose()
        self.assertEqual(citation.tree_digest(self.site)[0], before)
        self.assertEqual({p for p in self.site.rglob("*") if p.is_dir()}, directories)

    def test_wrong_release_or_missing_citation_doi_fails_before_writing(self):
        for key in ("source_commit", "git_tree", "tag_object"):
            with self.subTest(key=key):
                orig = self.archive[key]
                self.archive[key] = "e" * 40
                self.assert_rejected_without_writes("different releases")
                self.archive[key] = orig
        for name in citation.CITATION_PAGES:
            with self.subTest(name=name):
                original = self.pages[name]
                self.pages[name] = b"unverified edition"
                self.assert_rejected_without_writes("version DOI")
                self.pages[name] = original

    def test_omitted_and_extra_paths_are_rejected(self):
        for name in citation.MAINTAINED_FILES:
            with self.subTest(omitted=name):
                content = self.pages.pop(name)
                self.assert_rejected_without_writes("reviewed set")
                self.pages[name] = content
        for name in ("docs/v0.1.0/index.html", "docs/v0.2.0/index.html", "../unexpected.html"):
            with self.subTest(extra=name):
                self.pages[name] = b"override"
                self.assert_rejected_without_writes("reviewed set")
                del self.pages[name]

    def test_invalid_asset_bytes_are_rejected_before_earlier_pages_are_written(self):
        for value in (b"", "a string"):
            with self.subTest(value=value):
                self.pages[citation.FIGURE] = value
                self.assert_rejected_without_writes("nonempty tracked file")

    def test_figure_parent_must_be_a_directory(self):
        (self.site / citation.FIGURE).parent.write_bytes(b"obstruction")
        self.decision["site_tree_sha256"] = citation.tree_digest(self.site)[0]
        self.assert_rejected_without_writes("expected a directory")

    def test_missing_qualified_asset_is_rejected(self):
        (self.site / "styles.css").unlink()
        self.decision["site_tree_sha256"] = citation.tree_digest(self.site)[0]
        self.assert_rejected_without_writes("regular file at styles.css")

    def test_writing_a_hard_link_must_not_modify_a_historical_file(self):
        figure = self.site / citation.FIGURE
        figure.parent.mkdir()
        try:
            os.link(self.frozen, figure)
        except OSError as error:
            self.skipTest(f"hard links are unavailable: {error}")
        self.decision["site_tree_sha256"] = citation.tree_digest(self.site)[0]
        self.assert_rejected_without_writes("independent regular file")
        self.assertEqual(self.frozen.read_bytes(), b"historical")


if __name__ == "__main__":
    unittest.main()
