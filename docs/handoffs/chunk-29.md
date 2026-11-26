# Chunk 29 — Random codebooks and a total decoder

C30 can use one experiment for the sent pair, every competing pair and the actual decoder error. Given a finite blocklength, positive message count, arbitrary law on input words and a memoryless channel, C29 identifies uniform-message ensemble error with the expectation of released code error over random books. C29.01–C29.04 have supported closure records. C29.04 closed at `1f4f7c5d2e420dd0b54feec901d5361fc5a544c4545dbfbb8b2011ecc27199a8`. C29.05 is the cumulative validation, independent-review and handoff step. Its actual completion follows `.lit-review/setup/c29-05-20261110/completion.json` when established. [Approved plan](../plans/release-3-chunk-29.md) · [Criterion matrix and evidence attribution](../plans/release-3-chunk-29-notes.md)

## Focused imports

Import `LeanInfoTheory.Shannon.RandomCodebook` and open `LeanInfoTheory.Shannon`. Threshold callers also import `LeanInfoTheory.Shannon.InformationDensity`. The full `LeanInfoTheory.Shannon` umbrella exports all six C29 declarations. The code below copies their source headers in the owner's `universe u v` context. The two declarations grouped under `BlockChannelCode` are in that namespace. [Mathematical owner](../../LeanInfoTheory/Shannon/RandomCodebook.lean) · [Permanent focused consumers](../../LeanInfoTheory/Examples/RandomCodebook.lean)

## One sampled book and one output

Write `U = Fin n → X`, `V = Fin n → Y` and `Book = Fin M → U` in this handoff. The encoder is indexed, so duplicate words keep their original message labels. `P = PMF.iid q M` draws one complete word independently from `q` at each message index. Dependence among letters inside one word is arbitrary. For a fixed `m : Fin M`, write `L m = codebookOutputLaw q K m`. The atom `(b,y)` has mass `P b * K (b m) y`. All candidate pairs in this experiment use that same sampled output `y`.

```lean
def codebookOutputLaw {X : Type u} {Y : Type v} [Fintype X] {n M : ℕ}
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y)) (m : Fin M) :
    PMF ((Fin M → Fin n → X) × (Fin n → Y))

theorem codebookOutputLaw_map_sentOutput {X : Type u} {Y : Type v} [Fintype X]
    {n M : ℕ} (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (m : Fin M) :
    (codebookOutputLaw q K m).map (fun z => (z.1 m, z.2)) = PMF.channelJoint q K

theorem codebookOutputLaw_map_competingOutput {X : Type u} {Y : Type v} [Fintype X]
    {n M : ℕ} (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (m j : Fin M) (hjm : j ≠ m) :
    (codebookOutputLaw q K m).map (fun z => (z.1 j, z.2)) =
      indepProd q (q.bind K)
```

The two ordered pushforwards are PMF equalities. The sent pair `(b m,y)` has law `J = PMF.channelJoint q K`. Each competitor `(b j,y)` with `j ≠ m` has law `Q = indepProd q (q.bind K)`. The output marginal comes from the channel applied to the **sent** word. The proof projects the book to `(b j,b m)`, uses the two-coordinate product law, then sends its second coordinate through `K`. The one-coordinate sent projection uses `PMF.finiteProduct_map_eval`. The competing projection uses `PMF.finiteProduct_map_pair` and `PMF.channelExtension_map_endpoints`. [Finite products](../../LeanInfoTheory/Probability/FiniteProduct.lean) · [Raw channel laws](../../LeanInfoTheory/Probability/FiniteChannel.lean)

The fixed index already witnesses positive `M`. The book sampler and both projections use `[Fintype X]` and allow any type `Y`, any raw channel `K`, and every natural `n`. Event transport takes the preimage under the relevant projection and applies `PMF.toOuterMeasure_map_apply`. A permanent caller instantiates the competing transport with `n = 1`, `M = 2` and `Y = ℕ`.

## First passing index and total fallback

