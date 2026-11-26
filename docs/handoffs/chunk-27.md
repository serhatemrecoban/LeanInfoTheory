# Chunk 27 — Finite information density and the strict threshold event

C27.01–C27.05 have supported completion records. C27.06 is the selected
cumulative qualification and handoff step. Its exact clean candidate, full
suite, fresh independent assessment, reconciliation and final source
applicability belong to its own records. The maintained completion pointer is
`.lit-review/setup/c27-06-20261108/completion.json` when established.
[Approved plan](../plans/release-3-chunk-27.md) · [Implementation notes](../plans/release-3-chunk-27-notes.md)

## Public interface

Import `LeanInfoTheory.Shannon.InformationDensity` and open
`LeanInfoTheory.Shannon`. The full `LeanInfoTheory.Shannon` umbrella exposes
these seven declarations. For implicit `{A : Type u} {B : Type v}`, callers
supply `(p : PMF A) (W : A → PMF B)` in this order. In the schematic type excerpts
below, `J = PMF.channelJoint p W`, `Q = indepProd p (p.bind W)` and
`E t = infoDensityThresholdEvent p W t` are local abbreviations.
The first coordinate is input, the second output.

```lean
infoDensity p W (z : A × B) : ℝ
  := Real.log ((J z).toReal / (Q z).toReal)

support_channelJoint_subset_indepProd p W :
  J.support ⊆ Q.support

sum_mul_infoDensity_eq_mutualInfo [Fintype A] [Fintype B] p W :
  (∑ z : A × B, (J z).toReal * infoDensity p W z) = mutualInfo J

infoDensityThresholdEvent p W (t : ℝ) : Set (A × B)
  := {z | Real.exp t * (Q z).toReal < (J z).toReal}

mem_infoDensityThresholdEvent_iff_of_mem_support p W (t : ℝ)
  {z : A × B} (hz : z ∈ J.support) :
  z ∈ E t ↔ t < infoDensity p W z

channelJoint_infoDensityThresholdEvent_compl_eq p W (t : ℝ) :
  (J.toOuterMeasure (E t)ᶜ).toReal =
    (J.toOuterMeasure {z | infoDensity p W z ≤ t}).toReal

indepProd_infoDensityThresholdEvent_le [Finite A] [Finite B] p W (t : ℝ) :
  (Q.toOuterMeasure (E t)).toReal ≤ Real.exp (-t)
```

The signed real density uses natural logarithms. On joint support both atom
masses are positive. The mean specializes the existing
`mutualInfo_eq_sum_log_ratio` to `J`, reverses its orientation, and rewrites
the marginals with `PMF.channelJoint_map_fst` and `PMF.channelJoint_map_snd`.
The null-value convention makes the density zero whenever the joint mass is
zero. The strict mass comparison excludes every such atom, even when the
threshold is negative and Q gives the atom positive mass. Its finite tail
proof sums the Q indicator bound by `exp (-t)` times the J atom and uses
`PMF.sum_toReal` under J. The membership and joint-miss results hold on
arbitrary alphabets. [Information density](../../LeanInfoTheory/Shannon/InformationDensity.lean) · [Finite-sum theorem](../../LeanInfoTheory/Shannon/SemanticBridge/FiniteSums.lean) · [Channel marginals](../../LeanInfoTheory/Probability/FiniteChannel.lean)

The owner directly imports `LeanInfoTheory.Probability.FiniteChannel`,
`LeanInfoTheory.Probability.TotalVariation`,
`LeanInfoTheory.Shannon.SemanticBridge.FiniteSums` and
`LeanInfoTheory.Shannon.SemanticBridge.Product`. The private examples import
the owner, `LeanInfoTheory.Probability.BinaryTesting` and
`Mathlib.Probability.Distributions.Uniform`. They enter the development
`Examples` aggregate. The lightweight root retains its two direct imports,
five-module closure and 92 exports. C27.04's 839 supported declarations in
60 modules and 94 reviewed simp names remained applicable through C27.05.
Both historical release baselines (601 and 811), the incoming C26 surface
(832) and the 17 C25 and four C26 focused testing names are cumulative
qualification controls. [C25 handoff](chunk-25.md) · [C26 handoff](chunk-26.md) · [Compatibility guide](../compatibility/README.md)

## Examples that distinguish the laws and the tie convention

