/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.StandardChannelCapacity

/-!
# Attained information capacity and a standard channel

One maximizing input dominates every competing finite input law. The uniform
Boolean input attains the closed-interval binary symmetric channel formula
in canonical nats; no uniqueness or operational coding assertion is made.
-/

namespace Consumer.Capacity

open LeanInfoTheory.Shannon

universe u v

example {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B] (W : A → PMF B) :
    ∃ p : PMF A,
      mutualInfo (PMF.channelJoint p W) = channelCapacity W ∧
      ∀ q : PMF A,
        mutualInfo (PMF.channelJoint q W) ≤
          mutualInfo (PMF.channelJoint p W) := by
  obtain ⟨p, hp⟩ := exists_mutualInfo_channelJoint_eq_channelCapacity W
  refine ⟨p, hp, ?_⟩
  intro q
  rw [hp]
  exact mutualInfo_channelJoint_le_channelCapacity q W

example (ε : NNReal) (hε : ε ≤ 1) :
    mutualInfo (PMF.channelJoint (PMF.uniformOfFintype Bool)
      (PMF.binarySymmetricChannel ε hε)) =
        Real.log 2 - Real.binEntropy (ε : ℝ) := by
  exact (mutualInfo_channelJoint_binarySymmetricChannel_uniformOfFintype ε hε).trans
    (channelCapacity_binarySymmetricChannel ε hε)

end Consumer.Capacity
