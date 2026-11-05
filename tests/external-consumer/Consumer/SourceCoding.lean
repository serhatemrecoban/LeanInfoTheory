/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceCodingAsymptotic

/-!
# One source-code family between asymptotic rate bounds

The public above-entropy construction supplies one positive-budget family.
Its actual vanishing iid error then feeds the general converse, preserving
the same budgets and codes for every positive lower-rate tolerance.
-/

namespace Consumer.SourceCoding

open Filter Topology LeanInfoTheory.Shannon

universe u

example {A : Type u} [Fintype A] (p : PMF A)
    {R : ℝ} (hR : entropy p < R) :
    ∃ M : ℕ → ℕ, (∀ n, 1 ≤ M n) ∧
      ∃ c : ∀ n, BlockSourceCode A n (M n),
        Tendsto (fun n => (c n).errorProbability (PMF.iid p n))
          atTop (nhds 0) ∧
        ∀ δ : ℝ, 0 < δ →
          ∀ᶠ n in atTop,
            entropy p - δ ≤ codeRate n (M n) ∧
            codeRate n (M n) ≤ R := by
  obtain ⟨M, hM, c, he, hr⟩ :=
    exists_blockSourceCode_tendsto_errorProbability_zero p hR
  refine ⟨M, hM, c, he, ?_⟩
  intro δ hδ
  exact (eventually_entropy_sub_le_codeRate_of_tendsto_errorProbability_zero
    p M hM c he hδ).and hr

end Consumer.SourceCoding
