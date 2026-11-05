/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.Coupling
import LeanInfoTheory.Shannon.SemanticBridge.Gluing

/-!
# Coupling gluing consumers

These private consumers obtain a Markov triple from the public gluing theorem
and project that same triple to a coupling of the endpoint laws. Only the last
alphabet needs finiteness. Supported channel rows determine the whole triple,
so arbitrary changes to null-fiber fallbacks preserve both prescribed pairs.

A Bool/Fin 3/Bool example has two positive middle fibers with different
deterministic endpoints and one null middle fiber. Its public gluing witness
is identified with an explicit channel extension, has diagonal endpoints, and
is unchanged when the null fallback changes from pure false to pure true.
Singleton, empty-coordinate and infinite ambient alphabet consumers check the
assumption boundary separately.

A fair/point-mass/fair Bool regression has maximal adjacent couplings but a
Markov gluing with independent endpoints. Its endpoint disagreement is one
half although endpoint total variation and diagonal disagreement are zero.
The same public gluing witness supplies the triple atoms and endpoint law;
arbitrary changes on its null middle row leave that whole witness unchanged.
-/

namespace LeanInfoTheory.Examples.CouplingGluing

universe u v w

open LeanInfoTheory.Shannon
open scoped BigOperators ENNReal

private theorem same_triple_endpoint_coupling
    {alpha : Type u} {beta : Type v} {gamma : Type w} [Finite gamma]
    {L : PMF (alpha × beta)} {R : PMF (beta × gamma)}
    {p : PMF alpha} {q : PMF beta} {r : PMF gamma}
    (hL : PMF.IsCoupling L p q) (hR : PMF.IsCoupling R q r) :
    ∃ T : PMF (alpha × beta × gamma),
      fstSndMarginal T = L ∧ sndThirdMarginal T = R ∧ IsMarkovChain T ∧
        PMF.IsCoupling (T.map (fun t => (t.1, t.2.2))) p r := by
  obtain ⟨T, hAB, hBC, hM⟩ :=
    exists_isMarkovChain_with_marginals L R (hL.2.trans hR.1.symm)
  refine ⟨T, hAB, hBC, hM, ?_, ?_⟩
  · calc
      (T.map (fun t => (t.1, t.2.2))).map Prod.fst =
          (fstSndMarginal T).map Prod.fst := by
            simp only [fstSndMarginal, PMF.map_comp]
            rfl
      _ = p := by rw [hAB, hL.1]
  · calc
      (T.map (fun t => (t.1, t.2.2))).map Prod.snd =
          (sndThirdMarginal T).map Prod.snd := by
            simp only [sndThirdMarginal, PMF.map_comp]
            rfl
      _ = r := by rw [hBC, hR.2]

private theorem markov_gluing_eq_extension
    {alpha : Type u} {beta : Type v} {gamma : Type w} [Finite gamma]
    (T : PMF (alpha × beta × gamma)) (L : PMF (alpha × beta))
    (R : PMF (beta × gamma)) (hAB : fstSndMarginal T = L)
    (hBC : sndThirdMarginal T = R) (hM : IsMarkovChain T)
    (V : beta → PMF gamma) (hV : PMF.channelJoint (L.map Prod.snd) V = R) :
    T = PMF.channelExtension L V := by
  obtain ⟨W, hW⟩ := (isMarkovChain_iff_exists_channelExtension T).1 hM
  rw [hAB] at hW
  have hWjoint : PMF.channelJoint (L.map Prod.snd) W = R := by
    calc
      _ = sndThirdMarginal (PMF.channelExtension L W) :=
        (PMF.channelExtension_map_outputPair L W).symm
      _ = sndThirdMarginal T := congrArg sndThirdMarginal hW.symm
      _ = R := hBC
  have hrows := (PMF.channelJoint_eq_iff_eq_on_support (L.map Prod.snd) W V).1
    (hWjoint.trans hV.symm)
  exact hW.trans ((PMF.channelExtension_eq_iff_eq_on_support L W V).2 hrows)

