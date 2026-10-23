/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.Units
import Mathlib.Algebra.Order.Floor.Semiring

/-!
# Finite coding rates and integer message budgets

Rates are measured in nats. Their operational interpretation requires positive
block length and message budget; division at length zero is totalized to zero.
Ceiling the exponential gives a positive integer budget for every real target.
For nonnegative targets its rate lies between the target and the target plus
`log 2 / n`. Conversion to fixed binary length reuses the Units layer.
These scalar utilities impose no source-law or code-sequence assumptions.
-/

namespace LeanInfoTheory.Shannon

noncomputable section

/-- The logarithm of the message budget per source symbol, in nats.
The value at zero length is an initialization convention, not a normalized rate. -/
def codeRate (n M : ℕ) : ℝ := Real.log (M : ℝ) / n

/-- Positive integer budgets have nonnegative rate, including the totalized
zero-length value. -/
theorem codeRate_nonneg (n M : ℕ) (hM : 1 ≤ M) : 0 ≤ codeRate n M := by
  exact div_nonneg (Real.log_nonneg (by exact_mod_cast hM)) (Nat.cast_nonneg n)

/-- The totalized rate at length zero is zero. -/
theorem codeRate_zero (M : ℕ) : codeRate 0 M = 0 := by
  simp [codeRate]

/-- A one-message alphabet has rate zero at every length. -/
theorem codeRate_one (n : ℕ) : codeRate n 1 = 0 := by
  simp [codeRate]

/-- At positive length and budget, a rate bound is exactly an exponential
message-budget bound. The real target need not be nonnegative. -/
theorem codeRate_le_iff {n M : ℕ} (hn : 0 < n) (hM : 1 ≤ M) (R : ℝ) :
    codeRate n M ≤ R ↔ (M : ℝ) ≤ Real.exp ((n : ℝ) * R) := by
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  have hM' : (0 : ℝ) < M := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hM)
  rw [codeRate, div_le_iff₀ hn', mul_comm R, Real.log_le_iff_le_exp hM']

/-- Exponentiating length times rate recovers a positive integer budget.
Positive length is essential for cancellation. -/
theorem exp_mul_codeRate {n M : ℕ} (hn : 0 < n) (hM : 1 ≤ M) :
    Real.exp ((n : ℝ) * codeRate n M) = (M : ℝ) := by
  have hn' : (n : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hn)
  have hM' : (0 : ℝ) < M := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hM)
  rw [codeRate, mul_div_cancel₀ _ hn', Real.exp_log hM']

/-- The least natural message budget at least the target exponential.
It is positive even for negative targets and at length zero. -/
def roundedMessageSize (n : ℕ) (R : ℝ) : ℕ := ⌈Real.exp ((n : ℝ) * R)⌉₊

/-- All-real ceiling estimates: positivity, no rounding down, and an overhead
strictly below one message. -/
theorem roundedMessageSize_bounds (n : ℕ) (R : ℝ) :
    1 ≤ roundedMessageSize n R ∧
      Real.exp ((n : ℝ) * R) ≤ (roundedMessageSize n R : ℝ) ∧
      (roundedMessageSize n R : ℝ) < Real.exp ((n : ℝ) * R) + 1 := by
  exact ⟨Nat.one_le_ceil_iff.mpr (Real.exp_pos _), Nat.le_ceil _,
    Nat.ceil_lt_add_one (le_of_lt (Real.exp_pos _))⟩

/-- For nonnegative targets and positive length, rounding adds at most
`log 2 / n` to the rate. Negative targets retain the size estimates above,
but do not in general satisfy this rate sandwich. -/
theorem codeRate_roundedMessageSize_bounds {n : ℕ} (hn : 0 < n)
    {R : ℝ} (hR : 0 ≤ R) :
    R ≤ codeRate n (roundedMessageSize n R) ∧
      codeRate n (roundedMessageSize n R) ≤ R + Real.log 2 / n := by
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  obtain ⟨hM, hlo, hhi⟩ := roundedMessageSize_bounds n R
  have hM' : (0 : ℝ) < roundedMessageSize n R := by
    exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hM)
  constructor
  · rw [codeRate, le_div_iff₀ hn', mul_comm R, Real.le_log_iff_exp_le hM']
    exact hlo
  · apply (codeRate_le_iff hn hM _).mpr
    have hexp : 1 ≤ Real.exp ((n : ℝ) * R) :=
      Real.one_le_exp_iff.mpr (mul_nonneg (le_of_lt hn') hR)
    have heq : (n : ℝ) * (R + Real.log 2 / n) = (n : ℝ) * R + Real.log 2 := by
      field_simp
    rw [heq, Real.exp_add, Real.exp_log (by norm_num : (0 : ℝ) < 2)]
    linarith

/-- The minimal fixed binary length fits in `k` exactly when the positive
message budget fits in `2^k` indices. -/
theorem ceil_natsToBits_log_le_iff {M : ℕ} (hM : 1 ≤ M) (k : ℕ) :
    ⌈natsToBits (Real.log (M : ℝ))⌉₊ ≤ k ↔ M ≤ 2 ^ k := by
  have hlog : (0 : ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hM' : (0 : ℝ) < M := by exact_mod_cast (lt_of_lt_of_le Nat.zero_lt_one hM)
  rw [Nat.ceil_le, natsToBits, natsToBase, div_le_iff₀ hlog,
    ← Real.log_pow, Real.log_le_log_iff hM' (pow_pos (by norm_num) k)]
  exact_mod_cast (Iff.rfl : M ≤ 2 ^ k ↔ M ≤ 2 ^ k)

/-- The rate of exactly `k` binary digits, converted to bits per symbol.
The equality is algebraic at zero length as well. -/
theorem natsToBits_codeRate_pow_two (n k : ℕ) :
    natsToBits (codeRate n (2 ^ k)) = (k : ℝ) / n := by
  have hlog : Real.log 2 ≠ 0 := ne_of_gt (Real.log_pos (by norm_num))
  simp only [natsToBits, natsToBase, codeRate, Nat.cast_pow, Nat.cast_ofNat, Real.log_pow]
  rw [div_right_comm, mul_div_cancel_right₀ _ hlog]

end

end LeanInfoTheory.Shannon
