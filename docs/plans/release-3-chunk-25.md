# C25 — Finite binary hypothesis testing and total variation

<!-- lit-review-status:start -->
**Plan status:** Approved, revision 2. The lead accepted the revised plan and explicitly requested C25.01 with its review process on 6 November 2026 after qualification of the remaining prerequisite. C25.01 is complete; the lead conditionally selected C25.02 with review, and its predecessor closure and exact source applicability passed on 6 November 2026. C25.02 is complete; the lead conditionally selected C25.03 with review, and its predecessor closure and exact source applicability passed on 6 November 2026. C25.03 is complete; the lead conditionally selected C25.04 with review, and its predecessor closure and exact source applicability passed on 6 November 2026. C25.04 is complete; the lead conditionally selected C25.05 with review, and its predecessor closure and exact source applicability passed on 6 November 2026. C25.05 is complete. A distinct later conditional request selected only C25.06 after its predecessor closure, successful review and exact final source were verified on 6 November 2026. Revision 1's formal plan review remains historical; no new formal PLAN review of revision 2 is claimed.

The C25–C40 workflow bootstrap passed independent verification, and this chat has bound its persistent C25 reviewer. The completion record is `.lit-review/setup/r3-workflow-bootstrap-20261105/completion.json`. The revision 1 review and its dispositions are retained in `.lit-review/setup/c25-plan-r1-20261105/parent-reconciliation.json`.

Development validation for public API growth passed independent examination on 2026-11-06. The clean approved-growth fixture passed the complete local CI sequence, and the primary checkout passed static and compiled 601/811 retention checks. Matched approval and signature-mutation controls passed. Evidence and limitations are retained in `.lit-review/setup/r3-growth-qualification-20261106/completion.json`. Use `scripts/validate_development.py` for development gates. C25.01's implementation and independent review are reconciled; see the [step notes](release-3-chunk-25-notes.md). Completion is determined by the supported private workflow record and `.lit-review/setup/c25-01-20261106/completion.json`. C25.02 implementation and independent review are reconciled; its completion is determined by the supported private workflow record and `.lit-review/setup/c25-02-20261106/completion.json`. C25.03 implementation and independent review are reconciled; its completion is determined by the supported private workflow record and `.lit-review/setup/c25-03-20261106/completion.json`. C25.04 implementation and independent review are reconciled; its completion is determined by the supported private workflow record and `.lit-review/setup/c25-04-20261106/completion.json`. C25.05 implementation and fresh independent review are reconciled after the separately approved and independently qualified narrow workflow repair. Its completion is determined by the supported private workflow record and `.lit-review/setup/c25-05-20261106/completion.json`. C25.06's maintained C26/C27 handoff is prepared for cumulative qualification. Preparation-stage dirty-checkout focused/default builds, whole-project trust with both retained comparisons, documentation and subsequent static checks passed on their recorded inputs. The lead approved the exact isolated checkpoint and bounded six-document status/review amendments. Clean-run records, when produced, are retained under `.lit-review/setup/c25-06-20261106/approved-checkpoint/`; a passing result applies only to its recorded source. C25.06 completion is determined by the supported private closure, with `.lit-review/setup/c25-06-20261106/completion.json` identifying that closure, the final source, original cumulative report, substantive reconciliation and applicable clean result. Until such a supported source-matching record exists, completion is not established. This text predicts no validation or review outcome and selects no C26 work.
<!-- lit-review-status:end -->

## Decision problem

Let P₀ and P₁ be PMFs on the same finite alphabet X. A test assigns a probability of rejecting P₀ to each observation. Binary refers to the two decisions. The required result is an attained minimum over **every** randomized test. The sum of the two conditional errors has minimum 1 − TV(P₀, P₁). Under equal priors and zero-one loss the average error has minimum (1 − TV(P₀, P₁)) / 2. A deterministic test attains both by rejecting exactly where P₀(x) < P₁(x).

This plan owns the test, its operating characteristics, the TV result and its consumers. C26 owns thresholds, randomization to fill a prescribed size, and optimality under a size constraint. For C27 the event test takes the independent law as null and the true joint law as alternative. The [programme map, revision 3](release-3-chunk-map.md) gives the handoff. The detailed contracts and criteria below govern C25 upon approval.

## Decisions before execution

**Development validation, before the first public declaration.** Separately select and qualify the development checkout and its actual build/CI route. The [published validator](../../scripts/validate_published.py) checks maintenance against tagged inputs, and the [complete candidate comparison](../../scripts/check_candidate_api_compatibility.py) checks an exact surface and its producer identity. CI invokes published static checks and a trust job that reaches the candidate comparison. The legacy standalone compatibility comparison retains 601 types. C25.01 needs a development route that checks **all 811** released declarations on evolving source, with approved additions, and keeps the independent v0.1.0 comparison of **601**. Check names, kinds, owners and elaborated types, focused imports, root reachability/exports, simp membership and trust. Keep exact release replay and both frozen contracts/artifacts as independent controls.

