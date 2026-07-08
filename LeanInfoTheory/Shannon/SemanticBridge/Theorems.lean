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
* `condEntropy_nonneg`: `0 <= H(A|B)`;
* `condMutualInfo_nonneg`: `0 <= I(A;B|C)`;
* `mutualInfo_chain_rule_fst`: `I(A;B,C) = I(A;C) + I(A;B|C)`;
* `condEntropy_le_condEntropy_fstThirdMarginal`: `H(A|B,C) <= H(A|C)`.
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
Fiber conditional entropy is nonnegative:

`0 <= H(A | B=b)`.

On zero-mass fibers this is `0 <= 0`; on nonzero fibers it reduces to entropy
nonnegativity for the conditional law `P_{A|B=b}`.
-/
theorem condEntropyFstGivenSnd_nonneg
    {alpha : Type u} {beta : Type v}
    [Fintype alpha] (p : PMF (alpha × beta)) (b : beta) :
    0 <= condEntropyFstGivenSnd p b := by
  by_cases hb : sndMarginal p b = 0
  · rw [condEntropyFstGivenSnd_of_sndMarginal_eq_zero p hb]
  · rw [condEntropyFstGivenSnd_of_sndMarginal_ne_zero p hb]
    exact entropy_nonneg (condFstGivenSnd p b hb)

/--
Conditional entropy is nonnegative:

`0 <= H(A | B)`.

The proof uses the finite semantic bridge

`H(A | B) = sum_b P_B(b) * H(P_{A|B=b})`,

then every summand is nonnegative.
-/
theorem condEntropy_nonneg {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Fintype beta] (p : PMF (alpha × beta)) :
    0 <= condEntropy p := by
  rw [condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd]
  exact Finset.sum_nonneg fun b _hb =>
    mul_nonneg (PMF.toReal_nonneg (sndMarginal p) b)
      (condEntropyFstGivenSnd_nonneg p b)

/-- Conditional entropy of finite-valued random variables is nonnegative. -/
theorem condEntropyOf_nonneg
    {omega : Type u} {alpha : Type v} {beta : Type w}
    [Fintype alpha] [Fintype beta]
    (p : PMF omega) (X : omega -> alpha) (Y : omega -> beta) :
    0 <= condEntropyOf p X Y :=
  condEntropy_nonneg (p.map fun omega => (X omega, Y omega))

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

/--
Second mutual-information chain-rule variant:

`I(A;B,C) = I(A;B) + I(A;C | B)`.
-/
theorem mutualInfo_chain_rule_snd
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF (alpha × beta × gamma)) :
    mutualInfo p =
      mutualInfo (fstSndMarginal p) +
        condMutualInfo (p.map fun x => (x.1, x.2.2, x.2.1)) := by
  let q : PMF (alpha × gamma × beta) := p.map fun x => (x.1, x.2.2, x.2.1)
  change mutualInfo p = mutualInfo (fstSndMarginal p) + condMutualInfo q
  have hfst : fstMarginal (fstSndMarginal p) = fstMarginal p := by
    simp [fstMarginal, fstSndMarginal]
  have hthird : thirdMarginal q = sndMarginal (fstSndMarginal p) := by
    simp [q, thirdMarginal, sndMarginal, fstSndMarginal]
  have hfstthird : fstThirdMarginal q = fstSndMarginal p := by
    simp [q, fstThirdMarginal, fstSndMarginal]
  have hsndthird_entropy : entropy (sndThirdMarginal q) = entropy (sndMarginal p) := by
    have hsndthird : sndThirdMarginal q = (sndMarginal p).map Prod.swap := by
      unfold q sndThirdMarginal sndMarginal
      rw [PMF.map_comp, PMF.map_comp]
      rfl
    rw [hsndthird, entropy_map_swap]
  have hq_entropy : entropy q = entropy p := by
    have hswap :
        Function.Injective (fun x : alpha × beta × gamma => (x.1, x.2.2, x.2.1)) := by
      intro x y h
      exact
        Prod.ext
          (congrArg (fun z : alpha × gamma × beta => z.1) h)
          (Prod.ext
            (congrArg (fun z : alpha × gamma × beta => z.2.2) h)
            (congrArg (fun z : alpha × gamma × beta => z.2.1) h))
    exact entropy_map_injective (p := p) hswap
  rw [mutualInfo_eq, mutualInfo_eq, condMutualInfo_eq]
  rw [hfst, hfstthird, hthird, hsndthird_entropy, hq_entropy]
  ring

