/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.FiniteChannel
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Logic.Equiv.Basic
import Mathlib.Logic.Equiv.Set

/-!
# Finite dependent product laws

`PMF.finiteProduct` constructs a normalized law from finitely many finite-alphabet
component laws. Its atoms multiply, its support is coordinatewise, and evaluation
recovers each component law. Injective coordinate selection and equivalence
reindexing preserve products; sum-indexed products split into their ordered
blocks, and distinct coordinate pairs have the corresponding constant-channel
joint law. Zero component masses are allowed.

The index and alphabet universes are independent. For a finite subset of an
arbitrary ambient index type, use the subset as the index: only selected alphabets
need be finite. An empty index admits the unique empty outcome even when the
ambient alphabet is empty; a selected empty alphabet admits no component PMF.

This probability owner has no project Shannon or information-measure dependency.
-/

open scoped BigOperators

namespace PMF

universe u v w

variable {I : Type u} {A : I → Type v} [Fintype I] [∀ i, Fintype (A i)]

/-- The normalized product of a finite dependent family of finite-alphabet laws. -/
noncomputable def finiteProduct (p : ∀ i, PMF (A i)) : PMF ((i : I) → A i) := by
  classical
  exact PMF.ofFintype (fun x => ∏ i, p i (x i)) (by
    rw [← Fintype.prod_sum]
    apply Finset.prod_eq_one
    intro i _
    exact (tsum_fintype (fun a => p i a)).symm.trans (p i).tsum_coe)

/-- A finite product atom is the product of its component atom masses. -/
theorem finiteProduct_apply (p : ∀ i, PMF (A i)) (x : (i : I) → A i) :
    finiteProduct p x = ∏ i, p i (x i) := by
  classical
  rfl

/-- An outcome is supported exactly when every selected coordinate is supported. -/
theorem mem_support_finiteProduct_iff (p : ∀ i, PMF (A i)) (x : (i : I) → A i) :
    x ∈ (finiteProduct p).support ↔ ∀ i, x i ∈ (p i).support := by
  classical
  simp only [PMF.mem_support_iff, finiteProduct_apply, Finset.prod_ne_zero_iff,
    Finset.mem_univ, forall_const]

