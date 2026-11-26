# C25 implementation notes

These notes retain implementation evidence and evolving proof advice separately
from the [approved revision 2](release-3-chunk-25.md). The approved mathematical
endpoint and acceptance criteria govern; these notes grant no later-step authority.

## C25.01 — Test and evaluation

The lead selected C25.01 with review on 6 November 2026. Both enabling
prerequisites were qualified before this step. The development route is
`python scripts/validate_development.py`; its qualification is retained in
`.lit-review/setup/r3-growth-qualification-20261106/completion.json`.
Admission and the exact approved plan are retained in
`.lit-review/setup/c25-01-20261106/`.

### Development-route qualification facts

These are earlier, source-attributed observations, not new C25 mathematical
validation. The qualification completion JSON has SHA-256
`7cf882f03e4c4d21f82ec7655282378ae13043f8fb376db945b8d931bcc6b76e`.
At C25.01 admission the parent compared every source hash listed by that
completion record with the primary checkout; all matched before the first
public addition. The exact comparison is in `qualification-applicability.json`
under the step's private evidence directory.

| Earlier check | Recorded result and identity |
| --- | --- |
| Unmodified released mathematical surface on the development route | 811 declarations; pass at fixture commit `b8ab503897ffae7ba9cb859e686471f6dea4974f`. |
| Approved focused module and umbrella growth | 812 declarations; focused and full consumers compiled and root exclusion held at `d1ac82caca37499f7d5cf6dd7b04ad0cb663448c`. |
| Missing new-module approval | Rejected with `IMPORT_APPROVAL_REQUIRED: LeanInfoTheory.Shannon.GrowthFixture`. |
| Missing umbrella update | Rejected with `IMPORT_APPROVAL_MISMATCH: LeanInfoTheory.Shannon`. |
| Compiling post-v0.1.0 signature mutation | Adding a `True` premise to `BlockChannelCode.not_tendsto_errorProbability_zero_of_frequently_channelCapacity_add_le_codeRate` compiled through the supported umbrella and passed the 601 comparison; the 811 comparison rejected its elaborated type with `CANDIDATE_TYPE`. |
| Complete local development CI sequence | `python scripts/validate_development.py`, exit 0 at `2e45251c3d0ed0f2323e008e3c5024948c3c20b9`, tree `b03a7edc98b34f7c1c6bb8e29eefe3f31649310d`, identical to the approved-growth tree; clean before and after. |
| Independent frozen release replay | Original candidate checker passed at exact v0.2.0 commit `953b785fbdbcc9bffe22834124d5e1cbd14a4835`. Both frozen artifacts remained unchanged. |

The original matched-fixture, complete-CI and tagged-replay records are under
the qualification directory identified above. Independent prerequisite
examination used a separate support reviewer. The local CI run was on Windows;
hosted runner provisioning and optional API documentation were outside its scope.

### Interface and consumers

The implementation adds exactly six public declarations in the focused
`LeanInfoTheory.Probability.BinaryTesting` owner:

- `PMF.BinaryTest X := X → Set.Icc (0 : ℝ) 1`;
- `PMF.BinaryTest.rejectProb f P` and `rejectProb_mem_Icc`;
- `PMF.BinaryTest.size f P0`, `power f P1`, and `typeIIError f P1`.

The test assigns rejection probability. Size and power evaluate the same finite
weighted sum under the null and alternative respectively; type-II error is
one minus power. There is no prior weighting at this step. Only evaluation needs
`Fintype`; the test type has no enumeration, measurability, decidability or
inhabitance assumption. No public constant constructor, range aliases, new
instances or simp attributes are needed.

The single direct import is `Probability.TotalVariation`. The range proof uses
`PMF.toReal_nonneg`, `PMF.sum_toReal`, `Finset.sum_nonneg`,
`Finset.sum_le_sum` and `mul_le_of_le_one_right`. This keeps the finite PMF
representation and avoids a second expectation or decision-kernel abstraction.
Pinned mathlib's `ProbabilityTheory.avgRisk`, `bayesRisk` and `minimaxRisk`
remain measurable-kernel notions in `ℝ≥0∞`; C25.01 needs no bridge to them.

Private `Examples.BinaryTesting` consumers use the focused import. A local
constant test and `Finset.sum_mul` compute evaluations at arbitrary interval
weights, then specialize to zero, one and one half for arbitrary null and
alternative laws. The three operating-characteristic ranges are recovered
through `rejectProb_mem_Icc`, without opening the weighted sum. These examples
are part of the development-only Examples aggregate.

Both the new owner and the full umbrella's exact import addition are recorded
in `docs/compatibility/current-api-policy.json` under the actual lead authority.
Generated inventory contains 817 declarations in 58 supported modules; the
released baselines retain 811 and 601 declarations. Root exports remain 92.
The frozen release artifacts are unchanged. No later testing endpoint is claimed.

PW24 Section 14.1, printed 276–277 / PDF 301–302, was freshly inspected as text
by read-only source support. Its null-acceptance parameter is one minus this
API's size. The source support did not run a Lean build or perform a fresh visual
PDF check. The actual parent and reviewer checks are recorded separately below.

The warning-as-error focused owner, focused examples, full umbrella and Examples
aggregate builds passed. Separate full-umbrella and lightweight-root consumers
compiled. The development trust gate passed, including both retained baseline
comparisons, import/attribute checks and the permitted-axiom audit. Initial
compilation exposed one style warning in the private half-weight example; it
was corrected before the passing build. Independent review and substantive
reconciliation are recorded below. Closure is subject to the supported private
workflow record and `.lit-review/setup/c25-01-20261106/completion.json`. The intentionally dirty primary checkout
preserves existing work; a full clean checkpoint suite remains C25.06's separately
authorized gate. No commit, hosted Actions, API-doc build or publication is claimed.

### Independent review and final applicability

