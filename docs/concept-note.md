# LeanInfoTheory Concept Note

## Project

Lean-certified finite information theory: a reusable mathlib-based
information-measures and semantic theorem library for downstream mathematical
and verification projects.

## Motivation

Lean already has important fragments of information theory in mathlib, including
binary entropy, q-ary entropy, KL divergence, Markov-kernel infrastructure, and
coding basics such as Kraft-McMillan. PFR and related formalization work show
that Shannon entropy methods can be developed seriously in Lean. What is still
missing is a mature, information-theorist-facing layer for finite entropy,
mutual information, conditional mutual information, KL, finite channels,
Markov structure, data processing, and sufficiency.

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
- Finite-family, channel, Markov, data-processing, Fano, convexity,
  conditional-KL, mutual-independence, and sufficient-statistics APIs.
- A small set of recognizable examples from classical/network information
  theory.
- An isolated, exactly pinned doc-gen4 pipeline that renders and checks
  signatures for the complete supported API, together with versioned website
  staging and a separately authorized publication path.

Certificate expression languages, validators, importers, and checker-specific
demonstrations belong to downstream applications. LeanInfoTheory retains the
general mathematical theorems those applications may consume.

## Current Limitations

- The semantic and Fano layers remain finite-PMF/finite-alphabet focused.
  General measurable extensions, exact Fano equality and sharpness,
  randomized/list decoding, AEP, and source/channel coding remain future work.
- Certificate checking, search, and external-format import are outside the
  LeanInfoTheory release scope.
- Signature-bearing documentation is generated rather than committed; release
  publication requires a clean exact-commit GitHub-source build and the guarded
  manual Pages path.
- Non-toy network converse examples remain a future milestone.

## Funding Use

Funding would support master-student implementation time, AI/formalization tools,
documentation, library maintenance, and collaboration with Lean/mathlib mentors.

## Role Split

The project lead defines the information-theoretic API, theorem targets, and
examples. A Lean/mathlib mentor reviews architecture and upstreamability.
Student contributors can work on bounded Lean tasks such as finite-entropy,
channel, KL, example, and documentation lemmas.
