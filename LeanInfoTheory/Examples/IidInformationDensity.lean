/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.IidInformationDensity
import Mathlib.Probability.Distributions.Uniform

/-!
# Iid information-density callers

The focused import exposes coordinate additivity on the actual word joint,
with input first and output second. Every empty word pair is supported, and
its information density is the empty sum, hence zero. The later callers consume
the positive-length concentration and the all-natural-index strict-event miss.
The empty-word miss is one for every real threshold parameter.
Private Boolean identity-channel fixtures then check supported block density,
the strict boundary at mutual information, a jointly impossible pair with positive
independent-law mass, and a positive tie mass below mutual information with
a vanishing miss limit.
-/

namespace LeanInfoTheory.Examples.IidInformationDensity

open LeanInfoTheory.Shannon
open scoped BigOperators

universe u v

variable {A : Type u} {B : Type v} [Fintype A] [Fintype B]
  (p : PMF A) (W : A → PMF B)

example (n : ℕ) (x : Fin n → A) (y : Fin n → B)
    (hxy : (x, y) ∈
      (PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).support) :
    infoDensity (PMF.iid p n) (PMF.memorylessChannel W n) (x, y) =
      ∑ i : Fin n, infoDensity p W (x i, y i) :=
  infoDensity_iid_of_mem_support p W n hxy

example (z : (Fin 0 → A) × (Fin 0 → B)) :
    infoDensity (PMF.iid p 0) (PMF.memorylessChannel W 0) z = 0 := by
  obtain ⟨w, hw⟩ :=
    (PMF.channelJoint (PMF.iid p 0) (PMF.memorylessChannel W 0)).support_nonempty
  have hz : z ∈ (PMF.channelJoint (PMF.iid p 0) (PMF.memorylessChannel W 0)).support :=
    (Subsingleton.elim w z) ▸ hw
  simpa using infoDensity_iid_of_mem_support p W 0 hz

/- The probability uses the actual joint on the pair of length-(k+1) words.
The caller exposes the positive real denominator and the closed deviation. -/
example {ε : ℝ} (hε : 0 < ε) :
    (∀ k : ℕ, 0 < (k : ℝ) + 1) ∧
      Filter.Tendsto (fun k : ℕ =>
        ((PMF.channelJoint (PMF.iid p (k + 1))
          (PMF.memorylessChannel W (k + 1))).toOuterMeasure
          {z : (Fin (k + 1) → A) × (Fin (k + 1) → B) |
            ε ≤ |infoDensity (PMF.iid p (k + 1))
              (PMF.memorylessChannel W (k + 1)) z / ((k : ℝ) + 1) -
                mutualInfo (PMF.channelJoint p W)|}).toReal)
        Filter.atTop (nhds 0) := by
  constructor
  · intro k
    positivity
  · simpa only [Nat.cast_add, Nat.cast_one] using
      tendsto_infoDensity_iid_deviation p W hε

/- C31 composes this literal all-natural-index miss with its second vanishing term. -/
example {s : ℝ} (hs : s < mutualInfo (PMF.channelJoint p W)) (b : ℕ → ℝ)
    (hb : Filter.Tendsto b Filter.atTop (nhds 0)) :
    Filter.Tendsto (fun n : ℕ =>
      ((PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).toOuterMeasure
        (infoDensityThresholdEvent (PMF.iid p n) (PMF.memorylessChannel W n)
          ((n : ℝ) * s))ᶜ).toReal + b n) Filter.atTop (nhds 0) := by
  simpa only [add_zero] using (tendsto_prob_infoDensityThresholdEvent_iid_compl p W hs).add hb

example (s : ℝ) :
    ((PMF.channelJoint (PMF.iid p 0) (PMF.memorylessChannel W 0)).toOuterMeasure
      (infoDensityThresholdEvent (PMF.iid p 0) (PMF.memorylessChannel W 0)
        ((0 : ℝ) * s))ᶜ).toReal = 1 := by
  rw [ENNReal.toReal_eq_one_iff, PMF.toOuterMeasure_apply_eq_one_iff]
  rintro ⟨x, y⟩ _
  change ¬ Real.exp (0 * s) * ((indepProd _ _) (x, y)).toReal <
    ((PMF.channelJoint _ _) (x, y)).toReal
  simp [indepProd_apply, PMF.channelJoint_apply, PMF.iid, PMF.finiteProduct_apply,
    PMF.memorylessChannel, PMF.productChannel_apply]

