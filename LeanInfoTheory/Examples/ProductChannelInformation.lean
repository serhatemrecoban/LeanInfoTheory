/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.ProductChannel
import LeanInfoTheory.Shannon.SemanticBridge.Markov

/-!
# Conditional information for product channels

Private consumers use actual coordinate projections for a correlated diagonal
input through noisy rows. The output-given-input orientation is explicit, and
its block conditional entropy is positive.

A separate two-point input law omits one coordinate value. Changing the channel
at that value changes an unsupported row but preserves the joint law and its
information quantities. Supported reconstruction recovers the supplied rows;
the existing total conditional channel instead uses its output-marginal
fallback on a null word, where that fallback differs from the supplied row.

Further consumers distinguish the strict bound for a correlated identity
channel from equality for constant outputs. Heterogeneous independent inputs
and iid blocks exercise exact additivity. A noninjective encoding of independent
source bits produces the correlated input law used by the general bound, while
coordinate objective caps give a finite-block cap without capacity definitions.
Three parity-related outputs are pairwise independent but have a positive
entropy and information gap, so they fail the full mutual-independence criterion.
-/

namespace LeanInfoTheory.Examples.ProductChannelInformation

noncomputable section

universe u v w

open scoped BigOperators ENNReal
open LeanInfoTheory.Shannon

/-! ## Actual coordinate joints, with separate alphabet universes -/

open Classical in
private theorem conditional_entropy_projected_joints
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i)) :
    condEntropy ((PMF.channelJoint q (PMF.productChannel W)).map Prod.swap) =
      ∑ i, condEntropy
        (((PMF.channelJoint q (PMF.productChannel W)).map
          (fun xy => (xy.1 i, xy.2 i))).map Prod.swap) := by
  rw [condEntropy_channelJoint_productChannel]
  apply Finset.sum_congr rfl
  intro i _
  rw [PMF.channelJoint_productChannel_map_eval]

/-! ## A correlated fair diagonal through noisy coordinate rows -/

private def fair : PMF Bool := PMF.uniformOfFintype Bool

private theorem fair_mass (b : Bool) : fair b = ENNReal.ofReal (1 / 2 : ℝ) := by
  norm_num [fair, PMF.uniformOfFintype_apply, ENNReal.ofReal_div_of_pos]

private theorem fair_real_mass (b : Bool) : (fair b).toReal = (1 / 2 : ℝ) := by
  rw [fair_mass]
  norm_num

private theorem fair_entropy : entropy fair = Real.log 2 := by
  rw [entropy_eq_sum, Fintype.sum_bool]
  simp only [fair_real_mass, Real.negMulLog]
  rw [show (1 / 2 : ℝ) = (2 : ℝ)⁻¹ by norm_num, Real.log_inv]
  ring

private def noisyBit (b : Bool) : PMF Bool :=
  if b then PMF.pure true else fair

private theorem noisy_row_has_two_outputs :
    false ∈ (noisyBit false).support ∧ true ∈ (noisyBit false).support := by
  constructor <;> simp [noisyBit, fair]

private def diagonal : PMF (Fin 2 → Bool) := fair.map (fun b _ => b)

private theorem diagonal_eval (i : Fin 2) : diagonal.map (fun x => x i) = fair := by
  rw [diagonal, PMF.map_comp]
  exact PMF.map_id _

private theorem diagonal_off_atom : diagonal (![false, true]) = 0 := by
  apply PMF.map_apply_eq_zero_of_notMem_range fair
  rintro ⟨b, h⟩
  have h0 : b = false := congrFun h 0
  have h1 : b = true := congrFun h 1
  cases h0.symm.trans h1

private theorem diagonal_not_product :
    diagonal ≠ PMF.finiteProduct (fun i : Fin 2 => diagonal.map (fun x => x i)) := by
  intro h
  have hm := congrArg (fun p : PMF (Fin 2 → Bool) => p (![false, true])) h
  rw [diagonal_off_atom, PMF.finiteProduct_apply, Fin.prod_univ_two] at hm
  simp only [diagonal_eval, fair_mass] at hm
  norm_num [← ENNReal.ofReal_mul] at hm

private def noisyRows (_ : Fin 2) : Bool → PMF Bool := noisyBit

private def diagonalJoint : PMF ((Fin 2 → Bool) × (Fin 2 → Bool)) :=
  PMF.channelJoint diagonal (PMF.productChannel noisyRows)

private theorem diagonal_joint_coordinate (i : Fin 2) :
    diagonalJoint.map (fun xy => (xy.1 i, xy.2 i)) =
      PMF.channelJoint fair noisyBit := by
  simpa only [diagonalJoint, noisyRows, diagonal_eval] using
    PMF.channelJoint_productChannel_map_eval diagonal noisyRows i

