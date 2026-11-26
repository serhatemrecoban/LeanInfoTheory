/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.EmpiricalPMF
import LeanInfoTheory.Probability.Iid

/-!
# Word types and empirical laws

Permanent consumers of the count-indexed class interface in CT91 section 12.1.
Binary and sparse words check counts, actual support, exact denominators and
position permutations. Empty and singleton alphabets exercise the all-length
count interface without assigning an empirical law to an empty word.

Private generic callers recover counts from membership, partition arbitrary
word weights, and use one class finset for cardinality and iid event mass.
Exact class sizes, entropy estimates and iid type-probability formulas belong
to later chunks.
-/

namespace LeanInfoTheory.Examples.WordType

open LeanInfoTheory.Shannon
open scoped BigOperators ENNReal

universe u v

namespace Binary

private def pair (zeros ones : ℕ) (a : Bool) : ℕ := if a then ones else zeros
private def word : Fin 3 → Bool := ![false, false, true]
private def other : Fin 3 → Bool := ![false, true, true]

private theorem counts (a : Bool) : symbolCount word a = pair 2 1 a := by
  classical
  have hu : (Finset.univ : Finset (Fin 3)) = {0, 1, 2} := by decide
  cases a <;> norm_num [symbolCount, hu, word, pair] <;> decide

private theorem other_counts (a : Bool) : symbolCount other a = pair 1 2 a := by
  classical
  have hu : (Finset.univ : Finset (Fin 3)) = {0, 1, 2} := by decide
  cases a <;> norm_num [symbolCount, hu, other, pair] <;> decide

private noncomputable def index : ↥(wordTypes Bool 3) :=
  ⟨pair 2 1, (mem_wordTypes _).2 (by decide)⟩

private theorem word_type : wordType word = index :=
  Subtype.ext (funext counts)

example : word ∈ typeClass index := mem_typeClass.2 word_type

example : empiricalPMF (by decide) index false = (2 / 3 : ℝ≥0∞) ∧
    empiricalPMF (by decide) index true = (1 / 3 : ℝ≥0∞) := by
  constructor <;> rw [empiricalPMF_apply] <;> norm_num [index, pair]

example : ((wordTypeEquivPMF (A := Bool) (n := 3) (by decide)).symm
    ((wordTypeEquivPMF (by decide)) index)).val = pair 2 1 :=
  congrArg Subtype.val ((wordTypeEquivPMF (by decide)).symm_apply_apply index)

-- This cycle reads old position e i at new position i.
private def cycle : Equiv.Perm (Fin 3) :=
  (Equiv.swap 1 2).trans (Equiv.swap 0 1)

example : cycle 0 = 1 ∧ cycle 1 = 2 ∧ cycle 2 = 0 := by decide

example : word ∘ cycle = ![false, true, false] := by decide

example : word ∘ cycle.symm = ![true, false, false] := by decide

example : word ∘ cycle ∈ typeClass index := by
  rw [mem_typeClass, wordType_comp_perm]
  exact word_type

example : empiricalPMF (by decide) (wordType (word ∘ cycle)) =
    empiricalPMF (by decide) (wordType word) := by
  rw [wordType_comp_perm]

example : other ∉ typeClass index := by
  intro h
  have hcount := congrFun (congrArg Subtype.val (mem_typeClass.1 h)) false
  change symbolCount other false = pair 2 1 false at hcount
  rw [other_counts] at hcount
  norm_num [pair] at hcount

private theorem word_support : (empiricalPMF (by decide) (wordType word)).support =
    Set.univ := by
  ext a
  simp only [mem_support_empiricalPMF_iff, Set.mem_univ, iff_true]
  change 0 < symbolCount word a
  rw [counts]
  cases a <;> decide

private theorem other_support : (empiricalPMF (by decide) (wordType other)).support =
    Set.univ := by
  ext a
  simp only [mem_support_empiricalPMF_iff, Set.mem_univ, iff_true]
  change 0 < symbolCount other a
  rw [other_counts]
  cases a <;> decide

