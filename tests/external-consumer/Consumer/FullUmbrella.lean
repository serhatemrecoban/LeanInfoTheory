/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon

/-!
# Repeated standard-channel bounds through the full umbrella

An arbitrary, possibly correlated block input is bounded by repeated binary
symmetric information capacity. The composition includes blocklength zero.
-/

namespace Consumer.FullUmbrella

open LeanInfoTheory.Shannon

example (ε : NNReal) (hε : ε ≤ 1)
    (n : ℕ) (q : PMF (Fin n → Bool)) :
    mutualInfo (PMF.channelJoint q
      (PMF.memorylessChannel (PMF.binarySymmetricChannel ε hε) n)) ≤
      (n : ℝ) * (Real.log 2 - Real.binEntropy (ε : ℝ)) := by
  simpa only [channelCapacity_binarySymmetricChannel] using
    mutualInfo_channelJoint_memorylessChannel_le
      (PMF.binarySymmetricChannel ε hε) n q

end Consumer.FullUmbrella