The bound C25 reviewer assessed both complete criteria as `SATISFIED`, with no
new findings. It freshly passed the warning-as-error four-target build,
development static gate, compiled 601/811 comparison, full-umbrella consumer
and expected-negative root consumer. The compiled comparison found exactly
the six BinaryTest additions and 817 current declarations. Its separate range
theorem axiom check used only `propext`, `Classical.choice` and `Quot.sound`.
The parent's earlier full trust audit checked all 108 project modules and
4083 local constants against the same permitted axioms.

The original report retains two failed reviewer-probe attempts: a missing
`noncomputable section`, and a wrapper that initially failed to recognize
Lean's named unknown-constant errors. The corrected probes passed. Neither
required a project-source change, and neither failed observation supplies a
passing criterion citation. The parent independently reconciled each complete
criterion and these probe corrections. Original report and reconciliation:
`.lit-review/setup/c25-01-20261106/original-report.txt` and
`parent-reconciliation.json` in the same directory.

The reviewer also withdrew its earlier optional PW24 quantifier finding after
freshly checking that Section 7.3 expressly permits randomized decision rules.
Revision 2 already states that scope correctly. The earlier report is retained
as history; no normative plan change or mathematical correction is warranted.

Finalization changes only this note, the plan's editorial status, the living
summary and the project log. The final applicability check must confirm that
all mathematical sources, imports, policy, generated artifacts, build inputs,
dependency pins and frozen contracts still match the reviewed source. Fresh
development static checks cover the final documents. Compiler and trust results
retain their original attribution; they are reused only for unchanged inputs.
HEAD, staging and preexisting unrelated changes are preserved. No event-test
constructor or later C25 step has been started. The clean cumulative checkpoint
suite remains C25.06's separately authorized gate.

## C25.02 — Deterministic event tests

The lead conditionally selected C25.02 with review on 6 November 2026. Before
admission the parent verified the supported C25.01 closure, both satisfactory
original reviewer assessments, no active or paused work, the ordered next step
and exact equality with C25.01's final source. The observed admission and source
check are retained under `.lit-review/setup/c25-02-20261106/`.

Four declarations extend the existing `PMF.BinaryTest` namespace:

- `ofEvent s` rejects exactly on the arbitrary set `s`;
- `ofEvent_apply s x` exposes its real zero-one indicator;
- `rejectProb_ofEvent s P` identifies rejection with `(P.toOuterMeasure s).toReal`;
- `typeIIError_ofEvent s P1` identifies the miss with `(P1.toOuterMeasure sᶜ).toReal`.

The constructor and pointwise theorem require no finite enumeration. Classical
decidability is local to their implementation and statement elaboration; callers
need no `DecidablePred`, measurable-space, support or inhabitance premise. The
mass identities use the existing finite evaluation context. No import, policy,
instance or simp-attribute change is needed. The six C25.01 contracts remain.

The rejection proof reuses `PMF.toOuterMeasure_toReal_eq_sum` from
`Probability.TotalVariation:111`. For the complement, mathlib's generated
`Set.indicator_compl` (`Algebra/Group/Indicator:174`) expresses the complementary
indicator as total mass minus the event indicator. `Pi.sub_apply`,
`Finset.sum_sub_distrib` and `PMF.sum_toReal` finish the real identity. This
avoids a separate measurable decision kernel or an ENNReal subtraction lemma.

Private focused consumers use the public event identities to recover size,
power and complementary miss without unfolding the rejection sum. Empty and
full events give (size, power, miss) = (0,0,1) and (1,1,0). A generic singleton
consumer uses `PMF.toOuterMeasure_apply_singleton`; the concrete null
`PMF.pure false`, alternative `PMF.pure true` and event `{true}` give (0,1,0).
An arbitrary-type pointwise caller also checks that construction does not need
`Fintype`. The positive-overlap optimizer and prescribed-size fixtures remain
C25.05/C26 work.

PW24 Section 14.1 (PDF 301) defines the deterministic test by its decision-region
indicator, with one meaning rejection. Fresh targeted parent text inspection
used the registered PDF; no fresh visual inspection is claimed. Read-only source
support independently identified the pinned indicator and singleton anchors;
that support did not compile or edit files and is not the formal step review.

### C25.02 parent validation facts

The warning-as-error owner, focused examples, full umbrella and Examples
aggregate build passed (3138 jobs). The first attempt found only an explicit
normalization missing from the private empty/full consumers; the corrected
consumers use the public real event-mass formula and `PMF.sum_toReal`.
No public contract was weakened. Separate full-umbrella and root consumers
passed. The constructor was usable on `Nat`, and the full-umbrella caller
recovered size and complementary miss through the event API. All ten testing
declarations were absent from the lightweight root. Each of the four new
declarations used only `propext`, `Classical.choice` and `Quot.sound`.

The development static and fresh compiled compatibility gates passed. The
compiled comparison retained all 601 v0.1.0 and 811 v0.2.0 declarations, with
821 current declarations: the six C25.01 declarations and four event-test
additions beyond v0.2.0. Its actual compiler exports and boundary audit are in
`.lake/compatibility/977176aee4e74f8eb63f20dc4243c06a`.
A supplementary comparison of the hash-verified compiler exports retained all
817 preceding C25.01 declaration records exactly (name, kind, owner and
elaborated type). This does not create another frozen release baseline.
Current export SHA-256:
`b3168806d2c806d51d1a709e5e9aefa852a0ce1e1584efd4dd7696b84f88ceaf`.

Two local evidence wrappers failed after successful check subprocesses: one
displayed a UTF-8 log through a cp1252 console; another parsed a brace in a Git
command as the start of the compatibility JSON. The complete original logs and
exit records were preserved. Direct log inspection and a separate hash-verified
export comparison confirmed the results; the collector now selects the JSON
result line explicitly. Neither issue required a Lean or validator change.

