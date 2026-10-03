/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.TotalVariation
import LeanInfoTheory.Shannon.SemanticBridge.DataProcessing
import Mathlib.Analysis.SpecialFunctions.BinaryEntropy
import Mathlib.Analysis.Convex.Deriv
import Mathlib.Analysis.Real.Sqrt
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.FunProp

/-!
# Pinsker's inequality for finite probability laws

This semantic bridge bounds twice the square of the half-L1 total variation
by mathlib's canonical `ENNReal` KL divergence, in nats. The statement includes
infinite KL and requires no support inclusion. The Real-valued and square-root
forms assume support inclusion, which makes KL finite on finite alphabets.

For a joint law, mutual information bounds total variation from the product
of its marginals. The joint law is absolutely continuous with respect to this
product, so these bounds require no additional support hypotheses.

The proof reduces to the Boolean image of an attaining event using the
existing TV and KL data-processing APIs. A private closed-interval convexity
argument supplies the binary estimate, including zero numerator masses;
support inclusion handles degenerate reference laws in the finite-KL branch.
This follows the binary reduction and second-derivative bound in Polyanskiy
and Wu (2024), Section 7.4, Theorem 7.10.
-/

namespace LeanInfoTheory
namespace Shannon

open Set Real MeasureTheory
open scoped BigOperators

noncomputable section

universe u

/-! ## Private binary estimate -/

-- Subtract the desired quadratic bound from binary KL. Binary entropy keeps
-- this function continuous at both numerator endpoints.
private def pinskerGap (q x : ℝ) : ℝ :=
  -binEntropy x - x * log q - (1 - x) * log (1 - q) - 2 * (x - q) ^ 2

private def pinskerGapDeriv (q x : ℝ) : ℝ :=
  -(log (1 - x) - log x) - log q + log (1 - q) - 4 * (x - q)

