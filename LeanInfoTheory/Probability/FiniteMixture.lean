/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.Finite

/-!
# Finite mixtures of probability mass functions

This opt-in probability module provides a binary PMF mixture matching
mathlib's `PMF.bernoulli` parameter convention. General finite-selector
mixtures continue to use `PMF.bind` directly.
-/

namespace PMF

universe u

variable {alpha : Type u}

noncomputable section

/--
The binary mixture with weight `t` on `p` and weight `1 - t` on `q`.

Equivalently, a Bernoulli selector chooses `p` on `true` and `q` on `false`.
-/
def binaryMixture (t : NNReal) (ht : t <= 1)
    (p q : PMF alpha) : PMF alpha :=
  (PMF.bernoulli t ht).bind fun b => if b then p else q

/-- Pointwise mass formula for a binary PMF mixture. -/
theorem binaryMixture_apply (t : NNReal) (ht : t <= 1)
    (p q : PMF alpha) (a : alpha) :
    binaryMixture t ht p q a =
      (t : ENNReal) * p a + ((1 - t : NNReal) : ENNReal) * q a := by
  rw [binaryMixture, PMF.bind_apply, tsum_fintype]
  simp [PMF.bernoulli_apply, ENNReal.coe_sub]

/-- A binary mixture of weight zero is its second component. -/
@[simp]
theorem binaryMixture_zero (h0 : (0 : NNReal) <= 1)
    (p q : PMF alpha) :
    binaryMixture 0 h0 p q = q := by
  apply PMF.ext
  intro a
  rw [binaryMixture_apply]
  simp

/-- A binary mixture of weight one is its first component. -/
@[simp]
theorem binaryMixture_one (h1 : (1 : NNReal) <= 1)
    (p q : PMF alpha) :
    binaryMixture 1 h1 p q = p := by
  apply PMF.ext
  intro a
  rw [binaryMixture_apply]
  simp

end

end PMF