example : (empiricalPMF (by decide) (wordType word)).support =
    (empiricalPMF (by decide) (wordType other)).support := by
  rw [word_support, other_support]

private theorem types : wordTypes Bool 3 =
    {pair 3 0, pair 2 1, pair 1 2, pair 0 3} := by
  classical
  ext c
  rw [mem_wordTypes]
  simp only [Fintype.sum_bool, Finset.mem_insert, Finset.mem_singleton]
  constructor
  · intro h
    have choices : (c false = 3 ∧ c true = 0) ∨ (c false = 2 ∧ c true = 1) ∨
        (c false = 1 ∧ c true = 2) ∨ (c false = 0 ∧ c true = 3) := by omega
    rcases choices with h | h | h | h
    · exact Or.inl (funext fun a => by cases a <;> simp [pair, h.1, h.2])
    · exact Or.inr (Or.inl (funext fun a => by cases a <;> simp [pair, h.1, h.2]))
    · exact Or.inr (Or.inr (Or.inl (funext fun a => by cases a <;> simp [pair, h.1, h.2])))
    · exact Or.inr (Or.inr (Or.inr (funext fun a => by cases a <;> simp [pair, h.1, h.2])))
  · rintro (rfl | rfl | rfl | rfl) <;> decide

private theorem type_count : (wordTypes Bool 3).card = 4 := by
  classical
  rw [types]
  norm_num [pair, funext_iff]

example : (4 : ℕ) ≤ 4 ^ 2 := by
  simpa only [type_count, Fintype.card_bool, Nat.reduceAdd] using card_wordTypes_le Bool 3

example : (wordTypes Bool 3).card = 4 ∧ (wordTypes Bool 3).card ≤ 16 :=
  ⟨type_count, by simpa using card_wordTypes_le Bool 3⟩

end Binary

namespace Sparse

private def word : Fin 4 → Fin 3 := ![0, 1, 0, 1]

private def counts : Fin 3 → ℕ := ![2, 2, 0]

private theorem counts_sum : (∑ a, counts a) = 4 := by
  norm_num [counts, Fin.sum_univ_succ]

private theorem count_word (a : Fin 3) : symbolCount word a = counts a := by
  classical
  have hu : (Finset.univ : Finset (Fin 4)) = {0, 1, 2, 3} := by decide
  fin_cases a <;> norm_num [symbolCount, hu, word, counts] <;> decide

private noncomputable def index : ↥(wordTypes (Fin 3) 4) :=
  ⟨counts, (mem_wordTypes counts).2 counts_sum⟩

private theorem word_type : wordType word = index :=
  Subtype.ext (funext count_word)

example : word ∈ typeClass index := mem_typeClass.2 word_type

-- The mass table is supplied independently of the empirical construction.
private noncomputable def mass : Fin 3 → ℝ := ![1 / 2, 1 / 2, 0]

private theorem mass_nonneg (a : Fin 3) : 0 ≤ mass a := by
  fin_cases a <;> norm_num [mass]

private noncomputable def law : PMF (Fin 3) :=
  PMF.ofFintype (fun a => ENNReal.ofReal (mass a)) (by
    rw [← ENNReal.ofReal_sum_of_nonneg (fun a _ => mass_nonneg a)]
    norm_num [mass, Fin.sum_univ_succ])

private theorem law_mass (a : Fin 3) : law a = ![1 / 2, 1 / 2, 0] a := by
  fin_cases a <;> norm_num [law, mass, ENNReal.ofReal_div_of_pos]

private theorem denominator_four (a : Fin 3) :
    law a = (counts a : ℝ≥0∞) / (4 : ℝ≥0∞) := by
  calc
    law a = ENNReal.ofReal ((counts a : ℝ) / 4) := by
      change ENNReal.ofReal (mass a) = _
      congr 1
      fin_cases a <;> norm_num [mass, counts]
    _ = (counts a : ℝ≥0∞) / 4 := by
      rw [ENNReal.ofReal_div_of_pos (by norm_num)]
      norm_num

