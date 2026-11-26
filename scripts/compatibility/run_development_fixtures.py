#!/usr/bin/env python3
"""Qualify development API growth on matched, compiled v0.2.0 source fixtures.

Prepare a private local clone and warm build first. Check overlays the selected
development tools, exercises the two frozen contracts, and leaves the approved
positive fixture at a clean local commit for the development CI commands.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
sys.path.insert(0, str(ROOT / "scripts/compatibility"))
import run_candidate_fixtures as mutation
import run_growth_fixtures as growth
import validate_published as published

check = growth.check
run = growth.run
write = growth.write_record
DEV = [sys.executable, "-B", "scripts/validate_development.py", "compatibility"]
LEGACY = [sys.executable, "-B", "scripts/check_public_api_compatibility.py"]
SURFACE = ("LeanInfoTheory", "LeanInfoTheory.lean", "docs/current-public-api.json", growth.POLICY)
FROZEN = ("docs/v0.1-public-api.json", "docs/compatibility/v0.1.0-retained-contract.json",
          "docs/compatibility/v0.2.0-candidate-contract.json", "docs/compatibility/v0.2.0-candidate-approval.json")
TOOLING = ("scripts/validate_development.py", "scripts/check_development_api_compatibility.py",
           "scripts/validate_release.py", "scripts/validate_published.py", ".github/workflows/lean_action_ci.yml",
           "docs/compatibility/README.md", "scripts/compatibility/run_development_fixtures.py")


def git(root: Path, *args: str) -> bytes:
    return subprocess.check_output(["git", "-C", str(root), *args])


def fixture_directory(directory: Path) -> Path:
    path = directory.absolute()
    check.require(path.parent == ROOT / "tmp" and path.resolve() == path and path.name.startswith("gq-"),
                  "fixture must be a new, unredirected tmp/gq-* directory")
    git(ROOT, "check-ignore", path.relative_to(ROOT).as_posix())
    return path


def commit(source: Path, message: str, *, allow_empty: bool = False) -> str:
    git(source, "add", "--all")
    options = ["--allow-empty"] if allow_empty else []
    git(source, "-c", "commit.gpgSign=false", "commit", "--quiet", *options, "-m", message)
    check.require(not git(source, "status", "--porcelain"), "fixture checkpoint is dirty")
    return git(source, "rev-parse", "HEAD").decode().strip()


def prepare(out: Path) -> None:
    out.mkdir(exist_ok=False)
    source = out / "s"
    head = git(ROOT, "rev-parse", "HEAD").decode().strip()
    hooks = out / "empty-hooks"
    hooks.mkdir()
    run(["git", "clone", "--quiet", "--shared", "--no-checkout", "--template=" + str(hooks),
         str(ROOT), str(source)], out, out, "local-clone")
    git(source, "config", "core.hooksPath", str(hooks))
    git(source, "config", "core.autocrlf", "false")
    git(source, "config", "user.name", "Local qualification fixture")
    git(source, "config", "user.email", "qualification@example.invalid")
    git(source, "checkout", "--quiet", "--detach", head)
    # The clone remains local and keeps its own tag refs and object alternates.
    git(source, "remote", "remove", "origin")
    check.require(git(source, "rev-parse", "v0.2.0").decode().strip() == published.TAG and
                  git(source, "rev-parse", "v0.2.0^{commit}").decode().strip() == published.SOURCE,
                  "immutable v0.2.0 tag identity mismatch")
    git(source, "merge-base", "--is-ancestor", published.SOURCE, "HEAD")
    git(source, "restore", "--source=" + published.SOURCE, "--staged", "--worktree", "--", *SURFACE)
    packages = (ROOT / ".lake/packages").resolve()
    lake = source / ".lake"
    lake.mkdir()
    check.unredirected_tree(ROOT / ".lake/build")
    shutil.copytree(ROOT / ".lake/build", lake / "build")
    check.unredirected_tree(lake / "build")
    if os.name == "nt":
        subprocess.run(["powershell.exe", "-NoProfile", "-NonInteractive", "-Command",
                        "New-Item -ItemType Junction -Path $env:FIXTURE_PACKAGES -Target "
                        "$env:CACHE_PACKAGES -ErrorAction Stop | Out-Null"], check=True,
                       env={**os.environ, "FIXTURE_PACKAGES": str(lake / "packages"), "CACHE_PACKAGES": str(packages)})
    else:
        (lake / "packages").symlink_to(packages, target_is_directory=True)
    check.require((lake / "packages").resolve() == packages, "wrong dependency cache")
    run(["lake", "--wfail", "build", "LeanInfoTheory.Shannon"], source, out, "warm-build")
    write(out / "prepared.json", {"head": head, "release": published.SOURCE, "source": str(source),
                                  "shared_packages": str(packages)})


def check_release_bytes(source: Path) -> dict:
    """Compare physical bytes to the tag's Git blobs, without a text filter."""
    names = {p.relative_to(source).as_posix() for p in (source / "LeanInfoTheory").rglob("*") if p.is_file()}
    names.update((*SURFACE[1:], *FROZEN, *check.CONFIGURATION))
    tree = git(source, "ls-tree", "-rz", published.SOURCE, "--", *SURFACE, *FROZEN, *check.CONFIGURATION)
    blobs = {}
    for record in tree.split(b"\0"):
        if record:
            meta, path = record.decode().split("\t", 1)
            _, kind, oid = meta.split()
            check.require(kind == "blob", "unexpected tag object: " + path)
            raw = (source / path).read_bytes()
            blob = hashlib.sha1(f"blob {len(raw)}\0".encode() + raw).hexdigest()
            check.require(blob == oid, "working bytes differ from the published tag: " + path)
            blobs[path] = oid
    check.require(set(blobs) == names, "release source or frozen-file coverage differs")
    return blobs


