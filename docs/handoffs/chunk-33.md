# Chunk 33 — Direct lossless source–channel separation

For a finite iid source and a finite memoryless channel, one channel use per source symbol suffices for vanishing block reconstruction error when the source entropy is strictly below capacity. One encoder family and one decoder family work at every natural blocklength. C34 can evaluate the same error for any deterministic joint code. [Approved C33 plan](../plans/release-3-chunk-33.md) · [Step notes](../plans/release-3-chunk-33-notes.md) · [C32 handoff](chunk-32.md)

## The three supported declarations

For C34's error definition and the finite composition bound, import `LeanInfoTheory.Shannon.SourceChannelCode`. Its direct imports are `Shannon.SourceCoding` and `Shannon.ChannelCodeExpurgation` under the project prefix. For the direct theorem, import `LeanInfoTheory.Shannon.SourceChannelSeparation`. Its direct imports are the finite owner, `Shannon.SourceCodingAsymptotic`, `Shannon.OperationalCapacity` and `Shannon.OperationalExpurgation`. The full Shannon umbrella exports both owners. The projection identity, restriction comparisons and concrete calculations below are proved in development examples. [Finite owner](../../LeanInfoTheory/Shannon/SourceChannelCode.lean) · [Asymptotic owner](../../LeanInfoTheory/Shannon/SourceChannelSeparation.lean)

In the following signatures, `Word A n` abbreviates `Fin n → A` for display. The namespace is `LeanInfoTheory.Shannon`. The types `S`, `X` and `Y` have independent universes. The finite interface assumes `[Fintype S] [Fintype Y]`. The direct theorem also assumes `[Fintype X] [Nonempty X]`.

```lean
sourceChannelErrorProbability (p : PMF S) (W : X → PMF Y) (n : ℕ)
    (E : Word S n → Word X n) (D : Word Y n → Word S n) : ℝ

sourceChannelErrorProbability_comp_le {n K : ℕ} (p : PMF S) (W : X → PMF Y)
    (a : BlockSourceCode S n K) (b : BlockChannelCode X Y n K) :
  sourceChannelErrorProbability p W n (b.encoder ∘ a.encoder) (a.decoder ∘ b.decoder) ≤
    a.errorProbability (PMF.iid p n) +
      b.errorProbabilityWithPrior W ((PMF.iid p n).map a.encoder)

exists_sourceChannelCode_tendsto_errorProbability_zero
    (p : PMF S) (W : X → PMF Y) (h : entropy p < channelCapacity W) :
  ∃ (E : ∀ n : ℕ, Word S n → Word X n) (D : ∀ n : ℕ, Word Y n → Word S n),
    Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n)) atTop (nhds 0)
```

## The two laws C34 needs

