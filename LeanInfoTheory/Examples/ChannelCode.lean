/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCode

/-!
# Deterministic block channel-code consumers

These private consumers use the focused code-law interface with arbitrary input
types and finite output types. The message, input, output and pair projections
refer to one actual law, and error retains its Fano and failure-event meanings.

A one-letter three-message noiseless code has unequal encoder fibers. Its input
masses are two thirds and one third; two positive-mass messages share a codeword,
and the decoder never returns one of those messages. Singleton messages and
zero-length words keep their distinct error conventions.
-/

namespace LeanInfoTheory.Examples.ChannelCode

noncomputable section

universe u v

open scoped BigOperators
open LeanInfoTheory.Shannon

private theorem actual_marginals {A : Type u} {B : Type v} [Fintype B]
    {n M : ℕ} (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
    let U := PMF.uniformOfFintype (Fin M)
    let Q := c.messageInputOutputLaw W hM
    Q.map Prod.fst = U ∧
      Q.map (fun z => z.2.1) = U.map c.encoder ∧
      Q.map (fun z => z.2.2) = (U.map c.encoder).bind (PMF.memorylessChannel W n) ∧
      Q.map (fun z => (z.1, z.2.1)) = U.map (fun m => (m, c.encoder m)) ∧
      Q.map Prod.snd = PMF.channelJoint (U.map c.encoder) (PMF.memorylessChannel W n) ∧
      Q.map (fun z => (z.1, z.2.2)) = c.messageOutputLaw W hM ∧
      (c.messageOutputLaw W hM).map Prod.fst = U := by
  exact ⟨c.messageInputOutputLaw_map_message W hM,
    c.messageInputOutputLaw_map_input W hM,
    c.messageInputOutputLaw_map_output W hM,
    c.messageInputOutputLaw_map_messageInput W hM,
    c.messageInputOutputLaw_map_inputOutput W hM,
    c.messageInputOutputLaw_map_messageOutput W hM,
    c.messageOutputLaw_map_fst W hM⟩

private theorem actual_error {A : Type u} {B : Type v} [Fintype B]
    {n M : ℕ} (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    c.errorProbability W hM = decodingErrorProbabilityOf
        (c.messageInputOutputLaw W hM) Prod.fst (fun z => z.2.2) c.decoder ∧
      c.errorProbability W hM = ((c.messageInputOutputLaw W hM).toOuterMeasure
        {z | c.decoder z.2.2 ≠ z.1}).toReal ∧
      0 ≤ c.errorProbability W hM ∧ c.errorProbability W hM ≤ 1 :=
  ⟨c.errorProbability_eq_decodingErrorProbabilityOf W hM,
    c.errorProbability_eq_toOuterMeasure W hM,
    c.errorProbability_nonneg W hM, c.errorProbability_le_one W hM⟩

private theorem actual_average {A : Type u} {B : Type v} [Fintype B]
    {n M : ℕ} (c : BlockChannelCode A B n M) (W : A → PMF B) (hM : 1 ≤ M) :
    c.errorProbability W hM = (1 / (M : ℝ)) *
      ∑ m, ∑ y, if c.decoder y ≠ m then
        (PMF.memorylessChannel W n (c.encoder m) y).toReal else 0 :=
  c.errorProbability_eq_sum W hM

private theorem singleton_message {A : Type u} {B : Type v} [Fintype B]
    {n : ℕ} (c : BlockChannelCode A B n 1) (W : A → PMF B) :
    c.errorProbability W (by decide) = 0 :=
  c.errorProbability_one W

private theorem zero_length {A : Type u} {B : Type v} [Fintype B]
    {M : ℕ} (c : BlockChannelCode A B 0 M) (W : A → PMF B) (hM : 1 ≤ M) :
    c.errorProbability W hM = 1 - 1 / (M : ℝ) :=
  c.errorProbability_zero W hM

private theorem one_letter_law {A : Type u} {B : Type v} [Fintype B]
    {M : ℕ} (c : BlockChannelCode A B 1 M) (W : A → PMF B) (hM : 1 ≤ M) :
    letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
    (c.messageOutputLaw W hM).map (fun z => (z.1, z.2 0)) =
      PMF.channelJoint (PMF.uniformOfFintype (Fin M))
        (fun m => W (c.encoder m 0)) :=
  c.messageOutputLaw_one_map W hM

private theorem one_letter_average {A : Type u} {B : Type v} [Fintype B]
    {M : ℕ} (c : BlockChannelCode A B 1 M) (W : A → PMF B) (hM : 1 ≤ M) :
    c.errorProbability W hM = (1 / (M : ℝ)) * ∑ m, ∑ b : B,
      if c.decoder (fun _ => b) ≠ m then (W (c.encoder m 0) b).toReal else 0 :=
  c.errorProbability_one_length_eq_sum W hM

private def vacuousChannel : Empty → PMF Empty := fun a => nomatch a

private def emptyWordsThree : BlockChannelCode Empty Empty 0 3 :=
  (fun _ i => Fin.elim0 i, fun _ => 0)

private theorem empty_base_zero_word_error :
    emptyWordsThree.errorProbability vacuousChannel (by decide) = 2 / 3 := by
  rw [emptyWordsThree.errorProbability_zero]
  norm_num

/-! ## Unequal fibers retain all three message identities -/

private def unequal : BlockChannelCode Bool Bool 1 3 :=
  (fun m _ => if m = 2 then true else false, fun y => if y 0 then 2 else 0)

private def unequalInput : PMF (Fin 1 → Bool) :=
  (PMF.uniformOfFintype (Fin 3)).map unequal.encoder

private theorem unequal_input_false :
    (unequalInput (fun _ => false)).toReal = 2 / 3 := by
  norm_num [unequalInput, PMF.map_apply, tsum_fintype, Fin.sum_univ_succ,
    unequal, BlockChannelCode.encoder, funext_iff, Fin.forall_fin_one,
    PMF.uniformOfFintype_apply, Fin.ext_iff]
  rw [ENNReal.toReal_add (by norm_num) (by norm_num)]
  norm_num

private theorem unequal_input_true :
    (unequalInput (fun _ => true)).toReal = 1 / 3 := by
  norm_num [unequalInput, PMF.map_apply, tsum_fintype, Fin.sum_univ_succ,
    unequal, BlockChannelCode.encoder, funext_iff, Fin.forall_fin_one,
    PMF.uniformOfFintype_apply, Fin.ext_iff]

private theorem unequal_input_masses_differ :
    unequalInput (fun _ => false) ≠ unequalInput (fun _ => true) := by
  intro h
  have hreal := congrArg ENNReal.toReal h
  rw [unequal_input_false, unequal_input_true] at hreal
  norm_num at hreal

private theorem unequal_supported_collision :
    (0 : Fin 3) ∈ (PMF.uniformOfFintype (Fin 3)).support ∧
      (1 : Fin 3) ∈ (PMF.uniformOfFintype (Fin 3)).support ∧
      (0 : Fin 3) ≠ 1 ∧ unequal.encoder 0 = unequal.encoder 1 := by
  norm_num [PMF.mem_support_iff, PMF.uniformOfFintype_apply,
    unequal, BlockChannelCode.encoder, Fin.ext_iff]

private theorem unequal_unused_decoding_index (y : Fin 1 → Bool) :
    unequal.decoder y ≠ 1 := by
  cases hy : y 0 <;> simp [unequal, BlockChannelCode.decoder, hy]

private theorem unequal_actual_input :
    (unequal.messageInputOutputLaw (PMF.deterministicChannel id) (by decide)).map
      (fun z => z.2.1) = unequalInput :=
  unequal.messageInputOutputLaw_map_input (PMF.deterministicChannel id) (by decide)

private theorem unequal_error :
    unequal.errorProbability (PMF.deterministicChannel id) (by decide) = 1 / 3 := by
  rw [unequal.errorProbability_one_length_eq_sum]
  have h02 : (0 : Fin 3) ≠ 2 := by decide
  have h12 : (1 : Fin 3) ≠ 2 := by decide
  have h20 : (2 : Fin 3) ≠ 0 := by decide
  have h21 : (2 : Fin 3) ≠ 1 := by decide
  norm_num [Fin.sum_univ_succ, Fintype.sum_bool, unequal,
    BlockChannelCode.encoder, BlockChannelCode.decoder,
    PMF.deterministicChannel, PMF.pure_apply, h02, h12, h20, h21]

private theorem unequal_error_positive :
    0 < unequal.errorProbability (PMF.deterministicChannel id) (by decide) := by
  rw [unequal_error]
  norm_num

end

end LeanInfoTheory.Examples.ChannelCode
