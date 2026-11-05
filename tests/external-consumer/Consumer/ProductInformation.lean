/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.ProductChannel

/-!
# Product-channel information with arbitrary inputs

Coordinate information caps bound block information under the actual input
marginals. The duplicated Boolean input application allows dependence; no
independence is inferred from the product alphabet.
-/

namespace Consumer.ProductInformation

open LeanInfoTheory.Shannon
open scoped BigOperators

universe u v w

open Classical in
example {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (q : PMF (∀ i, A i)) (W : ∀ i, A i → PMF (B i))
    (r : I → ℝ)
    (hr : ∀ i,
      mutualInfo (PMF.channelJoint (q.map (fun x => x i)) (W i)) ≤ r i) :
    mutualInfo (PMF.channelJoint q (PMF.productChannel W)) ≤ ∑ i, r i := by
  exact (mutualInfo_channelJoint_productChannel_le q W).trans
    (Finset.sum_le_sum (fun i _ => hr i))

open Classical in
example (p : PMF Bool) (W : Bool → PMF Bool) :
    mutualInfo (PMF.channelJoint
      (p.map (fun b (_ : Fin 2) => b))
      (PMF.productChannel (fun (_ : Fin 2) => W))) ≤
      2 * mutualInfo (PMF.channelJoint p W) := by
  have hm (i : Fin 2) :
      (p.map (fun b (_ : Fin 2) => b)).map (fun x => x i) = p := by
    rw [PMF.map_comp]
    exact PMF.map_id p
  have h := mutualInfo_channelJoint_productChannel_le
    (p.map (fun b (_ : Fin 2) => b)) (fun (_ : Fin 2) => W)
  simp only [hm, Fin.sum_univ_two] at h
  rw [two_mul]
  convert! h

end Consumer.ProductInformation
