/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.Fano
import LeanInfoTheory.Probability.ProductChannel

/-!
# Deterministic block channel codes

A code encodes a message index as an input word and decodes an output word to
a message index. Messages are uniform over all `M` indices, with explicit
`1 ≤ M`. Encoding need not be injective: the induced input law is the actual
pushforward of the uniform message law, and need not be uniform or iid.

The message/input/output law uses the existing raw memoryless channel and
right-associated PMF channel extension. Error reuses the Fano decoding-error
definition. Its finite average formula and its event interpretation retain
message identity even when codewords collide. At length zero success is `1/M`;
with one message error is zero at every length. No capacity or converse theorem
is developed in this owner.

The total deterministic model and uniform average error follow CT91 §8.5 and
PW24 §17.1. The raw laws require finite output alphabets, with no finiteness or
nonemptiness premise on the input alphabet.
-/

namespace LeanInfoTheory.Shannon

noncomputable section

open scoped BigOperators ENNReal

universe u v

/-- A deterministic encoder/total decoder pair. The raw pair imposes neither
injectivity nor recovery; operational laws use a positive message budget. -/
abbrev BlockChannelCode (A : Type u) (B : Type v) (n M : ℕ) :=
  (Fin M → (Fin n → A)) × ((Fin n → B) → Fin M)

namespace BlockChannelCode

variable {A : Type u} {B : Type v} {n M : ℕ}

/-- Encode a message index as an input word. -/
abbrev encoder (c : BlockChannelCode A B n M) : Fin M → (Fin n → A) := c.1

/-- Decode an output word to a message index, including off-support outputs. -/
abbrev decoder (c : BlockChannelCode A B n M) : (Fin n → B) → Fin M := c.2

/-- The joint law of the uniform message and its channel output. -/
def messageOutputLaw [Fintype B] (c : BlockChannelCode A B n M)
    (W : A → PMF B) (hM : 1 ≤ M) : PMF (Fin M × (Fin n → B)) := by
  letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
  exact PMF.channelJoint (PMF.uniformOfFintype (Fin M))
    (fun m => PMF.memorylessChannel W n (c.encoder m))

/-- The actual message/input/output law, associated as `message × (input × output)`. -/
def messageInputOutputLaw [Fintype B] (c : BlockChannelCode A B n M)
    (W : A → PMF B) (hM : 1 ≤ M) :
    PMF (Fin M × (Fin n → A) × (Fin n → B)) := by
  letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
  exact PMF.channelExtension
    (PMF.channelJoint (PMF.uniformOfFintype (Fin M))
      (PMF.deterministicChannel c.encoder)) (PMF.memorylessChannel W n)

/-- Uniform-message average block error, with the existing Fano semantics. -/
def errorProbability [Fintype B] (c : BlockChannelCode A B n M)
    (W : A → PMF B) (hM : 1 ≤ M) : ℝ :=
  decodingErrorProbability (c.messageOutputLaw W hM) c.decoder

/-- Each message/output atom keeps the mass of its original message index. -/
theorem messageOutputLaw_apply [Fintype B] (c : BlockChannelCode A B n M)
    (W : A → PMF B) (hM : 1 ≤ M) (m : Fin M) (y : Fin n → B) :
    c.messageOutputLaw W hM (m, y) =
      (M : ℝ≥0∞)⁻¹ * PMF.memorylessChannel W n (c.encoder m) y := by
  simp [messageOutputLaw, PMF.uniformOfFintype_apply]

/-- The message marginal is uniform over indices, including colliding indices. -/
theorem messageOutputLaw_map_fst [Fintype B] (c : BlockChannelCode A B n M)
    (W : A → PMF B) (hM : 1 ≤ M) :
    letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
    (c.messageOutputLaw W hM).map Prod.fst = PMF.uniformOfFintype (Fin M) := by
  simp [messageOutputLaw]

