/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.PrefixCode
import LeanInfoTheory.Shannon.Units

/-!
# Expected lengths of binary prefix codes

A finite source assigns words only to the atoms of its positive support.
The mean codeword length counts binary digits. Every prefix code has mean
at least the source entropy in bits. Rounding each supported symbol's binary
information up gives a prefix code with mean strictly below entropy in bits plus one.
An encoder attains the least mean `optimalPrefixLength`, which obeys both bounds.
-/

namespace LeanInfoTheory.Shannon

universe u

open scoped BigOperators

variable {A : Type u} [Fintype A]

/-- Mean length in binary digits of a word assignment on the support of a finite source. -/
noncomputable def expectedCodewordLength (p : PMF A)
    (c : ↥p.supportFinset → List Bool) : ℝ :=
  ∑ a : ↥p.supportFinset, (p a.val).toReal * ((c a).length : ℝ)

/-- Zero masses contribute nothing to a sum whose summand vanishes at zero. -/
private theorem sum_support_toReal (p : PMF A) (f : ℝ → ℝ) (hzero : f 0 = 0) :
    (∑ a : ↥p.supportFinset, f (p a.val).toReal) = ∑ a : A, f (p a).toReal := by
  classical
  rw [Finset.sum_coe_sort p.supportFinset (fun a : A => f (p a).toReal)]
  apply Finset.sum_subset (Finset.subset_univ _)
  intro a _ ha
  have hmass : p a = 0 := (p.apply_eq_zero_iff a).2 fun hs =>
    ha ((p.mem_supportFinset a).2 hs)
  simpa only [hmass, ENNReal.toReal_zero] using hzero

/-- The tangent bound for the logarithm at the ratio of Kraft weight to atom mass. -/
private theorem negMulLog_sub_codeword_term_le (m : ℝ) (hm : 0 < m) (k : ℕ) :
    Real.negMulLog m - (m * k) * Real.log 2 ≤ (1 / 2 : ℝ) ^ k - m := by
  have hw : 0 < (1 / 2 : ℝ) ^ k := by positivity
  calc
    Real.negMulLog m - (m * k) * Real.log 2 =
        m * Real.log ((1 / 2 : ℝ) ^ k / m) := by
      rw [Real.log_div hw.ne' hm.ne', Real.log_pow, one_div, Real.log_inv, Real.negMulLog]
      ring
    _ ≤ m * ((1 / 2 : ℝ) ^ k / m - 1) :=
      mul_le_mul_of_nonneg_left (Real.log_le_sub_one_of_pos (div_pos hw hm)) hm.le
    _ = (1 / 2 : ℝ) ^ k - m := by field_simp

/-- Every binary prefix code on the supported symbols has mean length at least the
source entropy in bits. -/
theorem natsToBits_entropy_le_expectedCodewordLength (p : PMF A)
    {c : ↥p.supportFinset → List Bool} (hc : IsBinaryPrefixCode c) :
    natsToBits (entropy p) ≤ expectedCodewordLength p c := by
  have hmass : (∑ a : ↥p.supportFinset, (p a.val).toReal) = 1 :=
    (sum_support_toReal p id rfl).trans p.sum_toReal
  have hentropy : (∑ a : ↥p.supportFinset, Real.negMulLog (p a.val).toReal) = entropy p :=
    (sum_support_toReal p Real.negMulLog Real.negMulLog_zero).trans (entropy_eq_sum p).symm
  have hterm (a : ↥p.supportFinset) :=
    negMulLog_sub_codeword_term_le (p a.val).toReal
      (ENNReal.toReal_pos ((p.mem_support_iff a.val).1 ((p.mem_supportFinset a.val).1 a.prop))
        (p.apply_ne_top a.val)) (c a).length
  have hsum := Finset.sum_le_sum (s := Finset.univ) (fun a _ => hterm a)
  rw [Finset.sum_sub_distrib, Finset.sum_sub_distrib, ← Finset.sum_mul, hmass, hentropy] at hsum
  change entropy p / Real.log 2 ≤ ∑ a : ↥p.supportFinset, (p a.val).toReal * ((c a).length : ℝ)
  apply (div_le_iff₀ (Real.log_pos (by norm_num : (1 : ℝ) < 2))).2
  linarith [hc.kraft_sum_le_one]

