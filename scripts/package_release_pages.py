"""Build or verify the two versioned GitHub Pages artifacts, without deployment."""
from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import html
import http.client
import json
from pathlib import Path, PurePosixPath
import re
import shutil
import tempfile
import threading
import time
from urllib.parse import quote, unquote

import prepare_publication as publication
import check_website
from check_release_pages import SplitLinks
import release_state
import split_website as split
import stage_website as stage

ROOT = stage.ROOT
OUTPUT = ROOT / ".lake/release-pages"
HISTORY = ROOT / "scripts/data/pages-v0.1.0-files.txt"
RAW_EXTRAS = set(stage.DOCGEN_STATIC_ASSETS) | {
    "404.html", "declarations/declaration-data.bmp", "find/index.html",
    "foundational_types.html", "index.html", "navbar.html", "references.bib",
    "references.html", "search.html", "tactics.html",
}
DOUBLE_SLASH = re.compile(r'(\b(?:href|src)="(?:\.\./)*)\.//')
SITES = (split.MAIN_NAME, publication.API_NAME)


def exact_replace(source: str, old: str, new: str) -> str:
    if source.count(old) != 1:
        raise ValueError(f"pinned documentation asset changed at {old!r}")
    return source.replace(old, new, 1)


def api_bytes(raw: bytes, rel: str, manifest: dict, commit: str) -> bytes:
    if rel.endswith(".html"):
        source, _ = stage.transform_current_doc_html(
            raw.decode("utf-8").replace("\r\n", "\n"), relative=Path(rel), source_mode="github",
            manifest=manifest, commit=commit)
        if rel in {"index.html", "navbar.html"}:
            source = publication.release_api_html(source.encode(), rel).decode()
        return DOUBLE_SLASH.sub(r'\1./', source).encode()
    if rel in {"declaration-data.js", "find/find.js"}:
        source = raw.decode("utf-8")
        if rel == "declaration-data.js":
            source = exact_replace(source, "${SITE_ROOT}/declarations/", "${SITE_ROOT}declarations/")
        else:
            source = exact_replace(source, "window.location.replace(result.link);",
                                   "window.location.replace(result.docLink);")
        return source.encode()
    return raw


def checked_history_files() -> list[str]:
    names = HISTORY.read_text(encoding="utf-8").splitlines()
    if len(names) != publication.HISTORICAL_FILES or sorted(set(names)) != names:
        raise ValueError("invalid deployed historical file inventory")
    for name in names:
        parts = PurePosixPath(name).parts
        if not parts or PurePosixPath(name).as_posix() != name or name.startswith("/") \
                or ".." in parts or "\\" in name or ":" in name:
            raise ValueError("invalid historical path")
    return names


def recover_history(destination: Path) -> None:
    """Read the live, immutable v0.1.0 route and validate its pinned whole-tree hash."""
    names = checked_history_files()
    clients = threading.local()

    def fetch(name: str) -> None:
        for attempt in range(3):
            try:
                if getattr(clients, "connection", None) is None:
                    clients.connection = http.client.HTTPSConnection("serhatemrecoban.github.io", timeout=60)
                clients.connection.request("GET", "/LeanInfoTheory/docs/v0.1.0/" + quote(name))
                response = clients.connection.getresponse()
                if response.status != 200:
                    raise OSError(f"historical file {name}: HTTP {response.status}")
                data = response.read()
                break
            except (OSError, http.client.HTTPException):
                clients.connection.close()
                clients.connection = None
                if attempt == 2:
                    raise
                time.sleep(attempt + 1)
        target = destination / name
        target.parent.mkdir(exist_ok=True, parents=True)
        target.write_bytes(data)

    with ThreadPoolExecutor(max_workers=8) as workers:
        for _ in workers.map(fetch, names):
            pass