These are parent check facts, not an independent verdict. The original command
logs and result records, including failed probes and evidence-driver issues,
are retained under `.lit-review/setup/c25-02-20261106/`. The whole-project trust
audit from C25.01 remains earlier evidence; this step freshly checks the four
new declarations' axioms and both compiled baselines. The existing owner,
umbrella approvals and all imports are unchanged. Additional pinned indicator,
PMF-monad and finite-sum anchors were inspected at the clean mathlib revision
already captured by the workflow environment; their byte hashes are separately
retained for final applicability.

Independent review and substantive reconciliation are recorded below. Closure
remains subject to the supported private record and
`.lit-review/setup/c25-02-20261106/completion.json`.
No later step, commit, clean checkpoint, hosted run, API-doc build or publication
has been selected. Full cumulative clean validation remains C25.06's gate.

### C25.02 independent review and final applicability

The bound C25 reviewer assessed the complete `C25.02-EVENT` criterion as
`SATISFIED`, with no new findings. It freshly passed the warning-as-error owner
and focused-example build (2498 jobs), development static gate, arbitrary-event
consumers on finite laws, constructors on `Nat` and `Empty`, complementary-test
specialization, root exclusion of all ten testing declarations and all four new
declarations' axiom checks. Only `propext`, `Classical.choice` and `Quot.sound`
were used. The reviewer independently inspected the implementation and source
convention; its PW24 inspection used targeted text extraction.

For compiled compatibility the reviewer reused the parent's passing run after
checking all 20 recorded output hashes, all 131 producer-file hashes against
current source, the identical before/after producer records and all 817 preceding
compiled declaration records. It did not rerun the compiler export or boundary
audit. The parent run retained both released baselines and exactly four new
declarations beyond C25.01. Fresh parent and reviewer checks remain separately
attributed; the earlier C25.01 whole-project trust audit is not a fresh C25.02 run.

The original report retains one failed reviewer probe: `Set.compl_compl` was an
incorrect namespace for the pinned `compl_compl` theorem. Its corrected consumer
passed without changing project source. The failed observation remains in the
verification list and is absent from the criterion's passing evidence. The
parent reconciled every clause of the criterion, the probe failure, compatibility
reuse and earlier advice. No mathematical correction, extra public helper or
normative plan revision is warranted. The earlier PW24 quantifier finding remains
withdrawn. Original report and reconciliation are retained as
`.lit-review/setup/c25-02-20261106/original-report.txt` and
`parent-reconciliation.json` in the same directory.

Finalization changes only this note, the plan's editorial status, the living
summary and the project log. It also clarifies that 821 means ten additions
since v0.2.0 and four since C25.01. The final applicability check must confirm
that reviewed mathematical sources, consumers, imports, policy, generated
artifacts, build inputs, dependency pins, additional inspected mathlib anchors
and frozen contracts remain unchanged. Fresh development static checks cover
the final documents; earlier compiled and axiom evidence is reused only for
unchanged inputs with its original attribution. HEAD, staging and unrelated
local work are preserved. C25.03 and later steps remain unselected; the
cumulative clean suite remains C25.06's separately authorized gate.

## C25.03 — Lower bound for randomized tests

The lead conditionally selected C25.03 with review on 6 November 2026. Before
admission the parent verified the supported C25.02 closure, its satisfactory
original reviewer assessment, absence of active/paused/blocked work, the ordered
next step and exact equality with C25.02's final source. The observed admission
and source check are retained under `.lit-review/setup/c25-03-20261106/`.

Two declarations extend the existing `PMF.BinaryTest` namespace:

- `errorSum f P0 P1` is `size f P0 + typeIIError f P1`;
- `one_sub_totalVariation_le_errorSum f P0 P1` bounds this sum below by
  `1 - PMF.totalVariation P0 P1` for every randomized test.

Both retain the existing `[Fintype X]` evaluation context, with no extra support,
inhabitance, absolute-continuity, decidability or measurability assumptions.
The sum is unweighted; equal-prior average error and an attaining optimizer are
not defined in this step. Imports, policy approvals, instances and simp
attributes are unchanged. The ten C25.01–C25.02 declarations remain.

The proof specializes `PMF.abs_sum_sub_le_totalVariation_of_mem_Icc`
(`Probability.TotalVariation:295`) to real rejection weights in `[0,1]`.
Its interval width is one. The left component of mathlib's `abs_le`
(`Algebra/Order/Group/Abs:64`, generated additively) gives
`-TV ≤ rejectProb f P0 - rejectProb f P1`. Unfolding only the role names and
error sum then gives the requested inequality by real linear arithmetic.
No public signed-advantage helper or TV commutation is necessary.

A private focused caller recovers `power f P1 ≤ size f P0 + TV` for an
arbitrary test through the new theorem. A second caller reuses the existing
constant one-half test, applies the universal bound, and computes its error sum
as one through the earlier operating-characteristic consumer. It therefore
exercises an interior rejection weight without introducing a second test type
or a later-step fixture.

PW24 Section 7.3, Theorem 7.7(a)/(7.17)–(7.19), explicitly includes possibly
randomized decision rules. Fresh targeted parent text inspection of PDF147–148
at the registered hash confirms the sum and normalization; no fresh visual
inspection is claimed. Read-only source support independently checked the
signed proof route and source anchors, without editing or compiling. This
support is separate from the formal step reviewer.

### C25.03 parent validation facts

The warning-as-error owner, focused examples, full umbrella and Examples
aggregate build passed on the first attempt. Both permanent callers compiled.
Separate full-umbrella and root consumers passed: the full umbrella exposes
the unweighted error sum and arbitrary randomized-test bound, while all twelve
testing declarations remain absent from the lightweight root. Both new public
declarations use only `propext`, `Classical.choice` and `Quot.sound`.

