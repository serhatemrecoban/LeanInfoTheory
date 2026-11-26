/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.WordType
import LeanInfoTheory.Probability.Finite

/-!
# Empirical laws of finite words

At positive length, an admissible count vector determines a probability law
on the original alphabet by dividing each count by the length. Its support
consists of exactly the labels with positive counts.
The count indices are equivalent to laws carrying an exact denominator
witness, and empirical equality characterizes the original type class.
-/

namespace LeanInfoTheory.Shannon

open scoped BigOperators ENNReal

universe u

variable {A : Type u} [Fintype A] {n : ℕ}

private theorem tsum_typeCounts (t : ↥(wordTypes A n)) :
    (∑' a, (t.val a : ℝ≥0∞)) = n := by
  rw [tsum_fintype, ← Nat.cast_sum, (mem_wordTypes t.val).1 t.property]

/-- The empirical law of an admissible count vector of positive length. -/
noncomputable def empiricalPMF (hn : 0 < n) (t : ↥(wordTypes A n)) : PMF A :=
  PMF.normalize (fun a => (t.val a : ℝ≥0∞))
    (by rw [tsum_typeCounts]; exact_mod_cast (Nat.ne_of_gt hn))
    (by rw [tsum_typeCounts]; exact ENNReal.natCast_ne_top n)

/-- Each empirical atom is its labeled count divided by the positive word length. -/
theorem empiricalPMF_apply (hn : 0 < n) (t : ↥(wordTypes A n)) (a : A) :
    empiricalPMF hn t a = (t.val a : ℝ≥0∞) / (n : ℝ≥0∞) := by
  simp only [empiricalPMF, PMF.normalize_apply, tsum_typeCounts, div_eq_mul_inv]

/-- A symbol belongs to empirical support exactly when its count is positive. -/
theorem mem_support_empiricalPMF_iff (hn : 0 < n) (t : ↥(wordTypes A n)) (a : A) :
    a ∈ (empiricalPMF hn t).support ↔ 0 < t.val a := by
  rw [empiricalPMF, PMF.mem_support_normalize_iff]
  simp [Nat.pos_iff_ne_zero]

private theorem empiricalPMF_injective (hn : 0 < n) :
    Function.Injective (empiricalPMF (A := A) hn) := by
  intro s t h
  apply Subtype.ext
  funext a
  have hn0 : (n : ℝ≥0∞) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hn)
  have hcount := congrArg (fun p : PMF A => p a * (n : ℝ≥0∞)) h
  simp only [empiricalPMF_apply, ENNReal.div_mul_cancel hn0 (ENNReal.natCast_ne_top n)]
    at hcount
  exact_mod_cast hcount

/-- At positive length, admissible counts are equivalent to laws with an exact
denominator witness. The prescribed denominator need not be the least one. -/
noncomputable def wordTypeEquivPMF (hn : 0 < n) :
    ↥(wordTypes A n) ≃
      {q : PMF A // ∃ c : A → ℕ, (∑ a, c a) = n ∧
        ∀ a, q a = (c a : ℝ≥0∞) / (n : ℝ≥0∞)} :=
  Equiv.ofBijective
    (fun t => ⟨empiricalPMF hn t, t.val, (mem_wordTypes t.val).1 t.property,
      empiricalPMF_apply hn t⟩)
    ⟨fun _ _ h => empiricalPMF_injective hn (congrArg Subtype.val h), by
      intro q
      rcases q.property with ⟨c, hc, hq⟩
      refine ⟨⟨c, (mem_wordTypes c).2 hc⟩, Subtype.ext ?_⟩
      ext a
      exact (empiricalPMF_apply hn _ a).trans (hq a).symm⟩

/-- The forward conversion of a count index is its empirical law. -/
theorem wordTypeEquivPMF_apply (hn : 0 < n) (t : ↥(wordTypes A n)) :
    ((wordTypeEquivPMF hn) t).val = empiricalPMF hn t := rfl

/-- Empirical-law equality recognizes membership in the existing type class. -/
theorem mem_typeClass_iff_empiricalPMF_eq (hn : 0 < n)
    {x : Fin n → A} {t : ↥(wordTypes A n)} :
    x ∈ typeClass t ↔ empiricalPMF hn (wordType x) = empiricalPMF hn t := by
  rw [mem_typeClass]
  exact (empiricalPMF_injective hn).eq_iff.symm

end LeanInfoTheory.Shannon
