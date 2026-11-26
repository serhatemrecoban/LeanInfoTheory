/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceChannelSeparation
import LeanInfoTheory.Shannon.StandardChannelCapacity
import LeanInfoTheory.Examples.StochasticChannels

/-!
# Transmitting a biased source over a binary erasure channel

The true symbol has probability three quarters. Erasing one eighth of
channel symbols leaves a strict entropy–capacity gap in nats.
-/

namespace LeanInfoTheory.Examples.SourceChannelSeparation

open LeanInfoTheory.Shannon Filter
open StochasticChannels (biasedLaw)

private theorem source_masses :
    (biasedLaw false).toReal = 1 / 4 ∧ (biasedLaw true).toReal = 3 / 4 := by
  have htrue : (biasedLaw true).toReal = 3 / 4 := by
    norm_num [biasedLaw, PMF.ofFintype_apply]
  have hsum := PMF.sum_toReal biasedLaw
  rw [Fintype.sum_bool, htrue] at hsum
  exact ⟨by linarith, htrue⟩

private theorem eighth_le_one : (1 / 8 : NNReal) ≤ 1 := by
  change (1 / 8 : ℝ) ≤ 1
  norm_num

private noncomputable abbrev channel :=
  PMF.binaryErasureChannel (1 / 8) eighth_le_one

example (b : Bool) : (channel b none).toReal = 1 / 8 := by
  norm_num [channel, PMF.binaryErasureChannel, PMF.binaryMixture_apply, PMF.pure_apply,
    (Option.some_ne_none b).symm, ENNReal.toReal_inv]

private theorem biased_entropy : entropy biasedLaw = 2 * Real.log 2 - (3 / 4) * Real.log 3 := by
  rw [entropy_bool, source_masses.2, Real.binEntropy,
    show 1 - (3 / 4 : ℝ) = 1 / 4 by norm_num, Real.log_inv, Real.log_inv,
    Real.log_div (by norm_num : (3 : ℝ) ≠ 0) (by norm_num : (4 : ℝ) ≠ 0),
    Real.log_div (by norm_num : (1 : ℝ) ≠ 0) (by norm_num : (4 : ℝ) ≠ 0), Real.log_one,
    show (4 : ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
  ring

private theorem erasure_capacity : channelCapacity channel = (7 / 8) * Real.log 2 := by
  rw [channel, channelCapacity_binaryErasureChannel]
  norm_num

private theorem gap : channelCapacity channel - entropy biasedLaw = (3 / 8) * Real.log (9 / 8) := by
  rw [biased_entropy, erasure_capacity,
    Real.log_div (by norm_num : (9 : ℝ) ≠ 0) (by norm_num : (8 : ℝ) ≠ 0),
    show (9 : ℝ) = 3 ^ 2 by norm_num, show (8 : ℝ) = 2 ^ 3 by norm_num,
    Real.log_pow, Real.log_pow]
  ring

/-- One pair of constructed families eventually meets every positive error
tolerance under the joint law of the biased source and the erasure channel. -/
example :
    ∃ (E : ∀ n : ℕ, (Fin n → Bool) → (Fin n → Bool))
      (D : ∀ n : ℕ, (Fin n → Option Bool) → (Fin n → Bool)),
      ∀ ε : ℝ, 0 < ε → ∀ᶠ n in atTop,
        sourceChannelErrorProbability biasedLaw channel n (E n) (D n) < ε := by
  have strict : entropy biasedLaw < channelCapacity channel := by
    apply sub_pos.mp
    rw [gap]
    exact mul_pos (by norm_num) (Real.log_pos (by norm_num))
  obtain ⟨E, D, hlimit⟩ :=
    exists_sourceChannelCode_tendsto_errorProbability_zero biasedLaw channel strict
  exact ⟨E, D, fun _ hε => hlimit.eventually (gt_mem_nhds hε)⟩

end LeanInfoTheory.Examples.SourceChannelSeparation
