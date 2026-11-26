/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import Mathlib.Data.Finset.Max
import Mathlib.InformationTheory.Coding.KraftMcMillan

/-!
# Binary prefix codes and the Kraft inequality

A codeword is a list of binary digits attached to a source label. On nonempty
words the prefix condition gives unique decoding of concatenations, so the
finite image satisfies mathlib's Kraft–McMillan inequality. The empty word
can occur only at the sole label of a singleton source. Its Kraft weight is one.

Conversely, any finite family of lengths whose Kraft sum is at most one can be
assigned to its original labels by choosing free leaves at successive depths.
-/

namespace LeanInfoTheory.Shannon

universe u

open scoped BigOperators

variable {S : Type u}

/-- A binary word can prefix another assigned word only when their labels agree. -/
def IsBinaryPrefixCode (c : S → List Bool) : Prop :=
  ∀ ⦃a b : S⦄, List.IsPrefix (c a) (c b) → a = b

private theorem uniquelyDecodable_image_of_nonempty_words [Fintype S] {c : S → List Bool}
    (hc : IsBinaryPrefixCode c) (hne : ∀ a, c a ≠ []) :
    InformationTheory.UniquelyDecodable (↑(Finset.univ.image c) : Set (List Bool)) := by
  let T := Finset.univ.image c
  have label {w : List Bool} (hw : w ∈ T) : ∃ a, c a = w := by
    simpa [T] using hw
  have nonemptyWord {w : List Bool} (hw : w ∈ T) : w ≠ [] := by
    obtain ⟨a, rfl⟩ := label hw
    exact hne a
  have eq_of_prefix {v w : List Bool} (hv : v ∈ T) (hw : w ∈ T) (h : v <+: w) : v = w := by
    obtain ⟨a, rfl⟩ := label hv
    obtain ⟨b, rfl⟩ := label hw
    exact congrArg c (hc h)
  intro xs ys hxs hys hflat
  induction xs generalizing ys with
  | nil =>
    cases ys with
    | nil => rfl
    | cons w ws =>
      exact (nonemptyWord (hys w (by simp)) (List.append_eq_nil_iff.mp hflat.symm).1).elim
  | cons v vs ih =>
    have hv : v ∈ T := hxs v (by simp)
    cases ys with
    | nil => exact (nonemptyWord hv (List.append_eq_nil_iff.mp hflat).1).elim
    | cons w ws =>
      have hw : w ∈ T := hys w (by simp)
      change v ++ vs.flatten = w ++ ws.flatten at hflat
      have hp : v <+: w ++ ws.flatten := hflat ▸ v.prefix_append _
      have heq : v = w := (List.prefix_or_prefix_of_prefix hp (w.prefix_append _)).elim
        (eq_of_prefix hv hw) (fun h => (eq_of_prefix hw hv h).symm)
      subst w
      exact congrArg (v :: ·) (ih ws (fun z hz => hxs z (by simp [hz]))
        (fun z hz => hys z (by simp [hz])) (List.append_cancel_left hflat))

/-- The binary Kraft sum of any finite labeled prefix code is at most one. -/
theorem IsBinaryPrefixCode.kraft_sum_le_one [Fintype S] {c : S → List Bool}
    (hc : IsBinaryPrefixCode c) : (∑ a : S, (1 / 2 : ℝ) ^ (c a).length) ≤ 1 := by
  classical
  by_cases h : ∃ a, c a = []
  · obtain ⟨a, ha⟩ := h
    have hall (b : S) : a = b := hc (ha ▸ List.nil_prefix)
    have : Subsingleton S := ⟨fun x y => (hall x).symm.trans (hall y)⟩
    rw [Fintype.sum_subsingleton _ a, ha]
    simp
  · have hd := uniquelyDecodable_image_of_nonempty_words hc (fun a ha => h ⟨a, ha⟩)
    have hinj : Function.Injective c := fun a b hab => hc (hab ▸ List.prefix_refl _)
    have hk := InformationTheory.kraft_mcmillan_inequality hd
    simpa [Finset.sum_image hinj.injOn] using hk

