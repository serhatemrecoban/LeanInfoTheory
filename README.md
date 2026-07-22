# LeanInfoTheory

[![Lean build and placeholder check](https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/lean_action_ci.yml/badge.svg)](https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/lean_action_ci.yml)
[![Deploy website](https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/pages.yml/badge.svg)](https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/pages.yml)

Lean-certified information measures and entropy-inequality automation for
classical and network information theory.

## Positioning

Lean/mathlib already contains important information-theoretic fragments:
binary and q-ary entropy functions, measure-theoretic KL divergence, coding
basics, and the Kraft-McMillan inequality. Recent downstream projects such as
PFR also developed substantial entropy infrastructure. This repository is meant
to be complementary: an information-theorist-facing Lean library for finite
information measures, entropy-inequality certificates, and eventually
network-information-theory converse proofs.

The project is deliberately mathlib-based. It should not grow a toy probability
model such as `Probability := Rat`; entropy values live in `Real`, distributions
come from mathlib probability objects, and generic lemmas should be upstreamed
when they stabilize.

## Current Status

- Lake project initialized with Lean `v4.30.0` and mathlib `v4.30.0`.
- Mathlib cache fetched successfully for local builds.
- GitHub Actions runs the lightweight root build, a strict no-placeholder
  scan, and explicit builds for separately importable theorem/demo modules.
- Initial module structure added under `LeanInfoTheory/`.
- Finite Shannon entropy and entropy-derived information measures now use
  mathlib `PMF`s and `Real.negMulLog`.
- Zero entropy is characterized exactly: a finite PMF is pure, and a
  finite-valued random variable is constant on the source PMF support.
- Finite entropy is proved invariant under equivalence and injective alphabet
  relabelings, coordinate swaps, and product reassociation.
- A Jensen-based finite entropy upper bound is sharp exactly at the uniform law;
  both the bound and equality characterization are proved in
  `LeanInfoTheory.Shannon.EntropyBounds`.
- The stronger support-sensitive bounds `H(P) <= log |support P|` and
  `H(X) <= log |support (law X)|` are also proved in the opt-in bounds module,
  together with equality exactly when the relevant law is uniform on its
  support.
- Semantic bridge theorems connect the finite API to expected
  self-information, conditional laws, KL divergence, semantic nonnegativity,
  zero conditional entropy as support-wise functional dependence, pair/triple
  conditional-entropy and mutual-information chain rules, deterministic
  entropy processing with exact support-aware equality cases, deterministic
  mutual-information processing, and conditioning-reduces-entropy.
- For PMF measures, absolute continuity is characterized by support inclusion;
  on a finite alphabet, this is equivalent to KL divergence being non-infinite,
  while failed support inclusion is equivalent to infinite KL divergence.
- PMF KL divergence is zero exactly for equal PMFs. On finite alphabets, the
  corresponding `ENNReal.toReal` zero characterization is available under the
  necessary support-inclusion guard.
- Against a uniform law on a nonempty finset containing the PMF support, KL
  divergence is `log |s| - H(P)`; the semantic bridge also provides the
  full-alphabet `PMF.uniformOfFintype` form.
- PMF and random-variable independence are represented by `IsIndependent` and
  `IsIndependentOf`, with pointwise marginal factorization, independent-product
  construction, symmetry theorems, and an explicit-measurability bridge to
  mathlib `ProbabilityTheory.IndepFun`.
- Finite mutual information is zero exactly for an independent joint law, with
  parallel PMF and random-variable theorems.
- Conditioning preserves entropy, and joint entropy is additive, exactly for
  independent finite joint laws; both statements have PMF and random-variable
  forms.
- Zero conditional mutual information is now reduced to a pointwise condition:
  every positive-mass conditional joint fiber has zero mutual information.
- Conditional independence is represented by `IsCondIndependent` and
  `IsCondIndependentOf`. The PMF predicate uses the proof-independent
  cross-product factorization, which is equivalent to ordinary independence
  of every positive-mass conditional joint law.
