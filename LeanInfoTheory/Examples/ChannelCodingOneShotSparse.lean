/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCodingOneShot
import LeanInfoTheory.Examples.RandomCodebook
import Batteries.Tactic.OpenPrivate

/-!
# Supported selection for a sparse word prior

Two independent draws from the prior on 00 and 11 collide with probability
5/8. Under the identity channel and word-equality decoding, a collision costs
1/2 and distinct words cost zero. Selection at the actual mean 5/16 therefore
forces the two labels of the selected book to carry distinct supported words.
-/

namespace LeanInfoTheory.Examples.ChannelCodingOneShotSparse

open LeanInfoTheory.Shannon

noncomputable section

open private biased repeated repeatedPrior repeated_ne repeated_mass repeatedBook
  repeated_weighted_books repeated_collision_mass decoder_two from
  LeanInfoTheory.Examples.RandomCodebook

private abbrev Word := Fin 2 → Bool
private abbrev Book := Fin 2 → Word
private abbrev books : PMF Book := PMF.iid repeatedPrior 2
private def sameWord : Set (Word × Word) := {z | z.1 = z.2}

example : (repeatedPrior (repeated false)).toReal = 3 / 4 ∧
    (repeatedPrior (repeated true)).toReal = 1 / 4 := by
  norm_num [repeated_mass, repeated_ne, Ne.symm repeated_ne]

private def rowError (b : Book) : ℝ :=
  (1 / (2 : ℝ)) * ∑ m : Fin 2, ((PMF.pure (b m)).toOuterMeasure
    {y | (BlockChannelCode.ofAcceptanceEvent b sameWord (by decide)).decoder y ≠ m}).toReal

private theorem rowError_eq (b : Book) :
    rowError b = if b 0 = b 1 then 1 / 2 else 0 := by
  classical
  unfold rowError
  rw [Fin.sum_univ_two]
  simp only [PMF.toOuterMeasure_pure_apply, Set.mem_ofPred_eq]
  by_cases h : b 0 = b 1
  · norm_num [decoder_two, sameWord, h]
  · norm_num [decoder_two, sameWord, h, Ne.symm h]

private theorem weighted_mean : (∑ b, (books b).toReal * rowError b) = 5 / 16 := by
  rw [repeated_weighted_books]
  norm_num [rowError_eq, repeatedBook, repeated_ne, Ne.symm repeated_ne]

private theorem sent_miss :
    ((PMF.channelJoint repeatedPrior PMF.pure).toOuterMeasure sameWordᶜ).toReal = 0 := by
  have h : (PMF.channelJoint repeatedPrior PMF.pure).toOuterMeasure sameWordᶜ = 0 := by
    rw [PMF.toOuterMeasure_apply_eq_zero_iff, Set.disjoint_left]
    rintro ⟨x, y⟩ hxy hmiss
    have hy := ((PMF.mem_support_channelJoint_iff repeatedPrior PMF.pure x y).1 hxy).2
    have heq : y = x := by simpa using hy
    exact hmiss heq.symm
  rw [h, ENNReal.toReal_zero]

private theorem false_pass :
    ((indepProd repeatedPrior (repeatedPrior.bind PMF.pure)).toOuterMeasure sameWord).toReal =
      5 / 8 := by
  have hp : books.map (fun b => (b 0, b 1)) = indepProd repeatedPrior repeatedPrior :=
    PMF.finiteProduct_map_pair (fun _ : Fin 2 => repeatedPrior) (i := 0) (j := 1) (by decide)
  rw [PMF.bind_pure, ← hp, PMF.toOuterMeasure_map_apply]
  exact repeated_collision_mass

private theorem event_bound :
    ((PMF.channelJoint repeatedPrior PMF.pure).toOuterMeasure sameWordᶜ).toReal +
      ((2 : ℝ) - 1) *
        ((indepProd repeatedPrior (repeatedPrior.bind PMF.pure)).toOuterMeasure sameWord).toReal =
      5 / 8 := by
  rw [sent_miss, false_pass]
  norm_num

example : ∃ b ∈ books.support, rowError b ≤ 5 / 8 := by
  rw [← event_bound]
  exact exists_mem_support_codebook_error_le repeatedPrior PMF.pure sameWord (by decide : 1 ≤ 2)

example : ∀ b ∈ books.support, rowError b ≤ 5 / 8 := by
  intro b _
  rw [rowError_eq]
  split <;> norm_num

private theorem supported_words (b : Book) (hb : b ∈ books.support) (i : Fin 2) :
    b i = repeated false ∨ b i = repeated true := by
  have hi := (PMF.mem_support_finiteProduct_iff (fun _ : Fin 2 => repeatedPrior) b).1 hb i
  obtain ⟨a, _, ha⟩ := (PMF.mem_support_map_iff repeated biased (b i)).1 hi
  cases a with
  | false => exact Or.inl ha.symm
  | true => exact Or.inr ha.symm

open private exists_mem_support_le_mean from LeanInfoTheory.Shannon.ChannelCodingOneShot in
example : ∃ b ∈ books.support, rowError b ≤ 5 / 16 ∧
    (∀ i, b i = repeated false ∨ b i = repeated true) ∧ b 0 ≠ b 1 ∧ rowError b = 0 := by
  obtain ⟨b, hb, hmean⟩ := exists_mem_support_le_mean books rowError
  rw [weighted_mean] at hmean
  have hne : b 0 ≠ b 1 := by
    intro heq
    rw [rowError_eq, if_pos heq] at hmean
    norm_num at hmean
  exact ⟨b, hb, hmean, supported_words b hb, hne, (rowError_eq b).trans (if_neg hne)⟩

end

end LeanInfoTheory.Examples.ChannelCodingOneShotSparse
