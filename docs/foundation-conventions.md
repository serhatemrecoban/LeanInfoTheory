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
- A finite discrete channel is represented directly by a PMF-valued function
  `W : alpha -> PMF beta`; alphabets are not bundled into a channel structure.
  Output and identity remain mathlib's `p.bind W` and `PMF.pure`. The opt-in
  `LeanInfoTheory.Probability.FiniteChannel` module names deterministic
  channels, channel composition, induced joint laws, and pair-to-triple
  extension, together with their elementary atom, projection, algebra,
  deterministic-map, and support laws. It has no Shannon, kernel,
  measurable-space, or KL dependency.
- The total conditional channel lives in the opt-in
  `LeanInfoTheory.Shannon.SemanticBridge.Markov` module. For a joint law `p`,
  `condFstGivenSndChannel p` uses the canonical `condFstGivenSnd` on positive
  second-coordinate fibers and `fstMarginal p` on null fibers. The fallback is
  only a totality device; semantic consequences must make the null choice
  irrelevant through weighting or support conditions. The established theorem
  layer proves arbitrary-fallback irrelevance on null fibers, all-fiber atom
  reconstruction, and reconstruction of `p.map Prod.swap` from
  `sndMarginal p` and the total channel.
- The same opt-in semantic module owns the Markov predicates.
  `IsMarkovChainOf p X Y Z` means that `X` and `Z` are conditionally
  independent given `Y`, and `IsMarkovChain p` applies that definition to the
  three coordinate projections of a triple PMF. These predicates introduce no
  finiteness or measurable-space assumptions. The PMF predicate is equivalent
  to `p(a,b,c) p_B(b) = p_AB(a,b) p_BC(b,c)` and to independence of the
  endpoints on every positive middle-coordinate fiber. For finite alphabets,
  `IsMarkovChainOf p X Y Z` is equivalent to `I(X;Z|Y) = 0`. Reversing the
  endpoint order preserves both Markov predicates. The assumption-free theorem
  `isMarkovChain_channelExtension` states that extending any `(A,B)` law by a
  channel depending only on `B` produces `A -> B -> C`. Conversely, when the
  third alphabet is finite, every Markov triple is reconstructed from its
  first-two marginal by the total conditional channel extracted from its
  second-third marginal, and equivalently factors through some middle-to-third
  channel. For finite alphabets,
  `mutualInfo_markov_chain_rule` and `mutualInfoOf_markov_chain_rule` give the
  exact loss identity `I(X;Y) = I(X;Z) + I(X;Y|Z)` under that Markov condition.
  Its nonnegative remainder gives `I(X;Z) <= I(X;Y)` and the equivalent
  conditional-entropy inequality `H(X|Y) <= H(X|Z)`; equality holds exactly
  when the reverse chain `X -> Z -> Y` is also Markov. The channel-facing
  corollaries process either coordinate, process both coordinates through
  conditionally independent channels, contract two-stage channel cascades,
  and recover deterministic output mapping as a specialization. The
  independently two-sided output law is written directly with `PMF.bind` and
  `indepProd`; no additional channel construction is introduced.
- Finite KL data processing follows a separately importable kernel-chain-rule
  bridge rather than a project-local log-sum engine. The opt-in
  `Shannon.SemanticBridge.DataProcessing` module now converts a raw PMF channel
  with `pmfChannelKernel`, built from `Kernel.ofFunOfCountable`, and
  `channelJoint_toMeasure` identifies kernel `compProd` with
  `PMF.channelJoint`. `channelPosterior` reuses the existing total conditional
  channel, its PMF reconstruction theorem makes the null-output fallback
  irrelevant, and `klDiv_channel_eq_add_posterior` supplies the exact finite
  decomposition needed for contraction. The primary contraction theorem is
  unconditional and `ENNReal`-valued. Its real corollary requires only input
  support inclusion, which is preserved by `PMF.bind`. The public theorem
  family now includes common stochastic channels, deterministic maps, and
  channel cascades in both the applicable `ENNReal` and real-valued forms. The
  one-step invariant-reference corollaries reuse that family directly.
  Uniform-preserving channels increase entropy by the established full-
  alphabet uniform KL identity, and a PMF channel with unit column sums gives
  the finite doubly stochastic specialization. No matrix or process
  representation is introduced. The module stays opt-in and does not change
  the raw PMF-valued channel convention.
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
- The finite entropy upper bound by `log |alphabet|` and its exact equality
  characterization, equality iff the PMF is `PMF.uniformOfFintype`, live in
  `LeanInfoTheory.Shannon.EntropyBounds`, separated from the core entropy
  definition because the proof uses mathlib's convexity/Jensen API.
