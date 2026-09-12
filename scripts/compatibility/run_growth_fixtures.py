#!/usr/bin/env python3
"""Qualify current growth gates in one private, ignored source copy.

These are real Lean/source mutations and maintained static/trust/compatibility
commands. HTML is deliberately synthetic checker input, not doc-gen output or a
two-pass documentation milestone. Every original command result is retained.
"""

from __future__ import annotations

from contextlib import contextmanager
import json
from pathlib import Path
import re
import subprocess
import sys
import uuid

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
from compatibility import run_compatibility_fixtures as previous

check = previous.check
run = previous.run
OWNER = previous.OWNER
UMBRELLA = "LeanInfoTheory/Shannon.lean"
MODULE = "LeanInfoTheory.Shannon.GrowthFixture"
MODULE_PATH = MODULE.replace(".", "/") + ".lean"
MODULE_IMPORT = "LeanInfoTheory.Shannon.InfoMeasures"
NEW_NAME = "LeanInfoTheory.Shannon.c9GrowthOptIn"
ADDED_NAME = "LeanInfoTheory.Shannon.c9CompatibilityAddition"
POLICY = "docs/compatibility/current-api-policy.json"
DOC_OWNER = "LeanInfoTheory/Shannon/Units.lean"
DOC_TARGET = "LeanInfoTheory.Shannon.natsToBits"
STALE_DOC_DIAGNOSTIC = "API-doc source-content identity is stale; rebuild current documentation"
UNCLASSIFIED_MODULE = "LeanInfoTheory.C9UnclassifiedFixture"
UNCLASSIFIED_PATH = UNCLASSIFIED_MODULE.replace(".", "/") + ".lean"
SOURCE_NEGATIVES = {
    "undocumented_addition": {
        "generator": ("undocumented supported declarations", ADDED_NAME),
        "static": ("undocumented supported declarations", ADDED_NAME),
    },
    "unindexed_addition": {
        "generator": ("current public API manifest is stale;",),
        "static": ("current public API manifest is stale or invalid;",),
    },
    "unclassified_module": {
        "generator": ("Unclassified LeanInfoTheory module: " + UNCLASSIFIED_MODULE,),
        "static": ("Unclassified LeanInfoTheory module: " + UNCLASSIFIED_MODULE,),
    },
}
GENERATED = (
    "docs/current-public-api.json",
    "home_page/blueprint/module_graph.json",
    "home_page/blueprint/dep_graph_document.html",
    "home_page/docs/declaration_index.json",
    "home_page/docs/api-index.html",
)
RESTORED = (*GENERATED, OWNER, UMBRELLA, POLICY, DOC_OWNER)
GENERATORS = (
    "scripts/generate_current_public_api.py",
    "scripts/generate_website_blueprint.py",
    "scripts/generate_website_api_index.py",
)
ROOT_FILES = frozenset({
    "LeanInfoTheory.lean", "README.md", "AGENTS.md", "LICENSE", "CITATION.cff",
    ".gitignore", ".gitattributes", "lean-toolchain", "lakefile.toml", "lake-manifest.json",
})
PREFIXES = ("LeanInfoTheory/", "scripts/", "docs/", "home_page/", "blueprint/",
            "docbuild/", ".github/workflows/")
CASES = ("unchanged", "compatible_addition", "approved_module", "unapproved_module")
LIMITS = ("Real source/compiler and maintained growth-gate qualification. Documentation HTML "
          "is synthetic input to the actual checker, not generated signatures, a doc-gen build, "
          "or a two-pass attestation. No clean default-suite checkpoint or later C9 completion "
          "is claimed. Dependency caches are shared; project outputs and Git state are private.")
SCHEDULE_BASIS = ("Full unchanged-source trust is supplied separately by parent validation, not "
                  "executed or attested by this runner. Both changed positive cases run full trust. "
                  "Exact source restoration plus a fresh standalone compatibility audit avoids a "
                  "second restored all-project axiom audit. C9.04 cumulative qualification remains separate.")


def permitted_source(relative: str) -> bool:
    path = Path(relative)
    return (not path.is_absolute() and ".." not in path.parts
            and (relative in ROOT_FILES or relative.startswith(PREFIXES))
            and all(part not in {".git", ".lake", ".lit-review", "__pycache__"}
                    for part in path.parts))