/-- Bound the number of leaves below one word by counting its possible suffixes. -/
private theorem card_leaves_with_prefix_le (w : List Bool) {d : ℕ} (hw : w.length ≤ d) :
    ((Finset.univ : Finset (List.Vector Bool d)).filter (fun v => w <+: v.toList)).card ≤
      2 ^ (d - w.length) := by
  classical
  let appendSuffix (s : List.Vector Bool (d - w.length)) : List.Vector Bool d :=
    ⟨w ++ s.toList, by rw [List.length_append, s.toList_length]; omega⟩
  have mem_image (v : List.Vector Bool d) :
      v ∈ Finset.univ.image appendSuffix ↔ w <+: v.toList := by
    constructor
    · intro hv
      obtain ⟨s, _, rfl⟩ := Finset.mem_image.mp hv
      exact ⟨s.toList, rfl⟩
    · rintro ⟨s, hs⟩
      have hlen : w.length + s.length = d := by rw [← List.length_append, hs]; exact v.2
      exact Finset.mem_image.mpr ⟨⟨s, by omega⟩, Finset.mem_univ _, Subtype.ext hs⟩
  have heq : Finset.univ.filter (fun v : List.Vector Bool d => w <+: v.toList) =
      Finset.univ.image appendSuffix := by
    ext v
    simp [mem_image]
  rw [heq]
  exact Finset.card_image_le.trans_eq (by simp)

/-- Scale the real Kraft budget to a count of leaves at the depth of the new word. -/
private theorem occupied_leaf_bound (t : Finset S) (ℓ : S → ℕ) (d : ℕ)
    (hmax : ∀ x ∈ t, ℓ x ≤ d)
    (h : (1 / 2 : ℝ) ^ d + ∑ x ∈ t, (1 / 2 : ℝ) ^ ℓ x ≤ 1) :
    1 + ∑ x ∈ t, 2 ^ (d - ℓ x) ≤ 2 ^ d := by
  have scale (k : ℕ) (hk : k ≤ d) : (1 / 2 : ℝ) ^ k * 2 ^ d = 2 ^ (d - k) := by
    calc
      _ = ((2 : ℝ) ^ k)⁻¹ * (2 ^ (d - k) * 2 ^ k) := by
        rw [pow_sub_mul_pow (2 : ℝ) hk]
        simp [one_div]
      _ = _ := by rw [mul_left_comm]; simp
  have scaled := mul_le_mul_of_nonneg_right h (show 0 ≤ (2 : ℝ) ^ d by positivity)
  rw [add_mul, Finset.sum_mul, one_mul, scale d le_rfl, Nat.sub_self, pow_zero] at scaled
  rw [Finset.sum_congr rfl (fun x hx => scale (ℓ x) (hmax x hx))] at scaled
  exact_mod_cast scaled

private theorem exists_leaf_outside_prefixes (t : Finset S) (c : S → List Bool) (d : ℕ)
    (hmax : ∀ x ∈ t, (c x).length ≤ d)
    (hspace : 1 + ∑ x ∈ t, 2 ^ (d - (c x).length) ≤ 2 ^ d) :
    ∃ v : List.Vector Bool d, ∀ x ∈ t, ¬ c x <+: v.toList := by
  classical
  let leaves (x : S) := (Finset.univ : Finset (List.Vector Bool d)).filter
    (fun v => c x <+: v.toList)
  have hcard : (t.biUnion leaves).card ≤ ∑ x ∈ t, 2 ^ (d - (c x).length) :=
    Finset.card_biUnion_le.trans (Finset.sum_le_sum fun x hx =>
      card_leaves_with_prefix_le (c x) (hmax x hx))
  have hlt : (t.biUnion leaves).card < (Finset.univ : Finset (List.Vector Bool d)).card := by
    simp only [Finset.card_univ, card_vector, Fintype.card_bool]
    omega
  obtain ⟨v, _, hv⟩ := Finset.exists_mem_notMem_of_card_lt_card hlt
  exact ⟨v, fun x hx hp => hv (Finset.mem_biUnion.mpr
    ⟨x, hx, Finset.mem_filter.mpr ⟨Finset.mem_univ _, hp⟩⟩)⟩

