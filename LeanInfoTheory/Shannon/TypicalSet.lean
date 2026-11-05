/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.Entropy
import LeanInfoTheory.Probability.Iid

/-!
# Supported weak typical sets

Weak typicality uses strict normalized self-information deviation, in nats,
and requires both positive blocklength and positive word mass. Thus the set is
empty at length zero or nonpositive width, and impossible words are excluded
even when the width exceeds entropy.

This finite owner supplies membership, atom bounds and cardinality bounds
without importing AEP or concentration results. The lower cardinality bound
retains the actual typical-set probability. Probability convergence is owned by
`Shannon.SemanticBridge.AEP`.
-/

namespace LeanInfoTheory.Shannon

noncomputable section

universe u

open scoped BigOperators

/-- Supported words of positive length whose normalized self-information is
strictly within `ε` of entropy. The set is empty at length zero and for
nonpositive `ε`. Information is measured in nats. -/
def weakTypicalSet {A : Type u} [Fintype A] (p : PMF A) (n : ℕ) (ε : ℝ) :
    Finset (Fin n → A) := by
  classical
  exact Finset.univ.filter fun x =>
    0 < n ∧ x ∈ (PMF.iid p n).support ∧
      |selfInfo (PMF.iid p n) x / (n : ℝ) - entropy p| < ε

/-- Exact weak-typicality membership, including the positive-length guard,
support qualification, and strict deviation bound. -/
theorem mem_weakTypicalSet {A : Type u} [Fintype A] (p : PMF A)
    {n : ℕ} {ε : ℝ} {x : Fin n → A} :
    x ∈ weakTypicalSet p n ε ↔
      0 < n ∧ x ∈ (PMF.iid p n).support ∧
        |selfInfo (PMF.iid p n) x / (n : ℝ) - entropy p| < ε := by
  classical
  simp [weakTypicalSet]

/-- The real mass of a weakly typical word lies between the two exponential
bounds in nats. Membership supplies positive length and support; no full-support,
positive-entropy or additional width hypothesis is required. -/
theorem weakTypicalSet_mass_bounds {A : Type u} [Fintype A] (p : PMF A)
    {n : ℕ} {ε : ℝ} {x : Fin n → A} (hx : x ∈ weakTypicalSet p n ε) :
    Real.exp (-(n : ℝ) * (entropy p + ε)) ≤ (PMF.iid p n x).toReal ∧
      (PMF.iid p n x).toReal ≤ Real.exp (-(n : ℝ) * (entropy p - ε)) := by
  obtain ⟨hn, hs, ht⟩ := (mem_weakTypicalSet p).1 hx
  have hnR : 0 < (n : ℝ) := by exact_mod_cast hn
  have hr : 0 < (PMF.iid p n x).toReal :=
    ENNReal.toReal_pos (PMF.mem_support_iff _ _ |>.1 hs) (PMF.apply_ne_top _ _)
  rw [selfInfo_of_toReal_ne_zero _ (ne_of_gt hr)] at ht
  obtain ⟨hl, hu⟩ := abs_lt.mp ht
  have hu' : -Real.log (PMF.iid p n x).toReal < (entropy p + ε) * (n : ℝ) :=
    (div_lt_iff₀ hnR).1 (by linarith)
  have hl' : (entropy p - ε) * (n : ℝ) < -Real.log (PMF.iid p n x).toReal :=
    (lt_div_iff₀ hnR).1 (by linarith)
  constructor
  · apply (Real.le_log_iff_exp_le hr).1
    nlinarith
  · apply (Real.log_le_iff_le_exp hr).1
    nlinarith

/-- The real cardinality of the weak typical set is at most the entropy-based
exponential in nats. This holds at every length and width, including empty
boundary cases, without full-support or positive-entropy assumptions. -/
theorem card_weakTypicalSet_le {A : Type u} [Fintype A] (p : PMF A)
    (n : ℕ) (ε : ℝ) :
    ((weakTypicalSet p n ε).card : ℝ) ≤ Real.exp ((n : ℝ) * (entropy p + ε)) := by
  classical
  have hsum :
      ((weakTypicalSet p n ε).card : ℝ) * Real.exp (-(n : ℝ) * (entropy p + ε)) ≤
        1 := by
    calc
      _ = ∑ _x ∈ weakTypicalSet p n ε,
          Real.exp (-(n : ℝ) * (entropy p + ε)) := by simp
      _ ≤ ∑ x ∈ weakTypicalSet p n ε, (PMF.iid p n x).toReal :=
        Finset.sum_le_sum fun _ hx => (weakTypicalSet_mass_bounds p hx).1
      _ ≤ ∑ x, (PMF.iid p n x).toReal :=
        Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ _)
          (fun _ _ _ => ENNReal.toReal_nonneg)
      _ = 1 := PMF.sum_toReal _
  have h := mul_le_mul_of_nonneg_right hsum
    (Real.exp_pos ((n : ℝ) * (entropy p + ε))).le
  simpa only [mul_assoc, ← Real.exp_add, neg_mul, neg_add_cancel,
    Real.exp_zero, mul_one, one_mul] using h

/-- Typical probability times the lower entropy-based exponential is bounded
by the real cardinality. The probability factor is essential: a strict typical
set can be empty even at positive length and width. The bound holds for every
length and width, in nats and without full-support or positive-entropy assumptions. -/
theorem prob_mul_exp_le_card_weakTypicalSet {A : Type u} [Fintype A] (p : PMF A)
    (n : ℕ) (ε : ℝ) :
    ((PMF.iid p n).toOuterMeasure (weakTypicalSet p n ε)).toReal *
        Real.exp ((n : ℝ) * (entropy p - ε)) ≤
      ((weakTypicalSet p n ε).card : ℝ) := by
  classical
  have hsum :
      ((PMF.iid p n).toOuterMeasure (weakTypicalSet p n ε)).toReal ≤
        ((weakTypicalSet p n ε).card : ℝ) *
          Real.exp (-(n : ℝ) * (entropy p - ε)) := by
    rw [PMF.toOuterMeasure_apply_finset,
      ENNReal.toReal_sum (fun x _ => PMF.apply_ne_top (PMF.iid p n) x)]
    calc
      _ ≤ ∑ _x ∈ weakTypicalSet p n ε,
          Real.exp (-(n : ℝ) * (entropy p - ε)) :=
        Finset.sum_le_sum fun _ hx => (weakTypicalSet_mass_bounds p hx).2
      _ = _ := by simp
  have h := mul_le_mul_of_nonneg_right hsum
    (Real.exp_pos ((n : ℝ) * (entropy p - ε))).le
  simpa only [mul_assoc, ← Real.exp_add, neg_mul, neg_add_cancel,
    Real.exp_zero, mul_one] using h

end

end LeanInfoTheory.Shannon
