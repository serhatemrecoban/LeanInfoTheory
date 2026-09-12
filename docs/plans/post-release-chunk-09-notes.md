# C9 Evidence and Advisory Notes

This is advisory context for [the approved detailed plan](post-release-chunk-09.md).
Requirements live in that plan; changes here cannot replace them. The current
implementation section below supersedes dated planning-status statements, while
retaining their original evidence. This document does not establish workflow closure.

## C9.07 cumulative candidate preparation, 2026-09-12

C9.01--C9.06 have durable closures; their dated sections below retain original
evidence and pre-closure wording. C9.06's actual completion is
`82a1b5a429693718c24f2863d7d077c5010d9403e5836e5a30c61d307be16263` at final source
`f30aff1842d2b3b3fc95aca37eda1e2a5e4484b26694371ed7a7ef482c4fd559`. The fresh installed
inspect/API commands and conditional precheck found exact source equality,
the same approved normative plan and the same actual parent/reviewer binding.
The lead's exact step-7 message was retained and accepted once, selecting C9.07.

The [maintained chunk handoff](../handoffs/chunk-9.md) consolidates delivered APIs,
current versus released counts, commands, source/review identities and standing
dispositions. This preparation repairs stale planning/current-status descriptions
without rewriting later proposed mathematical contracts or dated evidence.
The normative plan still contains its original shorthand test path;
the actual maintained command is
`python -B scripts/compatibility/test_public_api_compatibility.py`, as already
documented in the [C9.04 qualification](../compatibility/c9-04-qualification.md).
No wrapper is added solely to match that advisory command spelling.

The lead authorized the proposed exact 94-file local checkpoint in the retained
response; that response alone does not establish a commit or any validation result.
The complete routine suite, final cumulative fixture matrix and real two-pass
current file-mode doc-gen must pass on the authorized clean candidate before the
fresh full-chunk review request. Old doc-gen output cannot establish current-source
attestation. Actual source-bound C9.07 records determine validation, review and
reconciliation results; the actual private completion record alone establishes
closure. Prepared prose and earlier component evidence do not satisfy C9.07-R2.
C10 remains unselected; no push or publication follows from checkpoint authority.

## C9.06 information decomposition and prepared handoff, 2026-09-12

The lead's conditional request selected only C9.06 after actual C9.05 closure
`502e426a14dff8c25557b3a55fdd06ab427e675e552d3e9b048b7967a5bdff85`
and exact final-source equality with
`9a6e75ab17922cf40a3a299094bc6ed7884179db34d585a3707e56b28fd4e905`.
The parent verified that source remained unchanged at ingress. Actual C9.06
baseline/accepted-request/edit references remain in the installed private workflow;
this prose invents no new reference and treats neither HEAD nor its cumulative
dirty diff as the isolated step delta.

**Selected contract and scope.** `Shannon.mutualInfoOf_condEntropyOf_decomposition`
lives in `Shannon.InfoMeasures` and states exactly

`I(Y;Z) = H(Y|X) - I(X;Z|Y) - H(Y|(X,Z)) + I(X;Z)`.

The source type is arbitrary; only the three observed alphabets require
`Fintype`. The conditioning pair is ordered `(X,Z)`. No independence,
Markov, recovery, measurable-space, full-support or positive-mass premise is
introduced. This is a derived convenience identity from the existing algebraic
MI/CMI/conditional-entropy forms, not a new semantic theorem family or an
application-specific equivalence. The owner keeps its lightweight import;
no simp attribute or facade alias is added. The canonical name becomes
root-visible through its existing owner while all 92 historical aliases remain exact.

**Private permanent consumers.** `Examples.InformationDecomposition` imports
only `Shannon.InfoMeasures`, and only the Examples aggregate imports this
new non-stable owner. The six private declarations are `general_decomposition`,
`zero_terms`, `singleton_auxiliary`, `sparseJoint`, `sparse_masses`
and `sparse_decomposition`. They cover the general formula, exactly the
assumptions `I(X;Z)=0` and `H(Y|(X,Z))=0`, a singleton auxiliary variable,
and a Boolean triple law with half mass at `(false,false,true)` and
`(true,true,false)` and zero mass at `(false,true,true)`. These source
consumers use the lightweight algebraic interface and passed the recorded
focused and aggregate builds. No semantic import is added to prove the two assumed zeros.
The zero-term conclusion is `I(Y;Z)=H(Y|X)-I(X;Z|Y)`.

