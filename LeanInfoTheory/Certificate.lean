/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.EntropyExpr

/-!
# Certificate skeleton for entropy inequalities

A certificate writes a target entropy inequality as a nonnegative combination of
known nonnegative inequalities. This first file proves the core soundness step
for any semantic interpretation of entropy atoms.
-/

namespace LeanInfoTheory

universe u

namespace Certificate

variable {Var : Type u} [DecidableEq Var]

/-- A weighted already-known inequality, represented by a nonnegative expression. -/
abbrev WeightedIneq (Var : Type u) [DecidableEq Var] := Rat × EntropyExpr Var

/-- Evaluate a list of weighted inequalities as a real linear combination. -/
noncomputable def evalCombination
    (value : EntropyAtom Var -> Real) : List (WeightedIneq Var) -> Real
  | [] => 0
  | step :: rest =>
      (step.1 : Real) * EntropyExpr.eval value step.2 + evalCombination value rest

/-- A certificate for a target expression. -/
structure Cert (Var : Type u) [DecidableEq Var] where
  target : EntropyExpr Var
  decomposition : List (WeightedIneq Var)

theorem evalCombination_nonneg
    (value : EntropyAtom Var -> Real)
    {steps : List (WeightedIneq Var)}
    (hsteps :
      forall step, step ∈ steps ->
        0 <= (step.1 : Real) ∧ 0 <= EntropyExpr.eval value step.2) :
    0 <= evalCombination value steps := by
  induction steps with
  | nil =>
      simp [evalCombination]
  | cons step rest ih =>
      have hstep :
          0 <= (step.1 : Real) ∧ 0 <= EntropyExpr.eval value step.2 :=
        hsteps step (by simp)
      have hrest :
          forall step, step ∈ rest ->
            0 <= (step.1 : Real) ∧ 0 <= EntropyExpr.eval value step.2 := by
        intro tailStep htailStep
        exact hsteps tailStep (by simp [htailStep])
      exact add_nonneg (mul_nonneg hstep.1 hstep.2) (ih hrest)

/--
Certificate soundness: if the target evaluates to the certified combination and
each ingredient is nonnegative under the semantic interpretation, then the
target inequality is nonnegative.
-/
theorem sound
    (value : EntropyAtom Var -> Real)
    (cert : Cert Var)
    (hdecomp :
      EntropyExpr.eval value cert.target =
        evalCombination value cert.decomposition)
    (hsteps :
      forall step, step ∈ cert.decomposition ->
        0 <= (step.1 : Real) ∧ 0 <= EntropyExpr.eval value step.2) :
    0 <= EntropyExpr.eval value cert.target := by
  rw [hdecomp]
  exact evalCombination_nonneg value hsteps

end Certificate

end LeanInfoTheory
