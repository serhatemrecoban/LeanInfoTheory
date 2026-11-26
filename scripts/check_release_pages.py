"""Validate the mounted release sites, including frozen API snapshots."""
from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass
import hashlib
import html
from html.parser import HTMLParser
import json
from pathlib import Path
import posixpath
import re
import subprocess
from urllib.parse import unquote, urlsplit, urlunsplit

import check_api_docs
import check_website as checks
import generate_website_api_index as discovery
import prepare_publication as publication
import split_website as split


class SplitLinks(checks.WebsiteValidator):
    def __init__(self, site: Path, commit: str):
        super().__init__(site, "split", expected_commit=commit)
        self.main = split.MAIN_NAME + "/"
        self.frozen = self.main + checks.VERSION_ROUTE + "/"
        self.current = publication.API_NAME + "/" + publication.API_VERSION + "/"
        self.hosts = (self.main, publication.API_NAME + "/")

    def canonical(self, text: str) -> str:
        return text.replace(self.frozen, checks.VERSION_ROUTE + "/").replace(
            self.current, checks.CURRENT_ROUTE + "/")

    def advisory_coordinates(self, message: str) -> str:
        """Compare the mounted result in the original snapshot's coordinate system."""
        source, detail = message.split(": ", 1)
        for mount, original in ((self.frozen, checks.VERSION_ROUTE), (self.current, checks.CURRENT_ROUTE)):
            if not source.startswith(mount):
                continue
            description, separator, target = detail.rpartition(" -> ")
            if not separator:
                raise ValueError("unexpected dependency advisory: " + message)
            # A few upstream hrefs point above the snapshot. Keep the actual
            # href and failure, translating only the reported filesystem path.
            relative = posixpath.relpath(target, mount.rstrip("/"))
            reported = posixpath.normpath(posixpath.join(original, relative))
            return f"{original}/{source[len(mount):]}: {description} -> {reported}"
        raise ValueError("dependency advisory outside the two versioned snapshots: " + message)

    def is_imported_dependency_page(self, relative: str) -> bool:
        # The two versions use the same imported package names.
        mapped = self.canonical(relative).replace(checks.CURRENT_ROUTE + "/", checks.VERSION_ROUTE + "/", 1)
        return super().is_imported_dependency_page(mapped)

    def local_target(self, source_rel: str, target: str):
        if target.startswith(("/", "https://serhatemrecoban.github.io/")) and not target.startswith("//"):
            link = urlsplit(html.unescape(target))
            if any(link.path.startswith("/" + host) for host in self.hosts):
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

    def load_files(self, sites: dict) -> None:
        # The packager already compared each inventory to the actual staged files.
        for site, inventory in sites.items():
            for rel in inventory:
                name = site + "/" + rel
                self.files.add(name)
                self.casefold_files[name.casefold()] = name
                parent = posixpath.dirname(name)
                while parent and parent not in self.directories:
                    self.directories.add(parent)
                    parent = posixpath.dirname(parent)

    def inspect(self, sites: dict) -> dict:
        self.load_files(sites)
        self.validate_links()
        baseline = checks.WebsiteValidator(self.site_root, "candidate")
        baseline.advisories = [self.advisory_coordinates(message) for message in self.advisories]
        baseline.validate_advisory_baseline()
        problems = self.errors + baseline.errors
        if problems:
            raise ValueError("Pages link and content validation failed:\n" + "\n".join(problems[:30]))
        return {"links": self.link_count, "html_pages": self.html_count,
                "reviewed_dependency_advisories": len(self.advisories)}


