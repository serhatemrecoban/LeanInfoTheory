/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.TypicalSet
import Mathlib.Tactic.FinCases

/-!
# Finite weak-typicality consumers

These private consumers use the finite typical-set owner. They check the
positive-length guard, nonpositive widths, deterministic and singleton sources,
and a sparse source whose impossible word passes the numerical band when the
width exceeds entropy but is excluded by support.

For the binary source with masses `1/3` and `2/3`, the strict band at length one
is empty at width `log 2 / 3`. At width `2 * log 2 / 3` it contains exactly the
common word and has probability `2/3`. Both excluded boundaries are checked
against the actual iid word law. Cardinality consumers check the empty,
deterministic and binary boundary cases, including failure of the lower bound
if its probability factor is omitted. No AEP theorem is imported.
-/

namespace LeanInfoTheory.Examples.TypicalSet

noncomputable section

universe u

open scoped BigOperators ENNReal
open LeanInfoTheory.Shannon

/-! ## Length and width boundaries -/

private theorem zero_length_empty {A : Type u} [Fintype A]
    (p : PMF A) (ε : ℝ) : weakTypicalSet p 0 ε = ∅ := by
  ext x
  simp [mem_weakTypicalSet]

private theorem nonpositive_width_empty {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) {ε : ℝ} (hε : ε ≤ 0) :
    weakTypicalSet p n ε = ∅ := by
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro x hx
  have ht := ((mem_weakTypicalSet p).1 hx).2.2
  exact (not_lt_of_ge (le_trans hε (abs_nonneg _))) ht

private theorem zero_width_empty {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) : weakTypicalSet p n 0 = ∅ :=
  nonpositive_width_empty p n le_rfl

private theorem zero_length_probability {A : Type u} [Fintype A]
    (p : PMF A) (ε : ℝ) :
    ((PMF.iid p 0).toOuterMeasure (weakTypicalSet p 0 ε)).toReal = 0 := by
  rw [zero_length_empty]
  simp

private theorem nonpositive_width_probability {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) {ε : ℝ} (hε : ε ≤ 0) :
    ((PMF.iid p n).toOuterMeasure (weakTypicalSet p n ε)).toReal = 0 := by
  rw [nonpositive_width_empty p n hε]
  simp

private theorem zero_length_word_mass {A : Type u} [Fintype A]
    (p : PMF A) (x : Fin 0 → A) : PMF.iid p 0 x = 1 := by
  simp [PMF.iid, PMF.finiteProduct_apply]

private theorem iid_one_mass {A : Type u} [Fintype A]
    (p : PMF A) (x : Fin 1 → A) : PMF.iid p 1 x = p (x 0) := by
  simp only [PMF.iid, PMF.finiteProduct_apply, Fin.prod_univ_one]

private theorem iid_one_selfInfo {A : Type u} [Fintype A]
    (p : PMF A) (x : Fin 1 → A) :
    selfInfo (PMF.iid p 1) x = selfInfo p (x 0) := by
  simp only [selfInfo, iid_one_mass]

private theorem iid_one_typical_mem {A : Type u} [Fintype A]
    (p : PMF A) (x : Fin 1 → A) (ε : ℝ) :
    x ∈ weakTypicalSet p 1 ε ↔
      x 0 ∈ p.support ∧ |selfInfo p (x 0) - entropy p| < ε := by
  have hs : x ∈ (PMF.iid p 1).support ↔ x 0 ∈ p.support := by
    rw [PMF.mem_support_iff, PMF.mem_support_iff, iid_one_mass]
  rw [mem_weakTypicalSet]
  simp only [Nat.zero_lt_succ, true_and, hs, iid_one_selfInfo, Nat.cast_one, div_one]

/-! ## Deterministic, singleton and empty-alphabet sources -/

private theorem pure_selfInfo {A : Type u} (a b : A) :
    selfInfo (PMF.pure a) b = 0 := by
  classical
  by_cases h : b = a
  · subst b
    simp [selfInfo, PMF.pure_apply]
  · simp [selfInfo, PMF.pure_apply, h]

