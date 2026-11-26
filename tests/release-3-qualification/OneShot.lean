/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCodingOneShot
import LeanInfoTheory.Shannon.IidInformationDensity

/-! C40.03 qualification of the laws, decoder and deterministic finite-block bound. -/

noncomputable section

open LeanInfoTheory.Shannon
open Filter
open scoped BigOperators

namespace LeanInfoTheory.Qualification.OneShot

section General

variable {X Y : Type*} [Fintype X] [Fintype Y]

/-- The pointwise log comparison uses true support. The closed miss is an equality of
true-pair probabilities and the strict-pass tail is measured under the independent law. -/
private theorem thresholdLaws (p : PMF X) (W : X → PMF Y) (t : ℝ) :
    (∑ z, ((PMF.channelJoint p W) z).toReal * infoDensity p W z) =
      mutualInfo (PMF.channelJoint p W) ∧
    (∀ z ∈ (PMF.channelJoint p W).support,
      (z ∈ infoDensityThresholdEvent p W t ↔ t < infoDensity p W z)) ∧
    ((PMF.channelJoint p W).toOuterMeasure (infoDensityThresholdEvent p W t)ᶜ).toReal =
      ((PMF.channelJoint p W).toOuterMeasure {z | infoDensity p W z ≤ t}).toReal ∧
    ((indepProd p (p.bind W)).toOuterMeasure (infoDensityThresholdEvent p W t)).toReal ≤
      Real.exp (-t) :=
  ⟨sum_mul_infoDensity_eq_mutualInfo p W,
    fun _ hz => mem_infoDensityThresholdEvent_iff_of_mem_support p W t hz,
    channelJoint_infoDensityThresholdEvent_compl_eq p W t,
    indepProd_infoDensityThresholdEvent_le p W t⟩

/-- A supported block pair has additive density; the literal miss tends to zero when
its threshold slope lies strictly below the mean of a single use. -/
private theorem iidDensity (p : PMF X) (W : X → PMF Y) (n : ℕ)
    (z : (Fin n → X) × (Fin n → Y))
    (hz : z ∈ (PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).support)
    (s : ℝ) (hs : s < mutualInfo (PMF.channelJoint p W)) :
    infoDensity (PMF.iid p n) (PMF.memorylessChannel W n) z =
      ∑ i, infoDensity p W (z.1 i, z.2 i) ∧
    Tendsto (fun k : ℕ =>
      ((PMF.channelJoint (PMF.iid p k) (PMF.memorylessChannel W k)).toOuterMeasure
        (infoDensityThresholdEvent (PMF.iid p k) (PMF.memorylessChannel W k)
          ((k : ℝ) * s))ᶜ).toReal) atTop (nhds 0) :=
  ⟨infoDensity_iid_of_mem_support p W n hz, tendsto_prob_infoDensityThresholdEvent_iid_compl p W hs⟩

/-- The normalized block-density deviations are small under the true iid joint law
for every fixed positive tolerance. The displayed length k+1 is positive. -/
private theorem normalizedConcentration (p : PMF X) (W : X → PMF Y) (ε : ℝ) (hε : 0 < ε) :
    Tendsto (fun k : ℕ =>
      let n := k + 1
      ((PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).toOuterMeasure
        {z | ε ≤ |infoDensity (PMF.iid p n) (PMF.memorylessChannel W n) z / (n : ℝ) -
          mutualInfo (PMF.channelJoint p W)|}).toReal) atTop (nhds 0) :=
  tendsto_infoDensity_iid_deviation p W hε

omit [Fintype Y] in
/-- Extract both projections of one random-book and output experiment. The competing
word is independent of the output after averaging over the book. -/
private theorem pairProjections {n M : ℕ} (q : PMF (Fin n → X))
    (K : (Fin n → X) → PMF (Fin n → Y)) (m j : Fin M) (hj : j ≠ m) :
    let L := codebookOutputLaw q K m
    L.map (fun z => (z.1 m, z.2)) = PMF.channelJoint q K ∧
    L.map (fun z => (z.1 j, z.2)) = indepProd q (q.bind K) :=
  ⟨codebookOutputLaw_map_sentOutput q K m, codebookOutputLaw_map_competingOutput q K m j hj⟩

