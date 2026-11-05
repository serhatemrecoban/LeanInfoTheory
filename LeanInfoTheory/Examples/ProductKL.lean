/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.ProductKL

/-!
# Finite-product KL consumers

Private consumers exercise finite supported heterogeneous products whose
reference law is sparse, as well as empty/singleton indices, singleton alphabets
and iid blocks. The support guards are checked on the actual coordinate and
product laws.

The paired-support regression uses `(fair, pure false)` against
`(pure false, fair)`. Their supports overlap but neither contains the other.
One coordinate KL is infinite and the other is finite with real value `log 2`:
the product KL is infinite, so converting its value to `Real` does not commute
with the coordinate sum. Singular iid length zero separately exercises
`0 * ⊤ = 0` without invoking a guarded Real theorem.
-/

namespace LeanInfoTheory.Examples.ProductKL

noncomputable section

open scoped BigOperators ENNReal
open LeanInfoTheory.Shannon

local instance : MeasurableSpace Bool := ⊤
local instance : MeasurableSingletonClass Bool where
  measurableSet_singleton _ := trivial

local instance : MeasurableSpace (Fin 3) := ⊤
local instance : MeasurableSingletonClass (Fin 3) where
  measurableSet_singleton _ := trivial

local instance : MeasurableSpace PUnit := ⊤
local instance : MeasurableSingletonClass PUnit where
  measurableSet_singleton _ := trivial

local instance : MeasurableSpace Empty := ⊤
local instance : MeasurableSingletonClass Empty where
  measurableSet_singleton _ := trivial

/-! ## Shared finite and infinite coordinate divergences -/

private def fair : PMF Bool := PMF.uniformOfFintype Bool
private def pureFalse : PMF Bool := PMF.pure false

private theorem pure_support_fair : pureFalse.support ⊆ fair.support := by
  intro b _
  exact PMF.mem_support_uniformOfFintype b

private theorem pure_fair_finite :
    InformationTheory.klDiv pureFalse.toMeasure fair.toMeasure ≠ ⊤ :=
  (klDiv_pmf_ne_top_iff_support_subset pureFalse fair).2 pure_support_fair

private theorem pure_fair_real :
    (InformationTheory.klDiv pureFalse.toMeasure fair.toMeasure).toReal =
      Real.log 2 := by
  simpa [pureFalse, fair, entropy_pure] using
    toReal_klDiv_pmf_uniformOfFintype (PMF.pure false)

private theorem pure_fair_ennreal :
    InformationTheory.klDiv pureFalse.toMeasure fair.toMeasure =
      ENNReal.ofReal (Real.log 2) := by
  rw [← ENNReal.ofReal_toReal pure_fair_finite, pure_fair_real]

private theorem pure_fair_real_pos :
    0 < (InformationTheory.klDiv pureFalse.toMeasure fair.toMeasure).toReal := by
  rw [pure_fair_real]
  exact Real.log_pos (by norm_num : (1 : ℝ) < 2)

private theorem fair_pure_top :
    InformationTheory.klDiv fair.toMeasure pureFalse.toMeasure = ⊤ := by
  apply (klDiv_pmf_eq_top_iff_not_support_subset fair pureFalse).2
  intro h
  have ht : true ∈ pureFalse.support :=
    h (PMF.mem_support_uniformOfFintype true)
  simp [pureFalse] at ht

/-! ## K1: heterogeneous, supported products with zero masses -/

private def sparse : PMF (Fin 3) :=
  PMF.uniformOfFinset ({0, 1} : Finset (Fin 3)) (by simp)

private abbrev Alphabet : Bool → Type
  | false => Bool
  | true => Fin 3

private instance alphabetFintype (i : Bool) : Fintype (Alphabet i) := by
  cases i <;> dsimp [Alphabet] <;> infer_instance

private instance alphabetMeasurableSpace (i : Bool) : MeasurableSpace (Alphabet i) := by
  cases i <;> dsimp [Alphabet] <;> infer_instance

private instance alphabetMeasurableSingletonClass (i : Bool) :
    MeasurableSingletonClass (Alphabet i) := by
  cases i <;> dsimp [Alphabet, alphabetMeasurableSpace] <;> infer_instance

