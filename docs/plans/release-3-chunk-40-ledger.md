# C40.01 — Six-package coverage ledger

This ledger covers the six mathematical packages delivered by C25–C39. Select a declaration to see the signature printed from the compiled environment. The file and line links identify the defining Lean source, the selected step in its approved plan, and a permanent consumer. Each entry describes how the textbook statement was adapted and where its conclusion applies. [Evidence and provenance](release-3-chunk-40-notes.md)

The maintained comparison uses the complete serialized types, including universe parameters, binder names, binder modes and instances. The signatures below use Lean notation for readability. One abbreviation introduces the randomized-test representation. The growth comparison found no theorem aliases. Permanent examples and private consequences are counted separately from the public API. See the [registered textbook editions](../references.md).

| Package | Approved chunks | Additions over v0.2.0 | Representative public caller |
| --- | --- | ---: | --- |
| [Finite testing](#package-1) | C25–C26 | 21 | `CallerTesting.lean` |
| [Information density and one-shot coding](#package-2) | C27–C30 | 20 | `CallerOneShot.lean` |
| [Operational capacity and expurgation](#package-3) | C31–C32 | 21 | `CallerOperational.lean` |
| [Lossless separation](#package-4) | C33–C34 | 5 | `CallerSeparation.lean` |
| [Binary prefix lengths](#package-5) | C35–C36 | 10 | `CallerPrefix.lean` |
| [Method of types](#package-6) | C37–C39 | 30 | `CallerTypes.lean` |

The original frozen controls contain 601 declarations for v0.1.0 and 811 for v0.2.0. Both match the corresponding records in the current 918-declaration export, and all 918 structural records match the C39.06 export. The 107 additions are distributed as shown above. The separate R3 candidate qualification belongs to C40.05.

<a id="package-1"></a>

## Finite testing

- C25 records. [Approved plan](../../docs/plans/release-3-chunk-25.md) · [Endpoint handoff](../../docs/handoffs/chunk-25.md)
- C26 records. [Approved plan](../../docs/plans/release-3-chunk-26.md) · [Endpoint handoff](../../docs/handoffs/chunk-26.md)

Permanent examples. [BinaryTesting](../../LeanInfoTheory/Examples/BinaryTesting.lean) · [NeymanPearson](../../LeanInfoTheory/Examples/NeymanPearson.lean)

<details>
<summary><code>PMF.BinaryTest</code></summary>

A randomized binary test, giving the probability of rejecting the null at each observation.

**C25.01** · new type representation (abbreviation). Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L44) · [Approved step](../../docs/plans/release-3-chunk-25.md#L51) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §14.1, Table 14.1 and (14.1), pp. 276–277; §7.3 Thm 7.7(a). Reject the null with f(x) in [0,1]. Finite real averages use the given law. Size uses the null, power uses the alternative, and miss is one minus power.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L40](../../LeanInfoTheory/Examples/BinaryTesting.lean#L40) · [NeymanPearson L58](../../LeanInfoTheory/Examples/NeymanPearson.lean#L58)

**Binder order.** `X`.

```lean
@[reducible] def PMF.BinaryTest.{u} : Type u → Type u
```

</details>

<details>
<summary><code>PMF.BinaryTest.rejectProb</code></summary>

The probability that a test rejects the null when observations have law `P`.

**C25.01** · new definition/representation. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L70) · [Approved step](../../docs/plans/release-3-chunk-25.md#L51) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §14.1, Table 14.1 and (14.1), pp. 276–277; §7.3 Thm 7.7(a). Reject the null with f(x) in [0,1]. Finite real averages use the given law. Size uses the null, power uses the alternative, and miss is one minus power.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L43](../../LeanInfoTheory/Examples/BinaryTesting.lean#L43) · [NeymanPearson L88](../../LeanInfoTheory/Examples/NeymanPearson.lean#L88)

**Binder order.** `{X}`, `[instance]`, `f`, `P`.

```lean
def PMF.BinaryTest.rejectProb.{u} : {X : Type u} → [Fintype.{u} X] → PMF.BinaryTest.{u} X → PMF.{u} X → ℝ
```

</details>

<details>
<summary><code>PMF.BinaryTest.rejectProb_mem_Icc</code></summary>

The rejection probability of a randomized binary test lies in the unit interval.

**C25.01** · new mathematical theorem. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L74) · [Approved step](../../docs/plans/release-3-chunk-25.md#L51) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §14.1, Table 14.1 and (14.1), pp. 276–277; §7.3 Thm 7.7(a). Reject the null with f(x) in [0,1]. Finite real averages use the given law. Size uses the null, power uses the alternative, and miss is one minus power.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L75](../../LeanInfoTheory/Examples/BinaryTesting.lean#L75) · [NeymanPearson L90](../../LeanInfoTheory/Examples/NeymanPearson.lean#L90)

**Binder order.** `{X}`, `[instance]`, `f`, `P`.

```lean
theorem PMF.BinaryTest.rejectProb_mem_Icc.{u} : ∀ {X : Type u} [inst : Fintype.{u} X] (f : PMF.BinaryTest.{u} X)
  (P : PMF.{u} X), Membership.mem.{0, 0} (Set.Icc.{0} 0 1) (PMF.BinaryTest.rejectProb.{u} f P)
```

</details>

<details>
<summary><code>PMF.BinaryTest.size</code></summary>

The size (type-I error) is the rejection probability under the null law `P0`.

**C25.01** · new definition/representation. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L86) · [Approved step](../../docs/plans/release-3-chunk-25.md#L51) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §14.1, Table 14.1 and (14.1), pp. 276–277; §7.3 Thm 7.7(a). Reject the null with f(x) in [0,1]. Finite real averages use the given law. Size uses the null, power uses the alternative, and miss is one minus power.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L47](../../LeanInfoTheory/Examples/BinaryTesting.lean#L47) · [NeymanPearson L59](../../LeanInfoTheory/Examples/NeymanPearson.lean#L59)

**Binder order.** `{X}`, `[instance]`, `f`, `P0`.

```lean
def PMF.BinaryTest.size.{u} : {X : Type u} → [Fintype.{u} X] → PMF.BinaryTest.{u} X → PMF.{u} X → ℝ
```

</details>

<details>
<summary><code>PMF.BinaryTest.power</code></summary>

The power is the rejection probability under the alternative law `P1`.

**C25.01** · new definition/representation. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L90) · [Approved step](../../docs/plans/release-3-chunk-25.md#L51) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §14.1, Table 14.1 and (14.1), pp. 276–277; §7.3 Thm 7.7(a). Reject the null with f(x) in [0,1]. Finite real averages use the given law. Size uses the null, power uses the alternative, and miss is one minus power.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L48](../../LeanInfoTheory/Examples/BinaryTesting.lean#L48) · [NeymanPearson L61](../../LeanInfoTheory/Examples/NeymanPearson.lean#L61)

**Binder order.** `{X}`, `[instance]`, `f`, `P1`.

```lean
def PMF.BinaryTest.power.{u} : {X : Type u} → [Fintype.{u} X] → PMF.BinaryTest.{u} X → PMF.{u} X → ℝ
```

</details>

<details>
<summary><code>PMF.BinaryTest.typeIIError</code></summary>

The type-II error is the probability of accepting the null under the alternative law `P1`.

**C25.01** · new definition/representation. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L94) · [Approved step](../../docs/plans/release-3-chunk-25.md#L51) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §14.1, Table 14.1 and (14.1), pp. 276–277; §7.3 Thm 7.7(a). Reject the null with f(x) in [0,1]. Finite real averages use the given law. Size uses the null, power uses the alternative, and miss is one minus power.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L49](../../LeanInfoTheory/Examples/BinaryTesting.lean#L49) · [NeymanPearson L99](../../LeanInfoTheory/Examples/NeymanPearson.lean#L99)

**Binder order.** `{X}`, `[instance]`, `f`, `P1`.

```lean
def PMF.BinaryTest.typeIIError.{u} : {X : Type u} → [Fintype.{u} X] → PMF.BinaryTest.{u} X → PMF.{u} X → ℝ
```

</details>

<details>
<summary><code>PMF.BinaryTest.ofEvent</code></summary>

The deterministic test that rejects the null exactly on the event `s`.

**C25.02** · new definition/representation. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L53) · [Approved step](../../docs/plans/release-3-chunk-25.md#L56) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §14.1, Table 14.1 and (14.1), pp. 276–277. Represent a deterministic decision by a zero-one rejection weight. Finite PMF outer masses give event and complement probabilities, also on null atoms.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L81](../../LeanInfoTheory/Examples/BinaryTesting.lean#L81) · [NeymanPearson L147](../../LeanInfoTheory/Examples/NeymanPearson.lean#L147)

**Binder order.** `{X}`, `s`.

```lean
def PMF.BinaryTest.ofEvent.{u} : {X : Type u} → Set.{u} X → PMF.BinaryTest.{u} X
```

</details>

<details>
<summary><code>PMF.BinaryTest.ofEvent_apply</code></summary>

The rejection weight of an event test is its zero-one indicator.

**C25.02** · new mathematical theorem. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L59) · [Approved step](../../docs/plans/release-3-chunk-25.md#L56) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §14.1, Table 14.1 and (14.1), pp. 276–277. Represent a deterministic decision by a zero-one rejection weight. Finite PMF outer masses give event and complement probabilities, also on null atoms.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L83](../../LeanInfoTheory/Examples/BinaryTesting.lean#L83) · [NeymanPearson L153](../../LeanInfoTheory/Examples/NeymanPearson.lean#L153)

**Binder order.** `{X}`, `s`, `x`.

```lean
theorem PMF.BinaryTest.ofEvent_apply.{u} : ∀ {X : Type u} (s : Set.{u} X) (x : X),
  Eq.{1} (↑(PMF.BinaryTest.ofEvent.{u} s x)) (ite.{1} (Membership.mem.{u, u} s x) 1 0)
```

</details>

<details>
<summary><code>PMF.BinaryTest.rejectProb_ofEvent</code></summary>

The rejection probability of an event test is the real mass of its rejection event.

**C25.02** · new mathematical theorem. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L98) · [Approved step](../../docs/plans/release-3-chunk-25.md#L56) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §14.1, Table 14.1 and (14.1), pp. 276–277. Represent a deterministic decision by a zero-one rejection weight. Finite PMF outer masses give event and complement probabilities, also on null atoms.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L89](../../LeanInfoTheory/Examples/BinaryTesting.lean#L89)

**Binder order.** `{X}`, `[instance]`, `s`, `P`.

```lean
theorem PMF.BinaryTest.rejectProb_ofEvent.{u} : ∀ {X : Type u} [inst : Fintype.{u} X] (s : Set.{u} X) (P : PMF.{u} X),
  Eq.{1} (PMF.BinaryTest.rejectProb.{u} (PMF.BinaryTest.ofEvent.{u} s) P) ((PMF.toOuterMeasure.{u} P) s).toReal
```

</details>

<details>
<summary><code>PMF.BinaryTest.typeIIError_ofEvent</code></summary>

The type-II error of an event test is the real mass of the complementary acceptance event.

**C25.02** · new mathematical theorem. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L107) · [Approved step](../../docs/plans/release-3-chunk-25.md#L56) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §14.1, Table 14.1 and (14.1), pp. 276–277. Represent a deterministic decision by a zero-one rejection weight. Finite PMF outer masses give event and complement probabilities, also on null atoms.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L89](../../LeanInfoTheory/Examples/BinaryTesting.lean#L89)

**Binder order.** `{X}`, `[instance]`, `s`, `P1`.

```lean
theorem PMF.BinaryTest.typeIIError_ofEvent.{u} : ∀ {X : Type u} [inst : Fintype.{u} X] (s : Set.{u} X) (P1 : PMF.{u} X),
  Eq.{1} (PMF.BinaryTest.typeIIError.{u} (PMF.BinaryTest.ofEvent.{u} s) P1)
    ((PMF.toOuterMeasure.{u} P1) (compl.{u} s)).toReal
```

</details>

<details>
<summary><code>PMF.BinaryTest.errorSum</code></summary>

The unweighted sum of type-I error under `P0` and type-II error under `P1`.

**C25.03** · new definition/representation. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L113) · [Approved step](../../docs/plans/release-3-chunk-25.md#L60) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §7.3, Thm 7.7(a), (7.17)–(7.19), pp. 122–123. Use the released finite-PMF half-L1 TV on all randomized tests. This lower bound does not assume equal priors or full support.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L123](../../LeanInfoTheory/Examples/BinaryTesting.lean#L123)

**Binder order.** `{X}`, `[instance]`, `f`, `P0`, `P1`.

```lean
def PMF.BinaryTest.errorSum.{u} : {X : Type u} → [Fintype.{u} X] → PMF.BinaryTest.{u} X → PMF.{u} X → PMF.{u} X → ℝ
```

</details>

<details>
<summary><code>PMF.BinaryTest.one_sub_totalVariation_le_errorSum</code></summary>

Every randomized test has error sum at least one minus total variation.

**C25.03** · new mathematical theorem. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L117) · [Approved step](../../docs/plans/release-3-chunk-25.md#L60) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §7.3, Thm 7.7(a), (7.17)–(7.19), pp. 122–123. Use the released finite-PMF half-L1 TV on all randomized tests. This lower bound does not assume equal priors or full support.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L122](../../LeanInfoTheory/Examples/BinaryTesting.lean#L122)

**Binder order.** `{X}`, `[instance]`, `f`, `P0`, `P1`.

```lean
theorem PMF.BinaryTest.one_sub_totalVariation_le_errorSum.{u} : ∀ {X : Type u} [inst : Fintype.{u} X]
  (f : PMF.BinaryTest.{u} X) (P0 P1 : PMF.{u} X),
  LE.le.{0} (HSub.hSub.{0, 0, 0} 1 (PMF.totalVariation.{u} P0 P1)) (PMF.BinaryTest.errorSum.{u} f P0 P1)
```

</details>

<details>
<summary><code>PMF.BinaryTest.tvTest</code></summary>

The test rejecting where the alternative has strictly greater mass; ties accept the null.

**C25.04** · new definition/representation. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L64) · [Approved step](../../docs/plans/release-3-chunk-25.md#L66) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §7.3, Thm 7.7(a), (7.17)–(7.19), pp. 122–123; §14.1, (14.1). Reject on strict alternative dominance. The same witness attains 1−TV and half that sum under equal priors. Ties accept the null.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L135](../../LeanInfoTheory/Examples/BinaryTesting.lean#L135)

**Binder order.** `{X}`, `P0`, `P1`.

```lean
def PMF.BinaryTest.tvTest.{u} : {X : Type u} → PMF.{u} X → PMF.{u} X → PMF.BinaryTest.{u} X
```

</details>

<details>
<summary><code>PMF.BinaryTest.errorSum_tvTest</code></summary>

The strict mass-comparison test has error sum one minus total variation.

**C25.04** · new mathematical theorem. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L128) · [Approved step](../../docs/plans/release-3-chunk-25.md#L66) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §7.3, Thm 7.7(a), (7.17)–(7.19), pp. 122–123; §14.1, (14.1). Reject on strict alternative dominance. The same witness attains 1−TV and half that sum under equal priors. Ties accept the null.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L137](../../LeanInfoTheory/Examples/BinaryTesting.lean#L137)

**Binder order.** `{X}`, `[instance]`, `P0`, `P1`.

```lean
theorem PMF.BinaryTest.errorSum_tvTest.{u} : ∀ {X : Type u} [inst : Fintype.{u} X] (P0 P1 : PMF.{u} X),
  Eq.{1} (PMF.BinaryTest.errorSum.{u} (PMF.BinaryTest.tvTest.{u} P0 P1) P0 P1)
    (HSub.hSub.{0, 0, 0} 1 (PMF.totalVariation.{u} P0 P1))
```

</details>

<details>
<summary><code>PMF.BinaryTest.isLeast_errorSum</code></summary>

The least error sum over all randomized tests is one minus total variation.

**C25.04** · new mathematical theorem. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L142) · [Approved step](../../docs/plans/release-3-chunk-25.md#L66) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §7.3, Thm 7.7(a), (7.17)–(7.19), pp. 122–123; §14.1, (14.1). Reject on strict alternative dominance. The same witness attains 1−TV and half that sum under equal priors. Ties accept the null.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L137](../../LeanInfoTheory/Examples/BinaryTesting.lean#L137)

**Binder order.** `{X}`, `[instance]`, `P0`, `P1`.

```lean
theorem PMF.BinaryTest.isLeast_errorSum.{u} : ∀ {X : Type u} [inst : Fintype.{u} X] (P0 P1 : PMF.{u} X),
  IsLeast.{0} (Set.range.{0, u + 1} fun f => PMF.BinaryTest.errorSum.{u} f P0 P1)
    (HSub.hSub.{0, 0, 0} 1 (PMF.totalVariation.{u} P0 P1))
```

</details>

<details>
<summary><code>PMF.BinaryTest.equalPriorError</code></summary>

The average probability of error under equal priors and zero-one loss.

**C25.04** · new definition/representation. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L151) · [Approved step](../../docs/plans/release-3-chunk-25.md#L66) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §7.3, Thm 7.7(a), (7.17)–(7.19), pp. 122–123; §14.1, (14.1). Reject on strict alternative dominance. The same witness attains 1−TV and half that sum under equal priors. Ties accept the null.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L143](../../LeanInfoTheory/Examples/BinaryTesting.lean#L143)

**Binder order.** `{X}`, `[instance]`, `f`, `P0`, `P1`.

```lean
def PMF.BinaryTest.equalPriorError.{u} : {X : Type u} →
  [Fintype.{u} X] → PMF.BinaryTest.{u} X → PMF.{u} X → PMF.{u} X → ℝ
```

</details>

<details>
<summary><code>PMF.BinaryTest.isLeast_equalPriorError</code></summary>

The least equal-prior error over all randomized tests is half of one minus TV.

**C25.04** · new mathematical theorem. Import `LeanInfoTheory.Probability.BinaryTesting`. [Definition](../../LeanInfoTheory/Probability/BinaryTesting.lean#L155) · [Approved step](../../docs/plans/release-3-chunk-25.md#L66) · [Handoff](../../docs/handoffs/chunk-25.md#L84)

**Source and limits.** PW24 §7.3, Thm 7.7(a), (7.17)–(7.19), pp. 122–123; §14.1, (14.1). Reject on strict alternative dominance. The same witness attains 1−TV and half that sum under equal priors. Ties accept the null.

**Consumer.** direct source reference in the listed permanent caller(s). [BinaryTesting L146](../../LeanInfoTheory/Examples/BinaryTesting.lean#L146)

**Binder order.** `{X}`, `[instance]`, `P0`, `P1`.

```lean
theorem PMF.BinaryTest.isLeast_equalPriorError.{u} : ∀ {X : Type u} [inst : Fintype.{u} X] (P0 P1 : PMF.{u} X),
  IsLeast.{0} (Set.range.{0, u + 1} fun f => PMF.BinaryTest.equalPriorError.{u} f P0 P1)
    (HDiv.hDiv.{0, 0, 0} (HSub.hSub.{0, 0, 0} 1 (PMF.totalVariation.{u} P0 P1)) 2)
```

</details>

<details>
<summary><code>PMF.BinaryTest.likelihoodThresholdTest</code></summary>

Reject above the alternative-to-null mass threshold, accept below it, and reject with probability `γ` on its boundary.

**C26.01** · new definition/representation. Import `LeanInfoTheory.Probability.NeymanPearson`. [Definition](../../LeanInfoTheory/Probability/NeymanPearson.lean#L43) · [Approved step](../../docs/plans/release-3-chunk-26.md#L78) · [Handoff](../../docs/handoffs/chunk-26.md#L107)

**Source and limits.** PW24 §§14.1–2, §14.4 Thm 14.11/(14.11), p. 284. Compare finite atom masses with nonnegative c, allow c=0 and use one common tie weight γ. On positive atoms c=exp(−τ) and γ=1−λ in the book's null-acceptance convention.

**Consumer.** direct source reference in the listed permanent caller(s). [NeymanPearson L33](../../LeanInfoTheory/Examples/NeymanPearson.lean#L33)

**Binder order.** `{X}`, `P0`, `P1`, `c`, `γ`.

```lean
def PMF.BinaryTest.likelihoodThresholdTest.{u} : {X : Type u} →
  PMF.{u} X → PMF.{u} X → NNReal → ↑(Set.Icc.{0} 0 1) → PMF.BinaryTest.{u} X
```

</details>

<details>
<summary><code>PMF.BinaryTest.likelihoodThresholdTest_apply</code></summary>

The rejection weight is one above the threshold, zero below, and `γ` at equality.

**C26.01** · new mathematical theorem. Import `LeanInfoTheory.Probability.NeymanPearson`. [Definition](../../LeanInfoTheory/Probability/NeymanPearson.lean#L53) · [Approved step](../../docs/plans/release-3-chunk-26.md#L78) · [Handoff](../../docs/handoffs/chunk-26.md#L107)

**Source and limits.** PW24 §§14.1–2, §14.4 Thm 14.11/(14.11), p. 284. Compare finite atom masses with nonnegative c, allow c=0 and use one common tie weight γ. On positive atoms c=exp(−τ) and γ=1−λ in the book's null-acceptance convention.

**Consumer.** direct source reference in the listed permanent caller(s). [NeymanPearson L34](../../LeanInfoTheory/Examples/NeymanPearson.lean#L34)

**Binder order.** `{X}`, `P0`, `P1`, `c`, `γ`, `x`.

```lean
theorem PMF.BinaryTest.likelihoodThresholdTest_apply.{u} : ∀ {X : Type u} (P0 P1 : PMF.{u} X) (c : NNReal)
  (γ : ↑(Set.Icc.{0} 0 1)) (x : X),
  Eq.{1} (↑(PMF.BinaryTest.likelihoodThresholdTest.{u} P0 P1 c γ x))
    (ite.{1} (LT.lt.{0} (HMul.hMul.{0, 0, 0} (↑c) (P0 x).toReal) (P1 x).toReal) 1
      (ite.{1} (LT.lt.{0} (P1 x).toReal (HMul.hMul.{0, 0, 0} (↑c) (P0 x).toReal)) 0 ↑γ))
```

</details>

<details>
<summary><code>PMF.BinaryTest.power_le_power_likelihoodThresholdTest</code></summary>

A likelihood-threshold test has at least the power of every randomized test whose size is at most its own size. The threshold may be zero.

**C26.02** · new mathematical theorem. Import `LeanInfoTheory.Probability.NeymanPearson`. [Definition](../../LeanInfoTheory/Probability/NeymanPearson.lean#L66) · [Approved step](../../docs/plans/release-3-chunk-26.md#L83) · [Handoff](../../docs/handoffs/chunk-26.md#L107)

**Source and limits.** PW24 §14.4, Thm 14.11/(14.11), p. 284. A supplied threshold rule dominates every randomized test of no greater null size. Common-null decisions contribute zero.

**Consumer.** direct source reference in the listed permanent caller(s). [NeymanPearson L62](../../LeanInfoTheory/Examples/NeymanPearson.lean#L62)

**Binder order.** `{X}`, `[instance]`, `P0`, `P1`, `c`, `γ`, `g`, `hg`.

```lean
theorem PMF.BinaryTest.power_le_power_likelihoodThresholdTest.{u} : ∀ {X : Type u} [inst : Fintype.{u} X]
  (P0 P1 : PMF.{u} X) (c : NNReal) (γ : ↑(Set.Icc.{0} 0 1)) (g : PMF.BinaryTest.{u} X),
  LE.le.{0} (PMF.BinaryTest.size.{u} g P0)
      (PMF.BinaryTest.size.{u} (PMF.BinaryTest.likelihoodThresholdTest.{u} P0 P1 c γ) P0) →
    LE.le.{0} (PMF.BinaryTest.power.{u} g P1)
      (PMF.BinaryTest.power.{u} (PMF.BinaryTest.likelihoodThresholdTest.{u} P0 P1 c γ) P1)
```

</details>

<details>
<summary><code>PMF.BinaryTest.exists_likelihoodThresholdTest</code></summary>

At every prescribed level in the closed unit interval, one randomized likelihood-threshold test has exactly that size and dominates every randomized competitor under the size cap. The threshold and common boundary weight are chosen before the competitor. No support inclusion is required.

**C26.04** · new mathematical theorem. Import `LeanInfoTheory.Probability.NeymanPearson`. [Definition](../../LeanInfoTheory/Probability/NeymanPearson.lean#L272) · [Approved step](../../docs/plans/release-3-chunk-26.md#L92) · [Handoff](../../docs/handoffs/chunk-26.md#L107)

**Source and limits.** PW24 §14.4, Thm 14.11/(14.11), p. 284. One pair c,γ exactly attains each level in [0,1] and dominates all competitors of at most that size; singular atoms and both endpoints are included. No uniqueness is asserted.

**Consumer.** direct source reference in the listed permanent caller(s). [NeymanPearson L77](../../LeanInfoTheory/Examples/NeymanPearson.lean#L77)

**Binder order.** `{X}`, `[instance]`, `P0`, `P1`, `a`, `ha`.

```lean
theorem PMF.BinaryTest.exists_likelihoodThresholdTest.{u} : ∀ {X : Type u} [inst : Fintype.{u} X] (P0 P1 : PMF.{u} X)
  (a : ℝ),
  Membership.mem.{0, 0} (Set.Icc.{0} 0 1) a →
    ∃ c γ,
      have fStar := PMF.BinaryTest.likelihoodThresholdTest.{u} P0 P1 c γ;
      Eq.{1} (PMF.BinaryTest.size.{u} fStar P0) a ∧
        ∀ (g : PMF.BinaryTest.{u} X),
          LE.le.{0} (PMF.BinaryTest.size.{u} g P0) a →
            LE.le.{0} (PMF.BinaryTest.power.{u} g P1) (PMF.BinaryTest.power.{u} fStar P1)
```

</details>

### Reused release declarations

| Qualified name and focused import | Caller |
| --- | --- |
| [PMF.abs_sum_sub_le_totalVariation_of_mem_Icc](../../LeanInfoTheory/Probability/TotalVariation.lean#L295) · `LeanInfoTheory.Probability.TotalVariation` | [BinaryTesting L121](../../LeanInfoTheory/Probability/BinaryTesting.lean#L121) |
| [PMF.totalVariation_eq_toOuterMeasure_sub](../../LeanInfoTheory/Probability/TotalVariation.lean#L169) · `LeanInfoTheory.Probability.TotalVariation` | [BinaryTesting L134](../../LeanInfoTheory/Probability/BinaryTesting.lean#L134) |
| [PMF.totalVariation](../../LeanInfoTheory/Probability/TotalVariation.lean#L51) · `LeanInfoTheory.Probability.TotalVariation` | [BinaryTesting L118](../../LeanInfoTheory/Probability/BinaryTesting.lean#L118) |

<details><summary>Compiled signatures of the reused declarations</summary>

```lean
theorem PMF.abs_sum_sub_le_totalVariation_of_mem_Icc.{u} : ∀ {α : Type u} [inst : Fintype.{u} α] (p q : PMF.{u} α)
  (f : α → ℝ) (l u : ℝ),
  LE.le.{0} l u →
    (∀ (a : α), LE.le.{0} l (f a) ∧ LE.le.{0} (f a) u) →
      LE.le.{0}
        (abs.{0}
          (HSub.hSub.{0, 0, 0} (∑ a, HMul.hMul.{0, 0, 0} (p a).toReal (f a))
            (∑ a, HMul.hMul.{0, 0, 0} (q a).toReal (f a))))
        (HMul.hMul.{0, 0, 0} (HSub.hSub.{0, 0, 0} u l) (PMF.totalVariation.{u} p q))
theorem PMF.totalVariation_eq_toOuterMeasure_sub.{u} : ∀ {α : Type u} [inst : Fintype.{u} α] (p q : PMF.{u} α),
  Eq.{1} (PMF.totalVariation.{u} p q)
    (HSub.hSub.{0, 0, 0}
      ((PMF.toOuterMeasure.{u} p) (Set.ofPred.{u} fun a => LE.le.{0} (q a).toReal (p a).toReal)).toReal
      ((PMF.toOuterMeasure.{u} q) (Set.ofPred.{u} fun a => LE.le.{0} (q a).toReal (p a).toReal)).toReal)
def PMF.totalVariation.{u} : {α : Type u} → [Fintype.{u} α] → PMF.{u} α → PMF.{u} α → ℝ
```

</details>

### Private and example results

- Minimum miss at prescribed size follows from maximal power. [NeymanPearson L94](../../LeanInfoTheory/Examples/NeymanPearson.lean#L94)
- C26.03 splits null rejection mass into the strict tail and common randomized tie. [size_likelihoodThresholdTest_eq](../../LeanInfoTheory/Probability/NeymanPearson.lean#L137)
- C26.03 locates a finite threshold crossing for the eventual calibration witness. [exists_likelihoodThreshold_crossing](../../LeanInfoTheory/Probability/NeymanPearson.lean#L198)

<a id="package-2"></a>

## Information density and one-shot coding

- C27 records. [Approved plan](../../docs/plans/release-3-chunk-27.md) · [Endpoint handoff](../../docs/handoffs/chunk-27.md)
- C28 records. [Approved plan](../../docs/plans/release-3-chunk-28.md) · [Endpoint handoff](../../docs/handoffs/chunk-28.md)
- C29 records. [Approved plan](../../docs/plans/release-3-chunk-29.md) · [Endpoint handoff](../../docs/handoffs/chunk-29.md)
- C30 records. [Approved plan](../../docs/plans/release-3-chunk-30.md) · [Endpoint handoff](../../docs/handoffs/chunk-30.md)

Permanent examples. [InformationDensity](../../LeanInfoTheory/Examples/InformationDensity.lean) · [IidInformationDensity](../../LeanInfoTheory/Examples/IidInformationDensity.lean) · [RandomCodebook](../../LeanInfoTheory/Examples/RandomCodebook.lean) · [ChannelCodingOneShot](../../LeanInfoTheory/Examples/ChannelCodingOneShot.lean) · [ChannelCodingOneShotBinary](../../LeanInfoTheory/Examples/ChannelCodingOneShotBinary.lean) · [ChannelCodingOneShotTernary](../../LeanInfoTheory/Examples/ChannelCodingOneShotTernary.lean) · [ChannelCodingOneShotSparse](../../LeanInfoTheory/Examples/ChannelCodingOneShotSparse.lean) · [ChannelCodingOneShotFinite](../../LeanInfoTheory/Examples/ChannelCodingOneShotFinite.lean)

<details>
<summary><code>LeanInfoTheory.Shannon.infoDensity</code></summary>

Information density in nats for an input-output pair. On joint support this is the logarithm of the joint mass divided by the independent-pair mass, and it can be negative. At zero joint mass, real division and `Real.log` give the conventional value zero.

**C27.01** · new definition/representation. Import `LeanInfoTheory.Shannon.InformationDensity`. [Definition](../../LeanInfoTheory/Shannon/InformationDensity.lean#L38) · [Approved step](../../docs/plans/release-3-chunk-27.md#L62) · [Handoff](../../docs/handoffs/chunk-27.md#L162)

**Source and limits.** PW24 §18.1, Def 18.1/(18.2), p. 351. Finite real log density is used on true joint support, which lies in the independent-product support. Real log totalization outside support does not encode an extended negative infinity.

**Consumer.** direct source reference in the listed permanent caller(s). [InformationDensity L49](../../LeanInfoTheory/Examples/InformationDensity.lean#L49) · [IidInformationDensity L42](../../LeanInfoTheory/Examples/IidInformationDensity.lean#L42)

**Binder order.** `{A}`, `{B}`, `p`, `W`, `z`.

```lean
def LeanInfoTheory.Shannon.infoDensity.{u, v} : {A : Type u} →
  {B : Type v} → PMF.{u} A → (A → PMF.{v} B) → Prod.{u, v} A B → ℝ
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.support_channelJoint_subset_indepProd</code></summary>

Every supported channel pair has positive mass under the independent product of the input and output laws.

**C27.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.InformationDensity`. [Definition](../../LeanInfoTheory/Shannon/InformationDensity.lean#L44) · [Approved step](../../docs/plans/release-3-chunk-27.md#L62) · [Handoff](../../docs/handoffs/chunk-27.md#L162)

**Source and limits.** PW24 §18.1, Def 18.1/(18.2), p. 351. Finite real log density is used on true joint support, which lies in the independent-product support. Real log totalization outside support does not encode an extended negative infinity.

**Consumer.** direct source reference in the listed permanent caller(s). [InformationDensity L37](../../LeanInfoTheory/Examples/InformationDensity.lean#L37)

**Binder order.** `{A}`, `{B}`, `p`, `W`.

```lean
theorem LeanInfoTheory.Shannon.support_channelJoint_subset_indepProd.{u, v} : ∀ {A : Type u} {B : Type v}
  (p : PMF.{u} A) (W : A → PMF.{v} B),
  PMF.support.{max u v} (PMF.channelJoint.{u, v} p W) ⊆
    PMF.support.{max u v} (LeanInfoTheory.Shannon.indepProd.{u, v} p (PMF.bind.{u, v} p W))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.sum_mul_infoDensity_eq_mutualInfo</code></summary>

The mean information density under the joint law is mutual information in nats.

**C27.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.InformationDensity`. [Definition](../../LeanInfoTheory/Shannon/InformationDensity.lean#L53) · [Approved step](../../docs/plans/release-3-chunk-27.md#L67) · [Handoff](../../docs/handoffs/chunk-27.md#L162)

**Source and limits.** PW24 §18.1 Prop 18.2, p. 351; CT91 §2.3, (2.28)–(2.30), pp. 18–19. Jointly weighted finite real expectation equals mutual information in nats; atoms of zero joint mass contribute zero.

**Consumer.** direct source reference in the listed permanent caller(s). [InformationDensity L71](../../LeanInfoTheory/Examples/InformationDensity.lean#L71) · [IidInformationDensity L132](../../LeanInfoTheory/Examples/IidInformationDensity.lean#L132)

**Binder order.** `{A}`, `{B}`, `[instance]`, `[instance]`, `p`, `W`.

```lean
theorem LeanInfoTheory.Shannon.sum_mul_infoDensity_eq_mutualInfo.{u, v} : ∀ {A : Type u} {B : Type v}
  [inst : Fintype.{u} A] [inst_1 : Fintype.{v} B] (p : PMF.{u} A) (W : A → PMF.{v} B),
  Eq.{1}
    (∑ z,
      HMul.hMul.{0, 0, 0} ((PMF.channelJoint.{u, v} p W) z).toReal (LeanInfoTheory.Shannon.infoDensity.{u, v} p W z))
    (LeanInfoTheory.mutualInfo.{u, v} (PMF.channelJoint.{u, v} p W))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.infoDensityThresholdEvent</code></summary>

The strict information-density threshold event, defined by real atom masses on the whole product. Every zero-joint atom fails, at every real threshold.

**C27.03** · new definition/representation. Import `LeanInfoTheory.Shannon.InformationDensity`. [Definition](../../LeanInfoTheory/Shannon/InformationDensity.lean#L65) · [Approved step](../../docs/plans/release-3-chunk-27.md#L71) · [Handoff](../../docs/handoffs/chunk-27.md#L162)

**Source and limits.** PW24 §18.1 (18.2); §18.2 Thm 18.5/(18.9)–(18.10), pp. 354–355. The global strict mass comparison exp(t)Q<J assigns equality to the miss. The log threshold equivalence holds on true support; the complementary true-event mass can use the weak log lower tail.

**Consumer.** direct source reference in the listed permanent caller(s). [InformationDensity L74](../../LeanInfoTheory/Examples/InformationDensity.lean#L74) · [IidInformationDensity L77](../../LeanInfoTheory/Examples/IidInformationDensity.lean#L77) · [RandomCodebook L142](../../LeanInfoTheory/Examples/RandomCodebook.lean#L142) · [ChannelCodingOneShot L211](../../LeanInfoTheory/Examples/ChannelCodingOneShot.lean#L211) · [ChannelCodingOneShotBinary L43](../../LeanInfoTheory/Examples/ChannelCodingOneShotBinary.lean#L43) · [ChannelCodingOneShotTernary L48](../../LeanInfoTheory/Examples/ChannelCodingOneShotTernary.lean#L48) · [ChannelCodingOneShotFinite L34](../../LeanInfoTheory/Examples/ChannelCodingOneShotFinite.lean#L34)

**Binder order.** `{A}`, `{B}`, `p`, `W`, `t`.

```lean
def LeanInfoTheory.Shannon.infoDensityThresholdEvent.{u, v} : {A : Type u} →
  {B : Type v} → PMF.{u} A → (A → PMF.{v} B) → ℝ → Set.{max v u} (Prod.{u, v} A B)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.mem_infoDensityThresholdEvent_iff_of_mem_support</code></summary>

On joint support, the mass-comparison event is the strict log-density threshold.

**C27.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.InformationDensity`. [Definition](../../LeanInfoTheory/Shannon/InformationDensity.lean#L71) · [Approved step](../../docs/plans/release-3-chunk-27.md#L71) · [Handoff](../../docs/handoffs/chunk-27.md#L162)

**Source and limits.** PW24 §18.1 (18.2); §18.2 Thm 18.5/(18.9)–(18.10), pp. 354–355. The global strict mass comparison exp(t)Q<J assigns equality to the miss. The log threshold equivalence holds on true support; the complementary true-event mass can use the weak log lower tail.

**Consumer.** direct source reference in the listed permanent caller(s). [InformationDensity L82](../../LeanInfoTheory/Examples/InformationDensity.lean#L82) · [IidInformationDensity L151](../../LeanInfoTheory/Examples/IidInformationDensity.lean#L151)

**Binder order.** `{A}`, `{B}`, `p`, `W`, `t`, `{z}`, `hz`.

```lean
theorem LeanInfoTheory.Shannon.mem_infoDensityThresholdEvent_iff_of_mem_support.{u, v} : ∀ {A : Type u} {B : Type v}
  (p : PMF.{u} A) (W : A → PMF.{v} B) (t : ℝ) {z : Prod.{u, v} A B},
  Membership.mem.{max u v, max u v} (PMF.support.{max u v} (PMF.channelJoint.{u, v} p W)) z →
    (Membership.mem.{max u v, max v u} (LeanInfoTheory.Shannon.infoDensityThresholdEvent.{u, v} p W t) z ↔
      LT.lt.{0} t (LeanInfoTheory.Shannon.infoDensity.{u, v} p W z))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.channelJoint_infoDensityThresholdEvent_compl_eq</code></summary>

Under the joint law, the complementary miss includes equality at the threshold. The two sets need only agree on joint support.

**C27.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.InformationDensity`. [Definition](../../LeanInfoTheory/Shannon/InformationDensity.lean#L84) · [Approved step](../../docs/plans/release-3-chunk-27.md#L71) · [Handoff](../../docs/handoffs/chunk-27.md#L162)

**Source and limits.** PW24 §18.1 (18.2); §18.2 Thm 18.5/(18.9)–(18.10), pp. 354–355. The global strict mass comparison exp(t)Q<J assigns equality to the miss. The log threshold equivalence holds on true support; the complementary true-event mass can use the weak log lower tail.

**Consumer.** direct source reference in the listed permanent caller(s). [InformationDensity L100](../../LeanInfoTheory/Examples/InformationDensity.lean#L100)

**Binder order.** `{A}`, `{B}`, `p`, `W`, `t`.

```lean
theorem LeanInfoTheory.Shannon.channelJoint_infoDensityThresholdEvent_compl_eq.{u, v} : ∀ {A : Type u} {B : Type v}
  (p : PMF.{u} A) (W : A → PMF.{v} B) (t : ℝ),
  Eq.{1}
    ((PMF.toOuterMeasure.{max u v} (PMF.channelJoint.{u, v} p W))
        (compl.{max u v} (LeanInfoTheory.Shannon.infoDensityThresholdEvent.{u, v} p W t))).toReal
    ((PMF.toOuterMeasure.{max u v} (PMF.channelJoint.{u, v} p W))
        (Set.ofPred.{max u v} fun z => LE.le.{0} (LeanInfoTheory.Shannon.infoDensity.{u, v} p W z) t)).toReal
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.indepProd_infoDensityThresholdEvent_le</code></summary>

Under the independent input-output law, the strict event has probability at most `exp (-t)` for every real threshold. Only internal enumeration requires a `Fintype`.

**C27.04** · new mathematical theorem. Import `LeanInfoTheory.Shannon.InformationDensity`. [Definition](../../LeanInfoTheory/Shannon/InformationDensity.lean#L97) · [Approved step](../../docs/plans/release-3-chunk-27.md#L77) · [Handoff](../../docs/handoffs/chunk-27.md#L162)

**Source and limits.** PW24 §18.1 Prop 18.3 and Cor 18.4/(18.6), pp. 352–353. Independent-pair false-alarm mass is at most exp(−t) for arbitrary real t using the global comparison, including Q-positive/J-null atoms.

**Consumer.** direct source reference in the listed permanent caller(s). [InformationDensity L114](../../LeanInfoTheory/Examples/InformationDensity.lean#L114) · [ChannelCodingOneShotBinary L121](../../LeanInfoTheory/Examples/ChannelCodingOneShotBinary.lean#L121) · [ChannelCodingOneShotTernary L149](../../LeanInfoTheory/Examples/ChannelCodingOneShotTernary.lean#L149)

**Binder order.** `{A}`, `{B}`, `[instance]`, `[instance]`, `p`, `W`, `t`.

```lean
theorem LeanInfoTheory.Shannon.indepProd_infoDensityThresholdEvent_le.{u, v} : ∀ {A : Type u} {B : Type v}
  [Finite.{u + 1} A] [Finite.{v + 1} B] (p : PMF.{u} A) (W : A → PMF.{v} B) (t : ℝ),
  LE.le.{0}
    ((PMF.toOuterMeasure.{max u v} (LeanInfoTheory.Shannon.indepProd.{u, v} p (PMF.bind.{u, v} p W)))
        (LeanInfoTheory.Shannon.infoDensityThresholdEvent.{u, v} p W t)).toReal
    (Real.exp (Neg.neg.{0} t))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.infoDensity_iid_of_mem_support</code></summary>

Under iid input and a memoryless channel, the information density of a supported word pair is the sum of its coordinate-pair densities, in nats. This includes length zero. The support premise permits sparse input laws and channel rows while respecting the totalized density at impossible pairs.

**C28.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.IidInformationDensity`. [Definition](../../LeanInfoTheory/Shannon/IidInformationDensity.lean#L64) · [Approved step](../../docs/plans/release-3-chunk-28.md#L90) · [Handoff](../../docs/handoffs/chunk-28.md#L142)

**Source and limits.** PW24 §19.2, proof of Thm 19.8, p. 376; §18.1, (18.2). Supported block information density is the sum of coordinate densities, in nats. This identity allows length zero.

**Consumer.** direct source reference in the listed permanent caller(s). [IidInformationDensity L44](../../LeanInfoTheory/Examples/IidInformationDensity.lean#L44)

**Binder order.** `{A}`, `{B}`, `[instance]`, `[instance]`, `p`, `W`, `n`, `{z}`, `hz`.

```lean
theorem LeanInfoTheory.Shannon.infoDensity_iid_of_mem_support.{u, v} : ∀ {A : Type u} {B : Type v}
  [inst : Fintype.{u} A] [inst_1 : Fintype.{v} B] (p : PMF.{u} A) (W : A → PMF.{v} B) (n : ℕ)
  {z : Prod.{u, v} (Fin n → A) (Fin n → B)},
  Membership.mem.{max u v, max u v}
      (PMF.support.{max u v} (PMF.channelJoint.{u, v} (PMF.iid.{u} p n) (PMF.memorylessChannel.{u, v} W n))) z →
    Eq.{1} (LeanInfoTheory.Shannon.infoDensity.{u, v} (PMF.iid.{u} p n) (PMF.memorylessChannel.{u, v} W n) z)
      (∑ i, LeanInfoTheory.Shannon.infoDensity.{u, v} p W (Prod.mk.{u, v} (z.1 i) (z.2 i)))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.tendsto_infoDensity_iid_deviation</code></summary>

Under the iid input and memoryless channel, the probability of a closed two-sided deviation of the normalized block information density from single-letter mutual information tends to zero. The word pairs and joint law vary with the positive blocklength, and input and output can be dependent.

**C28.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.IidInformationDensity`. [Definition](../../LeanInfoTheory/Shannon/IidInformationDensity.lean#L185) · [Approved step](../../docs/plans/release-3-chunk-28.md#L95) · [Handoff](../../docs/handoffs/chunk-28.md#L142)

**Source and limits.** PW24 §19.2, proof of Thm 19.8, p. 376; CT91 §§3.1, 8.6, Thm 8.6.1(1), pp. 195–196. Two-sided normalized deviations go to zero on varying finite word spaces using marginal and joint AEP; division is used on the positive tail.

**Consumer.** direct source reference in the listed permanent caller(s). [IidInformationDensity L70](../../LeanInfoTheory/Examples/IidInformationDensity.lean#L70)

**Binder order.** `{A}`, `{B}`, `[instance]`, `[instance]`, `p`, `W`, `{ε}`, `hε`.

```lean
theorem LeanInfoTheory.Shannon.tendsto_infoDensity_iid_deviation.{u, v} : ∀ {A : Type u} {B : Type v}
  [inst : Fintype.{u} A] [inst_1 : Fintype.{v} B] (p : PMF.{u} A) (W : A → PMF.{v} B) {ε : ℝ},
  LT.lt.{0} 0 ε →
    Filter.Tendsto.{0, 0}
      (fun k =>
        have n := HAdd.hAdd.{0, 0, 0} k 1;
        ((PMF.toOuterMeasure.{max u v} (PMF.channelJoint.{u, v} (PMF.iid.{u} p n) (PMF.memorylessChannel.{u, v} W n)))
            (Set.ofPred.{max u v} fun z =>
              LE.le.{0} ε
                (abs.{0}
                  (HSub.hSub.{0, 0, 0}
                    (HDiv.hDiv.{0, 0, 0}
                      (LeanInfoTheory.Shannon.infoDensity.{u, v} (PMF.iid.{u} p n) (PMF.memorylessChannel.{u, v} W n) z)
                      ↑n)
                    (LeanInfoTheory.mutualInfo.{u, v} (PMF.channelJoint.{u, v} p W)))))).toReal)
      Filter.atTop.{0} (nhds.{0} 0)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.tendsto_prob_infoDensityThresholdEvent_iid_compl</code></summary>

For every fixed real threshold per symbol strictly below single-letter mutual information, the true-pair miss probability of the strict iid word test tends to zero. The threshold is unnormalized and ties count as misses.

**C28.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.IidInformationDensity`. [Definition](../../LeanInfoTheory/Shannon/IidInformationDensity.lean#L207) · [Approved step](../../docs/plans/release-3-chunk-28.md#L100) · [Handoff](../../docs/handoffs/chunk-28.md#L142)

**Source and limits.** PW24 §18.2, (18.9), p. 354; §19.2 Thm 19.8, p. 376. At every n use C27's literal closed miss against n*s. Its probability tends to zero for s strictly below mutual information, without a density equivalence on off-support points.

**Consumer.** direct source reference in the listed permanent caller(s). [IidInformationDensity L79](../../LeanInfoTheory/Examples/IidInformationDensity.lean#L79) · [ChannelCodingOneShotFinite L51](../../LeanInfoTheory/Examples/ChannelCodingOneShotFinite.lean#L51)

**Binder order.** `{A}`, `{B}`, `[instance]`, `[instance]`, `p`, `W`, `{s}`, `hs`.

```lean
theorem LeanInfoTheory.Shannon.tendsto_prob_infoDensityThresholdEvent_iid_compl.{u, v} : ∀ {A : Type u} {B : Type v}
  [inst : Fintype.{u} A] [inst_1 : Fintype.{v} B] (p : PMF.{u} A) (W : A → PMF.{v} B) {s : ℝ},
  LT.lt.{0} s (LeanInfoTheory.mutualInfo.{u, v} (PMF.channelJoint.{u, v} p W)) →
    Filter.Tendsto.{0, 0}
      (fun n =>
        ((PMF.toOuterMeasure.{max u v} (PMF.channelJoint.{u, v} (PMF.iid.{u} p n) (PMF.memorylessChannel.{u, v} W n)))
            (compl.{max u v}
              (LeanInfoTheory.Shannon.infoDensityThresholdEvent.{u, v} (PMF.iid.{u} p n)
                (PMF.memorylessChannel.{u, v} W n) (HMul.hMul.{0, 0, 0} (↑n) s)))).toReal)
      Filter.atTop.{0} (nhds.{0} 0)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.codebookOutputLaw</code></summary>

Sample independent codewords from `q`, then send the word at the fixed message index through `K`, retaining the sampled book and output.

**C29.01** · new definition/representation. Import `LeanInfoTheory.Shannon.RandomCodebook`. [Definition](../../LeanInfoTheory/Shannon/RandomCodebook.lean#L51) · [Approved step](../../docs/plans/release-3-chunk-29.md#L64) · [Handoff](../../docs/handoffs/chunk-29.md#L120)

**Source and limits.** PW24 §18.2, proof of Thm 18.5, pp. 354–355; CT91 §8.7, proof of Thm 8.7.1, pp. 199–201. Sample iid whole words with arbitrary word law q, then sample output from the actual sent word. No coordinate-iid premise is imposed on q.

**Consumer.** direct source reference in the listed permanent caller(s). [RandomCodebook L34](../../LeanInfoTheory/Examples/RandomCodebook.lean#L34) · [ChannelCodingOneShot L32](../../LeanInfoTheory/Examples/ChannelCodingOneShot.lean#L32)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `q`, `K`, `m`.

```lean
def LeanInfoTheory.Shannon.codebookOutputLaw.{u, v} : {X : Type u} →
  {Y : Type v} →
    [Fintype.{u} X] →
      {n M : ℕ} →
        PMF.{u} (Fin n → X) →
          ((Fin n → X) → PMF.{v} (Fin n → Y)) → Fin M → PMF.{max v u} (Prod.{u, v} (Fin M → Fin n → X) (Fin n → Y))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.codebookOutputLaw_map_sentOutput</code></summary>

Under the whole book/output experiment, the sent word and output have the joint law induced by `q` and `K`.

**C29.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.RandomCodebook`. [Definition](../../LeanInfoTheory/Shannon/RandomCodebook.lean#L58) · [Approved step](../../docs/plans/release-3-chunk-29.md#L64) · [Handoff](../../docs/handoffs/chunk-29.md#L120)

**Source and limits.** PW24 §18.2, proof of Thm 18.5, pp. 354–355; CT91 §8.7, proof of Thm 8.7.1, pp. 199–201. Sample iid whole words with arbitrary word law q, then sample output from the actual sent word. No coordinate-iid premise is imposed on q.

**Consumer.** direct source reference in the listed permanent caller(s). [RandomCodebook L36](../../LeanInfoTheory/Examples/RandomCodebook.lean#L36)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `q`, `K`, `m`.

```lean
theorem LeanInfoTheory.Shannon.codebookOutputLaw_map_sentOutput.{u, v} : ∀ {X : Type u} {Y : Type v}
  [inst : Fintype.{u} X] {n M : ℕ} (q : PMF.{u} (Fin n → X)) (K : (Fin n → X) → PMF.{v} (Fin n → Y)) (m : Fin M),
  Eq.{max (u + 1) (v + 1)}
    (PMF.map.{max u v, max v u} (fun z => Prod.mk.{u, v} (z.1 m) z.2)
      (LeanInfoTheory.Shannon.codebookOutputLaw.{u, v} q K m))
    (PMF.channelJoint.{u, v} q K)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.codebookOutputLaw_map_competingOutput</code></summary>

Under the whole book/output experiment, the word at another message index and the output have the independent product of `q` and the output marginal.

**C29.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.RandomCodebook`. [Definition](../../LeanInfoTheory/Shannon/RandomCodebook.lean#L82) · [Approved step](../../docs/plans/release-3-chunk-29.md#L69) · [Handoff](../../docs/handoffs/chunk-29.md#L120)

**Source and limits.** PW24 §18.2, proof of Thm 18.5, step (a), pp. 354–355. A distinct index gives an independent competitor and the same output after averaging over the random book. Collisions are possible, and this law need not hold conditional on a fixed book.

**Consumer.** direct source reference in the listed permanent caller(s). [RandomCodebook L44](../../LeanInfoTheory/Examples/RandomCodebook.lean#L44)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `q`, `K`, `m`, `j`, `hjm`.

```lean
theorem LeanInfoTheory.Shannon.codebookOutputLaw_map_competingOutput.{u, v} : ∀ {X : Type u} {Y : Type v}
  [inst : Fintype.{u} X] {n M : ℕ} (q : PMF.{u} (Fin n → X)) (K : (Fin n → X) → PMF.{v} (Fin n → Y)) (m j : Fin M),
  Ne.{1} j m →
    Eq.{max (u + 1) (v + 1)}
      (PMF.map.{max u v, max v u} (fun z => Prod.mk.{u, v} (z.1 j) z.2)
        (LeanInfoTheory.Shannon.codebookOutputLaw.{u, v} q K m))
      (LeanInfoTheory.Shannon.indepProd.{u, v} q (PMF.bind.{u, v} q K))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.ofAcceptanceEvent</code></summary>

Use the given book as encoder and return the least message index whose word/output pair lies in `A`, or index zero when no index passes. The decoder is total on every output and permits equal words at different indices.

**C29.03** · new definition/representation. Import `LeanInfoTheory.Shannon.RandomCodebook`. [Definition](../../LeanInfoTheory/Shannon/RandomCodebook.lean#L98) · [Approved step](../../docs/plans/release-3-chunk-29.md#L75) · [Handoff](../../docs/handoffs/chunk-29.md#L120)

**Source and limits.** PW24 §18.2, (18.10), p. 354; §18.3, proof of Thm 18.6, p. 356. Define a total first-pass decoder using an arbitrary acceptance event at fixed n,M and fallback index zero. Distinct labels may have equal words. A unique passing label is decoded correctly.

**Consumer.** direct source reference in the listed permanent caller(s). [RandomCodebook L137](../../LeanInfoTheory/Examples/RandomCodebook.lean#L137) · [ChannelCodingOneShot L33](../../LeanInfoTheory/Examples/ChannelCodingOneShot.lean#L33) · [ChannelCodingOneShotBinary L115](../../LeanInfoTheory/Examples/ChannelCodingOneShotBinary.lean#L115) · [ChannelCodingOneShotTernary L143](../../LeanInfoTheory/Examples/ChannelCodingOneShotTernary.lean#L143) · [ChannelCodingOneShotSparse L46](../../LeanInfoTheory/Examples/ChannelCodingOneShotSparse.lean#L46) · [ChannelCodingOneShotFinite L39](../../LeanInfoTheory/Examples/ChannelCodingOneShotFinite.lean#L39)

**Binder order.** `{X}`, `{Y}`, `{n}`, `{M}`, `b`, `A`, `hM`.

```lean
def LeanInfoTheory.Shannon.BlockChannelCode.ofAcceptanceEvent.{u, v} : {X : Type u} →
  {Y : Type v} →
    {n M : ℕ} →
      (Fin M → Fin n → X) →
        Set.{max v u} (Prod.{u, v} (Fin n → X) (Fin n → Y)) →
          LE.le.{0} 1 M → LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.decoder_ofAcceptanceEvent_eq_of_unique</code></summary>

If the sent message index passes and every other message index fails, the acceptance-event decoder returns the sent index.

**C29.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.RandomCodebook`. [Definition](../../LeanInfoTheory/Shannon/RandomCodebook.lean#L108) · [Approved step](../../docs/plans/release-3-chunk-29.md#L75) · [Handoff](../../docs/handoffs/chunk-29.md#L120)

**Source and limits.** PW24 §18.2, (18.10), p. 354; §18.3, proof of Thm 18.6, p. 356. Define a total first-pass decoder using an arbitrary acceptance event at fixed n,M and fallback index zero. Distinct labels may have equal words. A unique passing label is decoded correctly.

**Consumer.** direct source reference in the listed permanent caller(s). [RandomCodebook L145](../../LeanInfoTheory/Examples/RandomCodebook.lean#L145)

**Binder order.** `{X}`, `{Y}`, `{n}`, `{M}`, `b`, `A`, `hM`, `m`, `y`, `hm`, `hother`.

```lean
theorem LeanInfoTheory.Shannon.BlockChannelCode.decoder_ofAcceptanceEvent_eq_of_unique.{u, v} : ∀ {X : Type u}
  {Y : Type v} {n M : ℕ} (b : Fin M → Fin n → X) (A : Set.{max v u} (Prod.{u, v} (Fin n → X) (Fin n → Y)))
  (hM : LE.le.{0} 1 M) (m : Fin M) (y : Fin n → Y),
  Membership.mem.{max v u, max u v} A (Prod.mk.{u, v} (b m) y) →
    (∀ (j : Fin M), Ne.{1} j m → Prod.mk.{u, v} (b j) y ∉ A) →
      Eq.{1}
        (LeanInfoTheory.Shannon.BlockChannelCode.decoder.{u, v}
          (LeanInfoTheory.Shannon.BlockChannelCode.ofAcceptanceEvent.{u, v} b A hM) y)
        m
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.mean_codebookOutputLaw_error_eq_mean_errorProbability</code></summary>

Uniformly averaging the actual decoder-error event over the transmitted message index equals the book-weighted mean of the realized code's released error probability, at the original blocklength and message count. The word law `q` is arbitrary. The codewords at distinct message indices are sampled independently.

**C29.04** · new mathematical theorem. Import `LeanInfoTheory.Shannon.RandomCodebook`. [Definition](../../LeanInfoTheory/Shannon/RandomCodebook.lean#L128) · [Approved step](../../docs/plans/release-3-chunk-29.md#L80) · [Handoff](../../docs/handoffs/chunk-29.md#L120)

**Source and limits.** CT91 §8.5, (8.28)–(8.32), pp. 193–194; §8.7, proof of Thm 8.7.1, pp. 199–201; PW24 §18.2, Thm 18.5. The same sampled book determines the sent input and decoder. Average over every message and then books to recover expected released uniform error.

**Consumer.** direct source reference in the listed permanent caller(s). [RandomCodebook L323](../../LeanInfoTheory/Examples/RandomCodebook.lean#L323) · [ChannelCodingOneShot L182](../../LeanInfoTheory/Examples/ChannelCodingOneShot.lean#L182)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `[instance]`, `{n}`, `{M}`, `q`, `W`, `A`, `hM`.

```lean
theorem LeanInfoTheory.Shannon.mean_codebookOutputLaw_error_eq_mean_errorProbability.{u, v} : ∀ {X : Type u}
  {Y : Type v} [inst : Fintype.{u} X] [inst_1 : Fintype.{v} Y] {n M : ℕ} (q : PMF.{u} (Fin n → X)) (W : X → PMF.{v} Y)
  (A : Set.{max v u} (Prod.{u, v} (Fin n → X) (Fin n → Y))) (hM : LE.le.{0} 1 M),
  Eq.{1}
    (HMul.hMul.{0, 0, 0} (HDiv.hDiv.{0, 0, 0} 1 ↑M)
      (∑ m,
        ((PMF.toOuterMeasure.{max u v}
              (LeanInfoTheory.Shannon.codebookOutputLaw.{u, v} q (PMF.memorylessChannel.{u, v} W n) m))
            (Set.ofPred.{max u v} fun z =>
              Ne.{1}
                (LeanInfoTheory.Shannon.BlockChannelCode.decoder.{u, v}
                  (LeanInfoTheory.Shannon.BlockChannelCode.ofAcceptanceEvent.{u, v} z.1 A hM) z.2)
                m)).toReal))
    (∑ b,
      HMul.hMul.{0, 0, 0} ((PMF.iid.{u} q M) b).toReal
        (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v}
          (LeanInfoTheory.Shannon.BlockChannelCode.ofAcceptanceEvent.{u, v} b A hM) W hM))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.mean_codebookOutputLaw_error_le</code></summary>

Expected uniform-message decoder error is at most the sent-pair miss plus `M - 1` independent-pair passes. The whole input-word law and raw block channel are arbitrary. Competing events sharing the output may be dependent.

**C30.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodingOneShot`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodingOneShot.lean#L120) · [Approved step](../../docs/plans/release-3-chunk-30.md#L48) · [Handoff](../../docs/handoffs/chunk-30.md#L143)

**Source and limits.** PW24 §18.2, Thm 18.5, pp. 354–355; §18.3 Thm 18.6 proof, p. 356. For an arbitrary finite whole-word law, raw channel, and event, bound the average over the full message budget by a true miss plus M−1 independent false matches.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodingOneShot L42](../../LeanInfoTheory/Examples/ChannelCodingOneShot.lean#L42)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `q`, `K`, `A`, `hM`.

```lean
theorem LeanInfoTheory.Shannon.mean_codebookOutputLaw_error_le.{u, v} : ∀ {X : Type u} {Y : Type v}
  [inst : Fintype.{u} X] {n M : ℕ} (q : PMF.{u} (Fin n → X)) (K : (Fin n → X) → PMF.{v} (Fin n → Y))
  (A : Set.{max v u} (Prod.{u, v} (Fin n → X) (Fin n → Y))) (hM : LE.le.{0} 1 M),
  LE.le.{0}
    (HMul.hMul.{0, 0, 0} (HDiv.hDiv.{0, 0, 0} 1 ↑M)
      (∑ m,
        ((PMF.toOuterMeasure.{max u v} (LeanInfoTheory.Shannon.codebookOutputLaw.{u, v} q K m))
            (Set.ofPred.{max u v} fun z =>
              Ne.{1}
                (LeanInfoTheory.Shannon.BlockChannelCode.decoder.{u, v}
                  (LeanInfoTheory.Shannon.BlockChannelCode.ofAcceptanceEvent.{u, v} z.1 A hM) z.2)
                m)).toReal))
    (HAdd.hAdd.{0, 0, 0} ((PMF.toOuterMeasure.{max u v} (PMF.channelJoint.{u, v} q K)) (compl.{max u v} A)).toReal
      (HMul.hMul.{0, 0, 0} (HSub.hSub.{0, 0, 0} (↑M) 1)
        ((PMF.toOuterMeasure.{max u v} (LeanInfoTheory.Shannon.indepProd.{u, v} q (PMF.bind.{u, v} q K))) A).toReal))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.exists_mem_support_codebook_error_le</code></summary>

Some book in the actual iid sampling support has uniform row error at most the sent-pair miss plus `M - 1` competing passes. The word law and raw block rows are arbitrary, including dependence between letters within each word.

**C30.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodingOneShot`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodingOneShot.lean#L192) · [Approved step](../../docs/plans/release-3-chunk-30.md#L56) · [Handoff](../../docs/handoffs/chunk-30.md#L143)

**Source and limits.** PW24 §18.2, proof of Thm 18.5, p. 355; CT91 §8.7, proof of Thm 8.7.1, pp. 199–202. Select a deterministic realization within actual positive-mass book support, at the given n,M and raw word channel. Preserve all labels.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodingOneShot L154](../../LeanInfoTheory/Examples/ChannelCodingOneShot.lean#L154) · [ChannelCodingOneShotSparse L90](../../LeanInfoTheory/Examples/ChannelCodingOneShotSparse.lean#L90)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `q`, `K`, `A`, `hM`.

```lean
theorem LeanInfoTheory.Shannon.exists_mem_support_codebook_error_le.{u, v} : ∀ {X : Type u} {Y : Type v}
  [inst : Fintype.{u} X] {n M : ℕ} (q : PMF.{u} (Fin n → X)) (K : (Fin n → X) → PMF.{v} (Fin n → Y))
  (A : Set.{max v u} (Prod.{u, v} (Fin n → X) (Fin n → Y))) (hM : LE.le.{0} 1 M),
  ∃ b,
    Membership.mem.{u, u} (PMF.support.{u} (PMF.iid.{u} q M)) b ∧
      LE.le.{0}
        (HMul.hMul.{0, 0, 0} (HDiv.hDiv.{0, 0, 0} 1 ↑M)
          (∑ m,
            ((PMF.toOuterMeasure.{v} (K (b m)))
                (Set.ofPred.{v} fun y =>
                  Ne.{1}
                    (LeanInfoTheory.Shannon.BlockChannelCode.decoder.{u, v}
                      (LeanInfoTheory.Shannon.BlockChannelCode.ofAcceptanceEvent.{u, v} b A hM) y)
                    m)).toReal))
        (HAdd.hAdd.{0, 0, 0} ((PMF.toOuterMeasure.{max u v} (PMF.channelJoint.{u, v} q K)) (compl.{max u v} A)).toReal
          (HMul.hMul.{0, 0, 0} (HSub.hSub.{0, 0, 0} (↑M) 1)
            ((PMF.toOuterMeasure.{max u v} (LeanInfoTheory.Shannon.indepProd.{u, v} q (PMF.bind.{u, v} q K)))
                A).toReal))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.exists_blockChannelCode_errorProbability_le_of_acceptanceEvent</code></summary>

Some deterministic code at the supplied `n` and `M` uses a book in the actual sampling support and the acceptance-event decoder. Its released average error is at most the sent miss plus `M - 1` competing passes. The word law need not be iid and need not equal the input law induced by the selected encoder.

**C30.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodingOneShot`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodingOneShot.lean#L239) · [Approved step](../../docs/plans/release-3-chunk-30.md#L63) · [Handoff](../../docs/handoffs/chunk-30.md#L143)

**Source and limits.** PW24 §18.1 Cor 18.4 and §18.2 Thm 18.5, pp. 353–355; CT91 §8.5, (8.28)–(8.32). Use the released uniform error at W of the selected book and its total decoder. The event form retains Q(E); the strict-threshold form gives exp(−t). Both retain n, positive M and arbitrary word q.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodingOneShotBinary L118](../../LeanInfoTheory/Examples/ChannelCodingOneShotBinary.lean#L118) · [ChannelCodingOneShot L170](../../LeanInfoTheory/Examples/ChannelCodingOneShot.lean#L170) · [ChannelCodingOneShotTernary L146](../../LeanInfoTheory/Examples/ChannelCodingOneShotTernary.lean#L146)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `[instance]`, `{n}`, `{M}`, `q`, `W`, `A`, `hM`.

```lean
theorem LeanInfoTheory.Shannon.exists_blockChannelCode_errorProbability_le_of_acceptanceEvent.{u, v} : ∀ {X : Type u}
  {Y : Type v} [inst : Fintype.{u} X] [inst_1 : Fintype.{v} Y] {n M : ℕ} (q : PMF.{u} (Fin n → X)) (W : X → PMF.{v} Y)
  (A : Set.{max v u} (Prod.{u, v} (Fin n → X) (Fin n → Y))) (hM : LE.le.{0} 1 M),
  ∃ c,
    Membership.mem.{u, u} (PMF.support.{u} (PMF.iid.{u} q M))
        (LeanInfoTheory.Shannon.BlockChannelCode.encoder.{u, v} c) ∧
      Eq.{max (u + 1) (v + 1)} c
          (LeanInfoTheory.Shannon.BlockChannelCode.ofAcceptanceEvent.{u, v}
            (LeanInfoTheory.Shannon.BlockChannelCode.encoder.{u, v} c) A hM) ∧
        LE.le.{0} (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} c W hM)
          (HAdd.hAdd.{0, 0, 0}
            ((PMF.toOuterMeasure.{max u v} (PMF.channelJoint.{u, v} q (PMF.memorylessChannel.{u, v} W n)))
                (compl.{max u v} A)).toReal
            (HMul.hMul.{0, 0, 0} (HSub.hSub.{0, 0, 0} (↑M) 1)
              ((PMF.toOuterMeasure.{max u v}
                    (LeanInfoTheory.Shannon.indepProd.{u, v} q (PMF.bind.{u, v} q (PMF.memorylessChannel.{u, v} W n))))
                  A).toReal))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold</code></summary>

For every real threshold there is a supported deterministic code at the supplied `n` and `M` with released error at most the literal strict-test miss plus `(M - 1) * exp (-t)`. Threshold ties count as misses.

**C30.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodingOneShot`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodingOneShot.lean#L258) · [Approved step](../../docs/plans/release-3-chunk-30.md#L63) · [Handoff](../../docs/handoffs/chunk-30.md#L143)

**Source and limits.** PW24 §18.1 Cor 18.4 and §18.2 Thm 18.5, pp. 353–355; CT91 §8.5, (8.28)–(8.32). Use the released uniform error at W of the selected book and its total decoder. The event form retains Q(E); the strict-threshold form gives exp(−t). Both retain n, positive M and arbitrary word q.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodingOneShotBinary L130](../../LeanInfoTheory/Examples/ChannelCodingOneShotBinary.lean#L130) · [ChannelCodingOneShot L190](../../LeanInfoTheory/Examples/ChannelCodingOneShot.lean#L190) · [ChannelCodingOneShotTernary L159](../../LeanInfoTheory/Examples/ChannelCodingOneShotTernary.lean#L159) · [ChannelCodingOneShotFinite L45](../../LeanInfoTheory/Examples/ChannelCodingOneShotFinite.lean#L45)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `[instance]`, `{n}`, `{M}`, `q`, `W`, `t`, `hM`.

```lean
theorem LeanInfoTheory.Shannon.exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold.{u, v} : ∀
  {X : Type u} {Y : Type v} [inst : Fintype.{u} X] [inst_1 : Fintype.{v} Y] {n M : ℕ} (q : PMF.{u} (Fin n → X))
  (W : X → PMF.{v} Y) (t : ℝ) (hM : LE.le.{0} 1 M),
  ∃ c,
    Membership.mem.{u, u} (PMF.support.{u} (PMF.iid.{u} q M))
        (LeanInfoTheory.Shannon.BlockChannelCode.encoder.{u, v} c) ∧
      Eq.{max (u + 1) (v + 1)} c
          (LeanInfoTheory.Shannon.BlockChannelCode.ofAcceptanceEvent.{u, v}
            (LeanInfoTheory.Shannon.BlockChannelCode.encoder.{u, v} c)
            (LeanInfoTheory.Shannon.infoDensityThresholdEvent.{u, v} q (PMF.memorylessChannel.{u, v} W n) t) hM) ∧
        LE.le.{0} (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} c W hM)
          (HAdd.hAdd.{0, 0, 0}
            ((PMF.toOuterMeasure.{max u v} (PMF.channelJoint.{u, v} q (PMF.memorylessChannel.{u, v} W n)))
                (compl.{max u v}
                  (LeanInfoTheory.Shannon.infoDensityThresholdEvent.{u, v} q (PMF.memorylessChannel.{u, v} W n)
                    t))).toReal
            (HMul.hMul.{0, 0, 0} (HSub.hSub.{0, 0, 0} (↑M) 1) (Real.exp (Neg.neg.{0} t))))
```

</details>

### Reused release declarations

| Qualified name and focused import | Caller |
| --- | --- |
| [PMF.channelJoint](../../LeanInfoTheory/Probability/FiniteChannel.lean#L64) · `LeanInfoTheory.Probability.FiniteChannel` | [ChannelCodingOneShot L74](../../LeanInfoTheory/Shannon/ChannelCodingOneShot.lean#L74) |
| [LeanInfoTheory.Shannon.indepProd](../../LeanInfoTheory/Shannon/SemanticBridge/Product.lean#L44) · `LeanInfoTheory.Shannon.SemanticBridge.Product` | [ChannelCodingOneShot L75](../../LeanInfoTheory/Shannon/ChannelCodingOneShot.lean#L75) |
| [PMF.finiteProduct_channelJoint_map](../../LeanInfoTheory/Probability/ProductChannel.lean#L163) · `LeanInfoTheory.Probability.ProductChannel` | [IidInformationDensity L75](../../LeanInfoTheory/Shannon/IidInformationDensity.lean#L75) |
| [PMF.finiteProduct_bind_productChannel](../../LeanInfoTheory/Probability/ProductChannel.lean#L91) · `LeanInfoTheory.Probability.ProductChannel` | [IidInformationDensity L85](../../LeanInfoTheory/Shannon/IidInformationDensity.lean#L85) |
| [LeanInfoTheory.Shannon.tendsto_selfInfo_iid_deviation](../../LeanInfoTheory/Shannon/SemanticBridge/AEP.lean#L218) · `LeanInfoTheory.Shannon.SemanticBridge.AEP` | [IidInformationDensity L194](../../LeanInfoTheory/Shannon/IidInformationDensity.lean#L194) |
| [LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_eq_sum](../../LeanInfoTheory/Shannon/ChannelCode.lean#L165) · `LeanInfoTheory.Shannon.ChannelCode` | [ChannelCodingOneShot L219](../../LeanInfoTheory/Shannon/ChannelCodingOneShot.lean#L219) |

<details><summary>Compiled signatures of the reused declarations</summary>

```lean
def PMF.channelJoint.{u, v} : {alpha : Type u} →
  {beta : Type v} → PMF.{u} alpha → (alpha → PMF.{v} beta) → PMF.{max v u} (Prod.{u, v} alpha beta)
def LeanInfoTheory.Shannon.indepProd.{u, v} : {alpha : Type u} →
  {beta : Type v} → PMF.{u} alpha → PMF.{v} beta → PMF.{max v u} (Prod.{u, v} alpha beta)
theorem PMF.finiteProduct_channelJoint_map.{u, v, w} : ∀ {I : Type u} {A : I → Type v} {B : I → Type w}
  [inst : Fintype.{u} I] [inst_1 : (i : I) → Fintype.{w} (B i)] [inst_2 : (i : I) → Fintype.{v} (A i)]
  (p : (i : I) → PMF.{v} (A i)) (W : (i : I) → A i → PMF.{w} (B i)),
  Eq.{max (max (u + 1) (v + 1)) (w + 1)}
    (PMF.map.{max (max u v) w, max (max u v) w} (⇑(Equiv.arrowProdEquivProdArrow.{u, v, w} I A B))
      (PMF.finiteProduct.{u, max w v} fun i => PMF.channelJoint.{v, w} (p i) (W i)))
    (PMF.channelJoint.{max v u, max u w} (PMF.finiteProduct.{u, v} p) (PMF.productChannel.{u, v, w} W))
theorem PMF.finiteProduct_bind_productChannel.{u, v, w} : ∀ {I : Type u} {A : I → Type v} {B : I → Type w}
  [inst : Fintype.{u} I] [inst_1 : (i : I) → Fintype.{w} (B i)] [inst_2 : (i : I) → Fintype.{v} (A i)]
  (p : (i : I) → PMF.{v} (A i)) (W : (i : I) → A i → PMF.{w} (B i)),
  Eq.{max (u + 1) (w + 1)} (PMF.bind.{max u v, max u w} (PMF.finiteProduct.{u, v} p) (PMF.productChannel.{u, v, w} W))
    (PMF.finiteProduct.{u, w} fun i => PMF.bind.{v, w} (p i) (W i))
theorem LeanInfoTheory.Shannon.tendsto_selfInfo_iid_deviation.{u} : ∀ {A : Type u} [inst : Fintype.{u} A]
  (p : PMF.{u} A) {ε : ℝ},
  LT.lt.{0} 0 ε →
    Filter.Tendsto.{0, 0}
      (fun n =>
        ((PMF.toOuterMeasure.{u} (PMF.iid.{u} p n))
            (Set.ofPred.{u} fun x =>
              LE.le.{0} ε
                (abs.{0}
                  (HSub.hSub.{0, 0, 0}
                    (HDiv.hDiv.{0, 0, 0} (LeanInfoTheory.Shannon.selfInfo.{u} (PMF.iid.{u} p n) x) ↑n)
                    (LeanInfoTheory.entropy.{u} p))))).toReal)
      Filter.atTop.{0} (nhds.{0} 0)
theorem LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_eq_sum.{u, v} : ∀ {A : Type u} {B : Type v} {n M : ℕ}
  [inst : Fintype.{v} B] (c : LeanInfoTheory.Shannon.BlockChannelCode.{u, v} A B n M) (W : A → PMF.{v} B)
  (hM : LE.le.{0} 1 M),
  Eq.{1} (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} c W hM)
    (HMul.hMul.{0, 0, 0} (HDiv.hDiv.{0, 0, 0} 1 ↑M)
      (∑ m,
        ∑ y,
          ite.{1} (Ne.{1} (LeanInfoTheory.Shannon.BlockChannelCode.decoder.{u, v} c y) m)
            ((PMF.memorylessChannel.{u, v} W n (LeanInfoTheory.Shannon.BlockChannelCode.encoder.{u, v} c m)) y).toReal
            0))
```

</details>

### Private and example results

- A fixed rounded budget and the identical literal threshold produce the finite bound used in the rate argument. [ChannelCodingOneShotFinite L36](../../LeanInfoTheory/Examples/ChannelCodingOneShotFinite.lean#L36)

<a id="package-3"></a>

## Operational capacity and expurgation

- C31 records. [Approved plan](../../docs/plans/release-3-chunk-31.md) · [Endpoint handoff](../../docs/handoffs/chunk-31.md)
- C32 records. [Approved plan](../../docs/plans/release-3-chunk-32.md) · [Endpoint handoff](../../docs/handoffs/chunk-32.md)

Permanent examples. [OperationalCapacity](../../LeanInfoTheory/Examples/OperationalCapacity.lean) · [ChannelCodeExpurgation](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean) · [OperationalExpurgation](../../LeanInfoTheory/Examples/OperationalExpurgation.lean) · [ChannelCodingAsymptotic](../../LeanInfoTheory/Examples/ChannelCodingAsymptotic.lean)

<details>
<summary><code>LeanInfoTheory.Shannon.IsAchievableRate</code></summary>

A nonnegative rate attained from below, up to every positive tolerance, by one deterministic block-code family with positive message counts and vanishing uniform-message average error. The same family is used at every tolerance.

**C31.01** · new definition/representation. Import `LeanInfoTheory.Shannon.OperationalCapacity`. [Definition](../../LeanInfoTheory/Shannon/OperationalCapacity.lean#L42) · [Approved step](../../docs/plans/release-3-chunk-31.md#L48) · [Handoff](../../docs/handoffs/chunk-31.md#L125)

**Source and limits.** PW24 §19.1 Defs 19.2–19.3, p. 373; CT91 §8.5 and §8.7 Thm 8.7.1. One all-length positive-budget family precedes all positive tolerances. Use uniform average error. Zero via the one-message family also covers zero capacity and length zero.

**Consumer.** direct source reference in the listed permanent caller(s). [OperationalCapacity L33](../../LeanInfoTheory/Examples/OperationalCapacity.lean#L33) · [OperationalExpurgation L30](../../LeanInfoTheory/Examples/OperationalExpurgation.lean#L30) · [ChannelCodingAsymptotic L230](../../LeanInfoTheory/Examples/ChannelCodingAsymptotic.lean#L230)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `W`, `R`.

```lean
def LeanInfoTheory.Shannon.IsAchievableRate.{u, v} : {X : Type u} →
  {Y : Type v} → [Fintype.{v} Y] → (X → PMF.{v} Y) → ℝ → Prop
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.isAchievableRate_zero</code></summary>

The one-message family achieves rate zero at every channel on a nonempty input alphabet. Its rate and error are zero at every length, including zero.

**C31.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.OperationalCapacity`. [Definition](../../LeanInfoTheory/Shannon/OperationalCapacity.lean#L52) · [Approved step](../../docs/plans/release-3-chunk-31.md#L48) · [Handoff](../../docs/handoffs/chunk-31.md#L125)

**Source and limits.** PW24 §19.1 Defs 19.2–19.3, p. 373; CT91 §8.5 and §8.7 Thm 8.7.1. One all-length positive-budget family precedes all positive tolerances. Use uniform average error. Zero via the one-message family also covers zero capacity and length zero.

**Consumer.** direct source reference in the listed permanent caller(s). [OperationalCapacity L44](../../LeanInfoTheory/Examples/OperationalCapacity.lean#L44)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `[instance]`, `W`.

```lean
theorem LeanInfoTheory.Shannon.isAchievableRate_zero.{u, v} : ∀ {X : Type u} {Y : Type v} [Nonempty.{u + 1} X]
  [inst : Fintype.{v} Y] (W : X → PMF.{v} Y), LeanInfoTheory.Shannon.IsAchievableRate.{u, v} W 0
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.isAchievableRate_of_lt_channelCapacity</code></summary>

Every nonnegative rate strictly below information capacity is achievable. One input law, threshold slope and family at the rounded budgets are fixed before any rate tolerance. The released average error tends to zero.

**C31.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.OperationalCapacity`. [Definition](../../LeanInfoTheory/Shannon/OperationalCapacity.lean#L66) · [Approved step](../../docs/plans/release-3-chunk-31.md#L54) · [Handoff](../../docs/handoffs/chunk-31.md#L125)

**Source and limits.** PW24 §19.2 Thm 19.8, (19.7), p. 376; CT91 §8.7 Thm 8.7.1, pp. 198–202. For 0≤R<C fix one p and R<s<I. Combine the same n*s miss with the rounded-budget one-shot bound. Gives one vanishing-error family for all tolerances.

**Consumer.** direct source reference in the listed permanent caller(s). [OperationalCapacity L55](../../LeanInfoTheory/Examples/OperationalCapacity.lean#L55)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `[instance]`, `[instance]`, `W`, `{R}`, `hR`, `hlt`.

```lean
theorem LeanInfoTheory.Shannon.isAchievableRate_of_lt_channelCapacity.{u, v} : ∀ {X : Type u} {Y : Type v}
  [inst : Fintype.{u} X] [inst_1 : Nonempty.{u + 1} X] [inst_2 : Fintype.{v} Y] (W : X → PMF.{v} Y) {R : ℝ},
  LE.le.{0} 0 R →
    LT.lt.{0} R (LeanInfoTheory.Shannon.channelCapacity.{u, v} W) → LeanInfoTheory.Shannon.IsAchievableRate.{u, v} W R
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.le_channelCapacity_of_isAchievableRate</code></summary>

Every achievable rate is bounded by information capacity. C23's tolerance converse applies to the same arbitrary family witnessing achievability.

**C31.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.OperationalCapacity`. [Definition](../../LeanInfoTheory/Shannon/OperationalCapacity.lean#L116) · [Approved step](../../docs/plans/release-3-chunk-31.md#L60) · [Handoff](../../docs/handoffs/chunk-31.md#L125)

**Source and limits.** PW24 §19.2 Thm 19.7, pp. 375–376; CT91 §8.7 Thm 8.7.1. Apply the earlier tolerance converse to the same arbitrary family. The supremum describes achievable rates without claiming a capacity-achieving family.

**Consumer.** direct source reference in the listed permanent caller(s). [OperationalCapacity L64](../../LeanInfoTheory/Examples/OperationalCapacity.lean#L64)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `[instance]`, `[instance]`, `W`, `{R}`, `h`.

```lean
theorem LeanInfoTheory.Shannon.le_channelCapacity_of_isAchievableRate.{u, v} : ∀ {X : Type u} {Y : Type v}
  [inst : Fintype.{u} X] [inst_1 : Nonempty.{u + 1} X] [inst_2 : Fintype.{v} Y] (W : X → PMF.{v} Y) {R : ℝ},
  LeanInfoTheory.Shannon.IsAchievableRate.{u, v} W R → LE.le.{0} R (LeanInfoTheory.Shannon.channelCapacity.{u, v} W)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.isLUB_isAchievableRate</code></summary>

Information capacity is the least upper bound of achievable rates. The zero-rate witness gives leastness also when capacity is zero.

**C31.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.OperationalCapacity`. [Definition](../../LeanInfoTheory/Shannon/OperationalCapacity.lean#L135) · [Approved step](../../docs/plans/release-3-chunk-31.md#L60) · [Handoff](../../docs/handoffs/chunk-31.md#L125)

**Source and limits.** PW24 §19.2 Thm 19.7, pp. 375–376; CT91 §8.7 Thm 8.7.1. Apply the earlier tolerance converse to the same arbitrary family. The supremum describes achievable rates without claiming a capacity-achieving family.

**Consumer.** direct source reference in the listed permanent caller(s). [OperationalCapacity L70](../../LeanInfoTheory/Examples/OperationalCapacity.lean#L70)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `[instance]`, `[instance]`, `W`.

```lean
theorem LeanInfoTheory.Shannon.isLUB_isAchievableRate.{u, v} : ∀ {X : Type u} {Y : Type v} [inst : Fintype.{u} X]
  [inst_1 : Nonempty.{u + 1} X] [inst_2 : Fintype.{v} Y] (W : X → PMF.{v} Y),
  IsLUB.{0} (Set.ofPred.{0} fun R => LeanInfoTheory.Shannon.IsAchievableRate.{u, v} W R)
    (LeanInfoTheory.Shannon.channelCapacity.{u, v} W)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior</code></summary>

Decoding error for the joint law obtained by sampling an index from the supplied prior and then sampling its channel output.

**C32.01** · new definition/representation. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L53) · [Approved step](../../docs/plans/release-3-chunk-32.md#L27) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.5, (8.28)–(8.32), pp. 193–194; PW24 §17.1 Defs 17.1–17.2, pp. 342–343. Keep the released uniform error and total decoder. Evaluate row error at one sent label, aggregate under any prescribed PMF, and maximize over a positive budget; a nonuniform prior can have larger error.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L41](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L41) · [OperationalExpurgation L51](../../LeanInfoTheory/Examples/OperationalExpurgation.lean#L51)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `c`, `W`, `π`.

```lean
def LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior.{u, v} : {X : Type u} →
  {Y : Type v} →
    [Fintype.{v} Y] →
      {n M : ℕ} → LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M → (X → PMF.{v} Y) → PMF.{0} (Fin M) → ℝ
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior_eq_sum</code></summary>

Weighting each row error by the mass of its sent index gives the actual decoding error under the supplied prior.

**C32.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L60) · [Approved step](../../docs/plans/release-3-chunk-32.md#L27) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.5, (8.28)–(8.32), pp. 193–194; PW24 §17.1 Defs 17.1–17.2, pp. 342–343. Keep the released uniform error and total decoder. Evaluate row error at one sent label, aggregate under any prescribed PMF, and maximize over a positive budget; a nonuniform prior can have larger error.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L148](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L148)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `c`, `W`, `π`.

```lean
theorem LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior_eq_sum.{u, v} : ∀ {X : Type u} {Y : Type v}
  [inst : Fintype.{v} Y] {n M : ℕ} (c : LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M) (W : X → PMF.{v} Y)
  (π : PMF.{0} (Fin M)),
  Eq.{1} (LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior.{u, v} c W π)
    (∑ m,
      HMul.hMul.{0, 0, 0} (π m).toReal (LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability.{u, v} c W m))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior_le_maximalErrorProbability</code></summary>

The maximum controls the error of the same code under every message prior.

**C32.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L102) · [Approved step](../../docs/plans/release-3-chunk-32.md#L27) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.5, (8.28)–(8.32), pp. 193–194; PW24 §17.1 Defs 17.1–17.2, pp. 342–343. Keep the released uniform error and total decoder. Evaluate row error at one sent label, aggregate under any prescribed PMF, and maximize over a positive budget; a nonuniform prior can have larger error.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L42](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L42) · [OperationalExpurgation L76](../../LeanInfoTheory/Examples/OperationalExpurgation.lean#L76)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `c`, `W`, `π`, `hM`.

```lean
theorem LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior_le_maximalErrorProbability.{u, v} : ∀
  {X : Type u} {Y : Type v} [inst : Fintype.{v} Y] {n M : ℕ}
  (c : LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M) (W : X → PMF.{v} Y) (π : PMF.{0} (Fin M))
  (hM : LE.le.{0} 1 M),
  LE.le.{0} (LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior.{u, v} c W π)
    (LeanInfoTheory.Shannon.BlockChannelCode.maximalErrorProbability.{u, v} c W hM)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior_pure</code></summary>

A point-mass prior selects the error of that message index.

**C32.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L81) · [Approved step](../../docs/plans/release-3-chunk-32.md#L27) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.5, (8.28)–(8.32), pp. 193–194; PW24 §17.1 Defs 17.1–17.2, pp. 342–343. Keep the released uniform error and total decoder. Evaluate row error at one sent label, aggregate under any prescribed PMF, and maximize over a positive budget; a nonuniform prior can have larger error.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L47](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L47)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `c`, `W`, `m`.

```lean
theorem LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior_pure.{u, v} : ∀ {X : Type u} {Y : Type v}
  [inst : Fintype.{v} Y] {n M : ℕ} (c : LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M) (W : X → PMF.{v} Y)
  (m : Fin M),
  Eq.{1} (LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior.{u, v} c W (PMF.pure.{0} m))
    (LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability.{u, v} c W m)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior_uniformOfFintype</code></summary>

Sampling uniformly on the positive message budget gives the released uniform-message block error.

**C32.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L74) · [Approved step](../../docs/plans/release-3-chunk-32.md#L27) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.5, (8.28)–(8.32), pp. 193–194; PW24 §17.1 Defs 17.1–17.2, pp. 342–343. Keep the released uniform error and total decoder. Evaluate row error at one sent label, aggregate under any prescribed PMF, and maximize over a positive budget; a nonuniform prior can have larger error.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L67](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L67)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `c`, `W`, `hM`.

```lean
@[defeq] theorem LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior_uniformOfFintype.{u, v} : ∀
  {X : Type u} {Y : Type v} [inst : Fintype.{v} Y] {n M : ℕ}
  (c : LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M) (W : X → PMF.{v} Y) (hM : LE.le.{0} 1 M),
  Eq.{1}
    (LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior.{u, v} c W (PMF.uniformOfFintype.{0} (Fin M)))
    (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} c W hM)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_eq_mean_messageErrorProbability</code></summary>

Uniform block error is the arithmetic mean of the errors at the original message indices, including any indices with identical codewords.

**C32.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L46) · [Approved step](../../docs/plans/release-3-chunk-32.md#L27) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.5, (8.28)–(8.32), pp. 193–194; PW24 §17.1 Defs 17.1–17.2, pp. 342–343. Keep the released uniform error and total decoder. Evaluate row error at one sent label, aggregate under any prescribed PMF, and maximize over a positive budget; a nonuniform prior can have larger error.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L36](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L36)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `c`, `W`, `hM`.

```lean
theorem LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_eq_mean_messageErrorProbability.{u, v} : ∀ {X : Type u}
  {Y : Type v} [inst : Fintype.{v} Y] {n M : ℕ} (c : LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M)
  (W : X → PMF.{v} Y) (hM : LE.le.{0} 1 M),
  Eq.{1} (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} c W hM)
    (HMul.hMul.{0, 0, 0} (HDiv.hDiv.{0, 0, 0} 1 ↑M)
      (∑ m, LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability.{u, v} c W m))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.maximalErrorProbability</code></summary>

Largest sent-index error over a positive message budget.

**C32.01** · new definition/representation. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L88) · [Approved step](../../docs/plans/release-3-chunk-32.md#L27) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.5, (8.28)–(8.32), pp. 193–194; PW24 §17.1 Defs 17.1–17.2, pp. 342–343. Keep the released uniform error and total decoder. Evaluate row error at one sent label, aggregate under any prescribed PMF, and maximize over a positive budget; a nonuniform prior can have larger error.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L41](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L41) · [OperationalExpurgation L40](../../LeanInfoTheory/Examples/OperationalExpurgation.lean#L40)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `c`, `W`, `hM`.

```lean
def LeanInfoTheory.Shannon.BlockChannelCode.maximalErrorProbability.{u, v} : {X : Type u} →
  {Y : Type v} →
    [Fintype.{v} Y] →
      {n M : ℕ} → LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M → (X → PMF.{v} Y) → LE.le.{0} 1 M → ℝ
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.maximalErrorProbability_le_iff</code></summary>

Bounding the maximal error is equivalent to bounding every sent-index error by the same real number.

**C32.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L94) · [Approved step](../../docs/plans/release-3-chunk-32.md#L27) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.5, (8.28)–(8.32), pp. 193–194; PW24 §17.1 Defs 17.1–17.2, pp. 342–343. Keep the released uniform error and total decoder. Evaluate row error at one sent label, aggregate under any prescribed PMF, and maximize over a positive budget; a nonuniform prior can have larger error.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L57](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L57) · [OperationalExpurgation L69](../../LeanInfoTheory/Examples/OperationalExpurgation.lean#L69)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `c`, `W`, `hM`, `b`.

```lean
theorem LeanInfoTheory.Shannon.BlockChannelCode.maximalErrorProbability_le_iff.{u, v} : ∀ {X : Type u} {Y : Type v}
  [inst : Fintype.{v} Y] {n M : ℕ} (c : LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M) (W : X → PMF.{v} Y)
  (hM : LE.le.{0} 1 M) (b : ℝ),
  LE.le.{0} (LeanInfoTheory.Shannon.BlockChannelCode.maximalErrorProbability.{u, v} c W hM) b ↔
    ∀ (m : Fin M), LE.le.{0} (LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability.{u, v} c W m) b
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability</code></summary>

Failure probability under the channel row of the sent index. It is defined independently of how often that index is sent.

**C32.01** · new definition/representation. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L40) · [Approved step](../../docs/plans/release-3-chunk-32.md#L27) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.5, (8.28)–(8.32), pp. 193–194; PW24 §17.1 Defs 17.1–17.2, pp. 342–343. Keep the released uniform error and total decoder. Evaluate row error at one sent label, aggregate under any prescribed PMF, and maximize over a positive budget; a nonuniform prior can have larger error.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L35](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L35) · [OperationalExpurgation L37](../../LeanInfoTheory/Examples/OperationalExpurgation.lean#L37)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `c`, `W`, `m`.

```lean
def LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability.{u, v} : {X : Type u} →
  {Y : Type v} →
    [Fintype.{v} Y] → {n M : ℕ} → LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M → (X → PMF.{v} Y) → Fin M → ℝ
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.restrictMessages</code></summary>

Retain the indices specified by an embedding. Invert that embedding on retained decoder outputs and send all other decoder outputs to the fallback.

**C32.02** · new definition/representation. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L119) · [Approved step](../../docs/plans/release-3-chunk-32.md#L33) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.7, proof of Thm 8.7.1, step 3, (8.81), p. 202. Restrict by an actual embedding of labels, with explicit fallback in the retained budget. Correctly decoded retained labels stay correct. A discarded output redirected by fallback can improve a row.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L125](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L125) · [OperationalExpurgation L39](../../LeanInfoTheory/Examples/OperationalExpurgation.lean#L39)

**Binder order.** `{X}`, `{Y}`, `{n}`, `{M}`, `{K}`, `c`, `i`, `j₀`.

```lean
def LeanInfoTheory.Shannon.BlockChannelCode.restrictMessages.{u, v} : {X : Type u} →
  {Y : Type v} →
    {n M K : ℕ} →
      LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M →
        Function.Embedding.{1, 1} (Fin K) (Fin M) → Fin K → LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n K
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.restrictMessages_decoder_of_eq</code></summary>

A correct decision on a retained index remains correct after restriction.

**C32.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L125) · [Approved step](../../docs/plans/release-3-chunk-32.md#L33) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.7, proof of Thm 8.7.1, step 3, (8.81), p. 202. Restrict by an actual embedding of labels, with explicit fallback in the retained budget. Correctly decoded retained labels stay correct. A discarded output redirected by fallback can improve a row.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L198](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L198)

**Binder order.** `{X}`, `{Y}`, `{n}`, `{M}`, `{K}`, `c`, `i`, `j₀`, `y`, `j`, `h`.

```lean
theorem LeanInfoTheory.Shannon.BlockChannelCode.restrictMessages_decoder_of_eq.{u, v} : ∀ {X : Type u} {Y : Type v}
  {n M K : ℕ} (c : LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M)
  (i : Function.Embedding.{1, 1} (Fin K) (Fin M)) (j₀ : Fin K) (y : Fin n → Y) (j : Fin K),
  Eq.{1} (LeanInfoTheory.Shannon.BlockChannelCode.decoder.{u, v} c y) (i j) →
    Eq.{1}
      (LeanInfoTheory.Shannon.BlockChannelCode.decoder.{u, v}
        (LeanInfoTheory.Shannon.BlockChannelCode.restrictMessages.{u, v} c i j₀) y)
      j
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability_restrictMessages_le</code></summary>

Restricting the message set can only decrease the error of a retained index. The transmitted word and its channel row are the same in both codes.

**C32.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L134) · [Approved step](../../docs/plans/release-3-chunk-32.md#L33) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.7, proof of Thm 8.7.1, step 3, (8.81), p. 202. Restrict by an actual embedding of labels, with explicit fallback in the retained budget. Correctly decoded retained labels stay correct. A discarded output redirected by fallback can improve a row.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L153](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L153) · [OperationalExpurgation L71](../../LeanInfoTheory/Examples/OperationalExpurgation.lean#L71)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `{K}`, `c`, `W`, `i`, `j₀`, `j`.

```lean
theorem LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability_restrictMessages_le.{u, v} : ∀ {X : Type u}
  {Y : Type v} [inst : Fintype.{v} Y] {n M K : ℕ} (c : LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M)
  (W : X → PMF.{v} Y) (i : Function.Embedding.{1, 1} (Fin K) (Fin M)) (j₀ j : Fin K),
  LE.le.{0}
    (LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability.{u, v}
      (LeanInfoTheory.Shannon.BlockChannelCode.restrictMessages.{u, v} c i j₀) W j)
    (LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability.{u, v} c W (i j))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.half_le_card_filter_messageErrorProbability</code></summary>

At least half the original message indices, rounded up, have row error at most twice the uniform mean. At zero mean every index meets the threshold.

**C32.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L152) · [Approved step](../../docs/plans/release-3-chunk-32.md#L40) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.7, proof of Thm 8.7.1, step 3, (8.81), p. 202; PW24 §19.1 Thm 19.4, pp. 374–375. Keep the whole weak-threshold good set including ties, of size at least ceil(M/2). For every fitting positive K, choose one restriction valid for all message priors.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L264](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L264)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `c`, `W`, `hM`.

```lean
theorem LeanInfoTheory.Shannon.BlockChannelCode.half_le_card_filter_messageErrorProbability.{u, v} : ∀ {X : Type u}
  {Y : Type v} [inst : Fintype.{v} Y] {n M : ℕ} (c : LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M)
  (W : X → PMF.{v} Y) (hM : LE.le.{0} 1 M),
  LE.le.{0} (HDiv.hDiv.{0, 0, 0} (HAdd.hAdd.{0, 0, 0} M 1) 2)
    (Finset.card.{0}
      {m |
        LE.le.{0} (LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability.{u, v} c W m)
          (HMul.hMul.{0, 0, 0} 2 (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} c W hM))})
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.BlockChannelCode.exists_expurgated_restrictions</code></summary>

Enumerate all indices with error at most twice the uniform mean. Each positive requested budget up to that count has one restriction whose maximal error, and hence its error under every prior, obeys the same bound.

**C32.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.ChannelCodeExpurgation`. [Definition](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L200) · [Approved step](../../docs/plans/release-3-chunk-32.md#L40) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.7, proof of Thm 8.7.1, step 3, (8.81), p. 202; PW24 §19.1 Thm 19.4, pp. 374–375. Keep the whole weak-threshold good set including ties, of size at least ceil(M/2). For every fitting positive K, choose one restriction valid for all message priors.

**Consumer.** direct source reference in the listed permanent caller(s). [ChannelCodeExpurgation L293](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean#L293)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `{n}`, `{M}`, `c`, `W`, `hM`.

```lean
theorem LeanInfoTheory.Shannon.BlockChannelCode.exists_expurgated_restrictions.{u, v} : ∀ {X : Type u} {Y : Type v}
  [inst : Fintype.{v} Y] {n M : ℕ} (c : LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n M) (W : X → PMF.{v} Y)
  (hM : LE.le.{0} 1 M),
  have G :=
    {m |
      LE.le.{0} (LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability.{u, v} c W m)
        (HMul.hMul.{0, 0, 0} 2 (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} c W hM))};
  ∃ (_ : LE.le.{0} 1 (Finset.card.{0} G)),
    ∃ i,
      LE.le.{0} (HDiv.hDiv.{0, 0, 0} (HAdd.hAdd.{0, 0, 0} M 1) 2) (Finset.card.{0} G) ∧
        Eq.{1} (Set.range.{0, 1} ⇑i) ↑G ∧
          ∀ (K : ℕ) (hK : LE.le.{0} 1 K) (hKL : LE.le.{0} K (Finset.card.{0} G)),
            ∃ d,
              Eq.{max (u + 1) (v + 1)} d
                  (LeanInfoTheory.Shannon.BlockChannelCode.restrictMessages.{u, v} c
                    (Function.Embedding.trans.{1, 1, 1} (Fin.castLEEmb hKL) i) ⟨0, hK⟩) ∧
                LE.le.{0} (LeanInfoTheory.Shannon.BlockChannelCode.maximalErrorProbability.{u, v} d W hK)
                    (HMul.hMul.{0, 0, 0} 2 (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} c W hM)) ∧
                  ∀ (π : PMF.{0} (Fin K)),
                    LE.le.{0} (LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior.{u, v} d W π)
                      (HMul.hMul.{0, 0, 0} 2 (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} c W hM))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.codeRate_sub_log_two_div_le_of_le_two_mul</code></summary>

Retaining at least half of a positive message budget costs at most `log 2 / n` nats per use at positive blocklength.

**C32.04** · new mathematical theorem. Import `LeanInfoTheory.Shannon.CodingRate`. [Definition](../../LeanInfoTheory/Shannon/CodingRate.lean#L118) · [Approved step](../../docs/plans/release-3-chunk-32.md#L58) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.7, (8.81), p. 202; PW24 §19.1 Thm 19.4, pp. 374–375. The full good-set family loses at most log(2)/n in nats per use for positive n, and has vanishing maximal error. Arbitrarily smaller restrictions need not retain the full-family rate.

**Consumer.** The scalar is used by the supported operational-family theorem; its permanent example then calls that theorem. [OperationalExpurgation L70](../../LeanInfoTheory/Shannon/OperationalExpurgation.lean#L70) · [OperationalExpurgation L62](../../LeanInfoTheory/Examples/OperationalExpurgation.lean#L62)

**Binder order.** `{n}`, `{M}`, `{L}`, `hn`, `hM`, `hML`.

```lean
theorem LeanInfoTheory.Shannon.codeRate_sub_log_two_div_le_of_le_two_mul : ∀ {n M L : ℕ},
  LT.lt.{0} 0 n →
    LE.le.{0} 1 M →
      LE.le.{0} M (HMul.hMul.{0, 0, 0} 2 L) →
        LE.le.{0} (HSub.hSub.{0, 0, 0} (LeanInfoTheory.Shannon.codeRate n M) (HDiv.hDiv.{0, 0, 0} (Real.log 2) ↑n))
          (LeanInfoTheory.Shannon.codeRate n L)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.exists_expurgated_family_of_tendsto_errorProbability</code></summary>

A positive-budget family with vanishing average error admits one family of full good-index restrictions with vanishing maximal error. At positive lengths its rate loss is at most `log 2 / n` nats per use, so it meets the same eventual rate floors.

**C32.04** · new mathematical theorem. Import `LeanInfoTheory.Shannon.OperationalExpurgation`. [Definition](../../LeanInfoTheory/Shannon/OperationalExpurgation.lean#L33) · [Approved step](../../docs/plans/release-3-chunk-32.md#L58) · [Handoff](../../docs/handoffs/chunk-32.md#L105)

**Source and limits.** CT91 §8.7, (8.81), p. 202; PW24 §19.1 Thm 19.4, pp. 374–375. The full good-set family loses at most log(2)/n in nats per use for positive n, and has vanishing maximal error. Arbitrarily smaller restrictions need not retain the full-family rate.

**Consumer.** direct source reference in the listed permanent caller(s). [OperationalExpurgation L62](../../LeanInfoTheory/Examples/OperationalExpurgation.lean#L62)

**Binder order.** `{X}`, `{Y}`, `[instance]`, `W`, `R`, `M`, `hM`, `c`, `he`, `hr`.

```lean
theorem LeanInfoTheory.Shannon.exists_expurgated_family_of_tendsto_errorProbability.{u, v} : ∀ {X : Type u} {Y : Type v}
  [inst : Fintype.{v} Y] (W : X → PMF.{v} Y) (R : ℝ) (M : ℕ → ℕ) (hM : ∀ (n : ℕ), LE.le.{0} 1 (M n))
  (c : (n : ℕ) → LeanInfoTheory.Shannon.BlockChannelCode.{u, v} X Y n (M n)),
  Filter.Tendsto.{0, 0} (fun n => LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} (c n) W (hM n))
      Filter.atTop.{0} (nhds.{0} 0) →
    (∀ (δ : ℝ),
        LT.lt.{0} 0 δ →
          ∀ᶠ (n : ℕ) in Filter.atTop.{0},
            LE.le.{0} (HSub.hSub.{0, 0, 0} R δ) (LeanInfoTheory.Shannon.codeRate n (M n))) →
      ∃ L,
        ∃ (hL : ∀ (n : ℕ), LE.le.{0} 1 (L n)),
          ∃ D,
            (∀ (n : ℕ),
                LE.le.{0} (HDiv.hDiv.{0, 0, 0} (HAdd.hAdd.{0, 0, 0} (M n) 1) 2) (L n) ∧
                  ∃ i,
                    Eq.{1} (Set.range.{0, 1} ⇑i)
                        (Set.ofPred.{0} fun m =>
                          LE.le.{0} (LeanInfoTheory.Shannon.BlockChannelCode.messageErrorProbability.{u, v} (c n) W m)
                            (HMul.hMul.{0, 0, 0} 2
                              (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} (c n) W (hM n)))) ∧
                      Eq.{max (u + 1) (v + 1)} (D n)
                        (LeanInfoTheory.Shannon.BlockChannelCode.restrictMessages.{u, v} (c n) i ⟨0, hL n⟩)) ∧
              (∀ (n : ℕ),
                  LE.le.{0} (LeanInfoTheory.Shannon.BlockChannelCode.maximalErrorProbability.{u, v} (D n) W (hL n))
                    (HMul.hMul.{0, 0, 0} 2
                      (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} (c n) W (hM n)))) ∧
                Filter.Tendsto.{0, 0}
                    (fun n => LeanInfoTheory.Shannon.BlockChannelCode.maximalErrorProbability.{u, v} (D n) W (hL n))
                    Filter.atTop.{0} (nhds.{0} 0) ∧
                  (∀ (n : ℕ),
                      LT.lt.{0} 0 n →
                        LE.le.{0}
                          (HSub.hSub.{0, 0, 0} (LeanInfoTheory.Shannon.codeRate n (M n))
                            (HDiv.hDiv.{0, 0, 0} (Real.log 2) ↑n))
                          (LeanInfoTheory.Shannon.codeRate n (L n))) ∧
                    ∀ (δ : ℝ),
                      LT.lt.{0} 0 δ →
                        ∀ᶠ (n : ℕ) in Filter.atTop.{0},
                          LE.le.{0} (HSub.hSub.{0, 0, 0} R δ) (LeanInfoTheory.Shannon.codeRate n (L n))
```

</details>

### Reused release declarations

| Qualified name and focused import | Caller |
| --- | --- |
| [LeanInfoTheory.Shannon.exists_mutualInfo_channelJoint_eq_channelCapacity](../../LeanInfoTheory/Shannon/ChannelCapacity.lean#L69) · `LeanInfoTheory.Shannon.ChannelCapacity` | [OperationalCapacity L71](../../LeanInfoTheory/Shannon/OperationalCapacity.lean#L71) |
| [LeanInfoTheory.Shannon.roundedMessageSize](../../LeanInfoTheory/Shannon/CodingRate.lean#L65) · `LeanInfoTheory.Shannon.CodingRate` | [CodingRate L65](../../LeanInfoTheory/Shannon/CodingRate.lean#L65) |
| [LeanInfoTheory.Shannon.roundedMessageSize_bounds](../../LeanInfoTheory/Shannon/CodingRate.lean#L69) · `LeanInfoTheory.Shannon.CodingRate` | [CodingRate L69](../../LeanInfoTheory/Shannon/CodingRate.lean#L69) |
| [LeanInfoTheory.Shannon.codeRate_roundedMessageSize_bounds](../../LeanInfoTheory/Shannon/CodingRate.lean#L79) · `LeanInfoTheory.Shannon.CodingRate` | [CodingRate L79](../../LeanInfoTheory/Shannon/CodingRate.lean#L79) |
| [LeanInfoTheory.Shannon.BlockChannelCode.eventually_codeRate_le_channelCapacity_add](../../LeanInfoTheory/Shannon/ChannelCodingAsymptotic.lean#L75) · `LeanInfoTheory.Shannon.ChannelCodingAsymptotic` | [OperationalCapacity L127](../../LeanInfoTheory/Shannon/OperationalCapacity.lean#L127) |
| [LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_one](../../LeanInfoTheory/Shannon/ChannelCode.lean#L194) · `LeanInfoTheory.Shannon.ChannelCode` | [OperationalCapacity L57](../../LeanInfoTheory/Shannon/OperationalCapacity.lean#L57) |

<details><summary>Compiled signatures of the reused declarations</summary>

```lean
theorem LeanInfoTheory.Shannon.exists_mutualInfo_channelJoint_eq_channelCapacity.{u, v} : ∀ {A : Type u} {B : Type v}
  [inst : Fintype.{u} A] [inst_1 : Nonempty.{u + 1} A] [inst_2 : Fintype.{v} B] (W : A → PMF.{v} B),
  ∃ p,
    Eq.{1} (LeanInfoTheory.mutualInfo.{u, v} (PMF.channelJoint.{u, v} p W))
      (LeanInfoTheory.Shannon.channelCapacity.{u, v} W)
def LeanInfoTheory.Shannon.roundedMessageSize : ℕ → ℝ → ℕ
theorem LeanInfoTheory.Shannon.roundedMessageSize_bounds : ∀ (n : ℕ) (R : ℝ),
  LE.le.{0} 1 (LeanInfoTheory.Shannon.roundedMessageSize n R) ∧
    LE.le.{0} (Real.exp (HMul.hMul.{0, 0, 0} (↑n) R)) ↑(LeanInfoTheory.Shannon.roundedMessageSize n R) ∧
      LT.lt.{0} (↑(LeanInfoTheory.Shannon.roundedMessageSize n R))
        (HAdd.hAdd.{0, 0, 0} (Real.exp (HMul.hMul.{0, 0, 0} (↑n) R)) 1)
theorem LeanInfoTheory.Shannon.codeRate_roundedMessageSize_bounds : ∀ {n : ℕ},
  LT.lt.{0} 0 n →
    ∀ {R : ℝ},
      LE.le.{0} 0 R →
        LE.le.{0} R (LeanInfoTheory.Shannon.codeRate n (LeanInfoTheory.Shannon.roundedMessageSize n R)) ∧
          LE.le.{0} (LeanInfoTheory.Shannon.codeRate n (LeanInfoTheory.Shannon.roundedMessageSize n R))
            (HAdd.hAdd.{0, 0, 0} R (HDiv.hDiv.{0, 0, 0} (Real.log 2) ↑n))
theorem LeanInfoTheory.Shannon.BlockChannelCode.eventually_codeRate_le_channelCapacity_add.{u, v} : ∀ {A : Type u}
  {B : Type v} [inst : Fintype.{u} A] [inst_1 : Nonempty.{u + 1} A] [inst_2 : Fintype.{v} B] (W : A → PMF.{v} B)
  (M : ℕ → ℕ) (hM : ∀ (n : ℕ), LE.le.{0} 1 (M n))
  (c : (n : ℕ) → LeanInfoTheory.Shannon.BlockChannelCode.{u, v} A B n (M n)),
  Filter.Tendsto.{0, 0} (fun n => LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} (c n) W (hM n))
      Filter.atTop.{0} (nhds.{0} 0) →
    ∀ (δ : ℝ),
      LT.lt.{0} 0 δ →
        ∀ᶠ (n : ℕ) in Filter.atTop.{0},
          LE.le.{0} (LeanInfoTheory.Shannon.codeRate n (M n))
            (HAdd.hAdd.{0, 0, 0} (LeanInfoTheory.Shannon.channelCapacity.{u, v} W) δ)
theorem LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_one.{u, v} : ∀ {A : Type u} {B : Type v} {n : ℕ}
  [inst : Fintype.{v} B] (c : LeanInfoTheory.Shannon.BlockChannelCode.{u, v} A B n 1) (W : A → PMF.{v} B),
  Eq.{1}
    (LeanInfoTheory.Shannon.BlockChannelCode.errorProbability.{u, v} c W
      (Decidable.byContradiction fun a => LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_one._proof_1 a))
    0
```

</details>

### Private and example results

- Open one C31 family before using C32's lengthwise expurgation. [OperationalExpurgation L29](../../LeanInfoTheory/Examples/OperationalExpurgation.lean#L29)

<a id="package-4"></a>

## Lossless separation

- C33 records. [Approved plan](../../docs/plans/release-3-chunk-33.md) · [Endpoint handoff](../../docs/handoffs/chunk-33.md)
- C34 records. [Approved plan](../../docs/plans/release-3-chunk-34.md) · [Endpoint handoff](../../docs/handoffs/chunk-34.md)

Permanent examples. [SourceChannelCode](../../LeanInfoTheory/Examples/SourceChannelCode.lean) · [SourceChannelSeparation](../../LeanInfoTheory/Examples/SourceChannelSeparation.lean) · [SourceChannelConverse](../../LeanInfoTheory/Examples/SourceChannelConverse.lean) · [SourceChannelSeparationPackage](../../LeanInfoTheory/Examples/SourceChannelSeparationPackage.lean)

<details>
<summary><code>LeanInfoTheory.Shannon.sourceChannelErrorProbability</code></summary>

Probability that a total decoder fails to reconstruct the original iid source word after one memoryless channel use per source symbol.

**C33.01** · new definition/representation. Import `LeanInfoTheory.Shannon.SourceChannelCode`. [Definition](../../LeanInfoTheory/Shannon/SourceChannelCode.lean#L33) · [Approved step](../../docs/plans/release-3-chunk-33.md#L60) · [Handoff](../../docs/handoffs/chunk-33.md#L70)

**Source and limits.** CT91 §8.13, (8.142), p. 216; PW24 §19.7 Thm 19.22, pp. 391–393. Evaluate reconstruction at the joint law of iid source words and outputs sampled from the DMC row selected by the arbitrary total encoder. One channel use per source symbol.

**Consumer.** direct source reference in the listed permanent caller(s). [SourceChannelCode L52](../../LeanInfoTheory/Examples/SourceChannelCode.lean#L52) · [SourceChannelSeparation L72](../../LeanInfoTheory/Examples/SourceChannelSeparation.lean#L72) · [SourceChannelConverse L37](../../LeanInfoTheory/Examples/SourceChannelConverse.lean#L37) · [SourceChannelSeparationPackage L35](../../LeanInfoTheory/Examples/SourceChannelSeparationPackage.lean#L35)

**Binder order.** `{S}`, `{X}`, `{Y}`, `[instance]`, `[instance]`, `p`, `W`, `n`, `E`, `D`.

```lean
def LeanInfoTheory.Shannon.sourceChannelErrorProbability.{u, v, w} : {S : Type u} →
  {X : Type v} →
    {Y : Type w} →
      [Fintype.{u} S] →
        [Fintype.{w} Y] →
          PMF.{u} S → (X → PMF.{w} Y) → (n : ℕ) → ((Fin n → S) → Fin n → X) → ((Fin n → Y) → Fin n → S) → ℝ
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.sourceChannelErrorProbability_comp_le</code></summary>

Reconstructing after compression and transmission fails only if the source decoder fails on the sent index or the channel decoder returns a different index. Channel errors are averaged under the compressor's output law.

**C33.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.SourceChannelCode`. [Definition](../../LeanInfoTheory/Shannon/SourceChannelCode.lean#L52) · [Approved step](../../docs/plans/release-3-chunk-33.md#L72) · [Handoff](../../docs/handoffs/chunk-33.md#L70)

**Source and limits.** CT91 §8.13, Thm 8.13.1, (8.143)–(8.147), pp. 216–217; PW24 §19.7, Thm 19.22, pp. 392–393. Channel prior is exactly the iid-source law pushed through its source encoder. Decoder error is bounded by source error plus this induced-prior channel error; a uniform substitution can fail.

**Consumer.** direct source reference in the listed permanent caller(s). [SourceChannelCode L188](../../LeanInfoTheory/Examples/SourceChannelCode.lean#L188)

**Binder order.** `{S}`, `{X}`, `{Y}`, `[instance]`, `[instance]`, `{n}`, `{K}`, `p`, `W`, `a`, `b`.

```lean
theorem LeanInfoTheory.Shannon.sourceChannelErrorProbability_comp_le.{u, v, w} : ∀ {S : Type u} {X : Type v}
  {Y : Type w} [inst : Fintype.{u} S] [inst_1 : Fintype.{w} Y] {n K : ℕ} (p : PMF.{u} S) (W : X → PMF.{w} Y)
  (a : LeanInfoTheory.Shannon.BlockSourceCode.{u} S n K) (b : LeanInfoTheory.Shannon.BlockChannelCode.{v, w} X Y n K),
  LE.le.{0}
    (LeanInfoTheory.Shannon.sourceChannelErrorProbability.{u, v, w} p W n
      (Function.comp.{u + 1, 1, v + 1} (LeanInfoTheory.Shannon.BlockChannelCode.encoder.{v, w} b)
        (LeanInfoTheory.Shannon.SourceCode.encoder.{u} a))
      (Function.comp.{w + 1, 1, u + 1} (LeanInfoTheory.Shannon.SourceCode.decoder.{u} a)
        (LeanInfoTheory.Shannon.BlockChannelCode.decoder.{v, w} b)))
    (HAdd.hAdd.{0, 0, 0} (LeanInfoTheory.Shannon.SourceCode.errorProbability.{u} a (PMF.iid.{u} p n))
      (LeanInfoTheory.Shannon.BlockChannelCode.errorProbabilityWithPrior.{v, w} b W
        (PMF.map.{u, 0} (LeanInfoTheory.Shannon.SourceCode.encoder.{u} a) (PMF.iid.{u} p n))))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.exists_sourceChannelCode_tendsto_errorProbability_zero</code></summary>

If source entropy is strictly below channel capacity, a single pair of total deterministic word-map families gives vanishing block reconstruction error with one channel use per source symbol.

**C33.04** · new mathematical theorem. Import `LeanInfoTheory.Shannon.SourceChannelSeparation`. [Definition](../../LeanInfoTheory/Shannon/SourceChannelSeparation.lean#L35) · [Approved step](../../docs/plans/release-3-chunk-33.md#L82) · [Handoff](../../docs/handoffs/chunk-33.md#L70)

**Source and limits.** CT91 §8.13 Thm 8.13.1, (8.143)–(8.147); PW24 §19.7 Thm 19.22 direct part, pp. 392–393. H<C gives one total family pair E,D at every length, with eventual budget fitting and arbitrary earlier choices. Finite iid lossless unit-bandwidth source/DMC coding.

**Consumer.** direct source reference in the listed permanent caller(s). [SourceChannelSeparation L78](../../LeanInfoTheory/Examples/SourceChannelSeparation.lean#L78) · [SourceChannelSeparationPackage L37](../../LeanInfoTheory/Examples/SourceChannelSeparationPackage.lean#L37)

**Binder order.** `{S}`, `{X}`, `{Y}`, `[instance]`, `[instance]`, `[instance]`, `[instance]`, `p`, `W`, `h`.

```lean
theorem LeanInfoTheory.Shannon.exists_sourceChannelCode_tendsto_errorProbability_zero.{u, v, w} : ∀ {S : Type u}
  {X : Type v} {Y : Type w} [inst : Fintype.{u} S] [inst_1 : Fintype.{v} X] [inst_2 : Nonempty.{v + 1} X]
  [inst_3 : Fintype.{w} Y] (p : PMF.{u} S) (W : X → PMF.{w} Y),
  LT.lt.{0} (LeanInfoTheory.entropy.{u} p) (LeanInfoTheory.Shannon.channelCapacity.{v, w} W) →
    ∃ E D,
      Filter.Tendsto.{0, 0} (fun n => LeanInfoTheory.Shannon.sourceChannelErrorProbability.{u, v, w} p W n (E n) (D n))
        Filter.atTop.{0} (nhds.{0} 0)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.mul_entropy_le_mul_channelCapacity_add_error</code></summary>

For every deterministic word encoder and reconstruction decoder, the iid source block entropy is bounded by the block capacity plus the weak Fano penalty for its actual reconstruction error. The undivided bound includes zero length and singleton sources.

**C34.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.SourceChannelConverse`. [Definition](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L50) · [Approved step](../../docs/plans/release-3-chunk-34.md#L43) · [Handoff](../../docs/handoffs/chunk-34.md#L47)

**Source and limits.** CT91 §8.13 Thm 8.13.1, (8.148)–(8.157), pp. 217–218; §§2.8, 2.11 (2.145); PW24 §19.7 (19.36). For any total E,D, weak Fano on the actual source/output joint and the possibly correlated pushforward channel input bound nH by nC plus log 2 and the error penalty, including n=0.

**Consumer.** direct source reference in the listed permanent caller(s). [SourceChannelConverse L38](../../LeanInfoTheory/Examples/SourceChannelConverse.lean#L38)

**Binder order.** `{S}`, `{X}`, `{Y}`, `[instance]`, `[instance]`, `[instance]`, `[instance]`, `p`, `W`, `n`, `E`, `D`.

```lean
theorem LeanInfoTheory.Shannon.mul_entropy_le_mul_channelCapacity_add_error.{u, v, w} : ∀ {S : Type u} {X : Type v}
  {Y : Type w} [inst : Fintype.{u} S] [inst_1 : Fintype.{v} X] [inst_2 : Nonempty.{v + 1} X] [inst_3 : Fintype.{w} Y]
  (p : PMF.{u} S) (W : X → PMF.{w} Y) (n : ℕ) (E : (Fin n → S) → Fin n → X) (D : (Fin n → Y) → Fin n → S),
  LE.le.{0} (HMul.hMul.{0, 0, 0} (↑n) (LeanInfoTheory.entropy.{u} p))
    (HAdd.hAdd.{0, 0, 0}
      (HAdd.hAdd.{0, 0, 0} (HMul.hMul.{0, 0, 0} (↑n) (LeanInfoTheory.Shannon.channelCapacity.{v, w} W)) (Real.log 2))
      (HMul.hMul.{0, 0, 0}
        (HMul.hMul.{0, 0, 0} (LeanInfoTheory.Shannon.sourceChannelErrorProbability.{u, v, w} p W n E D) ↑n)
        (Real.log ↑(Fintype.card.{u} S))))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability</code></summary>

With one memoryless channel use per iid source symbol, vanishing block reconstruction error for any given deterministic encoder and decoder families forces the source entropy to be at most the channel capacity.

**C34.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.SourceChannelConverse`. [Definition](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L76) · [Approved step](../../docs/plans/release-3-chunk-34.md#L56) · [Handoff](../../docs/handoffs/chunk-34.md#L47)

**Source and limits.** CT91 §8.13 Thm 8.13.1, (8.148)–(8.157), pp. 217–218; PW24 §19.7 Thm 19.22. Vanishing of the same family’s error implies H≤C. This weak converse yields no equality-case direct theorem or strong-converse rate.

**Consumer.** direct source reference in the listed permanent caller(s). [SourceChannelConverse L50](../../LeanInfoTheory/Examples/SourceChannelConverse.lean#L50) · [SourceChannelSeparationPackage L38](../../LeanInfoTheory/Examples/SourceChannelSeparationPackage.lean#L38)

**Binder order.** `{S}`, `{X}`, `{Y}`, `[instance]`, `[instance]`, `[instance]`, `[instance]`, `p`, `W`, `E`, `D`, `he`.

```lean
theorem LeanInfoTheory.Shannon.entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability.{u, v, w} : ∀
  {S : Type u} {X : Type v} {Y : Type w} [inst : Fintype.{u} S] [inst_1 : Fintype.{v} X] [inst_2 : Nonempty.{v + 1} X]
  [inst_3 : Fintype.{w} Y] (p : PMF.{u} S) (W : X → PMF.{w} Y) (E : (n : ℕ) → (Fin n → S) → Fin n → X)
  (D : (n : ℕ) → (Fin n → Y) → Fin n → S),
  Filter.Tendsto.{0, 0} (fun n => LeanInfoTheory.Shannon.sourceChannelErrorProbability.{u, v, w} p W n (E n) (D n))
      Filter.atTop.{0} (nhds.{0} 0) →
    LE.le.{0} (LeanInfoTheory.entropy.{u} p) (LeanInfoTheory.Shannon.channelCapacity.{v, w} W)
```

</details>

### Reused release declarations

| Qualified name and focused import | Caller |
| --- | --- |
| [LeanInfoTheory.Shannon.exists_blockSourceCode_tendsto_errorProbability_zero](../../LeanInfoTheory/Shannon/SourceCodingAsymptotic.lean#L150) · `LeanInfoTheory.Shannon.SourceCodingAsymptotic` | [SourceChannelSeparation L43](../../LeanInfoTheory/Shannon/SourceChannelSeparation.lean#L43) |
| [LeanInfoTheory.Shannon.condEntropy_fano_weak](../../LeanInfoTheory/Shannon/Fano.lean#L695) · `LeanInfoTheory.Shannon.Fano` | [SourceChannelConverse L65](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L65) |
| [LeanInfoTheory.Shannon.mutualInfo_channelJoint_memorylessChannel_le](../../LeanInfoTheory/Shannon/ProductChannelCapacity.lean#L97) · `LeanInfoTheory.Shannon.ProductChannelCapacity` | [SourceChannelConverse L61](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L61) |
| [LeanInfoTheory.Shannon.entropy_iid](../../LeanInfoTheory/Shannon/SemanticBridge/FiniteProduct.lean#L102) · `LeanInfoTheory.Shannon.SemanticBridge.FiniteProduct` | [SourceChannelConverse L64](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L64) |

<details><summary>Compiled signatures of the reused declarations</summary>

```lean
theorem LeanInfoTheory.Shannon.exists_blockSourceCode_tendsto_errorProbability_zero.{u} : ∀ {A : Type u}
  [inst : Fintype.{u} A] (p : PMF.{u} A) {R : ℝ},
  LT.lt.{0} (LeanInfoTheory.entropy.{u} p) R →
    ∃ M,
      (∀ (n : ℕ), LE.le.{0} 1 (M n)) ∧
        ∃ c,
          Filter.Tendsto.{0, 0}
              (fun n => LeanInfoTheory.Shannon.SourceCode.errorProbability.{u} (c n) (PMF.iid.{u} p n)) Filter.atTop.{0}
              (nhds.{0} 0) ∧
            ∀ᶠ (n : ℕ) in Filter.atTop.{0}, LE.le.{0} (LeanInfoTheory.Shannon.codeRate n (M n)) R
theorem LeanInfoTheory.Shannon.condEntropy_fano_weak.{u, v} : ∀ {alpha : Type u} {beta : Type v}
  [inst : Fintype.{u} alpha] [inst_1 : Fintype.{v} beta] (p : PMF.{max v u} (Prod.{u, v} alpha beta))
  (decoder : beta → alpha),
  LE.le.{0} (LeanInfoTheory.condEntropy.{u, v} p)
    (HAdd.hAdd.{0, 0, 0} (Real.log 2)
      (HMul.hMul.{0, 0, 0} (LeanInfoTheory.Shannon.decodingErrorProbability.{u, v} p decoder)
        (Real.log ↑(Fintype.card.{u} alpha))))
theorem LeanInfoTheory.Shannon.mutualInfo_channelJoint_memorylessChannel_le.{v, w} : ∀ {A : Type v} {B : Type w}
  [inst : Fintype.{v} A] [inst_1 : Nonempty.{v + 1} A] [inst_2 : Fintype.{w} B] (W : A → PMF.{w} B) (n : ℕ)
  (q : PMF.{v} (Fin n → A)),
  LE.le.{0} (LeanInfoTheory.mutualInfo.{v, w} (PMF.channelJoint.{v, w} q (PMF.memorylessChannel.{v, w} W n)))
    (HMul.hMul.{0, 0, 0} (↑n) (LeanInfoTheory.Shannon.channelCapacity.{v, w} W))
theorem LeanInfoTheory.Shannon.entropy_iid.{v} : ∀ {A : Type v} [inst : Fintype.{v} A] (p : PMF.{v} A) (n : ℕ),
  Eq.{1} (LeanInfoTheory.entropy.{v} (PMF.iid.{v} p n)) (HMul.hMul.{0, 0, 0} (↑n) (LeanInfoTheory.entropy.{v} p))
```

</details>

### Private and example results

- Direct and converse consumers over the identical error definition; the lower and upper sides retain their own hypotheses. [SourceChannelSeparationPackage L32](../../LeanInfoTheory/Examples/SourceChannelSeparationPackage.lean#L32)
- C34 compares the true source/output and encoded-input/output joint laws by data processing before imposing product assumptions. [mutualInfo_sourceOutput_le_inputOutput](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L30)

<a id="package-5"></a>

## Binary prefix lengths

- C35 records. [Approved plan](../../docs/plans/release-3-chunk-35.md) · [Endpoint handoff](../../docs/handoffs/chunk-35.md)
- C36 records. [Approved plan](../../docs/plans/release-3-chunk-36.md) · [Endpoint handoff](../../docs/handoffs/chunk-36.md)

Permanent examples. [PrefixCode](../../LeanInfoTheory/Examples/PrefixCode.lean) · [PrefixCodeLength](../../LeanInfoTheory/Examples/PrefixCodeLength.lean)

<details>
<summary><code>LeanInfoTheory.Shannon.IsBinaryPrefixCode</code></summary>

A binary word can prefix another assigned word only when their labels agree.

**C35.01** · new definition/representation. Import `LeanInfoTheory.Shannon.PrefixCode`. [Definition](../../LeanInfoTheory/Shannon/PrefixCode.lean#L36) · [Approved step](../../docs/plans/release-3-chunk-35.md#L50) · [Handoff](../../docs/handoffs/chunk-35.md#L26)

**Source and limits.** CT91 §5.1 (5.3), §5.2 Thm 5.2.1, pp. 82–83; §5.5 Thm 5.5.1; PW24 §10.3 Defs 10.6–10.8 and Thm 10.9. Index words by original source labels. Prefix comparability implies label equality. A singleton may receive the empty word when symbol count is known. Kraft uses Bool as digit alphabet.

**Consumer.** direct source reference in the listed permanent caller(s). [PrefixCode L31](../../LeanInfoTheory/Examples/PrefixCode.lean#L31) · [PrefixCodeLength L57](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L57)

**Binder order.** `{S}`, `c`.

```lean
def LeanInfoTheory.Shannon.IsBinaryPrefixCode.{u} : {S : Type u} → (S → List.{0} Bool) → Prop
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.IsBinaryPrefixCode.kraft_sum_le_one</code></summary>

The binary Kraft sum of any finite labeled prefix code is at most one.

**C35.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.PrefixCode`. [Definition](../../LeanInfoTheory/Shannon/PrefixCode.lean#L74) · [Approved step](../../docs/plans/release-3-chunk-35.md#L50) · [Handoff](../../docs/handoffs/chunk-35.md#L26)

**Source and limits.** CT91 §5.1 (5.3), §5.2 Thm 5.2.1, pp. 82–83; §5.5 Thm 5.5.1; PW24 §10.3 Defs 10.6–10.8 and Thm 10.9. Index words by original source labels. Prefix comparability implies label equality. A singleton may receive the empty word when symbol count is known. Kraft uses Bool as digit alphabet.

**Consumer.** direct source reference in the listed permanent caller(s). [PrefixCode L46](../../LeanInfoTheory/Examples/PrefixCode.lean#L46) · [PrefixCodeLength L120](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L120)

**Binder order.** `{S}`, `[instance]`, `{c}`, `hc`.

```lean
theorem LeanInfoTheory.Shannon.IsBinaryPrefixCode.kraft_sum_le_one.{u} : ∀ {S : Type u} [inst : Fintype.{u} S]
  {c : S → List.{0} Bool},
  LeanInfoTheory.Shannon.IsBinaryPrefixCode.{u} c →
    LE.le.{0} (∑ a, HPow.hPow.{0, 0, 0} (1 / 2) (List.length.{0} (c a))) 1
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.exists_isBinaryPrefixCode_of_kraft_sum_le_one</code></summary>

A finite family of binary codeword lengths with Kraft sum at most one is realized by a prefix code on the original labels, with the prescribed length at each label.

**C35.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.PrefixCode`. [Definition](../../LeanInfoTheory/Shannon/PrefixCode.lean#L146) · [Approved step](../../docs/plans/release-3-chunk-35.md#L56) · [Handoff](../../docs/handoffs/chunk-35.md#L26)

**Source and limits.** CT91 §5.2 Thm 5.2.1, pp. 82–83; PW24 §10.3 Thm 10.9, pp. 207–208. Realize each label's natural length in a finite Boolean tree, including tied lengths, slack, empty domain and zero depth. No canonical codeword ordering is asserted.

**Consumer.** direct source reference in the listed permanent caller(s). [PrefixCode L91](../../LeanInfoTheory/Examples/PrefixCode.lean#L91)

**Binder order.** `{S}`, `[instance]`, `ℓ`, `h`.

```lean
theorem LeanInfoTheory.Shannon.exists_isBinaryPrefixCode_of_kraft_sum_le_one.{u} : ∀ {S : Type u} [inst : Fintype.{u} S]
  (ℓ : S → ℕ),
  LE.le.{0} (∑ a, HPow.hPow.{0, 0, 0} (1 / 2) (ℓ a)) 1 →
    ∃ c, LeanInfoTheory.Shannon.IsBinaryPrefixCode.{u} c ∧ ∀ (a : S), Eq.{1} (List.length.{0} (c a)) (ℓ a)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.expectedCodewordLength</code></summary>

Mean length in binary digits of a word assignment on the support of a finite source.

**C36.01** · new definition/representation. Import `LeanInfoTheory.Shannon.PrefixCodeLength`. [Definition](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean#L34) · [Approved step](../../docs/plans/release-3-chunk-36.md#L70) · [Handoff](../../docs/handoffs/chunk-36.md#L44)

**Source and limits.** CT91 §5.3 Thm 5.3.1; PW24 §§10.1 and 10.3 (10.12). Each encoder acts on actual support; finite expectation in bits dominates entropy converted from nats, also for incomplete Kraft sums.

**Consumer.** direct source reference in the listed permanent caller(s). [PrefixCodeLength L70](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L70)

**Binder order.** `{A}`, `[instance]`, `p`, `c`.

```lean
def LeanInfoTheory.Shannon.expectedCodewordLength.{u} : {A : Type u} →
  [inst : Fintype.{u} A] → (p : PMF.{u} A) → (↥(PMF.supportFinset.{u} p) → List.{0} Bool) → ℝ
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.natsToBits_entropy_le_expectedCodewordLength</code></summary>

Every binary prefix code on the supported symbols has mean length at least the source entropy in bits.

**C36.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.PrefixCodeLength`. [Definition](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean#L64) · [Approved step](../../docs/plans/release-3-chunk-36.md#L70) · [Handoff](../../docs/handoffs/chunk-36.md#L44)

**Source and limits.** CT91 §5.3 Thm 5.3.1; PW24 §§10.1 and 10.3 (10.12). Each encoder acts on actual support; finite expectation in bits dominates entropy converted from nats, also for incomplete Kraft sums.

**Consumer.** direct source reference in the listed permanent caller(s). [PrefixCodeLength L104](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L104)

**Binder order.** `{A}`, `[instance]`, `p`, `{c}`, `hc`.

```lean
theorem LeanInfoTheory.Shannon.natsToBits_entropy_le_expectedCodewordLength.{u} : ∀ {A : Type u} [inst : Fintype.{u} A]
  (p : PMF.{u} A) {c : ↥(PMF.supportFinset.{u} p) → List.{0} Bool},
  LeanInfoTheory.Shannon.IsBinaryPrefixCode.{u} c →
    LE.le.{0} (LeanInfoTheory.Shannon.natsToBits (LeanInfoTheory.entropy.{u} p))
      (LeanInfoTheory.Shannon.expectedCodewordLength.{u} p c)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.exists_isBinaryPrefixCode_length_eq_ceil</code></summary>

A binary prefix encoder realizes the rounded-up information of each supported symbol and has mean length strictly less than entropy in bits plus one.

**C36.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.PrefixCodeLength`. [Definition](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean#L83) · [Approved step](../../docs/plans/release-3-chunk-36.md#L75) · [Handoff](../../docs/handoffs/chunk-36.md#L44)

**Source and limits.** CT91 §5.4 Thm 5.4.1, (5.29)–(5.37); PW24 §10.3 Thm 10.10, (10.13). One encoder realizes each ceiling of −log₂ mass and the strict upper mean bound; it need not minimize the mean.

**Consumer.** direct source reference in the listed permanent caller(s). [PrefixCodeLength L211](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L211)

**Binder order.** `{A}`, `[instance]`, `p`.

```lean
theorem LeanInfoTheory.Shannon.exists_isBinaryPrefixCode_length_eq_ceil.{u} : ∀ {A : Type u} [inst : Fintype.{u} A]
  (p : PMF.{u} A),
  ∃ c,
    LeanInfoTheory.Shannon.IsBinaryPrefixCode.{u} c ∧
      (∀ (a : ↥(PMF.supportFinset.{u} p)),
          Eq.{1} (List.length.{0} (c a)) (Nat.ceil.{0} (Neg.neg.{0} (Real.logb 2 (p ↑a).toReal)))) ∧
        LT.lt.{0} (LeanInfoTheory.Shannon.expectedCodewordLength.{u} p c)
          (HAdd.hAdd.{0, 0, 0} (LeanInfoTheory.Shannon.natsToBits (LeanInfoTheory.entropy.{u} p)) 1)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.optimalPrefixLength</code></summary>

The infimum of mean lengths of binary prefix codes on the positive support.

**C36.03** · new definition/representation. Import `LeanInfoTheory.Shannon.PrefixCodeLength`. [Definition](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean#L124) · [Approved step](../../docs/plans/release-3-chunk-36.md#L80) · [Handoff](../../docs/handoffs/chunk-36.md#L44)

**Source and limits.** CT91 §5.4 Thm 5.4.1, (5.29)–(5.37); PW24 §10.3 (10.12)–(10.13). Take the infimum, prove it attained by a supported prefix encoder, compare it with every competitor, and enclose it between entropy in bits and entropy plus one strictly.

**Consumer.** direct source reference in the listed permanent caller(s). [PrefixCodeLength L101](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L101)

**Binder order.** `{A}`, `[instance]`, `p`.

```lean
def LeanInfoTheory.Shannon.optimalPrefixLength.{u} : {A : Type u} → [Fintype.{u} A] → PMF.{u} A → ℝ
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.isLeast_optimalPrefixLength</code></summary>

A prefix code attains the least mean length among all prefix codes on the support.

**C36.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.PrefixCodeLength`. [Definition](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean#L129) · [Approved step](../../docs/plans/release-3-chunk-36.md#L80) · [Handoff](../../docs/handoffs/chunk-36.md#L44)

**Source and limits.** CT91 §5.4 Thm 5.4.1, (5.29)–(5.37); PW24 §10.3 (10.12)–(10.13). Take the infimum, prove it attained by a supported prefix encoder, compare it with every competitor, and enclose it between entropy in bits and entropy plus one strictly.

**Consumer.** direct source reference in the listed permanent caller(s). [PrefixCodeLength L102](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L102)

**Binder order.** `{A}`, `[instance]`, `p`.

```lean
theorem LeanInfoTheory.Shannon.isLeast_optimalPrefixLength.{u} : ∀ {A : Type u} [inst : Fintype.{u} A] (p : PMF.{u} A),
  IsLeast.{0}
    (Set.ofPred.{0} fun t =>
      ∃ c,
        LeanInfoTheory.Shannon.IsBinaryPrefixCode.{u} c ∧
          Eq.{1} (LeanInfoTheory.Shannon.expectedCodewordLength.{u} p c) t)
    (LeanInfoTheory.Shannon.optimalPrefixLength.{u} p)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.optimalPrefixLength_bounds</code></summary>

The attained optimal binary prefix length is at least the entropy in bits and strictly smaller than entropy in bits plus one.

**C36.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.PrefixCodeLength`. [Definition](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean#L182) · [Approved step](../../docs/plans/release-3-chunk-36.md#L80) · [Handoff](../../docs/handoffs/chunk-36.md#L44)

**Source and limits.** CT91 §5.4 Thm 5.4.1, (5.29)–(5.37); PW24 §10.3 (10.12)–(10.13). Take the infimum, prove it attained by a supported prefix encoder, compare it with every competitor, and enclose it between entropy in bits and entropy plus one strictly.

**Consumer.** direct source reference in the listed permanent caller(s). [PrefixCodeLength L241](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L241)

**Binder order.** `{A}`, `[instance]`, `p`.

```lean
theorem LeanInfoTheory.Shannon.optimalPrefixLength_bounds.{u} : ∀ {A : Type u} [inst : Fintype.{u} A] (p : PMF.{u} A),
  LE.le.{0} (LeanInfoTheory.Shannon.natsToBits (LeanInfoTheory.entropy.{u} p))
      (LeanInfoTheory.Shannon.optimalPrefixLength.{u} p) ∧
    LT.lt.{0} (LeanInfoTheory.Shannon.optimalPrefixLength.{u} p)
      (HAdd.hAdd.{0, 0, 0} (LeanInfoTheory.Shannon.natsToBits (LeanInfoTheory.entropy.{u} p)) 1)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.optimalPrefixLength_iid_div_bounds</code></summary>

For an iid block of positive length `n`, the optimal mean length per source symbol is at least the entropy in bits and is strictly below that entropy plus `1 / n` bits.

**C36.04** · new mathematical theorem. Import `LeanInfoTheory.Shannon.PrefixCodeLengthIid`. [Definition](../../LeanInfoTheory/Shannon/PrefixCodeLengthIid.lean#L28) · [Approved step](../../docs/plans/release-3-chunk-36.md#L85) · [Handoff](../../docs/handoffs/chunk-36.md#L44)

**Source and limits.** CT91 §5.4 Thm 5.4.1, (5.29)–(5.37); PW24 §10.3 Thm 10.10. Use the attained optimum on the whole iid-block support. At n>0 divide by n to get a strict additive 1/n upper bound; no optimizing algorithm is claimed.

**Consumer.** direct source reference in the listed permanent caller(s). [PrefixCodeLength L337](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L337)

**Binder order.** `{A}`, `[instance]`, `p`, `n`, `hn`.

```lean
theorem LeanInfoTheory.Shannon.optimalPrefixLength_iid_div_bounds.{u} : ∀ {A : Type u} [inst : Fintype.{u} A]
  (p : PMF.{u} A) (n : ℕ),
  LT.lt.{0} 0 n →
    LE.le.{0} (LeanInfoTheory.Shannon.natsToBits (LeanInfoTheory.entropy.{u} p))
        (HDiv.hDiv.{0, 0, 0} (LeanInfoTheory.Shannon.optimalPrefixLength.{u} (PMF.iid.{u} p n)) ↑n) ∧
      LT.lt.{0} (HDiv.hDiv.{0, 0, 0} (LeanInfoTheory.Shannon.optimalPrefixLength.{u} (PMF.iid.{u} p n)) ↑n)
        (HAdd.hAdd.{0, 0, 0} (LeanInfoTheory.Shannon.natsToBits (LeanInfoTheory.entropy.{u} p))
          (HDiv.hDiv.{0, 0, 0} 1 ↑n))
```

</details>

### Reused release declarations

| Qualified name and focused import | Caller |
| --- | --- |
| [LeanInfoTheory.Shannon.natsToBits](../../LeanInfoTheory/Shannon/Units.lean#L50) · `LeanInfoTheory.Shannon.Units` | [PrefixCodeLength L66](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean#L66) |
| [LeanInfoTheory.Shannon.entropy_iid](../../LeanInfoTheory/Shannon/SemanticBridge/FiniteProduct.lean#L102) · `LeanInfoTheory.Shannon.SemanticBridge.FiniteProduct` | [PrefixCodeLengthIid L35](../../LeanInfoTheory/Shannon/PrefixCodeLengthIid.lean#L35) |
| [PMF.supportFinset](../../LeanInfoTheory/Probability/Finite.lean#L81) · `LeanInfoTheory.Probability.Finite` | [PrefixCodeLength L35](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean#L35) |

<details><summary>Compiled signatures of the reused declarations</summary>

```lean
def LeanInfoTheory.Shannon.natsToBits : ℝ → ℝ
theorem LeanInfoTheory.Shannon.entropy_iid.{v} : ∀ {A : Type v} [inst : Fintype.{v} A] (p : PMF.{v} A) (n : ℕ),
  Eq.{1} (LeanInfoTheory.entropy.{v} (PMF.iid.{v} p n)) (HMul.hMul.{0, 0, 0} (↑n) (LeanInfoTheory.entropy.{v} p))
def PMF.supportFinset.{u} : {α : Type u} → [Fintype.{u} α] → PMF.{u} α → Finset.{u} α
```

</details>

### Private and example results

- Biased-source example distinguishes a ceiling-length encoder of mean 5/4 from the attained optimum 1. [PrefixCodeLength L206](../../LeanInfoTheory/Examples/PrefixCodeLength.lean#L206)

<a id="package-6"></a>

## Method of types

- C37 records. [Approved plan](../../docs/plans/release-3-chunk-37.md) · [Endpoint handoff](../../docs/handoffs/chunk-37.md)
- C38 records. [Approved plan](../../docs/plans/release-3-chunk-38.md) · [Endpoint handoff](../../docs/handoffs/chunk-38.md)
- C39 records. [Approved plan](../../docs/plans/release-3-chunk-39.md) · [Endpoint handoff](../../docs/handoffs/chunk-39.md)

Permanent examples. [WordType](../../LeanInfoTheory/Examples/WordType.lean) · [TypeClass](../../LeanInfoTheory/Examples/TypeClass.lean) · [TypeClassProbability](../../LeanInfoTheory/Examples/TypeClassProbability.lean) · [TypeClassProbabilityInterface](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean)

<details>
<summary><code>LeanInfoTheory.Shannon.symbolCount</code></summary>

The number of positions of the word `x` occupied by symbol `a`.

**C37.01** · new definition/representation. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L36) · [Approved step](../../docs/plans/release-3-chunk-37.md#L57) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, pp. 279–281, before (12.2). Use natural counts and a finite enumeration of labeled vectors summing to n, including n=0. These combinatorial objects need no empirical normalization.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L42](../../LeanInfoTheory/Examples/WordType.lean#L42) · [TypeClass L191](../../LeanInfoTheory/Examples/TypeClass.lean#L191) · [TypeClassProbability L64](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L64) · [TypeClassProbabilityInterface L279](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L279)

**Binder order.** `{A}`, `{n}`, `x`, `a`.

```lean
def LeanInfoTheory.Shannon.symbolCount.{u} : {A : Type u} → {n : ℕ} → (Fin n → A) → A → ℕ
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.symbolCount_zero</code></summary>

Every symbol occurs zero times in the empty word.

**C37.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L41) · [Approved step](../../docs/plans/release-3-chunk-37.md#L57) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, pp. 279–281, before (12.2). Use natural counts and a finite enumeration of labeled vectors summing to n, including n=0. These combinatorial objects need no empirical normalization.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L297](../../LeanInfoTheory/Examples/WordType.lean#L297)

**Binder order.** `{A}`, `x`, `a`.

```lean
theorem LeanInfoTheory.Shannon.symbolCount_zero.{u} : ∀ {A : Type u} (x : Fin 0 → A) (a : A),
  Eq.{1} (LeanInfoTheory.Shannon.symbolCount.{u} x a) 0
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.sum_symbolCount</code></summary>

The counts over the full alphabet sum to the word length.

**C37.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L46) · [Approved step](../../docs/plans/release-3-chunk-37.md#L57) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, pp. 279–281, before (12.2). Use natural counts and a finite enumeration of labeled vectors summing to n, including n=0. These combinatorial objects need no empirical normalization.

**Consumer.** The supported wordType constructor uses the sum theorem; the permanent example checks the constructed word type. [WordType L71](../../LeanInfoTheory/Shannon/WordType.lean#L71) · [WordType L55](../../LeanInfoTheory/Examples/WordType.lean#L55)

**Binder order.** `{A}`, `{n}`, `[instance]`, `x`.

```lean
theorem LeanInfoTheory.Shannon.sum_symbolCount.{u} : ∀ {A : Type u} {n : ℕ} [inst : Fintype.{u} A] (x : Fin n → A),
  Eq.{1} (∑ a, LeanInfoTheory.Shannon.symbolCount.{u} x a) n
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.wordTypes</code></summary>

The natural count vectors on `A` whose entries sum to `n`.

**C37.01** · new definition/representation. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L54) · [Approved step](../../docs/plans/release-3-chunk-37.md#L57) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, pp. 279–281, before (12.2). Use natural counts and a finite enumeration of labeled vectors summing to n, including n=0. These combinatorial objects need no empirical normalization.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L52](../../LeanInfoTheory/Examples/WordType.lean#L52) · [TypeClass L34](../../LeanInfoTheory/Examples/TypeClass.lean#L34) · [TypeClassProbability L32](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L32) · [TypeClassProbabilityInterface L40](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L40)

**Binder order.** `A`, `[instance]`, `n`.

```lean
def LeanInfoTheory.Shannon.wordTypes.{u} : (A : Type u) → [Fintype.{u} A] → ℕ → Finset.{u} (A → ℕ)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.mem_wordTypes</code></summary>

A count vector is admissible at length `n` exactly when its total is `n`.

**C37.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L59) · [Approved step](../../docs/plans/release-3-chunk-37.md#L57) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, pp. 279–281, before (12.2). Use natural counts and a finite enumeration of labeled vectors summing to n, including n=0. These combinatorial objects need no empirical normalization.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L53](../../LeanInfoTheory/Examples/WordType.lean#L53) · [TypeClass L69](../../LeanInfoTheory/Examples/TypeClass.lean#L69) · [TypeClassProbability L33](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L33) · [TypeClassProbabilityInterface L201](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L201)

**Binder order.** `{A}`, `{n}`, `[instance]`, `c`.

```lean
theorem LeanInfoTheory.Shannon.mem_wordTypes.{u} : ∀ {A : Type u} {n : ℕ} [inst : Fintype.{u} A] (c : A → ℕ),
  Membership.mem.{u, u} (LeanInfoTheory.Shannon.wordTypes.{u} A n) c ↔ Eq.{1} (∑ a, c a) n
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.wordTypes_zero</code></summary>

The sole admissible type at length zero is the all-zero count vector.

**C37.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L65) · [Approved step](../../docs/plans/release-3-chunk-37.md#L57) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, pp. 279–281, before (12.2). Use natural counts and a finite enumeration of labeled vectors summing to n, including n=0. These combinatorial objects need no empirical normalization.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L303](../../LeanInfoTheory/Examples/WordType.lean#L303) · [TypeClass L86](../../LeanInfoTheory/Examples/TypeClass.lean#L86)

**Binder order.** `A`, `[instance]`.

```lean
theorem LeanInfoTheory.Shannon.wordTypes_zero.{u} : ∀ (A : Type u) [inst : Fintype.{u} A],
  Eq.{u + 1} (LeanInfoTheory.Shannon.wordTypes.{u} A 0) (singleton.{u, u} 0)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.wordType</code></summary>

The admissible type of a word, with its symbol counts as the underlying function.

**C37.01** · new definition/representation. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L70) · [Approved step](../../docs/plans/release-3-chunk-37.md#L57) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, pp. 279–281, before (12.2). Use natural counts and a finite enumeration of labeled vectors summing to n, including n=0. These combinatorial objects need no empirical normalization.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L55](../../LeanInfoTheory/Examples/WordType.lean#L55) · [TypeClass L51](../../LeanInfoTheory/Examples/TypeClass.lean#L51) · [TypeClassProbabilityInterface L53](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L53)

**Binder order.** `{A}`, `{n}`, `[instance]`, `x`.

```lean
def LeanInfoTheory.Shannon.wordType.{u} : {A : Type u} →
  {n : ℕ} → [inst : Fintype.{u} A] → (Fin n → A) → ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.wordType_surjective</code></summary>

Every admissible count vector is realized by a word of the prescribed length.

**C37.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L74) · [Approved step](../../docs/plans/release-3-chunk-37.md#L62) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, definition (12.2), pp. 279–280. Realize every admissible count vector on its original labels. The existing finset fiber gives each word a unique class, including length zero.

**Consumer.** Exact class cardinality applies surjectivity; the permanent class examples consume that cardinality theorem. [TypeClassCardinality L99](../../LeanInfoTheory/Shannon/TypeClassCardinality.lean#L99) · [TypeClass L75](../../LeanInfoTheory/Examples/TypeClass.lean#L75)

**Binder order.** `{A}`, `{n}`, `[instance]`.

```lean
theorem LeanInfoTheory.Shannon.wordType_surjective.{u} : ∀ {A : Type u} {n : ℕ} [inst : Fintype.{u} A],
  Function.Surjective.{u + 1, u + 1} LeanInfoTheory.Shannon.wordType.{u}
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.typeClass</code></summary>

The finite set of all words with the given admissible count vector.

**C37.02** · new definition/representation. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L92) · [Approved step](../../docs/plans/release-3-chunk-37.md#L62) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, definition (12.2), pp. 279–280. Realize every admissible count vector on its original labels. The existing finset fiber gives each word a unique class, including length zero.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L58](../../LeanInfoTheory/Examples/WordType.lean#L58) · [TypeClass L35](../../LeanInfoTheory/Examples/TypeClass.lean#L35) · [TypeClassProbability L60](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L60) · [TypeClassProbabilityInterface L42](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L42)

**Binder order.** `{A}`, `{n}`, `[instance]`, `t`.

```lean
def LeanInfoTheory.Shannon.typeClass.{u} : {A : Type u} →
  {n : ℕ} → [inst : Fintype.{u} A] → ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n) → Finset.{u} (Fin n → A)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.mem_typeClass</code></summary>

A word belongs to the supplied class exactly when its type is the class index.

**C37.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L97) · [Approved step](../../docs/plans/release-3-chunk-37.md#L62) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, definition (12.2), pp. 279–280. Realize every admissible count vector on its original labels. The existing finset fiber gives each word a unique class, including length zero.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L58](../../LeanInfoTheory/Examples/WordType.lean#L58) · [TypeClass L188](../../LeanInfoTheory/Examples/TypeClass.lean#L188) · [TypeClassProbability L61](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L61) · [TypeClassProbabilityInterface L58](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L58)

**Binder order.** `{A}`, `{n}`, `[instance]`, `{x}`, `{t}`.

```lean
theorem LeanInfoTheory.Shannon.mem_typeClass.{u} : ∀ {A : Type u} {n : ℕ} [inst : Fintype.{u} A] {x : Fin n → A}
  {t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)},
  Membership.mem.{u, u} (LeanInfoTheory.Shannon.typeClass.{u} t) x ↔
    Eq.{u + 1} (LeanInfoTheory.Shannon.wordType.{u} x) t
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.existsUnique_mem_typeClass</code></summary>

Each word belongs to exactly one of the indexed type classes.

**C37.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L103) · [Approved step](../../docs/plans/release-3-chunk-37.md#L62) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, definition (12.2), pp. 279–280. Realize every admissible count vector on its original labels. The existing finset fiber gives each word a unique class, including length zero.

**Consumer.** The permanent sum_typeClasses checks the partition via fiberwise summation. The archived C37.02 caller directly uses the uniqueness theorem. These are separate checks. [WordType L284](../../LeanInfoTheory/Examples/WordType.lean#L284) · Archived local caller `.lake/compatibility/c37-02-caller-20261117/Caller.lean` at line 57

**Binder order.** `{A}`, `{n}`, `[instance]`, `x`.

```lean
theorem LeanInfoTheory.Shannon.existsUnique_mem_typeClass.{u} : ∀ {A : Type u} {n : ℕ} [inst : Fintype.{u} A]
  (x : Fin n → A), ExistsUnique.{u + 1} fun t => Membership.mem.{u, u} (LeanInfoTheory.Shannon.typeClass.{u} t) x
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.symbolCount_comp_perm</code></summary>

Reading old position `e i` at new position `i` preserves the count of each symbol.

**C37.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L108) · [Approved step](../../docs/plans/release-3-chunk-37.md#L67) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, (12.2) and Thm 12.1.1/(12.6), pp. 279–281. Permutation changes word positions, not alphabet labels. Bound the number of indices by (n+1)^|A|; this is not a bound on a single class's size.

**Consumer.** The bundled permutation law applies pointwise count invariance; the permanent example invokes that bundled law. [WordType L121](../../LeanInfoTheory/Shannon/WordType.lean#L121) · [WordType L79](../../LeanInfoTheory/Examples/WordType.lean#L79)

**Binder order.** `{A}`, `{n}`, `x`, `e`, `a`.

```lean
theorem LeanInfoTheory.Shannon.symbolCount_comp_perm.{u} : ∀ {A : Type u} {n : ℕ} (x : Fin n → A)
  (e : Equiv.Perm.{1} (Fin n)) (a : A),
  Eq.{1} (LeanInfoTheory.Shannon.symbolCount.{u} (Function.comp.{1, 1, u + 1} x ⇑e) a)
    (LeanInfoTheory.Shannon.symbolCount.{u} x a)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.wordType_comp_perm</code></summary>

A permutation of the positions of a word preserves its admissible type.

**C37.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L119) · [Approved step](../../docs/plans/release-3-chunk-37.md#L67) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, (12.2) and Thm 12.1.1/(12.6), pp. 279–281. Permutation changes word positions, not alphabet labels. Bound the number of indices by (n+1)^|A|; this is not a bound on a single class's size.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L79](../../LeanInfoTheory/Examples/WordType.lean#L79)

**Binder order.** `{A}`, `{n}`, `[instance]`, `x`, `e`.

```lean
theorem LeanInfoTheory.Shannon.wordType_comp_perm.{u} : ∀ {A : Type u} {n : ℕ} [inst : Fintype.{u} A] (x : Fin n → A)
  (e : Equiv.Perm.{1} (Fin n)),
  Eq.{u + 1} (LeanInfoTheory.Shannon.wordType.{u} (Function.comp.{1, 1, u + 1} x ⇑e))
    (LeanInfoTheory.Shannon.wordType.{u} x)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.card_wordTypes_le</code></summary>

The number of distinct types is at most `(n + 1) ^ Fintype.card A`.

**C37.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.WordType`. [Definition](../../LeanInfoTheory/Shannon/WordType.lean#L124) · [Approved step](../../docs/plans/release-3-chunk-37.md#L67) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, (12.2) and Thm 12.1.1/(12.6), pp. 279–281. Permutation changes word positions, not alphabet labels. Bound the number of indices by (n+1)^|A|; this is not a bound on a single class's size.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L136](../../LeanInfoTheory/Examples/WordType.lean#L136)

**Binder order.** `A`, `[instance]`, `n`.

```lean
theorem LeanInfoTheory.Shannon.card_wordTypes_le.{u} : ∀ (A : Type u) [inst : Fintype.{u} A] (n : ℕ),
  LE.le.{0} (Finset.card.{u} (LeanInfoTheory.Shannon.wordTypes.{u} A n))
    (HPow.hPow.{0, 0, 0} (HAdd.hAdd.{0, 0, 0} n 1) (Fintype.card.{u} A))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.empiricalPMF</code></summary>

The empirical law of an admissible count vector of positive length.

**C37.04** · new definition/representation. Import `LeanInfoTheory.Shannon.EmpiricalPMF`. [Definition](../../LeanInfoTheory/Shannon/EmpiricalPMF.lean#L38) · [Approved step](../../docs/plans/release-3-chunk-37.md#L72) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, definition of relative frequency before (12.2), pp. 279–280. Only positive lengths normalize. Atom = count/n; actual support means positive count even on sparse alphabets.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L60](../../LeanInfoTheory/Examples/WordType.lean#L60) · [TypeClass L36](../../LeanInfoTheory/Examples/TypeClass.lean#L36) · [TypeClassProbability L68](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L68) · [TypeClassProbabilityInterface L41](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L41)

**Binder order.** `{A}`, `[instance]`, `{n}`, `hn`, `t`.

```lean
def LeanInfoTheory.Shannon.empiricalPMF.{u} : {A : Type u} →
  [inst : Fintype.{u} A] → {n : ℕ} → LT.lt.{0} 0 n → ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n) → PMF.{u} A
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.empiricalPMF_apply</code></summary>

Each empirical atom is its labeled count divided by the positive word length.

**C37.04** · new mathematical theorem. Import `LeanInfoTheory.Shannon.EmpiricalPMF`. [Definition](../../LeanInfoTheory/Shannon/EmpiricalPMF.lean#L44) · [Approved step](../../docs/plans/release-3-chunk-37.md#L72) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, definition of relative frequency before (12.2), pp. 279–280. Only positive lengths normalize. Atom = count/n; actual support means positive count even on sparse alphabets.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L62](../../LeanInfoTheory/Examples/WordType.lean#L62) · [TypeClass L206](../../LeanInfoTheory/Examples/TypeClass.lean#L206) · [TypeClassProbability L71](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L71) · [TypeClassProbabilityInterface L260](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L260)

**Binder order.** `{A}`, `[instance]`, `{n}`, `hn`, `t`, `a`.

```lean
theorem LeanInfoTheory.Shannon.empiricalPMF_apply.{u} : ∀ {A : Type u} [inst : Fintype.{u} A] {n : ℕ}
  (hn : LT.lt.{0} 0 n) (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)) (a : A),
  Eq.{1} ((LeanInfoTheory.Shannon.empiricalPMF.{u} hn t) a) (HDiv.hDiv.{0, 0, 0} ↑(↑t a) ↑n)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.mem_support_empiricalPMF_iff</code></summary>

A symbol belongs to empirical support exactly when its count is positive.

**C37.04** · new mathematical theorem. Import `LeanInfoTheory.Shannon.EmpiricalPMF`. [Definition](../../LeanInfoTheory/Shannon/EmpiricalPMF.lean#L49) · [Approved step](../../docs/plans/release-3-chunk-37.md#L72) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, definition of relative frequency before (12.2), pp. 279–280. Only positive lengths normalize. Atom = count/n; actual support means positive count even on sparse alphabets.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L96](../../LeanInfoTheory/Examples/WordType.lean#L96) · [TypeClass L479](../../LeanInfoTheory/Examples/TypeClass.lean#L479) · [TypeClassProbability L468](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L468) · [TypeClassProbabilityInterface L159](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L159)

**Binder order.** `{A}`, `[instance]`, `{n}`, `hn`, `t`, `a`.

```lean
theorem LeanInfoTheory.Shannon.mem_support_empiricalPMF_iff.{u} : ∀ {A : Type u} [inst : Fintype.{u} A] {n : ℕ}
  (hn : LT.lt.{0} 0 n) (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)) (a : A),
  Membership.mem.{u, u} (PMF.support.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t)) a ↔ LT.lt.{0} 0 (↑t a)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.wordTypeEquivPMF</code></summary>

At positive length, admissible counts are equivalent to laws with an exact denominator witness. The prescribed denominator need not be the least one.

**C37.05** · new definition/representation. Import `LeanInfoTheory.Shannon.EmpiricalPMF`. [Definition](../../LeanInfoTheory/Shannon/EmpiricalPMF.lean#L67) · [Approved step](../../docs/plans/release-3-chunk-37.md#L77) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, relative frequencies and (12.2), pp. 279–280. A witnessed denominator n suffices (it need not be least). Standard inverse laws recover labeled counts. Both entry routes use the identical class finset.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L64](../../LeanInfoTheory/Examples/WordType.lean#L64) · [TypeClass L157](../../LeanInfoTheory/Examples/TypeClass.lean#L157) · [TypeClassProbabilityInterface L215](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L215)

**Binder order.** `{A}`, `[instance]`, `{n}`, `hn`.

```lean
def LeanInfoTheory.Shannon.wordTypeEquivPMF.{u} : {A : Type u} →
  [inst : Fintype.{u} A] →
    {n : ℕ} →
      LT.lt.{0} 0 n →
        Equiv.{u + 1, max 1 (u + 1)} (↥(LeanInfoTheory.Shannon.wordTypes.{u} A n))
          (Subtype.{u + 1} fun q => ∃ c, Eq.{1} (∑ a, c a) n ∧ ∀ (a : A), Eq.{1} (q a) (HDiv.hDiv.{0, 0, 0} ↑(c a) ↑n))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.wordTypeEquivPMF_apply</code></summary>

The forward conversion of a count index is its empirical law.

**C37.05** · new mathematical theorem. Import `LeanInfoTheory.Shannon.EmpiricalPMF`. [Definition](../../LeanInfoTheory/Shannon/EmpiricalPMF.lean#L82) · [Approved step](../../docs/plans/release-3-chunk-37.md#L77) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, relative frequencies and (12.2), pp. 279–280. A witnessed denominator n suffices (it need not be least). Standard inverse laws recover labeled counts. Both entry routes use the identical class finset.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L205](../../LeanInfoTheory/Examples/WordType.lean#L205) · [TypeClass L160](../../LeanInfoTheory/Examples/TypeClass.lean#L160)

**Binder order.** `{A}`, `[instance]`, `{n}`, `hn`, `t`.

```lean
@[defeq] theorem LeanInfoTheory.Shannon.wordTypeEquivPMF_apply.{u} : ∀ {A : Type u} [inst : Fintype.{u} A] {n : ℕ}
  (hn : LT.lt.{0} 0 n) (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)),
  Eq.{u + 1} (↑((LeanInfoTheory.Shannon.wordTypeEquivPMF.{u} hn) t)) (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.mem_typeClass_iff_empiricalPMF_eq</code></summary>

Empirical-law equality recognizes membership in the existing type class.

**C37.05** · new mathematical theorem. Import `LeanInfoTheory.Shannon.EmpiricalPMF`. [Definition](../../LeanInfoTheory/Shannon/EmpiricalPMF.lean#L86) · [Approved step](../../docs/plans/release-3-chunk-37.md#L77) · [Handoff](../../docs/handoffs/chunk-37.md#L85)

**Source and limits.** CT91 §12.1, relative frequencies and (12.2), pp. 279–280. A witnessed denominator n suffices (it need not be least). Standard inverse laws recover labeled counts. Both entry routes use the identical class finset.

**Consumer.** direct source reference in the listed permanent caller(s). [WordType L363](../../LeanInfoTheory/Examples/WordType.lean#L363)

**Binder order.** `{A}`, `[instance]`, `{n}`, `hn`, `{x}`, `{t}`.

```lean
theorem LeanInfoTheory.Shannon.mem_typeClass_iff_empiricalPMF_eq.{u} : ∀ {A : Type u} [inst : Fintype.{u} A] {n : ℕ}
  (hn : LT.lt.{0} 0 n) {x : Fin n → A} {t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)},
  Membership.mem.{u, u} (LeanInfoTheory.Shannon.typeClass.{u} t) x ↔
    Eq.{u + 1} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn (LeanInfoTheory.Shannon.wordType.{u} x))
      (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.card_typeClass_eq_multinomial</code></summary>

The words with supplied admissible counts are counted by the multinomial coefficient. This includes zero length and zero-count symbols.

**C38.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.TypeClassCardinality`. [Definition](../../LeanInfoTheory/Shannon/TypeClassCardinality.lean#L96) · [Approved step](../../docs/plans/release-3-chunk-38.md#L261) · [Handoff](../../docs/handoffs/chunk-38.md#L179)

**Source and limits.** CT91 §12.1 Thm 12.1.3, (12.17), p. 282. Count the existing class exactly at every n; retain zero counts and empty-alphabet boundaries.

**Consumer.** direct source reference in the listed permanent caller(s). [TypeClass L75](../../LeanInfoTheory/Examples/TypeClass.lean#L75) · [TypeClassProbability L125](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L125)

**Binder order.** `{A}`, `[instance]`, `{n}`, `t`.

```lean
theorem LeanInfoTheory.Shannon.card_typeClass_eq_multinomial.{u} : ∀ {A : Type u} [inst : Fintype.{u} A] {n : ℕ}
  (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)),
  Eq.{1} (Finset.card.{u} (LeanInfoTheory.Shannon.typeClass.{u} t)) (Nat.multinomial.{u} Finset.univ.{u} ↑t)
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.iid_empiricalPMF_apply_of_mem_typeClass</code></summary>

Every word in a type class has real iid mass `exp (-n * H(q))` under the class's own empirical law.

**C38.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.TypeClassBounds`. [Definition](../../LeanInfoTheory/Shannon/TypeClassBounds.lean#L98) · [Approved step](../../docs/plans/release-3-chunk-38.md#L277) · [Handoff](../../docs/handoffs/chunk-38.md#L179)

**Source and limits.** CT91 §12.1 Cor (12.15), p. 281; Thm 12.1.3, (12.18)–(12.22). The iid prior is the empirical law itself at n>0. Every member has exp(−nH) mass; multiply by cardinality once for the class. No general-prior KL assumption.

**Consumer.** direct source reference in the listed permanent caller(s). [TypeClass L41](../../LeanInfoTheory/Examples/TypeClass.lean#L41) · [TypeClassProbabilityInterface L249](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L249)

**Binder order.** `{A}`, `[instance]`, `{n}`, `hn`, `t`, `{x}`, `hx`.

```lean
theorem LeanInfoTheory.Shannon.iid_empiricalPMF_apply_of_mem_typeClass.{u} : ∀ {A : Type u} [inst : Fintype.{u} A]
  {n : ℕ} (hn : LT.lt.{0} 0 n) (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)) {x : Fin n → A},
  Membership.mem.{u, u} (LeanInfoTheory.Shannon.typeClass.{u} t) x →
    Eq.{1} ((PMF.iid.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t) n) x).toReal
      (Real.exp
        (HMul.hMul.{0, 0, 0} (Neg.neg.{0} ↑n)
          (LeanInfoTheory.entropy.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t))))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.iid_empiricalPMF_toOuterMeasure_typeClass</code></summary>

The real own-law iid mass of a type class is its cardinality times the common real mass of its words.

**C38.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.TypeClassBounds`. [Definition](../../LeanInfoTheory/Shannon/TypeClassBounds.lean#L118) · [Approved step](../../docs/plans/release-3-chunk-38.md#L277) · [Handoff](../../docs/handoffs/chunk-38.md#L179)

**Source and limits.** CT91 §12.1 Cor (12.15), p. 281; Thm 12.1.3, (12.18)–(12.22). The iid prior is the empirical law itself at n>0. Every member has exp(−nH) mass; multiply by cardinality once for the class. No general-prior KL assumption.

**Consumer.** direct source reference in the listed permanent caller(s). [TypeClass L44](../../LeanInfoTheory/Examples/TypeClass.lean#L44) · [TypeClassProbabilityInterface L252](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L252)

**Binder order.** `{A}`, `[instance]`, `{n}`, `hn`, `t`.

```lean
theorem LeanInfoTheory.Shannon.iid_empiricalPMF_toOuterMeasure_typeClass.{u} : ∀ {A : Type u} [inst : Fintype.{u} A]
  {n : ℕ} (hn : LT.lt.{0} 0 n) (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)),
  Eq.{1}
    ((PMF.toOuterMeasure.{u} (PMF.iid.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t) n))
        ↑(LeanInfoTheory.Shannon.typeClass.{u} t)).toReal
    (HMul.hMul.{0, 0, 0} (↑(Finset.card.{u} (LeanInfoTheory.Shannon.typeClass.{u} t)))
      (Real.exp
        (HMul.hMul.{0, 0, 0} (Neg.neg.{0} ↑n)
          (LeanInfoTheory.entropy.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t)))))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.card_typeClass_le_exp_entropy</code></summary>

At positive length, a type class has at most `exp (n * H(q))` words, where `q` is its empirical law and entropy is measured in nats.

**C38.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.TypeClassBounds`. [Definition](../../LeanInfoTheory/Shannon/TypeClassBounds.lean#L139) · [Approved step](../../docs/plans/release-3-chunk-38.md#L288) · [Handoff](../../docs/handoffs/chunk-38.md#L179)

**Source and limits.** CT91 §12.1 Thm 12.1.3, (12.16), (12.18)–(12.22), p. 282. Use the own-law class probability at most one. Natural log gives the real exponential upper cardinality bound for positive n.

**Consumer.** direct source reference in the listed permanent caller(s). [TypeClass L53](../../LeanInfoTheory/Examples/TypeClass.lean#L53)

**Binder order.** `{A}`, `[instance]`, `{n}`, `hn`, `t`.

```lean
theorem LeanInfoTheory.Shannon.card_typeClass_le_exp_entropy.{u} : ∀ {A : Type u} [inst : Fintype.{u} A] {n : ℕ}
  (hn : LT.lt.{0} 0 n) (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)),
  LE.le.{0} (↑(Finset.card.{u} (LeanInfoTheory.Shannon.typeClass.{u} t)))
    (Real.exp (HMul.hMul.{0, 0, 0} (↑n) (LeanInfoTheory.entropy.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t))))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.exp_entropy_div_pow_le_card_typeClass</code></summary>

At positive length, a type class has at least `exp (n * H(q)) / (n+1)^k` words, with `k` the full ambient alphabet size, including zero-count symbols.

**C38.04** · new mathematical theorem. Import `LeanInfoTheory.Shannon.TypeClassBounds`. [Definition](../../LeanInfoTheory/Shannon/TypeClassBounds.lean#L329) · [Approved step](../../docs/plans/release-3-chunk-38.md#L295) · [Handoff](../../docs/handoffs/chunk-38.md#L179)

**Source and limits.** CT91 §12.1 Thm 12.1.3, (12.16), (12.23)–(12.39), pp. 282–284. Prove a count-vector probability mode with a division-free natural factorial comparison. The lower bound retains the full ambient alphabet exponent even on sparse supports.

**Consumer.** direct source reference in the listed permanent caller(s). [TypeClass L63](../../LeanInfoTheory/Examples/TypeClass.lean#L63)

**Binder order.** `{A}`, `[instance]`, `{n}`, `hn`, `t`.

```lean
theorem LeanInfoTheory.Shannon.exp_entropy_div_pow_le_card_typeClass.{u} : ∀ {A : Type u} [inst : Fintype.{u} A] {n : ℕ}
  (hn : LT.lt.{0} 0 n) (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)),
  LE.le.{0}
    (HDiv.hDiv.{0, 0, 0}
      (Real.exp (HMul.hMul.{0, 0, 0} (↑n) (LeanInfoTheory.entropy.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t))))
      (HPow.hPow.{0, 0, 0} (HAdd.hAdd.{0, 0, 0} (↑n) 1) (Fintype.card.{u} A)))
    ↑(Finset.card.{u} (LeanInfoTheory.Shannon.typeClass.{u} t))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.iid_apply_of_mem_typeClass</code></summary>

Every word in a type class has real iid mass `exp (-n * (H(q) + D(q || p)))` under any prior whose support contains the empirical support. The canonical KL divergence is finite under this hypothesis, and both quantities use nats.

**C39.01** · new mathematical theorem. Import `LeanInfoTheory.Shannon.TypeClassProbability`. [Definition](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L67) · [Approved step](../../docs/plans/release-3-chunk-39.md#L255) · [Handoff](../../docs/handoffs/chunk-39.md#L125)

**Source and limits.** CT91 §12.1 Thm 12.1.2, (12.7)–(12.14), p. 281; §2.3 (2.26)–(2.27). Use empirical q, sampling p and actual support inclusion. Finite canonical KL and the class entropy enter one word's mass in nats, including zero-count labels.

**Consumer.** direct source reference in the listed permanent caller(s). [TypeClassProbability L158](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L158) · [TypeClassProbabilityInterface L49](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L49)

**Binder order.** `{A}`, `[instance]`, `{n}`, `[instance]`, `[instance]`, `hn`, `t`, `p`, `h`, `{x}`, `hx`.

```lean
theorem LeanInfoTheory.Shannon.iid_apply_of_mem_typeClass.{u} : ∀ {A : Type u} [inst : Fintype.{u} A] {n : ℕ}
  [inst_1 : MeasurableSpace.{u} A] [MeasurableSingletonClass.{u} A] (hn : LT.lt.{0} 0 n)
  (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)) (p : PMF.{u} A),
  PMF.support.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t) ⊆ PMF.support.{u} p →
    ∀ {x : Fin n → A},
      Membership.mem.{u, u} (LeanInfoTheory.Shannon.typeClass.{u} t) x →
        Eq.{1} ((PMF.iid.{u} p n) x).toReal
          (Real.exp
            (HMul.hMul.{0, 0, 0} (Neg.neg.{0} ↑n)
              (HAdd.hAdd.{0, 0, 0} (LeanInfoTheory.entropy.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t))
                (InformationTheory.klDiv.{u} (PMF.toMeasure.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t))
                    (PMF.toMeasure.{u} p)).toReal)))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.iid_toOuterMeasure_typeClass</code></summary>

The real iid mass of a type class is its cardinality times the common word mass under a prior whose support contains the empirical support. Canonical KL is finite under this hypothesis, and entropy and divergence use nats.

**C39.02** · new mathematical theorem. Import `LeanInfoTheory.Shannon.TypeClassProbability`. [Definition](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L138) · [Approved step](../../docs/plans/release-3-chunk-39.md#L283) · [Handoff](../../docs/handoffs/chunk-39.md#L125)

**Source and limits.** CT91 §12.1 Thm 12.1.4, (12.55)–(12.57), pp. 285–286. Sum the common word mass over the original finset once. The exact formula contains both entropy and divergence with the single cardinality multiplier.

**Consumer.** direct source reference in the listed permanent caller(s). [TypeClassProbability L169](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L169) · [TypeClassProbabilityInterface L70](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L70)

**Binder order.** `{A}`, `[instance]`, `{n}`, `[instance]`, `[instance]`, `hn`, `t`, `p`, `h`.

```lean
theorem LeanInfoTheory.Shannon.iid_toOuterMeasure_typeClass.{u} : ∀ {A : Type u} [inst : Fintype.{u} A] {n : ℕ}
  [inst_1 : MeasurableSpace.{u} A] [MeasurableSingletonClass.{u} A] (hn : LT.lt.{0} 0 n)
  (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)) (p : PMF.{u} A),
  PMF.support.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t) ⊆ PMF.support.{u} p →
    Eq.{1} ((PMF.toOuterMeasure.{u} (PMF.iid.{u} p n)) ↑(LeanInfoTheory.Shannon.typeClass.{u} t)).toReal
      (HMul.hMul.{0, 0, 0} (↑(Finset.card.{u} (LeanInfoTheory.Shannon.typeClass.{u} t)))
        (Real.exp
          (HMul.hMul.{0, 0, 0} (Neg.neg.{0} ↑n)
            (HAdd.hAdd.{0, 0, 0} (LeanInfoTheory.entropy.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t))
              (InformationTheory.klDiv.{u} (PMF.toMeasure.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t))
                  (PMF.toMeasure.{u} p)).toReal))))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.iid_toOuterMeasure_typeClass_le_exp_neg_klDiv</code></summary>

The probability of a type class under a prior containing its empirical support is at most the exponential of minus its length times its KL divergence.

**C39.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.TypeClassProbability`. [Definition](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L170) · [Approved step](../../docs/plans/release-3-chunk-39.md#L296) · [Handoff](../../docs/handoffs/chunk-39.md#L125)

**Source and limits.** CT91 §12.1 Thm 12.1.4, (12.54), (12.58), pp. 285–286. Under actual support inclusion both bounds apply to the same class/prior/finite KL. The polynomial denominator uses the ambient alphabet, even when inclusion is strict.

**Consumer.** direct source reference in the listed permanent caller(s). [TypeClassProbability L223](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L223) · [TypeClassProbabilityInterface L119](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L119)

**Binder order.** `{A}`, `[instance]`, `{n}`, `[instance]`, `[instance]`, `hn`, `t`, `p`, `h`.

```lean
theorem LeanInfoTheory.Shannon.iid_toOuterMeasure_typeClass_le_exp_neg_klDiv.{u} : ∀ {A : Type u} [inst : Fintype.{u} A]
  {n : ℕ} [inst_1 : MeasurableSpace.{u} A] [MeasurableSingletonClass.{u} A] (hn : LT.lt.{0} 0 n)
  (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)) (p : PMF.{u} A),
  PMF.support.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t) ⊆ PMF.support.{u} p →
    LE.le.{0} ((PMF.toOuterMeasure.{u} (PMF.iid.{u} p n)) ↑(LeanInfoTheory.Shannon.typeClass.{u} t)).toReal
      (Real.exp
        (HMul.hMul.{0, 0, 0} (Neg.neg.{0} ↑n)
          (InformationTheory.klDiv.{u} (PMF.toMeasure.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t))
              (PMF.toMeasure.{u} p)).toReal))
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.exp_neg_klDiv_div_pow_le_iid_toOuterMeasure_typeClass</code></summary>

The finite-KL lower bound for a type class uses the size of the entire alphabet in its polynomial denominator, including symbols with zero counts.

**C39.03** · new mathematical theorem. Import `LeanInfoTheory.Shannon.TypeClassProbability`. [Definition](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L184) · [Approved step](../../docs/plans/release-3-chunk-39.md#L296) · [Handoff](../../docs/handoffs/chunk-39.md#L125)

**Source and limits.** CT91 §12.1 Thm 12.1.4, (12.54), (12.58), pp. 285–286. Under actual support inclusion both bounds apply to the same class/prior/finite KL. The polynomial denominator uses the ambient alphabet, even when inclusion is strict.

**Consumer.** direct source reference in the listed permanent caller(s). [TypeClassProbability L221](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L221) · [TypeClassProbabilityInterface L118](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L118)

**Binder order.** `{A}`, `[instance]`, `{n}`, `[instance]`, `[instance]`, `hn`, `t`, `p`, `h`.

```lean
theorem LeanInfoTheory.Shannon.exp_neg_klDiv_div_pow_le_iid_toOuterMeasure_typeClass.{u} : ∀ {A : Type u}
  [inst : Fintype.{u} A] {n : ℕ} [inst_1 : MeasurableSpace.{u} A] [MeasurableSingletonClass.{u} A] (hn : LT.lt.{0} 0 n)
  (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)) (p : PMF.{u} A),
  PMF.support.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t) ⊆ PMF.support.{u} p →
    LE.le.{0}
      (HDiv.hDiv.{0, 0, 0}
        (Real.exp
          (HMul.hMul.{0, 0, 0} (Neg.neg.{0} ↑n)
            (InformationTheory.klDiv.{u} (PMF.toMeasure.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t))
                (PMF.toMeasure.{u} p)).toReal))
        (HPow.hPow.{0, 0, 0} (HAdd.hAdd.{0, 0, 0} (↑n) 1) (Fintype.card.{u} A)))
      ((PMF.toOuterMeasure.{u} (PMF.iid.{u} p n)) ↑(LeanInfoTheory.Shannon.typeClass.{u} t)).toReal
```

</details>

<details>
<summary><code>LeanInfoTheory.Shannon.iid_toOuterMeasure_typeClass_eq_zero_of_not_support_subset</code></summary>

A type class has zero iid probability if its empirical law gives positive mass to a symbol outside the sampling support.

**C39.04** · new mathematical theorem. Import `LeanInfoTheory.Shannon.TypeClassProbability`. [Definition](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L200) · [Approved step](../../docs/plans/release-3-chunk-39.md#L308) · [Handoff](../../docs/handoffs/chunk-39.md#L125)

**Source and limits.** CT91 §2.3, (2.26)–(2.27), p. 18; §12.1 Thms 12.1.2, 12.1.4. An observed zero-prior label makes actual ENNReal class probability zero without a measurable-space instance. Canonical KL top uses its separate earlier theorem; no real exponential at top.

**Consumer.** direct source reference in the listed permanent caller(s). [TypeClassProbability L483](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L483) · [TypeClassProbabilityInterface L147](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L147)

**Binder order.** `{A}`, `[instance]`, `{n}`, `hn`, `t`, `p`, `h`.

```lean
theorem LeanInfoTheory.Shannon.iid_toOuterMeasure_typeClass_eq_zero_of_not_support_subset.{u} : ∀ {A : Type u}
  [inst : Fintype.{u} A] {n : ℕ} (hn : LT.lt.{0} 0 n) (t : ↥(LeanInfoTheory.Shannon.wordTypes.{u} A n)) (p : PMF.{u} A),
  ¬PMF.support.{u} (LeanInfoTheory.Shannon.empiricalPMF.{u} hn t) ⊆ PMF.support.{u} p →
    Eq.{1} ((PMF.toOuterMeasure.{u} (PMF.iid.{u} p n)) ↑(LeanInfoTheory.Shannon.typeClass.{u} t)) 0
```

</details>

### Reused release declarations

| Qualified name and focused import | Caller |
| --- | --- |
| [LeanInfoTheory.Shannon.klDiv_pmf_ne_top_iff_support_subset](../../LeanInfoTheory/Shannon/SemanticBridge/KL.lean#L89) · `LeanInfoTheory.Shannon.SemanticBridge.KL` | [TypeClassProbability L47](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L47) |
| [LeanInfoTheory.Shannon.klDiv_pmf_eq_top_iff_not_support_subset](../../LeanInfoTheory/Shannon/SemanticBridge/KL.lean#L108) · `LeanInfoTheory.Shannon.SemanticBridge.KL` | [TypeClassProbability L488](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L488) |
| [PMF.finiteProduct_apply](../../LeanInfoTheory/Probability/FiniteProduct.lean#L54) · `LeanInfoTheory.Probability.FiniteProduct` | [TypeClassBounds L109](../../LeanInfoTheory/Shannon/TypeClassBounds.lean#L109) |
| [PMF.mem_support_finiteProduct_iff](../../LeanInfoTheory/Probability/FiniteProduct.lean#L60) · `LeanInfoTheory.Probability.FiniteProduct` | [TypeClassProbability L213](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L213) |

<details><summary>Compiled signatures of the reused declarations</summary>

```lean
theorem LeanInfoTheory.Shannon.klDiv_pmf_ne_top_iff_support_subset.{u} : ∀ {alpha : Type u} [Finite.{u + 1} alpha]
  [inst : MeasurableSpace.{u} alpha] [MeasurableSingletonClass.{u} alpha] (p q : PMF.{u} alpha),
  Ne.{1} (InformationTheory.klDiv.{u} (PMF.toMeasure.{u} p) (PMF.toMeasure.{u} q)) Top.top.{0} ↔
    PMF.support.{u} p ⊆ PMF.support.{u} q
theorem LeanInfoTheory.Shannon.klDiv_pmf_eq_top_iff_not_support_subset.{u} : ∀ {alpha : Type u} [Finite.{u + 1} alpha]
  [inst : MeasurableSpace.{u} alpha] [MeasurableSingletonClass.{u} alpha] (p q : PMF.{u} alpha),
  Eq.{1} (InformationTheory.klDiv.{u} (PMF.toMeasure.{u} p) (PMF.toMeasure.{u} q)) Top.top.{0} ↔
    ¬PMF.support.{u} p ⊆ PMF.support.{u} q
theorem PMF.finiteProduct_apply.{u, v} : ∀ {I : Type u} {A : I → Type v} [inst : Fintype.{u} I]
  [inst_1 : (i : I) → Fintype.{v} (A i)] (p : (i : I) → PMF.{v} (A i)) (x : (i : I) → A i),
  Eq.{1} ((PMF.finiteProduct.{u, v} p) x) (∏ i, (p i) (x i))
theorem PMF.mem_support_finiteProduct_iff.{u, v} : ∀ {I : Type u} {A : I → Type v} [inst : Fintype.{u} I]
  [inst_1 : (i : I) → Fintype.{v} (A i)] (p : (i : I) → PMF.{v} (A i)) (x : (i : I) → A i),
  Membership.mem.{max u v, max u v} (PMF.support.{max u v} (PMF.finiteProduct.{u, v} p)) x ↔
    ∀ (i : I), Membership.mem.{v, v} (PMF.support.{v} (p i)) (x i)
```

</details>

### Private and example results

- Class mass zero iff canonical KL top, obtained by cases from supported theorems; this is a private example and is not a sixth C39 theorem. [TypeClassProbabilityInterface L173](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L173)
- A permanent caller constructs the index from raw counts and obtains the exact class mass with its cardinality multiplier. [raw_counts_class](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L199)
- A permanent caller starting from an independent denominator-witnessed PMF recovers that same law, proves canonical KL finite, and obtains the exact mass of the original class. [supplied_law_class](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L210)

## Reused mathlib constructions

The pinned mathlib revision supplies four constructions used directly at these locations. Each link identifies the exact dependency source.

- `InformationTheory.kraft_mcmillan_inequality`. [Pinned mathlib](https://github.com/leanprover-community/mathlib4/blob/0df444a360eaa60ab8c11dca51a86af692955474/Mathlib/InformationTheory/Coding/KraftMcMillan.lean#L145) · [Project caller](../../LeanInfoTheory/Shannon/PrefixCode.lean#L85)
- `Finset.piAntidiag`. [Pinned mathlib](https://github.com/leanprover-community/mathlib4/blob/0df444a360eaa60ab8c11dca51a86af692955474/Mathlib/Algebra/Order/Antidiag/Pi.lean#L106) · [Project caller](../../LeanInfoTheory/Shannon/WordType.lean#L56)
- `Nat.multinomial`. [Pinned mathlib](https://github.com/leanprover-community/mathlib4/blob/0df444a360eaa60ab8c11dca51a86af692955474/Mathlib/Data/Nat/Choose/Multinomial.lean#L69) · [Project caller](../../LeanInfoTheory/Shannon/TypeClassCardinality.lean#L97)
- `InformationTheory.klDiv`. [Pinned mathlib](https://github.com/leanprover-community/mathlib4/blob/0df444a360eaa60ab8c11dca51a86af692955474/Mathlib/InformationTheory/KullbackLeibler/Basic.lean#L57) · [Project caller](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L43)

