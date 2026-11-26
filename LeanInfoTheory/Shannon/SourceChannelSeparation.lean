/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceChannelCode
import LeanInfoTheory.Shannon.SourceCodingAsymptotic
import LeanInfoTheory.Shannon.OperationalCapacity
import LeanInfoTheory.Shannon.OperationalExpurgation

/-!
# Direct lossless source–channel separation

With one memoryless channel use per iid source symbol, compression below
channel capacity gives vanishing block reconstruction error. At each sufficiently
large length the compressed indices fit in a channel code with small maximal
error (CT91 §8.13, PW24 §19.7).
-/

namespace LeanInfoTheory.Shannon

open Filter

universe u v w

/-- If source entropy is strictly below channel capacity, a single pair of
total deterministic word-map families gives vanishing block reconstruction
error with one channel use per source symbol. -/
theorem exists_sourceChannelCode_tendsto_errorProbability_zero
    {S : Type u} {X : Type v} {Y : Type w} [Fintype S] [Fintype X] [Nonempty X] [Fintype Y]
    (p : PMF S) (W : X → PMF Y) (h : entropy p < channelCapacity W) :
    ∃ (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X)) (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S)),
      Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n)) atTop (nhds 0) := by
  obtain ⟨rs, hs, hsC⟩ := exists_between h
  obtain ⟨rc, hsc, hc⟩ := exists_between hsC
  obtain ⟨K, hK, a, hSourceError, hSourceRate⟩ :=
    exists_blockSourceCode_tendsto_errorProbability_zero p hs
  obtain ⟨_, M, hM, c, hUniformError, hChannelRate⟩ :=
    isAchievableRate_of_lt_channelCapacity W ((entropy_nonneg p).trans (hs.trans hsc).le) hc
  obtain ⟨L, hL, B, _, _, hMaxError, _, hRetainedRate⟩ :=
    exists_expurgated_family_of_tendsto_errorProbability W rc M hM c hUniformError hChannelRate
  -- The rate floor controls the full retained budget L.
  let δ := (rc - rs) / 2
  have hδ : 0 < δ := half_pos (sub_pos.mpr hsc)
  have hgap : rs < rc - δ := by dsimp [δ]; linarith
  have eventuallyFit : ∀ᶠ n in atTop, 0 < n ∧ K n ≤ L n := by
    filter_upwards [eventually_gt_atTop (0 : ℕ), hSourceRate, hRetainedRate δ hδ]
      with n hn hsRate hcRate
    have hRate := hsRate.trans (hgap.le.trans hcRate)
    have hSize := (codeRate_le_iff hn (hK n) _).mp hRate
    rw [exp_mul_codeRate hn (hL n)] at hSize
    exact ⟨hn, by exact_mod_cast hSize⟩
  -- Both exceptional words come from the positive-budget component families.
  let restricted (n : ℕ) (hfit : K n ≤ L n) :=
    (B n).restrictMessages (Fin.castLEEmb hfit) ⟨0, hK n⟩
  let separated (n : ℕ) (hfit : K n ≤ L n) :=
    ((restricted n hfit).encoder ∘ (a n).encoder, (a n).decoder ∘ (restricted n hfit).decoder)
  let fallback (n : ℕ) :=
    (fun _ : Fin n → S => (B n).encoder ⟨0, hL n⟩,
     fun _ : Fin n → Y => (a n).decoder ⟨0, hK n⟩)
  let code (n : ℕ) := if hfit : 0 < n ∧ K n ≤ L n then separated n hfit.2 else fallback n
  have branches (n : ℕ) :
      (∀ hfit : 0 < n ∧ K n ≤ L n, code n = separated n hfit.2) ∧
      (¬ (0 < n ∧ K n ≤ L n) → code n = fallback n) :=
    ⟨fun hfit => dif_pos hfit, fun hfit => dif_neg hfit⟩
  -- On the fitting tail the induced-prior error is bounded by the old maximum.
  refine ⟨fun n => (code n).1, fun n => (code n).2, ?_⟩
  have upper : ∀ᶠ n in atTop, sourceChannelErrorProbability p W n (code n).1 (code n).2 ≤
      (a n).errorProbability (PMF.iid p n) + (B n).maximalErrorProbability W (hL n) := by
    filter_upwards [eventuallyFit] with n hn
    rw [(branches n).1 hn]
    let b := restricted n hn.2
    let π := (PMF.iid p n).map (a n).encoder
    have hmax : b.maximalErrorProbability W (hK n) ≤ (B n).maximalErrorProbability W (hL n) := by
      apply (b.maximalErrorProbability_le_iff W (hK n) _).mpr
      intro j
      exact ((B n).messageErrorProbability_restrictMessages_le W (Fin.castLEEmb hn.2)
        ⟨0, hK n⟩ j).trans (((B n).maximalErrorProbability_le_iff W (hL n) _).mp le_rfl _)
    exact (sourceChannelErrorProbability_comp_le p W (a n) b).trans
      (add_le_add le_rfl ((b.errorProbabilityWithPrior_le_maximalErrorProbability W π (hK n)).trans
        hmax))
  exact squeeze_zero' (Eventually.of_forall fun _ => decodingErrorProbability_nonneg _ _) upper
    (by simpa only [add_zero] using hSourceError.add hMaxError)

end LeanInfoTheory.Shannon
