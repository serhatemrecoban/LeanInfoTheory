# Chunk 25 — finite binary testing and the TV decision problem

**Status: maintained source handoff; completion follows the private record.**
C25.01–C25.05 have supported closure records and reconciled independent reviews.
C25.06 requires exact-source clean validation, fresh cumulative independent
review, substantive reconciliation and supported private closure. This document
states the delivered interface and completion requirements; it predicts no PASS,
review verdict or closure. Actual evidence is retained under
`.lit-review/setup/c25-06-20261106/`. Its `completion.json` is the maintained
pointer to the actual supported closure, final source, original report,
reconciliation and applicable clean result; until that source-matching record
exists, completion is not established. The next chunk remains unselected.

The [approved plan](../plans/release-3-chunk-25.md), revision 2, governs the
endpoint. The [implementation notes](../plans/release-3-chunk-25-notes.md)
retain source adaptations, earlier checks and original review dispositions.
The [revision 3 programme map](../plans/release-3-chunk-map.md) is advisory.

## Delivered interface and import boundary

Import `LeanInfoTheory.Probability.BinaryTesting`. Its only direct import is
`LeanInfoTheory.Probability.TotalVariation`. The full `LeanInfoTheory.Shannon`
umbrella exposes the interface; the lightweight `LeanInfoTheory` root retains
its two direct imports, five-module closure and 92 exports and excludes every
testing declaration. The 17 testing declarations bring the supported surface
to 828 declarations in 58 modules. No new global instance or simp rule is added.
The [permanent consumers](../../LeanInfoTheory/Examples/BinaryTesting.lean)
use the focused import, stay private, and join the development-only Examples
aggregate.

`PMF.BinaryTest X` abbreviates `X → Set.Icc (0 : ℝ) 1`. A value of one rejects
the null law `P0`; zero accepts it. The two decisions are binary even when the
observation alphabet is larger. Construction needs no finiteness assumption.
Evaluation needs `[Fintype X]`; no support positivity, measurable space,
inhabitance or caller-supplied event decidability is required.

Here are the public signatures in namespace `PMF.BinaryTest`, with
`{X : Type u}`. The first three require no `Fintype` instance:

```lean
ofEvent (s : Set X) : PMF.BinaryTest X
ofEvent_apply (s : Set X) (x : X) :
  (ofEvent s x : ℝ) = if x ∈ s then 1 else 0
tvTest (P0 P1 : PMF X) : PMF.BinaryTest X
```

The remaining signatures require `[Fintype X]`:

```lean
rejectProb (f : PMF.BinaryTest X) (P : PMF X) : ℝ
rejectProb_mem_Icc (f : PMF.BinaryTest X) (P : PMF X) :
  rejectProb f P ∈ Set.Icc (0 : ℝ) 1
size (f : PMF.BinaryTest X) (P0 : PMF X) : ℝ
power (f : PMF.BinaryTest X) (P1 : PMF X) : ℝ
typeIIError (f : PMF.BinaryTest X) (P1 : PMF X) : ℝ
rejectProb_ofEvent (s : Set X) (P : PMF X) :
  rejectProb (ofEvent s) P = (P.toOuterMeasure s).toReal
typeIIError_ofEvent (s : Set X) (P1 : PMF X) :
  typeIIError (ofEvent s) P1 = (P1.toOuterMeasure sᶜ).toReal
errorSum (f : PMF.BinaryTest X) (P0 P1 : PMF X) : ℝ
one_sub_totalVariation_le_errorSum (f : PMF.BinaryTest X) (P0 P1 : PMF X) :
  1 - PMF.totalVariation P0 P1 ≤ errorSum f P0 P1
errorSum_tvTest (P0 P1 : PMF X) :
  errorSum (tvTest P0 P1) P0 P1 = 1 - PMF.totalVariation P0 P1
isLeast_errorSum (P0 P1 : PMF X) :
  IsLeast (Set.range (fun f : PMF.BinaryTest X => errorSum f P0 P1))
    (1 - PMF.totalVariation P0 P1)
equalPriorError (f : PMF.BinaryTest X) (P0 P1 : PMF X) : ℝ
isLeast_equalPriorError (P0 P1 : PMF X) :
  IsLeast (Set.range (fun f : PMF.BinaryTest X => equalPriorError f P0 P1))
    ((1 - PMF.totalVariation P0 P1) / 2)
```

