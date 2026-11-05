/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.Iid

/-!
# Homogeneous block and iid consumers

These private consumers use the focused probability owner. Generic product
laws supply iid atoms, support, coordinates and injective selection. Concrete
fair and sparse laws exercise a nonidentity permutation and impossible words.
A non-iid three-coordinate law is split into a prefix of length one and a
suffix of length two, then reconstructed through the public block interfaces.
Empty sides, zero and one lengths, pure sources and empty alphabets are explicit.
-/

namespace LeanInfoTheory.Examples.Iid

noncomputable section

universe u

open scoped BigOperators ENNReal

/-! ## Component laws and inherited iid probability laws -/

private theorem half_mass_add :
    ENNReal.ofReal (1 / 2 : ℝ) + ENNReal.ofReal (1 / 2 : ℝ) = 1 := by
  rw [← ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1 / 2)
    (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  norm_num

private def fair : PMF Bool :=
  PMF.ofFintype (fun _ => ENNReal.ofReal (1 / 2 : ℝ))
    (by rw [Fintype.sum_bool]; exact half_mass_add)

private def biased : PMF Bool :=
  PMF.ofFintype (fun b => ENNReal.ofReal (if b then (1 / 4 : ℝ) else 3 / 4))
    (by
      rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
      norm_num)

private def sparse : PMF (Fin 3) :=
  PMF.ofFintype
    (fun a => if a = 2 then 0 else ENNReal.ofReal (1 / 2 : ℝ))
    (by simpa [Fin.sum_univ_three] using half_mass_add)

private theorem biased_ne_fair : biased ≠ fair := by
  intro h
  have hm := congrArg (fun p : PMF Bool => (p true).toReal) h
  norm_num [biased, fair, PMF.ofFintype_apply] at hm

private theorem iid_atoms {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) (x : Fin n → A) :
    PMF.iid p n x = ∏ i : Fin n, p (x i) :=
  PMF.finiteProduct_apply (fun _ : Fin n => p) x

private theorem iid_support {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) (x : Fin n → A) :
    x ∈ (PMF.iid p n).support ↔ ∀ i, x i ∈ p.support :=
  PMF.mem_support_finiteProduct_iff (fun _ : Fin n => p) x

private theorem iid_coordinate {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) (i : Fin n) :
    (PMF.iid p n).map (fun x => x i) = p :=
  PMF.finiteProduct_map_eval (fun _ : Fin n => p) i

private theorem fair_two_atoms (x : Fin 2 → Bool) :
    PMF.iid fair 2 x = ENNReal.ofReal (1 / 4 : ℝ) := by
  rw [iid_atoms, Fin.prod_univ_two]
  change ENNReal.ofReal (1 / 2 : ℝ) * ENNReal.ofReal (1 / 2 : ℝ) = _
  rw [← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  congr 1
  norm_num

private theorem fair_two_support (x : Fin 2 → Bool) :
    x ∈ (PMF.iid fair 2).support := by
  apply (iid_support fair 2 x).2
  intro i
  change fair (x i) ≠ 0
  norm_num [fair, PMF.ofFintype_apply]

private theorem fair_coordinate (i : Fin 3) :
    (PMF.iid fair 3).map (fun x => x i) = fair :=
  iid_coordinate fair 3 i

private theorem sparse_support (n : ℕ) (x : Fin n → Fin 3) :
    x ∈ (PMF.iid sparse n).support ↔ ∀ i, x i ≠ 2 := by
  rw [iid_support]
  constructor
  · intro h i hi
    have hz := h i
    rw [hi] at hz
    change sparse 2 ≠ 0 at hz
    norm_num [sparse, PMF.ofFintype_apply] at hz
  · intro h i
    change sparse (x i) ≠ 0
    simp [sparse, PMF.ofFintype_apply, h i]

private theorem sparse_coordinate (i : Fin 3) :
    (PMF.iid sparse 3).map (fun x => x i) = sparse :=
  iid_coordinate sparse 3 i

/-! ## Nonidentity permutations and injective block selection -/

private def exchangeEnds : Equiv.Perm (Fin 3) := Equiv.swap 0 2

private theorem exchangeEnds_moves_zero : exchangeEnds 0 = 2 :=
  Equiv.swap_apply_left 0 2

private theorem exchangeEnds_nonidentity : exchangeEnds ≠ Equiv.refl (Fin 3) := by
  intro h
  have h0 := congrArg (fun e : Equiv.Perm (Fin 3) => e 0) h
  rw [exchangeEnds_moves_zero] at h0
  exact (by decide : (2 : Fin 3) ≠ 0) h0

private theorem sparse_permutation :
    (PMF.iid sparse 3).map (fun x i => x (exchangeEnds i)) = PMF.iid sparse 3 :=
  PMF.iid_map_perm sparse 3 exchangeEnds

private def selectTail : Fin 2 ↪ Fin 3 where
  toFun := Fin.natAdd 1
  inj' i j h := by
    apply Fin.ext
    exact Nat.add_left_cancel (congrArg Fin.val h)

private theorem selectTail_orientation : selectTail 0 = 1 ∧ selectTail 1 = 2 :=
  ⟨rfl, rfl⟩

private theorem iid_selection {A : Type u} [Fintype A]
    (p : PMF A) {m n : ℕ} (e : Fin m ↪ Fin n) :
    (PMF.iid p n).map (fun x i => x (e i)) = PMF.iid p m :=
  PMF.finiteProduct_map_restrict (fun _ : Fin n => p) e

private theorem sparse_tail_selection :
    (PMF.iid sparse 3).map (fun x i => x (selectTail i)) = PMF.iid sparse 2 :=
  iid_selection sparse selectTail

/-! ## A non-iid length-three block and its ordered split -/

private def prefixLaws : Fin 1 → PMF Bool := fun _ => fair

private def suffixLaws : Fin 2 → PMF Bool := ![biased, fair]

private def blockComponents : Fin 3 → PMF Bool := Fin.append prefixLaws suffixLaws

private def block : PMF (Fin 3 → Bool) := PMF.finiteProduct blockComponents

private theorem block_components :
    blockComponents 0 = fair ∧ blockComponents 1 = biased ∧
      blockComponents 2 = fair :=
  ⟨rfl, rfl, rfl⟩

private theorem block_not_identical : blockComponents 1 ≠ blockComponents 0 :=
  biased_ne_fair

private theorem noniid_split :
    block.map (Fin.appendEquiv 1 2).symm =
      PMF.channelJoint (PMF.finiteProduct prefixLaws)
        (fun _ => PMF.finiteProduct suffixLaws) := by
  change (PMF.finiteProduct (Fin.append prefixLaws suffixLaws)).map
    (Fin.appendEquiv 1 2).symm = _
  simpa only [Fin.append_left, Fin.append_right] using
    PMF.finiteProduct_map_append_symm 1 2 (Fin.append prefixLaws suffixLaws)

private theorem noniid_concatenate :
    (PMF.channelJoint (PMF.finiteProduct prefixLaws)
        (fun _ => PMF.finiteProduct suffixLaws)).map (Fin.appendEquiv 1 2) = block :=
  PMF.channelJoint_finiteProduct_map_append prefixLaws suffixLaws

private theorem noniid_split_round_trip :
    (block.map (Fin.appendEquiv 1 2).symm).map (Fin.appendEquiv 1 2) = block := by
  have h := congrArg
    (fun p : PMF ((Fin 1 → Bool) × (Fin 2 → Bool)) => p.map (Fin.appendEquiv 1 2))
    noniid_split
  exact h.trans noniid_concatenate

private theorem split_coordinate_orientation (x : Fin 3 → Bool) :
    ((Fin.appendEquiv 1 2).symm x).1 0 = x 0 ∧
      ((Fin.appendEquiv 1 2).symm x).2 0 = x 1 ∧
      ((Fin.appendEquiv 1 2).symm x).2 1 = x 2 :=
  ⟨rfl, rfl, rfl⟩

/-! ## Iid specialization, empty sides and degenerate lengths -/

private theorem iid_split {A : Type u} [Fintype A]
    (p : PMF A) (m n : ℕ) :
    (PMF.iid p (m + n)).map (Fin.appendEquiv m n).symm =
      PMF.channelJoint (PMF.iid p m) (fun _ => PMF.iid p n) :=
  PMF.finiteProduct_map_append_symm m n (fun _ : Fin (m + n) => p)

private theorem iid_concatenate {A : Type u} [Fintype A]
    (p : PMF A) (m n : ℕ) :
    (PMF.channelJoint (PMF.iid p m) (fun _ => PMF.iid p n)).map
        (Fin.appendEquiv m n) = PMF.iid p (m + n) := by
  have h := PMF.channelJoint_finiteProduct_map_append
    (fun _ : Fin m => p) (fun _ : Fin n => p)
  have hc : Fin.append (fun _ : Fin m => p) (fun _ : Fin n => p) =
      (fun _ : Fin (m + n) => p) :=
    Fin.append_castAdd_natAdd (f := fun _ : Fin (m + n) => p)
  rw [hc] at h
  exact h

private theorem sparse_split_one_two :
    (PMF.iid sparse 3).map (Fin.appendEquiv 1 2).symm =
      PMF.channelJoint (PMF.iid sparse 1) (fun _ => PMF.iid sparse 2) :=
  iid_split sparse 1 2

private theorem sparse_concatenate_one_two :
    (PMF.channelJoint (PMF.iid sparse 1) (fun _ => PMF.iid sparse 2)).map
        (Fin.appendEquiv 1 2) = PMF.iid sparse 3 :=
  iid_concatenate sparse 1 2

private theorem iid_zero {A : Type u} [Fintype A] (p : PMF A) :
    PMF.iid p 0 = PMF.pure (fun i : Fin 0 => (isEmptyElim i : A)) :=
  PMF.finiteProduct_of_isEmpty (fun _ : Fin 0 => p)

private theorem iid_one_eval {A : Type u} [Fintype A] (p : PMF A) :
    (PMF.iid p 1).map (Equiv.funUnique (Fin 1) A) = p :=
  PMF.finiteProduct_map_eval (fun _ : Fin 1 => p) default

private theorem iid_one_rebuild {A : Type u} [Fintype A] (p : PMF A) :
    p.map (Equiv.funUnique (Fin 1) A).symm = PMF.iid p 1 := by
  have h := congrArg (fun q : PMF A => q.map (Equiv.funUnique (Fin 1) A).symm)
    (iid_one_eval p)
  simpa only [PMF.map_comp, Equiv.symm_comp_self, PMF.map_id] using h.symm

private theorem split_empty_prefix {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) :
    (PMF.iid p (0 + n)).map (Fin.appendEquiv 0 n).symm =
      PMF.channelJoint (PMF.pure (fun i : Fin 0 => (isEmptyElim i : A)))
        (fun _ => PMF.iid p n) := by
  rw [iid_split, iid_zero]

private theorem split_empty_suffix {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) :
    (PMF.iid p (n + 0)).map (Fin.appendEquiv n 0).symm =
      PMF.channelJoint (PMF.iid p n)
        (fun _ => PMF.pure (fun i : Fin 0 => (isEmptyElim i : A))) := by
  rw [iid_split, iid_zero]

private theorem concatenate_empty_prefix {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) :
    (PMF.channelJoint (PMF.iid p 0) (fun _ => PMF.iid p n)).map
        (Fin.appendEquiv 0 n) = PMF.iid p (0 + n) :=
  iid_concatenate p 0 n

private theorem concatenate_empty_suffix {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) :
    (PMF.channelJoint (PMF.iid p n) (fun _ => PMF.iid p 0)).map
        (Fin.appendEquiv n 0) = PMF.iid p (n + 0) :=
  iid_concatenate p n 0

private theorem iid_pure {A : Type u} [Fintype A] (a : A) (n : ℕ) :
    PMF.iid (PMF.pure a) n = PMF.pure (fun _ : Fin n => a) :=
  PMF.finiteProduct_pure (fun _ : Fin n => a)

private theorem singleton_alphabet (n : ℕ) :
    PMF.iid (PMF.pure ()) n = PMF.pure (fun _ : Fin n => ()) :=
  iid_pure () n

private def emptyComponents (i : Fin 0) : PMF Empty := isEmptyElim i

private theorem empty_alphabet_general_product :
    PMF.finiteProduct emptyComponents =
      PMF.pure (fun i : Fin 0 => (isEmptyElim i : Empty)) :=
  PMF.finiteProduct_of_isEmpty emptyComponents

private theorem no_empty_base_law : ¬ Nonempty (PMF Empty) := by
  rintro ⟨p⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

/-! ## Supported and impossible sparse words for the later AEP boundary -/

private theorem sparse_impossible_mass :
    PMF.iid sparse 2 (![0, 2] : Fin 2 → Fin 3) = 0 := by
  rw [iid_atoms, Fin.prod_univ_two]
  norm_num [sparse, PMF.ofFintype_apply]

private theorem sparse_impossible_not_supported :
    (![0, 2] : Fin 2 → Fin 3) ∉ (PMF.iid sparse 2).support := by
  intro h
  have h1 := (sparse_support 2 _).mp h 1
  exact h1 rfl

private theorem sparse_supported_mass :
    PMF.iid sparse 2 (![0, 1] : Fin 2 → Fin 3) =
      ENNReal.ofReal (1 / 4 : ℝ) := by
  rw [iid_atoms, Fin.prod_univ_two]
  change ENNReal.ofReal (1 / 2 : ℝ) * ENNReal.ofReal (1 / 2 : ℝ) = _
  rw [← ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  congr 1
  norm_num

private theorem sparse_supported_word :
    (![0, 1] : Fin 2 → Fin 3) ∈ (PMF.iid sparse 2).support :=
  (sparse_support 2 _).2 (by decide)

end

end LeanInfoTheory.Examples.Iid
