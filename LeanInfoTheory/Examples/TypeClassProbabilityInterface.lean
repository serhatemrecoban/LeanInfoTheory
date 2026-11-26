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
# Public type-probability interface consumers

These private generic callers import only the focused mathematical owner and
use no numerical-example helpers. The supplied-index and word-index entry
points both retain actual support inclusion and positive length. Canonical
KL finiteness is checked through the existing supported support criterion.
The whole-class caller multiplies the common word mass by the class cardinality.
Separate finite-mass and nonnegativity guards recover actual ENNReal word and
class identities from their public real-valued formulas. The singular callers
connect an observed zero-prior symbol to infinite KL and characterize exactly
when the class has zero probability. Additional callers use raw counts, laws with
an exact denominator witness, the empirical prior, and positive-length boundaries.
-/

namespace LeanInfoTheory.Examples.TypeClassProbabilityInterface

open LeanInfoTheory.Shannon
open scoped BigOperators ENNReal

universe u

variable {A : Type u} [Fintype A] {n : ℕ}
variable [MeasurableSpace A] [MeasurableSingletonClass A]

private theorem supplied_index_word
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support)
    (x : Fin n → A) (hx : x ∈ typeClass t) :
    InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure ≠ ⊤ ∧
      ((PMF.iid p n) x).toReal =
        Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
          (InformationTheory.klDiv
            (empiricalPMF hn t).toMeasure p.toMeasure).toReal)) :=
  ⟨(klDiv_pmf_ne_top_iff_support_subset _ _).2 h,
    iid_apply_of_mem_typeClass hn t p h hx⟩

private theorem word_type_word
    (hn : 0 < n) (x : Fin n → A) (p : PMF A)
    (h : (empiricalPMF hn (wordType x)).support ⊆ p.support) :
    ((PMF.iid p n) x).toReal =
      Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn (wordType x)) +
        (InformationTheory.klDiv
          (empiricalPMF hn (wordType x)).toMeasure p.toMeasure).toReal)) :=
  iid_apply_of_mem_typeClass hn (wordType x) p h (mem_typeClass.2 rfl)

private theorem supplied_index_class
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support) :
    InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure ≠ ⊤ ∧
      ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal =
        ((typeClass t).card : ℝ) *
          Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
            (InformationTheory.klDiv
              (empiricalPMF hn t).toMeasure p.toMeasure).toReal)) :=
  ⟨(klDiv_pmf_ne_top_iff_support_subset _ _).2 h,
    iid_toOuterMeasure_typeClass hn t p h⟩

private theorem supplied_index_masses_ennreal
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support)
    (x : Fin n → A) (hx : x ∈ typeClass t) :
    (PMF.iid p n) x =
        ENNReal.ofReal (Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
          (InformationTheory.klDiv
            (empiricalPMF hn t).toMeasure p.toMeasure).toReal))) ∧
      (PMF.iid p n).toOuterMeasure (typeClass t) =
        ENNReal.ofReal (((typeClass t).card : ℝ) *
          Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
            (InformationTheory.klDiv
              (empiricalPMF hn t).toMeasure p.toMeasure).toReal))) := by
  classical
  constructor
  · apply (ENNReal.toReal_eq_toReal_iff'
      ((PMF.iid p n).apply_ne_top x) ENNReal.ofReal_ne_top).1
    rw [ENNReal.toReal_ofReal (Real.exp_pos _).le]
    exact iid_apply_of_mem_typeClass hn t p h hx
  · have hfinite :
        (PMF.iid p n).toOuterMeasure (typeClass t) ≠ ⊤ := by
      rw [PMF.toOuterMeasure_apply_finset]
      exact ENNReal.sum_ne_top.2
        (fun y _ => (PMF.iid p n).apply_ne_top y)
    have hnonneg : 0 ≤ ((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
          (InformationTheory.klDiv
            (empiricalPMF hn t).toMeasure p.toMeasure).toReal)) :=
      mul_nonneg (Nat.cast_nonneg _) (Real.exp_pos _).le
    apply (ENNReal.toReal_eq_toReal_iff'
      hfinite ENNReal.ofReal_ne_top).1
    rw [ENNReal.toReal_ofReal hnonneg]
    exact iid_toOuterMeasure_typeClass hn t p h

private theorem supplied_index_bounds
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support) :
    Real.exp (-(n : ℝ) *
        (InformationTheory.klDiv
          (empiricalPMF hn t).toMeasure p.toMeasure).toReal) /
        ((n : ℝ) + 1) ^ Fintype.card A ≤
      ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal ∧
    ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal ≤
      Real.exp (-(n : ℝ) *
        (InformationTheory.klDiv
          (empiricalPMF hn t).toMeasure p.toMeasure).toReal) :=
  ⟨exp_neg_klDiv_div_pow_le_iid_toOuterMeasure_typeClass hn t p h,
    iid_toOuterMeasure_typeClass_le_exp_neg_klDiv hn t p h⟩

