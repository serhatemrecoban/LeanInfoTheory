# Chunk 32 — Per-message error, expurgation and message restriction

For a deterministic block channel code with a positive message budget (M) and uniform error (e), retain **all** message indices with individual error at most (2e). There are at least `(M+1)/2` such indices, using natural division. Any fitting positive budget admits a single restricted code with error at most (2e) under every prior. Retaining the full good set costs at most `Real.log 2 / n` nats per use at positive length. Applied at every length of one C31 witness, the construction gives one full retained family with the same eventual rate floors and vanishing maximal error. [Approved C32 plan](../plans/release-3-chunk-32.md) · [Step records](../plans/release-3-chunk-32-notes.md) · [C31 handoff](chunk-31.md)

## Public interface and focused imports

The finite owner imports only `LeanInfoTheory.Shannon.ChannelCode`. Its 14 declarations are under `LeanInfoTheory.Shannon.BlockChannelCode`. The scalar result belongs to `LeanInfoTheory.Shannon.CodingRate`. That module directly imports `LeanInfoTheory.Shannon.Units` and `Mathlib.Algebra.Order.Floor.Semiring`. The family result belongs to `LeanInfoTheory.Shannon.OperationalExpurgation` and directly imports the finite owner and `CodingRate`. The two new owners are exported through the full Shannon umbrella. The finite consumer imports the finite owner and `CodingRate`. The family consumer imports the family owner and `OperationalCapacity` to obtain a C31 witness. [Finite owner](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean) · [Scalar owner](../../LeanInfoTheory/Shannon/CodingRate.lean) · [Family owner](../../LeanInfoTheory/Shannon/OperationalExpurgation.lean)

```lean
import LeanInfoTheory.Shannon.OperationalExpurgation
import LeanInfoTheory.Shannon.OperationalCapacity

open LeanInfoTheory.Shannon Filter
```

Fix `c : BlockChannelCode X Y n M`, `W : X → PMF Y` and, for error calculations, `[Fintype Y]`. The input type can be arbitrary. In this section `row m` denotes `PMF.memorylessChannel W n (c.encoder m)`, `q m` denotes `c.messageErrorProbability W m`, and `e` denotes `c.errorProbability W hM` under `hM : 1 ≤ M`. The decoder returns a label on every output word. Thus two labels sent as the same word may have the same output law and different errors. Evaluating a row requires no positivity of its prior mass.

| Finite declaration and arguments | Statement |
|---|---|
| `messageErrorProbability c W m` | `∑ y, if c.decoder y ≠ m then (row m y).toReal else 0` for each `m : Fin M`. |
| `errorProbability_eq_mean_messageErrorProbability c W hM` | `e = (1 / (M : ℝ)) * ∑ m, q m`. |
| `errorProbabilityWithPrior c W π` | `decodingErrorProbability (PMF.channelJoint π row) c.decoder`, with `π : PMF (Fin M)`. |
| `errorProbabilityWithPrior_eq_sum c W π` | `c.errorProbabilityWithPrior W π = ∑ m, (π m).toReal * q m`. |
| `errorProbabilityWithPrior_uniformOfFintype c W hM` | After giving `Fin M` its nonempty instance from `hM`, the uniform-prior error equals `e`. |
| `errorProbabilityWithPrior_pure c W m` | `c.errorProbabilityWithPrior W (PMF.pure m) = q m`. |
| `maximalErrorProbability c W hM` | The finite supremum of `q` over the nonempty set of all indices. |
| `maximalErrorProbability_le_iff c W hM b` | `c.maximalErrorProbability W hM ≤ b ↔ ∀ m, q m ≤ b` for every real `b`. |
| `errorProbabilityWithPrior_le_maximalErrorProbability c W π hM` | `c.errorProbabilityWithPrior W π ≤ c.maximalErrorProbability W hM`. |
| `restrictMessages c i j₀` | For `i : Fin K ↪ Fin M` and `j₀ : Fin K`, return a `BlockChannelCode X Y n K` encoding `j` by `c.encoder (i j)`. Invert `i` on its image after decoding, and send other original decoder outputs to `j₀`. |
| `restrictMessages_decoder_of_eq c i j₀ y j h` | For every output `y`, `h : c.decoder y = i j` implies `(c.restrictMessages i j₀).decoder y = j`. |
| `messageErrorProbability_restrictMessages_le c W i j₀ j` | `(c.restrictMessages i j₀).messageErrorProbability W j ≤ q (i j)`. |
| `half_le_card_filter_messageErrorProbability c W hM` | `(M+1)/2 ≤ G.card` for the entire finite set `G` below. |
| `exists_expurgated_restrictions c W hM` | The exact-budget result below. |

