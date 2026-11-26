/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.TypeClassCardinality
import LeanInfoTheory.Shannon.EmpiricalPMF
import LeanInfoTheory.Probability.Iid
import LeanInfoTheory.Shannon.Entropy

/-!
# Own-law masses and entropy bounds for type classes

At positive length, every word in a supplied type class has the same iid
mass under that class's empirical law. Its real mass is `exp (-n * H(q))`;
the whole class has that mass multiplied by its cardinality.
Since the class event has probability at most one, its cardinality is at most
`exp (n * H(q))`. The target count vector maximizes probability under its
own empirical law. Comparing its mass with at most `(n+1)^k` classes gives
the lower bound `exp (n * H(q)) / (n+1)^k`, with the full ambient alphabet size.

These statements use the existing count index, finite class and empirical law.
Zero-count symbols contribute powers with exponent zero; logarithmic
cancellation is used only at positive-count symbols. Entropy is in nats.
-/

namespace LeanInfoTheory.Shannon

open scoped BigOperators ENNReal

universe u

variable {A : Type u} [Fintype A] {n : ℕ}

private theorem prod_word_eq_prod_typeClass_counts
    (w : A → ℝ) {x : Fin n → A} {t : ↥(wordTypes A n)}
    (hx : x ∈ typeClass t) :
    (∏ i, w (x i)) = ∏ a, w a ^ t.val a := by
  classical
  have hc : symbolCount x = t.val :=
    congrArg Subtype.val (mem_typeClass.1 hx)
  calc
    (∏ i, w (x i)) = ∏ a, w a ^ symbolCount x a := by
      simpa only [Finset.prod_const, symbolCount] using
        (Finset.prod_fiberwise' Finset.univ x w).symm
    _ = ∏ a, w a ^ t.val a := by rw [hc]

private theorem empiricalPMF_counts_prod_eq_exp
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    (∏ a, (empiricalPMF hn t a).toReal ^ t.val a) =
      Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)) := by
  classical
  let q := empiricalPMF hn t
  change (∏ a, (q a).toReal ^ t.val a) =
    Real.exp (-(n : ℝ) * entropy q)
  have hn0 : (n : ℝ) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt hn)
  have hmass (a : A) : (n : ℝ) * (q a).toReal = (t.val a : ℝ) := by
    dsimp only [q]
    rw [empiricalPMF_apply, ENNReal.toReal_div,
      ENNReal.toReal_natCast, ENNReal.toReal_natCast]
    rw [← mul_div_assoc, mul_div_cancel_left₀ _ hn0]
  have hfactor (a : A) :
      (q a).toReal ^ t.val a =
        Real.exp ((t.val a : ℝ) * Real.log (q a).toReal) := by
    by_cases hc : t.val a = 0
    · simp only [hc, pow_zero, Nat.cast_zero, zero_mul, Real.exp_zero]
    · have hs : a ∈ q.support :=
        (mem_support_empiricalPMF_iff hn t a).2 (Nat.pos_of_ne_zero hc)
      have hp : 0 < (q a).toReal :=
        ENNReal.toReal_pos
          ((PMF.mem_support_iff q a).1 hs)
          (q.apply_ne_top a)
      rw [Real.exp_nat_mul, Real.exp_log hp]
  calc
    (∏ a, (q a).toReal ^ t.val a) =
        ∏ a, Real.exp ((t.val a : ℝ) * Real.log (q a).toReal) :=
      Finset.prod_congr rfl fun a _ => hfactor a
    _ = Real.exp (∑ a, (t.val a : ℝ) * Real.log (q a).toReal) :=
      (Real.exp_sum Finset.univ
        (fun a => (t.val a : ℝ) * Real.log (q a).toReal)).symm
    _ = Real.exp (-(n : ℝ) * entropy q) := by
      congr 1
      rw [entropy_eq_sum, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro a _
      rw [Real.negMulLog, ← hmass a]
      ring

/-- Every word in a type class has real iid mass `exp (-n * H(q))`
under the class's own empirical law. -/
theorem iid_empiricalPMF_apply_of_mem_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n))
    {x : Fin n → A} (hx : x ∈ typeClass t) :
    ((PMF.iid (empiricalPMF hn t) n) x).toReal =
      Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)) := by
  classical
  calc
    ((PMF.iid (empiricalPMF hn t) n) x).toReal =
        ∏ i, (empiricalPMF hn t (x i)).toReal := by
      change ((PMF.finiteProduct (fun _ : Fin n => empiricalPMF hn t)) x).toReal =
        ∏ i, (empiricalPMF hn t (x i)).toReal
      simp only [PMF.finiteProduct_apply, ENNReal.toReal_prod]
    _ = ∏ a, (empiricalPMF hn t a).toReal ^ t.val a :=
      prod_word_eq_prod_typeClass_counts
        (fun a => (empiricalPMF hn t a).toReal) hx
    _ = Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)) :=
      empiricalPMF_counts_prod_eq_exp hn t

