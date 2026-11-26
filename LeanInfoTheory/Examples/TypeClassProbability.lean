/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.TypeClassProbability

/-!
# General-prior type-probability examples

One three-word Boolean class is sampled under a fair, biased, and deterministic
prior. Finite products give the individual word masses, and summing over the
class gives its probability. A sparse three-label example checks finite KL
and the lower bound with the full alphabet size. All fixtures are private.
-/

namespace LeanInfoTheory.Examples.TypeClassProbability

open LeanInfoTheory.Shannon
open scoped BigOperators ENNReal

namespace Sparse

private def counts : Fin 3 → ℕ := ![2, 0, 0]

private noncomputable def index : ↥(wordTypes (Fin 3) 2) :=
  ⟨counts, (mem_wordTypes _).2
    (by norm_num [counts, Fin.sum_univ_succ])⟩

private def word : Fin 2 → Fin 3 := fun _ => 0

-- This prior is supplied independently of the empirical construction.
private noncomputable def prior : PMF (Fin 3) :=
  PMF.ofFintype
    (fun a => ENNReal.ofReal (if a = 2 then (0 : ℝ) else 1 / 2))
    (by
      have hnonneg :
          ∀ a : Fin 3, 0 ≤ (if a = 2 then (0 : ℝ) else 1 / 2) := by
        intro a
        split_ifs <;> norm_num
      rw [← ENNReal.ofReal_sum_of_nonneg (fun a _ => hnonneg a)]
      norm_num [Fin.sum_univ_succ, Fin.ext_iff])

private theorem prior_toReal (a : Fin 3) :
    (prior a).toReal = if a = 2 then 0 else 1 / 2 := by
  change
    (ENNReal.ofReal (if a = 2 then (0 : ℝ) else 1 / 2)).toReal = _
  split_ifs <;> norm_num

private theorem prior_atoms :
    prior 0 = 1 / 2 ∧ prior 1 = 1 / 2 ∧ prior 2 = 0 := by
  norm_num [prior, PMF.ofFintype_apply, ENNReal.ofReal_div_of_pos, Fin.ext_iff]

private theorem word_mem : word ∈ typeClass index := by
  apply mem_typeClass.2
  apply Subtype.ext
  funext a
  change symbolCount word a = counts a
  fin_cases a <;> simp [symbolCount, word, counts]

private theorem empirical_eq_pure :
    empiricalPMF (by decide : 0 < (2 : ℕ)) index =
      PMF.pure (0 : Fin 3) := by
  ext a
  rw [empiricalPMF_apply]
  fin_cases a <;> norm_num [index, counts, PMF.pure_apply]
  exact ENNReal.div_self (by norm_num) ENNReal.ofNat_ne_top

private theorem prior_support :
    prior.support = ({0, 1} : Set (Fin 3)) := by
  ext a
  rw [PMF.mem_support_iff]
  change
    ENNReal.ofReal (if a = 2 then (0 : ℝ) else 1 / 2) ≠ 0 ↔ _
  fin_cases a <;> norm_num [Fin.ext_iff]

private theorem strict_support :
    (empiricalPMF (by decide : 0 < (2 : ℕ)) index).support ⊂
      prior.support := by
  rw [empirical_eq_pure, PMF.support_pure, prior_support,
    Set.ssubset_iff_subset_ne]
  constructor
  · intro a ha
    have ha0 : a = 0 := Set.mem_singleton_iff.1 ha
    subst a
    simp
  · intro heq
    have h1 : (1 : Fin 3) ∈ ({0, 1} : Set (Fin 3)) := by simp
    rw [← heq] at h1
    norm_num at h1

private theorem support_inclusion :
    (empiricalPMF (by decide : 0 < (2 : ℕ)) index).support ⊆
      prior.support :=
  (Set.ssubset_iff_subset_ne.1 strict_support).1

-- The two unused labels test different cases in the finite-KL word proof.
private theorem unused_labels :
    index.val 1 = 0 ∧ prior 1 = 1 / 2 ∧
      index.val 2 = 0 ∧ prior 2 = 0 := by
  exact ⟨rfl, prior_atoms.2.1, rfl, prior_atoms.2.2⟩

