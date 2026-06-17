/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Certificate.Checked

/-!
# Certificate proof of entropy submodularity

This file gives the first non-toy checked-certificate demonstration. It proves
the recognizable Shannon submodularity inequality

`H(A) + H(B) - H(A union B) - H(A inter B) >= 0`

by validating a one-step certificate whose primitive ingredient is conditional
mutual information:

`I(A \ B ; B \ A | A inter B)`.
-/

namespace LeanInfoTheory

universe u

namespace Certificate
namespace Submodularity

variable {Var : Type u} [DecidableEq Var]

/-- The formal entropy-expression form of submodularity. -/
noncomputable def expr (a b : EntropyAtom Var) : EntropyExpr Var :=
  EntropyExpr.atom a + EntropyExpr.atom b -
    EntropyExpr.atom (a ∪ b) - EntropyExpr.atom (a ∩ b)

private theorem diff_union_inter_eq_left (a b : EntropyAtom Var) :
    (a \ b) ∪ (a ∩ b) = a := by
  ext x
  by_cases hxa : x ∈ a
  · by_cases hxb : x ∈ b
    · simp [hxa, hxb]
    · simp [hxa, hxb]
  · simp [hxa]

private theorem diff_union_inter_eq_right (a b : EntropyAtom Var) :
    (b \ a) ∪ (a ∩ b) = b := by
  ext x
  by_cases hxa : x ∈ a
  · by_cases hxb : x ∈ b
    · simp [hxa, hxb]
    · simp [hxa, hxb]
  · by_cases hxb : x ∈ b
    · simp [hxa, hxb]
    · simp [hxa, hxb]

private theorem diff_union_diff_union_inter_eq_union (a b : EntropyAtom Var) :
    ((a \ b) ∪ (b \ a)) ∪ (a ∩ b) = a ∪ b := by
  ext x
  by_cases hxa : x ∈ a <;> by_cases hxb : x ∈ b <;> simp [hxa, hxb]

/--
Submodularity is exactly the conditional mutual information primitive
`I(A \ B ; B \ A | A inter B)` as a formal entropy expression.
-/
theorem expr_eq_condMutualInfo (a b : EntropyAtom Var) :
    expr a b =
      PrimitiveIneq.condMutualInfo (a \ b) (b \ a) (a ∩ b) := by
  rw [expr, PrimitiveIneq.condMutualInfo]
  rw [diff_union_inter_eq_left (a := a) (b := b),
    diff_union_inter_eq_right (a := a) (b := b),
    diff_union_diff_union_inter_eq_union (a := a) (b := b)]

/-- The primitive Shannon inequality used by the submodularity certificate. -/
noncomputable def primitive (a b : EntropyAtom Var) : PrimitiveIneq.Kind Var :=
  PrimitiveIneq.Kind.condMutualInfo (a \ b) (b \ a) (a ∩ b)

/-- The checked step used by the submodularity certificate. -/
noncomputable def checkedStep (a b : EntropyAtom Var) : CheckedStep Var where
  coeff := 1
  primitive := primitive a b

/-- The checked step has exactly the target submodularity expression. -/
theorem checkedStep_decomposition_matches (a b : EntropyAtom Var) :
    DecompositionMatches (expr a b) ([checkedStep a b].map CheckedStep.toWeightedIneq) := by
  rw [expr_eq_condMutualInfo (a := a) (b := b)]
  simp [DecompositionMatches, combinationExpr, CheckedStep.toWeightedIneq,
    CheckedStep.expr, checkedStep, primitive, PrimitiveIneq.Kind.expr]

/-- A proof-carrying checked certificate for entropy submodularity. -/
noncomputable def checkedCert (a b : EntropyAtom Var) : CheckedCert Var where
  target := expr a b
  decomposition := [checkedStep a b]
  decomposition_matches := checkedStep_decomposition_matches a b

/-- The raw step used by the submodularity certificate. -/
noncomputable def rawStep (a b : EntropyAtom Var) : RawStep Var where
  coeff := 1
  expr := PrimitiveIneq.condMutualInfo (a \ b) (b \ a) (a ∩ b)

/-- The raw submodularity step validates to the checked submodularity step. -/
theorem rawStep_toCheckedStep?_eq_some (a b : EntropyAtom Var) :
    RawStep.toCheckedStep? (rawStep a b) (primitive a b) = some (checkedStep a b) := by
  simp [RawStep.toCheckedStep?, rawStep, checkedStep, primitive, PrimitiveIneq.Kind.expr]
  rfl

/-- The raw submodularity step list validates against the primitive tag list. -/
theorem checkStepsAgainstPrimitives_eq_some (a b : EntropyAtom Var) :
    checkStepsAgainstPrimitives? [rawStep a b] [primitive a b] = some [checkedStep a b] := by
  simp [checkStepsAgainstPrimitives?, rawStep_toCheckedStep?_eq_some]

/-- A raw external-style certificate for entropy submodularity. -/
noncomputable def rawCert (a b : EntropyAtom Var) : RawCert Var where
  target := expr a b
  decomposition := [rawStep a b]

/-- The raw submodularity certificate validates against its primitive tag. -/
theorem rawCert_toCheckedCert?_isSome (a b : EntropyAtom Var) :
    (RawCert.toCheckedCert? (rawCert a b) [primitive a b]).isSome := by
  classical
  unfold RawCert.toCheckedCert?
  rw [show checkStepsAgainstPrimitives? (rawCert a b).decomposition [primitive a b] =
      some [checkedStep a b] by
    simp [rawCert, checkStepsAgainstPrimitives_eq_some]]
  change
    ((if hdecomp :
        DecompositionMatches (rawCert a b).target
          ([checkedStep a b].map CheckedStep.toWeightedIneq) then
      some (CheckedCert.mk (rawCert a b).target [checkedStep a b] hdecomp)
    else
      none).isSome = true)
  have hdecomp :
      DecompositionMatches (rawCert a b).target
        ([checkedStep a b].map CheckedStep.toWeightedIneq) := by
    simpa [rawCert] using checkedStep_decomposition_matches (a := a) (b := b)
  rw [dif_pos hdecomp]
  simp

/-- Running the raw submodularity validator gives a sound certificate. -/
theorem sound_from_validator
    (h : ShannonEntropyVal Var) (a b : EntropyAtom Var) :
    0 <= ShannonEntropyVal.eval h (expr a b) := by
  have hsome := rawCert_toCheckedCert?_isSome (a := a) (b := b)
  cases hchecked : RawCert.toCheckedCert? (rawCert a b) [primitive a b] with
  | none =>
      simp [hchecked] at hsome
  | some _checked =>
      exact RawCert.sound_of_toCheckedCert?_eq_some hchecked h

/-- Entropy submodularity for every abstract Shannon entropy valuation. -/
theorem entropy_submodularity
    (h : ShannonEntropyVal Var) (a b : EntropyAtom Var) :
    0 <= h a + h b - h (a ∪ b) - h (a ∩ b) := by
  simpa [expr, ShannonEntropyVal.eval] using sound_from_validator h a b

end Submodularity
end Certificate

end LeanInfoTheory