/-- The real own-law iid mass of a type class is its cardinality times
the common real mass of its words. -/
theorem iid_empiricalPMF_toOuterMeasure_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t)).toReal =
      ((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)) := by
  classical
  rw [PMF.toOuterMeasure_apply_finset,
    ENNReal.toReal_sum
      (fun x _ => (PMF.iid (empiricalPMF hn t) n).apply_ne_top x)]
  calc
    (∑ x ∈ typeClass t, ((PMF.iid (empiricalPMF hn t) n) x).toReal) =
        ∑ x ∈ typeClass t,
          Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)) :=
      Finset.sum_congr rfl
        (fun x hx => iid_empiricalPMF_apply_of_mem_typeClass hn t hx)
    _ = ((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)) := by
      simp only [Finset.sum_const, nsmul_eq_mul]

/-- At positive length, a type class has at most `exp (n * H(q))` words,
where `q` is its empirical law and entropy is measured in nats. -/
theorem card_typeClass_le_exp_entropy
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    ((typeClass t).card : ℝ) ≤
      Real.exp ((n : ℝ) * entropy (empiricalPMF hn t)) := by
  have hprob :
      (PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t) ≤ 1 := by
    calc
      _ ≤ (PMF.iid (empiricalPMF hn t) n).toOuterMeasure Set.univ :=
        (PMF.iid (empiricalPMF hn t) n).toOuterMeasure.mono (Set.subset_univ _)
      _ = 1 :=
        ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure_apply_eq_one_iff Set.univ).2
          (Set.subset_univ _)
  have hmass :
      ((typeClass t).card : ℝ) *
          Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)) ≤ 1 := by
    rw [← iid_empiricalPMF_toOuterMeasure_typeClass hn t]
    simpa only [ENNReal.toReal_one] using
      ENNReal.toReal_mono ENNReal.one_ne_top hprob
  have h := mul_le_mul_of_nonneg_right hmass
    (Real.exp_pos ((n : ℝ) * entropy (empiricalPMF hn t))).le
  simpa only [mul_assoc, ← Real.exp_add, neg_mul, neg_add_cancel,
    Real.exp_zero, mul_one, one_mul] using h

private theorem factorial_mul_pow_le_factorial_mul_pow (a b : ℕ) :
    a.factorial * a ^ b ≤ b.factorial * a ^ a := by
  rcases le_total a b with hab | hba
  · calc
      a.factorial * a ^ b =
          (a.factorial * a ^ (b - a)) * a ^ a := by
        rw [mul_assoc, ← pow_add, Nat.sub_add_cancel hab]
      _ ≤ b.factorial * a ^ a :=
        Nat.mul_le_mul_right _
          (Nat.factorial_mul_pow_sub_le_factorial hab)
  · have hf :
        b.factorial * a.descFactorial (a - b) = a.factorial := by
      simpa only [Nat.sub_sub_self hba] using
        (Nat.factorial_mul_descFactorial
          (n := a) (k := a - b) (Nat.sub_le a b))
    calc
      a.factorial * a ^ b =
          (b.factorial * a.descFactorial (a - b)) * a ^ b := by
        rw [hf]
      _ ≤ (b.factorial * a ^ (a - b)) * a ^ b :=
        Nat.mul_le_mul_right _
          (Nat.mul_le_mul_left _ (Nat.descFactorial_le_pow a (a - b)))
      _ = b.factorial * a ^ a := by
        rw [mul_assoc, ← pow_add, Nat.sub_add_cancel hba]

/-- Integer weights for count-vector probabilities at positive length.
The target counts fix the law; the competing counts determine the class. -/
private def typeCountWeight (a b : A → ℕ) : ℕ :=
  Nat.multinomial Finset.univ b * ∏ i, a i ^ b i

