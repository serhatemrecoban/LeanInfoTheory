/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.Entropy
import LeanInfoTheory.Shannon.SemanticBridge.FiniteProduct
import LeanInfoTheory.Shannon.TypicalSet
import Mathlib.Probability.Moments.Variance
import Mathlib.Analysis.SpecificLimits.Basic

/-!
# Finite-iid asymptotic equipartition

Self-information adds along supported iid words. The support hypothesis matters:
the existing zero-mass convention assigns zero information to impossible words.
Private finite-measure bridges identify the coordinate sum almost everywhere,
transport its mean and variance, and connect normalized deviation events to the
PMF's outer measure. Chebyshev's inequality then proves that the probability
of normalized block self-information deviating from entropy by at least any
positive width tends to zero. The supported strict weak typical set consequently
has probability tending to one. For positive blocklengths, its complement agrees
with the deviation event on support, which suffices for equality of probabilities.

Information is measured in nats. The supported identity includes length zero;
normalized mean and variance identities require positive length. No full-support
assumption or common infinite sample space is used.
-/

namespace LeanInfoTheory.Shannon

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

noncomputable section

universe u

/-- The self-information of a supported iid word is the sum of its coordinate
self-informations, in nats. This includes the empty word. Impossible words are
excluded because self-information is totalized to zero at zero mass. -/
theorem selfInfo_iid_of_mem_support {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) {x : Fin n → A} (hx : x ∈ (PMF.iid p n).support) :
    selfInfo (PMF.iid p n) x = ∑ i, selfInfo p (x i) := by
  classical
  have hx' := (PMF.mem_support_finiteProduct_iff (fun _ : Fin n => p) x).1 hx
  have hcoord (i : Fin n) : (p (x i)).toReal ≠ 0 :=
    ENNReal.toReal_ne_zero.mpr ⟨hx' i, p.apply_ne_top _⟩
  rw [selfInfo_of_toReal_ne_zero _ (ENNReal.toReal_ne_zero.mpr
    ⟨hx, (PMF.iid p n).apply_ne_top _⟩)]
  simp only [PMF.iid, PMF.finiteProduct_apply, ENNReal.toReal_prod]
  rw [Real.log_prod (fun i _ => hcoord i), ← Finset.sum_neg_distrib]
  exact Finset.sum_congr rfl fun i _ => (selfInfo_of_toReal_ne_zero p (hcoord i)).symm

section Moments

variable {A : Type u} [Fintype A] [MeasurableSpace A] [MeasurableSingletonClass A]

private theorem iid_selfInfo_ae (p : PMF A) (n : ℕ) :
    (fun x : Fin n → A => ∑ i, selfInfo p (x i)) =ᵐ[(PMF.iid p n).toMeasure]
      selfInfo (PMF.iid p n) := by
  have hs : ∀ᵐ x ∂(PMF.iid p n).toMeasure, x ∈ (PMF.iid p n).support := by
    rw [ae_iff]
    exact ((PMF.iid p n).toMeasure_apply_eq_zero_iff (.of_discrete)).2
      disjoint_compl_right
  filter_upwards [hs] with x hx
  exact (selfInfo_iid_of_mem_support p n hx).symm

private theorem iid_selfInfo_sum_integral (p : PMF A) (n : ℕ) :
    (∫ x : Fin n → A, ∑ i, selfInfo p (x i) ∂(PMF.iid p n).toMeasure) =
      (n : ℝ) * entropy p := by
  rw [integral_congr_ae (iid_selfInfo_ae p n), ← entropy_eq_integral_selfInfo, entropy_iid]

omit [MeasurableSingletonClass A] in
private theorem iid_coordinate_map (p : PMF A) (n : ℕ) (i : Fin n) :
    (PMF.iid p n).toMeasure.map (fun x => x i) = p.toMeasure := by
  rw [PMF.toMeasure_map _ _ (measurable_pi_apply i)]
  exact congrArg PMF.toMeasure (PMF.finiteProduct_map_eval (fun _ : Fin n => p) i)

