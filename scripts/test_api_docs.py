#!/usr/bin/env python3
"""Focused current-doc HTML, source-identity and frozen-staging regressions.

Synthetic HTML tests exercise the maintained checker, not doc-gen execution or
Lean compilation. The final two-pass real doc-gen milestone remains separate.
--write-fixture uses the actual current source/policy/dependency identity and is
also used by isolated real-growth fixtures after their Lean build succeeds.
"""

from __future__ import annotations

import argparse
import html
import json
import sqlite3
import sys
import tempfile
import unittest
from contextlib import ExitStack, closing, redirect_stdout
from io import StringIO
from pathlib import Path
from unittest.mock import patch

import api_doc_identity as identity
import check_api_docs as checker
import current_api
import generate_website_api_index as api_index
import stage_website as staging

ROOT = Path(__file__).resolve().parents[1]


def write_synthetic_docs(build_root: Path, manifest: dict, *, configuration=None) -> None:
    """Write distinctly synthetic doc-gen-shaped output into an owned empty path.

    The caller supplies the current manifest; CLI callers use the strict loader.
    Configuration defaults to the real maintained current-source identity. Unit
    tests pass an explicit identity stub solely at this external build boundary.
    No validation attestation or claim of real doc-gen execution is fabricated.
    """
    if build_root.exists() and any(build_root.iterdir()):
        raise ValueError(f"synthetic docs fixture directory must be empty: {build_root}")
    if configuration is None:
        import validate_release
        configuration = validate_release.api_doc_build_configuration("file")
    build_root.mkdir(parents=True, exist_ok=True)
    generated = set(checker.REQUIRED_OUTPUTS)
    for relative in checker.REQUIRED_OUTPUTS:
        path = build_root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text("synthetic documentation fixture\n", encoding="utf-8", newline="\n")
    for module in manifest["supported_modules"]:
        blocks = []
        for entry in manifest["declarations"]:
            if entry["module"] != module:
                continue
            name = html.escape(entry["name"], quote=True)
            source = html.escape((ROOT / checker.module_source(module)).resolve().as_uri(), quote=True)
            attributes = '<div class="attributes">@[simp]</div>' if "simp" in entry["attributes"] else ""
            blocks.append(
                f'<div class="decl" id="{name}"><div class="{entry["kind"]}">'
                f'<div class="gh_link"><a href="{source}">source</a></div>{attributes}'
                f'<div class="decl_header">{name} : <div class="decl_type">True</div></div>'
                '<p>Synthetic nonempty declaration documentation.</p></div></div>'
            )
        relative = checker.module_page(module)
        generated.add(relative)
        path = build_root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text("<!doctype html><html><body>" + "\n".join(blocks) + "</body></html>\n",
                        encoding="utf-8", newline="\n")
    (build_root / "doc-manifest.json").write_text(json.dumps(sorted(generated)) + "\n", encoding="utf-8")
    (build_root / "api-doc-build-config.json").write_text(json.dumps(configuration) + "\n", encoding="utf-8")
    with closing(sqlite3.connect(build_root / "api-docs.db")) as connection:
        connection.execute("CREATE TABLE definition_equations (equation TEXT)")
        connection.commit()


