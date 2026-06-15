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
  certificate-style reasoning.
- `LeanInfoTheory/Certificate.lean`: certificate primitives and soundness
  scaffolding for entropy inequalities.
- `LeanInfoTheory/Examples.lean`: small examples that exercise the current API.
- `LeanInfoTheory/InformationMeasures.lean`: compatibility/re-export module for
  the finite Shannon definitions.
- `LeanInfoTheory/MathlibFragments.lean`: heavier mathlib anchors we expect to
  connect to later, such as KL divergence, KL chain rules, binary/q-ary
  entropy, and Kraft-McMillan. This module is separately importable and should
  not be treated as part of the lightweight foundation import surface.
- `LeanInfoTheory/Probability/Finite.lean`: finite `PMF` real-mass bridge
  lemmas, kept in the `PMF` namespace and deliberately small.
- `LeanInfoTheory/Shannon/Entropy.lean`: finite Shannon entropy and entropy of
  finite-valued random variables via `PMF.map`.
- `LeanInfoTheory/Shannon/InfoMeasures.lean`: marginals, conditional entropy,
  mutual information, conditional mutual information, and basic rewrite lemmas.
- `LeanInfoTheory/Shannon/SemanticBridge.lean`: heavier bridge module for
  future KL-divergence and conditional-law equivalence theorems.
- `blueprint/`: project-map notes for theorem dependencies and future
  generated blueprint pages.
- `docs/`: human-facing design notes, roadmap notes, foundation conventions,
  and this project log.
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
   exported names such as `LeanInfoTheory.entropy`.

2. Continue monitoring the top-level import surface. The root
   `LeanInfoTheory.lean` no longer imports the heavy `MathlibFragments` anchor
   file, but it still imports examples. Before the project grows much further,
   decide whether examples should remain in the root import or become
   separately importable development aids.

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

9. Add entropy invariance and orientation theorems that are about values rather
   than marginals alone: invariance under equivalences, injective relabelings,
   coordinate swap, and product reassociation.

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
