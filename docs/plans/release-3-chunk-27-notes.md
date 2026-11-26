# C27 implementation notes

## C27.06 — Cumulative qualification and C28 handoff

The conditional request verified C27.05's successful supported closure
`c714fdd975bd5956da50733b1363761b357dd21dd824b9bde7a83cbca054d90d`,
both satisfactory original assessments and their reconciliation, and exact
final source/environment/Git correspondence before admitting C27.06.
Its final predecessor source is
`7b7ca82d5907b86f68c593b6ae3a0cc2a401640abf16113d0295769f90f17db7`.
Only this final C27 step is selected. No mathematical declaration, public
contract, dependency pin or review policy changes are planned.

The [maintained C28 handoff](../handoffs/chunk-27.md) describes the seven
public forms, sparse-law conventions and both permanent examples, with
separate consumer statements for C28–C30. The supported self-information
identity is documented with its positivity argument; its Lean proof and
concentration remain C28 work. Preparing this material is not cumulative
acceptance. Exact fresh checks, candidate/main correspondence, original
cumulative review, reconciliation and supported closure follow
`.lit-review/setup/c27-06-20261108/completion.json` when established.

The complete development suite needs an expressly authorized clean candidate.
The current main Desktop HEAD, index and pre-existing local bytes stay
protected. Read-only snapshot/tree preparation creates no commit, ref or
worktree. Any approved candidate amendment requires the full suite again.
The full API-documentation gate and publication remain separate milestones.

### Complete criterion-to-source and evidence matrix

In the table, **owner** denotes `LeanInfoTheory/Shannon/InformationDensity.lean`, **caller** denotes `LeanInfoTheory/Examples/InformationDensity.lean`, and **step** denotes the corresponding earlier directory under `.lit-review/setup/c27-NN-20261108/`. Its `final-applicability.json` records satisfactory original assessments for the listed criteria. Its `completion.json` supplies the actual private closure and final source. All ten earlier criteria are accounted for. The five original final focused and static run records have zero exit codes and matching stream hashes. Exact closure and artifact hashes are in `.lake/compatibility/c27-06-exploration/inspection-facts.json`, the attributed source-inspection record. This is earlier evidence inspection, not a new compiler run.