private theorem arbitrary_canonical_fallbacks
    {alpha : Type u} {beta : Type v} {gamma : Type w} [Fintype gamma]
    (L : PMF (alpha × beta)) (R : PMF (beta × gamma))
    (hmid : L.map Prod.snd = R.map Prod.fst) :
    ∃ T : PMF (alpha × beta × gamma),
      fstSndMarginal T = L ∧ sndThirdMarginal T = R ∧ IsMarkovChain T ∧
        ∀ V : beta → PMF gamma,
          (∀ b, b ∈ (L.map Prod.snd).support →
            V b = condFstGivenSndChannel (R.map Prod.swap) b) →
          PMF.channelExtension L V = T := by
  obtain ⟨T, hAB, hBC, hM⟩ := exists_isMarkovChain_with_marginals L R hmid
  have hcanonical :=
    (isMarkovChain_iff_eq_channelExtension_condFstGivenSndChannel T).1 hM
  rw [hAB, hBC] at hcanonical
  refine ⟨T, hAB, hBC, hM, ?_⟩
  intro V hV
  exact ((PMF.channelExtension_eq_iff_eq_on_support L V
    (condFstGivenSndChannel (R.map Prod.swap))).2 hV).trans hcanonical.symm

private noncomputable def fairBool : PMF Bool :=
  PMF.ofFintype (fun _ => ENNReal.ofReal (1 / 2 : ℝ)) (by
    rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
    norm_num)

private theorem fairBool_apply (b : Bool) : fairBool b = (1 / 2 : ℝ≥0∞) := by
  rw [fairBool, PMF.ofFintype_apply, ENNReal.ofReal_div_of_pos (by norm_num)]
  norm_num

private theorem fairBool_supported (b : Bool) : b ∈ fairBool.support := by
  rw [PMF.mem_support_iff, fairBool_apply]
  norm_num

private def middleCode (b : Bool) : Fin 3 := if b then 1 else 0

private theorem middleCode_injective : Function.Injective middleCode := by
  intro a b hab
  cases a <;> cases b <;> simp_all [middleCode]

private noncomputable def middleLaw : PMF (Fin 3) := fairBool.map middleCode

private theorem middleLaw_support_iff (b : Fin 3) :
    b ∈ middleLaw.support ↔ b = 0 ∨ b = 1 := by
  rw [middleLaw, PMF.mem_support_map_iff]
  constructor
  · rintro ⟨a, _, rfl⟩
    cases a <;> simp [middleCode]
  · rintro (rfl | rfl)
    · exact ⟨false, fairBool_supported false, rfl⟩
    · exact ⟨true, fairBool_supported true, rfl⟩

private theorem middleLaw_masses :
    middleLaw 0 = (1 / 2 : ℝ≥0∞) ∧
      middleLaw 1 = (1 / 2 : ℝ≥0∞) ∧ middleLaw 2 = 0 := by
  refine ⟨?_, ?_, ?_⟩
  · change (fairBool.map middleCode) (middleCode false) = (1 / 2 : ℝ≥0∞)
    rw [PMF.map_apply_of_injective fairBool middleCode_injective, fairBool_apply]
  · change (fairBool.map middleCode) (middleCode true) = (1 / 2 : ℝ≥0∞)
    rw [PMF.map_apply_of_injective fairBool middleCode_injective, fairBool_apply]
  · apply (middleLaw.apply_eq_zero_iff 2).2
    rw [middleLaw_support_iff]
    decide

private noncomputable def leftLaw : PMF (Bool × Fin 3) :=
  PMF.channelJoint fairBool (PMF.deterministicChannel middleCode)

private noncomputable def rightLaw : PMF (Fin 3 × Bool) := leftLaw.map Prod.swap

private theorem leftLaw_isCoupling : PMF.IsCoupling leftLaw fairBool middleLaw := by
  constructor
  · exact PMF.channelJoint_map_fst fairBool _
  · rw [leftLaw, PMF.channelJoint_map_snd, PMF.bind_deterministicChannel]
    rfl

private theorem rightLaw_isCoupling : PMF.IsCoupling rightLaw middleLaw fairBool :=
  leftLaw_isCoupling.map_swap

private theorem leftLaw_atoms (a : Bool) (b : Fin 3) :
    leftLaw (a, b) = if b = middleCode a then (1 / 2 : ℝ≥0∞) else 0 := by
  rw [leftLaw, PMF.channelJoint_apply, fairBool_apply]
  by_cases hb : b = middleCode a <;>
    simp [PMF.deterministicChannel, PMF.pure_apply, hb]

private theorem rightLaw_atoms (b : Fin 3) (c : Bool) :
    rightLaw (b, c) = if b = middleCode c then (1 / 2 : ℝ≥0∞) else 0 := by
  calc
    rightLaw (b, c) = leftLaw (c, b) :=
      PMF.map_apply_equiv leftLaw (Equiv.prodComm Bool (Fin 3)) (c, b)
    _ = _ := leftLaw_atoms c b

