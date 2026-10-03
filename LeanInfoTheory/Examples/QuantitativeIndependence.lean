/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.Pinsker

/-!
# Quantitative independence consumers

These private consumers turn a mutual-information budget into total-variation,
event, and bounded-test estimates against the same law's marginal product.
Signed tests retain the factor two from total variation. Random-variable
consumers leave the source alphabet arbitrary.

A fair diagonal law in `Fin 3 × Bool` has a null first-coordinate row. Its
marginals, product masses, TV, MI, and both KL representations are computed
explicitly. Support inclusion proves finite KL before its Real representation
is used. Independent, zero-MI, singleton, and empty-coordinate endpoints remain
separate consumers of the same focused mathematical owner.
-/

namespace LeanInfoTheory.Examples.QuantitativeIndependence

open LeanInfoTheory.Shannon
open scoped BigOperators ENNReal

noncomputable section

universe u v w

private theorem quantitative_bounds {α : Type u} {β : Type v}
    [Fintype α] [Fintype β] (p : PMF (α × β)) :
    2 * PMF.totalVariation p (indepProd (fstMarginal p) (sndMarginal p)) ^ 2 ≤
        mutualInfo p ∧
      PMF.totalVariation p (indepProd (fstMarginal p) (sndMarginal p)) ≤
        Real.sqrt (mutualInfo p / 2) :=
  ⟨two_mul_totalVariation_sq_le_mutualInfo p, totalVariation_le_sqrt_mutualInfo p⟩

private theorem mutualInfo_budget {α : Type u} {β : Type v}
    [Fintype α] [Fintype β] (p : PMF (α × β)) (ε : ℝ) (hI : mutualInfo p ≤ ε) :
    0 ≤ ε ∧ PMF.totalVariation p (indepProd (fstMarginal p) (sndMarginal p)) ≤
      Real.sqrt (ε / 2) := by
  refine ⟨(mutualInfo_nonneg p).trans hI, ?_⟩
  exact (totalVariation_le_sqrt_mutualInfo p).trans
    (Real.sqrt_le_sqrt (by linarith))

private theorem event_of_mutualInfo_budget {α : Type u} {β : Type v}
    [Fintype α] [Fintype β] (p : PMF (α × β)) (s : Set (α × β))
    (ε : ℝ) (hI : mutualInfo p ≤ ε) :
    |(p.toOuterMeasure s).toReal -
      ((indepProd (fstMarginal p) (sndMarginal p)).toOuterMeasure s).toReal| ≤
      Real.sqrt (ε / 2) :=
  (PMF.abs_toOuterMeasure_sub_le_totalVariation p
    (indepProd (fstMarginal p) (sndMarginal p)) s).trans (mutualInfo_budget p ε hI).2

private theorem unit_interval_test_of_mutualInfo_budget {α : Type u} {β : Type v}
    [Fintype α] [Fintype β] (p : PMF (α × β)) (f : α × β → ℝ)
    (hf : ∀ z, 0 ≤ f z ∧ f z ≤ 1) (ε : ℝ) (hI : mutualInfo p ≤ ε) :
    |(∑ z, (p z).toReal * f z) -
      (∑ z, (indepProd (fstMarginal p) (sndMarginal p) z).toReal * f z)| ≤
      Real.sqrt (ε / 2) := by
  have htest := PMF.abs_sum_sub_le_totalVariation_of_mem_Icc p
    (indepProd (fstMarginal p) (sndMarginal p)) f 0 1 (by norm_num) hf
  have htv := (mutualInfo_budget p ε hI).2
  calc
    _ ≤ PMF.totalVariation p (indepProd (fstMarginal p) (sndMarginal p)) := by
      simpa only [sub_zero, one_mul] using htest
    _ ≤ _ := htv

private theorem signed_test_of_mutualInfo_budget {α : Type u} {β : Type v}
    [Fintype α] [Fintype β] (p : PMF (α × β)) (f : α × β → ℝ)
    (hf : ∀ z, |f z| ≤ 1) (ε : ℝ) (hI : mutualInfo p ≤ ε) :
    |(∑ z, (p z).toReal * f z) -
      (∑ z, (indepProd (fstMarginal p) (sndMarginal p) z).toReal * f z)| ≤
      2 * Real.sqrt (ε / 2) := by
  have htest := PMF.abs_sum_sub_le_mul_totalVariation p
    (indepProd (fstMarginal p) (sndMarginal p)) f 1 (by norm_num) hf
  have htv := (mutualInfo_budget p ε hI).2
  calc
    _ ≤ 2 * PMF.totalVariation p (indepProd (fstMarginal p) (sndMarginal p)) := by
      simpa only [mul_one] using htest
    _ ≤ _ := mul_le_mul_of_nonneg_left htv (by norm_num)

