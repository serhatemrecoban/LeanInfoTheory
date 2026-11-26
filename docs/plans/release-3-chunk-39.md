# C39 — General-prior iid type probabilities and finite-KL bounds

<!-- lit-review-status:start -->
**Plan status:** Approved revision 2. Steps C39.01–05 have successful supervised receipts. The 24 November 2026 request selected C39.06 after verification of the Step 5 receipt and exact source. The [C40 handoff](../handoffs/chunk-39.md) carries the cumulative evidence. The parent reconciled the fresh independent review of all eighteen criteria. The private final receipt governs closure.
Revision 1 received
source-bound independent review: all eighteen proposal criteria satisfied,
no material findings, parent reconciliation complete. This revision adopts
five advisory refinements; that earlier report is not a review of revision 2.
The approved normative requirements are unchanged from presented revision 2;
proof-route improvements remain documented and subject to the stated boundaries.
The private review binding identifies the C39 parent chat;
its bound reviewer is `/root/c39_reviewer`, requested as `gpt-6-astra` / `ultra`
with `fork_turns="none"` (the exposed equivalent of `fork_context=false`).
Effective settings are unobservable. Original native creation and bootstrap
results are preserved privately. Any further requested formal review will use
the installed workflow; verified-file delivery needs no routine permission.
[Intake and evolving proof notes](release-3-chunk-39-notes.md)
<!-- lit-review-status:end -->

## 1. Endpoint and scope

Fix `{A : Type u} [Fintype A]`, `{n : ℕ}`, `hn : 0 < n`, the existing C37
index `t : ↥(wordTypes A n)` and an arbitrary sampling law `p : PMF A`. Write
`q := empiricalPMF hn t`, `T := typeClass t` and `k := Fintype.card A`.
These are explanatory abbreviations, not new public definitions. With the
discrete measurable structure required by the existing KL API, write
`D := InformationTheory.klDiv q.toMeasure p.toMeasure : ENNReal`.

Under **actual support inclusion** `q.support ⊆ p.support`, establish `D ≠ ⊤`
using the existing public characterization and prove, in canonical nats:

```text
one word x ∈ T:  ((PMF.iid p n) x).toReal = exp(-n * (H(q) + D.toReal))
whole class:    ((PMF.iid p n).toOuterMeasure T).toReal
                  = |T| * exp(-n * (H(q) + D.toReal))
bounds:         exp(-n * D.toReal) / (n+1)^k
                  ≤ ((PMF.iid p n).toOuterMeasure T).toReal
                  ≤ exp(-n * D.toReal).
```

If an observed label has zero sampling mass, equivalently support inclusion
fails, prove the **actual ENNReal** class event is zero and the **canonical
ENNReal KL** is `⊤`. The latter is a direct use of the existing public KL-top
theorem, not a second divergence definition or an unnecessary public alias.
The required generic singular consumer assembles both conclusions. A private
generic caller also proves exact equivalence between zero class probability
and canonical KL equal to `⊤`, using the strictly positive finite-branch lower
bound. No new public theorem is needed. It is not permitted to obtain the
singular branch by inserting `⊤.toReal` into a real exponential.

Keep the single count-indexed class and existing empirical/count conversion.
One word and the entire class are distinct probabilities. Preserve unused
labels in the alphabet and in the ambient polynomial factor; `p` need not
have full support and `q.support` may be a proper subset of `p.support`.
All empirical-law statements retain `hn`. No zero-length empirical law,
support-size sharpening, Sanov theorem, asymptotic package, new coding proof,
alternate channel/law representation, dependency update or naming migration
is required. C36–C38 mathematics stays closed.

