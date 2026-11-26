/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceChannelCode
import LeanInfoTheory.Examples.ChannelCodeExpurgation
import Batteries.Tactic.OpenPrivate

/-!
# Block reconstruction under the actual source and channel law

The source word remains the first coordinate through encoding and transmission.
Projecting that coordinate through the encoder gives the input/output joint law
even when distinct source words give the same input word.
-/

namespace LeanInfoTheory.Examples.SourceChannelCode

open LeanInfoTheory.Shannon
open scoped BigOperators ENNReal

noncomputable section

universe u v w

variable {S : Type u} {X : Type v} {Y : Type w} [Fintype S] [Fintype Y]

private abbrev joint (p : PMF S) (W : X → PMF Y) (n : ℕ)
    (E : (Fin n → S) → (Fin n → X)) :=
  PMF.channelJoint (PMF.iid p n) (fun s => PMF.memorylessChannel W n (E s))

section

variable (p : PMF S) (W : X → PMF Y) (n : ℕ) (E : (Fin n → S) → (Fin n → X))
  (D : (Fin n → Y) → (Fin n → S))

example (s : Fin n → S) (y : Fin n → Y) :
    joint p W n E (s, y) = PMF.iid p n s * PMF.memorylessChannel W n (E s) y :=
  PMF.channelJoint_apply _ _ _ _

example : (joint p W n E).map Prod.fst = PMF.iid p n :=
  PMF.channelJoint_map_fst _ _

open scoped Classical in
example : sourceChannelErrorProbability p W n E D =
    ∑ z : (Fin n → S) × (Fin n → Y),
      if D z.2 ≠ z.1 then
        (PMF.iid p n z.1 * PMF.memorylessChannel W n (E z.1) z.2).toReal else 0 := by
  rw [sourceChannelErrorProbability, decodingErrorProbability_eq_sum]
  apply Finset.sum_congr rfl
  rintro ⟨s, y⟩ _
  simp only [PMF.channelJoint_apply]

example : condEntropy (joint p W n E) ≤ Real.log 2 +
    sourceChannelErrorProbability p W n E D * Real.log (Fintype.card (Fin n → S) : ℝ) :=
  condEntropy_fano_weak _ D

example : (joint p W n E).map (fun z => (E z.1, z.2)) =
    PMF.channelJoint ((PMF.iid p n).map E) (PMF.memorylessChannel W n) := by
  simp only [joint, PMF.channelJoint, PMF.map_bind, PMF.bind_map, PMF.map_comp,
    Function.comp_def]

example : sourceChannelErrorProbability p W n E D ∈ Set.Icc (0 : ℝ) 1 :=
  ⟨decodingErrorProbability_nonneg _ _, decodingErrorProbability_le_one _ _⟩

end

private theorem error_eq_zero_of_subsingleton_word
    (p : PMF S) (W : X → PMF Y) (n : ℕ) [Subsingleton (Fin n → S)]
    (E : (Fin n → S) → (Fin n → X)) (D : (Fin n → Y) → (Fin n → S)) :
    sourceChannelErrorProbability p W n E D = 0 := by
  classical
  rw [sourceChannelErrorProbability, decodingErrorProbability_eq_sum]
  exact Finset.sum_eq_zero fun z _ => if_neg (not_not_intro (Subsingleton.elim (D z.2) z.1))

example (p : PMF S) (W : X → PMF Y)
    (E : (Fin 0 → S) → (Fin 0 → X)) (D : (Fin 0 → Y) → (Fin 0 → S)) :
    sourceChannelErrorProbability p W 0 E D = 0 :=
  error_eq_zero_of_subsingleton_word p W 0 E D

example [Subsingleton S] (p : PMF S) (W : X → PMF Y) (n : ℕ)
    (E : (Fin n → S) → (Fin n → X)) (D : (Fin n → Y) → (Fin n → S)) :
    sourceChannelErrorProbability p W n E D = 0 :=
  error_eq_zero_of_subsingleton_word p W n E D

/-! Both length-one Boolean words have positive source probability. The encoder
sends both to the unique input symbol. Its deterministic channel row emits
symbol zero. The decoder also assigns a reconstruction to the impossible one. -/

