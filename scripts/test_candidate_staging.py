#!/usr/bin/env python3
"""Candidate staging regressions using disposable Git and synthetic API inputs.

These tests do not run Lean or doc-gen and do not attest actual generated docs.
Synthetic API/attestation and historical-route fixtures exercise validation and
copying boundaries only; clean-checkout admission uses real isolated Git repos.
"""

from __future__ import annotations

import hashlib
import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import api_doc_identity as identity
import check_website as checker
import current_api
import release_state
import stage_website as staging


ROOT = Path(__file__).resolve().parents[1]
INPUT_REFUSAL = (staging.StagingError, ValueError)


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, sort_keys=True, indent=2) + "\n",
                    encoding="utf-8", newline="\n")


def git(root: Path, *arguments: str) -> str:
    result = subprocess.run(
        ["git", "-c", "core.autocrlf=false", "-c", "commit.gpgsign=false",
         "-c", "user.name=Candidate staging fixture",
         "-c", "user.email=candidate-fixture@example.invalid", *arguments],
        cwd=root, capture_output=True, encoding="utf-8", check=False,
    )
    if result.returncode:
        raise AssertionError(f"synthetic Git command failed: {arguments!r}: {result.stderr}")
    return result.stdout.strip()


class IsolatedRepositoryTests(unittest.TestCase):
    def setUp(self) -> None:
        auxiliary = ROOT / ".worktrees"
        auxiliary.mkdir(exist_ok=True)
        self.temporary = tempfile.TemporaryDirectory(prefix="candidate-stage-test-", dir=auxiliary)
        self.addCleanup(self.temporary.cleanup)
        self.base = Path(self.temporary.name)
        self.root = self.base / "source"
        self.root.mkdir()
        git(self.root, "init", "--quiet")
        (self.root / ".gitignore").write_text(".lake/\ndocbuild/.lake/\n", encoding="utf-8")
        (self.root / "tracked.txt").write_text("synthetic initial source\n", encoding="utf-8")
        (self.root / "lakefile.toml").write_text('name = "LeanInfoTheory"\nversion = "0.1.0"\n',
                                               encoding="utf-8")
        write_json(self.root / release_state.STATE_PATH,
                   dict(release_state.FIXED, phase="preparation", retention="pending"))
        self.commit = self.commit_all()
        self.enterContext(patch.object(staging, "ROOT", self.root))
        clean_environment = {key: value for key, value in os.environ.items()
                             if not key.startswith("GITHUB_") and key != "CI"}
        self.enterContext(patch.dict(os.environ, clean_environment, clear=True))

    def commit_all(self) -> str:
        git(self.root, "add", "--all")
        git(self.root, "-c", "core.hooksPath=" + str(self.base / "no-hooks"),
            "commit", "--quiet", "-m", "Synthetic candidate test fixture")
        return git(self.root, "rev-parse", "HEAD")


