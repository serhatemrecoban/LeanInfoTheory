/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCode
import LeanInfoTheory.Shannon.ProductChannelCapacity
import LeanInfoTheory.Shannon.CodingRate

/-!
# Finite channel-code converse bounds

The actual message/input/output law of a deterministic block code is Markov.
Decoding is deterministic processing of its output. Reversing the first chain
gives the information bound from message/output to input/output; no injective
encoder or independent input coordinates are assumed.

Uniform-source Fano and the arbitrary-input memoryless capacity bound yield
`(1 - Pe) * log M ≤ n * C(W) + log 2` in nats for every natural blocklength
and positive message budget. This undivided form includes zero length,
singleton messages and error one. Positive length is needed for the normalized
rate form; the pointwise error lower bound additionally uses a positive target
rate bounded by the actual code rate. It does not require that target to exceed
capacity. No result divides by `1 - Pe`.

These bounds adapt CT91 §8.9 and PW24 §17.4 to arbitrary positive natural message
budgets, canonical nats and the delivered total-decoder model. Asymptotic
consequences belong to a separate owner.
-/

namespace LeanInfoTheory.Shannon.BlockChannelCode

noncomputable section

universe u v

variable {A : Type u} {B : Type v} {n M : ℕ}

/-- Under the actual code law, message → encoded input → channel output.
This is a raw-law fact and needs no finite or nonempty input alphabet. -/
theorem isMarkovChain_messageInputOutputLaw [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    IsMarkovChain (c.messageInputOutputLaw W hM) := by
  unfold messageInputOutputLaw
  exact isMarkovChain_channelExtension _ _

/-- Under that same law, message → output → decoded message. -/
theorem isMarkovChainOf_decoder [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    IsMarkovChainOf (c.messageInputOutputLaw W hM) Prod.fst
      (fun z => z.2.2) (fun z => c.decoder z.2.2) :=
  isMarkovChainOf_comp _ _ _ c.decoder

/-- Decoding cannot increase message information on the actual sampling law. -/
theorem mutualInfoOf_decoder_le [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    mutualInfoOf (c.messageInputOutputLaw W hM) Prod.fst
        (fun z => c.decoder z.2.2) ≤
      mutualInfoOf (c.messageInputOutputLaw W hM) Prod.fst (fun z => z.2.2) :=
  mutualInfoOf_dataProcessing _ _ _ _ (c.isMarkovChainOf_decoder W hM)

/-- Message/output information is at most input/output information, including
noninjective encoders and correlated codewords. -/
theorem mutualInfoOf_message_le_input [Fintype A] [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    mutualInfoOf (c.messageInputOutputLaw W hM) Prod.fst (fun z => z.2.2) ≤
      mutualInfoOf (c.messageInputOutputLaw W hM) (fun z => z.2.1)
        (fun z => z.2.2) := by
  have hrev := (isMarkovChainOf_reverse (c.messageInputOutputLaw W hM)
    Prod.fst (fun z => z.2.1) (fun z => z.2.2)).2
      (c.isMarkovChain_messageInputOutputLaw W hM)
  have h := mutualInfoOf_dataProcessing _ _ _ _ hrev
  rw [mutualInfoOf_swap (c.messageInputOutputLaw W hM) Prod.fst
    (fun z => z.2.2), mutualInfoOf_swap (c.messageInputOutputLaw W hM)
    (fun z => z.2.1) (fun z => z.2.2)] at h
  exact h

private theorem mutualInfo_messageOutputLaw_le_mul_channelCapacity
    [Fintype A] [Nonempty A] [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    mutualInfo (c.messageOutputLaw W hM) ≤ (n : ℝ) * channelCapacity W := by
  let : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
  have h := c.mutualInfoOf_message_le_input W hM
  change mutualInfo ((c.messageInputOutputLaw W hM).map
      (fun z => (z.1, z.2.2))) ≤
    mutualInfo ((c.messageInputOutputLaw W hM).map Prod.snd) at h
  rw [c.messageInputOutputLaw_map_messageOutput,
    c.messageInputOutputLaw_map_inputOutput] at h
  exact h.trans (mutualInfo_channelJoint_memorylessChannel_le W n
    ((PMF.uniformOfFintype (Fin M)).map c.encoder))

/-- The finite Fano-capacity converse in nats. It includes zero blocklength,
one message and error one, without dividing by `1 - Pe`. -/
theorem one_sub_errorProbability_mul_log_le
    [Fintype A] [Nonempty A] [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    (1 - c.errorProbability W hM) * Real.log (M : ℝ) ≤
      (n : ℝ) * channelCapacity W + Real.log 2 := by
  let : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
  have hf := mutualInfo_fano_lower_bound_of_uniform_source
    (c.messageOutputLaw W hM) c.decoder (c.messageOutputLaw_map_fst W hM)
  simp only [Fintype.card_fin] at hf
  change Real.log (M : ℝ) - Real.log 2 -
      c.errorProbability W hM * Real.log (M : ℝ) ≤
    mutualInfo (c.messageOutputLaw W hM) at hf
  have hc := mutualInfo_messageOutputLaw_le_mul_channelCapacity c W hM
  calc
    (1 - c.errorProbability W hM) * Real.log (M : ℝ) =
        (Real.log (M : ℝ) - Real.log 2 -
          c.errorProbability W hM * Real.log (M : ℝ)) + Real.log 2 := by ring
    _ ≤ mutualInfo (c.messageOutputLaw W hM) + Real.log 2 :=
      add_le_add hf (le_refl (Real.log 2))
    _ ≤ (n : ℝ) * channelCapacity W + Real.log 2 :=
      add_le_add hc (le_refl (Real.log 2))

/-- At positive length, the finite converse bounds the error-weighted code rate. -/
theorem one_sub_errorProbability_mul_codeRate_le
    [Fintype A] [Nonempty A] [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M)
    (hn : 0 < n) :
    (1 - c.errorProbability W hM) * codeRate n M ≤
      channelCapacity W + Real.log 2 / (n : ℝ) := by
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  change (1 - c.errorProbability W hM) * (Real.log (M : ℝ) / (n : ℝ)) ≤ _
  calc
    _ = ((1 - c.errorProbability W hM) * Real.log (M : ℝ)) / (n : ℝ) :=
      (mul_div_assoc _ _ _).symm
    _ ≤ ((n : ℝ) * channelCapacity W + Real.log 2) / (n : ℝ) :=
      div_le_div_of_nonneg_right (c.one_sub_errorProbability_mul_log_le W hM)
        (le_of_lt hn')
    _ = channelCapacity W + Real.log 2 / (n : ℝ) := by
      rw [add_div]
      simp [ne_of_gt hn']

/-- Any positive lower bound on the actual positive-length rate gives a
pointwise error bound. No above-capacity hypothesis is needed for this form. -/
theorem one_sub_channelCapacity_div_sub_le_errorProbability
    [Fintype A] [Nonempty A] [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M)
    (hn : 0 < n) {R : ℝ} (hR : 0 < R) (hrate : R ≤ codeRate n M) :
    1 - channelCapacity W / R - Real.log 2 / ((n : ℝ) * R) ≤
      c.errorProbability W hM := by
  have hpe : 0 ≤ 1 - c.errorProbability W hM :=
    sub_nonneg.mpr (c.errorProbability_le_one W hM)
  have hbound := (mul_le_mul_of_nonneg_left hrate hpe).trans
    (c.one_sub_errorProbability_mul_codeRate_le W hM hn)
  have hdiv : 1 - c.errorProbability W hM ≤
      (channelCapacity W + Real.log 2 / (n : ℝ)) / R :=
    (le_div_iff₀ hR).2 hbound
  rw [add_div] at hdiv
  rw [← div_div (Real.log 2) (n : ℝ) R]
  linarith only [hdiv]

end
end LeanInfoTheory.Shannon.BlockChannelCode
