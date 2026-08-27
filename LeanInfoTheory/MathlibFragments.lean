/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import Mathlib.Analysis.SpecialFunctions.BinaryEntropy
import Mathlib.InformationTheory.Coding.KraftMcMillan
import Mathlib.InformationTheory.KullbackLeibler.Basic
import Mathlib.InformationTheory.KullbackLeibler.ChainRule
import Mathlib.Probability.ProbabilityMassFunction.Constructions

/-!
# Mathlib information-theory fragments

This non-stable reference-anchor module intentionally gathers mathlib material
that the project may build on later. It is not imported by either public
mathematical umbrella; import it explicitly when working on bridge or
coding-theory files that need these anchors.

Important anchors include:

- `Real.binEntropy` and `Real.qaryEntropy`;
- `InformationTheory.klDiv` and KL chain rules;
- mathlib's coding-theory files, including Kraft-McMillan;
- `PMF` constructions such as `PMF.map`, `PMF.pure`, `PMF.bind`, and
  `PMF.ofFintype`.
-/

namespace LeanInfoTheory

/-!
This namespace is intentionally empty for now. The imports above are a living
checklist of upstream APIs we expect to connect to as the library grows.
-/

end LeanInfoTheory