class CandidateCheckoutTests(IsolatedRepositoryTests):
    def test_clean_nondefault_branch_is_admitted_without_ci(self) -> None:
        git(self.root, "checkout", "--quiet", "-b", "fixture-candidate")
        self.assertNotIn("GITHUB_ACTIONS", os.environ)
        self.assertEqual(staging.validate_candidate_checkout(self.commit), self.commit)

    def test_clean_detached_checkout_is_admitted_without_ci(self) -> None:
        git(self.root, "checkout", "--quiet", "--detach", self.commit)
        self.assertEqual(git(self.root, "branch", "--show-current"), "")
        self.assertNotIn("GITHUB_SHA", os.environ)
        self.assertEqual(staging.validate_candidate_checkout(self.commit), self.commit)

    def test_wrong_exact_commit_is_refused(self) -> None:
        wrong = ("0" if self.commit[0] != "0" else "1") + self.commit[1:]
        with self.assertRaises(staging.StagingError):
            staging.validate_candidate_checkout(wrong)

    def test_commit_alias_abbreviation_and_invalid_values_are_refused(self) -> None:
        for value in ("", "HEAD", self.commit[:12], "v0.2.0", "g" * 40, self.commit.upper()):
            with self.subTest(value=value), self.assertRaises(staging.StagingError):
                staging.validate_candidate_checkout(value)

    def test_tracked_unstaged_change_is_refused(self) -> None:
        (self.root / "tracked.txt").write_text("changed source\n", encoding="utf-8")
        with self.assertRaises(staging.StagingError):
            staging.validate_candidate_checkout(self.commit)

    def test_staged_change_is_refused(self) -> None:
        (self.root / "tracked.txt").write_text("staged source\n", encoding="utf-8")
        git(self.root, "add", "tracked.txt")
        with self.assertRaises(staging.StagingError):
            staging.validate_candidate_checkout(self.commit)

    def test_untracked_change_is_refused(self) -> None:
        (self.root / "untracked.txt").write_text("untracked source\n", encoding="utf-8")
        with self.assertRaises(staging.StagingError):
            staging.validate_candidate_checkout(self.commit)

    def test_ignored_output_does_not_make_the_checkout_dirty(self) -> None:
        generated = self.root / ".lake" / "fixture.txt"
        generated.parent.mkdir()
        generated.write_text("ignored build fixture\n", encoding="utf-8")
        self.assertEqual(staging.validate_candidate_checkout(self.commit), self.commit)

    def test_tracked_private_task_path_is_refused_without_changing_fixture_bytes(self) -> None:
        # This is a wholly synthetic file in the disposable repository. The real
        # project's private task file is neither opened nor copied by this test.
        path = self.root / "docs/next-website-tasks.md"
        payload = b"Explicitly synthetic private-path regression fixture.\n"
        path.write_bytes(payload)
        self.commit = self.commit_all()
        with self.assertRaises(INPUT_REFUSAL):
            staging.validate_candidate_checkout(self.commit)
        self.assertEqual(path.read_bytes(), payload)


