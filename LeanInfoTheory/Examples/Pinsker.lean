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
# Finite Pinsker consumers

These private consumers use the canonical ENNReal Pinsker theorem from its
focused owner. Boolean laws exercise both parameter orders, equality, and
finite and singular boundary cases. A positive three-atom pair has a tied
coordinate in its non-strict attaining event. Its explicit indicator map
preserves TV and satisfies KL data processing, while its original KL is
computed only after proving support inclusion and finiteness.

Guarded Real and square-root consumers accept either support inclusion or a
non-top KL hypothesis. An extended-valued KL budget supplies finiteness before
bounding event probabilities. A point mass and a sparse two-atom reference
share a zero coordinate, while distinct pure Bool laws refute both unguarded
Real bounds and still satisfy the canonical ENNReal inequality.
-/

namespace LeanInfoTheory.Examples.Pinsker

open LeanInfoTheory.Shannon
open scoped BigOperators ENNReal

noncomputable section

universe u

private theorem finite_alphabet {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α] (p q : PMF α) :
    ENNReal.ofReal (2 * PMF.totalVariation p q ^ 2) ≤
      InformationTheory.klDiv p.toMeasure q.toMeasure :=
  ofReal_two_mul_totalVariation_sq_le_klDiv p q

private theorem equal_laws {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α] (p : PMF α) :
    PMF.totalVariation p p = 0 ∧
      InformationTheory.klDiv p.toMeasure p.toMeasure = 0 ∧
      ENNReal.ofReal (2 * PMF.totalVariation p p ^ 2) ≤
        InformationTheory.klDiv p.toMeasure p.toMeasure :=
  ⟨PMF.totalVariation_self p, (klDiv_pmf_eq_zero_iff p p).2 rfl,
    ofReal_two_mul_totalVariation_sq_le_klDiv p p⟩

private theorem empty_alphabet {α : Type u} [IsEmpty α] (p : PMF α) : False := by
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

private theorem subsingleton_laws {α : Type u} [Fintype α] [Subsingleton α]
    [MeasurableSpace α] [MeasurableSingletonClass α] (p q : PMF α) :
    PMF.totalVariation p q = 0 ∧
      InformationTheory.klDiv p.toMeasure q.toMeasure = 0 ∧
      ENNReal.ofReal (2 * PMF.totalVariation p q ^ 2) ≤
        InformationTheory.klDiv p.toMeasure q.toMeasure := by
  obtain ⟨a, _⟩ := p.support_nonempty
  have hsupport (r : PMF α) : r.support = {a} := by
    obtain ⟨b, hb⟩ := r.support_nonempty
    exact Set.eq_singleton_iff_unique_mem.mpr
      ⟨(Subsingleton.elim b a) ▸ hb, fun x _ => Subsingleton.elim x a⟩
  have hpq : p = q := ((PMF.eq_pure_iff_support_eq_singleton p a).2 (hsupport p)).trans
    ((PMF.eq_pure_iff_support_eq_singleton q a).2 (hsupport q)).symm
  subst q
  exact equal_laws p

private theorem support_guard_bounds {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α] (p q : PMF α)
    (h : p.support ⊆ q.support) :
    2 * PMF.totalVariation p q ^ 2 ≤
        (InformationTheory.klDiv p.toMeasure q.toMeasure).toReal ∧
      PMF.totalVariation p q ≤
        Real.sqrt ((InformationTheory.klDiv p.toMeasure q.toMeasure).toReal / 2) :=
  ⟨two_mul_totalVariation_sq_le_toReal_klDiv p q h,
    totalVariation_le_sqrt_toReal_klDiv p q h⟩

private theorem non_top_guard_bounds {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α] (p q : PMF α)
    (hfin : InformationTheory.klDiv p.toMeasure q.toMeasure ≠ ⊤) :
    2 * PMF.totalVariation p q ^ 2 ≤
        (InformationTheory.klDiv p.toMeasure q.toMeasure).toReal ∧
      PMF.totalVariation p q ≤
        Real.sqrt ((InformationTheory.klDiv p.toMeasure q.toMeasure).toReal / 2) :=
  support_guard_bounds p q ((klDiv_pmf_ne_top_iff_support_subset p q).1 hfin)