private abbrev boolWord (b : Bool) : Fin 1 → Bool := fun _ => b
private abbrev outWord (y : Fin 2) : Fin 1 → Fin 2 := fun _ => y
private def merge (_ : Fin 1 → Bool) : Fin 1 → Unit := fun _ => ()
private def row (_ : Unit) : PMF (Fin 2) := PMF.pure 0
private def reconstruct (y : Fin 1 → Fin 2) : Fin 1 → Bool := boolWord (decide (y 0 = 1))

example : boolWord false ≠ boolWord true ∧ merge (boolWord false) = merge (boolWord true) :=
  ⟨fun h => Bool.false_ne_true (congrFun h 0), rfl⟩

private theorem joint_atoms (b : Bool) :
    joint (PMF.uniformOfFintype Bool) row 1 merge (boolWord b, outWord 0) = (2 : ℝ≥0∞)⁻¹ ∧
    joint (PMF.uniformOfFintype Bool) row 1 merge (boolWord b, outWord 1) = 0 := by
  simp [joint, PMF.channelJoint_apply, PMF.iid, PMF.finiteProduct_apply,
    PMF.memorylessChannel, PMF.productChannel_apply, row, PMF.pure_apply,
    PMF.uniformOfFintype_apply, outWord]

example : reconstruct (outWord 0) = boolWord false ∧ reconstruct (outWord 1) = boolWord true :=
  ⟨rfl, rfl⟩

example : sourceChannelErrorProbability (PMF.uniformOfFintype Bool) row 1 merge reconstruct =
    1 / 2 := by
  classical
  have sumSource (f : (Fin 1 → Bool) → ℝ) :
      (∑ s, f s) = f (boolWord true) + f (boolWord false) := by
    rw [← (Equiv.funUnique (Fin 1) Bool).symm.sum_comp f, Fintype.sum_bool]
    rfl
  have sumOutput (f : (Fin 1 → Fin 2) → ℝ) :
      (∑ y, f y) = f (outWord 0) + f (outWord 1) := by
    rw [← (Equiv.funUnique (Fin 1) (Fin 2)).symm.sum_comp f, Fin.sum_univ_two]
    rfl
  change decodingErrorProbability (joint (PMF.uniformOfFintype Bool) row 1 merge) reconstruct = _
  rw [decodingErrorProbability_eq_sum, Fintype.sum_prod_type, sumSource]
  simp only [sumOutput, (joint_atoms true).1, (joint_atoms true).2,
    (joint_atoms false).1, (joint_atoms false).2]
  norm_num [reconstruct, boolWord, outWord, ENNReal.toReal_inv]
  exact fun h => Bool.false_ne_true (congrFun h 0)

end

/-! ## Restricting the channel code to the source budget -/

namespace Restriction

noncomputable section

universe u v w

variable {S : Type u} {X : Type v} {Y : Type w} {n K L : ℕ}

example (c : BlockChannelCode X Y n L) (i : Fin K ↪ Fin L) (j₀ : Fin K) :
    (∀ j, (c.restrictMessages i j₀).encoder j = c.encoder (i j)) ∧
      (∀ y j, c.decoder y = i j → (c.restrictMessages i j₀).decoder y = j) ∧
      (∀ y, c.decoder y ∉ Set.range i → (c.restrictMessages i j₀).decoder y = j₀) :=
  ⟨fun _ => rfl, c.restrictMessages_decoder_of_eq i j₀,
    fun y hy => Function.extend_apply' (f := i) id (fun _ => j₀) (c.decoder y) hy⟩

/-- At equal budgets, retaining each label under its original name preserves
both maps on their whole domains. -/
example (c : BlockChannelCode X Y n K) (j₀ : Fin K) :
    c.restrictMessages (Function.Embedding.refl _) j₀ = c := by
  apply Prod.ext
  · rfl
  · funext y
    exact c.restrictMessages_decoder_of_eq _ j₀ y (c.decoder y) rfl

private abbrev embeddedMaximum [Fintype Y] (c : BlockChannelCode X Y n L)
    (W : X → PMF Y) (i : Fin K ↪ Fin L) (j₀ : Fin K) : ℝ :=
  Finset.univ.sup' ⟨j₀, Finset.mem_univ _⟩ (fun j => c.messageErrorProbability W (i j))