Qualify with matched compiling fixtures on that route. The unmodified release must pass. Add a documented declaration in a fresh focused module, record both its `new_module` and the full umbrella's `umbrella_addition` approvals, and compile a consumer through each import. Verify absence from the lightweight root. Withhold each approval separately and require the corresponding rejection. In a third fixture, change the type of a released post-v0.1.0 declaration while keeping the library compiling. Show the historical 601 comparison passes and the 811 comparison identifies the mutation. Record fixture identities, commands and actual results. Generated inventory supplies coverage only. Budget and authorize this enabling work independently of C25 mathematics.

## Public contracts and ownership

Propose one focused owner, `LeanInfoTheory.Probability.BinaryTesting`, with a single direct project import, `LeanInfoTheory.Probability.TotalVariation`. Expose it through `LeanInfoTheory.Shannon`. Keep the lightweight root's two direct imports and five-module closure. Examples live under `LeanInfoTheory.Examples.BinaryTesting`, import the focused owner, and join the development-only Examples aggregate. Use ordinary explicit lemmas and local proof helpers. No new global instances or simp attributes are proposed.

Use the transparent abbreviation `PMF.BinaryTest X := X → Set.Icc (0 : ℝ) 1`. The scalar gives both decisions' probabilities, works for randomization on a single atom, and supplies precisely the hypotheses of the existing bounded-function TV inequality. A raw Boolean channel `W : X → PMF Bool` expresses the same experiment if `true` means rejection. Its scalar is `(W x true).toReal`. Conversely, mix the point masses at true and false with weights f(x) and 1 − f(x). The released `PMF.binaryMixture` supplies that pattern if a caller eventually needs a channel. C26's level constraint and power comparison use only the scalar. Keep one public representation.

The following names and argument order are proposed. Operations belong to `PMF.BinaryTest`. Write `r P x = (P x).toReal` locally in the explanation. The test type, event constructor and strict comparison need no finite enumeration. The sums and endpoint use `[Fintype X]`. There are no extra public inhabitance, decidability, measurability, absolute-continuity or support assumptions.

| Proposed contract | Meaning |
| --- | --- |
| `rejectProb f P : ℝ` and `rejectProb_mem_Icc` | The finite sum `∑ x, r P x * (f x : ℝ)` belongs to `Set.Icc 0 1`. |
| `size f P0`, `power f P1`, `typeIIError f P1` | Size (type-I error) is `rejectProb f P0`. Power is `rejectProb f P1`. Type-II error is `1 - power f P1`. The first two role names unfold to one evaluation. |
| `ofEvent s : PMF.BinaryTest X`, `ofEvent_apply`, `rejectProb_ofEvent`, `typeIIError_ofEvent` | The rejection weight is one on `s : Set X` and zero outside. Rejection and miss are the real event masses `(P.toOuterMeasure s).toReal` and `(P.toOuterMeasure sᶜ).toReal`. |
| `errorSum f P0 P1`, `one_sub_totalVariation_le_errorSum` | `errorSum = size f P0 + typeIIError f P1`. For every `f`, `1 - PMF.totalVariation P0 P1 ≤ errorSum f P0 P1`. |
| `tvTest P0 P1`, `errorSum_tvTest` | `tvTest P0 P1 = ofEvent {x \| P0 x < P1 x}`. Its error sum equals `1 - PMF.totalVariation P0 P1`. Ties accept the null. |
| `isLeast_errorSum` | `IsLeast (Set.range (fun f : PMF.BinaryTest X => errorSum f P0 P1)) (1 - PMF.totalVariation P0 P1)`. |
| `equalPriorError f P0 P1`, `isLeast_equalPriorError` | Half the error sum for each test. The range over the same tests has least element `(1 - PMF.totalVariation P0 P1) / 2`, attained by `tvTest P0 P1`. |

### Reusable source anchors

