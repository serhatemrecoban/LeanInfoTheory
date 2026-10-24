/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCapacity
import LeanInfoTheory.Shannon.SemanticBridge.ProductChannel

/-!
# Capacity of finite product channels

Information capacity adds over heterogeneous finite product channels. The upper
bound applies to every input law, including correlated laws, through its actual
coordinate marginals. For the lower bound, choose an attaining law for each
coordinate and use their existing finite product.

Repeated-channel capacity is blocklength times one-letter capacity in nats,
including blocklength zero. Any supplied attaining one-letter law has an attaining
iid repetition. These statements concern information capacity, not an operational
coding theorem. See PW24 §6.1, Theorem 6.1(a) and Example 6.1, in
`docs/references.md`.
-/

open scoped BigOperators

namespace LeanInfoTheory.Shannon

universe u v w

open Classical in
private theorem product_objective_le_sum_capacity
    {J : Type u} {A : J → Type v} {B : J → Type w}
    [Fintype J] [∀ j, Fintype (A j)] [∀ j, Nonempty (A j)]
    [∀ j, Fintype (B j)]
    (q : PMF ((j : J) → A j)) (W : ∀ j, A j → PMF (B j)) :
    mutualInfo (PMF.channelJoint q (PMF.productChannel W)) ≤
      ∑ j, channelCapacity (W j) := by
  let f : J → ℝ := fun j => mutualInfo (PMF.channelJoint (q.map (fun x => x j)) (W j))
  have hf : ∀ j, f j ≤ channelCapacity (W j) := by
    intro j
    have hj := mutualInfo_channelJoint_le_channelCapacity (q.map (fun x => x j)) (W j)
    convert! hj
  have hsum : (∑ j, f j) ≤ ∑ j, channelCapacity (W j) :=
    Finset.sum_le_sum (s := Finset.univ) (f := f) (g := fun j => channelCapacity (W j))
      (fun j _ => hf j)
  have hbound : mutualInfo (PMF.channelJoint q (PMF.productChannel W)) ≤ ∑ j, f j := by
    convert! mutualInfo_channelJoint_productChannel_le q W
  exact hbound.trans hsum

open Classical in
private theorem exists_product_attaining_sum_capacity
    {J : Type u} {A : J → Type v} {B : J → Type w}
    [Fintype J] [∀ j, Fintype (A j)] [∀ j, Nonempty (A j)]
    [∀ j, Fintype (B j)] (W : ∀ j, A j → PMF (B j)) :
    ∃ p : ∀ j, PMF (A j),
      (∀ j, mutualInfo (PMF.channelJoint (p j) (W j)) = channelCapacity (W j)) ∧
      mutualInfo (PMF.channelJoint (PMF.finiteProduct p) (PMF.productChannel W)) =
        ∑ j, channelCapacity (W j) := by
  choose p hp using fun j => exists_mutualInfo_channelJoint_eq_channelCapacity (W j)
  refine ⟨p, hp, ?_⟩
  rw [mutualInfo_channelJoint_finiteProduct]
  exact Finset.sum_congr rfl fun j _ => hp j

open Classical in
/-- Capacity adds over finite heterogeneous product channels. The supremum
ranges over every input law; independent maximizing inputs attain the sum.
The index may be empty, and its universe is independent of both alphabet universes. -/
theorem channelCapacity_productChannel
    {J : Type u} {A : J → Type v} {B : J → Type w}
    [Fintype J] [∀ j, Fintype (A j)] [∀ j, Nonempty (A j)]
    [∀ j, Fintype (B j)] (W : ∀ j, A j → PMF (B j)) :
    channelCapacity (PMF.productChannel W) = ∑ j, channelCapacity (W j) := by
  apply le_antisymm
  · exact (channelCapacity_le_iff _ _).2 fun q => product_objective_le_sum_capacity q W
  · obtain ⟨p, _, hp⟩ := exists_product_attaining_sum_capacity W
    rw [← hp]
    exact mutualInfo_channelJoint_le_channelCapacity (PMF.finiteProduct p) _

/-- Repeating a finite channel multiplies its capacity by the blocklength,
including blocklength zero. -/
theorem channelCapacity_memorylessChannel
    {A : Type v} {B : Type w} [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (n : ℕ) :
    channelCapacity (PMF.memorylessChannel W n) = (n : ℝ) * channelCapacity W := by
  have h := channelCapacity_productChannel (fun _ : Fin n => W)
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul] at h
  convert! h

/-- Every block input, including correlated inputs, has mutual information at
most the blocklength times one-letter capacity. No positive-length premise is needed. -/
theorem mutualInfo_channelJoint_memorylessChannel_le
    {A : Type v} {B : Type w} [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (n : ℕ) (q : PMF (Fin n → A)) :
    mutualInfo (PMF.channelJoint q (PMF.memorylessChannel W n)) ≤
      (n : ℝ) * channelCapacity W := by
  calc
    mutualInfo (PMF.channelJoint q (PMF.memorylessChannel W n)) ≤
        channelCapacity (PMF.memorylessChannel W n) :=
      mutualInfo_channelJoint_le_channelCapacity q _
    _ = (n : ℝ) * channelCapacity W := channelCapacity_memorylessChannel W n

private theorem iid_attains_memoryless_capacity
    {A : Type v} {B : Type w} [Fintype A] [Nonempty A] [Fintype B]
    (p : PMF A) (W : A → PMF B)
    (hp : mutualInfo (PMF.channelJoint p W) = channelCapacity W) (n : ℕ) :
    mutualInfo (PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)) =
      channelCapacity (PMF.memorylessChannel W n) := by
  rw [mutualInfo_channelJoint_iid, hp, channelCapacity_memorylessChannel]

end LeanInfoTheory.Shannon
