/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.Finite
import Mathlib.Analysis.SpecialFunctions.Log.NegMulLog
import Mathlib.Probability.ProbabilityMassFunction.Constructions

/-!
# Finite Shannon entropy

Entropy is measured in nats. For a finite `PMF`, the definition is the
finite sum of mathlib's `Real.negMulLog` over the real masses of the atoms.
This follows the same mathematical convention as Rocq `infotheo`: entropy is
first a function of a finite distribution, and random-variable entropy is then
defined by pushing a distribution forward along the random variable.
-/

namespace LeanInfoTheory
namespace Shannon

open scoped BigOperators

universe u v w

noncomputable section

/-- Shannon entropy, in nats, of a finite probability mass function. -/
def entropy {alpha : Type u} [Fintype alpha] (p : PMF alpha) : Real :=
  ∑ a, Real.negMulLog (p a).toReal

/-- The defining finite-sum formula for Shannon entropy. -/
theorem entropy_eq_sum {alpha : Type u} [Fintype alpha] (p : PMF alpha) :
    entropy p = ∑ a, Real.negMulLog (p a).toReal :=
  rfl

/-- Shannon entropy is nonnegative for finite PMFs. -/
theorem entropy_nonneg {alpha : Type u} [Fintype alpha] (p : PMF alpha) :
    0 <= entropy p := by
  classical
  rw [entropy_eq_sum]
  -- Each summand is nonnegative because every real PMF mass lies in `[0, 1]`.
  exact Finset.sum_nonneg fun a _ha =>
    Real.negMulLog_nonneg
      (PMF.toReal_nonneg p a)
      (PMF.toReal_le_one p a)

/-- A deterministic finite PMF has entropy zero. -/
@[simp]
theorem entropy_pure {alpha : Type u} [Fintype alpha] (a : alpha) :
    entropy (PMF.pure a) = 0 := by
  classical
  rw [entropy_eq_sum]
  apply Finset.sum_eq_zero
  intro x _hx
  -- The selected atom has mass one and every other atom has mass zero.
  by_cases hx : x = a
  · simp [PMF.pure_apply, hx]
  · simp [PMF.pure_apply, hx]

/-- Entropy of a finite-valued random variable under a discrete law. -/
def entropyOf {omega : Type u} {alpha : Type v} [Fintype alpha]
    (p : PMF omega) (X : omega -> alpha) : Real :=
  entropy (p.map X)

@[simp]
theorem entropyOf_id {alpha : Type u} [Fintype alpha] (p : PMF alpha) :
    entropyOf p id = entropy p := by
  simp [entropyOf, PMF.map_id]

/-- Joint entropy is entropy of a joint finite distribution. -/
abbrev jointEntropy {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta] (p : PMF (alpha × beta)) : Real :=
  entropy p

/-- Joint entropy of two finite-valued random variables under a discrete law. -/
def jointEntropyOf {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta]
    (p : PMF omega) (X : omega -> alpha) (Y : omega -> beta) : Real :=
  entropyOf p fun omega => (X omega, Y omega)

end

end Shannon
end LeanInfoTheory