```lean
def ofAcceptanceEvent {X : Type u} {Y : Type v} {n M : ℕ}
    (b : Fin M → Fin n → X) (A : Set ((Fin n → X) × (Fin n → Y)))
    (hM : 1 ≤ M) : BlockChannelCode X Y n M

theorem decoder_ofAcceptanceEvent_eq_of_unique {X : Type u} {Y : Type v} {n M : ℕ}
    (b : Fin M → Fin n → X) (A : Set ((Fin n → X) × (Fin n → Y)))
    (hM : 1 ≤ M) (m : Fin M) (y : Fin n → Y) (hm : (b m, y) ∈ A)
    (hother : ∀ j, j ≠ m → (b j, y) ∉ A) :
    (ofAcceptanceEvent b A hM).decoder y = m
```

For a realized `b` and an event `A : Set (U × V)`, write `C b = BlockChannelCode.ofAcceptanceEvent b A hM`. The encoder is definitionally `b`. The decoder filters `Finset.univ : Finset (Fin M)` by `(b i,y) ∈ A`. Its least passing index wins. The empty passing set gives `⟨0,hM⟩ : Fin M`. Classical membership makes this deterministic function total on every output, including outputs of mass zero. Neither alphabet needs a finiteness or inhabitance instance at the constructor or unique-pass theorem. The released `BlockChannelCode` is the original encoder/decoder pair at the caller's `n` and `M`. [Released code and error](../../LeanInfoTheory/Shannon/ChannelCode.lean)

**When the sent index passes**, the set is nonempty and its minimum is at most `m`. It equals `m` precisely when every `j < m` fails. A later pass has no effect in this branch. Without the sent-pass hypothesis, the fallback can return the sent index even after a miss. The public unique-pass implication supplies a sufficient success condition for C30. A concrete book `(0,1,1)` with equality acceptance at output `1` has two passing indices, `1` and `2`, and returns `1`. An empty passing set returns `0` even when index `1` was transmitted. With `M = 1` every output decodes to the sole index.

The literal threshold event `infoDensityThresholdEvent q K t` compares `Real.exp t * (Q z).toReal < (J z).toReal` on the entire pair space. Equality and all zero-joint atoms fail this strict test. C27 gives a log comparison on joint support, identifies the complementary mass with the closed density sublevel under `J`, and bounds the independent-law threshold mass by `Real.exp (-t)` for finite alphabets. C29's decoder takes this set directly. Randomized testing and iid concentration introduce no decoder premises. [C27 handoff](chunk-27.md)

## Uniform error and C30's compiling caller

```lean
theorem mean_codebookOutputLaw_error_eq_mean_errorProbability
    {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n M : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y)
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) :
    (1 / (M : ℝ)) * (∑ m : Fin M,
      ((codebookOutputLaw q (PMF.memorylessChannel W n) m).toOuterMeasure
        {z | (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m}).toReal) =
      ∑ b : Fin M → Fin n → X, (PMF.iid q M b).toReal *
        (BlockChannelCode.ofAcceptanceEvent b A hM).errorProbability W hM
```

Here `W : X → PMF Y`, `K = PMF.memorylessChannel W n`, and the error event for fixed `m` is `{z : Book × V | (C z.1).decoder z.2 ≠ m}`. The left side uses the decoder of the same sampled book that supplied the channel input. It averages real event masses with uniform weight `1/M` over the original indices. The right side weights each realized code's released `errorProbability W hM` by `(P b).toReal`. Both alphabets have `Fintype` instances for the finite sums. The proof expands each mass with `PMF.toOuterMeasure_toReal_eq_sum`, factors the book weight, exchanges finite sums, and applies `BlockChannelCode.errorProbability_eq_sum` to the realized code. It preserves `q`, `W`, `n` and `M`. The fixed code's actual encoded input law is its encoder pushforward of the uniform message law and can differ from `q`.

C30 supplies an upper bound for each fixed-message event on exactly this space. Here is the existing focused caller in full, with the same namespace and universes as above. The output is a bound on the expected released error. The normalization uses `hM` and allows an arbitrary real `r`. [Compiling caller and boundary cases](../../LeanInfoTheory/Examples/RandomCodebook.lean)

