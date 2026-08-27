/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.FiniteMixture
import LeanInfoTheory.Shannon.EntropyConcavity
import LeanInfoTheory.Shannon.LogSum
import LeanInfoTheory.Shannon.SemanticBridge.Convexity

/-!
# Convexity examples

This module provides maintained, non-public regression coverage for the finite
log-sum, mixture, entropy-concavity, relative-entropy-convexity, and
mutual-information-convexity APIs.
-/

namespace LeanInfoTheory
namespace Examples
namespace Convexity

open scoped BigOperators ENNReal
open Shannon

noncomputable section

/-! ## Scalar log-sum regressions -/

private def allZero : Bool -> NNReal := fun _ => 0

private def allOne : Bool -> NNReal := fun _ => 1

private def finiteNumerator : Bool -> NNReal
  | false => 2
  | true => 2

private def finiteDenominator : Bool -> NNReal
  | false => 1
  | true => 1

private def nonconstantNumerator : Bool -> NNReal
  | false => 1
  | true => 2

private def supportGuardData : Bool -> NNReal
  | false => 0
  | true => 1

private example :
    logSumTerm (∑ i ∈ (∅ : Finset Bool), allZero i)
        (∑ i ∈ (∅ : Finset Bool), allZero i) <=
      ∑ i ∈ (∅ : Finset Bool), logSumTerm (allZero i) (allZero i) :=
  logSum_inequality ∅ allZero allZero

private example : logSumTerm 0 0 = 0 :=
  logSumTerm_zero_left 0

private example :
    logSumTerm (∑ i ∈ Finset.univ, allZero i)
        (∑ i ∈ Finset.univ, allZero i) =
      ∑ i ∈ Finset.univ, logSumTerm (allZero i) (allZero i) := by
  apply (logSum_eq_iff_exists_constant_ratio Finset.univ allZero allZero).2
  refine ⟨0, ?_⟩
  intro i hi hactive
  simp [allZero] at hactive

private example : logSumTerm 0 3 = 0 :=
  logSumTerm_zero_left 3

private example : logSumTerm 2 0 = ⊤ :=
  logSumTerm_pos_zero (by norm_num)

private example :
    (∑ i : Bool, logSumTerm 1 (if i then 0 else 1)) = ⊤ := by
  simp only [Fintype.sum_bool, if_pos]
  rw [logSumTerm_pos_zero (by norm_num)]
  exact EReal.top_add_of_ne_bot (logSumTerm_ne_bot 1 1)

private example :
    logSumTerm (∑ i ∈ Finset.univ, allOne i)
        (∑ i ∈ Finset.univ, allZero i) = ⊤ := by
  rw [show (∑ i ∈ (Finset.univ : Finset Bool), allZero i) = 0 by
    simp [allZero]]
  apply logSumTerm_pos_zero
  simp [allOne]

private example :
    logSumTerm (∑ i ∈ ({false} : Finset Bool), finiteNumerator i)
        (∑ i ∈ ({false} : Finset Bool), finiteDenominator i) =
      ∑ i ∈ ({false} : Finset Bool),
        logSumTerm (finiteNumerator i) (finiteDenominator i) := by
  simp [finiteNumerator, finiteDenominator]

private example : logSumTerm 1 0 ≠ ⊥ :=
  logSumTerm_ne_bot 1 0

private example :
    (∑ i ∈ Finset.univ, logSumTerm (allOne i) (allZero i)) ≠ ⊥ :=
  sum_logSumTerm_ne_bot Finset.univ allOne allZero

private example :
    logSumTerm (∑ i ∈ Finset.univ, allZero i)
        (∑ i ∈ Finset.univ, allOne i) =
      ∑ i ∈ Finset.univ, logSumTerm (allZero i) (allOne i) := by
  apply (logSum_eq_iff_exists_constant_ratio Finset.univ allZero allOne).2
  refine ⟨0, ?_⟩
  intro i hi hactive
  simp [allZero, allOne]

