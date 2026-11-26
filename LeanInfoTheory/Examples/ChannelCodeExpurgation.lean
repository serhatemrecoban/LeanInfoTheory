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
# Sent-index, arbitrary-prior and maximal error consumers

The focused interface keeps message labels even when their words collide.
The code has error one when its never-decoded label is sent and zero when
its correctly decoded label is sent. Uniform averaging retains both labels.
-/

namespace LeanInfoTheory.Examples.ChannelCodeExpurgation

noncomputable section

open LeanInfoTheory.Shannon
open scoped BigOperators

universe u v

example {X : Type u} {Y : Type v} [Fintype Y] {n M : ℕ}
    (c : BlockChannelCode X Y n M) (W : X → PMF Y) (hM : 1 ≤ M) :
    c.errorProbability W hM =
      (1 / (M : ℝ)) * ∑ m, c.messageErrorProbability W m :=
  c.errorProbability_eq_mean_messageErrorProbability W hM

example {X : Type u} {Y : Type v} [Fintype Y] {n M : ℕ}
    (c : BlockChannelCode X Y n M) (W : X → PMF Y)
    (π : PMF (Fin M)) (hM : 1 ≤ M) :
    c.errorProbabilityWithPrior W π ≤ c.maximalErrorProbability W hM :=
  c.errorProbabilityWithPrior_le_maximalErrorProbability W π hM

example {X : Type u} {Y : Type v} [Fintype Y] {n M : ℕ}
    (c : BlockChannelCode X Y n M) (W : X → PMF Y) (m : Fin M) :
    0 ≤ c.messageErrorProbability W m ∧ c.messageErrorProbability W m ≤ 1 := by
  rw [← c.errorProbabilityWithPrior_pure W m]
  exact ⟨decodingErrorProbability_nonneg _ _, decodingErrorProbability_le_one _ _⟩

example {X : Type u} {Y : Type v} [Fintype Y] {n M : ℕ}
    (c : BlockChannelCode X Y n M) (W : X → PMF Y) (hM : 1 ≤ M) :
    0 ≤ c.maximalErrorProbability W hM ∧ c.maximalErrorProbability W hM ≤ 1 := by
  have hrow (m : Fin M) : 0 ≤ c.messageErrorProbability W m ∧
      c.messageErrorProbability W m ≤ 1 := by
    rw [← c.errorProbabilityWithPrior_pure W m]
    exact ⟨decodingErrorProbability_nonneg _ _, decodingErrorProbability_le_one _ _⟩
  have hle := (c.maximalErrorProbability_le_iff W hM
    (c.maximalErrorProbability W hM)).mp le_rfl
  exact ⟨(hrow ⟨0, hM⟩).1.trans (hle _),
    (c.maximalErrorProbability_le_iff W hM 1).mpr fun m => (hrow m).2⟩

example {X : Type u} {Y : Type v} [Fintype Y] {n M : ℕ}
    (c : BlockChannelCode X Y n M) (W : X → PMF Y) (hM : 1 ≤ M) :
    letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
    c.errorProbabilityWithPrior W (PMF.uniformOfFintype (Fin M)) =
      c.errorProbability W hM :=
  c.errorProbabilityWithPrior_uniformOfFintype W hM

private def repeated : BlockChannelCode Bool Bool 1 2 :=
  (fun _ _ => false, fun _ => 0)

private theorem repeated_rows (m : Fin 2) :
    repeated.messageErrorProbability (PMF.pure : Bool → PMF Bool) m =
      if m = 0 then 0 else 1 := by
  classical
  fin_cases m
  · simp [BlockChannelCode.messageErrorProbability, repeated, BlockChannelCode.decoder]
  · change (∑ y : Fin 1 → Bool, if (0 : Fin 2) ≠ 1 then
      (PMF.memorylessChannel (PMF.pure : Bool → PMF Bool) 1 (fun _ => false) y).toReal
      else 0) = 1
    norm_num only [Fin.isValue, ne_eq, Fin.reduceEq, not_false_eq_true, ite_true]
    exact PMF.sum_toReal (PMF.memorylessChannel (PMF.pure : Bool → PMF Bool) 1
      (fun _ => false))

