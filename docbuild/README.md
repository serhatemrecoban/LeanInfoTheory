# LeanInfoTheory documentation build

This nested Lake project keeps `doc-gen4` out of LeanInfoTheory's runtime
dependency graph. It duplicates the root's fixed Lean `v4.33.1` toolchain pin
and uses the same frozen mathlib release environment. Doc-gen4 is pinned at
`v4.33.1`, commit `e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015`, with all
transitive Git dependencies locked by the nested manifest.

Run the maintained build and coverage check from the repository root:

```powershell
python scripts/validate_release.py api-docs
```

That command explicitly uses local `file:` source links unless `DOCGEN_SRC` is
set to `github`. GitHub mode is accepted only for a clean checkout and produces
exact-commit links; local file-linked output is not a publication artifact.
Generated files live under `docbuild/.lake/build/doc` and are intentionally
untracked. See [`docs/api-documentation.md`](../docs/api-documentation.md) for
the full build, validation, serving, and publication-boundary contract.

This command is the explicit release/milestone gate. The routine
`python scripts/validate_release.py` suite and ordinary push/pull-request CI do
not run it. A manual workflow dispatch can opt into the separate `api_docs`
GitHub-mode job after the routine gates.

On Windows, set `LEANINFOTHEORY_ZIG` to the `zig.exe` from the pinned official
Zig 0.16.0 x86_64 archive. The validator requires SHA-256
`086ce9d47ba42f33a514e1a6e04eb1d4a8fa1d75e0868e0213caad447c91e864`
for the executable and compiles the small project-authored `CCShim.lean`
forwarding executable directly with the pinned Lean toolchain. Linux uses a
system `cc`; downstream library users need neither compiler setup.

The maintained documentation build disables doc-gen4's optional equation
extraction and validates that the database contains zero equation rows.
Rendered declaration names, headers, types, documentation, and source links are
unaffected. Expected pages, declarations, canonical export targets and non-stable
exclusions come from the schema-validated, source-matching
[`current manifest`](../docs/current-public-api.json) and reviewed growth policy.
The historical v0.1.0 result was 31 pages, 601 declarations, 92 targets and 13
exclusions; these are not current count ceilings.

The v2 build configuration and two-pass attestation identify current source
content, manifest/retained-contract bytes, build/checker inputs and pinned
dependencies. A signature, definition body or docstring edit invalidates old
evidence even if manifest entries are unchanged. Content changes preserve
incremental caches; link-mode changes invalidate generated mode-sensitive output.
Inspect current file-mode output directly here: it cannot be staged under the
frozen `/docs/v0.1.0/` route. The separate frozen release/maintenance procedures
retain their exact identities and publication guards. Generated types document
the current tree; retained structural fingerprints and source review govern
compatibility, and matching types do not establish unchanged semantics.

## Current C11 milestone

C11 adds `LeanInfoTheory.Probability.Coupling` and its ten public declarations.
The explicitly authorized initial C11 checkpoint
`2147dd3449af620f41d9bed8d37c5be8252f20e8` completed both real checked file-mode
passes: `234.8s and 19.9s`, with 638 declarations, 33 supported module pages,
92 canonical export targets, 19 non-stable exclusions and zero equation rows.
`.lit-review/setup/c11-06-api-docs-recovered-20260927/result.json` preserves the original result. `.lit-review/setup/c11-06-api-doc-inspection-utf8-20260927.json` records the
actual Coupling page, all ten signatures/docstrings and correct ownership.
The v2 attestation is `docbuild/.lake/build/api-doc-build-attestation.json`, with
its original source/configuration/dependency evidence retained privately.

The run used local file mode, disabled equation extraction and the reviewed
Windows Zig executable. The [maintained C11 handoff](../docs/handoffs/chunk-11.md) identifies original evidence
and applicability limits. Amended candidates require exact attestation
applicability or a new complete two-pass run. Source-bound C11.06 private records
establish final validation, cumulative review, reconciliation and closure.
Current local output must not be staged under the frozen release route.

The first API-doc run failed its semantic check because the generated manifest
omitted the new Coupling HTML page, although Coupling and Shannon docInfo rebuilt.
The original failure remains at
`.lit-review/setup/c11-06-api-docs-checkpoint-20260927/result.json`. The recovery
record `.lit-review/setup/c11-06-doc-marker-recovery-20260927.json` preserves the
bytes of exactly three ignored Shannon HTML completion-marker/hash/trace files
before their invalidation. The complete two-pass rerun passed at
`.lit-review/setup/c11-06-api-docs-recovered-20260927/result.json`. No maintained
source, validator, dependency pin or API contract changed. Both attempts replayed
upstream Qq docInfo warnings for `mkLambdaQ` and `withLetHave`; all current
supported signatures passed the successful rerun's semantic checks.

The first page inspector saved all ten successful declaration checks before its
console output failed on a Unicode symbol. The same read-only inspector passed
with Python UTF-8 output; the original inspection and the console-error
observation remain preserved beside the successful inspection record.

## Historical C10 milestone evidence and applicability

The initial C10.07 gate completed both real file-mode passes for the then-current
628-declaration/32-module surface, with 92 canonical export targets, 17 excluded
non-stable modules and all 25 TV signatures. Its current v2 source-content
attestation and original process results are identified in the
[C10 handoff](../docs/handoffs/chunk-10.md) and source-bound private records.
The clean routine suite and fresh cumulative review also succeeded; the original
review was explicitly reconciled. Final amended-candidate validation, exact
API-doc/review applicability and completion are established by C10.07's
source-bound private records. This maintained chronology does not itself certify
closure. Neither old output nor matching counts substitute for applicable
content-bound evidence.

C9.07's 603/31/92/15 milestone is historical and retained in its
[handoff](../docs/handoffs/chunk-9.md). Its old current-source attestation does not
cover the C10 owner and consumers. Keep current local output separate from the
frozen release route; no staging or publication is included.