def public_sources(config: dict, attestation: dict, manifest: dict, commit: str, historical: Path, scratch: Path):
    historical_files = publication.historical_inventory(historical)
    if sorted(historical_files) != checked_history_files():
        raise ValueError("historical inventory differs from the deployed path list")

    main = split.MAIN_NAME
    for rel in sorted(split.inventory(stage.SITE_SOURCE)):
        if rel.startswith(("docs/v0.1.0/", "docs/current/")):
            continue
        path = stage.SITE_SOURCE / rel
        raw = path.read_bytes()
        if path.suffix in {".html", ".json"}:
            def pin(link: re.Match) -> str:
                if link["ref"] in {"master", "main", "HEAD"}:
                    return link["prefix"] + commit + link["path"]
                return link[0]
            raw = stage.PROJECT_LEAN_BLOB_RE.sub(pin, raw.decode("utf-8")).encode()
        yield main, rel, raw
    yield main, "LICENSE.txt", (ROOT / "LICENSE").read_bytes()
    yield main, stage.ROOT_MARKER, split.encoded({
        "schema": "lean-info-theory.split-release.v1", "site_source_identity": commit,
        "current_api_url": release_state.PUBLICATION["api_url"],
        "api_source_identity": stage.VERSION_SOURCE_COMMIT, "release_tag_object": stage.VERSION_TAG_OBJECT,
        "version_route_sha256": publication.HISTORICAL_DIGEST,
        "version_route_bytes": publication.HISTORICAL_BYTES, "version_route_files": publication.HISTORICAL_FILES,
    })
    yield main, "docs/current/index.html", publication.version_entry()
    for rel in sorted(historical_files):
        yield main, "docs/v0.1.0/" + rel, (historical / rel).read_bytes()

    api = publication.API_NAME
    prefix = publication.API_VERSION + "/"
    yield api, "index.html", publication.version_entry()
    yield api, prefix + stage.VERSION_STAGE_METADATA, split.encoded({
        "schema": "lean-info-theory.versioned-api.v1", "version": publication.API_VERSION,
        "source_mode": "github", "source_identity": commit,
        "raw_tree_sha256": attestation["doc_tree_sha256"], "validated_passes": attestation["validated_passes"],
    })
    module_paths = json.loads((stage.DOC_SOURCE.parent / "doc-manifest.json").read_bytes())
    if not isinstance(module_paths, list) or not all(isinstance(m, str) for m in module_paths):
        raise ValueError("unexpected doc-gen module manifest")
    modules = {p.replace("\\", "/").removeprefix("doc/") for p in module_paths}
    actual = split.inventory(stage.DOC_SOURCE)
    if len(modules) != len(module_paths) or any(not p.endswith(".html") for p in modules) \
            or set(actual) != modules | RAW_EXTRAS:
        raise ValueError("raw doc-gen files differ from the module and asset inventory")
    raw_digest = hashlib.sha256()
    for rel in sorted(actual):
        raw = (stage.DOC_SOURCE / rel).read_bytes()
        raw_digest.update(rel.encode() + b"\0")
        raw_digest.update(raw)
        raw_digest.update(b"\0")
        yield api, prefix + rel, api_bytes(raw, rel, manifest, commit)
    if raw_digest.hexdigest() != attestation["doc_tree_sha256"]:
        raise ValueError("raw API changed while building the package")
    licenses = scratch / "licenses"
    stage.stage_licenses(licenses, config)
    for rel in sorted(split.inventory(licenses)):
        raw = (licenses / rel).read_bytes()
        if rel == "index.html":
            raw = publication.release_api_html(raw, "licenses/index.html")
        yield api, prefix + "licenses/" + rel, raw
    yield api, ".nojekyll", b""


def check_navigation(site: Path, files: dict, manifest: dict) -> None:
    prefix = publication.API_VERSION + "/"
    snapshot = site / publication.API_NAME / publication.API_VERSION
    search_text = (snapshot / "declarations/declaration-data.bmp").read_text(encoding="utf-8")
    for source in (search_text, (snapshot / "references.bib").read_text(encoding="utf-8")):
        if check_website.MACHINE_LOCAL_PATH_RE.search(source) or check_website.FILE_URL_LITERAL_RE.search(source):
            raise ValueError("machine-local path in search or bibliography data")
    data = json.loads(search_text)
    modules, declarations = data["modules"], data["declarations"]
    api_files = files[publication.API_NAME]
    module_paths = json.loads((stage.DOC_SOURCE.parent / "doc-manifest.json").read_bytes())
    wanted = {p.replace("\\", "/").removeprefix("doc/") for p in module_paths}
    if {m["url"].removeprefix("./") for m in modules.values()} != wanted \
            or not set(manifest["supported_modules"]).issubset(modules):
        raise ValueError("search module inventory differs from the complete documentation build")
    # Reviewed data for the v0.2.0 toolchain, dependency pins and supported surface.
    if {k: len(v) for k, v in data.items()} != {
            "declarations": 246607, "modules": 5531, "instances": 1243, "instancesFor": 3082}:
        raise ValueError("incomplete dependency search or instance inventory")
    if "LeanInfoTheory.Shannon" not in modules["LeanInfoTheory.Shannon.ChannelCapacity"]["importedBy"] \
            or "PMF.instCompactSpace" not in data["instancesFor"]["PMF"] \
            or declarations["PMF"]["docLink"] != "./Mathlib/Probability/ProbabilityMassFunction/Basic.html#PMF":
        raise ValueError("dependency search, reverse imports or instance navigation changed")
    for name, module in modules.items():
        if set(module) != {"url", "importedBy"} or module["url"] != "./" + name.replace(".", "/") + ".html" \
                or prefix + module["url"][2:] not in api_files or any(m not in modules for m in module["importedBy"]):
            raise ValueError(f"broken API module navigation: {name}")
    for name, declaration in declarations.items():
        path, sep, fragment = declaration["docLink"].partition("#")
        if set(declaration) != {"docLink", "kind"} or not path.startswith("./") \
                or prefix + path[2:] not in api_files or not sep or unquote(fragment) != name:
            raise ValueError(f"broken declaration search result: {name}")
    for key in ("instances", "instancesFor"):
        if any(i not in declarations for instances in data[key].values() for i in instances):
            raise ValueError("broken instance navigation: " + key)
    anchors = {}
    for item in manifest["declarations"]:
        owner = item["module"].replace(".", "/") + ".html"
        link = declarations[item["name"]]["docLink"]
        if owner not in anchors:
            page = (snapshot / owner).read_text(encoding="utf-8")
            anchors[owner] = {html.unescape(s) for s in re.findall(r'\bid="([^"]+)"', page)}
        path, fragment = link.split("#", 1)
        if path != "./" + owner or unquote(fragment) not in anchors[owner]:
            raise ValueError("incorrect supported declaration owner or anchor: " + item["name"])
    navbar = (snapshot / "navbar.html").read_text(encoding="utf-8")
    for target in (split.MAIN_ROUTE, split.MAIN_ROUTE + "docs/"):
        if f'href="{target}"' not in navbar:
            raise ValueError("missing API return link: " + target)
    main_entry = (site / split.MAIN_NAME / "docs" / publication.API_VERSION / "index.html").read_text(encoding="utf-8")
    if release_state.PUBLICATION["api_url"] not in main_entry:
        raise ValueError("main website links to the wrong API destination")


