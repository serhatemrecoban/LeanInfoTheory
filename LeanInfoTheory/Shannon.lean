/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory
import LeanInfoTheory.Probability.Coupling
import LeanInfoTheory.Probability.FiniteProduct
import LeanInfoTheory.Probability.FiniteTopology
import LeanInfoTheory.Probability.Iid
import LeanInfoTheory.Probability.ProductChannel
import LeanInfoTheory.Probability.TotalVariation
import LeanInfoTheory.Probability.TotalVariationTopology
import LeanInfoTheory.Shannon.Continuity
import LeanInfoTheory.Shannon.Fano
import LeanInfoTheory.Shannon.SemanticBridge
import LeanInfoTheory.Shannon.Topology
import LeanInfoTheory.Shannon.TypicalSet
import LeanInfoTheory.Shannon.Units

/-!
# Complete finite Shannon information-theory import

This import-only umbrella gathers the complete supported mathematical stack for
LeanInfoTheory `0.1.x`. It subsumes the lightweight `LeanInfoTheory` root and
adds the focused finite-channel, entropy-bound, Fano, finite-family, semantic,
KL, Markov, gluing, sufficiency, convexity, total-variation, coupling, finite-simplex
topology, finite dependent products, Fin block transports and iid laws, finite
product-channel rows and restrictions, TV
convergence, quantitative entropy
continuity, qualitative information continuity, and unit-conversion modules.

It deliberately excludes `LeanInfoTheory.Basic`, `LeanInfoTheory.Examples`, and
`LeanInfoTheory.MathlibFragments`, which are non-stable development, regression,
and reference anchors rather than public mathematical API.
-/
