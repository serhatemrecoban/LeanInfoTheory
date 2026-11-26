/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.NeymanPearson

/-! Qualification caller for the finite testing package in C40.02. -/

noncomputable section

open scoped NNReal BigOperators
open PMF.BinaryTest

namespace LeanInfoTheory.Qualification.FiniteTesting

section Optimality

variable {X : Type*} [Fintype X] (P Q : PMF X)

/-- Recover the attainable value in each loss normalization and bound any competing test. -/
private theorem totalVariationWitnesses :
    (∃ f : PMF.BinaryTest X, errorSum f P Q = 1 - PMF.totalVariation P Q ∧
      ∀ g : PMF.BinaryTest X, errorSum f P Q ≤ errorSum g P Q) ∧
    (∃ f : PMF.BinaryTest X, equalPriorError f P Q = (1 - PMF.totalVariation P Q) / 2 ∧
      ∀ g : PMF.BinaryTest X, equalPriorError f P Q ≤ equalPriorError g P Q) := by
  obtain ⟨f, hf⟩ := (isLeast_errorSum P Q).1
  obtain ⟨h, hh⟩ := (isLeast_equalPriorError P Q).1
  constructor
  · refine ⟨f, hf, fun g => ?_⟩
    exact hf.le.trans ((isLeast_errorSum P Q).2 ⟨g, rfl⟩)
  · refine ⟨h, hh, fun g => ?_⟩
    exact hh.le.trans ((isLeast_equalPriorError P Q).2 ⟨g, rfl⟩)

/-- Expose the one threshold and its common tie weight before choosing any competitor. -/
private theorem calibratedAt (a : Set.Icc (0 : ℝ) 1) :
    ∃ (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1),
      let f := likelihoodThresholdTest P Q c γ
      size f P = a.val ∧
        ∀ g : PMF.BinaryTest X, size g P ≤ a.val → power g Q ≤ power f Q := by
  obtain ⟨c, γ, hsize, hbest⟩ := exists_likelihoodThresholdTest P Q a.val a.property
  exact ⟨c, γ, hsize, fun g hg => hbest g hg⟩

/-- At level zero the same witness dominates every test with zero null rejection. -/
private theorem levelZero :
    ∃ f : PMF.BinaryTest X, size f P = 0 ∧
      ∀ g : PMF.BinaryTest X, size g P = 0 → power g Q ≤ power f Q := by
  obtain ⟨c, γ, hsize, hbest⟩ := calibratedAt P Q ⟨0, by norm_num⟩
  exact ⟨likelihoodThresholdTest P Q c γ, hsize, fun g hg => hbest g hg.le⟩

/-- At level one use the always-reject competitor to identify the attained power. -/
private theorem levelOne :
    ∃ f : PMF.BinaryTest X, size f P = 1 ∧ power f Q = 1 ∧ typeIIError f Q = 0 := by
  let rejectAll : PMF.BinaryTest X := fun _ => ⟨1, by norm_num⟩
  have hfull (law : PMF X) : rejectProb rejectAll law = 1 := by
    simpa only [rejectProb, rejectAll, mul_one] using law.sum_toReal
  obtain ⟨c, γ, hsize, hbest⟩ := calibratedAt P Q ⟨1, by norm_num⟩
  let f := likelihoodThresholdTest P Q c γ
  have hlow : 1 ≤ power f Q := by
    calc
      1 = power rejectAll Q := (hfull Q).symm
      _ ≤ power f Q := hbest rejectAll (hfull P).le
  have hone : power f Q = 1 := le_antisymm (rejectProb_mem_Icc f Q).2 hlow
  exact ⟨f, hsize, hone, by simp only [typeIIError, hone, sub_self]⟩

end Optimality

/-- Make the finite atom table used by the examples into a probability law. -/
private def lawOfWeights {X : Type*} [Fintype X] (w : X → ℝ)
    (hpos : ∀ x, 0 ≤ w x) (htotal : ∑ x, w x = 1) : PMF X :=
  PMF.ofFintype (fun x => ENNReal.ofReal (w x)) (by
    rw [← ENNReal.ofReal_sum_of_nonneg (fun x _ => hpos x), htotal, ENNReal.ofReal_one])

private theorem atomOfWeights {X : Type*} [Fintype X] (w : X → ℝ)
    (hpos : ∀ x, 0 ≤ w x) (htotal : ∑ x, w x = 1) (x : X) :
    ((lawOfWeights w hpos htotal) x).toReal = w x := by
  exact ENNReal.toReal_ofReal (hpos x)

private def coin : Set.Icc (0 : ℝ) 1 := ⟨1 / 2, by norm_num⟩

section OriginalBooleanLaws

-- Coordinates are false, true. The alternative places three quarters on false.
private def fair : PMF Bool := lawOfWeights (fun _ => 1 / 2)
  (by intro x; norm_num) (by norm_num [Fintype.sum_bool])

private def tilted : PMF Bool := lawOfWeights (fun x => if x then 1 / 4 else 3 / 4)
  (by intro x; cases x <;> norm_num) (by norm_num [Fintype.sum_bool])

