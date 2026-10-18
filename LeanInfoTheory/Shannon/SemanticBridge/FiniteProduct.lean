/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.FiniteProduct
import LeanInfoTheory.Probability.Iid
import LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence

/-!
# Finite products in the family and independence APIs

The existing `familyMarginal` of a finite dependent product is the product of
the selected component laws. Consequently the constructed family satisfies
`IsMutuallyIndependentFamily` on every finite atom, including empty atoms and
atoms with zero-mass outcomes.

Distinct coordinate evaluations satisfy the existing `IsIndependentOf`
predicate. The ordered pair law comes from `PMF.finiteProduct_map_pair`; its
constant-channel joint law is definitionally the existing `indepProd`.
These bridges retain the established family and independence semantics.

Finite-product entropy is the sum of the component entropies, by the existing
family independence characterization. The iid specialization is blocklength
times the base entropy. Empty indices, singleton alphabets and zero masses
require no additional assumptions.

Mutually independent coordinate pairs have additive mutual information after
the tuple of pairs is split into its two words. The pairs may each have positive
mutual information; no channel representation is required.
-/

open scoped BigOperators

namespace LeanInfoTheory.Shannon

universe u v w

/-- A selected marginal of a finite product is the product of its selected laws. -/
theorem familyMarginal_finiteProduct
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (s : Finset I) :
    familyMarginal (PMF.finiteProduct p) s =
      PMF.finiteProduct (fun i : s => p i.1) :=
  PMF.finiteProduct_map_restrict p (Function.Embedding.subtype (fun i => i ∈ s))

/-- The coordinates of a finite product are mutually independent on every atom. -/
theorem isMutuallyIndependentFamily_finiteProduct
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (s : Finset I) :
    IsMutuallyIndependentFamily (PMF.finiteProduct p) s := by
  intro x
  rw [familyMarginal_finiteProduct, PMF.finiteProduct_apply]
  simp only [PMF.finiteProduct_map_eval]

/-- Evaluations at distinct coordinates of a finite product are independent. -/
theorem isIndependentOf_finiteProduct_eval
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) {i j : I} (hij : i ≠ j) :
    IsIndependentOf (PMF.finiteProduct p) (fun x => x i) (fun x => x j) := by
  rw [isIndependentOf_iff_map_eq_indepProd,
    PMF.finiteProduct_map_eval, PMF.finiteProduct_map_eval]
  exact PMF.finiteProduct_map_pair p hij

open Classical in
/-- Entropy adds over a finite dependent product, including sparse and empty
families. This reuses full mutual independence in the existing family API. -/
theorem entropy_finiteProduct
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) :
    entropy (PMF.finiteProduct p) = ∑ i, entropy (p i) := by
  classical
  have hfull :
      familyEntropy (PMF.finiteProduct p) Finset.univ =
        entropy (PMF.finiteProduct p) := by
    change entropy
      ((PMF.finiteProduct p).map ((Finset.univ : Finset I).restrict (π := A))) = _
    apply entropy_map_injective
    intro x y h
    funext i
    exact congrFun h ⟨i, Finset.mem_univ i⟩
  have h :=
    (familyEntropy_eq_sum_singletons_iff_isMutuallyIndependentFamily
      (PMF.finiteProduct p) Finset.univ).2
      (isMutuallyIndependentFamily_finiteProduct p Finset.univ)
  rw [hfull] at h
  simpa only [familyEntropy_singleton, entropyOf,
    PMF.finiteProduct_map_eval] using h

/-- The entropy of an iid block is its length times the base entropy, in nats.
The base PMF is still supplied at length zero. -/
theorem entropy_iid
    {A : Type v} [Fintype A] (p : PMF A) (n : ℕ) :
    entropy (PMF.iid p n) = (n : ℝ) * entropy p := by
  have h := entropy_finiteProduct (fun _ : Fin n => p)
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul] at h
  convert! h

private theorem eq_finiteProduct_of_mutuallyIndependent_univ
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (r : PMF ((i : I) → A i))
    (hr : IsMutuallyIndependentFamily r Finset.univ) :
    r = PMF.finiteProduct (fun i => r.map (fun z => z i)) := by
  classical
  have hinj : Function.Injective ((Finset.univ : Finset I).restrict (π := A)) := by
    intro x y h
    funext i
    exact congrFun h ⟨i, Finset.mem_univ i⟩
  apply PMF.ext
  intro x
  rw [PMF.finiteProduct_apply]
  have h := hr ((Finset.univ : Finset I).restrict x)
  rw [familyMarginal, PMF.map_apply_of_injective r hinj x] at h
  change r x = ∏ i : (Finset.univ : Finset I), (r.map (fun z => z i.1)) (x i.1) at h
  exact h.trans (Finset.prod_coe_sort
    (f := fun i => (r.map (fun z => z i)) (x i)) (s := Finset.univ))

