# Chunk 38 — Exact type-class counting and entropy bounds

**C38.06 cumulative handoff; review reconciled, final records govern closure.** C38 implements exact counting and both
entropy bounds on C37's single count-indexed class. The independent own-law iid
seed is available without C39. C38.01–05 have successful scoped completion
receipts, including C38.05 closure
`48ac467748bb373002fdbba4b9b534fd86caa6f06e271c550f9dc01640284045`.
The current C38.06 request authorizes cumulative qualification and this handoff;
it does not authorize C39 implementation. Fresh cumulative validation, original
independent review, reconciliation and final applicability remain governed by
the records below. The supported private receipt determines actual C38.06 and chunk closure.

[Approved revision 2](../plans/release-3-chunk-38.md) ·
[Implementation and review notes](../plans/release-3-chunk-38-notes.md) ·
[C37 prerequisites](chunk-37.md)

## Public contracts and focused imports

C38 adds exactly five theorems in `LeanInfoTheory.Shannon`, across two new
supported owners. All signatures use `{A : Type u} [Fintype A] {n : ℕ}` and
canonical Real-valued entropy in nats. No public DecidableEq, Nonempty or
full-support assumption is added. Classical decisions remain local. The exact
source signatures are reproduced below; source bodies and compiled records are
authoritative. The cardinality theorem holds at every length, while the four
probability/entropy theorems require `hn : 0 < n`.

```lean
open scoped BigOperators ENNReal
universe u
variable {A : Type u} [Fintype A] {n : ℕ}

theorem card_typeClass_eq_multinomial (t : ↥(wordTypes A n)) :
    (typeClass t).card = Nat.multinomial Finset.univ t.val

theorem iid_empiricalPMF_apply_of_mem_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n))
    {x : Fin n → A} (hx : x ∈ typeClass t) :
    ((PMF.iid (empiricalPMF hn t) n) x).toReal =
      Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t))

theorem iid_empiricalPMF_toOuterMeasure_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t)).toReal =
      ((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t))

theorem card_typeClass_le_exp_entropy
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    ((typeClass t).card : ℝ) ≤
      Real.exp ((n : ℝ) * entropy (empiricalPMF hn t))

theorem exp_entropy_div_pow_le_card_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    Real.exp ((n : ℝ) * entropy (empiricalPMF hn t)) /
        ((n : ℝ) + 1) ^ Fintype.card A ≤
      ((typeClass t).card : ℝ)
```