- Finite conditional mutual information is zero exactly under conditional
  independence, at both PMF and random-variable levels.
- Conditioning preserves conditional entropy, and conditional joint entropy is
  additive, exactly under conditional independence; both equality families
  have PMF and random-variable forms.
- The lightweight finite API includes the equivalent identities
  `I(X;Y) = H(X) - H(X|Y)`, `I(X;Y) = H(Y) - H(Y|X)`, and
  `I(X;X) = H(X)`.
- Conditional mutual information has all three standard conditional-entropy
  forms, including both differences `H(X|Z) - H(X|Y,Z)` and
  `H(Y|Z) - H(Y|X,Z)`, and the conditional subadditivity gap
  `H(X|Z) + H(Y|Z) - H(X,Y|Z)`.
- The separately importable `LeanInfoTheory.Shannon.Units` module converts the
  canonical nat-valued quantities to other logarithm bases without duplicating
  the information-measure definitions.
- The semantic theorem API proves `H(X|Y) <= H(X)`, bounds mutual information
  by either marginal entropy, and places joint entropy between each marginal
  and their sum. Deterministic maps of either or both variables cannot increase
  mutual information. Conditionally, it proves
  `I(X;Y|Z) <= H(X|Z), H(Y|Z)` and
  `H(X|Z), H(Y|Z) <= H(X,Y|Z) <= H(X|Z) + H(Y|Z)`.
- Closed theorem examples are present in the algebraic and checked certificate
  layers.
- Checked certificate demos now cover entropy submodularity, entropy
  subadditivity, one-variable entropy monotonicity, and three-way entropy
  subadditivity.
- Website dashboard, theorem highlights, module guide, certificate-demo pages,
  generated module dependency map, and source-derived declaration index live in
  `home_page/`.
- Blueprint and roadmap notes live in `blueprint/` and `docs/`.
- Project B Chunk 1 is complete: all 14 pair/triple finite-Shannon steps and
  the full root/bounds/units/semantic/reference/certificate/example milestone
  suite pass.
- Project B Chunk 2 is complete. All 18 steps are finished, including finite
  KL support/equality, uniform-reference identities, and the sharp alphabet-
  and support-cardinality entropy bounds, plus the ordinary PMF and random-
  variable independence predicates, their mathlib `IndepFun` bridge, and the
  zero-MI and pair-entropy equality characterizations. Zero averaged
  conditional MI is also characterized by pointwise zero MI on every positive-
  mass fiber, and conditional independence now has its cross-product and
  positive-fiber formulations. Zero conditional mutual information is now
  equivalent to conditional independence at PMF and random-variable levels;
  the resulting conditioning and conditional-additivity equality cases are
  also closed. Separately importable examples now exercise the support-aware
  equality contracts and the non-absolutely-continuous `KL = ⊤` / `toReal = 0`
  trap. The API review added only four compatibility-preserving additive-
  entropy aliases, retained the existing simp and module boundaries, and kept
  speculative fiber, uniform-law, relabeling, and KL-helper APIs deferred. The
  complete ten-target milestone suite, generated-reference pass, website
  checks, and repository hygiene review all pass. Commit `e5e9825` served as
  the clean checkpoint for Chunk 3.
