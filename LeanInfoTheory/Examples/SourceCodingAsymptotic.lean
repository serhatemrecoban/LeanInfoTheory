/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceCodingAsymptotic

/-!
# Almost-lossless source-coding consumers

These private consumers extract one positive-budget code family from the public
above-entropy theorem and retain its actual iid error limit and eventual rate
bound together. The same witnesses give every positive upper-rate tolerance.
No rounded-budget identity, typical-word recovery or initialization property is
inferred from the public theorem's weaker existential conclusion.

A pure source on Bool and a biased sparse ternary source with masses
`(1/3, 2/3, 0)` exercise achievability without positive-entropy or full-support
assumptions. An actual one-message family under the fair binary source consumes
the public strong converse. Separate checks cover arbitrary positive budgets at
zero length and the impossible negative-rate cap when entropy is zero. All rates
and entropy values use nats.

The unrestricted general converse is consumed by two actual fair-source
families. Exact recovery with alternating full-word and larger budgets gives
vanishing error with bounded and unbounded rate branches. Alternating full-word
and one-message codes instead gives a fixed entropy gap arbitrarily far out,
without any eventual below-entropy cap, so its error cannot tend to zero.
The four-endpoint package also uses the threshold on actual achieved upper
rates. The biased sparse source admits compression strictly below log 2, by
its support-cardinality bound and the characterization of equality. Explicit
pure and singleton families have zero error and rate. A changed finite prefix
has different error and rate at length one while preserving both scalar limits
and the eventual cap by equality on the tail.
-/

namespace LeanInfoTheory.Examples.SourceCodingAsymptotic

noncomputable section

universe u

open LeanInfoTheory.Shannon

/-- One extraction supplies error convergence, the eventual cap and every
positive tolerance at that cap, all for the same budgets and codes. -/
private theorem above_entropy_same_family {A : Type u} [Fintype A]
    (p : PMF A) {R : ℝ} (hR : entropy p < R) :
    ∃ M : ℕ → ℕ, (∀ n, 1 ≤ M n) ∧
      ∃ c : ∀ n, BlockSourceCode A n (M n),
        Filter.Tendsto (fun n => (c n).errorProbability (PMF.iid p n))
          Filter.atTop (nhds 0) ∧
        (∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ R) ∧
        (∀ η : ℝ, 0 < η →
          ∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ R + η) := by
  obtain ⟨M, hM, c, herror, hrate⟩ :=
    exists_blockSourceCode_tendsto_errorProbability_zero p hR
  refine ⟨M, hM, c, herror, hrate, ?_⟩
  intro η hη
  exact hrate.mono fun _ hn => hn.trans (le_add_of_nonneg_right hη.le)

/-- The carrier has two symbols even though the law is concentrated at false. -/
private theorem pure_bool_above_entropy {R : ℝ} (hR : 0 < R) :
    ∃ M : ℕ → ℕ, (∀ n, 1 ≤ M n) ∧
      ∃ c : ∀ n, BlockSourceCode Bool n (M n),
        Filter.Tendsto (fun n => (c n).errorProbability (PMF.iid (PMF.pure false) n))
          Filter.atTop (nhds 0) ∧
        (∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ R) := by
  apply exists_blockSourceCode_tendsto_errorProbability_zero (PMF.pure false)
  simpa only [entropy_pure] using hR

private theorem third_masses_add :
    ENNReal.ofReal (1 / 3 : ℝ) + ENNReal.ofReal (2 / 3 : ℝ) = 1 := by
  rw [← ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1 / 3)
    (by norm_num : (0 : ℝ) ≤ 2 / 3)]
  norm_num

private def biasedSparse : PMF (Fin 3) :=
  PMF.ofFintype
    (fun a => if a = 0 then ENNReal.ofReal (1 / 3 : ℝ)
      else if a = 1 then ENNReal.ofReal (2 / 3 : ℝ) else 0)
    (by simpa [Fin.sum_univ_three] using third_masses_add)

private theorem biasedSparse_zero_mass : (biasedSparse 0).toReal = 1 / 3 := by
  norm_num [biasedSparse, PMF.ofFintype_apply]

private theorem biasedSparse_one_mass : (biasedSparse 1).toReal = 2 / 3 := by
  norm_num [biasedSparse, PMF.ofFintype_apply]

private theorem biasedSparse_two_mass : biasedSparse 2 = 0 := by
  change (if (2 : Fin 3) = 0 then ENNReal.ofReal (1 / 3 : ℝ)
    else if (2 : Fin 3) = 1 then ENNReal.ofReal (2 / 3 : ℝ) else 0) = 0
  rw [if_neg (by decide : (2 : Fin 3) ≠ 0),
    if_neg (by decide : (2 : Fin 3) ≠ 1)]

