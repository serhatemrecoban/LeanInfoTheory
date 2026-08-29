#!/usr/bin/env python3
"""Regression tests for release-website validation."""

from __future__ import annotations

import shutil
import tempfile
import unittest
from pathlib import Path

from check_website import (
    CURATED_ROW_RE,
    CURATED_SOURCE_RE,
    EXPECTED_CURATED_DECLARATION_COUNT,
    WebsiteValidator,
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


if __name__ == "__main__":
    unittest.main()
