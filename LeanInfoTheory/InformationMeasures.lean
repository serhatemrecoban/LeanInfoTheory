/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.InfoMeasures

/-!
# Finite information-measure API

This file keeps a public re-export entry point for finite information measures
while the canonical finite-discrete definitions live in
`LeanInfoTheory.Shannon`.

Project theorem files and documentation should prefer the namespaced
`Shannon.*` names when the distinction matters. The exported names in
`LeanInfoTheory` are convenience aliases for users who import the project root.
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
   fstSndMarginal
   condEntropy mutualInfo condMutualInfo
   condEntropyOf mutualInfoOf condMutualInfoOf
   mutualInfo_map_swap mutualInfoOf_swap
   condMutualInfo_map_swap12 condMutualInfoOf_swap
   fstMarginal_map sndMarginal_map fstMarginal_map_pair sndMarginal_map_pair
   fstMarginal_map_swap sndMarginal_map_swap
   fstMarginal_apply sndMarginal_apply
   fstSndMarginal_map fstSndMarginal_map_triple
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
   entropy_eq_entropy_sndMarginal_add_condEntropy
   entropy_eq_entropy_fstMarginal_add_condEntropy_swap
   jointEntropyOf_eq_entropyOf_add_condEntropyOf
   jointEntropyOf_eq_entropyOf_add_condEntropyOf_swap
   entropy_chain_rule_right entropy_chain_rule_left
   jointEntropyOf_chain_rule_right jointEntropyOf_chain_rule_left
   condEntropyOf_eq
   condEntropyOf_pair_swap condEntropyOf_pair_chain_rule
   condEntropyOf_pair_chain_rule_swap
   mutualInfoOf_eq condMutualInfoOf_eq
   condMutualInfoOf_eq_condEntropyOf_sub_condEntropyOf
   condMutualInfoOf_eq_condEntropyOf_sub_condEntropyOf_swap
   condMutualInfoOf_eq_condEntropyOf_add_condEntropyOf_sub_condEntropyOf_pair
   mutualInfo_eq_entropy_fstMarginal_sub_condEntropy
   mutualInfo_eq_entropy_sndMarginal_sub_condEntropy_swap
   mutualInfoOf_eq_entropyOf_sub_condEntropyOf
   mutualInfoOf_eq_entropyOf_sub_condEntropyOf_swap
   mutualInfo_map_diag mutualInfoOf_self)

end LeanInfoTheory
