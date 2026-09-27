/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.Coupling

/-!
# Coupling interface consumers

These private examples use only the focused probability owner. They exercise
independent existence, both ordered marginals, heterogeneous coordinate types
and universes, diagonal coupling, swapping twice, and empty-alphabet impossibility.
They use the public predicate and witnesses without Shannon semantics.
Finite consumers check the coupling inequality in both coordinate orders,
diagonal and subsingleton equality, disjoint and pure endpoints, asymmetric
Boolean laws, and strict inequality for two independent fair Boolean variables.
Further consumers use the actual common-mass constructor through its public
marginal and exact-disagreement theorems, including swapped coordinates, sparse
ternary laws, and both orders of asymmetric laws with positive Boolean masses.
The actual witness attains the smallest disagreement among all supplied couplings
of its two marginals.
Constructor-specific endpoint identities and atom checks stay in the owner.
-/

namespace LeanInfoTheory.Examples.Coupling

universe u v

open scoped BigOperators ENNReal

private theorem independent_marginals {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF beta) :
    (PMF.channelJoint p (fun _ => q)).map Prod.fst = p ∧
      (PMF.channelJoint p (fun _ => q)).map Prod.snd = q := by
  have h := PMF.isCoupling_channelJoint_const p q
  exact ⟨h.1, h.2⟩

private theorem heterogeneous_existence (p : PMF Nat) (q : PMF Bool) :
    ∃ joint : PMF (Nat × Bool),
      joint.map Prod.fst = p ∧ joint.map Prod.snd = q := by
  obtain ⟨joint, h⟩ := PMF.exists_isCoupling p q
  exact ⟨joint, h.1, h.2⟩

private theorem diagonal_marginals {alpha : Type u} (p : PMF alpha) :
    (p.map (fun a => (a, a))).map Prod.fst = p ∧
      (p.map (fun a => (a, a))).map Prod.snd = p := by
  have h := PMF.isCoupling_map_diag p
  exact ⟨h.1, h.2⟩

private theorem reversed_marginals {alpha : Type u} {beta : Type v}
    {joint : PMF (alpha × beta)} {p : PMF alpha} {q : PMF beta}
    (h : PMF.IsCoupling joint p q) :
    (joint.map Prod.swap).map Prod.fst = q ∧
      (joint.map Prod.swap).map Prod.snd = p := by
  exact ⟨h.map_swap.1, h.map_swap.2⟩

private theorem swap_twice {alpha : Type u} {beta : Type v}
    {joint : PMF (alpha × beta)} {p : PMF alpha} {q : PMF beta}
    (h : PMF.IsCoupling joint p q) :
    (joint.map Prod.swap).map Prod.swap = joint ∧
      PMF.IsCoupling ((joint.map Prod.swap).map Prod.swap) p q := by
  refine ⟨?_, h.map_swap.map_swap⟩
  rw [PMF.map_comp]
  exact PMF.map_id joint

private theorem empty_alphabet_impossible {alpha : Type u} [IsEmpty alpha]
    (p : PMF alpha) : False := by
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