example [Fintype S] [Fintype Y] (p : PMF S) (W : X → PMF Y)
    (a : BlockSourceCode S n K) (c : BlockChannelCode X Y n L)
    (i : Fin K ↪ Fin L) (j₀ : Fin K) (hK : 1 ≤ K) (hL : 1 ≤ L) :
    let b := c.restrictMessages i j₀
    let q := PMF.iid p n
    let π := q.map a.encoder
    let pe := sourceChannelErrorProbability p W n (b.encoder ∘ a.encoder) (a.decoder ∘ b.decoder)
    let ps := a.errorProbability q
    let weighted := ∑ j, (π j).toReal * c.messageErrorProbability W (i j)
    let onImage := embeddedMaximum c W i j₀
    pe ≤ ps + b.errorProbabilityWithPrior W π ∧
      ps + b.errorProbabilityWithPrior W π ≤ ps + b.maximalErrorProbability W hK ∧
      ps + b.errorProbabilityWithPrior W π ≤ ps + weighted ∧
      ps + weighted ≤ ps + onImage ∧
      ps + onImage ≤ ps + c.maximalErrorProbability W hL ∧
      b.maximalErrorProbability W hK ≤ c.maximalErrorProbability W hL := by
  dsimp only
  let b := c.restrictMessages i j₀
  let π := (PMF.iid p n).map a.encoder
  have row_le_embedded (j : Fin K) : c.messageErrorProbability W (i j) ≤ embeddedMaximum c W i j₀ :=
    Finset.le_sup' (fun k => c.messageErrorProbability W (i k)) (Finset.mem_univ j)
  have row_le_full := (c.maximalErrorProbability_le_iff W hL _).mp le_rfl
  refine ⟨sourceChannelErrorProbability_comp_le p W a b,
    add_le_add le_rfl (b.errorProbabilityWithPrior_le_maximalErrorProbability W π hK),
    add_le_add le_rfl ?_, add_le_add le_rfl ?_, add_le_add le_rfl ?_, ?_⟩
  · rw [BlockChannelCode.errorProbabilityWithPrior_eq_sum]
    exact Finset.sum_le_sum fun j _ =>
      mul_le_mul_of_nonneg_left (c.messageErrorProbability_restrictMessages_le W i j₀ j)
        (π.toReal_nonneg j)
  · calc
      ∑ j, (π j).toReal * c.messageErrorProbability W (i j) ≤
          ∑ j, (π j).toReal * embeddedMaximum c W i j₀ :=
        Finset.sum_le_sum fun j _ =>
          mul_le_mul_of_nonneg_left (row_le_embedded j) (π.toReal_nonneg j)
      _ = embeddedMaximum c W i j₀ := by rw [← Finset.sum_mul, π.sum_toReal, one_mul]
  · exact Finset.sup'_le _ _ fun j _ => row_le_full (i j)
  · apply (b.maximalErrorProbability_le_iff W hK _).mpr
    exact fun j =>
      (c.messageErrorProbability_restrictMessages_le W i j₀ j).trans (row_le_full (i j))

open private collision collision_rows from LeanInfoTheory.Examples.ChannelCodeExpurgation

private abbrev noiseless := (PMF.pure : Fin 3 → PMF (Fin 3))
private abbrev keep : Fin 2 ↪ Fin 4 := Fin.castLEEmb (by decide)

example : embeddedMaximum collision noiseless keep 0 = 0 ∧
    collision.maximalErrorProbability noiseless (by decide) = 1 := by
  have retained (j : Fin 2) : collision.messageErrorProbability noiseless (keep j) = 0 := by
    rw [collision_rows, if_neg]
    fin_cases j <;> decide
  constructor
  · apply le_antisymm
    · exact Finset.sup'_le _ _ fun j _ => (retained j).le
    · rw [← retained 0]
      exact Finset.le_sup' (fun j => collision.messageErrorProbability noiseless (keep j))
        (Finset.mem_univ 0)
  · apply le_antisymm
    · apply (collision.maximalErrorProbability_le_iff noiseless _ _).mpr
      intro j
      rw [collision_rows]
      split <;> norm_num
    · have h := (collision.maximalErrorProbability_le_iff noiseless (by decide) _).mp le_rfl 3
      simpa [collision_rows] using h

