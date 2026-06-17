# Project Log

This log records the project history and design notes at a useful level of
detail. It is not meant to list every small command or proof attempt. It should
help a future contributor understand what has been built, why the files are
organized as they are, and which ideas are waiting for the right moment.

## Current File Organization

- `LeanInfoTheory.lean`: lightweight public library entry point. It imports
  the stable finite-Shannon, certificate-facing, and current example modules,
  but not the heavy KL/coding anchor files.
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
- `LeanInfoTheory/Certificate/Submodularity.lean`: first non-toy
  certificate demonstration, proving entropy submodularity from a validated
  conditional-mutual-information certificate.
- `LeanInfoTheory/Examples.lean`: small examples that exercise the current API.
- `LeanInfoTheory/InformationMeasures.lean`: compatibility/re-export module for
  the finite Shannon definitions.
- `LeanInfoTheory/MathlibFragments.lean`: heavier mathlib anchors we expect to
  connect to later, such as KL divergence, KL chain rules, binary/q-ary
  entropy, and Kraft-McMillan. This module is separately importable and should
  not be treated as part of the lightweight foundation import surface.
- `LeanInfoTheory/Probability/Finite.lean`: finite `PMF` real-mass bridge
  lemmas, kept in the `PMF` namespace and deliberately small.
- `LeanInfoTheory/Shannon/Entropy.lean`: finite Shannon entropy, entropy of
  finite-valued random variables via `PMF.map`, and first entropy sanity
  theorems such as relabeling invariance.
- `LeanInfoTheory/Shannon/InfoMeasures.lean`: marginals, conditional entropy,
  mutual information, conditional mutual information, and basic rewrite lemmas.
- `LeanInfoTheory/Shannon/SemanticBridge.lean`: heavier bridge module for
  future KL-divergence and conditional-law equivalence theorems.
- `blueprint/`: project-map notes for theorem dependencies and future
  generated blueprint pages.
- `docs/`: human-facing design notes, roadmap notes, foundation conventions,
  external review notes, and this project log.
- `home_page/`: static website files for the project site.
- `.github/workflows/`: CI, docs, release, and update workflows.
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
Shannon API. The new file `LeanInfoTheory/Shannon/SemanticBridge.lean` imports
the finite information-measure API together with mathlib's KL divergence and
KL chain-rule files. It is currently a compiled scaffold for future bridge
theorem statements rather than a source of weak placeholder theorems.

The root `LeanInfoTheory.lean` no longer imports `LeanInfoTheory.MathlibFragments`.
This keeps ordinary project imports focused on the finite Shannon and
certificate-facing foundations. Heavy anchors such as KL divergence,
Kraft-McMillan, kernels, and conditional probability remain available through
separately importable files when we work on the semantic bridge or coding
theory layers.

Near-term bridge theorem targets remain:

- identify `mutualInfo` with KL divergence from the joint law to the product of
  the marginals;
- identify `condEntropy` with expected entropy of finite conditional laws;
- identify `condMutualInfo` with KL chain-rule or averaged conditional-KL
  expressions;
- decide how zero-probability conditioning events should be represented in a
  way that agrees with mathlib's measure-theoretic conventions.

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
step-by-step history above.

1. Make the namespace policy explicit. Definitions currently live in
   `LeanInfoTheory.Shannon`, and `LeanInfoTheory.InformationMeasures` exports
   them into `LeanInfoTheory`. Before there are many more names, decide whether
   examples and documentation should prefer names such as `Shannon.entropy` or
   exported names such as `LeanInfoTheory.entropy`. The same decision should
   be made for theorem-facing certificate results: for example, decide whether
   results currently named under namespaces such as
   `Certificate.Submodularity.entropy_submodularity` should later receive
   cleaner public aliases outside the certificate-demo namespace.

2. Continue monitoring the top-level import surface. The root
   `LeanInfoTheory.lean` no longer imports the heavy `MathlibFragments` anchor
   file, but it still imports examples and the current certificate demo module.
   Before the project grows much further, decide whether examples and
   certificate demos should remain in the root import or become separately
   importable development aids.

3. Revisit which coordinate-orientation lemmas should be marked `[simp]`.
   They are currently explicit lemmas, not global simp lemmas, to avoid
   surprising simplifier behavior. Promote only the ones that prove harmless
   after more theorem pressure.

4. Prove the semantic bridge for `entropy`, connecting the finite
   `Real.negMulLog` sum to the expected self-information or the corresponding
   measure-theoretic expression over `PMF.toMeasure`.

5. Design the finite conditional-law API carefully. In particular, decide how
   zero-probability conditioning events should be represented. Rocq chooses a
   default finite distribution, but mathlib already has measure-level
   conditioning conventions, so copying Rocq directly may create friction.

6. Prove that `condEntropy` agrees with the expected entropy of finite
   conditional laws once the conditional-law representation is chosen.

