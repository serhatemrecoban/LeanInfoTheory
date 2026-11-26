/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.RandomCodebook
import LeanInfoTheory.Shannon.InformationDensity

/-!
# Random codebook callers

The sent and competing event transports allow any word law, output alphabet and
event, including at zero blocklength. The one-letter examples compare a fixed
book with the ensemble and distinguish its input and output marginals.
The deterministic decoder examples use the strict threshold set and exercise
duplicate codewords, an empty passing set and a singleton message alphabet.
-/

namespace LeanInfoTheory.Examples.RandomCodebook

open LeanInfoTheory.Shannon

universe u v

example {X : Type u} {Y : Type v} [Fintype X] {n M : ℕ}
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (m : Fin M) (S : Set ((Fin n → X) × (Fin n → Y))) :
    (codebookOutputLaw q K m).toOuterMeasure {z | (z.1 m, z.2) ∈ S} =
      (PMF.channelJoint q K).toOuterMeasure S := by
  rw [← codebookOutputLaw_map_sentOutput q K m, PMF.toOuterMeasure_map_apply]
  rfl

private theorem competing_event {X : Type u} {Y : Type v} [Fintype X] {n M : ℕ}
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (m j : Fin M) (hjm : j ≠ m) (S : Set ((Fin n → X) × (Fin n → Y))) :
    (codebookOutputLaw q K m).toOuterMeasure {z | (z.1 j, z.2) ∈ S} =
      (indepProd q (q.bind K)).toOuterMeasure S := by
  rw [← codebookOutputLaw_map_competingOutput q K m j hjm, PMF.toOuterMeasure_map_apply]
  rfl

example (q : PMF (Fin 1 → Bool)) (K : (Fin 1 → Bool) → PMF (Fin 1 → ℕ))
    (S : Set ((Fin 1 → Bool) × (Fin 1 → ℕ))) :
    (codebookOutputLaw q K (0 : Fin 2)).toOuterMeasure {z | (z.1 1, z.2) ∈ S} =
      (indepProd q (q.bind K)).toOuterMeasure S :=
  competing_event q K 0 1 (by decide) S

noncomputable section

private abbrev Word := Fin 1 → Bool
private def word (b : Bool) : Word := fun _ => b
private def bits (z : Word × Word) : Bool × Bool := (z.1 0, z.2 0)
private abbrev fair : PMF Bool := PMF.uniformOfFintype Bool

private theorem bits_mass (p : PMF (Word × Word)) (a b : Bool) :
    p.map bits (a, b) = p (word a, word b) :=
  PMF.map_apply_equiv p
    ((Equiv.funUnique (Fin 1) Bool).prodCongr (Equiv.funUnique (Fin 1) Bool)) (word a, word b)

private theorem one_letter_mass (p : PMF Bool) (a : Bool) :
    PMF.iid p 1 (word a) = p a := by
  change PMF.finiteProduct (fun _ : Fin 1 => p) (word a) = p a
  rw [PMF.finiteProduct_apply, Fin.prod_univ_one]
  rfl

/-! ### Noiseless channel with a uniform prior -/

private abbrev noiseless := PMF.memorylessChannel (PMF.pure : Bool → PMF Bool) 1
private def fixedBook (i : Fin 2) : Word := word (decide (i = 1))

private theorem noiseless_eq_pure : noiseless = PMF.pure :=
  funext fun x => PMF.finiteProduct_pure x

private theorem fixed_competing :
    (noiseless (fixedBook 0)).map (fun y => (fixedBook 1 0, y 0)) = PMF.pure (true, false) := by
  rw [noiseless_eq_pure, PMF.pure_map]
  rfl

example :
    ((noiseless (fixedBook 0)).map (fun y => (fixedBook 1 0, y 0))) (true, false) = 1 := by
  simp [fixed_competing]

example (a b : Bool) :
    ((((codebookOutputLaw (PMF.iid fair 1) noiseless (0 : Fin 2)).map
      (fun z => (z.1 1, z.2))).map bits) (a, b)).toReal = 1 / 4 := by
  rw [codebookOutputLaw_map_competingOutput _ _ _ _ (by decide), bits_mass,
    noiseless_eq_pure, PMF.bind_pure, indepProd_apply, ENNReal.toReal_mul,
    one_letter_mass, one_letter_mass]
  norm_num [fair, PMF.uniformOfFintype_apply]