private theorem biasedSparse_support (a : Fin 3) :
    a ∈ biasedSparse.support ↔ a ≠ 2 := by
  have hzero : biasedSparse 0 ≠ 0 := by
    intro h
    have hmass := biasedSparse_zero_mass
    rw [h] at hmass
    norm_num at hmass
  have hone : biasedSparse 1 ≠ 0 := by
    intro h
    have hmass := biasedSparse_one_mass
    rw [h] at hmass
    norm_num at hmass
  rw [PMF.mem_support_iff]
  fin_cases a
  · exact iff_of_true hzero (by decide)
  · exact iff_of_true hone (by decide)
  · change biasedSparse 2 ≠ 0 ↔ (2 : Fin 3) ≠ 2
    rw [biasedSparse_two_mass]
    constructor <;> intro h <;> exact False.elim (h rfl)

/-- The source has an impossible alphabet symbol, but the public theorem
still produces one actual family above its entropy without a support premise. -/
private theorem biasedSparse_above_entropy :
    ∃ M : ℕ → ℕ, (∀ n, 1 ≤ M n) ∧
      ∃ c : ∀ n, BlockSourceCode (Fin 3) n (M n),
        Filter.Tendsto (fun n => (c n).errorProbability (PMF.iid biasedSparse n))
          Filter.atTop (nhds 0) ∧
        (∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ entropy biasedSparse + 1) := by
  apply exists_blockSourceCode_tendsto_errorProbability_zero biasedSparse
  linarith

private def fair : PMF Bool := PMF.uniformOfFintype Bool

private theorem fair_entropy : entropy fair = Real.log 2 := by
  simpa only [fair, Fintype.card_bool, Nat.cast_ofNat] using
    (entropy_uniformOfFintype (alpha := Bool))

/-- Every word is encoded by the unique message; its total decoder returns
the all-false word, including the unique empty word at length zero. -/
private def oneMessageCode (n : ℕ) : BlockSourceCode Bool n 1 :=
  (fun _ => 0, fun _ => fun _ => false)

/-- An actual one-message family for a positive-entropy source has error
tending to one by the public strong converse at the zero rate cap. -/
private theorem fair_oneMessage_error_tendsto_one :
    Filter.Tendsto
      (fun n => (oneMessageCode n).errorProbability (PMF.iid fair n))
      Filter.atTop (nhds 1) := by
  apply tendsto_errorProbability_iid_one_of_eventually_codeRate_le
    fair (fun _ => 1) (fun _ => by decide) oneMessageCode (R := 0)
  · rw [fair_entropy]
    exact Real.log_pos (by norm_num)
  · exact Filter.Eventually.of_forall fun n => (codeRate_one n).le

/-- Every total zero-length code recovers its unique possible word, regardless
of its positive message budget or source law. Its error and totalized rate
are zero, without cancellation or normalization at zero length. -/
private theorem arbitrary_zero_length_code {A : Type u} {M : ℕ}
    (_hM : 1 ≤ M) (q : PMF (Fin 0 → A)) (c : BlockSourceCode A 0 M) :
    (∀ w, c.decoder (c.encoder w) = w) ∧
      c.errorProbability q = 0 ∧ codeRate 0 M = 0 := by
  have hrecovers (w : Fin 0 → A) : c.decoder (c.encoder w) = w := by
    funext i
    exact Fin.elim0 i
  refine ⟨hrecovers, ?_, codeRate_zero M⟩
  rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure]
  have hfail : {w : Fin 0 → A | c.decoder (c.encoder w) ≠ id w} = ∅ := by
    ext w
    simp only [Set.mem_ofPred_eq, Set.mem_empty_iff_false, iff_false, not_not, id_eq]
    exact hrecovers w
  rw [hfail]
  simp

/-- Positive message budgets rule out even an eventual negative rate cap. -/
private theorem negative_rate_cap_impossible (M : ℕ → ℕ)
    (hM : ∀ n, 1 ≤ M n) {R : ℝ} (hR : R < 0) :
    ¬ (∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ R) := by
  intro hcap
  obtain ⟨n, hn⟩ := hcap.exists
  have hnonneg := codeRate_nonneg n (M n) (hM n)
  linarith

/-- For an entropy-zero source and any actual positive-budget code family,
the below-entropy eventual-cap antecedent is impossible. This is a boundary
check on the strong converse's hypotheses, not an application of its limit. -/
private theorem zero_entropy_strong_converse_antecedent_impossible
    {A : Type u} [Fintype A] (p : PMF A) (hH : entropy p = 0)
    (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n) (_c : ∀ n, BlockSourceCode A n (M n))
    {R : ℝ} (hR : R < entropy p) :
    ¬ (∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ R) := by
  apply negative_rate_cap_impossible M hM
  simpa only [hH] using hR

/-- The public finite selected-set constructor supplies exact recovery of every
binary word whenever the number of binary message digits is at least n. -/
private theorem fullWordCode_exists (n k : ℕ) (hnk : n ≤ k) :
    ∃ c : BlockSourceCode Bool n (2 ^ k),
      (∀ w, c.decoder (c.encoder w) = w) ∧
        c.errorProbability (PMF.iid fair n) = 0 := by
  have hcard : (Finset.univ : Finset (Fin n → Bool)).card ≤ 2 ^ k := by
    simpa only [Finset.card_univ, Fintype.card_fun, Fintype.card_bool,
      Fintype.card_fin] using
      (pow_le_pow_right₀ (by decide : 1 ≤ (2 : ℕ)) hnk)
  obtain ⟨c, hcorrect, herror⟩ := exists_sourceCode_errorProbability_le
    (PMF.iid fair n) Finset.univ hcard (one_le_pow₀ (by decide : 1 ≤ (2 : ℕ)))
  refine ⟨c, fun w => hcorrect w (Finset.mem_univ w), le_antisymm ?_
    (decodingErrorProbabilityOf_nonneg _ _ _ _)⟩
  simpa using herror

