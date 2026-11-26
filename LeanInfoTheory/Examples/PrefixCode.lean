/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.Finite
import LeanInfoTheory.Shannon.PrefixCode

/-!
# Finite binary prefix codes

An injective encoder with a prefix-free image can use the Kraft bound
directly on the source labels. Forgetting injectivity would collapse
duplicate assignments in the image. The three-label examples exercise both
Kraft directions. The empty and singleton cases include the support of a point mass.
-/

namespace LeanInfoTheory.Examples.PrefixCode

open LeanInfoTheory.Shannon

variable {S : Type*} {c : S → List Bool}

private theorem prefixCode_iff_injective_pairwise :
    IsBinaryPrefixCode c ↔ Function.Injective c ∧
      (Set.range c).Pairwise (fun u v => ¬ List.IsPrefix u v) := by
  constructor
  · intro hc
    refine ⟨fun a b h => hc (h ▸ List.prefix_refl (c a)), ?_⟩
    rintro _ ⟨a, rfl⟩ _ ⟨b, rfl⟩ hne hp
    exact hne (congrArg c (hc hp))
  · rintro ⟨hi, hp⟩ a b hab
    apply hi
    by_contra hne
    exact hp ⟨a, rfl⟩ ⟨b, rfl⟩ hne hab

example [Fintype S] (hi : Function.Injective c)
    (hp : (Set.range c).Pairwise (fun u v => ¬ List.IsPrefix u v)) :
    (∑ a : S, (1 / 2 : ℝ) ^ (c a).length) ≤ 1 :=
  (prefixCode_iff_injective_pairwise.mpr ⟨hi, hp⟩).kraft_sum_le_one

example : ¬ IsBinaryPrefixCode (fun _ : Bool => [false]) := by
  intro hc
  have h : false = true := hc (a := false) (b := true) (List.prefix_refl _)
  cases h

/-- Three source labels in the order used by CT91, equation (5.3). -/
private inductive Symbol
  | a | b | c
  deriving DecidableEq

private instance : Fintype Symbol where
  elems := {.a, .b, .c}
  complete x := by cases x <;> simp

private theorem sum_symbols (f : Symbol → ℝ) :
    (∑ x, f x) = f .a + (f .b + f .c) := by
  change (∑ x ∈ ({.a, .b, .c} : Finset Symbol), f x) = _
  simp

private def words : Symbol → List Bool
  | .a => [false]
  | .b => [true, false]
  | .c => [true, true]

private def lengths : Symbol → ℕ
  | .a => 1
  | .b | .c => 2

private theorem full_budget : (∑ x, (1 / 2 : ℝ) ^ lengths x) = 1 := by
  rw [sum_symbols]
  norm_num [lengths]

-- Check the displayed words independently of the existence theorem.
example : IsBinaryPrefixCode words ∧ (∀ x, (words x).length = lengths x) ∧
    (∑ x, (1 / 2 : ℝ) ^ (words x).length) = 1 := by
  have hlen (x) : (words x).length = lengths x := by cases x <;> rfl
  refine ⟨?_, hlen, by simpa only [hlen] using full_budget⟩
  intro x y
  cases x <;> cases y <;> decide

example : ∃ c : Symbol → List Bool, IsBinaryPrefixCode c ∧
    (c .a).length = 1 ∧ (c .b).length = 2 ∧ (c .c).length = 2 ∧
    (∑ x, (1 / 2 : ℝ) ^ (c x).length) ≤ 1 := by
  obtain ⟨c, hc, hl⟩ := exists_isBinaryPrefixCode_of_kraft_sum_le_one lengths full_budget.le
  exact ⟨c, hc, hl .a, hl .b, hl .c, hc.kraft_sum_le_one⟩

private def slackLengths : Symbol → ℕ
  | .a => 3
  | .b => 1
  | .c => 2

