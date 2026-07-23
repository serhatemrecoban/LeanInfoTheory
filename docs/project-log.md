# Project Log

This log records the project history and design notes at a useful level of
detail. It is not meant to list every small command or proof attempt. It should
help a future contributor understand what has been built, why the files are
organized as they are, and which ideas are waiting for the right moment.

## Current File Organization

- `LeanInfoTheory.lean`: lightweight public library entry point. It imports
  the stable finite-Shannon definitions and core certificate/checker modules,
  but not examples, certificate demos, heavier analytic bounds, KL/coding
  anchor files, or semantic bridge modules.
- `LeanInfoTheory/Basic.lean`: small project-level definitions used by
  documentation and examples.
- `LeanInfoTheory/EntropyExpr.lean`: algebraic entropy-expression syntax for
  certificate-style reasoning, with evaluation implemented through real
  coefficient linear combinations.
- `LeanInfoTheory/EntropyVal.lean`: abstract Shannon entropy valuations used
  to state certificate-facing semantic assumptions independently of concrete
  probability models.
- `LeanInfoTheory/PrimitiveIneq.lean`: primitive Shannon inequality
  expressions and their soundness theorems under abstract valuations.
- `LeanInfoTheory/Certificate.lean`: certificate primitives, exact
  decomposition matching, and soundness scaffolding for entropy inequalities.
- `LeanInfoTheory/Certificate/Checked.lean`: raw certificates, a first
  raw-to-checked validator, and proof-carrying checked certificates for
  primitive Shannon ingredients using nonnegative rational coefficients and
  exact decomposition equality.
- `LeanInfoTheory/Certificate/Submodularity.lean`: separately importable first
  non-toy certificate demonstration, proving entropy submodularity from a
  validated conditional-mutual-information certificate.
- `LeanInfoTheory/Certificate/Subadditivity.lean`: separately importable
  checked certificate demonstration, proving entropy subadditivity through a
  two-step primitive certificate.
- `LeanInfoTheory/Certificate/Monotonicity.lean`: separately importable
  checked certificate demonstration, proving one-variable entropy monotonicity
  from the conditional-entropy primitive.
- `LeanInfoTheory/Certificate/ThreeWaySubadditivity.lean`: separately
  importable manual certificate pressure-test module for a larger
  entropy-subadditivity example.
- `LeanInfoTheory/Examples.lean`: separately importable small examples that
  exercise the current API.
- `LeanInfoTheory/InformationMeasures.lean`: compatibility/re-export module for
  the finite Shannon definitions.
- `LeanInfoTheory/MathlibFragments.lean`: heavier mathlib anchors we expect to
  connect to later, such as KL divergence, KL chain rules, binary/q-ary
  entropy, and Kraft-McMillan. This module is separately importable and should
  not be treated as part of the lightweight foundation import surface.
- `LeanInfoTheory/Probability/Finite.lean`: finite `PMF` real-mass bridge
  lemmas and reusable pointwise `PMF.map` facts, kept in the `PMF` namespace
  and deliberately small.
- `LeanInfoTheory/Shannon/Entropy.lean`: finite Shannon entropy, entropy of
  finite-valued random variables via `PMF.map`, and first entropy sanity
  theorems such as relabeling invariance.
- `LeanInfoTheory/Shannon/EntropyBounds.lean`: Jensen-based finite entropy
  upper bounds. This imports convexity/Jensen tools separately so the core
  entropy definition file remains lightweight.
- `LeanInfoTheory/Shannon/InfoMeasures.lean`: marginals, conditional entropy,
  mutual information, conditional mutual information, and basic rewrite lemmas.
- `LeanInfoTheory/Shannon/SemanticBridge.lean`: heavier bridge entry point for
  self-information, KL-divergence, finite conditional laws, averaged
  conditional-KL, semantic nonnegativity, and chain-rule theorems. It proves
  the entropy/self-information bridge over `PMF.toMeasure` and imports the
  semantic bridge subfiles.
- `LeanInfoTheory/Shannon/SemanticBridge/Product.lean`: independent-product
  PMF infrastructure, product-measure semantics, marginal recovery, support
  formulas, and joint-law absolute-continuity facts.
- `LeanInfoTheory/Shannon/SemanticBridge/FiniteSums.lean`: reusable finite
  real-sum rewrites for marginals, entropy, and the log-ratio formula
  `I(A;B) = sum p(a,b) log (p(a,b)/(p_A(a)p_B(b)))`.
- `LeanInfoTheory/Shannon/SemanticBridge/KL.lean`: finite PMF density and KL
  bridge theorems, including
  `mutualInfo_eq_toReal_klDiv_joint_indepProd` and the product-measure form
  `mutualInfo_eq_toReal_klDiv_joint_prod_marginals`. It also contains the
  averaged conditional-KL bridge for finite conditional mutual information.
- `LeanInfoTheory/Shannon/SemanticBridge/Conditional.lean`: finite
  conditional-law API. It defines `condFstGivenSnd p b hb`, the conditional
  PMF `P_{A | B=b}` on nonzero conditioning atoms, plus factorization and
  support lemmas. It also proves
  `condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd`, identifying
  finite `condEntropy` with expected entropy of the conditional fibers, and
  `condMutualInfo_eq_sum_thirdMarginal_mul_condMutualInfoFstSndGivenThird`,
  identifying finite `condMutualInfo` with expected fiber mutual information.
- `LeanInfoTheory/Shannon/SemanticBridge/Theorems.lean`: user-facing semantic
  theorem API built from the bridge layer, including nonnegativity,
  mutual-information chain-rule variants, random-variable forms, and
  conditioning-reduces-entropy.
- `LeanInfoTheory/Shannon/SemanticBridge/Independence.lean`: separately
  importable PMF and random-variable independence predicates, their mathlib
  bridge and equality characterizations, together with the positive-fiber
  zero-MI extraction, proof-independent conditional-independence predicates,
  and their positive-fiber conditional-law characterization.
- `blueprint/`: project-map notes for theorem dependencies and future
  generated blueprint pages.
- `docs/`: human-facing design notes, roadmap notes, foundation conventions,
  external review notes, and this project log.
- `home_page/`: static website files for the project site, including the
  homepage dashboard, theorem highlights, module guide, submodularity demo,
  development guide, prior-art note, roadmap, documentation landing page, and
  generated module-level blueprint/dependency pages.
- `scripts/generate_website_blueprint.py`: stdlib-only generator for the
  website module-dependency map. It parses local Lean `import` lines, computes
  the current module dependency map, and writes
  `home_page/blueprint/dep_graph_document.html` plus
  `home_page/blueprint/module_graph.json`.
- `scripts/generate_website_api_index.py`: stdlib-only generator for the
  source-derived declaration index. It scans public declaration starters and
  nearby Lean doc comments, then writes `home_page/docs/api-index.html` plus
  `home_page/docs/declaration_index.json`.
- `scripts/check_website.py`: stdlib-only static website checker. It validates
  the generated JSON files and local links under `home_page/`.
- `.github/workflows/`: CI, docs, release, and update workflows. The Lean CI
  checks that the generated module-dependency map is current, builds the
  lightweight root, and explicitly builds separately importable
  theorem/demo/reference modules.
- `tmp/`, `.lake/`, and `info theory e-books/`: local working/reference
  material that should remain outside the repository.

## Step-by-Step Summary

### 1. Initial Project Scaffold

The project was initialized as a Lake/mathlib Lean project for a future
information theory library. The repository includes standard Lean project
files, CI workflows, a license, a README, a blueprint directory, and a static
website directory.

The public positioning is deliberately mathlib-based: the project should reuse
mathlib probability, measure, coding, and special-function APIs rather than
introducing a toy local probability theory.

### 2. Website and Public Shape

The project website was built as a static site under `home_page/`, with pages
for the concept note, roadmap, docs, and blueprint. The design was influenced
by formal-verification project pages, but the content was adjusted toward an
information-theory library plus certificate pipeline rather than a single
formalized theorem.

### 3. Early Project Split

The work was organized around two related directions:

- Project A: algebraic entropy expressions and certificate checking for
  information inequalities.
- Project B: semantic finite information theory, starting from probability
  distributions, entropy, conditional entropy, mutual information, and
  conditional mutual information.

The current foundations intentionally support both directions. Algebraic
definitions are useful for certificates, while semantic bridge theorems will
connect them back to textbook and mathlib meanings.

### 4. Mathlib and Textbook Audit

The foundation layer was audited against mathlib and standard references,
including Cover-Thomas, El Gamal-Kim, Yeung, Csiszar-Korner,
Polyanskiy-Wu, and measure-theoretic probability texts. The important decisions
are recorded in `docs/foundation-conventions.md`.

The main local convention is:

- Use mathlib `PMF` for finite distributions.
- Define entropy as a finite sum of `Real.negMulLog` over real PMF masses.
- Define entropy of a random variable by pushing the PMF forward with
  `PMF.map`.
- Keep binary and q-ary entropy as mathlib names.
- Keep heavier KL/coding imports out of the lightweight finite Shannon API.

### 5. Finite Shannon Foundation Layer

The current finite Shannon layer adds:

- `entropy`
- `entropyOf`
- `jointEntropy`
- `jointEntropyOf`
- `fstMarginal`, `sndMarginal`
- triple marginal projections such as `fstThirdMarginal`,
  `sndThirdMarginal`, and `thirdMarginal`
- `condEntropy`
- `mutualInfo`
- `condMutualInfo`
- random-variable versions of these measures
- basic map/marginal rewrite lemmas

The current `condEntropy`, `mutualInfo`, and `condMutualInfo` definitions are
entropy-identity definitions. This is intentional for the entropy-expression
and certificate layer, but future semantic bridge theorems should connect them
to conditional distributions and KL divergence.

### 6. Rocq Infotheo Comparison

The Rocq `infotheo` library follows a compatible high-level architecture:
finite distributions are the primary objects, random-variable quantities are
defined through pushforward distributions, and joint laws are manipulated using
maps, marginals, swaps, reassociation maps, and projections. Our use of mathlib
`PMF`, `PMF.map`, and named marginal abbreviations is therefore aligned with
the part of Rocq's design that makes larger information-theory theorems
manageable.

The main difference is where the semantic layer enters. Rocq defines
conditional entropy through finite conditional distributions, mutual
information through KL divergence from the joint law to the product of
marginals, and conditional mutual information through conditional entropy or
averaged conditional-divergence formulas. Our current finite Shannon layer
starts from entropy identities instead. This is intentional for the
entropy-expression and certificate layer, but it should be treated as the
algebraic API, not the final semantic story.

Design consequences from the Rocq comparison that are now reflected in the
current API:

- Keep the current entropy-identity definitions as the lightweight finite API.
- Strengthen pair/triple marginals with support/domination lemmas before
  serious conditional-law proofs.
- Keep KL and conditional-law bridge work in a separated semantic bridge file.

The remaining Rocq-inspired future work is recorded in the enumerated future
work notes below.

Sources used for the comparison:

- https://github.com/affeldt-aist/infotheo
- https://github.com/affeldt-aist/infotheo/blob/master/information_theory/entropy.v
- https://github.com/affeldt-aist/infotheo/blob/master/probability/fdist.v
- https://github.com/affeldt-aist/infotheo/blob/master/probability/divergence.v
- https://github.com/affeldt-aist/infotheo/blob/master/probability/jfdist_cond.v

### 7. Marginal Formula and Support API

The pair/triple marginal layer was strengthened before adding conditional-law
or KL-divergence bridge files. The new API records finite mass formulas for
pair marginals and the three triple projections:

- first marginal mass as a finite sum over the second coordinate;
- second marginal mass as a finite sum over the first coordinate;
- first-third and second-third marginal masses as finite coordinate sums;
- third marginal mass as the double finite sum over the first two coordinates.

The same file now also contains support/domination lemmas such as
`apply_le_fstMarginal`, `apply_le_thirdMarginal`, zero-support lemmas such as
`apply_eq_zero_of_fstMarginal_eq_zero`, and nonzero-support lemmas such as
`thirdMarginal_ne_zero_of_apply_ne_zero`. These are intentionally placed in
`LeanInfoTheory/Shannon/InfoMeasures.lean` next to the marginal definitions,
then exported through `LeanInfoTheory/InformationMeasures.lean`.

The support lemmas use `[Finite ...]` assumptions where the statement itself
does not contain an explicit finite sum, following mathlib's preference for
statement-level finiteness assumptions. The mass formulas keep `[Fintype ...]`
because the finite sums appear directly in their conclusions.

### 8. Coordinate Orientation API

The finite Shannon layer now has a small coordinate-orientation API. For pair
laws, `fstMarginal_map_swap` and `sndMarginal_map_swap` describe how marginals
behave after swapping the two coordinates. For right-associated triple laws,
`fstThirdMarginal_map_swap12`, `sndThirdMarginal_map_swap12`, and
`thirdMarginal_map_swap12` describe the effect of swapping the first two
coordinates while keeping the conditioning coordinate fixed.

Projection identities were also added for the random-variable APIs. For
example, `condEntropyOf_fst_snd` and `mutualInfoOf_fst_snd` say that applying
the random-variable versions to the coordinate projections of a joint PMF
recovers the corresponding joint-PMF measure. The triple identity
`condMutualInfoOf_fst_snd_third` records the intended orientation of
`I(first; second | third)` for Lean's right-associated product
`alpha × beta × gamma`.

These lemmas are exported through `LeanInfoTheory/InformationMeasures.lean`.
They are deliberately not marked as global simp lemmas yet; we can promote the
most useful ones later after more theorem pressure clarifies which rewrites are
safe and ergonomic.

### 9. Semantic Bridge Import Boundary

The KL/conditional-law bridge layer was separated from the lightweight finite
Shannon API. The `LeanInfoTheory/Shannon/SemanticBridge.lean` entry point and
its subfiles import heavier measure-theoretic tools only when bridge theorems
need them. The layer now contains the entropy/self-information bridge,
independent-product PMF infrastructure, finite log-ratio sum formulas, and the
first mutual-information-as-KL theorem.

The root `LeanInfoTheory.lean` no longer imports `LeanInfoTheory.MathlibFragments`.
This keeps ordinary project imports focused on the finite Shannon and
certificate-facing foundations. Heavy anchors such as KL divergence,
Kraft-McMillan, kernels, and conditional probability remain available through
separately importable files when we work on the semantic bridge or coding
theory layers.

The later semantic bridge steps completed the expected conditional-entropy
formula, averaged conditional-KL formula, and explicit zero-mass conditioning
convention. The next semantic bridge work should therefore focus on API polish
and broader theorem coverage rather than re-opening the import-boundary
decision.

### 10. Visible CI and Placeholder Policy

The Lean CI workflow now has an explicit no-placeholder check before the Lean
build. It scans Lean source files for `sorry`, `admit`, `opaque`, `undefined`,
and unapproved `axiom` declarations, then runs `leanprover/lean-action`.

The README and project homepage show workflow badges for the Lean build and the
GitHub Pages deployment. This makes the current build and deployment status
visible to readers without requiring them to inspect the Actions tab manually.

### 11. Public Status and Limitation Wording

The website was tightened to distinguish implemented code from planned work.
The homepage now separates implemented foundations from planned milestones such
as semantic bridge theorems, checked certificates, generated API documentation,
and network-converse examples.

The module-list page explicitly says that it is not generated declaration
documentation yet. The concept note and blueprint describe the certificate
layer as an evolving proof-carrying foundation. At this stage, semantic
bridges, deterministic raw-to-checked validation, generated API documentation,
and network-information-theory examples were still future work.

### 12. Empty Entropy Atom Convention

The entropy-expression layer now names the empty entropy atom through
`EntropyAtom.empty` and the formal expression `EntropyExpr.empty`. Arbitrary
semantic interpretations of entropy atoms are not forced to assign this atom
the value zero. Instead, `EntropyExpr.RespectsEmpty` records the convention
`H(empty) = 0` as an explicit assumption.

This keeps the current algebraic layer honest while preparing for the next
step: an abstract entropy-valuation structure that will include empty entropy,
conditional entropy nonnegativity, and conditional mutual information
nonnegativity as bundled assumptions. A small example theorem records that
`EntropyExpr.empty` evaluates to zero under any interpretation satisfying
`RespectsEmpty`.

### 13. Abstract Shannon Entropy Valuations

The new file `LeanInfoTheory/EntropyVal.lean` defines `ShannonEntropyVal`.
This structure assigns a real value to each entropy atom and records the
certificate-facing Shannon assumptions:

- empty entropy: `H(empty) = 0`;
- conditional entropy nonnegativity for adjoining one variable;
- conditional mutual information nonnegativity in the form
  `H(A,C) + H(B,C) - H(A,B,C) - H(C) >= 0`.

The structure is intentionally abstract. It lets the certificate layer prove
Shannon-type inequalities without waiting for all finite-`PMF` semantic bridge
theorems. Later, the concrete finite-family entropy semantics should prove that
actual finite random variables instantiate `ShannonEntropyVal`.

### 14. Primitive Shannon Inequality Expressions

The new file `LeanInfoTheory/PrimitiveIneq.lean` defines the first primitive
Shannon inequality expressions as formal entropy expressions:

- `PrimitiveIneq.emptyEntropy`, representing `H(empty)`;
- `PrimitiveIneq.condEntropy`, representing `H(S ∪ {i}) - H(S)`;
- `PrimitiveIneq.condMutualInfo`, representing
  `H(A,C) + H(B,C) - H(A,B,C) - H(C)`.

The file also includes evaluation formulas for these expressions under an
arbitrary atom interpretation. At this stage, the primitive expressions had not
yet been proved nonnegative under `ShannonEntropyVal`; that became the next
certificate-facing step.

### 15. Primitive Inequality Soundness

The primitive Shannon inequality layer now proves that its expressions are
sound under the abstract valuation semantics:

- `PrimitiveIneq.emptyEntropy_nonneg` uses the bundled empty-entropy
  convention, so `H(empty)` evaluates to zero and hence is nonnegative;
- `PrimitiveIneq.condEntropy_nonneg` turns the `ShannonEntropyVal.cond_nonneg`
  field into nonnegativity of the formal expression `H(S union {i}) - H(S)`;
- `PrimitiveIneq.condMutualInfo_nonneg` turns the
  `ShannonEntropyVal.cmi_nonneg` field into nonnegativity of the formal
  conditional-mutual-information expression.

The same file also provides `ShannonEntropyVal.eval` simp lemmas for the three
primitive expressions. These lemmas keep future checked-certificate proofs
close to the algebraic entropy notation while still making all semantic
assumptions explicit in `ShannonEntropyVal`.

This completes the earlier future-work item about proving primitive inequality
soundness. The next certificate-facing pressure points are checked
certificates, exact expression equality, and a first non-toy demonstration.

### 16. Raw and Checked Certificate Architecture

The new file `LeanInfoTheory/Certificate/Checked.lean` separates untrusted
external-style certificate data from certificates that Lean can use for a
soundness proof.

The raw side contains:

- `Certificate.RawStep`, with an unchecked rational coefficient and unchecked
  entropy expression;
- `Certificate.RawCert`, with an unchecked target and unchecked list of raw
  steps.

The checked side contains:

- `PrimitiveIneq.Kind`, a typed basis of primitive Shannon inequalities;
- `Certificate.CheckedStep`, whose coefficient was represented by a rational
  number plus a nonnegativity proof and whose ingredient is a
  `PrimitiveIneq.Kind`;
- `Certificate.CheckedCert`, whose decomposition equality is represented by a
  proof field;
- `Certificate.CheckedCert.sound`, proving that every checked certificate is
  sound under any abstract Shannon entropy valuation.

This was intentionally proof-carrying rather than a full executable checker.
The next certificate-layer step was to make the decomposition equality an exact
rational entropy-expression equality rather than a semantic equality over all
valuations.

### 17. Exact Decomposition Equality

The certificate layer now compares certificate decompositions as exact formal
entropy expressions.

The generic certificate file `LeanInfoTheory/Certificate.lean` adds:

- `Certificate.combinationExpr`, the formal rational expression
  `sum_i q_i • e_i` associated to a weighted decomposition;
- `Certificate.eval_combinationExpr`, proving that evaluating this formal
  expression agrees with the older semantic `evalCombination`;
- `Certificate.DecompositionMatches`, the exact equality predicate
  `target = combinationExpr decomposition`;
- `Certificate.sound_of_decompositionMatches`, deriving certificate soundness
  from exact formal equality plus nonnegativity of the checked ingredients.

The checked certificate file now stores
`Certificate.CheckedCert.decomposition_matches` as a `DecompositionMatches`
proof. Since entropy expressions are `Finsupp`s over `Rat`, this equality is an
atom-by-atom comparison of normalized sparse rational coefficients.

The entropy-expression evaluation API was also adjusted so rational
coefficients are first cast into a sparse real-coefficient expression and then
evaluated using `Finsupp.linearCombination Real`. This makes the linearity
lemmas for evaluation reflect the free-module structure of entropy
expressions, while avoiding any unnecessary assumption that `Real` is imported
as a `Rat`-module in this project.

This completes the future-work item about deterministic expression equality
for certificate decompositions. The next step was raw-to-checked validation:
turning parsed external-style certificate data into checked primitive
ingredients, nonnegative coefficients, and exact decomposition-equality proofs.

### 18. Nonnegative Checked Coefficients

Checked certificate steps now store coefficients as `NNRat`, the mathlib type
of nonnegative rational numbers. This removes the separate nonnegativity proof
field from `Certificate.CheckedStep`:

- raw parsed data still uses ordinary `Rat` coefficients, because external
  certificate input may be invalid;
- checked data uses `NNRat`, so coefficient nonnegativity is part of the type;
- `Certificate.CheckedStep.toWeightedIneq` forgets a checked step back to the
  generic rational `WeightedIneq` format by coercing `NNRat` to `Rat`;
- `Certificate.CheckedStep.coeff_rat_nonneg` and
  `Certificate.CheckedStep.coeff_real_nonneg` recover the rational and real
  nonnegativity facts needed by soundness proofs.

This completes the future-work item about using nonnegative coefficient types
inside checked certificates. It also prepares the raw-to-checked validator by
making coefficient validation a coercion from raw `Rat` input into checked
`NNRat` data.

### 19. Raw-to-Checked Validation

The checked certificate layer now contains the first deterministic validator
from external-style raw certificate data into proof-carrying checked
certificates.

The new validation API is:

- `Certificate.RawStep.toCheckedStep?`, which checks that a raw rational
  coefficient is nonnegative and that the raw expression matches the proposed
  `PrimitiveIneq.Kind`;
- `Certificate.checkStepsAgainstPrimitives?`, which validates a raw step list
  against a parallel list of primitive tags;
- `Certificate.RawCert.toCheckedCert?`, which validates all steps and then
  checks exact rational equality between the raw target and the checked
  decomposition;
- `Certificate.RawCert.sound_of_toCheckedCert?_eq_some`, which proves the raw
  target nonnegative whenever validation succeeds.

`LeanInfoTheory/Examples.lean` now includes a raw one-step primitive
conditional-mutual-information certificate, a proof that it validates against
its primitive tag, and a soundness theorem routed through the validator.

This completes the previous near-term future-work item about raw-to-checked
validation. At that point, the next certificate-layer task was to choose a
first non-toy certificate demonstration and let that example guide any
additional API refinement.

### 20. Entropy Submodularity Certificate Demo

The first non-toy certificate demonstration now lives in
`LeanInfoTheory/Certificate/Submodularity.lean`.

It proves the recognizable Shannon submodularity inequality

`H(A) + H(B) - H(A union B) - H(A inter B) >= 0`

for every abstract `ShannonEntropyVal` and arbitrary entropy atoms `A` and `B`.
The proof uses the identity

`H(A) + H(B) - H(A union B) - H(A inter B) =
  I(A \ B ; B \ A | A inter B)`,

then validates a one-step raw certificate against the corresponding
conditional-mutual-information primitive.

The new module includes:

- `Certificate.Submodularity.expr`, the formal submodularity expression;
- `Certificate.Submodularity.expr_eq_condMutualInfo`, the finite-set identity
  reducing submodularity to a primitive CMI expression;
- `Certificate.Submodularity.checkedCert`, a proof-carrying checked
  certificate;
- `Certificate.Submodularity.rawCert`, the corresponding raw external-style
  certificate;
- `Certificate.Submodularity.rawCert_toCheckedCert?_isSome`, proving the raw
  certificate validates;
- `Certificate.Submodularity.entropy_submodularity`, the user-facing
  nonnegativity theorem.

This completes the previous future-work item asking for a first serious
certificate demo. The demo is intentionally primitive-only: independence,
functional-dependence, and Markov constraints should be added later as
extensions rather than mixed into the first certificate milestone.

### Certificate and Validation

This note records the intended meaning of "certificate", "certificate checker",
and "validation" in the project. The terminology is useful but can be
misleading at first, because the checker is not searching for a proof in the
same way a human or an automated theorem prover might.

A certificate is proof data: a proposed algebraic explanation of why an
entropy expression is nonnegative. In the current primitive Shannon layer, a
certificate says that a target expression is equal to a nonnegative rational
combination of primitive Shannon inequalities. The current primitive
ingredients include:

- the empty entropy convention, `H(empty) = 0`;
- conditional entropy nonnegativity, written informally as `H(X | Y) >= 0`;
- conditional mutual information nonnegativity, written as
  `I(X;Y | Z) >= 0`.

Here CMI means conditional mutual information. Algebraically,

`I(X;Y | Z) = H(X union Z) + H(Y union Z) -
  H(X union Y union Z) - H(Z)`.

For example, the submodularity certificate for two entropy atoms `A` and `B`
is the one-step certificate

`H(A) + H(B) - H(A union B) - H(A inter B)
  = 1 * I(A \ B ; B \ A | A inter B)`.

Since the coefficient `1` is nonnegative and CMI is a primitive nonnegative
ingredient, this certificate proves

`H(A) + H(B) - H(A union B) - H(A inter B) >= 0`.

The certificate checker is the small trusted Lean-side mechanism that checks
whether such proof data is legitimate. Conceptually, it performs the following
steps:

1. Check that each raw coefficient is nonnegative, turning it into a checked
   nonnegative rational coefficient.
2. Check that each proposed raw step really matches the primitive inequality
   tag supplied for it, for example that a step tagged as CMI is exactly the
   formal expression for some `I(X;Y | Z)`.
3. Form the rational linear combination of all checked primitive steps.
4. Check that this computed combination is exactly equal to the target entropy
   expression.
5. If all checks succeed, produce a checked certificate whose soundness theorem
   proves that the target expression is nonnegative under any
   `ShannonEntropyVal`.

The most important design point is that step 4 is not a lookup for a
pre-existing named theorem. The checker does not need a theorem specifically
named, say, "submodularity identity". Instead, entropy expressions are stored
as normalized sparse rational linear combinations of entropy atoms. Informally,

`H(A) + H(B) - H(A union B)`

is stored like a coefficient table:

`A -> 1`, `B -> 1`, `A union B -> -1`.

Two entropy expressions are equal when these normalized coefficient tables are
the same. Thus, for the submodularity certificate, the checker expands

`I(A \ B ; B \ A | A inter B)`

to

`H((A \ B) union (A inter B))
 + H((B \ A) union (A inter B))
 - H((A \ B) union (B \ A) union (A inter B))
 - H(A inter B)`,

and the finite-set expressions simplify to

`H(A) + H(B) - H(A union B) - H(A inter B)`.

That is why the certificate validates. The validation succeeds because the
computed normalized expression is exactly the target, not because Lean already
had a separate theorem saying this particular identity is true.

The same principle applies to larger certificates. If a four-variable
certificate claims, for example, that some target expression is

`2 * I(A;B | C) + 3 * I(A;D | B union C) +
  (1 / 2) * H(D | A union B)`,

then the checker can validate it provided that all coefficients are
nonnegative, every step matches one of the currently supported primitive
inequality forms, and the expanded normalized combination is exactly the
target expression. No separate theorem for that exact four-variable identity is
needed.

There are also clear current limits. The checker is not yet a certificate
search engine: it does not invent the decomposition. It also does not yet use
extra assumptions such as independence, Markov constraints, or functional
dependence. For example, it cannot currently use assumptions like
`I(A;B) = 0` or `H(Y | X) = 0` unless those assumptions are added to the
certificate framework as supported rules. The current checker validates
primitive Shannon-style entropy inequality certificates by exact normalized
entropy-expression equality.

### 21. Finite Entropy Relabeling Sanity Theorems

The finite Shannon entropy layer now proves that entropy is invariant under
renaming finite alphabets.

The new API in `LeanInfoTheory/Shannon/Entropy.lean` includes:

- `Shannon.entropy_map_equiv`, showing that pushing a finite `PMF` forward
  along an equivalence preserves entropy;
- `Shannon.entropy_map_injective`, showing that an injective relabeling into a
  larger finite alphabet preserves entropy, with atoms outside the image
  contributing zero mass;
- `Shannon.entropyOf_comp_equiv` and
  `Shannon.entropyOf_comp_injective`, the corresponding random-variable
  relabeling theorems;
- `Shannon.entropy_map_swap`, `Shannon.jointEntropy_map_swap`, and
  `Shannon.jointEntropyOf_swap`, recording the basic pair-coordinate swap
  invariance expected by information theorists.

This completes the relabeling-invariance part of the core finite entropy
sanity work. The remaining finite entropy sanity targets are upper bounds by
the logarithm of alphabet size and the uniform-law equality case; those should
use mathlib's concavity/Jensen tools rather than ad hoc calculations.

### 22. Immediate-Layer Repository Checkpoint

After completing the immediate nine-step certificate and finite-entropy
foundation pass, the project is ready for a repository checkpoint before
starting harder theorem work.

This checkpoint includes:

- primitive Shannon inequality expressions and soundness;
- raw and checked certificate structures;
- exact rational decomposition matching;
- nonnegative checked coefficients through `NNRat`;
- raw-to-checked validation;
- the entropy submodularity certificate demo;
- finite entropy relabeling invariance under equivalences, injective maps, and
  coordinate swaps;
- updated README, project log, roadmap, and website status pages.

The next mathematical step should continue from the remaining finite entropy
sanity theorem backlog rather than reopening the completed immediate
certificate layer.

### 23. Product Reassociation Entropy Invariance

The finite Shannon entropy API now records that entropy is invariant under the
canonical reassociation equivalence between `(alpha × beta) × gamma` and
`alpha × beta × gamma`.

The new theorem layer includes:

- `Shannon.entropy_map_prodAssoc`, for reassociating a left-associated triple
  alphabet to Lean's right-associated triple product;
- `Shannon.entropy_map_prodAssoc_symm`, for the reverse orientation;
- `Shannon.entropyOf_prodAssoc`, for finite-valued random variables
  `(X, Y, Z)`.

These are intentionally proved from the existing relabeling-invariance theorem
`Shannon.entropy_map_equiv`, so the API keeps one proof principle: entropy is
unchanged by bijective renaming of finite atoms. This completes the live
future-work item about product reassociation. The remaining finite-entropy
sanity backlog is now the harder textbook-style upper bound by logarithm of
alphabet size and its uniform-law equality case.

### 24. Finite Entropy Upper Bound And Uniform Equality

The new file `LeanInfoTheory/Shannon/EntropyBounds.lean` proves the first
textbook-style finite entropy bound and its basic equality example:

- `Shannon.entropy_le_log_card`: for a nonempty finite alphabet, the entropy of
  any `PMF alpha` is at most `Real.log (Fintype.card alpha)`;
- `Shannon.entropy_uniformOfFintype`: the uniform distribution on a nonempty
  finite alphabet has entropy exactly `Real.log (Fintype.card alpha)`.

The proof uses mathlib's `Real.concaveOn_negMulLog` together with finite
Jensen's inequality, rather than duplicating calculus inside this project. The
theorem lives in a separate bounds module because importing Jensen is
noticeably heavier than the core entropy definition and relabeling API. This
keeps the base `LeanInfoTheory/Shannon/Entropy.lean` file focused on definitions
and cheap sanity theorems, while still giving theorem work an explicit place
for analytic finite-entropy bounds.

The equality theorem uses mathlib's `PMF.uniformOfFintype` API. Together, these
theorems complete the finite entropy sanity mini-milestone covering alphabet
relabeling/reassociation, the textbook upper bound by alphabet size, and the
uniform-law equality example.

### 25. Lean Code Commentary Convention

We made the Lean source commentary convention explicit: public definitions,
theorems, structures, inductive types, and instances should have short
human-readable docstrings explaining the mathematical meaning, even when the
Lean name is already suggestive. Private helper lemmas should also be commented
when their role is not obvious from the statement alone.

This pass added missing explanations for:

- PMF map helper lemmas that were then private and used in entropy relabeling
  invariance;
- private finite-set identities used to turn entropy submodularity into a
  conditional-mutual-information primitive;
- the coercion from `ShannonEntropyVal` to its underlying atom-value function;
- the `entropyOf_id` identity;
- the main steps inside the Jensen proof of the finite entropy upper bound.

The goal is not verbose prose inside every proof, but enough mathematical
orientation that future contributors can read theorem files as a formalized
textbook development rather than as isolated Lean terms.

### 26. Public Website Status Refresh

The website and public-facing documentation were refreshed after the finite
entropy upper-bound milestone. The homepage now has a status snapshot table
that separates the finite Shannon foundation, entropy sanity theorems,
certificate core, first certificate demo, and semantic bridge boundary. The
implemented list now mentions coordinate swaps, product reassociation, the
finite entropy upper bound, and the uniform-law equality theorem, while the
planned list no longer treats the entropy upper bound as future work.

The module-list page now includes `LeanInfoTheory.Shannon.EntropyBounds`, and
the blueprint/dependency-map pages record the heavier Jensen-based bounds
module separately from the lightweight entropy definition module. The roadmap
was also adjusted so the immediate mathematical direction is now semantic
bridge work: expected self-information, conditional laws, and KL-equivalence
theorems.

This completes the public-facing website polish item that was waiting for the
finite entropy sanity milestone. Full Lean doc-gen output, richer
collaboration material, and network-converse demos remain later milestones.

### 27. Public PMF Map Helper Lemmas

The private pointwise `PMF.map` helper lemmas used by entropy relabeling
invariance were reviewed against mathlib's current `PMF` API. Mathlib already
provides the general pushed-forward mass formula `PMF.map_apply`, support facts
such as `PMF.support_map`, and the measure bridge
`PMF.toOuterMeasure_map_apply`, but it does not provide the exact pointwise
injective-map facts we use repeatedly.

We promoted the reusable facts to `LeanInfoTheory/Probability/Finite.lean`
inside the `PMF` namespace:

- `PMF.map_apply_of_injective`: if `f` is injective, then
  `(p.map f) (f a) = p a`;
- `PMF.map_apply_eq_zero_of_notMem_range`: atoms outside the range of a map
  have zero mass under the pushed-forward PMF;
- `PMF.map_apply_equiv`: pushing a PMF forward along an equivalence preserves
  each atom's mass at the renamed atom.

The entropy relabeling proofs now depend on these public helper lemmas instead
of carrying private duplicates. This keeps the entropy file focused on entropy
arguments and gives future support, conditioning, marginal, and semantic bridge
proofs a stable place to reuse pointwise PMF-map facts.

### 28. Namespace and Root Import Policy

The namespace and import-surface policy is now explicit.

For finite information measures, `LeanInfoTheory.Shannon` is the canonical
implementation namespace. The `LeanInfoTheory.InformationMeasures` module still
exports the main finite-measure names into `LeanInfoTheory` for convenience,
but theorem-oriented code and documentation should prefer `Shannon.*` names
when that makes the source layer clearer.

The root module `LeanInfoTheory.lean` is now a lightweight library entry point:
it imports the stable finite-measure API and the core certificate/checker
definitions, but it no longer imports `LeanInfoTheory.Certificate.Submodularity`
or `LeanInfoTheory.Examples`. It also continues to leave
`LeanInfoTheory.Shannon.EntropyBounds`, `LeanInfoTheory.Shannon.SemanticBridge`,
and `LeanInfoTheory.MathlibFragments` as explicit imports. This keeps demo
files, heavier analytic theorem files, KL bridge files, and reference-anchor
files out of ordinary user imports.

To avoid losing coverage, the Lean CI now explicitly builds the separately
importable modules:

- `LeanInfoTheory.Shannon.EntropyBounds`;
- `LeanInfoTheory.Shannon.SemanticBridge`;
- `LeanInfoTheory.MathlibFragments`;
- `LeanInfoTheory.Certificate.Submodularity`;
- `LeanInfoTheory.Examples`.

Certificate-demo theorems also remain in descriptive namespaces such as
`Certificate.Submodularity.entropy_submodularity`. We will add polished public
aliases only after enough theorem examples exist to justify an alias layer.

### 29. Entropy Self-Information Semantic Bridge

The semantic bridge layer now contains the first theorem connecting the local
finite-sum entropy definition to textbook measure-theoretic semantics.

The new API in `LeanInfoTheory/Shannon/SemanticBridge.lean` includes:

- `Shannon.selfInfo`, the self-information of an atom under a `PMF`, defined as
  `-log p(a)` on nonzero real mass and `0` on zero-mass atoms;
- `Shannon.selfInfo_of_toReal_eq_zero` and
  `Shannon.selfInfo_of_toReal_ne_zero`, recording the two branches of the
  definition;
- `Shannon.toReal_mul_selfInfo`, proving that mass times self-information is
  exactly the `Real.negMulLog` entropy summand;
- `Shannon.entropy_eq_integral_selfInfo`, proving
  `entropy p = ∫ a, selfInfo p a ∂p.toMeasure` for finite alphabets with
  measurable singletons.

This is the textbook identity `H(P) = E[-log P(X)]`, formalized with the
zero-mass convention made explicit. It gives the project its first completed
semantic bridge theorem and sets the pattern for later bridges: use the
finite-sum API in core files, then prove equivalence to the
measure-theoretic/mathlib semantics in separately importable bridge files.

### 30. Semantic Bridge API Audit

The first near-term semantic bridge step is complete. We audited the relevant
mathlib APIs and two external Lean reference projects before choosing the
shape of the next semantic bridge definitions and lemmas.

The detailed audit is recorded in `docs/semantic-bridge-api-audit.md`. The
main conclusion is that the finite Shannon layer should remain PMF-first and
lightweight, while semantic equivalence theorems should reuse mathlib's
measure, kernel, conditional distribution, product measure, and KL-divergence
APIs in heavier bridge files.

Important findings:

- mathlib already provides the right `PMF.map`, `PMF.bind`, `PMF.toMeasure`,
  finite-integral, product-measure, kernel, conditional-distribution, and
  `InformationTheory.klDiv` infrastructure;
- the pinned mathlib version does not appear to expose a canonical finite
  `PMF.prod`, so we should add a small local independent-product helper before
  proving the mutual-information-as-KL theorem;
- mathlib's event conditioning returns the zero measure on zero-probability
  conditioning events, so any finite conditional-law API must state its
  zero-mass convention explicitly;
- PFR confirms that measure/kernel semantics are a strong long-term direction,
  while still leaving room for our lightweight PMF-first finite API;
- the divergence-project audit confirms that averaged conditional KL is
  important later, but the next mutual-information bridge should use mathlib's
  existing `InformationTheory.klDiv` directly.

This completes step 1 of the near-term semantic bridge plan. Step 2 is to
write the semantic-bridge design note before implementing the product-law and
KL bridge infrastructure.

### 31. Semantic Bridge Design Note

The second near-term semantic bridge step is complete. We wrote
`docs/semantic-bridge-design.md`, turning the API audit into concrete design
choices for the next implementation phase.

Main design decisions:

- the independent product of finite PMFs should be introduced as the
  project-local helper `Shannon.indepProd`, not as `PMF.prod`, so the name is
  explicit and will not fight a future mathlib product construction;
- the first main KL bridge should state finite mutual information as the
  `toReal` of mathlib's `InformationTheory.klDiv` from the joint law to the
  independent product of its marginals;
- a second theorem should rewrite the independent product law as
  `MeasureTheory.Measure.prod` of the marginal measures;
- the finite conditional-law API should avoid arbitrary default PMFs on
  zero-probability conditioning atoms by requiring a nonzero marginal proof for
  pointwise conditional PMFs;
- total expected-conditional-entropy expressions may branch over all
  conditioning atoms, but the zero-mass branch should be the number `0`, not
  the entropy of a fake default conditional law;
- semantic bridge imports should stay out of the lightweight finite Shannon
  files, with optional future subfiles under
  `LeanInfoTheory/Shannon/SemanticBridge/` if theorem pressure justifies the
  split.

This completes step 2 of the near-term semantic bridge plan. Step 3 is to add
the product-law, product-measure, support, absolute-continuity, and
finite-sum/integral helper layer needed for the KL bridge.

### 32. Semantic Bridge Product Infrastructure

The third near-term semantic bridge step is complete. We added
`LeanInfoTheory/Shannon/SemanticBridge/Product.lean` and imported it from the
main `LeanInfoTheory.Shannon.SemanticBridge` entry point.

The new product infrastructure includes:

- `Shannon.indepProd`, the independent product law of two PMFs, implemented via
  mathlib's `PMF.bind` and `PMF.map`;
- `Shannon.indepProd_apply`, proving that the atom mass of `(a, b)` is
  `p a * q b`;
- zero/nonzero atom lemmas and `Shannon.support_indepProd`, recording that the
  support of the independent product is the product of the supports;
- `Shannon.fstMarginal_indepProd` and `Shannon.sndMarginal_indepProd`, proving
  that the marginals of the independent product recover the original laws;
- `Shannon.indepProd_map_swap`, proving that swapping the coordinates of an
  independent product swaps the two factor laws;
- `Shannon.indepProd_toMeasure_prod`, the rectangle formula for the associated
  measure of the independent product;
- `Shannon.indepProd_toMeasure`, proving that the measure associated to
  `indepProd p q` is `MeasureTheory.Measure.prod p.toMeasure q.toMeasure`;
- `Shannon.joint_toMeasure_absolutelyContinuous_indepProd_marginals`, proving
  that a finite joint law is absolutely continuous with respect to the
  independent product of its marginals;
- `Shannon.joint_toMeasure_absolutelyContinuous_prod_marginals`, the same
  absolute-continuity fact stated directly against
  `MeasureTheory.Measure.prod` of the marginal measures.

This gives the next KL bridge theorem the main structural facts it needs:
pointwise product masses, product-measure semantics, marginal recovery, support
control, and the absolute-continuity fact needed before taking KL divergence
from a joint law to the product of its marginals.

We did not add a general finite KL expansion helper in this step. The design
note already says to add that helper only if the mutual-information proof
actually needs it, so the exact theorem statement should be chosen during step
4 rather than guessed now.

This completes step 3 of the near-term semantic bridge plan. Step 4 is to prove
that finite `mutualInfo` agrees with mathlib KL divergence from the joint law
to the product of its marginals.

### 33. Mutual Information as KL Divergence

The fourth near-term semantic bridge step is complete. We proved the finite
textbook identity

`I(A;B) = D(P_AB || P_A × P_B)`

for the project's finite PMF mutual information and mathlib's
measure-theoretic `InformationTheory.klDiv`.

The implementation was split into two semantic bridge subfiles:

- `LeanInfoTheory/Shannon/SemanticBridge/FiniteSums.lean` contains reusable
  finite real-sum identities. The most important formulas are:
  `(fstMarginal p a).toReal = sum_b (p (a,b)).toReal`,
  `(sndMarginal p b).toReal = sum_a (p (a,b)).toReal`,
  `sum_{a,b} p(a,b) f(a) = sum_a p_A(a) f(a)`,
  `sum_{a,b} p(a,b) g(b) = sum_b p_B(b) g(b)`, and
  `I(A;B) = sum_{a,b} p(a,b) log (p(a,b)/(p_A(a) p_B(b)))`.
- `LeanInfoTheory/Shannon/SemanticBridge/KL.lean` contains the KL bridge. It
  first proves the countable PMF density formula
  `Q.withDensity (fun a => P(a)/Q(a)) = P` under `P ≪ Q`, then the finite KL
  expansion
  `D(P || Q) = sum_a P(a) log (P(a)/Q(a))`, and finally the mutual-information
  bridge against the independent product of marginals.

The main new theorems are:

- `Shannon.toMeasure_withDensity_pmf_div`: if `p.toMeasure ≪ q.toMeasure`,
  then `q.toMeasure.withDensity (fun a => p a / q a) = p.toMeasure`;
- `Shannon.toReal_klDiv_pmf_eq_sum`: if `p.toMeasure ≪ q.toMeasure`, then
  `(InformationTheory.klDiv p.toMeasure q.toMeasure).toReal =
   sum_a (p a).toReal * log ((p a / q a).toReal)`;
- `Shannon.mutualInfo_eq_sum_log_ratio`:
  `mutualInfo p =
   sum_{a,b} p(a,b) log (p(a,b)/(p_A(a)p_B(b)))`;
- `Shannon.mutualInfo_eq_toReal_klDiv_joint_indepProd`:
  `mutualInfo p =
   (InformationTheory.klDiv p.toMeasure
     (indepProd (fstMarginal p) (sndMarginal p)).toMeasure).toReal`;
- `Shannon.mutualInfo_eq_toReal_klDiv_joint_prod_marginals`, the same theorem
  stated with mathlib's product measure
  `Measure.prod (fstMarginal p).toMeasure (sndMarginal p).toMeasure`.

This completes step 4 of the near-term semantic bridge plan. Step 5 is to
refine and implement the finite conditional-law API using the zero-mass
convention recorded in `docs/semantic-bridge-design.md`.

### 34. Finite Conditional-Law API

The fifth near-term semantic bridge step is complete. We added
`LeanInfoTheory/Shannon/SemanticBridge/Conditional.lean`, implementing the
first finite conditional-law API without assigning arbitrary PMFs to zero-mass
conditioning atoms.

For a joint law `p : PMF (alpha × beta)`, the project convention remains that
`condEntropy p` means `H(alpha | beta)`. The new conditional PMF is therefore

`condFstGivenSnd p b hb : PMF alpha`,

where `hb : sndMarginal p b ≠ 0`. Mathematically,

`condFstGivenSnd p b hb a = p(a,b) / p_B(b)`.

The proof argument is intentional: when `p_B(b)=0`, there is no canonical
finite conditional PMF `P_{A | B=b}`. This matches the design note and avoids
the Rocq-style default-distribution choice at the finite-PMF API level.

The main new facts are:

- `Shannon.condFstGivenSnd_apply`:
  `P_{A | B=b}(a) = p(a,b) / p_B(b)`;
- `Shannon.condFstGivenSnd_proof_irrel`: the conditional PMF does not depend
  on which proof of `p_B(b) ≠ 0` is passed;
- `Shannon.condFstGivenSnd_apply_eq_zero_iff` and
  `Shannon.condFstGivenSnd_apply_ne_zero_iff`: conditional support is exactly
  the joint support fiber over `b`;
- `Shannon.support_condFstGivenSnd`:
  `support(P_{A | B=b}) = {a | p(a,b) ≠ 0}`;
- `Shannon.sndMarginal_mul_condFstGivenSnd`:
  `p_B(b) * P_{A | B=b}(a) = p(a,b)`;
- `Shannon.sndMarginal_toReal_mul_condFstGivenSnd_toReal`, the same
  factorization after converting masses to real numbers;
- `Shannon.condEntropyFstGivenSnd`, the zero-branch helper for expected
  conditional entropy formulas. It is `0` when `p_B(b)=0`, and otherwise
  `entropy (condFstGivenSnd p b hb)`.

This completes step 5 of the near-term semantic bridge plan. Step 6 is to
prove that finite `condEntropy p = H(A,B) - H(B)` agrees with the expected
entropy of these conditional laws:

`condEntropy p = sum_b p_B(b) * H(P_{A | B=b})`,

with the zero branch handled by `condEntropyFstGivenSnd`.

### 35. Conditional Entropy as Expected Fiber Entropy

The sixth near-term semantic bridge step is complete. We proved that the
entropy-identity definition of finite conditional entropy agrees with the
expected entropy of the finite conditional laws introduced in step 5.

The main theorem is:

- `Shannon.condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd`:
  `condEntropy p =
   sum_b (sndMarginal p b).toReal * condEntropyFstGivenSnd p b`.

Mathematically, this is the textbook identity

`H(A | B) = sum_b P_B(b) H(P_{A | B=b})`.

The proof uses the per-fiber identity

`P_B(b) H(P_{A | B=b})
  = sum_a h(P_AB(a,b)) - h(P_B(b))`,

where `h(x) = -x log x`. On zero-marginal fibers, the left side is zero by
the explicit zero branch of `condEntropyFstGivenSnd`, and the right side is
zero because `P_B(b)=0` forces every joint atom `P_AB(a,b)` to be zero. On
nonzero fibers, the proof uses the factorization
`P_B(b) * P_{A | B=b}(a) = P_AB(a,b)` and mathlib's
`Real.negMulLog_mul`.

This completes step 6 of the near-term semantic bridge plan. Step 7 is to
prove that finite `condMutualInfo` agrees with either a KL chain-rule
expression or an averaged conditional-KL expression.

### 36. Conditional Mutual Information as Averaged Fiber KL

The seventh near-term semantic bridge step is complete. We proved finite
conditional mutual information as an average over conditional fibers, and then
connected each nonzero fiber to mathlib KL divergence.

The new conditional-fiber API in
`LeanInfoTheory/Shannon/SemanticBridge/Conditional.lean` includes:

- `Shannon.pairThirdLaw`, viewing a right-associated law `P_{A,B,C}` as a law
  on `((A,B),C)`;
- `Shannon.condFstSndGivenThird p c hc`, the conditional joint law
  `P_{A,B | C=c}` for `hc : P_C(c) ≠ 0`;
- marginal recovery theorems:
  `fstMarginal (P_{A,B | C=c}) = P_{A | C=c}` and
  `sndMarginal (P_{A,B | C=c}) = P_{B | C=c}`;
- `Shannon.condMutualInfoFstSndGivenThird`, the fiber value that is zero when
  `P_C(c)=0` and otherwise equals `I(P_{A,B | C=c})`.

The main averaged mutual-information theorem is:

- `Shannon.condMutualInfo_eq_sum_thirdMarginal_mul_condMutualInfoFstSndGivenThird`:
  `condMutualInfo p =
   sum_c (thirdMarginal p c).toReal *
     condMutualInfoFstSndGivenThird p c`.

Mathematically:

`I(A;B | C) = sum_c P_C(c) I(A;B | C=c)`.

The KL-facing corollary in `LeanInfoTheory/Shannon/SemanticBridge/KL.lean` is:

- `Shannon.condMutualInfo_eq_sum_thirdMarginal_mul_condMutualInfoFstSndGivenThirdKL`:
  `I(A;B | C) =
   sum_c P_C(c) D(P_{A,B|C=c} || P_{A|C=c} × P_{B|C=c})`.

Zero-marginal fibers contribute zero by definition, matching the convention
chosen in `docs/semantic-bridge-design.md`.

This completes step 7 of the near-term semantic bridge plan. Step 8 is to add
the first semantic theorem API built on the bridge results, such as chain-rule
and semantic nonnegativity theorems for mutual information and conditional
mutual information.

### 37. Semantic Nonnegativity and First Chain Rule

The eighth near-term semantic bridge step is complete. We added
`LeanInfoTheory/Shannon/SemanticBridge/Theorems.lean`, a small user-facing
theorem layer built on the conditional-law and KL bridge files.

The main new semantic theorems are:

- `Shannon.mutualInfo_nonneg`: `0 <= I(A;B)`;
- `Shannon.condMutualInfoFstSndGivenThird_nonneg`:
  `0 <= I(A;B | C=c)` for each fiber, with zero-marginal fibers handled by
  the explicit zero branch;
- `Shannon.condMutualInfo_nonneg`: `0 <= I(A;B | C)`;
- `Shannon.mutualInfo_chain_rule_fst`:
  `I(A;B,C) = I(A;C) + I(A;B | C)`.

The nonnegativity proof for `mutualInfo` uses the already proved KL bridge

`I(A;B) = D(P_AB || P_A x P_B)`

and then the nonnegativity of the real coercion of mathlib's `ENNReal` KL
divergence. Conditional mutual information nonnegativity follows from the
averaged fiber formula

`I(A;B | C) = sum_c P_C(c) I(A;B | C=c)`,

where every factor `P_C(c)` and every fiber mutual information term is
nonnegative.

The chain rule is proved from the entropy definitions, using the two marginal
reassociation facts now recorded in the same theorem module:

- `(P_AC)_A = P_A`;
- viewing `P_ABC` as a law of `A` and `(B,C)`, its second marginal is
  `P_BC`.

This completes step 8 of the near-term semantic bridge plan. Step 9 is API
polish after theorem pressure: review simp status, possible file splits, and
whether public theorem aliases are justified.

### 38. Semantic Bridge API Polish

The ninth near-term semantic bridge step is complete. We reviewed the API
after the conditional-law, KL, nonnegativity, and chain-rule theorems had put
real theorem pressure on the foundations.

The main code change was to promote safe coordinate/projection orientation
lemmas to `[simp]` in `LeanInfoTheory/Shannon/InfoMeasures.lean`. These are
lemmas whose left-hand sides are clearly more complicated projection forms and
whose right-hand sides are canonical marginals or PMF-level quantities. The
promoted simplifications include:

- pair swaps:
  `fstMarginal (P_{B,A}) = P_B` and `sndMarginal (P_{B,A}) = P_A`;
- triple first/second swaps:
  `(P_{B,A,C})_{B,C} = P_{B,C}`,
  `(P_{B,A,C})_{A,C} = P_{A,C}`, and the third marginal is unchanged;
- coordinate-projection random-variable identities, such as
  `I_P(fst; snd) = I(P)` and
  `I_P(first; second | third) = I(P)`.

We deliberately did not mark the entropy-identity unfolding lemmas
`condEntropy_eq`, `mutualInfo_eq`, or `condMutualInfo_eq` as simp lemmas.
Those are powerful algebraic rewrites and should remain explicit in proofs
unless later theorem pressure shows that global simplification is safe.

We also decided not to split `LeanInfoTheory/Shannon/InfoMeasures.lean` yet.
The file is large enough to watch, but it is still coherent: it contains the
finite PMF information-measure API, while the heavier semantic bridge has
already been split into subfiles. A split should happen when one of the
following pressures becomes real: finite-family entropy, many more conditional
mutual-information variants, or repeated long build/review cycles in the
single file.

Finally, we did not add polished public aliases for the semantic bridge
theorems yet. The current names in `LeanInfoTheory.Shannon` are descriptive,
and the theorem sample size is still small. Alias design should wait until we
have more chain rules, symmetry variants, and concrete users of the semantic
bridge.

This completes the nine-step near-term semantic bridge plan. The next natural
work is to choose a new focused milestone rather than continuing to stretch
this plan.

### 39. Public Website Status Refresh

After checkpointing the completed semantic bridge milestone, we started the
website-improvement plan with a truth/status refresh. This was deliberately a
low-risk content pass, not the full dashboard redesign or generated
blueprint/docgen infrastructure.

The homepage, module list, concept note, roadmap, blueprint overview, and
hand-written dependency map were updated so they no longer describe KL and
conditional-law bridge theorems as merely planned. The public status now
mentions:

- finite conditional laws with explicit zero-mass conventions;
- conditional entropy as expected fiber entropy;
- mutual information as KL divergence from the joint law to the product of
  marginals;
- conditional mutual information as averaged fiber mutual information and
  averaged fiber KL;
- semantic nonnegativity of mutual information and conditional mutual
  information;
- the first mutual-information chain rule
  `I(A;B,C) = I(A;C) + I(A;B|C)`.

The homepage also now includes a compact theorem-highlight table and a
certificate-validation explanation. The validation note emphasizes that the
current Lean side checks certificates; it does not search for them
automatically. External tools such as PSITIP/oXitip may later search for
certificates, but Lean validation remains the trusted step.

Related public Markdown files, including the README, concept note, roadmap,
and foundation conventions, were refreshed to avoid contradicting the website.
The next website step is the larger homepage/dashboard and new page pass
before moving on to generated blueprint/docgen infrastructure.

### 40. Homepage Dashboard and Hand-Written Guide Pages

The third website-improvement step replaced the older status-memo homepage
with a project-dashboard homepage. The new homepage now gives a compact current
milestone, implemented-layer cards, an architecture flow, start-here links, a
short theorem-highlight table, a certificate-validation explanation, and a
small planned-next section.

Several hand-written pages were added under `home_page/`:

- `theorems.html`: a curated list matching mathematical statements to Lean
  declarations, including entropy nonnegativity, pure-law entropy, relabeling
  invariance, reassociation invariance, entropy upper bound, uniform entropy,
  entropy as expected self-information, conditional entropy as expected fiber
  entropy, mutual information as KL divergence, conditional mutual information
  as averaged fiber MI/KL, semantic nonnegativity, the first MI chain rule, and
  the submodularity certificate theorem.
- `submodularity-demo.html`: an explanation of the checked certificate
  proving
  `H(A) + H(B) - H(A union B) - H(A inter B) >= 0`
  by recognizing it as
  `I(A \ B; B \ A | A inter B)`.
- `module-guide.html`: the hand-written module guide, moved out of the
  `/docs/` landing page so the generated declaration index and future full
  Lean doc-gen output can live there.
- `development.html`: build commands, focused build targets, import guidance,
  and project-hygiene notes.
- `prior-art.html`: the project's relationship to mathlib, PFR, Rocq
  Infotheo, PSITIP/oXitip, and textbook references.

The `/docs/` page is now a documentation landing page linking to these guides,
and the existing concept, roadmap, blueprint, and dependency-map pages received
light navigation updates. These pages remain hand-written; full Lean doc-gen
output, a real theorem-level blueprint source, a generated theorem-level
dependency graph, and a blueprint PDF remain future website milestones.

### 41. Generated Module-Level Blueprint Infrastructure

The fourth website-improvement step added the first reproducible generated
website artifact. The new `scripts/generate_website_blueprint.py` script reads
the Lean files, parses local `import` lines, computes the LeanInfoTheory module
graph, and writes:

- `home_page/blueprint/dep_graph_document.html`, the generated module-level
  dependency map shown on the website;
- `home_page/blueprint/module_graph.json`, a machine-readable copy of the same
  graph data.

The generated map currently records 24 local Lean modules, 33 local import
edges, 11 modules reachable from the lightweight root import
`LeanInfoTheory`, and 13 modules that are intentionally separately importable.
The map also groups modules into project layers: root import, shared
foundation, finite Shannon layer, semantic bridge layer, certificate layer,
and reference anchors.

This is not a theorem-level dependency graph yet. It is a reliable module-level
checkpoint that keeps the public site synchronized with the actual Lean import
graph. The CI workflow now runs the generator and checks that the generated
HTML and JSON outputs have no unstaged diff, so import-graph drift should be
caught automatically.

The website and roadmap wording were updated to distinguish the current
generated module dependency map from later full Lean doc-gen output, theorem-level
blueprint pages, and a blueprint PDF.

### 42. Generated Declaration Index

The fifth website-improvement step added a lightweight generated API index.
The new `scripts/generate_website_api_index.py` script scans local Lean source
files for public declaration starters, tracks namespaces, reads nearby Lean doc
comments, and writes:

- `home_page/docs/api-index.html`, a source-derived declaration inventory on
  the website;
- `home_page/docs/declaration_index.json`, the machine-readable declaration
  index data.

The generated index currently records 339 public declarations across 21
modules with declarations. The kind breakdown is 241 theorems/lemmas, 89
definitions/abbreviations, 6 structures/classes, and 3 inductive declarations.
All indexed declarations currently have doc comments, which is a useful
side-effect of the recent Lean-commentary pass.

This is intentionally not full Lean doc-gen output. It does not elaborate
types, render equations, link namespaces like mathlib docs, or replace a future
proper API documentation pipeline. Its job is to give the public site a
truthful, generated, source-derived reference page now, while keeping the
hand-written theorem highlights and module guide readable for humans.

The docs landing page, homepage, theorem highlights, module guide, development
page, README, roadmap, and CI workflow were updated. CI now runs both website
generators and checks the generated HTML/JSON artifacts for drift.

### 43. Website Verification and Publishing Pass

The sixth website-improvement step added the final verification wrapper for the
website milestone. The new `scripts/check_website.py` script validates the
generated JSON files and all local links under `home_page/`, so the website
checks are now reusable instead of living only as ad hoc command snippets from
development sessions.

The CI workflow now runs:

1. `python scripts/generate_website_blueprint.py`;
2. `python scripts/generate_website_api_index.py`;
3. `python scripts/check_website.py`;
4. a `git diff --exit-code` check over the generated website artifacts.

This makes the public site less likely to drift from the Lean import graph,
public declarations, or generated JSON files. The README and development page
now show the same regeneration/check commands that CI uses.

### 44. Navigation and Generated-Artifact Terminology Pass

The first follow-up step from the July 7 website-review task cleaned up the
public site navigation and the names of generated artifacts. The top-level
navigation is now centered on the main reader tasks:

- theorem highlights;
- the submodularity certificate demo;
- the generated API/declaration index;
- the blueprint area;
- the GitHub repository.

The short navigation label is `API Index`, but the generated page itself is
now titled `Generated Declaration Index`. This keeps the navigation compact
while making clear that the current artifact is a source-derived declaration
inventory, not full Lean doc-gen output.

The generated import graph is now described as a `module dependency map` or
`Generated Module Dependency Map`. This avoids suggesting that the current
graph is already a theorem-level dependency graph. A theorem-level blueprint,
full Lean doc-gen output, and blueprint PDF remain future milestones.

The handwritten website pages and the two website generators were updated, then
the generated declaration index and generated module dependency map were
regenerated from source.

### 45. Homepage Project Summary

The second follow-up step from the July 7 website-review task added a compact
project summary near the top of the homepage, immediately after the build and
deployment status badges. The paragraph now states, in one place, that
LeanInfoTheory is a Lean 4/mathlib project for finite information theory and
trusted entropy-inequality certificate checking.

The summary also separates the current formalized scope from the longer-term
goal. It names the checked finite PMF information measures, semantic bridges to
conditional laws and KL divergence, and the Shannon submodularity certificate
demo as current work, while describing textbook-scale library growth and
external-certificate imports for network-information-theory converses as later
goals.

### 46. Two-Branch Architecture Diagram

The third follow-up step from the July 7 website-review task redesigned the
homepage architecture diagram. The previous diagram was a mostly linear chain,
which made the finite-library work and certificate-checking work look like one
single pipeline.

The homepage now presents two parallel branches:

- the formal library branch, from mathlib `PMF`, measure, and KL APIs through
  the finite Shannon layer to semantic bridge theorems;
- the certificate-validation branch, from entropy expressions through
  primitive Shannon inequalities to raw certificates checked by Lean.

The two branches meet in a shared checked-theorem block explaining that the
semantic library facts and algebraic certificate validation together support
verified inequalities such as Shannon submodularity. A short future-facing line
connects this architecture to textbook inequalities, richer assumptions,
external certificate imports, and network converse examples.

### 47. Homepage Dashboard and Terminology Tightening

The website dashboard was tightened with a new `Status at a Glance` section on
the homepage. The section separates four public-facing statuses:

- checked finite PMF information-measure theorems;
- checked semantic and KL bridge theorems;
- the current Lean-side certificate checker and submodularity demo;
- generated reference artifacts.

This makes the homepage clearer about what is proved, what is a demo, and what
is generated documentation support. The certificate-checker card also states
that Lean currently validates supplied certificates but does not search for
certificates automatically.

The terminology pass also made the website and living docs more precise:

- the current import artifact is a `module dependency map`, not a theorem-level
  dependency graph;
- `home_page/docs/api-index.html` is a source-derived declaration index, not
  full Lean doc-gen output;
- full Lean doc-gen output, theorem-level blueprint pages, and a blueprint PDF
  remain future milestones.

### 48. Prior-Art Page Links and Comparison Table

The fifth step of the current website plan strengthened the prior-art page.
The page now includes concrete links to:

- mathlib foundations used by the project, including `PMF`, binary/q-ary
  entropy, KL divergence, KL chain rules, and Kraft-McMillan;
- the Lean PFR formalization, project website, and blueprint;
- Rocq Infotheo and its information-theory source directory;
- PSITIP, oXitip, and AITIP as external entropy-inequality search or checking
  tools.

The page also now has a comparison table explaining the role of each reference
and how LeanInfoTheory differs: it reuses mathlib foundations, learns from PFR
and Infotheo, and treats external inequality tools as untrusted search/import
front ends while keeping Lean validation as the trusted proof step.

### 49. Submodularity Demo Trusted-Flow Diagram

The sixth step of the current website plan added a visual trusted-flow diagram
to the submodularity demo page. The diagram separates:

- untrusted raw certificate data;
- Lean validation of primitive tags, nonnegative rational coefficients, and
  exact normalized entropy-expression equality;
- checked certificate data passed to the generic soundness theorem;
- the final proved entropy submodularity statement.

The wording is deliberately explicit that future external search/import tools
would enter as untrusted raw data, while Lean validation remains the trusted
step.

### 50. Roadmap Status Labels

The seventh step of the current website plan improved the roadmap/status
presentation. The roadmap page now separates work into explicit completed,
active, planned, and later categories, with status pills for each item.

The homepage `Planned Next` section was also adjusted to use the same labels,
so readers can distinguish active maintenance, planned theorem/documentation
work, and later infrastructure milestones at a glance. The wording continues
to distinguish the current source-derived declaration index and module
dependency map from future full Lean doc-gen output and theorem-level
leanblueprint pages.

### 51. Mutual Information Symmetry

The first step of the new Lean theorem-focused thread is complete. The finite
information-measure layer now proves mutual-information symmetry without
importing the semantic bridge:

- `Shannon.mutualInfo_map_swap`:
  `mutualInfo (p.map Prod.swap) = mutualInfo p`;
- `Shannon.mutualInfoOf_swap`:
  `mutualInfoOf p Y X = mutualInfoOf p X Y`.

The proof lives in `LeanInfoTheory/Shannon/InfoMeasures.lean` because it only
uses the entropy-identity definition of mutual information, the existing
coordinate-swap marginal lemmas, and entropy invariance under coordinate swap.
The declarations are exported through `LeanInfoTheory.InformationMeasures`, so
they are available from the lightweight root import.

This completes step 1 of the active nine-step Lean theorem plan. The next
theorem-development step is conditional mutual-information symmetry, followed
by conditional entropy nonnegativity and broader chain-rule variants.

### 52. Conditional Mutual Information Symmetry

The second step of the new Lean theorem-focused thread is complete. The finite
information-measure layer now proves conditional mutual information symmetry in
the first two coordinates:

- `Shannon.condMutualInfo_map_swap12`:
  `condMutualInfo (p.map fun x => (x.2.1, x.1, x.2.2)) = condMutualInfo p`;
- `Shannon.condMutualInfoOf_swap`:
  `condMutualInfoOf p Y X Z = condMutualInfoOf p X Y Z`.

Like mutual-information symmetry, this theorem belongs in
`LeanInfoTheory/Shannon/InfoMeasures.lean`, not the semantic bridge. Its proof
uses the entropy-identity definition of conditional mutual information, the
existing first/second-coordinate triple-swap marginal lemmas, and entropy
invariance under injective relabeling for the swapped triple law.

This completes step 2 of the active nine-step Lean theorem plan. The next
theorem-development step is finite conditional entropy nonnegativity, using
the semantic bridge theorem that writes `H(A|B)` as an average of fiber
entropies.

### 53. Conditional Entropy Nonnegativity

The third step of the new Lean theorem-focused thread is complete. The semantic
theorem layer now proves finite conditional entropy nonnegativity:

- `Shannon.condEntropyFstGivenSnd_nonneg`:
  `0 <= condEntropyFstGivenSnd p b`;
- `Shannon.condEntropy_nonneg`:
  `0 <= condEntropy p`;
- `Shannon.condEntropyOf_nonneg`:
  `0 <= condEntropyOf p X Y`.

Unlike the symmetry theorems from steps 1 and 2, this belongs in
`LeanInfoTheory/Shannon/SemanticBridge/Theorems.lean`, because the proof uses
the semantic conditional-law formula

`H(A | B) = sum_b P_B(b) H(P_{A | B=b})`.

Each summand is nonnegative: the marginal mass is a nonnegative real number,
and the fiber entropy is nonnegative, with zero-marginal fibers handled by the
explicit zero branch in `condEntropyFstGivenSnd`.

This completes step 3 of the active nine-step Lean theorem plan. The next
theorem-development step is the conditional entropy chain-rule API.

### 54. Conditional Entropy Chain Rules

The fourth step of the new Lean theorem-focused thread is complete. The finite
information-measure layer now records conditional entropy chain-rule variants:

- `Shannon.entropy_eq_entropy_sndMarginal_add_condEntropy`:
  `entropy p = entropy (sndMarginal p) + condEntropy p`;
- `Shannon.entropy_eq_entropy_fstMarginal_add_condEntropy_swap`:
  `entropy p = entropy (fstMarginal p) + condEntropy (p.map Prod.swap)`;
- `Shannon.jointEntropyOf_eq_entropyOf_add_condEntropyOf`:
  `jointEntropyOf p X Y = entropyOf p Y + condEntropyOf p X Y`;
- `Shannon.jointEntropyOf_eq_entropyOf_add_condEntropyOf_swap`:
  `jointEntropyOf p X Y = entropyOf p X + condEntropyOf p Y X`.

These theorems live in `LeanInfoTheory/Shannon/InfoMeasures.lean` because they
are algebraic consequences of the entropy-identity definition of conditional
entropy and existing coordinate-swap facts. They do not need KL divergence or
conditional-law imports.

This completes step 4 of the active nine-step Lean theorem plan. The next
theorem-development step is to add mutual-information chain-rule variants
beyond `mutualInfo_chain_rule_fst`.

### 55. Mutual Information Chain-Rule Variants

The fifth step of the new Lean theorem-focused thread is complete. The semantic
theorem layer now contains the sibling chain-rule expansion

`I(A;B,C) = I(A;B) + I(A;C | B)`.

The main new declarations are:

- `Shannon.mutualInfo_chain_rule_snd`;
- `Shannon.mutualInfoOf_chain_rule_fst`;
- `Shannon.mutualInfoOf_chain_rule_snd`.

To state the second PMF-level chain rule cleanly, the finite information
measure layer also now has the small missing triple marginal helper
`Shannon.fstSndMarginal`, together with projection lemmas
`Shannon.fstSndMarginal_map` and `Shannon.fstSndMarginal_map_triple`. This is
the first-second analogue of the existing first-third, second-third, and
third-coordinate marginal helpers.

This completes step 5 of the active nine-step Lean theorem plan. The next
theorem-development step is conditioning-reduces-entropy, likely using the
new chain-rule variants and conditional mutual-information nonnegativity.

### 56. Conditioning Reduces Entropy

The sixth step of the new Lean theorem-focused thread is complete. The semantic
theorem layer now proves the finite conditioning-reduces-entropy theorem

`H(A | B,C) <= H(A | C)`.

The main new declarations are:

- `Shannon.condMutualInfo_eq_condEntropy_fstThirdMarginal_sub_condEntropy`:
  `I(A;B | C) = H(A | C) - H(A | B,C)`;
- `Shannon.condEntropy_le_condEntropy_fstThirdMarginal`:
  `H(A | B,C) <= H(A | C)`;
- `Shannon.condEntropyOf_pair_le_condEntropyOf`:
  `H(X | Y,Z) <= H(X | Z)`.

The proof rewrites the conditional-entropy difference as conditional mutual
information, then applies `Shannon.condMutualInfo_nonneg`. This uses the
semantic theorem API rather than adding new definitions or changing the
lightweight finite layer.

This completes the finite-theorem part of the active nine-step plan. The next
step is to add one or two small checked-certificate examples beyond
submodularity, so the raw-to-checked validator sees more theorem pressure
before any primitive-recognition or richer-assumption work.

### 57. Additional Checked Certificate Demos

The seventh step of the active Lean theorem/certificate plan is complete. Two
small, separately importable checked-certificate demos now exercise the
raw-to-checked validator beyond the original submodularity example.

`LeanInfoTheory.Certificate.Subadditivity` proves

`0 <= H(A) + H(B) - H(A union B)`

for every abstract `ShannonEntropyVal`. The certificate is intentionally small
but not single-step: it validates the decomposition

`I(A;B | empty) + H(empty)`.

This uses conditional mutual information together with the empty-entropy
primitive to cancel the extra `-H(empty)` term in the CMI expression.

`LeanInfoTheory.Certificate.Monotonicity` proves

`0 <= H(insert i S) - H(S)`

under `i notin S`. This gives the checked-certificate layer a direct example
using the conditional-entropy primitive.

The main new user-facing declarations are:

- `Certificate.Subadditivity.entropy_subadditivity`;
- `Certificate.Monotonicity.entropy_insert_monotonicity`.

This completes step 7 of the active nine-step plan. The next step is to review
certificate ergonomics, especially the amount of boilerplate around raw steps,
primitive tags, and exact decomposition proofs.

### 58. Certificate Ergonomics Review

The eighth step of the active Lean theorem/certificate plan is complete. The
review compared the submodularity, subadditivity, and one-variable
monotonicity certificate demos and identified one repeated proof pattern worth
abstracting now.

Each demo proved that its raw certificate validates by showing

`(RawCert.toCheckedCert? raw primitives).isSome`,

then manually split the resulting option only to call the existing
`RawCert.sound_of_toCheckedCert?_eq_some` theorem. The checked-certificate
core now provides the ergonomic theorem

`Certificate.RawCert.sound_of_toCheckedCert?_isSome`.

This theorem states that any raw certificate whose validator returns some
checked certificate proves its raw target expression. The three certificate
demos now route their `sound_from_validator` proofs through this generic
helper instead of repeating the same option split.

The review deliberately did not add primitive-recognition/autotagging or a
larger certificate DSL. The explicit primitive-list API is still useful for
trust boundaries, and the current examples are too small to justify a
recognition layer. Future ergonomic work should wait for larger manually
tagged certificates to show whether repeated raw-step constructors,
decomposition proof scripts, or primitive tags are the dominant source of
friction.

### 59. Nine-Step Theorem Plan Reference Refresh

The ninth step of the active Lean theorem/certificate plan is complete. This
was a synchronization step rather than a new theorem step.

The project notes now record the nine-step phase as complete, and the future
work notes distinguish immediate next decisions from later infrastructure:

- choose the next focused Lean phase explicitly, with finite-family entropy
  semantics and larger manually tagged certificate examples as the two most
  natural candidates;
- keep primitive-recognition/autotagging delayed until larger certificates
  show that explicit primitive tags are the real bottleneck;
- keep independence, Markov, functional-dependence, and PSITIP/oXitip-style
  import work as later certificate extensions;
- keep theorem-level blueprint and full Lean doc-gen work separate from the
  current source-derived declaration index and module-level dependency map.

The generated website reference artifacts were refreshed, and the hand-written
theorem-highlight table was checked against the generated declaration index so
its source-line links match the current Lean files.

### 60. Three-Way Subadditivity Pressure-Test Module

The next focused Lean phase is the manual certificate pressure test for
three-way entropy subadditivity. Its goal is to add one larger, still
primitive-only checked certificate example before introducing any new trusted
assumptions, primitive-recognition layer, certificate DSL, or finite-family
entropy representation.

The first step is complete: the new separately importable module
`LeanInfoTheory.Certificate.ThreeWaySubadditivity` exists and imports only the
checked-certificate layer. It is intentionally a module shell at this point;
the target expression, manually tagged certificate, and final theorem are the
next steps.

The module was also added to the focused build lists and generated
module-dependency map so it stays visible as a separate-import certificate
target while the pressure-test phase proceeds.

The second step is also complete. The module now defines
`Certificate.ThreeWaySubadditivity.expr`, the formal entropy expression

`H(A) + H(B) + H(C) - H(A union B union C)`,

and proves `Certificate.ThreeWaySubadditivity.eval_expr`, identifying its
evaluation under any `ShannonEntropyVal` with the expected real-valued
inequality body. The next step is the manually tagged two-block primitive
certificate.

The third step is complete. The module now contains a four-step manually
tagged raw certificate with the primitive list

`I(A;B | empty), H(empty), I(A union B;C | empty), H(empty)`.

Its exact decomposition proof uses only local additive-group normalization:
the larger example did expose a small amount of associativity/cancellation
noise, but it did not require a new trusted helper, a primitive-recognition
layer, or an extra tactic import. The final user-facing theorem is
`Certificate.ThreeWaySubadditivity.entropy_three_way_subadditivity`.

The fourth step is complete. The pressure-test module stayed within the
intended conservative scope: it imports only `LeanInfoTheory.Certificate.Checked`,
remains separately importable, leaves the root import lightweight, and adds no
new assumptions, primitive-recognition/autotagging layer, certificate DSL, or
finite-family entropy representation. The root module's documentation was
updated to mention the expanded set of separately importable certificate demo
and pressure-test files without changing any imports.

The fifth step is complete. The pressure-test lessons are:

- raw-step boilerplate is repetitive but still manageable for a four-step
  certificate;
- explicit primitive tags remain a good trust-boundary choice and are not yet
  the dominant bottleneck;
- exact decomposition proofs are the first meaningful ergonomic pressure
  point, because the two-block expression required local additive-group
  normalization for associativity and cancellation;
- theorem naming is still fine with descriptive names such as
  `entropy_three_way_subadditivity`;
- the next larger certificate should watch whether normalization scripts
  repeat. If they do, a small proof-side normalization helper may be more
  valuable than primitive-recognition/autotagging.

The sixth step is complete. Public artifacts were refreshed after the theorem
landed: generated module/declaration artifacts were regenerated, the homepage
and theorem-highlight tables now list
`Certificate.ThreeWaySubadditivity.entropy_three_way_subadditivity`, and the
README/current-state notes describe the module as a proved pressure-test
certificate rather than only a planned shell.

### 61. Project B Transition Decision

On July 10, 2026, after completing the manual certificate pressure test and
reviewing the repository's general Lean status, the next mathematical direction
was chosen explicitly: focus on Project B, the formalization of textbook
information-theory fundamentals, before returning to the Project A
Lean-checked certificate system and converse-step program.

The Project B scope will be source-driven. Chapter 2 of Cover and Thomas is the
primary finite-information-theory spine, cross-checked against the local Yeung,
El Gamal--Kim, Polyanskiy--Wu, and Csiszar--Korner texts so that definitions and
theorem boundaries also support later coding, network-information-theory, and
learning-oriented chapters. The existing finite `PMF` entropy,
conditional-law, mutual-information, entropy-bound, and semantic KL bridge APIs
remain the starting point.

This transition does not yet choose a new Lean representation, change a theorem
statement, or alter the root import. The detailed Project B formalization map
and execution order will be designed after the current milestone cleanup and
before new Lean edits. In particular, finite-family entropy, kernel/Markov
infrastructure, relative-entropy API shape, data processing, sufficient
statistics, and Fano's inequality must be ordered by dependency and by existing
mathlib support rather than introduced all at once.

Project A is paused rather than abandoned. The checked certificate core and its
pressure-test lessons remain available, while primitive recognition, richer
certificate assumptions, external certificate import, and larger converse
examples stay in the future-work backlog until the stronger Project B
foundation makes returning to them worthwhile.

The milestone verification suite passed on July 11, 2026. Both generated
website reference artifacts were refreshed; a single multi-target Lake build
checked the lightweight root, entropy bounds, semantic bridge, mathlib anchors,
all certificate demos and pressure tests, and examples; and the website,
generated JSON, forbidden-placeholder, and diff-hygiene checks all passed. The
root import remains unchanged.

### 62. Project B Chunk 1 Contract and Proof Spikes

On July 12, 2026, the first implementation phase of the Project B
formalization map was fixed as a 14-step pair/triple Shannon theorem plan. The
phase starts from zero entropy and support-cardinality bounds, passes through
zero conditional entropy and support-wise functional dependence, then develops
deterministic processing, MI/CMI identities, and their named textbook
inequality consequences. Minimal base conversion and the milestone integration
pass close the chunk.

Step 1 is complete. Before any production theorem was added, temporary Lean
proofs were compiled against the current semantic bridge. The scratch file was
then removed. The proof spikes established all of the following without
`sorry`, `admit`, new axioms, or new opaque constants:

- for a finite PMF, a zero entropy sum forces every `Real.negMulLog` summand to
  vanish, a support atom must therefore have mass one, and the PMF is pure;
- `p.map f = PMF.pure b` is equivalent to `f a = b` for every
  `a in p.support`, using the existing `PMF.support_map` theorem;
- `condEntropy p = 0` forces every positive-mass conditional fiber to have zero
  entropy and hence to be pure;
- the pure-fiber witnesses assemble into a total function `f : beta -> alpha`;
  a support atom of the joint PMF supplies the harmless default value on
  zero-marginal fibers, so no extra `[Nonempty alpha]` assumption is needed;
- conversely, support-wise equality `a = f b` makes every positive conditional
  support a singleton and therefore makes expected conditional entropy zero;
- the PMF theorem transfers to random variables exactly through
  `PMF.support_map`, yielding equality only on the source PMF support.

The public theorem contract is now support-aware. `entropy_eq_zero_iff` and
`entropyOf_eq_zero_iff` will provide the zero-entropy API. The positive-fiber
theorem will be
`condEntropyFstGivenSnd_eq_zero_iff_of_sndMarginal_ne_zero`, while the global
PMF and random-variable theorems will be
`condEntropy_eq_zero_iff_exists_function` and
`condEntropyOf_eq_zero_iff_exists_function`. A separate public
functional-dependence predicate is not being introduced in this chunk; direct
existential decoder statements fit the current theorem surface and avoid
premature architecture for later certificate constraints.

The deterministic-processing equality contract was also fixed. In the
random-variable statement, `H(f(X)) = H(X)` will be characterized by
`Set.InjOn f (p.map X).support`. Requiring `f comp X` to be injective on the
source support would be incorrectly strong when `X` itself identifies source
outcomes. The conditional equality theorem will instead say that `X` can be
recovered from `(f(X), Z)` on the source support.

Module ownership remains conservative:

- zero entropy belongs in `Shannon/Entropy.lean`;
- support-cardinality bounds belong in the separately importable
  `Shannon/EntropyBounds.lean`;
- algebraic MI/CMI and conditional-chain-rule identities belong in
  `Shannon/InfoMeasures.lean`;
- consequences requiring expected conditional laws or semantic
  nonnegativity belong in `Shannon/SemanticBridge/Theorems.lean`;
- base conversion will be a small opt-in module and will not replace the
  canonical real-valued definitions measured in nats.

The units module will expose change-of-base lemmas rather than duplicate
entropy, conditional entropy, MI, and CMI definitions.

The root import is unchanged. Step 1 changed only maintained project notes;
production Lean work begins in step 2 with the zero-entropy characterization.

### 63. Zero-Entropy Characterizations

Step 2 of Project B Chunk 1 was completed on July 12, 2026. The lightweight
finite entropy module now exposes two new public theorems:

- `Shannon.entropy_eq_zero_iff` states
  `entropy p = 0 <-> exists a, p = PMF.pure a`;
- `Shannon.entropyOf_eq_zero_iff` states that `entropyOf p X = 0` exactly when
  there is an output `a` such that `X omega = a` for every
  `omega in p.support`.

The PMF proof uses nonnegativity of every `Real.negMulLog` summand. If their
finite sum is zero, every summand is zero; choosing a PMF support atom rules out
zero mass there, so its mass is one and the PMF is pure. The random-variable
proof transfers purity of `p.map X` to support-wise constancy using
`PMF.support_map`.

The implementation deliberately keeps the auxiliary singleton-support and
constant-pushforward lemmas private. Step 2 has only one production consumer
for the map-to-pure helper, so there is not yet enough pressure for a new
public PMF support API. Step 5 can promote a generic lemma if the functional-
dependence proofs create genuine reuse.

No extra `[Nonempty alpha]` assumption is present: the existing
`PMF.support_nonempty` theorem supplies the required witness. No existing
theorem statement, root import, entropy definition, certificate module, or
project architecture changed.

Focused and downstream verification passed:

- `lake build LeanInfoTheory.Shannon.Entropy`;
- `lake build LeanInfoTheory`;
- `lake build LeanInfoTheory.Shannon.EntropyBounds`;
- `lake build LeanInfoTheory.Shannon.SemanticBridge`.

The next active task is step 3, the support-cardinality entropy bound.

### 64. Support-Cardinality Entropy Bounds

Step 3 of Project B Chunk 1 was completed on July 12, 2026. The separately
importable `Shannon/EntropyBounds.lean` module now proves:

- `Shannon.entropy_le_log_support_ncard`:
  `entropy p <= Real.log (p.support.ncard : Real)`;
- `Shannon.entropyOf_le_log_support_ncard`:
  `entropyOf p X <= Real.log ((p.map X).support.ncard : Real)`.

The proof does not duplicate the Jensen argument in `entropy_le_log_card`.
Instead, a private `Finset` collects exactly the atoms with nonzero PMF mass,
a private PMF on that finite subtype reuses the original masses, and finite
sum calculations prove that this support PMF has total mass one and the same
entropy as the original law. The existing alphabet-cardinality theorem then
applies to the support subtype, whose `Fintype.card` rewrites to
`p.support.ncard`.

Using a concrete support `Finset` was important for proof stability. An initial
scratch formulation over the set subtype encountered competing `Fintype`
enumerations in subtype sums. The `Finset` subtype has a canonical enumeration,
and `Finset.univ_eq_attach` plus `Finset.sum_attach` provide direct sum bridges
without changing the mathematical construction.

As fixed in the Step 1 contract, neither theorem requires `[Nonempty alpha]`.
`PMF.support_nonempty` constructs the nonempty instance needed only for the
private support alphabet. All support constructions remain private, the root
import remains unchanged, and the bounds module remains opt-in.

Focused verification passed with
`lake build LeanInfoTheory.Shannon.EntropyBounds`; the lightweight root and
semantic bridge targets also passed together, confirming that the new analytic
theorems did not enter their import surfaces.

The next active task is step 4, zero entropy on positive conditional fibers.

### 65. Positive Conditional-Fiber Zero Entropy

Step 4 of Project B Chunk 1 was completed on July 12, 2026. The semantic
theorem layer now exposes
`Shannon.condEntropyFstGivenSnd_eq_zero_iff_of_sndMarginal_ne_zero`.
For `hb : sndMarginal p b != 0`, it states

```text
condEntropyFstGivenSnd p b = 0
  <-> exists a, condFstGivenSnd p b hb = PMF.pure a.
```

The proof deliberately reuses the existing API rather than inspecting the
conditional PMF sum again. The theorem
`condEntropyFstGivenSnd_of_sndMarginal_ne_zero` rewrites the numeric fiber
quantity to `entropy (condFstGivenSnd p b hb)`, after which the Step 2 theorem
`entropy_eq_zero_iff` gives the result directly.

The zero-marginal convention is unchanged and remains covered by
`condEntropyFstGivenSnd_of_sndMarginal_eq_zero`: such fibers contribute the
number zero without manufacturing a conditional PMF. The new theorem is
therefore intentionally parameterized by a nonzero-marginal proof and makes no
claim about a canonical law on a null fiber.

No new definition, helper representation, typeclass assumption, import, or
root export was introduced. Focused verification passed for
`LeanInfoTheory.Shannon.SemanticBridge.Theorems`; the aggregate semantic bridge
and lightweight root targets also passed.

The next active task is step 5, the global equivalence between zero conditional
entropy and support-wise functional dependence.

### 66. Zero Conditional Entropy and Functional Dependence

Step 5 of Project B Chunk 1 was completed on July 12, 2026. The semantic
theorem layer now contains the global PMF equivalence

```text
condEntropy p = 0
  <-> exists f : beta -> alpha,
        forall z in p.support, z.1 = f z.2
```

as `Shannon.condEntropy_eq_zero_iff_exists_function`. Its random-variable form,
`Shannon.condEntropyOf_eq_zero_iff_exists_function`, states

```text
condEntropyOf p X Y = 0
  <-> exists f : beta -> alpha,
        forall omega in p.support, X omega = f (Y omega).
```

The forward PMF proof rewrites conditional entropy as the finite weighted sum
of fiber entropies. Nonnegativity and a zero total force every positive-weight
fiber entropy to be zero; Step 4 then makes each positive fiber pure. Classical
choice assembles those pure-fiber atoms into a total decoder. A joint support
atom supplies a default output on null fibers, so the statement needs no extra
`[Nonempty alpha]` assumption.

For the converse, support-wise functional dependence makes each positive
conditional support the singleton `{f b}`. The conditional PMF is therefore
pure, every fiber contribution is zero, and the expected conditional entropy
vanishes. Null fibers continue to use the established numeric-zero branch.

Step 5 also adds the expected textbook corollaries:

- `Shannon.condEntropyOf_comp_eq_zero`: `H(f(Y)|Y) = 0`;
- `Shannon.condEntropyOf_self_eq_zero`: `H(X|X) = 0`;
- `Shannon.entropy_eq_entropy_sndMarginal_iff_exists_function`;
- `Shannon.jointEntropyOf_eq_entropyOf_iff_exists_function`, expressing
  `H(X,Y) = H(Y)` iff `X` is a support-wise function of `Y`.

The singleton-support PMF argument from Step 2 now had a second production
consumer, so it was promoted exactly once to the generic theorem
`PMF.eq_pure_iff_support_eq_singleton` in `Probability/Finite.lean`. The former
private duplicate in `Entropy.lean` was removed. The broader map-to-pure helper
remains private because it still lacks comparable reuse pressure.

No public functional-dependence predicate was introduced. These direct
existential statements do not add functional-dependence assumptions to the
certificate checker; that Project A extension remains in Future Work Note 11.
No existing theorem statement, root import, or module boundary changed.

Verification passed for `LeanInfoTheory.Shannon.Entropy`,
`LeanInfoTheory.Shannon.SemanticBridge.Theorems`, the aggregate semantic bridge,
the separately importable entropy bounds, and the lightweight root.

The next active task is step 6, the remaining pair/triple conditional-entropy
chain rules.

### 67. Pair/Triple Conditional-Entropy Chain Rules

Step 6 of Project B Chunk 1 was completed on July 12, 2026. The lightweight
random-variable layer now exposes the conditioned-pair swap theorem

- `Shannon.condEntropyOf_pair_swap`:
  `H(Y,X|Z) = H(X,Y|Z)`;

and both textbook triple conditional-entropy chain rules:

- `Shannon.condEntropyOf_pair_chain_rule`:
  `H(X,Y|Z) = H(Y|Z) + H(X|Y,Z)`;
- `Shannon.condEntropyOf_pair_chain_rule_swap`:
  `H(X,Y|Z) = H(X|Z) + H(Y|X,Z)`.

The primary rule is an entropy-identity calculation using product
reassociation. The swapped rule reuses conditioned-pair swap invariance and
the primary rule rather than duplicating that algebra. These random-variable
theorems live in `Shannon/InfoMeasures.lean` and are exported by the
lightweight `InformationMeasures` compatibility module.

The separately importable conditional semantic bridge adds the corresponding
PMF-facing statements for a law `p : PMF (alpha × beta × gamma)`:

- `Shannon.condEntropy_pairThirdLaw_chain_rule`;
- `Shannon.condEntropy_pairThirdLaw_chain_rule_swap`.

Here `pairThirdLaw p` views the triple as the conditioned pair `(A,B)` and
conditioning variable `C`. The wrappers reuse the random-variable rules and
the established first/second/third marginal maps, so no duplicate conditional
entropy definition or new triple-law representation was introduced.

Following Future Work Note 16, none of the chain-rule equalities is marked
`[simp]`: both sides are useful normal forms, and automatic expansion would
choose a direction before downstream theorem pressure has identified a stable
canonical form. No existing theorem statement or root import changed.

Focused verification passed for `LeanInfoTheory.Shannon.InfoMeasures` and
`LeanInfoTheory.Shannon.SemanticBridge.Conditional`. Downstream verification
also passed for the lightweight root, the separately importable entropy
bounds, and the aggregate semantic bridge.

The next active task is step 7, unconditional and conditional deterministic
entropy processing with the support-aware equality cases fixed in Step 1.

### 68. Deterministic Entropy Processing

Step 7 of Project B Chunk 1 was completed on July 12, 2026. The semantic
theorem layer now proves that deterministic post-processing cannot increase
finite entropy:

- `Shannon.entropy_map_le` for a PMF pushed forward by `f`;
- `Shannon.entropyOf_comp_le` for a finite-valued random variable `f(X)`.

The exact equality cases are:

- `Shannon.entropy_map_eq_iff_injOn_support`;
- `Shannon.entropyOf_comp_eq_iff_injOn_support`.

As fixed in Step 1, the random-variable theorem states

```text
H(f(X)) = H(X) <-> Set.InjOn f (p.map X).support.
```

It does not require `f comp X` to be injective on the source outcome support.
The proof decomposes `H(X)` as `H(f(X)) + H(X|f(X))`. Zero conditional entropy
gives a support-wise left inverse, hence injectivity on the law support. In the
reverse direction, mathlib's `Function.invFunOn` supplies a left inverse on
that support. A support atom from the PMF provides the local `Nonempty`
instance, so no artificial typeclass assumption enters the theorem statement.

Conditional deterministic processing is built from the Step 6 chain rules.
The new identity

- `Shannon.condEntropyOf_deterministic_chain_rule`:
  `H(X|Z) = H(f(X)|Z) + H(X|f(X),Z)`

immediately yields `Shannon.condEntropyOf_comp_le`. Its equality theorem,
`Shannon.condEntropyOf_comp_eq_iff_exists_recovery`, states

```text
H(f(X)|Z) = H(X|Z)
  <-> exists g, forall omega in p.support,
        X omega = g (f (X omega), Z omega).
```

The PMF-facing corollaries `Shannon.condEntropy_map_fst_le` and
`Shannon.condEntropy_map_fst_eq_iff_exists_recovery` apply the same result to
the first coordinate of a joint law. This is deterministic entropy processing,
not the later stochastic-channel data-processing API; no channel or Markov
abstraction was introduced.

All nine public declarations live in the separately importable
`Shannon/SemanticBridge/Theorems.lean` module because their proofs use semantic
conditional-entropy nonnegativity and equality results. The root import and
existing theorem statements remain unchanged.

Focused verification passed for
`LeanInfoTheory.Shannon.SemanticBridge.Theorems`. Downstream verification also
passed for the lightweight root, the separately importable entropy bounds, and
the aggregate semantic bridge.

The next active task is step 8, the elementary mutual-information identity
family.

### 69. Elementary Mutual-Information Identities

Step 8 of Project B Chunk 1 was completed on July 14, 2026. The lightweight
finite information-measure layer now exposes both standard conditional-entropy
forms of mutual information for a joint PMF:

- `Shannon.mutualInfo_eq_entropy_fstMarginal_sub_condEntropy`:
  `I(A;B) = H(A) - H(A|B)`;
- `Shannon.mutualInfo_eq_entropy_sndMarginal_sub_condEntropy_swap`:
  `I(A;B) = H(B) - H(B|A)`.

The corresponding random-variable declarations are:

- `Shannon.mutualInfoOf_eq_entropyOf_sub_condEntropyOf`;
- `Shannon.mutualInfoOf_eq_entropyOf_sub_condEntropyOf_swap`.

The same block also proves the textbook self-mutual-information identity
through:

- `Shannon.mutualInfo_map_diag`, stating that the diagonal law of `A` has
  mutual information `H(A)`;
- `Shannon.mutualInfoOf_self`, stating `I(X;X) = H(X)`.

The difference identities are direct algebraic consequences of the existing
entropy definitions and swap theorem. The diagonal result uses injectivity of
`fun a => (a, a)` and entropy invariance under injective relabeling, so no semantic
nonnegativity, KL divergence, or zero-conditional-entropy theorem is needed.

All six declarations live in `Shannon/InfoMeasures.lean` and are exported by
the explicit lightweight `InformationMeasures` compatibility module. They are
kept as explicit rewrites rather than `[simp]` lemmas. Reverse-oriented
restatements such as `H(X|Y) = H(X) - I(X;Y)` were not added preemptively;
Step 9 can show whether those aliases improve actual inequality proofs.
The six short identities fit the existing coherent module and do not yet
justify splitting `InfoMeasures.lean`.

No existing theorem statement, root import, semantic-bridge boundary, or
certificate architecture changed. Focused verification passed for
`LeanInfoTheory.Shannon.InfoMeasures` and
`LeanInfoTheory.InformationMeasures`. Downstream verification passed for the
lightweight root, the separately importable entropy bounds, and the aggregate
semantic bridge.

The next active task is step 9, pair-level entropy and mutual-information
inequalities.

### 70. Pair-Level Entropy and Mutual-Information Inequalities

Step 9 of Project B Chunk 1 was completed on July 14, 2026. The separately
importable semantic theorem layer now exposes the standard pair-level entropy
inequalities for a finite joint PMF.

Conditioning reduces entropy through
`Shannon.condEntropy_le_entropy_fstMarginal`:

```text
H(A|B) <= H(A).
```

Mutual information is bounded by either marginal entropy through:

- `Shannon.mutualInfo_le_entropy_fstMarginal`;
- `Shannon.mutualInfo_le_entropy_sndMarginal`.

The joint entropy lies between each marginal and their sum through:

- `Shannon.entropy_fstMarginal_le_entropy`;
- `Shannon.entropy_sndMarginal_le_entropy`;
- `Shannon.entropy_le_entropy_fstMarginal_add_entropy_sndMarginal`.

The six direct random-variable forms are:

- `Shannon.condEntropyOf_le_entropyOf`;
- `Shannon.mutualInfoOf_le_entropyOf_left`;
- `Shannon.mutualInfoOf_le_entropyOf_right`;
- `Shannon.entropyOf_le_jointEntropyOf`;
- `Shannon.entropyOf_le_jointEntropyOf_swap`;
- `Shannon.jointEntropyOf_le_entropyOf_add_entropyOf`.

Together these state the familiar pair band

```text
H(X), H(Y) <= H(X,Y) <= H(X) + H(Y),
I(X;Y) <= H(X), H(Y),
H(X|Y) <= H(X).
```

The proofs reuse mutual-information and conditional-entropy nonnegativity,
the Step 8 entropy-difference identities, and the existing pair chain rules.
No reverse-oriented Step 8 aliases were needed, so none were added. The
theorems belong in `Shannon/SemanticBridge/Theorems.lean`, not the lightweight
root, because their proofs depend on semantic nonnegativity.

As required by Future Work Note 18, this step proves inequalities only. It does
not pull forward `I(X;Y) = 0` iff independence, equality in subadditivity, or
`H(X|Y) = H(X)` iff independence; those require the later KL/equality API.

No existing theorem statement, import boundary, or certificate architecture
changed. Focused verification passed for
`LeanInfoTheory.Shannon.SemanticBridge.Theorems`; downstream verification
passed for the lightweight root, the separately importable entropy bounds, and
the aggregate semantic bridge.

### 71. Deterministic Mutual-Information Processing

Step 10 of Project B Chunk 1 was completed on July 14, 2026. The semantic
theorem layer now exposes the random-variable nonnegativity theorem
`Shannon.condMutualInfoOf_nonneg` and the exact deterministic decomposition

```text
I(X;Y) = I(f(X);Y) + I(X;Y | f(X)).
```

This identity is available as
`Shannon.mutualInfoOf_deterministic_chain_rule_left`. Conditional mutual
information nonnegativity then gives the one-sided processing inequalities

- `Shannon.mutualInfoOf_comp_left_le`;
- `Shannon.mutualInfoOf_comp_right_le`;

and `Shannon.mutualInfoOf_comp_le` handles deterministic maps of both
variables:

```text
I(f(X);g(Y)) <= I(X;Y).
```

The PMF-facing coordinate forms are `Shannon.mutualInfo_map_fst_le`,
`Shannon.mutualInfo_map_snd_le`, and `Shannon.mutualInfo_map_prod_le`.

The proof first observes privately that adjoining a deterministic function to
the variable it came from is an injective relabeling and therefore preserves
the relevant marginal and joint entropies. The existing mutual-information
chain rule then isolates the nonnegative conditional-MI remainder. This route
did not use the private Step 7 decomposition
`H(X) = H(f(X)) + H(X|f(X))`, so Future Work Note 19 keeps that identity private
until a genuine public consumer appears.

This step remains strictly deterministic. It does not introduce stochastic
channels, Markov structure, conditional-independence characterizations, or the
general data-processing inequality. The exact right-oriented chain identity
was also not duplicated: the right processing inequality follows cleanly from
symmetry, and the project continues to avoid adding symmetric rewrite variants
without downstream pressure.

The required naming audit added the long chain-rule name and the pressured
`comp`/coordinate-map families to Future Work Note 14. No declarations were
renamed during the active theorem phase.

Focused verification passed for
`LeanInfoTheory.Shannon.SemanticBridge.Theorems` (2693 jobs). Downstream
verification passed for the lightweight root, the separately importable
entropy bounds, and the aggregate semantic bridge (2709 jobs). The root import
remains unchanged. The source-derived API index was regenerated with 391 public
declarations, and the website, generated JSON, forbidden-placeholder, and diff
hygiene checks all passed. The dependency blueprint was refreshed without an
import-graph change.

### 72. Conditional-Mutual-Information Identity Family

Step 11 of Project B Chunk 1 was completed on July 14, 2026. The project already
had the four-entropy expansion of conditional mutual information, the PMF form

```text
I(A;B|C) = H(A|C) + H(B|C) - H(A,B|C),
```

and the left-oriented PMF difference. This step filled only the missing parts
instead of duplicating that API.

The lightweight `Shannon/InfoMeasures.lean` layer now exposes three standard
random-variable rewrites:

- `Shannon.condMutualInfoOf_eq_condEntropyOf_sub_condEntropyOf`:
  `I(X;Y|Z) = H(X|Z) - H(X|Y,Z)`;
- `Shannon.condMutualInfoOf_eq_condEntropyOf_sub_condEntropyOf_swap`:
  `I(X;Y|Z) = H(Y|Z) - H(Y|X,Z)`;
- `Shannon.condMutualInfoOf_eq_condEntropyOf_add_condEntropyOf_sub_condEntropyOf_pair`:
  `I(X;Y|Z) = H(X|Z) + H(Y|Z) - H(X,Y|Z)`.

All three are included in the explicit `LeanInfoTheory.InformationMeasures`
re-export. The semantic theorem layer adds the missing PMF orientation
`Shannon.condMutualInfo_eq_condEntropy_sndThirdMarginal_sub_condEntropy_swap12`,
which states `I(A;B|C) = H(B|C) - H(B|A,C)`.

The RV proofs are algebraic consequences of the existing entropy expansion,
product reassociation, and CMI symmetry. The PMF proof reuses
`condMutualInfo_eq_condEntropy_marginals` and the existing swapped conditional-
entropy chain rule. These are explicit rewrite theorems rather than `[simp]`
rules; expanded and difference normal forms remain independently useful.

The Step 11 audit found no genuine use for the deferred right-oriented exact
deterministic identity `I(X;Y) = I(X;g(Y)) + I(X;Y|g(Y))`, and no proof repeated
the private Step 10 augmentation argument. Consequently, no symmetric
deterministic rewrite or injective-relabeling abstraction was added. Reverse
ordinary-MI identities were also unnecessary. Future Work Notes 14 and 21 keep
those decisions deferred to actual downstream pressure.

The required naming audit added the long RV conditional-subadditivity form and
the representation-heavy PMF `_sndThirdMarginal...swap12` form to Future Work
Note 14, together with the two RV difference names so the family can be reviewed
coherently in Step 13. No existing declaration was renamed.

The focused build passed for `LeanInfoTheory.Shannon.InfoMeasures`,
`LeanInfoTheory.InformationMeasures`, and
`LeanInfoTheory.Shannon.SemanticBridge.Theorems` (2694 jobs). Downstream
verification passed for the lightweight root, the separately importable
entropy bounds, and the aggregate semantic bridge (2709 jobs). The root import
remains unchanged. The source-derived API index was regenerated with 395 public
declarations, and the website, generated JSON, forbidden-placeholder, and diff
hygiene checks all passed. The dependency blueprint was refreshed without an
import-graph change.

### 73. Triple-Level Conditional Inequalities

Step 12 of Project B Chunk 1 was completed on July 14, 2026. It is the
conditional analogue of the Step 9 pair-level inequality block. Together with
the existing conditioning-reduces theorem, the semantic API now exposes the
full finite conditional band

```text
I(X;Y|Z) <= H(X|Z), H(Y|Z),
H(X|Z), H(Y|Z) <= H(X,Y|Z) <= H(X|Z) + H(Y|Z).
```

The five PMF-facing declarations are:

- `Shannon.condMutualInfo_le_condEntropy_fstThirdMarginal`;
- `Shannon.condMutualInfo_le_condEntropy_sndThirdMarginal`;
- `Shannon.condEntropy_fstThirdMarginal_le_condEntropy_pairThirdLaw`;
- `Shannon.condEntropy_sndThirdMarginal_le_condEntropy_pairThirdLaw`;
- `Shannon.condEntropy_pairThirdLaw_le_condEntropy_fstThirdMarginal_add_condEntropy_sndThirdMarginal`.

Their five direct random-variable counterparts are:

- `Shannon.condMutualInfoOf_le_condEntropyOf_left`;
- `Shannon.condMutualInfoOf_le_condEntropyOf_right`;
- `Shannon.condEntropyOf_le_condEntropyOf_pair`;
- `Shannon.condEntropyOf_le_condEntropyOf_pair_swap`;
- `Shannon.condEntropyOf_pair_le_condEntropyOf_add_condEntropyOf`.

The CMI upper bounds subtract a nonnegative conditional entropy from the Step 11
difference identities. The two conditional-marginal lower bounds use the
Step 6 conditional chain rules and conditional-entropy nonnegativity.
Conditional subadditivity is exactly the nonnegativity of the Step 11
conditional-subadditivity gap. All ten results therefore remain in the
separately importable semantic theorem layer.

As required by Future Work Note 18, this step adds inequalities only. It does
not add equality characterizations through conditional independence or zero
CMI. The proofs did not consume the deferred right-oriented deterministic chain
identity, reverse ordinary-MI rewrites, or the private Step 10 augmentation
argument. Future Work Note 21 therefore still has only one genuine consumer.

The Step 12 naming audit records all ten declarations in Future Work Note 14 so
the PMF and RV families can be reviewed coherently. In particular, the PMF names
expose `fstThirdMarginal`, `sndThirdMarginal`, and `pairThirdLaw`; the RV
single-to-pair bounds use an asymmetric unsuffixed/`_swap` family; and both
subadditivity names are long. No declaration was renamed during the active
theorem phase.

Focused verification passed for
`LeanInfoTheory.Shannon.SemanticBridge.Theorems` (2693 jobs). Downstream
verification passed for the lightweight root, the separately importable
entropy bounds, and the aggregate semantic bridge (2709 jobs). The root import
remains unchanged. The source-derived API index was regenerated with 405 public
declarations, and the website, generated JSON, forbidden-placeholder, and diff
hygiene checks all passed. The dependency blueprint was refreshed without an
import-graph change.

### 74. Opt-In Units and Pressured API Review

Step 13 of Project B Chunk 1 was completed on July 14, 2026. The new
`LeanInfoTheory.Shannon.Units` module is separately importable and leaves every
canonical information measure real-valued and measured in nats. It exposes
only four conversion theorems:

- `Shannon.div_log_change_base`, the generic identity
  `x / log c = log_c(b) * (x / log b)` for bases greater than one;
- `Shannon.negMulLog_div_log`, converting one entropy summand to a
  `Real.logb` expression;
- `Shannon.entropy_div_log`, converting finite PMF entropy to the usual
  `-sum_a p(a) log_b p(a)` formula;
- `Shannon.entropyOf_div_log`, the corresponding pushforward-law formula for
  a finite-valued random variable.

There are no parallel base-indexed definitions of entropy, conditional
entropy, mutual information, or conditional mutual information. The generic
change-of-base theorem applies to any of their nat-valued real results. The
project root does not import `Shannon.Units`; its documentation now points to
the opt-in module.

The Future Work Note 14 review retained every existing declaration and added
compatibility-preserving aliases only where the left/right/both terminology is
already stable. The lightweight chain-rule aliases are:

- `entropy_chain_rule_right` and `entropy_chain_rule_left`;
- `jointEntropyOf_chain_rule_right` and
  `jointEntropyOf_chain_rule_left`.

The pair-inequality aliases are:

- `condEntropy_le_entropy_left`;
- `mutualInfo_le_entropy_left` and `mutualInfo_le_entropy_right`;
- `entropy_left_le_jointEntropy` and `entropy_right_le_jointEntropy`;
- `jointEntropy_le_add_marginalEntropy`;
- `entropyOf_left_le_jointEntropyOf` and
  `entropyOf_right_le_jointEntropyOf`;
- `jointEntropyOf_le_add_entropyOf`.

The deterministic-processing aliases are:

- `mutualInfoOf_comp_both_le`;
- `mutualInfo_map_left_le`, `mutualInfo_map_right_le`, and
  `mutualInfo_map_both_le`.

The conditional-inequality aliases are:

- `condMutualInfo_le_condEntropy_left` and
  `condMutualInfo_le_condEntropy_right`;
- `condEntropy_left_le_condEntropy_pair` and
  `condEntropy_right_le_condEntropy_pair`;
- `condEntropy_pair_le_add_condEntropy`;
- `condEntropyOf_left_le_condEntropyOf_pair` and
  `condEntropyOf_right_le_condEntropyOf_pair`;
- `condEntropyOf_pair_le_add_condEntropyOf`.

The review deliberately did not approve the provisional MI/CMI
entropy-difference aliases, `jointCondEntropy` terminology, shorter fiber
aliases, reverse elementary-MI identities, or a public injective-relabeling
family. Those choices still lack either settled mathematical vocabulary or a
second genuine proof consumer. It also did not add the right-oriented exact
deterministic identity merely for symmetry. The descriptive declarations
remain available as stable implementation-facing names.

Following Future Work Notes 15 and 16, local simp probes were compiled against
representative PMF, random-variable, symmetry, diagonal/self, and
entropy-difference goals. Four strictly reducing rules were promoted:

- `mutualInfo_map_swap` and `condMutualInfo_map_swap12` normalize explicit PMF
  coordinate swaps;
- `mutualInfo_map_diag` removes a diagonal PMF construction;
- `mutualInfoOf_self` removes a random-variable self construction.

Pure random-variable commutativity, entropy-difference identities, and all
ordinary and conditional entropy chain rules remain explicit rewrites. This
avoids arbitrary variable ordering, rewrite cycles, and premature selection
of an expanded entropy normal form.

Focused verification passed for `Shannon.InfoMeasures`, `Shannon.Units`, and
`Shannon.SemanticBridge.Theorems` together (2696 jobs). A separate scratch
probe compiled all four conversion theorems, the global simp behavior, and
representative uses from each alias family; the scratch file was then removed.
An intentionally root-only probe could not resolve `Shannon.entropy_div_log`,
confirming that units remain outside the lightweight root. Downstream builds
for the root, entropy bounds, and aggregate semantic bridge passed together
(2709 jobs). After the final source-diff review, the touched semantic theorem
module and its aggregate entry point were rebuilt once more (2693 and 2694
jobs, respectively).

The source-derived dependency graph and API index were regenerated. The units
module is marked separately importable and not root-reachable, and the API
index contains 434 public declarations, the expected increase of 25 aliases
and four conversion theorems over Step 12. The website/generated-JSON check,
forbidden-placeholder scan, and diff hygiene check all passed. This is still a
targeted Step 13 verification record; Future Work Note 17 reserves the full
certificate/examples/reference milestone suite for Step 14.

The next active task is step 14: update the public status, regenerate all
source-derived references, and run the full milestone verification suite.

### 75. Project B Chunk 1 Milestone Integration

Step 14 and Project B Chunk 1 were completed on July 14, 2026. A final review
covered the accumulated Lean diff, public theorem surface, simp policy, and
module-import boundaries. No corrective Lean edit or architecture change was
needed. The review confirmed that the root-facing layer contains only the
intended lightweight entropy and algebraic information-measure API, while
entropy bounds, logarithm-base conversion, semantic consequences, reference
anchors, and demonstrations remain separately importable.

The complete milestone Lean suite passed sequentially:

- `lake build LeanInfoTheory` (2240 jobs);
- `lake build LeanInfoTheory.Shannon.EntropyBounds` (2650 jobs);
- `lake build LeanInfoTheory.Shannon.Units` (2235 jobs);
- `lake build LeanInfoTheory.Shannon.SemanticBridge` (2694 jobs);
- `lake build LeanInfoTheory.MathlibFragments` (2700 jobs);
- `lake build LeanInfoTheory.Certificate.Submodularity` (1076 jobs);
- `lake build LeanInfoTheory.Certificate.Subadditivity` (1076 jobs);
- `lake build LeanInfoTheory.Certificate.Monotonicity` (1076 jobs);
- `lake build LeanInfoTheory.Certificate.ThreeWaySubadditivity` (1076 jobs);
- `lake build LeanInfoTheory.Examples` (1076 jobs).

The module dependency graph and source-derived API index were regenerated from
the final Lean tree. The index contains 434 documented public declarations,
and the curated theorem-page source anchors were synchronized with it.
The graph records 11 root-reachable modules and 14 separately importable
modules; `Shannon.Units` remains outside the root. The website check passed for
12 HTML files and both generated JSON files. The forbidden-placeholder scan,
root-import audit, scratch-artifact check, stale-status scan, and
`git diff --check` also passed.

Chunk 1 is therefore closed as a coherent milestone. It supplies the finite
pair/triple entropy foundation, support-aware zero/equality contracts,
deterministic processing, textbook MI/CMI identities and inequality bands,
opt-in units, and the reviewed compatibility alias surface. The equality cases
that require general finite KL, independence, or conditional independence stay
deferred as intended, and stochastic channels, Markov structure, and general
data processing remain later work. This closed boundary is the starting point
for the Project B Chunk 2 plan recorded in the next section.

### 76. Project B Chunk 2 Checkpoint and Contract Proof Spikes

Steps 1 and 2 of the revised 18-step Project B Chunk 2 plan were completed on
July 14, 2026. Step 1 preserved the completed Chunk 1 milestone as commit
`7ab3aa0` (`Complete Project B Chunk 1`) and confirmed a clean worktree before
new theorem development. No Chunk 2 code was mixed into that checkpoint.

Step 2 then fixed the Chunk 2 theorem contracts by compiling two temporary
no-placeholder Lean spikes and deleting both scratch files afterward. The main
semantic spike validated all of the following routes:

- `p.toMeasure ≪ q.toMeasure` iff `p.support ⊆ q.support` for PMFs with
  measurable singletons;
- on a finite alphabet, finite KL (`klDiv ≠ ∞`) iff support inclusion, and
  `klDiv = ∞` iff support inclusion fails;
- mathlib's finite-measure theorem gives `klDiv = 0` iff the two PMFs are equal;
- `(klDiv ...).toReal = 0` gives PMF equality only under the explicit
  support-inclusion/finiteness guard, avoiding the `ENNReal.toReal ∞ = 0` trap;
- `I(A;B) = 0` iff the joint PMF equals the independent product of its
  marginals, with the random-variable form obtained from the mapped joint law;
- the mapped-law independence predicate is equivalent to
  `ProbabilityTheory.IndepFun` under explicit measurability and measurable-
  singleton assumptions;
- the generalized uniform-reference identity
  `D(p || uniform(s)) = log |s| - H(p)` under `support(p) ⊆ s`, together with
  its equality consequence;
- a weighted nonnegative fiber sum is zero iff every positive-mass fiber MI is
  zero;
- positive-fiber independence is equivalent to the proof-independent
  cross-product formula
  `p(a,b,c) p_C(c) = p_AC(a,c) p_BC(b,c)`;
- that factorization therefore gives `I(A;B|C) = 0` iff conditional
  independence, including the corresponding mapped-law statement.

A second spike imported only `Shannon.EntropyBounds` and compiled the strict
Jensen equality case
`H(p) = log |alpha| ↔ p = PMF.uniformOfFintype alpha`. This confirms that the
entropy equality API can remain in the existing bounds module without making
it depend on the semantic KL bridge. The support-cardinality result can use the
same strict equality theorem through the existing private support-subtype PMF;
only the finite support finset itself now has enough consumers to become public.

The locked ownership and support conventions are:

- Step 3 promotes `PMF.supportFinset`, with public membership, set-coercion,
  cardinality, and nonemptiness facts in `Probability/Finite.lean`; the stronger
  `supportPMF` construction stays private.
- General finite PMF absolute-continuity, KL finiteness/infinity, KL equality,
  guarded `toReal`, and uniform-reference identities belong in
  `Shannon/SemanticBridge/KL.lean`.
- Alphabet/support entropy equality stays in
  `Shannon/EntropyBounds.lean` and uses strict Jensen.
- Ordinary and conditional independence use the primary names
  `IsIndependent`, `IsIndependentOf`, `IsCondIndependent`, and
  `IsCondIndependentOf` in a new separately importable
  `Shannon/SemanticBridge/Independence.lean` module.
- `IsIndependent` is PMF equality with `indepProd` of the two marginals.
  `IsCondIndependent` is the pointwise cross-product factorization above;
  positive conditional-law independence is secondary and proof-independent by
  equivalence.
- MI/CMI zero theorems hide the locally chosen finite discrete measurable
  structure. Only the explicit bridge to mathlib `IndepFun` exposes
  measurability assumptions.
- The aggregate semantic bridge may import the new independence module, but
  the lightweight root remains unchanged.

The active-phase primary names were also checked for current project/mathlib
collisions and fixed as follows. Step 17 may add compatibility-preserving
aliases, but ordinary theorem steps should retain these declarations:

- support infrastructure: `PMF.supportFinset`, `PMF.mem_supportFinset`,
  `PMF.coe_supportFinset`, `PMF.supportFinset_card`, and
  `PMF.supportFinset_nonempty`;
- KL support/equality: `toMeasure_absolutelyContinuous_iff_support_subset`,
  `klDiv_pmf_ne_top_iff_support_subset`,
  `klDiv_pmf_eq_top_iff_not_support_subset`, `klDiv_pmf_eq_zero_iff`, and
  `toReal_klDiv_pmf_eq_zero_iff`;
- uniformity: `toReal_klDiv_pmf_uniformOfFinset`, its `uniformOfFintype`
  corollary, `entropy_eq_log_card_iff_eq_uniformOfFintype`, and
  `entropy_eq_log_support_ncard_iff_eq_uniformOnSupport`;
- ordinary independence: `isIndependent_iff_apply_eq_mul_marginals`,
  `isIndependentOf_iff_indepFun`, `mutualInfo_eq_zero_iff_isIndependent`, and
  `mutualInfoOf_eq_zero_iff_isIndependentOf`;
- conditional independence: the descriptive positive-fiber extraction and
  factorization families, followed by
  `condMutualInfo_eq_zero_iff_isCondIndependent` and
  `condMutualInfoOf_eq_zero_iff_isCondIndependentOf`.

The strict spike passed with `lake env lean ScratchEntropyStrict.lean`; the
full contract spike passed with `lake env lean ScratchChunk2Contract.lean`.
Neither file remains in the repository. The final targeted command
`lake build LeanInfoTheory.Shannon.EntropyBounds LeanInfoTheory.Shannon.SemanticBridge`
also passed with 2700 jobs. No production Lean declaration was added in this
step, so Future Work Note 14 gained no new public-name entry. The next task is
Step 3, the small public `PMF.supportFinset` API.

### 77. Project B Chunk 2 Finite Support Finset API

Step 3 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
`LeanInfoTheory.Probability.Finite` now exposes the deliberately small finite
support surface fixed by the Step 2 contract:

- `PMF.supportFinset` is the finset of atoms with nonzero PMF mass;
- `PMF.mem_supportFinset` identifies its membership with membership in
  `PMF.support`;
- `PMF.coe_supportFinset` identifies its set coercion with `PMF.support`;
- `PMF.supportFinset_card` identifies its cardinality with
  `p.support.ncard`;
- `PMF.supportFinset_nonempty` records that a PMF has nonempty finite support.

Only membership and set coercion are `[simp]` rules. They reduce the concrete
finset representation to mathlib's canonical set-valued support. Cardinality
and nonemptiness remain explicit so simplification does not choose an
unrequested support-cardinality normal form or synthesize structural facts.

`Shannon.EntropyBounds` now consumes the public support finset and no longer
duplicates its definition, membership theorem, or cardinality theorem. Its
support-restricted `supportPMF` and entropy-preservation proof remain private,
as required by the locked module contract. No theorem statement or root import
changed.

The new public declarations were audited under the standing naming policy.
They form a short, discoverable `PMF.supportFinset` family and do not expose the
private support-PMF machinery, so Future Work Note 14 gained no entry. The
focused build
`lake build LeanInfoTheory.Probability.Finite LeanInfoTheory.Shannon.EntropyBounds`
passed with 2650 jobs. The downstream command
`lake build LeanInfoTheory LeanInfoTheory.Shannon.SemanticBridge` passed with
2703 jobs. The next task is Step 4: characterize finite PMF absolute
continuity, KL finiteness, and KL infinity through support inclusion.

### 78. Project B Chunk 2 KL Support and Finiteness Layer

Step 4 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
`LeanInfoTheory.Shannon.SemanticBridge.KL` now exposes the three support-aware
theorems fixed by the Step 2 contract:

- `toMeasure_absolutelyContinuous_iff_support_subset` proves, for PMFs with
  measurable singletons, that `p.toMeasure ≪ q.toMeasure` is equivalent to
  `p.support ⊆ q.support`;
- `klDiv_pmf_ne_top_iff_support_subset` proves on a finite alphabet that
  `klDiv p.toMeasure q.toMeasure ≠ ⊤` is equivalent to the same inclusion;
- `klDiv_pmf_eq_top_iff_not_support_subset` proves that KL is `⊤` exactly when
  support inclusion fails.

The absolute-continuity theorem is not artificially restricted to a finite
alphabet. Its forward proof tests measurable singleton atoms, and its reverse
proof uses `PMF.toMeasure_apply_eq_zero_iff`. The KL theorems require only the
propositional `[Finite alpha]` assumption: once support inclusion gives
absolute continuity, `Integrable.of_finite` supplies finite-alphabet
integrability of the log-likelihood ratio. An initial `[Fintype alpha]`
statement compiled but triggered mathlib's unused-Fintype linter; replacing it
with `[Finite alpha]` produced the cleaner public contract.

No simp attributes were added. These equivalences move between semantic
representations and should be invoked deliberately rather than selecting a
global normal form. The public-name audit retained all three locked names: each
spells out the relevant mathematical relation and none exposes proof helpers or
representation-specific marginal machinery, so Future Work Note 14 gained no
new entry.

`lake build LeanInfoTheory.Shannon.SemanticBridge.KL` passed with 2692 jobs and
no warnings after the signature refinement. The downstream aggregate command
`lake build LeanInfoTheory.Shannon.SemanticBridge` passed with 2694 jobs. The
lightweight root import remains unchanged. The next task is Step 5: add finite
KL equality and the support-guarded real-valued zero characterization.

### 79. Project B Chunk 2 PMF KL Equality Layer

Step 5 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
`LeanInfoTheory.Shannon.SemanticBridge.KL` now adds the two equality theorems
fixed by the Step 2 contract:

- `klDiv_pmf_eq_zero_iff` states that
  `klDiv p.toMeasure q.toMeasure = 0 ↔ p = q`;
- `toReal_klDiv_pmf_eq_zero_iff` states on a finite alphabet, under
  `p.support ⊆ q.support`, that the real value of the same KL divergence is
  zero exactly when `p = q`.

The first result specializes mathlib's converse Gibbs theorem
`InformationTheory.klDiv_eq_zero_iff` and uses injectivity of
`PMF.toMeasure`. It needs measurable singletons but no finite-alphabet
assumption because PMF measures are already finite measures. A separate
project-level KL nonnegativity wrapper was intentionally not added:
`InformationTheory.klDiv` is `ENNReal`-valued, so nonnegativity is built into
its codomain and `ENNReal.toReal_nonneg` already supplies the real consequence.

The second result deliberately consumes Step 4's
`klDiv_pmf_ne_top_iff_support_subset`. Its forward proof expands
`ENNReal.toReal_eq_zero_iff` and excludes the `KL = ⊤` branch using support
inclusion. This guard is part of the mathematical contract, not merely a proof
convenience: without it, infinite KL divergence would also have real value
zero.

Neither theorem is a simp rule. KL equality is an explicit semantic rewrite,
and automatically rewriting a real KL zero through side conditions would be
unpredictable. The locked names distinguish the unconditional `ENNReal`
statement from the guarded real-valued statement without exposing local proof
machinery, so the Step 5 naming audit added no Future Work Note 14 entry.

The focused command
`lake build LeanInfoTheory.Shannon.SemanticBridge.KL` passed with 2692 jobs and
no warnings. The aggregate command
`lake build LeanInfoTheory.Shannon.SemanticBridge` passed with 2694 jobs. The
root import remains unchanged. The next task is Step 6: prove KL divergence to
`PMF.uniformOfFinset` and its full-alphabet corollary.

### 80. Project B Chunk 2 Uniform-Reference KL Identities

Step 6 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
`LeanInfoTheory.Shannon.SemanticBridge.KL` now exposes:

- `toReal_klDiv_pmf_uniformOfFinset`, the generalized identity
  `D(P || U_s) = log |s| - H(P)` for a nonempty finset `s` under the explicit
  assumption `p.support ⊆ s`;
- `toReal_klDiv_pmf_uniformOfFintype`, the full-alphabet specialization
  `D(P || U_alpha) = log |alpha| - H(P)`.

The generalized proof first converts support inclusion into absolute
continuity through Step 4, then uses the existing finite KL sum expansion. For
each positive-mass atom, support inclusion identifies the uniform denominator
as `|s|⁻¹`; zero-mass atoms vanish separately. The resulting finite sum splits
using total PMF mass one and the defining entropy sum. The full-alphabet result
is a direct specialization to `Finset.univ`.

`Mathlib.Probability.Distributions.Uniform` is now imported directly by the
already-heavy KL bridge. `Shannon.EntropyBounds` remains independent of the
semantic KL layer, and the lightweight root import is unchanged. Neither new
identity is a simp rule because both are deliberate semantic normal-form
rewrites with substantial right-hand sides.

The Step 6 public-name audit retained the locked
`toReal_klDiv_pmf_uniformOfFinset`/`...uniformOfFintype` family. The names make
the real-valued KL codomain and exact mathlib uniform construction explicit;
they expose no local proof helpers, so Future Work Note 14 gained no entry.

The Step 5 explicit-finiteness abstraction was also rechecked. Step 5 remains
the sole production proof that assumes `klDiv ≠ ⊤` and manually eliminates the
`⊤` branch of `ENNReal.toReal_eq_zero_iff`; Step 6 uses absolute continuity and
the finite KL sum expansion instead. The threshold of two production proofs is
therefore unmet, and the provisional
`toReal_klDiv_pmf_eq_zero_iff_of_ne_top` theorem was not added. Future Work
Note 22 records this standing pressure test.

The temporary Step 6 proof file compiled and was deleted before production
integration. `lake build LeanInfoTheory.Shannon.SemanticBridge.KL` passed with
2697 jobs, and `lake build LeanInfoTheory.Shannon.SemanticBridge` passed with
2699 jobs. A final combined rebuild of both targets passed again with 2699
jobs, with no lingering Lean process or scratch file. The next task is Step 7:
complete the alphabet- and support-cardinality entropy equality cases and their
random-variable forms.

### 81. Project B Chunk 2 Sharp Finite Entropy Bounds

Step 7 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
`LeanInfoTheory.Shannon.EntropyBounds` now exposes four equality
characterizations:

- `entropy_eq_log_card_iff_eq_uniformOfFintype` says that a PMF reaches the
  alphabet-cardinality bound exactly when it is uniform on the alphabet;
- `entropy_eq_log_support_ncard_iff_eq_uniformOnSupport` says that a PMF reaches
  the support-cardinality bound exactly when it is uniform on its support;
- `entropyOf_eq_log_card_iff_map_eq_uniformOfFintype` and
  `entropyOf_eq_log_support_ncard_iff_map_eq_uniformOnSupport` give the
  corresponding mapped-law statements for finite-valued random variables.

The alphabet theorem uses the equality case of strict Jensen for
`Real.negMulLog`, forcing all real atom masses to equal the uniform average and
then lifting that pointwise equality back to `ENNReal`. The support theorem
applies the alphabet result to the existing private support-restricted PMF and
transfers the result back to the original law. A private
`entropy_uniformOfFinset` calculation supplies the reverse direction without
enlarging the public API.

This proof route preserves the locked module boundary: `EntropyBounds` still
depends on Jensen and uniform-distribution tools, not the semantic KL bridge.
The lightweight root import is unchanged. The two PMF names retain the locked
support-explicit contract. The two random-variable names are descriptive but
long and expose `PMF.map`; their compatibility-preserving alias sketches are
recorded in Future Work Note 14 for the planned Step 17 API review. No
declaration was renamed during theorem development.

The temporary complete proof probe passed and was deleted. The production
command `lake build LeanInfoTheory.Shannon.EntropyBounds` passed with 2650 jobs
and no warnings. Step 7 did not use the explicit-finiteness KL branch-
elimination pattern from Future Work Note 22, so its production-proof count
remains one. The next task is Step 8: introduce ordinary finite PMF and
random-variable independence predicates.

### 82. Project B Chunk 2 Ordinary Independence Predicates

Step 8 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026. A
new separately importable module,
`LeanInfoTheory.Shannon.SemanticBridge.Independence`, now exposes:

- `IsIndependent`, stating that a joint PMF equals `indepProd` of its two
  marginals;
- `IsIndependentOf`, applying `IsIndependent` to the mapped joint law of two
  random variables;
- `isIndependent_iff_apply_eq_mul_marginals`, the locked pointwise
  factorization characterization;
- `isIndependent_indepProd`, showing that an explicitly constructed
  independent product is independent;
- `isIndependent_map_swap` and `isIndependentOf_swap`, giving PMF and
  random-variable symmetry;
- `isIndependentOf_iff_map_eq_indepProd`, exposing the useful joint-law/product-
  law normal form for random variables.

The predicates and all Step 8 theorems require no measurable-space or finiteness
instances: the PMF equality contract is meaningful at that generality, while
later information-measure consequences can add finite-alphabet assumptions.
The explicit bridge to mathlib `ProbabilityTheory.IndepFun` remains assigned to
Step 9, where its measurability assumptions will be visible rather than hidden
inside these definitions.

The aggregate `LeanInfoTheory.Shannon.SemanticBridge` now imports the new
module and documents the predicates. `LeanInfoTheory.lean` remains unchanged,
so ordinary independence does not enlarge the lightweight root. The only new
simp theorems are `isIndependent_indepProd`, which removes a canonical
constructor, and `isIndependent_map_swap`, which removes an explicit
coordinate swap; the random-variable symmetry theorem remains an explicit
rewrite to avoid a commutativity loop.

The naming audit retained the locked predicate and pointwise-factorization
names. `isIndependentOf_iff_map_eq_indepProd` is useful but exposes the mapped-
law representation, so Future Work Note 14 records it with a provisional
textbook-facing alias sketch for the Step 17 review. The swap theorem is short
and names the exact operation it normalizes, so it does not need an alias merely
to hide `map`.

The temporary complete proof probe compiled and was deleted. Focused builds
passed for `LeanInfoTheory.Shannon.SemanticBridge.Independence` with 2272 jobs
and for the aggregate `LeanInfoTheory.Shannon.SemanticBridge` with 2700 jobs.
Step 8 did not use the explicit-finiteness KL branch-elimination pattern from
Future Work Note 22, whose production-proof count remains one. The next task is
Step 9: bridge mapped-law independence to mathlib
`ProbabilityTheory.IndepFun`.

### 83. Project B Chunk 2 Mathlib Independence Bridge

Step 9 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
`LeanInfoTheory.Shannon.SemanticBridge.Independence` now exposes the locked
bridge theorem `isIndependentOf_iff_indepFun`:

```text
IsIndependentOf p X Y ↔ ProbabilityTheory.IndepFun X Y p.toMeasure
```

The theorem assumes measurable spaces on the source and both codomains,
measurable singletons on the codomains, and explicit proofs that `X` and `Y`
are measurable. These assumptions stay at the semantic boundary; the Step 8
PMF-first predicates remain free of measurable-space instances.

The proof uses mathlib's
`ProbabilityTheory.indepFun_iff_map_prod_eq_prod_map_map`, rewrites each
pushforward measure with `PMF.toMeasure_map`, rewrites the product measure with
`indepProd_toMeasure`, and closes by injectivity of `PMF.toMeasure`. The module
now imports `Mathlib.Probability.Independence.Basic` directly. No local
measure-theoretic independence definition or hidden discrete measurable-space
choice was introduced.

The public-name audit retained the locked `isIndependentOf_iff_indepFun` name:
it is concise, uses mathlib's canonical predicate name, and exposes no local
proof machinery, so Future Work Note 14 gained no entry. The theorem is not a
simp rule because rewriting it automatically would choose between the PMF and
measure-theoretic independence representations globally.

The temporary proof probe compiled and was deleted. The production build
`lake build LeanInfoTheory.Shannon.SemanticBridge.Independence` passed with 2318
jobs, and `lake build LeanInfoTheory.Shannon.SemanticBridge` passed with 2700
jobs. Step 9 did not repeat the explicit-KL-finiteness branch-elimination
pattern tracked by Future Work Note 22, so its production-proof count remains
one. The next task is Step 10: characterize zero mutual information by ordinary
independence.

### 84. Project B Chunk 2 Zero Mutual Information

Step 10 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
`LeanInfoTheory.Shannon.SemanticBridge.Independence` now exposes the two locked
textbook equivalences:

- `mutualInfo_eq_zero_iff_isIndependent`, stating
  `mutualInfo p = 0 ↔ IsIndependent p` for a finite joint PMF;
- `mutualInfoOf_eq_zero_iff_isIndependentOf`, giving the corresponding result
  for two finite-valued random variables without requiring the source type to
  be finite.

The PMF proof locally installs the discrete measurable space on the product
alphabet and a measurable-singleton instance, then rewrites mutual information
as real-valued KL divergence to `indepProd` of the marginals. The existing joint-
to-product absolute-continuity theorem and Step 4 support characterization
supply the support-inclusion guard required by Step 5's
`toReal_klDiv_pmf_eq_zero_iff`; that theorem reduces zero real KL to equality
with the independent product. The random-variable theorem is the mapped-law
specialization. No measurable-space assumptions leak into either public
statement.

The independence module now imports `Shannon.SemanticBridge.KL` instead of its
lighter `Product` predecessor; KL already imports the product infrastructure,
and the dependency remains acyclic. The aggregate semantic bridge still imports
the independence module explicitly, while `LeanInfoTheory.lean` remains
unchanged. Neither zero equivalence is a simp rule: automatic rewriting would
globally choose independence over the numeric mutual-information normal form.

The public-name audit retained both locked names. Their length reflects the
established PMF versus random-variable `...Of` distinction and the direct
mathematical equivalence; neither exposes marginals, coordinate maps, or local
proof helpers, so Future Work Note 14 gained no entry.

The temporary combined PMF/RV proof probe compiled and was deleted. The
production build
`lake build LeanInfoTheory.Shannon.SemanticBridge.Independence` passed with 2698
jobs, and the aggregate `lake build LeanInfoTheory.Shannon.SemanticBridge`
passed with 2700 jobs. Step 10 calls the existing guarded real-KL zero theorem;
it does not directly assume `klDiv ≠ ⊤` or manually eliminate the top branch
of `ENNReal.toReal_eq_zero_iff`. Future Work Note 22 therefore remains at one
production consumer of that manual pattern. The next task is Step 11: close the
pair-level independence equality cases.

### 85. Project B Chunk 2 Pair Independence Equality Cases

Step 11 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
`LeanInfoTheory.Shannon.SemanticBridge.Independence` now exposes four equality
characterizations:

- `condEntropy_eq_entropy_left_iff_isIndependent` states
  `H(A|B) = H(A)` iff the joint PMF is independent;
- `condEntropyOf_eq_entropyOf_iff_isIndependentOf` gives the corresponding
  random-variable theorem;
- `jointEntropy_eq_add_marginalEntropy_iff_isIndependent` states that joint
  entropy is additive iff the two coordinates are independent;
- `jointEntropyOf_eq_add_entropyOf_iff_isIndependentOf` gives the mapped-law
  form.

Both PMF proofs rewrite the target equality into `mutualInfo p = 0` using the
existing entropy identities, then invoke Step 10. The random-variable theorems
are direct mapped-law specializations. No new analytic or measure-theoretic
argument is needed, and the independence module continues to import `KL`
directly rather than widening its dependency to the full semantic theorem
module.

This step deliberately closes only the endpoints governed by independence.
Equality in the MI upper bounds or marginal-to-joint lower bounds instead means
zero conditional entropy and support-wise functional dependence; those are not
independence statements, and the existing zero-conditional-entropy API remains
their correct foundation. Symmetric conditioning orientations are obtained by
swapping variables through the Step 8 symmetry theorems rather than by adding
duplicate public declarations.

None of the four equivalences is a simp rule because automatic rewriting would
choose independence as the global normal form for entropy equalities. The names
use the approved `left` and `add_marginalEntropy` vocabulary, but are long enough
to merit a coherent Step 17 review. Future Work Note 14 records all four and the
provisional shorter `jointEntropy_additive_iff_isIndependent`/`...Of` pair; no
declaration was renamed during the active theorem phase.

The temporary four-theorem proof probe compiled and was deleted. Focused builds
passed for `LeanInfoTheory.Shannon.SemanticBridge.Independence` with 2698 jobs
and the aggregate `LeanInfoTheory.Shannon.SemanticBridge` with 2700 jobs. Step
11 uses only algebraic identities and Step 10, so it does not repeat the manual
real-KL top-branch pattern tracked by Future Work Note 22. The next task is Step
12: extract pointwise positive-fiber zero MI from averaged conditional mutual
information.

### 86. Project B Chunk 2 Positive-Fiber Zero Mutual Information

Step 12 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
`LeanInfoTheory.Shannon.SemanticBridge.Independence` now exposes

- `condMutualInfo_eq_zero_iff_condMutualInfoFstSndGivenThird_eq_zero`, stating
  that `condMutualInfo p = 0` iff every `c` with
  `thirdMarginal p c != 0` has
  `condMutualInfoFstSndGivenThird p c = 0`.

The forward proof rewrites conditional mutual information as the finite sum
`sum_c P_C(c) I(A;B|C=c)`. Every summand is nonnegative by the existing fiber
nonnegativity theorem, so a zero total forces each weighted fiber term to be
zero. On a nonzero PMF atom, `ENNReal.toReal_pos` shows that the real marginal
weight is nonzero and can be cancelled. Conversely, null fibers have zero
weight, while every positive-mass fiber vanishes by hypothesis, so the whole
sum is zero. The theorem uses the established PMF-level nonzero-marginal guard
rather than exposing a real-valued positivity condition.

This step adds only the PMF equivalence needed by the next conditional-
independence proofs. It does not introduce `IsCondIndependent`, add a mapped-
law wrapper before that predicate exists, or promote a generic weighted-sum
lemma with only one production consumer. To use the existing fiber
nonnegativity theorem, the independence module now imports
`Shannon.SemanticBridge.Theorems` instead of `KL`; the dependency remains
acyclic, the aggregate semantic bridge remains separately importable, and the
lightweight root is unchanged.

The public name accurately exposes the existing fiber object but is unusually
long and implementation-facing. Future Work Note 14 records it with the
provisional compatibility alias sketch
`condMutualInfo_eq_zero_iff_fiberwise_zero` for the planned Step 17 review. No
declaration was renamed and no simp attribute was added.

The temporary complete proof probe passed and was deleted. Focused builds
passed for `LeanInfoTheory.Shannon.SemanticBridge.Independence` with 2699 jobs
and the aggregate `LeanInfoTheory.Shannon.SemanticBridge` with 2700 jobs. The
proof uses only the averaged finite-sum identity, PMF finiteness, and semantic
nonnegativity, so it does not repeat the real-KL top-branch elimination tracked
by Future Work Note 22. The next task is Step 13: introduce conditional
independence by cross-product factorization and prove its positive-fiber
characterization.

### 87. Project B Chunk 2 Conditional Independence Predicates

Step 13 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
`LeanInfoTheory.Shannon.SemanticBridge.Independence` now exposes the locked
conditional-independence predicates and their first semantic characterization:

- `IsCondIndependent p` is the atomwise cross-product identity
  `p(a,b,c) * p_C(c) = p_AC(a,c) * p_BC(b,c)`;
- `IsCondIndependentOf p X Y Z` applies that predicate to the mapped triple
  law of the three random variables;
- `isCondIndependent_iff_isIndependent_condFstSndGivenThird` states that the
  PMF predicate is equivalent to `IsIndependent` for every positive-mass
  conditional joint law `P_{A,B|C=c}`.

Both definitions are proof-independent and require no finite-alphabet
assumptions. The fiber theorem needs `[Fintype alpha] [Fintype beta]` to build
the finite conditional joint law, but it deliberately requires no
`[Fintype gamma]`: the characterization is pointwise in the conditioning
value and does not form a sum over the conditioning alphabet.

On a positive fiber, the forward proof rewrites ordinary independence into
pointwise marginal factorization. Multiplying conditional joint and marginal
masses by `p_C(c)` recovers the original triple and pair-marginal masses; two
applications of finite nonzero `ENNReal` multiplication cancellation then
turn the defining cross-product identity into conditional-law factorization.
The reverse direction performs the same calculation without division. On a
null fiber, the corresponding `(A,C)` marginal atom is zero, so the
cross-product identity holds automatically and no arbitrary conditional PMF is
chosen.

This step deliberately adds no conditional-independence symmetry or closure
theorems, mathlib `CondIndepFun` bridge, mapped-law positive-fiber wrapper, or
ordinary-independence convenience declarations. Steps 14 and 15 can first
establish which of those forms, if any, receive real proof pressure. Neither
predicate is a reducible abbreviation or simp rule; users can unfold the
cross-product definition explicitly when atomwise reasoning is intended.

The locked predicate names are concise and expose the mathematical concept.
The positive-fiber theorem name is descriptive but long and exposes
`condFstSndGivenThird`; Future Work Note 14 records it with the provisional
compatibility alias sketch
`isCondIndependent_iff_fiberwise_isIndependent` for the Step 17 review. No
declaration was renamed during active theorem development.

The temporary complete proof probe passed and was deleted. Focused builds
passed for `LeanInfoTheory.Shannon.SemanticBridge.Independence` with 2699 jobs
and the aggregate `LeanInfoTheory.Shannon.SemanticBridge` with 2700 jobs. This
step works entirely with PMF masses and `ENNReal` cancellation, so it does not
repeat the real-KL top-branch pattern tracked by Future Work Note 22. The next
task is Step 14: characterize zero conditional mutual information by
`IsCondIndependent` and `IsCondIndependentOf`.

### 88. Project B Chunk 2 Zero Conditional Mutual Information

Step 14 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
`LeanInfoTheory.Shannon.SemanticBridge.Independence` now exposes the two locked
textbook equivalences:

- `condMutualInfo_eq_zero_iff_isCondIndependent`, stating
  `condMutualInfo p = 0 <-> IsCondIndependent p` for a finite triple PMF;
- `condMutualInfoOf_eq_zero_iff_isCondIndependentOf`, giving the corresponding
  result for three finite-valued random variables without requiring the source
  type to be finite.

The PMF proof composes the existing semantic layers rather than reopening KL.
Step 12 turns zero averaged conditional mutual information into zero mutual
information on every positive-mass fiber. Step 10 identifies zero mutual
information of each conditional joint PMF with ordinary independence, and
Step 13 identifies that fiberwise independence family with the proof-
independent cross-product predicate. The random-variable theorem is the direct
mapped-triple-law specialization. No measurable-space assumptions or
conditional-PMF proof terms appear in either public statement.

Neither equivalence is a simp rule: automatic rewriting would globally choose
conditional independence over the numeric conditional-mutual-information
normal form. The public-name audit retained both locked names. They follow the
established PMF versus random-variable `...Of` pattern, directly state the
mathematical equivalence, and expose no marginals, coordinate maps, fiber
helpers, or local proof machinery, so Future Work Note 14 gained no entry.

The temporary combined PMF/RV proof probe compiled and was deleted. Focused
builds passed for `LeanInfoTheory.Shannon.SemanticBridge.Independence` with 2699
jobs and the aggregate `LeanInfoTheory.Shannon.SemanticBridge` with 2700 jobs.
Step 14 invokes the existing ordinary zero-MI theorem but does not directly
inspect KL or repeat the manual `ENNReal.toReal_eq_zero_iff` top-branch
elimination. Future Work Note 22 therefore remains at one production consumer.
The next task is Step 15: close the conditional-entropy equality cases governed
by conditional independence.

### 89. Project B Chunk 2 Conditional-Independence Equality Cases

Step 15 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
`LeanInfoTheory.Shannon.SemanticBridge.Independence` now exposes the four
conditional-entropy equality characterizations governed by conditional
independence:

- `condEntropy_eq_condEntropy_fstThirdMarginal_iff_isCondIndependent`;
- `condEntropyOf_eq_condEntropyOf_iff_isCondIndependentOf`;
- `condEntropy_pair_eq_add_condEntropy_iff_isCondIndependent`;
- `condEntropyOf_pair_eq_add_condEntropyOf_iff_isCondIndependentOf`.

The first PMF/random-variable pair states that additionally conditioning the
first variable on the second preserves its entropy given the third exactly
under conditional independence. The second pair states that conditional joint
entropy is additive exactly under conditional independence. These are precisely
the conditional-independence endpoints of the conditional entropy band. The
other endpoints reduce to zero conditional entropy and support-wise functional
dependence, so they were deliberately left outside this step.

All four proofs reuse the Step 14 zero-CMI equivalences and the established
conditional-mutual-information entropy identities. They are short algebraic
arguments and do not reopen the fiber, cross-product, or KL proofs. None is a
`[simp]` rule because the equalities and conditional-independence predicates
are alternative mathematical normal forms rather than strictly reducing
rewrites.

The naming audit preserved all four declarations during active theorem
development. The names are descriptive but long, and the PMF statements expose
`fstThirdMarginal`, `pairThirdLaw`, and marginal representation details. Future
Work Note 14 records them for the planned Step 17 compatibility-preserving API
review; no declaration was renamed in this step.

The temporary complete proof probe passed and was deleted. Focused builds
passed for `LeanInfoTheory.Shannon.SemanticBridge.Independence` with 2699 jobs
and the aggregate `LeanInfoTheory.Shannon.SemanticBridge` with 2700 jobs. The
proofs use only finite entropy identities and the Step 14 public equivalences,
so Future Work Note 22 remains at one production consumer. The next task is
Step 16: add the planned support-sensitive and non-absolutely-continuous
examples in separately importable example modules.

### 90. Project B Chunk 2 Support-Sensitive Examples

Step 16 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
Two new opt-in example modules exercise the completed support-aware API without
changing a core theorem statement or the lightweight root import.

`LeanInfoTheory.Examples.SupportSensitive` supplies five concrete pressure
tests:

- a uniform law on two points of a three-point ambient alphabet proves that
  `entropy_le_log_support_ncard` gives a strictly smaller upper bound than
  `entropy_le_log_card`;
- `supportEncoding` is not globally injective but is injective on the law's
  support, so `supportEncoding_preserves_entropy` follows from
  `entropyOf_comp_eq_iff_injOn_support`;
- `functionalDependence_on_support` proves zero conditional entropy from a
  functional relation on the source support, while
  `functionalDependence_not_global` exhibits its failure at the unsupported
  ambient point;
- `nullFiber_zero` records the numeric-zero convention on a null conditioning
  fiber, while the positive fiber is proved pure and then zero through
  `condEntropyFstGivenSnd_eq_zero_iff_of_sndMarginal_ne_zero`;
- `forgetSecond_loses_entropy` proves genuine ordinary information loss, while
  `sideInfo_preserves_condEntropy` supplies a decoder and recovers the exact
  conditional-entropy equality through
  `condEntropyOf_comp_eq_iff_exists_recovery`.

`LeanInfoTheory.Examples.KLTop` uses two disjoint pure Boolean laws. It proves
that the first law is not absolutely continuous with respect to the second,
their `ENNReal`-valued KL divergence is `⊤`, the laws are unequal, and yet the
real value obtained with `ENNReal.toReal` is zero. This is the concrete failure
mode excluded by the support hypothesis of
`toReal_klDiv_pmf_eq_zero_iff`.

The examples use only public theorem contracts. They did not require the
private deterministic-entropy decomposition, a canonical `uniformOnSupport`
definition, a general real-KL finiteness helper, or new independence
convenience lemmas. `LeanInfoTheory.Examples` imports both modules as an opt-in
aggregate, while each new module remains separately importable and
`LeanInfoTheory.lean` remains unchanged.

The Step 16 public-name audit found no new core-facing naming problem. The
example declarations are short within descriptive namespaces and expose the
mathematical point of each construction rather than private marginal, fiber,
or coordinate-swap machinery, so Future Work Note 14 gained no entry.

The temporary complete proof spike passed, was strengthened to prove the
positive conditional fiber actually pure and zero, passed again, and was
deleted. The focused build of `LeanInfoTheory.Examples.SupportSensitive`,
`LeanInfoTheory.Examples.KLTop`, and the `LeanInfoTheory.Examples` aggregate
passed with 2707 jobs. The source-derived references were regenerated. The API
index now contains 507 declarations, including 33 in the two new example
modules, and the graph records 28 modules and 41 local edges; all three example
modules remain outside the 11-module root-reachable set. The website checker
passed for 12 HTML files and both generated JSON files. A fresh-file import
smoke test also referenced the headline KL, support-bound, and side-information
results successfully, then its temporary file was deleted.

The next task is Step 17: perform the planned API, compatibility-alias, simp-
policy, module-pressure, and deferred-relabeling review against the complete
Chunk 2 theorem and example corpus.

### 91. Project B Chunk 2 API and Module Review

Step 17 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
The review checked the complete Future Work Note 14 watchlist against the
finished theorem corpus and Step 16 examples, searched both the project and the
pinned mathlib checkout for collisions, compiled exact theorem-shape probes,
and preserved every existing declaration.

Four compatibility-preserving aliases were approved because `additive` is
stable textbook vocabulary and the PMF/random-variable families line up
without hiding an orientation:

- `jointEntropy_additive_iff_isIndependent`;
- `jointEntropyOf_additive_iff_isIndependentOf`;
- `condEntropy_pair_additive_iff_isCondIndependent`;
- `condEntropyOf_pair_additive_iff_isCondIndependentOf`.

The aliases are exact wrappers around the descriptive Step 11 and Step 15
theorems. They live in the separately importable independence module, add no
imports, and carry no `[simp]` attributes. The original names remain the stable
descriptions of their full equality statements.

The review deliberately did not approve the remaining provisional aliases.
`uniformLaw` and `jointLaw` are not established project vocabulary and were not
needed by the examples. The two `fiberwise` sketches would compete with the
main zero-CMI/conditional-independence theorem while hiding which conditional
PMF helper appears in the underlying statement. No clear shorter name emerged
for conditioning-preserves-conditional-entropy, and the older MI/CMI
entropy-difference, reverse elementary-MI, and right-oriented deterministic
identity proposals still have no repeated consumer.

The simp review retained the existing policy. Swap and diagonal/self rules
that remove explicit constructions remain `[simp]`; commutativity, entropy
chain rules, KL/support equivalences, independence equivalences, zero-MI/CMI
characterizations, and all equality cases remain explicit. The Step 16 proofs
did not reveal a canonical entropy-expanded normal form or a new strictly
reducing rewrite.

The module-pressure review also retained the architecture. `InfoMeasures` and
`SemanticBridge.Theorems` are large but still coherent single-purpose files;
KL and independence already have separate opt-in modules, and the examples are
split by subject. Splitting those files now would create import and compatibility
churn without isolating a new mathematical dependency. Future stochastic-
channel, Markov, and data-processing work should enter new focused modules
rather than enlarging the lightweight root.

Future Work Note 21's injective mutual-information relabeling family remains
deferred. The private augmentation proof still has only one genuine consumer;
Step 16 used the public entropy support-injectivity theorem and did not repeat
that MI argument. The support-aware versus globally injective contract and
module ownership therefore remain intentionally unresolved. The general
real-KL `..._of_ne_top` helper likewise remains unjustified at one production
consumer.

The temporary four-alias proof probe passed and was deleted. Focused builds of
`LeanInfoTheory.Shannon.SemanticBridge.Independence` and the aggregate
`LeanInfoTheory.Shannon.SemanticBridge` passed with 2700 jobs. A fresh-file
consumer probe imported the production module and applied every alias to
concrete Boolean laws; it passed and was deleted. The source-derived references
were regenerated: the API index now contains 511 declarations, exactly four
more than Step 16, while the dependency graph remains at 28 modules, 41 local
edges, and 11 root-reachable modules. The website checker passed for 12 HTML
files and both generated JSON files. The generated summaries for entropy
bounds, the KL bridge, the independence module, and the semantic aggregate were
also refreshed to describe the completed Chunk 2 ownership accurately; no
layer or import edge changed.

At the end of Step 17, the remaining task was Step 18: integrate Chunk 2,
regenerate final references, run the complete milestone suite and hygiene
checks, and make the Chunk 2 checkpoint.

### 92. Project B Chunk 2 Milestone Integration

Step 18 of the 18-step Project B Chunk 2 plan was completed on July 14, 2026.
The final review confirmed that the accumulated source, examples,
documentation, generator, and generated-reference changes are all part of the
planned Chunk 2 milestone. `LeanInfoTheory.lean` has no diff, and the heavier
entropy-bound, semantic, example, certificate-demo, and reference layers remain
separately importable.

The complete milestone build suite passed:

- `lake build LeanInfoTheory` (2240 jobs);
- `lake build LeanInfoTheory.Shannon.EntropyBounds` (2650 jobs);
- `lake build LeanInfoTheory.Shannon.Units` (2235 jobs);
- `lake build LeanInfoTheory.Shannon.SemanticBridge` (2700 jobs);
- `lake build LeanInfoTheory.MathlibFragments` (2700 jobs);
- each of `Certificate.Submodularity`, `Certificate.Subadditivity`,
  `Certificate.Monotonicity`, and `Certificate.ThreeWaySubadditivity` (1076
  jobs each);
- `lake build LeanInfoTheory.Examples` (2707 jobs).

Both source-derived reference generators then passed. The declaration index
contains 511 documented public declarations, and the dependency graph contains
28 modules and 41 local import edges: 11 modules are root-reachable and 17
remain separately importable. The website checker passed for 12 HTML files and
both generated JSON files.

The repository hygiene pass found no forbidden placeholders, scratch Lean
files, or temporary `test_` declarations. `git diff --check` passed, the root
import remained unchanged, and no Lean or Lake process was left running. This
closes all 18 Chunk 2 steps and prepares the coherent `Complete Project B Chunk
2` checkpoint.

Step 18 added no public Lean declaration, so the Future Work Note 14 naming
watchlist is unchanged. It also added no KL proof and created no second consumer
for the deferred general real-KL `..._of_ne_top` helper.

Chunk 2 now supplies the finite support/KL equality layer, uniform-reference
identities, sharp finite entropy equality cases, ordinary and conditional
independence semantics, zero-MI and zero-CMI characterizations, their entropy
equality consequences, and support-sensitive examples. The next theorem phase
is intentionally not assumed by this checkpoint. Before editing Lean again,
review the Project B formalization map and live future-work notes and define a
focused next chunk; stochastic channels, Markov structure, and data processing
are the leading dependency-layer candidate.

### 93. Post-Chunk 2 Status and Backlog Cleanup

The three-step post-Chunk-2 documentation cleanup was completed on July 14,
2026. `docs/current-lean-state.md` now labels the finished Chunk 2 and earlier
nine-step plans as completed, and its locked Chunk 2 contract describes the
implemented conditional-independence ownership rather than calling that layer
planned.

`docs/foundation-conventions.md` now records the completed API-review and
triple-inequality results and replaces the stale near-term targets with the
current stochastic-channel, Markov, and data-processing direction. The Future
Work Notes retain all 28 numbers and detailed triggers but now have a compact
status index. Note 20 is explicitly closed, while Notes 21, 25, 26, and 27 are
clearly identified as consumer-triggered Chunk 3 watch items rather than
pre-Chunk-3 implementation tasks.

This pass changed no Lean source, theorem statement, public name, import,
website source, generator, or generated artifact. The final stale-status and
note-number scans passed, `git diff --check` passed, and the changed-file review
contained only the three intended documentation files. No Lake build or
website regeneration was needed for this documentation-only checkpoint.

### 94. Project B Chunk 3 Contract and Proof Spikes

Step 1 of the revised 20-step Project B Chunk 3 plan was completed on July 14,
2026. The phase starts from the clean post-Chunk-2 checkpoint `e72e68c` and is
focused on finite stochastic channels, Markov chains, mutual-information data
processing and its equality case, finite KL contraction, and the immediate
invariant-law and entropy consequences. Full sufficient-statistic, recovery,
Fano, channel-process, capacity, finite-family, and certificate extensions
remain outside this chunk as recorded in Future Work Note 29 and the existing
later-work notes.

Before any production declaration was added, the temporary no-placeholder
file `ScratchChunk3Contract.lean` compiled against the current API and was then
deleted. The spike validated all of the following contracts:

- a finite discrete channel can remain the raw mathlib-native function type
  `alpha -> PMF beta`, with output law `p.bind W`;
- channel composition is PMF bind composition, and deterministic channels
  specialize definitionally to `PMF.map` through `PMF.bind_pure_comp`;
- an input-output joint law built by binding and mapping to `(a,b)` elaborates
  without a new channel structure;
- a total conditional channel can use `fstMarginal p` on a null second-
  marginal fiber and `condFstGivenSnd` on a positive fiber;
- this total channel satisfies the atomwise reconstruction identity
  `p_B(b) * P_{A|B=b}(a) = p(a,b)` on both branches, so no extra
  `Nonempty alpha` assumption or proof-valued channel argument is needed;
- the PMF and random-variable Markov orientations can use the primary names
  `IsMarkovChain` and `IsMarkovChainOf`, with `X -> Y -> Z` represented by
  `IsCondIndependentOf p X Z Y`;
- the Markov predicate is therefore exactly the existing zero-CMI condition
  `I(X;Z|Y) = 0`;
- the two existing random-variable MI chain rules prove the exact loss identity
  `I(X;Y) = I(X;Z) + I(X;Y|Z)` under `X -> Y -> Z`;
- CMI nonnegativity then proves `I(X;Z) <= I(X;Y)`, and the existing zero-CMI
  equivalence proves equality exactly when `X -> Z -> Y`.

The locked representation and ownership policy is conservative. Generic PMF
channel mechanics should live in a new opt-in
`LeanInfoTheory.Probability.FiniteChannel` module. It should use raw functions
and existing `PMF.bind`, `PMF.pure`, and `PMF.map` operations rather than a new
channel structure; only repeated joint, extension, composition, and total-
conditioning constructions should receive project definitions. Markov and MI
results should live in a separately importable
`Shannon.SemanticBridge.Markov` module. The later kernel and KL bridge should
live in `Shannon.SemanticBridge.DataProcessing`, subject to the dedicated Step
13 proof checkpoint. The aggregate semantic bridge may import the new modules,
but `LeanInfoTheory.lean` must remain unchanged.

Channel operations remain type-generic where mathlib permits. The total
conditional channel needs finiteness only for the conditioned alphabet because
the existing `condFstGivenSnd` has that contract. Markov predicates themselves
need no measurable-space or finite-alphabet assumptions. `Fintype` assumptions
enter the MI/CMI theorem layer, while explicit measurable-space and measurable-
singleton assumptions remain confined to the later kernel/KL bridge. The
primary KL data-processing theorem will be `ENNReal`-valued; real-valued forms
must retain explicit support/finiteness guards.

The active plan is now fixed as follows. Step 1 is complete; Steps 2 through 20
are pending.

1. Lock the contract, compile the channel/Markov/MI spikes, and record the plan
   and deferred work.
2. Introduce the opt-in finite-channel core using raw PMF-valued functions.
3. Prove channel atom, marginal, algebra, deterministic-map, and support laws.
4. Construct a total conditional channel with an explicit null-fiber convention.
5. Prove positive-fiber agreement, null-fiber irrelevance, and pair-law
   reconstruction.
6. Introduce PMF/random-variable Markov predicates and only the required
   conditional-independence symmetry API.
7. Prove cross-product, positive-fiber, zero-CMI, and reversal
   characterizations of Markov structure.
8. Prove that channel-generated triples are Markov.
9. Prove the exact mutual-information loss identity.
10. Derive MI data processing, its conditional consequence, and its equality
    characterization.
11. Add left, right, independently two-sided, cascade, and deterministic
    channel-facing MI processing results.
12. Prove the full Markov factorization converse using total conditional
    channels.
13. Run a second no-placeholder checkpoint to choose the kernel/KL contraction
    route and lock its support assumptions.
14. Bridge finite PMF channels to mathlib Markov kernels.
15. Build the finite KL chain-rule and posterior-decomposition infrastructure.
16. Establish the private or public finite KL contraction engine justified by
    the selected proof route.
17. Publish `ENNReal`, support-guarded real, deterministic, and cascade KL data
    processing.
18. Derive one-step invariant-reference contraction and uniform-preserving
    entropy growth, with a finite doubly-stochastic corollary.
19. Add common-cause and genuinely stochastic examples, then perform the
    scheduled naming, simp, module, and future-work review.
20. Integrate the milestone, regenerate references, run the full build/check
    and root-isolation suites, and create the clean checkpoint commit.

The temporary file passed twice, including the strengthened PMF Markov
orientation check. A collision scan found no existing project or relevant
mathlib declarations named `IsMarkovChain` or `IsMarkovChainOf`. The focused
command `lake build LeanInfoTheory LeanInfoTheory.Shannon.SemanticBridge`
passed with 2709 jobs. No production Lean declaration or public name was added,
so Future Work Note 14 received no new naming-watch entry. Future Work Notes
21, 25, 26, and 27 remain consumer-triggered during the active chunk rather
than becoming automatic API tasks.

### 95. Project B Chunk 3 Finite-Channel Core

Step 2 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. The new separately importable
`LeanInfoTheory.Probability.FiniteChannel` module establishes the deliberately
small PMF-first construction surface for stochastic channels. It adds four
public definitions in the existing `PMF` namespace:

- `PMF.deterministicChannel f`, the pure-output channel induced by `f`;
- `PMF.channelComp W V`, which samples first through `W` and then through `V`;
- `PMF.channelJoint p W`, the induced input-output joint law;
- `PMF.channelExtension p V`, which extends an `(A,B)` law to `(A,B,C)` by
  sampling `C` from a channel depending only on `B`.

The module intentionally does not introduce a channel structure, type synonym,
output-law wrapper, identity-channel wrapper, notation, or typeclass. A channel
continues to be written directly as `W : alpha -> PMF beta`; its output law is
`p.bind W`, and its identity channel is `PMF.pure`. This keeps later theorem
statements close to mathlib's PMF monad while giving names only to the compound
constructions that the Markov and data-processing phases will repeat.

The definitions are type-generic and introduce no `Finite`, `Fintype`,
measurable-space, kernel, entropy, or KL assumptions. The module imports only
`LeanInfoTheory.Probability.Finite`, which already supplies the local PMF and
support helpers needed by Step 3. No existing project module imports
`Probability.FiniteChannel`, so the lightweight root and every existing import
path remain unchanged. Later semantic modules will opt into it explicitly.

The four names are concise, grouped by the `PMF.channel...` prefix where
appropriate, and expose no marginal, coordinate-swap, fiber-proof, or kernel
implementation detail. The Step 2 naming audit therefore added no entry to
Future Work Note 14. This definitions-only step also created no consumer for
the deferred MI relabeling, independence convenience, independence-module
split, or conditional-independence ergonomics in Future Work Notes 21 and
25-27.

`lake build LeanInfoTheory.Probability.FiniteChannel` passed with 1698 jobs.
Step 3 will add the atom, marginal, algebra, deterministic-map, and support laws
for these constructions; none of those theorems was folded into Step 2.

### 96. Project B Chunk 3 Finite-Channel Laws

Step 3 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Probability.FiniteChannel` now supplies the elementary
theorem API for the four raw PMF-valued channel constructions introduced in
Step 2. The 21 new public theorems are organized into five focused groups:

- pointwise formulas for deterministic channels, composition, induced joint
  laws, and pair-to-triple extension;
- the two projections of `channelJoint` and the original-pair, channel-pair,
  final-output, and endpoint projections of `channelExtension`;
- output-through-composition, left and right pure identities, and associative
  channel composition;
- reductions of deterministic channels to `PMF.map`, including composition on
  either side and the graph-pushforward joint law;
- support-membership characterizations for composition, induced joints, and
  pair-to-triple extension.

All statements are type-generic. They require no `Finite`, `Fintype`,
measurable-space, entropy, or KL assumptions and are proved directly from the
existing `PMF.bind`, `PMF.map`, support, and monad laws. Constructor,
projection, deterministic, and support reductions are marked `[simp]` where
they strictly remove channel structure. `channelComp_apply`,
`bind_channelComp`, and `channelComp_assoc` remain explicit so simplification
does not eagerly expand composition into sums or choose an associativity
normal form.

The public-name audit found the algebra, deterministic, pointwise, and support
families concise and discoverable. The six projection declarations are also
coherent, but `channelJoint_map_fst`, `channelJoint_map_snd`, and the four
`channelExtension_map_...` names necessarily expose the low-level `PMF.map`
coordinate representation. Future Work Note 14 now records that family as
`watching`, with provisional semantic alias sketches for the scheduled Step 19
API review. No declaration was renamed or duplicated during this theorem step.

The module still imports only `Probability.Finite`, remains absent from the
lightweight root, and has no dependency on the semantic independence layer.
This step therefore did not trigger the deferred MI-relabeling, ordinary-
independence, module-split, or conditional-independence work in Future Work
Notes 21 and 25-27. Notes 26 and 27 record the concrete no-pressure result.

The complete no-placeholder proof probe passed and all temporary scratch files
were deleted. `lake build LeanInfoTheory.Probability.FiniteChannel` passed with
1698 jobs, and `lake build LeanInfoTheory` passed with 2240 jobs. Step 4 is now
the active task: construct the total conditional channel with the locked
null-fiber convention, leaving its semantic reconstruction laws to Step 5.

### 97. Project B Chunk 3 Total Conditional Channel

Step 4 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. The new separately importable
`LeanInfoTheory.Shannon.SemanticBridge.Markov` module begins the channel-facing
semantic layer fixed by the Step 1 ownership contract. It imports only
`Probability.FiniteChannel` and `SemanticBridge.Conditional` and adds one public
definition:

- `condFstGivenSndChannel p : beta -> PMF alpha` uses
  `condFstGivenSnd p b hb` when `sndMarginal p b != 0` and uses
  `fstMarginal p` when the conditioning fiber is null.

The null branch is explicitly documented as a totality device rather than a
conditional-probability claim. Choosing `fstMarginal p` supplies a PMF already
present in the joint law, so the definition needs only `[Fintype alpha]`: it
adds no `Nonempty alpha`, `Fintype beta`, measurable-space, entropy, or KL
assumption. The canonical proof-valued `condFstGivenSnd` API in
`SemanticBridge.Conditional` remains unchanged and continues to represent only
positive conditional fibers.

This was intentionally a definition-only step. Positive- and null-branch
reduction theorems, null-fiber irrelevance, weighted atom factorization, and
reconstruction of the pair law remain Step 5 work. A temporary no-placeholder
probe nevertheless established that both the weighted atom identity and the
swapped pair-law reconstruction elaborate from the current public API, with no
extra assumptions; the probe was then deleted.

The name `condFstGivenSndChannel` extends the established
`condFstGivenSnd` family, keeps the coordinate orientation visible, and is
short enough to discover beside the canonical conditional PMF. It does not
expose the fallback implementation in its name, so the naming audit added no
Future Work Note 14 entry. Step 5 theorem names will receive their own required
audit after the complete law family exists.

The semantic aggregate now imports `SemanticBridge.Markov`, while
`LeanInfoTheory.lean` remains unchanged. The focused build
`lake build LeanInfoTheory.Shannon.SemanticBridge.Markov` passed with 2234 jobs,
the aggregate semantic-bridge build passed with 2702 jobs, and the lightweight
root build passed with 2240 jobs. Future Work Notes 26 and 27 record that this
first Markov-module step creates a clean downstream boundary but no current
pressure to split independence or add conditional-independence conveniences.
Step 5 is now active.

### 98. Project B Chunk 3 Total Conditional-Channel Laws

Step 5 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Shannon.SemanticBridge.Markov` now proves the complete
first law family for `condFstGivenSndChannel`:

- `condFstGivenSndChannel_of_sndMarginal_eq_zero` exposes the documented first-
  marginal fallback on a null conditioning fiber;
- `condFstGivenSndChannel_of_sndMarginal_ne_zero` identifies every positive
  fiber with the canonical proof-valued `condFstGivenSnd` PMF;
- `condFstGivenSndChannel_null_fiber_irrelevant` shows that, after weighting by
  the zero conditioning mass, the chosen channel fiber agrees atomwise with any
  alternative fallback PMF;
- `sndMarginal_mul_condFstGivenSndChannel` reconstructs every original joint
  atom, including atoms over null conditioning fibers;
- `channelJoint_condFstGivenSndChannel` reconstructs the pair law in natural
  channel input-output order:
  `channelJoint (sndMarginal p) (condFstGivenSndChannel p) = p.map Prod.swap`.

The entire family retains only `[Fintype alpha]`. It adds no `Fintype beta`,
`Nonempty alpha`, measurable-space, entropy, or KL assumptions. The pair-law
theorem uses the Step 3 `PMF.channelJoint_apply` formula and the existing
equivalence-aware PMF map formula. No redundant theorem that swaps the
reconstructed law back to `p` was added; the natural channel-order identity is
the single public orientation.

The simp policy is deliberately narrow. Only the null-branch reduction is
`[simp]`, matching the existing conditional-fiber API. Positive-fiber
normalization, weighted multiplication, and pair-law reconstruction remain
explicit rewrites, avoiding proof-valued or algebraic normalization choices.

The required naming audit added the four long or representation-facing branch,
null-irrelevance, and weighted-atom names to Future Work Note 14 as one
`watching` family. The concise constructor-led
`channelJoint_condFstGivenSndChannel` needs no provisional alias. No declaration
was renamed or duplicated during the active theorem phase.

The no-placeholder proof probe passed and was deleted. Focused verification of
`LeanInfoTheory.Shannon.SemanticBridge.Markov` passed with 2234 jobs, the
semantic aggregate passed with 2702 jobs, and the lightweight root passed with
2240 jobs. This step still consumes no independence predicate or MI relabeling
argument, so Future Work Notes 21 and 25 remain deferred. Notes 26 and 27 record
that the planned independence-module and conditional-independence pressure did
not arise before Step 6. Step 6 is now active.

### 99. Project B Chunk 3 Markov Predicates and Symmetry

Step 6 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Shannon.SemanticBridge.Markov` now introduces the two
assumption-free predicates fixed by the Step 1 contract:

- `IsMarkovChainOf p X Y Z` means `IsCondIndependentOf p X Z Y`, so its
  orientation is the textbook chain `X -> Y -> Z`;
- `IsMarkovChain p` applies that random-variable predicate to the first,
  second, and third coordinate projections of a triple PMF.

Neither definition requires finite alphabets, measurable spaces, or measurable
singletons. The Markov module now imports `SemanticBridge.Independence` in place
of its direct `SemanticBridge.Conditional` import, while retaining the opt-in
`Probability.FiniteChannel` dependency. The lightweight root is unchanged.

The owning independence module gained exactly the two symmetry forms required
by the immediate Markov development:

- `[simp] isCondIndependent_map_swap12` removes the explicit map swapping the
  first two coordinates of a triple PMF;
- `isCondIndependentOf_swap` states symmetry of the first two random variables
  and remains an explicit rewrite to avoid a commutativity simp loop.

The PMF proof is direct from the cross-product definition, the existing three
swapped-marginal laws, and injectivity of the coordinate permutation. It adds
no finiteness assumptions and does not route elementary symmetry through zero
conditional mutual information. No additional coordinate orientation,
closure theorem, right-oriented conditional-entropy equality, or extracted
conditional-fiber scaling helper was added without a consumer. Step 7 remains
responsible for the Markov factorization, positive-fiber, zero-CMI, and reversal
characterizations.

The module-pressure checkpoint measured the concrete dependency change. The
independence source now has 649 lines and 30 public definitions/theorems, and
its direct project importers are the semantic aggregate and the Markov module.
The focused Markov boundary rises from the Step 5 baseline of 2234 jobs to
2701 jobs. A split is still deferred: Step 7 immediately consumes the same
module's positive-fiber and zero-CMI theorems, and the Markov module is designed
to own later MI results, so a predicate-only split would not create a stable
light consumer. Future Work Note 26 retains Step 19 as the next review point.

The public-name audit records only `isCondIndependent_map_swap12` in Future
Work Note 14 because it exposes the coordinate-map representation. The two
Markov predicate names and `isCondIndependentOf_swap` are concise textbook-
facing names and need no watch entry. The temporary no-placeholder proof file
compiled without warnings and was deleted. Focused builds of
`LeanInfoTheory.Shannon.SemanticBridge.Independence` and
`LeanInfoTheory.Shannon.SemanticBridge.Markov` passed with 2701 jobs; the
semantic aggregate passed with 2702 jobs, and the lightweight root passed with
2240 jobs. Step 7 is now active.

### 100. Project B Chunk 3 Markov Characterizations

Step 7 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Shannon.SemanticBridge.Markov` now supplies the five
characterization theorems selected by the Step 1 contract:

- `isMarkovChain_iff_crossProduct` states
  `p(a,b,c) * p_B(b) = p_AB(a,b) * p_BC(b,c)` atomwise;
- `isMarkovChain_iff_isIndependent_condFstSndGivenThird` identifies Markov
  structure with independence of the two endpoints in every positive-mass
  conditional fiber of the middle coordinate;
- `condMutualInfoOf_eq_zero_iff_isMarkovChainOf` states the textbook
  equivalence `I(X;Z|Y) = 0` iff `X -> Y -> Z`;
- `isMarkovChainOf_reverse` states assumption-free random-variable chain
  reversal;
- `[simp] isMarkovChain_map_reverse` removes an explicit reversal of all three
  PMF coordinates.

The cross-product and reversal theorems require no finite alphabets or
measurable spaces. The positive-fiber theorem needs only `[Fintype alpha]` and
`[Fintype gamma]` for the two endpoint alphabets; the middle alphabet remains
arbitrary. Only the zero-CMI theorem needs all three alphabets finite. Null
middle fibers remain covered by the cross-product predicate without selecting
a conditional law.

The proofs reuse the existing conditional-independence layer rather than
duplicating its semantic arguments. The cross-product proof transports the
primary atomwise predicate from endpoint-endpoint-middle order back to the
original triple and uses only injective PMF relabeling and marginal projection
laws. The positive-fiber and zero-CMI theorems are direct specializations of
the established conditional-independence equivalences. Chain reversal is the
first production consumer of the Step 6 symmetry API.

The simp audit promotes only `isMarkovChain_map_reverse`: it strictly removes
an explicit coordinate construction. `isMarkovChainOf_reverse` remains
explicit to avoid a commutativity loop, while the cross-product, fiber, and
zero-CMI equivalences remain user-directed semantic rewrites. A temporary
consumer check proved that `PMF.channelExtension p V` satisfies the selected
cross-product formula using exactly the Step 3 input/output-pair projections
and pointwise channel laws. A second check normalized a double coordinate
reversal with `simp`; both checks compiled without warnings and the scratch
file was deleted. The generated-channel theorem itself remains Step 8 work.

The public-name audit keeps the concise cross-product, zero-CMI, and random-
variable reversal names unchanged without a watch entry. Future Work Note 14
records the long positive-fiber theorem and the representation-facing PMF
reverse-map theorem for the scheduled Step 19 review; no compatibility alias
was introduced during active theorem development. Future Work Notes 25-27
record that this step reused the current independence ownership and created no
pressure for ordinary-independence convenience lemmas, a module split, the
right-oriented conditional-entropy equality, or extracted conditional-fiber
scaling helpers.

`lake build LeanInfoTheory.Shannon.SemanticBridge.Markov` passed with 2701
jobs. The semantic aggregate passed with 2702 jobs, and the lightweight root
passed with 2240 jobs. Step 8 is now active.

### 101. Project B Chunk 3 Channel-Generated Markov Triples

Step 8 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Shannon.SemanticBridge.Markov` now proves the single
general constructor theorem

```lean
@[simp] theorem isMarkovChain_channelExtension
    (p : PMF (alpha × beta)) (V : beta -> PMF gamma) :
    IsMarkovChain (PMF.channelExtension p V)
```

Thus any law of `(A,B)` extended by sampling `C` from a channel depending only
on `B` forms the Markov chain `A -> B -> C`. The theorem is fully type-generic:
it needs no finite alphabets, support positivity, measurable spaces, or selected
conditional PMFs. Null middle-coordinate fibers are handled by the Step 7
cross-product characterization.

The proof rewrites Markov structure through
`isMarkovChain_iff_crossProduct`, recovers the original `(A,B)` law through
`PMF.channelExtension_map_input`, identifies the `(B,C)` law through
`PMF.channelExtension_map_outputPair`, and closes the atomwise identity with
`PMF.channelExtension_apply`, `PMF.channelJoint_apply`, and commutative
multiplication. It does not unfold PMF bind sums or repeat conditional-
independence fiber arguments.

The theorem is a simp rule because it strictly removes the explicit
`PMF.channelExtension` Markov construction. Temporary consumer checks confirmed
that `simp` proves the arbitrary-pair theorem, its two-channel specialization
with `PMF.channelJoint p W`, and the reversed-coordinate form via Step 7's
`isMarkovChain_map_reverse`. The scratch file compiled without warnings and was
deleted. No separate cascade or reversal corollary was added because both are
already immediate simplifier consequences of the general theorem.

The public name is concise, constructor-led, and exposes no marginal, fiber,
coordinate-swap, or local proof machinery, so Future Work Note 14 gains no new
entry. Future Work Notes 26 and 27 record that the proof uses the existing
Markov cross-product boundary and creates no pressure for an independence-
module split, extra conditional-independence closure forms, the right-oriented
conditional-entropy equality, or conditional-marginal scaling helpers.

`lake build LeanInfoTheory.Shannon.SemanticBridge.Markov` passed with 2701
jobs. The semantic aggregate passed with 2702 jobs, and the lightweight root
passed with 2240 jobs. Step 9 is now active.

### 102. Project B Chunk 3 Exact Markov Information Loss

Step 9 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Shannon.SemanticBridge.Markov` now exposes the exact
mutual-information loss identity at both established API levels:

- `mutualInfo_markov_chain_rule` states for a Markov triple law that
  `I(A;B) = I(A;C) + I(A;B|C)` using `fstSndMarginal`, `fstThirdMarginal`, and
  `condMutualInfo`;
- `mutualInfoOf_markov_chain_rule` states under
  `IsMarkovChainOf p X Y Z` that
  `I(X;Y) = I(X;Z) + I(X;Y|Z)`.

Both theorems require only finite instances for the three variable alphabets;
the source type of the random-variable theorem remains unrestricted. Their
proofs use `condMutualInfoOf_eq_zero_iff_isMarkovChainOf` to remove
`I(X;Z|Y)`, rewrite the paired mutual information through
`mutualInfo_chain_rule_snd`/`mutualInfoOf_chain_rule_snd`, and finish with the
corresponding `_fst` chain rule. No subtraction, linear arithmetic, KL
argument, support condition, or measurable-space choice is involved.

The PMF theorem is not a redundant mirror: an exported-API smoke test applies
it directly to `PMF.channelExtension p V` using Step 8's
`isMarkovChain_channelExtension`, with no coordinate lambdas in the consumer
statement. The random-variable theorem remains the clean textbook form needed
by Step 10. The temporary proof and consumer files compiled without warnings
and were deleted.

Neither theorem is a simp rule. Rewriting mutual information into an additive
loss decomposition selects a useful but noncanonical expanded form, matching
the existing explicit chain-rule policy. The paired names are concise,
textbook-facing, and follow the established PMF/`...Of` convention without
exposing marginals or proof machinery, so Future Work Note 14 gains no entry.
Future Work Notes 15, 21, 26, and 27 record that this step creates no simp-loop,
injective-relabeling, module-split, conditional-independence closure, or fiber-
helper pressure.

`lake build LeanInfoTheory.Shannon.SemanticBridge.Markov` passed with 2701
jobs. The semantic aggregate passed with 2702 jobs, and the lightweight root
passed with 2240 jobs. Step 10 is now active.

### 103. Project B Chunk 3 Mutual-Information Data Processing

Step 10 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Shannon.SemanticBridge.Markov` now exposes the complete
finite Markov data-processing family selected by the phase contract:

- `mutualInfo_dataProcessing` and `mutualInfoOf_dataProcessing` state
  `I(A;C) <= I(A;B)` and `I(X;Z) <= I(X;Y)` under the corresponding forward
  Markov condition;
- `condEntropy_dataProcessing` and `condEntropyOf_dataProcessing` state the
  equivalent consequence `H(A|B) <= H(A|C)` and `H(X|Y) <= H(X|Z)`;
- `mutualInfo_dataProcessing_eq_iff` and
  `mutualInfoOf_dataProcessing_eq_iff` characterize equality exactly by the
  reverse Markov condition, with the variable theorem stating `X -> Z -> Y`
  directly.

All six theorems require only finite instances for the three variable
alphabets. The MI inequalities rewrite the Step 9 exact loss identity and use
`condMutualInfo_nonneg` or `condMutualInfoOf_nonneg`. The conditional-entropy
form rewrites the existing identity `I(X;Y) = H(X) - H(X|Y)` and uses ordered-
group cancellation. The equality proof cancels the common `I(X;Z)` term and
uses `condMutualInfoOf_eq_zero_iff_isMarkovChainOf`; it introduces no KL,
support, measurable-space, or selected conditional-PMF assumptions.

The PMF equality statement avoids a mapped reverse triple and instead states
the reverse condition through the original first, third, and second coordinate
variables. An exported consumer compiled all three result kinds and applied
the PMF inequality directly to `PMF.channelExtension p V`, confirming the
Step 11 channel-facing route. The proof spike and consumer were deleted.

No theorem is a simp rule: inequalities do not normalize terms, and the
equality equivalences are semantic characterizations requiring an explicit
forward-chain hypothesis. The six names form a compact textbook-facing
`dataProcessing`/`dataProcessing_eq_iff` PMF-and-`...Of` family and expose no
proof helper, marginal, swap, or fiber machinery, so Future Work Note 14 gains
no new watch entry. The one conditional-entropy rearrangement does not justify
the deferred reverse elementary-MI alias family. Future Work Notes 15, 21, 26,
27, and 30 record that this step creates no simp, injective-relabeling, module-
split, closure, right-oriented conditional-entropy, fiber-helper, or total-
conditioning abstraction pressure.

The temporary six-theorem spike and exported consumer both compiled without
warnings. `lake build LeanInfoTheory.Shannon.SemanticBridge.Markov` passed with
2701 jobs, the combined root and semantic-aggregate build passed with 2711
jobs, and a separate lightweight-root build passed with 2240 jobs. The root
import remains unchanged. Step 11 is now active.

### 104. Project B Chunk 3 Channel-Facing MI Processing

Step 11 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Shannon.SemanticBridge.Markov` now exposes five
channel-facing mutual-information contractions:

- `mutualInfo_channel_right_le` processes the second coordinate of a joint law
  through `PMF.channelExtension`;
- `mutualInfo_channel_left_le` processes the first coordinate and states the
  resulting `(output,right)` law directly as a `PMF.bind`;
- `mutualInfo_independent_channels_le` independently processes both
  coordinates, with conditional output law `indepProd (W a) (V b)`;
- `mutualInfo_channelComp_le` contracts input-output mutual information along
  a two-stage `PMF.channelComp` cascade;
- `mutualInfo_channel_map_output_le` specializes the cascade theorem to a
  deterministic map of every channel output law.

The right theorem is a direct application of Step 10 data processing to the
Step 8 Markov channel extension. The left theorem reverses the source pair,
uses the right theorem, and restores the natural output-coordinate order
privately. The two-sided result applies the one-sided theorems sequentially;
two private PMF monad-law helpers identify the clean public `bind`/`indepProd`
law with those sequential extensions. The cascade proof uses
`channelExtension_map_endpoints`, and the deterministic theorem uses
`channelComp_deterministic_right`. No entropy expansion, KL argument, support
condition, measurable space, or selected conditional PMF is needed.

The theorem step adds no fifth channel construction. Channels remain raw
PMF-valued functions, the finite-channel core still owns exactly its four
locked compound constructions, and the only independent two-coordinate output
law is written directly in the consuming theorem. Revisit a product-channel
abstraction only if later KL or example proofs repeat that construction; one
consumer is not enough to change the core API.

None of the five inequalities is a simp rule. The left/right and independent-
channels names are short and mathematical. Future Work Note 14 records
`mutualInfo_channelComp_le` and `mutualInfo_channel_map_output_le` as
`watching` because they expose the selected constructor or `map` representation;
provisional compatibility-alias patterns are `mutualInfo_channel_cascade_le`
and `mutualInfo_channel_deterministic_postprocess_le`. No declaration was
renamed during the active theorem phase. Future Work Notes 15, 21, 25-27, and
30-31 record that the step creates no simp, injective-relabeling, independence-
convenience, module-split, conditional-independence, or total-conditioning
abstraction pressure.

The complete five-theorem spike and exported consumer compiled without
warnings and were deleted. The focused Markov build passed with 2701 jobs, the
semantic aggregate passed with 2711 jobs, and the lightweight root passed with
2240 jobs. `LeanInfoTheory.lean` remains unchanged. Step 12 is now active.

### 105. Project B Chunk 3 Markov Factorization Converse

Step 12 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Shannon.SemanticBridge.Markov` now closes both useful
forms of the channel-factorization converse:

- `isMarkovChain_iff_eq_channelExtension_condFstGivenSndChannel` states that a
  triple law is Markov exactly when extending its first-two marginal by the
  total `B -> C` conditional channel extracted from its swapped second-third
  marginal reconstructs the original law;
- `isMarkovChain_iff_exists_channelExtension` gives the textbook-facing form:
  a triple law is Markov exactly when some `B -> C` channel extends its first-
  two marginal to that law.

The canonical theorem needs only `[Fintype gamma]`, the assumption required by
the existing total conditional-channel construction; neither endpoint nor the
middle alphabet is required to be finite. The existential corollary exposes
the weaker `[Finite gamma]` contract and installs `Fintype.ofFinite` only inside
its proof to construct the canonical witness.

The forward canonical proof rewrites Markov structure to the Step 7 cross-
product law and compares atoms. It uses Step 5's weighted total-channel
reconstruction on the second-third marginal. On a null middle fiber, two local
support-map arguments show that both the original atom and its first-two-
marginal factor vanish. On a positive fiber, the cross-product identity and
weighted reconstruction have the same finite middle mass, which is cancelled
using its nonzero and non-`top` PMF bounds. The reverse implication is the Step
8 theorem that every channel extension is Markov. No selected proof-valued
conditional PMF, measurable space, kernel, KL argument, or stronger alphabet
assumption enters the result.

The null-fiber and middle-marginal bookkeeping remains local to this first
production converse proof. The step adds no generic weighted-channel helper,
opposite pair-law reconstruction theorem, fifth channel constructor, or new
`[simp]` rule. Future Work Note 14 marks the canonical theorem's descriptive
name as `watching` because it exposes both `channelExtension` and
`condFstGivenSndChannel`; the provisional Step 19 alias pattern is
`isMarkovChain_iff_canonical_channelExtension`. The existential theorem is
concise and textbook-facing and needs no watch entry. Future Work Notes 15,
26-27, and 30 retain the existing simp, module, conditional-independence, and
total-conditioning boundaries.

The complete no-placeholder spike and exported aggregate consumer compiled and
were deleted. `lake build LeanInfoTheory.Shannon.SemanticBridge.Markov` passed
with 2701 jobs, the semantic aggregate passed with 2711 jobs, and the
lightweight root passed with 2240 jobs. `LeanInfoTheory.lean` remains unchanged.
Step 13's kernel/KL contract and feasibility checkpoint is now active.

### 106. Project B Chunk 3 KL Contraction Feasibility Checkpoint

Step 13 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. A temporary no-placeholder Lean development validated the complete finite
KL contraction route before any production API was chosen.

The selected route keeps `W : alpha -> PMF beta` as the public channel
representation and converts it locally with mathlib's
`Kernel.ofFunOfCountable`. The spike proved that kernel `compProd` agrees with
`PMF.channelJoint`, then used `condFstGivenSndChannel` as a total finite
posterior and the existing `channelJoint_condFstGivenSndChannel` theorem to
reconstruct the swapped joint law. A finite equivalence-relabeling argument
handled that coordinate swap. Mathlib's `klDiv_compProd_left` and
`klDiv_compProd_eq_add` then supplied an exact posterior decomposition whose
nonnegative remainder proves channel contraction.

The theorem contracts established by the spike are now locked. The primary
finite-channel theorem is unconditional and `ENNReal`-valued. Its real-valued
corollary requires only the input condition `p.support ⊆ q.support`; no
separate output support hypothesis is needed because support inclusion is
preserved by `PMF.bind`. Deterministic-map and cascade specializations both
compiled, and the real cascade form needs only the same original input support
condition. The finite and measurable-singleton assumptions remain confined to
the kernel/KL layer.

Two alternatives were deliberately rejected. A direct finite log-sum proof
would duplicate an analytic engine because mathlib currently exposes the KL
chain rule but no reusable finite log-sum or KL data-processing theorem. Using
mathlib's general posterior construction would introduce unnecessary standard-
Borel and nonempty-type machinery when the project's existing total finite
conditional channel already supplies the required reconstruction.

Steps 14-18 will therefore live in a new separately importable
`LeanInfoTheory.Shannon.SemanticBridge.DataProcessing` module. The finite KL
equivalence-relabeling lemma should initially remain private because its only
current use is the coordinate swap inside posterior decomposition; Future Work
Note 35 records the trigger for reconsidering that choice. The explicit
`IsMarkovKernel` proof and named intermediate measure equalities from the spike
also avoid the typeclass-search and large-rewrite elaboration costs observed
during the checkpoint.

The temporary file passed with `lake env lean ScratchStep13.lean`, including
the deterministic and cascade contract checks, and was deleted. The focused
KL/Markov/semantic aggregate build passed with 2702 jobs, and the lightweight
root passed separately with 2240 jobs. No production Lean declaration, public
name, simp rule, aggregate import, or root import was added. Step 14's finite
PMF-channel-to-kernel bridge is now active.

### 107. Project B Chunk 3 PMF-to-Kernel Bridge

Step 14 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. The new separately importable
`LeanInfoTheory.Shannon.SemanticBridge.DataProcessing` module now contains the
small production bridge from raw PMF-valued channels to mathlib kernels:

- `pmfChannelKernel W` uses `Kernel.ofFunOfCountable` to view
  `W : alpha -> PMF beta` as a kernel without changing the project's public
  channel representation;
- the associated global `IsMarkovKernel` instance follows explicitly from the
  probability-measure instance on each `(W a).toMeasure`;
- `[simp] pmfChannelKernel_apply` reduces evaluation of the bridge to
  `(W a).toMeasure`;
- `channelJoint_toMeasure` identifies `(PMF.channelJoint p W).toMeasure` with
  `p.toMeasure ⊗ₘ pmfChannelKernel W`.

The joint-law bridge is proved by measure extensionality on finite/countable
singletons and mathlib's `Measure.compProd_apply_prod`. Its explicit countable
and measurable-singleton assumptions are inferred directly from the `[Finite]`
alphabets used by the later KL layer, as confirmed by an exported-consumer
smoke test. The semantic aggregate imports the new module, while
`LeanInfoTheory.lean` remains unchanged.

This step deliberately adds no posterior definition, KL decomposition,
contraction theorem, support-transport helper, total-conditional-channel law,
or Step 12 alias. In particular, it does not repeat either the equality between
the two middle-marginal representations or the null-fiber support transport
from the canonical Markov factorization proof. Those Step 15 triggers remain
active under Future Work Notes 27 and 30.

The public-name audit found `pmfChannelKernel`, `pmfChannelKernel_apply`, and
`channelJoint_toMeasure` concise and discoverable; no naming-watch entry or
compatibility alias is needed. The only new simp theorem strictly removes the
bridge constructor, while the measure identity remains explicit. The focused
data-processing build passed with 2702 jobs, the data-processing plus semantic-
aggregate build passed with 2703 jobs, and the lightweight root passed with
2240 jobs. The temporary consumer passed with `lake env lean` and was deleted.
Step 15's posterior/KL decomposition infrastructure is now active.

### 108. Project B Chunk 3 Exact KL Posterior Decomposition

Step 15 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Shannon.SemanticBridge.DataProcessing` now contains the
finite posterior and exact KL chain-rule infrastructure selected by the Step 13
checkpoint.

The new public PMF-first construction and reconstruction law are:

- `channelPosterior p W`, defined as
  `condFstGivenSndChannel (PMF.channelJoint p W)`;
- `channelPosterior_reconstructs_joint`, which states that sampling this
  posterior from the output law `p.bind W` reconstructs
  `PMF.channelJoint p W` in output-input order.

The reconstruction theorem requires only `[Fintype alpha]`. It composes
`PMF.channelJoint_map_snd` with the existing
`channelJoint_condFstGivenSndChannel`; it introduces no measurable space and
assigns no meaning to the inherited null-output fallback beyond the established
weighted reconstruction contract.

The main theorem `klDiv_channel_eq_add_posterior` states the exact unconditional
`ENNReal` identity

`D(p || q) = D(pW || qW) + D(P_{Y,X} || P_Y ⊗ Q_{X|Y})`,

with the final conditional remainder represented precisely by mathlib
composition-product measures over the first output law. Its public assumptions
are `[Fintype alpha]`, `[Finite beta]`, and explicit measurable-singleton spaces
on both alphabets. The proof first preserves input KL by adjoining the common
forward kernel, rewrites both joint laws through `channelJoint_toMeasure`, swaps
their coordinates, reconstructs them from their output laws and posteriors, and
then invokes mathlib's `klDiv_compProd_eq_add`.

Two implementation lemmas remain private. `channelPosterior_compProd` converts
the PMF reconstruction to the measure-level form used by the chain rule.
`klDiv_map_equiv` proves finite KL invariance under equivalence only for the
required coordinate swap; it handles both support-inclusion and infinite-KL
branches and remains the single production consumer tracked by Future Work
Note 35. No general relabeling API was promoted.

The Step 12 pressure audit found no repeated argument. Neither the equality
between the two Markov middle-marginal representations nor the canonical
factorization proof's null-fiber support transport appears here. Posterior
reconstruction instead composes two already public pair/channel laws, so Future
Work Notes 27 and 30 do not trigger a helper extraction. The theorem also adds
no KL recovery or posterior-equality characterization; those remain in the
sufficient-statistics phase owned by Note 29.

The public-name audit found `channelPosterior`,
`channelPosterior_reconstructs_joint`, and
`klDiv_channel_eq_add_posterior` conceptual and discoverable, with no marginal,
coordinate-swap, fiber-helper, or `compProd` detail in their names. No naming-
watch entry or compatibility alias is needed, and no new simp rule was added.
The warning-free focused build passed with 2714 jobs, the semantic aggregate
passed with 2715 jobs, and the lightweight root passed with 2240 jobs. A fresh
consumer exercised PMF reconstruction, the exact decomposition, and Step 16's
nonnegative-remainder specialization; it passed and was deleted. Step 16's
finite KL contraction engine is now active.

### 109. Project B Chunk 3 Private KL Contraction Engine

Step 16 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Shannon.SemanticBridge.DataProcessing` now contains the
private theorem `klDiv_channel_le_aux`, the internal engine for the public Step
17 KL data-processing family.

The engine already has the final finite-alphabet contract: `[Finite alpha]`,
`[Finite beta]`, measurable spaces, and measurable singletons on both
alphabets. It states the unconditional `ENNReal` inequality

`D(p.bind W || q.bind W) <= D(p || q)`.

The proof installs `Fintype.ofFinite alpha`, rewrites the input divergence with
`klDiv_channel_eq_add_posterior`, and drops the posterior divergence using
`le_add_of_nonneg_right bot_le`. No support inclusion, real conversion,
log-sum argument, posterior equality, recovery condition, or second contraction
proof enters the result.

The theorem remains private deliberately. Step 17 owns the coherent public
surface: primary `ENNReal`, support-guarded real, deterministic-map, and cascade
forms. Step 16 therefore adds no public declaration, naming-watch entry, alias,
or simp rule. It also consumes only the Step 15 public decomposition, so it
repeats none of the Step 12 middle-marginal or null-fiber support arguments and
creates no helper pressure under Future Work Notes 27 or 30. The private KL
equivalence helper still has only its original coordinate-swap consumer.

The warning-free focused data-processing build passed with 2714 jobs, the
semantic aggregate passed with 2715 jobs, and the lightweight root passed with
2240 jobs. `LeanInfoTheory.lean` remains unchanged. Step 17's public KL data-
processing family is now active.

### 110. Project B Chunk 3 KL Data Processing

Step 17 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Shannon.SemanticBridge.DataProcessing` now publishes the
coherent six-theorem finite KL data-processing family selected by the Step 13
checkpoint.

`klDiv_channel_le` is the primary unconditional `ENNReal` contraction theorem
for two finite input laws passed through the same stochastic channel.
`toReal_klDiv_channel_le` gives the real-valued form under only the input
condition `p.support ⊆ q.support`; `ENNReal.toReal_mono` needs finiteness of
the right-hand input divergence, so no separate output-support hypothesis is
introduced. The deterministic specializations are `klDiv_map_le` and
`toReal_klDiv_map_le`.

`klDiv_channelComp_le` and `toReal_klDiv_channelComp_le` state contraction when
the same second channel stage is appended to two intermediate output laws. The
cascade contract keeps the original source alphabet fully type-generic and
requires finite measurable-singleton structure only on the intermediate and
final alphabets. Its real form transports the original input support inclusion
through the first channel using one private `support_bind_mono` helper. That
helper has exactly one production consumer and therefore remains private.

The public-name audit accepts the primary channel and deterministic-map names
as concise mathematical vocabulary. The two cascade names deliberately match
the established `PMF.channelComp` and `mutualInfo_channelComp_le` surface but
expose a constructor spelling, so Future Work Note 14 records provisional
compatibility aliases `klDiv_channel_cascade_le` and
`toReal_klDiv_channel_cascade_le` for the scheduled Step 19 review. No existing
or new declaration was renamed. All six inequalities remain explicit rather
than `[simp]`.

The real proofs use monotonicity of `ENNReal.toReal`; they do not manually
eliminate the top branch of `ENNReal.toReal_eq_zero_iff`, so Future Work Note
22's production count remains one. Step 17 adds no equality, recovery,
posterior-fiber, product-channel, random-variable coupling, or public KL-
relabeling API. In particular, the private `klDiv_map_equiv` theorem still has
only its coordinate-swap consumer from Step 15.

The warning-free focused data-processing build passed with 2714 jobs, the
semantic aggregate passed with 2715 jobs, and the lightweight root passed with
2240 jobs. A fresh consumer imported only the data-processing module and
exercised all six public contracts, including the assumption-light cascade
forms; it passed and was deleted. `LeanInfoTheory.lean` remains unchanged.
Step 18's invariant-reference contraction and uniform-preserving entropy
consequences are now active.

### 111. Project B Chunk 3 Invariant Laws and Entropy Growth

Step 18 of the revised 20-step Project B Chunk 3 plan was completed on July 15,
2026. `LeanInfoTheory.Shannon.SemanticBridge.DataProcessing` now derives the
planned one-step invariant-law consequences from the public Step 17 channel
data-processing API.

`klDiv_channel_invariant_le` states that

`D(p.bind W || r) <= D(p || r)`

whenever the finite reference law is invariant, `r.bind W = r`. Its proof is a
direct specialization of `klDiv_channel_le`, so it preserves the unconditional
`ENNReal` contract. `toReal_klDiv_channel_invariant_le` gives the corresponding
real-valued inequality under `p.support ⊆ r.support` and reuses
`toReal_klDiv_channel_le` without a new finiteness argument.

`entropy_le_entropy_bind_of_uniform_invariant` specializes the reference to
`PMF.uniformOfFintype alpha`, rewrites both real divergences with
`toReal_klDiv_pmf_uniformOfFintype`, and cancels the common logarithmic
cardinality term. Its measurable and measurable-singleton structures are
chosen only inside the proof, leaving the public statement with the natural
`[Fintype alpha]` and `[Nonempty alpha]` assumptions.

`entropy_le_entropy_bind_of_doublyStochastic` supplies the finite textbook
corollary. A channel `W : alpha -> PMF alpha` already has probability-law rows;
the theorem therefore takes only the remaining column condition
`∀ b, ∑ a, W a b = 1`. A local atomwise calculation proves that this
condition preserves `PMF.uniformOfFintype alpha`, after which the uniform-
invariant theorem applies. No matrix conversion, bundled channel predicate,
transition process, or public uniform-preservation helper was added.

The naming audit accepts the two KL names as a concise extension of the Step 17
family. The two entropy names are mathematically direct but long, so Future
Work Note 14 records provisional `entropy_bind_mono_of_uniform_invariant` and
`entropy_bind_mono_of_doublyStochastic` alias patterns for the scheduled Step
19 review. These sketches are not approved aliases, and no declaration was
renamed. All four inequalities remain explicit rather than `[simp]`.

Step 18 does not use the private bind-support monotonicity helper, the private
KL equivalence theorem, or the posterior API. It also adds no KL equality,
recovery, random-variable coupling, product-channel, iterated-channel, or
stationary-process surface. The invariant theorem consumes the public
`klDiv_channel_le`, so the private `klDiv_channel_le_aux` wrapper gains no
second internal consumer before the Step 19 implementation review.

The warning-free focused data-processing build passed with 2714 jobs, the
semantic aggregate passed with 2715 jobs, and the lightweight root passed with
2240 jobs. A fresh consumer imported only the data-processing module and
exercised all four public contracts, including both assumption-light entropy
statements; it passed and was deleted. `LeanInfoTheory.lean` remains unchanged.
Step 19's common-cause and stochastic examples and scheduled API/module review
are now active.

### 112. Project B Chunk 3 Examples and API Review

Step 19 of the revised 20-step Project B Chunk 3 plan was completed on July 16,
2026. Two new opt-in modules turn the theorem phase into concrete finite
models without changing the lightweight root.

`LeanInfoTheory.Examples.CommonCause` builds a fair binary cause and two noisy
binary observations, each copied correctly with probability `3 / 4`. The
observation-cause-observation law is constructed by `PMF.channelExtension`, so
the public constructor theorem proves its Markov property. The example then
uses the random-variable conditional-independence predicate, the positive-
fiber endpoint characterization, the zero-CMI equivalence, and both canonical
and existential channel factorizations. The doc comment on
`condMutualInfo_eq_zero_iff_isCondIndependent` now also states why null fibers
need no chosen conditional law.

`LeanInfoTheory.Examples.StochasticChannels` supplies two genuinely stochastic
one-step models. A uniform reset channel satisfies both the uniform-invariance
and direct column-sum entropy hypotheses and strictly increases the entropy of
a pure binary input. A second reset channel has a full-support nonuniform
Bernoulli invariant law and demonstrates KL contraction toward that law. The
module also gives a two-stage cascade whose disjoint source laws fail support
inclusion but whose intermediate laws coincide. The weaker intermediate-
support real contraction is a short specialization of
`toReal_klDiv_channel_le`, so no additional cascade theorem was added. The
uniform-preservation and column calculations remain private to the example.

The scheduled naming review approved five compatibility aliases while
preserving every original declaration:

- `isMarkovChain_iff_fiberwise_endpoints_independent`;
- `isMarkovChain_iff_canonical_channelExtension`;
- `mutualInfo_channel_cascade_le`;
- `klDiv_channel_cascade_le`;
- `toReal_klDiv_channel_cascade_le`.

The projection, total-conditional-channel branch, conditional-independence
swap, Markov reversal, deterministic-postprocessing, and entropy-`mono` alias
sketches were declined after the examples showed no discovery benefit or
revealed ambiguous vocabulary. Future Work Note 14 records the complete
decision table. None of the aliases is a simp rule.

Representative direct channel-extension, two-channel cascade, reversed-
coordinate Markov, MI swap, and CMI swap simp goals all close with the existing
rules. No new simp attribute is justified. The short private
`klDiv_channel_le_aux` wrapper had no internal consumer and duplicated the
public theorem's statement, so its proof was moved into `klDiv_channel_le` and
the wrapper was deleted without changing the public contract.

The module review retained all three semantic files. `Independence` now has
654 source lines, 30 public declarations, and no private declarations;
`Markov` has 691 lines, 32 public declarations, and two private declarations;
`DataProcessing` has 454 lines, 19 public declarations (two definitions, one
instance, and 16 theorems), and three private declarations. Their current
direct consumers need the heavy semantic surfaces
they import, and no repeated proof crosses a stable ownership boundary. Recent
source-triggered rebuilds took 13 seconds for `Independence`, 17 seconds for
`Markov`, and 15 seconds for `DataProcessing`; cached focused builds took about
3.6, 3.8, and 3.4 seconds respectively. All remain outside the lightweight
root.

The combined focused example build passed with 2717 jobs. The semantic bridge,
example aggregate, and lightweight root build passed with 2730 jobs. A fresh
consumer imported only the two new example modules and checked all five aliases
plus the principal example results; it passed and was deleted. The separate
simp probe also passed and was deleted. The forbidden-placeholder scan,
scratch-file scan, and `git diff --check` passed. `LeanInfoTheory.lean` remains
unchanged. Generated reference and website integration remain Step 20 work.

A post-completion double-check on July 16 found no Lean theorem, example,
alias, simp, module-boundary, or import-isolation defect. It did correct two
bookkeeping issues: the hand-written README/current-state/roadmap status had
not been advanced beyond Step 18, and the first module metric omitted the public
`pmfChannelKernel.instIsMarkovKernel` instance. The corrected data-processing
count is 19 public declarations. A temporary Lean audit additionally verified
the fair cause mass, full support of both noisy-copy rows, full support of the
biased invariant law, and the direct, nested, and reversed Markov simp goals;
it passed and was deleted. The focused 2717-job and aggregate/root 2730-job
builds, root-reachability check, placeholder scan, scratch scan, stale-status
scan, and diff hygiene check all passed again.

### 113. Project B Chunk 3 Milestone Integration

Step 20 of the revised 20-step Project B Chunk 3 plan was completed on July 16,
2026. The final review confirmed that the finite-channel, independence, Markov,
data-processing, example, documentation, generator, and generated-reference
changes all belong to the planned milestone. `LeanInfoTheory.lean` has no diff;
all five new modules remain separately importable outside the lightweight root.

The complete milestone build suite passed:

- `lake build LeanInfoTheory` (2240 jobs);
- `lake build LeanInfoTheory.Shannon.EntropyBounds` (2650 jobs);
- `lake build LeanInfoTheory.Shannon.Units` (2235 jobs);
- `lake build LeanInfoTheory.Shannon.SemanticBridge` (2715 jobs);
- `lake build LeanInfoTheory.MathlibFragments` (2700 jobs);
- each of `Certificate.Submodularity`, `Certificate.Subadditivity`,
  `Certificate.Monotonicity`, and `Certificate.ThreeWaySubadditivity` (1076
  jobs each);
- `lake build LeanInfoTheory.Examples` (2725 jobs).

Both source-derived reference generators passed. The declaration index now
contains 616 documented public declarations. The dependency graph contains 33
modules and 52 local import edges: 11 modules are root-reachable and 22 remain
separately importable. The hand-written website was synchronized with the
completed channel, Markov, KL-data-processing, and example surfaces; the website
checker passed for 12 HTML files and both generated JSON files.

A temporary Lake consumer imported the new opt-in channel, Markov, data-
processing, common-cause, and stochastic-example modules and exercised
representative declarations; its 2718-job build passed and the source file was
deleted. The source-derived negative isolation check confirmed that all five
modules remain unreachable from `LeanInfoTheory`. The forbidden-placeholder,
scratch-file, temporary-`test_`, stale-status, and diff-hygiene checks passed,
and no Lean or Lake process remained running.

Step 20 added no public Lean declaration, so Future Work Note 14's naming review
remains exactly the Step 19 decision table. No further direct
`InformationTheory.klDiv ... != top` proof pattern appeared, and no deferred
helper crossed its proof-pressure threshold. This closes all 20 Chunk 3 steps
and prepares the coherent `Complete Project B Chunk 3` checkpoint without
selecting the next theorem phase.

### 114. Post-Chunk 3 Cleanup Checkpoint

The five-step post-Chunk-3 cleanup was completed on July 16, 2026, from the
clean `a5cc9e9` Chunk 3 checkpoint. The read-only technical audit confirmed
that the lightweight root, opt-in module boundaries, private-helper ownership,
Step 19 aliases, and simp policy remain coherent. It found no concrete Lean
cleanup worth applying, so the conditional technical-cleanup step was a
deliberate no-op.

At that cleanup checkpoint, the documentation pass normalized the then-current
38 Future Work Notes without
renumbering them or weakening their proof-pressure conditions. Note 26 is now
classified as a standing module-boundary guardrail, Note 29 is the next Project
B mathematical planning anchor, and Note 38 remains a later matrix and
majorization milestone. The index records 37 active or standing notes and one
closed historical note. `README.md`, `docs/current-lean-state.md`,
`docs/roadmap.md`, and `docs/foundation-conventions.md` now consistently state
that sufficient-statistics and recovery-equality work should be planned before
Fano. The cleanup itself deliberately stopped before activating that work.

The website checker passes for 12 HTML files and two generated JSON files. At
that checkpoint, the Future Work index contained 38 unique entries, the
detailed notes remained ordered 1 through 38, the cross-document status
assertions passed, the forbidden-placeholder and diff-hygiene scans were clean,
and no Lean, root-import, or website source file changed. Because this checkpoint
changed only five Markdown status files, no Lake rebuild or website regeneration
was required; Chunk 3 Step 20 remains the governing full milestone build. No
Chunk 4 planning or implementation was started during this cleanup.

### 115. Project B Chunk 4 Contract and Proof Spikes

Step 1 of the revised 20-step Project B Chunk 4 plan was completed on July 16,
2026. One temporary `LeanInfoTheory.Chunk4ContractSpikes` module imported
`SemanticBridge.DataProcessing` and mathlib's `Probability.Kernel.CompProdEqIff`.
Its clean 2747-job build validated every planned implication without
placeholders, and both the source file and all generated scratch artifacts were
then deleted.

The fixed-prior statistic contract is the reverse Markov condition
`Theta -> T(X) -> X`. The independent deterministic-forward spike proves
`Theta -> X -> T(X)` with no finiteness, injectivity, or support assumptions.
Applying the existing finite Markov factorization converse to the mapped
`(Theta, T(X), X)` law gives exactly one recovery channel from statistic values
to observations and reconstructs the complete triple law. This route needs
only `[Finite alpha]` for the recovered observation alphabet; it does not need
the statistic or parameter alphabet to be finite.

The family contract is now locked for raw
`model : theta -> PMF alpha` and `W : alpha -> PMF beta`: one common
`R : beta -> PMF alpha` must satisfy, for every parameter `t`,

```lean
PMF.channelJoint ((model t).bind W) R =
  (PMF.channelJoint (model t) W).map Prod.swap
```

This is exact full-joint recovery, not merely recovery of the input marginal.
The temporary hierarchical law sampled the parameter and then the swapped
output-input joint law. It was proved equal to the forward parameter-input-
output channel extension with its last two coordinates swapped. If that law is
Markov under any prior whose every parameter atom has positive mass, the
existing factorization theorem and finite `ENNReal` cancellation produce one
common `R` satisfying the displayed family contract. The proof again needs
only `[Finite alpha]` once the prior is supplied. Later use of the canonical
uniform full-support prior introduces `[Fintype theta] [Nonempty theta]` only
at the all-prior converse, not in the family definition.

The KL equality route is also locked. Under `p.support subset q.support`, the
input divergence is not `top`; KL data processing makes the output divergence
finite as well. The exact posterior decomposition can therefore cancel its
output term, mathlib's `klDiv_eq_zero_iff` turns the posterior remainder into
equality of composition-product measures, and `Kernel.compProd_eq_iff` yields
almost-everywhere equality of the two posterior kernels under
`(p.bind W).toMeasure`. The measure-level engine belongs in
`SemanticBridge.DataProcessing`, which may add the focused mathlib import.
The common-recovery/KL interpretation belongs in the later downstream
`Shannon.SemanticBridge.Sufficiency.KL` module. With the current posterior
definition, the spike uses `[Fintype alpha]`, `[Finite beta]`, and measurable
singletons. Future Work Note 37's possible `[Finite]` posterior wrapper has not
gained a production consumer and remains deferred.

For Fisher-Neyman, the textbook factorization will use finite `ENNReal`
factors: parameter/statistic factors `g t b`, one parameter-independent factor
`h a`, explicit `!= top` conditions, and
`model t a = g t (T a) * h a`. On each positive fiber, `PMF.normalize` produces
the common recovery law and the compiled spike proves the weighted
reconstruction identity after finite-sum cancellation. A zero-total fiber uses
an arbitrary fallback and has zero weight for every model law. Keep this
normalization machinery private unless another theorem independently needs it.

The negative Boolean probe used a fair input, the identity deterministic
channel, and a recovery channel that resets to the fair law. The two-stage
input marginal is exactly the original fair law, but the reconstructed joint
assigns positive mass to `(false, true)` while the original identity joint
assigns zero. This formally rules out marginal recovery as the public
sufficiency definition.

Step 1 introduced no production declaration, alias, simp rule, import edge, or
root reachability change, so Future Work Note 14 gains no naming entry. It did
not repeat the real-KL top-branch pattern, KL relabeling, injective MI
relabeling, or total-conditional-channel null-fiber arguments tracked by Notes
21, 22, 30, and 35. This closed the contract checkpoint without starting a
production declaration.

### 116. Project B Chunk 4 Deterministic Forward Markov Foundation

Step 2 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. `Shannon.SemanticBridge.Markov` now exports the type-generic theorem
`isMarkovChainOf_comp`: for any PMF `p`, variables `X` and `Y`, and function
`f`, the variables `X -> Y -> f(Y)` form a Markov chain. The statement needs no
finite-alphabet, measurable-space, injectivity, or support assumption.

The proof maps the source law to the triple `(X,Y,f(Y))`, identifies that law
with a `PMF.channelExtension` through `PMF.deterministicChannel f`, and applies
`isMarkovChain_channelExtension`. The deterministic channel-extension identity
is local to the proof. No PMF wrapper, helper declaration, alias, new import,
or bundled statistic object was added because Step 2 has only the direct
random-variable consumer needed by the next sufficiency steps.

The public name follows the established deterministic `...Of_comp` vocabulary,
is short and discoverable, and exposes no marginal, coordinate-swap, channel-
extension, or proof-helper detail. It therefore needs no Future Work Note 14
watch entry. The theorem remains explicit rather than `[simp]`: Step 5 can
invoke it directly, while Note 15 continues to reserve automatic Markov
normalization for the visibly constructor-headed
`isMarkovChain_channelExtension` rule.

The owning `Markov` module built with 2701 jobs. A temporary 2702-job consumer
imported only that module and applied `isMarkovChainOf_comp` over arbitrary
types; its source and generated artifacts were then deleted. The semantic
aggregate and lightweight root build passed with 2724 jobs. The root import and
module boundaries are unchanged. The source-derived references were refreshed:
the declaration index now contains 617 declarations, while the module graph
remains at 33 modules and 52 local edges with 11 root-reachable and 22
separately importable modules. The website checker passes for all 12 HTML files
and both generated JSON files. This completed the deterministic-forward
foundation before the entropy equality corollary was added.

### 117. Project B Chunk 4 Conditional-Entropy DPI Equality

Step 3 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. `Shannon.SemanticBridge.Markov` now exports
`condEntropyOf_dataProcessing_eq_iff`. Under a finite forward Markov chain
`X -> Y -> Z`, it states

```lean
condEntropyOf p X Y = condEntropyOf p X Z ↔
  IsMarkovChainOf p X Z Y
```

so equality in conditional-entropy data processing holds exactly when the
reverse chain is also Markov. The proof is the planned direct corollary of
`mutualInfoOf_dataProcessing_eq_iff`: both mutual-information terms are
rewritten as `H(X) - H(X | ·)`, and additive-group cancellation reverses the
conditional-entropy equality orientation. It does not duplicate the CMI or
Markov equality proof.

A temporary consumer combined `isMarkovChainOf_comp` with the new theorem to
derive the intended statistic specialization

```lean
H(Theta | X) = H(Theta | T(X)) ↔ Theta -> T(X) -> X.
```

This confirms the exact orientation needed by the fixed-prior sufficiency band
in Step 5. The consumer imported only `SemanticBridge.Markov`, built with 2702
jobs, and was deleted together with all generated artifacts.

The theorem name coherently extends the existing
`condEntropyOf_dataProcessing` and `mutualInfoOf_dataProcessing_eq_iff` family,
is discoverable, and exposes no marginal, coordinate-map, or helper detail, so
Future Work Note 14 gains no watch entry. It remains explicit under Note 15.
No PMF companion or strict-loss theorem was added: Future Work Note 33 keeps
those branches consumer-deferred.

The owning `Markov` module built with 2701 jobs, and the semantic aggregate and
lightweight root passed with 2724 jobs. Generated references now contain 618
declarations; the unchanged graph has 33 modules and 52 local edges, with 11
root-reachable and 22 separately importable modules. The website checker passes
for all 12 HTML files and both generated JSON files. This closed the theorem
prerequisites before introducing the sufficiency module.

### 118. Project B Chunk 4 Lightweight Sufficiency Core

Step 4 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. The new separately importable
`LeanInfoTheory.Shannon.SemanticBridge.Sufficiency` module imports only
`SemanticBridge.Markov`. It is included by the opt-in semantic aggregate but
not by `LeanInfoTheory.lean`, and it has no direct dependency on
`SemanticBridge.DataProcessing`, kernels, or the downstream KL sufficiency
layer.

The module introduces exactly two assumption-free definitions:

- `statisticTripleLawOf p Theta X T` is the induced PMF of
  `(Theta, T(X), X)` in parameter-statistic-observation order;
- `IsSufficientStatisticOf p Theta X T` is the fixed-prior textbook contract
  `IsMarkovChainOf p Theta (T ∘ X) X`, namely the reverse chain
  `Theta -> T(X) -> X`.

No finite-alphabet, measurable-space, support, injectivity, bundled experiment,
family-level, recovery, theorem, alias, or simp surface was added. The triple
law is the single induced construction retained because Step 6 and later
examples need the complete law rather than only a recovered marginal.

Before promotion, a temporary 2702-job contract module showed that the new
predicate reduces directly to the planned Step 5 mutual-information and
conditional-entropy preservation statements using Steps 2 and 3. An additional
premature re-elaboration of the Step 6 recovery equivalence exceeded the local
timeout, first with broad simplification and then with a targeted map bridge;
it emitted no Lean error and was removed rather than being treated as a result.
Step 1's clean recovery spike remains the governing feasibility proof. Step 6
should use an explicit intermediate law or directional applications of the
factorization theorem rather than a broad polymorphic `rw`. All temporary
sources and generated artifacts were deleted.

The production module built with 2702 jobs. Temporary positive and negative
consumers then built together with 2712 jobs: the positive file imported only
`SemanticBridge.Sufficiency` and unfolded both declarations, while the
root-only file inspected Lean's environment and verified that neither name was
reachable from `LeanInfoTheory`. The updated semantic aggregate and lightweight
root passed with 2725 jobs.

A later combined three-target post-edit check hit its command timeout without a
Lean diagnostic and left only that command's Lake/Lean children running. Their
command lines were verified, the exact process tree was terminated, and the
targets were rerun separately: `Sufficiency` passed with 2702 jobs, the semantic
aggregate with 2716 jobs, and the lightweight root with 2240 jobs. No source
repair was needed, and the final process check found no remaining Lean or Lake
process.

The two names are concise, textbook-facing, and expose only the mathematically
necessary induced triple law, so Future Work Note 14 gains no watch entry. No
simp attribute or existing policy changed. The generated declaration index now
contains 620 declarations, while the module graph contains 34 modules and 54
local edges with the root-reachable count unchanged at 11 and 23 modules
separately importable. The generator now gives the new node a factual summary;
the website checker passes for all 12 HTML files and both generated JSON files.
This completed the definitions-only module step before its first theorem band.

### 119. Project B Chunk 4 Fixed-Prior Equivalence Band

Step 5 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. `Shannon.SemanticBridge.Sufficiency` now exposes four predicate-first
characterizations of fixed-prior sufficiency:

- `isSufficientStatisticOf_iff_isMarkovChainOf` restates the assumption-free
  reverse chain `Theta -> T(X) -> X`;
- `isSufficientStatisticOf_iff_condMutualInfoOf_eq_zero` states
  `I(Theta;X | T(X)) = 0`;
- `isSufficientStatisticOf_iff_mutualInfoOf_eq` states
  `I(Theta;T(X)) = I(Theta;X)`;
- `isSufficientStatisticOf_iff_condEntropyOf_eq` states
  `H(Theta|X) = H(Theta|T(X))`.

The last three theorems use finite parameter, observation, and statistic value
types because the existing information quantities and equality theorems use
`Fintype`; the source type remains arbitrary. No support, measurability,
injectivity, or nonempty assumption was added.

The zero-CMI theorem delegates directly to
`condMutualInfoOf_eq_zero_iff_isMarkovChainOf`. The MI and conditional-entropy
theorems first invoke Step 2's assumption-free deterministic forward chain
`Theta -> X -> T(X)`, then use the canonical data-processing equality theorem
and Step 3's entropy corollary respectively. Thus the sufficiency layer does not
reprove data processing, CMI nonnegativity, or the reverse-chain equality case.

A temporary consumer imported only `SemanticBridge.Sufficiency` and used one
`IsSufficientStatisticOf` hypothesis to derive all four public consequences in
their intended `.mp` direction. Its 2703-job build passed, and its source and
all generated artifacts were deleted. The owning module passed with 2702 jobs,
the semantic aggregate with 2716, and the unchanged lightweight root with 2240.

The four names form a coherent, discoverable predicate-first family but are
long enough to be recorded as `watching` in Future Work Note 14. No declaration
was renamed or aliased. Note 15 records that all four remain explicit semantic
equivalences rather than simp rules. Step 5 added no PMF wrapper, recovery
channel, family-level predicate, import edge, or new induced law.

Generated references now contain 624 declarations. The module graph remains at
34 modules and 54 local edges, with 11 root-reachable and 23 separately
importable modules. The website checker passes for all 12 HTML files and both
generated JSON files. Step 6 is next.

A July 21, 2026 documentation and ergonomics follow-up expanded the
fixed-prior-characterization section comment into one four-view equivalence
band: reverse Markov structure, zero conditional mutual information, mutual-
information preservation, and conditional-entropy preservation. A disposable
consumer then exercised every theorem in the reverse `.mpr` direction,
including construction of `IsSufficientStatisticOf` from each of the three
information equalities. It passed with `lake env lean` and was deleted. No
declaration, statement, proof, import, attribute, alias, or module boundary
changed, so this follow-up leaves no deferred Future Work item.

### 120. Project B Chunk 4 Fixed-Prior Exact Recovery

Step 6 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. `Shannon.SemanticBridge.Sufficiency` now exposes the exact recovery
characterization
`isSufficientStatisticOf_iff_exists_recovery`. Its witness is one channel
`R : beta -> PMF alpha`, independent of the parameter value, and its equation
reconstructs the complete `(Theta, T(X), X)` law from the induced
parameter-statistic pair law. The theorem needs only `[Finite alpha]`; the
source, parameter, and statistic-value types remain unrestricted.

The proof applies `isMarkovChain_iff_exists_channelExtension` directionally to
the explicitly named induced triple law. Two representation facts connect that
law to `IsSufficientStatisticOf` and identify its first-two marginal; both are
private to the sufficiency module. This avoids exposing marginal machinery and
also avoids the broad polymorphic rewrite that timed out during the Step 4
probe.

The one-way corollary
`exists_marginal_recovery_of_isSufficientStatisticOf` maps the complete-law
equation to the observation coordinate and reuses
`PMF.channelExtension_map_output`. It concludes
`p.map X = (p.map fun omega => T (X omega)).bind R`. Its documentation states
that the converse is false, so the formally rejected marginal-only contract
cannot be mistaken for the definition of sufficiency.

A temporary consumer imported only `SemanticBridge.Sufficiency` and exercised
the full-law theorem in both directions and the marginal consequence using only
`[Finite alpha]`. It passed and was deleted with all scratch artifacts. The
owning module passed with 2702 jobs, the semantic aggregate with 2716, and the
unchanged lightweight root with 2240.

The two public names are retained unchanged during active theorem work and are
recorded as `watching` in Future Work Note 14 for the scheduled Step 19 review.
Future Work Note 15 records that both remain explicit rather than simp rules.
No public helper, PMF wrapper, canonical recovery theorem, family predicate,
new import edge, or KL dependency was added.

Generated references now contain 626 declarations, 624 with documentation.
The module graph remains at 34 modules and 54 local edges, with 11
root-reachable and 23 separately importable modules. The website checker passes
for all 12 HTML files and both generated JSON files. Step 7 is next.

### 121. Project B Chunk 4 Family Sufficiency Predicates

Step 7 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. `Shannon.SemanticBridge.Sufficiency` now defines the assumption-free
family predicate `IsSufficientChannel model W`. Its contract is exactly the
one locked in Step 1:

```lean
∃ R : beta -> PMF alpha, ∀ t,
  PMF.channelJoint ((model t).bind W) R =
    (PMF.channelJoint (model t) W).map Prod.swap
```

The existential recovery channel precedes the parameter quantifier, so the
same `R` must reconstruct every complete output-input joint law in the model
family. This is full-joint recovery rather than marginal recovery. The
definition adds no finiteness, support, measurability, or nonempty assumptions.

`IsSufficientStatistic model T` is definitionally
`IsSufficientChannel model (PMF.deterministicChannel T)`. It therefore makes a
deterministic statistic a literal specialization of the channel contract
rather than a second notion requiring later equivalence maintenance. No
bundled statistical-experiment structure, family-law constructor, or helper
predicate was introduced.

A temporary consumer imported only `SemanticBridge.Sufficiency`, introduced
and eliminated the common recovery witness, and checked the deterministic
specialization by `Iff.rfl`. It passed without typeclass assumptions and was
deleted with all scratch artifacts. The owning module passed with 2702 jobs,
the semantic aggregate with 2716, and the unchanged lightweight root with
2240.

The names `IsSufficientChannel` and `IsSufficientStatistic` are concise,
textbook-facing, and expose neither `Prod.swap` nor joint-law implementation
details, so Future Work Note 14 gains no watch entry. Future Work Note 15
records that neither controlled definition unfolds globally. No theorem, simp
rule, recovery constructor, import edge, or KL dependency was added.

Generated references now contain 628 declarations, 626 with documentation.
The module graph remains at 34 modules and 54 local edges, with 11
root-reachable and 23 separately importable modules. The website checker passes
for all 12 HTML files and both generated JSON files. Step 8 is next.

### 122. Project B Chunk 4 Supported Common Posteriors

Step 8 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. The existing posterior owner `Shannon.SemanticBridge.DataProcessing` now
imports the lightweight sufficiency core directly and exposes
`isSufficientChannel_iff_exists_common_posterior`. For `[Fintype alpha]`, it
states

```lean
IsSufficientChannel model W ↔
  ∃ R : beta -> PMF alpha, ∀ t b,
    b ∈ ((model t).bind W).support →
      channelPosterior (model t) W b = R b
```

Thus one posterior channel must agree with every model posterior wherever that
model's output law is positive. The theorem imposes no condition on null
output fibers, so the documented fallback chosen by the total
`channelPosterior` receives no conditional-probability meaning. The parameter
and output alphabets remain unrestricted, and no support, measurability, or
nonempty assumption beyond the displayed support guard is added.

The proof compares the exact recovery law with
`channelPosterior_reconstructs_joint`. A private generic lemma identifies two
channels from equality of their induced joint laws exactly on the input law's
support; its forward direction cancels one finite nonzero PMF mass and its
reverse direction makes null input atoms vanish. The helper has one production
consumer and remains private rather than expanding the finite-channel or
total-conditional-channel API.

The lightweight core separately adds the only requested sanity law,
`isSufficientStatistic_id`: the identity statistic is sufficient for every
model family without assumptions. Its proof uses the deterministic identity
channel as the common recovery channel. No constant, injective, bijective, or
second identity-channel convenience theorem was added.

A temporary proof spike compiled the complete support characterization and
identity theorem, then was deleted. A public consumer exercised both directions
of the iff and the identity theorem. Its first run exceeded the 124-second
shell timeout; the exact orphaned Lean/Lake process tree was terminated, and a
clean retry passed. The consumer and all scratch artifacts were then deleted.
The sufficiency core passed with 2702 jobs, the data-processing owner with
2715, the semantic aggregate with 2716, and the unchanged lightweight root
with 2240.

Future Work Note 14 records the descriptive common-posterior theorem as
`watching` for Step 19 while retaining its current name; the identity theorem
is concise and needs no watch entry. Note 15 keeps both theorems explicit.
Note 30 records the one-consumer private support-identifiability helper, and
Note 37 records that this first production sufficiency consumer works directly
with the existing `[Fintype alpha]` posterior API. No new posterior wrapper,
null-fiber law, averaged fiber-KL formula, public helper, simp rule, or module
was added.

Generated references now contain 630 declarations, 628 with documentation.
The module graph remains at 34 modules and now has 55 local edges because
`DataProcessing` directly imports `Sufficiency`; root reachability remains 11
with 23 modules separately importable. The website checker passes for all 12
HTML files and both generated JSON files. Step 9 is next.

### 123. Project B Chunk 4 Every-Prior Sufficiency Consequences

Step 9 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. `Shannon.SemanticBridge.Sufficiency` now proves that one common family
recovery channel has the expected consequences under every parameter prior.
The assumption-free theorem `isMarkovChainOf_of_isSufficientChannel` gives the
reverse chain `parameter -> output -> input` in the generated hierarchical
law. For finite parameter, input, and output alphabets, the same hypothesis
also yields:

- `condMutualInfo_eq_zero_of_isSufficientChannel`;
- `mutualInfo_eq_of_isSufficientChannel`;
- `condEntropy_eq_of_isSufficientChannel`.

The proof keeps the prior/model/channel law inline rather than publishing a
second statistical-experiment constructor. One private theorem swaps the
input and output coordinates in that law, uses the common recovery equation
atomwise, and identifies the result as a channel extension through the shared
recovery channel. The existing generated-chain theorem then supplies the
reverse Markov property. The zero-CMI corollary delegates to the established
Markov characterization, while the mutual-information and conditional-entropy
corollaries combine the forward channel-extension chain with the existing
data-processing equality characterizations. No analytic proof, posterior
argument, KL dependency, or stronger support assumption is duplicated.

This conditional-entropy corollary is the first independent PMF consumer
anticipated by Future Work Note 33, so `Markov` now also exposes the direct
law-level theorem `condEntropy_dataProcessing_eq_iff` beside its existing
random-variable counterpart. The new PMF theorem is a thin specialization of
that counterpart and lets the sufficiency proof remain at the law level. The
zero-CMI proof instead reuses the existing
`condMutualInfo_eq_zero_iff_isCondIndependent`; it does not create a second
consumer for Future Work Note 27's deferred Markov-specific PMF wrapper.

A temporary standalone consumer imported only `SemanticBridge.Sufficiency`
and exercised the PMF bridge plus all four family consequences; it passed and
was deleted with its artifacts. The Markov owner, sufficiency core, downstream
data-processing layer, semantic aggregate, and lightweight root pass with
2701, 2702, 2715, 2716, and 2240 jobs respectively. The website checker passes
for all 12 HTML files and both generated JSON files.

All five declarations remain explicit rather than `[simp]`. The four family-
consequence names are preserved during active theorem development and recorded
as `watching` in Future Work Note 14. In particular,
`isMarkovChainOf_of_isSufficientChannel` has an awkward repeated `Of_of`, while
the three equality names do not make their preserved endpoints explicit.
Conceptual implication/preservation aliases remain unapproved until the Step
19 examples test discovery and proof readability. The private coordinate-swap
helper creates no public naming or abstraction commitment. The direct PMF
conditional-entropy name coherently mirrors
`condEntropyOf_dataProcessing_eq_iff` and needs no separate watch entry.

Generated references now contain 635 declarations, 633 with documentation.
The module graph remains at 34 modules and 55 local edges, with 11
root-reachable and 23 separately importable modules. Step 10 is next.

### 124. Project B Chunk 4 Full-Support and All-Prior Characterizations

Step 10 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. The lightweight sufficiency core now exposes the finite converse to Step
9 and the standard all-priors characterizations.

The weakest public channel theorem is
`isSufficientChannel_iff_isMarkovChainOf_of_support_eq_univ`. Given one
supplied prior whose support is all of the parameter type, it characterizes
`IsSufficientChannel model W` by the reverse Markov condition in the generated
parameter-input-output law. Its only typeclass assumption is `[Finite alpha]`
for the recovered model-input alphabet; the parameter and output alphabets
remain unrestricted.

For `[Finite theta] [Nonempty theta] [Finite alpha]`,
`isSufficientChannel_iff_forall_isMarkovChainOf` gives the familiar statement
quantified over every parameter prior. The converse installs
`Fintype.ofFinite theta` only inside the proof and applies the full-support
theorem to `PMF.uniformOfFintype theta`. Thus the public theorem does not
require a chosen finite enumeration.

The deterministic specialization is available at both levels:

- `isSufficientStatistic_iff_isSufficientStatisticOf_of_support_eq_univ` says
  that family sufficiency is equivalent to the existing fixed-prior
  `IsSufficientStatisticOf` predicate under one full-support prior;
- `isSufficientStatistic_iff_forall_isSufficientStatisticOf` gives the
  textbook all-priors characterization on a finite nonempty parameter type.

The converse proof swaps the last two coordinates of the generated law,
applies the existing existential Markov channel-factorization theorem, and
identifies its first-two marginal with the parameter-output law. Evaluating the
factorization at `(t,b,a)` and cancelling the finite nonzero prior mass yields
one recovery channel valid for every parameter value. The generated law,
coordinate-swap injectivity, and deterministic representation bridge remain
private; no bundled experiment law or public marginal helper was introduced.

The exact deterministic representation acquired a second production consumer,
so the type-generic explicit theorem
`PMF.channelExtension_deterministicChannel` now lives beside the existing
deterministic laws in `Probability.FiniteChannel`. Step 2's local proof was
replaced by this shared constructor reduction. The four sufficiency iff
theorems remain explicit, and no metric-by-metric all-priors iff family was
added merely to mirror the Step 9 consequences.

A temporary consumer imported only `SemanticBridge.Sufficiency` and exercised
the deterministic-extension law and all four public characterizations. It
passed and was deleted with its artifacts. Focused builds pass for
`Probability.FiniteChannel`, `SemanticBridge.Markov`, and
`SemanticBridge.Sufficiency`, `SemanticBridge.DataProcessing`, the semantic
aggregate, and the lightweight root with 1698, 2701, 2702, 2715, 2716, and
2240 jobs respectively. The website checker passes for all 12 HTML files and
both generated JSON files.

Future Work Note 14 records the four long iff names as `watching` for Step 19;
the deterministic-extension name is concise and coherent with
`channelJoint_deterministicChannel`. Note 15 records the failed simp probe and
keeps the constructor reduction and all four semantic equivalences explicit.
Notes 26, 27, 29, 30, and 39 retain the existing module and scope boundaries.

Generated references contain 640 declarations, 638 with
documentation. The module graph remains at 34 modules and 55 local edges, with
11 root-reachable and 23 separately importable modules. Step 11 is next.

### 125. Project B Chunk 4 Midpoint Contract Review

Step 11 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. Two temporary positive consumers and one negative root-isolation probe
tested the completed recovery API before the analytic layer begins; all three
sources were deleted after the review.

The core-only consumer imported `SemanticBridge.Sufficiency` and used the model
that fixes an observation's first Boolean coordinate to the parameter while
leaving its second coordinate uniform. Projection to the first coordinate is
genuinely noninjective on two positive-mass observations for each parameter,
yet the parameter-indexed copy of that same model is one exact common recovery
channel. The consumer proved family sufficiency, exercised both the full-
support-prior and all-priors deterministic-statistic characterizations, and
confirmed that the opposite statistic value is a null output fiber for each
individual model.

The same consumer separated two negative contracts. Point-mass models at
`false` and `true` admit no common recovery through the constant `Unit`
statistic: evaluating a hypothetical recovered joint law at `((), true)`
would force the same recovery mass to be both zero and one. Separately, a fair
Boolean law passed through the identity statistic and then reset to the fair
law recovers its input marginal, but its reconstructed joint assigns positive
mass to `(false, true)` while the identity graph law assigns zero. Thus the
public exact full-joint recovery contract rejects the intended marginal-
recovery false positive.

The second consumer imported `SemanticBridge.DataProcessing` and exercised
`isSufficientChannel_iff_exists_common_posterior`. It verified the positive and
null output supports explicitly. More sharply, on a null output the documented
total-posterior fallback equals the current model law, while the common
posterior value at that output is fixed by the opposite model, for which the
same output is supported. Those PMFs differ. The support guard is therefore
mathematically necessary rather than defensive syntax, and no null-fiber
equality, helper, or stronger assumption should be added.

The import review confirmed that the core still imports only `Markov`, while
the posterior theorem remains downstream in `DataProcessing` with the kernel
and KL imports. A root-only probe failed with the expected unknown identifier
for `IsSufficientChannel`; the lightweight root remains isolated. The Step 10
full-support/all-priors names were usable in the examples and remain `watching`
for the scheduled Step 19 review, but the midpoint supplies no reason to add an
alias or rename a declaration now. No new public declaration, simp rule,
private production helper, module edge, or root import was added.

The temporary core and posterior consumers compiled cleanly. Focused builds
passed for `SemanticBridge.Sufficiency` and
`SemanticBridge.DataProcessing` with 2702 and 2715 jobs, and the combined
semantic aggregate/lightweight-root build passed with 2725 jobs. Generated
references therefore remain at 640 declarations, 638 documented; the graph
remains at 34 modules and 55 local edges with 11 root-reachable and 23
separately importable modules. Step 12, finite Fisher-Neyman factorization, is
next.

### 126. Project B Chunk 4 Finite Fisher-Neyman Factorization

Step 12 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. The lightweight `SemanticBridge.Sufficiency` core now exports
`isSufficientStatistic_iff_exists_fisherNeymanFactorization`. For
`[Finite alpha] [Nonempty alpha]`, it characterizes
`IsSufficientStatistic model T` by the existence of finite `ENNReal` factors

```lean
g : theta -> beta -> ENNReal
h : alpha -> ENNReal
```

such that `model t a = g t (T a) * h a` for every parameter and observation.
Neither the parameter nor statistic alphabet must be finite, and no selected
enumeration of the observation alphabet appears in the public theorem.

For the forward implication, an exact common recovery channel `R` supplies
`g t b = (model t).map T b` and `h a = R (T a) a`. Both are finite because
they are PMF atoms. Evaluating the common full-joint recovery equation at
`(T a, a)` gives the required factorization directly. Thus this direction
reuses the established recovery contract rather than deriving the factors
through ratios or support cases.

For the converse, the proof forms the parameter-independent weight `h a` on
each fiber `T a = b`. A local `Fintype.ofFinite alpha` proves that the fiber's
total weight is finite. On a positive-total fiber, `PMF.normalize` gives the
recovery row; the channel-output mass factors as `g t b` times the fiber total,
and finite nonzero `ENNReal` cancellation proves exact joint recovery. On a
zero-total fiber every corresponding `h a`, and hence every model atom in that
fiber, is zero, so an arbitrary pure fallback is observationally irrelevant.

The fiber weight, fiber total, recovery construction, finiteness proof, and
pointwise output-mass identity are all private to the sufficiency module. No
general PMF normalization theorem, public factorization predicate, bundled
experiment, stronger alphabet assumption, KL import, or simp rule was added.
The semantic aggregate's API overview now mentions the theorem, while the
lightweight root remains unchanged.

A temporary standalone consumer imported only `SemanticBridge.Sufficiency`.
It supplied explicit Fisher-Neyman factors for the genuinely noninjective model
`pure t` independently paired with a fair bit and the statistic `Prod.fst`,
used the theorem to prove sufficiency, then extracted factors back from that
sufficiency proof. A generic factorization-to-sufficiency invocation also
compiled. The consumer and the complete proof spike were deleted afterward.

The public theorem name is textbook-facing and exposes no implementation
helper, but it is unusually long; Future Work Note 14 records it as `watching`
for the scheduled Step 19 API review. The focused `Sufficiency` build passed
with 2702 jobs, `DataProcessing` passed with 2715, the semantic aggregate
passed with 2716, and the lightweight root passed with 2240. Generated
references now contain 641 declarations, 639 documented. The graph remains at
34 modules and 55 local edges, with 11 root-reachable and 23 separately
importable modules. Step 13's guarded measure-level KL equality engine is next.

### 127. Project B Chunk 4 Guarded KL Equality Engine

Step 13 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. `Shannon.SemanticBridge.DataProcessing` now exports
`klDiv_channel_eq_iff_posterior_ae_eq`. For `[Fintype alpha] [Finite beta]`
and `p.support ⊆ q.support`, it states

```lean
InformationTheory.klDiv (p.bind W).toMeasure (q.bind W).toMeasure =
    InformationTheory.klDiv p.toMeasure q.toMeasure ↔
  pmfChannelKernel (channelPosterior p W) =ᵐ[(p.bind W).toMeasure]
    pmfChannelKernel (channelPosterior q W)
```

Thus the guarded equality case of finite KL data processing is exactly almost-
everywhere agreement of the two posterior kernels under the first output law.
The support hypothesis excludes the uninformative infinite-divergence branch;
no separate output-support hypothesis is exposed.

The proof isolates `ENNReal` cancellation in one private helper with the
explicit hypothesis
`InformationTheory.klDiv p.toMeasure q.toMeasure ≠ ⊤`. The exact
`klDiv_channel_eq_add_posterior` decomposition reduces channel-DPI equality to
zero posterior remainder. Mathlib's `InformationTheory.klDiv_eq_zero_iff`
then identifies the two composition-product measures, and the focused
`Kernel.compProd_eq_iff` theorem converts that equality to almost-everywhere
kernel equality. The public wrapper obtains KL finiteness from
`klDiv_pmf_ne_top_iff_support_subset`.

`DataProcessing` now directly imports
`Mathlib.Probability.Kernel.CompProdEqIff`; no kernel or KL dependency moved
into the lightweight `Sufficiency` core or root. Step 13 deliberately adds no
pointwise supported-output theorem, real-valued equality theorem, recovery
channel, posterior wrapper, fiberwise KL expansion, alias, or simp rule. Those
finite-facing forms remain Step 14 work.

A temporary standalone consumer imported only `SemanticBridge.DataProcessing`
and exercised both directions of the public iff, then was deleted with its
generated artifacts. The owning module passed with 2747 jobs, the semantic
aggregate with 2748, and the unchanged lightweight root with 2240. Generated
references now contain 642 declarations, 640 documented. The local graph
remains at 34 modules and 55 edges, with 11 root-reachable and 23 separately
importable modules. Step 14's pointwise posterior and guarded real-valued forms
are next.

### 128. Project B Chunk 4 Finite Posterior Equality API

Step 14 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. `Shannon.SemanticBridge.DataProcessing` now exports the primary finite-
facing theorem `klDiv_channel_eq_iff_posterior_eq_on_support`. Under
`[Fintype alpha] [Finite beta]` and `p.support ⊆ q.support`, it states

```lean
InformationTheory.klDiv (p.bind W).toMeasure (q.bind W).toMeasure =
    InformationTheory.klDiv p.toMeasure q.toMeasure ↔
  ∀ b, b ∈ (p.bind W).support →
    channelPosterior p W b = channelPosterior q W b
```

The relevant outputs are exactly those reached by the first law. No condition
is imposed on null outputs, where the total posterior's fallback is arbitrary.
The input support guard excludes the infinite-divergence equality branch and
is unchanged from Step 13.

The proof deliberately consumes
`klDiv_channel_eq_iff_posterior_ae_eq` rather than reproving KL cancellation.
Mathlib's `Kernel.compProd_eq_iff` converts almost-everywhere kernel agreement
back to equality of composition products; `channelJoint_toMeasure` and
`PMF.toMeasure_inj` then recover equality of PMF joint laws. The existing
private `channelJoint_eq_iff_eq_on_support` helper supplies exactly the final
supported-output pointwise characterization. Its cancellation proof is reused,
not duplicated, and it remains private because callers now have the intended
posterior theorem.

The companion
`toReal_klDiv_channel_eq_iff_posterior_eq_on_support` gives the same pointwise
criterion for equality of the two real-valued KL divergences. Input support
inclusion makes the input divergence finite, and `klDiv_channel_le` transfers
that finiteness to the output divergence. Consequently
`ENNReal.toReal_eq_toReal_iff'` reduces the real equality exactly to the
`ENNReal` theorem without inspecting a top branch.

Step 14 adds no new definition, private helper, import edge, recovery theorem,
deterministic specialization, posterior wrapper, fiberwise KL expansion,
alias, or simp rule. The Step 13 almost-everywhere theorem remains public and
unchanged as the lower-level measure bridge. A temporary consumer imported
only `SemanticBridge.DataProcessing` and exercised both directions of both new
iff theorems, then was deleted with its artifacts.

The owning module passed with 2747 jobs, the semantic aggregate with 2748, and
the unchanged lightweight root with 2240. Generated references now contain 644
declarations, 642 documented. The local graph remains at 34 modules and 55
edges, with 11 root-reachable and 23 separately importable modules. Step 15's
downstream `Shannon.SemanticBridge.Sufficiency.KL` module is next.

### 129. Project B Chunk 4 Pairwise KL Preservation by Exact Recovery

Step 15 of the revised 20-step Project B Chunk 4 plan was completed on July 17,
2026. The new separately importable
`Shannon.SemanticBridge.Sufficiency.KL` module imports only
`SemanticBridge.DataProcessing`, which already depends on the lightweight
sufficiency core. The semantic aggregate imports the new module explicitly,
while `Shannon.SemanticBridge.Sufficiency` and `LeanInfoTheory.lean` remain
unchanged.

The module exports `klDiv_channel_eq_of_common_recovery`. For two finite input
laws `p` and `q`, a forward channel `W`, and one recovery channel `R`, it assumes
that `R` exactly reconstructs each complete output-input joint law:

```lean
PMF.channelJoint (p.bind W) R = (PMF.channelJoint p W).map Prod.swap
PMF.channelJoint (q.bind W) R = (PMF.channelJoint q W).map Prod.swap
```

It concludes equality between the output and input `ENNReal` KL divergences.
No support inclusion or explicit-finiteness hypothesis is needed: the theorem
remains valid when both sides are infinite.

A private helper projects one full-joint recovery equation along `Prod.snd` to
obtain `(p.bind W).bind R = p`. The public proof applies
`klDiv_channel_le` first through `W` and then through `R`; the two recovered
marginals make the reverse inequality exactly the input divergence. Thus the
result introduces no second analytic proof, posterior expansion, kernel
equality argument, KL relabeling, support transport, or real-valued top-branch
elimination. The helper stays private because callers need the exact-recovery
theorem rather than a weaker marginal-recovery surface.

This step deliberately stops at the two-law forward implication. It does not
add the guarded converse or deterministic variants assigned to Step 16, and it
does not add the model-family `IsSufficientChannel` wrapper assigned to Step
17. The public name is conceptual, discoverable beside the KL channel family,
and exposes no marginal, coordinate-swap, posterior, or kernel implementation
detail, so Future Work Note 14 gains no watch entry. The theorem remains
explicit rather than `[simp]`.

The focused module passed with 2748 jobs, the semantic aggregate with 2749,
and the unchanged lightweight root with 2240. A standalone positive consumer
exercised the exported theorem. Core-only and root-only probes both failed with
the expected unknown-identifier error. An initial concurrent validation batch
hit its shell timeout; its exact Lake/Lean process tree was terminated, and all
checks then passed sequentially. Every temporary source was deleted.

Generated references now contain 645 declarations, 643 documented. The graph
now records 35 modules and 57 local edges, with 11 root-reachable and 24
separately importable modules. Step 16's guarded common-recovery converse and
deterministic specializations are next.

### 130. Project B Chunk 4 Guarded KL Equality by Common Recovery

Step 16 of the revised 20-step Project B Chunk 4 plan was completed on July 21,
2026. `Shannon.SemanticBridge.Sufficiency.KL` now exports the four-theorem
guarded equality family:

- `klDiv_channel_eq_iff_exists_common_recovery`;
- `toReal_klDiv_channel_eq_iff_exists_common_recovery`;
- `klDiv_map_eq_iff_exists_common_recovery`;
- `toReal_klDiv_map_eq_iff_exists_common_recovery`.

For two input laws `p` and `q`, the channel forms state that equality in KL data
processing is equivalent to the existence of one `R : beta -> PMF alpha` that
exactly reconstructs both complete output-input joint laws. The common input
support condition `p.support ⊆ q.support` is used only for the equality-to-
recovery direction. It makes the input divergence finite and therefore rules
out the uninformative equality `top = top`; the reverse implication delegates
to Step 15's unconditional `klDiv_channel_eq_of_common_recovery`.

The converse applies
`klDiv_channel_eq_iff_posterior_eq_on_support`, chooses
`channelPosterior q W` as the common recovery channel, and reconstructs the
`q` law canonically. Supported posterior equality identifies that channel with
`channelPosterior p W` on `(p.bind W).support`, so the same channel reconstructs
the `p` law. The proof starts from public `[Finite]` assumptions and installs
one local `Fintype.ofFinite alpha` only to construct this existential posterior
witness; no `Fintype` instance appears in the theorem statement.

This proof created the first downstream need for the generic theorem saying
that two channels induce the same joint law from `p` exactly when they agree on
`p.support`. The former private data-processing helper is therefore now the
documented public theorem `PMF.channelJoint_eq_iff_eq_on_support` in the opt-in
`Probability.FiniteChannel` owner. `DataProcessing` reuses that theorem for its
existing common-posterior and finite posterior-equality results, so the
positive-mass cancellation argument is not duplicated and no analytic import
moves into the finite-channel module.

The deterministic forms specialize the channel iff theorems through
`PMF.deterministicChannel` and simplify their public statements to `PMF.map`
and the graph law `p.map fun a => (a, T a)`. The real forms use input KL
finiteness and channel data processing with
`ENNReal.toReal_eq_toReal_iff'`; they do not manually eliminate a zero/top
branch. Step 16 adds no family-level `IsSufficientChannel` theorem and makes no
claim that unrelated pairwise equality witnesses combine into one global
recovery channel; that integration remains Step 17 work.

All five new declarations remain explicit rather than `[simp]`. The generic
helper and the four long recovery-iff names are recorded for the scheduled
Future Work Note 14 review, with no declaration renamed or aliased during the
active theorem phase. The helper promotion closes its specific private/public
trigger in Future Work Note 30 without broadening the remaining null-fiber
convenience work.

The finite-channel module passed with 1698 jobs, `DataProcessing` with 2747,
`Sufficiency.KL` with 2748, the semantic aggregate with 2749, and the unchanged
lightweight root with 2240. A standalone consumer checked all five names and
exercised both implication directions. `DataProcessing`-only and root-only
probes both failed with the expected unknown identifier for the downstream iff
theorem. The first full scratch run reached its shell timeout; its exact
Lake/Lean process tree was stopped, and an isolated longer retry passed before
production edits. All temporary files were deleted.

Generated references now contain 650 declarations, 648 documented. The graph
remains at 35 modules and 57 local edges, with 11 root-reachable and 24
separately importable modules. Step 17's family-level KL integration is next.

### 131. Project B Chunk 4 Family KL Integration

Step 17 of the revised 20-step Project B Chunk 4 plan was completed on July 22,
2026. `Shannon.SemanticBridge.Sufficiency.KL` now exports four family-facing
theorems:

- `klDiv_eq_of_isSufficientChannel`;
- `klDiv_eq_of_isSufficientStatistic`;
- `isSufficientChannel_iff_klDiv_eq_bool`;
- `isSufficientStatistic_iff_klDiv_eq_bool`.

The two forward theorems state that a sufficient family channel, or its
deterministic-statistic specialization, preserves `ENNReal` KL divergence
between every pair of model laws. The proof extracts the one recovery channel
already shared by the whole family and applies Step 15's unconditional two-law
theorem. The parameter type remains unrestricted, no support inclusion is
needed, and the statement remains valid when the divergence is `top`.

The two iff theorems provide precisely the guarded binary converse justified
by Step 16. For a model indexed by `Bool` and
`(model false).support subset (model true).support`, preservation of the
directed KL divergence from the `false` law to the `true` law produces one
recovery channel for both laws. Those two cases exhaust the Boolean family, so
the witness proves `IsSufficientChannel`; unfolding the deterministic channel
gives the statistic form. No theorem combines independently chosen pairwise
witnesses for a larger family.

Step 17 deliberately adds no real-valued wrapper. Its canonical forward result
is an exact `ENNReal` equality, while Step 16 already owns the support-guarded
real two-law recovery criterion. Applying `ENNReal.toReal` to the forward
equality is immediate but gives little information in the `top = top` case, so
no duplicate public declaration is justified without a consumer.

All four declarations remain explicit rather than `[simp]`. The two forward
names are concise and align with the existing
`..._of_isSufficientChannel` consequence band. The Boolean iff names are
accurate but their trailing `_bool` is slightly awkward to parse, so Future
Work Note 14 records them as `watching` for the scheduled Step 19 example-
informed review; no declaration was renamed or aliased during the theorem
step. The results remain in the downstream KL module, add no import edge, and
leave both the lightweight sufficiency core and root unchanged.

The production `Sufficiency.KL` build passed with 2748 jobs, and the semantic
aggregate/root command passed with 2758 jobs. A standalone consumer exercised
both forward declarations and both directions across the binary iff family.
Data-processing-only and root-only probes failed with the expected unknown-
identifier error. The first scratch elaboration reached its short shell
timeout; its exact Lake/Lean process tree was stopped, and a longer isolated
retry passed before the production edit. All temporary files were deleted.

Generated references now contain 654 declarations, 652 documented. The graph
remains at 35 modules and 57 local edges, with 11 root-reachable and 24
separately importable modules. Step 18's permanent sufficient-statistics
examples are next.

### 132. Project B Chunk 4 Permanent Sufficient-Statistics Examples

Step 18 of the revised 20-step Project B Chunk 4 plan was completed on July 22,
2026. The new separately importable
`LeanInfoTheory.Examples.SufficientStatistics` module imports only the
downstream `Shannon.SemanticBridge.Sufficiency.KL` owner. The examples aggregate
imports the module, while `LeanInfoTheory.lean` remains unchanged.

The positive experiment attaches an independent fair nuisance bit to a binary
signal and retains only the signal coordinate. The statistic is globally
noninjective and, for every parameter in the midpoint model, maps two distinct
positive-support observations to the same value. One explicit recovery channel
resamples the discarded nuisance bit, proving family sufficiency without
pretending that sufficiency means injectivity.

Public declarations exercise the fixed-prior predicate and mutual-information
equality, exact fixed-prior recovery, family sufficiency, the every-prior
characterization, finite Fisher-Neyman factorization, and pairwise KL
preservation. A second overlapping-support model exercises both the channel and
deterministic-statistic Boolean KL converses. A disposable consumer used both
directions of both iff declarations. A further proper-support probe relabeled a
pair through `Bool.not` and confirmed that the opposite support orientation is
handled by a short reindexing proof; it creates no need for a reverse-oriented
or orientation-neutral duplicate theorem.

The two negative examples preserve the midpoint contract. A constant statistic
cannot be sufficient for two separated point-mass laws. Separately, the
identity statistic followed by a reset-to-fair recovery channel reproduces the
observation marginal but not the complete identity graph law. This keeps the
distinction between marginal recovery and the project's exact full-joint
sufficiency contract visible in production Lean.

All 32 new public declarations are documented and live under descriptive
example namespaces. None exposes a private marginal, coordinate-swap, fiber, or
normalization helper, so the Step 18 naming audit adds no new Note 14 watch
entry. The examples add no simp declaration, compatibility alias, core theorem,
posterior wrapper, KL relabeling result, support-bind helper, or marginal-
recovery KL theorem. Existing compatibility and ownership decisions remain
reserved for Step 19.

`lake build LeanInfoTheory.Examples.SufficientStatistics` passed with 2749 jobs,
the examples aggregate passed with 2760 jobs, and the semantic aggregate/root
command passed with 2758 jobs. A positive consumer imported only the new module
and checked the representative public surface; a root-only consumer failed with
the expected unknown identifier. All disposable files were deleted. Generated
references now contain 686 declarations, 684 documented. The graph records 36
modules and 59 local edges, with 11 root-reachable and 25 separately importable
modules. The website checker passed without a redesign.

### 133. Project B Chunk 4 API, Documentation, and Module Review

Step 19 of the revised 20-step Project B Chunk 4 plan was completed on July 22,
2026. The scheduled naming review exercised every watched family through the
permanent sufficient-statistics examples and a disposable downstream API
consumer. It approved no new compatibility alias. The existing names are long
where their statements carry genuine distinctions: fixed-prior versus family
sufficiency, full-joint versus marginal recovery, one existential witness,
full-support versus all-prior hypotheses, finite support guards, and `ENNReal`
versus real KL. Shortening those names would hide more contract than it would
improve discovery. All existing declarations remain unchanged, and Future Work
Note 14 now records the ten declined families in its decision table.

The simp review likewise made no change. Sufficiency definitions and semantic
equivalences remain controlled, explicit views; recovery, posterior, Fisher-
Neyman, and KL equality theorems are not constructor-reducing normalizations.
The existing lower-level channel constructor and projection rules remain the
canonical simp surface. In particular, `isSufficientStatistic_id` still has no
repeated automatic-closure pressure.

The documentation-only Lean pass now explains the intentional
`(parameter, statistic, observation)` order, the fixed-prior versus family
distinction, full-joint recovery and its null-fiber convention, the quantifier
order `exists R, forall t`, common supported posteriors, generated-law
coordinates, full-support prior cancellation, and the separate roles of the
two finite Fisher-Neyman factors. No theorem statement, proof, definition,
import, attribute, or public name changed.

The measured ownership review retained all three boundaries. After the comment
pass, `Sufficiency` has 778 source lines, 20 public and 11 private declarations,
imports only `Markov`, and is imported directly by `DataProcessing` and the
semantic aggregate. `DataProcessing` has 611 lines, 23 public and four private
declarations, directly imports `Markov`, `Sufficiency`, and its two focused
mathlib KL/kernel modules, and is imported by `Sufficiency.KL`,
`Examples.StochasticChannels`, and the aggregate. `Sufficiency.KL` has 308
lines, nine public and two private declarations, imports only `DataProcessing`,
and is imported by `Examples.SufficientStatistics` and the aggregate. None is
root-reachable. Source-triggered focused builds reported 40, 38, and 36 seconds
respectively; cached invocations were about eight seconds each. The consumers
show a stable lightweight-core/posterior-engine/KL-integration ownership split,
with no repeated cross-boundary proof or light consumer justifying a move.

Focused builds passed with 2702 jobs for `Sufficiency`, 2747 for
`DataProcessing`, 2748 for `Sufficiency.KL`, and 2749 for
`Examples.SufficientStatistics`; follow-up semantic aggregate and lightweight
root builds passed with 2749 and 2240 jobs. A disposable consumer resolved all
watched names through the downstream import. A guarded root-only consumer
compiled successfully while asserting the expected unknown-identifier
diagnostic, and a source scan confirmed that the sufficiency and example
modules add no simp declaration. Both temporary files were
deleted. A representative `#print axioms` audit of the fixed-prior recovery,
common-posterior, Fisher-Neyman, recovery/KL, and Boolean-converse families
reported only `propext`, `Classical.choice`, and `Quot.sound`, with no
`sorryAx`. Regenerated references remain at 686 declarations, 684 documented,
and 36 modules with 59 local edges, 11 root-reachable and 25 separately
importable; the website checker passes. Notes 21, 22, 27, 30, 33-37, 39, and
40 retain their evidence-based triggers; Step 19 creates no second production
consumer for any deferred helper or wrapper. Step 20 remains the full milestone
integration, generated-
reference, website, ten-target build, hygiene, and checkpoint step.

### 134. Project B Chunk 4 Milestone Integration

Step 20 of the revised 20-step Project B Chunk 4 plan was completed on July 22,
2026. The final scope review confirmed that the finite-channel, Markov,
sufficiency, posterior/KL equality, example, documentation, generator, and
generated-reference changes all belong to the planned milestone.
`LeanInfoTheory.lean` has no diff. The new `SemanticBridge.Sufficiency`,
`SemanticBridge.Sufficiency.KL`, and `Examples.SufficientStatistics` modules
remain separately importable outside the lightweight root.

The complete milestone build suite passed without requiring a cold rebuild:

- `lake build LeanInfoTheory` (2240 jobs);
- `lake build LeanInfoTheory.Shannon.EntropyBounds` (2650 jobs);
- `lake build LeanInfoTheory.Shannon.Units` (2235 jobs);
- `lake build LeanInfoTheory.Shannon.SemanticBridge` (2749 jobs);
- `lake build LeanInfoTheory.MathlibFragments` (2700 jobs);
- each of `Certificate.Submodularity`, `Certificate.Subadditivity`,
  `Certificate.Monotonicity`, and `Certificate.ThreeWaySubadditivity` (1076
  jobs each);
- `lake build LeanInfoTheory.Examples` (2760 jobs).

Guarded temporary consumers checked the architecture at each intended boundary.
The lightweight root does not expose `IsSufficientStatistic`; the core
`Sufficiency` import does not expose recovery/KL integration; and
`DataProcessing` does not expose the downstream common-recovery theorem. A
`Sufficiency.KL` consumer exercised the principal recovery and family-KL
declarations, while an example-only consumer exercised the positive
noninjective model, Fisher-Neyman and KL results, constant negative example,
and marginal-only false positive. All probes passed and were deleted.
Representative `#print axioms` checks reported only `propext`,
`Classical.choice`, and `Quot.sound`, with no `sorryAx`.

Both source-derived generators are byte-for-byte idempotent. The declaration
index contains 686 public declarations, 684 documented. The dependency graph
contains 36 modules and 59 local edges: 11 modules are root-reachable and 25
remain separately importable. All three new Chunk 4 modules are explicitly
non-root-reachable. The website checker passed for 12 HTML files and both
generated JSON files without a redesign.

The forbidden-placeholder, scratch/temporary-file, stale-process,
root-import, untracked-file-scope, and `git diff --check` audits passed. Step 20
adds no public Lean declaration, alias, simp rule, helper, import edge, or
Future Work trigger. Future Work Note 14 therefore remains exactly the Step 19
decision table, and the proof-pressure notes retain their existing thresholds.
This closes all 20 Chunk 4 steps and forms the coherent
`Complete Project B Chunk 4` checkpoint without starting Fano or any later
sufficiency extension.

### 135. Post-Chunk 4 Handoff Cleanup

Step 3 of the four-step post-Chunk 4 cleanup was completed on July 23, 2026.
The maintained current-state header now records the Chunk 3 and Chunk 4
checkpoint commits alongside the earlier milestones. Its new Chunk 5 handoff
identifies the focused finite Fano phase governed by Future Work Note 29,
including the intended error-event, binary/q-ary entropy, conditional-entropy,
and uniform-message surfaces and the explicit later-work boundary. This is a
scope handoff, not a locked execution plan, and no Fano declaration or module
has been started.

The two documentation gaps recorded at the Chunk 4 checkpoint were closed at
their source declarations:
`LeanInfoTheory.Shannon.pmfChannelKernel.instIsMarkovKernel` and
`LeanInfoTheory.Examples.StochasticChannels.toReal_klDiv_cascade_contracts_from_intermediate`.
Only doc comments changed; no declaration, theorem statement, proof, public
name, alias, attribute, import, or module boundary changed. Regenerating the
API index now reports 686 public declarations, all 686 documented, and the
website checker passes for 12 HTML files and both generated JSON files.

The focused builds for
`LeanInfoTheory.Shannon.SemanticBridge.DataProcessing` (2747 jobs) and
`LeanInfoTheory.Examples.StochasticChannels` (2749 jobs) pass. The complete
ten-target milestone suite, final generator-idempotence and hygiene checks, and
the cleanup checkpoint commit and push remained assigned to Step 4 at the end
of this documentation step.

The handoff review reconfirmed the standing Future Work boundaries. Note 14
receives no new naming candidate or compatibility decision; Note 17 governs the
remaining full verification; Note 29 remains active as the next mathematical
phase; and Note 39 remains deferred to a later canonical/minimal-sufficiency
milestone. No numbered Future Work item is opened or closed by this cleanup.

Step 4 completed the assignment on July 23. Both source-derived generators are
byte-for-byte idempotent, and the website checker passes for 12 HTML files and
both generated JSON files. All ten Lake targets required by `AGENTS.md` pass:
the lightweight root, entropy bounds, units, the semantic bridge aggregate,
mathlib fragments, all four certificate references, and the examples
aggregate. The final forbidden-placeholder, root-import, untracked-file,
scratch/artifact, stale-process, generated-reference, and diff-hygiene audits
also pass. This completes the cleanup and forms the coherent
`Prepare Chunk 5 handoff` checkpoint.

## Completed Project B Chunk 4 Plan

This completed theorem phase is a revised 20-step plan for finite sufficient
statistics, exact recovery, and equality in data processing. It follows
Cover-Thomas Section 2.10 and the finite statistical-experiment formulation in
Polyanskiy-Wu while reusing the project's raw PMF channels, Markov predicates,
total posteriors, and KL decomposition. Current status: all 20 steps are
complete. The lightweight sufficiency core now owns the
fixed-prior predicate, induced triple law, reverse-Markov/zero-CMI/MI/
conditional-entropy equivalence band, exact fixed-prior recovery, and the
family channel predicate with its deterministic specialization, every-prior
consequence band, and full-support/all-prior converses. The downstream data-
processing owner now supplies the supported common-posterior characterization
and both the lower-level almost-everywhere and primary support-pointwise KL
posterior-equality characterizations. The new downstream `Sufficiency.KL`
module now contains the two-law forward exact-recovery theorem, its guarded
`ENNReal`/real converses, deterministic-map forms, and the family-level
pairwise preservation and guarded Boolean converse bands.

1. Completed on July 16, 2026: locked the exact contracts with clean temporary
   proofs of deterministic forward Markov structure, fixed-prior recovery, the
   finite full-support-prior converse, KL equality and posterior-kernel
   equality, finite Fisher-Neyman normalization, and the marginal-recovery
   counterexample. Deleted the scratch source and generated artifacts after
   recording assumptions, ownership, and deferred branches.
2. Completed on July 17, 2026: proved the deterministic-statistic Markov
   foundation `isMarkovChainOf_comp`, showing for arbitrary source variables
   that `Theta -> X -> T(X)` holds without finiteness, measurability,
   injectivity, or support assumptions. No PMF-facing wrapper was needed.
3. Completed on July 17, 2026: added Future Work Note 33's random-variable
   conditional-entropy DPI equality characterization as
   `condEntropyOf_dataProcessing_eq_iff`, derived from the canonical mutual-
   information theorem. A statistic-oriented consumer validated the intended
   orientation; no PMF wrapper or simp rule was added.
4. Completed on July 17, 2026: introduced the lightweight, separately
   importable `Shannon.SemanticBridge.Sufficiency` core with only
   `statisticTripleLawOf` and `IsSufficientStatisticOf`. It imports Markov but
   not DataProcessing or the planned Sufficiency.KL layer; positive opt-in and
   negative root-only consumers both passed.
5. Completed on July 17, 2026: proved the fixed-prior textbook equivalence band
   through reverse Markov structure, zero conditional mutual information,
   preservation of mutual information, and preservation of the corresponding
   conditional entropy. Every result is oriented around `T(X)` and reuses the
   deterministic forward chain from Step 2.
6. Completed on July 17, 2026: proved the fixed-prior exact recovery and
   factorization characterization with one parameter-independent channel from
   statistic values back to observations. Its contract reconstructs the
   complete parameter-statistic-observation law; marginal recovery is exposed
   only as a one-way consequence.
7. Completed on July 17, 2026: defined family-level sufficiency for a raw model
   and channel by one common recovery channel that reconstructs every swapped
   input-output joint law exactly. Defined deterministic sufficient statistics
   as the specialization to `PMF.deterministicChannel T`, with no bundled
   statistical-experiment structure.
8. Completed on July 17, 2026: characterized family sufficiency through one
   common posterior on every supported output fiber, left null-output fallback
   values unconstrained, and added only the identity-statistic sanity law.
9. Completed on July 17, 2026: proved that one common family recovery channel
   yields reverse Markov, zero conditional mutual information, mutual-
   information preservation, and conditional-entropy preservation for every
   prior on the parameter. The prior/model/channel law and its coordinate-swap
   identification remain private to the lightweight sufficiency core. The
   first independent PMF entropy consumer also completed Note 33's direct
   `condEntropy_dataProcessing_eq_iff` branch.
10. Completed on July 17, 2026: proved the finite converse from one supplied
    full-support prior to a common recovery channel with only `[Finite alpha]`,
    then derived the all-priors channel and deterministic-statistic
    equivalences for finite nonempty parameter types. Promoted the pressured
    deterministic channel-extension graph law in the finite-channel core.
11. Completed on July 17, 2026: ran the midpoint contract and consumer review
    with a genuinely noninjective sufficient statistic, a non-sufficient
    constant statistic, and the marginal-recovery false positive. The probes
    validated the supported-output posterior guard, assumptions, naming,
    core/KL import separation, and negative root isolation, then were deleted.
12. Completed on July 17, 2026: proved the finite Fisher-Neyman factorization
    iff for deterministic statistics with finite `ENNReal` factors and only
    `[Finite alpha] [Nonempty alpha]`. Positive-fiber normalization and the
    zero-fiber fallback remain private; no general PMF-normalization API was
    exposed.
13. Completed on July 17, 2026: in `SemanticBridge.DataProcessing`, derived the
    guarded KL equality engine
    `klDiv_channel_eq_iff_posterior_ae_eq` from the exact posterior
    decomposition. A private explicit-finiteness cancellation helper, mathlib's
    zero-KL characterization, and `Kernel.compProd_eq_iff` identify equality in
    channel DPI with almost-everywhere posterior-kernel agreement under input
    support inclusion.
14. Completed on July 17, 2026: converted the measure-level equality engine
    into the primary finite supported-output theorem
    `klDiv_channel_eq_iff_posterior_eq_on_support` and its guarded real-valued
    companion. The Step 13 kernel almost-everywhere theorem remains the lower-
    level bridge.
15. Completed on July 17, 2026: added the separately importable
    `Shannon.SemanticBridge.Sufficiency.KL` module downstream of both the
    lightweight sufficiency core and `DataProcessing`, and proved that one
    common exact recovery channel preserves pairwise `ENNReal` KL divergence
    without importing KL machinery into the core module.
16. Completed on July 21, 2026: proved the finite support-guarded `ENNReal` and
    real KL equality iff common exact recovery, specialized both to
    deterministic statistics, and promoted the pressured generic channel-joint
    support-identifiability theorem without admitting the uninformative
    `top = top` case.
17. Completed on July 22, 2026: integrated the family and KL views. A
    sufficient family channel or deterministic statistic now preserves
    `ENNReal` KL divergence for every pair of model laws. Under directed
    support inclusion, preservation for the two laws of a Boolean-indexed
    model is also equivalent to family sufficiency. No larger-family converse
    from unrelated pairwise witnesses is claimed.
18. Completed on July 22, 2026: added the separately importable
    `Examples.SufficientStatistics` module. It preserves the compact
    noninjective sufficient, non-sufficient constant, and marginal-only
    counterexamples and exercises fixed-prior, family, recovery, all-prior,
    Fisher-Neyman, and KL-equality surfaces through public declarations. The
    lightweight root remains unchanged.
19. Completed on July 22, 2026: performed the scheduled API, naming, simp,
    ownership, documentation, and Future Work review. Retained every current
    name and module boundary, added no alias or simp rule, completed Note 29's
    source-comment checklist, and rechecked positive downstream imports and
    negative root reachability.
20. Completed on July 22, 2026: integrated the milestone, regenerated and
    checked both source-derived reference sets, ran the complete ten-target
    Lake suite, passed guarded consumer, root-isolation, axiom, website, and
    repository-hygiene checks, and prepared the coherent Chunk 4 checkpoint.

The completed chunk deliberately excludes Fano, canonical/minimal sufficient
statistics, a general measurable statistical-experiment layer, and a general
`n`-sample iid/count-statistic development. Fano remains sequenced by Future
Work Note 29. The other sufficiency extensions are now recorded in Future Work
Note 39 so they can be planned after the finite recovery API has proved stable.

## Near-Term Semantic Theorem API Plan

The next focused Lean theorem phase is a nine-step plan. Its purpose is to
turn the completed semantic bridge infrastructure into a broader textbook-style
finite information-measure API, while keeping root imports lightweight and
letting theorem pressure guide naming.

Current status: all nine steps are complete.

1. Completed on July 8, 2026: prove mutual-information symmetry in the
   lightweight finite layer.
2. Completed on July 8, 2026: prove conditional mutual-information symmetry in
   the first two variables.
3. Completed on July 8, 2026: prove conditional entropy nonnegativity from the
   expected conditional-law formula.
4. Completed on July 8, 2026: add conditional entropy chain-rule variants.
5. Completed on July 8, 2026: add mutual-information chain-rule variants
   beyond `mutualInfo_chain_rule_fst`.
6. Completed on July 8, 2026: prove conditioning-reduces-entropy from
   conditional mutual information nonnegativity.
7. Completed on July 8, 2026: add small checked-certificate examples beyond
   submodularity, without adding new assumptions yet.
8. Completed on July 8, 2026: review certificate ergonomics after those
   examples and add the generic raw-validator soundness helper
   `Certificate.RawCert.sound_of_toCheckedCert?_isSome`.
9. Completed on July 8, 2026: refresh project logs, current-state notes,
   future-work notes, generated website reference artifacts, and hand-written
   theorem-highlight source links.

## Near-Term Semantic Bridge Plan

The next focused project phase is a nine-step plan. Its purpose is to move
from the completed entropy/self-information bridge to the main textbook
semantic equivalence theorems, without choosing an awkward conditional-law or
KL API too early.

After each step, update this log and remove or rewrite any future-work note
that the step completes.

Current status: all nine steps are complete.

1. Completed on July 6, 2026: audit the relevant mathlib, PFR, and
   divergence-project APIs for product PMFs, product measures, `PMF.toMeasure`,
   finite sums as integrals, `InformationTheory.klDiv`, conditional measures,
   kernels, and zero-mass conventions. The detailed result is recorded in
   `docs/semantic-bridge-api-audit.md`.

2. Completed on July 6, 2026: write a semantic-bridge design note before
   proving the larger bridge theorems. The design specifies the product-law
   representation, the planned KL theorem statements, the conditional-law
   representation, and the convention for conditioning on zero-probability
   events. The detailed result is recorded in
   `docs/semantic-bridge-design.md`.

3. Completed on July 6, 2026: add a small semantic-bridge infrastructure
   layer. The new `LeanInfoTheory/Shannon/SemanticBridge/Product.lean` file
   provides the independent product PMF, support and marginal formulas,
   `PMF.toMeasure` product-measure bridge lemmas, and the joint-law
   absolute-continuity helper needed by the KL bridge. A general finite KL
   expansion helper remains deferred until step 4 shows its exact required
   shape.

4. Completed on July 6, 2026: prove that finite `mutualInfo` agrees with
   mathlib KL divergence from the joint law to the product of its marginals.
   The proof lives in semantic-bridge subfiles:
   `SemanticBridge/FiniteSums.lean` proves the finite log-ratio formula
   `I(A;B) = sum p(a,b) log (p(a,b)/(p_A(a)p_B(b)))`, and
   `SemanticBridge/KL.lean` proves both the `indepProd` and `Measure.prod`
   KL-divergence statements.

5. Completed on July 6, 2026: refine and implement the finite conditional-law
   API carefully, using the nonzero-mass conditional-law convention from
   `docs/semantic-bridge-design.md`. The new
   `SemanticBridge/Conditional.lean` file defines
   `condFstGivenSnd p b hb`, proves the atom formula
   `p(a,b)/p_B(b)`, support equivalences, proof irrelevance, and the
   factorization `p_B(b) * P_{A | B=b}(a) = p(a,b)`.

6. Completed on July 6, 2026: prove that finite `condEntropy` agrees with
   expected entropy of the chosen finite conditional laws. The main theorem is
   `condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd`, stating
   `H(A | B) = sum_b P_B(b) H(P_{A | B=b})`, with zero-marginal fibers handled
   by the numeric zero branch in `condEntropyFstGivenSnd`.

7. Completed on July 6, 2026: prove that finite `condMutualInfo` agrees with
   an averaged conditional-KL expression, using the previous conditional-law
   and KL bridge work. The main formulas are
   `I(A;B | C) = sum_c P_C(c) I(A;B | C=c)` and
   `I(A;B | C) =
    sum_c P_C(c) D(P_{A,B|C=c} || P_{A|C=c} × P_{B|C=c})`.

8. Completed on July 6, 2026: add the first semantic theorem API built on the
   bridge results. The new `SemanticBridge/Theorems.lean` file proves
   `0 <= I(A;B)`, fiberwise `0 <= I(A;B | C=c)`, `0 <= I(A;B | C)`, and the
   chain rule `I(A;B,C) = I(A;C) + I(A;B | C)`.

9. Completed on July 6, 2026: revisit local API polish after theorem pressure.
   Safe coordinate/projection orientation lemmas were promoted to `[simp]`.
   `LeanInfoTheory/Shannon/InfoMeasures.lean` was not split yet, because the
   semantic bridge itself is already split and the finite PMF API remains
   coherent. Public aliases for semantic theorem names were also deferred
   until more chain-rule and semantic-bridge examples exist.

## External Review Notes

The detailed external review summary has been moved to
`docs/external-review-notes-15-june-2026.md`. The main actionable outcome is
that some mathematical work will happen naturally through theorem pressure, but
the certificate-checker architecture and public-project hygiene need explicit
tracking so they are not postponed indefinitely. The live follow-up items are
recorded in the future-work list below.

## Mathlib `InformationTheory` Namespace Notes

This project should eventually contribute stable, general pieces upstream to
mathlib. We should be conservative: prove the ideas locally first, discover the
right API shape, then propose small PRs whose names and assumptions fit
mathlib.

### Potential Upstream Items

1. Finite Shannon entropy for `PMF`, probably in or near
  `Mathlib.InformationTheory`, if mathlib maintainers want a finite-discrete
  entropy API.
2. Real-valued finite-sum formulas for entropy over `PMF`, using
  `Real.negMulLog`.
3. Bridge lemmas between finite `PMF` entropy sums and measure-theoretic
  expectations over `PMF.toMeasure`.
4. Entropy invariance under equivalences and injective relabelings.
5. Product, swap, and reassociation lemmas for entropy of joint finite laws.
6. Finite marginal support/domination lemmas for joint PMFs, phrased in a way
  that works well with `PMF.map`, `PMF.toMeasure`, and mathlib's measure APIs.
7. A finite conditional-distribution API or a bridge to existing conditional
  measure notation, if this can be done without duplicating mathlib
  probability theory.
8. Mutual information for finite PMFs, with a theorem identifying it with
  `InformationTheory.klDiv` from the joint law to the product of marginals.
9. Conditional mutual information for finite PMFs, with bridge theorems to KL
  chain rules or averaged conditional KL.
10. A finite-family entropy API, but only after the pair/triple API and semantic
  bridge have clarified the best indexing representation.
11. Generic finite-measure lemmas needed by the above, if they are useful beyond
  this project.

### Staged Upstream Plan

Stage 0, local exploration:

- Keep new definitions local while the API is still changing.
- Record mathlib anchors in `LeanInfoTheory.MathlibFragments`.
- Avoid upstreaming definitions whose assumptions or names are not yet stable.

Stage 1, after pair/triple foundations are solid:

- Upstream tiny generic lemmas that are clearly mathlib-shaped, such as PMF
  real-mass finite-sum facts or reusable `PMF.map`/`PMF.toMeasure` bridge
  lemmas.
- Keep information-theory names local unless we have enough theorems to justify
  their exact shape.

Stage 2, after semantic bridge theorems:

- Propose finite entropy and mutual-information APIs if they are stable,
  theorem-rich, and compatible with `InformationTheory.klDiv`.
- Prefer small PRs: entropy first, then conditional entropy or mutual
  information, then conditional mutual information.

Stage 3, after certificate and finite-family pressure:

- Decide whether finite-family entropy belongs upstream.
- If yes, upstream only the representation-independent core, not
  project-specific certificate syntax.
- Keep PSITIP/oXitip-style certificate infrastructure in this repository unless
  mathlib maintainers specifically want a generic certificate framework.

## Future Work Notes

These notes record future work, ongoing guardrails, and proof-pressure
triggers. Completed foundation reminders are generally recorded in the
step-by-step history above instead; an entry explicitly marked closed remains
here only when preserving its number and context helps later cross-references.
The near-term semantic bridge plan above is complete.

The near-term theorem/certificate plan above is complete, and Project B is now
active. Its 14-step pair/triple Shannon Chunk 1 is complete and checkpointed as
commit `7ab3aa0`. The revised 18-step Chunk 2 is also complete: Step 18 closed
the chunk with final integration, the full milestone suite, generated-reference
and website checks, repository hygiene, and the coherent checkpoint review.
Chunk 2 owns finite KL support/equality, uniformity, independence, and
conditional independence. The revised 20-step Chunk 3 is complete: all 20 steps
locked the contract, introduced the opt-in raw PMF channel core
and its laws, completed the total conditional-channel reconstruction layer,
added the Markov predicates, symmetry, and characterization API, proved that
channel extensions generate Markov triples, established exact Markov mutual-
information loss, and derived MI data processing with its conditional-entropy
and reverse-Markov equality consequences, together with one-sided,
independently two-sided, cascade, and deterministic channel-facing forms. The
canonical and existential Markov channel-factorization converses are now also
complete. The second no-placeholder checkpoint selected the finite kernel-
chain-rule route and locked its KL support assumptions. The new opt-in data-
processing module now implements the PMF-to-kernel and joint-measure bridge,
the total finite posterior, PMF reconstruction, and the exact KL posterior
decomposition. The unconditional `ENNReal`, support-guarded real,
deterministic-map, and channel-cascade KL data-processing family is now public.
Its invariant-reference contraction and uniform-preserving and doubly
stochastic entropy consequences are complete. The common-cause and stochastic
examples and the scheduled API, simp, and module review are also complete. The
final milestone build, reference, website, root-isolation, consumer, and hygiene
suites pass. Note 29 anchors the Project B sequence from sufficient statistics
to Fano. The revised 20-step Chunk 4 finite sufficient-statistics,
exact-recovery, and KL-equality phase is now complete. The guarded
measure-level bridge and primary finite pointwise posterior equality family are
public in `DataProcessing`, while the downstream `Sufficiency.KL` module now
contains the pairwise forward theorem, guarded recovery converses, and
deterministic-map forms, together with family-level pairwise preservation and
the guarded Boolean-family converse. The new opt-in
`Examples.SufficientStatistics` module exercises the completed surface while
preserving root isolation. The complete build, generated-reference, website,
consumer, root-isolation, axiom, and hygiene suites pass, and the milestone is
ready for its coherent checkpoint. Fano remains the next separately planned
mathematical phase under Note 29. Finite-family entropy, richer certificate
assumptions, external certificate import, coding-theory layers, theorem-level
blueprint work, and substantial mathlib PR preparation remain later work.

### Status Index

| Status | Notes | Meaning |
| --- | --- | --- |
| Standing guardrails | 2-4, 6-8, 14-18, 26 | Apply these policies continuously; they do not create standalone cleanup tasks. |
| Project B sequence | 29 | Chunk 4 sufficient statistics and recovery are complete; Fano is the next separately planned mathematical phase. |
| Channel/Markov proof-pressure | 21, 25, 27 | Revisit these only when concrete channel, Markov, or data-processing consumers reach their stated triggers. |
| Proof-pressure deferred | 19, 22-24, 30-37, 40 | Wait for the repeated proof or new statement pressure specified in each note. |
| Later milestones | 1, 5, 9-13, 28, 38-39 | Schedule these in their own later mathematical, documentation, example, certificate, or coding phases. |
| Closed/historical | 20 | Retained for numbered references and rationale; it is not an active backlog item. |

This index is a navigation aid. It does not renumber the detailed notes, change
their theorem-pressure conditions, or serve as the naming decision table
requested by Note 14 for the next scheduled API review.
The 40 numbered entries therefore comprise 39 active or standing notes and one
closed historical note. Here, active includes guardrails, proof-pressure
triggers, the Project B sequence anchor, and later milestones; it does not mean
immediate implementation. Earlier step-specific imperatives retained inside a note are
historical trigger records when a later paragraph records their resolution.

1. Keep the finite-family entropy API delayed through Project B Chunk 1 and the
    intervening KL/channel theorem pressure. Revisit it in the planned
    finite-family chunk after the pair/triple API is stronger. The main open
    question is whether the API should be
    indexed by `Fin n`, finite sets of variable names, dependent finite
    alphabets, vectors, or another mathlib-friendly structure.

2. Split `LeanInfoTheory/Shannon/InfoMeasures.lean` only when the file becomes
    too large or theorem pressure makes the boundaries clear. The July 6 API
    polish pass decided not to split it yet: the file is around the watchlist
    size, but it still contains one coherent finite PMF information-measure
    layer, and the heavier semantic bridge has already been split into
    subfiles. Revisit the split when finite-family entropy, additional
    conditional mutual-information variants, or repeated long review/build
    cycles make the boundaries obvious. A likely future layout is `Marginals`,
    `ConditionalEntropy`, `MutualInfo`, `ConditionalMutualInfo`, and one or
    more heavier semantic bridge files.

    Chunk 2 Step 17 rechecked module pressure after the KL, independence, and
    example layers were complete. `InfoMeasures` and
    `SemanticBridge.Theorems` are large, but each still has one coherent role;
    KL and independence already live in focused opt-in modules. No split was
    made. Prefer new modules for the later channel, Markov, and data-processing
    layers, and revisit an internal split only when those developments create
    a real dependency boundary or repeated maintenance cost.

3. Keep imports light in the core finite Shannon files. Heavy bridge files can
    import KL divergence, kernels, conditional probability, and coding theory
    only when those APIs are actually needed.

    The Step 17 import review confirmed that the four new aliases add no import
    edge, the aggregate semantic bridge remains opt-in, and the lightweight
    root remains unchanged.

4. Treat `LeanInfoTheory/MathlibFragments.lean` as a separately importable
    anchor and checklist for upstream APIs, not as part of the lightweight
    public import surface.

5. Add coding-theory material, including Kraft-McMillan connections, in a
    later coding-oriented layer rather than in the finite Shannon foundation.

6. Upstream conservatively to mathlib. Small generic lemmas can go earlier,
    but substantial `InformationTheory` definitions should wait until local
    names, assumptions, and theorem statements have stabilized.

7. Keep PSITIP/oXitip-style certificate infrastructure local unless mathlib
    maintainers specifically want a generic certificate framework.

8. Re-run the semantic bridge API audit whenever the project upgrades mathlib.
    In particular, re-check whether mathlib has added a canonical finite
    product construction for `PMF`, new finite KL expansion lemmas, or a public
    averaged conditional-KL API. If any of those exist upstream, prefer reusing
    them over maintaining parallel local helpers.

### Do Later

9. Add theorem-level blueprint and full Lean doc-gen output once the Lean API is
    stable enough. The current generated artifacts are a module dependency map
    built from local import lines and a source-derived declaration index. Until
    richer generation exists, keep `/docs/` as a documentation landing page, keep
    `home_page/module-guide.html` as the hand-written import guide, and keep
    `home_page/docs/api-index.html` described as lighter than full Lean
    doc-gen. When full doc generation is added, link the homepage, theorem
    highlights, docs landing page, module guide, generated module dependency
    map, and declaration index directly to rendered declaration pages. A
    blueprint PDF should be added after the theorem-level blueprint source is
    real enough to be worth rendering.

10. Add a minimal contributor surface before inviting broader collaboration:
    `CONTRIBUTING.md`, beginner-friendly tasks, issue labels, and a short note
    about which components may eventually be proposed upstream to mathlib.

11. Add advanced certificate constraints after the primitive-only checker
    remains stable under a little more theorem pressure. Independence
    constraints, functional-dependence constraints, and Markov constraints are
    essential for network converses, but they should be introduced as explicit
    extensions of the primitive certificate layer. Project B Chunk 1 Step 5
    proves the semantic finite-PMF theorem `H(X|Y) = 0` iff support-wise
    functional dependence; that theorem is future mathematical input to this
    constraint layer, not a reason to add the certificate extension yet.
    Before adding a named semantic predicate, decide whether its primary form
    should concern a joint PMF, finite-valued random variables over a source
    PMF, or an almost-everywhere relation that can later bridge cleanly to
    channels and measure-theoretic APIs. A likely random-variable contract is
    a predicate packaging
    `exists f, forall omega in p.support, X omega = f (Y omega)`; it must not
    strengthen this to pointwise equality outside the source support or
    silently identify the semantic predicate with the future certificate
    constraint representation. Once concrete downstream users justify the
    abstraction, connect it directly to
    `condEntropyOf_eq_zero_iff_exists_function` rather than reproving the
    zero-conditional-entropy theorem.

    At the same time, consider adding the support-restricted decoder uniqueness
    companion theorem. If `f` and `g` both recover `X` from `Y` on `p.support`,
    then prove `f b = g b` only for
    `b in (p.map Y).support` (equivalently, on the support of the `Y` law).
    No uniqueness should be claimed outside that marginal support, where the
    decoder values are observationally irrelevant. Provide the corresponding
    joint-PMF formulation using `sndMarginal p` only if both forms have actual
    consumers. This uniqueness result is useful API support, not a prerequisite
    for the current direct existential theorem.

12. Add primitive-recognition/autotagging only after the manually tagged
    certificate pipeline has been exercised on larger examples. The step 8
    ergonomics review added a generic raw-validator soundness helper, and the
    three-way subadditivity pressure test showed expression normalization
    pressure before primitive-tag pressure. Neither result justifies primitive
    recognition yet. The current validator checks a raw expression against a
    supplied `PrimitiveIneq.Kind`;
    a later ergonomic layer could try to infer primitive tags from normalized
    entropy expressions, for example recognizing
    `H(A,C) + H(B,C) - H(A,B,C) - H(C)` as conditional mutual information.
    This recognition layer should remain outside the trusted core: it may
    propose tags, but the existing exact equality checker must still verify
    them.

13. Add PSITIP/oXitip-style certificate import only after the internal checked
    certificate format is stable. The first parser should target a small,
    explicit external format and should never be part of the trusted kernel.

14. Maintain a public theorem naming and alias watchlist, and revisit it after
    real theorem pressure. Long descriptive names are acceptable while the API
    is developing, but some expose implementation details such as named
    marginals, coordinate swaps, `pairThirdLaw`, or fiber helper names that a
    textbook-facing user should not always need to know. Do not rename these
    declarations during ordinary theorem steps. Prefer concise compatibility-
    preserving aliases while retaining descriptive names as stable
    implementation-facing entry points unless an explicit migration is
    justified.

    Apply the following criteria during each review:

    - Prefer names that communicate the mathematical identity before its PMF
      representation details.
    - Preserve the established PMF versus random-variable `...Of` distinction.
    - Keep orientation visible when two symmetric forms would otherwise have
      the same natural name, but avoid mentioning `Prod.swap` or a particular
      marginal construction when a shorter mathematical suffix is enough.
    - Treat newly suggested aliases as sketches until a recorded review checks
      namespace collisions, theorem search, downstream proof readability, and
      consistency with mathlib.
    - Do not add both directions of every algebraic identity automatically.
      Add reverse-oriented aliases only when real proofs repeatedly need them.

    The planned Step 13 review was completed on July 14, 2026. It checked
    namespace collisions, theorem search, PMF/RV consistency, and downstream
    statement readability, then approved four coherent alias groups:

    - pair chain rules use `entropy_chain_rule_left`/`..._right` and
      `jointEntropyOf_chain_rule_left`/`..._right`;
    - pair inequalities use left/right textbook names and the shorter
      `jointEntropy_le_add_marginalEntropy`/
      `jointEntropyOf_le_add_entropyOf` subadditivity pair;
    - deterministic processing uses `mutualInfoOf_comp_both_le` and
      `mutualInfo_map_left_le`/`..._right_le`/`..._both_le`;
    - the conditional inequality band uses left/right/pair names without
      exposing `fstThirdMarginal`, `sndThirdMarginal`, `pairThirdLaw`, or
      `_swap` in the aliases.

    All original declarations remain public. The review did not approve
    speculative MI/CMI entropy-difference aliases, coined `jointCondEntropy`
    terminology, shorter fiber aliases, reverse elementary-MI identities, the
    right-oriented exact deterministic identity, or a public injective-
    relabeling family. These remain deferred for the reasons recorded below.
    The lists that follow preserve the historical pressure and rejected
    sketches so later reviews can distinguish unresolved work from decisions
    already made.

    Chunk 3 Step 19 completed the scheduled review. The compact decision table
    below is the navigation summary; the historical entries later in this note
    retain the full proof-pressure record.

    | Watched family | Status | Decision and rationale |
    | --- | --- | --- |
    | finite-channel projection laws | declined | Keep the precise `_map_` names; the proposed input/output vocabulary is ambiguous and neither example needs aliases. |
    | total conditional-channel branch and weighted laws | declined | Keep names that expose the exact marginal hypothesis; shorter null/positive names hid contract details. |
    | `isCondIndependent_map_swap12` | declined | The current name matches the CMI normalization family and states the actual coordinate map; no new consumer needed another spelling. |
    | positive-fiber Markov characterization | approved | Added `isMarkovChain_iff_fiberwise_endpoints_independent`; the common-cause example is clearer while the original helper-facing name remains public. |
    | `isMarkovChain_map_reverse` | declined | The explicit `map` distinguishes the PMF coordinate theorem from `isMarkovChainOf_reverse`; no example showed discovery pressure. |
    | mutual-information channel cascade | approved | Added `mutualInfo_channel_cascade_le`; it aligns theorem search with textbook cascade vocabulary while preserving `mutualInfo_channelComp_le`. |
    | deterministic channel postprocessing | declined | The provisional alias was longer and no clearer than `mutualInfo_channel_map_output_le`; no example used it. |
    | canonical Markov channel factorization | approved | Added `isMarkovChain_iff_canonical_channelExtension`; rejected the broader `...channel_factorization` spelling because it is ambiguous beside the existential theorem. |
    | KL channel cascade | approved | Added `klDiv_channel_cascade_le` and `toReal_klDiv_channel_cascade_le` as a coherent pair; both original `channelComp` names remain public. |
    | uniform-invariant and doubly-stochastic entropy growth | declined | Keep the descriptive `_le_...bind...` names; `mono` suggests monotonicity in an ordered input argument and `nondecreasing` hides the bind operation. |

    Chunk 4 Step 19 completed the next scheduled review. All current
    declarations remain public and unchanged; the compact table below records
    the compatibility-alias decisions supported by the permanent examples.

    | Watched family | Status | Decision and rationale |
    | --- | --- | --- |
    | fixed-prior sufficiency equivalences | declined | Keep the coherent predicate-first names; `markov`, `zero_cmi`, and `preserved` sketches are less precise than the actual theorem targets. |
    | fixed-prior full and marginal recovery | declined | The existing names preserve the existential full-law characterization and one-way marginal consequence; shorter sketches blur the false marginal converse. |
    | common supported posterior | declined | Keep `isSufficientChannel_iff_exists_common_posterior`; dropping `exists` or adding `on_support` does not improve discovery enough to hide the witness shape. |
    | every-prior sufficiency consequences | declined | The current `_of_isSufficientChannel` family is Lean-idiomatic and states the exact premise; `imp` and `preserved` sketches are broader and less conventional. |
    | full-support and all-prior characterizations | declined | The long names make the exact support hypothesis and family/fixed-prior distinction visible; every shorter sketch loses one of those contracts. |
    | finite Fisher-Neyman factorization | declined | The textbook term and existential witness are both discoverable in the current name; generic `factorization` is ambiguous beside Markov and recovery factorizations. |
    | pointwise posterior KL equality | declined | Retain `_on_support`; the support restriction is mathematically essential and shorter forms would suggest total posterior equality on null fibers. |
    | common-recovery KL equality | declined | The channel/map and `ENNReal`/real matrix is systematic, and `exists` accurately advertises the witness returned by each iff theorem. |
    | channel-joint support identifiability | declined | `PMF.channelJoint_eq_iff_eq_on_support` is slightly repetitive but precise; the proposed alternative is longer and no downstream call site benefits. |
    | Boolean KL characterizations | declined | The trailing `_bool` remains readable in the two-law API, and the orientation probe showed that `Bool.not` reindexing handles the opposite support direction without another spelling. |

    The same pass audited the public declarations inside the two example
    namespaces. Names such as
    `toReal_klDiv_cascade_contracts_from_intermediate` are intentionally
    scenario-facing and expose the support distinction being demonstrated,
    while the shorter law and model names are locally scoped by their example
    namespaces. None exposes a private marginal, coordinate-swap, posterior,
    or fiber implementation detail that warrants another compatibility alias,
    so no example declaration remains on the watchlist.

    Initial high-priority theorem-facing review input:

    - `mutualInfo_eq_entropy_fstMarginal_sub_condEntropy`;
    - `mutualInfo_eq_entropy_sndMarginal_sub_condEntropy_swap`;
    - `mutualInfoOf_eq_entropyOf_sub_condEntropyOf`;
    - `mutualInfoOf_eq_entropyOf_sub_condEntropyOf_swap`;
    - `entropy_eq_entropy_sndMarginal_add_condEntropy`;
    - `entropy_eq_entropy_fstMarginal_add_condEntropy_swap`;
    - `jointEntropyOf_eq_entropyOf_add_condEntropyOf_swap`;
    - `entropy_le_entropy_fstMarginal_add_entropy_sndMarginal`;
    - `condEntropyFstGivenSnd_eq_zero_iff_of_sndMarginal_ne_zero`;
    - `entropy_eq_entropy_sndMarginal_iff_exists_function`;
    - `condMutualInfo_eq_condEntropy_fstThirdMarginal_sub_condEntropy`.

    Step 9 pair-inequality names reviewed together:

    - `condEntropy_le_entropy_fstMarginal`;
    - `mutualInfo_le_entropy_fstMarginal`;
    - `mutualInfo_le_entropy_sndMarginal`;
    - `entropy_fstMarginal_le_entropy`;
    - `entropy_sndMarginal_le_entropy`;
    - `entropyOf_le_jointEntropyOf`;
    - `entropyOf_le_jointEntropyOf_swap`;
    - `jointEntropyOf_le_entropyOf_add_entropyOf`.

    The PMF names expose the chosen `fstMarginal`/`sndMarginal`
    representation instead of leading with the textbook left/right entropy
    bound. The random-variable pair uses an asymmetric unsuffixed/`_swap`
    naming scheme even though the distinction is mathematically left versus
    right, and the subadditivity name is difficult to scan because it spells
    out every operand. The review considered these together with the already listed
    `entropy_le_entropy_fstMarginal_add_entropy_sndMarginal`. Provisional alias
    sketches include `condEntropy_le_entropy_left`,
    `mutualInfo_le_entropy_left`/`mutualInfo_le_entropy_right`,
    `entropy_left_le_jointEntropy`/`entropy_right_le_jointEntropy`,
    `entropyOf_left_le_jointEntropyOf`/`entropyOf_right_le_jointEntropyOf`, and
    a shorter joint-subadditivity family such as
    `jointEntropy_le_add_marginalEntropy` and
    `jointEntropyOf_le_add_entropyOf`. Step 13 approved all of these aliases
    after the collision, consistency, and discoverability checks; the original
    declarations remain available.

    Step 10 deterministic-processing names reviewed together:

    - `mutualInfoOf_deterministic_chain_rule_left`;
    - `mutualInfoOf_comp_left_le`;
    - `mutualInfoOf_comp_right_le`;
    - `mutualInfoOf_comp_le`;
    - `mutualInfo_map_fst_le`;
    - `mutualInfo_map_snd_le`;
    - `mutualInfo_map_prod_le`.

    The chain-rule name is long but mathematically descriptive. The RV
    inequality family is compact, although the unsuffixed `comp_le` denotes
    processing both variables and should be checked for discoverability beside
    the explicitly suffixed one-sided forms. The PMF names expose the selected
    `fst`/`snd`/`prod` coordinate representation. Provisional alias sketches are
    `mutualInfo_map_left_le`, `mutualInfo_map_right_le`, and
    `mutualInfo_map_both_le`; for the RV family, consider whether
    `mutualInfoOf_comp_both_le` is clearer than the current unsuffixed name.
    Step 13 approved those four aliases and retained the original family. It
    did not add the symmetric right-oriented chain identity because Steps 11
    and 12 supplied no real rewrite pressure. `condMutualInfoOf_nonneg` is
    short, conventional, and does not need watchlist treatment.

    Step 11 conditional-mutual-information names reviewed together:

    - `condMutualInfoOf_eq_condEntropyOf_sub_condEntropyOf`;
    - `condMutualInfoOf_eq_condEntropyOf_sub_condEntropyOf_swap`;
    - `condMutualInfoOf_eq_condEntropyOf_add_condEntropyOf_sub_condEntropyOf_pair`;
    - `condMutualInfo_eq_condEntropy_sndThirdMarginal_sub_condEntropy_swap12`.

    The two RV difference names are mathematically descriptive but long and use
    an asymmetric unsuffixed/`_swap` orientation. The RV conditional-
    subadditivity-gap name spells out every operand and is difficult to scan.
    The PMF name exposes both `sndThirdMarginal` and the implementation-level
    `swap12` map. Review these together with the existing
    `condMutualInfo_eq_condEntropy_fstThirdMarginal_sub_condEntropy` and
    `condMutualInfo_eq_condEntropy_marginals`. Provisional conceptual families
    include `condMutualInfoOf_eq_condEntropy_diff_left`/`..._right`, a shorter
    conditional-subadditivity-gap name, and analogous PMF left/right aliases.
    Step 13 did not approve these sketches: `diff` is less discoverable than
    the current entropy-expression names, and no stable short name emerged for
    the conditional-subadditivity gap. Keep the descriptive names until later
    proofs establish a better vocabulary.

    Step 11 did not consume the right-oriented exact deterministic identity
    `I(X;Y) = I(X;g(Y)) + I(X;Y|g(Y))`, despite strengthening the CMI API, so it
    remained deferred through Steps 12 and 13 because no proof repeated the
    symmetry argument. Step 11 also did not need reverse elementary-MI
    rewrites, adding further evidence against introducing them now.

    Step 12 triple-level inequality names reviewed together:

    - `condMutualInfo_le_condEntropy_fstThirdMarginal`;
    - `condMutualInfo_le_condEntropy_sndThirdMarginal`;
    - `condEntropy_fstThirdMarginal_le_condEntropy_pairThirdLaw`;
    - `condEntropy_sndThirdMarginal_le_condEntropy_pairThirdLaw`;
    - `condEntropy_pairThirdLaw_le_condEntropy_fstThirdMarginal_add_condEntropy_sndThirdMarginal`;
    - `condMutualInfoOf_le_condEntropyOf_left`;
    - `condMutualInfoOf_le_condEntropyOf_right`;
    - `condEntropyOf_le_condEntropyOf_pair`;
    - `condEntropyOf_le_condEntropyOf_pair_swap`;
    - `condEntropyOf_pair_le_condEntropyOf_add_condEntropyOf`.

    The PMF family exposes the triple-law representation rather than the
    textbook left/right conditional entropy band. The RV CMI-bound names are
    already reasonably clear, but the unsuffixed/`_swap` single-to-pair names
    are easy to confuse with the existing conditioning-reduces theorem
    `condEntropyOf_pair_le_condEntropyOf`. Provisional alias sketches include
    `condMutualInfo_le_condEntropy_left`/`..._right`,
    `condEntropy_left_le_jointCondEntropy`/`..._right`,
    `jointCondEntropy_le_add_condEntropy`, and corresponding `...Of` forms.
    Step 13 rejected the coined `jointCondEntropy` vocabulary and instead
    approved the coherent `condEntropy_left/right_le_condEntropy_pair` and
    `condEntropy_pair_le_add_condEntropy` families, with corresponding `...Of`
    aliases. It also approved the PMF
    `condMutualInfo_le_condEntropy_left`/`..._right` pair. The descriptive
    declarations remain available for compatibility.

    Step 12 supplied no consumer for the right-oriented exact deterministic
    identity or reverse elementary-MI identities. It also did not repeat the
    augmentation proof. The active theorem phase is now complete through Step
    12. Step 13 therefore left all of these deferred additions out rather than
    introducing them merely for symmetry.

    Chunk 2 Step 7 added the descriptive random-variable names
    `entropyOf_eq_log_card_iff_map_eq_uniformOfFintype` and
    `entropyOf_eq_log_support_ncard_iff_map_eq_uniformOnSupport`. Both expose
    the `PMF.map` representation in an already long equality-characterization
    name, even though the mathematical content is simply that the law is
    uniform on the alphabet or its support. Preserve these names during the
    active theorem phase. Step 17 declined the compatibility-preserving
    sketches `entropyOf_eq_log_card_iff_uniformLaw` and
    `entropyOf_eq_log_support_ncard_iff_uniformOnSupport`: `uniformLaw` is not
    established project vocabulary, and neither the theorem phase nor the
    examples needed a hidden mapped-law form. The PMF names
    `entropy_eq_log_card_iff_eq_uniformOfFintype` and
    `entropy_eq_log_support_ncard_iff_eq_uniformOnSupport` remain the locked,
    direct descriptions of their statements and need no alias merely for
    symmetry.

    Chunk 2 Step 8 added
    `isIndependentOf_iff_map_eq_indepProd`. The theorem is a useful unfolding
    normal form, but its name exposes the `PMF.map` representation instead of
    leading with the mathematical joint-law statement. Preserve the current
    name during the active theorem phase. Step 17 declined the
    compatibility-preserving sketch
    `isIndependentOf_iff_jointLaw_eq_indepProd`: the project has no `jointLaw`
    definition or stable naming family, and the mapped-law normal form remains
    the precise discoverable statement.
    The locked `isIndependent_iff_apply_eq_mul_marginals` name directly states
    pointwise factorization, while `isIndependent_map_swap` is a concise
    normalization theorem analogous to the existing approved swap simp rules;
    neither needs an additional alias at this point.

    Chunk 2 Step 11 added the coherent equality-case family
    `condEntropy_eq_entropy_left_iff_isIndependent`,
    `condEntropyOf_eq_entropyOf_iff_isIndependentOf`,
    `jointEntropy_eq_add_marginalEntropy_iff_isIndependent`, and
    `jointEntropyOf_eq_add_entropyOf_iff_isIndependentOf`. These names do not
    expose local proof machinery, and the conditional pair states its
    orientation explicitly, but all are long theorem-search terms. Preserve
    them through the active phase. Step 17 approved the compatibility-
    preserving aliases
    `jointEntropy_additive_iff_isIndependent` and
    `jointEntropyOf_additive_iff_isIndependentOf`, while retaining the original
    declarations. No comparably clear shorter conditional-entropy vocabulary
    is approved; do not abbreviate
    `entropy` or `independent` merely to shorten those names.

    Chunk 2 Step 12 added
    `condMutualInfo_eq_zero_iff_condMutualInfoFstSndGivenThird_eq_zero`. Its
    statement is mathematically direct, but the name is unusually long and
    exposes the specialized conditional-fiber helper rather than a concise
    textbook-facing phrase. Step 17 declined
    `condMutualInfo_eq_zero_iff_fiberwise_zero`: `fiberwise` hides which
    conditional object is zero and competes with the cleaner main zero-CMI iff
    conditional-independence theorem. Preserve the descriptive declaration.

    Chunk 2 Step 13 added
    `isCondIndependent_iff_isIndependent_condFstSndGivenThird`. The theorem
    precisely identifies the established conditional-law helper, but its name
    is long and representation-facing. Step 17 declined
    `isCondIndependent_iff_fiberwise_isIndependent` together with Step 12's
    `...fiberwise_zero` sketch. The shorter name would hide the exact positive-
    fiber conditional PMF contract and create competing near-synonyms beside
    the main zero-CMI equivalence. Preserve the descriptive declaration.

    Chunk 2 Step 15 added
    `condEntropy_eq_condEntropy_fstThirdMarginal_iff_isCondIndependent`,
    `condEntropyOf_eq_condEntropyOf_iff_isCondIndependentOf`,
    `condEntropy_pair_eq_add_condEntropy_iff_isCondIndependent`, and
    `condEntropyOf_pair_eq_add_condEntropyOf_iff_isCondIndependentOf`. All four
    names are unusually long. The first PMF name exposes the selected
    `fstThirdMarginal` representation, while the additive PMF name relies on
    the established but representation-facing `pair` vocabulary and expands
    both sides of the equality in the name. Step 17 approved the compatibility-
    preserving additive aliases
    `condEntropy_pair_additive_iff_isCondIndependent` and
    `condEntropyOf_pair_additive_iff_isCondIndependentOf` while retaining the
    original declarations. No comparably clear shorter name was approved for
    the conditioning-preservation pair: a generic `left` suffix would hide
    which conditioning variable is added.

    Longer semantic/fiber bridge names remain under future review, although
    many may remain descriptive because they expose genuinely specialized
    objects:

    - `condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd`;
    - `condMutualInfo_eq_sum_thirdMarginal_mul_condMutualInfoFstSndGivenThird`;
    - `condMutualInfo_eq_sum_thirdMarginal_mul_condMutualInfoFstSndGivenThirdKL`;
    - `condMutualInfoFstSndGivenThird_eq_entropy_fibers_of_ne_zero`;
    - `condFstGivenSnd_pairThirdLaw_eq_condFstSndGivenThird`.

    The short left/right `entropy_chain_rule` aliases were approved in Step 13.
    A possible canonical `mutualInfo_eq_entropy_sub_condEntropy` family with an
    explicit symmetric suffix, and an analogous `mutualInfoOf` family, remain
    deferred because the review found no clearly better concise spelling.

    Also keep the reverse elementary MI forms under review:

    - `H(X|Y) = H(X) - I(X;Y)`;
    - `H(Y|X) = H(Y) - I(X;Y)`;
    - the corresponding PMF statements using the two marginals.

    Step 9 derived the pair inequalities without needing public reverse-form
    aliases, so there is currently evidence against adding them immediately.
    Reconsider them only if Steps 10 through 12 or later examples repeatedly
    reproduce the same algebraic rearrangement. If they are eventually added,
    choose PMF and random-variable names as one coherent family and record why
    the forward and reverse orientations both earn public API space.

    Chunk 3 Step 10 performs this rearrangement once to derive the conditional-
    entropy form of Markov data processing. The proof is short ordered-group
    cancellation from the existing forward MI identity, and no second
    production proof repeats it. This is useful pressure to remember but does
    not yet satisfy the repeated-use trigger for a public reverse family.

    The July 6 API polish pass first deferred aliases for results such as
    `mutualInfo_chain_rule_fst`. Subsequent symmetry, conditional-chain-rule,
    deterministic-processing, MI-identity, and inequality steps supplied the
    evidence used by Step 13. Future theorem phases should continue recording
    newly pressured names here and should schedule another coherent review
    only after enough new examples accumulate.

    Chunk 3 Step 3 added the projection family
    `channelJoint_map_fst`, `channelJoint_map_snd`,
    `channelExtension_map_input`, `channelExtension_map_outputPair`,
    `channelExtension_map_output`, and `channelExtension_map_endpoints`. These
    names are concise and accurately describe the raw PMF layer, but they expose
    `map` plus coordinate-oriented projection vocabulary rather than leading
    with the mathematical input, output, stage-joint, and endpoint laws. Keep
    the current declarations unchanged during the active theorem phase and
    mark the family as `watching`. At the scheduled Step 19 review, test
    compatibility aliases along the provisional pattern
    `channelJoint_input`/`channelJoint_output` and
    `channelExtension_inputPair`/`channelExtension_stepJoint`/
    `channelExtension_output`/`channelExtension_endpoints`. These are sketches,
    not approved vocabulary; concrete Markov and data-processing consumers
    should decide whether removing `_map_` improves theorem search enough to
    justify the aliases.

    For that review, compare the candidates declaration by declaration:

    - `channelJoint_map_fst` -> `channelJoint_input`;
    - `channelJoint_map_snd` -> `channelJoint_output`;
    - `channelExtension_map_input` -> `channelExtension_inputPair`;
    - `channelExtension_map_outputPair` -> `channelExtension_stepJoint`;
    - `channelExtension_map_output` -> `channelExtension_output`;
    - `channelExtension_map_endpoints` -> `channelExtension_endpoints`.

    Any approved names should be compatibility-preserving theorem aliases, not
    replacements for the current declarations. Review the six names as one
    family, but approve only aliases that materially improve theorem search or
    consumer readability. In particular, check whether `stepJoint` is clear
    beside the Markov API or whether another mathematical term is more
    discoverable. Do not copy `[simp]` attributes onto aliases automatically:
    retain one canonical simplification rule for each projection unless a
    simplifier check demonstrates that duplicate entries are harmless and
    useful.

    Step 19 declined the six projection aliases. The permanent examples do not
    call the projection laws directly, the current names exactly match their
    `PMF.map` conclusions, and proposed terms such as `input`, `output`, and
    `stepJoint` admit competing interpretations. Keep the existing family as
    the sole vocabulary unless a later public theorem repeatedly exposes it.

    Chunk 3 Step 5 added
    `condFstGivenSndChannel_of_sndMarginal_eq_zero`,
    `condFstGivenSndChannel_of_sndMarginal_ne_zero`,
    `condFstGivenSndChannel_null_fiber_irrelevant`, and
    `sndMarginal_mul_condFstGivenSndChannel`. The two branch names follow the
    established conditional-fiber API exactly but are long and expose the
    selected `sndMarginal` representation. The null-irrelevance name is
    mathematically clear but long, while the weighted atom theorem leads with
    the representation rather than the reconstruction concept. Keep all four
    declarations unchanged and mark the family as `watching`. At Step 19,
    consider whether a coherent provisional family such as
    `condFstGivenSndChannel_of_null`/`..._of_positive`,
    `condFstGivenSndChannel_null_weighted_eq`, and
    `condFstGivenSndChannel_weighted_apply` improves theorem search without
    obscuring the exact hypotheses. The concise constructor-led
    `channelJoint_condFstGivenSndChannel` is not part of the watchlist.

    Step 19 declined these aliases. Neither permanent example needs a branch
    or weighted atom theorem, and the shorter sketches hide which marginal is
    null or positive. The descriptive declarations remain canonical.

    Chunk 3 Step 6 added `isCondIndependent_map_swap12`. The name deliberately
    matches the established `condMutualInfo_map_swap12` normalization family,
    but it exposes both `PMF.map` and numbered coordinate machinery rather than
    leading with the mathematical first-two-variable symmetry. Keep it
    unchanged and mark it as `watching`. At Step 19, test whether a
    compatibility alias along the provisional
    `isCondIndependent_swap_first_two` pattern improves discovery enough to
    justify another name; this sketch is not approved vocabulary. The concise
    random-variable theorem `isCondIndependentOf_swap` and the textbook-facing
    definitions `IsMarkovChain` and `IsMarkovChainOf` need no watch entry.

    Step 19 declined the alias. The existing name aligns with
    `condMutualInfo_map_swap12`, accurately advertises a mapped coordinate law,
    and the common-cause example needs only the variable-level predicate.

    Chunk 3 Step 7 added
    `isMarkovChain_iff_isIndependent_condFstSndGivenThird` and
    `isMarkovChain_map_reverse`. The first name is unusually long and exposes
    both the existing conditional-fiber helper and the endpoint-endpoint-middle
    coordinate representation. Keep it unchanged and mark it as `watching`;
    at Step 19, test the provisional conceptual pattern
    `isMarkovChain_iff_fiberwise_endpoints_independent` without treating that
    sketch as approved vocabulary. The PMF reversal name is concise but exposes
    an explicit `PMF.map` coordinate construction. Mark it as `watching` too
    and test whether the compatibility alias `isMarkovChain_reverse` improves
    discovery alongside `isMarkovChainOf_reverse`. The concise textbook-facing
    names `isMarkovChain_iff_crossProduct`,
    `condMutualInfoOf_eq_zero_iff_isMarkovChainOf`, and
    `isMarkovChainOf_reverse` need no watch entry.

    Step 19 approved
    `isMarkovChain_iff_fiberwise_endpoints_independent`: the common-cause
    example reads materially better with the conceptual positive-fiber name.
    It declined `isMarkovChain_reverse`, because retaining `_map_` distinguishes
    the PMF coordinate theorem from `isMarkovChainOf_reverse`. The original
    declarations remain available and only the original reversal theorem is a
    simp rule.

    Chunk 3 Step 11 added the channel-facing family
    `mutualInfo_channel_right_le`, `mutualInfo_channel_left_le`,
    `mutualInfo_independent_channels_le`, `mutualInfo_channelComp_le`, and
    `mutualInfo_channel_map_output_le`. The first three names are concise and
    lead with the mathematical orientation or independence contract. The last
    two expose the selected `channelComp` constructor and output-`map`
    representation rather than the textbook cascade and deterministic-
    postprocessing concepts. Keep every declaration unchanged and mark only
    those last two as `watching`. At Step 19, test the provisional
    compatibility aliases `mutualInfo_channel_cascade_le` and
    `mutualInfo_channel_deterministic_postprocess_le`; these are sketches, not
    approved vocabulary. Also check whether the longer deterministic sketch
    genuinely improves discovery enough to justify an alias.

    Step 19 approved `mutualInfo_channel_cascade_le`, which the stochastic
    example uses directly and which aligns with the reviewed KL cascade pair.
    It declined `mutualInfo_channel_deterministic_postprocess_le`: the sketch is
    longer than the current name and no example demonstrates discovery gain.

    Chunk 3 Step 12 added
    `isMarkovChain_iff_eq_channelExtension_condFstGivenSndChannel` and
    `isMarkovChain_iff_exists_channelExtension`. The existential name is concise,
    textbook-facing, and names the mathematical witness directly. The canonical
    name is unusually long and exposes both the selected `channelExtension`
    representation and the implementation-facing total conditional-channel
    constructor. Preserve both current declarations during the active theorem
    phase and mark only the canonical name as `watching`. At Step 19, test the
    compatibility aliases `isMarkovChain_iff_canonical_channelExtension` and
    the more textbook-facing `isMarkovChain_iff_channel_factorization`; these
    are provisional patterns, not approved vocabulary. In particular, confirm
    that either candidate is discoverable beside the existential theorem and
    that a shorter name does not hide the total null-fiber convention callers
    may need to inspect. Step 19's stochastic and common-cause examples should
    exercise both the canonical and existential Step 12 surfaces before this
    decision is made.

    Step 19 approved
    `isMarkovChain_iff_canonical_channelExtension` after the common-cause model
    exercised both characterizations. The alias leaves the total conditional
    channel visible in the statement. The broader
    `isMarkovChain_iff_channel_factorization` sketch was declined because it is
    ambiguous beside `isMarkovChain_iff_exists_channelExtension`.

    Chunk 3 Step 13 added no production declaration, so it creates no public
    name to audit. The checkpoint's finite KL equivalence-relabeling result is
    intentionally private in the selected Step 15 proof route unless the
    independent-consumer trigger in Future Work Note 35 is met. Provisional
    names for the Step 14-17 data-processing API must be audited when those
    declarations actually land rather than being approved from scratch names.

    Chunk 3 Step 14 added `pmfChannelKernel`,
    `pmfChannelKernel_apply`, and `channelJoint_toMeasure`. These names are
    concise, lead with the bridged mathematical objects, and avoid marginal,
    coordinate-swap, posterior-fiber, or other implementation details. The
    generated Markov-kernel instance follows normal typeclass naming and is not
    a caller-facing theorem family. No Step 14 declaration needs a watch entry
    or provisional alias.

    Chunk 3 Step 15 added `channelPosterior`,
    `channelPosterior_reconstructs_joint`, and
    `klDiv_channel_eq_add_posterior`. All three names lead with stable
    posterior or KL/channel vocabulary and avoid the private coordinate swap,
    support split, and mathlib `compProd` representation used by the proof.
    They are concise enough to discover as one family and need no watch entry
    or provisional alias. The private `klDiv_map_equiv` helper remains governed
    by Future Work Note 35 rather than this public-name table.

    Chunk 3 Step 16 adds only the private implementation theorem
    `klDiv_channel_le_aux`. It creates no public declaration or name to audit;
    the Step 17 family must be reviewed when its declarations actually land.

    Chunk 3 Step 17 added `klDiv_channel_le`,
    `toReal_klDiv_channel_le`, `klDiv_map_le`, `toReal_klDiv_map_le`,
    `klDiv_channelComp_le`, and `toReal_klDiv_channelComp_le`. The primary
    channel and deterministic-map names are concise, discoverable, and expose
    no posterior, support-transport, or measure-kernel implementation detail;
    they need no watch entry. The two cascade names match the existing
    `PMF.channelComp` and `mutualInfo_channelComp_le` vocabulary but expose the
    constructor spelling rather than the textbook cascade concept. Preserve
    them and mark the pair as `watching`. At Step 19, review the provisional
    compatibility aliases `klDiv_channel_cascade_le` and
    `toReal_klDiv_channel_cascade_le` together with the watched mutual-
    information cascade name. These are sketches, not approved aliases, and
    no declaration should be renamed.

    Step 19 approved both cascade aliases as a coherent textbook-facing pair.
    The stochastic example uses the `ENNReal` alias; the real alias preserves
    the existing source-support contract. Both original `channelComp` names
    remain public and none of the four declarations is a simp rule.

    Chunk 3 Step 18 added `klDiv_channel_invariant_le`,
    `toReal_klDiv_channel_invariant_le`,
    `entropy_le_entropy_bind_of_uniform_invariant`, and
    `entropy_le_entropy_bind_of_doublyStochastic`. The KL pair is concise,
    follows the established channel family, and exposes no implementation
    detail, so it needs no watch entry. The entropy pair states both sides and
    the exact channel condition clearly, but both names are long theorem-search
    terms. Preserve them and mark the pair as `watching`. At Step 19, test the
    provisional compatibility aliases
    `entropy_bind_mono_of_uniform_invariant` and
    `entropy_bind_mono_of_doublyStochastic`. In particular, approve them only
    if `mono` is not misleading about monotonicity in the input law and the
    examples show a real discovery benefit. These are sketches, not approved
    aliases, and no declaration should be renamed.

    During the same review, compare the `mono` sketches with the more literal
    but nonstandard patterns
    `entropy_nondecreasing_of_uniform_invariant` and
    `entropy_nondecreasing_of_doublyStochastic`. Treat these only as vocabulary
    probes: `nondecreasing` may describe the mathematical direction better but
    departs from the project's established `_le_` theorem-search shape and
    omits the visible `bind` operation. Prefer retaining only the descriptive
    declarations if neither shorter family materially improves discovery in
    the Step 19 examples.

    Step 19 declined both shorter entropy families. In the permanent example,
    the existing names make the bind direction and exact channel assumption
    visible. `mono` risks suggesting monotonicity in an ordered input law, and
    `nondecreasing` omits the operation while departing from the established
    `_le_` search shape.

    Step 19 added the compact decision table near the beginning of this note
    without deleting the historical discussion. At the next scheduled naming
    review, update it with each newly watched theorem family's descriptive
    declarations, review status, concise rationale, and either the approved
    compatibility alias or the concrete event that should reopen the question.
    Use statuses consistently:

    - `approved` means that an alias has landed while the original declaration
      remains available;
    - `declined` means that a review found no clearer stable vocabulary and the
      proposal should not be reconsidered merely because the name is long;
    - `deferred` means that the contract, orientation, ownership, or vocabulary
      remains unresolved and identifies a specific proof-pressure trigger;
    - `watching` means that a newly recorded family has not yet reached a
      scheduled review.

    Treat the table as a navigation aid rather than a second source of truth.
    Update it during coherent API reviews, not after every theorem step, and
    ensure that its statuses agree with the detailed entries below. Ordinary
    theorem steps should continue appending awkward names and reasons to the
    detailed watchlist under the standing `AGENTS.md` policy.

    Chunk 4 Step 2 added `isMarkovChainOf_comp`. The name is concise, follows
    the established random-variable deterministic-composition family, and
    exposes none of the local deterministic-channel or channel-extension proof
    representation. It needs no watch entry or provisional compatibility
    alias. No PMF-facing companion was added without an independent consumer.

    Chunk 4 Step 3 added `condEntropyOf_dataProcessing_eq_iff`. Although the
    name is descriptive, it is the direct and discoverable extension of the
    established `condEntropyOf_dataProcessing` and
    `mutualInfoOf_dataProcessing_eq_iff` vocabulary. It exposes no marginal,
    coordinate, mapped-law, or helper representation, so it needs no watch
    entry or provisional alias. A PMF companion remains deferred until it has
    an independent consumer.

    Chunk 4 Step 4 added the definitions `statisticTripleLawOf` and
    `IsSufficientStatisticOf`. Both names are concise and discoverable from
    textbook statistic vocabulary. The first makes the mathematically relevant
    three-coordinate law explicit without exposing marginals, coordinate swaps,
    or proof helpers; the second follows the established random-variable `Of`
    convention. Neither needs a watch entry or provisional alias.

    Chunk 4 Step 5 added
    `isSufficientStatisticOf_iff_isMarkovChainOf`,
    `isSufficientStatisticOf_iff_condMutualInfoOf_eq_zero`,
    `isSufficientStatisticOf_iff_mutualInfoOf_eq`, and
    `isSufficientStatisticOf_iff_condEntropyOf_eq`. The predicate-first family
    is coherent and discoverable as a block, and none of the names exposes
    marginals, coordinate maps, or proof helpers. The names are nevertheless
    long enough to mark the family as `watching` for the scheduled Step 19
    review. Preserve all four declarations. At that review, use the permanent
    examples to test conceptual alias sketches along
    `..._iff_markov`, `..._iff_zero_cmi`,
    `..._iff_mutualInfo_preserved`, and
    `..._iff_condEntropy_preserved`; these are not approved vocabulary, and the
    acronym/`preserved` forms may be less precise than the current names.

    Chunk 4 Step 6 added
    `isSufficientStatisticOf_iff_exists_recovery` and
    `exists_marginal_recovery_of_isSufficientStatisticOf`. The first follows
    the established `..._iff_exists_recovery` vocabulary and its statement
    makes the complete-law contract precise, but the name is long and the word
    `recovery` alone does not advertise full-joint reconstruction. The second
    is deliberately consequence-first and says `marginal`, but is unusually
    long because it must not resemble an iff characterization. Mark both as
    `watching` for Step 19 and preserve them during active theorem work. Test
    only provisional conceptual patterns such as
    `..._iff_exists_full_recovery` and
    `marginal_recovery_of_sufficiency`; neither is approved, and the examples
    must determine whether either improves discovery without blurring the
    existential witness or the false marginal converse.

    Chunk 4 Step 7 added the definitions `IsSufficientChannel` and
    `IsSufficientStatistic`. Both names are concise textbook vocabulary and
    hide the internal swapped-joint-law representation. The unqualified
    statistic name denotes model-family sufficiency, while the established
    `IsSufficientStatisticOf` retains the random-variable fixed-prior `Of`
    convention. This distinction is coherent and discoverable, so neither new
    definition needs a watch entry or provisional alias.

    Chunk 4 Step 8 added
    `isSufficientChannel_iff_exists_common_posterior` and
    `isSufficientStatistic_id`. The identity name is short and canonical, so
    it needs no watch entry. The common-posterior theorem is discoverable and
    hides the private support-cancellation machinery, but its predicate-first
    name is long and does not itself advertise that agreement is support-
    guarded. Mark it `watching` for Step 19 and preserve it during active
    theorem work. Test only provisional conceptual patterns such as
    `..._iff_common_posterior_on_support`; that form is not approved and may be
    no clearer because it suppresses the existential witness.

    Chunk 4 Step 9 added
    `isMarkovChainOf_of_isSufficientChannel`,
    `condMutualInfo_eq_zero_of_isSufficientChannel`,
    `mutualInfo_eq_of_isSufficientChannel`, and
    `condEntropy_eq_of_isSufficientChannel`. Mark the full family as `watching`
    for Step 19 and preserve every current declaration. The first name has an
    awkward `Of_of` stutter, while the latter three are broad enough that a
    search result does not immediately reveal the prior/model channel laws
    being compared. The statements nevertheless expose no private coordinate-
    swap or hierarchical-law helper. Use the permanent examples to test only
    conceptual patterns such as `isSufficientChannel_imp_markov`,
    `..._imp_zero_cmi`, `..._imp_mutualInfo_preserved`, and
    `..._imp_condEntropy_preserved`. These sketches are not approved: `imp` and
    `preserved` may be less idiomatic or less precise than the current names.

    The same step adds `condEntropy_dataProcessing_eq_iff` after Future Work
    Note 33's PMF-consumer trigger was met. Its name is the exact PMF companion
    to `condEntropyOf_dataProcessing_eq_iff`, follows the established `Of`
    distinction, and exposes no representation helper, so it needs no watch
    entry or provisional alias.

    Chunk 4 Step 10 added
    `isSufficientChannel_iff_isMarkovChainOf_of_support_eq_univ`,
    `isSufficientChannel_iff_forall_isMarkovChainOf`,
    `isSufficientStatistic_iff_isSufficientStatisticOf_of_support_eq_univ`,
    and `isSufficientStatistic_iff_forall_isSufficientStatisticOf`. Mark all
    four as `watching` for Step 19 and preserve their current names. The two
    full-support names are especially long and the statistic form repeats the
    `SufficientStatistic`/`SufficientStatisticOf` vocabulary, but the exact
    support hypothesis and PMF/`...Of` distinction are mathematically useful.
    Test only provisional conceptual patterns such as
    `..._iff_markov_of_fullSupportPrior`, `..._iff_markov_forall_prior`,
    `..._iff_fixedPrior_of_fullSupport`, and
    `..._iff_fixedPrior_forall`; these are not approved and may hide either the
    exact support contract or the family/fixed-prior distinction. The new
    `PMF.channelExtension_deterministicChannel` name is concise, follows the
    existing `channelJoint_deterministicChannel` family, and needs no watch
    entry.

    Chunk 4 Step 11 exercised all four Step 10 iff names in the genuinely
    noninjective sufficient-statistic consumer. The names are long but their
    exact full-support versus all-priors and family versus fixed-prior
    distinctions remained understandable at the call sites. Keep all four
    entries `watching` for the scheduled Step 19 API review; the midpoint
    justifies neither an early compatibility alias nor a rename. Step 11 added
    no public declaration and therefore adds no new watchlist entry.

    Chunk 4 Step 12 added
    `isSufficientStatistic_iff_exists_fisherNeymanFactorization`. Mark it
    `watching` for Step 19 and preserve the current name during theorem
    development. It is unusually long, but it is textbook-facing, begins with
    the established predicate family, states the existential shape, and
    exposes no fiber-normalization helper. Test only provisional compatibility
    patterns such as `isSufficientStatistic_iff_fisherNeymanFactorization` or
    `isSufficientStatistic_iff_exists_factorization`; neither is approved, and
    the shorter generic spelling may be ambiguous beside recovery and Markov
    factorizations.

    Chunk 4 Step 13 added `klDiv_channel_eq_iff_posterior_ae_eq`. The name is
    concise, begins with the established KL channel-equality family, and uses
    `posterior_ae_eq` to make its intentionally lower-level contract visible
    without exposing `pmfChannelKernel`, composition-product measures, or the
    private cancellation helper. It is discoverable beside
    `klDiv_channel_eq_add_posterior` and does not need a watch entry or
    provisional alias. At that checkpoint, its pointwise and real-valued names
    were assigned to Step 14 for review as one finite-facing family.

    Chunk 4 Step 14 added
    `klDiv_channel_eq_iff_posterior_eq_on_support` and
    `toReal_klDiv_channel_eq_iff_posterior_eq_on_support`. Mark the pair as
    `watching` for Step 19 and preserve both names during active theorem work.
    They are long, especially the real form, but coherently extend the Step 13
    name and make the mathematically essential null-fiber support restriction
    visible without exposing kernels, composition products, or joint-law
    helpers. A shorter sketch such as `..._iff_posterior_eq` is not approved
    because it hides that total posterior equality is required only on the
    first output law's support. Let Steps 16-18 test discovery before any
    compatibility alias is considered.

    Chunk 4 Step 15 added `klDiv_channel_eq_of_common_recovery`. Its name is
    concise, follows the established KL channel-equality family, and states the
    conceptual hypothesis without exposing the private marginal projection,
    `Prod.swap`, posterior, or kernel machinery. It needs no watch entry or
    provisional alias. Review the Step 16 iff and deterministic names together
    when that coherent family exists; preserve this declaration during active
    theorem work.

    Chunk 4 Step 16 added
    `klDiv_channel_eq_iff_exists_common_recovery`,
    `toReal_klDiv_channel_eq_iff_exists_common_recovery`,
    `klDiv_map_eq_iff_exists_common_recovery`, and
    `toReal_klDiv_map_eq_iff_exists_common_recovery`. Mark the four-name family
    as `watching` for Step 19 and preserve every declaration during active
    theorem work. The names are long, especially the real channel form, but
    align with the established channel/map and `toReal` families and make the
    existential common witness explicit. Test only provisional patterns that
    drop `exists`, such as `..._iff_common_recovery`; they are not approved and
    may hide the theorem's witness shape.

    The same step promoted `PMF.channelJoint_eq_iff_eq_on_support`. Mark it
    `watching` because the repeated `eq_iff_eq` is awkward, although the name
    accurately exposes the essential support restriction and hides the
    positive-mass cancellation proof. A sketch such as
    `channelJoint_eq_iff_channels_eq_on_support` is longer and not approved.
    Let downstream use and the Step 19 ownership review determine whether any
    compatibility alias materially improves discovery.

    Chunk 4 Step 17 added `klDiv_eq_of_isSufficientChannel`,
    `klDiv_eq_of_isSufficientStatistic`,
    `isSufficientChannel_iff_klDiv_eq_bool`, and
    `isSufficientStatistic_iff_klDiv_eq_bool`. The two forward names are
    concise, conceptual, and align with the existing every-prior consequence
    vocabulary, so they need no watch entry. Mark the two Boolean iff names as
    `watching` for Step 19: their contracts are honest about the concrete
    two-law index, but the trailing `_bool` is slightly awkward to parse and
    does not advertise the fixed `false`-to-`true` orientation. Preserve both
    declarations during active theorem work. Test only provisional
    compatibility patterns such as
    `isSufficientChannel_bool_iff_klDiv_eq` and
    `isSufficientStatistic_bool_iff_klDiv_eq`; neither is approved, and the
    permanent examples should determine whether moving the index qualifier
    materially improves discovery.

    During the Step 18 example work or, at latest, the Step 19 API review, run
    one focused orientation probe in addition to the ordinary binary consumer.
    First exercise both directions of each iff theorem on a concrete model with
    `(model false).support subset (model true).support`. Then relabel the same
    mathematical pair through `Bool.not`, so the convenient support inclusion
    is opposite relative to the original labels, and check whether the current
    theorem can be reused with a short, readable reindexing proof. This second
    probe may remain disposable unless it has independent pedagogical value.
    Do not add a duplicate reverse-oriented theorem merely for symmetry. If
    reindexing is painless, retain the current statements and decide only the
    compatibility-alias question above. Consider an orientation-neutral
    theorem with two explicitly chosen distinct Boolean indices only if the
    permanent example demonstrates material proof friction; audit its
    assumptions and name separately before adding it.

    Chunk 4 Step 18 completed both requested probes. The overlapping-support
    permanent model exercised both directions of the channel and statistic iff
    declarations. A disposable proper-support model then reversed the two laws
    through `Bool.not`; unfolding only the family quantifier and reordering the
    two Boolean cases reused the current theorem cleanly. No reverse-oriented or
    orientation-neutral theorem is justified. The 32 example declarations are
    concise within descriptive namespaces and expose no private implementation
    machinery, so they add no watch entry. Keep the two `_bool` declarations
    unchanged and settle only their existing compatibility-alias question in
    Step 19.

    Chunk 4 Step 19 declined every remaining provisional alias. The permanent
    examples and downstream API probe found the current fixed-prior, family,
    posterior, recovery, Fisher-Neyman, KL, support, and Boolean names
    discoverable as coherent theorem families. In each case the length records
    a real contract distinction, while the shorter sketches either suppress an
    existential witness, support guard, prior quantifier, fixed-prior/family
    boundary, full-joint/marginal distinction, or codomain. Namespace and
    mathlib searches found no collision, but no alias cleared the stronger
    downstream-readability test. All ten table entries are therefore
    `declined`, not `deferred` or `watching`; mere name length is not a reason
    to reopen them. Reconsider an individual family only if a later production
    consumer demonstrates a new concrete discovery or readability problem.

    Chunk 4 Step 20 adds no public Lean declaration or compatibility alias.
    The milestone consumers confirmed the reviewed names at the core,
    data-processing, downstream KL, and example boundaries. The Chunk 4
    decision table therefore remains unchanged and no naming item is reopened
    merely by the integration commit.

    The July 23 post-Chunk 4 cleanup changes only maintained status text and
    source doc comments. It adds no public declaration, name, or alias. The API
    index now documents all 686 declarations, while the Step 19 decision table
    and its evidence-based reopening rule remain unchanged.

15. The Step 13 `[simp]` review for mutual information and conditional mutual
    information was completed on July 14, 2026. Local attributes were tested
    on representative PMF, random-variable, symmetry, diagonal/self, and
    entropy-difference goals. Four strictly reducing rules were promoted:

    - `mutualInfo_map_swap` normalizes an explicit `Prod.swap` map;
    - `condMutualInfo_map_swap12` normalizes an explicit first-two-coordinate
      swap;
    - `mutualInfo_map_diag` removes a diagonal PMF construction;
    - `mutualInfoOf_self` removes a random-variable self construction.

    These rules select a visibly simpler construction-free normal form and did
    not create rewrite cycles. Pure random-variable commutativity statements
    such as `mutualInfoOf_swap` and `condMutualInfoOf_swap` remain explicit,
    because both sides have the same syntactic shape and automatic rewriting
    would choose an arbitrary variable order. The MI/CMI entropy-difference
    identities also remain explicit so users retain control of the entropy
    normal form. Revisit this policy only if later simp behavior supplies a
    concrete regression or a new strictly reducing construction.

    Chunk 2 Step 17 re-ran this policy against the KL/support,
    independence/conditional-independence, equality-case, and example layers.
    None of the new iff theorems or compatibility aliases is a strictly
    reducing construction rewrite, so no new `[simp]` attribute was added. The
    four previously approved swap and diagonal/self rules remain unchanged.

    Chunk 3 Step 9 keeps `mutualInfo_markov_chain_rule` and
    `mutualInfoOf_markov_chain_rule` explicit. Both rewrite a compact mutual-
    information term into an additive loss decomposition, so neither is a
    strictly construction-reducing normalization rule. The existing four-rule
    simp policy remains unchanged.

    Chunk 3 Step 10 keeps all six data-processing declarations explicit.
    Inequalities are not simplification rules, and the equality iff theorems
    require a forward Markov hypothesis and move to a semantic reverse-chain
    condition rather than a construction-reducing normal form. The existing
    four-rule simp policy remains unchanged.

    Chunk 3 Step 11 keeps all five channel-facing contractions explicit.
    Inequalities do not provide a simplifier normal form, and the private PMF
    law-identification helpers are not rewrite rules. No new simp attribute or
    change to the existing four-rule policy is justified.

    Chunk 3 Step 12 keeps both channel-factorization equivalences explicit.
    Rewriting an arbitrary `IsMarkovChain p` proposition into a canonical PMF
    equality or existential channel statement is a caller-selected semantic
    view, not a strictly reducing simplifier normal form. The existing Step 8
    rule remains the sole Markov-specific simp theorem because it closes a goal
    headed by an explicit `PMF.channelExtension` constructor. No new simp
    attribute or change to the existing four-rule MI/CMI policy is justified.

    Chunk 3 Step 14 marks only `pmfChannelKernel_apply` as `[simp]`. It strictly
    removes the bridge constructor and exposes the underlying PMF measure at a
    fixed input. `channelJoint_toMeasure` remains explicit because choosing
    between a PMF joint measure and kernel `compProd` is a semantic view rather
    than a simplifier normal form. No broader simp-policy change is justified.

    Chunk 3 Step 15 adds no simp theorem. `channelPosterior_reconstructs_joint`
    and `klDiv_channel_eq_add_posterior` each select a substantial semantic
    representation rather than a canonical simplifier normal form, so both
    remain explicit. The private equivalence and `compProd` helpers carry no
    attributes.

    Chunk 3 Step 16 adds no simp theorem. Its private contraction engine is an
    inequality and remains an explicit internal proof step; the existing simp
    policy is unchanged.

    Chunk 3 Step 17 keeps all six KL data-processing inequalities explicit.
    Neither contraction nor real conversion is a simplifier normal form, and
    the private bind-support transport lemma carries no attribute. The existing
    simp policy is unchanged.

    Chunk 3 Step 18 keeps both invariant-reference contractions and both
    entropy-growth inequalities explicit. The local proof that unit channel
    columns preserve the uniform PMF is not published as a rewrite theorem.
    No new simp attribute or policy change is justified.

    Chunk 3 Step 19 re-ran direct channel-extension, nested two-channel,
    reversed-coordinate Markov, mutual-information swap, and conditional-
    mutual-information swap goals. Every goal closes with the existing rules,
    with no loop or surprising orientation. The five new compatibility aliases
    carry no simp attributes. Retain the existing Markov constructor rule and
    four-rule MI/CMI normalization policy unchanged.

    Keep `IsMarkovChainOf` and `IsMarkovChain` as controlled public
    abstractions rather than adding global simp rules that unfold them to
    `IsCondIndependentOf` or its cross-product representation. The definitions
    can still be unfolded explicitly inside proofs, while the named Markov
    characterizations let callers choose the semantic normal form they need.
    Revisit this only if several production proofs exhibit the same concrete
    unfolding friction. Prefer a targeted, directionally reducing theorem over
    globally exposing conditional-independence or atomwise factorization during
    simplification; audit any proposed rule for loops with reversal and
    coordinate-map simp theorems during the Step 19 review.

    Step 8 marks `isMarkovChain_channelExtension` as `[simp]` because it closes
    a proposition headed by the explicit `PMF.channelExtension` constructor;
    temporary checks confirmed both the generated-chain and reversed-chain
    normalizations. Retain this rule unless later channel-composition or cascade
    simp lemmas produce a concrete loop, surprising orientation, or material
    simplifier slowdown. Re-run representative direct, two-channel cascade,
    and reversed-coordinate goals during the Step 19 simp review. Do not remove
    the attribute merely because the same theorem can be invoked explicitly.

    Chunk 4 Step 2 keeps `isMarkovChainOf_comp` explicit. Although its conclusion
    contains a deterministic composition, unfolding a random-variable Markov
    predicate is not needed for simplification, and the planned sufficiency
    proofs can invoke the theorem directly. This preserves
    `isMarkovChain_channelExtension` as the sole Markov-specific simp theorem
    until concrete downstream simplifier pressure justifies another rule.

    Chunk 4 Step 3 keeps `condEntropyOf_dataProcessing_eq_iff` explicit, as
    required by Future Work Note 33. The equivalence selects a semantic reverse-
    Markov characterization rather than reducing a constructor or normalizing
    an entropy expression, so it is not a simp rule. No existing simp attribute
    changed.

    Chunk 4 Step 4 adds only two controlled definitions and no theorem or simp
    attribute. In particular, `IsSufficientStatisticOf` does not unfold
    automatically to its reverse-Markov representation, and
    `statisticTripleLawOf` is unfolded explicitly by consumers. Revisit only if
    the Step 5-6 theorem API reveals a genuinely reducing public normalization.

    Chunk 4 Step 5 keeps all four fixed-prior equivalences explicit. The Markov
    theorem is a caller-selected view of the controlled predicate, while the
    zero-CMI, MI, and conditional-entropy theorems choose semantic
    characterizations rather than construction-free simplifier normal forms.
    No definition unfolds globally and no existing simp attribute changed.

    Chunk 4 Step 6 keeps both recovery declarations explicit. The full-law iff
    selects an existential semantic characterization rather than a canonical
    normal form, while the marginal theorem consumes a sufficiency hypothesis
    and produces a witness. Neither is a reducing simp rule, the two private
    representation bridges remain untagged, and no existing simp attribute
    changed.

    Chunk 4 Step 7 adds only the controlled definitions
    `IsSufficientChannel` and `IsSufficientStatistic`. Neither receives a simp
    attribute or a global unfolding rule. The deterministic specialization is
    available by explicit unfolding or definitional equality, and no theorem
    or existing simp attribute changed.

    Chunk 4 Step 8 keeps the supported common-posterior equivalence and the
    identity-statistic theorem explicit. The iff selects a semantic
    characterization with an existential witness, while the identity theorem
    is a direct proposition that current consumers can invoke by name. Do not
    add a simp attribute during the active phase; let the Step 18 examples and
    scheduled Step 19 review determine whether identity-statistic goals recur
    enough to justify automatic closure. The private support-identifiability
    lemma is untagged, and no existing simp attribute changed.

    Chunk 4 Step 9 keeps all four every-prior consequences and the new PMF
    `condEntropy_dataProcessing_eq_iff` bridge explicit. The
    reverse-Markov theorem consumes a sufficiency hypothesis, the zero-CMI
    theorem chooses a semantic equality, and the MI and conditional-entropy
    theorems orient exact preservation identities; none is a strictly reducing
    constructor normalization. The PMF bridge is a caller-selected semantic
    equivalence rather than a normalization rule. The private hierarchical-law
    identification is untagged, and no existing simp attribute changed.

    Chunk 4 Step 10 keeps all five new theorems explicit. A direct simp probe
    showed that tagging `PMF.channelExtension_deterministicChannel` rewrites the
    constructor inside `IsMarkovChain` before
    `[simp] isMarkovChain_channelExtension` can close the goal, leaving a mapped-
    law proposition. The attribute was therefore removed. The four full-
    support/all-prior iff theorems are caller-selected semantic views, and the
    private coordinate and deterministic representation bridges are untagged.

    Chunk 4 Step 11 used the explicit deterministic channel-extension and
    sufficiency equivalence surfaces without requesting automatic rewriting.
    The temporary examples exposed no loop, stuck constructor goal, or repeated
    normalization boilerplate, so the Step 10 simp decision remains unchanged
    and no new simp rule is justified.

    Chunk 4 Step 12 keeps the Fisher-Neyman iff explicit. Rewriting a
    sufficiency predicate into two existential factor functions is a caller-
    selected semantic view, not a reducing normalization, while the private
    fiber weights, totals, and recovery construction are implementation
    details. The public consumer needed no automatic rewrite, so no simp
    attribute or change to the existing policy is justified.

    Chunk 4 Step 13 keeps the posterior-kernel equality iff explicit. It
    selects a semantic equality characterization and rewrites KL divergence
    through composition-product measures, so it is not a constructor-reducing
    normal form. The private cancellation helper is untagged, and no existing
    simp attribute changed.

    Chunk 4 Step 14 keeps both support-pointwise equality iff theorems
    explicit. Rewriting KL equality into a universally quantified posterior
    condition is a caller-selected semantic view, not a reducing constructor
    rule. The reused private support-identifiability theorem remains untagged,
    and no existing simp attribute changed.

    Chunk 4 Step 15 keeps `klDiv_channel_eq_of_common_recovery` explicit. It is
    a semantic implication from two full-joint recovery equations to KL
    equality, not a constructor-reducing normalization. The private marginal-
    recovery projection is also untagged, and no existing simp attribute
    changed.

    Chunk 4 Step 16 keeps all four recovery iff theorems and
    `PMF.channelJoint_eq_iff_eq_on_support` explicit. Each iff selects a
    semantic support-aware recovery view rather than a constructor-reducing
    normal form. The deterministic proofs use existing simp laws locally, but
    no new or existing declaration receives a simp attribute.

    Chunk 4 Step 17 keeps both preservation implications and both guarded
    Boolean iff theorems explicit. They select semantic KL consequences or
    characterizations of controlled sufficiency predicates rather than
    reducing a visible constructor. The deterministic proofs use existing
    channel/map simplification only locally; no declaration or definition gains
    a simp attribute.

    Chunk 4 Step 18 adds no simp declaration. An initially convenient
    example-only attribute on `fairPrior_support` was removed after the first
    generated-index pass because no proof consumed it and Step 19 has not yet
    selected a global normal form. The marginal-only use of `id` does not invoke
    `isSufficientStatistic_id`, so that theorem still has no repeated simp
    pressure.

    Chunk 4 Step 19 retained that decision. A source audit found no simp
    declaration in `Sufficiency`, `Sufficiency.KL`, or
    `Examples.SufficientStatistics`, and the permanent examples needed no
    automatic unfolding of the controlled predicates or semantic iff
    theorems. Recovery, posterior equality, Fisher-Neyman factorization, and KL
    equality remain caller-selected views. No new attribute, duplicate alias
    rule, or change to the existing constructor-reducing simp surface is
    justified.

16. Revisit `[simp]` status for conditional entropy chain-rule theorems after
    the chain-rule family has more downstream examples. The July 8 chain-rule
    step deliberately kept
    `entropy_eq_entropy_sndMarginal_add_condEntropy`,
    `entropy_eq_entropy_fstMarginal_add_condEntropy_swap`, and the
    random-variable variants explicit rather than marking them `[simp]`.
    These theorems rewrite between mathematically equivalent but differently
    useful normal forms, such as `H(A,B)` and `H(B) + H(A|B)`, so automatic
    simplification could make proofs noisier or choose a direction too early.
    Project B Chunk 1 Step 6 added
    `condEntropyOf_pair_chain_rule`,
    `condEntropyOf_pair_chain_rule_swap`, and their PMF-facing
    `pairThirdLaw` forms as further explicit rewrites. This broadens the family
    but still does not supply enough downstream use to choose a canonical
    automatic orientation.
    Step 7 then used those rules explicitly for deterministic conditional
    entropy processing without needing new simp attributes. Step 9 likewise
    used the pair chain rules explicitly for marginal-to-joint bounds.
    The Step 13 review retained this policy. Deterministic processing, MI/CMI
    identities, and the pair/triple inequality proofs all used chain rules
    successfully as explicit rewrites, while no stable entropy-expanded normal
    form emerged. None of the ordinary or conditional chain rules is `[simp]`.
    Revisit only if later downstream proofs demonstrate that one orientation
    reliably reduces proof search without fighting other entropy rewrites.

    Chunk 2 Steps 15 and 16 added equality cases and examples, but neither
    produced a stable automatic chain-rule direction. The Step 17 review
    therefore retained every ordinary and conditional entropy chain rule as an
    explicit rewrite.

17. Run the broader project build suite before release, commit, or milestone
    checkpoints, while keeping focused builds for small theorem iterations.
    During individual theorem steps it is reasonable to build the touched
    module, the root import, and the main downstream semantic bridge target,
    because repeatedly building examples, demos, reference anchors, and heavier
    theorem modules can slow iteration without adding much signal for a local
    algebraic lemma. Before finalizing a milestone, preparing a commit, or
    publishing updated public status, run the full expected suite from the
    README/agent notes: `lake build LeanInfoTheory`,
    `lake build LeanInfoTheory.Shannon.EntropyBounds`,
    `lake build LeanInfoTheory.Shannon.Units`,
    `lake build LeanInfoTheory.Shannon.SemanticBridge`,
    `lake build LeanInfoTheory.MathlibFragments`,
    `lake build LeanInfoTheory.Certificate.Submodularity`,
    `lake build LeanInfoTheory.Certificate.Subadditivity`,
    `lake build LeanInfoTheory.Certificate.Monotonicity`,
    `lake build LeanInfoTheory.Certificate.ThreeWaySubadditivity`, and
    `lake build LeanInfoTheory.Examples`, plus the website generators and
    checks when public declarations or imports changed.

    Project B Chunk 1 followed this policy: targeted builds supported Steps 1
    through 13, and Step 14 then ran the complete ten-target suite, regenerated
    both source-derived reference sets, and passed the website and repository
    hygiene checks. Section 75 records the exact results, and the resulting
    milestone is commit `7ab3aa0`. Apply the same targeted-development/full-
    milestone distinction to later chunks.

    Project B Chunk 2 followed the same policy. Focused builds and temporary
    no-placeholder probes supported the first 17 steps; the final integration
    step then passed the complete ten-target suite, regenerated both
    source-derived reference sets, and passed the website and repository
    hygiene checks. Section 92 records the exact results.

    For a future milestone that adds public declarations to a separately
    importable opt-in module, supplement the dependency-graph check with an
    explicit root-isolation smoke test. A positive temporary consumer should
    import the owning opt-in module and typecheck representative declarations;
    a negative consumer should import only `LeanInfoTheory` and verify that the
    same declarations are not brought into scope by the lightweight root.
    Prefer a stable checked mechanism, such as a deliberately guarded Lean
    diagnostic or a source-derived import/reachability assertion, over treating
    an unstructured failing Lean command as success. Delete temporary consumers
    after the check and record both the positive and negative result in the
    milestone log. The generated module graph remains the broad architectural
    check; this smoke test is an extra user-facing contract check for newly
    added opt-in APIs, not a replacement for it and not required after theorem
    steps that do not alter public declarations or imports.

    Project B Chunk 3 Steps 14 and 15 have already satisfied the positive-
    consumer side of this policy for the new opt-in
    `Shannon.SemanticBridge.DataProcessing` module: temporary consumers imported
    the module, exercised the PMF-to-kernel bridge, posterior reconstruction,
    exact KL decomposition, and contraction specialization, and were deleted
    after passing. The deliberately small Step 14 declaration surface was also
    audited after real Step 15-16 consumers, so no retrospective private design
    note is needed. The only remaining verification item from the Step 13
    review is milestone-level rebuild coverage. Keep focused builds during
    Steps 17-19, then let Step 20 run the complete suite above and the root-
    isolation checks. A cold rebuild from cleared Lake artifacts is optional
    release hardening rather than a Step 17 blocker; if Step 20 performs one,
    record it explicitly in the milestone log.

    Chunk 3 Step 20 completed the full ten-target suite without requiring a cold
    rebuild. It regenerated both source-derived references, passed the website
    checker, compiled a positive opt-in consumer, and confirmed through the
    generated source-derived import graph that all five new modules remain
    unreachable from the root. Section 113 records the exact job and reference
    counts. This milestone-level verification item is closed.

    Chunk 4 Step 4 applied the same opt-in boundary policy immediately to the
    new sufficiency core. A positive consumer imported only
    `SemanticBridge.Sufficiency` and exercised both definitions; a root-only
    consumer inspected Lean's environment and confirmed that neither declaration
    was reachable. Both temporary files and artifacts were deleted. The
    generated graph independently records the module as non-root-reachable.

    Chunk 4 Step 17 repeated that contract at the downstream KL boundary. A
    standalone `Sufficiency.KL` consumer exercised all four family declarations,
    while data-processing-only and root-only probes both rejected the new names.
    Focused module and aggregate/root builds pass; the broader ten-target suite
    remains assigned to Step 20 rather than this local theorem step.

    Chunk 4 Step 18 applies the same policy to
    `Examples.SufficientStatistics`. A positive consumer imported only the new
    module and checked the representative public surface; a root-only consumer
    rejected it. Focused example, aggregate, and semantic/root builds pass, and
    generated reachability keeps the module outside the root. The complete ten-
    target milestone suite remains assigned to Step 20.

    Chunk 4 Step 20 completed that assignment. All ten required Lake targets
    passed, guarded consumers confirmed the root/core/data-processing/downstream
    boundaries, and the source-derived graph records all three new modules as
    non-root-reachable. Both generators and the website checker passed. This
    milestone-level verification item is closed without a cold rebuild.

    During the July 23 post-Chunk 4 cleanup, the two touched-module builds and
    the website checker passed. The complete ten-target suite, final generator
    idempotence and hygiene checks, and checkpoint remained assigned to cleanup
    Step 4 at the end of Step 3. This note continues to govern milestone
    verification.

    Cleanup Step 4 completed that assignment. Both generators are byte-for-byte
    idempotent, the website checker passes, all ten required Lake targets pass,
    and the final source, architecture, artifact, process, and diff-hygiene
    audits pass. This closes the current checkpoint assignment while preserving
    this note as the standing milestone-verification policy.

18. Standing architecture guardrail: preserve the boundary between the
    completed pair/triple Chunk 1, the completed equality/independence Chunk 2,
    and later Project B chunks. The full equality characterization for the
    support-cardinality entropy bound, `I(X;Y) = 0` iff independence,
    `H(X|Y) = H(X)` iff independence, and the corresponding conditional-
    independence equality cases were completed with the general finite
    KL/equality work in Chunk 2. Stochastic channels, Markov structure, and
    general data processing were completed separately in Chunk 3. Chunk 1 Step
    7 completed deterministic entropy
    processing and its support/recovery equality cases from the existing zero-
    conditional-entropy API without introducing the deferred infrastructure.
    Chunk 1 Step 9 added the pair-level inequalities while deliberately
    omitting their independence-based equality cases. Step 10 added only
    deterministic mutual-information processing; stochastic channels and the
    equality characterization through conditional independence remain in the
    later layers. Step 11 completed only algebraic conditional-MI rewrites; it
    did not add zero-CMI or conditional-independence characterizations. Step 12
    completed the conditional inequality band while likewise deferring every
    conditional-independence equality case.

    Project B Chunk 2 Steps 7, 10, 11, 12, 13, 14, 15, and 16 have now
    completed the
    support-cardinality equality, zero-MI, conditioning-equality, joint-
    additivity, positive-fiber reduction, proof-independent conditional-
    independence predicates, zero-CMI equivalences, and the resulting
    conditional-entropy equality cases deferred here, together with every
    planned example. `Examples.SupportSensitive` now contains the proper-
    support entropy-bound comparison, the null/positive conditional-fiber
    contrast, and the support-wise but non-global functional-dependence
    witness. These completed examples confirm that the support-sensitive
    theorem statements should not be strengthened to global ambient-alphabet
    conditions.

    Chunk 2 Step 18 completed the final integration and checkpoint review
    without adding stochastic-channel or Markov definitions. Those topics
    remain a later focused dependency layer rather than an extension of the
    completed equality/independence chunk.

19. Keep the Step 7 deterministic-entropy decomposition private unless a later
    theorem creates a genuine consumer. The two planned support-sensitive
    examples were completed in Chunk 2 Step 16. Chunk 1 Step 10 checked whether
    deterministic mutual-information processing needed the ordinary chain
    identity

    `H(X) = H(f(X)) + H(X | f(X))`.

    It did not: the compiled Step 10 proof uses injective deterministic
    augmentation, the existing mutual-information chain rule, and conditional-
    MI nonnegativity. The Step 7 PMF-oriented decomposition therefore remains a
    private helper. Promote a public theorem only if a later step produces a
    real consumer. Prefer a clean random-variable statement such as

    `entropyOf p X = entropyOf p (fun omega => f (X omega)) +
      condEntropyOf p X (fun omega => f (X omega))`,

    then add a PMF-facing corollary only if it is also used. Do not expose the
    current `id`-based helper merely to make the public theorem count larger.

    Step 16 added the two examples in the separately importable
    `LeanInfoTheory.Examples.SupportSensitive` module and exercised the exact
    public equality contracts:

    - an ordinary example where `f` is not globally injective but is injective
      on `(p.map X).support`, so `H(f(X)) = H(X)` still holds through
      `entropyOf_comp_eq_iff_injOn_support`;
    - a conditional example where `f` loses information about `X` by itself,
      but `Z` disambiguates the collided values and a decoder recovers `X` from
      `(f(X), Z)` on `p.support`, so
      `H(f(X)|Z) = H(X|Z)` through
      `condEntropyOf_comp_eq_iff_exists_recovery`.

    The examples remain outside the core theorem modules. They demonstrate why
    support-restricted injectivity and recovery are the correct information-
    theoretic contracts and created no pressure for a specialized alias or for
    promotion of the private decomposition. Only that possible future
    decomposition theorem remains deferred in this note.

20. Closed historical note: the proposed separately importable elementary-MI
    usage example was closed without adding a redundant module during Step 13.
    Step 9 supplied genuine proof pressure for the Step 8 identities, and the
    Step 13 simp probes plus generated theorem documentation were sufficient to
    review the final aliases and self/diagonal simplification behavior.

    A worthwhile example should exercise all three mathematical views rather
    than simply restate theorem signatures:

    - `I(X;Y) = H(X) - H(X|Y)`;
    - `I(X;Y) = H(Y) - H(Y|X)`;
    - `I(X;X) = H(X)` through `mutualInfoOf_self` or the diagonal PMF theorem.

    If a later pedagogical examples pass independently needs this material,
    prefer a small nontrivial finite law; avoid a pure-law example where every
    quantity vanishes. Keep any such example outside the core Shannon modules
    and out of the lightweight root. This note is no longer an active API task.

21. Mutual-information injective-relabeling proof-pressure note: revisit the
    public theorem family only when a second genuine consumer appears. The
    private Chunk 1 Step 10 helper proves the special case needed there by
    adjoining a deterministic image to its source variable and using entropy
    invariance under an injective map. If later deterministic-
    processing, sufficient-statistic, or channel proofs repeat that argument,
    extract a coherent public theorem family saying that injectively relabeling
    either random variable preserves mutual information, together with PMF
    coordinate forms only when they are used.

    Before fixing statements, decide whether the main contract should assume a
    global `Function.Injective` map or the sharper support-aware condition
    `Set.InjOn f (p.map X).support`, and decide whether the lightweight
    `InfoMeasures` layer can own the result or whether the support-aware proof
    genuinely belongs in the semantic theorem layer. Do not promote the current
    augmentation helper or add both orientations merely to enlarge the API;
    let a repeated proof establish the abstraction and naming pressure first.

    Step 11 did not repeat the augmentation argument: its new CMI identities
    use entropy algebra, product reassociation, symmetry, and existing
    conditional-entropy chain rules. There is therefore still only one genuine
    consumer, and no public relabeling theorem family should be extracted yet.
    Step 12 also avoided the argument: all ten inequalities follow from
    nonnegativity, the Step 6 chain rules, and the Step 11 CMI identities. Step
    13 added only aliases, simp attributes, and base conversion, so it supplied
    no second consumer either. The public relabeling family remains deferred.

    Step 16's support-restricted encoding example uses the existing entropy
    equality theorem directly. It does not repeat the private mutual-
    information augmentation argument, so the public MI relabeling family
    still has only one genuine consumer. Step 17 completed the scheduled review
    and kept the family deferred: neither the global-injectivity versus
    support-aware contract nor module ownership should be fixed without a
    second proof consumer.

    Chunk 3 Step 9 uses the two existing mutual-information chain rules and the
    public zero-CMI Markov equivalence. It does not repeat the private
    augmentation or injective-relabeling argument, so the tracked public MI
    relabeling family still has only one genuine consumer and remains deferred.

    Chunk 3 Step 10 uses only the exact Markov loss identity, CMI
    nonnegativity, elementary ordered-group cancellation, and the public zero-
    CMI Markov equivalence. It does not repeat the private augmentation or
    injective-relabeling proof, so the tracked relabeling family still has only
    one genuine consumer and remains deferred.

    Chunk 3 Step 11 uses the public Markov DPI, mutual-information swap, and
    PMF monad laws. It does not repeat the private deterministic augmentation
    or prove injective relabeling, so the tracked MI relabeling family still has
    only one genuine consumer and remains deferred.

    Chunk 3 Step 19's permanent examples use channel contraction and Markov
    factorization directly. Neither repeats the augmentation proof or requires
    injective relabeling, so the production count remains one and the global-
    versus support-injective contract stays deferred.

    Chunk 4 Step 9 performs one private coordinate swap while identifying a
    recovered hierarchical PMF atomwise. It does not prove mutual-information
    invariance under relabeling and derives preservation from the existing
    forward/reverse Markov equality theorem. The tracked MI relabeling family
    therefore still has one genuine consumer and remains deferred.

    Chunk 4 Step 10 again swaps only a generated PMF law and cancels prior
    masses before applying any information measure. It does not establish or
    consume mutual-information relabeling invariance, so the tracked public MI
    family remains at one genuine consumer.

    Chunk 4 Step 18's noninjective example obtains fixed-prior mutual-
    information preservation from the public sufficiency equivalence. It does
    not prove or consume invariance under an injective relabeling, so the tracked
    augmentation argument still has one genuine production consumer.

    Chunk 4 Step 19 adds only documentation and API checks. Its disposable
    consumer invokes the existing declarations by name and repeats no
    augmentation or relabeling proof. The production count remains one, so the
    global-injective versus support-aware statement and module owner remain
    deliberately unresolved.

22. Revisit a general explicit-finiteness form of the real-valued PMF KL zero
    theorem only after a second production proof repeats the pattern; this is
    not immediate work. The existing finite-PMF-facing theorem
    `toReal_klDiv_pmf_eq_zero_iff` should remain unchanged. Its proof uses Step
    4's support/finiteness characterization to obtain
    `InformationTheory.klDiv p.toMeasure q.toMeasure ≠ ⊤`, then eliminates the
    `⊤` branch of `ENNReal.toReal_eq_zero_iff`.

    If another production proof directly assumes the same `klDiv ≠ ⊤`
    condition and manually repeats that branch elimination, consider a general
    theorem provisionally named
    `toReal_klDiv_pmf_eq_zero_iff_of_ne_top`. Its contract should require
    measurable singletons and an explicit `klDiv ≠ ⊤` hypothesis, but no
    finite-alphabet or support-inclusion assumption. The existing support-
    guarded theorem should then remain the finite-facing corollary. Audit the
    provisional name under Future Work Note 14 before promoting it.

    Step 6 did not provide the second consumer: the uniform-reference proof
    uses support inclusion to obtain absolute continuity and then invokes the
    finite KL sum expansion. There is therefore still exactly one production
    occurrence of the branch-elimination pattern, and no general helper should
    be added yet.

    Step 7 also did not provide a second consumer: its entropy equality proofs
    use strict Jensen and no KL finiteness or `ENNReal.toReal_eq_zero_iff`
    branch elimination. The production count therefore remains exactly one.

    Step 8 likewise added only PMF equality, pointwise factorization, and
    symmetry results. It does not inspect KL or eliminate an `ENNReal.toReal`
    top branch, so the production count remains exactly one.

    Step 9 compares PMF and measure pushforward-product equalities through
    `PMF.toMeasure_inj`; it does not inspect KL or eliminate an
    `ENNReal.toReal` top branch. The production count therefore remains exactly
    one.

    Step 10 uses the existing support-guarded
    `toReal_klDiv_pmf_eq_zero_iff` theorem after deriving its support inclusion
    hypothesis. It neither assumes `klDiv ≠ ⊤` directly nor repeats the manual
    `ENNReal.toReal_eq_zero_iff` top-branch elimination. The tracked production
    count therefore remains exactly one.

    Step 11 uses only finite entropy identities and Step 10's public zero-MI
    equivalence. It does not inspect KL or repeat any `ENNReal.toReal` branch
    elimination, so the tracked production count remains exactly one.

    Step 12 uses the averaged conditional-MI finite-sum identity and semantic
    nonnegativity. Its only `ENNReal.toReal` fact is positivity of a nonzero PMF
    atom; it does not inspect KL or eliminate the `toReal` top branch. The
    tracked production count therefore remains exactly one.

    Step 13 uses PMF atom identities and finite nonzero `ENNReal`
    multiplication cancellation. It neither invokes KL nor eliminates an
    `ENNReal.toReal` top branch, so the tracked production count remains exactly
    one.

    Step 14 composes the public Step 10 zero-MI equivalence with the Step 12 and
    Step 13 fiber bridges. It does not directly inspect KL or eliminate an
    `ENNReal.toReal` top branch, so the tracked production count remains exactly
    one.

    Step 15 uses only finite entropy identities and the Step 14 public zero-CMI
    equivalences. It does not inspect KL or eliminate an `ENNReal.toReal` top
    branch, so the tracked production count remains exactly one.

    Step 16 deliberately demonstrates the opposite branch: its disjoint pure
    laws have KL equal to `⊤`, and `ENNReal.toReal` then returns zero. The proof
    rewrites the established `klDiv_pmf_eq_top_iff_not_support_subset` theorem;
    it neither assumes `klDiv ≠ ⊤` nor repeats the guarded
    `ENNReal.toReal_eq_zero_iff` branch elimination. The tracked production
    count therefore remains exactly one, and the general helper is still not
    justified.

    Step 17 added only exact aliases for entropy-additivity equivalences. It
    does not inspect KL or repeat either real-valued branch argument, so the
    tracked production count remains exactly one.

    Chunk 3 Step 13's temporary real-valued contraction proof uses
    `ENNReal.toReal_mono` together with the existing finite support
    characterization. It neither proves a zero characterization nor manually
    eliminates the top branch of `ENNReal.toReal_eq_zero_iff`. The spike was
    deleted, so the production count remains exactly one and the general helper
    is still unjustified.

    Chunk 3 Step 14 adds no real-valued KL proof. Chunk 3 Step 15's private
    equivalence-invariance proof compares finite real KL sums after splitting
    on support inclusion, but it does not prove a zero characterization or
    eliminate the top branch of `ENNReal.toReal_eq_zero_iff`. The exact public
    decomposition is `ENNReal`-valued. The tracked production count therefore
    remains exactly one.

    Chunk 3 Step 16 is also entirely `ENNReal`-valued. It does not call
    `ENNReal.toReal`, assume KL finiteness, or inspect a top branch, so the
    tracked production count remains exactly one.

    Chunk 3 Step 17's three real-valued contraction theorems use
    `ENNReal.toReal_mono` and the existing finite support characterization.
    None proves a zero characterization or manually eliminates the `⊤` branch
    of `ENNReal.toReal_eq_zero_iff`. The tracked production count therefore
    remains exactly one, and `toReal_klDiv_pmf_eq_zero_iff_of_ne_top` is still
    unjustified.

    Chunk 3 Step 18's real invariant-reference theorem delegates to the Step 17
    real channel inequality, and both entropy results use the established
    uniform-reference KL identity. No proof characterizes KL zero or manually
    eliminates the `⊤` branch of `ENNReal.toReal_eq_zero_iff`. The tracked
    production count remains exactly one.

    Chunk 3 Step 19's real cascade example invokes
    `toReal_klDiv_channel_le`; it does not characterize KL zero or eliminate a
    top branch. The production count remains exactly one, so the proposed
    explicit-finiteness zero theorem is still unjustified.

    Chunk 4 Step 9 uses no KL theorem and never inspects `ENNReal.toReal`.
    The tracked branch-elimination pattern therefore remains at one production
    proof, and `toReal_klDiv_pmf_eq_zero_iff_of_ne_top` is still unjustified.

    Chunk 4 Step 10 also uses no KL or real-valued divergence theorem. Its
    cancellation is directly in finite PMF atoms, so the explicit-finiteness
    `ENNReal.toReal` branch-elimination count remains one.

    Chunk 4 Step 13 is entirely `ENNReal`- and measure-valued. Its private
    helper assumes KL is not top only to cancel a finite addend; the proof never
    calls `ENNReal.toReal_eq_zero_iff` or eliminates a real-KL top branch. The
    tracked production count therefore remains exactly one, and the proposed
    `toReal_klDiv_pmf_eq_zero_iff_of_ne_top` theorem remained unjustified
    entering Step 14.

    Chunk 4 Step 14's real equality theorem uses
    `ENNReal.toReal_eq_toReal_iff'` after proving both divergences are not top
    from the existing support guard and KL data processing. It does not call
    `ENNReal.toReal_eq_zero_iff` or manually eliminate its top branch. The
    tracked production count therefore remains exactly one, so the proposed
    general zero theorem is still unjustified.

    Chunk 4 Step 15 is entirely `ENNReal`-valued. Its proof sandwiches KL with
    data processing through the forward and recovery channels and never calls
    `ENNReal.toReal_eq_zero_iff` or eliminates a real-KL top branch. The tracked
    production count remains exactly one, so the proposed explicit-finiteness
    zero theorem is still unjustified.

    Chunk 4 Step 16's two real recovery theorems use
    `ENNReal.toReal_eq_toReal_iff'` after deriving input and output KL
    finiteness from support inclusion and channel data processing. Neither
    proof calls `ENNReal.toReal_eq_zero_iff` or manually eliminates its top
    branch. The tracked production count remains one, so the proposed general
    zero theorem is still unjustified.

    Chunk 4 Step 17 is entirely `ENNReal`-valued. It reuses the exact Step 15
    equality and Step 16 recovery iff without introducing any `toReal` proof,
    calling `ENNReal.toReal_eq_zero_iff`, or eliminating a top branch. The
    tracked production count remains one.

    Chunk 4 Step 18 also stays entirely in the public `ENNReal` KL surface. Its
    examples neither call `ENNReal.toReal_eq_zero_iff` nor eliminate a top
    branch, so the proposed explicit-finiteness zero theorem remains
    unjustified with one production occurrence.

    Chunk 4 Step 19 changes no proof and introduces no real-KL consumer. The
    manual `ENNReal.toReal_eq_zero_iff` top-branch elimination count therefore
    remains one, and `toReal_klDiv_pmf_eq_zero_iff_of_ne_top` is still not
    justified.

23. Revisit the uniform-reference KL identity on a possibly infinite ambient
    alphabet when finite-support theorem pressure appears; this is not
    immediate work. The current theorem
    `toReal_klDiv_pmf_uniformOfFinset` assumes `[Fintype alpha]`, although its
    mathematical data already include a finite nonempty finset `s` and the
    support condition `p.support ⊆ s`. Mathematically, those hypotheses should
    suffice even when the ambient type is infinite.

    A future proof could sum directly over `s` or restrict the PMF to the
    subtype determined by `s`, rather than invoking the current KL expansion
    over every element of the ambient `Fintype`. Preserve the existing finite
    theorem and its full-alphabet corollary until an infinite-ambient consumer
    establishes the right statement, ownership, and compatibility strategy.
    At that point, decide whether to generalize the existing declaration or
    add a compatibility-preserving theorem, and audit any new name under Future
    Work Note 14.

    Do not extract the pointwise logarithm calculation against a uniform PMF
    merely from the Step 6 proof, and do not add reverse-oriented or
    `ENNReal`-valued versions of the identity speculatively. Promote those
    forms only if later proofs repeat the calculation or naturally require a
    different codomain or rewrite orientation. The planned Chunk 2 example
    step already covers concrete sanity checks, so this note does not create a
    separate example task.

24. Revisit the Step 7 entropy-equality infrastructure only after an
    independent consumer creates proof or statement pressure; this is not
    immediate work. The strict-Jensen proof of
    `entropy_eq_log_card_iff_eq_uniformOfFintype` currently contains the only
    production equality-case setup that derives constant atom masses from
    `Real.strictConcaveOn_negMulLog.map_sum_eq_iff`. If a later entropy,
    conditional-entropy, or extremization theorem repeats that weighted-sum
    construction, extract a private helper in the bounds layer that states the
    mathematical constant-mass consequence. Do not expose the raw Jensen
    bookkeeping or add a public theorem merely to shorten the existing proof.

    Also monitor repeated use of the law
    `PMF.uniformOfFinset p.supportFinset p.supportFinset_nonempty`. If a second
    independent public theorem or the planned example pass needs that exact
    object, consider a canonical `PMF.uniformOnSupport` definition and use it
    to make support-uniformity statements easier to read. Before adding it,
    decide module ownership carefully: the lightweight
    `Probability.Finite` module should not acquire heavier uniform-distribution
    imports merely for notation, while `EntropyBounds` may own an opt-in PMF
    definition if that is where all consumers remain. Preserve the current
    theorem statements and add compatibility lemmas rather than renaming them
    during active development.

    Step 8 did not repeat the strict-Jensen argument or use a uniform-on-
    support object, so neither abstraction is yet justified. The shorter
    random-variable equality aliases are already tracked separately in Future
    Work Note 14 for the planned Step 17 API review and should not be duplicated
    here.

    Step 16 defines a concrete uniform law on a chosen two-point finset, but it
    does not need the canonical self-support expression
    `PMF.uniformOfFinset p.supportFinset p.supportFinset_nonempty` and does not
    repeat strict Jensen. It therefore supplies no new pressure for either
    abstraction.

25. Ordinary-independence proof-pressure note: add convenience theorems only
    when concrete downstream proofs need them. The primary design remains
    PMF-first: `IsIndependent` is
    equality with the independent product of the marginals, and
    `IsIndependentOf` applies that predicate to the mapped joint law. Do not
    redefine either predicate through mathlib
    `ProbabilityTheory.IndepFun`; doing so would force measurable-space and
    measurability assumptions into the basic distributional vocabulary. Keep
    those assumptions confined to the explicit semantic bridge, as recorded
    in Section 82, `foundation-conventions.md`, and the independence module
    documentation.

    If later atom-level random-variable proofs repeatedly unfold mapped laws,
    consider a theorem characterizing `IsIndependentOf p X Y` by
    `p.map (fun omega => (X omega, Y omega)) (a, b) =
      p.map X a * p.map Y b` for every `a` and `b`. Fix its name and exact
    orientation only after checking whether consumers prefer this PMF-mass
    statement or an event-probability form; audit any public name under Future
    Work Note 14.

    A related downstream convenience would compose
    `mutualInfo_eq_zero_iff_isIndependent` with
    `isIndependent_iff_apply_eq_mul_marginals` and state zero mutual
    information directly as pointwise joint-mass factorization. Consider that
    PMF corollary, and a random-variable form only if independently used, when
    proofs repeatedly perform this two-theorem composition. Do not add it only
    to duplicate an already short route through `IsIndependent`. If promoted,
    review a descriptive sketch such as
    `mutualInfo_eq_zero_iff_apply_eq_mul_marginals` under Future Work Note 14,
    since the name is long and exposes marginal representation details.

    Also let theorem pressure decide the ordinary closure and degeneration
    API: constant variables are independent of every variable, deterministic
    functions of independent variables remain independent, and a variable is
    independent of itself exactly in the appropriate almost-sure-constant or
    pure-law case. These facts are mathematically useful, but do not add all
    orientations or PMF/random-variable variants speculatively. Revisit them
    when the independence equality cases, conditional-independence layer,
    stochastic data processing, or later examples produce actual consumers.

    The compatibility alias for
    `isIndependentOf_iff_map_eq_indepProd` remains tracked solely in Future
    Work Note 14 for Step 17 and is not duplicated here.

    Step 13 used the existing ordinary pointwise-factorization theorem only to
    characterize independence of each conditional PMF. It did not need an
    atom-level `IsIndependentOf` theorem, ordinary closure under maps, constant-
    variable lemmas, or self-independence degeneration results. This note
    therefore remains deferred without a new public convenience declaration.

    Step 15 derives its equality cases from the public zero-CMI equivalences and
    entropy identities. It likewise supplies no pressure for an atom-level
    `IsIndependentOf` characterization or additional ordinary-independence
    closure and degeneration theorems.

    Step 16's examples exercise support-wise functional dependence,
    deterministic recovery, and KL support failure rather than ordinary
    independence. They create no consumer for the deferred convenience API.

    Chunk 3 Step 7 reuses `IsIndependent` only inside the positive conditional-
    fiber characterization of a Markov triple. It does not require an atom-level
    `IsIndependentOf` theorem, closure under maps, constant-variable lemmas, or
    self-independence degeneration results. This note therefore remains
    deferred without a new ordinary-independence convenience declaration.

    Chunk 3 Step 11 uses `indepProd` only to state the conditional output law
    of two independently applied channels. Its proof needs no new theorem about
    `IsIndependent`, closure under maps, constant variables, or degeneracy, so
    the ordinary-independence convenience API remains deferred.

    Chunk 3 Step 19's common-cause example reaches fiberwise independence
    through the public Markov characterization. It does not unfold ordinary
    mapped-law factorization or need closure, constant-variable, or degeneracy
    helpers, so no ordinary-independence convenience theorem is promoted.

26. Standing module-boundary guardrail: do not split
    `Shannon.SemanticBridge.Independence` preemptively. Chunk 2 Step 17
    reviewed its size and import boundary and retained the current module. The
    file combines elementary PMF and random-variable independence predicates
    with the mathlib
    `IndepFun` bridge, KL-based zero-MI equivalences, pair entropy equality cases,
    positive-fiber results, and conditional independence. This remains a
    coherent semantic independence layer, so file length alone does not
    justify splitting it.

    The Step 17 baseline is concrete: the source has 587 lines and the generated
    API index attributes 28 public declarations to it, consisting of four
    definitions and 24 theorems. It directly imports one project module,
    `Shannon.SemanticBridge.Theorems`, and one external mathlib module,
    `Mathlib.Probability.Independence.Basic`. Its only direct project importer
    is the aggregate `Shannon.SemanticBridge`, and the source-derived graph
    records it as outside the lightweight root. These figures are observations,
    not automatic splitting thresholds.

    Split only if downstream import cost, ownership, or maintenance pressure
    reveals a stable boundary. A plausible compatibility-preserving layout
    would keep predicates, elementary factorization, and symmetry in a light
    independence module, while a heavier equality/conditional module imports
    KL and owns zero-MI, zero-CMI, and entropy equality characterizations. Keep
    `Shannon.SemanticBridge.Independence` as an aggregate compatibility import
    if such a split occurs. Do not move declarations or change existing import
    paths during the review unless the benefit is concrete and the aggregate
    preserves current users.

    At the next module-pressure review, compare the baseline above with source
    size, indexed public-declaration count, direct local and external imports,
    reverse project importers, root reachability, and focused build duration.
    Also record qualitative pressure that counts cannot capture: whether light
    consumers need only predicates and elementary factorization, whether KL and
    entropy equality results force avoidable dependencies, whether private
    arguments are being repeated across ownership boundaries, and whether new
    stochastic-channel or Markov modules have established a stable downstream
    boundary. Growth in line or declaration count alone remains insufficient;
    split only when the metric comparison and actual consumers identify a
    coherent dependency or maintenance benefit.

    Chunk 3 Step 2 added the new opt-in
    `LeanInfoTheory.Probability.FiniteChannel` construction module. It imports
    only `Probability.Finite`, has no dependency on
    `SemanticBridge.Independence`, and is not imported by the lightweight root
    or any existing semantic module. It therefore creates no concrete reason
    to split the independence file. Reassess only when the Markov consumer
    arrives in Step 6 and during the scheduled Step 19 module review.

    Chunk 3 Step 3 added 21 type-generic atom, projection, algebra,
    deterministic-map, and support theorems in that same opt-in module. The
    theorem layer still imports only `Probability.Finite` and uses no
    independence declaration, so it supplies no new module-split pressure.
    The Step 6 and Step 19 reassessment points remain unchanged.

    Chunk 3 Step 4 created the downstream
    `Shannon.SemanticBridge.Markov` module, but its initial definition imports
    only `Probability.FiniteChannel` and `SemanticBridge.Conditional`. The
    semantic aggregate imports the new module; the module itself still does not
    depend on `SemanticBridge.Independence`. This is a clean ownership boundary,
    not yet evidence for splitting independence. Reassess the actual dependency
    cost when Step 6 adds the first Markov predicates and again in Step 19.

    Chunk 3 Step 5 added only branch, weighted atom, and pair-law reconstruction
    theorems to the same Markov module. Its imports remain
    `Probability.FiniteChannel` and `SemanticBridge.Conditional`; it still has
    no independence dependency. The planned Step 6 measurement remains the
    first meaningful split-pressure checkpoint.

    Chunk 3 Step 6 made `SemanticBridge.Markov` the second direct project
    importer of `SemanticBridge.Independence`, after the semantic aggregate.
    The independence source now has 649 lines and 30 public
    definitions/theorems, compared with the Step 17 baseline of 587 lines and
    28 declarations. The focused Markov build boundary rose from 2234 jobs in
    Step 5 to 2701 jobs after importing independence. This is a measured import
    cost, but it does not yet establish a useful stable split: Step 7
    immediately needs the same module's positive-fiber and zero-CMI
    characterizations, and the Markov module will own later MI theorems. Keep
    the current compatibility boundary and repeat the metric and ownership
    review in Step 19 rather than moving declarations now.

    Chunk 3 Step 7 confirms the Step 6 ownership decision. The Markov module
    directly reuses both the positive-fiber and zero-CMI characterizations from
    `SemanticBridge.Independence`, so moving only predicates and symmetry into
    a lighter submodule would not make the active consumer light. No private
    proof is duplicated across the boundary. Keep the current module layout and
    the scheduled Step 19 metric review.

    Chunk 3 Step 8 proves channel-generated Markov structure entirely through
    the Step 7 cross-product theorem and the lightweight finite-channel laws.
    It adds no new dependency on or duplicated proof from the independence
    module, so it creates no additional split pressure. The Step 19 review
    remains the next module-boundary checkpoint.

    Chunk 3 Step 9 directly consumes the zero-CMI theorem from
    `SemanticBridge.Independence` at both PMF and random-variable levels. This
    is further evidence that the active Markov module is intentionally a heavy
    semantic consumer rather than a stable predicate-only client. No proof is
    duplicated across the boundary; keep the current layout until Step 19.

    Chunk 3 Step 10 is another intentionally heavy semantic consumer: its
    inequality and equality theorems use the Markov chain rule,
    nonnegativity, and zero-CMI characterization from the current imported
    layers. It duplicates no independence proof and creates no lighter stable
    ownership boundary. Keep the current layout until the Step 19 review.

    Chunk 3 Step 11 remains inside the existing Markov semantic consumer and
    reuses its Step 10 DPI together with the lightweight channel laws. It adds
    no dependency to `SemanticBridge.Independence`, duplicates no semantic
    proof, and creates no stable lighter boundary. Keep the current layout
    until Step 19.

    Chunk 3 Step 12 composes the Markov module's own cross-product and total-
    conditional-channel layers and adds no import. Its canonical proof is the
    first direct consumer spanning those two sections, which supports their
    current shared ownership rather than revealing a stable split. Keep the
    module intact until the scheduled Step 19 size and dependency review.

    Chunk 3 Step 13 confirms the planned downstream boundary rather than a
    split of an existing file. Kernel conversion, posterior KL decomposition,
    contraction, and its immediate consequences will live in the new opt-in
    `Shannon.SemanticBridge.DataProcessing` module during Steps 14-18. It may
    import the existing Markov and KL layers, while neither those source files
    nor `SemanticBridge.Independence` should be split merely to support it. Add
    the new module to the semantic aggregate when its production bridge lands;
    keep it outside the lightweight root and revisit the full metrics in Step
    19.

    Chunk 3 Steps 14-15 establish the planned downstream module as a real
    consumer: `DataProcessing` now owns kernel conversion, total channel
    posteriors, PMF reconstruction, private KL relabeling, and exact posterior
    decomposition. This is coherent new ownership, not evidence for splitting
    `SemanticBridge.Independence` or `SemanticBridge.Markov`; the new module
    imports and composes their public results without duplicating them. Keep the
    current boundaries until the scheduled Step 19 metrics review.

    Chunk 3 Step 16 adds one private theorem in the existing data-processing
    owner and no import. It consumes the Step 15 public decomposition directly,
    creating no module-boundary or split pressure before the Step 19 review.

    Chunk 3 Step 17 adds the six public contraction statements to the same
    downstream data-processing owner. Their proofs reuse the private engine and
    lightweight finite-channel laws without duplicating Markov or independence
    semantics. This confirms the current opt-in boundary and creates no reason
    to split `SemanticBridge.Markov` or `SemanticBridge.Independence` before the
    scheduled Step 19 metrics review.

    Chunk 3 Step 18 adds only direct one-step consequences in the same
    data-processing owner. It reuses the public Step 17 contraction and the
    existing KL/uniform bridge without changing imports or duplicating upstream
    semantics. The module boundary remains coherent through the end of the
    theorem phase.

    During that Step 19 review, also reconsider the now-internal duplication
    between `klDiv_channel_le_aux` and the public `klDiv_channel_le`: the two
    declarations have identical statements, and the public theorem currently
    delegates to the private one. Preserve the helper if Step 18 creates a real
    internal consumer or if retaining a named contraction engine materially
    clarifies the posterior-decomposition proof boundary. Otherwise, consider
    moving the short proof directly into `klDiv_channel_le` and deleting the
    private wrapper. This is implementation cleanup only: do not change the
    public theorem statement, introduce a second proof route, or split the
    module merely to remove one private declaration. Include any measurable
    elaboration or build-time effect in the Step 19 module decision rather than
    assuming that fewer declarations automatically compile faster.

    Step 18 creates no internal consumer of `klDiv_channel_le_aux`; its
    invariant-reference theorem deliberately calls the public
    `klDiv_channel_le`. The Step 19 cleanup criterion above therefore now
    favors inlining the private wrapper unless measured elaboration or proof-
    boundary clarity gives a concrete reason to retain it.

    The Step 19 module review should record a concrete
    `SemanticBridge.DataProcessing` baseline before considering any split:
    source lines, public and private declaration counts, direct imports,
    reverse project importers, root reachability, and both clean and cached
    focused-build duration where practical. Distinguish transitive mathlib
    import cost from re-elaboration of the file's exact posterior-decomposition
    proof. If incremental build cost is genuinely concentrated there, evaluate
    a compatibility-preserving boundary in which kernel/posterior
    infrastructure owns the exact decomposition and a downstream contraction
    layer owns Steps 16-18. Preserve the current
    `Shannon.SemanticBridge.DataProcessing` import path as an aggregate, and do
    not split merely because one clean build is slow: the proposed boundary
    must improve repeated development or ownership without duplicating the KL
    engine or changing the lightweight root.

    Step 19 completed the metric review and retained every boundary.
    `Independence` has 654 source lines, 30 public declarations, no private
    declarations, two direct imports, and direct project importers `Markov` and
    the semantic aggregate. `Markov` has 691 lines, 32 public and two private
    declarations, two direct project imports, and direct importers
    `DataProcessing`, `Examples.CommonCause`, and the aggregate.
    `DataProcessing` has 454 lines, 19 public declarations (two definitions,
    one instance, and 16 theorems) and three private declarations, one project
    plus one external direct import, and direct importers
    `Examples.StochasticChannels` and the aggregate. None is reachable from
    `LeanInfoTheory.lean`.

    Source-triggered focused rebuilds reported 13 seconds for `Independence`,
    17 seconds for `Markov`, and 15 seconds for `DataProcessing`; cached builds
    measured approximately 3.6, 3.8, and 3.4 seconds. More importantly,
    `Markov` consumes both positive-fiber and zero-CMI independence results,
    while `DataProcessing` coherently owns the kernel, posterior, exact KL,
    contraction, and one-step consequence surfaces. No light consumer or
    repeated cross-boundary proof identifies a useful split. The duplicate
    private `klDiv_channel_le_aux` wrapper was therefore inlined into the
    unchanged public `klDiv_channel_le`; no module move was made.

    Chunk 4 Step 4 adds a coherent downstream boundary rather than splitting
    any existing module. `SemanticBridge.Sufficiency` imports only `Markov`,
    owns the fixed-prior predicate and its induced triple law, and remains
    upstream of `DataProcessing` and the planned `Sufficiency.KL` layer. The
    semantic aggregate imports it while the lightweight root does not. This
    creates no pressure to split `Independence` or `Markov`; reassess the new
    core's size and ownership only during the scheduled Chunk 4 Step 19 review.

    Chunk 4 Step 5 adds four short proofs in the same sufficiency owner and no
    import edge. Each theorem delegates to the existing Markov equality API;
    no independence or data-processing proof is duplicated across the boundary.
    The new core remains upstream of `DataProcessing` and the planned
    `Sufficiency.KL` module.

    Chunk 4 Step 8 makes `DataProcessing` a direct importer of `Sufficiency` so
    the existing posterior owner can state the supported common-posterior
    characterization without pulling kernel/KL imports into the core. It keeps
    the existing direct `Markov` import because the file independently consumes
    Markov and finite-channel declarations. This adds one local graph edge but
    no module, split, moved declaration, duplicated posterior, or root import.
    The core remains independently importable and upstream; reassess the direct
    dependency and measured elaboration cost during Chunk 4 Step 19 rather than
    creating a speculative posterior submodule now.

    Chunk 4 Step 9 adds one private hierarchical-law identification and four
    short public consequences to the existing sufficiency core. All four
    public proofs reuse the Markov API already owned upstream, and the file
    still imports only `Markov`; no posterior, kernel, KL, or data-processing
    implementation moves into the core. This is coherent growth rather than a
    new ownership boundary. Reassess size and measured import pressure at Step
    19 as planned, without splitting the module now. The separate one-theorem
    PMF conditional-entropy bridge belongs beside its random-variable theorem
    in `Markov` and creates no split pressure there either.

    Chunk 4 Step 10 adds four public characterizations and two private proof
    bridges to the existing sufficiency core, which still imports only
    `Markov`. The converse uses the already-owned Markov factorization theorem
    and atomwise PMF cancellation; no posterior, kernel, or KL dependency moves
    upstream. The pressured deterministic graph law belongs in the type-
    generic finite-channel core and replaces Step 2's duplicated local proof.
    This remains a coherent boundary; defer any split or move until Step 19's
    measured review.

    Chunk 4 Step 11 compiled one consumer importing only `Sufficiency` and a
    second importing `DataProcessing`. The core consumer could state and prove
    exact recovery, non-recovery, and every-prior facts without kernel or KL
    dependencies; only the posterior-support test needed the downstream
    module. A root-only negative probe still rejected the sufficiency API.
    These concrete consumers support the present ownership boundary and create
    no reason to split or move declarations before Step 19.

    Chunk 4 Step 12 keeps Fisher-Neyman factorization in the same lightweight
    sufficiency owner. Its proof uses only PMF atoms, finite sums,
    `PMF.normalize`, and the existing exact recovery definition; all fiber
    machinery is private and the module still imports only `Markov`. The
    standalone consumer needs no `DataProcessing` or KL import. This is
    coherent core growth, not pressure for a new normalization module or an
    early split; retain the boundary until Step 19's measured review.

    Chunk 4 Step 13 adds the focused external
    `Mathlib.Probability.Kernel.CompProdEqIff` import only to the existing
    `DataProcessing` owner. The measure-level equality theorem reuses that
    module's posterior and exact KL decomposition, while `Sufficiency` still
    imports only `Markov` and the root remains unchanged. This is the planned
    downstream analytic boundary, not evidence for a split or module move;
    it was retained for Step 14, with measured costs still assigned to Step 19.

    Chunk 4 Step 14 adds two short wrappers in the same `DataProcessing` owner
    and no import edge. Both consume the existing measure-level theorem and
    PMF joint bridge; no kernel or KL dependency moves into `Sufficiency` or
    the root. The planned downstream boundary remains coherent for Step 15.

    Chunk 4 Step 15 creates the planned downstream
    `SemanticBridge.Sufficiency.KL` boundary. The new module imports only
    `DataProcessing`, contributes one public recovery/KL theorem and one
    private projection helper, and is imported by the semantic aggregate but
    not by the sufficiency core or root. This cleanly isolates analytic
    integration rather than creating pressure to split `Sufficiency`,
    `DataProcessing`, `Markov`, or `Independence`; retain the measured review
    for Step 19.

    Chunk 4 Step 16 keeps all analytic equality/recovery results in
    `Sufficiency.KL`. The only ownership change is the pressure-justified
    promotion of the assumption-free
    `PMF.channelJoint_eq_iff_eq_on_support` theorem from a private
    `DataProcessing` helper to `Probability.FiniteChannel`, where its raw PMF
    contract belongs. `DataProcessing` and the downstream KL module now share
    that lightweight theorem without duplicating cancellation. No new import
    edge or root reachability appears, so the broader module boundaries remain
    coherent pending Step 19's measured review.

    Chunk 4 Step 17 adds four short family wrappers in the existing
    `Sufficiency.KL` owner and no import edge. The proofs compose the lightweight
    family predicates with the downstream Step 15-16 recovery theorems; no KL
    declaration moves into `Sufficiency`, and no posterior or kernel machinery
    is duplicated. The current module boundary remains coherent for the Step
    18 consumers and scheduled Step 19 review.

    Chunk 4 Step 18 adds one downstream example module importing
    `Sufficiency.KL` and one aggregate import edge. It places no example,
    recovery proof, KL theorem, posterior construction, or normalization helper
    in the core modules. The positive and root-isolation consumers support the
    existing ownership boundary; measured final review remains Step 19 work.

    Chunk 4 Step 19 completed that measured review and retained every boundary.
    `Sufficiency` now has 778 source lines, 20 public and 11 private
    declarations, imports only `Markov`, and has direct importers
    `DataProcessing` and the semantic aggregate. `DataProcessing` has 611
    lines, 23 public and four private declarations, directly imports `Markov`,
    `Sufficiency`, and two focused external KL/kernel modules, and has direct
    importers `Sufficiency.KL`, `Examples.StochasticChannels`, and the
    aggregate. `Sufficiency.KL` has 308 lines, nine public and two private
    declarations, imports only `DataProcessing`, and has direct importers
    `Examples.SufficientStatistics` and the aggregate. None is root-reachable.

    Source-triggered focused builds reported 40, 38, and 36 seconds for the
    three modules, while cached invocations were about eight seconds. More
    importantly, a core-only consumer needs no posterior or KL import, the
    posterior and measure equality engine has one coherent owner, and the
    downstream recovery/KL layer adds no duplicate proof. No light consumer,
    repeated cross-boundary argument, or measured iteration cost identifies a
    useful compatibility split or declaration move.

27. Conditional-independence ergonomics remains proof-pressure deferred after
    the completed Chunk 3 review. That review added the separately importable
    nontrivial common-cause example and expanded the zero-CMI doc comment to
    explain the null-fiber contract. The remaining symmetry, closure,
    right-oriented entropy-equality, conditional-marginal-helper, and
    representation-convenience questions below should move only when their
    concrete consumer triggers are met.

    Let theorem pressure determine the symmetry and closure API. Conditional
    independence is symmetric in its first two variables, and a PMF coordinate-
    swap theorem plus an `IsCondIndependentOf` variable-swap theorem will likely
    become useful during Markov or data-processing work. Do not add every PMF,
    mapped-law, and closure orientation preemptively; promote only the forms
    used by those proofs, and audit their names under Future Work Note 14.
    Once that symmetry API has a real consumer, also check whether users need
    the right-oriented equality
    `H(B|A,C) = H(B|C)` iff conditional independence, with PMF and random-
    variable forms chosen together. Do not add it merely to mirror the Step 15
    left-oriented theorem.

    Also monitor the two conditional-marginal scaling calculations currently
    local to `isCondIndependent_iff_isIndependent_condFstSndGivenThird`. If a
    second production proof repeats the identities recovering the `(A,C)` and
    `(B,C)` marginal masses from positive conditional fibers, extract coherent
    private helpers in the owning semantic module. One consumer does not yet
    justify either public declarations or additional API surface.

    Chunk 3 Steps 3-5 did not import or consume conditional independence: the
    channel laws close at the raw PMF level, and the total conditional-channel
    reconstruction uses only the canonical positive-fiber conditional PMF and
    zero-marginal atom facts. They therefore do not trigger symmetry, closure,
    right-oriented entropy equality, or conditional-marginal helper work. Step
    6 is now the first concrete Markov consumer; add only the symmetry form its
    proofs actually require, then reassess the remaining items in Step 7.

    Chunk 3 Step 6 promoted exactly that narrow symmetry API:
    `[simp] isCondIndependent_map_swap12` removes an explicit first-two-
    coordinate map, while `isCondIndependentOf_swap` gives the corresponding
    variable-level equivalence as an explicit rewrite. No other orientation or
    closure theorem was added. The step did not repeat either positive-fiber
    conditional-marginal scaling calculation and supplied no consumer for the
    right-oriented conditional-entropy equality. Reassess those two deferred
    items only if the Step 7 characterizations create actual proof pressure;
    the separately importable example remains scheduled for Step 19.

    Chunk 3 Step 7 uses the Step 6 symmetry exactly once to prove chain
    reversal. Its positive-fiber theorem specializes
    `isCondIndependent_iff_isIndependent_condFstSndGivenThird` directly and
    does not repeat either conditional-marginal scaling calculation. Neither
    the reversal proof nor the zero-CMI wrapper needs the right-oriented
    conditional-entropy equality, so that theorem remains deferred despite the
    first real symmetry consumer. No additional conditional-independence
    closure orientation was added. Reassess only under later proof pressure;
    the common-cause example remains Step 19 work.

    Chunk 3 Step 8 proves `isMarkovChain_channelExtension` through the Markov
    cross-product characterization. It does not invoke a positive conditional
    fiber, repeat either conditional-marginal scaling identity, or need a new
    conditional-independence closure orientation. The right-oriented entropy
    equality and common-cause example therefore remain deferred to their
    existing proof-pressure and Step 19 triggers.

    Chunk 3 Step 9 uses only the public zero-CMI Markov equivalence and the two
    ordinary MI chain rules. It needs no additional conditional-independence
    symmetry or closure form, does not repeat the conditional-marginal scaling
    calculations, and creates no use for the right-oriented conditional-
    entropy equality. The existing deferred triggers remain unchanged.

    Chunk 3 Step 10 derives the conditional-entropy consequence from the
    mutual-information identity and ordered-group cancellation, rather than
    adding the deferred right-oriented conditional-independence equality. Its
    equality case uses the existing zero-CMI Markov equivalence directly. It
    repeats no positive-fiber scaling calculation and needs no new symmetry or
    closure theorem, so the remaining triggers stay deferred.

    Chunk 3 Step 11 derives every channel contraction from the public Markov
    theorem and channel-construction laws. The left-coordinate proof uses
    ordinary mutual-information swap and PMF map/bind algebra, not another
    conditional-independence coordinate transport; it therefore does not
    repeat the three-marginal bookkeeping tracked below. No new closure,
    right-oriented entropy equality, or fiber helper is justified.

    Chunk 3 Step 12 uses the public Markov cross-product characterization and
    the total conditional-channel atom law directly. Its one local equality of
    the two middle-coordinate marginal maps and its null-fiber support transport
    are specific to the canonical channel factorization; they do not repeat the
    conditional-fiber scaling or endpoint-relabeling proofs tracked here. No new
    conditional-independence closure, right-oriented entropy equality, public
    marginal helper, or relabeling theorem is justified.

    During Step 15, watch specifically for a second production use of either
    the equality between the two representations of the Markov middle marginal
    or the canonical converse's null-fiber support transport. If either repeats,
    first extract a coherent private helper in the owning semantic module.
    Promote a public theorem only after multiple downstream consumers establish
    genuine API pressure, and audit any resulting name under Note 14.

    Chunk 3 Step 14 performs only PMF-channel-to-kernel conversion and a joint-
    measure equality. It invokes neither middle-marginal representation nor
    null-fiber support transport, so neither Step 15 trigger has fired.

    Chunk 3 Step 15 also avoids both watched Step 12 arguments. Its posterior
    reconstruction uses `PMF.channelJoint_map_snd` and
    `channelJoint_condFstGivenSndChannel` directly, rather than comparing two
    triple middle-marginal representations or transporting support through a
    null Markov fiber. No private or public helper extraction is justified.

    Chunk 3 Step 16 rewrites only with the public posterior decomposition and
    uses order-theoretic nonnegativity. It does not revisit either watched Step
    12 argument, so no helper extraction is justified.

    The Step 6 proof of `isCondIndependent_map_swap12` manually transports the
    triple mass and three relevant marginals through one endpoint swap. Do not
    generalize that proof merely because other coordinate maps exist. If a
    second production proof repeats the same mapped-marginal bookkeeping,
    consider a coherent relabeling theorem for bijections applied separately
    to the two endpoint alphabets and the conditioning alphabet. Distinguish
    such bijective relabeling from arbitrary permutations that move the
    conditioning coordinate: conditional independence is not invariant under
    changing which variable is conditioned on. Before promoting a public
    theorem, decide whether the actual consumers need only endpoint symmetry,
    independent coordinate equivalences, or a private transport helper; keep
    ownership in `SemanticBridge.Independence` and audit the resulting name
    under Future Work Note 14. The existing swap theorem and its Step 7 reversal
    consumer do not yet meet this trigger.

    Two Step 7 convenience surfaces remain deliberately absent. First, do not
    introduce a new Markov-specific conditional-endpoint-law definition merely
    to hide the current mapped law
    `p.map fun x => (x.1, x.2.2, x.2.1)` in
    `isMarkovChain_iff_isIndependent_condFstSndGivenThird`. The existing
    `condFstSndGivenThird` API already gives the precise positive-fiber object,
    and the mapped order keeps the conditioning coordinate explicit. Revisit a
    named endpoint-given-middle law only if at least two downstream theorem
    statements or examples repeatedly construct this map and the representation
    materially obscures their mathematical contracts. At that point, decide
    whether a definition, a notation-free theorem alias, or a private helper is
    the smallest solution; preserve the positive-fiber guard and do not assign
    conditional semantics to null fibers.

    Second, do not add a PMF-only zero-CMI wrapper speculatively. A possible
    statement would identify zero conditional mutual information of the
    endpoint-endpoint-middle mapped law with `IsMarkovChain p`, but that form is
    representation-facing and is already an immediate specialization of
    `condMutualInfoOf_eq_zero_iff_isMarkovChainOf`. Step 9 contains the first
    production specialization when proving the PMF Markov chain rule. Promote
    a direct PMF theorem only if a second independent PMF consumer repeats the
    same coordinate specialization or the mapped-law conversion becomes a
    persistent usability problem. Choose its orientation and name together
    with any endpoint-law vocabulary, and record the public-name decision under
    Future Work Note 14.

    Step 8 deliberately publishes only the general
    `isMarkovChain_channelExtension` constructor theorem. Its specialization
    to a two-channel cascade,
    `PMF.channelExtension (PMF.channelJoint p W) V`, and its deterministic-
    channel instances are already immediate simp consequences. Do not add
    named cascade or deterministic Markov theorems merely to restate those
    specializations. Revisit a cascade alias only if at least two production
    theorem statements repeatedly expose the nested constructors and a named
    result materially improves theorem search or public documentation. A
    deterministic specialization should require independent pressure beyond
    that cascade use, since `PMF.deterministicChannel` already reduces through
    the general theorem.

    Also defer a random-variable/channel coupling form of the generated-Markov
    theorem. Add one only when downstream applications naturally begin with a
    source PMF and random variables or stochastic outputs that cannot be stated
    cleanly through the existing pair law and `PMF.channelExtension`. Before
    fixing such a statement, decide whether its coupling is represented by
    `PMF.channelJoint`, an explicit mapped source law, or later kernel
    infrastructure; do not introduce a bundled channel or coupling structure
    solely for this convenience. Keep the general PMF constructor theorem as
    the primary result and audit any additional public name under Future Work
    Note 14.

    Step 19 completes the requested common-cause review. The separately
    importable `Examples.CommonCause` model has a fair binary cause and two
    genuinely noisy children. It exercises `IsCondIndependentOf`, the
    positive-fiber endpoint theorem, the zero-CMI equivalence, and both
    canonical and existential channel-factorization surfaces. The core zero-
    CMI doc comment now explains the null-fiber contract explicitly.

    The example needed no new closure theorem, right-oriented conditional-
    entropy equality, conditional-marginal scaling helper, endpoint-law
    definition, PMF-only zero-CMI wrapper, cascade constructor theorem, or
    random-variable coupling layer. The common-cause example itself is now
    complete; those narrower consumer-triggered questions remain deferred.

    Chunk 4 Step 9's family zero-CMI corollary does not provide the second
    consumer for the deferred Markov-specific PMF wrapper. Its reverse-chain
    hypothesis unfolds to ordinary conditional independence of the generated
    law, so the proof calls the existing
    `condMutualInfo_eq_zero_iff_isCondIndependent` directly. No endpoint-law
    map or repeated Markov coordinate specialization remains in the production
    proof, and this note's wrapper trigger is still unmet.

    Chunk 4 Step 10 uses the existential Markov factorization theorem directly
    on a privately swapped generated law. The new public deterministic-
    extension theorem reduces a channel constructor to its graph pushforward;
    it is not a named deterministic Markov specialization, endpoint-law
    abstraction, PMF zero-CMI wrapper, or random-variable coupling layer. None
    of this note's remaining convenience triggers is met.

    Chunk 4 Step 11 exercised the public sufficiency and posterior contracts
    directly. Its temporary proofs needed no new conditional-independence
    symmetry, closure, endpoint-law wrapper, deterministic Markov
    specialization, or random-variable/channel coupling theorem. The probes
    were deleted, so this note remains proof-pressure deferred unchanged.

    Chunk 4 Step 12 derives Fisher-Neyman factorization directly from exact
    recovery and reconstructs recovery from normalized factors. It does not
    invoke conditional independence, mapped endpoint laws, or Markov closure,
    and therefore creates none of this note's deferred convenience pressure.

    Chunk 4 Step 18 consumes the sufficiency characterizations as finished
    public APIs. Its examples need no new conditional-independence symmetry,
    closure, endpoint-law wrapper, deterministic Markov specialization, or
    random-variable/channel coupling theorem, so this note remains deferred.

    Chunk 4 Step 19's API consumer and documentation review likewise use the
    existing public surfaces directly. They reveal no repeated unfolding,
    endpoint-law, closure, deterministic-Markov, or coupling friction, so every
    remaining convenience in this note stays proof-pressure deferred.

28. Strengthen the pedagogy of the Step 16 side-information example during a
    later example-polish pass; this is not immediate work, and the current
    `recoveryLaw` example is correct. Preserve its public declarations rather
    than changing their meanings in place. Add a second construction with two
    independent uniform bits, represented by a source outcome `(Z,W)` under
    `PMF.uniformOfFintype (Bool × Bool)`, and use

    - `X (z,w) = (z,w)`;
    - deterministic processing `f = Prod.snd`, which retains only `W`;
    - side information `Z = Prod.fst`;
    - decoder `g (w,z) = (z,w)`.

    The example should prove three separate facts through the public API:
    processing loses ordinary entropy because `Prod.snd` is not injective on
    the full support of the `X` law; `(f(X),Z)` recovers `X` on that support, so
    `condEntropyOf_comp_eq_iff_exists_recovery` gives
    `H(f(X)|Z) = H(X|Z)`; and the common conditional entropy is positive,
    ideally computed as `log 2`. The last fact distinguishes the example from
    the existing valid but degenerate `0 = 0` conditional-entropy equality.
    Keep the new example in `Examples.SupportSensitive`, outside the root, and
    do not promote new core lemmas unless its proof reveals repeated pressure.

    In the same low-priority polish pass, improve the readability of
    `Examples.KLTop` by opening the appropriate `MeasureTheory` notation scope
    and using `μ ≪ ν` in the absolute-continuity statements instead of spelling
    out `MeasureTheory.Measure.AbsolutelyContinuous`. This should be notation-
    only source cleanup: preserve theorem names, elaborated statements, local
    measurable-space choices, and module imports. Re-run the two focused
    example builds, a fresh consumer import smoke test, and generated-reference
    checks if this cleanup is made.

29. The next dependency-ordered Project B sequence after the completed Chunk 3
    is sufficient statistics followed by Fano, each in its own focused phase
    rather than as an extension of the channel and data-processing chunk. The
    sufficient-statistic phase should start from Chunk 3's equality case for
    mutual-information data processing
    and then settle the representation of a statistic, parameter/prior law,
    reverse Markov condition, and recovery map or channel. Revisit a support-
    guarded equality characterization for KL data processing in that phase,
    where posterior equality and recovery have genuine consumers; do not force
    that API into Chunk 3 merely because its KL proof may expose posterior
    bookkeeping.

    The revised 20-step Chunk 4 plan was locked on July 16, 2026. It uses exact
    full-joint recovery as the family-level contract, treats deterministic
    statistics as special channels, and connects one common recovery channel
    to every-prior reverse Markov, zero-CMI, mutual-information preservation,
    and conditional-entropy preservation. The lightweight sufficiency core is
    kept upstream of a separate KL integration module. A midpoint consumer
    review must reject marginal-only recovery as too weak before the Fisher-
    Neyman and guarded KL-equality layers are accepted. Fano remains a separate
    later phase after this recovery API is stable.

    Chunk 4 Step 1 has now validated that contract in temporary Lean. The
    family law uses one common channel reconstructing every complete swapped
    input-output joint law. A full-support prior and the existing Markov
    factorization converse recover that common channel after positive prior-
    mass cancellation. The same checkpoint validated the support-guarded KL
    posterior-equality route and finite Fisher normalization, while the Boolean
    counterexample formally rejected marginal-only recovery. No production
    sufficiency declaration was introduced before Step 2.

    Chunk 4 Step 2 now supplies the type-generic deterministic forward chain
    `Theta -> X -> T(X)` as `isMarkovChainOf_comp`. It adds no finiteness,
    support, or measurability assumptions and no PMF wrapper. This establishes
    the forward half that the fixed-prior equivalence band will reuse; the
    reverse-chain sufficiency and recovery contracts remain assigned to later
    Chunk 4 steps.

    Chunk 4 Step 3 now supplies the entropy-facing equality corollary
    `condEntropyOf_dataProcessing_eq_iff`. Combined with Step 2, its temporary
    consumer proves exactly that `H(Theta|X) = H(Theta|T(X))` iff
    `Theta -> T(X) -> X`. This closes the prerequisite for the fixed-prior
    entropy equivalence in Step 5 without defining sufficiency early; the core
    predicate and module remain Step 4 work.

    Chunk 4 Step 4 now defines that core as the Markov-only opt-in module
    `SemanticBridge.Sufficiency`, with `IsSufficientStatisticOf` and the single
    induced law `statisticTripleLawOf`. The Step 5 MI and entropy contracts were
    validated in a temporary consumer. A premature direct `rw` formulation of
    the Step 6 recovery equivalence exceeded the local timeout, so Step 6 should
    use an explicit intermediate triple law or directional factorization
    applications; Step 1's clean spike still validates the theorem contract.
    No recovery or family definition was added early.

    Chunk 4 Step 5 completes the fixed-prior equivalence band inside that core.
    Zero CMI is inherited from the reverse Markov condition; MI and conditional
    entropy preservation reuse the deterministic forward chain and the existing
    equality theorems. No support condition, recovery witness, family-level
    predicate, or KL-facing API was introduced. The complete-law recovery
    characterization remains precisely Step 6 work.

    Chunk 4 Step 6 now proves that complete-law recovery characterization. One
    channel from statistic values to observations reconstructs the entire
    parameter-statistic-observation law exactly, and only `[Finite alpha]` is
    required. Projecting that equation yields observation-marginal recovery in
    the sufficient-to-recover direction only; the false converse remains
    rejected. The induced-law and first-two-marginal bridges remain private,
    preserving the lightweight core's public representation boundary. Family-
    level common recovery remains precisely Step 7 work.

    Chunk 4 Step 7 now fixes that family-level contract as
    `IsSufficientChannel`: one recovery channel is shared across every model
    parameter and reconstructs each complete swapped input-output joint law.
    `IsSufficientStatistic` is exactly the deterministic-channel specialization.
    Both definitions are assumption-free and introduce no bundled experiment
    or auxiliary family law. The supported-output common-posterior
    characterization remains precisely Step 8 work.

    Chunk 4 Step 8 now supplies that characterization in the existing
    `DataProcessing` posterior owner. One common posterior agrees pointwise
    with every model posterior only on that model's supported output atoms;
    total-posterior null-fiber fallbacks remain unconstrained. The theorem uses
    `[Fintype alpha]` and no parameter/output finiteness, while a private
    support-identifiability lemma prevents representation machinery from
    entering the public API. The core adds only the identity-statistic sanity
    law. Deriving every-prior Markov and information-preservation consequences
    from common family recovery remains precisely Step 9 work.

    Chunk 4 Step 9 now derives those every-prior consequences. A private
    atomwise identification turns the generated parameter-input-output law,
    after swapping its last two coordinates, into a channel extension through
    the common recovery channel. Existing Markov and equality APIs then give
    reverse Markov structure without finiteness and zero CMI, mutual-
    information preservation, and conditional-entropy preservation for finite
    alphabets. No public experiment-law constructor, posterior theorem, or KL
    dependency was added. The conditional-entropy corollary supplies the first
    independent PMF consumer requested by Note 33, so the direct PMF equality
    characterization now lives beside its random-variable counterpart. The
    finite full-support-prior converse remains precisely Step 10 work.

    Chunk 4 Step 10 now completes that converse. One full-support prior and the
    existing existential Markov factorization produce a common recovery
    channel after atomwise cancellation; only `[Finite alpha]` is needed. A
    locally enumerated uniform prior then yields channel and deterministic-
    statistic characterizations quantified over every prior under
    `[Finite theta] [Nonempty theta]`. The generated experiment law remains
    inline/private, and no metric-by-metric all-priors iff family or bundled
    statistical experiment was added.

    Chunk 4 Step 11 now completes the required midpoint gate. Temporary public-
    API consumers prove a genuinely noninjective statistic sufficient, a
    constant statistic non-sufficient, and marginal recovery insufficient for
    full-joint recovery. The posterior consumer shows that the supported-output
    guard is essential: the total posterior on an individual model's null
    output can disagree with the common posterior fixed by another model. Core
    versus KL ownership and negative root isolation remain intact, all probes
    were deleted, and no production API was changed. The recovery contract is
    therefore stable enough for Step 12's finite Fisher-Neyman factorization.

    Chunk 4 Step 12 now completes that factorization. Exact common recovery
    yields finite `ENNReal` factors directly, and finite fiber normalization
    reconstructs one common recovery channel in the converse. The public
    theorem needs only `[Finite alpha] [Nonempty alpha]`; all normalizer and
    zero-fiber fallback machinery remains private in the lightweight core. A
    noninjective standalone consumer validates both directions. Step 13 can now
    begin the separately owned measure-level KL equality engine without
    changing the sufficiency representation.

    Chunk 4 Step 13 now supplies that measure-level engine as
    `klDiv_channel_eq_iff_posterior_ae_eq`. Under input support inclusion, the
    exact posterior remainder vanishes exactly when the two posterior kernels
    agree almost everywhere under the first output law. The theorem remains in
    `DataProcessing`, adds no recovery interpretation to the lightweight core,
    and leaves the finite pointwise and real-valued contracts for Step 14.

    Chunk 4 Step 14 now completes those finite-facing contracts. The primary
    theorem states equality of posterior PMFs exactly on
    `(p.bind W).support`, and the guarded real theorem has the same criterion.
    The lower-level almost-everywhere theorem remains public and unchanged.
    Recovery-channel interpretation is still reserved for the downstream
    `Sufficiency.KL` work in Steps 15-17.

    Chunk 4 Step 15 now supplies the forward two-law recovery interpretation:
    one common exact recovery channel preserves `ENNReal` KL divergence by
    applying data processing in both directions. It adds neither a converse
    nor the model-family wrapper. The support-guarded converse remains Step 16,
    and Step 17 still owns the careful passage from pairwise laws to
    `IsSufficientChannel` without claiming a global recovery channel from
    unrelated pairwise equalities.

    Chunk 4 Step 16 now completes the guarded two-law equality theorem for
    channels and deterministic statistics in both `ENNReal` and real forms.
    Input support inclusion excludes `top = top`, posterior equality constructs
    one shared exact recovery witness, and the unconditional Step 15 theorem
    supplies the reverse implication. The result remains pairwise: Step 17 must
    derive family consequences from an already common family recovery channel
    and must not infer one global witness from independently chosen pairwise
    witnesses.

    Chunk 4 Step 17 now performs that integration without crossing the stated
    boundary. One recovery channel already shared by an
    `IsSufficientChannel` family preserves `ENNReal` KL divergence for every
    pair of its laws, with a deterministic-statistic specialization. Conversely,
    one support-guarded equality characterizes a `Bool`-indexed family because
    the Step 16 witness recovers both possible laws and therefore the entire
    family. No assertion is made that separate equality witnesses for pairs in
    a larger family can be chosen coherently. The canonical family result stays
    `ENNReal`-valued; real wrappers remain consumer-deferred.

    Chunk 4 Step 18 now makes the midpoint tests permanent in the opt-in
    `Examples.SufficientStatistics` module. The ancillary-noise model is
    genuinely noninjective on positive support yet sufficient; the constant
    statistic is not sufficient; and the reset channel recovers only a marginal,
    not the complete graph law. The module also consumes the fixed-prior,
    family, exact-recovery, all-prior, Fisher-Neyman, and KL-equality APIs. It
    introduces no canonical/minimal statistic, iid model, measurable extension,
    Fano theorem, or alternative recovery contract. The examples therefore
    validate the planned finite boundary and leave Step 19 as the scheduled API
    and documentation review.

    During the scheduled Chunk 4 Step 19 API and documentation review, perform
    a documentation-only polish pass over the Step 4 core definitions and the
    Step 6-8 recovery and posterior sections unless their comments have already
    been improved:

    - expand `statisticTripleLawOf` to explain that the
      `(parameter, statistic, observation)` coordinate order is intentional and
      supports later recovery from statistic values to observations and the
      associated channel-factorization statements;
    - expand `IsSufficientStatisticOf` to state explicitly that the reverse
      chain means `Theta ⟂ X | T(X)`, and distinguish this fixed-source-law or
      fixed-prior predicate from the later model-family/all-priors notion
      `IsSufficientStatistic`.

    For the Step 6 `## Fixed-prior recovery` section and
    `isSufficientStatisticOf_iff_exists_recovery`, add a compact textbook-facing
    explanation with `S = T(X)` that records all of the following:

    - the complete-law equation is the channel factorization
      `P_(Theta,S,X) = P_(Theta,S) R`, atomwise
      `P(theta,s,x) = P(theta,s) * R s x`;
    - one `R : beta -> PMF alpha` is shared across parameter values and cannot
      inspect `theta`, although it may depend on the fixed joint law
      `(p, Theta, X, T)`;
    - values of `R s` on null statistic fibers are unconstrained because the
      parameter-statistic law gives those fibers zero weight;
    - full-joint reconstruction preserves the parameter-observation coupling
      and is strictly stronger than the one-way marginal consequence
      `P_X = P_S R`, whose converse is false.

    For the Step 7 `## Family-level sufficiency` section and the controlled
    definitions `IsSufficientChannel` and `IsSufficientStatistic`, add a
    documentation-only family-level explanation informed by the already
    completed Steps 8 and 16:

    - writing `P_t = model t`, state the atomwise full-joint recovery equation
      `((P_t.bind W) b) * R b a = P_t a * W a b`;
    - emphasize the quantifier order `exists R, forall t`: one recovery channel
      is shared by the whole model family, rather than choosing a separate
      witness for each parameter value;
    - contrast this prior-free model-family notion with the fixed-prior
      predicate `IsSufficientStatisticOf`;
    - explain that full-joint recovery preserves the actual input-output
      coupling and is stronger than recovery of the input marginal alone;
    - using Step 8's supported-posterior theorem, explain that a null output for
      one model imposes no constraint on `R b` from that model, while another
      model supporting the same output may constrain that same recovery row;
    - explain that `IsSufficientStatistic` is exactly the deterministic-channel
      specialization of `IsSufficientChannel`, not a second sufficiency notion.

    For the Step 8 theorem
    `isSufficientChannel_iff_exists_common_posterior` in `DataProcessing`, expand
    its documentation without changing its contract:

    - writing `Q_t = (model t).bind W`, state that one parameter-independent
      posterior channel `R` satisfies
      `channelPosterior (model t) W b = R b` whenever `Q_t b != 0`;
    - spell out the overlapping-support consequence: if the same output `b` is
      supported under two model parameters, their posterior input laws at `b`
      coincide because both equal the same `R b`;
    - distinguish an output that is null for one model from an output that is
      null for the entire family: the former model imposes no condition at that
      fiber, although another supporting model may still determine `R b`, while
      the latter leaves `R b` wholly unconstrained;
    - explain that the support guard prevents the arbitrary total-posterior
      fallback on a null fiber from acquiring conditional-probability meaning;
    - retain `[Fintype alpha]` as the existing `channelPosterior` construction's
      contract and do not add parameter- or output-alphabet finiteness.

    For the Step 9 every-prior consequence band, use the permanent Step 18
    examples during the Step 19 documentation review to decide whether one
    concise section or theorem comment should identify the generated law
    `PMF.channelExtension (PMF.channelJoint prior model) W` as having coordinate
    order `(parameter, input, output)`. If added, spell out only the reader-facing
    projection convention `z.1 = parameter`, `z.2.1 = input`, and
    `z.2.2 = output`, so the reverse-chain statement can be read as
    `parameter -> output -> input`. Keep this documentary and do not expose the
    private coordinate-swap helper, introduce a second experiment-law
    constructor, or change any Step 9 theorem statement. Omit the extra comment
    if the improved Step 7 family-level documentation and permanent examples
    already make the coordinate convention unambiguous.

    For the Step 10 full-support and all-priors characterization band, use the
    Step 18 examples during the Step 19 documentation review to decide whether
    a compact section comment should expose the converse's textbook
    cancellation argument. If useful, state that reverse-Markov factorization
    under a full-support prior gives
    `prior t * (P_t a * W a b) = prior t * (Q_t b * R b a)`, and that
    `prior t != 0` permits cancellation to obtain one recovery equation for
    every parameter value. Explain that full support is substantive: a
    zero-prior parameter is invisible to the generated joint law and therefore
    cannot be constrained by its Markov property. Also mention that the finite
    nonempty all-priors converse needs only the canonical uniform prior from
    the universal hypothesis. Keep this documentary; do not change the four
    Step 10 theorem statements, introduce a new full-support predicate or
    experiment-law wrapper, add metric-by-metric all-priors equivalences, or
    alter the explicit simp policy. Omit a separate Step 10 comment if the
    improved family-level documentation already communicates these points
    clearly without duplication.

    For the Step 12 Fisher-Neyman theorem, use its permanent Step 18 consumer
    during the Step 19 documentation review to clarify the two finite-factor
    conditions without changing the theorem. State that pointwise finiteness of
    the parameter-independent factor `h` makes each finite fiber mass
    `sum_{a : T a = b} h a` finite and therefore permits normalization on a
    positive fiber. State separately that pointwise finiteness of `g` rules out
    pathological `top`-valued factor witnesses and matches the canonical
    forward witness `g t b = (model t).map T b`, whose values are PMF atoms;
    it is not the condition used to normalize the recovery row. Preserve the
    current finite-`g` contract even though the converse proof's normalization
    calculation principally consumes finiteness of `h`. Do not add a weaker
    companion theorem, real-valued duplicate, public factorization predicate,
    or public fiber-normalization helper without later consumer pressure. Keep
    the theorem explicit, and leave its compatibility-alias decision to Future
    Work Note 14 after the permanent example tests discovery.

    Keep this pass strictly documentary: preserve the Step 4, Step 6, and Step 7
    definitions, their names, the Step 8 theorem contract, all recovery theorem
    statements and proofs, module ownership, and import boundary. Do not replace
    exact recovery with a posterior-equality, marginal-recovery, or all-priors
    definition, and do not add an alias, wrapper, bundled experiment, recovery
    predicate, canonical posterior/recovery channel, public marginal helper, or
    posterior dependency. The Step 8 naming question remains owned by Future
    Work Note 14 rather than this documentation checklist. If the comments are
    improved before Step 19, close the corresponding items as completed rather
    than carrying stale documentation tasks forward.

    Chunk 4 Step 19 completed this documentation checklist in the source.
    `statisticTripleLawOf` and `IsSufficientStatisticOf` now explain coordinate
    order and fixed-prior scope; the recovery and family sections explain the
    complete-law equations, shared-witness quantifiers, null fibers, and the
    strict gap from marginal recovery; the common-posterior theorem explains
    supported overlap and total-posterior fallbacks; and the every-prior,
    full-support, and Fisher-Neyman sections record their reader-facing
    coordinate, cancellation, and finiteness conventions. No declaration,
    proof, definition, import, attribute, alias, or ownership boundary changed.
    The checklist is complete and should not be carried into Step 20.

    Chunk 4 Step 20 closes the sufficient-statistics and recovery phase after
    the full milestone suite, guarded boundary consumers, axiom audit,
    generated-reference checks, and repository hygiene all passed. The
    statistic/recovery layer is now stable enough to satisfy this note's
    sequencing gate for Fano. No Fano declaration or execution plan is added
    during integration; that theorem phase remains the next separately planned
    Project B work.

    Chunk 3 Step 15 now exposes an exact posterior decomposition, but proves no
    equality characterization for its nonnegative remainder and introduces no
    recovery channel. This is precisely the boundary intended above: posterior
    bookkeeping supports KL contraction, while posterior equality and recovery
    remain deferred until sufficient-statistics consumers make their contract
    concrete.

    Chunk 3 Step 16 proves only inequality from a nonnegative remainder. It
    does not characterize equality or add a recovery channel, so the
    sufficient-statistics boundary remains unchanged.

    Chunk 3 Step 17 publishes only contraction and its deterministic/cascade
    specializations. It adds no posterior-equality criterion, reverse channel,
    or recovery interpretation, so KL equality and sufficient-statistic work
    remain in the later phase owned by this note.

    Chunk 3 Step 18 stops at the one-step boundary permitted by this note. It
    proves contraction toward a single invariant law and entropy growth under
    uniform preservation, but adds no channel powers, stationary-process
    object, entropy rate, capacity, equality characterization, or recovery
    theorem.

    Formalize Fano only after the statistic/recovery layer is stable. Its
    contract should include the decoding error event or error indicator,
    binary entropy, the finite decision alphabet, and the standard conditional-
    entropy bound without mixing in a full coding theorem. Binary/q-ary entropy
    bridges should be added at the point where Fano creates concrete use.

    Keep iterated channel powers, stationary Markov processes, entropy rates,
    channel capacity, and coding-theory converses in later focused chunks.
    Chunk 3 may prove one-step contraction toward an invariant law and entropy
    increase under a uniform-preserving channel, but it should not introduce a
    stochastic-process or transition-matrix architecture. Existing Future Work
    Notes 1, 5, and 11-13 continue to own finite-family entropy, coding, and
    certificate/import extensions respectively; this note records only the
    mathematical sequence immediately downstream of Chunk 3.

    Chunk 3 Step 19 remains within the one-step boundary. Its examples add no
    recovery theorem, equality characterization, channel powers, stationary
    process, entropy rate, capacity, or coding converse. The sufficient-
    statistic and Fano phases remain the next downstream mathematical work
    after Chunk 3 integration.

    The July 23 post-Chunk 4 handoff now identifies finite Fano as Chunk 5 and
    records the intended error-event, binary/q-ary entropy,
    conditional-entropy, weaker finite-alphabet, and uniform-message surfaces.
    It also preserves the boundary against coding theorems, channel capacity,
    stochastic-process infrastructure, finite-family certificate semantics,
    and canonical/minimal sufficiency. No detailed execution plan is locked and
    no Fano declaration or module has been started, so this note remains active
    for the next planning phase.

30. Keep the Step 5 total conditional-channel law surface minimal until later
    proofs create a concrete need for a more abstract null-fiber theorem. The
    current atomwise result
    `condFstGivenSndChannel_null_fiber_irrelevant` is sufficient to express the
    semantic contract: after multiplication by a zero conditioning mass, the
    chosen fallback agrees with every alternative PMF. Together with
    `sndMarginal_mul_condFstGivenSndChannel` and
    `channelJoint_condFstGivenSndChannel`, it already supplies the weighted
    reconstruction needed by the planned Markov factorization converse.

    Do not add a generic weighted-channel, measure-level, or kernel-level
    null-fiber irrelevance theorem merely to abstract this one-line atomwise
    proof. Revisit that layer only if at least two production proofs repeat the
    weighted extensionality argument, or if the later Markov-kernel/KL bridge
    genuinely needs equality of weighted measures or kernels rather than PMF
    atoms. At that point, first decide whether the generic result belongs in
    `Probability.FiniteChannel`, `Shannon.SemanticBridge.Markov`, or the later
    data-processing module; preserve the rule that no conditional-probability
    meaning is assigned to a null fiber, and keep assumptions no stronger than
    the consuming theorem requires. Audit any new public name under Future Work
    Note 14.

    Also retain the current reconstruction orientation as the only public
    theorem unless a downstream consumer repeatedly needs the opposite form:
    `PMF.channelJoint (sndMarginal p) (condFstGivenSndChannel p) =
    p.map Prod.swap` records the natural channel order `(input, output) =
    (B,A)`. A theorem that immediately swaps this law back to the original
    `(A,B)`-ordered PMF `p` is mathematically redundant and should normally be
    derived locally. Add a compatibility corollary only if repeated consumers
    show that the local map
    normalization materially obstructs theorem use; do not add it solely for
    symmetry.

    Chunk 3 Step 10 uses only the Markov information-loss identity,
    nonnegativity, entropy algebra, and the zero-CMI characterization. It does
    not invoke the total conditional channel, repeat weighted null-fiber
    extensionality, or need the opposite reconstruction orientation, so this
    note remains deferred with no new public law.

    Chunk 3 Step 11 uses ordinary `PMF.channelExtension` only to generate
    Markov triples for data processing. It does not invoke
    `condFstGivenSndChannel`, weighted null-fiber extensionality, or either
    reconstruction orientation, so this note remains deferred unchanged.

    Chunk 3 Step 12 is the first production theorem to consume
    `sndMarginal_mul_condFstGivenSndChannel` in the planned full Markov
    factorization converse. Its null-fiber support argument and positive-fiber
    cancellation are each local and occur once. The proof does not repeat a
    generic weighted extensionality pattern, need equality of weighted measures
    or kernels, or use the opposite pair-law reconstruction orientation.
    Therefore the trigger of two repeated production proofs is not met and no
    additional conditional-channel law is promoted.

    Chunk 3 Step 13's temporary posterior reconstruction reused
    `channelJoint_condFstGivenSndChannel` directly after converting the total
    channel to a kernel. It needed no new public null-fiber theorem or repeated
    weighted extensionality argument, and the scratch consumer was deleted.
    The production trigger therefore remains unmet. Reassess only if the
    Step 14-16 implementation repeats a genuinely generic measure-level
    argument rather than composing the existing PMF equality.

    Chunk 3 Step 14 proves its joint-measure bridge directly from
    `PMF.channelJoint_apply` and singleton measures. It does not consume the
    total conditional channel, compare middle-marginal representations, or
    transport support across a null fiber. During Step 15, if posterior
    decomposition repeats one of the Step 12 arguments, prefer a private helper
    in the owning semantic module first; add public surface only after multiple
    downstream consumers demonstrate the need.

    Chunk 3 Step 15 reuses `channelJoint_condFstGivenSndChannel` once to prove
    the PMF-level posterior reconstruction theorem and then converts that
    equality privately with the existing `channelJoint_toMeasure` bridge. It
    repeats no weighted extensionality or null-fiber support argument and needs
    no opposite reconstruction orientation. The trigger for a new generic
    conditional-channel helper remains unmet.

    Chunk 3 Step 16 does not unfold the posterior or total conditional channel;
    it consumes `klDiv_channel_eq_add_posterior` as a black box. No new
    null-fiber or weighted-reconstruction pressure appears.

    Chunk 3 Step 17 wraps the private contraction engine and specializes it
    through existing deterministic and composition laws. It does not inspect
    posterior fibers, compare middle marginals, or repeat null-fiber support
    transport, so this trigger remains unmet.

    Chunk 3 Step 18 specializes only the public channel inequalities and the
    uniform-reference KL identity. It never unfolds a posterior or conditional
    channel, so no null-fiber helper pressure appears.

    Chunk 3 Step 19 uses the existing canonical and existential factorization
    theorems without repeating null-fiber transport or requesting the opposite
    reconstruction orientation. No new conditional-channel helper is added.

    Chunk 4 Step 8 proves the supported common-posterior characterization with
    one private generic lemma: equality of two channel-induced joint laws is
    equivalent to equality of their channels on the input-law support. Its
    forward direction performs one positive-mass cancellation and its reverse
    direction makes null input atoms vanish. The lemma has exactly one
    production consumer, is not specific to the total conditional channel, and
    remains private in `DataProcessing`. This does not meet the two-proof
    trigger for a public weighted-channel or null-fiber abstraction; reassess
    only if later recovery/KL proofs repeat the same argument.

    Chunk 4 Step 9 uses only the family recovery equation, atomwise PMF laws,
    and existing channel-extension projections. Its private coordinate-swap
    identification does not invoke the total conditional channel, repeat the
    Step 8 support-identifiability proof, or transport a null-fiber fallback.
    The trigger for a public weighted-channel or null-fiber abstraction remains
    unmet.

    Chunk 4 Step 10 applies the public existential Markov factorization as a
    black box and cancels the full-support prior mass directly. It does not
    unfold `condFstGivenSndChannel`, repeat weighted null-fiber extensionality,
    use the Step 8 support-identifiability helper, or request the opposite
    reconstruction orientation. No conditional-channel helper trigger is met.

    Chunk 4 Step 11 deliberately tested the null branch through the public
    posterior API. In the noninjective model, an unsupported output uses the
    documented first-marginal fallback and differs from the common posterior
    fixed by the model for which that output is supported. This validates the
    existing support guard and null-fiber semantics. The temporary proof reused
    the public branch and reconstruction laws without repeating production
    weighted extensionality, so no generic null-fiber helper or opposite
    reconstruction theorem is justified.

    Chunk 4 Step 12 has a separate zero-total branch for the finite
    Fisher-Neyman factor `h`. It proves every model atom on that statistic fiber
    zero and chooses a private pure recovery fallback. This is finite
    normalization bookkeeping, not a repeated use of the total conditional
    channel or weighted extensionality argument, so it does not meet this
    note's abstraction trigger.

    Chunk 4 Step 13 treats null output fibers through almost-everywhere kernel
    equality under `(p.bind W).toMeasure`; it neither unfolds the total
    conditional channel nor repeats weighted null-fiber extensionality. The
    existing measure automatically ignores null fibers, so no generic weighted
    channel or null-fiber helper is justified.

    Chunk 4 Step 14 reuses the existing private
    `channelJoint_eq_iff_eq_on_support` theorem to convert almost-everywhere
    posterior equality into the public support-pointwise statement. This gives
    the helper a second internal consumer but does not repeat its weighted
    cancellation proof or expose a direct caller need. Keep it private; reopen
    public promotion only if downstream code itself needs the generic channel-
    joint equivalence rather than the new posterior theorem.

    Chunk 4 Step 15 projects an assumed full-joint recovery equation to the
    recovered input marginal with ordinary `PMF.channelJoint` projection laws.
    It never unfolds `condFstGivenSndChannel`, reasons about a null fiber, or
    repeats weighted extensionality. No generic null-fiber or conditional-
    channel helper is justified.

    Chunk 4 Step 16 fires the narrower public-promotion trigger recorded after
    Step 14: the downstream recovery converse itself needs equality of induced
    joint laws from support-wise channel equality. The generic theorem is now
    `PMF.channelJoint_eq_iff_eq_on_support` in
    `Probability.FiniteChannel`, and the former private copy in
    `DataProcessing` is removed. This closes that identifiability subtask. It
    does not create a weighted-measure, kernel, opposite-reconstruction, or
    broader total-conditional-channel theorem, so the remaining null-fiber
    conveniences in this note stay proof-pressure deferred.

    Chunk 4 Step 17 treats the Step 15-16 recovery theorems as black boxes. It
    neither mentions a posterior nor repeats support-wise channel-joint
    extensionality or null-fiber reasoning. No remaining total-conditional-
    channel convenience reaches its promotion trigger.

    Chunk 4 Step 18's private atomwise recovery proof uses ordinary
    `PMF.channelJoint` laws for one concrete example. It does not unfold
    `condFstGivenSndChannel`, repeat the generic support-identifiability proof,
    or transport a total-posterior null fallback. No remaining helper or
    opposite-reconstruction trigger is met.

    Chunk 4 Step 19 changes comments and tests public names only. It repeats no
    weighted extensionality, null-fiber transport, or opposite reconstruction,
    and the already promoted `PMF.channelJoint_eq_iff_eq_on_support` remains the
    only pressure-justified generic addition. All other conveniences in this
    note stay deferred.

31. Keep the finite-channel core at its four current compound constructions
    until a second production consumer needs a named independent product of
    two channels. Chunk 3 Step 11's two-sided MI theorem currently states its
    output law directly as

    `p.bind fun ab => indepProd (W ab.1) (V ab.2)`.

    That statement is mathematically clear and avoids introducing a fifth
    definition for one theorem. Revisit a product-channel constructor only if
    later KL data processing, examples, or another theorem repeats the same
    channel combination. At that point, decide ownership before naming it:
    `Probability.FiniteChannel` cannot depend on the Shannon-local
    `indepProd`, so a lightweight constructor there would need to use raw
    `PMF.bind`/`PMF.map` and receive a semantic bridge theorem to `indepProd`;
    alternatively, a Shannon-owned definition may be appropriate if all real
    consumers are information-theoretic. Do not add both layers speculatively.

    Any promoted constructor should come with only the atom, composition, and
    deterministic-reduction laws demanded by its consumers, preserve the raw
    PMF-valued-function channel architecture, and receive a Future Work Note 14
    naming audit. Step 11 itself supplies only the first consumer, so this note
    remains proof-pressure deferred.

    Chunk 3 Step 17 passes the same single channel to both laws and specializes
    only to deterministic channels and sequential composition. It never forms
    two conditionally independent output channels, so it creates no second
    product-channel consumer and the constructor remains deferred.

    Chunk 3 Step 18 uses one square channel and its uniform or invariant input
    law. It introduces no independently sampled pair of channels, so the
    product-channel trigger remains unmet.

    Chunk 3 Step 19's examples use sequential channels only. They do not form
    a named independent product of two channels, so the product-channel
    constructor still has one production consumer and remains deferred.

32. Keep the additive Step 9 Markov information-loss identity as the canonical
    public orientation:

    `I(X;Y) = I(X;Z) + I(X;Y|Z)`.

    It avoids subtraction, exposes the nonnegative loss term directly, and was
    consumed without rearrangement by Step 10. Do not add the quantitative
    difference form

    `I(X;Y) - I(X;Z) = I(X;Y|Z)`

    merely because it is algebraically equivalent. Revisit it only if at least
    two production numerical, stability, or quantitative-loss arguments repeat
    the same subtraction rearrangement. If promoted, preserve the additive
    theorem, add the random-variable corollary first, and add the corresponding
    PMF form only if it has an independent consumer. Keep both forms explicit
    rather than `[simp]`, choose their orientation as one family, and audit the
    names under Future Work Note 14.

    Likewise, do not publish every symmetric or reversed MI-loss variant. The
    current `mutualInfoOf_swap`, `condMutualInfoOf_swap`,
    `isMarkovChainOf_reverse`, and `mutualInfoOf_markov_chain_rule` already
    derive those statements. Add a named orientation only if multiple public
    proofs repeatedly perform the same symmetry/reversal sequence and the
    resulting statement is materially easier to discover or use. At that
    point, decide whether callers need endpoint-swapped mutual information,
    a chain written in reverse order, or a genuinely different conditioning
    orientation; do not add all three by symmetry. Review PMF and
    random-variable forms together and retain the existing additive identity
    as the primary theorem.

    Future Work Note 27 separately owns the possible direct PMF zero-CMI/Markov
    wrapper and any private coordinate-law or relabeling helper. Step 9 remains
    the first direct PMF specialization of the zero-CMI theorem, so those
    representation conveniences have not reached their promotion trigger and
    are not duplicated here.

    Chunk 3 Step 19 proves no quantitative MI difference identity and repeats
    no symmetry or reversal sequence. The additive loss theorem remains the
    sole public orientation.

33. Keep `mutualInfoOf_dataProcessing_eq_iff` and its PMF counterpart as the
    canonical Step 10 equality characterizations. Under the forward chain
    `X -> Y -> Z`, they identify

    `I(X;Z) = I(X;Y)`

    exactly with the reverse chain `X -> Z -> Y`. Do not immediately duplicate
    this result in every algebraically equivalent form.

    Revisit the conditional-entropy equality

    `H(X|Y) = H(X|Z)` iff `IsMarkovChainOf p X Z Y`

    when an entropy-facing theorem, example, or the planned sufficient-
    statistic development uses that statement directly, or when two
    production proofs repeat the conversion through
    `I(X;Y) = H(X) - H(X|Y)`. If promoted, prove the random-variable theorem as
    a corollary of the existing MI equality result and add a PMF form only for
    an independent PMF consumer. Keep both equivalences explicit rather than
    `[simp]`, and choose their names as a coherent extension of the current
    `dataProcessing_eq_iff` family under Future Work Note 14.

    A strict-loss characterization such as

    `I(X;Z) < I(X;Y)` iff `Not (IsMarkovChainOf p X Z Y)`

    is also a logical consequence of the Step 10 inequality and equality iff.
    Add it only when a theorem or nondegenerate example genuinely reasons about
    strict information loss; do not publish it merely to complete the order-
    relation family. Before adding PMF and random-variable variants, check which
    orientation the consumer uses and whether the negated reverse-Markov
    condition is the most informative public contract. Such strict theorems
    remain explicit and should not become simp rules.

    The current PMF equality theorem deliberately states the reverse condition
    with the original law's first, third, and second coordinate variables,
    avoiding a mapped reverse triple. If repeated PMF consumers find those
    coordinate lambdas difficult to use, review a cleaner reverse-chain wrapper
    together with Future Work Note 27's endpoint-law and direct PMF zero-CMI
    questions. Do not introduce a second PMF Markov predicate or a mapped-law
    alias solely to shorten this one theorem. Any compatibility wrapper must
    preserve the existing theorem and receive a naming audit under Note 14.

    Symmetric and reversed MI-loss orientations remain owned by Future Work
    Note 32. Recovery-channel and sufficient-statistic interpretations remain
    owned by Future Work Note 29; this note records only immediate equality and
    strictness corollaries of the finite Markov DPI.

    Chunk 3 Step 19 needs neither the conditional-entropy equality iff nor a
    strict MI-loss characterization. Both remain deferred to a direct entropy
    or sufficient-statistic consumer.

    Chunk 4 Step 3 completed the directly consumed random-variable theorem as
    `condEntropyOf_dataProcessing_eq_iff`, deriving it from the canonical MI
    equality characterization and validating it on the intended statistic
    specialization. No PMF wrapper is added because no independent PMF
    consumer appeared, and no strict-loss result is justified. Those two
    branches remain deferred under this note rather than blocking Step 4.

    Chunk 4 Step 5 is the first production sufficiency theorem to consume that
    random-variable entropy equality result. It confirms the chosen orientation
    `H(Theta|X) = H(Theta|T(X))` and still creates no independent PMF consumer or
    strict-loss argument. The random-variable branch is complete; the PMF and
    strict-loss branches remain deferred under their original triggers.

    Chunk 4 Step 9 supplies the independent law-level consumer: preservation
    of parameter conditional entropy under a sufficient family channel. The
    new `condEntropy_dataProcessing_eq_iff` is the direct PMF specialization of
    the existing `...Of` theorem and is used by that production corollary. It
    remains explicit, and its coherent PMF/RV name needs no compatibility
    alias. The conditional-entropy equality branch of this note is now
    complete; no proof or example reasons about strict information loss, so
    the strict-loss branch remains deferred.

    Chunk 4 Step 18 exercises the fixed-prior mutual-information equality and
    the already completed family APIs. It does not introduce another
    conditional-entropy wrapper or reason about strict information loss, so the
    remaining strict-loss trigger stays unmet.

    Chunk 4 Step 19 retains both completed conditional-entropy equality
    theorems as explicit canonical surfaces. Neither the documentation pass nor
    the API probe reasons about strict information loss, so only that separate
    strictness branch remains deferred.

34. Keep the Step 11 stochastic-channel processing API PMF-first until
    downstream applications establish a natural random-variable coupling
    contract. A deterministic function of a random variable remains on the
    original source type, but sampling through `W : alpha -> PMF beta`
    introduces fresh randomness; a channel output is therefore not generally a
    function on the original `omega` without enlarging the probability space or
    choosing an explicit coupling. The current `PMF.channelJoint`,
    `PMF.channelExtension`, and `PMF.bind` statements expose that law honestly.

    Do not add nominal `...Of` wrappers that merely hide this distinction.
    Revisit a random-variable channel-facing theorem when at least two
    applications naturally begin with `p : PMF omega` and source variables and
    repeatedly push their joint law forward before applying the same Step 11
    theorem, or when a later kernel/coupling layer supplies a canonical output
    sample space. Before fixing the API, decide whether the result should be
    stated solely about the pushed-forward output PMF, about variables on an
    explicitly extended source, or about a kernel-generated coupling. Preserve
    raw PMF-valued-function channels and do not introduce a bundled channel or
    source-extension structure solely to obtain an `...Of` name.

    Also defer channel-facing conditional-entropy corollaries. For example,
    applying a channel to `B` in a joint law of `(A,B)` gives the immediate Step
    10 consequence `H(A|B) <= H(A|C)`, where `C` is the channel output. Publish
    such a wrapper only when an entropy-facing theorem or example uses the
    channel construction directly, or when two proofs repeat the same
    specialization of `condEntropy_dataProcessing`. Decide first which variable
    is processed and which variable remains the entropy target; do not add
    left, right, both, cascade, and deterministic forms merely to mirror the MI
    family. Derive any accepted theorem from the existing Markov conditional-
    entropy DPI, keep it explicit rather than `[simp]`, and audit its name under
    Future Work Note 14.

    Equality and recovery conditions for these channel statements remain in
    the sufficient-statistic/recovery phase owned by Future Work Note 29, with
    immediate entropy-equality ergonomics covered by Note 33. Iterated and
    process-level channels remain in the later-process backlog in Note 29.
    Product-channel construction pressure remains separately tracked by Note
    31, and the Step 11 cascade/deterministic naming review remains in Note 14.

    Chunk 3 Step 17 keeps the KL data-processing family PMF-first for the same
    reason. Its deterministic-map specialization is already the honest law-
    level form, while stochastic outputs still require fresh randomness. No
    nominal random-variable wrapper or bundled coupling was added, and the
    trigger for revisiting this contract remains unmet.

    Chunk 3 Step 18 is likewise PMF-first. Invariance and uniform preservation
    are properties of output laws under `PMF.bind`, while a stochastic output
    still has no canonical random variable on the original sample space. No
    `...Of` wrapper or coupling structure is justified.

    Chunk 3 Step 19 keeps both new examples PMF-first. It adds no nominal
    `...Of` channel wrapper, coupling object, or channel-facing conditional-
    entropy corollary.

    Chunk 4 Step 18 is likewise an honest PMF experiment module. It uses raw
    model laws, deterministic channels, and explicit generated joint laws; no
    nominal stochastic-output variable, coupling object, or channel-facing
    `...Of` wrapper is introduced.

    Chunk 4 Step 19 confirms that this PMF-first surface is readable in the
    permanent experiment and downstream API probe. No repeated source-variable
    pushforward or entropy-channel specialization appears, so neither a
    stochastic `...Of` coupling wrapper nor a channel-facing conditional-
    entropy convenience is justified.

35. Keep the finite KL equivalence-relabeling theorem used by the Step 13
    posterior-decomposition spike private when it first enters production in
    Step 15. Its current sole purpose is to show that swapping the coordinates
    of both finite joint laws preserves KL before applying the posterior chain
    rule. A public theorem family would add measurable-space, finite-alphabet,
    support, and naming choices that no independent caller currently needs.

    Revisit this decision only if a second production proof needs KL invariance
    under a nontrivial alphabet relabeling, or if downstream sufficient-
    statistic/recovery work repeatedly performs the same transport. At that
    point decide whether callers need equivalences only, globally injective
    maps, or a support-aware injectivity contract; also decide whether the
    theorem belongs in `SemanticBridge.KL` or `SemanticBridge.DataProcessing`.
    Preserve the private theorem while evaluating the public contract, keep
    any accepted declaration explicit rather than `[simp]`, and audit its name
    under Future Work Note 14.

    Before extending or publishing this helper, and whenever the pinned mathlib
    version is upgraded, search upstream for KL invariance under measurable
    equivalences or injective pushforwards. Prefer replacing the local finite-
    sum proof with a suitable mathlib theorem if it preserves the unconditional
    `ENNReal` contract, including the infinite-KL branch. Do not weaken that
    contract merely to shorten the proof, and do not retain two public
    relabeling APIs if an upstream theorem already supplies the needed result.

    Chunk 3 Step 14 needs no KL relabeling: its only equality compares the same
    `(alpha, beta)` joint measure on both sides. The private-first Step 15
    decision and its independent-consumer trigger therefore remain unchanged.

    Chunk 3 Step 15 has now put the finite equivalence theorem into production
    as a private helper, used exactly once for `Prod.swap` inside
    `klDiv_channel_eq_add_posterior`. No second relabeling consumer appeared,
    so the helper remains private and the equivalence/injective/support-aware
    public contract question stays deferred.

    Chunk 3 Step 16 consumes only the public decomposition and never invokes
    `klDiv_map_equiv` directly. Its production-consumer count remains one.

    Chunk 3 Step 17 derives every public contraction from the private engine
    and existing channel algebra. The deterministic specialization does not
    use equivalence invariance, so `klDiv_map_equiv` still has exactly one
    production consumer and remains private.

    Chunk 3 Step 18 uses the same alphabet on both sides of each invariant-law
    statement and performs no relabeling. The private theorem's production-
    consumer count remains one.

    Chunk 3 Step 19 performs no KL relabeling. The private `klDiv_map_equiv`
    theorem still has its single `Prod.swap` consumer and remains private.

    Chunk 4 Step 9's private coordinate swap proves equality of two PMF laws
    atomwise before any information measure is applied. It neither calls nor
    repeats the KL equivalence-invariance proof, so `klDiv_map_equiv` still has
    one production consumer and remains private.

    Chunk 4 Step 10's last-coordinate swap is likewise a direct PMF-law
    calculation. It neither calls nor reproduces finite KL equivalence
    invariance, so `klDiv_map_equiv` remains private with one consumer.

    Chunk 4 Step 13 consumes the public posterior decomposition as a black box
    and performs no relabeling. It neither calls nor repeats `klDiv_map_equiv`,
    whose sole production consumer remains the coordinate swap inside
    `klDiv_channel_eq_add_posterior`; public promotion is still unjustified.

    Chunk 4 Step 14 performs no KL relabeling. It converts the Step 13 kernel
    statement back through composition products and PMF joint laws on the same
    alphabets, so `klDiv_map_equiv` remains private with its single consumer.

    Chunk 4 Step 15 assumes swapped full-joint recovery equations but proves KL
    equality only by projecting them to marginals and applying channel data
    processing twice. It neither calls nor repeats `klDiv_map_equiv`, whose
    production-consumer count remains one.

    Chunk 4 Step 16 uses the existing posterior equality theorem and PMF joint-
    law reconstruction. Its deterministic forms simplify an already proved
    channel theorem through graph pushforwards; they do not prove KL invariance
    under relabeling. `klDiv_map_equiv` therefore remains private with its one
    coordinate-swap consumer.

    Chunk 4 Step 17 invokes the public common-recovery theorem directly and
    obtains its deterministic family form by simplifying
    `PMF.deterministicChannel`. It neither calls nor repeats
    `klDiv_map_equiv`; the relabeling theorem still has one production consumer
    and remains private.

    Chunk 4 Step 18's concrete recovery calculation swaps PMF coordinates
    before any information measure is applied. Its Boolean orientation probe
    reindexes the model parameter, not either KL alphabet. Neither argument
    calls nor repeats `klDiv_map_equiv`, whose production count remains one.

    Chunk 4 Step 19 adds no theorem proof or KL relabeling consumer. The private
    equivalence helper remains used once for `Prod.swap`, so its public
    equivalence/injective/support-aware contract and ownership stay deferred.

36. Keep the type-generic bind-support monotonicity lemma introduced privately
    in Chunk 3 Step 17 out of the public API until a second production proof
    needs it. Its sole current consumer transports `p.support ⊆ q.support`
    through the first channel for `toReal_klDiv_channelComp_le`; the primary
    real channel theorem itself needs only finiteness of the right-hand input
    divergence and does not require a named output-support result.

    Separately from helper promotion, review the real cascade theorem's support
    contract during Step 19. Its right-hand divergence is between the
    intermediate laws `p.bind W` and `q.bind W`, so the weakest natural
    finiteness guard is

    `(p.bind W).support ⊆ (q.bind W).support`,

    not the current stronger source-law condition `p.support ⊆ q.support`.
    The distinction is genuine: a first channel can merge source atoms so that
    the intermediate support inclusion holds even when the source inclusion
    fails. Keep `toReal_klDiv_channelComp_le` unchanged for compatibility while
    reviewing this question. If a weaker public theorem is justified, choose
    its name and its relationship to the existing theorem together with Future
    Work Note 14's cascade-alias review; the current theorem should then remain
    as the convenient source-support corollary rather than being replaced.

    Step 19's genuinely stochastic example should exercise the cascade API and,
    if reasonably compact, include a finite case where source support inclusion
    fails but intermediate support inclusion succeeds. Use that example to
    decide whether the weaker contract materially improves real proofs and
    whether `channelComp` or `channel_cascade` is more discoverable in practice.
    Do not add a second theorem merely because its hypothesis is logically
    weaker if no consumer benefits from the extra generality.

    Revisit public promotion of `support_bind_mono` only if Step 18 or a later
    channel theorem independently repeats the same
    `PMF.mem_support_bind_iff` argument. At that point decide whether the
    theorem belongs with type-generic channel support laws in
    `Probability.FiniteChannel`, remains an implementation lemma in
    `SemanticBridge.DataProcessing`, or is better proposed upstream beside
    mathlib's `PMF.support_bind`. Preserve the private helper while evaluating
    that ownership, avoid adding finite or measurable assumptions to its
    type-generic contract, and audit any public name under Future Work Note 14.

    Chunk 3 Step 18 does not call `support_bind_mono`. The real invariant-law
    theorem keeps the original input/reference support condition, while the
    entropy proof discharges support against the full-support uniform law by
    simplification. The helper still has exactly one production consumer, so
    its promotion trigger remains unmet.

    Step 19's stochastic cascade supplies the requested separating example:
    two disjoint pure source laws fail source support inclusion, a uniform
    reset first stage makes their intermediate laws equal, and a nonuniform
    reset supplies the second stage. The weaker intermediate-support real
    contraction is one `simpa only [PMF.bind_channelComp]` from
    `toReal_klDiv_channel_le`. That route is already clear, so no second public
    real cascade theorem was added. The existing source-support theorem and
    the private one-consumer `support_bind_mono` remain unchanged; only the
    reviewed `...channel_cascade_le` compatibility alias family was added.

    Chunk 4 Step 14 proves output-divergence finiteness directly from
    `klDiv_channel_le` and input KL finiteness. It neither calls nor repeats the
    atomwise proof of `support_bind_mono`, whose production-consumer count
    remains one and whose public promotion trigger is still unmet.

    Chunk 4 Step 15 needs no support hypothesis and never inspects the support
    of a bind. It does not call or repeat `support_bind_mono`; that helper still
    has one production consumer and remains private.

    Chunk 4 Step 16 assumes input support inclusion only to invoke the guarded
    posterior equality theorem and prove KL finiteness. It never transports
    support through `PMF.bind` and neither calls nor repeats
    `support_bind_mono`. That helper remains private with one production
    consumer.

    Chunk 4 Step 17 passes the input-law support guard directly to Step 16 in
    the Boolean converse and needs no output-support statement. It neither
    calls nor repeats `support_bind_mono`, whose production-consumer count
    remains one.

    Chunk 4 Step 18 proves its concrete support inclusion directly from the
    finite atoms of the example laws. It does not transport support through an
    arbitrary bind or repeat `support_bind_mono`; that helper remains private
    with one production consumer.

    Chunk 4 Step 19 introduces no support proof. The private type-generic
    `support_bind_mono` helper therefore still has one production consumer, and
    neither public promotion nor a weaker real cascade theorem is justified.

37. Keep the Step 15 posterior API and exact composition-product KL
    decomposition unchanged unless later consumers create pressure for one of
    two textbook-facing conveniences. These are possible follow-ups, not work
    for the active data-processing theorem steps.

    First, `channelPosterior` and
    `channelPosterior_reconstructs_joint` expose `[Fintype alpha]` because they
    reuse the existing finite conditional-law construction directly. If later
    APIs repeatedly begin with only `[Finite alpha]` and must install
    `Fintype.ofFinite` merely to mention the posterior, investigate a
    compatibility-preserving `[Finite]` wrapper or a revised construction. Do
    not change the current definitions speculatively: first verify that the
    proposed result is independent of the selected `Fintype` instance, retains
    the documented null-output fallback, and materially improves theorem use.

    Second, a later consumer may want to rewrite the posterior remainder in
    `klDiv_channel_eq_add_posterior` as an explicit output-weighted average of
    fiberwise posterior divergences. Before adding such a theorem, decide
    whether its useful codomain is `ENNReal` or `Real`, which support or
    finiteness hypotheses prevent `toReal top` mistakes, how null output fibers
    contribute, and whether mathlib's kernel KL chain-rule API already provides
    the desired form. Keep the current unconditional `ENNReal` composition-
    product identity canonical. Revisit the averaged form only when
    sufficient-statistic/recovery work from Future Work Note 29, a quantitative
    information-loss argument, or at least two production proofs genuinely
    need fiberwise posterior KL values.

    Chunk 3 Step 18 consumes neither posterior reconstruction nor the exact
    posterior remainder. Its invariant-law and entropy proofs use only the
    public contraction inequality and uniform-reference KL identity, so both
    possible posterior conveniences remain deferred.

    Chunk 3 Step 19 consumes neither posterior reconstruction nor the exact
    posterior remainder. No `[Finite]` posterior wrapper or weighted fiber-KL
    expansion is justified.

    Chunk 4 Step 1 is the first temporary sufficiency proof to expose the
    current `[Fintype alpha]` posterior contract. The guarded KL equality spike
    compiled cleanly with that existing assumption and did not need an
    averaged fiber-KL expansion. A deleted proof spike is not a production
    consumer, so neither possible convenience has crossed this note's trigger;
    Steps 13-18 should reassess only if repeated production use appears.

    Chunk 4 Step 8 is the first production sufficiency consumer of
    `channelPosterior`. Its supported common-posterior theorem naturally states
    `[Fintype alpha]`, exactly matching the existing posterior construction; it
    does not begin from a `[Finite]`-only API and install a local instance.
    Consequently it creates no pressure for a compatibility wrapper. The proof
    uses only PMF reconstruction and support cancellation, not the posterior KL
    remainder, so it also creates no need for an output-weighted fiber-KL
    expansion. Both possible conveniences remain deferred.

    Chunk 4 Step 11's posterior consumer again uses the existing
    `[Fintype alpha]` contract naturally. It tests supported and unsupported
    output fibers but never installs a local enumeration from `[Finite]` and
    never expands the KL remainder into fiber divergences. The stronger null-
    fiber disagreement example confirms the present support-aware contract;
    neither deferred posterior convenience gains production pressure.

    Chunk 4 Step 12 does not use `channelPosterior` or the KL posterior
    remainder. Its private normalization is applied to the Fisher-Neyman factor
    on a finite observation fiber and is not a `[Finite]` wrapper around the
    posterior API or a weighted fiber-KL expansion. Both conveniences remain
    deferred for the actual equality consumers in Steps 13-17.

    Chunk 4 Step 13 is the first production KL-equality consumer of
    `channelPosterior`. Its natural theorem contract already uses
    `[Fintype alpha]`, so it installs no local enumeration and creates no
    pressure for a `[Finite]` compatibility wrapper. The proof cancels the
    composition-product remainder as a whole and never expands it into
    output-weighted fiber divergences. Both textbook-facing conveniences remain
    deferred entering Step 14 and the later recovery consumers.

    Chunk 4 Step 14 again uses the existing `[Fintype alpha]` posterior
    contract directly in both public theorems; no local enumeration is
    installed. Its pointwise support conclusion is derived from the whole
    composition-product equality and does not expand KL into a weighted sum of
    fiber divergences. Neither deferred convenience gains new proof pressure;
    reassess only if Steps 15-17 encounter a genuinely different consumer.

    Chunk 4 Step 15 is not a posterior consumer. It starts with `[Finite]`
    alphabets, uses the public channel DPI in both directions, and neither
    installs a `Fintype` merely to mention `channelPosterior` nor expands the
    composition-product remainder. Neither deferred posterior convenience
    gains proof pressure.

    Chunk 4 Step 16 is the first production theorem whose public contract uses
    only `[Finite alpha]` but whose proof installs one local
    `Fintype.ofFinite alpha` to choose a posterior as an existential recovery
    witness. The selected posterior does not appear in the theorem statement,
    and no caller must manage the instance. One internal consumer does not meet
    this note's repeated-API-pressure threshold, so no `[Finite]` posterior
    wrapper is added. The proof also treats posterior equality as a black box
    and never expands the KL remainder into fiberwise divergences.

    Chunk 4 Step 17 uses only the public recovery theorems and never mentions
    `channelPosterior`, installs a local `Fintype`, or expands the KL remainder.
    Neither the `[Finite]` posterior wrapper nor the weighted fiber-divergence
    formula gains a new production consumer.

    Chunk 4 Step 18 also consumes recovery and KL characterizations as black
    boxes. Its private example witness is an elementary PMF channel and never
    mentions `channelPosterior` or expands a fiberwise KL remainder. Neither
    deferred posterior convenience gains pressure.

    Chunk 4 Step 19's documentation and API checks add no posterior consumer.
    The `[Finite]` theorem that internally installs one `Fintype` remains the
    sole wrapper-pressure occurrence, and no proof requests a weighted
    fiberwise KL expansion. Both conveniences stay deferred.

38. Keep a matrix-facing doubly stochastic bridge deferred until the later
    majorization/Birkhoff phase creates a concrete consumer. Chunk 3 Step 18
    deliberately states its finite textbook corollary for a
    raw PMF-valued channel with the direct column condition
    `∀ b, ∑ a, W a b = 1`; the PMF codomain already provides normalized
    nonnegative rows. This proves the intended entropy result without a second
    channel representation.

    Mathlib already provides `doublyStochastic` and its row/column-sum
    characterizations in the heavier matrix/convexity hierarchy. When Chapter
    2 majorization, Birkhoff-von Neumann, or at least two matrix-facing examples
    need that vocabulary, design one compatibility bridge rather than a new
    project-local matrix theory. At that point decide the matrix entry type
    (`ENNReal` probabilities or real masses), the row/column orientation of
    `W a b`, how normalized rows construct PMFs, and whether the bridge belongs
    in a separate opt-in module so neither `Probability.FiniteChannel` nor the
    current data-processing module inherits convex-matrix imports.

    The same consumer review should decide whether the local Step 18 fact that
    unit column sums preserve `PMF.uniformOfFintype` deserves a public theorem
    or an iff characterization. Keep it local while it has one consumer, avoid
    a bundled `IsDoublyStochastic` predicate merely to restate the current
    theorem, and audit any accepted bridge names under Future Work Note 14.

    Step 19's permanent stochastic examples should test both Step 18 surfaces,
    not only import their signatures. Include a non-permutation doubly
    stochastic channel that sends a nonuniform input toward the uniform law and
    proves a genuine strict entropy increase when the existing entropy API can
    express it cleanly. Also include a channel with a nonuniform invariant
    reference law and use `klDiv_channel_invariant_le` or its real form to show
    one-step contraction toward that law. A reset channel with all rows equal
    to a full-support nonuniform reference is an acceptable compact example if
    a more structured chain would obscure the API under review.

    Use those examples to assess the entropy names from Future Work Note 14 and
    the practical value of a named uniform-preservation bridge. If an example
    merely repeats the local column-sum calculation once, keep the helper
    private; reconsider public promotion only when another independent
    theorem or the later matrix/majorization layer needs the same fact. Keep
    the examples PMF-facing and separately importable so they do not pull the
    matrix/convexity hierarchy into the active data-processing module.

    Step 19 supplies both requested permanent tests in
    `Examples.StochasticChannels`. The non-permutation uniform reset channel
    uses both Step 18 entropy theorems and strictly raises a pure binary input's
    entropy from zero to `log 2`. A full-support nonuniform Bernoulli reference
    is invariant under a second reset channel, and
    `klDiv_channel_invariant_le` proves one-step contraction toward it.

    The direct column-sum and uniform-preservation calculations remain private
    example helpers. They create no second core consumer, no reason for a
    bundled doubly-stochastic predicate or matrix bridge, and no reason to
    publish a uniform-preservation theorem. The entropy alias probes were
    declined in Future Work Note 14 because the existing names proved clearer
    than either the `mono` or `nondecreasing` alternatives.

39. Keep canonical and minimal sufficient statistics outside the active Chunk
    4 recovery phase. Chunk 4 should establish the finite fixed-prior and
    family sufficiency contracts, common recovery, every-prior equivalences,
    finite Fisher-Neyman factorization, and guarded KL equality without also
    committing to a comparison order or canonical quotient construction.

    In a later focused phase, define one statistic as no more informative than
    another by support-wise factorization on the union of the model family's
    supports. Do not require the factorization globally away from that union.
    Then formulate minimal sufficiency, prove uniqueness up to support-aware
    relabeling, and investigate a canonical finite statistic based on equal
    likelihood vectors or a zero-safe cross-product relation rather than
    unguarded likelihood ratios. Reuse Chunk 4's Fisher-Neyman and recovery
    theorems instead of creating a second notion of sufficiency.

    Also defer a general `n`-sample iid statistical-experiment construction and
    the textbook count-statistic example until product-family notation and its
    support laws have independent consumers. Chunk 4 may use a compact finite
    noninjective example, but it should not build an iid-process hierarchy for
    one demonstration. A general measurable sufficient-statistic theory is a
    still later bridge to mathlib kernels and almost-everywhere factorization;
    it must not weaken or silently replace the exact finite PMF API.

    Revisit this note only after the Chunk 4 API and examples make the
    statistic-comparison orientation, support convention, and quotient needs
    concrete. Keep the resulting modules opt-in, audit every public name under
    Future Work Note 14, and decide separately whether this phase belongs
    before or after Fano; neither development depends on the other.

    Chunk 4 Step 1 validates only the common-recovery, full-support-prior, KL
    equality, and finite factor-normalization foundations. It introduces no
    statistic-comparison order, support-union construction, quotient, or iid
    product model, so the boundary of this note remains unchanged.

    Chunk 4 Step 4 adds only fixed-prior sufficiency and its induced triple law.
    It introduces no comparison order, minimality predicate, canonical quotient,
    support-union relation, iid model, or measurable sufficiency layer, so this
    note remains deferred unchanged.

    Chunk 4 Step 10 closes only the full-support and all-priors equivalences for
    the existing finite recovery predicates. It introduces no statistic
    comparison relation, minimality notion, quotient, support-union model, iid
    construction, or measurable sufficiency layer. The later boundary of this
    note remains unchanged.

    Chunk 4 Step 11 uses a compact two-bit noninjective statistic solely as a
    temporary contract test. It introduces no statistic order, support-union
    quotient, canonical representative, iid family, or measurable extension.
    The example is suitable to reconsider for Step 18, but it creates no reason
    to begin canonical or minimal sufficiency before the current chunk closes.

    Chunk 4 Step 12 supplies the finite Fisher-Neyman theorem that this later
    phase should reuse. It keeps factor functions explicit and introduces no
    statistic-comparison order, minimality predicate, support-union relation,
    quotient, iid model, or measurable factorization layer. Completing this
    prerequisite does not move the deferred canonical/minimal work into the
    active chunk.

    Chunk 4 Step 16 characterizes pairwise KL equality through an existential
    common recovery channel for two supplied laws. It introduces no statistic
    comparison order, canonical quotient, support-union construction, iid
    family, or measurable experiment layer. The deterministic graph forms are
    equality criteria, not a minimal-sufficiency construction, so this later
    phase remains deferred.

    Chunk 4 Step 17 derives KL consequences of the existing family predicates
    and closes only a support-guarded Boolean two-law converse. It adds no
    statistic-comparison order, support-union relation, canonical quotient,
    minimality predicate, iid model, or measurable extension. This later phase
    remains deferred unchanged.

    Chunk 4 Step 18 makes the planned compact noninjective example permanent,
    but compares no two statistics and constructs no quotient, support-union
    relation, iid family, count statistic, or measurable extension. The example
    confirms that the finite API is expressive without moving canonical or
    minimal sufficiency into the active chunk; this note remains deferred for a
    separately planned phase.

    Chunk 4 Step 19 confirms that the finite recovery API and its module
    boundary are stable, but it still supplies no statistic-comparison order,
    support-union quotient, canonical representative, iid family, or measurable
    extension. This later phase is now better grounded, not immediate; retain
    it for separate planning after the current milestone closes.

    Chunk 4 Step 20 closes the finite recovery milestone without adding any of
    these later structures. The stable API now provides the intended foundation
    for a future canonical/minimal-sufficiency plan, but Fano and other already
    sequenced Chapter 2 work may proceed independently. This note remains a
    later focused milestone, not immediate integration cleanup.

    The July 23 handoff review does not activate this work. It introduces no
    statistic-comparison order, support-union quotient, canonical
    representative, iid/count-statistic family, or measurable extension.
    Canonical and minimal sufficiency remain deferred to their own later
    milestone while Chunk 5 proceeds with finite Fano.

40. Keep a general common-marginal-recovery KL preservation theorem out of the
    public API until a consumer independent of statistical sufficiency needs
    it. The current public theorem
    `klDiv_channel_eq_of_common_recovery` assumes that one channel `R` exactly
    reconstructs both complete output-input joint laws. Its proof privately
    projects those equations to

    ```lean
    (p.bind W).bind R = p
    (q.bind W).bind R = q
    ```

    and then sandwiches KL divergence between data processing through `W` and
    data processing through the same `R`. Consequently, the KL implication is
    mathematically valid under these two marginal equations alone and remains
    valid when the divergences are `top`. The use of one common `R` is
    essential; independently chosen reverse channels do not supply one channel
    through which the pair of output laws can be processed together.

    Do not weaken or replace `klDiv_channel_eq_of_common_recovery`. Its full-
    joint hypotheses are the correct sufficiency-facing contract and preserve
    the input-output coupling that marginal recovery forgets. Step 11 already
    demonstrated that marginal recovery alone is too weak to characterize a
    sufficient statistic. A later generic theorem must therefore be presented
    as a KL retraction or common-left-inverse result, not as an alternative
    definition or characterization of sufficiency.

    Reopen this question only if a second production consumer starts directly
    from the two bind-recovery equations and would otherwise repeat the same
    two-DPI proof, or if a later channel-equivalence, experiment-comparison, or
    stochastic-retraction development naturally exposes that contract. At
    that point, decide whether the generic theorem belongs in
    `SemanticBridge.DataProcessing` or a focused downstream channel-equivalence
    module. If it is added, retain the existing exact-recovery theorem as the
    sufficiency-facing corollary, avoid promoting the private joint-to-marginal
    projection helper merely to support it, and audit the new name under Future
    Work Note 14. A provisional conceptual family might use
    `klDiv_channel_eq_of_common_bind_recovery` or
    `klDiv_channel_eq_of_common_leftInverse`; neither name is approved.

    Do not add a real-valued companion automatically. Such a theorem needs an
    explicit support or finiteness contract so that `ENNReal.toReal` does not
    identify an infinite divergence with zero. Do not add separate-recovery,
    posterior, deterministic-map, or iff variants without their own consumer
    pressure. Through Chunk 4 Step 16, the Step 15 proof is the sole production
    occurrence of this marginal-recovery DPI sandwich, so the trigger remains
    unmet.

    Track one distinct deterministic convenience under the same pressure rule.
    Exact recovery of both graph laws for `T : alpha -> beta` implies the
    support-free `ENNReal` equality

    ```lean
    InformationTheory.klDiv (p.map T).toMeasure (q.map T).toMeasure =
      InformationTheory.klDiv p.toMeasure q.toMeasure
    ```

    by specializing `klDiv_channel_eq_of_common_recovery` to
    `PMF.deterministicChannel T`. The guarded Step 16 iff theorem already gives
    the finite-support-facing characterization, while a caller with recovery
    hypotheses but no `p.support subset q.support` can currently invoke and
    simplify the channel theorem directly. Add a public theorem provisionally
    shaped like `klDiv_map_eq_of_common_recovery` only if a later consumer
    repeats that specialization or finds the channel-facing invocation
    materially awkward. Keep it in `Sufficiency.KL`, preserve the existing iff
    family, and audit the final name under Note 14. Do not automatically add a
    `toReal` companion: applying `toReal` to the `ENNReal` equality is formally
    valid, but without a finiteness guard an equality arising from `top = top`
    has little real-valued information-theoretic content.

    Chunk 4 Step 17 does not trigger either promotion. Its family-channel proof
    starts from `IsSufficientChannel`'s full-joint recovery equations and calls
    `klDiv_channel_eq_of_common_recovery`; it does not restate or repeat the
    private marginal-recovery DPI sandwich. The deterministic theorem starts
    from the public family predicate `IsSufficientStatistic`, as required by
    the active integration plan, rather than exposing a new pairwise
    `klDiv_map_eq_of_common_recovery` convenience. No generic marginal theorem,
    pairwise deterministic-recovery wrapper, or real companion is added, so
    both proof-pressure triggers remain unmet.

    Chunk 4 Step 18 deliberately separates the two contracts in examples. The
    positive KL declaration starts from public family sufficiency, while the
    marginal-only counterexample proves no KL equality and supplies no generic
    common bind-recovery consumer. It also does not specialize the Step 15
    theorem directly from pairwise graph-recovery hypotheses. Neither the
    generic marginal-recovery theorem nor the deterministic convenience is
    justified.

    Chunk 4 Step 19's call-site review found no independent common-bind-
    recovery consumer and no repeated deterministic specialization. The
    sufficiency-facing full-joint theorem remains the correct public surface;
    both generic convenience triggers stay unmet.

    Chunk 4 Step 20 adds no theorem proof or independent recovery consumer.
    The full milestone consumers use the existing sufficiency-facing surface,
    so neither the generic marginal-recovery theorem nor the deterministic
    convenience crosses its promotion threshold.
