/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.FiniteProduct

/-!
# Finite dependent-product consumers

These private consumers use only the focused probability owner. They exercise
heterogeneous sparse component laws, exact atoms and coordinate marginals,
empty and singleton products, pure coordinates, and products selected from an
infinite ambient family whose unselected alphabets remain infinite.
-/

namespace LeanInfoTheory.Examples.FiniteProduct

noncomputable section

universe u v w

open scoped BigOperators ENNReal

/-! ## Heterogeneous sparse laws -/

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

private theorem bit_marginal : law.map (fun x => x false) = fair :=
  PMF.finiteProduct_map_eval components false

private theorem trit_marginal : law.map (fun x => x true) = sparse :=
  PMF.finiteProduct_map_eval components true

private theorem exact_atoms (b : Bool) (t : Fin 3) :
    law (outcome b t) =
      if t = 2 then 0 else ENNReal.ofReal (1 / 4 : ℝ) := by
  rw [law, PMF.finiteProduct_apply, Fintype.prod_bool]
  change sparse t * fair b = _
  by_cases ht : t = 2
  · simp [sparse, fair, PMF.ofFintype_apply, ht]
  · simp only [sparse, fair, PMF.ofFintype_apply, if_neg ht]
    rw [← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2)]
    congr 1
    norm_num

private theorem supported_iff (b : Bool) (t : Fin 3) :
    outcome b t ∈ law.support ↔ t ≠ 2 := by
  rw [law, PMF.mem_support_finiteProduct_iff]
  constructor
  · intro h ht
    subst t
    have hz := h true
    change sparse 2 ≠ 0 at hz
    norm_num [sparse, PMF.ofFintype_apply] at hz
  · intro ht i
    cases i with
    | false =>
        change fair b ≠ 0
        norm_num [fair, PMF.ofFintype_apply]
    | true =>
        change sparse t ≠ 0
        simp [sparse, PMF.ofFintype_apply, ht]

private theorem supported_words (b : Bool) :
    outcome b 0 ∈ law.support ∧ outcome b 1 ∈ law.support := by
  constructor <;> rw [supported_iff] <;> decide

private theorem impossible_word (b : Bool) :
    law (outcome b 2) = 0 ∧ outcome b 2 ∉ law.support := by
  constructor
  · simp [exact_atoms]
  · intro h
    exact (supported_iff b 2).mp h rfl

private theorem product_atom_zero_iff
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (x : (i : I) → A i) :
    PMF.finiteProduct p x = 0 ↔ ∃ i, p i (x i) = 0 := by
  classical
  rw [PMF.finiteProduct_apply]
  simp only [Finset.prod_eq_zero_iff, Finset.mem_univ, true_and]

/-! ## Empty, singleton and pure products -/

private def emptyComponents (i : Fin 0) : PMF Empty := isEmptyElim i

private theorem empty_product :
    PMF.finiteProduct emptyComponents =
      PMF.pure (fun i : Fin 0 => (isEmptyElim i : Empty)) :=
  PMF.finiteProduct_of_isEmpty emptyComponents

private theorem singleton_eval
    {I : Type u} {A : I → Type v}
    [Fintype I] [Unique I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) :
    (PMF.finiteProduct p).map (Equiv.piUnique A) = p default := by
  change (PMF.finiteProduct p).map (fun x => x default) = p default
  exact PMF.finiteProduct_map_eval p default

private theorem singleton_rebuild
    {I : Type u} {A : I → Type v}
    [Fintype I] [Unique I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) :
    (p default).map (Equiv.piUnique A).symm = PMF.finiteProduct p := by
  have h := congrArg
    (fun q : PMF (A default) => q.map (Equiv.piUnique A).symm)
    (singleton_eval p)
  simpa only [PMF.map_comp, Equiv.symm_comp_self, PMF.map_id] using h.symm

