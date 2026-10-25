/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCodingAsymptotic
import LeanInfoTheory.Shannon.StandardChannelCapacity

/-!
# Asymptotic channel-code consumers

The public eventual rate cap and real limsup bound apply to actual deterministic
code families. Singleton messages have zero error through every channel. A
noiseless Boolean family alternates between one message and an enumeration of
all binary words. Every code recovers its messages, while its rates alternate
between zero and log two and have no real limit.

The zero-length member has one message; the one-letter member has two. Both
errors and their scalar rates are checked explicitly. All code constructions,
enumeration and parity calculations remain private to this focused consumer.

Two constant-decoder families separate the eventual and frequent obstructions.
Over the positive-capacity noiseless channel, budgets `4^n` give a nonvacuous
finite converse and an eventual positive error floor. Over a zero-capacity
constant-output channel, alternating singleton and `2^(n*n)` budgets give
unbounded rate spikes but retain arbitrarily late zero-error lengths.

A final consumer composes the actual sampling laws, error interpretations,
Markov/data-processing/Fano interfaces, finite and normalized bounds, and both
vanishing-error rate conclusions on the same alternating lossless family.
Its rates still have no real limit; no abstract code-sequence interface is added.
-/

namespace LeanInfoTheory.Examples.ChannelCodingAsymptotic

noncomputable section

universe u v

open Filter Topology
open scoped BigOperators
open LeanInfoTheory.Shannon

private def singletonCode {A : Type u} (a : A) (B : Type v) (n : ℕ) :
    BlockChannelCode A B n 1 :=
  (fun _ _ => a, fun _ => 0)

private theorem singleton_family {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B] (a : A) (W : A → PMF B) :
    Tendsto (fun n => (singletonCode a B n).errorProbability W (by decide))
        atTop (nhds 0) ∧
      (∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop,
        codeRate n 1 ≤ channelCapacity W + δ) ∧
      Filter.limsup (fun n => codeRate n 1) atTop ≤ channelCapacity W := by
  have he : Tendsto (fun n => (singletonCode a B n).errorProbability W (by decide))
      atTop (nhds 0) := by
    have heq : (fun n => (singletonCode a B n).errorProbability W (by decide)) =
        (fun _ : ℕ => (0 : ℝ)) :=
      funext fun n => (singletonCode a B n).errorProbability_one W
    rw [heq]
    exact tendsto_const_nhds
  exact ⟨he,
    fun δ hδ => BlockChannelCode.eventually_codeRate_le_channelCapacity_add W
      (fun _ => 1) (fun _ => by decide) (singletonCode a B) he δ hδ,
    BlockChannelCode.limsup_codeRate_le_channelCapacity W
      (fun _ => 1) (fun _ => by decide) (singletonCode a B) he⟩

private theorem singleton_zero_one {A : Type u} {B : Type v} [Fintype B]
    (a : A) (W : A → PMF B) :
    (singletonCode a B 0).errorProbability W (by decide) = 0 ∧
      (singletonCode a B 1).errorProbability W (by decide) = 0 ∧
      codeRate 0 1 = 0 ∧ codeRate 1 1 = 0 :=
  ⟨(singletonCode a B 0).errorProbability_one W,
    (singletonCode a B 1).errorProbability_one W, codeRate_zero 1, codeRate_one 1⟩

/-! ## Every binary word as a message over the noiseless channel -/

private def noiseless : Bool → PMF Bool := PMF.deterministicChannel id

private def binaryWords (n : ℕ) : (Fin n → Bool) ≃ Fin (2 ^ n) :=
  Fintype.equivFinOfCardEq (by simp)

private def fullWordCode (n : ℕ) : BlockChannelCode Bool Bool n (2 ^ n) :=
  ((binaryWords n).symm, binaryWords n)

private theorem fullWordCode_recovery (n : ℕ) (m : Fin (2 ^ n)) :
    (fullWordCode n).decoder ((fullWordCode n).encoder m) = m :=
  (binaryWords n).apply_symm_apply m