private def fullWordCode (n k : ℕ) (hnk : n ≤ k) : BlockSourceCode Bool n (2 ^ k) :=
  Classical.choose (fullWordCode_exists n k hnk)

private theorem fullWordCode_spec (n k : ℕ) (hnk : n ≤ k) :
    (∀ w, (fullWordCode n k hnk).decoder ((fullWordCode n k hnk).encoder w) = w) ∧
      (fullWordCode n k hnk).errorProbability (PMF.iid fair n) = 0 :=
  Classical.choose_spec (fullWordCode_exists n k hnk)

private theorem binary_multiple_rate {n : ℕ} (hn : 0 < n) (k : ℕ) :
    codeRate n (2 ^ (n * k)) = (k : ℝ) * Real.log 2 := by
  have hn' : (n : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hn)
  simp only [codeRate, Nat.cast_pow, Nat.cast_ofNat, Real.log_pow, Nat.cast_mul]
  field_simp

private theorem full_word_rate {n : ℕ} (hn : 0 < n) :
    codeRate n (2 ^ n) = Real.log 2 := by
  simpa only [Nat.mul_one, Nat.cast_one, one_mul] using binary_multiple_rate hn 1

private def oscillatingDigits (n : ℕ) : ℕ :=
  if n % 2 = 0 then n else n * (n + 1)

private theorem oscillatingDigits_ge (n : ℕ) : n ≤ oscillatingDigits n := by
  unfold oscillatingDigits
  split_ifs <;> nlinarith

private def oscillatingBudget (n : ℕ) : ℕ := 2 ^ oscillatingDigits n

private theorem oscillatingBudget_pos (n : ℕ) : 1 ≤ oscillatingBudget n :=
  one_le_pow₀ (by decide : 1 ≤ (2 : ℕ))

private def oscillatingCode (n : ℕ) : BlockSourceCode Bool n (oscillatingBudget n) :=
  fullWordCode n (oscillatingDigits n) (oscillatingDigits_ge n)

private theorem oscillatingCode_exact (n : ℕ) :
    (∀ w, (oscillatingCode n).decoder ((oscillatingCode n).encoder w) = w) ∧
      (oscillatingCode n).errorProbability (PMF.iid fair n) = 0 :=
  fullWordCode_spec n (oscillatingDigits n) (oscillatingDigits_ge n)

private theorem oscillating_rate_even {n : ℕ} (hn : 0 < n) (heven : n % 2 = 0) :
    oscillatingBudget n = 2 ^ n ∧ codeRate n (oscillatingBudget n) = Real.log 2 := by
  have hbudget : oscillatingBudget n = 2 ^ n := by
    simp only [oscillatingBudget, oscillatingDigits, if_pos heven]
  exact ⟨hbudget, by rw [hbudget]; exact full_word_rate hn⟩

private theorem oscillating_rate_odd {n : ℕ} (hn : 0 < n) (hodd : n % 2 ≠ 0) :
    oscillatingBudget n = 2 ^ (n * (n + 1)) ∧
      codeRate n (oscillatingBudget n) = ((n + 1 : ℕ) : ℝ) * Real.log 2 := by
  have hbudget : oscillatingBudget n = 2 ^ (n * (n + 1)) := by
    simp only [oscillatingBudget, oscillatingDigits, if_neg hodd]
  exact ⟨hbudget, by rw [hbudget]; exact binary_multiple_rate hn (n + 1)⟩

/-- The bounded full-word branch persists arbitrarily far out. -/
private theorem oscillating_bounded_branch (N : ℕ) :
    ∃ n ≥ N, n % 2 = 0 ∧
      oscillatingBudget n = 2 ^ n ∧ codeRate n (oscillatingBudget n) = Real.log 2 := by
  refine ⟨2 * (N + 1), by omega, by omega, ?_⟩
  exact oscillating_rate_even (by omega) (by omega)

/-- On the other branch, actual positive budgets give rates exceeding any
fixed real bound arbitrarily far out. -/
private theorem oscillating_unbounded_branch (B : ℝ) (N : ℕ) :
    ∃ n ≥ N, n % 2 ≠ 0 ∧ B < codeRate n (oscillatingBudget n) := by
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  obtain ⟨k, hk⟩ := exists_nat_gt (B / Real.log 2)
  let n := 2 * (k + N) + 1
  have hn : 0 < n := by dsimp [n]; omega
  have hodd : n % 2 ≠ 0 := by dsimp [n]; omega
  refine ⟨n, by dsimp [n]; omega, hodd, ?_⟩
  rw [(oscillating_rate_odd hn hodd).2]
  have hB : B < (k : ℝ) * Real.log 2 := (div_lt_iff₀ hlog).mp hk
  have hkn : (k : ℝ) ≤ ((n + 1 : ℕ) : ℝ) := by
    exact_mod_cast (show k ≤ n + 1 by dsimp [n]; omega)
  exact hB.trans_le (mul_le_mul_of_nonneg_right hkn hlog.le)

