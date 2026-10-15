/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.Iid

/-!
# Finite product channels

`PMF.productChannel` samples the coordinate output channels independently at a
supplied input word. It is a raw PMF-valued function, built from
`PMF.finiteProduct`, with no input distribution or finite-input assumption.
Independence of each conditional row does not assert independence under an
arbitrary input law. The input and output alphabets may depend on the coordinate
and live in different universes.

Atoms and support are coordinatewise; evaluation and injective restriction
recover the selected channels at the selected input. Zero masses are allowed.
For a finite selection from an infinite ambient index, first use the finite
selected subtype as the index; no infinite product channel is constructed.
An empty index admits the pure empty output. An empty input alphabet permits a
vacuous channel, whereas an inhabited input cannot have a PMF on an empty output.

These finite conditional products follow the distinction in PW24 Sections 6.1
and 19.1. Independent input products are preserved by coordinate processing;
sequential product channels compose coordinatewise in sampling order, and
deterministic coordinate channels reduce to the existing deterministic channel.
Only the independent-input product law requires finite input alphabets.
`memorylessChannel W n` repeats the same channel at all `n` coordinates.
Its conditional rows are independent; neither its input law nor its output
under an arbitrary input law is required to be iid. Finite block transports
reuse the existing product-law equivalences, including at length zero.
Joint coordinate and block projections use the actual input law, which may be
correlated. For independent inputs, the entire joint is the transported product
of coordinate input-output joints, through the existing tuple/pair equivalence.
This owner has no project Shannon or information-measure dependency.
-/

open scoped BigOperators

namespace PMF

universe u v w t z

variable {I : Type u} {A : I → Type v} {B : I → Type w}
  [Fintype I] [∀ i, Fintype (B i)]

/-- The product of finite-output coordinate channels, evaluated at an input word.
No input distribution or independence assumption on inputs is required. -/
noncomputable def productChannel (W : ∀ i, A i → PMF (B i))
    (x : (i : I) → A i) : PMF ((i : I) → B i) :=
  finiteProduct (fun i => W i (x i))

/-- A product-channel row atom is the product of the coordinate row masses. -/
theorem productChannel_apply (W : ∀ i, A i → PMF (B i))
    (x : (i : I) → A i) (y : (i : I) → B i) :
    productChannel W x y = ∏ i, W i (x i) (y i) :=
  finiteProduct_apply (fun i => W i (x i)) y

/-- An output word is supported exactly when each coordinate row supports it. -/
theorem mem_support_productChannel_iff (W : ∀ i, A i → PMF (B i))
    (x : (i : I) → A i) (y : (i : I) → B i) :
    y ∈ (productChannel W x).support ↔ ∀ i, y i ∈ (W i (x i)).support :=
  mem_support_finiteProduct_iff (fun i => W i (x i)) y

/-- Evaluating a product-channel output at a coordinate recovers that input row. -/
theorem productChannel_map_eval (W : ∀ i, A i → PMF (B i))
    (x : (i : I) → A i) (i : I) :
    (productChannel W x).map (fun y => y i) = W i (x i) :=
  finiteProduct_map_eval (fun i => W i (x i)) i

/-- Selecting distinct output coordinates gives the selected channel at the
selected input. Injectivity excludes repetition of a single output sample. -/
theorem productChannel_map_restrict {J : Type t} [Fintype J]
    (W : ∀ i, A i → PMF (B i)) (x : (i : I) → A i) (e : J ↪ I) :
    (productChannel W x).map (fun y j => y (e j)) =
      productChannel (fun j => W (e j)) (fun j => x (e j)) :=
  finiteProduct_map_restrict (fun i => W i (x i)) e

/-! ## Independent processing and channel algebra -/

