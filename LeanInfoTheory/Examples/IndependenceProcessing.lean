/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.Independence

/-!
# Deterministic processing of independent random variables

These private consumers use arbitrary product PMFs and right processing, with
non-injective and constant maps, infinite types, left processing by symmetry,
and finite zero mutual information. Only the focused independence owner is
imported. The examples remain outside the stable mathematical API.
-/

namespace LeanInfoTheory
namespace Examples
namespace IndependenceProcessing

open Shannon

noncomputable section

universe u v w x

variable {alpha : Type u} {beta : Type v} {gamma : Type w}

/-- The two coordinates of an arbitrary independent product are independent. -/
private theorem product_coordinates (p : PMF alpha) (q : PMF beta) :
    IsIndependentOf (indepProd p q) Prod.fst Prod.snd := by
  unfold IsIndependentOf
  have hpair : (fun z : alpha × beta => (z.1, z.2)) = id := by
    funext z
    cases z
    rfl
  rw [hpair, PMF.map_id]
  exact isIndependent_indepProd p q

/-- An arbitrary map of the second component preserves product independence. -/
private theorem product_right (p : PMF alpha) (q : PMF beta) (f : beta → gamma) :
    IsIndependentOf (indepProd p q) Prod.fst (fun z => f z.2) :=
  isIndependentOf_comp_right (indepProd p q) Prod.fst Prod.snd f
    (product_coordinates p q)

/-- Halving is non-injective (0 and 1 collide), nonconstant, and has infinite codomain. -/
private theorem nat_halving (p q : PMF Nat) :
    IsIndependentOf (indepProd p q) Prod.fst (fun z => z.2 / 2) :=
  product_right p q (fun n => n / 2)

/-- A constant image with singleton target needs no injectivity assumption. -/
private theorem constant_image (p : PMF alpha) (q : PMF beta) :
    IsIndependentOf (indepProd p q) Prod.fst (fun _ : alpha × beta => ()) :=
  product_right p q (fun _ : beta => ())

/-- Existing symmetry gives left processing without another public wrapper. -/
private theorem left_processing
    {omega : Type x} (p : PMF omega) (X : omega → alpha) (Y : omega → beta)
    (f : alpha → gamma) (hXY : IsIndependentOf p X Y) :
    IsIndependentOf p (fun z => f (X z)) Y := by
  apply (isIndependentOf_swap p (fun z => f (X z)) Y).1
  exact isIndependentOf_comp_right p Y X f
    ((isIndependentOf_swap p X Y).2 hXY)

/-- Only the two observed alphabets need to be finite for the zero-MI consequence. -/
private theorem finite_zero_mi
    [Fintype alpha] [Fintype gamma]
    (p : PMF alpha) (q : PMF beta) (f : beta → gamma) :
    mutualInfoOf (indepProd p q) Prod.fst (fun z => f z.2) = 0 :=
  (mutualInfoOf_eq_zero_iff_isIndependentOf
    (indepProd p q) Prod.fst (fun z => f z.2)).2
      (product_right p q f)

end

end IndependenceProcessing
end Examples
end LeanInfoTheory