private theorem oscillating_error_tendsto_zero :
    Filter.Tendsto (fun n => (oscillatingCode n).errorProbability (PMF.iid fair n))
      Filter.atTop (nhds 0) := by
  have heq : (fun n => (oscillatingCode n).errorProbability (PMF.iid fair n)) =
      (fun _ : ℕ => (0 : ℝ)) := funext fun n => (oscillatingCode_exact n).2
  rw [heq]
  exact tendsto_const_nhds

/-- The public general converse applies to this positive-entropy, exact-recovery
family even though its rates are unbounded and retain a bounded branch. -/
private theorem oscillating_general_converse {δ : ℝ} (hδ : 0 < δ) :
    ∀ᶠ n in Filter.atTop, entropy fair - δ ≤ codeRate n (oscillatingBudget n) :=
  eventually_entropy_sub_le_codeRate_of_tendsto_errorProbability_zero
    fair oscillatingBudget oscillatingBudget_pos oscillatingCode
    oscillating_error_tendsto_zero hδ

private def intermittentBlock (n : ℕ) : Σ M : ℕ, BlockSourceCode Bool n M :=
  if n % 2 = 0 then ⟨2 ^ n, fullWordCode n n le_rfl⟩ else ⟨1, oneMessageCode n⟩

private def intermittentBudget (n : ℕ) : ℕ := (intermittentBlock n).1

private theorem intermittentBudget_pos (n : ℕ) : 1 ≤ intermittentBudget n := by
  unfold intermittentBudget intermittentBlock
  split_ifs
  · exact one_le_pow₀ (by decide : 1 ≤ (2 : ℕ))
  · exact le_rfl

private def intermittentCode (n : ℕ) : BlockSourceCode Bool n (intermittentBudget n) :=
  (intermittentBlock n).2

/-- Both branches are actual total codes: the even branch recovers all words,
while the odd branch is the one-message constant-decoder code. -/
private theorem intermittentCode_branches (n : ℕ) :
    (n % 2 = 0 → intermittentBudget n = 2 ^ n ∧
      ∀ w, (intermittentCode n).decoder ((intermittentCode n).encoder w) = w) ∧
    (n % 2 ≠ 0 → intermittentBudget n = 1 ∧
      ∀ w, (intermittentCode n).decoder ((intermittentCode n).encoder w) =
        (fun _ => false)) := by
  constructor
  · intro heven
    refine ⟨by simp only [intermittentBudget, intermittentBlock, if_pos heven], ?_⟩
    exact (congrArg (fun b : Σ M : ℕ, BlockSourceCode Bool n M =>
      ∀ w, b.2.decoder (b.2.encoder w) = w)
      (show intermittentBlock n = ⟨2 ^ n, fullWordCode n n le_rfl⟩ from
        if_pos heven)).mpr (fullWordCode_spec n n le_rfl).1
  · intro hodd
    refine ⟨by simp only [intermittentBudget, intermittentBlock, if_neg hodd], ?_⟩
    exact (congrArg (fun b : Σ M : ℕ, BlockSourceCode Bool n M =>
      ∀ w, b.2.decoder (b.2.encoder w) = (fun _ => false))
      (show intermittentBlock n = ⟨1, oneMessageCode n⟩ from
        if_neg hodd)).mpr (by intro w; rfl)

private theorem intermittent_rate_even {n : ℕ} (hn : 0 < n) (heven : n % 2 = 0) :
    codeRate n (intermittentBudget n) = entropy fair := by
  rw [((intermittentCode_branches n).1 heven).1, full_word_rate hn, fair_entropy]

private theorem intermittent_rate_odd {n : ℕ} (hodd : n % 2 ≠ 0) :
    codeRate n (intermittentBudget n) = 0 := by
  rw [((intermittentCode_branches n).2 hodd).1, codeRate_one]

/-- A single positive gap below entropy occurs arbitrarily late. -/
private theorem intermittent_bad_indices :
    0 < entropy fair / 2 ∧
      ∀ N : ℕ, ∃ n ≥ N,
        codeRate n (intermittentBudget n) < entropy fair - entropy fair / 2 := by
  have hH : 0 < entropy fair := by
    rw [fair_entropy]
    exact Real.log_pos (by norm_num)
  refine ⟨half_pos hH, ?_⟩
  intro N
  refine ⟨2 * N + 1, by omega, ?_⟩
  rw [intermittent_rate_odd (by omega : (2 * N + 1) % 2 ≠ 0)]
  linarith

/-- The full-word branch prevents every eventual cap strictly below entropy,
so the strong converse's eventual-cap hypothesis is unavailable. -/
private theorem intermittent_no_eventual_cap {R : ℝ} (hR : R < entropy fair) :
    ¬ (∀ᶠ n in Filter.atTop, codeRate n (intermittentBudget n) ≤ R) := by
  intro hcap
  obtain ⟨N, hN⟩ := Filter.eventually_atTop.mp hcap
  have h := hN (2 * (N + 1)) (by omega)
  rw [intermittent_rate_even (by omega : 0 < 2 * (N + 1)) (by omega)] at h
  exact (not_le_of_gt hR) h

