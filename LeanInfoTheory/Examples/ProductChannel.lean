/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.ProductChannel

/-!
# Product-channel rows, algebra and finite blocks

These private consumers use the focused probability owner. Input-dependent
Boolean and sparse ternary rows exercise exact atoms, support and evaluation,
including an infinite input alphabet. Nested selection, heterogeneous reindexing
and a finite selection from an infinite ambient family use the same constructor.
Duplicating one noisy output differs from sampling its row twice independently.
Empty alphabets and pure rows require no extra nonemptiness convention.
Independent heterogeneous inputs exercise coordinatewise processing. Two noisy
stages distinguish sampling order, while deterministic pre/postprocessing uses
the retained channel algebra and permits noninjective maps.
Repeated channels transport the input along with the output permutation.
Ordered blocks reuse C16 equivalences in both directions, including zero and
one letters, empty sides and empty-alphabet vacuous channels.
Joint transports preserve the actual input law. Independent inputs factor into
coordinate joints; a correlated diagonal input has non-product output even under
independent noisy coordinate sampling. A noninjective deterministic source map
uses the same raw joint/composition/extension APIs without coding definitions.
-/

namespace LeanInfoTheory.Examples.ProductChannel

noncomputable section

universe u v w t z

open scoped BigOperators ENNReal

/-! ## Heterogeneous, input-dependent channels -/

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

private def bitChannel (b : Bool) : PMF Bool :=
  if b then PMF.pure true else fair

private def tritChannel (n : ℕ) : PMF (Fin 3) :=
  if n = 0 then sparse else PMF.pure 2

private def Input : Bool → Type
  | false => Bool
  | true => ℕ

private def Output : Bool → Type
  | false => Bool
  | true => Fin 3

private instance outputFintype (i : Bool) : Fintype (Output i) := by
  cases i <;> dsimp [Output] <;> infer_instance

private def channels : (i : Bool) → Input i → PMF (Output i)
  | false => bitChannel
  | true => tritChannel

private def input (b : Bool) (n : ℕ) : (i : Bool) → Input i
  | false => b
  | true => n

private def output (b : Bool) (n : Fin 3) : (i : Bool) → Output i
  | false => b
  | true => n

private def row : PMF ((i : Bool) → Output i) :=
  PMF.productChannel channels (input false 0)

private theorem bit_marginal : row.map (fun y => y false) = fair :=
  PMF.productChannel_map_eval channels (input false 0) false

private theorem trit_marginal : row.map (fun y => y true) = sparse :=
  PMF.productChannel_map_eval channels (input false 0) true

private theorem changed_bit_marginal :
    (PMF.productChannel channels (input true 1)).map (fun y => y false) =
      PMF.pure true :=
  PMF.productChannel_map_eval channels (input true 1) false

private theorem changed_trit_marginal :
    (PMF.productChannel channels (input true 1)).map (fun y => y true) =
      PMF.pure (2 : Fin 3) :=
  PMF.productChannel_map_eval channels (input true 1) true

private theorem bit_rows_differ : bitChannel false ≠ bitChannel true := by
  intro h
  have hm := congrArg (fun p : PMF Bool => p false) h
  norm_num [bitChannel, fair, PMF.ofFintype_apply, PMF.pure_apply] at hm

private theorem trit_rows_differ : tritChannel 0 ≠ tritChannel 1 := by
  intro h
  have hm := congrArg (fun p : PMF (Fin 3) => p 0) h
  have h02 : (0 : Fin 3) ≠ 2 := by decide
  norm_num [tritChannel, sparse, PMF.ofFintype_apply, PMF.pure_apply, h02] at hm

private theorem exact_atoms (b : Bool) (a : Fin 3) :
    row (output b a) =
      if a = 2 then 0 else ENNReal.ofReal (1 / 4 : ℝ) := by
  rw [row, PMF.productChannel_apply, Fintype.prod_bool]
  change sparse a * fair b = _
  by_cases ha : a = 2
  · simp [sparse, fair, PMF.ofFintype_apply, ha]
  · simp only [sparse, fair, PMF.ofFintype_apply, if_neg ha]
    rw [← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2)]
    congr 1
    norm_num

private theorem supported_iff (b : Bool) (a : Fin 3) :
    output b a ∈ row.support ↔ a ≠ 2 := by
  rw [row, PMF.mem_support_productChannel_iff]
  constructor
  · intro h ha
    subst a
    have hz := h true
    change sparse 2 ≠ 0 at hz
    norm_num [sparse, PMF.ofFintype_apply] at hz
  · intro ha i
    cases i with
    | false =>
        change fair b ≠ 0
        norm_num [fair, PMF.ofFintype_apply]
    | true =>
        change sparse a ≠ 0
        simp [sparse, PMF.ofFintype_apply, ha]

private theorem supported_words (b : Bool) :
    output b 0 ∈ row.support ∧ output b 1 ∈ row.support := by
  constructor <;> rw [supported_iff] <;> decide

private theorem impossible_word (b : Bool) :
    row (output b 2) = 0 ∧ output b 2 ∉ row.support := by
  constructor
  · simp [exact_atoms]
  · intro h
    exact (supported_iff b 2).mp h rfl

private theorem normalized (x : (i : Bool) → Input i) :
    ∑' y, PMF.productChannel channels x y = 1 :=
  (PMF.productChannel channels x).tsum_coe

private theorem product_atom_zero_iff
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (W : ∀ i, A i → PMF (B i)) (x : ∀ i, A i) (y : ∀ i, B i) :
    PMF.productChannel W x y = 0 ↔ ∃ i, W i (x i) (y i) = 0 := by
  classical
  rw [PMF.productChannel_apply]
  simp only [Finset.prod_eq_zero_iff, Finset.mem_univ, true_and]

private theorem infinite_input : Infinite (Input true) :=
  inferInstanceAs (Infinite ℕ)

private theorem arbitrary_natural_input (b : Bool) (n : ℕ) :
    (PMF.productChannel channels (input b n)).map (fun y => y true) =
      tritChannel n :=
  PMF.productChannel_map_eval channels (input b n) true

/-! ## Singleton and nested restriction -/

private def selectTrit : Unit ↪ Bool where
  toFun _ := true
  inj' _ _ _ := Subsingleton.elim _ _

private theorem singleton_restriction :
    row.map (fun y (_ : Unit) => y true) =
      PMF.productChannel (fun _ : Unit => tritChannel) (fun _ => 0) :=
  PMF.productChannel_map_restrict channels (input false 0) selectTrit

private def TripleInput : Bool ⊕ Unit → Type
  | .inl i => Input i
  | .inr _ => Bool

private def TripleOutput : Bool ⊕ Unit → Type
  | .inl i => Output i
  | .inr _ => Bool

private instance tripleOutputFintype (i : Bool ⊕ Unit) :
    Fintype (TripleOutput i) := by
  cases i with
  | inl i => exact outputFintype i
  | inr _ => exact inferInstanceAs (Fintype Bool)

private def tripleChannels : (i : Bool ⊕ Unit) → TripleInput i → PMF (TripleOutput i)
  | .inl i => channels i
  | .inr _ => PMF.pure

private def tripleInput : (i : Bool ⊕ Unit) → TripleInput i
  | .inl i => input false 0 i
  | .inr _ => true

private def tripleRow : PMF ((i : Bool ⊕ Unit) → TripleOutput i) :=
  PMF.productChannel tripleChannels tripleInput

private def selectTwo : Bool ↪ Bool ⊕ Unit where
  toFun := Sum.inl
  inj' _ _ h := by cases h; rfl

private theorem three_to_two :
    tripleRow.map (fun y i => y (Sum.inl i)) = row :=
  PMF.productChannel_map_restrict tripleChannels tripleInput selectTwo

private theorem three_to_one_direct :
    tripleRow.map (fun y (_ : Unit) => y (Sum.inl true)) =
      PMF.productChannel (fun _ : Unit => tritChannel) (fun _ => 0) :=
  PMF.productChannel_map_restrict tripleChannels tripleInput
    (selectTrit.trans selectTwo)

private theorem nested_restriction :
    (tripleRow.map (fun y i => y (Sum.inl i))).map
        (fun y (_ : Unit) => y true) =
      PMF.productChannel (fun _ : Unit => tritChannel) (fun _ => 0) := by
  have h := congrArg
    (fun p : PMF ((i : Bool) → Output i) => p.map (fun y (_ : Unit) => y true))
    three_to_two
  exact h.trans singleton_restriction

