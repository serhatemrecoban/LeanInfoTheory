/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCoding
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Order.LiminfLimsup

/-!
# Vanishing-error channel-code rate bounds

For one arbitrary family of positive-budget deterministic block codes, vanishing
average error forces every positive-tolerance eventual rate cap and the real
limsup bound by the channel's information capacity. Rates are canonical nats.

The finite converse first bounds rates eventually by `2 * (C + log 2)`.
Only then is the vanishing overhead bounded using error times that fixed bound;
no rate limit or convergence of error times the actual rate is assumed. The
real limsup proof supplies both its derived upper boundedness and the lower
control from rate nonnegativity explicitly. All families include length zero,
and no condition is imposed on a finite initial segment.

An eventual rate lower bound strictly above capacity gives a quantitative error
bound, an explicit eventual positive floor and failure of vanishing error.
A fixed positive gap occurring infinitely often also prevents vanishing error,
without imposing a rate bound or concluding an eventual error floor.

This adapts the fixed-rate weak-converse reasoning of CT91 §8.9 and PW24 §17.4
to arbitrary natural message budgets. No achievability or strong converse is
asserted here.
-/

namespace LeanInfoTheory.Shannon.BlockChannelCode

noncomputable section

universe u v

open Filter Topology

variable {A : Type u} {B : Type v}

private theorem eventually_codeRate_le_bound
    [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode A B n (M n))
    (he : Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0)) :
    ∀ᶠ n in atTop, codeRate n (M n) ≤ 2 * (channelCapacity W + Real.log 2) := by
  have hsmall := he.eventually (gt_mem_nhds (by norm_num : (0 : ℝ) < 1 / 2))
  filter_upwards [hsmall, eventually_ge_atTop (1 : ℕ)] with n hpe hn
  have hnpos : 0 < n := lt_of_lt_of_le Nat.zero_lt_one hn
  have hn' : (0 : ℝ) < n := by exact_mod_cast hnpos
  have hn1 : (1 : ℝ) ≤ n := by exact_mod_cast hn
  have hlog : 0 ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  have ht : Real.log 2 / (n : ℝ) ≤ Real.log 2 := by
    apply (div_le_iff₀ hn').2
    simpa only [mul_one] using mul_le_mul_of_nonneg_left hn1 hlog
  have hhalf : (1 / 2 : ℝ) ≤ 1 - (c n).errorProbability W (hM n) := by
    linarith only [hpe]
  have hf := (c n).one_sub_errorProbability_mul_codeRate_le W (hM n) hnpos
  have hrhalf := (mul_le_mul_of_nonneg_right hhalf
    (codeRate_nonneg n (M n) (hM n))).trans hf
  linarith only [hrhalf, ht]

/-- Vanishing average error forces each positive-tolerance eventual rate cap.
The same arbitrary family is used at every tolerance, including its zero-length
and finite-prefix data. No rate boundedness or convergence is assumed. -/
theorem eventually_codeRate_le_channelCapacity_add
    [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode A B n (M n))
    (he : Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0))
    (δ : ℝ) (hδ : 0 < δ) :
    ∀ᶠ n in atTop, codeRate n (M n) ≤ channelCapacity W + δ := by
  let bound : ℝ := 2 * (channelCapacity W + Real.log 2)
  have hbound : ∀ᶠ n in atTop, codeRate n (M n) ≤ bound :=
    eventually_codeRate_le_bound W M hM c he
  have hlimit := (tendsto_const_div_atTop_nhds_zero_nat (Real.log 2)).add
    (he.mul_const bound)
  simp only [zero_mul, zero_add] at hlimit
  have hsmall := hlimit.eventually (gt_mem_nhds hδ)
  filter_upwards [hbound, hsmall, eventually_gt_atTop (0 : ℕ)] with n hnBound hnSmall hn
  have hf := (c n).one_sub_errorProbability_mul_codeRate_le W (hM n) hn
  have hmul := mul_le_mul_of_nonneg_left hnBound ((c n).errorProbability_nonneg W (hM n))
  calc
    codeRate n (M n) =
        (1 - (c n).errorProbability W (hM n)) * codeRate n (M n) +
          (c n).errorProbability W (hM n) * codeRate n (M n) := by ring
    _ ≤ (channelCapacity W + Real.log 2 / (n : ℝ)) +
        (c n).errorProbability W (hM n) * bound := add_le_add hf hmul
    _ ≤ channelCapacity W + δ := by linarith only [hnSmall]

