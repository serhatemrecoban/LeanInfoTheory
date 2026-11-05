/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.Continuity

/-!
# Coupling budgets and finite entropy continuity

A supplied coupling's actual disagreement probability controls entropy through
the capped continuity bound. A second application obtains a coupling attaining
total variation, including the zero and unit distance cases.
-/

namespace Consumer.CouplingContinuity

open LeanInfoTheory.Shannon

universe u

example {A : Type u} [Fintype A] (p q : PMF A)
    (joint : PMF (A × A)) (hj : PMF.IsCoupling joint p q)
    {ε : ℝ}
    (he : (joint.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal ≤ ε) :
    |entropy p - entropy q| ≤
      entropyContinuityBound (Fintype.card A) ε := by
  exact abs_entropy_sub_le_entropyContinuityBound p q
    (hj.totalVariation_le.trans he)

example {A : Type u} [Fintype A] (p q : PMF A) :
    ∃ joint : PMF (A × A),
      PMF.IsCoupling joint p q ∧
      (joint.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal =
        PMF.totalVariation p q := by
  exact ⟨PMF.maximalCoupling p q,
    PMF.isCoupling_maximalCoupling p q,
    PMF.maximalCoupling_toOuterMeasure_ne_toReal p q⟩

end Consumer.CouplingContinuity
