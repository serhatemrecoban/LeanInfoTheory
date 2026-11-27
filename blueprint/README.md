# Blueprint

The [theorem blueprint](https://serhatemrecoban.github.io/LeanInfoTheory-Blueprint/)
opens the edition for the latest published release. The
[v0.3.0 edition](https://serhatemrecoban.github.io/LeanInfoTheory-Blueprint/v0.3.0/)
covers all 918 public declarations in 77 supported modules. Each entry has its Lean name,
inputs, mathematical statement, and links to its formal declaration and tagged source.
The exact-size Neyman–Pearson entry also links to a worked proof.
Its [PDF](https://serhatemrecoban.github.io/LeanInfoTheory-Blueprint/v0.3.0/blueprint.pdf)
contains the same mathematical statements and worked proof. The separate [module map](https://serhatemrecoban.github.io/LeanInfoTheory/blueprint/dep_graph_document.html)
is generated from Lean imports. The layers below outline the wider project.

### Build an edition

Keep mathematical statements in `blueprint/versions/<release-tag>/statements/`,
one JSON object per declaring module keyed by full Lean name. `module-titles.json` also
covers the import-only modules. The generator checks exact coverage against the
tagged public manifest and reads binders and immutable source links from the release
API. The browser search index, web pages and printable book share the same entries.
With GitHub CLI and Chrome, Chromium or Edge installed, run:

```sh
python scripts/build_theorem_blueprint.py --output PATH_TO_BLUEPRINT_REPO/site
```

Use `--api-root PATH` to build from a local copy of the versioned doc-gen site.
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