private example :
    logSumTerm (∑ i ∈ Finset.univ, finiteNumerator i)
        (∑ i ∈ Finset.univ, finiteDenominator i) =
      ∑ i ∈ Finset.univ,
        logSumTerm (finiteNumerator i) (finiteDenominator i) := by
  apply
    (logSum_eq_iff_exists_constant_ratio
      Finset.univ finiteNumerator finiteDenominator).2
  refine ⟨2, ?_⟩
  intro i hi hactive
  cases i <;> norm_num [finiteNumerator, finiteDenominator]

private example :
    logSumTerm (∑ i ∈ Finset.univ, allOne i)
        (∑ i ∈ Finset.univ, allZero i) =
      ∑ i ∈ Finset.univ, logSumTerm (allOne i) (allZero i) := by
  apply (logSum_eq_iff_exists_constant_ratio Finset.univ allOne allZero).2
  refine ⟨⊤, ?_⟩
  intro i hi hactive
  simp [allOne, allZero]

private example :
    ¬ (logSumTerm (∑ i ∈ Finset.univ, nonconstantNumerator i)
          (∑ i ∈ Finset.univ, allOne i) =
        ∑ i ∈ Finset.univ,
          logSumTerm (nonconstantNumerator i) (allOne i)) := by
  intro hEquality
  obtain ⟨c, hc⟩ :=
    (logSum_eq_iff_exists_constant_ratio
      Finset.univ nonconstantNumerator allOne).1 hEquality
  have hFalse := hc false (by simp) (by simp [nonconstantNumerator, allOne])
  have hTrue := hc true (by simp) (by simp [nonconstantNumerator, allOne])
  norm_num [nonconstantNumerator, allOne] at hFalse hTrue
  have : (1 : ENNReal) = 2 := hFalse.trans hTrue.symm
  norm_num at this

private example :
    (¬ ∀ i ∈ (Finset.univ : Finset Bool), supportGuardData i ≠ 0) ∧
      (((∑ i ∈ Finset.univ, supportGuardData i : NNReal) : Real) *
          Real.log
            (((∑ i ∈ Finset.univ, supportGuardData i : NNReal) : Real) /
              ((∑ i ∈ Finset.univ, supportGuardData i : NNReal) : Real)) <=
        ∑ i ∈ Finset.univ,
          (supportGuardData i : Real) *
            Real.log
              ((supportGuardData i : Real) / (supportGuardData i : Real))) := by
  constructor
  · intro hAll
    exact hAll false (by simp) (by simp [supportGuardData])
  · apply
      real_logSum_inequality_of_support
        Finset.univ supportGuardData supportGuardData
    intro i hi hai
    exact hai

private example :
    (((∑ i ∈ Finset.univ, supportGuardData i : NNReal) : Real) *
          Real.log
            (((∑ i ∈ Finset.univ, supportGuardData i : NNReal) : Real) /
              ((∑ i ∈ Finset.univ, supportGuardData i : NNReal) : Real)) =
        ∑ i ∈ Finset.univ,
          (supportGuardData i : Real) *
            Real.log
              ((supportGuardData i : Real) / (supportGuardData i : Real))) := by
  have hSupport :
      ∀ i ∈ (Finset.univ : Finset Bool),
        supportGuardData i ≠ 0 -> supportGuardData i ≠ 0 := by
    intro i hi hai
    exact hai
  apply
    (real_logSum_eq_iff_exists_constant_ratio_of_support
      Finset.univ supportGuardData supportGuardData hSupport).2
  refine ⟨1, ?_⟩
  intro i hi hactive
  cases i <;> simp [supportGuardData] at hactive ⊢

/-! ## Shared Boolean models -/

private def halfWeight : NNReal := 1 / 2

private theorem halfWeight_le_one : halfWeight <= 1 := by
  norm_num [halfWeight]

private theorem halfWeight_pos : 0 < halfWeight := by
  norm_num [halfWeight]

private theorem halfWeight_lt_one : halfWeight < 1 := by
  norm_num [halfWeight]

private theorem zeroWeight_le_one_a : (0 : NNReal) <= 1 := by
  norm_num

private theorem zeroWeight_le_one_b : (0 : NNReal) <= 1 :=
  bot_le

private theorem oneWeight_le_one_a : (1 : NNReal) <= 1 :=
  le_rfl

