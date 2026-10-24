/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.StandardChannels

/-!
# Raw binary symmetric and erasure channel consumers

These private probability-only checks fix the crossover and retention weights
and identify the two deterministic BSC endpoints. At crossover one half,
both rows are the same fair Boolean law. BEC checks retain erasure, transmission
and absent-symbol masses, including zero- and full-erasure endpoints.
-/

namespace LeanInfoTheory.Examples.StandardChannels

noncomputable section

private theorem crossover_mass (ε : NNReal) (hε : ε ≤ 1) (a : Bool) :
    PMF.binarySymmetricChannel ε hε a (!a) = (ε : ENNReal) := by
  cases a <;>
    simp [PMF.binarySymmetricChannel, PMF.binaryMixture_apply, PMF.pure_apply]

private theorem retention_mass (ε : NNReal) (hε : ε ≤ 1) (a : Bool) :
    PMF.binarySymmetricChannel ε hε a a = ((1 - ε : NNReal) : ENNReal) := by
  cases a <;>
    simp [PMF.binarySymmetricChannel, PMF.binaryMixture_apply, PMF.pure_apply]

private theorem zero_crossover :
    PMF.binarySymmetricChannel 0 (by norm_num) = fun a => PMF.pure a := by
  funext a
  simp [PMF.binarySymmetricChannel]

private theorem full_crossover :
    PMF.binarySymmetricChannel 1 (by norm_num) = fun a => PMF.pure (!a) := by
  funext a
  simp [PMF.binarySymmetricChannel]

private theorem half_crossover_constant :
    PMF.binarySymmetricChannel (1 / 2) (by norm_num) =
      fun _ => PMF.binaryMixture (1 / 2) (by norm_num)
        (PMF.pure true) (PMF.pure false) := by
  funext a
  apply PMF.ext
  intro b
  cases a <;> cases b <;>
    norm_num [PMF.binarySymmetricChannel, PMF.binaryMixture_apply, PMF.pure_apply,
      ENNReal.coe_sub]

/-! ## Binary erasure channel masses and endpoints -/

private theorem erasure_mass (ε : NNReal) (hε : ε ≤ 1) (a : Bool) :
    PMF.binaryErasureChannel ε hε a none = (ε : ENNReal) := by
  simp [PMF.binaryErasureChannel, PMF.binaryMixture_apply, PMF.pure_apply]

private theorem transmission_mass (ε : NNReal) (hε : ε ≤ 1) (a : Bool) :
    PMF.binaryErasureChannel ε hε a (some a) = ((1 - ε : NNReal) : ENNReal) := by
  simp [PMF.binaryErasureChannel, PMF.binaryMixture_apply, PMF.pure_apply]

private theorem absent_symbol_mass (ε : NNReal) (hε : ε ≤ 1) (a : Bool) :
    PMF.binaryErasureChannel ε hε a (some (!a)) = 0 := by
  cases a <;>
    simp [PMF.binaryErasureChannel, PMF.binaryMixture_apply, PMF.pure_apply]

private theorem zero_erasure :
    PMF.binaryErasureChannel 0 (by norm_num) = fun a => PMF.pure (some a) := by
  funext a
  simp [PMF.binaryErasureChannel]

private theorem full_erasure :
    PMF.binaryErasureChannel 1 (by norm_num) = fun _ => PMF.pure none := by
  funext a
  simp [PMF.binaryErasureChannel]

end

end LeanInfoTheory.Examples.StandardChannels
