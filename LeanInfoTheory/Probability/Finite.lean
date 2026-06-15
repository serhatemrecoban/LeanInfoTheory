/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import Mathlib.Data.ENNReal.BigOperators
import Mathlib.Data.ENNReal.Real
import Mathlib.Probability.ProbabilityMassFunction.Basic

/-!
# Finite real-mass lemmas for PMFs

This file adds small bridge lemmas from mathlib's `ENNReal`-valued `PMF`
masses to the real-valued finite sums used by Shannon entropy. The probability
object itself remains mathlib's `PMF`.
-/

namespace PMF

universe u

open scoped BigOperators ENNReal

variable {α : Type u}

/-- Each atom of a `PMF` has nonnegative real mass. -/
theorem toReal_nonneg (p : PMF α) (a : α) : 0 <= (p a).toReal :=
  ENNReal.toReal_nonneg

/-- Each atom of a `PMF` has real mass at most one. -/
theorem toReal_le_one (p : PMF α) (a : α) : (p a).toReal <= 1 := by
  simpa using ENNReal.toReal_mono ENNReal.one_ne_top (p.coe_le_one a)

/-- On a finite type, the real masses of a `PMF` sum to one. -/
theorem sum_toReal [Fintype α] (p : PMF α) : (∑ a, (p a).toReal) = 1 := by
  classical
  -- `ENNReal.toReal_sum` requires every finite summand to be different from `∞`.
  have hfinite : forall a, a ∈ (Finset.univ : Finset α) -> p a ≠ ∞ := by
    intro a _ha
    exact p.apply_ne_top a
  calc
    (∑ a, (p a).toReal) = (∑ a, p a).toReal := by
      simpa using
        (ENNReal.toReal_sum (s := Finset.univ) (f := fun a => p a) hfinite).symm
    _ = (1 : ENNReal).toReal := by
      -- A PMF has total `ENNReal` mass one; after the previous line we can convert that total.
      have hsum : (∑ a, p a) = (1 : ENNReal) := by
        simpa using p.tsum_coe
      rw [hsum]
    _ = 1 := by
      simp

end PMF