private theorem oneWeight_le_one_b : (1 : NNReal) <= 1 := by
  norm_num

private def pureFalse : PMF Bool :=
  PMF.pure false

private def pureTrue : PMF Bool :=
  PMF.pure true

private def uniformBool : PMF Bool :=
  PMF.uniformOfFintype Bool

private def boolSelector : PMF Bool :=
  PMF.ofFintype
    (fun b : Bool =>
      ((cond b halfWeight (1 - halfWeight) : NNReal) : ENNReal))
    (by simp [halfWeight_le_one])

private def boolInputFamily : Bool -> PMF Bool
  | false => pureFalse
  | true => pureTrue

private def identityChannel (b : Bool) : PMF Bool :=
  PMF.pure b

private def constantFalseChannel (_ : Bool) : PMF Bool :=
  pureFalse

private def boolChannelFamily (selector input : Bool) : PMF Bool :=
  if selector then identityChannel input else constantFalseChannel input

private theorem pureFalse_ne_pureTrue : pureFalse ≠ pureTrue := by
  intro h
  have hmass := congrArg (fun p : PMF Bool => p false) h
  simp [pureFalse, pureTrue] at hmass

/-! ## Finite mixtures and proof irrelevance -/

private example (p q : PMF Bool) (b : Bool) :
    PMF.binaryMixture halfWeight halfWeight_le_one p q b =
      (halfWeight : ENNReal) * p b +
        ((1 - halfWeight : NNReal) : ENNReal) * q b :=
  PMF.binaryMixture_apply halfWeight halfWeight_le_one p q b

private example (p q : PMF Bool) :
    PMF.binaryMixture 0 zeroWeight_le_one_a p q = q := by
  simpa only using PMF.binaryMixture_zero zeroWeight_le_one_b p q

private example (p q : PMF Bool) :
    PMF.binaryMixture 1 oneWeight_le_one_a p q = p := by
  simpa only using PMF.binaryMixture_one oneWeight_le_one_b p q

private example (W1 W2 : Bool -> PMF Bool) :
    (fun b => PMF.binaryMixture 1 oneWeight_le_one_a (W1 b) (W2 b)) = W1 := by
  funext b
  simpa only using
    PMF.binaryMixture_one oneWeight_le_one_b (W1 b) (W2 b)

/-! ## Entropy concavity -/

private example :
    (Finset.univ.sum fun i =>
        (boolSelector i).toReal * entropy (boolInputFamily i)) <=
      entropy (boolSelector.bind boolInputFamily) :=
  sum_mul_entropy_le_entropy_bind boolSelector boolInputFamily

private example (p q : PMF Bool) :
    (0 : Real) * entropy p +
          ((1 - (0 : NNReal) : NNReal) : Real) * entropy q <=
        entropy (PMF.binaryMixture 0 zeroWeight_le_one_a p q) :=
  binaryMixture_entropy_concave
    (0 : NNReal) zeroWeight_le_one_a p q

private example (p q : PMF Bool) :
    (1 : Real) * entropy p +
          ((1 - (1 : NNReal) : NNReal) : Real) * entropy q <=
        entropy (PMF.binaryMixture 1 oneWeight_le_one_a p q) :=
  binaryMixture_entropy_concave
    (1 : NNReal) oneWeight_le_one_a p q

private example (p : PMF Bool) :
    (halfWeight : Real) * entropy p +
          ((1 - halfWeight : NNReal) : Real) * entropy p =
        entropy
          (PMF.binaryMixture
            halfWeight halfWeight_le_one p p) :=
  (binaryMixture_entropy_eq_iff
    halfWeight halfWeight_le_one halfWeight_pos halfWeight_lt_one p p).2 rfl

private example :
    (halfWeight : Real) * entropy pureFalse +
          ((1 - halfWeight : NNReal) : Real) * entropy pureTrue <
        entropy
          (PMF.binaryMixture
            halfWeight halfWeight_le_one pureFalse pureTrue) := by
  have hle :=
    binaryMixture_entropy_concave
      halfWeight halfWeight_le_one pureFalse pureTrue
  have hne :
      (halfWeight : Real) * entropy pureFalse +
            ((1 - halfWeight : NNReal) : Real) * entropy pureTrue ≠
          entropy
            (PMF.binaryMixture
              halfWeight halfWeight_le_one pureFalse pureTrue) := by
    intro hEquality
    exact pureFalse_ne_pureTrue
      ((binaryMixture_entropy_eq_iff
        halfWeight halfWeight_le_one halfWeight_pos halfWeight_lt_one
        pureFalse pureTrue).1 hEquality)
  exact lt_of_le_of_ne hle hne