| Approved criterion | Source, consumer and earlier evidence |
| --- | --- |
| C27.01-SUPPORT | Owner 38, 44. Signed real log ratio on the entire pair type and `J.support ⊆ Q.support` on arbitrary alphabets. Caller 35, 39, 48, 53, 62 checks inclusion, positive real mass transfer, the defining equation, negative density below unit ratio, and zero density at a zero joint atom. Original focused `probe.json` and final checks in step 01. |
| C27.01-BOUNDARY | `.lit-review/setup/c27-01-baseline-applicability-20261108.json` records C26.06 closure, 352 matched clean-candidate files, 147 validation inputs, nine pins, and the historical 832-record export before the first public edit. The reviewed import approvals are in `docs/compatibility/current-api-policy.json` at 48 and 515. Full umbrella import at `LeanInfoTheory/Shannon.lean` 30. Lightweight root at `LeanInfoTheory.lean` 12–13. Step 01 `post-trust-named/comparison.json`. |
| C27.02-MEAN | Owner 53–60 reverses `mutualInfo_eq_sum_log_ratio` from `Shannon/SemanticBridge/FiniteSums.lean` 239. It rewrites the channel projections from `Probability/FiniteChannel.lean` 130, 151 and the product atom from `Shannon/SemanticBridge/Product.lean` 68. Caller 68 rewrites in the presence of an arbitrary real additive term. Step 02 `post-compatibility-named/comparison.json`. |
| C27.03-EVENT | Owner 65, 71 compares real atom masses globally at arbitrary real `t` and proves the supported iff using positive J and Q masses. Caller 73 derives the global support-guarded iff. Caller 87 excludes every zero-joint atom, including Q-only and common-null atoms. Step 03 final focused build. |
| C27.03-MISS | Owner 84–93 compares intersections with joint support and proves equality of real joint probabilities with the weak density sublevel. Caller 94 works at unnormalized `(n : ℝ) * r` for arbitrary word PMF and block channel, including zero length, without finiteness assumptions. Step 03 final focused build. |
| C27.03-TIE | `.lake/compatibility/c27-03-20261108/Tie.lean` 24–49 gives uniform BSC(1/8) matching J=7/16, mismatching J=1/16, Q=1/4 throughout, and densities log(7/4), log(1/4). Lines 51–100 show diagonal strict event, Q-size 1/2, J-power 7/8, equality-level and closed miss 1/8, and open sublevel mass zero. Step 03 `tie.json`, `tie-inputs.json` and copied source/streams match the original parent and helper records. Source SHA-256 `4a8295069e0a64a31d2851e46876cc300086e9c5337855f78f3078a14aefdf46`. |
| C27.04-TAIL | Owner 97–117 evaluates Q with the existing `Probability/TotalVariation.lean` 111 real-event sum. Each Q indicator summand is at most exp(−t) times its J mass. The proof sums and uses `Probability/Finite.lean` 42. The public bound exposes only `Finite` instances. Step 04 `post-compatibility-named/comparison.json`; caller 102 instantiates this signature. |
| C27.04-CALLER | Caller 102–114 proves the weighted two-law inequality for arbitrary input-word PMF and block channel, all `n k : ℕ` and `r : ℝ`. It uses only nonnegativity of `(k : ℝ)` and the two C27 probability theorems. `.lake/compatibility/c27-04-20261108/WordCaller.lean` 12, 26 adds the explicit n=k=0 case. Step 04 `caller-inputs.json` and `caller-helper.json` preserve the helper’s pin-verified zero-exit run, its actual streams and identical source with SHA-256 `cc32640108787ee2603f39b8bb66548743c65398a0b4c19b95fa8996d941bb04`. The parent compiled the permanent caller. |
| C27.05-NOISELESS | Caller 123–143 computes all four J and Q masses and the density. Lines 145–164 show the event at −1 equals the diagonal while the off-diagonal density zero exceeds −1. Lines 166–190 use C25’s event test under Q and J for size 1/2, power 1, miss zero at log(3/2), and exhibit Q(A) ≤ 2/3 < J(A). Step 05 `focused-r2.json` and `final-focused.json`; original line-length warning and corrected successful attempts retained. |
| C27.05-INDEPENDENT | Caller 202, 209, 215 proves both laws equal the independent product, totalized density zero, and the strict zero-threshold event empty globally. Line 224 gives size/power/miss 0/0/1. Line 237 instantiates fair input and pure-false output, with an actual supported atom and an actual common-null atom. Step 05 final focused and axiom checks. |

### Public and import boundaries

All declarations are in `LeanInfoTheory.Shannon`. Each accepts implicit, universe-polymorphic alphabet types and explicit `(p : PMF A) (W : A → PMF B)`. Let J be `PMF.channelJoint p W` and Q be `indepProd p (p.bind W)`. Every atom mass in a real ratio or comparison uses its `.toReal`.

| Owner line | Exact public name | Further binders and result |
| --- | --- | --- |
| 38 | `infoDensity` | Explicit `z : A × B`. Returns the signed real log(J(z)/Q(z)). |
| 44 | `support_channelJoint_subset_indepProd` | J.support ⊆ Q.support. |
| 53 | `sum_mul_infoDensity_eq_mutualInfo` | `[Fintype A] [Fintype B]` before p and W. Sum of J mass times density equals mutualInfo J. |
| 65 | `infoDensityThresholdEvent` | Explicit `t : ℝ`. Returns the set exp(t) Q(z) < J(z). |
| 71 | `mem_infoDensityThresholdEvent_iff_of_mem_support` | Explicit t, implicit z, explicit joint-support membership. Event iff t < density. |
| 84 | `channelJoint_infoDensityThresholdEvent_compl_eq` | Explicit t. Real J mass of complement equals real J mass of density ≤ t. |
| 97 | `indepProd_infoDensityThresholdEvent_le` | `[Finite A] [Finite B]` before p and W. Explicit t. Real Q mass of event ≤ exp(−t). |