private theorem own_law_bounds
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    InformationTheory.klDiv
        (empiricalPMF hn t).toMeasure
        (empiricalPMF hn t).toMeasure = 0 ∧
      1 / ((n : ℝ) + 1) ^ Fintype.card A ≤
        ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t)).toReal ∧
      ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t)).toReal ≤ 1 := by
  have hzero :
      InformationTheory.klDiv
        (empiricalPMF hn t).toMeasure
        (empiricalPMF hn t).toMeasure = 0 :=
    (klDiv_pmf_eq_zero_iff (empiricalPMF hn t) (empiricalPMF hn t)).2 rfl
  refine ⟨hzero, ?_, ?_⟩
  · simpa only [hzero, ENNReal.toReal_zero, mul_zero, Real.exp_zero] using
      exp_neg_klDiv_div_pow_le_iid_toOuterMeasure_typeClass
        hn t (empiricalPMF hn t) (fun _ ha => ha)
  · simpa only [hzero, ENNReal.toReal_zero, mul_zero, Real.exp_zero] using
      iid_toOuterMeasure_typeClass_le_exp_neg_klDiv
        hn t (empiricalPMF hn t) (fun _ ha => ha)

omit [MeasurableSpace A] [MeasurableSingletonClass A] in
private theorem failed_support_class_zero
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : ¬ (empiricalPMF hn t).support ⊆ p.support) :
    (PMF.iid p n).toOuterMeasure (typeClass t) = 0 :=
  iid_toOuterMeasure_typeClass_eq_zero_of_not_support_subset hn t p h

private theorem observed_zero_prior_class_and_kl_top
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (hobs : ∃ a, 0 < t.val a ∧ p a = 0) :
    (PMF.iid p n).toOuterMeasure (typeClass t) = 0 ∧
      InformationTheory.klDiv
        (empiricalPMF hn t).toMeasure p.toMeasure = ⊤ := by
  rcases hobs with ⟨a, hcount, hzero⟩
  have hnot : ¬ (empiricalPMF hn t).support ⊆ p.support := by
    intro hsupport
    have ha : a ∈ p.support :=
      hsupport ((mem_support_empiricalPMF_iff hn t a).2 hcount)
    exact ((p.mem_support_iff a).1 ha) hzero
  exact ⟨iid_toOuterMeasure_typeClass_eq_zero_of_not_support_subset hn t p hnot,
    (klDiv_pmf_eq_top_iff_not_support_subset (empiricalPMF hn t) p).2 hnot⟩

private theorem failed_support_class_and_kl_top
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : ¬ (empiricalPMF hn t).support ⊆ p.support) :
    (PMF.iid p n).toOuterMeasure (typeClass t) = 0 ∧
      InformationTheory.klDiv
        (empiricalPMF hn t).toMeasure p.toMeasure = ⊤ :=
  ⟨iid_toOuterMeasure_typeClass_eq_zero_of_not_support_subset hn t p h,
    (klDiv_pmf_eq_top_iff_not_support_subset (empiricalPMF hn t) p).2 h⟩

private theorem class_zero_iff_kl_top
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A) :
    (PMF.iid p n).toOuterMeasure (typeClass t) = 0 ↔
      InformationTheory.klDiv
        (empiricalPMF hn t).toMeasure p.toMeasure = ⊤ := by
  constructor
  · intro hzero
    apply (klDiv_pmf_eq_top_iff_not_support_subset (empiricalPMF hn t) p).2
    intro hsupport
    -- The public lower bound is used only in its finite-KL support branch.
    have hbound :=
      exp_neg_klDiv_div_pow_le_iid_toOuterMeasure_typeClass hn t p hsupport
    have hden : 0 < ((n : ℝ) + 1) ^ Fintype.card A :=
      pow_pos (by positivity) _
    have hpositive :
        0 < Real.exp (-(n : ℝ) *
          (InformationTheory.klDiv
            (empiricalPMF hn t).toMeasure p.toMeasure).toReal) /
          ((n : ℝ) + 1) ^ Fintype.card A :=
      div_pos (Real.exp_pos _) hden
    rw [hzero, ENNReal.toReal_zero] at hbound
    exact (not_le_of_gt hpositive) hbound
  · intro htop
    exact iid_toOuterMeasure_typeClass_eq_zero_of_not_support_subset hn t p
      ((klDiv_pmf_eq_top_iff_not_support_subset (empiricalPMF hn t) p).1 htop)

