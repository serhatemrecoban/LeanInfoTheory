/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.FiniteFamily
import LeanInfoTheory.Shannon.SemanticBridge.Theorems

/-!
# Semantic theorems for finite subfamilies

This file begins the semantic layer for entropy of finite restrictions of a
possibly infinite family of finite-valued random variables.

The monotonicity proof compares only the finite marginal laws on two atoms.
When `s ⊆ t`, `familyMarginal_restrict` identifies the `s`-marginal as a
deterministic image of the `t`-marginal, so `entropy_map_le` applies. In
particular, the proof never forms the finite entropy of the unrestricted
full-family law.

Family mutual-information nonnegativity passes through the existing
restriction-valued random-variable bridge. Its entropy upper bounds and the
conditioning-reduces-entropy theorem are then atom-native consequences of the
family entropy-difference identities, conditional-entropy nonnegativity, and
mutual-information symmetry.

The additional-conditioning theorem formalizes the inequality
`H(A | B ∪ C) ≤ H(A | C)` from Cover--Thomas Theorem 2.6.5. Its equality
characterization is not included. Binary subadditivity then follows from the
family entropy chain rule and conditioning reduction.

N-way subadditivity bounds the entropy of a finite atom by the sum of its
singleton entropies. The corresponding equality characterization by mutual
independence is developed in the separate downstream
`LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence` module.

Conditional entropy of a finite dependent tuple is at most the sum of its
coordinate conditional entropies under the same finite observation. This
random-variable interface permits an arbitrary source type and an observation
alphabet in a separate universe; no independence premise is needed.

Submodularity is stated as nonnegativity of
`H(A) + H(B) - H(A ∪ B) - H(A ∩ B)`, directly in terms of finite-family
entropy.
-/

namespace LeanInfoTheory
namespace Shannon

open scoped BigOperators

universe u v w z

noncomputable section

/-- Entropy is monotone under inclusion of finite family atoms. -/
theorem familyEntropy_mono
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (q : PMF ((i : Var) -> alpha i)) {s t : Finset Var}
    (hst : s ⊆ t) :
    familyEntropy q s ≤ familyEntropy q t := by
  change entropy (familyMarginal q s) ≤ entropy (familyMarginal q t)
  rw [← familyMarginal_restrict q hst]
  exact
    entropy_map_le (familyMarginal q t) (Finset.restrict₂ hst)

/-- Source-family entropy is monotone under inclusion of finite atoms. -/
theorem familyEntropyOf_mono
    {Var : Type u} {alpha : Var -> Type v} {omega : Type w}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (p : PMF omega) (X : (i : Var) -> omega -> alpha i)
    {s t : Finset Var} (hst : s ⊆ t) :
    familyEntropyOf p X s ≤ familyEntropyOf p X t :=
  familyEntropy_mono (familyLawOf p X) hst

/-- Conditional entropy of two finite subfamilies is nonnegative. -/
theorem familyCondEntropy_nonneg
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (q : PMF ((i : Var) -> alpha i)) (a b : Finset Var) :
    0 ≤ familyCondEntropy q a b := by
  unfold familyCondEntropy
  exact sub_nonneg.mpr (familyEntropy_mono q Finset.subset_union_right)

/-- Conditional entropy of two finite source-indexed subfamilies is nonnegative. -/
theorem familyCondEntropyOf_nonneg
    {Var : Type u} {alpha : Var -> Type v} {omega : Type w}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (p : PMF omega) (X : (i : Var) -> omega -> alpha i)
    (a b : Finset Var) :
    0 ≤ familyCondEntropyOf p X a b := by
  simpa only [familyCondEntropyOf] using
    familyCondEntropy_nonneg (familyLawOf p X) a b

/-! ## Conditional mutual information and submodularity -/