**Naming, references and downstream evidence.** The selected name retains
searchable `mutualInfoOf` and `condEntropyOf` vocabulary; its docstring leads
with "Decompose `I(Y;Z)` through an auxiliary variable `X`", states the
full formula and identifies the ordered pair. Note 14 records this explicit
name/no-alias disposition. It renames no previously supported declaration.
The parent read registered CT91 Section 2.4, printed pages 19--21/PDF 41--43,
and Section 2.5, printed pages 21--22/PDF 43--44. Those MI and chain-rule
identities provide context for the derivation; no separate named decomposition
theorem is attributed to CT91. Its bit convention is translated to the library's
canonical nats consistently across all terms.
The [recorded bounded intake](post-release-chunk-map.md#c9-post-release-complementary-work)
already identifies a downstream decomposition consumer. The new private zero-term
example exercises that generic interface; it is not additional downstream demand.
`C9-INTAKE-02` records only that intake and the upstream response. No fresh
downstream access, reproduction, adoption or external implementation reuse is claimed.

**Current generated facts and validation status.** Fresh source-derived artifacts
contain 603 supported declarations in 31 owners, 94 simp declarations and
92 facade aliases. The graph contains 46 local modules, 15 non-stable anchors,
94 local edges, 5 root-reachable and 41 separate-import modules.
The source index contains 718 declarations, 717 documented plus its one
example-only instance. Both selected C9 public additions are present; the frozen
601-declaration manifest and retained artifact remain historical baselines.
**Recorded parent validation.** The original queue
`tmp/c9-06-native-1789228172263493800/` completed all five maintained commands with exit zero.
The focused command built lightweight InfoMeasures, its private consumer, the
root, Shannon and Examples with warnings as errors. The separate root-import
signature consumer printed the exact theorem/universes and its three allowed
axioms, and compiled both named argument use and the zero-term specialization
over an arbitrary `PMF Nat` source. Static passed, and documentation independently
compiled all 5 maintained README examples with warnings as errors.
The static command also passed its 31 website fixture tests.
Full current trust ran its own fresh retained-compatibility build/export before
the current compiled boundaries: all 601 historical retained types match.
It also ran the maintained warning-as-error build, exact current imports,
inventory/owners/simp/root checks and the complete all-project axiom audit.
The actual compiled audit reports 1400 local constants across
46 modules; this count is extracted from original native stdout,
not inferred from source inventory or a previous step.

| Fresh parent check | Result | Seconds | Original record directory |
| --- | --- | ---: | --- |
| focused | PASS | 285.297 | `tmp/c9-06-focused-1789228175324821600/` |
| signature | PASS | 16.704 | `tmp/c9-06-signature-1789228460809234500/` |
| static | PASS | 10.928 | `tmp/c9-06-static-1789228477680080400/` |
| documentation | PASS | 111.852 | `tmp/c9-06-documentation-1789228488773350300/` |
| trust | PASS | 1907.358 | `tmp/c9-06-trust-1789228600860892000/` |

Selected original trust output:

- `supported environment passed: 603 declarations, 94 simp declarations, axioms [Quot.sound, Classical.choice, propext]`
- `root boundary passed: 92 exports and 481 opt-in exclusions`
- `all-project axiom audit passed: 1400 local constants, axioms [Quot.sound, Classical.choice, propext]`
- `Lean probe passed: all 46 modules and every compiled project constant axiom audit`

**Preserved initial proof failure and correction.** The first disposable probe
exited 1 on its sparse PMF normalization obligation
`2⁻¹ + 2⁻¹ = 1`. Its two dependent "declaration uses `sorry`" diagnostics
were compiler consequences of that unresolved obligation. The archived original
source contains no authored placeholder; the decomposition itself already
printed with exactly the three allowed axioms. The corrected source changes
only that obligation's proof to use `ENNReal.inv_two_add_inv_two` after
`norm_num`; its native rerun exited zero. Both original sources, commands,
durations and unmodified streams remain separate from the maintained queue.
This corrected probe is not substituted for owner, aggregate or trust validation.

| Original parent proof probe | Result | Seconds | Original record directory |
| --- | --- | ---: | --- |
| Initial sparse normalization | FAIL | 216.098 | `tmp/c9-06-proof-probe-1789226794569369200/` |
| Corrected sparse normalization | PASS | 16.646 | `tmp/c9-06-proof-probe-corrected-1789227096407912000/` |

**Preserved first queue failure and corrected source.** The earlier queue
`tmp/c9-06-native-1789227697601348600/` passed focused compilation and its signature
consumer, then stopped with exit one at static. The website check identified
three curated `theorems.html` links whose InfoMeasures line locations had
shifted by two: `mutualInfo_map_swap`, `condMutualInfo_map_swap12` and
`entropy_eq_entropy_sndMarginal_add_condEntropy`. Only the two unnecessary
module-overview lines were removed to restore those locations. Exact archived
owner-byte comparison verifies that the theorem and its docstring are unchanged;
the private consumer source hash also remains unchanged. New generation passes
were preserved, and the isolated corrected static command passed its
31 website tests before the complete fresh queue above.
The original failed static streams, old owner source and earlier passing commands
remain historical evidence. None replaces a current-source queue command.

| Earlier source-specific parent execution | Result | Seconds | Original record directory |
| --- | --- | ---: | --- |
| First-queue focused | PASS | 369.642 | `tmp/c9-06-focused-1789227704195260600/` |
| First-queue signature | PASS | 16.972 | `tmp/c9-06-signature-1789228074034269500/` |
| First-queue static | FAIL | 3.121 | `tmp/c9-06-static-1789228091181409900/` |
| Isolated corrected static | PASS | 15.585 | `tmp/c9-06-static-correction-check-1789228130739367600/` |

The static stderr records contain the passing unittest report and only the
explicitly checked Git CRLF-to-LF advisories, when emitted, for the two blueprint
artifacts. These original diagnostics are retained; empty stderr is not inferred.

**Generation and applicability.** Both final current-manifest/website generation
passes succeeded in `tmp/c9-06-generation-1789228119261250500/`; all five output byte files are
archived under `pass-1/` and `pass-2/` and agree with each other and the
current files. Original generation stdout/stderr hashes and native queue
command/result/stream hashes were verified before this prose update. Durations
above come from original command records, rounded only for display. The queue's
complete maintained-source before/after maps agree; its trust, documentation,
README and dependency identities still match at prose preparation. The frozen
manifest, retained artifact, reviewed current policy and toolchain/Lake pins
also retain their recorded bytes. These checks establish applicability of the
parent's separate executions; they do not relabel old C9.04/C9.05 evidence or
constitute an independent validation pass.

This six-document prose update is outside the Lean/build/doc-content identity
inputs; its own changed canonical bytes still require the installed source
capture and final checks. Actual contextual self-review and separate reassessment preceded the
independent review of source R `c173341b6f8c77518d333e679d036f4ef25b080aa7a0c4c959f0f164c9e25913`. The installed workflow classified
the original report VALID, accepted it and explicitly reconciled it. The report
independently assesses all three approved C9.06 criteria as satisfied and contains
exactly two nonmaterial process findings. Both original claims remain unchanged
and explicitly reconciled. Actual RESOLVED dispositions concern completion of
their requested disclosure/impact follow-ups, never retroactive compliance.
These statements describe existing records, not a future verdict.

Report capture: `09bcdb29eae54dd453cc545ed261ca53fe747754015aa0ea158e154f257b0d84`.
Reconciliation: `4cc831712875d2743142e19ac4b75bc213482987c67079cecffbd8421ab12ec7`.
Original report-text SHA-256: `b53cc6b0c60463c346498c2a80c7132985292b30c0709b4227d98b864746f684`.
Derived canonical report-body SHA-256: `78c7f7205ee1c86a9948d3e826a515420dcc7b6b2b7c3611bc78f7b7d165e069`.

| Actual reviewer criterion | Status | Accepted reviewer evidence references |
| --- | --- | --- |
| C9.06-R1 | SATISFIED | `reviewer:c906-scope`, `reviewer:c906-proof`, `reviewer:c906-reference`, `reviewer:c906-focused`, `reviewer:c906-probe`, `reviewer:c906-identity`, `reviewer:c906-supplied-native` |
| C9.06-R2 | SATISFIED | `reviewer:c906-consumers`, `reviewer:c906-focused`, `reviewer:c906-probe`, `reviewer:c906-reference`, `reviewer:c906-identity`, `reviewer:c906-supplied-native` |
| C9.06-R3 | SATISFIED | `reviewer:c906-identity`, `reviewer:c906-generation`, `reviewer:c906-static`, `reviewer:c906-documents`, `reviewer:c906-supplied-native` |

The exact original report and native completion evidence remain preserved;
the derived body hash and this prose are not replacements for those originals.
The same persistent reviewer remains `/root/c9_reviewer`. Requested
gpt-6-astra/ultra and no copied parent history remain separate from UNREPORTED
effective model, effort and history settings. No formal plan review is claimed.

The reviewer independently ran the maintained focused warning-as-error build
for InfoMeasures, InformationDecomposition, the root, Shannon and Examples:
exit 0 in 177.2538997 seconds, 3070 jobs. Its separate root-import Lean probe
passed in 234.0199855 seconds, checking the four-universe statement, exact two-zero
specialization, arbitrary Nat source and only `propext`, `Classical.choice` and
`Quot.sound` axioms. Static validation passed in 12.8413062 seconds, including
31 website fixtures. The two existing Git CRLF advisories remain recorded.
All 166 checked local Markdown targets across 13 documents existed.

Independent source/reference inspection covered the registered CT91 Sections
2.4--2.5, actual pinned PMF/ENNReal declarations, coordinate reassociation,
algebraic cancellation, the six private consumers and naming/feedback records.
All 68 reviewer-scoped hashes and both current identity maps matched. The
reviewer checked preservation of all 602 preceding and 601 retained API entries,
the 92 aliases and exactly the two approved cumulative theorem additions.
Corrected independent generation produced two archived byte-identical copies
of all five current artifacts; all four generator check modes passed. The
corrected sequence preserved bytes and recorded modification times of the seven
current/frozen artifacts. These generation checks are distinct from actual
signature-bearing doc-gen, which remains a C9.07 obligation.

The reviewer did not rerun the complete trust command, README compilation or
cumulative fixture matrix. It assessed the supplied parent executions against
independently checked current source and dependency identities. The actual
parent trust audit measured 1400 compiled local constants; source identity alone
is not a new compilation measurement. Structural signature comparison does not
establish definition-body semantics; the algebra and actual definitions were
separately reviewed. Effective reviewer model, effort and copied-history settings
remain unreported.

Two original nonmaterial findings are explicitly reconciled:

- `lit-finding:c906-dispatch-order`: the parent sent the native request before
  recording dispatch intent. The first submission-recording command was refused
  at `REVIEW_READY`. Its exact native failure, original empty `UNCERTAIN` result,
  actual chronology and late dispatch intent are preserved. The supported late
  association and original-report delivery confirmation completed without a
  resend. They do not satisfy the historical intent-before-send requirement.
- `lit-finding:c906-reviewer-write-boundary`: the reviewer's first scratch
  generation redirected `OUTPUT_DIR` but missed concrete output constants,
  causing four identical-byte generated rewrites in maintained website files
  before `FileNotFoundError`. Those writes violated the read-only instruction;
  no initial modification-time preservation is claimed. The failed probe and
  partial output remain retained. Corrected runs redirected every concrete path
  and supply the successful repeatability evidence. A separate initial
  prior-record comparison failed at `KeyError: 'trust'`, then passed with the
  actual `trust_identity` schema; this failure also remains recorded.

The parent accepts both findings without refutation or severity downgrade.
Their installed `RESOLVED` dispositions mean the requested disclosure, failure
preservation, source-impact check and corrected isolated evidence are complete.
They do not mean either original process was compliant or can be repaired
retroactively. The parent verified every one of the 176 physical source files
in the rendered review inventory still matched its R hash. All three original
criteria remain satisfied, with no material implementation finding or evidence
gap. Additional theorem edits or a duplicate review request would not repair
either historical incident and are not justified by these facts.

The exact report, completed native envelope, 28 original reviewer non-PDF
artifacts, parent refusal and uncertainty records, process-deviation assessment
and supported finding histories are retained privately with their original
hashes. Final applicability and completion must retain those references and
both false historical-compliance flags. The next review must record intent
before native dispatch and establish all concrete scratch destinations before
any writer is called; these reminders do not reopen or implement C9.07.

The parent's initial final-prose preflight also refused before maintained writes:
it compared original reviewer-local evidence IDs directly with the workflow's
derived evidence hashes. The corrected scratch helper verifies every original
evidence payload and the actual installed ID-mapping record before comparing the
accepted report. Original report bytes and criterion assessments are unchanged;
the failed preflight's command, result and streams remain preserved separately.

**Recorded process deviations.** The parent-created record
`.lit-review/setup/c9-06-process-deviations-20260912.json`, SHA-256
`a0674c1468eac358a3d7e523a1348124d382f56843f76233d6ebc94b85e6eff7`, is bound to this request, R and original report.
It preserves the late dispatch intent and identical-byte generated rewrites,
with both chronological compliance and reviewer read-only compliance recorded
as false. The referenced original evidence files retain their verified hashes.
At the post-review check, maintained bytes matched R; byte equality does not
establish absence of writes or retrospectively satisfy the dispatch order. The original deviation record
and the parent's explicit assessment remain separate from the reviewer verdict.

**Actual finding dispositions.** The mandatory record
`.lit-review/setup/c9-06-finding-dispositions-20260912.json`, SHA-256
`385f09c9a2eda2d33aaa32318bfdedbe54054ad8c4efebd1d6a248bfe5cc85a6`, preserves both complete active finding histories and
is bound to this R, request, capture, original report and process-record hash.
`lit-finding:c906-reviewer-write-boundary` and `lit-finding:c906-dispatch-order`
remain the original nonmaterial claims. Each latest disposition is RESOLVED and
cites actual parent evidence `6828e234c5ab29d01bdad40c8a7a0ee4c8684bd359e5ba539e0dd3f840072672`, whose registered
record and source manifest were verified against R. This records completed
disclosure and impact follow-ups. It does not refute either finding, remove the
original FAIL observations, or establish compliant chronology/read-only conduct.

Reviewer executions above retain reviewer attribution. Inspection of supplied
parent evidence is not an independent rerun. The preceding parent native tables,
measured counts, original failed probe/static checks, corrected reruns and
superseded generation pairs retain their own outcomes and provenance. Satisfied
criteria and resolved follow-ups do not relabel any failed execution as PASS.

Only six canonical prose documents change in this bounded post-review update.
The approved normative plan, Lean/runtime/test/generated inputs, configuration,
dependencies and historical records retain their reviewed bytes. Fresh final
static/local-link checks and explicit R-to-F/source/configuration/dependency
applicability remain required before F. Final validation, F and durable closure
remain provisional; neither this prose nor the accepted report establishes them.
C9.07 is unselected and retains cumulative validation and fresh independent
chunk review, the separately authorized clean checkpoint/default suite, actual
final-source two-pass file-mode doc-gen, canonical reconciliation, remaining-work
dispositions and `docs/handoffs/chunk-9.md`. Actual C9.06 completion belongs only
to the installed private completion record after the final checks and F.

The persistent reviewer remains `/root/c9_reviewer`. Requested
gpt-6-astra/ultra/no copied parent history remain separate from unreported effective
settings. Supporting implementation research is not independent review. No formal
plan review is claimed.

**Remaining work and handoff.** C9.05's independence slice is closed; Note 25's
other conveniences remain consumer-triggered. C9.06 has an accepted independent report with all three criteria satisfied and
two nonmaterial process findings explicitly reconciled. RESOLVED dispositions
record disclosure/impact follow-ups while preserving historical noncompliance;
final validation, F and private exact-source closure remain pending.
C9.07 is unselected and requires a separate eligible request after that closure.
It retains fresh complete cumulative fixtures, the complete routine suite at a
separately authorized clean checkpoint, actual final-source two-pass file-mode
current doc-gen, full-chunk independent review, canonical reconciliation,
remaining-work dispositions and `docs/handoffs/chunk-9.md`. This source change
invalidates earlier current-doc attestations; generated source indices do not
substitute for signature-bearing HTML or real doc-gen. Earlier C9.04/C9.05
executions retain their historical provenance and are not relabeled as C9.06 reruns.
No commit, push, publication, dependency change, policy-approval record or frozen
baseline rewrite is authorized by this prose. The maintained handoff precedes F;
actual C9.06 closure belongs to the installed private completion record.

## C9.05 independence postprocessing and prepared handoff, 2026-09-12

The lead's conditional request selected only C9.05 after exact C9.04 closure
`814390aea8408ec16cf050bd692d9e68ae480d5140fca1f87b79e9f09a3c076a`
and final-source equality with
`1186f99ac55eb09aca651762c52a2617c1f89f386d956dfc026dfc7c9ff755d0`.
Actual C9.05 B is
`a25ca4e65e08591f62d60bd22facca1ba091a8c0baf767531a2b048f89ea1367`.
HEAD still predates earlier uncommitted C9 work; the full HEAD diff is not this
step's delta. Fresh installed inspect/api and original request/precheck/accepted
disposition remain under `.lit-review/setup/c9-05-*`.

**Delivered contract and reuse.** `Shannon.isIndependentOf_comp_right` lives in
`Shannon.SemanticBridge.Independence` with exactly the approved arbitrary-type
PMF contract. Its proof maps the joint-law equality through `(a,b) ↦ (a,f b)`
and reuses `isIndependentOf_iff_map_eq_indepProd`, `PMF.map_bind` and
`PMF.map_comp` with the existing `indepProd` definition. No auxiliary public helper or owner import,
simp attribute, facade alias, finiteness, measurability, injectivity or mass
hypothesis is added. Local source/generated-index and pinned-mathlib searches
plus a successful warning-as-error Lean probe established the reuse path.
The measure-theoretic `IndepFun.comp` route has additional measurability
assumptions; finite DPI is unnecessary for this PMF theorem.

**Permanent consumers.** `Examples.IndependenceProcessing` imports only that
focused owner. Six private declarations exercise arbitrary component PMFs and
right maps, the non-injective nonconstant map `Nat` halving, constant maps into
`Unit`, left processing through existing symmetry, and zero finite MI through
the existing equivalence (only the observed alphabets are finite). No PMF on an
empty type is invented. Only the non-stable Examples aggregate gains an import.
Current inventory is 602 supported declarations/31 owners/94 simp/92 aliases;
there are 45 local modules and 14 non-stable anchors. Private helpers are absent
from the public/source declaration indices but included in all-project trust.
Curated website module descriptions cover the new consumer and affected owners.

**References and attribution.** CT91 Section 2.8, printed pages 32--33
(PDF 54--55), supplies the deterministic-postprocessing information-theory
context; Section 2.4, printed pages 19--21 (PDF 41--43), supplies the finite
MI interpretation. The actual local text was read. The arbitrary-type PMF
closure result is stated directly beyond the finite entropy presentation.
The [recorded bounded downstream intake](post-release-chunk-map.md) motivates
this generic theorem; no external implementation code, fresh downstream
reproduction or adoption is claimed. The name follows existing `...Of` and
`...comp_right` vocabulary. No new naming friction or alias is inferred.
Note 25 closes only this selected deterministic-postprocessing slice.

**Validation and review status.** The initial exact-contract proof probe's native
Lean command exited zero. Its original stdout/result remain in
`tmp/c9-05-proof-probe-1789209482702460500/`; the outer scratch wrapper then
failed while printing Unicode through cp1252. The preserved native result is
separate from that presentation failure; the corrected wrapper uses UTF-8.
The first owned-edit intent rejected a directory path before any maintained
write, and a corrected exact-file intent succeeded. Both attempts remain
recorded; neither failure is a mathematical or production-gate result.
The first focused build accepted the owner and all six example proofs, then
failed on a missing unnamed-section `end` in the consumer. The corrected file
closes each scope explicitly; its rerun is retained separately from that FAIL.
Current generators ran twice with identical bytes, preserving both passes.
The corrected owner/consumer/semantic/Shannon/Examples warning-as-error builds,
exact printed four-universe signature with the three allowed axioms, static
checks, all five independently compiled README consumers, and full current trust
passed. Trust ran its own fresh standalone compatibility build/export before
compiled boundaries: all 601 retained types match. It also ran all eight maintained
warning-as-error targets and complete current import/attribute/root/all-project
axiom checks. Exact source/configuration/dependency comparisons establish current
applicability of those separate native executions after prose reconciliation.


| Fresh parent check | Result | Seconds | Original record directory |
| --- | --- | ---: | --- |
| focused | PASS | 44.91 | `tmp/c9-05-focused-1789210171923343400/` |
| signature | PASS | 18.45 | `tmp/c9-05-signature-1789210217036720800/` |
| static | PASS | 10.64 | `tmp/c9-05-static-1789210235642006600/` |
| documentation | PASS | 340.4 | `tmp/c9-05-documentation-1789210246465064600/` |
| trust | PASS | 7819.19 | `tmp/c9-05-trust-1789210587028339100/` |

Selected actual trust-output lines:

- `trust manifest loaded: 602 supported declarations, 115 non-stable exclusions, 120 private-name exclusions`
- `supported environment passed: 602 declarations, 94 simp declarations, axioms [Quot.sound, Classical.choice, propext]`
- `Lean probe passed: full umbrella inventory, owner, simp, axiom, non-stable, and private checks`
- `root boundary passed: 92 exports and 481 opt-in exclusions`
- `all-project axiom audit passed: 1389 local constants, axioms [Quot.sound, Classical.choice, propext]`
- `Lean probe passed: all 45 modules and every compiled project constant axiom audit`

All original native commands, stdout/stderr bytes and results (including the
initial failed focused build) are preserved in private C9.05 evidence; completed
probe source bytes are archived before removing the disposable Lean spikes.
The final generation passes are retained under
`tmp/c9-05-generation-1789210151781208400/pass-1/` and `pass-2/`.
Three supporting documentation corrections separate historical C9.04 closure/doc
evidence from current C9.05 status; current CI count wording was also checked
against its source. Neither these comparisons nor earlier C9.04 qualification
are relabeled as new native executions. Contextual self-review and separate reassessment preceded the original
independent report for reviewed source R `a9b9c14576d36e7fb191a03d2d5f367a0a407e564cad9fefc92d77f336db89dc`.
The installed workflow classified that report VALID, accepted it and explicitly
reconciled it. The report contains no findings and independently assesses exactly
the three approved C9.05 criteria as satisfied.

Report capture: `a03539304bf4f7bb930fb41a914c9c76ffb3f2f928b4dec6e543e4884e4525cd`.
Reconciliation: `3048e60838842c800182cf543ba02e0299e51099668d399e01c5190bc5b4cec8`.
Original report-text SHA-256: `c0eb65c33af7475d903046ac263031efa9ce7b0ba320831449a02d0ede1020f8`.
Derived canonical report-body SHA-256: `2a30672ac6f335682489c3a832272e80852b7fbb378d6ab3a6a1a7b13719351c`.

| Actual reviewer criterion | Status | Accepted reviewer evidence references |
| --- | --- | --- |
| C9.05-R1 | SATISFIED | `2748e8558d588c65af5d48cf8d0e669f65f21bdd4470652685d626319d298a5e`, `febb444de373bb179bcefd4207eeab5267a3ec52b89d209c230ea8ffb5e70575`, `472b60cbfc3908cdf4e4bbe9454809b769f53b967c07f578dfa6b6196f8d1ff7`, `8df1ae2a4f42796e351dacd29985710186c7ea7dfcc5d2d76b171be83aa889e7`, `94d1d84e0a2f227550319bed1b8aa9a7ff51448f1da749194b0a3aa5a15249e2`, `22390a1b29cfed8edd82df619b50d5e4480241b0bc636695db230b70dc5641e5`, `54c9de259fbd376484def5e1f08bc655498db78ddfe30c2ff1d63dbaa7b54583` |
| C9.05-R2 | SATISFIED | `0958175d78342c9c28c12e84f2b7da25a0898e6ebdfe073d2990f3d3c7631b3d`, `8df1ae2a4f42796e351dacd29985710186c7ea7dfcc5d2d76b171be83aa889e7`, `94d1d84e0a2f227550319bed1b8aa9a7ff51448f1da749194b0a3aa5a15249e2`, `22390a1b29cfed8edd82df619b50d5e4480241b0bc636695db230b70dc5641e5`, `54c9de259fbd376484def5e1f08bc655498db78ddfe30c2ff1d63dbaa7b54583` |
| C9.05-R3 | SATISFIED | `22390a1b29cfed8edd82df619b50d5e4480241b0bc636695db230b70dc5641e5`, `4dc3f40054c0047f3c0a281a85a756c9bec4c3eaeb790410cf4c339f5589f57b`, `b16d25810adbc8f706250985d676c944586b30eb88989b71307b837cc7da9fcf`, `5e701c31ba616e3a934f7fe65421bf927e8271692521f5deca64901615c7f867`, `54c9de259fbd376484def5e1f08bc655498db78ddfe30c2ff1d63dbaa7b54583` |

The exact native report text and original completion envelope remain preserved;
the derived body hash is not a replacement for those originals.
The original empty submission receipt remains UNCERTAIN. A separately
recorded, correlated native completion confirmed delivery; it did not
rewrite the receipt or substitute for report acceptance/reconciliation.
The persistent reviewer remains `/root/c9_reviewer`. Requested
gpt-6-astra/ultra and no copied parent history remain separate from UNREPORTED
effective model, effort and history settings. No formal plan review is claimed.

The reviewer independently read the mapped-law proof, existing independence and
zero-MI interfaces, the six private permanent consumers, focused imports, pinned
PMF reuse candidates and the affected canonical/naming/intake records. It verified
the registered CT91 PDF hash and visually inspected the five specified pages in
Sections 2.4 and 2.8. Its mathematical assessment distinguishes the finite
information interpretation from the delivered arbitrary-type PMF closure theorem.

The original report records these reviewer executions:

| Reviewer command/check | Actual outcome | Limits |
| --- | --- | --- |
| `python -B scripts/validate_release.py focused LeanInfoTheory.Shannon.SemanticBridge.Independence LeanInfoTheory.Examples.IndependenceProcessing LeanInfoTheory.Shannon.SemanticBridge LeanInfoTheory.Shannon LeanInfoTheory.Examples` | Exit 0; 3068 jobs; 118.3488806 seconds; empty stderr | Incremental warning-as-error build using current pinned caches, with Lean commands serialized. |
| `lake env lean -DwarningAsError=true` on its own `IndependentConsumer.lean` | Exit 0; 257.3405796 seconds; empty stderr | Separately checked four universes, named arguments without extra hypotheses, an arbitrary-source finite zero-MI consequence, halving witnesses, and exactly `propext`, `Classical.choice`, `Quot.sound`; this is not a full-project audit rerun. |
| Two fresh generations with output destinations redirected to reviewer scratch, plus the four maintained generator `--check` commands | Both five-artifact sets matched each other and current production bytes; all check commands exited 0 | Source-derived references only; no signature-bearing doc-gen build or attestation. Current/frozen artifact bytes and timestamps were preserved. |
| `python -B scripts/validate_release.py static` and a separate local-link probe | Static exit 0 in 17.9890971 seconds; all 31 website/staging tests passed; 135 local link targets across 13 documents existed | Stderr retained the passing test report and two Git CRLF-to-LF advisories for blueprint artifacts. Link checks do not establish remote URLs or every fragment anchor. |
| Source/API/dependency identity checks, repeated at completion | All 60 scoped hashes and current trust/documentation identities matched and remained unchanged; exactly one supported addition and all 601 retained entries/92 root exports preserved | Cooperative source/applicability observations, not authenticated compilation provenance or reconstruction of the private B snapshot. |

The reviewer reported no failed check or mathematical/assumption mismatch. It
assessed the separately supplied parent trust/compatibility and README results
against independently checked current source and dependency identities. It did
not rerun the multi-hour full trust command, README command or full fixture matrix,
and did not open the parent's private original streams. The parent's actual
native proof succeeded before its console wrapper failed on Unicode; that wrapper
failure and the initial consumer section-end build failure retain their original
outcomes separately from the corrected passes.

The reviewer confirmed that the sole new public theorem has the approved owner,
generality and right-coordinate orientation; the consumers remain private and
Examples-only. Note 25 closes only the selected deterministic-postprocessing
slice, with further public variants consumer-triggered. No new downstream access,
reproduction/adoption or naming-friction episode was claimed. Its original report
is evidence for this step and supplies no authorization for another step.

After native completion, the parent durably archived the reviewer's exact command
records, streams and disposable probe source in the private
`c9-05-original-reviewer-executions-and-probe-20260912.json` record. Only that
completed scratch Lean probe was then removed; its archived bytes and the original
report remain unchanged.

Reviewer executions above are attributed to the reviewer; inspection of supplied
parent evidence is not an independent rerun. The earlier parent command table,
original failures and corrected passes retain their separate attribution and
outcomes. No failed native command is relabeled PASS by this reconciliation.

Only these six canonical prose documents are changed by this bounded post-review
edit. Historical entries, the normative plan, Lean/runtime/test/generated inputs
and pins are preserved. Fresh final static/local-link checks and explicit
R-to-F/source/configuration/dependency applicability remain required before F.
This prose prepares final validation; neither it nor a clean reviewer report
establishes final capture or durable closure. C9.06 remains unselected.
C9.07 retains full cumulative qualification and independent chunk review, a
separately authorized clean checkpoint/default suite, actual final-source two-pass
file-mode doc-gen, canonical reconciliation, remaining-work dispositions and
`docs/handoffs/chunk-9.md`. Actual C9.05 completion belongs to the private
`c9-05-completion-20260912.json` record after final validation and F.

The persistent `/root/c9_reviewer` remains bound. Requested gpt-6-astra/ultra
and `fork_turns="none"` express the no-parent-history intent; effective model,
effort and history settings remain UNREPORTED. Supporting read-only proof and
documentation inspections are not formal review. No formal plan-review session
has occurred. Original native results must remain distinct from summaries.

**Remaining work and handoff.** C9.06's decomposition requires a separate eligible
request. C9.07 retains cumulative validation and independent review, an explicitly
authorized clean checkpoint/default suite, actual final-source two-pass file-mode
doc-gen, canonical reconciliation/dispositions and `docs/handoffs/chunk-9.md`.
The new source makes earlier current-doc attestations stale; no signature-bearing
current-doc refresh is claimed here. C9.04's complete live qualification remains
historical evidence and is not relabeled as a C9.05 rerun. Signature compatibility
checks retain their definition-body/semantic limits. No approval record, runtime
acceptance rule, frozen artifact, dependency pin, commit or publication changes.
This handoff is maintained before F; actual closure belongs to private
`c9-05-completion-20260912.json`, never a premature status sentence.

## C9.04 qualification and prepared handoff, 2026-09-12

The lead's conditional request selected C9.04 after checking C9.03's actual
durable closure `8c5813a6d39faa5419a45c1ffe00f11220a77394eadaca7738d055dc2f178b5e`,
exact equality with final source
`a73e78c71dbdb7aaf3b6a0a1952fe011e7cfee63b4a016d08a01157e914114f3`
and ordered next-step eligibility. Actual C9.04 baseline B is
`dd19020ae0af927c5d9e587b10aabed1dc1965fb4521f2839c8c185f7151448d`.
Fresh installed inspect/api and the original locally identified user request,
precheck and accepted disposition remain under `.lit-review/setup/c9-04-*`.

This step qualifies the combined C9.01--C9.04 gate design before either new
production theorem. The [consolidated qualification record](../compatibility/c9-04-qualification.md)
maps every Section 3.5 row and criterion to the actual runnable evidence, with
real Lean, actual source-only and synthetic boundaries stated separately.
Fresh cumulative production commands, all 17 retained cases, all four growth
cases and all 145 distinct component tests passed their expected outcomes. The
qualification record lists exact command/result locations and real, source-only
and synthetic boundaries. All 140 production inputs remained unchanged through
both complete runners, and each private source copy was restored exactly.
Original earlier runs remain preserved and are not relabeled as C9.04 execution.

Two bounded supporting inspections identified an obsolete current-inventory
test expectation and missing direct source-negative cases for undocumented,
unindexed and unclassified growth. C9.04 corrects those tests/fixtures and improves
stale-artifact and same-type-body diagnostic evidence. Existing production
acceptance gates, all Lean source and dependency pins remain unchanged. The
illustrative top-level compatibility-test path in plan Section 6 is stale; the
actual entrypoint is `scripts/compatibility/test_public_api_compatibility.py`.
Using it is an advisory command correction, with no normative plan change.

The original persistent reviewer `/root/c9_reviewer` remains bound. Requested
gpt-6-astra/ultra and `fork_turns="none"` express the no-parent-history intent;
the original native spawn exposed only the canonical task name. Effective model,
effort and history settings remain unreported. No formal plan-review session has
been performed. Supporting implementation analysis is not independent review.

Contextual read-only self-review and separate reassessment were recorded before
completion of the live matrix; neither treated pending checks as passing evidence.
Later supporting source inspections clarified the serializer's synthetic-expression
boundary and the increased inventory for unapproved new simp. These documentation
clarifications were accepted after the full live source freeze ended. Fresh source
applicability and documentation checks precede neutral independent review.
The original independent report for reviewed source R
`6f3baaed7ce07d02738bb3605062f6b0d43b43eb36b23863c5e76e9f4cff5b9a`
independently assesses all three C9.04 criteria as satisfied and reports no findings.
The installed workflow accepted the original report and explicitly reconciled it.
Report capture: `7645261280b9ec33bd698783cdb5e3bcf1ae4be532f7f54d84081f9609fe367c`.
Reconciliation: `9bfb94f716d1a12104421bd13222ac70310ca15c6ae40ab9f8657e606299f331`.
Original report SHA-256: `96da473aa8cea2b301ec99820ad34e05338d01287ed32c4dbd19055dee859e55`.
The full native completion envelope, exact extracted report and original empty
submission receipt are preserved under `.lit-review/setup/c9-04-*`. The empty
receipt remains UNCERTAIN; the correlated native completed report separately
confirmed delivery. Requested settings remain distinct from unreported effective
settings. No formal plan-review session is claimed.

The reviewer independently read the cumulative source and normative matrix,
verified 52 scoped hashes and all 48 historical source/configuration identities,
and checked the actual 62-input/nine-dependency trust and 69-input/14-dependency
documentation identities before and after its checks. It independently passed
134 Python-only tests plus all 11 exporter tests, including real pinned Lean
execution of the synthetic-expression serializer probe (159.947 seconds).
Static validation passed afterward. Five additional synthetic diagnostic probes
checked acceptance of the intended Units mismatch and refusal of unrelated,
wrong-owner, same-base and split-block errors; local target checks across 12
documents and seven generated-artifact byte/mtime preservation checks passed.
These are reviewer executions, distinct from the parent's original production
builds, README consumers, full trust and complete 21-case live matrix, which the
reviewer assessed from supplied observations and independently checked current
inputs. It did not repeat those long runs or open the parent's private logs.

The reviewer preserves its first identity-recording expression's Python TypeError
as FAIL; its corrected full probe and final repetition separately passed. This
was an isolated reviewer scratch error with no maintained change, so it requires
no product correction and is not counted as a passing execution. The parent
accepts the independently supported criterion assessments after checking them
against the completed original qualification and current identities. No material
issue, open finding, criterion gap or new source question remains. Strict retained
type equality still does not establish body semantics; actual doc-gen is still
a later milestone. Transient .olean bytes and intermediate generated/export
passes have the explicit archival limits in the qualification record.

Six qualification/canonical documents now reconcile that actual report and the
remaining-work handoff. Supporting read-only documentation inspection also found
two older C9.03-only quick-start/status pointers and ongoing-qualification wording;
these are corrected without rewriting historical entries. Only these six prose
documents change after R; normative requirements and all runtime, Lean, fixture,
test, generated and pinned dependency inputs remain unchanged. Final static,
12-document local links and exact native/source/review applicability checks must
pass before F. This prose prepares validation and makes no premature closure claim.
The maintained handoff is complete before final F capture; private
`c9-04-completion-20260912.json` carries the actual validation/closure result.
No maintained status sentence itself closes a step.

| Remaining work | Disposition and trigger |
| --- | --- |
| First approved theorem and permanent consumers | C9.05 only after durable C9.04 closure and a separate explicit eligible request. |
| Second approved theorem and permanent consumers | C9.06 in approved order, with its own request and review. |
| Final full cumulative checks/review, actual final-source two-pass current doc-gen and clean default suite | C9.07, including the separately authorized clean checkpoint; no gate is weakened or claimed here. |
| Canonical full-chunk reconciliation, remaining-work dispositions and `docs/handoffs/chunk-9.md` | C9.07; this step note maintains the intervening handoff. |

## C9.03 implementation and prepared handoff, 2026-09-12

The lead's conditional request selected C9.03 after the installed workflow
verified C9.02 closure `dbcd6e9e69f37a24ec28232bfad28cecee4296ae1024f0bb28ada5f994a41730`,
exact equality with its final source and next-step ordering. C9.03 baseline is
`38204bf569cb3c90babc8ce86635834252329f3e925751699c0577782638682b`.
Inspect/api, the genuine locally identified user request and its accepted
transition are retained under `.lit-review/setup/c9-03-*`. The same persistent
`/root/c9_reviewer` remains bound. Its original creation requested
gpt-6-astra/ultra with `fork_turns="none"` (no copied parent history); the native
result exposed its canonical task name only. Effective model, effort and history
settings remain unreported. No formal plan-review session has been performed.

Implementation connects current source/compiled validation and documentation to
the split historical/current contracts. The current loader compares the complete
manifest bytes against fresh generation and separately enforces reviewed source
policy. Trust invokes standalone retained compatibility, then retains the exact
current inventory, owner, focused-import, simp, alias, root-exclusion and every
compiled project constant's axiom audits. Default validation includes that trust
sequence; its clean-checkpoint gate remains intact.

Current v2 documentation configuration and two-pass attestations bind raw Lean
source, docstrings, explicit build/checker inputs and the actual clean 14-package
docbuild dependency graph. The input map is maintained in
`scripts/api_doc_identity.py`. Content changes invalidate old attestations while
preserving incremental caches; source-link/equation mode changes invalidate
mode-sensitive generated output. Failed or source-changing build sequences cannot
issue a new attestation. Current v2 docs are rejected before copying into the
frozen route; legacy preview additionally requires exact clean release source.
The unversioned source index labels current-development links, and maintenance
still pins them to the exact site commit while preserving frozen bytes.

No production Lean declaration, owner, import, attribute, alias, mathematical
assumption or dependency pin changed. Current coverage remains 601 supported
declarations in 31 modules, with 94 simp declarations and 92 facade aliases.
Release counts, tagged installation and both frozen artifacts remain historical.
The approved normative revision 2 hash remains
`50ca17fdeace90726327924f0d31d08dacd752fc0da94784482ca1dbdf3870bf`.

The parent completed `python -B scripts/validate_release.py trust` in 1491.668
seconds with exit 0 and empty stderr. It verified all 601 retained types, all 31
focused imports, the full supported environment and simp inventory, the 92 root
exports and 480 opt-in exclusions, and 1382 compiled local constants across all
44 project modules using only `Quot.sound`, `Classical.choice`, `propext`.
Originals are retained in `tmp/c9-03-current-trust-1789186769766088200/` and
`.lake/compatibility/cd0e2c98aeb449c0a9fc7c7be4f6750a/`. The unchanged relevant
62 source inputs and nine actual clean pinned dependencies establish continued
applicability; this comparison is not a fresh repetition of the Lean run.

The documentation entrypoint independently compiled all five README examples
with warnings as errors (exit 0, 74.200 seconds), retained in
`tmp/c9-03-documentation-1789188466512594600/`. The focused Python suite comprises
six validation/lifecycle tests, 25 API-doc tests, 17 growth-runner tests and 31
website/staging tests. Its completed original run is retained in
`tmp/c9-03-focused-final-initial-1789188575849305400/`; current post-correction
checks and source applicability are recorded separately below. Mocked external
doc-gen calls and synthetic HTML are not compiler or real documentation-build evidence.

The completed live retry is retained under
`tmp/c9-03-growth-live-retry-1789188702108670300/` and
`tmp/c903-b83545338af94830955d1b157f9beea3/`. All four cases passed their expected
outcomes: unchanged source; a documented compatible declaration in an existing
owner; a documented new opt-in owner with its two fixture-only approvals; and the
identical module, generated bytes and synthetic HTML with only those approvals
removed. Both changed positive cases passed full trust and direct Lean consumers.
The unapproved sibling compiled ordinarily but static, trust, compatibility and
docs each refused specifically at `IMPORT_APPROVAL_REQUIRED: LeanInfoTheory.Shannon`.
Generation remained repeatable and did not grant approval.

The unchanged case also retained old current-doc configuration/HTML across actual
signature, body and docstring edits of `natsToBits`. Each edit left the regenerated
current-manifest bytes unchanged, yet the maintained checker refused the stale
source-content identity; exact source restoration made it pass again. These three
freshness mutations claim no Lean compilation. Each fixture kept historical raw
bytes unchanged; final restored-source static and standalone compatibility passed,
all recorded owned source bytes were restored and the production input map was
unchanged. Per-command originals, exact generated hashes, mutation source,
matched-pair identities, assessments, summary and restoration records are retained.

The first live source-copy run failed static validation because the new website
test used `tmp/` before creating it; originals and exact restoration are retained
under `tmp/c9-03-growth-live-1789188553542084000/` and
`tmp/c903-ada42e05dcbe4367bd8d36845b2ec64f/`. The test now creates its scratch parent.
Self-review also identified the same portability issue in the focused lifecycle
tests. Supporting analysis reproduced two actual `FileNotFoundError` errors by
redirecting only `validator.ROOT` to an owned scratch checkout; test bodies and
real `tempfile` were unchanged. That actor's original command, output and boundary
description remain in `tmp/c903-portability-1789189136125765500/`. This is test
setup evidence, not a production Lean failure or formal independent review.

The parent's read-only self-review is
`009ee24a1964987f151fe00e6bcdc835ff55eabbb3110fc056ec61d78e884e2d`;
the separate reassessment is
`3f4ca8e60d11d2d938aa2f991159abec758146f90f5855906b024113113082a4`.
It accepted the optional focused-test portability fix, without changing validator
behavior or Lean source. Corrected focused-test, static and local-link evidence,
and refreshed applicability of the actual earlier Lean runs, are recorded through
the installed parent-evidence operation before dispatch. The original critique,
separate decision and failures remain preserved.

The fixture schedule is an in-scope efficiency decision: unchanged-source full
trust comes from the completed parent run; both changed positive fixtures receive
full trust. Exact restoration receives fresh static and standalone compatibility
checks, including a rebuild and the complete compiled boundary audit. The runner
explicitly records unchanged/restored full trust as not run where applicable; it
does not present the parent run as its own execution. This avoids repeating an
unchanged all-project audit while preserving the required changed-source checks.

| Criterion | Applicable evidence and boundary |
| --- | --- |
| C9.03-R1 | Current production full trust; real documented addition and matched approved/unapproved module checks; exact source inventory and independent policy approval. Generation itself grants no approval. |
| C9.03-R2 | Actual source-fingerprint/checker refusals for three same-manifest edits; unique/missing/extra/owner/type/docstring/attribute checks; attestation lifecycle and pre-copy historical guards. HTML fixtures are explicitly synthetic. |
| C9.03-R3 | Twice-generated exact byte comparisons and nonmutating check modes; fresh static/website and documentation-example checks; reconciled current/historical instructions and unchanged release pins/artifacts. |

The same persistent reviewer returned an original report for review source
`5084cd2358692cc5098a0be111c14c7a5de99b0f673209bacfbdbdfc4f33f223`.
All three criteria are **SATISFIED**, with no findings. Its original UTF-8 JSON
SHA-256 is `1edf19645108f655fae7fea9b8443a4ffdd6c01b55f4143897524fcea0bb933c`;
accepted capture `19a65e04e8b6b19e01ee075c2fd49cbc6ada43f40350b08cadb699b9a190b2fb` and canonical reconciliation
`ffe8563e67adf0ce7465de612de1ad4dcb9347ca12ed7613861ef5946556508d`
are preserved under `.lit-review/setup/c9-03-*`. The empty native submission
result remained an uncertain receipt until the matching original completion
confirmed delivery; requested settings remain distinct from observable settings.
A Windows text-decoding error in the first receipt metadata registration was
refused and preserved, then corrected with explicit UTF-8 without redispatch.

The reviewer independently executed the 79 focused tests, maintained static
validation, the full-current checker on explicitly synthetic HTML with actual
69-input/14-dependency identity, repeatable rendering and nonmutating checks,
and links across 11 documents. Its final source/hash refresh covered every
69-input documentation and 62-input trust identity entry, with actual pinned
dependencies. It did not repeat production trust, README compilation or the long
live growth matrix; those completed parent observations remained explicitly
attributed. No real doc-gen build or attestation was claimed. Its scoped source
assessment and evidence were reconciled without overriding or rewriting the
original report. Supporting implementation audits remain separate.

Before review, fresh post-correction validation passed all 79 tests, static
validation and 11-document links; the original two-test fresh-root probe also
passed and overlaps those 79 tests. Originals are retained in
`tmp/c9-03-focused-pre-review-1789192399958844700/`,
`tmp/c9-03-links-pre-review-1789192400366643300/` and
`tmp/c9-03-portability-corrected-1789192401543352700/`.
The final documentation correction also reconciles three stale C9.02 navigation
pointers in the living summary. Only five canonical/status documents change
after the reviewed source. Fresh final static/link checks and exact applicability
of earlier completed runtime/growth evidence are prerequisites to F; their
actual records are linked by
`.lit-review/setup/c9-03-final-validation-2-20260912.json`. No later step is selected.

The scoped implementation and maintained handoff are prepared for the installed
final validation and exact F capture. Maintained prose does not itself close the
workflow. The private `.lit-review/setup/c9-03-completion-20260912.json` record,
written after F, carries the actual completion/closure result; inspect it together
with installed state before processing another conditional request. No later step
is selected, and C9.03 grants no commit, push, tag or publication authority.

| Remaining work | Disposition and trigger |
| --- | --- |
| Complete cumulative C9 growth/negative fixture matrix and combined C9.01-C9.04 review/readiness | C9.04, only after durable C9.03 closure and its own explicit eligible request. |
| Two approved production theorems, permanent consumers and naming-note updates | C9.05/C9.06 in approved order, each with its own explicit request and review. |
| Clean default suite, complete cumulative fixture qualification, real two-pass current doc-gen and final cumulative review | C9.07; use the separately authorized clean checkpoint required by the plan. No clean gate is weakened or claimed here. |
| Full canonical chunk reconciliation, final remaining-work dispositions and `docs/handoffs/chunk-9.md` | C9.07. This step note maintains the intervening handoff. |

## C9.02 implementation and prepared handoff, 2026-09-12

C9.01 completed its review process: final source reference
`f38b40394ae60d884b47601490e87e554062c9b36064354fcb887eb58f66ce0e`,
durable closure
`bc046d53daef0394083815995ba0d4bb39fac0a3fbb27de60b4df7af720a35c5`.
Its original independent report satisfied all three criteria with no findings;
the report capture and canonical reconciliation remain in the private execution
record. Two optional reviewer repetitions were interrupted under host contention
and retained as non-pass evidence, separately from applicable completed runs.
No formal plan review was performed and effective reviewer settings remain
unreported, distinct from requested gpt-6-astra/ultra/no copied history.

The lead then requested: "Continue with step 2 with review process if step 1 with
its review process is completed". The installed workflow verified the predecessor
closure, unchanged source, next-step ordering and absence of blockers, and
accepted C9.02 only. Its baseline source reference is
`563234168a9a1c63937062e5d3f774044964cce7d08439d140fb467bebfa2087`.
The normative revision 2 hash remains
`50ca17fdeace90726327924f0d31d08dacd752fc0da94784482ca1dbdf3870bf`.
The original conditional request, inspect/api output and transition records are
preserved under `.lit-review/setup/c9-02-*`; no later-step authority follows.

The standalone [compatibility gate](../compatibility/README.md) now derives
current source, rebuilds its supported closure, compares all retained structural
types, and audits compiled declarations, owners, simp, aliases and focused imports.
The small reviewed policy is separate from generated inventory and begins with
empty approval lists. The checker reuses the unchanged historical serializer;
neither historical artifact is rewritten. Signature comparison precedes the
larger compiled import sweep so a type mismatch has a direct named diagnostic.
The current mathematical surface, root imports, pins and production trust policy
remain unchanged. The maintained fixture runner mutates only its owned ignored
source copy and preserves original outputs and restoration evidence.

The compiled audit uses one process for the complete focused-import sweep,
sequentially releasing extension-disabled import regions via Lean's ownership
wrapper. The full/root extension-loaded environments remain alive; only newly
serialized text escapes a released focused environment. This is a bounded
implementation choice to avoid retaining 31 large environments, not a change to
the compatibility requirements or production proof-trust policy.

The initial real runtime smoke passed with 601 public declarations, the exact 94
simp names and 92 alias/target pairs, five root modules, correct entropy resolution
and all 121 expected focused InfoMeasures name/owner pairs. It exposed an import
representation detail missed by the initial synthetic fixtures: pinned Lean adds
both ordinary and meta `Init` entries, not a singleton. Pinned
`Lean/Elab/Import.lean` confirms this behavior. The policy now recognizes exactly
that boilerplate and rejects unsupported source header modes; raw compiled output
is preserved unchanged. This correction follows actual compiler evidence without
relaxing other duplicate/import checks. The original singleton expectation remains
in owned before-images and earlier focused evidence; it was not a full gate pass.

Fourteen structural/freshness-orchestration tests and twenty-nine policy tests passed.
Six Python-only fixture-runner probes passed; they exercise mutation construction
and actual source parsing/policy without claiming that Lean compiled the cases.
The static gate passed its two generated-artifact check passes and all 29 website
tests. Seven affected documents passed local-link checks, and the approved
normative plan hash remains unchanged. The mocked command and synthetic compiled
JSON tests are not actual Lean build evidence. The current standalone command
passed its own warning-as-error build, all 601 retained types and the complete
31-module compiled audit, including 94 simp entries and 92 enumerated/resolved
facade aliases. Original output is under
`tmp/c9-02-standalone-current-1789166426195514700/` and
`.lake/compatibility/7cb5cd29a928493b8a12b718f76234db/`; input and dependency
identities agree before and after execution. That version checked simp in the
full umbrella only. Read-only investigation then found that a retained `simp`
annotation changed to `local simp` could be restored by a full-umbrella command
while remaining absent from a focused consumer. Focused simp reconstruction now
uses the pinned registered importer. The initial removal fixture
also needed correction: out-of-line `[-simp]` changes local state without erasing
exported annotations; the fixture now removes the actual source annotation.
The original suggested out-of-line erase/restore counterexample was withdrawn
after checking those pinned semantics; it was never executed or established.

The corrected direct checker command, `python -B scripts/check_public_api_compatibility.py`,
passed a fresh build, all 601 retained types and the complete compiled audit in
369.984 seconds. All 31 focused simp lists passed, with 1,334 memberships across
the overlapping closures. Every preexisting compiled JSON field exactly matched
the earlier successful audit. Actual local kernel-constant arrays now drive
discovery, with environment membership/owner checks and the unchanged public
classifier; pinned import implementation establishes their coverage. Separately,
two tiny compiling modules confirmed the reconstructed global/local/scoped simp
memberships exactly match normal extension loading. These are compiled support
checks, distinct from formal independent review.

Corrected native evidence is `.lake/compatibility/86c2a7c6dc554d888f5d150004ce4ce0/`,
with original wrapper output, field comparison, before-images and pinned-source
reasoning under `tmp/c9-02-focused-simp-20260912/`. Its compatibility-checker input fingerprint
is `fa90af733cc72b434d07e90fe7a55a1920cf4f6f029e5e1b3d34aef54198d6f4`;
all input/dependency identities agree before/after and match the current candidate.
The renewed static gate passed both generated checks and all 29 website tests.
Import diagnostics now preserve their refusal predicates while displaying changed
entries, including differences after long common prefixes. Missing retained names
and aliases display their historical value and current absence.

The original 16-case run passed its unchanged case; its addition compiled and
matched all retained types, but its boundary audit was intentionally interrupted
before completion to correct the candidate. Original commands, the explicit
interruption and non-pass result are preserved under
`tmp/c9-02-real-fixture-run-1789167481115295100/`. The runner restored all source
and the current manifest; parent inputs were unchanged. No completed suite or
addition compatibility pass is claimed from that run. The corrected runner adds
the focused `local simp` relocation case for 17 cases. The corrected complete run
passed all 17 expected outcomes and its final restored-source standalone gate.
Original output is under `tmp/c9-02-corrected-real-fixtures-1789169465587953200/`;
the isolated workspace is `tmp/c902-94825159538841398ef326792d74fb95/`.
All 14 negative cases compiled where required and were rejected for the intended
named reason. The compatible addition passed with 602 current declarations and
all 601 retained contracts intact; unchanged source passed with 601. The stale-artifact
case preserved the old owner artifact, then its standalone build replaced that
artifact and exported the changed `_c9extra` premise before rejecting it. Original
old/new artifact hashes and the root's source-restoration inspection are retained
under `tmp/c9-02-final-evidence-inspection/`.

The same-type definition-body change passed compatibility with all 601 types,
while the existing Units consumer failed: line 44 expected division by `Real.log 3`
instead of `Real.log 2`, and line 70 exposed base-3 versus base-2 `Real.logb`.
The baseline consumer compiled. This is actual evidence of the documented semantic
limitation, not approval of the mutated definition. The relocated simp case retained
the full umbrella's exact 94 simp names but lost the empty-family rule through
`Shannon.SemanticBridge`; the compiled focused-simp audit rejected it. A separately
added retained simp rule and an extra facade alias were also rejected by compiled
membership checks after all retained types matched.

The root inspected actual diagnostics and hash-verified native output streams,
all copied source/configuration/script/manifest restorations, and unchanged parent
checker inputs. Self-review and separate reassessment are recorded, and the
qualification finding was resolved using this completed evidence.

The same persistent reviewer independently assessed source
`e747d4b120d626f6d9f2e7a3d8c68e0a9465f60d355c6b1d3d34be85eaf436c4`.
Its original report satisfied all three C9.02 criteria with no findings; the installed
workflow accepted and reconciled it. Original report SHA-256 is
`7241bc100737b436761b2bed5067c06e46ddad318a6ee7d0b3f74d78412b3095`,
report capture is
`1d9600d3833aaca3a4757228f71c66ebcb5ab97657cc58d01c7f918c93d1536e`,
and reconciliation is
`e53afe5a0de9ec670aaa8247a72800944d95b63746644026a0aeaeeb8ffe6eca`.
The reviewer freshly passed the standalone build/export/compiled audit, fourteen
structural tests, twenty-nine policy tests, static validation including twenty-nine
website tests, scoped document links, and source/dependency checks. Its native gate
output is `.lake/compatibility/83ed9eabfa5045418dea931dd1cada53/`. It did not rerun
the 17-case matrix or inspect its private originals: it assessed the supplied actual
observations against independently checked matching source. The root's original
fixture inspection and the reviewer's fresh executions remain separately attributed.
One incidental process-status lookup raced with successful completion and remains
a non-pass observation, separate from the successful checker result. The original
empty send receipt remains uncertain; the completed native report separately
established delivery. Effective settings remain unreported.

Final source, canonical context and this maintained step handoff are validation-ready;
closure remains subject to the private completion record. Final documentation edits
record these review results and remaining work; they change no executable contract.
C9.03 requires its own eligible request after durable C9.02 closure.

| Remaining item | Disposition / owner and trigger |
| --- | --- |
| Final evidence applicability and closure | C9.02 validation-ready; independent review and reconciliation recorded; preserve earlier limited/interrupted evidence separately and stop after private closure |
| Default/static/trust and current API-doc integration, source fingerprints, historical preview protection, root README reconciliation | C9.03 after C9.02 durable closure and its own explicit eligible request |
| Complete growth fixture matrix and cumulative dirty-compatible qualification | C9.04; C9.02 focused tests do not close this duty |
| The two approved helpers and permanent consumers | C9.05/C9.06; no new production theorem in C9.02 |
| Complete clean-checkpoint suite, two-pass current API docs, full-chunk review and maintained chunk handoff | C9.07; no implicit commit authority |
| Formal plan review | Not performed; any separate renewed request uses the installed workflow and same reviewer |
| Broader Future Work and C10--C24 | Existing owners/triggers remain; no automatic progression or broad note closure |

## C9.01 implementation and prepared handoff, 2026-09-11

The lead accepted the exact presented revision 2 (full-file SHA-256
`b9914d8569de54baff0296ba6a40539f628dd841cee53c9dd3ed9c4302276bec`) and then
requested: "Great, do step 1 with its review process". The preceding instruction
expressly permits intelligent, justified procedural adaptations. On that basis
the actual implementation parent resolved the blocking native-schema prerequisite
through a narrow explicit collaboration adapter, preserving the legacy transport
and all source/criterion/reconciliation/closure safeguards. This is an interpretation
of those actual instructions, not a claim that a separate repair message arrived.
Only C9.01 is selected; no commit, publication or later-step authority follows.
The normative revision 2 hash remains
`50ca17fdeace90726327924f0d31d08dacd752fc0da94784482ca1dbdf3870bf`.

The existing reviewer `/root/c9_reviewer` is now bound using the original creation
result and actual canonical parent/child linkage. The execution session was opened
and the real step request consumed through the installed workflow. Requested
gpt-6-astra/ultra/no-history settings remain distinct from unreported effective
settings. There was no replacement reviewer or retroactive formal plan review.
Original refusal and setup records remain unchanged. Eighteen targeted adapter
tests passed (13 collaboration plus five legacy/parity); this is not a full-suite
claim. The prerequisite adapter changes precede the execution B capture and are
explicitly included in C9.01 review scope with their preserved before-images.

The exporter feasibility gate passed before generator behavior changed: two
independently built exact-release exports and a fresh current build/export agree
on all 601 signatures. Three real compiling mutations detect an extra premise,
argument rename and implicitness change; exact restoration reproduces the original
export. [Compatibility documentation](../compatibility/README.md) records the
representation, commands, provenance, failure boundaries and semantic limits.
The new current manifest reuses the existing parser/classifier. The old generator
is a non-mutating historical verifier. No production mathematical source,
supported import, public declaration, facade alias, reviewed simp or pin changes.

One factual correction concerns the plan's historical byte wording: its intake
hash identifies the untouched uniform-CRLF working file, while the exact Git
release blob uses LF. The two known byte identities and their exact LF-to-CRLF
relationship are recorded in the compatibility documentation. The working file
is preserved; verification accepts only those two fixed hashes, never arbitrary
normalization or regenerated contents. This preserves the historical contract.

Original command outputs and source identities are in `.lit-review/setup/` under
`c9-01-compiled-export-feasibility-20260911-*`,
`c9-01-real-signature-regressions-attempt2-20260911-*`, and
`c9-01-reproducer-corrected-20260911-*`. Earlier encoding-wrapper failures, the
initial scratch comparator error and the first reproducer's incorrect
instance-kind assumption remain separate non-pass evidence. The Lean exporter
was unchanged by those fixes. A Prop-valued source instance may compile as a
theorem; the artifact preserves both identities explicitly.

Eight focused inventory tests and eleven exporter/envelope tests passed. Current
generation was repeated byte-for-byte, both old modes preserved historical bytes
and modification time, and the static gate passed both render/check passes and
all 29 existing website tests. Affected documents passed local-link checks;
protected mathematical/configuration/publication files and historical working
bytes match intake. These are component checks on the intentionally dirty tree.
Prepared source and documentation are validation-ready; self-review, separate
reassessment, independent review, reconciliation, final validation and private
closure remain governed by the execution record. Do not infer completion from
provisional document wording.

| Remaining item | Owner / trigger |
| --- | --- |
| Current retained-contract checker, alias/import/attribute comparisons and freshness failures | C9.02, after durable C9.01 closure and an explicit eligible request |
| Current trust/API-doc integration, source fingerprints, historical preview protection and root README reconciliation | C9.03 under its own request |
| Full growth fixture qualification and cumulative dirty-compatible checks | C9.04 |
| The two approved helper contracts and permanent consumers | C9.05 and C9.06; no new theorem implemented here |
| Complete clean-checkpoint suite, two-pass current API docs and maintained chunk handoff | C9.07; requires actual authorized clean checkpoint, never implicit commit authority |
| Formal plan review | Historically blocked and not performed; any renewed separate request uses the installed workflow and same reviewer |
| Broader future-work notes and C10--C24 | Retain existing owners/triggers; no broad closure or automatic progression |

The sections below record planning history and its then-current limitations.

## Planning intake, 2026-09-11

The project lead explicitly requested planning only in
`C:\Users\coban\Desktop\Lean Info Theory`, reviewer bootstrap by the actual C9
implementation parent, and no implementation until exact plan approval followed
by one explicitly requested step at a time.

Read `AGENTS.md`, living-summary Section 0 and relevant conventions/architecture/
active work/future-work/reference/validation sections, the current proposed map,
the reference register, both review documents, the completed Chunk 8 plan's
status/contracts, targeted project-log installation/map entries and Note 25,
the public-API and downstream-feedback contracts, and relevant actual Lean,
pinned mathlib, validation, generation and staging source.

The map remains proposed; this new planning instruction authorizes the C9
proposal, not the broader map or implementation. Existing documentation still
contained a historical instruction to wait before review-workflow setup; actual
installation records and the newer user instruction supersede that sequencing.
Canonical active-state pointers now distinguish installation, C9 planning and
the outstanding binding/approval prerequisites.

Initial HEAD was `80ea016c7ac64bb5bd79b2f769227a3fb2ccc3b3`. Existing changes in
`.gitignore`, `AGENTS.md`, living summary, project log, roadmap, and untracked
feedback/map/reference/review documents and `tools/` were preserved. The planning
edits are this plan/notes pair and bounded living-summary/project-log pointers;
private setup evidence remains ignored. Mathematical Lean source, validator,
review adapter, pinned dependencies, frozen manifest and website were not edited.

## Persistent reviewer and native-schema limitation

Actual originating task identity, from exposed `CODEX_THREAD_ID`:
`01a090e5-167c-7181-8201-e0647c4c5e25`. It differs from the installation parent.
This is the actual task intended to implement C9 after approval, not a support
task borrowing an installation binding.

| Field | Requested / observed fact |
| --- | --- |
| Requested model | `gpt-6-astra` |
| Requested reasoning | `ultra` |
| Requested parent-history copying | Disabled; exposed call uses `fork_turns: "none"`, corresponding to the requested no-history behavior called `fork_context:false` in the installed guide. |
| Actual native tool | `collaboration.spawn_agent` |
| Entire native creation result | `{"task_name":"/root/c9_reviewer"}` |
| Observable reviewer handle | `/root/c9_reviewer`; no `agent_id` field was returned. |
| Effective model / effort / history settings | Unknown; not reported by the creation result. Tool request arguments are not effective-setting attestation. |
| Reviewer bootstrap result | Acknowledged readiness and read-only limits; explicitly reported no repository inspection or plan review. |
| Installed `bind` | Refused `CREATION_IDENTITY_MISMATCH`, because `project.py` requires `original_result.agent_id`. |
| Production binding and sessions | Absent. No plan-review or execution session was opened. |

The actual runtime message uses `Message Type: FINAL_ANSWER`, a task name and
sender; these are preserved as observed, not rewritten to the installation's
`multi_agent_v1` format. The installed adapter also expects `submission_id` and
`status[agent_id].completed` report envelopes, so creation identity is not the
only schema boundary to resolve. Keep the existing reviewer available. Repair
must cover actual creation/send/wait correlation and original-report extraction,
preserving the same acceptance/criterion-gap rules; a made-up identity alias or
successful bootstrap alone cannot make plan review operational.

No adapter change or replacement reviewer was attempted during planning. This
limitation needs a supported native interface or separately authorized bounded
adapter repair before using the installed workflow for plan review. It is not an
automatic approval-review rejection and does not require reopening C9 mathematics.

Durable private evidence is in `.lit-review/setup/`:

- `c9-reviewer-creation-original-20260911.json`: entire observed creation result.
- `c9-planning-bind-packet-20260911.json`: actual call arguments, honest local
  user-observation reference, requested settings and unknown effective settings.
- `c9-reviewer-bootstrap-original-20260911.json`: original bootstrap runtime event.
- `c9-planning-bind-refusal-20260911.json`: original shell-tool result and refusal.
- `c9-planning-inspect-20260911.json` and `c9-planning-api-20260911.json`: installed
  command results.

The shell wrapper reported exit 1 for the bind refusal while the CLI source maps
refusals to exit 2. Both facts are retained; the JSON refusal and absent binding
are unambiguous. Do not revise an original result to make exit conventions agree.

## Source and reference checks

`python -B tools/lit_review/cli.py inspect` and `api` ran successfully, then their
full results were saved using the installed exclusive `--save` option. Inspection
recognized the completed historical baseline, installed dependencies matching
their manifest revisions, existing installation, and absent C9 binding/execution.
It explicitly did not authorize mathematical execution or rerun historical gates.

The focused warning-as-error build passed:

```text
python -B scripts/validate_release.py focused LeanInfoTheory.Shannon.InfoMeasures LeanInfoTheory.Shannon.SemanticBridge.Independence
Build completed successfully (2751 jobs).
```

`lake env lean --stdin` successfully checked the actual types of the existing
independence predicate/product bridge/symmetry, `indepProd`, the three selected
pinned PMF map/bind identities, MI/CMI conditional-entropy identities and
`condEntropyOf_pair_swap`. Original input/output and source hashes are in
`c9-planning-declaration-checks-20260911.json`; original focused-build evidence is
in `c9-planning-focused-build-20260911.json`. These are existing-declaration checks,
not proof-complete new C9 theorem feasibility or implementation evidence.

CT91's registered local 1991 edition was inspected at Section 2.4 (printed
pp. 19--21, PDF pp. 41--43), Section 2.5's entropy/CMI/MI material (printed
pp. 21--22, PDF pp. 43--44), and Section 2.8 (printed pp. 32--33, PDF pp. 54--55).
The formula is derived from these existing identities; no separate named
"PFR decomposition theorem" is attributed to CT91. The general postprocessing
theorem uses PMF laws beyond the finite-entropy source presentation. No textbook
proof or substantial passage is reproduced in maintained documentation.

