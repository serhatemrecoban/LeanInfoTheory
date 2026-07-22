# Current Lean State

Last milestone checkpoint: July 16, 2026. Project B Chunk 1 was committed as
`7ab3aa0`, and Project B Chunk 2 was checkpointed as `e5e9825` after passing its full
milestone build/check suite. All 18 Chunk 2 steps are finished. The chunk began
from the clean Chunk 1 checkpoint, its new theorem contracts were validated by
temporary
no-placeholder Lean proofs, and the finite KL support, equality, and
uniform-reference APIs, sharp finite entropy equality cases, and ordinary
independence predicates, mathlib `IndepFun` bridge, and zero-MI
and pair-entropy equality characterizations are public. Zero averaged
conditional mutual information is now equivalent to zero mutual information
on every positive-mass conditional fiber. The proof-independent
`IsCondIndependent` and `IsCondIndependentOf` predicates are public, and the
PMF predicate is equivalent to ordinary independence on every positive-mass
conditional joint law. Zero conditional mutual information is now equivalent
to conditional independence at both PMF and random-variable levels, and the
corresponding conditioning-equality and conditional-additivity cases are
public. The opt-in `Examples.SupportSensitive` and `Examples.KLTop` modules now
exercise the support-aware theorem contracts and the non-absolutely-continuous
real-KL zero trap without changing the lightweight root.
The scheduled API review retained every existing declaration and added only
four short additive-entropy aliases. Simp policy, module ownership, and import
boundaries remain unchanged; the proposed fiber, uniform-law, general KL, and
MI relabeling APIs remain deferred for concrete theorem pressure. The final
integration pass rebuilt all ten milestone targets, regenerated both public
reference sets, passed the website and repository hygiene checks, and left the
lightweight root unchanged.

Project B Chunk 3 is complete. All 20 steps of its revised plan are finished.
Step 1 fixed the raw PMF-valued channel representation, total
conditional-channel convention, Markov orientations, and MI proof route through
a temporary no-placeholder spike. Step 2 added the separately importable
`Probability.FiniteChannel` module with deterministic channels, channel
composition, induced joint laws, and pair-to-triple channel extension. Step 3
proved their type-generic atom, projection, algebra, deterministic-map, and
support laws. Step 4 created the separately importable
`SemanticBridge.Markov` module and defined its total conditional channel. The
Step 5 theorem layer now proves positive and null branch reduction, arbitrary-
fallback irrelevance on null fibers after weighting, all-fiber atom
reconstruction, and reconstruction of the swapped pair law. Step 6 added the
assumption-free `IsMarkovChain` and `IsMarkovChainOf` predicates together with
PMF and random-variable symmetry of conditional independence in its first two
variables. Step 7 characterized these predicates through the atomwise Markov
cross-product law, independence of the endpoints on every positive middle
fiber, zero `I(X;Z|Y)`, and reversal of the chain. Step 8 proved that
`PMF.channelExtension p V` is Markov for every pair law `p` and channel `V`
depending on its second coordinate. The lightweight root remains unchanged;
Step 9 added PMF and random-variable forms of the exact loss identity
`I(X;Y) = I(X;Z) + I(X;Y|Z)`. Step 10 derived mutual-information data
processing, the conditional-entropy inequality `H(X|Y) <= H(X|Z)`, and
  equality exactly under the reverse Markov condition `X -> Z -> Y`. Step 11
  specialized this DPI to stochastic processing of either coordinate,
  independently processing both coordinates, two-stage channel cascades, and
  deterministic output maps. Step 12 completed the Markov/channel converse:
  every finite Markov triple is reconstructed by the canonical total
  middle-to-third conditional channel and, equivalently, is an extension of its
  first-two marginal through some channel. Step 13 completed the second
  no-placeholder feasibility checkpoint and selected the kernel-chain-rule
  route for finite KL contraction. It validated the PMF-to-kernel and posterior
  reconstruction bridges, finite KL invariance under equivalence, exact
  posterior decomposition, unconditional `ENNReal` contraction, and the real
  corollary under input support inclusion. No production declaration or root
  import was added. Step 14 introduced the opt-in
  `SemanticBridge.DataProcessing` module. Its `pmfChannelKernel` definition and
  Markov-kernel instance give the measure-theoretic view of a raw PMF channel,
  while `channelJoint_toMeasure` identifies the induced joint PMF measure with
  mathlib's `compProd`. The semantic aggregate imports the new module; the
  lightweight root remains unchanged. Step 15 added the total
  `channelPosterior`, its assumption-light PMF reconstruction theorem, and the
  exact `ENNReal` identity `klDiv_channel_eq_add_posterior`. The coordinate-
  swap KL invariance and measurable posterior `compProd` bridge remain private.
  Step 16 added the private `[Finite]` contraction engine by discarding that
  identity's nonnegative posterior remainder. Step 17 now publishes the
  unconditional `ENNReal` channel inequality, its input-support-guarded real
  form, and deterministic-map and channel-cascade specializations. The cascade
  surface keeps the original source alphabet type-generic. Step 18 derives
  contraction toward an invariant reference law and assumption-light entropy
  growth under uniform-preserving and finite doubly stochastic channels. Step
  19 adds separately importable noisy common-cause and stochastic-channel
  examples, approves five compatibility aliases after the scheduled review,
  confirms the existing simp and module boundaries, and inlines the unused
  private KL contraction wrapper into the unchanged public theorem. Step 20
  integrated the milestone, regenerated the source-derived references, passed
  the complete build, website, consumer, root-isolation, and hygiene suites, and
  left the lightweight root unchanged.

The revised 20-step Project B Chunk 4 plan governed by Future Work Note 29 is
complete. It develops finite sufficient statistics, exact recovery, and guarded
equality in KL data processing.
`isMarkovChainOf_comp` supplies the type-generic deterministic forward chain,
and `condEntropyOf_dataProcessing_eq_iff` gives the entropy-facing equality
characterization, with `condEntropy_dataProcessing_eq_iff` now supplying the
direct PMF form. The new opt-in `SemanticBridge.Sufficiency` core now owns the
fixed-prior predicate, induced triple law, and reverse-Markov/zero-CMI/MI/
conditional-entropy equivalence band, together with exact full-joint recovery
and its one-way marginal consequence. It now also defines family sufficiency
through one common exact recovery channel and deterministic statistics as its
specialization. Family sufficiency is now equivalent to agreement with one
common posterior on every supported output fiber; null fibers remain
unconstrained. The identity statistic is sufficient for every model family,
and common family recovery now yields reverse Markov, zero-CMI, MI-preservation,
and conditional-entropy-preservation consequences under every parameter prior.
One full-support prior now supplies the converse with only a finite model-input
alphabet, while finite nonempty parameter alphabets give channel and
deterministic-statistic characterizations quantified over every prior. The
permanent opt-in `Examples.SufficientStatistics` module validates the genuinely
noninjective sufficient, non-sufficient constant, and marginal-only cases and
exercises the fixed-prior, family, recovery, all-prior, Fisher-Neyman, and KL-
equality surfaces. The finite Fisher-Neyman iff now characterizes
deterministic family sufficiency by finite `ENNReal` factors through the
statistic, with all fiber normalization private. The downstream
`DataProcessing` owner now retains
`klDiv_channel_eq_iff_posterior_ae_eq` as the lower-level measure bridge and
supplies `klDiv_channel_eq_iff_posterior_eq_on_support` plus its guarded real
companion as the primary finite-facing equality family. The new downstream
`SemanticBridge.Sufficiency.KL` module now proves pairwise `ENNReal` KL
preservation from one channel that exactly recovers both complete output-input
joint laws. Under input support inclusion it now also characterizes `ENNReal`
and real KL equality by existence of one common exact recovery channel, with
deterministic-map forms. Sufficient family channels and deterministic
statistics now preserve `ENNReal` KL divergence between every pair of model
laws. Under directed support inclusion, either family predicate is equivalent
to that equality for a Boolean-indexed two-law model. The lightweight
sufficiency core and root remain unchanged. The complete ten-target build,
guarded consumer, axiom, generated-reference, website, and hygiene suites pass.
Fano is the next separately planned Project B phase, while
canonical/minimal sufficiency and larger iid examples are deferred by Future
Work Note 39.

This is a maintained status note for Lean-focused work. It summarizes the
current architecture and the completed Chunk 3 and Chunk 4 theorem milestones.

## Current Lean Architecture

- `LeanInfoTheory.lean` is the lightweight root import. It imports the stable
  finite information-measure API and the core certificate/checker definitions,
  but not heavier theorem, semantic bridge, demo, coding, or reference modules.
- `LeanInfoTheory.Basic` holds lightweight namespace/status vocabulary.
- `LeanInfoTheory.Probability.Finite` contains reusable finite `PMF` helper
  lemmas, including real-mass facts, the canonical finite `PMF.supportFinset`
  view, pointwise `PMF.map` formulas, and the singleton-support characterization
  `PMF.eq_pure_iff_support_eq_singleton`.
- `LeanInfoTheory.Probability.FiniteChannel` is a separately importable,
  type-generic PMF channel construction layer. Channels remain raw functions
  `alpha -> PMF beta`; the module names deterministic channels, channel
  composition, induced input-output joint laws, and pair-to-triple extension,
  together with their pointwise, projection, algebra, deterministic, and
  support laws.
- `LeanInfoTheory.Shannon.Entropy` defines finite Shannon entropy in nats using
  mathlib `PMF`s and `Real.negMulLog`.
- `LeanInfoTheory.Shannon.InfoMeasures` defines finite marginal laws,
  conditional entropy, mutual information, conditional mutual information, and
  random-variable versions via `PMF.map`.
- `LeanInfoTheory.Shannon.Units` is a separately importable logarithm-base
  conversion layer. It leaves the canonical definitions in nats and supplies
  division-by-`Real.log`/`Real.logb` bridge theorems.
- `LeanInfoTheory.Shannon.EntropyBounds` is separately importable and contains
  the Jensen-based alphabet- and support-cardinality entropy bounds and their
  exact uniform-law equality characterizations.