The development static and fresh compiled compatibility gates passed. The
compiled comparison retained all 601 v0.1.0 and 811 v0.2.0 declarations, with
823 current declarations: ten preceding testing declarations and the two
C25.03 additions beyond v0.2.0. Its actual compiler exports and boundary audit
are in
`.lake/compatibility/b4bb7f6850ed461690c3458727878aaa`.
A supplementary comparison of the hash-verified compiler exports retained all
821 preceding C25.02 declaration records exactly (name, kind, owner and
elaborated type). This is not another frozen release baseline. Current export
SHA-256: `66f0bc29d5863e978c68edd8edea7fd31d319a9b92be67930692e859bdc6f012`.

These are parent check facts, not an independent verdict. The original commands,
logs, results and exact source identities are retained under
`.lit-review/setup/c25-03-20261106/`. The whole-project trust audit from C25.01
remains earlier evidence; this step freshly checks the two new declarations'
axioms and both compiled baselines. Existing owner/umbrella approvals and all
imports are unchanged. The additional pinned `abs_le` source hash is retained
alongside the clean mathlib identity for final applicability.

Independent review and substantive reconciliation are recorded below. Closure
remains subject to the supported private record and
`.lit-review/setup/c25-03-20261106/completion.json`.
No C25.04 work, commit, clean checkpoint, hosted run, API-doc build or publication
has been selected. Full cumulative clean validation remains C25.06's gate.

### C25.03 independent review and final applicability

The bound C25 reviewer assessed the complete `C25.03-BOUND` criterion as
`SATISFIED`, with no findings. It freshly passed the warning-as-error owner,
focused-example, full-umbrella and Examples aggregate build (3138 jobs),
development static gate and separate full-umbrella consumers. The additional
clients use an arbitrary randomized test, derive a TV lower bound from a cap
on the error sum, and apply the theorem to a nonconstant Boolean test with
rejection weights one half and one third. Both new declarations' axiom checks
use only `propext`, `Classical.choice` and `Quot.sound`. Fresh targeted PW24
text inspection confirms the randomized scope and unweighted normalization;
no fresh visual-page check is claimed.

The root expected-absence probe passed: Lean returned exit 1 with exactly the
twelve expected unknown-constant diagnostics, and the checking wrapper returned
exit 0. This is successful negative-probe evidence, not a failed implementation
build. All eight original evidence outcomes are `PASS`.

For compiled compatibility the reviewer reused the parent's passing run after
checking all 20 recorded command-output hashes, all 131 producer-file hashes
against current source, identical before/after producer records, the boundary
export and all 821 preceding compiled declaration records. It did not rerun the
compiler export or boundary audit. The parent run retained the 601 v0.1.0 and
811 v0.2.0 declarations, with 823 current declarations and exactly two additions
since C25.02. Fresh parent and reviewer checks remain separately attributed;
the earlier C25.01 whole-project trust audit is not a fresh C25.03 run.

The parent reconciled every clause of the criterion, the original eight evidence
entries, compatibility reuse and earlier advice against the actual source.
Specialization to the unit interval has factor one, and the lower branch of
`abs_le` has the sign needed for null rejection plus alternative acceptance.
Both required permanent consumers compile. No mathematical correction, extra
public helper or normative plan revision is warranted. The earlier PW24
quantifier finding remains withdrawn. The original report and substantive
reconciliation are retained as
`.lit-review/setup/c25-03-20261106/original-report.txt` and
`parent-reconciliation.json` in the same directory.

Finalization changes only this note, the plan's editorial status, the living
summary and the project log. The final applicability check must confirm that
reviewed mathematical sources, consumers, imports, policy, generated artifacts,
build inputs, dependency pins, additional inspected mathlib anchors and frozen
contracts remain unchanged. Fresh development static checks cover the final
documents; earlier compiled and axiom evidence is reused only for unchanged
inputs with its original attribution. HEAD, staging and unrelated local work
are preserved. C25.04 and later steps remain unselected; cumulative clean
validation remains C25.06's separately authorized gate.

## C25.04 — Strict optimizer and equal-prior error

The lead conditionally selected C25.04 with review on 6 November 2026. Before
admission the parent verified the supported C25.03 closure, its satisfactory
original reviewer assessment, absence of active/paused/blocked work, the ordered
next step and exact equality with C25.03's final source. The admission and source
check are retained under `.lit-review/setup/c25-04-20261106/`.

Five declarations extend the existing `PMF.BinaryTest` namespace:

- `tvTest P0 P1 := ofEvent {x | P0 x < P1 x}` needs no finite enumeration;
- `errorSum_tvTest P0 P1` evaluates its error sum to `1 - TV`;
- `isLeast_errorSum P0 P1` states that `1 - TV` is the attained least value
  in the range over every randomized test;
- `equalPriorError f P0 P1 := errorSum f P0 P1 / 2` is the average error
  for equal priors and zero-one loss;
- `isLeast_equalPriorError P0 P1` gives the attained least value `(1 - TV) / 2`
  over the same randomized tests, with the same strict witness.

Evaluation and least-value statements retain `[Fintype X]`. There are no new
support, inhabitance, decidability, absolute-continuity or measurability premises.
The strict comparison accepts ties, including atoms null under both laws.
No import, public helper, global instance, simp attribute or approval changes
are needed. All twelve preceding testing declarations remain unchanged.

The approved complement-event route works directly. Finite PMF atom masses and
`ENNReal.toReal_le_toReal` identify the strict rejection event's complement
with the released weak-dominance event. The two C25.02 event identities and
`PMF.totalVariation_eq_toOuterMeasure_sub` give the exact error without expanding
weighted sums. The least-value proof combines that witness with C25.03's bound
on every randomized test. Dividing by the positive constant two gives the
equal-prior statement. Pinned `Order.Bounds.Defs` supplies `IsLeast`, and
`Algebra.Order.GroupWithZero.Basic` supplies `div_le_div_of_nonneg_right`.

Private focused consumers recover the explicit strict witness and compare it
with arbitrary randomized competitors. A separate caller derives the equal-prior
value at that same test and the bound on every test through the least-value API.
A private fair Boolean law versus `PMF.pure false` has positive overlap one half;
TV is one half, the strict test's error sum is one half and its equal-prior error
is one quarter. This checks normalization without implementing C25.05's sparse
three-point or symbolic-gamma fixtures.

