#!/usr/bin/env python3
"""Validate the tracked site or an assembled LeanInfoTheory website artifact."""

from __future__ import annotations

import argparse
import hashlib
import html
import json
import posixpath
import re
import subprocess
import sys
from html.parser import HTMLParser
from pathlib import Path, PurePosixPath
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SITE_ROOT = ROOT / "home_page"
VERSION_ROUTE = "docs/v0.1.0"
STAGE_METADATA = "leaninfotheory-stage.json"
ROOT_STAGE_METADATA = "website-stage.json"
PREVIEW_MARKER = "NOT_FOR_PUBLICATION.txt"
VERSION_TAG_OBJECT = "bcd9090ea2720fe14b0a3e168c76ebeef1dafd47"
VERSION_SOURCE_COMMIT = "0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f"
VERSION_STAGE_SCHEMA = "lean-info-theory.website-stage.v1"
COMPOSITION_STAGE_SCHEMA = "lean-info-theory.website-stage.v2"
HTML_LINK_RE = re.compile(r"\b(?:href|src)\s*=\s*([\"'])(.*?)\1", re.IGNORECASE)
HTML_ID_RE = re.compile(r"\b(?:id|name)\s*=\s*([\"'])(.*?)\1", re.IGNORECASE)
HTML_COMMENT_RE = re.compile(r"<!--.*?-->", re.DOTALL)
CSS_URL_RE = re.compile(r"url\(\s*([\"']?)(.*?)\1\s*\)", re.IGNORECASE)
MUTABLE_GITHUB_RE = re.compile(
    r"https://github\.com/serhatemrecoban/LeanInfoTheory/blob/(?:master|main|HEAD)/",
    re.IGNORECASE,
)
MACHINE_LOCAL_PATH_RE = re.compile(
    r"(?:[A-Za-z]:[\\/]+(?:Users|Documents and Settings)[\\/]"
    r"|/(?:home|Users)/[^/\s\"'<>]+/)",
    re.IGNORECASE,
)
FILE_URL_LITERAL_RE = re.compile(
    r"\bfile:(?:/{1,3})?(?:[A-Za-z]:[\\/]"
    r"|/(?:home|Users|tmp)/[^/\s\"'<>]+/)",
    re.IGNORECASE,
)
URL_TOKEN_RE = re.compile(r"https?:[^\"'<>\s]+", re.IGNORECASE)
CURATED_THEOREM_PAGE = "theorems.html"
CURATED_INDEX_PATH = "docs/declaration_index.json"
EXPECTED_CURATED_DECLARATION_COUNT = 28
CURATED_TBODY_RE = re.compile(r"<tbody\b[^>]*>(.*?)</tbody>", re.IGNORECASE | re.DOTALL)
CURATED_ROW_RE = re.compile(r"<tr\b[^>]*>(.*?)</tr>", re.IGNORECASE | re.DOTALL)
CURATED_CELL_RE = re.compile(r"<td\b[^>]*>(.*?)</td>", re.IGNORECASE | re.DOTALL)
CURATED_SOURCE_RE = re.compile(
    r"https://github\.com/serhatemrecoban/LeanInfoTheory/blob/"
    r"(?P<ref>[^/]+)/(?P<path>[^?#]+)#L(?P<line>[1-9][0-9]{0,8})"
)
EXACT_COMMIT_RE = re.compile(r"[0-9a-f]{40}")
SHA256_RE = re.compile(r"[0-9a-f]{64}")

DOCGEN_REVISION = "e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015"
LEAN_REVISION = "819816b2e0a3bf405af45ae5c7af2491d8f5bee6"
MATHLIB_REVISION = "0df444a360eaa60ab8c11dca51a86af692955474"
EXPECTED_DEPENDENCY_ADVISORY_COUNT = 111
EXPECTED_DEPENDENCY_MISSING_COUNT = 109
EXPECTED_DEPENDENCY_CASING_COUNT = 2
EXPECTED_DEPENDENCY_ADVISORY_SHA256 = (
    "bf8682253b1141fa6d97226f32d94fe599e4af7e4f69d8e363609f2155cfdd12"
)
TEXT_SAFETY_SUFFIXES = {
    ".css",
    ".html",
    ".htm",
    ".js",
    ".json",
    ".map",
    ".md",
    ".svg",
    ".txt",
    ".xml",
}


def tree_digest(root: Path) -> tuple[str, int, int, int]:
    """Fingerprint a staged directory exactly as the staging script does."""

    digest = hashlib.sha256()
    file_count = 0
    html_count = 0
    byte_count = 0
    for path in sorted(
        root.rglob("*"), key=lambda candidate: candidate.relative_to(root).as_posix()
    ):
        if path.is_dir():
            continue
        if not path.is_file():
            raise OSError(f"unsupported staged entry: {path}")
        relative = path.relative_to(root).as_posix()
        content = path.read_bytes()
        digest.update(relative.encode("utf-8"))
        digest.update(b"\0")
        digest.update(content)
        digest.update(b"\0")
        file_count += 1
        html_count += path.suffix.lower() == ".html"
        byte_count += len(content)
    return digest.hexdigest(), file_count, html_count, byte_count


def git_head() -> str:
    result = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        cwd=ROOT,
        text=True,
        encoding="utf-8",
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise OSError("could not resolve the current Git commit")
    return result.stdout.strip()


def is_positive_int(value: object) -> bool:
    return isinstance(value, int) and not isinstance(value, bool) and value > 0