private theorem fstMarginal_finiteProduct_map_piProd
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (p : ∀ i, PMF (A i × B i)) :
    fstMarginal ((PMF.finiteProduct p).map (Equiv.arrowProdEquivProdArrow I A B)) =
      PMF.finiteProduct (fun i => fstMarginal (p i)) := by
  classical
  apply PMF.ext
  intro x
  rw [fstMarginal_apply, PMF.finiteProduct_apply]
  calc
    (∑ y : ((i : I) → B i),
        ((PMF.finiteProduct p).map (Equiv.arrowProdEquivProdArrow I A B)) (x, y)) =
        ∑ y : ((i : I) → B i), ∏ i, p i (x i, y i) := by
      apply Finset.sum_congr rfl
      intro y _
      exact (PMF.map_apply_equiv (PMF.finiteProduct p)
        (Equiv.arrowProdEquivProdArrow I A B) (fun i => (x i, y i))).trans
        (PMF.finiteProduct_apply p (fun i => (x i, y i)))
    _ = ∏ i, ∑ b, p i (x i, b) := (Fintype.prod_sum (fun i b => p i (x i, b))).symm
    _ = ∏ i, fstMarginal (p i) (x i) := by simp only [fstMarginal_apply]

private theorem sndMarginal_finiteProduct_map_piProd
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (p : ∀ i, PMF (A i × B i)) :
    sndMarginal ((PMF.finiteProduct p).map (Equiv.arrowProdEquivProdArrow I A B)) =
      PMF.finiteProduct (fun i => sndMarginal (p i)) := by
  classical
  apply PMF.ext
  intro y
  rw [sndMarginal_apply, PMF.finiteProduct_apply]
  calc
    (∑ x : ((i : I) → A i),
        ((PMF.finiteProduct p).map (Equiv.arrowProdEquivProdArrow I A B)) (x, y)) =
        ∑ x : ((i : I) → A i), ∏ i, p i (x i, y i) := by
      apply Finset.sum_congr rfl
      intro x _
      exact (PMF.map_apply_equiv (PMF.finiteProduct p)
        (Equiv.arrowProdEquivProdArrow I A B) (fun i => (x i, y i))).trans
        (PMF.finiteProduct_apply p (fun i => (x i, y i)))
    _ = ∏ i, ∑ a, p i (a, y i) := (Fintype.prod_sum (fun i a => p i (a, y i))).symm
    _ = ∏ i, sndMarginal (p i) (y i) := by simp only [sndMarginal_apply]

open Classical in
private theorem mutualInfo_finiteProduct_map_piProd
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (p : ∀ i, PMF (A i × B i)) :
    mutualInfo ((PMF.finiteProduct p).map (Equiv.arrowProdEquivProdArrow I A B)) =
      ∑ i, mutualInfo (p i) := by
  classical
  rw [mutualInfo_eq, fstMarginal_finiteProduct_map_piProd p,
    sndMarginal_finiteProduct_map_piProd p,
    entropy_map_equiv (PMF.finiteProduct p) (Equiv.arrowProdEquivProdArrow I A B),
    entropy_finiteProduct (fun i => fstMarginal (p i)),
    entropy_finiteProduct (fun i => sndMarginal (p i)), entropy_finiteProduct p]
  simp only [mutualInfo_eq, Finset.sum_sub_distrib, Finset.sum_add_distrib]

open Classical in
/-- Splitting mutually independent coordinate pairs into two words makes their
mutual information additive. Independence is required between the pairs, not
within each pair, and no channel representation is assumed. -/
theorem mutualInfo_map_piProd_eq_sum_of_isMutuallyIndependentFamily
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (r : PMF ((i : I) → A i × B i))
    (hr : IsMutuallyIndependentFamily r Finset.univ) :
    mutualInfo (r.map (Equiv.arrowProdEquivProdArrow I A B)) =
      ∑ i, mutualInfo (r.map (fun z => z i)) := by
  classical
  have h := mutualInfo_finiteProduct_map_piProd (fun i => r.map (fun z => z i))
  rw [← eq_finiteProduct_of_mutuallyIndependent_univ r hr] at h
  convert! h

end LeanInfoTheory.Shannon
