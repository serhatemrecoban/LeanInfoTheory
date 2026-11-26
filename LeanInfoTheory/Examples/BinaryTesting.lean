/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.BinaryTesting

/-!
# Finite binary-test consumers

These private consumers use the focused probability import. Constant tests
check the rejection orientation at zero, one and one half under arbitrary
null and alternative laws. The public range theorem supplies bounds on size,
power and type-II error without unfolding the weighted sum.
Event consumers recover the rejection and complementary acceptance masses,
including empty/full events and a singleton with different masses under the
null and alternative laws.
The universal error bound also controls power relative to size and TV; a
constant one-half test exercises its use with an interior rejection weight.
Optimizer consumers recover the strict witness and compare it with arbitrary
randomized tests. A fair Boolean law against a point mass checks the factor of
two between the minimum error sum and equal-prior average at positive overlap.
Equal, disjoint and sparse overlapping laws exercise the optimum and tie behavior.
A Boolean family with coordinates `(false, true)` uses rejection weights `(γ, 0)`
to expose size and power symbolically for C26's prescribed-level problem.
-/

namespace LeanInfoTheory.Examples.BinaryTesting

open PMF.BinaryTest

variable {X : Type*} [Fintype X]

private def constantTest (c : Set.Icc (0 : ℝ) 1) : PMF.BinaryTest X := fun _ => c

private theorem constant_rejectProb (c : Set.Icc (0 : ℝ) 1) (P : PMF X) :
    rejectProb (constantTest c) P = (c : ℝ) := by
  simp only [rejectProb, constantTest, ← Finset.sum_mul, P.sum_toReal, one_mul]

private theorem constant_characteristics (c : Set.Icc (0 : ℝ) 1) (P0 P1 : PMF X) :
    size (constantTest c) P0 = (c : ℝ) ∧
      power (constantTest c) P1 = (c : ℝ) ∧
      typeIIError (constantTest c) P1 = 1 - (c : ℝ) := by
  simp only [size, power, typeIIError, constant_rejectProb, and_self]

private theorem never_reject (P0 P1 : PMF X) :
    size (constantTest ⟨0, by norm_num⟩) P0 = 0 ∧
      power (constantTest ⟨0, by norm_num⟩) P1 = 0 ∧
      typeIIError (constantTest ⟨0, by norm_num⟩) P1 = 1 := by
  simpa using constant_characteristics ⟨0, by norm_num⟩ P0 P1

private theorem always_reject (P0 P1 : PMF X) :
    size (constantTest ⟨1, by norm_num⟩) P0 = 1 ∧
      power (constantTest ⟨1, by norm_num⟩) P1 = 1 ∧
      typeIIError (constantTest ⟨1, by norm_num⟩) P1 = 0 := by
  simpa using constant_characteristics ⟨1, by norm_num⟩ P0 P1

private theorem half_reject (P0 P1 : PMF X) :
    size (constantTest ⟨1 / 2, by norm_num⟩) P0 = 1 / 2 ∧
      power (constantTest ⟨1 / 2, by norm_num⟩) P1 = 1 / 2 ∧
      typeIIError (constantTest ⟨1 / 2, by norm_num⟩) P1 = 1 / 2 := by
  convert constant_characteristics ⟨1 / 2, by norm_num⟩ P0 P1 using 1
  norm_num

private theorem operating_characteristics_mem_Icc
    (f : PMF.BinaryTest X) (P0 P1 : PMF X) :
    size f P0 ∈ Set.Icc (0 : ℝ) 1 ∧ power f P1 ∈ Set.Icc (0 : ℝ) 1 ∧
      typeIIError f P1 ∈ Set.Icc (0 : ℝ) 1 := by
  refine ⟨rejectProb_mem_Icc f P0, rejectProb_mem_Icc f P1, ?_⟩
  have h := rejectProb_mem_Icc f P1
  change 0 ≤ 1 - rejectProb f P1 ∧ 1 - rejectProb f P1 ≤ 1
  constructor <;> linarith [h.1, h.2]

private theorem event_pointwise {Y : Type*} (s : Set Y) (y : Y) :
    (ofEvent s y : ℝ) = s.indicator (fun _ => (1 : ℝ)) y := by
  classical
  simp only [ofEvent_apply, Set.indicator_apply]

