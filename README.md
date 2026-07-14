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
  checks, and repository hygiene review all pass, and the chunk is ready as a
  clean checkpoint for the next Project B phase.

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
  conditioning-reduces-entropy, the finite independence predicates, and the
  cross-product/positive-fiber/zero-CMI conditional-independence bridge with
  its entropy equality cases.
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
  `LeanInfoTheory.Examples` for demos and examples. The two semantic example
  modules may also be imported individually.

## Roadmap

1. Select and plan the next focused Project B chunk before editing Lean. The
   leading candidate is the stochastic-channel, Markov, and data-processing
   dependency layer, but its exact contracts and mathlib ownership should be
   fixed during that planning pass.
2. Continue toward sufficient statistics and Fano only after the channel and
   data-processing foundations they consume are stable.
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
