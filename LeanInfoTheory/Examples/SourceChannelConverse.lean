/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceChannelConverse
import LeanInfoTheory.Shannon.StandardChannelCapacity
import LeanInfoTheory.Examples.StochasticChannels

/-! # Using the source–channel converse

The entropy excess over the block capacity and the binary Fano overhead is
bounded by the reconstruction-error term, even for an arbitrary word encoder.
Above capacity, every family of encoders and reconstruction decoders fails
the vanishing-error condition. Concrete examples check the induced input law,
strictly positive error on a constant-output channel, and singleton sources.
-/

namespace LeanInfoTheory.Examples.SourceChannelConverse

open LeanInfoTheory.Shannon Filter

universe u v w

variable {S : Type u} {X : Type v} {Y : Type w}
  [Fintype S] [Fintype X] [Nonempty X] [Fintype Y]

example (p : PMF S) (W : X → PMF Y) (n : ℕ)
    (E : (Fin n → S) → (Fin n → X)) (D : (Fin n → Y) → (Fin n → S)) :
    (n : ℝ) * entropy p - ((n : ℝ) * channelCapacity W + Real.log 2) ≤
      sourceChannelErrorProbability p W n E D * (n : ℝ) * Real.log (Fintype.card S : ℝ) := by
  linarith only [mul_entropy_le_mul_channelCapacity_add_error p W n E D]

example (p : PMF S) (W : X → PMF Y)
    (E : (Fin 0 → S) → (Fin 0 → X)) (D : (Fin 0 → Y) → (Fin 0 → S)) :
    (0 : ℝ) ≤ Real.log 2 := by
  simpa using mul_entropy_le_mul_channelCapacity_add_error p W 0 E D

example (p : PMF S) (W : X → PMF Y)
    (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X))
    (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S))
    (he : Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n)) atTop (nhds 0)) :
    entropy p ≤ channelCapacity W :=
  entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability p W E D he

example (p : PMF S) (W : X → PMF Y)
    (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X))
    (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S))
    (h : channelCapacity W < entropy p) :
    ¬ Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n)) atTop (nhds 0) :=
  fun he =>
    h.not_ge (entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability p W E D he)

/-! ## Two fair source bits and a repeated noiseless input -/

namespace RepeatedBit

noncomputable section

private abbrev Word := Fin 2 → Bool
private abbrev fair := PMF.uniformOfFintype Bool
private abbrev source := PMF.iid fair 2
private def dup (b : Bool) : Word := fun _ => b
private def encode (s : Word) : Word := dup (s 0)
private abbrev noiseless := PMF.deterministicChannel (id : Bool → Bool)
private abbrev rows := PMF.memorylessChannel noiseless 2
private abbrev sourceOutput := PMF.channelJoint source (fun s => rows (encode s))
private abbrev input := source.map encode
private abbrev inputOutput := PMF.channelJoint input rows

private theorem rows_eq : rows = PMF.deterministicChannel id := by
  unfold rows PMF.memorylessChannel noiseless
  rw [PMF.productChannel_deterministicChannel]
  rfl

private theorem input_eq : input = fair.map dup := by
  have h : source.map (fun s => s 0) = fair := PMF.finiteProduct_map_eval _ 0
  rw [← h, PMF.map_comp]
  rfl

private theorem dup_injective : Function.Injective dup :=
  fun _ _ h => congrFun h 0

private theorem source_atom (s : Word) : (source s).toReal = 1 / 4 := by
  norm_num [source, PMF.iid, PMF.finiteProduct_apply, Fin.prod_univ_two, fair,
    PMF.uniformOfFintype_apply, ENNReal.toReal_mul]

private theorem sourceOutput_graph :
    sourceOutput = source.map (fun s => (s, encode s)) := by
  rw [sourceOutput, rows_eq]
  exact PMF.channelJoint_deterministicChannel source encode

example (s y : Word) :
    (sourceOutput (s, y)).toReal = if y = dup (s 0) then 1 / 4 else 0 := by
  classical
  rw [sourceOutput, PMF.channelJoint_apply, rows_eq, PMF.deterministicChannel_apply]
  by_cases h : y = dup (s 0) <;>
    simp [h, encode, PMF.pure_apply, source_atom]

example : sourceOutput.map (fun z => (encode z.1, z.2)) = inputOutput := by
  simp only [sourceOutput, inputOutput, input, PMF.channelJoint, PMF.map_bind,
    PMF.bind_map, PMF.map_comp, Function.comp_def]

private theorem inputOutput_eq :
    inputOutput = fair.map (fun b => (dup b, dup b)) := by
  rw [inputOutput, rows_eq, PMF.channelJoint_deterministicChannel, input_eq, PMF.map_comp]
  rfl