-- Preserve the approved Fintype consumer contract; enumeration is used only in the proof.
set_option linter.unusedFintypeInType false in
private theorem event_discrepancy_le_sqrt_of_klDiv_le
    {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) (s : Set α) (ε : ℝ) (hε : 0 ≤ ε)
    (hKL : InformationTheory.klDiv p.toMeasure q.toMeasure ≤ ENNReal.ofReal ε) :
    |(p.toOuterMeasure s).toReal - (q.toOuterMeasure s).toReal| ≤
      Real.sqrt (ε / 2) := by
  have hfin : InformationTheory.klDiv p.toMeasure q.toMeasure ≠ ⊤ :=
    ne_top_of_le_ne_top ENNReal.ofReal_ne_top hKL
  have hsupport := (klDiv_pmf_ne_top_iff_support_subset p q).1 hfin
  have hreal : (InformationTheory.klDiv p.toMeasure q.toMeasure).toReal ≤ ε := by
    simpa only [ENNReal.toReal_ofReal hε] using
      ENNReal.toReal_mono ENNReal.ofReal_ne_top hKL
  exact (PMF.abs_toOuterMeasure_sub_le_totalVariation p q s).trans
    ((totalVariation_le_sqrt_toReal_klDiv p q hsupport).trans
      (Real.sqrt_le_sqrt (by linarith)))

private theorem equal_guarded_bounds {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α] (p : PMF α) :
    2 * PMF.totalVariation p p ^ 2 ≤
        (InformationTheory.klDiv p.toMeasure p.toMeasure).toReal ∧
      PMF.totalVariation p p ≤
        Real.sqrt ((InformationTheory.klDiv p.toMeasure p.toMeasure).toReal / 2) :=
  ⟨two_mul_totalVariation_sq_le_toReal_klDiv p p (Set.Subset.refl _),
    totalVariation_le_sqrt_toReal_klDiv p p (Set.Subset.refl _)⟩

private theorem pure_guarded_bounds {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α] (a : α) :
    PMF.totalVariation (PMF.pure a) (PMF.pure a) = 0 ∧
      InformationTheory.klDiv (PMF.pure a).toMeasure (PMF.pure a).toMeasure = 0 ∧
      (2 * PMF.totalVariation (PMF.pure a) (PMF.pure a) ^ 2 ≤
          (InformationTheory.klDiv (PMF.pure a).toMeasure (PMF.pure a).toMeasure).toReal ∧
        PMF.totalVariation (PMF.pure a) (PMF.pure a) ≤
          Real.sqrt ((InformationTheory.klDiv
            (PMF.pure a).toMeasure (PMF.pure a).toMeasure).toReal / 2)) :=
  ⟨(equal_laws (PMF.pure a)).1, (equal_laws (PMF.pure a)).2.1,
    equal_guarded_bounds (PMF.pure a)⟩

private theorem subsingleton_guarded_bounds {α : Type u} [Fintype α] [Subsingleton α]
    [MeasurableSpace α] [MeasurableSingletonClass α] (p q : PMF α) :
    2 * PMF.totalVariation p q ^ 2 ≤
        (InformationTheory.klDiv p.toMeasure q.toMeasure).toReal ∧
      PMF.totalVariation p q ≤
        Real.sqrt ((InformationTheory.klDiv p.toMeasure q.toMeasure).toReal / 2) := by
  have hzero := (subsingleton_laws p q).2.1
  have hfin : InformationTheory.klDiv p.toMeasure q.toMeasure ≠ ⊤ := by
    rw [hzero]
    exact ENNReal.zero_ne_top
  exact non_top_guard_bounds p q hfin

section Boolean

local instance : MeasurableSpace Bool := ⊤
local instance : MeasurableSingletonClass Bool := ⟨fun _ => trivial⟩