private theorem raw_counts_class
    (hn : 0 < n) (c : A → ℕ) (hc : (∑ a, c a) = n) (p : PMF A)
    (h : (empiricalPMF hn ⟨c, (mem_wordTypes c).2 hc⟩).support ⊆ p.support) :
    let t : ↥(wordTypes A n) := ⟨c, (mem_wordTypes c).2 hc⟩
    ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal =
      ((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
          (InformationTheory.klDiv
            (empiricalPMF hn t).toMeasure p.toMeasure).toReal)) := by
  exact iid_toOuterMeasure_typeClass hn _ p h

private theorem supplied_law_class
    (hn : 0 < n) (q p : PMF A)
    (hq : ∃ c : A → ℕ, (∑ a, c a) = n ∧
      ∀ a, q a = (c a : ℝ≥0∞) / (n : ℝ≥0∞))
    (h : q.support ⊆ p.support) :
    let t := (wordTypeEquivPMF (A := A) hn).symm ⟨q, hq⟩
    empiricalPMF hn t = q ∧
      InformationTheory.klDiv q.toMeasure p.toMeasure ≠ ⊤ ∧
      ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal =
        ((typeClass t).card : ℝ) *
          Real.exp (-(n : ℝ) * (entropy q +
            (InformationTheory.klDiv q.toMeasure p.toMeasure).toReal)) := by
  let t := (wordTypeEquivPMF (A := A) hn).symm ⟨q, hq⟩
  have ht : empiricalPMF hn t = q :=
    congrArg Subtype.val ((wordTypeEquivPMF (A := A) hn).apply_symm_apply ⟨q, hq⟩)
  have hs : (empiricalPMF hn t).support ⊆ p.support := by
    rw [ht]
    exact h
  refine ⟨ht, (klDiv_pmf_ne_top_iff_support_subset q p).2 h, ?_⟩
  have hclass := iid_toOuterMeasure_typeClass hn t p hs
  rw [ht] at hclass
  exact hclass

-- Both generations of public formulas are evaluated on the same word/class.
private theorem own_law_formula_agreement
    (hn : 0 < n) (t : ↥(wordTypes A n))
    (x : Fin n → A) (hx : x ∈ typeClass t) :
    Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
        (InformationTheory.klDiv (empiricalPMF hn t).toMeasure
          (empiricalPMF hn t).toMeasure).toReal)) =
      Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)) ∧
    ((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
          (InformationTheory.klDiv (empiricalPMF hn t).toMeasure
            (empiricalPMF hn t).toMeasure).toReal)) =
      ((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)) :=
  ⟨(iid_apply_of_mem_typeClass hn t (empiricalPMF hn t)
      (fun _ ha => ha) hx).symm.trans
        (iid_empiricalPMF_apply_of_mem_typeClass hn t hx),
    (iid_toOuterMeasure_typeClass hn t (empiricalPMF hn t)
      (fun _ ha => ha)).symm.trans
        (iid_empiricalPMF_toOuterMeasure_typeClass hn t)⟩

omit [MeasurableSpace A] [MeasurableSingletonClass A] in
private theorem constant_word_empirical (hn : 0 < n) (a : A) :
    empiricalPMF hn (wordType (fun _ : Fin n => a)) = PMF.pure a := by
  classical
  have hn0 : (n : ℝ≥0∞) ≠ 0 := by exact_mod_cast Nat.ne_of_gt hn
  ext b
  rw [empiricalPMF_apply]
  change ((Finset.univ.filter fun _ : Fin n => a = b).card : ℝ≥0∞) /
    (n : ℝ≥0∞) = PMF.pure a b
  by_cases hab : a = b
  · subst b
    simp only [Finset.filter_true, Finset.card_univ, Fintype.card_fin,
      PMF.pure_apply_self]
    exact ENNReal.div_self hn0 (ENNReal.natCast_ne_top n)
  · simp [hab, Ne.symm hab, PMF.pure_apply]

omit [MeasurableSpace A] [MeasurableSingletonClass A] in
private theorem constant_word_class (hn : 0 < n) (a : A) :
    typeClass (wordType (fun _ : Fin n => a)) = {fun _ : Fin n => a} := by
  classical
  ext x
  rw [Finset.mem_singleton]
  constructor
  · intro hx
    funext i
    have hcount : 0 < symbolCount x (x i) := by
      apply Finset.card_pos.2
      exact ⟨i, by simp⟩
    have hs : x i ∈
        (empiricalPMF hn (wordType (fun _ : Fin n => a))).support := by
      apply (mem_support_empiricalPMF_iff hn _ _).2
      rw [← mem_typeClass.1 hx]
      exact hcount
    rw [constant_word_empirical hn a, PMF.support_pure] at hs
    exact Set.mem_singleton_iff.1 hs
  · rintro rfl
    exact mem_typeClass.2 rfl

