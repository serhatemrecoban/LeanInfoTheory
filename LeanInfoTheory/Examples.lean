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
import LeanInfoTheory.Examples.CouplingGluing
import LeanInfoTheory.Examples.CouplingTransport
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
Focused transport consumers check coordinate maps, supplied coupling channels,
deterministic specialization and a channel with incorrect unused-row marginals.
They also lift the actual maximal input coupling through maximal row couplings,
derive its exact weighted disagreement, and recover stochastic and deterministic
contraction, including degenerate cases.
Gluing consumers retain both prescribed pair laws, derive the endpoint coupling
from the same triple, and check that changing a null-fiber fallback leaves the
whole triple unchanged while positive conditional rows can differ.
The fair/pure/fair Boolean regression proves both adjacent couplings maximal,
then computes the same Markov witness's independent endpoints and their strictly
larger disagreement than the diagonal coupling.
It also includes representative
arbitrary-base, bits, and guarded real-KL unit conversions. It remains outside
both public mathematical umbrellas. The examples are maintained regression
consumers, not stable library API for the `0.1.x`
series.
-/