/-- Conditional mutual information of finite subfamilies is nonnegative. -/
theorem familyCondMutualInfo_nonneg
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (q : PMF ((i : Var) -> alpha i)) (a b c : Finset Var) :
    0 ≤ familyCondMutualInfo q a b c := by
  rw [familyCondMutualInfo_eq_condMutualInfoOf]
  exact condMutualInfoOf_nonneg q a.restrict b.restrict c.restrict

/--
Conditional mutual information of finite source-indexed subfamilies is
nonnegative.
-/
theorem familyCondMutualInfoOf_nonneg
    {Var : Type u} {alpha : Var -> Type v} {omega : Type w}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (p : PMF omega) (X : (i : Var) -> omega -> alpha i)
    (a b c : Finset Var) :
    0 ≤ familyCondMutualInfoOf p X a b c := by
  exact familyCondMutualInfo_nonneg (familyLawOf p X) a b c

/--
Entropy of finite family atoms is submodular:
`H(A) + H(B) - H(A ∪ B) - H(A ∩ B) ≥ 0`.
-/
theorem familyEntropy_submodular
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (q : PMF ((i : Var) -> alpha i)) (a b : Finset Var) :
    0 ≤ familyEntropy q a + familyEntropy q b -
      familyEntropy q (a ∪ b) - familyEntropy q (a ∩ b) := by
  have ha : a ∪ (a ∩ b) = a := by
    ext i
    simp only [Finset.mem_union, Finset.mem_inter]
    tauto
  have hb : b ∪ (a ∩ b) = b := by
    ext i
    simp only [Finset.mem_union, Finset.mem_inter]
    tauto
  have hab : a ∪ b ∪ (a ∩ b) = a ∪ b := by
    ext i
    simp only [Finset.mem_union, Finset.mem_inter]
    tauto
  have h := familyCondMutualInfo_nonneg q a b (a ∩ b)
  unfold familyCondMutualInfo at h
  rw [ha, hb, hab] at h
  exact h

/-- Entropy of finite source-indexed family atoms is submodular. -/
theorem familyEntropyOf_submodular
    {Var : Type u} {alpha : Var -> Type v} {omega : Type w}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (p : PMF omega) (X : (i : Var) -> omega -> alpha i)
    (a b : Finset Var) :
    0 ≤ familyEntropyOf p X a + familyEntropyOf p X b -
      familyEntropyOf p X (a ∪ b) - familyEntropyOf p X (a ∩ b) := by
  exact familyEntropy_submodular (familyLawOf p X) a b

/-! ## Mutual information and entropy bounds -/

/-- Mutual information of two finite subfamilies is nonnegative. -/
theorem familyMutualInfo_nonneg
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (q : PMF ((i : Var) -> alpha i)) (a b : Finset Var) :
    0 ≤ familyMutualInfo q a b := by
  rw [familyMutualInfo_eq_mutualInfoOf]
  unfold mutualInfoOf
  exact mutualInfo_nonneg _

/-- Mutual information of two finite source-indexed subfamilies is nonnegative. -/
theorem familyMutualInfoOf_nonneg
    {Var : Type u} {alpha : Var -> Type v} {omega : Type w}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (p : PMF omega) (X : (i : Var) -> omega -> alpha i)
    (a b : Finset Var) :
    0 ≤ familyMutualInfoOf p X a b := by
  exact familyMutualInfo_nonneg (familyLawOf p X) a b

/-- Family mutual information is at most the entropy of its left atom. -/
theorem familyMutualInfo_le_entropy_left
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (q : PMF ((i : Var) -> alpha i)) (a b : Finset Var) :
    familyMutualInfo q a b ≤ familyEntropy q a := by
  rw [familyMutualInfo_eq_entropy_sub_condEntropy]
  exact sub_le_self _ (familyCondEntropy_nonneg q a b)

/-- Family mutual information is at most the entropy of its right atom. -/
theorem familyMutualInfo_le_entropy_right
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (q : PMF ((i : Var) -> alpha i)) (a b : Finset Var) :
    familyMutualInfo q a b ≤ familyEntropy q b := by
  calc
    familyMutualInfo q a b = familyMutualInfo q b a :=
      familyMutualInfo_swap q b a
    _ ≤ familyEntropy q b := familyMutualInfo_le_entropy_left q b a

