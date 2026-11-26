/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.BinaryTesting

/-!
# Likelihood-threshold tests

`PMF.BinaryTest.likelihoodThresholdTest` compares the real alternative atom
mass with a nonnegative multiple of the real null atom mass. It rejects above
the threshold, accepts below it, and uses one common rejection probability on
the boundary. Alternative-only atoms are rejected at zero null size cost.
Common-null atoms receive the boundary probability and contribute zero to
both operating characteristics.

This is the finite mass formulation of Polyanskiy--Wu (2024), Sections
14.1--14.2 and Theorem 14.11 in Section 14.4. On jointly positive masses,
their log threshold `τ` corresponds to `c = exp (-τ)` and their boundary
acceptance probability `λ` corresponds to rejection probability `1 - λ`.
Their common-null log-likelihood convention can give a different pointwise
decision with the same size and power. The mass formulation also permits
threshold zero directly. Construction requires no finiteness assumption.
-/

namespace PMF.BinaryTest

open scoped NNReal BigOperators

universe u

variable {X : Type u}

/-- Reject above the alternative-to-null mass threshold, accept below it,
and reject with probability `γ` on its boundary. -/
noncomputable def likelihoodThresholdTest (P0 P1 : PMF X)
    (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1) : PMF.BinaryTest X := by
  classical
  exact fun x =>
    if (c : ℝ) * (P0 x).toReal < (P1 x).toReal then ⟨1, by norm_num⟩
    else if (P1 x).toReal < (c : ℝ) * (P0 x).toReal then ⟨0, by norm_num⟩
    else γ

open scoped Classical in
/-- The rejection weight is one above the threshold, zero below, and `γ` at equality. -/
theorem likelihoodThresholdTest_apply (P0 P1 : PMF X)
    (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1) (x : X) :
    (likelihoodThresholdTest P0 P1 c γ x : ℝ) =
      if (c : ℝ) * (P0 x).toReal < (P1 x).toReal then 1
      else if (P1 x).toReal < (c : ℝ) * (P0 x).toReal then 0
      else (γ : ℝ) := by
  simp only [likelihoodThresholdTest]
  split_ifs <;> rfl

variable [Fintype X]

/-- A likelihood-threshold test has at least the power of every randomized test
whose size is at most its own size. The threshold may be zero. -/
theorem power_le_power_likelihoodThresholdTest (P0 P1 : PMF X)
    (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1) (g : PMF.BinaryTest X)
    (hg : size g P0 ≤ size (likelihoodThresholdTest P0 P1 c γ) P0) :
    power g P1 ≤ power (likelihoodThresholdTest P0 P1 c γ) P1 := by
  classical
  let f := likelihoodThresholdTest P0 P1 c γ
  have hpoint (x : X) :
      (P1 x).toReal * (g x : ℝ) - (P1 x).toReal * (f x : ℝ) ≤
        (c : ℝ) * ((P0 x).toReal * (g x : ℝ) - (P0 x).toReal * (f x : ℝ)) := by
    have hsign : ((g x : ℝ) - (f x : ℝ)) *
        ((P1 x).toReal - (c : ℝ) * (P0 x).toReal) ≤ 0 := by
      dsimp only [f]
      rw [likelihoodThresholdTest_apply]
      split_ifs with hab hba
      · exact mul_nonpos_of_nonpos_of_nonneg
          (sub_nonpos.mpr (g x).property.2) (sub_nonneg.mpr hab.le)
      · exact mul_nonpos_of_nonneg_of_nonpos
          (by simpa using (g x).property.1) (sub_nonpos.mpr hba.le)
      · have heq : (P1 x).toReal = (c : ℝ) * (P0 x).toReal :=
          le_antisymm (le_of_not_gt hab) (le_of_not_gt hba)
        simp [heq]
    nlinarith only [hsign]
  have hsum := Finset.sum_le_sum (s := Finset.univ) (fun x _ => hpoint x)
  simp only [Finset.sum_sub_distrib, ← Finset.mul_sum] at hsum
  change power g P1 - power f P1 ≤ (c : ℝ) * (size g P0 - size f P0) at hsum
  have hsize : (c : ℝ) * (size g P0 - size f P0) ≤ 0 :=
    mul_nonpos_of_nonneg_of_nonpos c.property (sub_nonpos.mpr hg)
  linarith

