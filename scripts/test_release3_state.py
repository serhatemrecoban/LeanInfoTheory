"""Exercise the Release 3 metadata lifecycle without changing the repository's state."""
from __future__ import annotations

import json
import hashlib
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import release3_state as state

# Deliberately synthetic, local metadata and object identities.
EXAMPLE_DATE = "2099-01-02"
EXAMPLE_CONTRACT_PINS = {state.CONTRACT_PATH: "1" * 64, state.APPROVAL_PATH: "2" * 64}
EXAMPLE_ARCHIVE = {
    "version_doi": "10.5281/zenodo.123456789",
    "concept_doi": state.CONCEPT_DOI,
    "archive_sha256": "a" * 64,
    "tag_object": "b" * 40,
    "source_commit": "c" * 40,
    "git_tree": "d" * 40,
}


class MetadataTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        def tagged_file(name):
            return subprocess.check_output(["git", "show", "953b785fbdbcc9bffe22834124d5e1cbd14a4835:" + name],
                                           cwd=state.ROOT)
        cls.old_cff = tagged_file("CITATION.cff")
        cls.old_package = tagged_file("lakefile.toml")

    def setUp(self):
        scratch = state.ROOT / "tmp"
        scratch.mkdir(exist_ok=True)
        self.temp = tempfile.TemporaryDirectory(dir=scratch)
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.policy = self.root / state.STATE_PATH
        self.policy.parent.mkdir(parents=True)
        self.cff = self.root / "CITATION.cff"
        self.package = self.root / "lakefile.toml"
        self.ready = {**state.FIXED, "phase": "candidate-ready", "release_date": EXAMPLE_DATE}
        self.reviewed = {**self.ready, "retained_api": EXAMPLE_CONTRACT_PINS}
        self.maintained = {**self.reviewed, "phase": "published-maintenance", "archive": EXAMPLE_ARCHIVE}
        self.tagged_package = self.old_package.replace(b'version = "0.2.0"', b'version = "0.3.0"')
        self.tagged_cff = self.old_cff.replace(b'0.2.0', b'0.3.0').replace(b'2026-11-05', EXAMPLE_DATE.encode())

    def select(self, policy, cff, package):
        self.policy.write_bytes(json.dumps(policy).encode())
        self.cff.write_bytes(cff)
        self.package.write_bytes(package)

    def test_live_state(self):
        self.assertEqual(state.check_metadata()["target_version"], "0.3.0")

    def test_reviewed_contract_pins_are_version_specific(self):
        pins = EXAMPLE_CONTRACT_PINS
        self.assertEqual(state.validate_state(self.reviewed)["retained_api"], pins)
        for invalid in (None, {}, {**pins, state.CONTRACT_PATH: "x" * 64},
                        {state.historical.CANDIDATE_CONTRACT_PATH: "1" * 64, state.APPROVAL_PATH: "2" * 64}):
            with self.subTest(invalid=invalid), self.assertRaisesRegex(ValueError, "retained API"):
                state.validate_state({**self.ready, "retained_api": invalid})
        with self.assertRaises(ValueError):
            state.validate_state({**state.FIXED, "phase": "preparation", "retained_api": pins})
        with self.assertRaisesRegex(ValueError, "retained API"):
            state.validate_state({**self.ready, "phase": "published-maintenance", "archive": EXAMPLE_ARCHIVE})

    def test_preparation_preserves_previous_published_metadata(self):
        old_published = self.old_cff.replace(b"authors:\n", b'doi: "10.5281/zenodo.23973538"\nauthors:\n')
        self.select({**state.FIXED, "phase": "preparation"}, old_published, self.old_package)
        state.check_metadata(self.root)
        self.cff.write_bytes(self.old_cff)
        with self.assertRaisesRegex(ValueError, "CITATION"):
            state.check_metadata(self.root)
        self.cff.write_bytes(old_published)
        self.package.write_bytes(self.tagged_package)
        with self.assertRaisesRegex(ValueError, "lakefile"):
            state.check_metadata(self.root)

    def test_candidate_requires_doi_free_dated_citation_and_exact_package(self):
        self.select(self.ready, self.tagged_cff, self.tagged_package)
        state.check_metadata(self.root)
        for altered in (
            self.tagged_cff.replace(b"2099-01-02", b"2099-01-03"),
            self.tagged_cff.replace(b"authors:", b'doi: "10.5281/zenodo.23973538"\nauthors:'),
            self.tagged_cff.replace(b"Serhat Emre", b"Example"),
            self.tagged_cff.replace(b"Apache-2.0", b"MIT"),
        ):
            with self.subTest(altered=altered), self.assertRaisesRegex(ValueError, "CITATION"):
                self.cff.write_bytes(altered)
                state.check_metadata(self.root)
        self.cff.write_bytes(self.tagged_cff)
        self.package.write_bytes(self.tagged_package.replace(b"v4.33.1", b"v4.33.0"))
        with self.assertRaisesRegex(ValueError, "lakefile"):
            state.check_metadata(self.root)
        self.package.write_bytes(self.tagged_package)
        for alternate in ("lakefile.lean", ".zenodo.json"):
            with self.subTest(alternate=alternate), self.assertRaisesRegex(ValueError, "alternate"):
                (self.root / alternate).touch()
                state.check_metadata(self.root)
            (self.root / alternate).unlink()

    def test_unsupported_states_routes_dates_or_identifiers_fail(self):
        updates = ({"phase": "pending"}, {"api_url": state.MAIN_URL}, {"release_date": None},
                   {"release_date": "2026-11-05"}, {"release_date": "2099-02-31"},
                   {"phase": "preparation"}, {"archive": EXAMPLE_ARCHIVE}, {"publish": True})
        for update in updates:
            with self.subTest(update=update), self.assertRaises(ValueError):
                state.validate_state({**self.ready, **update})
        for update in ({"version_doi": state.CONCEPT_DOI}, {"concept_doi": EXAMPLE_ARCHIVE["version_doi"]},
                       *({"version_doi": doi} for doi in state.PREVIOUS_DOIS),
                       {"version_doi": "example"}, {"archive_sha256": "unknown"}, {"tag_object": "HEAD"}):
            with self.subTest(update=update), self.assertRaises(ValueError):
                state.validate_state({**self.maintained, "archive": {**EXAMPLE_ARCHIVE, **update}})
        with self.assertRaises(ValueError):
            state.validate_state(self.maintained | {"archive": None})
        self.policy.write_text(json.dumps(self.ready)[:-1] + ', "phase": "candidate-ready"}', encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "duplicate"):
            state.load_state(self.root)

    def test_published_metadata_matches_annotated_tag_and_archive_evidence(self):
        tag = "refs/tags/" + state.TAG
        replies = {
            ("rev-parse", tag + "^{tag}"): EXAMPLE_ARCHIVE["tag_object"].encode(),
            ("rev-parse", tag + "^{commit}"): EXAMPLE_ARCHIVE["source_commit"].encode(),
            ("rev-parse", tag + "^{tree}"): EXAMPLE_ARCHIVE["git_tree"].encode(),
            ("merge-base", "--is-ancestor", EXAMPLE_ARCHIVE["source_commit"], "HEAD"): b"",
            ("show", tag + ":" + state.STATE_PATH): json.dumps(self.reviewed).encode(),
            ("show", tag + ":CITATION.cff"): self.tagged_cff,
            ("show", tag + ":lakefile.toml"): self.tagged_package,
        }

        def git(args, **kwargs):
            key = tuple(args[1:])
            return subprocess.CompletedProcess(args, int(key not in replies), replies.get(key, b""), b"")

        version_doi = EXAMPLE_ARCHIVE["version_doi"]
        maintained = self.tagged_cff.replace(b"authors:\n", f'doi: "{version_doi}"\nauthors:\n'.encode())
        self.select(self.maintained, maintained, self.tagged_package)
        with patch.object(state.subprocess, "run", side_effect=git):
            state.check_metadata(self.root)
            for key in tuple(replies):
                original = replies.pop(key)
                with self.subTest(missing=key), self.assertRaises(ValueError):
                    state.check_metadata(self.root)
                replies[key] = original
            for key in (("rev-parse", tag + "^{commit}"), ("show", tag + ":CITATION.cff"),
                        ("show", tag + ":lakefile.toml"), ("show", tag + ":" + state.STATE_PATH)):
                original, replies[key] = replies[key], b"invalid"
                with self.subTest(wrong=key), self.assertRaises(ValueError):
                    state.check_metadata(self.root)
                replies[key] = original
            tag_state = ("show", tag + ":" + state.STATE_PATH)
            for other in (self.ready, {**self.ready, "retained_api": {
                    **EXAMPLE_CONTRACT_PINS, state.CONTRACT_PATH: "3" * 64}}):
                replies[tag_state] = json.dumps(other).encode()
                with self.subTest(tag_state=other), self.assertRaisesRegex(ValueError, "retained API"):
                    state.check_metadata(self.root)
            self.select(self.ready, self.tagged_cff, self.tagged_package)
            replies[tag_state] = json.dumps(self.ready).encode()
            with self.assertRaisesRegex(ValueError, "requires reviewed"):
                state.check_tag(self.root, EXAMPLE_DATE, EXAMPLE_ARCHIVE["tag_object"],
                                EXAMPLE_ARCHIVE["source_commit"], self.tagged_cff, self.tagged_package)
            self.select(self.maintained, maintained, self.tagged_package)
            replies[tag_state] = json.dumps(self.reviewed).encode()
            self.cff.write_bytes(self.tagged_cff)
            with self.assertRaisesRegex(ValueError, "CITATION"):
                state.check_metadata(self.root)

    def test_candidate_metadata_dispatch_checks_current_pages_and_frozen_inputs(self):
        import validate_development as development
        import validate_published as published
        self.select(self.ready, self.tagged_cff, self.tagged_package)
        from_repo = state.ROOT / ".github/workflows"
        shutil.copytree(from_repo, self.root / ".github/workflows")
        template = self.root / published.PROMOTION_TEMPLATE
        template.parent.mkdir(parents=True)
        shutil.copyfile(state.ROOT / published.PROMOTION_TEMPLATE, template)
        home = self.root / "home_page"
        home.mkdir()
        holder = "École polytechnique fédérale de Lausanne (EPFL)"
        page = (f'<meta name="citation_publication_date" content="{EXAMPLE_DATE}">'
                f'<meta name="citation_author" content="Coban, Serhat Emre">'
                f'<a href="{published.WORKFLOW}"><img src="{published.WORKFLOW}/badge.svg"></a>' + holder)
        for name in ("index.html", "license.html"):
            (home / name).write_text(page, encoding="utf-8")
        (self.root / "README.md").write_text(
            f'{holder}\nrev = "v0.3.0"\n918 supported declarations; 77 supported modules.\n'
            f'{published.WORKFLOW}/badge.svg\nyoutu.be/CXHebbD7ouA #pfr-case-study\n',
            encoding="utf-8")

        # Use the real immutable v0.2 tag for historical queries; only the
        # disposable files above carry simulated R3 candidate metadata.
        def historical_git(*args):
            return subprocess.check_output(["git", *args], cwd=state.ROOT)

        with patch.object(published, "ROOT", self.root), patch.object(published, "git", historical_git):
            published.check_maintenance(ci_sha256=development.DEVELOPMENT_CI_SHA256)
            (home / "index.html").write_text(page + '<meta name="citation_doi" content="obsolete">',
                                            encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "Incorrect visible or indexed citation"):
                published.check_maintenance(ci_sha256=development.DEVELOPMENT_CI_SHA256)

    def test_release3_proposal_is_doi_free_without_changing_live_metadata(self):
        import prepare_publication as preparation
        old_published = self.old_cff.replace(b"authors:\n", b'doi: "10.5281/zenodo.23973538"\nauthors:\n')
        self.select({**state.FIXED, "phase": "preparation"}, old_published, self.old_package)
        proposed = preparation.metadata_proposal(self.root, EXAMPLE_DATE)
        self.assertEqual(set(proposed), {Path(state.STATE_PATH).name, "lakefile.toml", "CITATION.cff"})
        self.assertEqual(self.cff.read_bytes(), old_published)
        self.assertEqual(self.package.read_bytes(), self.old_package)
        self.assertEqual(state.check_metadata(self.root)["phase"], "preparation")
        self.select(json.loads(proposed[Path(state.STATE_PATH).name]), proposed["CITATION.cff"], proposed["lakefile.toml"])
        self.assertEqual(state.check_metadata(self.root), self.ready)
        with self.assertRaisesRegex(ValueError, "starts from preparation"):
            preparation.metadata_proposal(self.root, EXAMPLE_DATE)

    def test_promotion_activation_requires_reviewed_workflow_and_bound_pins(self):
        import validate_published as published
        template = (state.ROOT / published.PROMOTION_TEMPLATE).read_bytes()
        archive = EXAMPLE_ARCHIVE
        pins = {"release_commit": archive["source_commit"], "annotated_tag": archive["tag_object"],
                "bundles_revision": "e" * 40, "receipt_sha256": "f" * 64,
                "archives": {site: {"zip_sha256": "1" * 64, "tar_sha256": "2" * 64} for site in ("main", "api")}}
        self.select(self.reviewed, self.tagged_cff, self.tagged_package)
        pins_file = self.root / published.PROMOTION_PINS
        pins_file.write_bytes(json.dumps(pins).encode())
        with patch.object(published, "ROOT", self.root), patch.object(state, "check_tag") as check_tag, \
                patch.object(published, "git", return_value=template) as git:
            published.check_release3_promotion(self.reviewed, template)
            check_tag.assert_called_once_with(self.root, EXAMPLE_DATE, pins["annotated_tag"], pins["release_commit"],
                                              self.tagged_cff, self.tagged_package)
            git.assert_called_once_with("show", pins["release_commit"] + ":" + published.PROMOTION_TEMPLATE)
            with self.assertRaisesRegex(ValueError, "active workflow"):
                published.check_release3_promotion(self.reviewed, template + b"# changed")
            with self.assertRaisesRegex(ValueError, "annotated public-release target"):
                published.check_release3_promotion({**state.FIXED, "phase": "preparation"}, template)
            pins_file.write_bytes(json.dumps({**pins, "archives": {"api": {}}}).encode())
            with self.assertRaisesRegex(ValueError, "archive pins"):
                published.check_release3_promotion(self.reviewed, template)
            pins_file.write_bytes(json.dumps({**pins, "release_commit": "0" * 40}).encode())
            with self.assertRaisesRegex(ValueError, "different sources"):
                published.check_release3_promotion(self.maintained, template)

    def test_check_on_published_v02_tree_still_uses_its_811_contract(self):
        import check_candidate_api_compatibility as exporter
        historical = state.historical
        self.package.write_bytes(self.old_package)
        for name, digest in state.V02_REFERENCE.items():
            raw = (state.ROOT / name).read_bytes()
            self.assertEqual(hashlib.sha256(raw).hexdigest(), digest)
            target = self.root / name
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(raw)
        self.assertFalse(self.policy.exists())
        baseline, _, _ = exporter.candidate.load_approved_snapshot(self.root)
        self.assertEqual(baseline["release_identity"]["target_version"], historical.TARGET_VERSION)
        with patch.object(exporter, "ROOT", self.root), \
                patch.object(exporter, "fresh_contract", return_value=baseline) as fresh:
            result = exporter.run_check(None)
        fresh.assert_called_once_with(None, deterministic=False)
        self.assertEqual(result["outcome"], "PASS")
        self.assertEqual(result["declaration_count"], 811)
        self.assertEqual(result["artifact_sha256"], state.V02_REFERENCE[historical.CANDIDATE_CONTRACT_PATH])
        self.assertEqual(result["approval_sha256"], state.V02_REFERENCE[historical.CANDIDATE_APPROVAL_PATH])

    def test_candidate_identity_through_docgen_export_and_historical_reference(self):
        import api_doc_identity as docs
        import check_candidate_api_compatibility as exporter
        import validate_release as release
        # Copy the real pinned producer sources. Only the proposed version/date,
        # package and DOI-free citation differ from the preparation checkout.
        files = set(docs.source_inputs(state.ROOT)) | set(exporter.candidate.producer_identity(state.ROOT))
        for name in files:
            dest = self.root / name
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(state.ROOT / name, dest)
        self.select(self.ready, self.tagged_cff, self.tagged_package)
        observed = state.contract_identity(self.root)
        self.assertEqual(observed["phase"], "candidate-ready")
        self.assertEqual(observed["package_version"], "0.3.0")
        self.assertEqual(observed["citation_sha256"], hashlib.sha256(self.tagged_cff).hexdigest())
        self.assertFalse(observed["publishable"])
        with self.assertRaisesRegex(ValueError, "NOT_ESTABLISHED"):
            exporter.candidate.load_release3_snapshot(self.root)
        approved, _, _ = exporter.candidate.load_approved_snapshot(self.root)
        self.assertEqual(approved["release_identity"]["target_version"], "0.2.0")
        self.assertEqual(approved["declaration_count"], 811)
        self.assertNotEqual(exporter.candidate.identity_projection(observed),
                            exporter.candidate.identity_projection(approved["release_identity"]))
        with self.assertRaises(ValueError):
            exporter.candidate.identity_projection({**observed, "publishable": True})

        # This fixture has no Lake cache. Use its real locked dependency IDs in
        # place of probing installed checkouts; run both native config functions.
        doc_lock = json.loads((self.root / "docbuild/lake-manifest.json").read_bytes())
        pins = {p["name"]: p["rev"] for p in doc_lock["packages"] if p["type"] == "git"}
        with patch.object(docs, "ROOT", self.root), patch.object(release, "ROOT", self.root), \
                patch.object(docs, "dependency_identity", return_value=pins):
            config = release.api_doc_build_configuration("file")
            docs.verify_configuration(config)
            self.assertEqual(config["api_identity"]["release_contract"], observed)
            wrong = {**config, "api_identity": {**config["api_identity"], "release_contract": approved["release_identity"]}}
            with self.assertRaisesRegex(ValueError, "stale"):
                docs.verify_configuration(wrong)

        # Run the real fresh-contract producer up to its first Lean command:
        # inventory, source projections and declared-boundary checks are real.
        # This stop produces neither a compiled capture nor an approval.
        observations = {}
        class StopBeforeCompiler(Exception):
            pass

        class Evidence:
            def write(self, name, data):
                observations[name] = data

            def run(self, label, args):
                if label != "compiler":
                    raise AssertionError(f"unexpected native command {label}")
                raise StopBeforeCompiler

        with patch.object(exporter, "ROOT", self.root), \
                patch.object(exporter.legacy.retained, "dependency_identity", return_value=approved["producer"]["dependencies"]):
            with self.assertRaises(StopBeforeCompiler):
                exporter.fresh_contract(Evidence(), deterministic=True)
            with self.assertRaisesRegex(ValueError, "NOT_ESTABLISHED: dated v0.3.0"):
                exporter.run_check(Evidence())
        self.assertEqual(observations["producer-before.json"]["release_identity"], observed)
        self.assertIn("scripts/release3_state.py", observations["producer-before.json"]["files"])
        self.assertEqual(observations["current-manifest.json"],
                         json.loads((self.root / "docs/current-public-api.json").read_bytes()))
        self.assertIn("expected-boundaries.json", observations)
        # Preserve the historical reference at each phase, including its policy.
        historical = self.root / state.historical.CANDIDATE_APPROVAL_PATH
        historical.write_bytes(historical.read_bytes() + b" ")
        with self.assertRaisesRegex(ValueError, "historical v0.2.0"):
            exporter.candidate.load_approved_snapshot(self.root)


if __name__ == "__main__":
    unittest.main()
