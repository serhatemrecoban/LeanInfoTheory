/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.Conditional
import LeanInfoTheory.Shannon.SemanticBridge.FiniteSums
import LeanInfoTheory.Shannon.SemanticBridge.Product
import Mathlib.InformationTheory.KullbackLeibler.Basic
import Mathlib.Probability.ProbabilityMassFunction.Integrals

/-!
# KL-divergence bridge for finite Shannon information measures

This file connects the finite PMF definitions in `LeanInfoTheory.Shannon` to
mathlib's measure-theoretic `InformationTheory.klDiv`.

The main theorem is

`mutualInfo_eq_toReal_klDiv_joint_indepProd`:

`I(A;B) = D(P_AB || P_A × P_B)`,

where the product of marginals is represented by the project-local PMF
`indepProd (fstMarginal p) (sndMarginal p)`.
-/

namespace LeanInfoTheory
namespace Shannon

open MeasureTheory
open scoped BigOperators

noncomputable section

universe u v

universe w

-- Every PMF atom is finite as an `ENNReal`; this is used when computing the
-- finite Radon-Nikodym derivative pointwise.
private theorem pmf_apply_ne_top {alpha : Type u} (p : PMF alpha) (a : alpha) :
    p a ≠ ⊤ := by
  exact ne_of_lt ((PMF.coe_le_one (p := p) a).trans_lt ENNReal.one_lt_top)

/--
Countable PMF density formula.