/-! ## Sparse Boolean identity-channel fixtures -/

private noncomputable abbrev identityChannel : Bool → PMF Bool := PMF.pure

private theorem identityWordRow (n : ℕ) (x : Fin n → Bool) :
    PMF.memorylessChannel identityChannel n x = PMF.pure x :=
  PMF.finiteProduct_pure x

/-! ### Uniform bits, the MI boundary and an impossible word pair -/

namespace UniformBits

open LeanInfoTheory.Shannon
open scoped BigOperators

private noncomputable abbrev fair := PMF.uniformOfFintype Bool
private noncomputable abbrev input (n : ℕ) := PMF.iid fair n
private noncomputable abbrev row (n : ℕ) := PMF.memorylessChannel identityChannel n
private noncomputable abbrev joint (n : ℕ) := PMF.channelJoint (input n) (row n)

private theorem row_eq_pure (n : ℕ) : row n = PMF.pure := by
  funext x
  exact identityWordRow n x

private theorem support_iff {n : ℕ} (x y : Fin n → Bool) :
    (x, y) ∈ (joint n).support ↔ x = y := by
  rw [PMF.mem_support_channelJoint_iff, row_eq_pure, PMF.mem_support_pure_iff]
  have hx : x ∈ (input n).support := by
    apply (PMF.mem_support_finiteProduct_iff (fun _ : Fin n => fair) x).2
    intro i
    simp [fair]
  exact ⟨fun h => h.2.symm, fun h => ⟨hx, h.symm⟩⟩

private theorem letter_density (a b : Bool) :
    infoDensity fair identityChannel (a, b) = if a = b then Real.log 2 else 0 := by
  cases a <;> cases b <;>
    norm_num [infoDensity, identityChannel, fair, PMF.bind_pure, indepProd_apply,
      PMF.channelJoint_apply, PMF.pure_apply, PMF.uniformOfFintype_apply]

example : mutualInfo (PMF.channelJoint fair identityChannel) = Real.log 2 := by
  rw [← sum_mul_infoDensity_eq_mutualInfo]
  norm_num [Fintype.sum_prod_type, Fintype.sum_bool, letter_density, PMF.channelJoint_apply,
    identityChannel, fair, PMF.uniformOfFintype_apply, PMF.pure_apply]
  ring

private theorem supported_density (n : ℕ) {z : (Fin n → Bool) × (Fin n → Bool)}
    (hz : z ∈ (joint n).support) : infoDensity (input n) (row n) z = (n : ℝ) * Real.log 2 := by
  obtain ⟨x, y⟩ := z
  obtain rfl := (support_iff x y).1 hz
  rw [infoDensity_iid_of_mem_support fair identityChannel n hz]
  simp [letter_density]

example (n : ℕ) (hn : 0 < n) (s : ℝ) (hs : s < Real.log 2) :
    ((joint n).toOuterMeasure (infoDensityThresholdEvent (input n) (row n) ((n : ℝ) * s))ᶜ).toReal =
      0 := by
  apply (ENNReal.toReal_eq_zero_iff _).2
  left
  apply (PMF.toOuterMeasure_apply_eq_zero_iff _ _).2
  refine Set.disjoint_left.mpr fun z hz hmiss => hmiss ?_
  apply (mem_infoDensityThresholdEvent_iff_of_mem_support _ _ _ hz).2
  rw [supported_density n hz]
  exact mul_lt_mul_of_pos_left hs (by exact_mod_cast hn)

example (n : ℕ) :
    ((joint n).toOuterMeasure
      (infoDensityThresholdEvent (input n) (row n) ((n : ℝ) * Real.log 2))ᶜ).toReal = 1 := by
  rw [ENNReal.toReal_eq_one_iff, PMF.toOuterMeasure_apply_eq_one_iff]
  intro z hz hpass
  have hlt := (mem_infoDensityThresholdEvent_iff_of_mem_support _ _ _ hz).1 hpass
  rw [supported_density n hz] at hlt
  exact lt_irrefl _ hlt

private def word00 : Fin 2 → Bool := ![false, false]
private def word01 : Fin 2 → Bool := ![false, true]

