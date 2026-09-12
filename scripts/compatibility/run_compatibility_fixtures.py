#!/usr/bin/env python3
"""Run real C9.02 compatibility regressions in an owned ignored source copy.

Deliberate API changes never touch production source. Every run keeps its exact
sources, commands and output below tmp/. The compiled-output copy is private;
only unchanged pinned dependency caches are shared. A baseline build is always
run in the copy before a stale-artifact experiment.
"""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import textwrap
import uuid

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
import check_public_api_compatibility as check

OWNER = "LeanInfoTheory/Shannon/SemanticBridge/FiniteFamilyIndependence.lean"
TARGET = "familyEntropyOf_eq_sum_singletons_iff_isMutuallyIndependentFamilyOf"
QUALIFIED = "LeanInfoTheory.Shannon." + TARGET
FINAL = "\nend LeanInfoTheory.Shannon"
CASES = ("unchanged", "compatible_addition", "extra_assumption", "named_binder",
         "implicit_binder", "changed_result", "removed", "renamed", "stale_artifact",
         "retained_simp_added", "retained_simp_removed", "retained_simp_relocated", "unapproved_new_simp",
         "focused_import", "heavy_root", "extra_root_alias", "same_type_body")
DIAGNOSTIC_SUBJECTS = {
    "retained_simp_added": QUALIFIED,
    "retained_simp_removed": "LeanInfoTheory.Shannon.isMutuallyIndependentFamily_empty",
    "retained_simp_relocated": "LeanInfoTheory.Shannon.isMutuallyIndependentFamily_empty",
    "extra_root_alias": "LeanInfoTheory.add_assoc",
}


def run(args: list[str], cwd: Path, out: Path, label: str, expected: int | None = 0) -> dict:
    print(f"fixture {label}: {args!r}", flush=True)
    stdout, stderr = out / f"{label}.stdout", out / f"{label}.stderr"
    env = dict(os.environ, GIT_OPTIONAL_LOCKS="0", GIT_TERMINAL_PROMPT="0")
    env.pop("LEAN_PATH", None)
    with stdout.open("xb") as left, stderr.open("xb") as right:
        result = subprocess.run(args, cwd=cwd, stdout=left, stderr=right, env=env, check=False)
    record = {"command": args, "cwd": str(cwd), "exit_code": result.returncode,
              "stdout_sha256": check.sha256(stdout.read_bytes()),
              "stderr_sha256": check.sha256(stderr.read_bytes())}
    (out / f"{label}.result.json").write_bytes(check.encode(record))
    if expected is not None and result.returncode != expected:
        diagnostic = (stdout.read_bytes() + stderr.read_bytes()).decode("utf-8", errors="replace")
        raise ValueError(f"unexpected compiler/generator outcome for {label}: {result.returncode}; {diagnostic[-3500:]}")
    return record


def make_source_copy(destination: Path) -> dict[str, bytes]:
    check.require(destination.resolve().is_relative_to((ROOT / "tmp").resolve()), "fixture escaped tmp")
    check.require(not destination.exists(), "fixture source copy must be new")
    ignored = subprocess.run(["git", "check-ignore", destination.relative_to(ROOT).as_posix()],
                             cwd=ROOT, capture_output=True, check=False)
    check.require(ignored.returncode == 0, "fixture path must be ignored")
    destination.mkdir(parents=True)
    files = set(check.INPUTS) | {p.relative_to(ROOT).as_posix() for p in check.blueprint.lean_files()}
    files |= {p.relative_to(ROOT).as_posix() for p in (ROOT / "scripts").rglob("*.py")}
    files |= {"docs/current-public-api.json", ".gitignore", ".gitattributes"}
    originals = {}
    copied = {}
    for rel in sorted(files):
        original = ROOT / rel
        check.require(original.resolve() == original.absolute(), f"redirected fixture input: {rel}")
        raw = original.read_bytes()
        target = destination / rel
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(raw)
        copied[rel] = check.sha256(raw)
        if rel.endswith(".lean") or rel == "docs/current-public-api.json":
            originals[rel] = raw
    lake = destination / ".lake"
    lake.mkdir()
    check.unredirected_tree(ROOT / ".lake/build")
    shutil.copytree(ROOT / ".lake/build", lake / "build", copy_function=shutil.copy2)
    check.unredirected_tree(lake / "build")
    packages = (ROOT / ".lake/packages").resolve()
    if os.name == "nt":
        quoted = lambda path: "'" + str(path).replace("'", "''") + "'"
        command = ("New-Item -ItemType Junction -Path " + quoted(lake / "packages")
                   + " -Value " + quoted(packages) + " -ErrorAction Stop | Out-Null")
        subprocess.run(["powershell.exe", "-NoProfile", "-NonInteractive", "-Command", command], check=True)
    else:
        (lake / "packages").symlink_to(packages, target_is_directory=True)
    with (destination.parent / "source-copy.json").open("xb") as output:
        output.write(check.encode({"files": copied, "private_build": str(lake / "build"),
                                   "shared_pinned_packages": str(packages)}))
    return originals