private theorem event_characteristics (s : Set X) (P0 P1 : PMF X) :
    size (ofEvent s) P0 = (P0.toOuterMeasure s).toReal ∧
      power (ofEvent s) P1 = (P1.toOuterMeasure s).toReal ∧
      typeIIError (ofEvent s) P1 = (P1.toOuterMeasure sᶜ).toReal :=
  ⟨rejectProb_ofEvent s P0, rejectProb_ofEvent s P1, typeIIError_ofEvent s P1⟩

private theorem empty_event (P0 P1 : PMF X) :
    size (ofEvent ∅) P0 = 0 ∧ power (ofEvent ∅) P1 = 0 ∧
      typeIIError (ofEvent ∅) P1 = 1 := by
  simpa only [Set.compl_empty, PMF.toOuterMeasure_toReal_eq_sum, Set.indicator_empty,
    Set.indicator_univ, Finset.sum_const_zero, P1.sum_toReal] using
    event_characteristics ∅ P0 P1

private theorem full_event (P0 P1 : PMF X) :
    size (ofEvent Set.univ) P0 = 1 ∧ power (ofEvent Set.univ) P1 = 1 ∧
      typeIIError (ofEvent Set.univ) P1 = 0 := by
  simpa only [Set.compl_univ, PMF.toOuterMeasure_toReal_eq_sum, Set.indicator_empty,
    Set.indicator_univ, Finset.sum_const_zero, P0.sum_toReal, P1.sum_toReal] using
    event_characteristics Set.univ P0 P1

private theorem singleton_characteristics (a : X) (P0 P1 : PMF X) :
    size (ofEvent {a}) P0 = (P0 a).toReal ∧
      power (ofEvent {a}) P1 = (P1 a).toReal ∧
      typeIIError (ofEvent {a}) P1 = 1 - (P1 a).toReal := by
  simp only [size, power, typeIIError, rejectProb_ofEvent,
    PMF.toOuterMeasure_apply_singleton, and_self]

private theorem different_singleton_masses :
    size (ofEvent {true}) (PMF.pure false) = 0 ∧
      power (ofEvent {true}) (PMF.pure true) = 1 ∧
      typeIIError (ofEvent {true}) (PMF.pure true) = 0 := by
  simpa [PMF.pure_apply] using
    singleton_characteristics true (PMF.pure false) (PMF.pure true)

private theorem power_le_size_add_totalVariation
    (f : PMF.BinaryTest X) (P0 P1 : PMF X) :
    power f P1 ≤ size f P0 + PMF.totalVariation P0 P1 := by
  have h := one_sub_totalVariation_le_errorSum f P0 P1
  simp only [errorSum, typeIIError] at h
  linarith

private theorem half_error_bound (P0 P1 : PMF X) :
    1 - PMF.totalVariation P0 P1 ≤ errorSum (constantTest ⟨1 / 2, by norm_num⟩) P0 P1 ∧
      errorSum (constantTest ⟨1 / 2, by norm_num⟩) P0 P1 = 1 := by
  refine ⟨one_sub_totalVariation_le_errorSum _ P0 P1, ?_⟩
  rw [errorSum, (half_reject P0 P1).1, (half_reject P0 P1).2.2]
  norm_num

private theorem strict_test_witness_and_comparison (P0 P1 : PMF X) :
    (∃ f : PMF.BinaryTest X, errorSum f P0 P1 = 1 - PMF.totalVariation P0 P1) ∧
      errorSum (tvTest P0 P1) P0 P1 = 1 - PMF.totalVariation P0 P1 ∧
      ∀ f : PMF.BinaryTest X, errorSum (tvTest P0 P1) P0 P1 ≤ errorSum f P0 P1 := by
  refine ⟨(isLeast_errorSum P0 P1).1, errorSum_tvTest P0 P1, ?_⟩
  intro f
  rw [errorSum_tvTest]
  exact (isLeast_errorSum P0 P1).2 ⟨f, rfl⟩

