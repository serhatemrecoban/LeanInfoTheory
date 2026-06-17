/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.EntropyVal

/-!
# Primitive Shannon inequality expressions

This file defines the first primitive Shannon-type inequalities as formal
entropy expressions. Each expression is intended to be interpreted as a
nonnegative quantity after evaluation by a suitable entropy valuation.
-/

namespace LeanInfoTheory

universe u

namespace PrimitiveIneq

variable {Var : Type u} [DecidableEq Var]

/-- The primitive empty-entropy expression `H(empty)`. -/
noncomputable def emptyEntropy (Var : Type u) [DecidableEq Var] : EntropyExpr Var :=
  EntropyExpr.empty Var

/--
The primitive conditional-entropy expression `H(S ∪ {i}) - H(S)`.

When evaluated by a Shannon entropy valuation and `i ∉ S`, this should be
nonnegative.
-/
noncomputable def condEntropy (s : EntropyAtom Var) (i : Var) : EntropyExpr Var :=
  EntropyExpr.atom (insert i s) - EntropyExpr.atom s

/--
The primitive conditional-mutual-information expression
`H(A,C) + H(B,C) - H(A,B,C) - H(C)`.

When evaluated by a Shannon entropy valuation, this should be nonnegative.
-/
noncomputable def condMutualInfo
    (a b c : EntropyAtom Var) : EntropyExpr Var :=
  EntropyExpr.atom (a ∪ c) + EntropyExpr.atom (b ∪ c) -
    EntropyExpr.atom (a ∪ b ∪ c) - EntropyExpr.atom c

/-- Evaluation formula for the primitive empty-entropy expression. -/
@[simp]
theorem eval_emptyEntropy (value : EntropyAtom Var -> Real) :
    EntropyExpr.eval value (emptyEntropy Var) = value (EntropyAtom.empty Var) := by
  simp [emptyEntropy]

/-- Evaluation formula for primitive conditional entropy. -/
@[simp]
theorem eval_condEntropy
    (value : EntropyAtom Var -> Real) (s : EntropyAtom Var) (i : Var) :
    EntropyExpr.eval value (condEntropy s i) = value (insert i s) - value s := by
  simp [condEntropy]

/-- Evaluation formula for primitive conditional mutual information. -/
@[simp]
theorem eval_condMutualInfo
    (value : EntropyAtom Var -> Real) (a b c : EntropyAtom Var) :
    EntropyExpr.eval value (condMutualInfo a b c) =
      value (a ∪ c) + value (b ∪ c) - value (a ∪ b ∪ c) - value c := by
  simp [condMutualInfo]

/-- Shannon-valuation evaluation formula for the empty-entropy primitive. -/
@[simp]
theorem shannonEval_emptyEntropy (h : ShannonEntropyVal Var) :
    ShannonEntropyVal.eval h (emptyEntropy Var) = 0 := by
  simp [ShannonEntropyVal.eval]

/-- Shannon-valuation evaluation formula for primitive conditional entropy. -/
@[simp]
theorem shannonEval_condEntropy
    (h : ShannonEntropyVal Var) (s : EntropyAtom Var) (i : Var) :
    ShannonEntropyVal.eval h (condEntropy s i) = h (insert i s) - h s := by
  simp [ShannonEntropyVal.eval]

/--
Shannon-valuation evaluation formula for primitive conditional mutual
information.
-/
@[simp]
theorem shannonEval_condMutualInfo
    (h : ShannonEntropyVal Var) (a b c : EntropyAtom Var) :
    ShannonEntropyVal.eval h (condMutualInfo a b c) =
      h (a ∪ c) + h (b ∪ c) - h (a ∪ b ∪ c) - h c := by
  simp [ShannonEntropyVal.eval]

/-- The empty-entropy primitive evaluates to a nonnegative quantity. -/
theorem emptyEntropy_nonneg (h : ShannonEntropyVal Var) :
    0 <= ShannonEntropyVal.eval h (emptyEntropy Var) := by
  simp

/--
Primitive conditional entropy is nonnegative under a Shannon entropy valuation
when the adjoined variable is not already present.
-/
theorem condEntropy_nonneg
    (h : ShannonEntropyVal Var) {s : EntropyAtom Var} {i : Var} (hi : i ∉ s) :
    0 <= ShannonEntropyVal.eval h (condEntropy s i) := by
  simpa using h.cond_nonneg s i hi

/--
Primitive conditional mutual information is nonnegative under a Shannon entropy
valuation.
-/
theorem condMutualInfo_nonneg
    (h : ShannonEntropyVal Var) (a b c : EntropyAtom Var) :
    0 <= ShannonEntropyVal.eval h (condMutualInfo a b c) := by
  simpa using h.cmi_nonneg a b c

/--
The primitive Shannon inequalities that the first checked certificate layer is
allowed to use as trusted ingredients.
-/
inductive Kind (Var : Type u) where
  /-- The empty entropy convention `H(empty) = 0`. -/
  | emptyEntropy : Kind Var
  /--
  Conditional entropy nonnegativity for adding one new variable to an atom.
  The proof field records that the variable is genuinely new.
  -/
  | condEntropy (s : EntropyAtom Var) (i : Var) (hi : i ∉ s) : Kind Var
  /-- Conditional mutual information nonnegativity. -/
  | condMutualInfo (a b c : EntropyAtom Var) : Kind Var

namespace Kind

variable {Var : Type u} [DecidableEq Var]

/-- The entropy expression represented by a primitive Shannon inequality. -/
noncomputable def expr : Kind Var -> EntropyExpr Var
  | .emptyEntropy => PrimitiveIneq.emptyEntropy Var
  | .condEntropy s i _ => PrimitiveIneq.condEntropy s i
  | .condMutualInfo a b c => PrimitiveIneq.condMutualInfo a b c

/-- Every primitive Shannon inequality is sound under a Shannon entropy valuation. -/
theorem nonneg (h : ShannonEntropyVal Var) :
    forall kind : Kind Var, 0 <= ShannonEntropyVal.eval h kind.expr
  | .emptyEntropy => by
      simp [expr]
  | .condEntropy s i hi => by
      simpa [expr] using condEntropy_nonneg h hi
  | .condMutualInfo a b c => by
      simpa [expr] using condMutualInfo_nonneg h a b c

end Kind

end PrimitiveIneq

end LeanInfoTheory