private def booleanLaw (t : ℝ) (ht : 0 ≤ t ∧ t ≤ 1) : PMF Bool :=
  PMF.ofFintype (fun b => ENNReal.ofReal (if b then t else 1 - t)) (by
    simp only [Fintype.sum_bool, Bool.false_eq_true, ↓reduceIte]
    rw [← ENNReal.ofReal_add ht.1 (sub_nonneg.mpr ht.2)]
    rw [show t + (1 - t) = 1 by linarith, ENNReal.ofReal_one])

private theorem booleanLaw_toReal (t : ℝ) (ht : 0 ≤ t ∧ t ≤ 1) (b : Bool) :
    (booleanLaw t ht b).toReal = if b then t else 1 - t := by
  cases b <;>
    simp [booleanLaw, PMF.ofFintype_apply, ENNReal.toReal_ofReal,
      ht.1, sub_nonneg.mpr ht.2]

private theorem booleanLaw_distance (t s : ℝ)
    (ht : 0 ≤ t ∧ t ≤ 1) (hs : 0 ≤ s ∧ s ≤ 1) :
    PMF.totalVariation (booleanLaw t ht) (booleanLaw s hs) = |t - s| := by
  rw [PMF.totalVariation, Fintype.sum_bool]
  simp only [booleanLaw_toReal, Bool.false_eq_true, ↓reduceIte]
  rw [show 1 - t - (1 - s) = -(t - s) by linarith, abs_neg]
  linarith

private theorem boolean_both_orders (t s : ℝ)
    (ht : 0 ≤ t ∧ t ≤ 1) (hs : 0 ≤ s ∧ s ≤ 1) :
    ENNReal.ofReal (2 * (t - s) ^ 2) ≤
        InformationTheory.klDiv (booleanLaw t ht).toMeasure (booleanLaw s hs).toMeasure ∧
      ENNReal.ofReal (2 * (s - t) ^ 2) ≤
        InformationTheory.klDiv (booleanLaw s hs).toMeasure (booleanLaw t ht).toMeasure := by
  constructor
  · simpa only [booleanLaw_distance, sq_abs] using
      ofReal_two_mul_totalVariation_sq_le_klDiv (booleanLaw t ht) (booleanLaw s hs)
  · simpa only [booleanLaw_distance, sq_abs] using
      ofReal_two_mul_totalVariation_sq_le_klDiv (booleanLaw s hs) (booleanLaw t ht)

private theorem boolean_equal_and_tied (t : ℝ) (ht : 0 ≤ t ∧ t ≤ 1) :
    {b | (booleanLaw t ht b).toReal ≤ (booleanLaw t ht b).toReal} = Set.univ ∧
      InformationTheory.klDiv (booleanLaw t ht).toMeasure (booleanLaw t ht).toMeasure = 0 ∧
      ENNReal.ofReal (2 * PMF.totalVariation (booleanLaw t ht) (booleanLaw t ht) ^ 2) ≤
        InformationTheory.klDiv (booleanLaw t ht).toMeasure (booleanLaw t ht).toMeasure := by
  exact ⟨by simp, (equal_laws (booleanLaw t ht)).2⟩

private theorem boolean_interior_reference (t s : ℝ)
    (ht : 0 ≤ t ∧ t ≤ 1) (hs : 0 < s ∧ s < 1) :
    InformationTheory.klDiv (booleanLaw t ht).toMeasure
        (booleanLaw s ⟨hs.1.le, hs.2.le⟩).toMeasure ≠ ⊤ ∧
      ENNReal.ofReal (2 * (t - s) ^ 2) ≤
        InformationTheory.klDiv (booleanLaw t ht).toMeasure
          (booleanLaw s ⟨hs.1.le, hs.2.le⟩).toMeasure := by
  refine ⟨(klDiv_pmf_ne_top_iff_support_subset _ _).2 ?_,
    (boolean_both_orders t s ht ⟨hs.1.le, hs.2.le⟩).1⟩
  intro b _
  rw [PMF.mem_support_iff]
  cases b
  · simpa [booleanLaw, PMF.ofFintype_apply] using
      ne_of_gt (ENNReal.ofReal_pos.mpr (sub_pos.mpr hs.2))
  · simpa [booleanLaw, PMF.ofFintype_apply] using ne_of_gt (ENNReal.ofReal_pos.mpr hs.1)

