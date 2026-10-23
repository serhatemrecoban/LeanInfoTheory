/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.Fano
import Mathlib.Data.Fintype.EquivFin

/-!
# Deterministic source codes and one-shot bounds

A source code is a total encoder into `Fin M` and a total decoder back to the
source type. Operational message budgets satisfy `1 ≤ M`; the transparent
pair type also permits a lawless empty-source, zero-message degeneracy.
A supplied PMF rules out that degeneracy. No global encoder injectivity is
assumed: injectivity holds only on the set of correctly recovered inputs.

Error reuses `decodingErrorProbabilityOf`. Real event probabilities are obtained
from the PMF's outer measure, with success and failure complementary. This
finite owner is independent of iid laws, typical sets and AEP.

A finite set fitting in the message budget can be recovered exactly. Its
complement therefore bounds error from above, with the same code witness.
Conversely, an atom cap on a selected set bounds success by its complement
probability plus the message budget times the cap. The cap is nonnegative,
including when the selected set is empty.

The total-decoder model adapts PW24 §11.1, Remark 11.1 (printed p. 214): on a
nonempty source, replacing erasures by a source value preserves prior successes.
All `M` indices are available; there is no reserved erasure index.
-/

namespace LeanInfoTheory.Shannon

noncomputable section

universe u

open scoped BigOperators

/-- A total deterministic encoder/decoder pair with `M` message indices.
Operational budgets are positive; no global recovery law is imposed. -/
abbrev SourceCode (X : Type u) (M : ℕ) := (X → Fin M) × (Fin M → X)

/-- A source code for words of length `n`, including the unique empty word at
length zero. No independence assumption is imposed on a word law. -/
abbrev BlockSourceCode (A : Type u) (n M : ℕ) := SourceCode (Fin n → A) M

namespace SourceCode

/-- The encoder of a deterministic source code. -/
abbrev encoder {X : Type u} {M : ℕ} (c : SourceCode X M) : X → Fin M := c.1

/-- The total decoder of a deterministic source code. -/
abbrev decoder {X : Type u} {M : ℕ} (c : SourceCode X M) : Fin M → X := c.2

/-- Source-code error, using the existing random-variable decoding semantics. -/
abbrev errorProbability {X : Type u} {M : ℕ} (c : SourceCode X M) (q : PMF X) : ℝ :=
  decodingErrorProbabilityOf q id c.encoder c.decoder

/-- All source values actually recovered by the code, including zero-mass
values and any successes beyond a set selected during construction. -/
def successSet {X : Type u} [Fintype X] {M : ℕ} (c : SourceCode X M) : Finset X := by
  classical
  exact Finset.univ.filter fun x => c.decoder (c.encoder x) = x

/-- Membership in the success set is exact recovery of the source value. -/
theorem mem_successSet {X : Type u} [Fintype X] {M : ℕ} (c : SourceCode X M)
    (x : X) : x ∈ c.successSet ↔ c.decoder (c.encoder x) = x := by
  classical
  simp only [successSet, Finset.mem_filter, Finset.mem_univ, true_and]

/-- At most `M` source values can be recovered: the encoder is injective on
its success set even when it collides elsewhere. This count is law-free. -/
theorem card_successSet_le {X : Type u} [Fintype X] {M : ℕ} (c : SourceCode X M) :
    c.successSet.card ≤ M := by
  classical
  have h := Finset.card_le_card_of_injOn (s := c.successSet)
    (t := Finset.univ) c.encoder (by intro x hx; exact Finset.mem_univ _)
    (by
      intro x hx y hy hxy
      have hx' := (c.mem_successSet x).mp hx
      have hy' := (c.mem_successSet y).mp hy
      exact hx'.symm.trans ((congrArg c.decoder hxy).trans hy'))
  simpa only [Finset.card_univ, Fintype.card_fin] using h

/-- The real probability of successful decoding is one minus the existing
error probability. The probability-measure complement theorem accounts for
finiteness before converting complementary event masses to real numbers. -/
theorem successProbability_eq_one_sub_errorProbability
    {X : Type u} [Fintype X] {M : ℕ} (c : SourceCode X M) (q : PMF X) :
    (q.toOuterMeasure (c.successSet : Set X)).toReal = 1 - c.errorProbability q := by
  classical
  let : MeasurableSpace X := ⊤
  have hsum := MeasureTheory.probReal_add_probReal_compl
    (μ := q.toMeasure) (s := (c.successSet : Set X)) MeasurableSet.of_discrete
  simp only [MeasureTheory.Measure.real, PMF.toMeasure_apply_eq_toOuterMeasure] at hsum
  have hfail : {x | c.decoder (c.encoder x) ≠ x} = (c.successSet : Set X)ᶜ := by
    ext x
    simp only [Set.mem_ofPred_eq, Set.mem_compl_iff, Finset.mem_coe, c.mem_successSet]
  rw [errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure]
  simp only [id_eq, hfail]
  linarith