private theorem pure_typical_set {A : Type u} [Fintype A]
    (a : A) {n : ℕ} (hn : 0 < n) {ε : ℝ} (hε : 0 < ε) :
    weakTypicalSet (PMF.pure a) n ε = {fun _ : Fin n => a} := by
  classical
  have hq : PMF.iid (PMF.pure a) n = PMF.pure (fun _ : Fin n => a) :=
    PMF.finiteProduct_pure (fun _ : Fin n => a)
  ext x
  simp [mem_weakTypicalSet, hq, hn, pure_selfInfo, hε]

private theorem pure_typical_probability {A : Type u} [Fintype A]
    (a : A) {n : ℕ} (hn : 0 < n) {ε : ℝ} (hε : 0 < ε) :
    ((PMF.iid (PMF.pure a) n).toOuterMeasure
      (weakTypicalSet (PMF.pure a) n ε)).toReal = 1 := by
  classical
  rw [pure_typical_set a hn hε]
  have hq : PMF.iid (PMF.pure a) n = PMF.pure (fun _ : Fin n => a) :=
    PMF.finiteProduct_pure (fun _ : Fin n => a)
  rw [hq, PMF.toOuterMeasure_pure_apply]
  simp

private theorem pure_impossible_excluded {A : Type u} [Fintype A]
    (a : A) {n : ℕ} {ε : ℝ} {x : Fin n → A}
    (hx : x ≠ fun _ : Fin n => a) :
    x ∉ weakTypicalSet (PMF.pure a) n ε := by
  intro ht
  have hs := ((mem_weakTypicalSet (PMF.pure a)).1 ht).2.1
  have hq : PMF.iid (PMF.pure a) n = PMF.pure (fun _ : Fin n => a) :=
    PMF.finiteProduct_pure (fun _ : Fin n => a)
  rw [hq, PMF.mem_support_pure_iff] at hs
  exact hx hs

private theorem pure_ambient_impossible {ε : ℝ} (hε : 0 < ε) :
    |selfInfo (PMF.iid (PMF.pure false) 2) (![false, true] : Fin 2 → Bool) /
        (2 : ℝ) - entropy (PMF.pure false)| < ε ∧
      (![false, true] : Fin 2 → Bool) ∉ weakTypicalSet (PMF.pure false) 2 ε := by
  constructor
  · have hq : PMF.iid (PMF.pure false) 2 =
        PMF.pure (fun _ : Fin 2 => false) :=
      PMF.finiteProduct_pure (fun _ : Fin 2 => false)
    simpa only [hq, pure_selfInfo, entropy_pure, zero_div, sub_zero, abs_zero] using hε
  · apply pure_impossible_excluded false
    intro h
    have hi := congrFun h 1
    norm_num at hi

private theorem singleton_alphabet_typical {n : ℕ} (hn : 0 < n)
    {ε : ℝ} (hε : 0 < ε) :
    weakTypicalSet (PMF.pure ()) n ε = {fun _ : Fin n => ()} ∧
      ((PMF.iid (PMF.pure ()) n).toOuterMeasure
        (weakTypicalSet (PMF.pure ()) n ε)).toReal = 1 :=
  ⟨pure_typical_set () hn hε, pure_typical_probability () hn hε⟩

private theorem no_empty_base_law : ¬ Nonempty (PMF Empty) := by
  rintro ⟨p⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

/-! ## A sparse source and widths larger than entropy -/

private theorem log_two_pos : 0 < Real.log 2 :=
  Real.log_pos (by norm_num)

