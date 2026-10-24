/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCapacity
import LeanInfoTheory.Shannon.SemanticBridge.Convexity
import Mathlib.Logic.Equiv.Fin.Rotate

/-!
# Finite-channel capacity interface consumers

These private consumers reuse one actual maximizing PMF through the public order
interface, test pure inputs with zero masses on a larger alphabet and singleton
capacities, and separate empty input domains from impossible empty output rows.
The focused import preserves independent input/output universes and needs no
extra output-inhabited assumption.
-/

namespace LeanInfoTheory.Examples.ChannelCapacity

open LeanInfoTheory.Shannon

universe u v w x

private theorem same_maximizing_input {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B] (W : A → PMF B) :
    ∃ p : PMF A, mutualInfo (PMF.channelJoint p W) = channelCapacity W ∧
      (∀ q : PMF A, mutualInfo (PMF.channelJoint q W) ≤
        mutualInfo (PMF.channelJoint p W)) ∧
      (∀ r : ℝ, mutualInfo (PMF.channelJoint p W) ≤ r ↔
        ∀ q : PMF A, mutualInfo (PMF.channelJoint q W) ≤ r) := by
  obtain ⟨p, hp⟩ := exists_mutualInfo_channelJoint_eq_channelCapacity W
  refine ⟨p, hp, ?_, ?_⟩
  · intro q
    rw [hp]
    exact mutualInfo_channelJoint_le_channelCapacity q W
  · intro r
    rw [hp]
    exact channelCapacity_le_iff W r

private theorem pure_ternary_zero_masses :
    (PMF.pure (0 : Fin 3)) 1 = 0 ∧ (PMF.pure (0 : Fin 3)) 2 = 0 := by
  simp [PMF.pure_apply]

private theorem pure_ternary_objective (W : Fin 3 → PMF Bool) :
    mutualInfo (PMF.channelJoint (PMF.pure 0) W) = 0 ∧
      mutualInfo (PMF.channelJoint (PMF.pure 0) W) ≤ channelCapacity W := by
  constructor
  · apply le_antisymm _ (mutualInfo_nonneg _)
    have h := mutualInfo_le_entropy_fstMarginal (PMF.channelJoint (PMF.pure 0) W)
    simpa only [fstMarginal, PMF.channelJoint_map_fst, entropy_pure] using h
  · exact mutualInfo_channelJoint_le_channelCapacity _ W

private theorem singleton_input_capacity {B : Type v} [Fintype B]
    (W : Unit → PMF B) : channelCapacity W = 0 := by
  apply le_antisymm _ (channelCapacity_nonneg W)
  simpa using channelCapacity_le_log_card_input W

private theorem singleton_output_capacity {A : Type u} [Fintype A] [Nonempty A]
    (W : A → PMF Unit) : channelCapacity W = 0 := by
  apply le_antisymm _ (channelCapacity_nonneg W)
  simpa using channelCapacity_le_log_card_output W

private theorem empty_input_channel_exists {A : Type u} {B : Type v}
    [IsEmpty A] : Nonempty (A → PMF B) :=
  ⟨fun a => isEmptyElim a⟩

private theorem no_empty_input_law {A : Type u} [IsEmpty A] : ¬ Nonempty (PMF A) := by
  rintro ⟨p⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

private theorem no_empty_input_maximizer {A : Type u} {B : Type v}
    [Fintype A] [IsEmpty A] [Fintype B] (W : A → PMF B) :
    ¬ ∃ p : PMF A, ∀ q : PMF A,
      mutualInfo (PMF.channelJoint q W) ≤ mutualInfo (PMF.channelJoint p W) := by
  rintro ⟨p, _⟩
  exact no_empty_input_law ⟨p⟩

private theorem no_empty_output_channel {A : Type u} {B : Type v}
    [Nonempty A] [IsEmpty B] : ¬ Nonempty (A → PMF B) := by
  rintro ⟨W⟩
  obtain ⟨a⟩ := ‹Nonempty A›
  obtain ⟨b, _⟩ := (W a).support_nonempty
  exact isEmptyElim b

/-! C22.02 consumers keep transport and optimizer reasoning private. -/