The owner’s four direct project imports at 12–15 are `Probability.FiniteChannel`, `Probability.TotalVariation`, `Shannon.SemanticBridge.FiniteSums`, and `Shannon.SemanticBridge.Product`. There are no direct external imports in source. Its project closure has eight modules and exposes 204 supported declarations. The development caller’s three imports at 12–14 are the owner, `Probability.BinaryTesting`, and mathlib’s `Probability.Distributions.Uniform`. `LeanInfoTheory/Examples.lean` 44 includes it in the development aggregate. Across public modules, the seven new names are visible exactly from the focused owner and full Shannon. Five are theorems and two are definitions, all with empty declaration attributes. The current manifest, retained current compiler export and reviewed growth policy agree. The source manifest is 839 declarations in 60 supported modules. The retained compiled boundary preserves 94 simp names and the lightweight root’s two direct imports, five-module closure and 92 exports.

### Cumulative validation and handoff

The C27.04 compiler export matches every field of all 832 incoming C26 records and adds the seven listed names. C27.05 explicitly attributed that earlier compiled evidence to an unchanged supported surface after example-only changes. Its own focused, static and all-project axiom checks were fresh. The two release contracts cover 601 and 811 declarations, and the prior named comparison checks 17 C25 and four C26 testing names under their focused imports.

For C27.06, obtain the cumulative focused, static, documentation, historical and named compatibility, import/root/simp and all-project trust results on the qualified inputs. Include the full routine suite on the expressly authorized clean candidate, its exact source/pin correspondence with the main checkout, and renewed results if the candidate changes. The original C27.03 tie run used the then-current owner and examples. The cumulative check should replay its exact retained bytes against the final owner; the word helper's recorded source and compiled inputs matched live bytes during this inspection. The ten earlier criterion assessments and five closures supply step history. The new independent cumulative assessment and reconciliation remain C27.06 duties.

Before final capture, reconcile canonical documents and the linked `docs/handoffs/chunk-27.md`. Give C28 the word miss and supported identity `infoDensity p W (x,y) = selfInfo p x + selfInfo (p.bind W) y - selfInfo J (x,y)`, with positivity, product factorization, log rules and `selfInfo_of_toReal_ne_zero` at `Shannon/SemanticBridge/Entropy.lean` 52. C28 owns the Lean proof and concentration. Give C29 the literal global event and support-guarded test, and C30 the independent-law bound with the weighted caller. Keep the handoff provisional until supported private closure.

### C27.06 acceptance duties

| Approved criterion | Current source and required cumulative evidence |
| --- | --- |
| C27.06-VALIDATE | The ten-row matrix above, fresh cumulative focused/static/documentation/trust results, a named 832-to-839 comparison and all 21 focused C25/C26 declarations, fresh retained negative-tie/word callers, the full development suite on the expressly authorized clean candidate, and exact raw-file/pin correspondence with main. Actual commands/results and applicability are recorded under the C27.06 private directory; a pending clean gate keeps closeout pending. |
| C27.06-HANDOFF | The linked handoff, these notes, living summary, project log and reference register. Exact seven binders/imports, both laws and all sparse/tie conventions, C28's word miss and supported selfInfo derivation, C29's guarded global rewrite and C30's weighted caller. The identity's Lean proof and all later-chunk implementation remain deferred. |
| C27.06-REVIEW | Contextual read-only self-review and separate reassessment precede the neutral source/candidate-bound request. Fresh independent review must cover all thirteen criteria through this matrix; the formal report records the three C27.06 assessments with explicit cumulative evidence. Preserve original native results/profile limits, reconcile every assessment/finding, finish corrections/docs, rerun amended-candidate checks and verify final applicability before private closure. |

Reference preparation rechecked the registered PW24 and CT91 hashes and
relevant text locators. The helper's source facts and original observations
are retained separately from parent commands. Earlier visual checks keep
their original actors and dates; no fresh visual-page check is claimed here.