Fresh parent and read-only support text inspection of the registered PW24
Sections 7.3 and 14.1 confirms the randomized scope, attained sum and prior
weighting. The parent retained one text-display wrapper failure caused by the
Windows default encoding; both PDF text extractions had succeeded, and the
UTF-8 display/anchor-recording follow-up passed. This was not a Lean failure or
source change. No fresh visual-page check is claimed. Pinned mathlib decision
risk definitions were inspected; their measurable-kernel bridge remains deferred.
Read-only support supplied source advice without edits or builds and is separate
from the formal reviewer.

### C25.04 parent validation facts

The warning-as-error owner, focused examples, full umbrella and Examples
aggregate build passed after replacing deprecated `Set.mem_setOf_eq` with
`Set.mem_ofPred_eq`. The first build compiled all targets but its strict gate
returned exit 1 for that warning; its original log and result remain retained.
Permanent callers recover the strict witness, compare
arbitrary randomized competitors, derive the equal-prior value and lower bound,
and check the positive-overlap factor of two. Separate full-umbrella and root
consumers passed. The constructor also compiles without finite enumeration;
all seventeen testing declarations remain absent from the lightweight root.
The first umbrella probe omitted a noncomputable section around its
constructor-valued example. Its other examples and five axiom checks succeeded;
the corrected probe passed without any library-source change. The original
failed input, output and result remain retained separately.
All five new declarations use only the permitted `propext`, `Classical.choice`
and `Quot.sound` axioms.

The development static and fresh compiled compatibility gates passed. Both
released baselines retain all 601 v0.1.0 and 811 v0.2.0 declarations. Current
coverage is 828 declarations in 58 supported modules with 92 root exports:
twelve earlier testing declarations and five C25.04 additions beyond v0.2.0.
The actual compiler exports and boundary audit are in
`.lake/compatibility/4fea1fa0a3e04962b70656f6ae2e596b`.
A supplementary comparison retained all 823 preceding C25.03 compiler records
exactly (name, kind, owner and elaborated type). This is not another frozen
baseline. Current export SHA-256:
`d6962858d3d6dba55f2b298dbf61fcffe1d03099a538ffe74f0e777231021d9d`.

These are parent check facts, not an independent verdict. Original commands,
logs, source identities and build-attempt history are retained under
`.lit-review/setup/c25-04-20261106/`, including the text-display wrapper failure
and its successful UTF-8 follow-up, plus the corrected umbrella-probe failure.
Earlier C25.01 whole-project trust remains
earlier evidence; C25.04 freshly checks its five additions' axioms and both
compiled baselines. The inspected mathlib anchors are hash-recorded alongside
the clean pinned dependency identity for final applicability. Normative plan,
HEAD, staging and unrelated local work are preserved.

Independent review and substantive reconciliation are recorded below. Closure
remains subject to the supported private record and
`.lit-review/setup/c25-04-20261106/completion.json`.
No C25.05 work, commit, clean checkpoint, hosted run, API-doc build or publication
has been selected. Full cumulative clean validation remains C25.06's gate.

### C25.04 independent review and final applicability

The bound C25 reviewer assessed both complete criteria, `C25.04-ATTAIN` and
`C25.04-PRIOR`, as `SATISFIED`, with no findings. Its fresh warning-as-error
owner, focused-example, full-umbrella and Examples aggregate build passed
(3138 jobs), as did development static checks and separate full-umbrella
consumers. A single explicit `tvTest` witness minimizes both objectives against
arbitrary randomized competitors. Additional clients check range membership,
pointwise strict rejection and tie acceptance without `Fintype`, and construction
on `Nat`. All five additions use only `propext`, `Classical.choice` and
`Quot.sound`. Fresh targeted PW24 text and pinned-source inspection confirm the
randomized scope, finite-mass conversion, attained minimum and prior weighting;
no fresh visual-page check is claimed.

The root expected-absence probe passed: Lean returned exit 1 with exactly
seventeen expected unknown-constant diagnostics and empty stderr; its checking
wrapper returned exit 0. This is successful negative-probe evidence, not a
failed implementation build. All eight original reviewer evidence outcomes
remain `PASS`. Non-failing CRLF-to-LF notices in static Git checks do not change
that outcome. The parent attempt history above remains separately attributed;
the reviewer did not claim to inspect those private original logs.

For compiled compatibility the reviewer reused the parent's passing run after
independently checking all 20 command-output hashes, all 131 current producer
inputs, identical before/after snapshots, the compiled boundary output and
all 823 preceding declaration records. It did not rerun the expensive compiler
export or boundary audit. Both released baselines retain their 601 and 811
declarations; current coverage is 828, with exactly the five planned additions.
All seventeen testing names are exposed by the focused owner and absent from
the lightweight root and its simp set. The owner still imports only TotalVariation.
Fresh parent and reviewer checks remain separately attributed; the earlier
C25.01 whole-project axiom audit is not a fresh C25.04 run.

The parent reconciled each clause of both criteria, all eight original evidence
entries, compatibility reuse and earlier advice against actual source. The
complement-event proof respects both law orientation and ties; the `IsLeast`
statements include attained membership and bounds for every randomized test.
The same explicit witness attains both minima. The positive-overlap fixture
checks an error sum of one half and equal-prior average of one quarter. No
mathematical correction, extra public helper or normative plan revision is
warranted. The earlier PW24 quantifier concern remains withdrawn. The original
report and substantive reconciliation are retained as
`.lit-review/setup/c25-04-20261106/original-report.txt` and
`parent-reconciliation.json` in that directory.

