/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.TotalVariation
import LeanInfoTheory.Shannon.ChannelCode

/-!
# Random codebook experiments

Sample one complete input word for each message index independently from an
arbitrary word law. For a fixed transmitted index, keep the whole sampled book
and draw the output through the channel at that index's word. The sent word and
output have the original input/channel joint law after averaging over books.
Any competing word is independent of the output in this experiment and has
the original word law, while the output has law `q.bind K`.

The product is over message indices. The word law may have dependent letters,
and distinct message indices may carry equal words. The raw block channel and
output alphabet are arbitrary. This random codebook experiment follows PW24 §18.2,
proof of Theorem 18.5, with the input alphabet specialized to complete words.

A realized book and an acceptance event also give a code at the original length
and message count. Its total decoder returns the least passing message index,
or index zero if none passes. Equal words keep their separate message indices.
This least-index rule follows the precedent in PW24 §18.3, proof of Theorem 18.6;
the supplied event and valid-index fallback replace its test and erasure symbol.

For a memoryless channel, averaging the actual decoder-error event uniformly
over transmitted indices equals the book-weighted mean of the realized code's
released error probability at the original length and budget. The distinction
between fixed-code and random-book averages follows CT91 §§8.5, 8.7. The word
law stays arbitrary, and the identity uses no symmetry between message indices.
-/

namespace LeanInfoTheory.Shannon

noncomputable section

universe u v

/-- Sample independent codewords from `q`, then send the word at the fixed
message index through `K`, retaining the sampled book and output. -/
def codebookOutputLaw {X : Type u} {Y : Type v} [Fintype X] {n M : ℕ}
    (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y)) (m : Fin M) :
    PMF ((Fin M → Fin n → X) × (Fin n → Y)) :=
  PMF.channelJoint (PMF.iid q M) (fun b => K (b m))

