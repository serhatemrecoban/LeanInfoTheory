/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.KL

/-!
# First semantic theorem API for finite Shannon information measures

This file collects the first user-facing semantic consequences of the bridge
layer.  The theorems here are stated in the finite-PMF vocabulary of
`LeanInfoTheory.Shannon`, while their proofs reuse the KL and conditional-law
bridges from the lower semantic bridge files.

The main results are:

* `mutualInfo_nonneg`: `0 <= I(A;B)`;
* `condMutualInfo_nonneg`: `0 <= I(A;B|C)`;
* `mutualInfo_chain_rule_fst`: `I(A;B,C) = I(A;C) + I(A;B|C)`.
-/

namespace LeanInfoTheory
namespace Shannon

open scoped BigOperators

noncomputable section

universe u v w

/-! ## Nonnegativity -/

/--
Mutual information is nonnegative:

`0 <= I(A;B)`.

The proof passes through the semantic bridge
`I(A;B) = D(P_AB || P_A x P_B)` and then uses nonnegativity of the real
coercion of an `ENNReal` KL divergence.
-/
theorem mutualInfo_nonneg {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta] (p : PMF (alpha × beta)) :
    0 <= mutualInfo p := by
  letI : MeasurableSpace (alpha × beta) := ⊤
  haveI : MeasurableSingletonClass (alpha × beta) := ⟨fun _ => trivial⟩
  rw [mutualInfo_eq_toReal_klDiv_joint_indepProd (p := p)]
  exact ENNReal.toReal_nonneg

/--
Fiber conditional mutual information is nonnegative:

`0 <= I(A;B | C=c)`.

On zero-mass fibers this is `0 <= 0`; on nonzero fibers it reduces to
`mutualInfo_nonneg` applied to the conditional joint law `P_{A,B|C=c}`.
-/
theorem condMutualInfoFstSndGivenThird_nonneg
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Fintype alpha] [Fintype beta]
    (p : PMF (alpha × beta × gamma)) (c : gamma) :
    0 <= condMutualInfoFstSndGivenThird p c := by
  by_cases hc : thirdMarginal p c = 0
  · rw [condMutualInfoFstSndGivenThird_of_thirdMarginal_eq_zero p hc]
  · rw [condMutualInfoFstSndGivenThird_of_thirdMarginal_ne_zero p hc]
    exact mutualInfo_nonneg (condFstSndGivenThird p c hc)

/--
Conditional mutual information is nonnegative:

`0 <= I(A;B | C)`.

We use the finite semantic bridge

`I(A;B | C) = sum_c P_C(c) * I(A;B | C=c)`,

then each summand is nonnegative because both `P_C(c)` and the fiber mutual
information are nonnegative.
-/
theorem condMutualInfo_nonneg
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF (alpha × beta × gamma)) :
    0 <= condMutualInfo p := by
  rw [condMutualInfo_eq_sum_thirdMarginal_mul_condMutualInfoFstSndGivenThird]
  exact Finset.sum_nonneg fun c _hc =>
    mul_nonneg (PMF.toReal_nonneg (thirdMarginal p) c)
      (condMutualInfoFstSndGivenThird_nonneg p c)

/-! ## Marginal reassociation lemmas -/

/--
Taking the first marginal after projecting `(A,B,C)` to `(A,C)` recovers the
first marginal of the original law:

`(P_AC)_A = P_A`.
-/
@[simp]
theorem fstMarginal_fstThirdMarginal
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    (p : PMF (alpha × beta × gamma)) :
    fstMarginal (fstThirdMarginal p) = fstMarginal p := by
  simp [fstMarginal, fstThirdMarginal]

/--
Viewing a triple law as a joint law of `A` and `(B,C)`, the second marginal is
the same law as the explicit `(B,C)` marginal:

`P_{B,C} = sndMarginal P_{A,(B,C)}`.
-/
@[simp]
theorem sndMarginal_eq_sndThirdMarginal
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    (p : PMF (alpha × beta × gamma)) :
    sndMarginal p = sndThirdMarginal p := by
  simp [sndMarginal, sndThirdMarginal]

/-! ## Chain rules -/

/--
First mutual-information chain rule:

`I(A;B,C) = I(A;C) + I(A;B | C)`.

In Lean's right-associated product convention, a PMF
`p : PMF (alpha × beta × gamma)` is also a joint law of `A` and `(B,C)`, so
`mutualInfo p` denotes `I(A;B,C)`.
-/
theorem mutualInfo_chain_rule_fst
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF (alpha × beta × gamma)) :
    mutualInfo p = mutualInfo (fstThirdMarginal p) + condMutualInfo p := by
  rw [mutualInfo_eq, mutualInfo_eq, condMutualInfo_eq]
  rw [fstMarginal_fstThirdMarginal, sndMarginal_fstThirdMarginal,
    sndMarginal_eq_sndThirdMarginal]
  ring

end

end Shannon
end LeanInfoTheory