private noncomputable def witnessedLaw :
    {q : PMF (Fin 3) // ∃ c : Fin 3 → ℕ, (∑ a, c a) = 4 ∧
      ∀ a, q a = (c a : ℝ≥0∞) / (4 : ℝ≥0∞)} :=
  ⟨law, counts, counts_sum, denominator_four⟩

private theorem empirical_law : empiricalPMF (by decide : 0 < (4 : ℕ)) index = law := by
  ext a
  exact (empiricalPMF_apply _ _ a).trans (denominator_four a).symm

example : empiricalPMF (by decide : 0 < (4 : ℕ)) (wordType word) = law := by
  rw [word_type, empirical_law]

private theorem equiv_law :
    wordTypeEquivPMF (by decide : 0 < (4 : ℕ)) index = witnessedLaw := by
  apply Subtype.ext
  rw [wordTypeEquivPMF_apply]
  exact empirical_law

private theorem recover_counts :
    ((wordTypeEquivPMF (by decide : 0 < (4 : ℕ))).symm witnessedLaw).val = counts := by
  rw [← equiv_law, Equiv.symm_apply_apply]
  rfl

example :
    ((wordTypeEquivPMF (by decide : 0 < (4 : ℕ))).symm witnessedLaw).val = ![2, 2, 0] :=
  recover_counts

private theorem support_law : law.support = {0, 1} := by
  ext a
  rw [PMF.mem_support_iff, law_mass]
  fin_cases a <;> norm_num

example : (empiricalPMF (by decide : 0 < (4 : ℕ)) index).support = {0, 1} := by
  rw [empirical_law, support_law]

example : law.supportFinset = {0, 1} := by
  ext a
  rw [PMF.mem_supportFinset, support_law]
  simp

example (x : Fin 4 → Fin 3) (hx : ∃ i, x i = 2) : x ∉ typeClass index := by
  classical
  intro hmem
  have ht := mem_typeClass.1 hmem
  have hz : symbolCount x (2 : Fin 3) = 0 :=
    congrFun (congrArg Subtype.val ht) 2
  obtain ⟨i, hi⟩ := hx
  have hp : 0 < symbolCount x (2 : Fin 3) := by
    unfold symbolCount
    apply Finset.card_pos.mpr
    exact ⟨i, by simpa using hi⟩
  omega

end Sparse

namespace Fair

private noncomputable def law : PMF Bool :=
  PMF.ofFintype (fun _ => ENNReal.ofReal (1 / 2 : ℝ)) (by
    rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
    norm_num)

private theorem law_mass (b : Bool) : law b = 1 / 2 := by
  rw [law, PMF.ofFintype_apply, ENNReal.ofReal_div_of_pos (by norm_num)]
  norm_num

example (h₃ : 0 < (3 : ℕ)) :
    ¬ ∃ t : ↥(wordTypes Bool 3), empiricalPMF h₃ t = law := by
  rintro ⟨t, ht⟩
  have hmass : (t.val false : ℝ≥0∞) / 3 = 1 / 2 := by
    simpa only [empiricalPMF_apply, law_mass, Nat.cast_ofNat] using
      congrArg (fun p : PMF Bool => p false) ht
  have hreal : (t.val false : ℝ) / 3 = 1 / 2 := by
    simpa only [ENNReal.toReal_div, ENNReal.toReal_natCast,
      ENNReal.toReal_one, ENNReal.toReal_ofNat] using congrArg ENNReal.toReal hmass
  have hreal_count : (2 : ℝ) * t.val false = 3 := by linarith
  have hnat : 2 * t.val false = 3 := by exact_mod_cast hreal_count
  omega

end Fair

namespace BoundaryAndPartition


private theorem mem_typeClass_iff_counts {A : Type u} [Fintype A] {n : ℕ}
    (x : Fin n → A) (t : ↥(wordTypes A n)) :
    x ∈ typeClass t ↔ ∀ a, symbolCount x a = t.val a := by
  rw [mem_typeClass]
  constructor
  · intro h a
    exact congrArg (fun s : ↥(wordTypes A n) => s.val a) h
  · intro h
    exact Subtype.ext (funext h)