/-- Under the whole book/output experiment, the sent word and output have the
joint law induced by `q` and `K`. -/
theorem codebookOutputLaw_map_sentOutput {X : Type u} {Y : Type v} [Fintype X]
    {n M : ℕ} (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (m : Fin M) :
    (codebookOutputLaw q K m).map (fun z => (z.1 m, z.2)) = PMF.channelJoint q K := by
  have heval : (PMF.iid q M).map (fun b => b m) = q :=
    PMF.finiteProduct_map_eval (fun _ : Fin M => q) m
  unfold codebookOutputLaw PMF.channelJoint
  rw [PMF.map_bind]
  simp_rw [PMF.map_comp, Function.comp_def]
  change (PMF.iid q M).bind
    ((fun x => (K x).map (fun y => (x, y))) ∘ (fun b => b m)) = _
  rw [← PMF.bind_map, heval]

private theorem map_competing_endpoints {X : Type u} {Y : Type v} [Fintype X]
    {n M : ℕ} (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (m j : Fin M) :
    (codebookOutputLaw q K m).map (fun z => (z.1 j, z.2)) =
      (PMF.channelExtension ((PMF.iid q M).map (fun b => (b j, b m))) K).map
        (fun s => (s.1, s.2.2)) := by
  simp only [codebookOutputLaw, PMF.channelJoint, PMF.channelExtension,
    PMF.map_bind, PMF.bind_map, PMF.map_comp, Function.comp_def]

/-- Under the whole book/output experiment, the word at another message index and
the output have the independent product of `q` and the output marginal. -/
theorem codebookOutputLaw_map_competingOutput {X : Type u} {Y : Type v} [Fintype X]
    {n M : ℕ} (q : PMF (Fin n → X)) (K : (Fin n → X) → PMF (Fin n → Y))
    (m j : Fin M) (hjm : j ≠ m) :
    (codebookOutputLaw q K m).map (fun z => (z.1 j, z.2)) =
      indepProd q (q.bind K) := by
  have hpair : (PMF.iid q M).map (fun b => (b j, b m)) =
      PMF.channelJoint q (fun _ => q) :=
    PMF.finiteProduct_map_pair (fun _ : Fin M => q) hjm
  rw [map_competing_endpoints, hpair, PMF.channelExtension_map_endpoints]
  rfl

namespace BlockChannelCode

/-- Use the given book as encoder and return the least message index whose
word/output pair lies in `A`, or index zero when no index passes. The decoder
is total on every output and permits equal words at different indices. -/
def ofAcceptanceEvent {X : Type u} {Y : Type v} {n M : ℕ}
    (b : Fin M → Fin n → X) (A : Set ((Fin n → X) × (Fin n → Y)))
    (hM : 1 ≤ M) : BlockChannelCode X Y n M := by
  classical
  exact (b, fun y =>
    let s := Finset.univ.filter (fun i => (b i, y) ∈ A)
    if hs : s.Nonempty then s.min' hs else ⟨0, hM⟩)

/-- If the sent message index passes and every other message index fails,
the acceptance-event decoder returns the sent index. -/
theorem decoder_ofAcceptanceEvent_eq_of_unique {X : Type u} {Y : Type v} {n M : ℕ}
    (b : Fin M → Fin n → X) (A : Set ((Fin n → X) × (Fin n → Y)))
    (hM : 1 ≤ M) (m : Fin M) (y : Fin n → Y) (hm : (b m, y) ∈ A)
    (hother : ∀ j, j ≠ m → (b j, y) ∉ A) :
    (ofAcceptanceEvent b A hM).decoder y = m := by
  classical
  let s := Finset.univ.filter (fun i => (b i, y) ∈ A)
  have hm' : m ∈ s := Finset.mem_filter.mpr ⟨Finset.mem_univ _, hm⟩
  have hs : s.Nonempty := ⟨m, hm'⟩
  change (if h : s.Nonempty then s.min' h else ⟨0, hM⟩) = m
  rw [dif_pos hs]
  by_contra hne
  exact hother _ hne (Finset.mem_filter.mp (s.min'_mem hs)).2

end BlockChannelCode

/-- Uniformly averaging the actual decoder-error event over the transmitted
message index equals the book-weighted mean of the realized code's released
error probability, at the original blocklength and message count. The word law
`q` is arbitrary. The codewords at distinct message indices are sampled independently. -/
theorem mean_codebookOutputLaw_error_eq_mean_errorProbability
    {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n M : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y)
    (A : Set ((Fin n → X) × (Fin n → Y))) (hM : 1 ≤ M) :
    (1 / (M : ℝ)) * (∑ m : Fin M,
      ((codebookOutputLaw q (PMF.memorylessChannel W n) m).toOuterMeasure
        {z | (BlockChannelCode.ofAcceptanceEvent z.1 A hM).decoder z.2 ≠ m}).toReal) =
      ∑ b : Fin M → Fin n → X, (PMF.iid q M b).toReal *
        (BlockChannelCode.ofAcceptanceEvent b A hM).errorProbability W hM := by
  classical
  let P := PMF.iid q M
  let K := PMF.memorylessChannel W n
  let C := fun b => BlockChannelCode.ofAcceptanceEvent b A hM
  have hEvent (m : Fin M) :
      ((codebookOutputLaw q K m).toOuterMeasure
        {z | (C z.1).decoder z.2 ≠ m}).toReal =
      ∑ b : Fin M → Fin n → X, (P b).toReal *
        ∑ y : Fin n → Y, if (C b).decoder y ≠ m then (K (b m) y).toReal else 0 := by
    rw [PMF.toOuterMeasure_toReal_eq_sum, Fintype.sum_prod_type]
    apply Finset.sum_congr rfl
    intro b _
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro y _
    have hatom : codebookOutputLaw q K m (b, y) = P b * K (b m) y :=
      PMF.channelJoint_apply P (fun b => K (b m)) b y
    by_cases h : (C b).decoder y ≠ m
    · rw [Set.indicator_of_mem h, hatom, ENNReal.toReal_mul, if_pos h]
    · rw [Set.indicator_of_notMem h, if_neg h, mul_zero]
  change (1 / (M : ℝ)) * (∑ m : Fin M,
    ((codebookOutputLaw q K m).toOuterMeasure
      {z | (C z.1).decoder z.2 ≠ m}).toReal) =
    ∑ b : Fin M → Fin n → X, (P b).toReal * (C b).errorProbability W hM
  rw [Finset.sum_congr (s₁ := Finset.univ) rfl (fun m _ => hEvent m)]
  rw [Finset.sum_comm, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro b _
  rw [BlockChannelCode.errorProbability_eq_sum]
  change (1 / (M : ℝ)) * (∑ m : Fin M, (P b).toReal *
    ∑ y : Fin n → Y, if (C b).decoder y ≠ m then (K (b m) y).toReal else 0) =
    (P b).toReal * ((1 / (M : ℝ)) * ∑ m : Fin M,
      ∑ y : Fin n → Y, if (C b).decoder y ≠ m then (K (b m) y).toReal else 0)
  rw [← Finset.mul_sum]
  ring

end
end LeanInfoTheory.Shannon
