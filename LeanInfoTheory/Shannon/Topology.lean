/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.InfoMeasures
import LeanInfoTheory.Probability.FiniteTopology

/-!
# Continuity of finite information measures

Entropy, conditional entropy and mutual information are continuous on their
entire finite PMF domains, including laws with zero masses. The proofs use
continuity of `Real.negMulLog`, finite sums and the existing algebraic formulas.
Composing with the fixed-channel joint map gives continuity of the actual
input mutual-information objective.

Conditional entropy retains the convention `H(X | Y)` on `PMF (α × β)`.
These joint-law statements do not assert continuity of conditional PMFs at
null fibers or continuity of KL divergence.
-/

namespace LeanInfoTheory.Shannon

universe u v

/-- Entropy is continuous on finite PMFs, including boundary laws. -/
theorem continuous_entropy {α : Type u} [Fintype α] :
    Continuous (entropy (alpha := α)) := by
  unfold entropy
  apply continuous_finsetSum
  intro a _
  exact Real.continuous_negMulLog.comp (PMF.continuous_apply_toReal a)

/-- Conditional entropy `H(X | Y)` is continuous as a finite joint-law function. -/
theorem continuous_condEntropy {α : Type u} {β : Type v}
    [Fintype α] [Fintype β] :
    Continuous (condEntropy (alpha := α) (beta := β)) := by
  exact continuous_entropy.sub
    (continuous_entropy.comp (PMF.continuous_map Prod.snd))

/-- Mutual information is continuous as a finite joint-law function. -/
theorem continuous_mutualInfo {α : Type u} {β : Type v}
    [Fintype α] [Fintype β] :
    Continuous (mutualInfo (alpha := α) (beta := β)) := by
  exact ((continuous_entropy.comp (PMF.continuous_map Prod.fst)).add
    (continuous_entropy.comp (PMF.continuous_map Prod.snd))).sub
      continuous_entropy

/-- The mutual information of a fixed finite channel is continuous in its input law. -/
theorem continuous_mutualInfo_channelJoint {α : Type u} {β : Type v}
    [Fintype α] [Fintype β] (W : α → PMF β) :
    Continuous (fun p : PMF α => mutualInfo (PMF.channelJoint p W)) :=
  continuous_mutualInfo.comp (PMF.continuous_channelJoint W)

end LeanInfoTheory.Shannon
