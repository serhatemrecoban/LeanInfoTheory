/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.InfoMeasures

/-!
# Mutual information through an auxiliary variable

These private consumers exercise the exact information decomposition, its
generic two-zero specialization, a singleton auxiliary variable, and a sparse
finite joint law. Only the lightweight information-measure owner is imported.
The ordered conditioning pair is always `(X,Z)`; no semantic hypotheses or
application-specific predicates enter the examples.
-/

namespace LeanInfoTheory
namespace Examples
namespace InformationDecomposition

open Shannon

noncomputable section

universe u v w x

/-- The general interface allows an arbitrary source and three finite observed alphabets. -/
private theorem general_decomposition
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta) (Z : omega → gamma) :
    mutualInfoOf p Y Z =
      condEntropyOf p Y X - condMutualInfoOf p X Z Y -
        condEntropyOf p Y (fun omega => (X omega, Z omega)) +
        mutualInfoOf p X Z :=
  mutualInfoOf_condEntropyOf_decomposition p X Y Z

/-- Two algebraic zero hypotheses give a generic specialization of the identity. -/
private theorem zero_terms
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega → alpha) (Y : omega → beta) (Z : omega → gamma)
    (hMI : mutualInfoOf p X Z = 0)
    (hCond : condEntropyOf p Y (fun omega => (X omega, Z omega)) = 0) :
    mutualInfoOf p Y Z = condEntropyOf p Y X - condMutualInfoOf p X Z Y := by
  simpa only [hMI, hCond, sub_zero, add_zero] using
    mutualInfoOf_condEntropyOf_decomposition p X Y Z

/-- A singleton auxiliary alphabet retains the explicit conditioning order `((), Z)`. -/
private theorem singleton_auxiliary
    {omega : Type u} {beta : Type v} {gamma : Type w}
    [Fintype beta] [Fintype gamma]
    (p : PMF omega) (Y : omega → beta) (Z : omega → gamma) :
    mutualInfoOf p Y Z =
      condEntropyOf p Y (fun _ => ()) - condMutualInfoOf p (fun _ => ()) Z Y -
        condEntropyOf p Y (fun omega => ((), Z omega)) +
        mutualInfoOf p (fun _ => ()) Z :=
  mutualInfoOf_condEntropyOf_decomposition p (fun _ => ()) Y Z

/-- A Boolean triple law with two half-mass atoms and six zero-mass atoms. -/
private def sparseJoint : PMF (Bool × Bool × Bool) :=
  PMF.ofFinset
    (fun s =>
      if s = (false, false, true) ∨ s = (true, true, false)
      then (1 : ENNReal) / 2 else 0)
    {(false, false, true), (true, true, false)}
    (by
      norm_num
      exact ENNReal.inv_two_add_inv_two)
    (by intro s hs; simp_all)

/-- Both supported atoms have mass one half, while an off-support atom has mass zero. -/
private theorem sparse_masses :
    sparseJoint (false, false, true) = (1 : ENNReal) / 2 ∧
    sparseJoint (true, true, false) = (1 : ENNReal) / 2 ∧
    sparseJoint (false, true, true) = 0 := by
  norm_num [sparseJoint, PMF.ofFinset_apply]

/-- Sparse joint laws require no positivity assumption, with pair `(fst, snd.snd)`. -/
private theorem sparse_decomposition :
    mutualInfoOf sparseJoint (fun s => s.2.1) (fun s => s.2.2) =
      condEntropyOf sparseJoint (fun s => s.2.1) (fun s => s.1) -
        condMutualInfoOf sparseJoint (fun s => s.1) (fun s => s.2.2) (fun s => s.2.1) -
        condEntropyOf sparseJoint (fun s => s.2.1) (fun s => (s.1, s.2.2)) +
        mutualInfoOf sparseJoint (fun s => s.1) (fun s => s.2.2) :=
  mutualInfoOf_condEntropyOf_decomposition sparseJoint
    (fun s => s.1) (fun s => s.2.1) (fun s => s.2.2)

end

end InformationDecomposition
end Examples
end LeanInfoTheory