## C27.05 — Permanent two-law event consumers

The conditional request admitted C27.05 after C27.04's successful supported
closure, both satisfactory original assessments and their reconciliation,
and exact final source/environment/Git correspondence were verified.
Only C27.05 is selected. Its private fixtures extend the existing focused
example module; the seven public declarations and owner imports are unchanged.

The uniform noiseless Boolean channel has real J-mass 1/2 on the diagonal
and zero off it, while Q has real mass 1/4 everywhere. Its diagonal density
is `log 2`. At threshold -1 the global event is the diagonal, although the
off-diagonal totalized density is zero and exceeds -1. At `log (3/2)`,
C25 event bridges give Q-size 1/2, J-power one and J-miss zero. The public
tail specializes to 2/3, strictly below that J-power, checking law orientation.

For an arbitrary input-independent channel `fun _ => r`, the joint and
independent laws both equal `indepProd p r`. The density is zero everywhere,
including common-null atoms, and the strict event at zero is empty globally.
The C25 test has size zero under Q, power zero and miss one under J.
The uniform Boolean input and pure-false output fixture explicitly includes
a supported atom and a common-null atom.

Only the development example imports `Probability.BinaryTesting` and pinned
mathlib `Probability.Distributions.Uniform` in addition to the focused owner.
It reuses `BinaryTest.ofEvent`, `rejectProb_ofEvent` and `typeIIError_ofEvent`.
No StandardChannels or C26 import is needed. The mathematical owner, root,
full public umbrella and compatibility policy are unchanged. The maintained
website module graph includes development modules and is regenerated for
these two example imports; the declaration index and public manifest are
unchanged.

The fresh validation scope is focused warning-as-error builds, non-mutating
development static checks and the maintained all-project axiom component.
C27.04's original compiled compatibility evidence is reused only after
matching its artifacts, pins and every public producer input: the sole
changed Lean input is outside all supported mathematical import closures.
This is attributed prior evidence, not a new compatibility compilation.
The full clean cumulative suite and C28 handoff remain C27.06.

Original validation, independent review, reconciliation and supported closure
follow `.lit-review/setup/c27-05-20261108/completion.json` when established.

### Validation and independent review

The integrated focused example, owner, Shannon and Examples passed the
warning-as-error build. Non-mutating development static checks and the
maintained all-project axiom component passed. The audit covered 4,241
local constants across 112 modules, using only
`propext`, `Classical.choice` and `Quot.sound`. The original initial build
failure was one line-length warning; its output is retained, and the recorded
line wrap passed the retry. Helper probes retain their original actors and
streams, including the independent probe's corrected simplifier attempt.
The parent separately compiled the permanent combined module.

The original C27.04 compatibility artifacts were hash-checked. All 134 other
producer inputs, all nine pins, current manifest, policy and supported direct
imports are identical. The sole changed producer input is this private
development consumer, absent from every supported import closure. Thus the
prior compiled evidence remains applicable: 839 declarations in 60 modules,
601/811 released records, all 21 C25/C26 testing names, root two imports,
five-module closure and 92 exports, and 94 reviewed simp names. This is
attributed prior compatibility evidence, not a fresh compiler export.

The persistent independent reviewer assessed C27.05-NOISELESS and
C27.05-INDEPENDENT as SATISFIED with no findings. The parent reconciled both
assessments against the permanent source, actual checks, law orientation,
strictness and support cases. The reviewer freshly elaborated the integrated
source, independently enumerated both Boolean laws with exact rationals, and
proved in memory that the unguarded log event at -1 is the whole space.
No mathematical or API correction was needed.
Only documentation changes follow review. Final focused/static checks and
exact source/pin applicability precede supported closure. The full clean
suite and maintained C28 handoff remain C27.06, which is unselected.

## C27.04 — Independent-law tail and weighted word caller

The conditional request admitted C27.04 after checking C27.03's successful
supported closure, all three satisfactory original assessments and their
reconciliation, and exact final source/environment/Git correspondence.
Only C27.04 is selected.