- The stronger support-sensitive bound also lives in `EntropyBounds`:
  `entropy_le_log_support_ncard` bounds entropy by the logarithm of the number
  of nonzero atoms, and its random-variable form counts the support of the
  pushforward law. `PMF.supportFinset` is the canonical public finite view of
  the set-valued support; the proof still keeps the stronger support-restricted
  PMF private and reuses the alphabet-cardinality theorem. Equality holds
  exactly when the PMF, or the random variable's pushforward law, is uniform on
  that support.
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
  deterministic theorem and remains distinct from the completed stochastic-
  channel and general data-processing layer.
- Mutual information is currently defined by the entropy identity
  `H(X) + H(Y) - H(X,Y)`. The semantic bridge now identifies it with finite KL
  divergence from the joint law to the product of marginals through
  `mutualInfo_eq_toReal_klDiv_joint_indepProd` and the product-measure form
  `mutualInfo_eq_toReal_klDiv_joint_prod_marginals`.
- For PMF measures with measurable singletons, absolute continuity is exactly
  support inclusion. On a finite alphabet, this is also exactly the condition
  that mathlib's `InformationTheory.klDiv` is not `⊤`; failure of inclusion
  makes KL equal to `⊤`. This support-sensitive `ENNReal` distinction must be
  preserved before taking `ENNReal.toReal`, since `ENNReal.toReal ⊤ = 0`.
- PMF KL divergence itself is zero exactly when the two PMFs are equal; this
  specialization does not require a finite alphabet. The real-valued theorem
  `toReal_klDiv_pmf_eq_zero_iff` does require a finite alphabet and explicit
  support inclusion, which rules out the otherwise indistinguishable `⊤`
  branch of `ENNReal.toReal_eq_zero_iff`.
- For a finite PMF supported on a nonempty finset `s`, the uniform-reference
  identity is `D(P || U_s) = log |s| - H(P)`. The primary theorem keeps the
  support inclusion explicit, and the full-alphabet corollary specializes to
  `PMF.uniformOfFintype`. This KL identity remains in the semantic bridge and
  does not make `Shannon.EntropyBounds` depend on KL infrastructure. The sharp
  entropy equality cases are proved independently there with strict Jensen.
- Ordinary independence is PMF-first in the separately importable
  `Shannon.SemanticBridge.Independence` module. `IsIndependent p` states that a
  joint law equals `indepProd` of its two marginals, while `IsIndependentOf p X
  Y` applies that predicate to the mapped joint law. Pointwise marginal
  factorization and coordinate-swap symmetry are derived theorems. The
  predicates themselves do not choose measurable-space instances; the bridge
  `isIndependentOf_iff_indepFun` to mathlib
  `ProbabilityTheory.IndepFun` keeps measurability and measurable-singleton
  assumptions explicit. For finite alphabets,
  `mutualInfo_eq_zero_iff_isIndependent` and its `...Of` form hide only a local
  discrete measurable-space choice and state the assumption-free textbook
  equivalence between zero mutual information and independence. Consequently,
  conditioning preserves entropy and joint entropy is additive exactly under
  independence, with PMF and random-variable forms in the same module. The
  short `jointEntropy_additive_iff_isIndependent` and
  `jointEntropyOf_additive_iff_isIndependentOf` declarations are compatibility
  aliases; the descriptive equality names remain available.
- The conditional-independence layer is likewise PMF-first.
  `condMutualInfo_eq_zero_iff_condMutualInfoFstSndGivenThird_eq_zero` states
  that `I(A;B|C) = 0` exactly when every fiber with `P_C(c) != 0` has zero
  mutual information. Null fibers are excluded from the pointwise hypothesis
  and contribute zero through their weight. `IsCondIndependent p` is the
  proof-independent atomwise identity
  `p(a,b,c) p_C(c) = p_AC(a,c) p_BC(b,c)`, while
  `IsCondIndependentOf p X Y Z` applies it to the mapped triple law. The theorem
  `isCondIndependent_iff_isIndependent_condFstSndGivenThird` proves that this
  primary definition is equivalent to ordinary independence of every positive-
  mass conditional joint law. The definitions require no finite alphabets; the
  fiber theorem needs only finite first and second alphabets, not a finite
  conditioning alphabet. For finite alphabets,
  `condMutualInfo_eq_zero_iff_isCondIndependent` and its `...Of` form give the
  assumption-free textbook equivalence between zero conditional mutual
  information and conditional independence. Consequently, conditioning on the
  second coordinate preserves the first coordinate's entropy given the third,
  and conditional joint entropy is additive, exactly under conditional
  independence, with PMF and random-variable forms in the same module. The
  `condEntropy_pair_additive_iff_isCondIndependent` and `...Of` declarations
  provide the reviewed short additive aliases without introducing
  `jointCondEntropy` terminology. Conditional independence is symmetric in its
  first two variables through `isCondIndependent_map_swap12` and
  `isCondIndependentOf_swap`; only the PMF coordinate-construction theorem is
  a simp normalization rule.