private theorem diagonal_conditional_entropy_actual_projections :
    condEntropy (diagonalJoint.map Prod.swap) =
      ∑ i : Fin 2, condEntropy
        ((diagonalJoint.map (fun xy => (xy.1 i, xy.2 i))).map Prod.swap) := by
  convert! conditional_entropy_projected_joints diagonal noisyRows

private theorem noisy_coordinate_conditional_entropy :
    condEntropy ((PMF.channelJoint fair noisyBit).map Prod.swap) =
      (1 / 2 : ℝ) * Real.log 2 := by
  have hc := mutualInfo_eq_entropy_sndMarginal_sub_condEntropy_swap
    (PMF.channelJoint fair noisyBit)
  change mutualInfo (PMF.channelJoint fair noisyBit) =
    entropy ((PMF.channelJoint fair noisyBit).map Prod.snd) -
      condEntropy ((PMF.channelJoint fair noisyBit).map Prod.swap) at hc
  rw [PMF.channelJoint_map_snd] at hc
  have hm := mutualInfo_channelJoint_eq_entropy_bind_sub_sum fair noisyBit
  rw [Fintype.sum_bool] at hm
  norm_num [noisyBit, fair_real_mass, fair_entropy] at hm
  linarith

private theorem diagonal_conditional_entropy :
    condEntropy (diagonalJoint.map Prod.swap) = Real.log 2 := by
  rw [diagonal_conditional_entropy_actual_projections]
  simp only [diagonal_joint_coordinate, noisy_coordinate_conditional_entropy,
    Fin.sum_univ_two]
  ring

private theorem diagonal_conditional_entropy_positive :
    0 < condEntropy (diagonalJoint.map Prod.swap) := by
  rw [diagonal_conditional_entropy]
  exact Real.log_pos (by norm_num)

/-! ## A nontrivial sparse input and an absent coordinate value -/

private def sparseWord (b : Bool) : Fin 2 → Bool := ![false, b]

private def sparseInput : PMF (Fin 2 → Bool) := fair.map sparseWord

private theorem sparse_supported_words (b : Bool) : sparseWord b ∈ sparseInput.support := by
  apply (PMF.mem_support_map_iff _ _ _).2
  exact ⟨b, PMF.mem_support_uniformOfFintype b, rfl⟩

private theorem sparse_words_distinct : sparseWord false ≠ sparseWord true := by
  intro h
  have h1 := congrFun h 1
  simp [sparseWord] at h1

private theorem sparse_eval_zero : sparseInput.map (fun x => x 0) = PMF.pure false := by
  rw [sparseInput, PMF.map_comp]
  exact PMF.map_const _ _

private theorem sparse_eval_one : sparseInput.map (fun x => x 1) = fair := by
  rw [sparseInput, PMF.map_comp]
  exact PMF.map_id _

private theorem changed_coordinate_value_absent :
    true ∉ (sparseInput.map (fun x => x 0)).support := by
  rw [sparse_eval_zero]
  simp

private def changedRows (i : Fin 2) (b : Bool) : PMF Bool :=
  if i = 0 ∧ b = true then PMF.pure false else noisyBit b

private theorem coordinate_rows_agree_on_support (i : Fin 2) (b : Bool)
    (hb : b ∈ (sparseInput.map (fun x => x i)).support) :
    noisyRows i b = changedRows i b := by
  by_cases hi : i = 0
  · subst i
    rw [sparse_eval_zero] at hb
    have hb0 := (PMF.mem_support_pure_iff false b).mp hb
    subst b
    simp [noisyRows, changedRows]
  · simp [noisyRows, changedRows, hi]

private theorem sparse_product_rows_agree (x : Fin 2 → Bool) (hx : x ∈ sparseInput.support) :
    PMF.productChannel noisyRows x = PMF.productChannel changedRows x := by
  unfold PMF.productChannel
  congr 1
  funext i
  apply coordinate_rows_agree_on_support
  exact (PMF.mem_support_map_iff _ _ _).2 ⟨x, hx, rfl⟩

private def sparseJoint : PMF ((Fin 2 → Bool) × (Fin 2 → Bool)) :=
  PMF.channelJoint sparseInput (PMF.productChannel noisyRows)

private def changedJoint : PMF ((Fin 2 → Bool) × (Fin 2 → Bool)) :=
  PMF.channelJoint sparseInput (PMF.productChannel changedRows)

private theorem sparse_joints_equal : sparseJoint = changedJoint :=
  (PMF.channelJoint_eq_iff_eq_on_support sparseInput
    (PMF.productChannel noisyRows) (PMF.productChannel changedRows)).mpr
      sparse_product_rows_agree

