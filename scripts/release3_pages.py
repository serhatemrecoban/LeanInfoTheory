"""Assemble and verify three permanent Release 3 Pages mounts. No deployment."""
from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
from urllib.request import urlopen
import zipfile

import package_release_pages as pages
import prepare_publication as publication
import release3_state as r3
import split_website as split
import stage_website as stage

ROOT = stage.ROOT
MAIN = split.MAIN_NAME
V02 = "LeanInfoTheory-API"
API = r3.API_REPOSITORY.split("/")[-1]
SITES = (MAIN, V02, API)
SCHEMA = "lean-info-theory.release3-pages.v1"
C40 = "4f2cb443f74f5779324b5c3e60ce7872957c96fe"
C40_ATTESTATION = "b56880c051fa1729c4528aed0a6a0a37bc4bfd3d822c2d965b05193eab7b71cb"
V02_COMMIT = "953b785fbdbcc9bffe22834124d5e1cbd14a4835"
V02_SITE = "bd7c79fe8d0404faa656ca63e8f352c2fa1c207d6091cd3e032a8ad9798b0b87"
V02_TREE = "7a38bc64cbe7ab2ae053b8ac53f0db87443ee50af076a55d96eb1ffadb63c549"
V02_ENTRY = "8f9de9b9883524ef161c5fd633e22d9a0d514abf253d30c960638131ae3a70ef"
BUNDLE_REV = "de641b1486b1b974faa0f5524fd35b9ab2e3d799"
BUNDLE_HASHES = {
    "main": ("264e47231f2b7e8754fca143df9442a531c94c0e950576f0758dd0a9cf623e8b",
             "ee4bd5a5f23c39d3f4811a05fba8733879ed728a692d523f7179f69c9b534ae8"),
    "api": ("abc331c711fa5432c57f135335588c851178e8450828b605efe3af0421ca864a",
            "a2287c0afc1d02fd3959bf646fb48a53a10c2ca7ccca0e92a708063522869bf8"),
}
# Only these reviewed presentation files may come from the draft rather than
# the qualified producer during a rehearsal. Candidate builds use Git blobs.
REHEARSAL_ROUTES = (
    "index.html", "module-guide.html", "theorems.html", "roadmap.html", "development.html",
    "license.html", "prior-art.html", "blueprint/index.html", "sitemap.xml",
    "docs/index.html", "docs/v0.3.0/index.html", "docs/release-3-examples.html",
    "docs/getting-started.html", "docs/information-measures.html",
    "docs/markov-data-processing.html", "docs/mathlib.html", "docs/research-projects.html",
    "docs/third-party.html",
)


def filesystem_path(path: Path) -> Path:
    """Allow complete dependency trees even on Windows with legacy MAX_PATH."""
    path = stage.require_unredirected_components(path, label="release site path")
    if os.name == "nt" and not str(path).startswith("\\\\?\\"):
        return Path("\\\\?\\UNC\\" + str(path)[2:] if str(path).startswith("\\\\") else "\\\\?\\" + str(path))
    return path


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def git(source: Path, *args: str) -> bytes:
    return subprocess.check_output(["git", "--no-optional-locks", *args], cwd=source)


def recover_bundle(kind: str, scratch: Path) -> Path:
    """Recover the known historical release bytes without today's website or tag state."""
    zip_digest, tar_digest = BUNDLE_HASHES[kind]
    url = f"https://raw.githubusercontent.com/serhatemrecoban/{V02}/{BUNDLE_REV}/packages/v0.2.0/{kind}.zip"
    root = scratch / kind
    prefix = "docs/v0.1.0/" if kind == "main" else ""
    with tempfile.TemporaryFile(dir=scratch) as compressed:
        with urlopen(url, timeout=90) as response:
            shutil.copyfileobj(response, compressed)
        compressed.seek(0)
        if hashlib.file_digest(compressed, "sha256").hexdigest() != zip_digest:
            raise ValueError(f"incorrect historical {kind} ZIP")
        with zipfile.ZipFile(compressed) as archive:
            if archive.namelist() != ["artifact.tar"]:
                raise ValueError(f"unexpected historical {kind} ZIP contents")
            with archive.open("artifact.tar") as stream:
                if hashlib.file_digest(stream, "sha256").hexdigest() != tar_digest:
                    raise ValueError(f"incorrect historical {kind} TAR")
            with archive.open("artifact.tar") as stream, tarfile.open(fileobj=stream, mode="r|") as tar:
                for member in tar:
                    name = member.name.removeprefix("./")
                    if not name.startswith(prefix) or member.isdir():
                        continue
                    rel = name.removeprefix(prefix)
                    if (not member.isfile() or not rel or PurePosixPath(rel).as_posix() != rel
                            or rel.startswith("/") or ".." in PurePosixPath(rel).parts or re.search(r"[\\:]", rel)):
                        raise ValueError(f"unexpected archive member: {name}")
                    target = root / rel
                    target.parent.mkdir(exist_ok=True, parents=True)
                    with tar.extractfile(member) as payload, target.open("xb") as output:
                        shutil.copyfileobj(payload, output)
    return root


