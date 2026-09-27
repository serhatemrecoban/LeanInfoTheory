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
import LeanInfoTheory.Shannon.SemanticBridge.Product

/-!
# Coupling consumers for Fano and product measures

These private consumers pass the actual maximal coupling witness and its
coordinate swap to the existing Fano API. Both identity decoders have error
equal to the same total variation, and the four ordered marginals agree with
the prescribed laws. Equal laws and subsingleton alphabets give zero errors
and zero conditional entropies in both orientations.

Independent coupling agrees with the existing Shannon product law and its
product measure and measurable rectangle semantics. Measurable-space premises
are confined to those consumers. Construction access uses the public coupling API;
the conditional-entropy bounds use canonical nats.
-/

namespace LeanInfoTheory.Examples.CouplingFano

universe u v

open LeanInfoTheory.Shannon

private theorem independent_eq_indepProd {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF beta) :
    PMF.channelJoint p (fun _ => q) = indepProd p q := rfl

private theorem independent_semantic_marginals {alpha : Type u} {beta : Type v}
    (p : PMF alpha) (q : PMF beta) :
    PMF.IsCoupling (PMF.channelJoint p (fun _ => q)) p q ∧
      fstMarginal (PMF.channelJoint p (fun _ => q)) = p ∧
      sndMarginal (PMF.channelJoint p (fun _ => q)) = q := by
  have h := PMF.isCoupling_channelJoint_const p q
  exact ⟨h, h.1, h.2⟩

private theorem independent_toMeasure {alpha : Type u} {beta : Type v}
    [MeasurableSpace alpha] [MeasurableSpace beta]
    (p : PMF alpha) (q : PMF beta) :
    (PMF.channelJoint p (fun _ => q)).toMeasure =
      MeasureTheory.Measure.prod p.toMeasure q.toMeasure := by
  rw [independent_eq_indepProd]
  exact indepProd_toMeasure p q

private theorem independent_rectangle {alpha : Type u} {beta : Type v}
    [MeasurableSpace alpha] [MeasurableSpace beta]
    (p : PMF alpha) (q : PMF beta) {s : Set alpha} {t : Set beta}
    (hs : MeasurableSet s) (ht : MeasurableSet t) :
    (PMF.channelJoint p (fun _ => q)).toMeasure (Set.prod s t) =
      p.toMeasure s * q.toMeasure t := by
  rw [independent_eq_indepProd]
  exact indepProd_toMeasure_prod p q hs ht

private theorem disagreement_map_swap {alpha : Type u}
    (joint : PMF (alpha × alpha)) :
    (joint.map Prod.swap).toOuterMeasure {xy | xy.1 ≠ xy.2} =
      joint.toOuterMeasure {xy | xy.1 ≠ xy.2} := by
  rw [PMF.toOuterMeasure_map_apply]
  congr 1
  ext xy
  change (xy.2 ≠ xy.1) ↔ (xy.1 ≠ xy.2)
  exact ne_comm

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

private theorem maximal_semantic_marginals {alpha : Type u} [Fintype alpha]
    (p q : PMF alpha) :
    fstMarginal (PMF.maximalCoupling p q) = p ∧
      sndMarginal (PMF.maximalCoupling p q) = q ∧
      fstMarginal ((PMF.maximalCoupling p q).map Prod.swap) = q ∧
      sndMarginal ((PMF.maximalCoupling p q).map Prod.swap) = p := by
  have h := PMF.isCoupling_maximalCoupling p q
  have hs := h.map_swap
  exact ⟨h.1, h.2, hs.1, hs.2⟩

private theorem maximal_disagreement_both_orders {alpha : Type u} [Fintype alpha]
    (p q : PMF alpha) :
    (PMF.maximalCoupling p q).toOuterMeasure {xy | xy.1 ≠ xy.2} =
        ENNReal.ofReal (PMF.totalVariation p q) ∧
      ((PMF.maximalCoupling p q).map Prod.swap).toOuterMeasure {xy | xy.1 ≠ xy.2} =
        ENNReal.ofReal (PMF.totalVariation p q) := by
  refine ⟨PMF.maximalCoupling_toOuterMeasure_ne p q, ?_⟩
  rw [disagreement_map_swap, PMF.maximalCoupling_toOuterMeasure_ne]