class SyntheticCandidateFixture(IsolatedRepositoryTests):
    """Real validators, with explicit synthetic external API/dependency inputs."""

    def setUp(self) -> None:
        super().setUp()
        self.site_source = self.root / "home_page"
        self.doc_source = self.root / "docbuild/.lake/build/doc"
        self.config_path = self.doc_source.parent / "api-doc-build-config.json"
        self.attestation_path = self.doc_source.parent / "api-doc-build-attestation.json"
        self.stage_parent = self.root / ".lake/website-stage"
        self.stage_root = self.stage_parent / "LeanInfoTheory"
        self.site_source.mkdir()
        self.doc_source.mkdir(parents=True)
        (self.site_source / "index.html").write_text(
            '<!doctype html><html><body><a href="docs/">Documentation</a></body></html>\n',
            encoding="utf-8")
        (self.site_source / "docs").mkdir()
        (self.site_source / "docs/index.html").write_text(
            '<!doctype html><html><body><div class="link-grid">'
            '<a href="v0.1.0/">Stable v0.1.0</a></div></body></html>\n', encoding="utf-8")
        (self.site_source / "docs/api-index.html").write_text(
            '<!doctype html><html><body>Source links target current development '
            f'<a href="{staging.REPOSITORY_URL}/blob/master/LeanInfoTheory/Fixture.lean#L2">'
            'fixture source</a></body></html>\n', encoding="utf-8")
        (self.root / "LICENSE").write_text("Synthetic fixture licence only.\n", encoding="utf-8")
        (self.root / "lakefile.toml").write_text('name = "LeanInfoTheory"\nversion = "0.1.0"\n',
                                               encoding="utf-8")
        self.state = dict(release_state.FIXED, phase="preparation", retention="pending")
        write_json(self.root / release_state.STATE_PATH, self.state)
        self.lean_source = self.root / "LeanInfoTheory/Fixture.lean"
        self.lean_source.parent.mkdir()
        self.lean_source.write_text('/-- Synthetic fixture. -/\ndef fixture : Nat := 1\n', encoding="utf-8")
        (self.root / "LeanInfoTheory.lean").write_text("import LeanInfoTheory.Fixture\n", encoding="utf-8")
        self.manifest = {
            "supported_modules": ["LeanInfoTheory", "LeanInfoTheory.Fixture"],
            "non_stable_modules": ["LeanInfoTheory.Examples"],
            "declarations": [{"name": "LeanInfoTheory.fixture", "module": "LeanInfoTheory.Fixture",
                              "kind": "def", "attributes": []}],
            "root_exports": [], "declaration_count": 1, "supported_module_count": 2,
            "root_export_count": 0,
        }
        write_json(self.root / "docs/current-public-api.json", self.manifest)
        write_json(self.root / "docs/compatibility/v0.1.0-retained-contract.json", {"synthetic": True})
        for relative in release_state.PRODUCTION_INPUTS:
            path = self.root / relative
            if not path.exists():
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("# Explicit synthetic validation-input fixture.\n", encoding="utf-8")
        for name, value in {
            "SITE_SOURCE": self.site_source, "DOC_SOURCE": self.doc_source,
            "DOC_CONFIG": self.config_path, "DOC_ATTESTATION": self.attestation_path,
            "STAGE_PARENT": self.stage_parent, "STAGE_ROOT": self.stage_root,
        }.items():
            self.enterContext(patch.object(staging, name, value))
        self.enterContext(patch.object(identity, "ROOT", self.root))
        self.enterContext(patch.object(checker, "ROOT", self.root))
        self.enterContext(patch.object(current_api, "load_current_manifest", return_value=self.manifest))
        self.enterContext(patch.object(identity, "INPUTS", (
            "lakefile.toml", "docs/current-public-api.json",
            "docs/compatibility/v0.1.0-retained-contract.json", release_state.STATE_PATH,
        )))
        # The fixture substitutes only the external validated manifest/dependency
        # boundary. Its source fingerprint is recomputed from real fixture bytes.
        self.enterContext(patch.object(identity, "current_doc_identity", side_effect=self.fixture_identity))
        self.enterContext(patch.object(staging, "stage_licenses", side_effect=self.fixture_licenses))
        self.commit = self.commit_all()
        self.write_api_fixture("file")
        self.write_frozen_fixture()

    def fixture_identity(self) -> dict:
        inputs = identity.source_inputs(self.root)
        return {
            "schema": identity.IDENTITY_SCHEMA,
            "current_manifest_sha256": inputs["docs/current-public-api.json"],
            "retained_contract_sha256": inputs["docs/compatibility/v0.1.0-retained-contract.json"],
            "baseline_identity": {"synthetic_external_fixture": True},
            "release_contract": release_state.contract_identity(self.root),
            "source_content_sha256": identity.sha256(identity.encode({"inputs": inputs, "dependencies": {}})),
            "inputs": inputs, "dependencies": {},
        }

    def fixture_licenses(self, destination: Path, _config: dict) -> list[dict]:
        destination.mkdir(parents=True, exist_ok=True)
        (destination / "index.html").write_text("Synthetic licence fixture.\n", encoding="utf-8")
        return [{"name": name} for name in checker.EXPECTED_LICENSE_NAMES]

    def write_api_fixture(self, mode: str) -> None:
        for relative in checker.REQUIRED_RUNTIME:
            if relative.startswith("licenses/"):
                continue  # Licence inventory is assembled separately, as in production.
            path = self.doc_source / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("synthetic API runtime fixture\n", encoding="utf-8")
        source_link = (self.lean_source.resolve().as_uri() if mode == "file" else
                       f"{staging.REPOSITORY_URL}/blob/{self.commit}/LeanInfoTheory/Fixture.lean#L2")
        (self.doc_source / "index.html").write_text(
            '<!doctype html><html><body><h1>Welcome to the documentation page </h1>'
            f'<a href="{source_link}">source</a></body></html>\n', encoding="utf-8")
        (self.doc_source / "navbar.html").write_text('<nav class="nav"></nav>\n', encoding="utf-8")
        self.config = {
            "schema": identity.CONFIG_SCHEMA, "docgen_revision": identity.DOCGEN_REVISION,
            "lean_revision": identity.LEAN_REVISION, "mathlib_revision": identity.MATHLIB_REVISION,
            "disable_equations": True, "source_mode": mode,
            "source_identity": str(self.root.resolve()) if mode == "file" else self.commit,
            "api_identity": self.fixture_identity(),
        }
        write_json(self.config_path, self.config)
        digest, files, html_files, size = staging.tree_digest(self.doc_source)
        self.attestation = {
            "schema": identity.ATTESTATION_SCHEMA, "configuration": self.config,
            "validated_passes": 2, "relevant_output_sha256": hashlib.sha256(b"synthetic fixture").hexdigest(),
            "doc_tree_sha256": digest, "doc_files": files, "doc_html_files": html_files, "doc_bytes": size,
        }
        write_json(self.attestation_path, self.attestation)

    def write_frozen_fixture(self) -> None:
        self.frozen_root = self.base / "synthetic-historical-source"
        self.frozen_root.mkdir()
        git(self.frozen_root, "init", "--quiet")
        (self.frozen_root / ".gitignore").write_text(".lake/\n", encoding="utf-8")
        (self.frozen_root / "source.txt").write_text("Synthetic historical source.\n", encoding="utf-8")
        git(self.frozen_root, "add", "--all")
        git(self.frozen_root, "-c", "core.hooksPath=" + str(self.base / "no-hooks"),
            "commit", "--quiet", "-m", "Synthetic historical source fixture")
        self.frozen_commit = git(self.frozen_root, "rev-parse", "HEAD")
        git(self.frozen_root, "tag", "-a", "v0.1.0", "-m", "Synthetic historical fixture")
        self.frozen_tag = git(self.frozen_root, "rev-parse", "v0.1.0")
        # Substitute the immutable historical pin solely for this synthetic repo;
        # exact-commit, clean-source, metadata and route validation remain real.
        for module in (staging, checker):
            self.enterContext(patch.object(module, "VERSION_SOURCE_COMMIT", self.frozen_commit))
            self.enterContext(patch.object(module, "VERSION_TAG_OBJECT", self.frozen_tag))
        self.frozen_site = self.frozen_root / ".lake/website-stage/LeanInfoTheory"
        self.frozen_route = self.frozen_site / "docs/v0.1.0"
        self.frozen_route.mkdir(parents=True)
        for relative in checker.REQUIRED_RUNTIME:
            path = self.frozen_route / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("synthetic frozen runtime\n", encoding="utf-8")
        (self.frozen_route / "index.html").write_text(
            '<!doctype html><html><body>Immutable synthetic historical API '
            f'<a href="{staging.REPOSITORY_URL}/blob/{self.frozen_commit}/LeanInfoTheory.lean">'
            'source</a></body></html>\n', encoding="utf-8")
        (self.frozen_route / "navbar.html").write_text(
            '<a href="../">Project documentation</a>\n', encoding="utf-8")
        frozen_metadata = {
            "schema": staging.VERSION_STAGE_SCHEMA, "version": "v0.1.0", "route": "/docs/v0.1.0/",
            "mode": "release", "publishable": True, "source_mode": "github",
            "source_identity": self.frozen_commit, "supported_modules": 31,
            "supported_declarations": 601, "root_exports": 92, "excluded_modules": 13,
            "equation_rows": 0, "doc_files": 5521, "doc_html_files": 5506,
            "docgen_revision": staging.DOCGEN_REVISION, "lean_revision": staging.LEAN_REVISION,
            "mathlib_revision": staging.MATHLIB_REVISION,
            "external_runtime": list(checker.EXPECTED_EXTERNAL_RUNTIME),
            "generated_static_assets": list(checker.EXPECTED_GENERATED_STATIC_ASSETS),
            "api_doc_relevant_sha256": "a" * 64, "doc_tree_sha256": "b" * 64,
            "license_records": [{"name": name} for name in checker.EXPECTED_LICENSE_NAMES],
        }
        write_json(self.frozen_site / staging.ROOT_MARKER, frozen_metadata)
        write_json(self.frozen_route / staging.VERSION_STAGE_METADATA, frozen_metadata)

    def assemble(self) -> Path:
        site = staging.assemble_candidate(expected_commit=self.commit,
                                           frozen_source_root=self.frozen_root,
                                           frozen_site_root=self.frozen_site)
        self.assertEqual(self.validate(site).errors, [],
                         "unchanged synthetic composition must pass before mutation")
        return site

    def validate(self, site: Path | None = None) -> checker.WebsiteValidator:
        validator = checker.WebsiteValidator(site or self.stage_root, "candidate",
                                             expected_commit=self.commit,
                                             frozen_source_root=self.frozen_root,
                                             frozen_site_root=self.frozen_site)
        validator.inventory()
        validator.validate_stage_contract()
        validator.validate_links()
        return validator


