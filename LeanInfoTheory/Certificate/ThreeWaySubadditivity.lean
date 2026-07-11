import LeanInfoTheory.Certificate.Checked

/-!
# Checked certificate for three-way entropy subadditivity

This module is the next manual certificate pressure test. It will prove the
three-way entropy subadditivity inequality

`0 <= H(A) + H(B) + H(C) - H(A ∪ B ∪ C)`

using the current explicit primitive-tag certificate checker.
-/

namespace LeanInfoTheory

universe u

namespace Certificate
namespace ThreeWaySubadditivity

variable {Var : Type u} [DecidableEq Var]

/-- The three-way entropy subadditivity expression `H(A) + H(B) + H(C) - H(A ∪ B ∪ C)`. -/
noncomputable def expr (a b c : EntropyAtom Var) : EntropyExpr Var :=
  EntropyExpr.atom a + EntropyExpr.atom b + EntropyExpr.atom c -
    EntropyExpr.atom (a ∪ b ∪ c)

/-- Evaluating the formal three-way subadditivity expression gives the expected inequality body. -/
theorem eval_expr (h : ShannonEntropyVal Var) (a b c : EntropyAtom Var) :
    ShannonEntropyVal.eval h (expr a b c) = h a + h b + h c - h (a ∪ b ∪ c) := by
  simp [expr, ShannonEntropyVal.eval]

/--
The target expression is the sum of two subadditivity-style primitive blocks:
`I(A;B | ∅) + H(∅)` and `I(A ∪ B;C | ∅) + H(∅)`.
-/
theorem expr_eq_two_cmi_empty_blocks (a b c : EntropyAtom Var) :
    expr a b c =
      (PrimitiveIneq.condMutualInfo a b (EntropyAtom.empty Var) +
          PrimitiveIneq.emptyEntropy Var) +
        (PrimitiveIneq.condMutualInfo (a ∪ b) c (EntropyAtom.empty Var) +
          PrimitiveIneq.emptyEntropy Var) := by
  simp [expr, PrimitiveIneq.condMutualInfo, PrimitiveIneq.emptyEntropy,
    EntropyExpr.empty, EntropyAtom.empty]
  simp [sub_eq_add_neg, add_assoc, add_left_comm, add_comm]

/-- The first CMI primitive used by the certificate: `I(A;B | ∅)`. -/
noncomputable def leftCmiPrimitive (a b : EntropyAtom Var) : PrimitiveIneq.Kind Var :=
  PrimitiveIneq.Kind.condMutualInfo a b (EntropyAtom.empty Var)

/-- The second CMI primitive used by the certificate: `I(A ∪ B;C | ∅)`. -/
noncomputable def rightCmiPrimitive (a b c : EntropyAtom Var) : PrimitiveIneq.Kind Var :=
  PrimitiveIneq.Kind.condMutualInfo (a ∪ b) c (EntropyAtom.empty Var)

/-- The empty-entropy primitive used to cancel each CMI block's `-H(∅)` term. -/
noncomputable def emptyPrimitive : PrimitiveIneq.Kind Var :=
  PrimitiveIneq.Kind.emptyEntropy

/-- Checked step for the first CMI block. -/
noncomputable def checkedLeftCmiStep (a b : EntropyAtom Var) : CheckedStep Var where
  coeff := 1
  primitive := leftCmiPrimitive a b

/-- Checked step for the second CMI block. -/
noncomputable def checkedRightCmiStep (a b c : EntropyAtom Var) : CheckedStep Var where
  coeff := 1
  primitive := rightCmiPrimitive a b c

/-- Checked empty-entropy step with coefficient `1`. -/
noncomputable def checkedEmptyStep : CheckedStep Var where
  coeff := 1
  primitive := emptyPrimitive

/-- The checked step list has exactly the target three-way subadditivity expression. -/
theorem checkedSteps_decomposition_matches (a b c : EntropyAtom Var) :
    DecompositionMatches (expr a b c)
      ([checkedLeftCmiStep a b, checkedEmptyStep, checkedRightCmiStep a b c,
          checkedEmptyStep].map CheckedStep.toWeightedIneq) := by
  rw [expr_eq_two_cmi_empty_blocks]
  simp [DecompositionMatches, combinationExpr, CheckedStep.toWeightedIneq,
    CheckedStep.expr, checkedLeftCmiStep, checkedRightCmiStep, checkedEmptyStep,
    leftCmiPrimitive, rightCmiPrimitive, emptyPrimitive, PrimitiveIneq.Kind.expr]
  ac_rfl

/-- Checked certificate for three-way entropy subadditivity. -/
noncomputable def checkedCert (a b c : EntropyAtom Var) : CheckedCert Var where
  target := expr a b c
  decomposition :=
    [checkedLeftCmiStep a b, checkedEmptyStep, checkedRightCmiStep a b c,
      checkedEmptyStep]
  decomposition_matches := checkedSteps_decomposition_matches a b c

/-- Soundness of the checked three-way subadditivity certificate. -/
theorem checkedCert_sound
    (h : ShannonEntropyVal Var) (a b c : EntropyAtom Var) :
    0 <= h.eval (expr a b c) :=
  CheckedCert.sound (checkedCert a b c) h

