/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import Mathlib.Data.ENNReal.BigOperators
import Mathlib.Data.ENNReal.Real
import Mathlib.Probability.ProbabilityMassFunction.Basic
import Mathlib.Probability.ProbabilityMassFunction.Constructions

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

/--
If `f` is injective, pushing a PMF forward along `f` preserves the mass of each
source atom at its image.
-/
theorem map_apply_of_injective {alpha : Type u} {beta : Type*}
    (p : PMF alpha) {f : alpha -> beta} (hf : Function.Injective f) (a : alpha) :
    p.map f (f a) = p a := by
  have hpre : f ⁻¹' ({f a} : Set beta) = ({a} : Set alpha) := by
    ext x
    constructor
    · intro hx
      exact hf (by simpa using hx)
    · intro hx
      rw [hx]
      rfl
  calc
    p.map f (f a) =
        (p.map f).toOuterMeasure ({f a} : Set beta) := by
      exact (PMF.toOuterMeasure_apply_singleton (p := p.map f) (f a)).symm
    _ = p.toOuterMeasure (f ⁻¹' ({f a} : Set beta)) := by
      rw [PMF.toOuterMeasure_map_apply]
    _ = p.toOuterMeasure ({a} : Set alpha) := by
      rw [hpre]
    _ = p a := by
      exact PMF.toOuterMeasure_apply_singleton (p := p) a

/--
If a target atom is outside the range of a map, then the pushed-forward PMF
assigns zero mass to that atom.
-/
theorem map_apply_eq_zero_of_notMem_range {alpha : Type u} {beta : Type*}
    (p : PMF alpha) {f : alpha -> beta} {b : beta} (hb : b ∉ Set.range f) :
    p.map f b = 0 := by
  have hpre : f ⁻¹' ({b} : Set beta) = (∅ : Set alpha) := by
    ext x
    constructor
    · intro hx
      exfalso
      exact hb ⟨x, by simpa using hx⟩
    · intro hx
      cases hx
  calc
    p.map f b =
        (p.map f).toOuterMeasure ({b} : Set beta) := by
      exact (PMF.toOuterMeasure_apply_singleton (p := p.map f) b).symm
    _ = p.toOuterMeasure (f ⁻¹' ({b} : Set beta)) := by
      rw [PMF.toOuterMeasure_map_apply]
    _ = p.toOuterMeasure (∅ : Set alpha) := by
      rw [hpre]
    _ = 0 := by
      simp

/--
Pushing a PMF forward along an equivalence preserves the mass of each atom at
the renamed atom.
-/
theorem map_apply_equiv {alpha : Type u} {beta : Type*}
    (p : PMF alpha) (e : alpha ≃ beta) (a : alpha) :
    p.map e (e a) = p a :=
  map_apply_of_injective p e.injective a

end PMF
