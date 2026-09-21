/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.TotalVariation
import LeanInfoTheory.Probability.FiniteChannel

/-!
# Finite total variation through maps and channels

These private consumers use the focused probability owners. They check a
nonconstant map that merges two atoms, constant collapse, identity and
equivalence relabeling, and a Boolean channel that retains its input with
probability three quarters. Distinct pure inputs have distance one and their
noisy outputs have distance exactly one half. The consumers use both the public
contraction interface and an explicit finite calculation, and compose channels
through the existing channel algebra. Both projections of an arbitrary joint
law also use the public deterministic contraction interface.
-/

namespace LeanInfoTheory.Examples.TotalVariationChannels

open scoped BigOperators ENNReal

private def mergeAtoms (a : Fin 3) : Bool := decide (a = 0)

private theorem mergeAtoms_noninjective_nonconstant :
    ¬Function.Injective mergeAtoms ∧ mergeAtoms 0 ≠ mergeAtoms 1 := by
  constructor
  · intro h
    have heq : (1 : Fin 3) = 2 := h (by decide)
    exact (by decide : (1 : Fin 3) ≠ 2) heq
  · decide

private theorem noninjective_map_contraction (p q : PMF (Fin 3)) :
    PMF.totalVariation (p.map mergeAtoms) (q.map mergeAtoms) ≤ PMF.totalVariation p q :=
  PMF.totalVariation_map_le p q mergeAtoms

private theorem merged_pure_distances :
    PMF.totalVariation (PMF.pure (1 : Fin 3)) (PMF.pure 2) = 1 ∧
    PMF.totalVariation ((PMF.pure (1 : Fin 3)).map mergeAtoms)
      ((PMF.pure 2).map mergeAtoms) = 0 := by
  constructor
  · norm_num [PMF.totalVariation, Fin.sum_univ_three, PMF.pure_apply,
      show (0 : Fin 3) ≠ 1 by decide, show (0 : Fin 3) ≠ 2 by decide,
      show (1 : Fin 3) ≠ 2 by decide, show (2 : Fin 3) ≠ 1 by decide]
  · rw [PMF.pure_map, PMF.pure_map]
    change PMF.totalVariation (PMF.pure false) (PMF.pure false) = 0
    exact PMF.totalVariation_self _

private theorem constant_map_collapse {α β : Type*} [Fintype β]
    (p q : PMF α) (b : β) :
    PMF.totalVariation (p.map (Function.const α b))
      (q.map (Function.const α b)) = 0 := by
  rw [PMF.map_const, PMF.map_const, PMF.totalVariation_self]

private theorem identity_map_distance {α : Type*} [Fintype α] (p q : PMF α) :
    PMF.totalVariation (p.map id) (q.map id) = PMF.totalVariation p q := by
  simpa only [Equiv.coe_refl] using PMF.totalVariation_map_equiv p q (Equiv.refl α)

private theorem equivalence_relabeling {α β : Type*} [Fintype α] [Fintype β]
    (p q : PMF α) (e : α ≃ β) :
    PMF.totalVariation (p.map e) (q.map e) = PMF.totalVariation p q :=
  PMF.totalVariation_map_equiv p q e

private def flipEquiv : Bool ≃ Bool where
  toFun := Bool.not
  invFun := Bool.not
  left_inv b := by cases b <;> rfl
  right_inv b := by cases b <;> rfl

private theorem boolean_flip_relabeling (p q : PMF Bool) :
    PMF.totalVariation (p.map Bool.not) (q.map Bool.not) = PMF.totalVariation p q :=
  PMF.totalVariation_map_equiv p q flipEquiv

private noncomputable def noisyChannel (a : Bool) : PMF Bool :=
  PMF.ofFintype (fun b => if b = a then (3 / 4 : ℝ≥0∞) else 1 / 4)
    (by
      cases a <;>
        (norm_num [Fintype.sum_bool, ← ENNReal.add_div, ← one_div]
         exact ENNReal.div_self (by norm_num) (by norm_num)))

