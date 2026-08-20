/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL

/-!
# Conditional relative-entropy examples

This module provides maintained, non-public regression coverage for finite
conditional relative entropy. The examples emphasize null fibers, infinite
fiber divergences, support-guarded real-valued formulas, and the joint KL
chain rule.
-/

namespace LeanInfoTheory
namespace Examples
namespace ConditionalKL

open scoped BigOperators ENNReal
open Shannon

noncomputable section

local instance : MeasurableSpace Bool := ⊤

local instance : MeasurableSingletonClass Bool where
  measurableSet_singleton _ := trivial

private def pureFalse : PMF Bool :=
  PMF.pure false

private def pureTrue : PMF Bool :=
  PMF.pure true

private def uniformBool : PMF Bool :=
  PMF.uniformOfFintype Bool

/-- The numerator base has one active atom and one null atom. -/
private def activeBase : PMF Bool :=
  pureFalse

/-- A distinct full-support base law for the joint chain-rule examples. -/
private def referenceBase : PMF Bool :=
  uniformBool

/-- Both numerator fibers are the same point mass. -/
private def numeratorChannel (_ : Bool) : PMF Bool :=
  pureFalse

/--
The active fiber is finite and nonzero; the null fiber has mutually singular
component laws and hence infinite KL divergence.
-/
private def referenceChannel : Bool → PMF Bool
  | false => uniformBool
  | true => pureTrue

/-- The active fiber is also support-singular in this boundary channel. -/
private def activeTopReference : Bool → PMF Bool
  | false => pureTrue
  | true => pureFalse

private theorem pureFalse_support_uniformBool :
    pureFalse.support ⊆ uniformBool.support := by
  intro b _hb
  change b ∈ (PMF.uniformOfFintype Bool).support
  exact PMF.mem_support_uniformOfFintype b

private theorem pureFalse_ne_uniformBool :
    pureFalse ≠ uniformBool := by
  intro h
  have hmem : true ∈ uniformBool.support := by
    change true ∈ (PMF.uniformOfFintype Bool).support
    exact PMF.mem_support_uniformOfFintype true
  have hne : uniformBool true ≠ 0 :=
    (uniformBool.mem_support_iff true).1 hmem
  apply hne
  rw [← h]
  simp [pureFalse]

private theorem active_component_ne_top :
    InformationTheory.klDiv
        pureFalse.toMeasure uniformBool.toMeasure ≠ ⊤ :=
  (klDiv_pmf_ne_top_iff_support_subset pureFalse uniformBool).2
    pureFalse_support_uniformBool

private theorem active_component_ne_zero :
    InformationTheory.klDiv
        pureFalse.toMeasure uniformBool.toMeasure ≠ 0 := by
  intro hzero
  exact pureFalse_ne_uniformBool
    ((klDiv_pmf_eq_zero_iff pureFalse uniformBool).1 hzero)

private theorem singular_component_eq_top :
    InformationTheory.klDiv
        pureFalse.toMeasure pureTrue.toMeasure = ⊤ := by
  apply (klDiv_pmf_eq_top_iff_not_support_subset pureFalse pureTrue).2
  simp [pureFalse, pureTrue]

private theorem active_fiber_support :
    ∀ x ∈ activeBase.support,
      (numeratorChannel x).support ⊆ (referenceChannel x).support := by
  intro x hx
  have hxFalse : x = false := by
    simpa [activeBase, pureFalse] using hx
  subst x
  simpa [numeratorChannel, referenceChannel] using
    pureFalse_support_uniformBool

private theorem base_support :
    activeBase.support ⊆ referenceBase.support := by
  simpa [activeBase, referenceBase] using pureFalse_support_uniformBool

/-! ## Null and active fiber boundaries -/

private example : activeBase true = 0 := by
  simp [activeBase, pureFalse]

private example :
    InformationTheory.klDiv
        (numeratorChannel false).toMeasure
        (referenceChannel false).toMeasure ≠ ⊤ := by
  simpa [numeratorChannel, referenceChannel] using active_component_ne_top

private example :
    InformationTheory.klDiv
        (numeratorChannel true).toMeasure
        (referenceChannel true).toMeasure = ⊤ := by
  simpa [numeratorChannel, referenceChannel] using singular_component_eq_top

private example :
    activeBase true *
        InformationTheory.klDiv
          (numeratorChannel true).toMeasure
          (referenceChannel true).toMeasure =
      0 := by
  rw [show InformationTheory.klDiv
      (numeratorChannel true).toMeasure
      (referenceChannel true).toMeasure = ⊤ by
        simpa [numeratorChannel, referenceChannel] using
          singular_component_eq_top]
  simp [activeBase, pureFalse]

