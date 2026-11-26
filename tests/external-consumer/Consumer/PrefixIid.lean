/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.PrefixCodeLengthIid

/-! External consumer of optimal one-symbol and iid binary prefix lengths. -/

noncomputable section

open LeanInfoTheory.Shannon
open scoped BigOperators

namespace Consumer.PrefixIid

/-- Obtain the rounded witness with its exact lengths, the independently attained
minimum, and the comparison with every supported binary prefix encoder. -/
private theorem scalarWitnesses {A : Type*} [Fintype A] (p : PMF A) :
    ∃ rounded best : ↥p.supportFinset → List Bool,
      IsBinaryPrefixCode rounded ∧
      (∀ a, (rounded a).length = ⌈-Real.logb 2 (p a.val).toReal⌉₊) ∧
      expectedCodewordLength p rounded < natsToBits (entropy p) + 1 ∧
      IsBinaryPrefixCode best ∧ expectedCodewordLength p best = optimalPrefixLength p ∧
      ∀ d : ↥p.supportFinset → List Bool, IsBinaryPrefixCode d →
        expectedCodewordLength p best ≤ expectedCodewordLength p d := by
  obtain ⟨rounded, hr, hlength, hupper⟩ := exists_isBinaryPrefixCode_length_eq_ceil p
  have hmin := isLeast_optimalPrefixLength p
  obtain ⟨best, hb, hcost⟩ := hmin.1
  refine ⟨rounded, best, hr, hlength, hupper, hb, hcost, fun d hd => ?_⟩
  exact hcost.le.trans (hmin.2 ⟨d, hd, rfl⟩)

/-- The block witness is an encoder on the support of the entire iid word law.
Its cost compares with any competing block encoder, and its own cost per symbol
satisfies the strict iid interval. -/
private theorem blockWitness {A : Type*} [Fintype A] (p : PMF A) (n : ℕ) (hn : 0 < n) :
    let q := PMF.iid p n
    ∃ best : ↥q.supportFinset → List Bool,
      IsBinaryPrefixCode best ∧ expectedCodewordLength q best = optimalPrefixLength q ∧
      (∀ d : ↥q.supportFinset → List Bool, IsBinaryPrefixCode d →
        expectedCodewordLength q best ≤ expectedCodewordLength q d) ∧
      natsToBits (entropy p) ≤ expectedCodewordLength q best / (n : ℝ) ∧
      expectedCodewordLength q best / (n : ℝ) < natsToBits (entropy p) + 1 / (n : ℝ) := by
  intro q
  have hl := isLeast_optimalPrefixLength q
  obtain ⟨best, hbest, he⟩ := hl.1
  obtain ⟨hlo, hhi⟩ := optimalPrefixLength_iid_div_bounds p n hn
  refine ⟨best, hbest, he, fun d hd => he.le.trans (hl.2 ⟨d, hd, rfl⟩), ?_⟩
  rw [he]
  exact ⟨hlo, hhi⟩

section EquiprobableThree

private def law : PMF (Fin 3) :=
  PMF.ofFintype (fun _ => ENNReal.ofReal (1 / 3)) (by
    rw [← ENNReal.ofReal_sum_of_nonneg (show ∀ i : Fin 3, i ∈ Finset.univ → 0 ≤ (1 / 3 : ℝ) from fun _ _ => by norm_num)]
    norm_num)

private theorem third (i : Fin 3) : (law i).toReal = 1 / 3 :=
  ENNReal.toReal_ofReal (by norm_num)

private abbrev Support := ↥law.supportFinset

private def labels : Fin 3 ≃ Support where
  toFun i := ⟨i, (law.mem_supportFinset i).2 ((law.mem_support_iff i).2 (by
    intro h
    have he := third i
    rw [h, ENNReal.toReal_zero] at he
    norm_num at he))⟩
  invFun s := s.val
  left_inv := fun _ => rfl
  right_inv := fun _ => rfl

private theorem supportSum (f : Support → ℝ) :
    (∑ a, f a) = f (labels 0) + f (labels 1) + f (labels 2) := by
  rw [← labels.sum_comp f, Fin.sum_univ_three]