private theorem boolean_numerator_endpoints (s : ℝ) (hs : 0 < s ∧ s < 1) :
    (InformationTheory.klDiv (booleanLaw 0 (by norm_num)).toMeasure
        (booleanLaw s ⟨hs.1.le, hs.2.le⟩).toMeasure ≠ ⊤ ∧
      ENNReal.ofReal (2 * s ^ 2) ≤
        InformationTheory.klDiv (booleanLaw 0 (by norm_num)).toMeasure
          (booleanLaw s ⟨hs.1.le, hs.2.le⟩).toMeasure) ∧
    (InformationTheory.klDiv (booleanLaw 1 (by norm_num)).toMeasure
        (booleanLaw s ⟨hs.1.le, hs.2.le⟩).toMeasure ≠ ⊤ ∧
      ENNReal.ofReal (2 * (1 - s) ^ 2) ≤
        InformationTheory.klDiv (booleanLaw 1 (by norm_num)).toMeasure
          (booleanLaw s ⟨hs.1.le, hs.2.le⟩).toMeasure) := by
  constructor
  · simpa only [zero_sub, neg_sq] using boolean_interior_reference 0 s (by norm_num) hs
  · exact boolean_interior_reference 1 s (by norm_num) hs

private theorem boolean_reference_zero_singular (t : ℝ) (ht : 0 < t ∧ t ≤ 1) :
    InformationTheory.klDiv (booleanLaw t ⟨ht.1.le, ht.2⟩).toMeasure
        (booleanLaw 0 (by norm_num)).toMeasure = ⊤ ∧
      ENNReal.ofReal (2 * t ^ 2) ≤
        InformationTheory.klDiv (booleanLaw t ⟨ht.1.le, ht.2⟩).toMeasure
          (booleanLaw 0 (by norm_num)).toMeasure := by
  constructor
  · apply (klDiv_pmf_eq_top_iff_not_support_subset _ _).2
    intro h
    have htrue : true ∈ (booleanLaw t ⟨ht.1.le, ht.2⟩).support := by
      rw [PMF.mem_support_iff]
      simpa [booleanLaw, PMF.ofFintype_apply] using ne_of_gt (ENNReal.ofReal_pos.mpr ht.1)
    simpa [PMF.mem_support_iff, booleanLaw, PMF.ofFintype_apply] using h htrue
  · simpa only [sub_zero] using
      (boolean_both_orders t 0 ⟨ht.1.le, ht.2⟩ (by norm_num)).1

private theorem boolean_reference_one_singular (t : ℝ) (ht : 0 ≤ t ∧ t < 1) :
    InformationTheory.klDiv (booleanLaw t ⟨ht.1, ht.2.le⟩).toMeasure
        (booleanLaw 1 (by norm_num)).toMeasure = ⊤ ∧
      ENNReal.ofReal (2 * (t - 1) ^ 2) ≤
        InformationTheory.klDiv (booleanLaw t ⟨ht.1, ht.2.le⟩).toMeasure
          (booleanLaw 1 (by norm_num)).toMeasure := by
  constructor
  · apply (klDiv_pmf_eq_top_iff_not_support_subset _ _).2
    intro h
    have hfalse : false ∈ (booleanLaw t ⟨ht.1, ht.2.le⟩).support := by
      rw [PMF.mem_support_iff]
      simpa [booleanLaw, PMF.ofFintype_apply] using
        ne_of_gt (ENNReal.ofReal_pos.mpr (sub_pos.mpr ht.2))
    simpa [PMF.mem_support_iff, booleanLaw, PMF.ofFintype_apply] using h hfalse
  · exact (boolean_both_orders t 1 ⟨ht.1, ht.2.le⟩ (by norm_num)).1

private theorem boolean_reference_endpoints_matching :
    InformationTheory.klDiv (booleanLaw 0 (by norm_num)).toMeasure
        (booleanLaw 0 (by norm_num)).toMeasure = 0 ∧
      InformationTheory.klDiv (booleanLaw 1 (by norm_num)).toMeasure
        (booleanLaw 1 (by norm_num)).toMeasure = 0 :=
  ⟨(boolean_equal_and_tied 0 (by norm_num)).2.1,
    (boolean_equal_and_tied 1 (by norm_num)).2.1⟩