```lean
example {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n M : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y) (t r : ℝ) (hM : 1 ≤ M) :
    let K := PMF.memorylessChannel W n
    let A := infoDensityThresholdEvent q K t
    (∀ m : Fin M, ((codebookOutputLaw q K m).toOuterMeasure
      {z | (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m}).toReal ≤ r) →
      ∑ b : Fin M → Fin n → X, (PMF.iid q M b).toReal *
        (BlockChannelCode.ofAcceptanceEvent b A hM).errorProbability W hM ≤ r := by
  intro K A h
  rw [← mean_codebookOutputLaw_error_eq_mean_errorProbability]
  calc
    _ ≤ (1 / (M : ℝ)) * ∑ _m : Fin M, r :=
      mul_le_mul_of_nonneg_left (Finset.sum_le_sum fun m _ => h m) (by positivity)
    _ = r := by
      have hMr : (M : ℝ) ≠ 0 := by exact_mod_cast (show M ≠ 0 by omega)
      simp [nsmul_eq_mul, hMr]
```

The boundary callers use the same public equality with `BlockChannelCode.errorProbability_one` and `BlockChannelCode.errorProbability_zero`. Uniform ensemble error is zero at `M = 1` and equals `1 - 1 / (M : ℝ)` at `n = 0`, including empty base alphabets wherever the stated laws exist.

## Checks that distinguish the two averaging laws

**Fixed book versus ensemble.** At length one with a uniform binary input and noiseless channel, fix the ordered book `(0,1)` and send index `0`. The competing output pair, evaluated as bits, is surely `(1,0)`. Before fixing the book, the same pair under `L 0` has mass `1/4` at each of the four bit pairs. This also tests collisions allowed by independent book sampling.

**Asymmetric channel.** At length one and `M = 2`, take input masses `q(0) = 3/4`, `q(1) = 1/4`. The row at `0` is pure `0`, and the row at `1` is uniform. Thus `q.bind K` gives output masses `7/8, 1/8`. For transmitted index `0` and competitor `1`, the atom `(0,1)` has sent mass zero and competing mass `3/32`. With **equality** as the acceptance event, the four realized codes have the following original-index errors.

| Ordered book | Book mass | Error sending 0 | Error sending 1 | Released uniform error |
| --- | ---: | ---: | ---: | ---: |
| `(0,0)` | 9/16 | 0 | 1 | 1/2 |
| `(0,1)` | 3/16 | 0 | 1/2 | 1/4 |
| `(1,0)` | 3/16 | 1/2 | 0 | 1/4 |
| `(1,1)` | 1/16 | 0 | 1 | 1/2 |

The two fixed-index ensemble errors are `3/32` and `23/32`. Their uniform mean is `13/32`. Independently weighting the released errors by the displayed book masses gives `13/32`. Giving all four supported books equal weight would give `3/8`.

**Dependent letters and a literal threshold.** At `n = 2` repeat one biased bit to give `q(00) = 3/4` and `q(11) = 1/4`, with mixed words of mass zero. Use the memoryless identity channel, `M = 2` and C27's literal event at `t = 0`. Its only passes are `(00,00)` and `(11,11)`. Each supported book of distinct words has released error zero. A collision has released error `1/2` and ensemble probability `5/8`. The four supported books therefore have weighted error `5/16`, which the public equality transfers to uniform-message ensemble error. [Permanent numerical consumers](../../LeanInfoTheory/Examples/RandomCodebook.lean)

## C30 and C31

C30 owns the pointwise inclusion of the error event in the union of a sent-pair miss and the competitor-pass events for `j ≠ m`. The two PMF pushforwards supply their respective marginal probabilities. The required C30 bound is `J(Aᶜ) + (M−1) Q(A)`, where the notation here means real event masses. A union bound permits dependence among the competing events. C30 must extract a book in `P.support` whose realized deterministic code achieves the bound at the original `n,M,W,hM`. C27's `indepProd_infoDensityThresholdEvent_le` supplies the threshold relaxation `(M−1) exp(-t)`. [C30 programme contract](../plans/release-3-chunk-map.md#c30-one-shot-achievability)