/-- The public general converse excludes vanishing error by inspecting its
lower-rate conclusion at an arbitrarily late low-rate branch. -/
private theorem intermittent_error_not_tendsto_zero :
    ¬ Filter.Tendsto (fun n => (intermittentCode n).errorProbability (PMF.iid fair n))
      Filter.atTop (nhds 0) := by
  intro herror
  have hlower := eventually_entropy_sub_le_codeRate_of_tendsto_errorProbability_zero
    fair intermittentBudget intermittentBudget_pos intermittentCode herror
    intermittent_bad_indices.1
  obtain ⟨N, hN⟩ := Filter.eventually_atTop.mp hlower
  obtain ⟨n, hn, hbad⟩ := intermittent_bad_indices.2 N
  exact (not_lt_of_ge (hN n hn)) hbad

/-- The four public endpoints form one operational package for the same source.
The threshold is also applied to actual almost-lossless witnesses, and the
above-entropy witness retains every upper-rate tolerance for that same family. -/
private theorem source_coding_package {A : Type u} [Fintype A] (p : PMF A) :
    IsGLB {R : ℝ | ∃ M : ℕ → ℕ, (∀ n, 1 ≤ M n) ∧
      ∃ c : ∀ n, BlockSourceCode A n (M n),
        Filter.Tendsto (fun n => (c n).errorProbability (PMF.iid p n))
          Filter.atTop (nhds 0) ∧
        (∀ η : ℝ, 0 < η → ∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ R + η)}
      (entropy p) ∧
    (∀ (R : ℝ) (M : ℕ → ℕ) (_hM : ∀ n, 1 ≤ M n)
      (c : ∀ n, BlockSourceCode A n (M n)),
      Filter.Tendsto (fun n => (c n).errorProbability (PMF.iid p n))
        Filter.atTop (nhds 0) →
      (∀ η : ℝ, 0 < η → ∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ R + η) →
      entropy p ≤ R) ∧
    (∀ δ : ℝ, 0 < δ → ∃ M : ℕ → ℕ, (∀ n, 1 ≤ M n) ∧
      ∃ c : ∀ n, BlockSourceCode A n (M n),
        Filter.Tendsto (fun n => (c n).errorProbability (PMF.iid p n))
          Filter.atTop (nhds 0) ∧
        (∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ entropy p + δ) ∧
        (∀ η : ℝ, 0 < η →
          ∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ entropy p + δ + η)) ∧
    (∀ (M : ℕ → ℕ) (_hM : ∀ n, 1 ≤ M n)
      (c : ∀ n, BlockSourceCode A n (M n)) (R : ℝ),
      R < entropy p → (∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ R) →
      Filter.Tendsto (fun n => (c n).errorProbability (PMF.iid p n))
        Filter.atTop (nhds 1)) ∧
    (∀ (M : ℕ → ℕ) (_hM : ∀ n, 1 ≤ M n)
      (c : ∀ n, BlockSourceCode A n (M n)),
      Filter.Tendsto (fun n => (c n).errorProbability (PMF.iid p n))
        Filter.atTop (nhds 0) →
      ∀ δ : ℝ, 0 < δ → ∀ᶠ n in Filter.atTop, entropy p - δ ≤ codeRate n (M n)) := by
  refine ⟨sourceCoding_threshold p, ?_, ?_, ?_, ?_⟩
  · intro R M hM c herror hupper
    exact (sourceCoding_threshold p).1 ⟨M, hM, c, herror, hupper⟩
  · intro δ hδ
    have habove : entropy p < entropy p + δ := by linarith
    obtain ⟨M, hM, c, herror, hrate⟩ :=
      exists_blockSourceCode_tendsto_errorProbability_zero p habove
    exact ⟨M, hM, c, herror, hrate, fun η hη =>
      hrate.mono fun _ hn => hn.trans (le_add_of_nonneg_right hη.le)⟩
  · intro M hM c R hR hrate
    exact tendsto_errorProbability_iid_one_of_eventually_codeRate_le p M hM c hR hrate
  · intro M hM c herror δ hδ
    exact eventually_entropy_sub_le_codeRate_of_tendsto_errorProbability_zero
      p M hM c herror hδ

private theorem biasedSparse_supportFinset :
    biasedSparse.supportFinset = ({0, 1} : Finset (Fin 3)) := by
  classical
  ext a
  rw [PMF.mem_supportFinset, biasedSparse_support]
  fin_cases a <;> decide

private theorem biasedSparse_support_ncard : biasedSparse.support.ncard = 2 := by
  rw [← PMF.supportFinset_card, biasedSparse_supportFinset]
  decide