-- Minimal coordinate/complement splitting for marginal and pair projections.
private theorem finiteProduct_map_splitAt [DecidableEq I]
    (p : ∀ i, PMF (A i)) (i : I) :
    (finiteProduct p).map (Equiv.piSplitAt i A) =
      channelJoint (p i)
        (fun _ => finiteProduct (fun j : {j : I // j ≠ i} => p j)) := by
  classical
  let E := Equiv.piSplitAt i A
  apply PMF.ext
  intro z
  obtain ⟨x, rfl⟩ := E.surjective z
  rw [PMF.map_apply_equiv, finiteProduct_apply]
  change (∏ j, p j (x j)) =
    channelJoint (p i)
      (fun _ => finiteProduct (fun j : {j : I // j ≠ i} => p j))
      (x i, fun j => x j)
  rw [channelJoint_apply, finiteProduct_apply]
  exact Fintype.prod_eq_mul_prod_subtype_ne (fun j => p j (x j)) i

/-- Evaluating a product law at one coordinate recovers its component law. -/
theorem finiteProduct_map_eval (p : ∀ i, PMF (A i)) (i : I) :
    (finiteProduct p).map (fun x => x i) = p i := by
  classical
  have h := congrArg (fun q => q.map Prod.fst) (finiteProduct_map_splitAt p i)
  rw [PMF.map_comp, channelJoint_map_fst] at h
  exact h

/-- The product on an empty index type is pure at the unique empty function. -/
theorem finiteProduct_of_isEmpty [IsEmpty I] (p : ∀ i, PMF (A i)) :
    finiteProduct p = PMF.pure (fun i => isEmptyElim i) := by
  classical
  apply PMF.ext
  intro x
  simp [finiteProduct_apply, PMF.pure_apply,
    Subsingleton.elim x (fun i => isEmptyElim i)]

/-- Products of deterministic component laws are deterministic at their tuple. -/
theorem finiteProduct_pure (a : (i : I) → A i) :
    finiteProduct (fun i => PMF.pure (a i)) = PMF.pure a := by
  rw [eq_pure_iff_support_eq_singleton, ← PMF.apply_eq_one_iff]
  simp only [finiteProduct_apply, PMF.pure_apply_self, Finset.prod_const_one]

/-! ## Coordinate restriction and reindexing -/

-- Predicate and range decompositions are proof infrastructure, not additional
-- public representations of finite products.
private theorem finiteProduct_map_splitPredicate
    (p : ∀ i, PMF (A i)) (P : I → Prop) [DecidablePred P] :
    (finiteProduct p).map (Equiv.piEquivPiSubtypeProd P A) =
      channelJoint (finiteProduct (fun i : {i : I // P i} => p i))
        (fun _ => finiteProduct (fun i : {i : I // ¬P i} => p i)) := by
  classical
  let E := Equiv.piEquivPiSubtypeProd P A
  apply PMF.ext
  intro z
  obtain ⟨x, rfl⟩ := E.surjective z
  rw [PMF.map_apply_equiv, finiteProduct_apply]
  change (∏ i, p i (x i)) =
    channelJoint (finiteProduct (fun i : {i : I // P i} => p i))
      (fun _ => finiteProduct (fun i : {i : I // ¬P i} => p i))
      (fun i => x i, fun i => x i)
  rw [channelJoint_apply, finiteProduct_apply, finiteProduct_apply]
  exact (Fintype.prod_subtype_mul_prod_subtype P (fun i => p i (x i))).symm

private theorem finiteProduct_map_subtype
    (p : ∀ i, PMF (A i)) (P : I → Prop) [DecidablePred P] :
    (finiteProduct p).map (fun x (i : {i : I // P i}) => x i) =
      finiteProduct (fun i : {i : I // P i} => p i) := by
  classical
  have h := congrArg (fun q => q.map Prod.fst) (finiteProduct_map_splitPredicate p P)
  rw [PMF.map_comp, channelJoint_map_fst] at h
  exact h

/-- Reindexing a dependent product by an equivalence reindexes its component laws. -/
theorem finiteProduct_map_reindex
    {I : Type u} {J : Type w} {A : I → Type v}
    [Fintype I] [Fintype J] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (e : J ≃ I) :
    (finiteProduct p).map (Equiv.piCongrLeft A e).symm =
      finiteProduct (fun j => p (e j)) := by
  classical
  let E := (Equiv.piCongrLeft A e).symm
  apply PMF.ext
  intro z
  obtain ⟨x, rfl⟩ := E.surjective z
  rw [PMF.map_apply_equiv, finiteProduct_apply, finiteProduct_apply]
  exact (e.prod_comp (fun i => p i (x i))).symm

/--
Selecting coordinates along an embedding gives the product of the selected laws.
Injectivity excludes repeated coordinates, whose law need not be a product.
-/
theorem finiteProduct_map_restrict
    {I : Type u} {J : Type w} {A : I → Type v}
    [Fintype I] [Fintype J] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (e : J ↪ I) :
    (finiteProduct p).map (fun x j => x (e j)) =
      finiteProduct (fun j => p (e j)) := by
  classical
  let : Fintype (Set.range e) := Subtype.fintype (fun i => i ∈ Set.range e)
  let er := Equiv.ofInjective e e.injective
  have h := congrArg
    (fun q : PMF ((i : Set.range e) → A i) =>
      q.map (Equiv.piCongrLeft (fun i : Set.range e => A i) er).symm)
    (finiteProduct_map_subtype p (fun i => i ∈ Set.range e))
  rw [PMF.map_comp, finiteProduct_map_reindex] at h
  exact h

/-! ## Ordered blocks and coordinate pairs -/

/--
A product indexed by a sum splits into its left and right block laws, in that
order. The right block is sampled through a constant channel.
-/
theorem finiteProduct_map_sum
    {I : Type u} {J : Type w} {A : I ⊕ J → Type v}
    [Fintype I] [Fintype J] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) :
    (finiteProduct p).map (Equiv.sumPiEquivProdPi A) =
      channelJoint (finiteProduct (fun i => p (Sum.inl i)))
        (fun _ => finiteProduct (fun j => p (Sum.inr j))) := by
  classical
  let E := Equiv.sumPiEquivProdPi A
  apply PMF.ext
  intro z
  obtain ⟨x, rfl⟩ := E.surjective z
  rw [PMF.map_apply_equiv, finiteProduct_apply]
  change (∏ i, p i (x i)) =
    channelJoint (finiteProduct (fun i => p (Sum.inl i)))
      (fun _ => finiteProduct (fun j => p (Sum.inr j)))
      (fun i => x (Sum.inl i), fun j => x (Sum.inr j))
  rw [channelJoint_apply, finiteProduct_apply, finiteProduct_apply]
  exact Fintype.prod_sum_type (fun i => p i (x i))

/--
The ordered pair of distinct coordinates has the constant-channel joint law of
the corresponding component PMFs. The distinctness assumption is essential.
-/
theorem finiteProduct_map_pair
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) {i j : I} (hij : i ≠ j) :
    (finiteProduct p).map (fun x => (x i, x j)) =
      channelJoint (p i) (fun _ => p j) := by
  classical
  let j' : {k : I // k ≠ i} := ⟨j, hij.symm⟩
  have h := congrArg
    (fun q : PMF (A i × ((k : {k : I // k ≠ i}) → A k)) =>
      q.map (fun z => (z.1, z.2 j')))
    (finiteProduct_map_splitAt p i)
  rw [PMF.map_comp] at h
  calc
    (finiteProduct p).map (fun x => (x i, x j)) =
        (channelJoint (p i)
          (fun _ => finiteProduct (fun k : {k : I // k ≠ i} => p k))).map
            (fun z => (z.1, z.2 j')) := h
    _ = channelJoint (p i) (fun _ => p j) := by
      unfold channelJoint
      rw [PMF.map_bind]
      apply congrArg (PMF.bind (p i))
      funext a
      rw [PMF.map_comp]
      have hm := congrArg
        (fun q : PMF (A j') => q.map (fun b => (a, b)))
        (finiteProduct_map_eval (fun k : {k : I // k ≠ i} => p k) j')
      rw [PMF.map_comp] at hm
      exact hm

end PMF
