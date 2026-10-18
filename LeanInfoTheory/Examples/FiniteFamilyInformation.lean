/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence

/-!
# Independent source families and a common observation

These private consumers retain an arbitrary source type and independent
universes for the index, source alphabets, source space and observation.
Independent fair bits observed through XOR have zero individual mutual
information but positive joint mutual information. Conditioning on that
observation makes the bits dependent, and conditional tuple subadditivity is
strict.

A heterogeneous Boolean/ternary family lives on an infinite ambient source
type and uses an observation in a higher universe. Empty and singleton families
exercise the actual conditional-entropy and mutual-information endpoints.
-/

namespace LeanInfoTheory.Examples.FiniteFamilyInformation

noncomputable section

universe u v w z

open scoped BigOperators ENNReal
open LeanInfoTheory.Shannon

/-! ## Direct random-variable contracts with four separate universes -/

open Classical in
private theorem arbitrary_source_conditional_bound
    {I : Type u} {A : I → Type v} {Ω : Type w} {C : Type z}
    [Fintype I] [∀ i, Fintype (A i)] [Fintype C]
    (p : PMF Ω) (X : ∀ i, Ω → A i) (Y : Ω → C) :
    condEntropyOf p (fun ω i => X i ω) Y ≤ ∑ i, condEntropyOf p (X i) Y :=
  condEntropyOf_pi_le_sum p X Y

open Classical in
private theorem arbitrary_source_information_bound
    {I : Type u} {A : I → Type v} {Ω : Type w} {C : Type z}
    [Fintype I] [∀ i, Fintype (A i)] [Fintype C]
    (p : PMF Ω) (X : ∀ i, Ω → A i) (Y : Ω → C)
    (hX : IsMutuallyIndependentFamilyOf p X Finset.univ) :
    (∑ i, mutualInfoOf p (X i) Y) ≤ mutualInfoOf p (fun ω i => X i ω) Y :=
  sum_mutualInfoOf_le_mutualInfoOf_pi p X Y hX

/-! ## Independent fair bits with an XOR observation -/

private def fair : PMF Bool := PMF.uniformOfFintype Bool

private theorem fair_entropy : entropy fair = Real.log 2 := by
  have hmass (b : Bool) : (fair b).toReal = (2 : ℝ)⁻¹ := by
    simp [fair, PMF.uniformOfFintype_apply]
  rw [entropy_eq_sum, Fintype.sum_bool]
  simp only [hmass, Real.negMulLog, Real.log_inv]
  ring

private def source : PMF (Bool × Bool) := PMF.uniformOfFintype (Bool × Bool)

private theorem source_eq_indepProd : source = indepProd fair fair := by
  apply PMF.ext
  rintro ⟨a, b⟩
  norm_num [source, fair, indepProd_apply, PMF.uniformOfFintype_apply]
  rw [← ENNReal.mul_inv (a := 2) (b := 2) (by norm_num) (by norm_num)]
  norm_num

private theorem source_independent : IsIndependent source := by
  rw [source_eq_indepProd]
  exact isIndependent_indepProd fair fair

private def bits : Bool → Bool × Bool → Bool
  | false => Prod.fst
  | true => Prod.snd

private def word (ω : Bool × Bool) : Bool → Bool := fun i => bits i ω

private def parity (ω : Bool × Bool) : Bool := ω.1 != ω.2

private theorem bits_independent :
    IsMutuallyIndependentFamilyOf source bits Finset.univ := by
  have hp : IsIndependentOf source (bits false) (bits true) := by
    unfold IsIndependentOf
    change IsIndependent (source.map id)
    rw [PMF.map_id]
    exact source_independent
  have h := (isMutuallyIndependentFamilyOf_pair_iff_isIndependentOf source bits
    (i := false) (j := true) (by decide)).2 hp
  simpa only [show ({false, true} : Finset Bool) = Finset.univ by decide] using h

private theorem coordinate_parity_law (i : Bool) :
    source.map (fun ω => (bits i ω, parity ω)) = source := by
  apply PMF.ext
  rintro ⟨a, b⟩
  cases i <;> cases a <;> cases b <;>
    norm_num [PMF.map_apply, tsum_fintype, Fintype.sum_prod_type, Fintype.sum_bool,
      source, PMF.uniformOfFintype_apply, bits, parity]

