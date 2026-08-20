/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Certificate.FiniteFamily
import LeanInfoTheory.Certificate.Submodularity
import LeanInfoTheory.Shannon.EntropyBounds
import LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence

/-!
# Finite-family information examples

This module exercises finite-family entropy, conditional mutual information,
and mutual independence on homogeneous and dependent-alphabet models. It also
keeps the two certificate trust paths visibly separate:

* `BooleanModel.submodularity_checked` applies a proof-carrying checked
  certificate directly to concrete Shannon entropy;
* `BooleanModel.submodularity_raw` first uses the existing raw-certificate
  validator theorem and then invokes generic validated-certificate soundness.

The variable-name types deliberately have no `Fintype` instances. Only the
coordinate alphabets used by entropy are finite.
-/

namespace LeanInfoTheory
namespace Examples
namespace FiniteFamily

noncomputable section

open scoped BigOperators

/-! ## A homogeneous Boolean family -/

namespace BooleanModel

/-- Names for two source bits and their parity bit. -/
inductive Var where
  | left
  | right
  | parity
  deriving DecidableEq, Repr

/-- A uniform two-bit source. -/
def source : PMF (Bool × Bool) :=
  PMF.uniformOfFintype (Bool × Bool)

/-- The two source coordinates together with their parity. -/
def coordinates : (i : Var) -> Bool × Bool -> Bool
  | .left, x => x.1
  | .right, x => x.2
  | .parity, x => x.1 != x.2

/-- The full law of the Boolean family. -/
def law : PMF ((i : Var) -> Bool) :=
  Shannon.familyLawOf source coordinates

/-- The order used by the mutual-information chain-rule example. -/
def order : List Var :=
  [.left, .right]

/-- The family mutual-information chain rule on the Boolean model. -/
theorem mutualInfo_chain_rule :
    Shannon.familyMutualInfo law order.toFinset {Var.parity} =
      ∑ k : Fin order.length,
        Shannon.familyCondMutualInfo law {order.get k} {Var.parity}
          (order.take k).toFinset := by
  exact Shannon.familyMutualInfo_chain_rule_of_nodup
    law order {Var.parity} (by decide)

/-! ### Conditional mutual information -/

private def repeatedOrder : List Var :=
  [.left, .left, .right]

private def emptyOrder : List Var :=
  []

private example :
    Shannon.familyCondMutualInfo law emptyOrder.toFinset
        {Var.parity} {Var.left} = 0 := by
  rw [Shannon.familyCondMutualInfo_chain_rule]
  simp [emptyOrder]

private example :
    Shannon.familyCondMutualInfo law
        ({Var.left, Var.parity} ∪ {Var.right, Var.parity})
        {Var.parity} {Var.left} =
      Shannon.familyCondMutualInfo law {Var.left, Var.parity}
          {Var.parity} {Var.left} +
        Shannon.familyCondMutualInfo law {Var.right, Var.parity}
          {Var.parity} ({Var.left, Var.parity} ∪ {Var.left}) :=
  Shannon.familyCondMutualInfo_union_chain_rule law
    {Var.left, Var.parity} {Var.right, Var.parity}
    {Var.parity} {Var.left}

private example :
    Shannon.familyCondMutualInfoOf source coordinates
        ((∅ : Finset Var) ∪ {Var.left}) {Var.parity} ∅ =
      Shannon.familyCondMutualInfoOf source coordinates ∅ {Var.parity} ∅ +
        Shannon.familyCondMutualInfoOf source coordinates {Var.left}
          {Var.parity} (∅ ∪ ∅) :=
  Shannon.familyCondMutualInfoOf_union_chain_rule source coordinates
    ∅ {Var.left} {Var.parity} ∅

private example :
    Shannon.familyCondMutualInfo law repeatedOrder.toFinset
        {Var.parity} {Var.left} =
      ∑ k : Fin repeatedOrder.length,
        Shannon.familyCondMutualInfo law {repeatedOrder.get k} {Var.parity}
          ({Var.left} ∪ (repeatedOrder.take k).toFinset) :=
  Shannon.familyCondMutualInfo_chain_rule law repeatedOrder
    {Var.parity} {Var.left}

