/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.WordType
import Mathlib.Data.Nat.Choose.Multinomial
import Mathlib.GroupTheory.Perm.DomMulAct
import Mathlib.GroupTheory.GroupAction.Quotient

/-!
# Exact cardinality of a type class

The existing count-indexed `typeClass` has multinomial cardinality, as in
CT91 section 12.1, equation (12.17). Equal symbol counts identify a class with
an orbit of position permutations. Its stabilizer permutes positions inside
each symbol fiber, including the empty fibers of unused symbols.

This combinatorial result holds at every length. In particular, the empty-word
class has cardinality one even over an empty alphabet. No empirical law or
probability normalization is used here.
-/

namespace LeanInfoTheory.Shannon

open scoped BigOperators

universe u

variable {A : Type u} [Fintype A] {n : ℕ}

private theorem exists_perm_of_wordType_eq
    {x y : Fin n → A} (h : wordType x = wordType y) :
    ∃ e : Equiv.Perm (Fin n), y ∘ e = x := by
  classical
  have hc : symbolCount x = symbolCount y := congrArg Subtype.val h
  let ef (a : A) : {i : Fin n // x i = a} ≃ {i : Fin n // y i = a} :=
    Fintype.equivOfCardEq (by
      simpa only [Fintype.card_subtype, symbolCount] using congrFun hc a)
  refine ⟨Equiv.ofFiberEquiv ef, ?_⟩
  funext i
  exact Equiv.ofFiberEquiv_map ef i

private theorem mem_typeClass_wordType_iff_mem_orbit (x y : Fin n → A) :
    y ∈ typeClass (wordType x) ↔
      y ∈ MulAction.orbit (DomMulAct (Equiv.Perm (Fin n))) x := by
  classical
  constructor
  · intro hy
    obtain ⟨e, he⟩ := exists_perm_of_wordType_eq (mem_typeClass.1 hy)
    apply MulAction.mem_orbit_iff.2
    refine ⟨DomMulAct.mk e, ?_⟩
    change x ∘ e = y
    exact he
  · intro hy
    obtain ⟨g, rfl⟩ := MulAction.mem_orbit_iff.1 hy
    apply mem_typeClass.2
    change wordType (x ∘ (DomMulAct.mk.symm g : Equiv.Perm (Fin n))) = wordType x
    exact wordType_comp_perm x (DomMulAct.mk.symm g)

private theorem card_typeClass_wordType_mul_factorials (x : Fin n → A) :
    (typeClass (wordType x)).card * (∏ a, (symbolCount x a).factorial) =
      n.factorial := by
  classical
  let G := DomMulAct (Equiv.Perm (Fin n))
  let : Fintype G := Fintype.ofEquiv (Equiv.Perm (Fin n)) DomMulAct.mk
  let ec : ↥(typeClass (wordType x)) ≃ MulAction.orbit G x :=
    Equiv.subtypeEquivRight (fun y => mem_typeClass_wordType_iff_mem_orbit x y)
  have hc : Fintype.card (MulAction.orbit G x) = (typeClass (wordType x)).card := by
    rw [← Fintype.card_congr ec]
    exact Fintype.card_coe _
  let es : MulAction.stabilizer G x ≃
      {e : Equiv.Perm (Fin n) // x ∘ e = x} :=
    Equiv.subtypeEquiv DomMulAct.mk.symm (fun _ => DomMulAct.mem_stabilizer_iff)
  have hs : Fintype.card (MulAction.stabilizer G x) =
      ∏ a, (symbolCount x a).factorial := by
    calc
      _ = Fintype.card {e : Equiv.Perm (Fin n) // x ∘ e = x} := Fintype.card_congr es
      _ = ∏ a, (Fintype.card {i : Fin n // x i = a}).factorial :=
        DomMulAct.stabilizer_card x
      _ = _ := by simp only [Fintype.card_subtype, symbolCount]
  have hg : Fintype.card G = n.factorial := by
    rw [← Fintype.card_congr (DomMulAct.mk : Equiv.Perm (Fin n) ≃ G),
      Fintype.card_perm, Fintype.card_fin]
  simpa only [hc, hs, hg] using
    MulAction.card_orbit_mul_card_stabilizer_eq_card_group G x

/-- The words with supplied admissible counts are counted by the multinomial
coefficient. This includes zero length and zero-count symbols. -/
theorem card_typeClass_eq_multinomial (t : ↥(wordTypes A n)) :
    (typeClass t).card = Nat.multinomial Finset.univ t.val := by
  classical
  obtain ⟨x, rfl⟩ := wordType_surjective t
  change (typeClass (wordType x)).card =
    Nat.multinomial Finset.univ (symbolCount x)
  apply Nat.mul_left_cancel (Nat.prod_factorial_pos Finset.univ (symbolCount x))
  calc
    (∏ a, (symbolCount x a).factorial) * (typeClass (wordType x)).card =
        n.factorial := by
      simpa only [Nat.mul_comm] using card_typeClass_wordType_mul_factorials x
    _ = (∏ a, (symbolCount x a).factorial) *
        Nat.multinomial Finset.univ (symbolCount x) := by
      simpa only [sum_symbolCount] using
        (Nat.multinomial_spec Finset.univ (symbolCount x)).symm

end LeanInfoTheory.Shannon
