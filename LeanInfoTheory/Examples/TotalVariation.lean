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
# Finite total-variation consumers

These private consumers use the focused probability import. They check
self-distance, recover atom masses through separation, and verify the
probability normalization on distinct pure Boolean laws. Event consumers exercise
empty/full and tied events, Finset coercions, a nontrivial Boolean maximizing
event, and generic Boolean indicator pushforwards through the public interfaces.
Overlap consumers derive finite normalization premises for both residual laws,
check equal/disjoint endpoints, and evaluate a sparse three-point example.
Bounded-test consumers recover both generic signed greatest values from the
public absolute forms, exhibit sharp Boolean tests, and check constant tests,
zero-radius bounds and zero-width intervals. The integrated Boolean family
connects these interfaces for arbitrary parameters and their endpoints. Generic
maximizing-event reduction preserves TV exactly, and degenerate alphabets and
remaining core interfaces are exercised without extra public helpers.
-/

namespace LeanInfoTheory.Examples.TotalVariation

open scoped BigOperators ENNReal

private theorem boolean_self (p : PMF Bool) : PMF.totalVariation p p = 0 :=
  PMF.totalVariation_self p

private theorem recover_pure_false (p : PMF Bool)
    (h : PMF.totalVariation p (PMF.pure false) = 0) : p false = 1 ∧ p true = 0 := by
  have hp := (PMF.totalVariation_eq_zero_iff p (PMF.pure false)).1 h
  simp [hp]

private theorem distinct_pure_distance :
    PMF.totalVariation (PMF.pure false) (PMF.pure true) = 1 := by
  norm_num [PMF.totalVariation, Fintype.sum_bool, PMF.pure_apply]

private theorem empty_full_events {α : Type*} [Fintype α] (p q : PMF α) :
    (p.toOuterMeasure ∅).toReal = 0 ∧ (p.toOuterMeasure Set.univ).toReal = 1 ∧
      |(p.toOuterMeasure ∅).toReal - (q.toOuterMeasure ∅).toReal| ≤ PMF.totalVariation p q ∧
      |(p.toOuterMeasure Set.univ).toReal - (q.toOuterMeasure Set.univ).toReal| ≤
        PMF.totalVariation p q := by
  refine ⟨?_, ?_, PMF.abs_toOuterMeasure_sub_le_totalVariation p q ∅,
    PMF.abs_toOuterMeasure_sub_le_totalVariation p q Set.univ⟩
  · rw [PMF.toOuterMeasure_toReal_eq_sum]
    simp
  · rw [PMF.toOuterMeasure_toReal_eq_sum]
    simpa only [Set.indicator_univ] using p.sum_toReal

private theorem finset_event {α : Type*} [Finite α] (p : PMF α) (s : Finset α) :
    (p.toOuterMeasure (s : Set α)).toReal = ∑ a ∈ s, (p a).toReal := by
  classical
  let : Fintype α := Fintype.ofFinite α
  rw [PMF.toOuterMeasure_toReal_eq_sum]
  simp [Set.indicator]

private theorem all_tied_event {α : Type*} [Finite α] (p : PMF α) :
    {a | (p a).toReal ≤ (p a).toReal} = (Set.univ : Set α) ∧
      (p.toOuterMeasure {a | (p a).toReal ≤ (p a).toReal}).toReal -
        (p.toOuterMeasure {a | (p a).toReal ≤ (p a).toReal}).toReal = 0 := by
  let : Fintype α := Fintype.ofFinite α
  constructor
  · ext a
    simp
  · rw [← PMF.totalVariation_eq_toOuterMeasure_sub, PMF.totalVariation_self]

private noncomputable def booleanLaw (heavy : Bool) : PMF Bool :=
  PMF.ofFintype (fun b => if b = heavy then (3 / 4 : ℝ≥0∞) else 1 / 4)
    (by
      cases heavy <;>
        (norm_num [Fintype.sum_bool, ← ENNReal.add_div, ← one_div]
         exact ENNReal.div_self (by norm_num) (by norm_num)))