def production_inputs() -> dict[str, str]:
    """Fingerprint only explicitly allowed, nonignored production source files."""
    result = subprocess.run(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
        cwd=ROOT, capture_output=True, check=True,
    )
    relatives = sorted({part.decode("utf-8") for part in result.stdout.split(b"\0")
                        if part and permitted_source(part.decode("utf-8"))})
    result_hashes = {}
    for relative in relatives:
        path = ROOT / relative
        check.require(path.resolve() == path.absolute() and path.is_file(),
                      f"redirected or missing growth fixture input: {relative}")
        result_hashes[relative] = check.sha256(path.read_bytes())
    check.require(ROOT_FILES.issubset(result_hashes), "growth fixture root inputs missing")
    return result_hashes


def write_record(path: Path, value: object) -> None:
    with path.open("xb") as output:
        output.write(check.encode(value))


def make_growth_copy(source: Path, setup: Path, identity: dict[str, str]) -> dict[str, bytes]:
    """Reuse private Lean output copying, then add static/docs inputs and own Git."""
    previous.make_source_copy(source)
    for relative, digest in identity.items():
        raw = (ROOT / relative).read_bytes()
        check.require(check.sha256(raw) == digest, f"input changed while copying: {relative}")
        target = source / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(raw)
    originals = {relative: (source / relative).read_bytes() for relative in RESTORED}
    check.require(not (source / MODULE_PATH).exists(), "growth module fixture already exists")
    empty_template = setup / "empty-git-template"
    empty_template.mkdir()
    run(["git", "init", "--quiet", "--template=" + str(empty_template)], source, setup, "git-init")
    run(["git", "config", "core.autocrlf", "false"], source, setup, "git-line-endings")
    run(["git", "rev-parse", "--show-toplevel"], source, setup, "git-root")
    observed = (setup / "git-root.stdout").read_text(encoding="utf-8").strip()
    check.require(Path(observed).resolve() == source.resolve(), "fixture Git resolved outside source copy")
    write_record(setup / "production-inputs.json", identity)
    write_record(setup / "originals.json", {rel: raw.hex() for rel, raw in originals.items()})
    return originals


def restore_source(source: Path, originals: dict[str, bytes]) -> None:
    """Restore only recorded owned files; remove only the one known new file."""
    resolved = source.resolve()
    check.require(resolved.is_relative_to((ROOT / "tmp").resolve()), "restore escaped owned tmp")
    for relative, raw in originals.items():
        target = source / relative
        check.require(target.resolve().is_relative_to(resolved) and not target.is_symlink(),
                      f"redirected restore path: {relative}")
        target.write_bytes(raw)
    added = source / MODULE_PATH
    if added.exists() or added.is_symlink():
        check.require(added.resolve().is_relative_to(resolved) and added.is_file()
                      and not added.is_symlink(), "redirected or nonfile added module")
        added.unlink()
    check.require(all((source / rel).read_bytes() == raw for rel, raw in originals.items()),
                  "growth source restoration mismatch")


def module_source(source: Path) -> str:
    original = (source / "LeanInfoTheory/Shannon/InfoMeasures.lean").read_text(encoding="utf-8")
    header, separator, _ = original.partition("-/")
    check.require(bool(separator) and header.startswith("/-\nCopyright"), "copyright anchor changed")
    return (header + separator + "\n\nimport " + MODULE_IMPORT + "\n\n"
            "/-!\n# Isolated growth-gate qualification\n\n"
            "A documented opt-in owner used only by the ignored growth fixture.\n-/\n\n"
            "namespace LeanInfoTheory.Shannon\n\n"
            "/-- A documented declaration for the isolated opt-in consumer. -/\n"
            "theorem c9GrowthOptIn (n : Nat) : n + 0 = n := by\n  exact Nat.add_zero n\n\n"
            "end LeanInfoTheory.Shannon\n")


def source_imports(source: Path, relative: str) -> dict[str, list[str]]:
    names = check.source_header_imports((source / relative).read_text(encoding="utf-8"), relative)
    return {"local": sorted(name for name in names if name == "LeanInfoTheory" or name.startswith("LeanInfoTheory.")),
            "external": sorted(name for name in names if name != "LeanInfoTheory" and not name.startswith("LeanInfoTheory."))}


