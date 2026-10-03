# Chunk 13: Pinsker and Quantitative Independence

<!-- lit-review-status:start -->
**Status:** Approved, active, revision 2, 2026-10-03.
The lead accepted revision 2. C13.01--C13.03 and their review processes are
complete by their private completion records. C13.03's exact final source was
verified before processing the lead's conditional C13.04 request with review.
Only C13.04 is currently selected. The lead explicitly authorized its 25-file
checkpoint, separate clean validation checkout and necessary Step-4-only
amendments. Initial checkpoint `17fb736a00448ecdd0aa824fd1928713bf716f01`
passed the complete routine suite in 1975.056 seconds; both current
API-doc passes and inspection also passed. Final amended-candidate validation,
cumulative review, reconciliation and closure remain governed by source-bound
records.
Revision 1's review found no material concern;
its original records remain bound to revision 1.
C12 is complete through C12.04 at `492cd6e`; captured provisional wording in
earlier documents does not reopen it. The lead also authorized reasoned
adaptation during implementation: use judgment, retain clear step goals and
review, and record justified changes. Later steps require their own requests.
<!-- lit-review-status:end -->

## 1. Scope and authority

This plan refines [C13 and the shared contracts in the chunk map](post-release-chunk-map.md#c13-pinsker-and-quantitative-independence).
The endpoint is finite-PMF Pinsker in nats, including infinite KL, followed by
guarded Real and square-root forms and quantitative closeness of a joint law
to the existing independent product of its marginals.

The mathematical prerequisites are C10 total variation and the existing
KL/data-processing and MI-as-KL interfaces. Neither coupling nor gluing is a
mathematical prerequisite. Their position in the chunk sequence supplies no
reason to import them into the new owner.

After approval, perform only one explicitly requested step with the installed
review process, report its scoped result, and stop. Plan review requires its
own explicit request and uses the installed PLAN workflow. Reviewer bootstrap
is neither plan review nor acceptance. Planning, review and plan approval do
not authorize a commit, push, deployment, release or dependency change, or
another chunk. The final clean-checkpoint gate needs separate authority.

Excluded: reverse Pinsker, refinements of the constant, equality or optimality
classification, optimal joint ranges, a general f-divergence hierarchy, Tao's
conditional-expectation inequality, entropy/MI continuity, topology, coding,
and application-specific certificate work. No stable declaration is moved or
renamed, and no second probability or divergence representation is introduced.

## 2. Verified intake and references

### 2.1 Checkout and prerequisite applicability

Use `C:\Users\coban\Desktop\Lean Info Theory`. Intake HEAD on `master` is
`492cd6e60c5d6b42a22ef2dcbb45d21067b6d378`. The only initial Git change is
`docs/next-website-tasks.md`. Preserve its bytes, staging state and location;
do not stage, commit, restore, hide or push it. Its intake SHA-256 is
`8db54766aff44faaf5f2380f0e9c11103ab4ba5471d2928b1c2750a3f3a11887`.

The actual `.lit-review/setup/c12-04-completion-20261003.json` records
`SUPERVISED_STEP_COMPLETE`, all four steps complete, no active step, and the
same HEAD. Its closure is
`915974a9f91d92aeec145a165ef9b4a3ff6145b730e4b769f3edeeeea7d9b0b2`;
F is `54a73c7aa797173f3212e77219442d5045da5dae3264011f1771be6265af387a`.
The C13 parent compared all 209 captured file entries against F: no mismatch.
Captured configuration and all nine installed dependency identities also match.
The check and its limits are retained in
`.lit-review/setup/c13-prerequisite-applicability-20261003.json`.
This is applicability of earlier evidence, not a new full-suite or C12 review.

A fresh read-only `git ls-remote origin refs/heads/master` returned
`bbead98abfd2ac94f95b615652365a65228e49c5` on 2026-10-03. Thus C12's local
checkpoint was not the remote branch tip at intake. No remote CI or publication
claim follows from local tracking refs, and no push is part of this plan.

Lean remains `v4.33.1`; mathlib remains
`0df444a360eaa60ab8c11dca51a86af692955474`. The historical release remains
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, with its frozen manifest,
retained structural contract and versioned documentation protected. Current
intake coverage is 642 supported declarations in 34 owners, 94 reviewed simp
declarations and 92 root exports. These are observations, not growth quotas.

Read for this intake: `AGENTS.md`; living-summary Quick Start and relevant
mathematical, architecture, limitations, active-work, reference and validation
sections; the C13 and shared map contracts; the C10 and C12 handoffs;
`docs/references.md`; both review documents; API-documentation policy; targeted
project-log entries, including the C12 warning-policy correction. Historical
hand-off prose is interpreted alongside actual completion records.

### 2.2 Exact mathematical source

PW24 is Polyanskiy and Wu, *Information Theory: From Coding to Learning*,
August 16, 2024 prepublication draft, local file `Polyanskiy-Wu Newer.pdf`.
The local SHA-256 was freshly checked against the reference register:
`c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
Section 7.4, Theorem 7.10, equation (7.27), is on printed page 126 / PDF page
151; the binary proof concludes on printed page 127 / PDF page 152. Both
pages were extracted and visually inspected. PW22 numbering is not used.

The displayed source bound has constant `2 log e`, with the logarithm base
accounted for explicitly; its proof switches to natural logarithms. C13 uses
`Real.log`, so the constant is exactly 2. TV is the half-L1 probability
normalization, in agreement with C10 and PW24 Section 7.3, Theorem 7.7(a),
equation (7.18), printed pages 122--123 / PDF pages 147--148, as recorded in
the C10 handoff. TV of Bernoulli laws is `|p-q|`.

Adaptations: replace a supremum over events by C10's explicit attaining
event; retain KL in `ENNReal`; supply the endpoint/support cases omitted by
the short analytic exposition; and use a closed-interval convexity proof of
the same second-derivative bound instead of requiring an improper integral
Taylor formula. Quantitative independence is a derived application to the
existing MI-as-KL identity, not a separately numbered PW24 theorem. Only this
Pinsker slice of Section 7.4 is selected. No reference PDF or substantial
textbook prose/proof is added to Git. No external formalization repository
was consulted.

### 2.3 Existing interfaces and search results

All paths below are under `LeanInfoTheory/`, unless prefixed by `Mathlib`.
Names identify inspected declarations, not proposed aliases.

| Need | Verified source and reusable declaration |
| --- | --- |
| Half-L1 TV | `Probability/TotalVariation.lean`: `PMF.totalVariation`, nonnegativity, range, separation and map/channel contraction; public interfaces use `[Fintype α]`. |
| Attaining event | `PMF.totalVariation_eq_toOuterMeasure_sub` uses `A = {a | (q a).toReal ≤ (p a).toReal}`; `PMF.abs_toOuterMeasure_sub_le_totalVariation` and `PMF.totalVariation_map_le` recover exact Bool reduction. |
| Existing binary consumer | `Examples/TotalVariation.lean`: private `maximizing_event_boolean_preserves_totalVariation`; it is evidence of the route, not an importable public theorem. |
| KL data processing | `Shannon/SemanticBridge/DataProcessing.lean`: `klDiv_map_le` and `klDiv_channel_le`, unconditional `ENNReal` statements on finite discrete alphabets. Real companions require support inclusion. |
| Finite KL | `Shannon/SemanticBridge/KL.lean`: `toMeasure_absolutelyContinuous_iff_support_subset`, `klDiv_pmf_ne_top_iff_support_subset`, `klDiv_pmf_eq_top_iff_not_support_subset`, `toReal_klDiv_pmf_eq_sum`. Finiteness equivalence needs only `[Finite α]`. |
| MI bridge | Same KL owner: `mutualInfo_eq_toReal_klDiv_joint_indepProd`; product owner: `joint_toMeasure_absolutelyContinuous_indepProd_marginals`, `indepProd`, its atom and product-measure laws. |
| Independence conventions | `Shannon/SemanticBridge/Independence.lean`: `IsIndependent` is equality to the product of the existing marginals; existing zero-MI results choose a discrete measurable structure locally. |
| Existing singular regression | `Examples/KLTop.lean`: distinct pure Bool laws have KL equal to top and real KL zero. C13 must additionally disprove the unguarded Pinsker inequalities. |
| Log-sum alternative | `Shannon/LogSum.lean`: `logSum_inequality` has an extended `EReal` scalar formulation; `real_logSum_inequality_of_support` has explicit support guards. Neither supplies the missing quadratic binary estimate. |
| Analytic ingredients | Pinned `Mathlib.Analysis.SpecialFunctions.BinaryEntropy` and `Mathlib.Analysis.Convex.Deriv`: `Real.hasDerivAt_binEntropy`, `convexOn_of_hasDerivWithinAt2_nonneg`, `ConvexOn.isMinOn_of_rightDeriv_eq_zero`. |

A case-insensitive search of all pinned Mathlib Lean sources found no Pinsker
or Bernoulli-KL theorem. This is a bounded source-search result, not a claim
about later mathlib. The pinned `PMF.bernoulli` family is deprecated; use
arbitrary `PMF Bool` and real atom parameters, or a private `PMF.ofFintype`
consumer construction. No deprecated constructor is needed.

## 3. Proposed contracts and ownership

### 3.1 Canonical Pinsker

Proposed owner: `LeanInfoTheory/Shannon/SemanticBridge/Pinsker.lean`.
All five proposed public theorems live in `LeanInfoTheory.Shannon`.
For a type `α` in any universe, the canonical contract is:

```lean
theorem ofReal_two_mul_totalVariation_sq_le_klDiv
    {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) :
    ENNReal.ofReal (2 * PMF.totalVariation p q ^ 2) ≤
      InformationTheory.klDiv p.toMeasure q.toMeasure
```

There is no support, absolute-continuity, full-support, positivity, nonzero-TV
or explicit `Nonempty` hypothesis. In particular, singular support and
`KL = ⊤` belong to this theorem.

`Fintype` is exposed because the existing TV definition uses an enumeration;
replacing it by `Finite` alone would not elaborate the existing expression.
Consumers with `[Finite α]` may install `Fintype.ofFinite α` locally. This
does not justify changing C10's definition or adding an alternate TV.

The measurable-space assumptions are explicit and necessary for the supplied
measure interpretation. A finite type with measurable singletons has all sets
measurable. An arbitrary indiscrete measurable space can identify distinct
PMF measures, making KL zero while PMF TV is positive. Do not assert the
displayed theorem over such a space. No global measurable instance is added.

### 3.2 Guarded Real and square-root forms

Use the same typeclass assumptions and argument order as Section 3.1, with
the explicit guard `h : p.support ⊆ q.support`:

```lean
theorem two_mul_totalVariation_sq_le_toReal_klDiv
    {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) (h : p.support ⊆ q.support) :
    2 * PMF.totalVariation p q ^ 2 ≤
      (InformationTheory.klDiv p.toMeasure q.toMeasure).toReal

theorem totalVariation_le_sqrt_toReal_klDiv
    {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) (h : p.support ⊆ q.support) :
    PMF.totalVariation p q ≤
      Real.sqrt ((InformationTheory.klDiv p.toMeasure q.toMeasure).toReal / 2)
```

Support inclusion matches the neighboring public Real KL APIs and permits
zero reference atoms when the numerator also vanishes. First derive
`KL ≠ ⊤` using the existing equivalence; only then convert the canonical
inequality. Use TV nonnegativity and nonnegativity of real KL for the square
root. A consumer supplied directly with `hfin : KL ≠ ⊤` obtains the guard
from that same equivalence. No duplicate public finiteness wrapper is needed.

Do not turn these into unconditional Real statements. The fact that each
alphabet is finite does not make arbitrary KL finite, and `⊤.toReal = 0`.

The permanent private KL-budget consumer has this contract in
`Examples.Pinsker`; its name is local to that example owner:

```lean
private theorem event_discrepancy_le_sqrt_of_klDiv_le
    {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) (s : Set α) (ε : ℝ) (hε : 0 ≤ ε)
    (hKL : InformationTheory.klDiv p.toMeasure q.toMeasure ≤ ENNReal.ofReal ε) :
    |(p.toOuterMeasure s).toReal - (q.toOuterMeasure s).toReal| ≤
      Real.sqrt (ε / 2)
```

The finite `ENNReal` budget first establishes `KL ≠ ⊤`, then support
inclusion and the guarded Real upper bound. Compose the public square-root
form with `PMF.abs_toOuterMeasure_sub_le_totalVariation` and square-root
monotonicity. This consumer supplies a concrete path from an extended-valued
budget to an event bound. The separate support-guard and non-top-guard
consumers remain required; no public budget wrapper is added.

### 3.3 Quantitative independence

For independently universe-polymorphic types `α`, `β`, assume only
`[Fintype α] [Fintype β]` and `p : PMF (α × β)`. Write, in this plan only,
`Q := indepProd (fstMarginal p) (sndMarginal p)`. Reuse that existing object;
do not add a product constructor or public distance-to-independence definition.

```lean
theorem two_mul_totalVariation_sq_le_mutualInfo
    {α : Type u} {β : Type v} [Fintype α] [Fintype β]
    (p : PMF (α × β)) :
    2 * PMF.totalVariation p (indepProd (fstMarginal p) (sndMarginal p)) ^ 2 ≤
      mutualInfo p

theorem totalVariation_le_sqrt_mutualInfo
    {α : Type u} {β : Type v} [Fintype α] [Fintype β]
    (p : PMF (α × β)) :
    PMF.totalVariation p (indepProd (fstMarginal p) (sndMarginal p)) ≤
      Real.sqrt (mutualInfo p / 2)
```

These two public statements need no measurable-space, support, full-support,
nonempty-coordinate or finite-source-space hypotheses. In their proofs, choose
the discrete measurable structure on `α × β` locally. Use the existing joint
absolute-continuity theorem to derive actual support inclusion and finite KL,
then apply Section 3.2 and the existing MI-as-KL bridge. Positive joint mass
forces both marginal masses positive; null marginal rows/columns are harmless.
The MI bridge's `toReal` identity alone is not evidence of finiteness.

Permanent consumers must derive `TV(p,Q) ≤ sqrt(ε/2)` from
`mutualInfo p ≤ ε`, and event/test-function consequences from C10. For
`f : α × β → ℝ`, write the finite expectation difference as
`|(∑ z, (p z).toReal * f z) - (∑ z, (Q z).toReal * f z)|`.
With `∀ z, 0 ≤ f z ∧ f z ≤ 1`, bound it by `Real.sqrt (ε / 2)` using
`PMF.abs_sum_sub_le_totalVariation_of_mem_Icc`. With `∀ z, |f z| ≤ 1`,
bound it by `2 * Real.sqrt (ε / 2)` using
`PMF.abs_sum_sub_le_mul_totalVariation` at `M = 1`. Both are private
consumers of the same MI budget; `0 ≤ ε` follows from MI nonnegativity and
the budget, so neither adds that premise. Also include a mapped-law consumer
of the quantitative independence bound: for a source law `r : PMF Ω` on an
arbitrary type `Ω`, apply it to `r.map (fun ω => (X ω, Y ω))`, rewriting
the marginals as the existing pushforwards and MI as `mutualInfoOf r X Y`.
No finiteness or measurability on Ω is required.
Keep these convenience forms private unless repeated independent consumers
establish a concrete reason to revise the public surface.

### 3.4 Module and public/private boundaries

The proposed public surface is exactly the five theorems in Sections 3.1--3.3.
Private machinery includes scalar functions, derivatives, binary KL expansion,
reference-boundary proofs, event-to-Bool reduction, joint finite-KL facts and
conversion conveniences. No public Bernoulli lemma, binary constructor,
general strong-convexity framework, alias, new definition or simp attribute is
needed for the selected consumers.

The new owner directly imports TV and the existing semantic DataProcessing
owner, plus the focused pinned analytic/tactic imports needed by the proof.
The expected analytic owners are `Mathlib.Analysis.SpecialFunctions.BinaryEntropy`,
`Mathlib.Analysis.Convex.Deriv` and `Mathlib.Analysis.Real.Sqrt`; the compiled
probe uses focused `Mathlib.Tactic.FieldSimp` and `Mathlib.Tactic.FunProp`.
Inspect the final dependency closure and remove unused direct imports.
Do not import all of Mathlib or a broad tactic umbrella in production. The
exact final direct-import list must be recorded in the reviewed current API
policy. Adding a necessary focused mathlib import within this analytic scope
is an implementation detail; changing the project dependency direction is a
plan-health decision.

DataProcessing already reaches KL, Product and Independence. Reusing it keeps
the supported map-DPI interface. Do not make Independence import Pinsker: that
would create a cycle. Add Pinsker to the import-only semantic aggregate; the
full `LeanInfoTheory.Shannon` umbrella then reaches it transitively. Preserve
the lightweight root's exact direct imports and five-module local closure.
`Probability.TotalVariation`, `FiniteChannel` and `Coupling` gain no heavy
imports. The focused Pinsker owner must have no coupling/gluing dependency.

New permanent private consumers:

- `Examples/Pinsker.lean`, importing the focused Pinsker owner; an explicit
  `Examples.KLTop` import is acceptable only for reuse of its existing singular
  laws and results, never as a production dependency.
- `Examples/QuantitativeIndependence.lean`, importing the focused Pinsker
  owner and only any genuinely needed construction module.

Both join the non-stable Examples aggregate and remain outside both public
mathematical umbrellas. Add their metadata to the maintained generated-source
tooling where required. New Lean files use the exact EPFL/MIL header. Protect
all existing names, meanings, assumptions, attributes, releases and pins.

## 4. Proof route and feasibility

### 4.1 Recommended route

1. Use the non-strict attaining event `A` and Boolean indicator
   `b a := if a ∈ A then true else false`. Reconstruct the existing private
   C10 consumer argument from public event/map APIs inside the new owner.
   This proves exact TV preservation without unfolding the half-L1 sum.
2. Prove the canonical inequality for arbitrary `PMF Bool`. If reference
   support fails, KL is top. If its true-mass parameter `q` is 0 or 1 and
   support inclusion holds, the numerator is the same point mass, so TV and
   KL are zero. These branches precede any logarithm division.
3. For `0 < q < 1`, put `p := (P true).toReal`, so `0 ≤ p ≤ 1`.
   The guarded finite KL expansion identifies real KL with
   `-Real.binEntropy p - p*Real.log q - (1-p)*Real.log (1-q)`.
   This identity must include `p=0` and `p=1`, using zero-weight conventions
   explicitly; do not apply `Real.log_div` with a zero numerator.
4. Subtract `2*(p-q)^2`. The resulting function is continuous on `[0,1]`.
   On `(0,1)` its second derivative is
   `1/p + 1/(1-p) - 4 = (2*p-1)^2/(p*(1-p)) ≥ 0`.
   Closed-interval convexity and zero first derivative at the interior point
   `q` give the minimum zero. This handles both parameter orders and numerator
   endpoints without an unsafe endpoint Taylor expansion.
5. Lift the finite binary inequality back into `ENNReal`, and compose with
   the unconditional `klDiv_map_le`. Keep a top branch throughout; no real
   conversion of the original infinite divergence occurs.

Equal laws are covered independently of full support. For a singleton or any
subsingleton alphabet all PMFs coincide and both quantities vanish. On an
empty alphabet a supplied PMF is impossible; the public statement adds no
inhabitant assumption to hide that case.

### 4.2 Alternatives considered

| Route | Assessment |
| --- | --- |
| Reuse upstream Pinsker | Preferred if an applicable theorem exists, but none was found in the pinned source. No pin change is justified. |
| Event reduction plus closed-interval binary convexity | Recommended: uses verified C10 and KL-DPI interfaces, isolates the only new analytic estimate, and handles numerator endpoints by continuity. |
| Literal integral Taylor remainder from PW24 | Mathematically valid with appropriate orientation and endpoint limits; creates avoidable integrability and improper-endpoint work in Lean. Keep as fallback advice. |
| Log-sum on the event and complement | The guarded Real theorem can rederive coarse-graining after a finite-KL split, without the EReal conversion. The unconditional extended theorem adds EReal/ENNReal bookkeeping. Both duplicate the existing DPI interface and still need the quadratic binary estimate. |
| Direct finite-sum convexity or another divergence | May produce a different proof, but needs additional weighted inequalities or representations and careful constants. No evidence currently justifies this extra API/dependency scope. |

Proof routes are advisory within the exact contracts. If feasibility requires
stronger hypotheses, weaker constants, extra public APIs, a pin change or a
different ownership boundary, stop for an explicit plan revision. Keep
evolving implementation advice in `post-release-chunk-13-notes.md` once
implementation is authorized; do not silently rewrite approved contracts.

### 4.3 Feasibility evidence and limitations

The planning helpers used only ignored `tmp/c13-kl-probes/` and
`tmp/c13-mi-probes/`. The parent inspected their actual source and reran both
strict direct-Lean commands, with original streams and source text retained
under `.lit-review/setup/c13-planning-probes-20261003/`.

| Check | Actual scope and result |
| --- | --- |
| Complete canonical feasibility | `lake env lean -DwarningAsError=true tmp/c13-kl-probes/check.lean`: exit 0. Proves the exact general Section 3.1 contract, including the scalar closed interval, binary finite/top branches, reference endpoints, exact event reduction and map DPI. `#print axioms C13Probe.canonical` reports exactly `propext`, `Classical.choice`, `Quot.sound`. |
| Boundary specializations | The same probe proves both equal point-mass endpoints and the singular pure-Bool KL/top/real-zero facts; its generic scalar theorem includes numerator parameters 0 and 1. |
| Guard and MI composition | `lake env lean -DwarningAsError=true tmp/c13-mi-probes/Contracts.lean`: exit 0. Proves guard conversion, square-root conversion, the joint MI statement using an explicitly supplied canonical theorem, the unrestricted-source mapped-law form, and actual negations of both unguarded singular Real inequalities. This probe's theorem parameter is explicit, not a proof placeholder. |
| Existing prerequisite modules | Maintained six-target focused validator: exit 0, 59.106 seconds; actual command uses `lake --wfail build`. Covers TV, KL, DataProcessing, Independence, the C10 TV consumer and KLTop. Original result: `.lit-review/setup/c13-planning-focused-20261003/result.json`. This is an incremental build, not the full clean routine suite. |
| Planning static gate | `python -B scripts/validate_release.py static`: exit 0, 8.666 seconds. Current inventories, pins, generated artifacts, website and repository checks passed; no production API change is claimed. Original result: `.lit-review/setup/c13-planning-static-20261003/result.json`. |

The canonical probe SHA-256 is
`74a029e8756fa3a24512dac5bd1cad5d8316d6c5427facd39db1600401051581`.
It imports LogSum only to check the alternative APIs. Its source and the
interface probe are preserved as private evidence, with source-hash
applicability checked before scratch cleanup. Helpers reported earlier
tactic/style diagnostics; only the final strict successes establish feasibility.
The first parent display wrapper failed on Windows stdout encoding after
saving the successful canonical child result; that wrapper failure is recorded
separately, and the interface probe ran in a corrected separate invocation.

The central mathematical route is therefore proof-complete in isolation.
This does not establish production readiness, permanent-consumer coverage,
minimal imports, current API documentation, retained compatibility, or
independent implementation review. Those remain obligations of the approved
steps. The completed revision-1 PLAN review and its limits are recorded in
Section 7. No production Lean file was changed. Disposable probe files were
removed before the initial planning report after retaining evidence; private
review records remain. Revision 2's additional private consumers have been
checked against the existing interfaces and by mathematical calculation;
their permanent Lean proofs remain implementation obligations.

## 5. Steps and acceptance criteria

The four boundaries separate the new analytic/canonical theorem, guarded
conversions, the joint-law application, and cumulative qualification. They
avoid publishing a one-use binary helper merely to split the first proof.
Each step includes its consumers, applicable documentation/generation,
validation, contextual self-review, separately retained reassessment,
independent review and reconciliation before its private closure.

### C13.01 — Canonical ENNReal Pinsker

**Dependencies:** completed C10 and existing KL/DPI; no C11/C12 theorem.

Implement Section 3.1 with private binary analysis and event reduction,
establish the new semantic owner/import policy, and start `Examples.Pinsker`.
Public growth is the canonical theorem only.

- **C13.01-CANONICAL:** The exact Section 3.1 inequality is proved in nats,
  including singular support and infinite KL, with no extra hypotheses.
  Evidence: final elaborated signature, proof/axiom inspection and a permanent
  finite-alphabet consumer using the public theorem.
- **C13.01-BINARY:** The binary proof covers both parameter orders, equality,
  numerator parameters 0 and 1 with interior reference, reference parameters
  0 and 1 with both matching and singular numerators, and tied attaining
  events. Alongside the Bool consumers, maintain the positive `Fin 3` laws
  `p = (1/2, 1/4, 1/4)` and `q = (1/4, 1/4, 1/2)`. With coordinates
  `0, 1, 2`, prove the non-strict attaining event is `{0, 1}`, including
  the positive-mass tie at `1`, and `PMF.totalVariation p q = (1/4 : ℝ)`.
  For `D := InformationTheory.klDiv p.toMeasure q.toMeasure` under the
  local discrete measurable structure, prove
  `D = ENNReal.ofReal ((1/4 : ℝ) * Real.log 2)` and
  `D.toReal = (1/4 : ℝ) * Real.log 2`. The event indicator's pushforwards
  have true masses `3/4` and `1/2`; prove exact TV preservation and use the
  canonical theorem. This exercises a many-to-one reduction with three
  positive atoms. The reduction uses exact TV preservation and the existing
  KL data-processing inequality.
  Evidence: private proof branches and permanent Bool/`Fin 3` consumers;
  no unsafe log identity or `toReal ⊤` conversion.
- **C13.01-BOUNDARY:** The new owner and aggregate are reviewed in the growth
  policy; the root and low-level imports are preserved and Pinsker has no
  coupling/gluing dependency. Evidence: focused owner/consumer/aggregate
  builds, non-mutating static checks, exact import and trust/compatibility
  checks. The public helper boundary matches Section 3.4.

### C13.02 — Guarded conversions and quantitative consumers

**Dependency:** C13.01 and its review process complete.

Implement the two Section 3.2 forms and complete `Examples.Pinsker`.
Consumers exercise a supplied support guard and a supplied non-top guard,
using the existing equivalence for the latter.

- **C13.02-GUARDS:** Both public Real forms have the exact support guard and
  constants in Section 3.2; all Real conversions first establish finiteness.
  Evidence: elaborated signatures, proofs, and a sparse finite-KL consumer
  whose reference law is not full-support.
- **C13.02-CONSUMERS:** Permanent consumers prove `TV = (1/2 : ℝ)`,
  `KL = ENNReal.ofReal (Real.log 2)` and `KL.toReal = Real.log 2`
  for a point mass against a fair two-atom reference embedded in `Fin 3`,
  with a common zero atom; `KL` denotes
  `InformationTheory.klDiv p.toMeasure q.toMeasure` in this requirement.
  They prove the exact private event-budget contract in Section 3.2,
  deriving finiteness from `KL ≤ ENNReal.ofReal ε` before Real conversion.
  Equal, pure, singleton and impossible-empty cases are explicit.
  Evidence: minimal-import compilation
  and mathematical use of the canonical, Real and square-root declarations.
- **C13.02-SINGULAR:** For distinct pure Bool laws, prove `TV=1`, `KL=⊤`,
  and `KL.toReal=0`; prove the canonical inequality and the negations of
  both unguarded Real/square-root inequalities. Evidence: actual Lean
  propositions proving failure, not only a comment or a failed typecheck.

### C13.03 — Quantitative independence

**Dependency:** C13.02 and its review process complete.

Implement the two Section 3.3 forms with private support/finiteness helpers
and `Examples.QuantitativeIndependence`.

- **C13.03-INDEPENDENCE:** Both exact joint-law bounds use the existing
  independent product of the same law's marginals, with no extra public
  support/measurability hypotheses. Evidence: actual finite-KL proof and
  existing MI bridge, elaborated signatures and private conversion audit.
- **C13.03-USE:** Maintain small-MI budget, event, bounded-test and mapped-law
  consumers. For `I(p) ≤ ε`, derive TV at most `sqrt(ε/2)`; for a function
  valued in `[0,1]`, bound the absolute difference of expectations under
  `p` and its marginal product by the same quantity. Also prove the private
  signed-test consequence from `∀ z, |f z| ≤ 1` with the explicit factor
  `2 * Real.sqrt (ε / 2)`, as specified in Section 3.3. The source-law consumer
  uses arbitrary Ω and the actual `mutualInfoOf`/pushforward marginals.
  Evidence: focused compilation from the new owner and explicit constants.
- **C13.03-SPARSE:** Maintain independent/zero-MI and singleton endpoints,
  and a dependent sparse joint with a null marginal value. A concrete
  diagonal fair-bit law embedded in `Fin 3 × Bool` has MI `Real.log 2`, TV to
  its marginal product `(1/2 : ℝ)`, and a zero reference row. For joint-to-product
  KL, prove `KL = ENNReal.ofReal (Real.log 2)` and `KL.toReal = Real.log 2`,
  in addition to actual finiteness. This demonstrates that full support is
  unnecessary. Evidence: exact masses,
  marginals and quantitative bounds, plus empty-coordinate impossibility.
- **C13.03-API:** All five public theorems have useful permanent consumers,
  documented assumptions and discoverable names; private helper status,
  no new simp policy and focused ownership are preserved. Evidence: current
  inventory, import, retained-contract and trust checks plus naming review.

### C13.04 — Cumulative qualification and maintained handoff

**Dependencies:** C13.01--C13.03 and their reviews complete; separately
authorized clean-checkpoint arrangement for the complete routine suite.

This final step adds no new mathematical scope. Finish canonical context and
`docs/handoffs/chunk-13.md`, settle findings and remaining-work dispositions,
and prepare the complete candidate before fresh independent full-chunk review.

- **C13.04-VALIDATION:** The exact candidate passes the complete maintained
  routine suite in an authorized clean checkout, focused independent
  consumers, and the actual two-pass current file-mode API-doc milestone.
  Inspect the new page and all five rendered signatures/docstrings/owners;
  verify current v2 source/configuration/dependency attestation. Evidence:
  actual command/results, source identity, original output and inspection;
  repeat invalidated gates after amendment. Earlier caches are disclosed.
- **C13.04-READINESS:** All owned source, generated and canonical-document
  edits are complete for review, every preceding review assessment has an
  explicit durable reconciliation, and no material issue or required
  consumer is unresolved. Evidence: exact review source, criterion matrix,
  source applicability, dispositions and owned-edit state. A favorable
  report alone does not establish later receipt, reconciliation or closure.
- **C13.04-HANDOFF:** The maintained handoff records delivered APIs, useful
  imports and consumers, source adaptations, guard/endpoint decisions,
  actual evidence and limitations, deferred items with owners/triggers, and
  later-chunk boundaries. Canonical records link it and distinguish current
  results from historical release facts. No later chunk starts automatically.

The fresh cumulative reviewer assesses every criterion above, including
earlier-step mathematical contracts. After receiving the original report,
reconcile every finding and criterion assessment, correct and revalidate
within authority, and obtain a new satisfactory reviewer assessment for
every criterion gap. Establish exact R-to-F applicability, finish all
captured edits before F, then use the installed private closure operation.
Record actual closure privately and in the user report, without editing a
captured document afterwards merely to insert the closure ID.

## 6. Validation and documentation duties

### 6.1 During implementation

Use this schedule on each step's complete candidate, including its reviewed
policy and generated artifacts. Section 5 fixes the mathematical coverage.

| Step and criteria | Principal permanent consumers | Checks before step review |
| --- | --- | --- |
| C13.01: CANONICAL, BINARY, BOUNDARY | `Examples.Pinsker`: Bool boundaries, positive three-point tied event and exact TV reduction | Focused owner/consumer/aggregate/root builds; `static`; `trust`. |
| C13.02: GUARDS, CONSUMERS, SINGULAR | `Examples.Pinsker`: both supplied guard forms, sparse finite KL, exact event budget, and singular negations | Focused builds including the completed Pinsker consumers; `static`; `trust`. |
| C13.03: INDEPENDENCE, USE, SPARSE, API | Both new example owners: MI/event/unit-interval/signed budgets, arbitrary source law and sparse joint | Focused builds including both new consumers and affected aggregates; `static`; `trust`. |
| C13.04: VALIDATION, READINESS, HANDOFF and all earlier criteria | All chunk consumers, maintained independent documentation examples and prepared handoff | Complete routine suite on the authorized clean candidate, plus Section 6.2's actual two-pass `api-docs` milestone and output inspection; cumulative review and source applicability. |

At C13.01--C13.03, run `trust` after the candidate's policy/generation updates
and static checks; it includes the maintained build and retained compatibility
gate. Those included checks satisfy the corresponding obligations without
separate duplicate invocations. The required focused consumer builds remain
explicit. At C13.04 the complete routine suite includes `trust`; the API-doc
gate remains separate. Rerun checks invalidated by corrections. If README or
release-facing documentation examples change earlier, also run `documentation`
for those changes. The final routine suite includes those documentation checks.

Use the maintained validator. The targeted command grows with the files
actually touched; representative targets are:

```text
python -B scripts/validate_release.py focused LeanInfoTheory.Shannon.SemanticBridge.Pinsker LeanInfoTheory.Examples.Pinsker LeanInfoTheory.Examples.QuantitativeIndependence LeanInfoTheory.Shannon.SemanticBridge LeanInfoTheory.Shannon LeanInfoTheory.Examples LeanInfoTheory
python -B scripts/validate_release.py static
python -B scripts/validate_release.py trust
```

Do not name a future consumer target before it exists. Include TV/KL/DPI and
relevant established consumers when changes affect their interfaces. Serialize
artifact-producing Lean builds. During isolated probes, direct
`lake env lean -DwarningAsError=true <probe>` is valid. The maintained focused
build uses `lake --wfail build`; preserve C12's correction. The historical
`-KwarningAsError=true` Lake flag is ineffective and must not be copied.

After approved public/import changes, update the reviewed growth policy using
actual authority, then deliberately regenerate the current public manifest
and source-derived website artifacts and run their checks. The historical
generator is check-only:

```text
python -B scripts/generate_current_public_api.py
python -B scripts/generate_v0_1_public_api.py --check
python -B scripts/generate_website_blueprint.py
python -B scripts/generate_website_api_index.py
python -B scripts/validate_release.py static
```

Check exact direct imports, root reachability, current supported inventory,
non-stable exclusions, reviewed attributes, retained signatures/assumptions
and allowed axioms. The only permitted axioms remain `propext`,
`Classical.choice` and `Quot.sound`. No proof placeholders, trust shortcuts,
or public examples disguised as regression helpers are allowed.

### 6.2 Cumulative clean and API-documentation gates

Run `python -B scripts/validate_release.py` only on the exact authorized
clean committed candidate, and repeat after any amendment. The intentionally
dirty original checkout cannot pass that hygiene contract. Prepare the owned
diff and concrete validation arrangement first; obtain separate checkpoint
authority at the final required point. A separate clean checkout is acceptable
once authorized, with exact source/pin comparisons and disclosed incremental
caches. Do not hide or commit the unrelated website notes to pass hygiene.

C13.04 is explicitly proposed as an API-documentation milestone because a
new supported owner and public contracts are being added. Run the maintained
`python -B scripts/validate_release.py api-docs` with `DOCGEN_SRC=file` and,
on Windows, the exact reviewed Zig 0.16.0 through `LEANINFOTHEORY_ZIG`.
Both actual build/check passes are required, with the v2 source-content
identity and output attestation. Inspect concrete signatures, docstrings,
constants, support hypotheses and source links. Source-body/docstring changes
invalidate old evidence even if names/counts are unchanged.

This gate is separate from the routine suite and is not a per-step requirement.
C10/C12's stale aggregate-marker history justifies careful output inspection;
it does not authorize preemptive cache deletion. Preserve a reproduced failure
and use only a bounded, evidenced repair before rerunning the unchanged gate.
Current file-mode output stays under `docbuild/.lake/build/doc/`; do not stage
it into the frozen `/docs/v0.1.0/` route or publish it.

### 6.3 Canonical reconciliation and dispositions

At meaningful steps, update the project log and C13 implementation notes.
By C13.04 reconcile affected sections of the living summary, current Lean
state, README/module guidance, roadmap/chunk map, reference register and
API-documentation guides against actual source and evidence. Generated
reference counts describe current coverage, not approval or semantic proof.
Keep historical release/checkpoint prose distinct and preserve the C12
completion evidence. The handoff must link exact public contracts, imports,
consumers, source editions, review records and validation limits.

| Remaining work | Owner and trigger |
| --- | --- |
| Public finite-KL, Bernoulli or budget wrappers | KL/API maintainer after repeated independent consumers show that existing guards or private helpers are insufficient. |
| Naming or aliases | API maintainer under Note 14 after concrete search/usage friction, deduplicated in downstream API feedback. No rename is inferred. |
| Doc-gen cache/tooling issue | Documentation maintainer under Note 9 after a reproduced failure; preserve original diagnostics and exact repair scope. |
| Continuity and topology | C14/C15 owners after their own approved plans and requests; C14 does not require Pinsker. |
| Refined/reverse Pinsker, general divergence or stability theory | A separately approved theorem phase with an actual consumer and exact support/constant contract. |
| Publication/release work | Project lead under separate explicit authority; this chunk changes neither pins nor release identity. |

## 7. Review initialization and approval decisions

The actual C13 implementation parent is
`01a10195-80e8-7f12-a8dc-70d8ca13ae68`, native role `/root`. It ran the
installed `inspect` and `api` commands and created its own persistent reviewer
`/root/c13_reviewer` using `collaboration.spawn_agent` with requested
`model="gpt-6-astra"`, `reasoning_effort="ultra"`, `fork_turns="none"`.
The original creation result and actual native call are preserved, along
with the complete bootstrap `list_agents` result and extracted acknowledgement.
The supported `bind` command succeeded. Effective parent/reviewer model
settings are unreported and remain unknown. Read-only instructions are
cooperative restrictions, not OS isolation or authenticated provenance.

Private setup records have prefix `.lit-review/setup/c13-`:
`planning-inspect-20261003.json`, `planning-api-20261003.json`,
`reviewer-creation-20261003.json`, `reviewer-bootstrap-20261003.json`,
`binding-packet-20261003.json`, and `binding-result-20261003.json`.
The binding is also retained at `.lit-review/chunks/C13/binding.json`.
No other chunk's reviewer was transferred. The two research helpers supplied
planning evidence only; neither is the independent reviewer.

The installed revision-1 PLAN review completed with all 13 proposed criteria
assessed as adequate and no findings. Its original report and reconciliation
are retained under `.lit-review/setup/c13-plan-review-*-20261003.json`;
the completion record is `c13-plan-review-completion-20261003.json` in that
directory. The reviewer freshly inspected the interfaces, mathematical source
and import closure, and passed static validation and a corrected strict stdin
interface/composition probe. Its initial probe's style-linter failure remains
recorded. This was not a fresh reconstruction of the complete canonical proof.

The lead also supplied an advisory General Assistant report: it found no
blocking issue after inspecting the plan, saved proof and relevant interfaces.
Its separate compilation attempt timed out without diagnostics, so that report
supplies no fresh compilation pass. It remains separately attributed and does
not replace the installed chunk review.

Revision 2 applies the lead's request to select the best subset of both sets
of suggestions:

| Suggestion | Decision and reason |
| --- | --- |
| Full public Lean signatures and typed KL constants | Adopt: make every assumption, product law and `ENNReal`/Real distinction explicit. |
| Exact private KL-budget contract | Adopt: show how an extended-valued upper budget establishes the guard before the event bound. |
| Per-step validation table | Adopt: connect criteria and consumers to checks while preserving the full trust, clean and API-doc gates. |
| Positive three-point tied-event example | Adopt: test a positive-mass tie and a genuine many-to-one Boolean reduction. |
| Signed-test consumer | Adopt: check C10's factor of two by a short composition alongside the unit-interval bound. |
| Reverse the sparse finite-KL pair | Defer: the existing singular negations already cover the essential Real-conversion failure; prioritize the two distinct coverage additions above. Reconsider only if implementation reveals support-orientation ambiguity. |

The five public statements, proof route, ownership and four-step structure
remain the same. Revision 2 adds only the selected private consumers and
contract/validation precision. The revision-1 review remains bound to its
original source; no fresh PLAN review of revision 2 is claimed. This revision
does not approve the plan or begin implementation.

**Decisions requiring lead approval:**

1. Approve this exact revision's five contracts, including the support-guarded
   Real surface and measurable assumptions on the canonical KL statement.
2. Approve the one-owner semantic architecture, aggregate addition and private
   helper/consumer boundary, with the four dependency-based steps above.
3. Approve C13.04's cumulative routine and current two-pass API-doc obligations.
   This does not grant checkpoint/commit authority in advance.

An explicit plan-review request comes before any PLAN session. An exact-plan
approval comes before implementation; each later request selects only one
step. If the analytical feasibility limits in Section 4.3 warrant more planning work,
resolve them without weakening these proposed mathematical contracts.