private theorem boolean_attaining_event :
    {b | (booleanLaw true b).toReal ≤ (booleanLaw false b).toReal} = ({false} : Set Bool) ∧
      PMF.totalVariation (booleanLaw false) (booleanLaw true) = 1 / 2 := by
  have hevent : {b | (booleanLaw true b).toReal ≤ (booleanLaw false b).toReal} =
      ({false} : Set Bool) := by
    ext b
    cases b <;> norm_num [booleanLaw, PMF.ofFintype_apply]
  refine ⟨hevent, ?_⟩
  rw [PMF.totalVariation_eq_toOuterMeasure_sub, hevent,
    PMF.toOuterMeasure_toReal_eq_sum, PMF.toOuterMeasure_toReal_eq_sum]
  norm_num [Fintype.sum_bool, booleanLaw, PMF.ofFintype_apply, Set.indicator]

private noncomputable def eventIndicator {α : Type*} (s : Set α) (a : α) : Bool := by
  classical
  exact decide (a ∈ s)

private theorem indicator_event_probability {α : Type*} [Fintype α]
    (p : PMF α) (s : Set α) :
    ((p.map (eventIndicator s)).toOuterMeasure {true}).toReal =
      ∑ a, s.indicator (fun a => (p a).toReal) a := by
  have hpre : eventIndicator s ⁻¹' ({true} : Set Bool) = s := by
    ext a
    simp [eventIndicator]
  rw [PMF.toOuterMeasure_map_apply, hpre, PMF.toOuterMeasure_toReal_eq_sum]

private theorem indicator_event_bound {α : Type*} [Fintype α]
    (p q : PMF α) (s : Set α) :
    |((p.map (eventIndicator s)).toOuterMeasure {true}).toReal -
      ((q.map (eventIndicator s)).toOuterMeasure {true}).toReal| ≤ PMF.totalVariation p q := by
  rw [indicator_event_probability, indicator_event_probability,
    ← PMF.toOuterMeasure_toReal_eq_sum, ← PMF.toOuterMeasure_toReal_eq_sum]
  exact PMF.abs_toOuterMeasure_sub_le_totalVariation p q s

private theorem boolean_indicator_gap :
    (((booleanLaw false).map (eventIndicator {false})).toOuterMeasure {true}).toReal -
      (((booleanLaw true).map (eventIndicator {false})).toOuterMeasure {true}).toReal =
        PMF.totalVariation (booleanLaw false) (booleanLaw true) := by
  rw [indicator_event_probability, indicator_event_probability, boolean_attaining_event.2]
  norm_num [Fintype.sum_bool, booleanLaw, PMF.ofFintype_apply, Set.indicator]

private theorem overlap_residual_totals {α : Type*} [Fintype α] (p q : PMF α) :
    (∑ a, min (p a) (q a)) = ENNReal.ofReal (1 - PMF.totalVariation p q) ∧
    (∑ a, (p a - min (p a) (q a))) = ENNReal.ofReal (PMF.totalVariation p q) ∧
    (∑ a, (q a - min (p a) (q a))) = ENNReal.ofReal (PMF.totalVariation p q) := by
  refine ⟨PMF.sum_min_eq_ofReal_one_sub_totalVariation p q, ?_, ?_⟩
  · simpa only [tsub_min] using (PMF.ofReal_totalVariation_eq_sum_sub p q).symm
  · calc
      (∑ a, (q a - min (p a) (q a))) = ∑ a, (q a - p a) := by
        apply Finset.sum_congr rfl
        intro a _
        rw [min_comm (p a) (q a), tsub_min]
      _ = ENNReal.ofReal (PMF.totalVariation q p) :=
        (PMF.ofReal_totalVariation_eq_sum_sub q p).symm
      _ = ENNReal.ofReal (PMF.totalVariation p q) := by
        rw [PMF.totalVariation_comm q p]

private theorem overlap_residual_finite {α : Type*} [Fintype α] (p q : PMF α) :
    (∑ a, min (p a) (q a)) < ⊤ ∧
    (∑ a, (p a - min (p a) (q a))) < ⊤ ∧
    (∑ a, (q a - min (p a) (q a))) < ⊤ := by
  have h := overlap_residual_totals p q
  rw [h.1, h.2.1, h.2.2]
  exact ⟨ENNReal.ofReal_lt_top, ENNReal.ofReal_lt_top, ENNReal.ofReal_lt_top⟩

