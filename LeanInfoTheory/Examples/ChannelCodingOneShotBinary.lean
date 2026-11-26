/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCodingOneShot
import LeanInfoTheory.Probability.StandardChannels

/-!
# One-shot bounds for a noisy binary channel

For one use of the binary symmetric channel with crossover probability 1/8,
the strict threshold at log(3/2) accepts precisely matching bits. The exact
event masses give an error upper bound of 5/8. Relaxing the false-match term
gives 19/24 for the same supported code.
-/

namespace LeanInfoTheory.Examples.ChannelCodingOneShotBinary

open LeanInfoTheory.Shannon

noncomputable section

private abbrev Word := Fin 1 → Bool
private def word (a : Bool) : Word := fun _ => a
private abbrev fair := PMF.uniformOfFintype Bool
private theorem crossover_le_one : (1 / 8 : NNReal) ≤ 1 := by
  change (1 / 8 : ℝ) ≤ 1
  norm_num

private abbrev W := PMF.binarySymmetricChannel (1 / 8) crossover_le_one
private abbrev K := PMF.memorylessChannel W 1
private abbrev q := PMF.iid fair 1
private abbrev J := PMF.channelJoint q K
private abbrev Q := indepProd q (q.bind K)
private abbrev t : ℝ := Real.log (3 / 2)
private abbrev A := infoDensityThresholdEvent q K t

private theorem sum_words (f : Word → ℝ) : (∑ x, f x) = f (word true) + f (word false) := by
  rw [← (Equiv.funUnique (Fin 1) Bool).symm.sum_comp f, Fintype.sum_bool]
  rfl

private theorem input_atom (x : Word) : (q x).toReal = 1 / 2 := by
  change (PMF.finiteProduct (fun _ : Fin 1 => fair) x).toReal = _
  rw [PMF.finiteProduct_apply, Fin.prod_univ_one]
  norm_num [fair, PMF.uniformOfFintype_apply]

private theorem letter_row (a b : Bool) :
    (W a b).toReal = if a = b then 7 / 8 else 1 / 8 := by
  have hsub := ENNReal.toReal_sub_of_le
    (show ((1 / 8 : NNReal) : ENNReal) ≤ 1 by exact_mod_cast crossover_le_one) (by simp)
  norm_num at hsub
  cases a <;> cases b <;>
    norm_num [W, PMF.binarySymmetricChannel, PMF.binaryMixture_apply, PMF.pure_apply,
      ENNReal.coe_sub, hsub]

private theorem row_atom (x y : Word) :
    (K x y).toReal = if x 0 = y 0 then 7 / 8 else 1 / 8 := by
  change (PMF.productChannel (fun _ : Fin 1 => W) x y).toReal = _
  rw [PMF.productChannel_apply, Fin.prod_univ_one]
  exact letter_row (x 0) (y 0)

private theorem output_atom (y : Word) : ((q.bind K) y).toReal = 1 / 2 := by
  rw [PMF.bind_toReal_apply, sum_words]
  cases h : y 0 <;> norm_num [input_atom, row_atom, word, h]

private theorem joint_atom (x y : Word) :
    (J (x, y)).toReal = if x 0 = y 0 then 7 / 16 else 1 / 16 := by
  rw [PMF.channelJoint_apply, ENNReal.toReal_mul, input_atom, row_atom]
  by_cases h : x 0 = y 0 <;> norm_num [h]

private theorem independent_atom (x y : Word) : (Q (x, y)).toReal = 1 / 4 := by
  rw [indepProd_apply, ENNReal.toReal_mul, input_atom, output_atom]
  norm_num

private theorem exp_threshold : Real.exp t = 3 / 2 :=
  Real.exp_log (by norm_num : 0 < (3 / 2 : ℝ))

private theorem threshold_event : A = {z : Word × Word | z.1 0 = z.2 0} := by
  ext ⟨x, y⟩
  change Real.exp t * (Q (x, y)).toReal < (J (x, y)).toReal ↔ x 0 = y 0
  rw [exp_threshold, independent_atom, joint_atom]
  by_cases h : x 0 = y 0 <;> norm_num [h]

private theorem event_masses :
    (J.toOuterMeasure Aᶜ).toReal = 1 / 8 ∧ (Q.toOuterMeasure A).toReal = 1 / 2 := by
  classical
  rw [threshold_event]
  simp only [PMF.toOuterMeasure_toReal_eq_sum, Fintype.sum_prod_type, sum_words,
    Set.indicator_apply, joint_atom, independent_atom]
  norm_num [word]

private theorem exp_neg_threshold : Real.exp (-t) = 2 / 3 := by
  rw [Real.exp_neg, exp_threshold]
  norm_num

private theorem event_bound :
    (J.toOuterMeasure Aᶜ).toReal + ((2 : ℝ) - 1) * (Q.toOuterMeasure A).toReal = 5 / 8 := by
  rw [event_masses.1, event_masses.2]
  norm_num

private theorem relaxed_bound :
    (J.toOuterMeasure Aᶜ).toReal + ((2 : ℝ) - 1) * Real.exp (-t) = 19 / 24 := by
  rw [event_masses.1, exp_neg_threshold]
  norm_num

example : ∃ c : BlockChannelCode Bool Bool 1 2,
    c.encoder ∈ (PMF.iid q 2).support ∧
    c = BlockChannelCode.ofAcceptanceEvent c.encoder A (by decide) ∧
    c.errorProbability W (by decide) ≤ 5 / 8 ∧ c.errorProbability W (by decide) ≤ 19 / 24 := by
  obtain ⟨c, hc, hdecoder, herror⟩ :=
    exists_blockChannelCode_errorProbability_le_of_acceptanceEvent q W A (by decide : 1 ≤ 2)
  have hrelax : (J.toOuterMeasure Aᶜ).toReal + ((2 : ℝ) - 1) * (Q.toOuterMeasure A).toReal ≤
      (J.toOuterMeasure Aᶜ).toReal + ((2 : ℝ) - 1) * Real.exp (-t) :=
    add_le_add le_rfl (mul_le_mul_of_nonneg_left (indepProd_infoDensityThresholdEvent_le q K t)
      (by norm_num))
  exact ⟨c, hc, hdecoder, herror.trans event_bound.le, (herror.trans hrelax).trans relaxed_bound.le⟩

example : ∃ c : BlockChannelCode Bool Bool 1 2,
    c.encoder ∈ (PMF.iid q 2).support ∧
    c = BlockChannelCode.ofAcceptanceEvent c.encoder A (by decide) ∧
    c.errorProbability W (by decide) ≤ 19 / 24 := by
  obtain ⟨c, hc, hdecoder, herror⟩ :=
    exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold q W t (by decide : 1 ≤ 2)
  exact ⟨c, hc, hdecoder, herror.trans relaxed_bound.le⟩

end

end LeanInfoTheory.Examples.ChannelCodingOneShotBinary
