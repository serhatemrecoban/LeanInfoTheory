/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceChannelSeparation
import LeanInfoTheory.Shannon.SourceChannelConverse

/-!
# Strict regimes for lossless source–channel separation

One channel use per source symbol gives achievability below capacity and
impossibility of vanishing reconstruction error above capacity.
-/

namespace LeanInfoTheory.Examples.SourceChannelSeparationPackage

open LeanInfoTheory.Shannon Filter

universe u v w

variable {S : Type u} {X : Type v} {Y : Type w}
  [Fintype S] [Fintype X] [Nonempty X] [Fintype Y]
  (p : PMF S) (W : X → PMF Y)

example (h : entropy p < channelCapacity W) :
    ∃ (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X))
      (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S)),
      Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n)) atTop (nhds 0) ∧
        entropy p ≤ channelCapacity W := by
  obtain ⟨E, D, he⟩ := exists_sourceChannelCode_tendsto_errorProbability_zero p W h
  exact ⟨E, D, he, entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability p W E D he⟩

example (h : channelCapacity W < entropy p) :
    ¬ ∃ (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X))
      (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S)),
      Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n)) atTop (nhds 0) := by
  rintro ⟨E, D, he⟩
  exact h.not_ge (entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability p W E D he)

end LeanInfoTheory.Examples.SourceChannelSeparationPackage
