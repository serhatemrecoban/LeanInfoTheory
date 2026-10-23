# Chunk 21: Complete finite-iid almost-lossless source coding

<!-- lit-review-status:start -->
**Status:** Approved revision 2, 2026-10-23; C21.01--C21.04 complete with review,
only C21.05 selected with review. The actual C21 parent retains its persistent
reviewer; requested settings were `gpt-6-astra` / `ultra` / no copied parent
history, while effective settings remain unobserved. No formal revision-2 PLAN
review is claimed.

Actual Step 4 closure `e22cd90cec76a7b22aa4bd3f92fbdfdeb39a3a86ec1834a01aa2f835a4538e57` and exact final-source/environment
applicability were verified before Step 5 admission. Its original report,
four satisfied criteria and reconciliation are retained in the actual private
completion chain. Authority/admission: `.lit-review/setup/c21-05-session-input-20261023.json` and `c21-05-admission-result-20261023.json`.

All four mathematical endpoints and permanent consumers are delivered.
The separately authorized initial checkpoint `463021c1493dd2b28e0730dc64fbace3fd29a67a` passed the complete maintained clean routine. Both actual local API build/check passes and the parent inspection of all four new elaborated declarations passed on their recorded inputs. That initial candidate is validation-ready. Final candidate qualification, readiness, cumulative acceptance and closure are established only by `.lit-review/setup/c21-05-completion-20261023.json` and its linked actual current-candidate validation/API applicability, genuine original independent report, complete seventeen-criterion matrix, substantive parent reconciliation and final-source qualification. This wording asserts no future PASS or closure. Every amended checkpoint, including the evidence updates here, requires the complete clean rerun and renewed API applicability before qualification; these initial results do not qualify later writes automatically. The final checkpoint identity belongs in that actual evidence chain, not in a prediction of a commit containing this text.
Step 5 maintains the [C21 handoff](../handoffs/chunk-21.md) and
reconciled canonical context without adding a mathematical endpoint. Current
evidence and remaining-work dispositions belong in notes section 13 and the
actual private records. Final qualification and closure retain the conditional
completion-record meaning above; no push/publication or later-chunk execution
is inferred. All normative
bytes outside this status region are retained.

<!-- lit-review-status:end -->

## 1. Authority and scope

Complete finite-iid, fixed-length, asymptotically almost-lossless source coding:
one actual code sequence achieving every rate strictly above entropy, the
error-to-one strong source converse below entropy, the general eventual rate
lower bound for every vanishing-error sequence, and a complete operational
entropy-threshold theorem using that same code model and nats.

Work in `C:\Users\coban\Desktop\Lean Info Theory`. This proposal authorizes
no production implementation. The lead must approve the exact plan and then
explicitly select one step with its required review process. Finish only that
step and stop. An explicit plan-review request uses the installed workflow
and the existing C21 reviewer; it does not approve execution.

No commit, push, publication, tag, release, dependency change or later chunk
is authorized. The clean-checkpoint and local API-documentation milestones
below retain their separate authorization requirements. Preserve unrelated
working changes, including `.gitignore`, `AGENTS.md`,
`docs/next-website-tasks.md` and pre-existing `docs/project-log.md` content.
Do not normalize them or manufacture a clean tree. No new folder directly on
the Desktop, unrelated project edits or external formalization reuse.

Excluded: a universal exact-fixed-rate `R = entropy p` theorem, error
exponents, second-order/normal approximation, optimal-code classification,
variable-length/prefix/Huffman/Kraft coding, an executable compression
algorithm, infinite-alphabet or non-iid sources, channel achievability and
an information-spectrum or general coding framework. The agreed second
release remains after C24; channel achievability is at most a possible
third-release direction, requiring its own decision.

Outside the marked status region this is the proposed contract. Baseline
facts in section 2 describe intake, not future qualification. Proof recipes
and evolving advice belong in the notes. Alternative proof organization is
allowed when every required checkpoint, hypothesis and witness contract is
preserved. Changes to meaning, required scope, important public contracts,
acceptance policy or pins require the lead.

## 2. Verified inputs and source interpretation