private theorem singular_pure_distance :
    PMF.totalVariation (PMF.pure false) (PMF.pure true) = 1 :=
  (PMF.totalVariation_eq_one_iff_disjoint_support _ _).2 (by simp)

private theorem singular_pure_kl_top :
    InformationTheory.klDiv (PMF.pure false).toMeasure (PMF.pure true).toMeasure = ⊤ := by
  apply (klDiv_pmf_eq_top_iff_not_support_subset _ _).2
  simp

private theorem singular_pure_toReal_zero :
    (InformationTheory.klDiv (PMF.pure false).toMeasure (PMF.pure true).toMeasure).toReal =
      0 := by
  rw [singular_pure_kl_top]
  simp

private theorem singular_pure_canonical :
    ENNReal.ofReal (2 * PMF.totalVariation (PMF.pure false) (PMF.pure true) ^ 2) ≤
      InformationTheory.klDiv (PMF.pure false).toMeasure (PMF.pure true).toMeasure :=
  ofReal_two_mul_totalVariation_sq_le_klDiv (PMF.pure false) (PMF.pure true)

private theorem singular_pure_real_bound_false :
    ¬ (2 * PMF.totalVariation (PMF.pure false) (PMF.pure true) ^ 2 ≤
      (InformationTheory.klDiv (PMF.pure false).toMeasure (PMF.pure true).toMeasure).toReal) := by
  rw [singular_pure_distance, singular_pure_toReal_zero]
  norm_num

private theorem singular_pure_sqrt_bound_false :
    ¬ (PMF.totalVariation (PMF.pure false) (PMF.pure true) ≤
      Real.sqrt ((InformationTheory.klDiv
        (PMF.pure false).toMeasure (PMF.pure true).toMeasure).toReal / 2)) := by
  rw [singular_pure_distance, singular_pure_toReal_zero]
  norm_num

end Boolean

section PositiveTernary

local instance : MeasurableSpace (Fin 3) := ⊤
local instance : MeasurableSingletonClass (Fin 3) := ⟨fun _ => trivial⟩
local instance : MeasurableSpace Bool := ⊤
local instance : MeasurableSingletonClass Bool := ⟨fun _ => trivial⟩

private def positiveP : PMF (Fin 3) :=
  PMF.ofFintype (fun a => ENNReal.ofReal (if a.val = 0 then (1 / 2 : ℝ) else 1 / 4)) (by
    have hn (a : Fin 3) : 0 ≤ (if a.val = 0 then (1 / 2 : ℝ) else 1 / 4) := by
      split_ifs <;> norm_num
    rw [← ENNReal.ofReal_sum_of_nonneg (fun a _ => hn a), Fin.sum_univ_three]
    change ENNReal.ofReal ((1 / 2 : ℝ) + 1 / 4 + 1 / 4) = 1
    norm_num)

private def positiveQ : PMF (Fin 3) :=
  PMF.ofFintype (fun a => ENNReal.ofReal (if a.val = 2 then (1 / 2 : ℝ) else 1 / 4)) (by
    have hn (a : Fin 3) : 0 ≤ (if a.val = 2 then (1 / 2 : ℝ) else 1 / 4) := by
      split_ifs <;> norm_num
    rw [← ENNReal.ofReal_sum_of_nonneg (fun a _ => hn a), Fin.sum_univ_three]
    change ENNReal.ofReal ((1 / 4 : ℝ) + 1 / 4 + 1 / 2) = 1
    norm_num)

private theorem positiveP_zero : positiveP 0 = ENNReal.ofReal (1 / 2 : ℝ) := rfl
private theorem positiveP_one : positiveP 1 = ENNReal.ofReal (1 / 4 : ℝ) := rfl
private theorem positiveP_two : positiveP 2 = ENNReal.ofReal (1 / 4 : ℝ) := rfl
private theorem positiveQ_zero : positiveQ 0 = ENNReal.ofReal (1 / 4 : ℝ) := rfl
private theorem positiveQ_one : positiveQ 1 = ENNReal.ofReal (1 / 4 : ℝ) := rfl
private theorem positiveQ_two : positiveQ 2 = ENNReal.ofReal (1 / 2 : ℝ) := rfl

