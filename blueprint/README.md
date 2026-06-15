# Blueprint

This blueprint is the project map for LeanInfoTheory. It is intentionally short
for the current foundation stage; the next step is to turn this into a
generated blueprint site with theorem dependencies once semantic bridge
theorems start landing.

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

## Layer 2: Algebraic Entropy Expressions

- entropy atoms indexed by finite sets of variable names
- rational linear combinations of atoms
- semantic evaluation into real entropy values
- normalization and comparison of expressions

## Layer 3: Certificates

- elemental inequality basis
- nonnegative linear-combination certificates
- soundness theorem for certified inequalities
- import path for PSITIP/oXitip-style certificates

## Layer 4: Network Information Theory

- data-processing examples
- Fano-style converse skeletons
- cut-set and multi-terminal converse examples
- selected source/channel coding definitions after the finite-measure layer is stable
