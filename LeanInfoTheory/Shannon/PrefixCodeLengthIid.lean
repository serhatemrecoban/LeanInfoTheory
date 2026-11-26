/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.PrefixCodeLength
import LeanInfoTheory.Shannon.SemanticBridge.FiniteProduct

/-!
# Binary prefix coding of iid blocks

An optimal binary prefix code on the support of the block law has less than one bit
of overhead per block. Dividing by the positive block length gives the per-symbol bounds.
-/

namespace LeanInfoTheory.Shannon

universe u

/-- For an iid block of positive length `n`, the optimal mean length per source symbol
is at least the entropy in bits and is strictly below that entropy plus `1 / n` bits. -/
theorem optimalPrefixLength_iid_div_bounds {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) (hn : 0 < n) :
    natsToBits (entropy p) ≤ optimalPrefixLength (PMF.iid p n) / (n : ℝ) ∧
      optimalPrefixLength (PMF.iid p n) / (n : ℝ) <
        natsToBits (entropy p) + 1 / (n : ℝ) := by
  have hn' : 0 < (n : ℝ) := by exact_mod_cast hn
  have hbits : natsToBits (entropy (PMF.iid p n)) = (n : ℝ) * natsToBits (entropy p) := by
    rw [entropy_iid]
    exact mul_div_assoc _ _ _
  obtain ⟨hlower, hupper⟩ := optimalPrefixLength_bounds (PMF.iid p n)
  rw [hbits] at hlower hupper
  constructor
  · rwa [le_div_iff₀ hn', mul_comm]
  · rwa [div_lt_iff₀ hn', add_mul, div_mul_cancel₀ _ hn'.ne', mul_comm (natsToBits (entropy p))]

end LeanInfoTheory.Shannon