A text-extraction command initially stopped on Windows output encoding; rerunning
with explicit UTF-8 recovered the remaining selected pages. One source search
used a nonexistent examples subdirectory and was corrected to
`LeanInfoTheory/Examples`; no absence conclusion relied on that failed path.

A separate read-only planning-support agent inspected growth-sensitive source,
not the plan as an independent reviewer. Its useful observations were checked
against the actual scripts: versioned-manifest overwrite, historical-vs-current
import checks, 601/92 API-doc ceilings, and current output mislabeled by historical
preview staging. Its report is advisory input, not a workflow review or approval.

No external implementation repository was accessed. PFR evidence is the limited
intake already retained in the proposed map. No new dependency or toolchain was
installed. Reference PDFs and build/scratch outputs remain outside capture/Git.

Revision 1 planning validation passed the static release gate, including two independent
generated-artifact checks, trust/source and metadata/pin/publication-interlock
checks, source website validation and all 29 website tests. This is the existing
static gate, not the proposed C9 growth gate or a full clean-checkpoint suite.
The four planning/canonical documents passed local-link checks, exact seven-step
ordering, 21 unique step-criterion IDs, proposed-status and editorial-marker
checks, and diff whitespace checks. Production source/script/docbuild/website,
frozen-manifest and pin paths remained unchanged relative to intake HEAD.
Before delivering revision 1, only wording/punctuation and its validation note
changed after that static run; the checked production inputs remained applicable.
That historical check does not validate revision 2's substantive planning edits.
The original output is `c9-planning-static-20260911.json`; revision 2 checks are
recorded separately below.