/-! ## Relative-entropy joint convexity -/

namespace RelativeEntropy

local instance : MeasurableSpace Bool := ⊤

local instance : MeasurableSingletonClass Bool where
  measurableSet_singleton _ := trivial

private def inactiveTopNumerator (_ : Bool) : PMF Bool :=
  pureFalse

private def inactiveTopReference : Bool -> PMF Bool
  | false => pureTrue
  | true => pureFalse

private theorem pureFalse_klDiv_pureTrue_eq_top :
    InformationTheory.klDiv pureFalse.toMeasure pureTrue.toMeasure = ⊤ := by
  apply
    (klDiv_pmf_eq_top_iff_not_support_subset pureFalse pureTrue).2
  simp [pureFalse, pureTrue]

private theorem pureFalse_support_uniformBool :
    pureFalse.support ⊆ uniformBool.support := by
  intro b _hb
  change b ∈ (PMF.uniformOfFintype Bool).support
  exact PMF.mem_support_uniformOfFintype b

private theorem pureTrue_support_uniformBool :
    pureTrue.support ⊆ uniformBool.support := by
  intro b _hb
  change b ∈ (PMF.uniformOfFintype Bool).support
  exact PMF.mem_support_uniformOfFintype b

private example :
    (PMF.pure true : PMF Bool) false *
        InformationTheory.klDiv
          pureFalse.toMeasure pureTrue.toMeasure =
      0 := by
  rw [pureFalse_klDiv_pureTrue_eq_top]
  simp

private example :
    InformationTheory.klDiv
        ((PMF.pure true : PMF Bool).bind inactiveTopNumerator).toMeasure
        ((PMF.pure true : PMF Bool).bind inactiveTopReference).toMeasure <=
      Finset.univ.sum
        (fun i =>
          (PMF.pure true : PMF Bool) i *
            InformationTheory.klDiv
              (inactiveTopNumerator i).toMeasure
              (inactiveTopReference i).toMeasure) :=
  klDiv_bind_le_sum
    (PMF.pure true : PMF Bool)
    inactiveTopNumerator inactiveTopReference

private example :
    (InformationTheory.klDiv
        ((PMF.pure true : PMF Bool).bind inactiveTopNumerator).toMeasure
        ((PMF.pure true : PMF Bool).bind inactiveTopReference).toMeasure).toReal <=
      Finset.univ.sum
        (fun i =>
          ((PMF.pure true : PMF Bool) i).toReal *
            (InformationTheory.klDiv
              (inactiveTopNumerator i).toMeasure
              (inactiveTopReference i).toMeasure).toReal) := by
  apply
    toReal_klDiv_bind_le_sum
      (PMF.pure true : PMF Bool)
      inactiveTopNumerator inactiveTopReference
  intro i hi
  cases i
  · simp at hi
  · simp [inactiveTopNumerator, inactiveTopReference]

private example :
    (PMF.pure true : PMF Bool) false *
          InformationTheory.klDiv
            pureFalse.toMeasure pureFalse.toMeasure =
        0 ∧
      InformationTheory.klDiv
          pureFalse.toMeasure pureFalse.toMeasure ≠ ⊤ := by
  constructor
  · simp
  · exact
      (klDiv_pmf_ne_top_iff_support_subset pureFalse pureFalse).2
        (fun _ hx => hx)

private example :
    InformationTheory.klDiv
        (PMF.binaryMixture
          0 zeroWeight_le_one_a pureFalse pureFalse).toMeasure
        (PMF.binaryMixture
          0 zeroWeight_le_one_a pureTrue pureFalse).toMeasure <=
      (0 : ENNReal) *
          InformationTheory.klDiv
            pureFalse.toMeasure pureTrue.toMeasure +
        ((1 - (0 : NNReal) : NNReal) : ENNReal) *
          InformationTheory.klDiv
            pureFalse.toMeasure pureFalse.toMeasure :=
  klDiv_binaryMixture_le
    (0 : NNReal) zeroWeight_le_one_a
    pureFalse pureFalse pureTrue pureFalse

