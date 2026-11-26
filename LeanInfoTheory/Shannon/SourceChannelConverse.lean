/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceChannelCode
import LeanInfoTheory.Shannon.ProductChannelCapacity

/-!
# Lossless source–channel converse

For an iid source and one memoryless channel use per symbol, weak Fano bounds
source entropy in terms of capacity and the actual reconstruction error of any
deterministic word code. If a family's reconstruction error vanishes, its
source entropy is at most the channel capacity (CT91 §8.13, PW24 §19.7).
-/

namespace LeanInfoTheory.Shannon

open Filter

universe u v w

private theorem mutualInfo_sourceOutput_le_inputOutput
    {A : Type u} {B : Type v} {C : Type w} [Fintype A] [Fintype B] [Fintype C]
    (q : PMF A) (e : A → B) (K : B → PMF C) :
    mutualInfo (PMF.channelJoint q (fun a => K (e a))) ≤
      mutualInfo (PMF.channelJoint (q.map e) K) := by
  let T := PMF.channelExtension (PMF.channelJoint q (PMF.deterministicChannel e)) K
  have hrev := (isMarkovChainOf_reverse T Prod.fst (fun z => z.2.1) (fun z => z.2.2)).2
    (isMarkovChain_channelExtension _ _)
  have h := mutualInfoOf_dataProcessing _ _ _ _ hrev
  rw [mutualInfoOf_swap T Prod.fst (fun z => z.2.2),
    mutualInfoOf_swap T (fun z => z.2.1) (fun z => z.2.2)] at h
  change mutualInfo (T.map (fun z => (z.1, z.2.2))) ≤ mutualInfo (T.map Prod.snd) at h
  simpa only [T, PMF.channelExtension_map_endpoints, PMF.channelComp_deterministic_left,
    PMF.channelExtension_map_outputPair, PMF.channelJoint_map_snd, PMF.bind_deterministicChannel]
    using h

/-- For every deterministic word encoder and reconstruction decoder, the iid
source block entropy is bounded by the block capacity plus the weak Fano
penalty for its actual reconstruction error. The undivided bound includes
zero length and singleton sources. -/
theorem mul_entropy_le_mul_channelCapacity_add_error
    {S : Type u} {X : Type v} {Y : Type w} [Fintype S] [Fintype X] [Nonempty X] [Fintype Y]
    (p : PMF S) (W : X → PMF Y) (n : ℕ)
    (E : (Fin n → S) → (Fin n → X)) (D : (Fin n → Y) → (Fin n → S)) :
    (n : ℝ) * entropy p ≤ (n : ℝ) * channelCapacity W + Real.log 2 +
      sourceChannelErrorProbability p W n E D * (n : ℝ) * Real.log (Fintype.card S : ℝ) := by
  let q := PMF.iid p n
  let K := PMF.memorylessChannel W n
  let J := PMF.channelJoint q (fun s => K (E s))
  have hmi : mutualInfo J ≤ (n : ℝ) * channelCapacity W :=
    (mutualInfo_sourceOutput_le_inputOutput q E K).trans
      (mutualInfo_channelJoint_memorylessChannel_le W n (q.map E))
  have hdecomp : (n : ℝ) * entropy p = mutualInfo J + condEntropy J := by
    simp only [mutualInfo_eq_entropy_fstMarginal_sub_condEntropy, sub_add_cancel,
      fstMarginal, J, PMF.channelJoint_map_fst, q, entropy_iid]
  have hf := condEntropy_fano_weak J D
  change condEntropy J ≤ Real.log 2 + sourceChannelErrorProbability p W n E D *
    Real.log (Fintype.card (Fin n → S) : ℝ) at hf
  rw [Fintype.card_fun, Fintype.card_fin, Nat.cast_pow, Real.log_pow, ← mul_assoc] at hf
  calc
    (n : ℝ) * entropy p = mutualInfo J + condEntropy J := hdecomp
    _ ≤ _ := (add_le_add hmi hf).trans_eq (add_assoc _ _ _).symm

/-- With one memoryless channel use per iid source symbol, vanishing block
reconstruction error for any given deterministic encoder and decoder families
forces the source entropy to be at most the channel capacity. -/
theorem entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability
    {S : Type u} {X : Type v} {Y : Type w} [Fintype S] [Fintype X] [Nonempty X] [Fintype Y]
    (p : PMF S) (W : X → PMF Y)
    (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X))
    (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S))
    (he : Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n))
      atTop (nhds 0)) :
    entropy p ≤ channelCapacity W := by
  let pe := fun n => sourceChannelErrorProbability p W n (E n) (D n)
  let L := Real.log (Fintype.card S : ℝ)
  have htail : ∀ᶠ n : ℕ in atTop,
      entropy p ≤ channelCapacity W + Real.log 2 / (n : ℝ) + pe n * L := by
    filter_upwards [eventually_gt_atTop (0 : ℕ)] with n hn
    have hn' : (0 : ℝ) < n := by exact_mod_cast hn
    apply (mul_le_mul_iff_of_pos_right hn').mp
    rw [add_mul, add_mul, div_mul_cancel₀ _ hn'.ne']
    simpa only [pe, L, mul_comm, mul_left_comm, mul_assoc] using
      mul_entropy_le_mul_channelCapacity_add_error p W n (E n) (D n)
  have hlim : Tendsto (fun n : ℕ => channelCapacity W + Real.log 2 / (n : ℝ) + pe n * L)
      atTop (nhds (channelCapacity W)) := by
    simpa only [add_zero, zero_mul] using
      ((tendsto_const_div_atTop_nhds_zero_nat (Real.log 2)).const_add (channelCapacity W)).add
        (he.mul_const L)
  exact le_of_tendsto_of_tendsto tendsto_const_nhds hlim htail

end LeanInfoTheory.Shannon