/-- A binary prefix encoder realizes the rounded-up information of each supported
symbol and has mean length strictly less than entropy in bits plus one. -/
theorem exists_isBinaryPrefixCode_length_eq_ceil (p : PMF A) :
    ∃ c : ↥p.supportFinset → List Bool, IsBinaryPrefixCode c ∧
      (∀ a, (c a).length = ⌈-Real.logb 2 (p a.val).toReal⌉₊) ∧
      expectedCodewordLength p c < natsToBits (entropy p) + 1 := by
  let m (a : ↥p.supportFinset) := (p a.val).toReal
  let info (a : ↥p.supportFinset) := -Real.logb 2 (m a)
  let ℓ (a : ↥p.supportFinset) := ⌈info a⌉₊
  have hm (a : ↥p.supportFinset) : 0 < m a :=
    ENNReal.toReal_pos ((p.mem_support_iff a.val).1 ((p.mem_supportFinset a.val).1 a.prop))
      (p.apply_ne_top a.val)
  have hinfo (a : ↥p.supportFinset) : 0 ≤ info a :=
    neg_nonneg.mpr (Real.logb_nonpos (by norm_num) (hm a).le (p.toReal_le_one a.val))
  have hmass : ∑ a, m a = 1 := (sum_support_toReal p id rfl).trans p.sum_toReal
  have hwidth (a : ↥p.supportFinset) : (1 / 2 : ℝ) ^ (ℓ a) ≤ m a := by
    have hceil : -Real.logb 2 (m a) ≤ (ℓ a : ℝ) := Nat.le_ceil (info a)
    have hlog : -(ℓ a : ℝ) ≤ Real.logb 2 (m a) := by linarith
    simpa only [Real.rpow_neg (by norm_num : (0 : ℝ) ≤ 2), Real.rpow_natCast,
      one_div, inv_pow] using (Real.le_logb_iff_rpow_le (by norm_num : (1 : ℝ) < 2) (hm a)).mp hlog
  have hkraft : (∑ a, (1 / 2 : ℝ) ^ (ℓ a)) ≤ 1 :=
    (Finset.sum_le_sum (fun a _ => hwidth a)).trans_eq hmass
  obtain ⟨c, hc, hlength⟩ := exists_isBinaryPrefixCode_of_kraft_sum_le_one ℓ hkraft
  refine ⟨c, hc, hlength, ?_⟩
  have hbits : (∑ a, m a * info a) = natsToBits (entropy p) := by
    calc
      (∑ a, m a * info a) = ∑ a, -(m a) * Real.logb 2 (m a) := by
        simp only [info, mul_neg, neg_mul]
      _ = ∑ a : A, -(p a).toReal * Real.logb 2 (p a).toReal :=
        sum_support_toReal p (fun x => -x * Real.logb 2 x) (by simp)
      _ = natsToBits (entropy p) := (entropy_div_log p 2).symm
  obtain ⟨a, ha⟩ := p.supportFinset_nonempty
  have hne : (Finset.univ : Finset ↥p.supportFinset).Nonempty := ⟨⟨a, ha⟩, Finset.mem_univ _⟩
  rw [expectedCodewordLength]
  simp_rw [hlength]
  calc
    (∑ a, m a * (ℓ a : ℝ)) < ∑ a, m a * (info a + 1) :=
      Finset.sum_lt_sum_of_nonempty hne (fun a _ =>
        mul_lt_mul_of_pos_left (Nat.ceil_lt_add_one (hinfo a)) (hm a))
    _ = natsToBits (entropy p) + 1 := by
      simp only [mul_add, mul_one, Finset.sum_add_distrib, hbits, hmass]

/-- The infimum of mean lengths of binary prefix codes on the positive support. -/
noncomputable def optimalPrefixLength (p : PMF A) : ℝ :=
  sInf {t : ℝ | ∃ c : ↥p.supportFinset → List Bool,
    IsBinaryPrefixCode c ∧ expectedCodewordLength p c = t}

