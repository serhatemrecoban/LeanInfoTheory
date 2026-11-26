/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.PrefixCodeLengthIid

/-!
# Expected lengths of finite binary prefix codes

These examples compute the costs of specific prefix codes on each law's support.
The biased Boolean law has different Shannon and optimal costs. Two independent
draws use fewer bits on average with joint coding than with concatenation.
-/

namespace LeanInfoTheory.Examples.PrefixCodeLength

open LeanInfoTheory.Shannon

/-! ### A dyadic source with an unused label -/

namespace Dyadic

private noncomputable def mass : Fin 4 → ℝ := ![1/2, 1/4, 1/4, 0]

private theorem mass_nonneg (a : Fin 4) : 0 ≤ mass a := by
  fin_cases a <;> norm_num [mass]

private noncomputable def law : PMF (Fin 4) :=
  PMF.ofFintype (fun a => ENNReal.ofReal (mass a)) (by
    rw [← ENNReal.ofReal_sum_of_nonneg (fun a _ => mass_nonneg a), Fin.sum_univ_four]
    change ENNReal.ofReal ((1/2 : ℝ) + 1/4 + 1/4 + 0) = 1
    norm_num)

private theorem real_mass (a : Fin 4) : (law a).toReal = mass a :=
  ENNReal.toReal_ofReal (mass_nonneg a)

private theorem support : law.supportFinset = {0, 1, 2} := by
  ext a
  rw [PMF.mem_supportFinset, PMF.mem_support_iff]
  change ENNReal.ofReal (mass a) ≠ 0 ↔ _
  fin_cases a <;> norm_num [mass] <;> decide

-- A candidate extension lets the fourth word vary; the supported code uses only
-- the first three entries of this table.
private def words (fourth : List Bool) : Fin 4 → List Bool :=
  ![[false], [true, false], [true, true], fourth]

private def code (a : ↥law.supportFinset) : List Bool := words [] a.val

private theorem code_prefix : IsBinaryPrefixCode code := by
  have tree : ∀ i ∈ ({0, 1, 2} : Finset (Fin 4)), ∀ j ∈ ({0, 1, 2} : Finset (Fin 4)),
      List.IsPrefix (words [] i) (words [] j) → i = j := by decide
  intro a b hab
  exact Subtype.ext (tree a.val (by simpa only [support] using a.property)
    b.val (by simpa only [support] using b.property) hab)

private theorem sum_supported (f : Fin 4 → ℝ) :
    (∑ a : ↥law.supportFinset, f a.val) = f 0 + (f 1 + f 2) := by
  rw [Finset.sum_coe_sort law.supportFinset f, support]
  rw [Finset.sum_insert (by decide : (0 : Fin 4) ∉ ({1, 2} : Finset (Fin 4))),
    Finset.sum_insert (by decide : (1 : Fin 4) ∉ ({2} : Finset (Fin 4))), Finset.sum_singleton]

private theorem mean : expectedCodewordLength law code = 3 / 2 := by
  change (∑ a : ↥law.supportFinset, (law a.val).toReal * ((words [] a.val).length : ℝ)) = _
  rw [sum_supported (fun a => (law a).toReal * ((words [] a).length : ℝ))]
  simp only [real_mass]
  rw [show mass (2 : Fin 4) = 1 / 4 by rfl, show (words [] (2 : Fin 4)).length = 2 by rfl]
  norm_num [mass, words]

private theorem entropy_bits : natsToBits (entropy law) = 3 / 2 := by
  have half : Real.logb 2 (1 / 2) = -1 := by
    rw [one_div, Real.logb_inv, Real.logb_self_eq_one (by norm_num : (1 : ℝ) < 2)]
  have quarter : Real.logb 2 (1 / 4) = -2 := by
    rw [one_div, Real.logb_inv, show (4 : ℝ) = 2 ^ 2 by norm_num, Real.logb_pow,
      Real.logb_self_eq_one (by norm_num : (1 : ℝ) < 2)]
    norm_num
  rw [natsToBits, natsToBase, entropy_div_log, Fin.sum_univ_four]
  simp only [real_mass]
  change -(1 / 2 : ℝ) * Real.logb 2 (1 / 2) + -(1 / 4 : ℝ) * Real.logb 2 (1 / 4) +
    -(1 / 4 : ℝ) * Real.logb 2 (1 / 4) + -0 * Real.logb 2 0 = 3 / 2
  rw [half, quarter]
  norm_num

