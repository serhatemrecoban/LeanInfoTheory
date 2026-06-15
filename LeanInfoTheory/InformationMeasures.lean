/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.InfoMeasures

/-!
# Finite information-measure API

This file keeps the original public entry point for information measures while
the concrete finite-discrete definitions live in `LeanInfoTheory.Shannon`.
-/

namespace LeanInfoTheory

/-!
The export list is intentionally explicit. Keeping the public names grouped by
topic makes it easier to notice when a new foundation lemma should become part
of the user-facing finite information-measure API.
-/
export Shannon
  (entropy entropyOf jointEntropy jointEntropyOf
   fstMarginal sndMarginal fstThirdMarginal sndThirdMarginal thirdMarginal
   condEntropy mutualInfo condMutualInfo
   condEntropyOf mutualInfoOf condMutualInfoOf
   fstMarginal_map sndMarginal_map fstMarginal_map_pair sndMarginal_map_pair
   fstMarginal_map_swap sndMarginal_map_swap
   fstMarginal_apply sndMarginal_apply
   fstThirdMarginal_map sndThirdMarginal_map thirdMarginal_map
   fstThirdMarginal_map_triple sndThirdMarginal_map_triple thirdMarginal_map_triple
   fstThirdMarginal_map_swap12 sndThirdMarginal_map_swap12 thirdMarginal_map_swap12
   fstThirdMarginal_apply sndThirdMarginal_apply thirdMarginal_apply
   apply_le_fstMarginal apply_le_sndMarginal
   apply_le_fstThirdMarginal apply_le_sndThirdMarginal apply_le_thirdMarginal
   apply_eq_zero_of_fstMarginal_eq_zero apply_eq_zero_of_sndMarginal_eq_zero
   fstMarginal_ne_zero_of_apply_ne_zero sndMarginal_ne_zero_of_apply_ne_zero
   apply_eq_zero_of_fstThirdMarginal_eq_zero
   apply_eq_zero_of_sndThirdMarginal_eq_zero apply_eq_zero_of_thirdMarginal_eq_zero
   fstThirdMarginal_ne_zero_of_apply_ne_zero sndThirdMarginal_ne_zero_of_apply_ne_zero
   thirdMarginal_ne_zero_of_apply_ne_zero
   entropyOf_fst entropyOf_snd jointEntropyOf_fst_snd
   condEntropyOf_fst_snd mutualInfoOf_fst_snd
   entropyOf_third jointEntropyOf_fst_third jointEntropyOf_snd_third
   condMutualInfoOf_fst_snd_third
   condEntropy_eq mutualInfo_eq condMutualInfo_eq
   condEntropyOf_eq mutualInfoOf_eq condMutualInfoOf_eq)

end LeanInfoTheory
