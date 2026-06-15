/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.InformationMeasures
import Mathlib.InformationTheory.KullbackLeibler.Basic
import Mathlib.InformationTheory.KullbackLeibler.ChainRule

/-!
# Semantic bridge for finite Shannon information measures

This file is the intended home for bridge theorems connecting the lightweight
finite Shannon API in `LeanInfoTheory.Shannon.InfoMeasures` to mathlib's
measure-theoretic probability and information-theory APIs.

The core finite Shannon files intentionally define conditional entropy, mutual
information, and conditional mutual information by entropy identities. That is
the right shape for entropy-expression certificates and for early finite-PMF
development. The semantic bridge layer should later prove that these
definitions agree with the textbook/measure-theoretic semantics:

- `condEntropy` as the expected entropy of conditional laws;
- `mutualInfo` as a KL divergence from the joint law to the product of its
  marginals;
- `condMutualInfo` as either a KL chain-rule expression or an averaged
  conditional KL divergence.

Keeping this file separate prevents KL divergence, kernels, and related
measure-theoretic imports from becoming dependencies of the lightweight finite
Shannon API. Conditional-probability imports should be added here when the
first conditional-law theorem actually needs them.
-/

namespace LeanInfoTheory
namespace Shannon

/-!
Bridge theorem targets should be added here only after their statements are
stable enough to justify the heavier imports above. Until then, this compiled
module records the import boundary and keeps the foundation layer honest.
-/

end Shannon
end LeanInfoTheory
