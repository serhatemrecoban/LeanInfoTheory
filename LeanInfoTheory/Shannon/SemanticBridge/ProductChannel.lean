/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.ProductChannel
import LeanInfoTheory.Shannon.SemanticBridge.FiniteProduct
import LeanInfoTheory.Shannon.SemanticBridge.Convexity

/-!
# Information identities for finite product channels

Conditional output entropy adds over a finite product channel for any input
law, including correlated and sparse inputs. Each coordinate term uses its
actual input marginal. Since `condEntropy` means first given second, the
input-output joint is swapped to express output given input.

The proof averages row entropies and transports finite expectations through
coordinate maps. Null input rows have zero weight; conditional reconstruction
on a null input is not used or assigned a probabilistic meaning.

Mutual information is bounded by the sum of the actual coordinate mutual
informations. The exact gap is the output entropy subadditivity gap, so equality
holds precisely when the output coordinates are mutually independent. Independent
input laws suffice for equality; their product and iid specializations consume
the general independent-pair theorem through the exact joint-law transport.
-/

open scoped BigOperators

namespace LeanInfoTheory.Shannon

universe u v w

private theorem condEntropy_channelJoint_swap_eq_sum
    {α : Type v} {β : Type w} [Fintype α] [Fintype β]
    (p : PMF α) (W : α → PMF β) :
    condEntropy ((PMF.channelJoint p W).map Prod.swap) =
      ∑ a, (p a).toReal * entropy (W a) := by
  have h := mutualInfo_channelJoint_eq_entropy_bind_sub_sum p W
  rw [mutualInfo_eq_entropy_sndMarginal_sub_condEntropy_swap] at h
  simp only [sndMarginal, PMF.channelJoint_map_snd] at h
  linarith

private theorem sum_map_toReal_mul
    {α : Type v} {β : Type w} [Fintype α] [Fintype β]
    (p : PMF α) (f : α → β) (g : β → ℝ) :
    (∑ b, (p.map f b).toReal * g b) =
      ∑ a, (p a).toReal * g (f a) := by
  classical
  simp only [PMF.map, PMF.bind_toReal_apply, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  simp [PMF.pure_apply, apply_ite, ite_mul]

open Classical in
/-- Output-given-input entropy adds over a finite product channel for an
arbitrary input law. Coordinate terms use the actual input marginals; no
input independence or full-support premise is required. -/
theorem condEntropy_channelJoint_productChannel
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (q : PMF ((i : I) → A i)) (W : ∀ i, A i → PMF (B i)) :
    condEntropy ((PMF.channelJoint q (PMF.productChannel W)).map Prod.swap) =
      ∑ i, condEntropy
        ((PMF.channelJoint (q.map (fun x => x i)) (W i)).map Prod.swap) := by
  classical
  simp_rw [condEntropy_channelJoint_swap_eq_sum]
  simp_rw [PMF.productChannel, entropy_finiteProduct, Finset.mul_sum]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  exact (sum_map_toReal_mul q (fun x => x i) (fun a => entropy (W i a))).symm

open Classical in
private theorem familyEntropy_univ_eq_entropy
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)] (q : PMF ((i : I) → A i)) :
    familyEntropy q Finset.univ = entropy q := by
  change entropy (q.map ((Finset.univ : Finset I).restrict (π := A))) = _
  apply entropy_map_injective
  intro x y h
  funext i
  exact congrFun h ⟨i, Finset.mem_univ i⟩

private theorem bind_productChannel_map_eval
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (q : PMF ((i : I) → A i)) (W : ∀ i, A i → PMF (B i)) (i : I) :
    (q.bind (PMF.productChannel W)).map (fun y => y i) =
      (q.map (fun x => x i)).bind (W i) := by
  rw [PMF.map_bind, PMF.bind_map]
  apply congrArg (PMF.bind q)
  funext x
  exact PMF.productChannel_map_eval W x i