example (b : Bool) : (inputOutput (dup b, dup b)).toReal = 1 / 2 := by
  rw [inputOutput_eq, PMF.map_apply_of_injective fair
    (fun _ _ h => dup_injective (congrArg Prod.fst h)) b]
  norm_num [fair, PMF.uniformOfFintype_apply]

example (x y : Word) (h : ∀ b : Bool, (dup b, dup b) ≠ (x, y)) :
    inputOutput (x, y) = 0 := by
  rw [inputOutput_eq]
  exact PMF.map_apply_eq_zero_of_notMem_range fair (fun ⟨b, hb⟩ => h b hb)

private theorem mismatch (a b : Bool) :
    encode ![a, b] ≠ ![a, b] ↔ a ≠ b := by
  cases a <;> cases b <;> decide

private theorem actual_error :
    sourceChannelErrorProbability fair noiseless 2 encode id = 1 / 2 := by
  classical
  change ((sourceOutput.map (fun z => decodingErrorIndicator id z.1 z.2)) true).toReal = _
  rw [sourceOutput_graph, PMF.map_comp, PMF.map_apply, tsum_fintype]
  have sumWords (f : Word → ENNReal) : (∑ s, f s) = ∑ a : Bool, ∑ b : Bool, f ![a, b] := by
    rw [← (finTwoArrowEquiv Bool).symm.sum_comp f, Fintype.sum_prod_type]
    rfl
  rw [sumWords]
  simp only [Function.comp_apply, eq_comm (a := true), decodingErrorIndicator_eq_true_iff,
    id_eq, mismatch, Fintype.sum_bool]
  norm_num [ENNReal.toReal_add, PMF.apply_ne_top, source_atom]

example : 2 * entropy fair ≤ 2 * channelCapacity noiseless + Real.log 2 +
    (1 / 2 : ℝ) * 2 * Real.log 2 := by
  simpa only [actual_error, Nat.cast_ofNat, Fintype.card_bool] using
    mul_entropy_le_mul_channelCapacity_add_error fair noiseless 2 encode id

private theorem input_entropy : entropy input = Real.log 2 := by
  rw [input_eq, entropy_map_injective fair dup_injective, entropy_uniformOfFintype]
  norm_num

example : mutualInfo inputOutput = Real.log 2 := by
  rw [inputOutput, rows_eq, PMF.channelJoint_deterministicChannel]
  exact (mutualInfo_map_diag input).trans input_entropy

private theorem source_information : mutualInfo sourceOutput = Real.log 2 := by
  rw [sourceOutput, rows_eq]
  change mutualInfo (PMF.channelJoint source (PMF.deterministicChannel encode)) = _
  rw [mutualInfo_channelJoint_eq_entropy_bind_sub_sum, PMF.bind_deterministicChannel]
  simpa only [PMF.deterministicChannel_apply, entropy_pure, mul_zero, Finset.sum_const_zero,
    sub_zero] using input_entropy

example : condEntropy sourceOutput = Real.log 2 := by
  have h := mutualInfo_eq_entropy_fstMarginal_sub_condEntropy sourceOutput
  rw [source_information, fstMarginal, sourceOutput, PMF.channelJoint_map_fst, entropy_iid,
    entropy_uniformOfFintype] at h
  norm_num at h
  linarith only [h]

private theorem input_eval (i : Fin 2) : input.map (fun x => x i) = fair := by
  rw [input_eq, PMF.map_comp]
  exact PMF.map_id fair

example : mutualInfo (PMF.channelJoint
    (PMF.finiteProduct (fun i : Fin 2 => input.map (fun x => x i))) rows) = 2 * Real.log 2 := by
  simp only [input_eval, rows_eq, PMF.channelJoint_deterministicChannel, id_eq, mutualInfo_map_diag]
  change entropy (PMF.iid fair 2) = _
  rw [entropy_iid, entropy_uniformOfFintype]
  norm_num

end

end RepeatedBit

/-! A fixed output carries no information. The finite bound already forces
error above one half on four symbols from the biased Boolean source. -/

open StochasticChannels (biasedLaw)

private noncomputable abbrev silentChannel (_ : Bool) : PMF Bool := PMF.pure false

