# Chunk 13 implementation notes

The [approved revision-2 plan](post-release-chunk-13.md) supplies the public
contracts and step goals. The lead permits reasoned adaptation during the
work; these notes record the choices and evidence. Private review records
establish each step's actual completion.

## C13.01 — Canonical ENNReal Pinsker

The new focused semantic owner supplies one public theorem,
`ofReal_two_mul_totalVariation_sq_le_klDiv`. It uses half-L1 TV and natural
logarithms, includes singular support and infinite KL, and assumes a finite
enumerated alphabet with measurable singletons. All analytic and Boolean
machinery stays private. Real, square-root and MI corollaries remain later
steps.

### Proof and source adaptation

PW24, August 16, 2024, Section 7.4, Theorem 7.10, equation (7.27), printed
pages 126--127 / PDF pages 151--152, supplies the binary-reduction argument.
The local edition is identified by SHA-256
`c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
The source's `2 log e` becomes 2 in nats.

For an interior reference parameter, subtract the quadratic term from binary
KL. The gap is continuous on the closed unit interval; its second derivative
on the interior is `(2*x-1)^2 / (x*(1-x))`, so the gap is convex and has its
minimum zero at the reference parameter. This uses closed-interval convexity
in place of the source's integral Taylor remainder and covers numerator
endpoints directly. Zero reference atoms are handled before division or log
expansion: finite KL forces equality of Boolean laws, and singular KL is top.

The existing attained event reduces general finite PMFs to Bool while
preserving TV exactly. Existing unconditional KL map data processing then
lifts the binary inequality. No real conversion of an infinite KL value is
used. C10's TV surface and the existing KL/DPI surface supply the probability
and semantic interfaces; coupling and gluing are not dependencies.

### Consumers and scope

`Examples.Pinsker` imports the focused owner. Its private consumers cover
the Boolean parameter orders and endpoint/support branches, then a positive
three-point pair. The latter has a positive-mass tie in its attaining event,
TV `1/4`, KL `ofReal ((1/4 : ℝ) * log 2)` and Boolean true masses `3/4`
and `1/2`. Only TV is preserved by this reduction; the proof uses the KL
data-processing inequality. Constructors and conveniences stay private.

The semantic aggregate imports the new owner, and the non-stable Examples
aggregate imports its consumer. The root retains its lightweight boundary.
Current policy and generated references follow the actual imports and public
declaration. No new simp attributes or public analytic helpers are added.

### Validation and remaining work

The step uses maintained focused builds, static checks and the trust gate,
with actual `lake --wfail build` enforcement. Commands, original output,
source identity, self-review, separate reassessment and independent-review
reconciliation are retained under `.lit-review/` for this step. This text
does not claim a later private closure in advance.

The owner, semantic/full aggregates and lightweight root passed maintained
focused builds. The consumer and Examples aggregate also passed after a
single project-linter line-length correction. Earlier direct consumer attempts
needed explicit finite-coordinate reduction; their diagnostics are retained,
and no source proof placeholder was introduced. The final statement and its
axiom report were checked from the compiled focused owner.

The full trust gate passed in 1185.629 seconds. It compared all 601 retained
release signatures, checked all 35 supported import closures, 643 public
names, 94 simp declarations, 92 root exports, private/non-stable exclusions
and all 1,819 compiled local constants across 57 modules. Only `propext`,
`Classical.choice` and `Quot.sound` were reported. The original command and
streams are retained in `.lit-review/setup/c13-01-trust-20261003/`. This is
incremental dirty-tree qualification for C13.01. The complete clean routine
suite and signature-bearing API-doc milestone remain C13.04 obligations.
Independent review, reconciliation and final source capture establish the
step's later private closure; this candidate text makes no advance claim.

C13.02 owns guarded Real/square-root forms, sparse finite-KL budget consumers
and proofs disproving the unguarded Real inequalities. C13.03 owns quantitative
independence. C13.04 owns the cumulative clean suite, the actual two-pass API-doc
milestone, final review and maintained handoff. No later step, checkpoint or
publication is selected by C13.01.

## C13.02 — Guarded Real and square-root consequences

C13.01 and its review subsequently completed under private closure
`0bd0f6d203cde547d593721e70672471c1c644f96fdf1d1043ca451d73f4cfda`.
The full final source inventory matched before the lead's conditional request
selected C13.02. Its approved mathematical contracts are unchanged.

### Guard conversion and proof choices

`two_mul_totalVariation_sq_le_toReal_klDiv` derives finite KL from the explicit
support inclusion before applying `ENNReal.ofReal_le_iff_le_toReal` to the
canonical inequality. `totalVariation_le_sqrt_toReal_klDiv` then uses that
guarded bound and `Real.le_sqrt_of_sq_le`. The latter lemma already supplies
the sign reasoning needed by the square root, so no auxiliary public result
or separate sign proof is needed. Both retain the exact approved arguments,
half-L1 normalization and constants in nats.

The owner directly imports `Mathlib.Analysis.Real.Sqrt`, the owner of the
new square-root lemma. Although the existing convexity import already exposes
it transitively, the explicit import records the actual dependency. The
growth policy records this focused addition. C13.01's proof is unchanged;
the root and probability imports, simp surface and dependency pins are unchanged.
These are algebraic consequences of the already recorded PW24 adaptation,
so no additional textbook theorem or external formalization is used.

### Permanent consumers

Private consumers exercise both public forms directly, derive support from
non-top KL, and implement the exact event-budget contract. The latter obtains
finite KL from the ENNReal upper bound before any `toReal` conversion, then
combines the existing event discrepancy bound with Pinsker and square-root
monotonicity. Its specified `[Fintype α]` binder triggers
`linter.unusedFintypeInType` because enumeration appears only in the proof.
A single-declaration suppression preserves the approved exact private contract;
the project-wide linter remains enabled.

For `p=(1,0,0)` and `q=(1/2,1/2,0)`, the consumer proves support inclusion,
finite KL, the common zero, TV `1/2`, KL `ofReal (log 2)` and KL.toReal
`log 2`. It consumes the canonical, support-guarded, non-top-guarded and
event-budget forms. This reference law lacks full support. Equal laws, pure
laws, subsingletons and impossible empty laws retain explicit coverage.
Distinct pure Bool laws prove TV `1`, KL top and KL.toReal `0`, use the
canonical inequality, and formally disprove both unguarded Real inequalities.
No public non-top wrapper, KL-budget wrapper or new constructor is added.

### Validation and next boundary

The strict owner compile passed without diagnostics. An earlier bounded
availability-only import probe was terminated without diagnostics; it is
inconclusive and is not counted as a pass. The first maintained consumer run
failed only on the local Fintype linter described above; its original output
is retained separately from corrected-source checks. Exact commands, source
identities and streams are preserved under `.lit-review/`.

The corrected six-target maintained focused build passed in 23.800 seconds
with `lake --wfail`; static checks also passed. The complete trust gate passed
in 1169.603 seconds, including all 601 retained signatures, 35 supported
import closures, 645 public declarations, 94 simp declarations, 92 root
exports and all 1,857 compiled local constants across 57 modules. Only
`propext`, `Classical.choice` and `Quot.sound` were reported. Original full
streams are retained in `.lit-review/setup/c13-02-trust-20261003/`.
These are incremental dirty-tree checks. The full clean routine suite and
the actual two-pass API-doc milestone remain C13.04 obligations.

The current manifest contains 645 public declarations in 35 supported owners,
94 reviewed simp declarations and 92 root exports. The source index contains
760 declarations, 759 documented, across 57 modules and 122 local edges.
Independent review and final capture establish the later private closure;
this candidate text does not anticipate their result. C13.03 quantitative
independence and C13.04 cumulative qualification remain unselected.

## C13.03 — Quantitative independence

C13.02 and its review completed under private closure
`31dc66de21bc880aa46603992511519cc1a128a90670bc06830185361a961808`.
Its complete final source inventory matched before the lead's conditional
request selected C13.03. The approved contracts and four criteria are unchanged.

### Joint-to-product proof and public boundary

`two_mul_totalVariation_sq_le_mutualInfo` and
`totalVariation_le_sqrt_mutualInfo` use the joint law's own marginal product.
Each theorem has independent alphabet universes and only the two Fintype
instances and joint PMF as arguments. Inside the proofs, a discrete measurable
structure is chosen on the pair alphabet. A private helper derives actual
finite KL from existing joint-to-product absolute continuity and the support
criterion. The public proofs use that finite result to supply the existing
guarded Pinsker forms before applying the MI-as-KL identity. Null marginal
rows therefore require no public full-support or nonemptiness assumption.

The focused owner now has exactly the approved five public declarations.
No imports or attributes were added in this step, and removing the Step 3
additions reproduces the exact Step 2 owner bytes. The root and probability
owners retain their imports, and Pinsker has no coupling/gluing dependency.
The theorem names follow the approved family; no new alias or naming-watchlist
entry is justified. This is a derived application of the already recorded
Pinsker proof and existing MI bridge, without a separate textbook theorem.

### Permanent private consumers

`Examples.QuantitativeIndependence` imports only the focused Pinsker owner.
Its MI-budget consumer derives nonnegativity of the budget from MI nonnegativity.
It supplies event and `[0,1]` expectation bounds with constant `sqrt (ε / 2)`
and a signed `|f| ≤ 1` test with the explicit constant `2 * sqrt (ε / 2)`.
The random-variable consumers use actual `mutualInfoOf`, mapped joint laws and
pushforward marginals, leaving the source type arbitrary. Independent products,
zero MI, singleton coordinates and impossibility of either empty coordinate
are explicit. All constructors and theorems are private; measurable instances
are local to the sparse example.

The fair diagonal joint on `Fin 3 × Bool` puts mass `1/2` at `(0,false)` and
`(1,true)`. The source proves its six atom masses, both marginals, all product
masses and the null row at coordinate `2`. TV to its own marginal product is
`1/2`; MI and KL.toReal are `log 2`; KL is `ofReal (log 2)` and finite.
Its support argument comes from joint-to-product absolute continuity. These
exact identities feed actual uses of both new public bounds. The existing
`Examples.Pinsker` remains unchanged and continues to consume the other three
members of the public family.

### Validation and remaining boundary

The owner passed strict compilation in 80.426 seconds without diagnostics.
The first strict invocation rejected four `letI` style warnings; the proofs
already elaborated, and replacing those binders with the repository's `let`
and `have` local-instance pattern resolved them. Original failing and passing
streams and source hashes are retained separately under `.lit-review/`.

The first maintained consumer invocation failed two concrete Fin-index rewrites
after `fin_cases`; explicit definitional `change` statements for those two rows
resolved the matching issue. The corrected seven-target focused build passed
in 25.208 seconds with `lake --wfail`, covering the owner, both permanent
consumers, affected aggregates and root. The initial static check also passed.
No public contract or consumer hypothesis changed during either repair.

The complete trust gate passed in 953.423 seconds: all 601 retained signatures,
35 supported import closures, 647 supported declarations, 94 reviewed simp
declarations, 92 root exports and 1,906 compiled local constants across
58 modules. Only `propext`, `Classical.choice` and `Quot.sound` were reported.
All compiled inputs, configuration and generated inventory hashes matched
before and after the run. Original full streams are retained at
`.lit-review/setup/c13-03-trust-20261003/`. The separate strict stdin check
confirmed all five public signatures, including independent universes and no
extra hypotheses on the two new forms, with only the same permitted axioms.
Final static validation covers the completed validation-result documentation.
These are incremental dirty-tree checks; no clean release checkpoint or
signature-bearing API-doc milestone is claimed.

The current manifest contains 647 public declarations in 35 supported owners,
94 reviewed simp declarations and 92 root exports. Generated references contain
58 local modules, 124 local edges and 762 indexed declarations, 761 documented.
The root retains its five-module closure.

Independent review, reconciliation and final source capture establish the later
private closure. This candidate text makes no advance claim of their result.
C13.04 remains the cumulative clean routine suite, actual two-pass API-doc
milestone and maintained next-chunk handoff; it is not selected by this step.

## C13.04 — Cumulative qualification preparation

C13.03 and its review completed under private closure
`9a6105e02101b696ff9c81aed49be4bc45d6f8bb15f2fb7bce59ee9cea2a5823`.
The complete Step 3 final inventory matched before the conditional Step 4 request
was accepted. All ten preceding criterion assessments and their original
reconciliations remain durable prerequisite evidence; the final reviewer must
freshly assess those ten and the three cumulative criteria together.

This step keeps the complete mathematical source, API policy, generated inventory
and dependency pins unchanged. The [C13 handoff](../handoffs/chunk-13.md) records
the delivered interfaces, focused imports, private consumers, reference choices,
validation evidence and remaining-work owners/triggers. Canonical current-state,
README/module guidance, roadmap/map, references and API-doc guidance are reconciled.
Historical release and C12 evidence remain separately identified.

Prepare the exact owned diff before requesting the separate checkpoint authority
required by plan Section 6.2. The proposed clean validation checkout will contain
the authorized commit and the committed baseline website notes; the unrelated
working notes remain untouched in the original checkout. Verify source and
dependency identities and disclose reused incremental caches. The complete
routine suite, cumulative review, reconciliation and private closure remain
pending at this preparation boundary. No later chunk or publication follows
automatically.

### Preparation validation and applicability

The corrected actual API-doc gate passed both build/check passes in
112.2 and 14.6 seconds (587.339 seconds overall, including setup
and full output fingerprinting). It covers 35 supported pages, 647 declarations,
92 canonical exports and 23 non-stable exclusions, with zero equation rows.
All five actual Pinsker declaration blocks were inspected: exact constants and
support guards, the MI forms' independent universes and finite-only public
premises, docstrings, ownership, empty attribute lists and correct file source
links. The v2 configuration verifies all 83 maintained source inputs and 14
locked dependencies. Its source-content identity is
`47b6b7f5fa02bbda16f106f5df268b72038a2ed61e8c3a63a2a815182359d1a4`.
The relevant output digest is
`1b391db6a3eaf9c12a31c68d6328b355ec4631a7886f59d0ca858beb64ddecef`;
the maintained gate recorded the full-tree digest
`2a422e0bde8171fc4b007d51478178a4575eb7aa50e2e95d95eb3894bd701221`.
The latter is attributed to that gate, not a second full-tree hash by the
declaration inspection. Both output digests are retained in the v2 attestation.

Original successful command/streams are in
`.lit-review/setup/c13-04-api-docs-recovered-20261003/`; concrete HTML and
source/configuration observations are in
`.lit-review/setup/c13-04-api-doc-inspection-20261003.json`.
The original failed run remains at `.lit-review/setup/c13-04-api-docs-20261003/`:
pass 1 compiled the new docInfo but reused the aggregate HTML marker, omitting
Pinsker.html. The repair preserved and invalidated exactly that ignored marker
and its hash/trace sidecars; all source, extracted docInfo and compiled caches
were retained. Its record is `c13-04-doc-marker-recovery-20261003.json` in the
same private setup directory. No dependency or tooling source was changed.

The seven-target focused build passed in 59.461 seconds using
`lake --wfail`. The documentation command passed in 122.829 seconds,
including five README and four website-guide examples compiled independently
with warnings as errors. During these two checks, only recorded status prose
changed; the compiled inputs and example sources were unchanged. Final static
checks repeat the release-documentation contract on the completed prose.
These checks reuse incremental caches. The full clean routine suite and fresh
cumulative review remain pending until the separately authorized checkpoint.

Three C13-owned policy/generated files were normalized from CRLF to the existing
LF convention before the successful API-doc run, so prospective committed bytes
can match the working source. This changed no JSON policy or HTML content.
The actual source/ownership audit verifies all Lean files byte-identical to
completed Step 3 and the plan's normative regions unchanged.

### Authorized initial checkpoint and clean qualification

The lead explicitly authorized the exact 25-file local checkpoint, a separate
clean validation checkout and necessary C13.04-only amendments. Initial
checkpoint `17fb736a00448ecdd0aa824fd1928713bf716f01` passed the complete
maintained routine suite in 1975.056 seconds. The checkpoint result is
`.lit-review/setup/c13-04-checkpoint-result-20261003.json`.
All 25 checkpointed files match between the primary and clean checkouts
byte-for-byte.

The actual command was `python -B scripts/validate_release.py` in
`C:\Users\coban\Desktop\LeanInfoTheory-C12-validation-20261003`.
Original command, streams and exact before/after input hashes are retained in
`.lit-review/setup/c13-04-full-checkpoint-20261003/`; explicit cross-checkout
and primary API-doc applicability is in
`.lit-review/setup/c13-04-checkpoint-applicability-20261003.json`.
The suite passed default and eight-target strict builds, five README and four
website examples, 601 retained signatures, 35 supported import closures,
647 public declarations, 94 reviewed simp declarations, 92 root exports,
the 1,906 local-constant axiom audit, generated artifacts, website checks and
clean final hygiene. Only `propext`, `Classical.choice` and `Quot.sound` were
reported. Ordinary incremental caches were reused.

The API-doc result above remains bound to the primary checkout's 83 raw source
inputs and its file-source paths, including the recorded v2 configuration and
both output digests. In the clean checkout, `docs/v0.1-public-api.json` differs
from the primary copy only by uniform CRLF-to-LF conversion. An older
`docs/plans/post-release-chunk-09-notes.md` also has an unrelated EOL-only
difference. Neither is a C13 edit; the old notes are outside the API input set.
The frozen-manifest verifier accepts precisely these two encodings.
Thus this is not a claim that the primary file-mode attestation has the clean
checkout's raw-byte or path identity. Exact final API-doc applicability is
established in the source-bound records.

The unrelated `docs/next-website-tasks.md` was excluded from the checkpoint
and remains untouched in the primary checkout; the clean checkout retains its
committed baseline. The initial full pass does not qualify a later amended
candidate. Final amended-candidate routine validation, cumulative review,
original-report reconciliation, exact source applicability and closure remain
governed by the C13.04 records. No push, publication or C14 work is included.

This entry supersedes the preparation section's pending checkpoint authority
and initial-routine status; that section remains the history of preparation.