- `LeanInfoTheory.Shannon.SemanticBridge` and its subfiles are the heavier
  bridge layer connecting the finite Shannon API to `PMF.toMeasure`, product
  measures, conditional laws, and `InformationTheory.klDiv`, including finite
  PMF support characterizations of absolute continuity, finiteness, and the
  KL zero-equality case, support-aware uniform-reference identities, and the
  separately importable independence module, including its conditional-
  independence definitions and positive-fiber characterization.
- `LeanInfoTheory.Shannon.SemanticBridge.Markov` is the new opt-in
  channel-facing semantic module. It defines `IsMarkovChain` and
  `IsMarkovChainOf` using conditional independence and also defines
  `condFstGivenSndChannel`, which agrees by construction with
  `condFstGivenSnd` on positive fibers and uses `fstMarginal p` on null fibers,
  and proves its branch, weighted atom, and pair-law reconstruction properties.
  The same module characterizes Markov structure by cross-product
  factorization, positive conditional fibers, zero CMI, and chain reversal,
  proves that `PMF.channelExtension` generates Markov triples, and exposes the
  exact Markov mutual-information loss identity, data-processing inequality,
  conditional-entropy consequence, and reverse-Markov equality case at PMF
  and random-variable levels. Its channel-facing consequences cover left,
  right, independently two-sided, cascade, and deterministic output
  processing without adding another channel construction.
- `LeanInfoTheory.Shannon.SemanticBridge.Sufficiency` is the lightweight opt-in
  sufficient-statistics core. It imports `Markov` but not `DataProcessing`,
  defines `IsSufficientStatisticOf` by the reverse chain
  `Theta -> T(X) -> X`, and records the induced complete law as
  `statisticTripleLawOf p Theta X T`. Its first theorem band characterizes the
  predicate by reverse Markov structure, zero CMI, mutual-information
  preservation, conditional-entropy preservation, and exact reconstruction of
  the complete induced law by one recovery channel. Observation-marginal
  recovery is exposed only as a one-way consequence. It is imported by the
  semantic aggregate but remains outside the lightweight root. The same module
  defines `IsSufficientChannel` for raw model families by one common exact
  recovery channel and `IsSufficientStatistic` as the deterministic-channel
  specialization, without introducing a bundled experiment structure. It also
  proves the assumption-free identity-statistic sanity law and derives reverse
  Markov structure plus zero-CMI, MI, and conditional-entropy preservation for
  every parameter prior. The hierarchical prior/model/channel law remains
  inline rather than becoming another public constructor.
- `LeanInfoTheory.Shannon.SemanticBridge.DataProcessing` is the new opt-in
  kernel/KL-facing module. It currently converts countable PMF-valued channels
  to mathlib Markov kernels and proves that `PMF.channelJoint` has the expected
  measure-kernel `compProd` semantics. It also constructs the total finite
  posterior, reconstructs the induced joint PMF in output-input order, and
  characterizes family sufficiency by one common posterior on supported output
  fibers before proving the exact channel KL posterior decomposition. It now
  imports the lightweight sufficiency core directly, is imported by the
  semantic aggregate, and remains outside the lightweight root.
- `LeanInfoTheory.Shannon.SemanticBridge.Sufficiency.KL` is the downstream
  exact-recovery/KL integration module. It imports `DataProcessing`, leaves the
  lightweight sufficiency core free of kernel and KL imports, and proves
  pairwise `ENNReal` KL preservation under one common exact recovery channel,
  together with support-guarded `ENNReal`/real converses and deterministic-map
  specializations.
- `LeanInfoTheory.EntropyExpr`, `LeanInfoTheory.EntropyVal`, and
  `LeanInfoTheory.PrimitiveIneq` form the abstract entropy-expression and
  primitive Shannon inequality layer.
- `LeanInfoTheory.Certificate` and `LeanInfoTheory.Certificate.Checked` contain
  the checked certificate skeleton and raw-to-checked validation path.
- `LeanInfoTheory.Certificate.Submodularity`,
  `LeanInfoTheory.Certificate.Subadditivity`,
  `LeanInfoTheory.Certificate.Monotonicity`,
  `LeanInfoTheory.Certificate.ThreeWaySubadditivity`, and
  `LeanInfoTheory.Examples` are separately importable demonstration and
  pressure-test modules. `LeanInfoTheory.Examples.SupportSensitive` and
  `LeanInfoTheory.Examples.KLTop`, together with the new
  `LeanInfoTheory.Examples.CommonCause` and
  `LeanInfoTheory.Examples.StochasticChannels` and
  `LeanInfoTheory.Examples.SufficientStatistics`, can also be imported directly
  when only one semantic example is wanted.
- `LeanInfoTheory.MathlibFragments` is a separately importable anchor/checklist
  for mathlib APIs that the project expects to use later.

## Finite Shannon Layer Status

The finite Shannon layer is PMF-based and uses real-valued entropy in nats.

Implemented and building:

- finite entropy `Shannon.entropy`;
- entropy as a finite sum of `Real.negMulLog` terms;
- entropy nonnegativity;
- deterministic-law entropy `H(delta_a) = 0`;
- zero entropy characterized by purity through
  `Shannon.entropy_eq_zero_iff`;
- random-variable zero entropy characterized by constancy on the source PMF
  support through `Shannon.entropyOf_eq_zero_iff`;
- entropy of random variables via pushforward laws;
- joint entropy as entropy of a joint `PMF`;
- invariance under equivalences, injective relabelings, coordinate swaps, and
  product reassociation;
- marginal laws for pairs and triples, including first-second, first-third,
  second-third, and third-coordinate projections, with pointwise mass formulas
  and domination/zero-mass helper lemmas;
- finite conditional entropy, mutual information, and conditional mutual
  information as entropy identities;
- pair conditional-entropy decompositions and the triple random-variable chain
  rules `H(X,Y|Z) = H(Y|Z) + H(X|Y,Z)` and
  `H(X,Y|Z) = H(X|Z) + H(Y|X,Z)`, together with swap invariance for the
  conditioned pair;
- mutual information symmetry and conditional mutual information symmetry
  under coordinate swaps, plus random-variable symmetry theorems
  `I(Y;X) = I(X;Y)` and `I(Y;X|Z) = I(X;Y|Z)`;
- the equivalent mutual-information identities
  `I(X;Y) = H(X) - H(X|Y)` and `I(X;Y) = H(Y) - H(Y|X)`, at both PMF and
  random-variable levels, together with `I(X;X) = H(X)`;
- the random-variable conditional-mutual-information identities
  `I(X;Y|Z) = H(X|Z) - H(X|Y,Z)`, its symmetric form in `Y`, and
  `I(X;Y|Z) = H(X|Z) + H(Y|Z) - H(X,Y|Z)`;
- opt-in change of logarithm base through `Shannon.div_log_change_base`,
  `Shannon.negMulLog_div_log`, `Shannon.entropy_div_log`, and
  `Shannon.entropyOf_div_log`;
- Jensen-based bound `H(P) <= log |alpha|` for nonempty finite alphabets;
- support-sensitive bounds `H(P) <= log |support P|` and
  `H(X) <= log |support (law X)|` through
  `Shannon.entropy_le_log_support_ncard` and
  `Shannon.entropyOf_le_log_support_ncard`;
- alphabet-cardinality equality exactly for `PMF.uniformOfFintype`, and
  support-cardinality equality exactly for uniformity on the PMF support, at
  both PMF and random-variable levels.

The layer intentionally does not introduce a project-local probability type.
It should continue to reuse mathlib `PMF`, `PMF.map`, `PMF.bind`,
`PMF.toMeasure`, `Real.negMulLog`, and measure-theoretic information theory
where possible.

## Semantic Bridge Status

The semantic bridge is separated from the lightweight finite Shannon files so
that KL divergence, measure products, kernels, and conditional probability
imports do not become root-import dependencies.

Implemented and building:

- `Shannon.selfInfo p a`, with zero-mass convention;
- finite entropy as expected self-information over `PMF.toMeasure`;
- independent product PMF `indepProd`, including support, marginal, and
  product-measure bridge lemmas;
- PMF independence `Shannon.IsIndependent` and random-variable independence
  `Shannon.IsIndependentOf`, with pointwise marginal factorization,
  independent-product construction, symmetry theorems, and the explicit
  `Shannon.isIndependentOf_iff_indepFun` measure-theoretic bridge;
- zero mutual information characterized by ordinary independence through
  `Shannon.mutualInfo_eq_zero_iff_isIndependent` and
  `Shannon.mutualInfoOf_eq_zero_iff_isIndependentOf`;
- conditioning preserves entropy and joint entropy is additive exactly under
  ordinary independence, at both PMF and random-variable levels;
- `Shannon.condMutualInfo_eq_zero_iff_condMutualInfoFstSndGivenThird_eq_zero`,
  which extracts zero mutual information on every positive-mass conditional
  fiber from zero averaged conditional mutual information and proves the
  converse;
- conditional independence predicates `Shannon.IsCondIndependent` and
  `Shannon.IsCondIndependentOf`, with the former defined by atomwise
  cross-product factorization and characterized by
  `Shannon.isCondIndependent_iff_isIndependent_condFstSndGivenThird` as
  independence of every positive-mass conditional joint law;
- zero conditional mutual information characterized by conditional
  independence through `Shannon.condMutualInfo_eq_zero_iff_isCondIndependent`
  and `Shannon.condMutualInfoOf_eq_zero_iff_isCondIndependentOf`;
- conditioning preserves conditional entropy exactly under conditional
  independence through
  `Shannon.condEntropy_eq_condEntropy_fstThirdMarginal_iff_isCondIndependent`
  and `Shannon.condEntropyOf_eq_condEntropyOf_iff_isCondIndependentOf`;
- conditional joint entropy is additive exactly under conditional independence
  through `Shannon.condEntropy_pair_eq_add_condEntropy_iff_isCondIndependent`
  and
  `Shannon.condEntropyOf_pair_eq_add_condEntropyOf_iff_isCondIndependentOf`;
- Markov predicates `Shannon.IsMarkovChain` and `Shannon.IsMarkovChainOf`, with
  atomwise cross-product, positive conditional-fiber, zero-CMI, and reversal
  characterizations in `Shannon.SemanticBridge.Markov`, plus
  `Shannon.isMarkovChain_channelExtension` for channel-generated triples and
  `Shannon.mutualInfo_markov_chain_rule`/
  `Shannon.mutualInfoOf_markov_chain_rule` for exact information loss;
