# C28 — Iid block information density and concentration

<!-- lit-review-status:start -->
**Plan status:** Approved, revision 2. On 9 November 2026 the lead selected C28.01 with its review process after accepting this plan. The presented revision has SHA-256 `a4fcc7131989bad7c30ef6a8c632ef20254f9a2be0d90aff3e8968f91fbc9394`. Formal PLAN review has not been requested. Step results follow the private execution records.
<!-- lit-review-status:end -->

## Contract and proposed signatures

For implicit `{A : Type u} {B : Type v}`, take `[Fintype A] [Fintype B]` and explicit `(p : PMF A) (W : A → PMF B)` in that order. Both iid word laws and finite-alphabet mutual information use these instances. The coordinate order is input, then output. A law and its raw channel supply all the inhabitance needed. Sparse laws, deterministic rows, singleton alphabets and signed densities are included. All logarithms are natural. Callers need no measurable-space, full-support or positive-information assumption.

Use the following abbreviations **in this plan only**.

```lean
J       = PMF.channelJoint p W
pₙ      = PMF.iid p n
Wₙ      = PMF.memorylessChannel W n
Jₙ      = PMF.channelJoint pₙ Wₙ
Dₙ z    = infoDensity pₙ Wₙ z
I       = mutualInfo J
Word n  = (Fin n → A) × (Fin n → B)
```

Propose three theorems in `LeanInfoTheory.Shannon`. The schematic signatures below expand the abbreviations at the locally bound length. The three acceptances are a support equality, a two-sided numerical probability limit and a one-sided numerical probability limit for the existing strict event.

```lean
theorem infoDensity_iid_of_mem_support
    (p : PMF A) (W : A → PMF B) (n : ℕ) {z : Word n}
    (hz : z ∈ Jₙ.support) :
    Dₙ z = ∑ i : Fin n, infoDensity p W (z.1 i, z.2 i)

theorem tendsto_infoDensity_iid_deviation
    (p : PMF A) (W : A → PMF B) {ε : ℝ} (hε : 0 < ε) :
    Filter.Tendsto (fun k : ℕ =>
      let n := k + 1
      (Jₙ.toOuterMeasure
        {z : Word n | ε ≤ |Dₙ z / (n : ℝ) - I|}).toReal)
      Filter.atTop (nhds 0)

theorem tendsto_prob_infoDensityThresholdEvent_iid_compl
    (p : PMF A) (W : A → PMF B) {s : ℝ} (hs : s < I) :
    Filter.Tendsto (fun n : ℕ =>
      (Jₙ.toOuterMeasure
        (infoDensityThresholdEvent pₙ Wₙ ((n : ℝ) * s))ᶜ).toReal)
      Filter.atTop (nhds 0)
```

The successor index enumerates every positive length and never forms a quotient at zero. Each probability uses that length’s actual law on the pair of word spaces. Only the real probabilities share a codomain across lengths. Additivity includes the empty sum at length zero. The C31 limit uses all natural lengths and every fixed real `s < I`, including negative rates and the case `I = 0`. At length zero the joint and independent laws both assign mass one to the empty pair. The threshold is zero for every real `s`, so the strict comparison fails and the miss has probability one. At positive lengths a tie at `s = I` can also persist.

## Module placement and scope

Create `LeanInfoTheory.Shannon.IidInformationDensity` with direct imports `LeanInfoTheory.Shannon.InformationDensity`, `LeanInfoTheory.Probability.ProductChannel` and `LeanInfoTheory.Shannon.SemanticBridge.AEP`. Expose this owner through the complete `LeanInfoTheory.Shannon` umbrella. A separate owner lets C27 one-shot callers retain their focused dependency closure. Keep the entropy decomposition, specialized law identities, support facts, event bounds and shifts private/local. The proposal adds three mathematical declarations, one supported owner and no simp attributes or root exports. Upon plan approval, record the owner and the full-umbrella import in the reviewed growth policy. Use the exact EPFL/MIL header on new Lean source files.

Permanent callers belong in `LeanInfoTheory.Examples.IidInformationDensity`, imported by the development `Examples` aggregate. They use the new focused owner and, for the uniform fixture, the pinned uniform-distribution import. C27's existing private examples remain independently compilable. C29 owns codebook sampling and the decoder, C30 the one-shot error bound, and C31 coding achievability. This proposal supplies C31's true-pair term.

## Proof route and references