private theorem noiseless_row (n : ℕ) (x : Fin n → Bool) :
    PMF.memorylessChannel noiseless n x = PMF.pure x := by
  unfold PMF.memorylessChannel noiseless
  rw [PMF.productChannel_deterministicChannel]
  rfl

private theorem error_eq_zero_of_noiseless_recovery {n M : ℕ}
    (c : BlockChannelCode Bool Bool n M) (hM : 1 ≤ M)
    (hc : ∀ m, c.decoder (c.encoder m) = m) :
    c.errorProbability noiseless hM = 0 := by
  classical
  rw [c.errorProbability_eq_sum]
  have hinner (m : Fin M) :
      (∑ y : Fin n → Bool, if c.decoder y ≠ m then
        (PMF.memorylessChannel noiseless n (c.encoder m) y).toReal else 0) = 0 := by
    apply Finset.sum_eq_zero
    intro y _
    by_cases hy : y = c.encoder m
    · subst y
      simp [hc]
    · simp [noiseless_row, PMF.pure_apply, hy]
  simp_rw [hinner]
  simp

private theorem fullWordCode_error (n : ℕ) :
    (fullWordCode n).errorProbability noiseless
      (one_le_pow₀ (by decide : 1 ≤ (2 : ℕ))) = 0 :=
  error_eq_zero_of_noiseless_recovery (fullWordCode n) _ (fullWordCode_recovery n)

private theorem full_word_rate {n : ℕ} (hn : 0 < n) :
    codeRate n (2 ^ n) = Real.log 2 := by
  have hn' : (n : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hn)
  simp only [codeRate, Nat.cast_pow, Nat.cast_ofNat, Real.log_pow]
  field_simp

/-! ## One family with zero error and nonconvergent rates -/

private def alternatingData (n : ℕ) : Σ M : ℕ, BlockChannelCode Bool Bool n M :=
  if n % 2 = 0 then ⟨1, singletonCode false Bool n⟩
  else ⟨2 ^ n, fullWordCode n⟩

private def alternatingBudget (n : ℕ) : ℕ := (alternatingData n).1

private theorem alternatingBudget_pos (n : ℕ) : 1 ≤ alternatingBudget n := by
  unfold alternatingBudget alternatingData
  split_ifs
  · exact le_rfl
  · exact one_le_pow₀ (by decide : 1 ≤ (2 : ℕ))

private def alternatingCode (n : ℕ) :
    BlockChannelCode Bool Bool n (alternatingBudget n) :=
  (alternatingData n).2

private theorem alternating_error (n : ℕ) :
    (alternatingCode n).errorProbability noiseless (alternatingBudget_pos n) = 0 := by
  let P := fun data : Σ M : ℕ, BlockChannelCode Bool Bool n M =>
    ∀ hM : 1 ≤ data.1, data.2.errorProbability noiseless hM = 0
  have hdata : P (alternatingData n) := by
    by_cases hn : n % 2 = 0
    · exact (congrArg P
        (show alternatingData n = ⟨1, singletonCode false Bool n⟩ from if_pos hn)).mpr
          (fun _ => (singletonCode false Bool n).errorProbability_one noiseless)
    · exact (congrArg P
        (show alternatingData n = ⟨2 ^ n, fullWordCode n⟩ from if_neg hn)).mpr
          (fun _ => fullWordCode_error n)
  exact hdata (alternatingBudget_pos n)

private theorem alternating_rate_even {n : ℕ} (hn : n % 2 = 0) :
    codeRate n (alternatingBudget n) = 0 := by
  simp only [alternatingBudget, alternatingData, if_pos hn, codeRate_one]

private theorem alternating_rate_odd {n : ℕ} (hn : 0 < n) (hodd : n % 2 ≠ 0) :
    codeRate n (alternatingBudget n) = Real.log 2 := by
  simpa only [alternatingBudget, alternatingData, if_neg hodd] using full_word_rate hn