private theorem sparse_coordinate_joints_equal (i : Fin 2) :
    PMF.channelJoint (sparseInput.map (fun x => x i)) (noisyRows i) =
      PMF.channelJoint (sparseInput.map (fun x => x i)) (changedRows i) :=
  (PMF.channelJoint_eq_iff_eq_on_support _ _ _).mpr
    (coordinate_rows_agree_on_support i)

private theorem sparse_information_unchanged :
    entropy sparseJoint = entropy changedJoint ∧
      entropy (sndMarginal sparseJoint) = entropy (sndMarginal changedJoint) ∧
      condEntropy (sparseJoint.map Prod.swap) = condEntropy (changedJoint.map Prod.swap) ∧
      mutualInfo sparseJoint = mutualInfo changedJoint := by
  rw [sparse_joints_equal]
  exact ⟨rfl, rfl, rfl, rfl⟩

private theorem sparse_conditional_entropy :
    condEntropy (sparseJoint.map Prod.swap) =
      condEntropy ((PMF.channelJoint (PMF.pure false) noisyBit).map Prod.swap) +
        condEntropy ((PMF.channelJoint fair noisyBit).map Prod.swap) := by
  have h := condEntropy_channelJoint_productChannel sparseInput noisyRows
  simp only [Fin.sum_univ_two, sparse_eval_zero, sparse_eval_one, noisyRows] at h
  convert! h

/-! ## Supported recovery and the existing total-channel fallback -/

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

private theorem sparse_supported_recovery (b : Bool) :
    condFstGivenSndChannel (sparseJoint.map Prod.swap) (sparseWord b) =
      PMF.productChannel noisyRows (sparseWord b) :=
  supported_channel_row sparseInput (PMF.productChannel noisyRows) (sparse_supported_words b)

private def absentWord : Fin 2 → Bool := ![true, false]

private theorem absent_word_mass_zero : sparseInput absentWord = 0 := by
  apply PMF.map_apply_eq_zero_of_notMem_range fair
  rintro ⟨b, h⟩
  have h0 := congrFun h 0
  simp [sparseWord, absentWord] at h0

private theorem supplied_rows_differ_at_absent_word :
    PMF.productChannel noisyRows absentWord ≠ PMF.productChannel changedRows absentWord := by
  intro h
  have hc := congrArg (fun p : PMF (Fin 2 → Bool) => p.map (fun y => y 0)) h
  rw [PMF.productChannel_map_eval, PMF.productChannel_map_eval] at hc
  have hm := congrArg (fun p : PMF Bool => p true) hc
  norm_num [noisyRows, noisyBit, changedRows, absentWord, PMF.pure_apply] at hm

private theorem absent_word_uses_fallback :
    condFstGivenSndChannel (sparseJoint.map Prod.swap) absentWord =
      sparseInput.bind (PMF.productChannel noisyRows) := by
  have hz : sndMarginal (sparseJoint.map Prod.swap) absentWord = 0 := by
    rw [sndMarginal_map_swap]
    change ((PMF.channelJoint sparseInput (PMF.productChannel noisyRows)).map Prod.fst)
      absentWord = 0
    rw [PMF.channelJoint_map_fst]
    exact absent_word_mass_zero
  rw [condFstGivenSndChannel_of_sndMarginal_eq_zero _ hz, fstMarginal_map_swap]
  exact PMF.channelJoint_map_snd sparseInput (PMF.productChannel noisyRows)

private theorem sparse_output_eval_zero :
    (sparseInput.bind (PMF.productChannel noisyRows)).map (fun y => y 0) = fair := by
  rw [PMF.map_bind]
  simp only [PMF.productChannel_map_eval]
  rw [sparseInput, PMF.bind_map]
  change (fair.bind fun _ => fair) = fair
  exact PMF.bind_const _ _

private theorem null_fallback_does_not_recover_supplied_row :
    condFstGivenSndChannel (sparseJoint.map Prod.swap) absentWord ≠
      PMF.productChannel noisyRows absentWord := by
  rw [absent_word_uses_fallback]
  intro h
  have hc := congrArg (fun p : PMF (Fin 2 → Bool) => p.map (fun y => y 0)) h
  rw [sparse_output_eval_zero, PMF.productChannel_map_eval] at hc
  have hm := congrArg (fun p : PMF Bool => p false) hc
  norm_num [noisyRows, noisyBit, absentWord, fair_mass, PMF.pure_apply] at hm

private theorem reconstructed_null_row_unchanged :
    condFstGivenSndChannel (sparseJoint.map Prod.swap) absentWord =
      condFstGivenSndChannel (changedJoint.map Prod.swap) absentWord := by
  rw [sparse_joints_equal]

/-! ## Empty and singleton coordinate families -/