private theorem coordinate_law (i : Bool) : source.map (bits i) = fair := by
  have h := congrArg (fun p : PMF (Bool × Bool) => p.map Prod.fst)
    (coordinate_parity_law i)
  rw [PMF.map_comp] at h
  change source.map (bits i) = fstMarginal source at h
  rw [source_eq_indepProd, fstMarginal_indepProd] at h
  simpa only [source_eq_indepProd] using h

private theorem parity_law : source.map parity = fair := by
  have h := congrArg (fun p : PMF (Bool × Bool) => p.map Prod.snd)
    (coordinate_parity_law false)
  rw [PMF.map_comp] at h
  change source.map parity = sndMarginal source at h
  rw [source_eq_indepProd, sndMarginal_indepProd] at h
  simpa only [source_eq_indepProd] using h

private theorem coordinate_parity_independent (i : Bool) :
    IsIndependentOf source (bits i) parity := by
  unfold IsIndependentOf
  rw [coordinate_parity_law]
  exact source_independent

private theorem coordinate_information_zero (i : Bool) :
    mutualInfoOf source (bits i) parity = 0 :=
  (mutualInfoOf_eq_zero_iff_isIndependentOf source (bits i) parity).2
    (coordinate_parity_independent i)

private theorem coordinate_information_sum_zero :
    (∑ i : Bool, mutualInfoOf source (bits i) parity) = 0 := by
  simp only [coordinate_information_zero, Finset.sum_const_zero]

private theorem coordinate_entropy (i : Bool) : entropyOf source (bits i) = Real.log 2 := by
  rw [entropyOf, coordinate_law, fair_entropy]

private theorem parity_entropy : entropyOf source parity = Real.log 2 := by
  rw [entropyOf, parity_law, fair_entropy]

private theorem parity_given_word_zero : condEntropyOf source parity word = 0 := by
  have h := condEntropyOf_comp_eq_zero source word (fun x : Bool → Bool => x false != x true)
  convert! h

private theorem joint_information : mutualInfoOf source word parity = Real.log 2 := by
  rw [mutualInfoOf_eq_entropyOf_sub_condEntropyOf_swap, parity_entropy,
    parity_given_word_zero, sub_zero]

private theorem xor_information_bound :
    (∑ i : Bool, mutualInfoOf source (bits i) parity) ≤ mutualInfoOf source word parity := by
  convert! sum_mutualInfoOf_le_mutualInfoOf_pi source bits parity bits_independent

private theorem xor_information_bound_strict :
    (∑ i : Bool, mutualInfoOf source (bits i) parity) < mutualInfoOf source word parity := by
  rw [coordinate_information_sum_zero, joint_information]
  exact Real.log_pos (by norm_num)

private theorem word_injective : Function.Injective word := by
  intro a b h
  exact Prod.ext (congrFun h false) (congrFun h true)

private theorem word_entropy : entropyOf source word = 2 * Real.log 2 := by
  rw [entropyOf, entropy_map_injective source word_injective]
  have h := (jointEntropy_eq_add_marginalEntropy_iff_isIndependent source).2 source_independent
  rw [source_eq_indepProd, fstMarginal_indepProd, sndMarginal_indepProd, fair_entropy] at h
  rw [source_eq_indepProd]
  linarith

private theorem coordinate_conditional_entropy (i : Bool) :
    condEntropyOf source (bits i) parity = Real.log 2 := by
  rw [(condEntropyOf_eq_entropyOf_iff_isIndependentOf source (bits i) parity).2
    (coordinate_parity_independent i), coordinate_entropy]

private theorem word_conditional_entropy : condEntropyOf source word parity = Real.log 2 := by
  have h := mutualInfoOf_eq_entropyOf_sub_condEntropyOf source word parity
  rw [joint_information, word_entropy] at h
  linarith

private theorem coordinate_conditional_entropy_sum :
    (∑ i : Bool, condEntropyOf source (bits i) parity) = 2 * Real.log 2 := by
  simp only [coordinate_conditional_entropy, Fintype.sum_bool]
  ring

private theorem xor_conditional_subadditivity :
    condEntropyOf source word parity ≤ ∑ i : Bool, condEntropyOf source (bits i) parity := by
  convert! condEntropyOf_pi_le_sum source bits parity

