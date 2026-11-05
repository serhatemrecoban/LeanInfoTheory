/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.CodingRate
import LeanInfoTheory.Shannon.SourceCoding
import Mathlib.Data.Fintype.BigOperators

/-!
# Finite coding-rate and binary-padding consumers

These private consumers exercise the scalar rate and ceiling interfaces, including
their zero-length and negative-target boundaries. An actual binary encoder and
total extended decoder preserve every recovered output of an arbitrary source
code, hence its exact error. Reindexing the binary alphabet gives a padded source
code whose minimal-length rate overhead is proved for the same construction.
-/

namespace LeanInfoTheory.Examples.CodingRate

noncomputable section

universe u

open LeanInfoTheory.Shannon

example (n M : ℕ) (hM : 1 ≤ M) : 0 ≤ codeRate n M :=
  codeRate_nonneg n M hM

example (M : ℕ) : codeRate 0 M = 0 := codeRate_zero M

example (n : ℕ) : codeRate n 1 = 0 := codeRate_one n

example {n M : ℕ} (hn : 0 < n) (hM : 1 ≤ M) (R : ℝ) :
    codeRate n M ≤ R ↔ (M : ℝ) ≤ Real.exp ((n : ℝ) * R) :=
  codeRate_le_iff hn hM R

example {n M : ℕ} (hn : 0 < n) (hM : 1 ≤ M) :
    Real.exp ((n : ℝ) * codeRate n M) = (M : ℝ) :=
  exp_mul_codeRate hn hM

example (n : ℕ) (R : ℝ) :
    1 ≤ roundedMessageSize n R ∧
      Real.exp ((n : ℝ) * R) ≤ (roundedMessageSize n R : ℝ) ∧
      (roundedMessageSize n R : ℝ) < Real.exp ((n : ℝ) * R) + 1 :=
  roundedMessageSize_bounds n R

example {n : ℕ} (hn : 0 < n) {R : ℝ} (hR : 0 ≤ R) :
    R ≤ codeRate n (roundedMessageSize n R) ∧
      codeRate n (roundedMessageSize n R) ≤ R + Real.log 2 / n :=
  codeRate_roundedMessageSize_bounds hn hR

example {M : ℕ} (hM : 1 ≤ M) (k : ℕ) :
    Nat.ceil (natsToBits (Real.log (M : ℝ))) ≤ k ↔ M ≤ 2 ^ k :=
  ceil_natsToBits_log_le_iff hM k

example (n k : ℕ) :
    natsToBits (codeRate n (2 ^ k)) = (k : ℝ) / n :=
  natsToBits_codeRate_pow_two n k

private theorem bits_card (k : ℕ) :
    Fintype.card (Fin k → Bool) = 2 ^ k := by
  simp

private def bitsEquivFin (k : ℕ) :
    (Fin k → Bool) ≃ Fin (2 ^ k) :=
  Fintype.equivFinOfCardEq (bits_card k)

private def messageBits {M k : ℕ} (h : M ≤ 2 ^ k) :
    Fin M ↪ (Fin k → Bool) :=
  (Fin.castLEEmb h).trans (bitsEquivFin k).symm.toEmbedding

private def binaryEncoder {X : Type u} {M k : ℕ}
    (c : SourceCode X M) (h : M ≤ 2 ^ k) : X → (Fin k → Bool) :=
  fun x => messageBits h (c.encoder x)

private def binaryDecoder {X : Type u} {M k : ℕ}
    (c : SourceCode X M) (hM : 1 ≤ M) (h : M ≤ 2 ^ k) :
    (Fin k → Bool) → X :=
  Function.extend (messageBits h) c.decoder
    (fun _ => c.decoder ⟨0, lt_of_lt_of_le Nat.zero_lt_one hM⟩)

private theorem binary_recovered {X : Type u} {M k : ℕ}
    (c : SourceCode X M) (hM : 1 ≤ M) (h : M ≤ 2 ^ k) (x : X) :
    binaryDecoder c hM h (binaryEncoder c h x) = c.decoder (c.encoder x) := by
  exact (messageBits h).injective.extend_apply c.decoder
    (fun _ => c.decoder ⟨0, lt_of_lt_of_le Nat.zero_lt_one hM⟩) (c.encoder x)

private theorem binary_error {X : Type u} {M k : ℕ}
    (c : SourceCode X M) (q : PMF X) (hM : 1 ≤ M) (h : M ≤ 2 ^ k) :
    decodingErrorProbabilityOf q id (binaryEncoder c h) (binaryDecoder c hM h) =
      c.errorProbability q := by
  simp only [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure,
    binary_recovered]