/-- Source-family mutual information is at most the entropy of its left atom. -/
theorem familyMutualInfoOf_le_entropyOf_left
    {Var : Type u} {alpha : Var -> Type v} {omega : Type w}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (p : PMF omega) (X : (i : Var) -> omega -> alpha i)
    (a b : Finset Var) :
    familyMutualInfoOf p X a b ≤ familyEntropyOf p X a := by
  exact familyMutualInfo_le_entropy_left (familyLawOf p X) a b

/-- Source-family mutual information is at most the entropy of its right atom. -/
theorem familyMutualInfoOf_le_entropyOf_right
    {Var : Type u} {alpha : Var -> Type v} {omega : Type w}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (p : PMF omega) (X : (i : Var) -> omega -> alpha i)
    (a b : Finset Var) :
    familyMutualInfoOf p X a b ≤ familyEntropyOf p X b := by
  exact familyMutualInfo_le_entropy_right (familyLawOf p X) a b

/-- Conditioning on a finite family atom cannot increase family entropy. -/
theorem familyCondEntropy_le_entropy
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (q : PMF ((i : Var) -> alpha i)) (a b : Finset Var) :
    familyCondEntropy q a b ≤ familyEntropy q a := by
  have h := familyMutualInfo_nonneg q a b
  rw [familyMutualInfo_eq_entropy_sub_condEntropy] at h
  exact sub_nonneg.mp h

/-- Conditioning cannot increase entropy for finite source-indexed subfamilies. -/
theorem familyCondEntropyOf_le_entropyOf
    {Var : Type u} {alpha : Var -> Type v} {omega : Type w}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (p : PMF omega) (X : (i : Var) -> omega -> alpha i)
    (a b : Finset Var) :
    familyCondEntropyOf p X a b ≤ familyEntropyOf p X a := by
  exact familyCondEntropy_le_entropy (familyLawOf p X) a b

/-! ## Additional conditioning and binary subadditivity -/

/-- Adding a finite conditioning atom cannot increase family conditional entropy. -/
theorem familyCondEntropy_union_le_condEntropy
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (q : PMF ((i : Var) -> alpha i)) (a b c : Finset Var) :
    familyCondEntropy q a (b ∪ c) ≤ familyCondEntropy q a c := by
  have h := familyCondMutualInfo_nonneg q a b c
  rw [familyCondMutualInfo_eq_condEntropy_sub_condEntropy] at h
  exact sub_nonneg.mp h

/--
Adding a finite conditioning atom cannot increase source-family conditional
entropy.
-/
theorem familyCondEntropyOf_union_le_condEntropyOf
    {Var : Type u} {alpha : Var -> Type v} {omega : Type w}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (p : PMF omega) (X : (i : Var) -> omega -> alpha i)
    (a b c : Finset Var) :
    familyCondEntropyOf p X a (b ∪ c) ≤ familyCondEntropyOf p X a c := by
  exact
    familyCondEntropy_union_le_condEntropy (familyLawOf p X) a b c

/-- Entropy of a union of two finite family atoms is subadditive. -/
theorem familyEntropy_union_le_add
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (q : PMF ((i : Var) -> alpha i)) (a b : Finset Var) :
    familyEntropy q (a ∪ b) ≤ familyEntropy q a + familyEntropy q b := by
  calc
    familyEntropy q (a ∪ b) =
        familyEntropy q b + familyCondEntropy q a b :=
      familyEntropy_union_chain_rule_right q a b
    _ ≤ familyEntropy q b + familyEntropy q a :=
      add_le_add_right (familyCondEntropy_le_entropy q a b) _
    _ = familyEntropy q a + familyEntropy q b := add_comm _ _