private theorem xor_conditional_subadditivity_strict :
    condEntropyOf source word parity < ∑ i : Bool, condEntropyOf source (bits i) parity := by
  rw [word_conditional_entropy, coordinate_conditional_entropy_sum]
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  linarith

/-! ## Conditioning on XOR creates dependence -/

private theorem first_bit_recovered :
    condEntropyOf source (bits false) (fun ω => (bits true ω, parity ω)) = 0 := by
  apply (condEntropyOf_eq_zero_iff_exists_function source (bits false)
    (fun ω => (bits true ω, parity ω))).2
  refine ⟨fun byValue : Bool × Bool => byValue.1 != byValue.2, ?_⟩
  rintro ⟨a, b⟩ _
  cases a <;> cases b <;> rfl

private theorem xor_conditional_information :
    condMutualInfoOf source (bits false) (bits true) parity = Real.log 2 := by
  rw [condMutualInfoOf_eq_condEntropyOf_sub_condEntropyOf,
    coordinate_conditional_entropy, first_bit_recovered, sub_zero]

private theorem xor_not_conditionally_independent :
    ¬ IsCondIndependentOf source (bits false) (bits true) parity := by
  intro h
  have hz := (condMutualInfoOf_eq_zero_iff_isCondIndependentOf source
    (bits false) (bits true) parity).2 h
  rw [xor_conditional_information] at hz
  exact (ne_of_gt (Real.log_pos (by norm_num : (1 : ℝ) < 2))) hz

/-! ## Heterogeneous observations on an infinite source carrier -/

private abbrev Alphabet : Bool → Type
  | false => Bool
  | true => Fin 3

private instance alphabetFintype (i : Bool) : Fintype (Alphabet i) := by
  cases i <;> dsimp [Alphabet] <;> infer_instance

private def tritLaw : PMF (Fin 3) := PMF.uniformOfFintype (Fin 3)

private def heterogeneousSource : PMF (ℕ × (Bool × Fin 3)) :=
  (indepProd fair tritLaw).map (fun bt => (0, bt))

private theorem heterogeneous_source_carrier_infinite : Infinite (ℕ × (Bool × Fin 3)) :=
  inferInstance

private def heterogeneousCoordinates : (i : Bool) → (ℕ × (Bool × Fin 3)) → Alphabet i
  | false => fun ω => ω.2.1
  | true => fun ω => ω.2.2

private def liftedObservation (ω : ℕ × (Bool × Fin 3)) : ULift.{1} Bool :=
  ⟨ω.2.1 != decide (ω.2.2 = 0)⟩

private theorem heterogeneous_pair_law :
    heterogeneousSource.map (fun ω => (heterogeneousCoordinates false ω,
      heterogeneousCoordinates true ω)) = indepProd fair tritLaw := by
  rw [heterogeneousSource, PMF.map_comp]
  change (indepProd fair tritLaw).map id = indepProd fair tritLaw
  exact PMF.map_id _

private theorem heterogeneous_independent :
    IsMutuallyIndependentFamilyOf heterogeneousSource heterogeneousCoordinates Finset.univ := by
  have hp : IsIndependentOf heterogeneousSource
      (heterogeneousCoordinates false) (heterogeneousCoordinates true) := by
    unfold IsIndependentOf
    rw [heterogeneous_pair_law]
    exact isIndependent_indepProd fair tritLaw
  have h := (isMutuallyIndependentFamilyOf_pair_iff_isIndependentOf
    heterogeneousSource heterogeneousCoordinates (i := false) (j := true) (by decide)).2 hp
  simpa only [show ({false, true} : Finset Bool) = Finset.univ by decide] using h

private theorem heterogeneous_conditional_bound :
    condEntropyOf heterogeneousSource (fun ω i => heterogeneousCoordinates i ω) liftedObservation ≤
      ∑ i, condEntropyOf heterogeneousSource (heterogeneousCoordinates i) liftedObservation := by
  convert! condEntropyOf_pi_le_sum heterogeneousSource heterogeneousCoordinates liftedObservation

private theorem heterogeneous_information_bound :
    (∑ i, mutualInfoOf heterogeneousSource (heterogeneousCoordinates i) liftedObservation) ≤
      mutualInfoOf heterogeneousSource (fun ω i => heterogeneousCoordinates i ω)
        liftedObservation := by
  convert! sum_mutualInfoOf_le_mutualInfoOf_pi heterogeneousSource heterogeneousCoordinates
    liftedObservation heterogeneous_independent

