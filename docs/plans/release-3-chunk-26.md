# C26 — The finite Neyman–Pearson theorem

<!-- lit-review-status:start -->
**Plan status:** Approved, revision 2. C26.01–C26.05 have supported closure records, satisfactory independent criterion assessments and final-source checks. C26.05's original stopped dispatch and authorized recovery retain their complete history; its replacement ordinary STEP review and closure are under .lit-review/setup/c26-05-r2-20261107/. A new conditional instruction selected C26.06 after exact C26.05 closure/source verification. The twelve-criterion cumulative matrix and maintained handoff are prepared. Exact clean-checkpoint authorization/results, fresh cumulative review, reconciliation, final applicability and supported completion follow .lit-review/setup/c26-06-20261107/completion.json when established. No result or closure is predicted. The earlier consumed conditional Step6 skip remains unchanged; C27 is unselected.

Revision 1's original PLAN review and reconciliation remain under .lit-review/setup/c26-plan-r1-20261107/. Formal PLAN review applied to revision 1. Revision 2 incorporates that review and the General Assistant’s advisory comments.
<!-- lit-review-status:end -->

## Mathematical contract

For any two PMFs on the same finite observation type and any real level `a` in the closed unit interval, exhibit a finite nonnegative threshold and a single boundary rejection probability. The resulting test has size exactly `a` under the null and simultaneously dominates in power every randomized test of size at most `a`. Thus the same test attains the least type-II error under that cap. The test may depend on both laws and the level. Its choice precedes the quantifier over competitors.

Write `pᵢ x = (Pᵢ x).toReal`. At each atom the rule rejects with probability one if `p₁ x > c * p₀ x`, zero if `p₁ x < c * p₀ x`, and the same `γ` throughout the equality set. In particular, a positive alternative mass on a null atom is always rejected. A common-null atom receives `γ` and contributes zero to both sums. The threshold may be zero. The contract includes levels zero and one, arbitrary ties, a singleton alphabet and PMFs with different supports. A PMF already rules out an empty observation type. Absolute continuity, strict positivity, caller-supplied decidability, a linear order on observations and a separate inhabitance hypothesis are unnecessary.

