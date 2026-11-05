/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.StandardChannelCapacity
import LeanInfoTheory.Shannon.ProductChannelCapacity

/-!
# Standard finite channel capacity consumers

These private consumers identify the uniform law attaining noiseless capacity
and retain the objective bound for every input. Every input attains the capacity
of a constant channel, including a pure witness against a non-pure output law.
A ternary input with masses one half, one half and zero exercises both channels.
Singleton input and output alphabets remain separate boundary cases.
The binary symmetric channel checks use its public objective, capacity and
uniform-attainment formulas, including crossover above one half and a biased
input whose output mass is computed exactly.
The erasure channel retains sparse and biased inputs, zero/full erasure and
uniform attainment through its public formulas. Explicit bits consumers use
positive log-2 scaling for these attaining laws, arbitrary-input bounds,
heterogeneous products and repeated channels, including zero blocklength.
-/

namespace LeanInfoTheory.Examples.StandardChannelCapacity

noncomputable section

universe u v

open LeanInfoTheory.Shannon

private theorem noiseless_objective {A : Type u} [Fintype A] (p : PMF A) :
    mutualInfo (PMF.channelJoint p (PMF.deterministicChannel (id : A → A))) =
      entropy p := by
  rw [PMF.channelJoint_deterministicChannel]
  exact mutualInfo_map_diag p

private theorem noiseless_universal_bound
    {A : Type u} [Fintype A] [Nonempty A] (p : PMF A) :
    mutualInfo (PMF.channelJoint p (PMF.deterministicChannel (id : A → A))) ≤
      Real.log (Fintype.card A) := by
  have h := mutualInfo_channelJoint_le_channelCapacity p
    (PMF.deterministicChannel (id : A → A))
  rwa [channelCapacity_deterministicChannel_id (A := A)] at h

private theorem uniform_noiseless_attainment
    {A : Type u} [Fintype A] [Nonempty A] :
    mutualInfo (PMF.channelJoint (PMF.uniformOfFintype A)
      (PMF.deterministicChannel (id : A → A))) =
        channelCapacity (PMF.deterministicChannel (id : A → A)) := by
  rw [noiseless_objective, entropy_uniformOfFintype,
    channelCapacity_deterministicChannel_id (A := A)]

private theorem pure_noiseless_input :
    mutualInfo (PMF.channelJoint (PMF.pure (0 : Fin 3))
      (PMF.deterministicChannel id)) = 0 ∧
      channelCapacity (PMF.deterministicChannel (id : Fin 3 → Fin 3)) = Real.log 3 := by
  constructor
  · rw [noiseless_objective, entropy_pure]
  · simpa using channelCapacity_deterministicChannel_id (A := Fin 3)

private theorem constant_objective {A : Type u} {B : Type v}
    [Fintype A] [Fintype B] (p : PMF A) (r : PMF B) :
    mutualInfo (PMF.channelJoint p (fun _ : A => r)) = 0 := by
  exact (mutualInfo_eq_zero_iff_isIndependent _).2 (isIndependent_indepProd p r)

private theorem every_input_constant_attainment {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B] (p : PMF A) (r : PMF B) :
    mutualInfo (PMF.channelJoint p (fun _ : A => r)) =
      channelCapacity (fun _ : A => r) := by
  rw [constant_objective, channelCapacity_const (A := A) r]

private def randomOutput : PMF Bool := PMF.uniformOfFintype Bool

private theorem randomOutput_not_pure (b : Bool) : randomOutput ≠ PMF.pure b := by
  intro h
  have hm := congrArg (fun r : PMF Bool => (r true).toReal) h
  cases b <;>
    norm_num [randomOutput, PMF.uniformOfFintype_apply, PMF.pure_apply] at hm

private theorem pure_constant_witness :
    mutualInfo (PMF.channelJoint (PMF.pure (0 : Fin 3)) (fun _ : Fin 3 => randomOutput)) =
        channelCapacity (fun _ : Fin 3 => randomOutput) ∧
      channelCapacity (fun _ : Fin 3 => randomOutput) = 0 :=
  ⟨every_input_constant_attainment _ _, channelCapacity_const (A := Fin 3) randomOutput⟩

