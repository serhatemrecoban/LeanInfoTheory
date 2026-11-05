# Chunk 13 maintained handoff: Pinsker and quantitative independence

## Status and authority

C13.01--C13.03 and their independent review processes have actual
`SUPERVISED_STEP_COMPLETE` records. The parent verified the complete C13.03
final inventory before selecting C13.04. Earlier candidate wording in the
[implementation notes](../plans/post-release-chunk-13-notes.md) records the
state before each closure; it does not reopen completed steps. The
[approved revision-2 plan](../plans/post-release-chunk-13.md), especially
Sections 3, 5 and 6, controls the contracts and cumulative qualification.

C13.04 is selected for cumulative validation, canonical-document reconciliation
and this handoff. The lead explicitly authorized the 25-file local checkpoint,
a separate clean validation checkout and necessary C13.04-only amendments.
Initial checkpoint `17fb736a00448ecdd0aa824fd1928713bf716f01` passed the
complete routine suite in 1975.056 seconds. The actual two-pass current
file-mode API-documentation gate and all-five-declaration inspection also passed.
Final amended-candidate routine validation, exact API-doc applicability,
cumulative review, original-report reconciliation and closure remain governed
by the source-bound C13.04 records.

The explicit checkpoint authority is recorded at
`.lit-review/setup/c13-04-checkpoint-authority-20261003.json`.
The source-bound C13.04 records determine final validation, original-report
reconciliation, source applicability, final capture and closure. No push,
publication or later-chunk authority is supplied by this handoff.
Preserve the unrelated `docs/next-website-tasks.md` bytes, staging state and
location, and exclude it from any C13 checkpoint. Finish captured documentation
before final F; the private completion record and final user report carry the
actual closure reference. Do not edit captured documents afterwards merely to
insert that reference.

## Delivered public mathematical interface

C13 adds exactly five public theorems, all in `LeanInfoTheory.Shannon`, owned
by [`Shannon.SemanticBridge.Pinsker`](../../LeanInfoTheory/Shannon/SemanticBridge/Pinsker.lean).
It adds no public definition, binary constructor, alias, instance or simp
attribute. Entropy, mutual information and KL use nats; total variation uses
the existing real half-L1 probability normalization.

The exact contracts, with independent universes `u` and `v`, are:

