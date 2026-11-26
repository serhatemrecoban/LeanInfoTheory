/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.TotalVariation

/-!
# Randomized binary tests on finite observations

A `PMF.BinaryTest X` assigns to each observation the probability of rejecting
the null hypothesis. For a finite observation alphabet, `rejectProb` evaluates
that probability under a PMF. Its value under the null is the size (type-I
error); its value under the alternative is the power. Type-II error is one
minus the power. These are conditional probabilities under the respective
laws, with no prior weighting.

The deterministic test `ofEvent s` rejects exactly on `s`. Its rejection
probability is the mass of `s`, and its type-II error is the mass of `sᶜ`.

The unweighted sum `errorSum` adds size and type-II error. Every randomized
test has error sum at least one minus the total variation of the two laws.
The strict test `tvTest` attains this bound by rejecting where the alternative
has greater atom mass; ties accept the null. `isLeast_errorSum` states the
attained minimum over all randomized tests. With equal priors and zero-one
loss, `equalPriorError` and its least value are half as large.

This scalar convention follows Polyanskiy--Wu (2024), Section 14.1. Their
null-acceptance parameter is one minus the size used here. The test itself
requires no finiteness assumption; only its finite-sum evaluation does.
-/

namespace PMF

universe u

/-- A randomized binary test, giving the probability of rejecting the null at each observation. -/
abbrev BinaryTest (X : Type u) := X → Set.Icc (0 : ℝ) 1

namespace BinaryTest

open scoped BigOperators

variable {X : Type u}

/-- The deterministic test that rejects the null exactly on the event `s`. -/
noncomputable def ofEvent (s : Set X) : BinaryTest X := by
  classical
  exact fun x => ⟨if x ∈ s then 1 else 0, by split_ifs <;> norm_num⟩

open scoped Classical in
/-- The rejection weight of an event test is its zero-one indicator. -/
theorem ofEvent_apply (s : Set X) (x : X) :
    (ofEvent s x : ℝ) = if x ∈ s then 1 else 0 := by
  rfl

/-- The test rejecting where the alternative has strictly greater mass; ties accept the null. -/
noncomputable def tvTest (P0 P1 : PMF X) : BinaryTest X :=
  ofEvent {x | P0 x < P1 x}

variable [Fintype X]

/-- The probability that a test rejects the null when observations have law `P`. -/
noncomputable def rejectProb (f : BinaryTest X) (P : PMF X) : ℝ :=
  ∑ x, (P x).toReal * (f x : ℝ)

/-- The rejection probability of a randomized binary test lies in the unit interval. -/
theorem rejectProb_mem_Icc (f : BinaryTest X) (P : PMF X) :
    rejectProb f P ∈ Set.Icc (0 : ℝ) 1 := by
  constructor
  · exact Finset.sum_nonneg fun x _ =>
      mul_nonneg (P.toReal_nonneg x) (f x).property.1
  · calc
      rejectProb f P ≤ ∑ x, (P x).toReal :=
        Finset.sum_le_sum fun x _ =>
          mul_le_of_le_one_right (P.toReal_nonneg x) (f x).property.2
      _ = 1 := P.sum_toReal

/-- The size (type-I error) is the rejection probability under the null law `P0`. -/
noncomputable def size (f : BinaryTest X) (P0 : PMF X) : ℝ :=
  rejectProb f P0

/-- The power is the rejection probability under the alternative law `P1`. -/
noncomputable def power (f : BinaryTest X) (P1 : PMF X) : ℝ :=
  rejectProb f P1

/-- The type-II error is the probability of accepting the null under the alternative law `P1`. -/
noncomputable def typeIIError (f : BinaryTest X) (P1 : PMF X) : ℝ :=
  1 - power f P1

/-- The rejection probability of an event test is the real mass of its rejection event. -/
theorem rejectProb_ofEvent (s : Set X) (P : PMF X) :
    rejectProb (ofEvent s) P = (P.toOuterMeasure s).toReal := by
  classical
  rw [rejectProb, P.toOuterMeasure_toReal_eq_sum]
  apply Finset.sum_congr rfl
  intro x _
  by_cases hx : x ∈ s <;> simp [ofEvent_apply, hx]

