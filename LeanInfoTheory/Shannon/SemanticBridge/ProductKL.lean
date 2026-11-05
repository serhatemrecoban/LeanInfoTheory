/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import LeanInfoTheory.Probability.Iid
import LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL

/-!
# KL divergence of finite products

KL divergence adds over finite dependent products, including singular laws and
infinite values. The iid specialization is blocklength times the base divergence.
Real-valued identities retain explicit support-inclusion guards.

The proof uses the existing joint KL chain rule with constant channels, followed
by finite-index induction. Equivalence transport and splitting remain private.
-/

open scoped BigOperators ENNReal

namespace LeanInfoTheory.Shannon

universe u v w

private theorem klDiv_map_equiv
    {α : Type v} {β : Type w} [Finite α] [Finite β]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    [MeasurableSpace β] [MeasurableSingletonClass β]
    (p q : PMF α) (e : α ≃ β) :
    InformationTheory.klDiv (p.map e).toMeasure (q.map e).toMeasure =
      InformationTheory.klDiv p.toMeasure q.toMeasure := by
  apply le_antisymm (klDiv_map_le p q e)
  simpa only [PMF.map_comp, Equiv.symm_comp_self, PMF.map_id] using
    (klDiv_map_le (p.map e) (q.map e) e.symm)

private theorem klDiv_channelJoint_const
    {α : Type v} {β : Type w} [Finite α] [Finite β]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    [MeasurableSpace β] [MeasurableSingletonClass β]
    (p q : PMF α) (r s : PMF β) :
    InformationTheory.klDiv (PMF.channelJoint p (fun _ => r)).toMeasure
        (PMF.channelJoint q (fun _ => s)).toMeasure =
      InformationTheory.klDiv p.toMeasure q.toMeasure +
        InformationTheory.klDiv r.toMeasure s.toMeasure := by
  classical
  let := Fintype.ofFinite α
  rw [klDiv_channelJoint_eq_add_conditionalKlDiv, conditionalKlDiv_eq_sum,
    ← Finset.sum_mul]
  rw [show ∑ a, p a = 1 from (tsum_fintype _).symm.trans p.tsum_coe, one_mul]

private theorem finiteProduct_map_option
    {I : Type u} {A : Option I → Type v}
    [Fintype I] [∀ i, Fintype (A i)] (p : ∀ i, PMF (A i)) :
    (PMF.finiteProduct p).map Equiv.piOptionEquivProd =
      PMF.channelJoint (p none)
        (fun _ => PMF.finiteProduct (fun i => p (some i))) := by
  classical
  let E := Equiv.piOptionEquivProd (β := A)
  apply PMF.ext
  intro z
  obtain ⟨x, rfl⟩ := E.surjective z
  rw [PMF.map_apply_equiv, PMF.finiteProduct_apply]
  change (∏ i, p i (x i)) =
    PMF.channelJoint (p none) (fun _ => PMF.finiteProduct (fun i => p (some i)))
      (x none, fun i => x (some i))
  rw [PMF.channelJoint_apply, PMF.finiteProduct_apply]
  exact Fintype.prod_option (fun i => p i (x i))