/- Private finite calibration machinery. The masses below sum null weights,
including every tied atom; ratios are inspected on positive null support. -/
private noncomputable def likelihoodRatio (P0 P1 : PMF X) (x : X) : ℝ :=
  (P1 x).toReal / (P0 x).toReal

private noncomputable def strictTailMass (P0 P1 : PMF X) (c : ℝ) : ℝ := by
  classical
  exact ∑ x ∈ (P0.supportFinset).filter
    (fun x => c < likelihoodRatio P0 P1 x), (P0 x).toReal

private noncomputable def boundaryMass (P0 P1 : PMF X) (c : ℝ) : ℝ := by
  classical
  exact ∑ x ∈ (P0.supportFinset).filter
    (fun x => likelihoodRatio P0 P1 x = c), (P0 x).toReal

private noncomputable def weakTailMass (P0 P1 : PMF X) (c : ℝ) : ℝ := by
  classical
  exact ∑ x ∈ (P0.supportFinset).filter
    (fun x => c ≤ likelihoodRatio P0 P1 x), (P0 x).toReal

private theorem mem_supportFinset_toReal_pos (P0 : PMF X) (x : X) :
    x ∈ P0.supportFinset ↔ 0 < (P0 x).toReal := by
  rw [PMF.mem_supportFinset, PMF.mem_support_iff]
  constructor
  · intro hx
    exact ENNReal.toReal_pos hx (P0.apply_ne_top x)
  · intro hx hzero
    simp [hzero] at hx

private theorem sum_supportFinset_toReal (P0 : PMF X) :
    ∑ x ∈ P0.supportFinset, (P0 x).toReal = 1 := by
  classical
  calc
    ∑ x ∈ P0.supportFinset, (P0 x).toReal = ∑ x, (P0 x).toReal := by
      apply Finset.sum_subset (Finset.subset_univ _)
      intro x _ hx
      exact le_antisymm (le_of_not_gt (mt (mem_supportFinset_toReal_pos P0 x).mpr hx))
        (P0.toReal_nonneg x)
    _ = 1 := P0.sum_toReal