private theorem maximal_decoder_errors {alpha : Type u} [Fintype alpha]
    (p q : PMF alpha) :
    decodingErrorProbability (PMF.maximalCoupling p q) id = PMF.totalVariation p q ∧
      decodingErrorProbability ((PMF.maximalCoupling p q).map Prod.swap) id =
        PMF.totalVariation p q := by
  constructor
  · rw [identity_error_eq_disagreement, PMF.maximalCoupling_toOuterMeasure_ne_toReal]
  · rw [identity_error_eq_disagreement, disagreement_map_swap,
      PMF.maximalCoupling_toOuterMeasure_ne_toReal]

private theorem maximal_fano_both_orders {alpha : Type u} [Fintype alpha]
    (p q : PMF alpha) :
    condEntropy (PMF.maximalCoupling p q) ≤
        Real.binEntropy (PMF.totalVariation p q) +
          PMF.totalVariation p q * Real.log ((Fintype.card alpha - 1 : Nat) : Real) ∧
      condEntropy ((PMF.maximalCoupling p q).map Prod.swap) ≤
        Real.binEntropy (PMF.totalVariation p q) +
          PMF.totalVariation p q * Real.log ((Fintype.card alpha - 1 : Nat) : Real) := by
  have he := maximal_decoder_errors p q
  constructor
  · simpa only [he.1] using condEntropy_fano (PMF.maximalCoupling p q) id
  · simpa only [he.2] using condEntropy_fano ((PMF.maximalCoupling p q).map Prod.swap) id

private theorem equal_law_fano {alpha : Type u} [Fintype alpha] (p : PMF alpha) :
    decodingErrorProbability (PMF.maximalCoupling p p) id = 0 ∧
      decodingErrorProbability ((PMF.maximalCoupling p p).map Prod.swap) id = 0 ∧
      condEntropy (PMF.maximalCoupling p p) = 0 ∧
      condEntropy ((PMF.maximalCoupling p p).map Prod.swap) = 0 := by
  have he : decodingErrorProbability (PMF.maximalCoupling p p) id = 0 ∧
      decodingErrorProbability ((PMF.maximalCoupling p p).map Prod.swap) id = 0 := by
    simpa only [PMF.totalVariation_self] using maximal_decoder_errors p p
  have hf : condEntropy (PMF.maximalCoupling p p) ≤ 0 ∧
      condEntropy ((PMF.maximalCoupling p p).map Prod.swap) ≤ 0 := by
    simpa only [PMF.totalVariation_self, Real.binEntropy_zero, zero_mul, zero_add] using
      maximal_fano_both_orders p p
  exact ⟨he.1, he.2,
    le_antisymm hf.1 (condEntropy_nonneg (PMF.maximalCoupling p p)),
    le_antisymm hf.2 (condEntropy_nonneg ((PMF.maximalCoupling p p).map Prod.swap))⟩

private theorem subsingleton_fano {alpha : Type u} [Fintype alpha] [Subsingleton alpha]
    (p q : PMF alpha) :
    p = q ∧
      decodingErrorProbability (PMF.maximalCoupling p q) id = 0 ∧
      decodingErrorProbability ((PMF.maximalCoupling p q).map Prod.swap) id = 0 ∧
      condEntropy (PMF.maximalCoupling p q) = 0 ∧
      condEntropy ((PMF.maximalCoupling p q).map Prod.swap) = 0 := by
  have hevent : {xy : alpha × alpha | xy.1 ≠ xy.2} = (∅ : Set (alpha × alpha)) := by
    ext xy
    simp [Subsingleton.elim xy.1 xy.2]
  have htv : PMF.totalVariation p q = 0 := by
    rw [← PMF.maximalCoupling_toOuterMeasure_ne_toReal, hevent]
    simp
  have hpq := (PMF.totalVariation_eq_zero_iff p q).1 htv
  subst q
  exact ⟨rfl, equal_law_fano p⟩

end LeanInfoTheory.Examples.CouplingFano