| Channel | Strict event and observable probabilities |
| --- | --- |
| Uniform noiseless Bool | J has mass 1/2 on each matching pair and zero off the diagonal. Every Q atom has mass 1/4. Matching density is `log 2`. At `t = -1`, the event is the diagonal even though off-diagonal totalized density is zero. At `t = log (3/2)`, the C25 event test has size 1/2 under Q, power one and miss zero under J. The Q bound is 2/3, strictly below the J event probability. |
| Input-independent `W = fun _ => r` | J and Q both equal `indepProd p r`. Density is zero everywhere, including common-null atoms. The strict event at zero is empty. C25 size, power and miss are 0, 0 and 1. For uniform Bool input and pure-false output, `(true, false)` is supported and `(true, true)` is common null. |

Both permanent examples use `PMF.BinaryTest.ofEvent` with Q as null and J as
alternative, via `rejectProb_ofEvent` and `typeIIError_ofEvent`. [Focused callers](../../LeanInfoTheory/Examples/InformationDensity.lean)

The retained private Boolean symmetric-channel check uses crossover 1/8 and
uniform input. Matching pairs have J-mass 7/16 and density `log (7/4)`.
Mismatches have J-mass 1/16 and negative density `log (1/4)`. Every Q atom
has mass 1/4. At `t = log (1/4)`, the strict event is the diagonal, with Q
mass 1/2 and J mass 7/8. The closed J-miss has mass 1/8, all at equality.
The open density sublevel has J-probability zero. The C27.03 check's source is
`.lit-review/setup/c27-03-20261108/tie-source.lean`, SHA-256
`4a8295069e0a64a31d2851e46876cc300086e9c5337855f78f3078a14aefdf46`.
Its original parent command and result are in `tie.json` beside that source.
[Implementation notes](../plans/release-3-chunk-27-notes.md)

## C28 — Word-level miss and supported self-information

For any input-word law `q : PMF (Fin n → X)` and raw word channel
`K : (Fin n → X) → PMF (Fin n → Y)`, specialize the miss theorem with
`t = (n : ℝ) * r`. Writing `Jₙ = PMF.channelJoint q K` and
`Aₙ = infoDensityThresholdEvent q K t` gives

```lean
(Jₙ.toOuterMeasure Aₙᶜ).toReal =
  (Jₙ.toOuterMeasure {z | infoDensity q K z ≤ (n : ℝ) * r}).toReal
```

This identity includes zero length and arbitrary real rates. A C28 limit
can work at positive length for normalization and use the unnormalized
threshold in the miss conclusion, for a fixed rate strictly below
single-letter mutual information. The supported single-letter identity
whose Lean proof belongs to C28 is

```lean
infoDensity p W (x, y) =
  selfInfo p x + selfInfo (p.bind W) y - selfInfo J (x, y)
```

Assume `(x, y) ∈ J.support`. Apply
`support_channelJoint_subset_indepProd` and rewrite `support_indepProd`
to get `x ∈ p.support` and `y ∈ (p.bind W).support`. For each of these
marginals and J, `PMF.mem_support_iff` gives a nonzero atom,
`PMF.apply_ne_top` supplies finiteness of that atom, and
`ENNReal.toReal_pos` gives positive real mass. Factor Q's real atom with
`indepProd_apply` and `ENNReal.toReal_mul`. Name the positive joint, input
and output real masses `j`, `a` and `b`. `Real.log_div` and
`Real.log_mul` give `log j - (log a + log b)`. All required nonzero
premises follow from positivity. Apply `selfInfo_of_toReal_ne_zero` to
each of the three laws. The resulting signs give the displayed identity.
[Self-information rewrite](../../LeanInfoTheory/Shannon/SemanticBridge/Entropy.lean) · [Product support and atom mass](../../LeanInfoTheory/Shannon/SemanticBridge/Product.lean)

For the proposed iid argument, `PMF.finiteProduct_channelJoint_map`
pushes the product of pair laws forward along
`Equiv.arrowProdEquivProdArrow` to the joint of input words and output
words. `PMF.finiteProduct_bind_productChannel` identifies the output-word
marginal. C28 can combine these transports with
`selfInfo_iid_of_mem_support` and `tendsto_selfInfo_iid_deviation` for the
input, output and joint laws. A union bound combines their deviations
without assuming independence of input and output. The supported identity,
event transports and limiting conclusion remain C28 work subject to its
own planning and selection. [Product channels](../../LeanInfoTheory/Probability/ProductChannel.lean) · [Finite iid AEP](../../LeanInfoTheory/Shannon/SemanticBridge/AEP.lean)

