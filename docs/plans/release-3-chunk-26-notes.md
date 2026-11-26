# C26 implementation notes

The [approved revision 2 plan](release-3-chunk-26.md) owns the mathematical
contracts. These notes retain proof choices, source adaptations and actual
validation/review evidence.

## C26.01 — Likelihood-threshold rule

Only C26.01 is selected by the lead’s 7 November 2026 request. The main
Desktop checkout is the implementation source. Its earlier local work is
preserved. Step completion follows the supported private closure identified
by `.lit-review/setup/c26-01-20261107/completion.json` when established.

### Delivered scope

`Probability.NeymanPearson` directly imports only `Probability.BinaryTesting`.
It adds `PMF.BinaryTest.likelihoodThresholdTest` and
`PMF.BinaryTest.likelihoodThresholdTest_apply`, with the approved parameter
order and without a finite-alphabet assumption. The full Shannon umbrella
imports this focused owner. The two reviewed growth-policy entries record
the module and umbrella import. The private focused example module joins
the development Examples aggregate and checks all three branches,
alternative-only atoms, common-null atoms and equal-law ties.

The constructor compares real finite atom masses. It rejects above the
threshold, accepts below it and uses the supplied tie probability at equality.
Thus a common-null atom gets that probability for every threshold. This
follows the plan’s finite convention. PW24’s common-null extended log value
is zero and can give a different pointwise decision with the same size and
power. On jointly positive masses, `c = exp (-τ)` and `γ = 1 - λ` translate
its null-acceptance convention. The source is PW24 §§14.1–14.2 and §14.4,
Theorem 14.11, printed 276–282 and 284 / PDF 301–307 and 309. Planning
verified the registered hash and inspected these sections. Current-step
source checks are retained with the validation evidence. The power comparison,
calibration and existence theorem belong to the subsequent selected steps.

### Pre-edit applicability

The accepted C25 checkpoint is
`06c71043a28af231e11490443b6225ae3b9a76eb`, with tree
`903a9f1a31e9731ec216ad37c0790f9df8559649`. Its clean result and completion
pointer remain under `.lit-review/setup/c25-06-20261106/`. Read-only support
verified exact pre-edit bytes of all 58 supported owners and the root,
umbrella, current policy and manifest against that checkpoint. All nine
installed dependencies matched their clean pinned revisions. Mathlib is
`0df444a360eaa60ab8c11dca51a86af692955474`.

The preserved clean compiler export has 828 records, including all 17 C25
testing declarations, and SHA-256
`d6962858d3d6dba55f2b298dbf61fcffe1d03099a538ffe74f0e777231021d9d`.
The separate boundary output has SHA-256
`99440c5f0ac8d789d55586f704bbc1ba0716d8ed6162e9e70f4482a58bd7e16a`.
It verifies the 17 focused declarations and the five-module, 92-export root.
The previously qualified development-growth route and its actual CI/checker
hashes remain applicable. Subsequent C25 review-adapter changes match the
accepted C25 checkpoint. This is applicability of earlier evidence to the
pre-edit source. Fresh C26 checks and the independent review are recorded
separately under `.lit-review/setup/c26-01-20261107/`.

### Validation and review boundary

Fresh warning-as-error builds passed for the owner, focused example and both
Shannon and Examples aggregates. Generated references and development static
checks passed. The complete development trust gate passed, including retained
601/811 comparisons, all 59 direct supported-import probes, current boundaries
and the axiom audit of 4165 constants across 110 project modules. Only
propext, Classical.choice and Quot.sound occur. The current compiler export
has SHA-256 12a13b4d17d929f32c563e8c58d813e05b08f9c302e5d88bcfd398af82a39eec.
All 828 preceding compiler records match exactly, with just the two approved
names added. The early comparison attempt preceded the current export and
was repeated successfully once that output existed.

Read-only support caught normalization of 673 historical CRLF pairs in the
project log. The correction restored every original byte outside the additive
C26 entry. Static checks were repeated on the corrected source.