private def fallbackOutput (fallback : Bool) (b : Fin 3) : Bool :=
  if b = 2 then fallback else decide (b = 1)

private theorem fallbackOutput_middleCode (fallback a : Bool) :
    fallbackOutput fallback (middleCode a) = a := by
  cases a <;> rfl

private noncomputable def fallbackChannel (fallback : Bool) : Fin 3 → PMF Bool :=
  PMF.deterministicChannel (fallbackOutput fallback)

private theorem fallbackChannel_rows (fallback : Bool) :
    fallbackChannel fallback 0 = PMF.pure false ∧
      fallbackChannel fallback 1 = PMF.pure true ∧
      fallbackChannel fallback 2 = PMF.pure fallback := by
  exact ⟨rfl, rfl, rfl⟩

private theorem fallback_channels_differ :
    fallbackChannel false 2 ≠ fallbackChannel true 2 := by
  intro heq
  have hatom := congrArg (fun p : PMF Bool => p false) heq
  norm_num [fallbackChannel, PMF.deterministicChannel, fallbackOutput,
    PMF.pure_apply] at hatom

private theorem fallback_channels_agree_on_support (b : Fin 3)
    (hb : b ∈ (leftLaw.map Prod.snd).support) :
    fallbackChannel true b = fallbackChannel false b := by
  rw [leftLaw_isCoupling.2] at hb
  rcases (middleLaw_support_iff b).1 hb with rfl | rfl <;> rfl

private theorem fallback_reconstructs_rightLaw (fallback : Bool) :
    PMF.channelJoint middleLaw (fallbackChannel fallback) = rightLaw := by
  rw [fallbackChannel, PMF.channelJoint_deterministicChannel]
  change (fairBool.map middleCode).map (fun b => (b, fallbackOutput fallback b)) =
    (PMF.channelJoint fairBool (PMF.deterministicChannel middleCode)).map Prod.swap
  rw [PMF.channelJoint_deterministicChannel, PMF.map_comp, PMF.map_comp]
  apply congrArg (fun f : Bool → Fin 3 × Bool => fairBool.map f)
  funext a
  change (middleCode a, fallbackOutput fallback (middleCode a)) = (middleCode a, a)
  rw [fallbackOutput_middleCode]

private theorem extension_fallback_graph (fallback : Bool) :
    PMF.channelExtension leftLaw (fallbackChannel fallback) =
      fairBool.map (fun a => (a, middleCode a, a)) := by
  rw [fallbackChannel, PMF.channelExtension_deterministicChannel, leftLaw,
    PMF.channelJoint_deterministicChannel, PMF.map_comp]
  apply congrArg (fun f : Bool → Bool × Fin 3 × Bool => fairBool.map f)
  funext a
  change (a, middleCode a, fallbackOutput fallback (middleCode a)) =
    (a, middleCode a, a)
  rw [fallbackOutput_middleCode]

private theorem two_positive_fibers_and_null_fallback :
    ∃ T : PMF (Bool × Fin 3 × Bool),
      fstSndMarginal T = leftLaw ∧ sndThirdMarginal T = rightLaw ∧ IsMarkovChain T ∧
        T = PMF.channelExtension leftLaw (fallbackChannel false) ∧
        T.map (fun t => (t.1, t.2.2)) = fairBool.map (fun b => (b, b)) ∧
        PMF.channelExtension leftLaw (fallbackChannel true) = T := by
  obtain ⟨T, hAB, hBC, hM⟩ := exists_isMarkovChain_with_marginals leftLaw rightLaw
    (leftLaw_isCoupling.2.trans rightLaw_isCoupling.1.symm)
  have hreal :
      PMF.channelJoint (leftLaw.map Prod.snd) (fallbackChannel false) = rightLaw := by
    rw [leftLaw_isCoupling.2]
    exact fallback_reconstructs_rightLaw false
  have hT := markov_gluing_eq_extension T leftLaw rightLaw hAB hBC hM
    (fallbackChannel false) hreal
  have hnull := (PMF.channelExtension_eq_iff_eq_on_support leftLaw
    (fallbackChannel true) (fallbackChannel false)).2 fallback_channels_agree_on_support
  refine ⟨T, hAB, hBC, hM, hT, ?_, hnull.trans hT.symm⟩
  rw [hT, extension_fallback_graph, PMF.map_comp]
  rfl

