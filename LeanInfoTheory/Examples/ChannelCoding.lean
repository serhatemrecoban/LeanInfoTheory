/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCoding
import LeanInfoTheory.Shannon.StandardChannelCapacity

/-!
# Finite channel-converse consumers

A four-message code repeats one bit at two coordinates. Two supported messages
collide at each codeword, the actual input law is correlated, and its noiseless
decoding error is one half. The same code supplies both actual-law Markov chains,
both information-processing inequalities, uniform-source Fano and the capacity
bound. No independent-input or injectivity hypothesis is available.

Additional consumers exercise the finite, normalized and positive-rate forms,
singleton messages, zero and one blocklength, and an always-wrong decoder with
error one. One-letter identity and total erasure-fallback codes consume all four
standard capacity formulas. Their actual errors are computed from the public
one-letter law and error interfaces before applying the public coding converse.
Noisy cases retain both endpoints and the interior parameter one quarter.
-/

namespace LeanInfoTheory.Examples.ChannelCoding

noncomputable section

universe u v

open scoped BigOperators ENNReal
open LeanInfoTheory.Shannon

private def noiseless : Bool → PMF Bool := PMF.deterministicChannel id

private def repeated : BlockChannelCode Bool Bool 2 4 :=
  (fun m _ => decide (2 ≤ m.val), fun y => if y 0 then 2 else 0)

private def correlatedInput : PMF (Fin 2 → Bool) :=
  (PMF.uniformOfFintype (Fin 4)).map repeated.encoder

private def actualTriple : PMF (Fin 4 × (Fin 2 → Bool) × (Fin 2 → Bool)) :=
  repeated.messageInputOutputLaw noiseless (by decide)

private theorem repeated_supported_collision :
    (0 : Fin 4) ∈ (PMF.uniformOfFintype (Fin 4)).support ∧
      (1 : Fin 4) ∈ (PMF.uniformOfFintype (Fin 4)).support ∧
      (0 : Fin 4) ≠ 1 ∧ repeated.encoder 0 = repeated.encoder 1 := by
  norm_num [PMF.mem_support_iff, PMF.uniformOfFintype_apply,
    repeated, BlockChannelCode.encoder, Fin.ext_iff]

private theorem repeated_not_injective : ¬ Function.Injective repeated.encoder := by
  intro h
  exact repeated_supported_collision.2.2.1 (h repeated_supported_collision.2.2.2)

private theorem coordinate_mass (i : Fin 2) (b : Bool) :
    ((correlatedInput.map (fun x => x i)) b).toReal = 1 / 2 := by
  cases b <;>
    norm_num [correlatedInput, PMF.map_comp, Function.comp_def, PMF.map_apply,
      tsum_fintype, Fin.sum_univ_succ, repeated, BlockChannelCode.encoder,
      PMF.uniformOfFintype_apply]
  all_goals rw [ENNReal.toReal_add (by norm_num) (by norm_num)]
  all_goals norm_num

private theorem mixed_word_mass : correlatedInput (![false, true]) = 0 := by
  apply PMF.map_apply_eq_zero_of_notMem_range
  rintro ⟨m, hm⟩
  have h0 : decide (2 ≤ m.val) = false := congrFun hm 0
  have h1 : decide (2 ≤ m.val) = true := congrFun hm 1
  exact Bool.false_ne_true (h0.symm.trans h1)

private theorem repeated_input_correlated :
    correlatedInput ≠ PMF.finiteProduct
      (fun i : Fin 2 => correlatedInput.map (fun x => x i)) := by
  intro h
  have hm := congrArg (fun p : PMF (Fin 2 → Bool) => (p (![false, true])).toReal) h
  rw [mixed_word_mass, PMF.finiteProduct_apply, Fin.prod_univ_two,
    ENNReal.toReal_mul] at hm
  simp only [ENNReal.toReal_zero, coordinate_mass] at hm
  norm_num at hm

private theorem actual_input_output :
    actualTriple.map Prod.snd =
      PMF.channelJoint correlatedInput (PMF.memorylessChannel noiseless 2) :=
  repeated.messageInputOutputLaw_map_inputOutput noiseless (by decide)