The bound reviewer assessed both complete C26.01 criteria as SATISFIED.
Its fresh focused/static/probe/axiom checks and independently verified
applicability of completed compiler/boundary evidence are distinguished in
the original report. A first boundary-file identification failed because
that older file had different local object paths. The exact accepted clean
artifact was then copied byte-for-byte for independent examination. The
reviewer also stopped its redundant end-to-end trust invocation and ran the
all-project axiom component independently. Both unsuccessful observations
remain FAIL and supply no passing-criterion evidence.

The original report and substantive parent reconciliation are retained under
.lit-review/setup/c26-01-20261107/. The one optional suggestion was applied
by naming the C26 declarations and consumer evidence in the umbrella
policy's descriptive consumer field. All Lean sources, import approvals,
simp choices, signatures and proofs retain the reviewed bytes. Final
validation checks the bounded prose/metadata amendments and records
applicability of the compiled evidence before supported closure.

The full clean suite belongs to C26.06. The conditional C26.02 request
arrived while C26.01 was unfinished and was consumed as a skip. A later
explicit selection is required for C26.02. Completion of C26.01 is determined
by its supported private record and completion.json.

## C26.02 — Supplied-threshold power comparison

The lead issued a new sequential instruction to finish C26.01 and then
perform C26.02 with its review process. Before intake, the supported
C26.01 closure, both satisfactory review assessments and exact final-source
applicability were verified. This distinct instruction leaves the earlier
consumed conditional skip intact. C26.02 completion follows its supported
private record and .lit-review/setup/c26-02-20261107/completion.json.

### Mathematical scope and proof

The public power_le_power_likelihoodThresholdTest uses the approved signature.
For arbitrary finite laws, nonnegative threshold, tie probability and randomized
competitor, the size comparison is against the supplied threshold test's own
size. The pointwise product (g − f)(p₁ − c p₀) is nonpositive in each of the
above, below and tie cases. Summation bounds the power difference by c times
the size difference. Nonnegativity of c completes the proof. At a tie the
second factor is zero, including at a common-null atom. A positive alternative
mass on a null atom lies above the threshold. The proof uses no division or
support-positivity assumption and allows c = 0.

This is the finite signed-sum adaptation of the likelihood-rule sufficiency
argument in PW24 §14.4, Theorem 14.11, printed 284 / PDF 309. It reuses the
C26.01 constructor and the C25 finite-sum evaluations. Pointwise proof
machinery stays local. The focused private callers supply threshold 2 or 0,
tie probability 1/2, and their own size bound. Exact prescribed-level
calibration and the existence theorem remain C26.03–C26.04.

### Validation scope

Imports, dependency pins and policy import maps are fixed. The step uses
fresh focused/aggregate builds, static checks, a complete current type export,
separate maintained comparisons to both released contracts, and comparison of
all 830 preceding compiler records. The affected supported import closures
are NeymanPearson and Shannon. Fresh maintained probes check both closures,
the full supported environment, root exclusion, attributes and all-project
axioms. Earlier step-1 import evidence for every unaffected closure is reused
only after checking its unchanged sources, import maps and pins. This is
focused fresh validation with explicit applicability of earlier evidence.

The exact checks and independent source-bound report are retained under
.lit-review/setup/c26-02-20261107/. Final completion is subject to the
supported closure. C26.03 remains unselected.

### Actual validation and independent reconciliation

Fresh warning-as-error builds passed for the owner, focused example, Shannon
and Examples. The generated references and development static gate passed.
The complete 831-record compiler export has SHA-256
39ca4caf0e897561c0cd81836131746a60af83bd8c9d356f2937103646bb31ff.
Maintained exact-record comparators separately retained all 601 v0.1.0,
811 v0.2.0 and 830 preceding C26.01 records. The single addition is the
approved power comparison, with no new attribute.

Fresh maintained probes passed for both affected supported import closures,
the whole 831-declaration supported environment and its 94 simp declarations,
the five-module lightweight root with 92 exports and 709 opt-in exclusions,
and all 4169 compiled constants across 110 project modules. The axiom set is
exactly propext, Classical.choice and Quot.sound. The 57 unaffected focused
closures reuse C26.01's completed evidence after checking their source,
import-graph and pin applicability. This is not a new end-to-end trust or
clean default-suite invocation. C26.06 retains the cumulative clean gate.

