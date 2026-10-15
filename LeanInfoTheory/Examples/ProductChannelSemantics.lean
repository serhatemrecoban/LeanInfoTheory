/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.ProductChannel
import LeanInfoTheory.Shannon.SemanticBridge.FiniteProduct
import LeanInfoTheory.Shannon.SemanticBridge.Markov

/-!
# Product-channel semantic consumers

These private consumers connect fixed product rows and independent coordinate
pairs to the existing finite-family predicates. Binary output processing agrees
exactly with the retained `indepProd` expression, including correlated inputs.

Conditional reconstruction recovers a supplied row only on the input support.
Two distinct product channels below induce the same joint after changing a row
at an absent coordinate value. The total conditional channel keeps its existing
output-marginal fallback there, without assigning it conditional meaning.
-/

namespace LeanInfoTheory.Examples.ProductChannelSemantics

noncomputable section

universe u v w t

open scoped BigOperators ENNReal
open LeanInfoTheory.Shannon

/-! ## Existing finite-family semantics on fixed rows -/

private theorem selected_row_marginal
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (W : ∀ i, A i → PMF (B i)) (x : ∀ i, A i) (s : Finset I) :
    familyMarginal (PMF.productChannel W x) s =
      PMF.productChannel (fun i : s => W i.1) (fun i => x i.1) :=
  familyMarginal_finiteProduct (fun i => W i (x i)) s

private theorem selected_row_independence
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (W : ∀ i, A i → PMF (B i)) (x : ∀ i, A i) (s : Finset I) :
    IsMutuallyIndependentFamily (PMF.productChannel W x) s :=
  isMutuallyIndependentFamily_finiteProduct (fun i => W i (x i)) s

private theorem half_mass_add :
    ENNReal.ofReal (1 / 2 : ℝ) + ENNReal.ofReal (1 / 2 : ℝ) = 1 := by
  rw [← ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1 / 2)
    (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  norm_num

private def fair : PMF Bool :=
  PMF.ofFintype (fun _ => ENNReal.ofReal (1 / 2 : ℝ))
    (by rw [Fintype.sum_bool]; exact half_mass_add)

private def noisyBit (b : Bool) : PMF Bool :=
  if b then PMF.pure true else fair

private def threeChannels : Fin 3 → Bool → PMF Bool :=
  ![noisyBit, (fun _ => PMF.pure false), (fun _ => PMF.pure true)]

private def threeInput : Fin 3 → Bool := fun _ => false

private theorem three_rows_nonidentical :
    threeChannels 0 (threeInput 0) ≠ threeChannels 1 (threeInput 1) ∧
      threeChannels 1 (threeInput 1) ≠ threeChannels 2 (threeInput 2) := by
  constructor
  · intro h
    have hm := congrArg (fun p : PMF Bool => p true) h
    norm_num [threeChannels, threeInput, noisyBit, fair,
      PMF.ofFintype_apply, PMF.pure_apply] at hm
  · intro h
    have hm := congrArg (fun p : PMF Bool => p false) h
    change PMF.pure false false = PMF.pure true false at hm
    norm_num [PMF.pure_apply] at hm

private theorem three_selected_marginal :
    familyMarginal (PMF.productChannel threeChannels threeInput) {0, 2} =
      PMF.productChannel (fun i : ({0, 2} : Finset (Fin 3)) => threeChannels i.1)
        (fun i => threeInput i.1) :=
  selected_row_marginal threeChannels threeInput {0, 2}

private theorem three_selected_independent :
    IsMutuallyIndependentFamily (PMF.productChannel threeChannels threeInput) {0, 2} :=
  selected_row_independence threeChannels threeInput {0, 2}

private theorem three_full_independent :
    IsMutuallyIndependentFamily (PMF.productChannel threeChannels threeInput) Finset.univ :=
  selected_row_independence threeChannels threeInput Finset.univ

private theorem three_full_source_semantics :
    IsMutuallyIndependentFamilyOf (PMF.productChannel threeChannels threeInput)
      (fun i y => y i) Finset.univ := by
  change IsMutuallyIndependentFamily
    ((PMF.productChannel threeChannels threeInput).map id) Finset.univ
  rw [PMF.map_id]
  exact three_full_independent

/-! ## Independent coordinate pairs use the same family predicate -/

private theorem independent_joint_inverse
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (p : ∀ i, PMF (A i)) (W : ∀ i, A i → PMF (B i)) :
    (PMF.channelJoint (PMF.finiteProduct p) (PMF.productChannel W)).map
        (Equiv.arrowProdEquivProdArrow I A B).symm =
      PMF.finiteProduct (fun i => PMF.channelJoint (p i) (W i)) := by
  have h := congrArg
    (fun q : PMF (((i : I) → A i) × ((i : I) → B i)) =>
      q.map (Equiv.arrowProdEquivProdArrow I A B).symm)
    (PMF.finiteProduct_channelJoint_map p W)
  simpa only [PMF.map_comp, Equiv.symm_comp_self, PMF.map_id] using h.symm

private theorem independent_coordinate_pairs
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (p : ∀ i, PMF (A i)) (W : ∀ i, A i → PMF (B i)) (s : Finset I) :
    IsMutuallyIndependentFamily
      ((PMF.channelJoint (PMF.finiteProduct p) (PMF.productChannel W)).map
        (Equiv.arrowProdEquivProdArrow I A B).symm) s := by
  rw [independent_joint_inverse]
  exact isMutuallyIndependentFamily_finiteProduct
    (fun i => PMF.channelJoint (p i) (W i)) s

private def threeInputLaws : Fin 3 → PMF Bool :=
  ![fair, PMF.pure false, PMF.pure true]

private theorem three_coordinate_pairs_independent :
    IsMutuallyIndependentFamily
      ((PMF.channelJoint (PMF.finiteProduct threeInputLaws)
        (PMF.productChannel threeChannels)).map
          (Equiv.arrowProdEquivProdArrow (Fin 3) (fun _ => Bool) (fun _ => Bool)).symm)
      Finset.univ :=
  independent_coordinate_pairs threeInputLaws threeChannels Finset.univ

/-! ## Compatibility with the retained binary processing expression -/

private theorem row_pair_eq_indepProd
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (W : ∀ i, A i → PMF (B i)) (x : ∀ i, A i) {i j : I} (hij : i ≠ j) :
    (PMF.productChannel W x).map (fun y => (y i, y j)) =
      indepProd (W i (x i)) (W j (x j)) :=
  PMF.finiteProduct_map_pair (fun i => W i (x i)) hij

-- The right side is exactly the old independently processed binary law for
-- the actual input-pair marginal. The input law need not be independent.
private theorem binary_processed_law
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i)) {i j : I} (hij : i ≠ j) :
    (q.bind (PMF.productChannel W)).map (fun y => (y i, y j)) =
      (q.map (fun x => (x i, x j))).bind
        (fun ab => indepProd (W i ab.1) (W j ab.2)) := by
  rw [PMF.map_bind, PMF.bind_map]
  apply congrArg (PMF.bind q)
  funext x
  exact row_pair_eq_indepProd W x hij