MAIN = "LeanInfoTheory/"
HUB = MAIN + "docs/"
GITHUB_PAGES = "https://serhatemrecoban.github.io/"
SOURCE_URL = "https://github.com/serhatemrecoban/LeanInfoTheory/blob/"
R3_ENDPOINTS = {
    "PMF.BinaryTest.exists_likelihoodThresholdTest": "LeanInfoTheory.Probability.NeymanPearson",
    "LeanInfoTheory.Shannon.exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold":
        "LeanInfoTheory.Shannon.ChannelCodingOneShot",
    "LeanInfoTheory.Shannon.isLUB_isAchievableRate": "LeanInfoTheory.Shannon.OperationalCapacity",
    "LeanInfoTheory.Shannon.exists_sourceChannelCode_tendsto_errorProbability_zero":
        "LeanInfoTheory.Shannon.SourceChannelSeparation",
    "LeanInfoTheory.Shannon.optimalPrefixLength_iid_div_bounds": "LeanInfoTheory.Shannon.PrefixCodeLengthIid",
    "LeanInfoTheory.Shannon.iid_toOuterMeasure_typeClass": "LeanInfoTheory.Shannon.TypeClassProbability",
}


@dataclass(frozen=True)
class Snapshot:
    version: str
    mount: str
    commit: str
    supported_declarations: int
    supported_modules: int
    search_declarations: int
    search_modules: int


def release_snapshots(commit: str) -> tuple[Snapshot, ...]:
    if not checks.EXACT_COMMIT_RE.fullmatch(commit):
        raise ValueError("release API source must be a full Git commit")
    return (
        Snapshot("v0.1.0", HUB + "v0.1.0/", checks.VERSION_SOURCE_COMMIT, 601, 31, 246158, 5498),
        Snapshot("v0.2.0", "LeanInfoTheory-API/v0.2.0/", "953b785fbdbcc9bffe22834124d5e1cbd14a4835",
                 811, 57, 246607, 5531),
        Snapshot("v0.3.0", "LeanInfoTheory-API-v0.3.0/v0.3.0/", commit, 918, 77, 246824, 5558),
    )


class AnchorLinks(HTMLParser):
    """Read actual selectable anchors, excluding metadata and comments."""
    def __init__(self) -> None:
        super().__init__()
        self.hrefs: list[str] = []

    def handle_starttag(self, tag: str, attrs) -> None:
        href = dict(attrs).get("href")
        if tag == "a" and href:
            self.hrefs.append(href)


