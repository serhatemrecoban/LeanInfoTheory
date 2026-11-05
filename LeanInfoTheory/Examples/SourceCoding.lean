/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SourceCoding

/-!
# Deterministic source-code consumers

These private consumers exercise a genuinely colliding encoder, exact fair-binary
success and error, and the type-generic failure-event identity. Public one-shot
endpoints are exercised for arbitrary laws, empty selected sets, exact and spare
budgets, and a sparse correlated two-letter law. The same empty-set construction
witness has extra successes and a strict error bound. Zero-mass selected words
are recovered, and an excess budget has an actual unused message index.
Constructed fair, pure and singleton sources exercise both one-shot endpoints.
Arbitrary zero-length codes and explicit zero-message impossibility distinguish
an empty alphabet from its inhabited empty-word space.
-/

namespace LeanInfoTheory.Examples.SourceCoding

noncomputable section

universe u

open LeanInfoTheory.Shannon

private def lossy : SourceCode Bool 1 := (fun _ => 0, fun _ => false)

private theorem lossy_not_injective : ¬ Function.Injective lossy.encoder := by
  intro h
  have hbad : false = true := h (by rfl)
  cases hbad

private theorem lossy_successSet : lossy.successSet = {false} := by
  ext x
  simp only [SourceCode.mem_successSet, Finset.mem_singleton]
  change (false = x) ↔ x = false
  exact eq_comm

private theorem lossy_count : lossy.successSet.card ≤ 1 :=
  lossy.card_successSet_le

private theorem lossy_error : lossy.errorProbability (PMF.uniformOfFintype Bool) = 1 / 2 := by
  rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure]
  have hfail : {x : Bool | lossy.decoder (lossy.encoder x) ≠ id x} = {true} := by
    ext x
    cases x <;> simp [lossy, SourceCode.encoder, SourceCode.decoder]
  rw [hfail, PMF.toOuterMeasure_apply_singleton]
  norm_num [PMF.uniformOfFintype_apply]

private theorem lossy_success :
    ((PMF.uniformOfFintype Bool).toOuterMeasure (lossy.successSet : Set Bool)).toReal =
      1 / 2 := by
  rw [lossy.successProbability_eq_one_sub_errorProbability, lossy_error]
  norm_num

private theorem infinite_error_event :
    decodingErrorProbabilityOf (PMF.pure (1 : ℕ)) id id (fun _ : ℕ => 0) = 1 := by
  rw [decodingErrorProbabilityOf_eq_toOuterMeasure]
  simp

private theorem law_free_construction {X : Type u} [Finite X] [Nonempty X]
    (T : Finset X) {M : ℕ} (hT : T.card ≤ M) (hM : 1 ≤ M) :
    ∃ c : SourceCode X M, ∀ x ∈ T, c.decoder (c.encoder x) = x :=
  exists_sourceCode_correctOn T hT hM

private theorem arbitrary_law_bounds {X : Type u} [Fintype X]
    (q : PMF X) (T : Finset X) {M : ℕ} (hT : T.card ≤ M) (hM : 1 ≤ M)
    (b : ℝ) (hb : 0 ≤ b) (hcap : ∀ x ∈ T, (q x).toReal ≤ b) :
    (∃ c : SourceCode X M, (∀ x ∈ T, c.decoder (c.encoder x) = x) ∧
      c.errorProbability q ≤ (q.toOuterMeasure (T : Set X)ᶜ).toReal) ∧
    (∀ c : SourceCode X M, (q.toOuterMeasure (c.successSet : Set X)).toReal ≤
      (q.toOuterMeasure (T : Set X)ᶜ).toReal + (M : ℝ) * b) :=
  ⟨exists_sourceCode_errorProbability_le q T hT hM,
    fun c => c.successProbability_le q T b hb hcap⟩

private theorem lossy_converse :
    ((PMF.uniformOfFintype Bool).toOuterMeasure (lossy.successSet : Set Bool)).toReal ≤
      1 / 2 := by
  have h := lossy.successProbability_le (PMF.uniformOfFintype Bool) Finset.univ
    (1 / 2) (by norm_num) (by intro x _; norm_num [PMF.uniformOfFintype_apply])
  simpa using h

private theorem lossy_converse_attained :
    ((PMF.uniformOfFintype Bool).toOuterMeasure (lossy.successSet : Set Bool)).toReal =
      1 / 2 ∧ (1 / 2 : ℝ) < 1 := ⟨lossy_success, by norm_num⟩

