# Foundation Conventions

This note records the textbook conventions used to audit the first finite
Shannon-information layer. The local `info theory e-books/` directory is
reference material only and is intentionally not part of the repository.

## Primary References

- Cover and Thomas, *Elements of Information Theory*, Chapter 2.
- El Gamal and Kim, *Network Information Theory*, Chapter 2.
- Yeung, *Information Theory and Network Coding*, Chapter 2.
- Csiszar and Korner, *Information Theory: Coding Theorems for Discrete
  Memoryless Systems*, early chapters on finite alphabets, stochastic matrices,
  entropy, and divergence.
- Polyanskiy and Wu, *Information Theory: From Coding to Learning*, Part I.
- Klenke, Billingsley, and Durrett for the measure-theoretic probability
  background that matches mathlib's probability foundations.

## Conventions We Follow

- Finite distributions are mathlib `PMF`s. We do not introduce a project-local
  probability type.
- Entropy values live in `Real`.
- The current entropy unit is the nat, because mathlib's logarithm is natural
  logarithm and mathlib's `Real.binEntropy` is documented in nats.
- Zero-mass atoms contribute zero via mathlib's `Real.negMulLog 0 = 0`.
- Entropy is a function of a distribution. Random-variable entropy is entropy
  of the pushforward distribution under `PMF.map`.
- Finite entropy is invariant under equivalence and injective relabelings of
  the alphabet, coordinate swaps, and product reassociation; this records that
  entropy depends on masses, not atom names.
- The finite entropy upper bound by `log |alphabet|` and its uniform-law
  equality case live in
  `LeanInfoTheory.Shannon.EntropyBounds`, separated from the core entropy
  definition because the proof uses mathlib's convexity/Jensen API.
- Joint entropy is ordinary entropy of a joint distribution.
- In the entropy-expression layer, the empty atom is named explicitly as
  `EntropyExpr.empty`. Arbitrary atom interpretations do not automatically
  satisfy `H(empty) = 0`; the predicate `EntropyExpr.RespectsEmpty` records
  this convention until the abstract valuation layer packages it as a field.
- The abstract `ShannonEntropyVal` layer packages entropy-expression semantics
  independently of concrete `PMF`s. It records `H(empty) = 0`, conditional
  entropy nonnegativity for adjoining one variable, and conditional mutual
  information nonnegativity as assumptions for future certificate proofs.
- The primitive Shannon inequality expressions live in
  `LeanInfoTheory.PrimitiveIneq`. They define the formal entropy-expression
  shapes for empty entropy, conditional entropy, and conditional mutual
  information, together with their soundness theorems under
  `ShannonEntropyVal`.
- The checked certificate layer lives in `LeanInfoTheory.Certificate.Checked`.
  Raw certificates are untrusted data. Checked certificates carry
  nonnegative rational coefficients by construction and exact decomposition
  equality over normalized sparse rational entropy expressions. The first
  validator derives checked certificates from raw rational coefficients,
  proposed primitive tags, and exact decomposition matching; later import work
  should parse external certificate formats into this raw layer.
- The current `condEntropy` and `condMutualInfo` definitions use entropy
  identities. For finite variables these are equivalent to the conditional
  distribution formulas used in textbooks; proving that equivalence is an
  early theorem target.
- Mutual information is currently defined by the entropy identity
  `H(X) + H(Y) - H(X,Y)`. A later bridge should identify this with finite KL
  divergence from the joint law to the product of marginals.
- The first semantic bridge theorem lives in
  `LeanInfoTheory.Shannon.SemanticBridge`: `Shannon.selfInfo` records
  self-information with the zero-mass convention, and
  `Shannon.entropy_eq_integral_selfInfo` proves that finite entropy is expected
  self-information over `PMF.toMeasure`.

## Mathlib Boundary

The pinned mathlib already provides the following foundations, so this project
uses them directly rather than wrapping them in new definitions:

- `PMF`, including `PMF.map`, `PMF.pure`, `PMF.bind`, `PMF.ofFintype`,
  `PMF.toMeasure`, and `Measure.toPMF`.
- Basic PMF facts such as `PMF.coe_le_one`, `PMF.tsum_coe`, and
  `PMF.apply_ne_top`.
- Local real-mass bridge lemmas and pointwise `PMF.map` facts are also placed
  in the `PMF` namespace, e.g. `PMF.toReal_nonneg`, `PMF.toReal_le_one`,
  `PMF.sum_toReal`, `PMF.map_apply_of_injective`,
  `PMF.map_apply_eq_zero_of_notMem_range`, and `PMF.map_apply_equiv`,
  matching mathlib's convention for object-specific lemmas.
- `Real.negMulLog`, `Real.binEntropy`, and `Real.qaryEntropy`.
- `InformationTheory.klDiv` and the measure-theoretic KL chain-rule
  infrastructure.
- Coding-theoretic files such as Kraft-McMillan.

These heavier anchors are gathered in `LeanInfoTheory.MathlibFragments`, rather
than imported through the finite entropy API. This keeps the basic Shannon layer
cheap to import while preserving an explicit reminder of the mathlib APIs we
expect to connect to next.

## Namespace and Import Policy

- `LeanInfoTheory.Shannon` is the canonical namespace for finite Shannon
  definitions and theorem statements. Documentation and theorem-oriented code
  should generally prefer names such as `Shannon.entropy`,
  `Shannon.condEntropy`, and `Shannon.mutualInfo`.
- `LeanInfoTheory.InformationMeasures` re-exports the main finite
  information-measure API into the `LeanInfoTheory` namespace as convenience
  aliases for users who import the project root.
- The root module `LeanInfoTheory` is intentionally lightweight. It imports the
  stable finite-measure API and the core certificate/checker definitions, but
  not demo modules, heavier analytic theorem modules, KL bridge modules,
  coding anchors, or generated-reference material.
- Import `LeanInfoTheory.Shannon.EntropyBounds`,
  `LeanInfoTheory.Shannon.SemanticBridge`,
  `LeanInfoTheory.MathlibFragments`,
  `LeanInfoTheory.Certificate.Submodularity`, and
  `LeanInfoTheory.Examples` explicitly when working with those layers.
- Certificate-demo theorems stay in their descriptive namespaces, such as
  `Certificate.Submodularity.entropy_submodularity`, until enough examples
  exist to justify a separate polished theorem-facing alias layer.

In the current mathlib checkout, I did not find a general Shannon entropy
definition for an arbitrary finite `PMF`, nor finite-PMF definitions of
conditional entropy, mutual information, or conditional mutual information.
Those are the local definitions introduced here.

## Why This Shape

Cover-Thomas, El Gamal-Kim, and Polyanskiy-Wu introduce conditional entropy as
an average of entropies of conditional laws. That is the semantic picture we
should eventually expose. Yeung's entropy-inequality treatment, however,
regularly rewrites conditional mutual information as a linear combination of
ordinary entropies. Since Project A will check linear entropy-expression
certificates, the algebraic form is the most useful definitional layer.

This is a design compromise, not a mathematical change: the next foundation
milestones should prove the equivalence between the algebraic definitions and
the conditional-law/KL definitions.

The comparison with Rocq `infotheo` is recorded in `docs/project-log.md`.

## Near-Term Theorem Targets

- `condEntropy` agrees with the expected entropy of finite conditional PMFs.
- `mutualInfo` agrees with KL divergence between the joint law and product of
  marginals.
- `condMutualInfo` agrees with averaged conditional mutual information.
- Chain rules for entropy, conditional entropy, mutual information, and
  conditional mutual information.
- Nonnegativity of mutual information and conditional mutual information.