The same bound independent reviewer assessed C26.02-COMPARE as SATISFIED
with no findings. It reran the focused/aggregate build and static gate,
independently exported identical current compiler bytes and checked the
601/811/830 contracts. Its extra focused caller used disjoint Boolean point
masses, c = 0 and gamma = 1/2: Lean verified size 1/2, power one and domination
of any equal-size competitor. It rechecked the mathematical source and
separately verified the current check inputs and earlier boundary applicability.
The original report distinguishes its own checks from the parent's broader
current probes; neither is represented as a fresh full clean suite.

The native submission produced an empty result and was retained as UNCERTAIN.
Delivery is correlated only with the actual matching original report from
the native agent-list result. Requested reviewer settings remain distinguished
from unobserved effective settings. The full original report, substantive
parent agreement and final applicability evidence remain in the private
C26.02 records. All existing staging and unrelated local source are preserved;
the project log retains its 673 historical CRLF pairs. Completion is determined
by the supported private closure and completion.json. C26.03 is unselected.

## C26.03 — Threshold size and finite crossing

The new conditional instruction selected C26.03 after the supported C26.02
closure, original satisfactory review and exact final-source match were verified.
Only C26.03 is active. Its completion follows the supported private record and
.lit-review/setup/c26-03-20261107/completion.json. C26.04 is unselected.

### Private mathematical interface

The focused owner uses the existing PMF.supportFinset, a private real-mass
positivity bridge, likelihoodRatio and three null-weight sums: strictTailMass U,
boundaryMass B and weakTailMass W. Each sum is filtered on that actual support. The ratio is used in comparisons only
there. Repeated ratio values are deduplicated for choosing a level, while all
atoms and their individual null masses remain in every tail/boundary sum.

The private size_likelihoodThresholdTest_eq states, for arbitrary supplied
nonnegative c and tie weight gamma,

    size (likelihoodThresholdTest P0 P1 c gamma) P0 = U(c) + gamma * B(c).

Its proof first removes every zero-null summand. This explicitly includes
alternative-only atoms, where rejection is one and null size is zero. Only
then does it use division inequalities with a strictly positive denominator.
The same identity holds at threshold zero and at unrealized thresholds.
C26.04 can apply it without repeating the support split.

The private exists_likelihoodThreshold_crossing takes any a in the closed unit
interval and returns a nonnegative c realized on positive null support, with
U(c) <= a <= U(c) + B(c) and 0 < B(c). PMF.sum_toReal proves that supported
null mass is one. Existing PMF.supportFinset_nonempty derives nonemptiness
through PMF.support_nonempty and coe_ne_zero, whose proof uses PMF normalization.
The least realized ratio has weak
mass one, so some level qualifies. The greatest qualifying realized ratio is
chosen. A least greater realized level, when present, identifies U(c) with
its weak mass, which is below a by maximality. With no successor, U(c) is
zero. The weak-tail partition W(c) = U(c) + B(c) and one positive realized
boundary summand complete the bracket. This covers a = 0, a = 1, repeated
levels and a single realized level with the same proof.

The proof uses the pinned Finset extrema and exists_next_right through the
existing import closure. No public declaration, import, attribute, instance or
policy approval is added. The public surface remains 831 declarations in
59 modules, and the light root retains its existing boundary. Forming gamma
and the public Neyman-Pearson existence theorem remain C26.04.

### Source and validation scope

The parent freshly verified the registered PW24 hash and extracted PDF 309 /
printed 284 with the installed pdftotext. Theorem 14.11 supplies the threshold
size equation and randomized-attainment context. The finite weighted-level
crossing and guarded ratio proof here adapt that context to the approved mass
rule; they do not assert uniqueness or require positive masses globally.
No fresh visual PDF inspection is claimed.

