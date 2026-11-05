"""Focused candidate-state/configuration regressions; no project Git writes."""
from __future__ import annotations

import copy
import hashlib
import json
from pathlib import Path
import sys
import tempfile
import unittest
from contextlib import redirect_stdout
import io
from unittest.mock import patch

import check_public_api_compatibility as compatibility
import release_state as state

ROOT = Path(__file__).resolve().parents[1]

# Fixtures describe both metadata states even after the live checkout transitions.
PREPARATION_POLICY = {
    "schema": "lean-info-theory.candidate-release-state.v1",
    "phase": "preparation",
    "target_version": "0.2.0",
    "stable_version": "0.1.0",
    "current_route": "/docs/current/",
    "stable_route": "/docs/v0.1.0/",
    "reserved_route": "/docs/v0.2.0/",
    "retention": "pending",
}
PREPARATION_CITATION = '''cff-version: 1.2.0
message: "If you use LeanInfoTheory in your work, please cite the software using this metadata."
type: software
title: "LeanInfoTheory"
version: "0.1.0"
date-released: 2026-09-01
doi: "10.5281/zenodo.22229599"
authors:
  - family-names: "Coban"
    given-names: "Serhat Emre"
    affiliation: "EPFL, Mathematics of Information Laboratory"
license: Apache-2.0
repository-code: "https://github.com/serhatemrecoban/LeanInfoTheory"
url: "https://serhatemrecoban.github.io/LeanInfoTheory/"
'''


class ReleaseStateTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.policy = copy.deepcopy(PREPARATION_POLICY)
        _, historical = compatibility.load_baseline()
        cls.config = {p: (ROOT / p).read_bytes() for p in
                      ("lean-toolchain", "lakefile.toml", "lake-manifest.json")}
        live = state.load_state(ROOT)
        cls.site_date = live.get("publication", {}).get("release_date", "2026-09-01")
        cls.config["lakefile.toml"] = state.project_lakefile(cls.config["lakefile.toml"], live)
        cls.hashes = {p: historical["release_source_sha256"][p] for p in cls.config}
        # The projected fixture must match independent immutable release hashes;
        # deriving expected hashes from live candidate bytes would weaken the test.
        for path, raw in cls.config.items():
            actual = hashlib.sha256(raw.replace(b"\r\n", b"\n")).hexdigest()
            if actual != cls.hashes[path]:
                raise AssertionError(f"fixture differs from historical configuration: {path}")

    def setUp(self):
        self.directory = tempfile.TemporaryDirectory(prefix="c24-state-", dir=ROOT / "tmp")
        self.root = Path(self.directory.name).resolve()
        self.assertTrue(self.root.is_relative_to((ROOT / "tmp").resolve()))
        for path, raw in self.config.items():
            (self.root / path).write_bytes(raw)
        self.write_policy(self.policy)

    def tearDown(self):
        self.assertTrue(self.root.is_relative_to((ROOT / "tmp").resolve()))
        self.directory.cleanup()

    def write_policy(self, value):
        path = self.root / state.STATE_PATH
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes((json.dumps(value, indent=2) + "\n").encode())

    def candidate(self):
        value = {**self.policy, "phase": "candidate"}
        self.write_policy(value)
        path = self.root / "lakefile.toml"
        path.write_bytes(path.read_bytes().replace(b'version = "0.1.0"', b'version = "0.2.0"', 1))
        return value

    def test_current_preparation_is_not_a_release(self):
        identity = state.contract_identity(self.root)
        self.assertEqual((identity["phase"], identity["package_version"], identity["target_version"]),
                         ("preparation", "0.1.0", "0.2.0"))
        self.assertFalse(identity["publishable"])
        self.assertEqual(identity["retention"], "pending")
        self.assertEqual(identity["stable_route"], "/docs/v0.1.0/")
        self.assertEqual(state.expected_citation(state.load_state(self.root)),
                         PREPARATION_CITATION)

    def test_live_metadata_matches_selected_state(self):
        live = state.load_state(ROOT)
        identity = state.contract_identity(ROOT)
        expected = "0.2.0" if live["phase"] in state.SECOND_RELEASE_PHASES else "0.1.0"
        self.assertEqual(identity["phase"], live["phase"])
        self.assertEqual(identity["package_version"], expected)
        self.assertEqual(identity["target_version"], "0.2.0")
        self.assertFalse(identity["publishable"])
        self.assertEqual((ROOT / "CITATION.cff").read_text(encoding="utf-8"),
                         state.expected_citation(live))
        state.check_legacy_configuration(ROOT, self.hashes)

    def test_candidate_version_projection_is_exact(self):
        self.candidate()
        state.check_legacy_configuration(self.root, self.hashes)
        self.assertEqual(state.contract_identity(self.root)["package_version"], "0.2.0")

    def test_candidate_citation_is_explicitly_unpublished_without_issued_identifiers(self):
        self.candidate()
        text = state.expected_citation(state.load_state(self.root))
        self.assertIn("Unpublished v0.2.0 candidate", text)
        self.assertIn('version: "0.2.0"', text)
        self.assertNotIn("date-released:", text)
        self.assertNotIn("doi:", text)
        self.assertIn('affiliation: "EPFL, Mathematics of Information Laboratory"', text)
        self.assertEqual(text.count("family-names:"), 1)

    def test_candidate_version_requires_explicit_state(self):
        self.candidate()
        (self.root / state.STATE_PATH).unlink()
        with self.assertRaisesRegex(ValueError, "unapproved package version"):
            state.check_legacy_configuration(self.root, self.hashes)
        with self.assertRaisesRegex(ValueError, "explicit candidate"):
            state.contract_identity(self.root)

    def test_release_ready_requires_exact_metadata_but_does_not_authorize(self):
        self.candidate()
        selected = {**self.policy, "phase": "release-ready", "retention": "established",
                    "publication": {**state.PUBLICATION, "release_date": "2026-11-05"}}
        self.write_policy(selected)
        loaded = state.load_state(self.root)
        citation = state.expected_citation(loaded)
        self.assertIn('version: "0.2.0"', citation)
        self.assertIn('date-released: 2026-11-05', citation)
        self.assertNotIn('doi:', citation)
        self.assertNotIn('Unpublished', citation)
        self.assertFalse(state.contract_identity(self.root)["publishable"])
        state.check_legacy_configuration(self.root, self.hashes)
        for issued in ("2026-09-01", "2026-02-30", "2026-1-5", "", None):
            with self.subTest(issued=issued), self.assertRaises(ValueError):
                state.validate_state({**selected, "publication": {**state.PUBLICATION, "release_date": issued}})
        for update in ({"retention": "pending"}, {"publication": {}},
                       {"publication": {**selected["publication"], "api_url": "https://example.com/"}},
                       {"publication": {**selected["publication"], "doi": "invented"}}):
            with self.subTest(update=update), self.assertRaises(ValueError):
                state.validate_state({**selected, **update})
        with self.assertRaises(ValueError):
            state.validate_state({**selected, "phase": "candidate"})

    def test_preparation_cannot_claim_candidate_package_or_established_retention(self):
        self.candidate()
        self.write_policy(self.policy)
        with self.assertRaisesRegex(ValueError, "package version"):
            state.contract_identity(self.root)
        self.write_policy({**self.policy, "retention": "established"})
        with self.assertRaisesRegex(ValueError, "requires unpublished"):
            state.load_state(self.root)

    def test_exact_version_projection_does_not_approve_other_drift(self):
        self.candidate()
        for path, replacement in (
            ("lakefile.toml", lambda b: b.replace(b"maxSynthPendingDepth = 3", b"maxSynthPendingDepth = 4")),
            ("lakefile.toml", lambda b: b + b"\n# unreviewed configuration bytes\n"),
            ("lakefile.toml", lambda b: b.replace(b'"v4.33.1"', b'"v4.33.2"')),
            ("lean-toolchain", lambda b: b.replace(b"v4.33.1", b"v4.33.2")),
            ("lake-manifest.json", lambda b: b.replace(b"0df444", b"1df444", 1)),
        ):
            with self.subTest(path=path):
                original = (self.root / path).read_bytes()
                changed = replacement(original)
                self.assertNotEqual(original, changed)
                (self.root / path).write_bytes(changed)
                with self.assertRaisesRegex(ValueError, "unapproved pinned build configuration"):
                    state.check_legacy_configuration(self.root, self.hashes)
                (self.root / path).write_bytes(original)

    def test_other_versions_and_nonexact_version_line_are_rejected(self):
        self.candidate()
        path = self.root / "lakefile.toml"
        original = path.read_bytes()
        for line in (b'version = "0.3.0"', b'version="0.2.0"', b'version = "0.2.0" # drift'):
            path.write_bytes(original.replace(b'version = "0.2.0"', line))
            with self.subTest(line=line), self.assertRaises(ValueError):
                state.check_legacy_configuration(self.root, self.hashes)

    def test_historical_path_remains_exact(self):
        (self.root / state.STATE_PATH).unlink()
        state.check_legacy_configuration(self.root, self.hashes)
        path = self.root / "lakefile.toml"
        path.write_bytes(path.read_bytes() + b"\n# drift\n")
        with self.assertRaisesRegex(ValueError, "unapproved pinned"):
            state.check_legacy_configuration(self.root, self.hashes)

    def test_unsupported_or_duplicate_policy_fields_are_rejected(self):
        for update in ({"phase": "released"}, {"phase": []}, {"retention": []},
                       {"target_version": "0.3.0"}, {"stable_version": "0.2.0"},
                       {"current_route": "/docs/v0.1.0/"}, {"publishable": True}):
            self.write_policy({**self.policy, **update})
            with self.subTest(update=update), self.assertRaises(ValueError):
                state.load_state(self.root)
        (self.root / state.STATE_PATH).write_bytes(b'{"schema":1,"schema":2}')
        with self.assertRaisesRegex(ValueError, "duplicate"):
            state.load_state(self.root)

    def test_alternate_lake_configuration_is_not_projected(self):
        (self.root / "lakefile.lean").write_bytes(b"import Lake\n")
        with self.assertRaisesRegex(ValueError, "alternate"):
            state.check_legacy_configuration(self.root, self.hashes)

    def test_validation_inputs_bind_state_machinery_and_established_outputs(self):
        for relative in state.PRODUCTION_INPUTS:
            path = self.root / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            if relative != state.STATE_PATH:
                path.write_bytes(b"fixture input\n")
        before = set(state.validation_inputs(self.root))
        self.assertIn(state.STATE_PATH, before)
        self.candidate()
        self.write_policy({**self.policy, "phase": "candidate", "retention": "established"})
        with self.assertRaisesRegex(ValueError, "established candidate retention"):
            state.validation_inputs(self.root)
        for relative in (state.CANDIDATE_CONTRACT_PATH, state.CANDIDATE_APPROVAL_PATH):
            path = self.root / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(b"fixture output only; not an approved contract\n")
        after = set(state.validation_inputs(self.root))
        self.assertEqual(after - before, {state.CANDIDATE_CONTRACT_PATH, state.CANDIDATE_APPROVAL_PATH})

    def test_private_content_guard_uses_tree_metadata_and_preserves_local_bytes(self):
        path = self.root / state.LOCAL_PRIVATE_PATH
        path.parent.mkdir(parents=True, exist_ok=True)
        secret = b"fixture local private bytes\x00\xff"
        path.write_bytes(secret)
        with patch.object(state.subprocess, "run") as run:
            run.return_value = type("Result", (), {"returncode": 0, "stdout": b"100644 blob hash\tdocs/next-website-tasks.md\n"})()
            with self.assertRaisesRegex(ValueError, "still contains"):
                state.require_candidate_content(self.root)
            run.return_value = type("Result", (), {"returncode": 0, "stdout": b""})()
            state.require_candidate_content(self.root)
            self.assertTrue(all(call.args[0][:3] == ["git", "ls-tree", "HEAD"] for call in run.call_args_list))
        self.assertEqual(path.read_bytes(), secret)

    def metadata_fixture(self):
        # Explicit public whitelist: the protected website-task file is absent.
        for relative in (
            ".gitattributes", "LICENSE", "README.md",
            "docs/releases/v0.1.0.md", "docs/v0.1-release-contract.md",
            "docs/v0.1-legal-metadata-audit.md", "docs/current-lean-state.md",
            "docs/lean-info-theory-living-summary.md", "docs/roadmap.md",
            "home_page/index.html", "home_page/license.html", "home_page/docs/third-party.html",
        ):
            target = self.root / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes((ROOT / relative).read_bytes())
        (self.root / "CITATION.cff").write_text(
            PREPARATION_CITATION, encoding="utf-8", newline="\n")
        # Preparation/candidate fixtures keep the published v0.1.0 site identity
        # even when the live source has advanced to release-ready publication copy.
        for name in ("index.html", "license.html"):
            path = self.root / "home_page" / name
            source = path.read_text(encoding="utf-8")
            source = source.replace(f'name="citation_publication_date" content="{self.site_date}"',
                                    'name="citation_publication_date" content="2026-09-01"')
            if 'name="citation_doi"' not in source:
                source = source.replace('</head>',
                    '<meta name="citation_doi" content="10.5281/zenodo.22229599"></head>')
            source = source.replace('Latest stable release: <code>v0.2.0</code>',
                                    'Latest stable release: <code>v0.1.0</code>')
            path.write_text(source, encoding="utf-8", newline="\n")
        # Current README prose may correctly omit this preparation-only CFF
        # sentence. Supply that fact explicitly in the preparation fixture.
        readme = self.root / "README.md"
        readme.write_text(readme.read_text(encoding="utf-8").replace(
            'rev = "v0.2.0"', 'rev = "v0.1.0"'), encoding="utf-8", newline="\n")
        sentence = "Its `date-released` value is `2026-09-01`"
        if sentence not in " ".join(readme.read_text(encoding="utf-8").split()):
            with readme.open("a", encoding="utf-8", newline="\n") as output:
                output.write("\nPreparation citation fixture: " + sentence + ".\n")

    def test_real_metadata_validator_handles_both_states_without_private_file(self):
        import validate_release as validator
        self.metadata_fixture()
        self.assertFalse((self.root / state.LOCAL_PRIVATE_PATH).exists())
        with patch.object(validator, "ROOT", self.root), redirect_stdout(io.StringIO()):
            validator.check_release_metadata()
        self.candidate()
        (self.root / "CITATION.cff").write_bytes(state.expected_citation(state.load_state(self.root)).encode())
        with (self.root / "README.md").open("ab") as stream:
            stream.write(b"\nAn unpublished v0.2.0 candidate; stable remains v0.1.0.\n")
        with patch.object(validator, "ROOT", self.root), redirect_stdout(io.StringIO()):
            validator.check_release_metadata()

    def test_release_ready_site_citation_dates_are_enforced(self):
        import validate_release as validator
        self.metadata_fixture()
        self.candidate()
        ready = {**self.policy, "phase": "release-ready", "retention": "established",
                 "publication": {**state.PUBLICATION, "release_date": self.site_date}}
        self.write_policy(ready)
        (self.root / "CITATION.cff").write_text(state.expected_citation(ready), encoding="utf-8")
        (self.root / "README.md").write_bytes((ROOT / "README.md").read_bytes())
        for name in ("index.html", "license.html"):
            (self.root / "home_page" / name).write_bytes((ROOT / "home_page" / name).read_bytes())
        with patch.object(validator, "ROOT", self.root), redirect_stdout(io.StringIO()):
            validator.check_release_metadata()
            for name in ("index.html", "license.html"):
                path = self.root / "home_page" / name
                original = path.read_text(encoding="utf-8")
                marker = f'<meta name="citation_publication_date" content="{self.site_date}">'
                self.assertIn(marker, original)
                for replacement in (marker.replace(self.site_date, "2026-09-01"), "", marker * 2):
                    path.write_text(original.replace(marker, replacement), encoding="utf-8")
                    with self.subTest(page=name, replacement=replacement), \
                         self.assertRaisesRegex(validator.ValidationError, "citation_publication_date"):
                        validator.check_release_metadata()
                path.write_text(original, encoding="utf-8")
            validator.check_release_metadata()

    def test_real_candidate_metadata_validator_rejects_issued_ids_and_wrong_creator(self):
        import validate_release as validator
        self.metadata_fixture()
        self.candidate()
        with (self.root / "README.md").open("ab") as stream:
            stream.write(b"\nAn unpublished v0.2.0 candidate; stable remains v0.1.0.\n")
        original = state.expected_citation(state.load_state(self.root))
        for text in (
            original.replace("authors:", 'doi: "10.5281/zenodo.22229599"\nauthors:'),
            original.replace("authors:", "date-released: 2026-09-01\nauthors:"),
            original.replace('given-names: "Serhat Emre"', 'given-names: "Other"'),
            original.replace('version: "0.2.0"', 'version: "0.1.0"'),
        ):
            (self.root / "CITATION.cff").write_bytes(text.encode())
            with self.subTest(text=text[:100]), patch.object(validator, "ROOT", self.root), \
                 self.assertRaisesRegex(validator.ValidationError, "CITATION.cff"):
                validator.check_release_metadata()


    def test_candidate_notes_receive_local_link_and_institutional_checks(self):
        import validate_release as validator
        self.metadata_fixture()
        self.candidate()
        for relative in (
            "home_page/docs/index.html", "home_page/docs/v0.1.0/index.html",
            "home_page/docs/v0.1.0/licenses/index.html", "home_page/module-guide.html",
            "home_page/roadmap.html", "blueprint/README.md",
        ):
            path = self.root / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes((ROOT / relative).read_bytes())
        path = self.root / "docs/releases/v0.2.0.md"
        base = "# Unpublished v0.2.0\nStable v0.1.0; information is in nats.\n"
        path.write_text(base + "[contract](../v0.1-release-contract.md)\n", encoding="utf-8")
        real_links = validator.check_local_markdown_links
        def candidate_links(paths):
            self.assertIn(path, paths)
            real_links((path,))
        with patch.object(validator, "ROOT", self.root), \
             patch.object(validator, "RELEASE_NOTES_PATH", self.root / "docs/releases/v0.1.0.md"), \
             patch.object(validator, "check_local_markdown_links", side_effect=candidate_links), \
             redirect_stdout(io.StringIO()):
            validator.check_release_documentation_contract()
            path.write_text(base + "[missing](missing.md)\n", encoding="utf-8")
            with self.assertRaisesRegex(validator.ValidationError, "missing.md"):
                validator.check_release_documentation_contract()
            path.write_text(base + "Approved by EPFL\n", encoding="utf-8")
            with self.assertRaisesRegex(validator.ValidationError, "institutional claim"):
                validator.check_release_documentation_contract()


if __name__ == "__main__":
    unittest.main()
