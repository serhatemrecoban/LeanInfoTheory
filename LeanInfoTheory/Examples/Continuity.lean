/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.Continuity

/-!
# Entropy-continuity consumers

These private consumers use the focused continuity owner. They apply its public
exact-distance inequality at zero distance, on singleton alphabets, and to both
orders of a sparse ternary point mass and the uniform law. Concrete Boolean
and ternary calculations check the half-L1 normalization, the zero binary
right-hand side at distance one, and the sharp pure-versus-uniform values.
Empty alphabets are tested through the impossibility of a probability law.

The capped bound is checked at zero, at binary and ternary thresholds, and
at budgets one and greater than one. A binary counterexample rules out
substitution of a mere upper estimate into the raw exact-distance expression.
Public monotonicity weakens a budget across the ternary threshold, and a
noninjective map applies the entropy bound with the output alphabet's size.

Joint-law consumers compare a sparse fair diagonal, its independent marginals,
and a supported point mass on `Bool × Fin 3`. They calculate the actual joint
and marginal distances and information values, including a null conditioning
fiber, before applying the three public bounds at a common budget. The two
marginal bounds saturate while the joint bound still uses its entropy branch.
Further consumers check both singleton-coordinate reductions, zero joint
distance, empty coordinates, swapped conditioning, and finite-valued observations
of two arbitrary source spaces.
-/

namespace LeanInfoTheory.Examples.Continuity

open Shannon
open scoped BigOperators ENNReal

private theorem equal_law_bound {α : Type*} [Fintype α] (p : PMF α) :
    |entropy p - entropy p| ≤ 0 := by
  simpa only [PMF.totalVariation_self, Real.binEntropy_zero, zero_mul, add_zero] using
    abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log p p

private theorem zero_distance_entropy_eq {α : Type*} [Fintype α] (p q : PMF α)
    (hTV : PMF.totalVariation p q = 0) : entropy p = entropy q := by
  have hbound := abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log p q
  simp only [hTV, Real.binEntropy_zero, zero_mul, add_zero] at hbound
  exact sub_eq_zero.mp (abs_eq_zero.mp (le_antisymm hbound (abs_nonneg _)))

private theorem singleton_law_pure (p : PMF Unit) : p = PMF.pure () := by
  obtain ⟨a, ha⟩ := p.support_nonempty
  apply (PMF.eq_pure_iff_support_eq_singleton p ()).2
  exact Set.eq_singleton_iff_unique_mem.mpr
    ⟨(Subsingleton.elim a ()) ▸ ha, fun x _ => Subsingleton.elim x ()⟩

private theorem singleton_bound (p q : PMF Unit) :
    PMF.totalVariation p q = 0 ∧ entropy p = 0 ∧ entropy q = 0 ∧
      |entropy p - entropy q| ≤ 0 := by
  have hp := singleton_law_pure p
  have hq := singleton_law_pure q
  have hTV : PMF.totalVariation p q = 0 := by
    rw [hp, hq, PMF.totalVariation_self]
  refine ⟨hTV, ?_, ?_, ?_⟩
  · rw [hp, entropy_pure]
  · rw [hq, entropy_pure]
  · simpa only [hTV, Real.binEntropy_zero, zero_mul, add_zero] using
      abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log p q

private theorem empty_law_impossible {α : Type*} [IsEmpty α] :
    ¬ Nonempty (PMF α) := by
  rintro ⟨p⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

private theorem distinct_pure_distance :
    PMF.totalVariation (PMF.pure false) (PMF.pure true) = 1 := by
  norm_num [PMF.totalVariation, Fintype.sum_bool, PMF.pure_apply]

private theorem distinct_pure_entropy_gap :
    |entropy (PMF.pure false) - entropy (PMF.pure true)| = 0 := by
  simp only [entropy_pure, sub_self, abs_zero]

private theorem distinct_pure_raw_rhs :
    Real.binEntropy (PMF.totalVariation (PMF.pure false) (PMF.pure true)) +
      PMF.totalVariation (PMF.pure false) (PMF.pure true) *
        Real.log ((Fintype.card Bool - 1 : Nat) : Real) = 0 := by
  rw [distinct_pure_distance]
  norm_num

private theorem distinct_pure_bound :
    |entropy (PMF.pure false) - entropy (PMF.pure true)| ≤ 0 := by
  have hbound := abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log
    (PMF.pure false) (PMF.pure true)
  rw [distinct_pure_raw_rhs] at hbound
  exact hbound

private theorem binary_pure_uniform_distance :
    PMF.totalVariation (PMF.pure false) (PMF.uniformOfFintype Bool) = 1 / 2 := by
  norm_num [PMF.totalVariation, Fintype.sum_bool, PMF.pure_apply,
    PMF.uniformOfFintype_apply]

private theorem binary_pure_uniform_entropy_gap :
    |entropy (PMF.pure false) - entropy (PMF.uniformOfFintype Bool)| =
      Real.log 2 := by
  rw [entropy_pure, entropy_uniformOfFintype]
  norm_num [abs_of_nonneg (Real.log_nonneg (by norm_num : (1 : Real) ≤ 2))]

private theorem binary_pure_uniform_bound :
    |entropy (PMF.pure false) - entropy (PMF.uniformOfFintype Bool)| ≤
      Real.log 2 := by
  have hbound := abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log
    (PMF.pure false) (PMF.uniformOfFintype Bool)
  simpa [binary_pure_uniform_distance, one_div] using hbound

