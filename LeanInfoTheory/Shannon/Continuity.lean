/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.Coupling
import LeanInfoTheory.Shannon.Fano

/-!
# Quantitative entropy and information continuity

The exact total variation between two finite laws controls their entropy
difference. The proof applies Fano's inequality to the actual maximal coupling
and its coordinate swap, whose identity-decoder errors both equal total
variation. Entropy is measured in nats and total variation is half the L1
distance between the real atom masses.

An upper estimate for total variation uses a capped scalar bound: the exact
binary-entropy expression increases through `1 - 1 / m`, where it equals
`log m`, and the bound stays constant above that threshold. Its monotonicity
therefore permits every nonnegative real budget, including budgets above one.

For joint laws, projection contraction and the entropy identities give bounds
for conditional entropy and mutual information at the same budget. Each joint
or marginal entropy uses the capped bound for its own whole alphabet. Conditional
entropy conditions the first coordinate on the second; no support assumption or
conditional-law continuity statement is needed.
-/

namespace LeanInfoTheory.Shannon

universe u v

private theorem disagreement_map_swap {alpha : Type u}
    (joint : PMF (alpha × alpha)) :
    (joint.map Prod.swap).toOuterMeasure {xy | xy.1 ≠ xy.2} =
      joint.toOuterMeasure {xy | xy.1 ≠ xy.2} := by
  rw [PMF.toOuterMeasure_map_apply]
  congr 1
  ext xy
  change (xy.2 ≠ xy.1) ↔ (xy.1 ≠ xy.2)
  exact ne_comm

-- Fano tests the decoded second coordinate against the first; the coupling
-- event uses the opposite order of the same inequality.
private theorem identity_error_eq_disagreement {alpha : Type u} [Finite alpha]
    (joint : PMF (alpha × alpha)) :
    decodingErrorProbability joint id =
      (joint.toOuterMeasure {xy | xy.1 ≠ xy.2}).toReal := by
  classical
  let := Fintype.ofFinite alpha
  rw [decodingErrorProbability_eq_sum, PMF.toOuterMeasure_toReal_eq_sum]
  apply Finset.sum_congr rfl
  intro xy _
  by_cases h : xy.1 = xy.2 <;> simp [Set.indicator, h, Ne.symm]

private theorem maximal_decoder_errors {alpha : Type u} [Fintype alpha]
    (p q : PMF alpha) :
    decodingErrorProbability (PMF.maximalCoupling p q) id = PMF.totalVariation p q ∧
      decodingErrorProbability ((PMF.maximalCoupling p q).map Prod.swap) id =
        PMF.totalVariation p q := by
  constructor
  · rw [identity_error_eq_disagreement, PMF.maximalCoupling_toOuterMeasure_ne_toReal]
  · rw [identity_error_eq_disagreement, disagreement_map_swap,
      PMF.maximalCoupling_toOuterMeasure_ne_toReal]

-- The two chain rules express the entropy difference as the difference of
-- the conditional entropies. Their nonnegativity bounds both orientations.
private theorem entropy_sub_bounds {alpha : Type u} [Fintype alpha]
    {joint : PMF (alpha × alpha)} {p q : PMF alpha}
    (h : PMF.IsCoupling joint p q) :
    entropy p - entropy q ≤ condEntropy joint ∧
      entropy q - entropy p ≤ condEntropy (joint.map Prod.swap) := by
  have hfst := entropy_eq_entropy_fstMarginal_add_condEntropy_swap joint
  have hsnd := entropy_eq_entropy_sndMarginal_add_condEntropy joint
  rw [show fstMarginal joint = p from h.1] at hfst
  rw [show sndMarginal joint = q from h.2] at hsnd
  constructor
  · linarith [condEntropy_nonneg (joint.map Prod.swap)]
  · linarith [condEntropy_nonneg joint]

/--
The absolute entropy difference is bounded by binary entropy plus the
alphabet-size term at the exact total variation distance.

This is Sason's maximal-coupling bound (SA13, Section II, Theorem 3), with
entropy in nats and total variation normalized as half the L1 distance.
The logarithm uses Nat subtraction before casting to Real. No lower bound
on the alphabet cardinality is required: on a singleton, both entropies and
total variation are zero; an empty alphabet carries no PMF.

