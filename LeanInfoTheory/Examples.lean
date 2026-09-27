/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Examples.CommonCause
import LeanInfoTheory.Examples.ConditionalKL
import LeanInfoTheory.Examples.Convexity
import LeanInfoTheory.Examples.Coupling
import LeanInfoTheory.Examples.CouplingFano
import LeanInfoTheory.Examples.Fano
import LeanInfoTheory.Examples.FiniteFamily
import LeanInfoTheory.Examples.IndependenceProcessing
import LeanInfoTheory.Examples.InformationDecomposition
import LeanInfoTheory.Examples.KLTop
import LeanInfoTheory.Examples.StochasticChannels
import LeanInfoTheory.Examples.SufficientStatistics
import LeanInfoTheory.Examples.SupportSensitive
import LeanInfoTheory.Examples.TotalVariation
import LeanInfoTheory.Examples.TotalVariationChannels
import LeanInfoTheory.Examples.Units

/-!
# Examples aggregate

This import-only aggregate gathers the separately usable common-cause,
conditional-KL, convexity, coupling, Fano, finite-family, independence-processing,
information-decomposition, infinite-KL, stochastic-channel, sufficient-statistics,
support-sensitive, and finite total-variation examples, including integrated
Boolean families, exact event reductions, deterministic and stochastic processing,
and joint projections. Coupling consumers check generic independent and diagonal
laws, coordinate swaps, empty alphabets, and the finite coupling inequality,
including a strict independent-versus-diagonal comparison and the actual
common-mass constructor's ordered marginals, exact disagreement and attained
optimality for sparse and degenerate laws. A separate semantic consumer applies
Fano to that actual witness and its coordinate swap with exact TV error, including
equal and subsingleton laws, and reuses independent-product measure semantics.
It also includes representative
arbitrary-base, bits, and guarded real-KL unit conversions. It remains outside
both public mathematical umbrellas. The examples are maintained regression
consumers, not stable library API for the `0.1.x`
series.
-/