private theorem alternating_zero_one :
    alternatingBudget 0 = 1 ∧ alternatingBudget 1 = 2 ∧
      (alternatingCode 0).errorProbability noiseless (alternatingBudget_pos 0) = 0 ∧
      (alternatingCode 1).errorProbability noiseless (alternatingBudget_pos 1) = 0 ∧
      codeRate 0 (alternatingBudget 0) = 0 ∧
      codeRate 1 (alternatingBudget 1) = Real.log 2 := by
  refine ⟨by simp [alternatingBudget, alternatingData],
    by simp [alternatingBudget, alternatingData], alternating_error 0,
    alternating_error 1, codeRate_zero _, ?_⟩
  exact alternating_rate_odd (by decide) (by decide)

private theorem alternating_error_tendsto_zero :
    Tendsto (fun n => (alternatingCode n).errorProbability noiseless (alternatingBudget_pos n))
      atTop (nhds 0) := by
  have heq :
      (fun n => (alternatingCode n).errorProbability noiseless (alternatingBudget_pos n)) =
        (fun _ : ℕ => (0 : ℝ)) := funext alternating_error
  rw [heq]
  exact tendsto_const_nhds

private theorem alternating_public_endpoints :
    (∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop,
      codeRate n (alternatingBudget n) ≤ channelCapacity noiseless + δ) ∧
      Filter.limsup (fun n => codeRate n (alternatingBudget n)) atTop ≤
        channelCapacity noiseless :=
  ⟨fun δ hδ => BlockChannelCode.eventually_codeRate_le_channelCapacity_add
    noiseless alternatingBudget alternatingBudget_pos alternatingCode
    alternating_error_tendsto_zero δ hδ,
    BlockChannelCode.limsup_codeRate_le_channelCapacity
      noiseless alternatingBudget alternatingBudget_pos alternatingCode
      alternating_error_tendsto_zero⟩

private theorem alternating_rates_not_convergent (l : ℝ) :
    ¬ Tendsto (fun n => codeRate n (alternatingBudget n)) atTop (nhds l) := by
  intro h
  have hevenIndex : Tendsto (fun n : ℕ => 2 * n) atTop atTop :=
    tendsto_atTop_mono (f := fun n : ℕ => n) (fun n => by omega) tendsto_id
  have hoddIndex : Tendsto (fun n : ℕ => 2 * n + 1) atTop atTop :=
    tendsto_atTop_mono (f := fun n : ℕ => n) (fun n => by omega) tendsto_id
  have hevenRate (n : ℕ) : codeRate (2 * n) (alternatingBudget (2 * n)) = 0 :=
    alternating_rate_even (by omega)
  have hoddRate (n : ℕ) :
      codeRate (2 * n + 1) (alternatingBudget (2 * n + 1)) = Real.log 2 :=
    alternating_rate_odd (by omega) (by omega)
  have heven := h.comp hevenIndex
  have hodd := h.comp hoddIndex
  simp only [Function.comp_def, hevenRate] at heven
  simp only [Function.comp_def, hoddRate] at hodd
  have hlzero : (0 : ℝ) = l := tendsto_const_nhds_iff.mp heven
  have hllog : Real.log 2 = l := tendsto_const_nhds_iff.mp hodd
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  linarith only [hlzero, hllog, hlog]

/-! ## Constant-decoder codes and a positive-capacity obstruction -/

private def constantCode (n M : ℕ) (hM : 1 ≤ M) : BlockChannelCode Bool Bool n M :=
  (fun _ _ => false, fun _ => ⟨0, hM⟩)