private example :
    (InformationTheory.klDiv
        (PMF.binaryMixture
          0 zeroWeight_le_one_a pureFalse pureFalse).toMeasure
        (PMF.binaryMixture
          0 zeroWeight_le_one_a pureTrue pureFalse).toMeasure).toReal <=
      (0 : Real) *
          (InformationTheory.klDiv
            pureFalse.toMeasure pureTrue.toMeasure).toReal +
        ((1 - (0 : NNReal) : NNReal) : Real) *
          (InformationTheory.klDiv
            pureFalse.toMeasure pureFalse.toMeasure).toReal := by
  exact
    toReal_klDiv_binaryMixture_le
      (0 : NNReal) zeroWeight_le_one_a
      pureFalse pureFalse pureTrue pureFalse
      (fun hzero => (hzero rfl).elim)
      (fun _ _ hx => hx)

private example :
    InformationTheory.klDiv
        (PMF.binaryMixture
          0 zeroWeight_le_one_a pureFalse pureFalse).toMeasure
        (PMF.binaryMixture
          0 zeroWeight_le_one_a pureTrue pureFalse).toMeasure =
      (0 : ENNReal) *
          InformationTheory.klDiv
            pureFalse.toMeasure pureTrue.toMeasure +
        ((1 - (0 : NNReal) : NNReal) : ENNReal) *
          InformationTheory.klDiv
            pureFalse.toMeasure pureFalse.toMeasure := by
  rw [PMF.binaryMixture_zero zeroWeight_le_one_b pureFalse pureFalse,
    PMF.binaryMixture_zero zeroWeight_le_one_b pureTrue pureFalse]
  simp [pureFalse_klDiv_pureTrue_eq_top]

private example :
    (InformationTheory.klDiv
        (PMF.binaryMixture
          0 zeroWeight_le_one_a pureFalse pureFalse).toMeasure
        (PMF.binaryMixture
          0 zeroWeight_le_one_a pureTrue pureFalse).toMeasure).toReal =
      (0 : Real) *
          (InformationTheory.klDiv
            pureFalse.toMeasure pureTrue.toMeasure).toReal +
        ((1 - (0 : NNReal) : NNReal) : Real) *
          (InformationTheory.klDiv
            pureFalse.toMeasure pureFalse.toMeasure).toReal := by
  rw [PMF.binaryMixture_zero zeroWeight_le_one_b pureFalse pureFalse,
    PMF.binaryMixture_zero zeroWeight_le_one_b pureTrue pureFalse]
  simp

private example :
    InformationTheory.klDiv
        (PMF.binaryMixture
          1 oneWeight_le_one_a pureFalse pureFalse).toMeasure
        (PMF.binaryMixture
          1 oneWeight_le_one_a pureFalse pureTrue).toMeasure <=
      (1 : ENNReal) *
          InformationTheory.klDiv
            pureFalse.toMeasure pureFalse.toMeasure +
        ((1 - (1 : NNReal) : NNReal) : ENNReal) *
          InformationTheory.klDiv
            pureFalse.toMeasure pureTrue.toMeasure :=
  klDiv_binaryMixture_le
    (1 : NNReal) oneWeight_le_one_a
    pureFalse pureFalse pureFalse pureTrue

private example :
    (InformationTheory.klDiv
        (PMF.binaryMixture
          1 oneWeight_le_one_a pureFalse pureFalse).toMeasure
        (PMF.binaryMixture
          1 oneWeight_le_one_a pureFalse pureTrue).toMeasure).toReal <=
      (1 : Real) *
          (InformationTheory.klDiv
            pureFalse.toMeasure pureFalse.toMeasure).toReal +
        ((1 - (1 : NNReal) : NNReal) : Real) *
          (InformationTheory.klDiv
            pureFalse.toMeasure pureTrue.toMeasure).toReal := by
  exact
    toReal_klDiv_binaryMixture_le
      (1 : NNReal) oneWeight_le_one_a
      pureFalse pureFalse pureFalse pureTrue
      (fun _ _ hx => hx)
      (fun hone => (hone rfl).elim)