private theorem arbitrary_source_bounds {Ω : Type u} {α : Type v} {β : Type w}
    [Fintype α] [Fintype β] (r : PMF Ω) (X : Ω → α) (Y : Ω → β) :
    2 * PMF.totalVariation (r.map fun ω => (X ω, Y ω))
        (indepProd (r.map X) (r.map Y)) ^ 2 ≤ mutualInfoOf r X Y ∧
      PMF.totalVariation (r.map fun ω => (X ω, Y ω))
        (indepProd (r.map X) (r.map Y)) ≤ Real.sqrt (mutualInfoOf r X Y / 2) := by
  simpa only [fstMarginal_map_pair, sndMarginal_map_pair, mutualInfoOf] using
    quantitative_bounds (r.map fun ω => (X ω, Y ω))

private theorem arbitrary_source_budget {Ω : Type u} {α : Type v} {β : Type w}
    [Fintype α] [Fintype β] (r : PMF Ω) (X : Ω → α) (Y : Ω → β)
    (ε : ℝ) (hI : mutualInfoOf r X Y ≤ ε) :
    PMF.totalVariation (r.map fun ω => (X ω, Y ω))
      (indepProd (r.map X) (r.map Y)) ≤ Real.sqrt (ε / 2) := by
  simpa only [fstMarginal_map_pair, sndMarginal_map_pair] using
    (mutualInfo_budget (r.map fun ω => (X ω, Y ω)) ε hI).2

private theorem zero_mutualInfo_distance {α : Type u} {β : Type v}
    [Fintype α] [Fintype β] (p : PMF (α × β)) (hI : mutualInfo p = 0) :
    PMF.totalVariation p (indepProd (fstMarginal p) (sndMarginal p)) = 0 := by
  have h := totalVariation_le_sqrt_mutualInfo p
  rw [hI] at h
  norm_num at h
  exact le_antisymm h (PMF.totalVariation_nonneg _ _)

private theorem independent_endpoint {α : Type u} {β : Type v}
    [Fintype α] [Fintype β] (p : PMF α) (q : PMF β) :
    mutualInfo (indepProd p q) = 0 ∧
      PMF.totalVariation (indepProd p q)
        (indepProd (fstMarginal (indepProd p q)) (sndMarginal (indepProd p q))) = 0 := by
  have hI := (mutualInfo_eq_zero_iff_isIndependent (indepProd p q)).2
    (isIndependent_indepProd p q)
  exact ⟨hI, zero_mutualInfo_distance (indepProd p q) hI⟩

private theorem singleton_endpoint {α : Type u} {β : Type v}
    [Fintype α] [Fintype β] [Subsingleton α] [Subsingleton β] (p : PMF (α × β)) :
    mutualInfo p = 0 ∧
      PMF.totalVariation p (indepProd (fstMarginal p) (sndMarginal p)) = 0 ∧
      2 * PMF.totalVariation p (indepProd (fstMarginal p) (sndMarginal p)) ^ 2 ≤
        mutualInfo p := by
  obtain ⟨a, _⟩ := p.support_nonempty
  have hpure (r : PMF (α × β)) : r = PMF.pure a := by
    apply (PMF.eq_pure_iff_support_eq_singleton r a).2
    obtain ⟨b, hb⟩ := r.support_nonempty
    exact Set.eq_singleton_iff_unique_mem.mpr
      ⟨(Subsingleton.elim b a) ▸ hb, fun x _ => Subsingleton.elim x a⟩
  have hi : IsIndependent p :=
    (hpure p).trans (hpure (indepProd (fstMarginal p) (sndMarginal p))).symm
  have hI := (mutualInfo_eq_zero_iff_isIndependent p).2 hi
  exact ⟨hI, zero_mutualInfo_distance p hI, two_mul_totalVariation_sq_le_mutualInfo p⟩

private theorem empty_first_coordinate {α : Type u} {β : Type v}
    [IsEmpty α] (p : PMF (α × β)) : False := by
  obtain ⟨ab, _⟩ := p.support_nonempty
  exact isEmptyElim ab.1

private theorem empty_second_coordinate {α : Type u} {β : Type v}
    [IsEmpty β] (p : PMF (α × β)) : False := by
  obtain ⟨ab, _⟩ := p.support_nonempty
  exact isEmptyElim ab.2