private example :
    Shannon.familyCondMutualInfoOf source coordinates repeatedOrder.toFinset
        {Var.parity} {Var.left} =
      ∑ k : Fin repeatedOrder.length,
        Shannon.familyCondMutualInfoOf source coordinates
          {repeatedOrder.get k} {Var.parity}
          ({Var.left} ∪ (repeatedOrder.take k).toFinset) :=
  Shannon.familyCondMutualInfoOf_chain_rule source coordinates repeatedOrder
    {Var.parity} {Var.left}

/-! ### Pairwise versus mutual independence -/

private def allAtom : Finset Var :=
  {.left, .right, .parity}

private def bitLaw : PMF Bool :=
  PMF.uniformOfFintype Bool

private theorem source_eq_indepProd :
    source = Shannon.indepProd bitLaw bitLaw := by
  apply PMF.ext
  rintro ⟨a, b⟩
  norm_num [source, bitLaw, Shannon.indepProd_apply,
    PMF.uniformOfFintype_apply]
  rw [← ENNReal.mul_inv (a := 2) (b := 2) (by norm_num) (by norm_num)]
  norm_num

private theorem source_independent : Shannon.IsIndependent source := by
  rw [source_eq_indepProd]
  exact Shannon.isIndependent_indepProd bitLaw bitLaw

private def leftParityEquiv : Bool × Bool ≃ Bool × Bool where
  toFun x := (x.1, x.1 != x.2)
  invFun x := (x.1, x.1 != x.2)
  left_inv x := by
    rcases x with ⟨a, b⟩
    cases a <;> cases b <;> rfl
  right_inv x := by
    rcases x with ⟨a, b⟩
    cases a <;> cases b <;> rfl

private def rightParityEquiv : Bool × Bool ≃ Bool × Bool where
  toFun x := (x.2, x.1 != x.2)
  invFun x := (x.2 != x.1, x.1)
  left_inv x := by
    rcases x with ⟨a, b⟩
    cases a <;> cases b <;> rfl
  right_inv x := by
    rcases x with ⟨a, b⟩
    cases a <;> cases b <;> rfl

private theorem source_map_equiv (e : Bool × Bool ≃ Bool × Bool) :
    source.map e = source := by
  apply PMF.ext
  intro x
  calc
    source.map e x = source (e.symm x) := by
      simpa using PMF.map_apply_equiv source e (e.symm x)
    _ = source x := by
      simp [source, PMF.uniformOfFintype_apply]

private theorem left_right_independent :
    Shannon.IsIndependentOf source (coordinates .left) (coordinates .right) := by
  unfold Shannon.IsIndependentOf
  have hmap :
      source.map (fun x => (coordinates .left x, coordinates .right x)) =
        source := by
    simpa [coordinates] using PMF.map_id source
  rw [hmap]
  exact source_independent

private theorem left_parity_independent :
    Shannon.IsIndependentOf source
      (coordinates .left) (coordinates .parity) := by
  unfold Shannon.IsIndependentOf
  change Shannon.IsIndependent (source.map leftParityEquiv)
  rw [source_map_equiv]
  exact source_independent

private theorem right_parity_independent :
    Shannon.IsIndependentOf source
      (coordinates .right) (coordinates .parity) := by
  unfold Shannon.IsIndependentOf
  change Shannon.IsIndependent (source.map rightParityEquiv)
  rw [source_map_equiv]
  exact source_independent

private example :
    Shannon.IsMutuallyIndependentFamilyOf source coordinates {.left, .right} :=
  (Shannon.isMutuallyIndependentFamilyOf_pair_iff_isIndependentOf
    source coordinates (by decide)).2 left_right_independent

private example :
    Shannon.IsMutuallyIndependentFamilyOf source coordinates {.left, .parity} :=
  (Shannon.isMutuallyIndependentFamilyOf_pair_iff_isIndependentOf
    source coordinates (by decide)).2 left_parity_independent

private example :
    Shannon.IsMutuallyIndependentFamilyOf source coordinates {.right, .parity} :=
  (Shannon.isMutuallyIndependentFamilyOf_pair_iff_isIndependentOf
    source coordinates (by decide)).2 right_parity_independent

