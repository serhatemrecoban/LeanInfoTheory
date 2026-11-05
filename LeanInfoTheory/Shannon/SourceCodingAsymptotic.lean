/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceCoding
import LeanInfoTheory.Shannon.CodingRate
import LeanInfoTheory.Shannon.SemanticBridge.AEP

/-!
# Finite-iid source-coding asymptotics

Every rate strictly above entropy admits one sequence of total deterministic
block codes whose error tends to zero and whose rate is eventually at most the
requested rate. Rates are in nats. An intermediate rate leaves room for the
integer ceiling overhead. The same selected codes retain typical-word recovery
and the complement error bound at every length, including length zero.

The finite coding and rate producers remain independent of AEP. This owner
combines their public interfaces with the supported strict typical sets and
their probability limit. Below entropy, an eventual rate cap forces the actual
error of every positive-budget family to tend to one. Conversely, vanishing
error forces rates eventually above every fixed level strictly below entropy,
even when rates oscillate or are unbounded. The shared pointwise success
estimate excludes isolated low-rate lengths; the analytic, construction and
pointwise checkpoints stay private.

The operational threshold packages these conclusions as a greatest-lower-bound
statement for achieved asymptotic upper rates. Its tolerance quantifiers retain
one actual code family, without asserting equality-rate attainment.
-/

namespace LeanInfoTheory.Shannon

noncomputable section

universe u

open Filter Topology