class URLAttributeParser(HTMLParser):
    """Collect browser-decoded href/src values, including unquoted attributes."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.values: list[str] = []

    def record(self, attrs: list[tuple[str, str | None]]) -> None:
        for name, value in attrs:
            if name.casefold() in {"href", "src"} and value is not None:
                self.values.append(value)

    def handle_starttag(
        self, _tag: str, attrs: list[tuple[str, str | None]]
    ) -> None:
        self.record(attrs)

    def handle_startendtag(
        self, _tag: str, attrs: list[tuple[str, str | None]]
    ) -> None:
        self.record(attrs)


def project_blob_links(source: str):
    """Yield normalized LeanInfoTheory GitHub blob refs and repository paths."""

    decoded = html.unescape(source)
    tokens = [(match.group(0), False) for match in URL_TOKEN_RE.finditer(decoded)]
    parser = URLAttributeParser()
    parser.feed(source)
    for value in parser.values:
        browser_value = value.replace("\t", "").replace("\r", "").replace("\n", "")
        if browser_value != value:
            tokens.extend(
                (match.group(0), False) for match in URL_TOKEN_RE.finditer(browser_value)
            )
        stripped_value = browser_value.strip()
        if re.match(r"^[\\/]{2,}", stripped_value):
            normalized_authority = stripped_value.lstrip("\\/")
            tokens.append((f"https://{normalized_authority}", True))
    for token, protocol_relative in tokens:
        scheme, _separator, raw_rest = token.partition(":")
        normalized_rest = raw_rest.replace("\\", "/").lstrip("/")
        try:
            parsed = urlsplit(f"{scheme}://{normalized_rest}")
            hostname = parsed.hostname
        except ValueError:
            continue
        if hostname is None:
            continue
        decoded_hostname = hostname
        for _ in range(5):
            next_hostname = unquote(decoded_hostname)
            if next_hostname == decoded_hostname:
                break
            decoded_hostname = next_hostname
        try:
            idna_hostname = decoded_hostname.encode("idna").decode("ascii")
        except UnicodeError:
            continue
        if idna_hostname.rstrip(".").casefold() != "github.com":
            continue
        if decoded_hostname.rstrip(".").casefold() != "github.com":
            raise ValueError("GitHub URL host uses a noncanonical Unicode spelling")
        if protocol_relative:
            raise ValueError("GitHub URL uses a protocol-relative authority")
        if (
            not raw_rest.startswith("//")
            or raw_rest.startswith("///")
            or "\\" in raw_rest
        ):
            raise ValueError("GitHub URL does not use canonical // authority syntax")
        if parsed.scheme.casefold() != "https":
            raise ValueError("GitHub project URL does not use HTTPS")
        if decoded_hostname.endswith("."):
            raise ValueError("GitHub URL host has a noncanonical trailing dot")
        decoded_path = parsed.path
        for _ in range(5):
            next_path = unquote(decoded_path)
            if next_path == decoded_path:
                break
            decoded_path = next_path
        else:
            raise ValueError("GitHub URL path uses excessive nested percent-encoding")
        if "\\" in decoded_path:
            raise ValueError("GitHub URL path contains a backslash")
        segments = decoded_path.split("/")
        if any(segment in {".", ".."} for segment in segments):
            raise ValueError("GitHub URL path contains a dot segment")
        if len(segments) < 6:
            continue
        prefix = tuple(part.casefold() for part in segments[1:4])
        if prefix != ("serhatemrecoban", "leaninfotheory", "blob"):
            continue
        yield segments[4], "/".join(segments[5:])

REQUIRED_JSON = (
    "blueprint/module_graph.json",
    "docs/declaration_index.json",
)
REQUIRED_RUNTIME = (
    "index.html",
    "404.html",
    "navbar.html",
    "search.html",
    "find/index.html",
    "find/find.js",
    "style.css",
    "favicon.svg",
    "declaration-data.js",
    "declarations/declaration-data.bmp",
    "jump-src.js",
    "search.js",
    "expand-nav.js",
    "how-about.js",
    "instances.js",
    "importedBy.js",
    "nav.js",
    "color-scheme.js",
    "LeanInfoTheory/Shannon/Entropy.html",
    "LeanInfoTheory/Shannon/SemanticBridge/Theorems.html",
    "licenses/index.html",
)
EXPECTED_EXTERNAL_RUNTIME = (
    "https://cdnjs.cloudflare.com/ajax/libs/lato-font/3.0.0/css/lato-font.min.css",
    "https://cdnjs.cloudflare.com/ajax/libs/juliamono/0.051/juliamono.css",
    "https://cdnjs.cloudflare.com/polyfill/v3/polyfill.min.js?features=es6",
    "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js",
)
EXPECTED_GENERATED_STATIC_ASSETS = (
    "color-scheme.js",
    "declaration-data.js",
    "expand-nav.js",
    "favicon.svg",
    "how-about.js",
    "importedBy.js",
    "instances.js",
    "jump-src.js",
    "mathjax-config.js",
    "nav.js",
    "search.js",
    "style.css",
    "find/find.js",
)
EXPECTED_LICENSE_NAMES = (
    "doc-gen4",
    "Aesop",
    "Batteries",
    "ImportGraph",
    "LeanSearchClient",
    "Mathlib",
    "Plausible",
    "ProofWidgets",
    "Qq",
    "Lean 4, Lake, Std, and Init",
)


class CuratedCellParser(HTMLParser):
    """Extract browser-interpreted anchors and code text from one table cell."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.anchors: list[tuple[str | None, tuple[str, ...]]] = []
        self.codes: list[str] = []
        self.errors: list[str] = []
        self._anchor_open = False
        self._anchor_href: str | None = None
        self._anchor_codes: list[str] = []
        self._code_chunks: list[str] | None = None

    def handle_starttag(
        self, tag: str, attrs: list[tuple[str, str | None]]
    ) -> None:
        if tag == "a":
            unexpected = [name for name, _value in attrs if name.lower() != "href"]
            if unexpected:
                self.errors.append(f"anchor has unexpected attributes {unexpected!r}")
            if self._anchor_open:
                self.errors.append("nested anchor")
                return
            hrefs = [value for name, value in attrs if name.lower() == "href"]
            if len(hrefs) != 1 or hrefs[0] is None:
                self.errors.append(
                    f"anchor has {len(hrefs)} href attributes, expected exactly one"
                )
            self._anchor_open = True
            self._anchor_href = hrefs[0] if hrefs else None
            self._anchor_codes = []
        elif tag == "code":
            if attrs:
                self.errors.append(f"code element has unexpected attributes {attrs!r}")
            if self._code_chunks is not None:
                self.errors.append("nested code element")
                return
            self._code_chunks = []
        elif tag == "span":
            if attrs != [("class", "decl-actions")]:
                self.errors.append(f"span has unexpected attributes {attrs!r}")
        else:
            self.errors.append(f"unexpected start tag {tag!r}")

    def handle_endtag(self, tag: str) -> None:
        if tag == "code":
            if self._code_chunks is None:
                self.errors.append("closing code tag without an opening tag")
                return
            rendered = "".join(self._code_chunks)
            self.codes.append(rendered)
            if self._anchor_open:
                self._anchor_codes.append(rendered)
            self._code_chunks = None
        elif tag == "a":
            if not self._anchor_open:
                self.errors.append("closing anchor tag without an opening tag")
                return
            self.anchors.append((self._anchor_href, tuple(self._anchor_codes)))
            self._anchor_open = False
            self._anchor_href = None
            self._anchor_codes = []
        elif tag != "span":
            self.errors.append(f"unexpected closing tag {tag!r}")

    def handle_data(self, data: str) -> None:
        if self._code_chunks is not None:
            self._code_chunks.append(data)

    def finish(self) -> None:
        self.close()
        if self._code_chunks is not None:
            self.errors.append("unclosed code element")
        if self._anchor_open:
            self.errors.append("unclosed anchor element")