example :
    joint 2 (word00, word01) = 0 ∧
    infoDensity (input 2) (row 2) (word00, word01) = 0 ∧
    (∑ i, infoDensity fair identityChannel (word00 i, word01 i)) = Real.log 2 ∧
    ((indepProd (input 2) ((input 2).bind (row 2))) (word00, word01)).toReal = 1 / 16 ∧
    (word00, word01) ∉ infoDensityThresholdEvent (input 2) (row 2) (-1) := by
  have hne : word00 ≠ word01 := fun h => Bool.false_ne_true (congrFun h (1 : Fin 2))
  have hzero : joint 2 (word00, word01) = 0 := by
    by_contra h
    exact hne ((support_iff word00 word01).1 h)
  have hQ : ((indepProd (input 2) ((input 2).bind (row 2))) (word00, word01)).toReal = 1 / 16 := by
    rw [row_eq_pure, PMF.bind_pure, indepProd_apply, ENNReal.toReal_mul]
    norm_num [input, PMF.iid, PMF.finiteProduct_apply, Fin.prod_univ_two, fair,
      PMF.uniformOfFintype_apply]
  refine ⟨hzero, ?_, ?_, hQ, ?_⟩
  · simp [infoDensity, show (PMF.channelJoint (input 2) (row 2)) (word00, word01) = 0 from hzero]
  · simp [Fin.sum_univ_two, letter_density, word00, word01]
  · change ¬ Real.exp (-1) * ((indepProd _ _) (word00, word01)).toReal <
      (joint 2 (word00, word01)).toReal
    rw [hzero, ENNReal.toReal_zero, hQ]
    exact not_lt_of_ge (mul_nonneg (Real.exp_pos _).le (by norm_num))

end UniformBits

/-! ### Biased bits and a positive tie mass below MI -/

namespace BiasedIdentity

open LeanInfoTheory.Shannon
open scoped BigOperators

private noncomputable def input : PMF Bool :=
  PMF.ofFintype (fun b => ENNReal.ofReal (if b then (1 / 4 : ℝ) else 3 / 4))
    (by
      rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
      norm_num)

private noncomputable abbrev s : ℝ := Real.log (4 / 3)

private theorem diagonal_density (a : Bool) :
    infoDensity input identityChannel (a, a) = if a then Real.log 4 else s := by
  cases a <;>
    norm_num [infoDensity, identityChannel, PMF.bind_pure, PMF.channelJoint_apply,
      indepProd_apply, ENNReal.toReal_mul, input, PMF.ofFintype_apply, s]

private theorem log_gap : s < Real.log 4 :=
  Real.log_lt_log (by norm_num) (by norm_num)

private theorem mutualInfo_gap :
    mutualInfo (PMF.channelJoint input identityChannel) - s = (Real.log 4 - s) / 4 := by
  rw [← sum_mul_infoDensity_eq_mutualInfo, Fintype.sum_prod_type]
  simp only [Fintype.sum_bool, PMF.channelJoint_apply, identityChannel, PMF.pure_apply,
    Bool.true_eq_false, Bool.false_eq_true, if_false, if_true, mul_zero, mul_one,
    ENNReal.toReal_zero, zero_mul, zero_add, add_zero, diagonal_density]
  norm_num [input, PMF.ofFintype_apply]
  ring

private theorem threshold_lt_mutualInfo :
    s < mutualInfo (PMF.channelJoint input identityChannel) := by
  have hg := log_gap
  linarith [mutualInfo_gap]

private abbrev Word := Fin 2 → Bool
private def commonWord : Word := fun _ => false
private noncomputable abbrev input₂ := PMF.iid input 2
private noncomputable abbrev channel₂ := PMF.memorylessChannel identityChannel 2
private noncomputable abbrev joint₂ := PMF.channelJoint input₂ channel₂

private theorem word_row (x : Word) : channel₂ x = PMF.pure x :=
  identityWordRow 2 x

private theorem common_iff (x : Word) :
    x = commonWord ↔ x 0 = false ∧ x 1 = false := by
  constructor
  · rintro rfl
    exact ⟨rfl, rfl⟩
  · rintro ⟨h0, h1⟩
    funext i
    fin_cases i <;> assumption

