/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCodingOneShot

/-!
# One-shot bounds for a noiseless ternary channel

Two messages use one noiseless channel use with input masses 3/8, 3/8 and 1/4.
At log(5/2) the strict test accepts every diagonal pair. At log(8/3), the
first two diagonal atoms tie the threshold and together contribute 3/4 to
the miss probability.
-/

namespace LeanInfoTheory.Examples.ChannelCodingOneShotTernary

open LeanInfoTheory.Shannon

noncomputable section

private abbrev Word := Fin 1 → Fin 3
private def word (a : Fin 3) : Word := fun _ => a
private def mass (a : Fin 3) : ℝ := if a = 2 then 1 / 4 else 3 / 8

private theorem mass_nonneg (a : Fin 3) : 0 ≤ mass a := by
  unfold mass
  split <;> norm_num

private def prior : PMF (Fin 3) :=
  PMF.ofFintype (fun a => ENNReal.ofReal (mass a)) (by
    rw [← ENNReal.ofReal_sum_of_nonneg (fun a _ => mass_nonneg a), Fin.sum_univ_three]
    change ENNReal.ofReal ((3 / 8 : ℝ) + 3 / 8 + 1 / 4) = 1
    norm_num)

private abbrev W : Fin 3 → PMF (Fin 3) := PMF.pure
private abbrev K := PMF.memorylessChannel W 1
private abbrev q := PMF.iid prior 1
private abbrev J := PMF.channelJoint q K
private abbrev Q := indepProd q (q.bind K)
private abbrev event (k : ℝ) := infoDensityThresholdEvent q K (Real.log k)

private theorem sum_words (f : Word → ℝ) :
    (∑ x, f x) = f (word 0) + f (word 1) + f (word 2) := by
  rw [← (Equiv.funUnique (Fin 1) (Fin 3)).symm.sum_comp f, Fin.sum_univ_three]
  rfl

private theorem input_atom (x : Word) : (q x).toReal = mass (x 0) := by
  change (PMF.finiteProduct (fun _ : Fin 1 => prior) x).toReal = _
  rw [PMF.finiteProduct_apply, Fin.prod_univ_one]
  exact ENNReal.toReal_ofReal (mass_nonneg (x 0))

private theorem word_channel : K = PMF.pure :=
  funext fun x => PMF.finiteProduct_pure x

private theorem joint_atom (x y : Word) :
    (J (x, y)).toReal = if x 0 = y 0 then mass (x 0) else 0 := by
  rw [PMF.channelJoint_apply, ENNReal.toReal_mul, input_atom]
  change mass (x 0) * (PMF.productChannel (fun _ : Fin 1 => W) x y).toReal = _
  rw [PMF.productChannel_apply, Fin.prod_univ_one]
  by_cases h : x 0 = y 0
  · simp [W, PMF.pure_apply, h]
  · simp [W, PMF.pure_apply, h, Ne.symm h]

private theorem independent_atom (x y : Word) :
    (Q (x, y)).toReal = mass (x 0) * mass (y 0) := by
  change ((indepProd q (q.bind K)) (x, y)).toReal = _
  rw [word_channel, PMF.bind_pure, indepProd_apply, ENNReal.toReal_mul, input_atom, input_atom]

example (x : Word) :
    (J (x, x)).toReal / (Q (x, x)).toReal = if x 0 = 2 then 4 else 8 / 3 := by
  rw [joint_atom, independent_atom]
  by_cases h : x 0 = 2 <;> norm_num [mass, h]

private theorem test_atoms (k : ℝ) (hk : 0 < k) (x y : Word) :
    (x, y) ∈ event k ↔ k * (mass (x 0) * mass (y 0)) <
      (if x 0 = y 0 then mass (x 0) else 0) := by
  change Real.exp (Real.log k) * (Q (x, y)).toReal < (J (x, y)).toReal ↔ _
  rw [Real.exp_log hk, independent_atom, joint_atom]

private theorem symbol_tests (a b : Fin 3) :
    ((5 / 2 : ℝ) * (mass a * mass b) < (if a = b then mass a else 0) ↔ a = b) ∧
    ((8 / 3 : ℝ) * (mass a * mass b) < (if a = b then mass a else 0) ↔ a = 2 ∧ b = 2) := by
  fin_cases a <;> fin_cases b <;> norm_num [mass, Fin.ext_iff]

private theorem main_event : event (5 / 2) = {z : Word × Word | z.1 0 = z.2 0} := by
  ext ⟨x, y⟩
  exact (test_atoms (5 / 2) (by norm_num) x y).trans (symbol_tests (x 0) (y 0)).1

private theorem tie_event : event (8 / 3) = {z : Word × Word | z.1 0 = 2 ∧ z.2 0 = 2} := by
  ext ⟨x, y⟩
  exact (test_atoms (8 / 3) (by norm_num) x y).trans (symbol_tests (x 0) (y 0)).2

