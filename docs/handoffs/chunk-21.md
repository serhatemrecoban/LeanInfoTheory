# Chunk 21 maintained handoff: complete finite-iid almost-lossless source coding

## Status and qualification boundary

The [approved revision-2 plan](../plans/post-release-chunk-21.md) supplies all
seventeen required criteria. C21.01--C21.04 have delivered the four mathematical
endpoints and permanent consumers below. C21.05 adds no mathematical endpoint;
it qualifies their complete package and maintains its downstream handoff.

The observed `.lit-review/setup/c21-04-completion-20261023.json` reports
`SUPERVISED_STEP_COMPLETE`, with closure
`e22cd90cec76a7b22aa4bd3f92fbdfdeb39a3a86ec1834a01aa2f835a4538e57` and final
source `c5a267ea69a6bfa87a2cce7f0e83a6b4264ecc76e6c2d106e538b133ccdd11ad`.
Its source-bound completion chain, rather than historical provisional prose,
determines Step 4 closure. The parent verified all four predecessor criteria,
original review/reconciliation and exact final-source applicability: all 285
Step 4 F entries matched. The actual
`.lit-review/setup/c21-05-prerequisite-audit-20261023.json` records PASS.

The lead's conditional Step 5 request is retained in
`.lit-review/setup/c21-05-session-input-20261023.json`;
`c21-05-admission-result-20261023.json` records ACCEPTED for C21.05.
The parent opened the scoped owned edit recorded in
`c21-05-edit-20261023.json`, reference
`ebdd333dfaf24245ab3361a5f6eeb774a22d8dc0b81af7d2ded5993b906c29e3`.
These are parent protocol results, not operations performed by the supporting
handoff author. The separate exact scoped-checkpoint and local API-documentation
approvals are retained in `.lit-review/setup/c21-05-milestone-approval-20261023.json`.
The twenty-path scope includes necessary Step 5 evidence amendments; each
amended checkpoint requires the complete maintained clean rerun.

