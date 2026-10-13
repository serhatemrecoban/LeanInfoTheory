/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.TotalVariation
import LeanInfoTheory.Probability.FiniteTopology

/-!
# Total variation and finite PMF convergence

On one fixed finite alphabet, the existing half-L1 total variation is continuous
in the PMF product/subtype topology. Convergence to a PMF is equivalent to total
variation tending to zero. Together with the real-coordinate convergence API,
this connects all three notions without introducing a metric instance.
-/

namespace PMF

universe u v

open Filter Topology
open scoped BigOperators

variable {α : Type u} [Fintype α]

/-- Total variation is jointly continuous on a fixed finite alphabet. -/
theorem continuous_totalVariation :
    Continuous (fun pq : PMF α × PMF α => totalVariation pq.1 pq.2) := by
  classical
  unfold totalVariation
  exact continuous_const.mul (continuous_finsetSum _ fun a _ =>
    (((continuous_apply_toReal a).comp continuous_fst).sub
      ((continuous_apply_toReal a).comp continuous_snd)).abs)

/-- On a fixed finite alphabet, PMF convergence is equivalent to TV tending to zero. -/
theorem tendsto_iff_totalVariation_tendsto_zero {ι : Type v} {l : Filter ι}
    {f : ι → PMF α} {p : PMF α} :
    Tendsto f l (𝓝 p) ↔ Tendsto (fun i => totalVariation (f i) p) l (𝓝 0) := by
  constructor
  · intro h
    have hc : Continuous (fun q : PMF α => totalVariation q p) :=
      continuous_totalVariation.comp (continuous_id.prodMk continuous_const)
    simpa only [totalVariation_self, Function.comp_def] using hc.continuousAt.tendsto.comp h
  · intro h
    apply tendsto_iff_forall_toReal_tendsto.mpr
    intro a
    rw [← tendsto_sub_nhds_zero_iff, tendsto_zero_iff_abs_tendsto_zero]
    exact squeeze_zero (fun _ => abs_nonneg _) (fun i => by
      simpa only [PMF.toOuterMeasure_apply_singleton, Function.comp_def] using
        abs_toOuterMeasure_sub_le_totalVariation (f i) p {a}) h

end PMF
