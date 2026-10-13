/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.Topology

/-!
# Information continuity and maximizing-input consumers

These private consumers obtain a maximizing input for the actual mutual
information of a finite channel from delivered compactness and continuity.
They propagate the Boolean input family with masses `1 - t` and `t` through
the same pure/fair channel as the focused probability examples, proving explicit
MI and conditional-entropy limits at its pure endpoint. The conditioning
marginal is positive for `t > 0` and vanishes at zero.

Singleton input and output laws give zero MI. Empty input has no optimizing
law, although its channel function exists; nonempty input and empty output
have no channel. No capacity definition or conditional-law limit is introduced.
-/

namespace LeanInfoTheory.Examples.ChannelOptimization

noncomputable section

universe u v

open Filter Topology LeanInfoTheory.Shannon
open scoped BigOperators

private theorem exists_maximizing_input {α : Type u} {β : Type v}
    [Fintype α] [Nonempty α] [Fintype β] (W : α → PMF β) :
    ∃ p : PMF α, ∀ q : PMF α,
      mutualInfo (PMF.channelJoint q W) ≤
        mutualInfo (PMF.channelJoint p W) := by
  obtain ⟨p, _, hp⟩ := isCompact_univ.exists_isMaxOn
    (s := Set.univ)
    ⟨PMF.pure (Classical.choice (inferInstance : Nonempty α)),
      Set.mem_univ _⟩
    (continuous_mutualInfo_channelJoint W).continuousOn
  exact ⟨p, fun q => hp (Set.mem_univ q)⟩

private abbrev Parameter := Set.Icc (0 : ℝ) 1

private def parameterZero : Parameter := ⟨0, le_rfl, zero_le_one⟩

private def parameterHalf : Parameter := ⟨1 / 2, by norm_num, by norm_num⟩

private def booleanFamily (t : Parameter) : PMF Bool :=
  PMF.ofFintype (fun b => ENNReal.ofReal (if b then t.1 else 1 - t.1)) (by
    simp only [Fintype.sum_bool, Bool.false_eq_true, ↓reduceIte]
    rw [← ENNReal.ofReal_add t.2.1 (sub_nonneg.mpr t.2.2)]
    rw [show t.1 + (1 - t.1) = 1 by ring, ENNReal.ofReal_one])

private theorem booleanFamily_toReal (t : Parameter) (b : Bool) :
    (booleanFamily t b).toReal = if b then t.1 else 1 - t.1 := by
  cases b <;>
    simp [booleanFamily, PMF.ofFintype_apply, ENNReal.toReal_ofReal,
      t.2.1, sub_nonneg.mpr t.2.2]

private theorem booleanFamily_zero :
    booleanFamily parameterZero = PMF.pure false := by
  apply PMF.ext
  intro b
  cases b <;>
    norm_num [booleanFamily, parameterZero, PMF.ofFintype_apply, PMF.pure_apply]

private def boundaryChannel (a : Bool) : PMF Bool :=
  if a then booleanFamily parameterHalf else booleanFamily parameterZero

private def boundaryJoint (t : Parameter) : PMF (Bool × Bool) :=
  PMF.channelJoint (booleanFamily t) boundaryChannel

private theorem boundaryChannel_toReal (a b : Bool) :
    (boundaryChannel a b).toReal =
      if a then 1 / 2 else if b then 0 else 1 := by
  cases a <;> cases b <;>
    norm_num [boundaryChannel, booleanFamily_toReal, parameterZero, parameterHalf]

private theorem boundary_conditioning_marginal_toReal (t : Parameter) :
    (sndMarginal (boundaryJoint t) true).toReal = t.1 / 2 := by
  rw [sndMarginal, boundaryJoint, PMF.channelJoint_map_snd,
    PMF.bind_toReal_apply, Fintype.sum_bool]
  norm_num [booleanFamily_toReal, boundaryChannel_toReal]
  ring

private theorem boundary_conditioning_marginal_positive
    (t : Parameter) (ht : 0 < t.1) :
    0 < sndMarginal (boundaryJoint t) true := by
  have h : 0 < (sndMarginal (boundaryJoint t) true).toReal := by
    rw [boundary_conditioning_marginal_toReal]
    positivity
  exact (ENNReal.toReal_pos_iff.mp h).1

private theorem boundaryJoint_zero :
    boundaryJoint parameterZero = PMF.pure (false, false) := by
  rw [boundaryJoint, booleanFamily_zero, PMF.channelJoint, PMF.pure_bind]
  simp [boundaryChannel, booleanFamily_zero, PMF.pure_map]

private theorem boundary_mutualInfo_zero :
    mutualInfo (boundaryJoint parameterZero) = 0 := by
  rw [boundaryJoint_zero]
  simp [mutualInfo, fstMarginal, sndMarginal, PMF.pure_map]

private theorem boundary_condEntropy_zero :
    condEntropy (boundaryJoint parameterZero) = 0 := by
  rw [boundaryJoint_zero]
  simp [condEntropy, sndMarginal, PMF.pure_map]

private theorem boundary_conditioning_marginal_null :
    sndMarginal (boundaryJoint parameterZero) true = 0 := by
  rw [boundaryJoint_zero]
  simp [sndMarginal, PMF.pure_map, PMF.pure_apply]