private theorem biasedSparse_entropy_pos : 0 < entropy biasedSparse := by
  by_contra h
  have hzero : entropy biasedSparse = 0 :=
    le_antisymm (le_of_not_gt h) (entropy_nonneg biasedSparse)
  obtain ⟨a, ha⟩ := (entropy_eq_zero_iff biasedSparse).mp hzero
  have hcard := biasedSparse_support_ncard
  rw [ha, PMF.support_pure, Set.ncard_singleton] at hcard
  norm_num at hcard

private theorem biasedSparse_entropy_lt_log_two : entropy biasedSparse < Real.log 2 := by
  classical
  have hle : entropy biasedSparse ≤ Real.log 2 := by
    simpa only [biasedSparse_support_ncard, Nat.cast_ofNat] using
      entropy_le_log_support_ncard biasedSparse
  by_contra h
  have heq : entropy biasedSparse = Real.log 2 :=
    le_antisymm hle (le_of_not_gt h)
  have heq_support : entropy biasedSparse = Real.log (biasedSparse.support.ncard : ℝ) := by
    simpa only [biasedSparse_support_ncard, Nat.cast_ofNat] using heq
  have hu :=
    (entropy_eq_log_support_ncard_iff_eq_uniformOnSupport biasedSparse).mp heq_support
  have hzero_mem : (0 : Fin 3) ∈ biasedSparse.supportFinset := by
    rw [PMF.mem_supportFinset, biasedSparse_support]
    decide
  have hcard : biasedSparse.supportFinset.card = 2 := by
    rw [biasedSparse_supportFinset]
    decide
  have hmass : (biasedSparse 0).toReal =
      (PMF.uniformOfFinset biasedSparse.supportFinset
        biasedSparse.supportFinset_nonempty 0).toReal :=
    congrArg (fun q : PMF (Fin 3) => (q 0).toReal) hu
  rw [biasedSparse_zero_mass,
    PMF.uniformOfFinset_apply_of_mem biasedSparse.supportFinset_nonempty hzero_mem,
    hcard] at hmass
  norm_num [ENNReal.toReal_inv] at hmass

/-- An impossible length-one word is outside the supported strict typical set
for every width, independently of the chosen compression rate. -/
private theorem biasedSparse_impossible_not_typical (ε : ℝ) :
    (fun _ : Fin 1 => (2 : Fin 3)) ∉ weakTypicalSet biasedSparse 1 ε := by
  intro htypical
  have hs := ((mem_weakTypicalSet biasedSparse).mp htypical).2.1
  have hcoord :=
    (PMF.mem_support_finiteProduct_iff (fun _ : Fin 1 => biasedSparse) _).mp hs 0
  exact ((biasedSparse_support 2).mp hcoord) rfl

