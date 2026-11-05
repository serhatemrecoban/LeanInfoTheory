/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.TotalVariationTopology

/-!
# Coordinate and total-variation convergence consumers

Private consumers compose the public coordinate and TV convergence interfaces
in both directions for arbitrary filters. A Boolean family on the closed unit
interval approaches the pure law at false, with exact coordinates and TV.
Singleton and impossible empty limits require no positivity assumptions.
-/

namespace LeanInfoTheory.Examples.TotalVariationTopology

noncomputable section

universe u v

open Filter Topology
open scoped BigOperators

private theorem tv_zero_of_coordinates {α : Type u} [Fintype α]
    {ι : Type v} {l : Filter ι} {f : ι → PMF α} {p : PMF α}
    (h : ∀ a, Tendsto (fun i => (f i a).toReal) l (𝓝 ((p a).toReal))) :
    Tendsto (fun i => PMF.totalVariation (f i) p) l (𝓝 0) :=
  PMF.tendsto_iff_totalVariation_tendsto_zero.mp
    (PMF.tendsto_iff_forall_toReal_tendsto.mpr h)

private theorem coordinates_of_tv_zero {α : Type u} [Fintype α]
    {ι : Type v} {l : Filter ι} {f : ι → PMF α} {p : PMF α}
    (h : Tendsto (fun i => PMF.totalVariation (f i) p) l (𝓝 0)) :
    ∀ a, Tendsto (fun i => (f i a).toReal) l (𝓝 ((p a).toReal)) :=
  PMF.tendsto_iff_forall_toReal_tendsto.mp
    (PMF.tendsto_iff_totalVariation_tendsto_zero.mpr h)

private abbrev Parameter := Set.Icc (0 : ℝ) 1

private def parameterZero : Parameter := ⟨0, le_rfl, zero_le_one⟩

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

private theorem booleanFamily_distance (t s : Parameter) :
    PMF.totalVariation (booleanFamily t) (booleanFamily s) = |t.1 - s.1| := by
  rw [PMF.totalVariation, Fintype.sum_bool]
  simp only [booleanFamily_toReal, Bool.false_eq_true, ↓reduceIte]
  rw [show 1 - t.1 - (1 - s.1) = -(t.1 - s.1) by ring, abs_neg]
  ring

private theorem booleanFamily_distance_zero (t : Parameter) :
    PMF.totalVariation (booleanFamily t) (booleanFamily parameterZero) = t.1 := by
  rw [booleanFamily_distance]
  simp [parameterZero, abs_of_nonneg t.2.1]

private theorem parameter_tendsto_zero :
    Tendsto (fun t : Parameter => t.1) (𝓝 parameterZero) (𝓝 (0 : ℝ)) :=
  continuous_subtype_val.continuousAt

private theorem booleanFamily_coordinate_limits (b : Bool) :
    Tendsto (fun t : Parameter => (booleanFamily t b).toReal)
      (𝓝 parameterZero) (𝓝 ((booleanFamily parameterZero b).toReal)) := by
  simp only [booleanFamily_toReal]
  cases b
  · simpa [parameterZero] using tendsto_const_nhds.sub parameter_tendsto_zero
  · simpa [parameterZero] using parameter_tendsto_zero

private theorem booleanFamily_tv_limit_from_coordinates :
    Tendsto (fun t : Parameter =>
      PMF.totalVariation (booleanFamily t) (booleanFamily parameterZero))
      (𝓝 parameterZero) (𝓝 0) :=
  tv_zero_of_coordinates booleanFamily_coordinate_limits

private theorem booleanFamily_tendsto_from_exact_tv :
    Tendsto booleanFamily (𝓝 parameterZero) (𝓝 (PMF.pure false)) := by
  rw [← booleanFamily_zero]
  apply PMF.tendsto_iff_totalVariation_tendsto_zero.mpr
  simpa only [booleanFamily_distance_zero] using parameter_tendsto_zero

private theorem booleanFamily_coordinates_from_tv :
    ∀ b, Tendsto (fun t : Parameter => (booleanFamily t b).toReal)
      (𝓝 parameterZero) (𝓝 ((booleanFamily parameterZero b).toReal)) :=
  coordinates_of_tv_zero booleanFamily_tv_limit_from_coordinates

private theorem singleton_tv (p q : PMF Unit) : PMF.totalVariation p q = 0 := by
  have hp : (p ()).toReal = 1 := by
    simpa only [Fintype.sum_unique] using p.sum_toReal
  have hq : (q ()).toReal = 1 := by
    simpa only [Fintype.sum_unique] using q.sum_toReal
  simp [PMF.totalVariation, hp, hq]

private theorem no_empty_limit {α : Type u} [IsEmpty α] {ι : Type v}
    (l : Filter ι) : ¬ ∃ (p : PMF α) (f : ι → PMF α), Tendsto f l (𝓝 p) := by
  rintro ⟨p, _, _⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

end

end LeanInfoTheory.Examples.TotalVariationTopology
