/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.Finite
import Mathlib.Analysis.SpecialFunctions.Log.NegMulLog
import Mathlib.Probability.ProbabilityMassFunction.Constructions

/-!
# Finite Shannon entropy

Entropy is measured in nats. For a finite `PMF`, the definition is the
finite sum of mathlib's `Real.negMulLog` over the real masses of the atoms.
This follows the same mathematical convention as Rocq `infotheo`: entropy is
first a function of a finite distribution, and random-variable entropy is then
defined by pushing a distribution forward along the random variable.
-/

namespace LeanInfoTheory
namespace Shannon

open scoped BigOperators

universe u v w

noncomputable section

/-- Shannon entropy, in nats, of a finite probability mass function. -/
def entropy {alpha : Type u} [Fintype alpha] (p : PMF alpha) : Real :=
  ∑ a, Real.negMulLog (p a).toReal

/-- The defining finite-sum formula for Shannon entropy. -/
theorem entropy_eq_sum {alpha : Type u} [Fintype alpha] (p : PMF alpha) :
    entropy p = ∑ a, Real.negMulLog (p a).toReal :=
  rfl

/-- Shannon entropy is nonnegative for finite PMFs. -/
theorem entropy_nonneg {alpha : Type u} [Fintype alpha] (p : PMF alpha) :
    0 <= entropy p := by
  classical
  rw [entropy_eq_sum]
  -- Each summand is nonnegative because every real PMF mass lies in `[0, 1]`.
  exact Finset.sum_nonneg fun a _ha =>
    Real.negMulLog_nonneg
      (PMF.toReal_nonneg p a)
      (PMF.toReal_le_one p a)