private theorem half_masses_add :
    ENNReal.ofReal (1 / 2 : ℝ) + ENNReal.ofReal (1 / 2 : ℝ) = 1 := by
  rw [← ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1 / 2)
    (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  norm_num

private def sparse : PMF (Fin 3) :=
  PMF.ofFintype
    (fun a => if a = 2 then 0 else ENNReal.ofReal (1 / 2 : ℝ))
    (by simpa [Fin.sum_univ_three] using half_masses_add)

private theorem sparse_mass (a : Fin 3) (ha : a ≠ 2) :
    (sparse a).toReal = 1 / 2 := by
  norm_num [sparse, PMF.ofFintype_apply, ha]

private theorem sparse_selfInfo (a : Fin 3) (ha : a ≠ 2) :
    selfInfo sparse a = Real.log 2 := by
  have hm : (sparse a).toReal ≠ 0 := by rw [sparse_mass a ha]; norm_num
  rw [selfInfo_of_toReal_ne_zero sparse hm, sparse_mass a ha,
    one_div, Real.log_inv, neg_neg]

private theorem sparse_entropy : entropy sparse = Real.log 2 := by
  rw [entropy_eq_sum, Fin.sum_univ_three,
    ← toReal_mul_selfInfo sparse 0, ← toReal_mul_selfInfo sparse 1,
    ← toReal_mul_selfInfo sparse 2, sparse_mass 0 (by decide),
    sparse_mass 1 (by decide), sparse_selfInfo 0 (by decide),
    sparse_selfInfo 1 (by decide)]
  have hz : (sparse 2).toReal = 0 := by norm_num [sparse, PMF.ofFintype_apply]
  rw [hz, zero_mul]
  ring

private theorem sparse_supported_mass :
    (PMF.iid sparse 2 (![0, 1] : Fin 2 → Fin 3)).toReal = 1 / 4 := by
  change (PMF.finiteProduct (fun _ : Fin 2 => sparse)
    (![0, 1] : Fin 2 → Fin 3)).toReal = _
  rw [PMF.finiteProduct_apply, Fin.prod_univ_two, ENNReal.toReal_mul]
  change (sparse 0).toReal * (sparse 1).toReal = _
  rw [sparse_mass 0 (by decide), sparse_mass 1 (by decide)]
  norm_num

private theorem sparse_supported_selfInfo :
    selfInfo (PMF.iid sparse 2) (![0, 1] : Fin 2 → Fin 3) = 2 * Real.log 2 := by
  have hm : (PMF.iid sparse 2 (![0, 1] : Fin 2 → Fin 3)).toReal ≠ 0 := by
    rw [sparse_supported_mass]
    norm_num
  rw [selfInfo_of_toReal_ne_zero _ hm, sparse_supported_mass,
    show (1 / 4 : ℝ) = (1 / 2) * (1 / 2) by norm_num,
    Real.log_mul (by norm_num : (1 / 2 : ℝ) ≠ 0) (by norm_num : (1 / 2 : ℝ) ≠ 0)]
  simp only [one_div, Real.log_inv]
  ring

private theorem sparse_supported_typical :
    (![0, 1] : Fin 2 → Fin 3) ∈ weakTypicalSet sparse 2 (2 * Real.log 2) := by
  apply (mem_weakTypicalSet sparse).2
  refine ⟨by decide, ?_, ?_⟩
  · apply (PMF.mem_support_iff _ _).2
    intro hz
    have hm := sparse_supported_mass
    rw [hz, ENNReal.toReal_zero] at hm
    norm_num at hm
  · rw [sparse_supported_selfInfo, sparse_entropy]
    have hz : (2 * Real.log 2) / (2 : ℝ) - Real.log 2 = 0 := by ring
    simpa only [Nat.cast_ofNat, hz, abs_zero] using
      mul_pos (by norm_num : (0 : ℝ) < 2) log_two_pos

private theorem sparse_typical_mass_bounds :
    Real.exp (-(2 : ℝ) * (Real.log 2 + 2 * Real.log 2)) ≤ (1 / 4 : ℝ) ∧
      (1 / 4 : ℝ) ≤ Real.exp (-(2 : ℝ) * (Real.log 2 - 2 * Real.log 2)) := by
  simpa only [sparse_entropy, sparse_supported_mass, Nat.cast_ofNat] using
    weakTypicalSet_mass_bounds sparse sparse_supported_typical

private theorem sparse_impossible_mass :
    PMF.iid sparse 2 (![0, 2] : Fin 2 → Fin 3) = 0 := by
  norm_num [PMF.iid, PMF.finiteProduct_apply, Fin.prod_univ_two,
    sparse, PMF.ofFintype_apply]

private theorem sparse_impossible_selfInfo :
    selfInfo (PMF.iid sparse 2) (![0, 2] : Fin 2 → Fin 3) = 0 := by
  apply selfInfo_of_toReal_eq_zero
  rw [sparse_impossible_mass]
  rfl

private theorem sparse_impossible_excluded (ε : ℝ) :
    (![0, 2] : Fin 2 → Fin 3) ∉ weakTypicalSet sparse 2 ε := by
  intro ht
  have hs := ((mem_weakTypicalSet sparse).1 ht).2.1
  rw [PMF.mem_support_iff, sparse_impossible_mass] at hs
  exact hs rfl

private theorem sparse_impossible_passes_raw_band :
    entropy sparse < 2 * Real.log 2 ∧
      |selfInfo (PMF.iid sparse 2) (![0, 2] : Fin 2 → Fin 3) / (2 : ℝ) -
        entropy sparse| < 2 * Real.log 2 ∧
      (![0, 2] : Fin 2 → Fin 3) ∉ weakTypicalSet sparse 2 (2 * Real.log 2) := by
  refine ⟨?_, ?_, sparse_impossible_excluded _⟩
  · rw [sparse_entropy]
    linarith [log_two_pos]
  · rw [sparse_impossible_selfInfo, sparse_entropy]
    simp only [zero_div, zero_sub, abs_neg, abs_of_pos log_two_pos]
    linarith [log_two_pos]

/-! ## The two nonuniform strict boundaries at length one -/

private theorem third_masses_add :
    ENNReal.ofReal (1 / 3 : ℝ) + ENNReal.ofReal (2 / 3 : ℝ) = 1 := by
  rw [← ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1 / 3)
    (by norm_num : (0 : ℝ) ≤ 2 / 3)]
  norm_num

