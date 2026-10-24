/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.Topology
import LeanInfoTheory.Shannon.EntropyBounds
import LeanInfoTheory.Shannon.SemanticBridge.Markov

/-!
# Attained finite-channel information capacity

Information capacity is the supremum, in nats, of the existing mutual-information
objective over all input PMFs. A nonempty finite input alphabet makes that domain
nonempty. Compactness of finite PMFs and continuity of the objective supply an
actual maximizing input, including laws with zero masses.

Simultaneous input/output equivalences preserve capacity. Stochastic or
deterministic processing of the output cannot increase it.

No separate nonempty-output assumption is needed: any channel row supplies it.
These results concern information capacity; they assert no operational coding
theorem. See CT91 §8.1–8.3 and PW24 Chapter 5 in `docs/references.md`.
-/

namespace LeanInfoTheory.Shannon

universe u v w x

/-- Finite-channel information capacity in nats, over all input laws on a nonempty
alphabet. The explicit nonempty-input binder excludes an empty supremum convention. -/
noncomputable def channelCapacity {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B] (W : A → PMF B) : ℝ :=
  sSup (Set.range (fun p : PMF A => mutualInfo (PMF.channelJoint p W)))

variable {A : Type u} {B : Type v} [Fintype A] [Nonempty A] [Fintype B]

private theorem objective_range_nonempty (W : A → PMF B) :
    (Set.range (fun p : PMF A => mutualInfo (PMF.channelJoint p W))).Nonempty := by
  exact ⟨_, ⟨PMF.pure (Classical.choice (inferInstance : Nonempty A)), rfl⟩⟩

private theorem objective_range_bddAbove (W : A → PMF B) :
    BddAbove (Set.range (fun p : PMF A => mutualInfo (PMF.channelJoint p W))) := by
  refine ⟨Real.log (Fintype.card A), ?_⟩
  rintro _ ⟨p, rfl⟩
  exact (mutualInfo_le_entropy_fstMarginal (PMF.channelJoint p W)).trans
    (entropy_le_log_card (fstMarginal (PMF.channelJoint p W)))

/-- Every input law's mutual information is bounded by information capacity. -/
theorem mutualInfo_channelJoint_le_channelCapacity (p : PMF A) (W : A → PMF B) :
    mutualInfo (PMF.channelJoint p W) ≤ channelCapacity W := by
  exact le_csSup (objective_range_bddAbove W) ⟨p, rfl⟩

/-- A real number bounds capacity exactly when it bounds every input objective. -/
theorem channelCapacity_le_iff (W : A → PMF B) (r : ℝ) :
    channelCapacity W ≤ r ↔ ∀ p : PMF A, mutualInfo (PMF.channelJoint p W) ≤ r := by
  unfold channelCapacity
  exact (csSup_le_iff (objective_range_bddAbove W)
    (objective_range_nonempty W)).trans Set.forall_mem_range

/-- A finite channel has an input PMF attaining its information capacity.
The proof uses continuity on the nonempty compact domain of finite input PMFs. -/
theorem exists_mutualInfo_channelJoint_eq_channelCapacity (W : A → PMF B) :
    ∃ p : PMF A, mutualInfo (PMF.channelJoint p W) = channelCapacity W := by
  obtain ⟨p, _, hp⟩ := isCompact_univ.exists_isMaxOn
    (s := Set.univ)
    ⟨PMF.pure (Classical.choice (inferInstance : Nonempty A)), Set.mem_univ _⟩
    (continuous_mutualInfo_channelJoint W).continuousOn
  refine ⟨p, le_antisymm (mutualInfo_channelJoint_le_channelCapacity p W) ?_⟩
  exact (channelCapacity_le_iff W _).2 (fun q => hp (Set.mem_univ q))

/-- Finite-channel information capacity is nonnegative. -/
theorem channelCapacity_nonneg (W : A → PMF B) : 0 ≤ channelCapacity W := by
  obtain ⟨p, hp⟩ := exists_mutualInfo_channelJoint_eq_channelCapacity W
  rw [← hp]
  exact mutualInfo_nonneg _

/-- Capacity in nats is at most the logarithm of the input alphabet size. -/
theorem channelCapacity_le_log_card_input (W : A → PMF B) :
    channelCapacity W ≤ Real.log (Fintype.card A) := by
  apply (channelCapacity_le_iff W _).2
  intro p
  exact (mutualInfo_le_entropy_fstMarginal (PMF.channelJoint p W)).trans
    (entropy_le_log_card (fstMarginal (PMF.channelJoint p W)))