- Project B Chunk 3 is complete. All 20 steps of its revised channel, Markov,
  and data-processing plan are finished. The separately importable
  `Probability.FiniteChannel` module keeps channels as raw PMF-valued functions
  and now provides the basic atom, projection, algebra, deterministic-map, and
  support laws for its four constructions. The new opt-in
  `SemanticBridge.Markov` module adds the total conditional channel, proves its
  branch and null-fiber irrelevance laws, and reconstructs the original pair
  law in channel order. It now also defines `IsMarkovChain` and
  `IsMarkovChainOf`; the independence layer supplies the required first-two-
  variable conditional-independence symmetry. Markov structure is now
  characterized by its atomwise cross-product law, positive conditional
  fibers, zero conditional mutual information, and chain reversal. Extending
  any pair law through a channel on its second coordinate now produces a
  Markov triple. The PMF and random-variable APIs expose the exact Markov loss
  identity `I(X;Y) = I(X;Z) + I(X;Y|Z)`, mutual-information data processing,
  its conditional-entropy form, and equality exactly under the reverse chain
  `X -> Z -> Y`. The channel-facing API now applies that theorem to left,
  right, and independently two-sided processing, channel cascades, and
  deterministic output maps. The converse is now complete: every finite Markov
  triple is canonically reconstructed by extending its first-two marginal with
  the total middle-to-third conditional channel, and equivalently factors
  through some such channel. The Step 13 no-placeholder checkpoint selected a
  finite kernel-chain-rule proof of KL contraction: bridge raw PMF channels to
  mathlib kernels, reconstruct swapped joint laws with the existing total
  posterior channel, and use mathlib's KL chain rule. The primary result is
  unconditional and `ENNReal`-valued; its real corollary needs only input
  support inclusion. The new opt-in `SemanticBridge.DataProcessing` module now
  implements the PMF-to-kernel bridge and identifies `PMF.channelJoint` with
  mathlib's measure-kernel composition product. It now also defines the total
  `channelPosterior`, reconstructs the induced joint PMF from the output law
  and posterior, and proves the exact `klDiv_channel_eq_add_posterior`
  decomposition. Its nonnegative remainder yields the finite KL contraction
  engine with no support assumption. The public API now includes primary
  stochastic-channel, support-guarded real, deterministic-map, and channel-
  cascade data-processing inequalities. It now also proves one-step KL
  contraction toward invariant reference laws and entropy growth under
  uniform-preserving and finite doubly stochastic channels. The new opt-in
  common-cause and stochastic-channel examples exercise conditional
  independence, zero CMI, Markov factorization, cascade contraction, and strict
  entropy growth. The scheduled naming review added five compatibility aliases,
  retained the existing simp and module boundaries, and inlined the unused
  private KL contraction wrapper. The final integration pass rebuilt all ten
  milestone targets, regenerated both public reference sets, passed the website,
  root-isolation, consumer, and repository-hygiene checks, and left the
  lightweight root unchanged.