private theorem noisyChannel_masses (a : Bool) :
    noisyChannel a a = (3 / 4 : ℝ≥0∞) ∧
      noisyChannel a (!a) = (1 / 4 : ℝ≥0∞) := by
  cases a <;> norm_num [noisyChannel, PMF.ofFintype_apply]

private theorem pure_input_distance :
    PMF.totalVariation (PMF.pure false) (PMF.pure true) = 1 := by
  norm_num [PMF.totalVariation, Fintype.sum_bool, PMF.pure_apply]

private theorem noisy_output_distance :
    PMF.totalVariation ((PMF.pure false).bind noisyChannel)
      ((PMF.pure true).bind noisyChannel) = 1 / 2 := by
  rw [PMF.pure_bind, PMF.pure_bind]
  norm_num [PMF.totalVariation, Fintype.sum_bool, noisyChannel, PMF.ofFintype_apply]

private theorem noisy_public_contraction :
    PMF.totalVariation ((PMF.pure false).bind noisyChannel)
      ((PMF.pure true).bind noisyChannel) ≤
        PMF.totalVariation (PMF.pure false) (PMF.pure true) :=
  PMF.totalVariation_bind_le (PMF.pure false) (PMF.pure true) noisyChannel

private theorem noisy_exact_strict_contraction :
    PMF.totalVariation (PMF.pure false) (PMF.pure true) = 1 ∧
    PMF.totalVariation ((PMF.pure false).bind noisyChannel)
      ((PMF.pure true).bind noisyChannel) = 1 / 2 ∧
    PMF.totalVariation ((PMF.pure false).bind noisyChannel)
      ((PMF.pure true).bind noisyChannel) <
        PMF.totalVariation (PMF.pure false) (PMF.pure true) := by
  refine ⟨pure_input_distance, noisy_output_distance, ?_⟩
  refine lt_of_le_of_ne noisy_public_contraction ?_
  rw [pure_input_distance, noisy_output_distance]
  norm_num

private theorem composition_contraction {α β γ : Type*}
    [Fintype α] [Fintype β] [Fintype γ]
    (p q : PMF α) (W : α → PMF β) (V : β → PMF γ) :
    PMF.totalVariation (p.bind (PMF.channelComp W V))
      (q.bind (PMF.channelComp W V)) ≤ PMF.totalVariation (p.bind W) (q.bind W) ∧
    PMF.totalVariation (p.bind (PMF.channelComp W V))
      (q.bind (PMF.channelComp W V)) ≤ PMF.totalVariation p q := by
  rw [PMF.bind_channelComp, PMF.bind_channelComp]
  have h := PMF.totalVariation_bind_le (p.bind W) (q.bind W) V
  exact ⟨h, h.trans (PMF.totalVariation_bind_le p q W)⟩

private theorem deterministic_postprocessing {α β γ : Type*}
    [Fintype α] [Finite β] [Fintype γ]
    (p q : PMF α) (W : α → PMF β) (f : β → γ) :
    PMF.totalVariation (p.bind (PMF.channelComp W (PMF.deterministicChannel f)))
      (q.bind (PMF.channelComp W (PMF.deterministicChannel f))) ≤
        PMF.totalVariation p q := by
  let : Fintype β := Fintype.ofFinite β
  rw [PMF.bind_channelComp, PMF.bind_channelComp,
    PMF.bind_deterministicChannel, PMF.bind_deterministicChannel]
  exact (PMF.totalVariation_map_le (p.bind W) (q.bind W) f).trans
    (PMF.totalVariation_bind_le p q W)

private theorem joint_projections_contract {α β : Type*} [Fintype α] [Fintype β]
    (p q : PMF (α × β)) :
    PMF.totalVariation (p.map Prod.fst) (q.map Prod.fst) ≤ PMF.totalVariation p q ∧
      PMF.totalVariation (p.map Prod.snd) (q.map Prod.snd) ≤ PMF.totalVariation p q :=
  ⟨PMF.totalVariation_map_le p q Prod.fst, PMF.totalVariation_map_le p q Prod.snd⟩

end LeanInfoTheory.Examples.TotalVariationChannels