private theorem sparse_singleton_eval :
    (PMF.finiteProduct (fun _ : Unit => sparse)).map
      (Equiv.piUnique (fun _ : Unit => Fin 3)) = sparse :=
  singleton_eval (fun _ : Unit => sparse)

private theorem sparse_singleton_rebuild :
    sparse.map (Equiv.piUnique (fun _ : Unit => Fin 3)).symm =
      PMF.finiteProduct (fun _ : Unit => sparse) :=
  singleton_rebuild (fun _ : Unit => sparse)

private theorem pure_coordinates
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)] (a : (i : I) → A i) :
    PMF.finiteProduct (fun i => PMF.pure (a i)) = PMF.pure a :=
  PMF.finiteProduct_pure a

private theorem singleton_alphabets :
    PMF.finiteProduct (fun _ : Fin 3 => PMF.pure ()) =
      PMF.pure (fun _ : Fin 3 => ()) :=
  PMF.finiteProduct_pure (fun _ : Fin 3 => ())

private theorem no_empty_law {A : Type v} [IsEmpty A] :
    ¬ Nonempty (PMF A) := by
  rintro ⟨p⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

private theorem no_selected_empty_component
    {Var : Type u} {A : Var → Type v} (s : Finset Var)
    (i : s) [IsEmpty (A i.1)] :
    ¬ Nonempty ((j : s) → PMF (A j.1)) := by
  rintro ⟨p⟩
  exact no_empty_law ⟨p i⟩

/-! ## Only selected coordinates require finite alphabets -/

private theorem selected_product_atoms
    {Var : Type u} {A : Var → Type v}
    (s : Finset Var) [∀ i : s, Fintype (A i.1)]
    (p : (i : s) → PMF (A i.1)) (x : (i : s) → A i.1) :
    PMF.finiteProduct p x = ∏ i : s, p i (x i) :=
  PMF.finiteProduct_apply p x

private theorem selected_product_support
    {Var : Type u} {A : Var → Type v}
    (s : Finset Var) [∀ i : s, Fintype (A i.1)]
    (p : (i : s) → PMF (A i.1)) (x : (i : s) → A i.1) :
    x ∈ (PMF.finiteProduct p).support ↔ ∀ i, x i ∈ (p i).support :=
  PMF.mem_support_finiteProduct_iff p x

private theorem selected_product_eval
    {Var : Type u} {A : Var → Type v}
    (s : Finset Var) [∀ i : s, Fintype (A i.1)]
    (p : (i : s) → PMF (A i.1)) (i : s) :
    (PMF.finiteProduct p).map (fun x => x i) = p i :=
  PMF.finiteProduct_map_eval p i

private def AmbientAlphabet : ℕ → Type
  | 0 => Bool
  | 1 => Fin 3
  | _ + 2 => ℕ

private def selected : Finset ℕ := {0, 1}

private instance selectedFintype : (i : selected) → Fintype (AmbientAlphabet i.1)
  | ⟨0, _⟩ => inferInstanceAs (Fintype Bool)
  | ⟨1, _⟩ => inferInstanceAs (Fintype (Fin 3))
  | ⟨n + 2, hn⟩ => False.elim (by simp [selected] at hn)

private def selectedComponents : (i : selected) → PMF (AmbientAlphabet i.1)
  | ⟨0, _⟩ => fair
  | ⟨1, _⟩ => sparse
  | ⟨n + 2, hn⟩ => False.elim (by simp [selected] at hn)

private def selectedLaw : PMF ((i : selected) → AmbientAlphabet i.1) :=
  PMF.finiteProduct selectedComponents

private def zeroIndex : selected := ⟨0, by simp [selected]⟩

private def oneIndex : selected := ⟨1, by simp [selected]⟩

private theorem selected_zero_component : selectedComponents zeroIndex = fair := rfl

private theorem selected_one_component : selectedComponents oneIndex = sparse := rfl