example : (law 0).toReal = 1 / 2 ∧ (law 1).toReal = 1 / 4 ∧
    (law 2).toReal = 1 / 4 ∧ (law 3).toReal = 0 ∧ (3 : Fin 4) ∉ law.supportFinset := by
  simp only [real_mass]
  refine ⟨rfl, rfl, rfl, rfl, ?_⟩
  rw [support]
  decide

-- The displayed assignment attains the converse, so its cost is the optimum.
example : IsBinaryPrefixCode code ∧ (∑ a, (1 / 2 : ℝ) ^ (code a).length) = 1 ∧
    expectedCodewordLength law code = 3 / 2 ∧ natsToBits (entropy law) = 3 / 2 ∧
    optimalPrefixLength law = 3 / 2 := by
  have hleast := isLeast_optimalPrefixLength law
  obtain ⟨opt, hopt, hcost⟩ := hleast.1
  have hlower := (natsToBits_entropy_le_expectedCodewordLength law hopt).trans_eq hcost
  have hupper := (hleast.2 ⟨code, code_prefix, rfl⟩).trans_eq mean
  refine ⟨code_prefix, ?_, mean, entropy_bits, le_antisymm hupper (entropy_bits ▸ hlower)⟩
  change (∑ a : ↥law.supportFinset, (1 / 2 : ℝ) ^ (words [] a.val).length) = 1
  rw [sum_supported (fun a => (1 / 2 : ℝ) ^ (words [] a).length)]
  change (1 / 2 : ℝ) ^ 1 + ((1 / 2) ^ 2 + (1 / 2) ^ 2) = 1
  norm_num

-- Every finite choice at the unused fourth label adds a strictly positive weight.
example (w : List Bool) : (∀ a : ↥law.supportFinset, words w a.val = code a) ∧
    1 < (∑ a : Fin 4, (1 / 2 : ℝ) ^ (words w a).length) ∧ ¬ IsBinaryPrefixCode (words w) := by
  have hweight : 0 < (1 / 2 : ℝ) ^ w.length := by positivity
  have hexcess : 1 < (∑ a : Fin 4, (1 / 2 : ℝ) ^ (words w a).length) := by
    rw [Fin.sum_univ_four]
    change 1 < (1 / 2 : ℝ) ^ 1 + (1 / 2 : ℝ) ^ 2 + (1 / 2 : ℝ) ^ 2 + (1 / 2 : ℝ) ^ w.length
    linarith
  refine ⟨?_, hexcess, fun h => hexcess.not_ge h.kraft_sum_le_one⟩
  intro a
  have ha : a.val = 0 ∨ a.val = 1 ∨ a.val = 2 := by
    simpa [support] using a.property
  rcases ha with h | h | h <;> rw [code, h] <;> rfl

end Dyadic

/-! ### The biased Boolean source -/

private noncomputable def biased : PMF Bool :=
  PMF.ofFintype (fun b => ENNReal.ofReal (if b then (3 / 4 : ℝ) else 1 / 4)) (by
    rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
    norm_num)

private theorem biased_mass (b : Bool) :
    (biased b).toReal = if b then (3 / 4 : ℝ) else 1 / 4 := by
  cases b <;> norm_num [biased, PMF.ofFintype_apply]

private theorem biased_mem (b : Bool) : b ∈ biased.supportFinset := by
  rw [PMF.mem_supportFinset, PMF.mem_support_iff]
  have hpos : 0 < (biased b).toReal := by cases b <;> norm_num [biased_mass]
  intro h
  simp [h] at hpos

private def biasedLabel (b : Bool) : ↥biased.supportFinset := ⟨b, biased_mem b⟩

private theorem biased_mean (c : ↥biased.supportFinset → List Bool) :
    expectedCodewordLength biased c =
      3 / 4 * ((c (biasedLabel true)).length : ℝ) +
      1 / 4 * ((c (biasedLabel false)).length : ℝ) := by
  let e : Bool ≃ ↥biased.supportFinset :=
    ⟨biasedLabel, Subtype.val, fun _ => rfl, fun _ => rfl⟩
  unfold expectedCodewordLength
  rw [← e.sum_comp (fun a => (biased a.val).toReal * ((c a).length : ℝ)), Fintype.sum_bool]
  change (biased true).toReal * _ + (biased false).toReal * _ = _
  rw [biased_mass, biased_mass]
  rfl