private theorem ternary_masses (a : Fin 3) :
    PMF.pure (0 : Fin 3) a = (if a = 0 then 1 else 0) ∧
      PMF.uniformOfFintype (Fin 3) a = (1 / 3 : ℝ≥0∞) := by
  constructor
  · by_cases ha : a = 0 <;> simp [PMF.pure_apply, ha]
  · norm_num [PMF.uniformOfFintype_apply]

private theorem ternary_zero_masses :
    PMF.pure (0 : Fin 3) 1 = 0 ∧ PMF.pure (0 : Fin 3) 2 = 0 := by
  norm_num [PMF.pure_apply, show (2 : Fin 3) ≠ 0 by decide]

private theorem ternary_pure_uniform_distance :
    PMF.totalVariation (PMF.pure (0 : Fin 3)) (PMF.uniformOfFintype (Fin 3)) =
      2 / 3 := by
  norm_num [PMF.totalVariation, Fin.sum_univ_three, PMF.pure_apply,
    PMF.uniformOfFintype_apply, show (2 : Fin 3) ≠ 0 by decide]

private theorem ternary_pure_uniform_entropy_gap :
    |entropy (PMF.pure (0 : Fin 3)) - entropy (PMF.uniformOfFintype (Fin 3))| =
      Real.log 3 := by
  rw [entropy_pure, entropy_uniformOfFintype]
  norm_num [abs_of_nonneg (Real.log_nonneg (by norm_num : (1 : Real) ≤ 3))]

private theorem ternary_threshold_value :
    Real.binEntropy (2 / 3 : Real) + (2 / 3 : Real) * Real.log 2 = Real.log 3 := by
  rw [Real.binEntropy, show 1 - (2 / 3 : Real) = 1 / 3 by norm_num]
  rw [Real.log_inv, Real.log_inv,
    Real.log_div (by norm_num : (2 : Real) ≠ 0) (by norm_num : (3 : Real) ≠ 0),
    Real.log_div (by norm_num : (1 : Real) ≠ 0) (by norm_num : (3 : Real) ≠ 0),
    Real.log_one]
  ring

private theorem ternary_pure_uniform_bounds_both_orders :
    |entropy (PMF.pure (0 : Fin 3)) - entropy (PMF.uniformOfFintype (Fin 3))| ≤
        Real.log 3 ∧
      |entropy (PMF.uniformOfFintype (Fin 3)) - entropy (PMF.pure (0 : Fin 3))| ≤
        Real.log 3 := by
  have hforward := abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log
    (PMF.pure (0 : Fin 3)) (PMF.uniformOfFintype (Fin 3))
  have hreverse := abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log
    (PMF.uniformOfFintype (Fin 3)) (PMF.pure (0 : Fin 3))
  rw [ternary_pure_uniform_distance] at hforward
  rw [PMF.totalVariation_comm, ternary_pure_uniform_distance] at hreverse
  norm_num only [Fintype.card_fin] at hforward hreverse
  rw [ternary_threshold_value] at hforward hreverse
  exact ⟨hforward, hreverse⟩

private theorem continuity_bound_small_card (m : Nat) (hm : m ≤ 1)
    (epsilon : Real) : entropyContinuityBound m epsilon = 0 := by
  simp [entropyContinuityBound, hm]

private theorem continuity_bound_zero (m : Nat) : entropyContinuityBound m 0 = 0 := by
  by_cases hm : m ≤ 1
  · exact continuity_bound_small_card m hm 0
  · have hmreal : (1 : Real) < m := by exact_mod_cast (lt_of_not_ge hm)
    have hdiv : (1 : Real) / m ≤ 1 :=
      (div_le_one (by linarith : (0 : Real) < m)).mpr hmreal.le
    have hthreshold : (0 : Real) ≤ 1 - 1 / m := by linarith
    rw [entropyContinuityBound, if_neg hm, if_pos hthreshold]
    simp only [Real.binEntropy_zero, zero_mul, add_zero]

private theorem continuity_bound_ge_one (m : Nat) (hm : 1 ≤ m)
    {epsilon : Real} (hepsilon : 1 ≤ epsilon) :
    entropyContinuityBound m epsilon = Real.log (m : Real) := by
  by_cases hsmall : m ≤ 1
  · have hcard : m = 1 := Nat.le_antisymm hsmall hm
    subst m
    simp [entropyContinuityBound]
  · have hmreal : (1 : Real) < m := by exact_mod_cast (lt_of_not_ge hsmall)
    have hdiv : (0 : Real) < 1 / m := one_div_pos.mpr (by linarith)
    have hthreshold : ¬epsilon ≤ 1 - 1 / (m : Real) := by linarith
    rw [entropyContinuityBound, if_neg hsmall, if_neg hthreshold]

private theorem continuity_bound_range (m : Nat) (hm : 1 ≤ m)
    {epsilon : Real} (hepsilon : 0 ≤ epsilon) :
    0 ≤ entropyContinuityBound m epsilon ∧
      entropyContinuityBound m epsilon ≤ Real.log (m : Real) := by
  constructor
  · have hmono := entropyContinuityBound_mono m
      (show (0 : Real) ∈ Set.Ici (0 : Real) by simp only [Set.mem_Ici, le_refl])
      hepsilon hepsilon
    simpa only [continuity_bound_zero] using hmono
  · by_cases hle : epsilon ≤ 1
    · have hmono := entropyContinuityBound_mono m hepsilon
        (show (1 : Real) ∈ Set.Ici (0 : Real) by norm_num) hle
      simpa only [continuity_bound_ge_one m hm (le_refl 1)] using hmono
    · exact (continuity_bound_ge_one m hm (le_of_lt (lt_of_not_ge hle))).le