private def nonuniform : PMF (Fin 2) :=
  PMF.ofFintype
    (fun a => ENNReal.ofReal (if a = 0 then (1 / 3 : ℝ) else 2 / 3))
    (by simpa [Fin.sum_univ_two] using third_masses_add)

private theorem nonuniform_zero_mass : (nonuniform 0).toReal = 1 / 3 := by
  norm_num [nonuniform, PMF.ofFintype_apply]

private theorem nonuniform_one_mass : (nonuniform 1).toReal = 2 / 3 := by
  norm_num [nonuniform, PMF.ofFintype_apply]

private theorem nonuniform_support (a : Fin 2) : a ∈ nonuniform.support := by
  by_cases ha : a = 0 <;>
    norm_num [PMF.mem_support_iff, nonuniform, PMF.ofFintype_apply, ha]

private theorem nonuniform_selfInfo_zero : selfInfo nonuniform 0 = Real.log 3 := by
  have hm : (nonuniform 0).toReal ≠ 0 := by rw [nonuniform_zero_mass]; norm_num
  rw [selfInfo_of_toReal_ne_zero nonuniform hm, nonuniform_zero_mass,
    one_div, Real.log_inv, neg_neg]

private theorem nonuniform_selfInfo_one :
    selfInfo nonuniform 1 = Real.log 3 - Real.log 2 := by
  have hm : (nonuniform 1).toReal ≠ 0 := by rw [nonuniform_one_mass]; norm_num
  rw [selfInfo_of_toReal_ne_zero nonuniform hm, nonuniform_one_mass,
    Real.log_div (by norm_num : (2 : ℝ) ≠ 0) (by norm_num : (3 : ℝ) ≠ 0)]
  ring

private theorem nonuniform_entropy :
    entropy nonuniform = Real.log 3 - (2 / 3 : ℝ) * Real.log 2 := by
  rw [entropy_eq_sum, Fin.sum_univ_two,
    ← toReal_mul_selfInfo nonuniform 0, ← toReal_mul_selfInfo nonuniform 1,
    nonuniform_zero_mass, nonuniform_one_mass,
    nonuniform_selfInfo_zero, nonuniform_selfInfo_one]
  ring

private theorem nonuniform_abs_centered_zero :
    |selfInfo nonuniform 0 - entropy nonuniform| = (2 / 3 : ℝ) * Real.log 2 := by
  rw [nonuniform_selfInfo_zero, nonuniform_entropy]
  rw [show Real.log 3 - (Real.log 3 - (2 / 3 : ℝ) * Real.log 2) =
    (2 / 3 : ℝ) * Real.log 2 by ring]
  exact abs_of_pos (mul_pos (by norm_num) log_two_pos)