private theorem nested_eq_direct :
    (tripleRow.map (fun y i => y (Sum.inl i))).map
        (fun y (_ : Unit) => y true) =
      tripleRow.map (fun y (_ : Unit) => y (Sum.inl true)) :=
  PMF.map_comp (p := tripleRow) (f := fun y i => y (Sum.inl i))
    (fun y (_ : Unit) => y true)

private theorem restriction_independent_universes
    {I : Type u} {J : Type t} {A : I → Type v} {B : I → Type w}
    [Fintype I] [Fintype J] [∀ i, Fintype (B i)]
    (W : ∀ i, A i → PMF (B i)) (x : ∀ i, A i) (e : J ↪ I) :
    (PMF.productChannel W x).map (fun y j => y (e j)) =
      PMF.productChannel (fun j => W (e j)) (fun j => x (e j)) :=
  PMF.productChannel_map_restrict W x e

/-! ## Heterogeneous reindexing in both directions -/

private def swapCoordinates : Bool ≃ Bool where
  toFun := Bool.not
  invFun := Bool.not
  left_inv b := by cases b <;> rfl
  right_inv b := by cases b <;> rfl

private theorem reordered_row (x : (i : Bool) → Input i) :
    (PMF.productChannel channels x).map (Equiv.piCongrLeft Output swapCoordinates).symm =
      PMF.productChannel (fun i => channels (swapCoordinates i))
        (fun i => x (swapCoordinates i)) :=
  PMF.finiteProduct_map_reindex (fun i => channels i (x i)) swapCoordinates

private theorem reordered_row_inverse (x : (i : Bool) → Input i) :
    (PMF.productChannel (fun i => channels (swapCoordinates i))
        (fun i => x (swapCoordinates i))).map (Equiv.piCongrLeft Output swapCoordinates) =
      PMF.productChannel channels x := by
  have h := congrArg
    (fun q : PMF ((i : Bool) → Output (swapCoordinates i)) =>
      q.map (Equiv.piCongrLeft Output swapCoordinates))
    (reordered_row x)
  simpa only [PMF.map_comp, Equiv.self_comp_symm, PMF.map_id] using h.symm

private theorem reordered_trit_coordinate :
    (PMF.productChannel (fun i => channels (swapCoordinates i))
        (fun i => input false 0 (swapCoordinates i))).map (fun y => y false) = sparse :=
  PMF.productChannel_map_eval (fun i => channels (swapCoordinates i))
    (fun i => input false 0 (swapCoordinates i)) false

private theorem reordered_bit_coordinate :
    (PMF.productChannel (fun i => channels (swapCoordinates i))
        (fun i => input false 0 (swapCoordinates i))).map (fun y => y true) = fair :=
  PMF.productChannel_map_eval (fun i => channels (swapCoordinates i))
    (fun i => input false 0 (swapCoordinates i)) true

/-! ## Construct on a finite selection before restricting it -/

private def AmbientInput : ℕ → Type
  | 0 => Bool
  | _ + 1 => ℕ

private def AmbientOutput : ℕ → Type
  | 0 => Bool
  | 1 => Fin 3
  | _ + 2 => ℕ

private def selected : Finset ℕ := {0, 1}

private instance selectedOutputFintype : (i : selected) → Fintype (AmbientOutput i.1)
  | ⟨0, _⟩ => inferInstanceAs (Fintype Bool)
  | ⟨1, _⟩ => inferInstanceAs (Fintype (Fin 3))
  | ⟨n + 2, hn⟩ => False.elim (by simp [selected] at hn)

private def selectedChannels : (i : selected) → AmbientInput i.1 → PMF (AmbientOutput i.1)
  | ⟨0, _⟩ => bitChannel
  | ⟨1, _⟩ => tritChannel
  | ⟨n + 2, hn⟩ => False.elim (by simp [selected] at hn)

private def selectedInput : (i : selected) → AmbientInput i.1
  | ⟨0, _⟩ => false
  | ⟨1, _⟩ => (0 : ℕ)
  | ⟨n + 2, hn⟩ => False.elim (by simp [selected] at hn)

private def selectedRow : PMF ((i : selected) → AmbientOutput i.1) :=
  PMF.productChannel selectedChannels selectedInput

private def oneIndex : selected := ⟨1, by simp [selected]⟩

private def selectOne : Unit ↪ selected where
  toFun _ := oneIndex
  inj' _ _ _ := Subsingleton.elim _ _

private theorem selected_atoms (y : (i : selected) → AmbientOutput i.1) :
    selectedRow y = ∏ i : selected, selectedChannels i (selectedInput i) (y i) :=
  PMF.productChannel_apply selectedChannels selectedInput y

private theorem selected_support (y : (i : selected) → AmbientOutput i.1) :
    y ∈ selectedRow.support ↔
      ∀ i : selected, y i ∈ (selectedChannels i (selectedInput i)).support :=
  PMF.mem_support_productChannel_iff selectedChannels selectedInput y

private theorem selected_trit_coordinate : selectedRow.map (fun y => y oneIndex) = sparse :=
  PMF.productChannel_map_eval selectedChannels selectedInput oneIndex

private theorem restrict_selected_family :
    selectedRow.map (fun y (_ : Unit) => y oneIndex) =
      PMF.productChannel (fun _ : Unit => tritChannel) (fun _ => 0) :=
  PMF.productChannel_map_restrict selectedChannels selectedInput selectOne

private theorem unselected_outputs_infinite (n : ℕ) :
    Infinite (AmbientOutput (n + 2)) :=
  inferInstanceAs (Infinite ℕ)

/-! ## Repeating an output repeats its sample -/

private def duplicated : PMF (Bool → Bool) :=
  row.map (fun y (_ : Bool) => y false)

private def independentRepeated : PMF (Bool → Bool) :=
  PMF.productChannel (fun _ : Bool => bitChannel) (fun _ => false)

private def offDiagonal : Bool → Bool := id

private theorem duplicated_eq :
    duplicated = fair.map (fun b (_ : Bool) => b) := by
  have h := congrArg
    (fun p : PMF Bool => p.map (fun b (_ : Bool) => b)) bit_marginal
  exact (PMF.map_comp (p := row)
    (f := fun y : (i : Bool) → Output i => (y false : Bool))
    (fun b (_ : Bool) => b)).symm.trans h

private theorem duplicated_off_diagonal : duplicated offDiagonal = 0 := by
  rw [duplicated_eq]
  apply PMF.map_apply_eq_zero_of_notMem_range fair
  rintro ⟨b, hb⟩
  have hf : b = false := congrFun hb false
  have ht : b = true := congrFun hb true
  have hft : false = true := hf.symm.trans ht
  cases hft