private theorem degenerate_modulus_values (epsilon : Real) :
    entropyContinuityBound 0 epsilon = 0 ∧ entropyContinuityBound 1 epsilon = 0 := by
  constructor <;> apply continuity_bound_small_card <;> norm_num

private theorem binary_entropy_half_value :
    Real.binEntropy (1 / 2 : Real) = Real.log 2 := by
  simpa only [one_div] using Real.binEntropy_two_inv

private theorem binary_modulus_values :
    entropyContinuityBound 2 (1 / 2) = Real.log 2 ∧
      entropyContinuityBound 2 1 = Real.log 2 ∧
      entropyContinuityBound 2 2 = Real.log 2 := by
  norm_num [entropyContinuityBound]
  exact binary_entropy_half_value

private theorem ternary_modulus_threshold :
    entropyContinuityBound 3 (2 / 3) =
        Real.binEntropy (2 / 3 : Real) + (2 / 3 : Real) * Real.log 2 ∧
      entropyContinuityBound 3 (2 / 3) = Real.log 3 := by
  have hraw : entropyContinuityBound 3 (2 / 3) =
      Real.binEntropy (2 / 3 : Real) + (2 / 3 : Real) * Real.log 2 := by
    norm_num [entropyContinuityBound]
  exact ⟨hraw, hraw.trans ternary_threshold_value⟩

private theorem ternary_crossing_values :
    (1 / 2 : Real) < 1 - 1 / 3 ∧ (1 - 1 / 3 : Real) < 3 / 4 ∧
      entropyContinuityBound 3 (1 / 2) = (3 / 2 : Real) * Real.log 2 ∧
      entropyContinuityBound 3 (3 / 4) = Real.log 3 := by
  norm_num [entropyContinuityBound]
  rw [binary_entropy_half_value]
  ring

private theorem zero_budget_bound {α : Type*} [Fintype α] (p q : PMF α)
    (hTV : PMF.totalVariation p q = 0) : |entropy p - entropy q| ≤ 0 := by
  have hbound := abs_entropy_sub_le_entropyContinuityBound p q (le_of_eq hTV)
  simpa only [continuity_bound_zero] using hbound

private theorem singleton_budget_bound (p q : PMF Unit) {epsilon : Real}
    (hTV : PMF.totalVariation p q ≤ epsilon) : |entropy p - entropy q| ≤ 0 := by
  have hbound := abs_entropy_sub_le_entropyContinuityBound p q hTV
  simpa [entropyContinuityBound] using hbound

private theorem binary_pure_uniform_budget_bounds :
    |entropy (PMF.pure false) - entropy (PMF.uniformOfFintype Bool)| ≤
        entropyContinuityBound 2 (1 / 2) ∧
      |entropy (PMF.pure false) - entropy (PMF.uniformOfFintype Bool)| ≤
        entropyContinuityBound 2 1 ∧
      |entropy (PMF.pure false) - entropy (PMF.uniformOfFintype Bool)| ≤
        entropyContinuityBound 2 2 := by
  have hbudget (epsilon : Real) (hepsilon : (1 / 2 : Real) ≤ epsilon) :=
    abs_entropy_sub_le_entropyContinuityBound
      (PMF.pure false) (PMF.uniformOfFintype Bool)
      (binary_pure_uniform_distance.le.trans hepsilon)
  simpa only [Fintype.card_bool] using
    And.intro (hbudget (1 / 2) (le_refl _))
      (And.intro (hbudget 1 (by norm_num)) (hbudget 2 (by norm_num)))

private theorem ternary_pure_uniform_budget_bound :
    |entropy (PMF.pure (0 : Fin 3)) - entropy (PMF.uniformOfFintype (Fin 3))| ≤
      Real.log 3 := by
  have hbound := abs_entropy_sub_le_entropyContinuityBound
    (PMF.pure (0 : Fin 3)) (PMF.uniformOfFintype (Fin 3))
    ternary_pure_uniform_distance.le
  simpa only [Fintype.card_fin, ternary_modulus_threshold.2] using hbound

private theorem binary_upper_estimate_counterexample :
    PMF.totalVariation (PMF.pure false) (PMF.uniformOfFintype Bool) ≤ 1 ∧
      ¬(|entropy (PMF.pure false) - entropy (PMF.uniformOfFintype Bool)| ≤
        Real.binEntropy 1 + (1 : Real) *
          Real.log ((Fintype.card Bool - 1 : Nat) : Real)) := by
  constructor
  · rw [binary_pure_uniform_distance]
    norm_num
  · rw [binary_pure_uniform_entropy_gap]
    norm_num
    exact Real.log_pos (by norm_num)

-- Later joint-law consumers can reuse this public-API composition with their
-- actual marginal laws; no construction from that later step is needed here.
private theorem entropy_budget_weaken {α : Type*} [Fintype α] (p q : PMF α)
    {epsilon eta : Real} (hTV : PMF.totalVariation p q ≤ epsilon)
    (hle : epsilon ≤ eta) :
    |entropy p - entropy q| ≤ entropyContinuityBound (Fintype.card α) eta := by
  have hepsilon : 0 ≤ epsilon := (PMF.totalVariation_nonneg p q).trans hTV
  have heta : 0 ≤ eta := hepsilon.trans hle
  exact (abs_entropy_sub_le_entropyContinuityBound p q hTV).trans
    (entropyContinuityBound_mono (Fintype.card α) hepsilon heta hle)

private theorem ternary_budget_weakening (p q : PMF (Fin 3))
    (hTV : PMF.totalVariation p q ≤ 1 / 2) :
    |entropy p - entropy q| ≤ Real.log 3 := by
  have hbound := entropy_budget_weaken p q hTV (by norm_num : (1 / 2 : Real) ≤ 3 / 4)
  simpa only [Fintype.card_fin, ternary_crossing_values.2.2.2] using hbound