/-! ### Asymmetric channel with a biased prior -/

private def biased : PMF Bool :=
  PMF.ofFintype (fun b => ENNReal.ofReal (if b then (1 / 4 : ℝ) else 3 / 4))
    (by
      rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
      norm_num)

private def asymmetric (b : Bool) : PMF Bool := if b then fair else PMF.pure false
private abbrev input := PMF.iid biased 1
private abbrev channel := PMF.memorylessChannel asymmetric 1

private theorem output_mass (b : Bool) :
    ((input.bind channel) (word b)).toReal = if b then 1 / 8 else 7 / 8 := by
  have h : input.bind channel = PMF.iid (biased.bind asymmetric) 1 :=
    PMF.finiteProduct_bind_productChannel (fun _ : Fin 1 => biased) (fun _ => asymmetric)
  rw [h, one_letter_mass, PMF.bind_toReal_apply, Fintype.sum_bool]
  cases b <;> norm_num [biased, asymmetric, fair, PMF.pure_apply,
    PMF.ofFintype_apply, PMF.uniformOfFintype_apply]

example :
    ((((codebookOutputLaw input channel (0 : Fin 2)).map
      (fun z => (z.1 0, z.2))).map bits) (false, true)).toReal = 0 := by
  rw [codebookOutputLaw_map_sentOutput, bits_mass, PMF.channelJoint_apply]
  change (input (word false) * PMF.productChannel (fun _ : Fin 1 => asymmetric)
    (word false) (word true)).toReal = 0
  simp [PMF.productChannel_apply, asymmetric, word, PMF.pure_apply]

example :
    ((((codebookOutputLaw input channel (0 : Fin 2)).map
      (fun z => (z.1 1, z.2))).map bits) (false, true)).toReal = 3 / 32 := by
  rw [codebookOutputLaw_map_competingOutput _ _ _ _ (by decide), bits_mass,
    indepProd_apply, ENNReal.toReal_mul, output_mass, one_letter_mass]
  norm_num [biased, PMF.ofFintype_apply]

end

/-! ### Deterministic decoding by an acceptance event -/

example {X : Type u} {Y : Type v} {n M : ℕ} (b : Fin M → Fin n → X)
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) :
    (BlockChannelCode.ofAcceptanceEvent b A hM).encoder = b := rfl

example {X : Type u} {Y : Type v} {n M : ℕ} (b : Fin M → Fin n → X)
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y)) (t : ℝ)
    (hM : 1 ≤ M) (m : Fin M) (y : Fin n → Y)
    (hm : (b m, y) ∈ infoDensityThresholdEvent q K t)
    (hother : ∀ j, j ≠ m → (b j, y) ∉ infoDensityThresholdEvent q K t) :
    (BlockChannelCode.ofAcceptanceEvent b (infoDensityThresholdEvent q K t) hM).decoder y = m :=
  BlockChannelCode.decoder_ofAcceptanceEvent_eq_of_unique b
    (infoDensityThresholdEvent q K t) hM m y hm hother

private def duplicateBook : Fin 3 → Word := ![word false, word true, word true]

private def equalityEvent : Set (Word × Word) := {z | z.1 = z.2}

