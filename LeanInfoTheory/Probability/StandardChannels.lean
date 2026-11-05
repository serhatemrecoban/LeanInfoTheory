/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.FiniteMixture

/-!
# Standard finite channels

The binary symmetric channel flips its Boolean input with probability `ε` and
retains it with probability `1 - ε`. The existing binary mixture places weight
`ε` on its first component. Both deterministic endpoints are included.

The binary erasure channel uses `none` for erasure and `some a` for the
transmitted input. Erasure has probability `ε`, including both endpoints.
-/

namespace PMF

/-- The binary symmetric channel with crossover probability `ε` in `[0, 1]`.
Its first mixture branch flips the input and has weight `ε`. -/
noncomputable def binarySymmetricChannel (ε : NNReal) (hε : ε ≤ 1)
    (a : Bool) : PMF Bool :=
  binaryMixture ε hε (PMF.pure (!a)) (PMF.pure a)

/-- The binary erasure channel with erasure probability `ε` in `[0, 1]`.
Its first mixture branch erases the input and has weight `ε`. -/
noncomputable def binaryErasureChannel (ε : NNReal) (hε : ε ≤ 1)
    (a : Bool) : PMF (Option Bool) :=
  binaryMixture ε hε (PMF.pure none) (PMF.pure (some a))

end PMF