private theorem word_mass :
    ((PMF.iid prior 2) word).toReal = (1 / 4 : ℝ) := by
  change
    ((PMF.finiteProduct (fun _ : Fin 2 => prior)) word).toReal = 1 / 4
  simp only [PMF.finiteProduct_apply, ENNReal.toReal_prod, prior_toReal]
  norm_num [Fin.prod_univ_succ, word, Fin.ext_iff]

private theorem word_mass_ennreal :
    (PMF.iid prior 2) word = (1 / 4 : ℝ≥0∞) := by
  apply (ENNReal.toReal_eq_toReal_iff'
    ((PMF.iid prior 2).apply_ne_top word)
    (ENNReal.div_ne_top ENNReal.one_ne_top (by norm_num))).1
  rw [word_mass]
  norm_num [ENNReal.toReal_div]

private theorem class_card : (typeClass index).card = 1 := by
  rw [card_typeClass_eq_multinomial]
  change Nat.multinomial Finset.univ ![2, 0, 0] = 1
  rw [Nat.multinomial_univ_three]
  norm_num

private theorem class_singleton : typeClass index = {word} := by
  classical
  symm
  apply Finset.eq_of_subset_of_card_le
  · exact Finset.singleton_subset_iff.2 word_mem
  · rw [class_card]
    simp

private theorem class_mass :
    (PMF.iid prior 2).toOuterMeasure (typeClass index) =
      (1 / 4 : ℝ≥0∞) := by
  rw [class_singleton, PMF.toOuterMeasure_apply_finset,
    Finset.sum_singleton]
  exact word_mass_ennreal

private theorem kl_finite :
    InformationTheory.klDiv
      (empiricalPMF (by decide : 0 < (2 : ℕ)) index).toMeasure
      prior.toMeasure ≠ ⊤ :=
  (klDiv_pmf_ne_top_iff_support_subset _ _).2 support_inclusion

private theorem general_word_formula :
    ((PMF.iid prior 2) word).toReal =
      Real.exp (-(2 : ℝ) *
        (entropy (empiricalPMF (by decide : 0 < (2 : ℕ)) index) +
          (InformationTheory.klDiv
            (empiricalPMF (by decide : 0 < (2 : ℕ)) index).toMeasure
            prior.toMeasure).toReal)) :=
  iid_apply_of_mem_typeClass (by decide) index prior
    support_inclusion word_mem

private theorem general_class_formula :
    ((PMF.iid prior 2).toOuterMeasure (typeClass index)).toReal =
      ((typeClass index).card : ℝ) *
        Real.exp (-(2 : ℝ) *
          (entropy (empiricalPMF (by decide : 0 < (2 : ℕ)) index) +
            (InformationTheory.klDiv
              (empiricalPMF (by decide : 0 < (2 : ℕ)) index).toMeasure
              prior.toMeasure).toReal)) :=
  iid_toOuterMeasure_typeClass (by decide) index prior support_inclusion

private theorem general_class_formula_value :
    ((typeClass index).card : ℝ) *
        Real.exp (-(2 : ℝ) *
          (entropy (empiricalPMF (by decide : 0 < (2 : ℕ)) index) +
            (InformationTheory.klDiv
              (empiricalPMF (by decide : 0 < (2 : ℕ)) index).toMeasure
              prior.toMeasure).toReal)) = (1 / 4 : ℝ) := by
  rw [← general_class_formula, class_mass]
  norm_num [ENNReal.toReal_div]

private theorem finite_kl_value :
    InformationTheory.klDiv
        (empiricalPMF (by decide : 0 < (2 : ℕ)) index).toMeasure
        prior.toMeasure ≠ ⊤ ∧
      (InformationTheory.klDiv
        (empiricalPMF (by decide : 0 < (2 : ℕ)) index).toMeasure
        prior.toMeasure).toReal = Real.log 2 := by
  refine ⟨kl_finite, ?_⟩
  rw [toReal_klDiv_pmf_eq_sum _ _
    ((toMeasure_absolutelyContinuous_iff_support_subset _ _).2 support_inclusion)]
  rw [empirical_eq_pure]
  rw [Finset.sum_eq_single (0 : Fin 3)]
  · have hp : (prior 0).toReal = (1 / 2 : ℝ) := by
      rw [prior_atoms.1]
      norm_num [ENNReal.toReal_div]
    rw [PMF.pure_apply_self, ENNReal.toReal_one, one_mul,
      ENNReal.toReal_div, ENNReal.toReal_one, hp]
    norm_num
  · intro a _ ha
    rw [PMF.pure_apply_of_ne _ _ ha, ENNReal.toReal_zero, zero_mul]
  · simp