example : repeated.encoder 0 = repeated.encoder 1 ∧
    (∀ y, repeated.decoder y ≠ 1) ∧
    repeated.messageErrorProbability (PMF.pure : Bool → PMF Bool) 0 = 0 ∧
    repeated.messageErrorProbability (PMF.pure : Bool → PMF Bool) 1 = 1 := by
  exact ⟨rfl, fun _ => by change (0 : Fin 2) ≠ 1; decide,
    by simp [repeated_rows], by simp [repeated_rows]⟩

example : repeated.errorProbability (PMF.pure : Bool → PMF Bool) (by decide) = 1 / 2 := by
  rw [repeated.errorProbability_eq_mean_messageErrorProbability]
  norm_num [Fin.sum_univ_succ, repeated_rows]

example : repeated.errorProbabilityWithPrior (PMF.pure : Bool → PMF Bool)
    (PMF.pure 0) = 0 ∧
    repeated.errorProbabilityWithPrior (PMF.pure : Bool → PMF Bool) (PMF.pure 1) = 1 := by
  simp [BlockChannelCode.errorProbabilityWithPrior_pure, repeated_rows]

example : repeated.maximalErrorProbability (PMF.pure : Bool → PMF Bool) (by decide) = 1 := by
  apply le_antisymm
  · apply (repeated.maximalErrorProbability_le_iff _ _ _).mpr
    intro m
    simp only [repeated_rows]
    split <;> norm_num
  · have h := (repeated.maximalErrorProbability_le_iff _ _
      (repeated.maximalErrorProbability (PMF.pure : Bool → PMF Bool) (by decide))).mp le_rfl
    simpa [repeated_rows] using h 1

private def noLetters : Empty → PMF Empty := fun x => nomatch x
private def emptyWords : BlockChannelCode Empty Empty 0 2 :=
  (fun _ i => Fin.elim0 i, fun _ => 0)

example : emptyWords.errorProbabilityWithPrior noLetters (PMF.pure 1) = 1 := by
  rw [emptyWords.errorProbabilityWithPrior_pure]
  change (∑ y, if (0 : Fin 2) ≠ 1 then
    (PMF.memorylessChannel noLetters 0 (emptyWords.encoder 1) y).toReal else 0) = 1
  simpa using PMF.sum_toReal (PMF.memorylessChannel noLetters 0 (emptyWords.encoder 1))

/-! Restriction preserves old correct decisions and transports the message prior. -/

example {X : Type u} {Y : Type v} {n M K : ℕ}
    (c : BlockChannelCode X Y n M) (i : Fin K ↪ Fin M) (j₀ j : Fin K) :
    (c.restrictMessages i j₀).encoder j = c.encoder (i j) := rfl

example {X : Type u} {Y : Type v} {n M K : ℕ}
    (c : BlockChannelCode X Y n M) (i : Fin K ↪ Fin M) (j₀ : Fin K)
    (y : Fin n → Y) (h : ¬ ∃ j, i j = c.decoder y) :
    (c.restrictMessages i j₀).decoder y = j₀ := by
  exact Function.extend_apply' (f := i) id (fun _ => j₀) (c.decoder y) h

