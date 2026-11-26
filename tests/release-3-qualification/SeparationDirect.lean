/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceChannelSeparation

/-! The finite composition bound, source/channel budget fit, total families and a concentrated prior. -/

namespace LeanInfoTheory.Qualification.SeparationDirect

open LeanInfoTheory.Shannon Filter

universe u v w

variable {S : Type u} {X : Type v} {Y : Type w}

-- The first coordinate in this joint law is the source word before compression.
example [Fintype S] [Fintype Y] {n K : ℕ} (p : PMF S) (W : X → PMF Y)
    (a : BlockSourceCode S n K) (b : BlockChannelCode X Y n K) :
    decodingErrorProbability
        (PMF.channelJoint (PMF.iid p n)
          (fun s => PMF.memorylessChannel W n (b.encoder (a.encoder s))))
        (a.decoder ∘ b.decoder) ≤
      a.errorProbability (PMF.iid p n) +
        b.errorProbabilityWithPrior W ((PMF.iid p n).map a.encoder) :=
  sourceChannelErrorProbability_comp_le p W a b

-- Specialize the rate estimates from compression and full-family expurgation to the same tail.
private theorem budgets_fit (K L : ℕ → ℕ) (hK : ∀ n, 0 < K n) (hL : ∀ n, 0 < L n)
    {rs rc : ℝ} (gap : rs < rc) (sourceRate : ∀ᶠ n in atTop, codeRate n (K n) ≤ rs)
    (channelRate : ∀ ε > 0, ∀ᶠ n in atTop, rc - ε ≤ codeRate n (L n)) :
    ∀ᶠ n : ℕ in atTop, 0 < n ∧ K n ≤ L n := by
  obtain ⟨mid, hs, hc⟩ := exists_between gap
  filter_upwards [eventually_gt_atTop (0 : ℕ), sourceRate, channelRate (rc - mid) (sub_pos.mpr hc)]
    with n hn low high
  have ordered : codeRate n (K n) ≤ codeRate n (L n) := by linarith only [low, hs, high]
  have count := (codeRate_le_iff hn (hK n) _).mp ordered
  rw [exp_mul_codeRate hn (hL n)] at count
  exact ⟨hn, by exact_mod_cast count⟩

-- The same E,D cover every length. The maps at all exceptions, including zero, are explicit.
example [Fintype S] [Fintype Y] (p : PMF S) (W : X → PMF Y)
    (K L : ℕ → ℕ) (hK : ∀ n, 0 < K n) (hL : ∀ n, 0 < L n)
    (a : ∀ n, BlockSourceCode S n (K n)) (b : ∀ n, BlockChannelCode X Y n (L n))
    {rs rc : ℝ} (gap : rs < rc) (sourceRate : ∀ᶠ n in atTop, codeRate n (K n) ≤ rs)
    (channelRate : ∀ ε > 0, ∀ᶠ n in atTop, rc - ε ≤ codeRate n (L n))
    (sourceErr : Tendsto (fun n => (a n).errorProbability (PMF.iid p n)) atTop (nhds 0))
    (channelErr : Tendsto (fun n => (b n).maximalErrorProbability W (hL n)) atTop (nhds 0)) :
    ∃ (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X)) (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S)),
      (∀ n, ¬ (0 < n ∧ K n ≤ L n) →
        E n = (fun _ => (b n).encoder ⟨0, hL n⟩) ∧
        D n = (fun _ => (a n).decoder ⟨0, hK n⟩)) ∧
      (∀ᶠ n in atTop, sourceChannelErrorProbability p W n (E n) (D n) ≤
        (a n).errorProbability (PMF.iid p n) + (b n).maximalErrorProbability W (hL n)) ∧
      Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n)) atTop (nhds 0) := by
  let short (n : ℕ) (fit : K n ≤ L n) :=
    (b n).restrictMessages (Fin.castLEEmb fit) ⟨0, hK n⟩
  let E (n : ℕ) := if hf : 0 < n ∧ K n ≤ L n then (short n hf.2).encoder ∘ (a n).encoder
    else fun _ => (b n).encoder ⟨0, hL n⟩
  let D (n : ℕ) := if hf : 0 < n ∧ K n ≤ L n then (a n).decoder ∘ (short n hf.2).decoder
    else fun _ => (a n).decoder ⟨0, hK n⟩
  have tail : ∀ᶠ n in atTop, sourceChannelErrorProbability p W n (E n) (D n) ≤
      (a n).errorProbability (PMF.iid p n) + (b n).maximalErrorProbability W (hL n) := by
    filter_upwards [budgets_fit K L hK hL gap sourceRate channelRate] with n fit
    simp only [E, D, dif_pos fit]
    apply (sourceChannelErrorProbability_comp_le p W (a n) (short n fit.2)).trans
    apply add_le_add le_rfl
    apply ((short n fit.2).errorProbabilityWithPrior_le_maximalErrorProbability W _ (hK n)).trans
    apply ((short n fit.2).maximalErrorProbability_le_iff W (hK n) _).mpr
    intro j
    exact ((b n).messageErrorProbability_restrictMessages_le W (Fin.castLEEmb fit.2) ⟨0, hK n⟩ j).trans
      (((b n).maximalErrorProbability_le_iff W (hL n) _).mp le_rfl _)
  refine ⟨E, D, fun n hn => ?_, tail, ?_⟩
  · simp only [E, D, dif_neg hn, and_self]
  · exact squeeze_zero' (Eventually.of_forall fun _ => decodingErrorProbability_nonneg _ _) tail
      (by simpa using sourceErr.add channelErr)

