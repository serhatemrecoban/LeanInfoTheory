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
# One-shot channel-coding achievability

For an arbitrary input-word law and raw block channel, the expected uniform-message
error of C29's acceptance-event decoder is bounded by the sent-pair miss probability
plus one independent-pair pass probability for each competing message label.

The union estimate follows PW24 §18.2, proof of Theorem 18.5. The decoder here
returns the first passing label with zero as fallback, so unique sent pass is a
sufficient success condition. The error event is contained in the miss/pass union.
All rival events use the same sampled output. Their mutual independence is
unnecessary. The input law may have arbitrary dependence within each word.

A book in the actual sampling support attains error at most the book-weighted
mean, hence at most the ensemble bound. The selection uses the row law for that
fixed book. It preserves the message labels and the arbitrary input-word prior
as the sampling law.

For memoryless channel rows the same selected book yields a deterministic code
at the supplied blocklength and message count, with the released average error.
C27's strict threshold bounds the competing-pair term by `exp (-t)` for every
real threshold. The miss remains the complement of that literal event.
-/

namespace LeanInfoTheory.Shannon

noncomputable section

universe u v

private theorem error_event_subset {X : Type u} {Y : Type v} {n M : ℕ}
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) (m : Fin M) :
    {z : (Fin M → Fin n → X) × (Fin n → Y) |
      (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m} ⊆
      (fun z => (z.1 m, z.2)) ⁻¹' Aᶜ ∪
        ⋃ j ∈ Finset.univ.erase m, (fun z => (z.1 j, z.2)) ⁻¹' A := by
  classical
  intro z hz
  by_contra h
  have hmiss : (z.1 m, z.2) ∈ A := by
    by_contra hm
    exact h (Or.inl hm)
  have hother : ∀ j, j ≠ m → (z.1 j, z.2) ∉ A := by
    intro j hj hpass
    exact h (Or.inr (Set.mem_iUnion.mpr ⟨j, Set.mem_iUnion.mpr
      ⟨Finset.mem_erase.mpr ⟨hj, Finset.mem_univ j⟩, hpass⟩⟩))
  exact hz (BlockChannelCode.decoder_ofAcceptanceEvent_eq_of_unique
    z.1 A hM m z.2 hmiss hother)

private theorem event_mass_ne_top {α : Type*} (p : PMF α) (S : Set α) :
    p.toOuterMeasure S ≠ ⊤ := by
  rw [PMF.toOuterMeasure_apply]
  exact p.tsum_coe_indicator_ne_top S

private theorem codebookOutputLaw_error_le {X : Type u} {Y : Type v} [Fintype X]
    {n M : ℕ} (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) (m : Fin M) :
    ((codebookOutputLaw q K m).toOuterMeasure
      {z | (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m}).toReal ≤
      ((PMF.channelJoint q K).toOuterMeasure Aᶜ).toReal +
        ((M : ℝ) - 1) * ((indepProd q (q.bind K)).toOuterMeasure A).toReal := by
  classical
  let L := codebookOutputLaw q K m
  let J := PMF.channelJoint q K
  let Q := indepProd q (q.bind K)
  let pass := fun j : Fin M => (fun z : (Fin M → Fin n → X) × (Fin n → Y) =>
    (z.1 j, z.2)) ⁻¹' A
  have hsent : L.toOuterMeasure ((fun z => (z.1 m, z.2)) ⁻¹' Aᶜ) =
      J.toOuterMeasure Aᶜ := by
    dsimp only [J]
    rw [← codebookOutputLaw_map_sentOutput q K m, PMF.toOuterMeasure_map_apply]
  have hrival (j : Fin M) (hj : j ∈ Finset.univ.erase m) :
      L.toOuterMeasure (pass j) = Q.toOuterMeasure A := by
    dsimp only [Q]
    rw [← codebookOutputLaw_map_competingOutput q K m j (Finset.mem_erase.mp hj).1,
      PMF.toOuterMeasure_map_apply]
  have hbound : L.toOuterMeasure
      {z | (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m} ≤
      J.toOuterMeasure Aᶜ + (M - 1) • Q.toOuterMeasure A := by
    calc
      _ ≤ L.toOuterMeasure ((fun z => (z.1 m, z.2)) ⁻¹' Aᶜ ∪
          ⋃ j ∈ Finset.univ.erase m, pass j) :=
        L.toOuterMeasure.mono (error_event_subset A hM m)
      _ ≤ L.toOuterMeasure ((fun z => (z.1 m, z.2)) ⁻¹' Aᶜ) +
          L.toOuterMeasure (⋃ j ∈ Finset.univ.erase m, pass j) :=
        MeasureTheory.measure_union_le _ _
      _ ≤ L.toOuterMeasure ((fun z => (z.1 m, z.2)) ⁻¹' Aᶜ) +
          ∑ j ∈ Finset.univ.erase m, L.toOuterMeasure (pass j) :=
        add_le_add le_rfl (MeasureTheory.measure_biUnion_finset_le _ _)
      _ = J.toOuterMeasure Aᶜ + (M - 1) • Q.toOuterMeasure A := by
        rw [hsent, Finset.sum_congr rfl hrival]
        simp
  have hQ : (M - 1) • Q.toOuterMeasure A ≠ ⊤ := by
    simpa only [nsmul_eq_mul] using ENNReal.mul_ne_top
      (by simp : ((M - 1 : ℕ) : ENNReal) ≠ ⊤) (event_mass_ne_top Q A)
  have hfinite : J.toOuterMeasure Aᶜ + (M - 1) • Q.toOuterMeasure A ≠ ⊤ :=
    ENNReal.add_ne_top.mpr ⟨event_mass_ne_top J Aᶜ, hQ⟩
  have hreal := ENNReal.toReal_mono hfinite hbound
  rw [ENNReal.toReal_add (event_mass_ne_top J Aᶜ) hQ,
    ENNReal.toReal_nsmul] at hreal
  simpa only [nsmul_eq_mul, Nat.cast_sub hM, Nat.cast_one] using hreal

/-- Expected uniform-message decoder error is at most the sent-pair miss plus
`M - 1` independent-pair passes. The whole input-word law and raw block channel
are arbitrary. Competing events sharing the output may be dependent. -/
theorem mean_codebookOutputLaw_error_le {X : Type u} {Y : Type v} [Fintype X]
    {n M : ℕ} (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) :
    (1 / (M : ℝ)) * (∑ m : Fin M,
      ((codebookOutputLaw q K m).toOuterMeasure
        {z | (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m}).toReal) ≤
      ((PMF.channelJoint q K).toOuterMeasure Aᶜ).toReal +
        ((M : ℝ) - 1) * ((indepProd q (q.bind K)).toOuterMeasure A).toReal := by
  calc
    _ ≤ (1 / (M : ℝ)) * ∑ _m : Fin M,
        (((PMF.channelJoint q K).toOuterMeasure Aᶜ).toReal +
          ((M : ℝ) - 1) * ((indepProd q (q.bind K)).toOuterMeasure A).toReal) :=
      mul_le_mul_of_nonneg_left
        (Finset.sum_le_sum fun m _ => codebookOutputLaw_error_le q K A hM m)
        (by positivity)
    _ = _ := by
      have hMr : (M : ℝ) ≠ 0 := by exact_mod_cast (show M ≠ 0 by omega)
      rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
      field_simp

private theorem mean_codebookOutputLaw_error_eq_mean_rowError
    {X : Type u} {Y : Type v} [Fintype X] {n M : ℕ}
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) :
    (1 / (M : ℝ)) * (∑ m : Fin M,
      ((codebookOutputLaw q K m).toOuterMeasure
        {z | (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m}).toReal) =
      ∑ b : Fin M → Fin n → X, (PMF.iid q M b).toReal *
        ((1 / (M : ℝ)) * ∑ m : Fin M,
          ((K (b m)).toOuterMeasure
            {y | (BlockChannelCode.ofAcceptanceEvent b A hM).decoder y ≠ m}).toReal) := by
  classical
  have hEvent (m : Fin M) :
      ((codebookOutputLaw q K m).toOuterMeasure
        {z | (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m}).toReal =
      ∑ b : Fin M → Fin n → X, (PMF.iid q M b).toReal *
        ((K (b m)).toOuterMeasure
          {y | (BlockChannelCode.ofAcceptanceEvent b A hM).decoder y ≠ m}).toReal := by
    unfold codebookOutputLaw PMF.channelJoint
    rw [PMF.toOuterMeasure_bind_apply, tsum_fintype, ENNReal.toReal_sum]
    · simp only [ENNReal.toReal_mul, PMF.toOuterMeasure_map_apply]
      rfl
    · intro b _
      exact ENNReal.mul_ne_top ((PMF.iid q M).apply_ne_top b)
        (event_mass_ne_top _ _)
  rw [Finset.sum_congr (s₁ := Finset.univ) rfl (fun m _ => hEvent m)]
  rw [Finset.sum_comm, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro b _
  rw [← Finset.mul_sum]
  ring

private theorem exists_mem_support_le_mean {α : Type*} [Fintype α]
    (p : PMF α) (f : α → ℝ) :
    ∃ x ∈ p.support, f x ≤ ∑ y, (p y).toReal * f y := by
  classical
  obtain ⟨x, hx, hmin⟩ := p.supportFinset.exists_min_image f p.supportFinset_nonempty
  refine ⟨x, (p.mem_supportFinset x).1 hx, ?_⟩
  calc
    f x = ∑ y, (p y).toReal * f x := by
      rw [← Finset.sum_mul, p.sum_toReal, one_mul]
    _ ≤ ∑ y, (p y).toReal * f y := by
      apply Finset.sum_le_sum
      intro y _
      by_cases hy : y ∈ p.support
      · exact mul_le_mul_of_nonneg_left
          (hmin y ((p.mem_supportFinset y).2 hy)) ENNReal.toReal_nonneg
      · simp [(p.apply_eq_zero_iff y).2 hy]

/-- Some book in the actual iid sampling support has uniform row error at most
the sent-pair miss plus `M - 1` competing passes. The word law and raw block
rows are arbitrary, including dependence between letters within each word. -/
theorem exists_mem_support_codebook_error_le
    {X : Type u} {Y : Type v} [Fintype X] {n M : ℕ}
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) :
    ∃ b ∈ (PMF.iid q M).support,
      (1 / (M : ℝ)) * (∑ m : Fin M,
        ((K (b m)).toOuterMeasure
          {y | (BlockChannelCode.ofAcceptanceEvent b A hM).decoder y ≠ m}).toReal) ≤
        ((PMF.channelJoint q K).toOuterMeasure Aᶜ).toReal +
          ((M : ℝ) - 1) * ((indepProd q (q.bind K)).toOuterMeasure A).toReal := by
  obtain ⟨b, hb, herror⟩ := exists_mem_support_le_mean (PMF.iid q M)
    (fun b => (1 / (M : ℝ)) * ∑ m : Fin M,
      ((K (b m)).toOuterMeasure
        {y | (BlockChannelCode.ofAcceptanceEvent b A hM).decoder y ≠ m}).toReal)
  refine ⟨b, hb, herror.trans ?_⟩
  rw [← mean_codebookOutputLaw_error_eq_mean_rowError q K A hM]
  exact mean_codebookOutputLaw_error_le q K A hM

private theorem rowError_eq_errorProbability
    {X : Type u} {Y : Type v} [Fintype Y] {n M : ℕ}
    (b : Fin M → Fin n → X) (W : X → PMF Y)
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) :
    (1 / (M : ℝ)) * (∑ m : Fin M,
      ((PMF.memorylessChannel W n (b m)).toOuterMeasure
        {y | (BlockChannelCode.ofAcceptanceEvent b A hM).decoder y ≠ m}).toReal) =
      (BlockChannelCode.ofAcceptanceEvent b A hM).errorProbability W hM := by
  classical
  rw [BlockChannelCode.errorProbability_eq_sum]
  simp only [PMF.toOuterMeasure_toReal_eq_sum]
  apply congrArg (fun r : ℝ => (1 / (M : ℝ)) * r)
  apply Finset.sum_congr rfl
  intro m _
  apply Finset.sum_congr rfl
  intro y _
  by_cases h : (BlockChannelCode.ofAcceptanceEvent b A hM).decoder y ≠ m
  · rw [Set.indicator_of_mem
      (show y ∈ {y | (BlockChannelCode.ofAcceptanceEvent b A hM).decoder y ≠ m} from h),
      if_pos h]
    rfl
  · rw [Set.indicator_of_notMem
      (show y ∉ {y | (BlockChannelCode.ofAcceptanceEvent b A hM).decoder y ≠ m} from h),
      if_neg h]

/-- Some deterministic code at the supplied `n` and `M` uses a book in the actual
sampling support and the acceptance-event decoder. Its released average error is
at most the sent miss plus `M - 1` competing passes. The word law need not be iid
and need not equal the input law induced by the selected encoder. -/
theorem exists_blockChannelCode_errorProbability_le_of_acceptanceEvent
    {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n M : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y)
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) :
    ∃ c : BlockChannelCode X Y n M,
      c.encoder ∈ (PMF.iid q M).support ∧
      c = BlockChannelCode.ofAcceptanceEvent c.encoder A hM ∧
      c.errorProbability W hM ≤
        ((PMF.channelJoint q (PMF.memorylessChannel W n)).toOuterMeasure Aᶜ).toReal +
          ((M : ℝ) - 1) *
            ((indepProd q (q.bind (PMF.memorylessChannel W n))).toOuterMeasure A).toReal := by
  obtain ⟨b, hb, herror⟩ :=
    exists_mem_support_codebook_error_le q (PMF.memorylessChannel W n) A hM
  refine ⟨BlockChannelCode.ofAcceptanceEvent b A hM, hb, rfl, ?_⟩
  rwa [rowError_eq_errorProbability b W A hM] at herror

/-- For every real threshold there is a supported deterministic code at the
supplied `n` and `M` with released error at most the literal strict-test miss plus
`(M - 1) * exp (-t)`. Threshold ties count as misses. -/
theorem exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold
    {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n M : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y) (t : ℝ) (hM : 1 ≤ M) :
    ∃ c : BlockChannelCode X Y n M,
      c.encoder ∈ (PMF.iid q M).support ∧
      c = BlockChannelCode.ofAcceptanceEvent c.encoder
        (infoDensityThresholdEvent q (PMF.memorylessChannel W n) t) hM ∧
      c.errorProbability W hM ≤
        ((PMF.channelJoint q (PMF.memorylessChannel W n)).toOuterMeasure
          (infoDensityThresholdEvent q (PMF.memorylessChannel W n) t)ᶜ).toReal +
            ((M : ℝ) - 1) * Real.exp (-t) := by
  obtain ⟨c, hc, hdecoder, herror⟩ :=
    exists_blockChannelCode_errorProbability_le_of_acceptanceEvent q W
      (infoDensityThresholdEvent q (PMF.memorylessChannel W n) t) hM
  refine ⟨c, hc, hdecoder, herror.trans ?_⟩
  have hMr : (1 : ℝ) ≤ M := by exact_mod_cast hM
  exact add_le_add le_rfl (mul_le_mul_of_nonneg_left
    (indepProd_infoDensityThresholdEvent_le q (PMF.memorylessChannel W n) t)
    (sub_nonneg.mpr hMr))

end
end LeanInfoTheory.Shannon