- `Shannon.pmfChannelKernel` and its Markov-kernel instance, together with
  `Shannon.channelJoint_toMeasure` identifying the induced PMF joint law with
  mathlib's measure-kernel composition product;
- `Shannon.channelPosterior` and
  `Shannon.channelPosterior_reconstructs_joint`, together with the exact
  `Shannon.klDiv_channel_eq_add_posterior` identity;
- absolute-continuity helpers from a joint finite law to the product of its
  marginals;
- finite log-ratio formulas for mutual information;
- mutual information as KL divergence from the joint law to the independent
  product law and to the product of marginal measures;
- finite conditional laws `P_{A | B=b}` for nonzero-marginal fibers, with
  factorization lemmas;
- zero entropy on a positive conditional fiber characterized by purity of its
  canonical conditional PMF through
  `Shannon.condEntropyFstGivenSnd_eq_zero_iff_of_sndMarginal_ne_zero`;
- global zero conditional entropy characterized by support-wise functional
  dependence through `Shannon.condEntropy_eq_zero_iff_exists_function` and
  `Shannon.condEntropyOf_eq_zero_iff_exists_function`;
- deterministic and self-conditioning consequences
  `Shannon.condEntropyOf_comp_eq_zero` and
  `Shannon.condEntropyOf_self_eq_zero`, together with PMF and random-variable
  joint-entropy equality characterizations;
- conditional entropy as `sum_b P_B(b) H(P_{A | B=b})`;
- PMF-facing triple conditional-entropy chain rules for `pairThirdLaw`, in both
  variable orders;
- deterministic entropy processing for PMFs and random variables, with equality
  characterized by injectivity on the relevant law support;
- the conditional deterministic chain rule
  `H(X|Z) = H(f(X)|Z) + H(X|f(X),Z)`, its entropy-processing inequality, and
  equality characterized by support-wise recovery of `X` from `(f(X), Z)`,
  together with PMF-facing first-coordinate forms;
- conditional mutual information as averaged fiber mutual information;
- conditional mutual information as averaged fiber KL divergence;
- semantic nonnegativity of conditional entropy, mutual information, and
  conditional mutual information;
- random-variable conditional-mutual-information nonnegativity through
  `Shannon.condMutualInfoOf_nonneg`;
- pair-level inequalities `H(A|B) <= H(A)`,
  `I(A;B) <= H(A), H(B)`, and
  `H(A), H(B) <= H(A,B) <= H(A) + H(B)`, together with random-variable forms;
- mutual-information chain rules:
  `I(A; B, C) = I(A; C) + I(A; B | C)` and
  `I(A; B, C) = I(A; B) + I(A; C | B)`, plus random-variable forms;
- deterministic mutual-information processing, including
  `I(X;Y) = I(f(X);Y) + I(X;Y|f(X))`, one-sided and two-sided random-variable
  inequalities, and PMF coordinate-map corollaries;
- stochastic channel-facing mutual-information processing on either coordinate,
  independent channels on both coordinates, channel cascades, and
  deterministic maps of a channel output;
- both PMF conditional-entropy difference forms for conditional mutual
  information;
- triple-level conditional inequalities in PMF and random-variable forms:
  `I(X;Y|Z) <= H(X|Z), H(Y|Z)` and
  `H(X|Z), H(Y|Z) <= H(X,Y|Z) <= H(X|Z) + H(Y|Z)`;
- conditioning-reduces-entropy:
  `H(A | B, C) <= H(A | C)`, plus the random-variable form.

The semantic bridge API remains separately importable. The Chunk 1 API review
added compatibility-preserving left/right/both aliases for the pair bounds,
deterministic processing, and conditional inequality band while retaining all
descriptive marginal/coordinate names. More speculative MI/CMI-difference,
fiber, reverse-identity, and relabeling aliases remain deferred pending real
proof pressure.

## Certificate Layer Status

The certificate layer is abstract: it works over entropy atoms, rational
linear combinations of entropy atoms, and abstract Shannon entropy valuations.

Implemented and building:

- entropy atoms as finite sets of variables;
- sparse rational entropy expressions;
- explicit empty-entropy convention;
- abstract `ShannonEntropyVal`, packaging `H(empty) = 0`, conditional entropy
  nonnegativity, and conditional mutual information nonnegativity;
- primitive Shannon inequality expressions for empty entropy, conditional
  entropy, and conditional mutual information;
- soundness theorems for primitive inequalities under a
  `ShannonEntropyVal`;
- checked certificate structures with nonnegative rational coefficients;
- raw certificate data and a raw-to-checked validator;
- exact decomposition matching over normalized rational entropy expressions;
- soundness theorem: if raw data validates to a checked certificate, then the
  target entropy expression is nonnegative under every `ShannonEntropyVal`;
- ergonomic raw-validator soundness theorem
  `Certificate.RawCert.sound_of_toCheckedCert?_isSome`, for demos that prove
  only that validation succeeds;
- checked certificate demos for entropy submodularity, entropy
  subadditivity, one-variable entropy monotonicity, and three-way entropy
  subadditivity.

The current project has the checking/validation side, not automatic
certificate generation. Future PSITIP/oXitip-style integration should remain
untrusted: external tools can search for certificates and emit raw data, while
Lean validation remains the trusted step.

## Certificate Demo Status

`LeanInfoTheory.Certificate.Submodularity` is the first non-toy checked
certificate demo.

It proves the abstract entropy submodularity inequality

```text
0 <= H(A) + H(B) - H(A union B) - H(A inter B)
```

for every `ShannonEntropyVal`, by validating a one-step certificate whose
primitive ingredient is

```text
I(A \ B ; B \ A | A inter B) >= 0.
```

The demo includes:

- the target entropy expression;
- the corresponding primitive conditional-mutual-information expression;
- set identities showing the expressions match;
- checked and raw certificate data;
- a theorem that the raw certificate validates;
- a final soundness theorem derived through the generic checker.

This is a real checked-certificate path, but it is still a small example. It
does not yet include independence, Markov, or functional-dependence
assumptions.

Two additional small checked-certificate demos now exercise the validator on
more primitive combinations:

- `LeanInfoTheory.Certificate.Subadditivity` proves
  `0 <= H(A) + H(B) - H(A union B)` by validating the two-step certificate
  `I(A;B | empty) + H(empty)`.
- `LeanInfoTheory.Certificate.Monotonicity` proves
  `0 <= H(insert i S) - H(S)` under `i notin S` by validating a
  conditional-entropy primitive certificate.

## Website Status

Website source lives under `home_page/`. The current website includes a
homepage dashboard, theorem highlights, submodularity demo, module guide,
development page, prior-art page, roadmap, generated module-level dependency
map, and generated declaration index.

The declaration index is source-derived and is not full Lean doc-gen. The
dependency map is module-level and is not theorem-level leanblueprint. Keep
website wording honest about what is proved, demoed, generated, planned, and
future work.

## Important Design Constraints

- Do not use `sorry`, `admit`, `axiom`, `opaque`, or `undefined` in Lean
  source.
- Keep root imports lightweight.
- Keep semantic bridge, entropy bounds, demos, and reference modules separately
  importable where appropriate.
- Prefer mathlib definitions and APIs over local replacements.
- Do not redefine probability theory locally.
- Do not change Lean theorem statements during website-only tasks.
- Keep certificate generation and certificate validation conceptually
  separated.
- Keep future external certificate importers untrusted; Lean validation is the
  trusted step.
- When upgrading mathlib, re-run the semantic bridge API audit and check
  whether mathlib has added canonical finite PMF product, finite KL expansion,
  or averaged conditional-KL APIs.

## Chunk 3 Milestone Close

1. All 20 Chunk 3 steps are complete and integrated.
2. The root import remains unchanged. Entropy bounds, semantic theorems, units,
   demos, and reference anchors remain separately importable where appropriate.
3. Sufficient statistics and KL recovery equality are complete under Future
   Work Note 29. Fano is the next separately planned Project B phase. Channel
   processes, binary/q-ary bridges, canonical/minimal sufficiency, and finite-
   family entropy remain later work.
4. Continue using focused Lake builds during theorem development and the full
   suite at every milestone boundary.

## Completed Project B Chunk 4 Plan

Current status: all 20 steps are complete. The lightweight sufficiency core
contains the fixed-prior predicate, induced triple
law, its first textbook equivalence band, and exact full-joint recovery,
together with the family channel predicate and deterministic specialization,
plus every-prior reverse-Markov and information-preservation consequences and
their full-support/all-prior converses. It remains upstream of the supported
posterior characterization and guarded measure-level equality engine in data
processing. The downstream `Sufficiency.KL` layer now contains the forward
pairwise exact-recovery theorem and its support-guarded `ENNReal`/real
converses, including deterministic-map forms, family pairwise preservation,
and the guarded Boolean-family converse. Permanent examples now exercise the
  completed surface without changing the root.

1. Completed on July 16, 2026: validated every contract with clean temporary
   no-placeholder proofs, including the marginal-recovery false-positive test.
2. Completed on July 17, 2026: proved deterministic forward Markov structure
   for arbitrary statistics as `isMarkovChainOf_comp`.
3. Completed on July 17, 2026: added the directly consumed conditional-entropy
   DPI equality case `condEntropyOf_dataProcessing_eq_iff` from Future Work
   Note 33.
4. Completed on July 17, 2026: introduced the lightweight opt-in sufficiency
   core, upstream of the DataProcessing and planned Sufficiency.KL layers, with
   positive and negative root-isolation checks.
5. Completed on July 17, 2026: proved the fixed-prior reverse-Markov, zero-CMI,
   MI-preservation, and conditional-entropy-preservation equivalences.
6. Completed on July 17, 2026: characterized fixed-prior sufficiency by exact
   full-joint recovery and derived marginal recovery only as a one-way
   consequence.
7. Completed on July 17, 2026: defined family sufficient channels through one
   common exact recovery channel and deterministic sufficient statistics as
   their specialization.
8. Completed on July 17, 2026: characterized family sufficiency by one common
   posterior on every supported output fiber and added the identity-statistic
   sanity law.
9. Completed on July 17, 2026: derived reverse Markov, zero-CMI, MI-preservation,
   and conditional-entropy-preservation consequences for every parameter prior
   from one common family recovery channel, and added the directly consumed
   PMF conditional-entropy equality characterization from Note 33.