/-- The package supplies one actual family with an eventual rate strictly below
the logarithm of support size. The threshold and general converse apply to
those same witnesses, alongside the package's below-entropy strong converse. -/
private theorem biasedSparse_operational_compression :
    ∃ R : ℝ, 0 < entropy biasedSparse ∧ entropy biasedSparse < R ∧ R < Real.log 2 ∧
      ∃ M : ℕ → ℕ, ∃ _hM : ∀ n, 1 ≤ M n,
        ∃ c : ∀ n, BlockSourceCode (Fin 3) n (M n),
          Filter.Tendsto (fun n => (c n).errorProbability (PMF.iid biasedSparse n))
            Filter.atTop (nhds 0) ∧
          (∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ R) ∧
          (∀ η : ℝ, 0 < η → ∀ᶠ n in Filter.atTop, codeRate n (M n) ≤ R + η) ∧
          entropy biasedSparse ≤ R ∧
          (∀ δ : ℝ, 0 < δ →
            ∀ᶠ n in Filter.atTop, entropy biasedSparse - δ ≤ codeRate n (M n)) ∧
          (∀ (M' : ℕ → ℕ) (_hM' : ∀ n, 1 ≤ M' n)
            (c' : ∀ n, BlockSourceCode (Fin 3) n (M' n)) (R' : ℝ),
            R' < entropy biasedSparse →
            (∀ᶠ n in Filter.atTop, codeRate n (M' n) ≤ R') →
            Filter.Tendsto (fun n => (c' n).errorProbability (PMF.iid biasedSparse n))
              Filter.atTop (nhds 1)) := by
  obtain ⟨_, hbound, hachievable, hstrong, hgeneral⟩ := source_coding_package biasedSparse
  let R := (entropy biasedSparse + Real.log 2) / 2
  have hHR : entropy biasedSparse < R := by
    dsimp [R]
    linarith [biasedSparse_entropy_lt_log_two]
  have hRlog : R < Real.log 2 := by
    dsimp [R]
    linarith [biasedSparse_entropy_lt_log_two]
  obtain ⟨M, hM, c, herror, hrate, hupper⟩ :=
    hachievable (R - entropy biasedSparse) (sub_pos.mpr hHR)
  have hsum : entropy biasedSparse + (R - entropy biasedSparse) = R := by ring
  rw [hsum] at hrate hupper
  exact ⟨R, biasedSparse_entropy_pos, hHR, hRlog, M, hM, c, herror, hrate, hupper,
    hbound R M hM c herror hupper, hgeneral M hM c herror, hstrong⟩

/-- The existing explicit one-message family is lossless for a pure source on
the nontrivial Bool carrier at every length, without full support. -/
private theorem pure_oneMessage_exact (n : ℕ) :
    (oneMessageCode n).errorProbability (PMF.iid (PMF.pure false) n) = 0 ∧
      codeRate n 1 = 0 := by
  refine ⟨?_, codeRate_one n⟩
  rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure]
  have hq : PMF.iid (PMF.pure false) n = PMF.pure (fun _ : Fin n => false) :=
    PMF.finiteProduct_pure (fun _ : Fin n => false)
  rw [hq, PMF.toOuterMeasure_pure_apply]
  simp [oneMessageCode, SourceCode.decoder, SourceCode.encoder]

private theorem pure_oneMessage_limits :
    Filter.Tendsto
      (fun n => (oneMessageCode n).errorProbability (PMF.iid (PMF.pure false) n))
      Filter.atTop (nhds 0) ∧
    Filter.Tendsto (fun n => codeRate n 1) Filter.atTop (nhds 0) ∧
    (∀ δ : ℝ, 0 < δ →
      ∀ᶠ n in Filter.atTop, entropy (PMF.pure false) - δ ≤ codeRate n 1) := by
  have herror : Filter.Tendsto
      (fun n => (oneMessageCode n).errorProbability (PMF.iid (PMF.pure false) n))
      Filter.atTop (nhds 0) := by
    have heq := funext fun n => (pure_oneMessage_exact n).1
    rw [heq]
    exact tendsto_const_nhds
  have hrate : Filter.Tendsto (fun n => codeRate n 1) Filter.atTop (nhds 0) := by
    have heq := funext fun n => codeRate_one n
    rw [heq]
    exact tendsto_const_nhds
  refine ⟨herror, hrate, ?_⟩
  intro δ hδ
  exact eventually_entropy_sub_le_codeRate_of_tendsto_errorProbability_zero
    (PMF.pure false) (fun _ => 1) (fun _ => by decide) oneMessageCode herror hδ

private def singletonOneMessageCode (n : ℕ) : BlockSourceCode Unit n 1 :=
  (fun _ => 0, fun _ => fun _ => ())

/-- An explicit singleton family recovers every word, for every base law on
Unit, with zero error and rate at every length. -/
private theorem singleton_oneMessage_exact (p : PMF Unit) (n : ℕ) :
    (∀ w, (singletonOneMessageCode n).decoder ((singletonOneMessageCode n).encoder w) = w) ∧
      (singletonOneMessageCode n).errorProbability (PMF.iid p n) = 0 ∧ codeRate n 1 = 0 := by
  have hcorrect (w : Fin n → Unit) :
      (singletonOneMessageCode n).decoder ((singletonOneMessageCode n).encoder w) = w :=
    Subsingleton.elim _ _
  refine ⟨hcorrect, ?_, codeRate_one n⟩
  rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure]
  have hfail : {w : Fin n → Unit |
      (singletonOneMessageCode n).decoder ((singletonOneMessageCode n).encoder w) ≠ id w} = ∅ := by
    ext w
    simp only [Set.mem_ofPred_eq, Set.mem_empty_iff_false, iff_false, not_not, id_eq]
    exact hcorrect w
  rw [hfail]
  simp

private def prefixChangedCode (n : ℕ) : BlockSourceCode Bool n 2 :=
  (fun _ => 0, fun _ => fun _ => true)

private def prefixBlock (n : ℕ) : Σ M : ℕ, BlockSourceCode Bool n M :=
  if n < 2 then ⟨2, prefixChangedCode n⟩ else ⟨1, oneMessageCode n⟩

private def prefixBudget (n : ℕ) : ℕ := (prefixBlock n).1

private def prefixCode (n : ℕ) : BlockSourceCode Bool n (prefixBudget n) :=
  (prefixBlock n).2

private theorem prefixBudget_pos (n : ℕ) : 1 ≤ prefixBudget n := by
  unfold prefixBudget prefixBlock
  split_ifs
  · exact (by decide : 1 ≤ (2 : ℕ))
  · exact le_rfl

/-- The modified prefix includes a positive blocklength: at length one its
budget, recovered word, actual error and rate differ from the pure-source code. -/
private theorem prefix_changed_at_one :
    prefixBudget 1 = 2 ∧ prefixBudget 1 ≠ 1 ∧
      (prefixCode 1).decoder ((prefixCode 1).encoder (fun _ => false)) = (fun _ => true) ∧
      (prefixCode 1).errorProbability (PMF.iid (PMF.pure false) 1) = 1 ∧
      codeRate 1 (prefixBudget 1) = Real.log 2 ∧ 0 < codeRate 1 (prefixBudget 1) := by
  have hb : prefixBlock 1 = ⟨2, prefixChangedCode 1⟩ := if_pos (by decide)
  have hbudget : prefixBudget 1 = 2 := congrArg Sigma.fst hb
  have hword :
      (prefixCode 1).decoder ((prefixCode 1).encoder (fun _ => false)) = (fun _ => true) :=
    congrArg (fun b : Σ M : ℕ, BlockSourceCode Bool 1 M =>
      b.2.decoder (b.2.encoder (fun _ => false))) hb
  have herror : (prefixChangedCode 1).errorProbability (PMF.iid (PMF.pure false) 1) = 1 := by
    rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure]
    have hq : PMF.iid (PMF.pure false) 1 = PMF.pure (fun _ : Fin 1 => false) :=
      PMF.finiteProduct_pure (fun _ : Fin 1 => false)
    rw [hq, PMF.toOuterMeasure_pure_apply]
    have hfail : (fun _ : Fin 1 => false) ∈
        {w | (prefixChangedCode 1).decoder ((prefixChangedCode 1).encoder w) ≠ id w} := by
      change (fun _ : Fin 1 => true) ≠ (fun _ => false)
      intro h
      have hvalue := congrFun h 0
      cases hvalue
    rw [if_pos hfail]
    simp
  have herror' : (prefixCode 1).errorProbability (PMF.iid (PMF.pure false) 1) = 1 :=
    (congrArg (fun b : Σ M : ℕ, BlockSourceCode Bool 1 M =>
      b.2.errorProbability (PMF.iid (PMF.pure false) 1)) hb).trans herror
  have hrate : codeRate 1 (prefixBudget 1) = Real.log 2 := by
    rw [hbudget]
    simp [codeRate]
  exact ⟨hbudget, by rw [hbudget]; decide, hword, herror', hrate,
    hrate.symm ▸ Real.log_pos (by norm_num : (1 : ℝ) < 2)⟩

/-- The different zero-length budget is valid and still gives exact empty-word
recovery, zero error and the totalized zero rate. -/
private theorem prefix_zero_boundary :
    prefixBudget 0 = 2 ∧
      (prefixCode 0).errorProbability (PMF.iid (PMF.pure false) 0) = 0 ∧
      codeRate 0 (prefixBudget 0) = 0 := by
  refine ⟨?_, (arbitrary_zero_length_code (prefixBudget_pos 0)
    (PMF.iid (PMF.pure false) 0) (prefixCode 0)).2⟩
  simp [prefixBudget, prefixBlock]

private theorem prefix_tail_scalars {n : ℕ} (hn : 2 ≤ n) :
    (prefixCode n).errorProbability (PMF.iid (PMF.pure false) n) =
      (oneMessageCode n).errorProbability (PMF.iid (PMF.pure false) n) ∧
    codeRate n (prefixBudget n) = codeRate n 1 := by
  have hb : prefixBlock n = ⟨1, oneMessageCode n⟩ := if_neg (by omega)
  exact ⟨congrArg (fun b : Σ M : ℕ, BlockSourceCode Bool n M =>
      b.2.errorProbability (PMF.iid (PMF.pure false) n)) hb,
    congrArg (fun b : Σ M : ℕ, BlockSourceCode Bool n M => codeRate n b.1) hb⟩

/-- Only real error and rate sequences are compared across different dependent
code budgets. Their equality holds after the actual modified finite prefix. -/
private theorem prefix_scalar_eventual_equal :
    ((fun n => (oneMessageCode n).errorProbability (PMF.iid (PMF.pure false) n))
      =ᶠ[Filter.atTop]
      (fun n => (prefixCode n).errorProbability (PMF.iid (PMF.pure false) n))) ∧
    ((fun n => codeRate n 1) =ᶠ[Filter.atTop] (fun n => codeRate n (prefixBudget n))) := by
  constructor
  · filter_upwards [Filter.eventually_ge_atTop (2 : ℕ)] with n hn
    exact (prefix_tail_scalars hn).1.symm
  · filter_upwards [Filter.eventually_ge_atTop (2 : ℕ)] with n hn
    exact (prefix_tail_scalars hn).2.symm

/-- A genuinely changed finite prefix preserves both scalar limits and the
zero eventual rate cap; every positive upper tolerance follows on that tail. -/
private theorem prefix_preserves_limits_and_cap :
    Filter.Tendsto
      (fun n => (prefixCode n).errorProbability (PMF.iid (PMF.pure false) n))
      Filter.atTop (nhds 0) ∧
    Filter.Tendsto (fun n => codeRate n (prefixBudget n)) Filter.atTop (nhds 0) ∧
    (∀ᶠ n in Filter.atTop, codeRate n (prefixBudget n) ≤ 0) ∧
    (∀ η : ℝ, 0 < η → ∀ᶠ n in Filter.atTop, codeRate n (prefixBudget n) ≤ η) := by
  have herror := Filter.Tendsto.congr' prefix_scalar_eventual_equal.1 pure_oneMessage_limits.1
  have hrate := Filter.Tendsto.congr' prefix_scalar_eventual_equal.2 pure_oneMessage_limits.2.1
  have hcap : ∀ᶠ n in Filter.atTop, codeRate n (prefixBudget n) ≤ 0 :=
    prefix_scalar_eventual_equal.2.symm.trans_le
      (Filter.Eventually.of_forall fun n => (codeRate_one n).le)
  exact ⟨herror, hrate, hcap, fun η hη => hcap.mono fun _ hn => hn.trans hη.le⟩

end

end LeanInfoTheory.Examples.SourceCodingAsymptotic