private theorem three_binary_compatibility :
    ((PMF.finiteProduct threeInputLaws).bind (PMF.productChannel threeChannels)).map
        (fun y => (y 0, y 2)) =
      ((PMF.finiteProduct threeInputLaws).map (fun x => (x 0, x 2))).bind
        (fun ab => indepProd (threeChannels 0 ab.1) (threeChannels 2 ab.2)) :=
  binary_processed_law (PMF.finiteProduct threeInputLaws) threeChannels (by decide)

/-! ## Supported reconstruction and the unchanged null-fiber fallback -/

private theorem supported_channel_row
    {X : Type v} {Y : Type w} [Fintype Y]
    (q : PMF X) (K : X → PMF Y) {x : X} (hx : x ∈ q.support) :
    condFstGivenSndChannel ((PMF.channelJoint q K).map Prod.swap) x = K x := by
  have hm : sndMarginal ((PMF.channelJoint q K).map Prod.swap) = q := by
    rw [sndMarginal_map_swap]
    exact PMF.channelJoint_map_fst q K
  have hs : ((PMF.channelJoint q K).map Prod.swap).map Prod.swap =
      PMF.channelJoint q K := by
    rw [PMF.map_comp]
    change (PMF.channelJoint q K).map id = PMF.channelJoint q K
    exact PMF.map_id _
  have h := channelJoint_condFstGivenSndChannel ((PMF.channelJoint q K).map Prod.swap)
  rw [hm, hs] at h
  exact (PMF.channelJoint_eq_iff_eq_on_support q _ K).mp h x hx

open scoped Classical in
private theorem supported_product_row
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i))
    {x : ∀ i, A i} (hx : x ∈ q.support) :
    condFstGivenSndChannel
      ((PMF.channelJoint q (PMF.productChannel W)).map Prod.swap) x =
        PMF.productChannel W x :=
  supported_channel_row q (PMF.productChannel W) hx

private theorem supported_natural_input
    (q : PMF ℕ) (K : ℕ → PMF Bool) {n : ℕ} (hn : n ∈ q.support) :
    condFstGivenSndChannel ((PMF.channelJoint q K).map Prod.swap) n = K n :=
  supported_channel_row q K hn