private theorem pure_positive_probabilities (hn : 0 < n) (a : A) :
    InformationTheory.klDiv
        (empiricalPMF hn (wordType (fun _ : Fin n => a))).toMeasure
        (PMF.pure a).toMeasure = 0 ∧
      ((PMF.iid (PMF.pure a) n) (fun _ : Fin n => a)).toReal = 1 ∧
      ((PMF.iid (PMF.pure a) n).toOuterMeasure
        (typeClass (wordType (fun _ : Fin n => a)))).toReal = 1 := by
  have heq := constant_word_empirical hn a
  have hzero : InformationTheory.klDiv
      (empiricalPMF hn (wordType (fun _ : Fin n => a))).toMeasure
      (PMF.pure a).toMeasure = 0 :=
    (klDiv_pmf_eq_zero_iff _ _).2 heq
  have hs : (empiricalPMF hn (wordType (fun _ : Fin n => a))).support ⊆
      (PMF.pure a).support := by rw [heq]
  have hself : InformationTheory.klDiv
      (PMF.pure a).toMeasure (PMF.pure a).toMeasure = 0 :=
    (klDiv_pmf_eq_zero_iff _ _).2 rfl
  refine ⟨hzero, ?_, ?_⟩
  · simpa only [heq, entropy_pure, hself, ENNReal.toReal_zero,
      zero_add, mul_zero, Real.exp_zero] using
      iid_apply_of_mem_typeClass hn (wordType (fun _ : Fin n => a))
        (PMF.pure a) hs (mem_typeClass.2 rfl)
  · simpa only [heq, hself, ENNReal.toReal_zero, entropy_pure,
      zero_add, mul_zero, Real.exp_zero, constant_word_class hn a,
      Finset.card_singleton, Nat.cast_one, one_mul] using
      iid_toOuterMeasure_typeClass hn (wordType (fun _ : Fin n => a))
        (PMF.pure a) hs

private theorem singleton_positive_probabilities (hn : 0 < n) :
    ((PMF.iid (PMF.pure ()) n) (fun _ : Fin n => ())).toReal = 1 ∧
      ((PMF.iid (PMF.pure ()) n).toOuterMeasure
        (typeClass (wordType (fun _ : Fin n => ())))).toReal = 1 :=
  (pure_positive_probabilities hn ()).2

private theorem length_one_probabilities (p : PMF A) (a : A)
    (ha : a ∈ p.support) :
    let t := wordType (fun _ : Fin 1 => a)
    InformationTheory.klDiv (empiricalPMF (by decide) t).toMeasure p.toMeasure ≠ ⊤ ∧
      (PMF.iid p 1) (fun _ : Fin 1 => a) = p a ∧
      (PMF.iid p 1).toOuterMeasure (typeClass t) = p a ∧
      ((PMF.iid p 1).toOuterMeasure (typeClass t)).toReal =
        Real.exp (-(InformationTheory.klDiv
          (empiricalPMF (by decide) t).toMeasure p.toMeasure).toReal) := by
  let t := wordType (fun _ : Fin 1 => a)
  have heq : empiricalPMF (by decide) t = PMF.pure a :=
    constant_word_empirical (by decide) a
  have hs : (empiricalPMF (by decide) t).support ⊆ p.support := by
    rw [heq, PMF.support_pure]
    exact Set.singleton_subset_iff.2 ha
  have hword : (PMF.iid p 1) (fun _ : Fin 1 => a) = p a := by
    change (PMF.finiteProduct (fun _ : Fin 1 => p)) (fun _ => a) = p a
    simp only [PMF.finiteProduct_apply, Fin.prod_univ_one]
  have hclass : (PMF.iid p 1).toOuterMeasure (typeClass t) = p a := by
    rw [constant_word_class (by decide) a,
      PMF.toOuterMeasure_apply_finset, Finset.sum_singleton]
    exact hword
  refine ⟨(klDiv_pmf_ne_top_iff_support_subset _ _).2 hs, hword, hclass, ?_⟩
  have hgeneral := iid_toOuterMeasure_typeClass (by decide) t p hs
  have hcard : (typeClass t).card = 1 := by
    rw [constant_word_class (by decide : 0 < (1 : ℕ)) a, Finset.card_singleton]
  change ((PMF.iid p 1).toOuterMeasure (typeClass t)).toReal =
    Real.exp (-(InformationTheory.klDiv
      (empiricalPMF (by decide) t).toMeasure p.toMeasure).toReal)
  simpa only [hcard, heq, entropy_pure, zero_add, Nat.cast_one,
    neg_one_mul, one_mul] using hgeneral

end LeanInfoTheory.Examples.TypeClassProbabilityInterface