private theorem map_apply_equiv {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (e : alpha ≃ beta) (a : alpha) :
    p.map e (e a) = p a := by
  have hpre : e ⁻¹' ({e a} : Set beta) = ({a} : Set alpha) := by
    ext x
    constructor
    · intro hx
      exact e.injective hx
    · intro hx
      rw [hx]
      rfl
  calc
    p.map e (e a) =
        (p.map e).toOuterMeasure ({e a} : Set beta) := by
      exact (PMF.toOuterMeasure_apply_singleton (p := p.map e) (e a)).symm
    _ = p.toOuterMeasure (e ⁻¹' ({e a} : Set beta)) := by
      rw [PMF.toOuterMeasure_map_apply]
    _ = p.toOuterMeasure ({a} : Set alpha) := by
      rw [hpre]
    _ = p a := by
      exact PMF.toOuterMeasure_apply_singleton (p := p) a

private theorem map_apply_of_injective {alpha : Type u} {beta : Type v}
    (p : PMF alpha) {f : alpha -> beta} (hf : Function.Injective f) (a : alpha) :
    p.map f (f a) = p a := by
  have hpre : f ⁻¹' ({f a} : Set beta) = ({a} : Set alpha) := by
    ext x
    constructor
    · intro hx
      exact hf (by simpa using hx)
    · intro hx
      rw [hx]
      rfl
  calc
    p.map f (f a) =
        (p.map f).toOuterMeasure ({f a} : Set beta) := by
      exact (PMF.toOuterMeasure_apply_singleton (p := p.map f) (f a)).symm
    _ = p.toOuterMeasure (f ⁻¹' ({f a} : Set beta)) := by
      rw [PMF.toOuterMeasure_map_apply]
    _ = p.toOuterMeasure ({a} : Set alpha) := by
      rw [hpre]
    _ = p a := by
      exact PMF.toOuterMeasure_apply_singleton (p := p) a

private theorem map_apply_eq_zero_of_notMem_range {alpha : Type u} {beta : Type v}
    (p : PMF alpha) {f : alpha -> beta} {b : beta} (hb : b ∉ Set.range f) :
    p.map f b = 0 := by
  have hpre : f ⁻¹' ({b} : Set beta) = (∅ : Set alpha) := by
    ext x
    constructor
    · intro hx
      exfalso
      exact hb ⟨x, by simpa using hx⟩
    · intro hx
      cases hx
  calc
    p.map f b =
        (p.map f).toOuterMeasure ({b} : Set beta) := by
      exact (PMF.toOuterMeasure_apply_singleton (p := p.map f) b).symm
    _ = p.toOuterMeasure (f ⁻¹' ({b} : Set beta)) := by
      rw [PMF.toOuterMeasure_map_apply]
    _ = p.toOuterMeasure (∅ : Set alpha) := by
      rw [hpre]
    _ = 0 := by
      simp

/--
Entropy is invariant under relabeling the alphabet by an equivalence.

This is one of the basic sanity checks for finite entropy: only the masses
matter, not the names of the atoms.
-/
theorem entropy_map_equiv {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta] (p : PMF alpha) (e : alpha ≃ beta) :
    entropy (p.map e) = entropy p := by
  classical
  rw [entropy_eq_sum, entropy_eq_sum]
  exact
    (Fintype.sum_equiv e
      (fun a : alpha => Real.negMulLog (p a).toReal)
      (fun b : beta => Real.negMulLog (p.map e b).toReal)
      (fun a => by simp [map_apply_equiv p e a])).symm

/--
Entropy is invariant under injective relabeling into a larger finite alphabet.
Atoms outside the image of the relabeling have zero pushed-forward mass.
-/
theorem entropy_map_injective {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta]
    (p : PMF alpha) {f : alpha -> beta} (hf : Function.Injective f) :
    entropy (p.map f) = entropy p := by
  classical
  rw [entropy_eq_sum, entropy_eq_sum]
  let g : beta -> Real := fun b => Real.negMulLog (p.map f b).toReal
  calc
    (∑ b, Real.negMulLog (p.map f b).toReal) = (Finset.univ.image f).sum g := by
      symm
      apply Finset.sum_subset
      · intro b hb
        simp
      · intro b _hbuniv hbimage
        have hbrange : b ∉ Set.range f := by
          intro hbrange
          rcases hbrange with ⟨a, rfl⟩
          exact hbimage (by simp)
        simp [map_apply_eq_zero_of_notMem_range p hbrange]
    _ = ∑ a, g (f a) := by
      rw [Finset.sum_image]
      intro a _ha a' _ha' h
      exact hf h
    _ = ∑ a, Real.negMulLog (p a).toReal := by
      change
        (∑ a, Real.negMulLog (p.map f (f a)).toReal) =
          ∑ a, Real.negMulLog (p a).toReal
      apply Finset.sum_congr rfl
      intro a _ha
      rw [map_apply_of_injective p hf a]

/-- A deterministic finite PMF has entropy zero. -/
@[simp]
theorem entropy_pure {alpha : Type u} [Fintype alpha] (a : alpha) :
    entropy (PMF.pure a) = 0 := by
  classical
  rw [entropy_eq_sum]
  apply Finset.sum_eq_zero
  intro x _hx
  -- The selected atom has mass one and every other atom has mass zero.
  by_cases hx : x = a
  · simp [PMF.pure_apply, hx]
  · simp [PMF.pure_apply, hx]

/-- Entropy of a finite-valued random variable under a discrete law. -/
def entropyOf {omega : Type u} {alpha : Type v} [Fintype alpha]
    (p : PMF omega) (X : omega -> alpha) : Real :=
  entropy (p.map X)

@[simp]
theorem entropyOf_id {alpha : Type u} [Fintype alpha] (p : PMF alpha) :
    entropyOf p id = entropy p := by
  simp [entropyOf, PMF.map_id]

/-- Relabeling a finite-valued random variable by an equivalence preserves its entropy. -/
theorem entropyOf_comp_equiv
    {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta]
    (p : PMF omega) (X : omega -> alpha) (e : alpha ≃ beta) :
    entropyOf p (fun omega => e (X omega)) = entropyOf p X := by
  simpa [entropyOf, Function.comp_def, PMF.map_comp] using entropy_map_equiv (p := p.map X) e

/-- Applying an injective relabeling to a finite-valued random variable preserves its entropy. -/
theorem entropyOf_comp_injective
    {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta]
    (p : PMF omega) (X : omega -> alpha) {f : alpha -> beta}
    (hf : Function.Injective f) :
    entropyOf p (fun omega => f (X omega)) = entropyOf p X := by
  simpa [entropyOf, Function.comp_def, PMF.map_comp] using
    entropy_map_injective (p := p.map X) hf

/-- Joint entropy is entropy of a joint finite distribution. -/
abbrev jointEntropy {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta] (p : PMF (alpha × beta)) : Real :=
  entropy p

/-- Swapping the two coordinates of a joint law preserves entropy. -/
theorem entropy_map_swap {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta] (p : PMF (alpha × beta)) :
    entropy (p.map Prod.swap) = entropy p := by
  simpa using entropy_map_equiv (p := p) (Equiv.prodComm alpha beta)

/-- Swapping the two coordinates of a joint law preserves joint entropy. -/
theorem jointEntropy_map_swap {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta] (p : PMF (alpha × beta)) :
    jointEntropy (p.map Prod.swap) = jointEntropy p :=
  entropy_map_swap p

/-- Joint entropy of two finite-valued random variables under a discrete law. -/
def jointEntropyOf {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta]
    (p : PMF omega) (X : omega -> alpha) (Y : omega -> beta) : Real :=
  entropyOf p fun omega => (X omega, Y omega)

/-- Joint entropy of two random variables is invariant under swapping their order. -/
theorem jointEntropyOf_swap
    {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta]
    (p : PMF omega) (X : omega -> alpha) (Y : omega -> beta) :
    jointEntropyOf p Y X = jointEntropyOf p X Y := by
  simpa [jointEntropyOf, entropyOf, Function.comp_def, PMF.map_comp] using
    entropy_map_equiv
      (p := p.map fun omega => (X omega, Y omega))
      (Equiv.prodComm alpha beta)

end

end Shannon
end LeanInfoTheory