private theorem positive_atoms (a : Fin 3) : 0 < positiveP a ∧ 0 < positiveQ a := by
  simp only [positiveP, positiveQ, PMF.ofFintype_apply]
  constructor <;> split_ifs <;> norm_num

private theorem positive_support : positiveP.support ⊆ positiveQ.support := by
  intro a _
  exact (positiveQ.mem_support_iff a).2 (ne_of_gt (positive_atoms a).2)

private theorem positive_finite :
    InformationTheory.klDiv positiveP.toMeasure positiveQ.toMeasure ≠ ⊤ :=
  (klDiv_pmf_ne_top_iff_support_subset positiveP positiveQ).2 positive_support

private theorem positive_tie :
    positiveP 1 = positiveQ 1 ∧ 0 < (positiveP 1).toReal := by
  norm_num [positiveP_one, positiveQ_one]

private theorem positive_attaining_event :
    {a | (positiveQ a).toReal ≤ (positiveP a).toReal} = ({0, 1} : Set (Fin 3)) := by
  ext a
  fin_cases a <;>
    norm_num [positiveP_zero, positiveP_one, positiveP_two,
      positiveQ_zero, positiveQ_one, positiveQ_two,
      show (2 : Fin 3) ≠ 0 by decide, show (2 : Fin 3) ≠ 1 by decide]
  change (ENNReal.ofReal (1 / 4 : ℝ)).toReal < (ENNReal.ofReal (1 / 2 : ℝ)).toReal
  norm_num

private theorem positive_distance : PMF.totalVariation positiveP positiveQ = 1 / 4 := by
  rw [PMF.totalVariation, Fin.sum_univ_three]
  norm_num [positiveP_zero, positiveP_one, positiveP_two,
    positiveQ_zero, positiveQ_one, positiveQ_two]

private theorem positive_real_kl :
    (InformationTheory.klDiv positiveP.toMeasure positiveQ.toMeasure).toReal =
      (1 / 4 : ℝ) * Real.log 2 := by
  have hac := (toMeasure_absolutelyContinuous_iff_support_subset positiveP positiveQ).2
    positive_support
  rw [toReal_klDiv_pmf_eq_sum positiveP positiveQ hac, Fin.sum_univ_three]
  have hlog : Real.log (1 / 2 : ℝ) = -Real.log 2 := by
    simpa only [one_div] using Real.log_inv 2
  norm_num [positiveP_zero, positiveP_one, positiveP_two,
    positiveQ_zero, positiveQ_one, positiveQ_two, ENNReal.toReal_div, hlog]
  ring

private theorem positive_kl :
    InformationTheory.klDiv positiveP.toMeasure positiveQ.toMeasure =
      ENNReal.ofReal ((1 / 4 : ℝ) * Real.log 2) := by
  rw [← ENNReal.ofReal_toReal positive_finite, positive_real_kl]

private def positiveIndicator (a : Fin 3) : Bool :=
  if a ∈ ({0, 1} : Set (Fin 3)) then true else false

private theorem positive_indicator_preimage :
    positiveIndicator ⁻¹' ({true} : Set Bool) = ({0, 1} : Set (Fin 3)) := by
  ext a
  simp [positiveIndicator]

private theorem positive_indicator_masses :
    ((positiveP.map positiveIndicator) true).toReal = 3 / 4 ∧
      ((positiveQ.map positiveIndicator) true).toReal = 1 / 2 := by
  constructor <;>
    rw [← PMF.toOuterMeasure_apply_singleton, PMF.toOuterMeasure_map_apply,
      positive_indicator_preimage, PMF.toOuterMeasure_toReal_eq_sum, Fin.sum_univ_three] <;>
    norm_num [Set.indicator, positiveP_zero, positiveP_one, positiveP_two,
      positiveQ_zero, positiveQ_one, positiveQ_two,
      show (2 : Fin 3) ≠ 0 by decide, show (2 : Fin 3) ≠ 1 by decide]