private def sparseInput : PMF (Fin 3) :=
  PMF.uniformOfFinset ({0, 1} : Finset (Fin 3)) (by simp)

private theorem sparse_input_masses :
    (sparseInput 0).toReal = 1 / 2 ∧ (sparseInput 1).toReal = 1 / 2 ∧ sparseInput 2 = 0 := by
  norm_num [sparseInput, PMF.uniformOfFinset_apply, Fin.ext_iff]

private theorem sparse_noiseless_input :
    mutualInfo (PMF.channelJoint sparseInput (PMF.deterministicChannel id)) =
        entropy sparseInput ∧
      mutualInfo (PMF.channelJoint sparseInput (PMF.deterministicChannel id)) ≤
        channelCapacity (PMF.deterministicChannel (id : Fin 3 → Fin 3)) := by
  refine ⟨noiseless_objective sparseInput, ?_⟩
  rw [channelCapacity_deterministicChannel_id (A := Fin 3)]
  exact noiseless_universal_bound sparseInput

private theorem sparse_constant_input :
    mutualInfo (PMF.channelJoint sparseInput (fun _ : Fin 3 => randomOutput)) = 0 ∧
      mutualInfo (PMF.channelJoint sparseInput (fun _ : Fin 3 => randomOutput)) =
        channelCapacity (fun _ : Fin 3 => randomOutput) :=
  ⟨constant_objective _ _, every_input_constant_attainment _ _⟩

private theorem singleton_noiseless_capacity_and_attainment :
    channelCapacity (PMF.deterministicChannel (id : Unit → Unit)) = 0 ∧
      mutualInfo (PMF.channelJoint (PMF.uniformOfFintype Unit)
        (PMF.deterministicChannel id)) =
          channelCapacity (PMF.deterministicChannel (id : Unit → Unit)) := by
  constructor
  · simpa using channelCapacity_deterministicChannel_id (A := Unit)
  · exact uniform_noiseless_attainment

private theorem singleton_input_constant_capacity_and_attainment :
    channelCapacity (fun _ : Unit => randomOutput) = 0 ∧
      mutualInfo (PMF.channelJoint (PMF.pure ()) (fun _ : Unit => randomOutput)) =
        channelCapacity (fun _ : Unit => randomOutput) :=
  ⟨channelCapacity_const (A := Unit) randomOutput, every_input_constant_attainment _ _⟩

private theorem singleton_output_constant_capacity_and_attainment (p : PMF (Fin 3)) :
    channelCapacity (fun _ : Fin 3 => PMF.pure ()) = 0 ∧
      mutualInfo (PMF.channelJoint p (fun _ : Fin 3 => PMF.pure ())) =
        channelCapacity (fun _ : Fin 3 => PMF.pure ()) :=
  ⟨channelCapacity_const (A := Fin 3) (PMF.pure ()), every_input_constant_attainment p _⟩

private theorem bsc_universal_bound (p : PMF Bool) (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint p (PMF.binarySymmetricChannel ε hε)) ≤
      Real.log 2 - Real.binEntropy (ε : ℝ) := by
  have h := mutualInfo_channelJoint_le_channelCapacity p (PMF.binarySymmetricChannel ε hε)
  rwa [channelCapacity_binarySymmetricChannel] at h

private theorem bsc_uniform_attainment (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint (PMF.uniformOfFintype Bool)
      (PMF.binarySymmetricChannel ε hε)) =
        channelCapacity (PMF.binarySymmetricChannel ε hε) :=
  mutualInfo_channelJoint_binarySymmetricChannel_uniformOfFintype ε hε

private theorem bsc_deterministic_endpoint_capacities :
    channelCapacity (PMF.binarySymmetricChannel 0 (by norm_num)) = Real.log 2 ∧
      channelCapacity (PMF.binarySymmetricChannel 1 (by norm_num)) = Real.log 2 := by
  simp [channelCapacity_binarySymmetricChannel]

