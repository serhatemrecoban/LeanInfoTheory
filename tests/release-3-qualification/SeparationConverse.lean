/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceChannelConverse

/-! Arbitrary word maps under one joint law, including correlated channel inputs and the empty block. -/

namespace LeanInfoTheory.Qualification.SeparationConverse

open LeanInfoTheory.Shannon Filter

universe u v w

variable {S : Type u} {X : Type v} {Y : Type w}

private noncomputable abbrev experiment [Fintype S] [Fintype Y] (p : PMF S) (W : X → PMF Y) (n : ℕ)
    (E : (Fin n → S) → (Fin n → X)) :=
  PMF.channelJoint (PMF.iid p n) (fun s => PMF.memorylessChannel W n (E s))

section Arbitrary

variable [Fintype S] [Fintype X] [Nonempty X] [Fintype Y] (p : PMF S) (W : X → PMF Y)

-- Applying the encoder to the first coordinate gives the actual input prior, even for collisions.
example (n : ℕ) (E : (Fin n → S) → (Fin n → X)) (D : (Fin n → Y) → (Fin n → S)) :
    (experiment p W n E).map (fun z => (E z.1, z.2)) =
        PMF.channelJoint ((PMF.iid p n).map E) (PMF.memorylessChannel W n) ∧
    (n : ℝ) * entropy p ≤ (n : ℝ) * channelCapacity W + Real.log 2 +
      decodingErrorProbability (experiment p W n E) D * n * Real.log (Fintype.card S : ℝ) := by
  constructor
  · simp only [experiment, PMF.channelJoint, PMF.map_bind, PMF.bind_map, PMF.map_comp,
      Function.comp_def]
  · exact mul_entropy_le_mul_channelCapacity_add_error p W n E D

-- At length zero each decoder reconstructs the only word; the undivided Fano inequality still applies.
example (E : (Fin 0 → S) → (Fin 0 → X)) (D : (Fin 0 → Y) → (Fin 0 → S)) :
    decodingErrorProbability (experiment p W 0 E) D = 0 ∧ (0 : ℝ) ≤ Real.log 2 := by
  classical
  constructor
  · rw [decodingErrorProbability_eq_sum]
    apply Finset.sum_eq_zero
    intro z _
    exact if_neg (not_not_intro (Subsingleton.elim _ _))
  · simpa using mul_entropy_le_mul_channelCapacity_add_error p W 0 E D

example (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X))
    (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S))
    (h : Tendsto (fun n => decodingErrorProbability (experiment p W n (E n)) (D n))
      atTop (nhds 0)) :
    entropy p ≤ channelCapacity W :=
  entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability p W E D h

end Arbitrary

-- The induced input repeats the first source bit. Both coordinates have the original marginal,
-- while an unequal pair has zero mass and has strictly positive iid mass.
private def repeated (s : Fin 2 → Bool) : Fin 2 → Bool := fun _ => s 0

example [Fintype Y] (p : PMF Bool) (hf : p false ≠ 0) (ht : p true ≠ 0)
    (W : Bool → PMF Y) (D : (Fin 2 → Y) → (Fin 2 → Bool)) :
    let q := PMF.iid p 2
    let input := q.map repeated
    (∀ i : Fin 2, input.map (fun x => x i) = p) ∧ input ≠ q ∧
      2 * entropy p ≤ 2 * channelCapacity W + Real.log 2 +
        decodingErrorProbability (experiment p W 2 repeated) D * 2 * Real.log (Fintype.card Bool : ℝ) := by
  dsimp only
  refine ⟨?_, ?_, ?_⟩
  · intro i
    rw [PMF.map_comp]
    exact PMF.finiteProduct_map_eval (fun _ : Fin 2 => p) 0
  · have absent : ((PMF.iid p 2).map repeated) ![false, true] = 0 := by
      apply PMF.map_apply_eq_zero_of_notMem_range
      rintro ⟨s, hs⟩
      have h0 : s 0 = false := congrFun hs 0
      have h1 : s 0 = true := congrFun hs 1
      simp [h0] at h1
    have present : PMF.iid p 2 ![false, true] ≠ 0 := by
      change PMF.finiteProduct (fun _ : Fin 2 => p) ![false, true] ≠ 0
      rw [PMF.finiteProduct_apply, Fin.prod_univ_two]
      exact mul_ne_zero hf ht
    intro equality
    exact present (by simpa only [equality] using absent)
  · simpa [sourceChannelErrorProbability, experiment] using
      mul_entropy_le_mul_channelCapacity_add_error p W 2 repeated D

end LeanInfoTheory.Qualification.SeparationConverse