- The revised 20-step Project B Chunk 4 plan governed by Future Work Note 29 is
  complete. It develops finite sufficient statistics, exact recovery, and
  guarded KL equality.
  `isMarkovChainOf_comp` gives the type-generic
  deterministic forward chain, while `condEntropyOf_dataProcessing_eq_iff`
  supplies its entropy-facing equality characterization and
  `condEntropy_dataProcessing_eq_iff` is the pressure-justified PMF companion.
  The new opt-in
  `SemanticBridge.Sufficiency` core now defines the fixed-prior predicate and
  induced triple law and characterizes it through reverse Markov, zero CMI, MI
  preservation, conditional-entropy preservation, and one-channel full-joint
  recovery. Marginal recovery is exposed only as a one-way consequence. The
  family-level `IsSufficientChannel` predicate now requires one common recovery
  channel for every model law, and `IsSufficientStatistic` is its deterministic
  specialization. Family sufficiency is now characterized by one common
  posterior on every supported output fiber, with null fibers unconstrained;
  the identity statistic is sufficient for every model family. One common
  recovery channel now yields reverse Markov structure, zero CMI, mutual-
  information preservation, and conditional-entropy preservation under every
  parameter prior. Conversely, reverse Markov structure under one full-support
  prior already characterizes family sufficiency; finite nonempty parameter
  alphabets therefore admit the standard all-priors channel and deterministic-
  statistic equivalences. The permanent opt-in
  `Examples.SufficientStatistics` module now validates a genuinely noninjective
  sufficient statistic, a non-sufficient constant statistic, and the marginal-
  recovery false positive while exercising the fixed-prior, family, exact-
  recovery, all-prior, Fisher-Neyman, and KL-equality surfaces. The finite
  Fisher-Neyman theorem now characterizes
  deterministic family sufficiency by a parameter/statistic factor and one
  parameter-independent observation factor, using finite `ENNReal` values and
  private fiber normalization. The downstream data-processing layer retains
  `klDiv_channel_eq_iff_posterior_ae_eq` as its measure-level bridge and now
  exposes `klDiv_channel_eq_iff_posterior_eq_on_support` as the primary finite
  form: equality in KL data processing is exactly equality of posterior PMFs
  on every output atom reached by the first law. Its guarded real-valued
  companion has the same pointwise criterion. The new downstream
  `SemanticBridge.Sufficiency.KL` module proves
  `klDiv_channel_eq_of_common_recovery`: one channel that exactly recovers the
  complete output-input joint laws for two inputs preserves their `ENNReal` KL
  divergence, with no support guard. Under input support inclusion, the same
  module now characterizes both `ENNReal` and real KL equality by existence of
  one such recovery channel, with map-facing deterministic-statistic forms.
  Family sufficiency now preserves `ENNReal` KL divergence between every pair
  of model laws, with a direct deterministic-statistic specialization. For a
  Boolean-indexed two-law model under directed support inclusion, that one KL
  equality also characterizes channel or statistic sufficiency; no larger-
  family converse from unrelated pairwise witnesses is claimed.
  Step 19 retained every public name, simp rule, and module boundary after the
  permanent examples and import probes, and completed the textbook-facing
  source documentation. Step 20 passed the complete ten-target build suite,
  guarded boundary consumers, representative axiom checks, both source-derived
  generators, the website checker, and repository hygiene. The lightweight
  sufficiency core and root remain unchanged. Fano is the next separately
  planned Project B phase, and Future Work Note 39 defers canonical/minimal
  sufficiency and larger iid examples.

## Lean Modules

- `LeanInfoTheory.Basic`: lightweight project namespace and shared status
  vocabulary.
- `LeanInfoTheory.MathlibFragments`: heavier mathlib anchors we expect to use
  later, including binary/q-ary entropy, KL divergence, KL chain rules, PMF
  constructions, and Kraft-McMillan.
- `LeanInfoTheory.Probability.Finite`: real-mass bridge lemmas, the canonical
  finite `PMF.supportFinset` view, and reusable pointwise `PMF.map` facts in the
  `PMF` namespace for finite Shannon sums and relabeling arguments, plus the
  pure-law/singleton-support equivalence.
- `LeanInfoTheory.Probability.FiniteChannel`: opt-in, type-generic PMF channel
  constructions and their elementary laws. It names deterministic channels,
  channel composition, induced input-output joint laws, and pair-to-triple
  extension without introducing a bundled channel type or heavier semantic
  imports.
- `LeanInfoTheory.Shannon.Entropy`: finite Shannon entropy in nats, with
  nonnegativity, zero-entropy characterizations, and relabeling-invariance
  theorems.
- `LeanInfoTheory.Shannon.EntropyBounds`: Jensen-based alphabet and support
  upper bounds, including `entropy_le_log_card` and
  `entropy_le_log_support_ncard`, plus PMF and mapped-law characterizations of
  equality as uniformity on the alphabet or support. It stays separate from the
  lightweight entropy definition because it imports convexity/Jensen tools.
  Import this module explicitly when using these bounds.
- `LeanInfoTheory.Shannon.InfoMeasures`: conditional entropy, mutual
  information, conditional mutual information, named marginals, and
  random-variable versions, including both triple conditional-entropy chain
  rules and the elementary mutual-information and conditional-mutual-
  information identity families.
- `LeanInfoTheory.Shannon.Units`: small opt-in logarithm-base conversion layer.
  The canonical definitions remain measured in nats; this module relates
  division by `Real.log` to `Real.logb` formulas without duplicating the
  information-measure hierarchy.