private theorem iid_coordinate_integral (p : PMF A) (n : ℕ) (i : Fin n) :
    (∫ x : Fin n → A, selfInfo p (x i) ∂(PMF.iid p n).toMeasure) = entropy p := by
  rw [← integral_map (measurable_pi_apply i).aemeasurable
    (Measurable.of_discrete.aestronglyMeasurable), iid_coordinate_map,
    ← entropy_eq_integral_selfInfo]

private theorem selfInfo_variance (p : PMF A) :
    variance (selfInfo p) p.toMeasure =
      ∑ a, (p a).toReal * (selfInfo p a - entropy p) ^ 2 := by
  rw [variance_eq_integral Measurable.of_discrete.aemeasurable,
    ← entropy_eq_integral_selfInfo, PMF.integral_eq_sum]
  simp only [smul_eq_mul]

private theorem iid_coordinate_variance (p : PMF A) (n : ℕ) (i : Fin n) :
    variance (fun x : Fin n → A => selfInfo p (x i)) (PMF.iid p n).toMeasure =
      ∑ a, (p a).toReal * (selfInfo p a - entropy p) ^ 2 := by
  have h := variance_map (X := selfInfo p) (Y := fun x : Fin n → A => x i)
    (μ := (PMF.iid p n).toMeasure) Measurable.of_discrete.aemeasurable
    (measurable_pi_apply i).aemeasurable
  rw [iid_coordinate_map, selfInfo_variance] at h
  exact h.symm

private theorem iid_selfInfo_indepFun (p : PMF A) (n : ℕ) {i j : Fin n} (hij : i ≠ j) :
    IndepFun (fun x : Fin n → A => selfInfo p (x i))
      (fun x => selfInfo p (x j)) (PMF.iid p n).toMeasure := by
  have h := (isIndependentOf_iff_indepFun (PMF.iid p n)
    (fun x => x i) (fun x => x j) (measurable_pi_apply i) (measurable_pi_apply j)).1
      (isIndependentOf_finiteProduct_eval (fun _ : Fin n => p) hij)
  exact h.comp (Measurable.of_discrete : Measurable (selfInfo p))
    (Measurable.of_discrete : Measurable (selfInfo p))

private theorem iid_selfInfo_sum_variance (p : PMF A) (n : ℕ) :
    variance (fun x : Fin n → A => ∑ i, selfInfo p (x i)) (PMF.iid p n).toMeasure =
      (n : ℝ) * ∑ a, (p a).toReal * (selfInfo p a - entropy p) ^ 2 := by
  classical
  have h := IndepFun.variance_sum
    (X := fun i (x : Fin n → A) => selfInfo p (x i)) (s := Finset.univ)
    (μ := (PMF.iid p n).toMeasure)
    (fun _ _ => MemLp.of_discrete) (fun _ _ _ _ hij => iid_selfInfo_indepFun p n hij)
  have hfun : (∑ i : Fin n, fun x : Fin n → A => selfInfo p (x i)) =
      (fun x => ∑ i, selfInfo p (x i)) := by
    funext x
    simp only [Finset.sum_apply]
  rw [hfun] at h
  simpa only [iid_coordinate_variance, Finset.sum_const,
    Finset.card_univ, Fintype.card_fin, nsmul_eq_mul] using h

private theorem iid_normalized_memLp (p : PMF A) (n : ℕ) :
    MemLp (fun x : Fin n → A => (∑ i, selfInfo p (x i)) / (n : ℝ)) 2
      (PMF.iid p n).toMeasure := MemLp.of_discrete

private theorem iid_normalized_integral (p : PMF A) {n : ℕ} (hn : 0 < n) :
    (∫ x : Fin n → A, (∑ i, selfInfo p (x i)) / (n : ℝ) ∂(PMF.iid p n).toMeasure) =
      entropy p := by
  rw [integral_div, iid_selfInfo_sum_integral]
  have hn' : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.ne_of_gt hn)
  exact mul_div_cancel_left₀ _ hn'