private theorem kl_exponential_value :
    Real.exp (-(2 : ℝ) *
      (InformationTheory.klDiv
        (empiricalPMF (by decide : 0 < (2 : ℕ)) index).toMeasure
        prior.toMeasure).toReal) = (1 / 4 : ℝ) := by
  rw [finite_kl_value.2, neg_mul, Real.exp_neg]
  have hexp : Real.exp ((2 : ℝ) * Real.log 2) = (2 : ℝ) ^ 2 := by
    simpa only [Nat.cast_ofNat, Real.exp_log (by norm_num : (0 : ℝ) < 2)] using
      Real.exp_nat_mul (Real.log 2) 2
  rw [hexp]
  norm_num

-- Ambient size is three even though the empirical support has just one label.
private theorem class_bounds :
    (1 / 108 : ℝ) ≤
        ((PMF.iid prior 2).toOuterMeasure (typeClass index)).toReal ∧
      ((PMF.iid prior 2).toOuterMeasure (typeClass index)).toReal ≤
        (1 / 4 : ℝ) := by
  have hlower := exp_neg_klDiv_div_pow_le_iid_toOuterMeasure_typeClass
    (by decide) index prior support_inclusion
  have hupper := iid_toOuterMeasure_typeClass_le_exp_neg_klDiv
    (by decide) index prior support_inclusion
  norm_num only [Nat.cast_ofNat] at hlower hupper
  rw [kl_exponential_value] at hlower hupper
  constructor
  · norm_num only [Fintype.card_fin, Nat.cast_ofNat] at hlower
    exact hlower
  · exact hupper

private theorem class_bounds_exact :
    (1 / 108 : ℝ) ≤ 1 / 4 ∧ (1 / 4 : ℝ) ≤ 1 / 4 := by
  simpa only [class_mass, ENNReal.toReal_div, ENNReal.toReal_one,
    ENNReal.toReal_ofNat] using class_bounds

end Sparse

namespace Binary

private def counts (a : Bool) : ℕ := if a then 1 else 2
private def word001 : Fin 3 → Bool := ![false, false, true]
private def word010 : Fin 3 → Bool := ![false, true, false]
private def word100 : Fin 3 → Bool := ![true, false, false]

private noncomputable def index : ↥(wordTypes Bool 3) :=
  ⟨counts, (mem_wordTypes counts).2 (by decide)⟩

private noncomputable def law : PMF Bool := empiricalPMF (by decide) index
private noncomputable def fair : PMF Bool := PMF.uniformOfFintype Bool
private noncomputable def biased : PMF Bool :=
  PMF.ofFintype
    (fun a => ENNReal.ofReal (if a then (1 / 4 : ℝ) else 3 / 4))
    (by
      rw [← ENNReal.ofReal_sum_of_nonneg (fun a _ => by cases a <;> norm_num)]
      norm_num [Fintype.sum_bool])
private noncomputable def singular : PMF Bool := PMF.pure false

private theorem univ_three : (Finset.univ : Finset (Fin 3)) = {0, 1, 2} := by decide

private theorem mem_index_iff (x : Fin 3 → Bool) :
    x ∈ typeClass index ↔ symbolCount x false = 2 ∧ symbolCount x true = 1 := by
  rw [mem_typeClass]
  constructor
  · intro h
    exact ⟨congrArg (fun t : ↥(wordTypes Bool 3) => t.val false) h,
      congrArg (fun t : ↥(wordTypes Bool 3) => t.val true) h⟩
  · rintro ⟨hf, ht⟩
    apply Subtype.ext
    funext a
    cases a
    · exact hf
    · exact ht

