/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCodingOneShot

/-!
# One-shot channel-coding callers

The ensemble bound accepts arbitrary block rows, including rows with infinite output
alphabet. In the three-message example the same fair output bit decides every pass.
-/

namespace LeanInfoTheory.Examples.ChannelCodingOneShot

open LeanInfoTheory.Shannon

noncomputable section

universe u v

private abbrev ensembleError {X : Type u} {Y : Type v} [Fintype X] {n M : ℕ}
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) : ℝ :=
  (1 / (M : ℝ)) * ∑ m : Fin M, ((codebookOutputLaw q K m).toOuterMeasure
    {z | (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m}).toReal

example {X : Type u} {Y : Type v} [Fintype X] {n M : ℕ} (hM : 1 ≤ M)
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (A : Set ((Fin n → X) × (Fin n → Y))) (miss alarm : ℝ)
    (hm : ((PMF.channelJoint q K).toOuterMeasure Aᶜ).toReal ≤ miss)
    (ha : ((indepProd q (q.bind K)).toOuterMeasure A).toReal ≤ alarm) :
    ensembleError q K A hM ≤ miss + ((M : ℝ) - 1) * alarm := by
  have hMr : (1 : ℝ) ≤ M := by exact_mod_cast hM
  exact (mean_codebookOutputLaw_error_le q K A hM).trans
    (add_le_add hm (mul_le_mul_of_nonneg_left ha (sub_nonneg.mpr hMr)))

example (q : PMF (Fin 1 → Bool)) (K : (Fin 1 → Bool) → PMF (Fin 1 → ℕ))
    (A : Set ((Fin 1 → Bool) × (Fin 1 → ℕ))) :
    ensembleError q K A (by decide : 1 ≤ 2) ≤
      ((PMF.channelJoint q K).toOuterMeasure Aᶜ).toReal +
        ((indepProd q (q.bind K)).toOuterMeasure A).toReal := by
  simpa only [ensembleError, Nat.cast_ofNat, show (2 : ℝ) - 1 = 1 by norm_num,
    one_mul] using mean_codebookOutputLaw_error_le q K A (by decide : 1 ≤ 2)

/-! ### Two rivals sharing a fair output -/

private abbrev Word := Fin 1 → Bool
private abbrev Book := Fin 3 → Word
private abbrev fairBit : PMF Bool := PMF.uniformOfFintype Bool
private abbrev fairRow (_ : Word) : PMF Word := PMF.iid fairBit 1
private def acceptsTrue : Set (Word × Word) := {z | z.2 0 = true}
private def pass (i : Fin 3) : Set (Book × Word) := {z | (z.1 i, z.2) ∈ acceptsTrue}

private theorem fair_output_mass {α : Type u} (p : PMF α) (a : Bool) :
    ((PMF.channelJoint p (fun _ => PMF.iid fairBit 1)).toOuterMeasure
      {z | z.2 0 = a}).toReal = 1 / 2 := by
  let J := PMF.channelJoint p (fun _ => PMF.iid fairBit 1)
  have h : (J.map Prod.snd).map (fun y => y 0) = fairBit := by
    dsimp only [J]
    rw [PMF.channelJoint_map_snd, PMF.bind_const]
    exact PMF.finiteProduct_map_eval (fun _ : Fin 1 => fairBit) 0
  calc
    _ = (((J.map Prod.snd).map (fun y => y 0)).toOuterMeasure {a}).toReal := by
      simp only [PMF.toOuterMeasure_map_apply]; rfl
    _ = _ := by
      rw [h, PMF.toOuterMeasure_apply_singleton]
      norm_num [fairBit, PMF.uniformOfFintype_apply]

example (q : PMF Word) :
    let L := codebookOutputLaw q fairRow (0 : Fin 3)
    pass 1 = pass 2 ∧ (L.toOuterMeasure (pass 1)).toReal = 1 / 2 ∧
      (L.toOuterMeasure (pass 2)).toReal = 1 / 2 ∧
      (L.toOuterMeasure (pass 1 ∩ pass 2)).toReal = 1 / 2 := by
  intro L
  have heq : pass 1 = pass 2 := rfl
  have hp : (L.toOuterMeasure (pass 1)).toReal = 1 / 2 :=
    fair_output_mass (PMF.iid q 3) true
  rw [← heq, Set.inter_self]
  exact ⟨rfl, hp, hp, hp⟩

private theorem decoder_always_zero (b : Book) (y : Word) :
    (BlockChannelCode.ofAcceptanceEvent b acceptsTrue (by decide)).decoder y = 0 := by
  classical
  let s := Finset.univ.filter (fun i : Fin 3 => (b i, y) ∈ acceptsTrue)
  change (if hs : s.Nonempty then s.min' hs else 0) = 0
  by_cases h : y 0 = true
  · have h0 : (0 : Fin 3) ∈ s := Finset.mem_filter.mpr ⟨Finset.mem_univ _, h⟩
    rw [dif_pos ⟨0, h0⟩]
    exact le_antisymm (s.min'_le 0 h0) (Fin.zero_le _)
  · have hempty : ¬ s.Nonempty := fun ⟨_, hi⟩ => h (Finset.mem_filter.mp hi).2
    rw [dif_neg hempty]

example :
    {z : Book × Word | (BlockChannelCode.ofAcceptanceEvent z.1 acceptsTrue
      (by decide)).decoder z.2 ≠ 0} = ∅ ∧
    (pass 0)ᶜ ∪ pass 1 ∪ pass 2 = Set.univ := by
  constructor
  · ext z
    simp [decoder_always_zero]
  · change (pass 0)ᶜ ∪ pass 0 ∪ pass 0 = Set.univ
    simp

example (q : PMF Word) : ensembleError q fairRow acceptsTrue (by decide : 1 ≤ 3) ≤ 3 / 2 := by
  have hmiss : acceptsTrueᶜ = {z : Word × Word | z.2 0 = false} := by
    ext z
    cases h : z.2 0 <;> simp [acceptsTrue, h]
  calc
    _ ≤ ((PMF.channelJoint q fairRow).toOuterMeasure acceptsTrueᶜ).toReal +
        ((3 : ℝ) - 1) * ((indepProd q (q.bind fairRow)).toOuterMeasure acceptsTrue).toReal :=
      mean_codebookOutputLaw_error_le q fairRow acceptsTrue (by decide)
    _ = 3 / 2 := by
      rw [hmiss, fair_output_mass q false, show q.bind fairRow = PMF.iid fairBit 1 from
        PMF.bind_const q _]
      change 1 / 2 + ((3 : ℝ) - 1) *
        ((PMF.channelJoint q (fun _ => PMF.iid fairBit 1)).toOuterMeasure
        {z | z.2 0 = true}).toReal = 3 / 2
      rw [fair_output_mass q true]
      norm_num

/-! ### One message -/

private theorem singleton_competitors : Finset.univ.erase (0 : Fin 1) = ∅ := by decide

example (w : Fin 1 → ℝ) : (∑ j ∈ Finset.univ.erase (0 : Fin 1), w j) = 0 := by
  rw [singleton_competitors, Finset.sum_empty]

example {X : Type u} {Y : Type v} [Fintype X] {n : ℕ}
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (A : Set ((Fin n → X) × (Fin n → Y))) :
    ensembleError q K A (by decide : 1 ≤ 1) ≤
      ((PMF.channelJoint q K).toOuterMeasure Aᶜ).toReal := by
  simpa only [ensembleError, Nat.cast_one, sub_self, zero_mul, add_zero] using
    mean_codebookOutputLaw_error_le q K A (by decide : 1 ≤ 1)

/-! ### A supported book for arbitrary raw rows -/

example {X : Type u} {Y : Type v} [Fintype X] {n M : ℕ}
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) (r : ℝ)
    (hr : ((PMF.channelJoint q K).toOuterMeasure Aᶜ).toReal +
      ((M : ℝ) - 1) * ((indepProd q (q.bind K)).toOuterMeasure A).toReal ≤ r) :
    ∃ b ∈ (PMF.iid q M).support,
      (1 / (M : ℝ)) * (∑ m : Fin M,
        ((K (b m)).toOuterMeasure
          {y | (BlockChannelCode.ofAcceptanceEvent b A hM).decoder y ≠ m}).toReal) ≤ r := by
  obtain ⟨b, hb, herror⟩ := exists_mem_support_codebook_error_le q K A hM
  exact ⟨b, hb, herror.trans hr⟩

/-! ### Released error of the same supported book -/

example {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n M : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y)
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) (r : ℝ)
    (hr : ((PMF.channelJoint q (PMF.memorylessChannel W n)).toOuterMeasure Aᶜ).toReal +
      ((M : ℝ) - 1) *
        ((indepProd q (q.bind (PMF.memorylessChannel W n))).toOuterMeasure A).toReal ≤ r) :
    ∃ c : BlockChannelCode X Y n M,
      c.encoder ∈ (PMF.iid q M).support ∧
      c = BlockChannelCode.ofAcceptanceEvent c.encoder A hM ∧
      c.errorProbability W hM ≤ r := by
  obtain ⟨c, hc, hdecoder, herror⟩ :=
    exists_blockChannelCode_errorProbability_le_of_acceptanceEvent q W A hM
  exact ⟨c, hc, hdecoder, herror.trans hr⟩

-- C29's independent averaging identity checks the expected released error too.
example {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n M : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y)
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) :
    (∑ b : Fin M → Fin n → X, (PMF.iid q M b).toReal *
      (BlockChannelCode.ofAcceptanceEvent b A hM).errorProbability W hM) ≤
      ((PMF.channelJoint q (PMF.memorylessChannel W n)).toOuterMeasure Aᶜ).toReal +
        ((M : ℝ) - 1) *
          ((indepProd q (q.bind (PMF.memorylessChannel W n))).toOuterMeasure A).toReal := by
  rw [← mean_codebookOutputLaw_error_eq_mean_errorProbability q W A hM]
  exact mean_codebookOutputLaw_error_le q (PMF.memorylessChannel W n) A hM