/-- Raw step for the first CMI block. -/
noncomputable def rawLeftCmiStep (a b : EntropyAtom Var) : RawStep Var where
  coeff := 1
  expr := PrimitiveIneq.condMutualInfo a b (EntropyAtom.empty Var)

/-- Raw step for the second CMI block. -/
noncomputable def rawRightCmiStep (a b c : EntropyAtom Var) : RawStep Var where
  coeff := 1
  expr := PrimitiveIneq.condMutualInfo (a ∪ b) c (EntropyAtom.empty Var)

/-- Raw empty-entropy step. -/
noncomputable def rawEmptyStep : RawStep Var where
  coeff := 1
  expr := PrimitiveIneq.emptyEntropy Var

/-- Raw certificate for three-way entropy subadditivity. -/
noncomputable def rawCert (a b c : EntropyAtom Var) : RawCert Var where
  target := expr a b c
  decomposition := [rawLeftCmiStep a b, rawEmptyStep, rawRightCmiStep a b c, rawEmptyStep]

/-- The raw first CMI step validates to the intended checked step. -/
theorem rawLeftCmiStep_toCheckedStep?_eq_some (a b : EntropyAtom Var) :
    RawStep.toCheckedStep? (rawLeftCmiStep a b) (leftCmiPrimitive a b) =
      some (checkedLeftCmiStep a b) := by
  simp [RawStep.toCheckedStep?, rawLeftCmiStep, checkedLeftCmiStep, leftCmiPrimitive,
    PrimitiveIneq.Kind.expr]
  rfl

/-- The raw second CMI step validates to the intended checked step. -/
theorem rawRightCmiStep_toCheckedStep?_eq_some (a b c : EntropyAtom Var) :
    RawStep.toCheckedStep? (rawRightCmiStep a b c) (rightCmiPrimitive a b c) =
      some (checkedRightCmiStep a b c) := by
  simp [RawStep.toCheckedStep?, rawRightCmiStep, checkedRightCmiStep, rightCmiPrimitive,
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

/-- The raw step list validates to the intended checked step list. -/
theorem checkStepsAgainstPrimitives_eq_some (a b c : EntropyAtom Var) :
    checkStepsAgainstPrimitives?
        [rawLeftCmiStep a b, rawEmptyStep, rawRightCmiStep a b c, rawEmptyStep]
        [leftCmiPrimitive a b, emptyPrimitive, rightCmiPrimitive a b c, emptyPrimitive] =
      some
        [checkedLeftCmiStep a b, checkedEmptyStep, checkedRightCmiStep a b c,
          checkedEmptyStep] := by
  simp [checkStepsAgainstPrimitives?, rawLeftCmiStep_toCheckedStep?_eq_some,
    rawRightCmiStep_toCheckedStep?_eq_some, rawEmptyStep_toCheckedStep?_eq_some]

/-- The raw three-way subadditivity certificate is accepted by the validator. -/
theorem rawCert_toCheckedCert?_isSome (a b c : EntropyAtom Var) :
    (RawCert.toCheckedCert? (rawCert a b c)
      [leftCmiPrimitive a b, emptyPrimitive, rightCmiPrimitive a b c, emptyPrimitive]).isSome := by
  classical
  unfold RawCert.toCheckedCert?
  rw [show checkStepsAgainstPrimitives? (rawCert a b c).decomposition
        [leftCmiPrimitive a b, emptyPrimitive, rightCmiPrimitive a b c, emptyPrimitive] =
      some
        [checkedLeftCmiStep a b, checkedEmptyStep, checkedRightCmiStep a b c,
          checkedEmptyStep] by
    simp [rawCert, checkStepsAgainstPrimitives_eq_some]]
  change
    ((if hdecomp :
        DecompositionMatches (rawCert a b c).target
          ([checkedLeftCmiStep a b, checkedEmptyStep, checkedRightCmiStep a b c,
              checkedEmptyStep].map CheckedStep.toWeightedIneq) then
      some
        (CheckedCert.mk (rawCert a b c).target
          [checkedLeftCmiStep a b, checkedEmptyStep, checkedRightCmiStep a b c,
            checkedEmptyStep] hdecomp)
    else
      none).isSome = true)
  have hdecomp :
      DecompositionMatches (rawCert a b c).target
        ([checkedLeftCmiStep a b, checkedEmptyStep, checkedRightCmiStep a b c,
            checkedEmptyStep].map CheckedStep.toWeightedIneq) := by
    simpa [rawCert] using checkedSteps_decomposition_matches (a := a) (b := b) (c := c)
  rw [dif_pos hdecomp]
  simp

/-- Running the raw three-way subadditivity validator gives a sound certificate. -/
theorem sound_from_validator
    (h : ShannonEntropyVal Var) (a b c : EntropyAtom Var) :
    0 <= ShannonEntropyVal.eval h (expr a b c) := by
  exact RawCert.sound_of_toCheckedCert?_isSome
    (rawCert_toCheckedCert?_isSome (a := a) (b := b) (c := c)) h

/-- Three-way entropy subadditivity for every abstract Shannon entropy valuation. -/
theorem entropy_three_way_subadditivity
    (h : ShannonEntropyVal Var) (a b c : EntropyAtom Var) :
    0 <= h a + h b + h c - h (a ∪ b ∪ c) := by
  simpa [eval_expr] using sound_from_validator h a b c

end ThreeWaySubadditivity
end Certificate

end LeanInfoTheory