Finalization changes only this note, the plan's editorial status, the living
summary and the project log. Final validation must confirm exact preservation
of reviewed mathematical sources, consumers, imports, policy, generated artifacts,
build inputs, dependency pins, additional inspected mathlib anchors and frozen
contracts. Fresh development static checks cover the final documents; previous
compiled and axiom results apply only to unchanged inputs and retain their
original attribution. HEAD, staging and unrelated local work are preserved.
C25.05 and later steps remain unselected; cumulative clean validation remains
C25.06's separately authorized gate.

## C25.05 — Permanent examples and the next caller

The lead conditionally selected C25.05 with review on 6 November 2026. Before
admission the parent verified C25.04's supported closure, both satisfactory
original criterion assessments, the absence of active/paused/blocked work,
the ordered next step and exact equality with C25.04's final source. Records
are retained under `.lit-review/setup/c25-05-20261106/`.

All mathematical additions are private consumers in
`LeanInfoTheory.Examples.BinaryTesting`, under its existing single focused
import. Public owner, declarations, imports, attributes and approval policy
are unchanged. No new fixture or threshold abstraction is public.

- Equal laws: every randomized test has power equal to size, miss equal to
  one minus size, error sum one and equal-prior error one half. The strict
  rejection event is empty, and both public least-value theorems specialize.
- Disjoint pure laws at atoms zero and one of `Fin 3`: the strict event is
  `{1}`. The test rejects the alternative-only atom and accepts the common-null
  atom two. Size is zero, power one, miss and both errors zero; TV is one.
- Sparse laws `(1/2,1/2,0)` and `(0,1/2,1/2)`: the strict event is `{2}`.
  Size is zero, power and miss one half, minimum error sum one half and average
  one quarter. Randomizing at the middle tie with probability one half changes
  size/power/miss to one quarter, three quarters and one quarter, retaining
  both optimum values against every randomized competitor.
- Boolean coordinates `(false,true)`: reuse `fairLaw` as `(1/2,1/2)` and add
  the private alternative `(3/4,1/4)`. `gammaTest` has weights `(gamma,0)` for
  arbitrary gamma in the real unit interval. Its size is gamma/2, power is
  3*gamma/4, miss is 1-3*gamma/4, error sum is 1-gamma/4 and average half that.
  Both numerical rows specialize this single calculation. At gamma=1 the test
  equals the public strict optimizer, rejects a shared positive-mass atom and
  has size 1/2, power 3/4, miss 1/4, sum 3/4 and average 3/8. TV is 1/4, and
  the public attained-minimum statements apply. At gamma=1/2 the corresponding
  values are 1/4, 3/8, 5/8, 7/8 and 7/16. The smaller test meets size cap 1/4
  and pays an additional 1/8 in error sum. Optimality at prescribed size
  remains C26's responsibility.

Event evaluations reuse `singleton_characteristics` and the public event-mass
identities. The private sparse-law construction follows the existing focused
TV example, without importing that development module. Public C25.04 exact
error and least-value theorems supply the TV/minimum connections. Fresh targeted
PW24 text extraction confirms the rejection, conditional-error and prior
conventions at the registered hash. Numerical fixtures were cross-checked with
exact rational arithmetic; that is supplementary, not Lean validation. Read-only
source support supplied proof advice without builds, edits or formal review.

### C25.05 parent validation facts

The warning-as-error focused owner, focused examples, full umbrella and Examples
aggregate build passed. All 25 new private declarations were separately compiled
and axiom-checked from the exact example source through Lean stdin; their axioms
are limited to `propext`, `Classical.choice` and `Quot.sound`. A full-umbrella
consumer also passed, constructing a symbolic test through the public API and
comparing the strict witness with arbitrary randomized competitors for both errors.

Three earlier focused-build failures remain retained with their original source
hashes and output: the first exposed finite-index simplification, arithmetic
normalization, one noncomputable private test and linter issues; the second
exposed simplifier recursion from a broad `Fin.ext_iff` rewrite; the third
required keeping the named sparse laws folded when rewriting their characteristics.
The final proof uses explicit finite inequalities and atom-mass rewrites. It
changes no example statement, public contract, assumption or global option.
The first full-umbrella probe also failed its warning-as-error check for an unused
`Fintype.sum_bool` simp argument. Removing only that private probe argument passed;
the original input, output and result are retained separately. Static and private
axiom results were reused on exactly unchanged source for that probe correction.

Development static checks and a fresh compiled compatibility run passed. The
601 v0.1.0 and 811 v0.2.0 declarations are retained. Current coverage remains
828 declarations in 58 supported modules with 92 unchanged root exports. All
828 preceding compiler records match exactly, with no public additions, removals,
owner or signature changes. The actual artifacts are in
`.lake/compatibility/e935d8a1b0b9434895223af2d23c7eb8`.
Current compiler export SHA-256:
`d6962858d3d6dba55f2b298dbf61fcffe1d03099a538ffe74f0e777231021d9d`.
The producer comparison with C25.04 changes only the private example file;
public sources, imports, policy, inventory and frozen inputs are byte-identical.
The fresh compiled boundary audit checks current exports, imports, root exclusion
and simp sets. No new public axiom audit is needed for an unchanged public owner;
C25.01 whole-project trust remains earlier evidence, with the 25 current private
additions freshly checked here.

Fresh parent source/text inspection and exact-rational fixture arithmetic are
separately attributed from Lean validation and read-only support advice. No fresh
visual textbook inspection is claimed. Normative plan, HEAD, staging and unrelated
local work are preserved. Original implementation commands, logs, source
identities and attempt history are retained under
`.lit-review/setup/c25-05-20261106/`. Separately approved repair, qualification,
fresh readiness and attempt-2 review records are retained under
`.lit-review/setup/c25-05-recovery-20261106/`, as described below.

Fresh independent review and substantive reconciliation are recorded below.
Closure remains subject to the supported private record and
`.lit-review/setup/c25-05-20261106/completion.json`.
C25.06, a clean checkpoint, commits, hosted validation, API-doc builds and
publication remain unselected.

### C25.05 narrow recovery and fresh independent review