The [C37–C40 map](release-3-chunk-map.md#c39-type-probabilities-and-finite-kl)
is programme context. This plan's contracts and criteria, once approved,
govern C39. Proof-route advice is separately maintained in the notes. Document
justified adjustments; ask the lead before changing mathematical meaning,
required scope, important public contracts, acceptance policy or pins.

## 2. Verified prerequisites and source basis

The actual C37/C38 declarations and permanent consumers agree with the
[C38 handoff](../handoffs/chunk-38.md). In particular:

| Reused interface | Verified owning source and role |
| --- | --- |
| `wordTypes`, `mem_wordTypes`, `wordType`, `wordType_surjective`, `typeClass`, `mem_typeClass`, `symbolCount` | `Shannon.WordType`: count indices, realization, finite class and membership/count conversion. |
| `empiricalPMF_apply`, `mem_support_empiricalPMF_iff`, `wordTypeEquivPMF`, `wordTypeEquivPMF_apply` | `Shannon.EmpiricalPMF`: positive-length masses, actual positive-count support and independent denominator-witnessed laws. |
| `card_typeClass_eq_multinomial` | `Shannon.TypeClassCardinality`: exact cardinality on the same finset, including zero length. |
| `iid_empiricalPMF_apply_of_mem_typeClass`, `iid_empiricalPMF_toOuterMeasure_typeClass`, `card_typeClass_le_exp_entropy`, `exp_entropy_div_pow_le_card_typeClass` | `Shannon.TypeClassBounds`: independent own-law seed and both entropy bounds. |
| `PMF.iid`, `PMF.finiteProduct_apply`, `PMF.mem_support_finiteProduct_iff` | `Probability.Iid` / `Probability.FiniteProduct`: existing sampling law and atom/support interfaces. |
| `klDiv_pmf_ne_top_iff_support_subset`, `klDiv_pmf_eq_top_iff_not_support_subset`, `toMeasure_absolutelyContinuous_iff_support_subset`, `toReal_klDiv_pmf_eq_sum` | `Shannon.SemanticBridge.KL`: canonical divergence, finite/infinite branches and guarded finite sum. |
| `entropy_eq_sum`; pinned `Finset.prod_fiberwise'`, `PMF.toOuterMeasure_apply_finset`, `PMF.apply_ne_top` | Finite entropy, symbol regrouping and justified finite probability conversion. |

C38's regrouping and weight helpers and all Examples helpers are private.
They are not producer APIs. Use supported project/mathlib declarations and
small private/local derivations, not imports of Examples or promotion of a
helper merely to avoid a short proof. Searches of project source, the current
manifest and generated declaration index found no existing C39 endpoint.
Source inspection establishes names; the intake focused build establishes the
existing modules' compilation. Neither proves proposed C39 statements.

C38.06 is closed by supported receipt
`eb8e38e499788244176aaf1451e804cfc605ff1a2e496cb7dd5acf223b61943c`, final source
`c6c395812b68152ebd2563d7eeab06aa10816e4224360ef7d47caae3c3de7511`.
C37.07 is closed by receipt
`5757260db89c5bb06ed280b4d88256cf24db8abc8c5feb3f8b7bc01512bc93b1`.
These are historical scoped completions, not new acceptance events. C36,
C37 and C38 each retain a distinct outstanding complete clean-checkpoint
development suite and hygiene qualification. C39 cannot discharge them with
dirty-tree checks or authorize a commit to satisfy them.

Intake uses the requested dirty primary checkout, HEAD
`2eb80d0e746688511618aaefc2624ffa4ae88f6e`, Lean 4.33.1, mathlib
`0df444a360eaa60ab8c11dca51a86af692955474`. Installed `inspect` and `api` pass;
all nine installed dependency states match their pins. All 259 producer
fingerprints in C38's corrected cumulative audit match at intake. Its recorded
surface is 913 declarations / 76 supported modules, 94 reviewed simp names,
and root direct-import/reachable-module/export counts 2/5/92. This is qualified
earlier evidence, not a newly compiled 913-row export or clean qualification.
The fresh warning-as-error focused build of existing TypeClassBounds,
Examples.TypeClass, Examples.WordType, SemanticBridge.KL, Shannon and the
lightweight root passed (3118 jobs); original command/output is retained.

**Compiler ownership constraint.** Read C38's documented seven-site correction:
use definitional `change` from iid to the constant `PMF.finiteProduct`, then
`finiteProduct_apply`. Do not materialize another `PMF.iid.eq_1` through
explicit iid unfolding/simplification. Audit raw compiled module ownership
before generated/private classification. Do not modify AEP or weaken that
audit to accommodate a collision. An unexpected collision is an implementation
issue to investigate with original failures retained.

**Exact mathematical source:** CT91, Cover–Thomas, *Elements of Information
Theory*, Wiley 1991, registered SHA-256
`16f016eafbb1160c2d8e6c29ff28db870e0eb2e61c15ea39bea5b06d463a952f`.
The planning reference check freshly matched this hash and read §12.1
Theorem 12.1.2, (12.7)–(12.14), printed 281/PDF303 (one word);
Theorem 12.1.3, (12.16)–(12.17), printed 282/PDF304 (C38 input);
Theorem 12.1.4, (12.54)–(12.58), printed 285–286/PDF307–308 (class and bounds);
and §2.3, (2.26)–(2.27), printed18/PDF40 (KL zero conventions).
The parent's intake used text inspection; the revision-1 reviewer subsequently
reported visual and text inspection of the relevant pages, preserved with its
original report. Neither establishes compilation of prospective C39 proofs.
The source's P becomes empirical q and its Q becomes sampling p. Adapt bits/powers of two
to nats/`Real.exp`, use explicit support/finiteness instead of an informal
extended exponential, and preserve zero counts and positive length. No
textbook proof prose or reference media is to be committed.

## 3. Proposed public contracts and ownership

The following **five names are proposed, not implemented**. They belong to
`LeanInfoTheory.Shannon` in a new focused
`LeanInfoTheory/Shannon/TypeClassProbability.lean`. Its proposed exact direct
imports are `LeanInfoTheory.Shannon.TypeClassBounds` and
`LeanInfoTheory.Shannon.SemanticBridge.KL`. The first four statements use the
existing KL API's `[MeasurableSpace A] [MeasurableSingletonClass A]`; no
measurable instance on the word space is required by `toOuterMeasure`.

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

Do not add public `DecidableEq A`, `Nonempty A`, positivity of every prior
atom, positive entropy or stronger support assumptions. Classical decisions
are local. No new public definition, instance, alias or simp attribute is
proposed. Names follow the existing own-law `iid_empiricalPMF_...` family;
the long lower-bound name reflects its orientation and belongs on the naming
watchlist if actual development/consumer friction warrants a note, not an
automatic alias.

The singular KL conclusion is the existing supported theorem applied to
`empiricalPMF hn t` and `p`:

```lean
(klDiv_pmf_eq_top_iff_not_support_subset (empiricalPMF hn t) p).2 h
```

The proposed endpoint includes this composed result and a permanent generic
caller proving zero event and canonical infinity together. A specialized KL-top
alias or a combined public wrapper is unnecessary. Show every class member is
unsupported under the sampling law, using either a zero-atom/sum argument or
public support-disjointness facts; no particular private helper is required.
A positive-count witness `∃ a, 0 < t.val a ∧ p a = 0` is converted to `h` using
public support facts; both interfaces must be exercised.

The separate private interface owner must also prove this exact characterization
for arbitrary `hn : 0 < n`, `t`, `p`, `[Fintype A]`, `[MeasurableSpace A]` and
`[MeasurableSingletonClass A]`, with **no support premise**:

```lean
(PMF.iid p n).toOuterMeasure (typeClass t) = 0 ↔
  InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure = ⊤
```

For zero mass to imply infinite KL, assume support inclusion and contradict the
strictly positive lower bound, rewriting the actual ENNReal zero equality to
real zero. Use the existing KL support characterization to finish. For the
reverse direction use that characterization and the new actual zero-event
theorem. This does not infer ENNReal zero from real zero, require an event
non-top premise, or apply the finite formula at infinite KL. It remains a
private consumer, not a sixth public contract.

The full import-only Shannon umbrella gains this owner after approval. The
lightweight root stays exactly as before. C37, C38, probability constructions
and coding owners gain no backwards import. A new private
`LeanInfoTheory/Examples/TypeClassProbability.lean` imports only the focused
owner and joins only the non-stable Examples aggregate. A second small private
`Examples/TypeClassProbabilityInterface.lean`, also importing only the focused
owner, keeps generic callers independent of numerical fixtures. No existing
Examples owner is an import of either module.

Only reviewed implementation growth updates `current-api-policy.json` and
the generated current manifest/index/graph. Record both new-owner and Shannon
umbrella approvals, exact direct imports and the five signatures. The expected
final increment is five theorems and one supported owner, not a substitute
for checking exact declarations. Frozen 601/811 contracts are preserved.

## 4. Numbered implementation steps and acceptance criteria

Every step requires exact prior plan approval and its own explicit selection
with review. Complete the selected step's installed cycle and stop. Initial
focused generic consumers accompany the mathematical steps; the comprehensive
numerical matrix is C39.05. Common acceptance/validation duties in §6 apply
at every step; criteria below add the step-specific obligations.

### C39.01 — Retained baseline, owner and finite-KL word mass

Before public growth, qualify the incoming 913-row producer against the actual
checkout/configuration/pins, or regenerate the baseline before edits if its
applicability fails. Any regenerated baseline must be structurally compared
with the sealed corrected C38 913 rows before accepting it; regeneration cannot
silently replace the expected surface. Investigate and record every discrepancy,
resolving any important-contract change with the lead before dependent growth.
Preserve both exports and their producer evidence.
Implement only the proposed word theorem and necessary private/local machinery;
introduce the focused owner, reviewed import edge and a minimal generic caller.
Begin the single permanent Fin3 sparse fixture here: define its prior/counts,
identify q=pure0 and strict support inclusion, directly check word mass1/4, and
instantiate the word formula. This exercises the unused positive-prior label1
and common-null label2 before later proofs. C39.02 adds its event slice and
C39.05 completes its divergence/bounds checks without duplicate definitions.

Preferred proof: establish guarded KL finiteness/absolute continuity, expand
the existing finite KL sum and entropy, separate zero-count terms, and regroup
the iid product by labels. The exponent is `-n*(H+D)`, not `-n*D`.
Proof details and alternatives remain advisory in the notes.

| Criterion | Required acceptance and evidence |
| --- | --- |
| **C39.01-RETAIN** | Qualify the actual incoming913 export before additions; if regenerated, first compare every structural row against the sealed corrected C38 export and resolve discrepancies without resetting the baseline. Retain types, binders, universes, kinds, owners, imports, root exports and reviewed attributes. Compare a fresh post-change export with it and both historical baselines through applicable maintained checks. Record fresh versus reused evidence and all limitations. |
| **C39.01-OWNER** | Add only the approved focused owner/import growth and selected theorem; keep root2/5/92, simp94 and all earlier import boundaries. Check raw iid-equation ownership and the focused/full/root environments; no private helper is promoted or Examples dependency introduced. |
| **C39.01-WORD** | Prove the exact word signature for any member under actual support inclusion. Establish canonical KL non-top before its real interpretation; split unused labels before logarithmic cancellation. Compile a generic supplied-index caller and a wordType specialization through supported APIs. Start the single sparse fixture with strict support inclusion, direct word mass1/4 and the general word formula; retain both kinds of unused label. |

### C39.02 — Whole-class probability on the existing finset

Sum C39.01 over `typeClass t`, obtaining the proposed cardinality-times-word
identity. Use finite PMF atoms to justify `ENNReal.toReal_sum`. Add a generic
caller recovering actual ENNReal atom and event identities with `ofReal`,
finite-mass and nonnegativity guards; retain the word/class distinction. Extend
the same sparse fixture with its singleton class and actual event mass1/4,
checking the new class formula without redefining its prior or counts.

| Criterion | Required acceptance and evidence |
| --- | --- |
| **C39.02-CLASS** | Prove the exact class signature on C37's original finset and compile guarded ENNReal atom/event recovery. Cardinality multiplies the common word mass exactly once. Extend the existing sparse fixture to its singleton class, actual event mass1/4 and the class formula. No second event, conditional law, natural probability division or unguarded toReal injectivity is introduced. |

### C39.03 — Two-sided finite-KL class bounds

Multiply C38's lower and upper cardinality bounds by the positive common word
mass. Cancel the entropy exponent, obtaining the two proposed KL-only bounds.
Keep the denominator `((n : ℝ)+1)^Fintype.card A`. Compile a paired generic
caller and an own-law specialization with zero divergence.

| Criterion | Required acceptance and evidence |
| --- | --- |
| **C39.03-UPPER** | Prove the exact upper bound from C38 and the class identity, for every supported prior, including sparse and pure empirical laws; no extra entropy/positivity assumption. |
| **C39.03-LOWER** | Prove the exact lower bound with positive ambient denominator and unchanged support premise. The proof calls C38's lower bound and handles unused labels without shrinking k. Generic callers exercise both bounds on one class. |

### C39.04 — Observed zero-prior symbols and canonical infinite KL

Implement the proposed zero-event theorem without measurable-space hypotheses.
From failed inclusion obtain a positive-count zero-prior symbol and show every
member word is unsupported. Either show its zero iid factor and sum in ENNReal,
or use public finiteProduct support and the zero-event/disjointness interface.
Assemble the infinite-KL conclusion using the existing canonical public
characterization. The singular proof is independent of the finite-branch real
formula. Then add the private zero-event iff KL-top caller from §3, combining
the singular theorem with the finite branch's strictly positive lower bound.

| Criterion | Required acceptance and evidence |
| --- | --- |
| **C39.04-ZERO** | Prove actual ENNReal class mass zero under failed support inclusion, establishing every member is unsupported through either zero-atom reasoning or public support-disjointness. Compile a positive-count/zero-prior witness caller and a direct failed-inclusion caller. No particular private helper is mandated and no top-toReal argument is used. |
| **C39.04-TOP** | In permanent generic callers prove canonical KL equals top for the same class/prior using `klDiv_pmf_eq_top_iff_not_support_subset`; connect observed counts to actual support. Prove the private equivalence actual class mass=0 iff canonical KL=top, for arbitrary positive length/index/prior without a support premise, using the strictly positive guarded lower bound and the actual zero-event theorem. No duplicate KL definition, public alias or inference from toReal zero to ENNReal zero. |

### C39.05 — Permanent numerical and public-interface consumers

All fixtures are authored private and derive their facts from supported
focused APIs. They must not reference C37/C38 or other example-private helpers.
Use explicit labels and exact masses, with direct finite-product calculations
as independent checks against the new entropy/KL formulas. Keep imported iid
equation materialization out of both example owners. Complete and reuse the
sparse fixture begun in C39.01–02 and retain the generic equivalence from
C39.04; do not create duplicate fixture definitions or a public wrapper.

| Criterion | Required acceptance and evidence |
| --- | --- |
| **C39.05-FAIR** | Boolean n=3/counts(2,1): identify the exact three-word class and cardinality3; under p=(1/2,1/2), prove each member word has mass1/8 and actual class mass3/8. Instantiate both generic bounds on that class and verify the class/word factor3. |
| **C39.05-SINGULAR** | The identical binary class under p=(1,0) has actual ENNReal word and class masses0 and canonical KL top. Exhibit the count1 zero-prior symbol and apply the public singular interface, with no real-divergence exponential. |
| **C39.05-SPARSE** | On Fin3 at n=2/counts(2,0,0), prove q=pure0, class={00}, p=(1/2,1/2,0), strict actual support inclusion, D≠top and D.toReal=log2. Prove word/class mass1/4 and instantiate the bounds with ambient k=3, concretely 1/108≤1/4≤1/4. Distinguish the unused positive-prior label1 from the common-null label2. |
| **C39.05-BIASED** | On the same binary n=3/counts(2,1) class use full-support p=(3/4,1/4), different from empirical q. Prove word9/64 and class27/64; compute D.toReal=(2/3)log(8/9)+(1/3)log(4/3), use the general word/class formulas and instantiate both KL bounds. |
| **C39.05-CALLER** | In the separate generic interface owner exercise supplied indices, raw counts with sum witness, wordType specialization, and independently supplied laws with exact denominator witnesses via `wordTypeEquivPMF`. Recover ENNReal word/class identities with guards, pair both bounds, assemble zero event plus canonical infinite KL, and retain the unconditional-at-positive-length zero-event iff KL-top check. Independently compile a caller outside Examples importing only the focused owner; no numerical/private helper may supply its proof. |
| **C39.05-BOUNDARY** | Exercise p=q against C38's own-law formulas, positive-length pure and singleton cases, unused labels and n=1. Preserve C37/C38 zero-length/Empty combinatorial consumers; do not manufacture an empirical PMF at n=0 or add Nonempty/full-support assumptions to the general API. |

Exact additional exponential simplifications for fair/biased bounds may be
included if useful; they are not required beyond the stated criteria. The
mandatory sparse rational endpoints deliberately catch replacing ambient size
by support size. See the notes for independently calculated fixture values.

### C39.06 — Cumulative qualification, fresh review and C40 handoff

This final step covers **all eighteen criteria** and the full approved C39
endpoint, not merely the last changed file. Reconcile canonical context and
maintain `docs/handoffs/chunk-39.md` before final source capture. Status remains
provisional until the supported private completion record. Carry distinct
remaining-work owners/triggers; do not silently transfer or retire unfinished
qualifications. C40 planning/implementation is not started by this step.

| Criterion | Required acceptance and evidence |
| --- | --- |
| **C39.06-VALIDATE** | Run cumulative focused owner/consumer/aggregate checks, generated/static checks, retained601/811 compatibility, current913 retention plus exactly approved growth, raw owners/import/root/simp boundaries, complete maintained trust/all-project axiom checks, documentation and a focused-only independent caller. Preserve original outputs and source/config/pin applicability. Keep full clean-suite/hygiene qualifications separate and pending without separately authorized clean checkpoint. |
| **C39.06-RECONCILE** | Reconcile actual source/builds, approved plan, current policy/inventory, relevant source adaptations, living summary, project log, reference register and roadmap/map. Preserve C36/C37/C38 completion and their separate clean obligations; record C39's own qualification limits, justified adjustments and all finding/disposition history. |
| **C39.06-HANDOFF** | Maintain and link docs/handoffs/chunk-39.md with exact final signatures/imports, count/law conversion, finite and singular endpoint callers including the private zero-event iff KL-top integration check, fixture locations, source adaptations, validation/review identities, proof/ownership decisions, limitations and remaining-work owners/triggers. Supply the C40 endpoint ledger and exact-candidate consumer requirements without selecting C40 or a release. |
| **C39.06-REVIEW** | Prepare a complete eighteen-criterion cumulative evidence matrix and a source-bound candidate for fresh independent review of the entire approved contract. Earlier step reviews cannot replace it. Make the finite/infinite split, ambient exponent and word/class distinction auditable; retain original review and substantive reconciliation before final validation/closure. |

The REVIEW criterion is candidate/readiness work. Actual original report intake,
every accepted-report reconciliation, correction/final-source applicability and
supported private closure are additional protocol duties, not presumed facts
inside a pre-review criterion. Reviewer gaps/contradictions require a new
satisfactory reviewer assessment; implementer evidence alone cannot override
them. Finish required documents before F; do not edit captured files afterward
to insert a closure claim. Report the actual private receipt separately.

## 5. Ownership and boundaries for the eventual handoff

| Item | Owner / trigger |
| --- | --- |
| Five C39 theorems, generic composition of canonical KL branches and permanent consumers | C39 implementation parent, only after exact plan approval and one selected step. |
| C36, C37, C38 clean-checkpoint development suite/hygiene | Project lead and separately authorized checkpoint executor; retain three identities/obligations without reopening mathematics. |
| C39 clean-checkpoint development suite/hygiene | Same separate authorization for an exact clean committed candidate, with rerun after amendment; dirty C39 closure cannot claim it. |
| All-package endpoint ledger, exact-candidate external consumer, both released comparisons, candidate API-documentation/hosting-size qualification | Separately approved C40 work. C39 supplies contracts, singular-case checks and applicability limits, not a release decision. |
| Public helper/alias, support-size sharpening, Sanov/large deviations, sharper polynomial or second-order estimates | Deferred; require concrete consumer pressure and approved scope. No required C39 theorem is deferred here. |
| Extra sparse-prior normalization over all length-two types | Optional advisory idea deferred: the private generic equivalence and required sparse/singular fixtures give the higher-value C39 check. Reconsider if a type-event aggregation consumer creates concrete pressure; no automatic C40 requirement. |
| Commit, push, publication, Desktop folder, release version/date/DOI, live workflow/pin change | Separate explicit lead authority; none follows from planning, review or chunk closure. |

## 6. Validation, review and change discipline

Use the installed protocol and operations with this parent's persistent bound
reviewer. On an explicit plan-review request, open a fresh `plan-*` session
binding the exact plan hash and proposal criteria; use a self-contained neutral
request and preserve original native call/results. Choose inline or verified
file delivery before dispatch. A plan-review result approves no implementation
step. Keep requested settings separate from observable effective settings and
cooperative read-only instructions separate from OS isolation.

After exact approval, an eligible implementation message selects one numbered
step. Capture B before edits, finish owned edits and validation, retain a
contextual self-review, separately reassess recommendations, then freeze R for
independent review. Preserve uncertainty/failure, source identity and report
origin; reconcile every accepted report, even clean ones. Make justified
corrections, assess R-to-F applicability, run final validation and close only
the selected step through the supported private mechanism. No automatic next
step, conditional queue drain or reviewer replacement.

After each coherent Lean change build the touched owner, relevant permanent
consumers and important downstream aggregates with warnings as errors. Before
public additions qualify the incoming producer; after additions verify exact
growth, compatibility, focused/full/root exports, direct imports and reviewed
attributes. The routine dirty-tree commands include:

```powershell
python scripts/validate_release.py focused <selected-owner-and-consumer-targets>
python scripts/generate_current_public_api.py
python scripts/generate_v0_1_public_api.py --check
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/validate_development.py static
```

Regeneration follows approved source/import changes, not speculative planning.
Use non-mutating `--check` invocations for subsequent validation. Preserve the
frozen v0.1 manifest and both released contracts. Each step's structural audit
must retain the incoming surface; cumulative closeout runs:

```powershell
python scripts/validate_development.py compatibility
python scripts/validate_development.py trust
python scripts/validate_release.py documentation
```

The following cadence makes those existing duties explicit; it does not remove
a gate or replace required fresh checks with earlier reports.

| Point | Required checks and evidence cadence |
| --- | --- |
| C39.01 before growth | Requalify sealed C38 producer source/configuration/pins, or regenerate and compare its exact structural rows to that sealed surface before using it. Preserve lineage and discrepancies. |
| Each coherent Lean change | Fresh warning-as-error focused builds of touched owners/consumers and important aggregates; deliberately regenerate only approved public/import growth, then fresh non-mutating static checks. |
| Each selected step after edits | Fresh current-surface structural audit against incoming913 plus exactly approved growth, including raw owners, imports, focused/full/root exports and reviewed simp attributes; preserve both historical contracts and record evidence applicability. |
| C39.01 historical comparison | Fresh maintained compiled comparison against both released601/811 baselines as required by RETAIN. Intermediate steps may cite that evidence only with explicit source/configuration/pin and structural applicability; invalidation requires a rerun. This never substitutes for their own fresh current-surface audit. |
| C39.05 consumers | Fresh full numerical/interface consumer builds and independent focused-only caller, including the retained zero-event iff KL-top check. |
| C39.06 cumulative closeout | Fresh cumulative owner/consumer/aggregate builds, generated/static and current retention audits, maintained released compatibility, complete trust/axiom checks, documentation, independent caller and all-criteria review. Earlier step results are history, not substitutes. |
| Separately authorized exact clean checkpoint | Complete default development suite and hygiene, repeated after amendment; keep C36/C37/C38/C39 obligations separately identified. API-documentation qualification remains a separate justified milestone. |

For R-to-F changes, repeat affected checks and record exact applicability of
every reused result under the protocol. Never qualify reuse by matching only a
declaration count, HEAD, or theorem names; inspect the recorded producer inputs.

Builds that produce Lean artifacts run serially. Record command, actor, exact
source/configuration/pins, original output, result and limitations; distinguish
fresh checks from applicable prior checks and reviewer-reported evidence.
No placeholder, unsafe/partial declaration, external proof hook or unapproved
axiom is allowed. Audit exact public additions, all project axioms, generated
auxiliaries before classification, namespace ownership and simp behavior.
Use the canonical EPFL/MIL header on each new project Lean file.

The full `python scripts/validate_development.py` and hygiene gate require an
authorized clean committed candidate. No such authority is present. Carry
that qualification explicitly rather than weakening the gate or committing
existing work. The expensive `api-docs` gate is a separate justified milestone,
not routine per-step work or publication permission. C40's broader exact-SHA
consumer/documentation duties remain separately scoped.

Preserve all existing work and durable `.lit-review/` records. Implementation
capture includes relevant dirty/untracked source, approved plan/notes,
configuration and dependencies, excluding private records, scratch and reference
media. Remove only owned disposable proof spikes before milestone reporting.
No proof spike or C39 implementation is authorized by this planning document.
