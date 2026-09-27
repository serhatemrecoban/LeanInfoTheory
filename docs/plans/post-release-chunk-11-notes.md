# Chunk 11 implementation notes

These advisory notes accompany the [approved C11 plan](post-release-chunk-11.md).
They preserve implementation choices and evidence boundaries. They do not replace
the approved contracts, independent review or private completion records.

## C11.01: coupling interface and elementary witnesses, 2026-09-26

### Authority and baseline

The lead accepted revision 2, encouraged justified adaptations, and explicitly
requested step 1 with its review process. Only C11.01 is selected. No commit,
push, publication or later step is authorized. C10 is complete at intake HEAD
`37b4ba90d1ab321645f80cacef475f10a3a6ba43`; its private completion record and
maintained handoff remain prior evidence. The C11 plan was the only unignored
change at entry, and its approved status was recorded before the step baseline.

### Implementation choices

- `Probability.Coupling` defines the joint-first `PMF.IsCoupling` predicate and
  the four approved elementary theorems. It directly imports `FiniteChannel`
  and `TotalVariation`, as approved for the complete coupling owner. No Shannon
  or semantic import is introduced.
- Independent existence reuses constant `channelJoint`. Diagonal and swap proofs
  use existing `PMF.map_comp` and `PMF.map_id`; they introduce no local probability
  representation, finiteness assumption, inhabitant or measurable-space instance.
- A fresh scoped search of project and pinned mathlib probability/measure source
  found no existing PMF coupling interface to reuse. The predicate and witness
  orientation match LP17 Section 4.2 and SA13 Section I, already inspected during
  planning. The same-name search and source contracts were rechecked for this step.
- `Examples.Coupling` imports only the focused owner. Its private examples use
  all five declarations and both ordered marginals, with generic independent
  universes, `Nat`/`Bool` heterogeneous existence, diagonal coupling, swap and
  double swap, and empty-alphabet impossibility from `PMF.support_nonempty`.
- The current growth policy adds one new-owner approval and updates the existing
  Shannon umbrella approval while preserving its C10 provenance. The lightweight
  root, retained declarations and imports, simp set and facade aliases are fixed.
- Generated source references record 633 documented supported declarations in
  33 owners, 94 reviewed simp declarations and 92 facade aliases. The module graph
  has 51 modules, 106 local edges and the same five-module root closure.

### Validation and completion boundary

C11.01 requires the five-target warning-as-error focused build (owner, minimal
consumer, full Shannon umbrella, Examples aggregate and root), current generation
and static checks, fresh standalone compiled compatibility, and source/API review.
Exact commands, original outcomes and source applicability are retained under
`.lit-review/setup/c11-01-*` and the bound execution session. Earlier failures,
if any, remain separate from corrected successful runs.

Source and canonical context are prepared for validation and independent review.
The original bound review, explicit reconciliation, final applicable evidence and
exact C11.01 private completion record establish step closure. These notes make
no claim that a future review or closure has already happened.

The clean routine suite and real two-pass API-documentation milestone belong to
C11.06. The current source-generated index does not imply that new signature-bearing
HTML has been built or published. C11.02--C11.06 remain unselected; the coupling
inequality, maximal witness and Fano consumer are not implemented in this step.

## C11.02: coupling inequality, 2026-09-26

### Authority and predecessor

The lead requested step 2 with review conditional on successful step 1 closure.
The actual C11.01 completion record, its reconciled original review, all three
satisfied criteria and exact final-source applicability were checked before the
request selected C11.02. The working tree preserves that uncommitted predecessor;
HEAD remains `37b4ba90d1ab321645f80cacef475f10a3a6ba43`.

### Proof and consumer choices

- The sole public addition is `PMF.IsCoupling.totalVariation_le`, with the
  approved common-alphabet `[Fintype alpha]` contract, coefficient one and
  ordered event `xy.1 ≠ xy.2`. No support, positivity, cardinality or
  measurable-space hypothesis is added.
- The proof follows the event argument in LP17 Section 4.2, Proposition 4.7.
  C10's attaining-event identity reduces TV to a signed marginal discrepancy.
  The two marginal maps transport the event to the joint law; finite indicator
  sums then give the pointwise bound by the disagreement indicator.
