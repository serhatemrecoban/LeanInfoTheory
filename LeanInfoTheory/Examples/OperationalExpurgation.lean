/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.OperationalExpurgation
import LeanInfoTheory.Shannon.OperationalCapacity

/-!
# Expurgating one operational witness

Open one C31 witness and specialize two positive rate tolerances on its full
retained family. For every fitting positive budget sequence, choose a single
restricted family before evaluating its error under any sequence of priors.
-/

namespace LeanInfoTheory.Examples.OperationalExpurgation

open LeanInfoTheory.Shannon Filter

universe u v w

example {X : Type u} {Y : Type v} [Fintype Y]
    (W : X → PMF Y) {R : ℝ} (h : IsAchievableRate W R) :
    ∃ (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
        (c : ∀ n, BlockChannelCode X Y n (M n))
        (L : ℕ → ℕ) (hL : ∀ n, 1 ≤ L n)
        (D : ∀ n, BlockChannelCode X Y n (L n)),
      Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0) ∧
      (∀ n, (M n + 1) / 2 ≤ L n ∧ ∃ i : Fin (L n) ↪ Fin (M n),
        Set.range i = {m | (c n).messageErrorProbability W m ≤
          2 * (c n).errorProbability W (hM n)} ∧
        D n = (c n).restrictMessages i ⟨0, hL n⟩) ∧
      (∀ n, (D n).maximalErrorProbability W (hL n) ≤
        2 * (c n).errorProbability W (hM n)) ∧
      Tendsto (fun n => (D n).maximalErrorProbability W (hL n)) atTop (nhds 0) ∧
      (∀ n, 0 < n → codeRate n (M n) - Real.log 2 / (n : ℝ) ≤ codeRate n (L n)) ∧
      (∀ (δ₁ : ℝ), 0 < δ₁ → ∀ (δ₂ : ℝ), 0 < δ₂ →
        (∀ᶠ n in atTop, R - δ₁ ≤ codeRate n (L n)) ∧
        (∀ᶠ n in atTop, R - δ₂ ≤ codeRate n (L n))) ∧
      ∀ (K : ℕ → ℕ) (hK : ∀ n, 1 ≤ K n) (hfit : ∀ n, K n ≤ L n),
        ∃ d : ∀ n, BlockChannelCode X Y n (K n),
          (∀ n, d n = (D n).restrictMessages (Fin.castLEEmb (hfit n)) ⟨0, hK n⟩) ∧
          (∀ n (π : PMF (Fin (K n))),
            (d n).errorProbabilityWithPrior W π ≤ (d n).maximalErrorProbability W (hK n) ∧
            (d n).maximalErrorProbability W (hK n) ≤ (D n).maximalErrorProbability W (hL n)) ∧
          (∀ n {S : Type w} (p : PMF S) (f : S → Fin (K n)) (j : Fin (K n)),
            (d n).errorProbabilityWithPrior W (p.map f) ≤
              (D n).maximalErrorProbability W (hL n) ∧
            (d n).errorProbabilityWithPrior W (PMF.pure j) ≤
              (D n).maximalErrorProbability W (hL n)) ∧
          ∀ π : ∀ n, PMF (Fin (K n)),
            Tendsto (fun n => (d n).errorProbabilityWithPrior W (π n)) atTop (nhds 0) := by
  obtain ⟨_, M, hM, c, he, hr⟩ := h
  obtain ⟨L, hL, D, hretain, hmax, hzero, hloss, hfloor⟩ :=
    exists_expurgated_family_of_tendsto_errorProbability W R M hM c he hr
  refine ⟨M, hM, c, L, hL, D, he, hretain, hmax, hzero, hloss,
    fun δ₁ hδ₁ δ₂ hδ₂ => ⟨hfloor δ₁ hδ₁, hfloor δ₂ hδ₂⟩, ?_⟩
  intro K hK hfit
  let d (n : ℕ) := (D n).restrictMessages (Fin.castLEEmb (hfit n)) ⟨0, hK n⟩
  have hmaxRestrict (n : ℕ) :
      (d n).maximalErrorProbability W (hK n) ≤ (D n).maximalErrorProbability W (hL n) := by
    apply ((d n).maximalErrorProbability_le_iff W (hK n) _).mpr
    intro j
    exact ((D n).messageErrorProbability_restrictMessages_le W (Fin.castLEEmb (hfit n))
      ⟨0, hK n⟩ j).trans
        (((D n).maximalErrorProbability_le_iff W (hL n) _).mp le_rfl _)
  have hprior (n : ℕ) (π : PMF (Fin (K n))) :
      (d n).errorProbabilityWithPrior W π ≤ (D n).maximalErrorProbability W (hL n) :=
    ((d n).errorProbabilityWithPrior_le_maximalErrorProbability W π (hK n)).trans (hmaxRestrict n)
  refine ⟨d, fun _ => rfl, ?_, ?_, ?_⟩
  · exact fun n π => ⟨(d n).errorProbabilityWithPrior_le_maximalErrorProbability W π (hK n),
      hmaxRestrict n⟩
  · exact fun n _ p f j => ⟨hprior n (p.map f), hprior n (PMF.pure j)⟩
  · intro π
    exact squeeze_zero (fun n => (show 0 ≤ (d n).errorProbabilityWithPrior W (π n) from
      decodingErrorProbability_nonneg _ _)) (fun n => hprior n (π n)) hzero

end LeanInfoTheory.Examples.OperationalExpurgation