-- This is the documented fallback, not a conditional interpretation at x.
private theorem null_channel_fallback
    {X : Type v} {Y : Type w} [Fintype Y]
    (q : PMF X) (K : X → PMF Y) {x : X} (hx : q x = 0) :
    condFstGivenSndChannel ((PMF.channelJoint q K).map Prod.swap) x = q.bind K := by
  have hz : sndMarginal ((PMF.channelJoint q K).map Prod.swap) x = 0 := by
    rw [sndMarginal_map_swap]
    change ((PMF.channelJoint q K).map Prod.fst) x = 0
    rw [PMF.channelJoint_map_fst]
    exact hx
  rw [condFstGivenSndChannel_of_sndMarginal_eq_zero _ hz, fstMarginal_map_swap]
  exact PMF.channelJoint_map_snd q K

/-! ## Two product channels differing only at an absent coordinate value -/

private def zeroWord : Fin 2 → Bool := fun _ => false

private def absentWord : Fin 2 → Bool := ![true, false]

private def nullInput : PMF (Fin 2 → Bool) := PMF.pure zeroWord

private def identityRows (_ : Fin 2) : Bool → PMF Bool :=
  PMF.deterministicChannel id

private def eraseAtZero (i : Fin 2) (b : Bool) : Bool :=
  if i = 0 then false else b

private def changedRows (i : Fin 2) : Bool → PMF Bool :=
  PMF.deterministicChannel (eraseAtZero i)

private def originalProduct : (Fin 2 → Bool) → PMF (Fin 2 → Bool) :=
  PMF.productChannel identityRows

private def changedProduct : (Fin 2 → Bool) → PMF (Fin 2 → Bool) :=
  PMF.productChannel changedRows

private theorem only_absent_coordinate_row_changes (i : Fin 2) (b : Bool)
    (h : i ≠ 0 ∨ b = false) : identityRows i b = changedRows i b := by
  rcases h with hi | hb
  · simp [identityRows, changedRows, eraseAtZero, hi]
  · subst b
    simp [identityRows, changedRows, eraseAtZero]

private theorem changed_coordinate_value_absent :
    true ∉ (nullInput.map (fun x => x 0)).support := by
  simp [nullInput, PMF.pure_map, zeroWord]

private theorem product_channels_agree_on_support :
    ∀ x, x ∈ nullInput.support → originalProduct x = changedProduct x := by
  intro x hx
  have hx0 : x = zeroWord := (PMF.mem_support_pure_iff zeroWord x).mp hx
  subst x
  change PMF.productChannel (fun _ : Fin 2 => PMF.deterministicChannel id) zeroWord =
    PMF.productChannel (fun i => PMF.deterministicChannel (eraseAtZero i)) zeroWord
  rw [PMF.productChannel_deterministicChannel, PMF.productChannel_deterministicChannel]
  simp [zeroWord, eraseAtZero]

private theorem product_joints_equal :
    PMF.channelJoint nullInput originalProduct = PMF.channelJoint nullInput changedProduct :=
  (PMF.channelJoint_eq_iff_eq_on_support nullInput originalProduct changedProduct).mpr
    product_channels_agree_on_support

private theorem product_rows_differ_at_absent_word :
    originalProduct absentWord ≠ changedProduct absentWord := by
  intro h
  have hc := congrArg (fun p : PMF (Fin 2 → Bool) => p.map (fun y => y 0)) h
  change (PMF.productChannel identityRows absentWord).map (fun y => y 0) =
    (PMF.productChannel changedRows absentWord).map (fun y => y 0) at hc
  rw [PMF.productChannel_map_eval, PMF.productChannel_map_eval] at hc
  have hm := congrArg (fun p : PMF Bool => p true) hc
  norm_num [identityRows, changedRows, eraseAtZero, absentWord, PMF.pure_apply] at hm

private theorem product_channels_differ : originalProduct ≠ changedProduct := by
  intro h
  exact product_rows_differ_at_absent_word (congrFun h absentWord)

private theorem absent_word_mass_zero : nullInput absentWord = 0 := by
  have hne : absentWord ≠ zeroWord := by
    intro h
    have h0 := congrArg (fun x : Fin 2 → Bool => x 0) h
    simp [absentWord, zeroWord] at h0
  simp [nullInput, PMF.pure_apply, hne]

private theorem absent_word_uses_fallback :
    condFstGivenSndChannel ((PMF.channelJoint nullInput originalProduct).map Prod.swap)
      absentWord = nullInput.bind originalProduct :=
  null_channel_fallback nullInput originalProduct absent_word_mass_zero

private theorem same_reconstructed_null_row :
    condFstGivenSndChannel ((PMF.channelJoint nullInput originalProduct).map Prod.swap)
      absentWord =
    condFstGivenSndChannel ((PMF.channelJoint nullInput changedProduct).map Prod.swap)
      absentWord :=
  congrArg
    (fun p : PMF ((Fin 2 → Bool) × (Fin 2 → Bool)) =>
      condFstGivenSndChannel (p.map Prod.swap) absentWord)
    product_joints_equal

end

end LeanInfoTheory.Examples.ProductChannelSemantics
