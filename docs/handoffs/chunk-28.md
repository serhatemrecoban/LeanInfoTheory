# Chunk 28 — Iid block information density and concentration

C28.01–C28.04 have supported closure records. C28.05 is the selected cumulative
validation, independent-review and handoff step. Its clean-candidate authority,
full-suite results, original review, reconciliation and final applicability are
separate obligations. Actual completion follows
`.lit-review/setup/c28-05-20261110/completion.json` when established.
[Approved plan](../plans/release-3-chunk-28.md) · [Criterion matrix and notes](../plans/release-3-chunk-28-notes.md#complete-cumulative-criterion-matrix)

## Exact public interface

Import `LeanInfoTheory.Shannon.IidInformationDensity` and open
`LeanInfoTheory.Shannon`. The full `LeanInfoTheory.Shannon` umbrella also exposes
all three declarations. Below are the exact declaration headers, with proof
bodies omitted, in the owner's `universe u v` context. The input is the first
coordinate and output the second; `p` precedes the raw channel `W`. No
measurable-space, full-support or positive-MI premise is required. All information
quantities are real-valued nats.

### Supported sum, including zero length

```lean
theorem infoDensity_iid_of_mem_support {A : Type u} {B : Type v}
    [Fintype A] [Fintype B] (p : PMF A) (W : A → PMF B) (n : ℕ)
    {z : (Fin n → A) × (Fin n → B)}
    (hz : z ∈ (PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).support) :
    infoDensity (PMF.iid p n) (PMF.memorylessChannel W n) z =
      ∑ i : Fin n, infoDensity p W (z.1 i, z.2 i)
```

The support is the actual joint of iid input words through the memoryless
channel. Impossible pairs require no pointwise additivity claim. At zero length
the sum is empty and density is zero.

### Two-sided concentration at positive lengths

```lean
theorem tendsto_infoDensity_iid_deviation {A : Type u} {B : Type v} [Fintype A] [Fintype B]
    (p : PMF A) (W : A → PMF B) {ε : ℝ} (hε : 0 < ε) :
    Filter.Tendsto (fun k : ℕ =>
      let n := k + 1
      ((PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).toOuterMeasure
        {z | ε ≤ |infoDensity (PMF.iid p n) (PMF.memorylessChannel W n) z / (n : ℝ) -
          mutualInfo (PMF.channelJoint p W)|}).toReal)
      Filter.atTop (nhds 0)
```

The successor index enumerates every positive blocklength. The deviation event
is closed. Each probability uses that length's actual pair of word spaces; only
the real probabilities share a codomain across lengths. No common probability
space or quotient at zero is required.

### Literal strict-test miss on every natural length

```lean
theorem tendsto_prob_infoDensityThresholdEvent_iid_compl {A : Type u} {B : Type v}
    [Fintype A] [Fintype B] (p : PMF A) (W : A → PMF B) {s : ℝ}
    (hs : s < mutualInfo (PMF.channelJoint p W)) :
    Filter.Tendsto (fun n : ℕ =>
      ((PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).toOuterMeasure
        (infoDensityThresholdEvent (PMF.iid p n) (PMF.memorylessChannel W n)
          ((n : ℝ) * s))ᶜ).toReal)
      Filter.atTop (nhds 0)
```

The threshold is the unnormalized `(n : ℝ) * s`. C27's strict mass event passes
when `exp t * Q(z) < J(z)`. Under the joint law its literal complement has the
same probability as the closed density sublevel `D(z) ≤ t`; ties are misses.
For every real `s`, the empty-word miss is one. This finite initial term does not
affect the all-natural-index limit. Negative `s` and zero MI are allowed whenever
the displayed strict inequality holds. No vanishing miss is claimed at `s = MI`.
[Mathematical owner](../../LeanInfoTheory/Shannon/IidInformationDensity.lean) · [Permanent focused callers](../../LeanInfoTheory/Examples/IidInformationDensity.lean)

## Proof route and import boundaries

For this paragraph, let `J = PMF.channelJoint p W`,
`pₙ = PMF.iid p n`, `Wₙ = PMF.memorylessChannel W n`,
`Jₙ = PMF.channelJoint pₙ Wₙ` and `Qₙ = indepProd pₙ (pₙ.bind Wₙ)`.
In the strict mass test above, J and Q denote the joint and independent laws
at the test's own alphabet (single-letter or word level).

On joint support, the private decomposition is input self-information plus
output self-information minus joint self-information. C19 supplies the iid sum
and three AEP limits. `PMF.finiteProduct_channelJoint_map` transports a word of
coordinate pairs to a pair of words through `Equiv.arrowProdEquivProdArrow`;
its inverse zips the coordinates. For a set S of words of coordinate pairs, the reverse identity is
`Jₙ.toOuterMeasure (e.symm ⁻¹' S) = (PMF.iid J n).toOuterMeasure S`.
`PMF.finiteProduct_bind_productChannel` supplies the output marginal. The
support-aware union bound with widths `ε/3` needs no independence between input
and output. The miss proof uses the full gap `MI − s`, normalizes only at
successors, then shifts back to all natural indices. Product-law and AEP
machinery were reused; no general iid-sum API was introduced.

The owner directly imports `Shannon.InformationDensity`,
`Probability.ProductChannel` and `Shannon.SemanticBridge.AEP` under
`LeanInfoTheory`. The development example adds the pinned
`Mathlib.Probability.Distributions.Uniform` import and stays outside both
mathematical umbrellas. One-off support, entropy, transport and event helpers
remain private. The surface is 842 declarations in 61 supported modules. All 839
incoming C27 named records and released contracts (601 and 811) remain retention
obligations. The root keeps `Probability.Finite` and `InformationMeasures`,
its five-module closure and 92 exports. No simp attribute was added; all 94
reviewed simp names remain protected.

## Consumers and boundary checks

| Consumer | Exact checked distinction |
| --- | --- |
| Generic supported words | Input/output orientation and every empty word pair. |
| Generic concentration | Actual word joint, positive real denominator, closed deviation and single-letter MI. |
| Generic C31 composition | For any `b : ℕ → ℝ` tending to zero, `miss n + b n` tends to zero on the same natural index. No sign condition on b is required by this scalar caller. |
| Empty miss | The literal complement at `0 * s` has probability one for every real s. |
| Uniform Boolean identity | Joint support is the word diagonal, MI is `log 2` and supported density is `n * log 2`. At positive lengths the miss is zero below MI and one at equality. Equality also gives miss one at length zero. |
| Impossible `00/01` | Joint mass and totalized density zero, coordinate sum `log 2`, independent mass `1/16`, and rejection at threshold `−1`. |
| Biased Boolean identity | Masses `3/4,1/4` and `s = log(4/3)` give `MI − s = (log 4 − s)/4 > 0`. At length two only the supported `00/00` pair ties at `2s`: closed miss `9/16`, open-sublevel probability zero. The same law/channel/threshold uses the all-natural miss limit. |

The biased fixture distinguishes an asymptotically vanishing miss from zero miss
at each finite length. The exact finite numerical check is at length two. The
null fixture separately distinguishes the joint and independent-pair laws.

## C27, C29, C30 and C31 responsibilities

C27 remains closed. It owns density, the joint mean, the global strict mass
comparison, support-only log interpretation, closed joint miss and independent
exponential tail. Its supported self-information derivation was a handoff; C28
formalizes it privately. [C27 handoff](chunk-27.md)

C29 owns codebook sampling and a total decoder, including duplicate words, no
match and a one-message budget. J and competing-pair Q are ensemble laws, not
claims about a fixed realized book. C30 owns the one-shot bound for the released
block code's actual error at the caller's W, n, positive M and arbitrary input-word
law q.

C31 may choose iid q, `R < s < MI` and `t(n) = n*s`. C28 supplies exactly the
true-pair miss. C30 bounds the competing-word term and supplies a deterministic code at each
chosen blocklength and budget. C31 selects these codes into a family. The rounded message budget permits a vanishing exponential bound using
the positive margin `s − R`; the generic `miss + b` caller checks composition
without constructing that later code. Joint concentration alone is no
competing-codeword bound.
[Programme boundaries](../plans/release-3-chunk-map.md#c31-finite-memoryless-channel-coding-and-operational-capacity)

## Sources, validation and deferred decisions

PW24 Section 18.1 supplies signed density and mean; Section 18.2/(18.9),
printed 354 / PDF 379, the closed lower-tail miss. Its Section 19.2 proof of
Theorem 19.8, printed 376 / PDF 401, supplies the memoryless-density and below-MI route.
C27's strict mass event fixes ties and null atoms, differing from the source's
weak acceptance display. CT91 (1991) Section 3.1 supplies self-information AEP;
Section 8.6 proof of Theorem 8.6.1(1), printed 195–196 / PDF 217–218, the marginal/joint
union argument; Section 8.1.1, printed 184–185 / PDF 206–207, the noiseless-bit setting.
The varying-word-space scalar limit, real null totalization, nats conversion and
exact biased tie fixture are project adaptations. Fresh text-only and earlier
inspections retain their actors/dates; no new visual or whole-book claim is made.
[Reference register](../references.md)

The matrix separates historical admission facts, current main checks, qualified
clean-candidate checks and independent assessments. The complete suite must run
on the expressly authorized clean, raw-byte-and-pin-matched snapshot and repeat
after amendment. Pending authority or validation supplies no passing credit.
API-doc generation is a separate milestone; release, publication and later chunks
are unselected.

No mathematical or naming decision remains open for these three endpoints.
Public self-information/transport helpers or a general iid-sum weak law remain
deferred until real production pressure justifies them. Random books, decoders
and achievability remain C29–C31. C28.01's unaccepted first review and authorized
recorder recovery retain their original limits; the replacement was accepted.
C28.04's sole optional overview wording finding was corrected and resolved.
Actual cumulative acceptance follows the completion pointer above.