The first native review dispatch contained an extra `71f` in the README hash.
The saved canonical request and actual native evidence were preserved; no
accepting report or criterion assessment was issued. The reviewer corroborated
the mismatch and observed exit 1 after interrupting its build, without claiming
successful completion or independently established termination of every
descendant process. Opaque stored message bytes remain opaque; no full received
plaintext hash or authenticated transport claim is made.

The lead separately approved a narrowly scoped repair, independent verification
and a fresh C25.05 review. Only `tools/lit_review/project.py`, its noncanonical
dispatch tests and `docs/review-operations.md` changed for that repair. The
observed recovery pins the exact incident, request, source, binding, native call,
field mismatch, protected Git state and three repair paths. It preserves the
existing C24 guards. Seven completed runner cases passed across implementer and
parent checks. Independent examination also exercised actual-input mutation
refusals, C24 guard controls and a complete synthetic C25 recovery/reload/fresh
cycle. A parent-identified retained-step condition was corrected before
qualification. The interrupted first tooling run remains retained; the full
duplicated suite was not claimed to have completed.

The supported append-only recovery superseded only the unaccepted request and
reset readiness. It conferred no mathematical review or closure credit. Fresh
parent focused and static checks passed on the qualified source. Earlier
compiler, umbrella-consumer and private-axiom evidence was reused only after
verifying unchanged inputs, including all 131 compiled producer files and the
additional pinned mathlib anchors. Repair evidence, original examination,
adjudication, fresh request and original report are retained in
`.lit-review/setup/c25-05-recovery-20261106/`. Original implementation and
malformed-attempt records remain in `.lit-review/setup/c25-05-20261106/`.

The same bound reviewer independently assessed fresh attempt 2, source
`d82c426866700ac3fc961187dfdeaafb450892b6f171c872d1ac58baa1ffeae1`.
Both complete criteria, `C25.05-EXAMPLES` and `C25.05-CALLER`, are `SATISFIED`,
with no findings. All eight original reviewer evidence outcomes are `PASS`.
Its fresh warning-as-error four-target build passed (3138 jobs), as did the
development static gate and exact-source stdin re-elaboration of all 25 new
private declarations. Their axioms are exactly `propext`, `Classical.choice`
and `Quot.sound`. Static Git CRLF notices were non-failing. The reviewer also
refreshed the registered PW24 text and pinned source anchors, and checked final
source identities; no fresh visual textbook check is claimed.

For compiled compatibility the reviewer independently checked the parent's ten
successful command records and all twenty output hashes, identical before/after
producer snapshots, all 131 current producer inputs, the boundary output and
all 828 unchanged C25.04 compiler declaration records. Both released baselines
retain 601 and 811 declarations. This is verified reuse of parent-produced
compiler evidence, not a fresh reviewer compiler-export or boundary run. The
producer-input comparison changes only the private example file; it makes no
such claim about the full repository delta. The 17 testing names, focused-owner
import, root exclusion and simp sets are unchanged. Current coverage remains
828 declarations, 58 modules and 92 root exports.

The parent reconciled every clause of both criteria and all eight evidence
entries against source. Equal laws cover arbitrary randomization; the pure-law
example exercises alternative-only and common-null atoms; the sparse example
evaluates strict and randomized-tie tests and compares the latter with every
randomized competitor. One symbolic gamma calculation supplies both Boolean
rows. The strict optimizer rejects a shared positive-mass atom and minimizes
both objectives; the smaller-size caller pays the stated additional error
without a prescribed-level optimality claim. No mathematical correction, new
public helper or normative plan revision is warranted. The earlier PW24
randomized-quantifier concern remains withdrawn. Original parent failures and
the interrupted first review retain their actual results and limits; successful
fresh checks do not rewrite them. The complete original report and substantive
reconciliation are `original-report.txt` and `parent-reconciliation.json` in
the recovery directory.

Finalization changes only the plan's editorial status, this note, the living
summary and the project log. Final static and exact reviewed-to-final checks
must confirm preservation of mathematical sources, private consumers, qualified
repair bytes, imports, policy, generated references, dependency pins, frozen
contracts, HEAD, staging and unrelated work. Earlier checks retain their own
attribution and apply only to unchanged inputs. The established completion
pointer is written only after supported closure. The earlier conditional
C25.06 request was consumed as skipped while C25.05 was incomplete and does not
revive; C25.06 remains unselected. Cumulative validation and the maintained C26
handoff remain that final step's work. No clean checkpoint, hosted validation,
API-doc build, commit or publication is claimed here.

## C25.06 — Cumulative qualification and handoff preparation

The new request received after successful C25.05 closure selected only C25.06.
Its intake freshly verified the supported predecessor closure, both satisfied
criteria, original valid review and exact final-source applicability. The old
conditional message remains consumed as skipped; it was not revived. Read-only
installed workflow `inspect` and `api` commands passed before admission.
The admission and source identities are under
`.lit-review/setup/c25-06-20261106/`. Revision 2's normative text is unchanged.

The maintained [handoff](../handoffs/chunk-25.md) gives every public signature,
focused/full/root import boundaries, source adaptations, permanent numerical
and symbolic consumers, and deferred owners/triggers. C25.06 changes only six
documentation paths; it preserves the mathematical owner, private examples,
qualified tooling, both frozen artifacts and primary HEAD/index.

### Cumulative source/evidence matrix

The approved execution contract has eleven criteria overall. Its C25.06 native
report has exactly three top-level criteria. Fresh source-bound evidence for
VALIDATE and REVIEW must explicitly assess all eight preceding rows as well;
the native report format is not silently extended. Earlier successful reviews
are historical inputs, not automatic cumulative acceptance.