private theorem empty_conditional_entropy
    (q : PMF (Empty → Bool)) (W : Empty → Bool → PMF Bool) :
    condEntropy ((PMF.channelJoint q (PMF.productChannel W)).map Prod.swap) = 0 := by
  have h := condEntropy_channelJoint_productChannel q W
  simp only [Finset.univ_eq_empty, Finset.sum_empty] at h
  convert! h

private theorem singleton_conditional_entropy
    (q : PMF (Fin 1 → Bool)) (W : Bool → PMF Bool) :
    condEntropy ((PMF.channelJoint q (PMF.productChannel (fun _ : Fin 1 => W))).map
      Prod.swap) =
      condEntropy ((PMF.channelJoint (q.map (fun x => x 0)) W).map Prod.swap) := by
  have h := condEntropy_channelJoint_productChannel q (fun _ : Fin 1 => W)
  simp only [Fin.sum_univ_one] at h
  convert! h

/-! ## Arbitrary-input bounds and the output entropy gap -/

private theorem noisy_diagonal_bound :
    mutualInfo diagonalJoint ≤ 2 * mutualInfo (PMF.channelJoint fair noisyBit) := by
  have h := mutualInfo_channelJoint_productChannel_le diagonal noisyRows
  simp only [diagonal_eval, noisyRows, Fin.sum_univ_two] at h
  rw [two_mul]
  convert! h

private theorem noisy_diagonal_gap :
    2 * mutualInfo (PMF.channelJoint fair noisyBit) - mutualInfo diagonalJoint =
      2 * entropy (fair.bind noisyBit) -
        entropy (diagonal.bind (PMF.productChannel noisyRows)) := by
  have h := sum_mutualInfo_sub_mutualInfo_productChannel diagonal noisyRows
  simp only [diagonal_eval, noisyRows, Fin.sum_univ_two] at h
  simp only [two_mul]
  convert! h

private theorem arbitrary_repeated_channel_bound
    {A : Type v} {B : Type w} [Fintype A] [Fintype B]
    (n : ℕ) (q : PMF (Fin n → A)) (W : A → PMF B) :
    mutualInfo (PMF.channelJoint q (PMF.memorylessChannel W n)) ≤
      ∑ i : Fin n, mutualInfo (PMF.channelJoint (q.map (fun x => x i)) W) := by
  convert! mutualInfo_channelJoint_productChannel_le q (fun _ : Fin n => W)

/-! ## Identity processing is strict for the correlated diagonal -/

private theorem identity_channel_mutualInfo
    {A : Type v} [Fintype A] (q : PMF A) :
    mutualInfo (PMF.channelJoint q (PMF.deterministicChannel id)) = entropy q := by
  rw [PMF.channelJoint_deterministicChannel]
  exact mutualInfo_map_diag q

private theorem constant_channel_mutualInfo
    {A : Type v} {B : Type w} [Fintype A] [Fintype B]
    (q : PMF A) (b : B) :
    mutualInfo (PMF.channelJoint q (fun _ => PMF.pure b)) = 0 := by
  rw [mutualInfo_channelJoint_eq_entropy_bind_sub_sum, PMF.bind_const]
  simp only [entropy_pure, mul_zero, Finset.sum_const_zero, sub_zero]

private theorem diagonal_entropy : entropy diagonal = Real.log 2 := by
  rw [diagonal, entropy_map_injective fair (fun _ _ h => congrFun h 0), fair_entropy]

private def identityRows (_ : Fin 2) : Bool → PMF Bool := PMF.deterministicChannel id

private def identityJoint : PMF ((Fin 2 → Bool) × (Fin 2 → Bool)) :=
  PMF.channelJoint diagonal (PMF.productChannel identityRows)

private theorem diagonal_identity_information : mutualInfo identityJoint = Real.log 2 := by
  unfold identityJoint identityRows
  rw [PMF.productChannel_deterministicChannel]
  change mutualInfo (PMF.channelJoint diagonal (PMF.deterministicChannel id)) = Real.log 2
  rw [identity_channel_mutualInfo, diagonal_entropy]

private theorem diagonal_identity_coordinate_sum :
    (∑ i : Fin 2, mutualInfo (PMF.channelJoint (diagonal.map (fun x => x i)) (identityRows i))) =
      2 * Real.log 2 := by
  simp only [diagonal_eval, identityRows, identity_channel_mutualInfo, fair_entropy,
    Fin.sum_univ_two]
  ring

private theorem diagonal_identity_bound_strict :
    mutualInfo identityJoint <
      ∑ i : Fin 2,
        mutualInfo (PMF.channelJoint (diagonal.map (fun x => x i)) (identityRows i)) := by
  rw [diagonal_identity_information, diagonal_identity_coordinate_sum]
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  linarith