private theorem coordinateLaw (i : Var) :
    source.map (coordinates i) = bitLaw := by
  cases i with
  | left =>
      change Shannon.fstMarginal source = bitLaw
      rw [source_eq_indepProd]
      exact Shannon.fstMarginal_indepProd bitLaw bitLaw
  | right =>
      change Shannon.sndMarginal source = bitLaw
      rw [source_eq_indepProd]
      exact Shannon.sndMarginal_indepProd bitLaw bitLaw
  | parity =>
      change source.map (fun x => x.1 != x.2) = bitLaw
      rw [show (fun x : Bool × Bool => x.1 != x.2) =
        Prod.snd ∘ leftParityEquiv by rfl, ← PMF.map_comp]
      rw [source_map_equiv]
      change Shannon.sndMarginal source = bitLaw
      rw [source_eq_indepProd]
      exact Shannon.sndMarginal_indepProd bitLaw bitLaw

private def toOutcome (x : Bool × Bool) :
    Shannon.FamilyOutcome (fun _ : Var => Bool) allAtom :=
  fun i => coordinates i x

private theorem toOutcome_injective : Function.Injective toOutcome := by
  intro x y hxy
  apply Prod.ext
  · have h := congrFun hxy
        (⟨Var.left, by simp [allAtom]⟩ : allAtom)
    exact h
  · have h := congrFun hxy
        (⟨Var.right, by simp [allAtom]⟩ : allAtom)
    exact h

private def allFalse :
    Shannon.FamilyOutcome (fun _ : Var => Bool) allAtom :=
  fun _ => false

private theorem allFalse_eq :
    allFalse = toOutcome (false, false) := by
  funext i
  rcases i with ⟨i, hi⟩
  cases i <;> rfl

private theorem factorAllFalse :
    (∏ i : allAtom,
        (Shannon.familyLawOf source coordinates).map
          (fun y => y i) (allFalse i)) =
      bitLaw false * (bitLaw false * bitLaw false) := by
  have hcoord (i : Var) :
      (Shannon.familyLawOf source coordinates).map (fun y => y i) =
        bitLaw := by
    rw [Shannon.familyLawOf, PMF.map_comp]
    exact coordinateLaw i
  let f : Var → ENNReal := fun i =>
    if hi : i ∈ allAtom then bitLaw (allFalse ⟨i, hi⟩) else 1
  calc
    (∏ i : allAtom,
        (Shannon.familyLawOf source coordinates).map
          (fun y => y i) (allFalse i)) =
        ∏ i : allAtom, f i := by
      apply Fintype.prod_congr
      intro i
      rw [hcoord i]
      simp only [f, dif_pos i.property]
    _ = ∏ i ∈ allAtom, f i := Finset.prod_coe_sort allAtom f
    _ = bitLaw false * (bitLaw false * bitLaw false) := by
      simp [allAtom, f, allFalse]

private example :
    ¬ Shannon.IsMutuallyIndependentFamilyOf source coordinates allAtom := by
  intro h
  have hfactor := h allFalse
  rw [Shannon.familyMarginal_familyLawOf] at hfactor
  change source.map toOutcome allFalse = _ at hfactor
  have hleft : source.map toOutcome allFalse = source (false, false) := by
    rw [allFalse_eq]
    exact PMF.map_apply_of_injective
      source toOutcome_injective (false, false)
  rw [hleft, factorAllFalse] at hfactor
  have hreal := congrArg ENNReal.toReal hfactor
  norm_num [source, bitLaw, PMF.uniformOfFintype_apply] at hreal

/-! ### Certificate consumers -/

/-- The first atom in the overlapping submodularity example. -/
def leftAtom : Finset Var :=
  {Var.left, Var.parity}

/-- The second atom in the overlapping submodularity example. -/
def rightAtom : Finset Var :=
  {Var.right, Var.parity}

/--
The checked submodularity certificate is sound for the concrete Boolean-family
entropy valuation.
-/
theorem submodularity_checked :
    0 <= EntropyExpr.eval (Shannon.familyEntropy law)
      (Certificate.Submodularity.checkedCert leftAtom rightAtom).target := by
  exact Certificate.CheckedCert.sound_finiteFamily
    (Certificate.Submodularity.checkedCert leftAtom rightAtom) law