## C29–C30 — Decoder event and weighted bound

C29 can pass the literal set `E t` to a deterministic decoder. The focused
global caller proves `z ∈ E t ↔ z ∈ J.support ∧ t < infoDensity p W z`. The
strict mass comparison forces positive J-mass, so the supported iff applies.
The reverse direction applies the supported iff with the supplied membership.
The support guard handles impossible pairs under the independent law. C29
owns the random-book sampling law and total decoder. [Guarded caller](../../LeanInfoTheory/Examples/InformationDensity.lean#L73)

For alphabets with only `[Finite X] [Finite Y]`, `n k : ℕ`, `r : ℝ`,
`q` and `K` as above,
the C30-facing caller sets `Qₙ = indepProd q (q.bind K)` and proves

```lean
(Jₙ.toOuterMeasure Aₙᶜ).toReal + (k : ℝ) * (Qₙ.toOuterMeasure Aₙ).toReal ≤
  (Jₙ.toOuterMeasure {z | infoDensity q K z ≤ t}).toReal +
    (k : ℝ) * Real.exp (-t)
```

It rewrites the first term using the miss identity and multiplies the
Q-tail inequality by the nonnegative competitor count. The caller admits
`k = 0`, `n = 0` and non-iid input laws. C30 supplies the code and its error
bound, including the number of competing indices for a positive message
budget. [Weighted caller](../../LeanInfoTheory/Examples/InformationDensity.lean#L102) · [Programme map, revision 3](../plans/release-3-chunk-map.md)

## Textbook conventions

PW24 §18.1, Definition 18.1/(18.2) and Proposition 18.2, printed p. 351
(PDF 376), give the density and its joint mean. Equation (18.2) assigns
minus infinity at J-zero, Q-positive atoms and zero at common-null atoms.
C27 recovers the ordinary log ratio on joint support and preserves the
strict decoder decision everywhere through multiplication of real masses.
Proposition 18.3, printed p. 352, introduces the independent input copy.
Corollary 18.4/(18.6), printed p. 353 (PDF 378), bounds its strict tail.
PW24 §18.2, Theorem 18.5/(18.9), uses a closed true-pair miss. Its decoder
display (18.10) uses a weak comparison, while the error decomposition on
printed p. 355 uses weak miss and strict false match. C27 assigns equality
to the miss throughout. CT91 §2.3/(2.28)–(2.30), printed pp. 18–19 (PDF
40–41), gives the finite joint mean. The project implements it in nats.
[Registered editions](../references.md#release-3-planning-locators)

## Cumulative evidence and closure

The [complete criterion matrix](../plans/release-3-chunk-27-notes.md#complete-criterion-to-source-and-evidence-matrix)
maps all ten earlier criteria and the three C27.06 duties to source and
attributed evidence. C27.01–C27.05 have successful original assessments,
reconciliation and supported closures. Their evidence does not predict the
new cumulative result. The final record at
`.lit-review/setup/c27-06-20261108/completion.json`, when established, identifies
the exact main source, clean candidate, checks, original cumulative report,
dispositions and final source applicability.

The cumulative commands cover the focused owner and examples, both testing
owners/consumers, Shannon and Examples, non-mutating generated/static and
documentation checks, both released contracts, named C26 and completed-testing
retention, import/root/simp boundaries and all-project axioms. The retained
negative-tie and word callers are replayed against the qualified owner.
The complete development suite requires the separately authorized exact clean
candidate and repeats after every amendment. Candidate-to-main raw bytes and
installed pins must match. Primary HEAD, index and existing local work stay
protected. The full API-documentation gate and publication are separate
milestones. C28, C29 and C30 have not been selected by this handoff.

One persistent independent C27 reviewer is reused. Its requested
gpt-6-astra/ultra/no-parent-history creation profile remains distinct from
unknown effective settings. Original native requests/results and reports,
uncertain dispatch observations, failed checks and reconciliations remain
private durable records. Read-only instructions are not OS isolation, and
recorded provenance is not authenticated human or model identity.