example [Fintype S] [Fintype X] [Nonempty X] [Fintype Y] (p : PMF S) (W : X → PMF Y)
    (h : entropy p < channelCapacity W) :
    ∃ (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X)) (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S)),
      Tendsto (fun n => decodingErrorProbability
        (PMF.channelJoint (PMF.iid p n) (fun s => PMF.memorylessChannel W n (E n s))) (D n))
        atTop (nhds 0) := by
  obtain ⟨E, D, he⟩ := exists_sourceChannelCode_tendsto_errorProbability_zero p W h
  exact ⟨E, D, he⟩

namespace Concentrated

-- The permanent C33 collision sends messages 2 and 3 as the same word. The source always sends 3.
private def book : BlockChannelCode (Fin 3) (Fin 3) 1 4 :=
  (fun m _ => ![0, 1, 2, 2] m, fun y => (![0, 1, 2] : Fin 3 → Fin 4) (y 0))
private abbrev compressor : BlockSourceCode (Fin 4) 1 4 := (fun s => s 0, fun j _ => j)
private noncomputable abbrev src := PMF.pure (3 : Fin 4)
private noncomputable abbrev wire := (PMF.pure : Fin 3 → PMF (Fin 3))

private theorem rows : PMF.memorylessChannel wire 1 = PMF.pure :=
  PMF.productChannel_deterministicChannel (fun _ : Fin 1 => id (α := Fin 3))

private theorem messageFailure (m : Fin 4) :
    book.messageErrorProbability wire m = if m = 3 then 1 else 0 := by
  classical
  rw [BlockChannelCode.messageErrorProbability, rows]
  have atom (y : Fin 1 → Fin 3) :
      (if book.decoder y ≠ m then (PMF.pure (book.encoder m) y).toReal else 0) =
      (if book.encoder m = y then (if book.decoder y ≠ m then (1 : ℝ) else 0) else 0) := by
    by_cases h : book.encoder m = y
    · subst y
      simp [PMF.pure_apply]
    · simp [PMF.pure_apply, h, Ne.symm h]
  simp_rw [atom]
  simp only [Finset.sum_ite_eq, Finset.mem_univ, if_true]
  fin_cases m <;> norm_num [book, BlockChannelCode.encoder, BlockChannelCode.decoder, Fin.ext_iff] <;> decide

example :
    let p := (PMF.iid src 1).map compressor.encoder
    let e := sourceChannelErrorProbability src wire 1 (book.encoder ∘ compressor.encoder)
      (compressor.decoder ∘ book.decoder)
    let es := compressor.errorProbability (PMF.iid src 1)
    let eu := book.errorProbability wire (by decide)
    p = PMF.pure 3 ∧ es = 0 ∧ eu = 1 / 4 ∧ book.errorProbabilityWithPrior wire p = 1 ∧
      e = 1 ∧ e ≤ es + book.errorProbabilityWithPrior wire p ∧ es + eu < e := by
  dsimp only
  have sourceWord : PMF.iid src 1 = PMF.pure (fun _ : Fin 1 => (3 : Fin 4)) := PMF.finiteProduct_pure _
  have prior : (PMF.iid src 1).map compressor.encoder = PMF.pure 3 := by rw [sourceWord, PMF.pure_map]
  have uniform : book.errorProbability wire (by decide) = 1 / 4 := by
    rw [book.errorProbability_eq_mean_messageErrorProbability]
    norm_num [Fin.sum_univ_succ, messageFailure]
  have easy : compressor.errorProbability (PMF.iid src 1) = 0 := by
    rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure,
      sourceWord, PMF.toOuterMeasure_pure_apply]
    simp [compressor]
  have fails : sourceChannelErrorProbability src wire 1 (book.encoder ∘ compressor.encoder)
      (compressor.decoder ∘ book.decoder) = 1 := by
    have joint : PMF.channelJoint (PMF.iid src 1)
        (fun s => PMF.memorylessChannel wire 1 ((book.encoder ∘ compressor.encoder) s)) =
        PMF.pure ((fun _ : Fin 1 => (3 : Fin 4)), (fun _ : Fin 1 => (2 : Fin 3))) := by
      rw [sourceWord, PMF.channelJoint, PMF.pure_bind, rows, PMF.pure_map]
      rfl
    rw [sourceChannelErrorProbability, joint, decodingErrorProbability, PMF.pure_map]
    have different : (compressor.decoder ∘ book.decoder) (fun _ => 2) ≠ (fun _ : Fin 1 => 3) := by decide
    rw [(decodingErrorIndicator_eq_true_iff _ _ _).mpr different]
    simp
  refine ⟨prior, easy, uniform, ?_, fails, sourceChannelErrorProbability_comp_le src wire compressor book, ?_⟩
  · rw [prior, book.errorProbabilityWithPrior_pure, messageFailure]
    norm_num
  · rw [easy, uniform, fails]
    norm_num

end Concentrated
end LeanInfoTheory.Qualification.SeparationDirect