/--
The raw submodularity certificate proves the same concrete Shannon inequality
only after the existing validator has accepted its primitive tag and exact
decomposition.
-/
theorem submodularity_raw :
    0 <= EntropyExpr.eval (Shannon.familyEntropy law)
      (Certificate.Submodularity.rawCert leftAtom rightAtom).target := by
  simpa only [Shannon.finiteFamilyEntropyVal_eval] using
    Certificate.RawCert.sound_of_toCheckedCert?_isSome
      (Certificate.Submodularity.rawCert_toCheckedCert?_isSome
        (a := leftAtom) (b := rightAtom))
      (Shannon.finiteFamilyEntropyVal law)

end BooleanModel

/-! ## A family with dependent alphabets -/

namespace HeterogeneousModel

/-- Names for a Boolean coordinate and a ternary coordinate. -/
inductive Var where
  | bit
  | trit
  deriving DecidableEq, Repr

/-- The coordinate alphabet, which depends on the variable name. -/
def Alphabet : Var -> Type
  | .bit => Bool
  | .trit => Fin 3

private instance alphabetFintype (i : Var) : Fintype (Alphabet i) := by
  cases i with
  | bit =>
      change Fintype Bool
      infer_instance
  | trit =>
      change Fintype (Fin 3)
      infer_instance

/-- A uniform source carrying one Boolean and one ternary coordinate. -/
def source : PMF (Bool × Fin 3) :=
  PMF.uniformOfFintype (Bool × Fin 3)

/-- The dependent family of source coordinates. -/
def coordinates : (i : Var) -> Bool × Fin 3 -> Alphabet i
  | .bit, x => x.1
  | .trit, x => x.2

/-- The full law of the heterogeneous family. -/
def law : PMF ((i : Var) -> Alphabet i) :=
  Shannon.familyLawOf source coordinates

/-- The textbook order of the two heterogeneous coordinates. -/
def order : List Var :=
  [.bit, .trit]

/-- The source-family entropy chain rule for dependent coordinate alphabets. -/
theorem entropy_chain_rule :
    Shannon.familyEntropyOf source coordinates order.toFinset =
      ∑ k : Fin order.length,
        Shannon.familyCondEntropyOf source coordinates {order.get k}
          (order.take k).toFinset := by
  exact Shannon.familyEntropyOf_chain_rule_of_nodup
    source coordinates order (by decide)

/-- The empty heterogeneous subfamily has zero entropy. -/
theorem empty_entropy :
    Shannon.familyEntropyOf source coordinates ∅ = 0 :=
  Shannon.familyEntropyOf_empty source coordinates

/-! ### Mutual independence -/

private def bitLaw : PMF Bool :=
  PMF.uniformOfFintype Bool

private def tritLaw : PMF (Fin 3) :=
  PMF.uniformOfFintype (Fin 3)

private theorem source_eq_indepProd :
    source = Shannon.indepProd bitLaw tritLaw := by
  apply PMF.ext
  rintro ⟨a, b⟩
  simp only [source, bitLaw, tritLaw, PMF.uniformOfFintype_apply,
    Shannon.indepProd_apply]
  norm_num [Fintype.card_prod]
  rw [← ENNReal.mul_inv (a := 2) (b := 3) (by norm_num) (by norm_num)]
  norm_num

private theorem source_independent : Shannon.IsIndependent source := by
  rw [source_eq_indepProd]
  exact Shannon.isIndependent_indepProd bitLaw tritLaw

private theorem coordinatePairIndependent :
    Shannon.IsIndependentOf source (coordinates .bit) (coordinates .trit) := by
  unfold Shannon.IsIndependentOf
  have hmap :
      source.map (fun x => (coordinates .bit x, coordinates .trit x)) =
        source := by
    simpa [coordinates] using PMF.map_id source
  rw [hmap]
  exact source_independent

private example :
    Shannon.IsMutuallyIndependentFamilyOf source coordinates {.bit, .trit} :=
  (Shannon.isMutuallyIndependentFamilyOf_pair_iff_isIndependentOf
    source coordinates (by decide)).2 coordinatePairIndependent

private example : Shannon.IsMutuallyIndependentFamily law ∅ :=
  Shannon.isMutuallyIndependentFamily_empty law

private example : Shannon.IsMutuallyIndependentFamily law {.trit} :=
  Shannon.isMutuallyIndependentFamily_singleton law .trit

