"""Archive a checked site in GitHub Pages artifact.tar format; verify every file."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import tarfile
import tempfile

import package_release_pages as pages
import split_website as split
import stage_website as stage


def archive(package: Path, name: str, output: Path) -> str:
    stage.require_unredirected_components(package, label="Pages package")
    stage.require_unredirected_components(output, label="Pages tar output")
    if output.exists() or output.name != "artifact.tar":
        raise ValueError("a fresh artifact.tar is required")
    receipt = json.loads((package / "receipt.json").read_bytes())
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
        tar.rename(output)
    return archive_sha


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("package", type=Path)
    parser.add_argument("site", choices=pages.SITES)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    print(archive(args.package, args.site, args.output))