section SparseDiagonal

local instance : MeasurableSpace (Fin 3 × Bool) := ⊤
local instance : MeasurableSingletonClass (Fin 3 × Bool) := ⟨fun _ => trivial⟩

private def fairBit : PMF Bool :=
  PMF.ofFintype (fun _ => ENNReal.ofReal (1 / 2 : ℝ)) (by
    rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
    norm_num)

private theorem fairBit_apply (b : Bool) : fairBit b = ENNReal.ofReal (1 / 2 : ℝ) := rfl

private def sparseFirst : PMF (Fin 3) :=
  PMF.ofFintype (fun a => ENNReal.ofReal (if a.val = 2 then (0 : ℝ) else 1 / 2)) (by
    have hn (a : Fin 3) : 0 ≤ (if a.val = 2 then (0 : ℝ) else 1 / 2) := by
      split_ifs <;> norm_num
    rw [← ENNReal.ofReal_sum_of_nonneg (fun a _ => hn a), Fin.sum_univ_three]
    change ENNReal.ofReal ((1 / 2 : ℝ) + 1 / 2 + 0) = 1
    norm_num)

private theorem sparseFirst_zero : sparseFirst 0 = ENNReal.ofReal (1 / 2 : ℝ) := rfl
private theorem sparseFirst_one : sparseFirst 1 = ENNReal.ofReal (1 / 2 : ℝ) := rfl
private theorem sparseFirst_two : sparseFirst 2 = 0 := by
  change ENNReal.ofReal (0 : ℝ) = 0
  exact ENNReal.ofReal_zero

private def diagonalJoint : PMF (Fin 3 × Bool) :=
  PMF.ofFintype (fun z =>
    ENNReal.ofReal (if z.1.val = (if z.2 then 1 else 0) then (1 / 2 : ℝ) else 0)) (by
    have hn (z : Fin 3 × Bool) :
        0 ≤ (if z.1.val = (if z.2 then 1 else 0) then (1 / 2 : ℝ) else 0) := by
      split_ifs <;> norm_num
    rw [← ENNReal.ofReal_sum_of_nonneg (fun z _ => hn z), Fintype.sum_prod_type,
      Fin.sum_univ_three]
    simp only [Fintype.sum_bool]
    change ENNReal.ofReal (((0 : ℝ) + 1 / 2) + (1 / 2 + 0) + (0 + 0)) = 1
    norm_num)

private theorem joint_zero_false : diagonalJoint (0, false) =
    ENNReal.ofReal (1 / 2 : ℝ) := rfl
private theorem joint_one_true : diagonalJoint (1, true) =
    ENNReal.ofReal (1 / 2 : ℝ) := rfl
private theorem joint_zero_true : diagonalJoint (0, true) = 0 := by
  change ENNReal.ofReal (0 : ℝ) = 0
  exact ENNReal.ofReal_zero
private theorem joint_one_false : diagonalJoint (1, false) = 0 := by
  change ENNReal.ofReal (0 : ℝ) = 0
  exact ENNReal.ofReal_zero
private theorem joint_null_row (b : Bool) : diagonalJoint (2, b) = 0 := by
  cases b <;> change ENNReal.ofReal (0 : ℝ) = 0 <;> exact ENNReal.ofReal_zero

private theorem diagonal_fstMarginal : fstMarginal diagonalJoint = sparseFirst := by
  apply PMF.ext
  intro a
  rw [fstMarginal_apply, Fintype.sum_bool]
  fin_cases a
  · change diagonalJoint (0, true) + diagonalJoint (0, false) = sparseFirst 0
    rw [joint_zero_true, joint_zero_false, sparseFirst_zero, zero_add]
  · change diagonalJoint (1, true) + diagonalJoint (1, false) = sparseFirst 1
    rw [joint_one_true, joint_one_false, sparseFirst_one, add_zero]
  · change diagonalJoint (2, true) + diagonalJoint (2, false) = sparseFirst 2
    rw [joint_null_row, joint_null_row, sparseFirst_two, add_zero]

private theorem diagonal_sndMarginal : sndMarginal diagonalJoint = fairBit := by
  apply PMF.ext
  intro b
  rw [sndMarginal_apply, Fin.sum_univ_three]
  cases b <;>
    simp only [joint_zero_true, joint_zero_false, joint_one_true, joint_one_false,
      joint_null_row, fairBit_apply, zero_add, add_zero]