private theorem bsc_half_capacity :
    channelCapacity (PMF.binarySymmetricChannel (1 / 2) (by norm_num)) = 0 := by
  rw [channelCapacity_binarySymmetricChannel]
  change Real.log 2 - Real.binEntropy (1 / 2 : ℝ) = 0
  rw [one_div, Real.binEntropy_two_inv, sub_self]

private theorem bsc_half_every_input_attainment (p : PMF Bool) :
    mutualInfo (PMF.channelJoint p (PMF.binarySymmetricChannel (1 / 2) (by norm_num))) = 0 ∧
      mutualInfo (PMF.channelJoint p (PMF.binarySymmetricChannel (1 / 2) (by norm_num))) =
        channelCapacity (PMF.binarySymmetricChannel (1 / 2) (by norm_num)) := by
  have hzero : mutualInfo
      (PMF.channelJoint p (PMF.binarySymmetricChannel (1 / 2) (by norm_num))) = 0 := by
    apply le_antisymm _ (mutualInfo_nonneg _)
    simpa only [bsc_half_capacity] using
      mutualInfo_channelJoint_le_channelCapacity p
        (PMF.binarySymmetricChannel (1 / 2) (by norm_num))
  exact ⟨hzero, hzero.trans bsc_half_capacity.symm⟩

private theorem quarter_le_one : (1 / 4 : NNReal) ≤ 1 := by
  change (1 / 4 : ℝ) ≤ 1
  norm_num

private theorem three_quarters_le_one : (3 / 4 : NNReal) ≤ 1 := by
  change (3 / 4 : ℝ) ≤ 1
  norm_num

private theorem bsc_pure_input_at_three_quarters :
    mutualInfo (PMF.channelJoint (PMF.pure true)
      (PMF.binarySymmetricChannel (3 / 4) three_quarters_le_one)) = 0 := by
  apply le_antisymm _ (mutualInfo_nonneg _)
  have h := mutualInfo_le_entropy_fstMarginal
    (PMF.channelJoint (PMF.pure true)
      (PMF.binarySymmetricChannel (3 / 4) three_quarters_le_one))
  simpa only [fstMarginal, PMF.channelJoint_map_fst, entropy_pure] using h

private def biasedInput : PMF Bool :=
  PMF.binaryMixture (1 / 4) quarter_le_one (PMF.pure true) (PMF.pure false)

private theorem biased_input_masses :
    (biasedInput true).toReal = 1 / 4 ∧ (biasedInput false).toReal = 3 / 4 := by
  have hsub := ENNReal.toReal_sub_of_le
    (show ((1 / 4 : NNReal) : ENNReal) ≤ 1 by exact_mod_cast quarter_le_one) (by simp)
  norm_num at hsub
  norm_num [biasedInput, PMF.binaryMixture_apply, PMF.pure_apply, ENNReal.coe_sub, hsub]

private theorem biased_bsc_output_true_mass :
    ((biasedInput.bind (PMF.binarySymmetricChannel (3 / 4) three_quarters_le_one))
      true).toReal = 5 / 8 := by
  have hsub := ENNReal.toReal_sub_of_le
    (show ((3 / 4 : NNReal) : ENNReal) ≤ 1 by exact_mod_cast three_quarters_le_one) (by simp)
  norm_num at hsub
  rw [PMF.bind_toReal_apply, Fintype.sum_bool, biased_input_masses.1, biased_input_masses.2]
  norm_num [PMF.binarySymmetricChannel, PMF.binaryMixture_apply,
    PMF.pure_apply, ENNReal.coe_sub, hsub]

private theorem biased_bsc_objective :
    mutualInfo (PMF.channelJoint biasedInput
      (PMF.binarySymmetricChannel (3 / 4) three_quarters_le_one)) =
        Real.binEntropy (5 / 8) - Real.binEntropy (3 / 4) := by
  rw [mutualInfo_channelJoint_binarySymmetricChannel, entropy_bool,
    biased_bsc_output_true_mass]
  norm_num

/-! ## Binary erasure channel capacity and sparse-input consumers -/