private theorem constantCode_error (n M : ℕ) (hM : 1 ≤ M) (W : Bool → PMF Bool) :
    (constantCode n M hM).errorProbability W hM = 1 - 1 / (M : ℝ) := by
  classical
  rw [BlockChannelCode.errorProbability_eq_sum]
  have hinner (m : Fin M) :
      (∑ y : Fin n → Bool, if (constantCode n M hM).decoder y ≠ m then
        (PMF.memorylessChannel W n ((constantCode n M hM).encoder m) y).toReal else 0) =
        if (⟨0, hM⟩ : Fin M) ≠ m then (1 : ℝ) else 0 := by
    by_cases hm : (⟨0, hM⟩ : Fin M) ≠ m <;>
      simp [constantCode, BlockChannelCode.decoder, hm, PMF.sum_toReal]
  simp_rw [hinner]
  have hsum : (∑ m : Fin M, if (⟨0, hM⟩ : Fin M) ≠ m then (1 : ℝ) else 0) =
      (M : ℝ) - 1 := by
    calc
      _ = ∑ m : Fin M, (1 - if (⟨0, hM⟩ : Fin M) = m then (1 : ℝ) else 0) := by
        apply Finset.sum_congr rfl
        intro m _
        by_cases hm : (⟨0, hM⟩ : Fin M) = m <;> simp [hm]
      _ = (M : ℝ) - 1 := by simp [Finset.sum_sub_distrib]
  rw [hsum]
  have hMr : (M : ℝ) ≠ 0 := by exact_mod_cast (show M ≠ 0 by omega)
  field_simp

private theorem noiseless_capacity : channelCapacity noiseless = Real.log 2 := by
  simpa [noiseless] using (channelCapacity_deterministicChannel_id (A := Bool))

private def fourBudget (n : ℕ) : ℕ := 4 ^ n

private theorem fourBudget_pos (n : ℕ) : 1 ≤ fourBudget n :=
  one_le_pow₀ (by decide : 1 ≤ (4 : ℕ))

private def fourCode (n : ℕ) : BlockChannelCode Bool Bool n (fourBudget n) :=
  constantCode n (fourBudget n) (fourBudget_pos n)

private theorem fourCode_error (n : ℕ) :
    (fourCode n).errorProbability noiseless (fourBudget_pos n) = 1 - 1 / (4 : ℝ) ^ n := by
  simpa only [fourCode, fourBudget, Nat.cast_pow, Nat.cast_ofNat] using
    constantCode_error n (fourBudget n) (fourBudget_pos n) noiseless

private theorem four_rate {n : ℕ} (hn : 0 < n) :
    codeRate n (fourBudget n) = 2 * Real.log 2 := by
  have hn' : (n : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hn)
  have hlog4 : Real.log 4 = 2 * Real.log 2 := by
    simpa only [show (2 : ℝ) ^ 2 = 4 by norm_num, Nat.cast_ofNat] using
      (Real.log_pow (2 : ℝ) 2)
  simp only [codeRate, fourBudget, Nat.cast_pow, Nat.cast_ofNat, Real.log_pow, hlog4]
  field_simp

private theorem four_bound_expression {n : ℕ} (hn : 0 < n) :
    1 - channelCapacity noiseless / (2 * Real.log 2) -
        Real.log 2 / ((n : ℝ) * (2 * Real.log 2)) =
      1 / 2 - 1 / (2 * (n : ℝ)) := by
  have hn' : (n : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hn)
  have hlog : Real.log 2 ≠ 0 := ne_of_gt (Real.log_pos (by norm_num))
  rw [noiseless_capacity]
  field_simp
  ring

private theorem four_pointwise_bound {n : ℕ} (hn : 0 < n) :
    1 / 2 - 1 / (2 * (n : ℝ)) ≤
      (fourCode n).errorProbability noiseless (fourBudget_pos n) := by
  have hR : 0 < 2 * Real.log 2 := mul_pos (by norm_num) (Real.log_pos (by norm_num))
  have h := (fourCode n).one_sub_channelCapacity_div_sub_le_errorProbability
    noiseless (fourBudget_pos n) hn hR (four_rate hn).ge
  rwa [four_bound_expression hn] at h