private theorem noiseless_row (n : ℕ) (x : Fin n → Bool) :
    PMF.memorylessChannel noiseless n x = PMF.pure x := by
  unfold PMF.memorylessChannel noiseless
  rw [PMF.productChannel_deterministicChannel]
  rfl

private theorem repeated_error : repeated.errorProbability noiseless (by decide) = 1 / 2 := by
  classical
  rw [repeated.errorProbability_eq_sum]
  have hinner (m : Fin 4) :
      (∑ y, if repeated.decoder y ≠ m then
        (PMF.memorylessChannel noiseless 2 (repeated.encoder m) y).toReal else 0) =
      if repeated.decoder (repeated.encoder m) ≠ m then (1 : ℝ) else 0 := by
    rw [Finset.sum_eq_single (repeated.encoder m)]
    · simp [noiseless_row]
    · intro y _ hy
      simp [noiseless_row, PMF.pure_apply, hy]
    · simp
  simp_rw [hinner]
  have h01 : (0 : Fin 4) ≠ 1 := by decide
  have h23 : (2 : Fin 4) ≠ (2 : Fin 3).succ := by decide
  norm_num [Fin.sum_univ_succ, repeated, BlockChannelCode.encoder,
    BlockChannelCode.decoder, h01, h23]

private theorem repeated_markov_chains :
    IsMarkovChain actualTriple ∧
      IsMarkovChainOf actualTriple Prod.fst (fun z => z.2.2)
        (fun z => repeated.decoder z.2.2) :=
  ⟨repeated.isMarkovChain_messageInputOutputLaw noiseless (by decide),
    repeated.isMarkovChainOf_decoder noiseless (by decide)⟩

private theorem repeated_information_processing :
    mutualInfoOf actualTriple Prod.fst (fun z => repeated.decoder z.2.2) ≤
        mutualInfoOf actualTriple Prod.fst (fun z => z.2.2) ∧
      mutualInfoOf actualTriple Prod.fst (fun z => z.2.2) ≤
        mutualInfoOf actualTriple (fun z => z.2.1) (fun z => z.2.2) :=
  ⟨repeated.mutualInfoOf_decoder_le noiseless (by decide),
    repeated.mutualInfoOf_message_le_input noiseless (by decide)⟩

private theorem repeated_fano :
    Real.log 4 - Real.log 2 - (1 / 2 : ℝ) * Real.log 4 ≤
      mutualInfoOf actualTriple Prod.fst (fun z => z.2.2) := by
  have h := mutualInfo_fano_lower_bound_of_uniform_source
    (repeated.messageOutputLaw noiseless (by decide)) repeated.decoder
    (repeated.messageOutputLaw_map_fst noiseless (by decide))
  change Real.log 4 - Real.log 2 -
    repeated.errorProbability noiseless (by decide) * Real.log 4 ≤
      mutualInfo (repeated.messageOutputLaw noiseless (by decide)) at h
  rw [repeated_error] at h
  simpa only [mutualInfoOf, actualTriple,
    repeated.messageInputOutputLaw_map_messageOutput] using h

private theorem repeated_input_information_bound :
    mutualInfoOf actualTriple (fun z => z.2.1) (fun z => z.2.2) ≤
      2 * channelCapacity noiseless := by
  change mutualInfo (actualTriple.map Prod.snd) ≤ _
  rw [actual_input_output]
  exact mutualInfo_channelJoint_memorylessChannel_le noiseless 2 correlatedInput

private theorem repeated_fano_to_capacity :
    Real.log 4 - Real.log 2 - (1 / 2 : ℝ) * Real.log 4 ≤
      2 * channelCapacity noiseless :=
  repeated_fano.trans (repeated_information_processing.2.trans repeated_input_information_bound)

private theorem repeated_finite_converse :
    (1 - (1 / 2 : ℝ)) * Real.log 4 ≤ 2 * channelCapacity noiseless + Real.log 2 := by
  simpa only [repeated_error, Nat.cast_ofNat] using
    repeated.one_sub_errorProbability_mul_log_le noiseless (by decide)

private theorem repeated_normalized_converse :
    (1 - (1 / 2 : ℝ)) * codeRate 2 4 ≤ channelCapacity noiseless + Real.log 2 / 2 := by
  simpa only [repeated_error, Nat.cast_ofNat] using
    repeated.one_sub_errorProbability_mul_codeRate_le noiseless (by decide) (by decide)