private theorem tendsto_typical_complement_probability {A : Type u} [Fintype A]
    (p : PMF A) {ε : ℝ} (hε : 0 < ε) :
    Tendsto (fun n : ℕ => ((PMF.iid p n).toOuterMeasure
      (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal) atTop (nhds 0) := by
  have hlimit := Filter.Tendsto.sub (tendsto_const_nhds (x := (1 : ℝ)))
    (tendsto_prob_weakTypicalSet p hε)
  have heq : (fun n : ℕ =>
      1 - ((PMF.iid p n).toOuterMeasure (weakTypicalSet p n ε)).toReal)
      =ᶠ[atTop] (fun n : ℕ => ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal) := by
    apply Eventually.of_forall
    intro n
    let : MeasurableSpace (Fin n → A) := ⊤
    have hsum := MeasureTheory.probReal_add_probReal_compl
      (μ := (PMF.iid p n).toMeasure)
      (s := (↑(weakTypicalSet p n ε) : Set (Fin n → A))) MeasurableSet.of_discrete
    simp only [MeasureTheory.Measure.real, PMF.toMeasure_apply_eq_toOuterMeasure] at hsum
    linarith
  simpa only [sub_self] using Filter.Tendsto.congr' heq hlimit

private theorem tendsto_codeRate_roundedMessageSize {ρ : ℝ} (hρ : 0 ≤ ρ) :
    Tendsto (fun n : ℕ => codeRate n (roundedMessageSize n ρ)) atTop (nhds ρ) := by
  have hlo : ∀ᶠ n : ℕ in atTop, 0 ≤ codeRate n (roundedMessageSize n ρ) - ρ := by
    filter_upwards [eventually_gt_atTop (0 : ℕ)] with n hn
    exact sub_nonneg.mpr (codeRate_roundedMessageSize_bounds hn hρ).1
  have hhi : ∀ᶠ n : ℕ in atTop,
      codeRate n (roundedMessageSize n ρ) - ρ ≤ Real.log 2 / n := by
    filter_upwards [eventually_gt_atTop (0 : ℕ)] with n hn
    linarith [(codeRate_roundedMessageSize_bounds hn hρ).2]
  have hlimit := squeeze_zero' hlo hhi (tendsto_const_div_atTop_nhds_zero_nat (Real.log 2))
  simpa using hlimit.add_const ρ

/-- The private construction retains all stronger properties for the exact
family used by the public existential. The budgets are definitionally rounded,
and the code family is selected only once. -/
private theorem rounded_sourceCode_family {A : Type u} [Fintype A]
    (p : PMF A) {ρ : ℝ} (hρ : entropy p < ρ) :
    let ε := ρ - entropy p
    let M : ℕ → ℕ := fun n => roundedMessageSize n ρ
    ∃ c : ∀ n, BlockSourceCode A n (M n),
      (∀ n, 1 ≤ M n) ∧
      (∀ n : ℕ, Real.exp ((n : ℝ) * ρ) ≤ (M n : ℝ) ∧
        (M n : ℝ) < Real.exp ((n : ℝ) * ρ) + 1) ∧
      (∀ n, ∀ x ∈ weakTypicalSet p n ε, (c n).decoder ((c n).encoder x) = x) ∧
      (∀ n, (c n).errorProbability (PMF.iid p n) ≤
        ((PMF.iid p n).toOuterMeasure
          (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal) ∧
      (∀ n, 0 < n → ρ ≤ codeRate n (M n) ∧
        codeRate n (M n) ≤ ρ + Real.log 2 / n) ∧
      Tendsto (fun n => (c n).errorProbability (PMF.iid p n)) atTop (nhds 0) ∧
      Tendsto (fun n => codeRate n (M n)) atTop (nhds ρ) ∧
      M 0 = 1 ∧ (c 0).errorProbability (PMF.iid p 0) = 0 ∧
      codeRate 0 (M 0) = 0 ∧ weakTypicalSet p 0 ε = ∅ := by
  classical
  let ε := ρ - entropy p
  have hε : 0 < ε := sub_pos.mpr hρ
  have hρnonneg : 0 ≤ ρ := (entropy_nonneg p).trans hρ.le
  have hsum : entropy p + ε = ρ := by dsimp [ε]; ring
  dsimp only
  have hM (n : ℕ) : 1 ≤ roundedMessageSize n ρ := (roundedMessageSize_bounds n ρ).1
  have hexists (n : ℕ) :
      ∃ c : BlockSourceCode A n (roundedMessageSize n ρ),
        (∀ x ∈ weakTypicalSet p n ε, c.decoder (c.encoder x) = x) ∧
          c.errorProbability (PMF.iid p n) ≤
            ((PMF.iid p n).toOuterMeasure
              (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal := by
    have hcard : ((weakTypicalSet p n ε).card : ℝ) ≤
        (roundedMessageSize n ρ : ℝ) := by
      have h := card_weakTypicalSet_le p n ε
      rw [hsum] at h
      exact h.trans (roundedMessageSize_bounds n ρ).2.1
    exact exists_sourceCode_errorProbability_le (PMF.iid p n) (weakTypicalSet p n ε)
      (Nat.cast_le.mp hcard) (hM n)
  choose c hrecover herror using hexists
  have herrorLimit : Tendsto (fun n => (c n).errorProbability (PMF.iid p n))
      atTop (nhds 0) :=
    squeeze_zero (fun n => decodingErrorProbabilityOf_nonneg
      (PMF.iid p n) id (c n).encoder (c n).decoder) herror
      (tendsto_typical_complement_probability p hε)
  refine ⟨c, hM, fun n => (roundedMessageSize_bounds n ρ).2,
    hrecover, herror, ?_, herrorLimit, tendsto_codeRate_roundedMessageSize hρnonneg,
    ?_, ?_, codeRate_zero _, ?_⟩
  · intro n hn
    exact codeRate_roundedMessageSize_bounds hn hρnonneg
  · simp [roundedMessageSize]
  · rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure]
    have hfail :
        {x : Fin 0 → A | (c 0).decoder ((c 0).encoder x) ≠ id x} = ∅ := by
      ext x
      simp only [Set.mem_ofPred_eq, Set.mem_empty_iff_false, iff_false, not_not, id_eq]
      funext i
      exact Fin.elim0 i
    rw [hfail]
    simp
  · ext x
    simp [mem_weakTypicalSet]

/-- Every rate strictly above the entropy of a finite source admits one family
of positive-budget total block codes with iid error tending to zero and rate
eventually at most that rate, in nats. Both conclusions concern the same family.
The construction rounds at an intermediate rate to absorb integer overhead.
No full-support or positive-entropy assumption is needed; zero length is included
in the family with the existing totalized rate convention. -/
theorem exists_blockSourceCode_tendsto_errorProbability_zero
    {A : Type u} [Fintype A] (p : PMF A) {R : ℝ} (hR : entropy p < R) :
    ∃ M : ℕ → ℕ, (∀ n, 1 ≤ M n) ∧
      ∃ c : ∀ n, BlockSourceCode A n (M n),
        Tendsto (fun n => (c n).errorProbability (PMF.iid p n)) atTop (nhds 0) ∧
        (∀ᶠ n in atTop, codeRate n (M n) ≤ R) := by
  let ρ := (entropy p + R) / 2
  have hρ : entropy p < ρ := by dsimp [ρ]; linarith
  have hρR : ρ < R := by dsimp [ρ]; linarith
  obtain ⟨c, hM, _, _, _, _, herror, hrate, _⟩ := rounded_sourceCode_family p hρ
  exact ⟨fun n => roundedMessageSize n ρ, hM, c, herror,
    (hrate.eventually (gt_mem_nhds hρR)).mono fun _ h => h.le⟩

/-- The actual success probability is bounded by the typical complement and
the message budget times the typical atom cap. This finite estimate allows
every natural length and every real width. -/
private theorem typical_success_bound {A : Type u} [Fintype A]
    (p : PMF A) (n M : ℕ) (ε : ℝ) (c : BlockSourceCode A n M) :
    1 - c.errorProbability (PMF.iid p n) ≤
      ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal +
          (M : ℝ) * Real.exp (-(n : ℝ) * (entropy p - ε)) := by
  have h := c.successProbability_le (PMF.iid p n) (weakTypicalSet p n ε)
    (Real.exp (-(n : ℝ) * (entropy p - ε))) (Real.exp_pos _).le
    (fun x hx => (weakTypicalSet_mass_bounds p hx).2)
  rw [c.successProbability_eq_one_sub_errorProbability] at h
  exact h

/-- A pointwise rate cap bounds success at this length. Both the target and
the width are arbitrary reals; no eventual rate assumption enters this lemma.
Positive length and budget are used only to convert the rate to a budget. -/
private theorem typical_rate_converse {A : Type u} [Fintype A]
    (p : PMF A) (ε R : ℝ) {n M : ℕ} (c : BlockSourceCode A n M)
    (hn : 0 < n) (hM : 1 ≤ M) (hR : codeRate n M ≤ R) :
    1 - c.errorProbability (PMF.iid p n) ≤
      ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal +
          Real.exp (-(n : ℝ) * (entropy p - ε - R)) := by
  have hbudget : (M : ℝ) ≤ Real.exp ((n : ℝ) * R) :=
    (codeRate_le_iff hn hM R).mp hR
  calc
    1 - c.errorProbability (PMF.iid p n) ≤
        ((PMF.iid p n).toOuterMeasure
          (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal +
            (M : ℝ) * Real.exp (-(n : ℝ) * (entropy p - ε)) :=
      typical_success_bound p n M ε c
    _ ≤ ((PMF.iid p n).toOuterMeasure
          (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal +
            Real.exp ((n : ℝ) * R) * Real.exp (-(n : ℝ) * (entropy p - ε)) :=
      add_le_add le_rfl (mul_le_mul_of_nonneg_right hbudget (Real.exp_pos _).le)
    _ = _ := by
      rw [← Real.exp_add]
      congr 2
      ring

private theorem tendsto_exp_neg_nat_mul {d : ℝ} (hd : 0 < d) :
    Tendsto (fun n : ℕ => Real.exp (-(n : ℝ) * d)) atTop (nhds 0) := by
  have h : Tendsto (fun n : ℕ => d * (n : ℝ)) atTop atTop :=
    tendsto_natCast_atTop_atTop.const_mul_atTop hd
  simpa only [Function.comp_def, neg_mul, mul_comm d] using
    Real.tendsto_exp_neg_atTop_nhds_zero.comp h

/-- For a finite iid source, every family of positive-budget total block
codes whose rate is eventually bounded by a real R strictly below entropy
has error tending to one. Rates and entropy are in nats. No rate convergence,
global rate cap, full support, positive entropy or nonnegative R is assumed.
The family's zero-length code may use any positive budget. -/
theorem tendsto_errorProbability_iid_one_of_eventually_codeRate_le
    {A : Type u} [Fintype A] (p : PMF A)
    (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n) (c : ∀ n, BlockSourceCode A n (M n))
    {R : ℝ} (hR : R < entropy p)
    (hrate : ∀ᶠ n in atTop, codeRate n (M n) ≤ R) :
    Tendsto (fun n => (c n).errorProbability (PMF.iid p n)) atTop (nhds 1) := by
  let ε := (entropy p - R) / 2
  have hε : 0 < ε := by dsimp [ε]; linarith
  have hgap : 0 < entropy p - ε - R := by dsimp [ε]; linarith
  have hlimit := (tendsto_typical_complement_probability p hε).add
    (tendsto_exp_neg_nat_mul hgap)
  have hlo : ∀ᶠ n in atTop, 0 ≤ 1 - (c n).errorProbability (PMF.iid p n) :=
    Eventually.of_forall fun n => sub_nonneg.mpr
      (decodingErrorProbabilityOf_le_one (PMF.iid p n) id (c n).encoder (c n).decoder)
  have hhi : ∀ᶠ n in atTop, 1 - (c n).errorProbability (PMF.iid p n) ≤
      ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal +
          Real.exp (-(n : ℝ) * (entropy p - ε - R)) := by
    filter_upwards [eventually_gt_atTop (0 : ℕ), hrate] with n hn hnr
    exact typical_rate_converse p ε R (c n) hn (hM n) hnr
  have hsuccess := squeeze_zero' hlo hhi (by simpa only [add_zero] using hlimit)
  simpa using (tendsto_const_nhds (x := (1 : ℝ))).sub hsuccess

/-- Vanishing error for a finite iid source forces every positive-budget code
family eventually to have rate at least entropy minus any positive tolerance.
No boundedness, convergence or monotonicity of the rate sequence is assumed.
The pointwise success bound excludes arbitrarily late low-rate indices even
when other rates are unbounded. Rates and entropy are in nats. -/
theorem eventually_entropy_sub_le_codeRate_of_tendsto_errorProbability_zero
    {A : Type u} [Fintype A] (p : PMF A)
    (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n) (c : ∀ n, BlockSourceCode A n (M n))
    (herror : Tendsto (fun n => (c n).errorProbability (PMF.iid p n)) atTop (nhds 0))
    {δ : ℝ} (hδ : 0 < δ) :
    ∀ᶠ n in atTop, entropy p - δ ≤ codeRate n (M n) := by
  let ε := δ / 2
  have hε : 0 < ε := by dsimp [ε]; linarith
  have hgap : 0 < entropy p - ε - (entropy p - δ) := by dsimp [ε]; linarith
  have hlimit : Tendsto (fun n : ℕ =>
      ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal +
          Real.exp (-(n : ℝ) * (entropy p - ε - (entropy p - δ))))
      atTop (nhds 0) := by
    simpa only [add_zero] using (tendsto_typical_complement_probability p hε).add
      (tendsto_exp_neg_nat_mul hgap)
  have hsmall := hlimit.eventually (gt_mem_nhds (by norm_num : (0 : ℝ) < 1 / 2))
  have hsuccess : ∀ᶠ n in atTop, 1 / 2 < 1 - (c n).errorProbability (PMF.iid p n) :=
    (herror.eventually (gt_mem_nhds (by norm_num : (0 : ℝ) < 1 / 2))).mono
      fun n hn => by linarith
  filter_upwards [eventually_gt_atTop (0 : ℕ), hsmall, hsuccess] with n hn hsmall hsuccess
  by_contra hlow
  have hbound := typical_rate_converse p ε (entropy p - δ) (c n) hn (hM n)
    (lt_of_not_ge hlow).le
  linarith

/-- Entropy is the operational threshold for finite-iid almost-lossless
coding, in nats: it is the greatest lower bound of the asymptotic upper rates
of actual positive-budget code families with vanishing error. One family works
for every positive upper-rate tolerance. This does not assert attainment at
entropy or impose convergence, monotonicity or boundedness of the rate sequence. -/
theorem sourceCoding_threshold {A : Type u} [Fintype A] (p : PMF A) :
    IsGLB {R : ℝ | ∃ M : ℕ → ℕ, (∀ n, 1 ≤ M n) ∧
      ∃ c : ∀ n, BlockSourceCode A n (M n),
        Tendsto (fun n => (c n).errorProbability (PMF.iid p n)) atTop (nhds 0) ∧
        (∀ η : ℝ, 0 < η → ∀ᶠ n in atTop, codeRate n (M n) ≤ R + η)}
      (entropy p) := by
  constructor
  · rintro R ⟨M, hM, c, herror, hupper⟩
    by_contra h
    have hR : R < entropy p := lt_of_not_ge h
    let δ := (entropy p - R) / 3
    have hδ : 0 < δ := by dsimp [δ]; linarith
    obtain ⟨n, hlower, hupper⟩ :=
      ((eventually_entropy_sub_le_codeRate_of_tendsto_errorProbability_zero
        p M hM c herror hδ).and (hupper δ hδ)).exists
    dsimp [δ] at hlower hupper
    linarith
  · intro L hL
    by_contra h
    have hL' : entropy p < L := lt_of_not_ge h
    let R := (entropy p + L) / 2
    have hR : entropy p < R := by dsimp [R]; linarith
    obtain ⟨M, hM, c, herror, hrate⟩ :=
      exists_blockSourceCode_tendsto_errorProbability_zero p hR
    have hLR : L ≤ R := hL ⟨M, hM, c, herror, fun η hη =>
      hrate.mono fun _ hn => hn.trans (le_add_of_nonneg_right hη.le)⟩
    dsimp [R] at hLR
    linarith


end

end LeanInfoTheory.Shannon
