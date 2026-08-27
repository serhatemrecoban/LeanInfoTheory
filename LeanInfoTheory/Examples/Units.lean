/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.KL
import LeanInfoTheory.Shannon.Units

/-!
# Information-unit examples

These maintained, non-stable regression consumers show how the canonical
real-valued quantities measured in nats can be converted to another valid
logarithm base and, in particular, to bits. The KL example converts only after
absolute continuity supplies the finite real-valued KL formula; applying
`ENNReal.toReal` to an infinite KL value would instead produce zero.
-/

namespace LeanInfoTheory
namespace Examples
namespace Units

open scoped BigOperators
open MeasureTheory
open Shannon

noncomputable section

universe u v w

example (x b c : Real) (hb : 1 < b) (hc : 1 < c) :
    natsToBase c x = Real.logb c b * natsToBase b x := by
  simpa [natsToBase] using div_log_change_base x b c hb hc

example {alpha : Type u} [Fintype alpha] (p : PMF alpha) :
    natsToBits (entropy p) =
      ∑ a, -(p a).toReal * Real.logb 2 (p a).toReal := by
  simpa [natsToBits, natsToBase] using entropy_div_log p 2

example {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (p : PMF (alpha × beta)) :
    natsToBits (mutualInfo p) =
      natsToBits (entropy (fstMarginal p)) +
        natsToBits (entropy (sndMarginal p)) - natsToBits (entropy p) := by
  rw [mutualInfo_eq]
  simp only [natsToBits, natsToBase]
  ring

example {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF (alpha × beta × gamma)) :
    natsToBits (condMutualInfo p) =
      natsToBits (entropy (fstThirdMarginal p)) +
        natsToBits (entropy (sndThirdMarginal p)) -
          natsToBits (entropy (thirdMarginal p)) - natsToBits (entropy p) := by
  rw [condMutualInfo_eq]
  simp only [natsToBits, natsToBase]
  ring

example {alpha : Type u}
    [Fintype alpha] [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    (p q : PMF alpha) (h : p.toMeasure ≪ q.toMeasure) :
    natsToBits ((InformationTheory.klDiv p.toMeasure q.toMeasure).toReal) =
      ∑ a, (p a).toReal * Real.logb 2 ((p a / q a).toReal) := by
  rw [natsToBits, natsToBase, toReal_klDiv_pmf_eq_sum p q h, Finset.sum_div]
  apply Finset.sum_congr rfl
  intro a _ha
  rw [mul_div_assoc, Real.log_div_log]

end

end Units
end Examples
end LeanInfoTheory