private theorem pure_gluing
    {alpha : Type u} {beta : Type v} {gamma : Type w} [Finite gamma]
    (a : alpha) (b : beta) (c : gamma) :
    ∃ T : PMF (alpha × beta × gamma),
      fstSndMarginal T = PMF.pure (a, b) ∧ sndThirdMarginal T = PMF.pure (b, c) ∧
        IsMarkovChain T ∧ T = PMF.pure (a, b, c) := by
  have hmid : (PMF.pure (a, b)).map Prod.snd = (PMF.pure (b, c)).map Prod.fst := by
    simp only [PMF.pure_map]
  obtain ⟨T, hAB, hBC, hM⟩ :=
    exists_isMarkovChain_with_marginals (PMF.pure (a, b)) (PMF.pure (b, c)) hmid
  have hV : PMF.channelJoint ((PMF.pure (a, b)).map Prod.snd)
      (fun _ => PMF.pure c) = PMF.pure (b, c) := by
    simp only [PMF.pure_map, PMF.channelJoint, PMF.pure_bind]
  have hT := markov_gluing_eq_extension T (PMF.pure (a, b)) (PMF.pure (b, c))
    hAB hBC hM (fun _ => PMF.pure c) hV
  refine ⟨T, hAB, hBC, hM, ?_⟩
  rw [hT, PMF.channelExtension, PMF.pure_bind, PMF.pure_map]

private theorem singleton_gluing :
    ∃ T : PMF (Unit × Unit × Unit),
      fstSndMarginal T = PMF.pure ((), ()) ∧
        sndThirdMarginal T = PMF.pure ((), ()) ∧ IsMarkovChain T ∧
          PMF.IsCoupling (T.map (fun t => (t.1, t.2.2))) (PMF.pure ()) (PMF.pure ()) := by
  have hpair : PMF.IsCoupling (PMF.pure ((), ())) (PMF.pure ()) (PMF.pure ()) := by
    constructor <;> simp only [PMF.pure_map]
  exact same_triple_endpoint_coupling hpair hpair

private theorem natural_ambient_gluing
    {L : PMF (Nat × Nat)} {R : PMF (Nat × Bool)}
    {p q : PMF Nat} {r : PMF Bool}
    (hL : PMF.IsCoupling L p q) (hR : PMF.IsCoupling R q r) :
    ∃ T : PMF (Nat × Nat × Bool),
      fstSndMarginal T = L ∧ sndThirdMarginal T = R ∧ IsMarkovChain T ∧
        PMF.IsCoupling (T.map (fun t => (t.1, t.2.2))) p r :=
  same_triple_endpoint_coupling hL hR

private theorem empty_coordinate_impossible
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    (hempty : IsEmpty alpha ∨ IsEmpty beta ∨ IsEmpty gamma)
    (T : PMF (alpha × beta × gamma)) : False := by
  obtain ⟨⟨a, b, c⟩, _⟩ := T.support_nonempty
  rcases hempty with ha | hb | hc
  · let := ha
    exact isEmptyElim a
  · let := hb
    exact isEmptyElim b
  · let := hc
    exact isEmptyElim c

/-! ## Maximal adjacent couplings need not give maximal endpoints -/

private theorem bool_disagreement_eq (J : PMF (Bool × Bool)) :
    J.toOuterMeasure {xy | xy.1 ≠ xy.2} = J (false, true) + J (true, false) := by
  rw [PMF.toOuterMeasure_apply_fintype]
  simp [Fintype.sum_prod_type, Set.indicator, add_comm]

private noncomputable def fairPureLeft : PMF (Bool × Bool) :=
  PMF.channelJoint fairBool (fun _ => PMF.pure false)

private noncomputable def pureFairRight : PMF (Bool × Bool) :=
  PMF.channelJoint (PMF.pure false) (fun _ => fairBool)

private noncomputable def fairIndependent : PMF (Bool × Bool) :=
  PMF.channelJoint fairBool (fun _ => fairBool)

private theorem fair_pure_couplings :
    PMF.IsCoupling fairPureLeft fairBool (PMF.pure false) ∧
      PMF.IsCoupling pureFairRight (PMF.pure false) fairBool :=
  ⟨PMF.isCoupling_channelJoint_const fairBool (PMF.pure false),
    PMF.isCoupling_channelJoint_const (PMF.pure false) fairBool⟩