def insert_before_final(source: str, addition: str) -> str:
    check.require(source.count(FINAL) == 1, "fixture namespace boundary changed")
    return source.replace(FINAL, "\n" + addition + FINAL)


def replace_once(source: str, old: str, new: str) -> str:
    check.require(source.count(old) == 1, f"fixture source anchor changed: {old!r}")
    return source.replace(old, new, 1)


def insert_header_import(source: str, module: str) -> str:
    """Insert beside the existing import header, before module documentation."""
    match = re.search(r"^import [A-Za-z_][A-Za-z0-9_.]*$", source, re.MULTILINE)
    check.require(match is not None, "fixture import header missing")
    # These owned fixtures use the project's single leading copyright comment.
    prefix = source[:match.start()]
    check.require(prefix.count("/-") == prefix.count("-/") == 1
                  and re.fullmatch(r"\s*/-[\s\S]*?-/\s*", prefix) is not None,
                  "fixture import header no longer follows the copyright comment")
    check.require(f"import {module}\n" not in source, "fixture import already present")
    return source[:match.start()] + f"import {module}\n" + source[match.start():]


def semantic_consumer_mismatch(output: str) -> str | None:
    """Find the actual base-2/base-3 error, not an unrelated Units build failure."""
    # The pinned compiler's observed error explains that entropy_div_log p 2
    # yields division by log 2 while the changed natsToBits expects log 3.
    # Permit source-line movement and whitespace wrapping, but keep both sides
    # inside the same native diagnostic block.
    for block in re.split(r"(?m)(?=^error: )", output):
        if re.match(r"error: (?:[^\n]*[/\\])?LeanInfoTheory[/\\]Examples[/\\]Units\.lean:\d+:\d+:", block):
            compact = " ".join(block.split())
            if re.search(r"Type mismatch: After simplification, term entropy_div_log p 2 "
                         r"has type entropy p / Real\.log 2 = .+? "
                         r"but is expected to have type entropy p / Real\.log 3 = ", compact):
                return block.rstrip()
    return None


