"""Small negative controls for the permanent Release 3 Pages mounts."""
from __future__ import annotations

import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import check_release_pages as links


class Release3LinksTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.commit = "a" * 40
        self.snapshots = links.release_snapshots(self.commit)
        self.sites = {s.mount.split("/")[0]: {} for s in self.snapshots}

    def page(self, name: str, source: str) -> None:
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(source, encoding="utf-8")
        host, file = name.split("/", 1)
        self.sites[host][file] = {}

    def validator(self):
        return links.ThreeHostLinks(self.root, self.sites, self.commit, self.root)

    def test_selectors_use_real_anchors_on_the_correct_version(self):
        one, two, three = self.snapshots
        self.page(links.MAIN + "index.html", '<a href="docs/">Documentation</a>')
        self.page(links.HUB + "index.html", ''.join(
            f'<a href="{s.version}/">{s.version}</a>' for s in self.snapshots))
        self.page(links.HUB + "third-party.html", "History")
        for snap in self.snapshots:
            self.page(snap.mount + "index.html", snap.version)
            self.page(snap.mount + "navbar.html", '<a href="/LeanInfoTheory/">Home</a>'
                      '<a href="/LeanInfoTheory/docs/">Docs</a><a href="/LeanInfoTheory/docs/third-party.html">Credit</a>')
        for snap in (two, three):
            self.page(links.HUB + snap.version + "/index.html", f'<a href="/{snap.mount}">API</a>')
        self.page(links.HUB + "current/index.html", '<a href="../v0.3.0/">Release</a>')
        self.validator().check_selectors()
        self.page(links.HUB + "current/index.html", '<!-- <a href="../v0.3.0/">3</a> --><a href="../v0.2.0/">2</a>')
        with self.assertRaisesRegex(ValueError, "current/index.html: missing navigation"):
            self.validator().check_selectors()

    def test_each_snapshot_pins_its_own_source(self):
        validator = self.validator()
        for snap in self.snapshots:
            page = snap.mount + "Module.html"
            validator.validate_text_safety(page, f'<a href="{links.SOURCE_URL}{snap.commit}/x.lean">source</a>')
            self.assertEqual(validator.errors, [])
        wrong = self.snapshots[1]
        validator.validate_text_safety(wrong.mount + "Module.html",
                                       f'<a href="{links.SOURCE_URL}{self.commit}/x.lean">wrong release</a>')
        self.assertIn("unexpected project source revision", validator.errors[0])

    def test_missing_upstream_link_is_never_an_advisory_on_a_project_page(self):
        validator = self.validator()
        snap = self.snapshots[-1]
        validator.validate_target(snap.mount + "Mathlib/Foo.html", "Missing.html")
        self.assertEqual(len(validator.advisories), 1)
        validator.validate_target(snap.mount + "LeanInfoTheory/Foo.html", "Missing.html")
        self.assertEqual(len(validator.errors), 1)
        with self.assertRaisesRegex(ValueError, "fingerprint differs"):
            validator.checked_advisories()

    def test_preview_and_wrong_case_hosts_cannot_escape_as_external_urls(self):
        validator = self.validator()
        for host in ("LeanInfoTheory-API-R3-preview", "leaninfotheory-api"):
            validator.validate_target(links.HUB + "index.html", links.GITHUB_PAGES + host + "/v0.3.0/")
        self.assertEqual(len(validator.errors), 2)
        self.assertTrue(all("unknown release Pages mount" in m for m in validator.errors))

    def test_search_result_cannot_redirect_to_a_different_declaration(self):
        one = self.snapshots[0]
        snap = links.Snapshot(one.version, one.mount, one.commit, 1, 1, 1, 1)
        module = "Mathlib.Probability.ProbabilityMassFunction.Basic"
        file = module.replace(".", "/") + ".html"
        self.page(one.mount + file, '<div id="PMF"></div>')
        validator = self.validator()
        hit = {"docLink": "./" + file + "#PMF"}
        data = {"modules": {module: {"url": "./" + file, "importedBy": []}},
                "declarations": {"PMF": hit}, "instances": {str(n): [] for n in range(1243)},
                "instancesFor": {str(n): [] for n in range(3082)}}
        validator.check_search(snap, {"supported_modules": [module]}, data)
        hit["docLink"] = "./" + file + "#other"
        with self.assertRaisesRegex(ValueError, "broken search destination for PMF"):
            validator.check_search(snap, {"supported_modules": [module]}, data)

    def test_declaration_source_range_must_include_the_declaration(self):
        validator = self.validator()
        snap = links.Snapshot("v0.1.0", self.snapshots[0].mount, self.snapshots[0].commit, 1, 1, 1, 1)
        module = "LeanInfoTheory.Example"
        name = module + ".sample"
        stem = module.replace(".", "/")
        self.page(snap.mount + "declarations/declaration-data.bmp",
                  json.dumps({"modules": {module: {}}, "declarations": {name: {"docLink": "./" + stem + ".html#" + name}}}))
        self.page(snap.mount + "references.bib", "")
        self.page(snap.mount + "search.js", "search_form autocomplete_results declaration-data.js")
        prefix = links.SOURCE_URL + snap.commit + "/" + stem + ".lean"
        header = ('<form id="search_form"><input name="q"></form><script src="./search.js"></script>'
                  f'<div class="decl" id="{name}"><div class="theorem"><div class="gh_link">')
        def source_range(fragment):
            self.page(snap.mount + stem + ".html", header + f'<a href="{prefix}{fragment}">source</a></div></div></div>')
        manifest = {"declarations": [{"name": name, "module": module}], "supported_modules": [module]}
        index = {"declarations": [{"name": name, "short_name": "sample", "module": module,
                                   "path": stem + ".lean", "line": 2}]}
        objects = {"docs/v0.1-public-api.json": json.dumps(manifest).encode(),
                   "home_page/docs/declaration_index.json": json.dumps(index).encode(),
                   stem + ".lean": b"namespace LeanInfoTheory.Example\ntheorem sample : True := by trivial\n"}
        source_range("#L1-L2")
        with patch.object(validator, "git_bytes", side_effect=lambda ref, path: objects[path]), \
                patch.object(validator, "check_search"):
            self.assertEqual(validator.check_snapshot(snap)["checked_source_ranges"], 1)
            source_range("#L1-L1")
            with self.assertRaisesRegex(ValueError, "source range does not match"):
                validator.check_snapshot(snap)


if __name__ == "__main__":
    unittest.main()