private theorem independent_repeated_atoms (y : Bool → Bool) :
    independentRepeated y = ENNReal.ofReal (1 / 4 : ℝ) := by
  rw [independentRepeated, PMF.productChannel_apply, Fintype.prod_bool]
  change ENNReal.ofReal (1 / 2 : ℝ) * ENNReal.ofReal (1 / 2 : ℝ) = _
  rw [← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  congr 1
  norm_num

private theorem repeated_restriction_ne_product : duplicated ≠ independentRepeated := by
  intro h
  have hm := congrArg (fun p : PMF (Bool → Bool) => p offDiagonal) h
  rw [duplicated_off_diagonal, independent_repeated_atoms] at hm
  norm_num at hm

/-! ## Constructor boundaries: empty alphabets and pure rows -/

private def emptyChannels (i : Fin 0) : Empty → PMF Empty := isEmptyElim i

private def emptyInput (i : Fin 0) : Empty := isEmptyElim i

private theorem empty_row :
    PMF.productChannel emptyChannels emptyInput = PMF.pure emptyInput :=
  PMF.finiteProduct_of_isEmpty (fun i => emptyChannels i (emptyInput i))

private theorem empty_atom : PMF.productChannel emptyChannels emptyInput emptyInput = 1 := by
  rw [empty_row]
  exact PMF.pure_apply_self emptyInput

private theorem pure_rows
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (f : ∀ i, A i → B i) (x : ∀ i, A i) :
    PMF.productChannel (fun i a => PMF.pure (f i a)) x =
      PMF.pure (fun i => f i (x i)) :=
  PMF.finiteProduct_pure (fun i => f i (x i))

private def emptyToEmpty (a : Empty) : PMF Empty := isEmptyElim a

private theorem empty_to_empty_exists : Nonempty (Empty → PMF Empty) :=
  ⟨emptyToEmpty⟩

private theorem vacuous_product_exists :
    Nonempty ((Unit → Empty) → PMF (Unit → Empty)) :=
  ⟨PMF.productChannel (fun _ : Unit => emptyToEmpty)⟩

private theorem no_empty_law : ¬ Nonempty (PMF Empty) := by
  rintro ⟨p⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

private theorem no_empty_input_word_law : ¬ Nonempty (PMF (Unit → Empty)) := by
  rintro ⟨p⟩
  obtain ⟨x, _⟩ := p.support_nonempty
  exact isEmptyElim (x ())

private theorem no_nonempty_input_to_empty_output {A : Type v} (a : A) :
    ¬ Nonempty (A → PMF Empty) := by
  rintro ⟨W⟩
  exact no_empty_law ⟨W a⟩

/-! ## Independent processing and stochastic composition -/

private def independentInputs : (i : Bool) → PMF (Output i)
  | false => fair
  | true => sparse

private def finiteChannels : (i : Bool) → Output i → PMF (Output i)
  | false => bitChannel
  | true => fun a => tritChannel a.val

private theorem independent_processing :
    (PMF.finiteProduct independentInputs).bind (PMF.productChannel finiteChannels) =
      PMF.finiteProduct (fun i => (independentInputs i).bind (finiteChannels i)) :=
  PMF.finiteProduct_bind_productChannel independentInputs finiteChannels

private theorem independent_processing_atom :
    ((PMF.finiteProduct independentInputs).bind
      (PMF.productChannel finiteChannels)) (output false 2) =
        ENNReal.ofReal (1 / 8 : ℝ) := by
  rw [independent_processing, PMF.finiteProduct_apply, Fintype.prod_bool]
  change (sparse.bind (fun a => tritChannel a.val)) 2 *
    (fair.bind bitChannel) false = _
  have h12 : (1 : Fin 3) ≠ 2 := by decide
  norm_num [PMF.bind_apply, tsum_fintype, Fin.sum_univ_three, Fintype.sum_bool,
    sparse, fair, bitChannel, tritChannel, PMF.ofFintype_apply, PMF.pure_apply, h12]
  rw [← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2),
    ← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  congr 1
  norm_num

private theorem independent_input_zero_mass : independentInputs true (2 : Fin 3) = 0 := by
  change sparse (2 : Fin 3) = 0
  simp [sparse, PMF.ofFintype_apply]

private def reverseBit (b : Bool) : PMF Bool :=
  if b then fair else PMF.pure false

private def firstStages (i : Bool) : Bool → PMF Bool :=
  if i then reverseBit else bitChannel

private def secondStages (i : Bool) : Bool → PMF Bool :=
  if i then bitChannel else reverseBit

private theorem stochastic_forward_atom :
    PMF.channelComp (PMF.productChannel firstStages) (PMF.productChannel secondStages)
      (fun _ => false) id = ENNReal.ofReal (3 / 8 : ℝ) := by
  rw [PMF.channelComp_productChannel, PMF.productChannel_apply, Fintype.prod_bool]
  change PMF.channelComp reverseBit bitChannel false true *
    PMF.channelComp bitChannel reverseBit false false = _
  norm_num [PMF.channelComp_apply, tsum_fintype, Fintype.sum_bool,
    reverseBit, bitChannel, fair, PMF.ofFintype_apply, PMF.pure_apply]
  rw [← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2),
    ← ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1 / 2 * (1 / 2))
      (by norm_num : (0 : ℝ) ≤ 1 / 2),
    ← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  congr 1
  norm_num

private theorem stochastic_reverse_atom :
    PMF.channelComp (PMF.productChannel secondStages) (PMF.productChannel firstStages)
      (fun _ => false) id = ENNReal.ofReal (1 / 8 : ℝ) := by
  rw [PMF.channelComp_productChannel, PMF.productChannel_apply, Fintype.prod_bool]
  change PMF.channelComp bitChannel reverseBit false true *
    PMF.channelComp reverseBit bitChannel false false = _
  norm_num [PMF.channelComp_apply, tsum_fintype, Fintype.sum_bool,
    reverseBit, bitChannel, fair, PMF.ofFintype_apply, PMF.pure_apply]
  rw [← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2),
    ← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2 * (1 / 2))]
  congr 1
  norm_num

private theorem stochastic_order_matters :
    PMF.channelComp (PMF.productChannel firstStages) (PMF.productChannel secondStages) ≠
      PMF.channelComp (PMF.productChannel secondStages) (PMF.productChannel firstStages) := by
  intro h
  have hm := congrArg (fun K => K (fun _ => false) id) h
  rw [stochastic_forward_atom, stochastic_reverse_atom] at hm
  norm_num at hm

private theorem composition_infinite_original_inputs :
    PMF.channelComp (PMF.productChannel channels) (PMF.productChannel finiteChannels) =
      PMF.productChannel (fun i => PMF.channelComp (channels i) (finiteChannels i)) :=
  PMF.channelComp_productChannel channels finiteChannels

private theorem sequential_output_any_input
    {I : Type u} {A : I → Type v} {B : I → Type w} {C : I → Type z}
    [Fintype I] [∀ i, Fintype (B i)] [∀ i, Fintype (C i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i))
    (V : ∀ i, B i → PMF (C i)) :
    (q.bind (PMF.productChannel W)).bind (PMF.productChannel V) =
      q.bind (PMF.productChannel (fun i => PMF.channelComp (W i) (V i))) := by
  rw [← PMF.bind_channelComp, PMF.channelComp_productChannel]

/-! ## Deterministic reductions through existing channel algebra -/

private theorem coordinatewise_map
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (p : ∀ i, PMF (A i)) (f : ∀ i, A i → B i) :
    (PMF.finiteProduct p).map (fun x i => f i (x i)) =
      PMF.finiteProduct (fun i => (p i).map (f i)) := by
  simpa only [PMF.productChannel_deterministicChannel,
    PMF.bind_deterministicChannel] using
    PMF.finiteProduct_bind_productChannel p (fun i => PMF.deterministicChannel (f i))

private theorem product_identity
    {I : Type u} {A : I → Type v} [Fintype I] [∀ i, Fintype (A i)] :
    PMF.productChannel (fun i => PMF.deterministicChannel (id : A i → A i)) =
      PMF.pure :=
  PMF.productChannel_deterministicChannel (fun _ => id)

private theorem product_identity_left :
    PMF.channelComp
      (PMF.productChannel (fun i => PMF.deterministicChannel (id : Output i → Output i)))
      (PMF.productChannel finiteChannels) = PMF.productChannel finiteChannels := by
  rw [product_identity, PMF.channelComp_pure_left]

private theorem product_identity_right :
    PMF.channelComp (PMF.productChannel channels)
      (PMF.productChannel (fun i => PMF.deterministicChannel (id : Output i → Output i))) =
        PMF.productChannel channels := by
  rw [product_identity, PMF.channelComp_pure_right]

private theorem product_constant
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)] (b : ∀ i, B i) :
    PMF.productChannel (fun i => PMF.deterministicChannel (fun _ : A i => b i)) =
      fun _ => PMF.pure b :=
  PMF.productChannel_deterministicChannel (fun i _ => b i)

private theorem deterministic_preprocessing
    {I : Type u} {A : I → Type v} {B : I → Type w} {C : I → Type z}
    [Fintype I] [∀ i, Fintype (B i)] [∀ i, Fintype (C i)]
    (f : ∀ i, A i → B i) (V : ∀ i, B i → PMF (C i)) :
    PMF.channelComp (PMF.productChannel (fun i => PMF.deterministicChannel (f i)))
      (PMF.productChannel V) = fun x => PMF.productChannel V (fun i => f i (x i)) := by
  rw [PMF.productChannel_deterministicChannel, PMF.channelComp_deterministic_left]