private def mergeAtoms (a : Fin 3) : Bool := decide (a = 0)

private theorem mergeAtoms_noninjective_nonconstant :
    ¬Function.Injective mergeAtoms ∧ mergeAtoms 0 ≠ mergeAtoms 1 := by
  constructor
  · intro h
    have heq : (1 : Fin 3) = 2 := h (by decide)
    exact (by decide : (1 : Fin 3) ≠ 2) heq
  · decide

private theorem merged_uniform_masses (b : Bool) :
    ((PMF.uniformOfFintype (Fin 3)).map mergeAtoms) b =
      if b then (1 / 3 : ℝ≥0∞) else 2 / 3 := by
  cases b <;>
    norm_num [PMF.map_apply, tsum_fintype, Fin.sum_univ_three,
      PMF.uniformOfFintype_apply, mergeAtoms,
      show (2 : Fin 3) ≠ 0 by decide]
  rw [← one_div, ← ENNReal.add_div]
  norm_num

private theorem merged_pure_uniform_distance :
    PMF.totalVariation ((PMF.pure (0 : Fin 3)).map mergeAtoms)
      ((PMF.uniformOfFintype (Fin 3)).map mergeAtoms) = 2 / 3 := by
  rw [PMF.pure_map]
  change PMF.totalVariation (PMF.pure true)
    ((PMF.uniformOfFintype (Fin 3)).map mergeAtoms) = 2 / 3
  simp only [PMF.totalVariation, Fintype.sum_bool, merged_uniform_masses]
  norm_num [PMF.pure_apply]

private theorem merged_entropy_gap :
    |entropy ((PMF.pure (0 : Fin 3)).map mergeAtoms) -
        entropy ((PMF.uniformOfFintype (Fin 3)).map mergeAtoms)| =
      Real.binEntropy (1 / 3) := by
  rw [PMF.pure_map, entropy_pure, entropy_bool, merged_uniform_masses]
  have hnonneg := Real.binEntropy_nonneg
    (by norm_num : (0 : Real) ≤ 1 / 3) (by norm_num : (1 / 3 : Real) ≤ 1)
  norm_num [abs_of_nonneg hnonneg]

private theorem merged_entropy_budget :
    PMF.totalVariation ((PMF.pure (0 : Fin 3)).map mergeAtoms)
        ((PMF.uniformOfFintype (Fin 3)).map mergeAtoms) = 2 / 3 ∧
      0 < |entropy ((PMF.pure (0 : Fin 3)).map mergeAtoms) -
        entropy ((PMF.uniformOfFintype (Fin 3)).map mergeAtoms)| ∧
      |entropy ((PMF.pure (0 : Fin 3)).map mergeAtoms) -
        entropy ((PMF.uniformOfFintype (Fin 3)).map mergeAtoms)| ≤ Real.log 2 := by
  refine ⟨merged_pure_uniform_distance, ?_, ?_⟩
  · rw [merged_entropy_gap]
    exact Real.binEntropy_pos (by norm_num) (by norm_num)
  · have hTV : PMF.totalVariation ((PMF.pure (0 : Fin 3)).map mergeAtoms)
        ((PMF.uniformOfFintype (Fin 3)).map mergeAtoms) ≤ 2 / 3 :=
      (PMF.totalVariation_map_le (PMF.pure (0 : Fin 3))
        (PMF.uniformOfFintype (Fin 3)) mergeAtoms).trans ternary_pure_uniform_distance.le
    have hbound := abs_entropy_sub_le_entropyContinuityBound
      ((PMF.pure (0 : Fin 3)).map mergeAtoms)
      ((PMF.uniformOfFintype (Fin 3)).map mergeAtoms) hTV
    have houtput : entropyContinuityBound 2 (2 / 3) = Real.log 2 := by
      norm_num [entropyContinuityBound]
    simpa only [Fintype.card_bool, houtput] using hbound

private theorem joint_approximation
    {α : Type*} {β : Type*} [Fintype α] [Fintype β] (p q : PMF (α × β))
    {epsilon : Real} (hTV : PMF.totalVariation p q ≤ epsilon) :
    |entropy p - entropy q| ≤
        entropyContinuityBound (Fintype.card α * Fintype.card β) epsilon ∧
      |condEntropy p - condEntropy q| ≤
        entropyContinuityBound (Fintype.card α * Fintype.card β) epsilon +
          entropyContinuityBound (Fintype.card β) epsilon ∧
      |mutualInfo p - mutualInfo q| ≤
        entropyContinuityBound (Fintype.card α) epsilon +
          entropyContinuityBound (Fintype.card β) epsilon +
            entropyContinuityBound (Fintype.card α * Fintype.card β) epsilon := by
  refine ⟨?_, abs_condEntropy_sub_le_entropyContinuityBound p q hTV,
    abs_mutualInfo_sub_le_entropyContinuityBound p q hTV⟩
  simpa only [Fintype.card_prod] using abs_entropy_sub_le_entropyContinuityBound p q hTV

private def bitToTernary : Bool → Fin 3
  | false => 0
  | true => 1

private theorem bitToTernary_injective : Function.Injective bitToTernary := by
  intro a b h
  cases a <;> cases b <;> simp_all [bitToTernary]

private noncomputable def fairBit : PMF Bool := PMF.uniformOfFintype Bool

private noncomputable def sparseTernary : PMF (Fin 3) := fairBit.map bitToTernary