private theorem nonuniform_abs_centered_one :
    |selfInfo nonuniform 1 - entropy nonuniform| = (1 / 3 : ℝ) * Real.log 2 := by
  rw [nonuniform_selfInfo_one, nonuniform_entropy]
  rw [show Real.log 3 - Real.log 2 - (Real.log 3 - (2 / 3 : ℝ) * Real.log 2) =
    -((1 / 3 : ℝ) * Real.log 2) by ring, abs_neg]
  exact abs_of_pos (mul_pos (by norm_num) log_two_pos)

private theorem nonuniform_small_band_excluded (a : Fin 2) :
    ¬ |selfInfo nonuniform a - entropy nonuniform| < Real.log 2 / 3 := by
  fin_cases a
  · change ¬ |selfInfo nonuniform (0 : Fin 2) - entropy nonuniform| < Real.log 2 / 3
    rw [nonuniform_abs_centered_zero]
    linarith [log_two_pos]
  · change ¬ |selfInfo nonuniform (1 : Fin 2) - entropy nonuniform| < Real.log 2 / 3
    rw [nonuniform_abs_centered_one]
    linarith

private theorem nonuniform_small_set_empty :
    weakTypicalSet nonuniform 1 (Real.log 2 / 3) = ∅ := by
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro x hx
  exact nonuniform_small_band_excluded (x 0)
    ((iid_one_typical_mem nonuniform x _).1 hx).2

private theorem nonuniform_small_probability :
    ((PMF.iid nonuniform 1).toOuterMeasure
      (weakTypicalSet nonuniform 1 (Real.log 2 / 3))).toReal = 0 := by
  rw [nonuniform_small_set_empty]
  simp

private theorem nonuniform_positive_width_empty_regression :
    0 < Real.log 2 / 3 ∧
      weakTypicalSet nonuniform 1 (Real.log 2 / 3) = ∅ ∧
      ((PMF.iid nonuniform 1).toOuterMeasure
        (weakTypicalSet nonuniform 1 (Real.log 2 / 3))).toReal = 0 :=
  ⟨div_pos log_two_pos (by norm_num),
    nonuniform_small_set_empty, nonuniform_small_probability⟩

private theorem nonuniform_middle_band (a : Fin 2) :
    |selfInfo nonuniform a - entropy nonuniform| < 2 * Real.log 2 / 3 ↔ a = 1 := by
  fin_cases a
  · change |selfInfo nonuniform (0 : Fin 2) - entropy nonuniform| <
      2 * Real.log 2 / 3 ↔ (0 : Fin 2) = 1
    rw [nonuniform_abs_centered_zero]
    constructor
    · intro h
      exfalso
      linarith
    · intro h
      norm_num at h
  · change |selfInfo nonuniform (1 : Fin 2) - entropy nonuniform| <
      2 * Real.log 2 / 3 ↔ (1 : Fin 2) = 1
    rw [nonuniform_abs_centered_one]
    constructor
    · intro _
      rfl
    · intro _
      linarith [log_two_pos]

private theorem nonuniform_middle_set :
    weakTypicalSet nonuniform 1 (2 * Real.log 2 / 3) = {fun _ : Fin 1 => (1 : Fin 2)} := by
  classical
  ext x
  rw [iid_one_typical_mem, nonuniform_middle_band, Finset.mem_singleton]
  simp only [nonuniform_support, true_and]
  constructor
  · intro hx
    funext i
    rw [Fin.eq_zero i]
    exact hx
  · intro hx
    exact congrFun hx 0

private theorem nonuniform_middle_probability :
    ((PMF.iid nonuniform 1).toOuterMeasure
      (weakTypicalSet nonuniform 1 (2 * Real.log 2 / 3))).toReal = 2 / 3 := by
  rw [nonuniform_middle_set, PMF.toOuterMeasure_apply_finset]
  simp only [Finset.sum_singleton, iid_one_mass]
  exact nonuniform_one_mass

