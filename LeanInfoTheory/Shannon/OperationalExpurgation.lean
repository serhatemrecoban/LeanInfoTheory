/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCodeExpurgation
import LeanInfoTheory.Shannon.CodingRate

/-!
# Expurgation along a family of block codes

At each length retain every message index whose error is at most twice the
uniform mean. CT91 §8.7 reindexes a reliable half at a cost of one bit per
block. The full retained family here loses at most that amount and serves
every positive rate tolerance for the original family.
-/

namespace LeanInfoTheory.Shannon

open Filter

universe u v

/-- A positive-budget family with vanishing average error admits one family of full
good-index restrictions with vanishing maximal error. At positive lengths its rate
loss is at most `log 2 / n` nats per use, so it meets the same eventual rate floors. -/
theorem exists_expurgated_family_of_tendsto_errorProbability {X : Type u} {Y : Type v} [Fintype Y]
    (W : X → PMF Y) (R : ℝ) (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode X Y n (M n))
    (he : Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0))
    (hr : ∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (M n)) :
    ∃ (L : ℕ → ℕ) (hL : ∀ n, 1 ≤ L n) (D : ∀ n, BlockChannelCode X Y n (L n)),
      (∀ n, (M n + 1) / 2 ≤ L n ∧ ∃ i : Fin (L n) ↪ Fin (M n),
        Set.range i = {m | (c n).messageErrorProbability W m ≤
          2 * (c n).errorProbability W (hM n)} ∧
        D n = (c n).restrictMessages i ⟨0, hL n⟩) ∧
      (∀ n, (D n).maximalErrorProbability W (hL n) ≤
        2 * (c n).errorProbability W (hM n)) ∧
      Tendsto (fun n => (D n).maximalErrorProbability W (hL n)) atTop (nhds 0) ∧
      (∀ n, 0 < n → codeRate n (M n) - Real.log 2 / (n : ℝ) ≤ codeRate n (L n)) ∧
      ∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (L n) := by
  classical
  have hstep (n : ℕ) :
      ∃ (l : ℕ) (hl : 1 ≤ l) (d : BlockChannelCode X Y n l),
        ((M n + 1) / 2 ≤ l ∧ ∃ i : Fin l ↪ Fin (M n),
          Set.range i = {m | (c n).messageErrorProbability W m ≤
            2 * (c n).errorProbability W (hM n)} ∧
          d = (c n).restrictMessages i ⟨0, hl⟩) ∧
        d.maximalErrorProbability W hl ≤ 2 * (c n).errorProbability W (hM n) := by
    let G := Finset.univ.filter (fun m => (c n).messageErrorProbability W m ≤
      2 * (c n).errorProbability W (hM n))
    obtain ⟨hG, i, hhalf, hrange, hfit⟩ := (c n).exists_expurgated_restrictions W (hM n)
    obtain ⟨d, hd, hmax, _⟩ := hfit G.card hG le_rfl
    have hcast : (Fin.castLEEmb (le_refl G.card)).trans i = i := by
      ext j
      rfl
    refine ⟨G.card, hG, d, ⟨hhalf, i, hrange.trans ?_, ?_⟩, hmax⟩
    · exact Finset.coe_filter_univ _
    · simpa only [hcast] using hd
  choose L hL D hretain hmax using hstep
  have hloss (n : ℕ) (hn : 0 < n) :
      codeRate n (M n) - Real.log 2 / (n : ℝ) ≤ codeRate n (L n) := by
    have hhalf := (hretain n).1
    exact codeRate_sub_log_two_div_le_of_le_two_mul hn (hM n) (by omega)
  refine ⟨L, hL, D, hretain, hmax, ?_, hloss, ?_⟩
  · refine squeeze_zero ?_ hmax ?_
    · intro n
      let π := PMF.pure (⟨0, hL n⟩ : Fin (L n))
      exact (show 0 ≤ (D n).errorProbabilityWithPrior W π from
        decodingErrorProbability_nonneg _ _).trans
          ((D n).errorProbabilityWithPrior_le_maximalErrorProbability W π (hL n))
    · have hlim := he.const_mul (2 : ℝ)
      rw [mul_zero] at hlim
      exact hlim
  · intro δ hδ
    have hhalf : 0 < δ / 2 := half_pos hδ
    have htail : ∀ᶠ n : ℕ in atTop, 0 < n ∧ Real.log 2 / (n : ℝ) < δ / 2 :=
      (eventually_gt_atTop (0 : ℕ)).and
        ((tendsto_const_div_atTop_nhds_zero_nat (Real.log 2)).eventually (gt_mem_nhds hhalf))
    filter_upwards [hr (δ / 2) hhalf, htail] with n hrate hn
    linarith only [hrate, hloss n hn.1, hn.2]

end LeanInfoTheory.Shannon