If `p.toMeasure ≪ q.toMeasure`, then `p.toMeasure` is obtained from
`q.toMeasure` by the density `a ↦ p(a) / q(a)`. On atoms with `q(a)=0`,
absolute continuity forces `p(a)=0`, so the formula is still valid.
-/
theorem toMeasure_withDensity_pmf_div {alpha : Type u}
    [Countable alpha] [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    (p q : PMF alpha) (h : p.toMeasure ≪ q.toMeasure) :
    q.toMeasure.withDensity (fun a => p a / q a) = p.toMeasure := by
  classical
  rw [Measure.ext_iff_singleton]
  intro a
  rw [MeasureTheory.withDensity_apply
    (μ := q.toMeasure) (f := fun a => p a / q a)
    (s := ({a} : Set alpha)) (MeasurableSet.singleton a)]
  rw [MeasureTheory.lintegral_singleton]
  rw [PMF.toMeasure_apply_singleton q a (MeasurableSet.singleton a),
    PMF.toMeasure_apply_singleton p a (MeasurableSet.singleton a)]
  by_cases hq : q a = 0
  · have hqmeasure : q.toMeasure ({a} : Set alpha) = 0 := by
      simpa [PMF.toMeasure_apply_singleton q a (MeasurableSet.singleton a)] using hq
    have hpmeasure : p.toMeasure ({a} : Set alpha) = 0 :=
      h hqmeasure
    have hp : p a = 0 := by
      simpa [PMF.toMeasure_apply_singleton p a (MeasurableSet.singleton a)] using hpmeasure
    simp [hq, hp]
  · rw [ENNReal.div_mul_cancel hq (pmf_apply_ne_top q a)]

/--
Finite KL expansion for absolutely continuous PMFs:

`D(P || Q) = sum_a p(a) log (p(a) / q(a))`.

The left-hand side is mathlib's measure-theoretic KL divergence applied to
`PMF.toMeasure`; the right-hand side is the usual finite sum over atoms.
-/
theorem toReal_klDiv_pmf_eq_sum {alpha : Type u}
    [Fintype alpha] [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    (p q : PMF alpha) (h : p.toMeasure ≪ q.toMeasure) :
    (InformationTheory.klDiv p.toMeasure q.toMeasure).toReal =
      ∑ a : alpha, (p a).toReal * Real.log ((p a / q a).toReal) := by
  classical
  have hdensity_meas : Measurable (fun a : alpha => p a / q a) :=
    measurable_of_finite _
  have hwith :
      q.toMeasure.withDensity (fun a : alpha => p a / q a) = p.toMeasure :=
    toMeasure_withDensity_pmf_div p q h
  have hrn_q :
      p.toMeasure.rnDeriv q.toMeasure =ᵐ[q.toMeasure] fun a : alpha => p a / q a := by
    simpa [hwith] using
      (Measure.rnDeriv_withDensity (ν := q.toMeasure) hdensity_meas)
  have hrn_p :
      p.toMeasure.rnDeriv q.toMeasure =ᵐ[p.toMeasure] fun a : alpha => p a / q a :=
    h.ae_eq hrn_q
  have hllr :
      MeasureTheory.llr p.toMeasure q.toMeasure =ᵐ[p.toMeasure]
        fun a : alpha => Real.log ((p a / q a).toReal) := by
    filter_upwards [hrn_p] with a ha
    simp [MeasureTheory.llr_def, ha]
  rw [InformationTheory.toReal_klDiv_of_measure_eq h (by simp)]
  rw [integral_congr_ae hllr]
  rw [PMF.integral_eq_sum]
  apply Finset.sum_congr rfl
  intro a _ha
  rw [smul_eq_mul]

/--
Semantic bridge for finite mutual information:

`I(A;B) = D(P_AB || P_A × P_B)`.

Here `P_A × P_B` is represented by the finite independent-product PMF
`indepProd (fstMarginal p) (sndMarginal p)`. This theorem is the finite
textbook identity connecting the entropy definition of mutual information to
mathlib's measure-theoretic KL divergence.
-/
theorem mutualInfo_eq_toReal_klDiv_joint_indepProd
    {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta]
    [MeasurableSpace (alpha × beta)] [MeasurableSingletonClass (alpha × beta)]
    (p : PMF (alpha × beta)) :
    mutualInfo p =
      (InformationTheory.klDiv p.toMeasure
        (indepProd (fstMarginal p) (sndMarginal p)).toMeasure).toReal := by
  classical
  symm
  rw [toReal_klDiv_pmf_eq_sum
    (p := p) (q := indepProd (fstMarginal p) (sndMarginal p))
    (joint_toMeasure_absolutelyContinuous_indepProd_marginals (p := p))]
  rw [mutualInfo_eq_sum_log_ratio]
  apply Finset.sum_congr rfl
  intro x _hx
  rcases x with ⟨a, b⟩
  simp [ENNReal.toReal_div, ENNReal.toReal_mul]

/--
Product-measure form of the finite mutual-information KL bridge:

`I(A;B) = D(P_AB || P_A.toMeasure.prod P_B.toMeasure)`.
-/
theorem mutualInfo_eq_toReal_klDiv_joint_prod_marginals
    {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta]
    [MeasurableSpace alpha] [MeasurableSpace beta]
    [MeasurableSingletonClass (alpha × beta)]
    (p : PMF (alpha × beta)) :
    mutualInfo p =
      (InformationTheory.klDiv p.toMeasure
        (Measure.prod (fstMarginal p).toMeasure (sndMarginal p).toMeasure)).toReal := by
  rw [← indepProd_toMeasure (p := fstMarginal p) (q := sndMarginal p)]
  exact mutualInfo_eq_toReal_klDiv_joint_indepProd p

/-! ## Averaged conditional KL bridge -/

/--
Fiberwise KL form of conditional mutual information.

This is zero on zero-marginal third-coordinate atoms. On nonzero atoms it is
`D(P_{A,B|C=c} || P_{A|C=c} × P_{B|C=c})`, using the marginals of the
conditional joint law.
-/
def condMutualInfoFstSndGivenThirdKL
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Fintype alpha] [Fintype beta]
    [MeasurableSpace (alpha × beta)] [MeasurableSingletonClass (alpha × beta)]
    (p : PMF (alpha × beta × gamma)) (c : gamma) : Real :=
  if hc : thirdMarginal p c = 0 then
    0
  else
    (InformationTheory.klDiv (condFstSndGivenThird p c hc).toMeasure
      (indepProd
        (fstMarginal (condFstSndGivenThird p c hc))
        (sndMarginal (condFstSndGivenThird p c hc))).toMeasure).toReal

/--
The fiber mutual-information helper agrees with the fiberwise KL expression
`D(P_{A,B|C=c} || P_{A|C=c} × P_{B|C=c})`.
-/
theorem condMutualInfoFstSndGivenThird_eq_KL
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Fintype alpha] [Fintype beta]
    [MeasurableSpace (alpha × beta)] [MeasurableSingletonClass (alpha × beta)]
    (p : PMF (alpha × beta × gamma)) (c : gamma) :
    condMutualInfoFstSndGivenThird p c =
      condMutualInfoFstSndGivenThirdKL p c := by
  by_cases hc : thirdMarginal p c = 0
  · rw [condMutualInfoFstSndGivenThird_of_thirdMarginal_eq_zero p hc]
    rw [condMutualInfoFstSndGivenThirdKL, dif_pos hc]
  · rw [condMutualInfoFstSndGivenThird_of_thirdMarginal_ne_zero p hc]
    rw [condMutualInfoFstSndGivenThirdKL, dif_neg hc]
    exact mutualInfo_eq_toReal_klDiv_joint_indepProd
      (p := condFstSndGivenThird p c hc)

/--
Averaged conditional-KL bridge for finite conditional mutual information:

`I(A;B | C) =
  sum_c P_C(c) D(P_{A,B|C=c} || P_{A|C=c} × P_{B|C=c})`.

Zero-marginal `c` contribute zero by definition of
`condMutualInfoFstSndGivenThirdKL`.
-/
theorem condMutualInfo_eq_sum_thirdMarginal_mul_condMutualInfoFstSndGivenThirdKL
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    [MeasurableSpace (alpha × beta)] [MeasurableSingletonClass (alpha × beta)]
    (p : PMF (alpha × beta × gamma)) :
    condMutualInfo p =
      ∑ c : gamma,
        (thirdMarginal p c).toReal * condMutualInfoFstSndGivenThirdKL p c := by
  rw [condMutualInfo_eq_sum_thirdMarginal_mul_condMutualInfoFstSndGivenThird]
  apply Finset.sum_congr rfl
  intro c _hc
  rw [condMutualInfoFstSndGivenThird_eq_KL]

end

end Shannon
end LeanInfoTheory