10. Completed on July 17, 2026: proved the finite full-support-prior converse,
    the all-priors channel and deterministic-statistic equivalences, and the
    pressure-justified deterministic channel-extension graph law.
11. Completed on July 17, 2026: ran the midpoint contract, example, module,
    naming, null-fiber, and root-isolation test with temporary public consumers.
12. Completed on July 17, 2026: proved the finite Fisher-Neyman factorization
    iff with finite `ENNReal` factors and private fiber normalization.
13. Completed on July 17, 2026: derived the guarded measure-level KL posterior-
    equality engine from the exact decomposition and mathlib's finite kernel
    composition-product equality theorem.
14. Completed on July 17, 2026: published the finite support-pointwise
    posterior equality theorem and its guarded real-valued companion.
15. Completed on July 17, 2026: added the downstream, separately importable
    `Shannon.SemanticBridge.Sufficiency.KL` module and proved unconditional
    pairwise `ENNReal` KL preservation from one common exact recovery channel.
16. Completed on July 21, 2026: proved guarded `ENNReal` and real KL equality
    iff common exact recovery, together with deterministic-map variants, and
    promoted the required channel-joint support-identifiability theorem.
17. Completed on July 22, 2026: integrated family sufficiency with pairwise
    `ENNReal` KL preservation and its support-guarded Boolean-family converse,
    including deterministic-statistic forms.
18. Completed on July 22, 2026: added permanent, separately importable
    sufficient-statistics examples covering the positive noninjective model,
    the negative constant statistic, the marginal-only false positive, and the
    fixed-prior, family, recovery, all-prior, Fisher-Neyman, and KL surfaces.
19. Completed on July 22, 2026: retained the current naming, simp, and module
    surfaces after the scheduled review, completed the source documentation
    checklist, and rechecked downstream imports and negative root reachability.
20. Completed on July 22, 2026: updated documentation and references, passed
    the full ten-target milestone suite plus guarded consumers, axiom, website,
    root-isolation, and hygiene checks, and prepared the checkpoint commit.

The detailed contracts, gates, and deferred boundaries are recorded in the
completed Chunk 4 section of `docs/project-log.md`.

### Locked Step 1 Contract

- Fixed-prior sufficiency is the reverse chain `Theta -> T(X) -> X`;
  `Theta -> X -> T(X)` is automatic and type-generic.
- Family sufficiency requires one channel that reconstructs every complete
  swapped input-output joint law. Recovering only each input marginal is
  formally too weak.
- One full-support prior suffices for the family converse. Once that prior is
  supplied, the compiled argument needs only `[Finite alpha]` for the recovered
  observation alphabet; a canonical uniform prior later adds finite nonempty
  parameter assumptions.
- Guarded KL equality cancels the exact posterior decomposition and uses
  `Kernel.compProd_eq_iff` to obtain almost-everywhere posterior-kernel
  equality. The engine remains owned by `SemanticBridge.DataProcessing`.
- Fisher-Neyman uses finite `ENNReal` factors and a private positive-fiber
  normalization argument; zero-total fibers use an observationally irrelevant
  fallback.
- The temporary 2747-job target built cleanly, then its source and generated
  artifacts were deleted. The root and production module graph are unchanged.

### Completed Chunk 4 Step 2

- `isMarkovChainOf_comp` proves `X -> Y -> f(Y)` for arbitrary source and
  variable types, with no finite, measurable, injective, or support assumptions.
- Its proof identifies the mapped triple law with a deterministic channel
  extension and reuses `isMarkovChain_channelExtension`; the identification is
  local, and no PMF wrapper or helper API was added.
- The theorem remains explicit, its concise name needs no Future Work Note 14
  watch entry, and the lightweight root/import boundary is unchanged.
- The owning module, a temporary standalone consumer, and the semantic/root
  aggregate passed with 2701, 2702, and 2724 jobs respectively. The consumer
  source and artifacts were deleted. Generated references now record 617
  declarations and the unchanged 33-module graph; the website checker passes.

### Completed Chunk 4 Step 3

- `condEntropyOf_dataProcessing_eq_iff` characterizes
  `H(X|Y) = H(X|Z)` under `X -> Y -> Z` exactly by the reverse chain
  `X -> Z -> Y`.
- The proof is a direct corollary of the canonical MI equality theorem and the
  existing MI/conditional-entropy identity. It remains explicit and adds no
  PMF wrapper or strict-loss companion.
- A temporary consumer combined Steps 2 and 3 to validate
  `H(Theta|X) = H(Theta|T(X))` iff `Theta -> T(X) -> X`; it and its artifacts
  were deleted after a 2702-job build.
- The owning module and semantic/root aggregate passed with 2701 and 2724 jobs.
  Generated references now record 618 declarations and the unchanged
  33-module graph; the website checker passes.

### Completed Chunk 4 Step 4

- The new `Shannon.SemanticBridge.Sufficiency` module imports only `Markov` and
  is included by the semantic aggregate, not the lightweight root.
- `statisticTripleLawOf` records `(Theta, T(X), X)`, and
  `IsSufficientStatisticOf` is exactly the reverse Markov condition. Both
  definitions are assumption-free; no recovery, family, theorem, or simp API
  was added early.
- The module, boundary consumers, and semantic/root aggregate passed with 2702,
  2712, and 2725 jobs. All temporary sources and artifacts were deleted.
- Generated references now record 620 declarations and a 34-module, 54-edge
  graph with the root-reachable count unchanged at 11; the website checker
  passes.

### Completed Chunk 4 Step 5

- Four predicate-first theorems characterize `IsSufficientStatisticOf` by the
  reverse chain, `I(Theta;X|T(X)) = 0`, preservation of `I(Theta;X)`, and
  preservation of `H(Theta|X)`.
- The MI and entropy proofs explicitly reuse the deterministic forward chain
  and existing data-processing equality results; no DPI or zero-CMI proof is
  duplicated.
- The owning module, a temporary all-four-surfaces consumer, the semantic
  aggregate, and root passed with 2702, 2703, 2716, and 2240 jobs. The consumer
  and artifacts were deleted.
- Generated references now record 624 declarations. The 34-module graph and
  root-isolation boundary are unchanged; the website checker passes.

### Completed Chunk 4 Step 6

- `isSufficientStatisticOf_iff_exists_recovery` characterizes fixed-prior
  sufficiency by one channel `R : beta -> PMF alpha` that reconstructs the
  complete `(Theta, T(X), X)` law from its parameter-statistic pair law.
- The theorem needs only `[Finite alpha]`; the source, parameter, and statistic
  value types remain unrestricted. Two representation equalities used by the
  proof remain private to the owning module.
- `exists_marginal_recovery_of_isSufficientStatisticOf` projects the same
  witness to `p.map X = (p.map fun omega => T (X omega)).bind R`. Its theorem name and
  documentation make the implication one-way because the converse is false.
- The owning module, a temporary three-surface consumer, the semantic
  aggregate, and the lightweight root all pass. Generated references now
  record 626 declarations; the 34-module, 54-edge graph remains unchanged with
  11 root-reachable and 23 separately importable modules.

### Completed Chunk 4 Step 7

- `IsSufficientChannel model W` requires one shared recovery channel
  `R : beta -> PMF alpha` whose recovered output-input joint law equals the
  swapped forward joint law for every parameter value.
- `IsSufficientStatistic model T` is definitionally
  `IsSufficientChannel model (PMF.deterministicChannel T)`. Both definitions
  are assumption-free, and no bundled statistical-experiment structure or
  auxiliary family-law definition was introduced.
- A temporary consumer checked witness introduction and elimination and the
  deterministic specialization using only the sufficiency import. The owning
  module, semantic aggregate, and unchanged root pass with 2702, 2716, and
  2240 jobs; all scratch files were deleted.
- Generated references now record 628 declarations, 626 documented. The
  34-module, 54-edge graph remains unchanged with 11 root-reachable and 23
  separately importable modules.

### Completed Chunk 4 Step 8

- `isSufficientChannel_iff_exists_common_posterior` states that a finite-input
  family channel is sufficient exactly when one posterior channel agrees with
  every model posterior on each supported output atom. It needs only
  `[Fintype alpha]`; parameter and output types remain unrestricted.
- The support premise deliberately imposes no equality on null output fibers,
  so `channelPosterior`'s documented fallback remains observationally
  irrelevant. A generic channel-joint identifiability lemma is private to the
  owning data-processing module.
- `isSufficientStatistic_id` proves without assumptions that the identity
  statistic is sufficient for every model family. No additional identity,
  constant, or injective-statistic convenience theorem was added.
- The sufficiency core, data-processing owner, public consumer, semantic
  aggregate, and unchanged root all pass. Generated references now record 630
  declarations, 628 documented; the graph remains at 34 modules with 55 edges,
  11 root-reachable and 23 separately importable modules.

### Completed Chunk 4 Step 9

- `isMarkovChainOf_of_isSufficientChannel` proves without finiteness assumptions
  that every parameter prior gives the reverse chain
  `parameter -> output -> input` in the generated hierarchical law.
- The finite corollaries
  `condMutualInfo_eq_zero_of_isSufficientChannel`,
  `mutualInfo_eq_of_isSufficientChannel`, and
  `condEntropy_eq_of_isSufficientChannel` expose zero CMI and exact preservation
  of parameter mutual information and conditional entropy for arbitrary priors.
- The first independent PMF consumer anticipated by Future Work Note 33 adds
  `condEntropy_dataProcessing_eq_iff` beside the existing random-variable
  equality characterization; the family entropy corollary reuses this direct
  law-level surface.
- The prior/model/channel law is written inline in theorem statements and kept
  in local proof abbreviations. One atomwise reverse-factorization helper stays
  private; no public experiment-law constructor or additional recovery API was
  introduced.
- The Markov and sufficiency owners and a standalone five-surface consumer
  pass. Generated references now record 635 declarations, 633 documented; the
  34-module, 55-edge graph and its 11 root-reachable/23 separate-import counts
  are unchanged.

### Completed Chunk 4 Step 10

- `isSufficientChannel_iff_isMarkovChainOf_of_support_eq_univ` proves that one
  supplied full-support prior characterizes family sufficiency with only
  `[Finite alpha]`; neither the parameter nor output type must be finite.
