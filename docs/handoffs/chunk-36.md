# Chunk 36 — Finite binary variable-length source coding

For every finite PMF, a binary prefix code on its positive support has mean length at least the source entropy in bits. A Shannon code has mean strictly below entropy plus one bit. A possibly different encoder attains the minimum over all prefix encoders. Coding a whole iid block gives a strict overhead below one bit per block. [Approved plan](../plans/release-3-chunk-36.md) · [Implementation notes](../plans/release-3-chunk-36-notes.md)

## Contracts and focused imports

All seven declarations belong to `LeanInfoTheory.Shannon`. The scalar owner imports `LeanInfoTheory.Shannon.PrefixCode` and `LeanInfoTheory.Shannon.Units` directly. The iid owner imports the scalar owner and `LeanInfoTheory.Shannon.SemanticBridge.FiniteProduct`. Import the iid owner for all seven contracts, or the scalar owner for the one-symbol results. Both are exported by the full Shannon umbrella. The lightweight root retains its two direct imports, five reachable modules and 92 exports. [Scalar owner](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean) · [Iid owner](../../LeanInfoTheory/Shannon/PrefixCodeLengthIid.lean) · [Root](../../LeanInfoTheory.lean)

```lean
variable {A : Type u} [Fintype A]

noncomputable def expectedCodewordLength (p : PMF A)
    (c : ↥p.supportFinset → List Bool) : ℝ :=
  ∑ a : ↥p.supportFinset, (p a.val).toReal * ((c a).length : ℝ)

theorem natsToBits_entropy_le_expectedCodewordLength (p : PMF A)
    {c : ↥p.supportFinset → List Bool} (hc : IsBinaryPrefixCode c) :
    natsToBits (entropy p) ≤ expectedCodewordLength p c

theorem exists_isBinaryPrefixCode_length_eq_ceil (p : PMF A) :
    ∃ c : ↥p.supportFinset → List Bool, IsBinaryPrefixCode c ∧
      (∀ a, (c a).length = ⌈-Real.logb 2 (p a.val).toReal⌉₊) ∧
      expectedCodewordLength p c < natsToBits (entropy p) + 1

noncomputable def optimalPrefixLength (p : PMF A) : ℝ :=
  sInf {t : ℝ | ∃ c : ↥p.supportFinset → List Bool,
    IsBinaryPrefixCode c ∧ expectedCodewordLength p c = t}

theorem isLeast_optimalPrefixLength (p : PMF A) :
    IsLeast {t : ℝ | ∃ c : ↥p.supportFinset → List Bool,
      IsBinaryPrefixCode c ∧ expectedCodewordLength p c = t}
      (optimalPrefixLength p)

theorem optimalPrefixLength_bounds (p : PMF A) :
    natsToBits (entropy p) ≤ optimalPrefixLength p ∧
      optimalPrefixLength p < natsToBits (entropy p) + 1

theorem optimalPrefixLength_iid_div_bounds (p : PMF A) (n : ℕ) (hn : 0 < n) :
    natsToBits (entropy p) ≤ optimalPrefixLength (PMF.iid p n) / (n : ℝ) ∧
      optimalPrefixLength (PMF.iid p n) / (n : ℝ) <
        natsToBits (entropy p) + 1 / (n : ℝ)
```

## C40 endpoint ledger

