/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCode

/-!
# Message-index error for a block channel code

Sending a particular message index fixes the input word and hence the
memoryless output law. The total decoder succeeds precisely when it returns
that index, even if another index encodes the same word. Under any prior on
the indices, the decoding error is their weighted mean and is bounded by the
largest row error. The uniform prior recovers the released block error.

The sent-index, maximal and uniform-average errors follow CT91 §8.5.
-/

namespace LeanInfoTheory.Shannon

noncomputable section

open scoped BigOperators

universe u v

namespace BlockChannelCode

variable {X : Type u} {Y : Type v} [Fintype Y] {n M : ℕ}

/-- Failure probability under the channel row of the sent index. It is
defined independently of how often that index is sent. -/
def messageErrorProbability (c : BlockChannelCode X Y n M)
    (W : X → PMF Y) (m : Fin M) : ℝ :=
  ∑ y, if c.decoder y ≠ m then (PMF.memorylessChannel W n (c.encoder m) y).toReal else 0

/-- Uniform block error is the arithmetic mean of the errors at the original
message indices, including any indices with identical codewords. -/
theorem errorProbability_eq_mean_messageErrorProbability
    (c : BlockChannelCode X Y n M) (W : X → PMF Y) (hM : 1 ≤ M) :
    c.errorProbability W hM = (1 / (M : ℝ)) * ∑ m, c.messageErrorProbability W m :=
  c.errorProbability_eq_sum W hM

/-- Decoding error for the joint law obtained by sampling an index from the
supplied prior and then sampling its channel output. -/
def errorProbabilityWithPrior (c : BlockChannelCode X Y n M)
    (W : X → PMF Y) (π : PMF (Fin M)) : ℝ :=
  decodingErrorProbability
    (PMF.channelJoint π (fun m => PMF.memorylessChannel W n (c.encoder m))) c.decoder