The restriction operation and decoder-preservation theorem require only the code, embedding and fallback. In particular they apply to off-support outputs without a channel law or an output enumeration. The source criterion uses a weak threshold, so ties are kept. The positive count used by uniform measures, finite maxima and fallback index zero is available even at `n=0`.

### The exact-budget theorem

The public theorem has the following conclusion, using `e` as above.

```lean
let G := Finset.univ.filter (fun m => c.messageErrorProbability W m ≤ 2 * e)
∃ (_hL : 1 ≤ G.card) (i : Fin G.card ↪ Fin M),
  (M + 1) / 2 ≤ G.card ∧ Set.range i = (G : Set (Fin M)) ∧
  ∀ (K : ℕ) (hK : 1 ≤ K) (hKL : K ≤ G.card),
    ∃ d : BlockChannelCode X Y n K,
      d = c.restrictMessages ((Fin.castLEEmb hKL).trans i) ⟨0, hK⟩ ∧
      d.maximalErrorProbability W hK ≤ 2 * e ∧
      ∀ π : PMF (Fin K), d.errorProbabilityWithPrior W π ≤ 2 * e
```

Every codeword is traced through the embedding to an original label. The range characterizes the good set independently of its enumeration. A proof by finite sums handles zero mean before cancelling a positive mean in the remaining case. When the mean is positive, the original row errors on bad indices bound their count times `2*e`. Nonnegativity bounds this partial sum by `M*e`. The integer complement then yields the ceiling-half bound. At a retained label the same channel row is sampled, and every old correct decision for that label is still correct. A fallback can make an old failure correct.

### Scalar and lengthwise statements

In `LeanInfoTheory.Shannon`, the scalar theorem is

```lean
theorem codeRate_sub_log_two_div_le_of_le_two_mul {n M L : ℕ}
    (hn : 0 < n) (hM : 1 ≤ M) (hML : M ≤ 2 * L) :
    codeRate n M - Real.log 2 / (n : ℝ) ≤ codeRate n L
```

The hypotheses imply `1 ≤ L`. With natural logarithms, passing from `M ≤ 2*L` to a per-use inequality contributes `Real.log 2 / n`. A smaller fitting budget inherits the probability bound. It must independently satisfy a size hypothesis to inherit the same rate estimate.

The operational theorem takes the components of the caller's one witness. `R` can be any real satisfying the supplied floor. The code families and positivity witnesses are available at every natural length.

```lean
theorem exists_expurgated_family_of_tendsto_errorProbability
    {X : Type u} {Y : Type v} [Fintype Y]
    (W : X → PMF Y) (R : ℝ) (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode X Y n (M n))
    (he : Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0))
    (hr : ∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (M n)) :
    ∃ (L : ℕ → ℕ) (hL : ∀ n, 1 ≤ L n) (D : ∀ n, BlockChannelCode X Y n (L n)),
      (∀ n, (M n + 1) / 2 ≤ L n ∧ ∃ i : Fin (L n) ↪ Fin (M n),
        Set.range i = {m | (c n).messageErrorProbability W m ≤
          2 * (c n).errorProbability W (hM n)} ∧
        D n = (c n).restrictMessages i ⟨0, hL n⟩) ∧
      (∀ n, (D n).maximalErrorProbability W (hL n) ≤
        2 * (c n).errorProbability W (hM n)) ∧
      Tendsto (fun n => (D n).maximalErrorProbability W (hL n)) atTop (nhds 0) ∧
      (∀ n, 0 < n → codeRate n (M n) - Real.log 2 / (n : ℝ) ≤ codeRate n (L n)) ∧
      ∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (L n)
```

The proof applies the finite result at full retained size for each length, then chooses the family once. The maxima are squeezed between zero and twice the original errors. The rate tail at `δ/2` intersects the positive-length tail on which `log 2/n < δ/2`. C31's final caller illustrates that last calculation under an assumed loss bound. C32 supplies the codes, the actual finite loss and their reliability. [C31 caller](../../LeanInfoTheory/Examples/OperationalCapacity.lean) · [C32 family caller](../../LeanInfoTheory/Examples/OperationalExpurgation.lean)

## Using the results in C33

