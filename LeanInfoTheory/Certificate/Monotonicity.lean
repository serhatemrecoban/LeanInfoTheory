import LeanInfoTheory.Certificate.Checked

/-!
# Checked certificate for one-variable entropy monotonicity

This module gives a minimal checked-certificate proof of

`0 <= H(S ∪ {i}) - H(S)`

when `i ∉ S`. It demonstrates the conditional-entropy primitive in the
raw-to-checked certificate pipeline.
-/

namespace LeanInfoTheory

universe u

namespace Certificate
namespace Monotonicity

variable {Var : Type u} [DecidableEq Var]

/-- The entropy-extension expression `H(S ∪ {i}) - H(S)`. -/
noncomputable def expr (s : EntropyAtom Var) (i : Var) : EntropyExpr Var :=
  EntropyExpr.atom (insert i s) - EntropyExpr.atom s

/-- The entropy-extension expression is the conditional-entropy primitive. -/
theorem expr_eq_condEntropy (s : EntropyAtom Var) (i : Var) :
    expr s i = PrimitiveIneq.condEntropy s i := by
  rfl

/-- The primitive Shannon inequality used by the monotonicity certificate. -/
noncomputable def primitive (s : EntropyAtom Var) (i : Var) (hi : i ∉ s) :
    PrimitiveIneq.Kind Var :=
  PrimitiveIneq.Kind.condEntropy s i hi

/-- The checked step used by the monotonicity certificate. -/
noncomputable def checkedStep
    (s : EntropyAtom Var) (i : Var) (hi : i ∉ s) : CheckedStep Var where
  coeff := 1
  primitive := primitive s i hi

/-- The checked step has exactly the target monotonicity expression. -/
theorem checkedStep_decomposition_matches
    (s : EntropyAtom Var) (i : Var) (hi : i ∉ s) :
    DecompositionMatches (expr s i)
      ([checkedStep s i hi].map CheckedStep.toWeightedIneq) := by
  rw [expr_eq_condEntropy]
  simp [DecompositionMatches, combinationExpr, CheckedStep.toWeightedIneq,
    CheckedStep.expr, checkedStep, primitive, PrimitiveIneq.Kind.expr]

/-- A proof-carrying checked certificate for one-variable entropy monotonicity. -/
noncomputable def checkedCert
    (s : EntropyAtom Var) (i : Var) (hi : i ∉ s) : CheckedCert Var where
  target := expr s i
  decomposition := [checkedStep s i hi]
  decomposition_matches := checkedStep_decomposition_matches s i hi

/-- Soundness of the checked monotonicity certificate. -/
theorem checkedCert_sound
    (h : ShannonEntropyVal Var) (s : EntropyAtom Var) (i : Var) (hi : i ∉ s) :
    0 <= h.eval (expr s i) :=
  CheckedCert.sound (checkedCert s i hi) h

/-- The raw step used by the monotonicity certificate. -/
noncomputable def rawStep (s : EntropyAtom Var) (i : Var) : RawStep Var where
  coeff := 1
  expr := PrimitiveIneq.condEntropy s i

/-- The raw monotonicity step validates to the checked monotonicity step. -/
theorem rawStep_toCheckedStep?_eq_some
    (s : EntropyAtom Var) (i : Var) (hi : i ∉ s) :
    RawStep.toCheckedStep? (rawStep s i) (primitive s i hi) =
      some (checkedStep s i hi) := by
  simp [RawStep.toCheckedStep?, rawStep, checkedStep, primitive, PrimitiveIneq.Kind.expr]
  rfl

/-- The raw monotonicity step list validates against the primitive tag list. -/
theorem checkStepsAgainstPrimitives_eq_some
    (s : EntropyAtom Var) (i : Var) (hi : i ∉ s) :
    checkStepsAgainstPrimitives? [rawStep s i] [primitive s i hi] =
      some [checkedStep s i hi] := by
  simp [checkStepsAgainstPrimitives?, rawStep_toCheckedStep?_eq_some]

/-- A raw external-style certificate for one-variable entropy monotonicity. -/
noncomputable def rawCert (s : EntropyAtom Var) (i : Var) : RawCert Var where
  target := expr s i
  decomposition := [rawStep s i]

/-- The raw monotonicity certificate validates against its primitive tag. -/
theorem rawCert_toCheckedCert?_isSome
    (s : EntropyAtom Var) (i : Var) (hi : i ∉ s) :
    (RawCert.toCheckedCert? (rawCert s i) [primitive s i hi]).isSome := by
  classical
  unfold RawCert.toCheckedCert?
  rw [show checkStepsAgainstPrimitives? (rawCert s i).decomposition [primitive s i hi] =
      some [checkedStep s i hi] by
    simp [rawCert, checkStepsAgainstPrimitives_eq_some]]
  change
    ((if hdecomp :
        DecompositionMatches (rawCert s i).target
          ([checkedStep s i hi].map CheckedStep.toWeightedIneq) then
      some (CheckedCert.mk (rawCert s i).target [checkedStep s i hi] hdecomp)
    else
      none).isSome = true)
  have hdecomp :
      DecompositionMatches (rawCert s i).target
        ([checkedStep s i hi].map CheckedStep.toWeightedIneq) := by
    simpa [rawCert] using
      checkedStep_decomposition_matches (s := s) (i := i) (hi := hi)
  rw [dif_pos hdecomp]
  simp

/-- Running the raw monotonicity validator gives a sound certificate. -/
theorem sound_from_validator
    (h : ShannonEntropyVal Var) (s : EntropyAtom Var) (i : Var) (hi : i ∉ s) :
    0 <= ShannonEntropyVal.eval h (expr s i) := by
  exact RawCert.sound_of_toCheckedCert?_isSome
    (rawCert_toCheckedCert?_isSome (s := s) (i := i) (hi := hi)) h

/-- One-variable entropy monotonicity for every abstract Shannon entropy valuation. -/
theorem entropy_insert_monotonicity
    (h : ShannonEntropyVal Var) (s : EntropyAtom Var) {i : Var} (hi : i ∉ s) :
    0 <= h (insert i s) - h s := by
  simpa [expr, ShannonEntropyVal.eval] using sound_from_validator h s i hi

end Monotonicity
end Certificate

end LeanInfoTheory
