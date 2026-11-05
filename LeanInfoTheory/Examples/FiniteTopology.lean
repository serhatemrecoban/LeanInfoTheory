/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.FiniteTopology

/-!
# Finite PMF topology consumers

These private consumers use the focused probability import. They check sparse
real coordinates, both simplex round trips, pure vertices, empty and singleton
alphabets, and reconstruction of a PMF limit from real-simplex coordinates.
The generic signatures also exercise unrelated universe levels and `Finite`
compactness without installing a local `Fintype` instance.

Probability-map consumers retain arbitrary output alphabets and include an
infinite input for joint continuity. They also exercise compact channel images,
a nonconstant noninjective deterministic map, and a stochastic channel along a
Boolean family approaching a pure input with a vanishing output coordinate.
-/

namespace LeanInfoTheory.Examples.FiniteTopology

noncomputable section

universe u v

open Filter Topology
open scoped BigOperators

private theorem half_mass_add :
    ENNReal.ofReal (1 / 2 : ℝ) + ENNReal.ofReal (1 / 2 : ℝ) = 1 := by
  rw [← ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1 / 2)
    (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  norm_num

private def sparse : PMF (Fin 3) :=
  PMF.ofFintype (fun a => if a = 2 then 0 else ENNReal.ofReal (1 / 2 : ℝ))
    (by simpa [Fin.sum_univ_three] using half_mass_add)

private theorem sparse_coordinates :
    PMF.homeomorphStdSimplex sparse 0 = 1 / 2 ∧
    PMF.homeomorphStdSimplex sparse 1 = 1 / 2 ∧
    PMF.homeomorphStdSimplex sparse 2 = 0 := by
  norm_num [PMF.homeomorphStdSimplex_apply, sparse, PMF.ofFintype_apply, Fin.ext_iff]

private theorem sparse_round_trip :
    PMF.homeomorphStdSimplex.symm (PMF.homeomorphStdSimplex sparse) = sparse :=
  PMF.homeomorphStdSimplex.symm_apply_apply sparse

private theorem simplex_round_trip {α : Type u} [Fintype α] (x : stdSimplex ℝ α) :
    PMF.homeomorphStdSimplex (PMF.homeomorphStdSimplex.symm x) = x :=
  PMF.homeomorphStdSimplex.apply_symm_apply x

private theorem pure_vertex_coordinate {α : Type u} [Fintype α] (a : α) :
    PMF.homeomorphStdSimplex (PMF.pure a) a = 1 := by
  rw [PMF.homeomorphStdSimplex_apply, PMF.pure_apply_self, ENNReal.toReal_one]

private theorem pure_other_coordinate {α : Type u} [Fintype α]
    (a b : α) (h : b ≠ a) :
    PMF.homeomorphStdSimplex (PMF.pure a) b = 0 := by
  rw [PMF.homeomorphStdSimplex_apply, PMF.pure_apply_of_ne a b h, ENNReal.toReal_zero]

private theorem no_empty_law {α : Type u} [IsEmpty α] : ¬ Nonempty (PMF α) := by
  rintro ⟨p⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

private theorem finite_compact {α : Type u} [Finite α] :
    IsCompact (Set.univ : Set (PMF α)) := isCompact_univ

private theorem empty_compact : IsCompact (Set.univ : Set (PMF Empty)) := isCompact_univ

private theorem singleton_compact : IsCompact (Set.univ : Set (PMF Unit)) := isCompact_univ

private theorem singleton_coordinate (p : PMF Unit) :
    PMF.homeomorphStdSimplex p () = 1 := by
  simpa only [PMF.homeomorphStdSimplex_apply, Fintype.sum_unique] using p.sum_toReal

private theorem continuous_real_coordinate {α : Type u} (a : α) :
    Continuous (fun p : PMF α => (p a).toReal) := PMF.continuous_apply_toReal a

private theorem law_limit_gives_coordinate {α : Type u} {ι : Type v} {l : Filter ι}
    {f : ι → PMF α} {p : PMF α} (h : Tendsto f l (𝓝 p)) (a : α) :
    Tendsto (fun i => (f i a).toReal) l (𝓝 ((p a).toReal)) :=
  (PMF.tendsto_iff_forall_toReal_tendsto.mp h) a

private theorem simplex_coordinates_give_law_limit {α : Type u} {ι : Type v}
    [Fintype α] {l : Filter ι} (x : ι → stdSimplex ℝ α) (y : stdSimplex ℝ α)
    (h : ∀ a, Tendsto (fun i => x i a) l (𝓝 (y a))) :
    Tendsto (fun i => PMF.homeomorphStdSimplex.symm (x i)) l
      (𝓝 (PMF.homeomorphStdSimplex.symm y)) := by
  apply PMF.tendsto_iff_forall_toReal_tendsto.mpr
  intro a
  have hx (i : ι) : ((PMF.homeomorphStdSimplex.symm (x i)) a).toReal = x i a := by
    rw [PMF.homeomorphStdSimplex_symm_apply]
    exact ENNReal.toReal_ofReal (stdSimplex.zero_le (x i) a)
  have hy : ((PMF.homeomorphStdSimplex.symm y) a).toReal = y a := by
    rw [PMF.homeomorphStdSimplex_symm_apply]
    exact ENNReal.toReal_ofReal (stdSimplex.zero_le y a)
  simpa only [hx, hy] using h a

private theorem map_generality {α : Type u} {β : Type v} [Finite α] (g : α → β) :
    Continuous (fun p : PMF α => p.map g) := PMF.continuous_map g

private theorem bind_generality {α : Type u} {β : Type v} [Finite α] (W : α → PMF β) :
    Continuous (fun p : PMF α => p.bind W) := PMF.continuous_bind W

private theorem joint_generality {α : Type u} {β : Type v} (W : α → PMF β) :
    Continuous (fun p : PMF α => PMF.channelJoint p W) := PMF.continuous_channelJoint W

private def boolNat (b : Bool) : Nat := if b then 1 else 0

private theorem bool_nat_map_continuous :
    Continuous (fun p : PMF Bool => p.map boolNat) := PMF.continuous_map boolNat

private theorem nat_bool_joint_continuous :
    Continuous (fun p : PMF Nat =>
      PMF.channelJoint p (fun n => PMF.pure (decide (n = 0)))) :=
  PMF.continuous_channelJoint _

private theorem compact_channel_image {α : Type u} {β : Type v} [Finite α]
    (W : α → PMF β) :
    IsCompact ((fun p : PMF α => p.bind W) '' (Set.univ : Set (PMF α))) :=
  isCompact_univ.image (PMF.continuous_bind W)

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


private def parameterHalf : Parameter := ⟨1 / 2, by norm_num, by norm_num⟩

private def boundaryChannel (a : Bool) : PMF Bool :=
  if a then booleanFamily parameterHalf else booleanFamily parameterZero

private def boundaryJoint (t : Parameter) : PMF (Bool × Bool) :=
  PMF.channelJoint (booleanFamily t) boundaryChannel

private theorem boundaryChannel_toReal (a b : Bool) :
    (boundaryChannel a b).toReal =
      if a then 1 / 2 else if b then 0 else 1 := by
  cases a <;> cases b <;>
    norm_num [boundaryChannel, booleanFamily_toReal, parameterZero, parameterHalf]

private theorem boundaryChannel_rows_distinct :
    boundaryChannel false ≠ boundaryChannel true := by
  intro h
  have hm := congrArg (fun p : PMF Bool => (p true).toReal) h
  norm_num [boundaryChannel_toReal] at hm

private theorem boundaryJoint_coordinates (t : Parameter) :
    (boundaryJoint t (false, false)).toReal = 1 - t.1 ∧
    (boundaryJoint t (false, true)).toReal = 0 ∧
    (boundaryJoint t (true, false)).toReal = t.1 / 2 ∧
    (boundaryJoint t (true, true)).toReal = t.1 / 2 := by
  simp only [boundaryJoint, PMF.channelJoint_apply, ENNReal.toReal_mul,
    booleanFamily_toReal, boundaryChannel_toReal, Bool.false_eq_true, ↓reduceIte,
    mul_one, one_mul, mul_zero, div_eq_mul_inv, and_self]

private theorem boundaryOutput_toReal (t : Parameter) (b : Bool) :
    ((booleanFamily t).bind boundaryChannel b).toReal =
      if b then t.1 / 2 else 1 - t.1 / 2 := by
  rw [PMF.bind_toReal_apply, Fintype.sum_bool]
  cases b <;>
    norm_num [booleanFamily_toReal, boundaryChannel_toReal] <;> ring

private theorem boundaryJoint_projections (t : Parameter) :
    (boundaryJoint t).map Prod.fst = booleanFamily t ∧
    (boundaryJoint t).map Prod.snd = (booleanFamily t).bind boundaryChannel :=
  ⟨PMF.channelJoint_map_fst _ _, PMF.channelJoint_map_snd _ _⟩

private theorem boundary_unused_row :
    booleanFamily parameterZero true = 0 ∧
    ∀ b, boundaryJoint parameterZero (true, b) = 0 := by
  have hz : booleanFamily parameterZero true = 0 := by
    rw [booleanFamily_zero]
    simp [PMF.pure_apply]
  refine ⟨hz, ?_⟩
  intro b
  simp [boundaryJoint, PMF.channelJoint_apply, hz]

private theorem boundaryOutput_zero :
    (booleanFamily parameterZero).bind boundaryChannel = PMF.pure false := by
  rw [booleanFamily_zero, PMF.pure_bind]
  simpa [boundaryChannel] using booleanFamily_zero

private theorem boundaryOutput_true_positive (t : Parameter) (ht : 0 < t.1) :
    0 < ((booleanFamily t).bind boundaryChannel true).toReal := by
  rw [boundaryOutput_toReal]
  exact div_pos ht (by norm_num)

private theorem boundaryOutput_true_mass_positive (t : Parameter) (ht : 0 < t.1) :
    0 < (booleanFamily t).bind boundaryChannel true :=
  (ENNReal.toReal_pos_iff.mp (boundaryOutput_true_positive t ht)).1

private theorem boundaryOutput_true_null :
    (booleanFamily parameterZero).bind boundaryChannel true = 0 := by
  rw [boundaryOutput_zero]
  simp [PMF.pure_apply]

private theorem booleanFamily_tendsto :
    Tendsto booleanFamily (𝓝 parameterZero) (𝓝 (booleanFamily parameterZero)) :=
  PMF.tendsto_iff_forall_toReal_tendsto.mpr booleanFamily_coordinate_limits

private theorem boundaryJoint_tendsto :
    Tendsto boundaryJoint (𝓝 parameterZero) (𝓝 (boundaryJoint parameterZero)) := by
  unfold boundaryJoint
  exact ((PMF.continuous_channelJoint boundaryChannel).tendsto
    (booleanFamily parameterZero)).comp booleanFamily_tendsto

private theorem boundaryOutput_tendsto :
    Tendsto (fun t => (booleanFamily t).bind boundaryChannel)
      (𝓝 parameterZero) (𝓝 (PMF.pure false)) := by
  have h := ((PMF.continuous_bind boundaryChannel).tendsto
    (booleanFamily parameterZero)).comp booleanFamily_tendsto
  simpa only [Function.comp_def, boundaryOutput_zero] using h

private theorem boundaryOutput_tendsto_from_joint :
    Tendsto (fun t => (booleanFamily t).bind boundaryChannel)
      (𝓝 parameterZero) (𝓝 (PMF.pure false)) := by
  have h := ((PMF.continuous_map (Prod.snd : Bool × Bool → Bool)).tendsto
    (boundaryJoint parameterZero)).comp boundaryJoint_tendsto
  simpa only [Function.comp_def, boundaryJoint, PMF.channelJoint_map_snd,
    boundaryOutput_zero] using h

private theorem boundaryInput_tendsto_from_joint :
    Tendsto (fun t => (boundaryJoint t).map Prod.fst)
      (𝓝 parameterZero) (𝓝 (booleanFamily parameterZero)) := by
  have h := ((PMF.continuous_map (Prod.fst : Bool × Bool → Bool)).tendsto
    (boundaryJoint parameterZero)).comp boundaryJoint_tendsto
  simpa only [Function.comp_def, boundaryJoint, PMF.channelJoint_map_fst] using h

private def natBoundaryChannel (a : Bool) : PMF Nat := (boundaryChannel a).map boolNat

private theorem bool_nat_bind_continuous :
    Continuous (fun p : PMF Bool => p.bind natBoundaryChannel) :=
  PMF.continuous_bind natBoundaryChannel

private def mergeAtoms (a : Fin 3) : Bool := decide (a = 0)

private theorem mergeAtoms_noninjective_nonconstant :
    ¬Function.Injective mergeAtoms ∧ mergeAtoms 0 ≠ mergeAtoms 1 := by
  constructor
  · intro h
    have heq : (1 : Fin 3) = 2 := h (by decide)
    exact (by decide : (1 : Fin 3) ≠ 2) heq
  · decide

private theorem merged_sparse_toReal (b : Bool) :
    ((sparse.map mergeAtoms) b).toReal = 1 / 2 := by
  change ((sparse.bind (PMF.pure ∘ mergeAtoms)) b).toReal = 1 / 2
  rw [PMF.bind_toReal_apply, Fin.sum_univ_three]
  cases b <;>
    norm_num [sparse, PMF.ofFintype_apply, Function.comp_apply,
      PMF.pure_apply, mergeAtoms, Fin.ext_iff]

private theorem mergeAtoms_continuous :
    Continuous (fun p : PMF (Fin 3) => p.map mergeAtoms) :=
  PMF.continuous_map mergeAtoms

end

end LeanInfoTheory.Examples.FiniteTopology
