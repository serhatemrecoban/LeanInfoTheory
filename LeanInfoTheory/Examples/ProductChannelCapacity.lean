/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ProductChannelCapacity

/-!
# Finite product-capacity consumers

Private consumers retain actual coordinate maximizing laws and repeat any
supplied achieving input. A heterogeneous product has different input and output
alphabets at its two coordinates. The duplicated fair bit is genuinely correlated
and has strictly less information than product capacity, using the existing
product-information identities and the core objective bound.

Singleton and empty products, blocklengths zero and one, and a vacuous channel
between empty base types exercise the domain boundaries. The vacuous channel's
zero-word capacity is formed only on the inhabited singleton word domain.

The C23-facing interface checks both capacity bounds on arbitrary input laws.
A noninjective encoder ignores a second message bit and repeats the first; its
two-letter pushforward is the correlated diagonal law already checked below.
-/

namespace LeanInfoTheory.Examples.ProductChannelCapacity

noncomputable section

universe u v w

open scoped BigOperators ENNReal
open LeanInfoTheory.Shannon

open Classical in
private theorem supplied_product_achieves
    {J : Type u} {A : J → Type v} {B : J → Type w}
    [Fintype J] [∀ j, Fintype (A j)] [∀ j, Nonempty (A j)]
    [∀ j, Fintype (B j)] (p : ∀ j, PMF (A j)) (W : ∀ j, A j → PMF (B j))
    (hp : ∀ j, mutualInfo (PMF.channelJoint (p j) (W j)) = channelCapacity (W j)) :
    mutualInfo (PMF.channelJoint (PMF.finiteProduct p) (PMF.productChannel W)) =
      channelCapacity (PMF.productChannel W) := by
  rw [mutualInfo_channelJoint_finiteProduct, channelCapacity_productChannel]
  exact Finset.sum_congr rfl fun j _ => hp j

open Classical in
private theorem selected_product_witness
    {J : Type u} {A : J → Type v} {B : J → Type w}
    [Fintype J] [∀ j, Fintype (A j)] [∀ j, Nonempty (A j)]
    [∀ j, Fintype (B j)] (W : ∀ j, A j → PMF (B j)) :
    ∃ p : ∀ j, PMF (A j),
      (∀ j, mutualInfo (PMF.channelJoint (p j) (W j)) = channelCapacity (W j)) ∧
      mutualInfo (PMF.channelJoint (PMF.finiteProduct p) (PMF.productChannel W)) =
        channelCapacity (PMF.productChannel W) := by
  classical
  choose p hp using fun j => exists_mutualInfo_channelJoint_eq_channelCapacity (W j)
  exact ⟨p, hp, supplied_product_achieves p W hp⟩

private theorem supplied_achiever_iid
    {A : Type v} {B : Type w} [Fintype A] [Nonempty A] [Fintype B]
    (p : PMF A) (W : A → PMF B)
    (hp : mutualInfo (PMF.channelJoint p W) = channelCapacity W) (n : ℕ) :
    mutualInfo (PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)) =
      channelCapacity (PMF.memorylessChannel W n) := by
  rw [mutualInfo_channelJoint_iid, hp, channelCapacity_memorylessChannel]