/-- Source-family entropy of a union of two finite atoms is subadditive. -/
theorem familyEntropyOf_union_le_add
    {Var : Type u} {alpha : Var -> Type v} {omega : Type w}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (p : PMF omega) (X : (i : Var) -> omega -> alpha i)
    (a b : Finset Var) :
    familyEntropyOf p X (a ∪ b) ≤
      familyEntropyOf p X a + familyEntropyOf p X b := by
  exact familyEntropy_union_le_add (familyLawOf p X) a b

/-! ## N-way entropy subadditivity -/

/-- Family entropy is at most the sum of the selected singleton entropies. -/
theorem familyEntropy_le_sum_singletons
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (q : PMF ((i : Var) -> alpha i)) (s : Finset Var) :
    familyEntropy q s ≤ ∑ i ∈ s, familyEntropy q {i} := by
  induction s using Finset.induction_on with
  | empty =>
      simp [familyEntropy_empty]
  | insert i s hi ih =>
      calc
        familyEntropy q (insert i s) =
            familyEntropy q ({i} ∪ s) := by
          rw [Finset.singleton_union]
        _ ≤ familyEntropy q {i} + familyEntropy q s :=
          familyEntropy_union_le_add q {i} s
        _ ≤ familyEntropy q {i} + ∑ j ∈ s, familyEntropy q {j} :=
          add_le_add_right ih _
        _ = ∑ j ∈ insert i s, familyEntropy q {j} := by
          rw [Finset.sum_insert hi]

/--
Source-family entropy is at most the sum of the selected singleton
entropies.
-/
theorem familyEntropyOf_le_sum_singletons
    {Var : Type u} {alpha : Var -> Type v} {omega : Type w}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (p : PMF omega) (X : (i : Var) -> omega -> alpha i)
    (s : Finset Var) :
    familyEntropyOf p X s ≤
      ∑ i ∈ s, familyEntropyOf p X {i} := by
  exact familyEntropy_le_sum_singletons (familyLawOf p X) s

/--
Textbook n-way entropy subadditivity for a list of distinct variable names.
-/
theorem familyEntropy_subadditivity_of_nodup
    {Var : Type u} {alpha : Var -> Type v}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (q : PMF ((i : Var) -> alpha i)) (l : List Var) (hl : l.Nodup) :
    familyEntropy q l.toFinset ≤
      ∑ k : Fin l.length, familyEntropy q {l.get k} := by
  rw [familyEntropy_chain_rule_of_nodup q l hl]
  exact Finset.sum_le_sum fun k _ =>
    familyCondEntropy_le_entropy q {l.get k} (l.take k).toFinset

/--
Source-family textbook n-way entropy subadditivity for distinct variable
names.
-/
theorem familyEntropyOf_subadditivity_of_nodup
    {Var : Type u} {alpha : Var -> Type v} {omega : Type w}
    [DecidableEq Var] [forall i, Fintype (alpha i)]
    (p : PMF omega) (X : (i : Var) -> omega -> alpha i)
    (l : List Var) (hl : l.Nodup) :
    familyEntropyOf p X l.toFinset ≤
      ∑ k : Fin l.length, familyEntropyOf p X {l.get k} := by
  exact familyEntropy_subadditivity_of_nodup (familyLawOf p X) l hl

/-! ## Conditional entropy of a dependent tuple -/

private theorem condEntropyOf_comp_equiv_left
    {Ω : Type u} {α : Type v} {β : Type w} {C : Type z}
    [Fintype α] [Fintype β] [Fintype C]
    (p : PMF Ω) (X : Ω → α) (Y : Ω → C) (e : α ≃ β) :
    condEntropyOf p (fun ω => e (X ω)) Y = condEntropyOf p X Y := by
  rw [condEntropyOf_eq, condEntropyOf_eq]
  have h := entropyOf_comp_equiv p (fun ω => (X ω, Y ω))
    (e.prodCongr (Equiv.refl C))
  exact congrArg (fun a : ℝ => a - entropyOf p Y) h