```lean
theorem ofReal_two_mul_totalVariation_sq_le_klDiv
    {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) :
    ENNReal.ofReal (2 * PMF.totalVariation p q ^ 2) ≤
      InformationTheory.klDiv p.toMeasure q.toMeasure

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

The canonical `ENNReal` statement includes singular support and infinite KL.
It requires no support inclusion, absolute continuity, full support, positive
atoms, nonzero TV or explicit `Nonempty` assumption.

The supplied measurable structure must have measurable singletons. On a finite
type this makes every set measurable. An arbitrary indiscrete structure could
identify distinct PMF measures, giving KL zero while PMF TV remains positive.
The two MI statements instead choose the discrete measurable structure on the
product locally; no measurable-space premise is exposed.

`Fintype` follows the existing finite-sum TV API. A consumer with `Finite`
may install `Fintype.ofFinite` locally. The support/finite-KL equivalence and
the owner's private joint finite-KL helper need only `Finite`. Supplied PMFs
already rule out empty alphabets, so no fallback inhabitant or global instance
is introduced.

## Proof route, support and endpoint decisions

### Binary reduction and endpoint analysis

The proof uses C10's non-strict attaining event
`A = {a | (q a).toReal ≤ (p a).toReal}` and its Bool indicator.
`PMF.totalVariation_eq_toOuterMeasure_sub`,
`PMF.abs_toOuterMeasure_sub_le_totalVariation` and
`PMF.totalVariation_map_le` prove exact TV preservation. The existing
`klDiv_map_le` supplies the KL inequality after mapping. This route preserves
TV; it only requires data processing for KL.

For arbitrary Bool laws, the proof first separates `KL = ⊤`. In the finite
branch, `klDiv_pmf_ne_top_iff_support_subset` yields actual support inclusion.
If either reference atom is zero, inclusion forces equality of the two laws,
so both TV and KL vanish. These branches precede logarithm division.

For interior reference parameter `q`, the private scalar function subtracts
`2 * (p-q)^2` from binary KL written using `Real.binEntropy`.
It is continuous on the closed interval `[0,1]`. Its second derivative on
the interior is

```text
1 / (1-p) + 1 / p - 4 = (2*p-1)^2 / (p*(1-p)) ≥ 0.
```

Closed-interval convexity and the zero derivative at `p=q` give the minimum
zero. This covers both parameter orders, equality and both numerator endpoints.
The private weighted-log identity treats a zero numerator separately before
using `Real.log_div`.

### Guarded Real conversion

The Real squared theorem first proves `KL ≠ ⊤` from
`p.support ⊆ q.support`, then applies
`ENNReal.ofReal_le_iff_le_toReal` to the canonical theorem.
The square-root theorem uses `Real.le_sqrt_of_sq_le`; that lemma supplies
the required sign reasoning. Support inclusion permits common zero atoms and
a reference law without full support.

A supplied non-top guard is converted to support inclusion by the existing
equivalence. A finite `ENNReal` KL budget also establishes non-top KL before
any Real conversion. These are private consumer conveniences. No duplicate
public finiteness or budget wrapper is added.

Finite alphabets alone do not guarantee finite KL. Distinct pure Bool laws
have TV one, KL top and `KL.toReal = 0`; both unguarded Real bounds are false.
The permanent consumers prove those negations as actual Lean propositions.

### Quantitative independence

For a joint law `p`, the reference is exactly
`indepProd (fstMarginal p) (sndMarginal p)`.
The private helper uses
`joint_toMeasure_absolutelyContinuous_indepProd_marginals`,
`toMeasure_absolutelyContinuous_iff_support_subset` and
`klDiv_pmf_ne_top_iff_support_subset` to establish finite KL.
Each public MI proof then uses the guarded Pinsker theorem and
`mutualInfo_eq_toReal_klDiv_joint_indepProd`.
The MI-as-KL `toReal` identity alone is not used as evidence of finiteness.

Null marginal rows and columns cause no problem: positive joint mass forces
both marginal masses positive. The proof does not replace this actual support
argument with a full-support hypothesis.

## Useful imports, ownership and current inventory

For the five contracts, import:

```lean
import LeanInfoTheory.Shannon.SemanticBridge.Pinsker
```

The owner's exact direct imports are:

```lean
import LeanInfoTheory.Probability.TotalVariation
import LeanInfoTheory.Shannon.SemanticBridge.DataProcessing
import Mathlib.Analysis.SpecialFunctions.BinaryEntropy
import Mathlib.Analysis.Convex.Deriv
import Mathlib.Analysis.Real.Sqrt
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.FunProp
```

`DataProcessing` already reaches the required KL, Product and Independence
APIs. Pinsker has no coupling/gluing dependency. The explicit square-root
import records its actual analytic dependency even though it is also available
transitively. No broad Mathlib or tactic umbrella was added.

The import-only `Shannon.SemanticBridge` aggregate imports Pinsker, so
`LeanInfoTheory.Shannon` reaches it. The root `LeanInfoTheory` keeps its two
direct imports, `Probability.Finite` and `InformationMeasures`, and its
five-module local closure. Low-level TV, channel and coupling owners gain
no heavy dependency. Independence does not import Pinsker.

Both new example owners import only the focused Pinsker owner:

- [`Examples.Pinsker`](../../LeanInfoTheory/Examples/Pinsker.lean)
- [`Examples.QuantitativeIndependence`](../../LeanInfoTheory/Examples/QuantitativeIndependence.lean)

They join `LeanInfoTheory.Examples` and remain outside both mathematical
umbrellas. All their new constructors, helpers and theorems are private;
measurable instances are local. The public owner likewise keeps all scalar,
binary and support/conversion helpers private.

The [current manifest](../current-public-api.json) records 647 supported and
documented declarations in 35 supported owners: 578 theorems, 59 definitions,
9 abbreviations and one instance. There are 94 reviewed simp declarations,
92 root exports, 58 local modules and 23 non-stable modules. Generated source
references record 124 local edges and 762 indexed declarations, 761 documented.
The root still has five local modules; the other 53 require separate imports.
C13 adds five public theorems and one supported owner relative to C12, plus
the two non-stable example owners. Counts describe coverage, not proof or
review completion.

The historical v0.1.0 release remains at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, with 601 declarations in 31
supported owners. Its frozen manifest and versioned documentation are separate
from the current surface. Lean remains `v4.33.1`; mathlib remains
`0df444a360eaa60ab8c11dca51a86af692955474`.
No release identity or dependency pin changes are part of C13.

## Permanent consumers and normalization checks

### Pinsker consumers

| Consumer family in `Examples.Pinsker` | Maintained mathematical coverage |
| --- | --- |
| Generic and endpoints | `finite_alphabet` applies the canonical theorem. Equal laws, pure laws and subsingletons consume the applicable canonical/guarded forms. `empty_alphabet` derives impossibility from PMF support. |
| Bool family | `boolean_both_orders`, equality/ties, numerator parameters zero and one with interior reference, and reference parameters zero and one with matching and singular numerators. The private family uses `PMF.ofFintype`, without a deprecated Bernoulli constructor. |
| Positive tied `Fin 3` | `p=(1/2,1/4,1/4)`, `q=(1/4,1/4,1/2)`; all atoms positive, tie at coordinate one, attaining event exactly `{0,1}`, TV `1/4`, real KL `(1/4)*log 2`, canonical KL `ofReal ((1/4)*log 2)`. |
| Actual Boolean reduction | The preceding event's pushforwards have true masses `3/4` and `1/2`. `positive_indicator_preserves_distance` proves exact TV preservation; `positive_binary_reduction` consumes canonical Pinsker and KL map DPI. `positive_canonical` uses the original pair's exact values. |
| Sparse finite pair | `p=(1,0,0)`, `q=(1/2,1/2,0)` in `Fin 3`, with common zero at two. Explicit support inclusion and finite KL precede TV `1/2`, KL `ofReal (log 2)` and real KL `log 2`. Both supplied support and supplied non-top guard paths are used. |
| KL event budget | `event_discrepancy_le_sqrt_of_klDiv_le` derives event discrepancy at most `sqrt(ε/2)` from `0≤ε` and `KL≤ofReal ε`, proving finiteness first. The sparse pair specializes this to event `{0}`, exact discrepancy `1/2`, and budget `log 2`. |
| Singular regression | Distinct pure Bool laws have TV one, KL top and real KL zero. `singular_pure_canonical` consumes the unconditional theorem; `singular_pure_real_bound_false` and `singular_pure_sqrt_bound_false` prove the two unguarded forms false. |

The exact approved private KL-event-budget contract retains `[Fintype α]`.
Its enumeration appears only in the proof, so a documented, single-declaration
`linter.unusedFintypeInType` suppression preserves that contract. The global
linter remains enabled.

### Quantitative-independence consumers

Write `Q = indepProd (fstMarginal p) (sndMarginal p)` in this paragraph.
From `mutualInfo p ≤ ε`, `mutualInfo_budget` derives `0 ≤ ε` using
`mutualInfo_nonneg`, and TV at most `sqrt(ε/2)`. The derived consumers
therefore add no nonnegativity premise on ε.

| Consumer in `Examples.QuantitativeIndependence` | Bound or regression |
| --- | --- |
| `quantitative_bounds`, `mutualInfo_budget` | Both public bounds and the supplied MI-budget form. |
| `event_of_mutualInfo_budget` | Absolute event discrepancy under p and Q at most `sqrt(ε/2)`, using C10's event estimate. |
| `unit_interval_test_of_mutualInfo_budget` | For `0≤f z≤1`, the absolute difference of finite expectations is at most `sqrt(ε/2)`, using `PMF.abs_sum_sub_le_totalVariation_of_mem_Icc`. |
| `signed_test_of_mutualInfo_budget` | For `abs (f z) ≤ 1`, the same difference is at most `2 * sqrt(ε/2)`, using `PMF.abs_sum_sub_le_mul_totalVariation` at radius one. The factor two is explicit. |
| `arbitrary_source_bounds`, `arbitrary_source_budget` | For arbitrary `r : PMF Ω`, apply the bounds to `r.map (fun ω => (X ω,Y ω))`; rewrite the actual marginals to `r.map X`, `r.map Y` and MI to `mutualInfoOf r X Y`. Only the two output alphabets are finite; Ω has no finite or measurable-space premise. |
| Endpoints | Independent product, zero MI and singleton coordinates give zero distance. The singleton case also consumes the squared public bound. Either empty coordinate makes a joint PMF impossible. |

The concrete dependent law places mass `1/2` at `(0,false)` and
`(1,true)` in `Fin 3 × Bool`, and zero elsewhere. Its actual first
marginal is `(1/2,1/2,0)`; its second is the fair bit. Their independent
product has mass `1/4` at all four atoms in rows zero and one, and zero
throughout row two.

The consumer proves these joint, marginal and product masses explicitly,
actual support inclusion and finite joint-to-product KL, TV `1/2`,
`KL.toReal = log 2`, `KL = ofReal (log 2)` and `mutualInfo = log 2`.
It proves dependence from the positive TV and applies both public MI bounds
to obtain `1/2 ≤ log 2` and `1/2 ≤ sqrt(log 2 / 2)`.
The zero reference row demonstrates why full support is unnecessary.

## Mathematical source and adaptations

The source is PW24: Yury Polyanskiy and Yihong Wu, *Information Theory: From
Coding to Learning*, August 16, 2024 prepublication draft. The local
`Polyanskiy-Wu Newer.pdf` has 730 PDF pages and SHA-256
`c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
The [reference register](../references.md#pw24-polyanskiy-and-wu-newer-draft)
links the author-hosted PDF; that mutable URL does not identify the inspected
edition by itself.

The selected slice is Section 7.4, Theorem 7.10, equation (7.27), printed
pages 126--127 / PDF pages 151--152. The approved planning record documents
extraction and visual inspection of both pages. The source's logarithm-base
factor `2 log e` becomes exactly two with `Real.log`.
C10's half-L1 TV and test normalization comes from Section 7.3,
Theorem 7.7(a), equation (7.18), printed pages 122--123 / PDF pages 147--148;
see the [C10 handoff](chunk-10.md#mathematical-sources-and-adaptations).

The formal proof replaces the supremum-over-events step with C10's explicit
attaining event. It keeps KL in `ENNReal`, supplies singular/reference/numerator
endpoint cases, and proves the binary second-derivative bound through
closed-interval convexity instead of an improper-integral Taylor formula.
The guarded consequences and MI application are derived uses of this theorem
and existing bridges; no separately numbered textbook theorem is claimed.

No external formalization repository was consulted. No reference PDF or
substantial textbook prose was added to Git. The remaining f-divergence,
joint-range and refined/reverse Pinsker material in Section 7.4 is outside
this chunk.

## Earlier completion and validation evidence

C13.01 and C13.02 closure identities are recorded in the next step's
[public implementation notes](../plans/post-release-chunk-13-notes.md).
The parent verified C13.03's completion record at C13.04 intake:

| Step | Recorded private closure |
| --- | --- |
| C13.01 | `0bd0f6d203cde547d593721e70672471c1c644f96fdf1d1043ca451d73f4cfda` |
| C13.02 | `31dc66de21bc880aa46603992511519cc1a128a90670bc06830185361a961808` |
| C13.03 | `9a6105e02101b696ff9c81aed49be4bc45d6f8bb15f2fb7bce59ee9cea2a5823` |

The parent verified `.lit-review/setup/c13-03-completion-20261003.json` and
matched the full final inventory
`452f69c4e97921cb9569aedf20f72b02cafbc2f8d7561903f673c2df27c1d472`.
It also verified all ten accepted earlier criterion assessments and their
original-report reconciliations. C13.01's accepted original is
`.lit-review/setup/c13-01-review-report-original-format-retry-20261003.json`;
the generic first-attempt filename is superseded and must not be treated as
the accepted report. These references report the parent's prerequisite check;
this handoff did not independently reopen the private records.

The following validation evidence summarizes the original public notes; it
does not claim a new execution of those checks.

| Step | Successful qualification and retained evidence |
| --- | --- |
| C13.01 | Focused owner, consumers, aggregates and root; strict compiled signature/axioms; static checks; trust in 1185.629 seconds. Trust checked 601 retained signatures, 35 supported import closures, 643 public declarations, 94 simp declarations, 92 root exports and 1,819 compiled local constants across 57 modules. Original command/streams: `.lit-review/setup/c13-01-trust-20261003/`. |
| C13.02 | Strict owner check; corrected six-target maintained focused build in 23.800 seconds; static checks; trust in 1169.603 seconds. Trust checked 601 retained signatures, 35 supported import closures, 645 public declarations, the unchanged simp/root counts and 1,857 compiled local constants across 57 modules. Original streams: `.lit-review/setup/c13-02-trust-20261003/`. |
| C13.03 | Corrected strict owner check; seven-target maintained focused build in 25.208 seconds; static checks; trust in 953.423 seconds. Trust checked 601 retained signatures, 35 supported import closures, 647 public declarations, the unchanged simp/root counts and 1,906 compiled local constants across 58 modules. Original streams: `.lit-review/setup/c13-03-trust-20261003/`. The separate strict stdin check confirmed all five exact signatures and axioms. |

All three trust checks reported only `propext`, `Classical.choice` and
`Quot.sound`. C13.03 recorded matching compiled-input, configuration and
generated-inventory hashes before and after trust. These are incremental
dirty-tree checks with their own source scope. They are not the clean routine
suite or the signature-bearing API-documentation milestone.

Original failed attempts remain distinct from successful corrected-source
checks. C13.01 needed explicit finite-coordinate reductions and then a
project-linter line wrap. Compiler-generated recovery diagnostics after failed
goals did not denote source proof placeholders. C13.02's first maintained
consumer run failed on the local Fintype linter described above; an earlier
bounded availability-only import probe was terminated without diagnostics and
is inconclusive. C13.03's owner first hit four `letI` style warnings, repaired
with standard `let`/`have`; its consumer needed explicit definitional
reductions at two `Fin 3` coordinates. The original failures are retained;
they are not reported as passes.

Maintained focused validation uses `lake --wfail build`. Historical
`-KwarningAsError=true` is ineffective and must not be reused. Independent
direct Lean checks and maintained Lake checks have different linter scope;
the latter caught C13.01's line-length warning.

### Coverage of the ten earlier criteria

This matrix points to the maintained evidence for cumulative review; it does
not replace the fresh reviewer's criterion assessments.

| Criterion | Concrete evidence to reassess |
| --- | --- |
| C13.01-CANONICAL | Exact unconditional ENNReal signature, private binary proof, `finite_alphabet`, compiled signature/axiom and trust checks. |
| C13.01-BINARY | Bool orders/equality/endpoints/singular cases, positive tied `Fin 3`, exact event/TV/KL and Boolean true masses, exact TV preservation and actual DPI/canonical applications. |
| C13.01-BOUNDARY | Seven focused direct imports, private helpers, semantic aggregate, current policy/inventory, preserved light root, no coupling/gluing dependency. |
| C13.02-GUARDS | Exact support-guarded Real/sqrt forms, finiteness before conversion, supplied support/non-top consumers and sparse reference. |
| C13.02-CONSUMERS | Sparse exact TV/KL, common zero, exact KL event budget and `{0}` specialization, equal/pure/subsingleton/impossible-empty endpoints. |
| C13.02-SINGULAR | Distinct pure Bool TV one, KL top, real KL zero, canonical application and actual negations of both unguarded Real bounds. |
| C13.03-INDEPENDENCE | Exact own-marginal-product signatures, local discrete measurability, actual joint finite-KL proof and guarded bridge composition. |
| C13.03-USE | MI-budget TV/event/[0,1]/signed bounds with constants one/two, derived ε nonnegativity and arbitrary-source pushforward/`mutualInfoOf` consumers. |
| C13.03-SPARSE | Independent/zero-MI/singleton/empty endpoints; exact sparse diagonal masses/marginals/product, MI/real/canonical KL, finite KL, zero row and quantitative applications. |
| C13.03-API | All five theorems used permanently; names/docstrings, focused imports, private consumer/helper boundary, no new simp attributes, current and retained inventories. |

## C13.04 preparation evidence and remaining qualification

The following duties distinguish completed preparation from remaining qualification:

| C13.04 criterion | Remaining evidence |
| --- | --- |
| VALIDATION | Focused consumers, actual two-pass API docs with five-declaration inspection and v2 attestation, and the initial authorized checkpoint's clean complete routine suite passed. Final amended-candidate routine validation and exact API-doc applicability remain governed by source-bound records. Repeat invalidated gates after amendments. |
| READINESS | Complete canonical/source/generated edits; durable reconciliation of every earlier original review report; exact cumulative review source and criterion matrix; no material unresolved issue; fresh independent assessment of all 13 criteria and explicit reconciliation of every finding and assessment. |
| HANDOFF | Final evidence and limitations in this handoff, canonical links, remaining-work dispositions and C14 boundary, with exact review-to-final applicability, final capture and actual private closure. |

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
These preparation checks reuse incremental caches. The authorized initial
checkpoint's later clean qualification is recorded below; final amended-source
validation and cumulative review remain subject to their own records.

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

Current API-doc output belongs under `docbuild/.lake/build/doc/`.
It must not replace or publish the frozen `/docs/v0.1.0/` route. Both actual
API-doc passes and concrete output inspection are required; source-body and
docstring changes can invalidate earlier evidence even when names and counts
match. C10/C12's stale aggregate-marker history warrants inspection but does
not authorize preemptive cache deletion. Reproduce any failure, retain its
diagnostics, and use only a bounded repair before rerunning the gate.

A favorable review report alone establishes neither receipt/reconciliation
nor private closure. Corrections require applicable revalidation and a new
satisfactory assessment for any criterion gap. Final records must establish
exact review-to-final applicability after all captured edits are complete.

## Deferred work, owners and triggers

| Deferred work | Owner and trigger |
| --- | --- |
| Public finite-KL, Bernoulli or budget wrappers | KL/API maintainer, after repeated independent consumers show that existing guards or private helpers are insufficient. |
| Names or aliases | API maintainer under Note 14, after concrete search/usage friction recorded and deduplicated in downstream API feedback. Existing names remain stable. |
| Doc-gen cache/tooling | Documentation maintainer under Note 9: C13 reproduced the aggregate-marker failure and retained exact diagnostics/repair. Investigate a durable cache-key correction in separately scoped tooling work; C13 keeps the pinned tool and bounded repair. |
| Continuity/topology | C14/C15 owners, after their own approved plans and explicit step requests. |
| Reverse/refined Pinsker, equality/optimality classification, joint ranges, general divergences or stability theory | A separately approved theorem phase with a concrete consumer and exact constants/support contract. |
| Coding or application certificates | The relevant later-phase/application owner, after a separate consumer and scope decision. |
| Release/publication | Project lead under separate explicit authority; retain dependency pins and historical release identity. |

Standing validation, simp, chain-rule and module-boundary duties remain
governed by their recorded triggers. This handoff does not close unrelated
future-work notes merely because C13 used adjacent APIs.

## C14 boundary

C14 does not require Pinsker. Its planned finite entropy continuity route uses
maximal coupling and Fano. For alphabet size `m ≥ 2` and exact
`δ = TV(p,q)`, the intended bound is
`|H(p)-H(q)| ≤ h(δ) + δ * log(m-1)`, with singleton cases separate.

A usable bound from only `TV(p,q) ≤ ε` must account for the modulus'
monotonicity: use the expression on `[0,1-1/m]` and `log m` above that
threshold. Substituting an upper budget into the exact-distance expression
without this range reasoning is not justified.

Conditional-entropy and MI continuity may then use joint/marginal entropy
bounds and TV contraction, with explicit finite alphabet sizes. Close joint
laws do not imply pointwise continuity of every conditional PMF at null
fibers. Sharper conditioning-alphabet-independent constants or CMI convenience
forms need concrete consumer pressure and a separate scope decision. C15's
finite-simplex topology remains later work; C13 introduces no metric or
topology instance.

The [chunk map](../plans/post-release-chunk-map.md) and a separately approved
C14 plan control any continuation. No C14 implementation starts automatically.