private theorem parameter_tendsto_zero :
    Tendsto (fun t : Parameter => t.1)
      (𝓝 parameterZero) (𝓝 (0 : ℝ)) :=
  continuous_subtype_val.continuousAt

private theorem booleanFamily_coordinate_limits (b : Bool) :
    Tendsto (fun t : Parameter => (booleanFamily t b).toReal)
      (𝓝 parameterZero) (𝓝 ((booleanFamily parameterZero b).toReal)) := by
  simp only [booleanFamily_toReal]
  cases b
  · simpa [parameterZero] using tendsto_const_nhds.sub parameter_tendsto_zero
  · simpa [parameterZero] using parameter_tendsto_zero

private theorem booleanFamily_tendsto :
    Tendsto booleanFamily
      (𝓝 parameterZero) (𝓝 (booleanFamily parameterZero)) :=
  PMF.tendsto_iff_forall_toReal_tendsto.mpr booleanFamily_coordinate_limits

private theorem boundaryJoint_tendsto :
    Tendsto boundaryJoint
      (𝓝 parameterZero) (𝓝 (boundaryJoint parameterZero)) := by
  unfold boundaryJoint
  exact ((PMF.continuous_channelJoint boundaryChannel).tendsto
    (booleanFamily parameterZero)).comp booleanFamily_tendsto

private theorem boundary_mutualInfo_tendsto :
    Tendsto (fun t => mutualInfo (PMF.channelJoint (booleanFamily t) boundaryChannel))
      (𝓝 parameterZero) (𝓝 (0 : ℝ)) := by
  change Tendsto (fun t => mutualInfo (boundaryJoint t))
    (𝓝 parameterZero) (𝓝 (0 : ℝ))
  have h := ((continuous_mutualInfo_channelJoint boundaryChannel).tendsto
    (booleanFamily parameterZero)).comp booleanFamily_tendsto
  change Tendsto (fun t => mutualInfo (boundaryJoint t))
    (𝓝 parameterZero) (𝓝 (mutualInfo (boundaryJoint parameterZero))) at h
  simpa only [boundary_mutualInfo_zero] using h

private theorem boundary_condEntropy_tendsto :
    Tendsto (fun t => condEntropy (boundaryJoint t))
      (𝓝 parameterZero) (𝓝 (0 : ℝ)) := by
  have h := (continuous_condEntropy.tendsto
    (boundaryJoint parameterZero)).comp boundaryJoint_tendsto
  simpa only [Function.comp_def, boundary_condEntropy_zero] using h

private theorem unit_pmf_eq_pure (p : PMF Unit) : p = PMF.pure () := by
  have hp : p () = 1 := by simpa using p.tsum_coe
  apply PMF.ext
  intro a
  cases a
  simpa only [PMF.pure_apply_self] using hp

private theorem singleton_input_mi {β : Type v} [Fintype β]
    (p : PMF Unit) (W : Unit → PMF β) :
    mutualInfo (PMF.channelJoint p W) = 0 := by
  have hfst : fstMarginal (PMF.channelJoint p W) = p :=
    PMF.channelJoint_map_fst p W
  have hp : entropy p = 0 := by
    rw [unit_pmf_eq_pure p, entropy_pure]
  have hsum : entropy (sndMarginal (PMF.channelJoint p W)) =
      entropy (PMF.channelJoint p W) :=
    entropy_map_injective _ (by
      intro x y h
      exact Prod.ext (Subsingleton.elim _ _) h)
  rw [mutualInfo_eq, hfst, hp, hsum, zero_add, sub_self]

private theorem singleton_output_mi {α : Type u} [Fintype α]
    (p : PMF α) (W : α → PMF Unit) :
    mutualInfo (PMF.channelJoint p W) = 0 := by
  have hsnd : entropy (sndMarginal (PMF.channelJoint p W)) = 0 := by
    rw [unit_pmf_eq_pure (sndMarginal (PMF.channelJoint p W)), entropy_pure]
  have hsum : entropy (fstMarginal (PMF.channelJoint p W)) =
      entropy (PMF.channelJoint p W) :=
    entropy_map_injective _ (by
      intro x y h
      exact Prod.ext h (Subsingleton.elim _ _))
  rw [mutualInfo_eq, hsum, hsnd, add_zero, sub_self]

private theorem no_empty_input_optimizer {α : Type u} {β : Type v}
    [Fintype α] [IsEmpty α] [Fintype β] (W : α → PMF β) :
    ¬ ∃ p : PMF α, ∀ q : PMF α,
      mutualInfo (PMF.channelJoint q W) ≤
        mutualInfo (PMF.channelJoint p W) := by
  rintro ⟨p, _⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

private theorem empty_input_channel_exists {α : Type u} {β : Type v}
    [IsEmpty α] : Nonempty (α → PMF β) :=
  ⟨fun a => isEmptyElim a⟩

private theorem no_empty_output_channel {α : Type u} {β : Type v}
    [Nonempty α] [IsEmpty β] : ¬ Nonempty (α → PMF β) := by
  rintro ⟨W⟩
  obtain ⟨a⟩ := ‹Nonempty α›
  obtain ⟨b, _⟩ := (W a).support_nonempty
  exact isEmptyElim b

end

end LeanInfoTheory.Examples.ChannelOptimization