## Advisory proof and tooling routes

- Independence: push the existing joint-law equality through the map
  `(a,b) -> (a,f b)`, identify the transformed independent product with the
  appropriate mapped second factor using `PMF.map_bind`/`PMF.map_comp`, and
  reconstruct `IsIndependentOf`. Keep the product transport proof private.
- Decomposition: combine the current MI/CMI conditional-entropy forms with pair
  chain rules/symmetry and ring arithmetic. No semantic nonnegativity argument
  or new conditional-law definition is needed. The plan fixes `(X,Z)` orientation.
- The structural type exporter is deliberately a pinned Lean audit of 601 named
  constants. Preserve binder names for named-argument compatibility; avoid an
  untested alpha-normalization or generic fingerprint framework. `C9.01` must
  establish full-surface feasibility before later code depends on it.
- Reuse current dynamic source/parser/environment checks. Keep the small reviewed
  attribute/import policy separate from generated inventory, so generation
  cannot silently approve changed architecture or new simp behavior.
- The two proposed non-stable consumer modules keep the decomposition's import
  test lightweight and the independence test attached to its semantic owner.
  Their declarations remain private; no production helpers are added for examples.

The preferred exporter route is a deterministic structural serialization of each
selected `ConstantInfo.type` and its universe parameters. Preserve dependent
binder structure, binder order/names/`BinderInfo`, applications, constants and
universe levels; do not unfold constants or replace unsupported syntax with holes.
Any normalization of source metadata or generated identifiers must be explicit,
justified and regression-tested. This is an advisory implementation route, not
approval to weaken Section 3.2: a different complete representation is acceptable
only if it meets every approved coverage, compatibility and failure requirement.
Full-surface repeatability and binder/assumption regressions precede changes to
generation behavior. No such exporter has been implemented or proved feasible.

