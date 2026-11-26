/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import Mathlib.Algebra.Order.Antidiag.Pi
import Mathlib.Data.Fintype.BigOperators

/-!
# Symbol counts and types of finite words

The type of a word `Fin n → A` records how many positions carry each symbol.
On a finite alphabet, `wordTypes A n` enumerates the natural count vectors
with total `n`. At length zero its sole element is the zero vector.
Every admissible vector is the type of some word. Its `typeClass` consists
of precisely the words of that type.
Reordering positions preserves the type. On an alphabet of size `k`, there
are at most `(n + 1) ^ k` distinct types of length `n`.
-/

namespace LeanInfoTheory.Shannon

open scoped BigOperators

universe u

variable {A : Type u} {n : ℕ}

/-- The number of positions of the word `x` occupied by symbol `a`. -/
noncomputable def symbolCount (x : Fin n → A) (a : A) : ℕ := by
  classical
  exact (Finset.univ.filter fun i => x i = a).card

/-- Every symbol occurs zero times in the empty word. -/
theorem symbolCount_zero (x : Fin 0 → A) (a : A) : symbolCount x a = 0 := by
  classical
  simp [symbolCount]

/-- The counts over the full alphabet sum to the word length. -/
theorem sum_symbolCount [Fintype A] (x : Fin n → A) :
    (∑ a, symbolCount x a) = n := by
  classical
  simpa [symbolCount] using
    (Finset.card_eq_sum_card_fiberwise (s := Finset.univ) (t := Finset.univ) (f := x)
      (fun _ _ => Finset.mem_univ _)).symm

/-- The natural count vectors on `A` whose entries sum to `n`. -/
noncomputable def wordTypes (A : Type u) [Fintype A] (n : ℕ) : Finset (A → ℕ) := by
  classical
  exact Finset.univ.piAntidiag n

/-- A count vector is admissible at length `n` exactly when its total is `n`. -/
theorem mem_wordTypes [Fintype A] (c : A → ℕ) :
    c ∈ wordTypes A n ↔ (∑ a, c a) = n := by
  classical
  simp [wordTypes, Finset.mem_piAntidiag]

/-- The sole admissible type at length zero is the all-zero count vector. -/
theorem wordTypes_zero (A : Type u) [Fintype A] : wordTypes A 0 = {0} := by
  classical
  exact Finset.piAntidiag_zero Finset.univ

/-- The admissible type of a word, with its symbol counts as the underlying function. -/
noncomputable def wordType [Fintype A] (x : Fin n → A) : ↥(wordTypes A n) :=
  ⟨symbolCount x, (mem_wordTypes _).2 (sum_symbolCount x)⟩

/-- Every admissible count vector is realized by a word of the prescribed length. -/
theorem wordType_surjective [Fintype A] :
    Function.Surjective (wordType : (Fin n → A) → ↥(wordTypes A n)) := by
  classical
  intro t
  let e : Fin n ≃ (Σ a : A, Fin (t.val a)) := Fintype.equivOfCardEq (by
    simpa only [Fintype.card_sigma, Fintype.card_fin] using
      ((mem_wordTypes t.val).1 t.property).symm)
  refine ⟨fun i => (e i).1, Subtype.ext ?_⟩
  funext a
  let fiber : {i : Fin n // (e i).1 = a} ≃ Fin (t.val a) :=
    (e.subtypeEquivOfSubtype (p := fun s => s.1 = a)).trans (Equiv.sigmaSubtype a)
  calc
    symbolCount (fun i => (e i).1) a = Fintype.card {i : Fin n // (e i).1 = a} :=
      (Fintype.card_subtype _).symm
    _ = Fintype.card (Fin (t.val a)) := Fintype.card_congr fiber
    _ = t.val a := Fintype.card_fin _

/-- The finite set of all words with the given admissible count vector. -/
noncomputable def typeClass [Fintype A] (t : ↥(wordTypes A n)) : Finset (Fin n → A) := by
  classical
  exact Finset.univ.filter fun x => wordType x = t

/-- A word belongs to the supplied class exactly when its type is the class index. -/
theorem mem_typeClass [Fintype A] {x : Fin n → A} {t : ↥(wordTypes A n)} :
    x ∈ typeClass t ↔ wordType x = t := by
  classical
  simp [typeClass]

/-- Each word belongs to exactly one of the indexed type classes. -/
theorem existsUnique_mem_typeClass [Fintype A] (x : Fin n → A) :
    ∃! t : ↥(wordTypes A n), x ∈ typeClass t :=
  ⟨wordType x, mem_typeClass.2 rfl, fun _ ht => (mem_typeClass.1 ht).symm⟩

/-- Reading old position `e i` at new position `i` preserves the count of each symbol. -/
theorem symbolCount_comp_perm (x : Fin n → A) (e : Equiv.Perm (Fin n)) (a : A) :
    symbolCount (x ∘ e) a = symbolCount x a := by
  classical
  calc
    symbolCount (x ∘ e) a = Fintype.card {i : Fin n // x (e i) = a} :=
      (Fintype.card_subtype _).symm
    _ = Fintype.card {i : Fin n // x i = a} :=
      Fintype.card_congr (e.subtypeEquivOfSubtype (p := fun i => x i = a))
    _ = symbolCount x a := Fintype.card_subtype _

/-- A permutation of the positions of a word preserves its admissible type. -/
theorem wordType_comp_perm [Fintype A] (x : Fin n → A) (e : Equiv.Perm (Fin n)) :
    wordType (x ∘ e) = wordType x :=
  Subtype.ext (funext fun a => symbolCount_comp_perm x e a)

/-- The number of distinct types is at most `(n + 1) ^ Fintype.card A`. -/
theorem card_wordTypes_le (A : Type u) [Fintype A] (n : ℕ) :
    (wordTypes A n).card ≤ (n + 1) ^ Fintype.card A := by
  classical
  let encode (t : ↥(wordTypes A n)) (a : A) : Fin (n + 1) := by
    have total := (Finset.add_sum_erase Finset.univ t.val (Finset.mem_univ a)).trans
      ((mem_wordTypes t.val).1 t.property)
    exact ⟨t.val a, Nat.lt_succ_of_le ((Nat.le_add_right _ _).trans_eq total)⟩
  have hinj : Function.Injective encode := by
    intro s t h
    exact Subtype.ext (funext fun a => congrArg Fin.val (congrFun h a))
  simpa only [Fintype.card_coe, Fintype.card_fun, Fintype.card_fin] using
    Fintype.card_le_of_injective encode hinj

end LeanInfoTheory.Shannon