class CuratedTableAuditParser(HTMLParser):
    """Audit that the curated table is live, visible, and structurally sound."""

    VOID_TAGS = {
        "area",
        "base",
        "br",
        "col",
        "embed",
        "hr",
        "img",
        "input",
        "link",
        "meta",
        "param",
        "source",
        "track",
        "wbr",
    }
    INERT_TAGS = {
        "iframe",
        "noembed",
        "noframes",
        "noscript",
        "optgroup",
        "option",
        "plaintext",
        "script",
        "select",
        "style",
        "template",
        "textarea",
        "title",
        "xmp",
    }

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.errors: list[str] = []
        self.target_table_count = 0
        self.target_tbody_count = 0
        self.row_cell_counts: list[int] = []
        self._stack: list[tuple[str, bool]] = []
        self._target_table_depth: int | None = None
        self._target_tbody_depth: int | None = None
        self._target_row_depth: int | None = None
        self._target_cell_depth: int | None = None
        self._current_cell_count = 0

    @staticmethod
    def _is_hidden(
        tag: str, attrs: list[tuple[str, str | None]], parent_hidden: bool
    ) -> bool:
        if parent_hidden or tag in CuratedTableAuditParser.INERT_TAGS:
            return True
        lowered = [(name.lower(), value) for name, value in attrs]
        if any(name in {"hidden", "inert"} for name, _value in lowered):
            return True
        if any(
            name == "aria-hidden" and (value or "").strip().lower() == "true"
            for name, value in lowered
        ):
            return True
        styles = [value or "" for name, value in lowered if name == "style"]
        compact_styles = [re.sub(r"\s+", "", value.lower()) for value in styles]
        return any(
            "display:none" in value or "visibility:hidden" in value
            for value in compact_styles
        )

    @staticmethod
    def _has_status_table_class(attrs: list[tuple[str, str | None]]) -> bool:
        return any(
            name.lower() == "class"
            and value is not None
            and "status-table" in value.split()
            for name, value in attrs
        )

    def handle_starttag(
        self, tag: str, attrs: list[tuple[str, str | None]]
    ) -> None:
        tag = tag.lower()
        depth = len(self._stack)
        parent_hidden = self._stack[-1][1] if self._stack else False
        hidden = self._is_hidden(tag, attrs, parent_hidden)

        if tag == "table" and self._target_table_depth is not None:
            self.errors.append("nested table inside status-table")

        if tag == "table" and self._has_status_table_class(attrs):
            self.target_table_count += 1
            if self._target_table_depth is not None:
                self.errors.append("nested status-table elements")
            else:
                self._target_table_depth = depth
                if attrs != [("class", "status-table")]:
                    self.errors.append(
                        f"status-table has unexpected attributes {attrs!r}"
                    )
                if not self._stack or self._stack[-1][0] != "main":
                    self.errors.append("status-table is not a direct child of main")
                if hidden:
                    self.errors.append("status-table is hidden or inside inert content")
        elif tag == "tbody" and self._target_table_depth is not None:
            self.target_tbody_count += 1
            if self._target_tbody_depth is not None:
                self.errors.append("nested theorem table bodies")
            else:
                self._target_tbody_depth = depth
                if attrs:
                    self.errors.append(
                        f"theorem table body has unexpected attributes {attrs!r}"
                    )
                if (
                    not self._stack
                    or self._stack[-1][0] != "table"
                    or depth != self._target_table_depth + 1
                ):
                    self.errors.append(
                        "theorem table body is not a direct child of status-table"
                    )
                if hidden:
                    self.errors.append("theorem table body is hidden or inert")
        elif tag == "tr" and self._target_tbody_depth is not None:
            if self._target_row_depth is not None:
                self.errors.append("nested theorem table rows")
            else:
                self._target_row_depth = depth
                self._current_cell_count = 0
                if attrs:
                    self.errors.append(
                        f"theorem table row has unexpected attributes {attrs!r}"
                    )
                if (
                    not self._stack
                    or self._stack[-1][0] != "tbody"
                    or depth != self._target_tbody_depth + 1
                ):
                    self.errors.append(
                        "theorem table row is not a direct child of its table body"
                    )
                if hidden:
                    self.errors.append("theorem table row is hidden or inert")
        elif tag == "td" and self._target_row_depth is not None:
            if self._target_cell_depth is not None:
                self.errors.append("nested theorem table cells")
            else:
                self._target_cell_depth = depth
                self._current_cell_count += 1
                if attrs:
                    self.errors.append(
                        f"theorem table cell has unexpected attributes {attrs!r}"
                    )
                if (
                    not self._stack
                    or self._stack[-1][0] != "tr"
                    or depth != self._target_row_depth + 1
                ):
                    self.errors.append(
                        "theorem table cell is not a direct child of its row"
                    )
                if hidden:
                    self.errors.append("theorem table cell is hidden or inert")

        if tag not in self.VOID_TAGS:
            self._stack.append((tag, hidden))

    def handle_startendtag(
        self, tag: str, attrs: list[tuple[str, str | None]]
    ) -> None:
        if tag.lower() not in self.VOID_TAGS:
            self.errors.append(
                f"non-void HTML element {tag.lower()!r} uses self-closing syntax"
            )
        self.handle_starttag(tag, attrs)
        if tag.lower() not in self.VOID_TAGS:
            self.handle_endtag(tag)

    def handle_endtag(self, tag: str) -> None:
        tag = tag.lower()
        if not self._stack or self._stack[-1][0] != tag:
            expected = self._stack[-1][0] if self._stack else None
            self.errors.append(
                f"closing tag {tag!r} does not match open tag {expected!r}"
            )
            return

        depth = len(self._stack) - 1
        if tag == "td" and self._target_cell_depth == depth:
            self._target_cell_depth = None
        elif tag == "tr" and self._target_row_depth == depth:
            if self._target_cell_depth is not None:
                self.errors.append("theorem table row ended inside a cell")
            self.row_cell_counts.append(self._current_cell_count)
            self._target_row_depth = None
        elif tag == "tbody" and self._target_tbody_depth == depth:
            if self._target_row_depth is not None:
                self.errors.append("theorem table body ended inside a row")
            self._target_tbody_depth = None
        elif tag == "table" and self._target_table_depth == depth:
            if self._target_tbody_depth is not None:
                self.errors.append("status-table ended inside its table body")
            self._target_table_depth = None

        self._stack.pop()

    def finish(self) -> None:
        self.close()
        if self._stack:
            self.errors.append(f"unclosed HTML element {self._stack[-1][0]!r}")