private noncomputable def diagonalJoint : PMF (Bool × Fin 3) :=
  fairBit.map fun b => (b, bitToTernary b)

private noncomputable def independentJoint : PMF (Bool × Fin 3) :=
  indepProd fairBit sparseTernary

private noncomputable def pointJoint : PMF (Bool × Fin 3) := PMF.pure (false, 0)

private theorem fairBit_mass (b : Bool) : fairBit b = (1 / 2 : ℝ≥0∞) := by
  norm_num [fairBit, PMF.uniformOfFintype_apply]

private theorem sparseTernary_mass (b : Fin 3) :
    sparseTernary b = if b = 2 then 0 else (1 / 2 : ℝ≥0∞) := by
  fin_cases b <;>
    norm_num [sparseTernary, PMF.map_apply, tsum_fintype, Fintype.sum_bool,
      fairBit_mass, bitToTernary, Fin.ext_iff]

private theorem diagonalJoint_mass (a : Bool) (b : Fin 3) :
    diagonalJoint (a, b) =
      if b = bitToTernary a then (1 / 2 : ℝ≥0∞) else 0 := by
  cases a <;> fin_cases b <;>
    norm_num [diagonalJoint, PMF.map_apply, tsum_fintype, Fintype.sum_bool,
      fairBit_mass, bitToTernary, show (2 : Fin 3) ≠ 0 by decide,
      show (2 : Fin 3) ≠ 1 by decide]

private theorem independentJoint_mass (a : Bool) (b : Fin 3) :
    independentJoint (a, b) = if b = 2 then 0 else (1 / 4 : ℝ≥0∞) := by
  simp only [independentJoint, indepProd_apply, fairBit_mass, sparseTernary_mass]
  split_ifs <;> norm_num
  rw [← ENNReal.mul_inv (by norm_num) (by norm_num)]
  norm_num

private theorem pointJoint_mass (a : Bool) (b : Fin 3) :
    pointJoint (a, b) = if a = false ∧ b = 0 then 1 else 0 := by
  simp only [pointJoint, PMF.pure_apply, Prod.mk.injEq]

private theorem diagonalJoint_marginals :
    fstMarginal diagonalJoint = fairBit ∧ sndMarginal diagonalJoint = sparseTernary := by
  constructor
  · rw [diagonalJoint, fstMarginal_map]
    change fairBit.map id = fairBit
    exact PMF.map_id fairBit
  · exact sndMarginal_map fairBit (fun b => (b, bitToTernary b))

private theorem independentJoint_marginals :
    fstMarginal independentJoint = fairBit ∧
      sndMarginal independentJoint = sparseTernary := by
  exact ⟨fstMarginal_indepProd fairBit sparseTernary,
    sndMarginal_indepProd fairBit sparseTernary⟩

private theorem pointJoint_marginals :
    fstMarginal pointJoint = PMF.pure false ∧
      sndMarginal pointJoint = PMF.pure (0 : Fin 3) := by
  constructor <;> exact PMF.pure_map _ _

private theorem sparse_null_fiber (a : Bool) :
    diagonalJoint (a, 2) = 0 ∧ independentJoint (a, 2) = 0 ∧ pointJoint (a, 2) = 0 := by
  cases a <;>
    norm_num [diagonalJoint_mass, independentJoint_mass, pointJoint_mass,
      bitToTernary, show (2 : Fin 3) ≠ 0 by decide, show (2 : Fin 3) ≠ 1 by decide]

private theorem sparse_null_marginals :
    sndMarginal diagonalJoint 2 = 0 ∧ sndMarginal independentJoint 2 = 0 ∧
      sndMarginal pointJoint 2 = 0 := by
  rw [diagonalJoint_marginals.2, independentJoint_marginals.2, pointJoint_marginals.2]
  norm_num [sparseTernary_mass, PMF.pure_apply, show (2 : Fin 3) ≠ 0 by decide]

private theorem fairBit_entropy : entropy fairBit = Real.log 2 := by
  simpa only [fairBit, Fintype.card_bool, Nat.cast_ofNat] using
    entropy_uniformOfFintype (alpha := Bool)

private theorem sparseTernary_entropy : entropy sparseTernary = Real.log 2 := by
  exact (entropy_map_injective fairBit bitToTernary_injective).trans fairBit_entropy

private theorem diagonalJoint_entropy : entropy diagonalJoint = Real.log 2 := by
  have hinj : Function.Injective (fun b : Bool => (b, bitToTernary b)) :=
    fun _ _ h => congrArg Prod.fst h
  exact (entropy_map_injective fairBit hinj).trans fairBit_entropy

private theorem independentJoint_entropy : entropy independentJoint = 2 * Real.log 2 := by
  have hlog4 : Real.log 4 = 2 * Real.log 2 := by
    simpa only [show (2 : Real) ^ 2 = 4 by norm_num, Nat.cast_ofNat] using
      Real.log_pow (2 : Real) 2
  norm_num [entropy_eq_sum, Fintype.sum_prod_type, Fintype.sum_bool,
    Fin.sum_univ_three, independentJoint_mass, Fin.ext_iff,
    Real.negMulLog, Real.log_div, hlog4]
  ring

private theorem sparse_information_values :
    condEntropy diagonalJoint = 0 ∧ mutualInfo diagonalJoint = Real.log 2 ∧
      condEntropy independentJoint = Real.log 2 ∧ mutualInfo independentJoint = 0 ∧
      entropy pointJoint = 0 ∧ condEntropy pointJoint = 0 ∧ mutualInfo pointJoint = 0 := by
  have hpoint : entropy pointJoint = 0 := entropy_pure (false, (0 : Fin 3))
  simp only [condEntropy_eq, mutualInfo_eq, diagonalJoint_marginals.1,
    diagonalJoint_marginals.2, independentJoint_marginals.1,
    independentJoint_marginals.2, pointJoint_marginals.1, pointJoint_marginals.2,
    diagonalJoint_entropy, independentJoint_entropy, sparseTernary_entropy,
    fairBit_entropy, hpoint, entropy_pure]
  ring_nf
  simp