private theorem mean (d : Support → List Bool) :
    expectedCodewordLength law d =
      (((d (labels 0)).length : ℝ) + (d (labels 1)).length + (d (labels 2)).length) / 3 := by
  unfold expectedCodewordLength
  rw [supportSum]
  simp only [third]
  ring

/-- The straight line through the binary Kraft weights for lengths 1 and 2
lies below the weight at every natural length. -/
private theorem weightLower (k : ℕ) : (3 - (k : ℝ)) / 4 ≤ (1 / 2 : ℝ) ^ k := by
  by_cases hk : k ≤ 2
  · rcases (show k = 0 ∨ k = 1 ∨ k = 2 by omega) with rfl | rfl | rfl <;> norm_num
  · have h3 : (3 : ℝ) ≤ k := by exact_mod_cast (show 3 ≤ k by omega)
    exact le_trans (by linarith : (3 - (k : ℝ)) / 4 ≤ 0) (pow_nonneg (by norm_num) _)

/-- Summing the line over three labels and applying Kraft bounds every prefix
encoder's mean by 5/3 from below. -/
private theorem fiveThirdsLower (d : Support → List Bool) (hd : IsBinaryPrefixCode d) :
    5 / 3 ≤ expectedCodewordLength law d := by
  have hk := hd.kraft_sum_le_one
  rw [supportSum] at hk
  rw [mean]
  linarith only [hk, weightLower (d (labels 0)).length,
    weightLower (d (labels 1)).length, weightLower (d (labels 2)).length]

private def depths (s : Support) : ℕ := if s.val = 0 then 1 else 2

private theorem feasible : (∑ a : Support, (1 / 2 : ℝ) ^ depths a) ≤ 1 := by
  rw [supportSum]
  norm_num [depths, labels, Fin.ext_iff]

private theorem attainedFiveThirds : optimalPrefixLength law = 5 / 3 := by
  obtain ⟨d, hd, hdepth⟩ := exists_isBinaryPrefixCode_of_kraft_sum_le_one depths feasible
  have hcost : expectedCodewordLength law d = 5 / 3 := by
    rw [mean]
    norm_num [hdepth, depths, labels, Fin.ext_iff]
  have hl := isLeast_optimalPrefixLength law
  obtain ⟨best, hbest, he⟩ := hl.1
  exact le_antisymm (hl.2 ⟨d, hd, hcost⟩) ((fiveThirdsLower best hbest).trans_eq he)

private theorem roundedTwo : ⌈-Real.logb 2 (1 / 3 : ℝ)⌉₊ = 2 := by
  rw [one_div, Real.logb_inv, neg_neg]
  apply (Nat.ceil_eq_iff (by decide : (2 : ℕ) ≠ 0)).2
  constructor
  · norm_num only [Nat.reduceSub, Nat.cast_one]
    exact (Real.lt_logb_iff_rpow_lt (by norm_num) (by norm_num)).2 (by norm_num)
  · change Real.logb 2 3 ≤ (2 : ℝ)
    exact (Real.logb_le_iff_le_rpow (by norm_num) (by norm_num)).2 (by norm_num)

/-- Rounded lengths (2,2,2) have mean 2. The optimal profile (1,2,2) has mean
5/3; both values are attained on the same source support. -/
private theorem differentAttainedCosts :
    ∃ rounded best : Support → List Bool,
      IsBinaryPrefixCode rounded ∧ (∀ a, (rounded a).length = 2) ∧
      expectedCodewordLength law rounded = 2 ∧ IsBinaryPrefixCode best ∧
      expectedCodewordLength law best = 5 / 3 ∧
      expectedCodewordLength law best < expectedCodewordLength law rounded := by
  obtain ⟨rounded, best, hr, hl, _, hb, he, _⟩ := scalarWitnesses law
  have lengths (a : Support) : (rounded a).length = 2 := by
    rw [hl, third, roundedTwo]
  have hrounded : expectedCodewordLength law rounded = 2 := by
    rw [mean]
    norm_num [lengths]
  have hbest : expectedCodewordLength law best = 5 / 3 := he.trans attainedFiveThirds
  exact ⟨rounded, best, hr, lengths, hrounded, hb, hbest, by rw [hbest, hrounded]; norm_num⟩

end EquiprobableThree
end Consumer.PrefixIid