-- Enumerate all eight Boolean words without using a cardinality theorem.
private theorem class_eq : typeClass index = {word001, word010, word100} := by
  classical
  ext x
  rw [mem_index_iff]
  obtain ⟨a, y, rfl⟩ := Fin.exists_cons x
  obtain ⟨b, z, rfl⟩ := Fin.exists_cons y
  obtain ⟨c, e, rfl⟩ := Fin.exists_cons z
  have he : e = ![] := Subsingleton.elim _ _
  subst e
  cases a <;> cases b <;> cases c <;>
    norm_num [symbolCount, univ_three, word001, word010, word100,
      funext_iff, Fin.forall_fin_succ] <;> decide

private theorem class_card : (typeClass index).card = 3 := by
  classical
  rw [class_eq]
  norm_num [word001, word010, word100, funext_iff, Fin.forall_fin_succ]

private theorem law_toReal (a : Bool) :
    (law a).toReal = if a then 1 / 3 else 2 / 3 := by
  cases a <;>
    norm_num [law, empiricalPMF_apply, index, counts, ENNReal.toReal_div]

private theorem fair_apply (a : Bool) : fair a = (1 / 2 : ℝ≥0∞) := by
  simp [fair, PMF.uniformOfFintype_apply, one_div]

private theorem biased_toReal (a : Bool) :
    (biased a).toReal = if a then 1 / 4 else 3 / 4 := by
  change (ENNReal.ofReal (if a then (1 / 4 : ℝ) else 3 / 4)).toReal = _
  cases a <;> norm_num

private theorem biased_atoms :
    biased false = (3 / 4 : ℝ≥0∞) ∧ biased true = 1 / 4 := by
  norm_num [biased, PMF.ofFintype_apply, ENNReal.ofReal_div_of_pos]

private theorem fair_support : law.support ⊆ fair.support := by
  intro a _
  rw [PMF.mem_support_iff, fair_apply]
  norm_num

private theorem biased_full_support : biased.support = Set.univ := by
  ext a
  cases a <;> simp [biased]

private theorem biased_support : law.support ⊆ biased.support := by
  rw [biased_full_support]
  exact Set.subset_univ _

private theorem biased_ne_law : biased ≠ law := by
  intro h
  have heq := congrArg (fun p : PMF Bool => (p false).toReal) h
  rw [biased_toReal, law_toReal] at heq
  norm_num at heq

private theorem fair_word_mass (x : Fin 3 → Bool) :
    ((PMF.iid fair 3) x).toReal = (1 / 8 : ℝ) := by
  change ((PMF.finiteProduct (fun _ : Fin 3 => fair)) x).toReal = _
  simp only [PMF.finiteProduct_apply, ENNReal.toReal_prod, fair_apply]
  norm_num [Fin.prod_univ_succ, ENNReal.toReal_div]

private theorem fair_word_mass_ennreal (x : Fin 3 → Bool) :
    (PMF.iid fair 3) x = (1 / 8 : ℝ≥0∞) := by
  apply (ENNReal.toReal_eq_toReal_iff'
    ((PMF.iid fair 3).apply_ne_top x)
    (ENNReal.div_ne_top ENNReal.one_ne_top (by norm_num))).1
  rw [fair_word_mass]
  norm_num [ENNReal.toReal_div]

private theorem fair_class_mass :
    (PMF.iid fair 3).toOuterMeasure (typeClass index) = (3 / 8 : ℝ≥0∞) := by
  rw [PMF.toOuterMeasure_apply_finset]
  simp only [fair_word_mass_ennreal, Finset.sum_const, nsmul_eq_mul, class_card]
  norm_num [div_eq_mul_inv]

private theorem fair_class_mass_real :
    ((PMF.iid fair 3).toOuterMeasure (typeClass index)).toReal = (3 / 8 : ℝ) := by
  rw [fair_class_mass]
  norm_num [ENNReal.toReal_div]

private theorem fair_word_formula (x : Fin 3 → Bool) (hx : x ∈ typeClass index) :
    (1 / 8 : ℝ) = Real.exp (-(3 : ℝ) *
      (entropy law + (InformationTheory.klDiv law.toMeasure fair.toMeasure).toReal)) := by
  have h := iid_apply_of_mem_typeClass (by decide) index fair fair_support hx
  simpa only [law, fair_word_mass, Nat.cast_ofNat] using h

