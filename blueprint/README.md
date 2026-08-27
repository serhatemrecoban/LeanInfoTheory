# Blueprint

This blueprint is the project map for LeanInfoTheory. The website now includes
a generated module-level dependency map produced from Lean `import` lines by
`scripts/generate_website_blueprint.py`. The website also has a source-derived
declaration index from `scripts/generate_website_api_index.py`. The complete
supported API is rendered and validated with an isolated, pinned doc-gen4
build and assembled at the stable versioned website route. A theorem-level
blueprint and blueprint PDF remain later milestones.

## Layer 0: Existing Foundations

- mathlib binary and q-ary entropy
- mathlib KL divergence and KL chain-rule infrastructure
- mathlib PMFs, finite measures, Markov kernels, and coding foundations
- PFR-style entropy and mutual-information infrastructure to audit

## Layer 1: Finite Information Measures

- finite random variables / finite PMFs
- entropy `H[X]`
- joint entropy `H[X,Y]`
- conditional entropy `H[X|Y]`
- mutual information `I[X;Y]`
- conditional mutual information `I[X;Y|Z]`
- equivalence between algebraic entropy definitions and textbook conditional
  distribution / KL-divergence definitions

## Layer 2: Semantic Bridges and Finite Theorems

- finite conditional laws and expected-fiber formulas
- KL interpretations and support-aware equality theorems
- independence, conditional independence, and Markov characterizations
- finite stochastic-channel data processing and sufficiency
- finite-family Shannon inequalities and mutual independence
- finite Fano, log-sum, entropy concavity, and KL-convexity results

## Layer 3: Documentation and Downstream Use

- focused public imports, a lightweight mathematical root, and the complete
  import-only `LeanInfoTheory.Shannon` umbrella
- source-derived module and declaration references
- signature-bearing generated API documentation with exact-commit source links
  and versioned website staging
- theorem-level blueprint pages
- downstream applications built against tagged releases

## Layer 4: Network Information Theory

- data-processing examples
- Fano-style converse skeletons
- cut-set and multi-terminal converse examples
- selected source/channel coding definitions after the finite-measure layer is stable
