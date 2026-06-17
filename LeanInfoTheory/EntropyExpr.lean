/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import Mathlib.Data.Finsupp.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Rat.Defs
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Finsupp.LinearCombination

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

/-- Cast a rational entropy expression to real coefficients. -/
noncomputable def realCoeffs (e : EntropyExpr Var) :
    Finsupp (EntropyAtom Var) Real :=
  e.mapRange (fun q : Rat => (q : Real)) (by simp)

/--
Evaluate a formal entropy expression against any assignment of real values to
entropy atoms.
-/
noncomputable def eval (value : EntropyAtom Var -> Real) (e : EntropyExpr Var) : Real :=
  Finsupp.linearCombination Real value (realCoeffs e)

/--
An interpretation of entropy atoms respects the empty-entropy convention if it
assigns value `0` to `H(∅)`.

This is deliberately a separate predicate rather than a property of every
function `EntropyAtom Var -> Real`: the next certificate layer can require this
assumption, and the later concrete finite-family semantics should prove it.
-/
def RespectsEmpty (value : EntropyAtom Var -> Real) : Prop :=
  value (EntropyAtom.empty Var) = 0

/-- Casting coefficients to `Real` sends the zero expression to zero. -/
@[simp]
theorem realCoeffs_zero :
    realCoeffs (0 : EntropyExpr Var) = 0 := by
  ext atom
  simp [realCoeffs]

/-- Casting coefficients to `Real` sends a single rational coefficient to a single real one. -/
@[simp]
theorem realCoeffs_single (s : EntropyAtom Var) (q : Rat) :
    realCoeffs (Finsupp.single s q : EntropyExpr Var) = Finsupp.single s (q : Real) := by
  ext atom
  simp [realCoeffs]

/-- Casting coefficients to `Real` commutes with addition. -/
@[simp]
theorem realCoeffs_add (e₁ e₂ : EntropyExpr Var) :
    realCoeffs (e₁ + e₂) = realCoeffs e₁ + realCoeffs e₂ := by
  ext atom
  simp [realCoeffs, Rat.cast_add]

/-- Casting coefficients to `Real` commutes with negation. -/
@[simp]
theorem realCoeffs_neg (e : EntropyExpr Var) :
    realCoeffs (-e) = -realCoeffs e := by
  ext atom
  simp [realCoeffs]

/-- Casting coefficients to `Real` commutes with subtraction. -/
@[simp]
theorem realCoeffs_sub (e₁ e₂ : EntropyExpr Var) :
    realCoeffs (e₁ - e₂) = realCoeffs e₁ - realCoeffs e₂ := by
  ext atom
  simp [sub_eq_add_neg]

/-- Casting coefficients to `Real` commutes with rational scalar multiplication. -/
@[simp]
theorem realCoeffs_smul (q : Rat) (e : EntropyExpr Var) :
    realCoeffs (q • e) = (q : Real) • realCoeffs e := by
  ext atom
  simp [realCoeffs, Rat.cast_mul, smul_eq_mul]

/-- The zero formal expression evaluates to zero under every interpretation. -/
@[simp]
theorem eval_zero (value : EntropyAtom Var -> Real) :
    eval value (0 : EntropyExpr Var) = 0 := by
  simp [eval]

/-- Evaluation is additive in the formal entropy expression. -/
@[simp]
theorem eval_add
    (value : EntropyAtom Var -> Real) (e₁ e₂ : EntropyExpr Var) :
    eval value (e₁ + e₂) = eval value e₁ + eval value e₂ := by
  simp [eval]

/-- Evaluation commutes with subtracting formal entropy expressions. -/
@[simp]
theorem eval_sub
    (value : EntropyAtom Var -> Real) (e₁ e₂ : EntropyExpr Var) :
    eval value (e₁ - e₂) = eval value e₁ - eval value e₂ := by
  simp [eval]

/-- Evaluation commutes with negating a formal entropy expression. -/
@[simp]
theorem eval_neg
    (value : EntropyAtom Var -> Real) (e : EntropyExpr Var) :
    eval value (-e) = -eval value e := by
  simpa using (eval_sub value (0 : EntropyExpr Var) e)

/-- Evaluation commutes with rational scalar multiplication. -/
@[simp]
theorem eval_smul
    (value : EntropyAtom Var -> Real) (q : Rat) (e : EntropyExpr Var) :
    eval value (q • e) = (q : Real) * eval value e := by
  simp [eval, smul_eq_mul]

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
