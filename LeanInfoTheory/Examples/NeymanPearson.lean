/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.NeymanPearson

/-!
# Likelihood-threshold test consumers

These private callers use the focused import and the public application
equation to check all three branches and both kinds of null atom.
The Boolean consumer adapts C25's private fixture in (false, true) order and
proves optimal power 3/8 at size 1/4, while every feasible event has power zero.
The disjoint point-mass consumer attains power one at size zero and checks
that the public existence theorem supplies an optimizer at that level too.
-/

namespace LeanInfoTheory.Examples.NeymanPearson

open PMF.BinaryTest
open scoped NNReal

variable {X : Type*} (P0 P1 : PMF X) (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1) (x : X)

private theorem above_threshold (h : (c : ℝ) * (P0 x).toReal < (P1 x).toReal) :
    (likelihoodThresholdTest P0 P1 c γ x : ℝ) = 1 := by
  simp [likelihoodThresholdTest_apply, h]

private theorem below_threshold (h : (P1 x).toReal < (c : ℝ) * (P0 x).toReal) :
    (likelihoodThresholdTest P0 P1 c γ x : ℝ) = 0 := by
  simp [likelihoodThresholdTest_apply, h, not_lt.mpr (le_of_lt h)]

private theorem on_boundary (h : (c : ℝ) * (P0 x).toReal = (P1 x).toReal) :
    (likelihoodThresholdTest P0 P1 c γ x : ℝ) = (γ : ℝ) := by
  simp [likelihoodThresholdTest_apply, h]

private theorem alternative_only (h0 : P0 x = 0) (h1 : 0 < (P1 x).toReal) :
    (likelihoodThresholdTest P0 P1 c γ x : ℝ) = 1 := by
  simp [likelihoodThresholdTest_apply, h0, h1]

private theorem common_null (h0 : P0 x = 0) (h1 : P1 x = 0) :
    (likelihoodThresholdTest P0 P1 c γ x : ℝ) = (γ : ℝ) := by
  simp [likelihoodThresholdTest_apply, h0, h1]

private theorem equal_laws_boundary (P : PMF X) :
    (likelihoodThresholdTest P P 1 γ x : ℝ) = (γ : ℝ) := by
  simp [likelihoodThresholdTest_apply]

variable [Fintype X]

private theorem supplied_parameters (g : PMF.BinaryTest X)
    (hg : size g P0 ≤
      size (likelihoodThresholdTest P0 P1 2 ⟨1 / 2, by norm_num⟩) P0) :
    power g P1 ≤ power (likelihoodThresholdTest P0 P1 2 ⟨1 / 2, by norm_num⟩) P1 :=
  power_le_power_likelihoodThresholdTest P0 P1 2 ⟨1 / 2, by norm_num⟩ g hg

private theorem zero_threshold_comparison (g : PMF.BinaryTest X)
    (hg : size g P0 ≤
      size (likelihoodThresholdTest P0 P1 0 ⟨1 / 2, by norm_num⟩) P0) :
    power g P1 ≤ power (likelihoodThresholdTest P0 P1 0 ⟨1 / 2, by norm_num⟩) P1 :=
  power_le_power_likelihoodThresholdTest P0 P1 0 ⟨1 / 2, by norm_num⟩ g hg

private theorem zero_level_alternative_only (P0 P1 : PMF X) :
    ∃ (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1),
      size (likelihoodThresholdTest P0 P1 c γ) P0 = 0 ∧
      (∀ g : PMF.BinaryTest X, size g P0 ≤ 0 →
        power g P1 ≤ power (likelihoodThresholdTest P0 P1 c γ) P1) ∧
      ∀ x : X, P0 x = 0 → 0 < (P1 x).toReal →
        (likelihoodThresholdTest P0 P1 c γ x : ℝ) = 1 := by
  obtain ⟨c, γ, hsize, hpower⟩ := exists_likelihoodThresholdTest P0 P1 0 (by norm_num)
  refine ⟨c, γ, hsize, hpower, ?_⟩
  intro x h0 h1
  simp [likelihoodThresholdTest_apply, h0, h1]