private def paddedCode {X : Type u} {M k : ℕ}
    (c : SourceCode X M) (hM : 1 ≤ M) (h : M ≤ 2 ^ k) :
    SourceCode X (2 ^ k) :=
  (fun x => bitsEquivFin k (binaryEncoder c h x),
    fun j => binaryDecoder c hM h ((bitsEquivFin k).symm j))

private theorem padded_recovered {X : Type u} {M k : ℕ}
    (c : SourceCode X M) (hM : 1 ≤ M) (h : M ≤ 2 ^ k) (x : X) :
    (paddedCode c hM h).decoder ((paddedCode c hM h).encoder x) =
      c.decoder (c.encoder x) := by
  change binaryDecoder c hM h
    ((bitsEquivFin k).symm (bitsEquivFin k (binaryEncoder c h x))) = _
  rw [Equiv.symm_apply_apply]
  exact binary_recovered c hM h x

private theorem padded_error {X : Type u} {M k : ℕ}
    (c : SourceCode X M) (q : PMF X) (hM : 1 ≤ M) (h : M ≤ 2 ^ k) :
    (paddedCode c hM h).errorProbability q = c.errorProbability q := by
  simp only [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure,
    padded_recovered]

private theorem padded_rate (n k : ℕ) :
    codeRate n (2 ^ k) = (k : ℝ) * Real.log 2 / n := by
  simp [codeRate, Nat.cast_pow, Real.log_pow]