private theorem repeated_pointwise_converse :
    1 - channelCapacity noiseless / codeRate 2 4 -
        Real.log 2 / (2 * codeRate 2 4) ≤ (1 / 2 : ℝ) := by
  have hrate : 0 < codeRate 2 4 :=
    div_pos (Real.log_pos (by norm_num)) (by norm_num)
  simpa only [repeated_error, Nat.cast_ofNat] using
    repeated.one_sub_channelCapacity_div_sub_le_errorProbability
      noiseless (by decide) (by decide) hrate le_rfl

/-! ## Explicit finite-converse boundaries -/

private theorem singleton_message_bound {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B] {n : ℕ}
    (c : BlockChannelCode A B n 1) (W : A → PMF B) :
    0 ≤ (n : ℝ) * channelCapacity W + Real.log 2 := by
  simpa using c.one_sub_errorProbability_mul_log_le W (by decide)

private theorem zero_length_bound {A : Type u} {B : Type v}
    [Finite A] [Nonempty A] [Finite B] {M : ℕ}
    (c : BlockChannelCode A B 0 M) (W : A → PMF B) (hM : 1 ≤ M) :
    (1 / (M : ℝ)) * Real.log M ≤ Real.log 2 := by
  let : Fintype A := Fintype.ofFinite A
  let : Fintype B := Fintype.ofFinite B
  have h := c.one_sub_errorProbability_mul_log_le W hM
  rw [c.errorProbability_zero] at h
  simpa using h

private theorem one_length_bound {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B] {M : ℕ}
    (c : BlockChannelCode A B 1 M) (W : A → PMF B) (hM : 1 ≤ M) :
    (1 - c.errorProbability W hM) * Real.log M ≤ channelCapacity W + Real.log 2 := by
  simpa using c.one_sub_errorProbability_mul_log_le W hM

private def alwaysWrong : BlockChannelCode Bool Bool 1 2 :=
  (fun m _ => decide (m.val = 1), fun y => if y 0 then 0 else 1)

private theorem alwaysWrong_error :
    alwaysWrong.errorProbability noiseless (by decide) = 1 := by
  rw [alwaysWrong.errorProbability_one_length_eq_sum]
  have h01 : (0 : Fin 2) ≠ 1 := by decide
  have h10 : (1 : Fin 2) ≠ 0 := by decide
  norm_num [Fin.sum_univ_succ, Fintype.sum_bool, alwaysWrong,
    BlockChannelCode.encoder, BlockChannelCode.decoder, noiseless,
    PMF.deterministicChannel, PMF.pure_apply, h01, h10]

private theorem complete_failure_bound : 0 ≤ channelCapacity noiseless + Real.log 2 := by
  have h := alwaysWrong.one_sub_errorProbability_mul_log_le noiseless (by decide)
  simpa only [alwaysWrong_error, sub_self, zero_mul, Nat.cast_one, one_mul] using h

/-! ## One-letter standard channels with their actual decoding errors -/

private def identityCode : BlockChannelCode Bool Bool 1 2 :=
  (fun m _ => decide (m.val = 1), fun y => if y 0 then 1 else 0)

private theorem identityCode_one_law (W : Bool → PMF Bool) :
    (identityCode.messageOutputLaw W (by decide)).map (fun z => (z.1, z.2 0)) =
      PMF.channelJoint (PMF.uniformOfFintype (Fin 2))
        (fun m => W (decide (m.val = 1))) :=
  identityCode.messageOutputLaw_one_map W (by decide)

private theorem identityCode_noiseless_error :
    identityCode.errorProbability noiseless (by decide) = 0 := by
  rw [identityCode.errorProbability_one_length_eq_sum]
  have h01 : (0 : Fin 2) ≠ 1 := by decide
  have h10 : (1 : Fin 2) ≠ 0 := by decide
  norm_num [Fin.sum_univ_succ, Fintype.sum_bool, identityCode,
    BlockChannelCode.encoder, BlockChannelCode.decoder, noiseless,
    PMF.deterministicChannel, PMF.pure_apply, h01, h10]