private example :
    InformationTheory.klDiv
        (PMF.binaryMixture
          1 oneWeight_le_one_a pureFalse pureFalse).toMeasure
        (PMF.binaryMixture
          1 oneWeight_le_one_a pureFalse pureTrue).toMeasure =
      (1 : ENNReal) *
          InformationTheory.klDiv
            pureFalse.toMeasure pureFalse.toMeasure +
        ((1 - (1 : NNReal) : NNReal) : ENNReal) *
          InformationTheory.klDiv
            pureFalse.toMeasure pureTrue.toMeasure := by
  rw [PMF.binaryMixture_one oneWeight_le_one_b pureFalse pureFalse,
    PMF.binaryMixture_one oneWeight_le_one_b pureFalse pureTrue]
  simp

private example :
    (InformationTheory.klDiv
        (PMF.binaryMixture
          1 oneWeight_le_one_a pureFalse pureFalse).toMeasure
        (PMF.binaryMixture
          1 oneWeight_le_one_a pureFalse pureTrue).toMeasure).toReal =
      (1 : Real) *
          (InformationTheory.klDiv
            pureFalse.toMeasure pureFalse.toMeasure).toReal +
        ((1 - (1 : NNReal) : NNReal) : Real) *
          (InformationTheory.klDiv
            pureFalse.toMeasure pureTrue.toMeasure).toReal := by
  rw [PMF.binaryMixture_one oneWeight_le_one_b pureFalse pureFalse,
    PMF.binaryMixture_one oneWeight_le_one_b pureFalse pureTrue]
  simp

private example :
    InformationTheory.klDiv
          (PMF.binaryMixture
            halfWeight halfWeight_le_one pureFalse pureTrue).toMeasure
          (PMF.binaryMixture
            halfWeight halfWeight_le_one pureFalse pureTrue).toMeasure =
        (halfWeight : ENNReal) *
            InformationTheory.klDiv
              pureFalse.toMeasure pureFalse.toMeasure +
          ((1 - halfWeight : NNReal) : ENNReal) *
            InformationTheory.klDiv
              pureTrue.toMeasure pureTrue.toMeasure := by
  apply
    (klDiv_binaryMixture_eq_iff
      halfWeight halfWeight_le_one halfWeight_pos halfWeight_lt_one
      pureFalse pureTrue pureFalse pureTrue
      (fun _ hx => hx) (fun _ hx => hx)).2
  intro b
  cases b <;> simp [pureFalse, pureTrue]

private example :
    (InformationTheory.klDiv
          (PMF.binaryMixture
            halfWeight halfWeight_le_one pureFalse pureTrue).toMeasure
          (PMF.binaryMixture
            halfWeight halfWeight_le_one pureFalse pureTrue).toMeasure).toReal =
        (halfWeight : Real) *
            (InformationTheory.klDiv
              pureFalse.toMeasure pureFalse.toMeasure).toReal +
          ((1 - halfWeight : NNReal) : Real) *
            (InformationTheory.klDiv
              pureTrue.toMeasure pureTrue.toMeasure).toReal := by
  apply
    (toReal_klDiv_binaryMixture_eq_iff
      halfWeight halfWeight_le_one halfWeight_pos halfWeight_lt_one
      pureFalse pureTrue pureFalse pureTrue
      (fun _ hx => hx) (fun _ hx => hx)).2
  intro b
  cases b <;> simp [pureFalse, pureTrue]

