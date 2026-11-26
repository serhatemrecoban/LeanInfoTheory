"""Reconstruct the clean capture commit from the containing release, even in a public clone."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

import release3_state as r3
from release_state import strict_json


def git(root: Path, *args: str, data: bytes | None = None, env: dict | None = None) -> bytes:
    return subprocess.run(["git", "--no-optional-locks", *args], cwd=root, env=env,
                          input=data, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True).stdout


def verify(root: Path, revision: str) -> dict:
    """Use only Git objects accessible from B. The original capture object can be absent."""
    if not re.fullmatch(r"[0-9a-f]{40}", revision) or git(root, "cat-file", "-t", revision).strip() != b"commit":
        raise ValueError("expected the full containing release commit")

    def blob(path: str) -> bytes:
        return git(root, "show", revision + ":" + path)

    state = r3.validate_state(strict_json(blob(r3.STATE_PATH)))
    pins = state.get("retained_api")
    if state["phase"] != "candidate-ready" or not pins:
        raise ValueError("expected a dated containing release with its reviewed API pins")
    artifacts = {path: blob(path) for path in pins}
    if any(hashlib.sha256(data).hexdigest() != pins[path] for path, data in artifacts.items()):
        raise ValueError("release tree differs from its approved contract or envelope")
    contract = strict_json(artifacts[r3.CONTRACT_PATH])
    approval = strict_json(artifacts[r3.APPROVAL_PATH])
    if approval["artifact_sha256"] != pins[r3.CONTRACT_PATH] or approval["review_reference"] != r3.REVIEW_PATH:
        raise ValueError("review envelope refers to a different contract or independent review")
    checkpoint = contract["checkpoint"]
    if approval["export_checkpoint"] != checkpoint or not checkpoint["clean"] or checkpoint["kind"] != "git":
        raise ValueError("capture and approval must identify the same clean Git checkout")
    if hashlib.sha256(blob(r3.REVIEW_PATH)).hexdigest() != approval["review_sha256"]:
        raise ValueError("containing release differs from the independent review")

    # Git computes the tree using its own modes, sorting and object format.
    # Keep newly reconstructed objects and the temporary index outside the repository.
    original_objects = git(root, "rev-parse", "--path-format=absolute", "--git-path", "objects").decode().strip()
    capture_state = {key: value for key, value in state.items() if key != "retained_api"}
    state_bytes = (json.dumps(capture_state, indent=2, sort_keys=True) + "\n").encode()
    capture_identity = contract["release_identity"]
    if (capture_identity["phase"] != "candidate-ready"
            or hashlib.sha256(state_bytes).hexdigest() != capture_identity["state_sha256"]
            or hashlib.sha256(blob("CITATION.cff")).hexdigest() != capture_identity["citation_sha256"]):
        raise ValueError("containing release does not reproduce the capture metadata")
    with tempfile.TemporaryDirectory() as tmp:
        objects = Path(tmp) / "objects"
        objects.mkdir()
        env = {**os.environ, "GIT_OBJECT_DIRECTORY": str(objects),
               "GIT_ALTERNATE_OBJECT_DIRECTORIES": original_objects, "GIT_INDEX_FILE": str(Path(tmp) / "index")}
        git(root, "read-tree", revision, env=env)
        git(root, "update-index", "--force-remove", "--", r3.CONTRACT_PATH, r3.APPROVAL_PATH, r3.REVIEW_PATH, env=env)
        state_oid = git(root, "hash-object", "-w", "--stdin", data=state_bytes, env=env).decode().strip()
        git(root, "update-index", "--cacheinfo", "100644", state_oid, r3.STATE_PATH, env=env)
        tree = git(root, "write-tree", env=env).decode().strip()
        if tree != checkpoint["tree"]:
            raise ValueError("release does not reproduce the approved capture tree")
        commit = approval["capture_commit_payload"].encode("utf-8")
        header = git(root, "cat-file", "commit", revision).split(b"\n\n", 1)[0]
        parents = re.findall(rb"^parent ([0-9a-f]{40})$", header, re.MULTILINE)
        if len(parents) != 1 or not commit.startswith(b"tree " + tree.encode() + b"\nparent " + parents[0] + b"\nauthor "):
            raise ValueError("capture and containing release must have the reviewed common parent")
        head = git(root, "hash-object", "-t", "commit", "--stdin", data=commit, env=env).decode().strip()
        if head != checkpoint["head"]:
            raise ValueError("commit payload does not reproduce the approved capture commit")
        inputs = contract["producer"]["files"]
        if not isinstance(inputs, dict) or not inputs:
            raise ValueError("missing producer inputs")
        # Resolve all recorded paths against the reconstructed tree in one Git process.
        request = "".join(f"{tree}:{path}\n" for path in inputs).encode("utf-8")
        stream = git(root, "cat-file", "--batch", data=request, env=env)
        offset = 0
        for path, digest in inputs.items():
            end = stream.index(b"\n", offset)
            header = stream[offset:end].split()
            if len(header) != 3 or header[1] != b"blob":
                raise ValueError(f"missing capture input at {path}")
            start = end + 1
            offset = start + int(header[2]) + 1
            if (hashlib.sha256(stream[start:offset - 1]).hexdigest() != digest
                    or stream[offset - 1:offset] != b"\n"):
                raise ValueError(f"capture producer digest differs for {path}")
        if offset != len(stream):
            raise ValueError("unexpected trailing Git output")
    return {"release": revision, "capture": head, "tree": tree, "parent": parents[0].decode(),
            "producer_inputs": len(inputs)}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("release_commit", help="full immutable containing release SHA")
    print(json.dumps(verify(r3.ROOT, parser.parse_args().release_commit), indent=2))
