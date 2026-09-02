#!/usr/bin/env python3
"""Assemble the LeanInfoTheory website and versioned doc-gen reference.

The generated API tree is intentionally kept out of Git. This script creates
one disposable Pages-shaped artifact under ``.lake/website-stage``. Local
preview mode removes machine-local ``file:`` links and marks the result as
unpublishable. Release mode accepts only the immutable ``v0.1.0`` checkout.
Maintenance mode combines the current hand-written site with the already
validated, immutable ``v0.1.0`` API route.
"""

from __future__ import annotations

import argparse
import hashlib
import html
import json
import os
import re
import shutil
import subprocess
import tempfile
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[1]
SITE_SOURCE = ROOT / "home_page"
DOC_SOURCE = ROOT / "docbuild" / ".lake" / "build" / "doc"
DOC_CONFIG = ROOT / "docbuild" / ".lake" / "build" / "api-doc-build-config.json"
DOC_ATTESTATION = ROOT / "docbuild" / ".lake" / "build" / "api-doc-build-attestation.json"
STAGE_PARENT = ROOT / ".lake" / "website-stage"
STAGE_ROOT = STAGE_PARENT / "LeanInfoTheory"
VERSION = "v0.1.0"
VERSION_ROUTE = Path("docs") / VERSION
ROOT_MARKER = "website-stage.json"
PREVIEW_MARKER = "NOT_FOR_PUBLICATION.txt"
VERSION_STAGE_METADATA = "leaninfotheory-stage.json"

REPOSITORY_URL = "https://github.com/serhatemrecoban/LeanInfoTheory"
VERSION_TAG_OBJECT = "bcd9090ea2720fe14b0a3e168c76ebeef1dafd47"
VERSION_SOURCE_COMMIT = "0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f"
VERSION_STAGE_SCHEMA = "lean-info-theory.website-stage.v1"
COMPOSITION_STAGE_SCHEMA = "lean-info-theory.website-stage.v2"

DOCGEN_REVISION = "e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015"
LEAN_REVISION = "819816b2e0a3bf405af45ae5c7af2491d8f5bee6"
MATHLIB_REVISION = "0df444a360eaa60ab8c11dca51a86af692955474"
REPARSE_POINT_ATTRIBUTE = 0x400

FILE_SOURCE_LINK_RE = re.compile(r'<a href="file:[^"]*">source</a>', re.IGNORECASE)
FILE_URL_RE = re.compile(r'\b(?:href|src)="file:', re.IGNORECASE)
MUTABLE_GITHUB_RE = re.compile(
    r"https://github\.com/serhatemrecoban/LeanInfoTheory/blob/(?:master|main|HEAD)/",
    re.IGNORECASE,
)
RELEASE_TAG_SOURCE = (
    f"{REPOSITORY_URL}/blob/{VERSION}/"
)
URL_TOKEN_RE = re.compile(r"https?:[^\"'<>\s]+", re.IGNORECASE)
PROJECT_LEAN_BLOB_RE = re.compile(
    r"(?P<prefix>" + re.escape(REPOSITORY_URL) + r"/blob/)"
    r"(?P<ref>[^/]+)"
    r"(?P<path>/LeanInfoTheory(?:\.lean|/[^\"'<>\s?#]*\.lean))",
    re.IGNORECASE,
)