- The lightweight theorem API also exposes the equivalent textbook forms
  `I(X;Y) = H(X) - H(X|Y)` and `I(X;Y) = H(Y) - H(Y|X)`, plus
  `I(X;X) = H(X)`. These remain explicit rewrites. The completed inequality
  and API reviews found no stable need for reverse-oriented aliases or further
  simp attributes; reconsider them only after repeated downstream use.
- The lightweight conditional-mutual-information API exposes
  `I(X;Y|Z) = H(X|Z) - H(X|Y,Z)`, its symmetric form in `Y`, and
  `I(X;Y|Z) = H(X|Z) + H(Y|Z) - H(X,Y|Z)`. These remain explicit rewrite
  theorems and supplied the normal forms for the completed triple-level
  inequality family.
- Deterministic mutual-information processing follows the exact decomposition
  `I(X;Y) = I(f(X);Y) + I(X;Y|f(X))`. Consequently, applying deterministic
  maps to the left variable, the right variable, or both variables cannot
  increase mutual information. This finite theorem remains distinct from the
  separately importable stochastic-channel data-processing infrastructure.
- Semantic nonnegativity yields the pair-level bounds
  `H(X|Y) <= H(X)`, `I(X;Y) <= H(X), H(Y)`, and
  `H(X), H(Y) <= H(X,Y) <= H(X) + H(Y)`. The independence-governed endpoints
  are now closed: `H(X|Y) = H(X)` and
  `H(X,Y) = H(X) + H(Y)` are equivalent to independence. MI-upper and
  marginal-to-joint equality instead reduce to zero conditional entropy and
  support-wise functional dependence; they are not independence statements.
- At the triple level, semantic nonnegativity and the CMI identities yield
  `I(X;Y|Z) <= H(X|Z), H(Y|Z)` and the conditional entropy band
  `H(X|Z), H(Y|Z) <= H(X,Y|Z) <= H(X|Z) + H(Y|Z)`. Equality
  in conditioning-reduces-entropy and conditional subadditivity is now
  characterized by conditional independence. The other band endpoints reduce
  to zero conditional entropy and support-wise functional dependence instead.
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
  inequalities and the positive-fiber characterization of zero averaged
  conditional mutual information, plus the proof-independent conditional-
  independence predicates, their conditional-law characterization, and the
  PMF/random-variable zero-CMI and conditional-entropy equality equivalences.

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
- The local channel constructions likewise extend the `PMF` namespace as
  `PMF.deterministicChannel`, `PMF.channelComp`, `PMF.channelJoint`, and
  `PMF.channelExtension`; they do not wrap `PMF.bind` or `PMF.pure` under
  parallel output or identity definitions.
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
  `LeanInfoTheory.Probability.FiniteChannel`,
  `LeanInfoTheory.Shannon.SemanticBridge.Markov`,
  `LeanInfoTheory.Shannon.SemanticBridge.DataProcessing`,
  `LeanInfoTheory.Shannon.SemanticBridge`,
  `LeanInfoTheory.MathlibFragments`,
  `LeanInfoTheory.Certificate.Submodularity`, and
  `LeanInfoTheory.Examples` explicitly when working with those layers.
- The semantic examples remain opt-in. Import
  `LeanInfoTheory.Examples.SupportSensitive` for support-aware entropy,
  conditional-fiber, functional-dependence, and recovery examples, or
  `LeanInfoTheory.Examples.KLTop` for the disjoint-support real-KL trap. The
  `LeanInfoTheory.Examples` aggregate imports both, but the project root imports
  neither.
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

## Post-Chunk-3 Guardrails

- The common-cause and genuinely stochastic examples and the scheduled naming,
  simp, module-boundary, and future-work review are complete.
- Let concrete channel and Markov consumers determine whether independence
  predicates need a lighter module boundary and which closure or symmetry
  conveniences are justified.
- Use Future Work Note 29 as the next Project B planning anchor: design a
  focused sufficient-statistics and recovery-equality phase first, then plan
  Fano separately. Do not begin either phase until its execution plan is
  explicitly locked.
- Keep concrete finite semantics for abstract certificate assumptions and
  richer certificate examples in later Project A work.
