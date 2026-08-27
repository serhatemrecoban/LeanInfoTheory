/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory
import LeanInfoTheory.Shannon.Fano
import LeanInfoTheory.Shannon.SemanticBridge
import LeanInfoTheory.Shannon.Units

/-!
# Complete finite Shannon information-theory import

This import-only umbrella gathers the complete supported mathematical stack for
LeanInfoTheory `0.1.x`. It subsumes the lightweight `LeanInfoTheory` root and
adds the focused finite-channel, entropy-bound, Fano, finite-family, semantic,
KL, Markov, sufficiency, convexity, and unit-conversion modules.

It deliberately excludes `LeanInfoTheory.Basic`, `LeanInfoTheory.Examples`, and
`LeanInfoTheory.MathlibFragments`, which are non-stable development, regression,
and reference anchors rather than public mathematical API.
-/