private theorem fair_class_formula :
    (3 / 8 : ℝ) = 3 * Real.exp (-(3 : ℝ) *
      (entropy law + (InformationTheory.klDiv law.toMeasure fair.toMeasure).toReal)) := by
  have h := iid_toOuterMeasure_typeClass (by decide) index fair fair_support
  simpa only [law, fair_class_mass_real, class_card, Nat.cast_ofNat] using h

private theorem fair_class_word_factor (x : Fin 3 → Bool) (hx : x ∈ typeClass index) :
    ((PMF.iid fair 3).toOuterMeasure (typeClass index)).toReal =
      3 * ((PMF.iid fair 3) x).toReal := by
  have hword := iid_apply_of_mem_typeClass (by decide) index fair fair_support hx
  have hclass := iid_toOuterMeasure_typeClass (by decide) index fair fair_support
  rw [← hword, class_card] at hclass
  simpa only [Nat.cast_ofNat] using hclass

private theorem fair_bounds :
    Real.exp (-(3 : ℝ) *
        (InformationTheory.klDiv law.toMeasure fair.toMeasure).toReal) / 4 ^ 2 ≤ 3 / 8 ∧
      (3 / 8 : ℝ) ≤ Real.exp (-(3 : ℝ) *
        (InformationTheory.klDiv law.toMeasure fair.toMeasure).toReal) := by
  constructor
  · simpa only [law, fair_class_mass_real, Fintype.card_bool, Nat.cast_ofNat,
      show (3 : ℝ) + 1 = 4 by norm_num] using
      exp_neg_klDiv_div_pow_le_iid_toOuterMeasure_typeClass
        (by decide) index fair fair_support
  · simpa only [law, fair_class_mass_real, Nat.cast_ofNat] using
      iid_toOuterMeasure_typeClass_le_exp_neg_klDiv (by decide) index fair fair_support

private theorem biased_word_mass (x : Fin 3 → Bool) (hx : x ∈ typeClass index) :
    ((PMF.iid biased 3) x).toReal = (9 / 64 : ℝ) := by
  have hx' : x = word001 ∨ x = word010 ∨ x = word100 := by
    simpa only [class_eq, Finset.mem_insert, Finset.mem_singleton] using hx
  rcases hx' with rfl | rfl | rfl <;>
    change ((PMF.finiteProduct (fun _ : Fin 3 => biased)) _).toReal = _ <;>
    simp only [PMF.finiteProduct_apply, ENNReal.toReal_prod, biased_toReal] <;>
    norm_num [Fin.prod_univ_succ, word001, word010, word100]

private theorem biased_word_mass_ennreal (x : Fin 3 → Bool) (hx : x ∈ typeClass index) :
    (PMF.iid biased 3) x = (9 / 64 : ℝ≥0∞) := by
  apply (ENNReal.toReal_eq_toReal_iff'
    ((PMF.iid biased 3).apply_ne_top x)
    (ENNReal.div_ne_top (by norm_num) (by norm_num))).1
  rw [biased_word_mass x hx]
  norm_num [ENNReal.toReal_div]

private theorem biased_class_mass :
    (PMF.iid biased 3).toOuterMeasure (typeClass index) = (27 / 64 : ℝ≥0∞) := by
  rw [PMF.toOuterMeasure_apply_finset]
  calc
    (∑ x ∈ typeClass index, (PMF.iid biased 3) x) =
        ∑ _x ∈ typeClass index, (9 / 64 : ℝ≥0∞) :=
      Finset.sum_congr rfl (fun x hx => biased_word_mass_ennreal x hx)
    _ = 27 / 64 := by
      simp only [Finset.sum_const, nsmul_eq_mul, class_card]
      norm_num [div_eq_mul_inv, ← mul_assoc]

private theorem biased_class_mass_real :
    ((PMF.iid biased 3).toOuterMeasure (typeClass index)).toReal = (27 / 64 : ℝ) := by
  rw [biased_class_mass]
  norm_num [ENNReal.toReal_div]

private theorem biased_kl_finite :
    InformationTheory.klDiv law.toMeasure biased.toMeasure ≠ ⊤ :=
  (klDiv_pmf_ne_top_iff_support_subset law biased).2 biased_support

