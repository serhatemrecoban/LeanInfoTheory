/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Certificate.Checked
import LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily

/-!
# Checked certificates under finite-family semantics

This module is an adapter from the existing checked-certificate soundness
theorem to actual Shannon entropy of finite family atoms. It does not add a
validation path, inspect a certificate decomposition, or change the trust
boundary: all certificate soundness still passes through `CheckedCert.sound`.
-/

namespace LeanInfoTheory

universe u v

namespace Certificate
namespace CheckedCert

/--
A checked entropy-inequality certificate is sound when interpreted as actual
Shannon entropy of finite family atoms.
-/
theorem sound_finiteFamily
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (cert : CheckedCert Var)
    (q : PMF ((i : Var) -> alpha i)) :
    0 <= EntropyExpr.eval (Shannon.familyEntropy q) cert.target := by
  simpa only [Shannon.finiteFamilyEntropyVal_eval] using
    cert.sound (Shannon.finiteFamilyEntropyVal q)

end CheckedCert
end Certificate
end LeanInfoTheory