/--
Random-variable form of `mutualInfo_chain_rule_fst`:

`I(X;Y,Z) = I(X;Z) + I(X;Y | Z)`.
-/
theorem mutualInfoOf_chain_rule_fst
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega -> alpha) (Y : omega -> beta) (Z : omega -> gamma) :
    mutualInfoOf p X (fun omega => (Y omega, Z omega)) =
      mutualInfoOf p X Z + condMutualInfoOf p X Y Z := by
  simpa [mutualInfoOf, condMutualInfoOf] using
    mutualInfo_chain_rule_fst (p := p.map fun omega => (X omega, Y omega, Z omega))

/--
Random-variable form of `mutualInfo_chain_rule_snd`:

`I(X;Y,Z) = I(X;Y) + I(X;Z | Y)`.
-/
theorem mutualInfoOf_chain_rule_snd
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega -> alpha) (Y : omega -> beta) (Z : omega -> gamma) :
    mutualInfoOf p X (fun omega => (Y omega, Z omega)) =
      mutualInfoOf p X Y + condMutualInfoOf p X Z Y := by
  have hmap :
      (p.map fun omega => (X omega, Z omega, Y omega)) =
        (p.map fun omega => (X omega, Y omega, Z omega)).map
          (fun x : alpha × beta × gamma => (x.1, x.2.2, x.2.1)) := by
    simpa [Function.comp_def] using
      (PMF.map_comp
        (p := p)
        (f := fun omega => (X omega, Y omega, Z omega))
        (g := fun x : alpha × beta × gamma => (x.1, x.2.2, x.2.1))).symm
  simpa [mutualInfoOf, condMutualInfoOf, hmap] using
    mutualInfo_chain_rule_snd (p := p.map fun omega => (X omega, Y omega, Z omega))

/-! ## Conditioning reduces entropy -/

/--
Conditional mutual information as a difference of conditional entropies:

`I(A;B | C) = H(A | C) - H(A | B,C)`.
-/
theorem condMutualInfo_eq_condEntropy_fstThirdMarginal_sub_condEntropy
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF (alpha × beta × gamma)) :
    condMutualInfo p = condEntropy (fstThirdMarginal p) - condEntropy p := by
  rw [condMutualInfo_eq, condEntropy_eq, condEntropy_eq]
  rw [sndMarginal_fstThirdMarginal, sndMarginal_eq_sndThirdMarginal]
  ring

/--
Conditioning reduces entropy:

`H(A | B,C) <= H(A | C)`.

The proof rewrites the difference as `I(A;B | C)` and uses conditional mutual
information nonnegativity.
-/
theorem condEntropy_le_condEntropy_fstThirdMarginal
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF (alpha × beta × gamma)) :
    condEntropy p <= condEntropy (fstThirdMarginal p) := by
  have hnonneg := condMutualInfo_nonneg p
  rw [condMutualInfo_eq_condEntropy_fstThirdMarginal_sub_condEntropy] at hnonneg
  exact sub_nonneg.mp hnonneg

/--
Random-variable conditioning-reduces-entropy theorem:

`H(X | Y,Z) <= H(X | Z)`.
-/
theorem condEntropyOf_pair_le_condEntropyOf
    {omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
    [Fintype alpha] [Fintype beta] [Fintype gamma]
    (p : PMF omega) (X : omega -> alpha) (Y : omega -> beta) (Z : omega -> gamma) :
    condEntropyOf p X (fun omega => (Y omega, Z omega)) <= condEntropyOf p X Z := by
  simpa [condEntropyOf] using
    condEntropy_le_condEntropy_fstThirdMarginal
      (p := p.map fun omega => (X omega, Y omega, Z omega))

end

end Shannon
end LeanInfoTheory
