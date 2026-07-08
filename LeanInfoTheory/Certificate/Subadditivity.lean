import LeanInfoTheory.Certificate.Checked

/-!
# Checked certificate for entropy subadditivity

This module gives a compact certificate proof of the Shannon-style inequality

`0 <= H(A) + H(B) - H(A ∪ B)`.

The certificate combines the nonnegativity of `I(A;B | ∅)` with the empty-entropy
primitive, cancelling the extra `-H(∅)` term that appears in the primitive CMI
shape.
-/

namespace LeanInfoTheory

universe u

namespace Certificate
namespace Subadditivity

open scoped BigOperators

variable {Var : Type u} [DecidableEq Var]

/-- The entropy subadditivity expression `H(A) + H(B) - H(A ∪ B)`. -/
noncomputable def expr (a b : EntropyAtom Var) : EntropyExpr Var :=
  EntropyExpr.atom a + EntropyExpr.atom b - EntropyExpr.atom (a ∪ b)

/-- Subadditivity is `I(A;B | ∅) + H(∅)` as an entropy expression. -/
theorem expr_eq_cmi_empty_add_emptyEntropy (a b : EntropyAtom Var) :
    expr a b =
      PrimitiveIneq.condMutualInfo a b (EntropyAtom.empty Var) +
        PrimitiveIneq.emptyEntropy Var := by
  simp [expr, PrimitiveIneq.condMutualInfo, PrimitiveIneq.emptyEntropy,
    EntropyExpr.empty, EntropyAtom.empty]

/-- The conditional mutual-information primitive used by the certificate. -/
noncomputable def cmiPrimitive (a b : EntropyAtom Var) : PrimitiveIneq.Kind Var :=
  PrimitiveIneq.Kind.condMutualInfo a b (EntropyAtom.empty Var)

/-- The empty-entropy primitive used to cancel the extra `-H(∅)` CMI term. -/
noncomputable def emptyPrimitive : PrimitiveIneq.Kind Var :=
  PrimitiveIneq.Kind.emptyEntropy

/-- Checked CMI certificate step with coefficient `1`. -/
noncomputable def checkedCmiStep (a b : EntropyAtom Var) : CheckedStep Var where
  coeff := 1
  primitive := cmiPrimitive a b

/-- Checked empty-entropy certificate step with coefficient `1`. -/
noncomputable def checkedEmptyStep : CheckedStep Var where
  coeff := 1
  primitive := emptyPrimitive

/-- The checked step list has exactly the target subadditivity expression. -/
theorem checkedSteps_decomposition_matches (a b : EntropyAtom Var) :
    DecompositionMatches (expr a b)
      ([checkedCmiStep a b, checkedEmptyStep].map CheckedStep.toWeightedIneq) := by
  rw [expr_eq_cmi_empty_add_emptyEntropy]
  simp [DecompositionMatches, combinationExpr, CheckedStep.toWeightedIneq,
    CheckedStep.expr, checkedCmiStep, checkedEmptyStep, cmiPrimitive, emptyPrimitive,
    PrimitiveIneq.Kind.expr]

/-- Checked certificate for entropy subadditivity. -/
noncomputable def checkedCert (a b : EntropyAtom Var) : CheckedCert Var where
  target := expr a b
  decomposition := [checkedCmiStep a b, checkedEmptyStep]
  decomposition_matches := checkedSteps_decomposition_matches a b

/-- Soundness of the checked subadditivity certificate. -/
theorem checkedCert_sound (h : ShannonEntropyVal Var) (a b : EntropyAtom Var) :
    0 <= h.eval (expr a b) :=
  CheckedCert.sound (checkedCert a b) h

/-- Raw CMI certificate step for subadditivity. -/
noncomputable def rawCmiStep (a b : EntropyAtom Var) : RawStep Var where
  coeff := 1
  expr := PrimitiveIneq.condMutualInfo a b (EntropyAtom.empty Var)