private theorem positive_indicator_preserves_distance :
    PMF.totalVariation (positiveP.map positiveIndicator) (positiveQ.map positiveIndicator) =
      PMF.totalVariation positiveP positiveQ := by
  have hgap : ((positiveP.map positiveIndicator).toOuterMeasure {true}).toReal -
      ((positiveQ.map positiveIndicator).toOuterMeasure {true}).toReal =
        PMF.totalVariation positiveP positiveQ := by
    rw [PMF.toOuterMeasure_map_apply, PMF.toOuterMeasure_map_apply,
      positive_indicator_preimage]
    rw [PMF.totalVariation_eq_toOuterMeasure_sub, positive_attaining_event]
  apply le_antisymm
  · exact PMF.totalVariation_map_le positiveP positiveQ positiveIndicator
  · have h := PMF.abs_toOuterMeasure_sub_le_totalVariation
      (positiveP.map positiveIndicator) (positiveQ.map positiveIndicator) {true}
    rwa [hgap, abs_of_nonneg (PMF.totalVariation_nonneg positiveP positiveQ)] at h

private theorem positive_binary_reduction :
    ENNReal.ofReal (2 * (1 / 4 : ℝ) ^ 2) ≤
        InformationTheory.klDiv (positiveP.map positiveIndicator).toMeasure
          (positiveQ.map positiveIndicator).toMeasure ∧
      InformationTheory.klDiv (positiveP.map positiveIndicator).toMeasure
          (positiveQ.map positiveIndicator).toMeasure ≤
        InformationTheory.klDiv positiveP.toMeasure positiveQ.toMeasure := by
  constructor
  · simpa only [positive_indicator_preserves_distance, positive_distance] using
      ofReal_two_mul_totalVariation_sq_le_klDiv
        (positiveP.map positiveIndicator) (positiveQ.map positiveIndicator)
  · exact klDiv_map_le positiveP positiveQ positiveIndicator

private theorem positive_canonical :
    ENNReal.ofReal (2 * (1 / 4 : ℝ) ^ 2) ≤
      ENNReal.ofReal ((1 / 4 : ℝ) * Real.log 2) := by
  simpa only [positive_distance, positive_kl] using
    ofReal_two_mul_totalVariation_sq_le_klDiv positiveP positiveQ

end PositiveTernary

section SparseTernary

local instance : MeasurableSpace (Fin 3) := ⊤
local instance : MeasurableSingletonClass (Fin 3) := ⟨fun _ => trivial⟩

private def sparsePoint : PMF (Fin 3) := PMF.pure 0

private def sparseReference : PMF (Fin 3) :=
  PMF.ofFintype (fun a => ENNReal.ofReal (if a.val = 2 then (0 : ℝ) else 1 / 2)) (by
    have hn (a : Fin 3) : 0 ≤ (if a.val = 2 then (0 : ℝ) else 1 / 2) := by
      split_ifs <;> norm_num
    rw [← ENNReal.ofReal_sum_of_nonneg (fun a _ => hn a), Fin.sum_univ_three]
    change ENNReal.ofReal ((1 / 2 : ℝ) + 1 / 2 + 0) = 1
    norm_num)

private theorem sparsePoint_zero : sparsePoint 0 = 1 := by
  simp [sparsePoint]

private theorem sparsePoint_one : sparsePoint 1 = 0 := by
  simp [sparsePoint]

private theorem sparsePoint_two : sparsePoint 2 = 0 := by
  simp [sparsePoint, show (2 : Fin 3) ≠ 0 by decide]

private theorem sparseReference_zero :
    sparseReference 0 = ENNReal.ofReal (1 / 2 : ℝ) := rfl

private theorem sparseReference_one :
    sparseReference 1 = ENNReal.ofReal (1 / 2 : ℝ) := rfl

private theorem sparseReference_two : sparseReference 2 = 0 := by
  change ENNReal.ofReal (0 : ℝ) = 0
  exact ENNReal.ofReal_zero