/-- A one-shot converse for an arbitrary finite source law. A nonnegative
atom cap on `T` bounds successful mass inside `T` by `M * b`; successful mass
outside `T` is at most the entire complement probability. -/
theorem successProbability_le {X : Type u} [Fintype X] {M : ℕ}
    (c : SourceCode X M) (q : PMF X) (T : Finset X) (b : ℝ)
    (hb : 0 ≤ b) (hcap : ∀ x ∈ T, (q x).toReal ≤ b) :
    (q.toOuterMeasure (c.successSet : Set X)).toReal ≤
      (q.toOuterMeasure (T : Set X)ᶜ).toReal + (M : ℝ) * b := by
  classical
  have hprob (U : Finset X) :
      (q.toOuterMeasure (U : Set X)).toReal = ∑ x ∈ U, (q x).toReal := by
    rw [PMF.toOuterMeasure_apply_finset]
    exact ENNReal.toReal_sum (fun x _ => q.apply_ne_top x)
  have hinside : (∑ x ∈ c.successSet ∩ T, (q x).toReal) ≤ (M : ℝ) * b := by
    calc
      _ ≤ ∑ _x ∈ c.successSet ∩ T, b :=
        Finset.sum_le_sum fun x hx => hcap x (Finset.mem_inter.mp hx).2
      _ = ((c.successSet ∩ T).card : ℝ) * b := by simp
      _ ≤ (M : ℝ) * b := by
        apply mul_le_mul_of_nonneg_right _ hb
        exact_mod_cast
          (Finset.card_le_card
            (Finset.inter_subset_left : c.successSet ∩ T ⊆ c.successSet)).trans
              c.card_successSet_le
  have houtside : (∑ x ∈ c.successSet \ T, (q x).toReal) ≤
      ∑ x ∈ Tᶜ, (q x).toReal := by
    apply Finset.sum_le_sum_of_subset_of_nonneg
    · intro x hx
      exact Finset.mem_compl.mpr (Finset.mem_sdiff.mp hx).2
    · intro x _ _
      exact PMF.toReal_nonneg q x
  calc
    (q.toOuterMeasure (c.successSet : Set X)).toReal =
        (∑ x ∈ c.successSet ∩ T, (q x).toReal) +
          ∑ x ∈ c.successSet \ T, (q x).toReal := by
      rw [hprob]
      exact (Finset.sum_inter_add_sum_sdiff
        c.successSet T (fun x => (q x).toReal)).symm
    _ ≤ (M : ℝ) * b + ∑ x ∈ Tᶜ, (q x).toReal := add_le_add hinside houtside
    _ = (q.toOuterMeasure (T : Set X)ᶜ).toReal + (M : ℝ) * b := by
      rw [← hprob Tᶜ, Finset.coe_compl]
      exact add_comm _ _

end SourceCode

/-- Any finite selected set fitting in a positive message budget admits a
total code recovering every selected value. Ambient nonemptiness supplies the
decoder fallback, including when the selected set is empty. -/
theorem exists_sourceCode_correctOn {X : Type u} [Finite X] [Nonempty X]
    (T : Finset X) {M : ℕ} (hT : T.card ≤ M) (hM : 1 ≤ M) :
    ∃ c : SourceCode X M, ∀ x ∈ T, c.decoder (c.encoder x) = x := by
  classical
  let e : T ↪ Fin M := T.equivFin.toEmbedding.trans (Fin.castLEEmb hT)
  let zeroIndex : Fin M := ⟨0, lt_of_lt_of_le Nat.zero_lt_one hM⟩
  let fallback : X := Classical.choice inferInstance
  refine ⟨(Function.extend (Subtype.val : T → X) e (fun _ => zeroIndex),
    Function.extend e (Subtype.val : T → X) (fun _ => fallback)), ?_⟩
  intro x hx
  change Function.extend e (Subtype.val : T → X) (fun _ => fallback)
    (Function.extend (Subtype.val : T → X) e (fun _ => zeroIndex) x) = x
  rw [Subtype.val_injective.extend_apply e (fun _ => zeroIndex) ⟨x, hx⟩]
  exact e.injective.extend_apply (Subtype.val : T → X) (fun _ => fallback) ⟨x, hx⟩

/-- A selected set fitting in the budget gives one code that recovers the
whole set and has error at most its complement probability. The law supplies
ambient nonemptiness. Extra correct decodings outside `T` are permitted, so
the error guarantee is an inequality. -/
theorem exists_sourceCode_errorProbability_le {X : Type u} [Finite X]
    (q : PMF X) (T : Finset X) {M : ℕ} (hT : T.card ≤ M) (hM : 1 ≤ M) :
    ∃ c : SourceCode X M, (∀ x ∈ T, c.decoder (c.encoder x) = x) ∧
      c.errorProbability q ≤ (q.toOuterMeasure (T : Set X)ᶜ).toReal := by
  obtain ⟨x₀, _⟩ := q.support_nonempty
  let : Nonempty X := ⟨x₀⟩
  obtain ⟨c, hc⟩ := exists_sourceCode_correctOn T hT hM
  refine ⟨c, hc, ?_⟩
  rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure]
  apply ENNReal.toReal_mono
  · rw [PMF.toOuterMeasure_apply]
    exact q.tsum_coe_indicator_ne_top _
  · apply q.toOuterMeasure.mono
    intro x hx
    change x ∉ T
    intro hxT
    exact hx (hc x hxT)

end

end LeanInfoTheory.Shannon