private theorem one_message_error (c : SourceCode Bool 1) :
    c.errorProbability (PMF.uniformOfFintype Bool) = 1 / 2 := by
  have henc (x : Bool) : c.encoder x = 0 := Subsingleton.elim _ _
  have hset : c.successSet = {c.decoder 0} := by
    ext x
    simp only [SourceCode.mem_successSet, Finset.mem_singleton, henc]
    exact eq_comm
  have h := c.successProbability_eq_one_sub_errorProbability (PMF.uniformOfFintype Bool)
  rw [hset, Finset.coe_singleton, PMF.toOuterMeasure_apply_singleton] at h
  norm_num [PMF.uniformOfFintype_apply] at h
  linarith

private theorem empty_construction_strict :
    ∃ c : SourceCode Bool 1,
      (∀ x ∈ (∅ : Finset Bool), c.decoder (c.encoder x) = x) ∧
      c.errorProbability (PMF.uniformOfFintype Bool) <
        ((PMF.uniformOfFintype Bool).toOuterMeasure ((∅ : Finset Bool) : Set Bool)ᶜ).toReal ∧
      ∃ x, x ∉ (∅ : Finset Bool) ∧ c.decoder (c.encoder x) = x := by
  obtain ⟨c, hc, _⟩ := exists_sourceCode_errorProbability_le
    (PMF.uniformOfFintype Bool) ∅ (M := 1) (by simp) (by decide)
  refine ⟨c, hc, ?_, c.decoder 0, Finset.notMem_empty _, ?_⟩
  · rw [one_message_error]
    norm_num [PMF.toOuterMeasure_apply]
  · have henc : c.encoder (c.decoder 0) = 0 := Subsingleton.elim _ _
    rw [henc]

private theorem empty_converse (q : PMF Bool) (c : SourceCode Bool 1) :
    (q.toOuterMeasure (c.successSet : Set Bool)).toReal ≤ 1 := by
  have h := c.successProbability_le q ∅ 0 le_rfl (by simp)
  have huniv : q.toOuterMeasure (Set.univ : Set Bool) = 1 := by
    rw [PMF.toOuterMeasure_apply, Set.indicator_univ, q.tsum_coe]
  simpa only [Finset.coe_empty, Set.compl_empty, mul_zero, add_zero,
    huniv, ENNReal.toReal_one] using h

private def repeatWord (b : Bool) : Fin 2 → Bool := fun _ => b

private theorem repeatWord_injective : Function.Injective repeatWord :=
  fun _ _ h => congrFun h 0

private def diagonal : PMF (Fin 2 → Bool) :=
  (PMF.uniformOfFintype Bool).map repeatWord

private def mixedWord : Fin 2 → Bool := fun i => if i = 0 then false else true

private theorem mixedWord_not_repeated : mixedWord ∉ Set.range repeatWord := by
  rintro ⟨b, hb⟩
  have hzero := congrFun hb 0
  have hone := congrFun hb 1
  cases b <;> simp [repeatWord, mixedWord] at hzero hone

private theorem diagonal_mixed_zero : diagonal mixedWord = 0 :=
  PMF.map_apply_eq_zero_of_notMem_range _ mixedWord_not_repeated

private theorem diagonal_marginal (i : Fin 2) :
    diagonal.map (fun w => w i) = PMF.uniformOfFintype Bool := by
  rw [diagonal, PMF.map_comp]
  exact PMF.map_id _

private theorem diagonal_correlated :
    diagonal mixedWord ≠
      (diagonal.map (fun w => w 0)) (mixedWord 0) *
        (diagonal.map (fun w => w 1)) (mixedWord 1) := by
  rw [diagonal_mixed_zero, diagonal_marginal, diagonal_marginal]
  norm_num [mixedWord, PMF.uniformOfFintype_apply]

private def diagonalSet : Finset (Fin 2 → Bool) := {repeatWord false, repeatWord true}

private theorem diagonalSet_card : diagonalSet.card = 2 := by
  simp [diagonalSet, repeatWord_injective.ne Bool.false_ne_true]

private theorem diagonal_complement :
    (diagonal.toOuterMeasure (diagonalSet : Set (Fin 2 → Bool))ᶜ).toReal = 0 := by
  rw [diagonal, PMF.toOuterMeasure_map_apply]
  have hpre : repeatWord ⁻¹' (diagonalSet : Set (Fin 2 → Bool))ᶜ = ∅ := by
    ext b
    cases b <;> simp [diagonalSet]
  rw [hpre]
  simp

private theorem diagonal_construction :
    ∃ c : BlockSourceCode Bool 2 2,
      (∀ w ∈ diagonalSet, c.decoder (c.encoder w) = w) ∧
      c.errorProbability diagonal = 0 := by
  obtain ⟨c, hc, he⟩ := exists_sourceCode_errorProbability_le diagonal diagonalSet
    (M := 2) (by rw [diagonalSet_card]) (by decide)
  refine ⟨c, hc, le_antisymm ?_ (decodingErrorProbabilityOf_nonneg _ _ _ _)⟩
  simpa only [diagonal_complement] using he