private theorem arbitrary_block_input_bound
    {A : Type v} {B : Type w} [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (n : ℕ) (q : PMF (Fin n → A)) :
    mutualInfo (PMF.channelJoint q (PMF.memorylessChannel W n)) ≤
      (n : ℝ) * channelCapacity W :=
  mutualInfo_channelJoint_memorylessChannel_le W n q

/-! ## A strict gap for a correlated duplicated bit -/

private def fair : PMF Bool := PMF.uniformOfFintype Bool

private theorem fair_mass (b : Bool) : fair b = ENNReal.ofReal (1 / 2 : ℝ) := by
  norm_num [fair, PMF.uniformOfFintype_apply, ENNReal.ofReal_div_of_pos]

private theorem fair_entropy : entropy fair = Real.log 2 := by
  simpa [fair] using (entropy_uniformOfFintype (alpha := Bool))

private theorem identity_information {A : Type v} [Fintype A] (p : PMF A) :
    mutualInfo (PMF.channelJoint p (PMF.deterministicChannel id)) = entropy p := by
  rw [PMF.channelJoint_deterministicChannel]
  exact mutualInfo_map_diag p

private theorem fair_achieves_identity :
    mutualInfo (PMF.channelJoint fair (PMF.deterministicChannel id)) =
      channelCapacity (PMF.deterministicChannel (id : Bool → Bool)) := by
  apply le_antisymm (mutualInfo_channelJoint_le_channelCapacity fair _)
  rw [identity_information, fair_entropy]
  simpa using channelCapacity_le_log_card_input (PMF.deterministicChannel (id : Bool → Bool))

private def diagonal : PMF (Fin 2 → Bool) := fair.map (fun b _ => b)

private theorem diagonal_eval (i : Fin 2) : diagonal.map (fun x => x i) = fair := by
  rw [diagonal, PMF.map_comp]
  exact PMF.map_id _

private theorem diagonal_off_atom : diagonal (![false, true]) = 0 := by
  apply PMF.map_apply_eq_zero_of_notMem_range fair
  rintro ⟨b, h⟩
  have h0 : b = false := congrFun h 0
  have h1 : b = true := congrFun h 1
  cases h0.symm.trans h1

private theorem diagonal_correlated :
    diagonal ≠ PMF.finiteProduct (fun i : Fin 2 => diagonal.map (fun x => x i)) := by
  intro h
  have hm := congrArg (fun p : PMF (Fin 2 → Bool) => p (![false, true])) h
  rw [diagonal_off_atom, PMF.finiteProduct_apply, Fin.prod_univ_two] at hm
  simp only [diagonal_eval, fair_mass] at hm
  norm_num [← ENNReal.ofReal_mul] at hm

private def identityRows (_ : Fin 2) : Bool → PMF Bool := PMF.deterministicChannel id

private theorem diagonal_identity_information :
    mutualInfo (PMF.channelJoint diagonal (PMF.productChannel identityRows)) =
      Real.log 2 := by
  unfold identityRows
  rw [PMF.productChannel_deterministicChannel]
  change mutualInfo (PMF.channelJoint diagonal (PMF.deterministicChannel id)) = Real.log 2
  rw [identity_information, diagonal,
    entropy_map_injective fair (fun _ _ h => congrFun h 0), fair_entropy]

private theorem independent_identity_information :
    mutualInfo (PMF.channelJoint (PMF.finiteProduct (fun _ : Fin 2 => fair))
      (PMF.productChannel identityRows)) = 2 * Real.log 2 := by
  have h := mutualInfo_channelJoint_finiteProduct (fun _ : Fin 2 => fair) identityRows
  simp only [identityRows, identity_information, fair_entropy, Fin.sum_univ_two] at h
  rw [two_mul]
  convert! h

private theorem independent_identity_attainment :
    mutualInfo (PMF.channelJoint (PMF.finiteProduct (fun _ : Fin 2 => fair))
      (PMF.productChannel identityRows)) = channelCapacity (PMF.productChannel identityRows) := by
  have h := supplied_product_achieves (fun _ : Fin 2 => fair) identityRows
    (fun _ => fair_achieves_identity)
  convert! h

private theorem diagonal_capacity_gap_strict :
    mutualInfo (PMF.channelJoint diagonal (PMF.productChannel identityRows)) <
      channelCapacity (PMF.productChannel identityRows) := by
  have hbound := mutualInfo_channelJoint_le_channelCapacity
    (PMF.finiteProduct (fun _ : Fin 2 => fair)) (PMF.productChannel identityRows)
  rw [independent_identity_information] at hbound
  rw [diagonal_identity_information]
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  linarith

private theorem diagonal_memoryless_bound :
    mutualInfo (PMF.channelJoint diagonal
      (PMF.memorylessChannel (PMF.deterministicChannel (id : Bool → Bool)) 2)) ≤
        2 * channelCapacity (PMF.deterministicChannel (id : Bool → Bool)) := by
  simpa using mutualInfo_channelJoint_memorylessChannel_le
    (PMF.deterministicChannel (id : Bool → Bool)) 2 diagonal

/-! ## Heterogeneous coordinate alphabets and an explicit attaining product -/

private abbrev HeterogeneousInput : Bool → Type
  | false => Bool
  | true => Fin 3

private abbrev HeterogeneousOutput : Bool → Type
  | false => Bool
  | true => Unit

private instance heterogeneousInputFintype (i : Bool) : Fintype (HeterogeneousInput i) := by
  cases i <;> dsimp [HeterogeneousInput] <;> infer_instance

private instance heterogeneousInputNonempty (i : Bool) : Nonempty (HeterogeneousInput i) := by
  cases i <;> dsimp [HeterogeneousInput] <;> infer_instance

private instance heterogeneousOutputFintype (i : Bool) : Fintype (HeterogeneousOutput i) := by
  cases i <;> dsimp [HeterogeneousOutput] <;> infer_instance

private def heterogeneousRows : (i : Bool) → HeterogeneousInput i → PMF (HeterogeneousOutput i)
  | false => PMF.deterministicChannel id
  | true => fun _ => PMF.pure ()

private def heterogeneousInputs : (i : Bool) → PMF (HeterogeneousInput i)
  | false => fair
  | true => PMF.pure 0

private theorem heterogeneous_capacity :
    channelCapacity (PMF.productChannel heterogeneousRows) =
      channelCapacity (heterogeneousRows false) + channelCapacity (heterogeneousRows true) := by
  have h := channelCapacity_productChannel heterogeneousRows
  rw [Fintype.sum_bool, add_comm] at h
  convert! h

private theorem unit_output_capacity {A : Type v} [Fintype A] [Nonempty A]
    (W : A → PMF Unit) : channelCapacity W = 0 := by
  apply le_antisymm _ (channelCapacity_nonneg W)
  simpa using channelCapacity_le_log_card_output W

private theorem heterogeneous_attainment :
    mutualInfo (PMF.channelJoint (PMF.finiteProduct heterogeneousInputs)
      (PMF.productChannel heterogeneousRows)) =
        channelCapacity (PMF.productChannel heterogeneousRows) := by
  have hp (i : Bool) :
      mutualInfo (PMF.channelJoint (heterogeneousInputs i) (heterogeneousRows i)) =
        channelCapacity (heterogeneousRows i) := by
    cases i
    · exact fair_achieves_identity
    · apply le_antisymm (mutualInfo_channelJoint_le_channelCapacity _ _)
      rw [unit_output_capacity]
      exact mutualInfo_nonneg _
  have h := supplied_product_achieves heterogeneousInputs heterogeneousRows hp
  convert! h

/-! ## Singleton, empty, zero-length and one-length domains -/

private theorem singleton_index_capacity
    {A : Type v} {B : Type w} [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) :
    channelCapacity (PMF.productChannel (fun _ : Unit => W)) = channelCapacity W := by
  have h := channelCapacity_productChannel (fun _ : Unit => W)
  simp only [Fintype.sum_unique] at h
  convert! h

open Classical in
private theorem singleton_input_alphabets_capacity
    {J : Type u} {B : J → Type w} [Fintype J] [∀ j, Fintype (B j)]
    (W : ∀ j, Unit → PMF (B j)) : channelCapacity (PMF.productChannel W) = 0 := by
  apply le_antisymm _ (channelCapacity_nonneg _)
  simpa using channelCapacity_le_log_card_input (PMF.productChannel W)

open Classical in
private theorem empty_dependent_product_capacity
    {J : Type u} {A : J → Type v} {B : J → Type w}
    [Fintype J] [IsEmpty J] [∀ j, Fintype (A j)] [∀ j, Fintype (B j)]
    (W : ∀ j, A j → PMF (B j)) : channelCapacity (PMF.productChannel W) = 0 := by
  classical
  let : ∀ j, Nonempty (A j) := fun j => isEmptyElim j
  rw [channelCapacity_productChannel]
  simp

private theorem memoryless_capacity_zero_and_one
    {A : Type v} {B : Type w} [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) :
    channelCapacity (PMF.memorylessChannel W 0) = 0 ∧
      channelCapacity (PMF.memorylessChannel W 1) = channelCapacity W := by
  simp only [channelCapacity_memorylessChannel, Nat.cast_zero, zero_mul, Nat.cast_one, one_mul,
    and_self]

private theorem supplied_achiever_iid_zero_and_one
    {A : Type v} {B : Type w} [Fintype A] [Nonempty A] [Fintype B]
    (p : PMF A) (W : A → PMF B)
    (hp : mutualInfo (PMF.channelJoint p W) = channelCapacity W) :
    mutualInfo (PMF.channelJoint (PMF.iid p 0) (PMF.memorylessChannel W 0)) = 0 ∧
      mutualInfo (PMF.channelJoint (PMF.iid p 1) (PMF.memorylessChannel W 1)) =
        channelCapacity W := by
  rw [supplied_achiever_iid p W hp 0, supplied_achiever_iid p W hp 1]
  exact memoryless_capacity_zero_and_one W

private theorem arbitrary_block_zero_and_one
    {A : Type v} {B : Type w} [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (q₀ : PMF (Fin 0 → A)) (q₁ : PMF (Fin 1 → A)) :
    mutualInfo (PMF.channelJoint q₀ (PMF.memorylessChannel W 0)) ≤ 0 ∧
      mutualInfo (PMF.channelJoint q₁ (PMF.memorylessChannel W 1)) ≤ channelCapacity W := by
  constructor
  · simpa using mutualInfo_channelJoint_memorylessChannel_le W 0 q₀
  · simpa using mutualInfo_channelJoint_memorylessChannel_le W 1 q₁

private def vacuousBase : Empty → PMF Empty := fun a => nomatch a

private theorem vacuous_zero_word_domain : Nonempty (Fin 0 → Empty) ∧
    Fintype.card (Fin 0 → Empty) = 1 := by
  exact ⟨⟨fun i => Fin.elim0 i⟩, by simp⟩

private theorem vacuous_zero_word_capacity :
    channelCapacity (PMF.memorylessChannel vacuousBase 0) = 0 := by
  apply le_antisymm _ (channelCapacity_nonneg _)
  simpa using channelCapacity_le_log_card_input (PMF.memorylessChannel vacuousBase 0)

private theorem vacuous_zero_word_attainment :
    mutualInfo (PMF.channelJoint (PMF.pure (fun i : Fin 0 => Fin.elim0 i))
      (PMF.memorylessChannel vacuousBase 0)) =
        channelCapacity (PMF.memorylessChannel vacuousBase 0) := by
  apply le_antisymm (mutualInfo_channelJoint_le_channelCapacity _ _)
  rw [vacuous_zero_word_capacity]
  exact mutualInfo_nonneg _

/-! ## C23-facing bounds and a noninjective encoder -/

private theorem c23_arbitrary_input_bounds
    {A : Type v} {B : Type w} [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (p : PMF A) (n : ℕ) (q : PMF (Fin n → A)) :
    mutualInfo (PMF.channelJoint p W) ≤ channelCapacity W ∧
      mutualInfo (PMF.channelJoint q (PMF.memorylessChannel W n)) ≤
        (n : ℝ) * channelCapacity W :=
  ⟨mutualInfo_channelJoint_le_channelCapacity p W,
    mutualInfo_channelJoint_memorylessChannel_le W n q⟩

private def messages : PMF (Bool × Bool) := indepProd fair fair

private def repeatedFirst (n : ℕ) (m : Bool × Bool) : Fin n → Bool := fun _ => m.1

private theorem repeatedFirst_not_injective (n : ℕ) :
    ¬ Function.Injective (repeatedFirst n) := by
  intro h
  have hp := h (show repeatedFirst n (false, false) = repeatedFirst n (false, true) from rfl)
  have hs := congrArg Prod.snd hp
  cases hs

private theorem message_pushforward_two : messages.map (repeatedFirst 2) = diagonal := by
  change (indepProd fair fair).map ((fun (b : Bool) (_ : Fin 2) => b) ∘ Prod.fst) =
    fair.map (fun (b : Bool) (_ : Fin 2) => b)
  rw [← PMF.map_comp]
  change (fstMarginal (indepProd fair fair)).map (fun (b : Bool) (_ : Fin 2) => b) =
    fair.map (fun (b : Bool) (_ : Fin 2) => b)
  rw [fstMarginal_indepProd]

private theorem encoded_words_correlated :
    messages.map (repeatedFirst 2) ≠ PMF.finiteProduct
      (fun i : Fin 2 => (messages.map (repeatedFirst 2)).map (fun x => x i)) := by
  simpa only [message_pushforward_two] using diagonal_correlated

private theorem encoded_word_bound {B : Type w} [Fintype B]
    (W : Bool → PMF B) (n : ℕ) :
    mutualInfo (PMF.channelJoint (messages.map (repeatedFirst n))
      (PMF.memorylessChannel W n)) ≤ (n : ℝ) * channelCapacity W :=
  mutualInfo_channelJoint_memorylessChannel_le W n (messages.map (repeatedFirst n))

private theorem encoded_zero_and_one_bound {B : Type w} [Fintype B]
    (W : Bool → PMF B) :
    mutualInfo (PMF.channelJoint (messages.map (repeatedFirst 0))
      (PMF.memorylessChannel W 0)) ≤ 0 ∧
      mutualInfo (PMF.channelJoint (messages.map (repeatedFirst 1))
        (PMF.memorylessChannel W 1)) ≤ channelCapacity W := by
  constructor
  · simpa using encoded_word_bound W 0
  · simpa using encoded_word_bound W 1

end

end LeanInfoTheory.Examples.ProductChannelCapacity
