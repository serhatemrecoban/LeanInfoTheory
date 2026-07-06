/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.Entropy
import Mathlib.Analysis.Convex.Jensen
import Mathlib.Probability.Distributions.Uniform

/-!
# Finite Shannon entropy bounds

This file contains analytic finite-entropy bounds that need heavier convexity
tools than the lightweight entropy definition file. Keeping these theorems here
lets the core finite entropy API remain cheap to import.
-/

namespace LeanInfoTheory
namespace Shannon

open scoped BigOperators

universe u

noncomputable section

/--
Finite Shannon entropy is bounded above by the logarithm of the alphabet size.

The proof is Jensen's inequality for the concave function `Real.negMulLog`,
applied with uniform weights over the finite alphabet.
-/
theorem entropy_le_log_card {alpha : Type u} [Fintype alpha] [Nonempty alpha]
    (p : PMF alpha) :
    entropy p <= Real.log (Fintype.card alpha) := by
  classical
  let n : Real := Fintype.card alpha
  have hn_pos : 0 < n := by
    simpa [n] using
      (Nat.cast_pos.mpr (Fintype.card_pos (α := alpha)) :
        (0 : Real) < Fintype.card alpha)
  have hn_nonneg : 0 <= n := hn_pos.le
  have hn_ne : n ≠ 0 := ne_of_gt hn_pos
  -- The uniform weights `1 / n` over the finite alphabet sum to one.
  have hweights :
      (∑ _a ∈ (Finset.univ : Finset alpha), (1 : Real) / n) = 1 := by
    calc
      (∑ _a ∈ (Finset.univ : Finset alpha), (1 : Real) / n) =
          ((Finset.univ : Finset alpha).card : Real) * (1 / n) := by
        simp [Finset.sum_const, nsmul_eq_mul]
      _ = n * (1 / n) := by
        simp [n]
      _ = 1 := by
        rw [mul_one_div_cancel hn_ne]
  -- Jensen turns the average of `negMulLog (p a)` into `negMulLog` of the average mass.
  have hJ :
      (∑ a ∈ (Finset.univ : Finset alpha),
          ((1 : Real) / n) • Real.negMulLog (p a).toReal) <=
        Real.negMulLog
          (∑ a ∈ (Finset.univ : Finset alpha), ((1 : Real) / n) • (p a).toReal) := by
    exact
      Real.concaveOn_negMulLog.le_map_sum
        (t := (Finset.univ : Finset alpha))
        (w := fun _ => (1 : Real) / n)
        (p := fun a => (p a).toReal)
        (fun _ _ => div_nonneg zero_le_one hn_nonneg)
        hweights
        (fun a _ => PMF.toReal_nonneg p a)
  -- The left side of Jensen is `(1 / n) * H(p)`.
  have hleft :
      (∑ a ∈ (Finset.univ : Finset alpha),
          ((1 : Real) / n) • Real.negMulLog (p a).toReal) =
        (1 / n) * entropy p := by
    calc
      (∑ a ∈ (Finset.univ : Finset alpha),
          ((1 : Real) / n) • Real.negMulLog (p a).toReal) =
          ∑ a ∈ (Finset.univ : Finset alpha),
            (1 / n) * Real.negMulLog (p a).toReal := by
        apply Finset.sum_congr rfl
        intro a _ha
        rw [smul_eq_mul]
      _ = (1 / n) * ∑ a ∈ (Finset.univ : Finset alpha),
          Real.negMulLog (p a).toReal := by
        rw [Finset.mul_sum]
      _ = (1 / n) * entropy p := by
        rw [entropy_eq_sum]
  -- The Jensen center point is the average of the masses, namely `1 / n`.
  have hright :
      (∑ a ∈ (Finset.univ : Finset alpha), ((1 : Real) / n) • (p a).toReal) =
        1 / n := by
    calc
      (∑ a ∈ (Finset.univ : Finset alpha), ((1 : Real) / n) • (p a).toReal) =
          ∑ a ∈ (Finset.univ : Finset alpha), (1 / n) * (p a).toReal := by
        apply Finset.sum_congr rfl
        intro a _ha
        rw [smul_eq_mul]
      _ = (1 / n) * ∑ a ∈ (Finset.univ : Finset alpha), (p a).toReal := by
        rw [Finset.mul_sum]
      _ = 1 / n := by
        rw [PMF.sum_toReal p, mul_one]
  -- Combining the previous two rewrites gives `(1 / n) * H(p) <= negMulLog (1 / n)`.
  have hJ' : (1 / n) * entropy p <= Real.negMulLog (1 / n) := by
    calc
      (1 / n) * entropy p =
          (∑ a ∈ (Finset.univ : Finset alpha),
            ((1 : Real) / n) • Real.negMulLog (p a).toReal) := hleft.symm
      _ <= Real.negMulLog
          (∑ a ∈ (Finset.univ : Finset alpha), ((1 : Real) / n) • (p a).toReal) := hJ
      _ = Real.negMulLog (1 / n) := by
        rw [hright]
  -- Multiply by the alphabet size and simplify `n * negMulLog (1 / n)` to `log n`.
  calc
    entropy p = n * ((1 / n) * entropy p) := by
      symm
      rw [← mul_assoc, mul_one_div_cancel hn_ne, one_mul]
    _ <= n * Real.negMulLog (1 / n) :=
      mul_le_mul_of_nonneg_left hJ' hn_nonneg
    _ = Real.log (Fintype.card alpha) := by
      have hlog : Real.log (1 / n) = -Real.log n := by
        rw [div_eq_mul_inv, one_mul, Real.log_inv]
      rw [Real.negMulLog, hlog]
      change n * (-(1 / n) * -Real.log n) = Real.log n
      calc
        n * (-(1 / n) * -Real.log n) = n * ((1 / n) * Real.log n) := by
          ring
        _ = (n * (1 / n)) * Real.log n := by
          ring
        _ = Real.log n := by
          rw [mul_one_div_cancel hn_ne, one_mul]

