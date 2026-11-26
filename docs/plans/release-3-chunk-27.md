# C27 — Finite information density and the strict threshold event

<!-- lit-review-status:start -->
**Plan status:** Approved, revision 2. The lead selected C27.01 with its review process on 8 November 2026. This revision incorporates the implementation chat's assessment and the General Assistant's advisory report. Revision 1 is preserved in the source capture for `plan-r1-20261108`. Its formal review stopped at a source-inventory mismatch before the bound reviewer issued any criterion assessment. The original observations are under `.lit-review/setup/c27-plan-r1-20261108/`. The mathematical contract is the revision presented under SHA-256 `9c60a954f30d66e8c88e2baef6e4312b8e087619941a002d8d764d2e7d0ed5f8`. Revision 2 has had no formal PLAN review. Step completion follows the private execution record.
<!-- lit-review-status:end -->

## Mathematical contract

Given an input law `p : PMF A` and a raw channel `W : A → PMF B`, write `J = PMF.channelJoint p W` and `Q = indepProd p (p.bind W)`. The coordinates are input first, output second. Use a signed real information density in nats, a strict event defined on the whole product, its false-alarm probability under Q, and its complementary miss probability under J. Allow arbitrary real thresholds, sparse laws, deterministic channels and singleton alphabets. A supplied PMF and channel already witness the necessary inhabitance. Callers supply no positivity, order, decidability or measurable-space instances.

Use Lean's total `Real.log ((J z).toReal / (Q z).toReal)`. On joint support both masses are positive, so this is the ordinary log likelihood ratio. It can be negative. At zero joint mass the expression evaluates to zero, including at a common-null atom. This convention makes finite sums and ordinary random-variable expressions convenient. The event compares atom masses directly, so every zero-joint atom fails for every real threshold. Probability under J permits replacing the complement by the closed density sublevel set even when their underlying sets differ.