private theorem bec_universal_bound (p : PMF Bool) (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint p (PMF.binaryErasureChannel ε hε)) ≤
      (1 - (ε : ℝ)) * Real.log 2 := by
  have h := mutualInfo_channelJoint_le_channelCapacity p (PMF.binaryErasureChannel ε hε)
  rwa [channelCapacity_binaryErasureChannel] at h

private theorem bec_uniform_attainment (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint (PMF.uniformOfFintype Bool)
      (PMF.binaryErasureChannel ε hε)) =
        channelCapacity (PMF.binaryErasureChannel ε hε) := by
  rw [mutualInfo_channelJoint_binaryErasureChannel, entropy_uniformOfFintype,
    channelCapacity_binaryErasureChannel]
  simp

private theorem bec_zero_erasure_objective (p : PMF Bool) :
    mutualInfo (PMF.channelJoint p (PMF.binaryErasureChannel 0 (by norm_num))) =
      entropy p := by
  simp [mutualInfo_channelJoint_binaryErasureChannel]

private theorem bec_endpoint_capacities :
    channelCapacity (PMF.binaryErasureChannel 0 (by norm_num)) = Real.log 2 ∧
      channelCapacity (PMF.binaryErasureChannel 1 (by norm_num)) = 0 := by
  simp [channelCapacity_binaryErasureChannel]

private theorem bec_full_erasure_every_input_attainment (p : PMF Bool) :
    mutualInfo (PMF.channelJoint p (PMF.binaryErasureChannel 1 (by norm_num))) = 0 ∧
      mutualInfo (PMF.channelJoint p (PMF.binaryErasureChannel 1 (by norm_num))) =
        channelCapacity (PMF.binaryErasureChannel 1 (by norm_num)) := by
  simp [mutualInfo_channelJoint_binaryErasureChannel, channelCapacity_binaryErasureChannel]

private theorem third_le_one : (1 / 3 : NNReal) ≤ 1 := by
  change (1 / 3 : ℝ) ≤ 1
  norm_num

private theorem bec_pure_sparse_input :
    PMF.pure true false = 0 ∧
      ((PMF.pure true).bind (PMF.binaryErasureChannel (1 / 3) third_le_one))
        (some false) = 0 ∧
      mutualInfo (PMF.channelJoint (PMF.pure true)
        (PMF.binaryErasureChannel (1 / 3) third_le_one)) = 0 := by
  refine ⟨by simp [PMF.pure_apply], ?_, ?_⟩
  · rw [PMF.pure_bind]
    simp [PMF.binaryErasureChannel, PMF.binaryMixture_apply, PMF.pure_apply]
  · rw [mutualInfo_channelJoint_binaryErasureChannel, entropy_pure, mul_zero]

private theorem biased_bec_output_masses :
    ((biasedInput.bind (PMF.binaryErasureChannel (1 / 3) third_le_one)) none).toReal =
        1 / 3 ∧
      ((biasedInput.bind (PMF.binaryErasureChannel (1 / 3) third_le_one))
        (some true)).toReal = 1 / 6 ∧
      ((biasedInput.bind (PMF.binaryErasureChannel (1 / 3) third_le_one))
        (some false)).toReal = 1 / 2 := by
  have hsub := ENNReal.toReal_sub_of_le
    (show ((1 / 3 : NNReal) : ENNReal) ≤ 1 by exact_mod_cast third_le_one) (by simp)
  norm_num at hsub
  refine ⟨?_, ?_, ?_⟩ <;>
    rw [PMF.bind_toReal_apply, Fintype.sum_bool, biased_input_masses.1, biased_input_masses.2] <;>
    norm_num [PMF.binaryErasureChannel, PMF.binaryMixture_apply,
      PMF.pure_apply, Option.some_ne_none, (Option.some_ne_none true).symm,
      (Option.some_ne_none false).symm, ENNReal.coe_sub, hsub]

private theorem biased_bec_objective :
    mutualInfo (PMF.channelJoint biasedInput
      (PMF.binaryErasureChannel (1 / 3) third_le_one)) = (2 / 3) * entropy biasedInput := by
  rw [mutualInfo_channelJoint_binaryErasureChannel]
  norm_num