private def oneBit (x : ↥biased.supportFinset) : List Bool := [x.val]

private theorem oneBit_prefix : IsBinaryPrefixCode oneBit := by
  intro x y h
  apply Subtype.ext
  simpa [oneBit] using h.eq_of_length_le (by rfl)

private theorem oneBit_mean : expectedCodewordLength biased oneBit = 1 := by
  norm_num [biased_mean, oneBit]

-- Any empty word prefixes the word of the opposite supported Boolean.
private theorem biased_length_pos {c : ↥biased.supportFinset → List Bool}
    (hc : IsBinaryPrefixCode c) (a : ↥biased.supportFinset) : 1 ≤ (c a).length := by
  by_contra! h
  have hnil : c a = [] := List.length_eq_zero_iff.mp (by omega)
  have heq : a = biasedLabel (!a.val) := hc (hnil ▸ List.nil_prefix)
  have hval : a.val = !a.val := congrArg Subtype.val heq
  cases ha : a.val <;> simp [ha] at hval

private theorem biased_optimal : optimalPrefixLength biased = 1 := by
  have hleast := isLeast_optimalPrefixLength biased
  refine le_antisymm ((hleast.2 ⟨oneBit, oneBit_prefix, rfl⟩).trans_eq oneBit_mean) ?_
  obtain ⟨c, hc, hopt⟩ := hleast.1
  rw [← hopt, biased_mean]
  have ht : (1 : ℝ) ≤ (c (biasedLabel true)).length :=
    by exact_mod_cast biased_length_pos hc (biasedLabel true)
  have hf : (1 : ℝ) ≤ (c (biasedLabel false)).length :=
    by exact_mod_cast biased_length_pos hc (biasedLabel false)
  linarith

private theorem biased_ceil_true : ⌈-Real.logb 2 (3 / 4 : ℝ)⌉₊ = 1 := by
  apply (Nat.ceil_eq_iff (by decide : 1 ≠ 0)).2
  have hneg : Real.logb 2 (3 / 4 : ℝ) < 0 :=
    Real.logb_neg (by norm_num) (by norm_num) (by norm_num)
  have half : Real.logb 2 (1 / 2 : ℝ) = -1 := by
    rw [one_div, Real.logb_inv, Real.logb_self_eq_one (by norm_num)]
  have hhalf : Real.logb 2 (1 / 2 : ℝ) < Real.logb 2 (3 / 4 : ℝ) :=
    Real.logb_lt_logb (by norm_num) (by norm_num) (by norm_num)
  norm_num
  constructor <;> linarith

private theorem biased_ceil_false : ⌈-Real.logb 2 (1 / 4 : ℝ)⌉₊ = 2 := by
  rw [show (1 / 4 : ℝ) = ((2 : ℝ) ^ 2)⁻¹ by norm_num, Real.logb_inv, Real.logb_pow,
    Real.logb_self_eq_one (by norm_num)]
  norm_num

-- The rounded witness costs a quarter of a bit more than the minimizing code.
example : ∃ c : ↥biased.supportFinset → List Bool, IsBinaryPrefixCode c ∧
    (c (biasedLabel true)).length = 1 ∧ (c (biasedLabel false)).length = 2 ∧
    expectedCodewordLength biased c = 5 / 4 ∧
    optimalPrefixLength biased = 1 ∧
    optimalPrefixLength biased < expectedCodewordLength biased c := by
  obtain ⟨c, hc, hl, _⟩ := exists_isBinaryPrefixCode_length_eq_ceil biased
  have ht : (c (biasedLabel true)).length = 1 := by
    rw [hl]
    simpa [biasedLabel, biased_mass] using biased_ceil_true
  have hf : (c (biasedLabel false)).length = 2 := by
    rw [hl]
    simpa [biasedLabel, biased_mass] using biased_ceil_false
  have hmean : expectedCodewordLength biased c = 5 / 4 := by
    rw [biased_mean, ht, hf]
    norm_num
  exact ⟨c, hc, ht, hf, hmean, biased_optimal, by rw [biased_optimal, hmean]; norm_num⟩

/-! ### A point mass with one supported label -/