Both size and crossing helpers compiled in isolated warning-as-error probes
before integration. An initial dependent-Decidable rewrite failure in the size
probe and two incorrect empty-finset lemma-name probes were resolved against
the pinned library. Their original failed outputs are retained separately;
only completed successful probes supply validation evidence. Disposable Lean
spikes are removed before the step milestone, with current module checks and
durable logs retained.

The reviewed source R passed focused/aggregate builds and the development static
gate. Its fresh export was byte-identical to C26.02 at SHA-256
39ca4caf0e897561c0cd81836131746a60af83bd8c9d356f2937103646bb31ff.
All 831 preceding compiler records and the separate 601/811 released contracts
were retained. Fresh maintained probes passed both affected focused imports,
the full supported environment (831 declarations, 94 simp declarations), the
five-module root (92 exports, 709 opt-in exclusions), and all 4183 constants
across 110 modules in R. Only propext, Classical.choice and Quot.sound occur.
The unchanged 57 focused closures reuse earlier completed evidence after
explicit source/import/pin applicability checks. This is not the full clean
cumulative suite, which remains C26.06.

### Independent review and canonical support correction

The same bound independent reviewer assessed both complete criteria as
SATISFIED. It independently compiled a same-file caller obtaining the same c,
B(c) > 0 and size(test c 0) <= a <= size(test c 1), using the crossing and size
lemmas without another support split. It also checked 4650 size identities and
1125 crossings on a bounded quarter-mass, three-atom rational grid, repeated
focused/static checks, reviewed the mathematical source and independently
verified the compiled evidence's applicability. The original report attributes
the whole environment/root/all-project probes to the parent and makes no new
full trust/default-suite claim.

The one optional finding, lit-finding:c2603-canonical-support-finset, is applied.
The first implementation's private support finset and nonemptiness theorem
duplicated existing PMF declarations. The final implementation instead uses
PMF.supportFinset directly, with the private equivalence

    x in P0.supportFinset iff 0 < (P0 x).toReal.

The bridge follows from actual PMF support, finite atom mass and
ENNReal.toReal_pos; the converse excludes a zero atom. Both the reviewer and
parent compiled the equivalence. The duplicate finset and nonemptiness theorem
were removed, and the existing normalization-based nonemptiness fact is reused.
The tail definitions and proof branches retain exactly the same elements and
null weights. The private size/crossing meaning and all public contracts,
imports, policy and attributes are unchanged. Fresh final integrated checks
and a joint-caller/representation-equivalence probe qualify the corrected
private proofs; their actual results and source identities are retained in the
private final-validation directory before supported closure.

The empty native send result remains UNCERTAIN. Delivery is established only
by the actual matching original report from the native agent-list result.
Requested reviewer settings remain separate from unknown effective settings.
The original report, optional finding, substantive parent agreement,
correction and final applicability remain under the private C26.03 records.
Completion requires the supported closure and completion.json. C26.04 remains
unselected, and no calibrated public witness is claimed by this step.

## C26.04 — Exact level and finite Neyman–Pearson

The new conditional instruction selected only C26.04 after C26.03's supported
closure, satisfactory original assessments and all captured final source,
dependency and Git identities were verified. The approved revision 2 normative
contract is unchanged. No C26.05 numeric permanent consumer is introduced.

### Public theorem and calibration

The focused probability owner adds only
PMF.BinaryTest.exists_likelihoodThresholdTest, with the approved signature:
two arbitrary PMFs on a finite observation type, a real level in [0,1], then
existential nonnegative threshold c and common boundary weight gamma, followed
by exact size and a universal power bound for every randomized competitor
under that level. The same test is chosen before the competitor.

C26.03 supplies U(c) <= a <= U(c)+B(c) and B(c)>0. The proof sets
gamma=(a-U(c))/B(c), obtains gamma>=0 from the lower bracket, and gamma<=1
from the upper bracket and positive denominator. Its one call to the private
size identity reduces exact size to division cancellation. C26.02 supplies
optimality after rewriting this same size equality. No positivity or support
inclusion assumption is added, and no division by a null atom occurs here.
All prior source declarations, imports and attributes retain their contracts.