- `isSufficientChannel_iff_forall_isMarkovChainOf` derives the standard
  all-priors channel form under `[Finite theta] [Nonempty theta] [Finite alpha]`
  by using a locally installed uniform prior for the converse.
- The corresponding deterministic-statistic theorems
  `isSufficientStatistic_iff_isSufficientStatisticOf_of_support_eq_univ` and
  `isSufficientStatistic_iff_forall_isSufficientStatisticOf` connect the family
  predicate directly to the existing fixed-prior `...Of` predicate.
- The type-generic explicit law `PMF.channelExtension_deterministicChannel` was
  promoted after its second production consumer and now supplies the private
  deterministic representation bridge shared by the Markov/sufficiency layer.
  A simp probe rejected an attribute because it preempted the established
  generated-Markov constructor rule.
- The converse factors the swapped generated law through one recovery channel
  and cancels the positive prior atomwise. The generated law and coordinate
  helpers remain private; no bundled experiment or stronger finiteness
  assumption was introduced.
- The finite-channel, Markov, sufficiency, data-processing, semantic aggregate,
  lightweight root, and standalone public consumer checks all pass.
- Generated references record 640 declarations, 638 documented; the
  34-module, 55-edge graph and its root-isolation counts remain unchanged.

### Completed Chunk 4 Step 11

- A temporary core-only consumer proves that the genuinely noninjective
  statistic projecting `(parameter, fairBit)` to its first coordinate is
  sufficient. It exercises exact common recovery and both full-support/all-
  priors statistic characterizations while retaining a null output fiber in
  every model.
- A constant statistic on the two Boolean point-mass models is not sufficient:
  one recovery mass would have to be both zero and one. A separate fair-law
  reset recovers the observation marginal but reconstructs the wrong joint law,
  confirming that marginal recovery cannot characterize sufficiency.
- A temporary `DataProcessing` consumer exercises the common-posterior theorem
  and proves its support guard necessary: an individual model's null-fiber
  fallback differs from the common posterior fixed by the opposite model.
- The core remains Markov-only, the posterior/KL layer remains downstream, and
  a root-only probe rejects `IsSufficientChannel` as expected. No production
  Lean declaration, alias, simp rule, helper, import edge, or root import was
  added; all probes were deleted.
- Focused builds pass for `Sufficiency` and `DataProcessing` with 2702 and 2715
  jobs, and the semantic aggregate/root build passes with 2725 jobs. Generated
  reference and graph counts remain unchanged.

### Completed Chunk 4 Step 12

- `isSufficientStatistic_iff_exists_fisherNeymanFactorization` characterizes
  deterministic family sufficiency by finite factors
  `model t a = g t (T a) * h a`, where `h` is parameter-independent.
- The public assumptions are only `[Finite alpha] [Nonempty alpha]`; parameter
  and statistic alphabets remain unrestricted, and the selected observation
  enumeration is local to the proof.
- Exact recovery gives the forward factors directly. Conversely, positive
  statistic fibers normalize `h` with `PMF.normalize`, while zero-total fibers
  have zero model mass and use an irrelevant pure fallback. All normalization,
  fiber, finiteness, and output-mass helpers remain private.
- A temporary core-only consumer exercised both directions on the genuinely
  noninjective model `indepProd (PMF.pure t) fairBit` with statistic `Prod.fst`,
  then was deleted. No KL import, public factorization predicate, normalization
  API, bundled experiment, or simp rule was added.
- Builds pass for `Sufficiency`, `DataProcessing`, the semantic aggregate, and
  the lightweight root with 2702, 2715, 2716, and 2240 jobs. Generated
  references now record 641 declarations, 639 documented; the 34-module,
  55-edge graph and root-isolation counts remain unchanged.

### Completed Chunk 4 Step 13

- `klDiv_channel_eq_iff_posterior_ae_eq` states, under
  `p.support ⊆ q.support`, that equality in finite KL channel data processing
  is equivalent to almost-everywhere equality of the two posterior kernels
  under `(p.bind W).toMeasure`.
- A private helper isolates the only `ENNReal` cancellation step behind the
  explicit guard `klDiv p.toMeasure q.toMeasure ≠ ⊤`. The public theorem
  obtains that guard from the existing finite support characterization, then
  uses `InformationTheory.klDiv_eq_zero_iff` and `Kernel.compProd_eq_iff`.
- The new focused `Mathlib.Probability.Kernel.CompProdEqIff` import stays in
  `SemanticBridge.DataProcessing`. No posterior implementation, KL dependency,
  or measure-theoretic API moved into the lightweight sufficiency core or root.
- The owning module and a temporary standalone consumer exercising both iff
  directions pass; the consumer was deleted. Generated references now record
  642 declarations, 640 documented. The 34-module, 55-edge graph and its root-
  isolation counts remain unchanged.

### Completed Chunk 4 Step 14

- `klDiv_channel_eq_iff_posterior_eq_on_support` is now the primary finite-
  facing equality theorem. Under `p.support ⊆ q.support`, it characterizes
  equality in KL channel data processing by
  `channelPosterior p W b = channelPosterior q W b` for every
  `b ∈ (p.bind W).support`.
- The proof deliberately factors through Step 13's public almost-everywhere
  theorem, converts kernel equality back to equality of PMF joint laws, and
  reuses the private supported-channel identifiability lemma. Null output
  fibers remain unconstrained.
- `toReal_klDiv_channel_eq_iff_posterior_eq_on_support` gives the identical
  pointwise criterion for real-valued KL equality. Channel DPI makes the output
  divergence finite from the input support guard, so
  `ENNReal.toReal_eq_toReal_iff'` introduces no top-branch ambiguity.
- The owning module, a standalone consumer exercising both directions of both
  theorems, the semantic aggregate, and the lightweight root pass. Generated
  references now record 644 declarations, 642 documented; the 34-module,
  55-edge graph and root-isolation counts remain unchanged.

### Completed Chunk 4 Step 15

- The new separately importable
  `LeanInfoTheory.Shannon.SemanticBridge.Sufficiency.KL` module is downstream
  of `DataProcessing`; the lightweight sufficiency core retains its Markov-only
  import boundary.
- `klDiv_channel_eq_of_common_recovery` takes two input laws and one recovery
  channel that reconstructs both complete swapped input-output joint laws. It
  proves equality in `ENNReal` KL data processing without support inclusion,
  so the statement remains valid in the infinite-divergence case.
- A private helper projects full-joint recovery to input-marginal recovery.
  Applying `klDiv_channel_le` through the forward channel and then through the
  recovery channel gives the two inequalities; no posterior, kernel equality,
  relabeling, or real-valued top-branch proof is repeated.
- The focused module, standalone positive consumer, semantic aggregate, and
  lightweight root builds pass. Core-only and root-only probes reject the new
  theorem as intended. Generated references now record 645 declarations, 643
  documented; the graph records 35 modules and 57 local edges, with 11 root-
  reachable and 24 separately importable modules.

### Completed Chunk 4 Step 16

- `klDiv_channel_eq_iff_exists_common_recovery` characterizes equality in
  finite `ENNReal` channel data processing by one channel that reconstructs
  both complete output-input joint laws. Input support inclusion is used only
  for the converse and excludes the uninformative `top = top` case.
- `toReal_klDiv_channel_eq_iff_exists_common_recovery` gives the same exact-
  recovery criterion for real KL equality. The two map-facing companions state
  the deterministic-statistic cases with graph pushforwards rather than an
  exposed `deterministicChannel` implementation.
- The converse chooses one input law's posterior as the recovery channel and
  uses supported posterior equality to reconstruct the other law. The generic
  `PMF.channelJoint_eq_iff_eq_on_support` theorem was therefore promoted from a
  private data-processing helper to the opt-in finite-channel owner instead of
  duplicating its atomwise cancellation proof downstream.
- The finite-channel, data-processing, sufficiency-KL, semantic aggregate, and
  root builds pass. A standalone consumer exercises both directions and all
  four names; data-processing-only and root-only probes reject the downstream
  API. Generated references record 650 declarations, 648 documented; the graph
  remains at 35 modules and 57 local edges, with 11 root-reachable and 24
  separately importable modules.

### Completed Chunk 4 Step 17

- `klDiv_eq_of_isSufficientChannel` proves that one recovery channel shared by
  a model family preserves `ENNReal` KL divergence between every pair of model
  laws. `klDiv_eq_of_isSufficientStatistic` gives the deterministic-statistic
  specialization.
- `isSufficientChannel_iff_klDiv_eq_bool` and
  `isSufficientStatistic_iff_klDiv_eq_bool` give the guarded converse for a
  Boolean-indexed two-law model when the `false` law's support is contained in
  the `true` law's support. Step 16 supplies one recovery witness for those two
  laws, which exhaust the family.
- No larger-family converse from independently chosen pairwise witnesses is
  claimed. No real wrapper, posterior helper, simp rule, alias, import edge, or
  marginal-recovery theorem was added.
- The focused module and semantic aggregate/root build command pass. A
  standalone consumer exercises both forward theorems and both directions of
  the binary iff family; data-processing-only and root-only probes reject the
  downstream declarations as intended. Generated references now record 654
  declarations, 652 documented; the graph remains at 35 modules and 57 local
  edges, with 11 root-reachable and 24 separately importable modules.

### Completed Chunk 4 Step 18

- `LeanInfoTheory.Examples.SufficientStatistics` is a separately importable
  finite example module downstream of `Sufficiency.KL`. Its ancillary-noise
  experiment has a statistic that is globally noninjective and collides on two
  supported observations for every parameter, yet is sufficient by one common
  exact recovery channel.
- Public declarations exercise the fixed-prior predicate and MI equality, family
  sufficiency, exact recovery, every-prior characterization, finite Fisher-
  Neyman factorization, pairwise KL preservation, and both Boolean KL converse
  surfaces. A proper-support disposable probe confirms that the opposite
  Boolean orientation is handled cleanly by `Bool.not` reindexing.
- The same module proves that a constant statistic is not sufficient for two
  separated point masses and that a reset channel can recover a marginal while
  failing to reconstruct the complete identity graph law. No theorem, helper,
  alias, or simp rule was added to a core semantic module.
