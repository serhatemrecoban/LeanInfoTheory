# Chunk 30 — One-shot channel-coding achievability

On finite input and output alphabets, for any natural blocklength `n`, any message count `M` with `hM : 1 ≤ M`, and any input-word PMF `q`, C30 returns a deterministic code at that exact length and budget. Its encoder belongs to `(PMF.iid q M).support`, its decoder is the total acceptance-event decoder, and its released uniform-message error is at most the true-pair miss plus `M - 1` competing-pair pass probabilities. A strict information-density threshold bounds each competing pass by `Real.exp (-t)` for every real `t`. [Approved plan](../plans/release-3-chunk-30.md) · [Criterion matrix and validation attribution](../plans/release-3-chunk-30-notes.md#complete-cumulative-criterion-matrix)

## Focused imports and exact declarations

```lean
import LeanInfoTheory.Shannon.ChannelCodingOneShot

open LeanInfoTheory.Shannon
```

The focused owner imports `LeanInfoTheory.Shannon.RandomCodebook` and `LeanInfoTheory.Shannon.InformationDensity`. All four theorems below are in `LeanInfoTheory.Shannon` and are available through its full umbrella. These are their source headers in the owner's `universe u v` context. [Mathematical owner](../../LeanInfoTheory/Shannon/ChannelCodingOneShot.lean)

### A raw channel and an arbitrary acceptance event

Put `U = Fin n → X`, `V = Fin n → Y`, `P = PMF.iid q M`, `J = PMF.channelJoint q K`, and `Q = indepProd q (q.bind K)`. For each label `m`, C29 samples a book `b` from `P` and an output `y` from `K (b m)`. Write `μ(S)` for `(μ.toOuterMeasure S).toReal`. The event bound is `J(Aᶜ) + ((M : ℝ) - 1) * Q(A)` and may exceed one. The sent pair `(b m,y)` has law `J`. For each other label `j`, the pair `(b j,y)` has law `Q` in the same experiment. Distinct labels may carry the same word. [C29 handoff](chunk-29.md)

```text
theorem mean_codebookOutputLaw_error_le {X : Type u} {Y : Type v} [Fintype X]
    {n M : ℕ} (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) :
    (1 / (M : ℝ)) * (∑ m : Fin M,
      ((codebookOutputLaw q K m).toOuterMeasure
        {z | (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m}).toReal) ≤
      ((PMF.channelJoint q K).toOuterMeasure Aᶜ).toReal +
        ((M : ℝ) - 1) * ((indepProd q (q.bind K)).toOuterMeasure A).toReal

theorem exists_mem_support_codebook_error_le
    {X : Type u} {Y : Type v} [Fintype X] {n M : ℕ}
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) :
    ∃ b ∈ (PMF.iid q M).support,
      (1 / (M : ℝ)) * (∑ m : Fin M,
        ((K (b m)).toOuterMeasure
          {y | (BlockChannelCode.ofAcceptanceEvent b A hM).decoder y ≠ m}).toReal) ≤
        ((PMF.channelJoint q K).toOuterMeasure Aᶜ).toReal +
          ((M : ℝ) - 1) * ((indepProd q (q.bind K)).toOuterMeasure A).toReal
```

The first theorem bounds the real probability of decoder error averaged uniformly over the labels. An error entails a miss at the sent pair or a pass at some other label. The union bound allows all of those passes to share the output. In a three-message example, the two competitors pass together with probability `1/2`. When zero is sent, first-match on a pass and fallback on a miss both decode correctly. The error event is empty even though the union covers the space. [Generic, infinite-output and boundary callers](../../LeanInfoTheory/Examples/ChannelCodingOneShot.lean)

The second theorem returns an actual supported book and bounds its fixed-book row error. Only the book and message sums require finite enumeration, so these two raw-channel theorems allow any output alphabet. Internally the sampled-book-weighted row-error mean equals the ensemble error. A minimum on the nonempty book support is at most that mean. For the length-two prior with masses `3/4` on `00` and `1/4` on `11`, the collision probability is `5/8` and the weighted mean error is `5/16`. The supported minimizing witness must have distinct words and zero error, since a collision costs `1/2`. [Sparse selection caller](../../LeanInfoTheory/Examples/ChannelCodingOneShotSparse.lean)

### A memoryless channel and the released code error

```text
theorem exists_blockChannelCode_errorProbability_le_of_acceptanceEvent
    {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n M : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y)
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) :
    ∃ c : BlockChannelCode X Y n M,
      c.encoder ∈ (PMF.iid q M).support ∧
      c = BlockChannelCode.ofAcceptanceEvent c.encoder A hM ∧
      c.errorProbability W hM ≤
        ((PMF.channelJoint q (PMF.memorylessChannel W n)).toOuterMeasure Aᶜ).toReal +
          ((M : ℝ) - 1) *
            ((indepProd q (q.bind (PMF.memorylessChannel W n))).toOuterMeasure A).toReal

theorem exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold
    {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n M : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y) (t : ℝ) (hM : 1 ≤ M) :
    ∃ c : BlockChannelCode X Y n M,
      c.encoder ∈ (PMF.iid q M).support ∧
      c = BlockChannelCode.ofAcceptanceEvent c.encoder
        (infoDensityThresholdEvent q (PMF.memorylessChannel W n) t) hM ∧
      c.errorProbability W hM ≤
        ((PMF.channelJoint q (PMF.memorylessChannel W n)).toOuterMeasure
          (infoDensityThresholdEvent q (PMF.memorylessChannel W n) t)ᶜ).toReal +
            ((M : ℝ) - 1) * Real.exp (-t)
```

For `K = PMF.memorylessChannel W n`, the fixed book becomes the encoder of `BlockChannelCode.ofAcceptanceEvent b A hM`. Expanding the row-event masses gives that code's `errorProbability W hM` for each book. Relaxing the event bound at the threshold preserves the witness, its membership in the actual sampling support and its decoder. The two code theorems require finite input and output alphabets. The generic caller separately checks expected released error via C29's averaging equality. A one-message code has error zero. At length zero the error is `1 - 1/(M : ℝ)`, including when both base alphabets are empty. [Released code and error](../../LeanInfoTheory/Shannon/ChannelCode.lean) · [Fixed-parameter callers](../../LeanInfoTheory/Examples/ChannelCodingOneShot.lean)

C27 defines acceptance on the entire pair space by the strict real-mass comparison `Real.exp t * (Q z).toReal < (J z).toReal`. Equality and zero-joint atoms fail, including at negative thresholds. The log-density equivalence is valid on joint support, and the literal complement has the same **joint mass** as the closed log-density sublevel. C31 can use the literal complement as supplied. [Information-density owner](../../LeanInfoTheory/Shannon/InformationDensity.lean)

## The two numerical checks

Both fixtures call the acceptance-event theorem once, retain the exact decoder and supported encoder, and derive both inequalities for that code. Each also calls the public threshold theorem separately.

| One use, two uniform messages | Global strict pass event | True miss | Competing pass | Exponential estimate for a competing pass | Upper bounds on the selected code's error |
| --- | --- | ---: | ---: | ---: | --- |
| Binary symmetric channel, crossover `1/8`, uniform input, `t = log(3/2)` | Equal bits | `1/8` | `1/2` | `2/3` | `5/8` and `19/24` |
| Noiseless ternary channel, input `(3/8,3/8,1/4)`, `t = log(5/2)` | Equal symbols | `0` | `11/32` | `2/5` | `11/32` and `2/5` |

Each binary diagonal atom of `J` has mass `7/16`, and each off-diagonal atom has mass `1/16`. Every atom of `Q` has mass `1/4`. In the ternary fixture the diagonal likelihood ratios are `8/3, 8/3, 4`. At `t = log(8/3)`, symbols zero and one give positive-mass ties. Only the pair `(2,2)` passes, so `J(Aᶜ) = 3/4` and `Q(A) = 1/16`. For two uniform messages every constant decoder has error exactly `1/2`, independently of its encoder or chosen output label. Both ternary guarantees at `log(5/2)` lie strictly below that error. [Binary calculation](../../LeanInfoTheory/Examples/ChannelCodingOneShotBinary.lean) · [Ternary calculation and comparison](../../LeanInfoTheory/Examples/ChannelCodingOneShotTernary.lean)

The ternary sampling prior gives positive mass to all three words. The image of an encoder on `Fin 2` contains at most two words. Its pushforward of the uniform message law therefore cannot equal that prior. Membership in `P.support` says that the book can occur under sampling. It permits collisions and arbitrary dependence among the letters within each sampled word.

## Finite caller and choices for C31

The following code is the permanent finite consumer, from its first import through the end of its namespace. The first example keeps the supplied length and takes any bound `μ` on the literal miss. The second applies C28 to that same miss function. The finite guarantee takes every `n : ℕ` and `R s : ℝ`. [Compiling C31-style caller](../../LeanInfoTheory/Examples/ChannelCodingOneShotFinite.lean) · [C28 handoff](chunk-28.md)

<!-- c30-c31-caller:start -->
```lean
import LeanInfoTheory.Shannon.ChannelCodingOneShot
import LeanInfoTheory.Shannon.IidInformationDensity
import LeanInfoTheory.Shannon.CodingRate

/-!
# One-shot codes at a rounded message budget

At each given length, the supported threshold code accepts an upper bound on the
miss under the iid-input joint law. The second caller identifies that same miss
as the quantity controlled by iid information-density concentration.
-/

namespace LeanInfoTheory.Examples.ChannelCodingOneShotFinite

open LeanInfoTheory.Shannon

universe u v

variable {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] (p : PMF X) (W : X → PMF Y)

private noncomputable abbrev miss (n : ℕ) (s : ℝ) : ℝ :=
  ((PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).toOuterMeasure
    (infoDensityThresholdEvent (PMF.iid p n) (PMF.memorylessChannel W n) ((n : ℝ) * s))ᶜ).toReal

example (n : ℕ) (R s μ : ℝ) (hmiss : miss p W n s ≤ μ) :
    ∃ c : BlockChannelCode X Y n (roundedMessageSize n R),
      c.encoder ∈ (PMF.iid (PMF.iid p n) (roundedMessageSize n R)).support ∧
      c = BlockChannelCode.ofAcceptanceEvent c.encoder
        (infoDensityThresholdEvent (PMF.iid p n) (PMF.memorylessChannel W n) ((n : ℝ) * s))
        (roundedMessageSize_bounds n R).1 ∧
      c.errorProbability W (roundedMessageSize_bounds n R).1 ≤
        μ + ((roundedMessageSize n R : ℝ) - 1) * Real.exp (-((n : ℝ) * s)) := by
  obtain ⟨c, hsupp, hdecoder, herror⟩ :=
    exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold
      (q := PMF.iid p n) (W := W) (t := (n : ℝ) * s) (hM := (roundedMessageSize_bounds n R).1)
  exact ⟨c, hsupp, hdecoder, herror.trans (add_le_add hmiss le_rfl)⟩

example {s : ℝ} (hs : s < mutualInfo (PMF.channelJoint p W)) :
    Filter.Tendsto (fun n : ℕ => miss p W n s) Filter.atTop (nhds 0) :=
  tendsto_prob_infoDensityThresholdEvent_iid_compl p W hs

end LeanInfoTheory.Examples.ChannelCodingOneShotFinite
```
<!-- c30-c31-caller:end -->

For a nonnegative target `R < channelCapacity W`, C31 can choose one input law `p` with `R < mutualInfo (PMF.channelJoint p W)` and a single `s` strictly between them. The capacity API supplies `exists_mutualInfo_channelJoint_eq_channelCapacity` for finite alphabets and nonempty input. The strict ceiling estimate in `roundedMessageSize_bounds` gives `(M : ℝ) - 1 < Real.exp ((n : ℝ) * R)`. At threshold `n*s`, the false-match term is bounded by `exp(-n*(s-R))`. The fixed positive gap makes it vanish. Use C28 for the true miss and select one dependent code family, one code per length, before quantifying over tolerances. At positive lengths `codeRate_roundedMessageSize_bounds` supplies the required lower rate for `R ≥ 0`. The singleton family covers rate zero at zero capacity. C31 owns the operational predicate, both limits, the least-upper-bound result, and checks on positive- and zero-capacity channels. Its converse can use C23's `eventually_codeRate_le_channelCapacity_add` on that same family. [C31 contract](../plans/release-3-chunk-map.md#c31-finite-memoryless-channel-coding-and-operational-capacity) · [Capacity attainment](../../LeanInfoTheory/Shannon/ChannelCapacity.lean) · [Rounded budgets](../../LeanInfoTheory/Shannon/CodingRate.lean) · [Tolerance converse](../../LeanInfoTheory/Shannon/ChannelCodingAsymptotic.lean)

## Source adaptation, package assessment and qualification

PW24 §18.1, Corollary 18.4, printed p. 353, gives the independent-pair tail. Section 18.2, Theorem 18.5 and its proof, pp. 354–355, gives the random-book argument and selection of a realization. Display (18.10) uses weak acceptance, a unique match and an erasure. The probability estimate on the following page uses strict pass and closed miss. Here the total first-match decoder and the globally strict comparison give error-event containment at every label. PW24 §18.3, Theorem 18.6's proof, p. 356, gives the first-match precedent. CT91 §8.5, (8.28)–(8.32), pp. 193–194, fixes uniform-message error, and §8.7, proof of Theorem 8.7.1, pp. 199–202, averages over books and selects a realization. C30 preserves all labels, permits correlated word priors, and makes sample support explicit. The numerical fixtures and sparse selection check are project calculations. C30.06's read-only reference support freshly matched both registered PDF hashes and checked these bounded passages as text; this adds no new visual formula audit. [Registered editions and prior passage checks](../references.md)

**Package 2 effort reassessment.** C29's whole-experiment pushforwards eliminated a fresh factorization proof for each competitor. C30's principal added work was moving between ensemble, row and released error while preserving the very same book. The sparse regression exposed why selection at the weighted mean matters. The literal threshold, rounded budget and concentration interfaces now meet in a finite caller. C31's remaining proof work is the choice of input and rate margin, forming one family with dependent code types, the exponential limit and matching the operational converse.

Keep the four theorem names under their focused owner. The long released-error names expose the outcome and differentiate the event and threshold arguments. Seek evidence from real C31 callers or downstream search friction before considering aliases. Earlier-rival counting, dependence-testing or Feinstein refinements need a concrete request for tighter finite error. A public generic PMF selector, row-error scalar or constant-decoder theorem needs a second consumer. Per-message guarantees and expurgation belong to C32. API-documentation generation, release and publication have separate authority. [Step notes](../plans/release-3-chunk-30-notes.md) · [API feedback](../downstream-api-feedback.md)

Four additions bring the supported inventory from 848 to 852 declarations in 63 modules. The lightweight root has two direct imports, a five-module closure and 92 exports. There are 94 reviewed simp names. All five focused examples are development consumers. C30.01–C30.05 have original reviews, parent reconciliation and scoped completion records in `.lit-review/setup/c30-NN-20261111/`. C30.05 closed at `3a4881d28e89a4a842c78072410278fde7459690a5feec50f053f96cac35d533`. C30.03's 852/848 named comparison, both released 601/811 contracts and focus/root/simp checks have their original source attribution. C30.04–05 separately checked applicability on their supported byte slice, compiled their new consumers and ran their own axiom audits. C30.06 has distinct obligations for fresh cumulative checks, a separately qualified clean candidate, fresh original independent review, reconciliation and final-source applicability. The selected closeout has three formal review criteria. Its new evidence must assess all fourteen approved criteria anew against the cumulative source, permanent consumers and applicable checks. Its supported closure follows `.lit-review/setup/c30-06-20261111/completion.json` when established.
