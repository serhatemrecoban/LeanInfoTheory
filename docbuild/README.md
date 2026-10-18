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

## Current C18 milestone

C18 adds fifteen theorems across semantic FiniteProduct, ProductKL,
ProductChannel, FiniteFamily and FiniteFamilyIndependence. Current source
coverage is 713 documented declarations in 45 supported owners, with 92 root
exports, 94 reviewed simp declarations and 36 non-stable exclusions.

<!-- c18-06-api-docs:start -->
Both actual current file-mode build/check passes passed; the full successful
gate took 693.925 seconds. The parent inspected all fifteen new
declaration signatures, hypotheses, docstrings, owners and local source links
against the v2 content/configuration identity and two-pass attestation. Guarded
Real KL, swapped conditional-output entropy, actual marginals, full output mutual
independence, unrestricted length and arbitrary-source/four-universe statements
match source. This was semantic HTML inspection, not browser visual QA.
The first missing-page failure and bounded three-marker recovery remain retained.
All source/configuration/dependency inputs were unchanged during the successful
gate; evidence-prose changes require separate applicability. Existing caches
were used. Under the lead's scoped checkpoint/amendment/reuse approval, initial
checkpoint `8b30dc96e89a9b4e0224b059faed48e19a4e5f1e` passed the complete
maintained clean routine separately. Readiness, fresh cumulative review,
reconciliation, exact final applicability and closure require their actual
source-bound records, including `.lit-review/setup/c18-06-completion-20261018.json`
when present; this captured account does not certify them. Every amendment
requires the complete maintained clean rerun and exact API applicability.
<!-- c18-06-api-docs:end -->

The [C18 handoff](../docs/handoffs/chunk-18.md) records captured qualification and evidence boundaries.
Actual local output stays under `docbuild/.lake/build/doc/`; the frozen v0.1.0
route, dependencies and build/checker contracts are unchanged. The API gate,
complete maintained clean routine, cumulative independent review and exact
closure retain separate evidence and applicability requirements.

## Historical C14 milestone

C14 adds `Shannon.Continuity` and six public declarations. Current coverage is
653 documented declarations in 36 supported owners, with 92 root exports,
94 reviewed simp declarations and 24 non-stable exclusions. Inspect the exact-TV
entropy statement, total capped scalar definition, monotonicity on nonnegative
budgets and the three entropy/conditional-entropy/MI budget statements. Preserve
Nat subtraction, independent coordinate universes, the sole TV-budget premise,
and separate joint/marginal cardinalities and thresholds.

<!-- c14-04-api-docs:start -->
Both actual current file-mode build/check passes passed (160.9s and 22.0s),
followed by inspection of all six new declaration blocks and the full Shannon
umbrella against the v2 source/configuration identity and two-pass attestation.
The original missing-Continuity-page failure and bounded three-marker repair
remain separately recorded. The recovered run kept all tracked/unignored source
unchanged. Later result-recording prose does not alter the exact API inputs;
applicability is checked separately. Existing pinned dependencies/caches were used.
The clean routine, cumulative review and closure remain pending.
<!-- c14-04-api-docs:end -->

The [C14 handoff](../docs/handoffs/chunk-14.md) records source/configuration identities,
original checks, failures and limits. Current output stays in
`docbuild/.lake/build/doc/`, outside the frozen release route. Exact applicability
must be checked after any source amendment; caches may be reused without calling
this a cold rebuild.

## Historical C13 milestone

C13 added `Shannon.SemanticBridge.Pinsker` and five public theorems. Its milestone
coverage was 647 documented declarations in 35 supported owners, with 92
canonical exports, 94 reviewed simp declarations and 23 non-stable exclusions.
The new page must retain canonical ENNReal KL, both explicit support guards,
the constant two and the two MI forms without public measurable-space premises.
The [C13 handoff](../docs/handoffs/chunk-13.md) and private C13.04 records retain the actual
checks and their limits. Both actual build/check passes succeeded (112.2s and
14.6s), followed by all-five-declaration inspection and v2 attestation checks.
The initial missing-Pinsker-page failure and bounded aggregate-marker repair
remain separately recorded. Exact applicability is checked after amendments.
C12 output is historical and cannot qualify the new source. The clean routine
suite and cumulative review remain separate requirements. Current generated
output stays in `docbuild/.lake/build/doc/`, outside the frozen release route.

## Historical C12 milestone

C12 adds the supported `Shannon.SemanticBridge.Gluing` owner and four public
theorems across Gluing, Coupling and FiniteChannel. That milestone covered 642
documented declarations in 34 supported modules, with 92 canonical exports,
94 reviewed simp declarations and 21 non-stable modules excluded.
C12.04's preparation completed both actual current file-mode passes and
inspection of all four new declarations, including the new Gluing page.
The initial stale aggregate-HTML-marker failure and bounded recovery are retained
separately from that success; exact applicability must be checked after changes.
The [C12 handoff](../docs/handoffs/chunk-12.md) and private C12.04 evidence retain the exact
source/configuration identity, output attestation, observations and failures.
Earlier C11 output is historical evidence and does not qualify the C12 source.
The full clean routine suite and fresh cumulative review are separate duties.
Current output stays local and separate from the frozen release route.

## Historical C11 milestone

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