open Classical in
/-- The sum of coordinate mutual informations exceeds the block mutual
information by exactly the output entropy subadditivity gap. Input coordinates
may be correlated; every coordinate channel uses its actual input marginal. -/
theorem sum_mutualInfo_sub_mutualInfo_productChannel
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (q : PMF ((i : I) → A i)) (W : ∀ i, A i → PMF (B i)) :
    (∑ i, mutualInfo (PMF.channelJoint (q.map (fun x => x i)) (W i))) -
        mutualInfo (PMF.channelJoint q (PMF.productChannel W)) =
      (∑ i, entropy ((q.map (fun x => x i)).bind (W i))) -
        entropy (q.bind (PMF.productChannel W)) := by
  simp only [mutualInfo_eq_entropy_sndMarginal_sub_condEntropy_swap,
    sndMarginal, PMF.channelJoint_map_snd, condEntropy_channelJoint_productChannel,
    Finset.sum_sub_distrib]
  ring

open Classical in
/-- Mutual information through a product channel is at most the sum of the
coordinate mutual informations under the actual input marginals. No input
independence or full-support hypothesis is needed. -/
theorem mutualInfo_channelJoint_productChannel_le
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (q : PMF ((i : I) → A i)) (W : ∀ i, A i → PMF (B i)) :
    mutualInfo (PMF.channelJoint q (PMF.productChannel W)) ≤
      ∑ i, mutualInfo (PMF.channelJoint (q.map (fun x => x i)) (W i)) := by
  have h := familyEntropy_le_sum_singletons (q.bind (PMF.productChannel W)) Finset.univ
  simp only [familyEntropy_univ_eq_entropy, familyEntropy_singleton, entropyOf,
    bind_productChannel_map_eval] at h
  have hgap := sum_mutualInfo_sub_mutualInfo_productChannel q W
  linarith

open Classical in
/-- Equality in the product-channel mutual-information bound holds exactly
when the unconditional output coordinates are mutually independent. Pairwise
independence alone does not suffice; input independence is not necessary. -/
theorem mutualInfo_channelJoint_productChannel_eq_sum_iff
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (q : PMF ((i : I) → A i)) (W : ∀ i, A i → PMF (B i)) :
    mutualInfo (PMF.channelJoint q (PMF.productChannel W)) =
        ∑ i, mutualInfo (PMF.channelJoint (q.map (fun x => x i)) (W i)) ↔
      IsMutuallyIndependentFamily (q.bind (PMF.productChannel W)) Finset.univ := by
  have h := familyEntropy_eq_sum_singletons_iff_isMutuallyIndependentFamily
    (q.bind (PMF.productChannel W)) Finset.univ
  simp only [familyEntropy_univ_eq_entropy, familyEntropy_singleton, entropyOf,
    bind_productChannel_map_eval] at h
  have hgap := sum_mutualInfo_sub_mutualInfo_productChannel q W
  constructor
  · intro heq
    apply h.mp
    linarith
  · intro hind
    have heq := h.mpr hind
    linarith

open Classical in
/-- Independent coordinate inputs make product-channel mutual information
additive. Dependence between each coordinate's input and output is allowed. -/
theorem mutualInfo_channelJoint_finiteProduct
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (p : ∀ i, PMF (A i)) (W : ∀ i, A i → PMF (B i)) :
    mutualInfo (PMF.channelJoint (PMF.finiteProduct p) (PMF.productChannel W)) =
      ∑ i, mutualInfo (PMF.channelJoint (p i) (W i)) := by
  have h := mutualInfo_map_piProd_eq_sum_of_isMutuallyIndependentFamily
    (PMF.finiteProduct (fun i => PMF.channelJoint (p i) (W i)))
    (isMutuallyIndependentFamily_finiteProduct
      (fun i => PMF.channelJoint (p i) (W i)) Finset.univ)
  simpa only [PMF.finiteProduct_channelJoint_map, PMF.finiteProduct_map_eval] using h

/-- Mutual information for iid inputs through a repeated channel is the
blocklength times the one-coordinate mutual information, including length zero. -/
theorem mutualInfo_channelJoint_iid
    {A : Type v} {B : Type w} [Fintype A] [Fintype B]
    (p : PMF A) (W : A → PMF B) (n : ℕ) :
    mutualInfo (PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)) =
      (n : ℝ) * mutualInfo (PMF.channelJoint p W) := by
  have h := mutualInfo_channelJoint_finiteProduct (fun _ : Fin n => p)
    (fun _ : Fin n => W)
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul] at h
  convert! h

end LeanInfoTheory.Shannon