private def diagonalReference : PMF (Fin 3 × Bool) :=
  indepProd (fstMarginal diagonalJoint) (sndMarginal diagonalJoint)

private theorem diagonalReference_apply (a : Fin 3) (b : Bool) :
    diagonalReference (a, b) = sparseFirst a * fairBit b := by
  simp only [diagonalReference, indepProd_apply, diagonal_fstMarginal, diagonal_sndMarginal]

private theorem reference_zero (b : Bool) :
    diagonalReference (0, b) = ENNReal.ofReal (1 / 4 : ℝ) := by
  rw [diagonalReference_apply, sparseFirst_zero, fairBit_apply,
    ← ENNReal.ofReal_mul (by norm_num)]
  congr 1
  norm_num

private theorem reference_one (b : Bool) :
    diagonalReference (1, b) = ENNReal.ofReal (1 / 4 : ℝ) := by
  rw [diagonalReference_apply, sparseFirst_one, fairBit_apply,
    ← ENNReal.ofReal_mul (by norm_num)]
  congr 1
  norm_num

private theorem reference_null_row (b : Bool) : diagonalReference (2, b) = 0 := by
  rw [diagonalReference_apply, sparseFirst_two, zero_mul]

private theorem diagonal_support : diagonalJoint.support ⊆ diagonalReference.support :=
  (toMeasure_absolutelyContinuous_iff_support_subset diagonalJoint diagonalReference).1
    (joint_toMeasure_absolutelyContinuous_indepProd_marginals diagonalJoint)

private theorem diagonal_finite_kl :
    InformationTheory.klDiv diagonalJoint.toMeasure diagonalReference.toMeasure ≠ ⊤ :=
  (klDiv_pmf_ne_top_iff_support_subset diagonalJoint diagonalReference).2 diagonal_support

private theorem diagonal_distance :
    PMF.totalVariation diagonalJoint diagonalReference = 1 / 2 := by
  rw [PMF.totalVariation, Fintype.sum_prod_type, Fin.sum_univ_three]
  simp only [Fintype.sum_bool, joint_zero_true, joint_zero_false, joint_one_true,
    joint_one_false, joint_null_row, reference_zero, reference_one, reference_null_row]
  norm_num

private theorem diagonal_real_kl :
    (InformationTheory.klDiv diagonalJoint.toMeasure diagonalReference.toMeasure).toReal =
      Real.log 2 := by
  have hac :=
    (toMeasure_absolutelyContinuous_iff_support_subset diagonalJoint diagonalReference).2
      diagonal_support
  rw [toReal_klDiv_pmf_eq_sum diagonalJoint diagonalReference hac,
    Fintype.sum_prod_type, Fin.sum_univ_three]
  simp only [Fintype.sum_bool, joint_zero_true, joint_zero_false, joint_one_true,
    joint_one_false, joint_null_row, reference_zero, reference_one, reference_null_row]
  norm_num [ENNReal.toReal_div]
  ring

private theorem diagonal_kl :
    InformationTheory.klDiv diagonalJoint.toMeasure diagonalReference.toMeasure =
      ENNReal.ofReal (Real.log 2) := by
  rw [← ENNReal.ofReal_toReal diagonal_finite_kl, diagonal_real_kl]

private theorem diagonal_mutualInfo : mutualInfo diagonalJoint = Real.log 2 := by
  rw [mutualInfo_eq_toReal_klDiv_joint_indepProd]
  exact diagonal_real_kl

private theorem diagonal_not_independent : ¬ IsIndependent diagonalJoint := by
  intro h
  change diagonalJoint = diagonalReference at h
  have hz := (PMF.totalVariation_eq_zero_iff diagonalJoint diagonalReference).2 h
  rw [diagonal_distance] at hz
  norm_num at hz

private theorem diagonal_quantitative_bounds :
    (1 / 2 : ℝ) ≤ Real.log 2 ∧ (1 / 2 : ℝ) ≤ Real.sqrt (Real.log 2 / 2) := by
  have h := quantitative_bounds diagonalJoint
  change (2 * PMF.totalVariation diagonalJoint diagonalReference ^ 2 ≤
    mutualInfo diagonalJoint) ∧
    PMF.totalVariation diagonalJoint diagonalReference ≤
      Real.sqrt (mutualInfo diagonalJoint / 2) at h
  rw [diagonal_distance, diagonal_mutualInfo] at h
  norm_num at h ⊢
  exact h

end SparseDiagonal

end

end LeanInfoTheory.Examples.QuantitativeIndependence