private theorem hasDerivAt_pinskerGap {q x : ℝ} (hx : x ∈ Ioo 0 1) :
    HasDerivAt (pinskerGap q) (pinskerGapDeriv q x) x := by
  have hb := (hasDerivAt_binEntropy hx.1.ne' hx.2.ne).neg
  have h1 := (hasDerivAt_id x).mul_const (log q)
  have h2 := ((hasDerivAt_const x 1).sub (hasDerivAt_id x)).mul_const (log (1 - q))
  have h3 := (((hasDerivAt_id x).sub_const q).pow 2).const_mul 2
  convert! ((hb.sub h1).sub h2).sub h3 using 1
  dsimp [pinskerGap, pinskerGapDeriv]
  ring

private theorem hasDerivAt_pinskerGapDeriv {q x : ℝ} (hx : x ∈ Ioo 0 1) :
    HasDerivAt (pinskerGapDeriv q) (1 / (1 - x) + 1 / x - 4) x := by
  have hlog1 := ((hasDerivAt_const x 1).sub (hasDerivAt_id x)).log
    (by linarith [hx.2] : 1 - x ≠ 0)
  have hlog2 := hasDerivAt_log hx.1.ne'
  have hlin := ((hasDerivAt_id x).sub_const q).const_mul 4
  convert! (((hlog1.sub hlog2).neg.sub_const (log q)).add_const (log (1 - q))).sub hlin
    using 1
  dsimp [pinskerGapDeriv]
  ring

private theorem convexOn_pinskerGap (q : ℝ) :
    ConvexOn ℝ (Icc 0 1) (pinskerGap q) := by
  apply convexOn_of_hasDerivWithinAt2_nonneg (convex_Icc 0 1)
      (f' := pinskerGapDeriv q) (f'' := fun x => 1 / (1 - x) + 1 / x - 4)
  · unfold pinskerGap
    fun_prop
  · intro x hx
    exact (hasDerivAt_pinskerGap (by simpa using hx)).hasDerivWithinAt
  · intro x hx
    exact (hasDerivAt_pinskerGapDeriv (by simpa using hx)).hasDerivWithinAt
  · intro x hx
    have hx' : x ∈ Ioo 0 1 := by simpa using hx
    have hx0 := hx'.1
    have hx1 : 0 < 1 - x := by linarith [hx'.2]
    have heq : 1 / (1 - x) + 1 / x - 4 = (2 * x - 1) ^ 2 / (x * (1 - x)) := by
      field_simp [hx0.ne', hx1.ne']
      ring
    rw [heq]
    positivity

private theorem two_mul_sub_sq_le_binary_kl
    {p q : ℝ} (hp : p ∈ Icc 0 1) (hq : q ∈ Ioo 0 1) :
    2 * (p - q) ^ 2 ≤ -binEntropy p - p * log q - (1 - p) * log (1 - q) := by
  have hd : HasDerivAt (pinskerGap q) 0 q := by
    convert hasDerivAt_pinskerGap hq using 1
    simp [pinskerGapDeriv]
  have hmin := (convexOn_pinskerGap q).isMinOn_of_rightDeriv_eq_zero
    (by simpa using hq)
    (hd.hasDerivWithinAt.derivWithin (uniqueDiffWithinAt_Ioi q))
  have h := hmin hp
  have hzero : pinskerGap q q = 0 := by
    simp [pinskerGap, binEntropy, log_inv]
  rw [hzero] at h
  dsimp [pinskerGap] at h
  linarith

-- Multiplication by a zero numerator makes the log identity valid there too.
private theorem mul_log_div_of_ne_zero (a b : ℝ) (hb : b ≠ 0) :
    a * log (a / b) = a * log a - a * log b := by
  by_cases ha : a = 0
  · simp [ha]
  · rw [log_div ha hb]
    ring

private theorem toReal_false_eq_one_sub_toReal_true (p : PMF Bool) :
    (p false).toReal = 1 - (p true).toReal := by
  have hs := p.sum_toReal
  simp only [Fintype.sum_bool] at hs
  linarith

private theorem eq_of_support_subset_of_bool_atom_eq_zero
    (p q : PMF Bool) (hs : p.support ⊆ q.support) (b : Bool) (hq : q b = 0) :
    p = q := by
  have hp : p b = 0 := by
    by_contra hp
    exact (q.mem_support_iff b).mp (hs ((p.mem_support_iff b).mpr hp)) hq
  have hpsum := p.sum_toReal
  have hqsum := q.sum_toReal
  apply PMF.ext
  intro c
  apply (ENNReal.toReal_eq_toReal_iff' (p.apply_ne_top c) (q.apply_ne_top c)).mp
  cases b <;> cases c <;> simp_all only [Fintype.sum_bool, ENNReal.toReal_zero] <;> linarith

private theorem ofReal_two_mul_bool_mass_sub_sq_le_klDiv (p q : PMF Bool) :
    ENNReal.ofReal (2 * ((p true).toReal - (q true).toReal) ^ 2) ≤
      InformationTheory.klDiv p.toMeasure q.toMeasure := by
  by_cases htop : InformationTheory.klDiv p.toMeasure q.toMeasure = ⊤
  · simp [htop]
  have hs := (klDiv_pmf_ne_top_iff_support_subset p q).mp htop
  by_cases hqt : q true = 0
  · rw [eq_of_support_subset_of_bool_atom_eq_zero p q hs true hqt]
    simp
  by_cases hqf : q false = 0
  · rw [eq_of_support_subset_of_bool_atom_eq_zero p q hs false hqf]
    simp
  have ht : 0 < (q true).toReal := ENNReal.toReal_pos hqt (q.apply_ne_top true)
  have hf : 0 < (q false).toReal := ENNReal.toReal_pos hqf (q.apply_ne_top false)
  have hq1 : (q true).toReal < 1 := by
    rw [toReal_false_eq_one_sub_toReal_true] at hf
    linarith
  have hscalar := two_mul_sub_sq_le_binary_kl
    (p := (p true).toReal) (q := (q true).toReal)
    ⟨p.toReal_nonneg true, p.toReal_le_one true⟩ ⟨ht, hq1⟩
  apply ENNReal.ofReal_le_of_le_toReal
  rw [toReal_klDiv_pmf_eq_sum p q
    ((toMeasure_absolutelyContinuous_iff_support_subset p q).mpr hs)]
  simp only [Fintype.sum_bool, ENNReal.toReal_div]
  rw [mul_log_div_of_ne_zero _ _ ht.ne', mul_log_div_of_ne_zero _ _ hf.ne',
    toReal_false_eq_one_sub_toReal_true p, toReal_false_eq_one_sub_toReal_true q]
  simp only [binEntropy, log_inv] at hscalar
  nlinarith [hscalar]

private theorem totalVariation_bool_eq_abs_sub (p q : PMF Bool) :
    PMF.totalVariation p q = |(p true).toReal - (q true).toReal| := by
  rw [PMF.totalVariation, Fintype.sum_bool,
    toReal_false_eq_one_sub_toReal_true p, toReal_false_eq_one_sub_toReal_true q]
  rw [show 1 - (p true).toReal - (1 - (q true).toReal) =
      -((p true).toReal - (q true).toReal) by ring, abs_neg]
  ring

private theorem ofReal_two_mul_totalVariation_bool_sq_le_klDiv (p q : PMF Bool) :
    ENNReal.ofReal (2 * PMF.totalVariation p q ^ 2) ≤
      InformationTheory.klDiv p.toMeasure q.toMeasure := by
  rw [totalVariation_bool_eq_abs_sub, sq_abs]
  exact ofReal_two_mul_bool_mass_sub_sq_le_klDiv p q

/-! ## Canonical finite-PMF Pinsker inequality -/

/--
Pinsker's inequality in nats: twice the square of the half-L1 total variation
is at most KL divergence. The inequality uses canonical `ENNReal` KL and
includes singular support and infinite divergence without additional guards.
-/
theorem ofReal_two_mul_totalVariation_sq_le_klDiv
    {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) :
    ENNReal.ofReal (2 * PMF.totalVariation p q ^ 2) ≤
      InformationTheory.klDiv p.toMeasure q.toMeasure := by
  classical
  let A : Set α := {a | (q a).toReal ≤ (p a).toReal}
  let b : α → Bool := fun a => if a ∈ A then true else false
  have hpre : b ⁻¹' ({true} : Set Bool) = A := by
    ext a
    by_cases ha : a ∈ A <;> simp [b, ha]
  have hgap : ((p.map b).toOuterMeasure {true}).toReal -
      ((q.map b).toOuterMeasure {true}).toReal = PMF.totalVariation p q := by
    rw [PMF.toOuterMeasure_map_apply, PMF.toOuterMeasure_map_apply, hpre]
    exact (PMF.totalVariation_eq_toOuterMeasure_sub p q).symm
  have htv : PMF.totalVariation (p.map b) (q.map b) = PMF.totalVariation p q := by
    apply le_antisymm
    · exact PMF.totalVariation_map_le p q b
    · have h := PMF.abs_toOuterMeasure_sub_le_totalVariation (p.map b) (q.map b) {true}
      rwa [hgap, abs_of_nonneg (PMF.totalVariation_nonneg p q)] at h
  calc
    _ = ENNReal.ofReal (2 * PMF.totalVariation (p.map b) (q.map b) ^ 2) := by rw [htv]
    _ ≤ InformationTheory.klDiv (p.map b).toMeasure (q.map b).toMeasure :=
      ofReal_two_mul_totalVariation_bool_sq_le_klDiv _ _
    _ ≤ _ := klDiv_map_le p q b

/-! ## Real-valued bounds under support inclusion -/

/--
Real-valued Pinsker's inequality in nats, under support inclusion.
The support guard ensures KL is finite before converting it with `ENNReal.toReal`.
-/
theorem two_mul_totalVariation_sq_le_toReal_klDiv
    {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) (h : p.support ⊆ q.support) :
    2 * PMF.totalVariation p q ^ 2 ≤
      (InformationTheory.klDiv p.toMeasure q.toMeasure).toReal := by
  have hfin : InformationTheory.klDiv p.toMeasure q.toMeasure ≠ ⊤ :=
    (klDiv_pmf_ne_top_iff_support_subset p q).2 h
  exact (ENNReal.ofReal_le_iff_le_toReal hfin).1
    (ofReal_two_mul_totalVariation_sq_le_klDiv p q)

/--
Total variation is at most the square root of half the Real-valued KL divergence
in nats. Support inclusion excludes infinite KL, whose `ENNReal.toReal` is zero.
-/
theorem totalVariation_le_sqrt_toReal_klDiv
    {α : Type u} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) (h : p.support ⊆ q.support) :
    PMF.totalVariation p q ≤
      Real.sqrt ((InformationTheory.klDiv p.toMeasure q.toMeasure).toReal / 2) := by
  apply Real.le_sqrt_of_sq_le
  linarith [two_mul_totalVariation_sq_le_toReal_klDiv p q h]

/-! ## Quantitative independence -/

universe v

-- Establish finite KL from actual joint-to-product absolute continuity before
-- using the Real-valued mutual-information bridge.
private theorem klDiv_joint_indepProd_marginals_ne_top
    {α : Type u} {β : Type v} [Finite α] [Finite β]
    [MeasurableSpace (α × β)] [MeasurableSingletonClass (α × β)]
    (p : PMF (α × β)) :
    InformationTheory.klDiv p.toMeasure
      (indepProd (fstMarginal p) (sndMarginal p)).toMeasure ≠ ⊤ := by
  apply (klDiv_pmf_ne_top_iff_support_subset p
    (indepProd (fstMarginal p) (sndMarginal p))).2
  exact (toMeasure_absolutelyContinuous_iff_support_subset p
    (indepProd (fstMarginal p) (sndMarginal p))).1
    (joint_toMeasure_absolutelyContinuous_indepProd_marginals p)

/--
Mutual information in nats bounds twice the squared total variation from the
product of the joint law's marginals. Joint-to-product KL is always finite on
finite alphabets, including when some marginal masses vanish.
-/
theorem two_mul_totalVariation_sq_le_mutualInfo
    {α : Type u} {β : Type v} [Fintype α] [Fintype β]
    (p : PMF (α × β)) :
    2 * PMF.totalVariation p (indepProd (fstMarginal p) (sndMarginal p)) ^ 2 ≤
      mutualInfo p := by
  let : MeasurableSpace (α × β) := ⊤
  have : MeasurableSingletonClass (α × β) := ⟨fun _ => trivial⟩
  have hsupport := (klDiv_pmf_ne_top_iff_support_subset p
    (indepProd (fstMarginal p) (sndMarginal p))).1
    (klDiv_joint_indepProd_marginals_ne_top p)
  rw [mutualInfo_eq_toReal_klDiv_joint_indepProd]
  exact two_mul_totalVariation_sq_le_toReal_klDiv p _ hsupport

/--
A joint law's total variation from the product of its marginals is at most
the square root of half its mutual information in nats. No support or
measurable-space assumptions are needed beyond the finite alphabets.
-/
theorem totalVariation_le_sqrt_mutualInfo
    {α : Type u} {β : Type v} [Fintype α] [Fintype β]
    (p : PMF (α × β)) :
    PMF.totalVariation p (indepProd (fstMarginal p) (sndMarginal p)) ≤
      Real.sqrt (mutualInfo p / 2) := by
  let : MeasurableSpace (α × β) := ⊤
  have : MeasurableSingletonClass (α × β) := ⟨fun _ => trivial⟩
  have hsupport := (klDiv_pmf_ne_top_iff_support_subset p
    (indepProd (fstMarginal p) (sndMarginal p))).1
    (klDiv_joint_indepProd_marginals_ne_top p)
  rw [mutualInfo_eq_toReal_klDiv_joint_indepProd]
  exact totalVariation_le_sqrt_toReal_klDiv p _ hsupport

end

end Shannon
end LeanInfoTheory