private theorem iid_normalized_variance (p : PMF A) {n : ℕ} (hn : 0 < n) :
    variance (fun x : Fin n → A => (∑ i, selfInfo p (x i)) / (n : ℝ))
      (PMF.iid p n).toMeasure =
        (∑ a, (p a).toReal * (selfInfo p a - entropy p) ^ 2) / (n : ℝ) := by
  simp only [div_eq_mul_inv]
  rw [variance_mul_const, iid_selfInfo_sum_variance]
  have hn' : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.ne_of_gt hn)
  field_simp [hn']

private theorem iid_deviation_probability (p : PMF A) (n : ℕ) (ε : ℝ) :
    ((PMF.iid p n).toOuterMeasure
      {x | ε ≤ |selfInfo (PMF.iid p n) x / (n : ℝ) - entropy p|}).toReal =
    ((PMF.iid p n).toMeasure
      {x | ε ≤ |(∑ i, selfInfo p (x i)) / (n : ℝ) - entropy p|}).toReal := by
  rw [← PMF.toMeasure_apply_eq_toOuterMeasure]
  congr 1
  apply measure_congr
  apply Filter.Eventually.set_eq
  exact (iid_selfInfo_ae p n).mono fun x hx => by
    change (ε ≤ |selfInfo (PMF.iid p n) x / (n : ℝ) - entropy p|) ↔
      (ε ≤ |(∑ i, selfInfo p (x i)) / (n : ℝ) - entropy p|)
    rw [← hx]

private theorem iid_event_ne_top (p : PMF A) (n : ℕ) (E : Set (Fin n → A)) :
    (PMF.iid p n).toOuterMeasure E ≠ ⊤ ∧ (PMF.iid p n).toMeasure E ≠ ⊤ := by
  rw [← PMF.toMeasure_apply_eq_toOuterMeasure]
  exact ⟨measure_ne_top _ _, measure_ne_top _ _⟩

end Moments

/- The finite PMF interface needs no measurable-space arguments. This private
checkpoint chooses them locally and assembles the normalized inputs for the
subsequent concentration argument on the same iid law and observable. -/
private theorem iid_moment_checkpoint {A : Type u} [Fintype A]
    (p : PMF A) {n : ℕ} (hn : 0 < n) (ε : ℝ) :
    letI : MeasurableSpace A := ⊤
    let Z := fun x : Fin n → A => (∑ i, selfInfo p (x i)) / (n : ℝ)
    MemLp Z 2 (PMF.iid p n).toMeasure ∧
      (∫ x, Z x ∂(PMF.iid p n).toMeasure) = entropy p ∧
      variance Z (PMF.iid p n).toMeasure =
        (∑ a, (p a).toReal * (selfInfo p a - entropy p) ^ 2) / (n : ℝ) ∧
      ((PMF.iid p n).toOuterMeasure
        {x | ε ≤ |selfInfo (PMF.iid p n) x / (n : ℝ) - entropy p|}).toReal =
        ((PMF.iid p n).toMeasure {x | ε ≤ |Z x - entropy p|}).toReal ∧
      (PMF.iid p n).toOuterMeasure
        {x | ε ≤ |selfInfo (PMF.iid p n) x / (n : ℝ) - entropy p|} ≠ ⊤ ∧
      (PMF.iid p n).toMeasure {x | ε ≤ |Z x - entropy p|} ≠ ⊤ := by
  let : MeasurableSpace A := ⊤
  exact ⟨iid_normalized_memLp p n, iid_normalized_integral p hn,
    iid_normalized_variance p hn, iid_deviation_probability p n ε,
    (iid_event_ne_top p n _).1, (iid_event_ne_top p n _).2⟩

private theorem iid_deviation_le {A : Type u} [Fintype A]
    (p : PMF A) {n : ℕ} (hn : 0 < n) {ε : ℝ} (hε : 0 < ε) :
    ((PMF.iid p n).toOuterMeasure
      {x | ε ≤ |selfInfo (PMF.iid p n) x / (n : ℝ) - entropy p|}).toReal ≤
      (∑ a, (p a).toReal * (selfInfo p a - entropy p) ^ 2) / ((n : ℝ) * ε ^ 2) := by
  let : MeasurableSpace A := ⊤
  obtain ⟨hmem, hmean, hvar, hevent, _, hfinite⟩ := iid_moment_checkpoint p hn ε
  rw [hevent]
  have hbound := meas_ge_le_variance_div_sq hmem hε
  rw [hmean, hvar] at hbound
  have hv : 0 ≤ ∑ a, (p a).toReal * (selfInfo p a - entropy p) ^ 2 :=
    Finset.sum_nonneg fun a _ => mul_nonneg ENNReal.toReal_nonneg (sq_nonneg _)
  have hnonneg := div_nonneg (div_nonneg hv (Nat.cast_nonneg n)) (sq_nonneg ε)
  have hreal := (ENNReal.toReal_le_toReal hfinite ENNReal.ofReal_ne_top).2 hbound
  rw [ENNReal.toReal_ofReal hnonneg] at hreal
  simpa only [div_div] using hreal

/-- Finite-iid AEP in nats: for every positive width, the real probability that
normalized block self-information differs from entropy by at least that width
tends to zero. Each blocklength uses its own finite iid word law. Zero-mass
symbols are allowed; no measurable-space or full-support hypothesis is needed.
The total expression at length zero does not affect the limit. -/
theorem tendsto_selfInfo_iid_deviation {A : Type u} [Fintype A]
    (p : PMF A) {ε : ℝ} (hε : 0 < ε) :
    Filter.Tendsto (fun n : ℕ => ((PMF.iid p n).toOuterMeasure
      {x | ε ≤ |selfInfo (PMF.iid p n) x / (n : ℝ) - entropy p|}).toReal)
      Filter.atTop (nhds 0) := by
  have hlimit := tendsto_const_div_atTop_nhds_zero_nat
    ((∑ a, (p a).toReal * (selfInfo p a - entropy p) ^ 2) / ε ^ 2)
  apply squeeze_zero' (Filter.Eventually.of_forall fun _ => ENNReal.toReal_nonneg) _
    hlimit
  filter_upwards [Filter.eventually_gt_atTop (0 : ℕ)] with n hn
  simpa only [div_div, mul_comm (ε ^ 2)] using iid_deviation_le p hn hε

/- At positive blocklengths, the complement and deviation events agree on support.
Their ambient sets can differ at impossible words, whose outer measure is zero. -/
private theorem iid_weakTypicalSet_compl_probability {A : Type u} [Fintype A]
    (p : PMF A) {n : ℕ} (hn : 0 < n) (ε : ℝ) :
    ((PMF.iid p n).toOuterMeasure
      (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal =
    ((PMF.iid p n).toOuterMeasure
      {x | ε ≤ |selfInfo (PMF.iid p n) x / (n : ℝ) - entropy p|}).toReal := by
  apply congrArg ENNReal.toReal
  apply (PMF.iid p n).toOuterMeasure_apply_eq_of_inter_support_eq
  ext x
  by_cases hx : x ∈ (PMF.iid p n).support
  · simp [mem_weakTypicalSet, hn, hx]
  · simp [hx]

private theorem iid_weakTypicalSet_probability {A : Type u} [Fintype A]
    (p : PMF A) {n : ℕ} (hn : 0 < n) (ε : ℝ) :
    ((PMF.iid p n).toOuterMeasure
      (↑(weakTypicalSet p n ε) : Set (Fin n → A))).toReal =
      1 - ((PMF.iid p n).toOuterMeasure
        {x | ε ≤ |selfInfo (PMF.iid p n) x / (n : ℝ) - entropy p|}).toReal := by
  let : MeasurableSpace (Fin n → A) := ⊤
  have hsum := probReal_add_probReal_compl (μ := (PMF.iid p n).toMeasure)
    (s := (↑(weakTypicalSet p n ε) : Set (Fin n → A))) MeasurableSet.of_discrete
  simp only [Measure.real, PMF.toMeasure_apply_eq_toOuterMeasure] at hsum
  rw [iid_weakTypicalSet_compl_probability p hn ε] at hsum
  linarith

/-- For every positive width, the real probability of the supported strict
weak typical set tends to one under the finite iid laws. For positive blocklengths,
the complement agrees with the self-information deviation event in probability,
including for sparse sources. The empty typical set at zero does not affect the limit. -/
theorem tendsto_prob_weakTypicalSet {A : Type u} [Fintype A]
    (p : PMF A) {ε : ℝ} (hε : 0 < ε) :
    Filter.Tendsto
      (fun n : ℕ => ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))).toReal)
      Filter.atTop (nhds 1) := by
  have hlimit := Filter.Tendsto.sub (tendsto_const_nhds (x := (1 : ℝ)))
    (tendsto_selfInfo_iid_deviation p hε)
  have heq :
      (fun n : ℕ => 1 - ((PMF.iid p n).toOuterMeasure
        {x | ε ≤ |selfInfo (PMF.iid p n) x / (n : ℝ) - entropy p|}).toReal)
        =ᶠ[Filter.atTop]
      (fun n : ℕ => ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))).toReal) := by
    filter_upwards [Filter.eventually_gt_atTop (0 : ℕ)] with n hn
    exact (iid_weakTypicalSet_probability p hn ε).symm
  simpa only [sub_zero] using Filter.Tendsto.congr' heq hlimit