## Revision 2 selective dispositions, 2026-09-11

After the initial proposal, the lead requested a plan review. The implementation
task supplied a source-based self-review, while formal installed-workflow review
remained blocked by the native-schema limitation above. The lead then supplied a
General Assistant independent advisory report and authorized selective revision.
That report is useful independent advice, not an accepted workflow report or
implementation approval. Revision 2 retains all seven steps and both mathematical
contracts, with the following dispositions.

| Suggestion | Disposition and reason |
| --- | --- |
| Self 1: remove circular readiness criteria | Accepted. C9.04/C9.07 criteria describe inspectable work and existing evidence; their own review, reconciliation, F and private closure are mandatory postconditions. Earlier-step closure remains a prerequisite. |
| Self 2: bind docs to actual source | Accepted. Attestation covers documentation-relevant source/configuration/dependency identity, including body and docstring changes that leave inventory names/counts unchanged. Reuse Lake's incremental build while rejecting stale evidence. |
| Self 3: make finalization order operational | Accepted. Prepare source/docs, obtain an authorized clean checkpoint, validate, capture R/review, reconcile corrections with applicable revalidation, then finalize/F/private closure. Status/advisory edits remain captured source changes. |
| Self 4: establish exporter feasibility first and avoid premature mechanics | Accepted with a boundary. C9.01 establishes full-surface feasibility before generator changes; the structural serializer route is advisory. Complete deterministic compatibility coverage, named-argument protection and fail-closed behavior remain normative. |
| Self 5: reassess the decomposition's name and public value | Accepted for naming and accounting; the alternative of deferring the helper is declined. The map records actual downstream pressure, and a permanent generic consumer tests its usefulness without importing downstream assumptions. Keep one convenience identity and count it separately from new theorem-family breadth. |
| Self 6: reduce repeated workflow prose and overlapping checks | Accepted selectively. Section 6 refers to the installed protocol for shared mechanics and schedules focused checks between the two cumulative tooling qualification points. Preserve all chunk-specific obligations and original evidence. |
| General Assistant 1: standalone compatibility must rebuild or refuse stale artifacts | Accepted. Build the relevant current closure with Lake before export and record its outcome; `lake env lean` alone is insufficient. A real retained-type mutation with an old compiled artifact must be detected or refused when invoking compatibility alone. |
| General Assistant 2: add an unapproved opt-in growth negative | Accepted. Pair the approved real opt-in fixture with the otherwise identical source lacking policy approval. Regeneration must not bless the latter. |
| General Assistant 3: reconcile root README explicitly | Accepted in C9.03 and C9.07. Preserve release statistics while labeling current counts, manifest identity and coverage separately. |
| General Assistant 4: consider a shorter decomposition name | Accepted. Select `mutualInfoOf_condEntropyOf_decomposition`, retain the exact formula and `(X,Z)` orientation in its docstring, and add no alias. |