private def numerator : (i : Bool) → PMF (Alphabet i)
  | false => pureFalse
  | true => sparse

private def reference : (i : Bool) → PMF (Alphabet i)
  | false => fair
  | true => sparse

private def word (b : Bool) (a : Fin 3) : (i : Bool) → Alphabet i
  | false => b
  | true => a

private def numeratorLaw : PMF ((i : Bool) → Alphabet i) := PMF.finiteProduct numerator
private def referenceLaw : PMF ((i : Bool) → Alphabet i) := PMF.finiteProduct reference

private theorem coordinate_support (i : Bool) :
    (numerator i).support ⊆ (reference i).support := by
  cases i with
  | false => exact pure_support_fair
  | true => exact fun _ hx => hx

private theorem numerator_support (x : (i : Bool) → Alphabet i) :
    x ∈ numeratorLaw.support ↔
      x false = false ∧ x true ∈ ({0, 1} : Finset (Fin 3)) := by
  change x ∈ (PMF.finiteProduct numerator).support ↔ _
  rw [PMF.mem_support_finiteProduct_iff]
  constructor
  · intro h
    exact ⟨by simpa [numerator, pureFalse] using h false,
      by simpa [numerator, sparse] using h true⟩
  · rintro ⟨hb, ha⟩ i
    cases i with
    | false => simpa [numerator, pureFalse] using hb
    | true => simpa [numerator, sparse] using ha

private theorem reference_support (x : (i : Bool) → Alphabet i) :
    x ∈ referenceLaw.support ↔ x true ∈ ({0, 1} : Finset (Fin 3)) := by
  change x ∈ (PMF.finiteProduct reference).support ↔ _
  rw [PMF.mem_support_finiteProduct_iff]
  constructor
  · intro h
    simpa [reference, sparse] using h true
  · intro ha i
    cases i with
    | false => exact PMF.mem_support_uniformOfFintype (x false)
    | true => simpa [reference, sparse] using ha

private theorem heterogeneous_product_support :
    numeratorLaw.support ⊆ referenceLaw.support := by
  intro x hx
  apply (PMF.mem_support_finiteProduct_iff reference x).2
  intro i
  exact coordinate_support i
    ((PMF.mem_support_finiteProduct_iff numerator x).1 hx i)

private theorem heterogeneous_supported_word :
    word false 0 ∈ numeratorLaw.support ∩ referenceLaw.support := by
  constructor
  · rw [numerator_support]
    decide
  · rw [reference_support]
    decide

private theorem heterogeneous_reference_has_extra_word :
    word true 1 ∈ referenceLaw.support ∧ word true 1 ∉ numeratorLaw.support := by
  rw [reference_support, numerator_support]
  decide

private theorem heterogeneous_missing_word :
    word false 2 ∉ numeratorLaw.support ∧ word false 2 ∉ referenceLaw.support := by
  rw [numerator_support, reference_support]
  decide

private theorem heterogeneous_kl_finite :
    InformationTheory.klDiv numeratorLaw.toMeasure referenceLaw.toMeasure ≠ ⊤ :=
  (klDiv_pmf_ne_top_iff_support_subset numeratorLaw referenceLaw).2
    heterogeneous_product_support

private theorem heterogeneous_kl :
    InformationTheory.klDiv numeratorLaw.toMeasure referenceLaw.toMeasure =
      ENNReal.ofReal (Real.log 2) := by
  simpa [numeratorLaw, referenceLaw, Fintype.sum_bool, numerator, reference,
    InformationTheory.klDiv_self, pure_fair_ennreal] using
    klDiv_finiteProduct numerator reference

private theorem heterogeneous_real_kl :
    (InformationTheory.klDiv numeratorLaw.toMeasure referenceLaw.toMeasure).toReal =
      Real.log 2 := by
  simpa [numeratorLaw, referenceLaw, Fintype.sum_bool, numerator, reference,
    InformationTheory.klDiv_self, pure_fair_real] using
    toReal_klDiv_finiteProduct numerator reference coordinate_support

/-! ## K2: overlapping supports with failed inclusion in both directions -/

private def leftComponents : Bool → PMF Bool
  | false => fair
  | true => pureFalse

private def rightComponents : Bool → PMF Bool
  | false => pureFalse
  | true => fair

