#!/usr/bin/env python3
"""Static checks for the generated project website."""

from __future__ import annotations

import json
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urlparse


ROOT = Path(__file__).resolve().parents[1]
SITE_ROOT = ROOT / "home_page"

REQUIRED_JSON = [
    SITE_ROOT / "blueprint" / "module_graph.json",
    SITE_ROOT / "docs" / "declaration_index.json",
]


class LocalLinkParser(HTMLParser):
    def __init__(self, path: Path):
        super().__init__()
        self.path = path
        self.errors: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attr_dict = dict(attrs)
        for key in ("href", "src"):
            target = attr_dict.get(key)
            if not target:
                continue
            self._check_target(target)

    def _check_target(self, target: str) -> None:
        if target.startswith("#"):
            return
        parsed = urlparse(target)
        if parsed.scheme or target.startswith("//"):
            return

        local = target.split("#", 1)[0].split("?", 1)[0]
        if not local:
            return

        candidate = (self.path.parent / local).resolve()
        try:
            candidate.relative_to(SITE_ROOT.resolve())
        except ValueError:
            self.errors.append(f"{self.path}: local link escapes home_page: {target}")
            return

        if target.endswith("/") or candidate.is_dir():
            candidate = candidate / "index.html"

        if not candidate.exists():
            self.errors.append(f"{self.path}: missing local link {target} -> {candidate}")


def validate_json() -> list[str]:
    errors: list[str] = []
    for path in REQUIRED_JSON:
        try:
            json.loads(path.read_text(encoding="utf-8"))
        except FileNotFoundError:
            errors.append(f"missing generated JSON: {path.relative_to(ROOT)}")
        except json.JSONDecodeError as exc:
            errors.append(f"invalid JSON in {path.relative_to(ROOT)}: {exc}")
    return errors


def validate_html_links() -> list[str]:
    errors: list[str] = []
    for path in sorted(SITE_ROOT.rglob("*.html")):
        parser = LocalLinkParser(path)
        parser.feed(path.read_text(encoding="utf-8"))
        errors.extend(parser.errors)
    return errors


def main() -> None:
    errors = validate_json()
    errors.extend(validate_html_links())

    if errors:
        print("\n".join(errors))
        raise SystemExit(1)

    html_count = len(list(SITE_ROOT.rglob("*.html")))
    print(f"checked {html_count} HTML files and {len(REQUIRED_JSON)} generated JSON files")


if __name__ == "__main__":
    main()