/-! ## A nonuniform positive-variance regression -/

private theorem aepBiased_masses_add :
    ENNReal.ofReal (1 / 3 : ℝ) + ENNReal.ofReal (2 / 3 : ℝ) = 1 := by
  rw [← ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1 / 3)
    (by norm_num : (0 : ℝ) ≤ 2 / 3)]
  norm_num

private def aepBiased : PMF (Fin 2) :=
  PMF.ofFintype
    (fun a => ENNReal.ofReal (if a = 0 then (1 / 3 : ℝ) else 2 / 3))
    (by simpa [Fin.sum_univ_two] using aepBiased_masses_add)

private theorem aepBiased_mass_zero : (aepBiased 0).toReal = 1 / 3 := by
  norm_num [aepBiased, PMF.ofFintype_apply]

private theorem aepBiased_mass_one : (aepBiased 1).toReal = 2 / 3 := by
  norm_num [aepBiased, PMF.ofFintype_apply]

private theorem aepBiased_selfInfo_zero : selfInfo aepBiased 0 = Real.log 3 := by
  have hm : (aepBiased 0).toReal ≠ 0 := by rw [aepBiased_mass_zero]; norm_num
  rw [selfInfo_of_toReal_ne_zero aepBiased hm, aepBiased_mass_zero,
    Real.log_div (by norm_num : (1 : ℝ) ≠ 0) (by norm_num : (3 : ℝ) ≠ 0),
    Real.log_one]
  ring

