# Chunk 39 — General-prior iid type probabilities and finite-KL bounds

The persistent reviewer assessed all eighteen criteria against review source `64ad6be12afbc161eaa11ba42977cbb551d237a7707f6a60c683cfd4097b3c70`. Parent reconciliation `688ad740d6a70cbc4a38feccf78e10367e3ffd5c18d6f0f225b9c9e7e53084c6` records agreement with original report `0b343eaa003ec7bdbca0cdc38b0d51728539ed4f2822cbbf9b0f0fb9a87b5ae5`. The reviewer independently compiled the focused-only caller, including raw-count paired bounds, and checked all five theorem signatures and axiom sets. The compile passed in 397.08 seconds. The reviewer also reproduced the four fixture calculations and checked 433 source files, 117 evidence artifacts, and the five signatures and file/line links in the handoff. The full builds and trust audit were parent executions. Two reviewer inspection attempts failed, one while comparing file lists and one while printing Unicode. Their corrected checks passed, and the original failures remain in the report. Neither affected a mathematical criterion. The cumulative index `.lake/compatibility/c39-06-validation-20261124/index.json` has SHA-256 `c825ad070ec713e7dd727f2ff18a934c3977ebbc7dacde709ada3cd470069820`. Final applicability checks are in `.lit-review/setup/c39-06-20261124/final-checks.json`. The supported private `completion.json` supplies the final source and closure identity.

**Cumulative validation, 24 November 2026.** The primary checkout passed the warning-as-error builds, both released compatibility comparisons, full trust and all-project axiom audit, documentation, and a separate focused-import caller. The [step notes](../plans/release-3-chunk-39-notes.md) identify the original evidence. The supported private receipt determines C39 closure.

C39 delivers five theorems for positive-length words and their type classes under an arbitrary iid sampling law. C37 supplies the index and the class, C38 supplies both cardinality bounds, and the existing KL API separates finite and infinite divergence. The two focused example modules exercise the public results.

[Approved revision 2](../plans/release-3-chunk-39.md) · [Implementation and review notes](../plans/release-3-chunk-39-notes.md) · [C38 prerequisites](chunk-38.md) · [C37 count/law contract](chunk-37.md)

## Exact public contracts and imports

The owner is `LeanInfoTheory.Shannon.TypeClassProbability`, in namespace `LeanInfoTheory.Shannon`. These are its five source signatures. The first four use the finite discrete measurable structure required by canonical KL. The zero-event theorem has no measurable-space hypotheses. No public `DecidableEq`, `Nonempty`, full-support, positive-entropy or extra nonzero-atom assumption is added. Every empirical-law contract retains `hn : 0 < n`.

```lean
open scoped BigOperators ENNReal
universe u
variable {A : Type u} [Fintype A] {n : ℕ}

section KL
variable [MeasurableSpace A] [MeasurableSingletonClass A]

theorem iid_apply_of_mem_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support)
    {x : Fin n → A} (hx : x ∈ typeClass t) :
    ((PMF.iid p n) x).toReal =
      Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
        (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal))

theorem iid_toOuterMeasure_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support) :
    ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal =
      ((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
          (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal))

theorem iid_toOuterMeasure_typeClass_le_exp_neg_klDiv
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support) :
    ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal ≤
      Real.exp (-(n : ℝ) *
        (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal)

theorem exp_neg_klDiv_div_pow_le_iid_toOuterMeasure_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support) :
    Real.exp (-(n : ℝ) *
        (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal) /
        ((n : ℝ) + 1) ^ Fintype.card A ≤
      ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal
end KL

theorem iid_toOuterMeasure_typeClass_eq_zero_of_not_support_subset
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : ¬ (empiricalPMF hn t).support ⊆ p.support) :
    (PMF.iid p n).toOuterMeasure (typeClass t) = 0
```

