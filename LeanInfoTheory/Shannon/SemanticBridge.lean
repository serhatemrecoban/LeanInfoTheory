/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.Theorems
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
- `indepProd` as the independent product law of two PMFs, together with
  product-measure and joint-law absolute-continuity bridge lemmas;
- finite-sum formulas rewriting `mutualInfo` as
  `sum p(a,b) log (p(a,b) / (p_A(a) p_B(b)))`;
- `mutualInfo` as KL divergence from the joint law to the product of its
  marginals;
- `condFstGivenSnd`, the nonzero-mass conditional law `P_{A | B=b}`;
- `condEntropy` as the expected entropy of these conditional laws;
- `condMutualInfo` as expected fiber mutual information and as an averaged
  conditional KL divergence;
- semantic theorem API: `0 <= I(A;B)`, `0 <= I(A;B|C)`, and the chain rule
  `I(A;B,C) = I(A;C) + I(A;B|C)`.

Keeping this file separate prevents KL divergence, kernels, and related
measure-theoretic imports from becoming dependencies of the lightweight finite
Shannon API. More conditional-probability and kernel imports should still stay
in this bridge layer or its subfiles, rather than in the core finite Shannon
API.
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
