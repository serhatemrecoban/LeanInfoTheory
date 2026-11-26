/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.TypeClassBounds
import LeanInfoTheory.Shannon.SemanticBridge.KL

/-!
# Type-class probabilities under a general prior

At positive length, every word in a supplied type class has iid mass
`exp (-n * (H(q) + D(q || p)))` under a sampling law `p` whose actual support
contains that of the empirical law `q`. Entropy and divergence use nats.
The divergence is canonical `InformationTheory.klDiv`; support inclusion
excludes infinity before its real-valued finite-sum interpretation.

The word identity concerns a single word; the whole-class identity multiplies
that mass by the cardinality of the existing `typeClass` finset. Zero-count
labels contribute a factor of one, including labels where the sampling mass is
zero. The cardinality bounds cancel the entropy term, giving upper and lower
bounds in terms of KL alone. The lower bound uses the full alphabet size.
When an observed symbol has zero sampling mass, the class has zero outer measure.
-/

namespace LeanInfoTheory.Shannon

open scoped BigOperators ENNReal

universe u

variable {A : Type u} [Fintype A] {n : ℕ}
variable [MeasurableSpace A] [MeasurableSingletonClass A]

private theorem entropy_add_klDiv_eq_neg_sum
    (q p : PMF A) (h : q.support ⊆ p.support) :
    entropy q + (InformationTheory.klDiv q.toMeasure p.toMeasure).toReal =
      -(∑ a, (q a).toReal * Real.log (p a).toReal) := by
  classical
  have hfinite : InformationTheory.klDiv q.toMeasure p.toMeasure ≠ ⊤ :=
    (klDiv_pmf_ne_top_iff_support_subset q p).2 h
  have hac := (InformationTheory.klDiv_ne_top_iff.mp hfinite).1
  rw [entropy_eq_sum, toReal_klDiv_pmf_eq_sum q p hac,
    ← Finset.sum_add_distrib, ← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro a _
  by_cases hqa : q a = 0
  · simp [hqa]
  · have hpa : p a ≠ 0 :=
      (p.mem_support_iff a).1 (h ((q.mem_support_iff a).2 hqa))
    have hqR : (q a).toReal ≠ 0 :=
      ENNReal.toReal_ne_zero.2 ⟨hqa, q.apply_ne_top a⟩
    have hpR : (p a).toReal ≠ 0 :=
      ENNReal.toReal_ne_zero.2 ⟨hpa, p.apply_ne_top a⟩
    rw [ENNReal.toReal_div, Real.log_div hqR hpR, Real.negMulLog]
    ring

/-- Every word in a type class has real iid mass `exp (-n * (H(q) + D(q || p)))`
under any prior whose support contains the empirical support. The canonical KL
divergence is finite under this hypothesis, and both quantities use nats. -/
theorem iid_apply_of_mem_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support)
    {x : Fin n → A} (hx : x ∈ typeClass t) :
    ((PMF.iid p n) x).toReal =
      Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
        (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal)) := by
  classical
  let q := empiricalPMF hn t
  change ((PMF.iid p n) x).toReal =
    Real.exp (-(n : ℝ) *
      (entropy q + (InformationTheory.klDiv q.toMeasure p.toMeasure).toReal))
  have hs : q.support ⊆ p.support := h
  have hn0 : (n : ℝ) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt hn)
  have hmass (a : A) : (n : ℝ) * (q a).toReal = (t.val a : ℝ) := by
    dsimp only [q]
    rw [empiricalPMF_apply, ENNReal.toReal_div,
      ENNReal.toReal_natCast, ENNReal.toReal_natCast]
    rw [← mul_div_assoc, mul_div_cancel_left₀ _ hn0]
  have hfactor (a : A) :
      (p a).toReal ^ t.val a =
        Real.exp ((t.val a : ℝ) * Real.log (p a).toReal) := by
    by_cases hc : t.val a = 0
    · simp only [hc, pow_zero, Nat.cast_zero, zero_mul, Real.exp_zero]
    · have hqa : a ∈ q.support :=
        (mem_support_empiricalPMF_iff hn t a).2 (Nat.pos_of_ne_zero hc)
      have hp : 0 < (p a).toReal :=
        ENNReal.toReal_pos ((p.mem_support_iff a).1 (hs hqa)) (p.apply_ne_top a)
      rw [Real.exp_nat_mul, Real.exp_log hp]
  have hgroup :
      (∏ i, (p (x i)).toReal) = ∏ a, (p a).toReal ^ t.val a := by
    have hc : symbolCount x = t.val :=
      congrArg Subtype.val (mem_typeClass.1 hx)
    calc
      (∏ i, (p (x i)).toReal) =
          ∏ a, (p a).toReal ^ symbolCount x a := by
        simpa only [Finset.prod_const, symbolCount] using
          (Finset.prod_fiberwise' Finset.univ x (fun a => (p a).toReal)).symm
      _ = ∏ a, (p a).toReal ^ t.val a := by rw [hc]
  calc
    ((PMF.iid p n) x).toReal = ∏ i, (p (x i)).toReal := by
      change ((PMF.finiteProduct (fun _ : Fin n => p)) x).toReal =
        ∏ i, (p (x i)).toReal
      simp only [PMF.finiteProduct_apply, ENNReal.toReal_prod]
    _ = ∏ a, (p a).toReal ^ t.val a := hgroup
    _ = ∏ a, Real.exp ((t.val a : ℝ) * Real.log (p a).toReal) :=
      Finset.prod_congr rfl fun a _ => hfactor a
    _ = Real.exp (∑ a, (t.val a : ℝ) * Real.log (p a).toReal) :=
      (Real.exp_sum Finset.univ
        (fun a => (t.val a : ℝ) * Real.log (p a).toReal)).symm
    _ = Real.exp (-(n : ℝ) *
        (entropy q + (InformationTheory.klDiv q.toMeasure p.toMeasure).toReal)) := by
      congr 1
      calc
        (∑ a, (t.val a : ℝ) * Real.log (p a).toReal) =
            ∑ a, (n : ℝ) * ((q a).toReal * Real.log (p a).toReal) := by
          apply Finset.sum_congr rfl
          intro a _
          rw [← hmass a]
          ring
        _ = (n : ℝ) * ∑ a, (q a).toReal * Real.log (p a).toReal := by
          rw [Finset.mul_sum]
        _ = -(n : ℝ) *
            (entropy q + (InformationTheory.klDiv q.toMeasure p.toMeasure).toReal) := by
          rw [entropy_add_klDiv_eq_neg_sum q p hs]
          ring

/-- The real iid mass of a type class is its cardinality times the common word
mass under a prior whose support contains the empirical support. Canonical KL
is finite under this hypothesis, and entropy and divergence use nats. -/
theorem iid_toOuterMeasure_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support) :
    ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal =
      ((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
          (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal)) := by
  classical
  rw [PMF.toOuterMeasure_apply_finset,
    ENNReal.toReal_sum (fun x _ => (PMF.iid p n).apply_ne_top x)]
  calc
    (∑ x ∈ typeClass t, ((PMF.iid p n) x).toReal) =
        ∑ x ∈ typeClass t,
          Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
            (InformationTheory.klDiv
              (empiricalPMF hn t).toMeasure p.toMeasure).toReal)) :=
      Finset.sum_congr rfl
        (fun x hx => iid_apply_of_mem_typeClass hn t p h hx)
    _ = ((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
          (InformationTheory.klDiv
            (empiricalPMF hn t).toMeasure p.toMeasure).toReal)) := by
      simp only [Finset.sum_const, nsmul_eq_mul]

