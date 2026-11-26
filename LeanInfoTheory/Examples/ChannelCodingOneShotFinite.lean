/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCodingOneShot
import LeanInfoTheory.Shannon.IidInformationDensity
import LeanInfoTheory.Shannon.CodingRate

/-!
# One-shot codes at a rounded message budget

At each given length, the supported threshold code accepts an upper bound on the
miss under the iid-input joint law. The second caller identifies that same miss
as the quantity controlled by iid information-density concentration.
-/

namespace LeanInfoTheory.Examples.ChannelCodingOneShotFinite

open LeanInfoTheory.Shannon

universe u v

variable {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] (p : PMF X) (W : X → PMF Y)

private noncomputable abbrev miss (n : ℕ) (s : ℝ) : ℝ :=
  ((PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)).toOuterMeasure
    (infoDensityThresholdEvent (PMF.iid p n) (PMF.memorylessChannel W n) ((n : ℝ) * s))ᶜ).toReal

example (n : ℕ) (R s μ : ℝ) (hmiss : miss p W n s ≤ μ) :
    ∃ c : BlockChannelCode X Y n (roundedMessageSize n R),
      c.encoder ∈ (PMF.iid (PMF.iid p n) (roundedMessageSize n R)).support ∧
      c = BlockChannelCode.ofAcceptanceEvent c.encoder
        (infoDensityThresholdEvent (PMF.iid p n) (PMF.memorylessChannel W n) ((n : ℝ) * s))
        (roundedMessageSize_bounds n R).1 ∧
      c.errorProbability W (roundedMessageSize_bounds n R).1 ≤
        μ + ((roundedMessageSize n R : ℝ) - 1) * Real.exp (-((n : ℝ) * s)) := by
  obtain ⟨c, hsupp, hdecoder, herror⟩ :=
    exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold
      (q := PMF.iid p n) (W := W) (t := (n : ℝ) * s) (hM := (roundedMessageSize_bounds n R).1)
  exact ⟨c, hsupp, hdecoder, herror.trans (add_le_add hmiss le_rfl)⟩

example {s : ℝ} (hs : s < mutualInfo (PMF.channelJoint p W)) :
    Filter.Tendsto (fun n : ℕ => miss p W n s) Filter.atTop (nhds 0) :=
  tendsto_prob_infoDensityThresholdEvent_iid_compl p W hs

end LeanInfoTheory.Examples.ChannelCodingOneShotFinite
