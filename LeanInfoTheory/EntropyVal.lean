/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.EntropyExpr

/-!
# Abstract Shannon entropy valuations

This file packages the semantic assumptions used by Shannon-type entropy
inequality certificates, independently of any concrete probability model.

The intended use is:

- the certificate layer can first prove inequalities for any
  `ShannonEntropyVal`;
- later finite-`PMF` semantics should prove that concrete entropy assignments
  give examples of this structure.
-/

namespace LeanInfoTheory

universe u

/--
An abstract Shannon entropy valuation assigns a real value to every entropy
atom and records the basic Shannon-type facts needed by the certificate layer.

The fields are intentionally semantic assumptions rather than proved facts:
concrete finite-probability models should instantiate this structure later.
-/
structure ShannonEntropyVal (Var : Type u) [DecidableEq Var] where
  /-- The real value assigned to each entropy atom. -/
  value : EntropyAtom Var -> Real
  /-- The empty entropy convention: `H(∅) = 0`. -/
  empty_eq_zero : value (EntropyAtom.empty Var) = 0
  /--
  Conditional entropy nonnegativity for adjoining one variable:
  `H(S ∪ {i}) - H(S) >= 0` when `i ∉ S`.
  -/
  cond_nonneg :
    forall (s : EntropyAtom Var) (i : Var),
      i ∉ s -> 0 <= value (insert i s) - value s
  /--
  Conditional mutual information nonnegativity:
  `H(A,C) + H(B,C) - H(A,B,C) - H(C) >= 0`.
  -/
  cmi_nonneg :
    forall (a b c : EntropyAtom Var),
      0 <= value (a ∪ c) + value (b ∪ c) - value (a ∪ b ∪ c) - value c

namespace ShannonEntropyVal

variable {Var : Type u} [DecidableEq Var]

instance : CoeFun (ShannonEntropyVal Var) (fun _ => EntropyAtom Var -> Real) where
  coe h := h.value

/-- Evaluate an entropy expression using an abstract Shannon entropy valuation. -/
noncomputable def eval (h : ShannonEntropyVal Var) (e : EntropyExpr Var) : Real :=
  EntropyExpr.eval h e

/-- A Shannon entropy valuation respects the empty-entropy convention. -/
theorem respectsEmpty (h : ShannonEntropyVal Var) : EntropyExpr.RespectsEmpty h := by
  simpa [EntropyExpr.RespectsEmpty] using h.empty_eq_zero

/-- The empty atom has value zero under a Shannon entropy valuation. -/
@[simp]
theorem apply_empty (h : ShannonEntropyVal Var) :
    h (EntropyAtom.empty Var) = 0 :=
  h.empty_eq_zero

/-- The zero expression evaluates to zero under a Shannon entropy valuation. -/
@[simp]
theorem eval_zero (h : ShannonEntropyVal Var) :
    eval h (0 : EntropyExpr Var) = 0 := by
  simp [eval]

/-- A single entropy atom evaluates to the value assigned by the valuation. -/
@[simp]
theorem eval_atom (h : ShannonEntropyVal Var) (s : EntropyAtom Var) :
    eval h (EntropyExpr.atom s) = h s := by
  simp [eval]

/-- The empty entropy expression evaluates to zero under a Shannon entropy valuation. -/
@[simp]
theorem eval_empty (h : ShannonEntropyVal Var) :
    eval h (EntropyExpr.empty Var) = 0 := by
  exact EntropyExpr.eval_empty_eq_zero_of_respectsEmpty (respectsEmpty h)

end ShannonEntropyVal

end LeanInfoTheory