private theorem deterministic_postprocessing
    {I : Type u} {A : I → Type v} {B : I → Type w} {C : I → Type z}
    [Fintype I] [∀ i, Fintype (B i)] [∀ i, Fintype (C i)]
    (W : ∀ i, A i → PMF (B i)) (f : ∀ i, B i → C i) :
    PMF.channelComp (PMF.productChannel W)
      (PMF.productChannel (fun i => PMF.deterministicChannel (f i))) =
        fun x => (PMF.productChannel W x).map (fun y i => f i (y i)) := by
  rw [PMF.productChannel_deterministicChannel, PMF.channelComp_deterministic_right]

private theorem negate_before_noisy_channels :
    PMF.channelComp
      (PMF.productChannel (fun _ : Bool => PMF.deterministicChannel Bool.not))
      (PMF.productChannel firstStages) =
        fun x => PMF.productChannel firstStages (fun i => !(x i)) :=
  deterministic_preprocessing (fun _ => Bool.not) firstStages

private def outputCollapse : (i : Bool) → Output i → Bool
  | false => id
  | true => fun a : Fin 3 => decide (a = 2)

private theorem collapse_has_supported_collision :
    outputCollapse true (0 : Fin 3) = outputCollapse true (1 : Fin 3) ∧
      (0 : Fin 3) ≠ 1 ∧ 0 ∈ sparse.support ∧ 1 ∈ sparse.support := by
  have h02 : (0 : Fin 3) ≠ 2 := by decide
  have h12 : (1 : Fin 3) ≠ 2 := by decide
  norm_num [outputCollapse, PMF.mem_support_iff, sparse, PMF.ofFintype_apply, h02, h12]

private theorem collapse_after_noisy_channels :
    PMF.channelComp (PMF.productChannel channels)
      (PMF.productChannel (fun i => PMF.deterministicChannel (outputCollapse i))) =
        fun x => (PMF.productChannel channels x).map (fun y i => outputCollapse i (y i)) :=
  deterministic_postprocessing channels outputCollapse

private theorem collapse_independent_inputs :
    (PMF.finiteProduct independentInputs).map (fun x i => outputCollapse i (x i)) =
      PMF.finiteProduct (fun i => (independentInputs i).map (outputCollapse i)) :=
  coordinatewise_map independentInputs outputCollapse

/-! ## Repeated channels: covariance, not fixed-input invariance -/

