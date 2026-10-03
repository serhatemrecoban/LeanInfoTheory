/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.Coupling

/-!
# Coupling transport consumers

These private consumers use only the focused coupling owner. They obtain both
ordered marginals after heterogeneous coordinate maps and supplied coupling
channels, and identify deterministic lifting with the coordinate pushforward.
Identity, constant, composed and swapped maps exercise the existing PMF algebra.
Pure, singleton and impossible empty inputs require no fallback inhabitant.

The fair-Bool diagonal regression distinguishes the support of a joint law
from the product of its marginal supports. Swapped pure rows have the required
marginals on the diagonal and both wrong marginals at an unused off-diagonal
pair. The public support-restricted lifting theorem still applies, and the
resulting whole joint law is unchanged.

The quantitative consumers lift a maximal input coupling through maximal row
couplings. Exact ENNReal and Real weighted disagreement identities, with explicit
finite-value guards, give the coupling proof of channel contraction on the same
output laws as the total-variation API. Deterministic, equal-input, constant-row
and subsingleton-output cases use those public interfaces.
-/

namespace LeanInfoTheory.Examples.CouplingTransport

universe u v w x y z

open scoped BigOperators ENNReal

private theorem mapped_marginals
    {alpha : Type u} {beta : Type v} {gamma : Type w} {delta : Type x}
    {joint : PMF (alpha × beta)} {p : PMF alpha} {q : PMF beta}
    (h : PMF.IsCoupling joint p q) (f : alpha → gamma) (g : beta → delta) :
    (joint.map (fun ab => (f ab.1, g ab.2))).map Prod.fst = p.map f ∧
      (joint.map (fun ab => (f ab.1, g ab.2))).map Prod.snd = q.map g := by
  have hout := h.map f g
  exact ⟨hout.1, hout.2⟩

private theorem lifted_marginals
    {alpha : Type u} {beta : Type v} {gamma : Type w} {delta : Type x}
    {joint : PMF (alpha × beta)} {p : PMF alpha} {q : PMF beta}
    (h : PMF.IsCoupling joint p q)
    (W : alpha → PMF gamma) (V : beta → PMF delta)
    (K : alpha × beta → PMF (gamma × delta))
    (hK : ∀ ab, ab ∈ joint.support → PMF.IsCoupling (K ab) (W ab.1) (V ab.2)) :
    (joint.bind K).map Prod.fst = p.bind W ∧
      (joint.bind K).map Prod.snd = q.bind V := by
  have hout := h.bind W V K hK
  exact ⟨hout.1, hout.2⟩

private theorem deterministic_lifting
    {alpha : Type u} {beta : Type v} {gamma : Type w} {delta : Type x}
    {joint : PMF (alpha × beta)} {p : PMF alpha} {q : PMF beta}
    (h : PMF.IsCoupling joint p q) (f : alpha → gamma) (g : beta → delta) :
    joint.bind (PMF.deterministicChannel (fun ab => (f ab.1, g ab.2))) =
        joint.map (fun ab => (f ab.1, g ab.2)) ∧
      PMF.IsCoupling
        (joint.bind (PMF.deterministicChannel (fun ab => (f ab.1, g ab.2))))
        (p.map f) (q.map g) := by
  have hK (ab : alpha × beta) (_hab : ab ∈ joint.support) :
      PMF.IsCoupling (PMF.deterministicChannel (fun ab => (f ab.1, g ab.2)) ab)
        (PMF.deterministicChannel f ab.1) (PMF.deterministicChannel g ab.2) := by
    constructor <;> simp only [PMF.deterministicChannel, PMF.pure_map]
  have hout := h.bind (PMF.deterministicChannel f) (PMF.deterministicChannel g)
    (PMF.deterministicChannel (fun ab => (f ab.1, g ab.2))) hK
  simp only [PMF.bind_deterministicChannel] at hout
  exact ⟨PMF.bind_deterministicChannel joint _, hout⟩

private theorem identity_transport {alpha : Type u} {beta : Type v}
    {joint : PMF (alpha × beta)} {p : PMF alpha} {q : PMF beta}
    (h : PMF.IsCoupling joint p q) :
    joint.map (fun ab => (id ab.1, id ab.2)) = joint ∧
      PMF.IsCoupling (joint.map (fun ab => (id ab.1, id ab.2))) p q := by
  refine ⟨PMF.map_id joint, ?_⟩
  simpa only [PMF.map_id] using h.map id id

