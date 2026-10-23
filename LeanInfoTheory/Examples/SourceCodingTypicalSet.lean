/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.CodingRate
import LeanInfoTheory.Shannon.SemanticBridge.AEP
import LeanInfoTheory.Shannon.SourceCoding

/-!
# Source coding through the supported strict typical sets

These private consumers compose the public finite coding endpoints with C19's
iid laws, supported strict typical sets and typical-probability limit. One actual
dependent family uses the ceiling budgets at entropy plus a positive width. The
same chosen codes recover every typical word and satisfy the complement error
bound at every length, with the rate sandwich at positive lengths. The family
starts with one message and the unique empty word.

The converse remains a statement about an arbitrary code and budget. Its rate
form accepts any real target. Complement convergence is recorded beside these
finite statements; no limit of code error or operational rate is proved here.
-/

namespace LeanInfoTheory.Examples.SourceCodingTypicalSet

noncomputable section

universe u

open LeanInfoTheory.Shannon

private theorem typical_complement_probability {A : Type u} [Fintype A]
    (p : PMF A) {ε : ℝ} (hε : 0 < ε) :
    Filter.Tendsto
      (fun n : ℕ => ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal)
      Filter.atTop (nhds 0) := by
  have hlimit := Filter.Tendsto.sub (tendsto_const_nhds (x := (1 : ℝ)))
    (tendsto_prob_weakTypicalSet p hε)
  have heq :
      (fun n : ℕ =>
        1 - ((PMF.iid p n).toOuterMeasure (weakTypicalSet p n ε)).toReal)
        =ᶠ[Filter.atTop]
      (fun n : ℕ => ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal) := by
    apply Filter.Eventually.of_forall
    intro n
    let : MeasurableSpace (Fin n → A) := ⊤
    have hsum := MeasureTheory.probReal_add_probReal_compl
      (μ := (PMF.iid p n).toMeasure)
      (s := (↑(weakTypicalSet p n ε) : Set (Fin n → A))) MeasurableSet.of_discrete
    simp only [MeasureTheory.Measure.real, PMF.toMeasure_apply_eq_toOuterMeasure] at hsum
    linarith
  simpa only [sub_self] using Filter.Tendsto.congr' heq hlimit

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