Local Step 4 evidence already covers the producer, permanent consumer and
Shannon/Examples aggregates, all nine documentation examples, static/scope
checks, compiled compatibility/trust and the original four-criterion review
with reconciliation. Step 5 has initial separately authorized clean
checkpoint and current two-pass API qualification, recorded below. Cumulative
acceptance requires the actual original report and all-seventeen matrix in the
conditional completion chain. Exact actors, identities and limits appear below
and in the [notes](../plans/post-release-chunk-21-notes.md#12-c2104-operational-entropy-threshold-and-complete-consumers).

This maintained handoff supplies the delivered contracts, source adaptations,
canonical links, evidence limits and C22--C24 dispositions before review capture.
Final candidate qualification, readiness, cumulative acceptance and closure are established only by `.lit-review/setup/c21-05-completion-20261023.json` and its linked actual current-candidate validation/API applicability, genuine original independent report, complete seventeen-criterion matrix, substantive parent reconciliation and final-source qualification. This wording asserts no future PASS or closure.
If the genuine review and reconciliation identify no material change, the parent
can retain the same captured source and finish the required private qualification
and completion chain. No source amendment is needed solely to announce that
outcome. Any actual source or documentation amendment requires the complete
clean rerun, renewed API applicability and all applicable review obligations.
C22--C24, publication and channel achievability require separate selection and authority.

## Delivered public interface and exact quantifiers

All four supported theorems belong to `LeanInfoTheory.Shannon` in
[Shannon.SourceCodingAsymptotic](../../LeanInfoTheory/Shannon/SourceCodingAsymptotic.lean).
For exposition only, fix `{A : Type u} [Fintype A] (p : PMF A)` and write

```text
H := entropy p
M : Nat -> Nat
hM : forall n, 1 <= M n
c : forall n, BlockSourceCode A n (M n)
e n := (c n).errorProbability (PMF.iid p n)
r n := codeRate n (M n)
```

Limits below are `Filter.Tendsto` of these real-valued sequences along
`Filter.atTop` on natural blocklengths. The abbreviations are not additional
public declarations or a sequence bundle.

| Exact public name | Contract |
| --- | --- |
| `exists_blockSourceCode_tendsto_errorProbability_zero` | For `H < R`, there exist M, hM and c with `e -> 0` and eventually `r n <= R`. The very same M and c satisfy both conclusions. |
| `tendsto_errorProbability_iid_one_of_eventually_codeRate_le` | For arbitrary M, hM and c and real `R < H`, an eventual cap `r n <= R` implies `e -> 1`. The premise is eventual, not global. |
| `eventually_entropy_sub_le_codeRate_of_tendsto_errorProbability_zero` | For arbitrary M, hM and c with `e -> 0`, every `delta > 0` gives eventually `H - delta <= r n`. No rate bound, convergence or monotonicity is assumed. |
| `sourceCoding_threshold` | `IsGLB {R : Real | exists M, (forall n, 1 <= M n) and exists c, e -> 0 and (forall eta > 0, eventually r n <= R + eta)} H`, with the set written inline in the theorem. |

In the last theorem one family is chosen before the universal upper tolerance:
M and c may depend on R, but not on eta. This is the primary asymptotic-upper-rate
contract. It avoids unguarded use of conditionally complete Real liminf/limsup.
The general converse also applies to unbounded or oscillating rate sequences;
membership in the threshold set itself requires the displayed asymptotic cap.

The threshold's lower-bound projection takes an actual vanishing-error family
with every upper tolerance at R and returns `H <= R`. Greatestness uses actual
above-entropy families at intermediate rates. The theorem does not assert that
H belongs to its set, a universally available exact-fixed-rate-H family, or an
equality-case optimality theorem. Above-H existence alone does not expose its
private witness's rounded budget formula, typical-word recovery, rate limit or
zero-length budget identity; those stronger properties are checked in the
connected private production construction.

### Model, units and boundaries

`SourceCode X M` remains the transparent pair
`(X -> Fin M) x (Fin M -> X)` from C20; `BlockSourceCode A n M` specializes X to
`Fin n -> A`. Both maps are total and deterministic. There is no global
injectivity, inverse, full-support or recovery-outside-the-selected-set premise.
The error abbreviation is exactly C20/Fano's
`decodingErrorProbabilityOf q id c.encoder c.decoder`, with q here the actual
finite iid law `PMF.iid p n`. Each length has its own word space; no common
infinite path-space process or almost-sure coding limit is introduced.

All primary theorems need only `[Fintype A]` and a supplied PMF in addition to
their displayed code/rate hypotheses. No `Nonempty`, `DecidableEq`,
measurable-space, full-support, positive-entropy or alphabet-size premise is
added. A law supplies any required fallback nonemptiness internally.

Entropy and `codeRate n M = Real.log (M : Real) / n` use nats. Existing
`natsToBits`, `ceil_natsToBits_log_le_iff` and `natsToBits_codeRate_pow_two`
provide the opt-in binary interpretation through C20's CodingRate/Units
surface. C21 adds no bit-valued duplicate, binary-padding API or extra unit
conversion theorem. Natural message budgets and their ceiling overhead are
part of the proof; informal nonintegral message counts are not substituted.

The constructed family has M0=1. Arbitrary converse families may have any
positive M0; every zero-length code still recovers the unique empty word,
with error zero and totalized rate zero. Rate/budget cancellation is guarded
by n>0 and M>=1. Zero-message budgets are excluded by hM. A PMF on an empty
base alphabet is unavailable; this does not exclude the empty word at n=0.

C19's `weakTypicalSet` retains positive length, actual iid support and the
strict normalized-deviation inequality. Impossible words are excluded even
if a raw numerical band would contain them. `T(0,epsilon)=empty`, so its
complement upper bound can be loose at zero while the actual error is zero.
The finite atom estimates allow arbitrary real widths; the probability limit
requires positive width. No full-support or positive-entropy shortcut is used.

## Producer chain and private implementation decisions

The [C19 handoff](chunk-19.md) supplies finite-iid AEP, supported strict typical
sets, atom bounds and finite cardinality bounds. The [C20 handoff](chunk-20.md)
supplies actual total codes, same-witness selected-set construction, success
counting, exact error complementarity and natural rate/ceiling bounds. C21
composes these public interfaces rather than reproving their underlying theory.

1. `rounded_sourceCode_family` privately fixes `H < rho`, width `rho-H > 0`
   and `M n = roundedMessageSize n rho`, then selects one dependent c. Its
   connected conclusion retains positive budgets, all-length integer bounds,
   typical-word recovery, complement error bounds, positive-length rate
   sandwich, error tending to zero, rate tending to rho and all zero-length
   identities. For the public endpoint rho is `(H+R)/2`. The overhead
   `log 2/n` tends to zero, leaving room for the eventual cap at R.
2. `typical_success_bound` specializes C20's arbitrary-law success bound and
   exact complement equality to give, for every n, M, epsilon and actual code,
   `1-e <= P(T^c) + M*exp(-n*(H-epsilon))`. `typical_rate_converse` converts a
   pointwise cap `codeRate n M <= R`, with n>0 and M>=1, into
   `1-e <= P(T^c) + exp(-n*(H-epsilon-R))`. Both epsilon and R are arbitrary
   reals in this finite implication; no eventual family premise enters it.
3. The strong converse chooses width `(H-R)/2`, combines typical-complement
   convergence with positive-gap exponential decay, and squeezes actual
   success to zero using the error range. Its rate premise is used only on a
   sufficiently late tail.
4. The general converse uses width `delta/2` and the same isolated-index
   implication. Its full-sequence upper expression tends to zero, whereas
   vanishing error makes actual success eventually exceed one half. A rate
   below `H-delta` at any sufficiently large index contradicts those bounds,
   independently of how large the other rates become.
5. The threshold intersects the same witness's upper tolerance at
   `(H-R)/3` with the general lower bound to prove `H <= R`. For greatestness,
   public achievability at `(H+L)/2` contradicts a proposed lower bound L>H.

Complement, rounded-rate and decay limits, dependent choice, both pointwise
estimates and order arithmetic remain private. No public achievable-rate
predicate, code-sequence abstraction, helper alias, instance or simp rule was
added. Repetition of a small composition in C20's private integration example
does not establish a need to promote a helper. Promotion requires a concrete
additional production use or documented discovery problem and ordinary
ownership/API review.

### Imports and permanent consumers

The focused owner directly imports exactly `Shannon.SourceCoding`,
`Shannon.CodingRate` and `Shannon.SemanticBridge.AEP`. Existing finite coding,
rate, Fano, TypicalSet, Iid and Units producers retain their direct imports;
finite coding acquires no AEP dependency. The complete Shannon umbrella imports
the new owner. The semantic umbrella gains no coding import, and the lightweight
root retains only `Probability.Finite` and `InformationMeasures`.

[Examples.SourceCodingAsymptotic](../../LeanInfoTheory/Examples/SourceCodingAsymptotic.lean)
imports only the focused owner and belongs only to the non-stable Examples
aggregate. Every fixture/helper/theorem there is private. These are compiled
public-interface consumers and regression anchors, not a supported downstream
import surface. The earlier C20
[SourceCodingTypicalSet consumer](../../LeanInfoTheory/Examples/SourceCodingTypicalSet.lean)
is retained unchanged and is not imported into production.

| Private anchors | Actual interface pressure |
| --- | --- |
| `above_entropy_same_family`, `pure_bool_above_entropy`, `biasedSparse_above_entropy` | Extract one public witness and derive every positive upper tolerance; exercise pure and sparse sources without extra assumptions. |
| `fair_oneMessage_error_tendsto_one` | An actual constant encoder/false-word decoder with M=1 under the fair Bool source; rate zero and entropy log 2 give error tending to one through the public strong converse. |
| `arbitrary_zero_length_code`, `negative_rate_cap_impossible`, `zero_entropy_strong_converse_antecedent_impossible` | Arbitrary positive zero-length budgets, exact empty-word recovery/error/rate, and impossibility of a negative eventual cap when H=0. |
| `oscillatingCode_exact`, `oscillating_bounded_branch`, `oscillating_unbounded_branch`, `oscillating_general_converse` | An actual positive-entropy fair-source exact-recovery family. Even positive lengths have rate log 2; odd lengths have rate `(n+1)*log 2`. Both the bounded branch and rates above every real bound occur arbitrarily far out; public general converse applies to its zero-error limit. |
| `intermittentCode_branches`, `intermittent_bad_indices`, `intermittent_no_eventual_cap`, `intermittent_error_not_tendsto_zero` | Fair-source full-word codes at even lengths and one-message codes at odd lengths. A fixed positive gap occurs arbitrarily late, but no eventual cap below H exists. The public general converse, rather than the eventual-cap strong theorem, excludes vanishing error. |
| `source_coding_package` | All four public endpoints for the identical p/model/error/nats, useful threshold lower-bound projection on actual witnesses, and one H+delta family retaining every upper tolerance. |
| `biasedSparse_support_ncard`, `biasedSparse_entropy_pos`, `biasedSparse_entropy_lt_log_two`, `biasedSparse_operational_compression` | The law (1/3,2/3,0) has support cardinality two and positive entropy strictly below log 2. At midpoint R, one actual public family has error tending to zero and eventual rate at most R, with `0 < H < R < log 2`; the same family exercises threshold and general-converse conclusions. |
| `biasedSparse_impossible_not_typical` | The all-symbol-2 length-one word is outside the actual supported typical set at every real width. |
| `pure_oneMessage_exact`, `pure_oneMessage_limits`, `singleton_oneMessage_exact` | Explicit one-message pure-Bool and singleton families have zero error/rate at every length; pure Bool retains impossible ambient symbols, and its limits also exercise the general converse. |
| `prefix_changed_at_one`, `prefix_zero_boundary`, `prefix_scalar_eventual_equal`, `prefix_preserves_limits_and_cap` | A genuine n<2 modification uses budget 2 and the true-word decoder. At length one its decoded word, error 1 and positive log 2 rate differ from the original pure-source code; at zero error/rate remain zero. Actual scalar tail equality for n>=2 transfers both limits, the eventual zero cap and all positive tolerances. |

The sparse strict entropy gap uses the existing support-cardinality entropy
bound and its uniform-on-support equality characterization: equality would
force mass 1/2 at symbol 0, contradicting its actual mass 1/3. No numerical
logarithm estimates or new entropy theorem are needed. The finite-prefix
consumer compares real errors/rates across dependent budgets without a general
dependent-family transport framework.

## Registered sources and adaptations

The [reference register](../references.md) distinguishes CT91 (1991) and PW24
(August 16, 2024) from PW22. The approved plan and notes retain edition/hash,
page-reading and actor-specific evidence. This handoff preparation inspected
those accounts and the actual Lean source; it did not freshly inspect PDFs.

- PW24 section 11.1, printed 212--217/PDF 237--242, Definition 11.1, Theorem
  11.2 and Remark 11.1 motivate the fixed-length model. C20's total decoder
  replaces erasures by a source value, preserving previous successes. All M
  indices are available; no reserved index or optimal-erasure-tail equality
  is imported.
- PW24 Corollary 11.3/Theorem 11.4, printed 214--215/PDF 239--240, motivate
  threshold and success-set splitting. C21 uses actual natural budgets and
  nats. Its `IsGLB` packaging is derived from its public endpoints, not
  attributed to a separately named textbook order theorem.
- PW24 section 11.2, Proposition 11.6 and coding discussion, printed
  217--218/PDF 242--243, supply the typicality route. The book's closed
  definition/strict proof discrepancy is not silently transferred to C19's
  strict supported set. The decaying exponential summand does not establish
  an exponential rate for the whole error bound.
- CT91 section 3.1, Theorems 3.1.1--3.1.2, printed 51--53/PDF 73--75, supply
  AEP/counting context, with the explicit bits-to-nats convention. Section
  3.3, Theorem 3.3.1, printed 55--56/PDF 77--78, motivates the high-probability
  size lower bound; the implemented sequence converse follows directly from
  the pointwise success bound.
- CT91 section 3.2, Theorem 3.2.1, printed 53--55/PDF 75--77, is a
  variable-length expected-description-length construction and is not this
  fixed-length almost-lossless endpoint.

No textbook media, substantial extracts or external formalization code are
part of the delivery. Exact-rate-H coding, error exponents, second-order
asymptotics, optimal-code classification, variable-length/prefix/Huffman/Kraft
theory, executable compression and non-iid/infinite sources are outside C21.

## Seventeen-criterion source and obligation map

This map identifies source evidence and required qualification; it is not a
fresh cumulative review verdict. Earlier step closure does not remove a
criterion from the C21.05 review.

| Exact criterion | Actual source or remaining qualification obligation |
| --- | --- |
| C21.01-WITNESS | Public above-H existential and connected `rounded_sourceCode_family`: one dependent family retains the construction guarantees and supplies both exported conclusions. |
| C21.01-ROUNDING | Actual natural ceiling identities/integer bounds, guarded rate sandwich, `log 2/n` decay, internal rate convergence and `above_entropy_same_family` tolerance consumer. |
| C21.01-BOUNDARY | Constructed M0=1/error0/rate0/typical-set0 identities; public pure-Bool and biased-sparse existence consumers. |
| C21.01-ARCHITECTURE | Focused owner, exact imports, Shannon export and Examples-only consumer; retained finite/root/semantic boundaries, generated inventory and growth policy require final-candidate qualification. |
| C21.02-POINTWISE | `typical_success_bound` and `typical_rate_converse` retain the exact iid error/strict set, arbitrary widths/R and guarded isolated-index implication. |
| C21.02-STRONG | Public eventual-cap theorem uses positive-gap decay, complement convergence and success/error range without global-cap or regularity assumptions. |
| C21.02-CONSUMER | Actual fair-source one-message family; arbitrary-positive-budget empty-word code; entropy-zero negative-cap impossibility. |
| C21.03-GENERAL | Public lower bound assumes only p/M/hM/c, vanishing error and a positive delta; it adds no rate bound, convergence or monotonicity. |
| C21.03-BADINDICES | Connected fixed-gap pointwise contradiction against eventual success above one half; no global low-rate premise. |
| C21.03-CONSUMER | Actual positive-entropy unbounded oscillation with a persistent bounded branch, and actual intermittent fixed-gap family with no eventual below-H cap; each uses the public general endpoint. |
| C21.04-THRESHOLD | Exact inline same-family IsGLB set, actual-witness lower-bound obligation and above-H greatestness, without H-attainment substitution. |
| C21.04-INTEGRATION | `source_coding_package` and `biasedSparse_operational_compression`: four endpoints, actual threshold projection, H+delta witness, support two and genuine below-log-2 compression. |
| C21.04-EDGE | Pure/singleton/H=0/sparse/positive-initialization cases and actual nonempty finite-prefix modification; strict typicality and positive normalization guards. |
| C21.04-API | Exactly four public theorems; private helper/consumer ownership, naming, imports and no new simp rules; final generated/canonical reconciliation and exact evidence applicability remain required. |
| C21.05-VALIDATION | Initial separately authorized full clean routine and both actual API build/check passes succeeded, with all four declaration inspections; exact records and limits appear below. Every amended checkpoint requires the full clean rerun and API applicability assessment. |
| C21.05-READINESS | Parent predecessor/source applicability and admission passed; initial qualification is recorded below. Dispatch readiness requires current validation, contextual self-review, separate reassessment, finished owned edits and a neutral all-seventeen request. Receipt of the genuine original report and full matrix, substantive reconciliation, dispositions and final applicability are later obligations of this same step, linked by the actual completion record. No future outcome is asserted. |
| C21.05-HANDOFF | This maintained handoff and canonical links provide the delivered contracts, adaptations, initial qualification, evidence limits and downstream dispositions before review capture. The completion record and actual linked chain determine final acceptance; material findings require proportionate correction and renewed qualification. |

## Initial Step 5 qualification and conditional completion

The separately authorized initial checkpoint `463021c1493dd2b28e0730dc64fbace3fd29a67a` passed the complete maintained clean routine. Both actual local API build/check passes and the parent inspection of all four new elaborated declarations passed on their recorded inputs. That initial candidate is validation-ready. Final candidate qualification, readiness, cumulative acceptance and closure are established only by `.lit-review/setup/c21-05-completion-20261023.json` and its linked actual current-candidate validation/API applicability, genuine original independent report, complete seventeen-criterion matrix, substantive parent reconciliation and final-source qualification. This wording asserts no future PASS or closure. Every amended checkpoint, including the evidence updates here, requires the complete clean rerun and renewed API applicability before qualification; these initial results do not qualify later writes automatically. The final checkpoint identity belongs in that actual evidence chain, not in a prediction of a commit containing this text.

| Actual evidence | Retained record / identity |
| --- | --- |
| Human milestone approvals | `.lit-review/setup/c21-05-milestone-approval-20261023.json`, SHA-256 `94b252282f81a756b11228b297b7e5479a69e12a8b9a5d10f7495300791dd4b7` |
| Full clean routine at `463021c1493dd2b28e0730dc64fbace3fd29a67a` | `.lit-review/setup/c21-05-clean-01/result.json`, SHA-256 `6c8981a2d3bb5119252c62b1c2fe48ccefcffa1b89a4cd11c2f580a55e32c093` |
| Actual two-pass local API retry 02 | `.lit-review/setup/c21-05-api-retry-02.json`, SHA-256 `399d0a94125797029e22b0f328507fd00d3c517766ec0799a2ae261fda913b29` |
| All four parent API meaning inspections | `.lit-review/setup/c21-05-api-inspection-20261023.json`, SHA-256 `9b016b5c7a120de836f91302e1567d9fae895acf1bbd0435a6339035e17549d7` |
| Actual four-declaration extracts | `.lit-review/setup/c21-05-api-extracts-20261023.json`, SHA-256 `5ae161dd0ce0b38a3adc6d081a7fd10010cb29fa5618380f388ff713957de473` |
| API/inspection/clean applicability | `.lit-review/setup/c21-05-api-applicability-01.json`, SHA-256 `0ac684748ceab720b00ecdc9d630a4f31898279b3313e3dd5153ed526d609d93` |
| API source content / attestation | `9fd39bdc6b51749c437996c0734eea75d03ecdd7bed7d3d08f5ca36f9d337d66` / `44a5d9b96ff81c5438f3245277c9fa2f5e480659639626c6e9e0ffb1d0d3225a` |
| API relevant / full-tree output | `26e57f955a4352af74ae8cbc86770c54789e56e54055f39c83c0a5b46dc3d2a1` / `903adee15aa8491b77eece8bc211234b599e3420d118b0e9736a1c1a50469453` |
| Initial API FAIL, retained | `.lit-review/setup/c21-05-api-initial.json`, SHA-256 `7241e858b0039a9d8ee0be3295f0df42cf638be555e418bfbcda17a21f059ddf` |
| Bounded generated-marker recovery | `.lit-review/setup/c21-05-api-cache-recovery-20261023/result.json`, SHA-256 `f0c9f575d7065aa3bb75520458ece718afb7e03d3a5d6daca36448e2e7b0500c` |

The first API attempt remains FAIL: new-owner declaration data built, but cached final HTML replay omitted its page. The parent preserved the exact three generated final-facet markers before the bounded recovery, with source/configuration/pins unchanged. Recovery is not a passing milestone; the complete two-pass retry and subsequent inspection are separate evidence.

The parent completed substantive inspection of all four rendered C21 signatures,
hypotheses, docstrings, owners and exact local source links. Actual input,
configuration, attestation and clean-candidate applicability records qualify the
evidence. Available caches and local file links do not establish a cold build,
browser visual QA or publication. Final qualification and closure have only the
conditional completion-record meaning above.
This evidence update itself requires a bounded checkpoint amendment, complete
clean rerun and renewed API applicability before review capture. Every later
actual amendment has the same full-clean obligation. If actual review and
reconciliation require no source change, the parent may finish the private
final qualification chain on the unchanged reviewed source; no ceremonial
source edit is required to announce a clean report.

The native Step 5 record carries three C21.05 criterion IDs. The approved
cumulative obligation still covers all seventeen criteria: the actual original
independent report must supply that full matrix, and the parent must reconcile
every criterion substantively. Native three-criterion acceptance alone is not
cumulative acceptance. The completion record must link the genuine original,
full matrix, parent reconciliation and current final validation/applicability;
this handoff does not turn an expected report into evidence.

The evidence section immediately below retains its original Step 4 account and
limits byte-for-byte; those initial observations are historical, not a denial
of the separately recorded Step 5 gates above.

## Evidence already available and applicability limits

**Historical Step 4 evidence snapshot.** The following account and its limits
describe the earlier source inspection, rather than current Step 5 gate status.


At this inspection, current producer SHA-256 is
`bdf4c2245147d5d3cd0be9fc5ca0f9788edc81a6f21979302a8cf0edd0f4b339` and consumer
SHA-256 is `378b468b94a6c44311062d19382941f5feff6eb0a78d271182fdbfc802532622`.
These match the recorded Step 4 source identities. The local pins remain Lean
v4.33.1 and mathlib `0df444a360eaa60ab8c11dca51a86af692955474`; the handoff preparation's pin
file inspection is not a fresh cleanliness audit of all dependency worktrees.

The support actor `/root/c21_math_feasibility` executed the successful
four-target maintained focused run with warnings as errors, 3122 jobs:

```text
python -X utf8 -B scripts/validate_release.py focused LeanInfoTheory.Shannon.SourceCodingAsymptotic LeanInfoTheory.Examples.SourceCodingAsymptotic LeanInfoTheory.Shannon LeanInfoTheory.Examples
```

Record `.lit-review/setup/c21-04-focused-02.json` has SHA-256
`cb7d7c6bc8182a56b0285dc340dcf98bc60cfff8fc011c1c8babcb8dbf08c236` and exit 0.
Attempt 01 remains FAIL on earlier consumer bytes; repaired private proof
issues and complete failure output are retained separately. No failure is
recategorized as passing evidence.

Parent-owned `c21-04-documentation-initial.json`, `c21-04-trust-initial.json`,
`c21-04-static-final.json` and `c21-04-scope-final.json` are separate evidence.
The parent trust result covers retained signatures, exact imports/root,
reviewed simp rules and allowed axioms; the notes report only `propext`,
`Classical.choice` and `Quot.sound`. Nine documentation examples compiled.
The documentation command has no separate time-of-run identity fingerprint:
its retained applicability uses unchanged example/proof/configuration inputs
and matching trust identity, without inventing such a fingerprint.

`c21-04-final-validation-evidence-20261023.json` reports PASS, unchanged
before/after/current trust and focused identities, and only eight canonical
documents changed from R to F. It qualifies reused compiled evidence after
document-only reconciliation; it does not claim a repeated compiled run.
The observed original review capture is
`e57070619aa303112b511402e2b4080ebceeda0d476acbaf646b0ab5d557d4ca`, with supported
reconciliation `a76294eada64c29ddf8e7928e2bb346542d4dbe499062079773cc0eccbcc9e74`.
The notes retain the independent actor's actual checks, failed attempts,
context-exposure/effective-setting limitations and original report. This
handoff source inspection neither replaces nor reenacts that independent review.

These are local dirty-tree, available-cache qualifications on recorded inputs.
No clean candidate, cold build, publication, new API HTML inspection or full
Step 5 cumulative review is inferred. The current generated surface is an
inventory, not approval or a mathematical completion metric. After any amended
Step 5 checkpoint, rerun the entire maintained clean routine and reassess
source/configuration/dependency/output applicability of API evidence. Previous
C19/C20 API output does not qualify the four new signatures.

## Downstream contracts and remaining work

### Delivered mathematics across C19--C21

The package now connects finite-iid probability concentration to operational
coding: supported AEP and finite typical-set bounds; actual finite total-code
construction and arbitrary-code success estimates; then a single vanishing-error
family above entropy, error to one below an eventual entropy gap, unrestricted
eventual lower rates for every vanishing-error family, and the common operational
threshold. The permanent consumers establish that these are compatible models,
units, quantifiers and boundary conventions, including strict compression for
a nonuniform sparse law. This completes the selected source-coding mathematics
without relying on declaration quotas. Cumulative release qualification is a
separate obligation.

### C22: attained finite-channel information capacity

C22 still owns the actual capacity optimization and attainment from the
existing channel-MI objective, compactness/continuity and correlated-input
information bounds, including product and selected-channel examples. Source
coding does not prove that optimization theorem or identify information capacity
with operational channel capacity. It adds no new channel abstraction. Preserve
finite alphabets, transparent nonempty-input assumptions and nats. C22 requires
its own detailed approved plan and selected work.

### C23: distinct channel codes and a weak converse

Reuse C20's natural budgets, positive-budget/positive-length guards, `codeRate`,
Units and Fano error bridge. Reuse C21's unbundled dependent-family and eventual
scalar-limit convention, without importing private source-code helpers or
creating a competing general sequence framework merely for notation.

Channel encoders map `Fin M -> (Fin n -> A)` and decoders received words to
`Fin M`, under uniform messages and the memoryless channel. Their induced
codeword law can be correlated; it is not the iid source law in the C21
theorems. The shared rate convention does not turn a source encoder into a
channel encoder. C17/C18/C22 and the actual Fano joint law still have to yield
`(1-Pe)*log M <= n*C(W)+log 2` and C23's weak-converse limit.

For vanishing channel error, derive every eventual upper tolerance
`r n <= C(W)+delta`; if using Real limsup, derive needed eventual boundedness
from that finite bound rather than assuming it. A fixed positive excess
infinitely often gives a subsequential obstruction; it need not give an
eventual positive error bound. Keep the stronger eventual-above-capacity
premise distinct. C21's source error-to-one theorem supplies no channel strong
converse, channel achievability, maximal-error equivalence, feedback or cost
constraint theorem.

### C24 and the release boundary

C24 audits actual agreed endpoints and external consumers, integrates the
completed source/capacity/weak-converse surface, and qualifies the proposed
second release after C24. It does not hide a new theorem programme in cleanup.
Version/migration/website/publication actions have their own authority. The
exact existing release and versioned route remain protected. Channel
achievability is outside the second-release programme; a possible third-release
direction requires a later explicit decision.

| Disposition | Owner and concrete completion or reopening trigger |
| --- | --- |
| Four endpoints and required permanent consumers are present; no additional mathematical endpoint is required by C21.05. | C21.05 checks all seventeen criteria against the exact final source and resolves any actual cumulative finding before closure. |
| Initial authorized clean checkpoint passed the complete routine. | Parent retains the actual checkpoint and full record above; every bounded amendment requires the complete clean rerun before final qualification. |
| Authorized actual two-pass API gate and all-four substantive inspection passed. | Retain actual identity/attestation/output evidence, the initial failure and bounded recovery, and exact applicability to the clean candidate; recheck after every amendment and rerun when invalidated. |
| Cumulative acceptance and closure are conditional on the actual completion record and complete linked chain. | All seventeen criteria require a genuine original independent matrix, substantive parent reconciliation and current final validation/applicability, alongside contextual self-review, separate reassessment, neutral dispatch and every required disposition. Native three-criterion acceptance does not replace that matrix. |
| Maintained handoff and current canonical links provide delivered mathematics, initial qualification, evidence limits and downstream dispositions before review capture. | Material findings require bounded correction, full clean rerun and renewed applicability. With no material change, the required private completion chain determines closure without an announcement-only source amendment. |
| Private analytic/construction/pointwise/transport helpers remain private. | Reconsider only after concrete independent production reuse or documented discovery friction and normal API/ownership review; no immediate C21 follow-up is required. |
| Exact-H attainment, EReal wrappers, public family predicates, code optimization and further coding variants are omitted deliberately. | Require concrete consumer pressure and a separately approved mathematical/API scope; no completion gap follows merely from their absence. |
| C22/C23/C24 and any channel-achievability programme remain separately scoped. | Approved detailed plans and eligible explicit selections, preserving the downstream distinctions above; no next chunk starts automatically. |
| The twenty-path local checkpoint and necessary bounded Step 5 amendments are authorized; push/publication, dependency changes and release actions are not. | Preserve the exact approved scope, unrelated intake bytes and all retained evidence. Local checkpoint/API authority does not authorize later chunks or publication. |

The maintained handoff and canonical links record delivered contracts,
source adaptations, actual initial qualification, evidence limits and downstream
dispositions before review capture. Independent assessment of all seventeen
criteria belongs to the genuine source-bound report and substantive parent
reconciliation. Final qualification and closure have the conditional
completion-record meaning stated above.