private theorem aepBiased_selfInfo_one :
    selfInfo aepBiased 1 = Real.log 3 - Real.log 2 := by
  have hm : (aepBiased 1).toReal ≠ 0 := by rw [aepBiased_mass_one]; norm_num
  rw [selfInfo_of_toReal_ne_zero aepBiased hm, aepBiased_mass_one,
    Real.log_div (by norm_num : (2 : ℝ) ≠ 0) (by norm_num : (3 : ℝ) ≠ 0)]
  ring

private theorem aepBiased_entropy :
    entropy aepBiased = Real.log 3 - (2 / 3 : ℝ) * Real.log 2 := by
  rw [entropy_eq_sum, Fin.sum_univ_two,
    ← toReal_mul_selfInfo aepBiased 0, ← toReal_mul_selfInfo aepBiased 1,
    aepBiased_mass_zero, aepBiased_mass_one,
    aepBiased_selfInfo_zero, aepBiased_selfInfo_one]
  ring

private theorem aepBiased_abs_centered_zero :
    |selfInfo aepBiased 0 - entropy aepBiased| = (2 / 3 : ℝ) * Real.log 2 := by
  rw [aepBiased_selfInfo_zero, aepBiased_entropy]
  rw [show Real.log 3 - (Real.log 3 - (2 / 3 : ℝ) * Real.log 2) =
    (2 / 3 : ℝ) * Real.log 2 by ring]
  exact abs_of_nonneg (mul_nonneg (by norm_num)
    (Real.log_nonneg (by norm_num : (1 : ℝ) ≤ 2)))

