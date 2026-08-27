#!/usr/bin/env python3
"""Assemble the LeanInfoTheory website and versioned doc-gen reference.

The generated API tree is intentionally kept out of Git. This script creates
one disposable Pages-shaped artifact under ``.lake/website-stage``. Local
preview mode removes machine-local ``file:`` links and marks the result as
unpublishable. Release mode accepts only a clean exact-commit GitHub-source
build.
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
from pathlib import Path


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
    "https://github.com/serhatemrecoban/LeanInfoTheory/blob/v0.1.0/"
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


def run(command: list[str]) -> str:
    result = subprocess.run(
        command,
        cwd=ROOT,
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


def load_json(path: Path) -> dict[str, object]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as exc:
        raise StagingError(f"missing required file: {path.relative_to(ROOT)}") from exc
    if not isinstance(value, dict):
        raise StagingError(f"expected a JSON object: {path.relative_to(ROOT)}")
    return value


def is_redirected_path(path: Path) -> bool:
    if path.is_symlink():
        return True
    try:
        attributes = int(getattr(os.lstat(path), "st_file_attributes", 0))
    except FileNotFoundError:
        return False
    return bool(attributes & REPARSE_POINT_ATTRIBUTE)


def doc_tree_digest() -> tuple[str, int, int, int]:
    paths = sorted(
        DOC_SOURCE.rglob("*"),
        key=lambda path: path.relative_to(DOC_SOURCE).as_posix(),
    )
    digest = hashlib.sha256()
    file_count = 0
    html_count = 0
    byte_count = 0
    for path in paths:
        relative = path.relative_to(DOC_SOURCE).as_posix()
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


def validate_attestation(config: dict[str, object]) -> dict[str, object]:
    attestation = load_json(DOC_ATTESTATION)
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
    tree_digest, file_count, html_count, byte_count = doc_tree_digest()
    observed = {
        "doc_tree_sha256": tree_digest,
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
        for candidate in path.rglob("*"):
            if is_redirected_path(candidate):
                raise StagingError(
                    f"staging input contains a redirected path: {candidate.relative_to(ROOT)}"
                )

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
        return config, None, validate_attestation(config)

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
    return config, commit, validate_attestation(config)


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
    if marker.get("schema") != "lean-info-theory.website-stage.v1":
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


def assemble(mode: str) -> Path:
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
            "schema": "lean-info-theory.website-stage.v1",
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


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "mode",
        choices=("preview", "release"),
        help="sanitize and mark a local preview, or require clean exact-commit output",
    )
    args = parser.parse_args()
    try:
        output = assemble(args.mode)
    except (OSError, StagingError, ValueError, json.JSONDecodeError) as exc:
        print(f"website staging failed: {exc}")
        return 1
    print(f"assembled {args.mode} website at {output.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