/-- Keep the event and exponential bounds on the same realized code, with its actual
encoder and total decoder. The threshold is tested at the arbitrary word prior. -/
private theorem selectedCode {n M : ℕ} (q : PMF (Fin n → X))
    (W : X → PMF Y) (t : ℝ) (hM : 1 ≤ M) :
    let K := PMF.memorylessChannel W n
    let A := infoDensityThresholdEvent q K t
    let miss := ((PMF.channelJoint q K).toOuterMeasure Aᶜ).toReal
    ∃ c : BlockChannelCode X Y n M,
      c.encoder ∈ (PMF.iid q M).support ∧
      c.decoder = (BlockChannelCode.ofAcceptanceEvent c.encoder A hM).decoder ∧
      c.errorProbability W hM ≤ miss + ((M : ℝ) - 1) *
        ((indepProd q (q.bind K)).toOuterMeasure A).toReal ∧
      c.errorProbability W hM ≤ miss + ((M : ℝ) - 1) * Real.exp (-t) := by
  intro K A miss
  obtain ⟨c, hbook, hcode, herror⟩ :=
    exists_blockChannelCode_errorProbability_le_of_acceptanceEvent q W A hM
  have hMr : (1 : ℝ) ≤ M := by exact_mod_cast hM
  refine ⟨c, hbook, congrArg (fun d : BlockChannelCode X Y n M => d.decoder) hcode, herror, ?_⟩
  exact herror.trans (add_le_add (le_refl miss) (mul_le_mul_of_nonneg_left
    (indepProd_infoDensityThresholdEvent_le q K t) (sub_nonneg.mpr hMr)))

/-- A singleton budget removes the competing term at any threshold and channel;
the actual deterministic decoder always returns the only possible label. -/
private theorem singletonBudget {n : ℕ} (q : PMF (Fin n → X)) (W : X → PMF Y) (t : ℝ) :
    let A := infoDensityThresholdEvent q (PMF.memorylessChannel W n) t
    ∃ c : BlockChannelCode X Y n 1, c.encoder ∈ (PMF.iid q 1).support ∧
      c = BlockChannelCode.ofAcceptanceEvent c.encoder A (by decide) ∧
      (∀ y, c.decoder y = 0) ∧ c.errorProbability W (by decide) = 0 ∧
      c.errorProbability W (by decide) ≤
        ((PMF.channelJoint q (PMF.memorylessChannel W n)).toOuterMeasure Aᶜ).toReal := by
  intro A
  obtain ⟨c, hbook, hdecoder, hb⟩ :=
    exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold q W t (by decide : 1 ≤ 1)
  refine ⟨c, hbook, hdecoder, fun _ => Subsingleton.elim _ _, c.errorProbability_one W, ?_⟩
  simpa only [Nat.cast_one, sub_self, zero_mul, add_zero] using hb

end General

section NoiselessExample

private abbrev Letter := Fin 4
private abbrev Word := Fin 1 → Letter
private abbrev q : PMF Word := PMF.uniformOfFintype Word
private abbrev W : Letter → PMF Letter := PMF.deterministicChannel id
private abbrev K := PMF.memorylessChannel W 1
private abbrev J := PMF.channelJoint q K
private abbrev Q := indepProd q (q.bind K)
private def diagonal : Set (Word × Word) := {z | z.1 = z.2}

private theorem noiseless : K = PMF.pure := by
  change PMF.productChannel (fun _ : Fin 1 => PMF.deterministicChannel (id : Letter → Letter)) = _
  rw [PMF.productChannel_deterministicChannel]
  rfl

