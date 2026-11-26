/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.InformationDensity
import LeanInfoTheory.Probability.BinaryTesting
import Mathlib.Probability.Distributions.Uniform

/-!
# Channel information density callers

These focused callers check support, signed values, the joint mean and strict
thresholds. Joint support suffices for the log threshold. Zero-joint pairs fail
the global mass comparison, and the joint miss includes threshold equality.
The finite independent-law bound combines with that miss identity on arbitrary
word laws and block channels, including zero length and zero competitors.
Permanent noiseless and input-independent fixtures exercise the C25 event-test
API with the independent law as null and the joint law as alternative.
-/

namespace LeanInfoTheory.Examples.InformationDensity

open LeanInfoTheory.Shannon

universe u v
variable {A : Type u} {B : Type v} (p : PMF A) (W : A → PMF B)

example :
    (PMF.channelJoint p W).support ⊆ (indepProd p (p.bind W)).support :=
  support_channelJoint_subset_indepProd p W

private theorem productMass_pos {z : A × B}
    (h : 0 < ((PMF.channelJoint p W) z).toReal) :
    0 < ((indepProd p (p.bind W)) z).toReal := by
  have hj : z ∈ (PMF.channelJoint p W).support :=
    (PMF.mem_support_iff _ _).2 (ENNReal.toReal_pos_iff.mp h).1.ne'
  have hq := support_channelJoint_subset_indepProd p W hj
  exact ENNReal.toReal_pos ((PMF.mem_support_iff _ _).1 hq)
    ((indepProd p (p.bind W)).apply_ne_top z)

example {z : A × B} (_hz : z ∈ (PMF.channelJoint p W).support) :
    infoDensity p W z =
      Real.log (((PMF.channelJoint p W) z).toReal /
        ((indepProd p (p.bind W)) z).toReal) := rfl

example {z : A × B} (hz : z ∈ (PMF.channelJoint p W).support)
    (hratio : ((PMF.channelJoint p W) z).toReal /
      ((indepProd p (p.bind W)) z).toReal < 1) :
    infoDensity p W z < 0 := by
  have hj : 0 < ((PMF.channelJoint p W) z).toReal :=
    ENNReal.toReal_pos ((PMF.mem_support_iff _ _).1 hz)
      ((PMF.channelJoint p W).apply_ne_top z)
  exact Real.log_neg (div_pos hj (productMass_pos p W hj)) hratio

example {z : A × B} (hz : (PMF.channelJoint p W) z = 0) :
    infoDensity p W z = 0 := by
  simp [infoDensity, hz]

open scoped BigOperators

example [Fintype A] [Fintype B] (c : ℝ) :
    (∑ z : A × B, ((PMF.channelJoint p W) z).toReal * infoDensity p W z) + c =
      mutualInfo (PMF.channelJoint p W) + c := by
  rw [sum_mul_infoDensity_eq_mutualInfo p W]

example (t : ℝ) (z : A × B) :
    z ∈ infoDensityThresholdEvent p W t ↔
      z ∈ (PMF.channelJoint p W).support ∧ t < infoDensity p W z := by
  constructor
  · intro he
    have hj : 0 < ((PMF.channelJoint p W) z).toReal :=
      lt_of_le_of_lt (mul_nonneg (Real.exp_pos t).le ENNReal.toReal_nonneg) he
    have hz : z ∈ (PMF.channelJoint p W).support :=
      (PMF.mem_support_iff _ _).2 (ENNReal.toReal_pos_iff.mp hj).1.ne'
    exact ⟨hz, (mem_infoDensityThresholdEvent_iff_of_mem_support p W t hz).1 he⟩
  · rintro ⟨hz, ht⟩
    exact (mem_infoDensityThresholdEvent_iff_of_mem_support p W t hz).2 ht

-- This covers both Q-only and common-null atoms, including negative thresholds.
example (t : ℝ) {z : A × B} (hz : (PMF.channelJoint p W) z = 0) :
    z ∉ infoDensityThresholdEvent p W t := by
  change ¬ Real.exp t * ((indepProd p (p.bind W)) z).toReal <
    ((PMF.channelJoint p W) z).toReal
  rw [hz, ENNReal.toReal_zero]
  exact not_lt_of_ge (mul_nonneg (Real.exp_pos t).le ENNReal.toReal_nonneg)