/-- The message/input pair is the graph pushforward of the uniform message. -/
theorem messageInputOutputLaw_map_messageInput [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
    (c.messageInputOutputLaw W hM).map (fun z => (z.1, z.2.1)) =
      (PMF.uniformOfFintype (Fin M)).map (fun m => (m, c.encoder m)) := by
  simp [messageInputOutputLaw, PMF.channelJoint_deterministicChannel]

/-- The input marginal is the encoder pushforward, with no image-uniformity claim. -/
theorem messageInputOutputLaw_map_input [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
    (c.messageInputOutputLaw W hM).map (fun z => z.2.1) =
      (PMF.uniformOfFintype (Fin M)).map c.encoder := by
  have h := congrArg (fun p => p.map Prod.snd)
    (c.messageInputOutputLaw_map_messageInput W hM)
  simpa only [PMF.map_comp, Function.comp_def] using h

/-- The input/output pair uses the actual encoder pushforward as input law. -/
theorem messageInputOutputLaw_map_inputOutput [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
    (c.messageInputOutputLaw W hM).map Prod.snd =
      PMF.channelJoint ((PMF.uniformOfFintype (Fin M)).map c.encoder)
        (PMF.memorylessChannel W n) := by
  simp [messageInputOutputLaw, PMF.channelJoint_deterministicChannel,
    PMF.map_comp, Function.comp_def]

/-- Projecting the triple to message/output gives the original Fano joint law. -/
theorem messageInputOutputLaw_map_messageOutput [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    (c.messageInputOutputLaw W hM).map (fun z => (z.1, z.2.2)) =
      c.messageOutputLaw W hM := by
  simp only [messageInputOutputLaw, messageOutputLaw,
    PMF.channelExtension_map_endpoints, PMF.channelComp_deterministic_left]

/-- The message marginal of the triple is the same uniform message law. -/
theorem messageInputOutputLaw_map_message [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
    (c.messageInputOutputLaw W hM).map Prod.fst = PMF.uniformOfFintype (Fin M) := by
  have h := congrArg (fun p => p.map Prod.fst)
    (c.messageInputOutputLaw_map_messageOutput W hM)
  simpa only [PMF.map_comp, Function.comp_def, c.messageOutputLaw_map_fst W hM] using h

/-- The output law is the encoder pushforward passed through the memoryless channel. -/
theorem messageInputOutputLaw_map_output [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
    (c.messageInputOutputLaw W hM).map (fun z => z.2.2) =
      ((PMF.uniformOfFintype (Fin M)).map c.encoder).bind
        (PMF.memorylessChannel W n) := by
  simp [messageInputOutputLaw, PMF.channelJoint_deterministicChannel,
    PMF.map_comp, Function.comp_def]

/-- The block error is the Fano random-variable error on the actual triple. -/
theorem errorProbability_eq_decodingErrorProbabilityOf [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    c.errorProbability W hM = decodingErrorProbabilityOf
      (c.messageInputOutputLaw W hM) Prod.fst (fun z => z.2.2) c.decoder := by
  rw [decodingErrorProbabilityOf, c.messageInputOutputLaw_map_messageOutput]
  rfl

/-- The same error is the real mass of the message-decoding failure event. -/
theorem errorProbability_eq_toOuterMeasure [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    c.errorProbability W hM = ((c.messageInputOutputLaw W hM).toOuterMeasure
      {z | c.decoder z.2.2 ≠ z.1}).toReal := by
  rw [c.errorProbability_eq_decodingErrorProbabilityOf,
    decodingErrorProbabilityOf_eq_toOuterMeasure]

/-- Error is the uniform average of each message's conditional error mass. -/
theorem errorProbability_eq_sum [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    c.errorProbability W hM = (1 / (M : ℝ)) *
      ∑ m, ∑ y, if c.decoder y ≠ m then
        (PMF.memorylessChannel W n (c.encoder m) y).toReal else 0 := by
  classical
  rw [errorProbability, decodingErrorProbability_eq_sum, Fintype.sum_prod_type]
  simp_rw [c.messageOutputLaw_apply W hM, ENNReal.toReal_mul,
    ENNReal.toReal_inv, ENNReal.toReal_natCast]
  simp only [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro m _
  apply Finset.sum_congr rfl
  intro y _
  split <;> simp_all [one_div]

/-- Average block error is nonnegative. -/
theorem errorProbability_nonneg [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    0 ≤ c.errorProbability W hM :=
  decodingErrorProbability_nonneg _ _

/-- Average block error is at most one, including complete decoding failure. -/
theorem errorProbability_le_one [Fintype B]
    (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    c.errorProbability W hM ≤ 1 :=
  decodingErrorProbability_le_one _ _

/-- One message is always recovered, at any blocklength. -/
theorem errorProbability_one [Fintype B] (c : BlockChannelCode A B n 1)
    (W : A → PMF B) : c.errorProbability W (by omega) = 0 := by
  rw [c.errorProbability_eq_sum]
  have h (y : Fin n → B) : c.decoder y = 0 := Subsingleton.elim _ _
  simp [h]

/-- With an empty received word, exactly one of the uniform message indices
is selected by the total decoder. This includes empty base alphabets. -/
theorem errorProbability_zero [Fintype B] (c : BlockChannelCode A B 0 M)
    (W : A → PMF B) (hM : 1 ≤ M) :
    c.errorProbability W hM = 1 - 1 / (M : ℝ) := by
  classical
  rw [c.errorProbability_eq_sum]
  simp only [PMF.memorylessChannel, PMF.productChannel_apply,
    Fin.prod_univ_zero, ENNReal.toReal_one, Fintype.sum_unique]
  have hsum : (∑ m : Fin M, if c.decoder default ≠ m then (1 : ℝ) else 0) =
      (M : ℝ) - 1 := by
    calc
      _ = ∑ m : Fin M, (1 - if c.decoder default = m then (1 : ℝ) else 0) := by
        apply Finset.sum_congr rfl
        intro m _
        by_cases h : c.decoder default = m <;> simp [h]
      _ = (M : ℝ) - 1 := by simp [Finset.sum_sub_distrib]
  rw [hsum]
  have hMr : (M : ℝ) ≠ 0 := by exact_mod_cast (show M ≠ 0 by omega)
  field_simp

/-- At length one, evaluating the output word recovers the original channel
joint law for the actual encoded symbol. -/
theorem messageOutputLaw_one_map [Fintype B] (c : BlockChannelCode A B 1 M)
    (W : A → PMF B) (hM : 1 ≤ M) :
    letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
    (c.messageOutputLaw W hM).map (fun z => (z.1, z.2 0)) =
      PMF.channelJoint (PMF.uniformOfFintype (Fin M))
        (fun m => W (c.encoder m 0)) := by
  unfold messageOutputLaw PMF.channelJoint
  rw [PMF.map_bind]
  congr 1
  funext m
  rw [PMF.map_comp]
  change (PMF.memorylessChannel W 1 (c.encoder m)).map
      ((fun b => (m, b)) ∘ (fun y => y 0)) = _
  rw [← PMF.map_comp]
  congr 1
  exact PMF.productChannel_map_eval _ _ 0

/-- One-letter block error is the uniform average over original output symbols. -/
theorem errorProbability_one_length_eq_sum [Fintype B]
    (c : BlockChannelCode A B 1 M) (W : A → PMF B) (hM : 1 ≤ M) :
    c.errorProbability W hM = (1 / (M : ℝ)) * ∑ m, ∑ b : B,
      if c.decoder (fun _ => b) ≠ m then (W (c.encoder m 0) b).toReal else 0 := by
  classical
  rw [c.errorProbability_eq_sum]
  congr 1
  apply Finset.sum_congr rfl
  intro m _
  apply Fintype.sum_equiv (Equiv.funUnique (Fin 1) B)
  intro y
  have hy : (fun _ : Fin 1 => y 0) = y := by
    funext i
    exact congrArg y (Subsingleton.elim _ _)
  simp [Equiv.funUnique, Equiv.piUnique, hy, PMF.memorylessChannel,
    PMF.productChannel_apply]

end BlockChannelCode
end
end LeanInfoTheory.Shannon