private theorem nonuniform_common_on_small_boundary :
    |selfInfo (PMF.iid nonuniform 1) (fun _ : Fin 1 => (1 : Fin 2)) / (1 : ℝ) -
      entropy nonuniform| = Real.log 2 / 3 := by
  rw [div_one, iid_one_selfInfo, nonuniform_abs_centered_one]
  ring

private theorem nonuniform_rare_on_middle_boundary :
    |selfInfo (PMF.iid nonuniform 1) (fun _ : Fin 1 => (0 : Fin 2)) / (1 : ℝ) -
      entropy nonuniform| = 2 * Real.log 2 / 3 := by
  rw [div_one, iid_one_selfInfo, nonuniform_abs_centered_zero]
  ring

/-! ## Finite cardinality bounds at boundary and nonempty sets -/

private theorem zero_length_cardinality {A : Type u} [Fintype A]
    (p : PMF A) (ε : ℝ) :
    ((weakTypicalSet p 0 ε).card : ℝ) ≤ 1 ∧
      ((PMF.iid p 0).toOuterMeasure (weakTypicalSet p 0 ε)).toReal ≤
        ((weakTypicalSet p 0 ε).card : ℝ) := by
  simpa only [Nat.cast_zero, zero_mul, Real.exp_zero, mul_one] using
    And.intro (card_weakTypicalSet_le p 0 ε)
      (prob_mul_exp_le_card_weakTypicalSet p 0 ε)

private theorem nonpositive_width_cardinality {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) {ε : ℝ} (hε : ε ≤ 0) :
    (0 : ℝ) ≤ Real.exp ((n : ℝ) * (entropy p + ε)) ∧
      ((PMF.iid p n).toOuterMeasure (weakTypicalSet p n ε)).toReal *
        Real.exp ((n : ℝ) * (entropy p - ε)) ≤ 0 := by
  simpa only [nonpositive_width_empty p n hε, Finset.card_empty, Nat.cast_zero] using
    And.intro (card_weakTypicalSet_le p n ε)
      (prob_mul_exp_le_card_weakTypicalSet p n ε)

private theorem pure_cardinality_bounds {A : Type u} [Finite A]
    (a : A) {n : ℕ} (hn : 0 < n) {ε : ℝ} (hε : 0 < ε) :
    Real.exp (-(n : ℝ) * ε) ≤ 1 ∧
      1 ≤ Real.exp ((n : ℝ) * ε) := by
  let := Fintype.ofFinite A
  have bounds :=
    And.intro (prob_mul_exp_le_card_weakTypicalSet (PMF.pure a) n ε)
      (card_weakTypicalSet_le (PMF.pure a) n ε)
  rw [pure_typical_probability a hn hε, pure_typical_set a hn hε] at bounds
  simpa only [Finset.card_singleton, Nat.cast_one, entropy_pure, zero_sub, zero_add,
    mul_neg, neg_mul, one_mul] using bounds

private theorem nonuniform_empty_requires_probability_factor :
    (0 : ℝ) * Real.exp (entropy nonuniform - Real.log 2 / 3) ≤ 0 ∧
      ¬ Real.exp (entropy nonuniform - Real.log 2 / 3) ≤ 0 := by
  constructor
  · have bound := prob_mul_exp_le_card_weakTypicalSet nonuniform 1 (Real.log 2 / 3)
    rw [nonuniform_small_probability, nonuniform_small_set_empty] at bound
    simpa only [Finset.card_empty, Nat.cast_zero, Nat.cast_one, one_mul] using bound
  · exact not_le.mpr (Real.exp_pos _)

private theorem nonuniform_middle_cardinality :
    (2 / 3 : ℝ) * Real.exp (entropy nonuniform - 2 * Real.log 2 / 3) ≤ 1 ∧
      1 ≤ Real.exp (entropy nonuniform + 2 * Real.log 2 / 3) := by
  have bounds :=
    And.intro (prob_mul_exp_le_card_weakTypicalSet nonuniform 1 (2 * Real.log 2 / 3))
      (card_weakTypicalSet_le nonuniform 1 (2 * Real.log 2 / 3))
  rw [nonuniform_middle_probability, nonuniform_middle_set] at bounds
  simpa only [Finset.card_singleton, Nat.cast_one, one_mul] using bounds

end

end LeanInfoTheory.Examples.TypicalSet
