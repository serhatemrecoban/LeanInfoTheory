/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.FiniteProduct

/-!
# Finite-product family and independence consumers

These private consumers connect dependent product laws to the existing finite
family semantics. A fair Boolean and a sparse ternary coordinate exercise
selected outcomes, marginals and independence, including impossible outcomes.
A third, biased Boolean coordinate gives a non-iid family whose full
three-coordinate atom satisfies the public mutual-independence bridge.

Identity-family source semantics and the existing measure independence bridge
are used directly. The same triple exercises product and full-family entropy.
Independent diagonal pairs exercise positive within-pair mutual information:
two fair pairs give twice log 2. A separate heterogeneous, nonidentical family
uses the fair, sparse ternary and biased laws without any channel import.
-/

namespace LeanInfoTheory.Examples.FiniteProductSemantics

noncomputable section

universe u v

open scoped BigOperators ENNReal
open LeanInfoTheory.Shannon

/-! ## Generic consumers of the focused semantic interfaces -/

private theorem selected_marginal
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (s : Finset I) :
    familyMarginal (PMF.finiteProduct p) s =
      (PMF.finiteProduct (fun i : s => p i.1) : PMF (FamilyOutcome A s)) :=
  familyMarginal_finiteProduct p s

private theorem selected_atoms
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (s : Finset I) (x : FamilyOutcome A s) :
    familyMarginal (PMF.finiteProduct p) s x = ∏ i : s, p i.1 (x i) := by
  rw [familyMarginal_finiteProduct, PMF.finiteProduct_apply]

private theorem selected_support
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (s : Finset I) (x : FamilyOutcome A s) :
    x ∈ (familyMarginal (PMF.finiteProduct p) s).support ↔
      ∀ i : s, x i ∈ (p i.1).support := by
  rw [familyMarginal_finiteProduct]
  exact PMF.mem_support_finiteProduct_iff (fun i : s => p i.1) x

private theorem identity_family_law
    {I : Type u} {A : I → Type v} (q : PMF ((i : I) → A i)) :
    familyLawOf q (fun i x => x i) = q :=
  PMF.map_id q

private theorem identity_family_independent
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (s : Finset I) :
    IsMutuallyIndependentFamilyOf (PMF.finiteProduct p) (fun i x => x i) s := by
  unfold IsMutuallyIndependentFamilyOf
  rw [identity_family_law]
  exact isMutuallyIndependentFamily_finiteProduct p s

private theorem pair_eq_indepProd
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) {i j : I} (hij : i ≠ j) :
    (PMF.finiteProduct p).map (fun x => (x i, x j)) = indepProd (p i) (p j) :=
  PMF.finiteProduct_map_pair p hij

private theorem independent_coordinates
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) {i j : I} (hij : i ≠ j) :
    IsIndependentOf (PMF.finiteProduct p) (fun x => x i) (fun x => x j) :=
  isIndependentOf_finiteProduct_eval p hij

private theorem coordinate_indepFun
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    [MeasurableSpace ((i : I) → A i)]
    [∀ i, MeasurableSpace (A i)] [∀ i, MeasurableSingletonClass (A i)]
    (p : ∀ i, PMF (A i)) {i j : I} (hij : i ≠ j)
    (hi : Measurable (fun x : ((k : I) → A k) => x i))
    (hj : Measurable (fun x : ((k : I) → A k) => x j)) :
    ProbabilityTheory.IndepFun (fun x => x i) (fun x => x j)
      (PMF.finiteProduct p).toMeasure :=
  (isIndependentOf_iff_indepFun (PMF.finiteProduct p)
    (fun x => x i) (fun x => x j) hi hj).1
    (isIndependentOf_finiteProduct_eval p hij)

/-! ## A heterogeneous sparse two-coordinate family -/