- The event bound is local to the proof. It needs no new public or private
  declaration, diagonal-mass formula, complement formula or normalization.
  `PMF.toOuterMeasure_toReal_eq_sum` already proves the required finite-mass
  guards using `PMF.apply_ne_top`. No unchecked `ENNReal.toReal` subtraction or
  cancellation is introduced.
- Private consumers check an arbitrary coupling in both coordinate orders,
  diagonal equality, arbitrary subsingleton couplings, the distance-one lower
  bound for any disjoint-support coupling, distinct pure Boolean endpoints and
  asymmetric pure/fair laws. Two independent fair Boolean variables have
  disagreement `1/2`, while their TV and diagonal disagreement are zero;
  the comparison includes an explicit strict inequality.
- The fair law uses `PMF.ofFintype`; no deprecated Bernoulli API or semantic
  import is needed. The generic disjoint consumer uses `[Finite alpha]` and
  introduces enumeration only inside its proof.
- The first focused invocation exited zero but emitted two linter warnings.
  It is retained as an insufficient warning-free check. Removing an unnecessary
  final tactic and weakening the private disjoint consumer's enumeration premise
  addressed them without suppressing linters or changing validation tooling.
  The next invocation exposed a local-instance style warning; using `let`
  instead of `letI` resolved it. Both original outputs remain preserved, and
  direct warning-as-error compilation checks the corrected source.

### Validation and completion boundary

C11.02 requires fresh focused owner/consumer/aggregate builds, current generation
and static checks, and exact axiom evidence for the new theorem. Direct owner
and consumer compilations also use `-DwarningAsError=true`; source inspection
checks imports, assumptions and finite-event conversion guards. The current API
has 634 documented declarations in 33 owners, with the same 94 simp declarations,
92 root aliases and five-module root closure. No import/attribute policy changes
are made, so C11.01's compiled compatibility remains prior evidence for those
unchanged boundaries; it does not certify the new theorem or current types.

Original command outputs, independent review and source applicability belong in
the private C11.02 records. This entry records source readiness only; exact step
completion requires the original review, reconciliation and final private closure.
C11.03 and later steps remain unselected. The clean cumulative suite, all-project
trust and real two-pass API documentation remain C11.06 duties.


## C11.03: common-mass constructor and marginals, 2026-09-26

### Authority and scope

The conditional request for step 3 was selected only after checking C11.02's
actual completion record, both satisfied criteria, reconciled original report,
absence of open findings, and exact final-source applicability. The uncommitted
C11.01--C11.02 work is preserved. This step adds `PMF.maximalCoupling` and
`PMF.isCoupling_maximalCoupling`; exact disagreement and maximality are C11.04.

### Construction and endpoint checks

The implementation uses the preferred two-case definition from Section 3.3.
At zero TV it selects the diagonal map. At positive TV it uses `PMF.ofFintype`
on the common diagonal mass plus the product of the two truncated residuals
divided by `ENNReal.ofReal (totalVariation p q)`. Separate private row and column
identities establish both marginals and unit total mass. The row calculation
uses TV symmetry to obtain the reverse residual total. Cancellation requires
only positive TV and the finiteness of `ofReal`; no TV<1 assumption, normalized
overlap PMF or fallback inhabitant is needed.

Private generic endpoint proofs identify the actual selected constructor with
the diagonal law at TV=0 and the independent `channelJoint` at TV=1. In the latter
case C10's zero overlap sum makes every common atom zero; `tsub_min` then
identifies both residuals with the original laws. The denominator is one.
Private sparse ternary checks compute the common middle diagonal atom and the
first-to-last residual atom as one half each. These inspect the construction
inside its owner, while the focused example module uses only the public producer
and marginal theorem. Its consumers cover generic and swapped marginals, equal
and disjoint laws, distinct pure laws, sparse interior and asymmetric Boolean
laws, arbitrary subsingletons, and the impossibility of empty-alphabet inputs.

The selected formula is the flattened mixture in SA13 Section I, equations
(5)--(8), reread locally for this step. Existing C10 residual/overlap identities
and the planning feasibility probe supplied the normalization route. The direct
matrix avoids introducing normalized residual PMFs into production.