def add_module(source: Path, *, approved: bool) -> None:
    target = source / MODULE_PATH
    check.require(not target.exists(), "new-module mutation must start from restored source")
    target.write_text(module_source(source), encoding="utf-8", newline="\n")
    umbrella = source / UMBRELLA
    umbrella.write_text(previous.insert_header_import(umbrella.read_text(encoding="utf-8"), MODULE),
                        encoding="utf-8", newline="\n")
    if approved:
        policy_path = source / POLICY
        policy = check.strict_json(policy_path.read_bytes())
        for owner, relative, kind in (("LeanInfoTheory.Shannon", UMBRELLA, "umbrella_addition"),
                                     (MODULE, MODULE_PATH, "new_module")):
            check.require(not any(item["owner"] == owner for item in policy["import_approvals"]),
                          f"fixture approval conflicts with existing owner: {owner}")
            policy["import_approvals"].append({
                "owner": owner, "kind": kind, "imports": source_imports(source, relative),
                "rationale": "Isolated C9.03 reviewed additive opt-in qualification; no production approval.",
                "consumer": "tmp/c9-growth-consumer.lean: " + NEW_NAME,
                "approval_reference": "fixture-only:C9.03-R1:approved-module",
            })
        policy_path.write_bytes(check.encode(policy))


def hashes(source: Path, relatives: tuple[str, ...]) -> dict[str, str]:
    return {relative: check.sha256((source / relative).read_bytes()) for relative in relatives}


def check_growth_inventory(source: Path, baseline: dict, case: str) -> dict:
    current = check.strict_json((source / GENERATED[0]).read_bytes())
    old = {entry["name"]: entry for entry in baseline["declarations"]}
    new = {entry["name"]: entry for entry in current["declarations"]}
    expected_name = (ADDED_NAME if case == "compatible_addition" else NEW_NAME if "module" in case else None)
    expected_owner = OWNER[:-5].replace("/", ".") if case == "compatible_addition" else MODULE
    check.require(set(new) - set(old) == ({expected_name} if expected_name else set())
                  and not set(old) - set(new), "fixture did not add exactly the intended declaration")
    if expected_name:
        check.require(new[expected_name]["module"] == expected_owner
                      and not new[expected_name]["attributes"],
                      "growth declaration owner/attributes mismatch")
    expected_modules = set(baseline["supported_modules"]) | ({MODULE} if "module" in case else set())
    check.require(set(current["supported_modules"]) == expected_modules,
                  "fixture current module coverage mismatch")
    check.require(current["declaration_count"] == len(old) + bool(expected_name)
                  and current["documented_declaration_count"] == current["declaration_count"]
                  and current["supported_module_count"] == len(expected_modules)
                  and current["baseline_identity"] == baseline["baseline_identity"]
                  and current["root_exports"] == baseline["root_exports"]
                  and current["non_stable_modules"] == baseline["non_stable_modules"],
                  "fixture inventory changed unrelated current/historical boundaries")
    return current


def generate_twice(source: Path, out: Path) -> dict[str, str]:
    first = None
    for number in (1, 2):
        for index, generator in enumerate(GENERATORS):
            run([sys.executable, "-B", generator], source, out, f"generate-{number}-{index}")
        observed = hashes(source, GENERATED)
        if first is None:
            first = observed
        else:
            check.require(observed == first, "growth generation is not byte-repeatable")
    for index, generator in enumerate((*GENERATORS, "scripts/generate_v0_1_public_api.py")):
        run([sys.executable, "-B", generator, "--check"], source, out, f"check-generated-{index}")
    check.require(hashes(source, GENERATED) == first, "check mode changed generated files")
    write_record(out / "generated-hashes.json", first)
    return first


def output_text(out: Path, label: str) -> str:
    return ((out / (label + ".stdout")).read_bytes() + (out / (label + ".stderr")).read_bytes()).decode(
        "utf-8", errors="replace")


def is_import_policy_refusal(text: str) -> bool:
    return re.search(r"IMPORT_APPROVAL_REQUIRED: LeanInfoTheory\.Shannon(?:;|$)", text, re.MULTILINE) is not None


def maintained_gate(source: Path, out: Path, gate: str, *, approved: bool) -> dict:
    result = run([sys.executable, "-B", "scripts/validate_release.py", gate], source, out,
                 gate, expected=0 if approved else None)
    if not approved:
        check.require(result["exit_code"] != 0 and is_import_policy_refusal(output_text(out, gate)),
                      f"{gate} did not refuse specifically for missing import approval")
    return result


