/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.StandardChannels
import LeanInfoTheory.Shannon.BinaryEntropy
import LeanInfoTheory.Shannon.ChannelCapacity
import LeanInfoTheory.Shannon.SemanticBridge.Convexity
import LeanInfoTheory.Shannon.Units

/-!
# Information capacity of standard finite channels

A noiseless channel preserves the input entropy. Its information capacity is the
logarithm of the finite input alphabet size, attained by the uniform input law.
An input-independent channel has zero mutual information for every input law,
so every input law attains its zero capacity.

The binary symmetric channel has capacity `log 2 - binEntropy ε`, attained by
the uniform Boolean input throughout the closed crossover interval `[0, 1]`.
Its all-input objective is output entropy minus the common row entropy.

The binary erasure channel preserves the input entropy with weight `1 - ε`.
Its capacity is `(1 - ε) * log 2`, attained by the uniform Boolean input,
including the all-erasure endpoint where every input attains zero.

The `_bits` formulas apply `natsToBits` to these capacities and give explicit
scalar consequences in bits. The underlying information measures remain in nats.

These finite-alphabet adaptations of CT91 §§8.1.1 and 8.3 use canonical nats and
the existing raw PMF channels. They concern information capacity; no operational
coding theorem is asserted. The binary symmetric and erasure calculations adapt
CT91 §§8.1.4–8.1.5 to the same natural-logarithm convention. See `docs/references.md`.
-/

open scoped BigOperators

namespace LeanInfoTheory.Shannon

universe u v

private theorem noiseless_objective {A : Type u} [Fintype A] (p : PMF A) :
    mutualInfo (PMF.channelJoint p (PMF.deterministicChannel (id : A → A))) =
      entropy p := by
  rw [PMF.channelJoint_deterministicChannel]
  exact mutualInfo_map_diag p

private theorem noiseless_objective_le_log_card
    {A : Type u} [Fintype A] [Nonempty A] (p : PMF A) :
    mutualInfo (PMF.channelJoint p (PMF.deterministicChannel (id : A → A))) ≤
      Real.log (Fintype.card A) := by
  rw [noiseless_objective]
  exact entropy_le_log_card p

/-- A noiseless finite channel has information capacity equal to the logarithm
of its input alphabet size in nats. The uniform input attains this value. -/
theorem channelCapacity_deterministicChannel_id
    {A : Type u} [Fintype A] [Nonempty A] :
    channelCapacity (PMF.deterministicChannel (id : A → A)) =
      Real.log (Fintype.card A) := by
  apply le_antisymm
  · exact (channelCapacity_le_iff _ _).2 noiseless_objective_le_log_card
  · have h := mutualInfo_channelJoint_le_channelCapacity (PMF.uniformOfFintype A)
      (PMF.deterministicChannel (id : A → A))
    rwa [noiseless_objective, entropy_uniformOfFintype] at h

private theorem uniform_attains_noiseless_capacity
    {A : Type u} [Fintype A] [Nonempty A] :
    mutualInfo (PMF.channelJoint (PMF.uniformOfFintype A)
      (PMF.deterministicChannel (id : A → A))) =
        channelCapacity (PMF.deterministicChannel (id : A → A)) := by
  rw [noiseless_objective, entropy_uniformOfFintype, channelCapacity_deterministicChannel_id]

private theorem constant_objective {A : Type u} {B : Type v}
    [Fintype A] [Fintype B] (p : PMF A) (r : PMF B) :
    mutualInfo (PMF.channelJoint p (fun _ : A => r)) = 0 := by
  change mutualInfo (indepProd p r) = 0
  exact (mutualInfo_eq_zero_iff_isIndependent _).2 (isIndependent_indepProd p r)

/-- An input-independent finite channel has zero information capacity.
The supplied output law requires no separate nonempty-output assumption. -/
theorem channelCapacity_const {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B] (r : PMF B) :
    channelCapacity (fun _ : A => r) = 0 := by
  apply le_antisymm
  · exact (channelCapacity_le_iff _ _).2 fun p => (constant_objective p r).le
  · have h := mutualInfo_channelJoint_le_channelCapacity
      (PMF.pure (Classical.choice (inferInstance : Nonempty A))) (fun _ : A => r)
    rwa [constant_objective] at h