private theorem identityCode_noiseless_bound : Real.log 2 ≤ Real.log 2 + Real.log 2 := by
  have h := identityCode.one_sub_errorProbability_mul_log_le noiseless (by decide)
  have hcapacity : channelCapacity noiseless = Real.log 2 := by
    simpa only [noiseless, Fintype.card_bool, Nat.cast_ofNat] using
      channelCapacity_deterministicChannel_id (A := Bool)
  simpa only [identityCode_noiseless_error, sub_zero, one_mul, Nat.cast_ofNat,
    Nat.cast_one, hcapacity] using h

private def randomOutput : PMF Bool := PMF.uniformOfFintype Bool

private theorem identityCode_constant_error :
    identityCode.errorProbability (fun _ => randomOutput) (by decide) = (1 / 2 : ℝ) := by
  rw [identityCode.errorProbability_one_length_eq_sum]
  have h01 : (0 : Fin 2) ≠ 1 := by decide
  have h10 : (1 : Fin 2) ≠ 0 := by decide
  norm_num [Fin.sum_univ_succ, Fintype.sum_bool, identityCode,
    BlockChannelCode.encoder, BlockChannelCode.decoder, randomOutput,
    PMF.uniformOfFintype_apply, h01, h10]

private theorem identityCode_constant_bound :
    (1 - (1 / 2 : ℝ)) * Real.log 2 ≤ Real.log 2 := by
  have h := identityCode.one_sub_errorProbability_mul_log_le
    (fun _ => randomOutput) (by decide)
  simpa only [identityCode_constant_error, channelCapacity_const, Nat.cast_ofNat,
    Nat.cast_one, mul_zero, zero_add] using h

private theorem identityCode_bsc_error (ε : NNReal) (hε : ε ≤ 1) :
    identityCode.errorProbability (PMF.binarySymmetricChannel ε hε) (by decide) = (ε : ℝ) := by
  rw [identityCode.errorProbability_one_length_eq_sum]
  have h01 : (0 : Fin 2) ≠ 1 := by decide
  have h10 : (1 : Fin 2) ≠ 0 := by decide
  norm_num [Fin.sum_univ_succ, Fintype.sum_bool, identityCode,
    BlockChannelCode.encoder, BlockChannelCode.decoder, PMF.binarySymmetricChannel,
    PMF.binaryMixture_apply, PMF.pure_apply, h01, h10]
  ring

private theorem identityCode_bsc_bound (ε : NNReal) (hε : ε ≤ 1) :
    (1 - (ε : ℝ)) * Real.log 2 ≤
      (Real.log 2 - Real.binEntropy (ε : ℝ)) + Real.log 2 := by
  have h := identityCode.one_sub_errorProbability_mul_log_le
    (PMF.binarySymmetricChannel ε hε) (by decide)
  simpa only [identityCode_bsc_error, channelCapacity_binarySymmetricChannel,
    Nat.cast_ofNat, Nat.cast_one, one_mul] using h

private theorem bsc_endpoint_errors_and_bounds :
    identityCode.errorProbability (PMF.binarySymmetricChannel 0 (by norm_num)) (by decide) = 0 ∧
      identityCode.errorProbability (PMF.binarySymmetricChannel 1 (by norm_num)) (by decide) = 1 ∧
      Real.log 2 ≤ Real.log 2 + Real.log 2 ∧
      (0 : ℝ) ≤ Real.log 2 + Real.log 2 := by
  refine ⟨by simpa using identityCode_bsc_error 0 (by norm_num),
    by simpa using identityCode_bsc_error 1 (by norm_num), ?_, ?_⟩
  · simpa using identityCode_bsc_bound 0 (by norm_num)
  · simpa using identityCode_bsc_bound 1 (by norm_num)

private theorem quarter_le_one : (1 / 4 : NNReal) ≤ 1 := by
  change (1 / 4 : ℝ) ≤ 1
  norm_num

