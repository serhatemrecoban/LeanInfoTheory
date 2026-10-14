/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.FiniteProduct
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
-/

namespace LeanInfoTheory.Shannon

universe u v

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

end LeanInfoTheory.Shannon