private theorem wordMass (x : Word) : (q x).toReal = 1 / 4 := by
  norm_num [q, PMF.uniformOfFintype_apply, Fintype.card_fun]

private theorem jointMass (x y : Word) : (J (x,y)).toReal = if x = y then 1 / 4 else 0 := by
  classical
  rw [PMF.channelJoint_apply, ENNReal.toReal_mul, wordMass, noiseless, PMF.pure_apply]
  by_cases h : x = y
  · simp [h]
  · simp [h, Ne.symm h]

private theorem independentMass (x y : Word) : (Q (x,y)).toReal = 1 / 16 := by
  rw [indepProd_apply, ENNReal.toReal_mul, noiseless, PMF.bind_pure, wordMass, wordMass]
  norm_num

/-- A Q-positive off-diagonal pair has totalized log density zero, which exceeds −1,
while the global strict mass test correctly excludes this impossible sent pair. -/
private theorem impossiblePair (x y : Word) (h : x ≠ y) :
    (J (x,y)).toReal = 0 ∧ (Q (x,y)).toReal = 1 / 16 ∧
    (-1 : ℝ) < infoDensity q K (x,y) ∧ (x,y) ∉ infoDensityThresholdEvent q K (-1) := by
  have hj := jointMass x y
  rw [if_neg h] at hj
  refine ⟨hj, independentMass x y, ?_, ?_⟩
  · change -1 < Real.log ((J (x,y)).toReal / (Q (x,y)).toReal)
    rw [hj, zero_div, Real.log_zero]
    norm_num
  · change ¬ Real.exp (-1) * (Q (x,y)).toReal < (J (x,y)).toReal
    rw [independentMass, hj]
    exact not_lt_of_ge (mul_nonneg (Real.exp_pos _).le (by norm_num))

private theorem offDiagonalWitness :
    ∃ (x y : Word), (x,y) ∉ J.support ∧ (Q (x,y)).toReal = 1 / 16 ∧
      (-1 : ℝ) < infoDensity q K (x,y) ∧ (x,y) ∉ infoDensityThresholdEvent q K (-1) := by
  let x : Word := fun _ => 0
  let y : Word := fun _ => 1
  have h : x ≠ y := fun e => (by decide : (0 : Letter) ≠ 1) (congrFun e 0)
  have hj : J (x,y) = 0 := by
    rw [PMF.channelJoint_apply, noiseless, PMF.pure_apply, if_neg (Ne.symm h), mul_zero]
  exact ⟨x,y,fun hs => (PMF.mem_support_iff _ _).mp hs hj,(impossiblePair x y h).2⟩

/-- At log 4, every diagonal pair has positive true mass and lies exactly at the
threshold, so the strict test misses it. -/
private theorem positiveTie (x : Word) :
    (J (x,x)).toReal = 1 / 4 ∧ infoDensity q K (x,x) = Real.log 4 ∧
      (x,x) ∉ infoDensityThresholdEvent q K (Real.log 4) := by
  have hj : (J (x,x)).toReal = 1 / 4 := (jointMass x x).trans (if_pos rfl)
  refine ⟨hj, ?_, ?_⟩
  · change Real.log ((J (x,x)).toReal / (Q (x,x)).toReal) = _
    rw [hj, independentMass]
    norm_num
  · change ¬ Real.exp (Real.log 4) * (Q (x,x)).toReal < (J (x,x)).toReal
    rw [Real.exp_log (by norm_num : 0 < (4 : ℝ)), hj, independentMass]
    norm_num

private theorem passAtLogThree : infoDensityThresholdEvent q K (Real.log 3) = diagonal := by
  ext ⟨x,y⟩
  change Real.exp (Real.log 3) * (Q (x,y)).toReal < (J (x,y)).toReal ↔ x = y
  rw [Real.exp_log (by norm_num : 0 < (3 : ℝ)), independentMass, jointMass]
  by_cases h : x = y <;> norm_num [h]