end HeterogeneousModel

/-! ## A nondegenerate independent three-bit family -/

namespace ProductModel

private inductive Var where
  | first
  | second
  | third
  deriving DecidableEq

private def bitLaw : PMF Bool :=
  PMF.uniformOfFintype Bool

private def source : PMF (Bool × (Bool × Bool)) :=
  Shannon.indepProd bitLaw (Shannon.indepProd bitLaw bitLaw)

private def coordinates : Var → Bool × (Bool × Bool) → Bool
  | .first, x => x.1
  | .second, x => x.2.1
  | .third, x => x.2.2

private def law : PMF (Var → Bool) :=
  Shannon.familyLawOf source coordinates

private def fullAtom : Finset Var :=
  {.first, .second, .third}

private def toOutcome (x : Bool × (Bool × Bool)) :
    Shannon.FamilyOutcome (fun _ : Var => Bool) fullAtom :=
  fun i => coordinates i x

private def fromOutcome
    (x : Shannon.FamilyOutcome (fun _ : Var => Bool) fullAtom) :
    Bool × (Bool × Bool) :=
  (x ⟨.first, by simp [fullAtom]⟩,
    x ⟨.second, by simp [fullAtom]⟩,
    x ⟨.third, by simp [fullAtom]⟩)

private theorem toOutcome_fromOutcome
    (x : Shannon.FamilyOutcome (fun _ : Var => Bool) fullAtom) :
    toOutcome (fromOutcome x) = x := by
  funext i
  rcases i with ⟨i, hi⟩
  cases i <;> rfl

private theorem toOutcome_injective : Function.Injective toOutcome := by
  intro x y hxy
  have h := congrArg fromOutcome hxy
  simpa [fromOutcome, toOutcome, coordinates] using h

private theorem coordinateLaw (i : Var) :
    source.map (coordinates i) = bitLaw := by
  cases i with
  | first =>
      change Shannon.fstMarginal source = bitLaw
      simp [source]
  | second =>
      change source.map (fun x => x.2.1) = bitLaw
      rw [show (fun x : Bool × (Bool × Bool) => x.2.1) =
        Prod.fst ∘ Prod.snd by rfl, ← PMF.map_comp]
      change (Shannon.sndMarginal source).map Prod.fst = bitLaw
      rw [show Shannon.sndMarginal source =
        Shannon.indepProd bitLaw bitLaw by simp [source]]
      change Shannon.fstMarginal
        (Shannon.indepProd bitLaw bitLaw) = bitLaw
      exact Shannon.fstMarginal_indepProd bitLaw bitLaw
  | third =>
      change source.map (fun x => x.2.2) = bitLaw
      rw [show (fun x : Bool × (Bool × Bool) => x.2.2) =
        Prod.snd ∘ Prod.snd by rfl, ← PMF.map_comp]
      change (Shannon.sndMarginal source).map Prod.snd = bitLaw
      rw [show Shannon.sndMarginal source =
        Shannon.indepProd bitLaw bitLaw by simp [source]]
      change Shannon.sndMarginal
        (Shannon.indepProd bitLaw bitLaw) = bitLaw
      exact Shannon.sndMarginal_indepProd bitLaw bitLaw

private theorem productFactor
    (x : Shannon.FamilyOutcome (fun _ : Var => Bool) fullAtom) :
    (∏ i : fullAtom,
        law.map (fun y => y i) (x i)) =
      bitLaw (x ⟨.first, by simp [fullAtom]⟩) *
        (bitLaw (x ⟨.second, by simp [fullAtom]⟩) *
          bitLaw (x ⟨.third, by simp [fullAtom]⟩)) := by
  have hcoord (i : Var) : law.map (fun y => y i) = bitLaw := by
    rw [law, Shannon.familyLawOf, PMF.map_comp]
    exact coordinateLaw i
  let f : Var → ENNReal := fun i =>
    if hi : i ∈ fullAtom then bitLaw (x ⟨i, hi⟩) else 1
  calc
    (∏ i : fullAtom, law.map (fun y => y i) (x i)) =
        ∏ i : fullAtom, f i := by
      apply Fintype.prod_congr
      intro i
      rw [hcoord i]
      simp only [f, dif_pos i.property]
    _ = ∏ i ∈ fullAtom, f i := Finset.prod_coe_sort fullAtom f
    _ = bitLaw (x ⟨.first, by simp [fullAtom]⟩) *
        (bitLaw (x ⟨.second, by simp [fullAtom]⟩) *
          bitLaw (x ⟨.third, by simp [fullAtom]⟩)) := by
      simp [fullAtom, f]

