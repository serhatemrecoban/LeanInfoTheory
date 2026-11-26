/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.FiniteChannel
import LeanInfoTheory.Probability.TotalVariation
import LeanInfoTheory.Shannon.SemanticBridge.FiniteSums
import LeanInfoTheory.Shannon.SemanticBridge.Product

/-!
# Channel information density

The input-output joint law is supported on the product of its marginal
supports. Its log likelihood ratio against the independent product therefore
has a positive numerator and denominator at every supported pair.
The strict threshold event compares masses on the whole product. Under the
joint law, its complement has the probability of the closed density sublevel.
Under the independent law on finite alphabets, its probability is at most
the exponential of the negative threshold.
-/

namespace LeanInfoTheory.Shannon

universe u v

open scoped BigOperators

/-- Information density in nats for an input-output pair. On joint support this is the
logarithm of the joint mass divided by the independent-pair mass, and it can be negative.
At zero joint mass, real division and `Real.log` give the conventional value zero. -/
noncomputable def infoDensity {A : Type u} {B : Type v}
    (p : PMF A) (W : A → PMF B) (z : A × B) : ℝ :=
  Real.log (((PMF.channelJoint p W) z).toReal / ((indepProd p (p.bind W)) z).toReal)

/-- Every supported channel pair has positive mass under the independent product of
the input and output laws. -/
theorem support_channelJoint_subset_indepProd {A : Type u} {B : Type v}
    (p : PMF A) (W : A → PMF B) :
    (PMF.channelJoint p W).support ⊆ (indepProd p (p.bind W)).support := by
  rintro ⟨a, b⟩ hab
  obtain ⟨ha, hb⟩ := (PMF.mem_support_channelJoint_iff p W a b).1 hab
  rw [support_indepProd]
  exact ⟨ha, (PMF.mem_support_bind_iff p W b).2 ⟨a, ha, hb⟩⟩

/-- The mean information density under the joint law is mutual information in nats. -/
theorem sum_mul_infoDensity_eq_mutualInfo {A : Type u} {B : Type v}
    [Fintype A] [Fintype B] (p : PMF A) (W : A → PMF B) :
    (∑ z : A × B, ((PMF.channelJoint p W) z).toReal * infoDensity p W z) =
      mutualInfo (PMF.channelJoint p W) := by
  refine Eq.trans ?_ (mutualInfo_eq_sum_log_ratio (PMF.channelJoint p W)).symm
  apply Finset.sum_congr rfl
  rintro ⟨a, b⟩ _
  simp only [infoDensity, indepProd_apply, ENNReal.toReal_mul, fstMarginal,
    sndMarginal, PMF.channelJoint_map_fst, PMF.channelJoint_map_snd]

/-- The strict information-density threshold event, defined by real atom masses
on the whole product. Every zero-joint atom fails, at every real threshold. -/
def infoDensityThresholdEvent {A : Type u} {B : Type v}
    (p : PMF A) (W : A → PMF B) (t : ℝ) : Set (A × B) :=
  {z | Real.exp t * ((indepProd p (p.bind W)) z).toReal <
    ((PMF.channelJoint p W) z).toReal}

/-- On joint support, the mass-comparison event is the strict log-density threshold. -/
theorem mem_infoDensityThresholdEvent_iff_of_mem_support {A : Type u} {B : Type v}
    (p : PMF A) (W : A → PMF B) (t : ℝ) {z : A × B}
    (hz : z ∈ (PMF.channelJoint p W).support) :
    z ∈ infoDensityThresholdEvent p W t ↔ t < infoDensity p W z := by
  have hj := ENNReal.toReal_pos ((PMF.mem_support_iff _ _).1 hz)
    ((PMF.channelJoint p W).apply_ne_top z)
  have hq := ENNReal.toReal_pos
    ((PMF.mem_support_iff _ _).1 (support_channelJoint_subset_indepProd p W hz))
    ((indepProd p (p.bind W)).apply_ne_top z)
  exact (lt_div_iff₀ hq).symm.trans (Real.lt_log_iff_exp_lt (div_pos hj hq)).symm

/-- Under the joint law, the complementary miss includes equality at the threshold.
The two sets need only agree on joint support. -/
theorem channelJoint_infoDensityThresholdEvent_compl_eq {A : Type u} {B : Type v}
    (p : PMF A) (W : A → PMF B) (t : ℝ) :
    ((PMF.channelJoint p W).toOuterMeasure (infoDensityThresholdEvent p W t)ᶜ).toReal =
      ((PMF.channelJoint p W).toOuterMeasure {z | infoDensity p W z ≤ t}).toReal := by
  apply congrArg ENNReal.toReal
  apply (PMF.channelJoint p W).toOuterMeasure_apply_eq_of_inter_support_eq
  ext z
  by_cases hz : z ∈ (PMF.channelJoint p W).support
  · simp [hz, mem_infoDensityThresholdEvent_iff_of_mem_support p W t hz]
  · simp [hz]

/-- Under the independent input-output law, the strict event has probability at most
`exp (-t)` for every real threshold. Only internal enumeration requires a `Fintype`. -/
theorem indepProd_infoDensityThresholdEvent_le {A : Type u} {B : Type v}
    [Finite A] [Finite B] (p : PMF A) (W : A → PMF B) (t : ℝ) :
    ((indepProd p (p.bind W)).toOuterMeasure (infoDensityThresholdEvent p W t)).toReal ≤
      Real.exp (-t) := by
  classical
  let _ := Fintype.ofFinite (A × B)
  let J := PMF.channelJoint p W
  let Q := indepProd p (p.bind W)
  rw [Q.toOuterMeasure_toReal_eq_sum]
  calc
    _ ≤ ∑ z : A × B, Real.exp (-t) * (J z).toReal := by
      apply Finset.sum_le_sum
      intro z _
      by_cases hz : z ∈ infoDensityThresholdEvent p W t
      · rw [Set.indicator_of_mem hz]
        change Real.exp t * (Q z).toReal < (J z).toReal at hz
        simpa only [← mul_assoc, ← Real.exp_add, neg_add_cancel, Real.exp_zero, one_mul]
          using mul_le_mul_of_nonneg_left hz.le (Real.exp_pos (-t)).le
      · rw [Set.indicator_of_notMem hz]
        exact mul_nonneg (Real.exp_pos (-t)).le ENNReal.toReal_nonneg
    _ = _ := by rw [← Finset.mul_sum, J.sum_toReal, mul_one]

end LeanInfoTheory.Shannon