private theorem equal_prior_witness_and_bound (P0 P1 : PMF X) :
    equalPriorError (tvTest P0 P1) P0 P1 = (1 - PMF.totalVariation P0 P1) / 2 ∧
      ∀ f : PMF.BinaryTest X,
        (1 - PMF.totalVariation P0 P1) / 2 ≤ equalPriorError f P0 P1 := by
  refine ⟨?_, fun f => (isLeast_equalPriorError P0 P1).2 ⟨f, rfl⟩⟩
  simp only [equalPriorError, errorSum_tvTest]

private noncomputable def fairLaw : PMF Bool :=
  PMF.ofFintype (fun _ => ENNReal.ofReal (1 / 2)) (by
    rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
    norm_num)

private theorem positive_overlap_normalization :
    (fairLaw false).toReal = 1 / 2 ∧
      errorSum (tvTest (PMF.pure false) fairLaw) (PMF.pure false) fairLaw = 1 / 2 ∧
      equalPriorError (tvTest (PMF.pure false) fairLaw) (PMF.pure false) fairLaw = 1 / 4 := by
  have htv : PMF.totalVariation (PMF.pure false) fairLaw = 1 / 2 := by
    norm_num [PMF.totalVariation, fairLaw, PMF.ofFintype_apply, Fintype.sum_bool,
      PMF.pure_apply]
  refine ⟨?_, ?_, ?_⟩
  · norm_num [fairLaw, PMF.ofFintype_apply]
  · rw [errorSum_tvTest, htv]
    norm_num
  · rw [equalPriorError, errorSum_tvTest, htv]
    norm_num

private theorem equal_laws_characteristics (f : PMF.BinaryTest X) (P : PMF X) :
    power f P = size f P ∧ typeIIError f P = 1 - size f P ∧
      errorSum f P P = 1 ∧ equalPriorError f P P = 1 / 2 := by
  have hsum : errorSum f P P = 1 := by
    unfold errorSum size typeIIError power
    ring
  exact ⟨rfl, rfl, hsum, by rw [equalPriorError, hsum]⟩

omit [Fintype X] in
private theorem equal_laws_strict_test (P : PMF X) :
    {x | P x < P x} = (∅ : Set X) ∧ tvTest P P = ofEvent ∅ := by
  simp [tvTest]

private theorem equal_laws_minima (P : PMF X) :
    IsLeast (Set.range (fun f : PMF.BinaryTest X => errorSum f P P)) 1 ∧
      IsLeast (Set.range (fun f : PMF.BinaryTest X => equalPriorError f P P)) (1 / 2) := by
  simpa [PMF.totalVariation_self] using
    And.intro (isLeast_errorSum P P) (isLeast_equalPriorError P P)

private theorem pure_three_event :
    {x | PMF.pure (0 : Fin 3) x < PMF.pure (1 : Fin 3) x} = {1} := by
  ext x
  by_cases h1 : x = 1
  · subst x
    norm_num [PMF.pure_apply]
  · by_cases h0 : x = 0
    · subst x
      norm_num [PMF.pure_apply]
    · simp [PMF.pure_apply, h0, h1]

private theorem pure_three_characteristics :
    size (tvTest (PMF.pure (0 : Fin 3)) (PMF.pure 1)) (PMF.pure 0) = 0 ∧
      power (tvTest (PMF.pure (0 : Fin 3)) (PMF.pure 1)) (PMF.pure 1) = 1 ∧
      typeIIError (tvTest (PMF.pure (0 : Fin 3)) (PMF.pure 1)) (PMF.pure 1) = 0 ∧
      errorSum (tvTest (PMF.pure (0 : Fin 3)) (PMF.pure 1)) (PMF.pure 0) (PMF.pure 1) = 0 ∧
      equalPriorError (tvTest (PMF.pure (0 : Fin 3)) (PMF.pure 1))
        (PMF.pure 0) (PMF.pure 1) = 0 := by
  simp only [tvTest, pure_three_event]
  have h := singleton_characteristics (1 : Fin 3) (PMF.pure 0) (PMF.pure 1)
  norm_num [PMF.pure_apply] at h
  exact ⟨h.1, h.2.1, h.2.2, by simp [errorSum, h.1, h.2.2],
    by simp [equalPriorError, errorSum, h.1, h.2.2]⟩