private theorem mutuallyIndependentOf :
    Shannon.IsMutuallyIndependentFamilyOf source coordinates fullAtom := by
  intro x
  rw [Shannon.familyMarginal_familyLawOf]
  change source.map toOutcome x = _
  calc
    source.map toOutcome x = source (fromOutcome x) := by
      rw [← toOutcome_fromOutcome x]
      exact PMF.map_apply_of_injective
        source toOutcome_injective (fromOutcome x)
    _ = bitLaw (x ⟨.first, by simp [fullAtom]⟩) *
        (bitLaw (x ⟨.second, by simp [fullAtom]⟩) *
          bitLaw (x ⟨.third, by simp [fullAtom]⟩)) := by
      simp [source, fromOutcome, Shannon.indepProd_apply]
    _ = ∏ i : fullAtom, law.map (fun y => y i) (x i) :=
      (productFactor x).symm

private theorem mutuallyIndependent :
    Shannon.IsMutuallyIndependentFamily law fullAtom :=
  mutuallyIndependentOf

private example :
    Shannon.IsMutuallyIndependentFamily law {.first, .second} :=
  Shannon.isMutuallyIndependentFamily_mono law mutuallyIndependent (by
    simp [fullAtom])

private theorem singletonEntropyPos (i : Var) :
    0 < Shannon.familyEntropyOf source coordinates {i} := by
  rw [Shannon.familyEntropyOf_singleton, Shannon.entropyOf, coordinateLaw,
    show bitLaw = PMF.uniformOfFintype Bool by rfl,
    Shannon.entropy_uniformOfFintype]
  exact Real.log_pos (by norm_num)

private theorem entropyEq :
    Shannon.familyEntropy law fullAtom =
      ∑ i ∈ fullAtom, Shannon.familyEntropy law {i} :=
  (Shannon.familyEntropy_eq_sum_singletons_iff_isMutuallyIndependentFamily
    law fullAtom).2 mutuallyIndependent

private example : Shannon.IsMutuallyIndependentFamily law fullAtom :=
  (Shannon.familyEntropy_eq_sum_singletons_iff_isMutuallyIndependentFamily
    law fullAtom).1 entropyEq

private theorem entropyOfEq :
    Shannon.familyEntropyOf source coordinates fullAtom =
      ∑ i ∈ fullAtom, Shannon.familyEntropyOf source coordinates {i} :=
  (Shannon.familyEntropyOf_eq_sum_singletons_iff_isMutuallyIndependentFamilyOf
    source coordinates fullAtom).2 mutuallyIndependentOf

private example :
    Shannon.IsMutuallyIndependentFamilyOf source coordinates fullAtom :=
  (Shannon.familyEntropyOf_eq_sum_singletons_iff_isMutuallyIndependentFamilyOf
    source coordinates fullAtom).1 entropyOfEq

private example (i : Var) :
    0 < Shannon.familyEntropyOf source coordinates {i} :=
  singletonEntropyPos i

end ProductModel

/-! ## Private law-facing pair compatibility -/

private example
    {Var : Type} {alpha : Var → Type} [DecidableEq Var]
    (q : PMF ((i : Var) → alpha i)) {i j : Var} (hij : i ≠ j) :
    Shannon.IsMutuallyIndependentFamily q {i, j} ↔
      Shannon.IsIndependent (q.map fun y => (y i, y j)) := by
  have hid : Shannon.familyLawOf q (fun i y => y i) = q := by
    rw [Shannon.familyLawOf]
    simpa using PMF.map_id q
  have h := Shannon.isMutuallyIndependentFamilyOf_pair_iff_isIndependentOf
    q (fun i y => y i) hij
  rw [Shannon.IsMutuallyIndependentFamilyOf, hid,
    Shannon.IsIndependentOf] at h
  exact h

end

end FiniteFamily
end Examples
end LeanInfoTheory