private theorem infinite_ambient_atoms (x : (i : selected) → AmbientAlphabet i.1) :
    selectedLaw x = ∏ i : selected, selectedComponents i (x i) :=
  selected_product_atoms selected selectedComponents x

private theorem infinite_ambient_support (x : (i : selected) → AmbientAlphabet i.1) :
    x ∈ selectedLaw.support ↔ ∀ i, x i ∈ (selectedComponents i).support :=
  selected_product_support selected selectedComponents x

private theorem infinite_ambient_bit_marginal :
    selectedLaw.map (fun x => x zeroIndex) = fair := by
  change (PMF.finiteProduct selectedComponents).map (fun x => x zeroIndex) = fair
  rw [selected_product_eval selected selectedComponents zeroIndex,
    selected_zero_component]

private theorem infinite_ambient_trit_marginal :
    selectedLaw.map (fun x => x oneIndex) = sparse := by
  change (PMF.finiteProduct selectedComponents).map (fun x => x oneIndex) = sparse
  rw [selected_product_eval selected selectedComponents oneIndex,
    selected_one_component]

private theorem unselected_alphabets_infinite (n : ℕ) :
    Infinite (AmbientAlphabet (n + 2)) :=
  inferInstanceAs (Infinite ℕ)

/-! ## Injective restriction and heterogeneous reindexing -/

private def selectTrit : Unit ↪ Bool where
  toFun _ := true
  inj' _ _ _ := Subsingleton.elim _ _

private theorem singleton_restriction :
    law.map (fun x (_ : Unit) => x true) =
      PMF.finiteProduct (fun _ : Unit => sparse) :=
  PMF.finiteProduct_map_restrict components selectTrit

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

private def selectTwo : Bool ↪ Bool ⊕ Unit where
  toFun := Sum.inl
  inj' _ _ h := by cases h; rfl

private theorem three_to_two :
    tripleLaw.map (fun x i => x (Sum.inl i)) = law :=
  PMF.finiteProduct_map_restrict tripleComponents selectTwo

private theorem three_to_one_direct :
    tripleLaw.map (fun x (_ : Unit) => x (Sum.inl true)) =
      PMF.finiteProduct (fun _ : Unit => sparse) :=
  PMF.finiteProduct_map_restrict tripleComponents (selectTrit.trans selectTwo)

private theorem nested_restriction :
    (tripleLaw.map (fun x i => x (Sum.inl i))).map
        (fun y (_ : Unit) => y true) =
      PMF.finiteProduct (fun _ : Unit => sparse) := by
  have h := congrArg
    (fun p : PMF ((i : Bool) → Alphabet i) => p.map (fun y (_ : Unit) => y true))
    three_to_two
  exact h.trans singleton_restriction

private theorem nested_eq_direct :
    (tripleLaw.map (fun x i => x (Sum.inl i))).map
        (fun y (_ : Unit) => y true) =
      tripleLaw.map (fun x (_ : Unit) => x (Sum.inl true)) :=
  PMF.map_comp (p := tripleLaw) (f := fun x i => x (Sum.inl i))
    (fun y (_ : Unit) => y true)

private def swapCoordinates : Bool ≃ Bool where
  toFun := Bool.not
  invFun := Bool.not
  left_inv b := by cases b <;> rfl
  right_inv b := by cases b <;> rfl

private theorem reordered_law :
    law.map (Equiv.piCongrLeft Alphabet swapCoordinates).symm =
      PMF.finiteProduct (fun i => components (swapCoordinates i)) :=
  PMF.finiteProduct_map_reindex components swapCoordinates

private theorem reindex_inverse
    {I : Type u} {J : Type w} {A : I → Type v}
    [Fintype I] [Fintype J] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (e : J ≃ I) :
    (PMF.finiteProduct (fun j => p (e j))).map (Equiv.piCongrLeft A e) =
      PMF.finiteProduct p := by
  have h := congrArg
    (fun q : PMF ((j : J) → A (e j)) => q.map (Equiv.piCongrLeft A e))
    (PMF.finiteProduct_map_reindex p e)
  simpa only [PMF.map_comp, Equiv.self_comp_symm, PMF.map_id] using h.symm

