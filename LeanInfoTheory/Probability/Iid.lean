/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.FiniteProduct
import Mathlib.Logic.Equiv.Fin.Basic

/-!
# Finite blocks and iid laws

`PMF.iid` is the finite product of a constant family of component laws. Its atom,
support and coordinate formulas are inherited from `PMF.finiteProduct`, and its
law is invariant under coordinate permutations.

This owner also provides splitting and concatenation for general finite blocks
with different component laws. The upstream `Fin.appendEquiv` fixes the ordered
prefix/suffix convention. Both transports include empty blocks, without a
positive-length assumption or a separate block representation.

An iid law still requires a base PMF at length zero. The general finite product
constructs the empty word over an empty alphabet without requiring such a PMF.
This probability owner has no project Shannon or information-measure dependency.
-/

namespace PMF

universe v

/-- The law of a finite block of independent coordinates with the same law. -/
noncomputable def iid {A : Type v} [Fintype A] (p : PMF A) (n : ℕ) :
    PMF (Fin n → A) := finiteProduct (fun _ : Fin n => p)

/-- Split a finite product into its ordered prefix and suffix product laws. -/
theorem finiteProduct_map_append_symm
    {A : Type v} [Fintype A] (m n : ℕ) (p : Fin (m + n) → PMF A) :
    (finiteProduct p).map (Fin.appendEquiv m n).symm =
      channelJoint
        (finiteProduct (fun i => p (Fin.castAdd n i)))
        (fun _ => finiteProduct (fun j => p (Fin.natAdd m j))) := by
  have h := congrArg
    (fun q : PMF (Fin m ⊕ Fin n → A) =>
      q.map (Equiv.sumPiEquivProdPi (fun _ : Fin m ⊕ Fin n => A)))
    (finiteProduct_map_reindex p
      (finSumFinEquiv : Fin m ⊕ Fin n ≃ Fin (m + n)))
  rw [PMF.map_comp, finiteProduct_map_sum] at h
  exact h

/-- Concatenate independent product blocks, allowing different coordinate laws. -/
theorem channelJoint_finiteProduct_map_append
    {A : Type v} [Fintype A] {m n : ℕ}
    (p : Fin m → PMF A) (q : Fin n → PMF A) :
    (channelJoint (finiteProduct p) (fun _ => finiteProduct q)).map
        (Fin.appendEquiv m n) = finiteProduct (Fin.append p q) := by
  have h := congrArg
    (fun r : PMF ((Fin m → A) × (Fin n → A)) => r.map (Fin.appendEquiv m n))
    (finiteProduct_map_append_symm m n (Fin.append p q))
  simpa only [PMF.map_comp, Equiv.self_comp_symm, PMF.map_id,
    Fin.append_left, Fin.append_right] using h.symm

/-- Permuting the coordinates of an iid block preserves its law. -/
theorem iid_map_perm {A : Type v} [Fintype A]
    (p : PMF A) (n : ℕ) (e : Equiv.Perm (Fin n)) :
    (iid p n).map (fun x i => x (e i)) = iid p n :=
  finiteProduct_map_reindex (fun _ : Fin n => p) e

end PMF