private theorem every_input_attains_constant_capacity
    {A : Type u} {B : Type v} [Fintype A] [Nonempty A] [Fintype B]
    (p : PMF A) (r : PMF B) :
    mutualInfo (PMF.channelJoint p (fun _ : A => r)) =
      channelCapacity (fun _ : A => r) := by
  rw [constant_objective, channelCapacity_const]

private theorem binarySymmetricChannel_true_mass_toReal
    (ε : NNReal) (hε : ε ≤ 1) (a : Bool) :
    (PMF.binarySymmetricChannel ε hε a true).toReal =
      if a then 1 - (ε : ℝ) else (ε : ℝ) := by
  cases a <;>
    simp [PMF.binarySymmetricChannel, PMF.binaryMixture_apply, PMF.pure_apply]
  simpa using ENNReal.toReal_sub_of_le
    (show (ε : ENNReal) ≤ 1 by exact_mod_cast hε) (by simp)

private theorem binarySymmetricChannel_row_entropy
    (ε : NNReal) (hε : ε ≤ 1) (a : Bool) :
    entropy (PMF.binarySymmetricChannel ε hε a) = Real.binEntropy (ε : ℝ) := by
  rw [entropy_bool, binarySymmetricChannel_true_mass_toReal]
  cases a <;> simp

/-- Mutual information through a binary symmetric channel is output entropy
minus binary entropy of the crossover probability, in nats. All input laws and
both crossover endpoints are included. -/
theorem mutualInfo_channelJoint_binarySymmetricChannel
    (p : PMF Bool) (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint p (PMF.binarySymmetricChannel ε hε)) =
      entropy (p.bind (PMF.binarySymmetricChannel ε hε)) - Real.binEntropy (ε : ℝ) := by
  rw [mutualInfo_channelJoint_eq_entropy_bind_sub_sum]
  simp_rw [binarySymmetricChannel_row_entropy]
  rw [← Finset.sum_mul, PMF.sum_toReal, one_mul]

private theorem binarySymmetricChannel_objective_le
    (p : PMF Bool) (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint p (PMF.binarySymmetricChannel ε hε)) ≤
      Real.log 2 - Real.binEntropy (ε : ℝ) := by
  rw [mutualInfo_channelJoint_binarySymmetricChannel]
  exact sub_le_sub_right
    (by simpa using entropy_le_log_card (p.bind (PMF.binarySymmetricChannel ε hε))) _

private theorem binarySymmetricChannel_uniform_true_mass
    (ε : NNReal) (hε : ε ≤ 1) :
    (((PMF.uniformOfFintype Bool).bind (PMF.binarySymmetricChannel ε hε)) true).toReal =
      (1 / 2 : ℝ) := by
  rw [PMF.bind_toReal_apply, Fintype.sum_bool]
  norm_num [PMF.uniformOfFintype_apply, binarySymmetricChannel_true_mass_toReal]
  ring

private theorem binarySymmetricChannel_uniform_output_entropy
    (ε : NNReal) (hε : ε ≤ 1) :
    entropy ((PMF.uniformOfFintype Bool).bind (PMF.binarySymmetricChannel ε hε)) =
      Real.log 2 := by
  rw [entropy_bool, binarySymmetricChannel_uniform_true_mass, one_div,
    Real.binEntropy_two_inv]

private theorem binarySymmetricChannel_uniform_objective
    (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint (PMF.uniformOfFintype Bool)
      (PMF.binarySymmetricChannel ε hε)) = Real.log 2 - Real.binEntropy (ε : ℝ) := by
  rw [mutualInfo_channelJoint_binarySymmetricChannel,
    binarySymmetricChannel_uniform_output_entropy]

/-- Binary symmetric channel information capacity in nats, for every crossover
probability in `[0, 1]`. The uniform Boolean input attains the value. -/
theorem channelCapacity_binarySymmetricChannel (ε : NNReal) (hε : ε ≤ 1) :
    channelCapacity (PMF.binarySymmetricChannel ε hε) =
      Real.log 2 - Real.binEntropy (ε : ℝ) := by
  apply le_antisymm
  · exact (channelCapacity_le_iff _ _).2 fun p => binarySymmetricChannel_objective_le p ε hε
  · have h := mutualInfo_channelJoint_le_channelCapacity (PMF.uniformOfFintype Bool)
      (PMF.binarySymmetricChannel ε hε)
    rwa [binarySymmetricChannel_uniform_objective] at h