example :
    (duplicateBook 1, word true) ∈ equalityEvent ∧
    (duplicateBook 2, word true) ∈ equalityEvent ∧
    (BlockChannelCode.ofAcceptanceEvent duplicateBook equalityEvent (by decide)).decoder
      (word true) = 1 := by
  classical
  refine ⟨rfl, rfl, ?_⟩
  let s := Finset.univ.filter (fun i => (duplicateBook i, word true) ∈ equalityEvent)
  have h1 : (1 : Fin 3) ∈ s := Finset.mem_filter.mpr ⟨Finset.mem_univ _, rfl⟩
  change (if hs : s.Nonempty then s.min' hs else (0 : Fin 3)) = 1
  rw [dif_pos ⟨1, h1⟩]
  apply (Finset.min'_eq_iff s _ 1).mpr
  refine ⟨h1, fun j hj => ?_⟩
  have hpass : duplicateBook j = word true := (Finset.mem_filter.mp hj).2
  fin_cases j
  · exact Bool.noConfusion (congrFun hpass 0)
  · decide
  · decide

private theorem decoder_of_no_pass {X : Type u} {Y : Type v} {n M : ℕ}
    (b : Fin M → Fin n → X) (A : Set ((Fin n → X) × (Fin n → Y))) (y : Fin n → Y)
    (hM : 1 ≤ M) (hnone : ∀ j, (b j, y) ∉ A) :
    (BlockChannelCode.ofAcceptanceEvent b A hM).decoder y = ⟨0, hM⟩ := by
  classical
  let s := Finset.univ.filter (fun j => (b j, y) ∈ A)
  have h : ¬ s.Nonempty := by
    rintro ⟨j, hj⟩
    exact hnone j (Finset.mem_filter.mp hj).2
  change (if hs : s.Nonempty then s.min' hs else ⟨0, hM⟩) = _
  rw [dif_neg h]

example {X : Type u} {Y : Type v} {n : ℕ} (b : Fin 2 → Fin n → X) (y : Fin n → Y) :
    (BlockChannelCode.ofAcceptanceEvent b ∅ (by decide)).decoder y ≠ 1 := by
  rw [decoder_of_no_pass b ∅ y (by decide) (fun _ h => h)]
  decide

example {X : Type u} {Y : Type v} {n : ℕ} (b : Fin 1 → Fin n → X)
    (A : Set ((Fin n → X) × (Fin n → Y))) (y : Fin n → Y) :
    (BlockChannelCode.ofAcceptanceEvent b A (by decide)).decoder y = 0 :=
  Subsingleton.elim _ _

/-! ### Two-message decoders and book sums -/

open Classical in
private theorem decoder_two {X : Type u} {Y : Type v} {n : ℕ}
    (b : Fin 2 → Fin n → X) (A : Set ((Fin n → X) × (Fin n → Y))) (y : Fin n → Y) :
    (BlockChannelCode.ofAcceptanceEvent b A (by decide)).decoder y =
      if (b 1, y) ∈ A ∧ (b 0, y) ∉ A then 1 else 0 := by
  classical
  by_cases h0 : (b 0, y) ∈ A
  · rw [if_neg (fun h => h.2 h0)]
    let s := Finset.univ.filter (fun j => (b j, y) ∈ A)
    have hmem : (0 : Fin 2) ∈ s := Finset.mem_filter.mpr ⟨Finset.mem_univ _, h0⟩
    change (if hs : s.Nonempty then s.min' hs else 0) = 0
    rw [dif_pos ⟨0, hmem⟩]
    exact le_antisymm (s.min'_le 0 hmem) (Fin.zero_le _)
  · by_cases h1 : (b 1, y) ∈ A
    · rw [if_pos ⟨h1, h0⟩]
      apply BlockChannelCode.decoder_ofAcceptanceEvent_eq_of_unique b A _ 1 y h1
      intro j hj
      fin_cases j
      · exact h0
      · exact (hj rfl).elim
    · rw [if_neg (fun h => h1 h.1)]
      apply decoder_of_no_pass b A y
      intro j
      fin_cases j
      · exact h0
      · exact h1

private theorem sum_two_books {α : Type u} [Fintype α] (f : (Fin 2 → α) → ℝ) :
    (∑ b : Fin 2 → α, f b) = ∑ x, ∑ y, f ![x, y] := by
  rw [← (finTwoArrowEquiv α).symm.sum_comp f, Fintype.sum_prod_type]
  rfl

/-! ### Both averaging orders for the asymmetric channel -/

noncomputable section

private def orderedBook (a b : Bool) : Fin 2 → Word := ![word a, word b]
private abbrev eventCode (book : Fin 2 → Word) :=
  BlockChannelCode.ofAcceptanceEvent book equalityEvent (by decide)
private abbrev books := PMF.iid input 2
private abbrev failure (m : Fin 2) : Set ((Fin 2 → Word) × Word) :=
  {z | (eventCode z.1).decoder z.2 ≠ m}

private theorem word_inj {a b : Bool} : word a = word b ↔ a = b :=
  ⟨fun h => congrFun h 0, congrArg word⟩

private theorem decode_bits (a b y : Bool) :
    (eventCode (orderedBook a b)).decoder (word y) =
      if b = y ∧ a ≠ y then 1 else 0 := by
  classical
  rw [decoder_two]
  simp [orderedBook, equalityEvent, word_inj]

private theorem sum_words (f : Word → ℝ) :
    (∑ x, f x) = f (word true) + f (word false) := by
  rw [← (Equiv.funUnique (Fin 1) Bool).symm.sum_comp f, Fintype.sum_bool]
  rfl

private theorem sum_ordered_books (f : (Fin 2 → Word) → ℝ) :
    (∑ b, f b) = (f (orderedBook true true) + f (orderedBook true false)) +
      (f (orderedBook false true) + f (orderedBook false false)) := by
  rw [sum_two_books]
  simp_rw [sum_words]
  rfl

private theorem book_mass (a b : Bool) :
    (books (orderedBook a b)).toReal =
      (if a then 1 / 4 else 3 / 4) * (if b then 1 / 4 else 3 / 4) := by
  change (PMF.finiteProduct (fun _ : Fin 2 => input) (orderedBook a b)).toReal = _
  rw [PMF.finiteProduct_apply, Fin.prod_univ_two, ENNReal.toReal_mul]
  change (input (word a)).toReal * (input (word b)).toReal = _
  rw [one_letter_mass, one_letter_mass]
  cases a <;> cases b <;> norm_num [biased, PMF.ofFintype_apply]

private theorem row_mass (a y : Bool) :
    (channel (word a) (word y)).toReal = if a then 1 / 2 else if y then 0 else 1 := by
  change (PMF.productChannel (fun _ : Fin 1 => asymmetric) (word a) (word y)).toReal = _
  rw [PMF.productChannel_apply, Fin.prod_univ_one]
  cases a <;> cases y <;> norm_num [asymmetric, word, fair, PMF.pure_apply,
    PMF.uniformOfFintype_apply]

private theorem joint_atom (a b y : Bool) (m : Fin 2) :
    ((codebookOutputLaw input channel m) (orderedBook a b, word y)).toReal =
      (books (orderedBook a b)).toReal * (channel (orderedBook a b m) (word y)).toReal := by
  change ((PMF.channelJoint books (fun book => channel (book m)))
    (orderedBook a b, word y)).toReal = _
  rw [PMF.channelJoint_apply, ENNReal.toReal_mul]

private theorem fixed_index_error (m : Fin 2) :
    ((codebookOutputLaw input channel m).toOuterMeasure (failure m)).toReal =
      if m = 0 then 3 / 32 else 23 / 32 := by
  classical
  rw [PMF.toOuterMeasure_toReal_eq_sum, Fintype.sum_prod_type, sum_ordered_books]
  simp_rw [sum_words]
  simp only [failure, Set.indicator, Set.mem_ofPred_eq, decode_bits, joint_atom, book_mass]
  fin_cases m <;> norm_num [orderedBook, row_mass]

private theorem realized_error (a b : Bool) :
    (eventCode (orderedBook a b)).errorProbability asymmetric (by decide) =
      if a = b then 1 / 2 else 1 / 4 := by
  classical
  rw [BlockChannelCode.errorProbability_one_length_eq_sum, Fin.sum_univ_two]
  simp only [Fintype.sum_bool]
  change (1 / (2 : ℝ)) *
    ((if (eventCode (orderedBook a b)).decoder (word true) ≠ 0 then
      (asymmetric a true).toReal else 0) +
     (if (eventCode (orderedBook a b)).decoder (word false) ≠ 0 then
      (asymmetric a false).toReal else 0) +
     ((if (eventCode (orderedBook a b)).decoder (word true) ≠ 1 then
      (asymmetric b true).toReal else 0) +
      (if (eventCode (orderedBook a b)).decoder (word false) ≠ 1 then
      (asymmetric b false).toReal else 0))) = _
  simp only [decode_bits]
  cases a <;> cases b <;>
    norm_num [asymmetric, fair, PMF.pure_apply, PMF.uniformOfFintype_apply]

private theorem weighted_released_error :
    (∑ b, (books b).toReal * (eventCode b).errorProbability asymmetric (by decide)) = 13 / 32 := by
  rw [sum_ordered_books, realized_error true true, realized_error true false,
    realized_error false true, realized_error false false]
  norm_num [book_mass]

example :
    let uniformMean := (1 / (2 : ℝ)) * ∑ m : Fin 2,
      ((codebookOutputLaw input channel m).toOuterMeasure (failure m)).toReal
    let bookMean := ∑ b, (books b).toReal * (eventCode b).errorProbability asymmetric (by decide)
    uniformMean = 13 / 32 ∧ bookMean = 13 / 32 ∧ uniformMean = bookMean := by
  refine ⟨?_, weighted_released_error,
    mean_codebookOutputLaw_error_eq_mean_errorProbability input asymmetric equalityEvent
      (by decide : 1 ≤ 2)⟩
  rw [Fin.sum_univ_two, fixed_index_error 0, fixed_index_error 1]
  norm_num

end

/-! ### C30's caller and the released boundary formulas -/

example {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n M : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y) (t r : ℝ) (hM : 1 ≤ M) :
    let K := PMF.memorylessChannel W n
    let A := infoDensityThresholdEvent q K t
    (∀ m : Fin M, ((codebookOutputLaw q K m).toOuterMeasure
      {z | (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m}).toReal ≤ r) →
      ∑ b : Fin M → Fin n → X, (PMF.iid q M b).toReal *
        (BlockChannelCode.ofAcceptanceEvent b A hM).errorProbability W hM ≤ r := by
  intro K A h
  rw [← mean_codebookOutputLaw_error_eq_mean_errorProbability]
  calc
    _ ≤ (1 / (M : ℝ)) * ∑ _m : Fin M, r :=
      mul_le_mul_of_nonneg_left (Finset.sum_le_sum fun m _ => h m) (by positivity)
    _ = r := by
      have hMr : (M : ℝ) ≠ 0 := by exact_mod_cast (show M ≠ 0 by omega)
      simp [nsmul_eq_mul, hMr]

example {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y) (A : Set ((Fin n → X) × (Fin n → Y))) :
    (1 / (1 : ℝ)) * (∑ m : Fin 1,
      ((codebookOutputLaw q (PMF.memorylessChannel W n) m).toOuterMeasure
        {z | (BlockChannelCode.ofAcceptanceEvent z.1 A (by decide)).decoder z.2 ≠ m}).toReal) =
      0 := by
  simpa [BlockChannelCode.errorProbability_one] using
    mean_codebookOutputLaw_error_eq_mean_errorProbability q W A (by decide : 1 ≤ 1)

example {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {M : ℕ}
    (q : PMF (Fin 0 → X)) (W : X → PMF Y) (A : Set ((Fin 0 → X) × (Fin 0 → Y)))
    (hM : 1 ≤ M) :
    (1 / (M : ℝ)) * (∑ m : Fin M,
      ((codebookOutputLaw q (PMF.memorylessChannel W 0) m).toOuterMeasure
        {z | (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m}).toReal) =
      1 - 1 / (M : ℝ) := by
  rw [mean_codebookOutputLaw_error_eq_mean_errorProbability]
  simp_rw [BlockChannelCode.errorProbability_zero]
  rw [← Finset.sum_mul, PMF.sum_toReal, one_mul]

/-! ### A correlated word prior with the literal strict threshold -/

noncomputable section

private abbrev Word2 := Fin 2 → Bool
private def repeated (bit : Bool) : Word2 := fun _ => bit
private def repeatedPrior : PMF Word2 := biased.map repeated
private abbrev identityChannel : Bool → PMF Bool := PMF.pure
private abbrev repeatedChannel := PMF.memorylessChannel identityChannel 2
private def repeatedEvent := infoDensityThresholdEvent repeatedPrior repeatedChannel 0

private theorem repeated_ne : repeated false ≠ repeated true := by
  intro h
  exact Bool.noConfusion (congrFun h 0)

private theorem repeated_channel_eq_pure : repeatedChannel = PMF.pure :=
  funext fun x => PMF.finiteProduct_pure x

private theorem repeated_mass (x : Word2) :
    (repeatedPrior x).toReal =
      (if x = repeated false then 3 / 4 else 0) +
      (if x = repeated true then 1 / 4 else 0) := by
  classical
  change (biased.bind (PMF.pure ∘ repeated) x).toReal = _
  rw [PMF.bind_toReal_apply, Fintype.sum_bool]
  by_cases h0 : x = repeated false <;> by_cases h1 : x = repeated true <;>
    norm_num [Function.comp_apply, PMF.pure_apply, biased, PMF.ofFintype_apply, h0, h1,
      repeated_ne, Ne.symm repeated_ne]

private theorem repeated_pass (x y : Word2) :
    (x, y) ∈ repeatedEvent ↔
      (x = repeated false ∧ y = repeated false) ∨
      (x = repeated true ∧ y = repeated true) := by
  classical
  change Real.exp 0 *
    ((indepProd repeatedPrior (repeatedPrior.bind repeatedChannel)) (x, y)).toReal <
    ((PMF.channelJoint repeatedPrior repeatedChannel) (x, y)).toReal ↔ _
  simp only [Real.exp_zero, repeated_channel_eq_pure, PMF.bind_pure, indepProd_apply,
    PMF.channelJoint_apply, ENNReal.toReal_mul, one_mul, PMF.pure_apply]
  by_cases hx : x = repeated false <;>
    by_cases hx' : x = repeated true <;>
    by_cases hy : y = repeated false <;>
    by_cases hy' : y = repeated true <;>
    simp_all [repeated_mass, repeated_ne, Ne.symm repeated_ne] <;> norm_num

private theorem repeated_weighted_sum (f : Word2 → ℝ) :
    (∑ x, (repeatedPrior x).toReal * f x) =
      (3 / 4) * f (repeated false) + (1 / 4) * f (repeated true) := by
  classical
  simp_rw [repeated_mass, add_mul, ite_mul, zero_mul]
  simp [Finset.sum_add_distrib]

private def repeatedBook (a b : Bool) : Fin 2 → Word2 := ![repeated a, repeated b]

private theorem repeated_decodes (a b c : Bool) :
    (BlockChannelCode.ofAcceptanceEvent (repeatedBook a b) repeatedEvent
      (by decide)).decoder (repeated c) =
      if b = c ∧ a ≠ c then (1 : Fin 2) else 0 := by
  classical
  rw [decoder_two]
  cases a <;> cases b <;> cases c <;>
    simp [repeatedBook, repeated_pass, repeated_ne, Ne.symm repeated_ne]

private theorem repeated_error (a b : Bool) :
    (BlockChannelCode.ofAcceptanceEvent (repeatedBook a b) repeatedEvent
      (by decide)).errorProbability identityChannel (by decide) =
      if a = b then (1 / 2 : ℝ) else 0 := by
  classical
  rw [BlockChannelCode.errorProbability_eq_sum]
  simp only [repeated_channel_eq_pure]
  change (1 / (2 : ℝ)) * (∑ m : Fin 2, ∑ y : Word2,
    if (BlockChannelCode.ofAcceptanceEvent (repeatedBook a b) repeatedEvent
      (by decide)).decoder y ≠ m then
      (PMF.pure (repeatedBook a b m) y).toReal else 0) = _
  have hpure (m : Fin 2) :
      (∑ y : Word2, if
        (BlockChannelCode.ofAcceptanceEvent (repeatedBook a b) repeatedEvent
          (by decide)).decoder y ≠ m then
        (PMF.pure (repeatedBook a b m) y).toReal else 0) =
      if (BlockChannelCode.ofAcceptanceEvent (repeatedBook a b) repeatedEvent
        (by decide)).decoder (repeatedBook a b m) ≠ m then (1 : ℝ) else 0 := by
    rw [Finset.sum_eq_single (repeatedBook a b m)]
    · simp
    · intro y _ hy
      rw [PMF.pure_apply_of_ne _ _ hy]
      simp
    · simp
  simp_rw [hpure]
  rw [Fin.sum_univ_two]
  change (1 / (2 : ℝ)) *
    ((if (BlockChannelCode.ofAcceptanceEvent (repeatedBook a b) repeatedEvent
      (by decide)).decoder (repeated a) ≠ 0 then 1 else 0) +
     (if (BlockChannelCode.ofAcceptanceEvent (repeatedBook a b) repeatedEvent
      (by decide)).decoder (repeated b) ≠ 1 then 1 else 0)) = _
  rw [repeated_decodes, repeated_decodes]
  cases a <;> cases b <;> norm_num

private theorem repeated_weighted_books (f : (Fin 2 → Word2) → ℝ) :
    (∑ b, (PMF.iid repeatedPrior 2 b).toReal * f b) =
      (9 / 16) * f (repeatedBook false false) +
      (3 / 16) * f (repeatedBook false true) +
      (3 / 16) * f (repeatedBook true false) +
      (1 / 16) * f (repeatedBook true true) := by
  change (∑ b : Fin 2 → Word2,
    (PMF.finiteProduct (fun _ : Fin 2 => repeatedPrior) b).toReal * f b) = _
  rw [sum_two_books]
  simp only [PMF.finiteProduct_apply, Fin.prod_univ_two,
    Matrix.cons_val_zero, Matrix.cons_val_one, ENNReal.toReal_mul]
  simp_rw [mul_assoc, ← Finset.mul_sum]
  rw [repeated_weighted_sum]
  simp_rw [repeated_weighted_sum]
  change (3 / 4) * ((3 / 4) * f (repeatedBook false false) +
    (1 / 4) * f (repeatedBook false true)) +
    (1 / 4) * ((3 / 4) * f (repeatedBook true false) +
    (1 / 4) * f (repeatedBook true true)) = _
  ring

private theorem repeated_collision_sum :
    ((PMF.iid repeatedPrior 2).toOuterMeasure
      {b : Fin 2 → Word2 | b 0 = b 1}).toReal =
      ∑ b : Fin 2 → Word2, (PMF.iid repeatedPrior 2 b).toReal *
        (if b 0 = b 1 then 1 else 0) := by
  classical
  rw [PMF.toOuterMeasure_toReal_eq_sum]
  apply Finset.sum_congr rfl
  intro b _
  by_cases h : b 0 = b 1 <;> simp [Set.indicator, h]

private theorem repeated_collision_mass :
    ((PMF.iid repeatedPrior 2).toOuterMeasure
      {b : Fin 2 → Word2 | b 0 = b 1}).toReal = 5 / 8 := by
  rw [repeated_collision_sum, repeated_weighted_books]
  norm_num [repeatedBook, repeated_ne, Ne.symm repeated_ne]

private theorem repeated_weighted_released_error :
    (∑ b, (PMF.iid repeatedPrior 2 b).toReal *
      (BlockChannelCode.ofAcceptanceEvent b repeatedEvent (by decide)).errorProbability
        identityChannel (by decide)) = 5 / 16 := by
  calc
    _ = (1 / 2) * ((PMF.iid repeatedPrior 2).toOuterMeasure
        {b : Fin 2 → Word2 | b 0 = b 1}).toReal := by
      rw [repeated_collision_sum, repeated_weighted_books, repeated_weighted_books]
      rw [repeated_error false false, repeated_error false true,
        repeated_error true false, repeated_error true true]
      norm_num [repeatedBook, repeated_ne, Ne.symm repeated_ne]
    _ = 5 / 16 := by
      rw [repeated_collision_mass]
      norm_num

example :
    (1 / (2 : ℝ)) * (∑ m : Fin 2,
      ((codebookOutputLaw repeatedPrior repeatedChannel m).toOuterMeasure
        {z | (BlockChannelCode.ofAcceptanceEvent z.1 repeatedEvent (by decide)).decoder
          z.2 ≠ m}).toReal) = 5 / 16 := by
  exact (mean_codebookOutputLaw_error_eq_mean_errorProbability repeatedPrior
    identityChannel repeatedEvent (by decide)).trans repeated_weighted_released_error

end

end LeanInfoTheory.Examples.RandomCodebook