private theorem input_only_capacity {A : Type u} {B : Type v} {A' : Type w}
    [Fintype A] [Nonempty A] [Fintype B] [Fintype A']
    (W : A → PMF B) (e : A ≃ A') :
    let : Nonempty A' := ⟨e (Classical.choice (inferInstance : Nonempty A))⟩
    channelCapacity (fun a' => W (e.symm a')) = channelCapacity W := by
  let : Nonempty A' := ⟨e (Classical.choice (inferInstance : Nonempty A))⟩
  simpa [PMF.map_id] using channelCapacity_congr_equiv W e (Equiv.refl B)

private theorem output_only_capacity {A : Type u} {B : Type v} {B' : Type x}
    [Fintype A] [Nonempty A] [Fintype B] [Fintype B']
    (W : A → PMF B) (f : B ≃ B') :
    channelCapacity (fun a => (W a).map f) = channelCapacity W := by
  simpa using channelCapacity_congr_equiv W (Equiv.refl A) f

noncomputable section

private def ternaryLaw : PMF (Fin 3) :=
  PMF.binaryMixture (1 / 2) (by norm_num) (PMF.pure 0)
    (PMF.binaryMixture (1 / 3) (by change (1 / 3 : ℝ) ≤ 1; norm_num)
      (PMF.pure 1) (PMF.pure 2))

private def ternaryRows (a : Fin 3) : PMF Bool :=
  if a = 0 then PMF.pure false
  else if a = 1 then PMF.pure true else PMF.uniformOfFintype Bool

private abbrev threeCycle : Fin 3 ≃ Fin 3 := finRotate 3

private theorem cycle_values :
    threeCycle 0 = 1 ∧ threeCycle 1 = 2 ∧ threeCycle 2 = 0 := by
  decide

private theorem cycle_inverse_values :
    threeCycle.symm 0 = 2 ∧ threeCycle.symm 1 = 0 ∧ threeCycle.symm 2 = 1 := by
  decide

private theorem ternaryLaw_toReal (a : Fin 3) :
    (ternaryLaw a).toReal = if a = 0 then 1 / 2 else if a = 1 then 1 / 6 else 1 / 3 := by
  fin_cases a <;>
    norm_num [ternaryLaw, PMF.binaryMixture_apply, PMF.pure_apply, ENNReal.coe_sub,
      Fin.ext_iff]

private theorem ternaryRows_toReal (a : Fin 3) (b : Bool) :
    (ternaryRows a b).toReal =
      if a = 0 then (if b then 0 else 1)
      else if a = 1 then (if b then 1 else 0) else 1 / 2 := by
  fin_cases a <;> cases b <;>
    norm_num [ternaryRows, PMF.pure_apply, PMF.uniformOfFintype_apply, Fin.ext_iff]

private theorem ternary_masses_distinct :
    (ternaryLaw 0).toReal ≠ (ternaryLaw 1).toReal ∧
      (ternaryLaw 0).toReal ≠ (ternaryLaw 2).toReal ∧
      (ternaryLaw 1).toReal ≠ (ternaryLaw 2).toReal := by
  norm_num [ternaryLaw_toReal, Fin.ext_iff]

private theorem ternary_rows_distinct :
    ternaryRows 0 ≠ ternaryRows 1 ∧ ternaryRows 0 ≠ ternaryRows 2 ∧
      ternaryRows 1 ≠ ternaryRows 2 := by
  refine ⟨?_, ?_, ?_⟩ <;> intro h
  all_goals
    have hm := congrArg (fun r : PMF Bool => (r true).toReal) h
    norm_num [ternaryRows_toReal, Fin.ext_iff] at hm

private theorem cycle_input_mass (a : Fin 3) :
    (ternaryLaw.map threeCycle a).toReal = (ternaryLaw (threeCycle.symm a)).toReal := by
  have h := PMF.map_apply_equiv ternaryLaw threeCycle (threeCycle.symm a)
  simpa using congrArg ENNReal.toReal h

private theorem cycle_joint_transport :
    PMF.channelJoint (ternaryLaw.map threeCycle) (fun a => ternaryRows (threeCycle.symm a)) =
      (PMF.channelJoint ternaryLaw ternaryRows).map (fun z => (threeCycle z.1, z.2)) := by
  simp [PMF.channelJoint, PMF.map_bind, PMF.map_comp, Function.comp_def]

private theorem cycle_output_unchanged :
    (ternaryLaw.map threeCycle).bind (fun a => ternaryRows (threeCycle.symm a)) =
      ternaryLaw.bind ternaryRows := by
  simp [Function.comp_def]

private theorem cycle_objective_unchanged :
    mutualInfo (PMF.channelJoint (ternaryLaw.map threeCycle)
      (fun a => ternaryRows (threeCycle.symm a))) =
      mutualInfo (PMF.channelJoint ternaryLaw ternaryRows) := by
  rw [cycle_joint_transport]
  apply le_antisymm (mutualInfo_map_fst_le _ threeCycle)
  have h := mutualInfo_map_fst_le
    ((PMF.channelJoint ternaryLaw ternaryRows).map (fun z => (threeCycle z.1, z.2)))
    threeCycle.symm
  simp only [PMF.map_comp, Function.comp_def, Equiv.symm_apply_apply, Prod.eta] at h
  change mutualInfo ((PMF.channelJoint ternaryLaw ternaryRows).map id) ≤ _ at h
  rw [PMF.map_id] at h
  exact h

private theorem cycle_capacity_unchanged :
    channelCapacity (fun a => ternaryRows (threeCycle.symm a)) = channelCapacity ternaryRows := by
  simpa [PMF.map_id] using
    channelCapacity_congr_equiv ternaryRows threeCycle (Equiv.refl Bool)

private theorem swapped_output_capacity_unchanged :
    channelCapacity (fun a => (ternaryRows a).map (Equiv.swap false true)) =
      channelCapacity ternaryRows :=
  output_only_capacity ternaryRows (Equiv.swap false true)

private theorem cycle_output_masses :
    ((ternaryLaw.bind ternaryRows) true).toReal = 1 / 3 ∧
      (((ternaryLaw.map threeCycle).bind (fun a => ternaryRows (threeCycle a))) true).toReal =
        7 / 12 := by
  constructor
  · rw [PMF.bind_toReal_apply, Fin.sum_univ_three]
    norm_num [ternaryLaw_toReal, ternaryRows_toReal, Fin.ext_iff]
  · rw [PMF.bind_map, PMF.bind_toReal_apply, Fin.sum_univ_three]
    simp only [Function.comp_apply]
    norm_num [cycle_values.1, cycle_values.2.1, cycle_values.2.2,
      ternaryLaw_toReal, ternaryRows_toReal, Fin.ext_iff]

private theorem cycle_orientation_atom :
    (PMF.channelJoint (ternaryLaw.map threeCycle)
      (fun a => ternaryRows (threeCycle.symm a)) (1, true)).toReal = 0 ∧
      (PMF.channelJoint (ternaryLaw.map threeCycle)
        (fun a => ternaryRows (threeCycle a)) (1, true)).toReal = 1 / 4 := by
  simp only [PMF.channelJoint_apply, ENNReal.toReal_mul, cycle_input_mass,
    cycle_inverse_values.2.1, cycle_values.2.1]
  norm_num [ternaryLaw_toReal, ternaryRows_toReal, Fin.ext_iff]

private theorem cycle_orientation_changes_joint :
    PMF.channelJoint (ternaryLaw.map threeCycle) (fun a => ternaryRows (threeCycle.symm a)) ≠
      PMF.channelJoint (ternaryLaw.map threeCycle) (fun a => ternaryRows (threeCycle a)) := by
  intro h
  have hm := congrArg (fun r : PMF (Fin 3 × Bool) => (r (1, true)).toReal) h
  rw [cycle_orientation_atom.1, cycle_orientation_atom.2] at hm
  norm_num at hm

private def stochasticStage (b : Bool) : PMF Bool :=
  if b then PMF.uniformOfFintype Bool else PMF.pure false

private theorem stochastic_stage_not_pure (b : Bool) :
    stochasticStage true ≠ PMF.pure b := by
  intro h
  have hm := congrArg (fun r : PMF Bool => (r true).toReal) h
  cases b <;>
    norm_num [stochasticStage, PMF.uniformOfFintype_apply, PMF.pure_apply] at hm

private theorem stochastic_processing :
    channelCapacity (PMF.channelComp ternaryRows stochasticStage) ≤ channelCapacity ternaryRows ∧
      ((ternaryLaw.bind (PMF.channelComp ternaryRows stochasticStage)) true).toReal = 1 / 6 := by
  refine ⟨channelCapacity_channelComp_le ternaryRows stochasticStage, ?_⟩
  have htrue := cycle_output_masses.1
  have hfalse : ((ternaryLaw.bind ternaryRows) false).toReal = 2 / 3 := by
    have hsum := PMF.sum_toReal (ternaryLaw.bind ternaryRows)
    rw [Fintype.sum_bool] at hsum
    linarith
  rw [PMF.bind_channelComp, PMF.bind_toReal_apply, Fintype.sum_bool]
  rw [htrue, hfalse]
  norm_num [stochasticStage, PMF.uniformOfFintype_apply, PMF.pure_apply]

private def collapseOutput (_ : Bool) : Unit := ()

private theorem collapseOutput_not_injective : ¬ Function.Injective collapseOutput := by
  intro h
  have hbad : (false : Bool) = true := h rfl
  cases hbad

private theorem stochastic_then_collapse :
    channelCapacity (fun a =>
      ((PMF.channelComp ternaryRows stochasticStage) a).map collapseOutput) = 0 ∧
      channelCapacity (fun a =>
        ((PMF.channelComp ternaryRows stochasticStage) a).map collapseOutput) ≤
          channelCapacity ternaryRows := by
  refine ⟨singleton_output_capacity _, ?_⟩
  exact (channelCapacity_map_output_le (PMF.channelComp ternaryRows stochasticStage)
    collapseOutput).trans (channelCapacity_channelComp_le ternaryRows stochasticStage)

private theorem mixture_of_achievers {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B]
    (t : NNReal) (ht : t ≤ 1) (p q : PMF A) (W : A → PMF B)
    (hp : mutualInfo (PMF.channelJoint p W) = channelCapacity W)
    (hq : mutualInfo (PMF.channelJoint q W) = channelCapacity W) :
    mutualInfo (PMF.channelJoint (PMF.binaryMixture t ht p q) W) = channelCapacity W := by
  apply le_antisymm (mutualInfo_channelJoint_le_channelCapacity _ W)
  have h := mutualInfo_binaryMixture_input_concave t ht p q W
  simp only [hp, hq, NNReal.coe_sub ht, NNReal.coe_one] at h
  nlinarith

private theorem mixture_of_achievers_endpoints {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B] (p q : PMF A) (W : A → PMF B)
    (hp : mutualInfo (PMF.channelJoint p W) = channelCapacity W)
    (hq : mutualInfo (PMF.channelJoint q W) = channelCapacity W) :
    mutualInfo (PMF.channelJoint (PMF.binaryMixture 0 zero_le_one p q) W) = channelCapacity W ∧
      mutualInfo (PMF.channelJoint (PMF.binaryMixture 1 le_rfl p q) W) = channelCapacity W :=
  ⟨mixture_of_achievers 0 zero_le_one p q W hp hq,
    mixture_of_achievers 1 le_rfl p q W hp hq⟩

private theorem pure_inputs_distinct : PMF.pure false ≠ PMF.pure true := by
  intro h
  have hm := congrArg (fun r : PMF Bool => r true) h
  simp [PMF.pure_apply] at hm

private theorem distinct_achiever_mixtures (t : NNReal) (ht : t ≤ 1) :
    mutualInfo (PMF.channelJoint
      (PMF.binaryMixture t ht (PMF.pure false) (PMF.pure true))
      (fun _ : Bool => PMF.pure ())) = channelCapacity (fun _ : Bool => PMF.pure ()) := by
  have hachieve (r : PMF Bool) :
      mutualInfo (PMF.channelJoint r (fun _ : Bool => PMF.pure ())) =
        channelCapacity (fun _ : Bool => PMF.pure ()) := by
    apply le_antisymm (mutualInfo_channelJoint_le_channelCapacity _ _)
    rw [singleton_output_capacity]
    exact mutualInfo_nonneg _
  exact mixture_of_achievers t ht _ _ _ (hachieve _) (hachieve _)

end

end LeanInfoTheory.Examples.ChannelCapacity