A separate read-only support inspection found no collision for the selected name
in current Lean source, the frozen inventory or the declaration index. Existing
descriptive identity names support this form; retaining both `mutualInfoOf` and
`condEntropyOf` makes it searchable. This support inspection is not independent
plan review and did not build or implement the declaration. Only the proposed
name changes: the mathematical signature, assumptions, owner and consumer remain
as in revision 1.

The full user-supplied advisory report is preserved privately as
`c9-general-assistant-advisory-original-20260911.txt`. The self-review suggestions
remain in `c9-plan-self-review-suggestions-20260911.json`. Before-images of this
revision's four maintained documents are in
`c9-plan-revision2-before-20260911.json`. The original revision 1 proposal hash is
`c6f8cd680ca4e43b0521c57e6c037739c33a2a5792edbae940eb2cb634958820`.
These are advisory/provenance records, not workflow acceptance artifacts.

Revision 2 passed the existing static release gate, including both generated
check passes, source/trust/pin/publication checks, website validation and all 29
website tests. The four maintained documents passed local-link and whitespace
checks, seven-step/21-criterion/three-plan-criterion consistency, and exact equality
of the two Lean mathematical contract blocks against revision 1. Protected
production source/scripts/docbuild/website, frozen release bytes and pins remain
unchanged. A read-only support pass confirmed the revised sequencing and identified
the historical-validation labeling correction above; it is not formal review.
Original static output is `c9-plan-revision2-static-20260911.json`. Only historical
evidence labeling and validation reporting changed afterward; final document
identities/checks are retained in `c9-plan-revision2-final-20260911.json`.
No full clean suite, real API-doc rebuild, exporter feasibility or new proof was
run as part of this planning revision.

## Planning-revision limits and then-next action (historical)

Revision 2 is a detailed proposal. The requested formal plan review remains
pending; self-review and supplied advisory review do not replace it. No exact
implementation approval exists, no C9 step was begun and no future-work item is
marked discharged. Formal review must use the installed workflow once the
documented native-schema prerequisite is resolved. The final step deliberately
requires actual clean-checkpoint and two-pass API-doc evidence; partial/dirty
checks cannot close it or authorize an implicit commit.

The final user report identifies the exact proposal hash and planning checks.
Originals and before-images remain durable private records; never clean them up
as disposable proof scratch.
