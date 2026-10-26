/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.ChannelCodingAsymptotic

/-!
# Finite and asymptotic converses for the same channel-code family

The undivided finite Fano-capacity bound includes zero length. The family's
actual vanishing uniform-message error also gives every eventual rate cap,
without a rate convergence or boundedness premise.
-/

namespace Consumer.WeakConverse

open Filter Topology LeanInfoTheory.Shannon

universe u v

example {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B]
    (W : A → PMF B) (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
    (c : ∀ n, BlockChannelCode A B n (M n))
    (he : Tendsto (fun n => (c n).errorProbability W (hM n))
      atTop (nhds 0)) :
    (∀ n,
      (1 - (c n).errorProbability W (hM n)) * Real.log (M n : ℝ) ≤
        (n : ℝ) * channelCapacity W + Real.log 2) ∧
    (∀ δ : ℝ, 0 < δ →
      ∀ᶠ n in atTop, codeRate n (M n) ≤ channelCapacity W + δ) := by
  constructor
  · intro n
    exact (c n).one_sub_errorProbability_mul_log_le W (hM n)
  · intro δ hδ
    exact BlockChannelCode.eventually_codeRate_le_channelCapacity_add
      W M hM c he δ hδ

end Consumer.WeakConverse
