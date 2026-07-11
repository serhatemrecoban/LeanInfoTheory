# Current Lean State

Last checkpoint: July 8, 2026, after completing the active nine-step Lean
theorem/certificate plan.

This is a handoff note for future Lean-focused work. It summarizes the current
architecture and the next useful Lean tasks without changing theorem
statements.

## Current Lean Architecture

- `LeanInfoTheory.lean` is the lightweight root import. It imports the stable
  finite information-measure API and the core certificate/checker definitions,
  but not heavier theorem, semantic bridge, demo, coding, or reference modules.
- `LeanInfoTheory.Basic` holds lightweight namespace/status vocabulary.
- `LeanInfoTheory.Probability.Finite` contains reusable finite `PMF` helper
  lemmas, including real-mass facts and pointwise `PMF.map` formulas.
- `LeanInfoTheory.Shannon.Entropy` defines finite Shannon entropy in nats using
  mathlib `PMF`s and `Real.negMulLog`.
- `LeanInfoTheory.Shannon.InfoMeasures` defines finite marginal laws,
  conditional entropy, mutual information, conditional mutual information, and
  random-variable versions via `PMF.map`.
- `LeanInfoTheory.Shannon.EntropyBounds` is separately importable and contains
  the Jensen-based finite entropy upper bound and the uniform-law equality
  theorem.
- `LeanInfoTheory.Shannon.SemanticBridge` and its subfiles are the heavier
  bridge layer connecting the finite Shannon API to `PMF.toMeasure`, product
  measures, conditional laws, and `InformationTheory.klDiv`.
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
  pressure-test modules.
- `LeanInfoTheory.MathlibFragments` is a separately importable anchor/checklist
  for mathlib APIs that the project expects to use later.

## Finite Shannon Layer Status

The finite Shannon layer is PMF-based and uses real-valued entropy in nats.

Implemented and building:

- finite entropy `Shannon.entropy`;
- entropy as a finite sum of `Real.negMulLog` terms;
- entropy nonnegativity;
- deterministic-law entropy `H(delta_a) = 0`;
- entropy of random variables via pushforward laws;
- joint entropy as entropy of a joint `PMF`;
- invariance under equivalences, injective relabelings, coordinate swaps, and
  product reassociation;
- marginal laws for pairs and triples, including first-second, first-third,
  second-third, and third-coordinate projections, with pointwise mass formulas
  and domination/zero-mass helper lemmas;
- finite conditional entropy, mutual information, and conditional mutual
  information as entropy identities;
- conditional entropy chain-rule variants for joint PMFs and finite-valued
  random variables;
- mutual information symmetry and conditional mutual information symmetry
  under coordinate swaps, plus random-variable symmetry theorems
  `I(Y;X) = I(X;Y)` and `I(Y;X|Z) = I(X;Y|Z)`;
- Jensen-based bound `H(P) <= log |alpha|` for nonempty finite alphabets;
- uniform-law equality case for the entropy upper bound.

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
- absolute-continuity helpers from a joint finite law to the product of its
  marginals;
- finite log-ratio formulas for mutual information;
- mutual information as KL divergence from the joint law to the independent
  product law and to the product of marginal measures;
- finite conditional laws `P_{A | B=b}` for nonzero-marginal fibers, with
  factorization lemmas;
- conditional entropy as `sum_b P_B(b) H(P_{A | B=b})`;
- conditional mutual information as averaged fiber mutual information;
- conditional mutual information as averaged fiber KL divergence;
- semantic nonnegativity of conditional entropy, mutual information, and
  conditional mutual information;
- mutual-information chain rules:
  `I(A; B, C) = I(A; C) + I(A; B | C)` and
  `I(A; B, C) = I(A; B) + I(A; C | B)`, plus random-variable forms.
- conditioning-reduces-entropy:
  `H(A | B, C) <= H(A | C)`, plus the random-variable form.

The semantic bridge API is useful but still young. Public aliases for theorem
names should wait until more chain rules, symmetry variants, and downstream
examples reveal the most natural naming scheme.

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

## Recommended Next Lean Tasks

1. Produce a detailed Project B formalization map for finite textbook
   information-theory fundamentals, centered on Chapter 2 of Cover and Thomas
   and cross-checked against the other local textbooks.
2. Turn that map into a first focused theorem-development phase with explicit
   module boundaries, dependencies, success criteria, and build targets before
   editing Lean.
3. Start from the existing finite PMF entropy, conditional-law, information
   measure, entropy-bound, and KL bridge APIs; audit mathlib before introducing
   new definitions or parallel infrastructure.
4. Keep the finite-family entropy representation undecided until the Project B
   map and further pair/triple theorem pressure clarify what later chapters
   need.
5. Keep Project A certificate automation, richer assumptions, and external
   certificate import as later work while Project B develops the mathematical
   foundation they will eventually consume.
6. Revisit public theorem aliases, `[simp]` policy, module splitting, and
   upstream candidates only when the new theorem development supplies concrete
   pressure.

## Active 9-Step Lean Theorem Plan

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
