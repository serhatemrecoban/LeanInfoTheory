#!/usr/bin/env python3
"""Regression tests for release-website validation."""

from __future__ import annotations

import hashlib
import json
import os
import shutil
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from check_website import (
    COMPOSITION_STAGE_SCHEMA,
    CURATED_ROW_RE,
    CURATED_SOURCE_RE,
    EXPECTED_EXTERNAL_RUNTIME,
    EXPECTED_GENERATED_STATIC_ASSETS,
    EXPECTED_LICENSE_NAMES,
    EXPECTED_CURATED_DECLARATION_COUNT,
    REQUIRED_RUNTIME,
    VERSION_STAGE_SCHEMA,
    VERSION_TAG_OBJECT,
    VERSION_SOURCE_COMMIT,
    WebsiteValidator,
    tree_digest,
)
from stage_website import (
    StagingError,
    project_blob_links as staging_project_blob_links,
    require_unredirected_components,
    require_unredirected_tree,
    rewrite_current_site_source_refs,
    validate_current_maintenance_checkout,
)


ROOT = Path(__file__).resolve().parents[1]
SITE_ROOT = ROOT / "home_page"


class CuratedTheoremLinkTests(unittest.TestCase):
    def test_checked_in_catalogue_matches_declaration_index(self) -> None:
        validator = WebsiteValidator(SITE_ROOT, "source")
        validator.run()
        self.assertEqual(validator.errors, [])
        self.assertEqual(
            validator.curated_declaration_count, EXPECTED_CURATED_DECLARATION_COUNT
        )

    def test_wrong_source_line_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-website-test-") as raw:
            copied_site = Path(raw) / "home_page"
            shutil.copytree(SITE_ROOT, copied_site)
            baseline = WebsiteValidator(copied_site, "source")
            baseline.run()
            self.assertEqual(baseline.errors, [])
            baseline_count = baseline.curated_declaration_count
            theorem_path = copied_site / "theorems.html"
            source = theorem_path.read_text(encoding="utf-8")
            match = CURATED_SOURCE_RE.search(source)
            self.assertIsNotNone(match)
            assert match is not None
            line_start, line_end = match.span("line")
            wrong_line = str(int(match.group("line")) + 1)
            mutated = source[:line_start] + wrong_line + source[line_end:]
            theorem_path.write_text(mutated, encoding="utf-8", newline="\n")

            validator = WebsiteValidator(copied_site, "source")
            validator.run()
            self.assertTrue(
                any("source location" in error for error in validator.errors),
                msg="a deliberately stale curated source line was not rejected",
            )
            self.assertEqual(
                validator.curated_declaration_count,
                baseline_count - 1,
                msg="the mutation should invalidate exactly one curated row",
            )

    def test_commented_out_row_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-website-test-") as raw:
            copied_site = Path(raw) / "home_page"
            shutil.copytree(SITE_ROOT, copied_site)
            theorem_path = copied_site / "theorems.html"
            source = theorem_path.read_text(encoding="utf-8")
            table_start = source.index("<tbody>")
            match = CURATED_ROW_RE.search(source, table_start)
            self.assertIsNotNone(match)
            assert match is not None
            row_start, row_end = match.span()
            mutated = (
                source[:row_start]
                + "<!--"
                + source[row_start:row_end]
                + "-->"
                + source[row_end:]
            )
            theorem_path.write_text(mutated, encoding="utf-8", newline="\n")

            validator = WebsiteValidator(copied_site, "source")
            validator.run()
            self.assertTrue(
                any(
                    "expected 28 curated rows, found 27" in error
                    for error in validator.errors
                ),
                msg="a commented-out curated row was not rejected",
            )
            self.assertEqual(
                validator.curated_declaration_count,
                EXPECTED_CURATED_DECLARATION_COUNT - 1,
            )

    def test_duplicate_href_cannot_hide_a_wrong_browser_target(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-website-test-") as raw:
            copied_site = Path(raw) / "home_page"
            shutil.copytree(SITE_ROOT, copied_site)
            theorem_path = copied_site / "theorems.html"
            source = theorem_path.read_text(encoding="utf-8")
            match = CURATED_SOURCE_RE.search(source)
            self.assertIsNotNone(match)
            assert match is not None
            expected_target = match.group(0)
            wrong_target = (
                expected_target[: match.start("line") - match.start()]
                + str(int(match.group("line")) + 1)
                + expected_target[match.end("line") - match.start() :]
            )
            quoted_href = f'href="{expected_target}"'
            self.assertIn(quoted_href, source)
            mutated = source.replace(
                quoted_href, f"href={wrong_target} {quoted_href}", 1
            )
            theorem_path.write_text(mutated, encoding="utf-8", newline="\n")

            validator = WebsiteValidator(copied_site, "source")
            validator.run()
            self.assertTrue(
                any(
                    "anchor has 2 href attributes" in error
                    for error in validator.errors
                ),
                msg="duplicate href attributes were not rejected",
            )

    def test_double_encoded_display_text_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-website-test-") as raw:
            copied_site = Path(raw) / "home_page"
            shutil.copytree(SITE_ROOT, copied_site)
            theorem_path = copied_site / "theorems.html"
            source = theorem_path.read_text(encoding="utf-8")
            expected_display = "Shannon.entropy_nonneg"
            self.assertIn(expected_display, source)
            mutated = source.replace(
                expected_display, "Shannon&amp;period;entropy_nonneg", 1
            )
            theorem_path.write_text(mutated, encoding="utf-8", newline="\n")

            validator = WebsiteValidator(copied_site, "source")
            validator.run()
            self.assertTrue(
                any(
                    "displays" in error and "&period;" in error
                    for error in validator.errors
                ),
                msg="double-encoded display text was not rejected",
            )

    def test_raw_text_container_cannot_hide_a_source_link(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-website-test-") as raw:
            copied_site = Path(raw) / "home_page"
            shutil.copytree(SITE_ROOT, copied_site)
            theorem_path = copied_site / "theorems.html"
            source = theorem_path.read_text(encoding="utf-8")
            match = CURATED_SOURCE_RE.search(source)
            self.assertIsNotNone(match)
            assert match is not None
            source_anchor = f'<a href="{match.group(0)}">source</a>'
            self.assertIn(source_anchor, source)
            mutated = source.replace(
                source_anchor, f"<textarea>{source_anchor}</textarea>", 1
            )
            theorem_path.write_text(mutated, encoding="utf-8", newline="\n")

            validator = WebsiteValidator(copied_site, "source")
            validator.run()
            self.assertTrue(
                any("unexpected start tag 'textarea'" in error for error in validator.errors),
                msg="a source link hidden in a raw-text container was not rejected",
            )

    def test_raw_text_container_cannot_hide_the_entire_table(self) -> None:
        wrappers = (
            ('<script type="text/plain">', "</script>"),
            ("<title>", "</title>"),
            ("<select>", "</select>"),
        )
        for opening, closing in wrappers:
            with self.subTest(wrapper=opening):
                with tempfile.TemporaryDirectory(
                    prefix="leaninfotheory-website-test-"
                ) as raw:
                    copied_site = Path(raw) / "home_page"
                    shutil.copytree(SITE_ROOT, copied_site)
                    theorem_path = copied_site / "theorems.html"
                    source = theorem_path.read_text(encoding="utf-8")
                    table_start = source.index('<table class="status-table">')
                    table_end = source.index("</table>", table_start) + len(
                        "</table>"
                    )
                    mutated = (
                        source[:table_start]
                        + opening
                        + source[table_start:table_end]
                        + closing
                        + source[table_end:]
                    )
                    theorem_path.write_text(
                        mutated, encoding="utf-8", newline="\n"
                    )

                    validator = WebsiteValidator(copied_site, "source")
                    validator.run()
                    self.assertNotEqual(
                        validator.errors,
                        [],
                        msg=f"a theorem table hidden by {opening!r} was not rejected",
                    )
                    self.assertEqual(validator.curated_declaration_count, 0)

    def test_hidden_table_structure_is_rejected(self) -> None:
        mutations = (
            ("<tbody>", "<tbody hidden>"),
            ("          <tr>\n            <td><code>H(P)",
             "          <tr hidden>\n            <td><code>H(P)"),
            ("<td><a href=", "<td hidden><a href="),
        )
        for original, replacement in mutations:
            with self.subTest(replacement=replacement):
                with tempfile.TemporaryDirectory(
                    prefix="leaninfotheory-website-test-"
                ) as raw:
                    copied_site = Path(raw) / "home_page"
                    shutil.copytree(SITE_ROOT, copied_site)
                    theorem_path = copied_site / "theorems.html"
                    source = theorem_path.read_text(encoding="utf-8")
                    self.assertIn(original, source)
                    mutated = source.replace(original, replacement, 1)
                    theorem_path.write_text(
                        mutated, encoding="utf-8", newline="\n"
                    )

                    validator = WebsiteValidator(copied_site, "source")
                    validator.run()
                    self.assertTrue(
                        any("unexpected attributes" in error
                            for error in validator.errors),
                        msg=f"hidden table structure {replacement!r} was not rejected",
                    )

    def test_nonvoid_self_closing_wrapper_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-website-test-") as raw:
            copied_site = Path(raw) / "home_page"
            shutil.copytree(SITE_ROOT, copied_site)
            theorem_path = copied_site / "theorems.html"
            source = theorem_path.read_text(encoding="utf-8")
            table_start = source.index('<table class="status-table">')
            mutated = source[:table_start] + "<div hidden/>" + source[table_start:]
            theorem_path.write_text(mutated, encoding="utf-8", newline="\n")

            validator = WebsiteValidator(copied_site, "source")
            validator.run()
            self.assertTrue(
                any("non-void HTML element 'div' uses self-closing syntax" in error
                    for error in validator.errors),
                msg="a non-void self-closing wrapper was not rejected",
            )

    def test_nested_table_cannot_impersonate_the_curated_table(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-website-test-") as raw:
            copied_site = Path(raw) / "home_page"
            shutil.copytree(SITE_ROOT, copied_site)
            theorem_path = copied_site / "theorems.html"
            source = theorem_path.read_text(encoding="utf-8")
            outer_start = source.index('<table class="status-table">')
            content_start = outer_start + len('<table class="status-table">')
            outer_end = source.index("</table>", content_start)
            mutated = (
                source[:content_start]
                + "<table>"
                + source[content_start:outer_end]
                + "</table>"
                + source[outer_end:]
            )
            theorem_path.write_text(mutated, encoding="utf-8", newline="\n")

            validator = WebsiteValidator(copied_site, "source")
            validator.run()
            self.assertTrue(
                any("nested table inside status-table" in error
                    for error in validator.errors),
                msg="a nested table was allowed to impersonate the curated table",
            )


class VersionedWebsiteBoundaryTests(unittest.TestCase):
    SITE_COMMIT = "1" * 40

    def validator(self) -> WebsiteValidator:
        validator = WebsiteValidator(SITE_ROOT, "publishable")
        validator.metadata = {
            "schema": COMPOSITION_STAGE_SCHEMA,
            "site_source_identity": self.SITE_COMMIT,
            "api_source_identity": VERSION_SOURCE_COMMIT,
        }
        return validator

    def test_versioned_route_accepts_only_the_release_commit(self) -> None:
        validator = self.validator()
        validator.validate_text_safety(
            "docs/v0.1.0/LeanInfoTheory/Shannon/Entropy.html",
            "https://github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/LeanInfoTheory/Shannon/Entropy.lean#L45-L47",
        )
        self.assertEqual(validator.errors, [])

        validator.validate_text_safety(
            "docs/v0.1.0/LeanInfoTheory/Shannon/Entropy.html",
            "https://github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{self.SITE_COMMIT}/LeanInfoTheory/Shannon/Entropy.lean#L45-L47",
        )
        self.assertTrue(
            any(VERSION_SOURCE_COMMIT in error for error in validator.errors),
            msg="an advanced site commit rebound the frozen v0.1.0 route",
        )

    def test_case_and_entity_encoded_version_link_cannot_bypass_freeze(self) -> None:
        encoded_url = (
            "https://GITHUB&#46;COM/serhatemrecoban/LeanInfoTheory/blob/"
            f"{self.SITE_COMMIT}/LeanInfoTheory%2FShannon%2FEntropy%2Elean#L45"
        )
        validator = self.validator()
        validator.validate_text_safety(
            "docs/v0.1.0/LeanInfoTheory/Shannon/Entropy.html",
            encoded_url,
        )
        self.assertTrue(
            any(VERSION_SOURCE_COMMIT in error for error in validator.errors),
            msg="an encoded project URL bypassed the frozen-route source identity",
        )
        self.assertEqual(
            list(staging_project_blob_links(encoded_url)),
            [
                (
                    self.SITE_COMMIT,
                    "LeanInfoTheory/Shannon/Entropy.lean",
                )
            ],
            msg="the staging guard did not normalize the same encoded project URL",
        )

    def test_traversal_spellings_cannot_escape_the_frozen_ref(self) -> None:
        wrong_commit = self.SITE_COMMIT
        attacks = (
            "https://github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/../{wrong_commit}/LeanInfoTheory.lean",
            "https://github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/%2e%2e/{wrong_commit}/LeanInfoTheory.lean",
            "https://github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/safe%5c..%5c..%5c{wrong_commit}%5cLeanInfoTheory.lean",
            "https://github.com./serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/LeanInfoTheory.lean",
            "http://github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/LeanInfoTheory.lean",
            "https:\\github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/LeanInfoTheory.lean",
            "https:/\\github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/LeanInfoTheory.lean",
            "https:/github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/LeanInfoTheory.lean",
            "https:///github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/LeanInfoTheory.lean",
            "https:github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/LeanInfoTheory.lean",
            "https://github。com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/LeanInfoTheory.lean",
            "https://ｇｉｔｈｕｂ．ｃｏｍ/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/LeanInfoTheory.lean",
        )
        for attack in attacks:
            with self.subTest(attack=attack):
                validator = self.validator()
                validator.validate_text_safety(
                    "docs/v0.1.0/LeanInfoTheory.html",
                    attack,
                )
                self.assertTrue(
                    any("unsafe GitHub URL" in error for error in validator.errors),
                    msg="a browser-normalized traversal spelling bypassed validation",
                )
                with self.assertRaises(ValueError):
                    list(staging_project_blob_links(attack))

    def test_browser_normalized_host_spellings_remain_enforced(self) -> None:
        spellings = (
            "https://git&#x09;hub.com/serhatemrecoban/LeanInfoTheory/blob/",
            "https://%67ithub%2ecom/serhatemrecoban/LeanInfoTheory/blob/",
        )
        for prefix in spellings:
            with self.subTest(prefix=prefix):
                url = (
                    prefix
                    + self.SITE_COMMIT
                    + "/LeanInfoTheory/Shannon/Entropy.lean#L45"
                )
                source = f'<a href="{url}">source</a>'
                validator = self.validator()
                validator.validate_text_safety(
                    "docs/v0.1.0/LeanInfoTheory/Shannon/Entropy.html",
                    source,
                )
                self.assertTrue(
                    any(VERSION_SOURCE_COMMIT in error for error in validator.errors),
                    msg="a browser-normalized GitHub host bypassed frozen-ref enforcement",
                )
                self.assertEqual(
                    list(staging_project_blob_links(source)),
                    [
                        (
                            self.SITE_COMMIT,
                            "LeanInfoTheory/Shannon/Entropy.lean",
                        )
                    ],
                )

    def test_protocol_relative_project_urls_are_rejected(self) -> None:
        targets = (
            "//github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{self.SITE_COMMIT}/LeanInfoTheory.lean",
            "///github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{self.SITE_COMMIT}/LeanInfoTheory.lean",
            "\\\\github.com\\serhatemrecoban\\LeanInfoTheory\\blob\\"
            f"{self.SITE_COMMIT}\\LeanInfoTheory.lean",
        )
        for target in targets:
            with self.subTest(target=target):
                source = f'<a href="{target}">source</a>'
                validator = self.validator()
                validator.validate_text_safety(
                    "docs/v0.1.0/LeanInfoTheory.html",
                    source,
                )
                self.assertTrue(any("unsafe GitHub URL" in error for error in validator.errors))
                with self.assertRaises(ValueError):
                    list(staging_project_blob_links(source))

        unquoted = (
            "<a href=//github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{self.SITE_COMMIT}/LeanInfoTheory.lean>source</a>"
        )
        validator = self.validator()
        validator.validate_text_safety("docs/v0.1.0/LeanInfoTheory.html", unquoted)
        self.assertTrue(any("unsafe GitHub URL" in error for error in validator.errors))
        with self.assertRaises(ValueError):
            list(staging_project_blob_links(unquoted))

    def test_current_lean_links_follow_the_site_commit(self) -> None:
        validator = self.validator()
        validator.validate_text_safety(
            "theorems.html",
            "https://github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{self.SITE_COMMIT}/LeanInfoTheory/Shannon/Entropy.lean#L45",
        )
        self.assertEqual(validator.errors, [])

        validator.validate_text_safety(
            "theorems.html",
            "https://github.com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/LeanInfoTheory/Shannon/Entropy.lean#L45",
        )
        self.assertTrue(
            any(self.SITE_COMMIT in error for error in validator.errors),
            msg="the current theorem catalogue retained a stale release source ref",
        )

    def test_encoded_current_lean_path_cannot_retain_the_release_ref(self) -> None:
        validator = self.validator()
        validator.validate_text_safety(
            "theorems.html",
            "https://github&#46;com/serhatemrecoban/LeanInfoTheory/blob/"
            f"{VERSION_SOURCE_COMMIT}/LeanInfoTheory%2FShannon%2FEntropy%2Elean#L45",
        )
        self.assertTrue(
            any(self.SITE_COMMIT in error for error in validator.errors),
            msg="an encoded Lean path bypassed the current-site source identity",
        )

    def test_stable_release_metadata_link_remains_tagged(self) -> None:
        validator = self.validator()
        validator.validate_text_safety(
            "license.html",
            "https://github.com/serhatemrecoban/LeanInfoTheory/blob/"
            "v0.1.0/CITATION.cff",
        )
        self.assertEqual(validator.errors, [])

    def test_mutable_project_link_is_rejected_everywhere(self) -> None:
        validator = self.validator()
        validator.validate_text_safety(
            "license.html",
            "https://github.com/serhatemrecoban/LeanInfoTheory/blob/master/README.md",
        )
        self.assertTrue(any("mutable GitHub" in error for error in validator.errors))

        encoded = self.validator()
        encoded.validate_text_safety(
            "license.html",
            "https://GITHUB&#46;COM/serhatemrecoban/LeanInfoTheory/blob/"
            "m%61ster/README.md",
        )
        self.assertTrue(any("mutable GitHub" in error for error in encoded.errors))

    def test_curated_links_use_current_site_identity(self) -> None:
        validator = self.validator()
        self.assertEqual(validator.curated_source_ref(), self.SITE_COMMIT)

    def test_current_source_rewrite_excludes_versioned_and_release_metadata(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-stage-test-") as raw:
            site = Path(raw) / "site"
            version = site / "docs" / "v0.1.0"
            version.mkdir(parents=True)
            lean_url = (
                "https://github.com/serhatemrecoban/LeanInfoTheory/blob/"
                "v0.1.0/LeanInfoTheory/Shannon/Entropy.lean#L45"
            )
            (site / "theorems.html").write_text(lean_url, encoding="utf-8")
            (site / "license.html").write_text(
                "https://github.com/serhatemrecoban/LeanInfoTheory/blob/"
                "v0.1.0/CITATION.cff",
                encoding="utf-8",
            )
            (version / "index.html").write_text(lean_url, encoding="utf-8")

            changed = rewrite_current_site_source_refs(site, self.SITE_COMMIT)
            self.assertEqual(changed, 1)
            self.assertIn(
                f"/blob/{self.SITE_COMMIT}/",
                (site / "theorems.html").read_text(encoding="utf-8"),
            )
            self.assertIn(
                "/blob/v0.1.0/CITATION.cff",
                (site / "license.html").read_text(encoding="utf-8"),
            )
            self.assertEqual(
                (version / "index.html").read_text(encoding="utf-8"), lean_url
            )

    def test_version_route_digest_detects_mutation(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-digest-test-") as raw:
            root = Path(raw)
            page = root / "index.html"
            page.write_text("release", encoding="utf-8")
            before = tree_digest(root)
            page.write_text("changed", encoding="utf-8")
            after = tree_digest(root)
            self.assertNotEqual(before, after)

    def make_composed_site(self, parent: Path) -> Path:
        site = parent / "site"
        version = site / "docs" / "v0.1.0"
        version.mkdir(parents=True)
        for relative in REQUIRED_RUNTIME:
            path = version / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            content = (
                '<a href="../">Project documentation</a>'
                if relative == "navbar.html"
                else "release fixture\n"
            )
            path.write_text(content, encoding="utf-8", newline="\n")

        version_metadata = {
            "schema": VERSION_STAGE_SCHEMA,
            "version": "v0.1.0",
            "route": "/docs/v0.1.0/",
            "mode": "release",
            "publishable": True,
            "source_mode": "github",
            "source_identity": VERSION_SOURCE_COMMIT,
            "supported_modules": 31,
            "supported_declarations": 601,
            "root_exports": 92,
            "excluded_modules": 13,
            "equation_rows": 0,
            "doc_files": 5521,
            "doc_html_files": 5506,
            "docgen_revision": "e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015",
            "lean_revision": "819816b2e0a3bf405af45ae5c7af2491d8f5bee6",
            "mathlib_revision": "0df444a360eaa60ab8c11dca51a86af692955474",
            "external_runtime": list(EXPECTED_EXTERNAL_RUNTIME),
            "generated_static_assets": list(EXPECTED_GENERATED_STATIC_ASSETS),
            "api_doc_relevant_sha256": "a" * 64,
            "doc_tree_sha256": "b" * 64,
            "license_records": [{"name": name} for name in EXPECTED_LICENSE_NAMES],
        }
        version_metadata_path = version / "leaninfotheory-stage.json"
        version_metadata_path.write_text(
            json.dumps(version_metadata, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
            newline="\n",
        )
        digest, files, html_files, byte_count = tree_digest(version)
        version_metadata_bytes = version_metadata_path.read_bytes()
        root_metadata = {
            "schema": COMPOSITION_STAGE_SCHEMA,
            "version": "v0.1.0",
            "route": "/docs/v0.1.0/",
            "mode": "maintenance",
            "publishable": True,
            "site_policy": "current-master",
            "site_source_identity": self.SITE_COMMIT,
            "api_policy": "immutable-version",
            "api_source_identity": VERSION_SOURCE_COMMIT,
            "release_tag": "v0.1.0",
            "release_tag_object": VERSION_TAG_OBJECT,
            "version_metadata_schema": VERSION_STAGE_SCHEMA,
            "version_metadata_sha256": hashlib.sha256(version_metadata_bytes).hexdigest(),
            "version_route_sha256": digest,
            "version_route_files": files,
            "version_route_html_files": html_files,
            "version_route_bytes": byte_count,
            "version_project_source_links": 1,
            "rewritten_current_site_source_links": 1,
        }
        (site / "website-stage.json").write_text(
            json.dumps(root_metadata, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
            newline="\n",
        )
        return site

    @staticmethod
    def refresh_composition_fingerprints(site: Path) -> None:
        version = site / "docs" / "v0.1.0"
        metadata_path = version / "leaninfotheory-stage.json"
        root_path = site / "website-stage.json"
        root_metadata = json.loads(root_path.read_text(encoding="utf-8"))
        root_metadata["version_metadata_sha256"] = hashlib.sha256(
            metadata_path.read_bytes()
        ).hexdigest()
        digest, files, html_files, byte_count = tree_digest(version)
        root_metadata.update(
            {
                "version_route_sha256": digest,
                "version_route_files": files,
                "version_route_html_files": html_files,
                "version_route_bytes": byte_count,
            }
        )
        root_path.write_text(
            json.dumps(root_metadata, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
            newline="\n",
        )

    def validate_composed_contract(self, site: Path) -> WebsiteValidator:
        validator = WebsiteValidator(site, "publishable")
        validator.inventory()
        with patch("check_website.git_head", return_value=self.SITE_COMMIT):
            validator.validate_stage_contract()
        return validator

    def test_composed_contract_accepts_consistent_v2_metadata(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-v2-test-") as raw:
            site = self.make_composed_site(Path(raw))
            validator = self.validate_composed_contract(site)
            self.assertEqual(validator.errors, [])

    def test_composed_contract_rejects_route_mutation(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-v2-test-") as raw:
            site = self.make_composed_site(Path(raw))
            page = site / "docs" / "v0.1.0" / "index.html"
            page.write_text("mutated\n", encoding="utf-8", newline="\n")
            validator = self.validate_composed_contract(site)
            self.assertTrue(
                any("version_route_sha256" in error for error in validator.errors),
                msg="route mutation was not compared with the recorded digest",
            )

    def test_composed_contract_rejects_metadata_substitution(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-v2-test-") as raw:
            site = self.make_composed_site(Path(raw))
            path = site / "docs" / "v0.1.0" / "leaninfotheory-stage.json"
            metadata = json.loads(path.read_text(encoding="utf-8"))
            metadata["api_doc_relevant_sha256"] = "c" * 64
            path.write_text(
                json.dumps(metadata, indent=2, sort_keys=True) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            validator = self.validate_composed_contract(site)
            self.assertTrue(
                any("does not match frozen version metadata" in error for error in validator.errors)
            )

    def test_composed_contract_rejects_bad_frozen_identity_and_tag(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-v2-test-") as raw:
            site = self.make_composed_site(Path(raw))
            version_path = site / "docs" / "v0.1.0" / "leaninfotheory-stage.json"
            version_metadata = json.loads(version_path.read_text(encoding="utf-8"))
            version_metadata["source_identity"] = self.SITE_COMMIT
            version_path.write_text(
                json.dumps(version_metadata, indent=2, sort_keys=True) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            root_path = site / "website-stage.json"
            root_metadata = json.loads(root_path.read_text(encoding="utf-8"))
            root_metadata["release_tag_object"] = "2" * 40
            root_path.write_text(
                json.dumps(root_metadata, indent=2, sort_keys=True) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            self.refresh_composition_fingerprints(site)
            validator = self.validate_composed_contract(site)
            self.assertTrue(any("release_tag_object" in error for error in validator.errors))
            self.assertTrue(any("metadata is not pinned" in error for error in validator.errors))

    def test_composed_contract_rejects_stale_current_site_identity(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-v2-test-") as raw:
            site = self.make_composed_site(Path(raw))
            root_path = site / "website-stage.json"
            root_metadata = json.loads(root_path.read_text(encoding="utf-8"))
            root_metadata["site_source_identity"] = "2" * 40
            root_path.write_text(
                json.dumps(root_metadata, indent=2, sort_keys=True) + "\n",
                encoding="utf-8",
                newline="\n",
            )
            validator = self.validate_composed_contract(site)
            self.assertTrue(any("does not match checkout HEAD" in error for error in validator.errors))

    def test_redirected_components_and_descendants_are_rejected(self) -> None:
        with tempfile.TemporaryDirectory(prefix="leaninfotheory-redirect-test-") as raw:
            root = Path(raw).absolute()
            nested = root / "safe" / "route"
            nested.mkdir(parents=True)
            child = nested / "page.html"
            child.write_text("fixture", encoding="utf-8")

            redirected_component = root / "safe"
            with patch(
                "stage_website.is_redirected_path",
                side_effect=lambda path: Path(path) == redirected_component,
            ):
                with self.assertRaises(StagingError):
                    require_unredirected_components(nested, label="test root")

            with patch(
                "stage_website.is_redirected_path",
                side_effect=lambda path: Path(path) == child,
            ):
                with self.assertRaises(StagingError):
                    require_unredirected_tree(nested, label="test tree")

    def test_detached_staging_requires_matching_github_actions_sha(self) -> None:
        def fake_run(command: list[str], *, cwd: Path = ROOT) -> str:
            if command == ["git", "branch", "--show-current"]:
                return ""
            if command == ["git", "rev-parse", "HEAD"]:
                return self.SITE_COMMIT
            if command == ["git", "rev-parse", "v0.1.0"]:
                return VERSION_TAG_OBJECT
            if command == ["git", "rev-parse", "v0.1.0^{commit}"]:
                return VERSION_SOURCE_COMMIT
            raise AssertionError(f"unexpected command: {command!r}")

        with (
            patch("stage_website.require_clean_checkout"),
            patch("stage_website.run", side_effect=fake_run),
            patch.dict(os.environ, {}, clear=True),
        ):
            with self.assertRaises(StagingError):
                validate_current_maintenance_checkout()

        with (
            patch("stage_website.require_clean_checkout"),
            patch("stage_website.run", side_effect=fake_run),
            patch.dict(
                os.environ,
                {"GITHUB_ACTIONS": "true", "GITHUB_SHA": self.SITE_COMMIT},
                clear=True,
            ),
        ):
            self.assertEqual(validate_current_maintenance_checkout(), self.SITE_COMMIT)


if __name__ == "__main__":
    unittest.main()