class CurrentDocumentationTests(unittest.TestCase):
    """Synthetic HTML at the external doc-gen boundary; real checker execution."""

    def setUp(self):
        (ROOT / "tmp").mkdir(exist_ok=True)
        self.temporary = tempfile.TemporaryDirectory(prefix="c9-03-api-doc-unit-", dir=ROOT / "tmp")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.build = self.root / "build"
        self.module = "LeanInfoTheory.Shannon.UnitFixture"
        self.name = "LeanInfoTheory.Shannon.unitFixture"
        self.other = "LeanInfoTheory.Shannon.unitOther"
        self.manifest = {
            "supported_modules": ["LeanInfoTheory", self.module],
            "non_stable_modules": ["LeanInfoTheory.Examples"],
            "declarations": [
                {"name": self.name, "module": self.module, "kind": "theorem", "attributes": ["simp"]},
                {"name": self.other, "module": self.module, "kind": "def", "attributes": []},
            ],
            "root_exports": [{"alias": "LeanInfoTheory.unitFixture", "target": self.name}],
        }
        self.source = self.root / checker.module_source(self.module)
        self.source.parent.mkdir(parents=True)
        self.source.write_text("/-- Source fixture. -/\ntheorem unitFixture : True := True.intro\n", encoding="utf-8")
        self.actual_identity = {"source_content_sha256": "test identity"}
        self.config = {"schema": identity.CONFIG_SCHEMA, "source_mode": "file", "api_identity": self.actual_identity,
                       "source_identity": str(self.root.resolve()), "disable_equations": True,
                       "docgen_revision": identity.DOCGEN_REVISION, "lean_revision": identity.LEAN_REVISION,
                       "mathlib_revision": identity.MATHLIB_REVISION}
        stack = self.enterContext(ExitStack())
        for name, value in {"ROOT": self.root, "BUILD_ROOT": self.build,
                            "DOC_ROOT": self.build / "doc", "DOC_MANIFEST": self.build / "doc-manifest.json",
                            "DOC_CONFIG": self.build / "api-doc-build-config.json"}.items():
            stack.enter_context(patch.object(checker, name, value))
        stack.enter_context(patch.object(sys.modules[__name__], "ROOT", self.root))
        stack.enter_context(patch.object(current_api, "load_current_manifest", return_value=self.manifest))
        stack.enter_context(patch.object(identity, "current_doc_identity", return_value=self.actual_identity))
        stack.enter_context(patch.object(identity, "ROOT", self.root))
        stack.enter_context(patch.object(api_index, "all_declarations", return_value=[
            api_index.Declaration(entry["name"], entry["name"].rsplit(".", 1)[1], entry["kind"],
                                  self.module, checker.module_source(self.module), 2, "Source fixture.")
            for entry in self.manifest["declarations"]
        ]))
        write_synthetic_docs(self.build, self.manifest, configuration=self.config)
        self.page = self.build / checker.module_page(self.module)

    def check(self):
        with redirect_stdout(StringIO()):
            checker.check_api_docs("file")

    def mutate_page(self, before, after):
        raw = self.page.read_text(encoding="utf-8")
        self.assertIn(before, raw)
        self.page.write_text(raw.replace(before, after, 1), encoding="utf-8")

    def test_exact_current_coverage_has_no_historical_count_floor(self):
        self.check()

    def test_missing_declaration_block(self):
        self.mutate_page(f'id="{self.name}"', 'id="unexpected"')
        with self.assertRaisesRegex(checker.DocumentationError, "coverage differs"):
            self.check()

    def test_duplicate_declaration_block(self):
        self.mutate_page(f'id="{self.other}"', f'id="{self.name}"')
        self.manifest["declarations"] = self.manifest["declarations"][:1]
        with self.assertRaisesRegex(checker.DocumentationError, "expected one generated block"):
            self.check()

    def test_unindexed_extra_declaration(self):
        self.manifest["declarations"] = self.manifest["declarations"][:1]
        with self.assertRaisesRegex(checker.DocumentationError, "coverage differs"):
            self.check()

    def test_wrong_owner_block(self):
        self.manifest["declarations"][0]["module"] = "LeanInfoTheory"
        with self.assertRaisesRegex(checker.DocumentationError, "coverage differs"):
            self.check()

    def test_empty_signature(self):
        self.mutate_page('<div class="decl_type">True</div>', '<div class="decl_type"> </div>')
        with self.assertRaisesRegex(checker.DocumentationError, "type is empty"):
            self.check()

    def test_empty_docstring_does_not_count_header_or_instance_boilerplate(self):
        self.mutate_page('<p>Synthetic nonempty declaration documentation.</p>',
                         '<details><summary>Instances For</summary></details>')
        with self.assertRaisesRegex(checker.DocumentationError, "docstring is empty"):
            self.check()

    def test_missing_reviewed_simp(self):
        self.mutate_page('@[simp]', '@[other]')
        with self.assertRaisesRegex(checker.DocumentationError, "simp membership"):
            self.check()

    def test_unexpected_simp(self):
        self.manifest["declarations"][0]["attributes"] = []
        with self.assertRaisesRegex(checker.DocumentationError, "simp membership"):
            self.check()

    def test_sorry_marker(self):
        self.mutate_page('class="decl"', 'class="decl sorried"')
        with self.assertRaisesRegex(checker.DocumentationError, "sorried"):
            self.check()

    def test_wrong_source_link(self):
        self.mutate_page(self.source.resolve().as_uri(), (self.root / "wrong.lean").as_uri())
        with self.assertRaisesRegex(checker.DocumentationError, "source link"):
            self.check()

    def test_non_stable_page_leak(self):
        leaked = self.build / "doc/LeanInfoTheory/Examples.html"
        leaked.write_text("unexpected", encoding="utf-8")
        with self.assertRaisesRegex(checker.DocumentationError, "stale or missing local module pages"):
            self.check()

    def test_equations_must_remain_disabled(self):
        with closing(sqlite3.connect(self.build / "api-docs.db")) as connection:
            connection.execute("INSERT INTO definition_equations VALUES ('unexpected')")
            connection.commit()
        with self.assertRaisesRegex(checker.DocumentationError, "equation rows"):
            self.check()

    def test_stale_same_path_identity_refused(self):
        with patch.object(identity, "current_doc_identity", return_value={"source_content_sha256": "changed"}):
            with self.assertRaisesRegex(ValueError, "source-content identity is stale"):
                self.check()

    def test_legacy_config_cannot_validate_current_docs(self):
        self.config["schema"] = "lean-info-theory.api-doc-build-config.v1"
        (self.build / "api-doc-build-config.json").write_text(json.dumps(self.config), encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "v2 build configuration"):
            self.check()

    def test_changed_pin_equation_policy_or_source_path_is_refused(self):
        for key, value, message in (
            ("docgen_revision", "0" * 40, "unexpected docgen_revision"),
            ("disable_equations", False, "must disable equations"),
            ("source_identity", "same contents elsewhere", "source identity differs"),
        ):
            with self.subTest(key=key):
                changed = dict(self.config, **{key: value})
                (self.build / "api-doc-build-config.json").write_text(json.dumps(changed), encoding="utf-8")
                with self.assertRaisesRegex(ValueError, message):
                    self.check()

    def test_duplicate_config_key_is_refused(self):
        raw = json.dumps(self.config)[:-1] + ', "source_mode": "file"}'
        (self.build / "api-doc-build-config.json").write_text(raw, encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "duplicate JSON key"):
            self.check()

    def test_dirty_github_config_is_refused(self):
        self.config.update(source_mode="github", source_identity="a" * 40)
        (self.build / "api-doc-build-config.json").write_text(json.dumps(self.config), encoding="utf-8")
        with patch.object(identity, "git_output", side_effect=["a" * 40, " M source.lean"]):
            with self.assertRaisesRegex(ValueError, "exact clean current source"):
                checker.check_api_docs("github")


