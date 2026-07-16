/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

import LeanInfoTheory.Shannon.SemanticBridge.Markov
import Mathlib.InformationTheory.KullbackLeibler.ChainRule

/-!
# Data processing for finite stochastic channels

This file bridges the project's PMF-valued finite channels to mathlib Markov
kernels. Channels remain represented publicly by functions
`W : alpha -> PMF beta`; `pmfChannelKernel W` is the measure-theoretic view used
only by the semantic data-processing layer.

The first bridge theorem identifies the induced PMF joint law with mathlib's
composition-product measure. The module then constructs the total finite
posterior channel, proves PMF-level joint reconstruction, and combines these
facts with mathlib's KL chain rule to obtain an exact posterior decomposition.
Its nonnegative remainder yields the finite KL data-processing family for
stochastic channels, deterministic maps, and channel cascades. The same API
then gives one-step contraction toward an invariant reference law and entropy
growth under uniform-preserving and doubly stochastic channels. Kernel and KL
imports remain outside the lightweight finite Shannon API.
-/

namespace LeanInfoTheory
namespace Shannon

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal ProbabilityTheory

noncomputable section

universe u v w

/-! ## PMF channels as Markov kernels -/

/--
The mathlib kernel associated to a countable PMF-valued channel.

This is a semantic view of the existing raw channel function, not a second
public channel representation.
-/
def pmfChannelKernel
    {alpha : Type u} {beta : Type v}
    [MeasurableSpace alpha] [Countable alpha] [MeasurableSingletonClass alpha]
    [MeasurableSpace beta]
    (W : alpha -> PMF beta) : Kernel alpha beta :=
  Kernel.ofFunOfCountable fun a => (W a).toMeasure

instance pmfChannelKernel.instIsMarkovKernel
    {alpha : Type u} {beta : Type v}
    [MeasurableSpace alpha] [Countable alpha] [MeasurableSingletonClass alpha]
    [MeasurableSpace beta]
    (W : alpha -> PMF beta) : IsMarkovKernel (pmfChannelKernel W) :=
  ⟨fun a => by
    change IsProbabilityMeasure (W a).toMeasure
    infer_instance⟩

/-- Evaluating the kernel associated to a PMF channel recovers its PMF measure. -/
@[simp]
theorem pmfChannelKernel_apply
    {alpha : Type u} {beta : Type v}
    [MeasurableSpace alpha] [Countable alpha] [MeasurableSingletonClass alpha]
    [MeasurableSpace beta]
    (W : alpha -> PMF beta) (a : alpha) :
    pmfChannelKernel W a = (W a).toMeasure :=
  rfl

/--
The measure of an induced PMF joint law is the composition-product of the
input measure and the associated Markov kernel.
-/
theorem channelJoint_toMeasure
    {alpha : Type u} {beta : Type v}
    [MeasurableSpace alpha] [Countable alpha] [MeasurableSingletonClass alpha]
    [MeasurableSpace beta] [Countable beta] [MeasurableSingletonClass beta]
    (p : PMF alpha) (W : alpha -> PMF beta) :
    (PMF.channelJoint p W).toMeasure =
      p.toMeasure ⊗ₘ pmfChannelKernel W := by
  rw [Measure.ext_iff_singleton]
  rintro ⟨a, b⟩
  rw [show ({(a, b)} : Set (alpha × beta)) = {a} ×ˢ {b} by ext x; simp]
  rw [Measure.compProd_apply_prod (MeasurableSet.singleton a)
    (MeasurableSet.singleton b)]
  simp [PMF.channelJoint_apply, PMF.toMeasure_apply_singleton]

/-! ## Finite posterior channels -/

/--
The total posterior channel associated to an input law and a finite stochastic
channel.

On an output atom of positive probability this is the usual posterior input
law. On a null output fiber it uses the fallback already documented by
`condFstGivenSndChannel`; reconstruction makes that arbitrary branch
semantically irrelevant.
-/
def channelPosterior
    {alpha : Type u} {beta : Type v} [Fintype alpha]
    (p : PMF alpha) (W : alpha -> PMF beta) : beta -> PMF alpha :=
  condFstGivenSndChannel (PMF.channelJoint p W)