private def leftLaw : PMF (Bool → Bool) := PMF.finiteProduct leftComponents
private def rightLaw : PMF (Bool → Bool) := PMF.finiteProduct rightComponents

private theorem left_support (x : Bool → Bool) :
    x ∈ leftLaw.support ↔ x true = false := by
  change x ∈ (PMF.finiteProduct leftComponents).support ↔ _
  rw [PMF.mem_support_finiteProduct_iff]
  constructor
  · intro h
    simpa [leftComponents, pureFalse] using h true
  · intro hx i
    cases i with
    | false => exact PMF.mem_support_uniformOfFintype (x false)
    | true => simpa [leftComponents, pureFalse] using hx

private theorem right_support (x : Bool → Bool) :
    x ∈ rightLaw.support ↔ x false = false := by
  change x ∈ (PMF.finiteProduct rightComponents).support ↔ _
  rw [PMF.mem_support_finiteProduct_iff]
  constructor
  · intro h
    simpa [rightComponents, pureFalse] using h false
  · intro hx i
    cases i with
    | false => simpa [rightComponents, pureFalse] using hx
    | true => exact PMF.mem_support_uniformOfFintype (x true)

private theorem supports_overlap : (leftLaw.support ∩ rightLaw.support).Nonempty := by
  refine ⟨fun _ => false, ?_, ?_⟩
  · exact (left_support _).2 rfl
  · exact (right_support _).2 rfl

private theorem left_only_word :
    (fun b : Bool => !b) ∈ leftLaw.support ∧
      (fun b : Bool => !b) ∉ rightLaw.support := by
  rw [left_support, right_support]
  decide

private theorem right_only_word :
    (id : Bool → Bool) ∈ rightLaw.support ∧ (id : Bool → Bool) ∉ leftLaw.support := by
  rw [right_support, left_support]
  decide

private theorem neither_support_contains :
    (¬ leftLaw.support ⊆ rightLaw.support) ∧
      (¬ rightLaw.support ⊆ leftLaw.support) := by
  constructor
  · exact fun h => left_only_word.2 (h left_only_word.1)
  · exact fun h => right_only_word.2 (h right_only_word.1)

private theorem paired_coordinate_kl :
    InformationTheory.klDiv (leftComponents false).toMeasure
        (rightComponents false).toMeasure = ⊤ ∧
      InformationTheory.klDiv (leftComponents true).toMeasure
        (rightComponents true).toMeasure = ENNReal.ofReal (Real.log 2) :=
  ⟨fair_pure_top, pure_fair_ennreal⟩

private theorem paired_product_top :
    InformationTheory.klDiv leftLaw.toMeasure rightLaw.toMeasure = ⊤ := by
  simpa [leftLaw, rightLaw, Fintype.sum_bool, leftComponents, rightComponents,
    fair_pure_top] using klDiv_finiteProduct leftComponents rightComponents

private theorem paired_reverse_top :
    InformationTheory.klDiv rightLaw.toMeasure leftLaw.toMeasure = ⊤ :=
  (klDiv_pmf_eq_top_iff_not_support_subset rightLaw leftLaw).2
    neither_support_contains.2

private theorem coordinate_real_sum :
    (∑ i : Bool, (InformationTheory.klDiv
      (leftComponents i).toMeasure (rightComponents i).toMeasure).toReal) =
      Real.log 2 := by
  rw [Fintype.sum_bool]
  simp [leftComponents, rightComponents, fair_pure_top, pure_fair_real]

private theorem unguarded_real_sum_fails :
    (InformationTheory.klDiv leftLaw.toMeasure rightLaw.toMeasure).toReal ≠
      ∑ i : Bool, (InformationTheory.klDiv
        (leftComponents i).toMeasure (rightComponents i).toMeasure).toReal := by
  rw [paired_product_top, ENNReal.toReal_top, coordinate_real_sum]
  exact ne_of_lt (Real.log_pos (by norm_num : (1 : ℝ) < 2))

/-! ## Singleton and empty products, and supported versus singular iid blocks -/