- The focused example build passes with 2,749 jobs, the examples aggregate with
  2,760 jobs, and the semantic aggregate/root command with 2,758 jobs. Positive
  opt-in and negative root-only consumers behave as intended. Generated
  references record 686 declarations, 684 documented; the graph records 36
  modules and 59 local edges, with 11 root-reachable and 25 separately
  importable modules. The website checker passes.

### Completed Chunk 4 Step 19

- The scheduled public API review declined all ten provisional alias families.
  Existing names preserve meaningful witness, support, prior, fixed-law/family,
  full-joint/marginal, and `ENNReal`/real distinctions; no declaration was
  renamed or duplicated.
- No sufficiency, recovery, posterior, Fisher-Neyman, or KL equality theorem
  became a simp rule. Controlled predicates and semantic equivalences remain
  explicit, while the lower finite-channel layer retains the canonical
  constructor-reducing rules.
- Source comments now explain coordinate order, shared recovery quantifiers,
  null fibers, full-support cancellation, common supported posteriors, and the
  separate Fisher-Neyman finiteness roles. No theorem statement, proof,
  definition, import, attribute, or public name changed.
- The measured review retains `Sufficiency` as the Markov-only core,
  `DataProcessing` as the posterior/kernel equality engine, and
  `Sufficiency.KL` as the downstream recovery/KL integration layer. All remain
  outside the lightweight root.
- Focused builds of those three modules and `Examples.SufficientStatistics`
  pass. A downstream consumer resolves every watched name, a root-only consumer
  rejects the sufficiency API as intended, and all disposable files are gone.

### Completed Chunk 4 Step 20

- All ten required milestone Lake targets pass, including the 2,749-job
  semantic aggregate and 2,760-job examples aggregate.
- Guarded root, core-only, and data-processing-only consumers confirm the
  intended non-leakage boundaries. Downstream KL and example consumers exercise
  the completed API, and representative axiom reports contain no `sorryAx`.
- Both source-derived generators are idempotent. The API index records 686
  public declarations, 684 documented; the graph records 36 modules and 59
  local edges, with 11 root-reachable and 25 separately importable modules.
- The website, placeholder, temporary-file, process, root-import, and diff-
  hygiene checks pass. `LeanInfoTheory.lean` remains unchanged, and the three
  new Chunk 4 modules remain outside the lightweight root.
- Step 20 adds no declaration, alias, simp rule, helper, import edge, or Future
  Work trigger. All 20 Chunk 4 steps are complete and ready for the coherent
  checkpoint.

## Completed Project B Chunk 3 Plan

Current status: all 20 steps are complete.
The chunk covers finite stochastic channels, Markov structure, MI and KL data
processing, and their immediate one-step consequences.

1. Completed on July 14, 2026: lock the contract through no-placeholder
   channel/Markov/MI spikes and record the active plan and deferred work.
2. Completed on July 15, 2026: introduce the opt-in finite-channel core using
   raw PMF-valued functions and four repeated compound constructions.
3. Completed on July 15, 2026: prove channel atom, projection, algebra,
   deterministic-map, and support laws.
4. Completed on July 15, 2026: construct a total conditional channel with a
   documented null-fiber branch.
5. Completed on July 15, 2026: prove positive-fiber agreement, null-fiber
   irrelevance, weighted atom reconstruction, and pair-law reconstruction.
6. Completed on July 15, 2026: introduce PMF/random-variable Markov predicates
   and the required conditional-independence symmetry API.
7. Completed on July 15, 2026: prove cross-product, positive-fiber, zero-CMI,
   and reversal Markov characterizations.
8. Completed on July 15, 2026: prove that channel-generated triples are
   Markov.
9. Completed on July 15, 2026: prove the exact PMF and random-variable mutual-
   information loss identities.
10. Completed on July 15, 2026: derive MI data processing, its conditional-
    entropy consequence, and reverse-Markov equality case.
11. Completed on July 15, 2026: add one-sided, independently two-sided,
    cascade, and deterministic channel-facing MI processing.
12. Completed on July 15, 2026: prove the canonical and existential Markov
    channel-factorization converses using the total conditional channel.
13. Completed on July 15, 2026: select the kernel/KL contraction route and lock
    its support assumptions through a no-placeholder feasibility checkpoint.
14. Completed on July 15, 2026: bridge finite PMF channels to mathlib Markov
    kernels and identify their induced joint measures.
15. Completed on July 15, 2026: construct the total channel posterior, prove
    joint reconstruction, and establish the exact KL posterior decomposition.
16. Completed on July 15, 2026: establish the private finite KL contraction
    engine from the nonnegative posterior remainder.
17. Completed on July 15, 2026: publish `ENNReal`, support-guarded real,
    deterministic-map, and channel-cascade KL data processing.
18. Completed on July 15, 2026: derive invariant-reference contraction and
    uniform-preserving entropy growth, with a finite doubly-stochastic
    corollary.
19. Completed on July 16, 2026: add common-cause and stochastic examples and
    complete the naming, simp, module, and future-work review.
20. Completed on July 16, 2026: integrate, regenerate references, run the full
    milestone suite, and create the clean checkpoint commit.

### Locked Step 20 Integration

- All ten milestone Lake targets pass. The semantic aggregate builds with 2715
  jobs and the examples aggregate with 2725 jobs.
- The generated declaration index contains 616 documented public declarations.
  The module graph contains 33 modules and 52 local import edges: 11 modules are
  root-reachable and 22 remain separately importable.
- The website checker passes for 12 HTML files and both generated JSON files. A
  temporary 2718-job Lake consumer exercised representative finite-channel,
  Markov, data-processing, and example declarations and was deleted.
- Source-derived isolation confirms that all five new Chunk 3 modules remain
  outside the lightweight root. Placeholder, scratch, temporary-declaration,
  diff-hygiene, and process checks pass.

### Locked Step 19 Examples and Review

- `Examples.CommonCause` constructs two noisy binary observations of a fair
  cause and exercises `IsCondIndependentOf`, positive-fiber endpoint
  independence, zero CMI, and canonical and existential Markov factorization.
- `Examples.StochasticChannels` exercises both Step 18 entropy surfaces, proves
  strict entropy growth from a pure input, contracts KL toward a nonuniform
  invariant law, and separates source support from intermediate cascade
  support.
- The review added the compatibility aliases
  `isMarkovChain_iff_fiberwise_endpoints_independent`,
  `isMarkovChain_iff_canonical_channelExtension`,
  `mutualInfo_channel_cascade_le`, `klDiv_channel_cascade_le`, and
  `toReal_klDiv_channel_cascade_le`. Every original declaration remains public,
  and no alias is a simp rule.
- Representative simp goals still close with the existing policy. The semantic
  modules remain separately importable and outside the lightweight root. The
  duplicate private `klDiv_channel_le_aux` wrapper was inlined into
  `klDiv_channel_le` without changing its statement.

### Locked Step 18 Invariant-Law Consequences

- `klDiv_channel_invariant_le` and
  `toReal_klDiv_channel_invariant_le` specialize the Step 17 channel DPI to a
  reference law `r` satisfying `r.bind W = r`. The primary theorem remains
  unconditional and `ENNReal`-valued; the real form retains the input support
  condition `p.support ⊆ r.support`.
- `entropy_le_entropy_bind_of_uniform_invariant` rewrites real KL divergence
  to the uniform law as `log |alpha| - H(P)`. Its discrete measurable structure
  is local, so callers see only `[Fintype alpha]` and `[Nonempty alpha]`.
- `entropy_le_entropy_bind_of_doublyStochastic` takes the finite column-sum
  condition `∀ b, ∑ a, W a b = 1`; PMF-valued rows already provide row
  stochasticity. The proof derives uniform preservation locally. No bundled
  channel, matrix bridge, transition process, or public helper was introduced.
- All four results remain explicit rather than `[simp]`. Future Work Note 14
  records the Step 19 decision to retain the two descriptive entropy names
  without `mono` or `nondecreasing` aliases. Future Work Note 38 defers a
  mathlib doubly-stochastic-matrix bridge until the later majorization phase
  creates a real consumer. The lightweight root is unchanged.

### Locked Step 17 KL Data-Processing API

- `klDiv_channel_le` is the primary unconditional `ENNReal` theorem, and
  `toReal_klDiv_channel_le` requires only the input support inclusion
  `p.support ⊆ q.support`. The real proof uses `ENNReal.toReal_mono`; it does
  not repeat the top-branch elimination tracked by Future Work Note 22.
- `klDiv_map_le` and `toReal_klDiv_map_le` specialize the common channel to a
  deterministic map. `klDiv_channelComp_le` and
  `toReal_klDiv_channelComp_le` contract the second stage of a channel cascade;
  they require finite measurable-singleton structure only on the intermediate
  and final alphabets, not on the original source type.
- Support inclusion through the first channel is proved by one private helper
  used only by the real cascade theorem. No support, recovery, equality, or KL-
  relabeling theorem was promoted speculatively. All six inequalities remain
  explicit rather than `[simp]`.
- The cascade names follow the established `PMF.channelComp` and mutual-
  information vocabulary. Step 19 retained those names and added the reviewed
  `klDiv_channel_cascade_le` and `toReal_klDiv_channel_cascade_le`
  compatibility aliases. The data-processing module stays opt-in and the
  lightweight root is unchanged.

### Locked Step 16 Contraction Engine

- The private `klDiv_channel_le_aux` theorem already has the intended public
  assumptions: `[Finite alpha]`, `[Finite beta]`, and explicit measurable-
  singleton spaces, with no support-inclusion hypothesis.
- Its proof installs only the input `Fintype`, rewrites with
  `klDiv_channel_eq_add_posterior`, and drops the posterior KL remainder by
  `ENNReal` nonnegativity. It introduces no second analytic argument.
- Step 16 adds no public declaration, alias, simp theorem, posterior-equality
  condition, support helper, or recovery API. Step 17 publishes the coherent
  primary/real/deterministic/cascade theorem family above without exposing the
  engine.

### Locked Step 15 Posterior Decomposition

- `channelPosterior p W` is exactly
  `condFstGivenSndChannel (PMF.channelJoint p W)`. Its null-output fallback is
  inherited from the established total conditional-channel convention and has
  no independent probabilistic meaning.