private theorem reordered_law_inverse :
    (PMF.finiteProduct (fun i => components (swapCoordinates i))).map
        (Equiv.piCongrLeft Alphabet swapCoordinates) = law :=
  reindex_inverse components swapCoordinates

private theorem reordered_trit_coordinate :
    (PMF.finiteProduct (fun i => components (swapCoordinates i))).map
        (fun x => x false) = sparse :=
  PMF.finiteProduct_map_eval (fun i => components (swapCoordinates i)) false

private theorem reordered_bit_coordinate :
    (PMF.finiteProduct (fun i => components (swapCoordinates i))).map
        (fun x => x true) = fair :=
  PMF.finiteProduct_map_eval (fun i => components (swapCoordinates i)) true

/-! ## Sum splitting, inverse concatenation and coordinate pairs -/

private def thirdBlock : PMF (Unit → Bool) :=
  PMF.finiteProduct (fun _ : Unit => biased)

private theorem split_three :
    tripleLaw.map (Equiv.sumPiEquivProdPi TripleAlphabet) =
      PMF.channelJoint law (fun _ => thirdBlock) :=
  PMF.finiteProduct_map_sum tripleComponents

private theorem concatenate_three :
    (PMF.channelJoint law (fun _ => thirdBlock)).map
        (Equiv.sumPiEquivProdPi TripleAlphabet).symm = tripleLaw := by
  have h := congrArg
    (fun q : PMF (((i : Bool) → Alphabet i) × (Unit → Bool)) =>
      q.map (Equiv.sumPiEquivProdPi TripleAlphabet).symm)
    split_three
  simpa only [PMF.map_comp, Equiv.symm_comp_self, PMF.map_id] using h.symm

private theorem split_first_block :
    (tripleLaw.map (Equiv.sumPiEquivProdPi TripleAlphabet)).map Prod.fst = law := by
  have h := congrArg
    (fun p : PMF (((i : Bool) → Alphabet i) × (Unit → Bool)) => p.map Prod.fst)
    split_three
  exact h.trans (PMF.channelJoint_map_fst law (fun _ => thirdBlock))

private theorem split_second_block :
    (tripleLaw.map (Equiv.sumPiEquivProdPi TripleAlphabet)).map Prod.snd =
      thirdBlock := by
  have h := congrArg
    (fun p : PMF (((i : Bool) → Alphabet i) × (Unit → Bool)) => p.map Prod.snd)
    split_three
  exact h.trans ((PMF.channelJoint_map_snd law (fun _ => thirdBlock)).trans
    (PMF.bind_const law thirdBlock))

private theorem split_empty_left
    {I : Type u} {J : Type w} {A : I ⊕ J → Type v}
    [Fintype I] [Fintype J] [IsEmpty I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) :
    (PMF.finiteProduct p).map (Equiv.sumPiEquivProdPi A) =
      PMF.channelJoint (PMF.pure (fun i : I => (isEmptyElim i : A (Sum.inl i))))
        (fun _ => PMF.finiteProduct (fun j => p (Sum.inr j))) := by
  have he := PMF.finiteProduct_of_isEmpty (fun i : I => p (Sum.inl i))
  rw [PMF.finiteProduct_map_sum, he]

private theorem split_empty_right
    {I : Type u} {J : Type w} {A : I ⊕ J → Type v}
    [Fintype I] [Fintype J] [IsEmpty J] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) :
    (PMF.finiteProduct p).map (Equiv.sumPiEquivProdPi A) =
      PMF.channelJoint (PMF.finiteProduct (fun i => p (Sum.inl i)))
        (fun _ => PMF.pure (fun j : J => (isEmptyElim j : A (Sum.inr j)))) := by
  have he := PMF.finiteProduct_of_isEmpty (fun j : J => p (Sum.inr j))
  rw [PMF.finiteProduct_map_sum, he]