def mutate(case: str, source: Path) -> tuple[bool, str]:
    """Return expected compatibility pass and required diagnostic substring."""
    path = source / OWNER
    text = path.read_text(encoding="utf-8")
    check.require(text.count("theorem " + TARGET + "\n") == 1, "fixture theorem anchor changed")
    start = text.index("theorem " + TARGET)
    end = text.index("\nend\n", start)
    theorem = text[start:end]
    changed = theorem
    if case in {"extra_assumption", "stale_artifact"}:
        changed = replace_once(theorem, "    (p : PMF omega)", "    (_c9extra : True) (p : PMF omega)")
    elif case == "named_binder":
        changed = re.sub(r"\bp\b", "pRenamed", theorem)
    elif case == "implicit_binder":
        changed = replace_once(theorem, "(s : Finset Var)", "{s : Finset Var}")
    elif case == "changed_result":
        prefix, result = theorem.split(" :\n", 1)
        proposition, proof = result.split(" := by\n", 1)
        check.require(all(not line.strip() or line.startswith("  ") for line in proof.splitlines()),
                      "fixture proof indentation changed")
        proof = textwrap.indent(proof.rstrip(), "  ")
        changed = prefix + " :\n    (" + proposition.strip() + ") ∧ True := by\n  constructor\n  ·\n" + proof + "\n  · trivial\n"
    elif case == "renamed":
        changed = replace_once(theorem, TARGET, TARGET + "Renamed")
    elif case == "removed":
        start = text.rfind("/--", 0, start)
        check.require(start >= 0, "fixture theorem documentation anchor missing")
        changed = ""
    if changed != theorem or case == "removed":
        path.write_text(text[:start] + changed + text[end:], encoding="utf-8", newline="\n")
        reason = "RETAINED_NAME_MISSING: " if case in {"removed", "renamed"} else "retained contract changed: "
        return False, reason + QUALIFIED
    if case in {"compatible_addition", "unapproved_new_simp"}:
        attribute = "@[simp]\n" if case == "unapproved_new_simp" else ""
        addition = "/-- A deliberately isolated compatible-addition regression. -/\n" + attribute
        addition += "theorem c9CompatibilityAddition (n : Nat) : n + 0 = n := by simp\n"
        path.write_text(insert_before_final(text, addition), encoding="utf-8", newline="\n")
        return (True, "") if case == "compatible_addition" else (
            False, "SIMP_APPROVAL_REQUIRED: LeanInfoTheory.Shannon.c9CompatibilityAddition")
    if case == "retained_simp_added":
        path.write_text(insert_before_final(text, "attribute [simp] " + TARGET + "\n"),
                        encoding="utf-8", newline="\n")
        return False, "COMPILED_SIMP_MISMATCH"
    if case in {"retained_simp_removed", "retained_simp_relocated"}:
        # Out-of-line [-simp] changes only a local state; it does not erase the
        # annotation exported in the olean. Change the actual retained annotation.
        anchor = "@[simp] theorem isMutuallyIndependentFamily_empty\n"
        annotation = "" if case == "retained_simp_removed" else "@[local simp] "
        path.write_text(replace_once(text, anchor,
                        annotation + "theorem isMutuallyIndependentFamily_empty\n"),
                        encoding="utf-8", newline="\n")
        if case == "retained_simp_removed":
            return False, "RETAINED_SIMP_CHANGED"
        # The source inventory still sees 'simp' and the full umbrella restores
        # membership. Only an actual focused-import simp audit detects the loss.
        umbrella = source / "LeanInfoTheory/Shannon.lean"
        umbrella.write_text(umbrella.read_text(encoding="utf-8")
                            + "\nattribute [simp] LeanInfoTheory.Shannon.isMutuallyIndependentFamily_empty\n",
                            encoding="utf-8", newline="\n")
        return False, "COMPILED_FOCUSED_SIMP_MISMATCH"
    if case == "focused_import":
        path.write_text(insert_header_import(text, "Lean"),
                        encoding="utf-8", newline="\n")
        return False, "IMPORT_APPROVAL_REQUIRED: LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence"
    if case == "heavy_root":
        path = source / "LeanInfoTheory.lean"
        text = path.read_text(encoding="utf-8")
        path.write_text(insert_header_import(text, "LeanInfoTheory.Shannon.SemanticBridge.Independence"),
                        encoding="utf-8", newline="\n")
        return False, "ROOT_IMPORT_BOUNDARY"
    if case == "extra_root_alias":
        path = source / "LeanInfoTheory/InformationMeasures.lean"
        text = path.read_text(encoding="utf-8")
        path.write_text(text + "\nnamespace LeanInfoTheory\nexport Nat (add_assoc)\nend LeanInfoTheory\n",
                        encoding="utf-8", newline="\n")
        return False, "COMPILED_ROOT_ALIAS_MISMATCH"
    if case == "same_type_body":
        path = source / "LeanInfoTheory/Shannon/Units.lean"
        text = path.read_text(encoding="utf-8")
        check.require(text.count("  natsToBase 2 x") == 1, "same-type fixture definition changed")
        path.write_text(text.replace("  natsToBase 2 x", "  natsToBase 3 x"), encoding="utf-8", newline="\n")
        return True, ""
    check.require(case == "unchanged", f"unknown fixture: {case}")
    return True, ""


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cases", nargs="+", choices=CASES, default=list(CASES))
    args = parser.parse_args(argv)
    if len(args.cases) != len(set(args.cases)):
        parser.error("fixture cases must be unique")
    (ROOT / "tmp").mkdir(exist_ok=True)
    workspace = ROOT / "tmp" / ("c902-" + uuid.uuid4().hex)
    source = workspace / "s"
    before = check.source_identity()
    original_frozen = check.frozen.FROZEN_PATH.read_bytes()
    original_artifact = check.retained.ARTIFACT.read_bytes()
    outcomes = []
    originals = None
    workspace.mkdir()  # Exclusive ownership; do not overwrite a colliding run.
    try:
        originals = make_source_copy(source)
        setup = workspace / "setup"
        setup.mkdir()
        run(["lake", "-KwarningAsError=true", "build", "LeanInfoTheory.Shannon"], source, setup, "baseline-build")
        if "same_type_body" in args.cases:
            run(["lake", "-KwarningAsError=true", "build", "LeanInfoTheory.Examples.Units"], source, setup,
                "baseline-semantic-consumer")
        for case in args.cases:
            for rel, raw in originals.items():
                (source / rel).write_bytes(raw)
            out = workspace / case
            out.mkdir()
            # A genuinely current baseline owner is needed immediately before
            # preserving its old artifacts for the standalone stale-input case.
            if case == "stale_artifact":
                run(["lake", "-KwarningAsError=true", "build", "LeanInfoTheory.Shannon"], source, out, "old-artifact-build")
                olean = source / ".lake/build/lib/lean" / Path(OWNER).with_suffix(".olean")
                old_olean = check.sha256(olean.read_bytes())
            should_pass, diagnostic = mutate(case, source)
            changed_sources = {rel: (source / rel).read_bytes().hex() for rel, raw in originals.items()
                               if rel.endswith(".lean") and (source / rel).read_bytes() != raw}
            (out / "mutation-sources.json").write_bytes(check.encode(changed_sources))
            if case == "stale_artifact":
                check.require(check.sha256(olean.read_bytes()) == old_olean, "old artifact changed before standalone check")
                (out / "stale-artifact-before.json").write_bytes(check.encode({"path": str(olean), "sha256": old_olean,
                    "no_build_after_mutation": True, "source_sha256": check.sha256((source / OWNER).read_bytes())}))
            elif case != "unchanged":
                run(["lake", "-KwarningAsError=true", "build", "LeanInfoTheory.Shannon"], source, out, "compiling-mutation")
            # Generation is real, but never supplies approval. Name/owner changes
            # with no exported facade dependency still produce a valid inventory.
            run([sys.executable, "-B", "scripts/generate_current_public_api.py"], source, out, "generate-current")
            result = run([sys.executable, "-B", "scripts/validate_release.py", "compatibility"], source, out,
                         "standalone-compatibility", expected=None)
            output = ((out / "standalone-compatibility.stdout").read_bytes()
                      + (out / "standalone-compatibility.stderr").read_bytes()).decode("utf-8", errors="replace")
            check.require((result["exit_code"] == 0) == should_pass,
                          f"wrong compatibility outcome for {case}: {output[-4000:]}")
            if not should_pass:
                required = [diagnostic] + ([DIAGNOSTIC_SUBJECTS[case]] if case in DIAGNOSTIC_SUBJECTS else [])
                check.require(all(item in output for item in required),
                              f"wrong failure reason for {case}; expected {required!r}: {output[-3000:]}")
            if case == "stale_artifact":
                check.require("compatibility build:" in output and "retained contract changed" in output,
                              "standalone stale-artifact check did not rebuild and detect the retained change")
                new_olean = check.sha256(olean.read_bytes())
                check.require(new_olean != old_olean, "stale owner artifact was not replaced")
                # Persist transient post-check bytes before subsequent cases
                # restore/rebuild the source copy. Original native streams and
                # their nested build records remain the evidence of execution.
                with (out / "stale-artifact-after.json").open("xb") as record:
                    record.write(check.encode({
                        "path": str(olean), "before_sha256": old_olean, "after_sha256": new_olean,
                        "source_sha256": check.sha256((source / OWNER).read_bytes()),
                        "source_identity": {rel: check.sha256((source / rel).read_bytes())
                                            for rel in sorted(originals)},
                        "source_identity_scope": "all copied local Lean sources and current manifest; other inputs in source-copy.json",
                        "standalone_command_result": result,
                        "build_diagnostic_lines": [line for line in output.splitlines()
                                                   if line.startswith("compatibility build:")],
                        "retained_diagnostic_lines": [line for line in output.splitlines()
                                                      if "retained contract changed" in line],
                    }))
            if case == "same_type_body":
                check.require((source / "docs/current-public-api.json").read_bytes() == originals["docs/current-public-api.json"],
                              "same-type body fixture unexpectedly changed manifest entries")
                consumer = run(["lake", "-KwarningAsError=true", "build", "LeanInfoTheory.Examples.Units"], source,
                               out, "semantic-consumer", expected=None)
                check.require(consumer["exit_code"] != 0, "changed bits semantics unexpectedly passed the existing units consumer")
                consumer_output = ((out / "semantic-consumer.stdout").read_bytes()
                                   + (out / "semantic-consumer.stderr").read_bytes()).decode("utf-8", errors="replace")
                mismatch = semantic_consumer_mismatch(consumer_output)
                check.require(mismatch is not None,
                              "semantic consumer did not report the expected base-2/base-3 entropy mismatch")
                with (out / "semantic-consumer-attribution.json").open("xb") as record:
                    record.write(check.encode({"outcome": "EXPECTED_SEMANTIC_LIMITATION",
                                               "diagnostic": mismatch, "command_result": consumer}))
            check.require((source / "docs/v0.1-public-api.json").read_bytes() == original_frozen,
                          "fixture rewrote frozen manifest")
            check.require((source / "docs/compatibility/v0.1.0-retained-contract.json").read_bytes() == original_artifact,
                          "fixture rewrote retained artifact")
            outcomes.append({"case": case, "expected_compatibility_pass": should_pass,
                             "observed_exit": result["exit_code"], "diagnostic": diagnostic,
                             "outcome": "EXPECTED_SEMANTIC_LIMITATION" if case == "same_type_body" else "PASS",
                             "evidence": str(out)})
            (out / "assessment.json").write_bytes(check.encode(outcomes[-1]))
            print(json.dumps(outcomes[-1]), flush=True)
        for rel, raw in originals.items():
            (source / rel).write_bytes(raw)
        restored = workspace / "restored"
        restored.mkdir()
        run([sys.executable, "-B", "scripts/validate_release.py", "compatibility"], source, restored,
            "standalone-compatibility")
        check.require(check.source_identity() == before, "production inputs changed during fixture run")
        summary = {"outcome": "PASS", "workspace": str(workspace), "cases": outcomes,
                   "production_inputs_unchanged": True, "source_input_sha256": check.sha256(check.encode(before)),
                   "restored_source_passed_standalone": True,
                   "limits": "Deliberate changes exist only in the ignored source copy. Expected semantic-blind-spot pass is not approval of changed mathematical meaning. These fixtures do not qualify C9.03 trust/API-doc growth integration."}
        (workspace / "summary.json").write_bytes(check.encode(summary))
        print(json.dumps(summary, ensure_ascii=False), flush=True)
        return 0
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        workspace.mkdir(parents=True, exist_ok=True)
        (workspace / "failure.json").write_bytes(check.encode({"outcome": "FAIL", "diagnostic": str(error), "completed_cases": outcomes}))
        print(f"compatibility fixtures failed; originals retained at {workspace}: {error}", file=sys.stderr)
        return 1
    finally:
        if originals is not None:
            for rel, raw in originals.items():
                (source / rel).write_bytes(raw)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
    raise SystemExit(main())