/-- Weighting each row error by the mass of its sent index gives the actual
decoding error under the supplied prior. -/
theorem errorProbabilityWithPrior_eq_sum (c : BlockChannelCode X Y n M)
    (W : X → PMF Y) (π : PMF (Fin M)) :
    c.errorProbabilityWithPrior W π = ∑ m, (π m).toReal * c.messageErrorProbability W m := by
  classical
  rw [errorProbabilityWithPrior, decodingErrorProbability_eq_sum, Fintype.sum_prod_type]
  apply Finset.sum_congr rfl
  intro m _
  rw [messageErrorProbability, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro y _
  by_cases h : c.decoder y ≠ m <;> simp [h, PMF.channelJoint_apply, ENNReal.toReal_mul]

/-- Sampling uniformly on the positive message budget gives the released
uniform-message block error. -/
theorem errorProbabilityWithPrior_uniformOfFintype (c : BlockChannelCode X Y n M)
    (W : X → PMF Y) (hM : 1 ≤ M) :
    letI : Nonempty (Fin M) := ⟨⟨0, hM⟩⟩
    c.errorProbabilityWithPrior W (PMF.uniformOfFintype (Fin M)) = c.errorProbability W hM :=
  rfl

/-- A point-mass prior selects the error of that message index. -/
theorem errorProbabilityWithPrior_pure (c : BlockChannelCode X Y n M)
    (W : X → PMF Y) (m : Fin M) :
    c.errorProbabilityWithPrior W (PMF.pure m) = c.messageErrorProbability W m := by
  classical
  simp [errorProbabilityWithPrior_eq_sum, PMF.pure_apply, apply_ite, ite_mul]

/-- Largest sent-index error over a positive message budget. -/
def maximalErrorProbability (c : BlockChannelCode X Y n M)
    (W : X → PMF Y) (hM : 1 ≤ M) : ℝ :=
  Finset.univ.sup' ⟨⟨0, hM⟩, Finset.mem_univ _⟩ (c.messageErrorProbability W)

/-- Bounding the maximal error is equivalent to bounding every sent-index
error by the same real number. -/
theorem maximalErrorProbability_le_iff (c : BlockChannelCode X Y n M)
    (W : X → PMF Y) (hM : 1 ≤ M) (b : ℝ) :
    c.maximalErrorProbability W hM ≤ b ↔ ∀ m, c.messageErrorProbability W m ≤ b := by
  exact (Finset.sup'_le_iff (s := Finset.univ)
    (show (Finset.univ : Finset (Fin M)).Nonempty from ⟨⟨0, hM⟩, Finset.mem_univ _⟩)
    (c.messageErrorProbability W)).trans (by simp only [Finset.mem_univ, forall_const])

/-- The maximum controls the error of the same code under every message prior. -/
theorem errorProbabilityWithPrior_le_maximalErrorProbability (c : BlockChannelCode X Y n M)
    (W : X → PMF Y) (π : PMF (Fin M)) (hM : 1 ≤ M) :
    c.errorProbabilityWithPrior W π ≤ c.maximalErrorProbability W hM := by
  rw [errorProbabilityWithPrior_eq_sum]
  calc
    ∑ m, (π m).toReal * c.messageErrorProbability W m ≤
        ∑ m, (π m).toReal * c.maximalErrorProbability W hM := by
      apply Finset.sum_le_sum
      intro m _
      exact mul_le_mul_of_nonneg_left
        ((c.maximalErrorProbability_le_iff W hM _).mp le_rfl m) (π.toReal_nonneg m)
    _ = c.maximalErrorProbability W hM := by rw [← Finset.sum_mul, π.sum_toReal, one_mul]

variable {K : ℕ}

/-- Retain the indices specified by an embedding. Invert that embedding on
retained decoder outputs and send all other decoder outputs to the fallback. -/
def restrictMessages (c : BlockChannelCode X Y n M) (i : Fin K ↪ Fin M)
    (j₀ : Fin K) : BlockChannelCode X Y n K :=
  (fun j => c.encoder (i j), fun y => Function.extend i id (fun _ => j₀) (c.decoder y))

omit [Fintype Y] in
/-- A correct decision on a retained index remains correct after restriction. -/
theorem restrictMessages_decoder_of_eq (c : BlockChannelCode X Y n M)
    (i : Fin K ↪ Fin M) (j₀ : Fin K) (y : Fin n → Y) (j : Fin K)
    (h : c.decoder y = i j) : (c.restrictMessages i j₀).decoder y = j := by
  change Function.extend i id (fun _ => j₀) (c.decoder y) = j
  rw [h]
  exact i.injective.extend_apply id (fun _ => j₀) j

/-- Restricting the message set can only decrease the error of a retained
index. The transmitted word and its channel row are the same in both codes. -/
theorem messageErrorProbability_restrictMessages_le (c : BlockChannelCode X Y n M)
    (W : X → PMF Y) (i : Fin K ↪ Fin M) (j₀ j : Fin K) :
    (c.restrictMessages i j₀).messageErrorProbability W j ≤
      c.messageErrorProbability W (i j) := by
  unfold messageErrorProbability
  apply Finset.sum_le_sum
  intro y _
  by_cases h : c.decoder y = i j
  · simp [h, c.restrictMessages_decoder_of_eq i j₀ y j h]
  · rw [if_pos h]
    split
    · exact le_rfl
    · exact ENNReal.toReal_nonneg


open scoped Classical in
/-- At least half the original message indices, rounded up, have row error at most
twice the uniform mean. At zero mean every index meets the threshold. -/
theorem half_le_card_filter_messageErrorProbability (c : BlockChannelCode X Y n M)
    (W : X → PMF Y) (hM : 1 ≤ M) :
    (M + 1) / 2 ≤ (Finset.univ.filter (fun m =>
      c.messageErrorProbability W m ≤ 2 * c.errorProbability W hM)).card := by
  classical
  let row := c.messageErrorProbability W
  let e := c.errorProbability W hM
  let good := Finset.univ.filter (fun m => row m ≤ 2 * e)
  change (M + 1) / 2 ≤ good.card
  have hrow (m : Fin M) : 0 ≤ row m := by
    rw [show row m = c.errorProbabilityWithPrior W (PMF.pure m) from
      (c.errorProbabilityWithPrior_pure W m).symm]
    exact decodingErrorProbability_nonneg _ _
  have hsum : ∑ m, row m = (M : ℝ) * e := by
    have hM0 : (M : ℝ) ≠ 0 := by exact_mod_cast (show M ≠ 0 by omega)
    dsimp only [e, row]
    rw [c.errorProbability_eq_mean_messageErrorProbability W hM]
    field_simp
  by_cases hz : e = 0
  · have hzero : ∀ m, row m = 0 := fun m =>
      (Finset.sum_eq_zero_iff_of_nonneg (fun j _ => hrow j)).mp
        (by simpa [hz] using hsum) m (Finset.mem_univ _)
    have hall : good = Finset.univ := by simp [good, hz, hzero]
    rw [hall, Finset.card_univ, Fintype.card_fin]
    omega
  · have he : 0 < e := lt_of_le_of_ne (c.errorProbability_nonneg W hM) (Ne.symm hz)
    let bad := Finset.univ.filter (fun m => ¬ row m ≤ 2 * e)
    have hpart : good.card + bad.card = M := by
      simpa only [Finset.card_univ, Fintype.card_fin] using
        (Finset.card_filter_add_card_filter_not (s := Finset.univ) (fun m => row m ≤ 2 * e))
    have hbad : (2 * (bad.card : ℝ)) * e ≤ (M : ℝ) * e := calc
      _ = ∑ _m ∈ bad, 2 * e := by
        rw [Finset.sum_const, nsmul_eq_mul]
        ring
      _ ≤ ∑ m ∈ bad, row m := by
        apply Finset.sum_le_sum
        intro m hm
        exact (lt_of_not_ge (Finset.mem_filter.mp hm).2).le
      _ ≤ ∑ m, row m := Finset.sum_le_sum_of_subset_of_nonneg
        (Finset.subset_univ _) fun m _ _ => hrow m
      _ = (M : ℝ) * e := hsum
    have hcount : 2 * bad.card ≤ M := by
      exact_mod_cast (mul_le_mul_iff_left₀ he).mp hbad
    omega

/-- Enumerate all indices with error at most twice the uniform mean. Each
positive requested budget up to that count has one restriction whose maximal
error, and hence its error under every prior, obeys the same bound. -/
theorem exists_expurgated_restrictions (c : BlockChannelCode X Y n M)
    (W : X → PMF Y) (hM : 1 ≤ M) :
    let G := Finset.univ.filter
      (fun m => c.messageErrorProbability W m ≤ 2 * c.errorProbability W hM)
    ∃ (_hL : 1 ≤ G.card) (i : Fin G.card ↪ Fin M),
      (M + 1) / 2 ≤ G.card ∧ Set.range i = (G : Set (Fin M)) ∧
      ∀ (K : ℕ) (hK : 1 ≤ K) (hKL : K ≤ G.card),
        ∃ d : BlockChannelCode X Y n K,
          d = c.restrictMessages ((Fin.castLEEmb hKL).trans i) ⟨0, hK⟩ ∧
          d.maximalErrorProbability W hK ≤ 2 * c.errorProbability W hM ∧
          ∀ π : PMF (Fin K), d.errorProbabilityWithPrior W π ≤
            2 * c.errorProbability W hM := by
  classical
  let G := Finset.univ.filter
    (fun m => c.messageErrorProbability W m ≤ 2 * c.errorProbability W hM)
  have hhalf : (M + 1) / 2 ≤ G.card :=
    c.half_le_card_filter_messageErrorProbability W hM
  have hL : 1 ≤ G.card := by omega
  let i := G.equivFin.symm.toEmbedding.trans (Function.Embedding.subtype (· ∈ G))
  refine ⟨hL, i, hhalf, ?_, ?_⟩
  · ext m
    constructor
    · rintro ⟨j, rfl⟩
      exact (G.equivFin.symm j).property
    · intro hm
      refine ⟨G.equivFin ⟨m, hm⟩, ?_⟩
      change (G.equivFin.symm (G.equivFin ⟨m, hm⟩)).val = m
      rw [Equiv.symm_apply_apply]
  · intro K hK hKL
    let k := (Fin.castLEEmb hKL).trans i
    let d := c.restrictMessages k ⟨0, hK⟩
    have hrow (j : Fin K) : d.messageErrorProbability W j ≤
        2 * c.errorProbability W hM := by
      have hj : k j ∈ G := (G.equivFin.symm (Fin.castLEEmb hKL j)).property
      exact (c.messageErrorProbability_restrictMessages_le W k ⟨0, hK⟩ j).trans
        (Finset.mem_filter.mp hj).2
    have hmax : d.maximalErrorProbability W hK ≤ 2 * c.errorProbability W hM :=
      (d.maximalErrorProbability_le_iff W hK _).mpr hrow
    exact ⟨d, rfl, hmax, fun π =>
      (d.errorProbabilityWithPrior_le_maximalErrorProbability W π hK).trans hmax⟩

end BlockChannelCode
end
end LeanInfoTheory.Shannon
