#!/usr/bin/env python3
"""Validate generated doc-gen4 output against the frozen v0.1 public API."""

from __future__ import annotations

import argparse
import html
import json
import os
import re
import sqlite3
import subprocess
import sys
from dataclasses import dataclass, field
from html.parser import HTMLParser
from pathlib import Path, PurePosixPath
from urllib.parse import unquote, urlsplit

import generate_website_api_index as api_index


ROOT = Path(__file__).resolve().parents[1]
BUILD_ROOT = ROOT / "docbuild" / ".lake" / "build"
DOC_ROOT = BUILD_ROOT / "doc"
DOC_MANIFEST = BUILD_ROOT / "doc-manifest.json"
PUBLIC_API = ROOT / "docs" / "v0.1-public-api.json"
PUBLIC_API_SCHEMA = "lean-info-theory.public-api.v0.1.v1"
REPOSITORY_URL = "https://github.com/serhatemrecoban/LeanInfoTheory"

REQUIRED_OUTPUTS = (
    "doc/404.html",
    "doc/index.html",
    "doc/search.html",
    "doc/find/index.html",
    "doc/find/find.js",
    "doc/navbar.html",
    "doc/style.css",
    "doc/color-scheme.js",
    "doc/declaration-data.js",
    "doc/expand-nav.js",
    "doc/importedBy.js",
    "doc/instances.js",
    "doc/jump-src.js",
    "doc/mathjax-config.js",
    "doc/nav.js",
    "doc/search.js",
    "doc/declarations/declaration-data.bmp",
)

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


class DocumentationError(RuntimeError):
    """Generated documentation does not satisfy the release contract."""


@dataclass
class DeclarationBlock:
    name: str
    classes: set[str]
    header_text: list[str] = field(default_factory=list)
    type_text: list[str] = field(default_factory=list)
    source_href: str | None = None