In the registered PW24 draft, §18.1, Definition 18.1/(18.2), Proposition 18.2 and Corollary 18.4/(18.6) supply the density, joint mean and independent-pair strict tail (printed pp. 351–353). The extended logarithm can take minus infinity where J vanishes and Q is positive. C27 uses its ordinary real value on joint support and preserves the global decoder decision by mass comparison. PW24 §18.2, Theorem 18.5/(18.9), gives the closed true-pair miss in the one-shot bound. The displayed decoder (18.10) uses a weak comparison. Here equality goes to the miss, including for atoms of positive probability. CT91 §2.3, (2.28)–(2.30), gives the discrete joint mean in the book's log convention. Use the library's natural logarithm and existing finite-sum theorem. [Reference register](../references.md#release-3-planning-locators) · [Release 3 map, revision 3](release-3-chunk-map.md#c27-information-density-and-the-two-competing-laws)

## Proposed public API

All seven declarations belong to `LeanInfoTheory.Shannon`. In the signatures below, `{A : Type u} {B : Type v}` are implicit, `(p : PMF A) (W : A → PMF B)` are explicit in that order, and `J` and `Q` expand to the expressions above. These two symbols are notation in this plan only. The displayed definitions specify their actual bodies. The sum has an explicit pair index.

```lean
noncomputable def infoDensity (p : PMF A) (W : A → PMF B) (z : A × B) : ℝ :=
  Real.log ((J z).toReal / (Q z).toReal)

theorem support_channelJoint_subset_indepProd (p : PMF A) (W : A → PMF B) :
    J.support ⊆ Q.support

theorem sum_mul_infoDensity_eq_mutualInfo [Fintype A] [Fintype B]
    (p : PMF A) (W : A → PMF B) :
    (∑ z : A × B, (J z).toReal * infoDensity p W z) = mutualInfo J

def infoDensityThresholdEvent (p : PMF A) (W : A → PMF B) (t : ℝ) : Set (A × B) :=
  {z | Real.exp t * (Q z).toReal < (J z).toReal}

theorem mem_infoDensityThresholdEvent_iff_of_mem_support
    (p : PMF A) (W : A → PMF B) (t : ℝ) {z : A × B} (hz : z ∈ J.support) :
    z ∈ infoDensityThresholdEvent p W t ↔ t < infoDensity p W z

theorem indepProd_infoDensityThresholdEvent_le [Finite A] [Finite B]
    (p : PMF A) (W : A → PMF B) (t : ℝ) :
    (Q.toOuterMeasure (infoDensityThresholdEvent p W t)).toReal ≤ Real.exp (-t)

theorem channelJoint_infoDensityThresholdEvent_compl_eq
    (p : PMF A) (W : A → PMF B) (t : ℝ) :
    (J.toOuterMeasure (infoDensityThresholdEvent p W t)ᶜ).toReal =
      (J.toOuterMeasure {z | infoDensity p W z ≤ t}).toReal
```

The support inclusion gives positivity of the Q atom from positivity of the J atom. A focused caller must also obtain the corresponding strict real-mass implication, using finiteness of PMF **atom masses** when passing through `toReal`. A single unfolding gives the supported log equation.

## Placement and proof dependencies

Create the focused owner `LeanInfoTheory.Shannon.InformationDensity` and expose it through the complete `LeanInfoTheory.Shannon` umbrella. Proposed direct project imports:

- `LeanInfoTheory.Probability.FiniteChannel` for `PMF.channelJoint`, `PMF.channelJoint_apply`, `PMF.channelJoint_map_fst`, `PMF.channelJoint_map_snd` and channel support.
- `LeanInfoTheory.Shannon.SemanticBridge.Product` for the existing `indepProd`, its atom formula and its support.
- `LeanInfoTheory.Shannon.SemanticBridge.FiniteSums` for `mutualInfo_eq_sum_log_ratio`.
- `LeanInfoTheory.Probability.TotalVariation` for `PMF.toOuterMeasure_toReal_eq_sum`. This finite-event identity is owned there.

Use `LeanInfoTheory.Examples.InformationDensity` for private examples under the development `Examples` aggregate. It imports the focused owner and C25's `LeanInfoTheory.Probability.BinaryTesting` for deterministic test consumers. The uniform fixture may also use the pinned `Mathlib.Probability.Distributions.Uniform`. The new public owner needs no testing, capacity, code, iid, or KL module. Keep proof-only estimates private. Add no global instance or simp attribute. Iid concentration belongs to C28, the sampling experiment and decoder to C29, and the one-shot coding bound to C30. [C25 handoff](../handoffs/chunk-25.md) · [C26 handoff](../handoffs/chunk-26.md)

## Ordered steps and acceptance criteria

### C27.01 — Define the density and establish support domination

- **C27.01-SUPPORT** — Add the total signed density and the support inclusion with the stated binders. Exhibit the real-mass positivity implication and supported log formula in a focused caller. Check that a supported ratio strictly below one gives strictly negative density and that zero joint mass evaluates to zero. The channel support characterization, the input witness in the support of `bind`, and `support_indepProd` suffice for inclusion on arbitrary alphabets.
- **C27.01-BOUNDARY** — Before adding public names, match the completed C26 evidence against the pre-edit mathematical/validation inputs and pins, accounting for the C27 plan as a new document. Record the separately approved module and full-umbrella growth entries. Verify focused visibility and lightweight-root exclusion.

### C27.02 — Identify the joint mean

- **C27.02-MEAN** — Prove the exact finite weighted-sum equality by specializing `mutualInfo_eq_sum_log_ratio` to `PMF.channelJoint p W` and reversing its orientation. Identify its two marginals by the existing projection theorems and rewrite the independent-product atom using `indepProd_apply` and `ENNReal.toReal_mul`. A focused consumer must rewrite the sum to `mutualInfo J` for arbitrary finite alphabets and channel.

### C27.03 — Construct the strict event and identify the true-pair miss

- **C27.03-EVENT** — Add the global mass-comparison set and the membership iff on joint support. Compile a private caller deriving `z ∈ infoDensityThresholdEvent p W t ↔ z ∈ J.support ∧ t < infoDensity p W z` for every pair. In the forward direction, the nonnegative product `Real.exp t * (Q z).toReal` lies strictly below the joint mass, so the pair is in joint support. The supported iff then applies in either direction. Check that the mass rule excludes Q-only and common-null atoms for every real threshold.
- **C27.03-MISS** — Prove the displayed equality of J-probabilities with a weak density sublevel for every real threshold. Intersect each event with J support and apply `PMF.toOuterMeasure_apply_eq_of_inter_support_eq`. Compile a private miss caller on word alphabets at `t = (n : ℝ) * r`, for arbitrary blocklength, input-word PMF and block channel.
- **C27.03-TIE** — In a private Lean development check, use uniform Boolean input and the existing `PMF.binarySymmetricChannel` with crossover `1/8`. Each matching pair has real masses `J = 7/16`, `Q = 1/4` and density `Real.log (7/4)`. Each mismatching pair has `J = 1/16`, `Q = 1/4` and strictly negative density `Real.log (1/4)`. At `t = Real.log (1/4)`, prove the event is the diagonal, its Q-probability is `1/2`, and its J-probability is `7/8`. Check that the full J-miss of `1/8` lies at equality and that the open density sublevel has J-probability zero. Keep the standard-channel import in the development check and retain the result in the step evidence. [Binary symmetric channel](../../LeanInfoTheory/Probability/StandardChannels.lean)

### C27.04 — Bound false alarms under the independent law

- **C27.04-TAIL** — Prove the real Q-probability bound for every real threshold. On the strict event, multiply by the positive `exp (-t)` to bound Q's atom mass by `exp (-t)` times J's. Outside the event, Q's indicator contribution is zero. Sum and use `PMF.sum_toReal` for J. Check arbitrary finite inputs with only `Finite` instances at the theorem boundary.
- **C27.04-CALLER** — On words over finite alphabets, compile a private caller combining the C27.03 miss equality and the C27.04 tail bound. Take `n k : ℕ`, `r : ℝ`, any input-word law `q : PMF (Fin n → X)`, and any block channel `K : (Fin n → X) → PMF (Fin n → Y)`. Set `t = (n : ℝ) * r`, `A = infoDensityThresholdEvent q K t`, `J = PMF.channelJoint q K`, and `Q = indepProd q (q.bind K)`. The target below includes zero blocklength and zero competitors. It uses only the nonnegativity of the real cast of `k` and needs no iid hypothesis.

```lean
(J.toOuterMeasure Aᶜ).toReal + (k : ℝ) * (Q.toOuterMeasure A).toReal ≤
  (J.toOuterMeasure {z | infoDensity q K z ≤ t}).toReal + (k : ℝ) * Real.exp (-t)
```

### C27.05 — Exercise both laws through permanent focused consumers

- **C27.05-NOISELESS** — Use `PMF.uniformOfFintype Bool` and the deterministic identity channel. Check J masses 1/2 on the diagonal and 0 off it, Q mass 1/4 on all four pairs, and diagonal density `log 2`. At `t = -1`, establish that the event is the diagonal even though the off-diagonal totalized density exceeds the threshold. At `t = log (3/2)`, show Q-size 1/2, J-power 1 and J-miss 0 via C25. Here the false-alarm bound is 2/3, which separates the two law orientations.
- **C27.05-INDEPENDENT** — Use an input-independent channel `W = fun _ => r`. Identify J and Q with `indepProd p r`, check zero density on joint support, and prove the strict event at zero is the empty set globally. Check size and power zero and miss one. Instantiate with uniform Boolean input and a pure Boolean output to include common-null atoms. Use C25's `BinaryTest.ofEvent`, `rejectProb_ofEvent` and `typeIIError_ofEvent`, with Q null and J alternative.

### C27.06 — Qualify the chunk and hand off to C28

- **C27.06-VALIDATE** — Map every preceding criterion to its source, consumer and applicable evidence. Run cumulative focused owner, examples, Shannon and testing checks, non-mutating generated/static and documentation checks, compiled historical and completed-testing comparisons, import/root/simp and all-project axiom audits, and the complete development suite on an expressly authorized clean candidate. Establish candidate-to-main source and pin correspondence for the exact revision submitted for review.
- **C27.06-HANDOFF** — Reconcile the living summary, project log, reference register and implementation notes with actual declarations, checks and dispositions. Prepare and link `docs/handoffs/chunk-27.md` with exact imports, laws, both permanent examples, and the private negative-tie check. Include the word-level miss rewrite for C28, the support-guarded global rewrite for C29, and the weighted two-law caller for C30. For C28's proposed concentration proof, document the supported identity below and its derivation. Mark its Lean proof as C28 work. Maintain provisional closure wording before final capture.

  For `(x, y) ∈ J.support`, the identity is `infoDensity p W (x, y) = selfInfo p x + selfInfo (p.bind W) y - selfInfo J (x, y)`. The joint atom is positive, and the support inclusion supplies positive input and output marginal atoms through `support_indepProd`. Their real masses are positive as each PMF atom is finite. Factor the Q atom, expand the log of the quotient and product, and apply `selfInfo_of_toReal_ne_zero` to each of the three laws. [Self-information rewrite](../../LeanInfoTheory/Shannon/SemanticBridge/Entropy.lean)

- **C27.06-REVIEW** — Before dispatch, complete the contextual self-review and separate reassessment. Prepare a neutral request for fresh cumulative independent review covering all criteria, with references to the evidence matrix, exact candidate, handoff and applicable earlier findings. Keep private verdicts and transcripts in the implementation record.

**Mandatory closeout after dispatch.** Receive and preserve the bound reviewer's original report. Reconcile every assessment and finding, and obtain fresh satisfactory reviewer assessments for criterion gaps. Finish any corrections and required document edits before final capture. Repeat the complete development suite after any candidate amendment and revalidate the applicability of the independent assessment to the final source. Record closure through the supported private mechanism and stop.

## Baseline, validation and approval

C26.06 closed with record `963c196f79dd96c19b2015ca318e2bec083b500b13e4313a10870a3b393512a5` and clean checkpoint `b882bb00572b8831783f34979c25ba7af5c44e81`. The handoff intentionally points to the private completion record for its verdict. Before this proposal was added, the main checkout matched the C26 final manifest, including its environment and Git state, and all 352 clean candidate files by raw hash. Use the retained C26 compiler export in `.lit-review/setup/c26-06-20261107/candidate-types.stdout` for a named-record comparison of the incoming 832 declarations across 59 supported modules. Also check the 17 C25 and four C26 declarations through their respective focused imports. The released baselines independently retain 601 and 811 declarations. Preserve both released contracts, the root's two direct imports, five-module closure and 92 exports, and the 94 reviewed simp names.

Each separately selected step uses the installed supervised cycle, original reviewer output, explicit reconciliation, final validation and private closure. Build touched owners and important consumers with `python scripts/validate_release.py focused <targets>`. After approved public growth, regenerate the current manifest and both website indexes (blueprint and declaration index), verify the frozen manifest and run `python scripts/validate_development.py static`. Use the maintained compiled compatibility/trust checks and named pre-C27 comparison for public changes. Cumulative qualification includes `python scripts/validate_release.py documentation` and `python scripts/validate_development.py` on the exact clean candidate. Existing local work stays protected. A pending mandatory gate keeps closeout pending. API-doc generation and publication have separate milestones. [Compatibility guide](../compatibility/README.md) · [Review protocol](../review-protocol.md) · [Operations](../review-operations.md)

## Formal plan-review criteria

- **C27-PLAN-MATH** — Assess support domination, signed nats, reuse of the existing joint mean, the globally strict event on sparse laws, the independent-law bound and the complementary joint-law equality against the registered references.
- **C27-PLAN-CONSUMERS** — Assess the binder choices, real probability interface, both permanent examples, the negative-density tie and impossible-pair checks, and C25 test orientation. Check the guarded global rewrite, the word-level miss, the weighted two-law caller and the supported self-information handoff.
- **C27-PLAN-BOUNDARY** — Assess import ownership, public growth, retention of released and completed testing contracts, the clean validation boundary, review readiness, subsequent closure duties and handoff. Assess this proposal only upon the lead's explicit request.
