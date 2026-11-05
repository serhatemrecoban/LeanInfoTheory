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
import LeanInfoTheory.Probability.StandardChannels
import LeanInfoTheory.Probability.TotalVariation
import LeanInfoTheory.Probability.TotalVariationTopology
import LeanInfoTheory.Shannon.ChannelCapacity
import LeanInfoTheory.Shannon.ChannelCode
import LeanInfoTheory.Shannon.ChannelCoding
import LeanInfoTheory.Shannon.ChannelCodingAsymptotic
import LeanInfoTheory.Shannon.CodingRate
import LeanInfoTheory.Shannon.Continuity
import LeanInfoTheory.Shannon.Fano
import LeanInfoTheory.Shannon.ProductChannelCapacity
import LeanInfoTheory.Shannon.SemanticBridge
import LeanInfoTheory.Shannon.SourceCoding
import LeanInfoTheory.Shannon.SourceCodingAsymptotic
import LeanInfoTheory.Shannon.StandardChannelCapacity
import LeanInfoTheory.Shannon.Topology
import LeanInfoTheory.Shannon.TypicalSet
import LeanInfoTheory.Shannon.Units

/-!
# Complete finite Shannon information-theory import

This import-only umbrella gathers LeanInfoTheory's complete supported
mathematical stack. It subsumes the lightweight `LeanInfoTheory` root and
adds the focused finite-channel, entropy-bound, Fano, finite-family, semantic,
KL, Markov, gluing, sufficiency, convexity, total-variation, coupling, finite-simplex
topology, finite dependent products, Fin block transports and iid laws, finite
product-channel rows and restrictions, TV
convergence, quantitative entropy
continuity, qualitative information continuity, and unit-conversion modules.

For each target above entropy, the focused asymptotic source-coding owner supplies
one finite-iid code family with vanishing error and an eventual rate bound.
Finite-channel information capacity is an attained supremum in nats, with a
universal objective bound and input/output alphabet bounds. Product capacity is
the sum of coordinate capacities, with an arbitrary-input memoryless nC bound.
The focused standard-channel owner gives noiseless, input-independent, binary
symmetric and binary erasure capacities, with actual uniform attaining inputs.
BSC exposes its uniform witness directly; BEC supplies its all-input entropy formula.
The four standard capacity values also have explicit scalar bits equations
through the existing Units conversion.

The focused channel-code owner defines deterministic block codes, their actual
uniform-message sampling laws and average decoding error, including collisions,
singleton budgets and zero/one blocklengths.

The finite channel-coding owner connects those actual laws to Markov data
processing, the Fano-capacity bound and its positive-length rate/error forms.

The channel-coding asymptotic owner derives eventual rate boundedness from
vanishing average error, then proves every positive-tolerance capacity cap and
the real limsup bound for the same arbitrary code family.

An eventual rate above capacity gives a quantitative eventual error bound and
a positive error floor. A fixed positive rate gap occurring infinitely often
rules out vanishing error, including for unbounded rate sequences.

It deliberately excludes `LeanInfoTheory.Basic`, `LeanInfoTheory.Examples`, and
`LeanInfoTheory.MathlibFragments`, which are non-stable development, regression,
and reference anchors rather than public mathematical API.
-/