def release_html(raw: bytes, relative: str) -> bytes:
    source = raw.decode()
    if relative == "index.html":
        source = pages.exact_replace(source, "LeanInfoTheory current API — unpublished",
                                     f"LeanInfoTheory {r3.TAG} API reference")
        source = pages.exact_replace(source, "This local candidate is NOT_FOR_PUBLICATION; the stable release remains v0.1.0.",
                                     "Imported dependency pages are included for signatures, navigation and search.")
    elif relative == "navbar.html":
        source = split.normalized_nav(raw).decode()
        source = pages.exact_replace(source, "LeanInfoTheory current — unpublished", f"LeanInfoTheory {r3.TAG}")
        source = pages.exact_replace(source, "Local candidate — not for publication", "Release API reference")
    else:
        raise ValueError(f"unexpected release HTML input: {relative}")
    return source.encode()


def entry_page() -> bytes:
    return (f'<!doctype html><html lang="en"><meta charset="utf-8"><title>LeanInfoTheory {r3.TAG} API</title>'
            f'<main><h1>LeanInfoTheory {r3.TAG} API</h1><p><a href="{r3.API_URL}">Open the API reference</a></p>'
            f'<p><a href="/{MAIN}/docs/">Project documentation and versions</a></p></main></html>\n').encode()


def verify_source(source: Path, commit: str, rehearsal: bool, licenses: Path | None = None) -> tuple[dict, str]:
    if stage.exact_commit(source) != commit:
        raise ValueError("expected source differs from Git HEAD")
    stage.require_clean_checkout(source, label="documentation producer")
    build = source / "docbuild/.lake/build"
    for name in ("api-doc-build-config.json", "api-doc-build-attestation.json", "doc-manifest.json"):
        stage.require_unredirected_components(build / name, label="doc-gen input")
    config = stage.strict_object(build / "api-doc-build-config.json")
    att_path = build / "api-doc-build-attestation.json"
    att = stage.strict_object(att_path)
    att_hash = digest(att_path.read_bytes())
    if (att.get("schema") != stage.api_doc_identity.ATTESTATION_SCHEMA
            or att.get("configuration") != config or type(att.get("validated_passes")) is not int
            or att["validated_passes"] != 2 or config.get("source_mode") != "github"
            or config.get("source_identity") != commit):
        raise ValueError("exact-commit two-pass GitHub API attestation required")
    if rehearsal:
        if commit != C40 or att_hash != C40_ATTESTATION:
            raise ValueError("local rehearsal requires the exact C40-qualified documentation producer")
        # These checks and licence paths belong to the original, clean producer checkout.
        script = ("import sys;sys.path.insert(0,'scripts');import stage_website as s;"
                  "s.api_doc_identity.verify_configuration(s.strict_object(s.DOC_CONFIG))")
        subprocess.run([sys.executable, "-I", "-B", "-c", script], cwd=source, check=True)
    else:
        if r3.check_metadata(source)["phase"] != "candidate-ready":
            raise ValueError("Release 3 packaging requires candidate-ready metadata")
        from compatibility import candidate_contract
        candidate_contract.load_release3_snapshot(source)
        stage.api_doc_identity.verify_configuration(config)
    if licenses:
        if stage.run(["lean", "--githash"], cwd=source) != config["lean_revision"]:
            raise ValueError("Lean licence source differs from the documentation toolchain")
        prefix = Path(stage.run(["lean", "--print-prefix"], cwd=source))
        stage.stage_licenses(licenses, config, root=source, prefix=prefix)
    return att, att_hash