private theorem diagonal_identity_gap :
    (∑ i : Fin 2, mutualInfo (PMF.channelJoint (diagonal.map (fun x => x i)) (identityRows i))) -
      mutualInfo identityJoint = Real.log 2 := by
  rw [diagonal_identity_coordinate_sum, diagonal_identity_information]
  ring

/-! ## Correlated inputs can give equality, including singleton outputs -/

private def constantBoolRows (_ : Fin 2) : Bool → PMF Bool :=
  PMF.deterministicChannel (fun _ => false)

private theorem diagonal_constant_bool_information :
    mutualInfo (PMF.channelJoint diagonal (PMF.productChannel constantBoolRows)) = 0 := by
  unfold constantBoolRows
  rw [PMF.productChannel_deterministicChannel]
  exact constant_channel_mutualInfo diagonal (fun _ : Fin 2 => false)

private theorem diagonal_constant_bool_coordinate_information (i : Fin 2) :
    mutualInfo (PMF.channelJoint (diagonal.map (fun x => x i)) (constantBoolRows i)) = 0 := by
  rw [diagonal_eval]
  change mutualInfo (PMF.channelJoint fair (fun _ : Bool => PMF.pure false)) = 0
  exact constant_channel_mutualInfo fair false

private theorem diagonal_constant_bool_equality :
    mutualInfo (PMF.channelJoint diagonal (PMF.productChannel constantBoolRows)) =
      ∑ i : Fin 2,
        mutualInfo (PMF.channelJoint (diagonal.map (fun x => x i)) (constantBoolRows i)) := by
  rw [diagonal_constant_bool_information]
  simp only [diagonal_constant_bool_coordinate_information, Finset.sum_const_zero]

private theorem diagonal_constant_bool_output_independent :
    IsMutuallyIndependentFamily
      (diagonal.bind (PMF.productChannel constantBoolRows)) Finset.univ := by
  apply (mutualInfo_channelJoint_productChannel_eq_sum_iff diagonal constantBoolRows).mp
  convert! diagonal_constant_bool_equality

private def singletonRows (_ : Fin 2) : Bool → PMF Unit :=
  PMF.deterministicChannel (fun _ => ())

private theorem diagonal_singleton_output_information :
    mutualInfo (PMF.channelJoint diagonal (PMF.productChannel singletonRows)) = 0 := by
  unfold singletonRows
  rw [PMF.productChannel_deterministicChannel]
  exact constant_channel_mutualInfo diagonal (fun _ : Fin 2 => ())

private theorem diagonal_singleton_coordinate_information (i : Fin 2) :
    mutualInfo (PMF.channelJoint (diagonal.map (fun x => x i)) (singletonRows i)) = 0 := by
  rw [diagonal_eval]
  change mutualInfo (PMF.channelJoint fair (fun _ : Bool => PMF.pure ())) = 0
  exact constant_channel_mutualInfo fair ()

private theorem diagonal_singleton_output_equality :
    mutualInfo (PMF.channelJoint diagonal (PMF.productChannel singletonRows)) =
      ∑ i : Fin 2,
        mutualInfo (PMF.channelJoint (diagonal.map (fun x => x i)) (singletonRows i)) := by
  rw [diagonal_singleton_output_information]
  simp only [diagonal_singleton_coordinate_information, Finset.sum_const_zero]

/-! ## Heterogeneous independent processing with sparse input -/

private abbrev HeterogeneousInput : Bool → Type
  | false => Bool
  | true => Fin 3

private abbrev HeterogeneousOutput : Bool → Type
  | false => Bool
  | true => Unit

private instance heterogeneousInputFintype (i : Bool) : Fintype (HeterogeneousInput i) := by
  cases i <;> dsimp [HeterogeneousInput] <;> infer_instance

private instance heterogeneousOutputFintype (i : Bool) : Fintype (HeterogeneousOutput i) := by
  cases i <;> dsimp [HeterogeneousOutput] <;> infer_instance

private def heterogeneousSparse : PMF (Fin 3) :=
  PMF.uniformOfFinset ({0, 1} : Finset (Fin 3)) (by simp)

private theorem heterogeneous_sparse_zero : heterogeneousSparse 2 = 0 := by
  simp [heterogeneousSparse, PMF.uniformOfFinset_apply]

private def heterogeneousInputs : (i : Bool) → PMF (HeterogeneousInput i)
  | false => fair
  | true => heterogeneousSparse

private def heterogeneousRows : (i : Bool) → HeterogeneousInput i → PMF (HeterogeneousOutput i)
  | false => noisyBit
  | true => fun _ => PMF.pure ()

private theorem heterogeneous_product_input_additivity :
    mutualInfo (PMF.channelJoint (PMF.finiteProduct heterogeneousInputs)
      (PMF.productChannel heterogeneousRows)) =
      ∑ i : Bool, mutualInfo (PMF.channelJoint (heterogeneousInputs i) (heterogeneousRows i)) := by
  convert! mutualInfo_channelJoint_finiteProduct heterogeneousInputs heterogeneousRows

