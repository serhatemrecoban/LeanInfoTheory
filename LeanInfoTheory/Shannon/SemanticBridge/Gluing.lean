/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.Markov

/-!
# Gluing pair laws through a common marginal

Two pair laws with the same middle marginal extend to a Markov triple with
both prescribed pair marginals. The construction extends the first pair
through the total conditional channel obtained from the second pair.

Only the final coordinate alphabet needs to be finite. Null middle fibers
are handled by the existing conditional-channel reconstruction laws; the
fallback on those fibers has no conditional-probability meaning.
-/

namespace LeanInfoTheory
namespace Shannon

universe u v w

/--
Pair laws on `(A,B)` and `(B,C)` with the same `B` marginal extend to a law on
the right-associated triple `(A,B,C)` with both prescribed pair marginals
and Markov structure `A → B → C`.

Only the final alphabet is required to be finite. The construction uses the
total conditional channel for `C` given `B`; its values on null middle fibers
do not affect the reconstructed law.
-/
theorem exists_isMarkovChain_with_marginals
    {alpha : Type u} {beta : Type v} {gamma : Type w} [Finite gamma]
    (L : PMF (alpha × beta)) (R : PMF (beta × gamma))
    (hmid : L.map Prod.snd = R.map Prod.fst) :
    ∃ T : PMF (alpha × beta × gamma),
      fstSndMarginal T = L ∧ sndThirdMarginal T = R ∧ IsMarkovChain T := by
  classical
  let := Fintype.ofFinite gamma
  let V := condFstGivenSndChannel (R.map Prod.swap)
  refine ⟨PMF.channelExtension L V, PMF.channelExtension_map_input L V,
    ?_, isMarkovChain_channelExtension L V⟩
  change (PMF.channelExtension L V).map (fun z => z.2) = R
  rw [PMF.channelExtension_map_outputPair, hmid]
  have hmiddle : sndMarginal (R.map Prod.swap) = R.map Prod.fst := by
    simp only [sndMarginal, PMF.map_comp]
    rfl
  have hreconstruct := channelJoint_condFstGivenSndChannel (R.map Prod.swap)
  rw [hmiddle] at hreconstruct
  calc
    PMF.channelJoint (R.map Prod.fst) V =
        (R.map Prod.swap).map Prod.swap := hreconstruct
    _ = R := by
      rw [PMF.map_comp]
      exact PMF.map_id R

end Shannon
end LeanInfoTheory