class ContentIdentityTests(unittest.TestCase):
    def test_same_manifest_signature_body_docstring_and_input_changes_invalidate(self):
        (ROOT / "tmp").mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(prefix="c9-03-doc-fingerprint-", dir=ROOT / "tmp") as raw:
            root = Path(raw)
            owner = root / "LeanInfoTheory/Owner.lean"
            owner.parent.mkdir()
            (root / "LeanInfoTheory.lean").write_text("import LeanInfoTheory.Owner\n", encoding="utf-8")
            (root / "manifest.json").write_bytes(b'{"names":["constant"]}\n')
            (root / "checker.py").write_bytes(b'original checker\n')
            original = b'/-- Original docstring. -/\ndef constant : Nat := 1\n'
            owner.write_bytes(original)
            with patch.object(identity, "INPUTS", ("manifest.json", "checker.py")):
                before = identity.source_inputs(root)
                self.assertEqual(before, identity.source_inputs(root))
                for changed in (original.replace(b": Nat", b": Int"),
                                original.replace(b":= 1", b":= 2"),
                                original.replace(b"Original docstring", b"Changed docstring")):
                    owner.write_bytes(changed)
                    after = identity.source_inputs(root)
                    self.assertEqual(before["manifest.json"], after["manifest.json"])
                    self.assertNotEqual(before, after)
                owner.write_bytes(original)
                (root / "checker.py").write_bytes(b'changed checker\n')
                self.assertNotEqual(before, identity.source_inputs(root))
                (root / "checker.py").write_bytes(b'original checker\n')
                added = owner.with_name("Added.lean")
                added.write_bytes(b'-- additional local source\n')
                self.assertNotEqual(before, identity.source_inputs(root))
                added.unlink()
                self.assertEqual(before, identity.source_inputs(root))

    def test_dependency_revision_and_dirty_source_are_refused(self):
        lock = {"packages": [{"type": "path", "name": "LeanInfoTheory", "dir": "../"},
                             {"type": "git", "name": "«doc-gen4»", "rev": "a" * 40}]}
        raw = json.dumps(lock).encode("utf-8")
        with patch.object(Path, "read_bytes", return_value=raw), \
                patch.object(identity, "DOCBUILD_LOCK_SHA256", identity.sha256(raw)):
            with patch.object(identity, "git_output", side_effect=["a" * 40, ""]) as git:
                self.assertEqual(identity.dependency_identity(), {"«doc-gen4»": "a" * 40})
                self.assertEqual(git.call_args_list[0].args[0].name, "doc-gen4")
            with patch.object(identity, "git_output", return_value="b" * 40):
                with self.assertRaisesRegex(ValueError, "revision or source differs"):
                    identity.dependency_identity()
            with patch.object(identity, "git_output", side_effect=["a" * 40, " M source.lean"]):
                with self.assertRaisesRegex(ValueError, "revision or source differs"):
                    identity.dependency_identity()