C20 completion is established by
`.lit-review/setup/c20-05-completion-20261023.json`, linked closure
`465e6291b7afdd93340e1d0f75a76f53c01310ef00c8207fc98b48034f6ca537`, and its
actual review/reconciliation/final-validation/source chain. Fresh planning
intake checks at `dee3cc9848389d27d41b21ecc6e39f3c4761ea97` confirmed
closure and source applicability before C21 document creation. The exact
inventory, assessments and validation correspondence remain in
[notes section 2](post-release-chunk-21-notes.md#2-c20-closure-and-present-applicability).
This is applicability checking, not a fresh full build or mathematical
review. Historical reviewer-context exposure, unknown effective settings,
failures and warm/incremental validation limits remain disclosed there.

The current baseline is 745 supported declarations in 49 owners, 92 root
exports and 94 reviewed simp names. These are inventory facts, not quotas.
Lean/mathlib remain v4.33.1; mathlib is pinned to
`0df444a360eaa60ab8c11dca51a86af692955474`. All nine root dependencies were
clean at their configured revisions during inspection. The maintained
[C19 handoff](../handoffs/chunk-19.md), [C20 handoff](../handoffs/chunk-20.md)
and [map](post-release-chunk-map.md#c21-complete-finite-iid-source-coding)
supply the cross-chunk contracts.

### 2.1 Public reuse obligations

Paths below are relative to `LeanInfoTheory/`; names were inspected in source.

| Owner | Required reuse |
| --- | --- |
| `Shannon.SourceCoding` | `BlockSourceCode`, `SourceCode.encoder`, `decoder`, `errorProbability`; `exists_sourceCode_errorProbability_le` for one witness with recovery and the error bound; `successProbability_le` and `successProbability_eq_one_sub_errorProbability` for arbitrary-code success. Do not rebuild finite coding/counting theory. |
| `Shannon.CodingRate` | `codeRate`, `codeRate_nonneg`, `codeRate_zero`, `codeRate_one`, `codeRate_le_iff`, `roundedMessageSize_bounds`, `codeRate_roundedMessageSize_bounds`; retain integer ceilings and their positive-length/nonnegative-target guards. |
| `Shannon.Fano` | Exact existing failure-event semantics and `decodingErrorProbabilityOf_nonneg` / `decodingErrorProbabilityOf_le_one`. No competing error definition or unnecessary finite-Fano proof. |
| `Shannon.TypicalSet` | The same `weakTypicalSet`, `mem_weakTypicalSet`, `weakTypicalSet_mass_bounds`, `card_weakTypicalSet_le`; retain support, strict width and the empty zero-length convention. The probability-weighted lower cardinality bound remains available but is not needed to reprove the success-set converse. |
| `Shannon.SemanticBridge.AEP` | `tendsto_prob_weakTypicalSet`; derive complement convergence locally with the pinned finite probability complement identity. Do not repeat the AEP/variance proof. |
| `Probability.Iid` | Existing `PMF.iid p n` on `Fin n → A`; no new block, product law or probability construction. |
| `Shannon.Units` | Canonical nats; any explanatory bits conversion uses `natsToBits` and existing fixed-binary-budget identities. No parallel bit-valued theory. |
| `Shannon.EntropyBounds` / `Shannon.Entropy` (private consumers) | Use `entropy_le_log_support_ncard` and `entropy_eq_log_support_ncard_iff_eq_uniformOnSupport` for strict compression below the support-size rate of a nonuniform sparse law; `entropy_eq_zero_iff` and entropy nonnegativity establish positivity. No numerical logarithm estimates or new entropy endpoint. |
| Pinned mathlib | Reuse natural-cast divergence, constant-over-natural limits, exponential decay, eventual filter operations, squeeze and order-theoretic `IsGLB`. Source-search and isolated compilation evidence are distinguished in the notes. |

`Examples.SourceCodingTypicalSet` is evidence that public C19/C20 interfaces
already compose: its private `rounded_typical_family` chooses one dependent
family, and its private finite/rate converses retain the exact event model.
Never import this private example into production or refer to its private
declarations. Reconstruct only the small required composition from public
producers in the new owner. Keep composition helpers private. Promotion
requires actual additional production/consumer pressure, a discovery search,
and an ownership/API justification; repetition in examples is insufficient.

### 2.2 Exact registered references and adaptations

Use [the reference register](../references.md), particularly PW24 (August 16,
2024 draft), not PW22 or the later published edition. Both local hashes were
freshly checked; selected mathematical pages were text-read and visually
checked as recorded in the notes. Do not include textbook extracts/media in
tracked documentation.

| Source passage | C21 use and boundary |
| --- | --- |
| PW24 section 11.1, printed 212--217 / PDF 237--242; Definition 11.1, Theorem 11.2, Remark 11.1 | Fixed-length model with detectable erasure versus undetected error. C20's total-decoder adaptation replaces erasures by a source value, preserving previous successes. All M indices remain available; no reserved erasure index or optimal-erasure-tail equality is imported. |
| PW24 Corollary 11.3 and Theorem 11.4, printed 214--215 / PDF 239--240 | Above/below-entropy coding threshold and success-set splitting. Use actual natural budgets in nats, not informal nonintegral binary lengths. Normal approximations and optimal-code machinery are excluded. |
| PW24 section 11.2, Proposition 11.6 and coding discussion, printed 217--218 / PDF 242--243 | Typicality-to-coding route. Preserve C19's strict supported set; the book's closed definition/strict proof discrepancy is not silently transferred. The exponentially decaying summand below does not establish an exponential rate for the whole error bound. |
| CT91 section 3.1, Theorems 3.1.1--3.1.2, printed 51--53 / PDF 73--75 | AEP, atom and cardinality context, converted from bits to nats through existing conventions. |
| CT91 section 3.2, Theorem 3.2.1, printed 53--55 / PDF 75--77 | Variable-length expected-description-length construction, using different typical/atypical lengths. It is not the fixed-length almost-lossless endpoint. |
| CT91 section 3.3, Theorem 3.3.1, printed 55--56 / PDF 77--78 | High-probability-set size lower bounds motivate the general converse. C21 proves the stated sequence contract directly from C20's pointwise bound; no unproved optimal-set assertion is assumed. |

## 3. Common mathematical model and limit conventions

All primary theorems have `{A : Type u} [Fintype A] (p : PMF A)`.
Entropy already uses a finite sum. No additional `Nonempty`, `DecidableEq`,
measurable-space, full-support, positive-entropy or alphabet-size premise is
permitted. A supplied law supplies any needed nonempty fallback internally.

Use exactly the unbundled family:

~~~text
M : Nat → Nat
hM : ∀ n, 1 ≤ M n
c : ∀ n, BlockSourceCode A n (M n)
e n := (c n).errorProbability (PMF.iid p n)
r n := codeRate n (M n)
H := entropy p
~~~

Here e, r, H and other abbreviations in this plan are exposition only, not
new public definitions. The encoder and decoder are total deterministic
maps; no ambient encoder injectivity or exact recovery outside a selected
set is imposed. Each length has its own finite iid law. Limits are limits
of real numbers along `Filter.atTop` on natural lengths.

Use `Filter.Tendsto ... Filter.atTop (nhds ...)` and eventual inequalities.
The asymptotic upper-rate assertion at R means
`∀ η : Real, 0 < η → ∀ᶠ n in atTop, r n ≤ R + η`.
This condition is meaningful for arbitrary sequences, including oscillating
or unbounded ones, and expresses the extended-real limsup bound. Do not
use unguarded conditionally complete Real liminf/limsup. No EReal wrapper
theorem is required: it may be considered only after concrete consumer
pressure and a fully guarded equivalence proof.

### 3.1 Same-witness achievability and rounding

For every real R with `H < R`, deliver

~~~text
∃ M : Nat → Nat, (∀ n, 1 ≤ M n) ∧
  ∃ c : ∀ n, BlockSourceCode A n (M n),
    Tendsto (fun n => e n) atTop (nhds 0) ∧
    (∀ᶠ n in atTop, r n ≤ R)
~~~

The same M and c must satisfy both conclusions. This eventual upper bound
is stronger than the roadmap's asymptotic upper bound by R; include a
consumer deriving the tolerance formulation in section 3.

The retained internal construction fixes `H < ρ < R`, sets `ε := ρ - H > 0`
and `M n := roundedMessageSize n ρ`, and selects one dependent code family
from C20. It retains recovery on `weakTypicalSet p n ε` and the complement
error bound for the very same witnesses at every n. Prove `ρ ≥ 0` from
entropy nonnegativity. The exact integer budget satisfies

~~~text
1 ≤ M n,  exp(n*ρ) ≤ (M n : Real) < exp(n*ρ) + 1;
0 < n → ρ ≤ r n ≤ ρ + log 2 / n.
~~~

Prove `log 2 / n → 0`, `r n → ρ` and the eventual bound at R for this
family, together with its actual error tending to zero. Retain the rounded
budget identity, recovery, complement error bound, rate limit and `M 0 = 1`
in a connected private construction lemma/checkpoint in the production owner.
The public theorem uses this same family and exposes only its stated
conclusions. Check the hidden construction properties there; an external
consumer cannot infer them from the weaker public existential. Particular
limit arguments are advice in the notes, not an additional proof-method
requirement. Do not exchange witnesses between these arguments.

### 3.2 Pointwise bound and strong source converse

For every natural n, budget M, width ε and actual code c, retain the
specialization of the public arbitrary-law bound:

~~~text
1 - e_n(c) ≤ P_n(T(n,ε)ᶜ) + (M : Real)*exp(-(n : Real)*(H-ε)),
T(n,ε) := weakTypicalSet p n ε.
~~~

For `0 < n`, `1 ≤ M` and arbitrary real R with `codeRate n M ≤ R`, derive

~~~text
1 - e_n(c) ≤ P_n(T(n,ε)ᶜ) + exp(-(n : Real)*(H-ε-R)).
~~~

This remains a pointwise implication in the rate premise. It must remain
available internally to both converses, even when the family has no
eventual upper-rate bound. The finite specialization allows every real
width; probability convergence subsequently requires ε positive.

Public strong converse: for every M, hM and c in section 3, every real
`R < H`, and `∀ᶠ n in atTop, r n ≤ R`, prove `e n → 1`.
The connected proof must establish positive-gap decay, complement
convergence and the resulting success/error limit through the pointwise
bound and exact complementarity. Specific choices of width and limit
lemmas are proof advice in the notes.
Do not assume rate convergence, global rate bounds or R nonnegative.

### 3.3 General converse, including intermittent low rates

For every M, hM and c in section 3, assume only `e n → 0`. For every real
`δ > 0`, prove

~~~text
∀ᶠ n in atTop, H - δ ≤ r n.
~~~

No rate convergence, eventual boundedness, monotonicity or eventual
below-entropy hypothesis is allowed. The proof must retain the pointwise
low-rate implication from 3.2. Establish a success upper bound at any
index with `r n < H-δ`, controlled by a full-sequence bound tending to zero
with a positive gap independent of n. Vanishing error makes success
eventually bounded below by a fixed positive number, excluding all such
late indices regardless of high excursions elsewhere. The notes give a
suggested width and contradiction argument.

An eventual-low-rate strong converse alone does not prove this contract.
An alternative proof must explicitly establish the same arbitrary-index
obstruction without hidden boundedness or convergence hypotheses.

### 3.4 Complete operational threshold

Expose a top-level theorem, not only separate single-block or typicality
results. Define the following set locally in the theorem's statement:

~~~text
S_p := {R : Real | ∃ M : Nat → Nat, (∀ n, 1 ≤ M n) ∧
  ∃ c : ∀ n, BlockSourceCode A n (M n),
    Tendsto (fun n => e n) atTop (nhds 0) ∧
    (∀ η : Real, 0 < η → ∀ᶠ n in atTop, r n ≤ R + η)}.
~~~

Prove `IsGLB S_p (entropy p)`: entropy is the greatest lower bound of
the asymptotic upper rates achieved by actual almost-lossless families.
The quantifier order is essential: one M and c work for every η at that R.
Every R>H belongs by 3.1. Every R in the set satisfies H≤R by intersecting
the upper tolerance and the general converse's eventual lower inequality.
The availability of every R>H establishes greatestness. `IsGLB` is an
order-theoretic assertion, not a conditionally complete Real limit.

No assertion that H belongs to this set, no single family with rate exactly
H, and no universal fixed-budget theorem at equality is required. Keep the
set comprehension inline; introduce no public achievable-rate predicate,
sequence bundle or infimum framework. A permanent consumer must combine
this theorem, above-H construction, strong converse and general converse
for the same p, code model, error and units.

### 3.5 Boundary cases

For H=0, choose ρ>0 in 3.1; do not require ε<H. The general lower bound
also follows from rate nonnegativity. Strong-converse assumptions with
R<H=0 contradict eventual nonnegative rates; do not invent a negative
operational rate. Pure sources and singleton alphabets admit explicit
one-message constant-decoder families with zero error and rate at every
length. Include a pure law on a larger alphabet and a sparse positive-entropy
law to exercise zero-probability symbols.

For the constructed family, M0=1, r0=0 and e0=0. Arbitrary converse families
may have any positive M0; all empty-word codes still recover the unique
word. `T(0,ε)=∅`, so its complement bound may be loose at zero. Normalize
only at n>0. Altering finitely many valid initial codes/budgets changes none
of the limits or eventual inequalities. A required private consumer
demonstrates an actual change to a nonempty finite prefix using eventual equality
of the scalar error and rate sequences. No generic dependent-family
transport framework is required. A PMF on an empty base alphabet is
impossible; do not invent one to test n=0. Zero-message budgets are excluded
by hM.

## 4. Ownership, public surface and consumers

Propose one new focused owner,
`LeanInfoTheory.Shannon.SourceCodingAsymptotic`, in namespace
`LeanInfoTheory.Shannon`. It combines coding/rates with AEP and therefore
belongs above the finite producers. Its direct imports are:

~~~text
LeanInfoTheory.Shannon.SourceCoding
LeanInfoTheory.Shannon.CodingRate
LeanInfoTheory.Shannon.SemanticBridge.AEP
~~~

Pinned analytic/order facts are presently available through this closure.
Add a focused mathlib import only with a demonstrated dependency reason and
the ordinary import-policy update. No change to SourceCoding, CodingRate,
Fano, TypicalSet, Probability.Iid, Units or their direct imports is planned.
In particular finite coding does not acquire an AEP dependency. The full
Shannon umbrella imports the new owner; the semantic umbrella and the
lightweight root retain their current imports. No example enters either
mathematical umbrella. Test positive access and negative reachability.

| Step | Proposed public name | Exact contract |
| --- | --- | --- |
| C21.01 | `exists_blockSourceCode_tendsto_errorProbability_zero` | Section 3.1, one positive-budget family with error tending to zero and eventual rate at most R, for H<R. |
| C21.02 | `tendsto_errorProbability_iid_one_of_eventually_codeRate_le` | Section 3.2, arbitrary families with an eventual cap R<H. |
| C21.03 | `eventually_entropy_sub_le_codeRate_of_tendsto_errorProbability_zero` | Section 3.3, every δ>0 and every vanishing-error family without rate assumptions. |
| C21.04 | `sourceCoding_threshold` | Section 3.4, `IsGLB` of the explicitly quantified achievable asymptotic-upper-rate set. |

These names are proposals, not existing declarations. Review discoverability,
argument order and naming against current source/index before implementation.
Ordinary inference refinements must preserve all hypotheses and witness
strength. Any additional public theorem/helper needs a concrete justification;
no new public definition, instance, alias or simp attribute is proposed.
Private helpers include complement/decay/rounded-rate limits, dependent choice,
the pointwise typical success estimates, and threshold order arithmetic.

Create the permanent non-stable owner
`LeanInfoTheory.Examples.SourceCodingAsymptotic`, importing the focused public
owner and joining only `LeanInfoTheory.Examples`. Examples must consume
public endpoints rather than private production lemmas. Retain C20's
integration example as historical interface pressure; do not relocate or
rewrite it merely to remove a little private composition duplication.

## 5. Ordered steps and individually reviewable criteria

All seventeen criteria below are required. Each step applies the common
qualification/review duties in section 7 and stops after its own closure.

<a id="c21-01"></a>
### C21.01 - One almost-lossless family above entropy

Establish the focused owner and prove achievability. Before exposing the
endpoint, compile the connected dependent-choice, complement-limit,
actual-error limit and rounded-rate checkpoints under the exact contract.

- **C21.01-WITNESS:** Prove section 3.1 for arbitrary finite p and H<R;
  one dependent family has all positive budgets, typical-word recovery and
  complement error bounds in the connected private production checkpoint.
  The public theorem uses that same witness for error tending to zero and
  the required eventual rate upper bound; external consumers check these
  exported guarantees, not hidden properties of an extracted witness.
- **C21.01-ROUNDING:** Use actual natural ceiling budgets at H<ρ<R;
  prove the integer bounds, positive-length rate sandwich, vanishing
  `log 2/n` overhead and internal convergence to ρ. A permanent public-API
  consumer derives the roadmap's tolerance upper-rate formulation.
- **C21.01-BOUNDARY:** Check the constructed M0=1, zero empty-word
  error/rate and empty zero-length typical set in the private production
  checkpoint without normalizing at zero. Public consumers instantiate
  achievability at a pure source and a sparse source without stronger
  support/entropy/nonempty premises.
- **C21.01-ARCHITECTURE:** Add only the approved focused owner, public
  endpoint, umbrella access and private consumer; preserve all finite
  producer/root/semantic import boundaries, retained API and attributes.
  Generated current inventory and exact import approvals match actual source.

<a id="c21-02"></a>
### C21.02 - Pointwise low-rate estimate and strong converse

Use C20's public success bound and C19's atom estimate; do not reprove
success counting. Keep the shared pointwise implication private in the owner.

- **C21.02-POINTWISE:** Prove both section 3.2 estimates with the same strict
  typical set and exact error complement. The rate implication has explicit
  n>0 and M≥1 guards, allows any real R and remains usable at isolated
  low-rate indices. It imposes no eventual condition on a code family.
- **C21.02-STRONG:** Prove error tending to one for every positive-budget
  family with an eventual cap R<H, using a strictly positive entropy gap,
  complement convergence, exponential decay and the error range. No global
  cap, full support, positive entropy or rate-convergence premise is added.
- **C21.02-CONSUMER:** A permanent consumer applies the public strong
  converse to an actual one-message family under a source of positive
  entropy. A separate boundary check treats arbitrary positive M0 and
  shows the H=0/R<0 antecedent is impossible rather than misusing the theorem.

<a id="c21-03"></a>
### C21.03 - General converse without rate regularity

The general conclusion must use the pointwise estimate; an application of
the eventual-cap strong converse alone fails this step's scope.

- **C21.03-GENERAL:** Prove section 3.3 with only p, M, hM, c, vanishing
  error and δ>0; no bound, convergence or monotonicity assumption on rates.
- **C21.03-BADINDICES:** Compile the connected low-index contradiction
  with a positive gap independent of n and an eventual positive lower
  bound on success. Explicitly show why arbitrarily large low-rate indices
  are excluded even if other rates oscillate or are unbounded.
- **C21.03-CONSUMER:** Permanent public-endpoint consumers include an actual
  vanishing-error family with unbounded oscillating rates, and an actual
  positive-entropy family with a fixed `δ > 0` and
  `∀ N, ∃ n ≥ N, r n < H - δ`, but no eventual cap at any fixed R<H.
  The general converse rules out vanishing error for the latter. For the
  unbounded example prove `∀ B : Real, ∀ N, ∃ n ≥ N, B < r n`, together
  with a distinct bounded branch arbitrarily far out. Prove actual
  branch/budget properties; scalar sequences without codes are insufficient.

<a id="c21-04"></a>
### C21.04 - Operational threshold and complete consumers

Complete the four-endpoint package and its boundary/ownership qualification.

- **C21.04-THRESHOLD:** Prove `sourceCoding_threshold` with precisely the
  section 3.4 set and `IsGLB` contract. Prove both the lower-bound and
  greatestness obligations using actual family witnesses and the general
  converse. No membership-at-H or exact-fixed-rate-H assertion is substituted.
- **C21.04-INTEGRATION:** A single permanent consumer assembles the top-level
  threshold, above-H almost-lossless existence, below-H error-to-one result
  and general eventual lower bound for the same finite p, error and nats.
  Exercise the threshold's lower-bound projection on an actual vanishing-error
  family with asymptotic upper rate R to obtain H≤R, and instantiate
  achievability at H+δ for δ>0. Apply the package to one sparse nonuniform
  source with support cardinality two and prove 0<H<R<log 2 for a chosen R.
  Extract one public achievability family with error tending to zero and
  eventual rate at most this R, demonstrating compression below support size.
- **C21.04-EDGE:** Complete the boundary matrix in section 6: pure and
  singleton one-message families, sparse positive-entropy source, H=0,
  positive arbitrary initialization and finite initial modifications.
  Demonstrate one valid finite-prefix modification through eventual
  equality of scalar errors/rates; preserve strict typicality and rate guards.
- **C21.04-API:** Review the complete public/private split, four endpoint
  signatures, naming, focused/umbrella/example imports and absence of new
  simp rules. Reconcile generated current references and in-scope canonical
  statements without asserting closure or a larger release scope.

<a id="c21-05"></a>
### C21.05 - Cumulative qualification and maintained handoff

This final step adds no mathematical endpoint. Independently review every
approved criterion, including the first four steps, against the final candidate.

- **C21.05-VALIDATION:** Qualify the exact candidate with the complete
  maintained clean routine, affected focused consumers/aggregates,
  compiled compatibility/trust, current imports/API/simp/generated and
  release-documentation checks. Complete the separately authorized local
  two-pass API-documentation milestone and inspect every new elaborated
  signature, hypothesis, docstring, owner and source link; retain failures,
  source/configuration/dependency identity and applicability limits.
- **C21.05-READINESS:** Retain current validation, contextual read-only
  self-review and separate reassessment, predecessor closure/source checks,
  all original-report obligations, and a neutral source-bound request
  covering all seventeen criteria. Required work and material concerns have
  explicit dispositions; optional omissions have owners/reopening triggers.
- **C21.05-HANDOFF:** Before final source capture maintain
  `docs/handoffs/chunk-21.md`, linked from reconciled canonical context,
  with actual endpoints/imports/consumers, source adaptations, same-family
  quantifiers, eventual-limit conventions, private-helper decisions,
  evidence limits and remaining-work dispositions for C22/C23/C24.
  Reassess the C19--C21 package by delivered mathematics, not declaration
  quotas; preserve the second-release boundary and channel-achievability exclusion.

Readiness precedes dispatch; receipt, substantive reconciliation, corrections,
final validation and supported private closure remain later obligations of
this same selected step. A clean report also requires explicit reconciliation.
Any criterion gap/contradiction needs a satisfactory new reviewer assessment,
not an implementer-only override. Finish all source/docs/handoff edits before
F, with captured wording such as "validation ready; closure subject to the
private completion record." Preserve B/R/F and R-to-F applicability; use
the supported completion mechanism and do not edit captured documents after
F just to announce closure. Stop after C21.05, without starting C22.

## 6. Permanent consumer and boundary matrix

| Consumer | Required evidence and owner |
| --- | --- |
| Generic above-H witness | Extract M and c once from the public theorem; use those same witnesses for both error and rate statements in `Examples.SourceCodingAsymptotic`. |
| Positive-entropy one-message code | Actual constant encoder/decoder; M=1 and rate zero; public strong converse yields error tending to one. |
| Intermittent low-rate obstruction | A positive-entropy binary source, alternating full-word recovery budgets and one-message budgets. Prove a fixed δ>0 with low-rate lengths r n < H-δ arbitrarily far out, and absence of an eventual cap for every fixed R<H; public general converse excludes vanishing error. |
| Unbounded oscillation with vanishing error | An actual pure-source family with constant decoded source word and alternating one-message/rapidly growing positive budgets suffices. Prove zero error, a bounded-rate branch arbitrarily far out (rate zero for the pure fixture), and rates exceeding every real bound arbitrarily far out; apply the unrestricted general converse. This checks applicability without rate bounds; the separate positive-entropy intermittent consumer checks the substantive low-rate obstruction. A positive-entropy replacement may satisfy the same criterion, without an extra required example or public padding API. |
| Biased sparse source and compression | One private source, for example masses (1/3,2/3,0), has support cardinality two and 0<H<log 2. Choose H<R<log 2 and use one public achievability witness for error tending to zero and eventual rate at most R. This same source exercises the complete package without full support; impossible words remain outside C19 typical sets. The entropy gap follows from the support bound and its uniformity characterization. |
| Pure/singleton/H=0 | Explicit M=1 families give zero error/rate; above-H theorem still accepts every R>0, and the general lower conclusion requires no H>0. A pure law on a larger carrier exercises zero-mass symbols. |
| Zero length and finite initialization | The private production checkpoint checks constructed M0=1. External consumers check arbitrary positive-budget empty-word codes and one actual finite-prefix modification preserving limits/eventual inequalities by eventual equality of scalar errors/rates. No exponential/rate cancellation at n=0. |
| Complete threshold | A single consumer packages all three asymptotic conclusions and the public `IsGLB` result with identical definitions, extracts H≤R from achieved asymptotic upper rate R, and obtains a family at H+δ for δ>0. Test focused import, full Shannon access and Examples-only placement. |

Hidden properties of the constructed witness are checked only in the private
production checkpoint; public-API examples use exported guarantees or their
own independently constructed fixtures. Reuse private binary fixtures across
consumers where practical. Do not expose fixture definitions or prove unrelated
code optimization facts. C20's existing finite boundary consumers remain useful
prior evidence but do not replace these sequence-level checks.

## 7. Validation, review and authorization gates

During each selected dirty-tree step, serialize artifact-producing Lean runs.
Compile the touched focused owner, its permanent consumer and important
downstream aggregates through the maintained validator, for example:

~~~text
python scripts/validate_release.py focused LeanInfoTheory.Shannon.SourceCodingAsymptotic LeanInfoTheory.Examples.SourceCodingAsymptotic LeanInfoTheory.Shannon LeanInfoTheory.Examples
~~~

After approved public/import changes, deliberately regenerate current API
and website source references with the established generators, verify the
frozen manifest non-mutatingly, then run `python scripts/validate_release.py static`.
Run `documentation` when relevant prose/examples change and the maintained
compiled compatibility/trust gate for the changed public surface. Require
actual permanent consumers, exact import/root checks, reviewed attributes,
proof-placeholder/source checks and the allowed-axiom audit. No dependency
pin, frozen release, gate weakening or tooling extension is in scope.

Record actual actors, commands, outcomes and source identity. Distinguish
fresh checks, earlier applicable evidence, reviewer checks and unavailable
evidence. Preserve failures. Planning probes are isolated evidence and must
not be shipped or counted as supported declarations. Remove disposable
Lean probes after retaining command/result/hash evidence before a milestone.

Use the installed protocol for each explicitly selected step: B before edits,
initial validation, retained contextual self-review, separate reassessment,
finished owned edits, neutral source-bound R request, genuine native report,
all-finding/all-criterion reconciliation, correction validation, completed
documents before F, and supported scoped closure. The persistent C21 reviewer
must not receive implementation transcripts, self-review verdicts or other
reviewers' assessments. Provide exact normative excerpts when documents mix
requirements and historical assessments; retain observable context limits.

For C21.05, prepare a concrete scoped checkpoint proposal and review any
existing validation checkout before requesting its separate authorization.
Only after that authority may the clean committed candidate run
`python scripts/validate_release.py`; rerun the entire routine after every
amendment. Dirty focused/static checks do not replace this requirement.
Likewise obtain the separate local API-documentation milestone authority
before `python scripts/validate_release.py api-docs`; on Windows use the
reviewed Zig 0.16.0 and local file links. Recheck source/configuration/pins,
attestation and output applicability after changes. Neither milestone grants
publication. If authority is pending, report the pending gate and do not
claim chunk completion or silently commit unrelated work.

Canonical reconciliation covers the living summary, relevant map/roadmap,
current state, source/reference/API documentation, targeted project-log and
Future Work Note 14/discovery feedback as actually affected. Append scoped
log material without rewriting unrelated history. Preserve all pre-existing
changes. Implementation approval does not authorize a naming migration.

## 8. Plan-health checkpoints and decisions

The notes retain verified searches and isolated proof results. Recheck actual
production elaboration at C21.01 and the pointwise proof at C21.02/C21.03;
neither planning success nor a compiler pass substitutes for intended-meaning
review. Stop for a lead decision if the contracts require stronger hypotheses,
a new code/rate/probability abstraction, changed ownership, a dependency
upgrade, a weaker general converse or reduced acceptance criteria.

The proposed decision is a five-step/four-public-endpoint package in the
focused asymptotic owner, with `IsGLB` as the top-level threshold and eventual
inequalities as primary rate contracts. No unresolved mathematical convention
requires a new assumption. Exact-plan approval remains with the lead; formal
plan review is separate and has not been dispatched. Checkpoint/API milestones,
publication and later chunks retain the authority boundaries above.
