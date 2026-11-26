/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceCoding
import LeanInfoTheory.Shannon.ChannelCodeExpurgation

/-!
# Block error for deterministic source–channel codes

The source word is drawn from the iid law. Its encoding determines the
memoryless channel row from which the output word is drawn. The decoder
reconstructs the source word from that output (CT91 §8.13, (8.142)).
For a composition of codes at a common budget, the channel error is
averaged under the source encoder’s output law (PW24 §19.7).
-/

namespace LeanInfoTheory.Shannon

open scoped BigOperators

universe u v w

/-- Probability that a total decoder fails to reconstruct the original iid
source word after one memoryless channel use per source symbol. -/
noncomputable def sourceChannelErrorProbability {S : Type u} {X : Type v} {Y : Type w}
    [Fintype S] [Fintype Y] (p : PMF S) (W : X → PMF Y) (n : ℕ)
    (E : (Fin n → S) → (Fin n → X)) (D : (Fin n → Y) → (Fin n → S)) : ℝ :=
  decodingErrorProbability
    (PMF.channelJoint (PMF.iid p n) (fun s => PMF.memorylessChannel W n (E s))) D

private theorem sum_map_toReal_mul {A : Type u} {B : Type v}
    [Fintype A] [Fintype B] (q : PMF A) (f : A → B) (g : B → ℝ) :
    (∑ b, (q.map f b).toReal * g b) = ∑ s, (q s).toReal * g (f s) := by
  classical
  simp only [PMF.map, PMF.bind_toReal_apply, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro s _
  simp [PMF.pure_apply, apply_ite, ite_mul]

/-- Reconstructing after compression and transmission fails only if the
source decoder fails on the sent index or the channel decoder returns a
different index. Channel errors are averaged under the compressor's output law. -/
theorem sourceChannelErrorProbability_comp_le {S : Type u} {X : Type v} {Y : Type w}
    [Fintype S] [Fintype Y] {n K : ℕ} (p : PMF S) (W : X → PMF Y)
    (a : BlockSourceCode S n K) (b : BlockChannelCode X Y n K) :
    sourceChannelErrorProbability p W n (b.encoder ∘ a.encoder) (a.decoder ∘ b.decoder) ≤
      a.errorProbability (PMF.iid p n) +
        b.errorProbabilityWithPrior W ((PMF.iid p n).map a.encoder) := by
  classical
  let q := PMF.iid p n
  let row (s : Fin n → S) := PMF.memorylessChannel W n (b.encoder (a.encoder s))
  have sourceError : a.errorProbability q =
      ∑ s, if a.decoder (a.encoder s) ≠ s then (q s).toReal else 0 := by
    rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure,
      PMF.toOuterMeasure_apply_fintype, ENNReal.toReal_sum]
    · apply Finset.sum_congr rfl
      intro s _
      by_cases h : a.decoder (a.encoder s) = s <;> simp [h]
    · intro s _
      by_cases h : a.decoder (a.encoder s) = s <;>
        simp [h, q.apply_ne_top]
  have channelError : b.errorProbabilityWithPrior W (q.map a.encoder) =
      ∑ s, (q s).toReal * b.messageErrorProbability W (a.encoder s) := by
    rw [b.errorProbabilityWithPrior_eq_sum, sum_map_toReal_mul]
  change decodingErrorProbability (PMF.channelJoint q row) (a.decoder ∘ b.decoder) ≤
    a.errorProbability q + b.errorProbabilityWithPrior W (q.map a.encoder)
  rw [decodingErrorProbability_eq_sum, Fintype.sum_prod_type, sourceError, channelError,
    ← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro s _
  simp only [Function.comp_apply, PMF.channelJoint_apply, ENNReal.toReal_mul]
  have atomBound (y : Fin n → Y) :
      (if a.decoder (b.decoder y) ≠ s then (q s).toReal * (row s y).toReal else 0) ≤
      (if a.decoder (a.encoder s) ≠ s then (q s).toReal else 0) * (row s y).toReal +
      (q s).toReal * (if b.decoder y ≠ a.encoder s then (row s y).toReal else 0) := by
    by_cases correct : b.decoder y = a.encoder s
    · by_cases recovered : a.decoder (a.encoder s) = s <;> simp [correct, recovered]
    · have hmass := mul_nonneg (q.toReal_nonneg s) ((row s).toReal_nonneg y)
      by_cases recovered : a.decoder (a.encoder s) = s <;>
        simp [correct, recovered] <;> split <;> linarith
  refine (Finset.sum_le_sum fun y _ => atomBound y).trans_eq ?_
  rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum,
    (row s).sum_toReal, mul_one]
  rfl

end LeanInfoTheory.Shannon