private theorem diagonal_atom_cap (w : Fin 2 → Bool) : (diagonal w).toReal ≤ 1 / 2 := by
  by_cases hw : w ∈ Set.range repeatWord
  · obtain ⟨b, rfl⟩ := hw
    rw [diagonal, PMF.map_apply_of_injective _ repeatWord_injective]
    norm_num [PMF.uniformOfFintype_apply]
  · rw [diagonal, PMF.map_apply_eq_zero_of_notMem_range _ hw]
    norm_num

private theorem diagonal_converse (c : BlockSourceCode Bool 2 1) :
    (diagonal.toOuterMeasure (c.successSet : Set (Fin 2 → Bool))).toReal ≤ 1 / 2 := by
  have h := c.successProbability_le diagonal Finset.univ (1 / 2) (by norm_num)
    (fun w _ => diagonal_atom_cap w)
  simpa using h

private theorem selected_zero_mass_word :
    ∃ c : BlockSourceCode Bool 2 2,
      c.decoder (c.encoder mixedWord) = mixedWord ∧
      diagonal mixedWord = 0 ∧
      c.errorProbability diagonal ≤
        (diagonal.toOuterMeasure ({repeatWord false, mixedWord} : Set (Fin 2 → Bool))ᶜ).toReal := by
  have hcard : ({repeatWord false, mixedWord} : Finset (Fin 2 → Bool)).card ≤ 2 :=
    (Finset.card_insert_le _ _).trans (by simp)
  obtain ⟨c, hc, he⟩ := exists_sourceCode_errorProbability_le diagonal
    {repeatWord false, mixedWord} hcard (by decide)
  exact ⟨c, hc mixedWord (by simp), diagonal_mixed_zero, by simpa using he⟩

private theorem spare_message_index :
    ∃ c : SourceCode Bool 3,
      (∀ x, c.decoder (c.encoder x) = x) ∧
      c.errorProbability (PMF.uniformOfFintype Bool) = 0 ∧
      ∃ j : Fin 3, ∀ x : Bool, c.encoder x ≠ j := by
  obtain ⟨c, hc, he⟩ := exists_sourceCode_errorProbability_le
    (PMF.uniformOfFintype Bool) Finset.univ (M := 3) (by decide) (by decide)
  refine ⟨c, fun x => hc x (Finset.mem_univ x), ?_, ?_⟩
  · apply le_antisymm _ (decodingErrorProbabilityOf_nonneg _ _ _ _)
    simpa using he
  · have hnot : ¬ Function.Surjective c.encoder := by
      intro h
      have hcard := Fintype.card_le_of_surjective c.encoder h
      norm_num at hcard
    obtain ⟨j, hj⟩ := not_forall.mp hnot
    exact ⟨j, fun x hx => hj ⟨x, hx⟩⟩


private theorem law_forces_positive_budget {X : Type u} {M : ℕ}
    (q : PMF X) (c : SourceCode X M) : 1 ≤ M := by
  obtain ⟨x, _⟩ := q.support_nonempty
  exact Nat.succ_le_of_lt (lt_of_le_of_lt (Nat.zero_le _) (c.encoder x).isLt)

private def emptySourceZeroCode : SourceCode Empty 0 := (Empty.elim, Fin.elim0)

private def emptyWordCode : BlockSourceCode Empty 0 1 :=
  (fun _ => 0, fun _ => fun i => Fin.elim0 i)

private theorem emptyWordCode_error :
    emptyWordCode.errorProbability (PMF.pure (fun i : Fin 0 => Fin.elim0 i)) = 0 := by
  rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure]
  have hfail : {x : Fin 0 → Empty |
      emptyWordCode.decoder (emptyWordCode.encoder x) ≠ id x} = ∅ := by
    ext x
    simp only [Set.mem_ofPred_eq, Set.mem_empty_iff_false, iff_false, not_not, id_eq]
    funext i
    exact Fin.elim0 i
  rw [hfail]
  simp

/-! ## Constructed fair codes and degenerate source boundaries -/