These are signature excerpts, not a standalone Lean file. `ofEvent_apply`
uses local classical decidability. See the
[owner](../../LeanInfoTheory/Probability/BinaryTesting.lean) for the exact
declaration forms and proofs. `rejectProb f P = ∑ x, (P x).toReal * (f x : ℝ)`;
`size` and `power` evaluate it under their respective laws. `typeIIError` is
`1 - power`; `errorSum` adds size and miss, and `equalPriorError` divides that
sum by two. Both `IsLeast` results quantify over **all randomized tests** and
include attainment, not merely an infimum or a deterministic-test comparison.
Their witness is `tvTest P0 P1 = ofEvent {x | P0 x < P1 x}`.

## Source adaptation and reusable proof anchors

PW24 §7.3, Theorem 7.7(a), (7.17)–(7.19), printed 122–123 / PDF 147–148,
supplies the randomized decision problem and its TV optimum. Section 14.1,
Table 14.1/(14.1), printed 276–277 / PDF 301–302, supplies the conditional
rejection convention and prior weighting. The registered local edition has
SHA-256 `c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
The [reference register](../references.md#pw24-polyanskiy-and-wu-newer-draft)
and step notes retain the actual earlier text inspections, their actors and
page limits. This handoff reuses them; its preparation claims no new PDF
inspection. The book's null-acceptance parameter is one minus C26's size level.

The lower bound specializes released
`PMF.abs_sum_sub_le_totalVariation_of_mem_Icc` to `[0,1]`. Attainment
complements the weak-dominance event in
`PMF.totalVariation_eq_toOuterMeasure_sub`; finite atom masses let
`ENNReal.toReal_le_toReal` and `PMF.apply_ne_top` identify that complement
with strict rejection, including ties. The event identities supply the two
error probabilities. `PMF.sum_toReal`, `PMF.toReal_nonneg` and
`PMF.toOuterMeasure_toReal_eq_sum` support evaluation. No second
pointwise-minimum proof is needed. The factor of two uses division of the
same attained sum by the positive number two.

Pinned mathlib is `v4.33.1`, commit
`0df444a360eaa60ab8c11dca51a86af692955474`. Its
`ProbabilityTheory.avgRisk`, `bayesRisk` and `minimaxRisk` use measurable
decision kernels and `ℝ≥0∞` risk. C25 uses a finite real scalar interface and
does not import the risk module or claim a formal bridge to those definitions.

## Permanent consumers and the C26 handoff

The examples evaluate every operating characteristic, not just the optimum:

| Laws/test | Size | Power | Miss | Error sum | Equal-prior error |
| --- | --- | --- | --- | --- | --- |
| Equal laws, any test | s | s | 1 − s | 1 | 1/2 |
| Distinct pure laws on `Fin 3`, strict test | 0 | 1 | 0 | 0 | 0 |
| (1/2,1/2,0) versus (0,1/2,1/2), strict test | 0 | 1/2 | 1/2 | 1/2 | 1/4 |
| Same sparse laws, rejection weights (0,1/2,1) | 1/4 | 3/4 | 1/4 | 1/2 | 1/4 |
| (1/2,1/2) versus (3/4,1/4), strict test (1,0) | 1/2 | 3/4 | 1/4 | 3/4 | 3/8 |
| Same two-point laws, test (1/2,0) | 1/4 | 3/8 | 5/8 | 7/8 | 7/16 |

The pure-law example rejects the alternative-only atom and accepts a
common-null atom. The sparse strict event is `{2}`; randomizing at the tied
middle atom preserves optimality. The last two rows have TV `1/4`. Their
coordinates are `(false, true)` in the Boolean fixture; the strict test
rejects an atom with positive mass under both laws.

For any `γ : Set.Icc (0 : ℝ) 1`, private `gammaTest γ` has weights `(γ,0)`.
Private `gamma_characteristics` proves size `γ/2`, power `3*γ/4`, miss
`1 - 3*γ/4`, sum `1 - γ/4` and the half-sum average. `gamma_one_eq_tvTest`
identifies γ = 1 with the public witness; `gamma_strict_characteristics`
and `gamma_half_characteristics` give both table rows.
`gamma_half_size_cap_and_cost` checks the size cap `1/4` and additional
error `1/8`. These are private examples to adapt, not importable public
helpers. The smaller-size row carries no prescribed-level optimality claim.

C26 should consume `size f P0 ≤ a` and `power f P1` directly. Its target
includes a constructed threshold test `fStar` satisfying

```lean
size fStar P0 = a ∧
  ∀ g : PMF.BinaryTest X,
    size g P0 ≤ a → power g P1 ≤ power fStar P1