/-- A prefix code attains the least mean length among all prefix codes on the support. -/
theorem isLeast_optimalPrefixLength (p : PMF A) :
    IsLeast {t : ℝ | ∃ c : ↥p.supportFinset → List Bool,
      IsBinaryPrefixCode c ∧ expectedCodewordLength p c = t}
      (optimalPrefixLength p) := by
  classical
  obtain ⟨seed, hseed, _, _⟩ := exists_isBinaryPrefixCode_length_eq_ceil p
  let B := expectedCodewordLength p seed
  let m (a : ↥p.supportFinset) := (p a.val).toReal
  have hm (a : ↥p.supportFinset) : 0 < m a :=
    ENNReal.toReal_pos ((p.mem_support_iff a.val).1 ((p.mem_supportFinset a.val).1 a.prop))
      (p.apply_ne_top a.val)
  let cap (a : ↥p.supportFinset) := ⌊B / m a⌋₊
  let Profile := (a : ↥p.supportFinset) → Fin (cap a + 1)
  let cost (v : Profile) := ∑ a, m a * ((v a).val : ℝ)
  let feasible := Finset.univ.filter fun v : Profile =>
    (∑ a, (1 / 2 : ℝ) ^ (v a).val) ≤ 1
  -- Every code competitive with the seed fits all the coordinate bounds.
  have bounded (d : ↥p.supportFinset → List Bool) (hd : IsBinaryPrefixCode d)
      (hB : expectedCodewordLength p d ≤ B) :
      ∃ v ∈ feasible, cost v = expectedCodewordLength p d := by
    have hcap (a : ↥p.supportFinset) : (d a).length ≤ cap a := by
      apply Nat.le_floor
      apply (le_div_iff₀ (hm a)).2
      calc
        ((d a).length : ℝ) * m a = m a * ((d a).length : ℝ) := mul_comm _ _
        _ ≤ expectedCodewordLength p d :=
          Finset.single_le_sum (f := fun x => m x * ((d x).length : ℝ))
            (fun x _ => mul_nonneg (hm x).le (Nat.cast_nonneg _)) (Finset.mem_univ a)
        _ ≤ B := hB
    let v : Profile := fun a => ⟨(d a).length, Nat.lt_succ_of_le (hcap a)⟩
    exact ⟨v, Finset.mem_filter.mpr ⟨Finset.mem_univ _, hd.kraft_sum_le_one⟩, rfl⟩
  obtain ⟨seedProfile, hseedMem, hseedCost⟩ := bounded seed hseed le_rfl
  obtain ⟨best, hbestMem, hmin⟩ :=
    feasible.exists_min_image cost ⟨seedProfile, hseedMem⟩
  obtain ⟨c, hc, hlength⟩ := exists_isBinaryPrefixCode_of_kraft_sum_le_one
    (fun a => (best a).val) (Finset.mem_filter.mp hbestMem).2
  have hcost : expectedCodewordLength p c = cost best := by
    simp only [expectedCodewordLength, cost, m, hlength]
  let costs := {t : ℝ | ∃ c : ↥p.supportFinset → List Bool,
    IsBinaryPrefixCode c ∧ expectedCodewordLength p c = t}
  have hleast : IsLeast costs (cost best) := by
    refine ⟨⟨c, hc, hcost⟩, ?_⟩
    rintro _ ⟨d, hd, rfl⟩
    by_cases hB : expectedCodewordLength p d ≤ B
    · obtain ⟨v, hv, hcostV⟩ := bounded d hd hB
      exact (hmin v hv).trans_eq hcostV
    · exact ((hmin seedProfile hseedMem).trans_eq hseedCost).trans (le_of_not_ge hB)
  change IsLeast costs (sInf costs)
  rw [hleast.csInf_eq]
  exact hleast

/-- The attained optimal binary prefix length is at least the entropy in bits
and strictly smaller than entropy in bits plus one. -/
theorem optimalPrefixLength_bounds (p : PMF A) :
    natsToBits (entropy p) ≤ optimalPrefixLength p ∧
      optimalPrefixLength p < natsToBits (entropy p) + 1 := by
  have hleast := isLeast_optimalPrefixLength p
  obtain ⟨c, hc, hcost⟩ := hleast.1
  obtain ⟨s, hs, _, hupper⟩ := exists_isBinaryPrefixCode_length_eq_ceil p
  exact ⟨(natsToBits_entropy_le_expectedCodewordLength p hc).trans_eq hcost,
    (hleast.2 ⟨s, hs, rfl⟩).trans_lt hupper⟩

end LeanInfoTheory.Shannon