/-- Raw empty-entropy certificate step for subadditivity. -/
noncomputable def rawEmptyStep : RawStep Var where
  coeff := 1
  expr := PrimitiveIneq.emptyEntropy Var

/-- Raw certificate for entropy subadditivity. -/
noncomputable def rawCert (a b : EntropyAtom Var) : RawCert Var where
  target := expr a b
  decomposition := [rawCmiStep a b, rawEmptyStep]

/-- The raw CMI step validates to the intended checked step. -/
theorem rawCmiStep_toCheckedStep?_eq_some (a b : EntropyAtom Var) :
    RawStep.toCheckedStep? (rawCmiStep a b) (cmiPrimitive a b) =
      some (checkedCmiStep a b) := by
  simp [RawStep.toCheckedStep?, rawCmiStep, checkedCmiStep, cmiPrimitive,
    PrimitiveIneq.Kind.expr]
  rfl

/-- The raw empty-entropy step validates to the intended checked step. -/
theorem rawEmptyStep_toCheckedStep?_eq_some :
    RawStep.toCheckedStep? (rawEmptyStep : RawStep Var)
        (emptyPrimitive : PrimitiveIneq.Kind Var) =
      some (checkedEmptyStep : CheckedStep Var) := by
  simp [RawStep.toCheckedStep?, rawEmptyStep, checkedEmptyStep, emptyPrimitive,
    PrimitiveIneq.Kind.expr]
  rfl

/-- The raw subadditivity step list validates to the intended checked step list. -/
theorem checkStepsAgainstPrimitives_eq_some (a b : EntropyAtom Var) :
    checkStepsAgainstPrimitives? [rawCmiStep a b, rawEmptyStep]
        [cmiPrimitive a b, emptyPrimitive] =
      some [checkedCmiStep a b, checkedEmptyStep] := by
  simp [checkStepsAgainstPrimitives?, rawCmiStep_toCheckedStep?_eq_some,
    rawEmptyStep_toCheckedStep?_eq_some]

/-- The raw subadditivity certificate is accepted by the validator. -/
theorem rawCert_toCheckedCert?_isSome (a b : EntropyAtom Var) :
    (RawCert.toCheckedCert? (rawCert a b) [cmiPrimitive a b, emptyPrimitive]).isSome := by
  classical
  unfold RawCert.toCheckedCert?
  rw [show checkStepsAgainstPrimitives? (rawCert a b).decomposition
        [cmiPrimitive a b, emptyPrimitive] =
      some [checkedCmiStep a b, checkedEmptyStep] by
    simp [rawCert, checkStepsAgainstPrimitives_eq_some]]
  change
    ((if hdecomp :
        DecompositionMatches (rawCert a b).target
          ([checkedCmiStep a b, checkedEmptyStep].map CheckedStep.toWeightedIneq) then
      some
        (CheckedCert.mk (rawCert a b).target
          [checkedCmiStep a b, checkedEmptyStep] hdecomp)
    else
      none).isSome = true)
  have hdecomp :
      DecompositionMatches (rawCert a b).target
        ([checkedCmiStep a b, checkedEmptyStep].map CheckedStep.toWeightedIneq) := by
    simpa [rawCert] using checkedSteps_decomposition_matches (a := a) (b := b)
  rw [dif_pos hdecomp]
  simp

/-- Soundness obtained through the raw certificate validator. -/
theorem sound_from_validator
    (h : ShannonEntropyVal Var) (a b : EntropyAtom Var) :
    0 <= ShannonEntropyVal.eval h (expr a b) := by
  exact RawCert.sound_of_toCheckedCert?_isSome
    (rawCert_toCheckedCert?_isSome (a := a) (b := b)) h

/-- Entropy subadditivity, proved by the checked certificate. -/
theorem entropy_subadditivity (h : ShannonEntropyVal Var) (a b : EntropyAtom Var) :
    0 <= h a + h b - h (a ∪ b) := by
  simpa [expr, ShannonEntropyVal.eval] using sound_from_validator h a b

end Subadditivity
end Certificate
end LeanInfoTheory
