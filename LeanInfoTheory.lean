/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.Finite
import LeanInfoTheory.InformationMeasures

/-!
# LeanInfoTheory root import

This root module gathers the lightweight project API that should be convenient
for users to import. It includes elementary finite probability and the finite
information-measure re-export, but not heavier theorem files, semantic bridge
files, units, examples, or development/reference modules.

Import these separately when needed:

- `LeanInfoTheory.Shannon.EntropyBounds` for Jensen-based finite entropy
  bounds;
- `LeanInfoTheory.Shannon.Units` for opt-in logarithm-base conversion while
  keeping the canonical information measures in nats;
- `LeanInfoTheory.Shannon.SemanticBridge` for KL/conditional-law bridge work;
- `LeanInfoTheory.Shannon` for the complete supported mathematical stack;
- `LeanInfoTheory.MathlibFragments` for heavier mathlib information-theory and
  coding anchors;
- `LeanInfoTheory.Examples` for maintained examples and regression consumers.
-/