PW24 §§14.1–14.2 give the decision convention, Table 14.1, Definition 14.1/(14.3) and Definitions 14.4–14.5 of the extended log likelihood and deterministic likelihood test (printed 276–282, PDF 301–307). The randomized attainment statement is in **§14.4, Theorem 14.11/(14.11)** (printed 284, PDF 309). The book uses null acceptance `α` and alternative acceptance `β`. Here size is `1 − α` and power is `1 − β`. On jointly positive masses, a finite threshold `τ` for the book’s null-over-alternative log likelihood corresponds to `c = exp(−τ)`, with tie rejection `γ = 1 − λ` for tie acceptance `λ`. The finite mass rule also permits `c = 0` directly. On a common-null atom Definition 14.4 assigns the log likelihood zero. Our mass rule ties there for every `c`, so the pointwise decisions can differ while giving the same size and power. The theorem asserts existence. For example, at size 1/2 in the Boolean fixture every threshold strictly between 1/2 and 3/2 gives the same decision, independently of `γ`. The registered August 16, 2024 copy matched SHA-256 `c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`. [Reference register](../references.md#pw24-polyanskiy-and-wu-newer-draft) · [C25 handoff](../handoffs/chunk-25.md) · [Release 3 map, revision 3](release-3-chunk-map.md#c26-neyman--pearson-for-finite-experiments)

## Proposed public interface

Use `LeanInfoTheory.Probability.NeymanPearson` with the sole direct import `LeanInfoTheory.Probability.BinaryTesting`. Expose it through the full `LeanInfoTheory.Shannon` umbrella. A client that needs only C25 evaluation or event tests can still import `BinaryTesting` alone. Keep private examples in `LeanInfoTheory.Examples.NeymanPearson`, directly importing the new owner only, under the development `Examples` aggregate. Use the existing `PMF.BinaryTest` namespace and its real finite-sum evaluations.

The following are proposed declaration headers. The constructor and its application equation require no finiteness assumption. The two comparison theorems use `[Fintype X]` to match `size` and `power`.

```lean
namespace PMF.BinaryTest
open scoped NNReal
universe u
variable {X : Type u}

noncomputable def likelihoodThresholdTest (P0 P1 : PMF X)
    (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1) : PMF.BinaryTest X

theorem likelihoodThresholdTest_apply (P0 P1 : PMF X)
    (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1) (x : X) :
    (likelihoodThresholdTest P0 P1 c γ x : ℝ) =
      if (c : ℝ) * (P0 x).toReal < (P1 x).toReal then 1
      else if (P1 x).toReal < (c : ℝ) * (P0 x).toReal then 0
      else (γ : ℝ)

variable [Fintype X]

theorem power_le_power_likelihoodThresholdTest (P0 P1 : PMF X)
    (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1) (g : PMF.BinaryTest X)
    (hg : size g P0 ≤ size (likelihoodThresholdTest P0 P1 c γ) P0) :
    power g P1 ≤ power (likelihoodThresholdTest P0 P1 c γ) P1

theorem exists_likelihoodThresholdTest (P0 P1 : PMF X) (a : ℝ)
    (ha : a ∈ Set.Icc (0 : ℝ) 1) :
    ∃ (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1),
      let fStar := likelihoodThresholdTest P0 P1 c γ
      size fStar P0 = a ∧
        ∀ g : PMF.BinaryTest X, size g P0 ≤ a → power g P1 ≤ power fStar P1

end PMF.BinaryTest
```

The explicit-parameter comparison certifies a supplied test, including the concrete C25 witness. The existence theorem supplies both parameters to a caller with only a level. A private general caller will derive attained minimum miss using `typeIIError f P1 = 1 - power f P1`. Keep thresholds, ties and decisions visible through the constructor. Keep support enumeration, crossing lemmas, sums and calibration private. Add no global instance or simp attribute. Full ROC theory, information density, C27 implementation and release operations lie outside C26.

## Proof choice

**Threshold size.** Let `S` be the positive null support. Its null mass is one by `PMF.sum_toReal`, so it is nonempty. Define `r(x) = p₁(x) / p₀(x)` on `S`. For any `c ≥ 0`, let `U(c)`, `B(c)` and `W(c)` be the **null masses** on `S` where `r > c`, `r = c` and `r ≥ c`, respectively. First prove the private identity for arbitrary `c, γ`.

```text
size (likelihoodThresholdTest P0 P1 c γ) P0 = U(c) + γ * B(c)
```

On `S`, multiplying by positive `p₀(x)` identifies the ratio comparisons with the constructor’s mass comparisons. Off `S` every term of the size sum is zero, including every alternative-only atom where the constructor rejects. This identity also holds for an unrealized threshold with `B(c) = 0`.

**Exact calibration on the closed interval.** For any `a ∈ [0,1]`, choose the greatest realized ratio `c` with `W(c) ≥ a`. The least realized ratio qualifies because its weak tail has mass one. If there is a higher level, the least such level `d` has `U(c) = W(d) < a`. Otherwise `U(c) = 0 ≤ a`. Thus `U(c) ≤ a ≤ W(c) = U(c) + B(c)`. Some atom of `S` realizes `c`, so `B(c) > 0`. Now set `γ = (a − U(c)) / B(c)`. The bracket places `γ` in the closed unit interval and the size identity gives exact size.

At `a = 0`, all realized levels qualify. The greatest has `U(c) = 0`, so `γ = 0` and the test rejects exactly the alternative-only atoms. At `a = 1`, the least realized level is the only one with weak tail mass one, since each realized level has positive null mass. Hence `1 − U(c) = B(c)` and `γ = 1`. The test rejects everywhere. Both endpoint calculations use the same positive denominator as the interior proof.

For the test `f` at any `c, γ`, compare `(g(x) − f(x)) (p₁(x) − c p₀(x))` with zero. Above threshold the first factor is nonpositive, below it the first is nonnegative, and on the boundary the second vanishes. Summation gives `power g P1 − power f P1 ≤ c * (size g P0 − size f P0)`. Nonnegativity of `c` gives the public size-cap comparison. This covers the singular atoms directly.

**Alternatives considered.** Sorting distinct levels and taking the first crossing gives the same witness, but requires list order and prefix-sum reasoning. Greedy fractional knapsack on atoms requires an exchange argument and a further step to obtain a single weight on a tied level. Compact optimization over the feasible finite cube gives an optimizer but leaves its threshold form and exact-size calibration to prove. The finite-set maximum and successor route supplies both directly. In pinned mathlib `v4.33.1` at `0df444a360eaa60ab8c11dca51a86af692955474`, `Finset.exists_next_right` gives the least strictly greater realized value. The focused import supplies finite extrema, positive-sum and filter-partition lemmas, `Finset.sum_le_sum` and guarded real division comparisons. The pinned decision-risk definitions concern kernel-valued estimators and expected loss. Local source/index and pinned-library searches located no matching prescribed-level testing endpoint. The proof route may evolve with Lean evidence.

## Ordered steps and acceptance criteria

### C26.01 — Define the threshold rule

- **C26.01-RULE** — Define the constructor and its public pointwise equation with the stated parameter types, three branches and no finiteness assumption. Check the above, below and tie branches and their consequences on alternative-only and common-null atoms via the focused import.
- **C26.01-IMPORTS** — Before the first public addition, establish the applicability of the C25 checkpoint evidence identified below to the current pre-edit source and pins. The pre-C26 surface has 828 declarations in 58 modules. On approval, record the new owner and its full-umbrella import in their respective growth-policy entries. Verify focused and umbrella visibility and root exclusion. Preserve the 17 C25 contracts and the root’s two direct imports, five-module closure and 92 exports.

### C26.02 — Certify a supplied threshold test

- **C26.02-COMPARE** — Prove the public power comparison for arbitrary nonnegative threshold, tie probability and randomized competitor with the stated size inequality. Build a focused caller which supplies its own parameters and size bound. The comparison must cover equality, `c = 0` and alternative-only atoms.

### C26.03 — Evaluate threshold size and locate the boundary

- **C26.03-SIZE** — Prove the private size identity for the public threshold test at arbitrary `c, γ`, with the strict-tail and tie masses defined on positive null support. Account for the zero size contribution off that support. C26.04 must be able to apply this identity without redoing the support split.
- **C26.03-CROSSING** — For every `a ∈ [0,1]`, produce a realized nonnegative `c` with `U(c) ≤ a ≤ U(c) + B(c)` and `0 < B(c)`. Anchor support nonemptiness in PMF normalization. Cover repeated levels, a single realized level and a greatest level with no successor. Keep these facts private. The finite-set proof above is the recommended route.

### C26.04 — Attain the level and prove Neyman–Pearson

- **C26.04-ATTAIN** — Form the common tie weight using the positive boundary mass from C26.03. Prove its interval bounds and exact size via the private size identity, then apply C26.02 to the same test for every feasible competitor. Check arbitrary-law calls at both endpoints, including size-zero rejection on alternative-only atoms. Derive the attained minimum of the existing `typeIIError` from the general-level witness.

- **C26.04-CALIBRATION** — Use one private four-atom check during proof development. Take `P0 = (1/6, 1/6, 1/3, 1/3)` and `P1 = (1/2, 1/6, 1/3, 0)`. Their ratios are `(3, 1, 1, 0)`. Verify the two rows below in Lean and retain the result in the step evidence. C26.05 supplies the two permanent consumers.

| Level | Threshold | Strict-tail null mass | Boundary null mass | Tie weight | Rejection weights | Optimal power |
| --- | --- | --- | --- | --- | --- | --- |
| 1/3 | 1 | 1/6 | 1/2 | 1/3 | (1, 1/3, 1/3, 0) | 2/3 |
| 5/6 | 0 | 2/3 | 1/3 | 1/2 | (1, 1, 1, 1/2) | 1 |

The first row fills a positive residual size using two tied atoms of unequal null mass. In the second row `c > 0` would force the fourth weight to zero and cap size at 2/3. These are explicit witnesses to compare using C26.02. The existence theorem leaves its choice of parameters free.

### C26.05 — Prove both permanent consumers

- **C26.05-RANDOMIZED** — Adapt the private C25 Boolean fixture in its (false, true) coordinate order. With null weights (1/2, 1/2), alternative weights (3/4, 1/4), `c = 3/2` and `γ = 1/2`, identify the rejection weights (1/2, 0). Prove size 1/4, power 3/8, miss 5/8 and `∀ g, size g P0 ≤ 1/4 → power g P1 ≤ 3/8` through the public comparison. Check that every feasible deterministic event has power zero, since every nonempty event has null mass at least 1/2. Keep the fixture private. [C25 example](../../LeanInfoTheory/Examples/BinaryTesting.lean)
- **C26.05-SINGULAR** — Take the point masses at 0 and 1 on `Fin 3` as null and alternative, respectively. With `c = 2` and `γ = 1/2`, prove the rejection weights are `(0, 1, 1/2)`, with size zero, power one and miss zero. This distinguishes the alternative-only atom from the common-null atom pointwise. Prove the comparison for every feasible randomized competitor. Also instantiate the public existence theorem at zero, compare its witness to the explicit test, and use the unit upper bound to show its power is one. Compile the focused example and Examples aggregate.

### C26.06 — Cumulative validation, independent review and handoff

- **C26.06-VALIDATE** — Qualify all preceding criteria on the exact candidate. Build the C25 and C26 focused owners and consumers, Examples and Shannon. Run the separate retained comparisons for v0.1.0 (601) and v0.2.0 (811). Against the C25 checkpoint, compare the 828 preceding compiler records by name, including elaborated types, universe parameters, kinds and owners, and check all 17 C25 testing declarations remain visible from the C25 focused import. Audit current inventory, direct imports, root closure and exports, simp sets, documentation and axioms. Run the complete development suite on a separately authorized clean checkpoint and repeat after every amendment. Preserve unrelated local work and the frozen release artifacts.
- **C26.06-HANDOFF** — Prepare `docs/handoffs/chunk-26.md`, link it from the living summary, and reconcile affected canonical context, reference register, project log and deferred items before final capture. Give actual signatures, focused imports, both numeric consumers, source adaptation, check provenance, limitations and review dispositions. Record whether the testing package can be used independently of coding imports and what C27 can import from C25.
- **C26.06-REVIEW** — Before dispatch, prepare the source/evidence matrix for all C26 criteria, contextual self-review, separate reassessment and a neutral request for fresh cumulative independent review. Include the actual handoff, candidate evidence and earlier dispositions. Separate review readiness from the subsequent original report, reconciliation and supported closure.

**C25 comparison evidence for C26.01 and C26.06.** The accepted C25 checkpoint is `06c71043a28af231e11490443b6225ae3b9a76eb`. Its completion pointer is `.lit-review/setup/c25-06-20261106/completion.json`. The associated clean result at `approved-checkpoint/initial-clean/result.json` under the same C25.06 record directory identifies preserved copies of `candidate-types.stdout` and `boundaries.stdout` in the main checkout. The former has SHA-256 `d6962858d3d6dba55f2b298dbf61fcffe1d03099a538ffe74f0e777231021d9d` and contains all 828 compiler records. The latter records focused visibility and the root boundary. Use these to distinguish C26 growth from changes to C25 before and after implementation. [C25 handoff](../handoffs/chunk-25.md) · [C25 validation notes](release-3-chunk-25-notes.md#c2505-parent-validation-facts)

For each selected step, capture its actual baseline, perform the scoped work, run focused and static checks and check new declarations and imports. For each public change, record the reviewed policy growth, regenerate the current manifest and website blueprint/index, check the frozen inventory, run the compiled compatibility comparisons and verify focused, full and lightweight-root boundaries. Use `scripts/validate_release.py focused` and `documentation` and the appropriate `scripts/validate_development.py` gates (`static`, `compatibility`, `trust`, and the default complete suite). Record fresh results separately from applicable prior evidence. The full API-docs gate is reserved for its separate milestone.

Follow the installed supervised workflow at each selected step. Retain the read-only self-review and separate reassessment, freeze the reviewed source, preserve the bound reviewer's original report and reconcile each assessment. Resolve findings, obtain a satisfactory reviewer reassessment for criterion gaps, revalidate final-source applicability and close only the selected step. For cumulative closure finish documentation before final capture, record any remaining proof-pressure triggers or deferred scope, and use the supported private completion record. A mandatory outstanding gate keeps the chunk open. C27 requires a separate planning decision. [Compatibility guide](../compatibility/README.md) · [Review protocol](../review-protocol.md) · [Review operations](../review-operations.md)

## Formal plan-review criteria

- **C26-PLAN-MATH** — Assess the finite existence and sufficiency contracts, all-randomized quantifier order, both likelihood orientations, ties, endpoints and singular/null atoms against PW24 and the approved C25 interface.
- **C26-PLAN-FEASIBILITY** — Assess the private size identity, realized-level crossing on the closed interval, positive denominator and signed-sum comparison. Check both four-atom calibration rows, verified library anchors, proof alternatives and both permanent uses of the public API.
- **C26-PLAN-BOUNDARY** — Assess module ownership and growth approvals, both release baselines, current C25 retention, lightweight-root exclusion, and the sufficiency of the cumulative review, validation and handoff criteria.