class CandidateInputTests(SyntheticCandidateFixture):
    def check(self):
        return staging.validate_candidate_inputs(self.commit)

    def test_current_v2_inputs_use_real_release_state_and_content_identity(self) -> None:
        config, attestation, manifest, contract = self.check()
        self.assertEqual(config, self.config)
        self.assertEqual(attestation, self.attestation)
        self.assertEqual(manifest, self.manifest)
        self.assertEqual(contract, release_state.contract_identity(self.root))
        self.assertEqual(contract["phase"], "preparation")
        self.assertIs(contract["publishable"], False)

    def test_candidate_package_phase_is_also_explicitly_unpublished(self) -> None:
        self.state["phase"] = "candidate"
        write_json(self.root / release_state.STATE_PATH, self.state)
        (self.root / "lakefile.toml").write_text('name = "LeanInfoTheory"\nversion = "0.2.0"\n',
                                               encoding="utf-8")
        self.commit = self.commit_all()
        self.write_api_fixture("file")
        contract = self.check()[3]
        self.assertEqual(contract["package_version"], "0.2.0")
        self.assertEqual(contract["stable_version"], "0.1.0")
        self.assertIs(contract["publishable"], False)

    def test_legacy_api_configuration_is_refused(self) -> None:
        self.config["schema"] = "lean-info-theory.api-doc-build-config.v1"
        write_json(self.config_path, self.config)
        with self.assertRaises(INPUT_REFUSAL):
            self.check()

    def test_same_manifest_clean_body_and_docstring_drift_invalidates_output(self) -> None:
        manifest_before = (self.root / "docs/current-public-api.json").read_bytes()
        original = self.lean_source.read_text(encoding="utf-8")
        for replacement in (original.replace(":= 1", ":= 2"),
                            original.replace("Synthetic fixture", "Changed docstring")):
            with self.subTest(replacement=replacement):
                self.lean_source.write_text(replacement, encoding="utf-8")
                self.commit = self.commit_all()
                self.assertEqual(git(self.root, "status", "--porcelain"), "")
                self.assertEqual((self.root / "docs/current-public-api.json").read_bytes(), manifest_before)
                with self.assertRaisesRegex(INPUT_REFUSAL, "stale|source.content"):
                    self.check()

    def test_configuration_unknown_fields_pins_and_equation_policy_are_refused(self) -> None:
        for key, value in (("extra", True), ("docgen_revision", "0" * 40),
                           ("lean_revision", "0" * 40), ("mathlib_revision", "0" * 40),
                           ("disable_equations", False), ("source_identity", "other checkout")):
            with self.subTest(key=key):
                write_json(self.config_path, dict(self.config, **{key: value}))
                with self.assertRaises(INPUT_REFUSAL):
                    self.check()

    def test_duplicate_configuration_key_is_refused(self) -> None:
        raw = json.dumps(self.config)[:-1] + ', "source_mode": "file"}\n'
        self.config_path.write_text(raw, encoding="utf-8")
        with self.assertRaises(INPUT_REFUSAL):
            self.check()

    def test_attestation_requires_exact_known_schema_two_passes_and_digests(self) -> None:
        for key, value in (("schema", "lean-info-theory.api-doc-attestation.v1"),
                           ("validated_passes", 1), ("validated_passes", True),
                           ("doc_tree_sha256", "0" * 64),
                           ("relevant_output_sha256", "not-a-digest"),
                           ("doc_files", self.attestation["doc_files"] + 1),
                           ("extra", "unknown")):
            with self.subTest(key=key, value=value):
                write_json(self.attestation_path, dict(self.attestation, **{key: value}))
                with self.assertRaises(staging.StagingError):
                    self.check()

    def test_attestation_configuration_substitution_is_refused(self) -> None:
        changed = dict(self.attestation, configuration=dict(self.config, source_identity="other checkout"))
        write_json(self.attestation_path, changed)
        with self.assertRaises(staging.StagingError):
            self.check()

    def test_nested_api_contract_boolean_cannot_be_replaced_by_zero(self) -> None:
        self.check()  # The unchanged synthetic inputs pass the actual validators.
        changed = json.loads(json.dumps(self.config))
        self.assertIs(changed["api_identity"]["release_contract"]["publishable"], False)
        changed["api_identity"]["release_contract"]["publishable"] = 0
        write_json(self.config_path, changed)
        # Keep the synthetic attestation bound to the changed configuration so
        # this regression specifically tests the independent API identity check.
        attestation = json.loads(json.dumps(self.attestation))
        attestation["configuration"] = changed
        write_json(self.attestation_path, attestation)
        with self.assertRaisesRegex(INPUT_REFUSAL, "source.content identity|release contract"):
            self.check()

    def test_attestation_nested_scalar_substitution_cannot_match_valid_configuration(self) -> None:
        self.check()
        original_config = self.config_path.read_bytes()
        changed = json.loads(json.dumps(self.attestation))
        changed["configuration"]["api_identity"]["release_contract"]["publishable"] = 0
        write_json(self.attestation_path, changed)
        self.assertEqual(self.config_path.read_bytes(), original_config)
        identity.verify_configuration(self.config)
        with self.assertRaisesRegex(staging.StagingError, "attestation must bind"):
            self.check()

    def test_generated_tree_change_is_refused(self) -> None:
        with (self.doc_source / "index.html").open("a", encoding="utf-8") as stream:
            stream.write("changed synthetic rendered body\n")
        with self.assertRaisesRegex(staging.StagingError, "doc_tree_sha256|digest"):
            self.check()

    def test_github_mode_requires_the_expected_exact_commit(self) -> None:
        self.write_api_fixture("github")
        self.assertEqual(self.check()[0]["source_identity"], self.commit)
        self.config["source_identity"] = self.frozen_commit
        write_json(self.config_path, self.config)
        with self.assertRaises(INPUT_REFUSAL):
            self.check()

    def test_preparation_cannot_carry_candidate_package_version(self) -> None:
        (self.root / "lakefile.toml").write_text('name = "LeanInfoTheory"\nversion = "0.2.0"\n',
                                               encoding="utf-8")
        self.commit = self.commit_all()
        with self.assertRaises(INPUT_REFUSAL):
            self.check()