Write `H_bits(p) = natsToBits (entropy p)`. The library computes entropy in nats and divides by `Real.log 2` when comparing it with a number of bits. Each encoder takes an element of `↥p.supportFinset`. Every such atom has strictly positive finite real mass, and these masses sum to one. This needs no full-support assumption on the ambient alphabet. [Support membership](../../LeanInfoTheory/Probability/Finite.lean#L86) · [Conversion to bits](../../LeanInfoTheory/Shannon/Units.lean#L50)

| Claim | Quantifiers, witness and proof |
| --- | --- |
| Converse | Fix any finite `p` and **any** supported prefix encoder `d`. Apply `natsToBits_entropy_le_expectedCodewordLength p hd`. For mass `m > 0` and length `k`, apply the logarithm tangent inequality to `2⁻ᵏ/m`. Summing and using C35 Kraft necessity gives the lower bound, including when there is unused Kraft budget. |
| Strict upper bound | For each `p`, `exists_isBinaryPrefixCode_length_eq_ceil p` returns **one encoder** `s`, its prefix proof, a pointwise length equation and the strict expected-length bound on that same `s`. The rounded widths fit the actual masses. C35 realizes the lengths on the original support labels, and strict rounding on a nonempty positive support gives the strict mean bound. |
| Attained optimum | `(isLeast_optimalPrefixLength p).1` returns an encoder `m`, its prefix proof and an equality of its cost to the optimum. The second projection compares the optimum with **every** admissible mean. With a feasible incumbent of mean `B`, every competitive length at atom `a` is at most `⌊B / (p a).toReal⌋₊`. The finite search contains the incumbent. C35 realizes its minimizing Kraft-feasible profile. A competitor above `B` costs more than the incumbent and hence more than the chosen minimum. Ties and an incumbent of cost zero are allowed. |
| Scalar interval | Apply the universal converse to `m`, and leastness to `s`. Thus `H_bits(p) ≤ optimalPrefixLength p < H_bits(p) + 1`. The two codes can differ, as the biased Boolean example shows. |
| Iid rate | For each `p` and each `n > 0`, apply leastness to `PMF.iid p n` to obtain an attaining encoder on the **support of the whole block**. Iid entropy in nats scales by `n`. Conversion and division by positive `n` give `H_bits(p) ≤ optimalPrefixLength (PMF.iid p n) / n < H_bits(p) + 1/n`. An encoder can depend on both `p` and `n`. |

The public caller can extract the two scalar witnesses separately and compare the minimizer to an arbitrary supplied encoder. The permanent generic block caller extracts its optimizer and derives both inequalities on that encoder's own per-symbol mean. C40 still has its release-candidate external-consumer check. The prefix package proves finite binary prefix-code results. Huffman optimality, universal coding, arbitrary injections and sources with unknown symbol count have separate mathematical contracts. [C35 Kraft interfaces](chunk-35.md#contracts-for-c36-and-the-c40-ledger) · [Generic block caller](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L341)

## Permanent consumers and source interpretation

| Law | Checked result |
| --- | --- |
| Four labels, masses `(1/2, 1/4, 1/4, 0)` | Words `0, 10, 11` on the first three labels exhaust the Kraft budget. Mean, entropy in bits and optimum all equal `3/2`. Any finite fourth word would violate Kraft. [Dyadic checks](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L91) |
| Boolean law, `P(true) = 3/4` | The Shannon witness has lengths `(1, 2)` and mean `5/4`. Every admissible encoder uses at least one bit for each of these two supported labels. The single-bit assignment attains the minimum `1`. [Shannon witness and optimizer](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L206) |
| Boolean point mass at `false` | The other label is outside the support. Assigning `[]` gives mean, entropy in bits and optimum all zero. For each known source count, even zero, the support-valued tuple is unique. [Point-mass caller](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L226) |
| Two iid biased Booleans | On `TT, TF, FT, FF`, masses `(9, 3, 3, 1)/16` and words `0, 10, 110, 111` give `27/16` bits per pair. Concatenating the single-bit optimizer costs two. The attained block optimum per symbol is **at most** `27/32 < 1`. The same optimum satisfies the iid entropy interval with upper overhead `1/2`. [Block comparisons](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L311) |

CT91 §5.3, Theorem 5.3.1 gives the arbitrary-code converse. Its normalized Kraft-weight proof and the direct tangent proof above cover the same lower bound. CT91 §5.4, Theorem 5.4.1 and (5.29)–(5.37), gives the rounded witness, strict upper inequality and iid division. PW24 §10.1 uses positive support for single-shot losslessness. Its §10.3, (10.12), optimizes over feasible integer lengths, while Theorem 10.10, (10.13), prints a weak upper bound. C36 proves strictness via rounding and proves global attainment by finite search. PW24's unknown-count stream convention explains the extra condition on use of an empty word. [Registered editions and page references](../references.md#source-selection)

## Qualification and review identities

The implementation plan is approved revision 2, SHA-256 `39f36a20c91f94adfa44cc038ccf653069532f8830a0b166bbefa165646439f2`. The plan review examined revision 1. The first five implementation reviews assessed eleven criteria on their respective sources. Each reported zero findings. In C36.04, a reviewer-written probe generated a lint error and its corrected version passed on the same Lean source. The original observation and disposition remain in that step's private record.

| Step | Criteria and current evidence | Private closure |
| --- | --- | --- |
| C36.01 | `MEAN`, `LOWER` — [support sum and arbitrary-code converse](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean#L34) | `0da52d08370f6789f567fd20ed3145bfc414d773230da0476dc1dc2ee1de2f35` |
| C36.02 | `ROUND`, `WITNESS` — [ceiling, Kraft realization and strict mean on one encoder](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean#L83) | `7a06b837214b4f7c11891be120afca2a5ed6adb30e556f318a1246205c37ed17` |
| C36.03 | `ATTAIN`, `BOUNDS` — [global leastness and both scalar inequalities](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean#L124) | `dbcfe8d825ff28cba607f352a4c49b1c1c524dfe3cd49cf5f061e33d319c66dd` |
| C36.04 | `IID` — [positive block length, natural-to-real division and entropy identity](../../LeanInfoTheory/Shannon/PrefixCodeLengthIid.lean#L28) | `e98a407b77a577850b73b72d091353b65f67eabc9dfd8bfd2efb1f0be2212658` |
| C36.05 | `DYADIC`, `BIASED`, `PURE`, `BLOCK` — [four computations and generic caller](../../LeanInfoTheory/Examples/PrefixCodeLength.lean) | `1eadc33236a98cd7512a10acf54699857607b298a6a27221f6d9bf39ad36f766` |

The originals, reconciliations and final-source manifests for these reviews are in `.lit-review/setup/c36-01-20261116/` through `c36-04-20261116/` and `c36-05-20261117/`. The final three criteria are `C36.06-VALIDATE`, `C36.06-HANDOFF` and `C36.06-REVIEW`. They cover qualified contracts and imports, this handoff and the fresh cumulative assessment of all fourteen criteria. [Normative criteria](../plans/release-3-chunk-36.md#c3606--cumulative-review-qualification-and-c37-handoff)

- **C35 retention.** The incoming 881-name compiled export has SHA-256 `10f262ace43aef4e7b46c1933dc67c2a73e3271560eab094f38bec3489a2c229`. Before growth, C36.01 matched its 220 producer inputs, 70 compiled owners and nine dependency pins. The 888-name C36.05 export has SHA-256 `ac164a66e1acdf3ad050d5a5c420d11c3c4c6a08caa538bc8b4939e2eab944bc`. The cumulative comparison checks each incoming type, kind and owner and identifies the six scalar additions and the iid addition separately. The supported surface comprises 72 modules and 94 declarations with reviewed simp membership. The new development example is reachable from `LeanInfoTheory.Examples`. [C35 qualification](chunk-35.md#validation-and-review-identities) · [Current inventory](../current-public-api.json)
- **Primary checks.** The checkout is on `master` at `2eb80d0e746688511618aaefc2624ffa4ae88f6e`, with pre-existing changes. Lean is pinned to 4.33.1. The cumulative comparison and focused probes are indexed under `.lit-review/setup/c36-06-audit-20261117/`. Separate command receipts in `.lit-review/setup/c36-06-20261117/` record the focused build, arbitrary-law caller, source and generated-file checks, compatibility against the releases of 601 and 811 declarations, full trust/import/axiom audit, and documentation examples. The axiom policy allows only `propext`, `Classical.choice` and `Quot.sound`. Those receipts identify the exact checked inputs and results. [Development validation policy](../compatibility/README.md)
- **Completion and limits.** The original cumulative report, parent reconciliation, final validation and `completion.json` in that step directory identify the reviewed source, final source and actual closure once issued. The complete clean-checkpoint suite and its clean hygiene gate remain outstanding for this C36 candidate. Earlier clean checkpoints qualify their own source only. Release API-documentation generation, external-consumer release qualification and publication have separate milestones.

## Handoff to C37

C37 begins the method-of-types package independently of prefix coding. Its input is a word `x : Fin n → A` over a finite alphabet of size `k`. Counts are defined at every length and sum to `n`. For positive `n`, the roadmap offers two representations of a type: a natural count vector totaling `n`, or an empirical PMF with an exact denominator-`n` witness. Choose one index for the class of words with those counts and prove conversion and round-trip at positive length.

The required starting obligations are realization of each admissible count vector by a word, partition of words into classes, invariance under permuting **coordinate positions**, identification of empirical support with positive counts, and at most `(n+1)^k` types. A binary word of length three with counts `(2,1)` and a larger alphabet with an unused label exercise the boundary. At `n = 0` the empty word has all counts zero. Those counts cannot normalize to a PMF. This length-zero issue is distinct from assigning a zero-bit codeword to the sole possible symbol at a known count. C38 and C39 will consume the same realized counts, empirical PMF and class event. C37 planning and implementation await their own selection. [Release-map C37 contract](../plans/release-3-chunk-map.md#c37-empirical-laws-and-type-classes) · [Existing iid coordinate action](../../LeanInfoTheory/Probability/Iid.lean#L68)