The [C27 handoff](../handoffs/chunk-27.md#c28--word-level-miss-and-supported-self-information) supplies a derivation for C28 to formalize. For one supported pair, C27's support inclusion and `support_indepProd` give positive input and output masses. All PMF atoms are finite, so the three supported atoms have positive real masses. Expand the independent product atom, apply the log quotient/product identities and `selfInfo_of_toReal_ne_zero`. This gives
`infoDensity p W (a,b) = selfInfo p a + selfInfo (p.bind W) b - selfInfo J (a,b)`.
The identity works for arbitrary PMFs with that support premise. Its uses at single-letter and block level justify a private helper.

Write `e` for `Equiv.arrowProdEquivProdArrow`, oriented from a word of pairs to a pair of words. Specialize `PMF.finiteProduct_channelJoint_map` to obtain `(PMF.iid J n).map e = Jₙ`. In the reverse direction `e.symm z` is the zipped pair word. `PMF.map_apply_equiv` identifies its atom with the block atom, hence also support and self-information. `PMF.finiteProduct_bind_productChannel` gives `pₙ.bind Wₙ = PMF.iid (p.bind W) n`. The projection laws follow from `PMF.channelJoint_map_fst` and `PMF.channelJoint_map_snd`. Use `PMF.mem_support_finiteProduct_iff` on the zipped word for coordinate support. Apply `selfInfo_iid_of_mem_support` to the supported input, output and zipped words, distribute the three sums, and use the one-letter identity at each supported pair. [ProductChannel](../../LeanInfoTheory/Probability/ProductChannel.lean) · [C19 AEP](../../LeanInfoTheory/Shannon/SemanticBridge/AEP.lean)

The preferred concentration proof uses C19 three times. For `n > 0`, write `Aₙ(q, δ)` for C19’s real probability under `PMF.iid q n` of `δ ≤ |selfInfo (PMF.iid q n) w / (n : ℝ) - entropy q|`. For `ε > 0`, the private finite-length estimate on this route is

```text
(Jₙ.toOuterMeasure {z | ε ≤ |Dₙ z / (n : ℝ) - I|}).toReal
  ≤ Aₙ(p, ε / 3) + Aₙ(p.bind W, ε / 3) + Aₙ(J, ε / 3).
```

Use the following reverse event identity for the joint term. For every `S : Set (Fin n → (A × B))`,

```lean
Jₙ.toOuterMeasure (e.symm ⁻¹' S) = (PMF.iid J n).toOuterMeasure S
```

Rewrite `Jₙ` with the forward product-law equality and use `PMF.toOuterMeasure_map_apply`. Pulling the event back along `e` gives `e ⁻¹' (e.symm ⁻¹' S) = S`. This identity also holds at length zero. The two marginal probabilities use the projection laws above.

Unfold `mutualInfo J` and rewrite its marginals. On joint support, if all three normalized deviations are strictly less than `ε / 3`, the triangle inequality makes the density deviation strictly less than `ε`. Intersecting the closed density-deviation event with support therefore gives a subset of the union of the three pulled-back events. Use `PMF.toOuterMeasure_mono` and finite subadditivity twice. PMF event masses are at most one, so the finite sums of event masses can be converted to real probabilities. Apply `tendsto_selfInfo_iid_deviation` to the three laws along successors and squeeze. The union bound allows arbitrary dependence between the input and output.

A direct iid-sum argument could use additivity, C27’s `sum_mul_infoDensity_eq_mutualInfo` and a weak law on iid pair words. C19’s existing moment and variance helpers are private and specialized to self-information. A fixed-sample-space weak law would also require transport to these varying word laws. The three-AEP route already supplies the limits and law transports. Its reverse event identity and finite-length estimate are private proof checkpoints for that route. If a shorter proof using existing machinery emerges, record the evidence and reasoning in the step notes. The required statement, focused caller, support and length conventions apply to either proof; the project’s product-law and AEP machinery must be reused where needed.

For the coding-facing limit, fix `s < I` and use the full positive gap `ε = I - s`. C27's `channelJoint_infoDensityThresholdEvent_compl_eq` rewrites the miss probability to the closed sublevel `Dₙ z ≤ (n : ℝ) * s`. At `n = k + 1` this implies `Dₙ z / n ≤ s`, hence `I - s ≤ |Dₙ z / n - I|`, including equality. Squeeze by the deviation probability and use `Filter.tendsto_add_atTop_iff_nat 1` to obtain the stated, unshifted miss sequence. C31 can choose its own `R < s < I` and combine this scalar limit with C30 at the identical law and threshold.

Registered PW24, §19.2, proof of Theorem 19.8, printed p. 376 (PDF 401), factors the stationary memoryless pair law, sums the iid densities and uses the below-MI miss in (19.7). The density and joint mean come from §18.1, Definition 18.1/(18.2) and Proposition 18.2, printed p. 351 (PDF 376). The closed miss is explicit in §18.2, (18.9), printed p. 354 (PDF 379). C27's mass comparison fixes the strict acceptance and the behavior at zero joint mass. CT91 (1991), §3.1, Theorem 3.1.1, printed p. 51 (PDF 73), gives the self-information AEP. Its §8.6, Theorem 8.6.1(1), (8.42)–(8.47), printed pp. 195–196 (PDF 217–218), bounds the union of marginal and joint failures. The noiseless bit example in §8.1.1, printed pp. 184–185 (PDF 206–207), has one bit of mutual information, or `Real.log 2` in project units. The two-sided varying-space statement, its real-probability interface and the finite-length tie check are the project adaptation. [Reference register](../references.md#release-3-planning-locators) · [C28 and C31 programme entries](release-3-chunk-map.md#c28-iid-block-information-density-and-concentration)

For the biased Boolean check, `PMF.ofFintype` already has a private example with the required masses. Use the same constructor locally and compute the mean with C27’s `sum_mul_infoDensity_eq_mutualInfo`. The C28 example can use the focused mathematical import throughout. [Existing iid example](../../LeanInfoTheory/Examples/Iid.lean#L45)

## Ordered steps and acceptance criteria

### C28.01 — Supported block additivity

- **C28.01-SUM** — In the focused owner, prove the private supported self-information decomposition and the public coordinate-sum theorem for the specified iid input and raw memoryless channel. Use the existing product transports and C19 supported theorem. A focused consumer must apply the result to a supported pair of words with the stated projection order and at length zero.
- **C28.01-API** — Match the incoming C27 compiler export and environment before public growth. Add the reviewed focused owner and full-umbrella exposure, regenerate derived inventories, and check the new name through the owner and full umbrella. Preserve the incoming public contracts and lightweight-root boundary.

### C28.02 — Concentration on positive word lengths

- **C28.02-DEVIATION** — Prove the two-sided limit for every `ε > 0` at lengths `n = k + 1`, using the real `Jₙ`-probability of the closed deviation `ε ≤ |Dₙ z / (n : ℝ) - mutualInfo J|` on the actual pair of word spaces. On the preferred three-AEP route, check the reverse joint event transport and finite-length inequality in the proof guidance, then use the three C19 limits. An alternative proof must establish the same public statement and document the existing machinery it reuses.
- **C28.02-CALLER** — Compile a focused caller using the displayed numerical limit for arbitrary finite alphabets, PMF, raw channel and positive width. It must expose the original word law and positive denominator, with a closed absolute-deviation event and single-letter MI in nats.

### C28.03 — The exact C31 miss

- **C28.03-MISS** — Prove the all-natural-index limit for the literal complement of C27's strict event at `(n : ℝ) * s`, for every fixed `s < mutualInfo J`. Use the closed miss rewrite, positive gap and positive-length normalization only inside the proof.
- **C28.03-CALLER** — Compile a permanent private caller from the focused import. Given `s < mutualInfo J`, any `b : ℕ → ℝ` and `Filter.Tendsto b Filter.atTop (nhds 0)`, derive

  ```lean
  Filter.Tendsto (fun n : ℕ =>
    (Jₙ.toOuterMeasure
      (infoDensityThresholdEvent pₙ Wₙ ((n : ℝ) * s))ᶜ).toReal + b n)
    Filter.atTop (nhds 0)
  ```

  This checks composition on C31’s natural index with the literal miss term. C31 supplies the vanishing competing-codeword term when it applies C30.

- **C28.03-EMPTY** — For arbitrary input law, raw channel and `s : ℝ`, check privately at `n = 0` that the same strict-event complement has probability one, using the empty-word laws and the unnormalized threshold.

### C28.04 — Sparse channel and ties

- **C28.04-NOISELESS** — With `PMF.uniformOfFintype Bool` and the deterministic identity channel, check that the joint support is the word diagonal, the single-letter MI is `Real.log 2`, and every supported word pair has density `(n : ℝ) * Real.log 2`. For every positive length, compute the actual strict-event miss as zero for all `s < Real.log 2` and one at equality.
- **C28.04-NULL** — In the private focused example, exercise an impossible pair at length two, input `00`, output `01`. Its joint mass and totalized block density are zero, but the coordinate sum is `Real.log 2`. The independent word-pair law gives it positive mass and the strict mass test excludes it even at a negative threshold. This checks why support matters without adding a second public event or an assertion of additivity at null atoms.
- **C28.04-BIASED** — Reuse the Boolean identity channel with input masses `p false = 3/4` and `p true = 1/4`. Set `s = Real.log (4 / 3)` and prove `s < mutualInfo J`. The two supported densities are `s` and `Real.log 4`, so the joint mean exceeds `s` by `(Real.log 4 - s) / 4 > 0`. At length two, use supported additivity to identify the only supported miss as the all-common input and output pair `(00, 00)`, which ties at `2 * s`. Prove that the literal miss has probability `9/16` and that the open density sublevel has joint probability zero. Apply C28.03 at the same `p, W, s` to obtain the vanishing-miss limit. The exact numerical acceptance check is at length two.

### C28.05 — Cumulative validation, independent review and handoff

- **C28.05-VALIDATE** — Map every approved criterion to its declaration, focused caller and applicable checks. Run cumulative warning-as-error focused builds for the new owner and examples, C19 AEP, ProductChannel, the C27 owner and examples, Shannon and Examples. Check regenerated artifacts non-mutatingly, documentation, both historical compiled baselines, all 839 incoming named compiler records, important focused visibility, exact import/root/simp boundaries and all-project axioms. Run the complete development suite on the expressly authorized, clean, byte-and-pin-matched candidate and repeat after amendment. Account separately for fresh and inherited evidence.
- **C28.05-HANDOFF** — Reconcile the living summary, project log, reference register and step notes. Link a maintained `docs/handoffs/chunk-28.md` giving the three exact signatures, their focused imports, pair/word orientation and blocklength domains. Include the zero-length miss, both uniform and biased tie checks, and C31’s use of the literal miss with a vanishing second term. Record the C27/C29/C30 division of work, outstanding decisions and deferred items. Finish all source and handoff edits before final capture, with closure subject to the private completion record.
- **C28.05-REVIEW** — Complete contextual self-review and separate reassessment, then prepare a fresh neutral cumulative request for the bound reviewer covering every approved criterion on the identified source. Provide the criterion-to-evidence matrix, qualified candidate, handoff and relevant earlier findings so the reviewer can assess the cumulative result.

After dispatch, retain the complete native report, reconcile every finding and assessment, obtain a fresh satisfactory assessment for any criterion gap, resolve corrections and finish document edits before final capture. Repeat the full suite on an amended candidate, check review applicability to the final source and perform supported closure. Give the actual closure reference to the lead and stop.

## Admission, retention and evidence

C27.01–C27.06 have six durable closures. C27.06 closed at `873664f7af839a216cfdcb73f75fcc475155669f928c357e2104a261ed27cf95`, with final source `e2919d335c1ca5139878f598842f051d75f9f5e91667be1fc3aedfad37ebf11d` and qualified clean commit `eb5eee8fd735f239b9922cfb50a5979d89072fae`. Before creating this proposal, the main checkout matched the final inventory, captured bytes, Git state, environment and nine installed pins. All 357 files in the clean-candidate manifest matched by raw SHA-256. The full-suite pass belongs to C27's retained clean record. The main checkout was on `master` at `2eb80d0e746688511618aaefc2624ffa4ae88f6e` with prior local work.

Use the retained 839-record compiler export `.lit-review/setup/c27-06-20261108/main-current-compiler/candidate-types.stdout` (SHA-256 `15ab353eb9c3f3903ec9cab86129b4bd87185e6eb2c3bb6719ee154664f4ed4f`). Compare named records, including elaborated types, binder details, kinds and owners. Retain the original 60 supported modules, the seven C27 names at their focused import and prior C25/C26 testing visibility. The released 601- and 811-declaration comparisons remain independent obligations. The root keeps the direct imports `LeanInfoTheory.Probability.Finite` and `LeanInfoTheory.InformationMeasures`, its five-module closure and 92 exports. Preserve all 94 reviewed simp names. The expected result of this specific proposal is 842 declarations across 61 supported modules. Counts supplement exact checks.

Each selected step has its own baseline, scoped edits, focused builds, applicable generated/static and compiled checks, contextual self-review, separate reassessment, review by the same bound independent reviewer, reconciliation, final validation and closure. Regenerate the current manifest and both website generators after approved public growth and verify the frozen manifest. Run `python scripts/validate_release.py focused <targets>` and `python scripts/validate_development.py static` on the working source. Use the compiled `compatibility` and `trust` gates and the named C27 comparison for public changes. Closeout also runs `python scripts/validate_release.py documentation` and `python scripts/validate_development.py` on the exact clean candidate. Obtain separate authority for a concrete clean checkpoint if needed. Existing main-checkout work stays protected. The expensive signature-bearing API-doc build is a separate milestone. [Compatibility guide](../compatibility/README.md) · [Review protocol](../review-protocol.md) · [Review operations](../review-operations.md)

## Formal plan-review criteria

- **C28-PLAN-MATH** — Assess support, signs, pair-to-word orientation, the two-sided positive-length statement, and the strict event's closed miss at the exact C31 threshold. Compare both proof routes and the registered textbook conventions.
- **C28-PLAN-CONSUMERS** — Assess the focused callers, composition of C31’s literal miss with a vanishing second term, the zero-length miss, the uniform equality obstruction, the impossible-pair witness, and the biased positive tie mass below MI.
- **C28-PLAN-BOUNDARY** — Assess theorem names/owners, assumptions, public growth and retention, import boundaries, validation, review and handoff. Formal review of this revision requires a separate request. Execution requires lead approval of the exact plan and explicit selection of one step.
