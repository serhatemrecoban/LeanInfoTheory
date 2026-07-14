/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.KL

/-!
# Non-absolutely-continuous KL example

This opt-in module records the finite PMF example that makes the support guard
on real-valued KL equality essential. Two disjoint pure laws have infinite
`ENNReal`-valued KL divergence, but applying `ENNReal.toReal` to that value
returns zero even though the laws are unequal.
-/

namespace LeanInfoTheory
namespace Examples
namespace KLTop

open Shannon

noncomputable section

local instance : MeasurableSpace Bool := ⊤

local instance : MeasurableSingletonClass Bool where
  measurableSet_singleton _ := trivial

/-- The pure law at `false`. -/
def leftLaw : PMF Bool := PMF.pure false

/-- The pure law at `true`, whose support is disjoint from `leftLaw`. -/
def rightLaw : PMF Bool := PMF.pure true

/-- The two pure laws are unequal. -/
theorem laws_ne : leftLaw ≠ rightLaw := by
  intro h
  have hmass := congrArg (fun p : PMF Bool => p false) h
  simp [leftLaw, rightLaw] at hmass

/-- `leftLaw` is not absolutely continuous with respect to `rightLaw`. -/
theorem not_absolutelyContinuous :
    Not (MeasureTheory.Measure.AbsolutelyContinuous
      leftLaw.toMeasure rightLaw.toMeasure) := by
  rw [toMeasure_absolutelyContinuous_iff_support_subset]
  simp [leftLaw, rightLaw]

/-- Failed support inclusion makes the KL divergence infinite. -/
theorem klDiv_eq_top :
    InformationTheory.klDiv leftLaw.toMeasure rightLaw.toMeasure = ⊤ := by
  apply (klDiv_pmf_eq_top_iff_not_support_subset leftLaw rightLaw).2
  simp [leftLaw, rightLaw]

/-- Taking `ENNReal.toReal` sends the infinite KL value to zero. -/
theorem toReal_klDiv_eq_zero :
    (InformationTheory.klDiv leftLaw.toMeasure rightLaw.toMeasure).toReal = 0 := by
  rw [klDiv_eq_top]
  simp

/--
Without absolute continuity, real-valued KL can be zero for two unequal laws;
this is the branch excluded by `toReal_klDiv_pmf_eq_zero_iff`.
-/
theorem toReal_zero_trap :
    (InformationTheory.klDiv leftLaw.toMeasure rightLaw.toMeasure).toReal = 0 ∧
      leftLaw ≠ rightLaw ∧
        Not (MeasureTheory.Measure.AbsolutelyContinuous
          leftLaw.toMeasure rightLaw.toMeasure) :=
  ⟨toReal_klDiv_eq_zero, laws_ne, not_absolutelyContinuous⟩

end


end KLTop
end Examples
end LeanInfoTheory