/-! ## Empty and singleton families use the actual endpoints -/

private def emptyCoordinates {Ω : Type w} : Empty → Ω → Bool := fun i => nomatch i

private def emptyWord {Ω : Type w} (_ : Ω) : Empty → Bool := fun i => nomatch i

private theorem empty_family_independent {Ω : Type w} (p : PMF Ω) :
    IsMutuallyIndependentFamilyOf p emptyCoordinates Finset.univ := by
  change IsMutuallyIndependentFamily (familyLawOf p emptyCoordinates) Finset.univ
  rw [Finset.univ_eq_empty]
  exact isMutuallyIndependentFamily_empty _

private theorem empty_word_entropy {Ω : Type w} (p : PMF Ω) : entropyOf p emptyWord = 0 := by
  have hword : (emptyWord : Ω → Empty → Bool) =
      Function.const Ω (Empty.elim : Empty → Bool) := by
    funext ω i
    exact i.elim
  rw [entropyOf, hword, PMF.map_const, entropy_pure]

private theorem empty_conditional_entropy
    {Ω : Type w} {C : Type z} [Fintype C] (p : PMF Ω) (Y : Ω → C) :
    condEntropyOf p emptyWord Y = 0 := by
  have h := condEntropyOf_pi_le_sum p emptyCoordinates Y
  simp only [Finset.univ_eq_empty, Finset.sum_empty] at h
  have hu : condEntropyOf p emptyWord Y ≤ 0 := by convert! h
  exact le_antisymm hu (condEntropyOf_nonneg p emptyWord Y)

private theorem empty_information
    {Ω : Type w} {C : Type z} [Fintype C] (p : PMF Ω) (Y : Ω → C) :
    mutualInfoOf p emptyWord Y = 0 := by
  have h := sum_mutualInfoOf_le_mutualInfoOf_pi p emptyCoordinates Y (empty_family_independent p)
  simp only [Finset.univ_eq_empty, Finset.sum_empty] at h
  have hl : 0 ≤ mutualInfoOf p emptyWord Y := by convert! h
  have hu := mutualInfoOf_le_entropyOf_left p emptyWord Y
  rw [empty_word_entropy] at hu
  exact le_antisymm hu hl

private theorem singleton_family_independent
    {Ω : Type w} {A : Type v} (p : PMF Ω) (X : Ω → A) :
    IsMutuallyIndependentFamilyOf p (fun _ : Unit => X) Finset.univ := by
  change IsMutuallyIndependentFamily (familyLawOf p (fun _ : Unit => X)) Finset.univ
  rw [show (Finset.univ : Finset Unit) = {()} by decide]
  exact isMutuallyIndependentFamily_singleton _ ()

private theorem singleton_conditional_entropy
    {Ω : Type w} {A : Type v} {C : Type z} [Fintype A] [Fintype C]
    (p : PMF Ω) (X : Ω → A) (Y : Ω → C) :
    condEntropyOf p (fun ω (_ : Unit) => X ω) Y = condEntropyOf p X Y := by
  have h := condEntropyOf_pi_le_sum p (fun _ : Unit => X) Y
  simp only [Fintype.sum_unique] at h
  have hu : condEntropyOf p (fun ω (_ : Unit) => X ω) Y ≤ condEntropyOf p X Y := by
    convert! h
  have hl := condEntropyOf_comp_le p (fun ω (_ : Unit) => X ω) Y (fun f => f ())
  exact le_antisymm hu hl

private theorem singleton_information
    {Ω : Type w} {A : Type v} {C : Type z} [Fintype A] [Fintype C]
    (p : PMF Ω) (X : Ω → A) (Y : Ω → C) :
    mutualInfoOf p (fun ω (_ : Unit) => X ω) Y = mutualInfoOf p X Y := by
  have h := sum_mutualInfoOf_le_mutualInfoOf_pi p (fun _ : Unit => X) Y
    (singleton_family_independent p X)
  simp only [Fintype.sum_unique] at h
  have hl : mutualInfoOf p X Y ≤ mutualInfoOf p (fun ω (_ : Unit) => X ω) Y := by
    convert! h
  have hu := mutualInfoOf_comp_left_le p X Y (fun a (_ : Unit) => a)
  exact le_antisymm hu hl

end

end LeanInfoTheory.Examples.FiniteFamilyInformation
