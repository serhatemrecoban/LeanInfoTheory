/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.AEP

/-!
# Finite-iid self-information and AEP consumers

These private consumers use the focused AEP owner. A sparse ternary law gives
an actual counterexample to unrestricted block self-information additivity:
the impossible word `(0,2)` has block self-information zero but coordinate sum
`log 2 > 0`. The supported word `(0,1)` uses the public supported identity.

Zero and one lengths, deterministic sources with impossible ambient words,
singleton alphabets, and the impossibility of an empty-alphabet base PMF are
separate boundary cases. The public deviation-probability limit is consumed by
the sparse source and a nonuniform binary source with masses `1/3` and `2/3`.
For deterministic sources the deviation probability is exactly zero at every
length and every positive threshold. Further consumers use the public
typical-probability limit for nonuniform and sparse sources and derive complement
convergence for every finite source through supported PMF interfaces.
The cardinality consumers keep the typicality width and probability tolerance
independent, and assemble the common typical-set inputs with an explicit natural
message-budget conversion. They do not choose a budget or introduce coding data.
All information quantities use nats.
-/

namespace LeanInfoTheory.Examples.AEP

noncomputable section

universe u

open scoped BigOperators ENNReal
open LeanInfoTheory.Shannon

/-! ## A sparse source and the support boundary -/

private theorem half_mass_add :
    ENNReal.ofReal (1 / 2 : ℝ) + ENNReal.ofReal (1 / 2 : ℝ) = 1 := by
  rw [← ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1 / 2)
    (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  norm_num

private def sparse : PMF (Fin 3) :=
  PMF.ofFintype
    (fun a => if a = 2 then 0 else ENNReal.ofReal (1 / 2 : ℝ))
    (by simpa [Fin.sum_univ_three] using half_mass_add)

private theorem sparse_toReal (a : Fin 3) (ha : a ≠ 2) :
    (sparse a).toReal = 1 / 2 := by
  norm_num [sparse, PMF.ofFintype_apply, ha]

private theorem sparse_selfInfo (a : Fin 3) (ha : a ≠ 2) :
    selfInfo sparse a = Real.log 2 := by
  have hmass : (sparse a).toReal ≠ 0 := by
    rw [sparse_toReal a ha]
    norm_num
  rw [selfInfo_of_toReal_ne_zero sparse hmass, sparse_toReal a ha,
    one_div, Real.log_inv, neg_neg]

private theorem sparse_missing_selfInfo : selfInfo sparse 2 = 0 := by
  apply selfInfo_of_toReal_eq_zero
  norm_num [sparse, PMF.ofFintype_apply]

private theorem sparse_support (n : ℕ) (x : Fin n → Fin 3) :
    x ∈ (PMF.iid sparse n).support ↔ ∀ i, x i ≠ 2 := by
  change x ∈ (PMF.finiteProduct (fun _ : Fin n => sparse)).support ↔ _
  rw [PMF.mem_support_finiteProduct_iff]
  constructor
  · intro h i hi
    have hz := h i
    rw [hi] at hz
    change sparse 2 ≠ 0 at hz
    norm_num [sparse, PMF.ofFintype_apply] at hz
  · intro h i
    change sparse (x i) ≠ 0
    simp [sparse, PMF.ofFintype_apply, h i]

private theorem sparse_impossible_mass :
    PMF.iid sparse 2 (![0, 2] : Fin 2 → Fin 3) = 0 := by
  change PMF.finiteProduct (fun _ : Fin 2 => sparse) (![0, 2] : Fin 2 → Fin 3) = 0
  rw [PMF.finiteProduct_apply, Fin.prod_univ_two]
  norm_num [sparse, PMF.ofFintype_apply]

private theorem sparse_impossible_not_supported :
    (![0, 2] : Fin 2 → Fin 3) ∉ (PMF.iid sparse 2).support := by
  rw [PMF.mem_support_iff, sparse_impossible_mass]
  simp

private theorem sparse_impossible_selfInfo :
    selfInfo (PMF.iid sparse 2) (![0, 2] : Fin 2 → Fin 3) = 0 := by
  apply selfInfo_of_toReal_eq_zero
  rw [sparse_impossible_mass]
  rfl

private theorem sparse_impossible_coordinate_sum :
    (∑ i : Fin 2, selfInfo sparse ((![0, 2] : Fin 2 → Fin 3) i)) =
      Real.log 2 := by
  simp only [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one,
    sparse_selfInfo 0 (by decide), sparse_missing_selfInfo, add_zero]

private theorem sparse_impossible_coordinate_sum_pos :
    0 < ∑ i : Fin 2, selfInfo sparse ((![0, 2] : Fin 2 → Fin 3) i) := by
  rw [sparse_impossible_coordinate_sum]
  exact Real.log_pos (by norm_num)

private theorem sparse_impossible_not_additive :
    selfInfo (PMF.iid sparse 2) (![0, 2] : Fin 2 → Fin 3) ≠
      ∑ i : Fin 2, selfInfo sparse ((![0, 2] : Fin 2 → Fin 3) i) := by
  rw [sparse_impossible_selfInfo]
  exact ne_of_lt sparse_impossible_coordinate_sum_pos

private theorem sparse_supported_word :
    (![0, 1] : Fin 2 → Fin 3) ∈ (PMF.iid sparse 2).support :=
  (sparse_support 2 _).2 (by decide)

private theorem sparse_supported_additivity :
    selfInfo (PMF.iid sparse 2) (![0, 1] : Fin 2 → Fin 3) =
      ∑ i : Fin 2, selfInfo sparse ((![0, 1] : Fin 2 → Fin 3) i) :=
  selfInfo_iid_of_mem_support sparse 2 sparse_supported_word

private theorem sparse_supported_selfInfo :
    selfInfo (PMF.iid sparse 2) (![0, 1] : Fin 2 → Fin 3) =
      2 * Real.log 2 := by
  rw [sparse_supported_additivity, Fin.sum_univ_two]
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one,
    sparse_selfInfo 0 (by decide), sparse_selfInfo 1 (by decide)]
  exact (two_mul (Real.log 2)).symm