private theorem pure_three_null_atoms :
    (tvTest (PMF.pure (0 : Fin 3)) (PMF.pure 1) 1 : ℝ) = 1 ∧
      (tvTest (PMF.pure (0 : Fin 3)) (PMF.pure 1) 2 : ℝ) = 0 := by
  norm_num [tvTest, pure_three_event, ofEvent_apply,
    show (2 : Fin 3) ≠ 0 by decide, show (2 : Fin 3) ≠ 1 by decide]

private theorem pure_three_minima :
    PMF.totalVariation (PMF.pure (0 : Fin 3)) (PMF.pure 1) = 1 ∧
      IsLeast (Set.range (fun f : PMF.BinaryTest (Fin 3) =>
        errorSum f (PMF.pure 0) (PMF.pure 1))) 0 ∧
      IsLeast (Set.range (fun f : PMF.BinaryTest (Fin 3) =>
        equalPriorError f (PMF.pure 0) (PMF.pure 1))) 0 := by
  have htv : PMF.totalVariation (PMF.pure (0 : Fin 3)) (PMF.pure 1) = 1 := by
    have h := errorSum_tvTest (PMF.pure (0 : Fin 3)) (PMF.pure 1)
    rw [pure_three_characteristics.2.2.2.1] at h
    linarith
  refine ⟨htv, ?_⟩
  simpa [htv] using And.intro
    (isLeast_errorSum (PMF.pure (0 : Fin 3)) (PMF.pure 1))
    (isLeast_equalPriorError (PMF.pure (0 : Fin 3)) (PMF.pure 1))

