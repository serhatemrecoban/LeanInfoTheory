/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.FiniteProduct

/-!
# Iid entropy consumers

These private consumers use the focused finite-product semantic owner. A fair
Boolean law and its injective image in a three-symbol alphabet both have block
entropy `n * log 2`. The image law is nondegenerate but assigns zero mass to its
third symbol, so the entropy identity does not require full support.

Zero and one lengths, an actual singleton alphabet and an empty index over an
empty alphabet are distinct cases. The latter uses a general finite product:
there is no base PMF on the empty alphabet to supply to `PMF.iid`, even at zero
length.
-/

namespace LeanInfoTheory.Examples.IidInformation

noncomputable section

open scoped BigOperators ENNReal
open LeanInfoTheory.Shannon

/-! ## A nondegenerate sparse law and its iid entropy -/

private def fair : PMF Bool := PMF.uniformOfFintype Bool

private theorem fair_entropy : entropy fair = Real.log 2 := by
  have hmass (b : Bool) : (fair b).toReal = (2 : ℝ)⁻¹ := by
    simp [fair, PMF.uniformOfFintype_apply]
  rw [entropy_eq_sum, Fintype.sum_bool]
  simp only [hmass, Real.negMulLog, Real.log_inv]
  ring

private def bitSymbol (b : Bool) : Fin 3 := if b then 1 else 0

private theorem bitSymbol_injective : Function.Injective bitSymbol := by
  intro a b h
  cases a <;> cases b <;> simp_all [bitSymbol]

private def sparse : PMF (Fin 3) := fair.map bitSymbol

private theorem sparse_entropy : entropy sparse = Real.log 2 := by
  rw [sparse, entropy_map_injective fair bitSymbol_injective, fair_entropy]

private theorem sparse_entropy_pos : 0 < entropy sparse := by
  rw [sparse_entropy]
  exact Real.log_pos (by norm_num : (1 : ℝ) < 2)

private theorem sparse_missing_symbol : sparse 2 = 0 := by
  apply PMF.map_apply_eq_zero_of_notMem_range fair
  rintro ⟨b, hb⟩
  have hv := congrArg Fin.val hb
  cases b <;> norm_num [bitSymbol] at hv

private theorem sparse_not_full_support : (2 : Fin 3) ∉ sparse.support := by
  intro h
  change sparse 2 ≠ 0 at h
  exact h sparse_missing_symbol

private theorem fair_iid_entropy (n : ℕ) :
    entropy (PMF.iid fair n) = (n : ℝ) * Real.log 2 := by
  rw [entropy_iid, fair_entropy]

private theorem sparse_iid_entropy (n : ℕ) :
    entropy (PMF.iid sparse n) = (n : ℝ) * Real.log 2 := by
  rw [entropy_iid, sparse_entropy]

private theorem sparse_iid_zero_entropy : entropy (PMF.iid sparse 0) = 0 := by
  simpa using sparse_iid_entropy 0

private theorem sparse_iid_one_entropy :
    entropy (PMF.iid sparse 1) = Real.log 2 := by
  simpa using sparse_iid_entropy 1

private theorem sparse_iid_missing_word (n : ℕ) (hn : 0 < n) :
    (fun _ : Fin n => (2 : Fin 3)) ∉ (PMF.iid sparse n).support := by
  intro h
  have hcoordinate :=
    (PMF.mem_support_finiteProduct_iff (fun _ : Fin n => sparse)
      (fun _ => (2 : Fin 3))).mp h ⟨0, hn⟩
  exact sparse_not_full_support hcoordinate

/-! ## Singleton alphabets and genuinely empty products -/

private theorem singleton_alphabet_iid_entropy (n : ℕ) :
    entropy (PMF.iid (PMF.pure PUnit.unit) n) = 0 := by
  rw [entropy_iid, entropy_pure, mul_zero]

private def emptyComponents (i : Fin 0) : PMF Empty := isEmptyElim i

private theorem empty_alphabet_product_entropy :
    entropy (PMF.finiteProduct emptyComponents) = 0 := by
  have h := entropy_finiteProduct emptyComponents
  simp only [Finset.univ_eq_empty, Finset.sum_empty] at h
  convert! h

private theorem empty_alphabet_product_law :
    PMF.finiteProduct emptyComponents =
      PMF.pure (fun i : Fin 0 => (isEmptyElim i : Empty)) :=
  PMF.finiteProduct_of_isEmpty emptyComponents

private theorem no_empty_base_law : ¬ Nonempty (PMF Empty) := by
  rintro ⟨p⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

end

end LeanInfoTheory.Examples.IidInformation