/-! ## Zero and one blocklengths -/

private theorem iid_zero_selfInfo {A : Type u} [Fintype A]
    (p : PMF A) (x : Fin 0 → A) :
    selfInfo (PMF.iid p 0) x = 0 := by
  have hx : x ∈ (PMF.iid p 0).support := by
    apply (PMF.mem_support_finiteProduct_iff (fun _ : Fin 0 => p) x).2
    intro i
    exact Fin.elim0 i
  simpa using selfInfo_iid_of_mem_support p 0 hx

private theorem iid_one_selfInfo {A : Type u} [Fintype A]
    (p : PMF A) {a : A} (ha : a ∈ p.support) :
    selfInfo (PMF.iid p 1) (fun _ : Fin 1 => a) = selfInfo p a := by
  have hx : (fun _ : Fin 1 => a) ∈ (PMF.iid p 1).support :=
    (PMF.mem_support_finiteProduct_iff (fun _ : Fin 1 => p) _).2 (fun _ => ha)
  simpa only [Fin.sum_univ_one] using selfInfo_iid_of_mem_support p 1 hx

/-! ## Deterministic, singleton and empty-alphabet boundaries -/

private theorem pure_selfInfo {A : Type u} (a b : A) :
    selfInfo (PMF.pure a) b = 0 := by
  classical
  by_cases h : b = a
  · subst b
    simp [selfInfo, PMF.pure_apply]
  · simp [selfInfo, PMF.pure_apply, h]

private theorem iid_pure_supported {A : Type u} [Fintype A]
    (a : A) (n : ℕ) :
    (fun _ : Fin n => a) ∈ (PMF.iid (PMF.pure a) n).support := by
  apply (PMF.mem_support_finiteProduct_iff (fun _ : Fin n => PMF.pure a) _).2
  intro i
  simp