private theorem four_finite_nonvacuous :
    fourBudget 2 = 16 ∧
      (fourCode 2).errorProbability noiseless (fourBudget_pos 2) = (15 / 16 : ℝ) ∧
      (1 / 4 : ℝ) ≤ (fourCode 2).errorProbability noiseless (fourBudget_pos 2) := by
  refine ⟨by decide, ?_, ?_⟩
  · have h := fourCode_error 2
    norm_num at h
    exact h
  · have h := four_pointwise_bound (by decide : 0 < 2)
    norm_num at h
    exact h

private theorem four_public_eventual :
    (∀ᶠ n : ℕ in atTop, 1 / 2 - 1 / (2 * (n : ℝ)) ≤
      (fourCode n).errorProbability noiseless (fourBudget_pos n)) ∧
      (0 < (1 / 4 : ℝ) ∧ ∀ᶠ n in atTop,
        (1 / 4 : ℝ) ≤ (fourCode n).errorProbability noiseless (fourBudget_pos n)) ∧
      ¬ Tendsto (fun n => (fourCode n).errorProbability noiseless (fourBudget_pos n))
        atTop (nhds 0) := by
  have hR : channelCapacity noiseless < 2 * Real.log 2 := by
    rw [noiseless_capacity]
    have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
    linarith
  have hrate : ∀ᶠ n in atTop, 2 * Real.log 2 ≤ codeRate n (fourBudget n) := by
    filter_upwards [eventually_gt_atTop (0 : ℕ)] with n hn
    exact (four_rate hn).ge
  have hquant := BlockChannelCode.eventually_one_sub_channelCapacity_div_sub_le_errorProbability
    noiseless fourBudget fourBudget_pos fourCode hR hrate
  have hfloor := BlockChannelCode.eventually_pos_le_errorProbability_of_eventually_le_codeRate
    noiseless fourBudget fourBudget_pos fourCode hR hrate
  have hquarter : (1 - channelCapacity noiseless / (2 * Real.log 2)) / 2 = (1 / 4 : ℝ) := by
    have hlog : Real.log 2 ≠ 0 := ne_of_gt (Real.log_pos (by norm_num))
    rw [noiseless_capacity]
    field_simp
    ring
  rw [hquarter] at hfloor
  refine ⟨?_, hfloor,
    BlockChannelCode.not_tendsto_errorProbability_zero_of_eventually_le_codeRate
      noiseless fourBudget fourBudget_pos fourCode hR hrate⟩
  filter_upwards [hquant, eventually_gt_atTop (0 : ℕ)] with n h hn
  rwa [four_bound_expression hn] at h

/-! ## Frequent unbounded spikes with no eventual positive error floor -/

private def constantOutput : Bool → PMF Bool := fun _ => PMF.pure false

private theorem constantOutput_capacity : channelCapacity constantOutput = 0 :=
  channelCapacity_const (PMF.pure false)

private def intermittentBudget (n : ℕ) : ℕ :=
  if n % 2 = 0 then 1 else 2 ^ (n * n)

private theorem intermittentBudget_pos (n : ℕ) : 1 ≤ intermittentBudget n := by
  unfold intermittentBudget
  split_ifs
  · exact le_rfl
  · exact one_le_pow₀ (by decide : 1 ≤ (2 : ℕ))

private def intermittentCode (n : ℕ) : BlockChannelCode Bool Bool n (intermittentBudget n) :=
  constantCode n (intermittentBudget n) (intermittentBudget_pos n)

private theorem intermittent_error (n : ℕ) :
    (intermittentCode n).errorProbability constantOutput (intermittentBudget_pos n) =
      1 - 1 / (intermittentBudget n : ℝ) :=
  constantCode_error n (intermittentBudget n) (intermittentBudget_pos n) constantOutput

