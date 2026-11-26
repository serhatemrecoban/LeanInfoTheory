/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.TypeClassProbability

/-! Public type-class probability interfaces under a fixed sampling law. -/

namespace Consumer.TypeProb

open LeanInfoTheory.Shannon
open scoped ENNReal BigOperators

noncomputable section

variable {A : Type*} [Fintype A] {n : ℕ}

/-- A missing observed atom rules out the class with no measurable-space instance. -/
private theorem missingAtom (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (a : A) (hc : 0 < t.val a) (hp : p a = 0) :
    (PMF.iid p n).toOuterMeasure (typeClass t) = 0 := by
  apply iid_toOuterMeasure_typeClass_eq_zero_of_not_support_subset hn t p
  intro hs
  exact ((p.mem_support_iff a).1 (hs ((mem_support_empiricalPMF_iff hn t a).2 hc))) hp

section Measurable

variable [MeasurableSpace A] [MeasurableSingletonClass A]

private def classFacts (t : ↥(wordTypes A n)) (q p : PMF A) : Prop :=
  let D := InformationTheory.klDiv q.toMeasure p.toMeasure
  let wordMass := Real.exp (-(n : ℝ) * (entropy q + D.toReal))
  let tail := Real.exp (-(n : ℝ) * D.toReal)
  let event := ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal
  D ≠ ⊤ ∧ D.toReal = ∑ a, (q a).toReal * Real.log ((q a / p a).toReal) ∧
    (∀ x ∈ typeClass t, ((PMF.iid p n) x).toReal = wordMass) ∧
    event = ((typeClass t).card : ℝ) * wordMass ∧
    tail / ((n : ℝ) + 1) ^ Fintype.card A ≤ event ∧ event ≤ tail

private theorem formulas (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (hs : (empiricalPMF hn t).support ⊆ p.support) : classFacts t (empiricalPMF hn t) p := by
  have hfin := (klDiv_pmf_ne_top_iff_support_subset (empiricalPMF hn t) p).2 hs
  have hsum := toReal_klDiv_pmf_eq_sum (empiricalPMF hn t) p
    (InformationTheory.klDiv_ne_top_iff.mp hfin).1
  exact ⟨hfin, hsum, fun _ hx => iid_apply_of_mem_typeClass hn t p hs hx,
    iid_toOuterMeasure_typeClass hn t p hs,
    exp_neg_klDiv_div_pow_le_iid_toOuterMeasure_typeClass hn t p hs,
    iid_toOuterMeasure_typeClass_le_exp_neg_klDiv hn t p hs⟩

example (hn : 0 < n) (c : A → ℕ) (hc : ∑ a, c a = n) (p : PMF A)
    (hp : ∀ a, 0 < c a → p a ≠ 0) :
    let t : ↥(wordTypes A n) := ⟨c, (mem_wordTypes c).2 hc⟩
    classFacts t (empiricalPMF hn t) p := by
  let t : ↥(wordTypes A n) := ⟨c, (mem_wordTypes c).2 hc⟩
  apply formulas hn t p
  intro a ha
  exact (p.mem_support_iff a).2 (hp a ((mem_support_empiricalPMF_iff hn t a).1 ha))

example (hn : 0 < n) (q p : PMF A)
    (denom : ∃ c : A → ℕ, (∑ a, c a) = n ∧ ∀ a, q a = (c a : ℝ≥0∞) / n)
    (hs : q.support ⊆ p.support) :
    let t := (wordTypeEquivPMF hn).symm ⟨q, denom⟩
    empiricalPMF hn t = q ∧
      (∀ x, x ∈ typeClass t ↔ empiricalPMF hn (wordType x) = q) ∧ classFacts t q p := by
  let t := (wordTypeEquivPMF hn).symm ⟨q, denom⟩
  have hq : empiricalPMF hn t = q :=
    congrArg Subtype.val ((wordTypeEquivPMF hn).apply_symm_apply ⟨q, denom⟩)
  refine ⟨hq, fun x => ?_, ?_⟩
  · exact (mem_typeClass_iff_empiricalPMF_eq hn).trans (congrArg (empiricalPMF hn (wordType x) = ·) hq).to_iff
  · have h := formulas hn t p (hq.symm ▸ hs)
    rwa [hq] at h

private theorem zeroIffTop (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A) :
    (PMF.iid p n).toOuterMeasure (typeClass t) = 0 ↔
      InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure = ⊤ := by
  by_cases hs : (empiricalPMF hn t).support ⊆ p.support
  · obtain ⟨hfinite, _, _, _, hlo, _⟩ := formulas hn t p hs
    have hpos : 0 < ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal :=
      lt_of_lt_of_le (div_pos (Real.exp_pos _) (pow_pos (by positivity) _)) hlo
    exact iff_of_false (fun hzero => by simp [hzero] at hpos) hfinite
  · exact iff_of_true (iid_toOuterMeasure_typeClass_eq_zero_of_not_support_subset hn t p hs)
      ((klDiv_pmf_eq_top_iff_not_support_subset _ _).2 hs)

end Measurable

/-! Two observed labels, one unused positive-prior label, and one common-null label. -/

private def observed : ↥(wordTypes (Fin 4) 2) :=
  ⟨fun a => if a = 0 ∨ a = 3 then 1 else 0, (mem_wordTypes _).2 (by decide)⟩

private def prior : PMF (Fin 4) :=
  PMF.uniformOfFinset {0, 1, 3} (by decide)

private abbrev q := empiricalPMF (by decide : 0 < 2) observed

private theorem empiricalAtom (a : Fin 4) :
    (q a).toReal = if a = 0 ∨ a = 3 then (1 / 2 : ℝ) else 0 := by
  rw [empiricalPMF_apply, ENNReal.toReal_div, ENNReal.toReal_natCast, ENNReal.toReal_natCast]
  change ((if a = 0 ∨ a = 3 then 1 else 0 : ℕ) : ℝ) / 2 = _
  split <;> norm_num

private theorem priorAtom (a : Fin 4) :
    (prior a).toReal = if a = 2 then 0 else (1 / 3 : ℝ) := by
  have card : ({0, 1, 3} : Finset (Fin 4)).card = 3 := by decide
  fin_cases a <;> norm_num [prior, PMF.uniformOfFinset_apply, card, ENNReal.toReal_inv, Fin.ext_iff]

private theorem contained : q.support ⊆ prior.support := by
  intro a ha
  have hq : 0 < (q a).toReal := ENNReal.toReal_pos ((q.mem_support_iff a).1 ha) (q.apply_ne_top a)
  apply (prior.mem_support_iff a).2
  intro hz
  have hp : (prior a).toReal = 0 := by rw [hz, ENNReal.toReal_zero]
  rw [empiricalAtom] at hq
  rw [priorAtom] at hp
  have hne : a ≠ 2 := by
    rintro rfl
    norm_num [Fin.ext_iff] at hq
  rw [if_neg hne] at hp
  norm_num at hp

private theorem expNegTwiceLog (z : ℝ) (hz : 0 < z) :
    Real.exp (-(2 : ℝ) * Real.log z) = (z ^ 2)⁻¹ := by
  rw [show -(2 : ℝ) * Real.log z = -Real.log (z ^ 2) by rw [Real.log_pow]; ring,
    Real.exp_neg, Real.exp_log (pow_pos hz 2)]

example :
    let D := InformationTheory.klDiv q.toMeasure prior.toMeasure
    let mass := ((PMF.iid prior 2).toOuterMeasure (typeClass observed)).toReal
    D ≠ ⊤ ∧ D.toReal = Real.log (3 / 2) ∧ (typeClass observed).card = 2 ∧
      (∀ x ∈ typeClass observed, ((PMF.iid prior 2) x).toReal = 1 / 9) ∧
      mass = 2 / 9 ∧ 4 / 729 ≤ mass ∧ mass ≤ 4 / 9 := by
  let D := InformationTheory.klDiv q.toMeasure prior.toMeasure
  obtain ⟨hfin, hsum, hword, hmass, hlower, hupper⟩ := formulas (by decide) observed prior contained
  have hD : D.toReal = Real.log (3 / 2) := by
    change (InformationTheory.klDiv q.toMeasure prior.toMeasure).toReal = _
    rw [hsum]
    simp only [ENNReal.toReal_div, empiricalAtom, priorAtom, Fin.sum_univ_succ]
    norm_num [Fin.ext_iff]
    ring
  have hH : entropy q = Real.log 2 := by
    have logHalf : Real.log ((1 : ℝ) / 2) = -Real.log 2 := by
      rw [Real.log_div (by norm_num) (by norm_num), Real.log_one, zero_sub]
    rw [entropy_eq_sum]
    simp only [Fin.sum_univ_succ, empiricalAtom, Real.negMulLog]
    norm_num [Fin.ext_iff, logHalf, Real.log_inv]
    ring
  have hsumlog : entropy q + D.toReal = Real.log 3 := by
    rw [hH, hD, ← Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) (by norm_num : (3 / 2 : ℝ) ≠ 0)]
    norm_num
  have wordFactor : Real.exp (-(2 : ℝ) * (entropy q + D.toReal)) = 1 / 9 := by
    rw [hsumlog, expNegTwiceLog _ (by norm_num)]
    norm_num
  have tail : Real.exp (-(2 : ℝ) * D.toReal) = 4 / 9 := by
    rw [hD, expNegTwiceLog _ (by norm_num)]
    norm_num
  have card : (typeClass observed).card = 2 := by
    rw [card_typeClass_eq_multinomial]
    decide
  refine ⟨hfin, hD, card, ?_, ?_, ?_, ?_⟩
  · intro x hx
    exact (hword x hx).trans wordFactor
  · calc
      _ = ((typeClass observed).card : ℝ) * Real.exp (-(2 : ℝ) * (entropy q + D.toReal)) := hmass
      _ = 2 / 9 := by rw [wordFactor, card]; norm_num
  · calc
      (4 / 729 : ℝ) = Real.exp (-(2 : ℝ) * D.toReal) / ((2 : ℝ) + 1) ^ Fintype.card (Fin 4) := by
        rw [tail]
        norm_num
      _ ≤ _ := hlower
  · exact hupper.trans_eq tail

example :
    let p := PMF.pure (0 : Fin 4)
    (PMF.iid p 2).toOuterMeasure (typeClass observed) = 0 ∧
      InformationTheory.klDiv q.toMeasure p.toMeasure = ⊤ := by
  let p := PMF.pure (0 : Fin 4)
  have hzero := missingAtom (by decide) observed p 3 (by decide)
    (by norm_num [p, PMF.pure_apply, Fin.ext_iff])
  exact ⟨hzero, (zeroIffTop (by decide) observed p).1 hzero⟩

end
end Consumer.TypeProb