private theorem sum_typeClasses {A : Type u} [Fintype A] {n : ℕ}
    {M : Type v} [AddCommMonoid M] (f : (Fin n → A) → M) :
    (∑ t : ↥(wordTypes A n), ∑ x ∈ typeClass t, f x) = ∑ x : Fin n → A, f x := by
  classical
  have hclass (t : ↥(wordTypes A n)) :
      typeClass t = Finset.univ.filter (fun x : Fin n → A => wordType x = t) := by
    ext x
    simp only [mem_typeClass, Finset.mem_filter, Finset.mem_univ, true_and]
  simp_rw [hclass]
  exact Finset.sum_fiberwise Finset.univ wordType f

private theorem counts_zero {A : Type u} (x : Fin 0 → A) : symbolCount x = 0 := by
  funext a
  exact symbolCount_zero x a

private theorem class_zero {A : Type u} [Fintype A] (t : ↥(wordTypes A 0)) :
    typeClass t = {(Fin.elim0 : Fin 0 → A)} := by
  classical
  have hzero : t.val = 0 := by
    simpa only [wordTypes_zero, Finset.mem_singleton] using t.property
  ext x
  rw [Finset.mem_singleton]
  constructor
  · intro _
    funext i
    exact Fin.elim0 i
  · intro _
    apply (mem_typeClass_iff_counts x t).2
    intro a
    simpa [hzero] using symbolCount_zero x a

private theorem empty_class :
    typeClass (wordType (Fin.elim0 : Fin 0 → Empty)) = {(Fin.elim0 : Fin 0 → Empty)} :=
  class_zero _

private theorem unique_empty_word :
    ∃! x : Fin 0 → Empty, x ∈ typeClass (wordType (Fin.elim0 : Fin 0 → Empty)) := by
  rw [empty_class]
  exact ⟨Fin.elim0, Finset.mem_singleton_self _, fun _ h => Finset.mem_singleton.1 h⟩

private theorem no_positive_empty_type (n : ℕ) (hn : 0 < n) : wordTypes Empty n = ∅ := by
  apply Finset.eq_empty_iff_forall_notMem.2
  intro c hc
  have hzero : 0 = n := by simpa using (mem_wordTypes c).1 hc
  exact (Nat.ne_of_gt hn) hzero.symm

private theorem singleton_counts (n : ℕ) (t : ↥(wordTypes Unit n)) : t.val = fun _ => n := by
  have htotal : t.val () = n := by simpa using (mem_wordTypes t.val).1 t.property
  funext a
  cases a
  exact htotal

private theorem unique_singleton_type (n : ℕ) (s t : ↥(wordTypes Unit n)) : s = t := by
  apply Subtype.ext
  rw [singleton_counts n s, singleton_counts n t]


example (n : ℕ) : ∃! t : ↥(wordTypes Unit n), t.val () = n := by
  refine ⟨wordType (fun _ => ()), ?_, ?_⟩
  · simpa using congrFun (singleton_counts n (wordType (fun _ => ()))) ()
  · intro t _
    exact unique_singleton_type n t _

end BoundaryAndPartition

namespace SharedClass


private noncomputable def classSizeAndMass {A : Type u} [Fintype A] {n : ℕ}
    (p : PMF A) (t : ↥(wordTypes A n)) : ℕ × ENNReal :=
  ((typeClass t).card, (PMF.iid p n).toOuterMeasure (typeClass t))

example {A : Type u} [Fintype A] {n : ℕ} (p : PMF A) (t : ↥(wordTypes A n)) :
    (classSizeAndMass p t).1 = (typeClass t).card ∧
    (classSizeAndMass p t).2 = (PMF.iid p n).toOuterMeasure (typeClass t) := ⟨rfl, rfl⟩

example {A : Type u} [Fintype A] {n : ℕ} (hn : 0 < n)
    (x : Fin n → A) (t : ↥(wordTypes A n)) :
    x ∈ typeClass t ↔ empiricalPMF hn (wordType x) = empiricalPMF hn t :=
  mem_typeClass_iff_empiricalPMF_eq hn


end SharedClass

end LeanInfoTheory.Examples.WordType
