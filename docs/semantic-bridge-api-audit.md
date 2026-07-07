# Semantic Bridge API Audit

Date: July 6, 2026

This note records the API audit for the first near-term semantic bridge step.
The goal is to decide what we should reuse from mathlib and adjacent Lean
projects before designing the product-law, KL-divergence, and conditional-law
bridges for the finite Shannon API.

## Sources

- Local project dependency: mathlib `v4.30.0`, pinned at commit
  `c5ea00351c28e24afc9f0f84379aa41082b1188f`.
- External reference: `teorth/pfr`, audited at commit
  `ac54b58943015e00250aed72126e814c7fa44902`.
- External reference: `RemyDegenne/testing-lower-bounds`, audited at commit
  `5d4c306593b8426846ead569bbcbb781e2a965e9`.

## Main Conclusion

The project should keep the finite Shannon layer PMF-first and lightweight, but
the semantic bridge layer should reuse mathlib's measure, kernel, conditional
distribution, and KL-divergence APIs directly. This gives us a clean split:
finite textbook definitions remain easy to import and compute with, while
measure-theoretic equivalence theorems live in heavier bridge files.

The two largest local gaps are:

1. A small independent product-law API for finite `PMF`s.
2. A finite conditional-law design that states explicitly what happens on
   zero-probability conditioning events.

Both should be designed before proving the larger KL and conditional entropy
bridges.

## Mathlib APIs To Reuse

The following declaration table was smoke-checked locally against the pinned
mathlib dependency. It is not meant to be exhaustive; it records the main API
anchors that future semantic bridge files should reuse.

| Area | Module | Declarations | Intended use |
| --- | --- | --- | --- |
| PMF maps and finite laws | `Mathlib.Probability.ProbabilityMassFunction.Constructions` | `PMF.map`, `PMF.map_apply`, `PMF.ofFintype` | Relabeling, uniform finite distributions, and pointwise map formulas. |
| PMF monadic composition | `Mathlib.Probability.ProbabilityMassFunction.Monad` | `PMF.bind`, `PMF.bind_apply`, `PMF.bindOnSupport` | Candidate implementation path for independent products and conditional finite laws. |
| PMF-to-measure bridge | `Mathlib.Probability.ProbabilityMassFunction.Basic` and `Mathlib.Probability.ProbabilityMassFunction.Integrals` | `PMF.toMeasure`, `PMF.toMeasure_apply_singleton`, `PMF.integral_eq_sum` | Convert finite PMF sums to integrals against `p.toMeasure`. |
| Product measures | `Mathlib.MeasureTheory.Measure.Prod` | `MeasureTheory.Measure.prod`, `MeasureTheory.Measure.prod_apply`, `MeasureTheory.Measure.map_fst_prod`, `MeasureTheory.Measure.map_snd_prod` | State and prove product-measure versions of product-PMF bridge lemmas. |
| Finite/probability products | `Mathlib.MeasureTheory.Measure.FiniteMeasureProd` | `MeasureTheory.FiniteMeasure.prod`, `MeasureTheory.FiniteMeasure.toMeasure_prod`, `MeasureTheory.ProbabilityMeasure.prod`, `MeasureTheory.ProbabilityMeasure.toMeasure_prod` | Future wrappers if the semantic bridge wants finite/probability-measure objects instead of raw measures. |
| Kernels | `Mathlib.Probability.Kernel.Basic` and `Mathlib.Probability.Kernel.Composition.Prod` | `ProbabilityTheory.Kernel.const`, `ProbabilityTheory.Kernel.deterministic`, `ProbabilityTheory.Kernel.prod`, `ProbabilityTheory.Kernel.prod_apply_prod` | Conditional-law and Markov-kernel infrastructure. |
| Measure-kernel products | `Mathlib.Probability.Kernel.Composition.MeasureCompProd` | `MeasureTheory.Measure.compProd`, `MeasureTheory.Measure.compProd_apply`, `MeasureTheory.Measure.fst_compProd`, `MeasureTheory.Measure.snd_compProd` | Express joint laws generated from a base measure and kernel. |
| Conditional distributions | `Mathlib.Probability.Kernel.CondDistrib` | `ProbabilityTheory.condDistrib`, `ProbabilityTheory.condDistrib_apply_of_ne_zero`, `ProbabilityTheory.compProd_map_condDistrib`, `ProbabilityTheory.condDistrib_fst_prod`, `ProbabilityTheory.condDistrib_snd_prod` | Connect finite conditional laws with mathlib disintegration and conditional distribution semantics. |
| Event conditioning | `Mathlib.Probability.ConditionalProbability` | `ProbabilityTheory.cond`, `ProbabilityTheory.cond_apply`, `ProbabilityTheory.cond_isProbabilityMeasure` | Record mathlib's zero-event behavior and nonzero-event probability-measure theorem. |
| KL divergence | `Mathlib.InformationTheory.KullbackLeibler.Basic` and `Mathlib.InformationTheory.KullbackLeibler.ChainRule` | `InformationTheory.klDiv`, `InformationTheory.klDiv_self`, `InformationTheory.klDiv_eq_lintegral_klFun`, `InformationTheory.toReal_klDiv`, `InformationTheory.toReal_klDiv_eq_integral_klFun`, `InformationTheory.klDiv_compProd_left`, `InformationTheory.klDiv_compProd_eq_add` | Prove finite mutual information and later conditional mutual information equal the corresponding measure-level KL expressions. |

