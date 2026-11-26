/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.TypeClassBounds

/-!
# Type-class counting, own-law and entropy-bound consumers

Private consumers of the supplied-index interface and both entropy bounds.
They cover arbitrary counts, independently supplied denominator-witnessed laws,
finite-mass ENNReal recovery, empty and singleton alphabets, pure binary classes,
the binary (2,1) class, and sparse counts (2,2,0). A biased comparison keeps the
law fixed and distinguishes maximizing count-vector probability from class size.
Zero-count symbols remain in the ambient alphabet. All logarithms use nats.
-/

namespace LeanInfoTheory.Examples.TypeClass

open LeanInfoTheory.Shannon
open scoped BigOperators

universe u

private theorem supplied_type_own_law
    {A : Type u} [Fintype A] {n : ℕ}
    (hn : 0 < n) (t : ↥(wordTypes A n))
    (x : Fin n → A) (hx : x ∈ typeClass t) :
    ((PMF.iid (empiricalPMF hn t) n) x).toReal =
        Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)) ∧
      ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t)).toReal =
        ((typeClass t).card : ℝ) *
          ((PMF.iid (empiricalPMF hn t) n) x).toReal := by
  have hword := iid_empiricalPMF_apply_of_mem_typeClass hn t hx
  refine ⟨hword, ?_⟩
  rw [hword]
  exact iid_empiricalPMF_toOuterMeasure_typeClass hn t

private theorem supplied_and_word_type_upper_bounds
    {A : Type u} [Fintype A] {n : ℕ}
    (hn : 0 < n) (t : ↥(wordTypes A n)) (x : Fin n → A) :
    ((typeClass t).card : ℝ) ≤
        Real.exp ((n : ℝ) * entropy (empiricalPMF hn t)) ∧
      ((typeClass (wordType x)).card : ℝ) ≤
        Real.exp ((n : ℝ) * entropy (empiricalPMF hn (wordType x))) :=
  ⟨card_typeClass_le_exp_entropy hn t,
    card_typeClass_le_exp_entropy hn (wordType x)⟩

private theorem supplied_type_entropy_bounds
    {A : Type u} [Fintype A] {n : ℕ}
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    Real.exp ((n : ℝ) * entropy (empiricalPMF hn t)) /
          ((n : ℝ) + 1) ^ Fintype.card A ≤ ((typeClass t).card : ℝ) ∧
      ((typeClass t).card : ℝ) ≤
        Real.exp ((n : ℝ) * entropy (empiricalPMF hn t)) :=
  ⟨exp_entropy_div_pow_le_card_typeClass hn t,
    card_typeClass_le_exp_entropy hn t⟩

private theorem supplied_counts_cardinality
    {A : Type u} [Fintype A] {n : ℕ}
    (c : A → ℕ) (hc : (∑ a, c a) = n) :
    let t : ↥(wordTypes A n) := ⟨c, (mem_wordTypes c).2 hc⟩
    (typeClass t).card = n.factorial / ∏ a, (c a).factorial ∧
      (∏ a, (c a).factorial) * (typeClass t).card = n.factorial := by
  classical
  dsimp only
  constructor
  · rw [card_typeClass_eq_multinomial]
    change Nat.multinomial Finset.univ c = n.factorial / _
    simp only [Nat.multinomial, hc]
  · rw [card_typeClass_eq_multinomial]
    simpa only [hc] using Nat.multinomial_spec Finset.univ c

private theorem zero_length_counting
    {A : Type u} [Fintype A] (t : ↥(wordTypes A 0)) :
    (typeClass t).card = 1 ∧ Nat.multinomial Finset.univ t.val = 1 := by
  classical
  have hzero : t.val = 0 := by
    simpa only [wordTypes_zero, Finset.mem_singleton] using t.property
  have hm : Nat.multinomial Finset.univ t.val = 1 := by
    simp [hzero, Nat.multinomial]
  exact ⟨(card_typeClass_eq_multinomial t).trans hm, hm⟩