The initial direct compilation checked the generic normalization and marginal
proofs but found errors in the private independent-law and sparse-atom checks.
The fixes expose pair coordinates to `channelJoint_apply` and select the positive
branch before unfolding the concrete sparse PMFs. Original failure output is
retained in the private records; no linter or theorem contract was weakened.
Further sparse-check attempts made the finite index inequalities, conversion of
the real half to ENNReal, and guarded cancellation of the nonzero finite half
explicit. Their original outputs are retained too.

### Pinned cancellation evidence and validation boundary

`ENNReal.mul_inv_cancel_right` and `ENNReal.mul_div_cancel_right` are defined in pinned mathlib
`Mathlib/Data/ENNReal/Inv.lean`, explicitly imported by the session-scoped
`BigOperators.lean`. The execution contract's additional file list is immutable
and does not separately list `Inv.lean`. Its checkout SHA-256 is
`f88286bd4a1367d8076f6828a3ca88e0309cf0cad3d8fce60532fbba0617b03e`;
its pinned Git blob SHA-256 is
`bbc0988d1a084ec35346dc7ab70b455efe86a833c84c499ec5e4dc0b07550d72`.
A direct check established the same text, clean Git status and the configured
mathlib commit `0df444a360eaa60ab8c11dca51a86af692955474`. The checkout uses
CRLF and the blob LF, explaining the initial raw-byte comparison failure.
This explicit evidence supplements the session's captured dependency identity;
no workflow contract, scope field, dependency or acceptance policy was changed.
The private evidence record retains both hashes and the actual Git EOL result.

Required validation is the focused owner/consumer/umbrella build, generated/static
checks, direct warning-as-error compilation, exact constructor/theorem axiom
evidence, and review of the atom, marginal and denominator proofs. Source and
context updates record readiness only. Consult the private C11.03 records for
actual check outcomes, independent review, reconciliation and exact completion.
C11.04 and later steps remain unselected; cumulative clean-tree, compatibility,
all-project trust and real two-pass API documentation remain C11.06 duties.

## C11.04: exact disagreement and attainment, 2026-09-26

### Authority and proof route

The conditional step-4 request was selected after verifying C11.03's actual
closure, all three satisfied criteria, reconciled independent report and exact
final-source applicability. C11.01--C11.03 and their uncommitted source remain
intact. Only C11.04 is selected; Fano interoperability and cumulative closeout
remain later steps.

The source adds the two approved disagreement theorems, first in ENNReal and
then in Real. In the positive branch, one of the two truncated residuals vanishes
at each diagonal atom. The diagonal mass therefore equals the common minimum.
A private finite diagonal sum gives agreement `ofReal (1-TV)`. Another private
finite-indicator partition proves disagreement plus agreement is one; subtraction
uses `ENNReal.eq_sub_of_add_eq'` with the explicit finite total `one_ne_top`.
The final complement calculation uses `ENNReal.ofReal_sub` with `0 <= 1-TV`,
supplied by `totalVariation_le_one`. Only after the ENNReal equality is established
does the Real corollary use `ENNReal.toReal_ofReal` and TV nonnegativity.

The public proof treats both endpoints explicitly. At TV=0 it rewrites the
actual constructor to its diagonal law and transports the disagreement event
through that map. At TV=1 it rewrites to the actual independent law, uses C10's
disjoint-support characterization, and shows every supported pair disagrees.
The positive-case proof itself still works at TV=1; the separate endpoint proof
records the required independent-support argument without changing the producer.
No public positivity, support, cardinality or inhabitance assumption is added.

The first direct compilation found one local equality-transport error in the
independent endpoint proof. Exposing the pair projection equality as `a = b`
before transporting support membership fixes that proof without changing its
statement. The original compiler log and failure record are preserved. Printing
the Unicode diagnostic through the terminal's default encoding also failed;
subsequent check runners explicitly use Python UTF-8 mode.
The first focused build then compiled all targets but reported an unused
`Fintype`-in-type linter warning on the private complement helper. Its statement
now uses `Finite` and introduces enumeration only inside the proof. That earlier
exit-zero build is retained as an insufficient warning-free check; no linter
was disabled.
Fresh direct owner and consumer compilations subsequently passed. The private
axiom probe's global universe display option printed universe suffixes on the
three allowed axiom names, which its exact-name parser rejected. Scoping that
display option to the signature checks corrects the probe format; the original
failure is preserved. The two successful direct elaborations remain applicable
to unchanged Lean source, while the corrected axiom probe is run freshly.