private theorem diagonal_independent_distances :
    PMF.totalVariation diagonalJoint independentJoint = 1 / 2 ∧
      fstMarginal diagonalJoint = fstMarginal independentJoint ∧
      sndMarginal diagonalJoint = sndMarginal independentJoint := by
  refine ⟨?_, diagonalJoint_marginals.1.trans independentJoint_marginals.1.symm,
    diagonalJoint_marginals.2.trans independentJoint_marginals.2.symm⟩
  norm_num [PMF.totalVariation, Fintype.sum_prod_type, Fintype.sum_bool,
    Fin.sum_univ_three, diagonalJoint_mass, independentJoint_mass,
    bitToTernary, Fin.ext_iff]

private theorem point_independent_distances :
    PMF.totalVariation pointJoint independentJoint = 3 / 4 ∧
      PMF.totalVariation (fstMarginal pointJoint) (fstMarginal independentJoint) = 1 / 2 ∧
      PMF.totalVariation (sndMarginal pointJoint) (sndMarginal independentJoint) = 1 / 2 := by
  refine ⟨?_, ?_, ?_⟩
  · norm_num [PMF.totalVariation, Fintype.sum_prod_type, Fintype.sum_bool,
      Fin.sum_univ_three, pointJoint_mass, independentJoint_mass,
      show (0 : Fin 3) ≠ 2 by decide, show (1 : Fin 3) ≠ 2 by decide,
      show (2 : Fin 3) ≠ 0 by decide]
  · rw [pointJoint_marginals.1, independentJoint_marginals.1]
    exact binary_pure_uniform_distance
  · rw [pointJoint_marginals.2, independentJoint_marginals.2]
    norm_num [PMF.totalVariation, Fin.sum_univ_three, sparseTernary_mass,
      PMF.pure_apply, show (0 : Fin 3) ≠ 2 by decide,
      show (1 : Fin 3) ≠ 2 by decide, show (2 : Fin 3) ≠ 0 by decide]

private theorem point_independent_strict_contractions :
    PMF.totalVariation (fstMarginal pointJoint) (fstMarginal independentJoint) <
        PMF.totalVariation pointJoint independentJoint ∧
      PMF.totalVariation (sndMarginal pointJoint) (sndMarginal independentJoint) <
        PMF.totalVariation pointJoint independentJoint := by
  rw [point_independent_distances.1, point_independent_distances.2.1,
    point_independent_distances.2.2]
  norm_num

private theorem diagonal_independent_gaps :
    |entropy diagonalJoint - entropy independentJoint| = Real.log 2 ∧
      |condEntropy diagonalJoint - condEntropy independentJoint| = Real.log 2 ∧
      |mutualInfo diagonalJoint - mutualInfo independentJoint| = Real.log 2 := by
  have hlog : 0 ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  rcases sparse_information_values with ⟨hDc, hDm, hIc, hIm, _⟩
  rw [diagonalJoint_entropy, independentJoint_entropy, hDc, hDm, hIc, hIm]
  have hsub : Real.log 2 - 2 * Real.log 2 = -Real.log 2 := by ring
  simp [hsub, abs_of_nonneg hlog]

private theorem point_independent_gaps :
    |entropy pointJoint - entropy independentJoint| = 2 * Real.log 2 ∧
      |entropy (fstMarginal pointJoint) - entropy (fstMarginal independentJoint)| =
        Real.log 2 ∧
      |entropy (sndMarginal pointJoint) - entropy (sndMarginal independentJoint)| =
        Real.log 2 ∧
      |condEntropy pointJoint - condEntropy independentJoint| = Real.log 2 ∧
      |mutualInfo pointJoint - mutualInfo independentJoint| = 0 := by
  have hlog : 0 ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  have htwolog : 0 ≤ 2 * Real.log 2 := mul_nonneg (by norm_num) hlog
  rcases sparse_information_values with ⟨_, _, hIc, hIm, hPh, hPc, hPm⟩
  rw [hPh, independentJoint_entropy, pointJoint_marginals.1,
    independentJoint_marginals.1, pointJoint_marginals.2,
    independentJoint_marginals.2, entropy_pure, entropy_pure,
    fairBit_entropy, sparseTernary_entropy, hPc, hIc, hPm, hIm]
  simp [abs_of_nonneg hlog, abs_of_nonneg htwolog]

private theorem mixed_modulus_branches :
    entropyContinuityBound 2 (3 / 4) = Real.log 2 ∧
      entropyContinuityBound 3 (3 / 4) = Real.log 3 ∧
      entropyContinuityBound 6 (3 / 4) =
        Real.binEntropy (3 / 4) + (3 / 4 : Real) * Real.log 5 ∧
      (1 - 1 / 2 : Real) < 3 / 4 ∧ (1 - 1 / 3 : Real) < 3 / 4 ∧
      (3 / 4 : Real) < 1 - 1 / 6 := by
  norm_num [entropyContinuityBound]