private theorem typeCountWeight_le_self
    (t s : ↥(wordTypes A n)) :
    typeCountWeight t.val s.val ≤ typeCountWeight t.val t.val := by
  classical
  have ht :
      (∏ i, (t.val i).factorial) *
          Nat.multinomial Finset.univ t.val = n.factorial := by
    simpa only [(mem_wordTypes t.val).1 t.property] using
      Nat.multinomial_spec Finset.univ t.val
  have hs :
      (∏ i, (s.val i).factorial) *
          Nat.multinomial Finset.univ s.val = n.factorial := by
    simpa only [(mem_wordTypes s.val).1 s.property] using
      Nat.multinomial_spec Finset.univ s.val
  have hp :
      (∏ i, (t.val i).factorial) * (∏ i, t.val i ^ s.val i) ≤
        (∏ i, (s.val i).factorial) * (∏ i, t.val i ^ t.val i) := by
    simpa only [Finset.prod_mul_distrib] using
      (Finset.prod_le_prod' (s := Finset.univ)
        (fun i _ => factorial_mul_pow_le_factorial_mul_pow
          (t.val i) (s.val i)))
  have hcancel :
      n.factorial * typeCountWeight t.val s.val ≤
        n.factorial * typeCountWeight t.val t.val := by
    calc
      _ =
          (Nat.multinomial Finset.univ t.val *
              Nat.multinomial Finset.univ s.val) *
            ((∏ i, (t.val i).factorial) *
              (∏ i, t.val i ^ s.val i)) := by
        rw [← ht]
        dsimp only [typeCountWeight]
        ring
      _ ≤
          (Nat.multinomial Finset.univ t.val *
              Nat.multinomial Finset.univ s.val) *
            ((∏ i, (s.val i).factorial) *
              (∏ i, t.val i ^ t.val i)) :=
        Nat.mul_le_mul_left _ hp
      _ = n.factorial * typeCountWeight t.val t.val := by
        rw [← hs]
        dsimp only [typeCountWeight]
        ring
  exact Nat.le_of_mul_le_mul_left hcancel (Nat.factorial_pos n)

private theorem sum_typeCountWeight (t : ↥(wordTypes A n)) :
    (∑ c ∈ wordTypes A n, typeCountWeight t.val c) = n ^ n := by
  classical
  have ht : (∑ a, t.val a) = n :=
    (mem_wordTypes t.val).1 t.property
  simpa only [wordTypes, typeCountWeight, ht, Nat.cast_id] using
    (Finset.sum_pow_eq_sum_piAntidiag Finset.univ t.val n).symm

private theorem pow_le_pow_mul_typeCountWeight
    (t : ↥(wordTypes A n)) :
    n ^ n ≤ (n + 1) ^ Fintype.card A * typeCountWeight t.val t.val := by
  classical
  calc
    n ^ n = ∑ c ∈ wordTypes A n, typeCountWeight t.val c :=
      (sum_typeCountWeight t).symm
    _ ≤ ∑ _c ∈ wordTypes A n, typeCountWeight t.val t.val :=
      Finset.sum_le_sum fun c hc => typeCountWeight_le_self t ⟨c, hc⟩
    _ = (wordTypes A n).card * typeCountWeight t.val t.val := by
      simp
    _ ≤ (n + 1) ^ Fintype.card A * typeCountWeight t.val t.val :=
      Nat.mul_le_mul_right _ (card_wordTypes_le A n)

private theorem typeCountWeight_eq_zero_of_zero_count
    (t s : ↥(wordTypes A n)) (a : A)
    (ht : t.val a = 0) (hs : 0 < s.val a) :
    typeCountWeight t.val s.val = 0 := by
  classical
  have hp : (∏ i, t.val i ^ s.val i) = 0 :=
    Finset.prod_eq_zero (Finset.mem_univ a)
      (by simp only [ht, zero_pow (Nat.ne_of_gt hs)])
  simp only [typeCountWeight, hp, mul_zero]

