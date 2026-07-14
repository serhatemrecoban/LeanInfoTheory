# LeanInfoTheory Concept Note

## Project

Lean-certified classical and network information theory: a reusable finite
information-measures layer, with a planned path toward AI-assisted,
machine-checked entropy-inequality and converse automation.

## Motivation

Lean already has important fragments of information theory in mathlib, including
binary entropy, q-ary entropy, KL divergence, Markov-kernel infrastructure, and
coding basics such as Kraft-McMillan. PFR and related formalization work show
that Shannon entropy methods can be developed seriously in Lean. What is still
missing is a mature, information-theorist-facing layer for finite entropy,
mutual information, conditional mutual information, and certified
network-information-theory converse proofs.

## Current and Near-Term Deliverables

- A public mathlib-based Lean repository with CI and a current module guide.
- A finite information-measures API connected to existing mathlib/PFR work.
- Finite entropy sanity theorems for relabeling, coordinate swaps,
  reassociation, the logarithmic upper bound, and the uniform-law equality case.
- Semantic bridge theorems proving finite entropy as expected self-information
  over `PMF.toMeasure`, mutual information as KL divergence, conditional
  entropy as expected fiber entropy, conditional mutual information as averaged
  fiber mutual information and averaged fiber KL, semantic nonnegativity, and
  a first mutual-information chain rule.
- A formal entropy-expression layer for rational linear combinations of entropy
  atoms.
- An abstract Shannon entropy-valuation layer for certificate-facing semantic
  assumptions.
- Primitive Shannon inequality expressions for empty entropy, conditional
  entropy, and conditional mutual information, with soundness theorems under
  abstract Shannon entropy valuations.
- A generic Lean-checked soundness theorem for nonnegative certificate
  combinations.
- A first raw/checked certificate split, where checked certificates use
  primitive Shannon ingredients, nonnegative rational coefficients, and the
  proof data needed for soundness.
- Exact rational expression matching for checked certificate decompositions.
- A first raw-to-checked validator for primitive-tagged certificate steps.
- Checked certificate demos proving entropy submodularity, subadditivity,
  one-variable monotonicity, and three-way subadditivity.
- A small set of recognizable examples from classical/network information
  theory.

## Current Limitations

- The semantic bridge is still finite-PMF focused; general stochastic data
  processing, independence equality cases, Fano, AEP, and source/channel
  coding are future work.
- The certificate layer checks and validates certificates, but it does not yet
  search for certificates automatically.
- The certificate layer is not yet a full import pipeline for external
  certificate formats such as PSITIP/oXitip output.
- Independence, Markov, and functional-dependence constraints are not yet part
  of the checked certificate language.
- Full Lean doc-gen output and non-toy network converse examples are future
  milestones.

## Funding Use

Funding would support master-student implementation time, AI/formalization tools,
documentation, library maintenance, and collaboration with Lean/mathlib mentors.

## Role Split

The project lead defines the information-theoretic API, theorem targets, and
examples. A Lean/mathlib mentor reviews architecture and upstreamability.
Student contributors can work on bounded Lean tasks such as expression
normalization, certificate import, and finite-entropy lemmas.