private theorem composed_transport
    {alpha : Type u} {beta : Type v} {gamma : Type w} {delta : Type x}
    {epsilon : Type y} {zeta : Type z}
    {joint : PMF (alpha × beta)} {p : PMF alpha} {q : PMF beta}
    (h : PMF.IsCoupling joint p q)
    (f : alpha → gamma) (g : beta → delta)
    (f' : gamma → epsilon) (g' : delta → zeta) :
    (joint.map (fun ab => (f ab.1, g ab.2))).map (fun cd => (f' cd.1, g' cd.2)) =
        joint.map (fun ab => (f' (f ab.1), g' (g ab.2))) ∧
      PMF.IsCoupling
        ((joint.map (fun ab => (f ab.1, g ab.2))).map (fun cd => (f' cd.1, g' cd.2)))
        ((p.map f).map f') ((q.map g).map g') := by
  refine ⟨?_, (h.map f g).map f' g'⟩
  rw [PMF.map_comp]
  rfl

private theorem swapped_transport
    {alpha : Type u} {beta : Type v} {gamma : Type w} {delta : Type x}
    {joint : PMF (alpha × beta)} {p : PMF alpha} {q : PMF beta}
    (h : PMF.IsCoupling joint p q) (f : alpha → gamma) (g : beta → delta) :
    (joint.map (fun ab => (f ab.1, g ab.2))).map Prod.swap =
        (joint.map Prod.swap).map (fun ba => (g ba.1, f ba.2)) ∧
      PMF.IsCoupling ((joint.map (fun ab => (f ab.1, g ab.2))).map Prod.swap)
        (q.map g) (p.map f) := by
  refine ⟨?_, (h.map f g).map_swap⟩
  rw [PMF.map_comp, PMF.map_comp]
  rfl

private theorem constant_transport
    {alpha : Type u} {beta : Type v} {gamma : Type w} {delta : Type x}
    {joint : PMF (alpha × beta)} {p : PMF alpha} {q : PMF beta}
    (h : PMF.IsCoupling joint p q) (c : gamma) (d : delta) :
    joint.map (fun _ => (c, d)) = PMF.pure (c, d) ∧
      PMF.IsCoupling (joint.map (fun _ => (c, d))) (PMF.pure c) (PMF.pure d) := by
  refine ⟨PMF.map_const (p := joint) (b := (c, d)), ?_⟩
  simpa only [PMF.map_const, Function.const] using
    h.map (Function.const alpha c) (Function.const beta d)

private def zeroTest (n : Nat) : Bool := decide (n = 0)

private theorem heterogeneous_noninjective_transport
    {joint : PMF (Nat × Bool)} {p : PMF Nat} {q : PMF Bool}
    (h : PMF.IsCoupling joint p q) :
    ¬Function.Injective zeroTest ∧
      PMF.IsCoupling (joint.map (fun ab => (zeroTest ab.1, ())))
        (p.map zeroTest) (PMF.pure ()) := by
  constructor
  · intro hinj
    have heq : (1 : Nat) = 2 := hinj (by decide)
    exact (by decide : (1 : Nat) ≠ 2) heq
  · simpa only [PMF.map_const] using h.map zeroTest (Function.const Bool ())

private theorem pure_transport
    {alpha : Type u} {beta : Type v} {gamma : Type w} {delta : Type x}
    (a : alpha) (b : beta) (f : alpha → gamma) (g : beta → delta) :
    (PMF.pure (a, b)).map (fun ab => (f ab.1, g ab.2)) = PMF.pure (f a, g b) ∧
      PMF.IsCoupling ((PMF.pure (a, b)).map (fun ab => (f ab.1, g ab.2)))
        (PMF.pure (f a)) (PMF.pure (g b)) := by
  have hin : PMF.IsCoupling (PMF.pure (a, b)) (PMF.pure a) (PMF.pure b) := by
    constructor <;> simp only [PMF.pure_map]
  refine ⟨PMF.pure_map _ _, ?_⟩
  simpa only [PMF.pure_map] using hin.map f g

private theorem singleton_lifting {gamma : Type w} {delta : Type x}
    (p : PMF gamma) (q : PMF delta) :
    PMF.IsCoupling
        ((PMF.pure ((), ())).bind (fun _ => PMF.channelJoint p (fun _ => q))) p q ∧
      (PMF.pure ((), ())).bind (fun _ => PMF.channelJoint p (fun _ => q)) =
        PMF.channelJoint p (fun _ => q) := by
  have hin : PMF.IsCoupling (PMF.pure ((), ())) (PMF.pure ()) (PMF.pure ()) := by
    constructor <;> simp only [PMF.pure_map]
  have hout := hin.bind (fun _ => p) (fun _ => q)
    (fun _ => PMF.channelJoint p (fun _ => q))
    (fun _ _ => PMF.isCoupling_channelJoint_const p q)
  refine ⟨?_, PMF.bind_const _ _⟩
  simpa only [PMF.bind_const] using hout