DOCGEN_STATIC_ASSETS = (
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

EXTERNAL_RUNTIME = (
    "https://cdnjs.cloudflare.com/ajax/libs/lato-font/3.0.0/css/lato-font.min.css",
    "https://cdnjs.cloudflare.com/ajax/libs/juliamono/0.051/juliamono.css",
    "https://cdnjs.cloudflare.com/polyfill/v3/polyfill.min.js?features=es6",
    "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js",
)

PACKAGE_LICENSES = (
    ("doc-gen4", "doc-gen4", "doc-gen4", ("generated static assets",)),
    ("aesop", "aesop", "Aesop", ("Aesop",)),
    ("batteries", "batteries", "Batteries", ("Batteries",)),
    ("importGraph", "importGraph", "ImportGraph", ("ImportGraph",)),
    ("LeanSearchClient", "LeanSearchClient", "LeanSearchClient", ("LeanSearchClient",)),
    ("mathlib", "mathlib", "Mathlib", ("Mathlib",)),
    ("plausible", "plausible", "Plausible", ("Plausible",)),
    ("proofwidgets", "proofwidgets", "ProofWidgets", ("ProofWidgets",)),
    ("Qq", "Qq", "Qq", ("Qq",)),
)

LEAN_DOC_ROOTS = ("Init", "Lake", "Lean", "Std")


class StagingError(RuntimeError):
    """The requested website artifact would violate the staging contract."""


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


def run(command: list[str], *, cwd: Path = ROOT) -> str:
    result = subprocess.run(
        command,
        cwd=cwd,
        text=True,
        encoding="utf-8",
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise StagingError(
            f"command failed ({' '.join(command)}):\n{result.stdout}{result.stderr}"
        )
    return result.stdout.strip()


def display_path(path: Path) -> str:
    try:
        return path.relative_to(ROOT).as_posix()
    except ValueError:
        return str(path)


def load_json(path: Path) -> dict[str, object]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as exc:
        raise StagingError(f"missing required file: {display_path(path)}") from exc
    if not isinstance(value, dict):
        raise StagingError(f"expected a JSON object: {display_path(path)}")
    return value


def is_redirected_path(path: Path) -> bool:
    if path.is_symlink():
        return True
    try:
        attributes = int(getattr(os.lstat(path), "st_file_attributes", 0))
    except FileNotFoundError:
        return False
    return bool(attributes & REPARSE_POINT_ATTRIBUTE)


def absolute_without_resolving(path: Path) -> Path:
    """Return an absolute lexical path without following links or junctions."""

    return Path(os.path.abspath(path))


def require_unredirected_components(path: Path, *, label: str) -> Path:
    """Reject a redirect in any existing component before resolving ``path``."""

    absolute = absolute_without_resolving(path)
    current = Path(absolute.anchor)
    for component in absolute.parts[1:]:
        current /= component
        if is_redirected_path(current):
            raise StagingError(f"{label} contains a redirected path component: {current}")
    return absolute


def require_unredirected_tree(path: Path, *, label: str) -> None:
    """Reject a redirected root or descendant before copying or fingerprinting."""

    root = require_unredirected_components(path, label=label)
    if not root.is_dir():
        raise StagingError(f"{label} is not a directory: {root}")
    for candidate in root.rglob("*"):
        if is_redirected_path(candidate):
            raise StagingError(f"{label} contains a redirected path: {candidate}")


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


def tree_digest(root: Path) -> tuple[str, int, int, int]:
    if is_redirected_path(root):
        raise StagingError(f"documentation input root is redirected: {root}")
    paths = sorted(
        root.rglob("*"),
        key=lambda path: path.relative_to(root).as_posix(),
    )
    digest = hashlib.sha256()
    file_count = 0
    html_count = 0
    byte_count = 0
    for path in paths:
        relative = path.relative_to(root).as_posix()
        if is_redirected_path(path):
            raise StagingError(f"documentation input contains a redirected path: {relative}")
        if path.is_dir():
            continue
        if not path.is_file():
            raise StagingError(f"unsupported documentation input entry: {relative}")
        content = path.read_bytes()
        digest.update(relative.encode("utf-8"))
        digest.update(b"\0")
        digest.update(content)
        digest.update(b"\0")
        file_count += 1
        html_count += path.suffix.lower() == ".html"
        byte_count += len(content)
    return digest.hexdigest(), file_count, html_count, byte_count


def validate_attestation(
    config: dict[str, object], *, doc_source: Path, attestation_path: Path
) -> dict[str, object]:
    attestation = load_json(attestation_path)
    if attestation.get("schema") != "lean-info-theory.api-doc-attestation.v1":
        raise StagingError("API-doc attestation has an unsupported schema")
    if attestation.get("configuration") != config:
        raise StagingError("API-doc attestation does not match the active build configuration")
    if attestation.get("validated_passes") != 2:
        raise StagingError("API-doc attestation does not record both validated build passes")
    relevant_digest = str(attestation.get("relevant_output_sha256", ""))
    recorded_tree_digest = str(attestation.get("doc_tree_sha256", ""))
    if re.fullmatch(r"[0-9a-f]{64}", relevant_digest) is None:
        raise StagingError("API-doc attestation has no valid relevant-output digest")
    if re.fullmatch(r"[0-9a-f]{64}", recorded_tree_digest) is None:
        raise StagingError("API-doc attestation has no valid full-tree digest")
    observed_tree_digest, file_count, html_count, byte_count = tree_digest(doc_source)
    observed = {
        "doc_tree_sha256": observed_tree_digest,
        "doc_files": file_count,
        "doc_html_files": html_count,
        "doc_bytes": byte_count,
    }
    for key, value in observed.items():
        if attestation.get(key) != value:
            raise StagingError(
                f"API-doc attestation {key} mismatch: "
                f"recorded {attestation.get(key)!r}, observed {value!r}"
            )
    return attestation


def validate_inputs(
    mode: str,
) -> tuple[dict[str, object], str | None, dict[str, object]]:
    if not SITE_SOURCE.is_dir():
        raise StagingError("home_page is missing")
    if not DOC_SOURCE.is_dir():
        raise StagingError(
            "signature-bearing documentation is missing; run the maintained "
            "api-docs gate before staging"
        )
    input_roots = (
        SITE_SOURCE,
        ROOT / "docbuild" / ".lake",
        DOC_SOURCE.parent,
        DOC_SOURCE,
    )
    for path in input_roots:
        if path.exists() and is_redirected_path(path):
            raise StagingError(f"staging input root is redirected: {path.relative_to(ROOT)}")
    for path in (SITE_SOURCE, DOC_SOURCE):
        require_unredirected_tree(path, label="staging input")

    config = load_json(DOC_CONFIG)
    expected_config = {
        "schema": "lean-info-theory.api-doc-build-config.v1",
        "docgen_revision": DOCGEN_REVISION,
        "lean_revision": LEAN_REVISION,
        "mathlib_revision": MATHLIB_REVISION,
        "disable_equations": True,
    }
    for key, value in expected_config.items():
        if config.get(key) != value:
            raise StagingError(
                f"API-doc configuration {key}: expected {value!r}, found {config.get(key)!r}"
            )
    source_mode = config.get("source_mode")
    if mode == "preview":
        if source_mode != "file":
            raise StagingError(
                f"preview mode requires file-mode doc-gen output, found {source_mode!r}"
            )
        return config, None, validate_attestation(
            config, doc_source=DOC_SOURCE, attestation_path=DOC_ATTESTATION
        )

    if source_mode != "github":
        raise StagingError(
            f"release mode requires GitHub-mode doc-gen output, found {source_mode!r}"
        )
    status = run(["git", "status", "--porcelain", "--untracked-files=normal"])
    if status:
        raise StagingError("release staging requires a completely clean Git checkout")
    commit = run(["git", "rev-parse", "HEAD"])
    if re.fullmatch(r"[0-9a-f]{40}", commit) is None:
        raise StagingError(f"HEAD is not an exact 40-character commit: {commit!r}")
    if config.get("source_identity") != commit:
        raise StagingError(
            "doc-gen source identity does not match the exact clean HEAD: "
            f"{config.get('source_identity')!r} != {commit}"
        )
    if commit != VERSION_SOURCE_COMMIT:
        raise StagingError(
            "release staging is reserved for the immutable v0.1.0 source commit: "
            f"{commit} != {VERSION_SOURCE_COMMIT}"
        )
    return config, commit, validate_attestation(
        config, doc_source=DOC_SOURCE, attestation_path=DOC_ATTESTATION
    )


def validate_owned_destination() -> None:
    root_resolved = ROOT.resolve(strict=True)
    expected_parent = root_resolved / ".lake" / "website-stage"
    expected = expected_parent / "LeanInfoTheory"
    for component in (ROOT / ".lake", STAGE_PARENT, STAGE_ROOT):
        if component.exists() and is_redirected_path(component):
            raise StagingError(f"refusing redirected staging path: {component}")
    if STAGE_PARENT.resolve(strict=False) != expected_parent:
        raise StagingError(f"refusing unexpected staging parent: {STAGE_PARENT}")
    if STAGE_ROOT.resolve(strict=False) != expected:
        raise StagingError(f"refusing unexpected staging destination: {STAGE_ROOT}")
    if not STAGE_ROOT.exists():
        return
    marker_path = STAGE_ROOT / ROOT_MARKER
    try:
        marker = json.loads(marker_path.read_text(encoding="utf-8"))
    except (FileNotFoundError, json.JSONDecodeError) as exc:
        raise StagingError(
            f"refusing to replace an unowned directory: {STAGE_ROOT}"
        ) from exc
    if marker.get("schema") not in {VERSION_STAGE_SCHEMA, COMPOSITION_STAGE_SCHEMA}:
        raise StagingError(f"refusing to replace an unrecognized staging tree: {STAGE_ROOT}")


def transform_doc_html(
    source: str, *, mode: str, relative: Path
) -> tuple[str, int, int]:
    sanitized = 0
    if mode == "preview":
        source, sanitized = FILE_SOURCE_LINK_RE.subn(
            '<span title="Source links are added by the clean release-candidate build.">'
            "source unavailable in local preview</span>",
            source,
        )
    if FILE_URL_RE.search(source):
        raise StagingError(
            f"unsanitized local file URL remains in generated page: {relative.as_posix()}"
        )
    if MUTABLE_GITHUB_RE.search(source):
        raise StagingError(
            f"mutable GitHub source link in generated page: {relative.as_posix()}"
        )

    injected_top = 0
    if 'href="#top"' in source and 'id="top"' not in source:
        if source.count("<main>") != 1:
            raise StagingError(
                f"cannot add the missing top anchor in {relative.as_posix()}"
            )
        source = source.replace("<main>", '<main><a id="top"></a>', 1)
        injected_top = 1

    if relative.as_posix() == "navbar.html":
        status = (
            "<h3>Local preview — not for publication</h3>"
            if mode == "preview"
            else "<h3>Release API reference</h3>"
        )
        insertion = (
            '<nav class="nav"><h3>LeanInfoTheory v0.1.0</h3>'
            '<div class="nav_link"><a href="../">Project documentation</a></div>'
            '<div class="nav_link"><a href="../../">Project home</a></div>'
            '<div class="nav_link"><a href="../third-party.html">Third-party provenance</a></div>'
            f"{status}"
        )
        if source.count('<nav class="nav">') != 1:
            raise StagingError("doc-gen navbar template did not have one nav root")
        source = source.replace('<nav class="nav">', insertion, 1)

    if relative.as_posix() == "index.html":
        old = "<h1>Welcome to the documentation page </h1>"
        new = (
            "<h1>LeanInfoTheory v0.1.0 API reference</h1>"
            "<p>Signature-bearing documentation for the 31 supported modules and "
            "601 supported declarations. Imported dependency pages are included "
            "so rendered signatures, navigation, and search remain complete.</p>"
        )
        if source.count(old) != 1:
            raise StagingError("doc-gen index template did not have the expected heading")
        source = source.replace(old, new, 1)
    return source, sanitized, injected_top


def copy_doc_tree(destination: Path, *, mode: str) -> tuple[int, int, int, int, int]:
    file_count = 0
    html_count = 0
    byte_count = 0
    sanitized_count = 0
    top_anchor_count = 0
    for source in sorted(DOC_SOURCE.rglob("*")):
        relative = source.relative_to(DOC_SOURCE)
        target = destination / relative
        if source.is_dir():
            target.mkdir(parents=True, exist_ok=True)
            continue
        if not source.is_file():
            raise StagingError(f"unsupported documentation input: {source}")
        target.parent.mkdir(parents=True, exist_ok=True)
        file_count += 1
        byte_count += source.stat().st_size
        if source.suffix.lower() == ".html":
            html_count += 1
            rendered, count, injected_top = transform_doc_html(
                source.read_text(encoding="utf-8"), mode=mode, relative=relative
            )
            sanitized_count += count
            top_anchor_count += injected_top
            target.write_text(rendered, encoding="utf-8", newline="\n")
        else:
            shutil.copy2(source, target)
    return file_count, html_count, byte_count, sanitized_count, top_anchor_count


def docbuild_packages() -> dict[str, dict[str, object]]:
    manifest = json.loads(
        (ROOT / "docbuild" / "lake-manifest.json").read_text(encoding="utf-8")
    )
    result: dict[str, dict[str, object]] = {}
    for package in manifest.get("packages", []):
        if isinstance(package, dict) and package.get("type") == "git":
            name = str(package.get("name", "")).strip("«»")
            result[name] = package
    return result


def lean_prefix() -> Path:
    prefix = Path(run(["lake", "env", "lean", "--print-prefix"]))
    if not prefix.is_dir():
        raise StagingError(f"Lean prefix does not exist: {prefix}")
    return prefix


def stage_licenses(destination: Path, config: dict[str, object]) -> list[dict[str, object]]:
    destination.mkdir(parents=True, exist_ok=True)
    packages = docbuild_packages()
    records: list[dict[str, object]] = []

    for manifest_name, directory_name, label, doc_roots in PACKAGE_LICENSES:
        package = packages.get(manifest_name)
        if package is None:
            raise StagingError(f"missing locked documentation package: {manifest_name}")
        source = ROOT / ".lake" / "packages" / directory_name / "LICENSE"
        if not source.is_file():
            raise StagingError(f"missing upstream licence: {source.relative_to(ROOT)}")
        filename = f"{directory_name}-LICENSE.txt"
        shutil.copy2(source, destination / filename)
        records.append(
            {
                "name": label,
                "documentation_roots": list(doc_roots),
                "repository": package.get("url"),
                "revision": package.get("rev"),
                "license_file": filename,
            }
        )

    prefix = lean_prefix()
    lean_revision = config.get("lean_revision")
    for source_name, output_name in (
        ("LICENSE", "lean4-LICENSE.txt"),
        ("LICENSES", "lean4-LICENSES.txt"),
    ):
        source = prefix / source_name
        if not source.is_file():
            raise StagingError(f"missing Lean toolchain licence file: {source}")
        shutil.copy2(source, destination / output_name)
    records.append(
        {
            "name": "Lean 4, Lake, Std, and Init",
            "documentation_roots": list(LEAN_DOC_ROOTS),
            "repository": "https://github.com/leanprover/lean4",
            "revision": lean_revision,
            "license_file": "lean4-LICENSE.txt",
            "additional_licenses": "lean4-LICENSES.txt",
        }
    )

    rows = []
    for record in records:
        repo = html.escape(str(record["repository"]))
        revision = html.escape(str(record["revision"]))
        name = html.escape(str(record["name"]))
        license_file = html.escape(str(record["license_file"]))
        roots = ", ".join(html.escape(str(item)) for item in record["documentation_roots"])
        extra = ""
        if "additional_licenses" in record:
            additional = html.escape(str(record["additional_licenses"]))
            extra = f' and <a href="{additional}">{additional}</a>'
        rows.append(
            f"<li><strong>{name}</strong> ({roots}): "
            f'<a href="{repo}/tree/{revision}">exact source</a>; '
            f'<a href="{license_file}">{license_file}</a>{extra}.</li>'
        )
    index = f"""<!doctype html>
<html lang="en-US">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>API documentation licences | LeanInfoTheory</title>
    <link rel="stylesheet" href="../../../styles.css">
  </head>
  <body>
    <header class="page-header" role="banner">
      <h1 class="project-name">API Documentation Licences</h1>
      <h2 class="project-tagline">Upstream licence files carried with the assembled documentation artifact.</h2>
      <nav class="project-links" aria-label="Project links">
        <a href="../../../" class="btn">Home</a>
        <a href="../../" class="btn">Docs</a>
        <a href="../" class="btn">API reference</a>
        <a href="../../third-party.html" class="btn">Provenance</a>
      </nav>
    </header>
    <main class="main-content" role="main">
      <p class="lead">These files belong to their respective upstream projects. No EPFL/MIL project notice is applied to them.</p>
      <ul>
        {''.join(rows)}
      </ul>
      <p>The Step 14 attribution review found no concrete requirement for a root <code>NOTICE</code>; these exact upstream licence copies remain the distribution record.</p>
    </main>
  </body>
</html>
"""
    (destination / "index.html").write_text(index, encoding="utf-8", newline="\n")
    return records


def rewrite_release_source_refs(site_root: Path, commit: str) -> int:
    replacement = (
        "https://github.com/serhatemrecoban/LeanInfoTheory/blob/" + commit + "/"
    )
    count = 0
    for path in sorted(site_root.rglob("*.html")):
        source = path.read_text(encoding="utf-8")
        rendered, changed = re.subn(re.escape(RELEASE_TAG_SOURCE), replacement, source)
        if changed:
            path.write_text(rendered, encoding="utf-8", newline="\n")
            count += changed
    return count


def rewrite_current_site_source_refs(site_root: Path, commit: str) -> int:
    """Pin unversioned Lean source links to the current website commit."""

    count = 0
    for path in sorted(site_root.rglob("*.html")):
        relative = path.relative_to(site_root)
        if relative == VERSION_ROUTE or VERSION_ROUTE in relative.parents:
            continue
        source = path.read_text(encoding="utf-8")

        def replace(match: re.Match[str]) -> str:
            return match.group("prefix") + commit + match.group("path")

        rendered, changed = PROJECT_LEAN_BLOB_RE.subn(replace, source)
        if changed:
            path.write_text(rendered, encoding="utf-8", newline="\n")
            count += changed
    return count


def exact_commit(repository: Path) -> str:
    commit = run(["git", "rev-parse", "HEAD"], cwd=repository)
    if re.fullmatch(r"[0-9a-f]{40}", commit) is None:
        raise StagingError(f"HEAD is not an exact 40-character commit: {commit!r}")
    return commit


def require_clean_checkout(repository: Path, *, label: str) -> None:
    status = run(
        ["git", "status", "--porcelain", "--untracked-files=normal"],
        cwd=repository,
    )
    if status:
        raise StagingError(f"{label} requires a completely clean Git checkout")


def validate_current_maintenance_checkout() -> str:
    require_clean_checkout(ROOT, label="maintenance staging")
    branch = run(["git", "branch", "--show-current"])
    commit = exact_commit(ROOT)
    if branch == "":
        workflow_sha = os.environ.get("GITHUB_SHA", "")
        if os.environ.get("GITHUB_ACTIONS") != "true" or workflow_sha != commit:
            raise StagingError(
                "detached maintenance staging is allowed only in GitHub Actions "
                "when GITHUB_SHA matches the checked-out commit"
            )
    elif branch != "master":
        raise StagingError(
            "maintenance staging is reserved for master or its bound detached CI commit, "
            f"found {branch!r}"
        )
    tag_object = run(["git", "rev-parse", VERSION])
    if tag_object != VERSION_TAG_OBJECT:
        raise StagingError(
            f"{VERSION} tag object changed: {tag_object} != {VERSION_TAG_OBJECT}"
        )
    tag_commit = run(["git", "rev-parse", f"{VERSION}^{{commit}}"])
    if tag_commit != VERSION_SOURCE_COMMIT:
        raise StagingError(
            f"{VERSION} no longer resolves to the immutable release commit: "
            f"{tag_commit} != {VERSION_SOURCE_COMMIT}"
        )
    return commit


def validate_frozen_artifact(
    frozen_source_root: Path, frozen_site_root: Path
) -> tuple[Path, bytes, str, int, int, int, int]:
    raw_source_root = require_unredirected_components(
        frozen_source_root, label="frozen source root"
    )
    raw_site_root = require_unredirected_components(
        frozen_site_root, label="frozen site root"
    )
    source_root = raw_source_root.resolve(strict=True)
    site_root = raw_site_root.resolve(strict=True)
    expected_site_root = (
        source_root / ".lake" / "website-stage" / "LeanInfoTheory"
    ).resolve(strict=True)
    if site_root != expected_site_root:
        raise StagingError(
            "frozen site must be the owned release artifact under its exact source "
            f"checkout: {site_root} != {expected_site_root}"
        )
    require_clean_checkout(source_root, label="frozen v0.1.0 staging")
    frozen_commit = exact_commit(source_root)
    if frozen_commit != VERSION_SOURCE_COMMIT:
        raise StagingError(
            "frozen API source checkout is not the immutable v0.1.0 commit: "
            f"{frozen_commit} != {VERSION_SOURCE_COMMIT}"
        )

    version_dir = site_root / VERSION_ROUTE
    root_metadata_path = site_root / ROOT_MARKER
    version_metadata_path = version_dir / VERSION_STAGE_METADATA
    require_unredirected_tree(version_dir, label="frozen version route")
    for path in (root_metadata_path, version_metadata_path):
        if is_redirected_path(path):
            raise StagingError(f"frozen release metadata is redirected: {path}")
    try:
        root_metadata_bytes = root_metadata_path.read_bytes()
        version_metadata_bytes = version_metadata_path.read_bytes()
    except FileNotFoundError as exc:
        raise StagingError(f"frozen release artifact is missing metadata: {exc.filename}") from exc
    if root_metadata_bytes != version_metadata_bytes:
        raise StagingError("frozen release root and version metadata are not byte-identical")
    try:
        metadata = json.loads(version_metadata_bytes.decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise StagingError("frozen release metadata is not valid UTF-8 JSON") from exc
    if not isinstance(metadata, dict):
        raise StagingError("frozen release metadata is not a JSON object")
    expected_metadata = {
        "schema": VERSION_STAGE_SCHEMA,
        "version": VERSION,
        "route": f"/{VERSION_ROUTE.as_posix()}/",
        "mode": "release",
        "publishable": True,
        "source_mode": "github",
        "source_identity": VERSION_SOURCE_COMMIT,
    }
    for key, value in expected_metadata.items():
        if metadata.get(key) != value:
            raise StagingError(
                f"frozen release metadata {key}: expected {value!r}, "
                f"found {metadata.get(key)!r}"
            )
    if (version_dir / PREVIEW_MARKER).exists():
        raise StagingError("frozen release artifact contains NOT_FOR_PUBLICATION")

    link_count = 0
    for path in sorted(version_dir.rglob("*")):
        if not path.is_file() or path.suffix.lower() not in {
            ".css",
            ".html",
            ".js",
            ".json",
            ".md",
            ".svg",
            ".txt",
            ".xml",
        }:
            continue
        try:
            source = path.read_text(encoding="utf-8")
        except UnicodeDecodeError as exc:
            raise StagingError(f"frozen version text is not UTF-8: {path}") from exc
        try:
            links = list(project_blob_links(source))
        except ValueError as exc:
            raise StagingError(f"unsafe GitHub URL in frozen version route {path}: {exc}") from exc
        for ref, _project_path in links:
            link_count += 1
            if ref.casefold() in {"master", "main", "head"}:
                raise StagingError(
                    f"frozen version route contains a mutable project link: {path}"
                )
            if ref != VERSION_SOURCE_COMMIT:
                raise StagingError(
                    "frozen version route contains a project link outside the release "
                    f"commit in {path}: {ref}"
                )
    if link_count == 0:
        raise StagingError("frozen version route contains no checked project source links")

    digest, file_count, html_count, byte_count = tree_digest(version_dir)
    return (
        version_dir,
        version_metadata_bytes,
        digest,
        file_count,
        html_count,
        byte_count,
        link_count,
    )


def assemble_standard(mode: str) -> Path:
    config, commit, attestation = validate_inputs(mode)
    validate_owned_destination()
    STAGE_PARENT.mkdir(parents=True, exist_ok=True)
    temporary = Path(tempfile.mkdtemp(prefix=".LeanInfoTheory-", dir=STAGE_PARENT))
    try:
        site = temporary / "LeanInfoTheory"
        shutil.copytree(SITE_SOURCE, site)
        version_dir = site / VERSION_ROUTE
        if version_dir.exists():
            shutil.rmtree(version_dir)
        version_dir.mkdir(parents=True)

        file_count, html_count, byte_count, sanitized, injected_top = copy_doc_tree(
            version_dir, mode=mode
        )
        licenses = stage_licenses(version_dir / "licenses", config)
        shutil.copy2(ROOT / "LICENSE", site / "LICENSE.txt")

        rewritten = 0
        if mode == "release":
            assert commit is not None
            rewritten = rewrite_release_source_refs(site, commit)
            if rewritten == 0:
                raise StagingError("release staging did not rewrite any v0.1.0 source links")

        metadata = {
            "schema": VERSION_STAGE_SCHEMA,
            "version": VERSION,
            "route": f"/{VERSION_ROUTE.as_posix()}/",
            "mode": mode,
            "publishable": mode == "release",
            "source_mode": config.get("source_mode"),
            "source_identity": commit if commit is not None else "local paths removed",
            "docgen_revision": config.get("docgen_revision"),
            "lean_revision": config.get("lean_revision"),
            "mathlib_revision": config.get("mathlib_revision"),
            "api_doc_relevant_sha256": attestation.get("relevant_output_sha256"),
            "doc_tree_sha256": attestation.get("doc_tree_sha256"),
            "doc_files": file_count,
            "doc_html_files": html_count,
            "doc_source_bytes": byte_count,
            "sanitized_file_source_links": sanitized,
            "injected_missing_top_anchors": injected_top,
            "rewritten_release_source_links": rewritten,
            "supported_modules": 31,
            "supported_declarations": 601,
            "root_exports": 92,
            "excluded_modules": 13,
            "equation_rows": 0,
            "generated_static_assets": list(DOCGEN_STATIC_ASSETS),
            "external_runtime": list(EXTERNAL_RUNTIME),
            "license_records": licenses,
        }
        rendered_metadata = json.dumps(metadata, indent=2, sort_keys=True) + "\n"
        (version_dir / "leaninfotheory-stage.json").write_text(
            rendered_metadata, encoding="utf-8", newline="\n"
        )
        (site / ROOT_MARKER).write_text(
            rendered_metadata, encoding="utf-8", newline="\n"
        )
        if mode == "preview":
            (version_dir / PREVIEW_MARKER).write_text(
                "LOCAL PREVIEW ONLY. DO NOT UPLOAD OR DEPLOY THIS ARTIFACT.\n"
                "Machine-local doc-gen source links were removed during staging.\n",
                encoding="utf-8",
                newline="\n",
            )

        if STAGE_ROOT.exists():
            shutil.rmtree(STAGE_ROOT)
        site.replace(STAGE_ROOT)
    finally:
        if temporary.exists():
            shutil.rmtree(temporary)
    return STAGE_ROOT


def assemble_maintenance(
    *, frozen_source_root: Path, frozen_site_root: Path
) -> Path:
    site_commit = validate_current_maintenance_checkout()
    (
        frozen_version_dir,
        frozen_metadata_bytes,
        frozen_digest,
        frozen_files,
        frozen_html_files,
        frozen_bytes,
        frozen_links,
    ) = validate_frozen_artifact(frozen_source_root, frozen_site_root)
    require_unredirected_tree(SITE_SOURCE, label="current website source")
    validate_owned_destination()
    STAGE_PARENT.mkdir(parents=True, exist_ok=True)
    temporary = Path(tempfile.mkdtemp(prefix=".LeanInfoTheory-", dir=STAGE_PARENT))
    try:
        site = temporary / "LeanInfoTheory"
        shutil.copytree(SITE_SOURCE, site)
        version_dir = site / VERSION_ROUTE
        if version_dir.exists():
            shutil.rmtree(version_dir)

        rewritten = rewrite_current_site_source_refs(site, site_commit)
        if rewritten == 0:
            raise StagingError(
                "maintenance staging did not pin any current-site Lean source links"
            )
        shutil.copytree(frozen_version_dir, version_dir)
        shutil.copy2(ROOT / "LICENSE", site / "LICENSE.txt")

        copied_digest, copied_files, copied_html, copied_bytes = tree_digest(version_dir)
        copied = (copied_digest, copied_files, copied_html, copied_bytes)
        expected = (frozen_digest, frozen_files, frozen_html_files, frozen_bytes)
        if copied != expected:
            raise StagingError(
                "copied v0.1.0 route differs from the validated frozen artifact: "
                f"{copied!r} != {expected!r}"
            )

        metadata = {
            "schema": COMPOSITION_STAGE_SCHEMA,
            "version": VERSION,
            "route": f"/{VERSION_ROUTE.as_posix()}/",
            "mode": "maintenance",
            "publishable": True,
            "site_policy": "current-master",
            "site_source_identity": site_commit,
            "api_policy": "immutable-version",
            "api_source_identity": VERSION_SOURCE_COMMIT,
            "release_tag": VERSION,
            "release_tag_object": VERSION_TAG_OBJECT,
            "version_metadata_schema": VERSION_STAGE_SCHEMA,
            "version_metadata_sha256": hashlib.sha256(
                frozen_metadata_bytes
            ).hexdigest(),
            "version_route_sha256": frozen_digest,
            "version_route_files": frozen_files,
            "version_route_html_files": frozen_html_files,
            "version_route_bytes": frozen_bytes,
            "version_project_source_links": frozen_links,
            "rewritten_current_site_source_links": rewritten,
        }
        (site / ROOT_MARKER).write_text(
            json.dumps(metadata, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
            newline="\n",
        )

        if STAGE_ROOT.exists():
            shutil.rmtree(STAGE_ROOT)
        site.replace(STAGE_ROOT)
    finally:
        if temporary.exists():
            shutil.rmtree(temporary)
    return STAGE_ROOT


def assemble(
    mode: str,
    *,
    frozen_source_root: Path | None = None,
    frozen_site_root: Path | None = None,
) -> Path:
    if mode != "maintenance":
        if frozen_source_root is not None or frozen_site_root is not None:
            raise StagingError(
                "frozen source/site options are valid only in maintenance mode"
            )
        return assemble_standard(mode)
    if frozen_source_root is None or frozen_site_root is None:
        raise StagingError(
            "maintenance mode requires --frozen-source-root and --frozen-site-root"
        )
    return assemble_maintenance(
        frozen_source_root=frozen_source_root,
        frozen_site_root=frozen_site_root,
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "mode",
        choices=("preview", "release", "maintenance"),
        help=(
            "sanitize a local preview, stage the immutable release checkout, or "
            "compose current site pages with the frozen release API"
        ),
    )
    parser.add_argument(
        "--frozen-source-root",
        type=Path,
        help="exact v0.1.0 checkout used to build the frozen API artifact",
    )
    parser.add_argument(
        "--frozen-site-root",
        type=Path,
        help="validated publishable site assembled inside the v0.1.0 checkout",
    )
    args = parser.parse_args()
    try:
        output = assemble(
            args.mode,
            frozen_source_root=args.frozen_source_root,
            frozen_site_root=args.frozen_site_root,
        )
    except (OSError, StagingError, ValueError, json.JSONDecodeError) as exc:
        print(f"website staging failed: {exc}")
        return 1
    print(f"assembled {args.mode} website at {output.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