### Probability Mass Functions

The finite Shannon definitions should continue to build on mathlib `PMF`
rather than introducing a separate distribution type. The relevant reusable API
includes:

- `PMF.map`, including support and composition lemmas.
- `PMF.bind`, including pointwise formulas and support lemmas.
- `PMF.ofFintype`, for uniform finite distributions.
- `PMF.toMeasure`, with singleton, finset, fintype, and extensionality lemmas.
- `PMF.integral_eq_sum` and related finite-integral formulas.

These APIs are enough to connect finite sums to integrals against
`p.toMeasure`, and they are the right foundation for semantic bridge theorems
such as `H(P) = E[-log P(X)]`.

### Product Measures

The bridge layer should reuse mathlib's product-measure API rather than
formalizing product measures locally. Important pieces include:

- `MeasureTheory.Measure.prod` and product-measure application lemmas.
- Coordinate-map lemmas such as `MeasureTheory.Measure.map_fst_prod` and
  `MeasureTheory.Measure.map_snd_prod`.
- `FiniteMeasure.prod` and `ProbabilityMeasure.prod` for future wrappers.

There does not appear to be a canonical finite `PMF.prod` in the pinned mathlib
version. This means the project should add a small local product-PMF helper and
prove its relationship to `MeasureTheory.Measure.prod`.

### Kernels And Conditional Distributions

For conditional-law and conditional-mutual-information bridges, mathlib already
has a serious measure/kernel API. The bridge layer should reuse:

- `Kernel.const`, `Kernel.deterministic`, product kernels, and composition
  products.
- `MeasureTheory.Measure.compProd` and the corresponding scoped notation.
- `Kernel.condKernel`, disintegration, and uniqueness lemmas.
- `ProbabilityTheory.condDistrib`, including its pointwise singleton formula
  for nonzero conditioning mass and its comp-product characterization.

This suggests that the eventual conditional-law bridge should be compatible
with mathlib kernels, even if the finite API exposes a simpler PMF-level
interface first.

### Conditional Probability

Mathlib event conditioning is measure-based:

- `ProbabilityTheory.cond` has notation `mu[|s]`.
- It is defined by rescaling the restricted measure.
- If the conditioning event has zero mass, the resulting measure is the zero
  measure, because the inverse of zero is zero.

This is different from Rocq/Infotheo-style finite APIs that often choose an
arbitrary default distribution on zero-probability events. We should not copy a
default-distribution convention into the Lean API without making it explicit.

### Kullback-Leibler Divergence

The semantic bridge should reuse mathlib's KL divergence:

- `InformationTheory.klDiv : Measure alpha -> Measure alpha -> ENNReal`.
- `klDiv_self` and zero-characterization lemmas.
- `klDiv_eq_lintegral_klFun` and finite/integral bridge lemmas.
- `toReal_klDiv` and real-valued expansion lemmas.
- Chain-rule API in `Mathlib.InformationTheory.KullbackLeibler.ChainRule`,
  especially the comp-product identities.

The pinned mathlib KL API is measure-theoretic and returns `ENNReal`. Local
finite theorems that state real-valued formulas should isolate any required
finite-support, absolute-continuity, or integrability arguments in bridge
helper lemmas.