example : (∑ x, (1 / 2 : ℝ) ^ slackLengths x) = 7 / 8 ∧
    (∑ x, (1 / 2 : ℝ) ^ slackLengths x) < 1 ∧
    ∃ c : Symbol → List Bool, IsBinaryPrefixCode c ∧
      (c .a).length = 3 ∧ (c .b).length = 1 ∧ (c .c).length = 2 := by
  have h : (∑ x, (1 / 2 : ℝ) ^ slackLengths x) = 7 / 8 := by
    rw [sum_symbols]
    norm_num [slackLengths]
  have hlt := h.trans_lt (by norm_num : (7 / 8 : ℝ) < 1)
  obtain ⟨c, hc, hl⟩ := exists_isBinaryPrefixCode_of_kraft_sum_le_one slackLengths hlt.le
  exact ⟨h, hlt, c, hc, hl .a, hl .b, hl .c⟩

example : ¬ ∃ c : Symbol → List Bool, IsBinaryPrefixCode c ∧ ∀ x, (c x).length = 1 := by
  rintro ⟨c, hc, hl⟩
  have h := hc.kraft_sum_le_one
  rw [sum_symbols] at h
  have impossible : (3 / 2 : ℝ) ≤ 1 := calc
    3 / 2 = (1 / 2 : ℝ) ^ (c .a).length +
        ((1 / 2 : ℝ) ^ (c .b).length + (1 / 2 : ℝ) ^ (c .c).length) := by norm_num [hl]
    _ ≤ 1 := h
  norm_num at impossible

example : (∑ _ : Empty, (1 / 2 : ℝ) ^ (0 : ℕ)) = 0 ∧
    ∃ c : Empty → List Bool, IsBinaryPrefixCode c ∧ ∀ x, (c x).length = 0 := by
  exact ⟨by simp, exists_isBinaryPrefixCode_of_kraft_sum_le_one (fun _ => 0) (by simp)⟩

-- The singleton has only one possible source tuple at each given count.
example (n : ℕ) (x y : Fin n → Unit) : x = y := Subsingleton.elim _ _

example : ∃ c : Unit → List Bool, IsBinaryPrefixCode c ∧ c () = [] ∧
    (∑ x, (1 / 2 : ℝ) ^ (c x).length) = 1 ∧
    ¬ InformationTheory.UniquelyDecodable (Set.range c) := by
  obtain ⟨c, hc, hl⟩ := exists_isBinaryPrefixCode_of_kraft_sum_le_one
    (fun _ : Unit => 0) (by simp)
  have he : c () = [] := List.length_eq_zero_iff.mp (hl ())
  refine ⟨c, hc, he, by simp [hl], ?_⟩
  intro hud
  have hm : ([] : List Bool) ∈ Set.range c := ⟨(), he⟩
  have h := hud [[]] [[], []] (by simpa using hm) (by simpa using hm) rfl
  simpa using congrArg List.length h

-- The point mass has a two-symbol ambient alphabet and a one-label code domain.
example : false ∈ (PMF.pure false).supportFinset ∧ true ∉ (PMF.pure false).supportFinset ∧
    ∃ c : ↥(PMF.pure false).supportFinset → List Bool, IsBinaryPrefixCode c ∧
      ∀ x, x.val = false ∧ (c x).length = 0 ∧ c x = [] := by
  have hs : (PMF.pure false).supportFinset = {false} := by
    ext x
    simp
  have budget : (∑ _ : ↥(PMF.pure false).supportFinset, (1 / 2 : ℝ) ^ (0 : ℕ)) ≤ 1 := by
    simp [hs]
  obtain ⟨c, hc, hl⟩ := exists_isBinaryPrefixCode_of_kraft_sum_le_one (fun _ => 0) budget
  refine ⟨by simp [hs], by simp [hs], c, hc, fun x => ⟨?_, hl x, List.length_eq_zero_iff.mp (hl x)⟩⟩
  simpa only [hs, Finset.mem_singleton] using x.property

end LeanInfoTheory.Examples.PrefixCode