example (j₀ : Fin 2) :
    let y : Fin 1 → Fin 3 := fun _ => 2
    let b := collision.restrictMessages keep j₀
    collision.decoder y = 2 ∧ collision.decoder y ∉ Set.range keep ∧ b.decoder y = j₀ ∧
      ∀ j, PMF.memorylessChannel noiseless 1 (b.encoder j) y = 0 := by
  dsimp only
  have off : collision.decoder (fun _ => 2) ∉ Set.range keep := by decide
  refine ⟨rfl, off, Function.extend_apply' (f := keep) id (fun _ => j₀) _ off, ?_⟩
  intro j
  change PMF.memorylessChannel noiseless 1 (collision.encoder (keep j)) (fun _ => 2) = 0
  have rows : PMF.memorylessChannel noiseless 1 = PMF.pure :=
    PMF.productChannel_deterministicChannel (fun _ : Fin 1 => id (α := Fin 3))
  rw [rows, PMF.pure_apply_of_ne]
  intro h
  have hcoord := congrFun h 0
  fin_cases j <;> contradiction

end

end Restriction

/-! ## Uniform error can underestimate reconstruction error -/

namespace Collision

open private collision collision_rows collision_mean
  from LeanInfoTheory.Examples.ChannelCodeExpurgation

private noncomputable abbrev p := PMF.pure (3 : Fin 4)
private noncomputable abbrev W := (PMF.pure : Fin 3 → PMF (Fin 3))
private abbrev identitySource : BlockSourceCode (Fin 4) 1 4 :=
  (fun s => s 0, fun j _ => j)

private theorem identity_recovers (s : Fin 1 → Fin 4) :
    identitySource.decoder (identitySource.encoder s) = s := by
  funext i
  exact congrArg s (Subsingleton.elim 0 i)

private theorem source_word_law :
    PMF.iid p 1 = PMF.pure (fun _ : Fin 1 => (3 : Fin 4)) :=
  PMF.finiteProduct_pure _

private theorem induced_prior : (PMF.iid p 1).map identitySource.encoder = PMF.pure 3 := by
  rw [source_word_law, PMF.pure_map]

private theorem source_error : identitySource.errorProbability (PMF.iid p 1) = 0 := by
  rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure,
    source_word_law, PMF.toOuterMeasure_pure_apply]
  simp [identity_recovers]

private theorem prior_error :
    collision.errorProbabilityWithPrior W ((PMF.iid p 1).map identitySource.encoder) = 1 := by
  rw [induced_prior, collision.errorProbabilityWithPrior_pure, collision_rows]
  norm_num

private abbrev encode := collision.encoder ∘ identitySource.encoder
private abbrev reconstruct := identitySource.decoder ∘ collision.decoder

private theorem joint_law :
    PMF.channelJoint (PMF.iid p 1) (fun s => PMF.memorylessChannel W 1 (encode s)) =
      PMF.pure ((fun _ : Fin 1 => (3 : Fin 4)), (fun _ : Fin 1 => (2 : Fin 3))) := by
  have rows : PMF.memorylessChannel W 1 = PMF.pure :=
    PMF.productChannel_deterministicChannel (fun _ : Fin 1 => id (α := Fin 3))
  rw [source_word_law, PMF.channelJoint, PMF.pure_bind, rows, PMF.pure_map]
  rfl

private theorem reconstruction_error :
    sourceChannelErrorProbability p W 1 encode reconstruct = 1 := by
  have decoded : reconstruct (fun _ => 2) = (fun _ : Fin 1 => (2 : Fin 4)) := rfl
  have mismatch : reconstruct (fun _ => 2) ≠ (fun _ : Fin 1 => (3 : Fin 4)) := by
    rw [decoded]
    decide
  rw [sourceChannelErrorProbability, joint_law, decodingErrorProbability, PMF.pure_map]
  rw [(decodingErrorIndicator_eq_true_iff _ _ _).mpr mismatch]
  simp