private theorem sparse_joint_bounds (p q : PMF (Bool × Fin 3))
    (hTV : PMF.totalVariation p q ≤ 3 / 4) :
    |entropy p - entropy q| ≤ Real.binEntropy (3 / 4) + (3 / 4 : Real) * Real.log 5 ∧
      |condEntropy p - condEntropy q| ≤
        Real.binEntropy (3 / 4) + (3 / 4 : Real) * Real.log 5 + Real.log 3 ∧
      |mutualInfo p - mutualInfo q| ≤ Real.log 2 + Real.log 3 +
        (Real.binEntropy (3 / 4) + (3 / 4 : Real) * Real.log 5) := by
  have h := joint_approximation p q hTV
  simpa only [Fintype.card_bool, Fintype.card_fin, show 2 * 3 = 6 by decide,
    mixed_modulus_branches.1, mixed_modulus_branches.2.1,
    mixed_modulus_branches.2.2.1] using h

private theorem diagonal_independent_budget_bounds :
    Real.log 2 ≤ Real.binEntropy (3 / 4) + (3 / 4 : Real) * Real.log 5 ∧
      Real.log 2 ≤ Real.binEntropy (3 / 4) + (3 / 4 : Real) * Real.log 5 + Real.log 3 ∧
      Real.log 2 ≤ Real.log 2 + Real.log 3 +
        (Real.binEntropy (3 / 4) + (3 / 4 : Real) * Real.log 5) := by
  have hTV : PMF.totalVariation diagonalJoint independentJoint ≤ 3 / 4 := by
    rw [diagonal_independent_distances.1]
    norm_num
  simpa only [diagonal_independent_gaps.1, diagonal_independent_gaps.2.1,
    diagonal_independent_gaps.2.2] using sparse_joint_bounds diagonalJoint independentJoint hTV

private theorem point_independent_budget_bounds :
    2 * Real.log 2 ≤ Real.binEntropy (3 / 4) + (3 / 4 : Real) * Real.log 5 ∧
      Real.log 2 ≤ Real.binEntropy (3 / 4) + (3 / 4 : Real) * Real.log 5 + Real.log 3 ∧
      0 ≤ Real.log 2 + Real.log 3 +
        (Real.binEntropy (3 / 4) + (3 / 4 : Real) * Real.log 5) := by
  simpa only [point_independent_gaps.1, point_independent_gaps.2.2.2.1,
    point_independent_gaps.2.2.2.2] using
      sparse_joint_bounds pointJoint independentJoint point_independent_distances.1.le

private theorem second_marginal_budget_weakening :
    |entropy (sndMarginal pointJoint) - entropy (sndMarginal independentJoint)| ≤
      Real.log 3 := by
  have h := entropy_budget_weaken (sndMarginal pointJoint) (sndMarginal independentJoint)
    point_independent_distances.2.2.le (by norm_num : (1 / 2 : Real) ≤ 3 / 4)
  simpa only [Fintype.card_fin, mixed_modulus_branches.2.1] using h

private theorem zero_distance_information_eq
    {α : Type*} {β : Type*} [Fintype α] [Fintype β]
    (p q : PMF (α × β)) (hTV : PMF.totalVariation p q = 0) :
    condEntropy p = condEntropy q ∧ mutualInfo p = mutualInfo q := by
  have hcond := abs_condEntropy_sub_le_entropyContinuityBound p q hTV.le
  have hmi := abs_mutualInfo_sub_le_entropyContinuityBound p q hTV.le
  simp only [continuity_bound_zero, add_zero] at hcond hmi
  exact ⟨sub_eq_zero.mp (abs_eq_zero.mp (le_antisymm hcond (abs_nonneg _))),
    sub_eq_zero.mp (abs_eq_zero.mp (le_antisymm hmi (abs_nonneg _)))⟩

-- A singleton first coordinate has no conditional entropy or MI.
private theorem first_singleton_information
    {β : Type*} [Fintype β] (p : PMF (Unit × β)) :
    condEntropy p = 0 ∧ mutualInfo p = 0 := by
  have hinj : Function.Injective (Prod.snd : Unit × β → β) := by
    intro a b hab
    exact Prod.ext (Subsingleton.elim _ _) hab
  have hprojection : entropy (sndMarginal p) = entropy p :=
    entropy_map_injective p hinj
  have hunit : entropy (fstMarginal p) = 0 := by
    rw [singleton_law_pure (fstMarginal p), entropy_pure]
  constructor
  · rw [condEntropy_eq, hprojection, sub_self]
  · rw [mutualInfo_eq, hunit, hprojection, zero_add, sub_self]

private theorem first_singleton_information_bounds
    {β : Type*} [Fintype β] (p q : PMF (Unit × β)) {epsilon : Real}
    (hTV : PMF.totalVariation p q ≤ epsilon) :
    |condEntropy p - condEntropy q| ≤
        entropyContinuityBound (Fintype.card β) epsilon +
          entropyContinuityBound (Fintype.card β) epsilon ∧
      |mutualInfo p - mutualInfo q| ≤
        entropyContinuityBound (Fintype.card β) epsilon +
          entropyContinuityBound (Fintype.card β) epsilon := by
  have hone : entropyContinuityBound 1 epsilon = 0 :=
    continuity_bound_small_card 1 (by norm_num) epsilon
  constructor
  · simpa only [Fintype.card_unit, one_mul] using
      abs_condEntropy_sub_le_entropyContinuityBound p q hTV
  · simpa only [Fintype.card_unit, one_mul, hone, zero_add] using
      abs_mutualInfo_sub_le_entropyContinuityBound p q hTV

