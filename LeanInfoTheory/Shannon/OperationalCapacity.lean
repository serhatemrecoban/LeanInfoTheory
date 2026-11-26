/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCodingAsymptotic
import LeanInfoTheory.Shannon.ChannelCodingOneShot
import LeanInfoTheory.Shannon.IidInformationDensity

/-!
# Operational capacity for finite channels

A rate is achievable when one positive-budget deterministic code family has
vanishing uniform-message average error and meets every positive rate tolerance
eventually. The family is fixed before the tolerance. Rates are in nats per use.

Every nonnegative rate strictly below information capacity is achievable.
Information capacity bounds all rates satisfying this same predicate and is
their least upper bound. The singleton family gives zero for nonempty input.

This uses the average-error code notion of PW24 §19.1 with the released total
message-valued decoder. CT91 §8.5 uses maximal error; its §8.7 proof selects an
average-error code before expurgation. The rate condition here allows arbitrary
finite prefixes and does not require a rate limit.
-/

namespace LeanInfoTheory.Shannon

open Filter

universe u v

/-- A nonnegative rate attained from below, up to every positive tolerance, by
one deterministic block-code family with positive message counts and vanishing
uniform-message average error. The same family is used at every tolerance. -/
def IsAchievableRate {X : Type u} {Y : Type v} [Fintype Y]
    (W : X → PMF Y) (R : ℝ) : Prop :=
  0 ≤ R ∧
    ∃ (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
      (c : ∀ n, BlockChannelCode X Y n (M n)),
      Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0) ∧
      ∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (M n)

/-- The one-message family achieves rate zero at every channel on a nonempty
input alphabet. Its rate and error are zero at every length, including zero. -/
theorem isAchievableRate_zero {X : Type u} {Y : Type v} [Nonempty X] [Fintype Y]
    (W : X → PMF Y) : IsAchievableRate W 0 := by
  let c (n : ℕ) : BlockChannelCode X Y n 1 :=
    (fun _ _ => Classical.choice (inferInstance : Nonempty X), fun _ => 0)
  refine ⟨le_rfl, fun _ => 1, fun _ => le_rfl, c, ?_, ?_⟩
  · simpa only [BlockChannelCode.errorProbability_one] using
      (tendsto_const_nhds : Tendsto (fun _ : ℕ => (0 : ℝ)) atTop (nhds 0))
  · intro δ hδ
    exact Eventually.of_forall fun n => by
      simpa only [codeRate_one, zero_sub] using (neg_nonpos.mpr hδ.le)

/-- Every nonnegative rate strictly below information capacity is achievable.
One input law, threshold slope and family at the rounded budgets are fixed
before any rate tolerance. The released average error tends to zero. -/
theorem isAchievableRate_of_lt_channelCapacity
    {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]
    (W : X → PMF Y) {R : ℝ} (hR : 0 ≤ R) (hlt : R < channelCapacity W) :
    IsAchievableRate W R := by
  classical
  obtain ⟨p, hp⟩ := exists_mutualInfo_channelJoint_eq_channelCapacity W
  rw [← hp] at hlt
  obtain ⟨s, hRs, hs⟩ := exists_between hlt
  let miss (n : ℕ) : ℝ :=
    ((PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).toOuterMeasure
      (infoDensityThresholdEvent (PMF.iid p n) (PMF.memorylessChannel W n)
        ((n : ℝ) * s))ᶜ).toReal
  have hpoint (n : ℕ) :
      ∃ c : BlockChannelCode X Y n (roundedMessageSize n R),
        c.errorProbability W (roundedMessageSize_bounds n R).1 ≤
          miss n + Real.exp (-(n : ℝ) * (s - R)) := by
    obtain ⟨c, _, _, hc⟩ :=
      exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold
        (q := PMF.iid p n) (W := W) (t := (n : ℝ) * s)
        (hM := (roundedMessageSize_bounds n R).1)
    refine ⟨c, hc.trans (add_le_add le_rfl ?_)⟩
    have hround : (roundedMessageSize n R : ℝ) - 1 ≤ Real.exp ((n : ℝ) * R) := by
      linarith only [(roundedMessageSize_bounds n R).2.2]
    calc
      ((roundedMessageSize n R : ℝ) - 1) * Real.exp (-((n : ℝ) * s)) ≤
          Real.exp ((n : ℝ) * R) * Real.exp (-((n : ℝ) * s)) :=
        mul_le_mul_of_nonneg_right hround (Real.exp_pos _).le
      _ = Real.exp (-(n : ℝ) * (s - R)) := by
        rw [← Real.exp_add]
        congr 1
        ring
  choose c hc using hpoint
  have hmiss : Tendsto miss atTop (nhds 0) :=
    tendsto_prob_infoDensityThresholdEvent_iid_compl p W hs
  have hexp : Tendsto (fun n : ℕ => Real.exp (-(n : ℝ) * (s - R)))
      atTop (nhds 0) := by
    have h : Tendsto (fun n : ℕ => (s - R) * (n : ℝ)) atTop atTop :=
      tendsto_natCast_atTop_atTop.const_mul_atTop (sub_pos.mpr hRs)
    simpa only [Function.comp_def, neg_mul, mul_comm (s - R)] using
      Real.tendsto_exp_neg_atTop_nhds_zero.comp h
  refine ⟨hR, fun n => roundedMessageSize n R,
    fun n => (roundedMessageSize_bounds n R).1, c, ?_, ?_⟩
  · exact squeeze_zero (fun n => (c n).errorProbability_nonneg W _) hc
      (by simpa only [zero_add] using hmiss.add hexp)
  · intro δ hδ
    filter_upwards [eventually_gt_atTop (0 : ℕ)] with n hn
    exact (sub_le_self R hδ.le).trans (codeRate_roundedMessageSize_bounds hn hR).1

/-- Every achievable rate is bounded by information capacity. C23's tolerance
converse applies to the same arbitrary family witnessing achievability. -/
theorem le_channelCapacity_of_isAchievableRate
    {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]
    (W : X → PMF Y) {R : ℝ} (h : IsAchievableRate W R) :
    R ≤ channelCapacity W := by
  obtain ⟨_, M, hM, c, he, hr⟩ := h
  apply le_of_not_gt
  intro hgap
  let δ := (R - channelCapacity W) / 3
  have hδ : 0 < δ := by
    dsimp [δ]
    linarith
  have hcap := BlockChannelCode.eventually_codeRate_le_channelCapacity_add
    W M hM c he δ hδ
  obtain ⟨n, hlo, hhi⟩ := ((hr δ hδ).and hcap).exists
  dsimp [δ] at hlo hhi
  linarith only [hlo, hhi, hgap]

/-- Information capacity is the least upper bound of achievable rates.
The zero-rate witness gives leastness also when capacity is zero. -/
theorem isLUB_isAchievableRate
    {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]
    (W : X → PMF Y) :
    IsLUB {R : ℝ | IsAchievableRate W R} (channelCapacity W) := by
  constructor
  · intro R hR
    exact le_channelCapacity_of_isAchievableRate W hR
  · intro b hb
    have hb0 : 0 ≤ b := hb (isAchievableRate_zero W)
    apply le_of_not_gt
    intro hgap
    let r := (b + channelCapacity W) / 2
    have hbr : b < r := by
      dsimp [r]
      linarith
    have hrC : r < channelCapacity W := by
      dsimp [r]
      linarith
    have hrb : r ≤ b :=
      hb (isAchievableRate_of_lt_channelCapacity W (hb0.trans hbr.le) hrC)
    exact (not_lt_of_ge hrb) hbr

end LeanInfoTheory.Shannon