The real event probability is expanded with the existing
`PMF.toOuterMeasure_toReal_eq_sum`. On the event, multiplication by positive
`exp (-t)` bounds the Q atom by `exp (-t)` times the J atom. Off the event,
the indicator is zero and the comparison term is nonnegative. Sum and use
`PMF.sum_toReal` for J. The theorem exposes only `Finite` assumptions;
`Fintype.ofFinite (A × B)` provides internal enumeration. It works at every
real threshold without support, full-positivity or nonnegative-threshold
assumptions. No logarithmic rewrite or new public helper is needed.

The owner gains the approved `Probability.TotalVariation` direct import for
the finite-event sum identity. Its other three imports and all earlier
public declarations are retained. The focused private word caller combines
the C27.03 weak miss identity with the Q-tail, multiplying the latter by
`(k : ℝ)`. Only `Nat.cast_nonneg k` is needed. The caller accepts arbitrary
input-word law and block channel, without an iid assumption or normalization.

PW24 §18.1, Corollary 18.4/(18.6), printed p. 353/PDF p. 378, uses the
independent pair and a strict tail. The registered edition and displayed
bar on the input were freshly checked. Reference observations are in
`.lake/compatibility/c27-04-exploration/pw24-tail-reference.json`.

Validation, original review, reconciliation and supported closure follow
`.lit-review/setup/c27-04-20261108/completion.json` when established.

### Validation and independent review

Warning-as-error builds passed for the owner, permanent focused callers,
Shannon and Examples. Generated-artifact and development static checks passed.
Fresh compatibility retained both released contracts (601 and 811), all
838 preceding complete compiler records and all 21 C25/C26 testing names.
The current inventory is 839 declarations in 60 supported modules. The
approved TV import grows the owner's project closure from seven to eight
and its visible supported declarations from 178 to 204: 25 existing TV
declarations and the one new theorem. The full umbrella gains the theorem.
The root retains its two direct imports, five-module closure and 92 exports;
all 94 reviewed simp names and every focused simp set are unchanged.
A separate fresh maintained all-project axiom component audited 4,219 local
constants in 112 modules, finding only `propext`, `Classical.choice` and
`Quot.sound`. No duplicate full trust run is claimed.

The retained isolated word caller is
`.lake/compatibility/c27-04-20261108/WordCaller.lean`, SHA-256
`cc32640108787ee2603f39b8bb66548743c65398a0b4c19b95fa8996d941bb04`.
The helper's original successful execution, including the explicit
`n = k = 0` specialization, records stable source, compiled owner and all
nine installed pins. The parent verified and preserved that record and its
streams and copied the exact source; the permanent generic caller was
compiled by the parent builds. These checks keep their actual attribution.

The persistent independent reviewer assessed C27.04-TAIL and C27.04-CALLER
as SATISFIED with no findings. It freshly elaborated the owner, permanent
caller and retained private caller, then independently compiled zero-length
at arbitrary competitor count and zero competitors at arbitrary length.
It checked the selected theorem's axioms, visually resolved the barred input
in PW24 (18.6), and independently checked original compiler outputs, source
inputs, pins and visibility growth. Parent reconciliation agrees with both
assessments. Only documentation changes follow review. Final focused/static
checks and source applicability precede supported closure. The full clean
suite remains C27.06; C27.05 is unselected.

## C27.03 — Strict threshold and closed joint miss

C27.02's supported closure, original satisfactory independent assessment,
reconciliation and exact final source were verified before this conditional
request admitted C27.03. Only this step is selected.

The event compares real atom masses globally. On joint support the two
masses are positive, so `Real.lt_log_iff_exp_lt` and `lt_div_iff₀` identify
it with a strict log-density threshold. For the miss equality, intersect
the complement and the weak density sublevel with joint support and use
`PMF.toOuterMeasure_apply_eq_of_inter_support_eq`. All three new public
declarations work without finiteness assumptions or a measurable space.
The focused owner retains its three direct imports and gains no simp rule.