/-- Capacity in nats is at most the logarithm of the output alphabet size.
Output nonemptiness follows internally from a channel row. -/
theorem channelCapacity_le_log_card_output (W : A → PMF B) :
    channelCapacity W ≤ Real.log (Fintype.card B) := by
  obtain ⟨b, _⟩ := (W (Classical.choice (inferInstance : Nonempty A))).support_nonempty
  let : Nonempty B := ⟨b⟩
  apply (channelCapacity_le_iff W _).2
  intro p
  exact (mutualInfo_le_entropy_sndMarginal (PMF.channelJoint p W)).trans
    (entropy_le_log_card (sndMarginal (PMF.channelJoint p W)))

omit [Fintype A] [Nonempty A] [Fintype B] in
private theorem channelJoint_map_equiv {A' : Type w} {B' : Type x}
    (p : PMF A) (W : A → PMF B) (e : A ≃ A') (f : B ≃ B') :
    PMF.channelJoint (p.map e) (fun a' => (W (e.symm a')).map f) =
      (PMF.channelJoint p W).map (fun ab => (e ab.1, f ab.2)) := by
  unfold PMF.channelJoint
  rw [PMF.bind_map, PMF.map_bind]
  apply congrArg (PMF.bind p)
  funext a
  simp only [Function.comp_def, Equiv.symm_apply_apply, PMF.map_comp]

omit [Nonempty A] in
private theorem mutualInfo_map_equiv {A' : Type w} {B' : Type x}
    [Fintype A'] [Fintype B'] (q : PMF (A × B)) (e : A ≃ A') (f : B ≃ B') :
    mutualInfo (q.map (fun ab => (e ab.1, f ab.2))) = mutualInfo q := by
  apply le_antisymm (mutualInfo_map_prod_le q e f)
  have h := mutualInfo_map_prod_le
    (q.map (fun ab => (e ab.1, f ab.2))) e.symm f.symm
  simp only [PMF.map_comp, Function.comp_def, Equiv.symm_apply_apply, Prod.eta] at h
  change mutualInfo (q.map id) ≤ mutualInfo (q.map (fun ab => (e ab.1, f ab.2))) at h
  simpa only [PMF.map_id] using h

omit [Nonempty A] in
private theorem channelJoint_objective_map_equiv {A' : Type w} {B' : Type x}
    [Fintype A'] [Fintype B']
    (p : PMF A) (W : A → PMF B) (e : A ≃ A') (f : B ≃ B') :
    mutualInfo (PMF.channelJoint (p.map e) (fun a' => (W (e.symm a')).map f)) =
      mutualInfo (PMF.channelJoint p W) := by
  rw [channelJoint_map_equiv]
  exact mutualInfo_map_equiv _ e f

/-- Simultaneously relabeling input and output alphabets preserves capacity.
The input law is pushed forward by `e`, so channel rows use `e.symm`.
Nonemptiness of the renamed input is transported locally from the original input. -/
theorem channelCapacity_congr_equiv {A' : Type w} {B' : Type x}
    [Fintype A'] [Fintype B'] (W : A → PMF B) (e : A ≃ A') (f : B ≃ B') :
    let : Nonempty A' := e.symm.nonempty
    channelCapacity (fun a' => (W (e.symm a')).map f) = channelCapacity W := by
  let : Nonempty A' := e.symm.nonempty
  apply le_antisymm
  · apply (channelCapacity_le_iff _ _).2
    intro q
    have h := channelJoint_objective_map_equiv (q.map e.symm) W e f
    simp only [PMF.map_comp, Function.comp_def, Equiv.apply_symm_apply] at h
    change mutualInfo (PMF.channelJoint (q.map id) (fun a' => (W (e.symm a')).map f)) =
      mutualInfo (PMF.channelJoint (q.map e.symm) W) at h
    rw [PMF.map_id] at h
    exact h.le.trans (mutualInfo_channelJoint_le_channelCapacity _ W)
  · apply (channelCapacity_le_iff W _).2
    intro p
    rw [← channelJoint_objective_map_equiv p W e f]
    exact mutualInfo_channelJoint_le_channelCapacity _ _

/-- Stochastic processing of a finite channel's output cannot increase capacity. -/
theorem channelCapacity_channelComp_le {D : Type w} [Fintype D]
    (W : A → PMF B) (V : B → PMF D) :
    channelCapacity (PMF.channelComp W V) ≤ channelCapacity W := by
  apply (channelCapacity_le_iff _ _).2
  intro p
  exact (mutualInfo_channelComp_le p W V).trans
    (mutualInfo_channelJoint_le_channelCapacity p W)

/-- Mapping a finite channel's output cannot increase capacity, even when the
map identifies distinct outputs. -/
theorem channelCapacity_map_output_le {D : Type w} [Fintype D]
    (W : A → PMF B) (g : B → D) :
    channelCapacity (fun a => (W a).map g) ≤ channelCapacity W := by
  apply (channelCapacity_le_iff _ _).2
  intro p
  exact (mutualInfo_channel_map_output_le p W g).trans
    (mutualInfo_channelJoint_le_channelCapacity p W)

end LeanInfoTheory.Shannon