Private focused callers exercise the public theorem at zero, with pointwise
rejection of every alternative-only atom, and at one, where comparison with
the constant-one test and the existing probability range gives power one.
A general-level caller derives the attained IsLeast type-II error over the
size cap for the same threshold test from typeIIError=1-power. These callers
require no additional public wrapper or optimization structure.

### Four-atom development calibration

The retained private Lean check constructs actual Fin 4 PMFs with null weights
(1/6,1/6,1/3,1/3) and alternative weights (1/2,1/6,1/3,0). It checks both
approved rows: at c=1, gamma=1/3, size=1/3 and power=2/3; at c=0, gamma=1/2,
size=5/6 and power=1. Rejection weights are respectively (1,1/3,1/3,0) and
(1,1,1,1/2). The optimality statements use the public supplied-parameter
comparison. The strictly above and boundary masses are null-weight sums,
including both unequal-mass tied atoms in the first row. The successful whole-file
check also proves every positive threshold has size at most 2/3 in this fixture.
Its input SHA-256 is c093628d90f33c001d375d417c0217041260d0125b8ebcaacec6744e17432483.
All seven inspected calibration declarations use only the three permitted axioms.
Exact inputs and
actual successful or failed outputs belong to the private step evidence;
only successful Lean runs count as validation. The disposable source is not
a third permanent example. C26.05 retains the two permanent consumers.

### Source and validation boundary

The registered PW24 SHA-256 was freshly verified and Theorem 14.11, printed
284 / PDF 309, freshly extracted as text. The finite closed-interval mass rule
adapts its randomized-attainment statement, using size=1-null acceptance and
power=1-alternative acceptance, allowing threshold zero directly. Common-null
weights can differ pointwise from the book with zero contribution to either
law. No uniqueness claim or fresh visual inspection is made.

The current generated manifest and website references were deliberately regenerated
for the single approved public addition: 832 declarations in the same 59 supported
modules. The C25 focused import and the root's two direct imports, five-module
closure and 92 exports remain fixed. Initial and final checks, current versus
applicable prior evidence, independent review and reconciliation are retained
under .lit-review/setup/c26-04-20261107/. Completion is subject to its supported
closure and completion.json. The full clean cumulative suite remains C26.06.

Initial scoped validation passed: focused owner, actual endpoint/type-II callers,
Shannon and Examples build with warnings as errors; development static checks;
fresh full 832-record compiler export; separate 601/811 frozen comparisons and
all 831 preceding records. The sole new public name is the approved existence
theorem. Fresh affected focused imports, full supported environment, root and
all-project axiom checks passed. The other 57 focused closures use earlier
compiled evidence after explicit source/import/pin applicability checks. These
scoped checks are distinct from a fresh full trust invocation or a clean default
suite. The complete current result files and precise audit counts remain in
the private evidence and the source-bound review request. Independent review
has not yet been dispatched at this point.

### Independent review and final applicability

The same persistent C26 reviewer independently assessed both complete criteria
as SATISFIED, with no new findings. The original source-bound report and all
reviewer checks remain separate from the parent evidence. Parent reconciliation
agrees with the full assessments and preserves earlier finding dispositions.
Requested gpt-6-astra/ultra/no-parent-history settings follow the original
binding; effective settings remain unknown. Read-only instructions are not
OS isolation. The native dispatch result and actual correlated original report
are preserved separately, with any uncertain receipt retained as uncertain.

Final changes after R concern only five Markdown context/status records.
The mathematical source, all 832 public records and previous 831 contracts,
imports, attributes, policy, generated artifacts and dependency pins remain
exactly reviewed. Final checks verify this applicability and rerun static
validation after the documentation reconciliation. The actual result and
supported closure, when established, are referenced through completion.json
under .lit-review/setup/c26-04-20261107/. No fresh full trust/default invocation
or clean checkpoint is claimed. C26.05 and C26.06 require their own selection.

## C26.05 — Two permanent threshold consumers

The new conditional request selected only C26.05 after C26.04's supported
closure, satisfactory independent review and exact captured source, environment,
HEAD and staging were verified. The main Desktop checkout remains the source;
unrelated local work is preserved. The approved revision 2 requirements are
unchanged. The cumulative clean suite and maintained handoff remain C26.06.

