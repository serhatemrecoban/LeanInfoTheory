/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.OperationalCapacity
import LeanInfoTheory.Shannon.OperationalExpurgation

namespace LeanInfoTheory.Qualification.Rate

open LeanInfoTheory.Shannon Filter

noncomputable section

universe u v
variable {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]

private def miss (p : PMF X) (W : X → PMF Y) (s : ℝ) (n : ℕ) : ℝ :=
  let q := PMF.iid p n
  let K := PMF.memorylessChannel W n
  ((PMF.channelJoint q K).toOuterMeasure (infoDensityThresholdEvent q K ((n : ℝ) * s))ᶜ).toReal

private def competingTerm (R s : ℝ) (n : ℕ) : ℝ :=
  ((roundedMessageSize n R : ℝ) - 1) * Real.exp (-((n : ℝ) * s))

private theorem competingTerm_tendsto {R s : ℝ} (hs : R < s) :
    Tendsto (competingTerm R s) atTop (nhds 0) := by
  have grow : Tendsto (fun n : ℕ => (s - R) * (n : ℝ)) atTop atTop :=
    tendsto_natCast_atTop_atTop.const_mul_atTop (sub_pos.mpr hs)
  have lim : Tendsto (fun n : ℕ => Real.exp (-(n : ℝ) * (s - R))) atTop (nhds 0) := by
    simpa only [Function.comp_def, neg_mul, mul_comm (s - R)] using
      Real.tendsto_exp_neg_atTop_nhds_zero.comp grow
  apply squeeze_zero _ _ lim
  · intro n
    have hM : (1 : ℝ) ≤ roundedMessageSize n R := by
      exact_mod_cast (roundedMessageSize_bounds n R).1
    exact mul_nonneg (sub_nonneg.mpr hM) (Real.exp_pos _).le
  · intro n
    have hceil : (roundedMessageSize n R : ℝ) - 1 ≤ Real.exp ((n : ℝ) * R) := by
      linarith only [(roundedMessageSize_bounds n R).2.2]
    calc
      competingTerm R s n ≤ Real.exp ((n : ℝ) * R) * Real.exp (-((n : ℝ) * s)) :=
        mul_le_mul_of_nonneg_right hceil (Real.exp_pos _).le
      _ = Real.exp (-(n : ℝ) * (s - R)) := by rw [← Real.exp_add]; congr 1; ring

private def selectedAt (p : PMF X) (W : X → PMF Y) (R s : ℝ) (n : ℕ)
    (c : BlockChannelCode X Y n (roundedMessageSize n R)) : Prop :=
  let q := PMF.iid p n
  let K := PMF.memorylessChannel W n
  let t := (n : ℝ) * s
  let hM := (roundedMessageSize_bounds n R).1
  c.encoder ∈ (PMF.iid q (roundedMessageSize n R)).support ∧
    c = BlockChannelCode.ofAcceptanceEvent c.encoder (infoDensityThresholdEvent q K t) hM ∧
    c.errorProbability W hM ≤ miss p W s n + competingTerm R s n

/-- Keep the complete good set for the rate claim. A smaller positive budget
chooses its restricted decoder before evaluating the message prior. -/
private def retained (W : X → PMF Y) (R : ℝ) (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode X Y n (M n)) : Prop :=
  ∃ (L : ℕ → ℕ) (hL : ∀ n, 1 ≤ L n) (D : ∀ n, BlockChannelCode X Y n (L n)),
    (∀ n, (M n + 1) / 2 ≤ L n ∧ ∃ i : Fin (L n) ↪ Fin (M n),
      Set.range i = {m | (c n).messageErrorProbability W m ≤ 2 * (c n).errorProbability W (hM n)} ∧
      D n = (c n).restrictMessages i ⟨0, hL n⟩) ∧
    (∀ n, (D n).maximalErrorProbability W (hL n) ≤ 2 * (c n).errorProbability W (hM n)) ∧
    Tendsto (fun n => (D n).maximalErrorProbability W (hL n)) atTop (nhds 0) ∧
    (∀ n, 0 < n → codeRate n (M n) - Real.log 2 / n ≤ codeRate n (L n)) ∧
    (∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (L n)) ∧
    ∀ n K (hK : 1 ≤ K) (fit : K ≤ L n), ∃ d : BlockChannelCode X Y n K,
      d = (D n).restrictMessages (Fin.castLEEmb fit) ⟨0, hK⟩ ∧
      d.maximalErrorProbability W hK ≤ (D n).maximalErrorProbability W (hL n) ∧
      ∀ π : PMF (Fin K), d.errorProbabilityWithPrior W π ≤ 2 * (c n).errorProbability W (hM n)

omit [Fintype X] [Nonempty X] in
private theorem retainFamily (W : X → PMF Y) (R : ℝ) (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode X Y n (M n))
    (he : Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0))
    (hr : ∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (M n)) :
    retained W R M hM c := by
  obtain ⟨L, hL, D, hfull, hmax, hlim, hloss, hfloor⟩ :=
    exists_expurgated_family_of_tendsto_errorProbability W R M hM c he hr
  refine ⟨L, hL, D, hfull, hmax, hlim, hloss, hfloor, ?_⟩
  intro n K hK fit
  let i := Fin.castLEEmb fit
  let d := (D n).restrictMessages i ⟨0, hK⟩
  have bound : d.maximalErrorProbability W hK ≤ (D n).maximalErrorProbability W (hL n) := by
    apply (d.maximalErrorProbability_le_iff W hK _).2
    intro j
    exact ((D n).messageErrorProbability_restrictMessages_le W i ⟨0, hK⟩ j).trans
      (((D n).maximalErrorProbability_le_iff W (hL n) _).1 le_rfl _)
  exact ⟨d, rfl, bound, fun π => (d.errorProbabilityWithPrior_le_maximalErrorProbability W π hK).trans
    (bound.trans (hmax n))⟩