private theorem iid_pure_selfInfo {A : Type u} [Fintype A]
    (a : A) (n : ℕ) :
    selfInfo (PMF.iid (PMF.pure a) n) (fun _ : Fin n => a) = 0 := by
  rw [selfInfo_iid_of_mem_support (PMF.pure a) n (iid_pure_supported a n)]
  simp only [pure_selfInfo, Finset.sum_const_zero]

private theorem pure_impossible_mass :
    PMF.iid (PMF.pure false) 2 (![false, true] : Fin 2 → Bool) = 0 := by
  change PMF.finiteProduct (fun _ : Fin 2 => PMF.pure false)
    (![false, true] : Fin 2 → Bool) = 0
  rw [PMF.finiteProduct_apply, Fin.prod_univ_two]
  norm_num [PMF.pure_apply]

private theorem pure_impossible_not_supported :
    (![false, true] : Fin 2 → Bool) ∉ (PMF.iid (PMF.pure false) 2).support := by
  rw [PMF.mem_support_iff, pure_impossible_mass]
  simp

private theorem pure_impossible_selfInfo :
    selfInfo (PMF.iid (PMF.pure false) 2) (![false, true] : Fin 2 → Bool) = 0 := by
  apply selfInfo_of_toReal_eq_zero
  rw [pure_impossible_mass]
  rfl

private theorem singleton_alphabet_selfInfo (n : ℕ) (x : Fin n → Unit) :
    selfInfo (PMF.iid (PMF.pure ()) n) x = 0 := by
  rw [Subsingleton.elim x (fun _ : Fin n => ())]
  exact iid_pure_selfInfo () n

private theorem no_empty_base_law : ¬ Nonempty (PMF Empty) := by
  rintro ⟨p⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

/-! ## Public AEP for nonuniform and sparse sources -/

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

private theorem nonuniform_deviation_tendsto {ε : ℝ} (hε : 0 < ε) :
    Filter.Tendsto
      (fun n : ℕ => ((PMF.iid nonuniform n).toOuterMeasure
        {x | ε ≤ |selfInfo (PMF.iid nonuniform n) x / (n : ℝ) -
          entropy nonuniform|}).toReal)
      Filter.atTop (nhds 0) :=
  tendsto_selfInfo_iid_deviation nonuniform hε

private theorem sparse_deviation_tendsto {ε : ℝ} (hε : 0 < ε) :
    Filter.Tendsto
      (fun n : ℕ => ((PMF.iid sparse n).toOuterMeasure
        {x | ε ≤ |selfInfo (PMF.iid sparse n) x / (n : ℝ) - entropy sparse|}).toReal)
      Filter.atTop (nhds 0) :=
  tendsto_selfInfo_iid_deviation sparse hε

private theorem pure_deviation_probability {A : Type u} [Fintype A]
    (a : A) (n : ℕ) {ε : ℝ} (hε : 0 < ε) :
    ((PMF.iid (PMF.pure a) n).toOuterMeasure
      {x | ε ≤ |selfInfo (PMF.iid (PMF.pure a) n) x / (n : ℝ) -
        entropy (PMF.pure a)|}).toReal = 0 := by
  have hq : PMF.iid (PMF.pure a) n = PMF.pure (fun _ : Fin n => a) :=
    PMF.finiteProduct_pure (fun _ : Fin n => a)
  simp only [hq, pure_selfInfo, entropy_pure, zero_div, sub_zero, abs_zero]
  simp [not_le.mpr hε]

/-! ## Typical probability and its complement through supported interfaces -/

private theorem nonuniform_typical_probability {ε : ℝ} (hε : 0 < ε) :
    Filter.Tendsto
      (fun n : ℕ =>
        ((PMF.iid nonuniform n).toOuterMeasure (weakTypicalSet nonuniform n ε)).toReal)
      Filter.atTop (nhds 1) :=
  tendsto_prob_weakTypicalSet nonuniform hε

private theorem sparse_typical_probability {ε : ℝ} (hε : 0 < ε) :
    Filter.Tendsto
      (fun n : ℕ =>
        ((PMF.iid sparse n).toOuterMeasure (weakTypicalSet sparse n ε)).toReal)
      Filter.atTop (nhds 1) :=
  tendsto_prob_weakTypicalSet sparse hε