private theorem sum_map_toReal_mul {A : Type u} {B : Type v}
    [Fintype A] [Fintype B] (p : PMF A) (f : A → B) (g : B → ℝ) :
    (∑ b, (p.map f b).toReal * g b) = ∑ a, (p a).toReal * g (f a) := by
  classical
  simp only [PMF.map, PMF.bind_toReal_apply, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  simp [PMF.pure_apply, apply_ite, ite_mul]

private theorem error_restrict_le {X : Type u} {Y : Type v} [Fintype Y]
    {n M K : ℕ} (c : BlockChannelCode X Y n M) (W : X → PMF Y)
    (i : Fin K ↪ Fin M) (j₀ : Fin K) (π : PMF (Fin K)) :
    (c.restrictMessages i j₀).errorProbabilityWithPrior W π ≤
      c.errorProbabilityWithPrior W (π.map i) := by
  simp_rw [BlockChannelCode.errorProbabilityWithPrior_eq_sum]
  rw [sum_map_toReal_mul]
  apply Finset.sum_le_sum
  intro j _
  exact mul_le_mul_of_nonneg_left
    (c.messageErrorProbability_restrictMessages_le W i j₀ j) (π.toReal_nonneg j)

example {X : Type u} {Y : Type v} [Fintype Y] {n M K L : ℕ}
    (c : BlockChannelCode X Y n M) (W : X → PMF Y)
    (i : Fin K ↪ Fin M) (j₀ : Fin K) (k : Fin L ↪ Fin K) (l₀ j : Fin L) :
    ((c.restrictMessages i j₀).restrictMessages k l₀).messageErrorProbability W j ≤
      c.messageErrorProbability W (i (k j)) :=
  ((c.restrictMessages i j₀).messageErrorProbability_restrictMessages_le W k l₀ j).trans
    (c.messageErrorProbability_restrictMessages_le W i j₀ (k j))

private def collision : BlockChannelCode (Fin 3) (Fin 3) 1 4 :=
  (fun m _ => ![0, 1, 2, 2] m, fun y => (![0, 1, 2] : Fin 3 → Fin 4) (y 0))

private def keepZeroThree : Fin 2 ↪ Fin 4 := ⟨![0, 3], by decide⟩

private theorem noiseless_row {M : ℕ} (c : BlockChannelCode (Fin 3) (Fin 3) 1 M)
    (m : Fin M) :
    c.messageErrorProbability (PMF.pure : Fin 3 → PMF (Fin 3)) m =
      if c.decoder (c.encoder m) ≠ m then 1 else 0 := by
  classical
  have hrow : PMF.memorylessChannel (PMF.pure : Fin 3 → PMF (Fin 3)) 1 =
      PMF.pure := by
    exact PMF.productChannel_deterministicChannel (fun _ : Fin 1 => id (α := Fin 3))
  rw [BlockChannelCode.messageErrorProbability, hrow]
  calc
    (∑ y, if c.decoder y ≠ m then (PMF.pure (c.encoder m) y).toReal else 0) =
        ∑ y, if c.encoder m = y then (if c.decoder y ≠ m then (1 : ℝ) else 0) else 0 := by
      apply Finset.sum_congr rfl
      intro y _
      by_cases h : y = c.encoder m
      · subst y
        simp [PMF.pure_apply]
      · simp [PMF.pure_apply, h, Ne.symm h]
    _ = _ := by simp

private theorem collision_rows (m : Fin 4) :
    collision.messageErrorProbability (PMF.pure : Fin 3 → PMF (Fin 3)) m =
      if m = 3 then 1 else 0 := by
  rw [noiseless_row]
  fin_cases m <;>
    norm_num [collision, BlockChannelCode.encoder, BlockChannelCode.decoder, Fin.ext_iff] <;>
    decide

private theorem restricted_decode_zero (b : Fin 2) :
    (collision.restrictMessages keepZeroThree b).decoder (fun _ => 0) = 0 := by
  apply collision.restrictMessages_decoder_of_eq keepZeroThree b (fun _ => 0) 0
  rfl

private theorem restricted_decode_two (b : Fin 2) :
    (collision.restrictMessages keepZeroThree b).decoder (fun _ => 2) = b := by
  exact Function.extend_apply' (f := keepZeroThree) id (fun _ => b)
    (collision.decoder (fun _ => 2)) (by decide)

private theorem restricted_rows (b j : Fin 2) :
    (collision.restrictMessages keepZeroThree b).messageErrorProbability
      (PMF.pure : Fin 3 → PMF (Fin 3)) j =
      if j = 0 then 0 else if b = 0 then 1 else 0 := by
  rw [noiseless_row]
  fin_cases j
  · change (if (collision.restrictMessages keepZeroThree b).decoder (fun _ => 0) ≠ 0
      then (1 : ℝ) else 0) = 0
    rw [restricted_decode_zero]
    norm_num
  · change (if (collision.restrictMessages keepZeroThree b).decoder (fun _ => 2) ≠ 1
      then (1 : ℝ) else 0) = if b = 0 then 1 else 0
    rw [restricted_decode_two]
    fin_cases b <;> norm_num

example : collision.errorProbability (PMF.pure : Fin 3 → PMF (Fin 3)) (by decide) = 1 / 4 := by
  rw [collision.errorProbability_eq_mean_messageErrorProbability]
  norm_num [Fin.sum_univ_succ, collision_rows]

example :
    collision.errorProbabilityWithPrior (PMF.pure : Fin 3 → PMF (Fin 3))
      ((PMF.uniformOfFintype (Fin 2)).map keepZeroThree) = 1 / 2 := by
  rw [collision.errorProbabilityWithPrior_eq_sum, sum_map_toReal_mul]
  norm_num [Fin.sum_univ_succ, PMF.uniformOfFintype_apply, collision_rows,
    keepZeroThree, Fin.ext_iff]

example :
    (collision.restrictMessages keepZeroThree 0).errorProbability
      (PMF.pure : Fin 3 → PMF (Fin 3)) (by decide) = 1 / 2 ∧
    (collision.restrictMessages keepZeroThree 1).errorProbability
      (PMF.pure : Fin 3 → PMF (Fin 3)) (by decide) = 0 := by
  constructor <;> rw [BlockChannelCode.errorProbability_eq_mean_messageErrorProbability] <;>
    norm_num [Fin.sum_univ_succ, restricted_rows]

example (b : Fin 2) (π : PMF (Fin 2)) :
    (collision.restrictMessages keepZeroThree b).errorProbabilityWithPrior
      (PMF.pure : Fin 3 → PMF (Fin 3)) π ≤
    collision.errorProbabilityWithPrior (PMF.pure : Fin 3 → PMF (Fin 3))
      (π.map keepZeroThree) :=
  error_restrict_le collision _ keepZeroThree b π

example :
    collision.messageErrorProbability (PMF.pure : Fin 3 → PMF (Fin 3)) 3 = 1 ∧
    (collision.restrictMessages keepZeroThree 1).messageErrorProbability
      (PMF.pure : Fin 3 → PMF (Fin 3)) 1 = 0 := by
  simp [collision_rows, restricted_rows]

example (b : Fin 2) :
    (collision.restrictMessages keepZeroThree b).decoder (fun _ => 1) = b := by
  exact Function.extend_apply' (f := keepZeroThree) id (fun _ => b)
    (collision.decoder (fun _ => 1)) (by decide)

/-! Count and exact-budget consumers select a code before its message prior. -/

example {X : Type u} {Y : Type v} [Fintype Y] {n : ℕ}
    (c : BlockChannelCode X Y n 5) (W : X → PMF Y) :
    3 ≤ (Finset.univ.filter
      (fun m => c.messageErrorProbability W m ≤ 2 * c.errorProbability W (by decide))).card := by
  simpa using c.half_le_card_filter_messageErrorProbability W (by decide)

example {X : Type u} {Y : Type v} [Fintype Y] {n M : ℕ}
    (c : BlockChannelCode X Y n M) (W : X → PMF Y) (hM : 1 ≤ M)
    (hz : c.errorProbability W hM = 0) :
    (Finset.univ.filter
      (fun m => c.messageErrorProbability W m ≤ 2 * c.errorProbability W hM)) =
      (Finset.univ : Finset (Fin M)) := by
  classical
  have hM0 : (M : ℝ) ≠ 0 := by exact_mod_cast (show M ≠ 0 by omega)
  have heq := c.errorProbability_eq_mean_messageErrorProbability W hM
  rw [hz] at heq
  have hsum : ∑ m, c.messageErrorProbability W m = 0 :=
    (mul_eq_zero.mp heq.symm).resolve_left (one_div_ne_zero hM0)
  have hrow (m : Fin M) : 0 ≤ c.messageErrorProbability W m := by
    rw [← c.errorProbabilityWithPrior_pure W m]
    exact decodingErrorProbability_nonneg _ _
  have hzero (m : Fin M) : c.messageErrorProbability W m = 0 :=
    (Finset.sum_eq_zero_iff_of_nonneg (fun j _ => hrow j)).mp hsum m (Finset.mem_univ _)
  simp [hz, hzero]

example {X : Type u} {Y : Type v} [Fintype Y] {n M K : ℕ}
    (c : BlockChannelCode X Y n M) (W : X → PMF Y) (hM : 1 ≤ M)
    (hK : 1 ≤ K) (hfit : K ≤ (Finset.univ.filter
      (fun m => c.messageErrorProbability W m ≤ 2 * c.errorProbability W hM)).card) :
    ∃ d : BlockChannelCode X Y n K,
      (∀ π : PMF (Fin K), d.errorProbabilityWithPrior W π ≤ 2 * c.errorProbability W hM) ∧
      (∀ j : Fin K, d.errorProbabilityWithPrior W (PMF.pure j) ≤
        2 * c.errorProbability W hM) := by
  obtain ⟨_, _, _, _, hbudget⟩ := c.exists_expurgated_restrictions W hM
  obtain ⟨d, _, _, hprior⟩ := hbudget K hK hfit
  exact ⟨d, hprior, fun j => hprior (PMF.pure j)⟩

example {X : Type u} {Y : Type v} [Fintype Y] {n M : ℕ}
    (c : BlockChannelCode X Y n M) (W : X → PMF Y) (hM : 1 ≤ M) :
    let G := Finset.univ.filter
      (fun m => c.messageErrorProbability W m ≤ 2 * c.errorProbability W hM)
    ∃ (hL : 1 ≤ G.card) (i : Fin G.card ↪ Fin M)
        (oneCode : BlockChannelCode X Y n 1) (fullCode : BlockChannelCode X Y n G.card),
      (∀ j, fullCode.encoder j = c.encoder (i j)) ∧
      oneCode.encoder 0 = c.encoder (i ⟨0, hL⟩) ∧
      (∀ π : PMF (Fin 1), oneCode.errorProbabilityWithPrior W π ≤
        2 * c.errorProbability W hM) ∧
      (∀ π : PMF (Fin G.card), fullCode.errorProbabilityWithPrior W π ≤
        2 * c.errorProbability W hM) ∧
      (∀ j : Fin G.card, fullCode.errorProbabilityWithPrior W (PMF.pure j) ≤
        2 * c.errorProbability W hM) := by
  classical
  obtain ⟨hL, i, _, _, hbudget⟩ := c.exists_expurgated_restrictions W hM
  obtain ⟨oneCode, hone, _, honePrior⟩ := hbudget 1 (by decide) hL
  obtain ⟨fullCode, hfull, _, hfullPrior⟩ := hbudget _ hL le_rfl
  refine ⟨hL, i, oneCode, fullCode, ?_, ?_, honePrior, hfullPrior,
    fun j => hfullPrior (PMF.pure j)⟩
  · intro j
    rw [hfull]
    rfl
  · rw [hone]
    rfl

example {X : Type u} {Y : Type v} [Fintype Y] {n : ℕ}
    (c : BlockChannelCode X Y n 1) (W : X → PMF Y) :
    (Finset.univ.filter (fun m => c.messageErrorProbability W m ≤
      2 * c.errorProbability W (by decide))).card = 1 := by
  classical
  have hrow (m : Fin 1) : c.messageErrorProbability W m = 0 := by
    have h (y : Fin n → Y) : c.decoder y = m := Subsingleton.elim _ _
    simp [BlockChannelCode.messageErrorProbability, h]
  simp [c.errorProbability_one W, hrow]

/-! Noiseless collision codes distinguish uniform error, maximal error and prior error. -/

private abbrev noiseless := (PMF.pure : Fin 3 → PMF (Fin 3))

private theorem collision_mean : collision.errorProbability noiseless (by decide) = 1 / 4 := by
  rw [collision.errorProbability_eq_mean_messageErrorProbability]
  norm_num [Fin.sum_univ_succ, collision_rows]

example : collision.errorProbabilityWithPrior noiseless (PMF.pure 3) = 1 := by
  rw [collision.errorProbabilityWithPrior_pure, collision_rows]
  norm_num

private theorem collision_good :
    Finset.univ.filter (fun m => collision.messageErrorProbability noiseless m ≤
      2 * collision.errorProbability noiseless (by decide)) = ({0, 1, 2} : Finset (Fin 4)) := by
  ext m
  fin_cases m <;> norm_num [collision_rows, collision_mean, Fin.ext_iff]

private theorem zero_max_and_priors {X : Type u} {Y : Type v} [Fintype Y] {n M : ℕ}
    (c : BlockChannelCode X Y n M) (W : X → PMF Y) (hM : 1 ≤ M)
    (hrow : ∀ j, c.messageErrorProbability W j ≤ 0) :
    c.maximalErrorProbability W hM = 0 ∧ ∀ π, c.errorProbabilityWithPrior W π = 0 := by
  have hmax := (c.maximalErrorProbability_le_iff W hM 0).mpr hrow
  have hprior (π : PMF (Fin M)) := c.errorProbabilityWithPrior_le_maximalErrorProbability W π hM
  have hnonneg (π : PMF (Fin M)) : 0 ≤ c.errorProbabilityWithPrior W π :=
    decodingErrorProbability_nonneg _ _
  let π := PMF.pure (⟨0, hM⟩ : Fin M)
  exact ⟨le_antisymm hmax ((hnonneg π).trans (hprior π)),
    fun p => le_antisymm ((hprior p).trans hmax) (hnonneg p)⟩

example :
    ∃ (i : Fin 3 ↪ Fin 4) (d : BlockChannelCode (Fin 3) (Fin 3) 1 3)
      (d₂ : BlockChannelCode (Fin 3) (Fin 3) 1 2),
      Set.range i = (↑({0, 1, 2} : Finset (Fin 4)) : Set (Fin 4)) ∧
      (∀ j, d.encoder j = collision.encoder (i j)) ∧
      d.maximalErrorProbability noiseless (by decide) = 0 ∧
      d.errorProbabilityWithPrior noiseless (PMF.pure 0) = 0 ∧
      d.errorProbabilityWithPrior noiseless (PMF.uniformOfFintype (Fin 3)) = 0 ∧
      (∀ π, d₂.errorProbabilityWithPrior noiseless π ≤ 1 / 2) := by
  classical
  have h := collision.exists_expurgated_restrictions noiseless (by decide)
  dsimp only at h
  rw [collision_good, show ({0, 1, 2} : Finset (Fin 4)).card = 3 by decide] at h
  obtain ⟨_, i, _, hrange, hbudget⟩ := h
  obtain ⟨d, hd, _, _⟩ := hbudget 3 (by decide) le_rfl
  obtain ⟨d₂, _, _, hprior₂⟩ := hbudget 2 (by decide) (by decide)
  have hrow (j : Fin 3) : d.messageErrorProbability noiseless j ≤ 0 := by
    have hj : i j ∈ ({0, 1, 2} : Finset (Fin 4)) := by
      change i j ∈ (↑({0, 1, 2} : Finset (Fin 4)) : Set (Fin 4))
      rw [← hrange]
      exact ⟨j, rfl⟩
    have hne : i j ≠ 3 := by
      intro heq
      rw [heq] at hj
      exact (by decide : (3 : Fin 4) ∉ ({0, 1, 2} : Finset (Fin 4))) hj
    rw [hd]
    exact (collision.messageErrorProbability_restrictMessages_le noiseless _ _ j).trans
      (show collision.messageErrorProbability noiseless (i j) ≤ 0 by simp [collision_rows, hne])
  obtain ⟨hmax, hprior⟩ := zero_max_and_priors d noiseless (by decide) hrow
  refine ⟨i, d, d₂, hrange, ?_, hmax, hprior _, hprior _, ?_⟩
  · intro j
    rw [hd]
    rfl
  · intro π
    have hπ := hprior₂ π
    rw [collision_mean] at hπ
    linarith only [hπ]

example : codeRate 1 4 - Real.log 2 > codeRate 1 1 := by
  have hlog : Real.log 4 = Real.log 2 + Real.log 2 := by
    rw [show (4 : ℝ) = 2 * 2 by norm_num, Real.log_mul (by norm_num) (by norm_num)]
  rw [codeRate_one, codeRate]
  norm_num only [Nat.cast_ofNat, Nat.cast_one, div_one, hlog, add_sub_cancel_right]
  exact Real.log_pos (by norm_num : (1 : ℝ) < 2)

private def oddCollision : BlockChannelCode (Fin 3) (Fin 3) 1 5 :=
  (fun m _ => ![2, 0, 2, 1, 2] m, fun y => (![1, 3, 4] : Fin 3 → Fin 5) (y 0))

private theorem odd_rows (m : Fin 5) :
    oddCollision.messageErrorProbability noiseless m = if m = 0 ∨ m = 2 then 1 else 0 := by
  rw [noiseless_row]
  have h : oddCollision.decoder (oddCollision.encoder m) ≠ m ↔ m = 0 ∨ m = 2 := by
    fin_cases m <;> decide
  simp only [h]

private theorem odd_mean : oddCollision.errorProbability noiseless (by decide) = 2 / 5 := by
  rw [oddCollision.errorProbability_eq_mean_messageErrorProbability]
  have hrow (m : Fin 5) : oddCollision.messageErrorProbability noiseless m =
      (if m = 0 then 1 else 0) + (if m = 2 then 1 else 0) := by
    rw [odd_rows]
    by_cases hz : m = 0
    · subst m
      norm_num [show (0 : Fin 5) ≠ 2 by decide]
    · simp [hz]
  simp_rw [hrow, Finset.sum_add_distrib]
  norm_num

example : ∃ i : Fin 3 ↪ Fin 5, Set.range i = (↑({1, 3, 4} : Finset (Fin 5)) : Set (Fin 5)) := by
  classical
  have hgood : Finset.univ.filter (fun m => oddCollision.messageErrorProbability noiseless m ≤
      2 * oddCollision.errorProbability noiseless (by decide)) = ({1, 3, 4} : Finset (Fin 5)) := by
    ext m
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, odd_rows, odd_mean]
    have hmem : m ∈ ({1, 3, 4} : Finset (Fin 5)) ↔ ¬ (m = 0 ∨ m = 2) := by
      fin_cases m <;> decide
    rw [hmem]
    by_cases h : m = 0 ∨ m = 2 <;> norm_num [h]
  have h := oddCollision.exists_expurgated_restrictions noiseless (by decide)
  dsimp only at h
  rw [hgood, show ({1, 3, 4} : Finset (Fin 5)).card = 3 by decide] at h
  obtain ⟨_, i, _, hrange, _⟩ := h
  exact ⟨i, hrange⟩