Private focused callers derive the support-guarded global rewrite, exclude
every zero-joint atom at every real threshold, and specialize the miss to
words at `(n : ℝ) * r` for arbitrary `n`, input-word law and block channel.
The negative-density tie check belongs to private development evidence,
with the standard-channel import kept outside the focused owner.

PW24 §18.1/(18.2) and §18.2/(18.9) supply the supported density and closed
true-pair miss. The decoder display (18.10) uses a weak comparison; C27's
approved convention assigns equality to miss, as does the following error
decomposition. Fresh reference facts are retained in
`.lake/compatibility/c27-03-exploration/pw24-locators.json`.

Validation, original review, reconciliation and supported closure follow
`.lit-review/setup/c27-03-20261108/completion.json` when established.

### Validation, negative tie and independent review

The owner, focused callers, Shannon and Examples passed warning-as-error
builds. Generated-artifact and development static checks passed. Fresh
compatibility retained both released contracts (601 and 811 declarations),
all 835 preceding complete compiler records, all 60 supported import
boundaries and all 21 C25/C26 testing names. The current inventory is 838.
Direct imports and closures are unchanged, with 92 root exports and 94
reviewed simp names. A separate fresh maintained all-project axiom component
audited 4,216 local constants in 112 modules, finding only `propext`,
`Classical.choice` and `Quot.sound`. No duplicate full trust run is claimed.

The retained private fixture is
`.lake/compatibility/c27-03-20261108/Tie.lean` (SHA-256
`4a8295069e0a64a31d2851e46876cc300086e9c5337855f78f3078a14aefdf46`).
Uniform Boolean input and BSC crossover 1/8 give matching J mass 7/16,
mismatching J mass 1/16 and Q mass 1/4 everywhere. The respective densities
are `log (7/4)` and strictly negative `log (1/4)`. At the latter threshold,
the strict event is the diagonal, with Q-probability 1/2 and J-probability
7/8. The entire J-miss of 1/8 is at equality. The public miss theorem gives
the closed density-sublevel probability 1/8; the open sublevel is empty and
has J-probability zero. Both the helper and the parent's final retained
fixture compilations passed with stable inputs.

The persistent independent reviewer assessed C27.03-EVENT, C27.03-MISS and
C27.03-TIE as SATISFIED with no findings. It freshly elaborated the owner,
permanent callers and private fixture, independently enumerated the four
atoms using exact rational arithmetic, and checked the original compiler
artifacts and producer inputs. Its display-wrapper limitation is preserved
in the original report; a separate successful raw-output capture supports
the stated Lean results. Parent reconciliation agrees with all three
assessments. Only documentation changes follow review; final focused/static
checks and source applicability precede closure. The complete clean suite
remains C27.06, and C27.04 is unselected.

## C27.02 — Joint mean

The conditional Step 2 request was admitted after verifying Step 1's
supported closure and exact final source, including its two satisfactory
independent criterion assessments.

The mean theorem specializes `mutualInfo_eq_sum_log_ratio` to the channel
joint law and reverses the equality. The channel projection laws identify
the two marginals, and `indepProd_apply` with `ENNReal.toReal_mul` identifies
the denominator in each summand. This uses the existing finite-sum theorem
on every pair, including zero-mass pairs. The finite-sum signature has
`Fintype` assumptions on both alphabets. A private focused caller rewrites
the mean inside an expression with an arbitrary real additive term.

The owner now additionally imports `SemanticBridge.FiniteSums`. The
supported inventory has one further theorem, for 835 declarations in the
same 60 modules. Validation, original review, reconciliation and supported
closure follow `.lit-review/setup/c27-02-20261108/completion.json` when
established. Only C27.02 is selected by this request.

### Validation and review

Focused warning-as-error builds covered the owner, focused callers, Shannon
and Examples. The development static and compatibility commands passed.
Compatibility retained both released contracts (601 and 811 declarations),
all 834 preceding complete compiler records, and all 60 supported import
boundaries. The root still exposes 92 declarations and the reviewed simp
set still has 94 names; all 21 C25/C26 testing names retain their focused
visibility. The only direct-import addition is the owner's FiniteSums.