7. Prove that `mutualInfo` agrees with `InformationTheory.klDiv` from the joint
   law to the product of its marginals. This should live in
   `LeanInfoTheory/Shannon/SemanticBridge.lean` or a later subfile of it.

8. Prove that `condMutualInfo` agrees with a KL chain-rule expression or an
   averaged conditional-KL expression. The existing `SemanticBridge` file
   already imports mathlib's KL chain-rule API for this purpose.

9. Add the remaining value-level orientation theorem for finite entropy:
   product reassociation. Entropy invariance under equivalences, injective
   relabelings, and pair-coordinate swap is now implemented in
   `LeanInfoTheory/Shannon/Entropy.lean`.

10. Keep the finite-family entropy API delayed until pair/triple APIs and
    semantic bridge proofs clarify the right representation. The main open
    question is whether the API should be indexed by `Fin n`, finite sets of
    variable names, dependent finite alphabets, vectors, or another
    mathlib-friendly structure.

11. Split `LeanInfoTheory/Shannon/InfoMeasures.lean` only when the file becomes
    too large or theorem pressure makes the boundaries clear. A likely future
    layout is `Marginals`, `ConditionalEntropy`, `MutualInfo`,
    `ConditionalMutualInfo`, and one or more heavier semantic bridge files.

12. Keep imports light in the core finite Shannon files. Heavy bridge files can
    import KL divergence, kernels, conditional probability, and coding theory
    only when those APIs are actually needed.

13. Treat `LeanInfoTheory/MathlibFragments.lean` as a separately importable
    anchor and checklist for upstream APIs, not as part of the lightweight
    public import surface.

14. Add coding-theory material, including Kraft-McMillan connections, in a
    later coding-oriented layer rather than in the finite Shannon foundation.

15. Upstream conservatively to mathlib. Small generic lemmas can go earlier,
    but substantial `InformationTheory` definitions should wait until local
    names, assumptions, and theorem statements have stabilized.

16. Keep PSITIP/oXitip-style certificate infrastructure local unless mathlib
    maintainers specifically want a generic certificate framework.

### Do Soon After The Immediate Layer

17. Add the remaining finite entropy sanity theorems that information theorists
    expect: entropy upper bounds by the logarithm of alphabet size and the
    uniform-law equality case. Entropy invariance under equivalences and
    injective relabelings is now in the finite Shannon entropy API.

### Do Later

18. Review the private PMF helper lemmas from entropy relabeling invariance.
    The proof of finite entropy invariance under injective relabeling currently
    uses private helper lemmas in `LeanInfoTheory/Shannon/Entropy.lean`,
    morally saying that if `f : alpha -> beta` is injective, then
    `(p.map f) (f a) = p a`, and if `b` is outside the range of `f`, then
    `(p.map f) b = 0`. These are potentially useful beyond entropy, especially
    for future finite-support, marginal, conditioning, and semantic bridge
    proofs. Keep them private for now to avoid prematurely enlarging the public
    API, but if they are reused in another module, consider promoting them to a
    stable public location, likely in the `PMF` namespace or a finite
    PMF support/mapping helper file. Before promotion, search mathlib again for
    existing equivalent lemmas and choose names consistent with mathlib's
    `PMF.map` API.

19. Add generated API documentation once the Lean API is stable enough. Until
    then, keep the current docs page described as a module list rather than as
    generated declaration documentation. When doc generation is added, link the
    homepage and docs page directly to declarations and important modules.

20. Add a minimal contributor surface before inviting broader collaboration:
    `CONTRIBUTING.md`, beginner-friendly tasks, issue labels, and a short note
    about which components may eventually be proposed upstream to mathlib.

21. Add advanced certificate constraints after the primitive-only checker
    remains stable under a little more theorem pressure. Independence
    constraints, functional-dependence constraints, and Markov constraints are
    essential for network converses, but they should be introduced as explicit
    extensions of the primitive certificate layer.

22. Add primitive-recognition/autotagging only after the manually tagged
    certificate pipeline has been exercised on several examples. The current
    validator checks a raw expression against a supplied `PrimitiveIneq.Kind`;
    a later ergonomic layer could try to infer primitive tags from normalized
    entropy expressions, for example recognizing
    `H(A,C) + H(B,C) - H(A,B,C) - H(C)` as conditional mutual information.
    This recognition layer should remain outside the trusted core: it may
    propose tags, but the existing exact equality checker must still verify
    them.

23. Add PSITIP/oXitip-style certificate import only after the internal checked
    certificate format is stable. The first parser should target a small,
    explicit external format and should never be part of the trusted kernel.

24. Expand website polish after the next mathematical milestone. A richer
    status table, architecture diagram, collaboration page, and demo section
    will be more meaningful after the project has both the submodularity demo,
    finite-entropy relabeling invariance, and either a semantic bridge theorem
    or an entropy upper-bound theorem to show.