For `q := empiricalPMF hn t`, actual support inclusion proves `InformationTheory.klDiv q.toMeasure p.toMeasure ≠ ⊤` through existing `klDiv_pmf_ne_top_iff_support_subset`. Its real value is used only in that finite branch. The singular KL conclusion uses existing `klDiv_pmf_eq_top_iff_not_support_subset`; no duplicate divergence, public KL alias or sixth C39 theorem is added. Entropy and divergence use nats. The polynomial exponent is the ambient `Fintype.card A`, including unused labels.

| Owner or entry point | Exact local imports / reachability | Boundary |
| --- | --- | --- |
| [TypeClassProbability](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L12) | `LeanInfoTheory.Shannon.TypeClassBounds`; `LeanInfoTheory.Shannon.SemanticBridge.KL` | Five supported theorems; only private proof helpers. |
| [Numerical consumer](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L12) | Only `LeanInfoTheory.Shannon.TypeClassProbability` | Private fixtures; no earlier example imports. |
| [Generic interface consumer](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L12) | Only `LeanInfoTheory.Shannon.TypeClassProbability` | Private arbitrary-law/count callers; no numerical-example helpers. |
| [Full Shannon umbrella](../../LeanInfoTheory/Shannon.lean#L53) | Imports the focused owner | Import-only complete mathematical stack. |
| [Examples aggregate](../../LeanInfoTheory/Examples.lean#L61) | Imports both new example owners | Development aggregate, excluded from both supported umbrellas. |
| [Lightweight root](../../LeanInfoTheory.lean#L12) | Only `Probability.Finite` and `InformationMeasures` | No new import/export; retained direct/closure/export counts 2/5/92. |

Approved C39 growth is exactly five declarations and one supported module over C38's 913/76: 918 declarations in 77 supported modules, with the same 94 reviewed simp names. C39 adds no public definition, structure, instance, alias or simp attribute. These counts summarize the prior successful compiled audit; current cumulative applicability must be attached below, not inferred from matching counts.

## One count index, one class, two entry routes

For raw counts `c : A → ℕ` and `hc : (∑ a, c a) = n`, construct `t := ⟨c, (mem_wordTypes c).2 hc⟩ : ↥(wordTypes A n)`. For a word `x`, use `wordType x` and `mem_typeClass`. Labels are unchanged; C37's permutation invariance reorders word positions. C38 supplies exact multinomial cardinality and both entropy bounds on this identical index.

At positive length, `empiricalPMF_apply hn t a` gives `(t.val a : ENNReal)/(n : ENNReal)`, and `mem_support_empiricalPMF_iff hn t a` identifies positive counts with actual support. `mem_typeClass_iff_empiricalPMF_eq hn` recognizes the same class through empirical-law equality. No second law-indexed class is introduced.

For an independently supplied law, use the existing equivalence:

```lean
wordTypeEquivPMF hn :
  ↥(wordTypes A n) ≃
    {q : PMF A // ∃ c : A → ℕ, (∑ a, c a) = n ∧
      ∀ a, q a = (c a : ℝ≥0∞) / (n : ℝ≥0∞)}
```

Its inverse takes the supplied law and exact denominator witness. `apply_symm_apply` followed by `congrArg Subtype.val` recovers that law; `wordTypeEquivPMF_apply` gives the forward equation. The denominator need not be least. The [raw-count caller](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L199) and [independent-law caller](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L210) reach the same event without changing counts, denominator or support assumptions.

The count and exact-cardinality layer remains meaningful at zero length, including the empty alphabet. The empirical layer does not. Retained [C37 zero/Empty consumers](../../LeanInfoTheory/Examples/WordType.lean#L295) and [C38 all-length consumers](../../LeanInfoTheory/Examples/TypeClass.lean#L81) remain the relevant checks. No zero-length empirical PMF or global nonempty-alphabet premise is manufactured.

## Finite and singular endpoint composition

One word has real mass `exp(-n*(H(q)+D(q||p).toReal))`. The whole class has that common mass multiplied once by its cardinality. Only then do C38's bounds cancel entropy and produce the KL-only interval. A KL-only class bound is not an exact atom formula.

The [word proof](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L67) groups iid coordinates by counts and separates zero counts before logarithmic cancellation. Both unused positive-prior labels and unused common-null labels contribute factor one. Positive-count terms obtain positive sampling mass from actual support inclusion. The private entropy/KL identity first establishes canonical non-top and then uses the supported finite KL sum.

The [class proof](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L138) sums over the existing finset, using finite PMF atoms to guard real conversion. The [ENNReal recovery caller](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L72) separately proves finite event mass and nonnegative real right-hand sides before using `ENNReal.toReal_eq_toReal_iff'` and `ENNReal.toReal_ofReal`. Unrestricted `toReal` injectivity is never used.

For failed inclusion, the [zero-event proof](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L200) finds a positive-count label outside prior support. Every class word has a coordinate with that label. Public finite-product support shows the class disjoint from iid support, and `PMF.toOuterMeasure_apply_eq_zero_iff` gives actual ENNReal zero. This argument uses neither the finite real formula nor a conversion at infinite KL.

The interface supplies a [positive-count/zero-prior witness](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L149) and [direct failed inclusion](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L164), each assembling actual event zero and canonical top. Its [private generic equivalence](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L173) has no support premise:

```lean
(PMF.iid p n).toOuterMeasure (typeClass t) = 0 ↔
  InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure = ⊤
```

Here positive length and the finite discrete measurable structure remain explicit. For the forward implication, support inclusion would give a strictly positive finite-branch lower bound; rewriting the given ENNReal zero gives real zero and a contradiction. For the reverse implication, canonical top gives failed inclusion and the public zero-event theorem applies. No ENNReal zero is inferred from a real zero, and no KL exponential is evaluated at top. This remains a private integration check.

## Permanent consumers

All numerical fixtures use [Examples.TypeClassProbability](../../LeanInfoTheory/Examples/TypeClassProbability.lean), with direct finite-product calculations separate from the public entropy/KL formulas.

| Fixture | Exact checked outcomes and source anchors |
| --- | --- |
| Fair Boolean `(1/2,1/2)`, n=3, counts `(2,1)` in `(false,true)` order | [Class](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L276) `{001,010,100}`, cardinality 3. [Actual word/event masses](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L330) 1/8 and 3/8. [Formulas/factor 3](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L355) and [both bounds](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L375), with denominator 4². |
| Deterministic Boolean `(1,0)`, same class | [Observed null label](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L462) true has count 1. [Every class word](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L472) and [whole class](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L481) have actual mass 0; [canonical KL](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L486) is top. |
| Sparse Fin3 `(1/2,1/2,0)`, n=2, counts `(2,0,0)` | [q=pure0](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L67), [strict inclusion](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L83), [class={00}](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L130), actual word/event mass 1/4. [Guarded KL](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L181) has real value log2. [Ambient bounds](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L216) give `1/108 ≤ 1/4 ≤ 1/4`. [Label1 versus label2](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L104) distinguishes unused positive prior from common-null. |
| Biased full-support Boolean `(3/4,1/4)`, same binary class | [Full support/distinctness from q](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L316); [word/event](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L388) 9/64 and 27/64. [Finite KL](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L421) is `(2/3)*log(8/9)+(1/3)*log(4/3)` in real value. [Both formulas/bounds](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L434) apply to that same class. |

The [separate interface](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L39) covers supplied indices, wordType, both count/law routes, guarded ENNReal recovery, paired bounds and both singular interfaces. Its [own-law comparison](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L234) directly composes C39 and C38 formulas on the same atom/event; [own-law bounds](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L121) reduce to `1/(n+1)^k` and 1 with canonical self-KL zero. [Positive-length pure/Unit](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L292) and [n=1 under arbitrary supported prior](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L326) preserve the empirical boundary. The n=1 caller checks actual word/event mass `p a` as well as the guarded exponential.

## Source interpretation and compiler ownership

CT91 is Cover and Thomas, *Elements of Information Theory*, Wiley, 1991, as registered in [references](../references.md#ct91-cover-and-thomas).

| Source locator | C39 use and adaptation |
| --- | --- |
| §12.1 Theorem 12.1.2, (12.7)–(12.14), printed 281 / PDF 303 | One-word mass from iid product and counts. Source empirical P/sampling Q become library q/p. Bits/powers2 become nats/Real.exp. |
| §12.1 Theorem 12.1.4, (12.54)–(12.58), printed 285–286 / PDF 307–308 | Sum over the class, exactly one cardinality factor, then KL bounds. Theorem 12.1.3's cardinality input was delivered independently in C38; ambient exponent is retained. |
| §2.3, (2.26)–(2.27), printed 18 / PDF 40 | Zero-numerator convention and infinity for positive empirical mass over zero prior. Formalization separates supported finite KL from actual zero event/canonical infinity. |

The registered PDF SHA-256 is `16f016eafbb1160c2d8e6c29ff28db870e0eb2e61c15ea39bea5b06d463a952f`, rechecked at cumulative validation. Original records distinguish text inspection from reviewer-reported visual inspection; the cumulative parent used extracted text from the specified pages. Fixtures are project calculations. The private iff follows from the delivered lower bound, singular theorem and canonical support characterization, not an additional textbook theorem. No Sanov, asymptotic package, support-size sharpening or Stirling estimate is required.

C38's documented iid correction remains important: use definitional `change` to `PMF.finiteProduct` and its public application theorem rather than unfolding/simplifying imported `PMF.iid`. C39 follows this in its producer and direct calculations. It adds no ownership of `PMF.iid.eq_1`; pre-existing owners elsewhere are preserved.

C39.05 found that simplifier traversal in the new interface materialized `wordType.eq_1` and `wordTypeEquivPMF.congr_simp`, duplicating C38-owned imported names. Definitional count reduction and explicit law-equality rewriting fixed this. Final Step 5 raw owners contain 101 numerical and 18 interface constants, all private; the full Examples aggregate resolves both old names to `LeanInfoTheory.Examples.TypeClass`. Two redundant Fin3 local measurable instances were replaced by mathlib's identical discrete instances. These are proof-body/elaboration adjustments, with unchanged public types, assumptions, pins and C38 sources. Original failed/discrepant observations remain preserved.

## Eighteen-criterion evidence navigation

Each row identifies a source or caller that exercises the approved criterion. The final section records the cumulative validation, independent review and source applicability for these results.

| Criterion | Source, concrete outcome and cumulative evidence requirement |
| --- | --- |
| **C39.01-RETAIN** | [Current API](../current-public-api.json) and [reviewed policy](../compatibility/current-api-policy.json): retain all original C38 913 structural rows and both historical 601/811 contracts; exactly the five signatures above are growth. Step 5 retained all incoming 918 without further growth. The cumulative export and boundary comparison are identified below. |
| **C39.01-OWNER** | [Producer imports](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L12), [Shannon entry](../../LeanInfoTheory/Shannon.lean#L53), [root](../../LeanInfoTheory.lean#L12): one focused owner, no backwards/Examples dependency, root 2/5/92 and simp 94 retained. Raw-owner audit includes generated auxiliaries before classification and both private consumers. |
| **C39.01-WORD** | [Word theorem](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L67), [KL guard](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L41), [index/word callers](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L39), [unused labels](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L104): exact atom formula under actual support inclusion; zero counts handled before logs. |
| **C39.02-CLASS** | [Class theorem](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L138), [ENNReal recovery](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L72), [sparse singleton/mass](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L130): original finset, single cardinality multiplier, actual mass 1/4, finite/nonnegative conversion guards. |
| **C39.03-UPPER** | [Upper theorem](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L170): C38 cardinality upper bound, class identity and positive exponential; no positive-entropy/full-support premise. [Paired caller](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L106) keeps the same event. |
| **C39.03-LOWER** | [Lower theorem](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L184): C38 lower bound and entropy cancellation preserve `((n:Real)+1)^Fintype.card A`; [sparse endpoint](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L216) distinguishes ambient size 3 from support size 1. |
| **C39.04-ZERO** | [Actual zero event](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L200), [caller omitting measurable assumptions](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L143), [observed-count caller](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L149): failed inclusion excludes every class member from iid support. |
| **C39.04-TOP** | [Canonical top](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L164), [positive-length iff without support premise](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L173): actual zero iff canonical top, with positive guarded lower bound for the converse; no infinite real exponential. |
| **C39.05-FAIR** | [Three-word class](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L276), [masses](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L330), [factor/bounds](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L367): word mass 1/8, class mass 3/8, factor 3 and both KL bounds at n3/counts(2,1). |
| **C39.05-SINGULAR** | [Witness/direct word proof](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L462), [class/KL](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L481): identical class under `(1,0)`, every member actual mass 0, class mass 0 and canonical top. |
| **C39.05-SPARSE** | [q=pure0](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L67), [strict inclusion](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L83), [guarded log2](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L181), [bounds](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L216): singleton class, word/event mass 1/4 and `1/108 ≤ 1/4 ≤ 1/4`; both kinds of unused labels explicit. |
| **C39.05-BIASED** | [Full support/distinct law](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L316), [masses](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L388), [KL/formulas/bounds](../../LeanInfoTheory/Examples/TypeClassProbability.lean#L421): word mass 9/64, class mass 27/64, weighted log-ratio value, both formulas and bounds. |
| **C39.05-CALLER** | [Focused-only interface](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L12): index, wordType, raw-count and independent exact-denominator-law routes; guarded ENNReal recovery, paired bounds, singular conjunction and iff. Step 5's separately authored caller used supported imports only. The cumulative validation recompiles the external caller on the current source. |
| **C39.05-BOUNDARY** | [Own-law agreement](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L234), [pure/Unit](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L292), [n1](../../LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean#L326), [C37 zero/Empty](../../LeanInfoTheory/Examples/WordType.lean#L295), [C38 all-length](../../LeanInfoTheory/Examples/TypeClass.lean#L81): positive empirical boundary; no unnecessary Nonempty/full-support assumptions. |
| **C39.06-VALIDATE** | [Cumulative criteria](../plans/release-3-chunk-39.md#c3906--cumulative-qualification-fresh-review-and-c40-handoff): owner/consumer/aggregate builds, generated/static checks, original 913+five and both releases, raw-owner/import/focused/full/root/simp audit, complete maintained trust/all-project axioms, documentation and independent caller. Original receipts and source, configuration and pin applicability are recorded below. |
| **C39.06-RECONCILE** | [Summary](../lean-info-theory-living-summary.md), [notes](../plans/release-3-chunk-39-notes.md), [log](../project-log.md), [references](../references.md), [map](../plans/release-3-chunk-map.md): align source/contracts/growth/status, preserve ownership-failure dispositions and four separate clean-checkpoint obligations. Independent review and final-source reconciliation are recorded separately. |
| **C39.06-HANDOFF** | This document supplies exact contracts/imports, both count/law routes, finite/singular callers, fixtures, source adaptations, ownership decisions, C40 ledger and remaining owners/triggers. The final section records validation and review identities. C40 requires separate authorization. |
| **C39.06-REVIEW** | This eighteen-row matrix and [approved plan](../plans/release-3-chunk-39.md) define the cumulative candidate. Obtain fresh independent assessment of the complete endpoint, preserve original report and substantive reconciliation/dispositions, then establish R-to-F applicability. Earlier reviews cannot replace this assessment. |

## C40 endpoint ledger and qualification boundaries

C39 supplies the sixth package's source endpoint; programme integration requires its own approved plan and selected steps. C40 derives its ledger from final approved contracts and maintained handoffs, not an assumed declaration quota.

| C40 entry | Contract and required consumer / limit |
| --- | --- |
| Counts, realization and cardinality | [C37](chunk-37.md), [C38](chunk-38.md): identical admissible index, realized finset and positive-length empirical law. Preserve all-length combinatorics separately from normalization. |
| General-prior word/class probabilities | First two signatures above: every positive n, admissible t, prior p and actual inclusion. Preserve atom/event distinction and exactly one cardinality factor. External callers should enter through both raw counts and an independently supplied denominator-witnessed law. |
| Finite-KL interval | Next two signatures preserve actual inclusion and ambient exponent. Exercise strict inclusion and sparse 1/108. Full support is unnecessary. |
| Singular endpoint | Fifth signature plus existing canonical KL characterization. Actual zero event needs no measurable-space hypotheses; KL composition does. Exercise witness and failed-inclusion routes and independently derive zero-event iff KL-top from supported APIs. |
| Other five packages | [C26 testing](chunk-26.md), [C30 one-shot coding](chunk-30.md), [C32 operational capacity/expurgation](chunk-32.md), [C34 separation](chunk-34.md), [C36 prefix ledger](chunk-36.md#c40-endpoint-ledger). Preserve each exact final quantifier/witness contract, focused import, source adaptation, consumer, validation identity and limit. C39 adds no coding theorem or backwards required dependency. |

Qualify **both integration routes**: finite testing in isolation, and the full information-density → random-coding → operational-capacity → source-channel-separation chain. Audit quantifier order and witness scope in C26/C31/C32/C34/C36. Exercise prefix lengths and type probabilities in a separate external project against the exact candidate commit using supported focused APIs. C39 development probes do not discharge that exact-candidate milestone.

Retain **both immutable historical contracts**, 601 declarations for v0.1.0 and 811 for v0.2.0, with actual types, binders, universes, kinds, owners, imports, root exports and reviewed attributes. Generated inventory does not grant growth approval. C39 also carries sealed C38 original 913 plus exactly five approved additions. Reused evidence needs source/configuration/pin and structural applicability; matching only HEAD, counts or names is insufficient. Complete maintained trust and the all-project axiom audit allow only `propext`, `Classical.choice` and `Quot.sound`.

C36, C37, C38 and C39 clean-checkpoint suite/hygiene qualifications remain **four separate obligations**. Their mathematics and scoped completions are not reopened by these limits. Only a separately authorized exact clean committed candidate can pass the default clean suite/hygiene; repeat after amendments. This handoff grants no commit authority.

C40 documentation is qualification, not deployment. Preserve `/LeanInfoTheory/docs/v0.1.0/`, `/LeanInfoTheory/docs/v0.2.0/` as the entry point, and the separate `/LeanInfoTheory-API/v0.2.0/` immutable snapshot. The prior split preview measured 661,575,985 bytes for the main site and 655,316,062 for the separate API site; these are historical measurements, not Release 3 size evidence. Measure each complete proposed host against the 1,000,000,000-byte guard, including snapshots, dependencies, search assets and selectors. Record artifacts, bytes/headroom and check actual project-subpath navigation, anchors, search and source links. If co-hosting is oversized, qualify a stable separate snapshot or separately review an alternative; never overwrite old routes or relax the guard.

Leave the existing promotion workflow and its version-specific source/bundle/archive pins unchanged. Future promotion needs explicit authority and pin review. Final source/metadata amendments require clean suite, retained comparisons and exact-SHA external-consumer requalification; API-input/link-mode changes require regeneration and attestation rechecks. Final publication composition needs fresh sizes, digests, permanent-route and public-commit-link checks. Local previews are not hosted/publication evidence. C40 closure does not choose version/date/DOI, provision sites, repin live workflows or publish.

## Historical evidence, source identity and remaining work

These receipts establish their own scoped step completions. They do not establish cumulative C39.06 qualification by inheritance.

The predecessor mathematics is closed under its own inspected supported records:

| Predecessor | Scoped cumulative closure | Outstanding qualification |
| --- | --- | --- |
| C36.06 | `4fc4ee595fde988debd5d3b7170baab475f05105b2802fa00cde4ab47067b09c` | Its complete clean-checkpoint suite and hygiene, separately authorized. |
| C37.07 | `5757260db89c5bb06ed280b4d88256cf24db8abc8c5feb3f8b7bc01512bc93b1` | Its own complete clean-checkpoint suite and hygiene. |
| C38.06 | `eb8e38e499788244176aaf1451e804cfc605ff1a2e496cb7dd5acf223b61943c` | Its own complete clean-checkpoint suite and hygiene, preserving the corrected source lineage. |

The original records are `.lit-review/setup/c36-06-20261117/completion.json`, `.lit-review/setup/c37-07-20261117/completion.json` and `.lit-review/setup/c38-06-20261118/completion.json`. C39 does not reopen that mathematics or transfer these outstanding qualifications to a different chunk.

| Step | Scoped closure | Exact F capture |
| --- | --- | --- |
| C39.01 | `1238e91af6fe2ee3711b50b2a2b0010deb7dd7e269fd2c32c5507d7d49a625ae` | `b373c17910291e2c144ac7719af6fabfbafdf721934c8a621a54a12a108bb55c` |
| C39.02 | `0db11584267defb2838c6d07c3adde3353b2ec26c5cd2e7556d7708321709a9e` | `782d58cbce7b4d69ae6c08afb41ce17d4f0a31e8ed358b5fe374b0d61b708736` |
| C39.03 | `c85ac2d389d42af6300cae8801f331c1cb26843ad6db6e73b3775e53369bb233` | `94d2ba310b3ccab91d3f773b989779c07d66135c9d364d4046e038ab4f6001c8` |
| C39.04 | `97345eb57f8b22a77e978e93e7a2d77ec4686271ba5e04e014bee8d9f730ec02` | `4afc323e12e13d6abd3f3359771b2e483ccec86b18926b5a69c5604ea6672f68` |
| C39.05 | `9d5f2fb39e1e6f84ff07065cdd9c6fa2a67cddd81e210aada3a1c553c0bec735` | `edf5b336aebe3691d24ba41afacbdd8d1142fdcf67ed55c2f45a398dcecd92e9` |

Original step records are under `.lit-review/setup/c39-01-20261119/`, `c39-02-20261120/`, `c39-03-20261123/`, `c39-04-20261124/` and `c39-05-20261124/`. Step 5 validation is indexed at `.lake/compatibility/c39-05-validation-20261124/index.json`. Its final raw owners report 101/18 private constants; aggregate inspection preserves the original C38 resolution of both generated names. Its maintained comparison retains all 918 incoming and original 913 rows, both released contracts, root 2/5/92, simp 94 and nine dependency states. This is attributed prior evidence, not newly executed C39.06 validation.

Step 5 original report `6d57320d1e6858deb3ed31ef2340b515514ec6827f4d10e1b7329d19aa1ab8b2` assesses all six selected criteria satisfied; parent reconciliation `0c024172a40ac6c5888080d02485fbf4786ae5f77cbeeb57a999f68413cf3fd6` agrees. Preserve failed development probes, the initial ownership discrepancy, corrections and reviewer-reported attempts. In particular, C39.04's reviewer caller timed out and remains recorded as FAIL; its successful criterion assessment relied on the other original evidence identified in that report. Do not relabel an earlier failed attempt as passing after a correction.

The persistent C39 reviewer is `/root/c39_reviewer`, requested as `gpt-6-astra`/`ultra` with `fork_turns="none"`, the exposed mapping of `fork_context=false`. Effective settings remain unobservable; cooperative read-only instructions are not OS isolation. Preserve original native creation, report and reconciliation records. This handoff creates no reviewer and transfers no independent-review role to implementation helpers.

Source fingerprints checked against the cumulative candidate:

| Source | SHA-256 |
| --- | --- |
| `LeanInfoTheory/Shannon/TypeClassProbability.lean` | `c7bad3d9a5687099e0b88a7c31ac0373bacaab4632a25f5e9e1488e35353c07c` |
| `LeanInfoTheory/Examples/TypeClassProbability.lean` | `be592ecbf6808845f21a8f524557e8f6507194e74178689e5ce71ceb487ab496` |
| `LeanInfoTheory/Examples/TypeClassProbabilityInterface.lean` | `1d47d6179fe9450028d9040d89177577db4e321bd6d39dd00422ca83bc99deef` |

| Remaining item | Owner and trigger / disposition |
| --- | --- |
| C39.06 cumulative builds, structure/boundary/trust/documentation/caller checks, all eighteen review, canonical reconciliation, R-to-F applicability and closure | Current implementation parent under the selected final step. The final section points to the original evidence, reconciliation and closure records. No required C39 mathematics is deferred here. |
| C36 complete clean-checkpoint suite/hygiene | Lead plus separately authorized checkpoint executor on an exact clean committed candidate; preserve its own source/evidence and rerun after amendments. Mathematics stays closed. |
| C37 complete clean-checkpoint suite/hygiene | Same separate ownership/trigger, with its own evidence. C38/C39 dirty-tree checks do not discharge it. |
| C38 complete clean-checkpoint suite/hygiene | Same separate ownership/trigger; preserve corrected C38 source lineage and actual completion identity. |
| C39 complete clean-checkpoint suite/hygiene | Separate exact clean committed C39 authorization; distinct from dirty-tree cumulative qualification. |
| All-package ledger, both integration routes, exact-candidate consumer, candidate API docs and whole-host size feasibility | Separately approved C40 plan and selected steps. Keep required gaps and explicit limits; C39 supplies its endpoint without starting C40. |
| Public alias/helper, support-size sharpening, sharper polynomial, Sanov/large deviations, Stirling/second-order package | Optional extensions deferred pending concrete consumer pressure and separately approved scope. No required endpoint is moved here. |
| Extra normalization of the sparse prior over all length-two types | Optional advisory idea deferred; reconsider for concrete type-event aggregation consumer pressure. Not an automatic C40 requirement. |
| Commit, push, publication, Desktop folders, release version/date/DOI, pins or live workflow/site changes | Separate explicit lead authorization; none follows from this handoff or C39 closure. |

## Cumulative validation and review records

The private execution directory is `.lit-review/setup/c39-06-20261124/`. The neutral index `.lake/compatibility/c39-06-validation-20261124/index.json` identifies each original command, output, source map and outcome. The `compatibility` and `trust` entries refer to separately executed maintained comparisons. Both recover all 601 and 811 released declarations, the original 913 pre-C39 structural rows and the five C39 additions. The cumulative audit also compares the incoming Step 5 export and the raw module boundaries. All 918 declarations in 77 supported modules match, with 94 reviewed simp declarations, two root imports, five reachable root modules and 92 root exports.

The `focused` entry covers all eight maintained targets plus the individual C37–C39 modules and consumers. The `trust` entry includes the independent historical comparison and the all-project axiom audit. The `documentation` entry covers release documentation and five README and four website-guide examples, each independently compiled with warnings as errors. The `caller` entry independently compiles the focused-only raw-count and denominator-witnessed caller in the current checkout. Separate entries preserve the raw example and aggregate owner checks, exact fixture enumeration and nonmutating generated/static checks. The cumulative methodology compares producer inputs, the development controls, checkout state and all nine dependency pins.

The fresh independent review is recorded against its own source capture. Final applicability and closure are recorded by the supported private procedure after reconciliation. The four clean-checkpoint obligations above remain separate.

| Compiled evidence | Original path | SHA-256 |
| --- | --- | --- |
| Released comparisons | `.lake/compatibility/f215679915e441778d0e297dde72f745/result.json` | `1201082b0929dc2be94178236039f78262c29a5a34e7c377bc1fdb7ee9ce79de` |
| 918 current structural rows | `.lake/compatibility/f215679915e441778d0e297dde72f745/candidate-types.stdout` | `6686d822c4c8a3cda892261adce7e98ab60976ab52f46fd5011fe4f4ca72c1f2` |
| Raw module boundaries | `.lake/compatibility/f215679915e441778d0e297dde72f745/boundaries.stdout` | `fc64c08577394d18c65f3b1e339f79174e7f0e082fe78beab73a1f79703c6929` |
| Comparison repeated by trust | `.lake/compatibility/ee7cb192df9a4153b56699fd62e86b96/result.json` | `50755691bc311f1787008d47df46502aa4411ae6c26dc365a7a0448c9db673d8` |

The all-project audit examined 5,173 local constants in 149 modules. The axioms were `propext`, `Classical.choice` and `Quot.sound`.