-- A singleton conditioning coordinate reduces conditional entropy to the
-- ordinary first-marginal entropy, while MI is zero.
private theorem second_singleton_information
    {α : Type*} [Fintype α] (p : PMF (α × Unit)) :
    condEntropy p = entropy (fstMarginal p) ∧ mutualInfo p = 0 := by
  have hinj : Function.Injective (Prod.fst : α × Unit → α) := by
    intro a b hab
    exact Prod.ext hab (Subsingleton.elim _ _)
  have hprojection : entropy (fstMarginal p) = entropy p :=
    entropy_map_injective p hinj
  have hunit : entropy (sndMarginal p) = 0 := by
    rw [singleton_law_pure (sndMarginal p), entropy_pure]
  constructor
  · rw [condEntropy_eq, hunit, sub_zero, hprojection]
  · rw [mutualInfo_eq, hunit, hprojection, add_zero, sub_self]

private theorem second_singleton_information_bounds
    {α : Type*} [Fintype α] (p q : PMF (α × Unit)) {epsilon : Real}
    (hTV : PMF.totalVariation p q ≤ epsilon) :
    |condEntropy p - condEntropy q| ≤
        entropyContinuityBound (Fintype.card α) epsilon ∧
      |mutualInfo p - mutualInfo q| ≤
        entropyContinuityBound (Fintype.card α) epsilon +
          entropyContinuityBound (Fintype.card α) epsilon := by
  have hone : entropyContinuityBound 1 epsilon = 0 :=
    continuity_bound_small_card 1 (by norm_num) epsilon
  constructor
  · simpa only [Fintype.card_unit, mul_one, hone, add_zero] using
      abs_condEntropy_sub_le_entropyContinuityBound p q hTV
  · simpa only [Fintype.card_unit, mul_one, hone, add_zero] using
      abs_mutualInfo_sub_le_entropyContinuityBound p q hTV

private theorem empty_first_coordinate_impossible
    {α : Type*} {β : Type*} [IsEmpty α] : ¬Nonempty (PMF (α × β)) := by
  rintro ⟨p⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a.1

private theorem empty_second_coordinate_impossible
    {α : Type*} {β : Type*} [IsEmpty β] : ¬Nonempty (PMF (α × β)) := by
  rintro ⟨p⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a.2

-- Swapping the law changes the conditioning alphabet from β to α.
private theorem swapped_conditional_entropy_bound
    {α : Type*} {β : Type*} [Fintype α] [Fintype β]
    (p q : PMF (α × β)) {epsilon : Real}
    (hTV : PMF.totalVariation p q ≤ epsilon) :
    |condEntropy (p.map Prod.swap) - condEntropy (q.map Prod.swap)| ≤
        entropyContinuityBound (Fintype.card α * Fintype.card β) epsilon +
          entropyContinuityBound (Fintype.card α) epsilon ∧
      |(entropy p - entropy (fstMarginal p)) -
          (entropy q - entropy (fstMarginal q))| ≤
        entropyContinuityBound (Fintype.card α * Fintype.card β) epsilon +
          entropyContinuityBound (Fintype.card α) epsilon := by
  have hswap : PMF.totalVariation (p.map Prod.swap) (q.map Prod.swap) ≤ epsilon :=
    (PMF.totalVariation_map_le p q Prod.swap).trans hTV
  have hbound :
      |condEntropy (p.map Prod.swap) - condEntropy (q.map Prod.swap)| ≤
        entropyContinuityBound (Fintype.card α * Fintype.card β) epsilon +
          entropyContinuityBound (Fintype.card α) epsilon := by
    simpa only [Nat.mul_comm] using
      abs_condEntropy_sub_le_entropyContinuityBound
        (p.map Prod.swap) (q.map Prod.swap) hswap
  refine ⟨hbound, ?_⟩
  simpa only [condEntropy_eq, entropy_map_swap, sndMarginal_map_swap] using hbound

-- The two source spaces are arbitrary and need not even be the same type.
-- Only the common finite output alphabets determine the three constants.
private theorem arbitrary_source_random_variable_approximation
    {Ω : Type*} {Ψ : Type*} {α : Type*} {β : Type*}
    [Fintype α] [Fintype β]
    (p : PMF Ω) (q : PMF Ψ) (X : Ω → α) (Y : Ω → β)
    (X' : Ψ → α) (Y' : Ψ → β) {epsilon : Real}
    (hTV : PMF.totalVariation (p.map fun w => (X w, Y w))
      (q.map fun w => (X' w, Y' w)) ≤ epsilon) :
    |jointEntropyOf p X Y - jointEntropyOf q X' Y'| ≤
        entropyContinuityBound (Fintype.card α * Fintype.card β) epsilon ∧
      |condEntropyOf p X Y - condEntropyOf q X' Y'| ≤
        entropyContinuityBound (Fintype.card α * Fintype.card β) epsilon +
          entropyContinuityBound (Fintype.card β) epsilon ∧
      |mutualInfoOf p X Y - mutualInfoOf q X' Y'| ≤
        entropyContinuityBound (Fintype.card α) epsilon +
          entropyContinuityBound (Fintype.card β) epsilon +
          entropyContinuityBound (Fintype.card α * Fintype.card β) epsilon := by
  refine ⟨?_, ?_, ?_⟩
  · simpa only [jointEntropyOf, entropyOf, Fintype.card_prod] using
      abs_entropy_sub_le_entropyContinuityBound
        (p.map fun w => (X w, Y w)) (q.map fun w => (X' w, Y' w)) hTV
  · exact abs_condEntropy_sub_le_entropyContinuityBound
      (p.map fun w => (X w, Y w)) (q.map fun w => (X' w, Y' w)) hTV
  · exact abs_mutualInfo_sub_le_entropyContinuityBound
      (p.map fun w => (X w, Y w)) (q.map fun w => (X' w, Y' w)) hTV

end LeanInfoTheory.Examples.Continuity