1. **Open one C31 witness.** From `IsAchievableRate W R`, obtain the same `M,hM,c` before its error limit and all rate tolerances. C32 yields one `L,hL,D` as above, including the full family's vanishing maximal error.
2. **Supply the budgets.** Given any positive `K : ℕ → ℕ` fitting `L` at every length, fix `d n := (D n).restrictMessages (Fin.castLEEmb (hfit n)) ⟨0,hK n⟩`. For an arbitrary single restriction `d = c.restrictMessages i j₀`, the finite consumer proves `d.errorProbabilityWithPrior W π ≤ c.errorProbabilityWithPrior W (π.map i)`. This follows from the weighted row sum and the pushforward change of variables; it uses the actual prior on both sides.
3. **Evaluate priors on that family.** At every length, `errorProbabilityWithPrior (d n) W π ≤ maximalErrorProbability (d n) W (hK n) ≤ maximalErrorProbability (D n) W (hL n)`. Apply this both to `p.map f` and to a point mass. For every sequence `π : ∀ n, PMF (Fin (K n))`, the same family's actual error tends to zero. These transported-prior and further-restriction bounds are derived in development consumers from the supported row and maximum theorems. The eventual lower rate floor belongs to `L`. [Finite consumer](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean) · [Complete family caller](../../LeanInfoTheory/Examples/OperationalExpurgation.lean)
4. **Fit and compose in C33.** For `H(p) < C(W)`, choose `H(p) < r_s < r_c < C(W)` and a positive tolerance smaller than `r_c-r_s`. Use the released source family with eventual rate at most `r_s` and the C31/C32 channel family with retained rate at least `r_c-δ` eventually. At positive lengths on that tail, compare logarithms to fit the positive source budget into the retained budget. C33 must furnish valid total codes on exceptional short lengths. [Source producer](../../LeanInfoTheory/Shannon/SourceCodingAsymptotic.lean) · [C33 roadmap](../plans/release-3-chunk-map.md#c33-lossless-source-channel-separation-construction)

For the outstanding finite inequality, draw a source word under its iid law, apply its source encoder `f`, transmit the selected channel codeword, and sample the actual memoryless output. The source-index law `π` is the pushforward along `f`. Source success and correct channel decoding imply reconstruction success. Under this joint law the failure union bound should give

```text
P(reconstruction error) ≤ P(source error) + Σj π(j) · error(channel row j)
                        ≤ P(source error) + maximal channel error.
```

If using the larger code directly, the row index is the embedded source label and the decoder includes its total inverse with a fallback. The row formulation also applies after exact-budget restriction. The events may be dependent. C33 owns this inequality, the biased-source composed example, and the regression with an identity source code and an input law concentrated on the never-decoded fourth index. Its expected reconstruction error is one although source error is zero and the four-message uniform channel error is `1/4`. C33 requires its own plan, approval and step selection.

## Permanent calculations and source adaptations

| Experiment | Checked values |
|---|---|
| Four labels `(0,1,2,2)`, noiseless ternary channel, first representative decoder | The row errors in old label order are `(0,0,0,1)`. The uniform mean is `1/4`; pure old label 3 has error one. The threshold is `1/2` and the selected range is exactly `{0,1,2}`. The full three-label code has maximum zero and achieves zero for both a point mass and a uniform prior. A separate two-label code uses the exact-budget theorem. |
| User-specified restriction to old labels `(0,3)` | Mapping the new uniform prior to the old labels gives old-code error `1/2`. New fallback 0 (old 0) gives rows `(0,1)` and mean `1/2`. New fallback 1 (old 3) redirects the output decoded to discarded old 2 and gives rows `(0,0)`. |
| Five labels `(2,0,2,1,2)` with decoder `(1,3,4)` | Rows `(1,0,1,0,0)`, mean `2/5`, threshold `4/5`, selected range `{1,3,4}`. Its cardinality is three, the ceiling half of five, independent of how the retained labels are enumerated. |
| Zero mean and one label | All original rows have zero error at zero mean and the full retained set is all labels. With one label the released error and maximal error are both zero at every blocklength. |
| Empty words | At `n=0` the sole output word gives one correctly decoded index; all other rows have error one. Uniform error is `1−1/M`. At `M=2`, mean `1/2` makes error one a threshold tie and the embedding covers both labels. Finite results also allow empty base alphabets. |
| Rate check | At `n=1,M=4,K=1`, `codeRate 1 4 − Real.log 2 > codeRate 1 1`. The positive-length full-retention rate estimate cannot be applied to every smaller fitting budget. |

CT91 §8.5, pp. 193–194, distinguishes label-specific, maximal and uniform errors. Its §8.7, Theorem 8.7.1 proof step 3, p. 202, (8.81), reindexes a reliable half and loses one bit per block. PW24 §19.1, Theorem 19.4, pp. 374–375, bounds a bad-message fraction. PW24 §17.1, Definitions 17.1–17.2, pp. 342–343, allows more general decision rules. The project uses its released total decoder, nats, exact natural cardinalities, fallback on discarded labels and a single code selected before all priors. PW24 §19.7, Theorem 19.22, pp. 391–393, explains the downstream need for channel reliability when the compressor output is nonuniform. [Registered editions and checks](../references.md)

The three error names distinguish the marginal experiment, its evaluation at a sent label, and its maximum. The released uniform error remains `errorProbability`; a new prior is explicit in `errorProbabilityWithPrior`. All finite code constructions use the existing code type. No helper structures, public aliases, new simp attributes, separate maximal-error achievability predicate or bundled channel were required. The full-family producer takes witness components, which keeps the finite interface and the operational restriction theorem independently importable. C32.01's review clarified that changing the prior changes the weighted error while the never-decoded row still has error one. C32.02 clarified the old/new fallback labels and the scope of pointwise preservation. Both corrections were recorded. The original C32.03–05 reports had no findings.

## Coverage and evidence

C32.06's fresh compatibility gate caught a duplicate unused compiler-generated
`errorProbability.congr_simp` in the new operational proof and the old
ChannelCoding owner. The same source independently serialized to the same old
artifact. Targeted set-coercion and multiplication-limit lemmas replace two
broad simplifier traversals; the public statement, assumptions, imports and
argument are unchanged. Every other Lean file matches C32.05. The original
failed boundary run and serialized import controls are retained separately;
only fresh qualification of the corrected proof supplies current gate credit.

C31 closed at `b2ca510a740a9a0602b8ed8c761b985d79e65b6ce50b626004ff5fdf43a256d7`. Its qualified clean commit was `5afb51465752a42b6a4213c8ee9e5e3c5905b94a`. At intake the C32 source manifest retains all 857 declaration records from that C31 manifest with identical names, owners, kinds and attributes. The 16 additions have empty attribute lists. The inventory grows from 64 to 66 supported modules and from 857 to 873 supported names. The lightweight root retains its two direct imports, five reachable modules and 92 exports. The reviewed simp set remains at 94. Current inventory comparison is distinct evidence from compiled historical signature retention and the axiom audit. [Compatibility controls](../compatibility/README.md)

Private completion records for C32.01–05 are under `.lit-review/setup/c32-NN-20261113/completion.json`. These original checks retain the source identities in their respective records.

| Step | Supervised closure | Final captured source |
|---|---|---|
| C32.01 | `cf2b87c8ffccce6080ab2468bd4db17020ddf81b8cb5722c5ed68f103cd1f165` | `8a0940ab19a03117828656b2ecf754ef2f3a2f8f769d7b2b455a21267bb42957` |
| C32.02 | `a5c88b314ff862907f82af3ee5dee08ab3605c636880937029efe1c5026ac215` | `53e60c38565750893f6d776379776161008563edb624d54cbc74f02959a43715` |
| C32.03 | `682f8f7aa5ffce29b94735b604d68164a40c434ddd78b2f10232034df38772a1` | `7eb537aec28893b125a9c49e438e9da2a180e1dc21265eda8e5d7accc879a76c` |
| C32.04 | `fe4088ab8457f2f321e240cbf4ddc6b90596023948bf4d8688ecbbf3d514ffdb` | `80120f93b832d752847a11815cc7470aec645ecceb1aaa13262fb75cf1c471dd` |
| C32.05 | `cb7db335b86769ddab0f756d5907d4c0cfb1986d9353897a7e64ffdd5b004f95` | `900f9ff0f57d32086ffc6039b4228b36caf51b3cdecfac5c6072baa236a7ef08` |

The criterion matrix uses `F` for the finite producer, `E` for its finite examples, `A` for the family producer and `P` for its operational examples. The linked source files provide the Lean statements with their actual universe constraints. [F](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean) · [E](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean) · [A](../../LeanInfoTheory/Shannon/OperationalExpurgation.lean) · [P](../../LeanInfoTheory/Examples/OperationalExpurgation.lean)

| Approved criterion | Source and permanent exercise | Validation or record |
|---|---|---|
| C32.01-ROW | F 40,46 and E 32,85,188 connect the row and released mean. | Step 1 source and closure above; C32.06 `focused.json` and its actual stdout/stderr. |
| C32.01-PRIOR | F 53,60,74,81 and E 62,96,115,225 give the actual joint experiment, weighted sum and pure/uniform cases. | Step 1 closure; C32.06 `focused.json` and its actual stdout/stderr. |
| C32.01-MAX | F 88,94,102 and E 38,44,50,101 characterize the maximum and bound arbitrary priors. | Step 1 closure; C32.06 `focused.json` and its actual stdout/stderr. |
| C32.02-DECODE | F 119,125 and E 123,127,196,201,253 check encoder identity, preservation and off-image outputs. | Step 2 closure; C32.06 `focused.json` and its actual stdout/stderr. |
| C32.02-ERROR | F 134 and E 143,155,206,225,232,247 cover the embedded row, transport, a second restriction and strict improvement. | Step 2 closure; C32.06 `focused.json` and its actual stdout/stderr. |
| C32.03-COUNT | F 152 and E 260,266,323,430,468 cover odd, zero, singleton and threshold ties. | Step 3 closure; C32.06 `focused.json` and its actual stdout/stderr. |
| C32.03-EXACT | F 200 and E 285,297,363,430 quantify over budgets before code selection and over priors afterward. | Step 3 closure; C32.06 `focused.json` and its actual stdout/stderr. |
| C32.04-RATE | CodingRate 118, A 69 and E 401 prove/apply the scalar bound and exhibit a counterexample for arbitrary shrinking. | Step 4 closure; C32.06 `focused.json` and its actual stdout/stderr. |
| C32.04-FAMILY | A 33 and P 29 keep one full good-set family through both limits and all rate tolerances. | Step 4 closure; C32.06 `focused.json` and its actual stdout/stderr. |
| C32.05-COLLISION | E 163,188,221,341,345,363,401 identify the four-label range, original errors, maximum-zero full code and rate check. | Step 5 closure; C32.06 `focused.json` and its actual stdout/stderr. |
| C32.05-BOUNDARY | E 266,408,411,418,430,446,454,460,468 cover the permuted odd code, zero mean, singleton, empty-word rows and tie. | Step 5 closure; C32.06 `focused.json` and its actual stdout/stderr. |
| C32.05-CALLER | P 29 fixes the requested code family before the prior sequence, bounds its maximum and squeezes its actual errors. | Step 5 closure; C32.06 `focused.json` and its actual stdout/stderr. |
| C32.06-VALIDATE | C31 exact named retention; 601/811 historical contracts; current imports, root, simp, axioms, pins, documentation and repository hygiene. | C32.06 `main-qualification.json`, `named-retention.json`, and the exact local checkpoint proposal/execution records; full suite outcome and commit/tree identity must be read from those original records. |
| C32.06-HANDOFF | This handoff, the exact public contracts, C33 caller, reconciled summary, log, sources, map and notes. | C32.06 `readiness-source.json` and its `readiness.json` digest; matched raw source, protected primary state, helper restoration and actual clean-suite evidence are retained with the checkpoint. |
| C32.06-REVIEW | Cumulative criterion matrix and maintained handoff submitted to the bound original C32 reviewer. | C32.06 `original-report.json`, `parent-reconciliation.json`, `final-applicability.json` and `completion.json`; the original report must assess all fifteen criteria on its fixed candidate. |

C32.06 records are under `.lit-review/setup/c32-06-20261113/`. The
fresh cumulative commands are the eight-target warning-as-error focused build,
four non-mutating generated-artifact checks, development static, compatibility
and trust, and release documentation. `main-qualification.json` binds their
actual streams to equal before/after source observations. `named-retention.json`
compares fresh compiled rows with C31's 857 and retains the exact 601/811
historical-contract results, current imports, root and simp boundaries. The
checkpoint proposal binds its exact raw manifest, normalized tree, diff and
separate local authority. Its execution record identifies the source-matched
clean commit, the unfiltered complete development suite and helper restoration.
No earlier clean-suite approval transfers to C32. No primary staging, commit,
push or publication is authorized by this closeout.

The persistent C32 reviewer is `/root/c32_reviewer`, originally requested as
`gpt-6-astra`, `ultra`, with parent-history copying disabled; effective runtime
settings remain unknown. Original native delivery/results and the cumulative
report are preserved separately from parent reconciliation. The report and
completion records supply the actual reviewed/final source identities and
assessments after capture. This handoff is validation ready; the supported
private completion record alone establishes cumulative closure. No separate
signature-bearing API-documentation build or release/publication is claimed.
C33 planning and implementation remain unselected.