private theorem iid_empiricalPMF_typeClass_eq_weight
    (hn : 0 < n) (t s : ↥(wordTypes A n)) :
    ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass s)).toReal =
      (typeCountWeight t.val s.val : ℝ) / (n : ℝ) ^ n := by
  classical
  have hprod :
      (∏ a, (empiricalPMF hn t a).toReal ^ s.val a) =
        ((∏ a, t.val a ^ s.val a : ℕ) : ℝ) / (n : ℝ) ^ n := by
    simp_rw [empiricalPMF_apply, ENNReal.toReal_div,
      ENNReal.toReal_natCast, div_pow]
    rw [Finset.prod_div_distrib, Finset.prod_pow_eq_pow_sum,
      (mem_wordTypes s.val).1 s.property]
    simp only [Nat.cast_prod, Nat.cast_pow]
  rw [PMF.toOuterMeasure_apply_finset,
    ENNReal.toReal_sum
      (fun x _ => (PMF.iid (empiricalPMF hn t) n).apply_ne_top x)]
  calc
    (∑ x ∈ typeClass s, ((PMF.iid (empiricalPMF hn t) n) x).toReal) =
        ∑ _x ∈ typeClass s, ∏ a, (empiricalPMF hn t a).toReal ^ s.val a := by
      apply Finset.sum_congr rfl
      intro x hx
      change ((PMF.finiteProduct (fun _ : Fin n => empiricalPMF hn t)) x).toReal =
        ∏ a, (empiricalPMF hn t a).toReal ^ s.val a
      simp only [PMF.finiteProduct_apply, ENNReal.toReal_prod]
      exact prod_word_eq_prod_typeClass_counts
        (fun a => (empiricalPMF hn t a).toReal) hx
    _ = ((typeClass s).card : ℝ) *
        ∏ a, (empiricalPMF hn t a).toReal ^ s.val a := by
      simp only [Finset.sum_const, nsmul_eq_mul]
    _ = (typeCountWeight t.val s.val : ℝ) / (n : ℝ) ^ n := by
      rw [card_typeClass_eq_multinomial, hprod]
      simp only [typeCountWeight, Nat.cast_mul, mul_div_assoc]

private theorem iid_empiricalPMF_typeClass_le_self
    (hn : 0 < n) (t s : ↥(wordTypes A n)) :
    ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass s)).toReal ≤
      ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t)).toReal := by
  have hnpos : 0 < (n : ℝ) ^ n := pow_pos (by exact_mod_cast hn) n
  rw [iid_empiricalPMF_typeClass_eq_weight hn t s,
    iid_empiricalPMF_typeClass_eq_weight hn t t]
  exact div_le_div_of_nonneg_right
    (by exact_mod_cast typeCountWeight_le_self t s) hnpos.le

private theorem iid_empiricalPMF_typeClass_eq_zero_of_zero_count
    (hn : 0 < n) (t s : ↥(wordTypes A n)) (a : A)
    (ht : t.val a = 0) (hs : 0 < s.val a) :
    (PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass s) = 0 := by
  have hfinite :
      (PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass s) ≠ ∞ := by
    rw [PMF.toOuterMeasure_apply_finset]
    exact ENNReal.sum_ne_top.2
      (fun x _ => (PMF.iid (empiricalPMF hn t) n).apply_ne_top x)
  have hz :
      ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass s)).toReal = 0 := by
    rw [iid_empiricalPMF_typeClass_eq_weight hn t s,
      typeCountWeight_eq_zero_of_zero_count t s a ht hs, Nat.cast_zero, zero_div]
  exact ((ENNReal.toReal_eq_zero_iff _).1 hz).resolve_right hfinite

/-- At positive length, a type class has at least `exp (n * H(q)) / (n+1)^k`
words, with `k` the full ambient alphabet size, including zero-count symbols. -/
theorem exp_entropy_div_pow_le_card_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    Real.exp ((n : ℝ) * entropy (empiricalPMF hn t)) /
        ((n : ℝ) + 1) ^ Fintype.card A ≤
      ((typeClass t).card : ℝ) := by
  have hnpos : 0 < (n : ℝ) ^ n := pow_pos (by exact_mod_cast hn) n
  have hweight :
      (n : ℝ) ^ n ≤
        ((n : ℝ) + 1) ^ Fintype.card A * (typeCountWeight t.val t.val : ℝ) := by
    exact_mod_cast pow_le_pow_mul_typeCountWeight t
  have hmass :
      1 ≤ ((n : ℝ) + 1) ^ Fintype.card A *
        ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t)).toReal := by
    rw [iid_empiricalPMF_typeClass_eq_weight hn t t, ← mul_div_assoc]
    exact (le_div_iff₀ hnpos).2 (by simpa only [one_mul] using hweight)
  rw [iid_empiricalPMF_toOuterMeasure_typeClass hn t] at hmass
  have h := mul_le_mul_of_nonneg_right hmass
    (Real.exp_pos ((n : ℝ) * entropy (empiricalPMF hn t))).le
  have hbound :
      Real.exp ((n : ℝ) * entropy (empiricalPMF hn t)) ≤
        ((n : ℝ) + 1) ^ Fintype.card A * ((typeClass t).card : ℝ) := by
    simpa only [one_mul, mul_assoc, ← Real.exp_add, neg_mul, neg_add_cancel,
      Real.exp_zero, mul_one] using h
  exact (div_le_iff₀ (by positivity : 0 < ((n : ℝ) + 1) ^ Fintype.card A)).2
    (by simpa only [mul_comm] using hbound)

end LeanInfoTheory.Shannon