/-- The uniform Boolean law attains binary symmetric channel information
capacity, including crossover probabilities zero, one half and one. -/
theorem mutualInfo_channelJoint_binarySymmetricChannel_uniformOfFintype
    (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint (PMF.uniformOfFintype Bool)
      (PMF.binarySymmetricChannel ε hε)) =
        channelCapacity (PMF.binarySymmetricChannel ε hε) := by
  rw [binarySymmetricChannel_uniform_objective, channelCapacity_binarySymmetricChannel]

private theorem binaryErasureChannel_none_mass_toReal
    (ε : NNReal) (hε : ε ≤ 1) (a : Bool) :
    (PMF.binaryErasureChannel ε hε a none).toReal = (ε : ℝ) := by
  simp [PMF.binaryErasureChannel, PMF.binaryMixture_apply, PMF.pure_apply]

private theorem binaryErasureChannel_some_mass_toReal
    (ε : NNReal) (hε : ε ≤ 1) (a b : Bool) :
    (PMF.binaryErasureChannel ε hε a (some b)).toReal =
      if b = a then 1 - (ε : ℝ) else 0 := by
  by_cases hb : b = a
  · subst b
    simp [PMF.binaryErasureChannel, PMF.binaryMixture_apply, PMF.pure_apply]
    simpa using ENNReal.toReal_sub_of_le
      (show (ε : ENNReal) ≤ 1 by exact_mod_cast hε) (by simp)
  · simp [PMF.binaryErasureChannel, PMF.binaryMixture_apply, PMF.pure_apply, hb]

private theorem binaryErasureChannel_output_none_mass
    (p : PMF Bool) (ε : NNReal) (hε : ε ≤ 1) :
    ((p.bind (PMF.binaryErasureChannel ε hε)) none).toReal = (ε : ℝ) := by
  rw [PMF.bind_toReal_apply]
  simp_rw [binaryErasureChannel_none_mass_toReal]
  rw [← Finset.sum_mul, PMF.sum_toReal, one_mul]

private theorem binaryErasureChannel_output_some_mass
    (p : PMF Bool) (ε : NNReal) (hε : ε ≤ 1) (b : Bool) :
    ((p.bind (PMF.binaryErasureChannel ε hε)) (some b)).toReal =
      (1 - (ε : ℝ)) * (p b).toReal := by
  rw [PMF.bind_toReal_apply]
  simp_rw [binaryErasureChannel_some_mass_toReal]
  simp [mul_comm]

private theorem binaryErasureChannel_output_entropy
    (p : PMF Bool) (ε : NNReal) (hε : ε ≤ 1) :
    entropy (p.bind (PMF.binaryErasureChannel ε hε)) =
      Real.binEntropy (ε : ℝ) + (1 - (ε : ℝ)) * entropy p := by
  rw [entropy_eq_sum, Fintype.sum_option, binaryErasureChannel_output_none_mass]
  simp_rw [binaryErasureChannel_output_some_mass, Real.negMulLog_mul]
  rw [Finset.sum_add_distrib, ← Finset.sum_mul, PMF.sum_toReal, one_mul,
    ← Finset.mul_sum, ← entropy_eq_sum,
    Real.binEntropy_eq_negMulLog_add_negMulLog_one_sub]
  ring

private theorem binaryErasureChannel_row_entropy
    (ε : NNReal) (hε : ε ≤ 1) (a : Bool) :
    entropy (PMF.binaryErasureChannel ε hε a) = Real.binEntropy (ε : ℝ) := by
  simpa [entropy_pure] using binaryErasureChannel_output_entropy (PMF.pure a) ε hε

/-- Mutual information through a binary erasure channel is the input entropy
weighted by the probability of transmission. The identity holds for every input
law and throughout the closed erasure interval, including zero masses. -/
theorem mutualInfo_channelJoint_binaryErasureChannel
    (p : PMF Bool) (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint p (PMF.binaryErasureChannel ε hε)) =
      (1 - (ε : ℝ)) * entropy p := by
  rw [mutualInfo_channelJoint_eq_entropy_bind_sub_sum, binaryErasureChannel_output_entropy]
  simp_rw [binaryErasureChannel_row_entropy]
  rw [← Finset.sum_mul, PMF.sum_toReal, one_mul]
  ring