private theorem heterogeneous_product_input_information :
    mutualInfo (PMF.channelJoint (PMF.finiteProduct heterogeneousInputs)
      (PMF.productChannel heterogeneousRows)) = mutualInfo (PMF.channelJoint fair noisyBit) := by
  rw [heterogeneous_product_input_additivity]
  simp only [Fintype.sum_bool, heterogeneousInputs, heterogeneousRows,
    constant_channel_mutualInfo, zero_add]

/-! ## Iid processing at general, zero and one block lengths -/

private theorem iid_noisy_information (n : ℕ) :
    mutualInfo (PMF.channelJoint (PMF.iid fair n) (PMF.memorylessChannel noisyBit n)) =
      (n : ℝ) * mutualInfo (PMF.channelJoint fair noisyBit) := by
  convert! mutualInfo_channelJoint_iid fair noisyBit n

private theorem iid_noisy_information_zero :
    mutualInfo (PMF.channelJoint (PMF.iid fair 0) (PMF.memorylessChannel noisyBit 0)) = 0 := by
  rw [iid_noisy_information]
  simp

private theorem iid_noisy_information_one :
    mutualInfo (PMF.channelJoint (PMF.iid fair 1) (PMF.memorylessChannel noisyBit 1)) =
      mutualInfo (PMF.channelJoint fair noisyBit) := by
  rw [iid_noisy_information]
  simp

private theorem iid_identity_information (n : ℕ) :
    mutualInfo (PMF.channelJoint (PMF.iid fair n)
      (PMF.memorylessChannel (PMF.deterministicChannel id) n)) = (n : ℝ) * Real.log 2 := by
  have h := mutualInfo_channelJoint_iid fair (PMF.deterministicChannel id) n
  rw [identity_channel_mutualInfo, fair_entropy] at h
  convert! h

/-! ## Independent source bits and a noninjective encoding -/

private def sourceBits : PMF (Bool × Bool) := indepProd fair fair

private theorem source_bits_independent : IsIndependent sourceBits :=
  isIndependent_indepProd fair fair

private def encodeBits (ab : Bool × Bool) : Fin 2 → Bool := fun _ => ab.1

private theorem encoding_pushforward : sourceBits.map encodeBits = diagonal := by
  change (indepProd fair fair).map ((fun b (_ : Fin 2) => b) ∘ Prod.fst) = diagonal
  rw [← PMF.map_comp]
  change (fstMarginal (indepProd fair fair)).map (fun b (_ : Fin 2) => b) = diagonal
  rw [fstMarginal_indepProd]
  rfl

private theorem encoding_supported_collision :
    (false, false) ∈ sourceBits.support ∧ (false, true) ∈ sourceBits.support ∧
      (false, false) ≠ (false, true) ∧ encodeBits (false, false) = encodeBits (false, true) := by
  have hs (a b : Bool) : (a, b) ∈ sourceBits.support := by
    apply (sourceBits.mem_support_iff (a, b)).2
    rw [sourceBits, indepProd_apply, fair_mass, fair_mass]
    norm_num
  exact ⟨hs false false, hs false true, by decide, rfl⟩

private theorem encoded_input_correlated :
    sourceBits.map encodeBits ≠
      PMF.finiteProduct (fun i : Fin 2 => (sourceBits.map encodeBits).map (fun x => x i)) := by
  rw [encoding_pushforward]
  exact diagonal_not_product

private theorem encoded_noisy_information_bound :
    mutualInfo (PMF.channelJoint (sourceBits.map encodeBits) (PMF.memorylessChannel noisyBit 2)) ≤
      ∑ i : Fin 2,
        mutualInfo
          (PMF.channelJoint ((sourceBits.map encodeBits).map (fun x => x i)) noisyBit) := by
  convert! mutualInfo_channelJoint_productChannel_le
    (sourceBits.map encodeBits) (fun _ : Fin 2 => noisyBit)

private theorem encoded_noisy_single_letter_bound :
    mutualInfo (PMF.channelJoint (sourceBits.map encodeBits) (PMF.memorylessChannel noisyBit 2)) ≤
      2 * mutualInfo (PMF.channelJoint fair noisyBit) := by
  have h := encoded_noisy_information_bound
  rw [encoding_pushforward] at h ⊢
  simp only [diagonal_eval, Fin.sum_univ_two] at h
  linarith

/-! ## Coordinate objective bounds and independent-input objective values -/

