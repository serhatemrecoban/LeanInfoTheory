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

The generated map currently records 23 local Lean modules, 32 local import
edges, 11 modules reachable from the lightweight root import
`LeanInfoTheory`, and 12 modules that are intentionally separately importable.
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

The generated index currently records 316 public declarations across 20
modules with declarations. The kind breakdown is 230 theorems/lemmas, 77
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

The near-term theorem/certificate plan above is now complete. The next focused
Lean phase should be chosen explicitly rather than assumed. Items not completed
by that phase, such as finite-family entropy, richer certificate assumptions,
external certificate import, coding-theory layers, theorem-level blueprint
work, and substantial mathlib PR preparation, should remain later work until a
new focused plan moves one of them into active development.

1. Keep the finite-family entropy API delayed until pair/triple APIs and
    semantic bridge proofs clarify the right representation. The main open
    question is whether the API should be indexed by `Fin n`, finite sets of
    variable names, dependent finite alphabets, vectors, or another
    mathlib-friendly structure.

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

3. Keep imports light in the core finite Shannon files. Heavy bridge files can
    import KL divergence, kernels, conditional probability, and coding theory
    only when those APIs are actually needed.

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
    extensions of the primitive certificate layer.

12. Add primitive-recognition/autotagging only after the manually tagged
    certificate pipeline has been exercised on larger examples. The step 8
    ergonomics review added a generic raw-validator soundness helper, but did
    not show enough pressure to justify primitive recognition yet. The current
    validator checks a raw expression against a supplied `PrimitiveIneq.Kind`;
    a later ergonomic layer could try to infer primitive tags from normalized
    entropy expressions, for example recognizing
    `H(A,C) + H(B,C) - H(A,B,C) - H(C)` as conditional mutual information.
    This recognition layer should remain outside the trusted core: it may
    propose tags, but the existing exact equality checker must still verify
    them.

13. Add PSITIP/oXitip-style certificate import only after the internal checked
    certificate format is stable. The first parser should target a small,
    explicit external format and should never be part of the trusted kernel.

14. Revisit public semantic theorem aliases after more theorem pressure. The
    July 6 API polish pass deferred aliases for results like
    `mutualInfo_chain_rule_fst` because the current names are descriptive and
    the semantic theorem layer is still small. The July 8 theorem pass added
    `mutualInfo_map_swap`, `mutualInfoOf_swap`,
    `condMutualInfo_map_swap12`, and `condMutualInfoOf_swap`, but aliases
    should still wait until we have several chain rules and downstream examples
    that show which names users naturally reach for.

15. Revisit `[simp]` status for mutual-information and
    conditional-mutual-information symmetry after the symmetry and chain-rule
    API has more theorem pressure. The PMF-level swap-normalization theorem
    `mutualInfo_map_swap`, whose left-hand side contains the visibly more
    complicated expression `mutualInfo (p.map Prod.swap)`, is a plausible
    future simp lemma because it rewrites an explicit coordinate swap back to
    the canonical unswapped joint law. The CMI symmetry theorem
    `condMutualInfo_map_swap12` should be evaluated similarly because it
    normalizes an explicit `swap12` map to the canonical `I(A;B|C)`
    orientation. In contrast,
    pure random-variable commutativity statements such as
    `mutualInfoOf p Y X = mutualInfoOf p X Y` need more care, because both
    sides have the same syntactic shape and an automatic rewrite could choose
    an arbitrary orientation or interact poorly with later chain-rule rewrites.
    Before adding `[simp]`, test the candidate lemmas on the next few
    chain-rule, CMI-symmetry, and conditioning-reduces-entropy proofs. Promote
    only rewrites that reduce explicit coordinate maps or projections to a
    canonical form, do not create rewrite loops, and make ordinary `simp`
    calls more predictable.

16. Revisit `[simp]` status for conditional entropy chain-rule theorems after
    the chain-rule family has more downstream examples. The July 8 chain-rule
    step deliberately kept
    `entropy_eq_entropy_sndMarginal_add_condEntropy`,
    `entropy_eq_entropy_fstMarginal_add_condEntropy_swap`, and the
    random-variable variants explicit rather than marking them `[simp]`.
    These theorems rewrite between mathematically equivalent but differently
    useful normal forms, such as `H(A,B)` and `H(B) + H(A|B)`, so automatic
    simplification could make proofs noisier or choose a direction too early.
    Reconsider this only after the mutual-information chain-rule variants,
    conditioning-reduces-entropy theorem, and a few certificate or example
    proofs show whether the library wants a canonical entropy-expanded normal
    form. If a direction is promoted, prefer one that reliably reduces proof
    search and does not fight later chain-rule rewrites.

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
    `lake build LeanInfoTheory.Shannon.SemanticBridge`,
    `lake build LeanInfoTheory.MathlibFragments`,
    `lake build LeanInfoTheory.Certificate.Submodularity`,
    `lake build LeanInfoTheory.Certificate.Subadditivity`,
    `lake build LeanInfoTheory.Certificate.Monotonicity`, and
    `lake build LeanInfoTheory.Examples`, plus the website generators and
    checks when public declarations or imports changed.
