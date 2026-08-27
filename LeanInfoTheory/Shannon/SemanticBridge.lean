/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.Entropy
import LeanInfoTheory.Shannon.SemanticBridge.Product
import LeanInfoTheory.Shannon.SemanticBridge.FiniteSums
import LeanInfoTheory.Shannon.SemanticBridge.Conditional
import LeanInfoTheory.Shannon.SemanticBridge.KL
import LeanInfoTheory.Shannon.SemanticBridge.Theorems
import LeanInfoTheory.Shannon.SemanticBridge.Convexity
import LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily
import LeanInfoTheory.Shannon.SemanticBridge.Independence
import LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence
import LeanInfoTheory.Shannon.SemanticBridge.Markov
import LeanInfoTheory.Shannon.SemanticBridge.Sufficiency
import LeanInfoTheory.Shannon.SemanticBridge.DataProcessing
import LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL
import LeanInfoTheory.Shannon.SemanticBridge.Sufficiency.KL

/-!
# Semantic bridge for finite Shannon information measures

This import-only aggregate is the public entry point for bridge theorems
connecting the lightweight finite Shannon API in
`LeanInfoTheory.Shannon.InfoMeasures` to mathlib's measure-theoretic probability
and information-theory APIs. Individual declarations live in focused submodules.

The core finite Shannon files intentionally define entropy and entropy-derived
quantities by finite sums and entropy identities. That keeps computational
finite-PMF use lightweight. The semantic bridge layer proves that these
definitions agree with the textbook/measure-theoretic semantics.

- `entropy` as expected self-information over `PMF.toMeasure`;
- `indepProd` as the independent product law of two PMFs, together with
  product-measure and joint-law absolute-continuity bridge lemmas;
- `IsIndependent` and `IsIndependentOf` as PMF and random-variable
  independence predicates, with a bridge to mathlib `IndepFun` and zero-mutual-
  information and pair-entropy equality characterizations;
- `IsCondIndependent` and `IsCondIndependentOf` through proof-independent
  cross-product factorization, equivalent to independence of each positive-
  mass conditional joint law and to zero conditional mutual information, with
  first-two-variable symmetry and the resulting conditional-entropy equality
  cases;
- finite-sum formulas rewriting `mutualInfo` as
  `sum p(a,b) log (p(a,b) / (p_A(a) p_B(b)))`;
- `mutualInfo` as KL divergence from the joint law to the product of its
  marginals;
- `condFstGivenSnd`, the nonzero-mass conditional law `P_{A | B=b}`;
- `condFstGivenSndChannel`, its total channel form with a documented null-fiber
  fallback and pair-law reconstruction for Markov factorization;
- `IsMarkovChain` and `IsMarkovChainOf`, the PMF and random-variable Markov
  predicates with the orientation `X -> Y -> Z`, together with cross-product,
  positive-fiber, zero-CMI, and reversal characterizations and the Markov law
  for channel-generated triples, its canonical and existential channel-
  factorization converses, and the exact mutual-information loss identity;
- `IsSufficientStatisticOf`, the fixed-prior reverse-Markov sufficiency
  predicate, together with `statisticTripleLawOf`, its induced parameter-
  statistic-observation law, its information-preservation characterizations,
  and its exact full-joint recovery equivalence;
- `IsSufficientChannel` and `IsSufficientStatistic`, the family-level channel
  predicate with one common recovery channel and its deterministic-channel
  specialization, together with reverse Markov, zero-CMI, mutual-information,
  and conditional-entropy consequences for every parameter prior and the
  converse full-support/all-prior characterizations, plus the finite Fisher-
  Neyman factorization theorem for deterministic statistics;
- `pmfChannelKernel`, the mathlib Markov-kernel view of a countable PMF-valued
  channel, with `channelJoint_toMeasure` identifying the induced PMF joint law
  with the corresponding measure-kernel composition product;
- `channelPosterior`, the total finite posterior of an input law and channel,
  together with PMF joint reconstruction, the supported common-posterior
  characterization of family sufficiency, and the exact
  `klDiv_channel_eq_add_posterior` decomposition;
- finite KL data processing through a common stochastic channel, with
  unconditional `ENNReal`, support-guarded real, deterministic-map, and
  channel-cascade forms;
- finite-selector KL joint convexity, entropy concavity and mutual-information
  concavity in the input law, and mutual-information convexity in the channel,
  together with binary textbook forms;
- exact preservation of pairwise `ENNReal` KL divergence through a channel
  admitting one common exact recovery channel for both input laws, together
  with support-guarded `ENNReal`/real converses and deterministic-map forms;
- pairwise `ENNReal` KL preservation for sufficient model-family channels and
  statistics, with guarded converse characterizations for Boolean-indexed
  two-law families;
- one-step KL contraction toward invariant reference laws and entropy growth
  under uniform-preserving and finite doubly stochastic channels;
- `condEntropy` as the expected entropy of these conditional laws;
- `condMutualInfo` as expected fiber mutual information and as an averaged
  conditional KL divergence;
- conditional relative entropy for PMF-valued channels under one input law,
  with finite unconditional `ENNReal` weighted-fiber and joint-chain formulas
  and support-guarded real-valued counterparts;
- semantic theorem API: `0 <= I(A;B)`, `0 <= I(A;B|C)`, and the chain rule
  `I(A;B,C) = I(A;C) + I(A;B|C)`.
- finite-family entropy monotonicity, nonnegative conditional entropy and CMI,
  and entropy submodularity, without requiring a finite family index.
- finite-family mutual independence through pointwise PMF factorization,
  including empty, singleton, restriction, pair compatibility, and exact
  entropy-additivity characterizations.

Keeping this file separate prevents KL divergence, kernels, and related
measure-theoretic imports from becoming dependencies of the lightweight finite
Shannon API. More conditional-probability and kernel imports should still stay
in this bridge layer or its subfiles, rather than in the core finite Shannon
API.
-/