example {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y) (t : ℝ) :
    ∃ c : BlockChannelCode X Y n 1,
      c.encoder ∈ (PMF.iid q 1).support ∧ c.errorProbability W (by decide) = 0 := by
  obtain ⟨c, hc, _, _⟩ :=
    exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold q W t (by decide : 1 ≤ 1)
  exact ⟨c, hc, c.errorProbability_one W⟩

-- The empty word exists even when both base alphabets are empty.
example (M : ℕ) (hM : 1 ≤ M) :
    let q : PMF (Fin 0 → Fin 0) := PMF.pure id
    let W : Fin 0 → PMF (Fin 0) := fun x => Fin.elim0 x
    ∃ c : BlockChannelCode (Fin 0) (Fin 0) 0 M,
      c.encoder ∈ (PMF.iid q M).support ∧
      c.errorProbability W hM = 1 - 1 / (M : ℝ) := by
  intro q W
  obtain ⟨c, hc, _, _⟩ :=
    exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold q W 0 hM
  exact ⟨c, hc, c.errorProbability_zero W hM⟩

/-! ### The global strict event, including negative thresholds -/

example {X : Type u} {Y : Type v} {n : ℕ} (q : PMF (Fin n → X))
    (K : (Fin n → X) → PMF (Fin n → Y)) (t : ℝ) (z : (Fin n → X) × (Fin n → Y))
    (htie : Real.exp t * (indepProd q (q.bind K) z).toReal =
      (PMF.channelJoint q K z).toReal) :
    z ∉ infoDensityThresholdEvent q K t := by
  change ¬ Real.exp t * (indepProd q (q.bind K) z).toReal <
    (PMF.channelJoint q K z).toReal
  rw [htie]
  exact lt_irrefl _

example {X : Type u} {Y : Type v} {n : ℕ} (q : PMF (Fin n → X))
    (K : (Fin n → X) → PMF (Fin n → Y)) (z : (Fin n → X) × (Fin n → Y))
    (hz : PMF.channelJoint q K z = 0) :
    z ∉ infoDensityThresholdEvent q K (-1) := by
  change ¬ Real.exp (-1) * (indepProd q (q.bind K) z).toReal <
    (PMF.channelJoint q K z).toReal
  rw [hz, ENNReal.toReal_zero]
  exact not_lt_of_ge (mul_nonneg (Real.exp_pos _).le ENNReal.toReal_nonneg)

end

end LeanInfoTheory.Examples.ChannelCodingOneShot