def main_files(source: Path, commit: str, rehearsal: bool, overlays: dict):
    publication.validate_tracked_site_source(source)
    paths = git(source, "ls-tree", "-rz", commit, "--", "home_page").split(b"\0")
    tracked = {}
    for entry in filter(None, paths):
        header, name = entry.split(b"\t", 1)
        mode, kind, oid = header.decode().split()
        if mode != "100644" or kind != "blob":
            raise ValueError(f"unexpected website Git entry: {name!r}")
        tracked[name.decode().removeprefix("home_page/")] = oid
    if rehearsal:
        tracked.update({rel: None for rel in REHEARSAL_ROUTES})
    for rel, oid in sorted(tracked.items()):
        if rel.startswith("docs/v0.1.0/"):
            continue
        if rel.startswith("docs/current/"):
            raise ValueError("the release packager owns docs/current/")
        if oid is None:
            path = ROOT / "home_page" / rel
            stage.require_unredirected_components(path, label="rehearsal overlay")
            raw = path.read_bytes()
            overlays["home_page/" + rel] = digest(raw)
        else:
            raw = git(source, "cat-file", "blob", oid)
        if rel.startswith("docs/v0.2.0/") and (rel != "docs/v0.2.0/index.html" or digest(raw) != V02_ENTRY):
            raise ValueError("historical v0.2.0 main entry changed")
        if rel.endswith((".html", ".json")):
            def pin(link: re.Match) -> str:
                if link["ref"] in {"master", "main", "HEAD"}:
                    return link["prefix"] + commit + link["path"]
                return link[0]
            raw = stage.PROJECT_LEAN_BLOB_RE.sub(pin, raw.decode()).encode()
        yield rel, raw
    if not {"index.html", "docs/index.html", "docs/v0.2.0/index.html", "docs/v0.3.0/index.html"}.issubset(tracked):
        raise ValueError("missing permanent main website entry")
    yield "LICENSE.txt", git(source, "show", f"{commit}:LICENSE")
    yield "docs/current/index.html", entry_page()


def historical_files(root: Path, expected: str):
    stage.require_unredirected_tree(root, label="historical release")
    h = hashlib.sha256()
    paths = sorted((p.relative_to(root).as_posix(), p) for p in root.rglob("*") if p.is_file())
    if expected == publication.HISTORICAL_DIGEST and [rel for rel, _ in paths] != pages.checked_history_files():
        raise ValueError("historical v0.1.0 route path inventory differs")
    for rel, path in paths:
        if path.stat().st_nlink != 1:
            raise ValueError(f"hard-linked historical file: {rel}")
        raw = path.read_bytes()
        h.update(rel.encode() + b"\0")
        h.update(raw)
        h.update(b"\0")
        yield rel, raw
    if h.hexdigest() != expected:
        raise ValueError("historical site differs from authenticated deployed or release bundle bytes")