/- Null atoms have zero size contribution, including alternative-only atoms.
Division comparisons are used only after restriction to positive null support. -/
private theorem size_likelihoodThresholdTest_eq (P0 P1 : PMF X)
    (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1) :
    size (likelihoodThresholdTest P0 P1 c γ) P0 =
      strictTailMass P0 P1 c + (γ : ℝ) * boundaryMass P0 P1 c := by
  classical
  have hrestrict :
      (∑ x ∈ P0.supportFinset,
        (P0 x).toReal * (likelihoodThresholdTest P0 P1 c γ x : ℝ)) =
      ∑ x, (P0 x).toReal * (likelihoodThresholdTest P0 P1 c γ x : ℝ) := by
    apply Finset.sum_subset (Finset.subset_univ _)
    intro x _ hx
    have hnot : ¬ 0 < (P0 x).toReal := mt (mem_supportFinset_toReal_pos P0 x).mpr hx
    have hzero : (P0 x).toReal = 0 :=
      le_antisymm (le_of_not_gt hnot) (P0.toReal_nonneg x)
    simp [hzero]
  unfold size rejectProb
  rw [← hrestrict]
  unfold strictTailMass boundaryMass
  rw [Finset.sum_filter, Finset.sum_filter, Finset.mul_sum,
    ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro x hx
  have hp0 : 0 < (P0 x).toReal := (mem_supportFinset_toReal_pos P0 x).mp hx
  have hab : (c : ℝ) * (P0 x).toReal < (P1 x).toReal ↔
      (c : ℝ) < likelihoodRatio P0 P1 x :=
    (lt_div_iff₀ hp0).symm
  have hba : (P1 x).toReal < (c : ℝ) * (P0 x).toReal ↔
      likelihoodRatio P0 P1 x < (c : ℝ) :=
    (div_lt_iff₀ hp0).symm
  rw [likelihoodThresholdTest_apply]
  simp only [hab, hba]
  rcases lt_trichotomy (c : ℝ) (likelihoodRatio P0 P1 x) with hlt | heq | hgt
  · simp [hlt, ne_of_gt hlt]
  · simp [heq, mul_comm]
  · simp [hgt, not_lt.mpr hgt.le, ne_of_lt hgt]

private theorem weakTailMass_eq (P0 P1 : PMF X) (c : ℝ) :
    weakTailMass P0 P1 c = strictTailMass P0 P1 c + boundaryMass P0 P1 c := by
  classical
  unfold weakTailMass strictTailMass boundaryMass
  simp only [Finset.sum_filter]
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro x _
  rcases lt_trichotomy (likelihoodRatio P0 P1 x) c with h | h | h
  · simp [not_le_of_gt h, not_lt.mpr h.le, ne_of_lt h]
  · simp [h]
  · simp [h, h.le, ne_of_gt h]

private theorem boundaryMass_pos (P0 P1 : PMF X) (c : ℝ)
    (hc : ∃ x ∈ P0.supportFinset, likelihoodRatio P0 P1 x = c) :
    0 < boundaryMass P0 P1 c := by
  classical
  obtain ⟨x, hx, hr⟩ := hc
  apply Finset.sum_pos'
  · intro y _
    exact P0.toReal_nonneg y
  · exact ⟨x, Finset.mem_filter.mpr ⟨hx, hr⟩, (mem_supportFinset_toReal_pos P0 x).mp hx⟩

/- Maximize the realized levels whose weak null tail reaches the requested level.
The next greater realized level identifies the strict tail without sorting atoms. -/
private theorem exists_likelihoodThreshold_crossing (P0 P1 : PMF X) (a : ℝ)
    (ha : a ∈ Set.Icc (0 : ℝ) 1) :
    ∃ c : ℝ≥0,
      (∃ x ∈ P0.supportFinset, likelihoodRatio P0 P1 x = (c : ℝ)) ∧
      strictTailMass P0 P1 c ≤ a ∧
      a ≤ strictTailMass P0 P1 c + boundaryMass P0 P1 c ∧
      0 < boundaryMass P0 P1 c := by
  classical
  let S := P0.supportFinset
  let r := likelihoodRatio P0 P1
  let L := S.image r
  have hL : L.Nonempty := P0.supportFinset_nonempty.image r
  let m := L.min' hL
  have hmin (x : X) (hx : x ∈ S) : m ≤ r x :=
    L.min'_le _ (Finset.mem_image_of_mem r hx)
  have hWm : weakTailMass P0 P1 m = 1 := by
    have he : S.filter (fun x => m ≤ r x) = S :=
      Finset.filter_eq_self.mpr hmin
    change (∑ x ∈ S.filter (fun x => m ≤ r x), (P0 x).toReal) = 1
    rw [he]
    exact sum_supportFinset_toReal P0
  let A := L.filter (fun t => a ≤ weakTailMass P0 P1 t)
  have hA : A.Nonempty := by
    refine ⟨m, Finset.mem_filter.mpr ⟨L.min'_mem hL, ?_⟩⟩
    rw [hWm]
    exact ha.2
  let c := A.max' hA
  have hcA : c ∈ A := A.max'_mem hA
  have hcL : c ∈ L := (Finset.mem_filter.mp hcA).1
  have hcW : a ≤ weakTailMass P0 P1 c := (Finset.mem_filter.mp hcA).2
  have hU : strictTailMass P0 P1 c ≤ a := by
    by_cases hn : ∃ d ∈ L, c < d
    · obtain ⟨d, hdL, hcd, hnext⟩ := Finset.exists_next_right hn
      have hdnot : ¬ a ≤ weakTailMass P0 P1 d := by
        intro hd
        have hdA : d ∈ A := Finset.mem_filter.mpr ⟨hdL, hd⟩
        exact (not_le_of_gt hcd) (A.le_max' d hdA)
      have he : S.filter (fun x => c < r x) = S.filter (fun x => d ≤ r x) := by
        ext x
        simp only [Finset.mem_filter]
        constructor
        · rintro ⟨hx, hr⟩
          exact ⟨hx, hnext (r x) (Finset.mem_image_of_mem r hx) hr⟩
        · rintro ⟨hx, hr⟩
          exact ⟨hx, hcd.trans_le hr⟩
      have hUW : strictTailMass P0 P1 c = weakTailMass P0 P1 d := by
        change (∑ x ∈ S.filter (fun x => c < r x), (P0 x).toReal) =
          ∑ x ∈ S.filter (fun x => d ≤ r x), (P0 x).toReal
        rw [he]
      rw [hUW]
      exact (lt_of_not_ge hdnot).le
    · have he : S.filter (fun x => c < r x) = ∅ := by
        apply Finset.eq_empty_of_forall_notMem
        intro x hx
        obtain ⟨hxS, hr⟩ := Finset.mem_filter.mp hx
        exact hn ⟨r x, Finset.mem_image_of_mem r hxS, hr⟩
      have hUz : strictTailMass P0 P1 c = 0 := by
        change (∑ x ∈ S.filter (fun x => c < r x), (P0 x).toReal) = 0
        rw [he, Finset.sum_empty]
      rw [hUz]
      exact ha.1
  obtain ⟨x, hxS, hr⟩ := Finset.mem_image.mp hcL
  have hcn : 0 ≤ c := by
    rw [← hr]
    exact div_nonneg (P1.toReal_nonneg x) (P0.toReal_nonneg x)
  refine ⟨⟨c, hcn⟩, ⟨x, hxS, hr⟩, hU, ?_, ?_⟩
  · rw [← weakTailMass_eq]
    exact hcW
  · exact boundaryMass_pos P0 P1 c ⟨x, hxS, hr⟩

/-- At every prescribed level in the closed unit interval, one randomized
likelihood-threshold test has exactly that size and dominates every randomized
competitor under the size cap. The threshold and common boundary weight are
chosen before the competitor. No support inclusion is required. -/
theorem exists_likelihoodThresholdTest (P0 P1 : PMF X) (a : ℝ)
    (ha : a ∈ Set.Icc (0 : ℝ) 1) :
    ∃ (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1),
      let fStar := likelihoodThresholdTest P0 P1 c γ
      size fStar P0 = a ∧
        ∀ g : PMF.BinaryTest X, size g P0 ≤ a → power g P1 ≤ power fStar P1 := by
  obtain ⟨c, _, hU, hUB, hB⟩ := exists_likelihoodThreshold_crossing P0 P1 a ha
  let γ : Set.Icc (0 : ℝ) 1 :=
    ⟨(a - strictTailMass P0 P1 c) / boundaryMass P0 P1 c,
      div_nonneg (sub_nonneg.mpr hU) hB.le,
      (div_le_one hB).mpr (by linarith)⟩
  have hsize : size (likelihoodThresholdTest P0 P1 c γ) P0 = a := by
    rw [size_likelihoodThresholdTest_eq]
    change strictTailMass P0 P1 c +
      ((a - strictTailMass P0 P1 c) / boundaryMass P0 P1 c) * boundaryMass P0 P1 c = a
    rw [div_mul_cancel₀ _ (ne_of_gt hB)]
    ring
  refine ⟨c, γ, hsize, ?_⟩
  intro g hg
  exact power_le_power_likelihoodThresholdTest P0 P1 c γ g (by simpa [hsize] using hg)

end PMF.BinaryTest