private theorem supported_density_cases {z : Word × Word} (hz : z ∈ joint₂.support) :
    (z = (commonWord, commonWord) ∧ infoDensity input₂ channel₂ z = 2 * s) ∨
      (z ≠ (commonWord, commonWord) ∧ 2 * s < infoDensity input₂ channel₂ z) := by
  obtain ⟨x, y⟩ := z
  have hy := ((PMF.mem_support_channelJoint_iff input₂ channel₂ x y).1 hz).2
  have hyx : y = x := by simpa [word_row] using hy
  subst y
  rw [infoDensity_iid_of_mem_support input identityChannel 2 hz, Fin.sum_univ_two]
  simp only [Prod.mk.injEq, and_self, common_iff, diagonal_density]
  have hg := log_gap
  cases h0 : x 0 <;> cases h1 : x 1 <;> simp [common_iff, h0, h1] <;> linarith

private theorem common_joint_mass :
    (joint₂ (commonWord, commonWord)).toReal = 9 / 16 := by
  rw [PMF.channelJoint_apply, word_row, PMF.pure_apply_self, mul_one]
  norm_num [input₂, PMF.iid, PMF.finiteProduct_apply, Fin.prod_univ_two, commonWord,
    ENNReal.toReal_mul, input, PMF.ofFintype_apply]

private theorem miss_probability :
    (joint₂.toOuterMeasure (infoDensityThresholdEvent input₂ channel₂ (2 * s))ᶜ).toReal =
      9 / 16 := by
  have hset : joint₂.toOuterMeasure (infoDensityThresholdEvent input₂ channel₂ (2 * s))ᶜ =
      joint₂.toOuterMeasure {(commonWord, commonWord)} := by
    apply joint₂.toOuterMeasure_apply_eq_of_inter_support_eq
    ext z
    by_cases hz : z ∈ joint₂.support
    · simp only [Set.mem_inter_iff, hz, and_true, Set.mem_compl_iff, Set.mem_singleton_iff,
        mem_infoDensityThresholdEvent_iff_of_mem_support input₂ channel₂ (2 * s) hz, not_lt]
      rcases supported_density_cases hz with ⟨heq, htie⟩ | ⟨hne, hlt⟩
      · exact iff_of_true htie.le heq
      · exact iff_of_false (not_le_of_gt hlt) hne
    · simp [hz]
  rw [hset, PMF.toOuterMeasure_apply_singleton, common_joint_mass]

private theorem open_sublevel_probability :
    (joint₂.toOuterMeasure {z | infoDensity input₂ channel₂ z < 2 * s}).toReal = 0 := by
  have hzero : joint₂.toOuterMeasure {z | infoDensity input₂ channel₂ z < 2 * s} = 0 := by
    rw [PMF.toOuterMeasure_apply_eq_zero_iff, Set.disjoint_left]
    intro z hz hlt
    rcases supported_density_cases hz with ⟨_, h⟩ | ⟨_, h⟩
    · exact (not_lt_of_ge h.ge) hlt
    · exact (not_lt_of_ge h.le) hlt
  rw [hzero, ENNReal.toReal_zero]

example :
    Filter.Tendsto (fun n : ℕ =>
      ((PMF.channelJoint (PMF.iid input n) (PMF.memorylessChannel identityChannel n)).toOuterMeasure
        (infoDensityThresholdEvent (PMF.iid input n) (PMF.memorylessChannel identityChannel n)
          ((n : ℝ) * s))ᶜ).toReal) Filter.atTop (nhds 0) :=
  tendsto_prob_infoDensityThresholdEvent_iid_compl input identityChannel threshold_lt_mutualInfo


/- The positive tie mass is supported; an open miss would lose all of it. -/
example :
    s < mutualInfo (PMF.channelJoint input identityChannel) ∧
      (commonWord, commonWord) ∈ joint₂.support ∧
      infoDensity input₂ channel₂ (commonWord, commonWord) = 2 * s ∧
      (joint₂.toOuterMeasure (infoDensityThresholdEvent input₂ channel₂ (2 * s))ᶜ).toReal =
        9 / 16 ∧
      (joint₂.toOuterMeasure {z | infoDensity input₂ channel₂ z < 2 * s}).toReal = 0 := by
  have hz : (commonWord, commonWord) ∈ joint₂.support := by
    change joint₂ (commonWord, commonWord) ≠ 0
    intro hzero
    have hm := common_joint_mass
    rw [hzero, ENNReal.toReal_zero] at hm
    norm_num at hm
  refine ⟨threshold_lt_mutualInfo, hz, ?_, miss_probability, open_sublevel_probability⟩
  rcases supported_density_cases hz with h | h
  · exact h.2
  · exact (h.1 rfl).elim
end BiasedIdentity

end LeanInfoTheory.Examples.IidInformationDensity