/-- The real limsup of rates is at most capacity when the actual family error
vanishes. Eventual upper boundedness is derived from the finite converse;
nonnegative rates provide the explicit coboundedness needed by real limsup. -/
theorem limsup_codeRate_le_channelCapacity
    [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode A B n (M n))
    (he : Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0)) :
    Filter.limsup (fun n => codeRate n (M n)) atTop ≤ channelCapacity W := by
  have hbounded := isBoundedUnder_of_eventually_le
    (eventually_codeRate_le_bound W M hM c he)
  have hcobounded := isCoboundedUnder_le_of_le atTop
    (fun n => codeRate_nonneg n (M n) (hM n))
  apply (limsup_le_iff' hcobounded hbounded).2
  intro y hy
  filter_upwards [eventually_codeRate_le_channelCapacity_add W M hM c he
    (y - channelCapacity W) (sub_pos.mpr hy)] with n hn
  linarith only [hn]

/-- An eventual rate lower bound strictly above capacity gives the finite
quantitative error bound eventually. Positivity of the requested rate follows
from capacity nonnegativity; positive blocklength is needed only on a tail. -/
theorem eventually_one_sub_channelCapacity_div_sub_le_errorProbability
    [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode A B n (M n))
    {R : ℝ} (hR : channelCapacity W < R)
    (hrate : ∀ᶠ n in atTop, R ≤ codeRate n (M n)) :
    ∀ᶠ n : ℕ in atTop, 1 - channelCapacity W / R - Real.log 2 / ((n : ℝ) * R) ≤
      (c n).errorProbability W (hM n) := by
  have hRpos : 0 < R := (channelCapacity_nonneg W).trans_lt hR
  filter_upwards [hrate, eventually_gt_atTop (0 : ℕ)] with n hr hn
  exact (c n).one_sub_channelCapacity_div_sub_le_errorProbability W (hM n) hn hRpos hr

/-- An eventual rate lower bound strictly above capacity forces the explicit
positive error floor `(1 - channelCapacity W / R) / 2` eventually.
No boundedness or convergence of the rates is assumed. -/
theorem eventually_pos_le_errorProbability_of_eventually_le_codeRate
    [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode A B n (M n))
    {R : ℝ} (hR : channelCapacity W < R)
    (hrate : ∀ᶠ n in atTop, R ≤ codeRate n (M n)) :
    0 < (1 - channelCapacity W / R) / 2 ∧
      ∀ᶠ n : ℕ in atTop, (1 - channelCapacity W / R) / 2 ≤
        (c n).errorProbability W (hM n) := by
  have hRpos : 0 < R := (channelCapacity_nonneg W).trans_lt hR
  have hratio : channelCapacity W / R < 1 := (div_lt_one hRpos).2 hR
  have hpos : 0 < (1 - channelCapacity W / R) / 2 := by linarith only [hratio]
  refine ⟨hpos, ?_⟩
  have hlimit : Tendsto (fun n : ℕ => Real.log 2 / ((n : ℝ) * R)) atTop (nhds 0) := by
    simpa only [div_div, zero_div] using
      (tendsto_const_div_atTop_nhds_zero_nat (Real.log 2)).div_const R
  have hsmall := hlimit.eventually (gt_mem_nhds hpos)
  filter_upwards [eventually_one_sub_channelCapacity_div_sub_le_errorProbability
    W M hM c hR hrate, hsmall] with n hb hs
  linarith only [hb, hs]

/-- An eventual rate lower bound strictly above capacity prevents the actual
family error from tending to zero. The explicit positive floor is derived
without any bounded-rate or rate-convergence premise. -/
theorem not_tendsto_errorProbability_zero_of_eventually_le_codeRate
    [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode A B n (M n))
    {R : ℝ} (hR : channelCapacity W < R)
    (hrate : ∀ᶠ n in atTop, R ≤ codeRate n (M n)) :
    ¬ Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0) := by
  obtain ⟨hpos, hfloor⟩ :=
    eventually_pos_le_errorProbability_of_eventually_le_codeRate W M hM c hR hrate
  intro he
  obtain ⟨n, hlo, hhi⟩ := (hfloor.and (he.eventually (gt_mem_nhds hpos))).exists
  exact (not_lt_of_ge hlo) hhi

/-- A fixed positive rate gap occurring infinitely often prevents vanishing
error, even for unbounded or nonconvergent rates. This conclusion does not
assert an eventual positive error floor or use a real-limsup convention. -/
theorem not_tendsto_errorProbability_zero_of_frequently_channelCapacity_add_le_codeRate
    [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode A B n (M n))
    {η : ℝ} (hη : 0 < η)
    (hrate : ∃ᶠ n in atTop, channelCapacity W + η ≤ codeRate n (M n)) :
    ¬ Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0) := by
  intro he
  have hcap := eventually_codeRate_le_channelCapacity_add W M hM c he
    (η / 2) (half_pos hη)
  obtain ⟨n, hlo, hhi⟩ := (hrate.and_eventually hcap).exists
  linarith only [hlo, hhi, hη]

end
end LeanInfoTheory.Shannon.BlockChannelCode