-- At a known symbol count the sole supported symbol may use the empty word.
example :
    (PMF.pure false : PMF Bool) true = 0 ∧ true ∉ (PMF.pure false).supportFinset ∧
    ∃ c : ↥(PMF.pure false).supportFinset → List Bool, IsBinaryPrefixCode c ∧
      (∀ a, a.val = false ∧ c a = []) ∧ expectedCodewordLength (PMF.pure false) c = 0 ∧
      natsToBits (entropy (PMF.pure false)) = 0 ∧ optimalPrefixLength (PMF.pure false) = 0 ∧
      (∀ (n : ℕ) (x y : Fin n → ↥(PMF.pure false).supportFinset), x = y) := by
  let p : PMF Bool := PMF.pure false
  let c : ↥p.supportFinset → List Bool := fun _ => []
  have label (x : ↥p.supportFinset) : x.val = false :=
    (PMF.mem_support_pure_iff false x.val).mp ((p.mem_supportFinset x.val).mp x.property)
  have hc : IsBinaryPrefixCode c := fun {x y} _ => Subtype.ext ((label x).trans (label y).symm)
  have hmean : expectedCodewordLength p c = 0 := by simp [expectedCodewordLength, c]
  have hent : natsToBits (entropy p) = 0 := by simp [p, entropy_pure, natsToBits, natsToBase]
  have hopt := isLeast_optimalPrefixLength p
  exact ⟨by simp, by simp, c, hc, fun x => ⟨label x, rfl⟩, hmean, hent,
    le_antisymm (hopt.2 ⟨c, hc, hmean⟩) (hent ▸ (optimalPrefixLength_bounds p).1),
    fun _ x y => funext fun i => Subtype.ext ((label (x i)).trans (label (y i)).symm)⟩

/-! ### Two iid draws of the biased coin -/

private abbrev PairWord := Fin 2 → Bool
private noncomputable abbrev pairLaw := PMF.iid biased 2

private theorem pair_mem (x : PairWord) : x ∈ pairLaw.supportFinset := by
  apply (pairLaw.mem_supportFinset x).2
  exact (PMF.mem_support_finiteProduct_iff _ x).2
    (fun i => (biased.mem_supportFinset _).1 (biased_mem (x i)))

private def pairLabel (a b : Bool) : ↥pairLaw.supportFinset :=
  ⟨![a, b], pair_mem _⟩

private theorem pair_mass (a b : Bool) :
    (pairLaw ![a, b]).toReal = (biased a).toReal * (biased b).toReal := by
  simp [pairLaw, PMF.iid, PMF.finiteProduct_apply, Fin.prod_univ_two, ENNReal.toReal_mul]

-- Coordinate order is TT, TF, FT, FF.
private theorem pair_masses :
    (pairLaw ![true, true]).toReal = 9 / 16 ∧ (pairLaw ![true, false]).toReal = 3 / 16 ∧
    (pairLaw ![false, true]).toReal = 3 / 16 ∧ (pairLaw ![false, false]).toReal = 1 / 16 := by
  norm_num [pair_mass, biased_mass]

private theorem pair_mean (c : ↥pairLaw.supportFinset → List Bool) :
    expectedCodewordLength pairLaw c =
      (9 / 16) * (c (pairLabel true true)).length + (3 / 16) * (c (pairLabel true false)).length +
      ((3 / 16) * (c (pairLabel false true)).length +
        (1 / 16) * (c (pairLabel false false)).length) := by
  let e : PairWord ≃ ↥pairLaw.supportFinset :=
    ⟨fun x => ⟨x, pair_mem x⟩, Subtype.val, fun _ => rfl, fun _ => rfl⟩
  let f (x : ↥pairLaw.supportFinset) := (pairLaw x.val).toReal * ((c x).length : ℝ)
  change ∑ x, f x = _
  rw [← e.sum_comp f, ← (finTwoArrowEquiv Bool).symm.sum_comp (fun x => f (e x)),
    Fintype.sum_prod_type]
  simp only [Fintype.sum_bool]
  obtain ⟨htt, htf, hft, hff⟩ := pair_masses
  change (pairLaw ![true, true]).toReal * _ + (pairLaw ![true, false]).toReal * _ +
      ((pairLaw ![false, true]).toReal * _ + (pairLaw ![false, false]).toReal * _) = _
  rw [htt, htf, hft, hff]
  rfl

private def jointWords : Bool × Bool → List Bool
  | (true, true) => [false]
  | (true, false) => [true, false]
  | (false, true) => [true, true, false]
  | (false, false) => [true, true, true]