class HistoricalPreviewTests(unittest.TestCase):
    """All refusals are tested through assembly before any copy or destination write."""

    def setUp(self):
        (ROOT / "tmp").mkdir(exist_ok=True)
        self.temporary = tempfile.TemporaryDirectory(prefix="c9-03-preview-unit-", dir=ROOT / "tmp")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.site = self.root / "home_page"
        self.doc = self.root / "docbuild/.lake/build/doc"
        self.site.mkdir()
        self.doc.mkdir(parents=True)
        self.config = {
            "schema": "lean-info-theory.api-doc-build-config.v1",
            "docgen_revision": staging.DOCGEN_REVISION, "lean_revision": staging.LEAN_REVISION,
            "mathlib_revision": staging.MATHLIB_REVISION, "disable_equations": True,
            "source_mode": "file", "source_identity": str(self.root.resolve()),
        }
        self.config_path = self.doc.parent / "api-doc-build-config.json"
        self.config_path.write_text(json.dumps(self.config), encoding="utf-8")
        for name, value in {"ROOT": self.root, "SITE_SOURCE": self.site, "DOC_SOURCE": self.doc,
                            "DOC_CONFIG": self.config_path}.items():
            self.enterContext(patch.object(staging, name, value))
        self.copytree = self.enterContext(patch.object(staging.shutil, "copytree"))
        self.copydocs = self.enterContext(patch.object(staging, "copy_doc_tree"))
        self.destination = self.enterContext(patch.object(staging, "validate_owned_destination"))

    def assert_refused(self, message):
        with self.assertRaisesRegex(staging.StagingError, message):
            staging.assemble_standard("preview")
        self.copytree.assert_not_called()
        self.copydocs.assert_not_called()
        self.destination.assert_not_called()

    def test_current_v2_refused_before_copy_even_at_historical_counts(self):
        self.config["schema"] = identity.CONFIG_SCHEMA
        self.config_path.write_text(json.dumps(self.config), encoding="utf-8")
        self.assert_refused("current API documentation cannot be staged")

    def test_same_count_changed_source_cannot_use_legacy_preview(self):
        with patch.object(staging, "require_clean_checkout"), \
                patch.object(staging, "exact_commit", return_value="1" * 40):
            self.assert_refused("exact immutable v0.1.0")

    def test_dirty_historical_source_refused_before_copy(self):
        with patch.object(staging, "require_clean_checkout", side_effect=staging.StagingError("dirty source")):
            self.assert_refused("dirty source")

    def test_legacy_identity_must_match_historical_checkout(self):
        self.config["source_identity"] = "another checkout"
        self.config_path.write_text(json.dumps(self.config), encoding="utf-8")
        with patch.object(staging, "require_clean_checkout"), \
                patch.object(staging, "exact_commit", return_value=staging.VERSION_SOURCE_COMMIT):
            self.assert_refused("source identity does not match")

    def test_exact_clean_historical_preview_preserves_legacy_attestation_validation(self):
        with patch.object(staging, "require_clean_checkout"), \
                patch.object(staging, "exact_commit", return_value=staging.VERSION_SOURCE_COMMIT), \
                patch.object(staging, "validate_attestation", return_value={"historical": True}) as attest:
            result = staging.validate_inputs("preview")
            self.assertEqual(result, (self.config, None, {"historical": True}))
            attest.assert_called_once()


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    if "--write-fixture" in sys.argv:
        parser = argparse.ArgumentParser(description="Write synthetic HTML; this does not run doc-gen or attest a build.")
        parser.add_argument("--write-fixture", type=Path, required=True)
        args = parser.parse_args()
        write_synthetic_docs(args.write_fixture.resolve(), current_api.load_current_manifest())
        print(f"wrote synthetic current-source HTML fixture (not doc-gen evidence): {args.write_fixture.resolve()}")
    else:
        unittest.main()