private theorem conditionalKlDiv_eq_active_component :
    conditionalKlDiv activeBase numeratorChannel referenceChannel =
      InformationTheory.klDiv
        pureFalse.toMeasure uniformBool.toMeasure := by
  rw [conditionalKlDiv_eq_sum]
  simp [activeBase, pureFalse, numeratorChannel, referenceChannel]

private example :
    conditionalKlDiv activeBase numeratorChannel referenceChannel ≠ ⊤ ∧
      conditionalKlDiv activeBase numeratorChannel referenceChannel ≠ 0 := by
  rw [conditionalKlDiv_eq_active_component]
  exact ⟨active_component_ne_top, active_component_ne_zero⟩

private example :
    conditionalKlDiv activeBase numeratorChannel numeratorChannel = 0 :=
  conditionalKlDiv_self activeBase numeratorChannel

private theorem active_conditionalKlDiv_eq_top :
    conditionalKlDiv activeBase numeratorChannel activeTopReference = ⊤ := by
  rw [conditionalKlDiv_eq_sum, Fintype.sum_bool]
  rw [show InformationTheory.klDiv
      (numeratorChannel false).toMeasure
      (activeTopReference false).toMeasure = ⊤ by
        simpa [numeratorChannel, activeTopReference] using
          singular_component_eq_top]
  simp [activeBase, pureFalse, numeratorChannel, activeTopReference]

/-! ## Weighted formulas and joint KL chain rules -/

private example : activeBase ≠ referenceBase :=
  pureFalse_ne_uniformBool

private example :
    conditionalKlDiv activeBase numeratorChannel referenceChannel =
      ∑ x, activeBase x *
        InformationTheory.klDiv
          (numeratorChannel x).toMeasure
          (referenceChannel x).toMeasure :=
  conditionalKlDiv_eq_sum activeBase numeratorChannel referenceChannel

private example :
    (conditionalKlDiv activeBase numeratorChannel referenceChannel).toReal =
      ∑ x, (activeBase x).toReal *
        (InformationTheory.klDiv
          (numeratorChannel x).toMeasure
          (referenceChannel x).toMeasure).toReal :=
  toReal_conditionalKlDiv_eq_sum
    activeBase numeratorChannel referenceChannel active_fiber_support

private example :
    InformationTheory.klDiv
        (PMF.channelJoint activeBase numeratorChannel).toMeasure
        (PMF.channelJoint referenceBase referenceChannel).toMeasure =
      InformationTheory.klDiv
          activeBase.toMeasure referenceBase.toMeasure +
        conditionalKlDiv activeBase numeratorChannel referenceChannel :=
  klDiv_channelJoint_eq_add_conditionalKlDiv
    activeBase referenceBase numeratorChannel referenceChannel

private example :
    InformationTheory.klDiv
        (PMF.channelJoint activeBase numeratorChannel).toMeasure
        (PMF.channelJoint pureTrue numeratorChannel).toMeasure = ⊤ := by
  rw [klDiv_channelJoint_eq_add_conditionalKlDiv,
    conditionalKlDiv_self]
  have hbaseTop :
      InformationTheory.klDiv
          activeBase.toMeasure pureTrue.toMeasure = ⊤ := by
    simpa [activeBase] using singular_component_eq_top
  rw [hbaseTop]
  simp

private example :
    InformationTheory.klDiv
        (PMF.channelJoint activeBase numeratorChannel).toMeasure
        (PMF.channelJoint activeBase activeTopReference).toMeasure = ⊤ := by
  rw [klDiv_channelJoint_eq_add_conditionalKlDiv,
    InformationTheory.klDiv_self,
    active_conditionalKlDiv_eq_top]
  simp

private example :
    (InformationTheory.klDiv
        (PMF.channelJoint activeBase numeratorChannel).toMeasure
        (PMF.channelJoint referenceBase referenceChannel).toMeasure).toReal =
      (InformationTheory.klDiv
          activeBase.toMeasure referenceBase.toMeasure).toReal +
        ∑ x, (activeBase x).toReal *
          (InformationTheory.klDiv
            (numeratorChannel x).toMeasure
            (referenceChannel x).toMeasure).toReal := by
  rw [toReal_klDiv_channelJoint_eq_add_conditionalKlDiv
      activeBase referenceBase numeratorChannel referenceChannel
      base_support active_fiber_support,
    toReal_conditionalKlDiv_eq_sum
      activeBase numeratorChannel referenceChannel active_fiber_support]

end

end ConditionalKL
end Examples
end LeanInfoTheory
