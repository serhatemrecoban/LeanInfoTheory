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
- Logarithm-base conversion is opt-in through
  `LeanInfoTheory.Shannon.Units`. A nat-valued information quantity is
  converted to base-`b` units by division by `Real.log b`; the module supplies
  a generic change-of-base theorem and `Real.logb` entropy formulas rather
  than parallel base-indexed definitions.
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
- The stronger support-sensitive bound also lives in `EntropyBounds`:
  `entropy_le_log_support_ncard` bounds entropy by the logarithm of the number
  of nonzero atoms, and its random-variable form counts the support of the
  pushforward law. The proof restricts to a private finite support PMF and
  reuses the alphabet-cardinality theorem.
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
  distribution formulas used in textbooks. The semantic bridge now proves
  `condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd` and
  `condMutualInfo_eq_sum_thirdMarginal_mul_condMutualInfoFstSndGivenThird`,
  making those expected-fiber interpretations explicit.
- A zero-marginal conditioning fiber contributes the number zero without a
  fabricated conditional PMF. On a nonzero fiber,
  `condEntropyFstGivenSnd_eq_zero_iff_of_sndMarginal_ne_zero` says that zero
  fiber entropy is exactly purity of the canonical conditional law.
- Functional dependence is currently stated directly and support-wise:
  `condEntropyOf_eq_zero_iff_exists_function` uses
  `X omega = f (Y omega)` only for `omega in p.support`. The project does not
  impose pointwise equality outside the law's support or introduce a separate
  functional-dependence predicate at this stage.
- Triple conditional entropy follows the textbook chain rules
  `H(X,Y|Z) = H(Y|Z) + H(X|Y,Z)` and
  `H(X,Y|Z) = H(X|Z) + H(Y|X,Z)`. The lightweight declarations are stated for
  random variables; the conditional semantic bridge supplies PMF-facing forms
  using `pairThirdLaw` and the named triple marginals.
- Conditional-entropy chain rules remain explicit rewrites rather than
  `[simp]` lemmas. Expanded and unexpanded entropy expressions are both useful,
  and the Chunk 1 API review found no stable reason to choose either direction
  as an automatic normal form. Short left/right aliases are available for the
  pair chain rules.
- Mutual-information simplification removes explicit PMF coordinate swaps,
  diagonal PMF laws, and random-variable self constructions. Pure
  random-variable symmetry and entropy-difference identities remain explicit
  rewrites so simplification does not choose an arbitrary variable ordering or
  entropy normal form.
- Deterministic processing cannot increase finite entropy. Equality
  `H(f(X)) = H(X)` is characterized by `Set.InjOn f (p.map X).support`, because
  the relevant injectivity is on the values actually taken by `X`, not on the
  source outcome space.
- Conditionally,
  `H(X|Z) = H(f(X)|Z) + H(X|f(X),Z)`. Thus `H(f(X)|Z) <= H(X|Z)`, with equality
  exactly when `X` can be recovered from `(f(X), Z)` on `p.support`. This is a
  deterministic theorem; stochastic channels and general data processing
  remain later infrastructure.
- Mutual information is currently defined by the entropy identity
  `H(X) + H(Y) - H(X,Y)`. The semantic bridge now identifies it with finite KL
  divergence from the joint law to the product of marginals through
  `mutualInfo_eq_toReal_klDiv_joint_indepProd` and the product-measure form
  `mutualInfo_eq_toReal_klDiv_joint_prod_marginals`.
- The lightweight theorem API also exposes the equivalent textbook forms
  `I(X;Y) = H(X) - H(X|Y)` and `I(X;Y) = H(Y) - H(Y|X)`, plus
  `I(X;X) = H(X)`. These remain explicit rewrites; later inequality proofs and
  the planned API review should determine whether reverse-oriented aliases or
  any simp attributes are useful.
- The lightweight conditional-mutual-information API exposes
  `I(X;Y|Z) = H(X|Z) - H(X|Y,Z)`, its symmetric form in `Y`, and
  `I(X;Y|Z) = H(X|Z) + H(Y|Z) - H(X,Y|Z)`. These remain explicit rewrite
  theorems and supply the normal forms for the next triple-level inequality
  step.
- Deterministic mutual-information processing follows the exact decomposition
  `I(X;Y) = I(f(X);Y) + I(X;Y|f(X))`. Consequently, applying deterministic
  maps to the left variable, the right variable, or both variables cannot
  increase mutual information. This finite theorem does not introduce
  stochastic channels or the later general data-processing infrastructure.
- Semantic nonnegativity yields the pair-level bounds
  `H(X|Y) <= H(X)`, `I(X;Y) <= H(X), H(Y)`, and
  `H(X), H(Y) <= H(X,Y) <= H(X) + H(Y)`. Equality characterizations involving
  independence remain deferred to the later finite KL/equality layer.
- At the triple level, semantic nonnegativity and the CMI identities yield
  `I(X;Y|Z) <= H(X|Z), H(Y|Z)` and the conditional entropy band
  `H(X|Z), H(Y|Z) <= H(X,Y|Z) <= H(X|Z) + H(Y|Z)`. Equality
  characterizations involving conditional independence remain deferred.
- The semantic bridge lives in `LeanInfoTheory.Shannon.SemanticBridge` and its
  subfiles. It includes `Shannon.selfInfo`,
  `Shannon.entropy_eq_integral_selfInfo`, finite conditional laws,
  mutual-information-as-KL theorems, averaged conditional-KL for conditional
  mutual information, semantic nonnegativity of mutual information and
  conditional mutual information, PMF-facing triple conditional-entropy chain
  rules, deterministic entropy processing and equality cases,
  mutual-information chain rules, deterministic mutual-information processing,
  and both PMF conditional-entropy difference forms for conditional mutual
  information, together with PMF and random-variable triple-level conditional
  inequalities.

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
milestones should continue extending the theorem layer while preserving the
separation between lightweight entropy-identity definitions and heavier
semantic bridge imports.

The comparison with Rocq `infotheo` is recorded in `docs/project-log.md`.

## Near-Term Theorem Targets

- Further chain rules for entropy, mutual information, and conditional mutual
  information, building on the completed pair/triple conditional-entropy
  family.
- Conditioning-reduces-entropy and equality conditions.
- Stochastic data-processing and Markov-chain APIs, building on the completed
  deterministic entropy-processing results.
- Concrete finite semantics for the abstract certificate assumptions.
- More textbook entropy inequalities and certificate examples.