private example :
    ¬ (InformationTheory.klDiv
          (PMF.binaryMixture
            halfWeight halfWeight_le_one pureFalse pureTrue).toMeasure
          (PMF.binaryMixture
            halfWeight halfWeight_le_one uniformBool uniformBool).toMeasure =
        (halfWeight : ENNReal) *
            InformationTheory.klDiv
              pureFalse.toMeasure uniformBool.toMeasure +
          ((1 - halfWeight : NNReal) : ENNReal) *
            InformationTheory.klDiv
              pureTrue.toMeasure uniformBool.toMeasure) := by
  intro hEquality
  have hcross :=
    (klDiv_binaryMixture_eq_iff
      halfWeight halfWeight_le_one halfWeight_pos halfWeight_lt_one
      pureFalse pureTrue uniformBool uniformBool
      pureFalse_support_uniformBool pureTrue_support_uniformBool).1 hEquality
  have hfalse := hcross false
  norm_num [pureFalse, pureTrue, uniformBool,
    PMF.uniformOfFintype_apply] at hfalse

private example :
    ¬ ((InformationTheory.klDiv
          (PMF.binaryMixture
            halfWeight halfWeight_le_one pureFalse pureTrue).toMeasure
          (PMF.binaryMixture
            halfWeight halfWeight_le_one uniformBool uniformBool).toMeasure).toReal =
        (halfWeight : Real) *
            (InformationTheory.klDiv
              pureFalse.toMeasure uniformBool.toMeasure).toReal +
          ((1 - halfWeight : NNReal) : Real) *
            (InformationTheory.klDiv
              pureTrue.toMeasure uniformBool.toMeasure).toReal) := by
  intro hEquality
  have hcross :=
    (toReal_klDiv_binaryMixture_eq_iff
      halfWeight halfWeight_le_one halfWeight_pos halfWeight_lt_one
      pureFalse pureTrue uniformBool uniformBool
      pureFalse_support_uniformBool pureTrue_support_uniformBool).1 hEquality
  have hfalse := hcross false
  norm_num [pureFalse, pureTrue, uniformBool,
    PMF.uniformOfFintype_apply] at hfalse

end RelativeEntropy

/-! ## Mutual-information concavity and convexity -/

private example :
    mutualInfo (PMF.channelJoint uniformBool identityChannel) =
      entropy (uniformBool.bind identityChannel) -
        Finset.univ.sum
          (fun x => (uniformBool x).toReal * entropy (identityChannel x)) :=
  mutualInfo_channelJoint_eq_entropy_bind_sub_sum
    uniformBool identityChannel

private example :
    (Finset.univ.sum fun i =>
        (boolSelector i).toReal *
          mutualInfo
            (PMF.channelJoint (boolInputFamily i) identityChannel)) <=
      mutualInfo
        (PMF.channelJoint
          (boolSelector.bind boolInputFamily) identityChannel) :=
  sum_mul_mutualInfo_channelJoint_le
    boolSelector boolInputFamily identityChannel

private example :
    (halfWeight : Real) *
          mutualInfo (PMF.channelJoint pureFalse identityChannel) +
        ((1 - halfWeight : NNReal) : Real) *
          mutualInfo (PMF.channelJoint pureTrue identityChannel) <=
      mutualInfo
        (PMF.channelJoint
          (PMF.binaryMixture
            halfWeight halfWeight_le_one pureFalse pureTrue)
          identityChannel) :=
  mutualInfo_binaryMixture_input_concave
    halfWeight halfWeight_le_one pureFalse pureTrue identityChannel

private example :
    mutualInfo
        (PMF.channelJoint uniformBool
          (fun x => boolSelector.bind fun i => boolChannelFamily i x)) <=
      Finset.univ.sum
        (fun i =>
          (boolSelector i).toReal *
            mutualInfo
              (PMF.channelJoint uniformBool (boolChannelFamily i))) :=
  mutualInfo_channelMixture_le_sum
    boolSelector uniformBool boolChannelFamily

private example :
    mutualInfo
        (PMF.channelJoint uniformBool
          (fun x =>
            PMF.binaryMixture
              halfWeight halfWeight_le_one
              (identityChannel x) (constantFalseChannel x))) <=
      (halfWeight : Real) *
          mutualInfo (PMF.channelJoint uniformBool identityChannel) +
        ((1 - halfWeight : NNReal) : Real) *
          mutualInfo (PMF.channelJoint uniformBool constantFalseChannel) :=
  mutualInfo_binaryChannelMixture_le
    halfWeight halfWeight_le_one uniformBool
    identityChannel constantFalseChannel

end

end Convexity
end Examples
end LeanInfoTheory