/-- One input and slope govern every selected book, error bound, limit and
restriction. The input attains the information capacity; the coding rate is
strictly below it. -/
private theorem strictRate (W : X → PMF Y) (R : ℝ) (hR : 0 ≤ R) (hcap : R < channelCapacity W) :
    ∃ (p : PMF X) (s : ℝ), mutualInfo (PMF.channelJoint p W) = channelCapacity W ∧
      R < s ∧ s < mutualInfo (PMF.channelJoint p W) ∧
      Tendsto (miss p W s) atTop (nhds 0) ∧ Tendsto (competingTerm R s) atTop (nhds 0) ∧
      (∀ n, 1 ≤ roundedMessageSize n R) ∧
      (∀ n, 0 < n → R ≤ codeRate n (roundedMessageSize n R) ∧
        codeRate n (roundedMessageSize n R) ≤ R + Real.log 2 / n) ∧
      ∃ c : ∀ n, BlockChannelCode X Y n (roundedMessageSize n R),
        (∀ n, selectedAt p W R s n (c n)) ∧
        Tendsto (fun n => (c n).errorProbability W (roundedMessageSize_bounds n R).1) atTop (nhds 0) ∧
        (∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (roundedMessageSize n R)) ∧
        retained W R (fun n => roundedMessageSize n R) (fun n => (roundedMessageSize_bounds n R).1) c ∧
        IsAchievableRate W R ∧ R ≤ channelCapacity W ∧
        IsLUB {r : ℝ | IsAchievableRate W r} (channelCapacity W) := by
  classical
  obtain ⟨p, hp⟩ := exists_mutualInfo_channelJoint_eq_channelCapacity W
  obtain ⟨s, hRs, hs⟩ := exists_between (hcap.trans_eq hp.symm)
  have hmiss : Tendsto (miss p W s) atTop (nhds 0) :=
    tendsto_prob_infoDensityThresholdEvent_iid_compl p W hs
  have hterm := competingTerm_tendsto hRs
  let M (n : ℕ) := roundedMessageSize n R
  let hM (n : ℕ) : 1 ≤ M n := (roundedMessageSize_bounds n R).1
  have chooseAt (n : ℕ) : ∃ c : BlockChannelCode X Y n (M n), selectedAt p W R s n c :=
    exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold
      (PMF.iid p n) W ((n : ℝ) * s) (hM n)
  choose c hc using chooseAt
  have he : Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0) :=
    squeeze_zero (fun n => (c n).errorProbability_nonneg W (hM n)) (fun n => (hc n).2.2)
      (by simpa only [zero_add] using hmiss.add hterm)
  have hr : ∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (M n) := by
    intro δ hδ
    filter_upwards [eventually_gt_atTop (0 : ℕ)] with n hn
    exact (sub_le_self R hδ.le).trans (codeRate_roundedMessageSize_bounds hn hR).1
  have ach : IsAchievableRate W R := ⟨hR, M, hM, c, he, hr⟩
  exact ⟨p, s, hp, hRs, hs, hmiss, hterm, hM, fun _ hn => codeRate_roundedMessageSize_bounds hn hR,
    c, hc, he, hr, retainFamily W R M hM c he hr, ach, le_channelCapacity_of_isAchievableRate W ach,
    isLUB_isAchievableRate W⟩

private theorem singletonFamily (W : X → PMF Y) :
    IsAchievableRate W 0 ∧ (∃ c : ∀ n, BlockChannelCode X Y n 1,
      ∀ n, (c n).errorProbability W le_rfl = 0 ∧ codeRate n 1 = 0) ∧
    0 ≤ channelCapacity W ∧ IsLUB {r : ℝ | IsAchievableRate W r} (channelCapacity W) := by
  let c (n : ℕ) : BlockChannelCode X Y n 1 :=
    (fun _ _ => Classical.choice (inferInstance : Nonempty X), fun _ => 0)
  have ach := isAchievableRate_zero W
  exact ⟨ach, ⟨c, fun n => ⟨(c n).errorProbability_one W, codeRate_one n⟩⟩,
    le_channelCapacity_of_isAchievableRate W ach, isLUB_isAchievableRate W⟩

example (W : X → PMF Y) (hC : channelCapacity W = 0) :
    IsLUB {r : ℝ | IsAchievableRate W r} 0 ∧ (∀ r, IsAchievableRate W r ↔ r = 0) ∧
    ∃ c : ∀ n, BlockChannelCode X Y n 1, ∀ n, (c n).errorProbability W le_rfl = 0 ∧ codeRate n 1 = 0 := by
  obtain ⟨hzero, codes, _, lub⟩ := singletonFamily W
  refine ⟨hC ▸ lub, ?_, codes⟩
  intro r
  constructor
  · intro hr
    exact le_antisymm (hC ▸ le_channelCapacity_of_isAchievableRate W hr) hr.1
  · rintro rfl
    exact hzero

end
end LeanInfoTheory.Qualification.Rate