open Classical in
private theorem coordinate_objective_cap
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i)) (C : I → ℝ)
    (hC : ∀ i (p : PMF (A i)), mutualInfo (PMF.channelJoint p (W i)) ≤ C i) :
    mutualInfo (PMF.channelJoint q (PMF.productChannel W)) ≤ ∑ i, C i := by
  let f : I → ℝ := fun i => mutualInfo (PMF.channelJoint (q.map (fun x => x i)) (W i))
  have hf : ∀ i, f i ≤ C i := by
    intro i
    have hi := hC i (q.map (fun x => x i))
    convert! hi
  have hsum : (∑ i, f i) ≤ ∑ i, C i :=
    Finset.sum_le_sum (s := Finset.univ) (f := f) (g := C) (fun i _ => hf i)
  have hbound : mutualInfo (PMF.channelJoint q (PMF.productChannel W)) ≤ ∑ i, f i := by
    convert! mutualInfo_channelJoint_productChannel_le q W
  exact hbound.trans hsum

open Classical in
private theorem independent_input_objective_value
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (p : ∀ i, PMF (A i)) (W : ∀ i, A i → PMF (B i)) (C : I → ℝ)
    (hC : ∀ i, mutualInfo (PMF.channelJoint (p i) (W i)) = C i) :
    mutualInfo (PMF.channelJoint (PMF.finiteProduct p) (PMF.productChannel W)) = ∑ i, C i := by
  rw [mutualInfo_channelJoint_finiteProduct]
  exact Finset.sum_congr rfl fun i _ => hC i

/-! ## Pairwise-independent parity outputs with a positive information gap -/

private def c3Source : PMF (Bool × Bool) := PMF.uniformOfFintype (Bool × Bool)

private theorem c3Source_eq_indepProd : c3Source = indepProd fair fair := by
  apply PMF.ext
  rintro ⟨a, b⟩
  norm_num [c3Source, fair, indepProd_apply, PMF.uniformOfFintype_apply]
  rw [← ENNReal.mul_inv (a := 2) (b := 2) (by norm_num) (by norm_num)]
  norm_num

private theorem c3Source_independent : IsIndependent c3Source := by
  rw [c3Source_eq_indepProd]
  exact isIndependent_indepProd fair fair

private def c3Word (x : Bool × Bool) : Fin 3 → Bool :=
  ![x.1, x.2, x.1 != x.2]

private def c3Input : PMF (Fin 3 → Bool) := c3Source.map c3Word

private theorem c3Word_injective : Function.Injective c3Word := by
  intro x y h
  apply Prod.ext
  · exact congrFun h 0
  · exact congrFun h 1

private theorem c3_pair_law (i j : Fin 3) (hij : i ≠ j) :
    c3Input.map (fun x => (x i, x j)) = c3Source := by
  rw [c3Input, PMF.map_comp]
  apply PMF.ext
  rintro ⟨a, b⟩
  fin_cases i <;> fin_cases j
  all_goals try exact (hij rfl).elim
  all_goals
    cases a <;> cases b <;>
      norm_num [PMF.map_apply, tsum_fintype, Fintype.sum_prod_type,
        Fintype.sum_bool, c3Source, PMF.uniformOfFintype_apply, c3Word]

private theorem c3_eval_from_pair (i j : Fin 3) (hij : i ≠ j) :
    c3Input.map (fun x => x i) = fair := by
  have h := congrArg (fun p : PMF (Bool × Bool) => p.map Prod.fst)
    (c3_pair_law i j hij)
  rw [PMF.map_comp] at h
  change c3Input.map (fun x => x i) = fstMarginal c3Source at h
  rw [c3Source_eq_indepProd, fstMarginal_indepProd] at h
  exact h

private theorem c3Input_eval (i : Fin 3) :
    c3Input.map (fun x => x i) = fair := by
  fin_cases i
  · exact c3_eval_from_pair 0 1 (by decide)
  · exact c3_eval_from_pair 1 0 (by decide)
  · exact c3_eval_from_pair 2 0 (by decide)

private theorem c3Source_entropy : entropy c3Source = 2 * Real.log 2 := by
  calc
    entropy c3Source = entropy (fstMarginal c3Source) + entropy (sndMarginal c3Source) :=
      (jointEntropy_eq_add_marginalEntropy_iff_isIndependent c3Source).2
        c3Source_independent
    _ = 2 * Real.log 2 := by
      rw [c3Source_eq_indepProd, fstMarginal_indepProd, sndMarginal_indepProd,
        fair_entropy]
      ring

private theorem c3Input_entropy : entropy c3Input = 2 * Real.log 2 := by
  rw [c3Input, entropy_map_injective c3Source c3Word_injective, c3Source_entropy]

private def c3Rows (_ : Fin 3) : Bool → PMF Bool := PMF.deterministicChannel id

private theorem c3_product_identity :
    PMF.productChannel c3Rows = PMF.deterministicChannel (id : (Fin 3 → Bool) → _) := by
  exact PMF.productChannel_deterministicChannel (fun _ : Fin 3 => (id : Bool → Bool))