private theorem repeated_atoms {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (n : ℕ) (x : Fin n → A) (y : Fin n → B) :
    PMF.memorylessChannel W n x y = ∏ i, W (x i) (y i) :=
  PMF.productChannel_apply (fun _ => W) x y

private theorem repeated_support {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (n : ℕ) (x : Fin n → A) (y : Fin n → B) :
    y ∈ (PMF.memorylessChannel W n x).support ↔ ∀ i, y i ∈ (W (x i)).support :=
  PMF.mem_support_productChannel_iff (fun _ => W) x y

private theorem repeated_eval {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (n : ℕ) (x : Fin n → A) (i : Fin n) :
    (PMF.memorylessChannel W n x).map (fun y => y i) = W (x i) :=
  PMF.productChannel_map_eval (fun _ => W) x i

private theorem repeated_comp {A : Type v} {B : Type w} {C : Type z}
    [Fintype B] [Fintype C] (W : A → PMF B) (V : B → PMF C) (n : ℕ) :
    PMF.channelComp (PMF.memorylessChannel W n) (PMF.memorylessChannel V n) =
      PMF.memorylessChannel (PMF.channelComp W V) n :=
  PMF.channelComp_productChannel (fun _ => W) (fun _ => V)

private theorem repeated_deterministic {A : Type v} {B : Type w} [Fintype B]
    (f : A → B) (n : ℕ) :
    PMF.memorylessChannel (PMF.deterministicChannel f) n =
      PMF.deterministicChannel (fun x i => f (x i)) :=
  PMF.productChannel_deterministicChannel (fun _ => f)

private theorem repeated_permutation {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (n : ℕ) (x : Fin n → A) (e : Equiv.Perm (Fin n)) :
    (PMF.memorylessChannel W n x).map (fun y i => y (e i)) =
      PMF.memorylessChannel W n (fun i => x (e i)) :=
  PMF.productChannel_map_restrict (fun _ => W) x e.toEmbedding

private def varyingInput : Fin 3 → Bool := ![false, false, true]

private def exchangeEnds : Equiv.Perm (Fin 3) := Equiv.swap 0 2

private theorem varying_permutation :
    (PMF.memorylessChannel bitChannel 3 varyingInput).map (fun y i => y (exchangeEnds i)) =
      PMF.memorylessChannel bitChannel 3 (fun i => varyingInput (exchangeEnds i)) :=
  repeated_permutation bitChannel 3 varyingInput exchangeEnds

private theorem varying_not_invariant :
    (PMF.memorylessChannel bitChannel 3 varyingInput).map (fun y i => y (exchangeEnds i)) ≠
      PMF.memorylessChannel bitChannel 3 varyingInput := by
  rw [varying_permutation]
  intro h
  have hm := congrArg (fun p : PMF (Fin 3 → Bool) => p.map (fun y => y 0)) h
  rw [repeated_eval, repeated_eval] at hm
  exact bit_rows_differ (by simpa [exchangeEnds, varyingInput] using hm.symm)

private theorem varying_supported_atom :
    PMF.memorylessChannel bitChannel 3 varyingInput (![false, true, true]) =
      ENNReal.ofReal (1 / 4 : ℝ) := by
  rw [repeated_atoms, Fin.prod_univ_three]
  change fair false * fair true * PMF.pure true true = _
  norm_num [fair, PMF.ofFintype_apply, PMF.pure_apply, ← ENNReal.ofReal_mul]

private theorem varying_impossible_word :
    (![false, true, false] : Fin 3 → Bool) ∉
      (PMF.memorylessChannel bitChannel 3 varyingInput).support := by
  intro h
  have hz := (repeated_support bitChannel 3 varyingInput _).mp h 2
  simp [varyingInput, bitChannel] at hz

private def prefixEmbedding (m n : ℕ) : Fin m ↪ Fin (m + n) where
  toFun := Fin.castAdd n
  inj' := Fin.castAdd_injective m n

private def suffixEmbedding (m n : ℕ) : Fin n ↪ Fin (m + n) where
  toFun := Fin.natAdd m
  inj' _ _ h := Fin.ext (Nat.add_left_cancel (congrArg Fin.val h))

private theorem repeated_prefix {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (m n : ℕ) (x : Fin (m + n) → A) :
    (PMF.memorylessChannel W (m + n) x).map (fun y i => y (Fin.castAdd n i)) =
      PMF.memorylessChannel W m (fun i => x (Fin.castAdd n i)) :=
  PMF.productChannel_map_restrict (fun _ => W) x (prefixEmbedding m n)

private theorem repeated_suffix {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (m n : ℕ) (x : Fin (m + n) → A) :
    (PMF.memorylessChannel W (m + n) x).map (fun y i => y (Fin.natAdd m i)) =
      PMF.memorylessChannel W n (fun i => x (Fin.natAdd m i)) :=
  PMF.productChannel_map_restrict (fun _ => W) x (suffixEmbedding m n)

private theorem prefix_ignores_discarded_inputs {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (m n : ℕ) (x x' : Fin (m + n) → A)
    (h : ∀ i, x (Fin.castAdd n i) = x' (Fin.castAdd n i)) :
    (PMF.memorylessChannel W (m + n) x).map (fun y i => y (Fin.castAdd n i)) =
      (PMF.memorylessChannel W (m + n) x').map (fun y i => y (Fin.castAdd n i)) := by
  rw [repeated_prefix, repeated_prefix, funext h]

/-- A supplied infinite sequence only indexes finite constructions. -/
private theorem finite_length_consistency {A : Type v} {B : Type w} [Fintype B]
    (W : ℕ → A → PMF B) (x : ℕ → A) (m n : ℕ) :
    (PMF.productChannel (fun i : Fin (m + n) => W i) (fun i => x i)).map
        (fun y i => y (Fin.castAdd n i)) =
      PMF.productChannel (fun i : Fin m => W i) (fun i => x i) :=
  PMF.productChannel_map_restrict (fun i : Fin (m + n) => W i)
    (fun i => x i) (prefixEmbedding m n)

/-! ## Ordered finite blocks and inverse concatenation -/

private theorem block_split {A : Type v} {B : Type w} [Fintype B]
    (m n : ℕ) (W : Fin (m + n) → A → PMF B) (x : Fin (m + n) → A) :
    (PMF.productChannel W x).map (Fin.appendEquiv m n).symm =
      PMF.channelJoint
        (PMF.productChannel (fun i => W (Fin.castAdd n i)) (fun i => x (Fin.castAdd n i)))
        (fun _ => PMF.productChannel (fun i => W (Fin.natAdd m i))
          (fun i => x (Fin.natAdd m i))) :=
  PMF.finiteProduct_map_append_symm m n (fun i => W i (x i))

private theorem block_rebuild {A : Type v} {B : Type w} [Fintype B]
    (m n : ℕ) (W : Fin (m + n) → A → PMF B) (x : Fin (m + n) → A) :
    (PMF.channelJoint
        (PMF.productChannel (fun i => W (Fin.castAdd n i)) (fun i => x (Fin.castAdd n i)))
        (fun _ => PMF.productChannel (fun i => W (Fin.natAdd m i))
          (fun i => x (Fin.natAdd m i)))).map (Fin.appendEquiv m n) =
      PMF.productChannel W x := by
  have h := PMF.channelJoint_finiteProduct_map_append
    (fun i => W (Fin.castAdd n i) (x (Fin.castAdd n i)))
    (fun i => W (Fin.natAdd m i) (x (Fin.natAdd m i)))
  rw [Fin.append_castAdd_natAdd (f := fun i => W i (x i))] at h
  exact h

private theorem block_prefix {A : Type v} {B : Type w} [Fintype B]
    (m n : ℕ) (W : Fin (m + n) → A → PMF B) (x : Fin (m + n) → A) :
    ((PMF.productChannel W x).map (Fin.appendEquiv m n).symm).map Prod.fst =
      PMF.productChannel (fun i => W (Fin.castAdd n i)) (fun i => x (Fin.castAdd n i)) := by
  rw [block_split, PMF.channelJoint_map_fst]

private theorem block_suffix {A : Type v} {B : Type w} [Fintype B]
    (m n : ℕ) (W : Fin (m + n) → A → PMF B) (x : Fin (m + n) → A) :
    ((PMF.productChannel W x).map (Fin.appendEquiv m n).symm).map Prod.snd =
      PMF.productChannel (fun i => W (Fin.natAdd m i)) (fun i => x (Fin.natAdd m i)) := by
  rw [block_split, PMF.channelJoint_map_snd, PMF.bind_const]

private def blockChannels : Fin 3 → Bool → PMF Bool :=
  ![bitChannel, reverseBit, bitChannel]

private theorem one_two_orientation (y : Fin 3 → Bool) :
    ((Fin.appendEquiv 1 2).symm y).1 0 = y 0 ∧
      ((Fin.appendEquiv 1 2).symm y).2 0 = y 1 ∧
      ((Fin.appendEquiv 1 2).symm y).2 1 = y 2 :=
  ⟨rfl, rfl, rfl⟩

private theorem nonidentical_rows :
    blockChannels 0 (varyingInput 0) ≠ blockChannels 1 (varyingInput 1) ∧
      blockChannels 1 (varyingInput 1) ≠ blockChannels 2 (varyingInput 2) := by
  constructor
  · intro h
    have hm := congrArg (fun p : PMF Bool => p true) h
    norm_num [blockChannels, varyingInput, reverseBit, bitChannel, fair,
      PMF.ofFintype_apply, PMF.pure_apply] at hm
  · intro h
    have hm := congrArg (fun p : PMF Bool => p false) h
    change PMF.pure false false = PMF.pure true false at hm
    simp at hm

private theorem nonidentical_one_two :
    (PMF.productChannel blockChannels varyingInput).map (Fin.appendEquiv 1 2).symm =
      PMF.channelJoint (PMF.productChannel (fun _ : Fin 1 => bitChannel) (fun _ => false))
        (fun _ => PMF.productChannel (![reverseBit, bitChannel]) (![false, true])) := by
  exact block_split 1 2 blockChannels varyingInput

private theorem nonidentical_one_two_inverse :
    (PMF.channelJoint (PMF.productChannel (fun _ : Fin 1 => bitChannel) (fun _ => false))
      (fun _ => PMF.productChannel (![reverseBit, bitChannel]) (![false, true]))).map
        (Fin.appendEquiv 1 2) = PMF.productChannel blockChannels varyingInput := by
  exact block_rebuild 1 2 blockChannels varyingInput

private theorem nonidentical_one_two_prefix :
    ((PMF.productChannel blockChannels varyingInput).map
      (Fin.appendEquiv 1 2).symm).map Prod.fst =
        PMF.productChannel (fun _ : Fin 1 => bitChannel) (fun _ => false) := by
  rw [nonidentical_one_two, PMF.channelJoint_map_fst]

private theorem nonidentical_one_two_suffix :
    ((PMF.productChannel blockChannels varyingInput).map
      (Fin.appendEquiv 1 2).symm).map Prod.snd =
        PMF.productChannel (![reverseBit, bitChannel]) (![false, true]) := by
  rw [nonidentical_one_two, PMF.channelJoint_map_snd, PMF.bind_const]

private theorem dependent_sum_split :
    tripleRow.map (Equiv.sumPiEquivProdPi TripleOutput) =
      PMF.channelJoint row (fun _ => PMF.productChannel
        (fun _ : Unit => PMF.pure) (fun _ => true)) :=
  PMF.finiteProduct_map_sum (fun i => tripleChannels i (tripleInput i))

private theorem repeated_split {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (m n : ℕ) (x : Fin (m + n) → A) :
    (PMF.memorylessChannel W (m + n) x).map (Fin.appendEquiv m n).symm =
      PMF.channelJoint (PMF.memorylessChannel W m (fun i => x (Fin.castAdd n i)))
        (fun _ => PMF.memorylessChannel W n (fun i => x (Fin.natAdd m i))) :=
  block_split m n (fun _ => W) x

private theorem repeated_rebuild {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (m n : ℕ) (x : Fin (m + n) → A) :
    (PMF.channelJoint (PMF.memorylessChannel W m (fun i => x (Fin.castAdd n i)))
      (fun _ => PMF.memorylessChannel W n (fun i => x (Fin.natAdd m i)))).map
        (Fin.appendEquiv m n) = PMF.memorylessChannel W (m + n) x :=
  block_rebuild m n (fun _ => W) x

/-! ## Zero and one letters, empty sides, and vacuous channels -/

private theorem repeated_zero {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (x : Fin 0 → A) :
    PMF.memorylessChannel W 0 x = PMF.pure (fun i : Fin 0 => (isEmptyElim i : B)) :=
  PMF.finiteProduct_of_isEmpty (fun i => W (x i))

private theorem repeated_zero_atom {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (x : Fin 0 → A) (y : Fin 0 → B) :
    PMF.memorylessChannel W 0 x y = 1 := by
  rw [repeated_atoms]
  simp

private theorem repeated_one_eval {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (x : Fin 1 → A) :
    (PMF.memorylessChannel W 1 x).map (Equiv.funUnique (Fin 1) B) =
      W ((Equiv.funUnique (Fin 1) A) x) :=
  repeated_eval W 1 x default

private theorem repeated_one_rebuild {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (x : Fin 1 → A) :
    (W ((Equiv.funUnique (Fin 1) A) x)).map (Equiv.funUnique (Fin 1) B).symm =
      PMF.memorylessChannel W 1 x := by
  have h := congrArg (fun p : PMF B => p.map (Equiv.funUnique (Fin 1) B).symm)
    (repeated_one_eval W x)
  simpa only [PMF.map_comp, Equiv.symm_comp_self, PMF.map_id] using h.symm

private theorem repeated_split_empty_prefix {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (n : ℕ) (x : Fin (0 + n) → A) :
    (PMF.memorylessChannel W (0 + n) x).map (Fin.appendEquiv 0 n).symm =
      PMF.channelJoint (PMF.pure (fun i : Fin 0 => (isEmptyElim i : B)))
        (fun _ => PMF.memorylessChannel W n (fun i => x (Fin.natAdd 0 i))) := by
  rw [repeated_split, repeated_zero]

private theorem repeated_split_empty_suffix {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (n : ℕ) (x : Fin (n + 0) → A) :
    (PMF.memorylessChannel W (n + 0) x).map (Fin.appendEquiv n 0).symm =
      PMF.channelJoint (PMF.memorylessChannel W n (fun i => x (Fin.castAdd 0 i)))
        (fun _ => PMF.pure (fun i : Fin 0 => (isEmptyElim i : B))) := by
  rw [repeated_split, repeated_zero]

private theorem repeated_rebuild_empty_prefix {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (n : ℕ) (x : Fin (0 + n) → A) :
    (PMF.channelJoint (PMF.pure (fun i : Fin 0 => (isEmptyElim i : B)))
      (fun _ => PMF.memorylessChannel W n (fun i => x (Fin.natAdd 0 i)))).map
        (Fin.appendEquiv 0 n) = PMF.memorylessChannel W (0 + n) x := by
  simpa only [repeated_zero] using repeated_rebuild W 0 n x

private theorem repeated_rebuild_empty_suffix {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (n : ℕ) (x : Fin (n + 0) → A) :
    (PMF.channelJoint (PMF.memorylessChannel W n (fun i => x (Fin.castAdd 0 i)))
      (fun _ => PMF.pure (fun i : Fin 0 => (isEmptyElim i : B)))).map
        (Fin.appendEquiv n 0) = PMF.memorylessChannel W (n + 0) x := by
  simpa only [repeated_zero] using repeated_rebuild W n 0 x

private theorem repeated_empty_empty_split :
    (PMF.memorylessChannel emptyToEmpty (0 + 0) emptyInput).map
      (Fin.appendEquiv 0 0).symm =
        PMF.channelJoint (PMF.pure emptyInput) (fun _ => PMF.pure emptyInput) := by
  have h : (fun i : Fin 0 => (isEmptyElim i : Empty)) = emptyInput := Subsingleton.elim _ _
  simpa only [repeated_zero, h] using repeated_split emptyToEmpty 0 0 emptyInput

private theorem repeated_empty_empty_rebuild :
    (PMF.channelJoint (PMF.pure emptyInput) (fun _ => PMF.pure emptyInput)).map
      (Fin.appendEquiv 0 0) = PMF.memorylessChannel emptyToEmpty (0 + 0) emptyInput := by
  have h : (fun i : Fin 0 => (isEmptyElim i : Empty)) = emptyInput := Subsingleton.elim _ _
  simpa only [repeated_zero, h] using repeated_rebuild emptyToEmpty 0 0 emptyInput

private theorem singleton_output (n : ℕ) (x : Fin n → ℕ) :
    PMF.memorylessChannel (PMF.deterministicChannel (fun _ : ℕ => ())) n x =
      PMF.pure (fun _ => ()) :=
  congrFun (repeated_deterministic (fun _ : ℕ => ()) n) x

private theorem empty_alphabets_zero_row :
    PMF.memorylessChannel emptyToEmpty 0 emptyInput = PMF.pure emptyInput :=
  repeated_zero emptyToEmpty emptyInput

private theorem vacuous_positive_channel (n : ℕ) :
    Nonempty ((Fin (n + 1) → Empty) → PMF (Fin (n + 1) → Empty)) :=
  ⟨PMF.memorylessChannel emptyToEmpty (n + 1)⟩

private theorem no_positive_empty_input_word (n : ℕ) :
    ¬ Nonempty (Fin (n + 1) → Empty) := by
  rintro ⟨x⟩
  exact isEmptyElim (x 0)

private theorem no_positive_empty_word_law (n : ℕ) :
    ¬ Nonempty (PMF (Fin (n + 1) → Empty)) := by
  rintro ⟨p⟩
  obtain ⟨x, _⟩ := p.support_nonempty
  exact no_positive_empty_input_word n ⟨x⟩

private theorem zero_length_does_not_supply_a_base_channel :
    ¬ Nonempty (Unit → PMF Empty) :=
  no_nonempty_input_to_empty_output ()

/-! ## Arbitrary-input joints and independent coordinate-pair products -/

private theorem joint_atom
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i))
    (x : ∀ i, A i) (y : ∀ i, B i) :
    PMF.channelJoint q (PMF.productChannel W) (x, y) =
      q x * ∏ i, W i (x i) (y i) := by
  rw [PMF.channelJoint_apply, PMF.productChannel_apply]

private theorem joint_support
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i))
    (x : ∀ i, A i) (y : ∀ i, B i) :
    (x, y) ∈ (PMF.channelJoint q (PMF.productChannel W)).support ↔
      x ∈ q.support ∧ ∀ i, y i ∈ (W i (x i)).support := by
  rw [PMF.mem_support_channelJoint_iff, PMF.mem_support_productChannel_iff]

private theorem joint_input_marginal
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i)) :
    (PMF.channelJoint q (PMF.productChannel W)).map Prod.fst = q :=
  PMF.channelJoint_map_fst q (PMF.productChannel W)

private theorem joint_output_marginal
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i)) :
    (PMF.channelJoint q (PMF.productChannel W)).map Prod.snd = q.bind (PMF.productChannel W) :=
  PMF.channelJoint_map_snd q (PMF.productChannel W)

private theorem output_eval
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i)) (i : I) :
    (q.bind (PMF.productChannel W)).map (fun y => y i) =
      (q.map (fun x => x i)).bind (W i) := by
  have h := congrArg (fun p => p.map Prod.snd)
    (PMF.channelJoint_productChannel_map_eval q W i)
  simpa only [PMF.map_comp, ← PMF.channelJoint_map_snd, Function.comp_def] using h

private theorem output_restrict
    {I : Type u} {J : Type t} {A : I → Type v} {B : I → Type w}
    [Fintype I] [Fintype J] [∀ i, Fintype (B i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i)) (e : J ↪ I) :
    (q.bind (PMF.productChannel W)).map (fun y j => y (e j)) =
      (q.map (fun x j => x (e j))).bind (PMF.productChannel (fun j => W (e j))) := by
  have h := congrArg (fun p => p.map Prod.snd)
    (PMF.channelJoint_productChannel_map_restrict q W e)
  simpa only [PMF.map_comp, ← PMF.channelJoint_map_snd, Function.comp_def] using h

private theorem joint_sequential
    {I : Type u} {A : I → Type v} {B : I → Type w} {C : I → Type z}
    [Fintype I] [∀ i, Fintype (B i)] [∀ i, Fintype (C i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i)) (V : ∀ i, B i → PMF (C i)) :
    (PMF.channelExtension (PMF.channelJoint q (PMF.productChannel W))
      (PMF.productChannel V)).map (fun xyz => (xyz.1, xyz.2.2)) =
        PMF.channelJoint q (PMF.productChannel (fun i => PMF.channelComp (W i) (V i))) := by
  rw [PMF.channelExtension_map_endpoints, PMF.channelComp_productChannel]

private theorem joint_factorization_inverse
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (p : ∀ i, PMF (A i)) (W : ∀ i, A i → PMF (B i)) :
    (PMF.channelJoint (PMF.finiteProduct p) (PMF.productChannel W)).map
        (Equiv.arrowProdEquivProdArrow I A B).symm =
      PMF.finiteProduct (fun i => PMF.channelJoint (p i) (W i)) := by
  rw [← PMF.finiteProduct_channelJoint_map, PMF.map_comp]
  simp only [Equiv.symm_comp_self, PMF.map_id]

private theorem sparse_joint_factorization :
    (PMF.finiteProduct (fun i => PMF.channelJoint (independentInputs i) (finiteChannels i))).map
      (Equiv.arrowProdEquivProdArrow Bool Output Output) =
        PMF.channelJoint (PMF.finiteProduct independentInputs)
          (PMF.productChannel finiteChannels) :=
  PMF.finiteProduct_channelJoint_map independentInputs finiteChannels

private theorem sparse_joint_inverse :
    (PMF.channelJoint (PMF.finiteProduct independentInputs) (PMF.productChannel finiteChannels)).map
      (Equiv.arrowProdEquivProdArrow Bool Output Output).symm =
        PMF.finiteProduct (fun i => PMF.channelJoint (independentInputs i) (finiteChannels i)) :=
  joint_factorization_inverse independentInputs finiteChannels

private theorem sparse_joint_supported_atom :
    PMF.channelJoint (PMF.finiteProduct independentInputs) (PMF.productChannel finiteChannels)
      (output false 0, output false 1) = ENNReal.ofReal (1 / 16 : ℝ) := by
  rw [joint_atom, PMF.finiteProduct_apply, Fintype.prod_bool, Fintype.prod_bool]
  change (sparse 0 * fair false) * (tritChannel 0 1 * bitChannel false false) = _
  have h02 : (0 : Fin 3) ≠ 2 := by decide
  have h12 : (1 : Fin 3) ≠ 2 := by decide
  norm_num [sparse, fair, tritChannel, bitChannel, PMF.ofFintype_apply,
    ← ENNReal.ofReal_mul, h02, h12]

private theorem sparse_joint_input_zero (y : ∀ i, Output i) :
    PMF.channelJoint (PMF.finiteProduct independentInputs) (PMF.productChannel finiteChannels)
      (output false 2, y) = 0 := by
  rw [joint_atom, PMF.finiteProduct_apply, Fintype.prod_bool]
  change (sparse 2 * fair false) * _ = 0
  simp [sparse, PMF.ofFintype_apply]

private theorem sparse_joint_output_zero :
    PMF.channelJoint (PMF.finiteProduct independentInputs) (PMF.productChannel finiteChannels)
      (output false 0, output false 2) = 0 := by
  rw [joint_atom, Fintype.prod_bool]
  change _ * (tritChannel 0 2 * bitChannel false false) = 0
  simp [tritChannel, sparse, PMF.ofFintype_apply]

private theorem iid_joint {A : Type v} {B : Type w} [Fintype A] [Fintype B]
    (p : PMF A) (W : A → PMF B) (n : ℕ) :
    (PMF.iid (PMF.channelJoint p W) n).map
      (Equiv.arrowProdEquivProdArrow (Fin n) (fun _ => A) (fun _ => B)) =
        PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n) :=
  PMF.finiteProduct_channelJoint_map (fun _ => p) (fun _ => W)

private theorem iid_output {A : Type v} {B : Type w} [Fintype A] [Fintype B]
    (p : PMF A) (W : A → PMF B) (n : ℕ) :
    (PMF.iid p n).bind (PMF.memorylessChannel W n) = PMF.iid (p.bind W) n :=
  PMF.finiteProduct_bind_productChannel (fun _ => p) (fun _ => W)

private theorem iid_joint_inverse {A : Type v} {B : Type w} [Fintype A] [Fintype B]
    (p : PMF A) (W : A → PMF B) (n : ℕ) :
    (PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).map
      (Equiv.arrowProdEquivProdArrow (Fin n) (fun _ => A) (fun _ => B)).symm =
        PMF.iid (PMF.channelJoint p W) n :=
  joint_factorization_inverse (fun _ => p) (fun _ => W)

private theorem iid_joint_zero_inverse :
    (PMF.channelJoint (PMF.iid fair 0) (PMF.memorylessChannel bitChannel 0)).map
      (Equiv.arrowProdEquivProdArrow (Fin 0) (fun _ => Bool) (fun _ => Bool)).symm =
        PMF.iid (PMF.channelJoint fair bitChannel) 0 :=
  iid_joint_inverse fair bitChannel 0

private theorem iid_joint_one_inverse :
    (PMF.channelJoint (PMF.iid fair 1) (PMF.memorylessChannel bitChannel 1)).map
      (Equiv.arrowProdEquivProdArrow (Fin 1) (fun _ => Bool) (fun _ => Bool)).symm =
        PMF.iid (PMF.channelJoint fair bitChannel) 1 :=
  iid_joint_inverse fair bitChannel 1

private theorem iid_joint_zero :
    PMF.channelJoint (PMF.iid fair 0) (PMF.memorylessChannel bitChannel 0) =
      PMF.pure (fun i : Fin 0 => (isEmptyElim i : Bool),
        fun i : Fin 0 => (isEmptyElim i : Bool)) := by
  rw [← iid_joint, PMF.iid, PMF.finiteProduct_of_isEmpty, PMF.pure_map]
  congr 1
  exact Subsingleton.elim _ _

private theorem iid_joint_one :
    (PMF.channelJoint (PMF.iid fair 1) (PMF.memorylessChannel bitChannel 1)).map
      (fun xy => (xy.1 0, xy.2 0)) = PMF.channelJoint fair bitChannel := by
  simpa only [PMF.memorylessChannel, PMF.iid, PMF.finiteProduct_map_eval] using
    PMF.channelJoint_productChannel_map_eval (PMF.iid fair 1) (fun _ : Fin 1 => bitChannel) 0

private theorem iid_output_zero :
    (PMF.iid fair 0).bind (PMF.memorylessChannel bitChannel 0) =
      PMF.pure (fun i : Fin 0 => (isEmptyElim i : Bool)) := by
  rw [iid_output]
  exact PMF.finiteProduct_of_isEmpty _

private theorem iid_output_one :
    ((PMF.iid fair 1).bind (PMF.memorylessChannel bitChannel 1)).map
      (Equiv.funUnique (Fin 1) Bool) = fair.bind bitChannel := by
  rw [iid_output]
  exact PMF.finiteProduct_map_eval _ default

/-! ## Correlated inputs through identity and genuinely noisy channels -/

private def diagonal : PMF (Fin 2 → Bool) := fair.map (fun b _ => b)

private theorem diagonal_eval (i : Fin 2) : diagonal.map (fun x => x i) = fair := by
  rw [diagonal, PMF.map_comp]
  exact PMF.map_id _

private theorem diagonal_constant_atom (b : Bool) :
    diagonal (fun _ => b) = ENNReal.ofReal (1 / 2 : ℝ) := by
  rw [diagonal, PMF.map_apply_of_injective (hf := fun _ _ h => congrFun h 0)]
  rfl

private theorem diagonal_off_atom : diagonal (![false, true]) = 0 := by
  apply PMF.map_apply_eq_zero_of_notMem_range fair
  rintro ⟨b, h⟩
  have h0 : b = false := congrFun h 0
  have h1 : b = true := congrFun h 1
  cases h0.symm.trans h1

private theorem identity_keeps_diagonal :
    diagonal.bind (PMF.memorylessChannel (PMF.deterministicChannel id) 2) = diagonal := by
  rw [repeated_deterministic, PMF.bind_deterministicChannel]
  exact PMF.map_id _

private theorem identity_output_off :
    diagonal.bind (PMF.memorylessChannel (PMF.deterministicChannel id) 2) (![false, true]) = 0 := by
  rw [identity_keeps_diagonal, diagonal_off_atom]

private theorem identity_output_on :
    diagonal.bind (PMF.memorylessChannel (PMF.deterministicChannel id) 2) (fun _ => false) =
      ENNReal.ofReal (1 / 2 : ℝ) := by
  rw [identity_keeps_diagonal, diagonal_constant_atom]

private theorem identity_joint_coordinate (i : Fin 2) :
    (PMF.channelJoint diagonal
      (PMF.memorylessChannel (PMF.deterministicChannel id) 2)).map
        (fun xy => (xy.1 i, xy.2 i)) =
      PMF.channelJoint fair (PMF.deterministicChannel id) := by
  simpa only [PMF.memorylessChannel, diagonal_eval] using PMF.channelJoint_productChannel_map_eval
    diagonal (fun _ : Fin 2 => PMF.deterministicChannel (id : Bool → Bool)) i

private theorem identity_joint_prefix :
    (PMF.channelJoint diagonal
      (PMF.memorylessChannel (PMF.deterministicChannel id) 2)).map
        (fun xy => ((fun i : Fin 1 => xy.1 (Fin.castAdd 1 i)),
          (fun i : Fin 1 => xy.2 (Fin.castAdd 1 i)))) =
      PMF.channelJoint (diagonal.map (fun x (i : Fin 1) => x (Fin.castAdd 1 i)))
        (PMF.memorylessChannel (PMF.deterministicChannel id) 1) :=
  PMF.channelJoint_productChannel_map_restrict diagonal
    (fun _ => PMF.deterministicChannel id) (prefixEmbedding 1 1)

private theorem diagonal_marginal_product_off :
    PMF.finiteProduct (fun i : Fin 2 => diagonal.map (fun x => x i)) (![false, true]) =
      ENNReal.ofReal (1 / 4 : ℝ) := by
  simp only [diagonal_eval, PMF.finiteProduct_apply, Fin.prod_univ_two]
  norm_num [fair, PMF.ofFintype_apply, ← ENNReal.ofReal_mul]

private theorem diagonal_not_product :
    diagonal ≠ PMF.finiteProduct (fun i : Fin 2 => diagonal.map (fun x => x i)) := by
  intro h
  have hm := congrArg (fun p : PMF (Fin 2 → Bool) => p (![false, true])) h
  rw [diagonal_off_atom, diagonal_marginal_product_off] at hm
  norm_num at hm

private def noisyOutput : PMF (Fin 2 → Bool) :=
  diagonal.bind (PMF.memorylessChannel bitChannel 2)

private theorem noisy_joint_coordinate (i : Fin 2) :
    (PMF.channelJoint diagonal (PMF.memorylessChannel bitChannel 2)).map
      (fun xy => (xy.1 i, xy.2 i)) = PMF.channelJoint fair bitChannel := by
  simpa only [PMF.memorylessChannel, diagonal_eval] using
    PMF.channelJoint_productChannel_map_eval diagonal (fun _ : Fin 2 => bitChannel) i

private theorem noisy_joint_prefix :
    (PMF.channelJoint diagonal (PMF.memorylessChannel bitChannel 2)).map
      (fun xy => ((fun i : Fin 1 => xy.1 (Fin.castAdd 1 i)),
        (fun i : Fin 1 => xy.2 (Fin.castAdd 1 i)))) =
      PMF.channelJoint (diagonal.map (fun x (i : Fin 1) => x (Fin.castAdd 1 i)))
        (PMF.memorylessChannel bitChannel 1) :=
  PMF.channelJoint_productChannel_map_restrict diagonal (fun _ => bitChannel) (prefixEmbedding 1 1)

private theorem noisy_output_prefix :
    noisyOutput.map (fun y (i : Fin 1) => y (Fin.castAdd 1 i)) =
      (diagonal.map (fun x (i : Fin 1) => x (Fin.castAdd 1 i))).bind
        (PMF.memorylessChannel bitChannel 1) :=
  output_restrict diagonal (fun _ => bitChannel) (prefixEmbedding 1 1)

private theorem noisy_output_eval (i : Fin 2) :
    noisyOutput.map (fun y => y i) = fair.bind bitChannel := by
  simpa only [noisyOutput, PMF.memorylessChannel, diagonal_eval] using
    output_eval diagonal (fun _ : Fin 2 => bitChannel) i

private theorem noisy_fixed_row (x y : Fin 2 → Bool) :
    PMF.memorylessChannel bitChannel 2 x y = bitChannel (x 0) (y 0) * bitChannel (x 1) (y 1) := by
  rw [repeated_atoms, Fin.prod_univ_two]

private theorem noisy_output_false_false :
    noisyOutput (fun _ => false) = ENNReal.ofReal (1 / 8 : ℝ) := by
  rw [noisyOutput, diagonal, PMF.bind_map, PMF.bind_apply, tsum_fintype, Fintype.sum_bool]
  norm_num [Function.comp_def, noisy_fixed_row, bitChannel, fair, PMF.ofFintype_apply,
    PMF.pure_apply, ← ENNReal.ofReal_mul]

private theorem noisy_marginal_false :
    (fair.bind bitChannel) false = ENNReal.ofReal (1 / 4 : ℝ) := by
  norm_num [PMF.bind_apply, tsum_fintype, Fintype.sum_bool, bitChannel, fair,
    PMF.ofFintype_apply, PMF.pure_apply, ← ENNReal.ofReal_mul]

private theorem noisy_marginal_product_false_false :
    PMF.finiteProduct (fun i : Fin 2 => noisyOutput.map (fun y => y i)) (fun _ => false) =
      ENNReal.ofReal (1 / 16 : ℝ) := by
  simp only [noisy_output_eval, PMF.finiteProduct_apply, Fin.prod_univ_two, noisy_marginal_false]
  norm_num [← ENNReal.ofReal_mul]

private theorem noisy_output_not_product :
    noisyOutput ≠ PMF.finiteProduct (fun i : Fin 2 => noisyOutput.map (fun y => y i)) := by
  intro h
  have hm := congrArg (fun p : PMF (Fin 2 → Bool) => p (fun _ => false)) h
  rw [noisy_output_false_false, noisy_marginal_product_false_false] at hm
  norm_num at hm

/-! ## A noninjective deterministic source-to-word map -/

private theorem source_pushforward {Z : Type u} {X : Type v} {Y : Type w}
    (p : PMF Z) (f : Z → X) (K : X → PMF Y) :
    (p.map f).bind K = p.bind (fun z => K (f z)) :=
  PMF.bind_map p f K

private theorem source_joint {Z : Type u} {X : Type v} {Y : Type w}
    (p : PMF Z) (f : Z → X) (K : X → PMF Y) :
    (PMF.channelJoint p (PMF.channelComp (PMF.deterministicChannel f) K)).map
      (fun zy => (f zy.1, zy.2)) = PMF.channelJoint (p.map f) K := by
  rw [PMF.channelComp_deterministic_left]
  unfold PMF.channelJoint
  rw [PMF.map_bind, PMF.bind_map]
  apply congrArg (PMF.bind p)
  funext z
  rw [PMF.map_comp]
  rfl

private theorem source_extension {Z : Type u} {X : Type v} {Y : Type w}
    (p : PMF Z) (f : Z → X) (K : X → PMF Y) :
    (PMF.channelExtension (PMF.channelJoint p (PMF.deterministicChannel f)) K).map
      (fun zxy => (zxy.1, zxy.2.2)) = PMF.channelJoint p (fun z => K (f z)) := by
  rw [PMF.channelExtension_map_endpoints, PMF.channelComp_deterministic_left]

private def sourceBits : PMF (Bool × Bool) := PMF.channelJoint fair (fun _ => fair)

private def encodeBits (ab : Bool × Bool) : Fin 2 → Bool := fun _ => ab.1

private theorem encoding_pushforward : sourceBits.map encodeBits = diagonal := by
  unfold sourceBits encodeBits diagonal
  have h := congrArg (fun p : PMF Bool => p.map (fun b (_ : Fin 2) => b))
    (PMF.channelJoint_map_fst fair (fun _ => fair))
  simpa only [PMF.map_comp, Function.comp_def] using h

private theorem encoding_supported_collision :
    (false, false) ∈ sourceBits.support ∧ (false, true) ∈ sourceBits.support ∧
      (false, false) ≠ (false, true) ∧ encodeBits (false, false) = encodeBits (false, true) := by
  norm_num [sourceBits, PMF.mem_support_channelJoint_iff, PMF.mem_support_iff,
    fair, PMF.ofFintype_apply, encodeBits]
  rfl

private theorem encoding_nonconstant : encodeBits (false, false) ≠ encodeBits (true, false) := by
  intro h
  have h0 : false = true := congrFun h 0
  cases h0

private theorem encoding_output :
    sourceBits.bind (fun ab => PMF.memorylessChannel bitChannel 2 (encodeBits ab)) =
      noisyOutput := by
  rw [← source_pushforward, encoding_pushforward]
  rfl

private theorem encoding_joint :
    (PMF.channelJoint sourceBits
      (PMF.channelComp (PMF.deterministicChannel encodeBits)
        (PMF.memorylessChannel bitChannel 2))).map
        (fun zy => (encodeBits zy.1, zy.2)) =
      PMF.channelJoint diagonal (PMF.memorylessChannel bitChannel 2) := by
  rw [source_joint, encoding_pushforward]

private theorem encoding_extension_endpoints :
    (PMF.channelExtension (PMF.channelJoint sourceBits (PMF.deterministicChannel encodeBits))
      (PMF.memorylessChannel bitChannel 2)).map (fun zxy => (zxy.1, zxy.2.2)) =
        PMF.channelJoint sourceBits
          (fun ab => PMF.memorylessChannel bitChannel 2 (encodeBits ab)) :=
  source_extension sourceBits encodeBits (PMF.memorylessChannel bitChannel 2)

private theorem encoding_extension_word_output :
    (PMF.channelExtension (PMF.channelJoint sourceBits (PMF.deterministicChannel encodeBits))
      (PMF.memorylessChannel bitChannel 2)).map Prod.snd =
        PMF.channelJoint diagonal (PMF.memorylessChannel bitChannel 2) := by
  rw [PMF.channelExtension_map_outputPair, PMF.channelJoint_map_snd,
    PMF.bind_deterministicChannel, encoding_pushforward]

end

end LeanInfoTheory.Examples.ProductChannel