private theorem typical_complement_probability {A : Type u} [Fintype A]
    (p : PMF A) {ε : ℝ} (hε : 0 < ε) :
    Filter.Tendsto
      (fun n : ℕ => ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal)
      Filter.atTop (nhds 0) := by
  have hlimit := Filter.Tendsto.sub (tendsto_const_nhds (x := (1 : ℝ)))
    (tendsto_prob_weakTypicalSet p hε)
  have heq :
      (fun n : ℕ =>
        1 - ((PMF.iid p n).toOuterMeasure (weakTypicalSet p n ε)).toReal)
        =ᶠ[Filter.atTop]
      (fun n : ℕ => ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal) := by
    apply Filter.Eventually.of_forall
    intro n
    let : MeasurableSpace (Fin n → A) := ⊤
    have hsum := MeasureTheory.probReal_add_probReal_compl
      (μ := (PMF.iid p n).toMeasure)
      (s := (↑(weakTypicalSet p n ε) : Set (Fin n → A))) MeasurableSet.of_discrete
    simp only [MeasureTheory.Measure.real, PMF.toMeasure_apply_eq_toOuterMeasure] at hsum
    linarith
  simpa only [sub_self] using Filter.Tendsto.congr' heq hlimit

/-! ## Cardinality inputs through the same supported typical-set family -/

private theorem eventually_card_weakTypicalSet_lower {A : Type u} [Fintype A]
    (p : PMF A) {ε δ : ℝ} (hε : 0 < ε) (hδ : 0 < δ) :
    ∀ᶠ n : ℕ in Filter.atTop,
      (1 - δ) * Real.exp ((n : ℝ) * (entropy p - ε)) ≤
        ((weakTypicalSet p n ε).card : ℝ) := by
  have hp :
      ∀ᶠ n : ℕ in Filter.atTop,
        1 - δ ≤ ((PMF.iid p n).toOuterMeasure (weakTypicalSet p n ε)).toReal :=
    Filter.Tendsto.eventually_const_le (by linarith : 1 - δ < 1)
      (tendsto_prob_weakTypicalSet p hε)
  exact hp.mono fun n hn =>
    (mul_le_mul_of_nonneg_right hn (Real.exp_pos _).le).trans
      (prob_mul_exp_le_card_weakTypicalSet p n ε)

private theorem typical_inputs {A : Type u} [Fintype A]
    (p : PMF A) {ε : ℝ} (hε : 0 < ε) :
    Filter.Tendsto
      (fun n : ℕ => ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal)
      Filter.atTop (nhds 0) ∧
    (∀ (n : ℕ) (x : Fin n → A), x ∈ weakTypicalSet p n ε →
      (PMF.iid p n x).toReal ≤ Real.exp (-(n : ℝ) * (entropy p - ε))) ∧
    (∀ n : ℕ, ((weakTypicalSet p n ε).card : ℝ) ≤
      Real.exp ((n : ℝ) * (entropy p + ε))) ∧
    (∀ n M : ℕ, Real.exp ((n : ℝ) * (entropy p + ε)) ≤ (M : ℝ) →
      (weakTypicalSet p n ε).card ≤ M ∧ 1 ≤ M ∧ Fintype.card (Fin M) = M) := by
  refine ⟨typical_complement_probability p hε, ?_, ?_, ?_⟩
  · intro n x hx
    exact (weakTypicalSet_mass_bounds p hx).2
  · intro n
    exact card_weakTypicalSet_le p n ε
  · intro n M hM
    have hcard : ((weakTypicalSet p n ε).card : ℝ) ≤ (M : ℝ) :=
      (card_weakTypicalSet_le p n ε).trans hM
    have hpos : (0 : ℝ) < M := (Real.exp_pos _).trans_le hM
    refine ⟨Nat.cast_le.mp hcard, ?_, Fintype.card_fin M⟩
    exact Nat.succ_le_of_lt (Nat.cast_pos.mp hpos)

end

end LeanInfoTheory.Examples.AEP