def qualification_gates(source: Path, out: Path, case: str) -> dict:
    check.require(case in CASES, f"unknown growth qualification case: {case}")
    approved = case != "unapproved_module"
    static = maintained_gate(source, out, "static", approved=approved)
    trust = None if case == "unchanged" else maintained_gate(source, out, "trust", approved=approved)
    if not approved:
        maintained_gate(source, out, "compatibility", approved=False)
    return {"static_exit": static["exit_code"], "trust_exit": trust["exit_code"] if trust else None,
            "trust_status": "NOT_RUN" if trust is None else "PASS" if approved else "EXPECTED_POLICY_REFUSAL"}


def consumer(source: Path, out: Path, case: str) -> dict:
    (source / "tmp").mkdir(exist_ok=True)
    path = source / "tmp/c9-growth-consumer.lean"
    if case in {"approved_module", "unapproved_module"}:
        owner, theorem = MODULE, NEW_NAME
    elif case == "compatible_addition":
        owner, theorem = OWNER[:-5].replace("/", "."), ADDED_NAME
    else:
        owner, theorem = MODULE_IMPORT, "Nat.add_zero"
    path.write_text(f"import {owner}\n\nexample (n : Nat) : n + 0 = n := by\n  exact {theorem} n\n",
                    encoding="utf-8", newline="\n")
    write_record(out / "consumer-source.json", {"path": str(path), "source_utf8": path.read_text(encoding="utf-8")})
    # Trust built changed positive owners. The unchanged case and matched
    # unapproved case each request a focused build before the direct consumer.
    if case in {"unchanged", "unapproved_module"}:
        run([sys.executable, "-B", "scripts/validate_release.py", "focused", owner], source, out, "ordinary-module-build")
    return run(["lake", "env", "lean", "-DwarningAsError=true", str(path)], source, out, "direct-consumer")


def check_frozen(source: Path, expected: dict[str, str]) -> None:
    check.require(hashes(source, tuple(expected)) == expected, "growth fixture changed historical artifacts")


def changed_documentation_source(kind: str, text: str) -> str:
    """Make a guarded same-name edit; these cases claim no Lean compilation."""
    declaration = "def natsToBits (x : Real) : Real :=\n  natsToBase 2 x"
    check.require(text.count(declaration) == 1, "documentation fixture declaration anchor changed")
    if kind == "signature":
        return previous.replace_once(text, declaration,
                                     "def natsToBits (x : Real) (_c9Extra : True) : Real :=\n  natsToBase 2 x")
    if kind == "body":
        return previous.replace_once(text, declaration,
                                     "def natsToBits (x : Real) : Real :=\n  natsToBase 3 x")
    if kind == "docstring":
        return previous.replace_once(text,
            "/-- Convert a real-valued quantity measured in nats to bits, namely `x / Real.log 2`. -/",
            "/-- Convert a real-valued quantity measured in nats to bits, namely `x / Real.log 2`. "
            "This sentence is an isolated documentation-freshness fixture. -/")
    raise ValueError(f"unknown documentation mutation: {kind}")


@contextmanager
def temporary_documentation_edit(source: Path, kind: str):
    resolved = source.resolve()
    check.require(resolved.is_relative_to((ROOT / "tmp").resolve()), "documentation edit escaped owned tmp")
    path, manifest = source / DOC_OWNER, source / GENERATED[0]
    for target in (path, manifest):
        check.require(target.resolve().is_relative_to(resolved) and not target.is_symlink(),
                      "redirected documentation mutation input")
    original, original_manifest = path.read_bytes(), manifest.read_bytes()
    changed = changed_documentation_source(kind, path.read_text(encoding="utf-8")).encode("utf-8")
    check.require(changed != original, "documentation mutation did not change source bytes")
    try:
        path.write_bytes(changed)
        yield {"kind": kind, "declaration": DOC_TARGET, "path": DOC_OWNER,
               "original_sha256": check.sha256(original), "changed_sha256": check.sha256(changed),
               "original_bytes_hex": original.hex(), "changed_bytes_hex": changed.hex(),
               "manifest_sha256": check.sha256(original_manifest), "lean_compilation_claimed": False}
    finally:
        path.write_bytes(original)
        manifest.write_bytes(original_manifest)