-- The same private law construction as in the focused total-variation examples.
private theorem half_mass_add :
    ENNReal.ofReal (1 / 2 : ℝ) + ENNReal.ofReal (1 / 2 : ℝ) = 1 := by
  rw [← ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1 / 2)
    (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  norm_num

private noncomputable def sparseP : PMF (Fin 3) :=
  PMF.ofFintype
    (fun a => if a = 2 then 0 else ENNReal.ofReal (1 / 2 : ℝ))
    (by simpa [Fin.sum_univ_three] using half_mass_add)

private noncomputable def sparseQ : PMF (Fin 3) :=
  PMF.ofFintype
    (fun a => if a = 0 then 0 else ENNReal.ofReal (1 / 2 : ℝ))
    (by simpa [Fin.sum_univ_three] using half_mass_add)

private theorem sparse_event : {x | sparseP x < sparseQ x} = {2} := by
  ext x
  by_cases h2 : x = 2
  · subst x
    norm_num [sparseP, sparseQ, PMF.ofFintype_apply, show (2 : Fin 3) ≠ 0 by decide]
  · by_cases h0 : x = 0
    · subst x
      norm_num [sparseP, sparseQ, PMF.ofFintype_apply, show (0 : Fin 3) ≠ 2 by decide]
    · simp [sparseP, sparseQ, PMF.ofFintype_apply, h0, h2]

private theorem sparse_characteristics :
    size (tvTest sparseP sparseQ) sparseP = 0 ∧
      power (tvTest sparseP sparseQ) sparseQ = 1 / 2 ∧
      typeIIError (tvTest sparseP sparseQ) sparseQ = 1 / 2 ∧
      errorSum (tvTest sparseP sparseQ) sparseP sparseQ = 1 / 2 ∧
      equalPriorError (tvTest sparseP sparseQ) sparseP sparseQ = 1 / 4 := by
  simp only [tvTest, sparse_event]
  have hp : (sparseP 2).toReal = 0 := by
    norm_num [sparseP, PMF.ofFintype_apply]
  have hq : (sparseQ 2).toReal = 1 / 2 := by
    norm_num [sparseQ, PMF.ofFintype_apply, show (2 : Fin 3) ≠ 0 by decide]
  have h := singleton_characteristics (2 : Fin 3) sparseP sparseQ
  rw [hp, hq] at h
  norm_num at h
  exact ⟨h.1, h.2.1, h.2.2, by norm_num [errorSum, h.1, h.2.2],
    by norm_num [equalPriorError, errorSum, h.1, h.2.2]⟩

private theorem sparse_minima :
    PMF.totalVariation sparseP sparseQ = 1 / 2 ∧
      IsLeast (Set.range (fun f : PMF.BinaryTest (Fin 3) => errorSum f sparseP sparseQ))
        (1 / 2) ∧
      IsLeast (Set.range (fun f : PMF.BinaryTest (Fin 3) => equalPriorError f sparseP sparseQ))
        (1 / 4) := by
  have htv : PMF.totalVariation sparseP sparseQ = 1 / 2 := by
    have h := errorSum_tvTest sparseP sparseQ
    rw [sparse_characteristics.2.2.2.1] at h
    linarith
  refine ⟨htv, ?_⟩
  have h := And.intro (isLeast_errorSum sparseP sparseQ) (isLeast_equalPriorError sparseP sparseQ)
  norm_num [htv] at h
  exact h

private noncomputable def sparseTieTest : PMF.BinaryTest (Fin 3) :=
  fun a => ⟨if a = 2 then 1 else if a = 1 then 1 / 2 else 0,
    by split_ifs <;> norm_num⟩

private theorem sparse_tie_characteristics :
    size sparseTieTest sparseP = 1 / 4 ∧ power sparseTieTest sparseQ = 3 / 4 ∧
      typeIIError sparseTieTest sparseQ = 1 / 4 ∧ errorSum sparseTieTest sparseP sparseQ = 1 / 2 ∧
      equalPriorError sparseTieTest sparseP sparseQ = 1 / 4 := by
  have hs : size sparseTieTest sparseP = 1 / 4 := by
    norm_num [size, rejectProb, Fin.sum_univ_three, sparseP, PMF.ofFintype_apply,
      sparseTieTest, show (0 : Fin 3) ≠ 2 by decide, show (1 : Fin 3) ≠ 2 by decide]
  have hp : power sparseTieTest sparseQ = 3 / 4 := by
    norm_num [power, rejectProb, Fin.sum_univ_three, sparseQ, PMF.ofFintype_apply,
      sparseTieTest, show (1 : Fin 3) ≠ 2 by decide, show (2 : Fin 3) ≠ 0 by decide]
  exact ⟨hs, hp, by norm_num [typeIIError, hp],
    by norm_num [errorSum, hs, typeIIError, hp],
    by norm_num [equalPriorError, errorSum, hs, typeIIError, hp]⟩

private theorem sparse_tie_is_optimal (f : PMF.BinaryTest (Fin 3)) :
    errorSum sparseTieTest sparseP sparseQ ≤ errorSum f sparseP sparseQ ∧
      equalPriorError sparseTieTest sparseP sparseQ ≤ equalPriorError f sparseP sparseQ := by
  rw [sparse_tie_characteristics.2.2.2.1, sparse_tie_characteristics.2.2.2.2]
  exact ⟨sparse_minima.2.1.2 ⟨f, rfl⟩, sparse_minima.2.2.2 ⟨f, rfl⟩⟩

-- Coordinates are (false, true): the alternative puts mass 3/4 on false.
private noncomputable def alternativeLaw : PMF Bool :=
  PMF.ofFintype (fun b => ENNReal.ofReal (if b then 1 / 4 else 3 / 4)) (by
    rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
    norm_num)

private def gammaTest (γ : Set.Icc (0 : ℝ) 1) : PMF.BinaryTest Bool :=
  fun b => if b then ⟨0, by norm_num⟩ else γ

private theorem gamma_characteristics (γ : Set.Icc (0 : ℝ) 1) :
    size (gammaTest γ) fairLaw = (γ : ℝ) / 2 ∧
      power (gammaTest γ) alternativeLaw = 3 * (γ : ℝ) / 4 ∧
      typeIIError (gammaTest γ) alternativeLaw = 1 - 3 * (γ : ℝ) / 4 ∧
      errorSum (gammaTest γ) fairLaw alternativeLaw = 1 - (γ : ℝ) / 4 ∧
      equalPriorError (gammaTest γ) fairLaw alternativeLaw = (1 - (γ : ℝ) / 4) / 2 := by
  have hs : size (gammaTest γ) fairLaw = (γ : ℝ) / 2 := by
    norm_num [size, rejectProb, Fintype.sum_bool, fairLaw, PMF.ofFintype_apply, gammaTest]
    ring
  have hp : power (gammaTest γ) alternativeLaw = 3 * (γ : ℝ) / 4 := by
    norm_num [power, rejectProb, Fintype.sum_bool, alternativeLaw, PMF.ofFintype_apply,
      gammaTest]
    ring
  refine ⟨hs, hp, ?_, ?_, ?_⟩
  · rw [typeIIError, hp]
  · rw [errorSum, hs, typeIIError, hp]
    ring
  · rw [equalPriorError, errorSum, hs, typeIIError, hp]
    ring

private theorem gamma_one_eq_tvTest :
    gammaTest ⟨1, by norm_num⟩ = tvTest fairLaw alternativeLaw := by
  funext b
  apply Subtype.ext
  cases b <;> norm_num [gammaTest, tvTest, ofEvent_apply, fairLaw, alternativeLaw,
    PMF.ofFintype_apply]

private theorem gamma_strict_characteristics :
    size (tvTest fairLaw alternativeLaw) fairLaw = 1 / 2 ∧
      power (tvTest fairLaw alternativeLaw) alternativeLaw = 3 / 4 ∧
      typeIIError (tvTest fairLaw alternativeLaw) alternativeLaw = 1 / 4 ∧
      errorSum (tvTest fairLaw alternativeLaw) fairLaw alternativeLaw = 3 / 4 ∧
      equalPriorError (tvTest fairLaw alternativeLaw) fairLaw alternativeLaw = 3 / 8 := by
  rw [← gamma_one_eq_tvTest]
  have h := gamma_characteristics ⟨1, by norm_num⟩
  norm_num at h
  exact h

private theorem gamma_half_characteristics :
    size (gammaTest ⟨1 / 2, by norm_num⟩) fairLaw = 1 / 4 ∧
      power (gammaTest ⟨1 / 2, by norm_num⟩) alternativeLaw = 3 / 8 ∧
      typeIIError (gammaTest ⟨1 / 2, by norm_num⟩) alternativeLaw = 5 / 8 ∧
      errorSum (gammaTest ⟨1 / 2, by norm_num⟩) fairLaw alternativeLaw = 7 / 8 ∧
      equalPriorError (gammaTest ⟨1 / 2, by norm_num⟩) fairLaw alternativeLaw = 7 / 16 := by
  have h := gamma_characteristics ⟨1 / 2, by norm_num⟩
  norm_num at h
  exact h

private theorem gamma_minima :
    PMF.totalVariation fairLaw alternativeLaw = 1 / 4 ∧
      IsLeast (Set.range (fun f : PMF.BinaryTest Bool => errorSum f fairLaw alternativeLaw))
        (3 / 4) ∧
      IsLeast (Set.range (fun f : PMF.BinaryTest Bool => equalPriorError f fairLaw alternativeLaw))
        (3 / 8) := by
  have htv : PMF.totalVariation fairLaw alternativeLaw = 1 / 4 := by
    have h := errorSum_tvTest fairLaw alternativeLaw
    rw [gamma_strict_characteristics.2.2.2.1] at h
    linarith
  refine ⟨htv, ?_⟩
  have h := And.intro
    (isLeast_errorSum fairLaw alternativeLaw) (isLeast_equalPriorError fairLaw alternativeLaw)
  norm_num [htv] at h
  exact h

private theorem gamma_strict_rejects_shared_atom :
    (fairLaw false).toReal = 1 / 2 ∧ (alternativeLaw false).toReal = 3 / 4 ∧
      (tvTest fairLaw alternativeLaw false : ℝ) = 1 := by
  rw [← gamma_one_eq_tvTest]
  norm_num [fairLaw, alternativeLaw, PMF.ofFintype_apply, gammaTest]

-- Meeting this size cap is a calculation; prescribed-level optimality belongs to C26.
private theorem gamma_half_size_cap_and_cost :
    size (gammaTest ⟨1 / 2, by norm_num⟩) fairLaw ≤ 1 / 4 ∧
      errorSum (gammaTest ⟨1 / 2, by norm_num⟩) fairLaw alternativeLaw =
        errorSum (tvTest fairLaw alternativeLaw) fairLaw alternativeLaw + 1 / 8 := by
  rw [gamma_half_characteristics.1, gamma_half_characteristics.2.2.2.1,
    gamma_strict_characteristics.2.2.2.1]
  norm_num

end LeanInfoTheory.Examples.BinaryTesting