private theorem fair_pure_totalVariation :
    PMF.totalVariation fairBool (PMF.pure false) = 1 / 2 ∧
      PMF.totalVariation (PMF.pure false) fairBool = 1 / 2 := by
  have h : PMF.totalVariation (PMF.pure false) fairBool = 1 / 2 := by
    norm_num [PMF.totalVariation, Fintype.sum_bool, PMF.pure_apply,
      fairBool, PMF.ofFintype_apply]
  exact ⟨(PMF.totalVariation_comm fairBool (PMF.pure false)).trans h, h⟩

private theorem fair_pure_disagreement_ennreal :
    fairPureLeft.toOuterMeasure {xy | xy.1 ≠ xy.2} = ENNReal.ofReal (1 / 2 : ℝ) ∧
      pureFairRight.toOuterMeasure {xy | xy.1 ≠ xy.2} = ENNReal.ofReal (1 / 2 : ℝ) := by
  constructor <;> rw [bool_disagreement_eq] <;>
    norm_num [fairPureLeft, pureFairRight, PMF.channelJoint_apply, PMF.pure_apply,
      fairBool, PMF.ofFintype_apply]

private theorem fair_pure_disagreement :
    fairPureLeft.toOuterMeasure {xy | xy.1 ≠ xy.2} ≠ ⊤ ∧
      pureFairRight.toOuterMeasure {xy | xy.1 ≠ xy.2} ≠ ⊤ ∧
      (fairPureLeft.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 1 / 2 ∧
      (pureFairRight.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 1 / 2 := by
  rcases fair_pure_disagreement_ennreal with ⟨hleft, hright⟩
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [hleft]
    exact ENNReal.ofReal_ne_top
  · rw [hright]
    exact ENNReal.ofReal_ne_top
  · rw [hleft, ENNReal.toReal_ofReal (by norm_num)]
  · rw [hright, ENNReal.toReal_ofReal (by norm_num)]

private theorem fair_pure_adjacent_maximalities :
    (∀ J : PMF (Bool × Bool), PMF.IsCoupling J fairBool (PMF.pure false) →
      (fairPureLeft.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal ≤
        (J.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal) ∧
    (∀ J : PMF (Bool × Bool), PMF.IsCoupling J (PMF.pure false) fairBool →
      (pureFairRight.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal ≤
        (J.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal) := by
  rcases fair_pure_disagreement with ⟨_, _, hleft, hright⟩
  constructor
  · intro J hJ
    calc
      _ = 1 / 2 := hleft
      _ = PMF.totalVariation fairBool (PMF.pure false) := fair_pure_totalVariation.1.symm
      _ ≤ _ := hJ.totalVariation_le
  · intro J hJ
    calc
      _ = 1 / 2 := hright
      _ = PMF.totalVariation (PMF.pure false) fairBool := fair_pure_totalVariation.2.symm
      _ ≤ _ := hJ.totalVariation_le

private theorem fairIndependent_atoms (a c : Bool) :
    fairIndependent (a, c) = ENNReal.ofReal (1 / 4 : ℝ) := by
  simp only [fairIndependent, PMF.channelJoint_apply, fairBool, PMF.ofFintype_apply]
  rw [← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  congr 1
  norm_num

private theorem fairIndependent_disagreement_ennreal :
    fairIndependent.toOuterMeasure {xy | xy.1 ≠ xy.2} = ENNReal.ofReal (1 / 2 : ℝ) := by
  simp only [bool_disagreement_eq, fairIndependent_atoms]
  rw [← ENNReal.ofReal_add (by norm_num) (by norm_num)]
  congr 1
  norm_num

private theorem fair_pure_fair_gluing_not_maximal :
    ∃ T : PMF (Bool × Bool × Bool),
      fstSndMarginal T = fairPureLeft ∧ sndThirdMarginal T = pureFairRight ∧
        IsMarkovChain T ∧
        (∀ a c, T (a, false, c) = ENNReal.ofReal (1 / 4 : ℝ) ∧ T (a, true, c) = 0) ∧
        PMF.IsCoupling (T.map (fun t => (t.1, t.2.2))) fairBool fairBool ∧
        T.map (fun t => (t.1, t.2.2)) = fairIndependent ∧
        (T.map (fun t => (t.1, t.2.2))).toOuterMeasure {xy | xy.1 ≠ xy.2} =
          ENNReal.ofReal (1 / 2 : ℝ) ∧
        (T.map (fun t => (t.1, t.2.2))).toOuterMeasure {xy | xy.1 ≠ xy.2} ≠ ⊤ ∧
        ((T.map (fun t => (t.1, t.2.2))).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 1 / 2 ∧
        PMF.IsCoupling (fairBool.map (fun b => (b, b))) fairBool fairBool ∧
        (fairBool.map (fun b => (b, b))).toOuterMeasure {xy | xy.1 ≠ xy.2} = 0 ∧
        ((fairBool.map (fun b => (b, b))).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 0 ∧
        PMF.totalVariation fairBool fairBool = 0 ∧
        PMF.totalVariation fairBool fairBool <
          ((T.map (fun t => (t.1, t.2.2))).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal ∧
        ((fairBool.map (fun b => (b, b))).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal <
          ((T.map (fun t => (t.1, t.2.2))).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal ∧
        ∀ V : Bool → PMF Bool, V false = fairBool → PMF.channelExtension fairPureLeft V = T := by
  rcases fair_pure_couplings with ⟨hleft, hright⟩
  obtain ⟨T, hAB, hBC, hM⟩ := exists_isMarkovChain_with_marginals fairPureLeft pureFairRight
    (hleft.2.trans hright.1.symm)
  have hV : PMF.channelJoint (fairPureLeft.map Prod.snd) (fun _ => fairBool) =
      pureFairRight := by
    rw [hleft.2]
    rfl
  have hT := markov_gluing_eq_extension T fairPureLeft pureFairRight hAB hBC hM
    (fun _ => fairBool) hV
  have hatoms (a c : Bool) :
      T (a, false, c) = ENNReal.ofReal (1 / 4 : ℝ) ∧ T (a, true, c) = 0 := by
    rw [hT]
    constructor
    · rw [PMF.channelExtension_apply, fairPureLeft, PMF.channelJoint_apply]
      simp only [PMF.pure_apply_self, mul_one]
      simpa only [fairIndependent, PMF.channelJoint_apply] using fairIndependent_atoms a c
    · simp [PMF.channelExtension_apply, fairPureLeft, PMF.channelJoint_apply, PMF.pure_apply]
  have hendpoints : T.map (fun t => (t.1, t.2.2)) = fairIndependent := by
    rw [hT, fairPureLeft, PMF.channelExtension_map_endpoints]
    change PMF.channelJoint fairBool
      (fun _ : Bool => (PMF.pure false).bind (fun _ : Bool => fairBool)) = fairIndependent
    rw [PMF.pure_bind]
    rfl
  have hcoupling : PMF.IsCoupling (T.map (fun t => (t.1, t.2.2))) fairBool fairBool := by
    rw [hendpoints]
    exact PMF.isCoupling_channelJoint_const fairBool fairBool
  have hevent : (T.map (fun t => (t.1, t.2.2))).toOuterMeasure {xy | xy.1 ≠ xy.2} =
      ENNReal.ofReal (1 / 2 : ℝ) := by
    rw [hendpoints]
    exact fairIndependent_disagreement_ennreal
  have hfinite : (T.map (fun t => (t.1, t.2.2))).toOuterMeasure {xy | xy.1 ≠ xy.2} ≠ ⊤ := by
    rw [hevent]
    exact ENNReal.ofReal_ne_top
  have hreal :
      ((T.map (fun t => (t.1, t.2.2))).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 1 / 2 := by
    rw [hevent, ENNReal.toReal_ofReal (by norm_num)]
  have hdiag : (fairBool.map (fun b => (b, b))).toOuterMeasure {xy | xy.1 ≠ xy.2} = 0 := by
    rw [PMF.toOuterMeasure_map_apply]
    simp
  have hdiagReal :
      ((fairBool.map (fun b => (b, b))).toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal = 0 := by
    rw [hdiag, ENNReal.toReal_zero]
  refine ⟨T, hAB, hBC, hM, hatoms, hcoupling, hendpoints, hevent, hfinite, hreal,
    PMF.isCoupling_map_diag fairBool, hdiag, hdiagReal, PMF.totalVariation_self fairBool,
    ?_, ?_, ?_⟩
  · rw [PMF.totalVariation_self, hreal]
    norm_num
  · rw [hdiagReal, hreal]
    norm_num
  · intro V hrow
    apply Eq.trans ?_ hT.symm
    apply (PMF.channelExtension_eq_iff_eq_on_support fairPureLeft V (fun _ => fairBool)).2
    intro b hb
    rw [hleft.2, PMF.mem_support_pure_iff] at hb
    simpa only [hb] using hrow

end LeanInfoTheory.Examples.CouplingGluing
