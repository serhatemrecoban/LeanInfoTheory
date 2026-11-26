"""Resolve a reviewed Release 3 Pages archive after checking its public release.

The qualification build does not call this command. Promotion uses a separately
reviewed pins file once the tag object, release SHA and bundles exist.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
from urllib.parse import unquote
from urllib.request import Request, urlopen

from check_api_docs import ModulePageParser
from check_release_pages import R3_ENDPOINTS
import release3_state as release
from release_state import strict_json


REPO_API = "https://api.github.com/repos/serhatemrecoban/LeanInfoTheory"
SITE_NAMES = {"main": "LeanInfoTheory", "api": release.API_REPOSITORY.split("/")[1]}
MARKER = "leaninfotheory-stage.json"


def read_public(url: str) -> bytes:
    with urlopen(Request(url, headers={"User-Agent": "LeanInfoTheory-release-promotion"}),
                 timeout=60) as response:
        return response.read()


def require(ok: bool, message: str) -> None:
    if not ok:
        raise ValueError(message)


def digest(value, length: int) -> str:
    require(isinstance(value, str) and bool(re.fullmatch(f"[0-9a-f]{{{length}}}", value)),
            f"expected a {length}-digit hexadecimal identity")
    return value


def verify_live_endpoints(source: str, read) -> None:
    """Exercise the deployed search index and each featured page before the main cutover."""
    records = json.loads(read(release.API_URL + "declarations/declaration-data.bmp"))["declarations"]
    raw = f"https://raw.githubusercontent.com/serhatemrecoban/LeanInfoTheory/{source}/"
    source_index = strict_json(read(raw + "home_page/docs/declaration_index.json"))["declarations"]
    locations = {entry["name"]: entry for entry in source_index if entry["name"] in R3_ENDPOINTS}
    for name, module in R3_ENDPOINTS.items():
        stem = module.replace(".", "/")
        record = records.get(name, {})
        require(unquote(record.get("docLink", "")) == f"./{stem}.html#{name}",
                f"the live search index does not resolve {name}")
        page = ModulePageParser()
        page.feed(read(release.API_URL + stem + ".html").decode("utf-8"))
        page.close()
        blocks = page.declarations.get(name, [])
        require(len(blocks) == 1 and blocks[0].header_text[:1] == ["theorem"]
                and "".join(blocks[0].type_text).strip(), f"missing live theorem signature for {name}")
        prefix = f"https://github.com/serhatemrecoban/LeanInfoTheory/blob/{source}/{stem}.lean"
        lines = re.fullmatch(re.escape(prefix) + r"#L([1-9]\d*)-L([1-9]\d*)", blocks[0].source_href or "")
        entry = locations[name]
        lean = read(raw + stem + ".lean").decode("utf-8").splitlines()
        require(lines is not None and entry["module"] == module and entry["path"] == stem + ".lean"
                and int(lines[1]) <= entry["line"] <= int(lines[2]) <= len(lean)
                and entry["short_name"] in lean[entry["line"] - 1], f"incorrect live source link for {name}")


def resolve(site: str, pins: dict, read=read_public) -> dict:
    source = digest(pins["release_commit"], 40)
    tag = digest(pins["annotated_tag"], 40)
    rev = digest(pins["bundles_revision"], 40)
    zip_hash = digest(pins["archives"][site]["zip_sha256"], 64)
    tar_hash = digest(pins["archives"][site]["tar_sha256"], 64)

    published = strict_json(read(f"{REPO_API}/releases/tags/{release.TAG}"))
    require(published["tag_name"] == release.TAG and published["target_commitish"] == source
            and published["immutable"] is True and published["draft"] is False
            and published["prerelease"] is False, "expected the published immutable release at the reviewed SHA")
    ref = strict_json(read(f"{REPO_API}/git/ref/tags/{release.TAG}"))
    obj = strict_json(read(f"{REPO_API}/git/tags/{tag}"))
    require(ref["object"]["type"] == "tag" and ref["object"]["sha"] == tag
            and obj["sha"] == tag and obj["tag"] == release.TAG
            and obj["object"]["type"] == "commit" and obj["object"]["sha"] == source,
            "annotated tag differs from the reviewed tag or release commit")

    base = f"https://raw.githubusercontent.com/{release.API_REPOSITORY}/{rev}/packages/{release.TAG}"
    raw = read(f"{base}/receipt.json")
    require(hashlib.sha256(raw).hexdigest() == digest(pins["receipt_sha256"], 64),
            "qualification receipt differs from the reviewed artifact")
    receipt = strict_json(raw)
    require(receipt["schema"] == "lean-info-theory.release3-pages.v1"
            and receipt["purpose"] == "candidate" and receipt["source"] == source,
            "promotion requires the exact candidate qualification receipt")
    commit = strict_json(read(f"{REPO_API}/git/commits/{source}"))
    require(commit["sha"] == source and commit["tree"]["sha"] == receipt["source_tree"],
            "public release tree differs from the qualified tree")
    require(set(receipt["sites"]) == {*SITE_NAMES.values(), "LeanInfoTheory-API"},
            "qualification receipt must cover all three permanent sites")
    if site == "main":
        raw_marker = read(release.API_URL + MARKER)
        require(hashlib.sha256(raw_marker).hexdigest() == digest(receipt["api_stage_sha256"], 64),
                "the live v0.3.0 API marker differs from the qualified bytes")
        marker = strict_json(raw_marker)
        require(marker["schema"] == "lean-info-theory.versioned-api.v1"
                and marker["version"] == release.TAG and marker["purpose"] == "candidate"
                and marker["source_mode"] == "github" and marker["source_identity"] == source
                and marker["source_tree"] == receipt["source_tree"]
                and marker["validated_passes"] == 2
                and marker["api_attestation_sha256"] == receipt["api_attestation_sha256"]
                and marker["raw_tree_sha256"] == receipt["api_raw_sha256"],
                "the live v0.3.0 API is bound to different documentation or source")
        verify_live_endpoints(source, read)
    return {"bundle_url": f"{base}/{site}.zip", "zip_sha256": zip_hash,
            "tar_sha256": tar_hash, "site_tree_sha256": digest(receipt["sites"][SITE_NAMES[site]]["sha256"], 64)}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("site", choices=SITE_NAMES)
    parser.add_argument("--pins", type=Path, required=True)
    args = parser.parse_args()
    try:
        print(json.dumps(resolve(args.site, strict_json(args.pins.read_bytes())), sort_keys=True))
    except (OSError, ValueError, TypeError, KeyError) as error:
        parser.exit(1, f"Release 3 promotion check failed: {error}\n")