def require_stale_documentation_refusal(exit_code: int, output: str) -> None:
    check.require(exit_code != 0 and STALE_DOC_DIAGNOSTIC in output,
                  "documentation mutation was not refused specifically for stale source-content identity")


def check_documentation_staleness(source: Path, out: Path, docs: Path) -> list[dict]:
    """Exercise the actual current identity/checker against prior synthetic HTML."""
    original, manifest = (source / DOC_OWNER).read_bytes(), (source / GENERATED[0]).read_bytes()
    command = [sys.executable, "-B", "scripts/check_api_docs.py", "--source-mode", "file",
               "--build-root", str(docs)]
    results = []
    for kind in ("signature", "body", "docstring"):
        case_out = out / ("same-manifest-" + kind)
        case_out.mkdir()
        try:
            with temporary_documentation_edit(source, kind) as mutation:
                write_record(case_out / "mutation-source.json", mutation)
                run([sys.executable, "-B", GENERATORS[0]], source, case_out, "regenerate-current")
                check.require((source / GENERATED[0]).read_bytes() == manifest,
                              f"{kind} documentation fixture changed manifest bytes")
                result = run(command, source, case_out, "stale-doc-check", expected=None)
                require_stale_documentation_refusal(result["exit_code"], output_text(case_out, "stale-doc-check"))
        finally:
            check.require((source / DOC_OWNER).read_bytes() == original
                          and (source / GENERATED[0]).read_bytes() == manifest,
                          f"{kind} documentation fixture did not restore exact source/manifest bytes")
            run(command, source, case_out, "restored-doc-check")
        assessment = {"kind": kind, "outcome": "PASS", "manifest_bytes_unchanged": True,
                      "stale_checker_exit": result["exit_code"], "diagnostic": STALE_DOC_DIAGNOSTIC,
                      "exact_source_restored": True, "restored_checker_passed": True,
                      "lean_compilation_claimed": False, "evidence": str(case_out)}
        write_record(case_out / "assessment.json", assessment)
        results.append(assessment)
    return results


@contextmanager
def temporary_source_negative(source: Path, kind: str):
    """Create a source-only failure, preserving original inventory and source."""
    check.require(kind in SOURCE_NEGATIVES, f"unknown source-negative fixture: {kind}")
    resolved = source.resolve()
    check.require(resolved.is_relative_to((ROOT / "tmp").resolve()), "source-negative edit escaped owned tmp")
    originals = {relative: (source / relative).read_bytes() for relative in (OWNER, GENERATED[0])}
    added = source / UNCLASSIFIED_PATH
    check.require(not added.exists() and not added.is_symlink(), "unclassified fixture path already exists")
    for target in (source / OWNER, source / GENERATED[0], added):
        check.require(target.resolve().is_relative_to(resolved) and not target.is_symlink(),
                      "redirected source-negative input")
    created = False
    try:
        if kind == "unclassified_module":
            header, separator, _ = (source / "LeanInfoTheory/Shannon/InfoMeasures.lean").read_text(
                encoding="utf-8").partition("-/")
            check.require(bool(separator) and header.startswith("/-\nCopyright"), "copyright anchor changed")
            raw = (header + separator + "\n\nimport " + MODULE_IMPORT
                   + "\n\n/-! An isolated unclassified-module source fixture. -/\n").encode("utf-8")
            with added.open("xb") as output:
                created = True
                output.write(raw)
            changed_path, original = UNCLASSIFIED_PATH, None
        else:
            # This is the same documented declaration/proof used by the real
            # compatible-addition case. These supplemental checks run no Lean.
            previous.mutate("compatible_addition", source)
            if kind == "undocumented_addition":
                path = source / OWNER
                path.write_text(previous.replace_once(path.read_text(encoding="utf-8"),
                    "/-- A deliberately isolated compatible-addition regression. -/\n", ""),
                    encoding="utf-8", newline="\n")
            changed_path, original = OWNER, originals[OWNER]
        changed = (source / changed_path).read_bytes()
        check.require(changed != original, "source-negative fixture did not change source")
        check.require((source / GENERATED[0]).read_bytes() == originals[GENERATED[0]],
                      "source-negative fixture changed its original inventory")
        yield {"kind": kind, "path": changed_path,
               "original_bytes_hex": original.hex() if original is not None else None,
               "changed_bytes_hex": changed.hex(), "changed_sha256": check.sha256(changed),
               "original_manifest_sha256": check.sha256(originals[GENERATED[0]]),
               "expected_diagnostics": SOURCE_NEGATIVES[kind], "lean_compilation_claimed": False}
    finally:
        for relative, raw in originals.items():
            (source / relative).write_bytes(raw)
        if created:
            check.require(added.resolve().is_relative_to(resolved) and added.is_file()
                          and not added.is_symlink(), "redirected unclassified fixture cleanup")
            added.unlink()


