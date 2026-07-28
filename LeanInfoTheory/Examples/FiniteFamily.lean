/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Certificate.FiniteFamily
import LeanInfoTheory.Certificate.Submodularity

/-!
# Finite-family entropy examples

This module exercises the finite-family API on a homogeneous Boolean model and
a model with dependent coordinate alphabets. It also keeps the two certificate
trust paths visibly separate:

* `BooleanModel.submodularity_checked` applies a proof-carrying checked
  certificate directly to concrete Shannon entropy;
* `BooleanModel.submodularity_raw` first uses the existing raw-certificate
  validator theorem and then invokes generic validated-certificate soundness.

The variable-name types deliberately have no `Fintype` instances. Only the
coordinate alphabets used by entropy are finite.
-/

namespace LeanInfoTheory
namespace Examples
namespace FiniteFamily

noncomputable section

open scoped BigOperators

/-! ## A homogeneous Boolean family -/

namespace BooleanModel

/-- Names for two source bits and their parity bit. -/
inductive Var where
  | left
  | right
  | parity
  deriving DecidableEq, Repr

/-- A uniform two-bit source. -/
def source : PMF (Bool × Bool) :=
  PMF.uniformOfFintype (Bool × Bool)

/-- The two source coordinates together with their parity. -/
def coordinates : (i : Var) -> Bool × Bool -> Bool
  | .left, x => x.1
  | .right, x => x.2
  | .parity, x => x.1 != x.2

/-- The full law of the Boolean family. -/
def law : PMF ((i : Var) -> Bool) :=
  Shannon.familyLawOf source coordinates

/-- The order used by the mutual-information chain-rule example. -/
def order : List Var :=
  [.left, .right]

/-- The family mutual-information chain rule on the Boolean model. -/
theorem mutualInfo_chain_rule :
    Shannon.familyMutualInfo law order.toFinset {Var.parity} =
      ∑ k : Fin order.length,
        Shannon.familyCondMutualInfo law {order.get k} {Var.parity}
          (order.take k).toFinset := by
  exact Shannon.familyMutualInfo_chain_rule_of_nodup
    law order {Var.parity} (by decide)

/-- The first atom in the overlapping submodularity example. -/
def leftAtom : Finset Var :=
  {Var.left, Var.parity}

/-- The second atom in the overlapping submodularity example. -/
def rightAtom : Finset Var :=
  {Var.right, Var.parity}

/--
The checked submodularity certificate is sound for the concrete Boolean-family
entropy valuation.
-/
theorem submodularity_checked :
    0 <= EntropyExpr.eval (Shannon.familyEntropy law)
      (Certificate.Submodularity.checkedCert leftAtom rightAtom).target := by
  exact Certificate.CheckedCert.sound_finiteFamily
    (Certificate.Submodularity.checkedCert leftAtom rightAtom) law

/--
The raw submodularity certificate proves the same concrete Shannon inequality
only after the existing validator has accepted its primitive tag and exact
decomposition.
-/
theorem submodularity_raw :
    0 <= EntropyExpr.eval (Shannon.familyEntropy law)
      (Certificate.Submodularity.rawCert leftAtom rightAtom).target := by
  simpa only [Shannon.finiteFamilyEntropyVal_eval] using
    Certificate.RawCert.sound_of_toCheckedCert?_isSome
      (Certificate.Submodularity.rawCert_toCheckedCert?_isSome
        (a := leftAtom) (b := rightAtom))
      (Shannon.finiteFamilyEntropyVal law)

end BooleanModel

/-! ## A family with dependent alphabets -/

namespace HeterogeneousModel

/-- Names for a Boolean coordinate and a ternary coordinate. -/
inductive Var where
  | bit
  | trit
  deriving DecidableEq, Repr

/-- The coordinate alphabet, which depends on the variable name. -/
def Alphabet : Var -> Type
  | .bit => Bool
  | .trit => Fin 3

private instance alphabetFintype (i : Var) : Fintype (Alphabet i) := by
  cases i with
  | bit =>
      change Fintype Bool
      infer_instance
  | trit =>
      change Fintype (Fin 3)
      infer_instance

/-- A uniform source carrying one Boolean and one ternary coordinate. -/
def source : PMF (Bool × Fin 3) :=
  PMF.uniformOfFintype (Bool × Fin 3)

/-- The dependent family of source coordinates. -/
def coordinates : (i : Var) -> Bool × Fin 3 -> Alphabet i
  | .bit, x => x.1
  | .trit, x => x.2

/-- The full law of the heterogeneous family. -/
def law : PMF ((i : Var) -> Alphabet i) :=
  Shannon.familyLawOf source coordinates

/-- The textbook order of the two heterogeneous coordinates. -/
def order : List Var :=
  [.bit, .trit]

/-- The source-family entropy chain rule for dependent coordinate alphabets. -/
theorem entropy_chain_rule :
    Shannon.familyEntropyOf source coordinates order.toFinset =
      ∑ k : Fin order.length,
        Shannon.familyCondEntropyOf source coordinates {order.get k}
          (order.take k).toFinset := by
  exact Shannon.familyEntropyOf_chain_rule_of_nodup
    source coordinates order (by decide)

/-- The empty heterogeneous subfamily has zero entropy. -/
theorem empty_entropy :
    Shannon.familyEntropyOf source coordinates ∅ = 0 :=
  Shannon.familyEntropyOf_empty source coordinates

end HeterogeneousModel

end

end FiniteFamily
end Examples
end LeanInfoTheory