private theorem exp_entropy_mul_word_factor (m H D : ℝ) :
    Real.exp (m * H) * Real.exp (-m * (H + D)) = Real.exp (-m * D) := by
  rw [← Real.exp_add]
  congr 1
  ring

/-- The probability of a type class under a prior containing its empirical
support is at most the exponential of minus its length times its KL divergence. -/
theorem iid_toOuterMeasure_typeClass_le_exp_neg_klDiv
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support) :
    ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal ≤
      Real.exp (-(n : ℝ) *
        (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal) := by
  rw [iid_toOuterMeasure_typeClass hn t p h]
  calc
    _ ≤ Real.exp ((n : ℝ) * entropy (empiricalPMF hn t)) * _ :=
      mul_le_mul_of_nonneg_right (card_typeClass_le_exp_entropy hn t) (Real.exp_pos _).le
    _ = _ := exp_entropy_mul_word_factor _ _ _

/-- The finite-KL lower bound for a type class uses the size of the entire
alphabet in its polynomial denominator, including symbols with zero counts. -/
theorem exp_neg_klDiv_div_pow_le_iid_toOuterMeasure_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support) :
    Real.exp (-(n : ℝ) *
        (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal) /
        ((n : ℝ) + 1) ^ Fintype.card A ≤
      ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal := by
  rw [iid_toOuterMeasure_typeClass hn t p h]
  let D := (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal
  have lower := mul_le_mul_of_nonneg_right (exp_entropy_div_pow_le_card_typeClass hn t)
    (Real.exp_pos (-(n : ℝ) * (entropy (empiricalPMF hn t) + D))).le
  rwa [div_mul_eq_mul_div₀, exp_entropy_mul_word_factor] at lower

omit [MeasurableSpace A] [MeasurableSingletonClass A] in
/-- A type class has zero iid probability if its empirical law gives positive
mass to a symbol outside the sampling support. -/
theorem iid_toOuterMeasure_typeClass_eq_zero_of_not_support_subset
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : ¬ (empiricalPMF hn t).support ⊆ p.support) :
    (PMF.iid p n).toOuterMeasure (typeClass t) = 0 := by
  classical
  obtain ⟨a, ha, hnull⟩ := Set.not_subset.mp h
  have hcount := (mem_support_empiricalPMF_iff hn t a).mp ha
  rw [PMF.toOuterMeasure_apply_eq_zero_iff, Set.disjoint_left]
  intro x hs hx
  have htype : wordType x = t := mem_typeClass.mp hx
  rw [← htype] at hcount
  change 0 < (Finset.univ.filter fun i => x i = a).card at hcount
  obtain ⟨i, hi⟩ := Finset.card_pos.mp hcount
  have hcoord := (PMF.mem_support_finiteProduct_iff (fun _ : Fin n => p) x).mp hs i
  exact hnull ((Finset.mem_filter.mp hi).2 ▸ hcoord)

end LeanInfoTheory.Shannon