private def concatenatedWords (q : Bool × Bool) : List Bool :=
  oneBit (biasedLabel q.1) ++ oneBit (biasedLabel q.2)

private def pairCode (words : Bool × Bool → List Bool) (x : ↥pairLaw.supportFinset) : List Bool :=
  words (finTwoArrowEquiv Bool x.val)

private theorem pairCode_prefix {words : Bool × Bool → List Bool} (h : IsBinaryPrefixCode words) :
    IsBinaryPrefixCode (pairCode words) := fun {_ _} hp =>
  Subtype.ext ((finTwoArrowEquiv Bool).injective (h hp))

private theorem joint_prefix : IsBinaryPrefixCode (pairCode jointWords) := by
  apply pairCode_prefix
  rintro ⟨a, b⟩ ⟨c, d⟩
  cases a <;> cases b <;> cases c <;> cases d <;> decide

private theorem joint_mean : expectedCodewordLength pairLaw (pairCode jointWords) = 27 / 16 := by
  rw [pair_mean]
  norm_num [pairCode, jointWords, pairLabel, finTwoArrowEquiv]

-- Concatenate the very one-bit encoder whose mean attains the single-symbol optimum.
example : expectedCodewordLength biased oneBit = optimalPrefixLength biased ∧
    IsBinaryPrefixCode (pairCode concatenatedWords) ∧
    expectedCodewordLength pairLaw (pairCode concatenatedWords) = 2 ∧
    expectedCodewordLength pairLaw (pairCode jointWords) <
      expectedCodewordLength pairLaw (pairCode concatenatedWords) := by
  have hc : IsBinaryPrefixCode (pairCode concatenatedWords) := by
    apply pairCode_prefix
    rintro ⟨a, b⟩ ⟨c, d⟩
    cases a <;> cases b <;> cases c <;> cases d <;> decide
  have cost : expectedCodewordLength pairLaw (pairCode concatenatedWords) = 2 := by
    rw [pair_mean]
    norm_num [pairCode, concatenatedWords, oneBit, biasedLabel]
  exact ⟨oneBit_mean.trans biased_optimal.symm, hc, cost, by rw [cost, joint_mean]; norm_num⟩

-- The explicit joint code bounds the cost of a separately obtained block optimizer.
example : ∃ c : ↥pairLaw.supportFinset → List Bool, IsBinaryPrefixCode c ∧
    expectedCodewordLength pairLaw c = optimalPrefixLength pairLaw ∧
    optimalPrefixLength pairLaw / 2 ≤ 27 / 32 ∧ (27 / 32 : ℝ) < 1 ∧
    optimalPrefixLength biased = 1 := by
  have hleast := isLeast_optimalPrefixLength pairLaw
  obtain ⟨c, hc, hcost⟩ := hleast.1
  have h := hleast.2 ⟨pairCode jointWords, joint_prefix, joint_mean⟩
  exact ⟨c, hc, hcost, by linarith, by norm_num, biased_optimal⟩

example : natsToBits (entropy biased) ≤ optimalPrefixLength pairLaw / 2 ∧
    optimalPrefixLength pairLaw / 2 < natsToBits (entropy biased) + 1 / 2 := by
  simpa using optimalPrefixLength_iid_div_bounds biased 2 (by decide)

/-! ### Using the focused API on an arbitrary finite source -/

example {A : Type*} [Fintype A] (p : PMF A) (n : ℕ) (hn : 0 < n) :
    ∃ c : ↥(PMF.iid p n).supportFinset → List Bool,
      IsBinaryPrefixCode c ∧
      expectedCodewordLength (PMF.iid p n) c = optimalPrefixLength (PMF.iid p n) ∧
      natsToBits (entropy p) ≤ expectedCodewordLength (PMF.iid p n) c / (n : ℝ) ∧
      expectedCodewordLength (PMF.iid p n) c / (n : ℝ) < natsToBits (entropy p) + 1 / (n : ℝ) := by
  obtain ⟨c, hc, hcost⟩ := (isLeast_optimalPrefixLength (PMF.iid p n)).1
  exact ⟨c, hc, hcost, by simpa only [hcost] using optimalPrefixLength_iid_div_bounds p n hn⟩

end LeanInfoTheory.Examples.PrefixCodeLength
