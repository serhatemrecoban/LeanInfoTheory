/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Basic

/-!
# Finite information-measure API targets

This file records the semantic layer the project is aiming at. It deliberately
uses mathlib's `PMF` for finite distributions and `Real` for information values.
The concrete entropy/MI definitions should eventually be connected to mathlib or
PFR-style entropy infrastructure; the certificate layer can already be developed
against this interface.
-/

namespace LeanInfoTheory

universe u

/-- Finite probability distributions are represented by mathlib PMFs. -/
abbrev FinitePMF (alpha : Type u) [Fintype alpha] := PMF alpha

/--
An interface for finite Shannon information measures.

This is an API target rather than a claimed implementation. Keeping it as a
structure lets the certificate layer state what semantic data it expects without
pretending that the full entropy theory has already been formalized here.
-/
structure FiniteInfoAPI where
  entropy :
    {alpha : Type u} -> [Fintype alpha] -> FinitePMF alpha -> Real
  jointEntropy :
    {alpha beta : Type u} -> [Fintype alpha] -> [Fintype beta] ->
      FinitePMF (alpha × beta) -> Real
  condEntropy :
    {alpha beta : Type u} -> [Fintype alpha] -> [Fintype beta] ->
      FinitePMF (alpha × beta) -> Real
  mutualInfo :
    {alpha beta : Type u} -> [Fintype alpha] -> [Fintype beta] ->
      FinitePMF (alpha × beta) -> Real
  condMutualInfo :
    {alpha beta gamma : Type u} -> [Fintype alpha] -> [Fintype beta] -> [Fintype gamma] ->
      FinitePMF (alpha × beta × gamma) -> Real

/-- Project-local alias for mathlib's binary entropy function. -/
noncomputable def binaryEntropy (p : Real) : Real :=
  Real.binEntropy p

@[simp]
theorem binaryEntropy_zero : binaryEntropy 0 = 0 := by
  simp [binaryEntropy]

@[simp]
theorem binaryEntropy_one : binaryEntropy 1 = 0 := by
  simp [binaryEntropy]

theorem binaryEntropy_fair_bit' : binaryEntropy (2 : Real)⁻¹ = Real.log 2 := by
  change Real.binEntropy (2 : Real)⁻¹ = Real.log 2
  exact binaryEntropy_fair_bit

end LeanInfoTheory
