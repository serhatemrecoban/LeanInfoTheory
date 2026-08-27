#!/usr/bin/env python3
"""Validate the tracked site or an assembled LeanInfoTheory website artifact."""

from __future__ import annotations

import argparse
import hashlib
import html
import json
import posixpath
import re
import sys
from pathlib import Path, PurePosixPath
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SITE_ROOT = ROOT / "home_page"
VERSION_ROUTE = "docs/v0.1.0"
STAGE_METADATA = "leaninfotheory-stage.json"
ROOT_STAGE_METADATA = "website-stage.json"
PREVIEW_MARKER = "NOT_FOR_PUBLICATION.txt"
HTML_LINK_RE = re.compile(r"\b(?:href|src)\s*=\s*([\"'])(.*?)\1", re.IGNORECASE)
HTML_ID_RE = re.compile(r"\b(?:id|name)\s*=\s*([\"'])(.*?)\1", re.IGNORECASE)
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
PROJECT_BLOB_RE = re.compile(
    r"https://github\.com/serhatemrecoban/LeanInfoTheory/blob/([^/]+)/"
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
        self.total_bytes = 0
        self.metadata: dict[str, object] | None = None

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
            except json.JSONDecodeError as exc:
                self.error(f"invalid JSON in {relative}: {exc}")

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
            metadata_bytes = metadata_path.read_bytes()
            root_metadata_bytes = root_metadata_path.read_bytes()
            if root_metadata_bytes != metadata_bytes:
                self.error("root and versioned staged metadata are not byte-identical")
            metadata = json.loads(metadata_bytes.decode("utf-8"))
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
        if not isinstance(metadata, dict):
            self.error("staged metadata is not a JSON object")
            return
        self.metadata = metadata
        expected = {
            "schema": "lean-info-theory.website-stage.v1",
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
        for key, value in expected.items():
            if metadata.get(key) != value:
                self.error(
                    f"staged metadata {key}: expected {value!r}, found {metadata.get(key)!r}"
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
            if metadata.get("mode") != "preview" or metadata.get("publishable") is not False:
                self.error("preview metadata is not explicitly nonpublishable")
            if metadata.get("source_mode") != "file":
                self.error("preview metadata does not record file-mode generation")
            if not marker.is_file():
                self.error("preview is missing its NOT_FOR_PUBLICATION marker")
            if int(metadata.get("sanitized_file_source_links", 0)) <= 0:
                self.error("preview did not record sanitized local source links")
        else:
            if metadata.get("mode") != "release" or metadata.get("publishable") is not True:
                self.error("publishable metadata is not explicitly release-mode")
            if metadata.get("source_mode") != "github":
                self.error("publishable metadata does not record GitHub source mode")
            identity = str(metadata.get("source_identity", ""))
            if EXACT_COMMIT_RE.fullmatch(identity) is None:
                self.error("publishable metadata does not use an exact source commit")
            if marker.exists():
                self.error("publishable artifact contains NOT_FOR_PUBLICATION")

        external_runtime = metadata.get("external_runtime")
        if external_runtime != list(EXPECTED_EXTERNAL_RUNTIME):
            self.error("staged external-runtime inventory differs from the reviewed contract")
        if metadata.get("generated_static_assets") != list(EXPECTED_GENERATED_STATIC_ASSETS):
            self.error("staged generated-asset inventory differs from the reviewed contract")
        for key in ("api_doc_relevant_sha256", "doc_tree_sha256"):
            if SHA256_RE.fullmatch(str(metadata.get(key, ""))) is None:
                self.error(f"staged metadata has no valid {key}")
        license_records = metadata.get("license_records")
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
        if self.mode == "publishable":
            assert self.metadata is not None
            identity = str(self.metadata.get("source_identity", ""))
            for ref in PROJECT_BLOB_RE.findall(source):
                if ref != identity:
                    self.error(
                        f"{relative}: project source link uses {ref!r}, expected exact {identity}"
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
        f"{len(REQUIRED_JSON)} generated JSON files, and {validator.total_bytes} bytes "
        f"in {args.mode} mode; recorded {len(validator.advisories)} imported-dependency "
        f"link advisories ({advisory_digest})"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