- `LeanInfoTheory.Shannon.SemanticBridge.Independence`: separately importable
  PMF and random-variable independence predicates, their pointwise/product-law
  forms, symmetry facts, and the explicit bridge to mathlib
  `ProbabilityTheory.IndepFun`, together with the zero-mutual-information
  equivalences, pair-level entropy equality cases, and the positive-fiber
  characterization of zero averaged conditional mutual information. It also
  contains the PMF and random-variable conditional-independence predicates and
  the equivalence between cross-product factorization and independence of each
  positive-mass conditional law, together with the zero-conditional-mutual-
  information equivalences and conditional-entropy equality cases, with short
  `...additive_iff...` aliases for ordinary and conditional joint entropy.
- `LeanInfoTheory.Shannon.SemanticBridge.Markov`: opt-in channel-facing
  semantic layer. It defines the PMF and random-variable Markov predicates and
  the total conditional channel
  `condFstGivenSndChannel`, using the canonical conditional PMF on positive
  fibers and the first marginal as a technically convenient null-fiber
  fallback, and proves weighted atom and pair-law reconstruction. Its Markov
  API includes cross-product, positive-fiber, zero-CMI, and reversal
  characterizations, together with the fact that `PMF.channelExtension`
  generates a Markov triple, the canonical and existential channel-
  factorization converses, the exact PMF/random-variable information-loss chain
  rules, data-processing and equality theorems, and one-sided, two-sided,
  cascade, and deterministic channel-facing consequences.
- `LeanInfoTheory.Shannon.SemanticBridge.Sufficiency`: lightweight opt-in
  sufficient-statistics core. It imports the Markov layer but not the
  kernel/KL data-processing layer, defines fixed-prior sufficiency through
  `IsSufficientStatisticOf`, and records the complete induced
  parameter-statistic-observation law as `statisticTripleLawOf`. The predicate
  is characterized equivalently by reverse Markov structure, zero conditional
  mutual information, mutual-information preservation, and conditional-
  entropy preservation. It is also equivalent to exact reconstruction of the
  complete induced law by one channel from statistic values to observations;
  observation-marginal recovery is retained only as a consequence. At model-
  family level, `IsSufficientChannel` asks one shared recovery channel to
  reconstruct every complete output-input joint law, while
  `IsSufficientStatistic` specializes this contract to deterministic channels.
  The identity statistic is sufficient for every model family. Common family
  recovery also implies reverse Markov structure, zero CMI, mutual-information
  preservation, and conditional-entropy preservation for every parameter
  prior.
- `LeanInfoTheory.Shannon.SemanticBridge.DataProcessing`: opt-in bridge from
  raw PMF-valued channels to mathlib Markov kernels. It provides
  `pmfChannelKernel`, its Markov-kernel instance, and
  `channelJoint_toMeasure`, which identifies the induced PMF joint law with
  mathlib's measure-kernel composition product. It also provides the total
  `channelPosterior`, PMF-level joint reconstruction, the supported common-
  posterior characterization of `IsSufficientChannel`, and the exact
  `klDiv_channel_eq_add_posterior` identity. It exposes KL contraction through
  a common channel in unconditional `ENNReal` and support-guarded real forms,
  together with deterministic-map and channel-cascade specializations. It also
  gives invariant-reference contraction and entropy growth under uniform-
  preserving and doubly stochastic channels, without changing the lightweight
  root.
- `LeanInfoTheory.Shannon.SemanticBridge.Sufficiency.KL`: downstream opt-in KL
  integration for exact recovery. It imports `DataProcessing`, leaves the
  lightweight sufficiency core untouched, and proves pairwise `ENNReal` KL
  preservation from one channel that exactly recovers both complete output-
  input joint laws. Under input support inclusion it gives the converse for
  `ENNReal` and real KL equality, plus deterministic-map specializations stated
  with graph pushforwards.