def require_source_negative_refusal(kind: str, stage: str, exit_code: int, output: str) -> None:
    required = SOURCE_NEGATIVES[kind][stage]
    check.require(exit_code != 0 and all(item in output for item in required),
                  f"{kind} {stage} did not refuse for its required source/inventory reason: {required!r}")


def check_source_negatives(source: Path, out: Path) -> list[dict]:
    originals = hashes(source, (OWNER, GENERATED[0]))
    results = []
    for kind in SOURCE_NEGATIVES:
        case_out = out / ("source-negative-" + kind)
        case_out.mkdir()
        observed = {}
        try:
            with temporary_source_negative(source, kind) as mutation:
                write_record(case_out / "mutation-source.json", mutation)
                # --check leaves the original manifest in place for an otherwise
                # valid but unindexed addition; invalid source must also fail in
                # ordinary generation without replacing that manifest.
                generator = [sys.executable, "-B", GENERATORS[0]]
                if kind == "unindexed_addition":
                    generator.append("--check")
                for stage, command in (("generator", generator),
                                       ("static", [sys.executable, "-B", "scripts/validate_release.py", "static"])):
                    result = run(command, source, case_out, stage, expected=None)
                    require_source_negative_refusal(kind, stage, result["exit_code"], output_text(case_out, stage))
                    observed[stage] = result["exit_code"]
                    check.require(check.sha256((source / GENERATED[0]).read_bytes()) == originals[GENERATED[0]],
                                  f"{kind} {stage} mutated the original inventory")
        finally:
            check.require(hashes(source, tuple(originals)) == originals
                          and not (source / UNCLASSIFIED_PATH).exists(),
                          f"{kind} did not restore exact source/inventory")
            run([sys.executable, "-B", GENERATORS[0], "--check"], source, case_out, "restored-current-check")
        assessment = {"kind": kind, "outcome": "PASS", "observed_exits": observed,
                      "expected_diagnostics": SOURCE_NEGATIVES[kind], "original_manifest_preserved": True,
                      "exact_source_restored": True, "restored_current_check_passed": True,
                      "lean_compilation_claimed": False, "evidence": str(case_out)}
        write_record(case_out / "assessment.json", assessment)
        results.append(assessment)
    return results


