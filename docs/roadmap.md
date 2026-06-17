# Roadmap

This roadmap records planned technical milestones. The homepage and current
module list record what is implemented now.

## Now

- Stabilize the finite `PMF`-based Shannon foundation layer.
- Continue finite entropy sanity theorems beyond relabeling invariance.
- Maintain project notes in the foundation conventions and project log.
- Keep the lightweight finite API separated from heavier KL and coding imports.
- Use the semantic bridge module for future KL and conditional-law equivalence
  theorems.

## 3 Months

- Prove that entropy agrees with the expected self-information formula.
- Design finite conditional laws with careful zero-probability behavior.
- Prove bridge theorems from mutual information to mathlib KL divergence.
- Extend the current primitive-only checked certificate path beyond the
  submodularity demo.

## 6 Months

- Connect conditional entropy and conditional mutual information to
  conditional-law or KL-chain-rule semantics.
- Add richer certificate constraints such as independence, functional
  dependence, and Markov constraints.
- Certify several textbook entropy inequalities.
- Prepare focused mathlib PRs for generic finite-measure lemmas.

## 12 Months

- Add PSITIP/oXitip-style certificate import.
- Formalize selected converse proof skeletons.
- Write a technical report or short paper describing the Lean library and
  certificate pipeline.
- Stabilize project documentation, API docs, and blueprint dependency graph.
