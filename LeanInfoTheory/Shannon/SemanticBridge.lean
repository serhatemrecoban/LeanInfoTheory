/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.InformationMeasures
import Mathlib.InformationTheory.KullbackLeibler.Basic
import Mathlib.InformationTheory.KullbackLeibler.ChainRule
import Mathlib.Probability.ProbabilityMassFunction.Integrals

/-!
# Semantic bridge for finite Shannon information measures

This file is the intended home for bridge theorems connecting the lightweight
finite Shannon API in `LeanInfoTheory.Shannon.InfoMeasures` to mathlib's
measure-theoretic probability and information-theory APIs.

The core finite Shannon files intentionally define entropy and entropy-derived
quantities by finite sums and entropy identities. That is the right shape for
entropy-expression certificates and for early finite-PMF development. The
semantic bridge layer proves that these definitions agree with the
textbook/measure-theoretic semantics.

- `entropy` as expected self-information over `PMF.toMeasure`;
- future: `condEntropy` as the expected entropy of conditional laws;
- future: `mutualInfo` as a KL divergence from the joint law to the product of its
  marginals;
- future: `condMutualInfo` as either a KL chain-rule expression or an averaged
  conditional KL divergence.

Keeping this file separate prevents KL divergence, kernels, and related
measure-theoretic imports from becoming dependencies of the lightweight finite
Shannon API. Conditional-probability imports should be added here when the
first conditional-law theorem actually needs them.
-/

namespace LeanInfoTheory
namespace Shannon

open MeasureTheory
open scoped BigOperators

noncomputable section

universe u

/--
Self-information of an atom under a finite PMF, in nats.

It is `-log p(a)` when the real mass of `a` is nonzero, and `0` on zero-mass
atoms. The zero branch is the usual entropy convention that zero-probability
outcomes contribute no expected information.
-/
def selfInfo {alpha : Type u} (p : PMF alpha) (a : alpha) : Real :=
  if (p a).toReal = 0 then 0 else -Real.log (p a).toReal

/-- A zero-mass atom has zero self-information by convention. -/
@[simp]
theorem selfInfo_of_toReal_eq_zero {alpha : Type u} (p : PMF alpha) {a : alpha}
    (ha : (p a).toReal = 0) :
    selfInfo p a = 0 := by
  simp [selfInfo, ha]

/-- A nonzero-mass atom has self-information `-log p(a)`. -/
theorem selfInfo_of_toReal_ne_zero {alpha : Type u} (p : PMF alpha) {a : alpha}
    (ha : (p a).toReal ≠ 0) :
    selfInfo p a = -Real.log (p a).toReal := by
  simp [selfInfo, ha]

/--
Multiplying self-information by the atom mass recovers the `Real.negMulLog`
entropy summand.
-/
theorem toReal_mul_selfInfo {alpha : Type u} (p : PMF alpha) (a : alpha) :
    (p a).toReal * selfInfo p a = Real.negMulLog (p a).toReal := by
  by_cases ha : (p a).toReal = 0
  · simp [selfInfo, ha]
  · simp [selfInfo, ha, Real.negMulLog]

/--
Semantic bridge for finite entropy: the finite-sum definition of
`Shannon.entropy` is the expected self-information with respect to
`PMF.toMeasure`.

Informally, this is the textbook identity `H(P) = E[-log P(X)]`, with the
zero-mass convention handled by `selfInfo`.
-/
theorem entropy_eq_integral_selfInfo {alpha : Type u}
    [Fintype alpha] [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    (p : PMF alpha) :
    entropy p = ∫ a, selfInfo p a ∂p.toMeasure := by
  rw [entropy_eq_sum, PMF.integral_eq_sum]
  exact Finset.sum_congr rfl fun a _ha => by
    rw [smul_eq_mul, toReal_mul_selfInfo]

end

end Shannon
end LeanInfoTheory