/-- A finite family of binary codeword lengths with Kraft sum at most one is realized by a
prefix code on the original labels, with the prescribed length at each label. -/
theorem exists_isBinaryPrefixCode_of_kraft_sum_le_one [Fintype S] (ℓ : S → ℕ)
    (h : (∑ a : S, (1 / 2 : ℝ) ^ ℓ a) ≤ 1) :
    ∃ c : S → List Bool, IsBinaryPrefixCode c ∧ ∀ a, (c a).length = ℓ a := by
  classical
  have assign (t : Finset S) : (∑ x ∈ t, (1 / 2 : ℝ) ^ ℓ x) ≤ 1 →
      ∃ c : S → List Bool, (∀ x ∈ t, (c x).length = ℓ x) ∧
        ∀ x ∈ t, ∀ y ∈ t, c x <+: c y → x = y := by
    induction t using Finset.induction_on_max_value ℓ with
    | empty => exact fun _ => ⟨fun _ => [], by simp, by simp⟩
    | insert a t ha hmax ih =>
      intro budget
      rw [Finset.sum_insert ha] at budget
      have smaller : (∑ x ∈ t, (1 / 2 : ℝ) ^ ℓ x) ≤ 1 :=
        (le_add_of_nonneg_left (by positivity)).trans budget
      obtain ⟨c, lengths, hprefix⟩ := ih smaller
      have counts := occupied_leaf_bound t ℓ (ℓ a) hmax budget
      obtain ⟨v, free⟩ := exists_leaf_outside_prefixes t c (ℓ a)
        (fun x hx => by rw [lengths x hx]; exact hmax x hx)
        (by
          have eq : (∑ x ∈ t, 2 ^ (ℓ a - (c x).length)) = ∑ x ∈ t, 2 ^ (ℓ a - ℓ x) :=
            Finset.sum_congr rfl (fun x hx => by rw [lengths x hx])
          rwa [eq])
      let c' := Function.update c a v.toList
      have atNew : c' a = v.toList := Function.update_self ..
      have atOld {x : S} (hx : x ∈ t) : c' x = c x :=
        Function.update_of_ne (show x ≠ a from fun he => ha (he ▸ hx)) _ _
      refine ⟨c', ?_, ?_⟩
      · intro x hx
        rcases Finset.mem_insert.mp hx with rfl | hx
        · rw [atNew]; exact v.2
        · rw [atOld hx]; exact lengths x hx
      · intro x hx y hy hp
        rcases Finset.mem_insert.mp hx with rfl | hxOld
        · rcases Finset.mem_insert.mp hy with rfl | hyOld
          · rfl
          · rw [atNew, atOld hyOld] at hp
            have eq := hp.eq_of_length_le (by
              rw [v.toList_length, lengths y hyOld]
              exact hmax y hyOld)
            exact (free y hyOld (by rw [eq])).elim
        · rcases Finset.mem_insert.mp hy with rfl | hyOld
          · rw [atOld hxOld, atNew] at hp
            exact (free x hxOld hp).elim
          · exact hprefix x hxOld y hyOld (by simpa only [atOld hxOld, atOld hyOld] using hp)
  obtain ⟨c, lengths, hprefix⟩ := assign Finset.univ h
  exact ⟨c, fun {_ _} hp => hprefix _ (Finset.mem_univ _) _ (Finset.mem_univ _) hp,
    fun x => lengths x (Finset.mem_univ _)⟩

end LeanInfoTheory.Shannon