private def quarterRule := likelihoodThresholdTest fair tilted (3 / 2) coin

-- At false the two scaled masses tie; at true the alternative is below threshold.
private theorem booleanDecisions :
    (quarterRule false : ℝ) = 1 / 2 ∧ (quarterRule true : ℝ) = 0 := by
  norm_num [quarterRule, likelihoodThresholdTest_apply, fair, tilted, atomOfWeights, coin]

private theorem booleanExperiment :
    size quarterRule fair = 1 / 4 ∧ power quarterRule tilted = 3 / 8 ∧
      typeIIError quarterRule tilted = 5 / 8 := by
  norm_num [size, power, typeIIError, rejectProb, Fintype.sum_bool, fair, tilted,
    atomOfWeights, booleanDecisions.1, booleanDecisions.2]

private theorem booleanCompetitor (g : PMF.BinaryTest Bool) (h : size g fair ≤ 1 / 4) :
    power g tilted ≤ 3 / 8 := by
  calc
    power g tilted ≤ power quarterRule tilted :=
      power_le_power_likelihoodThresholdTest fair tilted (3 / 2) coin g
        (h.trans_eq booleanExperiment.1.symm)
    _ = 3 / 8 := booleanExperiment.2.1

end OriginalBooleanLaws

section SharedTie

-- The first two positive atoms have different masses and identical likelihood ratios.
private def p4 : PMF (Fin 4) := lawOfWeights ![1 / 6, 1 / 3, 1 / 2, 0]
  (by intro i; fin_cases i <;> norm_num)
  (by rw [Fin.sum_univ_four]; change (1 / 6 : ℝ) + 1 / 3 + 1 / 2 + 0 = 1; norm_num)

private def q4 : PMF (Fin 4) := lawOfWeights ![1 / 4, 1 / 2, 1 / 4, 0]
  (by intro i; fin_cases i <;> norm_num)
  (by rw [Fin.sum_univ_four]; change (1 / 4 : ℝ) + 1 / 2 + 1 / 4 + 0 = 1; norm_num)

/-- A single, arbitrary γ sets the rejection probability at both positive tied atoms
and at the common-null atom. The null and alternative expectations see no mass at the last. -/
private theorem sharedBoundary (γ : Set.Icc (0 : ℝ) 1) :
    let f := likelihoodThresholdTest p4 q4 (3 / 2) γ
    (f 0 : ℝ) = γ.val ∧ (f 1 : ℝ) = γ.val ∧
      (f 2 : ℝ) = 0 ∧ (f 3 : ℝ) = γ.val := by
  norm_num [likelihoodThresholdTest_apply, p4, q4, atomOfWeights,
    Matrix.cons_val_two, Matrix.cons_val_three]

private theorem commonTieExperiment :
    let f := likelihoodThresholdTest p4 q4 (3 / 2) coin
    size f p4 = 1 / 4 ∧ power f q4 = 3 / 8 ∧ typeIIError f q4 = 5 / 8 := by
  obtain ⟨a, b, c, d⟩ := sharedBoundary coin
  dsimp only
  simp only [typeIIError, size, power, rejectProb, Fin.sum_univ_four, a, b, c, d]
  norm_num [p4, q4, atomOfWeights, coin, Matrix.cons_val_two, Matrix.cons_val_three]

end SharedTie

section OriginalSingularLaws

-- Labels 0, 1, 2 are respectively null-only, alternative-only, and common-null.
private def disjointRule (γ : Set.Icc (0 : ℝ) 1) : PMF.BinaryTest (Fin 3) :=
  likelihoodThresholdTest (PMF.pure 0) (PMF.pure 1) 2 γ

private theorem disjointDecisions (γ : Set.Icc (0 : ℝ) 1) :
    (disjointRule γ 0 : ℝ) = 0 ∧ (disjointRule γ 1 : ℝ) = 1 ∧
      (disjointRule γ 2 : ℝ) = γ.val := by
  norm_num [disjointRule, likelihoodThresholdTest_apply, PMF.pure_apply,
    show (0 : Fin 3) ≠ 1 by decide, show (1 : Fin 3) ≠ 0 by decide,
    show (2 : Fin 3) ≠ 1 by decide, show (2 : Fin 3) ≠ 0 by decide]

private theorem disjointExperiment (γ : Set.Icc (0 : ℝ) 1) :
    size (disjointRule γ) (PMF.pure 0) = 0 ∧
      power (disjointRule γ) (PMF.pure 1) = 1 ∧
      typeIIError (disjointRule γ) (PMF.pure 1) = 0 := by
  obtain ⟨a, b, c⟩ := disjointDecisions γ
  norm_num [size, power, typeIIError, rejectProb, Fin.sum_univ_three, PMF.pure_apply,
    a, b, c, show (0 : Fin 3) ≠ 1 by decide, show (1 : Fin 3) ≠ 0 by decide,
    show (2 : Fin 3) ≠ 1 by decide, show (2 : Fin 3) ≠ 0 by decide]

end OriginalSingularLaws
end LeanInfoTheory.Qualification.FiniteTesting