private theorem one_level_power (P0 P1 : PMF X) :
    ∃ (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1),
      size (likelihoodThresholdTest P0 P1 c γ) P0 = 1 ∧
      power (likelihoodThresholdTest P0 P1 c γ) P1 = 1 := by
  obtain ⟨c, γ, hsize, hpower⟩ := exists_likelihoodThresholdTest P0 P1 1 (by norm_num)
  let oneTest : PMF.BinaryTest X := fun _ => ⟨1, by norm_num⟩
  have hs : size oneTest P0 = 1 := by simp [size, rejectProb, oneTest, P0.sum_toReal]
  have hp : power oneTest P1 = 1 := by simp [power, rejectProb, oneTest, P1.sum_toReal]
  refine ⟨c, γ, hsize, le_antisymm (rejectProb_mem_Icc _ P1).2 ?_⟩
  have h := hpower oneTest hs.le
  simpa only [hp] using h

private theorem exists_minimum_typeIIError (P0 P1 : PMF X) (a : ℝ) (ha : a ∈ Set.Icc (0 : ℝ) 1) :
    ∃ (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1),
      let fStar := likelihoodThresholdTest P0 P1 c γ
      size fStar P0 = a ∧
        IsLeast {b : ℝ | ∃ g : PMF.BinaryTest X,
          size g P0 ≤ a ∧ typeIIError g P1 = b} (typeIIError fStar P1) := by
  obtain ⟨c, γ, hsize, hpower⟩ := exists_likelihoodThresholdTest P0 P1 a ha
  refine ⟨c, γ, hsize, ⟨?_, ?_⟩⟩
  · exact ⟨_, hsize.le, rfl⟩
  · rintro _ ⟨g, hg, rfl⟩
    dsimp only [typeIIError]
    linarith [hpower g hg]


-- The following permanent consumers use only the public focused interface.
-- Coordinates are (false, true), as in the private C25 fixture.
private noncomputable def fairLaw : PMF Bool :=
  PMF.ofFintype (fun _ => ENNReal.ofReal (1 / 2)) (by
    rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
    norm_num)

private noncomputable def alternativeLaw : PMF Bool :=
  PMF.ofFintype (fun b => ENNReal.ofReal (if b then 1 / 4 else 3 / 4)) (by
    rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
    norm_num)

private noncomputable def quarterLevelTest : PMF.BinaryTest Bool :=
  likelihoodThresholdTest fairLaw alternativeLaw (3 / 2) ⟨1 / 2, by norm_num⟩

private theorem quarter_test_weights :
    (quarterLevelTest false : ℝ) = 1 / 2 ∧ (quarterLevelTest true : ℝ) = 0 := by
  norm_num [quarterLevelTest, likelihoodThresholdTest_apply, fairLaw,
    alternativeLaw, PMF.ofFintype_apply]

private theorem quarter_test_characteristics :
    size quarterLevelTest fairLaw = 1 / 4 ∧
      power quarterLevelTest alternativeLaw = 3 / 8 ∧
      typeIIError quarterLevelTest alternativeLaw = 5 / 8 := by
  norm_num [size, power, typeIIError, rejectProb, Fintype.sum_bool,
    quarter_test_weights.1, quarter_test_weights.2, fairLaw, alternativeLaw,
    PMF.ofFintype_apply]

private theorem quarter_test_optimal (g : PMF.BinaryTest Bool)
    (hg : size g fairLaw ≤ 1 / 4) : power g alternativeLaw ≤ 3 / 8 := by
  have hsize : size g fairLaw ≤ size quarterLevelTest fairLaw := by
    rw [quarter_test_characteristics.1]
    exact hg
  have h := power_le_power_likelihoodThresholdTest fairLaw alternativeLaw
    (3 / 2) ⟨1 / 2, by norm_num⟩ g hsize
  change power g alternativeLaw ≤ power quarterLevelTest alternativeLaw at h
  simpa only [quarter_test_characteristics.2.1] using h

private theorem nonempty_event_size (s : Set Bool) (hs : s.Nonempty) :
    1 / 2 ≤ size (ofEvent s) fairLaw := by
  classical
  obtain ⟨b, hb⟩ := hs
  cases b
  · by_cases ht : true ∈ s <;>
      norm_num [size, rejectProb, Fintype.sum_bool, fairLaw, PMF.ofFintype_apply,
        ofEvent_apply, hb, ht]
  · by_cases hf : false ∈ s <;>
      norm_num [size, rejectProb, Fintype.sum_bool, fairLaw, PMF.ofFintype_apply,
        ofEvent_apply, hb, hf]

