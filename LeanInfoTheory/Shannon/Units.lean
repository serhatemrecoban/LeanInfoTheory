/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.InfoMeasures
import Mathlib.Analysis.SpecialFunctions.Log.Base

/-!
# Information units and logarithm-base conversion

The canonical finite information measures in this project are real-valued and
measured in nats. This opt-in module relates division by `Real.log b` to the
usual formulas written with `Real.logb b`; it does not introduce parallel
base-indexed definitions of entropy, conditional entropy, mutual information,
or conditional mutual information.

For the usual information-theoretic interpretation, logarithm bases are
greater than one. The summand and entropy identities are algebraically valid
for every real base because mathlib's logarithms and division are total.
-/

namespace LeanInfoTheory
namespace Shannon

open scoped BigOperators

noncomputable section

universe u v

/--
Change a real quantity from logarithm base `b` to logarithm base `c`.

If `x` is measured in nats, then `x / Real.log b` is its value in base-`b`
units. Thus the theorem is the usual change-of-base identity
`x_c = log_c(b) * x_b`.
-/
theorem div_log_change_base (x b c : Real) (hb : 1 < b) (hc : 1 < c) :
    x / Real.log c = Real.logb c b * (x / Real.log b) := by
  rw [← Real.log_div_log]
  field_simp [ne_of_gt (Real.log_pos hb), ne_of_gt (Real.log_pos hc)]

/-- A `Real.negMulLog` summand in base-`b` units. -/
theorem negMulLog_div_log (x b : Real) :
    Real.negMulLog x / Real.log b = -x * Real.logb b x := by
  rw [Real.negMulLog, ← Real.log_div_log]
  ring

/--
Finite PMF entropy converted from nats to base-`b` units is the usual
`-sum_x p(x) log_b p(x)` formula.
-/
theorem entropy_div_log {alpha : Type u} [Fintype alpha]
    (p : PMF alpha) (b : Real) :
    entropy p / Real.log b =
      ∑ a, -(p a).toReal * Real.logb b (p a).toReal := by
  rw [entropy_eq_sum, Finset.sum_div]
  apply Finset.sum_congr rfl
  intro a _ha
  exact negMulLog_div_log (p a).toReal b

/--
Finite-valued random-variable entropy converted from nats to base-`b` units.
-/
theorem entropyOf_div_log
    {omega : Type u} {alpha : Type v} [Fintype alpha]
    (p : PMF omega) (X : omega -> alpha) (b : Real) :
    entropyOf p X / Real.log b =
      ∑ a, -(p.map X a).toReal * Real.logb b (p.map X a).toReal := by
  exact entropy_div_log (p.map X) b

end

end Shannon
end LeanInfoTheory
