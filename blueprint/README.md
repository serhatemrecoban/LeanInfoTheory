# Blueprint

The [theorem blueprint](https://serhatemrecoban.github.io/LeanInfoTheory-Blueprint/)
opens the edition for the latest published release. The
[v0.3.0 edition](https://serhatemrecoban.github.io/LeanInfoTheory-Blueprint/v0.3.0/)
begins with finite hypothesis testing and the exact-size Neyman–Pearson theorem.
Its [PDF](https://serhatemrecoban.github.io/LeanInfoTheory-Blueprint/v0.3.0/blueprint.pdf)
uses the same chapter text. The separate [module map](https://serhatemrecoban.github.io/LeanInfoTheory/blueprint/dep_graph_document.html)
is generated from Lean imports. The layers below outline the wider project.

### Build an edition

Keep the chapter HTML under `blueprint/versions/<release-tag>/`. Link each
result to its versioned API declaration and the proof at the release commit.
The build reads the chapters in filename order and prints the HTML to PDF.
With GitHub CLI and Chrome, Chromium or Edge installed, run:

```sh
python scripts/build_theorem_blueprint.py --output PATH_TO_BLUEPRINT_REPO/site
```

The build asks GitHub for LeanInfoTheory’s latest published release and
requires matching chapter sources. It writes the stable entry and that
edition’s files, preserving other release directories. Review the HTML and
PDF before publishing through the companion repository’s manual Pages workflow.

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