private theorem deterministic_quarter_power_zero (s : Set Bool)
    (hs : size (ofEvent s) fairLaw ≤ 1 / 4) :
    power (ofEvent s) alternativeLaw = 0 := by
  classical
  have hz (b : Bool) : b ∉ s := by
    intro hb
    have hlarge := nonempty_event_size s ⟨b, hb⟩
    linarith
  simp [power, rejectProb, ofEvent_apply, hz]

-- Distinguish alternative-only rejection from a common-null tie decision.
private noncomputable def singularThresholdTest : PMF.BinaryTest (Fin 3) :=
  likelihoodThresholdTest (PMF.pure 0) (PMF.pure 1) 2 ⟨1 / 2, by norm_num⟩

private theorem singular_threshold_weights :
    (singularThresholdTest 0 : ℝ) = 0 ∧
      (singularThresholdTest 1 : ℝ) = 1 ∧
      (singularThresholdTest 2 : ℝ) = 1 / 2 := by
  norm_num [singularThresholdTest, likelihoodThresholdTest_apply, PMF.pure_apply,
    show (0 : Fin 3) ≠ 1 by decide, show (1 : Fin 3) ≠ 0 by decide,
    show (2 : Fin 3) ≠ 0 by decide, show (2 : Fin 3) ≠ 1 by decide]

private theorem singular_threshold_characteristics :
    size singularThresholdTest (PMF.pure 0) = 0 ∧
      power singularThresholdTest (PMF.pure 1) = 1 ∧
      typeIIError singularThresholdTest (PMF.pure 1) = 0 := by
  norm_num [size, power, typeIIError, rejectProb, Fin.sum_univ_three,
    PMF.pure_apply, singular_threshold_weights.1, singular_threshold_weights.2.1,
    singular_threshold_weights.2.2,
    show (0 : Fin 3) ≠ 1 by decide, show (1 : Fin 3) ≠ 0 by decide,
    show (2 : Fin 3) ≠ 0 by decide, show (2 : Fin 3) ≠ 1 by decide]

private theorem singular_threshold_optimal (g : PMF.BinaryTest (Fin 3))
    (hg : size g (PMF.pure 0) ≤ 0) :
    power g (PMF.pure 1) ≤ power singularThresholdTest (PMF.pure 1) := by
  exact power_le_power_likelihoodThresholdTest (PMF.pure 0) (PMF.pure 1)
    2 ⟨1 / 2, by norm_num⟩ g (by
      change size g (PMF.pure 0) ≤ size singularThresholdTest (PMF.pure 0)
      rw [singular_threshold_characteristics.1]
      exact hg)

private theorem singular_exists_zero_power_one :
    ∃ (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1),
      let fStar := likelihoodThresholdTest (PMF.pure (0 : Fin 3)) (PMF.pure 1) c γ
      size fStar (PMF.pure 0) = 0 ∧
        power fStar (PMF.pure 1) = 1 ∧
        typeIIError fStar (PMF.pure 1) = 0 ∧
        ∀ g : PMF.BinaryTest (Fin 3), size g (PMF.pure 0) ≤ 0 →
          power g (PMF.pure 1) ≤ power fStar (PMF.pure 1) := by
  obtain ⟨c, γ, hsize, hpower⟩ :=
    exists_likelihoodThresholdTest (PMF.pure (0 : Fin 3)) (PMF.pure 1) 0 (by norm_num)
  have hcompare := hpower singularThresholdTest singular_threshold_characteristics.1.le
  have hpow : power (likelihoodThresholdTest (PMF.pure (0 : Fin 3)) (PMF.pure 1) c γ)
      (PMF.pure 1) = 1 :=
    le_antisymm (rejectProb_mem_Icc _ _).2
      (by simpa only [singular_threshold_characteristics.2.1] using hcompare)
  refine ⟨c, γ, hsize, hpow, ?_, hpower⟩
  simp only [typeIIError, hpow, sub_self]

end LeanInfoTheory.Examples.NeymanPearson