The distance on the right is exact. Replacing it by an upper estimate requires
a separate monotonicity argument, since the displayed expression need not
increase throughout the unit interval.
-/
theorem abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log
    {alpha : Type u} [Fintype alpha] (p q : PMF alpha) :
    |entropy p - entropy q| ≤
      Real.binEntropy (PMF.totalVariation p q) +
        PMF.totalVariation p q *
          Real.log ((Fintype.card alpha - 1 : Nat) : Real) := by
  have he := maximal_decoder_errors p q
  have hf := condEntropy_fano (PMF.maximalCoupling p q) id
  have hfs := condEntropy_fano ((PMF.maximalCoupling p q).map Prod.swap) id
  rw [he.1] at hf
  rw [he.2] at hfs
  have hd := entropy_sub_bounds (PMF.isCoupling_maximalCoupling p q)
  refine abs_le.mpr ⟨?_, hd.1.trans hf⟩
  linarith [hd.2.trans hfs]

private theorem continuity_qary_eq (m : Nat) (hm : 2 ≤ m) (epsilon : Real) :
    Real.qaryEntropy m epsilon =
      Real.binEntropy epsilon + epsilon * Real.log ((m - 1 : Nat) : Real) := by
  have hcast : (((m : Int) - 1 : Int) : Real) = ((m - 1 : Nat) : Real) := by
    push_cast
    rw [Nat.cast_sub (by omega : 1 ≤ m)]
    norm_num
  rw [Real.qaryEntropy, hcast]
  ring

private theorem continuity_threshold_range (m : Nat) (hm : 2 ≤ m) :
    1 - 1 / (m : Real) ∈ Set.Icc (0 : Real) 1 := by
  have hmR : 2 ≤ (m : Real) := by exact_mod_cast hm
  have hq : 1 / (m : Real) ≤ 1 := (div_le_one (by linarith)).2 (by linarith)
  have hq0 : 0 ≤ 1 / (m : Real) := by positivity
  constructor <;> linarith

private theorem continuity_term_at_threshold (m : Nat) (hm : 2 ≤ m) :
    Real.binEntropy (1 - 1 / (m : Real)) +
        (1 - 1 / (m : Real)) * Real.log ((m - 1 : Nat) : Real) =
      Real.log (m : Real) := by
  rw [← continuity_qary_eq m hm]
  have hmR : 2 ≤ (m : Real) := by exact_mod_cast hm
  have hm0 : (m : Real) ≠ 0 := by linarith
  have hm1 : (m : Real) - 1 ≠ 0 := by linarith
  have hfrac : 1 - 1 / (m : Real) = ((m : Real) - 1) / m := by field_simp
  rw [Real.qaryEntropy]
  -- Definitional reduction avoids duplicating Pinsker's lazy `Real.binEntropy.eq_1`.
  delta Real.binEntropy
  push_cast
  rw [Real.log_inv, Real.log_inv,
    show 1 - (1 - 1 / (m : Real)) = 1 / m by ring]
  rw [hfrac, Real.log_div hm1 hm0,
    Real.log_div (by norm_num : (1 : Real) ≠ 0) hm0, Real.log_one]
  field_simp
  ring

private theorem continuity_term_mono (m : Nat) (hm : 2 ≤ m) :
    MonotoneOn
      (fun epsilon : Real =>
        Real.binEntropy epsilon + epsilon * Real.log ((m - 1 : Nat) : Real))
      (Set.Icc 0 (1 - 1 / (m : Real))) := by
  intro epsilon hepsilon eta heta hle
  change Real.binEntropy epsilon + epsilon * Real.log ((m - 1 : Nat) : Real) ≤
    Real.binEntropy eta + eta * Real.log ((m - 1 : Nat) : Real)
  rw [← continuity_qary_eq m hm, ← continuity_qary_eq m hm]
  exact (Real.qaryEntropy_strictMonoOn hm).monotoneOn hepsilon heta hle

/--
A monotone entropy-continuity bound for an alphabet of size `m`, in nats.

For `m ≥ 2`, this is binary entropy plus `epsilon * log (m - 1)` through
`1 - 1 / m`, including equality, and `log m` above that threshold. Nat
subtraction precedes the Real cast. The bound is zero for `m ≤ 1`; the
zero-cardinality case is only a scalar convention, since an empty alphabet
carries no PMF. Approximation guarantees concern nonnegative real budgets;
negative arguments have no such interpretation.
-/
noncomputable def entropyContinuityBound (m : Nat) (epsilon : Real) : Real :=
  if m ≤ 1 then 0
  else if epsilon ≤ 1 - 1 / (m : Real) then
    Real.binEntropy epsilon + epsilon * Real.log ((m - 1 : Nat) : Real)
  else Real.log (m : Real)