def run_gate(source: Path, out: Path, label: str, command: list[str], expected: int) -> dict:
    run(command, source, out, label, expected=expected)
    text = growth.output_text(out, label)
    schema = ("lean-info-theory.current-compatibility-result.v1" if command == LEGACY else
              "lean-info-theory.development-compatibility-result.v1")
    results = [json.loads(line) for line in text.splitlines() if line.startswith("{")]
    matches = [item for item in results if item.get("schema") == schema]
    check.require(len(matches) == 1, "missing or ambiguous actual checker result: " + label)
    result = matches[0]
    check.require(result["outcome"] == ("PASS" if expected == 0 else "FAIL"), "unexpected result: " + label)
    return result


def require_positive(result: dict, names: list[str]) -> None:
    check.require((result["v0.1.0_retained"], result["v0.2.0_retained"]) == (601, 811)
                  and result["added_names_since_v0.2.0"] == names
                  and result["current_declarations"] == 811 + len(names), "wrong compiled growth surface")


def check_mutation(source: Path, out: Path) -> None:
    owner = source / mutation.OWNER
    original = owner.read_bytes()
    changed = mutation.mutate(original.decode("utf-8")).encode("utf-8")
    owner.write_bytes(changed)
    try:
        legacy = run_gate(source, out, "mutation-601", LEGACY, 0)
        check.require((legacy["retained_count"], legacy["current_count"]) == (601, 811),
                      "unexpected independent legacy control")
        rejected = run_gate(source, out, "mutation-811", DEV, 1)
        check.require(rejected["diagnostic"].startswith("CANDIDATE_TYPE: " + mutation.QUALIFIED + " at type"),
                      "mutation refused for the wrong reason: " + rejected["diagnostic"])
        write(out / "mutation.json", {"declaration": mutation.QUALIFIED, "before": check.sha256(original),
                                      "after": check.sha256(changed), "diagnostic": rejected["diagnostic"]})
    finally:
        owner.write_bytes(original)


def check_approval_omissions(source: Path, out: Path, original: dict, umbrella_reason: str) -> None:
    policy = source / growth.POLICY
    approved = policy.read_bytes()
    surface = growth.hashes(source, (*growth.GENERATED, growth.MODULE_PATH, growth.UMBRELLA, *FROZEN))
    try:
        for label, owner, reason in (
                ("missing-module-approval", growth.MODULE, "IMPORT_APPROVAL_REQUIRED"),
                ("missing-umbrella-approval", growth.UMBRELLA_MODULE, umbrella_reason)):
            sibling = json.loads(approved)
            approvals = sibling["import_approvals"]
            record = next(item for item in approvals if item["owner"] == owner)
            before = next((item for item in original["import_approvals"] if item["owner"] == owner), None)
            if before is None:
                approvals.remove(record)
            else:
                approvals[approvals.index(record)] = before
            policy.write_bytes(check.encode(sibling))
            write(out / (label + "-policy.json"), sibling)
            result = run_gate(source, out, label, DEV, 1)
            check.require(result["diagnostic"].split(";", 1)[0] == f"{reason}: {owner}",
                          "incorrect policy refusal: " + result["diagnostic"])
            check.require(surface == growth.hashes(source, tuple(surface)), "unmatched approval siblings")
    finally:
        policy.write_bytes(approved)