SA13 Section I, Theorems 1--2, and LP17 Section 4.2, Proposition 4.7 and its
construction, were reread locally. Their half-L1 convention, common-mass
agreement and attaining witness agree with this flattened construction.
The normalized-component presentation leaves zero denominators informal;
the existing explicit constructor branches and generic endpoint identities
remain the formal treatment. No external formalization was consulted.

### Consumer and validation boundary

The focused private consumer combines the actual witness's two marginals and
exact ENNReal event value with the universal inequality for every competing
coupling. The edge examples consume the public exact-event theorems for equal,
disjoint, distinct pure, sparse ternary and asymmetric Boolean laws, including
reversed input order. Existing strict fair-independent, subsingleton, empty-type
and heterogeneous cases remain. Constructor-specific endpoint identities and
the two sparse atom checks remain private in the probability owner.
An additional quarter-versus-fair Boolean example checks strictly interior atom
masses, TV one quarter, both ordered marginals and exact disagreement in both
input orders. This makes the interior-parameter row explicit alongside the
existing pure-versus-fair and sparse examples.

The two new public theorems bring source coverage to 638 documented
supported declarations in 33 owners; 94 simp declarations, 92 facade aliases,
imports and policies remain unchanged. Required validation includes focused
owner/consumer/aggregate builds, generation/static checks, direct warning-as-error
compilation and exact signature/axiom probes. The full `trust` gate also performs
fresh compiled compatibility and the all-project axiom audit; it satisfies both
step-4 duties without duplicating the standalone compatibility run.

Actual validation results, original independent review, reconciliation and exact
closure belong to the private C11.04 records. This entry records source readiness
only. The clean committed-tree suite and real two-pass API documentation remain
C11.06 duties; no commit, push, publication or later step is authorized here.

## C11.05: Fano and product interoperability, 2026-09-26

### Authority and consumer design

The conditional step-5 request was selected after verifying C11.04's actual
completion record, all three satisfied criteria, original review reconciliation
and exact final source. C11.01--C11.04 and their uncommitted source are preserved.
Only C11.05 is selected; cumulative qualification and the maintained handoff
remain C11.06 work.

`Examples.CouplingFano` has exactly the three approved direct imports:
`Probability.Coupling`, `Shannon.Fano` and `Shannon.SemanticBridge.Product`.
Its twelve private theorems consume existing public interfaces. The independent
constant-channel law is definitionally `Shannon.indepProd`; this identity lets
the consumer reuse both the complete product-measure theorem and its measurable
rectangle theorem. These generic results retain different coordinate types and
universes. Only the measure consumers require coordinate measurable spaces;
the rectangle theorem additionally requires the two measurable sets. No finite,
nonempty or measurable-singleton premise is added to those results.

For the actual maximal witness, the semantic marginal abbreviations accept the
two coupling equalities directly. `IsCoupling.map_swap` supplies the reversed
marginals of that same witness. A generic ENNReal event-preimage proof transports
disagreement through the coordinate swap. A separate finite-sum identity
reconciles identity decoding's `second != first` event with the coupling API's
`first != second` event. Both actual ENNReal event masses are `ofReal TV`, and
both identity-decoder errors are the same `totalVariation p q`.

The expanded existing `condEntropy_fano` theorem is applied to the actual
`maximalCoupling p q` and its `map Prod.swap`, giving the two conditional-entropy
bounds in nats. The logarithm retains natural-number subtraction before the
cast. Equal-law specialization gives zero error and, using conditional-entropy
nonnegativity, zero conditional entropy in both orientations. The subsingleton
case first makes the disagreement event empty, obtains TV zero and equality of
the supplied laws, then reuses the equal-law result. No global inhabitant,
cardinality lower bound or equality with `maximalCoupling q p` is needed.

CT91 Section 2.11, Theorem 2.11.1 and equation (2.144), and PW22 Section 6.3,
Theorem 6.3 and equation (6.8), were reread locally with registered hashes
verified. They support the source/observation orientation of the existing Fano
API. CT91's bits are converted by the existing canonical-nats convention;
PW22's randomized-estimator extension is outside this deterministic consumer.
Their informal singleton logarithmic conventions are handled by the existing
Lean theorem, which already includes singleton alphabets. PW22 numbering is
not attributed to PW24.