private theorem empty_alphabet_zero_counting :
    (typeClass (wordType (Fin.elim0 : Fin 0 → Empty))).card = 1 ∧
      Nat.multinomial Finset.univ (wordType (Fin.elim0 : Fin 0 → Empty)).val = 1 :=
  zero_length_counting _

private theorem no_positive_empty_index
    {n : ℕ} (hn : 0 < n) (t : ↥(wordTypes Empty n)) : False := by
  have hzero : 0 = n := by
    simpa using (mem_wordTypes t.val).1 t.property
  exact (Nat.ne_of_gt hn) hzero.symm

private theorem singleton_alphabet_counting (n : ℕ) (t : ↥(wordTypes Unit n)) :
    (typeClass t).card = 1 ∧ Nat.multinomial Finset.univ t.val = 1 := by
  classical
  have hu : (Finset.univ : Finset Unit) = {()} := by
    ext a
    simp
  have hm : Nat.multinomial Finset.univ t.val = 1 := by
    rw [hu]
    exact Nat.multinomial_singleton () t.val
  exact ⟨(card_typeClass_eq_multinomial t).trans hm, hm⟩

private noncomputable def pureBinaryType (n : ℕ) : ↥(wordTypes Bool n) :=
  ⟨Pi.single false n, (mem_wordTypes _).2 (by simp)⟩

private theorem pure_binary_counts (n : ℕ) :
    (pureBinaryType n).val false = n ∧ (pureBinaryType n).val true = 0 := by
  simp [pureBinaryType]

private theorem pure_binary_counting (n : ℕ) :
    (typeClass (pureBinaryType n)).card = 1 ∧
      Nat.multinomial Finset.univ (pureBinaryType n).val = 1 := by
  classical
  have hm : Nat.multinomial Finset.univ (pureBinaryType n).val = 1 := by
    exact Nat.multinomial_single (s := Finset.univ) (a := false) (n := n)
  exact ⟨(card_typeClass_eq_multinomial _).trans hm, hm⟩

/- The generic callers below use only the supported focused interface. -/
private theorem prescribed_counts_package
    {A : Type u} [Fintype A] {n : ℕ} (hn : 0 < n)
    (c : A → ℕ) (hc : (∑ a, c a) = n) :
    let t : ↥(wordTypes A n) := ⟨c, (mem_wordTypes c).2 hc⟩
    (typeClass t).card = Nat.multinomial Finset.univ c ∧
      Real.exp ((n : ℝ) * entropy (empiricalPMF hn t)) /
          ((n : ℝ) + 1) ^ Fintype.card A ≤ ((typeClass t).card : ℝ) ∧
      ((typeClass t).card : ℝ) ≤ Real.exp ((n : ℝ) * entropy (empiricalPMF hn t)) ∧
      ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t)).toReal =
        ((typeClass t).card : ℝ) *
          Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)) := by
  dsimp only
  exact ⟨card_typeClass_eq_multinomial _, exp_entropy_div_pow_le_card_typeClass hn _,
    card_typeClass_le_exp_entropy hn _, iid_empiricalPMF_toOuterMeasure_typeClass hn _⟩

private theorem independently_supplied_law_package
    {A : Type u} [Fintype A] {n : ℕ} (hn : 0 < n) (q : PMF A)
    (hq : ∃ c : A → ℕ, (∑ a, c a) = n ∧
      ∀ a, q a = (c a : ENNReal) / (n : ENNReal)) :
    ∃ t : ↥(wordTypes A n), empiricalPMF hn t = q ∧
      (typeClass t).card = Nat.multinomial Finset.univ t.val ∧
      Real.exp ((n : ℝ) * entropy q) / ((n : ℝ) + 1) ^ Fintype.card A ≤
          ((typeClass t).card : ℝ) ∧
      ((typeClass t).card : ℝ) ≤ Real.exp ((n : ℝ) * entropy q) ∧
      ((PMF.iid q n).toOuterMeasure (typeClass t)).toReal =
        ((typeClass t).card : ℝ) * Real.exp (-(n : ℝ) * entropy q) := by
  let witnessed := (⟨q, hq⟩ : {p : PMF A // ∃ c : A → ℕ, (∑ a, c a) = n ∧
    ∀ a, p a = (c a : ENNReal) / (n : ENNReal)})
  let t := (wordTypeEquivPMF hn).symm witnessed
  have ht : empiricalPMF hn t = q := by
    have h := congrArg Subtype.val ((wordTypeEquivPMF hn).apply_symm_apply witnessed)
    simpa only [wordTypeEquivPMF_apply] using h
  refine ⟨t, ht, card_typeClass_eq_multinomial t, ?_, ?_, ?_⟩
  · simpa only [ht] using exp_entropy_div_pow_le_card_typeClass hn t
  · simpa only [ht] using card_typeClass_le_exp_entropy hn t
  · simpa only [ht] using iid_empiricalPMF_toOuterMeasure_typeClass hn t