## Local Helpers We Probably Need

These are not new foundational definitions yet. They are the helper targets
that step 2 and step 3 should refine.

1. Independent product PMF.

   We need a local construction for the independent product of two PMFs, likely
   implemented using `PMF.bind` and `PMF.map`. The essential theorem should be
   the pointwise formula:

   ```lean
   prod p q (a, b) = p a * q b
   ```

   We should choose the name carefully so it will not fight a future mathlib
   `PMF.prod`.

2. Marginals of an independent product.

   The product helper should prove that the first and second marginals of the
   independent product recover the original PMFs. These lemmas will support the
   mutual-information-as-KL bridge and future chain rules.

3. Product PMF as product measure.

   The bridge layer should prove that the `toMeasure` of the independent
   product PMF is the product of the two `toMeasure`s, under the standard
   measurability assumptions used elsewhere in the finite API.

4. Absolute continuity of a joint law with respect to product marginals.

   For a finite joint PMF `p`, the theorem

   ```lean
   p.toMeasure.AbsolutelyContinuous
     ((fstMarginal p).toMeasure.prod (sndMarginal p).toMeasure)
   ```

   should be available in the KL bridge layer. Mathematically, if either
   marginal gives zero mass to a coordinate, then every joint atom with that
   coordinate has zero mass. This is a central helper for proving finite mutual
   information equals KL divergence from the joint law to the product of its
   marginals.

5. Finite KL expansion for PMFs.

   We will likely need a theorem converting mathlib's measure-level `klDiv`
   into the finite textbook sum

   ```lean
   sum a, p a * log (p a / q a)
   ```

   with the zero-mass and absolute-continuity conditions stated cleanly. This
   theorem should live in the semantic bridge layer, not in the lightweight
   finite Shannon core.

6. Conditional-law pointwise formulas.

   Once the conditional-law representation is chosen, we should prove pointwise
   formulas for nonzero conditioning mass and explicit simplification lemmas
   for zero conditioning mass. These lemmas will keep later conditional entropy
   and conditional mutual information proofs from becoming fragile.

## Lessons From PFR

The PFR project uses a measure-first information theory design. It defines
measure entropy, random-variable entropy, conditional entropy, mutual
information, conditional mutual information, and kernel entropy using
measure-theoretic objects and finite-support hypotheses.

Useful lessons:

- The measure/kernel layer is expressive enough for serious information theory.
- Conditional entropy is naturally expressed as an expected entropy of
  conditional laws.
- Mutual information and conditional mutual information become cleaner once
  they are connected to kernels and conditional distributions.
- Chain rules and nonnegativity theorems benefit from a semantic layer rather
  than from only expanding finite sums.

For our project, PFR is a strong guide for the semantic bridge direction, but
not a reason to abandon the local PMF-first finite API. Our finite API is
better suited for textbook discrete information theory, certificate checking,
and later computational examples.

## Lessons From Testing Lower Bounds

The `testing-lower-bounds` project contains a more general divergence
architecture, including conditional KL and f-divergence material. Its
conditional KL has the expected shape: integrate the pointwise KL divergence of
two kernels against a base measure, with explicit top/integrability cases.

Useful lessons:

- A conditional KL abstraction is important for advanced chain rules.
- The averaged conditional-divergence design is more general than what we need
  immediately.
- Mathlib's current KL chain-rule file proves comp-product KL identities
  without introducing a public averaged conditional-KL API.

For the next bridge theorem, we should use mathlib's `InformationTheory.klDiv`
directly. A local conditional-KL helper can wait until conditional mutual
information forces the issue.

## Design Decisions For The Next Step

Step 2 should be a short design note, not a proof sprint. It should decide:

1. The exact local name and namespace for the independent product PMF helper.
2. Which product-law lemmas belong in the public semantic bridge API.
3. The statement shape of the mutual-information-as-KL theorem.
4. The conditional-law representation for finite joint PMFs.
5. The zero-probability conditioning convention.
6. Which imports stay out of the lightweight finite Shannon files.

The most important guardrail is that bridge-specific imports should remain in
bridge files. The core finite Shannon API should not start importing KL,
kernels, or conditional probability merely because the semantic bridge needs
them.
