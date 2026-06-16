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

namespace EntropyAtom

/-- The empty entropy atom, conventionally written `H(∅)`. -/
abbrev empty (Var : Type u) : EntropyAtom Var :=
  ∅

end EntropyAtom

/-- A formal rational linear combination of entropy atoms. -/
abbrev EntropyExpr (Var : Type u) [DecidableEq Var] := Finsupp (EntropyAtom Var) Rat

namespace EntropyExpr

variable {Var : Type u} [DecidableEq Var]

/-- The expression with coefficient `1` on one entropy atom. -/
noncomputable def atom (s : EntropyAtom Var) : EntropyExpr Var :=
  Finsupp.single s 1

/-- The formal entropy expression `H(∅)`. -/
noncomputable def empty (Var : Type u) [DecidableEq Var] : EntropyExpr Var :=
  atom (EntropyAtom.empty Var)

/--
Evaluate a formal entropy expression against any assignment of real values to
entropy atoms.
-/
noncomputable def eval (value : EntropyAtom Var -> Real) (e : EntropyExpr Var) : Real :=
  e.sum fun atom coeff => (coeff : Real) * value atom

/--
An interpretation of entropy atoms respects the empty-entropy convention if it
assigns value `0` to `H(∅)`.

This is deliberately a separate predicate rather than a property of every
function `EntropyAtom Var -> Real`: the next certificate layer can require this
assumption, and the later concrete finite-family semantics should prove it.
-/
def RespectsEmpty (value : EntropyAtom Var -> Real) : Prop :=
  value (EntropyAtom.empty Var) = 0

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

/-- The empty entropy expression evaluates to the value assigned to the empty atom. -/
@[simp]
theorem eval_empty (value : EntropyAtom Var -> Real) :
    eval value (empty Var) = value (EntropyAtom.empty Var) := by
  simp [empty]

/-- Under the empty-entropy convention, the expression `H(∅)` evaluates to zero. -/
theorem eval_empty_eq_zero_of_respectsEmpty
    {value : EntropyAtom Var -> Real} (hvalue : RespectsEmpty value) :
    eval value (empty Var) = 0 := by
  simpa [RespectsEmpty] using hvalue

/--
For an arbitrary atom interpretation, respecting the empty-entropy convention is
equivalent to evaluating the formal expression `H(∅)` as zero.
-/
theorem respectsEmpty_iff_eval_empty_eq_zero
    (value : EntropyAtom Var -> Real) :
    RespectsEmpty value ↔ eval value (empty Var) = 0 := by
  simp [RespectsEmpty]

end EntropyExpr

end LeanInfoTheory
