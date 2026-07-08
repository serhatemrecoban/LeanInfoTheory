/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Certificate
import LeanInfoTheory.PrimitiveIneq
import Mathlib.Data.Rat.Cast.Order

/-!
# Checked entropy-inequality certificates

This file separates untrusted raw certificate data from certificates that carry
the proof data needed by Lean. The checked layer is still deliberately small,
but it now includes the first validator from raw primitive-tagged steps into
proof-carrying checked certificates.
-/

namespace LeanInfoTheory

universe u

namespace Certificate

variable {Var : Type u} [DecidableEq Var]

/--
An untrusted certificate step as it might be parsed from an external source.
No soundness proof should use a `RawStep` directly.
-/
structure RawStep (Var : Type u) [DecidableEq Var] where
  /-- The proposed rational coefficient. It has not yet been checked nonnegative. -/
  coeff : Rat
  /-- The proposed ingredient expression. It has not yet been checked primitive. -/
  expr : EntropyExpr Var

/--
An untrusted certificate as it might be parsed from an external source.
It must be validated before it can justify an entropy inequality.
-/
structure RawCert (Var : Type u) [DecidableEq Var] where
  /-- The proposed target inequality expression. -/
  target : EntropyExpr Var
  /-- The proposed decomposition steps. -/
  decomposition : List (RawStep Var)

namespace RawStep

/-- Forget a raw step into the older generic weighted-inequality format. -/
noncomputable def toWeightedIneq (step : RawStep Var) : WeightedIneq Var :=
  (step.coeff, step.expr)

end RawStep

namespace RawCert

/-- Forget a raw certificate into the older generic certificate format. -/
noncomputable def toCert (cert : RawCert Var) : Cert Var where
  target := cert.target
  decomposition := cert.decomposition.map RawStep.toWeightedIneq

end RawCert

/--
A checked certificate step. Its coefficient has been proved nonnegative, and
its ingredient is one of the primitive Shannon inequalities.
-/
structure CheckedStep (Var : Type u) [DecidableEq Var] where
  /-- The checked nonnegative rational coefficient. -/
  coeff : NNRat
  /-- The primitive Shannon inequality used by this step. -/
  primitive : PrimitiveIneq.Kind Var

namespace CheckedStep

/-- The entropy expression used by a checked step. -/
noncomputable def expr (step : CheckedStep Var) : EntropyExpr Var :=
  step.primitive.expr

/-- Forget a checked step into the older generic weighted-inequality format. -/
noncomputable def toWeightedIneq (step : CheckedStep Var) : WeightedIneq Var :=
  ((step.coeff : Rat), step.expr)

/-- The coefficient of a checked step is nonnegative as a rational number. -/
theorem coeff_rat_nonneg (step : CheckedStep Var) :
    0 <= (step.coeff : Rat) :=
  step.coeff.2

/-- The coefficient of a checked step is nonnegative after casting to `Real`. -/
theorem coeff_real_nonneg (step : CheckedStep Var) :
    0 <= ((step.coeff : Rat) : Real) := by
  exact (Rat.cast_nonneg (K := Real)).mpr step.coeff_rat_nonneg

/-- The ingredient expression of a checked step is nonnegative under any Shannon valuation. -/
theorem expr_nonneg (step : CheckedStep Var) (h : ShannonEntropyVal Var) :
    0 <= ShannonEntropyVal.eval h step.expr :=
  PrimitiveIneq.Kind.nonneg h step.primitive

end CheckedStep

namespace RawStep

/--
Validate a raw step against a proposed primitive Shannon inequality.

The check accepts exactly when the raw coefficient is nonnegative and the raw
expression is equal to the primitive expression as a normalized sparse entropy
expression. The resulting `CheckedStep` carries the nonnegative coefficient as
an `NNRat`.
-/
noncomputable def toCheckedStep? (step : RawStep Var)
    (primitive : PrimitiveIneq.Kind Var) : Option (CheckedStep Var) :=
  if hcoeff : 0 <= step.coeff then
    if _ : step.expr = primitive.expr then
      some
        { coeff := ⟨step.coeff, hcoeff⟩
          primitive := primitive }
    else
      none
  else
    none

end RawStep

/--
Validate raw steps against a parallel list of primitive Shannon inequalities.

This is intentionally list-shaped for the first certificate layer: external
certificate import can parse candidate primitive tags separately, and this
function checks that every raw expression and coefficient agrees with those
tags.
-/
noncomputable def checkStepsAgainstPrimitives? :
    List (RawStep Var) -> List (PrimitiveIneq.Kind Var) -> Option (List (CheckedStep Var))
  | [], [] => some []
  | rawStep :: rawSteps, primitive :: primitives => do
      let checkedStep <- rawStep.toCheckedStep? primitive
      let checkedSteps <- checkStepsAgainstPrimitives? rawSteps primitives
      pure (checkedStep :: checkedSteps)
  | _, _ => none