example {X : Type u} {Y : Type v} (n : ℕ) (r : ℝ)
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y)) :
    ((PMF.channelJoint q K).toOuterMeasure
      (infoDensityThresholdEvent q K ((n : ℝ) * r))ᶜ).toReal =
      ((PMF.channelJoint q K).toOuterMeasure
        {z | infoDensity q K z ≤ (n : ℝ) * r}).toReal :=
  channelJoint_infoDensityThresholdEvent_compl_eq q K ((n : ℝ) * r)

example {X : Type u} {Y : Type v} [Finite X] [Finite Y] (n k : ℕ) (r : ℝ)
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y)) :
    let t := (n : ℝ) * r
    let event := infoDensityThresholdEvent q K t
    let J := PMF.channelJoint q K
    let Q := indepProd q (q.bind K)
    (J.toOuterMeasure eventᶜ).toReal + (k : ℝ) * (Q.toOuterMeasure event).toReal ≤
      (J.toOuterMeasure {z | infoDensity q K z ≤ t}).toReal +
        (k : ℝ) * Real.exp (-t) := by
  dsimp only
  rw [channelJoint_infoDensityThresholdEvent_compl_eq]
  exact add_le_add le_rfl
    (mul_le_mul_of_nonneg_left (indepProd_infoDensityThresholdEvent_le q K ((n : ℝ) * r))
      (Nat.cast_nonneg k))

/-! ### Uniform noiseless Boolean channel -/

namespace Noiseless

open PMF.BinaryTest

private noncomputable abbrev fair : PMF Bool := PMF.uniformOfFintype Bool
private noncomputable abbrev channel : Bool → PMF Bool := PMF.pure
private noncomputable abbrev joint : PMF (Bool × Bool) := PMF.channelJoint fair channel
private noncomputable abbrev independent : PMF (Bool × Bool) := indepProd fair (fair.bind channel)
private def diagonal : Set (Bool × Bool) := {z | z.1 = z.2}

private theorem joint_mass (a b : Bool) :
    (joint (a, b)).toReal = if a = b then 1 / 2 else 0 := by
  cases a <;> cases b <;>
    norm_num [joint, channel, PMF.channelJoint_apply, PMF.pure_apply, fair,
      PMF.uniformOfFintype_apply]

private theorem independent_mass (a b : Bool) : (independent (a, b)).toReal = 1 / 4 := by
  rw [independent, channel, PMF.bind_pure, indepProd_apply, ENNReal.toReal_mul]
  norm_num [fair, PMF.uniformOfFintype_apply]

private theorem density (a b : Bool) :
    infoDensity fair channel (a, b) = if a = b then Real.log 2 else 0 := by
  change Real.log ((joint (a, b)).toReal / (independent (a, b)).toReal) = _
  rw [joint_mass, independent_mass]
  by_cases h : a = b <;> norm_num [h]

private theorem event_eq_diagonal {t : ℝ} (ht : Real.exp t < 2) :
    infoDensityThresholdEvent fair channel t = diagonal := by
  ext ⟨a, b⟩
  change Real.exp t * (independent (a, b)).toReal < (joint (a, b)).toReal ↔ a = b
  rw [independent_mass, joint_mass]
  by_cases h : a = b
  · rw [if_pos h]
    exact iff_of_true (by linarith) h
  · rw [if_neg h]
    exact iff_of_false (not_lt_of_ge (mul_nonneg (Real.exp_pos t).le (by norm_num))) h

private theorem negative_threshold_event : infoDensityThresholdEvent fair channel (-1) = diagonal :=
  event_eq_diagonal ((Real.exp_lt_one_iff.mpr (by norm_num)).trans (by norm_num))

example {a b : Bool} (h : a ≠ b) :
    -1 < infoDensity fair channel (a, b) ∧
      (a, b) ∉ infoDensityThresholdEvent fair channel (-1) := by
  simp [density, h, negative_threshold_event, diagonal]

private noncomputable abbrev threshold : ℝ := Real.log (3 / 2)

private theorem test_probabilities :
    size (ofEvent (infoDensityThresholdEvent fair channel threshold)) independent = 1 / 2 ∧
    power (ofEvent (infoDensityThresholdEvent fair channel threshold)) joint = 1 ∧
    typeIIError (ofEvent (infoDensityThresholdEvent fair channel threshold)) joint = 0 := by
  classical
  have hdiag : infoDensityThresholdEvent fair channel threshold = diagonal :=
    event_eq_diagonal (by rw [threshold, Real.exp_log (by norm_num : 0 < (3 / 2 : ℝ))]; norm_num)
  simp only [size, power, rejectProb_ofEvent, typeIIError_ofEvent, hdiag,
    PMF.toOuterMeasure_toReal_eq_sum, Fintype.sum_prod_type, Fintype.sum_bool,
    Set.indicator_apply, independent_mass, joint_mass]
  norm_num [diagonal]