private theorem own_law_event_ennreal
    {A : Type u} [Fintype A] {n : ℕ}
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    (PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t) =
      ENNReal.ofReal (((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t))) := by
  have hfinite :
      (PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t) ≠ ⊤ := by
    rw [PMF.toOuterMeasure_apply_finset]
    exact ENNReal.sum_ne_top.2
      (fun x _ => (PMF.iid (empiricalPMF hn t) n).apply_ne_top x)
  have hnonneg : 0 ≤ ((typeClass t).card : ℝ) *
      Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)) :=
    mul_nonneg (Nat.cast_nonneg _) (Real.exp_pos _).le
  apply (ENNReal.toReal_eq_toReal_iff' hfinite ENNReal.ofReal_ne_top).1
  rw [ENNReal.toReal_ofReal hnonneg]
  exact iid_empiricalPMF_toOuterMeasure_typeClass hn t


/- A pure class retains the unused Boolean symbol and the ambient exponent two. -/
private theorem pure_binary_word_mem (n : ℕ) :
    (fun _ : Fin n => false) ∈ typeClass (pureBinaryType n) := by
  apply mem_typeClass.2
  apply Subtype.ext
  funext a
  cases a <;> simp [wordType, symbolCount, pureBinaryType]

private theorem pure_binary_class (n : ℕ) :
    typeClass (pureBinaryType n) = {fun _ : Fin n => false} := by
  classical
  symm
  apply Finset.eq_of_subset_of_card_le
  · exact Finset.singleton_subset_iff.2 (pure_binary_word_mem n)
  · rw [(pure_binary_counting n).1]
    simp

private theorem pure_binary_law {n : ℕ} (hn : 0 < n) :
    empiricalPMF hn (pureBinaryType n) = PMF.pure false := by
  ext a
  cases a
  · rw [empiricalPMF_apply]
    simp only [pureBinaryType, Pi.single_eq_same, PMF.pure_apply_self]
    exact ENNReal.div_self (by exact_mod_cast (Nat.ne_of_gt hn))
      (ENNReal.natCast_ne_top n)
  · rw [empiricalPMF_apply]
    simp [pureBinaryType, PMF.pure_apply]

private theorem pure_binary_entropy {n : ℕ} (hn : 0 < n) :
    entropy (empiricalPMF hn (pureBinaryType n)) = 0 := by
  rw [pure_binary_law hn, entropy_pure]

private theorem pure_binary_masses {n : ℕ} (hn : 0 < n) :
    ((PMF.iid (empiricalPMF hn (pureBinaryType n)) n) (fun _ => false)).toReal = 1 ∧
      ((PMF.iid (empiricalPMF hn (pureBinaryType n)) n).toOuterMeasure
        (typeClass (pureBinaryType n))).toReal = 1 := by
  constructor
  · simpa only [pure_binary_entropy hn, mul_zero, Real.exp_zero] using
      iid_empiricalPMF_apply_of_mem_typeClass hn (pureBinaryType n) (pure_binary_word_mem n)
  · simpa only [pure_binary_entropy hn, mul_zero, Real.exp_zero,
      (pure_binary_counting n).1, Nat.cast_one, one_mul] using
      iid_empiricalPMF_toOuterMeasure_typeClass hn (pureBinaryType n)

private theorem pure_binary_bounds {n : ℕ} (hn : 0 < n) :
    (1 : ℝ) / ((n : ℝ) + 1) ^ 2 ≤ 1 ∧
      ((typeClass (pureBinaryType n)).card : ℝ) =
        Real.exp ((n : ℝ) * entropy (empiricalPMF hn (pureBinaryType n))) := by
  constructor
  · simpa only [pure_binary_entropy hn, mul_zero, Real.exp_zero,
      Fintype.card_bool, (pure_binary_counting n).1, Nat.cast_one] using
      exp_entropy_div_pow_le_card_typeClass hn (pureBinaryType n)
  · apply le_antisymm (card_typeClass_le_exp_entropy hn (pureBinaryType n))
    simp only [pure_binary_entropy hn, mul_zero, Real.exp_zero,
      (pure_binary_counting n).1, Nat.cast_one, le_refl]


namespace Binary

private def counts (a : Bool) : ℕ := if a then 1 else 2
private def word001 : Fin 3 → Bool := ![false, false, true]
private def word010 : Fin 3 → Bool := ![false, true, false]
private def word100 : Fin 3 → Bool := ![true, false, false]

private noncomputable def index : ↥(wordTypes Bool 3) :=
  ⟨counts, (mem_wordTypes counts).2 (by decide)⟩

private noncomputable def law : PMF Bool := empiricalPMF (by decide) index

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

-- Enumerate the eight possible words independently of the counting theorem.
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

private theorem multinomial_card :
    (typeClass index).card = Nat.multinomial Finset.univ index.val ∧
      Nat.multinomial Finset.univ index.val = 3 := by
  refine ⟨card_typeClass_eq_multinomial index, ?_⟩
  norm_num [Nat.multinomial, index, counts, Fintype.sum_bool, Fintype.prod_bool]

private theorem word001_mem : word001 ∈ typeClass index := by
  rw [class_eq]
  exact Finset.mem_insert_self _ _

private theorem word_mass : ((PMF.iid law 3) word001).toReal = 4 / 27 := by
  change ((PMF.finiteProduct (fun _ : Fin 3 => law)) word001).toReal = 4 / 27
  simp only [PMF.finiteProduct_apply, ENNReal.toReal_prod,
    law, empiricalPMF_apply, ENNReal.toReal_div, ENNReal.toReal_natCast]
  norm_num [Fin.prod_univ_succ, index, counts, word001]

private theorem class_mass :
    ((PMF.iid law 3).toOuterMeasure (typeClass index)).toReal = 4 / 9 := by
  have hword := iid_empiricalPMF_apply_of_mem_typeClass (by decide) index word001_mem
  have hclass := iid_empiricalPMF_toOuterMeasure_typeClass (by decide) index
  change ((PMF.iid law 3) word001).toReal =
    Real.exp (-(3 : ℝ) * entropy law) at hword
  change ((PMF.iid law 3).toOuterMeasure (typeClass index)).toReal =
    ((typeClass index).card : ℝ) * Real.exp (-(3 : ℝ) * entropy law) at hclass
  rw [← hword, word_mass, class_card] at hclass
  exact hclass.trans (by norm_num)

private theorem exp_entropy : Real.exp ((3 : ℝ) * entropy law) = 27 / 4 := by
  have hword := iid_empiricalPMF_apply_of_mem_typeClass (by decide) index word001_mem
  change ((PMF.iid law 3) word001).toReal =
    Real.exp (-(3 : ℝ) * entropy law) at hword
  rw [word_mass] at hword
  have h := congrArg (fun z : ℝ => z⁻¹) hword.symm
  norm_num only [neg_mul, Real.exp_neg, inv_inv] at h
  exact h

private theorem entropy_bounds :
    Real.exp ((3 : ℝ) * entropy law) / 4 ^ 2 ≤ 3 ∧
      (3 : ℝ) ≤ Real.exp ((3 : ℝ) * entropy law) := by
  constructor
  · simpa only [law, class_card, Fintype.card_bool, Nat.cast_ofNat,
      show (3 : ℝ) + 1 = 4 by norm_num] using
      exp_entropy_div_pow_le_card_typeClass (by decide) index
  · simpa [law, class_card] using card_typeClass_le_exp_entropy (by decide) index

private theorem numerical_entropy_bounds : (27 / 64 : ℝ) ≤ 3 ∧ (3 : ℝ) ≤ 27 / 4 := by
  have h := entropy_bounds
  rw [exp_entropy] at h
  norm_num at h ⊢

end Binary

namespace Biased

private def pair (zeros ones : ℕ) (a : Bool) : ℕ := if a then ones else zeros
private def word0001 : Fin 4 → Bool := ![false, false, false, true]
private def word0011 : Fin 4 → Bool := ![false, false, true, true]
private def word0101 : Fin 4 → Bool := ![false, true, false, true]
private def word0110 : Fin 4 → Bool := ![false, true, true, false]
private def word1001 : Fin 4 → Bool := ![true, false, false, true]
private def word1010 : Fin 4 → Bool := ![true, false, true, false]
private def word1100 : Fin 4 → Bool := ![true, true, false, false]

private noncomputable def target : ↥(wordTypes Bool 4) :=
  ⟨pair 3 1, (mem_wordTypes _).2 (by decide)⟩

private noncomputable def competitor : ↥(wordTypes Bool 4) :=
  ⟨pair 2 2, (mem_wordTypes _).2 (by decide)⟩

-- The same target law is used for both events.
private noncomputable def law : PMF Bool := empiricalPMF (by decide) target

private theorem law_atoms : law false = 3 / 4 ∧ law true = 1 / 4 := by
  constructor <;> rw [law, empiricalPMF_apply] <;> norm_num [target, pair]

private theorem univ_four : (Finset.univ : Finset (Fin 4)) = {0, 1, 2, 3} := by decide

private theorem target_card : (typeClass target).card = 4 := by
  rw [card_typeClass_eq_multinomial]
  norm_num [Nat.multinomial, target, pair, Fintype.sum_bool, Fintype.prod_bool]

private theorem competitor_card : (typeClass competitor).card = 6 := by
  rw [card_typeClass_eq_multinomial]
  norm_num [Nat.multinomial, competitor, pair, Fintype.sum_bool, Fintype.prod_bool]

private theorem target_word_mem : word0001 ∈ typeClass target := by
  rw [mem_typeClass]
  apply Subtype.ext
  funext a
  change symbolCount word0001 a = pair 3 1 a
  cases a <;>
    norm_num [symbolCount, univ_four, word0001, pair] <;> decide

private noncomputable def competitorWords : Finset (Fin 4 → Bool) := by
  classical
  exact {word0011, word0101, word0110, word1001, word1010, word1100}

private theorem competitor_words_mem : competitorWords ⊆ typeClass competitor := by
  classical
  intro x hx
  simp only [competitorWords, Finset.mem_insert, Finset.mem_singleton] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl <;>
    rw [mem_typeClass] <;> apply Subtype.ext <;> funext a
  all_goals change symbolCount _ a = pair 2 2 a
  all_goals cases a <;>
    norm_num [symbolCount, univ_four, pair,
      word0011, word0101, word0110, word1001, word1010, word1100] <;> decide

private theorem competitor_words_card : competitorWords.card = 6 := by
  classical
  norm_num [competitorWords, word0011, word0101, word0110, word1001, word1010,
    word1100, funext_iff, Fin.forall_fin_succ]

private theorem competitor_class : typeClass competitor = competitorWords := by
  apply (Finset.eq_of_subset_of_card_le competitor_words_mem ?_).symm
  rw [competitor_card, competitor_words_card]

private theorem target_word_mass : ((PMF.iid law 4) word0001).toReal = 27 / 256 := by
  change ((PMF.finiteProduct (fun _ : Fin 4 => law)) word0001).toReal = 27 / 256
  simp only [PMF.finiteProduct_apply, ENNReal.toReal_prod,
    law, empiricalPMF_apply, ENNReal.toReal_div, ENNReal.toReal_natCast]
  norm_num [Fin.prod_univ_succ, target, pair, word0001]

private theorem target_mass :
    ((PMF.iid law 4).toOuterMeasure (typeClass target)).toReal = 27 / 64 := by
  have hword := iid_empiricalPMF_apply_of_mem_typeClass (by decide) target target_word_mem
  have hclass := iid_empiricalPMF_toOuterMeasure_typeClass (by decide) target
  change ((PMF.iid law 4) word0001).toReal =
    Real.exp (-(4 : ℝ) * entropy law) at hword
  change ((PMF.iid law 4).toOuterMeasure (typeClass target)).toReal =
    ((typeClass target).card : ℝ) * Real.exp (-(4 : ℝ) * entropy law) at hclass
  rw [← hword, target_word_mass, target_card] at hclass
  exact hclass.trans (by norm_num)

private theorem competitor_word_mass (x : Fin 4 → Bool) (hx : x ∈ competitorWords) :
    ((PMF.iid law 4) x).toReal = 9 / 256 := by
  classical
  change ((PMF.finiteProduct (fun _ : Fin 4 => law)) x).toReal = 9 / 256
  simp only [competitorWords, Finset.mem_insert, Finset.mem_singleton] at hx
  rcases hx with rfl | rfl | rfl | rfl | rfl | rfl
  all_goals simp only [PMF.finiteProduct_apply, ENNReal.toReal_prod,
    law, empiricalPMF_apply, ENNReal.toReal_div, ENNReal.toReal_natCast]
  all_goals norm_num [Fin.prod_univ_succ, target, pair,
    word0011, word0101, word0110, word1001, word1010, word1100]

-- This computes the competing event directly: six finite iid products,
-- all under the target law. No general-prior or private mode theorem is used.
private theorem competitor_mass :
    ((PMF.iid law 4).toOuterMeasure (typeClass competitor)).toReal = 27 / 128 := by
  classical
  rw [PMF.toOuterMeasure_apply_finset,
    ENNReal.toReal_sum (fun x _ => (PMF.iid law 4).apply_ne_top x), competitor_class]
  calc
    (∑ x ∈ competitorWords, ((PMF.iid law 4) x).toReal) =
        ∑ _x ∈ competitorWords, (9 / 256 : ℝ) :=
      Finset.sum_congr rfl (fun x hx => competitor_word_mass x hx)
    _ = 27 / 128 := by norm_num [competitor_words_card]

private theorem opposite_orderings :
    (typeClass target).card < (typeClass competitor).card ∧
      ((PMF.iid law 4).toOuterMeasure (typeClass competitor)).toReal <
        ((PMF.iid law 4).toOuterMeasure (typeClass target)).toReal := by
  rw [target_card, competitor_card, target_mass, competitor_mass]
  norm_num

end Biased

namespace Sparse

private def counts : Fin 3 → ℕ := ![2, 2, 0]
private def word : Fin 4 → Fin 3 := ![0, 1, 0, 1]

private noncomputable def index : ↥(wordTypes (Fin 3) 4) :=
  ⟨counts, (mem_wordTypes _).2 (by norm_num [counts, Fin.sum_univ_succ])⟩

private theorem word_mem : word ∈ typeClass index := by
  apply mem_typeClass.2
  apply Subtype.ext
  funext a
  change symbolCount word a = counts a
  classical
  have hu : (Finset.univ : Finset (Fin 4)) = {0, 1, 2, 3} := by decide
  fin_cases a <;> norm_num [symbolCount, hu, word, counts] <;> decide

private theorem cardinality : (typeClass index).card = 6 := by
  rw [card_typeClass_eq_multinomial]
  norm_num [index, counts, Nat.multinomial, Fin.sum_univ_succ, Fin.prod_univ_succ]

private theorem support : (empiricalPMF (by decide : 0 < (4 : ℕ)) index).support =
    ({0, 1} : Set (Fin 3)) := by
  ext a
  rw [mem_support_empiricalPMF_iff]
  fin_cases a <;> norm_num [index, counts]

private theorem word_mass :
    ((PMF.iid (empiricalPMF (by decide : 0 < (4 : ℕ)) index) 4) word).toReal =
      (1 / 16 : ℝ) := by
  change ((PMF.finiteProduct (fun _ : Fin 4 =>
    empiricalPMF (by decide : 0 < (4 : ℕ)) index)) word).toReal = (1 / 16 : ℝ)
  simp only [PMF.finiteProduct_apply, ENNReal.toReal_prod]
  norm_num [Fin.prod_univ_succ, word, empiricalPMF_apply, index, counts,
    ENNReal.toReal_div]

private theorem negative_entropy_exponential :
    Real.exp (-(4 : ℝ) * entropy (empiricalPMF (by decide : 0 < (4 : ℕ)) index)) =
      (1 / 16 : ℝ) :=
  (iid_empiricalPMF_apply_of_mem_typeClass (by decide) index word_mem).symm.trans word_mass

private theorem entropy_exponential :
    Real.exp ((4 : ℝ) * entropy (empiricalPMF (by decide : 0 < (4 : ℕ)) index)) = 16 := by
  have h := congrArg Inv.inv negative_entropy_exponential
  simpa only [neg_mul, Real.exp_neg, inv_inv, one_div] using h

private theorem class_mass :
    ((PMF.iid (empiricalPMF (by decide : 0 < (4 : ℕ)) index) 4).toOuterMeasure
      (typeClass index)).toReal = (3 / 8 : ℝ) := by
  rw [iid_empiricalPMF_toOuterMeasure_typeClass, cardinality]
  norm_num only [Nat.cast_ofNat]
  rw [negative_entropy_exponential]
  norm_num

private theorem entropy_bounds :
    (16 / 125 : ℝ) ≤ ((typeClass index).card : ℝ) ∧
      ((typeClass index).card : ℝ) ≤ 16 := by
  constructor
  · have h := exp_entropy_div_pow_le_card_typeClass (by decide : 0 < (4 : ℕ)) index
    norm_num [entropy_exponential] at h
    exact h
  · simpa only [Nat.cast_ofNat, entropy_exponential] using
      card_typeClass_le_exp_entropy (by decide : 0 < (4 : ℕ)) index

private theorem numerical_bounds : (16 / 125 : ℝ) ≤ 6 ∧ (6 : ℝ) ≤ 16 := by
  simpa only [cardinality, Nat.cast_ofNat] using entropy_bounds

private def competitorCounts : Fin 3 → ℕ := ![2, 1, 1]

private noncomputable def competitor : ↥(wordTypes (Fin 3) 4) :=
  ⟨competitorCounts, (mem_wordTypes _).2
    (by norm_num [competitorCounts, Fin.sum_univ_succ])⟩

-- The law stays fixed to counts (2,2,0), while the competing class uses symbol 2.
private theorem unsupported_competitor_mass :
    (PMF.iid (empiricalPMF (by decide : 0 < (4 : ℕ)) index) 4).toOuterMeasure
      (typeClass competitor) = 0 := by
  classical
  rw [PMF.toOuterMeasure_apply_finset]
  apply Finset.sum_eq_zero
  intro x hx
  have hc : symbolCount x 2 = 1 := by
    have h := congrFun (congrArg Subtype.val (mem_typeClass.1 hx)) 2
    simpa [wordType, competitor, competitorCounts] using h
  have hpos : 0 < symbolCount x 2 := by omega
  rw [symbolCount] at hpos
  obtain ⟨i, hi⟩ := Finset.card_pos.1 hpos
  have hxi : x i = 2 := by
    simpa only [Finset.mem_filter, Finset.mem_univ, true_and] using hi
  change (PMF.finiteProduct (fun _ : Fin 4 =>
    empiricalPMF (by decide : 0 < (4 : ℕ)) index)) x = 0
  simp only [PMF.finiteProduct_apply]
  apply Finset.prod_eq_zero (Finset.mem_univ i)
  rw [hxi, empiricalPMF_apply]
  norm_num [index, counts]
  decide

end Sparse


end LeanInfoTheory.Examples.TypeClass