/-! ## Bits equations, actual achieving laws and scalar integration -/

private theorem natsToBits_mono {x y : ℝ} (h : x ≤ y) :
    natsToBits x ≤ natsToBits y := by
  exact div_le_div_of_nonneg_right h (le_of_lt (Real.log_pos (by norm_num)))

private theorem uniform_noiseless_attainment_bits
    {A : Type u} [Fintype A] [Nonempty A] :
    natsToBits (mutualInfo (PMF.channelJoint (PMF.uniformOfFintype A)
      (PMF.deterministicChannel (id : A → A)))) = Real.logb 2 (Fintype.card A) := by
  rw [uniform_noiseless_attainment, channelCapacity_deterministicChannel_id_bits]

private theorem every_input_constant_attainment_bits
    {A : Type u} {B : Type v} [Fintype A] [Nonempty A] [Fintype B]
    (p : PMF A) (r : PMF B) :
    natsToBits (mutualInfo (PMF.channelJoint p (fun _ : A => r))) = 0 := by
  rw [every_input_constant_attainment p r, channelCapacity_const_bits]

private theorem bsc_uniform_attainment_bits (ε : NNReal) (hε : ε ≤ 1) :
    natsToBits (mutualInfo (PMF.channelJoint (PMF.uniformOfFintype Bool)
      (PMF.binarySymmetricChannel ε hε))) = 1 - natsToBits (Real.binEntropy (ε : ℝ)) := by
  rw [bsc_uniform_attainment, channelCapacity_binarySymmetricChannel_bits]

private theorem bec_uniform_attainment_bits (ε : NNReal) (hε : ε ≤ 1) :
    natsToBits (mutualInfo (PMF.channelJoint (PMF.uniformOfFintype Bool)
      (PMF.binaryErasureChannel ε hε))) = 1 - (ε : ℝ) := by
  rw [bec_uniform_attainment, channelCapacity_binaryErasureChannel_bits]

private theorem bsc_bits_endpoints :
    natsToBits (channelCapacity (PMF.binarySymmetricChannel 0 (by norm_num))) = 1 ∧
      natsToBits (channelCapacity (PMF.binarySymmetricChannel (1 / 2) (by norm_num))) = 0 ∧
      natsToBits (channelCapacity (PMF.binarySymmetricChannel 1 (by norm_num))) = 1 := by
  have hlog : Real.log 2 ≠ 0 := ne_of_gt (Real.log_pos (by norm_num))
  rw [bsc_deterministic_endpoint_capacities.1, bsc_half_capacity,
    bsc_deterministic_endpoint_capacities.2]
  simp [natsToBits, natsToBase, hlog]

private theorem bec_bits_endpoints :
    natsToBits (channelCapacity (PMF.binaryErasureChannel 0 (by norm_num))) = 1 ∧
      natsToBits (channelCapacity (PMF.binaryErasureChannel 1 (by norm_num))) = 0 := by
  simp [channelCapacity_binaryErasureChannel_bits]

private theorem bsc_half_every_input_attainment_bits (p : PMF Bool) :
    natsToBits (mutualInfo
      (PMF.channelJoint p (PMF.binarySymmetricChannel (1 / 2) (by norm_num)))) = 0 := by
  rw [(bsc_half_every_input_attainment p).1]
  simp [natsToBits, natsToBase]

private theorem bec_full_erasure_every_input_attainment_bits (p : PMF Bool) :
    natsToBits (mutualInfo
      (PMF.channelJoint p (PMF.binaryErasureChannel 1 (by norm_num)))) = 0 := by
  rw [(bec_full_erasure_every_input_attainment p).1]
  simp [natsToBits, natsToBase]

private theorem arbitrary_input_bound_bits
    {A : Type u} {B : Type v} [Fintype A] [Nonempty A] [Fintype B]
    (p : PMF A) (W : A → PMF B) :
    natsToBits (mutualInfo (PMF.channelJoint p W)) ≤ natsToBits (channelCapacity W) :=
  natsToBits_mono (mutualInfo_channelJoint_le_channelCapacity p W)