private theorem entropyContinuityBound_of_card_le_one (m : Nat) (hm : m ≤ 1)
    (epsilon : Real) : entropyContinuityBound m epsilon = 0 := by
  rw [entropyContinuityBound, if_pos hm]

private theorem entropyContinuityBound_zero (m : Nat) :
    entropyContinuityBound m 0 = 0 := by
  by_cases hm : m ≤ 1
  · exact entropyContinuityBound_of_card_le_one m hm 0
  · rw [entropyContinuityBound, if_neg hm,
      if_pos (continuity_threshold_range m (by omega)).1]
    simp only [Real.binEntropy_zero, zero_mul, add_zero]

private theorem entropyContinuityBound_at_threshold (m : Nat) (hm : 2 ≤ m) :
    entropyContinuityBound m (1 - 1 / (m : Real)) = Real.log (m : Real) := by
  rw [entropyContinuityBound, if_neg (by omega : ¬m ≤ 1), if_pos le_rfl,
    continuity_term_at_threshold m hm]

/-- The entropy-continuity bound is monotone on all nonnegative real budgets. -/
theorem entropyContinuityBound_mono (m : Nat) :
    MonotoneOn (entropyContinuityBound m) (Set.Ici (0 : Real)) := by
  intro epsilon hepsilon eta heta hle
  by_cases hm : m ≤ 1
  · simp only [entropyContinuityBound, if_pos hm, le_refl]
  · have hm2 : 2 ≤ m := by omega
    simp only [entropyContinuityBound, if_neg hm]
    split_ifs with he ht ht
    · exact continuity_term_mono m hm2 ⟨hepsilon, he⟩ ⟨heta, ht⟩ hle
    · exact (continuity_term_mono m hm2 ⟨hepsilon, he⟩
        ⟨(continuity_threshold_range m hm2).1, le_rfl⟩ he).trans_eq
          (continuity_term_at_threshold m hm2)
    · exact False.elim (he (hle.trans ht))
    · exact le_rfl

private theorem entropyContinuityBound_nonneg (m : Nat) {epsilon : Real}
    (hepsilon : 0 ≤ epsilon) : 0 ≤ entropyContinuityBound m epsilon := by
  have h := entropyContinuityBound_mono m
    (show 0 ∈ Set.Ici (0 : Real) by simp only [Set.mem_Ici, le_refl])
    hepsilon hepsilon
  rwa [entropyContinuityBound_zero] at h

private theorem entropyContinuityBound_le_log (m : Nat) (hm : 1 ≤ m)
    {epsilon : Real} (hepsilon : 0 ≤ epsilon) :
    entropyContinuityBound m epsilon ≤ Real.log (m : Real) := by
  by_cases hm1 : m ≤ 1
  · have hm_eq : m = 1 := by omega
    simp only [hm_eq, entropyContinuityBound, le_refl, if_true,
      Nat.cast_one, Real.log_one]
  · have hm2 : 2 ≤ m := by omega
    by_cases he : epsilon ≤ 1 - 1 / (m : Real)
    · have h := entropyContinuityBound_mono m hepsilon
        (continuity_threshold_range m hm2).1 he
      rwa [entropyContinuityBound_at_threshold m hm2] at h
    · simp only [entropyContinuityBound, if_neg hm1, if_neg he, le_refl]

private theorem entropyContinuityBound_saturated (m : Nat) (hm : 2 ≤ m)
    {epsilon : Real} (hepsilon : 1 - 1 / (m : Real) ≤ epsilon) :
    entropyContinuityBound m epsilon = Real.log (m : Real) := by
  by_cases he : epsilon ≤ 1 - 1 / (m : Real)
  · rw [le_antisymm he hepsilon, entropyContinuityBound_at_threshold m hm]
  · rw [entropyContinuityBound, if_neg (by omega : ¬m ≤ 1), if_neg he]

/--
An upper estimate for total variation controls the entropy difference by the
monotone capped bound for the whole common alphabet.