- `channelPosterior_reconstructs_joint` is deliberately PMF-first and requires
  only `[Fintype alpha]`: sampling the posterior from `p.bind W` reconstructs
  `PMF.channelJoint p W` in output-input order.
- `klDiv_channel_eq_add_posterior` is an unconditional `ENNReal` identity. It
  splits input KL into output KL plus the divergence between the two posterior
  kernels over the first output law, using mathlib composition-product measures.
- Finite KL invariance under equivalence and the measurable posterior
  `compProd` reconstruction remain private implementation lemmas. The former
  still has only the coordinate-swap consumer tracked by Future Work Note 35.
- The proof composes existing channel-output and total-conditional-channel
  reconstruction theorems. It repeats neither watched Step 12 middle-marginal
  equality nor its null-fiber support transport, so no helper extraction or
  stronger assumption is justified.

### Locked Step 14 Kernel Bridge

- `pmfChannelKernel W` is the semantic kernel view of the existing raw channel
  `W : alpha -> PMF beta`; it uses `Kernel.ofFunOfCountable` and introduces no
  bundled or competing channel representation.
- Its global `IsMarkovKernel` instance follows pointwise from the probability-
  measure instance of each `W a`. The `[simp]` evaluation theorem merely
  reduces the bridge back to `(W a).toMeasure`.
- `channelJoint_toMeasure` states that `(PMF.channelJoint p W).toMeasure` is
  `p.toMeasure ⊗ₘ pmfChannelKernel W`. It is explicit rather than a simp rule,
  and its countability and measurable-singleton assumptions are inferred from
  the finite alphabets used by later KL theorems.
- Step 14 adds no posterior definition, KL theorem, support helper, Step 12
  alias, or stronger alphabet assumption. Those decisions remain owned by the
  scheduled later steps and proof-pressure notes.

### Locked Step 13 KL Contract

- Raw `W : alpha -> PMF beta` channels are converted locally with mathlib's
  `Kernel.ofFunOfCountable`; the project does not introduce a second channel
  representation.
- The proof route identifies kernel `compProd` with `PMF.channelJoint`, uses
  `condFstGivenSndChannel` as a total finite posterior, and reconstructs the
  swapped joint law through the existing weighted conditional-channel theorem.
- Exact posterior decomposition is obtained from mathlib's
  `klDiv_compProd_left` and `klDiv_compProd_eq_add`. A finite KL invariance
  lemma for equivalence relabeling supplies only the required coordinate swap
  and should remain private until another independent consumer justifies a
  public theorem.
- Finite channel KL contraction is primarily an unconditional `ENNReal`
  theorem. Its real-valued corollary assumes only `p.support ⊆ q.support`;
  channel output support inclusion follows automatically. Deterministic and
  cascade forms are direct specializations, and the same original support
  guard suffices for the real cascade theorem.
- The direct finite log-sum route would duplicate analytic infrastructure not
  currently exposed by mathlib. Mathlib's general posterior construction would
  also impose unnecessary standard-Borel machinery, so neither route is used.
- Steps 14-18 belong in a separately importable
  `Shannon.SemanticBridge.DataProcessing` module. The lightweight root remains
  unchanged.

### Locked Step 1 Contract

- A channel is represented directly by `W : alpha -> PMF beta`; no channel
  structure or parallel probability theory is introduced.
- Output, identity, deterministic, and composition semantics reuse `PMF.bind`,
  `PMF.pure`, and `PMF.map`. Only repeated constructions receive local names.
- The total conditional channel uses `fstMarginal p` on null second-marginal
  fibers and `condFstGivenSnd` on positive fibers. Its public consequences are
  support-aware, so the null convention is not given semantic significance.
- `IsMarkovChainOf p X Y Z` means `IsCondIndependentOf p X Z Y`; the PMF form
  applies this to the three coordinate projections.
- Under that predicate, the existing MI chain rules prove
  `I(X;Y) = I(X;Z) + I(X;Y|Z)`. CMI nonnegativity proves DPI, and zero CMI
  characterizes its reverse-Markov equality case.
- Generic channel mechanics belong in an opt-in
  `Probability.FiniteChannel` module; Markov/MI and later kernel/KL work belong
  in separate semantic-bridge submodules. The lightweight root stays unchanged.
- Finiteness and measurability assumptions are introduced only by the layers
  that consume them. The later KL theorem is primarily `ENNReal`-valued.

## Completed Project B Chunk 2 Plan

Current status: all 18 steps are complete. The chunk covers finite KL
support/equality, uniformity, independence, and conditional independence, and
the final milestone suite and hygiene checks pass.

1. Completed on July 14, 2026: checkpoint the completed Chunk 1 milestone as
   commit `7ab3aa0` with a clean worktree.
2. Completed on July 14, 2026: lock theorem shapes, names, ownership, support
   conventions, and proof routes through temporary no-placeholder Lean spikes.
3. Completed on July 14, 2026: promote the lightweight finite
   `PMF.supportFinset` API and make `EntropyBounds` consume it while retaining
   the stronger support-restriction PMF as private implementation machinery.
4. Completed on July 14, 2026: characterize PMF absolute continuity by support
   inclusion and, on finite alphabets, characterize finite and infinite KL
   divergence by whether that inclusion holds.
5. Completed on July 14, 2026: specialize mathlib's KL zero-equality theorem to
   PMFs and prove the real-valued zero characterization under the finite
   support-inclusion guard.
6. Completed on July 14, 2026: prove the support-aware KL identity against
   `PMF.uniformOfFinset` and its full-alphabet `PMF.uniformOfFintype` corollary.
7. Completed on July 14, 2026: characterize equality in the alphabet- and
   support-cardinality entropy bounds by uniformity, at both PMF and
   random-variable levels, using strict Jensen in the opt-in bounds module.
8. Completed on July 14, 2026: introduce ordinary PMF and random-variable
   independence predicates, pointwise/product-law characterizations, and
   symmetry in the separately importable semantic independence module.
9. Completed on July 14, 2026: bridge mapped-law independence to mathlib
   `ProbabilityTheory.IndepFun` under explicit measurability and measurable-
   singleton assumptions.
10. Completed on July 14, 2026: characterize zero mutual information by
    `IsIndependent` and `IsIndependentOf`, with the discrete measurable-space
    choice confined locally to the KL proof.
11. Completed on July 14, 2026: characterize equality in conditioning-reduces-
    entropy and joint-entropy subadditivity by ordinary independence, at both
    PMF and random-variable levels.
12. Completed on July 14, 2026: characterize zero averaged conditional mutual
    information by zero mutual information on every positive-mass conditional
    joint fiber.
13. Completed on July 14, 2026: introduce `IsCondIndependent` and
    `IsCondIndependentOf` through proof-independent cross-product factorization
    and prove the PMF predicate equivalent to independence of every positive-
    mass conditional joint law.
14. Completed on July 14, 2026: characterize zero conditional mutual
    information by `IsCondIndependent` and `IsCondIndependentOf` at PMF and
    random-variable levels.
15. Completed on July 14, 2026: characterize preservation of conditional
    entropy and additivity of conditional joint entropy by conditional
    independence, at PMF and random-variable levels.
16. Completed on July 14, 2026: add separately importable support-sensitive and
    non-absolutely-continuous examples using the public theorem contracts.
17. Completed on July 14, 2026: review names, aliases, simp policy, module
    pressure, and deferred relabeling; add only the four approved additive-
    entropy compatibility aliases.
18. Completed on July 14, 2026: integrate the accumulated work, regenerate both
    public reference sets, run the complete ten-target milestone suite and
    repository hygiene checks, and prepare the clean Chunk 2 checkpoint.

### Locked Step 2 Contract

- `PMF.supportFinset` will expose only membership, set coercion, cardinality,
  and nonemptiness facts. The stronger support-restriction PMF remains private.
- For finite PMFs, `p.toMeasure ≪ q.toMeasure` is represented by
  `p.support ⊆ q.support`; on a finite alphabet this is equivalent to
  `klDiv p.toMeasure q.toMeasure ≠ ∞`, while failure of inclusion is equivalent
  to KL being `∞`.
- The project continues to use mathlib's `InformationTheory.klDiv : ENNReal`.
  A real-valued zero theorem must assume support inclusion/finiteness so that
  `ENNReal.toReal ∞ = 0` cannot create a false equality characterization.
- The uniform-reference identity has the generalized support-aware shape
  `D(p || uniform(s)) = log |s| - H(p)` under `support(p) ⊆ s`.
- Entropy-bound equality remains in `Shannon.EntropyBounds` and uses strict
  Jensen. The KL identity remains in the separately importable semantic layer.
- `Shannon.IsIndependent p` means that a joint PMF equals the independent
  product of its marginals. `Shannon.IsIndependentOf p X Y` applies this to the
  mapped joint law. The mathlib bridge uses explicit measurability assumptions.
- `Shannon.IsCondIndependent p` is primarily the proof-independent statement
  `p(a,b,c) * p_C(c) = p_AC(a,c) * p_BC(b,c)` for every atom. Independence of
  each positive conditional joint law is an equivalent theorem; null fibers
  satisfy the primary factorization automatically.
- The primary KL families use support-explicit names such as
  `klDiv_pmf_ne_top_iff_support_subset`,
  `klDiv_pmf_eq_top_iff_not_support_subset`, and
  `toReal_klDiv_pmf_eq_zero_iff`. The main equality theorems use
  `mutualInfo_eq_zero_iff_isIndependent` and
  `condMutualInfo_eq_zero_iff_isCondIndependent`, with parallel `...Of` forms.
- The ordinary- and conditional-independence APIs live in the separately
  importable `Shannon.SemanticBridge.Independence` module. The aggregate
  semantic bridge imports it, but the lightweight root does not.
- Stochastic channels, Markov chains, general data processing, sufficient
  statistics, Fano, and finite-family entropy remain outside this chunk.

## Completed Project B Chunk 1 Plan

Current status: all 14 steps are complete. Step 1 fixed the theorem
contract; steps 2 and 3 completed the ordinary-entropy block; steps 4 and 5
completed the zero-conditional-entropy and functional-dependence block; step 6
completed the pair/triple conditional-entropy chain-rule block; step 7 completed
deterministic entropy processing and its equality cases; step 8 completed the
elementary mutual-information identity family; step 9 completed the pair-level
entropy and mutual-information inequalities; step 10 completed deterministic
mutual-information processing; step 11 completed the conditional-mutual-
information identity family; step 12 completed the triple-level conditional
inequality band; step 13 completed opt-in units and the pressured API review;
step 14 completed the integration review, public-status refresh, generated
references, and full milestone suite.