class ModulePageParser(HTMLParser):
    """Extract doc-gen declaration blocks without depending on third-party HTML."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.stack: list[tuple[str, set[str]]] = []
        self.current: DeclarationBlock | None = None
        self.declaration_depth: int | None = None
        self.header_depth: int | None = None
        self.type_depth: int | None = None
        self.source_depth: int | None = None
        self.declarations: dict[str, list[DeclarationBlock]] = {}

    @staticmethod
    def attributes(attrs: list[tuple[str, str | None]]) -> dict[str, str]:
        return {key: value or "" for key, value in attrs}

    def handle_starttag(
        self, tag: str, attrs: list[tuple[str, str | None]]
    ) -> None:
        attributes = self.attributes(attrs)
        classes = set(attributes.get("class", "").split())
        depth = len(self.stack) + 1

        if (
            self.current is None
            and tag == "div"
            and "decl" in classes
            and attributes.get("id")
        ):
            self.current = DeclarationBlock(attributes["id"], classes)
            self.declaration_depth = depth

        if self.current is not None:
            if tag == "div" and "decl_header" in classes:
                self.header_depth = depth
            if tag == "div" and "decl_type" in classes:
                self.type_depth = depth
            if tag == "div" and "gh_link" in classes:
                self.source_depth = depth
            if (
                tag == "a"
                and self.source_depth is not None
                and self.current.source_href is None
                and attributes.get("href")
            ):
                self.current.source_href = html.unescape(attributes["href"])

        if tag not in VOID_TAGS:
            self.stack.append((tag, classes))

    def handle_startendtag(
        self, tag: str, attrs: list[tuple[str, str | None]]
    ) -> None:
        self.handle_starttag(tag, attrs)
        if tag not in VOID_TAGS:
            self.handle_endtag(tag)

    def handle_data(self, data: str) -> None:
        if self.current is None:
            return
        if self.header_depth is not None:
            self.current.header_text.append(data)
        if self.type_depth is not None:
            self.current.type_text.append(data)

    def handle_endtag(self, tag: str) -> None:
        if not self.stack:
            return
        depth = len(self.stack)
        stack_tag, _ = self.stack[-1]
        if stack_tag != tag:
            return

        if self.type_depth == depth:
            self.type_depth = None
        if self.header_depth == depth:
            self.header_depth = None
        if self.source_depth == depth:
            self.source_depth = None
        if self.current is not None and self.declaration_depth == depth:
            self.declarations.setdefault(self.current.name, []).append(self.current)
            self.current = None
            self.declaration_depth = None
            self.header_depth = None
            self.type_depth = None
            self.source_depth = None
        self.stack.pop()


def normalize_text(parts: list[str]) -> str:
    return re.sub(r"\s+", " ", "".join(parts)).strip()


def module_page(module: str) -> str:
    return "doc/" + module.replace(".", "/") + ".html"


def module_source(module: str) -> str:
    return module.replace(".", "/") + ".lean"


def load_public_api() -> dict[str, object]:
    data = json.loads(PUBLIC_API.read_text(encoding="utf-8"))
    if data.get("schema") != PUBLIC_API_SCHEMA:
        raise DocumentationError(f"unexpected public API schema: {data.get('schema')!r}")
    return data


def load_generated_manifest() -> set[str]:
    if not DOC_MANIFEST.is_file():
        raise DocumentationError(f"missing generated manifest: {DOC_MANIFEST}")
    data = json.loads(DOC_MANIFEST.read_text(encoding="utf-8"))
    if not isinstance(data, list) or not all(isinstance(item, str) for item in data):
        raise DocumentationError("doc-manifest.json must be an array of relative paths")

    normalized: list[str] = []
    for raw in data:
        value = raw.replace("\\", "/")
        path = PurePosixPath(value)
        if path.is_absolute() or not path.parts or any(part in {"", ".", ".."} for part in path.parts):
            raise DocumentationError(f"unsafe generated path in doc manifest: {raw!r}")
        normalized.append(path.as_posix())
    if len(normalized) != len(set(normalized)):
        raise DocumentationError("doc-manifest.json contains duplicate paths")
    for value in normalized:
        path = BUILD_ROOT.joinpath(*PurePosixPath(value).parts)
        if not path.is_file():
            raise DocumentationError(f"doc manifest names a missing file: {value}")
    return set(normalized)


def parse_module_page(relative: str) -> dict[str, list[DeclarationBlock]]:
    path = BUILD_ROOT.joinpath(*PurePosixPath(relative).parts)
    parser = ModulePageParser()
    parser.feed(path.read_text(encoding="utf-8"))
    parser.close()
    return parser.declarations


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
        raise DocumentationError("could not resolve git HEAD for source-link validation")
    head = result.stdout.strip()
    if re.fullmatch(r"[0-9a-f]{40}", head) is None:
        raise DocumentationError(f"git HEAD is not a full commit hash: {head!r}")
    return head


def file_uri_path(href: str) -> str:
    normalized = href.replace("\\", "/")
    parsed = urlsplit(normalized)
    if parsed.scheme.lower() != "file":
        raise DocumentationError(f"expected a file source link, found {href!r}")
    combined = unquote((parsed.netloc + parsed.path).replace("\\", "/"))
    return combined.removeprefix("/") if re.match(r"^/[A-Za-z]:/", combined) else combined


def check_source_link(
    *,
    declaration: str,
    module: str,
    href: str | None,
    source_mode: str,
    head: str | None,
    source_line: int,
) -> None:
    if href is None:
        raise DocumentationError(f"{declaration}: generated declaration has no source link")
    expected_relative = module_source(module)

    if source_mode == "file":
        actual = file_uri_path(href)
        expected_path = (ROOT / expected_relative).resolve()
        try:
            actual_path = Path(actual).resolve(strict=True)
        except OSError as exc:
            raise DocumentationError(
                f"{declaration}: file source link does not resolve: {actual!r}"
            ) from exc
        if os.path.normcase(str(actual_path)) != os.path.normcase(str(expected_path)):
            raise DocumentationError(
                f"{declaration}: file source link points to {actual_path!s}, "
                f"expected {expected_path!s}"
            )
        return

    assert head is not None
    expected_prefix = f"{REPOSITORY_URL}/blob/{head}/{expected_relative}"
    if not href.startswith(expected_prefix + "#"):
        raise DocumentationError(
            f"{declaration}: GitHub source link is not pinned to the expected file/HEAD: {href}"
        )
    if re.search(r"/blob/(?:master|main|HEAD)/", href, re.IGNORECASE):
        raise DocumentationError(f"{declaration}: mutable branch source link: {href}")
    match = re.fullmatch(re.escape(expected_prefix) + r"#L(\d+)-L(\d+)", href)
    if match is None:
        raise DocumentationError(f"{declaration}: missing GitHub line range: {href}")
    start, end = (int(match.group(1)), int(match.group(2)))
    source_lines = (ROOT / expected_relative).read_text(encoding="utf-8").splitlines()
    line_count = len(source_lines)
    if not (1 <= start <= source_line <= end <= line_count):
        raise DocumentationError(
            f"{declaration}: invalid source range L{start}-L{end}; "
            f"expected a bounded range containing declaration line L{source_line} "
            f"in a {line_count}-line file"
        )


def check_equations_disabled() -> None:
    database = BUILD_ROOT / "api-docs.db"
    if not database.is_file():
        raise DocumentationError(f"missing doc-gen database: {database.relative_to(ROOT)}")
    try:
        with sqlite3.connect(f"file:{database.as_posix()}?mode=ro", uri=True) as connection:
            row = connection.execute("SELECT COUNT(*) FROM definition_equations").fetchone()
    except sqlite3.Error as exc:
        raise DocumentationError(f"could not inspect doc-gen equation policy: {exc}") from exc
    equation_count = int(row[0]) if row is not None else -1
    if equation_count != 0:
        raise DocumentationError(
            "maintained API docs must omit optional definition equations, but "
            f"the generated database contains {equation_count} equation rows"
        )


def check_api_docs(source_mode: str) -> None:
    public_api = load_public_api()
    generated = load_generated_manifest()
    check_equations_disabled()

    for relative in REQUIRED_OUTPUTS:
        path = BUILD_ROOT.joinpath(*PurePosixPath(relative).parts)
        if not path.is_file():
            raise DocumentationError(f"missing standard doc-gen output: {relative}")

    supported_modules = [str(module) for module in public_api["supported_modules"]]
    non_stable_modules = [str(module) for module in public_api["non_stable_modules"]]
    expected_pages = {module_page(module) for module in supported_modules}
    generated_local_pages = {
        value
        for value in generated
        if value.endswith(".html")
        and (value == "doc/LeanInfoTheory.html" or value.startswith("doc/LeanInfoTheory/"))
    }
    if generated_local_pages != expected_pages:
        missing = sorted(expected_pages - generated_local_pages)
        extra = sorted(generated_local_pages - expected_pages)
        raise DocumentationError(
            "generated local module closure differs from the frozen supported closure: "
            f"missing={missing}, extra={extra}"
        )

    filesystem_local_pages = {
        path.relative_to(BUILD_ROOT).as_posix()
        for path in DOC_ROOT.rglob("*.html")
        if path.relative_to(DOC_ROOT).as_posix() == "LeanInfoTheory.html"
        or path.relative_to(DOC_ROOT).as_posix().startswith("LeanInfoTheory/")
    }
    if filesystem_local_pages != expected_pages:
        missing = sorted(expected_pages - filesystem_local_pages)
        extra = sorted(filesystem_local_pages - expected_pages)
        raise DocumentationError(
            "generated directory contains stale or missing local module pages: "
            f"missing={missing}, extra={extra}"
        )

    leaked_non_stable = sorted(
        module for module in non_stable_modules if module_page(module) in generated_local_pages
    )
    if leaked_non_stable:
        raise DocumentationError(
            "non-stable local modules leaked into generated API docs: "
            + ", ".join(leaked_non_stable)
        )

    pages = {module: parse_module_page(module_page(module)) for module in supported_modules}
    source_index = {decl.name: decl for decl in api_index.all_declarations()}
    declarations = list(public_api["declarations"])
    if len(declarations) != 601:
        raise DocumentationError(
            f"expected 601 frozen declarations, found {len(declarations)}"
        )

    head = git_head() if source_mode == "github" else None
    checked_names: set[str] = set()
    for declaration in declarations:
        name = str(declaration["name"])
        module = str(declaration["module"])
        if name in checked_names:
            raise DocumentationError(f"duplicate declaration in public manifest: {name}")
        checked_names.add(name)
        blocks = pages[module].get(name, [])
        if len(blocks) != 1:
            raise DocumentationError(
                f"{name}: expected one generated block in {module}, found {len(blocks)}"
            )
        block = blocks[0]
        if "sorried" in block.classes:
            raise DocumentationError(f"{name}: doc-gen marked the declaration as sorried")
        header = normalize_text(block.header_text)
        rendered_type = normalize_text(block.type_text)
        compact_header = re.sub(r"\s*\.\s*", ".", header)
        if not header or name not in compact_header or ":" not in header:
            raise DocumentationError(f"{name}: incomplete rendered declaration header: {header!r}")
        if not rendered_type:
            raise DocumentationError(f"{name}: rendered declaration type is empty")
        source = source_index.get(name)
        if source is None or source.module != module:
            raise DocumentationError(f"{name}: source inventory owner differs from {module}")
        check_source_link(
            declaration=name,
            module=module,
            href=block.source_href,
            source_mode=source_mode,
            head=head,
            source_line=source.line,
        )

    exports = list(public_api["root_exports"])
    if len(exports) != 92:
        raise DocumentationError(f"expected 92 root exports, found {len(exports)}")
    for export in exports:
        alias = str(export["alias"])
        target = str(export["target"])
        if target not in checked_names:
            raise DocumentationError(f"{alias}: export target is outside the frozen API: {target}")
        target_module = str(next(item["module"] for item in declarations if item["name"] == target))
        if len(pages[target_module].get(target, [])) != 1:
            raise DocumentationError(f"{alias}: canonical target has no generated anchor: {target}")

    local_sorried = sorted(
        name
        for declarations_by_name in pages.values()
        for name, blocks in declarations_by_name.items()
        if any("sorried" in block.classes for block in blocks)
    )
    if local_sorried:
        raise DocumentationError(
            "generated supported-module declarations marked sorried: "
            + ", ".join(local_sorried)
        )

    files = [path for path in DOC_ROOT.rglob("*") if path.is_file()]
    total_bytes = sum(path.stat().st_size for path in files)
    mode_note = "local/unpublished file links" if source_mode == "file" else f"commit {head}"
    print(
        "API documentation contract passed: "
        f"{len(supported_modules)} supported module pages, {len(checked_names)} "
        f"signature-bearing declarations, {len(exports)} export targets, "
        f"{len(non_stable_modules)} non-stable exclusions, zero equation rows; "
        f"{len(files)} files, "
        f"{total_bytes / (1024 * 1024):.1f} MiB; {mode_note}"
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-mode", choices=("file", "github"), required=True)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        check_api_docs(args.source_mode)
    except (DocumentationError, OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"API documentation validation failed: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