private theorem constructed_fair_singleton :
    ∃ c : SourceCode Bool 1,
      c.decoder (c.encoder false) = false ∧
      c.errorProbability (PMF.uniformOfFintype Bool) = 1 / 2 := by
  have hlower (d : SourceCode Bool 1) :
      (1 / 2 : ℝ) ≤ d.errorProbability (PMF.uniformOfFintype Bool) := by
    have hs := d.successProbability_le (PMF.uniformOfFintype Bool) Finset.univ
      (1 / 2) (by norm_num)
      (by intro x _; norm_num [PMF.uniformOfFintype_apply])
    rw [d.successProbability_eq_one_sub_errorProbability
      (PMF.uniformOfFintype Bool)] at hs
    have hs' : 1 - d.errorProbability (PMF.uniformOfFintype Bool) ≤ (1 / 2 : ℝ) := by
      simpa using hs
    linarith
  have hcompl :
      ((PMF.uniformOfFintype Bool).toOuterMeasure ({false} : Set Bool)ᶜ).toReal =
        1 / 2 := by
    have hset : ({false} : Set Bool)ᶜ = {true} := by
      ext x
      cases x <;> simp
    rw [hset, PMF.toOuterMeasure_apply_singleton]
    norm_num [PMF.uniformOfFintype_apply]
  obtain ⟨c, hc, he⟩ := exists_sourceCode_errorProbability_le
    (PMF.uniformOfFintype Bool) {false} (M := 1) (by simp) (by decide)
  refine ⟨c, hc false (by simp), le_antisymm ?_ (hlower c)⟩
  simpa only [Finset.coe_singleton, hcompl] using he

private theorem pure_source_construction {X : Type u} [Finite X] (x₀ : X) :
    ∃ c : SourceCode X 1,
      c.decoder (c.encoder x₀) = x₀ ∧ c.errorProbability (PMF.pure x₀) = 0 := by
  classical
  obtain ⟨c, hc, he⟩ := exists_sourceCode_errorProbability_le
    (PMF.pure x₀) {x₀} (M := 1) (by simp) (by decide)
  refine ⟨c, hc x₀ (by simp), le_antisymm ?_
    (decodingErrorProbabilityOf_nonneg _ _ _ _)⟩
  simpa using he

private theorem singleton_source_construction (q : PMF Unit) :
    ∃ c : SourceCode Unit 1,
      (∀ x, c.decoder (c.encoder x) = x) ∧ c.errorProbability q = 0 := by
  obtain ⟨c, hc, he⟩ := exists_sourceCode_errorProbability_le
    q Finset.univ (M := 1) (by decide) (by decide)
  refine ⟨c, fun x => hc x (Finset.mem_univ x), le_antisymm ?_
    (decodingErrorProbabilityOf_nonneg _ _ _ _)⟩
  simpa using he

private def zeroWord (A : Type u) : Fin 0 → A := fun i => Fin.elim0 i

private theorem arbitrary_zero_length_code {A : Type u} {M : ℕ}
    (_hM : 1 ≤ M) (q : PMF (Fin 0 → A)) (c : BlockSourceCode A 0 M) :
    (∀ j : Fin M, c.decoder j = zeroWord A) ∧
      (∀ w, c.decoder (c.encoder w) = w) ∧ c.errorProbability q = 0 := by
  have hdecoder (j : Fin M) : c.decoder j = zeroWord A := by
    funext i
    exact Fin.elim0 i
  have hrecovers (w : Fin 0 → A) : c.decoder (c.encoder w) = w := by
    funext i
    exact Fin.elim0 i
  refine ⟨hdecoder, hrecovers, ?_⟩
  rw [SourceCode.errorProbability, decodingErrorProbabilityOf_eq_toOuterMeasure]
  have hfail : {w : Fin 0 → A | c.decoder (c.encoder w) ≠ id w} = ∅ := by
    ext w
    simp only [Set.mem_ofPred_eq, Set.mem_empty_iff_false, iff_false, not_not, id_eq]
    exact hrecovers w
  rw [hfail]
  simp

example {M : ℕ} (hM : 1 ≤ M) (c : BlockSourceCode Empty 0 M) :
    (∀ j : Fin M, c.decoder j = zeroWord Empty) ∧
      c.errorProbability (PMF.pure (zeroWord Empty)) = 0 := by
  obtain ⟨hd, _, he⟩ := arbitrary_zero_length_code hM
    (PMF.pure (zeroWord Empty)) c
  exact ⟨hd, he⟩

private theorem no_zero_message_operational_code {X : Type u} (q : PMF X) :
    ¬ Nonempty (SourceCode X 0) := by
  rintro ⟨c⟩
  obtain ⟨x, _⟩ := q.support_nonempty
  exact Fin.elim0 (c.encoder x)

private theorem no_empty_source_law : ¬ Nonempty (PMF Empty) := by
  rintro ⟨q⟩
  obtain ⟨x, _⟩ := q.support_nonempty
  exact Empty.elim x

example : ¬ Nonempty (BlockSourceCode Empty 0 0) :=
  no_zero_message_operational_code (PMF.pure (zeroWord Empty))

end

end LeanInfoTheory.Examples.SourceCoding