example :
    Real.exp (-threshold) = 2 / 3 ∧
    (independent.toOuterMeasure (infoDensityThresholdEvent fair channel threshold)).toReal ≤ 2 / 3 ∧
    2 / 3 < (joint.toOuterMeasure (infoDensityThresholdEvent fair channel threshold)).toReal := by
  have hbound : Real.exp (-threshold) = 2 / 3 := by
    rw [Real.exp_neg, threshold, Real.exp_log (by norm_num : 0 < (3 / 2 : ℝ))]
    norm_num
  refine ⟨hbound, ?_, ?_⟩
  · simpa only [hbound] using indepProd_infoDensityThresholdEvent_le fair channel threshold
  · have hpower := test_probabilities.2.1
    rw [power, rejectProb_ofEvent] at hpower
    rw [hpower]
    norm_num

end Noiseless

/-! ### Input-independent channel, including common-null atoms -/

section InputIndependent

open PMF.BinaryTest

variable (r : PMF B)

private theorem inputIndependentLaws :
    PMF.channelJoint p (fun _ => r) = indepProd p r ∧
      indepProd p (p.bind fun _ => r) = indepProd p r :=
  ⟨rfl, congrArg (indepProd p) (PMF.bind_const p r)⟩

-- On support the common atom mass divides by itself. At a common-null atom
-- real division and the total logarithm also give zero.
private theorem inputIndependentDensity (z : A × B) :
    infoDensity p (fun _ => r) z = 0 := by
  obtain ⟨hJ, hQ⟩ := inputIndependentLaws p r
  rw [infoDensity, hJ, hQ]
  by_cases h : ((indepProd p r) z).toReal = 0 <;> simp [h]

private theorem inputIndependentEvent :
    infoDensityThresholdEvent p (fun _ => r) 0 = ∅ := by
  obtain ⟨hJ, hQ⟩ := inputIndependentLaws p r
  ext z
  change Real.exp 0 * ((indepProd p (p.bind fun _ => r)) z).toReal <
    ((PMF.channelJoint p (fun _ => r)) z).toReal ↔ False
  rw [hJ, hQ, Real.exp_zero, one_mul]
  simp

private theorem inputIndependentTest [Fintype A] [Fintype B] :
    let f := ofEvent (infoDensityThresholdEvent p (fun _ => r) 0)
    let J := PMF.channelJoint p (fun _ => r)
    let Q := indepProd p (p.bind fun _ => r)
    size f Q = 0 ∧ power f J = 0 ∧ typeIIError f J = 1 := by
  dsimp only
  rw [inputIndependentEvent]
  simp only [size, power, rejectProb_ofEvent, typeIIError_ofEvent, Set.compl_empty,
    PMF.toOuterMeasure_toReal_eq_sum, Set.indicator_empty, Set.indicator_univ,
    Finset.sum_const_zero, PMF.sum_toReal, and_self]

-- Output true is impossible under both laws. The test still uses Q for size
-- and J for power and miss on this sparse channel.
example :
    let p := PMF.uniformOfFintype Bool
    let r := PMF.pure false
    let W := fun _ : Bool => r
    let J := PMF.channelJoint p W
    let Q := indepProd p (p.bind W)
    let E := infoDensityThresholdEvent p W 0
    let f := ofEvent E
    J (true, true) = 0 ∧ Q (true, true) = 0 ∧ (true, false) ∈ J.support ∧
      infoDensity p W (true, false) = 0 ∧
      E = ∅ ∧ size f Q = 0 ∧ power f J = 0 ∧ typeIIError f J = 1 := by
  dsimp only
  obtain ⟨hJ, hQ⟩ := inputIndependentLaws (PMF.uniformOfFintype Bool) (PMF.pure false)
  refine ⟨?_, ?_, ?_, inputIndependentDensity _ _ _, inputIndependentEvent _ _,
    inputIndependentTest _ _⟩
  · rw [hJ]
    simp [PMF.pure_apply]
  · rw [hQ]
    simp [PMF.pure_apply]
  · rw [hJ, support_indepProd]
    exact ⟨PMF.mem_support_uniformOfFintype _, by simp⟩

end InputIndependent

end LeanInfoTheory.Examples.InformationDensity