class ThreeHostLinks(SplitLinks):
    def __init__(self, site: Path, sites: dict, commit: str, repository: Path):
        super().__init__(site, commit)
        self.snapshots = release_snapshots(commit)
        self.hosts = tuple(snapshot.mount.split("/")[0] + "/" for snapshot in self.snapshots)
        if set(sites) != {host.rstrip("/") for host in self.hosts}:
            raise ValueError("expected the main site and both permanent API hosts")
        self.repository = repository
        self.source_lines: dict[tuple[str, str], list[str]] = {}
        self.load_files(sites)

    def snapshot_of(self, relative: str) -> Snapshot | None:
        return next((snap for snap in self.snapshots if relative.startswith(snap.mount)), None)

    def is_imported_dependency_page(self, relative: str) -> bool:
        snap = self.snapshot_of(relative)
        return snap is not None and checks.WebsiteValidator.is_imported_dependency_page(
            self, checks.VERSION_ROUTE + "/" + relative.removeprefix(snap.mount))

    def local_target(self, source_rel: str, target: str):
        # An obsolete/incorrect API host on the same Pages origin must not escape
        # the local crawl by looking like an external URL.
        if target[:4].lower() == "http":
            parsed = urlsplit(html.unescape(target))
            project = unquote(parsed.path).lstrip("/").split("/", 1)[0]
            release_mount = project.casefold().startswith("leaninfotheory-api") or project.casefold() == "leaninfotheory"
            if parsed.hostname == "serhatemrecoban.github.io" and release_mount and (
                    project + "/" not in self.hosts or not target.startswith(GITHUB_PAGES)
                    or not parsed.path.startswith("/" + project + "/")):
                self.error(f"{source_rel}: unknown release Pages mount: {target}")
                return None, None
        return super().local_target(source_rel, target)

    def git_bytes(self, ref: str, path: str) -> bytes:
        return subprocess.check_output(["git", "--no-optional-locks", "-C", str(self.repository),
                                        "show", ref + ":" + path])

    def lines(self, ref: str, path: str) -> list[str]:
        key = (ref, path)
        if key not in self.source_lines:
            self.source_lines[key] = self.git_bytes(ref, path).decode("utf-8").splitlines()
        return self.source_lines[key]

    def validate_text_safety(self, relative: str, source: str) -> None:
        # Use the same strict GitHub URL parser as the legacy crawler, once per
        # page. The release uses a different immutable ref on each of three mounts.
        if checks.FILE_URL_LITERAL_RE.search(source) or checks.MACHINE_LOCAL_PATH_RE.search(source):
            self.error(f"{relative}: machine-local path in staged content")
        if checks.MUTABLE_GITHUB_RE.search(source):
            self.error(f"{relative}: mutable project source URL")
        snap = self.snapshot_of(relative)
        allowed = {snap.commit} if snap else {
            ref for s in self.snapshots for ref in (s.commit, s.version)
        }
        for ref, path in checks.project_blob_links(source):
            if ref not in allowed:
                self.error(f"{relative}: unexpected project source revision {ref} for {path}")

    def validate_target(self, source_rel: str, target: str) -> None:
        super().validate_target(source_rel, target)
        if target.startswith(SOURCE_URL) and "#" in target:
            parsed = urlsplit(html.unescape(target))
            line_range = re.fullmatch(r"L([0-9]+)(?:-L([0-9]+))?", parsed.fragment)
            if line_range:
                ref, path = unquote(parsed.path).split("/blob/", 1)[1].split("/", 1)
                ref = next((s.commit for s in self.snapshots if ref == s.version), ref)
                if ref not in {s.commit for s in self.snapshots}:
                    self.error(f"{source_rel}: unexpected project source revision {ref}")
                    return
                start, end = int(line_range[1]), int(line_range[2] or line_range[1])
                if not 1 <= start <= end <= len(self.lines(ref, path)):
                    self.error(f"{source_rel}: source range outside {ref}:{path}: {target}")

    def checked_advisories(self) -> dict[str, int]:
        by_version: dict[str, list[str]] = defaultdict(list)
        for message in self.advisories:
            source, detail = message.split(": ", 1)
            snap = self.snapshot_of(source)
            description, separator, destination = detail.rpartition(" -> ")
            if snap is None or not separator:
                raise ValueError("unexpected release dependency advisory: " + message)
            original = checks.VERSION_ROUTE
            relative = posixpath.relpath(destination, snap.mount.rstrip("/"))
            reported = posixpath.normpath(posixpath.join(original, relative))
            by_version[snap.version].append(
                f"{original}/{source.removeprefix(snap.mount)}: {description} -> {reported}")
        for snap in self.snapshots:
            rows = by_version[snap.version]
            actual = (len(rows), sum("missing local link" in m for m in rows),
                      sum("incorrect path casing" in m for m in rows),
                      hashlib.sha256("\n".join(sorted(rows)).encode("utf-8")).hexdigest())
            expected = checks.EXPECTED_CURRENT_DEPENDENCY_ADVISORY_BASELINE
            if snap.version == "v0.1.0":
                expected = (checks.EXPECTED_DEPENDENCY_ADVISORY_COUNT, checks.EXPECTED_DEPENDENCY_MISSING_COUNT,
                            checks.EXPECTED_DEPENDENCY_CASING_COUNT, checks.EXPECTED_DEPENDENCY_ADVISORY_SHA256)
            if actual != expected:
                raise ValueError(f"{snap.version}: reviewed dependency advisory fingerprint differs: {actual}")
        return {version: len(rows) for version, rows in by_version.items()}

    def require_destinations(self, page: str, *choices: tuple[str, ...]) -> None:
        parser = AnchorLinks()
        parser.feed((self.site_root / page).read_text(encoding="utf-8"))
        parser.close()
        destinations = {self.local_target(page, href)[0] for href in parser.hrefs}
        for alternatives in choices:
            if not any((target + "index.html" if target.endswith("/") else target) in destinations
                       for target in alternatives):
                raise ValueError(f"{page}: missing navigation to {alternatives}")

    def check_selectors(self) -> None:
        one, two, three = self.snapshots
        v2_entry, v3_entry = HUB + two.version + "/", HUB + three.version + "/"
        self.require_destinations(HUB + "index.html", (one.mount,), (v2_entry, two.mount), (v3_entry, three.mount))
        self.require_destinations(HUB + "current/index.html", (v3_entry, three.mount))
        self.require_destinations(v2_entry + "index.html", (two.mount,))
        self.require_destinations(v3_entry + "index.html", (three.mount,))
        self.require_destinations(MAIN + "index.html", (HUB,))
        for snap in self.snapshots:
            self.require_destinations(snap.mount + "navbar.html", (MAIN,), (HUB,))
        self.require_destinations(one.mount + "navbar.html", (HUB + "third-party.html",))

    def check_search(self, snap: Snapshot, manifest: dict, data: dict) -> None:
        expected = {"declarations": snap.search_declarations, "modules": snap.search_modules,
                    "instances": 1243, "instancesFor": 3082}
        if {key: len(value) for key, value in data.items()} != expected:
            raise ValueError(f"{snap.version}: incomplete search database")
        modules, results = data["modules"], data["declarations"]
        if not set(manifest["supported_modules"]).issubset(modules):
            raise ValueError(f"{snap.version}: missing supported search module")
        for name, item in modules.items():
            url = "./" + name.replace(".", "/") + ".html"
            if item["url"] != url or snap.mount + url[2:] not in self.files \
                    or any(dependent not in modules for dependent in item["importedBy"]):
                raise ValueError(f"{snap.version}: broken module navigation for {name}")
        for name, item in results.items():
            path, sep, fragment = item["docLink"].partition("#")
            if not (path.startswith("./") and sep and unquote(fragment) == name
                    and snap.mount + path[2:] in self.files):
                raise ValueError(f"{snap.version}: broken search destination for {name}")
        for kind in ("instances", "instancesFor"):
            if any(name not in results for names in data[kind].values() for name in names):
                raise ValueError(f"{snap.version}: invalid {kind} search entry")
        if results["PMF"]["docLink"] != "./Mathlib/Probability/ProbabilityMassFunction/Basic.html#PMF":
            raise ValueError(f"{snap.version}: missing PMF dependency destination")
        if snap.version != "v0.1.0" and ("PMF.instCompactSpace" not in data["instancesFor"]["PMF"]
                or "LeanInfoTheory.Shannon" not in modules["LeanInfoTheory.Shannon.ChannelCapacity"]["importedBy"]):
            raise ValueError(f"{snap.version}: dependency/import navigation changed")

    def check_snapshot(self, snap: Snapshot) -> dict:
        manifest_path = "docs/v0.1-public-api.json" if snap.version == "v0.1.0" else "docs/current-public-api.json"
        manifest = json.loads(self.git_bytes(snap.commit, manifest_path))
        index = json.loads(self.git_bytes(snap.commit, "home_page/docs/declaration_index.json"))
        locations = {item["name"]: item for item in index["declarations"]}
        owners = {item["name"]: item["module"] for item in manifest["declarations"]}
        # The source index also includes development examples outside the public contract.
        if len(owners) != snap.supported_declarations or not owners.keys() <= locations.keys() \
                or len(manifest["supported_modules"]) != snap.supported_modules:
            raise ValueError(f"{snap.version}: unexpected Git declaration inventory")
        if snap.version == "v0.3.0" and any(owners.get(name) != module for name, module in R3_ENDPOINTS.items()):
            raise ValueError("unexpected owner of a featured release theorem")
        root = self.site_root / snap.mount
        search = (root / "declarations/declaration-data.bmp").read_text(encoding="utf-8")
        for text in (search, (root / "references.bib").read_text(encoding="utf-8")):
            if checks.FILE_URL_LITERAL_RE.search(text) or checks.MACHINE_LOCAL_PATH_RE.search(text):
                raise ValueError(f"{snap.version}: machine-local path in search or bibliography data")
        data = json.loads(search)
        self.check_search(snap, manifest, data)
        runtime = (root / "search.js").read_text(encoding="utf-8")
        if not all(marker in runtime for marker in ("autocomplete_results", "search_form", "declaration-data.js")):
            raise ValueError(f"{snap.version}: missing doc-gen search runtime controls")
        by_module: dict[str, list[str]] = defaultdict(list)
        for name, module in owners.items():
            by_module[module].append(name)
        for module, names in by_module.items():
            stem = module.replace(".", "/")
            page = check_api_docs.ModulePageParser()
            source = (root / (stem + ".html")).read_text(encoding="utf-8")
            if 'id="search_form"' not in source or 'name="q"' not in source or '/search.js"' not in source:
                raise ValueError(f"{snap.version}: missing interactive search controls in {module}")
            page.feed(source)
            page.close()
            path = stem + ".lean"
            lines = self.lines(snap.commit, path)
            for name in names:
                hit = data["declarations"][name]["docLink"]
                if unquote(hit) != "./" + stem + ".html#" + name or len(page.declarations.get(name, [])) != 1:
                    raise ValueError(f"{snap.version}: search result and declaration anchor disagree for {name}")
                entry = locations[name]
                line = entry["line"]
                if entry["module"] != module or entry["path"] != path or not 1 <= line <= len(lines):
                    raise ValueError(f"{snap.version}: incorrect source index entry for {name}")
                declaration = discovery.DECL_RE.match(lines[line - 1])
                if not declaration or declaration["name"] != entry["short_name"]:
                    raise ValueError(f"{snap.version}: indexed declaration does not match source for {name}")
                prefix = SOURCE_URL + snap.commit + "/" + path
                block = page.declarations[name][0]
                if name in R3_ENDPOINTS and (block.header_text[:1] != ["theorem"] or not "".join(block.type_text).strip()):
                    raise ValueError(f"{snap.version}: missing featured theorem signature for {name}")
                link = re.fullmatch(re.escape(prefix) + r"#L(\d+)-L(\d+)", block.source_href or "")
                if not link or not 1 <= int(link[1]) <= line <= int(link[2]) <= len(lines):
                    raise ValueError(f"{snap.version}: declaration source range does not match {name}: {block.source_href}")
        return {"commit": snap.commit, "checked_source_ranges": len(owners),
                "search_results": len(data["declarations"]), "search_modules": len(data["modules"])}

    def navigation(self) -> dict:
        self.check_selectors()
        results = {snap.version: self.check_snapshot(snap) for snap in self.snapshots}
        if self.errors:
            raise ValueError("failed release navigation:\n" + "\n".join(self.errors[:30]))
        return results


def check_three_host_navigation(site: Path, sites: dict, commit: str, *,
                                repository: Path = checks.ROOT) -> dict:
    """Fast local probe of all three versions' selectors, search indexes, anchors and Git sources."""
    return ThreeHostLinks(site, sites, commit, repository).navigation()


def check_three_host_links(site: Path, sites: dict, commit: str, *, repository: Path = checks.ROOT) -> dict:
    """Check three complete staged hosts, against exact Git objects and advisory fingerprints."""
    validator = ThreeHostLinks(site, sites, commit, repository)
    navigation = validator.navigation()
    validator.validate_links()
    if validator.errors:
        raise ValueError("failed release crawl:\n" + "\n".join(validator.errors[:30]))
    advisories = validator.checked_advisories()
    return {"snapshots": navigation, "featured_theorems": sorted(R3_ENDPOINTS),
            "html_pages": validator.html_count, "links": validator.link_count,
            "reviewed_dependency_advisories": advisories}