### Boolean randomization and the deterministic contrast

Private Examples.NeymanPearson adapts C25's private fairLaw/alternativeLaw
construction without importing its non-stable example module. Coordinates are
(false,true), null masses (1/2,1/2), alternative masses (3/4,1/4). The public
threshold constructor at c=3/2 and gamma=1/2 gives rejection weights (1/2,0).
The consumer proves size 1/4, power 3/8 and type-II error 5/8, then applies
power_le_power_likelihoodThresholdTest to every randomized competitor under
the quarter-size cap. This proves the prescribed-level optimum, rather than
only evaluating C25's one-parameter test. A separate proof shows every
nonempty Boolean event has null size at least 1/2; every deterministic event
under the cap therefore has power zero. All fixture declarations stay private.

### Singular alternative and common-null tie

The second private fixture uses PMF.pure 0 and PMF.pure 1 on Fin 3, with c=2
and gamma=1/2. Its weights are (0,1,1/2), size zero, power one and miss zero.
Thus an alternative-only atom is rejected and a common-null atom receives
the boundary weight, with zero contribution to either operating characteristic.
The public supplied-parameter comparison handles every feasible randomized g.
The existence theorem is also instantiated at level zero. The consumer keeps
that same existential witness and its universal dominance, compares the
explicit test with it, and uses the existing unit upper bound to prove its
power is one and its miss is zero. It does not assert that the existential
parameters or common-null decision equal the explicit fixture's parameters.

### Source, validation and review boundary

The registered PW24 hash was freshly verified and Theorem 14.11, printed 284 /
PDF 309, freshly read as text. These fixtures exercise the already proved
finite mass rule and its supplied-parameter/exact-level theorems. The rejection
orientation and the zero-cost singular decision follow the conventions
recorded for C26.01–C26.04. No new generality, uniqueness claim or fresh visual
inspection is introduced. The Boolean law construction comes from the actual
private C25 source, in its documented coordinate order.

Both isolated whole-file probes passed on their first run with warnings as
errors. Exact input bytes, commands, actor/source/olean/pin applicability and
full results are retained in the private development-evidence directory.
Disposable Lean probe files were removed before the milestone; their preserved
text is durable evidence. Only the integrated module's later build and current
checks qualify the permanent source. The sole direct import stays the focused
NeymanPearson owner. No public declaration, instance, simp attribute, import,
policy or generated artifact changes are intended; the public surface stays
832 declarations in 59 supported modules and the lightweight root stays fixed.

All mathematical and canonical edits are prepared before independent review.
The exact reviewed source, original report, criterion assessments, substantive
parent reconciliation, final-source applicability and supported closure belong
under .lit-review/setup/c26-05-20261107/. Its completion.json is the actual
completion authority when present. This neutral pointer anticipates no review
verdict. If review requires no source correction, the same source can be used
for R and F after exact source/configuration/dependency revalidation, without
rewriting canonical prose merely to repeat a private verdict. Any required
correction still receives the ordinary supported correction and review process.

Initial integrated qualification passed: focused owner/consumer, Shannon and
Examples builds with warnings as errors, development static checks, a fresh
complete compiler export and exact retained comparisons against all 601 and
811 released records and all 832 preceding records. The full export is
byte-identical to C26.04; no public name or type is added or changed.
All supported source/import/pin/policy/manifest inputs are exactly C26.04.
Its compiled supported environment, root and two affected focused probes,
together with its explicitly qualified earlier 57 focused closures, remain
applicable. These are reused checks, not fresh per-import executions.
The current all-project axiom audit is fresh and includes the new private
consumers; it permits only propext, Classical.choice and Quot.sound.
This scoped qualification is separate from a fresh full trust/default suite
or a clean checkpoint. C26.06 retains that cumulative responsibility.
The original request/report, private reconciliation and supported completion
pointer determine the review outcome when established; no outcome is
predicted here and no later step has started.

### Authorized incident recovery and replacement review