private theorem aepBiased_abs_centered_one :
    |selfInfo aepBiased 1 - entropy aepBiased| = (1 / 3 : ℝ) * Real.log 2 := by
  rw [aepBiased_selfInfo_one, aepBiased_entropy]
  rw [show Real.log 3 - Real.log 2 - (Real.log 3 - (2 / 3 : ℝ) * Real.log 2) =
    -((1 / 3 : ℝ) * Real.log 2) by ring, abs_neg]
  exact abs_of_nonneg (mul_nonneg (by norm_num)
    (Real.log_nonneg (by norm_num : (1 : ℝ) ≤ 2)))

private theorem aepBiased_second_moment :
    (∑ a, (aepBiased a).toReal * (selfInfo aepBiased a - entropy aepBiased) ^ 2) =
      (2 / 9 : ℝ) * (Real.log 2) ^ 2 := by
  rw [Fin.sum_univ_two, aepBiased_mass_zero, aepBiased_mass_one,
    aepBiased_selfInfo_zero, aepBiased_selfInfo_one, aepBiased_entropy]
  ring

private theorem aepBiased_second_moment_pos :
    0 < ∑ a, (aepBiased a).toReal * (selfInfo aepBiased a - entropy aepBiased) ^ 2 := by
  rw [aepBiased_second_moment]
  exact mul_pos (by norm_num)
    (pow_pos (Real.log_pos (by norm_num : (1 : ℝ) < 2)) 2)

/- The left side is the actual normalized block self-information. Its variance
is transported by the same support/AE identity used by the concentration proof. -/
private theorem aepBiased_block_two_variance :
    letI : MeasurableSpace (Fin 2) := ⊤
    variance (fun x : Fin 2 → Fin 2 => selfInfo (PMF.iid aepBiased 2) x / 2)
        (PMF.iid aepBiased 2).toMeasure = (1 / 9 : ℝ) * (Real.log 2) ^ 2 ∧
      0 < variance (fun x : Fin 2 → Fin 2 => selfInfo (PMF.iid aepBiased 2) x / 2)
        (PMF.iid aepBiased 2).toMeasure := by
  let : MeasurableSpace (Fin 2) := ⊤
  have hae :
      (fun x : Fin 2 → Fin 2 => selfInfo (PMF.iid aepBiased 2) x / 2)
        =ᵐ[(PMF.iid aepBiased 2).toMeasure]
      (fun x => (∑ i, selfInfo aepBiased (x i)) / (2 : ℝ)) := by
    filter_upwards [iid_selfInfo_ae aepBiased 2] with x hx
    exact congrArg (fun t : ℝ => t / 2) hx.symm
  have hvar :
      variance (fun x : Fin 2 → Fin 2 => selfInfo (PMF.iid aepBiased 2) x / 2)
        (PMF.iid aepBiased 2).toMeasure = (1 / 9 : ℝ) * (Real.log 2) ^ 2 := by
    rw [variance_congr hae]
    calc
      variance (fun x : Fin 2 → Fin 2 => (∑ i, selfInfo aepBiased (x i)) / (2 : ℝ))
          (PMF.iid aepBiased 2).toMeasure =
          ((2 / 9 : ℝ) * (Real.log 2) ^ 2) / 2 := by
        simpa only [Nat.cast_ofNat, aepBiased_second_moment] using
          (iid_normalized_variance aepBiased (n := 2) (by decide))
      _ = (1 / 9 : ℝ) * (Real.log 2) ^ 2 := by ring
  refine ⟨hvar, ?_⟩
  rw [hvar]
  exact mul_pos (by norm_num)
    (pow_pos (Real.log_pos (by norm_num : (1 : ℝ) < 2)) 2)

end

end LeanInfoTheory.Shannon