/-- Processing independent finite input laws coordinatewise gives the product
of their output laws. Zero input and channel masses are allowed. -/
theorem finiteProduct_bind_productChannel [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (W : ∀ i, A i → PMF (B i)) :
    (finiteProduct p).bind (productChannel W) =
      finiteProduct (fun i => (p i).bind (W i)) := by
  classical
  apply PMF.ext
  intro y
  simp only [PMF.bind_apply, tsum_fintype, finiteProduct_apply,
    productChannel_apply, ← Finset.prod_mul_distrib]
  exact (Fintype.prod_sum (fun i (a : A i) => p i a * W i a (y i))).symm

/-- Sampling one product channel and then another equals the product of the
coordinate composites in that order. Original input alphabets may be infinite. -/
theorem channelComp_productChannel {C : I → Type z} [∀ i, Fintype (C i)]
    (W : ∀ i, A i → PMF (B i)) (V : ∀ i, B i → PMF (C i)) :
    channelComp (productChannel W) (productChannel V) =
      productChannel (fun i => channelComp (W i) (V i)) := by
  funext x
  exact finiteProduct_bind_productChannel (fun i => W i (x i)) V

/-- Deterministic coordinate channels form the existing deterministic channel
on input words; no input law or finite-input assumption is needed. -/
theorem productChannel_deterministicChannel (f : ∀ i, A i → B i) :
    productChannel (fun i => deterministicChannel (f i)) =
      deterministicChannel (fun x i => f i (x i)) := by
  funext x
  exact finiteProduct_pure (fun i => f i (x i))

/-- Repeating one finite-output channel for a finite block. Independence refers
to the conditional output row at the supplied input word, not to an input law.
At length zero the row is the pure empty output; no positivity is required. -/
noncomputable def memorylessChannel {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (n : ℕ) : (Fin n → A) → PMF (Fin n → B) :=
  productChannel (fun _ : Fin n => W)

/-! ## Joint laws and coordinate-pair factorization -/

/-- The coordinate input-output joint uses the actual input marginal. The input
law can be correlated and the input alphabets need not be finite. -/
theorem channelJoint_productChannel_map_eval
    (q : PMF ((i : I) → A i)) (W : ∀ i, A i → PMF (B i)) (i : I) :
    (channelJoint q (productChannel W)).map (fun xy => (xy.1 i, xy.2 i)) =
      channelJoint (q.map (fun x => x i)) (W i) := by
  unfold channelJoint
  rw [PMF.map_bind, PMF.bind_map]
  apply congrArg (PMF.bind q)
  funext x
  rw [PMF.map_comp]
  change (productChannel W x).map ((fun b => (x i, b)) ∘ (fun y => y i)) = _
  rw [← PMF.map_comp, productChannel_map_eval]
  rfl

/-- Restricting both words in a product-channel joint gives the selected channel
with the restricted actual input law. No input independence is required. -/
theorem channelJoint_productChannel_map_restrict {J : Type t} [Fintype J]
    (q : PMF ((i : I) → A i)) (W : ∀ i, A i → PMF (B i)) (e : J ↪ I) :
    (channelJoint q (productChannel W)).map
        (fun xy => ((fun j => xy.1 (e j)), (fun j => xy.2 (e j)))) =
      channelJoint (q.map (fun x j => x (e j)))
        (productChannel (fun j => W (e j))) := by
  unfold channelJoint
  rw [PMF.map_bind, PMF.bind_map]
  apply congrArg (PMF.bind q)
  funext x
  rw [PMF.map_comp]
  change (productChannel W x).map
    ((fun b => ((fun j => x (e j)), b)) ∘ (fun y j => y (e j))) = _
  rw [← PMF.map_comp, productChannel_map_restrict]
  rfl

/-- For independent finite inputs, splitting the tuple of coordinate joints
gives exactly the joint of the input product and the product channel. -/
theorem finiteProduct_channelJoint_map [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (W : ∀ i, A i → PMF (B i)) :
    (finiteProduct (fun i => channelJoint (p i) (W i))).map
        (Equiv.arrowProdEquivProdArrow I A B) =
      channelJoint (finiteProduct p) (productChannel W) := by
  classical
  apply PMF.ext
  intro xy
  obtain ⟨z, rfl⟩ := (Equiv.arrowProdEquivProdArrow I A B).surjective xy
  rw [PMF.map_apply_equiv, finiteProduct_apply]
  change (∏ i, channelJoint (p i) (W i) ((z i).1, (z i).2)) =
    channelJoint (finiteProduct p) (productChannel W) (fun i => (z i).1, fun i => (z i).2)
  simp only [channelJoint_apply, finiteProduct_apply, productChannel_apply,
    Finset.prod_mul_distrib]

end PMF