### API and validation boundary

All ten public coupling declarations have maintained producer/consumer uses in
the two example owners. The event-conversion helpers are small private proofs;
their use supplies no evidence for a public bridge, alias, instance or simp
attribute. Fano, Product, the probability owner and both mathematical umbrellas
retain their earlier source and contracts. No actionable repeated naming
friction was found, so Note 14 and the feedback register need no speculative
entry. Current supported coverage remains 638 declarations in 33 owners, with
94 reviewed simp declarations and 92 aliases.

Required checks are focused owner/consumer/dependency/aggregate compilation,
current generation/static checks, documentation and full trust, including its
fresh compatibility run. An exact signature/axiom audit of the ten public
coupling declarations provides focused evidence. Initial direct elaboration
passed, but the project build exposed an unused-`Fintype` warning in the private
decoder-event bridge. Its statement now uses `Finite`, with enumeration confined
to the proof; final project compilation checks that correction. The additional
pinned `Inv.lean` dependency of the unchanged
constructor was freshly compared with its recorded hash and clean mathlib pin;
it remains separately disclosed, without changing the immutable capture scope.

This entry records source readiness. Actual validation, original independent
review, reconciliation and completion are established by the source-bound
C11.05 private records. The clean committed-tree suite and two-pass API-doc
milestone remain C11.06 duties. No commit, push, publication or later step is
authorized here.

## C11.06: cumulative candidate and maintained handoff, 2026-09-27

The actual C11.05 closure and exact final source were verified before consuming
the conditional step-6 request. All five earlier steps have accepted original
reviews, explicit reconciliation and satisfied criteria. Their certificates are
preserved; they are inputs to a fresh cumulative assessment, not substitutes for it.

This step preserves the complete mathematical candidate and reconciles current
documentation with it. The maintained `docs/handoffs/chunk-11.md` identifies all
ten public names, their assumptions/imports, permanent private consumers, the
constructor/consumer testing split, source adaptations and C12/C14 prerequisites.
The README's old 628/32 count and C11-planning status are updated to the actual
638/33 candidate. C10 API-doc results remain historical evidence; current C11
qualification must produce its own applicable two-pass attestation.

The source still uses the common diagonal plus independent residual matrix at
positive TV and a diagonal law at zero TV. Constructor endpoint equalities and
sparse joint atoms remain private. Existing public contracts and consumers need
no mathematical or API change for closeout. General transport/gluing, continuity,
public Fano bridges and maximality abstractions retain the handoff's owners and
proof-pressure triggers; no speculative alias or helper is added.

The approved Section 5 checkpoint boundary and original user instruction require
separate commit authorization. Prepare all source/document changes, inspect the
complete scoped diff, run available preparation checks and record contextual
self-review before requesting it. The complete clean suite, real two-pass API
docs, fresh all-criterion review, reconciliation and final private closure remain
required. Earlier warnings and failures stay in their original evidence records;
in particular, C11.05's source audit explicitly maps its renamed initial logs.
No clean gate, API-doc result or cumulative review is inferred from prior steps.

### Authorized checkpoint and initial cumulative gates, 2026-09-27

The lead approved the exact 24-file local checkpoint and necessary C11.06-only
amendments. Initial checkpoint `2147dd3449af620f41d9bed8d37c5be8252f20e8`
was clean and preserved the reviewed mathematical source and current API.
`.lit-review/setup/c11-06-full-checkpoint-20260927/result.json` records the clean complete routine suite (exit 0,
`1983.359` seconds); `.lit-review/setup/c11-06-api-docs-recovered-20260927/result.json` records both real checked file-mode
API-doc passes (`234.8s and 19.9s`). `.lit-review/setup/c11-06-api-doc-inspection-utf8-20260927.json` records the actual new owner,
all ten public declarations and the v2 source/configuration attestation.
The maintained C11 handoff preserves the observed coverage and original evidence.

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

The current-document amendment records completed initial checks. Complete routine
validation must be repeated on the amended clean candidate, and exact API-doc
applicability must be established. The fresh all-17-criterion original report,
explicit reconciliation, final validation/review applicability, final capture and
closure are established by C11.06's source-bound private records. This entry
neither predicts their identities nor certifies completion. No later chunk, push
or publication is included.