private def c3Output : PMF (Fin 3 → Bool) := c3Input.bind (PMF.productChannel c3Rows)

private def c3Joint : PMF ((Fin 3 → Bool) × (Fin 3 → Bool)) :=
  PMF.channelJoint c3Input (PMF.productChannel c3Rows)

private theorem c3Output_eq : c3Output = c3Input := by
  rw [c3Output, c3_product_identity, PMF.bind_deterministicChannel, PMF.map_id]

private theorem c3_output_pairwise_independent (i j : Fin 3) (hij : i ≠ j) :
    IsIndependentOf c3Output (fun y => y i) (fun y => y j) := by
  rw [c3Output_eq]
  unfold IsIndependentOf
  rw [c3_pair_law i j hij]
  exact c3Source_independent

private theorem c3_output_entropy : entropy c3Output = 2 * Real.log 2 := by
  rw [c3Output_eq, c3Input_entropy]

private theorem c3_output_coordinate_entropy (i : Fin 3) :
    entropy (c3Output.map (fun y => y i)) = Real.log 2 := by
  rw [c3Output_eq, c3Input_eval, fair_entropy]

private theorem c3_output_entropy_gap :
    (∑ i : Fin 3, entropy (c3Output.map (fun y => y i))) - entropy c3Output =
      Real.log 2 := by
  simp only [c3_output_coordinate_entropy, c3_output_entropy, Fin.sum_univ_three]
  ring

private theorem c3_output_entropy_gap_positive :
    0 < (∑ i : Fin 3, entropy (c3Output.map (fun y => y i))) - entropy c3Output := by
  rw [c3_output_entropy_gap]
  exact Real.log_pos (by norm_num)

private theorem c3_joint_mutualInfo : mutualInfo c3Joint = 2 * Real.log 2 := by
  rw [c3Joint, c3_product_identity, identity_channel_mutualInfo, c3Input_entropy]

private theorem c3_coordinate_mutualInfo (i : Fin 3) :
    mutualInfo (PMF.channelJoint (c3Input.map (fun x => x i)) (c3Rows i)) =
      Real.log 2 := by
  rw [c3Input_eval]
  exact (identity_channel_mutualInfo fair).trans fair_entropy

private theorem c3_coordinate_mutualInfo_sum :
    (∑ i : Fin 3,
      mutualInfo (PMF.channelJoint (c3Input.map (fun x => x i)) (c3Rows i))) =
      3 * Real.log 2 := by
  simp only [c3_coordinate_mutualInfo, Fin.sum_univ_three]
  ring

private theorem c3_mutualInfo_gap :
    (∑ i : Fin 3,
      mutualInfo (PMF.channelJoint (c3Input.map (fun x => x i)) (c3Rows i))) -
        mutualInfo c3Joint = Real.log 2 := by
  rw [c3_coordinate_mutualInfo_sum, c3_joint_mutualInfo]
  ring

private theorem c3_mutualInfo_gap_positive :
    0 < (∑ i : Fin 3,
      mutualInfo (PMF.channelJoint (c3Input.map (fun x => x i)) (c3Rows i))) -
        mutualInfo c3Joint := by
  rw [c3_mutualInfo_gap]
  exact Real.log_pos (by norm_num)

private theorem c3_gap_from_public_identity :
    (∑ i : Fin 3, entropy ((c3Input.map (fun x => x i)).bind (c3Rows i))) -
        entropy c3Output = Real.log 2 := by
  have h := sum_mutualInfo_sub_mutualInfo_productChannel c3Input c3Rows
  have hgap :
      (∑ i : Fin 3,
        mutualInfo (PMF.channelJoint (c3Input.map (fun x => x i)) (c3Rows i))) -
          mutualInfo c3Joint =
        (∑ i : Fin 3, entropy ((c3Input.map (fun x => x i)).bind (c3Rows i))) -
          entropy c3Output := by
    convert! h
  rw [c3_mutualInfo_gap] at hgap
  exact hgap.symm

private theorem c3_not_output_mutually_independent :
    ¬ IsMutuallyIndependentFamily c3Output Finset.univ := by
  intro h
  have hiff := mutualInfo_channelJoint_productChannel_eq_sum_iff c3Input c3Rows
  have heq : mutualInfo c3Joint =
      ∑ i : Fin 3,
        mutualInfo (PMF.channelJoint (c3Input.map (fun x => x i)) (c3Rows i)) := by
    convert! hiff.mpr h
  have hpositive := c3_mutualInfo_gap_positive
  rw [heq, sub_self] at hpositive
  exact (lt_irrefl 0) hpositive

end

end LeanInfoTheory.Examples.ProductChannelInformation
