# External Review Notes - 15 June 2026

This note summarizes two external ChatGPT Pro reports that reviewed the public
LeanInfoTheory repository, website, and code architecture around 15 June 2026.
It records the suggestions that are useful for future planning. The reports
should be treated as design advice rather than as the source of truth: they
were written from public snapshots and did not always include the latest local
or pushed repository state.

In particular, Lean CI and GitHub Pages deployment were added around the same
period, so the remaining infrastructure advice is mainly about making that
status visible and adding stricter placeholder checks.

## Foundation Assessment

The reports strongly agreed with the main foundation choices already made in
this project:

- Use mathlib `PMF`, `Real`, and `Real.negMulLog`, not a toy local probability
  model.
- Treat the current `condEntropy`, `mutualInfo`, and `condMutualInfo`
  definitions as an algebraic finite-Shannon API, then prove semantic bridge
  theorems to conditional laws and KL divergence.
- Keep KL divergence, conditional probability, kernels, coding theory, and
  Kraft-McMillan imports out of the lightweight root API.
- Delay a general finite-family entropy API until pair/triple APIs and the
  semantic bridge reveal the right indexing representation.
- Upstream to mathlib only after local theorem pressure has stabilized names,
  assumptions, and API shape.

## Main Risk

The reports clarified one risk that ordinary Lean development will not force us
to solve: the certificate layer can remain mathematically correct but too
assumption-based unless we deliberately turn it into a checker.

The current `Certificate.sound` theorem assumes both the decomposition equality
and the nonnegativity of each ingredient. A real certificate checker should
instead validate nonnegative coefficients, normalize the target and
decomposition as formal entropy expressions, and derive primitive inequality
soundness from a fixed semantic basis.

## New Architectural Suggestion

The most important new architectural suggestion is to introduce an abstract
entropy-valuation layer, tentatively something like `ShannonEntropyVal` or an
`EntropyCone` namespace. Such a structure would assign a real value to each
entropy atom and record axioms such as `H(empty) = 0`, conditional entropy
nonnegativity, and conditional mutual information nonnegativity.

The certificate checker could then prove Shannon-type inequalities for any
abstract valuation before the project has fully proved that concrete finite
`PMF` entropy assignments instantiate that valuation. Later, the finite Shannon
layer should provide the concrete PMF instance.

## Already Well Covered

These external-review points were already present in the project log or
foundation conventions:

- semantic bridge targets for entropy/self-information, conditional laws,
  mutual information as KL divergence, and conditional mutual information via
  KL chain rules or averaged conditional KL;
- careful zero-probability conditioning design instead of blindly copying the
  Rocq default-distribution convention;
- lightweight/heavy import separation through `SemanticBridge` and
  `MathlibFragments`;
- cautious `[simp]` policy for product, map, marginal, swap, and reassociation
  lemmas;
- future split of `Shannon.InfoMeasures` only after theorem pressure clarifies
  the boundaries;
- delayed finite-family entropy API;
- staged upstream plan for mathlib;
- keeping PSITIP/oXitip-style import local until the internal certificate
  format is stable.

## Likely To Happen Naturally

These items should arise if the project keeps following the current roadmap,
though they should still be checked periodically:

- chain rules for entropy, conditional entropy, mutual information, and
  conditional mutual information;
- value-level entropy orientation theorems for swaps, reassociation, and
  coordinate projections, building on the current marginal-orientation API;
- mutual information and conditional mutual information nonnegativity, once the
  KL or elemental-inequality bridge is available;
- small mathlib PR candidates for generic PMF finite-sum and map/measure
  bridge lemmas;
- file splits around `Marginals`, `ConditionalEntropy`, `MutualInfo`,
  `ConditionalMutualInfo`, and semantic bridge subfiles once the central file
  becomes too large.

## Requires Special Attention

These items are easy to postpone unless they remain explicit:

- design `RawCert` versus `CheckedCert`, so untrusted external certificates
  become trusted only after Lean validates coefficients and expression
  equality;
- use nonnegative coefficient types internally, such as `NNRat` or a subtype,
  after parsing and validation from external rational data;
- implement a deterministic expression-equality check for certificate
  decompositions, probably using normalized `Finsupp` expressions;
- define primitive Shannon inequalities as formal entropy expressions and prove
  their soundness for the chosen abstract semantics;
- add empty-atom semantics, especially `H(empty) = 0`, before normalization and
  textbook certificate examples depend on it;
- choose a first serious certificate demo, such as submodularity or a symbolic
  data-processing inequality, instead of only adding more tiny algebraic
  examples;
- make the public status machine-checkable with a visible build badge,
  no-placeholder check for `sorry`, `admit`, and unapproved `axiom`s, and later
  generated API documentation;
- keep the website wording precise until generated API docs and non-toy
  examples exist, including clear limitations about the semantic bridge,
  certificate checker, and network-converse status;
- add a minimal collaboration surface, such as `CONTRIBUTING.md`, beginner
  tasks, and issue labels, before inviting outside contributors.