def main() -> int:
    workspace = ROOT / "tmp" / ("c903-" + uuid.uuid4().hex)
    source = workspace / "s"
    before = production_inputs()
    workspace.mkdir(parents=True)
    setup = workspace / "setup"
    setup.mkdir()
    originals = None
    outcomes = []
    try:
        originals = make_growth_copy(source, setup, before)
        baseline = check.strict_json(originals[GENERATED[0]])
        frozen = hashes(source, ("docs/v0.1-public-api.json", "docs/compatibility/v0.1.0-retained-contract.json"))
        approved_surface = None
        approved_docs = None
        for case in CASES:
            out = workspace / case
            out.mkdir()
            if case == "unapproved_module":
                # Keep exactly the same Lean, generated artifacts and HTML as
                # the approved sibling. Only its two fixture approvals disappear.
                (source / POLICY).write_bytes(originals[POLICY])
            else:
                restore_source(source, originals)
                if case == "compatible_addition":
                    previous.mutate(case, source)
                elif case == "approved_module":
                    add_module(source, approved=True)
            approved = case != "unapproved_module"
            generated = generate_twice(source, out)
            check_growth_inventory(source, baseline, case)
            snapshot_paths = (*GENERATED, OWNER, UMBRELLA) + ((MODULE_PATH,) if "module" in case else ())
            surface = hashes(source, snapshot_paths)
            write_record(out / "source-snapshot.json", {
                "hashes": surface, "policy_sha256": check.sha256((source / POLICY).read_bytes()),
                "policy_utf8": (source / POLICY).read_text(encoding="utf-8"),
                "mutations_utf8": {rel: (source / rel).read_text(encoding="utf-8") for rel in (OWNER, UMBRELLA, MODULE_PATH)
                                   if (source / rel).exists() and (rel not in originals or (source / rel).read_bytes() != originals[rel])},
            })
            if case == "unapproved_module":
                check.require(surface == approved_surface, "matched module pair changed Lean or generated bytes")
            gates = qualification_gates(source, out, case)
            consumer(source, out, case)
            # The maintained synthetic writer and checker retain their normal
            # source-policy checks. The unapproved sibling reuses identical HTML
            # and must be rejected by policy before documentation acceptance.
            docs = out / "synthetic-docs" if approved else approved_docs
            if approved:
                run([sys.executable, "-B", "scripts/test_api_docs.py", "--write-fixture", str(docs)],
                    source, out, "write-synthetic-docs")
            docs_result = run([sys.executable, "-B", "scripts/check_api_docs.py", "--source-mode", "file",
                               "--build-root", str(docs)], source, out, "check-synthetic-docs", expected=0 if approved else None)
            if not approved:
                check.require(docs_result["exit_code"] != 0
                              and is_import_policy_refusal(output_text(out, "check-synthetic-docs")),
                              "unapproved docs failed for a different cause than source policy")
            doc_hashes = {path.relative_to(docs).as_posix(): check.sha256(path.read_bytes())
                          for path in sorted(docs.rglob("*")) if path.is_file()}
            write_record(out / "synthetic-doc-hashes.json", doc_hashes)
            doc_invalidations = check_documentation_staleness(source, out, docs) if case == "unchanged" else []
            source_negatives = check_source_negatives(source, out) if case == "unchanged" else []
            if doc_invalidations:
                check.require({path.relative_to(docs).as_posix(): check.sha256(path.read_bytes())
                               for path in sorted(docs.rglob("*")) if path.is_file()} == doc_hashes,
                              "documentation invalidation checks modified their saved HTML/configuration")
            if case == "approved_module":
                approved_surface, approved_docs = surface, docs
                approved_doc_hashes = doc_hashes
            elif case == "unapproved_module":
                check.require(doc_hashes == approved_doc_hashes, "matched module pair changed HTML fixture bytes")
            check_frozen(source, frozen)
            result = {"case": case, "outcome": "PASS", "expected_policy_pass": approved,
                      **gates,
                      "docs_checker_exit": docs_result["exit_code"], "direct_consumer_passed": True,
                      "generated_sha256": check.sha256(check.encode(generated)),
                      "same_manifest_documentation_invalidations": doc_invalidations,
                      "supplemental_source_negatives": source_negatives,
                      "documentation_kind": "synthetic checker input; not real doc-gen", "evidence": str(out)}
            outcomes.append(result)
            write_record(out / "assessment.json", result)
            print(json.dumps(result), flush=True)
        restore_source(source, originals)
        restored = workspace / "restored"
        restored.mkdir()
        maintained_gate(source, restored, "static", approved=True)
        maintained_gate(source, restored, "compatibility", approved=True)
        check_frozen(source, frozen)
        check.require(production_inputs() == before, "production source changed during growth qualification")
        summary = {"outcome": "PASS", "workspace": str(workspace), "cases": outcomes,
                   "restored_source_passed_static_and_compatibility": True,
                   "restored_all_project_axiom_audit": "NOT_RUN", "production_inputs_unchanged": True,
                   "source_input_sha256": check.sha256(check.encode(before)),
                   "evidence_schedule": SCHEDULE_BASIS, "limits": LIMITS}
        write_record(workspace / "summary.json", summary)
        print(json.dumps(summary), flush=True)
        return 0
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        write_record(workspace / "failure.json", {"outcome": "FAIL", "diagnostic": str(error), "completed_cases": outcomes})
        print(f"growth fixtures failed; originals retained at {workspace}: {error}", file=sys.stderr)
        return 1
    finally:
        if originals is not None:
            restore_source(source, originals)
            write_record(workspace / "restoration.json", {
                "recorded_owned_bytes_restored": True,
                "new_module_removed": not (source / MODULE_PATH).exists(),
                "production_inputs_unchanged": production_inputs() == before,
                "restored_hashes": hashes(source, tuple(originals)),
            })


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
    raise SystemExit(main())
