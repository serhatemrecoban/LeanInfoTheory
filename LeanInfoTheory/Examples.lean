/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Examples.ChannelOptimization
import LeanInfoTheory.Examples.AEP
import LeanInfoTheory.Examples.TypicalSet
import LeanInfoTheory.Examples.CommonCause
import LeanInfoTheory.Examples.ConditionalKL
import LeanInfoTheory.Examples.Continuity
import LeanInfoTheory.Examples.Convexity
import LeanInfoTheory.Examples.Coupling
import LeanInfoTheory.Examples.CouplingFano
import LeanInfoTheory.Examples.CouplingGluing
import LeanInfoTheory.Examples.CouplingTransport
import LeanInfoTheory.Examples.Fano
import LeanInfoTheory.Examples.FiniteFamily
import LeanInfoTheory.Examples.FiniteFamilyInformation
import LeanInfoTheory.Examples.FiniteProduct
import LeanInfoTheory.Examples.FiniteProductSemantics
import LeanInfoTheory.Examples.FiniteTopology
import LeanInfoTheory.Examples.Iid
import LeanInfoTheory.Examples.IidInformation
import LeanInfoTheory.Examples.ProductKL
import LeanInfoTheory.Examples.IndependenceProcessing
import LeanInfoTheory.Examples.InformationDecomposition
import LeanInfoTheory.Examples.KLTop
import LeanInfoTheory.Examples.Pinsker
import LeanInfoTheory.Examples.ProductChannel
import LeanInfoTheory.Examples.ProductChannelSemantics
import LeanInfoTheory.Examples.ProductChannelInformation
import LeanInfoTheory.Examples.QuantitativeIndependence
import LeanInfoTheory.Examples.StochasticChannels
import LeanInfoTheory.Examples.SufficientStatistics
import LeanInfoTheory.Examples.SupportSensitive
import LeanInfoTheory.Examples.TotalVariation
import LeanInfoTheory.Examples.TotalVariationTopology
import LeanInfoTheory.Examples.TotalVariationChannels
import LeanInfoTheory.Examples.Units

/-!
# Examples aggregate

Focused family-information consumers apply conditional tuple subadditivity and
the independent-source MI bound to one common observation. XOR gives a strict
gap and conditional dependence; heterogeneous variables on an infinite source
space, separate observation universes and empty/singleton families exercise the
general random-variable interfaces.

Product-channel consumers separate elementary joint/block laws from existing
family and conditional semantics. They exercise correlated noisy inputs,
noninjective source maps, supported recovery and null-coordinate changes.
Focused information consumers check swapped conditional output entropy with
actual coordinate marginals, noisy correlated inputs and sparse null-row changes.

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

The focused finite-product semantic consumers connect constructed laws to
existing family marginals and independence predicates, including a full
three-coordinate non-iid atom, sparse outcomes and distinct coordinate pairs.
Independent coordinate pairs retain positive within-pair mutual information;
a heterogeneous pair family uses the same focused semantic product import.

Product-channel information consumers exercise the arbitrary-input MI bound,
strict correlated identity processing, correlated constant-output equality,
heterogeneous independent inputs and iid lengths. The parity triple separates
pairwise from mutual output independence. Noninjective encoded inputs and
generic coordinate-objective caps use the actual channel objective.

The focused product-KL consumers exercise heterogeneous sparse supported laws,
empty and singleton products, singleton alphabets and zero/one iid lengths.
Overlapping incomparable supports give infinite product KL while coordinate
Real divergences sum to positive log 2, demonstrating the Real support guard.

The focused iid consumers use general product laws for sparse atoms, support,
coordinates, injective selection and permutation invariance. They split and
reconstruct a non-iid block, specialize both transports to iid, and cover zero/one
lengths, either empty side, singleton alphabets and impossible symbols.

The focused Pinsker consumers cover Boolean endpoint and support cases and
a positive three-atom law pair whose attaining event contains a tied atom,
with exact total variation and KL values and Boolean TV preservation. They
also exercise both supplied finite-KL guards, a sparse reference law, an
event bound from an extended-valued KL budget, and actual counterexamples
to unguarded Real and square-root Pinsker inequalities.
Quantitative-independence consumers turn a mutual-information budget into
total-variation, event and bounded-test estimates, including the factor two
for signed tests. They cover arbitrary source-law pushforwards, independent
and degenerate endpoints, and an exact sparse joint with a null marginal row.
The focused continuity consumers apply the exact-TV entropy bound in both
orders, check empty/singleton and zero/maximal-distance cases, and establish
the nonzero binary and ternary threshold gaps with exact masses and distances.
The finite-topology consumers use the real-simplex bridge on sparse laws and
pure vertices, both round trips, empty/singleton alphabets and coordinate limits.
TV-topology consumers connect coordinate and TV limits and approach a pure law
through a Boolean family with exact coordinates and total variation.
The channel-optimization consumers obtain an actual maximizing input from
compactness and continuity. They propagate the same Boolean family to explicit
zero MI and conditional-entropy limits, including a disappearing conditioning
marginal, and distinguish singleton and empty input/output alphabets.
-/
