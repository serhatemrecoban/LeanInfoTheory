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

These are the live notes we are keeping for future work. Completed foundation
reminders have been removed from this backlog and are recorded instead in the
step-by-step history above. The near-term semantic bridge plan above is
complete; this section records important later work, ongoing guardrails, and
items that should wait for more theorem pressure.

The near-term theorem/certificate plan above is complete, and Project B is now
active. Its 14-step pair/triple Shannon Chunk 1 is complete and checkpointed as
commit `7ab3aa0`. The revised 18-step Chunk 2 is also complete: Step 18 closed
the chunk with final integration, the full milestone suite, generated-reference
and website checks, repository hygiene, and the coherent checkpoint review.
Chunk 2 owns finite KL support/equality, uniformity, independence, and
conditional independence.
Finite-family entropy,
richer certificate assumptions, external certificate import, coding-theory
layers, theorem-level blueprint work, and substantial mathlib PR preparation
remain later work.

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

    The July 6 API polish pass first deferred aliases for results such as
    `mutualInfo_chain_rule_fst`. Subsequent symmetry, conditional-chain-rule,
    deterministic-processing, MI-identity, and inequality steps supplied the
    evidence used by Step 13. Future theorem phases should continue recording
    newly pressured names here and should schedule another coherent review
    only after enough new examples accumulate.

    At the next scheduled naming review, add a compact decision table near the
    beginning or end of this note without deleting the historical discussion.
    Give each watched theorem family one row with its current descriptive
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

18. Preserve the boundary between the completed pair/triple Chunk 1 and the later
    Project B chunks. The full equality characterization for the
    support-cardinality entropy bound, `I(X;Y) = 0` iff independence,
    `H(X|Y) = H(X)` iff independence, and the corresponding conditional-
    independence equality cases belong with the general finite KL/equality
    work. Stochastic channels, Markov structure, and general data processing
    remain later still. Chunk 1 Step 7 completed deterministic entropy
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

20. The proposed separately importable elementary-MI usage example was closed
    without adding a redundant module during Step 13. Step 9 supplied genuine
    proof pressure for the Step 8 identities, and the Step 13 simp probes plus
    generated theorem documentation were sufficient to review the final
    aliases and self/diagonal simplification behavior.

    A worthwhile example should exercise all three mathematical views rather
    than simply restate theorem signatures:

    - `I(X;Y) = H(X) - H(X|Y)`;
    - `I(X;Y) = H(Y) - H(Y|X)`;
    - `I(X;X) = H(X)` through `mutualInfoOf_self` or the diagonal PMF theorem.

    If a later pedagogical examples pass independently needs this material,
    prefer a small nontrivial finite law; avoid a pure-law example where every
    quantity vanishes. Keep any such example outside the core Shannon modules
    and out of the lightweight root. This note is no longer an active API task.

21. Revisit mutual-information invariance under injective relabeling when a
    second genuine consumer appears; this is not immediate work. The private
    Step 10 helper proves the special case needed there by adjoining a
    deterministic image to its source variable and using entropy invariance
    under an injective map. If later deterministic-processing, sufficient-
    statistic, or channel proofs repeat that argument, extract a coherent
    public theorem family saying that injectively relabeling either random
    variable preserves mutual information, together with PMF coordinate forms
    only when they are used.

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

25. Add ordinary-independence convenience theorems only when concrete
    downstream proofs need them; this is not immediate work. The primary
    design remains PMF-first: `IsIndependent` is equality with the independent
    product of the marginals, and `IsIndependentOf` applies that predicate to
    the mapped joint law. Do not redefine either predicate through mathlib
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

26. Step 17 reviewed the size and import boundary of
    `Shannon.SemanticBridge.Independence` and retained the current module. The
    file combines elementary PMF and
    random-variable independence predicates with the mathlib `IndepFun`
    bridge, KL-based zero-MI equivalences, pair entropy equality cases,
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

27. Revisit conditional-independence ergonomics when the first Markov-chain,
    stochastic-channel, or data-processing proofs create concrete consumers;
    this is not immediate work. Add a small separately importable finite
    example in that phase, preferably a nontrivial common-cause construction,
    that exercises `IsCondIndependentOf`, the positive-fiber characterization,
    and `condMutualInfoOf_eq_zero_iff_isCondIndependentOf`. The example should
    clarify the mathematical contract rather than merely restate theorem
    signatures. During the same pass, expand the doc comment on
    `condMutualInfo_eq_zero_iff_isCondIndependent` to state explicitly that
    null fibers require no chosen conditional law because the primary cross-
    product predicate handles them directly.

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
