/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Certificate
import LeanInfoTheory.Certificate.Checked
import LeanInfoTheory.EntropyVal
import LeanInfoTheory.Examples.CommonCause
import LeanInfoTheory.Examples.KLTop
import LeanInfoTheory.Examples.StochasticChannels
import LeanInfoTheory.Examples.SufficientStatistics
import LeanInfoTheory.Examples.SupportSensitive
import LeanInfoTheory.PrimitiveIneq

/-!
# Toy examples

This aggregate contains the original small certificate examples and imports the
separately usable common-cause, stochastic-channel, support-sensitive, and
sufficient-statistics semantic examples, as well as the infinite-KL example.
It remains outside the lightweight root import.
-/

namespace LeanInfoTheory
namespace Examples

/-- Three variable names used in toy entropy expressions. -/
inductive Var where
  | X
  | Y
  | Z
  deriving DecidableEq, Repr

open Var

/-- The formal atom `H(X)`. -/
noncomputable def HX : EntropyExpr Var :=
  EntropyExpr.atom ({X} : Finset Var)

/-- The formal empty entropy atom `H(∅)`. -/
noncomputable def HEmpty : EntropyExpr Var :=
  EntropyExpr.empty Var

/-- The empty entropy atom evaluates to zero under interpretations satisfying `H(∅) = 0`. -/
theorem hEmpty_eval_eq_zero
    (value : EntropyAtom Var -> Real)
    (hvalue : EntropyExpr.RespectsEmpty value) :
    EntropyExpr.eval value HEmpty = 0 := by
  simpa [HEmpty] using
    EntropyExpr.eval_empty_eq_zero_of_respectsEmpty (value := value) hvalue

/-- Abstract Shannon entropy valuations evaluate `H(∅)` as zero. -/
theorem hEmpty_eval_eq_zero_of_shannonEntropyVal
    (h : ShannonEntropyVal Var) :
    ShannonEntropyVal.eval h HEmpty = 0 := by
  simp [HEmpty]

/-- Primitive conditional mutual information is nonnegative for abstract valuations. -/
theorem primitiveCmi_nonneg
    (h : ShannonEntropyVal Var) :
    0 <= ShannonEntropyVal.eval h
      (PrimitiveIneq.condMutualInfo ({X} : Finset Var) ({Y} : Finset Var) ({Z} : Finset Var)) := by
  exact PrimitiveIneq.condMutualInfo_nonneg h _ _ _

/-- A one-step checked certificate for primitive conditional mutual information. -/
noncomputable def primitiveCmiCheckedCert : Certificate.CheckedCert Var where
  target :=
    PrimitiveIneq.condMutualInfo ({X} : Finset Var) ({Y} : Finset Var) ({Z} : Finset Var)
  decomposition :=
    [{
      coeff := 1
      primitive :=
        PrimitiveIneq.Kind.condMutualInfo
          ({X} : Finset Var) ({Y} : Finset Var) ({Z} : Finset Var)
    }]
  decomposition_matches := by
    simp [Certificate.DecompositionMatches, Certificate.combinationExpr,
      Certificate.CheckedStep.toWeightedIneq,
      Certificate.CheckedStep.expr, PrimitiveIneq.Kind.expr]

/-- The checked primitive-CMI certificate is sound for every abstract valuation. -/
theorem primitiveCmiCheckedCert_sound
    (h : ShannonEntropyVal Var) :
    0 <= ShannonEntropyVal.eval h primitiveCmiCheckedCert.target := by
  exact Certificate.CheckedCert.sound primitiveCmiCheckedCert h

/-- The primitive tag used by the raw primitive-CMI certificate example. -/
noncomputable def primitiveCmiKind : PrimitiveIneq.Kind Var :=
  PrimitiveIneq.Kind.condMutualInfo
    ({X} : Finset Var) ({Y} : Finset Var) ({Z} : Finset Var)

/-- A raw external-style one-step certificate for primitive conditional mutual information. -/
noncomputable def primitiveCmiRawCert : Certificate.RawCert Var where
  target :=
    PrimitiveIneq.condMutualInfo ({X} : Finset Var) ({Y} : Finset Var) ({Z} : Finset Var)
  decomposition :=
    [{
      coeff := 1
      expr :=
        PrimitiveIneq.condMutualInfo
          ({X} : Finset Var) ({Y} : Finset Var) ({Z} : Finset Var)
    }]

/-- The raw primitive-CMI certificate validates against its primitive tag. -/
theorem primitiveCmiRawCert_toCheckedCert?_isSome :
    (Certificate.RawCert.toCheckedCert? primitiveCmiRawCert [primitiveCmiKind]).isSome := by
  simp [primitiveCmiRawCert, primitiveCmiKind, Certificate.RawCert.toCheckedCert?,
    Certificate.checkStepsAgainstPrimitives?, Certificate.RawStep.toCheckedStep?,
    Certificate.DecompositionMatches, Certificate.combinationExpr,
    Certificate.CheckedStep.toWeightedIneq,
    Certificate.CheckedStep.expr, PrimitiveIneq.Kind.expr]

/-- A successfully validated raw primitive-CMI certificate proves its raw target. -/
theorem primitiveCmiRawCert_validated_sound
    (h : ShannonEntropyVal Var) {checked : Certificate.CheckedCert Var}
    (hchecked :
      Certificate.RawCert.toCheckedCert? primitiveCmiRawCert [primitiveCmiKind] = some checked) :
    0 <= ShannonEntropyVal.eval h primitiveCmiRawCert.target := by
  exact Certificate.RawCert.sound_of_toCheckedCert?_eq_some hchecked h

/-- Running the raw primitive-CMI validator gives a sound certificate. -/
theorem primitiveCmiRawCert_sound_from_validator
    (h : ShannonEntropyVal Var) :
    0 <= ShannonEntropyVal.eval h primitiveCmiRawCert.target := by
  have hsome := primitiveCmiRawCert_toCheckedCert?_isSome
  cases hchecked :
      Certificate.RawCert.toCheckedCert? primitiveCmiRawCert [primitiveCmiKind] with
  | none =>
      simp [hchecked] at hsome
  | some checked =>
      exact Certificate.RawCert.sound_of_toCheckedCert?_eq_some hchecked h

/-- A one-step certificate for the nonnegativity of `H(X)`. -/
noncomputable def hxNonnegCert : Certificate.Cert Var where
  target := HX
  decomposition := [(1, HX)]

/-- The toy certificate is sound whenever the semantic value assigned to `H(X)` is nonnegative. -/
theorem hxNonnegCert_sound
    (value : EntropyAtom Var -> Real)
    (hHX : 0 <= EntropyExpr.eval value HX) :
    0 <= EntropyExpr.eval value hxNonnegCert.target := by
  -- The certificate has one ingredient: `1 * H(X)`.
  apply Certificate.sound (value := value) (cert := hxNonnegCert)
  · simp [hxNonnegCert, Certificate.evalCombination]
  · intro step hstep
    simp [hxNonnegCert] at hstep
    subst step
    constructor
    -- The coefficient is nonnegative, and the semantic value is exactly `hHX`.
    · simp
    · simpa using hHX

end Examples
end LeanInfoTheory