def package(commit: str, historical: Path | None, v02: Path | None, output: Path | None, *,
            rehearsal_source: Path | None, check: bool) -> Path:
    if not re.fullmatch(r"[0-9a-f]{40}", commit):
        raise ValueError("a full source commit is required")
    rehearsal = rehearsal_source is not None
    source = stage.require_unredirected_components(rehearsal_source or ROOT, label="API producer")
    if rehearsal and output is None:
        raise ValueError("supply a fresh --output distinct from release artifacts for the rehearsal")
    dest = filesystem_path(output or (pages.OUTPUT / commit))
    if rehearsal and dest.is_relative_to(filesystem_path(source)):
        raise ValueError("rehearsal output must be outside the protected producer checkout")
    if dest.exists() != check:
        raise ValueError("build requires a fresh destination; check requires the previous package")
    dest.parent.mkdir(exist_ok=True, parents=True)
    tree = git(source, "rev-parse", "HEAD^{tree}").decode().strip()
    mark = {"purpose": "rehearsal" if rehearsal else "candidate", "source_identity": commit, "source_tree": tree}
    history = {"v0.1.0": {"source": stage.VERSION_SOURCE_COMMIT, "sha256": publication.HISTORICAL_DIGEST},
               "v0.2.0": {"source": V02_COMMIT, "sha256": V02_TREE, "site_sha256": V02_SITE}}
    with tempfile.TemporaryDirectory(dir=dest.parent, prefix="assemble-") as temp:
        scratch = Path(temp)
        site = dest if check else scratch / "sites"
        att, att_hash = verify_source(source, commit, rehearsal, scratch / "licenses")
        manifest = stage.strict_object(source / "docs/current-public-api.json")
        if (len(manifest["supported_modules"]), len(manifest["declarations"])) != (77, 918):
            raise ValueError("Release 3 requires 77 supported modules and 918 declarations")
        if digest((source / "docs/current-public-api.json").read_bytes()) != att["configuration"]["api_identity"]["current_manifest_sha256"]:
            raise ValueError("documentation attestation uses a different supported surface")
        files = {name: {} for name in SITES}

        def put(host: str, rel: str, raw: bytes) -> None:
            if rel in files[host]:
                raise ValueError(f"duplicate packaging input: {host}/{rel}")
            files[host][rel] = {"bytes": len(raw), "sha256": digest(raw)}
            if not check:
                target = site / host / rel
                target.parent.mkdir(exist_ok=True, parents=True)
                target.write_bytes(raw)

        overlays = {}
        for rel, raw in main_files(source, commit, rehearsal, overlays):
            put(MAIN, rel, raw)
        put(MAIN, stage.ROOT_MARKER, split.encoded({"schema": SCHEMA, **mark, "site_source_identity": commit,
            "current_api_url": r3.API_URL, "history": history, "rehearsal_overlays": overlays}))
        if rehearsal:
            for name in (MAIN, API):
                put(name, stage.PREVIEW_MARKER, b"Nonpublishable C40 rehearsal of the Release 3 routing.\n")
        old = filesystem_path(historical) if historical else recover_bundle("main", scratch)
        for rel, raw in historical_files(old, publication.HISTORICAL_DIGEST):
            put(MAIN, "docs/v0.1.0/" + rel, raw)
        second = filesystem_path(v02) if v02 else recover_bundle("api", scratch)
        for rel, raw in historical_files(second, V02_SITE):
            put(V02, rel, raw)
        version = r3.TAG + "/"
        put(API, "index.html", entry_page())
        put(API, ".nojekyll", b"")
        api_stage = split.encoded({"schema": "lean-info-theory.versioned-api.v1", **mark,
            "version": r3.TAG, "source_mode": "github", "raw_tree_sha256": att["doc_tree_sha256"],
            "validated_passes": 2, "api_attestation_sha256": att_hash, "supported_modules": 77,
            "supported_declarations": 918})
        put(API, version + stage.VERSION_STAGE_METADATA, api_stage)
        doc = filesystem_path(source / "docbuild/.lake/build/doc")
        for rel, raw in pages.api_snapshot(doc, att, manifest, commit, release_html):
            put(API, version + rel, raw)
        for rel in split.inventory(scratch / "licenses"):
            raw = (scratch / "licenses" / rel).read_bytes()
            if rel == "index.html":
                raw = publication.release_api_html(raw, "licenses/index.html")
            put(API, version + "licenses/" + rel, raw)
        sites = {}
        for name, expected in files.items():
            size = split.check_capacity(expected)
            if split.inventory(site / name) != expected:
                raise ValueError(f"actual {name} site differs from packaging inputs")
            sites[name] = {"bytes": size, "files": len(expected), "sha256": stage.tree_digest(site / name)[0]}
        if stage.tree_digest(site / V02 / "v0.2.0")[0] != V02_TREE:
            raise ValueError("v0.2.0 versioned subtree differs")
        print(f"Three mounted sites ready for full validation under {site}", flush=True)
        from check_release_pages import check_three_host_links
        navigation = check_three_host_links(site, files, commit, repository=source)
        if (att, att_hash) != verify_source(source, commit, rehearsal):
            raise ValueError("attested source changed while packaging")
        if any(digest((ROOT / p).read_bytes()) != h for p, h in overlays.items()):
            raise ValueError("rehearsal page changed while packaging")
        receipt = {"schema": SCHEMA, "source": commit, "source_tree": tree, "purpose": mark["purpose"],
                   "sites": sites, "historical": history, "rehearsal_overlays": overlays,
                   "api_attestation_sha256": att_hash, "api_stage_sha256": digest(api_stage),
                   "api_raw_sha256": att["doc_tree_sha256"], "navigation": navigation}
        if check:
            if {p.name for p in site.iterdir()} != {*SITES, "receipt.json"} or stage.strict_object(site / "receipt.json") != receipt:
                raise ValueError("unexpected Release 3 package roots or receipt")
        else:
            (site / "receipt.json").write_bytes(split.encoded(receipt))
            site.rename(dest)
    print(json.dumps(receipt, indent=2))
    return dest