The premise itself implies `0 ≤ epsilon`; no upper restriction on `epsilon`
is required. Below the scalar threshold the proof uses the exact-distance
inequality and q-ary monotonicity. Above it, entropy lies between zero and
the logarithm of the alphabet cardinality. Singleton alphabets give zero,
and no extra nonemptiness or support premise is imposed.
-/
theorem abs_entropy_sub_le_entropyContinuityBound
    {alpha : Type u} [Fintype alpha] (p q : PMF alpha)
    {epsilon : Real} (hTV : PMF.totalVariation p q ≤ epsilon) :
    |entropy p - entropy q| ≤
      entropyContinuityBound (Fintype.card alpha) epsilon := by
  obtain ⟨a, _⟩ := p.support_nonempty
  let : Nonempty alpha := ⟨a⟩
  have hp := entropy_le_log_card p
  have hq := entropy_le_log_card q
  have hepsilon := (PMF.totalVariation_nonneg p q).trans hTV
  by_cases hm : Fintype.card alpha ≤ 1
  · have hm_eq : Fintype.card alpha = 1 := by
      have hpos := Fintype.card_pos (α := alpha)
      omega
    have hpzero : entropy p = 0 := le_antisymm
      (by simpa only [hm_eq, Nat.cast_one, Real.log_one] using hp) (entropy_nonneg p)
    have hqzero : entropy q = 0 := le_antisymm
      (by simpa only [hm_eq, Nat.cast_one, Real.log_one] using hq) (entropy_nonneg q)
    simp only [entropyContinuityBound, if_pos hm, hpzero, hqzero,
      sub_self, abs_zero, le_refl]
  · have hm2 : 2 ≤ Fintype.card alpha := by omega
    by_cases he : epsilon ≤ 1 - 1 / (Fintype.card alpha : Real)
    · rw [entropyContinuityBound, if_neg hm, if_pos he]
      exact (abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log p q).trans
        (continuity_term_mono (Fintype.card alpha) hm2
          ⟨PMF.totalVariation_nonneg p q, hTV.trans he⟩ ⟨hepsilon, he⟩ hTV)
    · rw [entropyContinuityBound, if_neg hm, if_neg he]
      exact abs_le.mpr ⟨by linarith [entropy_nonneg p], by linarith [entropy_nonneg q]⟩

/--
An upper estimate for joint total variation bounds the change in conditional
entropy of the first coordinate given the second. The joint and second-marginal
entropy terms use their respective whole-alphabet capped bounds at the same
budget. No support or additional nonemptiness premise is required.
-/
theorem abs_condEntropy_sub_le_entropyContinuityBound
    {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (p q : PMF (alpha × beta))
    {epsilon : Real} (hTV : PMF.totalVariation p q ≤ epsilon) :
    |condEntropy p - condEntropy q| ≤
      entropyContinuityBound (Fintype.card alpha * Fintype.card beta) epsilon +
        entropyContinuityBound (Fintype.card beta) epsilon := by
  have hjoint := abs_entropy_sub_le_entropyContinuityBound p q hTV
  rw [Fintype.card_prod] at hjoint
  have hsnd := abs_entropy_sub_le_entropyContinuityBound
    (sndMarginal p) (sndMarginal q) ((PMF.totalVariation_map_le p q Prod.snd).trans hTV)
  rcases abs_le.mp hjoint with ⟨hjl, hju⟩
  rcases abs_le.mp hsnd with ⟨hsl, hsu⟩
  rw [condEntropy_eq, condEntropy_eq]
  apply abs_le.mpr
  constructor <;> linarith

/--
An upper estimate for joint total variation bounds the change in mutual
information by the sum of the two marginal and joint entropy bounds. Each term
uses its own whole-alphabet cardinality, so their saturation thresholds may
differ. No support or additional nonemptiness premise is required.
-/
theorem abs_mutualInfo_sub_le_entropyContinuityBound
    {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (p q : PMF (alpha × beta))
    {epsilon : Real} (hTV : PMF.totalVariation p q ≤ epsilon) :
    |mutualInfo p - mutualInfo q| ≤
      entropyContinuityBound (Fintype.card alpha) epsilon +
        entropyContinuityBound (Fintype.card beta) epsilon +
          entropyContinuityBound (Fintype.card alpha * Fintype.card beta) epsilon := by
  have hjoint := abs_entropy_sub_le_entropyContinuityBound p q hTV
  rw [Fintype.card_prod] at hjoint
  have hfst := abs_entropy_sub_le_entropyContinuityBound
    (fstMarginal p) (fstMarginal q) ((PMF.totalVariation_map_le p q Prod.fst).trans hTV)
  have hsnd := abs_entropy_sub_le_entropyContinuityBound
    (sndMarginal p) (sndMarginal q) ((PMF.totalVariation_map_le p q Prod.snd).trans hTV)
  rcases abs_le.mp hfst with ⟨hfl, hfu⟩
  rcases abs_le.mp hsnd with ⟨hsl, hsu⟩
  rcases abs_le.mp hjoint with ⟨hjl, hju⟩
  rw [mutualInfo_eq, mutualInfo_eq]
  apply abs_le.mpr
  constructor <;> linarith

end LeanInfoTheory.Shannon