private theorem binaryErasureChannel_objective_le
    (p : PMF Bool) (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint p (PMF.binaryErasureChannel ε hε)) ≤
      (1 - (ε : ℝ)) * Real.log 2 := by
  rw [mutualInfo_channelJoint_binaryErasureChannel]
  apply mul_le_mul_of_nonneg_left
  · simpa using entropy_le_log_card p
  · exact sub_nonneg.mpr (by exact_mod_cast hε)

private theorem binaryErasureChannel_uniform_objective
    (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint (PMF.uniformOfFintype Bool)
      (PMF.binaryErasureChannel ε hε)) = (1 - (ε : ℝ)) * Real.log 2 := by
  rw [mutualInfo_channelJoint_binaryErasureChannel, entropy_uniformOfFintype]
  simp

/-- Binary erasure channel information capacity in nats, for every erasure
probability in `[0, 1]`. The uniform Boolean input attains the value. -/
theorem channelCapacity_binaryErasureChannel (ε : NNReal) (hε : ε ≤ 1) :
    channelCapacity (PMF.binaryErasureChannel ε hε) =
      (1 - (ε : ℝ)) * Real.log 2 := by
  apply le_antisymm
  · exact (channelCapacity_le_iff _ _).2 fun p => binaryErasureChannel_objective_le p ε hε
  · have h := mutualInfo_channelJoint_le_channelCapacity (PMF.uniformOfFintype Bool)
      (PMF.binaryErasureChannel ε hε)
    rwa [binaryErasureChannel_uniform_objective] at h

private theorem uniform_attains_binaryErasureChannel_capacity
    (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint (PMF.uniformOfFintype Bool)
      (PMF.binaryErasureChannel ε hε)) =
        channelCapacity (PMF.binaryErasureChannel ε hε) := by
  rw [binaryErasureChannel_uniform_objective, channelCapacity_binaryErasureChannel]

/-- Noiseless finite-channel information capacity, converted from nats to bits. -/
theorem channelCapacity_deterministicChannel_id_bits {A : Type u} [Fintype A] [Nonempty A] :
    natsToBits (channelCapacity (PMF.deterministicChannel (id : A → A))) =
      Real.logb 2 (Fintype.card A) := by
  rw [channelCapacity_deterministicChannel_id]
  change Real.log (Fintype.card A) / Real.log 2 = _
  rw [Real.log_div_log]

/-- Input-independent channel information capacity is zero in bits. -/
theorem channelCapacity_const_bits {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B] (r : PMF B) :
    natsToBits (channelCapacity (fun _ : A => r)) = 0 := by
  rw [channelCapacity_const]
  change (0 : ℝ) / Real.log 2 = 0
  exact zero_div _

/-- Binary symmetric channel information capacity in bits, on the closed crossover interval. -/
theorem channelCapacity_binarySymmetricChannel_bits (ε : NNReal) (hε : ε ≤ 1) :
    natsToBits (channelCapacity (PMF.binarySymmetricChannel ε hε)) =
      1 - natsToBits (Real.binEntropy (ε : ℝ)) := by
  rw [channelCapacity_binarySymmetricChannel]
  change (Real.log 2 - Real.binEntropy (ε : ℝ)) / Real.log 2 =
    1 - Real.binEntropy (ε : ℝ) / Real.log 2
  rw [sub_div]
  rw [div_self (ne_of_gt (Real.log_pos (by norm_num : (1 : ℝ) < 2)))]

/-- Binary erasure channel information capacity in bits, on the closed erasure interval. -/
theorem channelCapacity_binaryErasureChannel_bits (ε : NNReal) (hε : ε ≤ 1) :
    natsToBits (channelCapacity (PMF.binaryErasureChannel ε hε)) = 1 - (ε : ℝ) := by
  rw [channelCapacity_binaryErasureChannel]
  change ((1 - (ε : ℝ)) * Real.log 2) / Real.log 2 = 1 - (ε : ℝ)
  rw [mul_div_assoc, div_self (ne_of_gt (Real.log_pos (by norm_num : (1 : ℝ) < 2))),
    mul_one]

end LeanInfoTheory.Shannon
