/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.InformationDensity
import LeanInfoTheory.Probability.ProductChannel
import LeanInfoTheory.Shannon.SemanticBridge.AEP

/-!
# Iid block information density

For iid input through a memoryless channel, information density on the supported
pair of input and output words is the sum of the coordinate-pair densities.
The pair-to-word equivalence transports the existing iid joint law. Supported
input, output and joint self-information then give the three finite sums.
The identity includes the empty word and allows zero input and channel masses.
The normalized density concentrates around single-letter mutual information
under the actual block joint laws at positive blocklengths. Three existing AEP
limits and a support-aware union bound suffice; input and output may depend
on each other. No common sample space across blocklengths is required.
For a fixed real per-symbol threshold strictly below that mean, the literal
complement of the strict threshold event has probability tending to zero.
Its unnormalized threshold is blocklength times that real value, with ties
included in the miss. The miss limit uses every natural blocklength.
All information quantities use natural logarithms.
-/

namespace LeanInfoTheory.Shannon

open scoped BigOperators

universe u v

private theorem infoDensity_eq_selfInfo {A : Type u} {B : Type v}
    (p : PMF A) (W : A → PMF B) {z : A × B}
    (hz : z ∈ (PMF.channelJoint p W).support) :
    infoDensity p W z =
      selfInfo p z.1 + selfInfo (p.bind W) z.2 - selfInfo (PMF.channelJoint p W) z := by
  rcases z with ⟨a, b⟩
  have hs := support_channelJoint_subset_indepProd p W hz
  rw [support_indepProd] at hs
  have ha : (p a).toReal ≠ 0 := ENNReal.toReal_ne_zero.mpr ⟨hs.1, p.apply_ne_top _⟩
  have hb : ((p.bind W) b).toReal ≠ 0 :=
    ENNReal.toReal_ne_zero.mpr ⟨hs.2, (p.bind W).apply_ne_top _⟩
  have hj : ((PMF.channelJoint p W) (a, b)).toReal ≠ 0 :=
    ENNReal.toReal_ne_zero.mpr ⟨hz, (PMF.channelJoint p W).apply_ne_top _⟩
  rw [infoDensity, indepProd_apply, ENNReal.toReal_mul,
    Real.log_div hj (mul_ne_zero ha hb), Real.log_mul ha hb,
    selfInfo_of_toReal_ne_zero _ ha, selfInfo_of_toReal_ne_zero _ hb,
    selfInfo_of_toReal_ne_zero _ hj]
  ring