First-match order leaves a possible refinement for C30. For fixed `m` there are `m.val` strictly earlier indices. The decoder argument that only an earlier competitor can defeat `m` assumes `m` passes. The **count** averages over the original uniform message indices and has mean `((M : ℝ) - 1) / 2`. A sharper probability bound based on this count is a separate C30 decision. C29's six declarations contain the two projections, success implication and error identity used above.

C30's binary symmetric fixture uses crossover `1/8`, uniform input, `M = 2` and `exp(t) = 3/2`. The event bound should be `5/8` and the exponential relaxation `19/24`. Its second fixture uses a noiseless ternary channel, `q = (3/8,3/8,1/4)`, `M = 2` and `exp(t) = 5/2`. The strict test accepts precisely the diagonal, with miss zero and `Q(A) = 11/32`. The relaxed bound `2/5` is strictly below the constant-decoder error `1/2`. These numbers are checks for C30's future inequalities.

C31 may specialize `q = PMF.iid p n` and choose `R < s < mutualInfo (PMF.channelJoint p W)`. C28's `tendsto_prob_infoDensityThresholdEvent_iid_compl` controls exactly the literal complementary event at unnormalized threshold `(n : ℝ) * s` under this iid-input/memoryless-channel joint. C30 must supply a good code at the caller's rounded positive budget. C31 chooses one code per length into a single family and proves the rate and vanishing-error assertions. [C28 handoff](chunk-28.md) · [C31 programme contract](../plans/release-3-chunk-map.md#c31-finite-memoryless-channel-coding-and-operational-capacity)

## Source adaptation, compatibility and validation

PW24 §18.2, Theorem 18.5's proof, printed pp. 354–355 / PDF 379–380, gives independent whole-codeword draws, a fixed sent label and step (a)'s competing pair. Its display (18.10) uses a weak comparison, a unique match and an external erasure. Section 18.3, Theorem 18.6's proof, printed p. 356 / PDF 381, gives the least-passing-index precedent. CT91 §8.5, (8.28)–(8.32), printed pp. 193–194 / PDF 215–216, gives deterministic codes and uniform average error. Section 8.7, proof of Theorem 8.7.1, printed pp. 199–201 / PDF 221–223, averages over random books and messages with coordinate-iid words and a joint-typicality test. The finite PMF construction with arbitrary `q`, global C27 event, valid fallback and explicit averaging over every message is the project adaptation. The C29.05 reference helper rechecked the local registered hashes and these targeted passages as text. CT91's scanned double-average display is partly absent from text extraction. The adjacent prose supplies the averaging convention. [Reference register](../references.md)

The focused owner imports `LeanInfoTheory.Probability.TotalVariation` and `LeanInfoTheory.Shannon.ChannelCode`. C29 adds six names and one supported module, bringing the surface to 848 declarations in 62 modules. C28's 842 incoming named records and the released 601 and 811 baselines are separate comparisons. The lightweight root keeps its two direct imports `Probability.Finite` and `InformationMeasures` under `LeanInfoTheory`, its five-module closure, and 92 exports. The 94 reviewed `simp` names are preserved. Step 4's approved TotalVariation import adds 25 existing names to the focused owner's visibility alongside its new theorem. The focused example module stays in the development `Examples` aggregate. [Compatibility guide](../compatibility/README.md)

Two independent documentation findings led to precise wording about a distinct **index** in Step 2 and independent **codeword draws** in Step 4. Their original reviews, corrections and source qualifications remain separate. At Step 4, focused/static checks and a fresh 848-row compiler export qualified the final documentation change against full trust and named retention at the reviewed source. Cumulative main checks and the full development suite on a separately authorized, clean, byte-and-pin-matched candidate require their own records. Each candidate amendment requires the complete rerun. Cumulative independent review, reconciliation and scoped closure likewise use their own records. [Complete criterion matrix and step evidence](../plans/release-3-chunk-29-notes.md)

No further public mathematical or naming decision is needed for these six endpoints. A generic sampling structure, additional aliases, a public least-index characterization and a sharper one-shot inequality remain deferred until a concrete consumer needs them. API-documentation generation, publication and later chunk selections are separate milestones.