universe w

open scoped BigOperators

open Classical in
private theorem product_capacity_bits
    {J : Type w} {A : J → Type u} {B : J → Type v}
    [Fintype J] [∀ j, Fintype (A j)] [∀ j, Nonempty (A j)]
    [∀ j, Fintype (B j)] (W : ∀ j, A j → PMF (B j)) :
    natsToBits (channelCapacity (PMF.productChannel W)) =
      ∑ j, natsToBits (channelCapacity (W j)) := by
  rw [channelCapacity_productChannel]
  simp only [natsToBits, natsToBase, Finset.sum_div]

private theorem repeated_capacity_bits
    {A : Type u} {B : Type v} [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (n : ℕ) :
    natsToBits (channelCapacity (PMF.memorylessChannel W n)) =
      (n : ℝ) * natsToBits (channelCapacity W) := by
  rw [channelCapacity_memorylessChannel]
  exact mul_div_assoc _ _ _

private theorem arbitrary_block_bound_bits
    {A : Type u} {B : Type v} [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (n : ℕ) (q : PMF (Fin n → A)) :
    natsToBits (mutualInfo (PMF.channelJoint q (PMF.memorylessChannel W n))) ≤
      (n : ℝ) * natsToBits (channelCapacity W) := by
  have h := natsToBits_mono (mutualInfo_channelJoint_memorylessChannel_le W n q)
  simpa only [natsToBits, natsToBase, mul_div_assoc] using h

open Classical in
private theorem supplied_product_attainment_bits
    {J : Type w} {A : J → Type u} {B : J → Type v}
    [Fintype J] [∀ j, Fintype (A j)] [∀ j, Nonempty (A j)]
    [∀ j, Fintype (B j)] (p : ∀ j, PMF (A j)) (W : ∀ j, A j → PMF (B j))
    (hp : ∀ j, mutualInfo (PMF.channelJoint (p j) (W j)) = channelCapacity (W j)) :
    natsToBits (mutualInfo (PMF.channelJoint (PMF.finiteProduct p) (PMF.productChannel W))) =
      natsToBits (channelCapacity (PMF.productChannel W)) := by
  apply congrArg natsToBits
  rw [mutualInfo_channelJoint_finiteProduct, channelCapacity_productChannel]
  exact Finset.sum_congr rfl fun j _ => hp j

private theorem supplied_iid_attainment_bits
    {A : Type u} {B : Type v} [Fintype A] [Nonempty A] [Fintype B]
    (p : PMF A) (W : A → PMF B)
    (hp : mutualInfo (PMF.channelJoint p W) = channelCapacity W) (n : ℕ) :
    natsToBits (mutualInfo (PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n))) =
      natsToBits (channelCapacity (PMF.memorylessChannel W n)) := by
  apply congrArg natsToBits
  rw [mutualInfo_channelJoint_iid, hp, channelCapacity_memorylessChannel]

private theorem bits_zero_and_one_blocks
    {A : Type u} {B : Type v} [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (q₀ : PMF (Fin 0 → A)) (q₁ : PMF (Fin 1 → A)) :
    natsToBits (channelCapacity (PMF.memorylessChannel W 0)) = 0 ∧
      natsToBits (channelCapacity (PMF.memorylessChannel W 1)) =
        natsToBits (channelCapacity W) ∧
      natsToBits (mutualInfo (PMF.channelJoint q₀ (PMF.memorylessChannel W 0))) ≤ 0 ∧
      natsToBits (mutualInfo (PMF.channelJoint q₁ (PMF.memorylessChannel W 1))) ≤
        natsToBits (channelCapacity W) := by
  refine ⟨by simp [repeated_capacity_bits], by simp [repeated_capacity_bits], ?_, ?_⟩
  · simpa using arbitrary_block_bound_bits W 0 q₀
  · simpa using arbitrary_block_bound_bits W 1 q₁

end

end LeanInfoTheory.Examples.StandardChannelCapacity