private theorem eventMasses : (J.toOuterMeasure diagonalᶜ).toReal = 0 ∧
    (Q.toOuterMeasure diagonal).toReal = 1 / 4 := by
  classical
  constructor
  · rw [PMF.toOuterMeasure_toReal_eq_sum, Fintype.sum_prod_type]
    apply Finset.sum_eq_zero
    intro x _
    apply Finset.sum_eq_zero
    intro y _
    by_cases h : x = y
    · exact Set.indicator_of_notMem (show (x,y) ∉ diagonalᶜ from fun hc => hc h) _
    · rw [Set.indicator_of_mem (show (x,y) ∈ diagonalᶜ from h)]
      exact (jointMass x y).trans (if_neg h)
  · rw [PMF.toOuterMeasure_toReal_eq_sum, Fintype.sum_prod_type]
    have term (x y : Word) :
        diagonal.indicator (fun z => (Q z).toReal) (x,y) =
          if y = x then 1 / 16 else 0 := by
      by_cases h : y = x
      · rw [Set.indicator_of_mem (show (x,y) ∈ diagonal from h.symm), if_pos h]
        exact independentMass x y
      · rw [Set.indicator_of_notMem (show (x,y) ∉ diagonal from Ne.symm h), if_neg h]
    simp_rw [term]
    norm_num [Fintype.card_fun]

/-- Both labels send exactly x. On output x, both pass the diagonal event, so its
actual first-match decoder returns index zero and errs if label one was sent. -/
private theorem duplicateWords (x : Word) :
    let b : Fin 2 → Word := fun _ => x
    b 0 = b 1 ∧ (b 0,x) ∈ diagonal ∧ (b 1,x) ∈ diagonal ∧
      (BlockChannelCode.ofAcceptanceEvent b diagonal (by decide)).decoder x ≠ 1 := by
  classical
  intro b
  refine ⟨rfl, rfl, rfl, ?_⟩
  let s := Finset.univ.filter (fun j => (b j,x) ∈ diagonal)
  have h0 : (0 : Fin 2) ∈ s := Finset.mem_filter.mpr ⟨Finset.mem_univ _, rfl⟩
  have hmin : s.min' ⟨0,h0⟩ = (0 : Fin 2) := (Finset.min'_eq_iff s _ 0).mpr
    ⟨h0, fun _ _ => Fin.zero_le _⟩
  change (if h : s.Nonempty then s.min' h else ⟨0, by decide⟩) ≠ 1
  rw [dif_pos (show s.Nonempty from ⟨0,h0⟩), hmin]
  decide

/-- Two messages, four equiprobable one-letter words and noiseless transmission.
One supported realization satisfies both finite bounds, each strictly below 1/2. -/
private theorem twoMessageGuarantees :
    ∃ c : BlockChannelCode Letter Letter 1 2, c.encoder ∈ (PMF.iid q 2).support ∧
      c.decoder = (BlockChannelCode.ofAcceptanceEvent c.encoder diagonal (by decide)).decoder ∧
      c.errorProbability W (by decide) ≤ 1 / 4 ∧
      c.errorProbability W (by decide) ≤ 1 / 3 ∧ c.errorProbability W (by decide) < 1 / 2 := by
  obtain ⟨c,hbook,hd,hA,hExp⟩ := selectedCode q W (Real.log 3) (by decide : 1 ≤ 2)
  rw [passAtLogThree] at hd hA hExp
  rw [eventMasses.1, eventMasses.2] at hA
  rw [eventMasses.1, Real.exp_neg, Real.exp_log (by norm_num : 0 < (3 : ℝ))] at hExp
  norm_num at hA hExp
  exact ⟨c,hbook,hd,hA,hExp,hA.trans_lt (by norm_num)⟩

end NoiselessExample
end LeanInfoTheory.Qualification.OneShot