| Criterion | Current source and concrete consumer | Evidence required for cumulative acceptance |
| --- | --- | --- |
| C25.01-API | `BinaryTest`, `rejectProb` and range, size/power/miss in the focused owner; constant 0/1/1/2 tests and operating bounds in focused examples | Fresh assessment of rejection orientation, finite evaluation and range; current compiled consumers |
| C25.01-IMPORTS | Sole TotalVariation import, Shannon exposure, root exclusion, Examples-only consumers; both recorded import approvals | Current 601/811 retained comparisons, 828-declaration inventory, focused/full/root imports, simp and trust; preserved frozen artifacts |
| C25.02-EVENT | `ofEvent`, pointwise indicator, rejection-event and complementary alternative mass; arbitrary/empty/full/unequal singleton consumers | Fresh check of law orientation and no construction-level finiteness or public decidability premise |
| C25.03-BOUND | `errorSum` and universal TV lower bound; arbitrary and interior-weight consumers | Fresh check of every randomized test, signed advantage and unweighted error sum |
| C25.04-ATTAIN | Strict `tvTest`, complement-event identity and `IsLeast`; explicit witness and arbitrary competitor | Fresh check of strict ties, null atoms, actual attainment and all-randomized range |
| C25.04-PRIOR | `equalPriorError`, attained least half-sum; same witness, arbitrary competitor and positive-overlap values | Fresh factor-of-two check; no unsupported measurable-kernel bridge claim |
| C25.05-EXAMPLES | Equal, pure Fin 3, sparse overlap and randomized middle-tie private consumers | Fresh check of individual characteristics, event identity, TV and both minima; applicable current compilation |
| C25.05-CALLER | Symbolic `gamma_characteristics`, strict and half-weight rows, shared positive atom and size-cap/cost | Fresh check of symbolic usability and both rows; prescribed-level optimality stays C26 |
| C25.06-VALIDATE | Exact whole candidate and qualified development route | Dirty-checkout preparation evidence below; approved-checkpoint records must establish a passing complete clean suite for the exact reviewed source, with a full rerun after amendment |
| C25.06-HANDOFF | Maintained handoff plus living summary, reference register and project log | Exact signatures/imports/adaptations/examples and C26/C27/deferred contracts supplied; final independent assessment required |
| C25.06-REVIEW | This matrix, contextual self-review, separate reassessment and source-bound cumulative request | Self-review exit, fresh original review, substantive reconciliation, any corrections and final applicability/closure must be evidenced before completion |

### Fresh checks and applicability limits

The parent ran the focused owner, focused examples, Examples aggregate and
Shannon umbrella together with warnings as errors, then the default
warning-as-error build. The complete development `trust` command passed,
including its own maintained build, independent 601/811 compiled retention,
current declaration and import boundaries, reviewed simp sets and all-project
axiom probes. The documentation route passed its release-facing contract and
independently compiled README/website guide examples. Each command's actual
exit code, original log hash and before/after repository-file hashes,
HEAD/index/staged-diff identity and mathlib HEAD/status are in `checks/`
under the step directory. The nested compatibility records retain their producer
input and dependency identities, and the trust command checks its full validation
identity before and after its probes. All four commands passed
with unchanged captured inputs. The later six-document preparation preserved
the mathematical and build inputs; its subsequent static check passed on that
prepared source, with its own unchanged-source record. These five results are
parent preparation-stage checks on a dirty checkout. They do not establish a
full-clean result for a later candidate, hosted CI or an independent reviewer run.

C25.01–C25.05 supported records and original reports remain retained. In
particular, C25.05 r2 freshly compiled the examples and checked all 25 new
private axioms, while independently validating applicability of the earlier
parent compiler outputs. C25.06's new whole-project trust run is separate.
The initial malformed dispatch, interrupted build, independently qualified
repair and fresh mathematical review retain their distinct status. Revision 1
formal plan review is historical; no separate revision 2 PLAN review is
claimed. The randomized-quantifier concern remains withdrawn because the
registered PW24 source permits randomized rules. Earlier failed proofs/probes
and corrected passes are not rewritten.

### Reassessment and completion gates

The contextual source inspection found no need for a new public helper, a
second attainment proof or a mathematical change. The complement-event proof
meets the same endpoint and treats ties directly. The private gamma fixture
exercises C26's future randomization parameter without asserting its optimality
at a prescribed size. C26 can adapt its source; private declarations are not
public callable helpers. C27 uses Q as null and J as alternative, with a global
mass-comparison event and log agreement only on joint support.

The lead approved the exact 35-path checkpoint packet and bounded status,
review-result and reconciliation amendments to these same six documents.
The immutable packet remains under `checkpoint-proposal/`. Checkpoint identities
and clean-run records, when produced, are retained under
`.lit-review/setup/c25-06-20261106/approved-checkpoint/`; the first run's
`initial-clean/result.json` records its actual outcome only after it ends.
Later attempts retain distinct records. Approval and preparation establish
neither a clean PASS nor an independent-review verdict.

Before cumulative dispatch, the complete development suite must pass on the
exact reviewed source, and self-review and separate reassessment must use that
actual evidence. Every original report and criterion assessment must be retained
and substantively reconciled, even when there are no findings. The final
source/configuration/dependency applicability check remains mandatory. When
review requires no source or document change, applicable earlier full-clean
evidence may be reused after that check; source identity must be verified, not
inferred from an empty findings list. Any candidate amendment, including a
post-review document amendment, requires a complete clean-suite rerun. Reviewer
gaps or contradictions still require a satisfactory source-bound reassessment.

Completion is established only by supported private closure. Its maintained
pointer is `.lit-review/setup/c25-06-20261106/completion.json`, which must
identify the actual closure reference, final source, original cumulative report,
substantive reconciliation, exact clean candidate/result and final applicability
evidence. Before those records exist, this text establishes no completion;
afterwards, their actual contents determine status. Material changes to the API,
limitations, deferred work or handoff decisions require canonical correction
before final capture. Primary local work and historical control checkouts remain
preserved. C26 remains unselected. The approval permits isolated local
checkpoints, not a primary commit, push, release, API-doc generation or
publication.