open Classical in
/-- Conditional entropy of a finite dependent tuple is at most the sum of the
coordinate conditional entropies given the same observation. The source type
is arbitrary, and the finite observation alphabet may inhabit a separate
universe. No independence or conditional factorization is assumed. -/
theorem condEntropyOf_pi_le_sum
    {I : Type u} {A : I → Type v} {Ω : Type w} {C : Type z}
    [Fintype I] [∀ i, Fintype (A i)] [Fintype C]
    (p : PMF Ω) (X : ∀ i, Ω → A i) (Y : Ω → C) :
    condEntropyOf p (fun ω i => X i ω) Y ≤
      ∑ i, condEntropyOf p (X i) Y := by
  classical
  let P (J : Type u) [Fintype J] : Prop :=
    ∀ (B : J → Type v) [∀ j, Fintype (B j)] (Z : ∀ j, Ω → B j),
      condEntropyOf p (fun ω j => Z j ω) Y ≤
        ∑ j, condEntropyOf p (Z j) Y
  have main : P I := by
    refine Fintype.induction_empty_option (P := P) ?_ ?_ ?_ I
    · intro J K _ e ih B _ Z
      let : Fintype J := Fintype.ofEquiv K e.symm
      have h := ih (fun j => B (e j)) (fun j => Z (e j))
      have he : condEntropyOf p (fun ω (j : J) => Z (e j) ω) Y =
          condEntropyOf p (fun ω (k : K) => Z k ω) Y :=
        condEntropyOf_comp_equiv_left p (fun ω k => Z k ω) Y
          (Equiv.piCongrLeft B e).symm
      rw [he] at h
      calc
        condEntropyOf p (fun ω k => Z k ω) Y ≤
            ∑ j, condEntropyOf p (Z (e j)) Y := h
        _ = ∑ k, condEntropyOf p (Z k) Y :=
          e.sum_comp (fun k => condEntropyOf p (Z k) Y)
    · intro B _ Z
      have hinj : Function.Injective
          (Prod.snd : ((i : PEmpty) → B i) × C → C) := by
        intro a b h
        exact Prod.ext (Subsingleton.elim _ _) h
      have h := entropyOf_comp_injective p
        (fun ω => ((fun i => Z i ω), Y ω)) hinj
      change entropyOf p Y = jointEntropyOf p (fun ω i => Z i ω) Y at h
      have hzero : condEntropyOf p (fun ω (i : PEmpty) => Z i ω) Y = 0 := by
        rw [condEntropyOf_eq]
        exact sub_eq_zero.mpr h.symm
      have hle : condEntropyOf p (fun ω (i : PEmpty) => Z i ω) Y ≤
          ∑ i, condEntropyOf p (Z i) Y := by
        rw [hzero]
        simp
      convert! hle
    · intro J _ ih B _ Z
      have step : condEntropyOf p (fun ω (i : Option J) => Z i ω) Y ≤
          ∑ i, condEntropyOf p (Z i) Y := by
        have he := condEntropyOf_comp_equiv_left p (fun ω i => Z i ω) Y
          (Equiv.piOptionEquivProd (β := B))
        calc
          condEntropyOf p (fun ω i => Z i ω) Y =
              condEntropyOf p (fun ω => (Z none ω, fun j => Z (some j) ω)) Y :=
            he.symm
          _ ≤ condEntropyOf p (Z none) Y +
              condEntropyOf p (fun ω j => Z (some j) ω) Y :=
            condEntropyOf_pair_le_add_condEntropyOf p (Z none)
              (fun ω j => Z (some j) ω) Y
          _ ≤ condEntropyOf p (Z none) Y +
              ∑ j, condEntropyOf p (Z (some j)) Y :=
            add_le_add le_rfl (ih (fun j => B (some j)) (fun j => Z (some j)))
          _ = ∑ j, condEntropyOf p (Z j) Y :=
            (Fintype.sum_option (fun j => condEntropyOf p (Z j) Y)).symm
      convert! step
  exact main A X

end

end Shannon
end LeanInfoTheory