The first native C26.05 review request omitted two rows from its prepared source
inventory. The bound reviewer detected the difference and stopped without issuing
a criterion report. Both known omissions, the opaque native frames, the original
uncertain receipt and the interrupted/partial checks remain preserved. Its derived
canonical-message assertion is explicitly contradicted; it supplies no delivery,
review or completion credit. The immutable prepared UTF-8 request and its older
CRLF text serialization are distinguished by byte hash. No complete native
received-text comparison or exhaustive mismatch count is claimed.

The lead authorized the narrow three-file recovery proposal. Exact candidate
bytes for the adapter, focused tests and operations guide were qualified before
application. Independent examination found and resolved a draft presentation-scope
issue. Two erroneous regression fixtures were corrected and rerun. The qualified
V4 checks comprise two fresh passes and 24 explicitly applicable earlier passes;
original failures and the interrupted obsolete broad run retain their outcomes.
There is no full V4 suite claim. The supported append-only adjudication preserves
B, the old request/receipt and all earlier completed steps, supersedes only the
unaccepted request, and resets initial validation, self-review and reassessment.
Actual qualification, authority, target and reset evidence are under
.lit-review/setup/c26-05-recovery-20261107/.

The replacement request retains the entire source inventory in its immutable
payload. A tightly guarded presentation for this incident binds the complete
neutral inventory file by SHA-256, bytes and entry count; preparation and dispatch
recheck it, and the reviewer must read and verify it. Both full mathematical
criteria, the library rubric, binding/source identity and report requirements
remain directly present. Unrelated retries keep their ordinary inline inventory.
The same persistent reviewer is reused. The originally requested profile remains
distinct from unknown effective runtime settings; read-only remains cooperative.

All Lean definitions, public declarations, imports, simp sets, manifests, pins,
HEAD, staging and unrelated local work remain unchanged by this recovery.
Replacement initial checks and the ordinary source-bound review cycle are recorded
under .lit-review/setup/c26-05-r2-20261107/. The original Step5 completion.json
will point to the actual supported closure when established. No verdict is
predicted by these pre-review notes. C26.06's earlier conditional request was
consumed/skipped while its prerequisite was incomplete; it does not revive.
Cumulative clean qualification and the maintained handoff remain C26.06.

## C26.06 — Cumulative qualification and maintained handoff

The new conditional instruction selects C26.06 after actual C26.05 closure,
both satisfactory original criterion assessments and all six final source,
environment, scope and Git components were checked. The first conditional
Step6 message remains consumed/skipped; the new instruction supplies this
selection. The actual Step5 closure is
2792951a32092ba7e4f19eb47284528958f421247c7a31170324bfdd2b763eb7.
Its replacement report, reconciliation, independent Lean checks and final
applicability are preserved under .lit-review/setup/c26-05-r2-20261107/.

The [maintained handoff](../handoffs/chunk-26.md) gives the four exact public
headers, parameter/quantifier order, proof and source adaptations, both numeric
consumers, current import boundaries and explicit next-chunk limits. All Lean
source, public contracts, imports, attributes, growth policy and dependency
pins remain unchanged in this cumulative step. The library stays at 832
supported declarations in 59 modules, 94 reviewed simp declarations and 92
lightweight-root exports. The focused testing chain has no coding imports.

### Complete criterion-to-source and evidence matrix

This matrix has nine preceding obligations and the three cumulative criteria.
Source locations refer to the current focused owners and consumers. Retained
checks keep their original actor/source/method; cumulative commands and their
actual results are recorded under .lit-review/setup/c26-06-20261107/ when
established. Earlier verdicts do not replace fresh cumulative assessment.