private theorem bit_trit_pair :
    law.map (fun x => (x false, x true)) =
      PMF.channelJoint fair (fun _ => sparse) :=
  PMF.finiteProduct_map_pair components (i := false) (j := true) (by decide)

private theorem trit_bit_pair :
    law.map (fun x => (x true, x false)) =
      PMF.channelJoint sparse (fun _ => fair) :=
  PMF.finiteProduct_map_pair components (i := true) (j := false) (by decide)

private theorem pair_impossible_trit (b : Bool) :
    (law.map (fun x => (x false, x true))) (b, (2 : Fin 3)) = 0 := by
  have h := congrArg (fun p : PMF (Bool × Fin 3) => p (b, 2)) bit_trit_pair
  apply h.trans
  rw [PMF.channelJoint_apply]
  simp [sparse, PMF.ofFintype_apply]

/-! ## Repeated coordinates do not form an independent product -/

private def duplicated : PMF (Bool × Bool) :=
  law.map (fun x => (x false, x false))

private theorem duplicated_eq : duplicated = fair.map (fun b => (b, b)) := by
  have h := congrArg (fun q : PMF Bool => q.map (fun b => (b, b))) bit_marginal
  have hc := PMF.map_comp
    (fun x : (i : Bool) → Alphabet i => (x false : Bool)) law
    (fun b : Bool => (b, b))
  exact hc.symm.trans h

private theorem duplicated_diagonal (b : Bool) :
    duplicated (b, b) = ENNReal.ofReal (1 / 2 : ℝ) := by
  rw [duplicated_eq]
  simpa only [fair, PMF.ofFintype_apply] using
    PMF.map_apply_of_injective fair (f := fun b : Bool => (b, b))
      (fun a b h => congrArg Prod.fst h) b

private theorem duplicated_off_diagonal : duplicated (false, true) = 0 := by
  rw [duplicated_eq]
  apply PMF.map_apply_eq_zero_of_notMem_range fair
  rintro ⟨b, hb⟩
  cases b <;> simp at hb

private theorem independent_pair_atoms (a b : Bool) :
    PMF.channelJoint fair (fun _ => fair) (a, b) =
      ENNReal.ofReal (1 / 4 : ℝ) := by
  rw [PMF.channelJoint_apply]
  change ENNReal.ofReal (1 / 2 : ℝ) * ENNReal.ofReal (1 / 2 : ℝ) = _
  rw [← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  congr 1
  norm_num

private theorem duplicated_ne_independent :
    duplicated ≠ PMF.channelJoint fair (fun _ => fair) := by
  intro h
  have hm := congrArg (fun p : PMF (Bool × Bool) => p (false, true)) h
  rw [duplicated_off_diagonal, independent_pair_atoms] at hm
  norm_num at hm

private theorem repeated_restriction_ne_product :
    law.map (fun x (_ : Bool) => x false) ≠
      PMF.finiteProduct (fun _ : Bool => fair) := by
  intro h
  have hp := congrArg
    (fun p : PMF (Bool → Bool) => p.map (fun x => (x false, x true))) h
  have hcomp : duplicated =
      (law.map (fun x (_ : Bool) => x false)).map
        (fun y : Bool → Bool => (y false, y true)) :=
    (PMF.map_comp
      (fun x : (i : Bool) → Alphabet i => fun (_ : Bool) => (x false : Bool)) law
      (fun y : Bool → Bool => (y false, y true))).symm
  have hpair := PMF.finiteProduct_map_pair (fun _ : Bool => fair)
    (i := false) (j := true) (by decide)
  exact duplicated_ne_independent (hcomp.trans (hp.trans hpair))

end

end LeanInfoTheory.Examples.FiniteProduct