/-- Under iid input and a memoryless channel, the information density of a
supported word pair is the sum of its coordinate-pair densities, in nats.
This includes length zero. The support premise permits sparse input laws and
channel rows while respecting the totalized density at impossible pairs. -/
theorem infoDensity_iid_of_mem_support {A : Type u} {B : Type v}
    [Fintype A] [Fintype B] (p : PMF A) (W : A → PMF B) (n : ℕ)
    {z : (Fin n → A) × (Fin n → B)}
    (hz : z ∈ (PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).support) :
    infoDensity (PMF.iid p n) (PMF.memorylessChannel W n) z =
      ∑ i : Fin n, infoDensity p W (z.1 i, z.2 i) := by
  classical
  let e := Equiv.arrowProdEquivProdArrow (Fin n) (fun _ => A) (fun _ => B)
  obtain ⟨w, rfl⟩ := e.surjective z
  have hmap : (PMF.iid (PMF.channelJoint p W) n).map e =
      PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n) :=
    PMF.finiteProduct_channelJoint_map (fun _ => p) (fun _ => W)
  have hatom : PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n) (e w) =
      PMF.iid (PMF.channelJoint p W) n w := by
    rw [← hmap, PMF.map_apply_equiv]
  have hw : w ∈ (PMF.iid (PMF.channelJoint p W) n).support := by
    change PMF.iid (PMF.channelJoint p W) n w ≠ 0
    rw [← hatom]
    exact hz
  have hout : (PMF.iid p n).bind (PMF.memorylessChannel W n) =
      PMF.iid (p.bind W) n :=
    PMF.finiteProduct_bind_productChannel (fun _ => p) (fun _ => W)
  have hs := support_channelJoint_subset_indepProd (PMF.iid p n)
    (PMF.memorylessChannel W n) hz
  rw [support_indepProd, hout] at hs
  have hself :
      selfInfo (PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)) (e w) =
        selfInfo (PMF.iid (PMF.channelJoint p W) n) w := by
    simp only [selfInfo, hatom]
  rw [infoDensity_eq_selfInfo _ _ hz, hout, hself,
    selfInfo_iid_of_mem_support p n hs.1,
    selfInfo_iid_of_mem_support (p.bind W) n hs.2,
    selfInfo_iid_of_mem_support (PMF.channelJoint p W) n hw,
    ← Finset.sum_add_distrib, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro i _
  exact (infoDensity_eq_selfInfo p W
    ((PMF.mem_support_finiteProduct_iff (fun _ : Fin n => PMF.channelJoint p W) w).1 hw i)).symm

open MeasureTheory
open scoped ENNReal

private theorem prob_le_three_events_of_support_subset {α : Type*} (q : PMF α) (D A B C : Set α)
    (h : D ∩ q.support ⊆ (A ∪ B) ∪ C) :
    (q.toOuterMeasure D).toReal ≤ (q.toOuterMeasure A).toReal + (q.toOuterMeasure B).toReal +
      (q.toOuterMeasure C).toReal := by
  have finite (S : Set α) : q.toOuterMeasure S ≠ ⊤ := by
    rw [PMF.toOuterMeasure_apply]
    exact q.tsum_coe_indicator_ne_top S
  have hmass : q.toOuterMeasure D ≤
      (q.toOuterMeasure A + q.toOuterMeasure B) + q.toOuterMeasure C :=
    (q.toOuterMeasure_mono h).trans ((measure_union_le (μ := q.toOuterMeasure) _ _).trans
      (add_le_add (measure_union_le (μ := q.toOuterMeasure) A B) le_rfl))
  have hfin := ENNReal.add_ne_top.mpr ⟨finite A, finite B⟩
  simpa only [ENNReal.toReal_add hfin (finite C), ENNReal.toReal_add (finite A) (finite B)] using
    ENNReal.toReal_mono (ENNReal.add_ne_top.mpr ⟨hfin, finite C⟩) hmass

private def iidSelfInfoDeviation {A : Type*} [Fintype A] (p : PMF A) (k : ℕ) (δ : ℝ) :
    Set (Fin (k + 1) → A) :=
  {w | δ ≤ |selfInfo (PMF.iid p (k + 1)) w / ((k + 1 : ℕ) : ℝ) - entropy p|}

private theorem infoDensity_iid_deviation_le {A : Type u} {B : Type v} [Fintype A] [Fintype B]
    (p : PMF A) (W : A → PMF B) (k : ℕ) (ε : ℝ) :
    let n := k + 1
    let J := PMF.channelJoint p W
    let Jn := PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)
    (Jn.toOuterMeasure {z | ε ≤
      |infoDensity (PMF.iid p n) (PMF.memorylessChannel W n) z / (n : ℝ) -
      mutualInfo J|}).toReal ≤
      ((PMF.iid p n).toOuterMeasure (iidSelfInfoDeviation p k (ε/3))).toReal +
      ((PMF.iid (p.bind W) n).toOuterMeasure (iidSelfInfoDeviation (p.bind W) k (ε/3))).toReal +
      ((PMF.iid J n).toOuterMeasure (iidSelfInfoDeviation J k (ε/3))).toReal := by
  intro n J Jn
  let e := Equiv.arrowProdEquivProdArrow (Fin n) (fun _ => A) (fun _ => B)
  have hmap : (PMF.iid J n).map e = Jn :=
    PMF.finiteProduct_channelJoint_map (fun _ => p) (fun _ => W)
  have hout : (PMF.iid p n).bind (PMF.memorylessChannel W n) = PMF.iid (p.bind W) n :=
    PMF.finiteProduct_bind_productChannel (fun _ => p) (fun _ => W)
  have hfst (S : Set (Fin n → A)) :
      Jn.toOuterMeasure (Prod.fst ⁻¹' S) = (PMF.iid p n).toOuterMeasure S := by
    have hproj : Jn.map Prod.fst = PMF.iid p n := PMF.channelJoint_map_fst _ _
    rw [← PMF.toOuterMeasure_map_apply, hproj]
  have hsnd (S : Set (Fin n → B)) :
      Jn.toOuterMeasure (Prod.snd ⁻¹' S) = (PMF.iid (p.bind W) n).toOuterMeasure S := by
    have hproj : Jn.map Prod.snd = (PMF.iid p n).bind (PMF.memorylessChannel W n) :=
      PMF.channelJoint_map_snd _ _
    rw [← PMF.toOuterMeasure_map_apply, hproj, hout]
  have hjoint (S : Set (Fin n → A × B)) : Jn.toOuterMeasure (e.symm ⁻¹' S) =
      (PMF.iid J n).toOuterMeasure S := by
    rw [← hmap, PMF.toOuterMeasure_map_apply]
    congr 1
  rw [← hfst, ← hsnd, ← hjoint]
  apply prob_le_three_events_of_support_subset
  rintro z ⟨hd, hz⟩
  by_contra hc
  have ha : |selfInfo (PMF.iid p n) z.1 / (n:ℝ) - entropy p| < ε/3 :=
    lt_of_not_ge (fun h => hc (Or.inl (Or.inl h)))
  have hb : |selfInfo (PMF.iid (p.bind W) n) z.2 / (n:ℝ) - entropy (p.bind W)| < ε/3 :=
    lt_of_not_ge (fun h => hc (Or.inl (Or.inr h)))
  have hj : |selfInfo (PMF.iid J n) (e.symm z) / (n:ℝ) - entropy J| < ε/3 :=
    lt_of_not_ge (fun h => hc (Or.inr h))
  have hatom : Jn z = PMF.iid J n (e.symm z) := by
    rw [← hmap]
    simpa only [Equiv.apply_symm_apply] using PMF.map_apply_equiv (PMF.iid J n) e (e.symm z)
  have hself : selfInfo Jn z = selfInfo (PMF.iid J n) (e.symm z) := by
    simp only [selfInfo, hatom]
  change ε ≤ |infoDensity _ _ z / (n:ℝ) - mutualInfo J| at hd
  have hI : mutualInfo J = entropy p + entropy (p.bind W) - entropy J := by
    simp only [mutualInfo, fstMarginal, sndMarginal, J,
      PMF.channelJoint_map_fst, PMF.channelJoint_map_snd]
  rw [infoDensity_eq_selfInfo _ _ hz, hout, hself, hI, sub_div, add_div] at hd
  have ⟨ha₁, ha₂⟩ := abs_lt.mp ha
  have ⟨hb₁, hb₂⟩ := abs_lt.mp hb
  have ⟨hj₁, hj₂⟩ := abs_lt.mp hj
  exact (not_le_of_gt (abs_lt.mpr ⟨by linarith, by linarith⟩)) hd


/-- Under the iid input and memoryless channel, the probability of a closed
two-sided deviation of the normalized block information density from single-letter
mutual information tends to zero. The word pairs and joint law vary with the
positive blocklength, and input and output can be dependent. -/
theorem tendsto_infoDensity_iid_deviation {A : Type u} {B : Type v} [Fintype A] [Fintype B]
    (p : PMF A) (W : A → PMF B) {ε : ℝ} (hε : 0 < ε) :
    Filter.Tendsto (fun k : ℕ =>
      let n := k + 1
      ((PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).toOuterMeasure
        {z | ε ≤ |infoDensity (PMF.iid p n) (PMF.memorylessChannel W n) z / (n : ℝ) -
          mutualInfo (PMF.channelJoint p W)|}).toReal)
      Filter.atTop (nhds 0) := by
  have hδ : 0 < ε / 3 := by positivity
  have hInput := (tendsto_selfInfo_iid_deviation p hδ).comp (Filter.tendsto_add_atTop_nat 1)
  have hOutput := (tendsto_selfInfo_iid_deviation (p.bind W) hδ).comp
    (Filter.tendsto_add_atTop_nat 1)
  have hJoint := (tendsto_selfInfo_iid_deviation (PMF.channelJoint p W) hδ).comp
    (Filter.tendsto_add_atTop_nat 1)
  apply squeeze_zero' (Filter.Eventually.of_forall fun _ => ENNReal.toReal_nonneg)
    (Filter.Eventually.of_forall fun k => infoDensity_iid_deviation_le p W k ε)
  simpa only [add_zero, Function.comp_apply, iidSelfInfoDeviation] using
    (hInput.add hOutput).add hJoint

/-- For every fixed real threshold per symbol strictly below single-letter mutual
information, the true-pair miss probability of the strict iid word test tends
to zero. The threshold is unnormalized and ties count as misses. -/
theorem tendsto_prob_infoDensityThresholdEvent_iid_compl {A : Type u} {B : Type v}
    [Fintype A] [Fintype B] (p : PMF A) (W : A → PMF B) {s : ℝ}
    (hs : s < mutualInfo (PMF.channelJoint p W)) :
    Filter.Tendsto (fun n : ℕ =>
      ((PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).toOuterMeasure
        (infoDensityThresholdEvent (PMF.iid p n) (PMF.memorylessChannel W n)
          ((n : ℝ) * s))ᶜ).toReal)
      Filter.atTop (nhds 0) := by
  apply (Filter.tendsto_add_atTop_iff_nat 1).mp
  apply squeeze_zero' (Filter.Eventually.of_forall fun _ => ENNReal.toReal_nonneg) _
    (tendsto_infoDensity_iid_deviation p W (sub_pos.mpr hs))
  apply Filter.Eventually.of_forall
  intro k
  rw [channelJoint_infoDensityThresholdEvent_compl_eq]
  apply ENNReal.toReal_mono
  · rw [PMF.toOuterMeasure_apply]
    exact PMF.tsum_coe_indicator_ne_top _ _
  · apply MeasureTheory.measure_mono
    intro z hz
    let n := k + 1
    let d := infoDensity (PMF.iid p n) (PMF.memorylessChannel W n) z
    let I := mutualInfo (PMF.channelJoint p W)
    change d ≤ (n : ℝ) * s at hz
    change I - s ≤ |d / (n : ℝ) - I|
    have hn : 0 < (n : ℝ) := by dsimp [n]; positivity
    have hdiv : d / (n : ℝ) ≤ s := (div_le_iff₀ hn).2 (hz.trans_eq (mul_comm _ _))
    rw [abs_sub_comm]
    exact (sub_le_sub_left hdiv I).trans (le_abs_self _)

end LeanInfoTheory.Shannon