1. Completed on July 12, 2026: freeze theorem statements, support conventions,
   names, file ownership, and proof routes. Temporary no-placeholder Lean
   proofs validated both `H(X) = 0` iff purity and `H(X|Y) = 0` iff support-wise
   functional dependence.
2. Completed on July 12, 2026: prove `Shannon.entropy_eq_zero_iff`, stating
   that a finite PMF has zero entropy exactly when it is pure, and
   `Shannon.entropyOf_eq_zero_iff`, stating that a finite-valued random
   variable has zero entropy exactly when it is constant on the source PMF
   support.
3. Completed on July 12, 2026: prove
   `Shannon.entropy_le_log_support_ncard` and
   `Shannon.entropyOf_le_log_support_ncard` by restricting the PMF to its
   finite nonzero support and reusing `entropy_le_log_card`.
4. Completed on July 12, 2026: prove
   `Shannon.condEntropyFstGivenSnd_eq_zero_iff_of_sndMarginal_ne_zero`, reducing
   positive-fiber zero entropy exactly to purity of the canonical conditional
   PMF.
5. Completed on July 12, 2026: characterize PMF and random-variable zero
   conditional entropy by support-wise functional dependence; add deterministic
   function, self-conditioning, and joint-entropy equality corollaries; and
   promote the reused singleton-support PMF lemma.
6. Completed on July 12, 2026: prove random-variable conditioned-pair swap
   invariance and both triple conditional-entropy chain rules, together with
   PMF-facing `pairThirdLaw` forms. The new rules remain explicit rewrites.
7. Completed on July 12, 2026: prove PMF and random-variable deterministic
   entropy monotonicity with equality exactly under injectivity on the law
   support; prove the conditional deterministic chain identity, monotonicity,
   and equality exactly under support-wise recovery from `(f(X), Z)`, together
   with PMF-facing first-coordinate forms.
8. Completed on July 14, 2026: prove both PMF and random-variable forms of
   `I(A;B) = H(A) - H(A|B)` and `I(A;B) = H(B) - H(B|A)`, plus the diagonal-law
   and self identities `I(A;A) = H(A)`, all in the lightweight finite layer.
9. Completed on July 14, 2026: prove PMF and random-variable forms of
   conditioning-reduces-entropy, MI upper bounds by both marginal entropies,
   both marginal-to-joint entropy bounds, and joint entropy subadditivity;
   independence-based equality cases remain deferred.
10. Completed on July 14, 2026: add random-variable conditional-MI
    nonnegativity, prove the exact deterministic chain decomposition
    `I(X;Y) = I(f(X);Y) + I(X;Y|f(X))`, and derive one-sided and two-sided
    deterministic mutual-information processing for random variables and joint
    PMFs. Stochastic channels and conditional-independence equality
    characterizations remain deferred.
11. Completed on July 14, 2026: add random-variable forms of
    `I(X;Y|Z) = H(X|Z) - H(X|Y,Z)`, its symmetric `Y` form, and
    `I(X;Y|Z) = H(X|Z) + H(Y|Z) - H(X,Y|Z)` in the lightweight layer; add the
    missing symmetric PMF difference identity in the semantic theorem layer.
12. Completed on July 14, 2026: prove PMF and random-variable forms of
    `I(X;Y|Z) <= H(X|Z), H(Y|Z)` and
    `H(X|Z), H(Y|Z) <= H(X,Y|Z) <= H(X|Z) + H(Y|Z)`; conditional-independence
    equality cases remain deferred.
13. Completed on July 14, 2026: add the separately importable
    `Shannon.Units` change-of-base module; add compatibility-preserving
    left/right/both aliases for the pressured chain-rule, inequality, and
    deterministic-processing families; and promote only canonical PMF
    swap/diagonal and RV self reductions to `[simp]`.
14. Completed on July 14, 2026: review the accumulated Chunk 1 diff and module
    boundaries, update public status, regenerate the dependency graph and
    434-declaration API index, and pass the complete root, bounds, units,
    semantic bridge, reference, certificate-demo, examples, website,
    placeholder, and diff-hygiene suite.

### Locked Step 1 Contract

- Equalities of random variables are support-wise: `X omega = f (Y omega)` is
  required only for `omega in p.support`. No global equality outside the
  probability law's support is imposed.
- The primary zero-entropy theorems will use the names
  `entropy_eq_zero_iff` and `entropyOf_eq_zero_iff`.
- The primary zero-conditional-entropy theorems will use the names
  `condEntropyFstGivenSnd_eq_zero_iff_of_sndMarginal_ne_zero`,
  `condEntropy_eq_zero_iff_exists_function`, and
  `condEntropyOf_eq_zero_iff_exists_function`.
- Deterministic entropy equality is characterized by
  `Set.InjOn f (p.map X).support`, not injectivity of `f comp X` on the source
  support. Conditional deterministic equality instead uses recovery of
  `X` from `(f(X), Z)` on the source support.
- The new support bounds will be named
  `entropy_le_log_support_ncard` and
  `entropyOf_le_log_support_ncard`; they will not require an artificial
  `[Nonempty alpha]` assumption because a PMF has nonempty support.
- Lightweight algebraic identities and the new conditional chain rules remain
  in `Shannon/InfoMeasures.lean`. Zero entropy remains in
  `Shannon/Entropy.lean`, support bounds remain in
  `Shannon/EntropyBounds.lean`, and semantic nonnegativity/equality consequences
  remain in `Shannon/SemanticBridge/Theorems.lean` unless actual file pressure
  justifies a later split.
- Base conversion is opt-in and leaves nats canonical. `Shannon.Units` exposes
  division-by-`Real.log`/`Real.logb` bridge theorems rather
  than duplicate the entropy, conditional-entropy, MI, and CMI definition
  hierarchy.
- The root import, certificate architecture, and existing theorem statements
  remain unchanged throughout this chunk.

## Completed 9-Step Lean Theorem Plan

Current status: all nine steps are complete.

1. Completed on July 8, 2026: prove mutual-information symmetry through
   `Shannon.mutualInfo_map_swap` and `Shannon.mutualInfoOf_swap`.
2. Completed on July 8, 2026: prove conditional mutual-information symmetry
   through `Shannon.condMutualInfo_map_swap12` and
   `Shannon.condMutualInfoOf_swap`.
3. Completed on July 8, 2026: prove finite conditional entropy nonnegativity
   through `Shannon.condEntropy_nonneg` and `Shannon.condEntropyOf_nonneg`.
4. Completed on July 8, 2026: add conditional entropy chain-rule variants
   for joint PMFs and finite-valued random variables.
5. Completed on July 8, 2026: add mutual-information chain-rule variants
   beyond `mutualInfo_chain_rule_fst`, including the sibling
   `I(A;B,C) = I(A;B) + I(A;C|B)` and random-variable forms.
6. Completed on July 8, 2026: prove conditioning-reduces-entropy through
   `Shannon.condEntropy_le_condEntropy_fstThirdMarginal` and
   `Shannon.condEntropyOf_pair_le_condEntropyOf`.
7. Completed on July 8, 2026: add small checked-certificate examples beyond
   submodularity, namely entropy subadditivity and one-variable entropy
   monotonicity.
8. Completed on July 8, 2026: review certificate ergonomics after the new
   examples and add `Certificate.RawCert.sound_of_toCheckedCert?_isSome` to
   remove repeated option-splitting in demo soundness proofs.
9. Completed on July 8, 2026: refresh project notes, future-work notes, and
   website reference artifacts after the completed theorem/certificate phase.

## Completed Manual Certificate Pressure-Test Plan

Current status: all six steps are complete.

1. Completed on July 8, 2026: add the separately importable module
   `LeanInfoTheory.Certificate.ThreeWaySubadditivity`.
2. Completed on July 8, 2026: define the target expression
   `H(A) + H(B) + H(C) - H(A union B union C)` and prove its evaluation
   formula through `Certificate.ThreeWaySubadditivity.eval_expr`.
3. Completed on July 8, 2026: use a manually tagged two-block primitive
   certificate:
   `I(A;B | empty) + H(empty)` and
   `I(A union B;C | empty) + H(empty)`, proving
   `Certificate.ThreeWaySubadditivity.entropy_three_way_subadditivity`.
4. Completed on July 9, 2026: audit the conservative scope. The pressure-test
   module imports only `LeanInfoTheory.Certificate.Checked`, does not change
   the root import, and adds no assumptions, primitive recognition, certificate
   DSL, or finite-family entropy representation.
5. Completed on July 9, 2026: record the pressure-test lessons. The main
   friction was expression normalization in exact decomposition proofs; raw
   step boilerplate and explicit primitive tags are still manageable at this
   scale, and the descriptive theorem name
   `entropy_three_way_subadditivity` is acceptable.
6. Completed on July 9, 2026: refresh public artifacts, add the three-way
   theorem to hand-written theorem highlights, and run the relevant Lean and
   website checks.

### Pressure-Test Lessons

The three-way subadditivity example is the first certificate demo large enough
to say something useful about ergonomics beyond one- or two-step examples.

- Raw-step boilerplate is repetitive but still readable for a four-step
  certificate. It does not yet justify a certificate DSL.
- Explicit primitive tags are verbose but useful for the trust boundary. This
  example does not justify primitive-recognition/autotagging yet.
- Exact decomposition proofs are the first real pain point. The proof needed
  local additive-group normalization for associativity and cancellation after
  expanding the two CMI-plus-empty blocks.
- The theorem naming style remains workable: descriptive names such as
  `entropy_three_way_subadditivity` are clear enough for demo modules.
- The next larger certificate should watch whether expression normalization
  repeats; if it does, a small untrusted or proof-only normalization helper may
  be more urgent than primitive-tag inference.

## Commands After Lean Edits

Use the relevant subset, and run broader checks for shared API or theorem-layer
changes.

```powershell
lake build LeanInfoTheory
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

If Lean declarations or imports change, also refresh and check the website
reference artifacts:

```powershell
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/check_website.py
git diff --check
```
