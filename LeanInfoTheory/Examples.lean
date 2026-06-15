/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Certificate

/-!
# Toy examples

These examples are intentionally small. Their job is to keep the initial project
honest: the scaffold contains at least one closed Lean theorem in the certificate
layer, even before the analytic entropy API is complete.
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