```

for each admissible level, with threshold structure, boundary randomization
and endpoint cases. C25's threshold-one strict test accepts ties; it need not
fill a prescribed size. Alternative-only atoms can be rejected at zero null
size cost. Common-null choices affect neither error. C26 must preserve these
cases while selecting randomization to attain equality in size. No ratio at
a zero null atom is supplied or required by C25.

## C27 event convention and deferred work

C27 can use `ofEvent A` with independent law `Q` as null and joint law `J`
as alternative: size is `(Q.toOuterMeasure A).toReal`, power is
`(J.toOuterMeasure A).toReal`, and miss is
`(J.toOuterMeasure Aᶜ).toReal`. The intended global threshold event is
`{z | J z > exp t * Q z}`, interpreted with consistently typed masses; for
real finite masses use `(J z).toReal > Real.exp t * (Q z).toReal`.
It is generally different from `tvTest Q J`. Agreement with a log-threshold
formula belongs on joint support: totalized `log 0` must not admit impossible
pairs. C27 does not need C26 merely for testing terminology.

| Deferred item | Owner and trigger |
| --- | --- |
| Prescribed-level Neyman–Pearson theorem, threshold and boundary randomization | C26, after its own plan and step selection |
| Supported information-density identity and global threshold bridge | C27, when constructing its joint-versus-independent event |
| Measurable-kernel decision-risk bridge | A future concrete consumer needing pinned mathlib risk interoperability; no automatic public addition |
| Generic threshold constructor or Boolean-channel equivalence | Add only for an approved consumer that needs that interface |

## Validation and closure boundary

The cumulative source/evidence matrix in the implementation notes covers all
eleven approved criteria. The native C25.06 report has three top-level rows;
its fresh evidence must explicitly assess the eight preceding obligations too.
Earlier successful reports remain source-bound historical evidence and do not
replace this cumulative review. C25.05's malformed first dispatch and the
separate repair qualification retain their original status and attribution.

C25.06's fresh dirty-checkout results are recorded under
`.lit-review/setup/c25-06-20261106/checks/`. They do not constitute the full
clean gate. That gate is `python -X utf8 -B scripts/validate_development.py all`
on the separately approved exact candidate, with clean state before and after,
the default and maintained builds, documentation, current imports/simp/trust
and independent retained comparisons of all 601 v0.1.0 and 811 v0.2.0
declarations. Frozen artifacts, primary HEAD/index and unrelated local work
must remain preserved. Any candidate amendment requires a complete rerun.

The lead approved the exact isolated checkpoint and bounded six-document
status/review amendments. Checkpoint identities and clean-run records, when
produced, are retained under
`.lit-review/setup/c25-06-20261106/approved-checkpoint/`. A result applies only
to its recorded source. After cumulative review, every original assessment must
be reconciled and final source/configuration/dependency applicability checked.
If the source and documents remain unchanged, applicable full-clean evidence may
be reused; every candidate amendment, including post-review prose, requires a
complete clean-suite rerun. Any reviewer criterion gap still needs satisfactory
source-bound reassessment. The supported closure and actual report,
reconciliation, clean result and final applicability references belong in
`.lit-review/setup/c25-06-20261106/completion.json` once established. Their
absence supplies no completion claim. No hosted CI run, API-doc generation,
release, push, publication or C26 execution is claimed.