private theorem minimal_binary_rate_bounds {n M : ℕ}
    (hn : 0 < n) (hM : 1 ≤ M) :
    codeRate n M ≤
        (Nat.ceil (natsToBits (Real.log (M : ℝ))) : ℝ) * Real.log 2 / n ∧
      (Nat.ceil (natsToBits (Real.log (M : ℝ))) : ℝ) * Real.log 2 / n <
        codeRate n M + Real.log 2 / n := by
  have hnR : 0 < (n : ℝ) := by exact_mod_cast hn
  have hL : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hlog : 0 ≤ Real.log (M : ℝ) :=
    Real.log_nonneg (by exact_mod_cast hM)
  have ht : 0 ≤ Real.log (M : ℝ) / Real.log 2 := div_nonneg hlog hL.le
  have hlo : Real.log (M : ℝ) ≤
      (Nat.ceil (Real.log (M : ℝ) / Real.log 2) : ℝ) * Real.log 2 :=
    (div_le_iff₀ hL).mp (Nat.le_ceil (Real.log (M : ℝ) / Real.log 2))
  have hhi := mul_lt_mul_of_pos_right (Nat.ceil_lt_add_one ht) hL
  rw [add_mul, div_mul_cancel₀ _ hL.ne', one_mul] at hhi
  constructor
  · simpa [codeRate, natsToBits, natsToBase] using
      div_le_div_of_nonneg_right hlo hnR.le
  · have hd := (div_lt_div_iff_of_pos_right hnR).mpr hhi
    simpa [codeRate, natsToBits, natsToBase, add_div] using hd

example {X : Type u} {n M : ℕ} (c : SourceCode X M) (q : PMF X)
    (hn : 0 < n) (hM : 1 ≤ M) :
    let k := Nat.ceil (natsToBits (Real.log (M : ℝ)))
    ∃ d : SourceCode X (2 ^ k),
      (∀ x, d.decoder (d.encoder x) = c.decoder (c.encoder x)) ∧
      d.errorProbability q = c.errorProbability q ∧
      codeRate n M ≤ codeRate n (2 ^ k) ∧
      codeRate n (2 ^ k) < codeRate n M + Real.log 2 / n := by
  dsimp only
  let k := Nat.ceil (natsToBits (Real.log (M : ℝ)))
  have hbudget : M ≤ 2 ^ k := (ceil_natsToBits_log_le_iff hM k).mp le_rfl
  obtain ⟨hlo, hhi⟩ := minimal_binary_rate_bounds hn hM
  refine ⟨paddedCode c hM hbudget, padded_recovered c hM hbudget,
    padded_error c q hM hbudget, ?_, ?_⟩
  · rw [padded_rate]
    exact hlo
  · rw [padded_rate]
    exact hhi

private theorem three_fits_two : 3 ≤ 2 ^ 2 := by norm_num

private def unusedTwoBits : Fin 2 → Bool :=
  (bitsEquivFin 2).symm (3 : Fin (2 ^ 2))

private theorem unusedTwoBits_not_in_range :
    ¬ ∃ j : Fin 3, messageBits three_fits_two j = unusedTwoBits := by
  rintro ⟨j, hj⟩
  have he := congrArg (bitsEquivFin 2) hj
  change (bitsEquivFin 2)
      ((bitsEquivFin 2).symm ((Fin.castLEEmb three_fits_two) j)) =
    (bitsEquivFin 2) ((bitsEquivFin 2).symm (3 : Fin (2 ^ 2))) at he
  simp only [Equiv.apply_symm_apply] at he
  have hv := congrArg Fin.val he
  change (j : ℕ) = 3 at hv
  exact (ne_of_lt j.isLt) hv

example {X : Type u} (c : SourceCode X 3) (x : X) :
    binaryEncoder c three_fits_two x ≠ unusedTwoBits := by
  intro h
  exact unusedTwoBits_not_in_range ⟨c.encoder x, h⟩

private theorem unusedTwoBits_fallback {X : Type u} (c : SourceCode X 3) :
    binaryDecoder c (by norm_num) three_fits_two unusedTwoBits = c.decoder 0 := by
  change Function.extend (messageBits three_fits_two) c.decoder
    (fun _ => c.decoder (0 : Fin 3)) unusedTwoBits = c.decoder 0
  exact Function.extend_apply' c.decoder (fun _ => c.decoder (0 : Fin 3))
    unusedTwoBits unusedTwoBits_not_in_range

example : binaryDecoder ((id, id) : SourceCode (Fin 3) 3)
    (by norm_num) three_fits_two unusedTwoBits = 0 :=
  unusedTwoBits_fallback ((id, id) : SourceCode (Fin 3) 3)

example {X : Type u} (c : SourceCode X 3) (q : PMF X) :
    decodingErrorProbabilityOf q id (binaryEncoder c three_fits_two)
      (binaryDecoder c (by norm_num) three_fits_two) = c.errorProbability q :=
  binary_error c q (by norm_num) three_fits_two

example : Nat.ceil (natsToBits (Real.log (3 : ℝ))) = 2 := by
  apply Nat.le_antisymm
  · exact (ceil_natsToBits_log_le_iff (M := 3) (by norm_num) 2).mpr three_fits_two
  · by_contra h
    have hk : Nat.ceil (natsToBits (Real.log (3 : ℝ))) ≤ 1 := by omega
    have hbad := (ceil_natsToBits_log_le_iff (M := 3) (by norm_num) 1).mp hk
    norm_num at hbad

example : Fintype.card (Fin 0 → Bool) = 1 := by simp

example : Nat.ceil (natsToBits (Real.log (1 : ℝ))) = 0 := by
  simp [natsToBits, natsToBase]

example {X : Type u} (c : SourceCode X 1) (q : PMF X) :
    (paddedCode (k := 0) c (by norm_num) (by norm_num)).errorProbability q =
      c.errorProbability q :=
  padded_error c q (by norm_num) (by norm_num)

example (n : ℕ) : natsToBits (codeRate n (2 ^ 0)) = 0 := by
  simpa using natsToBits_codeRate_pow_two n 0

example (n : ℕ) : roundedMessageSize n 0 = 1 := by
  simp [roundedMessageSize]

example (R : ℝ) : roundedMessageSize 0 R = 1 := by
  simp [roundedMessageSize]

example : roundedMessageSize 1 (Real.log 3) = 3 := by
  unfold roundedMessageSize
  rw [Nat.cast_one, one_mul, Real.exp_log (by norm_num : (0 : ℝ) < 3)]
  norm_num

private theorem rounded_nonpos (n : ℕ) (R : ℝ) (hR : R ≤ 0) :
    roundedMessageSize n R = 1 := by
  apply Nat.le_antisymm
  · change Nat.ceil (Real.exp ((n : ℝ) * R)) ≤ 1
    apply Nat.ceil_le.mpr
    simpa only [Nat.cast_one] using Real.exp_le_one_iff.mpr
      (mul_nonpos_of_nonneg_of_nonpos (Nat.cast_nonneg n) hR)
  · exact (roundedMessageSize_bounds n R).1

example (n : ℕ) (R : ℝ) (hR : R < 0) :
    roundedMessageSize n R = 1 ∧ codeRate n (roundedMessageSize n R) = 0 := by
  rw [rounded_nonpos n R hR.le]
  exact ⟨rfl, codeRate_one n⟩

example : ¬ codeRate 1 (roundedMessageSize 1 (-2 * Real.log 2)) ≤
    -2 * Real.log 2 + Real.log 2 / (1 : ℝ) := by
  have hL : 0 < Real.log 2 := Real.log_pos (by norm_num)
  rw [rounded_nonpos 1 (-2 * Real.log 2) (by nlinarith), codeRate_one]
  simp only [div_one]
  linarith

example : codeRate 0 3 = 0 ∧ Real.exp ((0 : ℝ) * codeRate 0 3) ≠ (3 : ℝ) := by
  constructor
  · exact codeRate_zero 3
  · norm_num

example (k : ℕ) : natsToBits (codeRate 0 (2 ^ k)) = 0 := by
  simpa using natsToBits_codeRate_pow_two 0 k

end

end LeanInfoTheory.Examples.CodingRate