Fix arbitrary total `E : Word S n → Word X n` and `D : Word Y n → Word S n`. Set `q := PMF.iid p n`, `Wn := PMF.memorylessChannel W n` and `J := PMF.channelJoint q (fun s => Wn (E s))`. Its atom at `(s,y)` is `q s * Wn (E s) y` and `J.map Prod.fst = q`. The error is `decodingErrorProbability J D`, the sum of the real masses of the atoms with `D y ≠ s`. Both maps are arbitrary, including on words of probability zero. The following examples compile for an arbitrary input type `X`. [Finite law and Fano consumer](../../LeanInfoTheory/Examples/SourceChannelCode.lean#L44) · [Projection consumer](../../LeanInfoTheory/Examples/SourceChannelCode.lean#L65)

```lean
condEntropy J ≤ Real.log 2 +
  sourceChannelErrorProbability p W n E D * Real.log (Fintype.card (Fin n → S) : ℝ)

J.map (fun z => (E z.1, z.2)) = PMF.channelJoint (q.map E) Wn
```

The first display is `condEntropy_fano_weak J D` by unfolding the shared error. The second preserves the actual output while aggregating source words sent to the same input. With finite input alphabet and `[Nonempty X]`, `mutualInfo_channelJoint_memorylessChannel_le W n (q.map E)` bounds the mutual information of the **right-hand joint** by `(n : ℝ) * channelCapacity W` for every natural `n`. Its input prior can be correlated across uses. [Finite Fano](../../LeanInfoTheory/Shannon/Fano.lean#L695) · [Block capacity](../../LeanInfoTheory/Shannon/ProductChannelCapacity.lean#L97)

C34's remaining mathematical step is to use the dependence `s → E s → y` to bound `mutualInfo J` by that input/output mutual information. Merely mapping the first coordinate gives the usual deterministic data-processing inequality in the opposite direction. The actual channel row depending only on `E s` is essential. With `entropy_iid p n`, the first marginal and `mutualInfo_eq_entropy_fstMarginal_sub_condEntropy`, the intended finite bound is

```text
n H(p) ≤ n C(W) + log 2 + Pe(n) · n · log |S|.
```

C34 should quantify over every pair of word-map families, then take a vanishing-error hypothesis. Divide by `n` only on the positive-length tail. The term involving the fixed `log |S|` tends to zero even for a singleton source, as does `log 2 / n`. At length zero the empty word is recovered, and every length has zero error for a singleton source. The proposed examples pair a positive-entropy source with a constant-output channel and exercise a singleton separately. The planned weak converse concludes `entropy p ≤ channelCapacity W`. Neither chunk settles achievability at equality. C34 needs its own approved plan and step selection. [Iid entropy](../../LeanInfoTheory/Shannon/SemanticBridge/FiniteProduct.lean#L102) · [MI identity](../../LeanInfoTheory/Shannon/InfoMeasures.lean#L1083) · [C34 scope](../plans/release-3-chunk-map.md#c34-separation-converse-for-arbitrary-joint-codes)

## Composition and the fitting tail

For a source code `a` and an exact-budget channel code `b`, put `π := q.map a.encoder`. At an atom `(s,y)`, source recovery at `a.encoder s` together with correct channel decoding of that index ensures reconstruction. Summing the indicator inequality under `J` gives source error plus `∑ j, (π j).toReal * b.messageErrorProbability W j`. Source-word collisions add mass to the same prior atom. Unused labels have zero weight. Both failures can occur on the same outcome.

For `b := C.restrictMessages i j₀`, an arbitrary embedding `i : Fin K ↪ Fin L` and a fallback `j₀ : Fin K`, the encoder transmits `C.encoder (i j)`. The decoder inverts `i` on its image and returns `j₀` on discarded decoded labels. The finite caller bounds reconstruction by source error plus the induced-prior error of `b`. The latter is at most the weighted original-row error `∑ j, (π j).toReal * C.messageErrorProbability W (i j)` and hence at most the maximum over embedded original labels. For positive budgets it is also bounded by the maximum for `b`, which is at most the full maximum for `C`. The source error is added in each reconstruction bound. C32 supplies the public row and finite-maximum theorems from which these comparisons follow. [Restriction caller](../../LeanInfoTheory/Examples/SourceChannelCode.lean#L146) · [C32 row API](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean)

Choose `H(p) < r_s < r_c < C(W)`. Open the released source theorem once at `r_s` for a vanishing-error family with positive budgets `K n`. Open C31's achievability witness at `r_c`, which is nonnegative by `entropy_nonneg p`. C32 expurgates that witness into one positive full retained family `L,hL,B` with vanishing maximal error. The C32 example for exact budgets assumed a fit at every length. The C33 theorem proves its own eventual fit from the source upper rate and the retained lower rate at `δ = (r_c − r_s)/2`. On the positive-length intersection, `codeRate n (K n) ≤ r_s < r_c − δ ≤ codeRate n (L n)`. Exponentiating using `codeRate_le_iff` and `exp_mul_codeRate` gives `K n ≤ L n`. Only `L` carries the retained lower rate floor. [Released source family](../../LeanInfoTheory/Shannon/SourceCodingAsymptotic.lean#L150) · [C31 achievability](../../LeanInfoTheory/Shannon/OperationalCapacity.lean#L66) · [C32 full family](../../LeanInfoTheory/Shannon/OperationalExpurgation.lean#L33) · [C32 example](../../LeanInfoTheory/Examples/OperationalExpurgation.lean#L29)

At each positive fitting length restrict `B n` along `Fin.castLEEmb hfit` to exactly `K n` with fallback source index zero. Compose its encoder after the source encoder and its decoder before the source decoder. At every exceptional length the encoder sends the retained codeword of index zero and the decoder returns the source reconstruction at source index zero. Positivity of both budgets supplies the words. Both equations hold for the one selected pair, including the exceptional zero-length case. On the fitting tail C33.02 bounds its error by source error plus the restricted code's induced-prior error, then by source error plus its maximum and finally by source error plus the full retained maximum. The last two component limits and nonnegativity give the eventual squeeze. [Branch equations and limit](../../LeanInfoTheory/Shannon/SourceChannelSeparation.lean#L60)

## Permanent numerical checks

| Experiment | Calculation under the actual laws |
|---|---|
| Total maps and null outputs | At length one, two equally likely Boolean words encode to the same unit input. Output zero is certain. The reconstruction differs on impossible output one and error is exactly one half. |
| Proper restriction | Retaining old collision labels 0 and 1 gives embedded maximum zero and original full maximum one. Output 2 has zero mass from either retained input. Its old decoder label 2 is discarded, so its new decision is exactly the supplied fallback. At equal budgets the identity embedding preserves both total maps. |
| Always sending the never-decoded label | The original noiseless code sends four labels as `(0,1,2,2)` and decodes each received symbol to its first representative. An identity length-one source code and source concentrated at 3 give source error 0, uniform channel error 1/4, induced-prior channel error 1, and actual reconstruction error 1. The joint is pure at the source word 3 and output word 2. Replacing the prior term by the uniform mean would assert `1 ≤ 1/4`. |
| A wrong channel decision repairs a source error | Source symbols `(a,b,c)` have masses `(1,3,4)/8`. The compressor sends `(3,3,0)` and decodes labels `(0,1,2,3)` to `(c,c,b,a)`. The sent prior is `(4,0,0,4)/8`. Channel decisions are `(2,2,0)`. Source-only reconstructions are `(a,a,c)` and final reconstructions are `(b,b,c)`. Label 2 has zero sent mass and decoded mass 4/8. Both failures occur on `b`, which the composite recovers. Reconstruction error `1/8` is strictly below `3/8 + 4/8`. |
| Biased source, noisy channel | The existing Boolean law has false mass 1/4 and true mass 3/4. Either input to the BEC erases to `none` with probability 1/8. In nats, `H = 2 log 2 − (3/4) log 3`, `C = (7/8) log 2` and `C−H = (3/8) log(9/8) > 0`. The caller takes the direct theorem's witnesses once. For every positive tolerance the actual joint-law error of those same families is eventually below it. |

[Finite tests](../../LeanInfoTheory/Examples/SourceChannelCode.lean) · [Biased/noisy caller](../../LeanInfoTheory/Examples/SourceChannelSeparation.lean) · [Original collision code](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L163)

## Source adaptations and dispositions

CT91 (1991), §8.13, Theorem 8.13.1, printed pp. 216–217 (PDF 238–239), gives the source/actual-row error in (8.142) and the direct indexing and error estimate in (8.143)–(8.147) for a finite source satisfying the AEP. PW24 (16 August 2024), §19.7, printed pp. 391–393 (PDF 416–418), defines arbitrary word maps for general source/channel blocklengths. The statement of Theorem 19.22 and the displayed achievability estimate on pp. 392–393 use maximal channel error after compression. The sentence immediately after the estimate turns to the weak converse. PW24 Corollary 11.3 (p. 214) and Theorem 19.9 (p. 377) give the component coding results. CT91 §§2.1 and 8.1.5, and PW24 §19.3 supply the biased-example formulas. The project uses finite iid source words, unit bandwidth, natural log, explicit positive integer budgets, exact inverse/fallback and arbitrary total decisions. The induced-prior bound, projected-law equality, exceptional-length maps and regression fixtures are project derivations. [Registered sources and edition checks](../references.md)

The revision 1 reviewer suggested distinguishing the embedded and full maxima on the C32 collision fixture and clarifying the PW24 proof-direction citation. Revision 2 incorporated both. It also specified the generic projection, the producer's two branch equations and finite-tail bound, and a mixed-prior repair example selected by the lead. Independent step reviews accepted all twelve mathematical criteria in C33.01–05. The sole step finding (`lit-finding:C33-02-summary-link-label`) corrected the living-summary link label to cover all C33 step notes. The unchanged destination and corrected text were rechecked. Steps 01, 03, 04 and 05 had no findings. Original review results, parent dispositions, and final source identities are preserved separately from each other under `.lit-review/setup/c33-NN-20261114/`. Earlier build diagnostics remain attached to their original runs. [Approved contracts](../plans/release-3-chunk-33.md) · [Step validation and dispositions](../plans/release-3-chunk-33-notes.md)

## Cumulative criterion matrix

The source references use [finite owner](../../LeanInfoTheory/Shannon/SourceChannelCode.lean), [finite examples](../../LeanInfoTheory/Examples/SourceChannelCode.lean), [direct owner](../../LeanInfoTheory/Shannon/SourceChannelSeparation.lean) and [biased example](../../LeanInfoTheory/Examples/SourceChannelSeparation.lean). Each of the first twelve criteria has its original step's independent SATISFIED assessment, parent reconciliation and final source under the corresponding numbered step above. The last three rows describe the C33.06 closeout evidence.

| Criterion | Exact exercise or record |
|---|---|
| C33.01-LAW | Finite owner 33, finite examples 44–63. Actual atom, first marginal, real mismatch sum and weak Fano with the original decoder. |
| C33.01-PROJECTION | Finite examples 65–68. General PMF identity under `(s,y) ↦ (E s,y)`. C33.01 reviewer also compiled the capacity bound at the projected prior. |
| C33.01-BOUNDARY | Finite examples 70–130. Range, empty word, singleton source, many-to-one encoder, null output and exact 1/2 error. |
| C33.02-PRIOR | Finite owner 52–94. Pointwise union bound, normalized rows, source failure measure and weighted encoder pushforward. |
| C33.02-RESTRICT | Finite examples 146–246. Total fallback, equal-budget identity, embedded-row sum and both maxima, 0 versus 1 and null output. |
| C33.03-COLLISION | Finite examples 260–319. Original collision, pure source/induced prior, source error 0, original uniform 1/4, actual prior and reconstruction 1. |
| C33.03-REPAIR | Finite examples 335–454. Actual sent and decoded masses and independently evaluated source, channel and reconstruction errors. |
| C33.04-FIT | Direct owner 40–58. Positive-length rate comparison and exponentiation on the one retained family. |
| C33.04-FAMILY | Direct owner 60–71. Dependent branch equations verify exact restriction and both exceptional constant maps. |
| C33.04-LIMIT | Direct owner 73–89. Induced prior at each fitting length, rowwise maximum bounds and squeeze for one pair of families. |
| C33.05-GAP | Biased example 28–64. Both source atoms, erased output for each input, exact capacity, entropy and positive margin. |
| C33.05-CALLER | Biased example 68–80. One theorem witness and its limit used for all positive tolerances. |
| C33.06-VALIDATE | Focused, generated, static, compatibility, trust and documentation checks, 873 retained C32 signatures, 601/811 released contracts, current API/owner/import/simp/axiom controls and complete clean-suite/hygiene qualification at its source-matched checkpoint. |
| C33.06-HANDOFF | The three supported contracts, both C34-law examples, source adaptations, scoped numerical and branch checks and the reconciled canonical documents. |
| C33.06-REVIEW | Bound independent cumulative assessment of all fifteen criteria, original report, parent reconciliation, final source applicability and private closure. |

C32's full clean-suite checkpoint `aab42d0214007adb546cdfc48edbbd1b13f78138` belongs to C32. Between C32 and C33.05 the supported surface grew from 873 declarations in 66 modules to 876 in 68. Two direct root imports, five root-reachable modules, 92 root exports and 94 reviewed simp names were preserved. The C33.05 closure is `986fa52bf2c3dbdb4e7f42fc990e78ebbd29bec6832f21d28de82f978f730450`, at final captured source `9031cb09729f22eaaf35a4666174cf683ad517f34eb6617e16d14846f437b986`. C33.06 command results, checkpoint identity and cumulative review belong to their own source-bound records.

### Validation identities

| Reviewed input | Final source manifest | Step closure |
|---|---|---|
| C33.01 | `83acc70f9b440f84217d7ccdaeda8b539e92ea84d2dd6f68c31128ab30032d0d` | `be429cf320ca9f1a2076dff83d633299b91545256b9d93d8b270d149d429d924` |
| C33.02 | `8a5db704a752619c9ee7889d9b9b2910e6e06dede9085ab0669b5f2b8bf6da22` | `e9bfc8fcea5bfd90bf29f7eb51a46d0edc17bb3c7d8d8a412aa3496311135f16` |
| C33.03 | `de30d58d957a99abc16a281dbdb4bedcd57fcf8c5cac548e964e8721d23bb494` | `5513fa232b76e526ba60f7a74cd469c8dac5159fc19d1d7c51fe644ffee8c63a` |
| C33.04 | `9b8551b32d69479d2c4e2866a72a0c8a0c37a36e7f2f3c943688f492df3d9a31` | `04dc6c6e0d9fcb05b80fc28ba76b3ef38ddcd29a7cc438bc15a015395c23f1b1` |
| C33.05 | `9031cb09729f22eaaf35a4666174cf683ad517f34eb6617e16d14846f437b986` | `986fa52bf2c3dbdb4e7f42fc990e78ebbd29bec6832f21d28de82f978f730450` |

The cumulative evidence directory is `.lit-review/setup/c33-06-20261114/`.
`main-qualification.json` identifies the primary focused, generated, documentation,
static, compatibility and trust commands with their original streams.
`named-retention.json` identifies the compiled C32 and C33 exports.
The clean checkpoint record binds its commit and Git tree to the candidate's
raw file bytes, the complete development validator and hygiene result.
`completion.json` records the final source, checkpoint, original cumulative
review and reconciliation when closure succeeds. These records allow the
same source to identify its validation without embedding its own commit hash.