def run(commit: str, history: Path | None, check: bool) -> Path:
    if not re.fullmatch("[0-9a-f]{40}", commit):
        raise ValueError("a full commit is required")
    stage.require_unredirected_components(OUTPUT, label="release Pages output")
    OUTPUT.mkdir(exist_ok=True)
    output = OUTPUT / commit
    stage.require_unredirected_components(output, label="release Pages artifact")
    if output.exists() != check:
        raise ValueError("building requires a new destination; checking requires an existing bundle")
    evidence_hash = hashlib.sha256(stage.DOC_ATTESTATION.read_bytes()).hexdigest()
    config, attestation, manifest, contract = stage.validate_candidate_inputs(commit)
    if config["source_mode"] != "github" or release_state.load_state(ROOT)["phase"] != "release-ready":
        raise ValueError("packaging requires release-ready source and two-pass GitHub documentation")
    from compatibility import candidate_contract
    retained = candidate_contract.load_approved_contract(ROOT)
    if retained["producer"]["files"] != candidate_contract.producer_identity(ROOT):
        raise ValueError("retained API producer differs")
    publication.validate_tracked_site_source(ROOT)
    with tempfile.TemporaryDirectory(dir=OUTPUT, prefix="assemble-") as temporary:
        scratch = Path(temporary)
        if history is None:
            history = scratch / "history"
            recover_history(history)
        stage.require_unredirected_components(history, label="historical API input")
        site = output if check else scratch / "pair"
        sites = {name: {} for name in SITES}
        for name, rel, raw in public_sources(config, attestation, manifest, commit, history, scratch):
            if rel in sites[name]:
                raise ValueError(f"duplicate packaging input: {name}/{rel}")
            sites[name][rel] = {"bytes": len(raw), "sha256": hashlib.sha256(raw).hexdigest()}
            if not check:
                dest = site / name / rel
                dest.parent.mkdir(exist_ok=True, parents=True)
                dest.write_bytes(raw)
        sizes = {n: split.check_capacity(v) for n, v in sites.items()}
        for name in SITES:
            if split.inventory(site / name) != sites[name]:
                raise ValueError(f"{name} package differs from exact inputs")
        if stage.tree_digest(site / split.MAIN_NAME / "docs/v0.1.0")[0] != publication.HISTORICAL_DIGEST:
            raise ValueError("packaged historical release bytes differ")
        check_navigation(site, sites, manifest)
        navigation = SplitLinks(site, commit).inspect(sites)
        receipt = {
            "source": commit, "api_attestation_sha256": evidence_hash, "navigation": navigation,
            "history_sha256": publication.HISTORICAL_DIGEST, "api_raw_sha256": attestation["doc_tree_sha256"],
            "sites": {n: {"bytes": sizes[n], "files": len(sites[n]),
                          "sha256": stage.tree_digest(site / n)[0]} for n in SITES},
        }
        if stage.validate_candidate_inputs(commit) != (config, attestation, manifest, contract) \
                or hashlib.sha256(stage.DOC_ATTESTATION.read_bytes()).hexdigest() != evidence_hash:
            raise ValueError("API inputs changed during release packaging")
        if check:
            if {p.name for p in site.iterdir()} != {*SITES, "receipt.json"} \
                    or json.loads((site / "receipt.json").read_bytes()) != receipt:
                raise ValueError("unexpected package roots or receipt")
        else:
            (site / "receipt.json").write_bytes(split.encoded(receipt))
            site.rename(output)
        print(json.dumps(receipt, indent=2))
    return output


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("build", "check"))
    parser.add_argument("--expected-commit", required=True)
    parser.add_argument("--historical-route", type=Path, help="use a previously recovered, hash-verified live route")
    args = parser.parse_args()
    run(args.expected_commit, args.historical_route, args.action == "check")


if __name__ == "__main__":
    main()
