# Downstream API Feedback

This document is the canonical LeanInfoTheory register for deduplicated,
actionable post-`v0.1.0` API-discoverability feedback from downstream users and
projects. It is not a chronological development log and should not contain
every ordinary successful search.

## Ownership and flow

- Downstream projects own detailed task notes, search attempts, and local
  workarounds.
- LeanInfoTheory records here only reproducible friction that may justify an
  upstream documentation, naming, import, statement, or theorem change.
- Future Work Note 14 in [`project-log.md`](project-log.md) remains the
  theorem-development naming/alias watchlist, historical decision record, and
  source of its standing review criteria. Downstream search observations
  belong here rather than being appended to that declaration-audit watchlist.
- An accepted action may be cross-referenced from the project log, roadmap, or
  an approved plan, but those documents should not duplicate the raw evidence.

The planned Perfect Functional Representations formalization is the first
intended substantial downstream discoverability test. That role is an evidence
collection opportunity, not a presumption that the current API is difficult to
use or that every downstream convenience belongs upstream.

## Reproduction and search protocol

Before classifying a result as missing, search in proportionate order:

1. the current LeanInfoTheory source;
2. the generated declaration index and signature-bearing API documentation;
3. likely focused modules and the `LeanInfoTheory` or
   `LeanInfoTheory.Shannon` umbrella;
4. the pinned mathlib source;
5. available Lean tools such as `#check`, `#print`, `exact?`, `apply?`,
   `#loogle`, or `#search`.

Verify any candidate with `#check`, `#print`, or a small compiling probe. When
the downstream project uses a released version, reproduce the issue against
that exact release and then check current `master` separately. Do not add a
production dependency merely to obtain a search command.

Classify the primary source of friction as one of:

- unpredictable name;
- inconsistent vocabulary;
- unclear module ownership or required import;
- insufficient documentation or indexing;
- missing alias or wrapper;
- inconvenient statement or assumptions; or
- genuinely missing theorem.

## Decision policy

A downstream complaint does not automatically authorize an upstream change.
First reproduce and deduplicate it, identify whether the result already exists,
and determine whether the need is general information theory or specific to
the downstream application.

For `0.1.x`, preserve the supported contract in
[`v0.1-public-api.md`](v0.1-public-api.md). Prefer a documentation or import
clarification when the existing declaration is adequate. Add a compatibility
alias only when evidence shows that it materially improves discovery; do not
add multiple synonymous aliases speculatively. Propose a new theorem only when
the result is genuinely absent and belongs in the reusable library.

Do not build a custom theorem-search engine, semantic index, or naming linter
until recurring failures remain after the ordinary process above. The amount
and quality of friction, not theorem-count growth, determines whether new
infrastructure is justified.

## Entry template

Add an entry only for genuine friction. Use these fields:

```text
### <short identifier>: <mathematical capability>

- Status: observed | no upstream change needed | documentation fix proposed |
  alias proposed | theorem proposed | fixed upstream | intentionally deferred
- Downstream task and consumed LeanInfoTheory version:
- Mathematical fact or capability needed:
- Informal search terms or theorem shapes tried:
- Search mechanisms used:
- Existing declaration, owner, and required import, if found:
- Primary friction classification:
- Temporary downstream workaround:
- Proposed upstream response:
- Reproduction or validation evidence:
```

## Current register

### C9-INTAKE-02: auxiliary-variable entropy/MI decomposition

- Status: fixed upstream in C9.06 and durably closed as
  `82a1b5a429693718c24f2863d7d077c5010d9403e5836e5a30c61d307be16263`.
  All three independent criteria were satisfied; two nonmaterial process findings
  were reconciled with final-source disclosure/impact evidence, preserving their
  original claims and historical noncompliance. C9.07 cumulative qualification
  and review are required; the [chunk handoff](handoffs/chunk-9.md) identifies
  the actual source-bound records that determine their results and closure.
- Downstream task/version: the [existing bounded intake](plans/post-release-chunk-map.md#c9-post-release-complementary-work)
  records `PerfectFunctionalRepresentations.mutualInfoOf_eq_pfr_decomposition`
  and its structural specialization. The consumed LeanInfoTheory commit is not
  recorded here. No fresh downstream access, reproduction or adoption is claimed.
- Capability/classification: a reusable derived algebraic identity,
  `I(Y;Z) = H(Y|X) - I(X;Z|Y) - H(Y|(X,Z)) + I(X;Z)`; the paper-specific predicate/equivalence
  remains downstream. Existing MI/CMI identities provide the proof ingredients.
- Upstream response/import: `LeanInfoTheory.Shannon.mutualInfoOf_condEntropyOf_decomposition`,
  imported through `LeanInfoTheory.Shannon.InfoMeasures`. Preserve canonical nats,
  finite observed alphabets, arbitrary source and ordered pair `(X,Z)`.
  The name follows the approved generic vocabulary; no alias or released rename.
- Consumer/search evidence: private general, exact two-zero, singleton and sparse
  upstream consumers test the intended interface. Local source and existing
  identity names are the reuse anchors; actual focused/root/aggregate compilation
  and its source applicability are recorded in the step notes. The zero-term
  consumer is not new downstream demand or evidence of downstream integration.
- Naming/reference disposition: Note 14 records the selected name/no-alias
  decision. CT91 Sections 2.4/2.5 supply underlying MI/chain-rule context; the
  derived formula is not attributed as a separate named textbook theorem.

### C9-INTAKE-01: deterministic postprocessing of independent PMF variables

- Status: fixed upstream in C9.05 source; independent review assessed all three
  criteria as satisfied with no findings and was explicitly reconciled. Actual
  evidence and final-validation status are tracked in the [step handoff](plans/post-release-chunk-09-notes.md#c905-independence-postprocessing-and-prepared-handoff-2026-09-12).
  C9.05 completed durable closure `502e426a14dff8c25557b3a55fdd06ab427e675e552d3e9b048b7967a5bdff85`.
- Downstream task/version: the [bounded intake already recorded in the chunk map](plans/post-release-chunk-map.md#c9-post-release-complementary-work)
  reports PFR's canonical-representation consumer and local
  `PerfectFunctionalRepresentations.isIndependentOf_comp_right`. Its exact
  consumed LeanInfoTheory commit is not recorded here. No fresh downstream
  access, reproduction or adoption is claimed.
- Capability/classification: preserve PMF independence under an arbitrary right
  map without finiteness or measurability premises; missing general theorem.
- Search: current source, generated declaration index/API output, focused
  Independence/Product owners and pinned mathlib map/bind/IndepFun declarations;
  a compiling arbitrary-type probe verifies the reuse path. Existing finite DPI
  or measurable `IndepFun.comp` statements do not supply this exact contract.
- Upstream response/import: `LeanInfoTheory.Shannon.isIndependentOf_comp_right`
  in `LeanInfoTheory.Shannon.SemanticBridge.Independence`. Existing symmetry
  supplies left processing; no public wrapper/alias or downstream structure.
- Validation: six private upstream permanent consumers cover arbitrary products,
  non-injective and constant maps, infinite types, symmetry and finite zero MI;
  actual build/trust/compatibility evidence and its limits live in the step notes.
  This upstream reproduction does not establish downstream integration.
