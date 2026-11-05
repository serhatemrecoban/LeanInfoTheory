/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory

/-!
# Retained information laws through the lightweight root

An invertible relabeling preserves the information in a diagonal joint law.
This module intentionally imports only the lightweight public root.
-/

namespace Consumer.RootOnly

universe u v

example {A : Type u} {B : Type v} [Fintype A] [Fintype B]
    (p : PMF A) (e : A ≃ B) :
    LeanInfoTheory.mutualInfo
      ((p.map e).map (fun b => (b, b))) = LeanInfoTheory.entropy p := by
  rw [LeanInfoTheory.mutualInfo_map_diag]
  exact LeanInfoTheory.Shannon.entropy_map_equiv p e

end Consumer.RootOnly