private theorem biased_four_symbol_gap :
    4 * entropy biasedLaw - 3 * Real.log 2 = Real.log (32 / 27 : ℝ) := by
  have ht : (biasedLaw true).toReal = 3 / 4 := by
    norm_num [biasedLaw, PMF.ofFintype_apply]
  have hs := PMF.sum_toReal biasedLaw
  rw [Fintype.sum_bool, ht] at hs
  have hf : (biasedLaw false).toReal = 1 / 4 := by linarith
  have hcomp : 1 - (biasedLaw true).toReal = (biasedLaw false).toReal := by
    rw [ht, hf]
    norm_num
  rw [entropy_bool, Real.binEntropy, hcomp, hf, ht, Real.log_inv, Real.log_inv,
    Real.log_div (by norm_num : (3 : ℝ) ≠ 0) (by norm_num : (4 : ℝ) ≠ 0),
    Real.log_div (by norm_num : (1 : ℝ) ≠ 0) (by norm_num : (4 : ℝ) ≠ 0), Real.log_one,
    Real.log_div (by norm_num : (32 : ℝ) ≠ 0) (by norm_num : (27 : ℝ) ≠ 0),
    show (4 : ℝ) = 2 ^ 2 by norm_num, show (32 : ℝ) = 2 ^ 5 by norm_num,
    show (27 : ℝ) = 3 ^ 3 by norm_num]
  simp only [Real.log_pow]
  ring

example (E D : (Fin 4 → Bool) → (Fin 4 → Bool)) :
    1 / 2 < sourceChannelErrorProbability biasedLaw silentChannel 4 E D := by
  have gap : 0 < 4 * entropy biasedLaw - 3 * Real.log 2 := by
    rw [biased_four_symbol_gap]
    exact Real.log_pos (by norm_num)
  have bound := mul_entropy_le_mul_channelCapacity_add_error biasedLaw silentChannel 4 E D
  rw [show channelCapacity silentChannel = 0 from channelCapacity_const (A := Bool) _] at bound
  norm_num only [Fintype.card_bool, Nat.cast_ofNat, mul_zero, zero_add] at bound
  by_contra! he
  have hprod := mul_le_mul_of_nonneg_right he (show 0 ≤ 4 * Real.log 2 by positivity)
  linarith

/-! For a fair Boolean source the asymptotic converse rules out vanishing
error for every sequence of word encoders and reconstruction decoders. -/

example (E D : ∀ n : ℕ, (Fin n → Bool) → (Fin n → Bool)) :
    ¬ Tendsto (fun n => sourceChannelErrorProbability (PMF.uniformOfFintype Bool)
      silentChannel n (E n) (D n)) atTop (nhds 0) := by
  intro he
  have h := entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability
    (PMF.uniformOfFintype Bool) silentChannel E D he
  rw [entropy_uniformOfFintype, Fintype.card_bool, Nat.cast_ofNat,
    show channelCapacity silentChannel = 0 from channelCapacity_const (A := Bool) _] at h
  exact (Real.log_pos (by norm_num : (1 : ℝ) < 2)).not_ge h

/-! If there is only one possible word, every decoder returns it on every
outcome. This covers singleton sources at all lengths and empty words. -/

omit [Fintype X] [Nonempty X] in
private theorem unique_word_error (p : PMF S) (W : X → PMF Y) (n : ℕ)
    [Subsingleton (Fin n → S)] (E : (Fin n → S) → (Fin n → X))
    (D : (Fin n → Y) → (Fin n → S)) : sourceChannelErrorProbability p W n E D = 0 := by
  classical
  rw [sourceChannelErrorProbability, decodingErrorProbability_eq_sum]
  exact Finset.sum_eq_zero fun z _ => if_neg (not_not_intro (Subsingleton.elim (D z.2) z.1))

private theorem unit_entropy (p : PMF Unit) : entropy p = 0 := by
  apply le_antisymm _ (entropy_nonneg p)
  simpa using entropy_le_log_card p

example (n : ℕ) : Real.log (Fintype.card (Fin n → Unit) : ℝ) = 0 := by simp

private theorem unit_converse (p : PMF Unit) (W : X → PMF Y)
    (E : ∀ n : ℕ, (Fin n → Unit) → (Fin n → X))
    (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → Unit)) : 0 ≤ channelCapacity W := by
  have he : Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n)) atTop (nhds 0) := by
    simpa only [unique_word_error] using
      (tendsto_const_nhds : Tendsto (fun _ : ℕ => (0 : ℝ)) atTop (nhds 0))
  simpa only [unit_entropy] using
    entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability p W E D he

example (p : PMF Unit) (E : ∀ n : ℕ, (Fin n → Unit) → (Fin n → Bool))
    (D : ∀ n : ℕ, (Fin n → Bool) → (Fin n → Unit)) :
    0 ≤ channelCapacity silentChannel ∧ channelCapacity silentChannel = entropy p := by
  exact ⟨unit_converse p silentChannel E D,
    (channelCapacity_const (A := Bool) (PMF.pure false)).trans (unit_entropy p).symm⟩

example (p : PMF Bool) (W : X → PMF Y)
    (E : (Fin 0 → Bool) → (Fin 0 → X)) (D : (Fin 0 → Y) → (Fin 0 → Bool)) :
    sourceChannelErrorProbability p W 0 E D = 0 := unique_word_error p W 0 E D

end LeanInfoTheory.Examples.SourceChannelConverse