- `LeanInfoTheory.Shannon.SemanticBridge`: separated heavier bridge layer;
  contains finite entropy as expected self-information, finite conditional-law
  formulas, PMF support characterizations of absolute continuity and KL
  finiteness, PMF KL equality and uniform-reference identities, mutual
  information as KL divergence,
  conditional mutual information as averaged fiber mutual information and
  averaged fiber KL, semantic nonnegativity, zero conditional entropy as
  functional dependence,
  PMF-facing triple conditional-entropy chain rules, mutual-information chain
  rules, deterministic entropy processing and recovery equality cases,
  pair-level entropy and mutual-information inequalities, deterministic
  mutual-information processing, PMF-facing conditional-MI difference forms,
  triple-level conditional inequalities and subadditivity,
  conditioning-reduces-entropy, the total conditional channel, the finite
  independence predicates, and the cross-product/positive-fiber/zero-CMI
  conditional-independence bridge with its entropy equality cases.
- `LeanInfoTheory.InformationMeasures`: public re-export for finite information
  measures and their core rewrite lemmas. Binary and q-ary entropy remain mathlib names:
  `Real.binEntropy` and `Real.qaryEntropy`.
- `LeanInfoTheory.EntropyExpr`: formal rational linear combinations of entropy
  atoms, including the empty-entropy convention interface.
- `LeanInfoTheory.EntropyVal`: abstract Shannon entropy valuations for
  certificate work.
- `LeanInfoTheory.PrimitiveIneq`: primitive Shannon inequality expressions and
  their soundness theorems under abstract Shannon entropy valuations.
- `LeanInfoTheory.Certificate`: soundness skeleton for nonnegative certificate
  combinations, including exact rational expression matching for
  decompositions.
- `LeanInfoTheory.Certificate.Checked`: raw certificate data, a first
  raw-to-checked validator, and proof-carrying checked certificate structures
  for primitive Shannon-inequality ingredients, using nonnegative rational
  coefficients and exact decomposition equality.
- `LeanInfoTheory.Certificate.Submodularity`: separately importable first
  non-toy certificate demo, proving entropy submodularity from a validated CMI
  certificate.
- `LeanInfoTheory.Certificate.Subadditivity`: separately importable checked
  certificate demo, proving entropy subadditivity from a two-step certificate.
- `LeanInfoTheory.Certificate.Monotonicity`: separately importable checked
  certificate demo, proving one-variable entropy monotonicity from a
  conditional-entropy primitive.
- `LeanInfoTheory.Certificate.ThreeWaySubadditivity`: separately importable
  manual certificate pressure-test module, proving three-way entropy
  subadditivity from a four-step primitive certificate.
- `LeanInfoTheory.Examples.SupportSensitive`: opt-in examples showing the
  sharper support-cardinality bound, null versus positive conditional fibers,
  support-wise functional dependence and injectivity, and side-information
  recovery.
- `LeanInfoTheory.Examples.KLTop`: opt-in disjoint-support example showing why
  real-valued KL zero theorems require a finiteness or support-inclusion guard.
- `LeanInfoTheory.Examples.CommonCause`: opt-in noisy binary common-cause model
  exercising conditional independence, zero conditional mutual information,
  and canonical and existential Markov channel factorization.
- `LeanInfoTheory.Examples.StochasticChannels`: opt-in reset-channel examples
  exercising strict entropy growth, invariant-reference KL contraction, and
  source-versus-intermediate support conditions for channel cascades.
- `LeanInfoTheory.Examples.SufficientStatistics`: opt-in finite experiments
  exercising fixed-prior and family sufficiency, exact recovery, all-prior and
  Fisher-Neyman characterizations, KL preservation, and recovery failure modes.
- `LeanInfoTheory.Examples`: aggregate for the semantic examples above and the
  original toy certificate examples.

## Import and Namespace Policy