private theorem empty_input_impossible {alpha : Type u} {beta : Type v} [IsEmpty alpha] :
    ¬∃ (joint : PMF (alpha × beta)) (p : PMF alpha) (q : PMF beta),
      PMF.IsCoupling joint p q := by
  rintro ⟨_, p, _, _⟩
  obtain ⟨a, _⟩ := p.support_nonempty
  exact isEmptyElim a

private noncomputable def fairBool : PMF Bool :=
  PMF.ofFintype (fun _ => ENNReal.ofReal (1 / 2 : ℝ)) (by
    rw [Fintype.sum_bool, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
    norm_num)

private theorem fairBool_supported (b : Bool) : b ∈ fairBool.support := by
  norm_num [PMF.mem_support_iff, fairBool, PMF.ofFintype_apply]

private noncomputable def diagonalFair : PMF (Bool × Bool) :=
  fairBool.map (fun b => (b, b))

private theorem diagonalFair_support_iff (ab : Bool × Bool) :
    ab ∈ diagonalFair.support ↔ ab.1 = ab.2 := by
  rw [diagonalFair, PMF.mem_support_map_iff]
  constructor
  · rintro ⟨b, _, rfl⟩
    rfl
  · intro hab
    exact ⟨ab.1, fairBool_supported _, Prod.ext rfl hab⟩

private theorem diagonalFair_support :
    diagonalFair.support = {(false, false), (true, true)} := by
  apply Set.ext
  intro ab
  rw [diagonalFair_support_iff]
  rcases ab with ⟨a, b⟩
  cases a <;> cases b <;> simp

private theorem diagonalFair_marginal_supports (b : Bool) :
    b ∈ (diagonalFair.map Prod.fst).support ∧
      b ∈ (diagonalFair.map Prod.snd).support := by
  have hin := PMF.isCoupling_map_diag fairBool
  change b ∈ ((fairBool.map (fun b => (b, b))).map Prod.fst).support ∧
    b ∈ ((fairBool.map (fun b => (b, b))).map Prod.snd).support
  rw [hin.1, hin.2]
  exact ⟨fairBool_supported b, fairBool_supported b⟩

private noncomputable def swappedPureRow (ab : Bool × Bool) : PMF (Bool × Bool) :=
  PMF.pure (ab.2, ab.1)

private theorem swappedPureRow_supported (ab : Bool × Bool)
    (hab : ab ∈ diagonalFair.support) :
    PMF.IsCoupling (swappedPureRow ab) (PMF.pure ab.1) (PMF.pure ab.2) := by
  have heq := (diagonalFair_support_iff ab).1 hab
  constructor
  · change (PMF.pure (ab.2, ab.1)).map Prod.fst = PMF.pure ab.1
    rw [PMF.pure_map]
    exact congrArg PMF.pure heq.symm
  · change (PMF.pure (ab.2, ab.1)).map Prod.snd = PMF.pure ab.2
    rw [PMF.pure_map]
    exact congrArg PMF.pure heq

private theorem swappedPureRow_wrong_marginals :
    (swappedPureRow (false, true)).map Prod.fst ≠ PMF.pure false ∧
      (swappedPureRow (false, true)).map Prod.snd ≠ PMF.pure true := by
  constructor
  · intro heq
    have hatom := congrArg (fun r : PMF Bool => r true) heq
    norm_num [swappedPureRow, PMF.pure_map, PMF.pure_apply] at hatom
  · intro heq
    have hatom := congrArg (fun r : PMF Bool => r false) heq
    norm_num [swappedPureRow, PMF.pure_map, PMF.pure_apply] at hatom

private theorem unsupported_row_regression :
    (false, true) ∉ diagonalFair.support ∧
      false ∈ (diagonalFair.map Prod.fst).support ∧
      true ∈ (diagonalFair.map Prod.snd).support ∧
      ¬PMF.IsCoupling (swappedPureRow (false, true)) (PMF.pure false) (PMF.pure true) ∧
      (diagonalFair.bind swappedPureRow).map Prod.fst = fairBool ∧
      (diagonalFair.bind swappedPureRow).map Prod.snd = fairBool ∧
      diagonalFair.bind swappedPureRow = diagonalFair := by
  have hin : PMF.IsCoupling diagonalFair fairBool fairBool :=
    PMF.isCoupling_map_diag fairBool
  have hout := hin.bind PMF.pure PMF.pure swappedPureRow swappedPureRow_supported
  simp only [PMF.bind_pure] at hout
  refine ⟨?_, (diagonalFair_marginal_supports false).1,
    (diagonalFair_marginal_supports true).2, ?_, hout.1, hout.2, ?_⟩
  · simp [diagonalFair_support]
  · intro hbad
    exact swappedPureRow_wrong_marginals.1 hbad.1
  · change (fairBool.map (fun b => (b, b))).bind
      (fun ab => PMF.pure (ab.2, ab.1)) = fairBool.map (fun b => (b, b))
    rw [PMF.bind_map]
    rfl

private noncomputable def disagreementENN {alpha : Type u}
    (joint : PMF (alpha × alpha)) : ℝ≥0∞ :=
  joint.toOuterMeasure {xy | xy.1 ≠ xy.2}

private noncomputable def disagreement {alpha : Type u}
    (joint : PMF (alpha × alpha)) : ℝ :=
  (disagreementENN joint).toReal

section Quantitative

variable {alpha : Type u} {gamma : Type w} [Fintype alpha] [Fintype gamma]

private noncomputable def maximalChannelLift (p q : PMF alpha) (W : alpha → PMF gamma) :
    PMF (gamma × gamma) :=
  (PMF.maximalCoupling p q).bind
    (fun ab => PMF.maximalCoupling (W ab.1) (W ab.2))

private theorem maximalChannelLift_isCoupling (p q : PMF alpha) (W : alpha → PMF gamma) :
    PMF.IsCoupling (maximalChannelLift p q W) (p.bind W) (q.bind W) :=
  (PMF.isCoupling_maximalCoupling p q).bind W W
    (fun ab => PMF.maximalCoupling (W ab.1) (W ab.2))
    (fun ab _ => PMF.isCoupling_maximalCoupling (W ab.1) (W ab.2))

private theorem maximalChannelLift_disagreementENN (p q : PMF alpha)
    (W : alpha → PMF gamma) :
    disagreementENN (maximalChannelLift p q W) =
      ∑ ab : alpha × alpha, (PMF.maximalCoupling p q) ab *
        ENNReal.ofReal (PMF.totalVariation (W ab.1) (W ab.2)) := by
  simp only [disagreementENN, maximalChannelLift, PMF.toOuterMeasure_bind_apply,
    PMF.maximalCoupling_toOuterMeasure_ne, tsum_fintype]

private theorem maximalChannelLift_guarded_conversion (p q : PMF alpha)
    (W : alpha → PMF gamma) :
    disagreementENN (maximalChannelLift p q W) ≠ ⊤ ∧
      disagreementENN (PMF.maximalCoupling p q) ≠ ⊤ ∧
      disagreement (maximalChannelLift p q W) =
        ∑ ab : alpha × alpha, ((PMF.maximalCoupling p q) ab).toReal *
          PMF.totalVariation (W ab.1) (W ab.2) := by
  have hterm : ∀ ab ∈ (Finset.univ : Finset (alpha × alpha)),
      (PMF.maximalCoupling p q) ab *
        ENNReal.ofReal (PMF.totalVariation (W ab.1) (W ab.2)) ≠ ⊤ := by
    intro ab _
    exact ENNReal.mul_ne_top ((PMF.maximalCoupling p q).apply_ne_top ab)
      ENNReal.ofReal_ne_top
  refine ⟨?_, ?_, ?_⟩
  · rw [maximalChannelLift_disagreementENN]
    exact ENNReal.sum_ne_top.2 hterm
  · rw [disagreementENN, PMF.maximalCoupling_toOuterMeasure_ne]
    exact ENNReal.ofReal_ne_top
  · rw [disagreement, maximalChannelLift_disagreementENN, ENNReal.toReal_sum hterm]
    apply Finset.sum_congr rfl
    intro ab _
    rw [ENNReal.toReal_mul,
      ENNReal.toReal_ofReal (PMF.totalVariation_nonneg (W ab.1) (W ab.2))]

private theorem maximalChannelLift_disagreement_le (p q : PMF alpha)
    (W : alpha → PMF gamma) :
    disagreement (maximalChannelLift p q W) ≤ disagreement (PMF.maximalCoupling p q) := by
  classical
  rw [(maximalChannelLift_guarded_conversion p q W).2.2, disagreement, disagreementENN,
    PMF.toOuterMeasure_toReal_eq_sum]
  apply Finset.sum_le_sum
  intro ab _
  by_cases hab : ab.1 = ab.2
  · simp [hab, PMF.totalVariation_self]
  · simpa [hab] using
      mul_le_mul_of_nonneg_left (PMF.totalVariation_le_one (W ab.1) (W ab.2))
        ((PMF.maximalCoupling p q).toReal_nonneg ab)

private theorem maximalChannelLift_contraction (p q : PMF alpha) (W : alpha → PMF gamma) :
    (maximalChannelLift p q W).map Prod.fst = p.bind W ∧
      (maximalChannelLift p q W).map Prod.snd = q.bind W ∧
      PMF.totalVariation (p.bind W) (q.bind W) ≤ disagreement (maximalChannelLift p q W) ∧
      disagreement (maximalChannelLift p q W) ≤ disagreement (PMF.maximalCoupling p q) ∧
      disagreement (PMF.maximalCoupling p q) = PMF.totalVariation p q ∧
      PMF.totalVariation (p.bind W) (q.bind W) ≤ PMF.totalVariation p q := by
  have hout := maximalChannelLift_isCoupling p q W
  exact ⟨hout.1, hout.2, hout.totalVariation_le, maximalChannelLift_disagreement_le p q W,
    PMF.maximalCoupling_toOuterMeasure_ne_toReal p q, PMF.totalVariation_bind_le p q W⟩

private theorem deterministic_maximal_lifting (p q : PMF alpha) (f : alpha → gamma) :
    (maximalChannelLift p q (PMF.deterministicChannel f)).map Prod.fst = p.map f ∧
      (maximalChannelLift p q (PMF.deterministicChannel f)).map Prod.snd = q.map f ∧
      PMF.totalVariation (p.map f) (q.map f) ≤
        disagreement (maximalChannelLift p q (PMF.deterministicChannel f)) ∧
      disagreement (maximalChannelLift p q (PMF.deterministicChannel f)) ≤
        PMF.totalVariation p q ∧
      PMF.totalVariation (p.map f) (q.map f) ≤ PMF.totalVariation p q := by
  have h := maximalChannelLift_contraction p q (PMF.deterministicChannel f)
  simp only [PMF.bind_deterministicChannel] at h
  exact ⟨h.1, h.2.1, h.2.2.1, h.2.2.2.1.trans_eq h.2.2.2.2.1,
    PMF.totalVariation_map_le p q f⟩

private theorem equal_input_maximal_lifting (p : PMF alpha) (W : alpha → PMF gamma) :
    disagreement (maximalChannelLift p p W) = 0 ∧
      PMF.totalVariation (p.bind W) (p.bind W) = 0 := by
  have h := maximalChannelLift_contraction p p W
  refine ⟨le_antisymm ?_ ENNReal.toReal_nonneg, PMF.totalVariation_self _⟩
  simpa only [PMF.totalVariation_self] using h.2.2.2.1.trans_eq h.2.2.2.2.1

private theorem constant_row_maximal_lifting (p q : PMF alpha) (r : PMF gamma) :
    disagreement (maximalChannelLift p q (fun _ => r)) = 0 ∧
      PMF.totalVariation (p.bind (fun _ => r)) (q.bind (fun _ => r)) = 0 := by
  constructor
  · rw [(maximalChannelLift_guarded_conversion p q (fun _ => r)).2.2]
    simp only [PMF.totalVariation_self, mul_zero, Finset.sum_const_zero]
  · simp only [PMF.bind_const, PMF.totalVariation_self]

private theorem subsingleton_output_maximal_lifting [Subsingleton gamma]
    (p q : PMF alpha) (W : alpha → PMF gamma) :
    disagreement (maximalChannelLift p q W) = 0 ∧
      PMF.totalVariation (p.bind W) (q.bind W) = 0 := by
  have hempty : {cd : gamma × gamma | cd.1 ≠ cd.2} = ∅ := by
    ext cd
    simp only [Set.mem_ofPred_eq, Set.mem_empty_iff_false, iff_false]
    exact not_not.mpr (Subsingleton.elim _ _)
  have hzero : disagreement (maximalChannelLift p q W) = 0 := by
    simp only [disagreement, disagreementENN, hempty, MeasureTheory.measure_empty,
      ENNReal.toReal_zero]
  refine ⟨hzero, le_antisymm ?_ (PMF.totalVariation_nonneg _ _)⟩
  have h := (maximalChannelLift_isCoupling p q W).totalVariation_le
  change PMF.totalVariation (p.bind W) (q.bind W) ≤ disagreement (maximalChannelLift p q W) at h
  exact h.trans_eq hzero

end Quantitative

end LeanInfoTheory.Examples.CouplingTransport