/-- A checked certificate for a target entropy inequality. -/
structure CheckedCert (Var : Type u) [DecidableEq Var] where
  /-- The entropy expression whose nonnegativity the certificate proves. -/
  target : EntropyExpr Var
  /-- The checked primitive decomposition steps. -/
  decomposition : List (CheckedStep Var)
  /--
  Exact rational expression equality between the target and the checked
  decomposition. Because entropy expressions are sparse `Finsupp`s over `Rat`,
  this is the deterministic normalized equality check for the current layer.
  -/
  decomposition_matches :
    DecompositionMatches target (decomposition.map CheckedStep.toWeightedIneq)

namespace CheckedCert

/-- Forget a checked certificate into the older generic certificate format. -/
noncomputable def toCert (cert : CheckedCert Var) : Cert Var where
  target := cert.target
  decomposition := cert.decomposition.map CheckedStep.toWeightedIneq

/-- Every checked step in a checked certificate is semantically nonnegative. -/
theorem steps_nonneg (cert : CheckedCert Var) (h : ShannonEntropyVal Var) :
    forall step, step ∈ cert.toCert.decomposition ->
      0 <= (step.1 : Real) ∧ 0 <= EntropyExpr.eval h step.2 := by
  intro step hstep
  rcases List.mem_map.mp hstep with ⟨checkedStep, _hcheckedStep, rfl⟩
  exact ⟨CheckedStep.coeff_real_nonneg checkedStep, CheckedStep.expr_nonneg checkedStep h⟩

/-- Checked certificate soundness under any abstract Shannon entropy valuation. -/
theorem sound (cert : CheckedCert Var) (h : ShannonEntropyVal Var) :
    0 <= ShannonEntropyVal.eval h cert.target := by
  exact Certificate.sound_of_decompositionMatches
    (value := h)
    (cert := cert.toCert)
    (hdecomp := cert.decomposition_matches)
    (hsteps := cert.steps_nonneg h)

end CheckedCert

namespace RawCert

/--
Validate a raw certificate against a list of proposed primitive Shannon
ingredients. The validator checks each raw step against the corresponding
primitive tag, then checks exact rational equality between the target and the
resulting checked decomposition.
-/
noncomputable def toCheckedCert? (cert : RawCert Var)
    (primitives : List (PrimitiveIneq.Kind Var)) : Option (CheckedCert Var) := by
  classical
  exact do
    let checkedSteps <- checkStepsAgainstPrimitives? cert.decomposition primitives
    if hdecomp :
        DecompositionMatches cert.target (checkedSteps.map CheckedStep.toWeightedIneq) then
      some
        { target := cert.target
          decomposition := checkedSteps
          decomposition_matches := hdecomp }
    else
      none

/-- Any successfully validated raw certificate proves its raw target expression. -/
theorem sound_of_toCheckedCert?_eq_some
    {cert : RawCert Var} {primitives : List (PrimitiveIneq.Kind Var)}
    {checked : CheckedCert Var}
    (hchecked : cert.toCheckedCert? primitives = some checked)
    (h : ShannonEntropyVal Var) :
    0 <= ShannonEntropyVal.eval h cert.target := by
  classical
  unfold toCheckedCert? at hchecked
  cases hsteps : checkStepsAgainstPrimitives? cert.decomposition primitives with
  | none =>
      rw [hsteps] at hchecked
      change (none : Option (CheckedCert Var)) = some checked at hchecked
      cases hchecked
  | some checkedSteps =>
    rw [hsteps] at hchecked
    change
      (if hdecomp :
          DecompositionMatches cert.target (checkedSteps.map CheckedStep.toWeightedIneq) then
        some
          { target := cert.target
            decomposition := checkedSteps
            decomposition_matches := hdecomp }
      else
        none) = some checked at hchecked
    by_cases hdecomp :
        DecompositionMatches cert.target (checkedSteps.map CheckedStep.toWeightedIneq)
    · rw [dif_pos hdecomp] at hchecked
      cases hchecked
      exact CheckedCert.sound
        { target := cert.target
          decomposition := checkedSteps
          decomposition_matches := hdecomp } h
    · rw [dif_neg hdecomp] at hchecked
      cases hchecked

/--
Any raw certificate whose validation returns some checked certificate proves
its raw target expression.

This is the ergonomic form used by certificate demos: once a concrete raw
certificate has a validation theorem of the form
`(cert.toCheckedCert? primitives).isSome`, callers do not need to split the
resulting option by hand.
-/
theorem sound_of_toCheckedCert?_isSome
    {cert : RawCert Var} {primitives : List (PrimitiveIneq.Kind Var)}
    (hvalidated : (cert.toCheckedCert? primitives).isSome)
    (h : ShannonEntropyVal Var) :
    0 <= ShannonEntropyVal.eval h cert.target := by
  cases hchecked : cert.toCheckedCert? primitives with
  | none =>
      simp [hchecked] at hvalidated
  | some _checked =>
      exact sound_of_toCheckedCert?_eq_some hchecked h

end RawCert

end Certificate

end LeanInfoTheory
