# Roadmap

This roadmap records planned technical milestones. The homepage, theorem
highlights, and module guide record what is implemented now.

## Now

- Project B Chunk 2 is complete. All 18 steps finished finite KL
  support/equality, uniform-reference identities,
  sharp alphabet- and support-cardinality entropy bounds, and ordinary finite
  independence predicates with their mathlib `IndepFun`, zero-MI, and pair-
  entropy equality bridges, plus positive-fiber zero MI and the cross-product
  definition of conditional independence. Zero conditional MI now exactly
  characterizes conditional independence, and the associated conditional-
  entropy equality cases are closed. The support-sensitive and non-absolutely-
  continuous examples are now separately importable. The API review retained
  the current simp/module boundaries and added only four additive-entropy
  compatibility aliases. The complete milestone build, generated-reference,
  website, and repository hygiene suites pass.
- Select and plan the next focused Project B chunk. The leading candidate is a
  stochastic-channel, Markov, and data-processing dependency layer, with exact
  contracts and mathlib ownership to be settled before implementation.
- Extend the current generated module dependency map and source-derived
  declaration index toward a real theorem-level blueprint, full Lean doc-gen
  output, and blueprint PDF.
- Keep the public website's theorem highlights, module guide, and certificate
  demo aligned with the Lean code as the API evolves.
- Maintain project notes in the foundation conventions and project log.
- Keep the lightweight finite API separated from heavier KL and coding imports.

## 3 Months

- Publish a genuine leanblueprint web page, blueprint PDF, and theorem-level
  dependency graph.
- Upgrade the current source-derived declaration index into full Lean doc-gen
  output, while keeping the hand-written module guide as a stable
  orientation page.
- Link generated docs and blueprint entries back to the curated theorem
  highlights and submodularity demo page.
- Extend the Cover-Thomas Chapter 2 layer toward stochastic data processing,
  sufficient statistics, and Fano after the finite equality infrastructure.

## 6 Months

- Add richer certificate constraints such as independence, functional
  dependence, and Markov constraints.
- Return to richer checked-certificate assumptions and recognizable converse
  steps after the planned Project B foundations are in place.
- Prepare focused mathlib PRs for generic finite-measure lemmas.

## 12 Months

- Add PSITIP/oXitip-style certificate import.
- Formalize selected converse proof skeletons.
- Write a technical report or short paper describing the Lean library and
  certificate pipeline.
- Stabilize project documentation, full Lean doc-gen output, and theorem-level
  blueprint dependency graph.