example {X : Type u} {Y : Type v} [Fintype Y] {n : ℕ}
    (c : BlockChannelCode X Y n 1) (W : X → PMF Y) :
    c.errorProbability W (by decide) = 0 ∧ c.maximalErrorProbability W (by decide) = 0 := by
  refine ⟨c.errorProbability_one W, (zero_max_and_priors c W (by decide) ?_).1⟩
  intro j
  have h (y : Fin n → Y) : c.decoder y = j := Subsingleton.elim _ _
  simp [BlockChannelCode.messageErrorProbability, h]

private theorem zero_length_row {X : Type u} {Y : Type v} [Fintype Y] {M : ℕ}
    (c : BlockChannelCode X Y 0 M) (W : X → PMF Y) (m : Fin M) :
    c.messageErrorProbability W m = if c.decoder default ≠ m then 1 else 0 := by
  simp only [BlockChannelCode.messageErrorProbability, PMF.memorylessChannel,
    PMF.productChannel_apply, Fin.prod_univ_zero, ENNReal.toReal_one, Fintype.sum_unique]

example {X : Type u} {Y : Type v} [Fintype Y] {M : ℕ}
    (c : BlockChannelCode X Y 0 M) (W : X → PMF Y) (hM : 1 ≤ M) :
    c.messageErrorProbability W (c.decoder default) = 0 ∧
      (∀ m, c.decoder default ≠ m → c.messageErrorProbability W m = 1) ∧
      c.errorProbability W hM = 1 - 1 / (M : ℝ) :=
  ⟨by simp [zero_length_row], fun m hm => by simp [zero_length_row, hm],
    c.errorProbability_zero W hM⟩

example {X : Type u} {Y : Type v} [Fintype Y] (c : BlockChannelCode X Y 0 2) (W : X → PMF Y) :
    (∀ m, c.decoder default ≠ m →
      c.messageErrorProbability W m = 2 * c.errorProbability W (by decide)) ∧
      ∃ i : Fin 2 ↪ Fin 2, Set.range i = Set.univ := by
  classical
  have he : c.errorProbability W (by decide) = 1 / 2 := by
    rw [c.errorProbability_zero]
    norm_num
  constructor
  · intro m hm
    rw [zero_length_row, if_pos hm, he]
    norm_num
  · have hall : Finset.univ.filter (fun m => c.messageErrorProbability W m ≤
        2 * c.errorProbability W (by decide)) = Finset.univ := by
      ext m
      by_cases hm : c.decoder default = m <;> norm_num [zero_length_row, hm, he]
    have h := c.exists_expurgated_restrictions W (by decide)
    dsimp only at h
    rw [hall, Finset.card_univ, Fintype.card_fin] at h
    obtain ⟨_, i, _, hrange, _⟩ := h
    exact ⟨i, by simpa using hrange⟩

end
end LeanInfoTheory.Examples.ChannelCodeExpurgation