private theorem rounded_typical_family {A : Type u} [Fintype A]
    (p : PMF A) {ε : ℝ} (hε : 0 < ε) :
    let M : ℕ → ℕ := fun n => roundedMessageSize n (entropy p + ε)
    ∃ c : ∀ n, BlockSourceCode A n (M n),
      (∀ n, 1 ≤ M n) ∧
      (∀ n, ∀ x ∈ weakTypicalSet p n ε, (c n).decoder ((c n).encoder x) = x) ∧
      (∀ n, (c n).errorProbability (PMF.iid p n) ≤
        ((PMF.iid p n).toOuterMeasure
          (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal) ∧
      (∀ n, 0 < n →
        entropy p + ε ≤ codeRate n (M n) ∧
          codeRate n (M n) ≤ entropy p + ε + Real.log 2 / n) ∧
      M 0 = 1 ∧
      (∀ j : Fin (M 0), (c 0).decoder j = (fun i : Fin 0 => Fin.elim0 i)) ∧
      (c 0).errorProbability (PMF.iid p 0) = 0 ∧
      codeRate 0 (M 0) = 0 := by
  classical
  dsimp only
  have hM (n : ℕ) : 1 ≤ roundedMessageSize n (entropy p + ε) :=
    (roundedMessageSize_bounds n (entropy p + ε)).1
  have hexists (n : ℕ) :
      ∃ c : BlockSourceCode A n (roundedMessageSize n (entropy p + ε)),
        (∀ x ∈ weakTypicalSet p n ε, c.decoder (c.encoder x) = x) ∧
          c.errorProbability (PMF.iid p n) ≤
            ((PMF.iid p n).toOuterMeasure
              (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal := by
    have hcard : ((weakTypicalSet p n ε).card : ℝ) ≤
        (roundedMessageSize n (entropy p + ε) : ℝ) :=
      (card_weakTypicalSet_le p n ε).trans
        (roundedMessageSize_bounds n (entropy p + ε)).2.1
    exact exists_sourceCode_errorProbability_le (PMF.iid p n) (weakTypicalSet p n ε)
      (Nat.cast_le.mp hcard) (hM n)
  choose c hrecover herror using hexists
  refine ⟨c, hM, hrecover, herror, ?_, ?_, ?_, ?_, ?_⟩
  · intro n hn
    exact codeRate_roundedMessageSize_bounds hn (add_nonneg (entropy_nonneg p) hε.le)
  · simp [roundedMessageSize]
  · intro j
    funext i
    exact Fin.elim0 i
  · rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure]
    have hfail :
        {x : Fin 0 → A | (c 0).decoder ((c 0).encoder x) ≠ id x} = ∅ := by
      ext x
      simp only [Set.mem_ofPred_eq, Set.mem_empty_iff_false, iff_false, not_not, id_eq]
      funext i
      exact Fin.elim0 i
    rw [hfail]
    simp
  · exact codeRate_zero _

/-- One interface-composition checkpoint: the same strict typical sets and iid
laws supply the complement limit, one chosen family at the rounded budgets,
and finite converses for arbitrary codes. No code-error limit is asserted. -/
private theorem typical_coding_inputs {A : Type u} [Fintype A]
    (p : PMF A) {ε : ℝ} (hε : 0 < ε) :
    let M : ℕ → ℕ := fun n => roundedMessageSize n (entropy p + ε)
    Filter.Tendsto
      (fun n : ℕ => ((PMF.iid p n).toOuterMeasure
        (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal)
      Filter.atTop (nhds 0) ∧
    (∃ c : ∀ n, BlockSourceCode A n (M n),
      (∀ n, 1 ≤ M n) ∧
      (∀ n, ∀ x ∈ weakTypicalSet p n ε, (c n).decoder ((c n).encoder x) = x) ∧
      (∀ n, (c n).errorProbability (PMF.iid p n) ≤
        ((PMF.iid p n).toOuterMeasure
          (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal) ∧
      (∀ n, 0 < n →
        entropy p + ε ≤ codeRate n (M n) ∧
          codeRate n (M n) ≤ entropy p + ε + Real.log 2 / n) ∧
      M 0 = 1 ∧
      (∀ j : Fin (M 0), (c 0).decoder j = (fun i : Fin 0 => Fin.elim0 i)) ∧
      (c 0).errorProbability (PMF.iid p 0) = 0 ∧
      codeRate 0 (M 0) = 0) ∧
    (∀ (n K : ℕ) (c : BlockSourceCode A n K),
      1 - c.errorProbability (PMF.iid p n) ≤
        ((PMF.iid p n).toOuterMeasure
          (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal +
            (K : ℝ) * Real.exp (-(n : ℝ) * (entropy p - ε))) ∧
    (∀ (n K : ℕ) (c : BlockSourceCode A n K) (R : ℝ),
      0 < n → 1 ≤ K → codeRate n K ≤ R →
        1 - c.errorProbability (PMF.iid p n) ≤
          ((PMF.iid p n).toOuterMeasure
            (↑(weakTypicalSet p n ε) : Set (Fin n → A))ᶜ).toReal +
              Real.exp (-(n : ℝ) * (entropy p - ε - R))) := by
  dsimp only
  refine ⟨typical_complement_probability p hε, rounded_typical_family p hε, ?_, ?_⟩
  · intro n K c
    exact typical_success_bound p n K ε c
  · intro n K c R hn hK hR
    exact typical_rate_converse p ε R c hn hK hR

end

end LeanInfoTheory.Examples.SourceCodingTypicalSet