private theorem coupling_bounds_both_orders {alpha : Type u} [Fintype alpha]
    {joint : PMF (alpha × alpha)} {p q : PMF alpha}
    (h : PMF.IsCoupling joint p q) :
    PMF.totalVariation p q ≤ (joint.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal ∧
      PMF.totalVariation q p ≤ (joint.toOuterMeasure {xy | xy.2 ≠ xy.1}).toReal := by
  refine ⟨h.totalVariation_le, ?_⟩
  have hs := h.map_swap.totalVariation_le
  rw [PMF.toOuterMeasure_map_apply] at hs
  exact hs

private theorem diagonal_disagreement {alpha : Type u} (p : PMF alpha) :
    ((p.map (fun a => (a, a))).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 0 := by
  rw [PMF.toOuterMeasure_map_apply]
  simp

private theorem diagonal_inequality_equality {alpha : Type u} [Fintype alpha]
    (p : PMF alpha) :
    PMF.totalVariation p p =
        ((p.map (fun a => (a, a))).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal ∧
      PMF.totalVariation p p ≤
        ((p.map (fun a => (a, a))).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal := by
  exact ⟨by rw [PMF.totalVariation_self, diagonal_disagreement],
    (PMF.isCoupling_map_diag p).totalVariation_le⟩

private theorem subsingleton_inequality {alpha : Type u} [Fintype alpha]
    [Subsingleton alpha] {joint : PMF (alpha × alpha)} {p q : PMF alpha}
    (h : PMF.IsCoupling joint p q) :
    PMF.totalVariation p q = 0 ∧
      (joint.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 0 := by
  have hevent : {xy : alpha × alpha | xy.1 ≠ xy.2} = (∅ : Set (alpha × alpha)) := by
    ext xy
    simp [Subsingleton.elim xy.1 xy.2]
  have hzero : (joint.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 0 := by
    rw [hevent]
    simp
  refine ⟨le_antisymm ?_ (PMF.totalVariation_nonneg p q), hzero⟩
  simpa only [hzero] using h.totalVariation_le

private theorem disjoint_disagreement_lower_bound {alpha : Type u} [Finite alpha]
    {joint : PMF (alpha × alpha)} {p q : PMF alpha}
    (h : PMF.IsCoupling joint p q) (hdis : Disjoint p.support q.support) :
    1 ≤ (joint.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal := by
  let : Fintype alpha := Fintype.ofFinite alpha
  have htv := (PMF.totalVariation_eq_one_iff_disjoint_support p q).2 hdis
  simpa only [htv] using h.totalVariation_le

private theorem distinct_pure_endpoint :
    PMF.totalVariation (PMF.pure false) (PMF.pure true) = 1 ∧
      ((PMF.channelJoint (PMF.pure false) (fun _ => PMF.pure true)).toOuterMeasure
        {xy | xy.1 ≠ xy.2}).toReal = 1 ∧
      PMF.totalVariation (PMF.pure false) (PMF.pure true) ≤
        ((PMF.channelJoint (PMF.pure false) (fun _ => PMF.pure true)).toOuterMeasure
          {xy | xy.1 ≠ xy.2}).toReal := by
  refine ⟨?_, ?_, (PMF.isCoupling_channelJoint_const
    (PMF.pure false) (PMF.pure true)).totalVariation_le⟩
  · norm_num [PMF.totalVariation, Fintype.sum_bool, PMF.pure_apply]
  · rw [PMF.toOuterMeasure_toReal_eq_sum]
    norm_num [Fintype.sum_prod_type, Fintype.sum_bool, Set.indicator,
      PMF.channelJoint_apply, PMF.pure_apply]

private noncomputable def fairBool : PMF Bool :=
  PMF.ofFintype (fun _ => ENNReal.ofReal (1 / 2 : ℝ)) (by
    rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
    norm_num)

private theorem asymmetric_independent :
    (PMF.channelJoint (PMF.pure false) (fun _ => fairBool)).map Prod.fst = PMF.pure false ∧
      (PMF.channelJoint (PMF.pure false) (fun _ => fairBool)).map Prod.snd = fairBool ∧
      PMF.totalVariation (PMF.pure false) fairBool = 1 / 2 ∧
      ((PMF.channelJoint (PMF.pure false) (fun _ => fairBool)).toOuterMeasure
        {xy | xy.1 ≠ xy.2}).toReal = 1 / 2 ∧
      PMF.totalVariation (PMF.pure false) fairBool ≤
        ((PMF.channelJoint (PMF.pure false) (fun _ => fairBool)).toOuterMeasure
          {xy | xy.1 ≠ xy.2}).toReal ∧
      PMF.totalVariation fairBool (PMF.pure false) ≤
        ((PMF.channelJoint (PMF.pure false) (fun _ => fairBool)).toOuterMeasure
          {xy | xy.2 ≠ xy.1}).toReal := by
  have h := PMF.isCoupling_channelJoint_const (PMF.pure false) fairBool
  refine ⟨h.1, h.2, ?_, ?_, coupling_bounds_both_orders h⟩
  · norm_num [PMF.totalVariation, Fintype.sum_bool, PMF.pure_apply,
      fairBool, PMF.ofFintype_apply]
  · rw [PMF.toOuterMeasure_toReal_eq_sum]
    norm_num [Fintype.sum_prod_type, Fintype.sum_bool, Set.indicator,
      PMF.channelJoint_apply, PMF.pure_apply, fairBool, PMF.ofFintype_apply]

private theorem fair_independent_strict :
    PMF.totalVariation fairBool fairBool = 0 ∧
      ((PMF.channelJoint fairBool (fun _ => fairBool)).toOuterMeasure
        {xy | xy.1 ≠ xy.2}).toReal = 1 / 2 ∧
      ((fairBool.map (fun a => (a, a))).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 0 ∧
      PMF.totalVariation fairBool fairBool ≤
        ((PMF.channelJoint fairBool (fun _ => fairBool)).toOuterMeasure
          {xy | xy.1 ≠ xy.2}).toReal ∧
      PMF.totalVariation fairBool fairBool <
        ((PMF.channelJoint fairBool (fun _ => fairBool)).toOuterMeasure
          {xy | xy.1 ≠ xy.2}).toReal := by
  have hind : ((PMF.channelJoint fairBool (fun _ => fairBool)).toOuterMeasure
      {xy | xy.1 ≠ xy.2}).toReal = 1 / 2 := by
    rw [PMF.toOuterMeasure_toReal_eq_sum]
    norm_num [Fintype.sum_prod_type, Fintype.sum_bool, Set.indicator,
      PMF.channelJoint_apply, fairBool, PMF.ofFintype_apply, ENNReal.toReal_mul]
  refine ⟨PMF.totalVariation_self fairBool, hind, diagonal_disagreement fairBool,
    (PMF.isCoupling_channelJoint_const fairBool fairBool).totalVariation_le, ?_⟩
  rw [PMF.totalVariation_self, hind]
  norm_num

private theorem constructed_marginals {alpha : Type u} [Fintype alpha]
    (p q : PMF alpha) :
    (PMF.maximalCoupling p q).map Prod.fst = p ∧
      (PMF.maximalCoupling p q).map Prod.snd = q := by
  have h := PMF.isCoupling_maximalCoupling p q
  exact ⟨h.1, h.2⟩

private theorem constructed_swapped_marginals {alpha : Type u} [Fintype alpha]
    (p q : PMF alpha) :
    ((PMF.maximalCoupling p q).map Prod.swap).map Prod.fst = q ∧
      ((PMF.maximalCoupling p q).map Prod.swap).map Prod.snd = p :=
  reversed_marginals (PMF.isCoupling_maximalCoupling p q)

private theorem constructed_attains {alpha : Type u} [Fintype alpha]
    (p q : PMF alpha) :
    (PMF.maximalCoupling p q).map Prod.fst = p ∧
      (PMF.maximalCoupling p q).map Prod.snd = q ∧
      (PMF.maximalCoupling p q).toOuterMeasure {xy | xy.1 ≠ xy.2} =
        ENNReal.ofReal (PMF.totalVariation p q) ∧
      ∀ joint : PMF (alpha × alpha), PMF.IsCoupling joint p q →
        ((PMF.maximalCoupling p q).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal ≤
          (joint.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal := by
  have hm := PMF.isCoupling_maximalCoupling p q
  refine ⟨hm.1, hm.2, PMF.maximalCoupling_toOuterMeasure_ne p q, ?_⟩
  intro joint hj
  rw [PMF.maximalCoupling_toOuterMeasure_ne_toReal]
  exact hj.totalVariation_le

private theorem constructed_equal {alpha : Type u} [Fintype alpha] (p : PMF alpha) :
    PMF.totalVariation p p = 0 ∧
      (PMF.maximalCoupling p p).map Prod.fst = p ∧
      (PMF.maximalCoupling p p).map Prod.snd = p ∧
      ((PMF.maximalCoupling p p).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 0 := by
  refine ⟨PMF.totalVariation_self p, (constructed_marginals p p).1,
    (constructed_marginals p p).2, ?_⟩
  rw [PMF.maximalCoupling_toOuterMeasure_ne_toReal, PMF.totalVariation_self]

private theorem constructed_disjoint {alpha : Type u} [Fintype alpha]
    (p q : PMF alpha) (hdis : Disjoint p.support q.support) :
    PMF.totalVariation p q = 1 ∧
      (PMF.maximalCoupling p q).map Prod.fst = p ∧
      (PMF.maximalCoupling p q).map Prod.snd = q ∧
      ((PMF.maximalCoupling p q).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 1 := by
  have htv := (PMF.totalVariation_eq_one_iff_disjoint_support p q).2 hdis
  refine ⟨htv, (constructed_marginals p q).1, (constructed_marginals p q).2, ?_⟩
  rw [PMF.maximalCoupling_toOuterMeasure_ne_toReal, htv]

private theorem constructed_distinct_pure :
    PMF.totalVariation (PMF.pure false) (PMF.pure true) = 1 ∧
      (PMF.maximalCoupling (PMF.pure false) (PMF.pure true)).map Prod.fst =
        PMF.pure false ∧
      (PMF.maximalCoupling (PMF.pure false) (PMF.pure true)).map Prod.snd =
        PMF.pure true ∧
      ((PMF.maximalCoupling (PMF.pure false) (PMF.pure true)).toOuterMeasure
        {xy | xy.1 ≠ xy.2}).toReal = 1 := by
  apply constructed_disjoint
  simp [PMF.support_pure]

private theorem half_mass_add :
    ENNReal.ofReal (1 / 2 : ℝ) + ENNReal.ofReal (1 / 2 : ℝ) = 1 := by
  rw [← ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1 / 2)
    (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  norm_num

private noncomputable def sparseP : PMF (Fin 3) :=
  PMF.ofFintype (fun a => if a = 2 then 0 else ENNReal.ofReal (1 / 2 : ℝ))
    (by simpa [Fin.sum_univ_three] using half_mass_add)

private noncomputable def sparseQ : PMF (Fin 3) :=
  PMF.ofFintype (fun a => if a = 0 then 0 else ENNReal.ofReal (1 / 2 : ℝ))
    (by simpa [Fin.sum_univ_three] using half_mass_add)

private theorem sparse_distance : PMF.totalVariation sparseP sparseQ = 1 / 2 := by
  rw [PMF.totalVariation_eq_one_sub_sum_min, Fin.sum_univ_three]
  norm_num [sparseP, sparseQ, PMF.ofFintype_apply, show (1 : Fin 3) ≠ 2 by decide]

private theorem constructed_sparse :
    PMF.totalVariation sparseP sparseQ = 1 / 2 ∧
      (PMF.maximalCoupling sparseP sparseQ).map Prod.fst = sparseP ∧
      (PMF.maximalCoupling sparseP sparseQ).map Prod.snd = sparseQ ∧
      (PMF.maximalCoupling sparseQ sparseP).map Prod.fst = sparseQ ∧
      (PMF.maximalCoupling sparseQ sparseP).map Prod.snd = sparseP ∧
      ((PMF.maximalCoupling sparseP sparseQ).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal =
        1 / 2 ∧
      ((PMF.maximalCoupling sparseQ sparseP).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal =
        1 / 2 := by
  refine ⟨sparse_distance, (constructed_marginals sparseP sparseQ).1,
    (constructed_marginals sparseP sparseQ).2, (constructed_marginals sparseQ sparseP).1,
    (constructed_marginals sparseQ sparseP).2, ?_, ?_⟩
  · rw [PMF.maximalCoupling_toOuterMeasure_ne_toReal, sparse_distance]
  · rw [PMF.maximalCoupling_toOuterMeasure_ne_toReal,
      PMF.totalVariation_comm sparseQ sparseP, sparse_distance]

private theorem constructed_asymmetric :
    (PMF.maximalCoupling (PMF.pure false) fairBool).map Prod.fst = PMF.pure false ∧
      (PMF.maximalCoupling (PMF.pure false) fairBool).map Prod.snd = fairBool ∧
      (PMF.maximalCoupling fairBool (PMF.pure false)).map Prod.fst = fairBool ∧
      (PMF.maximalCoupling fairBool (PMF.pure false)).map Prod.snd = PMF.pure false ∧
      ((PMF.maximalCoupling (PMF.pure false) fairBool).toOuterMeasure
        {xy | xy.1 ≠ xy.2}).toReal = 1 / 2 ∧
      ((PMF.maximalCoupling fairBool (PMF.pure false)).toOuterMeasure
        {xy | xy.1 ≠ xy.2}).toReal = 1 / 2 := by
  have htv : PMF.totalVariation (PMF.pure false) fairBool = 1 / 2 :=
    asymmetric_independent.2.2.1
  refine ⟨(constructed_marginals (PMF.pure false) fairBool).1,
    (constructed_marginals (PMF.pure false) fairBool).2,
    (constructed_marginals fairBool (PMF.pure false)).1,
    (constructed_marginals fairBool (PMF.pure false)).2, ?_, ?_⟩
  · rw [PMF.maximalCoupling_toOuterMeasure_ne_toReal, htv]
  · rw [PMF.maximalCoupling_toOuterMeasure_ne_toReal,
      PMF.totalVariation_comm fairBool (PMF.pure false), htv]

private noncomputable def quarterBool : PMF Bool :=
  PMF.ofFintype (fun b => ENNReal.ofReal (if b then (1 / 4 : ℝ) else 3 / 4)) (by
    rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
    norm_num)

private theorem constructed_interior_boolean :
    (∀ b : Bool, 0 < (quarterBool b).toReal ∧ (quarterBool b).toReal < 1 ∧
      0 < (fairBool b).toReal ∧ (fairBool b).toReal < 1) ∧
      PMF.totalVariation quarterBool fairBool = 1 / 4 ∧
      (PMF.maximalCoupling quarterBool fairBool).map Prod.fst = quarterBool ∧
      (PMF.maximalCoupling quarterBool fairBool).map Prod.snd = fairBool ∧
      (PMF.maximalCoupling fairBool quarterBool).map Prod.fst = fairBool ∧
      (PMF.maximalCoupling fairBool quarterBool).map Prod.snd = quarterBool ∧
      ((PMF.maximalCoupling quarterBool fairBool).toOuterMeasure
        {xy | xy.1 ≠ xy.2}).toReal = 1 / 4 ∧
      ((PMF.maximalCoupling fairBool quarterBool).toOuterMeasure
        {xy | xy.1 ≠ xy.2}).toReal = 1 / 4 := by
  have htv : PMF.totalVariation quarterBool fairBool = 1 / 4 := by
    norm_num [PMF.totalVariation, Fintype.sum_bool, quarterBool, fairBool,
      PMF.ofFintype_apply]
  refine ⟨?_, htv, (constructed_marginals quarterBool fairBool).1,
    (constructed_marginals quarterBool fairBool).2, (constructed_marginals fairBool quarterBool).1,
    (constructed_marginals fairBool quarterBool).2, ?_, ?_⟩
  · intro b
    cases b <;> norm_num [quarterBool, fairBool, PMF.ofFintype_apply]
  · rw [PMF.maximalCoupling_toOuterMeasure_ne_toReal, htv]
  · rw [PMF.maximalCoupling_toOuterMeasure_ne_toReal,
      PMF.totalVariation_comm fairBool quarterBool, htv]

private theorem constructed_subsingleton {alpha : Type u} [Fintype alpha]
    [Subsingleton alpha] (p q : PMF alpha) :
    p = q ∧
      (PMF.maximalCoupling p q).map Prod.fst = p ∧
      (PMF.maximalCoupling p q).map Prod.snd = q ∧
      PMF.totalVariation p q = 0 ∧
      ((PMF.maximalCoupling p q).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 0 := by
  have hs := subsingleton_inequality (PMF.isCoupling_maximalCoupling p q)
  exact ⟨(PMF.totalVariation_eq_zero_iff p q).1 hs.1,
    (constructed_marginals p q).1, (constructed_marginals p q).2, hs⟩

private theorem empty_constructor_has_no_inputs :
    ¬ ∃ p q : PMF Empty, PMF.IsCoupling (PMF.maximalCoupling p q) p q := by
  rintro ⟨p, _, _⟩
  exact empty_alphabet_impossible p

end LeanInfoTheory.Examples.Coupling