/-- The type-II error of an event test is the real mass of the complementary acceptance event. -/
theorem typeIIError_ofEvent (s : Set X) (P1 : PMF X) :
    typeIIError (ofEvent s) P1 = (P1.toOuterMeasure sᶜ).toReal := by
  simp only [typeIIError, power, rejectProb_ofEvent, P1.toOuterMeasure_toReal_eq_sum,
    Set.indicator_compl, Pi.sub_apply, Finset.sum_sub_distrib, P1.sum_toReal]

/-- The unweighted sum of type-I error under `P0` and type-II error under `P1`. -/
noncomputable def errorSum (f : BinaryTest X) (P0 P1 : PMF X) : ℝ :=
  size f P0 + typeIIError f P1

/-- Every randomized test has error sum at least one minus total variation. -/
theorem one_sub_totalVariation_le_errorSum (f : BinaryTest X) (P0 P1 : PMF X) :
    1 - PMF.totalVariation P0 P1 ≤ errorSum f P0 P1 := by
  have h : |rejectProb f P0 - rejectProb f P1| ≤ PMF.totalVariation P0 P1 := by
    simpa only [rejectProb, sub_zero, one_mul] using
      PMF.abs_sum_sub_le_totalVariation_of_mem_Icc P0 P1 (fun x => (f x : ℝ)) 0 1
        (by norm_num) (fun x => (f x).property)
  have hlo := (abs_le.mp h).1
  unfold errorSum size typeIIError power
  linarith

/-- The strict mass-comparison test has error sum one minus total variation. -/
theorem errorSum_tvTest (P0 P1 : PMF X) :
    errorSum (tvTest P0 P1) P0 P1 = 1 - PMF.totalVariation P0 P1 := by
  have hcomp : {x | P0 x < P1 x}ᶜ = {x | (P1 x).toReal ≤ (P0 x).toReal} := by
    ext x
    simp only [Set.mem_compl_iff, Set.mem_ofPred_eq, not_lt,
      ENNReal.toReal_le_toReal (P1.apply_ne_top x) (P0.apply_ne_top x)]
  have htv := PMF.totalVariation_eq_toOuterMeasure_sub P0 P1
  rw [← hcomp] at htv
  have hnull := typeIIError_ofEvent {x | P0 x < P1 x} P0
  rw [typeIIError, power, rejectProb_ofEvent] at hnull
  simp only [errorSum, tvTest, size, rejectProb_ofEvent, typeIIError_ofEvent]
  linarith

/-- The least error sum over all randomized tests is one minus total variation. -/
theorem isLeast_errorSum (P0 P1 : PMF X) :
    IsLeast (Set.range (fun f : BinaryTest X => errorSum f P0 P1))
      (1 - PMF.totalVariation P0 P1) := by
  constructor
  · exact ⟨tvTest P0 P1, errorSum_tvTest P0 P1⟩
  · rintro _ ⟨f, rfl⟩
    exact one_sub_totalVariation_le_errorSum f P0 P1

/-- The average probability of error under equal priors and zero-one loss. -/
noncomputable def equalPriorError (f : BinaryTest X) (P0 P1 : PMF X) : ℝ :=
  errorSum f P0 P1 / 2

/-- The least equal-prior error over all randomized tests is half of one minus TV. -/
theorem isLeast_equalPriorError (P0 P1 : PMF X) :
    IsLeast (Set.range (fun f : BinaryTest X => equalPriorError f P0 P1))
      ((1 - PMF.totalVariation P0 P1) / 2) := by
  constructor
  · refine ⟨tvTest P0 P1, ?_⟩
    simp only [equalPriorError, errorSum_tvTest]
  · rintro _ ⟨f, rfl⟩
    exact div_le_div_of_nonneg_right
      (one_sub_totalVariation_le_errorSum f P0 P1) (by norm_num)

end BinaryTest
end PMF