private theorem half_mass_add :
    ENNReal.ofReal (1 / 2 : ℝ) + ENNReal.ofReal (1 / 2 : ℝ) = 1 := by
  rw [← ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1 / 2)
    (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  norm_num

private def fair : PMF Bool :=
  PMF.ofFintype (fun _ => ENNReal.ofReal (1 / 2 : ℝ))
    (by rw [Fintype.sum_bool]; exact half_mass_add)

private def sparse : PMF (Fin 3) :=
  PMF.ofFintype
    (fun a => if a = 2 then 0 else ENNReal.ofReal (1 / 2 : ℝ))
    (by simpa [Fin.sum_univ_three] using half_mass_add)

private def Alphabet : Bool → Type
  | false => Bool
  | true => Fin 3

private instance alphabetFintype (i : Bool) : Fintype (Alphabet i) := by
  cases i <;> dsimp [Alphabet] <;> infer_instance

private def components : (i : Bool) → PMF (Alphabet i)
  | false => fair
  | true => sparse

private def outcome (b : Bool) (t : Fin 3) : (i : Bool) → Alphabet i
  | false => b
  | true => t

private def law : PMF ((i : Bool) → Alphabet i) :=
  PMF.finiteProduct components

private def pairAtom : Finset Bool := {false, true}

private def selectedOutcome (s : Finset Bool) (b : Bool) (t : Fin 3) :
    FamilyOutcome Alphabet s :=
  fun i => outcome b t i.1

private theorem heterogeneous_marginal (s : Finset Bool) :
    familyMarginal law s = PMF.finiteProduct (fun i : s => components i.1) :=
  familyMarginal_finiteProduct components s

private theorem empty_marginal :
    familyMarginal law ∅ =
      PMF.pure (fun i : (∅ : Finset Bool) => (isEmptyElim i : Alphabet i.1)) := by
  rw [heterogeneous_marginal]
  exact PMF.finiteProduct_of_isEmpty (fun i : (∅ : Finset Bool) => components i.1)

private theorem singleton_marginal :
    familyMarginal law {true} =
      PMF.finiteProduct (fun i : ({true} : Finset Bool) => components i.1) :=
  heterogeneous_marginal {true}

private theorem full_pair_marginal :
    familyMarginal law pairAtom =
      PMF.finiteProduct (fun i : pairAtom => components i.1) :=
  heterogeneous_marginal pairAtom

private theorem sparse_selected_support (b : Bool) (t : Fin 3) :
    selectedOutcome pairAtom b t ∈ (familyMarginal law pairAtom).support ↔ t ≠ 2 := by
  change selectedOutcome pairAtom b t ∈
    (familyMarginal (PMF.finiteProduct components) pairAtom).support ↔ t ≠ 2
  rw [selected_support]
  constructor
  · intro h ht
    have hz := h ⟨true, by simp [pairAtom]⟩
    change sparse t ≠ 0 at hz
    rw [ht] at hz
    norm_num [sparse, PMF.ofFintype_apply] at hz
  · intro ht i
    rcases i with ⟨i, hi⟩
    cases i with
    | false =>
        change fair b ≠ 0
        norm_num [fair, PMF.ofFintype_apply]
    | true =>
        change sparse t ≠ 0
        simp [sparse, PMF.ofFintype_apply, ht]

private theorem sparse_selected_words (b : Bool) :
    selectedOutcome pairAtom b 0 ∈ (familyMarginal law pairAtom).support ∧
      selectedOutcome pairAtom b 2 ∉ (familyMarginal law pairAtom).support := by
  constructor
  · exact (sparse_selected_support b 0).2 (by decide)
  · intro h
    exact (sparse_selected_support b 2).1 h rfl

private theorem empty_independent : IsMutuallyIndependentFamily law ∅ :=
  isMutuallyIndependentFamily_finiteProduct components ∅

private theorem singleton_independent : IsMutuallyIndependentFamily law {true} :=
  isMutuallyIndependentFamily_finiteProduct components {true}

private theorem pair_independent : IsMutuallyIndependentFamily law pairAtom :=
  isMutuallyIndependentFamily_finiteProduct components pairAtom

private theorem pair_source_independent :
    IsMutuallyIndependentFamilyOf law (fun i x => x i) pairAtom :=
  identity_family_independent components pairAtom

private theorem bit_trit_joint :
    law.map (fun x => (x false, x true)) = indepProd fair sparse :=
  pair_eq_indepProd components (i := false) (j := true) (by decide)

private theorem trit_bit_joint :
    law.map (fun x => (x true, x false)) = indepProd sparse fair :=
  pair_eq_indepProd components (i := true) (j := false) (by decide)

private theorem bit_trit_independent :
    IsIndependentOf law (fun x => x false) (fun x => x true) :=
  isIndependentOf_finiteProduct_eval components (i := false) (j := true) (by decide)

private theorem bit_trit_impossible_mass (b : Bool) :
    (law.map (fun x => (x false, x true))) (b, (2 : Fin 3)) = 0 := by
  have h := congrArg (fun p : PMF (Bool × Fin 3) => p (b, 2)) bit_trit_joint
  apply h.trans
  rw [indepProd_apply]
  simp [sparse, PMF.ofFintype_apply]

/-! ## Full mutual independence of a non-iid three-coordinate family -/

private def biased : PMF Bool :=
  PMF.ofFintype (fun b => ENNReal.ofReal (if b then (1 / 4 : ℝ) else 3 / 4))
    (by
      rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
      norm_num)

private theorem biased_ne_fair : biased ≠ fair := by
  intro h
  have hm := congrArg (fun p : PMF Bool => (p true).toReal) h
  norm_num [biased, fair, PMF.ofFintype_apply] at hm

private def TripleAlphabet : Bool ⊕ Unit → Type
  | .inl i => Alphabet i
  | .inr _ => Bool

private instance tripleAlphabetFintype (i : Bool ⊕ Unit) :
    Fintype (TripleAlphabet i) := by
  cases i with
  | inl i => exact alphabetFintype i
  | inr _ => exact inferInstanceAs (Fintype Bool)

private def tripleComponents : (i : Bool ⊕ Unit) → PMF (TripleAlphabet i)
  | .inl i => components i
  | .inr _ => biased

private def tripleLaw : PMF ((i : Bool ⊕ Unit) → TripleAlphabet i) :=
  PMF.finiteProduct tripleComponents

private def fullAtom : Finset (Bool ⊕ Unit) :=
  {Sum.inl false, Sum.inl true, Sum.inr ()}

private theorem fullAtom_eq_univ : fullAtom = Finset.univ := by decide

private theorem fullAtom_card : fullAtom.card = 3 := by decide

private theorem distinct_boolean_components :
    tripleComponents (Sum.inr ()) ≠ tripleComponents (Sum.inl false) :=
  biased_ne_fair

private theorem full_marginal :
    familyMarginal tripleLaw fullAtom =
      PMF.finiteProduct (fun i : fullAtom => tripleComponents i.1) :=
  familyMarginal_finiteProduct tripleComponents fullAtom

private theorem full_mutual_independence :
    IsMutuallyIndependentFamily tripleLaw fullAtom :=
  isMutuallyIndependentFamily_finiteProduct tripleComponents fullAtom

private theorem full_factorization (x : FamilyOutcome TripleAlphabet fullAtom) :
    familyMarginal tripleLaw fullAtom x =
      ∏ i : fullAtom, (tripleLaw.map fun y => y i.1) (x i) :=
  full_mutual_independence x

private theorem full_source_independence :
    IsMutuallyIndependentFamilyOf tripleLaw (fun i x => x i) fullAtom :=
  identity_family_independent tripleComponents fullAtom

private theorem first_third_independent :
    IsIndependentOf tripleLaw (fun x => x (Sum.inl false))
      (fun x => x (Sum.inr ())) :=
  isIndependentOf_finiteProduct_eval tripleComponents
    (i := Sum.inl false) (j := Sum.inr ()) (by decide)

/-! ## Entropy of the same heterogeneous, sparse, non-iid family -/

private theorem triple_entropy_sum :
    (∑ i, entropy (tripleComponents i)) =
      entropy fair + entropy sparse + entropy biased := by
  simp only [Fintype.sum_sum_type, Fintype.sum_bool, Fintype.sum_unique,
    tripleComponents, components]
  convert! congrArg (fun x : ℝ => x + entropy biased)
    (add_comm (entropy sparse) (entropy fair))

private theorem heterogeneous_entropy :
    entropy tripleLaw = entropy fair + entropy sparse + entropy biased := by
  have h := entropy_finiteProduct tripleComponents
  rw [triple_entropy_sum] at h
  convert! h

private theorem full_family_entropy :
    familyEntropy tripleLaw fullAtom =
      entropy fair + entropy sparse + entropy biased := by
  rw [fullAtom_eq_univ]
  have h :=
    (familyEntropy_eq_sum_singletons_iff_isMutuallyIndependentFamily
      tripleLaw Finset.univ).2
      (by simpa [fullAtom_eq_univ] using full_mutual_independence)
  have h' : familyEntropy tripleLaw Finset.univ =
      ∑ i, entropy (tripleComponents i) := by
    simpa only [familyEntropy_singleton, entropyOf, tripleLaw,
      PMF.finiteProduct_map_eval] using h
  exact h'.trans triple_entropy_sum

private theorem full_family_entropy_eq_word :
    familyEntropy tripleLaw fullAtom = entropy tripleLaw := by
  rw [full_family_entropy, heterogeneous_entropy]

private theorem singleton_index_entropy :
    entropy (PMF.finiteProduct (fun _ : Unit => sparse)) = entropy sparse := by
  have h := entropy_finiteProduct (fun _ : Unit => sparse)
  simp only [Fintype.sum_unique] at h
  convert! h

private theorem singleton_alphabet_entropy :
    entropy (PMF.finiteProduct (fun _ : Bool => PMF.pure PUnit.unit)) = 0 := by
  have h := entropy_finiteProduct (fun _ : Bool => PMF.pure PUnit.unit)
  simp only [entropy_pure, Finset.sum_const_zero] at h
  convert! h

/-! ## Independent pairs with positive within-pair mutual information -/

private theorem fair_entropy : entropy fair = Real.log 2 := by
  have hmass (b : Bool) : (fair b).toReal = (2 : ℝ)⁻¹ := by
    norm_num [fair, PMF.ofFintype_apply]
  rw [entropy_eq_sum, Fintype.sum_bool]
  simp only [hmass, Real.negMulLog, Real.log_inv]
  ring

private def fairPair : PMF (Bool × Bool) := fair.map (fun b => (b, b))

private def independentFairPairs : PMF (Bool → Bool × Bool) :=
  PMF.finiteProduct (fun _ : Bool => fairPair)

private theorem fair_pair_mutualInfo : mutualInfo fairPair = Real.log 2 := by
  rw [fairPair, mutualInfo_map_diag, fair_entropy]

private theorem fair_pair_mutualInfo_pos : 0 < mutualInfo fairPair := by
  rw [fair_pair_mutualInfo]
  exact Real.log_pos (by norm_num : (1 : ℝ) < 2)

private theorem independent_fair_pairs :
    IsMutuallyIndependentFamily independentFairPairs Finset.univ :=
  isMutuallyIndependentFamily_finiteProduct (fun _ : Bool => fairPair) Finset.univ

private theorem fair_pair_coordinate_mutualInfo (i : Bool) :
    mutualInfo (independentFairPairs.map (fun z => z i)) = Real.log 2 := by
  rw [independentFairPairs, PMF.finiteProduct_map_eval, fair_pair_mutualInfo]

private theorem independent_fair_pairs_mutualInfo :
    mutualInfo (independentFairPairs.map
      (Equiv.arrowProdEquivProdArrow Bool (fun _ => Bool) (fun _ => Bool))) =
      2 * Real.log 2 := by
  have h := mutualInfo_map_piProd_eq_sum_of_isMutuallyIndependentFamily
    independentFairPairs independent_fair_pairs
  simp only [fair_pair_coordinate_mutualInfo, Fintype.sum_bool] at h
  rw [← two_mul] at h
  convert! h

/-! ## A heterogeneous and nonidentical independent pair family -/

private def triplePairComponents (i : Bool ⊕ Unit) :
    PMF (TripleAlphabet i × TripleAlphabet i) :=
  (tripleComponents i).map (fun a => (a, a))

private def triplePairLaw :
    PMF ((i : Bool ⊕ Unit) → TripleAlphabet i × TripleAlphabet i) :=
  PMF.finiteProduct triplePairComponents

private theorem heterogeneous_pairs_independent :
    IsMutuallyIndependentFamily triplePairLaw Finset.univ :=
  isMutuallyIndependentFamily_finiteProduct triplePairComponents Finset.univ

private theorem nonidentical_boolean_pairs :
    triplePairComponents (Sum.inr ()) ≠ triplePairComponents (Sum.inl false) := by
  intro h
  apply biased_ne_fair
  have hm := congrArg (fun p : PMF (Bool × Bool) => fstMarginal p) h
  change fstMarginal (biased.map (fun a => (a, a))) =
    fstMarginal (fair.map (fun a => (a, a))) at hm
  simp only [fstMarginal, PMF.map_comp, Function.comp_def] at hm
  change biased.map id = fair.map id at hm
  simpa only [PMF.map_id] using hm

private theorem sparse_ternary_pair_zero :
    triplePairComponents (Sum.inl true) ((2 : Fin 3), (2 : Fin 3)) = 0 := by
  change (sparse.map (fun a => (a, a))) (2, 2) = 0
  have hdiag : Function.Injective (fun a : Fin 3 => (a, a)) := by
    intro a b h
    exact congrArg Prod.fst h
  rw [PMF.map_apply_of_injective sparse hdiag (2 : Fin 3)]
  simp [sparse, PMF.ofFintype_apply]

private theorem heterogeneous_pairs_mutualInfo :
    mutualInfo (triplePairLaw.map
      (Equiv.arrowProdEquivProdArrow (Bool ⊕ Unit) TripleAlphabet TripleAlphabet)) =
      entropy fair + entropy sparse + entropy biased := by
  have h := mutualInfo_map_piProd_eq_sum_of_isMutuallyIndependentFamily
    triplePairLaw heterogeneous_pairs_independent
  have hs : (∑ i, mutualInfo (triplePairLaw.map (fun z => z i))) =
      ∑ i, entropy (tripleComponents i) := by
    simp only [triplePairLaw, PMF.finiteProduct_map_eval,
      triplePairComponents, mutualInfo_map_diag]
  convert! h.trans (hs.trans triple_entropy_sum)

end

end LeanInfoTheory.Examples.FiniteProductSemantics