/--
The uniform distribution reaches the finite entropy upper bound.

Mathematically, this is the equality case `H(U_alpha) = log |alpha|` for the
uniform law on a nonempty finite alphabet.
-/
theorem entropy_uniformOfFintype {alpha : Type u} [Fintype alpha] [Nonempty alpha] :
    entropy (PMF.uniformOfFintype alpha) = Real.log (Fintype.card alpha) := by
  classical
  let n : Real := Fintype.card alpha
  have hn_pos : 0 < n := by
    simpa [n] using
      (Nat.cast_pos.mpr (Fintype.card_pos (α := alpha)) :
        (0 : Real) < Fintype.card alpha)
  have hn_ne : n ≠ 0 := ne_of_gt hn_pos
  -- Every atom of the uniform law has real mass `1 / n`.
  have hmass (a : alpha) : (PMF.uniformOfFintype alpha a).toReal = 1 / n := by
    rw [PMF.uniformOfFintype_apply]
    simp [n]
  rw [entropy_eq_sum]
  calc
    (∑ a, Real.negMulLog (PMF.uniformOfFintype alpha a).toReal) =
        ∑ _a : alpha, Real.negMulLog (1 / n) := by
      apply Finset.sum_congr rfl
      intro a _ha
      rw [hmass a]
    _ = n * Real.negMulLog (1 / n) := by
      rw [Finset.sum_const, Finset.card_univ]
      simp [n, nsmul_eq_mul]
    _ = Real.log (Fintype.card alpha) := by
      have hlog : Real.log (1 / n) = -Real.log n := by
        rw [div_eq_mul_inv, one_mul, Real.log_inv]
      rw [Real.negMulLog, hlog]
      change n * (-(1 / n) * -Real.log n) = Real.log n
      calc
        n * (-(1 / n) * -Real.log n) = n * ((1 / n) * Real.log n) := by
          ring
        _ = (n * (1 / n)) * Real.log n := by
          ring
        _ = Real.log n := by
          rw [mul_one_div_cancel hn_ne, one_mul]

end

end Shannon
end LeanInfoTheory