open Classical in
/-- KL divergence adds over finite dependent products, without support
restrictions and including infinite coordinate divergences. -/
theorem klDiv_finiteProduct
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    [∀ i, MeasurableSpace (A i)] [∀ i, MeasurableSingletonClass (A i)]
    (p q : ∀ i, PMF (A i)) :
    InformationTheory.klDiv (PMF.finiteProduct p).toMeasure
        (PMF.finiteProduct q).toMeasure =
      ∑ i, InformationTheory.klDiv (p i).toMeasure (q i).toMeasure := by
  classical
  let P (J : Type u) [Fintype J] : Prop :=
    ∀ (B : J → Type v) [∀ j, Fintype (B j)]
      [∀ j, MeasurableSpace (B j)] [∀ j, MeasurableSingletonClass (B j)]
      (r s : ∀ j, PMF (B j)),
      InformationTheory.klDiv (PMF.finiteProduct r).toMeasure
          (PMF.finiteProduct s).toMeasure =
        ∑ j, InformationTheory.klDiv (r j).toMeasure (s j).toMeasure
  have main : P I := by
    refine Fintype.induction_empty_option (P := P) ?_ ?_ ?_ I
    · intro J K _ e ih B _ _ _ r s
      let : Fintype J := Fintype.ofEquiv K e.symm
      have ht := klDiv_map_equiv (PMF.finiteProduct r) (PMF.finiteProduct s)
        (Equiv.piCongrLeft B e).symm
      rw [PMF.finiteProduct_map_reindex, PMF.finiteProduct_map_reindex] at ht
      rw [← ht, ih (fun j => B (e j))]
      exact e.sum_comp (fun j => InformationTheory.klDiv (r j).toMeasure (s j).toMeasure)
    · intro B _ _ _ r s
      rw [PMF.finiteProduct_of_isEmpty, PMF.finiteProduct_of_isEmpty,
        InformationTheory.klDiv_self]
      simp
    · intro J _ ih B _ _ _ r s
      have ht := klDiv_map_equiv (PMF.finiteProduct r) (PMF.finiteProduct s)
        Equiv.piOptionEquivProd
      rw [finiteProduct_map_option, finiteProduct_map_option,
        klDiv_channelJoint_const, ih (fun j => B (some j))] at ht
      rw [← ht, Fintype.sum_option]
  exact main A p q

open Classical in
/-- Real KL divergence adds over finite products when each numerator support is
contained in the corresponding reference support. Full support is not required. -/
theorem toReal_klDiv_finiteProduct
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    [∀ i, MeasurableSpace (A i)] [∀ i, MeasurableSingletonClass (A i)]
    (p q : ∀ i, PMF (A i)) (h : ∀ i, (p i).support ⊆ (q i).support) :
    (InformationTheory.klDiv (PMF.finiteProduct p).toMeasure
        (PMF.finiteProduct q).toMeasure).toReal =
      ∑ i, (InformationTheory.klDiv (p i).toMeasure (q i).toMeasure).toReal := by
  classical
  have hcoordinate (i : I) :
      InformationTheory.klDiv (p i).toMeasure (q i).toMeasure ≠ ⊤ :=
    (klDiv_pmf_ne_top_iff_support_subset (p i) (q i)).2 (h i)
  have hsupport : (PMF.finiteProduct p).support ⊆ (PMF.finiteProduct q).support := by
    intro x hx
    apply (PMF.mem_support_finiteProduct_iff q x).2
    intro i
    exact h i ((PMF.mem_support_finiteProduct_iff p x).1 hx i)
  -- Both the product and every coordinate have finite KL before conversion.
  have _hproduct :
      InformationTheory.klDiv (PMF.finiteProduct p).toMeasure
        (PMF.finiteProduct q).toMeasure ≠ ⊤ :=
    (klDiv_pmf_ne_top_iff_support_subset _ _).2 hsupport
  rw [klDiv_finiteProduct, ENNReal.toReal_sum (fun i _ => hcoordinate i)]

/-- KL divergence of iid blocks is blocklength times the base divergence,
including infinite base divergence and the zero-length identity `0 * ⊤ = 0`. -/
theorem klDiv_iid
    {α : Type v} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) (n : ℕ) :
    InformationTheory.klDiv (PMF.iid p n).toMeasure (PMF.iid q n).toMeasure =
      (n : ENNReal) * InformationTheory.klDiv p.toMeasure q.toMeasure := by
  have h := klDiv_finiteProduct (fun _ : Fin n => p) (fun _ : Fin n => q)
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul] at h
  convert! h

/-- Real KL divergence of iid blocks under support inclusion, in nats.
The guard expresses finite-information semantics. Unlike heterogeneous sum
conversion, `ENNReal.toReal_mul` itself does not require finiteness. -/
theorem toReal_klDiv_iid
    {α : Type v} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) (h : p.support ⊆ q.support) (n : ℕ) :
    (InformationTheory.klDiv (PMF.iid p n).toMeasure
        (PMF.iid q n).toMeasure).toReal =
      (n : ℝ) * (InformationTheory.klDiv p.toMeasure q.toMeasure).toReal := by
  have hblock := toReal_klDiv_finiteProduct
    (fun _ : Fin n => p) (fun _ : Fin n => q) (fun _ => h)
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul] at hblock
  convert! hblock

end LeanInfoTheory.Shannon