example (x : Word) (hx : x 0 ≠ 2) :
    0 < (J (x, x)).toReal ∧
    Real.exp (Real.log (8 / 3)) * (Q (x, x)).toReal = (J (x, x)).toReal ∧
    (x, x) ∉ event (8 / 3) := by
  rw [Real.exp_log (by norm_num : 0 < (8 / 3 : ℝ)), tie_event, independent_atom, joint_atom]
  norm_num [mass, hx]

private theorem main_masses :
    (J.toOuterMeasure (event (5 / 2))ᶜ).toReal = 0 ∧
    (Q.toOuterMeasure (event (5 / 2))).toReal = 11 / 32 := by
  classical
  rw [main_event]
  simp only [PMF.toOuterMeasure_toReal_eq_sum, Fintype.sum_prod_type, sum_words,
    Set.indicator_apply, joint_atom, independent_atom]
  norm_num [word, mass, Fin.ext_iff]

example : (J.toOuterMeasure (event (8 / 3))ᶜ).toReal = 3 / 4 ∧
    (Q.toOuterMeasure (event (8 / 3))).toReal = 1 / 16 := by
  classical
  rw [tie_event]
  simp only [PMF.toOuterMeasure_toReal_eq_sum, Fintype.sum_prod_type, sum_words,
    Set.indicator_apply, joint_atom, independent_atom]
  norm_num [word, mass, Fin.ext_iff]

private theorem exp_neg_threshold : Real.exp (-Real.log (5 / 2)) = 2 / 5 := by
  rw [Real.exp_neg, Real.exp_log (by norm_num : 0 < (5 / 2 : ℝ))]
  norm_num

private theorem event_bound :
    (J.toOuterMeasure (event (5 / 2))ᶜ).toReal +
      ((2 : ℝ) - 1) * (Q.toOuterMeasure (event (5 / 2))).toReal = 11 / 32 := by
  rw [main_masses.1, main_masses.2]
  norm_num

private theorem relaxed_bound :
    (J.toOuterMeasure (event (5 / 2))ᶜ).toReal +
      ((2 : ℝ) - 1) * Real.exp (-Real.log (5 / 2)) = 2 / 5 := by
  rw [main_masses.1, exp_neg_threshold]
  norm_num

example : ∃ c : BlockChannelCode (Fin 3) (Fin 3) 1 2,
    c.encoder ∈ (PMF.iid q 2).support ∧
    c = BlockChannelCode.ofAcceptanceEvent c.encoder (event (5 / 2)) (by decide) ∧
    c.errorProbability W (by decide) ≤ 11 / 32 ∧ c.errorProbability W (by decide) ≤ 2 / 5 := by
  obtain ⟨c, hc, hdecoder, herror⟩ :=
    exists_blockChannelCode_errorProbability_le_of_acceptanceEvent q W (event (5 / 2))
      (by decide : 1 ≤ 2)
  have hrelax := mul_le_mul_of_nonneg_left
    (indepProd_infoDensityThresholdEvent_le q K (Real.log (5 / 2)))
    (by norm_num : 0 ≤ (2 : ℝ) - 1)
  exact ⟨c, hc, hdecoder, herror.trans event_bound.le,
    (herror.trans (add_le_add le_rfl hrelax)).trans relaxed_bound.le⟩

example : ∃ c : BlockChannelCode (Fin 3) (Fin 3) 1 2,
    c.encoder ∈ (PMF.iid q 2).support ∧
    c = BlockChannelCode.ofAcceptanceEvent c.encoder (event (5 / 2)) (by decide) ∧
    c.errorProbability W (by decide) ≤ 2 / 5 := by
  obtain ⟨c, hc, hdecoder, herror⟩ :=
    exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold q W (Real.log (5 / 2))
      (by decide : 1 ≤ 2)
  exact ⟨c, hc, hdecoder, herror.trans relaxed_bound.le⟩

/-! ### Comparison with constant decoding -/

private theorem constant_error {X Y : Type*} [Fintype Y] {n : ℕ}
    (c : BlockChannelCode X Y n 2) (V : X → PMF Y) (d : Fin 2)
    (hd : ∀ y, c.decoder y = d) : c.errorProbability V (by decide) = 1 / 2 := by
  classical
  rw [BlockChannelCode.errorProbability_eq_sum]
  simp_rw [hd]
  have hrow (m : Fin 2) :
      (∑ y, if d ≠ m then (PMF.memorylessChannel V n (c.encoder m) y).toReal else 0) =
        if d ≠ m then (1 : ℝ) else 0 := by
    by_cases h : d ≠ m <;> simp [h, PMF.sum_toReal]
  simp_rw [hrow]
  fin_cases d <;> norm_num [Fin.sum_univ_two, Fin.ext_iff]

example (c : BlockChannelCode (Fin 3) (Fin 3) 1 2) (d : Fin 2) (hd : ∀ y, c.decoder y = d) :
    c.errorProbability W (by decide) = 1 / 2 ∧
    11 / 32 < c.errorProbability W (by decide) ∧ 2 / 5 < c.errorProbability W (by decide) := by
  rw [constant_error c W d hd]
  norm_num

end

end LeanInfoTheory.Examples.ChannelCodingOneShotTernary