/--
Sampling the posterior from the channel output law reconstructs the induced
joint law in output-input order.
-/
theorem channelPosterior_reconstructs_joint
    {alpha : Type u} {beta : Type v}
    [Fintype alpha]
    (p : PMF alpha) (W : alpha -> PMF beta) :
    PMF.channelJoint (p.bind W) (channelPosterior p W) =
      (PMF.channelJoint p W).map Prod.swap := by
  rw [← PMF.channelJoint_map_snd p W]
  rw [channelPosterior, channelJoint_condFstGivenSndChannel]

/-! ## Finite KL posterior decomposition -/

private theorem channelPosterior_compProd
    {alpha : Type u} {beta : Type v}
    [Fintype alpha]
    [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    [MeasurableSpace beta] [Countable beta] [MeasurableSingletonClass beta]
    (p : PMF alpha) (W : alpha -> PMF beta) :
    (p.bind W).toMeasure ⊗ₘ pmfChannelKernel (channelPosterior p W) =
      ((PMF.channelJoint p W).map Prod.swap).toMeasure := by
  rw [← channelJoint_toMeasure, channelPosterior_reconstructs_joint]

-- The posterior proof needs only equivalence invariance for the coordinate
-- swap. Keep this private until another production consumer justifies a
-- general public relabeling theorem.
private theorem klDiv_map_equiv
    {alpha : Type u} {beta : Type v}
    [Finite alpha] [Finite beta]
    [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    [MeasurableSpace beta] [MeasurableSingletonClass beta]
    (p q : PMF alpha) (e : alpha ≃ beta) :
    InformationTheory.klDiv (p.map e).toMeasure (q.map e).toMeasure =
      InformationTheory.klDiv p.toMeasure q.toMeasure := by
  classical
  letI := Fintype.ofFinite alpha
  letI := Fintype.ofFinite beta
  have hsupport :
      (p.map e).support ⊆ (q.map e).support ↔ p.support ⊆ q.support := by
    simpa only [PMF.support_map] using
      (Set.image_subset_image_iff e.injective (s := p.support) (t := q.support))
  by_cases hpq : p.support ⊆ q.support
  · have hmap : (p.map e).support ⊆ (q.map e).support := hsupport.mpr hpq
    have hac : p.toMeasure ≪ q.toMeasure :=
      (toMeasure_absolutelyContinuous_iff_support_subset p q).2 hpq
    have hacMap : (p.map e).toMeasure ≪ (q.map e).toMeasure :=
      (toMeasure_absolutelyContinuous_iff_support_subset (p.map e) (q.map e)).2 hmap
    have hne : InformationTheory.klDiv p.toMeasure q.toMeasure ≠ ⊤ :=
      (klDiv_pmf_ne_top_iff_support_subset p q).2 hpq
    have hneMap :
        InformationTheory.klDiv (p.map e).toMeasure (q.map e).toMeasure ≠ ⊤ :=
      (klDiv_pmf_ne_top_iff_support_subset (p.map e) (q.map e)).2 hmap
    apply (ENNReal.toReal_eq_toReal_iff' hneMap hne).mp
    rw [toReal_klDiv_pmf_eq_sum (p.map e) (q.map e) hacMap,
      toReal_klDiv_pmf_eq_sum p q hac]
    calc
      (∑ b : beta,
          ((p.map e) b).toReal * Real.log (((p.map e) b / (q.map e) b).toReal)) =
          ∑ a : alpha,
            ((p.map e) (e a)).toReal *
              Real.log (((p.map e) (e a) / (q.map e) (e a)).toReal) :=
        (Equiv.sum_comp e _).symm
      _ = ∑ a : alpha, (p a).toReal * Real.log ((p a / q a).toReal) := by
        apply Finset.sum_congr rfl
        intro a _ha
        rw [PMF.map_apply_equiv p e a, PMF.map_apply_equiv q e a]
  · have hmap : ¬ (p.map e).support ⊆ (q.map e).support :=
      fun h => hpq (hsupport.mp h)
    rw [(klDiv_pmf_eq_top_iff_not_support_subset (p.map e) (q.map e)).2 hmap,
      (klDiv_pmf_eq_top_iff_not_support_subset p q).2 hpq]

/--
Exact KL decomposition for two input laws passed through the same finite
stochastic channel.

The first term is the divergence between the output laws. The remainder is the
divergence between the two posterior kernels over the first output law, stated
with mathlib composition-product measures. No support-inclusion assumption is
needed because the identity is `ENNReal`-valued.
-/
theorem klDiv_channel_eq_add_posterior
    {alpha : Type u} {beta : Type v}
    [Fintype alpha] [Finite beta]
    [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    [MeasurableSpace beta] [MeasurableSingletonClass beta]
    (p q : PMF alpha) (W : alpha -> PMF beta) :
    InformationTheory.klDiv p.toMeasure q.toMeasure =
      InformationTheory.klDiv (p.bind W).toMeasure (q.bind W).toMeasure +
        InformationTheory.klDiv
          ((p.bind W).toMeasure ⊗ₘ pmfChannelKernel (channelPosterior p W))
          ((p.bind W).toMeasure ⊗ₘ pmfChannelKernel (channelPosterior q W)) := by
  classical
  letI := Fintype.ofFinite beta
  have hsame := InformationTheory.klDiv_compProd_left
    p.toMeasure q.toMeasure (pmfChannelKernel W)
  have hjointP := channelJoint_toMeasure p W
  have hjointQ := channelJoint_toMeasure q W
  have hswap := klDiv_map_equiv
    (PMF.channelJoint p W) (PMF.channelJoint q W)
    (Equiv.prodComm alpha beta)
  have hpostP := channelPosterior_compProd p W
  have hpostQ := channelPosterior_compProd q W
  have hchain := InformationTheory.klDiv_compProd_eq_add
    (p.bind W).toMeasure (q.bind W).toMeasure
    (pmfChannelKernel (channelPosterior p W))
    (pmfChannelKernel (channelPosterior q W))
  calc
    InformationTheory.klDiv p.toMeasure q.toMeasure =
        InformationTheory.klDiv
          (p.toMeasure ⊗ₘ pmfChannelKernel W)
          (q.toMeasure ⊗ₘ pmfChannelKernel W) := hsame.symm
    _ = InformationTheory.klDiv
          (PMF.channelJoint p W).toMeasure
          (PMF.channelJoint q W).toMeasure :=
      congrArg₂ InformationTheory.klDiv hjointP.symm hjointQ.symm
    _ = InformationTheory.klDiv
          ((PMF.channelJoint p W).map Prod.swap).toMeasure
          ((PMF.channelJoint q W).map Prod.swap).toMeasure := hswap.symm
    _ = InformationTheory.klDiv
          ((p.bind W).toMeasure ⊗ₘ pmfChannelKernel (channelPosterior p W))
          ((q.bind W).toMeasure ⊗ₘ pmfChannelKernel (channelPosterior q W)) :=
      congrArg₂ InformationTheory.klDiv hpostP.symm hpostQ.symm
    _ = InformationTheory.klDiv (p.bind W).toMeasure (q.bind W).toMeasure +
          InformationTheory.klDiv
            ((p.bind W).toMeasure ⊗ₘ pmfChannelKernel (channelPosterior p W))
            ((p.bind W).toMeasure ⊗ₘ pmfChannelKernel (channelPosterior q W)) := hchain

/-! ## KL data processing -/

/--
Finite relative entropy contracts when two input laws pass through the same
stochastic channel.

This is the primary channel data-processing inequality. It is unconditional
because KL divergence is valued in `ENNReal`.
-/
theorem klDiv_channel_le
    {alpha : Type u} {beta : Type v}
    [Finite alpha] [Finite beta]
    [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    [MeasurableSpace beta] [MeasurableSingletonClass beta]
    (p q : PMF alpha) (W : alpha -> PMF beta) :
    InformationTheory.klDiv (p.bind W).toMeasure (q.bind W).toMeasure <=
      InformationTheory.klDiv p.toMeasure q.toMeasure := by
  classical
  letI := Fintype.ofFinite alpha
  rw [klDiv_channel_eq_add_posterior p q W]
  exact le_add_of_nonneg_right bot_le

/--
Real-valued finite relative entropy contracts through a common stochastic
channel when the first input law is supported by the second.

Only the input support condition is needed; no separate support hypothesis on
the output laws is required.
-/
theorem toReal_klDiv_channel_le
    {alpha : Type u} {beta : Type v}
    [Finite alpha] [Finite beta]
    [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    [MeasurableSpace beta] [MeasurableSingletonClass beta]
    (p q : PMF alpha) (W : alpha -> PMF beta)
    (h : p.support ⊆ q.support) :
    (InformationTheory.klDiv (p.bind W).toMeasure (q.bind W).toMeasure).toReal <=
      (InformationTheory.klDiv p.toMeasure q.toMeasure).toReal :=
  ENNReal.toReal_mono
    ((klDiv_pmf_ne_top_iff_support_subset p q).2 h)
    (klDiv_channel_le p q W)

/-- KL data processing for a deterministic map of a finite alphabet. -/
theorem klDiv_map_le
    {alpha : Type u} {beta : Type v}
    [Finite alpha] [Finite beta]
    [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    [MeasurableSpace beta] [MeasurableSingletonClass beta]
    (p q : PMF alpha) (f : alpha -> beta) :
    InformationTheory.klDiv (p.map f).toMeasure (q.map f).toMeasure <=
      InformationTheory.klDiv p.toMeasure q.toMeasure := by
  simpa only [PMF.bind_deterministicChannel] using
    klDiv_channel_le p q (PMF.deterministicChannel f)

/--
Real-valued KL data processing for a deterministic map, under input support
inclusion.
-/
theorem toReal_klDiv_map_le
    {alpha : Type u} {beta : Type v}
    [Finite alpha] [Finite beta]
    [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    [MeasurableSpace beta] [MeasurableSingletonClass beta]
    (p q : PMF alpha) (f : alpha -> beta)
    (h : p.support ⊆ q.support) :
    (InformationTheory.klDiv (p.map f).toMeasure (q.map f).toMeasure).toReal <=
      (InformationTheory.klDiv p.toMeasure q.toMeasure).toReal := by
  simpa only [PMF.bind_deterministicChannel] using
    toReal_klDiv_channel_le p q (PMF.deterministicChannel f) h

-- A common channel preserves support inclusion. The cascade corollary is the
-- only current production consumer, so this stays private.
private theorem support_bind_mono
    {alpha : Type u} {beta : Type v}
    (p q : PMF alpha) (W : alpha -> PMF beta)
    (h : p.support ⊆ q.support) :
    (p.bind W).support ⊆ (q.bind W).support := by
  intro b hb
  rw [PMF.mem_support_bind_iff] at hb ⊢
  rcases hb with ⟨a, ha, hWa⟩
  exact ⟨a, h ha, hWa⟩

/--
Appending a common channel stage cannot increase the KL divergence between
the two intermediate output laws.
-/
theorem klDiv_channelComp_le
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Finite beta] [Finite gamma]
    [MeasurableSpace beta] [MeasurableSingletonClass beta]
    [MeasurableSpace gamma] [MeasurableSingletonClass gamma]
    (p q : PMF alpha) (W : alpha -> PMF beta) (V : beta -> PMF gamma) :
    InformationTheory.klDiv
        (p.bind (PMF.channelComp W V)).toMeasure
        (q.bind (PMF.channelComp W V)).toMeasure <=
      InformationTheory.klDiv (p.bind W).toMeasure (q.bind W).toMeasure := by
  simpa only [PMF.bind_channelComp] using
    klDiv_channel_le (p.bind W) (q.bind W) V

/-- Textbook-facing alias for `ENNReal`-valued KL contraction along a cascade. -/
theorem klDiv_channel_cascade_le
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Finite beta] [Finite gamma]
    [MeasurableSpace beta] [MeasurableSingletonClass beta]
    [MeasurableSpace gamma] [MeasurableSingletonClass gamma]
    (p q : PMF alpha) (W : alpha -> PMF beta) (V : beta -> PMF gamma) :
    InformationTheory.klDiv
        (p.bind (PMF.channelComp W V)).toMeasure
        (q.bind (PMF.channelComp W V)).toMeasure <=
      InformationTheory.klDiv (p.bind W).toMeasure (q.bind W).toMeasure :=
  klDiv_channelComp_le p q W V

/--
Real-valued KL contraction for a channel cascade. The original input support
condition suffices for the intermediate laws as well.
-/
theorem toReal_klDiv_channelComp_le
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Finite beta] [Finite gamma]
    [MeasurableSpace beta] [MeasurableSingletonClass beta]
    [MeasurableSpace gamma] [MeasurableSingletonClass gamma]
    (p q : PMF alpha) (W : alpha -> PMF beta) (V : beta -> PMF gamma)
    (h : p.support ⊆ q.support) :
    (InformationTheory.klDiv
        (p.bind (PMF.channelComp W V)).toMeasure
        (q.bind (PMF.channelComp W V)).toMeasure).toReal <=
      (InformationTheory.klDiv
        (p.bind W).toMeasure (q.bind W).toMeasure).toReal := by
  simpa only [PMF.bind_channelComp] using
    toReal_klDiv_channel_le (p.bind W) (q.bind W) V
      (support_bind_mono p q W h)

/-- Textbook-facing alias for real-valued KL contraction along a cascade. -/
theorem toReal_klDiv_channel_cascade_le
    {alpha : Type u} {beta : Type v} {gamma : Type w}
    [Finite beta] [Finite gamma]
    [MeasurableSpace beta] [MeasurableSingletonClass beta]
    [MeasurableSpace gamma] [MeasurableSingletonClass gamma]
    (p q : PMF alpha) (W : alpha -> PMF beta) (V : beta -> PMF gamma)
    (h : p.support ⊆ q.support) :
    (InformationTheory.klDiv
        (p.bind (PMF.channelComp W V)).toMeasure
        (q.bind (PMF.channelComp W V)).toMeasure).toReal <=
      (InformationTheory.klDiv
        (p.bind W).toMeasure (q.bind W).toMeasure).toReal :=
  toReal_klDiv_channelComp_le p q W V h

/-! ## Invariant references and entropy growth -/

/--
KL divergence to an invariant reference law cannot increase after one step of
a finite stochastic channel.
-/
theorem klDiv_channel_invariant_le
    {alpha : Type u}
    [Finite alpha]
    [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    (p r : PMF alpha) (W : alpha -> PMF alpha)
    (hr : r.bind W = r) :
    InformationTheory.klDiv (p.bind W).toMeasure r.toMeasure <=
      InformationTheory.klDiv p.toMeasure r.toMeasure := by
  simpa only [hr] using klDiv_channel_le p r W

/--
Real-valued KL divergence to an invariant reference law contracts when the
input law is supported by that reference.
-/
theorem toReal_klDiv_channel_invariant_le
    {alpha : Type u}
    [Finite alpha]
    [MeasurableSpace alpha] [MeasurableSingletonClass alpha]
    (p r : PMF alpha) (W : alpha -> PMF alpha)
    (hr : r.bind W = r) (h : p.support ⊆ r.support) :
    (InformationTheory.klDiv (p.bind W).toMeasure r.toMeasure).toReal <=
      (InformationTheory.klDiv p.toMeasure r.toMeasure).toReal := by
  simpa only [hr] using toReal_klDiv_channel_le p r W h

/--
A finite channel that preserves the uniform law cannot decrease Shannon
entropy.

The discrete measurable structure used by the KL proof remains local, so the
statement has only the natural finite nonempty alphabet assumptions.
-/
theorem entropy_le_entropy_bind_of_uniform_invariant
    {alpha : Type u} [Fintype alpha] [Nonempty alpha]
    (p : PMF alpha) (W : alpha -> PMF alpha)
    (hW : (PMF.uniformOfFintype alpha).bind W =
      PMF.uniformOfFintype alpha) :
    entropy p <= entropy (p.bind W) := by
  letI : MeasurableSpace alpha := ⊤
  haveI : MeasurableSingletonClass alpha := ⟨fun _ => trivial⟩
  have hkl := toReal_klDiv_channel_invariant_le
    p (PMF.uniformOfFintype alpha) W hW (by simp)
  rw [toReal_klDiv_pmf_uniformOfFintype,
    toReal_klDiv_pmf_uniformOfFintype] at hkl
  linarith

/--
A finite doubly stochastic channel cannot decrease Shannon entropy.

Each `W a` is already a probability law, hence supplies the row-stochastic
condition. The displayed hypothesis is the remaining column-sum condition.
No transition-matrix representation is introduced.
-/
theorem entropy_le_entropy_bind_of_doublyStochastic
    {alpha : Type u} [Fintype alpha] [Nonempty alpha]
    (p : PMF alpha) (W : alpha -> PMF alpha)
    (hW : ∀ b, ∑ a, W a b = 1) :
    entropy p <= entropy (p.bind W) := by
  apply entropy_le_entropy_bind_of_uniform_invariant p W
  ext b
  rw [PMF.bind_apply, tsum_fintype]
  simp only [PMF.uniformOfFintype_apply, ← Finset.mul_sum, hW b, mul_one]

end

end Shannon
end LeanInfoTheory