class WebsiteValidator:
    def __init__(self, site_root: Path, mode: str):
        self.site_root = site_root.resolve()
        self.mode = mode
        self.errors: list[str] = []
        self.advisories: list[str] = []
        self.files: set[str] = set()
        self.directories: set[str] = {""}
        self.casefold_files: dict[str, str] = {}
        self.anchor_cache: dict[str, set[str]] = {}
        self.html_count = 0
        self.link_count = 0
        self.curated_declaration_count = 0
        self.total_bytes = 0
        self.metadata: dict[str, object] | None = None
        self.version_metadata: dict[str, object] | None = None

    def error(self, message: str) -> None:
        self.errors.append(message)

    def advisory(self, message: str) -> None:
        self.advisories.append(message)

    def is_imported_dependency_page(self, relative: str) -> bool:
        prefix = VERSION_ROUTE + "/"
        if not relative.startswith(prefix):
            return False
        nested = relative.removeprefix(prefix)
        first = nested.split("/", 1)[0].removesuffix(".html")
        return first in {
            "Aesop",
            "Batteries",
            "ImportGraph",
            "Init",
            "Lake",
            "Lean",
            "LeanSearchClient",
            "Mathlib",
            "Plausible",
            "ProofWidgets",
            "Qq",
            "Std",
        }

    def relative(self, path: Path) -> str:
        return path.relative_to(self.site_root).as_posix()

    def inventory(self) -> None:
        if not self.site_root.is_dir():
            self.error(f"site root is missing: {self.site_root}")
            return
        for path in sorted(self.site_root.rglob("*")):
            rel = self.relative(path)
            if path.is_symlink():
                self.error(f"symbolic link is not allowed: {rel}")
                continue
            if path.is_dir():
                self.directories.add(rel)
                continue
            if not path.is_file():
                self.error(f"unsupported filesystem entry: {rel}")
                continue
            self.files.add(rel)
            self.casefold_files[rel.casefold()] = rel
            stat = path.stat()
            self.total_bytes += stat.st_size
            if self.mode != "source" and stat.st_nlink > 1:
                self.error(f"hard-linked staged file is not allowed: {rel}")
            if self.mode != "source" and stat.st_size > 100 * 1024 * 1024:
                self.error(f"staged file exceeds 100 MiB: {rel}")
        if self.mode != "source" and self.total_bytes >= 1_000_000_000:
            self.error(
                f"staged site is {self.total_bytes} bytes and reaches the 1 GB Pages limit"
            )

    def validate_json(self) -> None:
        for relative in REQUIRED_JSON:
            path = self.site_root / Path(relative)
            try:
                json.loads(path.read_text(encoding="utf-8"))
            except FileNotFoundError:
                self.error(f"missing generated JSON: {relative}")
            except ValueError as exc:
                self.error(f"invalid JSON in {relative}: {exc}")

    @staticmethod
    def declaration_fragment(name: str) -> str:
        """Return the declaration-index fragment used by the website generator."""
        slug = re.sub(r"[^A-Za-z0-9_-]+", "-", name).strip("-")
        return f"decl-{slug}"

    @staticmethod
    def is_versioned_path(relative: str) -> bool:
        return relative == VERSION_ROUTE or relative.startswith(VERSION_ROUTE + "/")

    def curated_source_ref(self) -> str:
        if self.mode != "publishable" or self.metadata is None:
            return "v0.1.0"
        if self.metadata.get("schema") == COMPOSITION_STAGE_SCHEMA:
            return str(self.metadata.get("site_source_identity", ""))
        return str(self.metadata.get("source_identity", ""))

    def expected_project_ref(self, relative: str, project_path: str) -> str | None:
        """Return the required ref for a staged project link, if one is fixed."""

        if self.mode != "publishable" or self.metadata is None:
            return None
        if self.metadata.get("schema") != COMPOSITION_STAGE_SCHEMA:
            return str(self.metadata.get("source_identity", ""))
        if self.is_versioned_path(relative):
            return str(self.metadata.get("api_source_identity", ""))
        if project_path.endswith(".lean"):
            return str(self.metadata.get("site_source_identity", ""))
        return None

    def validate_curated_theorem_links(self) -> None:
        """Match every hand-curated theorem row to the source-derived index."""
        theorem_path = self.site_root / CURATED_THEOREM_PAGE
        index_path = self.site_root / CURATED_INDEX_PATH
        try:
            theorem_source = theorem_path.read_text(encoding="utf-8")
            index_data = json.loads(index_path.read_text(encoding="utf-8"))
        except FileNotFoundError as exc:
            self.error(f"curated theorem validation is missing {exc.filename}")
            return
        except UnicodeDecodeError as exc:
            self.error(f"curated theorem validation found invalid UTF-8: {exc}")
            return
        except ValueError as exc:
            self.error(f"curated theorem validation found invalid JSON: {exc}")
            return

        theorem_source = HTML_COMMENT_RE.sub("", theorem_source)
        if "<!--" in theorem_source or "-->" in theorem_source:
            self.error(
                f"{CURATED_THEOREM_PAGE}: malformed or unterminated HTML comment"
            )
            return

        table_audit = CuratedTableAuditParser()
        table_audit.feed(theorem_source)
        table_audit.finish()
        for issue in table_audit.errors:
            self.error(f"{CURATED_THEOREM_PAGE}: invalid curated table HTML: {issue}")
        if table_audit.target_table_count != 1:
            self.error(
                f"{CURATED_THEOREM_PAGE}: expected exactly one live status-table, "
                f"found {table_audit.target_table_count}"
            )
        if table_audit.target_tbody_count != 1:
            self.error(
                f"{CURATED_THEOREM_PAGE}: expected exactly one live theorem table body, "
                f"found {table_audit.target_tbody_count}"
            )
        if (
            table_audit.errors
            or table_audit.target_table_count != 1
            or table_audit.target_tbody_count != 1
        ):
            return

        if not isinstance(index_data, dict):
            self.error(f"{CURATED_INDEX_PATH}: top-level JSON value is not an object")
            return
        raw_declarations = index_data.get("declarations")
        if not isinstance(raw_declarations, list):
            self.error(f"{CURATED_INDEX_PATH}: declarations is not a list")
            return

        declarations_by_fragment: dict[str, dict[str, object]] = {}
        for position, record in enumerate(raw_declarations, start=1):
            if not isinstance(record, dict):
                self.error(
                    f"{CURATED_INDEX_PATH}: declaration {position} is not an object"
                )
                continue
            name = record.get("name")
            if not isinstance(name, str) or not name:
                self.error(
                    f"{CURATED_INDEX_PATH}: declaration {position} has no valid name"
                )
                continue
            fragment = self.declaration_fragment(name)
            previous = declarations_by_fragment.get(fragment)
            if previous is not None:
                self.error(
                    f"{CURATED_INDEX_PATH}: duplicate declaration fragment {fragment!r}"
                )
                continue
            declarations_by_fragment[fragment] = record

        table_bodies = CURATED_TBODY_RE.findall(theorem_source)
        if len(table_bodies) != 1:
            self.error(
                f"{CURATED_THEOREM_PAGE}: expected exactly one theorem table body, "
                f"found {len(table_bodies)}"
            )
            return
        rows = CURATED_ROW_RE.findall(table_bodies[0])
        if not rows:
            self.error(f"{CURATED_THEOREM_PAGE}: curated theorem table has no rows")
            return
        if len(rows) != len(table_audit.row_cell_counts):
            self.error(
                f"{CURATED_THEOREM_PAGE}: raw and live theorem row counts differ "
                f"({len(rows)} versus {len(table_audit.row_cell_counts)})"
            )
            return
        for row_number, cell_count in enumerate(
            table_audit.row_cell_counts, start=1
        ):
            if cell_count != 4:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: live curated row {row_number} has "
                    f"{cell_count} cells, expected 4"
                )
        if len(rows) != EXPECTED_CURATED_DECLARATION_COUNT:
            self.error(
                f"{CURATED_THEOREM_PAGE}: expected "
                f"{EXPECTED_CURATED_DECLARATION_COUNT} curated rows, found {len(rows)}"
            )

        if self.mode == "publishable" and self.metadata is None:
            self.error(
                f"{CURATED_THEOREM_PAGE}: publishable validation has no stage metadata"
            )
            return
        expected_ref = self.curated_source_ref()

        seen_fragments: set[str] = set()
        valid_rows = 0
        for row_number, row in enumerate(rows, start=1):
            cells = CURATED_CELL_RE.findall(row)
            if len(cells) != 4:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} has "
                    f"{len(cells)} cells, expected 4"
                )
                continue

            declaration_cell = cells[1]
            declaration_parser = CuratedCellParser()
            declaration_parser.feed(declaration_cell)
            declaration_parser.finish()
            for issue in declaration_parser.errors:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} "
                    f"declaration cell has invalid HTML: {issue}"
                )
            primary_matches = [
                (target, codes)
                for target, codes in declaration_parser.anchors
                if target is not None
                and target.startswith("docs/api-index.html#decl-")
                and len(codes) == 1
            ]
            if len(primary_matches) != 1:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} has "
                    f"{len(primary_matches)} primary declaration links, expected 1"
                )
                continue
            primary_target, primary_codes = primary_matches[0]
            fragment = primary_target.split("#", 1)[1]
            display = primary_codes[0].strip()
            observed_codes = [code.strip() for code in declaration_parser.codes]
            if observed_codes != [display]:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} declaration "
                    f"cell code elements are {observed_codes!r}, expected [{display!r}]"
                )
            if fragment in seen_fragments:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: duplicate curated declaration {fragment!r}"
                )
                continue
            seen_fragments.add(fragment)

            declaration = declarations_by_fragment.get(fragment)
            if declaration is None:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} references "
                    f"unknown declaration fragment {fragment!r}"
                )
                continue

            name = declaration.get("name")
            module = declaration.get("module")
            path = declaration.get("path")
            line = declaration.get("line")
            if (
                not isinstance(name, str)
                or not isinstance(module, str)
                or not isinstance(path, str)
                or not isinstance(line, int)
                or isinstance(line, bool)
                or line <= 0
            ):
                self.error(
                    f"{CURATED_INDEX_PATH}: declaration for {fragment!r} has "
                    "invalid name/module/path/line metadata"
                )
                continue

            expected_display = name.removeprefix("LeanInfoTheory.")
            if display != expected_display:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} displays "
                    f"{display!r}, expected {expected_display!r}"
                )

            api_target = f"docs/api-index.html#{fragment}"
            all_targets = [
                target
                for target, _codes in declaration_parser.anchors
                if target is not None
            ]
            if len(declaration_parser.anchors) != 3 or len(all_targets) != 3:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} has "
                    f"{len(declaration_parser.anchors)} anchors and {len(all_targets)} "
                    "valid hrefs, expected three declaration/API-index/source links"
                )
            api_targets = [
                target
                for target in all_targets
                if target.startswith("docs/api-index.html#decl-")
            ]
            if api_targets != [api_target, api_target]:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} API links "
                    f"are {api_targets!r}, expected two copies of {api_target!r}"
                )

            module_parser = CuratedCellParser()
            module_parser.feed(cells[2])
            module_parser.finish()
            for issue in module_parser.errors:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} "
                    f"module cell has invalid HTML: {issue}"
                )
            module_codes = [code.strip() for code in module_parser.codes]
            if module_parser.anchors:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} module cell "
                    "must not contain links"
                )
            observed_module = module_codes[0] if len(module_codes) == 1 else None
            if observed_module != module:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} module is "
                    f"{observed_module!r}, expected {module!r}"
                )

            source_targets = [
                target
                for target in all_targets
                if CURATED_SOURCE_RE.fullmatch(target) is not None
            ]
            if len(source_targets) != 1:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} has "
                    f"{len(source_targets)} project source links, expected 1"
                )
                continue
            source_match = CURATED_SOURCE_RE.fullmatch(source_targets[0])
            assert source_match is not None
            observed_ref = source_match.group("ref")
            observed_path = unquote(source_match.group("path"))
            observed_line = int(source_match.group("line"))
            if observed_ref != expected_ref:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} source ref is "
                    f"{observed_ref!r}, expected {expected_ref!r}"
                )
            if observed_path != path or observed_line != line:
                self.error(
                    f"{CURATED_THEOREM_PAGE}: curated row {row_number} source location "
                    f"is {observed_path}#L{observed_line}, expected {path}#L{line} for {name}"
                )
                continue
            valid_rows += 1

        self.curated_declaration_count = valid_rows
        if valid_rows != len(rows):
            self.error(
                f"{CURATED_THEOREM_PAGE}: only {valid_rows} of {len(rows)} curated "
                "rows have authoritative source locations"
            )

    def validate_stage_contract(self) -> None:
        version = self.site_root / Path(VERSION_ROUTE)
        metadata_path = version / STAGE_METADATA
        if self.mode == "source":
            placeholder = version / "index.html"
            if not placeholder.is_file():
                self.error(f"missing version-route placeholder: {VERSION_ROUTE}/index.html")
                return
            source = placeholder.read_text(encoding="utf-8")
            if 'data-api-placeholder="true"' not in source:
                self.error("tracked version route is not marked as an unpublished placeholder")
            if metadata_path.exists():
                self.error("tracked site must not contain assembled stage metadata")
            if (self.site_root / ROOT_STAGE_METADATA).exists():
                self.error("tracked site must not contain root stage metadata")
            return

        root_metadata_path = self.site_root / ROOT_STAGE_METADATA
        try:
            version_metadata_bytes = metadata_path.read_bytes()
            root_metadata_bytes = root_metadata_path.read_bytes()
            version_metadata = json.loads(version_metadata_bytes.decode("utf-8"))
            root_metadata = json.loads(root_metadata_bytes.decode("utf-8"))
        except FileNotFoundError:
            self.error(
                f"missing staged metadata: {ROOT_STAGE_METADATA} and/or "
                f"{VERSION_ROUTE}/{STAGE_METADATA}"
            )
            return
        except UnicodeDecodeError as exc:
            self.error(f"staged metadata is not UTF-8: {exc}")
            return
        except json.JSONDecodeError as exc:
            self.error(f"invalid staged metadata: {exc}")
            return
        if not isinstance(root_metadata, dict) or not isinstance(version_metadata, dict):
            self.error("root and versioned staged metadata must be JSON objects")
            return
        self.metadata = root_metadata
        self.version_metadata = version_metadata

        root_schema = root_metadata.get("schema")
        if root_schema == VERSION_STAGE_SCHEMA:
            if root_metadata_bytes != version_metadata_bytes:
                self.error("legacy root and versioned staged metadata are not byte-identical")
        elif root_schema == COMPOSITION_STAGE_SCHEMA:
            if self.mode != "publishable":
                self.error("maintenance composition metadata is valid only when publishable")
            expected_root = {
                "version": "v0.1.0",
                "route": "/docs/v0.1.0/",
                "mode": "maintenance",
                "publishable": True,
                "site_policy": "current-master",
                "api_policy": "immutable-version",
                "api_source_identity": VERSION_SOURCE_COMMIT,
                "release_tag": "v0.1.0",
                "release_tag_object": VERSION_TAG_OBJECT,
                "version_metadata_schema": VERSION_STAGE_SCHEMA,
            }
            for key, value in expected_root.items():
                if root_metadata.get(key) != value:
                    self.error(
                        f"composition metadata {key}: expected {value!r}, "
                        f"found {root_metadata.get(key)!r}"
                    )
            site_identity = str(root_metadata.get("site_source_identity", ""))
            if EXACT_COMMIT_RE.fullmatch(site_identity) is None:
                self.error("composition metadata has no exact current-site commit")
            try:
                observed_head = git_head()
            except OSError as exc:
                self.error(str(exc))
            else:
                if site_identity != observed_head:
                    self.error(
                        "composition current-site identity does not match checkout HEAD: "
                        f"{site_identity!r} != {observed_head!r}"
                    )
            if not is_positive_int(
                root_metadata.get("rewritten_current_site_source_links")
            ):
                self.error("composition metadata records no current-site source rewrites")
            metadata_digest = hashlib.sha256(version_metadata_bytes).hexdigest()
            if root_metadata.get("version_metadata_sha256") != metadata_digest:
                self.error("composition metadata does not match frozen version metadata")
            try:
                route_digest, route_files, route_html, route_bytes = tree_digest(version)
            except OSError as exc:
                self.error(f"could not fingerprint frozen version route: {exc}")
            else:
                observed_route = {
                    "version_route_sha256": route_digest,
                    "version_route_files": route_files,
                    "version_route_html_files": route_html,
                    "version_route_bytes": route_bytes,
                }
                for key, value in observed_route.items():
                    if root_metadata.get(key) != value:
                        self.error(
                            f"composition metadata {key}: expected observed {value!r}, "
                            f"found {root_metadata.get(key)!r}"
                        )
            if not is_positive_int(root_metadata.get("version_project_source_links")):
                self.error("composition metadata records no frozen API source links")
        else:
            self.error(f"unsupported root staged metadata schema: {root_schema!r}")

        expected_version = {
            "schema": VERSION_STAGE_SCHEMA,
            "version": "v0.1.0",
            "route": "/docs/v0.1.0/",
            "supported_modules": 31,
            "supported_declarations": 601,
            "root_exports": 92,
            "excluded_modules": 13,
            "equation_rows": 0,
            "doc_files": 5521,
            "doc_html_files": 5506,
            "docgen_revision": DOCGEN_REVISION,
            "lean_revision": LEAN_REVISION,
            "mathlib_revision": MATHLIB_REVISION,
        }
        for key, value in expected_version.items():
            if version_metadata.get(key) != value:
                self.error(
                    f"versioned metadata {key}: expected {value!r}, "
                    f"found {version_metadata.get(key)!r}"
                )
        for relative in REQUIRED_RUNTIME:
            if f"{VERSION_ROUTE}/{relative}" not in self.files:
                self.error(f"missing staged runtime asset: {VERSION_ROUTE}/{relative}")
        index_path = version / "index.html"
        if index_path.is_file() and 'data-api-placeholder="true"' in index_path.read_text(
            encoding="utf-8"
        ):
            self.error("assembled API route still contains the tracked placeholder")

        marker = version / PREVIEW_MARKER
        if self.mode == "preview":
            if (
                version_metadata.get("mode") != "preview"
                or version_metadata.get("publishable") is not False
            ):
                self.error("preview metadata is not explicitly nonpublishable")
            if version_metadata.get("source_mode") != "file":
                self.error("preview metadata does not record file-mode generation")
            if not marker.is_file():
                self.error("preview is missing its NOT_FOR_PUBLICATION marker")
            if not is_positive_int(version_metadata.get("sanitized_file_source_links")):
                self.error("preview did not record sanitized local source links")
        else:
            if (
                version_metadata.get("mode") != "release"
                or version_metadata.get("publishable") is not True
            ):
                self.error("versioned publishable metadata is not release-mode")
            if version_metadata.get("source_mode") != "github":
                self.error("versioned publishable metadata does not record GitHub mode")
            identity = str(version_metadata.get("source_identity", ""))
            if identity != VERSION_SOURCE_COMMIT:
                self.error(
                    "v0.1.0 metadata is not pinned to the immutable release commit: "
                    f"{identity!r}"
                )
            if marker.exists():
                self.error("publishable artifact contains NOT_FOR_PUBLICATION")

        external_runtime = version_metadata.get("external_runtime")
        if external_runtime != list(EXPECTED_EXTERNAL_RUNTIME):
            self.error("staged external-runtime inventory differs from the reviewed contract")
        if version_metadata.get("generated_static_assets") != list(EXPECTED_GENERATED_STATIC_ASSETS):
            self.error("staged generated-asset inventory differs from the reviewed contract")
        for key in ("api_doc_relevant_sha256", "doc_tree_sha256"):
            if SHA256_RE.fullmatch(str(version_metadata.get(key, ""))) is None:
                self.error(f"staged metadata has no valid {key}")
        license_records = version_metadata.get("license_records")
        if not isinstance(license_records, list):
            self.error("staged licence inventory is not a list")
        else:
            names = tuple(
                str(record.get("name", "")) if isinstance(record, dict) else ""
                for record in license_records
            )
            if names != EXPECTED_LICENSE_NAMES:
                self.error("staged licence inventory differs from the reviewed contract")
        navbar_path = version / "navbar.html"
        if navbar_path.is_file():
            navbar = navbar_path.read_text(encoding="utf-8")
            if 'href="../">Project documentation</a>' not in navbar:
                self.error("doc-gen navbar has no route back to project documentation")

    def anchors(self, relative: str) -> set[str]:
        cached = self.anchor_cache.get(relative)
        if cached is not None:
            return cached
        path = self.site_root / Path(relative)
        try:
            source = path.read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError):
            result: set[str] = set()
        else:
            result = {html.unescape(match[1]) for match in HTML_ID_RE.findall(source)}
        self.anchor_cache[relative] = result
        return result

    def local_target(self, source_rel: str, target: str) -> tuple[str | None, str | None]:
        parsed = urlsplit(html.unescape(target))
        if parsed.scheme:
            scheme = parsed.scheme.lower()
            if scheme not in {"http", "https", "mailto"}:
                self.error(f"{source_rel}: forbidden URL scheme {scheme!r}: {target}")
            return None, None
        if target.startswith("//"):
            self.error(f"{source_rel}: protocol-relative URL is not allowed: {target}")
            return None, None
        path_text = unquote(parsed.path).replace("\\", "/")
        if path_text.startswith("/"):
            self.error(f"{source_rel}: root-relative link breaks the project base path: {target}")
            return None, None
        if not path_text:
            candidate = source_rel
            fragment = unquote(parsed.fragment)
            return candidate, fragment or None
        source_parent = PurePosixPath(source_rel).parent.as_posix()
        joined = posixpath.normpath(posixpath.join(source_parent, path_text))
        if joined == ".." or joined.startswith("../"):
            self.error(f"{source_rel}: local link escapes the site: {target}")
            return None, None
        if joined == ".":
            joined = ""
        candidate = joined
        bare_target = target.split("#", 1)[0].split("?", 1)[0]
        if candidate in self.directories or bare_target.endswith("/"):
            candidate = posixpath.join(candidate, "index.html") if candidate else "index.html"
        if candidate not in self.files:
            actual = self.casefold_files.get(candidate.casefold())
            if actual is not None:
                message = f"{source_rel}: link has incorrect path casing: {target} -> {actual}"
                if self.is_imported_dependency_page(source_rel):
                    self.advisory(message)
                else:
                    self.error(message)
            else:
                message = f"{source_rel}: missing local link {target} -> {candidate}"
                if self.is_imported_dependency_page(source_rel):
                    self.advisory(message)
                else:
                    self.error(message)
            return None, None
        fragment = unquote(parsed.fragment)
        return candidate, fragment or None

    def validate_target(self, source_rel: str, target: str) -> None:
        self.link_count += 1
        if re.search(r"file://", target, re.IGNORECASE):
            self.error(f"{source_rel}: local file URL is forbidden: {target}")
            return
        candidate, fragment = self.local_target(source_rel, target)
        if candidate is None or fragment is None:
            return
        if self.is_imported_dependency_page(source_rel):
            return
        if not candidate.lower().endswith((".html", ".htm")):
            self.error(f"{source_rel}: fragment targets a non-HTML file: {target}")
            return
        if fragment not in self.anchors(candidate):
            message = f"{source_rel}: missing fragment {target} in {candidate}"
            if self.is_imported_dependency_page(source_rel):
                self.advisory(message)
            else:
                self.error(message)

    def validate_text_safety(self, relative: str, source: str) -> None:
        if FILE_URL_LITERAL_RE.search(source):
            self.error(f"{relative}: contains a local file URL")
        if MACHINE_LOCAL_PATH_RE.search(source):
            self.error(f"{relative}: contains a machine-local filesystem path")
        if MUTABLE_GITHUB_RE.search(source):
            self.error(f"{relative}: contains a mutable GitHub source link")
        try:
            project_links = list(project_blob_links(source))
        except ValueError as exc:
            self.error(f"{relative}: contains an unsafe GitHub URL: {exc}")
            return
        if any(ref.casefold() in {"master", "main", "head"} for ref, _ in project_links):
            self.error(f"{relative}: contains a mutable GitHub source link")
        if self.mode == "publishable":
            assert self.metadata is not None
            for ref, project_path in project_links:
                expected = self.expected_project_ref(relative, project_path)
                if expected is not None and ref != expected:
                    self.error(
                        f"{relative}: project source link uses {ref!r}, "
                        f"expected exact {expected}"
                    )
                    continue
                if (
                    expected is None
                    and self.metadata.get("schema") == COMPOSITION_STAGE_SCHEMA
                ):
                    allowed = {
                        "v0.1.0",
                        str(self.metadata.get("site_source_identity", "")),
                        str(self.metadata.get("api_source_identity", "")),
                    }
                    if ref not in allowed:
                        self.error(
                            f"{relative}: non-source project link uses unreviewed ref {ref!r}"
                        )

    def validate_links(self) -> None:
        for relative in sorted(self.files):
            suffix = Path(relative).suffix.lower()
            if suffix not in TEXT_SAFETY_SUFFIXES:
                continue
            path = self.site_root / Path(relative)
            try:
                source = path.read_text(encoding="utf-8")
            except UnicodeDecodeError as exc:
                self.error(f"{relative}: invalid UTF-8: {exc}")
                continue
            self.validate_text_safety(relative, source)
            if suffix == ".html":
                self.html_count += 1
                targets = [match[1] for match in HTML_LINK_RE.findall(source)]
            elif suffix == ".css":
                targets = [match[1] for match in CSS_URL_RE.findall(source)]
            else:
                targets = []
            for target in targets:
                if target:
                    self.validate_target(relative, target)

    def validate_advisory_baseline(self) -> None:
        digest = hashlib.sha256(
            "\n".join(sorted(self.advisories)).encode("utf-8")
        ).hexdigest()
        if self.mode == "source":
            if self.advisories:
                self.error("tracked source unexpectedly produced dependency advisories")
            return
        missing = sum("missing local link" in message for message in self.advisories)
        casing = sum("incorrect path casing" in message for message in self.advisories)
        observed = (
            len(self.advisories),
            missing,
            casing,
            digest,
        )
        expected = (
            EXPECTED_DEPENDENCY_ADVISORY_COUNT,
            EXPECTED_DEPENDENCY_MISSING_COUNT,
            EXPECTED_DEPENDENCY_CASING_COUNT,
            EXPECTED_DEPENDENCY_ADVISORY_SHA256,
        )
        if observed != expected:
            self.error(
                "imported-dependency advisory baseline changed: "
                f"expected count/missing/casing/digest {expected}, found {observed}; "
                "review the dependency documentation before updating the baseline"
            )

    def validate_required_site_files(self) -> None:
        required = (
            ".nojekyll",
            "index.html",
            "docs/index.html",
            "docs/third-party.html",
            "license.html",
        )
        for relative in required:
            if relative not in self.files:
                self.error(f"missing required website file: {relative}")

    def run(self) -> None:
        self.inventory()
        if not self.site_root.is_dir():
            return
        self.validate_required_site_files()
        self.validate_json()
        self.validate_stage_contract()
        self.validate_curated_theorem_links()
        self.validate_links()
        self.validate_advisory_baseline()


def main() -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--site-root",
        type=Path,
        default=DEFAULT_SITE_ROOT,
        help="tracked or assembled website root (default: home_page)",
    )
    parser.add_argument(
        "--mode",
        choices=("source", "preview", "publishable"),
        default="source",
        help="validation policy for the tracked site or a staged artifact",
    )
    args = parser.parse_args()
    validator = WebsiteValidator(args.site_root, args.mode)
    validator.run()
    if validator.errors:
        shown = validator.errors[:200]
        print("\n".join(shown))
        if len(validator.errors) > len(shown):
            print(f"... {len(validator.errors) - len(shown)} additional errors")
        return 1
    advisory_digest = hashlib.sha256(
        "\n".join(sorted(validator.advisories)).encode("utf-8")
    ).hexdigest()
    print(
        f"checked {validator.html_count} HTML files, {validator.link_count} links/assets, "
        f"{len(REQUIRED_JSON)} generated JSON files, "
        f"{validator.curated_declaration_count} curated theorem links, and "
        f"{validator.total_bytes} bytes "
        f"in {args.mode} mode; recorded {len(validator.advisories)} imported-dependency "
        f"link advisories ({advisory_digest})"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
