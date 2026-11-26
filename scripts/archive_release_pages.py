"""Archive a checked site in GitHub Pages artifact.tar format; verify every file."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import tarfile
import tempfile

import release3_pages as release3
import split_website as split
import stage_website as stage


def archive(package: Path, name: str, output: Path, *, allow_rehearsal: bool = False,
            file_manifest: Path | None = None) -> str:
    package = release3.filesystem_path(package)
    output = release3.filesystem_path(output)
    if output.exists() or output.name != "artifact.tar" or output.is_relative_to(package):
        raise ValueError("a fresh artifact.tar outside the checked package is required")
    if file_manifest is not None:
        file_manifest = release3.filesystem_path(file_manifest)
        if file_manifest.exists() or file_manifest == output or file_manifest.is_relative_to(package):
            raise ValueError("a separate fresh file-manifest path outside the checked package is required")
    receipt = json.loads((package / "receipt.json").read_bytes())
    if name not in release3.SITES:
        raise ValueError(f"unknown Pages project: {name}")
    marker = package / release3.MAIN / stage.ROOT_MARKER
    is_release3 = (receipt.get("schema") == release3.SCHEMA or name == release3.API
                   or (package / release3.API).exists())
    if is_release3:
        purpose = receipt.get("purpose")
        if (receipt.get("schema") != release3.SCHEMA or set(receipt["sites"]) != set(release3.SITES)
                or purpose not in ("candidate", "rehearsal") or stage.strict_object(marker)["purpose"] != purpose):
            raise ValueError("Release 3 requires an identified three-site qualification receipt")
        if purpose == "rehearsal" and not allow_rehearsal:
            raise ValueError("nonpublishable rehearsal requires explicit --allow-rehearsal for local archiving")
        for host in (release3.MAIN, release3.API):
            if (package / host / stage.PREVIEW_MARKER).exists() != (purpose == "rehearsal"):
                raise ValueError("release artifact purpose differs from rehearsal markers")
    tree = package / name
    expected = split.inventory(tree)
    size = split.check_capacity(expected)
    digest, count, _, observed_size = stage.tree_digest(tree)
    if receipt["sites"][name] != {"sha256": digest, "files": count, "bytes": size} or observed_size != size:
        raise ValueError("site differs from its checked release package")
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(dir=output.parent) as temporary:
        tar = Path(temporary) / "artifact.tar"
        with tarfile.open(tar, "w", format=tarfile.PAX_FORMAT) as bundle:
            for rel, entry in sorted(expected.items()):
                info = tarfile.TarInfo("./" + rel)
                info.size = entry["bytes"]
                info.mode = 0o644
                with (tree / rel).open("rb") as source:
                    bundle.addfile(info, source)
        seen = set()
        with tarfile.open(tar, "r:") as bundle:
            for member in bundle:
                rel = member.name.removeprefix("./")
                if rel in seen or rel not in expected or not member.isfile():
                    raise ValueError("unexpected entry in Pages tar")
                with bundle.extractfile(member) as source:
                    actual = hashlib.file_digest(source, "sha256").hexdigest()
                if actual != expected[rel]["sha256"] or member.size != expected[rel]["bytes"]:
                    raise ValueError(f"incorrect archived file: {rel}")
                seen.add(rel)
        if seen != set(expected):
            raise ValueError("missing files in Pages tar")
        with tar.open("rb") as stream:
            archive_sha = hashlib.file_digest(stream, "sha256").hexdigest()
        if file_manifest is not None:
            metadata = {"schema": "lean-info-theory.pages-file-manifest.v1", "site": name,
                        "source": receipt.get("source"), "purpose": receipt.get("purpose", "v0.2.0"),
                        "tree_sha256": digest, "tar_sha256": archive_sha, "bytes": size,
                        "file_count": count, "files": expected}
            file_manifest.parent.mkdir(parents=True, exist_ok=True)
            with file_manifest.open("xb") as stream:
                stream.write(split.encoded(metadata))
        try:
            tar.rename(output)
        except OSError:
            if file_manifest is not None:
                file_manifest.unlink()
            raise
    return archive_sha


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("package", type=Path)
    parser.add_argument("site", choices=release3.SITES)
    parser.add_argument("output", type=Path)
    parser.add_argument("--allow-rehearsal", action="store_true",
                        help="archive an explicitly nonpublishable three-site rehearsal for local inspection")
    parser.add_argument("--file-manifest", type=Path,
                        help="also write the checked path, size and SHA-256 of every archived file")
    args = parser.parse_args()
    print(archive(args.package, args.site, args.output, allow_rehearsal=args.allow_rehearsal,
                  file_manifest=args.file_manifest))
