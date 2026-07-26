/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.Entropy
import Mathlib.Analysis.SpecialFunctions.BinaryEntropy

/-!
# Boolean entropy

This opt-in module identifies the project's finite Shannon entropy of a
Boolean PMF with mathlib's `Real.binEntropy`. Both sides use natural
logarithms, so the identity is in nats.
-/

namespace LeanInfoTheory
namespace Shannon

open scoped BigOperators

noncomputable section

/--
The entropy of a Boolean PMF is the binary entropy of its `true` mass.

The identity includes the endpoint laws without separate positivity
assumptions.
-/
theorem entropy_bool (p : PMF Bool) :
    entropy p = Real.binEntropy (p true).toReal := by
  have hfalse : (p false).toReal = 1 - (p true).toReal := by
    have hmass := PMF.sum_toReal p
    rw [Fintype.sum_bool] at hmass
    linarith
  rw [entropy_eq_sum, Fintype.sum_bool,
    Real.binEntropy_eq_negMulLog_add_negMulLog_one_sub, hfalse]

end

end Shannon
end LeanInfoTheory