def consumers(source: Path, out: Path) -> None:
    growth.consumer(source, out, "approved_module")
    umbrella = (source / "tmp/c9-growth-consumer.lean").read_text(encoding="utf-8").replace(
        "import " + growth.MODULE + "\n", "import LeanInfoTheory.Shannon\n")
    root = f"""import LeanInfoTheory
import Lean.Elab.Command

open Lean Elab Command in
run_cmd do
  let env ← getEnv
  if env.allImportedModuleNames.contains `{growth.MODULE} || env.contains `{growth.NEW_NAME} ||
      env.contains `LeanInfoTheory.c9GrowthOptIn then
    throwError "lightweight import leaked the fixture module or declaration"
"""
    for name, program in (("umbrella", umbrella), ("lightweight-root", root)):
        path = out / (name + "-consumer.lean")
        path.write_text(program, encoding="utf-8", newline="\n")
        run(["lake", "env", "lean", "-DwarningAsError=true", str(path)], source, out, name + "-consumer")


def run_checks(out: Path) -> None:
    source = out / "s"
    prepared = check.strict_json((out / "prepared.json").read_bytes())
    check.require(source.resolve() == source and prepared["source"] == str(source)
                  and git(source, "rev-parse", "HEAD").decode().strip() == prepared["head"]
                  and Path(git(source, "rev-parse", "--show-toplevel").decode().strip()).resolve() == source
                  and (source / ".lake/packages").resolve() == (ROOT / ".lake/packages").resolve(),
                  "fixture checkout or shared dependency location changed")
    with (out / "checks-started").open("x"):
        pass
    released = check_release_bytes(source)
    frozen = growth.hashes(source, FROZEN)
    write(out / "release-blobs.json", released)
    for rel in TOOLING:
        path = ROOT / rel
        check.require(path.resolve() == path and path.is_file(), "missing or redirected tooling: " + rel)
        (source / rel).write_bytes(path.read_bytes())
    tools = growth.hashes(source, TOOLING)
    write(out / "tools.json", tools)
    baseline_commit = commit(source, "Local fixture: released surface with development validation", allow_empty=True)
    require_positive(run_gate(source, out, "released-control", DEV, 0), [])
    check_mutation(source, out)
    check.require(check_release_bytes(source) == released, "baseline restoration failed")
    baseline = check.strict_json((source / growth.GENERATED[0]).read_bytes())
    original_policy = check.strict_json((source / growth.POLICY).read_bytes())
    reason = growth.add_module(source, approved=True)
    growth.generate_twice(source, out)
    growth.check_growth_inventory(source, baseline, "approved_module")
    positive = commit(source, "Local fixture: documented opt-in and scoped umbrella approvals")
    require_positive(run_gate(source, out, "approved-growth", DEV, 0), [growth.NEW_NAME])
    consumers(source, out)
    check_approval_omissions(source, out, original_policy, reason)
    check.require(not git(source, "status", "--porcelain"), "approved positive checkout diverged")
    check.require(growth.hashes(source, FROZEN) == frozen, "frozen fixture bytes changed")
    check.require(growth.hashes(ROOT, TOOLING) == tools, "development tooling changed during qualification")
    result = {"outcome": "PASS", "tagged_source": published.SOURCE, "released_control": baseline_commit,
              "fixture_source": str(source), "clean_positive_commit": positive, "added_declaration": growth.NEW_NAME,
              "rejected_mutation": mutation.QUALIFIED, "frozen_paths": FROZEN,
              "remaining_ci": "Run the development CI jobs against the clean positive fixture."}
    write(out / "result.json", result)
    print(json.dumps(result), flush=True)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("prepare", "check"))
    parser.add_argument("directory", type=Path, help="ignored tmp/gq-* directory (new for prepare)")
    args = parser.parse_args()
    out = fixture_directory(args.directory)
    if args.action == "prepare":
        prepare(out)
    else:
        run_checks(out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
