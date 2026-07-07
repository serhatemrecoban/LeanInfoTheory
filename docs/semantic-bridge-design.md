# Semantic Bridge Design Note

Date: July 6, 2026

This note completes step 2 of the near-term semantic bridge plan. It turns the
API audit in `docs/semantic-bridge-api-audit.md` into concrete design choices
for the next Lean implementation steps.

The purpose is not to prove theorems yet. The purpose is to keep the upcoming
product-law, KL-divergence, and conditional-law code mathematically coherent
before the implementation starts to harden names and assumptions.

## Guiding Principles

1. Keep the core finite Shannon API PMF-first.

   The definitions in `LeanInfoTheory/Shannon/Entropy.lean` and
   `LeanInfoTheory/Shannon/InfoMeasures.lean` should remain finite, elementary,
   and cheap to import. They should not import KL divergence, kernels, product
   measures, or conditional probability just because semantic bridge theorems
   need those APIs.

2. Put measure-theoretic meaning in bridge files.

   The semantic bridge layer is where finite sums are connected to
   `PMF.toMeasure`, mathlib integrals, product measures, kernels, conditional
   distributions, and `InformationTheory.klDiv`.

3. Prefer mathlib semantics over parallel local semantics.

   If mathlib already has a measure-level concept, the bridge should reuse it.
   Local helpers should exist only to connect our finite PMF definitions to
   mathlib's more general API.

4. Avoid arbitrary zero-event conditional PMFs.

   Conditioning on a zero-probability atom has no canonical finite PMF. The
   finite API should not pretend otherwise. Values on zero-mass conditioning
   atoms should either be omitted by requiring a nonzero-mass proof, or should
   appear only inside weighted expressions where the zero branch is explicitly
   numeric zero.

## Product-Law Representation

The local independent product of two PMFs should be named:

```lean
Shannon.indepProd
```

Planned shape:

```lean
noncomputable def indepProd {alpha beta : Type*}
    (p : PMF alpha) (q : PMF beta) : PMF (Prod alpha beta)
```

Implementation target:

```lean
p.bind fun a => q.map fun b => (a, b)
```

This name is intentionally not `PMF.prod`. It says that the construction is the
independent product law, and it leaves room to replace or alias the helper if a
future mathlib version adds a canonical `PMF.prod`.

The first implementation layer should prove:

```lean
indepProd_apply :
  indepProd p q (a, b) = p a * q b

fstMarginal_indepProd :
  fstMarginal (indepProd p q) = p

sndMarginal_indepProd :
  sndMarginal (indepProd p q) = q

indepProd_map_swap :
  (indepProd p q).map Prod.swap = indepProd q p
```

The exact assumptions can be adjusted during implementation. The definition
should not need finite alphabets, but the first pointwise formula may initially
be proved under the finite assumptions already used by the information-measure
API if that keeps the proof simple.

## Product Measures

The bridge layer should also prove that the independent product PMF has the
expected product measure.

Planned theorem name:

```lean
indepProd_toMeasure
```

Planned mathematical statement:

```lean
(indepProd p q).toMeasure =
  MeasureTheory.Measure.prod p.toMeasure q.toMeasure
```

This theorem belongs in the semantic bridge layer, not in the core finite
Shannon files, because it requires measure-theoretic imports. It will let later
KL statements be offered in both finite-PMF and product-measure forms.

## Mutual Information As KL Divergence

The first main KL bridge should state that finite mutual information equals
mathlib KL divergence from the joint law to the independent product of its
marginals.

Primary planned theorem name:

```lean
mutualInfo_eq_toReal_klDiv_joint_indepProd
```

Planned statement shape:

```lean
theorem mutualInfo_eq_toReal_klDiv_joint_indepProd
    {alpha beta : Type*}
    [Fintype alpha] [Fintype beta]
    [MeasurableSpace alpha] [MeasurableSpace beta]
    [MeasurableSingletonClass alpha] [MeasurableSingletonClass beta]
    (p : PMF (Prod alpha beta)) :
    mutualInfo p =
      (InformationTheory.klDiv p.toMeasure
        (indepProd (fstMarginal p) (sndMarginal p)).toMeasure).toReal
```

Secondary planned theorem name:

```lean
mutualInfo_eq_toReal_klDiv_joint_prodMeasure
```

This version should rewrite the second measure using
`MeasureTheory.Measure.prod`:

```lean
mutualInfo p =
  (InformationTheory.klDiv p.toMeasure
    (MeasureTheory.Measure.prod
      (fstMarginal p).toMeasure
      (sndMarginal p).toMeasure)).toReal
```

The PMF version should be proved first, because it uses the local product-law
helper directly. The product-measure version should follow from
`indepProd_toMeasure`.

Useful later corollary:

```lean
mutualInfoOf_eq_toReal_klDiv
```

This should specialize the pair-law theorem to `p.map fun omega => (X omega,
Y omega)`.

## KL Helper Layer

Before proving the mutual-information bridge, step 3 should add a small KL
helper layer. The most important helper is absolute continuity of a finite joint
law with respect to the product of its marginals.

Planned theorem target:

```lean
joint_toMeasure_absolutelyContinuous_indepProd_marginals
```

Mathematical meaning:

```text
p.toMeasure is absolutely continuous with respect to
(indepProd (fstMarginal p) (sndMarginal p)).toMeasure.
```

This follows from the existing zero-marginal lemmas in
`LeanInfoTheory/Shannon/InfoMeasures.lean`: if either marginal atom has zero
mass, then every joint atom over that coordinate has zero mass.

The KL bridge may also need a finite PMF expansion theorem:

```lean
toReal_klDiv_pmf_eq_sum
```

Expected mathematical form:

```text
toReal (klDiv p.toMeasure q.toMeasure)
  = sum over a of p(a) * log (p(a) / q(a))
```

This helper should live in the bridge layer and should state the required
finite-support, measurability, absolute-continuity, and integrability
assumptions explicitly. It should not be added to the lightweight entropy or
information-measure files.

## Conditional-Law Representation

For a joint law `p : PMF (Prod alpha beta)`, the project convention is that
`condEntropy p` means `H(alpha | beta)`, i.e. the first coordinate conditioned
on the second coordinate.

The finite conditional law should therefore be represented first as a
nonzero-mass conditional PMF:

```lean
noncomputable def condFstGivenSnd
    {alpha beta : Type*} [Fintype alpha]
    (p : PMF (Prod alpha beta)) (b : beta)
    (hb : Ne (sndMarginal p b) 0) : PMF alpha
```

Planned pointwise formula:

```lean
condFstGivenSnd p b hb a =
  p (a, b) / sndMarginal p b
```

The proof term `hb` is part of the API on purpose. It prevents the project from
choosing a mathematically meaningless default PMF when `sndMarginal p b = 0`.

Expected conditional entropy bridge target:

```text
condEntropy p =
  sum over b with nonzero sndMarginal p b of
    (sndMarginal p b).toReal * entropy (condFstGivenSnd p b hb)
```

If a total expression over all `b : beta` is more convenient in Lean, the zero
branch should be the number `0`, not the entropy of an arbitrary default PMF:

```lean
if hb : sndMarginal p b = 0 then
  0
else
  entropy (condFstGivenSnd p b hb)
```

## Relation To Mathlib Conditional Distributions

For measure-theoretic semantics, the bridge should compare finite conditional
PMFs with mathlib's conditional-distribution kernel:

```lean
ProbabilityTheory.condDistrib Prod.fst Prod.snd p.toMeasure
```

Here `Prod.snd` is the conditioning coordinate and `Prod.fst` is the output
coordinate. On atoms with nonzero second marginal, the finite conditional PMF
should agree with this kernel as a measure:

```text
(condFstGivenSnd p b hb).toMeasure
  = ProbabilityTheory.condDistrib Prod.fst Prod.snd p.toMeasure b
```

This comparison should use `ProbabilityTheory.condDistrib_apply_of_ne_zero`.
No theorem should claim a meaningful finite conditional PMF at zero-mass
conditioning atoms.

For conditional mutual information, the same pattern should be reused with
conditional laws of `(alpha, beta)` given `gamma`, and with the first/third and
second/third marginals already present in `InfoMeasures.lean`.

## Zero-Probability Conditioning Convention

The project convention is:

1. Entropy summands at zero mass use the usual `0 * log 0 = 0` convention,
   already represented by `Real.negMulLog` and `selfInfo`.

2. Conditional PMFs are only canonical on conditioning atoms with nonzero
   marginal mass.

3. Expected conditional quantities ignore zero-mass conditioning atoms by
   weighting them by zero or by summing only over nonzero support.

4. When comparing to mathlib event conditioning, remember that
   `ProbabilityTheory.cond` returns the zero measure on zero-mass events. That
   is a measure-level convention, not a finite PMF convention.

This is close in spirit to textbook information theory, where conditional
distributions are only relevant almost surely, while remaining compatible with
mathlib's measure-theoretic semantics.

## File And Import Plan

The current file `LeanInfoTheory/Shannon/SemanticBridge.lean` remains the
public semantic bridge entry point.

If step 3 grows beyond a small amount of code, introduce subfiles under:

```text
LeanInfoTheory/Shannon/SemanticBridge/
```

Likely subfiles:

- `Product.lean`, for `indepProd`, marginal formulas, product-measure bridge,
  and joint absolute-continuity helpers.
- `KL.lean`, for finite KL expansion and mutual-information-as-KL theorems.
- `Conditional.lean`, for finite conditional laws and conditional-distribution
  bridge theorems.

The existing `SemanticBridge.lean` file can import stable subfiles as they
settle. If later subfiles need the existing `selfInfo` theorem and import cycles
appear, move the entropy/self-information bridge into
`SemanticBridge/Entropy.lean` and make `SemanticBridge.lean` a small aggregator.
Do not do that split until theorem pressure justifies it.

## Implementation Order After This Note

Step 3 should proceed in this order:

1. Add `Shannon.indepProd`.
2. Prove pointwise and marginal formulas for `indepProd`.
3. Prove the `toMeasure` product-measure theorem.
4. Prove joint-law absolute continuity against the product of marginals.
5. Add the finite KL expansion helper only if the mutual-information proof
   actually needs it.

Step 4 should then prove the mutual-information-as-KL theorem and add the
random-variable corollary if the theorem pressure is low enough.