/-- The finite theorem gives the correct induced-prior bound. Using the
uniform error instead would bound unit reconstruction error by one quarter. -/
example :
    let e := sourceChannelErrorProbability p W 1 encode reconstruct
    let es := identitySource.errorProbability (PMF.iid p 1)
    let eu := collision.errorProbability W (by decide)
    let eπ := collision.errorProbabilityWithPrior W ((PMF.iid p 1).map identitySource.encoder)
    es = 0 ∧ eu = 1 / 4 ∧ eπ = 1 ∧ e = 1 ∧ e ≤ es + eπ ∧ es + eu < e := by
  dsimp only
  refine ⟨source_error, collision_mean, prior_error, reconstruction_error,
    sourceChannelErrorProbability_comp_le p W identitySource collision, ?_⟩
  rw [source_error, collision_mean, reconstruction_error]
  norm_num

end Collision

/-! ## A channel mistake can repair a compression mistake

At length one write the three source symbols as 0, 1 and 2. The compressor
sends 0 and 1 to the never-decoded channel index 3. The old decoder returns 2
instead, which the total source decoder interprets as source symbol 1.
-/

namespace Repair

noncomputable section

open private collision collision_rows from LeanInfoTheory.Examples.ChannelCodeExpurgation

private abbrev Word := Fin 1 → Fin 3
private def word (a : Fin 3) : Word := fun _ => a
private def mass : Fin 3 → ℝ := ![1 / 8, 3 / 8, 4 / 8]
private theorem mass_nonneg (a : Fin 3) : 0 ≤ mass a := by
  fin_cases a <;> norm_num [mass]

private def source : PMF (Fin 3) := PMF.ofFintype (fun a => ENNReal.ofReal (mass a)) (by
  rw [← ENNReal.ofReal_sum_of_nonneg (fun a _ => mass_nonneg a), Fin.sum_univ_three]
  change ENNReal.ofReal (1 / 8 + 3 / 8 + 4 / 8 : ℝ) = 1
  norm_num)

private def compressor : BlockSourceCode (Fin 3) 1 4 :=
  (fun s => ![3, 3, 0] (s 0), fun j => word (![2, 2, 1, 0] j))

private abbrev q := PMF.iid source 1
private abbrev prior := q.map compressor.encoder
private abbrev W := (PMF.pure : Fin 3 → PMF (Fin 3))
private abbrev E := collision.encoder ∘ compressor.encoder
private abbrev D := compressor.decoder ∘ collision.decoder
private abbrev J := PMF.channelJoint q (fun s => PMF.memorylessChannel W 1 (E s))

private theorem decisions (a : Fin 3) :
    compressor.decoder (compressor.encoder (word a)) = word (![0, 0, 2] a) ∧
      collision.decoder (E (word a)) = (![2, 2, 0] : Fin 3 → Fin 4) a ∧
      D (E (word a)) = word (![1, 1, 2] a) := by
  fin_cases a <;> exact ⟨rfl, rfl, rfl⟩

private theorem failure_sets (a : Fin 3) :
    (compressor.decoder (compressor.encoder (word a)) ≠ word a ↔ a = 1) ∧
      (collision.decoder (E (word a)) ≠ compressor.encoder (word a) ↔ a = 0 ∨ a = 1) ∧
      (D (E (word a)) ≠ word a ↔ a = 0) := by
  rw [(decisions a).1, (decisions a).2.1, (decisions a).2.2]
  fin_cases a <;> decide

private theorem sum_words (f : Word → ℝ) :
    (∑ s, f s) = f (word 0) + f (word 1) + f (word 2) := by
  rw [← (Equiv.funUnique (Fin 1) (Fin 3)).symm.sum_comp f, Fin.sum_univ_three]
  rfl

private theorem source_atom (a : Fin 3) : (q (word a)).toReal = mass a := by
  change (PMF.finiteProduct (fun _ : Fin 1 => source) (word a)).toReal = _
  rw [PMF.finiteProduct_apply, Fin.prod_univ_one]
  exact ENNReal.toReal_ofReal (mass_nonneg a)