class CandidateCompositionTests(SyntheticCandidateFixture):
    def refresh_stage_fingerprints(self) -> None:
        """Model an attacker recomputing all self-reported staged fingerprints."""
        path = self.stage_root / staging.ROOT_MARKER
        metadata = json.loads(path.read_text(encoding="utf-8"))
        for prefix, relative in (("current", "docs/current"), ("version", "docs/v0.1.0")):
            route = self.stage_root / relative
            digest, files, html_files, size = staging.tree_digest(route)
            metadata.update({f"{prefix}_route_sha256": digest, f"{prefix}_route_files": files,
                             f"{prefix}_route_html_files": html_files, f"{prefix}_route_bytes": size,
                             f"{prefix}_metadata_sha256": hashlib.sha256(
                                 (route / staging.VERSION_STAGE_METADATA).read_bytes()).hexdigest()})
        write_json(path, metadata)

    def assert_rejected(self, pattern: str | None = None) -> None:
        errors = self.validate().errors
        self.assertTrue(errors, "tampered candidate was accepted")
        if pattern is not None:
            self.assertRegex("\n".join(errors), pattern)

    def test_detached_file_mode_stages_portable_current_and_unchanged_frozen_routes(self) -> None:
        before = {path.relative_to(self.frozen_route): path.read_bytes()
                  for path in self.frozen_route.rglob("*") if path.is_file()}
        git(self.root, "checkout", "--quiet", "--detach", self.commit)
        site = self.assemble()
        self.assertEqual(site, self.stage_root)
        copied = site / "docs/v0.1.0"
        self.assertEqual(before, {path.relative_to(copied): path.read_bytes()
                                  for path in copied.rglob("*") if path.is_file()})
        self.assertEqual(before, {path.relative_to(self.frozen_route): path.read_bytes()
                                  for path in self.frozen_route.rglob("*") if path.is_file()})
        for route in (site, site / "docs/current", site / "docs/v0.2.0"):
            self.assertTrue((route / staging.PREVIEW_MARKER).is_file())
        self.assertFalse((copied / staging.PREVIEW_MARKER).exists())
        for path in (site / staging.ROOT_MARKER, site / "docs/current" / staging.VERSION_STAGE_METADATA):
            raw = path.read_text(encoding="utf-8")
            self.assertIs(json.loads(raw)["publishable"], False)
            self.assertNotIn(str(self.root), raw)
            self.assertNotIn(str(self.root).replace("\\", "\\\\"), raw)
            self.assertNotIn(self.root.as_uri(), raw)
        index = (site / "docs/current/index.html").read_text(encoding="utf-8")
        self.assertIn("unpublished", index)
        self.assertNotIn("file:", index)
        self.assertNotIn("/blob/master/", (site / "docs/api-index.html").read_text(encoding="utf-8"))
        self.assertEqual(self.validate().errors, [])

    def test_github_mode_stages_exact_commit_links_but_remains_nonpublishable(self) -> None:
        self.write_api_fixture("github")
        self.assemble()
        index = (self.stage_root / "docs/current/index.html").read_text(encoding="utf-8")
        self.assertIn(f"/blob/{self.commit}/", index)
        self.assertEqual(self.validate().errors, [])
        publication = checker.WebsiteValidator(self.stage_root, "publishable")
        publication.inventory()
        publication.validate_stage_contract()
        self.assertTrue(publication.errors, "local candidate was admitted as publishable")

    def test_all_three_nonpublication_markers_are_required(self) -> None:
        self.assemble()
        for route in ("", "docs/current", "docs/v0.2.0"):
            with self.subTest(route=route):
                path = self.stage_root / route / staging.PREVIEW_MARKER
                raw = path.read_bytes()
                path.unlink()
                self.refresh_stage_fingerprints()
                self.assert_rejected("NOT_FOR_PUBLICATION|marker")
                path.write_bytes(raw)
                self.refresh_stage_fingerprints()

    def test_current_rendered_body_tamper_is_rejected_after_digest_refresh(self) -> None:
        self.assemble()
        path = self.stage_root / "docs/current/index.html"
        path.write_text(path.read_text(encoding="utf-8") + "<p>Substituted rendered theorem.</p>\n",
                        encoding="utf-8")
        self.refresh_stage_fingerprints()
        self.assert_rejected("current|render|trusted|transformed")

    def test_frozen_body_tamper_is_rejected_after_digest_refresh(self) -> None:
        self.assemble()
        path = self.stage_root / "docs/v0.1.0/index.html"
        path.write_text(path.read_text(encoding="utf-8") + "<p>Changed historical output.</p>\n",
                        encoding="utf-8")
        self.refresh_stage_fingerprints()
        self.assert_rejected("frozen|historical|version")

    def test_frozen_metadata_substitution_is_rejected_after_digest_refresh(self) -> None:
        self.assemble()
        path = self.stage_root / "docs/v0.1.0" / staging.VERSION_STAGE_METADATA
        metadata = json.loads(path.read_text(encoding="utf-8"))
        metadata["api_doc_relevant_sha256"] = "e" * 64
        write_json(path, metadata)
        self.refresh_stage_fingerprints()
        self.assert_rejected("frozen|historical|version")

    def test_current_evidence_substitution_is_rejected_after_digest_refresh(self) -> None:
        self.assemble()
        path = self.stage_root / "docs/current" / staging.VERSION_STAGE_METADATA
        metadata = json.loads(path.read_text(encoding="utf-8"))
        metadata["api_configuration_sha256"] = "e" * 64
        write_json(path, metadata)
        self.refresh_stage_fingerprints()
        self.assert_rejected("configuration|current|evidence")

    def test_current_and_frozen_route_swap_is_rejected(self) -> None:
        self.assemble()
        current = self.stage_root / "docs/current"
        frozen = self.stage_root / "docs/v0.1.0"
        temporary = self.stage_root / "docs/swap-fixture"
        current.rename(temporary)
        frozen.rename(current)
        temporary.rename(frozen)
        self.refresh_stage_fingerprints()
        self.assert_rejected()

    def test_unknown_root_and_current_metadata_fields_are_rejected(self) -> None:
        self.assemble()
        for relative in (staging.ROOT_MARKER, "docs/current/" + staging.VERSION_STAGE_METADATA):
            with self.subTest(relative=relative):
                path = self.stage_root / relative
                before = path.read_bytes()
                metadata = json.loads(before)
                metadata["unreviewed_field"] = "synthetic substitution"
                write_json(path, metadata)
                self.refresh_stage_fingerprints()
                self.assert_rejected("field|schema|metadata")
                path.write_bytes(before)
                self.refresh_stage_fingerprints()

    def test_duplicate_root_and_current_metadata_keys_are_rejected(self) -> None:
        self.assemble()
        for relative in (staging.ROOT_MARKER, "docs/current/" + staging.VERSION_STAGE_METADATA):
            with self.subTest(relative=relative):
                path = self.stage_root / relative
                before = path.read_bytes()
                raw = before.decode("utf-8").rstrip()
                path.write_text(raw[:-1] + ', "publishable": false}\n', encoding="utf-8")
                self.assert_rejected("duplicate")
                path.write_bytes(before)

    def test_publishable_flags_cannot_be_enabled(self) -> None:
        self.assemble()
        for relative in (staging.ROOT_MARKER, "docs/current/" + staging.VERSION_STAGE_METADATA):
            with self.subTest(relative=relative):
                path = self.stage_root / relative
                before = path.read_bytes()
                metadata = json.loads(before)
                metadata["publishable"] = True
                write_json(path, metadata)
                self.refresh_stage_fingerprints()
                self.assert_rejected("publishable|metadata")
                path.write_bytes(before)
                self.refresh_stage_fingerprints()

    def test_boolean_cannot_impersonate_numeric_metadata(self) -> None:
        self.assemble()
        path = self.stage_root / "docs/current" / staging.VERSION_STAGE_METADATA
        metadata = json.loads(path.read_text(encoding="utf-8"))
        self.assertEqual(metadata["equation_rows"], 0)
        metadata["equation_rows"] = False
        write_json(path, metadata)
        self.refresh_stage_fingerprints()
        self.assert_rejected("equation_rows|type|metadata")

    def test_nonobject_licence_record_is_rejected_after_digest_refresh(self) -> None:
        self.assemble()  # Includes an unchanged composed-artifact control.
        path = self.stage_root / "docs/current" / staging.VERSION_STAGE_METADATA
        metadata = json.loads(path.read_text(encoding="utf-8"))
        metadata["license_records"].append("synthetic non-object licence record")
        write_json(path, metadata)
        self.refresh_stage_fingerprints()
        self.assert_rejected("licence|license")

    def test_candidate_validator_requires_explicit_trusted_inputs(self) -> None:
        self.assemble()
        validator = checker.WebsiteValidator(self.stage_root, "candidate")
        validator.inventory()
        validator.validate_stage_contract()
        self.assertTrue(validator.errors)

    def test_wrong_expected_commit_cannot_be_hidden_by_staged_metadata(self) -> None:
        self.assemble()
        validator = checker.WebsiteValidator(self.stage_root, "candidate",
                                             expected_commit="0" * 40,
                                             frozen_source_root=self.frozen_root,
                                             frozen_site_root=self.frozen_site)
        validator.inventory()
        validator.validate_stage_contract()
        self.assertTrue(validator.errors)

    def test_reserved_route_cannot_host_an_api_page(self) -> None:
        self.assemble()
        (self.stage_root / "docs/v0.2.0/Extra.html").write_text("Release API substitution.\n", encoding="utf-8")
        self.assert_rejected("reserv")

    def test_stable_landing_cannot_be_retargeted_to_current(self) -> None:
        self.assemble()
        path = self.stage_root / "docs/index.html"
        path.write_text(path.read_text(encoding="utf-8").replace('href="v0.1.0/"', 'href="current/"'),
                        encoding="utf-8")
        self.assert_rejected("stable|landing")

    def test_unversioned_site_tamper_is_rejected_against_tracked_source(self) -> None:
        self.assemble()
        path = self.stage_root / "index.html"
        path.write_text(path.read_text(encoding="utf-8") + "<p>Untracked release claim.</p>\n",
                        encoding="utf-8")
        self.refresh_stage_fingerprints()
        self.assert_rejected("site|source|unversioned")

    def test_extra_unversioned_output_is_rejected(self) -> None:
        self.assemble()
        (self.stage_root / "unexpected.html").write_text("Unreviewed output.\n", encoding="utf-8")
        self.assert_rejected("unexpected|inventory|unversioned")

    def test_mutable_or_wrong_current_source_link_is_rejected(self) -> None:
        self.write_api_fixture("github")
        self.assemble()
        path = self.stage_root / "docs/current/index.html"
        original = path.read_text(encoding="utf-8")
        for ref in ("master", self.frozen_commit):
            with self.subTest(ref=ref):
                path.write_text(original.replace(f"/blob/{self.commit}/", f"/blob/{ref}/"), encoding="utf-8")
                self.refresh_stage_fingerprints()
                self.assert_rejected("source|current|mutable|trusted")

    def test_unsafe_frozen_source_link_refuses_assembly_before_destination_creation(self) -> None:
        path = self.frozen_route / "index.html"
        path.write_text(path.read_text(encoding="utf-8").replace(self.frozen_commit, self.commit),
                        encoding="utf-8")
        with self.assertRaisesRegex(staging.StagingError, "release|frozen"):
            self.assemble()
        self.assertFalse(self.stage_root.exists())


if __name__ == "__main__":
    unittest.main()