Import `LeanInfoTheory` for the lightweight stable API: finite Shannon
definitions, the finite information-measure re-export, and the core
certificate/checker definitions.

The canonical implementation namespace for finite information measures is
`LeanInfoTheory.Shannon`. In theorem statements, docs, and proof-oriented code,
prefer names such as `Shannon.entropy` and `Shannon.mutualInfo` when that makes
the source layer clear. The `LeanInfoTheory.InformationMeasures` module exports
the main finite-measure names into `LeanInfoTheory` as convenience aliases.

Import heavier or demonstrational modules explicitly:

- `LeanInfoTheory.Shannon.EntropyBounds` for Jensen-based entropy bounds.
- `LeanInfoTheory.Shannon.Units` for logarithm-base conversion.
- `LeanInfoTheory.Shannon.SemanticBridge` for self-information,
  conditional-law, KL, averaged conditional-KL, nonnegativity, and chain-rule
  bridge theorems.
- `LeanInfoTheory.MathlibFragments` for heavy mathlib/coding anchors.
- `LeanInfoTheory.Certificate.Submodularity`,
  `LeanInfoTheory.Certificate.Subadditivity`,
  `LeanInfoTheory.Certificate.Monotonicity`,
  `LeanInfoTheory.Certificate.ThreeWaySubadditivity`, and
  `LeanInfoTheory.Examples` for demos and examples. The five semantic example
  modules may also be imported individually.

## Roadmap

1. Plan the focused finite Fano phase from Future Work Note 29 on top of the
   completed sufficient-statistics, exact-recovery, and guarded KL-equality
   layer, without folding in a full coding theorem.
2. Keep the sufficiency core lightweight and place KL integration downstream;
   retain exact full-joint recovery as the contract established by the
   completed midpoint tests, including rejection of marginal-only false
   positives and unguarded null-fiber posterior equality.
3. Return to Project A by extending the checked-certificate path and certifying
   recognizable information-theoretic converse steps on top of that foundation.
4. Add richer certificate assumptions such as independence, Markov, and
   functional-dependence constraints when concrete examples require them.
5. Prepare small mathlib PRs and richer theorem/blueprint documentation once
   the relevant APIs have stabilized locally.

## Build

```powershell
lake exe cache get
lake build
lake build LeanInfoTheory.Shannon.EntropyBounds
lake build LeanInfoTheory.Shannon.Units
lake build LeanInfoTheory.Shannon.SemanticBridge
lake build LeanInfoTheory.MathlibFragments
lake build LeanInfoTheory.Certificate.Submodularity
lake build LeanInfoTheory.Certificate.Subadditivity
lake build LeanInfoTheory.Certificate.Monotonicity
lake build LeanInfoTheory.Certificate.ThreeWaySubadditivity
lake build LeanInfoTheory.Examples
```

The first `lake build` checks the lightweight root import. The explicit module
builds check heavier or demonstrational files that are intentionally kept out
of the root import. The Lean CI workflow also fails if Lean source files
contain `sorry`, `admit`, `opaque`, `undefined`, or an unapproved `axiom`.

Regenerate website reference artifacts after changing Lean imports or public
declarations:

```powershell
python scripts\generate_website_blueprint.py
python scripts\generate_website_api_index.py
python scripts\check_website.py
```

CI checks that the generated website artifacts are up to date and that local
website links plus generated JSON files are valid.

The public project website can be opened locally from:

```text
home_page/index.html
```

## Website Deployment

The repository includes `.github/workflows/pages.yml`, which deploys the
contents of `home_page/` to GitHub Pages.

After pushing to GitHub:

1. Open the repository settings on GitHub.
2. Go to **Pages**.
3. Set **Source** to **GitHub Actions**.
4. Push to `master` or `main`, or run the **Deploy website** workflow manually.

For a repository named `LeanInfoTheory` under `serhatemrecoban`, the deployed
site should appear at:

```text
https://serhatemrecoban.github.io/LeanInfoTheory/
```