/-- The mass assigned to a label adds the masses of all words mapped there. -/
private theorem map_atom {T : Type} [DecidableEq T] (f : Word → T) (t : T) :
    ((q.map f) t).toReal =
      (if f (word 0) = t then mass 0 else 0) +
      (if f (word 1) = t then mass 1 else 0) +
      (if f (word 2) = t then mass 2 else 0) := by
  change ((q.bind (PMF.pure ∘ f)) t).toReal = _
  rw [PMF.bind_toReal_apply, sum_words]
  have term (a : Fin 3) : (q (word a)).toReal * ((PMF.pure (f (word a))) t).toReal =
      (if f (word a) = t then mass a else 0) := by
    by_cases h : f (word a) = t
    · simp [h, source_atom]
    · simp [PMF.pure_apply, h, Ne.symm h]
  exact congrArg₂ (· + ·) (congrArg₂ (· + ·) (term 0) (term 1)) (term 2)

private theorem prior_atoms (j : Fin 4) :
    (prior j).toReal = (![4 / 8, 0, 0, 4 / 8] : Fin 4 → ℝ) j := by
  rw [map_atom]
  change (if (3 : Fin 4) = j then (1 / 8 : ℝ) else 0) +
    (if (3 : Fin 4) = j then 3 / 8 else 0) + (if (0 : Fin 4) = j then 4 / 8 else 0) = _
  fin_cases j <;> norm_num [Fin.isValue, Fin.reduceFinMk, Matrix.cons_val, Fin.ext_iff]

private theorem joint_graph : J = q.map (fun s => (s, E s)) := by
  have rows : PMF.memorylessChannel W 1 = PMF.pure :=
    PMF.productChannel_deterministicChannel (fun _ : Fin 1 => id (α := Fin 3))
  unfold J
  rw [rows]
  exact PMF.channelJoint_deterministicChannel q E

example : (prior 2).toReal = 0 ∧
    ((J.map (fun z => collision.decoder z.2)) 2).toReal = 4 / 8 := by
  refine ⟨prior_atoms 2, ?_⟩
  rw [joint_graph, PMF.map_comp]
  change ((q.map (fun s => collision.decoder (E s))) 2).toReal = _
  rw [map_atom]
  simp only [(decisions _).2.1]
  change (if (2 : Fin 4) = 2 then (1 / 8 : ℝ) else 0) +
    (if (2 : Fin 4) = 2 then 3 / 8 else 0) + (if (0 : Fin 4) = 2 then 4 / 8 else 0) = _
  norm_num [Fin.ext_iff]

private theorem error_eq_mapped_indicator {T : Type} (f : Word → T) (d : T → Word) :
    decodingErrorProbabilityOf q id f d =
      ((q.map (fun s => decodingErrorIndicator d s (f s))) true).toReal := by
  unfold decodingErrorProbabilityOf decodingErrorProbability
  rw [PMF.map_comp]
  rfl

private theorem source_error : compressor.errorProbability q = 3 / 8 := by
  rw [SourceCode.errorProbability, error_eq_mapped_indicator, map_atom]
  simp only [decodingErrorIndicator_eq_true_iff, (failure_sets _).1]
  norm_num [mass, Fin.ext_iff]

private theorem channel_error : collision.errorProbabilityWithPrior W prior = 4 / 8 := by
  rw [collision.errorProbabilityWithPrior_eq_sum]
  simp only [collision_rows, mul_ite, mul_one, mul_zero, Finset.sum_ite_eq',
    Finset.mem_univ, if_true]
  exact prior_atoms 3

private theorem reconstruction_error : sourceChannelErrorProbability source W 1 E D = 1 / 8 := by
  change decodingErrorProbability J D = _
  rw [joint_graph]
  change decodingErrorProbabilityOf q id E D = _
  rw [error_eq_mapped_indicator, map_atom]
  simp only [decodingErrorIndicator_eq_true_iff, (failure_sets _).2.2]
  norm_num [mass, Fin.ext_iff]

example : sourceChannelErrorProbability source W 1 E D ≤
      compressor.errorProbability q + collision.errorProbabilityWithPrior W prior ∧
    sourceChannelErrorProbability source W 1 E D <
      compressor.errorProbability q + collision.errorProbabilityWithPrior W prior := by
  refine ⟨sourceChannelErrorProbability_comp_le source W compressor collision, ?_⟩
  rw [source_error, channel_error, reconstruction_error]
  norm_num

end

end Repair

end LeanInfoTheory.Examples.SourceChannelCode