private theorem bsc_quarter_error_and_bound :
    identityCode.errorProbability (PMF.binarySymmetricChannel (1 / 4) quarter_le_one)
        (by decide) = (1 / 4 : ℝ) ∧
      (3 / 4 : ℝ) * Real.log 2 ≤
        (Real.log 2 - Real.binEntropy (1 / 4)) + Real.log 2 := by
  constructor
  · simpa using identityCode_bsc_error (1 / 4) quarter_le_one
  · convert identityCode_bsc_bound (1 / 4) quarter_le_one using 1 <;> norm_num

private def erasureCode : BlockChannelCode Bool (Option Bool) 1 2 :=
  (fun m _ => decide (m.val = 1), fun y => match y 0 with
    | some true => 1
    | _ => 0)

private theorem erasureCode_total_decoder :
    erasureCode.decoder (fun _ => none) = 0 ∧
      erasureCode.decoder (fun _ => some false) = 0 ∧
      erasureCode.decoder (fun _ => some true) = 1 := by
  decide

private theorem erasureCode_one_law (ε : NNReal) (hε : ε ≤ 1) :
    (erasureCode.messageOutputLaw (PMF.binaryErasureChannel ε hε) (by decide)).map
        (fun z => (z.1, z.2 0)) =
      PMF.channelJoint (PMF.uniformOfFintype (Fin 2))
        (fun m => PMF.binaryErasureChannel ε hε (decide (m.val = 1))) :=
  erasureCode.messageOutputLaw_one_map (PMF.binaryErasureChannel ε hε) (by decide)

private theorem erasureCode_bec_error (ε : NNReal) (hε : ε ≤ 1) :
    erasureCode.errorProbability (PMF.binaryErasureChannel ε hε) (by decide) = (ε : ℝ) / 2 := by
  rw [erasureCode.errorProbability_one_length_eq_sum]
  have h01 : (0 : Fin 2) ≠ 1 := by decide
  have h10 : (1 : Fin 2) ≠ 0 := by decide
  norm_num [Fin.sum_univ_succ, Fintype.sum_option, Fintype.sum_bool, erasureCode,
    BlockChannelCode.encoder, BlockChannelCode.decoder, PMF.binaryErasureChannel,
    PMF.binaryMixture_apply, PMF.pure_apply, h01, h10, Option.some_ne_none,
    (Option.some_ne_none true).symm, (Option.some_ne_none false).symm]
  ring

private theorem erasureCode_bec_bound (ε : NNReal) (hε : ε ≤ 1) :
    (1 - (ε : ℝ) / 2) * Real.log 2 ≤ (1 - (ε : ℝ)) * Real.log 2 + Real.log 2 := by
  have h := erasureCode.one_sub_errorProbability_mul_log_le
    (PMF.binaryErasureChannel ε hε) (by decide)
  simpa only [erasureCode_bec_error, channelCapacity_binaryErasureChannel,
    Nat.cast_ofNat, Nat.cast_one, one_mul] using h

private theorem bec_endpoint_errors_and_bounds :
    erasureCode.errorProbability (PMF.binaryErasureChannel 0 (by norm_num)) (by decide) = 0 ∧
      erasureCode.errorProbability (PMF.binaryErasureChannel 1 (by norm_num))
        (by decide) = (1 / 2 : ℝ) ∧
      Real.log 2 ≤ Real.log 2 + Real.log 2 ∧
      (1 / 2 : ℝ) * Real.log 2 ≤ Real.log 2 := by
  refine ⟨by simpa using erasureCode_bec_error 0 (by norm_num),
    by simpa using erasureCode_bec_error 1 (by norm_num), ?_, ?_⟩
  · simpa using erasureCode_bec_bound 0 (by norm_num)
  · convert erasureCode_bec_bound 1 (by norm_num) using 1 <;> norm_num

private theorem bec_quarter_error_and_bound :
    erasureCode.errorProbability (PMF.binaryErasureChannel (1 / 4) quarter_le_one)
        (by decide) = (1 / 8 : ℝ) ∧
      (7 / 8 : ℝ) * Real.log 2 ≤ (3 / 4 : ℝ) * Real.log 2 + Real.log 2 := by
  constructor
  · convert erasureCode_bec_error (1 / 4) quarter_le_one using 1
    norm_num
  · convert erasureCode_bec_bound (1 / 4) quarter_le_one using 1 <;> norm_num

end

end LeanInfoTheory.Examples.ChannelCoding