| Focused owner | Exact direct imports | Boundary |
| --- | --- | --- |
| `LeanInfoTheory.Shannon.TypeClassCardinality` | `LeanInfoTheory.Shannon.WordType`; `Mathlib.Data.Nat.Choose.Multinomial`; `Mathlib.GroupTheory.Perm.DomMulAct`; `Mathlib.GroupTheory.GroupAction.Quotient` | Exact combinatorial count only; no project empirical-PMF, iid or entropy dependency. [Source:12](../../LeanInfoTheory/Shannon/TypeClassCardinality.lean#L12) |
| `LeanInfoTheory.Shannon.TypeClassBounds` | `LeanInfoTheory.Shannon.TypeClassCardinality`; `LeanInfoTheory.Shannon.EmpiricalPMF`; `LeanInfoTheory.Probability.Iid`; `LeanInfoTheory.Shannon.Entropy` | Own-law masses and bounds; no semantic-KL or coding owner. [Source:12](../../LeanInfoTheory/Shannon/TypeClassBounds.lean#L12) |
| `LeanInfoTheory.Examples.TypeClass` | `LeanInfoTheory.Shannon.TypeClassBounds` | Private development consumers, excluded from both supported mathematical umbrellas. [Source:12](../../LeanInfoTheory/Examples/TypeClass.lean#L12) |

The import-only Shannon umbrella exports both supported owners at lines 51–52.
The Examples umbrella includes only the example owner at line60. The lightweight
root still imports only Probability.Finite and InformationMeasures; its retained
direct-import/project-closure/export counts are 2/5/92. The current compiled
surface is 913 declarations in 76 supported modules, with 94 reviewed simp names.
C38 contributes five supported names and two owners over the incoming 908/74
surface. It adds no simp attribute, public helper, alias, bundled type or instance.
Compiler-materialized imported-definition auxiliaries `wordType.eq_1` and
`wordTypeEquivPMF.congr_simp` observed in the consumer environment are separately
audited; they are not authored public fixtures or additions to the manifest.

## Reusing the single C37 class

For supplied counts `c : A → ℕ` and `hc : (∑ a, c a) = n`, construct
`t := ⟨c, (mem_wordTypes c).2 hc⟩ : ↥(wordTypes A n)`.
The exact cardinality is `Nat.multinomial Finset.univ c`, equivalently
`n.factorial / ∏ a, (c a).factorial` in ℕ. `Nat.multinomial_spec` gives the
division-free factorial product identity. For a word, use `wordType x`; its
membership is exposed by `mem_typeClass`. No public count aliases or word-index
specializations are necessary.

At positive length let `q := empiricalPMF hn t`. Its actual support is exactly
the positive-count labels. Bounds use `k = Fintype.card A`, retaining every
unused label in the polynomial. The same `typeClass t` serves as a finset for
cardinality and, by coercion to a set, as an event for
`(PMF.iid q n).toOuterMeasure`. Do not introduce a second law-indexed class.
C37's `mem_typeClass_iff_empiricalPMF_eq hn` relates membership to empirical-law
equality. `wordTypeEquivPMF hn` recovers an index from an independently supplied
PMF with an exact denominator witness, and its ordinary equivalence laws recover
the supplied law and labeled counts. The prescribed denominator need not be least.

The private generic callers at [lines129](../../LeanInfoTheory/Examples/TypeClass.lean#L129)
and [144](../../LeanInfoTheory/Examples/TypeClass.lean#L144) exercise these two entry
points using only public focused APIs. They obtain exact counting, both entropy
bounds and own-law event mass on the identical finset. The generic caller at
[line166](../../LeanInfoTheory/Examples/TypeClass.lean#L166) recovers the ENNReal
identity from the public real class identity:

```lean
(PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t) =
  ENNReal.ofReal (((typeClass t).card : ℝ) *
    Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t)))
```

Its proof uses `PMF.toOuterMeasure_apply_finset`, `ENNReal.sum_ne_top` and
`PMF.apply_ne_top` to exclude infinity; it separately proves the right-hand real
quantity nonnegative, then uses `ENNReal.toReal_eq_toReal_iff'` and
`ENNReal.toReal_ofReal`. Unrestricted toReal injectivity is not used. This caller
is a checked reuse pattern, not a new public theorem; production C39 must use
supported declarations rather than import Examples or reference private helpers.

## Private proof choices and boundary behavior

C38.06 preserves the mathematical routes, theorem statements, public contracts
and acceptance policy. It corrects seven proof-body elaboration sites to avoid
duplicate ownership of a lazily generated iid equation theorem; the dedicated
correction/evidence section below records the failure, fix and rerun limits.

Exact counting realizes the supplied index, identifies equal-count words with
an orbit under position precomposition, and counts the stabilizer as the product
of factorials of symbol fibers. Empty fibers contribute `0! = 1`. Pinned
`DomMulAct.stabilizer_card`, orbit–stabilizer and `Fintype.card_perm` give the
factorial identity; comparison with `Nat.multinomial_spec` and cancellation of
positive factorials give the public count. The position convention is `x ∘ e`,
inherited from C37; alphabet labels are preserved.

The own-law word proof groups the iid position product by symbols with
`Finset.prod_fiberwise'`. A zero count contributes power zero and exponent zero. Only
positive-count symbols enter logarithmic cancellation, justified by actual PMF
support and finite atoms. `Real.exp_sum` then gives `exp(-n H(q))`. Summing that
constant over the original finset gives the real class mass, with finite sums
justifying conversion. This proof is independent of any general-prior or KL
formula. The upper bound uses outer-measure monotonicity to the total event,
finite real conversion and positive exponential cancellation; this is the
documented simplification of the advisory finite-sum route.

The lower bound follows the approved division-free route. For natural a,b,
the private scalar comparison is `a! * a^b ≤ b! * a^a`. Coordinate products and
equal totals show that, for fixed target counts a, the natural weight
`W_a(b) = Nat.multinomial Finset.univ b * ∏ i, a i ^ b i` is maximized at b=a.
The multinomial expansion sums these weights over the existing wordTypes to
`n^n`. C37's number-of-types bound supplies `(n+1)^k`. The private empirical-target
bridge identifies each competing class's real iid event mass with
`(W_a(b) : ℝ) / (n : ℝ)^n`; casts precede real division and hn makes the
denominator positive. It proves probability maximality under one fixed target
law, **not maximal class cardinality**. The natural factorial/mode/normalization
lemmas also hold at n=0; only empirical-law claims require hn. A competitor using
a target-zero symbol has weight zero and actual ENNReal event mass zero; the production
proof excludes top through a finite sum before recovering zero from toReal.
No repeated-transfer termination argument, natural probability division,
full-support premise or removal of zero-count labels is used.

At zero length, the only class and multinomial have cardinality one even for Empty;
no empirical law is assigned. At positive length Empty has no admissible index.
Singleton alphabets have class size one. Pure laws and zero entropy are included.
The estimate is the universal ambient `(n+1)^k` estimate; no support-size
improvement, Stirling asymptotic or second-order accuracy is claimed.

## Permanent consumers

Every declaration in Examples.TypeClass is authored private. Earlier generic
word/class and upper-bound callers remain at lines32/46/56; raw factorial and
all-length boundary consumers remain at66/81/91/96/102/120. The table gives the
main current fixture locations; all lines refer to the source hash below.

| Fixture | Exact result | Consumer location |
| --- | --- | --- |
| Boolean n=3, counts(2,1) | Class exactly001,010,100; cardinality3 by independent enumeration and by the public multinomial theorem; own-law word4/27, class4/9; exp(3H)=27/4; 27/64≤3≤27/4. | [class:270](../../LeanInfoTheory/Examples/TypeClass.lean#L270), count283/288, masses298/304, exponential315, bounds324/333 |
| Biased Boolean n=4 | Fixed q=(3/4,1/4): target(3,1) card4/mass27/64; competitor(2,2) card6/mass27/128. Direct competing atom mass9/256 and finite sum; opposite strict size/probability orderings. | [cards:365](../../LeanInfoTheory/Examples/TypeClass.lean#L365), competitor enumeration401, target mass411, direct competitor422/435, strict orders446 |
| Pure Boolean, every positive n | Unused true label retained; singleton constant-false class, pure empirical law, entropy0, both masses1; lower factor1/(n+1)^2 and upper equality. | [class:193](../../LeanInfoTheory/Examples/TypeClass.lean#L193), law202, entropy213, masses217, bounds228 |
| Fin3 n=4, counts(2,2,0) | Card6, actual support{0,1}, word1/16/class3/8, exp(4H)=16, 16/125≤6≤16 with exponent3. | [card:472](../../LeanInfoTheory/Examples/TypeClass.lean#L472), support476, word482, exponential496, class501, bounds509/519 |
| Sparse competing counts(2,1,1) | Actual ENNReal class mass0 under the fixed target q=(1/2,1/2,0); zero iid factor and finite sum. | [zero event:529](../../LeanInfoTheory/Examples/TypeClass.lean#L529) |
| Arbitrary counts, arbitrary witnessed law, ENNReal recovery | No example-private theorem used inside the generic interface proofs; one finset throughout, explicit no-top and nonnegativity. | [counts:129](../../LeanInfoTheory/Examples/TypeClass.lean#L129), law144, recovery166 |

## Mathematical source and adaptations

CT91, Cover–Thomas, *Elements of Information Theory*, Wiley 1991, §12.1 is the
source. The registered local PDF hash is
`16f016eafbb1160c2d8e6c29ff28db870e0eb2e61c15ea39bea5b06d463a952f`.
Corollary (12.15), printed 281/PDF 303, is the own-law seed. Theorem 12.1.3,
(12.16)–(12.17), printed 282/PDF 304, gives the two-sided class-size estimate and
multinomial count. The upper probability argument is (12.18)–(12.22); the
probability-mode and lower-bound derivation is (12.23)–(12.39), printed 283–284/
PDF 305–306. C38.06 support freshly matched the PDF hash and read PDF 303–306 as
text. No new visual inspection or whole-book reading is claimed; initial C38
planning's visual check remains historical. Text extraction omits some scanned
formula detail, including (12.27), so the actual verified natural scalar lemma
and earlier visual/source record retain their separate evidentiary roles.

Bit entropy/powers of two become nats/Real.exp. The own-law specialization is
proved first instead of depending on the source's general-prior theorem. The
source probability ratio becomes a natural division-free factorial comparison
that handles zero counts directly. Empty-word/empty-alphabet boundaries and
the numerical/private interface fixtures are explicit project extensions and
original consumers. No textbook proof prose is reproduced and no external
information-theory formalization is used. [Reference register](../references.md#ct91-cover-and-thomas)

## C39 prerequisites and obligations

C39 receives the existing admissible count indices, realization and single
class, the exact count, both entropy inequalities, the independently proved
own-law seed and the finite-mass ENNReal recovery pattern. Import TypeClassBounds
for this package and reuse the released iid product API. Production code must
not depend on Examples.TypeClass or owner-private mode/count-weight helpers.

For a general prior p and positive-length type law q, C39 still owns the
one-word exponent `-n * (H(q) + D(q || p))`, the whole-class identity, and the
KL-only class bounds after multiplication by class cardinality. On the finite
KL branch, use actual support inclusion `q.support ⊆ p.support`; requiring
full support of p would unnecessarily strengthen the contract. Canonical
unconditional divergence remains `InformationTheory.klDiv` in ENNReal.
Whenever p is zero on an observed symbol, C39 must prove the class has zero
probability and canonical KL is top, treating that branch before any real
conversion. C38's private fixed-empirical-target bridge and concrete biased/zero
fixtures are not a public general-prior formula or a delivered KL theorem.

Planned C39 sanity checks remain obligations, not C38 results: fair binary p
at n=3/counts(2,1) has word1/8 and class3/8; p=(1,0) makes that class impossible;
p=(1/2,1/2,0), q=(1,0,0), n=2 has class size1, class mass1/4 and finite KL log2.
Also check a biased full-support prior. Keep the distinction between word and event mass explicit. No C39 proof,
general-prior API, Sanov theorem, rate theorem or asymptotic refinement is
authorized by C38.06 completion.

## Cumulative seventeen-criterion matrix

This matrix links each approved criterion to current source and validation. Earlier
step verdicts do not substitute for a fresh assessment of the entire contract.
Fresh independent cumulative review `c38c67f0b6c044aff0a5c5630554d31dc033d7fce7353d68af1a2f19ff7e0db3` marks all four selected
C38.06 criteria and all seventeen criteria below SATISFIED, with no material findings.
The parent agrees in `b95f53aa4c31515e03695a491b0d2712d2657629a66dfbc2fa2abeb722ad930a`. Actual final applicability and acceptance are governed by
`.lit-review/setup/c38-06-20261118/final-checks.json` and
`.lit-review/setup/c38-06-20261118/completion.json`.

| Criterion | Exact contract and source/consumer evidence | Cumulative evidence and assessment |
| --- | --- | --- |
| C38.01-RETAIN | Qualify incoming 908 full named rows before growth; retain historical contracts, roots and attributes. C38.01 incoming qualification and original producer are linked from `.lake/compatibility/c38-01-validation-20261118/index.json`. | Original pre-growth908 producer qualification is preserved; fresh current913 export retains all908 full rows and exactly five approved additions. Fresh601/811 maintained comparisons pass. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.01-COUNT | [Cardinality owner:96](../../LeanInfoTheory/Shannon/TypeClassCardinality.lean#L96) proves the exact multinomial for every supplied index/all lengths. [Raw-count caller:66](../../LeanInfoTheory/Examples/TypeClass.lean#L66) derives both factorial quotient and division-free factorial product. | Fresh Cardinality owner/aggregate build and public factorial caller; original index and all-length statement unchanged. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.01-BOUNDARY | [Consumers:81](../../LeanInfoTheory/Examples/TypeClass.lean#L81): arbitrary finite alphabet at zero length, Empty, no positive Empty index, Unit and pure Boolean counts. Focused cardinality owner directly imports only WordType and three pinned combinatorial modules. | Fresh cardinality-only import control and permanent boundary consumers; exact project closure is WordType plus Cardinality. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.02-WORD | [Bounds:98](../../LeanInfoTheory/Shannon/TypeClassBounds.lean#L98) exposes the exact own-law atom exponent. Private grouped product at41 and entropy product at54 use positive-count logarithms; zero counts give exponent/power-zero factors. | Fresh Bounds owner and own-law atom callers; source groups iid products and separates zero counts before logarithms. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.02-CLASS | [Bounds:118](../../LeanInfoTheory/Shannon/TypeClassBounds.lean#L118) sums the same finset with finite PMF atoms before toReal. [Generic word/class caller:32](../../LeanInfoTheory/Examples/TypeClass.lean#L32) distinguishes the two masses. | Fresh owner and generic mass callers; finite atom sum, same finset and explicit atom/event distinction. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.03-UPPER | [Bounds:139](../../LeanInfoTheory/Shannon/TypeClassBounds.lean#L139) uses own-law probability at most one and positive exponential cancellation, without full support. [Caller:46](../../LeanInfoTheory/Examples/TypeClass.lean#L46) covers supplied index and wordType. | Fresh owner and supplied/wordType upper callers; exact source and compiled contract retain only positive-length hypothesis. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.04-MODE | [Bounds:162](../../LeanInfoTheory/Shannon/TypeClassBounds.lean#L162) scalar factorial comparison; private weights at189, mode at192, exact n^n sum at237, ambient polynomial comparison at245; [fixed-target event bridge:269](../../LeanInfoTheory/Shannon/TypeClassBounds.lean#L269), probability comparison at302, actual zero ENNReal event at312. Natural casts precede real division; denominators are positive. | Fresh owner/axiom/import checks and biased/sparse consumers; fixed-law probability weight mode, n^n normalization and finite zero-event bridge inspected. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.04-LOWER | [Bounds:329](../../LeanInfoTheory/Shannon/TypeClassBounds.lean#L329) has the exact ambient exponent Fintype.card A and no extra premise. [Two-sided caller:56](../../LeanInfoTheory/Examples/TypeClass.lean#L56) and raw-count package at129 use both public bounds. | Fresh owner and generic paired bounds; ambient exponent and C39-independent import closure checked. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.05-BINARY | [Binary:270](../../LeanInfoTheory/Examples/TypeClass.lean#L270) independently enumerates 001/010/100; cardinality3 at283 and separate multinomial computation at288; masses4/27 and4/9 at298/304; exp27/4 and bounds at315/324/333. [Biased:365](../../LeanInfoTheory/Examples/TypeClass.lean#L365): cards4/6; fixed target law (3/4,1/4); direct competitor iid products/finite sum at422/435; opposite strict orderings at446. | Fresh permanent consumer build: independent enumeration, separate multinomial count, exact atom/event masses, both bounds and fixed-law opposite orderings. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.05-PURE | [Pure:193](../../LeanInfoTheory/Examples/TypeClass.lean#L193) singleton constant word; empirical pure law at202, entropy0 at213, both masses1 at217; bounds at228 retain unused Boolean symbol and ambient exponent2, with upper equality. | Fresh permanent consumer build covers every positive n, unused Boolean label, pure law, entropy0, masses1 and ambient exponent2. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.05-SPARSE | [Sparse:472](../../LeanInfoTheory/Examples/TypeClass.lean#L472): Fin3 counts(2,2,0), card6, support{0,1}, word1/16, class3/8, exp16 and 16/125≤6≤16. [Zero competitor:529](../../LeanInfoTheory/Examples/TypeClass.lean#L529) proves actual ENNReal mass0 for counts(2,1,1) under the fixed target, via a zero iid factor and finite sum. | Fresh permanent consumer build: support{0,1}, ambient exponent3, exact masses/bounds and actual fixed-target zero event. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.05-BOUNDARY | [All-length consumers:81](../../LeanInfoTheory/Examples/TypeClass.lean#L81), Empty at91/96, singleton at102 and pure counting at120 remain. Cardinality and multinomial are1 at zero length even for Empty; positive Empty index is impossible. | Fresh all-length permanent consumers retain Empty/Unit/zero boundaries, without a zero-length empirical law. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.05-CALLER | [Raw counts:129](../../LeanInfoTheory/Examples/TypeClass.lean#L129); [independent denominator-witness law:144](../../LeanInfoTheory/Examples/TypeClass.lean#L144), through wordTypeEquivPMF; [ENNReal recovery:166](../../LeanInfoTheory/Examples/TypeClass.lean#L166), finite-sum no-top and nonnegative real RHS. Each invokes only supported APIs, not other example-private or owner-private results. A separate non-Examples public caller passed in C38.05. | Fresh independently compiled focused-only caller, exact public count/law transport and guarded finite-mass ENNReal recovery; no Examples dependency. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.06-VALIDATE | Cumulative owner/consumer/aggregate builds, generated/static checks, incoming908 and released601/811 retention, maintained trust/import/axiom checks, documentation and public-only caller. Dirty-tree applicability is distinct from full clean suite/hygiene. | Fresh primary focused/compatibility/trust/documentation and generated/static records are bound in the neutral validation index; cumulative support export/controls/caller bind259 inputs and9 pins. Clean gates remain separate. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.06-RECONCILE | Reconcile actual source, imports/policy/inventory, source adaptations, log/living summary/reference/map; keep original failures and report dispositions; preserve separate C36/C37 clean obligations and add C38's own clean obligation. | The seven canonical files reconcile current source, the seven-site definitional proof correction, unchanged policy/contracts, source adaptations, historical and failed receipts, and remaining-work ownership; the normative plan is unchanged. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.06-HANDOFF | Maintain docs/handoffs/chunk-38.md with the five signatures, focused imports, source/consumer locations, proof choices, validation identities, checked ENNReal recovery and C39 support/KL obligations. | This maintained handoff contains exact signatures/imports, source and validation identities, permanent consumers, proof choices, finite ENNReal recovery and C39 obligations. SATISFIED in the fresh cumulative review; parent agrees. |
| C38.06-REVIEW | Prepare the complete auditable seventeen-criterion matrix and a review-ready cumulative candidate, with exact source and evidence available for fresh independent assessment of the whole approved contract. Earlier step reports do not replace cumulative review. | The complete17-criterion matrix and source-bound candidate satisfied the pre-review readiness contract. The fresh independent review and substantive parent reconciliation are recorded in `c38c67f0b6c044aff0a5c5630554d31dc033d7fce7353d68af1a2f19ff7e0db3` and `b95f53aa4c31515e03695a491b0d2712d2657629a66dfbc2fa2abeb722ad930a`; final applicability and actual closure are governed by `.lit-review/setup/c38-06-20261118/final-checks.json` and `.lit-review/setup/c38-06-20261118/completion.json`. SATISFIED in the fresh cumulative review; parent agrees. |

## C38.06 compiler-ownership correction and revalidation

The first maintained cumulative compatibility command exited 1 after its
913-row candidate export succeeded. The maintained raw module-ownership audit
reported `compiled module/environment owner mismatch for PMF.iid.eq_1`.
The complete diagnostic enumeration found exactly one mismatch: the same lazy
equation theorem was stored by both `Shannon.SemanticBridge.AEP` and
`Shannon.TypeClassBounds`; the full environment selected AEP as owner.
`PMF.iid` itself remains owned by `Probability.Iid`. Both equation bodies were
the definitional reflexivity proof. Generated/private classification occurs
after this ownership check and cannot excuse the collision.

The parent applied exactly seven C38 proof-body corrections: two Bounds sites
and five Examples.TypeClass sites now use definitional `change` to the constant
`PMF.finiteProduct`, followed by the existing public `finiteProduct_apply` and
real-product lemmas. The five consumer changes prevent fresh materialization
there after removing the Bounds-produced equation. Mathematical proof routes,
all theorem statements, public contracts, imports, assumptions, simp policy and
acceptance rules are unchanged. No AEP, C36, C37, validator or dependency-pin
change was made. The source-derived API line index was regenerated; this is
line-location maintenance, with no public manifest or policy growth.

Original failure and diagnostic records remain under
`.lake/compatibility/c38-06-facts-20261118/boundary-diagnostics/`.
The attributed diagnosis is `diagnosis.json`, SHA-256
`fdf752e10b1a447d397dc02f2c4525de66473c3a4f4681f04a3f05d04000764d`;
it links original inputs, stdout/stderr, actor, commands, exit codes and source/
pin fingerprints. The unmodified maintained failure is retained both in its
original `.lake/compatibility/5819a4202c1a499bb818e411b4a7bf02/` directory and
the hashed `maintained-failure/` copies. The initial additional owner probe
exited 1 because its `env.contains` diagnostic did not expose the already
enumerated lazy constant; the corrected raw-map diagnostic passed. Neither
original failure is replaced by a later success.

Isolated warning-as-error probes of the exact corrected Bounds source and the
combined exact Bounds/Examples declarations passed, with no locally generated
`PMF.iid.eq_1` and only permitted axioms. The combined probe removes the old
compiled Bounds import and places those exact owner declarations before the
consumer; it is not the production aggregate or maintained boundary audit.
Its original receipt is `supplied-bounds-and-examples.result.json` in the
diagnostic directory (exit 0, 29.07 seconds). The source candidate and seven-site
diff remain under `.lake/compatibility/c38-06-iid-proof-body-drafts/`.

Fresh production focused, compatibility, trust and documentation reruns on the
corrected source pass. Their actual original receipts and source/producer/pin
applicability are retained. The neutral validation index
`.lake/compatibility/c38-06-validation-20261118/index.json` (original commands, outputs, actors and source maps; the generated/static records are sealed before review capture) distinguishes the initial FAIL, isolated probe
successes and each corrected maintained result. No full clean-checkpoint suite
or hygiene qualification is inferred. C36/C37 mathematics remains closed and
their separate clean-checkpoint obligations remain outstanding.

## Earlier evidence and current source fingerprints

The immutable prior completion records below establish their own scoped closure;
their hashes/source references do not independently establish the C38.06 cumulative
review, final applicability or supported closure.
All original native results, reports, reconciliations, failed exploratory attempts
and private review records must remain intact.

| Step | Closure | Exact F capture |
| --- | --- | --- |
| C38.01 | `c9947ff5afa8251b794a56eb994f8abf03f01958857014c4802495ec6bc84311` | `539eb510759104b47eab503da28748fe6cc3237d320b0de1c363db4ecb331c48` |
| C38.02 | `c7c25ea6c6b3996ef37ed42484862b6e090471bbff1cb71a6a0c49006f33e8bb` | `4c908f825f161191ad6d4915be1857b022c6e5dbcb6769a68d9ba27701660bff` |
| C38.03 | `70fcccae8cc70e9035d28f125b1171f32910fc67538b3f26a90720c4a3ef888e` | `9ed5f5a779a0d8c7784cac5f65b5a822b2c2844b575ce8eeaff53ccc555e9188` |
| C38.04 | `51037c5d326e9250182b11344f5b632c837e40765aefa8de832f6ead271c44d2` | `3dae08c60147c95a61551733612c337b4999642865206e9fcbd56bf414dc7148` |
| C38.05 | `48ac467748bb373002fdbba4b9b534fd86caa6f06e271c550f9dc01640284045` | `ccd27dc6b07fac07d9647beb9fd6bfb6e1d91391f058772238558d62f8326e42` |

Each step's neutral index is
`.lake/compatibility/c38-0N-validation-20261118/index.json` for N=1,…,5.
These retain original commands, stdout/stderr, exact probe inputs, actor
attribution and source/config/pin maps. C38.01 qualified the C37 incoming908
export by source-bound reuse; it did not freshly compile that incoming snapshot.
C38.05's current913-row export hash is
`7b1d4b453e8662fd23e26089dacf65ac981a28945ada72f189a386776bf7d558`;
its comparison is
`.lake/compatibility/c38-05-facts-20261118/post-growth-20261118T194019567473Z/comparison.json`,
SHA-256 `74cbdc2f6fa38e39cd297afdfd1606de5aab0111d544f64a51c7b3fb9848d30c`.
That successful audit retained all 913 incoming rows without growth; it bound 259
producer fingerprints, including 27 selected pinned mathlib sources and 9
installed dependency states. These are attributed prior checks, not newly
executed C38.06 validation or a clean-checkpoint qualification.

Current corrected-source hashes, stable through the successful C38.06 reruns, are:

| Source | SHA-256 |
| --- | --- |
| `LeanInfoTheory/Shannon/TypeClassCardinality.lean` | `509a2b450cecafaa113db9fe0379dbee937f08668538fa10e44e590de1e83c40` |
| `LeanInfoTheory/Shannon/TypeClassBounds.lean` | `1c280130887f073df8841575ad60b19889a4516fb9e05c685b84f41184afde2b` |
| `LeanInfoTheory/Examples/TypeClass.lean` | `f456e702cc5f32415c194e3d692a208baf6f186e398e055c7907357218b90de5` |
| `LeanInfoTheory/Shannon/WordType.lean` | `f8b426e0836f19e9f6a96a6da588570f406c7baffb5e647ff9f7d5b8b6b3be80` |
| `LeanInfoTheory/Shannon/EmpiricalPMF.lean` | `253e2449292c10538a0d024efe73b47b24e440b6ec2009b5a3b3e1963b90e9c1` |
| `LeanInfoTheory/Probability/Iid.lean` | `d1e366e06e59ebfcaca3e761d258d18865414e0fd05313529a165b0304c2235f` |
| `LeanInfoTheory/Probability/FiniteProduct.lean` | `cfa53f23b9fb6295e5d031b55ccb4726e674c4698777d47ce3b3a26211ddce6a` |

## Current cumulative validation and review identities

Fresh primary validation is indexed at `.lake/compatibility/c38-06-validation-20261118/index.json`. It includes the nine-target
owner/consumer/aggregate build, maintained released601/811 compatibility,
complete maintained trust/import/all-project axiom checks, documentation and
non-mutating generated/static checks. The public-only caller is independently
compiled in the cumulative support audit. Exact commands, original raw outputs,
actors and before/after source maps are preserved, with no original failure
promoted to passing evidence.

The fresh cumulative audit is `.lake/compatibility/c38-06-facts-20261118/corrected-v2/cumulative-20261119T001450237763Z/comparison.json`, SHA-256 `6f776d24373fa98304cee2e4fa58db6586d82955e87cf1457074bfd5b0ee79a7`.
It retains every original908 structural row (types, binders, universes, kinds
and owners), adds exactly the approved five theorems, and equals all913 rows
from the immediate predecessor. Its seven successful compiler receipts cover
the export, both focused owners, consumer, full/root controls and public caller.
All259 source/compiled/configuration fingerprints and nine installed pin states
match before/after. Original226-input provenance is qualified through the
preserved C38.01 record: six old inputs changed and33 were added during C38;
the complete historical map is not claimed unchanged. Current counts are
913 declarations/76 supported modules,94 reviewed simp names, root2/5/92.
The consumer classification verifies77 authored private declarations,125 private
compiled constants and exactly the two reflexive imported-definition auxiliaries;
the auxiliaries are not simp and are absent from both supported umbrellas and
the focused Bounds closure. No blanket allowance for new public fixtures is used.
Relative to C38.05, the seven-site correction changes exactly the Bounds and
Examples.TypeClass source/olean fingerprints; the other255 producer inputs and
all nine pins match. The corrected audit checks raw module ownership before
classification and excludes the iid equation auxiliary from the focused owner
and consumer. The existing AEP equation remains owned by AEP.

Fresh cumulative review `c38c67f0b6c044aff0a5c5630554d31dc033d7fce7353d68af1a2f19ff7e0db3` marks all four selected criteria and all
seventeen chunk criteria SATISFIED, with no material findings. The parent agrees in
`b95f53aa4c31515e03695a491b0d2712d2657629a66dfbc2fa2abeb722ad930a`. The reviewer is
the original bound `/root/c38_reviewer`, requested as gpt-6-astra/ultra with
parent-history copying disabled (`fork_turns="none"`, mapped fork_context=false).
Effective settings remain unobservable. Cooperative read-only instructions are
not OS isolation. Original native results, requested/observable settings,
source R, original report and reconciliation are retained under
`.lit-review/setup/c38-06-20261118/` and the durable C38 session. Final validation
and source F belong to the authoritative captures; `.lit-review/setup/c38-06-20261118/final-checks.json`
and `.lit-review/setup/c38-06-20261118/completion.json` govern their applicability and actual closure.
Only `completion.json` and its linked supported receipt establish actual closure.
The handoff's own final hash belongs to that final capture; it cannot be embedded
in the file itself. No captured document is edited after F to claim closure.

## Remaining work and qualification limits

| Item | Owner and trigger / disposition |
| --- | --- |
| C38.06 cumulative checks, fresh all17 review, corrections/revalidation, canonical reconciliation and private closure | Current C38 implementation parent; authorized C38.06 request. Cumulative validation, fresh four-criterion/all17 SATISFIED review and parent reconciliation are recorded in `c38c67f0b6c044aff0a5c5630554d31dc033d7fce7353d68af1a2f19ff7e0db3` and `b95f53aa4c31515e03695a491b0d2712d2657629a66dfbc2fa2abeb722ad930a`; final exact applicability and actual closure are governed by `.lit-review/setup/c38-06-20261118/final-checks.json` and `.lit-review/setup/c38-06-20261118/completion.json`. |
| C36 complete clean-checkpoint development suite and hygiene | Project lead plus authorized checkpoint executor; separate explicit authorization for an exact clean committed checkpoint and rerun after amendments. Mathematics remains closed. |
| C37 complete clean-checkpoint development suite and hygiene | Same separate authorization/ownership, with its own source identity and evidence. Mathematics remains closed. C38 evidence does not discharge it. |
| C38 complete clean-checkpoint development suite and hygiene | Project lead plus authorized checkpoint executor after an explicitly authorized clean committed C38 checkpoint; keep this obligation distinct from C36/C37 and the C38.06 dirty-tree pass. No commit is authorized here. |
| General-prior type word/class probabilities, finite-KL bounds, support-inclusion and infinite-KL branches | C39 parent after its own approved plan and explicit selected step. Handoff obligations only. |
| Public aliases, public probability-mode theorem, support-size sharpening, Stirling/second-order estimates, Sanov/asymptotic developments | Outside required C38 scope; reconsider only on concrete consumer pressure and an approved proposal. No hidden required theorem is deferred. |
| Separate API-documentation milestone, external-consumer release qualification, release/push/publication or dependency-pin changes | Project lead's separate explicit authorization. Ordinary C38.06 validation does not authorize them. |

No new Desktop directory, commit, push, publication, pin change or automatic
next-step execution follows from this handoff. Existing work and durable private
review records are preserved.