- [Finite PMF](../../LeanInfoTheory/Probability/Finite.lean) supplies `PMF.toReal_nonneg` and `PMF.sum_toReal`. [Total variation](../../LeanInfoTheory/Probability/TotalVariation.lean) supplies `PMF.toOuterMeasure_toReal_eq_sum`, `PMF.abs_sum_sub_le_totalVariation_of_mem_Icc`, `PMF.totalVariation_eq_one_sub_sum_min`, `PMF.totalVariation_self` and `PMF.totalVariation_eq_one_iff_disjoint_support`. The released greatest-value test theorem uses an absolute discrepancy. Its event theorem `PMF.totalVariation_eq_toOuterMeasure_sub` selects the first law's **weak** dominance set. The signed alternative advantage and the strict witness both need an explicit argument here.
- Pinned mathlib `v4.33.1`, commit `0df444a360eaa60ab8c11dca51a86af692955474`, defines `ProbabilityTheory.avgRisk`, `bayesRisk` and `minimaxRisk` in `Mathlib.Probability.Decision.Risk.Defs`. Average risk integrates a composed kernel's loss over a prior in `ℝ≥0∞`. Bayes risk takes an infimum over Markov decision kernels. Equal priors and zero-one loss motivate the half-sum. A formal bridge would require a consumer of those measurable kernels. Defer that bridge and the risk-module import. Mathlib's old PMF Bernoulli constructor is deprecated in this pin.
- PW24 §7.3 introduces a possibly randomized rule and gives the error-sum optimum in Theorem 7.7(a), (7.17)–(7.19), printed 122–123 / PDF 147–148. §14.1, printed 276–277 / PDF 301–302, makes the conditional rejection probability and the weighting by priors explicit. The book's α is null acceptance, so C26's size level a corresponds to 1 − α. The proposed Lean theorems bound every randomized test and exhibit one deterministic event attaining equality. §14.2 supplies C26 context. The C10 record documents the half-L1 normalization and the sparse three-point fixture. [Reference register](../references.md#pw24-polyanskiy-and-wu-newer-draft) · [C10 handoff](../handoffs/chunk-10.md) · [TV consumers](../../LeanInfoTheory/Examples/TotalVariation.lean)

## Ordered steps and acceptance criteria

The criterion IDs below are the units for review. Proof routes are advisory. Each selected step must supply a warning-as-error focused build and a compiling consumer using its public contracts. For growth, use the separately qualified development checks, exact owner/import approvals, up-to-date generated current inventory and website indexes. Distinguish source/static checks from compiled evidence. Apply the [review protocol](../review-protocol.md) and [operations](../review-operations.md) to one explicitly requested step at a time.

### C25.01 — Test and evaluation

- **C25.01-API** — Deliver the bounded test, rejection probability, its range, size, power and type-II error with the stated orientations. A focused consumer constructs constant tests with probabilities zero, one and one half, checks their numerical evaluations, and recovers the range of all three operating characteristics for arbitrary laws.
- **C25.01-IMPORTS** — Before adding the first public declaration, identify the approved development route and its passing qualification evidence described above. Build the new owner and the full umbrella consumer. Verify that the lightweight root cannot see the new declarations. Record both import approvals, check both retained baselines and audit the new documentation, imports and attributes.

### C25.02 — Deterministic event tests

- **C25.02-EVENT** — Deliver `ofEvent`, its pointwise evaluation and the two event-mass identities for arbitrary sets. Check empty and full events and a singleton on which null and alternative assign different masses. A caller obtains size under the null and the complement miss probability under the alternative without unfolding weighted sums.

### C25.03 — Lower bound for randomized tests

- **C25.03-BOUND** — Deliver `errorSum` and prove `1 - PMF.totalVariation P0 P1 ≤ errorSum f P0 P1` for every randomized test, using the released bounded-test TV inequality. Compile a caller with an arbitrary `f : PMF.BinaryTest X` and one with an interior rejection weight.

Proof note. At endpoints 0 and 1 the interval inequality bounds the signed advantage `power f P1 - size f P0` by TV. Subtracting the advantage from one gives the error sum. Choose the local rewrites during implementation.

### C25.04 — Strict optimizer and equal-prior error

- **C25.04-ATTAIN** — Deliver the strict test, its exact error and the `IsLeast` error-sum theorem. A consumer must recover both the explicit witness and the comparison with an arbitrary randomized competitor.
- **C25.04-PRIOR** — Deliver the equal-prior error and its attained least-value theorem. A caller derives the value at the same strict test and the lower bound for any test. Check the factor of two on a pair with positive overlap.

Proof note. Try the complement-event argument first. Let S be the strict rejection event, and let T be the event where `r P1 x ≤ r P0 x`. PMF atom masses are finite, so `ENNReal.toReal_le_toReal` with `PMF.apply_ne_top` identifies T with Sᶜ, including ties. Write mᵢ(A) for the real mass of A under Pᵢ. The released `PMF.totalVariation_eq_toOuterMeasure_sub P0 P1` gives TV = m₀(T) − m₁(T). C25.02 gives the miss m₁(T) under P₁. Under P₀ the same event identities give m₀(T) = 1 − m₀(S). Thus the strict test has error sum 1 − m₀(T) + m₁(T) = 1 − TV. If the finite-sum proof is simpler in Lean, each atom contributes the smaller of its two masses and `PMF.totalVariation_eq_one_sub_sum_min` gives the same result. Either proof suffices.

### C25.05 — Permanent examples and the next caller

- **C25.05-EXAMPLES** — Compile the following regressions through the focused import. Identify the event and evaluate the individual errors as well as the optimum. Use private fixtures and public theorem calls.

  | Laws and test | Required observations |
  | --- | --- |
  | Equal laws, arbitrary test | Power equals size, sum is 1 and average is 1/2 for every test. The strict event is empty. |
  | Distinct pure laws on a three-point alphabet | Reject the alternative-only atom even at null size zero. Accept the common-null atom. Size 0, power 1, miss 0, sum and average 0. |
  | P₀ = (1/2, 1/2, 0), P₁ = (0, 1/2, 1/2) | The strict test rejects only atom 2. Size 0, power 1/2, miss 1/2, TV 1/2, minimum sum 1/2 and average 1/4. Randomizing with probability 1/2 at the middle tie changes size and power to 1/4 and 3/4 and retains both optimum values. |

- **C25.05-CALLER** — Use one private two-point fixture with P₀ = (1/2, 1/2) and P₁ = (3/4, 1/4). For an arbitrary γ in the real unit interval, construct fγ with rejection weights (γ, 0). Through the focused API prove size γ/2 and power 3γ/4. Specialize the same calculation twice, identifying f₁ with the public `tvTest P0 P1`.

  | Test | Size | Power | Type-II error | Error sum | Equal-prior error |
  | --- | --- | --- | --- | --- | --- |
  | Strict TV test, γ = 1 | 1/2 | 3/4 | 1/4 | 3/4 | 3/8 |
  | Randomized caller, γ = 1/2 | 1/4 | 3/8 | 5/8 | 7/8 | 7/16 |

  Check TV = 1/4 and apply the C25.04 result to the first row. The strict optimizer rejects an atom with positive mass under both laws. The second row meets the tighter size cap 1/4 and pays 1/8 more in error sum. These evaluations exercise the interface for C26, which owns optimality at a prescribed size.

### C25.06 — Cumulative validation, independent review and C26 handoff

- **C25.06-VALIDATE** — Qualify the exact candidate against all preceding criteria. Build the focused owner, consumer, Examples and full umbrella. Exercise the root boundary, both compiled retained comparisons, current inventory, imports, simp, trust and documentation on the qualified development route. Run the full clean suite on a separately authorized clean checkpoint and repeat after amendment. Preserve unrelated local work. Record fresh checks, applicable earlier results and any pending gate with its reason. A mandatory pending gate keeps closure open.
- **C25.06-HANDOFF** — Prepare `docs/handoffs/chunk-25.md`, link it from the living summary, and reconcile the reference register and project log before final capture. Give exact signatures, imports, source adaptations, consumers, results and unresolved decisions. Point C26 to the private γ example and both rows above. Spell out `size f P0 ≤ a`, `power f P1`, the strict test's tie convention, alternative-only and common-null atoms, and the C26 need for equality in size and optimal power. Give C27 the event-test convention. Keep the roadmap advisory and the next chunk unselected.
- **C25.06-REVIEW** — Before cumulative dispatch, assemble the criterion-by-criterion source/evidence matrix, complete self-review and separate reassessment, and record applicable earlier dispositions. Prepare the neutral, source-bound request for fresh independent assessment of the entire chunk, including final validation and handoff. List deferred items with their owners and triggers.

Dispatch the cumulative request to the bound reviewer. After receipt, preserve and substantively reconcile each original assessment, address findings and revalidate the final source. A reviewer gap needs a satisfactory source-bound reassessment. Finish canonical edits before final capture. Only the supported private closure record establishes completion.

## Plan-review scope

- **C25-PLAN-MATH** — Assess the public test representation, signs, quantifiers, strict witness, normalization, finite assumptions and source adaptation against the stated decision problem.
- **C25-PLAN-USE** — Assess the reuse and import boundaries, permanent examples, numerical expectations and C26/C27 consumers against the proposed contracts.
- **C25-PLAN-GATES** — Distinguish the completed workflow prerequisite from the pending qualification for public API growth. Assess the separation of plan approval and step selection, and whether the cumulative evidence and reconciliation can establish every required endpoint.

For each future dispatch use the exact source-bound plan revision, applicable normative excerpts and dependencies. Preserve original reviewer reports. After plan review, exact lead approval is required for execution. Thereafter each eligible instruction selects one named step with its review process, then the chat stops.