| Criterion | Actual source and obligation | Evidence boundary |
| --- | --- | --- |
| C26.01-RULE | NeymanPearson lines 43–62; Examples lines 32–52: all branches, equal laws and both null-atom kinds | Focused owner/consumer compilation and actual branch proofs |
| C26.01-IMPORTS | Sole owner import at line 12, full umbrella import, reviewed module/umbrella growth and unchanged root | C25 applicability and 17 focused contracts; current manifest/import, type, root and attribute audits |
| C26.02-COMPARE | Owner lines 66–93; supplied and zero-threshold callers in Examples | Signed pointwise proof for every randomized g, including ties, c=0 and singular mass |
| C26.03-SIZE | Private owner lines 137–171 | Exact U+gamma*B identity; off-support zero contribution precedes guarded ratio comparisons |
| C26.03-CROSSING | Owner lines 198–266, private positivity at 186–194 | PMF support normalization, qualifying minimum, greatest qualifying realized level, successor/no-successor split and positive boundary; includes a single realized level |
| C26.04-ATTAIN | Owner lines 271–291; Examples lines 70–111 | Positive B calibrates one common weight; same exact-size test dominates every competitor; arbitrary-law endpoint and attained type-II callers |
| C26.04-CALIBRATION | Retained C26.04 calibration-input.txt, SHA-256 c093628d90f33c001d375d417c0217041260d0125b8ebcaacec6744e17432483 | Actual four-atom row input and successful output; unequal null masses tied at one, interior size 5/6 needing threshold zero; failed earlier attempts remain failed |
| C26.05-RANDOMIZED | Examples lines 120–166 | Public supplied comparison; exact size 1/4, optimal power 3/8, miss 5/8; every feasible event has power zero |
| C26.05-SINGULAR | Examples lines 169–215 | Explicit Fin3 weights (0,1,1/2), zero size, unit power, zero miss and universal comparison; same public-existence witness obtains unit power |
| C26.06-VALIDATE | Exact candidate and current-run evidence, separate 601/811/C25-828 comparisons, 17 C25 focused names, full current boundaries and axioms | Fresh versus source-applicable checks are separate; complete clean development suite needs separately authorized checkpoint and repeats after every amendment |
| C26.06-HANDOFF | This matrix, maintained handoff, canonical summary, reference register and project log | All captured edits precede final capture; exact source/validation/review/completion references remain private durable records |
| C26.06-REVIEW | Contextual self-review, separate reassessment and one neutral cumulative request to the existing reviewer | Fresh complete assessment of all twelve obligations, original native report, substantive reconciliation, final applicability and supported closure; readiness alone is not acceptance |

### Source reconciliation and validation controls

The cumulative preparation freshly checked the registered PW24 hash and read
Theorem14.11, printed284/PDF309, as text. Sections14.1–14.2 retain their exact
earlier reading attribution. No fresh visual inspection is claimed. The mass
rule allows threshold zero, handles null atoms without division and claims
existence rather than uniqueness. No mathematical source departure changes.

The accepted C25 checkpoint is 06c71043a28af231e11490443b6225ae3b9a76eb.
Its 828-record compiler export and focused boundary artifact are the current
testing baseline; the 601 and 811 released contracts are compared separately.
Count agreement cannot establish types, universe parameters, kinds, owners or
focused visibility. The new cumulative runs retain commands, raw results,
current inputs/pins and exact producer applicability in the private directory.

The primary checkout's existing HEAD, index and all unrelated local work are
protected. A separately authorized clean validation checkpoint is required by
the approved plan. Its precise proposed content, authorization, candidate
identity, actual full-suite results and every amendment/rerun are kept in
the current private records; preparing this handoff grants no commit/worktree
authority. Private journals, reference media and proof probes are outside
the tracked candidate. The separate full API-doc gate remains its own milestone.

The Step5 noncanonical dispatch, contradicted cooperative receipt claim,
append-only adjudication, exact independent tooling qualification and all
failed/partial evidence retain their historical status. They supply no
cumulative mathematical verdict. The bound reviewer's requested creation
settings remain distinct from unknown effective settings. Native transport
uncertainty and originals remain explicit; no sandbox/authentication claim
is inferred from cooperative hashes or instructions.

Actual cumulative readiness, independent report, reconciliation, final source
and closure follow .lit-review/setup/c26-06-20261107/completion.json when
established. This source record predicts no future result. C27 requires its
own planning decision; full ROC theory, information density, kernel-risk
bridges, uniqueness and randomized decoders remain outside C26.
