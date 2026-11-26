"""Exercise the DOI-only Pages composition before release promotion."""
import json
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
        self.pages = {p: f"{p} https://doi.org/{self.archive['version_doi']}".encode() for p in citation.PAGES}
        self.frozen = self.site / "docs/v0.1.0/index.html"
        self.frozen.parent.mkdir(parents=True)
        self.frozen.write_bytes(b"historical")
        for name in self.pages:
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
        receipt = self.compose()
        self.assertEqual(self.frozen.read_bytes(), b"historical")
        self.assertEqual(receipt["site_tree_sha256"], citation.tree_digest(self.site)[0])
        self.assertEqual(set(receipt["maintained_sha256"]), {*citation.PAGES, citation.ROOT_MARKER})
        marker = json.loads(self.marker.read_bytes())
        self.assertEqual(marker["history"], {"v0.1.0": "unchanged"})
        self.assertEqual(marker["source_identity"], self.release)
        self.assertEqual(marker["site_source_identity"], self.maintenance)
        self.assertEqual(marker["qualified_site_tree_sha256"], self.decision["site_tree_sha256"])

    def test_corrupt_qualified_tree_fails_before_writing(self):
        self.frozen.write_bytes(b"unexpected")
        with self.assertRaisesRegex(ValueError, "differs from the qualified"):
            self.compose()
        self.assertEqual((self.site / "index.html").read_bytes(), b"qualified")

    def test_wrong_release_missing_doi_and_extra_page_fail_before_writing(self):
        for key in ("source_commit", "git_tree", "tag_object"):
            with self.subTest(key=key):
                orig = self.archive[key]
                self.archive[key] = "e" * 40
                with self.assertRaisesRegex(ValueError, "different releases"):
                    self.compose()
                self.archive[key] = orig
        self.pages["license.html"] = b"unverified edition"
        with self.assertRaisesRegex(ValueError, "version DOI"):
            self.compose()
        self.pages["docs/v0.1.0/index.html"] = b"override"
        with self.assertRaisesRegex(ValueError, "two citation pages"):
            self.compose()
        self.assertEqual((self.site / "index.html").read_bytes(), b"qualified")


if __name__ == "__main__":
    unittest.main()
