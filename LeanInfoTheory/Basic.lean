/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import Mathlib.Analysis.SpecialFunctions.BinaryEntropy
import Mathlib.InformationTheory.Coding.KraftMcMillan
import Mathlib.InformationTheory.KullbackLeibler.Basic
import Mathlib.Probability.ProbabilityMassFunction.Constructions

/-!
# LeanInfoTheory

This file collects the mathlib information-theory fragments that the project
will build on. The project is intentionally mathlib-based: finite probability
mass functions, binary entropy, KL divergence, and coding-theory foundations
come from mathlib rather than from an ad-hoc probability model.
-/

namespace LeanInfoTheory

/-- Public project name used by documentation and the website. -/
def projectName : String := "LeanInfoTheory"

/-- A small status vocabulary for roadmap items and generated documentation. -/
inductive Status where
  | scaffolded
  | inProgress
  | planned
  | upstreamCandidate
  deriving DecidableEq, Repr

/-- The pinned mathlib already proves the binary entropy value at a fair bit. -/
theorem binaryEntropy_fair_bit : Real.binEntropy (2 : Real)⁻¹ = Real.log 2 :=
  Real.binEntropy_two_inv

end LeanInfoTheory
