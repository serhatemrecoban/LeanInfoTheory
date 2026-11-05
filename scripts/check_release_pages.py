"""Validate links and privacy under the two GitHub Pages project prefixes."""
from __future__ import annotations

import html
from pathlib import Path
import posixpath
from urllib.parse import urlsplit, urlunsplit

import check_website as checks
import prepare_publication as publication
import split_website as split


class SplitLinks(checks.WebsiteValidator):
    def __init__(self, site: Path, commit: str):
        super().__init__(site, "split", expected_commit=commit)
        self.main = split.MAIN_NAME + "/"
        self.frozen = self.main + checks.VERSION_ROUTE + "/"
        self.current = publication.API_NAME + "/" + publication.API_VERSION + "/"

    def canonical(self, text: str) -> str:
        return text.replace(self.frozen, checks.VERSION_ROUTE + "/").replace(
            self.current, checks.CURRENT_ROUTE + "/")

    def is_imported_dependency_page(self, relative: str) -> bool:
        # The two versions use the same imported package names.
        mapped = self.canonical(relative).replace(checks.CURRENT_ROUTE + "/", checks.VERSION_ROUTE + "/", 1)
        return super().is_imported_dependency_page(mapped)

    def local_target(self, source_rel: str, target: str):
        if target.startswith(("/", "https://serhatemrecoban.github.io/")) and not target.startswith("//"):
            link = urlsplit(html.unescape(target))
            if link.path.startswith(("/" + self.main, "/" + publication.API_NAME + "/")):
                path = posixpath.relpath(link.path.lstrip("/"), posixpath.dirname(source_rel))
                if link.path.endswith("/"):
                    path += "/"
                target = urlunsplit(("", "", path, link.query, link.fragment))
        return super().local_target(source_rel, target)

    def validate_text_safety(self, relative: str, source: str) -> None:
        super().validate_text_safety(relative, source)
        if relative.startswith(self.frozen):
            allowed = {checks.VERSION_SOURCE_COMMIT}
        elif relative.startswith(self.current):
            allowed = {self.expected_commit}
        else:
            allowed = {self.expected_commit, "v0.1.0", checks.VERSION_SOURCE_COMMIT}
        for ref, path in checks.project_blob_links(source):
            if relative == self.main + "license.html" and ref == publication.API_VERSION and path == "CITATION.cff":
                continue
            if ref not in allowed:
                self.error(f"{relative}: unexpected project source revision {ref} for {path}")

    def inspect(self, sites: dict) -> dict:
        # Each site already passed its own inventory and size limit.
        for site, inventory in sites.items():
            for rel in inventory:
                name = site + "/" + rel
                self.files.add(name)
                self.casefold_files[name.casefold()] = name
                parent = posixpath.dirname(name)
                while parent and parent not in self.directories:
                    self.directories.add(parent)
                    parent = posixpath.dirname(parent)
        self.validate_links()
        baseline = checks.WebsiteValidator(self.site_root, "candidate")
        baseline.advisories = [self.canonical(message) for message in self.advisories]
        baseline.validate_advisory_baseline()
        problems = self.errors + baseline.errors
        if problems:
            raise ValueError("Pages link and content validation failed:\n" + "\n".join(problems[:30]))
        return {"links": self.link_count, "html_pages": self.html_count,
                "reviewed_dependency_advisories": len(self.advisories)}