private theorem sparse_common_zero :
    sparsePoint 2 = 0 ∧ sparseReference 2 = 0 ∧
      (2 : Fin 3) ∉ sparseReference.support := by
  exact ⟨sparsePoint_two, sparseReference_two,
    (sparseReference.apply_eq_zero_iff 2).1 sparseReference_two⟩

private theorem sparse_support : sparsePoint.support ⊆ sparseReference.support := by
  have hzero : (0 : Fin 3) ∈ sparseReference.support := by
    rw [PMF.mem_support_iff, sparseReference_zero]
    norm_num
  simpa only [sparsePoint, PMF.support_pure, Set.singleton_subset_iff] using hzero

private theorem sparse_finite :
    InformationTheory.klDiv sparsePoint.toMeasure sparseReference.toMeasure ≠ ⊤ :=
  (klDiv_pmf_ne_top_iff_support_subset sparsePoint sparseReference).2 sparse_support

private theorem sparse_distance : PMF.totalVariation sparsePoint sparseReference = 1 / 2 := by
  rw [PMF.totalVariation, Fin.sum_univ_three]
  norm_num [sparsePoint_zero, sparsePoint_one, sparsePoint_two,
    sparseReference_zero, sparseReference_one, sparseReference_two]

private theorem sparse_real_kl :
    (InformationTheory.klDiv sparsePoint.toMeasure sparseReference.toMeasure).toReal =
      Real.log 2 := by
  have hac :=
    (toMeasure_absolutelyContinuous_iff_support_subset sparsePoint sparseReference).2
      sparse_support
  rw [toReal_klDiv_pmf_eq_sum sparsePoint sparseReference hac, Fin.sum_univ_three]
  norm_num [sparsePoint_zero, sparsePoint_one, sparsePoint_two,
    sparseReference_zero, sparseReference_one, sparseReference_two, ENNReal.toReal_div]

private theorem sparse_kl :
    InformationTheory.klDiv sparsePoint.toMeasure sparseReference.toMeasure =
      ENNReal.ofReal (Real.log 2) := by
  rw [← ENNReal.ofReal_toReal sparse_finite, sparse_real_kl]

private theorem sparse_canonical :
    ENNReal.ofReal (1 / 2 : ℝ) ≤ ENNReal.ofReal (Real.log 2) := by
  have h := ofReal_two_mul_totalVariation_sq_le_klDiv sparsePoint sparseReference
  rw [sparse_distance, sparse_kl] at h
  norm_num at h ⊢
  exact h

private theorem sparse_guarded_bounds :
    (1 / 2 : ℝ) ≤ Real.log 2 ∧ (1 / 2 : ℝ) ≤ Real.sqrt (Real.log 2 / 2) := by
  have h := support_guard_bounds sparsePoint sparseReference sparse_support
  rw [sparse_distance, sparse_real_kl] at h
  norm_num at h ⊢
  exact h

private theorem sparse_non_top_bounds :
    (1 / 2 : ℝ) ≤ Real.log 2 ∧ (1 / 2 : ℝ) ≤ Real.sqrt (Real.log 2 / 2) := by
  have h := non_top_guard_bounds sparsePoint sparseReference sparse_finite
  rw [sparse_distance, sparse_real_kl] at h
  norm_num at h ⊢
  exact h

private theorem sparse_event_discrepancy :
    |(sparsePoint.toOuterMeasure {0}).toReal -
      (sparseReference.toOuterMeasure {0}).toReal| = 1 / 2 := by
  rw [PMF.toOuterMeasure_apply_singleton, PMF.toOuterMeasure_apply_singleton,
    sparsePoint_zero, sparseReference_zero]
  norm_num

private theorem sparse_event_budget :
    (1 / 2 : ℝ) ≤ Real.sqrt (Real.log 2 / 2) := by
  have h := event_discrepancy_le_sqrt_of_klDiv_le sparsePoint sparseReference {0}
    (Real.log 2) (Real.log_nonneg (by norm_num)) sparse_kl.le
  rwa [sparse_event_discrepancy] at h

end SparseTernary

end

end LeanInfoTheory.Examples.Pinsker