private theorem interior_positive_totals {α : Type*} [Fintype α] (p q : PMF α)
    (h0 : 0 < PMF.totalVariation p q) (h1 : PMF.totalVariation p q < 1) :
    0 < (∑ a, min (p a) (q a)) ∧
    0 < (∑ a, (p a - min (p a) (q a))) ∧
    0 < (∑ a, (q a - min (p a) (q a))) := by
  have h := overlap_residual_totals p q
  rw [h.1, h.2.1, h.2.2]
  exact ⟨ENNReal.ofReal_pos.mpr (sub_pos.mpr h1),
    ENNReal.ofReal_pos.mpr h0, ENNReal.ofReal_pos.mpr h0⟩

private theorem interior_normalization_premises {α : Type*} [Fintype α]
    (p q : PMF α) (h0 : 0 < PMF.totalVariation p q)
    (h1 : PMF.totalVariation p q < 1) :
    ((∑' a, min (p a) (q a)) ≠ 0 ∧ (∑' a, min (p a) (q a)) ≠ ⊤) ∧
    ((∑' a, (p a - min (p a) (q a))) ≠ 0 ∧
      (∑' a, (p a - min (p a) (q a))) ≠ ⊤) ∧
    ((∑' a, (q a - min (p a) (q a))) ≠ 0 ∧
      (∑' a, (q a - min (p a) (q a))) ≠ ⊤) := by
  have hpos := interior_positive_totals p q h0 h1
  have hfin := overlap_residual_finite p q
  simpa only [tsum_fintype] using
    And.intro (And.intro (ne_of_gt hpos.1) (ne_of_lt hfin.1))
      (And.intro (And.intro (ne_of_gt hpos.2.1) (ne_of_lt hfin.2.1))
        (And.intro (ne_of_gt hpos.2.2) (ne_of_lt hfin.2.2)))

private theorem equal_overlap_residuals {α : Type*} [Fintype α] (p : PMF α) :
    (∑ a, min (p a) (p a)) = 1 ∧
    (∑ a, (p a - min (p a) (p a))) = 0 ∧
    (∑ a, (p a - min (p a) (p a))) = 0 := by
  simpa only [PMF.totalVariation_self, sub_zero, ENNReal.ofReal_one,
    ENNReal.ofReal_zero] using overlap_residual_totals p p

private theorem disjoint_overlap_residuals {α : Type*} [Fintype α] (p q : PMF α)
    (hdis : Disjoint p.support q.support) :
    (∑ a, min (p a) (q a)) = 0 ∧
    (∑ a, (p a - min (p a) (q a))) = 1 ∧
    (∑ a, (q a - min (p a) (q a))) = 1 := by
  have hT := (PMF.totalVariation_eq_one_iff_disjoint_support p q).2 hdis
  simpa only [hT, sub_self, ENNReal.ofReal_zero, ENNReal.ofReal_one] using
    overlap_residual_totals p q

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

private theorem sparse_totalVariation : PMF.totalVariation sparseP sparseQ = 1 / 2 := by
  rw [PMF.totalVariation_eq_one_sub_sum_min, Fin.sum_univ_three]
  norm_num [sparseP, sparseQ, PMF.ofFintype_apply, show (1 : Fin 3) ≠ 2 by decide]

private theorem sparse_totals :
    (∑ a, min (sparseP a) (sparseQ a)) = (1 / 2 : ℝ≥0∞) ∧
    (∑ a, (sparseP a - min (sparseP a) (sparseQ a))) = (1 / 2 : ℝ≥0∞) ∧
    (∑ a, (sparseQ a - min (sparseP a) (sparseQ a))) = (1 / 2 : ℝ≥0∞) := by
  have h := overlap_residual_totals sparseP sparseQ
  norm_num [sparse_totalVariation] at h
  simpa only [ENNReal.ofReal_div_of_pos (by norm_num : (0 : ℝ) < 2),
    ENNReal.ofReal_one, ENNReal.ofReal_ofNat] using h


private theorem test_gap_complement {α : Type*} [Fintype α]
    (p q : PMF α) (f : α → ℝ) :
    (∑ a, (p a).toReal * (1 - f a)) - (∑ a, (q a).toReal * (1 - f a)) =
      -((∑ a, (p a).toReal * f a) - (∑ a, (q a).toReal * f a)) := by
  simp only [mul_sub, mul_one, Finset.sum_sub_distrib, PMF.sum_toReal]
  linarith

private theorem test_gap_neg {α : Type*} [Fintype α]
    (p q : PMF α) (f : α → ℝ) :
    (∑ a, (p a).toReal * (-f a)) - (∑ a, (q a).toReal * (-f a)) =
      -((∑ a, (p a).toReal * f a) - (∑ a, (q a).toReal * f a)) := by
  simp only [mul_neg, Finset.sum_neg_distrib]
  linarith

private theorem signed_unitInterval_greatest {α : Type*} [Fintype α]
    (p q : PMF α) :
    IsGreatest {d : ℝ | ∃ f : α → ℝ,
      (∀ a, 0 ≤ f a ∧ f a ≤ 1) ∧
      d = (∑ a, (p a).toReal * f a) - (∑ a, (q a).toReal * f a)}
      (PMF.totalVariation p q) := by
  have hG := PMF.totalVariation_isGreatest_unitInterval p q
  constructor
  · rcases hG.1 with ⟨f, hf, heq⟩
    by_cases hs : 0 ≤ (∑ a, (p a).toReal * f a) - (∑ a, (q a).toReal * f a)
    · refine ⟨f, hf, ?_⟩
      simpa only [abs_of_nonneg hs] using heq
    · refine ⟨fun a => 1 - f a, ?_, ?_⟩
      · intro a
        constructor <;> linarith [(hf a).1, (hf a).2]
      · rw [test_gap_complement p q f]
        simpa only [abs_of_neg (lt_of_not_ge hs)] using heq
  · rintro d ⟨f, hf, rfl⟩
    exact (le_abs_self _).trans (hG.2 ⟨f, hf, rfl⟩)

private theorem signed_bounded_greatest {α : Type*} [Fintype α]
    (p q : PMF α) :
    IsGreatest {d : ℝ | ∃ f : α → ℝ,
      (∀ a, |f a| ≤ 1) ∧
      d = (∑ a, (p a).toReal * f a) - (∑ a, (q a).toReal * f a)}
      (2 * PMF.totalVariation p q) := by
  have hG := PMF.two_mul_totalVariation_isGreatest_bounded p q
  constructor
  · rcases hG.1 with ⟨f, hf, heq⟩
    by_cases hs : 0 ≤ (∑ a, (p a).toReal * f a) - (∑ a, (q a).toReal * f a)
    · refine ⟨f, hf, ?_⟩
      simpa only [abs_of_nonneg hs] using heq
    · refine ⟨fun a => -f a, ?_, ?_⟩
      · intro a
        simpa only [abs_neg] using hf a
      · rw [test_gap_neg p q f]
        simpa only [abs_of_neg (lt_of_not_ge hs)] using heq
  · rintro d ⟨f, hf, rfl⟩
    exact (le_abs_self _).trans (hG.2 ⟨f, hf, rfl⟩)

private theorem equal_law_signed_greatest {α : Type*} [Fintype α] (p : PMF α) :
    IsGreatest {d : ℝ | ∃ f : α → ℝ,
      (∀ a, 0 ≤ f a ∧ f a ≤ 1) ∧
      d = (∑ a, (p a).toReal * f a) - (∑ a, (p a).toReal * f a)} 0 ∧
    IsGreatest {d : ℝ | ∃ f : α → ℝ,
      (∀ a, |f a| ≤ 1) ∧
      d = (∑ a, (p a).toReal * f a) - (∑ a, (p a).toReal * f a)} 0 := by
  constructor
  · simpa only [PMF.totalVariation_self] using signed_unitInterval_greatest p p
  · simpa only [PMF.totalVariation_self, mul_zero] using signed_bounded_greatest p p

private theorem zero_width_test {α : Type*} [Fintype α]
    (p q : PMF α) (f : α → ℝ) (c : ℝ)
    (hf : ∀ a, c ≤ f a ∧ f a ≤ c) :
    (∑ a, (p a).toReal * f a) - (∑ a, (q a).toReal * f a) = 0 := by
  have h := PMF.abs_sum_sub_le_totalVariation_of_mem_Icc
    (p := p) (q := q) (f := f) (l := c) (u := c) (le_refl c) hf
  have hz : |(∑ a, (p a).toReal * f a) - (∑ a, (q a).toReal * f a)| ≤ 0 := by
    simpa only [sub_self, zero_mul] using h
  exact abs_eq_zero.mp (le_antisymm hz (abs_nonneg _))

private theorem constant_test {α : Type*} [Fintype α]
    (p q : PMF α) (c : ℝ) :
    (∑ a, (p a).toReal * c) - (∑ a, (q a).toReal * c) = 0 := by
  exact zero_width_test p q (fun _ => c) c (fun _ => ⟨le_rfl, le_rfl⟩)

private theorem zero_radius_test {α : Type*} [Fintype α]
    (p q : PMF α) (f : α → ℝ) (hf : ∀ a, |f a| ≤ 0) :
    (∑ a, (p a).toReal * f a) - (∑ a, (q a).toReal * f a) = 0 := by
  have h := PMF.abs_sum_sub_le_mul_totalVariation
    (p := p) (q := q) (f := f) (M := 0) (le_refl 0) hf
  have hz : |(∑ a, (p a).toReal * f a) - (∑ a, (q a).toReal * f a)| ≤ 0 := by
    simpa only [mul_zero, zero_mul] using h
  exact abs_eq_zero.mp (le_antisymm hz (abs_nonneg _))

private def unitBooleanTest (b : Bool) : ℝ := if b = false then 1 else 0

private def signedBooleanTest (b : Bool) : ℝ := if b = false then 1 else -1

private theorem boolean_unit_test_attainment :
    (∀ b, 0 ≤ unitBooleanTest b ∧ unitBooleanTest b ≤ 1) ∧
    (∑ b, (booleanLaw false b).toReal * unitBooleanTest b) -
      (∑ b, (booleanLaw true b).toReal * unitBooleanTest b) =
        PMF.totalVariation (booleanLaw false) (booleanLaw true) := by
  constructor
  · intro b
    cases b <;> norm_num [unitBooleanTest]
  · rw [boolean_attaining_event.2]
    norm_num [Fintype.sum_bool, booleanLaw, PMF.ofFintype_apply, unitBooleanTest]

private theorem boolean_signed_test_attainment :
    (∀ b, |signedBooleanTest b| ≤ 1) ∧
    (∑ b, (booleanLaw false b).toReal * signedBooleanTest b) -
      (∑ b, (booleanLaw true b).toReal * signedBooleanTest b) =
        2 * PMF.totalVariation (booleanLaw false) (booleanLaw true) := by
  constructor
  · intro b
    cases b <;> norm_num [signedBooleanTest]
  · rw [boolean_attaining_event.2]
    norm_num [Fintype.sum_bool, booleanLaw, PMF.ofFintype_apply, signedBooleanTest]

private theorem maximizing_event_boolean_preserves_totalVariation
    {α : Type*} [Fintype α] (p q : PMF α) :
    let A : Set α := {a | (q a).toReal ≤ (p a).toReal}
    let b : α → Bool := fun a => if a ∈ A then true else false
    PMF.totalVariation (p.map b) (q.map b) = PMF.totalVariation p q := by
  classical
  let A : Set α := {a | (q a).toReal ≤ (p a).toReal}
  let b : α → Bool := fun a => if a ∈ A then true else false
  change PMF.totalVariation (p.map b) (q.map b) = PMF.totalVariation p q
  have hpre : b ⁻¹' ({true} : Set Bool) = A := by
    ext a
    by_cases ha : a ∈ A <;> simp [b, ha]
  have hgap : ((p.map b).toOuterMeasure {true}).toReal -
      ((q.map b).toOuterMeasure {true}).toReal = PMF.totalVariation p q := by
    rw [PMF.toOuterMeasure_map_apply, PMF.toOuterMeasure_map_apply, hpre]
    exact (PMF.totalVariation_eq_toOuterMeasure_sub p q).symm
  apply le_antisymm
  · exact PMF.totalVariation_map_le p q b
  · have h := PMF.abs_toOuterMeasure_sub_le_totalVariation (p.map b) (q.map b) {true}
    rwa [hgap, abs_of_nonneg (PMF.totalVariation_nonneg p q)] at h

private theorem subsingleton_distance_zero {α : Type*} [Fintype α] [Subsingleton α]
    (p q : PMF α) : PMF.totalVariation p q = 0 := by
  obtain ⟨a, _⟩ := p.support_nonempty
  have hsupport (r : PMF α) : r.support = {a} := by
    obtain ⟨b, hb⟩ := r.support_nonempty
    apply Set.eq_singleton_iff_unique_mem.mpr
    exact ⟨(Subsingleton.elim b a) ▸ hb, fun x _ => Subsingleton.elim x a⟩
  rw [(PMF.eq_pure_iff_support_eq_singleton p a).2 (hsupport p),
    (PMF.eq_pure_iff_support_eq_singleton q a).2 (hsupport q)]
  exact PMF.totalVariation_self _

private theorem singleton_distance_zero (p q : PMF Unit) :
    PMF.totalVariation p q = 0 :=
  subsingleton_distance_zero p q

private theorem no_empty_alphabet_pmf {α : Type*} [IsEmpty α] :
    ¬ Nonempty (PMF α) := by
  rintro ⟨p⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

private theorem totalVariation_mem_unitInterval {α : Type*} [Fintype α]
    (p q : PMF α) : PMF.totalVariation p q ∈ Set.Icc (0 : ℝ) 1 :=
  ⟨PMF.totalVariation_nonneg p q, PMF.totalVariation_le_one p q⟩

private theorem distance_to_reference_stability {α : Type*} [Fintype α]
    (p q r : PMF α) :
    |PMF.totalVariation p r - PMF.totalVariation q r| ≤ PMF.totalVariation p q := by
  apply abs_le.mpr
  constructor
  · have h := PMF.totalVariation_triangle q p r
    rw [PMF.totalVariation_comm q p] at h
    linarith
  · have h := PMF.totalVariation_triangle p q r
    linarith

private theorem positive_excess_eq_minimum_residual {α : Type*} [Fintype α]
    (p q : PMF α) :
    (∑ a ∈ Finset.univ.filter (fun a => (q a).toReal ≤ (p a).toReal),
      ((p a).toReal - (q a).toReal)) =
        ∑ a, ((p a).toReal - min (p a).toReal (q a).toReal) :=
  (PMF.totalVariation_eq_sum_pos p q).symm.trans (PMF.totalVariation_eq_sum_sub_min p q)

private theorem signed_event_envelope_iff {α : Type*} [Fintype α]
    (p q : PMF α) (c : ℝ) :
    (∀ s : Set α, (p.toOuterMeasure s).toReal - (q.toOuterMeasure s).toReal ≤ c) ↔
      PMF.totalVariation p q ≤ c := by
  have hG := PMF.totalVariation_isGreatest_event p q
  constructor
  · intro h
    rcases hG.1 with ⟨s, hs⟩
    rw [← hs]
    exact h s
  · intro h s
    exact (hG.2 ⟨s, rfl⟩).trans h

private theorem absolute_event_envelope_iff {α : Type*} [Fintype α]
    (p q : PMF α) (c : ℝ) :
    (∀ s : Set α, |(p.toOuterMeasure s).toReal - (q.toOuterMeasure s).toReal| ≤ c) ↔
      PMF.totalVariation p q ≤ c := by
  have hG := PMF.totalVariation_isGreatest_abs_event p q
  constructor
  · intro h
    rcases hG.1 with ⟨s, hs⟩
    rw [← hs]
    exact h s
  · intro h s
    exact (hG.2 ⟨s, rfl⟩).trans h

section ParameterizedBoolean

private noncomputable def booleanFamily (t : ℝ) (ht : 0 ≤ t ∧ t ≤ 1) : PMF Bool :=
  PMF.ofFintype (fun b => ENNReal.ofReal (if b then t else 1 - t)) (by
    simp only [Fintype.sum_bool, Bool.false_eq_true, ↓reduceIte]
    rw [← ENNReal.ofReal_add ht.1 (sub_nonneg.mpr ht.2)]
    rw [show t + (1 - t) = 1 by linarith, ENNReal.ofReal_one])

variable {t s : ℝ} (ht : 0 ≤ t ∧ t ≤ 1) (hs : 0 ≤ s ∧ s ≤ 1)

private theorem booleanFamily_toReal (b : Bool) :
    (booleanFamily t ht b).toReal = if b then t else 1 - t := by
  cases b <;>
    simp [booleanFamily, PMF.ofFintype_apply, ENNReal.toReal_ofReal,
      ht.1, sub_nonneg.mpr ht.2]

private theorem booleanFamily_weighted_sum (f : Bool → ℝ) :
    (∑ b, (booleanFamily t ht b).toReal * f b) =
      t * f true + (1 - t) * f false := by
  simp [booleanFamily_toReal]

private theorem booleanFamily_distance :
    PMF.totalVariation (booleanFamily t ht) (booleanFamily s hs) = |t - s| := by
  rw [PMF.totalVariation, Fintype.sum_bool]
  simp only [booleanFamily_toReal, Bool.false_eq_true, ↓reduceIte]
  rw [show 1 - t - (1 - s) = -(t - s) by linarith, abs_neg]
  linarith

private theorem booleanFamily_coordinate_events :
    ((booleanFamily t ht).toOuterMeasure {true}).toReal = t ∧
      ((booleanFamily t ht).toOuterMeasure {false}).toReal = 1 - t := by
  constructor <;> rw [PMF.toOuterMeasure_toReal_eq_sum] <;>
    simp [Set.indicator, booleanFamily_toReal]

private def booleanFamilyEvent (t s : ℝ) : Set Bool :=
  {b | if b then s ≤ t else t ≤ s}

private theorem booleanFamily_maximizing_event :
    {b | (booleanFamily s hs b).toReal ≤ (booleanFamily t ht b).toReal} =
      booleanFamilyEvent t s := by
  ext b
  cases b
  · simp only [Set.mem_ofPred_eq, booleanFamily_toReal, booleanFamilyEvent,
      Bool.false_eq_true, ↓reduceIte]
    constructor <;> intro h <;> linarith
  · simp [booleanFamilyEvent, booleanFamily_toReal]

private theorem booleanFamily_attaining_event :
    ((booleanFamily t ht).toOuterMeasure (booleanFamilyEvent t s)).toReal -
      ((booleanFamily s hs).toOuterMeasure (booleanFamilyEvent t s)).toReal = |t - s| := by
  rw [← booleanFamily_maximizing_event ht hs,
    ← PMF.totalVariation_eq_toOuterMeasure_sub, booleanFamily_distance]

private theorem booleanFamily_overlap :
    min t s + min (1 - t) (1 - s) = 1 - |t - s| ∧
    (∑ b, min (booleanFamily t ht b) (booleanFamily s hs b)) =
      ENNReal.ofReal (1 - |t - s|) := by
  constructor
  · have h := PMF.totalVariation_eq_one_sub_sum_min
      (booleanFamily t ht) (booleanFamily s hs)
    rw [booleanFamily_distance, Fintype.sum_bool] at h
    simp only [booleanFamily_toReal, Bool.false_eq_true, ↓reduceIte] at h
    linarith
  · rw [PMF.sum_min_eq_ofReal_one_sub_totalVariation, booleanFamily_distance]

private noncomputable def booleanFamilyUnitTest (t s : ℝ) : Bool → ℝ :=
  (booleanFamilyEvent t s).indicator (fun _ => 1)

private theorem booleanFamily_unit_test :
    (∀ b, 0 ≤ booleanFamilyUnitTest t s b ∧ booleanFamilyUnitTest t s b ≤ 1) ∧
    (∑ b, (booleanFamily t ht b).toReal * booleanFamilyUnitTest t s b) -
      (∑ b, (booleanFamily s hs b).toReal * booleanFamilyUnitTest t s b) = |t - s| ∧
    (∀ f : Bool → ℝ, (∀ b, 0 ≤ f b ∧ f b ≤ 1) →
      |(∑ b, (booleanFamily t ht b).toReal * f b) -
        (∑ b, (booleanFamily s hs b).toReal * f b)| ≤ |t - s|) := by
  classical
  refine ⟨?_, ?_, ?_⟩
  · intro b
    by_cases hb : b ∈ booleanFamilyEvent t s <;> simp [booleanFamilyUnitTest, hb]
  · have hsum (r : PMF Bool) :
        (∑ b, (r b).toReal * booleanFamilyUnitTest t s b) =
          (r.toOuterMeasure (booleanFamilyEvent t s)).toReal := by
      rw [PMF.toOuterMeasure_toReal_eq_sum]
      apply Finset.sum_congr rfl
      intro b _
      by_cases hb : b ∈ booleanFamilyEvent t s <;>
        simp [booleanFamilyUnitTest, Set.indicator, hb]
    rw [hsum, hsum]
    exact booleanFamily_attaining_event ht hs
  · intro f hf
    simpa only [sub_zero, one_mul, booleanFamily_distance] using
      PMF.abs_sum_sub_le_totalVariation_of_mem_Icc
        (booleanFamily t ht) (booleanFamily s hs) f 0 1 (by norm_num) hf

private noncomputable def booleanFamilySignedTest (t s : ℝ) (b : Bool) : ℝ :=
  2 * booleanFamilyUnitTest t s b - 1

private theorem booleanFamily_signed_test :
    (∀ b, |booleanFamilySignedTest t s b| ≤ 1) ∧
    (∑ b, (booleanFamily t ht b).toReal * booleanFamilySignedTest t s b) -
      (∑ b, (booleanFamily s hs b).toReal * booleanFamilySignedTest t s b) = 2 * |t - s| ∧
    (∀ f : Bool → ℝ, (∀ b, |f b| ≤ 1) →
      |(∑ b, (booleanFamily t ht b).toReal * f b) -
        (∑ b, (booleanFamily s hs b).toReal * f b)| ≤ 2 * |t - s|) := by
  refine ⟨?_, ?_, ?_⟩
  · intro b
    have h := (booleanFamily_unit_test ht hs).1 b
    apply abs_le.mpr
    unfold booleanFamilySignedTest
    constructor <;> linarith
  · have hsum (r : PMF Bool) :
        (∑ b, (r b).toReal * booleanFamilySignedTest t s b) =
          2 * (∑ b, (r b).toReal * booleanFamilyUnitTest t s b) - 1 := by
      calc
        _ = ∑ b, (2 * ((r b).toReal * booleanFamilyUnitTest t s b) - (r b).toReal) := by
          apply Finset.sum_congr rfl
          intro b _
          rw [booleanFamilySignedTest, mul_sub, mul_one, mul_left_comm]
        _ = _ := by
          rw [Finset.sum_sub_distrib, ← Finset.mul_sum, r.sum_toReal]
    rw [hsum, hsum]
    have h := (booleanFamily_unit_test ht hs).2.1
    linarith
  · intro f hf
    simpa only [mul_one, booleanFamily_distance] using
      PMF.abs_sum_sub_le_mul_totalVariation
        (booleanFamily t ht) (booleanFamily s hs) f 1 (by norm_num) hf

private theorem booleanFamily_map_contraction {β : Type*} [Fintype β] (f : Bool → β) :
    PMF.totalVariation ((booleanFamily t ht).map f) ((booleanFamily s hs).map f) ≤
      |t - s| := by
  simpa only [booleanFamily_distance] using
    PMF.totalVariation_map_le (booleanFamily t ht) (booleanFamily s hs) f

private theorem booleanFamily_equal :
    PMF.totalVariation (booleanFamily t ht) (booleanFamily t ht) = 0 ∧
    booleanFamilyEvent t t = Set.univ ∧
    (∑ b, min (booleanFamily t ht b) (booleanFamily t ht b)) = 1 := by
  refine ⟨PMF.totalVariation_self _, ?_, ?_⟩
  · ext b
    cases b <;> simp [booleanFamilyEvent]
  · simpa only [sub_self, abs_zero, sub_zero, ENNReal.ofReal_one] using
      (booleanFamily_overlap ht ht).2

private theorem booleanFamily_endpoints :
    booleanFamily 0 (by norm_num) = PMF.pure false ∧
    booleanFamily 1 (by norm_num) = PMF.pure true ∧
    booleanFamily 0 (by norm_num) true = 0 ∧
    booleanFamily 1 (by norm_num) false = 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · apply PMF.ext
    intro b
    cases b <;> norm_num [booleanFamily, PMF.ofFintype_apply, PMF.pure_apply]
  · apply PMF.ext
    intro b
    cases b <;> norm_num [booleanFamily, PMF.ofFintype_apply, PMF.pure_apply]
  · norm_num [booleanFamily, PMF.ofFintype_apply]
  · norm_num [booleanFamily, PMF.ofFintype_apply]

private theorem booleanFamily_endpoint_comparison :
    PMF.totalVariation (booleanFamily 0 (by norm_num))
      (booleanFamily 1 (by norm_num)) = 1 ∧
    Disjoint (booleanFamily 0 (by norm_num)).support
      (booleanFamily 1 (by norm_num)).support ∧
    (∑ b, min (booleanFamily 0 (by norm_num) b)
      (booleanFamily 1 (by norm_num) b)) = 0 := by
  have hdist : PMF.totalVariation (booleanFamily 0 (by norm_num))
      (booleanFamily 1 (by norm_num)) = 1 := by
    rw [booleanFamily_distance]
    norm_num
  refine ⟨hdist, ?_, ?_⟩
  · exact (PMF.totalVariation_eq_one_iff_disjoint_support _ _).mp hdist
  · rw [PMF.sum_min_eq_ofReal_one_sub_totalVariation, hdist]
    norm_num

end ParameterizedBoolean

end LeanInfoTheory.Examples.TotalVariation