A fresh invocation of the maintained all-project axiom component audited
4,213 local constants in 112 modules and found only `propext`,
`Classical.choice` and `Quot.sound`. Compatibility and this axiom component
were run separately; no duplicate complete trust command is claimed.

The persistent independent reviewer assessed C27.02-MEAN as SATISFIED with
no findings. It freshly elaborated both files with warnings as errors,
compiled an independent focused subtraction caller, checked the selected
theorem's axioms, and independently compared the original compiler
artifacts, all 135 producer inputs and nine installed pins. Its assessment
was reconciled against the source, registered references and parent checks.
No mathematical or API correction was needed. Final focused/static checks
cover the documentation reconciliation; compiler inputs remain identical
to the reviewed source. The full clean C27 suite belongs to C27.06.

## C27.01 — Signed density and joint support

The lead selected C27.01 from the [approved revision 2 plan](release-3-chunk-27.md)
on 8 November 2026. The main Desktop checkout is the implementation source.
The C26.06 completion pointer and clean checkpoint are in the [C26 handoff](../handoffs/chunk-26.md).

For `z = (a, b)`, the joint support characterization gives `a ∈ p.support`
and `b ∈ (W a).support`. The same input `a` witnesses `b ∈ (p.bind W).support`.
The product support formula then gives membership in `(indepProd p (p.bind W)).support`.
This proof works on arbitrary alphabets. Positivity of the two real masses
on joint support uses the fact that PMF atoms are finite.

`Shannon.infoDensity` uses the real logarithm of the ratio of these real
masses. It can be negative. At zero joint mass its value is zero by the
total real operations. PW24 §18.1 supplies the log-ratio interpretation on
joint support. The later global threshold must compare masses directly.
[Reference register](../references.md#release-3-planning-locators)

The [owner](../../LeanInfoTheory/Shannon/InformationDensity.lean) needs only
`Probability.FiniteChannel` and `Shannon.SemanticBridge.Product` at this step.
Bring in `SemanticBridge.FiniteSums` for the mean and `Probability.TotalVariation`
for the finite false-alarm bound when those steps are selected.
The [private focused callers](../../LeanInfoTheory/Examples/InformationDensity.lean)
check both public signatures, the real-mass implication, sign below unit ratio
and the null-joint value. The root and existing focused testing modules keep
their import boundaries.

The pre-edit check compared all 352 clean candidate files, 147 validation
inputs, nine pins and the 832-record compiler export against the retained
C26 sources. The baseline record is
`.lit-review/setup/c27-01-baseline-applicability-20261108.json`.
The C27.01 source manifest has 834 declarations in 60 supported modules.
The C27.01 validation, original independent review, reconciliation and private
completion record belong under `.lit-review/setup/c27-01-20261108/`.
Its `completion.json`, when established, identifies the actual final source and
scoped closure.

### Validation and review

The focused warning-as-error builds covered the owner, its private callers,
Shannon and Examples. The standalone caller and development static gate passed.
The development trust gate checked both released contracts (601 and 811
declarations), all 60 focused imports, the lightweight root, 94 reviewed simp
names and all 4,211 compiled project constants across 112 modules. The audit
found only `propext`, `Classical.choice` and `Quot.sound`. The named comparison
retained all 832 C26 compiler records with exactly the two planned additions.

The bound reviewer independently elaborated both sources and tested visibility
through the focused owner, full umbrella and lightweight root. It assessed
C27.01-SUPPORT and C27.01-BOUNDARY as SATISFIED with no findings. Both
assessments were reconciled against the actual sources and compiler evidence.

An auxiliary reviewer comparison of raw Git blobs to historical checkout
bytes failed on seven files. The required working-file comparisons and Git
tree checks passed separately. A subsequent parent check traced all seven
differences to line endings, including the mixed historical project log.
The original failed observation is retained. Final validation covers the
documentation changes following the review. The full clean C27 suite belongs
to C27.06.