private theorem biased_kl :
    (InformationTheory.klDiv law.toMeasure biased.toMeasure).toReal =
      (2 / 3 : ℝ) * Real.log (8 / 9) + (1 / 3 : ℝ) * Real.log (4 / 3) := by
  have hac := (toMeasure_absolutelyContinuous_iff_support_subset law biased).2 biased_support
  rw [toReal_klDiv_pmf_eq_sum law biased hac, Fintype.sum_bool]
  simp only [ENNReal.toReal_div, law_toReal, biased_toReal]
  norm_num
  ring

private theorem biased_word_formula (x : Fin 3 → Bool) (hx : x ∈ typeClass index) :
    (9 / 64 : ℝ) = Real.exp (-(3 : ℝ) *
      (entropy law + (InformationTheory.klDiv law.toMeasure biased.toMeasure).toReal)) := by
  have h := iid_apply_of_mem_typeClass (by decide) index biased biased_support hx
  simpa only [law, biased_word_mass x hx, Nat.cast_ofNat] using h

private theorem biased_class_formula :
    (27 / 64 : ℝ) = 3 * Real.exp (-(3 : ℝ) *
      (entropy law + (InformationTheory.klDiv law.toMeasure biased.toMeasure).toReal)) := by
  have h := iid_toOuterMeasure_typeClass (by decide) index biased biased_support
  simpa only [law, biased_class_mass_real, class_card, Nat.cast_ofNat] using h

private theorem biased_bounds :
    Real.exp (-(3 : ℝ) *
        (InformationTheory.klDiv law.toMeasure biased.toMeasure).toReal) / 4 ^ 2 ≤ 27 / 64 ∧
      (27 / 64 : ℝ) ≤ Real.exp (-(3 : ℝ) *
        (InformationTheory.klDiv law.toMeasure biased.toMeasure).toReal) := by
  constructor
  · simpa only [law, biased_class_mass_real, Fintype.card_bool, Nat.cast_ofNat,
      show (3 : ℝ) + 1 = 4 by norm_num] using
      exp_neg_klDiv_div_pow_le_iid_toOuterMeasure_typeClass
        (by decide) index biased biased_support
  · simpa only [law, biased_class_mass_real, Nat.cast_ofNat] using
      iid_toOuterMeasure_typeClass_le_exp_neg_klDiv (by decide) index biased biased_support

private theorem singular_atoms : singular false = 1 ∧ singular true = 0 := by
  simp [singular, PMF.pure_apply]

private theorem singular_observed_zero : index.val true = 1 ∧ singular true = 0 :=
  ⟨rfl, singular_atoms.2⟩

private theorem singular_support_failure : ¬ law.support ⊆ singular.support := by
  intro h
  have ha : true ∈ law.support :=
    (mem_support_empiricalPMF_iff (by decide) index true).2
      (by rw [singular_observed_zero.1]; decide)
  exact ((singular.mem_support_iff true).1 (h ha)) singular_observed_zero.2

private theorem singular_word_mass (x : Fin 3 → Bool) (hx : x ∈ typeClass index) :
    (PMF.iid singular 3) x = 0 := by
  have hx' : x = word001 ∨ x = word010 ∨ x = word100 := by
    simpa only [class_eq, Finset.mem_insert, Finset.mem_singleton] using hx
  rcases hx' with rfl | rfl | rfl <;>
    change (PMF.finiteProduct (fun _ : Fin 3 => singular)) _ = 0 <;>
    simp [PMF.finiteProduct_apply, Fin.prod_univ_succ,
      word001, word010, word100, singular, PMF.pure_apply]

private theorem singular_class_mass :
    (PMF.iid singular 3).toOuterMeasure (typeClass index) = 0 :=
  iid_toOuterMeasure_typeClass_eq_zero_of_not_support_subset
    (by decide) index singular singular_support_failure

private theorem singular_kl_top :
    InformationTheory.klDiv law.toMeasure singular.toMeasure = ⊤ :=
  (klDiv_pmf_eq_top_iff_not_support_subset law singular).2 singular_support_failure

end Binary

end LeanInfoTheory.Examples.TypeClassProbability