private theorem singleton_index_kl :
    InformationTheory.klDiv
        (PMF.finiteProduct (fun _ : Unit => pureFalse)).toMeasure
        (PMF.finiteProduct (fun _ : Unit => fair)).toMeasure =
      ENNReal.ofReal (Real.log 2) := by
  simpa [pure_fair_ennreal] using
    klDiv_finiteProduct (fun _ : Unit => pureFalse) (fun _ : Unit => fair)

private theorem singleton_index_real_kl :
    (InformationTheory.klDiv
        (PMF.finiteProduct (fun _ : Unit => pureFalse)).toMeasure
        (PMF.finiteProduct (fun _ : Unit => fair)).toMeasure).toReal = Real.log 2 := by
  simpa [pure_fair_real] using
    toReal_klDiv_finiteProduct (fun _ : Unit => pureFalse) (fun _ : Unit => fair)
      (fun _ => pure_support_fair)

private theorem singleton_alphabet_kl :
    InformationTheory.klDiv
        (PMF.finiteProduct (fun _ : Bool => PMF.pure PUnit.unit)).toMeasure
        (PMF.finiteProduct (fun _ : Bool => PMF.pure PUnit.unit)).toMeasure = 0 := by
  rw [klDiv_finiteProduct
    (fun _ : Bool => PMF.pure PUnit.unit) (fun _ : Bool => PMF.pure PUnit.unit)]
  simp

private def emptyComponents (i : Fin 0) : PMF Empty := isEmptyElim i

private theorem empty_product_kl :
    InformationTheory.klDiv (PMF.finiteProduct emptyComponents).toMeasure
        (PMF.finiteProduct emptyComponents).toMeasure = 0 := by
  rw [klDiv_finiteProduct emptyComponents emptyComponents]
  simp

private theorem empty_product_real_kl :
    (InformationTheory.klDiv (PMF.finiteProduct emptyComponents).toMeasure
        (PMF.finiteProduct emptyComponents).toMeasure).toReal = 0 := by
  rw [toReal_klDiv_finiteProduct emptyComponents emptyComponents
    (fun i => isEmptyElim i)]
  simp

private theorem supported_iid_kl (n : ℕ) :
    InformationTheory.klDiv (PMF.iid pureFalse n).toMeasure
        (PMF.iid fair n).toMeasure = (n : ENNReal) * ENNReal.ofReal (Real.log 2) := by
  simpa [pure_fair_ennreal] using klDiv_iid pureFalse fair n

private theorem supported_iid_real_kl (n : ℕ) :
    (InformationTheory.klDiv (PMF.iid pureFalse n).toMeasure
        (PMF.iid fair n).toMeasure).toReal = (n : ℝ) * Real.log 2 := by
  simpa [pure_fair_real] using toReal_klDiv_iid pureFalse fair pure_support_fair n

private theorem supported_iid_zero_one :
    InformationTheory.klDiv (PMF.iid pureFalse 0).toMeasure
        (PMF.iid fair 0).toMeasure = 0 ∧
      InformationTheory.klDiv (PMF.iid pureFalse 1).toMeasure
        (PMF.iid fair 1).toMeasure = ENNReal.ofReal (Real.log 2) := by
  constructor
  · simpa using supported_iid_kl 0
  · simpa using supported_iid_kl 1

private theorem supported_iid_real_zero_one :
    (InformationTheory.klDiv (PMF.iid pureFalse 0).toMeasure
        (PMF.iid fair 0).toMeasure).toReal = 0 ∧
      (InformationTheory.klDiv (PMF.iid pureFalse 1).toMeasure
        (PMF.iid fair 1).toMeasure).toReal = Real.log 2 := by
  constructor
  · simpa using supported_iid_real_kl 0
  · simpa using supported_iid_real_kl 1

private theorem singular_iid_zero_one :
    InformationTheory.klDiv (PMF.iid fair 0).toMeasure
        (PMF.iid pureFalse 0).toMeasure = 0 ∧
      InformationTheory.klDiv (PMF.iid fair 1).toMeasure
        (PMF.iid pureFalse 1).toMeasure = ⊤ := by
  constructor
  · simpa [fair_pure_top] using klDiv_iid fair pureFalse 0
  · simpa [fair_pure_top] using klDiv_iid fair pureFalse 1

end

end LeanInfoTheory.Examples.ProductKL
