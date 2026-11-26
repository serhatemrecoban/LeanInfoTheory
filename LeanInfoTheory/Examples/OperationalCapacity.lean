/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.OperationalCapacity
import LeanInfoTheory.Shannon.StandardChannelCapacity

/-!
# Operational capacity consumers

The focused consumer retains the budget and codes while specializing the rate
clause twice. The singleton caller needs only a nonempty input and finite output.
The converse accepts arbitrary dependent code families. The upper and least
clauses of operational capacity are exercised generically and at zero capacity.
The half-erasure binary channel has a positive achievable rate. For a constant
output row on nonempty finite input, the achievable-rate set is exactly `{0}`.
-/

namespace LeanInfoTheory.Examples.OperationalCapacity

open LeanInfoTheory.Shannon Filter

universe u v

example {X : Type u} {Y : Type v} [Fintype Y] (W : X → PMF Y) (R : ℝ)
    (h : IsAchievableRate W R) (δ₁ δ₂ : ℝ) (hδ₁ : 0 < δ₁) (hδ₂ : 0 < δ₂) :
    ∃ (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
      (c : ∀ n, BlockChannelCode X Y n (M n)),
      Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0) ∧
      ∀ᶠ n in atTop,
        R - δ₁ ≤ codeRate n (M n) ∧ R - δ₂ ≤ codeRate n (M n) := by
  obtain ⟨_, M, hM, c, he, hr⟩ := h
  exact ⟨M, hM, c, he, (hr δ₁ hδ₁).and (hr δ₂ hδ₂)⟩

example {X : Type u} {Y : Type v} [Nonempty X] [Fintype Y]
    (W : X → PMF Y) : IsAchievableRate W 0 :=
  isAchievableRate_zero W

/-! A generic subcapacity caller retains one family and its error limit for
every positive rate tolerance. -/

example {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]
    (W : X → PMF Y) {R : ℝ} (hR : 0 ≤ R) (hlt : R < channelCapacity W) :
    ∃ (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
      (c : ∀ n, BlockChannelCode X Y n (M n)),
      Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0) ∧
      ∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (M n) :=
  (isAchievableRate_of_lt_channelCapacity W hR hlt).2

example {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]
    (W : X → PMF Y) {R : ℝ} (hR : 0 ≤ R)
    (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode X Y n (M n))
    (he : Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0))
    (hr : ∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (M n)) :
    R ≤ channelCapacity W :=
  le_channelCapacity_of_isAchievableRate W ⟨hR, M, hM, c, he, hr⟩

example {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]
    (W : X → PMF Y) {R b : ℝ} (hR : IsAchievableRate W R)
    (hb : b ∈ upperBounds {r : ℝ | IsAchievableRate W r}) :
    R ≤ channelCapacity W ∧ channelCapacity W ≤ b :=
  ⟨(isLUB_isAchievableRate W).1 hR, (isLUB_isAchievableRate W).2 hb⟩

example {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]
    (W : X → PMF Y) (hC : channelCapacity W = 0) {R b : ℝ}
    (hR : IsAchievableRate W R)
    (hb : b ∈ upperBounds {r : ℝ | IsAchievableRate W r}) :
    R ≤ 0 ∧ 0 ≤ b := by
  simpa only [hC] using
    (show R ≤ channelCapacity W ∧ channelCapacity W ≤ b from
      ⟨(isLUB_isAchievableRate W).1 hR, (isLUB_isAchievableRate W).2 hb⟩)

/-! At half erasure, capacity is `log 2 / 2` nats per use. The strictly smaller
positive rate `log 2 / 4` is achievable with the public operational predicate. -/

example :
    let W := PMF.binaryErasureChannel (1 / 2) (by norm_num)
    channelCapacity W = Real.log 2 / 2 ∧
      0 < channelCapacity W ∧
      0 < Real.log 2 / 4 ∧
      IsAchievableRate W (Real.log 2 / 4) ∧
      IsLUB {R : ℝ | IsAchievableRate W R} (Real.log 2 / 2) := by
  let W := PMF.binaryErasureChannel (1 / 2) (by norm_num)
  have hC : channelCapacity W = Real.log 2 / 2 := by
    dsimp only [W]
    rw [channelCapacity_binaryErasureChannel]
    norm_num [NNReal.coe_div]
    ring
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hpos : 0 < Real.log 2 / 4 := by positivity
  have hcap : 0 < channelCapacity W := by
    rw [hC]
    positivity
  have hlt : Real.log 2 / 4 < channelCapacity W := by
    rw [hC]
    linarith
  refine ⟨hC, hcap, hpos, isAchievableRate_of_lt_channelCapacity W hpos.le hlt, ?_⟩
  simpa only [hC] using isLUB_isAchievableRate W

/-! On nonempty finite input and finite output, a fixed row has zero capacity.
The singleton theorem witnesses zero even though there is no nonnegative
strict-subcapacity target. -/

example {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]
    (q : PMF Y) :
    let W := fun _ : X => q
    channelCapacity W = 0 ∧
      IsAchievableRate W 0 ∧
      {R : ℝ | IsAchievableRate W R} = {0} ∧
      ¬ ∃ R : ℝ, 0 ≤ R ∧ R < channelCapacity W := by
  let W := fun _ : X => q
  have hC : channelCapacity W = 0 := channelCapacity_const (A := X) q
  have hzero : IsAchievableRate W 0 := isAchievableRate_zero W
  refine ⟨hC, hzero, ?_, ?_⟩
  · ext R
    change IsAchievableRate W R ↔ R = 0
    constructor
    · intro hR
      apply le_antisymm
      · simpa only [hC] using le_channelCapacity_of_isAchievableRate W hR
      · exact hR.1
    · rintro rfl
      exact hzero
  · rintro ⟨R, hR, hlt⟩
    rw [hC] at hlt
    exact (not_lt_of_ge hR) hlt

/-! Conditional C32 budget handoff. The original family and its error limit
are retained before any proposed budget or rate tolerance is supplied. C32 must
provide the retained codes and their error guarantee; this transfers rate only. -/

example {X : Type u} {Y : Type v} [Fintype Y]
    (W : X → PMF Y) {R : ℝ} (h : IsAchievableRate W R) :
    ∃ (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
      (c : ∀ n, BlockChannelCode X Y n (M n)),
      Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0) ∧
      (∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (M n)) ∧
      ∀ (M' : ℕ → ℕ), (∀ n, 1 ≤ M' n) →
        (∀ᶠ n in atTop,
          codeRate n (M n) - Real.log 2 / (n : ℝ) ≤ codeRate n (M' n)) →
        ∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (M' n) := by
  obtain ⟨_, M, hM, c, he, hr⟩ := h
  refine ⟨M, hM, c, he, hr, ?_⟩
  intro M' _ hloss δ hδ
  have hhalf : 0 < δ / 2 := half_pos hδ
  have htail : ∀ᶠ n : ℕ in atTop,
      0 < n ∧ Real.log 2 / (n : ℝ) < δ / 2 :=
    (eventually_gt_atTop (0 : ℕ)).and
      ((tendsto_const_div_atTop_nhds_zero_nat (Real.log 2)).eventually
        (gt_mem_nhds hhalf))
  filter_upwards [hr (δ / 2) hhalf, hloss, htail] with n hrate hlossn hn
  linarith only [hrate, hlossn, hn.2]

end LeanInfoTheory.Examples.OperationalCapacity
