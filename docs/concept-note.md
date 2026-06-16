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

- A public mathlib-based Lean repository with CI and a current module list.
- A finite information-measures API connected to existing mathlib/PFR work.
- A formal entropy-expression layer for rational linear combinations of entropy
  atoms.
- An abstract Shannon entropy-valuation layer for certificate-facing semantic
  assumptions.
- A generic Lean-checked soundness theorem for nonnegative certificate
  combinations.
- A small set of recognizable examples from classical/network information
  theory.

## Current Limitations

- Semantic KL and conditional-law bridge theorems are planned, not yet proved.
- The certificate layer is a soundness skeleton, not yet a full checked
  certificate pipeline.
- Generated API documentation and non-toy network converse examples are future
  milestones.

## Funding Use

Funding would support master-student implementation time, AI/formalization tools,
documentation, library maintenance, and collaboration with Lean/mathlib mentors.

## Role Split

The project lead defines the information-theoretic API, theorem targets, and
examples. A Lean/mathlib mentor reviews architecture and upstreamability.
Student contributors can work on bounded Lean tasks such as expression
normalization, certificate import, and finite-entropy lemmas.