private theorem intermittent_error_even {n : ℕ} (heven : n % 2 = 0) :
    (intermittentCode n).errorProbability constantOutput (intermittentBudget_pos n) = 0 := by
  rw [intermittent_error]
  simp [intermittentBudget, heven]

private theorem intermittent_rate_even {n : ℕ} (heven : n % 2 = 0) :
    codeRate n (intermittentBudget n) = 0 := by
  simp [intermittentBudget, heven, codeRate_one]

private theorem intermittent_rate_odd {n : ℕ} (hn : 0 < n) (hodd : n % 2 ≠ 0) :
    codeRate n (intermittentBudget n) = (n : ℝ) * Real.log 2 := by
  have hn' : (n : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hn)
  simp only [intermittentBudget, if_neg hodd, codeRate, Nat.cast_pow, Nat.cast_ofNat,
    Real.log_pow, Nat.cast_mul]
  field_simp

private theorem intermittent_unbounded_spikes (B : ℝ) (N : ℕ) :
    ∃ n ≥ N, n % 2 ≠ 0 ∧ B < codeRate n (intermittentBudget n) := by
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  obtain ⟨k, hk⟩ := exists_nat_gt (B / Real.log 2)
  let n := 2 * (k + N) + 1
  have hn : 0 < n := by dsimp [n]; omega
  have hodd : n % 2 ≠ 0 := by dsimp [n]; omega
  refine ⟨n, by dsimp [n]; omega, hodd, ?_⟩
  rw [intermittent_rate_odd hn hodd]
  have hB : B < (k : ℝ) * Real.log 2 := (div_lt_iff₀ hlog).mp hk
  have hkn : (k : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast (show k ≤ n by dsimp [n]; omega)
  exact hB.trans_le (mul_le_mul_of_nonneg_right hkn hlog.le)

private theorem intermittent_frequently_zero_error :
    ∃ᶠ n in atTop,
      (intermittentCode n).errorProbability constantOutput (intermittentBudget_pos n) = 0 := by
  apply frequently_atTop.2
  intro N
  exact ⟨2 * N, by omega, intermittent_error_even (by omega)⟩

private theorem intermittent_no_eventual_error_floor {ε : ℝ} (hε : 0 < ε) :
    ¬ (∀ᶠ n in atTop,
      ε ≤ (intermittentCode n).errorProbability constantOutput (intermittentBudget_pos n)) := by
  intro hfloor
  obtain ⟨N, hN⟩ := eventually_atTop.mp hfloor
  have h := hN (2 * N) (by omega)
  rw [intermittent_error_even (by omega : (2 * N) % 2 = 0)] at h
  exact (not_le_of_gt hε) h

private theorem intermittent_frequent_gap :
    ∃ᶠ n in atTop, channelCapacity constantOutput + Real.log 2 ≤
      codeRate n (intermittentBudget n) := by
  apply frequently_atTop.2
  intro N
  refine ⟨2 * N + 1, by omega, ?_⟩
  rw [constantOutput_capacity, zero_add, intermittent_rate_odd (by omega) (by omega)]
  have hn : (1 : ℝ) ≤ ((2 * N + 1 : ℕ) : ℝ) := by exact_mod_cast (by omega : 1 ≤ 2 * N + 1)
  simpa only [one_mul] using mul_le_mul_of_nonneg_right hn (Real.log_nonneg (by norm_num))

private theorem intermittent_public_frequent_obstruction :
    ¬ Tendsto
      (fun n => (intermittentCode n).errorProbability constantOutput (intermittentBudget_pos n))
      atTop (nhds 0) :=
  BlockChannelCode.not_tendsto_errorProbability_zero_of_frequently_channelCapacity_add_le_codeRate
    constantOutput intermittentBudget intermittentBudget_pos intermittentCode
    (Real.log_pos (by norm_num)) intermittent_frequent_gap

private theorem intermittent_no_eventual_rate_floor {R : ℝ} (hR : 0 < R) :
    ¬ (∀ᶠ n in atTop, R ≤ codeRate n (intermittentBudget n)) := by
  intro hfloor
  obtain ⟨N, hN⟩ := eventually_atTop.mp hfloor
  have h := hN (2 * N) (by omega)
  rw [intermittent_rate_even (by omega : (2 * N) % 2 = 0)] at h
  exact (not_le_of_gt hR) h

/-! ## The same actual family through the complete public interface -/

private def alternatingInput (n : ℕ) : PMF (Fin n → Bool) := by
  letI : Nonempty (Fin (alternatingBudget n)) := ⟨⟨0, alternatingBudget_pos n⟩⟩
  exact (PMF.uniformOfFintype (Fin (alternatingBudget n))).map (alternatingCode n).encoder

private def alternatingTriple (n : ℕ) :
    PMF (Fin (alternatingBudget n) × (Fin n → Bool) × (Fin n → Bool)) :=
  (alternatingCode n).messageInputOutputLaw noiseless (alternatingBudget_pos n)

private theorem alternating_complete_interface :
    (∀ n : ℕ,
      (alternatingTriple n).map (fun z => (z.1, z.2.2)) =
          (alternatingCode n).messageOutputLaw noiseless (alternatingBudget_pos n) ∧
      (alternatingTriple n).map Prod.snd =
          PMF.channelJoint (alternatingInput n) (PMF.memorylessChannel noiseless n) ∧
      (alternatingCode n).errorProbability noiseless (alternatingBudget_pos n) =
          decodingErrorProbabilityOf (alternatingTriple n) Prod.fst (fun z => z.2.2)
            (alternatingCode n).decoder ∧
      (alternatingCode n).errorProbability noiseless (alternatingBudget_pos n) =
          ((alternatingTriple n).toOuterMeasure
            {z | (alternatingCode n).decoder z.2.2 ≠ z.1}).toReal ∧
      (alternatingCode n).errorProbability noiseless (alternatingBudget_pos n) = 0 ∧
      IsMarkovChain (alternatingTriple n) ∧
      IsMarkovChainOf (alternatingTriple n) Prod.fst (fun z => z.2.2)
          (fun z => (alternatingCode n).decoder z.2.2) ∧
      mutualInfoOf (alternatingTriple n) Prod.fst
          (fun z => (alternatingCode n).decoder z.2.2) ≤
          mutualInfoOf (alternatingTriple n) Prod.fst (fun z => z.2.2) ∧
      Real.log (alternatingBudget n : ℝ) - Real.log 2 -
          (alternatingCode n).errorProbability noiseless (alternatingBudget_pos n) *
            Real.log (alternatingBudget n : ℝ) ≤
          mutualInfoOf (alternatingTriple n) Prod.fst (fun z => z.2.2) ∧
      mutualInfoOf (alternatingTriple n) Prod.fst (fun z => z.2.2) ≤
          mutualInfoOf (alternatingTriple n) (fun z => z.2.1) (fun z => z.2.2) ∧
      mutualInfoOf (alternatingTriple n) (fun z => z.2.1) (fun z => z.2.2) ≤
          (n : ℝ) * channelCapacity noiseless ∧
      (1 - (alternatingCode n).errorProbability noiseless (alternatingBudget_pos n)) *
          Real.log (alternatingBudget n : ℝ) ≤
          (n : ℝ) * channelCapacity noiseless + Real.log 2 ∧
      (0 < n →
        (1 - (alternatingCode n).errorProbability noiseless (alternatingBudget_pos n)) *
            codeRate n (alternatingBudget n) ≤
            channelCapacity noiseless + Real.log 2 / (n : ℝ) ∧
        ∀ R : ℝ, 0 < R → R ≤ codeRate n (alternatingBudget n) →
          1 - channelCapacity noiseless / R - Real.log 2 / ((n : ℝ) * R) ≤
            (alternatingCode n).errorProbability noiseless (alternatingBudget_pos n))) ∧
    (∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop,
      codeRate n (alternatingBudget n) ≤ channelCapacity noiseless + δ) ∧
    Filter.limsup (fun n => codeRate n (alternatingBudget n)) atTop ≤
      channelCapacity noiseless ∧
    Tendsto
      (fun n => (alternatingCode n).errorProbability noiseless (alternatingBudget_pos n))
      atTop (nhds 0) ∧
    (∀ l : ℝ, ¬ Tendsto (fun n => codeRate n (alternatingBudget n)) atTop (nhds l)) := by
  refine ⟨?_, ?_, ?_, alternating_error_tendsto_zero, alternating_rates_not_convergent⟩
  · intro n
    let : Nonempty (Fin (alternatingBudget n)) := ⟨⟨0, alternatingBudget_pos n⟩⟩
    refine ⟨?_, ?_, ?_, ?_, alternating_error n, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
    · exact (alternatingCode n).messageInputOutputLaw_map_messageOutput noiseless _
    · exact (alternatingCode n).messageInputOutputLaw_map_inputOutput noiseless _
    · exact (alternatingCode n).errorProbability_eq_decodingErrorProbabilityOf noiseless _
    · exact (alternatingCode n).errorProbability_eq_toOuterMeasure noiseless _
    · exact (alternatingCode n).isMarkovChain_messageInputOutputLaw noiseless _
    · exact (alternatingCode n).isMarkovChainOf_decoder noiseless _
    · exact (alternatingCode n).mutualInfoOf_decoder_le noiseless _
    · have hf := mutualInfo_fano_lower_bound_of_uniform_source
        ((alternatingCode n).messageOutputLaw noiseless (alternatingBudget_pos n))
        (alternatingCode n).decoder
        ((alternatingCode n).messageOutputLaw_map_fst noiseless (alternatingBudget_pos n))
      simp only [Fintype.card_fin] at hf
      change Real.log (alternatingBudget n : ℝ) - Real.log 2 -
        (alternatingCode n).errorProbability noiseless (alternatingBudget_pos n) *
          Real.log (alternatingBudget n : ℝ) ≤
        mutualInfo ((alternatingCode n).messageOutputLaw noiseless (alternatingBudget_pos n)) at hf
      simpa only [mutualInfoOf, alternatingTriple,
        (alternatingCode n).messageInputOutputLaw_map_messageOutput] using hf
    · exact (alternatingCode n).mutualInfoOf_message_le_input noiseless _
    · change mutualInfo ((alternatingTriple n).map Prod.snd) ≤ _
      have hio : (alternatingTriple n).map Prod.snd =
          PMF.channelJoint (alternatingInput n) (PMF.memorylessChannel noiseless n) :=
        (alternatingCode n).messageInputOutputLaw_map_inputOutput noiseless _
      rw [hio]
      exact mutualInfo_channelJoint_memorylessChannel_le noiseless n (alternatingInput n)
    · exact (alternatingCode n).one_sub_errorProbability_mul_log_le noiseless _
    · intro hn
      refine ⟨(alternatingCode n).one_sub_errorProbability_mul_codeRate_le noiseless _ hn, ?_⟩
      intro R hR hrate
      exact (alternatingCode n).one_sub_channelCapacity_div_sub_le_errorProbability
        noiseless _ hn hR hrate
  · intro δ hδ
    exact BlockChannelCode.eventually_codeRate_le_channelCapacity_add
      noiseless alternatingBudget alternatingBudget_pos alternatingCode
      alternating_error_tendsto_zero δ hδ
  · exact BlockChannelCode.limsup_codeRate_le_channelCapacity
      noiseless alternatingBudget alternatingBudget_pos alternatingCode
      alternating_error_tendsto_zero

end

end LeanInfoTheory.Examples.ChannelCodingAsymptotic
