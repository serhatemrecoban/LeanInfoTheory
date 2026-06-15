/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import Mathlib.Data.Finsupp.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Rat.Defs
import Mathlib.Data.Real.Basic

/-!
# Formal entropy expressions

Network-information converses often reduce to linear combinations of entropy
atoms such as `H(X,Y)`. This file starts that algebraic layer independently of
the analytic entropy definition.
-/

namespace LeanInfoTheory

universe u

/-- An entropy atom is a finite set of random-variable names. -/
abbrev EntropyAtom (Var : Type u) := Finset Var

/-- A formal rational linear combination of entropy atoms. -/
abbrev EntropyExpr (Var : Type u) [DecidableEq Var] := Finsupp (EntropyAtom Var) Rat

namespace EntropyExpr

variable {Var : Type u} [DecidableEq Var]

/-- The expression with coefficient `1` on one entropy atom. -/
noncomputable def atom (s : EntropyAtom Var) : EntropyExpr Var :=
  Finsupp.single s 1

/--
Evaluate a formal entropy expression against any assignment of real values to
entropy atoms.
-/
noncomputable def eval (value : EntropyAtom Var -> Real) (e : EntropyExpr Var) : Real :=
  e.sum fun atom coeff => (coeff : Real) * value atom

/-- The zero formal expression evaluates to zero under every interpretation. -/
@[simp]
theorem eval_zero (value : EntropyAtom Var -> Real) :
    eval value (0 : EntropyExpr Var) = 0 := by
  simp [eval]

/-- A single entropy atom evaluates to the value assigned to that atom. -/
@[simp]
theorem eval_atom (value : EntropyAtom Var -> Real) (s : EntropyAtom Var) :
    eval value (atom s) = value s := by
  simp [eval, atom]

end EntropyExpr

end LeanInfoTheory
