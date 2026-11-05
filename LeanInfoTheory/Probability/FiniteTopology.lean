/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.FiniteChannel
import Mathlib.Analysis.Convex.StdSimplex
import Mathlib.Topology.Homeomorph.Lemmas

/-!
# PMF topology and the real standard simplex

The topology on `PMF α` is the product/subtype topology of its `ENNReal` atom
masses. The named instance below forwards that topology because instance search
does not unfold the upstream `PMF` definition automatically.

Real atom evaluation is continuous, including at zero mass, and convergence
is equivalent to real-coordinate convergence for arbitrary alphabets and filters.
For finite alphabets the real coordinates give a homeomorphism with mathlib's
`stdSimplex ℝ α`, hence compactness. Empty alphabets require no exception to these
statements; compactness does not assert that a probability law exists.

Fixed pushforward and channel-output maps are continuous for finite source
alphabets and arbitrary output alphabets. Fixed-channel joint laws are continuous
without any alphabet finiteness hypothesis, by their coordinate-product formula.
-/

namespace PMF

noncomputable section

universe u v

open Filter Topology
open scoped BigOperators

variable {α : Type u}

/-- The existing product/subtype topology on PMF atom masses. -/
instance instTopologicalSpace : TopologicalSpace (PMF α) :=
  inferInstanceAs (TopologicalSpace {f : α → ENNReal // HasSum f 1})

/-- Evaluation of a real atom mass is continuous, including at zero mass. -/
theorem continuous_apply_toReal (a : α) :
    Continuous (fun p : PMF α => (p a).toReal) := by
  refine continuous_iff_continuousAt.mpr fun p => ?_
  have heval : Continuous (fun q : PMF α => q a) :=
    (continuous_apply a).comp continuous_subtype_val
  exact (ENNReal.continuousAt_toReal (p.apply_ne_top a)).comp
    (f := fun q : PMF α => q a) heval.continuousAt

/-- Finite PMFs are homeomorphic to the real standard simplex by their atom masses. -/
def homeomorphStdSimplex [Fintype α] : PMF α ≃ₜ stdSimplex ℝ α where
  toFun p := ⟨fun a => (p a).toReal, fun a => p.toReal_nonneg a, p.sum_toReal⟩
  invFun x := PMF.ofFintype (fun a => ENNReal.ofReal (x a)) (by
    calc
      (∑ a, ENNReal.ofReal (x a)) = ENNReal.ofReal (∑ a, x a) :=
        (ENNReal.ofReal_sum_of_nonneg (s := Finset.univ) (f := fun a => x a)
          (fun a _ => x.2.1 a)).symm
      _ = 1 := by
        have hx : (∑ a, x a) = 1 := x.2.2
        rw [hx, ENNReal.ofReal_one])
  left_inv p := by
    apply PMF.ext
    intro a
    exact ENNReal.ofReal_toReal (p.apply_ne_top a)
  right_inv x := by
    apply Subtype.ext
    funext a
    exact ENNReal.toReal_ofReal (x.2.1 a)
  continuous_toFun := (continuous_pi continuous_apply_toReal).subtype_mk _
  continuous_invFun := (continuous_pi fun a =>
    ENNReal.continuous_ofReal.comp ((continuous_apply a).comp continuous_subtype_val)).subtype_mk _

/-- A PMF's simplex coordinate is its real atom mass. -/
theorem homeomorphStdSimplex_apply [Fintype α] (p : PMF α) (a : α) :
    homeomorphStdSimplex p a = (p a).toReal := rfl

/-- The inverse simplex map converts each nonnegative coordinate to `ENNReal`. -/
theorem homeomorphStdSimplex_symm_apply [Fintype α] (x : stdSimplex ℝ α) (a : α) :
    (homeomorphStdSimplex.symm x) a = ENNReal.ofReal (x a) := rfl

/-- PMFs converge exactly when each real atom mass converges, for any filter. -/
theorem tendsto_iff_forall_toReal_tendsto {ι : Type v} {l : Filter ι}
    {f : ι → PMF α} {p : PMF α} :
    Tendsto f l (𝓝 p) ↔ ∀ a, Tendsto (fun i => (f i a).toReal) l (𝓝 ((p a).toReal)) := by
  refine (tendsto_subtype_rng (f := f) (x := p)).trans (tendsto_pi_nhds.trans ?_)
  exact forall_congr' fun a =>
    (ENNReal.tendsto_toReal_iff (fun i => (f i).apply_ne_top a) (p.apply_ne_top a)).symm

/-- PMFs on a finite alphabet form a compact space, also when the alphabet is empty. -/
instance instCompactSpace [Finite α] : CompactSpace (PMF α) := by
  let := Fintype.ofFinite α
  exact (homeomorphStdSimplex (α := α)).symm.compactSpace

/-- A fixed channel's output law depends continuously on its finite-source input law. -/
theorem continuous_bind {β : Type v} [Finite α] (W : α → PMF β) :
    Continuous (fun p : PMF α => p.bind W) := by
  classical
  let := Fintype.ofFinite α
  refine continuous_iff_continuousAt.mpr fun p => ?_
  apply tendsto_iff_forall_toReal_tendsto.mpr
  intro b
  simp only [bind_toReal_apply]
  exact (continuous_finsetSum _ fun a _ =>
    (continuous_apply_toReal a).mul continuous_const).continuousAt

/-- Pushforward by a fixed map is continuous for finite source and arbitrary output. -/
theorem continuous_map {β : Type v} [Finite α] (g : α → β) :
    Continuous (fun p : PMF α => p.map g) := by
  simpa only [PMF.map] using continuous_bind (PMF.pure ∘ g)

/-- A fixed channel's joint law depends continuously on its input, for arbitrary alphabets. -/
theorem continuous_channelJoint {β : Type v} (W : α → PMF β) :
    Continuous (fun p : PMF α => channelJoint p W) := by
  refine continuous_iff_continuousAt.mpr fun p => ?_
  apply tendsto_iff_forall_toReal_tendsto.mpr
  rintro ⟨a, b⟩
  simp only [channelJoint_apply, ENNReal.toReal_mul]
  exact ((continuous_apply_toReal a).mul continuous_const).continuousAt

end

end PMF
