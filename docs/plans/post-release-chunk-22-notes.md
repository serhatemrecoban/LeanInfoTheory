# C22 planning and implementation notes

These are **advisory, evolving notes** for the approved
[C22 plan](post-release-chunk-22.md), revision 2, dated 2026-10-24. They record
planning, closed C22.01–C22.06 and selected C22.07 implementation and review; they are not a formal
review report or a replacement for the plan's mathematical and acceptance requirements.
Sections 1–2 and 6 retain the original intake, bootstrap and planning-check
history. Section 7 records the later revision-1 review and revision-2 decisions.

## 1. Intake and source applicability

Authorized checkout: `C:\Users\coban\Desktop\Lean Info Theory`.
The chat was renamed **Chunk 22**. Its native parent thread identity is
`01a16b2d-041d-7d10-8b2e-0b75a5df96d5`; the runtime parent role is `/root`.
HEAD is `33a367ace4fec271956974474b982a5c7a654a3b`.

Read the repository instructions, living-summary Section 0, relevant map and
reference-register content, review protocol/operations, C21 handoff and actual
completion record, C15/C17/C18 handoffs, actual producers/consumers and targeted
project-log entries (C15.04/05, C17 closeout, C18.03/04/06 and C21 closeout).
Source and evidence take priority over historical captured provisional wording.
The supplied C21 final checkpoint is still current.

At intake four tracked files were already modified: `.gitignore`, `AGENTS.md`,
`docs/next-website-tasks.md`, `docs/project-log.md`. Their hashes are retained in
`.lit-review/setup/c22-intake-source-20261024.json`. Planning owns only the two
new C22 Markdown files and its private/scratch evidence; it does not repair,
normalize, stage or commit those unrelated changes.

The read-only C21 verification is retained in
`.lit-review/setup/c22-c21-applicability-result-20261024.json`, produced by the
adjacent `c22-c21-applicability-20261024.py`. It checked:

- completion status `SUPERVISED_STEP_COMPLETE`, actual closure
  `69a406c1ab8240f946b59eae81f47cfde25c1641cccb32fc631f82a2298456b2`,
  production acceptance, C21.05 identity, final-source and review links;
- content-addressed B/R/F, request, review, original capture, acceptance,
  reconciliation, final evidence, documentation and impact records;
- all thirteen named artifact hashes linked from the completion packet,
  including the genuine native event/original wrapper, clean result, API
  applicability, strict cumulative matrix and parent agreement;
- all 285 actual files in the 286-entry F inventory, with no missing or changed
  file; the remaining entry is environment evidence. Configuration and all
  nine installed dependency records also match the fresh workflow inspection.

The strict matrix records all seventeen original criteria SATISFIED, exact
approved-order coverage and zero findings, with four reported FAIL observations
retained rather than turned into passes. The separate parent agreement has
seventeen rows. Native outer closure has three closeout criteria; it is not by
itself a mechanical seventeen-criterion certificate. The actual original
matrix, reconciliation and linked qualification are part of the inspected chain.
The recorded clean rerun has status PASS and exit 0. This intake does not claim
a new full suite or new API build and does not reopen completed C21 work.

## 2. Reviewer initialization and authority

Ran the installed `python -B tools/lit_review/cli.py inspect` and `api`
commands, then retained fresh saved outputs:

- `.lit-review/setup/c22-inspect-20261024.json`
- `.lit-review/setup/c22-api-20261024.json`

The actual parent created `/root/c22_reviewer` with the exposed native call
`collaboration.spawn_agent`, requested model `gpt-6-astra`, reasoning effort
`ultra`, and `fork_turns="none"`. The genuine creation result was exactly the
canonical task handle. No agent ID, submission ID, effective settings or
synthetic completion wrapper was invented.

The installed collaboration adapter accepted the binding input through:

```text
python -B tools/lit_review/cli.py bind --input .lit-review/setup/c22-binding-input-20261024.json --save c22-binding-result-20261024.json
```

The durable binding is `.lit-review/chunks/C22/binding.json`. The input retains
the exact bootstrap call/message, genuine creation result, actual parent thread
and role, exact pasted user authorization and explicitly local observation
references. Observable effective parent/reviewer settings are unknown (`null`),
separate from the requested profile. This is a fresh C22 binding, not a binding
transferred from C21 or another chunk.

At initialization, the reviewer was instructed to remain read-only, perform no delegation/edits or
unrelated access, and wait for a neutral source-bound request. It acknowledged
readiness. The actual `collaboration.list_agents {}` result and exact extracted
bootstrap text are preserved in
`.lit-review/setup/c22-bootstrap-native-list-20261024.json`, explicitly classified
as bootstrap only. At that checkpoint no source-bound review had been sent and
no plan/execution session had been opened. The later formal revision-1 PLAN
review is recorded in section 7; it supplies no implementation authority.
Read-only instructions and observable call parameters are not OS isolation or
authenticated proof of hidden effective settings. Reuse this bound reviewer when
the lead explicitly requests review, with the supported native result extractor.

Two other agents performed read-only planning-support source audits of producers
and concrete-channel ingredients. They did not perform formal plan review,
write files, build production code, or substitute for the persistent reviewer.

## 3. Verified reuse map

The following names were found in current local source. Selected declarations
were additionally checked by the bounded probe in section 6. Do not interpret
every row as a newly compiled full proof or an approved new declaration.

| Existing producer | Exact source and useful contract |
| --- | --- |
| `PMF.instTopologicalSpace`, `PMF.instCompactSpace`, `PMF.homeomorphStdSimplex` | `Probability/FiniteTopology.lean`; the finite-PMF compact domain includes zero coordinates and empty types, with nonemptiness a separate obligation. Compactness needs only `Finite`. |
| `continuous_mutualInfo_channelJoint` | `Shannon/Topology.lean`; finite input/output, independent universes, exact `fun p => mutualInfo (PMF.channelJoint p W)`, including zero masses. |
| Private `exists_maximizing_input` | `Examples/ChannelOptimization.lean`; direct `isCompact_univ.exists_isMaxOn` application using a pure input. It adds no output nonempty premise and cannot be imported into production. |
| `PMF.productChannel`, `PMF.memorylessChannel` | `Probability/ProductChannel.lean`; existing conditional product/repeated channel, no input-law independence. Actual direct import is `Probability.Iid`, rather than a new direct finite-product/channel import list. |
| `mutualInfo_channelJoint_productChannel_le` | `Shannon/SemanticBridge/ProductChannel.lean`; arbitrary q, actual coordinate marginals, finite dependent alphabets. |
| `mutualInfo_channelJoint_finiteProduct`, `mutualInfo_channelJoint_iid` | Same owner; exact independent-input sum and all-n scalar identity. These give the lower witness after single-letter attainment. |
| `sum_mutualInfo_sub_mutualInfo_productChannel`, `mutualInfo_channelJoint_productChannel_eq_sum_iff` | Same owner; output entropy gap and full output independence criterion. Available for interpretation; no new C22 equality-case programme is required. |
| `mutualInfo_channelJoint_eq_entropy_bind_sub_sum` | `Shannon/SemanticBridge/Convexity.lean`; `I(p,W)=H(p.bind W)-∑a p(a).toReal*H(W a)` without positivity assumptions. Avoid promoting C18's private conditional-row helper. |
| `sum_mul_mutualInfo_channelJoint_le`, `mutualInfo_binaryMixture_input_concave` | Same convexity owner; existing selector/binary input concavity. A private optimizer-mixture consumer suffices; no new concavity framework. |
| `mutualInfo_channelComp_le`, `mutualInfo_channel_map_output_le` | `Shannon/SemanticBridge/Markov.lean`; arbitrary-input stochastic/deterministic output processing. No need to add the heavier DataProcessing import just for these facts. |
| `mutualInfo_map_fst_le`, `mutualInfo_map_snd_le`, `mutualInfo_map_prod_le` | `Shannon/SemanticBridge/Theorems.lean`; equivalences and their inverses can yield relabeling equality. |
| `mutualInfo_nonneg`, `mutualInfo_le_entropy_fstMarginal`, `mutualInfo_le_entropy_sndMarginal` | Same semantic theorem owner; combine with actual channel marginals and alphabet entropy bounds. |
| `entropy_le_log_card`, `entropy_uniformOfFintype` | `Shannon/EntropyBounds.lean`; requires nonempty relevant alphabet, derivable from a PMF/channel where appropriate. |
| `PMF.channelJoint_deterministicChannel`, `mutualInfo_map_diag` | Raw finite channel and `Shannon/InfoMeasures.lean`; noiseless objective equals input entropy. |
| `PMF.binaryMixture`, `_apply`, `_zero`, `_one` | `Probability/FiniteMixture.lean`; NNReal first-branch weight t, proof t≤1, endpoints require their proof argument. |
| `entropy_bool`, `Real.binEntropy_one_sub`, `_zero`, `_one`, `_two_inv` | `Shannon/BinaryEntropy.lean` and pinned scalar entropy support; BSC row entropy and endpoints. |
| `natsToBits`, `natsToBase`, `div_log_change_base` | `Shannon/Units.lean`; scalar units only. `natsToBits x = x / log 2`. |

Current source/index and pinned `Mathlib.InformationTheory` searches found no
existing capacity, BSC or BEC implementation to reuse. This is a bounded search
result, not a claim about every external formalization. No external formalization
repository was consulted. Pinned `PMF.bernoulli`/`bernoulli_apply` are deprecated;
use the project's existing mixture instead of introducing warnings under the
warning-as-error policy. The installed Lean and mathlib remain v4.33.1, with
mathlib revision `0df444a360eaa60ab8c11dca51a86af692955474`.

Pinned order/topology searches verified `IsCompact.exists_isMaxOn` in
`Mathlib/Topology/Order/Compact.lean`, and `isLUB_csSup`, `le_csSup`,
`csSup_le`, `csSup_le_iff`, `IsLUB.csSup_eq` in
`Mathlib/Order/ConditionallyCompleteLattice/Basic.lean`. No generic optimizer
framework or public range-boundedness wrapper is necessary.

## 4. Source audit and mathematical interpretation

Recomputed the registered hashes and page counts:

| Source | Checked identity and reading |
| --- | --- |
| CT91 | 563 pages; `16f016eafbb1160c2d8e6c29ff28db870e0eb2e61c15ea39bea5b06d463a952f`; Chapter 8 introduction and 8.1–8.3, printed 183–191 / PDF 205–213. |
| PW24 | 730 pages; `c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`; Chapter 5, printed 91–105 / PDF 116–130; 6.1, printed 106–107 / PDF 131–132; 19.3, printed 379–381 / PDF 404–406, stopping at the next section. |

Used the bundled pypdf runtime for selected-page extraction, and Poppler for
visual checks of PW24 PDF 405 and CT91 PDF 213. Relevant adjacent page fragments
were distinguished from the selected sections; no reading of operational
achievability is used to justify a C22 conclusion. Local extracts/renderings
remain ignored under `tmp/c22-planning/`; copyrighted references are not committed
or reproduced in these documents.

CT91 8.3 lists continuity, concavity and finite upper bounds. Its informal
attainment discussion is implemented with nonempty compactness plus continuity;
finite bounds alone cannot justify replacing a supremum by a maximum.
PW24 Theorem 5.4 assumes an achieving input, while its later general-channel
Theorem 5.9 supplies an optimal output under finite capacity. Neither replaces
C15's actual finite-PMF extremum argument. Chapter 5's minimax, Gaussian and
iterative algorithms were read for boundaries and do not become requirements.

PW24 6.1(a) concerns product conditional channels with arbitrary input; the
maximizing input may be chosen product. It does not assert that all optimizing
inputs are independent. C18's output-independence equality criterion is consistent
with that distinction. The C23 interface must work on encoded correlated laws.

The visual PW24 19.3 BEC page confirms a missing erasure weight in the displayed
conditional-entropy chain and inconsistent multiplicative-noise parameter prose.
Anchor ε to the erasure probability in the PMF rows. The required identity is
`I=(1-ε)H(input)`, also obtained by CT91's output-entropy calculation. At zero
erasure there is no positive-mass erasure fiber on which to divide. At full
erasure every input achieves zero. Similarly, the BSC “iff uniform” phrase needs
qualification at crossover 1/2. C22 requires uniform attainment, not uniqueness,
and covers the full closed parameter interval. These are explicit adaptations,
not imported errors or new operational assertions.

## 5. Proof routes and design rationale (advisory)

### Core and product

Obtain a true maximizing PMF from compactness/continuity first. Its value bounds
the objective range; a pure law witnesses nonemptiness. Identify the maximum
with `sSup` using the verified order lemmas. This avoids proving analytic
boundedness twice. Keep range lemmas private and publish only the usable
objective bound, universal bound iff and attained-capacity statement.

Binding `[Nonempty A]` explicitly on `channelCapacity` itself makes the roadmap's
domain explicit. An unused ambient section instance is dropped by elaboration,
as the later review probe confirmed. The explicit binder avoids an externally
visible empty-range capacity convention.
Equivalence statements may require a local transported instance in their type;
work out that elaboration without adding an independent nonempty assumption on
the renamed input. Output inhabitedness comes from a support element of `W a`.

For relabeling, privately transport `channelJoint` with the corresponding
input/output map, use MI monotonicity in both equivalence directions, and then
the universal upper-bound interface. Use the already available postprocessing
theorems for stochastic and deterministic inequalities. No second-stage
capacity bottleneck or optimizer-uniqueness result is required.

For the stronger relabeling consumer, a suitable private fixture has `Fin 3`
input masses `(1/2, 1/6, 1/3)` and Boolean-output rows
`(PMF.pure false, PMF.pure true, PMF.uniformOfFintype Bool)`. Under the cycle
`0↦1↦2↦0`, `p.map e` paired with `W ∘ e.symm` preserves the output law,
whose true-mass is `1/3`. Erroneously using `W ∘ e` gives true-mass `7/12`.
Check the joint equality against the pushforward of the original joint by
`fun (a, b) => (e a, b)`; then derive the output/objective and capacity results.
These exact fixture fractions are advisory. The normative obligation is a
nonuniform three-cycle with distinct rows and an orientation-sensitive law check.

For products, first prove the arbitrary-q upper chain with actual marginals.
Choose one maximizing law per coordinate for the lower chain, then use the
existing product-input identity. The existing private
`Examples.ProductChannelInformation.coordinate_objective_cap` gives a useful
typed-intermediate/`convert!` pattern for finite-Pi instance coherence. It is a
proof-reading reference, not a production dependency. Maintain independent
universes and avoid public `DecidableEq` or extra typeclass assumptions.

### Selected channels

The common public weighted-row formula handles constant channels and both
binary channels. For BSC each row has entropy `Real.binEntropy ε`; uniform input
gives uniform output, and every output law has entropy at most `log 2`.
Export the resulting uniform-input MI-equals-capacity equation once, after
the capacity value is established, and make the permanent consumer use it.
This avoids repeating uniform-output preservation outside the supported owner.
For BEC the output masses are ε at `none` and `(1-ε)*p(b)` at `some b`.
`Real.negMulLog_mul` is valid even for zero factors and expands the output
entropy as `h(ε)+(1-ε)H(p)`; each row entropy is `h(ε)`.
This avoids conditional laws at null fibers.
Its uniform-attainment consumer should simply combine the public BEC objective
and capacity formulas with `entropy_uniformOfFintype`; it needs no separate
attainment export or repeated entropy calculation.

Use the same private biased Boolean law with true-mass `1/4` in both information
consumers. The existing binary mixture of pure true/false laws provides it.
For BSC crossover `3/4`, the true output mass is
`(1/4)*(1/4)+(3/4)*(3/4)=5/8`; apply the public objective and `entropy_bool`.
For BEC erasure `1/3`, the masses at `none`, `some true`, `some false` are
`1/3`, `(2/3)*(1/4)=1/6`, `(2/3)*(3/4)=1/2`; apply the public MI formula.
These exact computations supplement the required pure/uniform and endpoint
cases. Keep entropy expressions symbolic rather than approximate logarithms.

Use NNReal parameters plus ε≤1 to match `binaryMixture`; coerce to Real for
binary entropy and scalar formulas. A subtype of the closed interval or a Real
parameter with two bounds would be possible, but would add conversions without
benefit for the selected constructors. `Option Bool` gives a distinct erasure
symbol without an arbitrary three-symbol encoding or another alphabet framework.

The four supported owners keep probability rows separate from optimization,
product theory separate from examples, and bits work in the opt-in example
owner `Shannon.StandardChannelCapacity` importing Units. Its corresponding
private consumer is `Examples.StandardChannelCapacity`; four private consumer
owners test the import boundaries.
No existing source owner must import capacity; the root remains unchanged.
The 26-declaration revision-2 proposal adds just the direct BSC uniform-attainment
theorem to revision 1's surface. This is not a count target. No chosen-optimizer
definition, optimizer structure, symmetry machinery or generic BitsCapacity
definition is justified. Specialized public raw mass lemmas remain deferred:
the transparent constructors and existing `PMF.binaryMixture_apply` supply
the needed access; promote a helper only if actual repeated consumer pressure
shows that this interface is insufficient.

## 6. Bounded planning-only feasibility checks

The first process ran
`lake env lean -DwarningAsError=true tmp/c22-planning/Probe.lean`.
It printed and resolved selected exact declarations, but the aggregate probe
**failed**: the dependent-function statement lacked a locally classical finite
instance; direct composition also hit an `isDefEq` heartbeat limit; one mixture
endpoint invocation omitted its explicit proof argument; and the upstream
`negMulLog_mul` identity lists the addends in the opposite order.
The source, hash, actual failure diagnostics and local process reference are
retained in `.lit-review/setup/c22-probe01-observation-20261024.json`.
This record is a parent observation, not a fabricated complete native log.

The second run retained full stdout/stderr, source and hash in
`.lit-review/setup/c22-probe02-result-20261024.json`. It was bounded to 480
seconds and finished in about 28 seconds, still **FAIL**, solely on the direct
product-bound composition's 200000-heartbeat `isDefEq` timeout. Classical scope,
the mixture endpoint argument and sum order had been corrected. The failure
does not establish an impossible mathematical contract or justify weakening it.

The third bounded run uses the existing C18 consumer's typed intermediate
and `convert!` pattern, without changing the dependency pins or increasing
heartbeats. It has a 120-second process bound and retains its actual result,
stdout/stderr, exact source and hash in
`.lit-review/setup/c22-probe03-result-20261024.json`.
It finished in about 14 seconds with **PASS**, exit 0 and empty stderr, using
warnings as errors. Its source SHA-256 is
`fd72118d0a0fb97f58bf0035ab2d8d56c4f061cef34a01d38c809b95987d3a1d`.
The earlier failures retain their original attribution and do not become passes.

Probe scope is deliberately narrow: direct public C15 attainment composition;
output nonemptiness from a row; C18 arbitrary-q bound followed by arbitrary
coordinate caps; zero-length iid MI; existing mixture constructors and an
endpoint; and zero-compatible scalar entropy algebra. There is no production
capacity definition or implemented capacity theorem in the probe. Complete
relabeling normalization, the sSup API, standard-channel entropy calculations,
all example proofs, generated growth gates and cumulative validation remain
implementation obligations. No full suite or API-doc milestone ran for planning.

Parent editorial/contract inspection checked all eight ordered steps and 26 unique
criterion IDs, all four example endpoints and achieving-law obligations, the
arbitrary-input product/C23 quantifiers, domain/zero-length boundaries and the
separate approval gates. It clarified that C22.03's early strict-gap consumer
uses existing objective calculations and the core bound, so it does not depend
on the later noiseless-capacity example step. This is planning self-inspection,
not the installed formal review workflow or an independent PLAN report.
Final scope checks and scratch removal are retained privately in
`.lit-review/setup/c22-planning-final-check-20261024.json`.

## 7. Revision-1 review and revision-2 decisions

The lead explicitly requested review of proposed revision 1 without editing it.
The installed workflow opened `plan-r1-20261024` with the original plan SHA-256
`8a25c1997d66b2b28daf2ca0fe669e0a874336dd1b82571f241da5c599853975` and the
existing persistent `/root/c22_reviewer`. The genuine original report is
`.lit-review/setup/c22-plan-review-01-original-report-20261024.json`.
It assessed all eight plan-review requirements, covering the 26 detailed future
implementation criteria, as satisfactory and reported no material findings.
This was specification/feasibility review, not completion of those future criteria.

The native dispatch returned empty output and was preserved as UNCERTAIN;
delivery was confirmed from the genuine correlated `collaboration.list_agents`
completion through the supported operation, without resending. The original
report was classified VALID and substantively reconciled. Native observations,
classification, confirmation and parent dispositions are retained beside
`.lit-review/setup/c22-plan-review-01-parent-reconciliation-20261024.json`.
The final check `c22-plan-review-01-final-check-20261024.json` recorded both
planning documents and all four protected files unchanged, no execution session,
and `plan_approved: false`. Reviewer inspection failures remain recorded as
failures; corrected checks do not erase them.

The parent also ran a narrow read-only stdin comparison, retained in
`.lit-review/setup/c22-plan-review-signature-probe-20261024.json`. It confirmed
that Lean omits an unused ambient `Nonempty A`, while an explicit declaration
binder is retained. The first comparison emitted an overlapping-instance warning;
the corrected section layout passed with warnings as errors. This was a signature
check, not a production capacity implementation or a completed C22.01 proof.

The lead then pasted an independent General Assistant advisory report. It found
no blocking mathematical, scope or architectural problem and suggested a directly
usable uniform optimizer, a non-involutive relabeling consumer, and biased-input
standard-channel checks. It is retained as user-supplied advice, not substituted
for the installed workflow's original report or treated as approval.

The subsequent user request authorized choosing a useful subset of both sets of
suggestions and revising the plan. Revision 2 adopts the following decisions:

| Suggestion | Disposition and reason |
| --- | --- |
| Explicit nonempty binder | Adopted in the displayed definition and C22.01 signature check. The probe demonstrated the elaboration risk; the intended mathematical domain is unchanged. |
| Earlier exact signature checks | Adopted inside C22.01–03 for domain binders, transported nonemptiness, universes, argument order and arbitrary-input/all-n quantifiers. This catches interface issues before dependent proofs without adding a step. |
| Public uniform attainment | Adopted for BSC as `mutualInfo_channelJoint_binarySymmetricChannel_uniformOfFintype`, with an actual focused consumer. Declined a separate BEC export: its general MI identity, uniform entropy and capacity formula already give the witness directly; the consumer must demonstrate that route. |
| Public raw mass/apply lemmas | Deferred. The two transparent definitions plus existing `PMF.binaryMixture_apply` suffice for the planned raw and information consumers. Revisit only with concrete proof/discovery pressure; no mandatory helper growth now. |
| Supported module naming | Adopted `Shannon.StandardChannelCapacity` and matching private `Examples.StandardChannelCapacity`. This distinguishes supported standard-channel results from development-only examples before any source module or released name exists. |
| Three-cycle relabeling consumer | Adopted in place of the mandatory Boolean-permutation fixture. Boolean permutations are involutions; the three-cycle with nonuniform masses, distinct rows and joint/output-law checks can expose the inverse-orientation mistake. One-sided specializations remain required. |
| Biased interior channel inputs | Adopted the exact `p(true)=1/4`, BSC crossover `3/4`, and BEC erasure `1/3` checks in C22.05–06. They exercise the general public objective formulas where pure/uniform cases simplify too much, including crossover above one half. |

Read-only planning support cross-checked the proposed witness equation, both
rational examples and a concrete three-cycle fixture against the existing mixture
and entropy interfaces. It performed no builds or edits and did not act as the
persistent formal reviewer. All eight steps, all 26 criterion IDs, four required
channel families, arbitrary correlated-input scope, zero/empty boundaries,
C23 interface and cumulative validation/authority obligations remain in place.
The proposed public surface is 26 declarations (10 core, 3 product, 2 raw,
7 standard-channel nats/attainment, 4 bits), in four supported owners.

Revision-1 plan/notes bytes were preserved before editing in
`.lit-review/setup/c22-plan-revision2-before-20261024.json`. Existing review
records are not modified or rebound to revision 2. No fresh formal PLAN review
of revision 2 is claimed, and this editing request is not implementation approval.

## 8. Approval and selected-step boundary

On 2026-10-24 the lead approved the exact revision-2 plan and selected only
C22.01 with its review process. This is implementation authority, not a fresh
formal revision-2 PLAN review. Complete that step and its review, then stop;
C22.02 onward remains unselected. The approved domain, later channel parameters
and representations, four owners and eight-step division remain unchanged.

Clean-checkpoint/amendment authorization and the current API-documentation
milestone remain separate later gates. No commit, push, publication, release
or C23 work follows from the selected step.

## 9. C22.01 implementation and validation — 2026-10-24

`Shannon.ChannelCapacity` contains exactly the seven selected
public declarations: the supremum definition, objective bound, universal-bound
iff, actual attaining-input existence, nonnegativity and both alphabet bounds.
The definition explicitly binds nonempty input and preserves independent input
and output universes. Private helpers establish nonempty and bounded objective
range before Real supremum operations. Attainment uses C15's compact domain and
continuous channel-MI objective; output nonemptiness is derived from a row.

Actual direct imports are `Shannon.Topology`, `Shannon.EntropyBounds` and
`Shannon.SemanticBridge.Theorems`. The lighter last import supplies the current
MI inequalities; Markov/data processing is unnecessary until C22.02. This is
proof-dependency refinement, not a changed theorem contract. No new simp
attribute, root export, optimizer definition or public helper is proposed.

`Examples.ChannelCapacity` imports only the new focused owner. Its private
consumers reuse one maximizing PMF for equality, comparison with all inputs and
the upper-bound iff; check a pure ternary input's zero masses and zero objective;
derive singleton-input/output capacities from the public bounds; and distinguish
an empty input's vacuous channel function from its absent PMF/maximizer and an
inhabited input's impossible empty-output channel.

C22.01's corrected producer/consumer and aggregate builds, focused and umbrella
signature probes, all nine documentation examples, static/generated checks and
the full compiled compatibility/trust audit passed on their recorded inputs.
Independent review assessed all four selected criteria as satisfied with no
findings; the parent reconciled each assessment against the source and evidence.
Current inventory is 756 declarations in 51 owners; the compiled audit confirms
the unchanged 92 root exports and 94 reviewed simp names. The initial style
warning and the successful `let` correction remain separate retained results.
This is validation-ready status. Final source applicability and scoped closure
are established only by `.lit-review/setup/c22-01-completion-20261024.json`
when present, including fresh final static/scope checks and the exact R-to-F
comparison. The clean cumulative routine and current API-documentation milestone
remain C22.08; no later step is selected.

Actual records: `.lit-review/setup/c22-01-focused-initial.json` retains the
style-warning failure; `c22-01-focused-corrected.json` retains the successful
four-target build. `c22-01-signatures-20261024.json` records all seven elaborated
signatures and the definition through focused and umbrella imports, including
the retained `[Nonempty A]`, separate universes and absence of `[Nonempty B]`.
The `c22-01-static-initial.json`, `c22-01-scope-initial.json`,
`c22-01-documentation-initial.json` records retain the other actual outputs
and limits. The full `trust` command overlapped independent source review
and subsequently passed on the unchanged Lean inputs. This bounded sequencing
choice used the lead's explicit procedural discretion: focused proofs, signatures,
static and documentation checks had passed before review; the full compiled audit
remained a required closure condition throughout.
No required check or acceptance criterion is waived. Scope checking preserves HEAD, index,
configuration, dependency pins and every pre-existing project-log byte.
The early overlapping workflow edit attempt was refused as `WRITER_BUSY` while
admission was still running; after actual admission completion, the ordinary
edit operation succeeded. No lock, journal, contract or gate was bypassed.
The parent claims no full clean build, fresh textbook reread or current doc-gen build.

## 10. C22.01 independent review and final applicability — 2026-10-24

The persistent independent reviewer inspected the exact selected source and
returned an original STEP report covering all four C22.01 criteria. Each was
SATISFIED and the findings list was empty. The parent independently agreed with
the supremum-range obligations, actual compactness/continuity attainment proof,
derived output nonemptiness, and the permanent domain/interface consumers.
No source correction or normative plan change was needed after review.

The reviewer separately reread CT91 PDF pages 206 and 212–213 and PW24 PDF
page 119, checking both local PDF hashes. That original reviewer evidence
supports the reference adaptation and is distinct from the parent's retained
planning readings; it does not recast those earlier readings as fresh ones.

The original native submission returned no acknowledgement; that uncertainty
was retained, and the actual completed report supplied delivery evidence. It
was not replaced by a parent-written summary or silently resent. Review was
independent source evaluation with instructed read-only access, not blind or
OS-enforced isolation. Full reviewer evidence retains its own actor and limits.

The successful compiled audit is retained in
`.lit-review/setup/c22-01-trust-initial.json`; exact compiled-input identity is
checked before, after and at final qualification. Only these canonical status,
reference and plan-editorial documents change after the reviewed snapshot.
Final static/scope checks and an explicit source comparison establish continued
applicability of the retained focused, signature, documentation and trust runs;
those runs are not claimed freshly repeated. The completion record named above
owns the actual final snapshot and closure. C22.02 is not started. C22.08 retains
the separate clean cumulative and API-documentation duties.

## 11. C22.02 admission, implementation and validation — 2026-10-24

The user's conditional request selects only C22.02 with review under approved
revision 2. The parent verified C22.01's actual closure and all 276 captured
source/environment entries before admission. Sections 8–10 retain their earlier
history; their unstarted-C22.02 statements describe that snapshot.

The current source adds `channelCapacity_congr_equiv`,
`channelCapacity_channelComp_le` and `channelCapacity_map_output_le` in
`Shannon.ChannelCapacity`. Markov replaces Theorems for existing DPI; Topology
and EntropyBounds remain. Production has no Convexity dependency. Relabeling
keeps four independent universes, inverse input-row orientation and locally
transported renamed-input nonemptiness through `e.symm.nonempty`. The capacity
inequalities apply existing channel-MI DPI to every input law, with no new
output-inhabited or injectivity premise. Private transport helpers remain private.

The permanent consumers exercise: the non-involutive Fin 3
cycle with distinct masses/rows and joint/output/objective checks; one-sided
applications; stochastic processing and noninjective collapse;
and mixtures of maximizing laws, including weights 0 and 1. The last consumer
uses existing input concavity privately, without a public symmetry, convex-set
or optimizer framework.

The parent freshly read CT91 Section 2.8, printed 32–33 / PDF 54–55, and PW24
Theorem 5.3, printed 92–93 / PDF 117–118, through pypdf text extraction on
2026-10-24. Both hashes matched the registered editions. No fresh visual
inspection is claimed. These bounded adaptations use existing DPI for all-input
capacity bounds and existing concavity for the private maximizing-law consumer.

C22.02's corrected four-target build, focused and umbrella signature/axiom
probes, all nine documentation examples, static/generated checks and the full
compiled compatibility/trust audit passed on their recorded inputs. Independent
review assessed all three selected criteria as satisfied with no findings; the
parent reconciled those assessments against the source and evidence.
Current inventory is 759 declarations in 51 owners. The compiled audit confirms
the preserved 92 root exports and 94 reviewed simp names. Earlier producer and
consumer failures remain separate records from their successful corrections.
This is validation-ready status. Final source applicability and scoped closure
are established only by `.lit-review/setup/c22-02-completion-20261024.json`
when present, including fresh final static/scope checks and exact R-to-F
comparison. C22.03 onward has not started. C22.08 retains the separate cumulative
clean and current API-documentation milestone. See C22 notes sections 11–12.


Actual records under `.lit-review/setup/` retain `c22-02-producer-initial.json`
and `c22-02-focused-second.json` as failed attempts. The former exposed private
unused assumptions, a redundant tactic and identity-map normalization; the
latter compiled the producer and Shannon umbrella but rejected several consumer
finite-value/simplification proofs. No public contract or fixture was weakened.
`c22-02-focused-corrected.json` records the corrected four-target build.
`c22-02-signatures-20261024.json` retains fresh focused and umbrella checks of
all three public signatures and their permitted axioms, including independent
universes and the local target input instance without an extra public premise.
Documentation, static/scope and full-trust records retain their own actual outputs
and input applicability. The slow full audit overlapped independent source review under the lead's
procedural discretion, as in Step 1, and subsequently passed on the unchanged
Lean inputs. Every acceptance obligation remained required before closure. No clean build, current
doc-gen milestone, commit, publication or later-step execution is claimed.

## 12. C22.02 independent review and final applicability — 2026-10-24

The persistent independent reviewer returned an original source-bound STEP
report covering all three criteria, each SATISFIED, with no findings. The parent
independently reconciled the inverse row orientation and local input instance,
the all-input DPI proofs, and the permanent consumer coverage. No mathematical
source correction or normative plan change was needed after review.

The reviewer independently read CT91 PDF pages 54–55 and PW24 PDF pages 117–118,
verified both registered hashes, and rendered the relevant DPI and concavity
statements in memory to inspect the inequality glyphs. This reviewer evidence
is separate from the parent's fresh text-only reading recorded in section 11.

The original empty submission response remains UNCERTAIN. Delivery was confirmed
from the actual completed native report, which was retained before classification;
no blind resend or parent-authored replacement report was used. Reviewer evidence
retains its own actor, actual outputs and limits. The review was instructed
read-only source evaluation, not blind or OS-enforced isolation. Parent validation
and textbook readings remain distinct from reviewer-reported checks.

The successful full audit is retained in
`.lit-review/setup/c22-02-trust-initial.json`, with exact compiled-input identities
before and after the run. Final applicability checks compare those identities
with the actual final inputs and compare the final source with reviewed R.
Only canonical status/reference/notes and plan-editorial prose changes after R.
Fresh final static/scope checks cover that delta; retained focused, signature,
documentation and trust runs are reused only on unchanged applicable inputs and
are not called fresh reruns. The completion record named above owns actual F
and scoped closure. C22.03 remains unstarted; C22.08 keeps cumulative clean and
API-documentation qualification. No commit, push or publication is claimed.

## 13. C22.03 admission, implementation and proof advice — 2026-10-24

C22.01 and C22.02 are closed. Only C22.03 with review was admitted after
the parent verified Step 2's actual closure, its three satisfied criteria and all
276 captured source/environment entries plus HEAD/index. The selected work adds
product-capacity additivity, repeated-channel capacity and the arbitrary-block-input
nC bound, using the existing C18 actual-marginal inequality and independent-input
identity. Coordinate maximizing PMFs supply the lower witness. Index, input and
output universes remain independent; empty products and zero blocklength remain
within the contract.

The new focused owner imports ChannelCapacity and SemanticBridge.ProductChannel.
It joins only the full Shannon umbrella. Its private consumer joins Examples
and covers heterogeneous channels, supplied product/iid achievers, a genuinely
correlated duplicated-bit input with a strict capacity gap, singleton/empty
products, n=0/n=1 and the vacuous empty-base zero-word channel.

The conditional request was processed only after fresh exact predecessor
applicability. The actual intake is retained in `c22-03-user-request-20261024.json`,
`c22-03-precheck-20261024.json` and `c22-03-admission-result-20261024.json`
under `.lit-review/setup/`. Step 2's closure is
`de144ede51d44971b518ae7c4eb81477648033e2dbd2b73d9dbdbd809ec4c67e`.
This checks the completed predecessor; it does not rerun its validation.

Production reuses the C18 actual-marginal upper bound and finite-product/iid
identities, with C22.01's all-input bound and actual attaining PMFs. Private
witness reasoning suffices; no optimizer structure or additional public helper
is justified. The arbitrary-q memoryless endpoint takes W, n, then q, so the
blocklength binds q's type explicitly. This routine argument-order choice
does not alter the approved mathematical contract.

The parent freshly read PW24 Theorem 6.1(a) and Example 6.1, printed 106–107 /
PDF 131–132, and matched the registered SHA-256. Page 107 needed an explicit
UTF-8 rerun after console encoding failure. Text-only inspection is claimed.
The adaptation retains finite dependent alphabets, nats, empty products and
zero lengths, and treats product input as an attaining construction rather
than a necessary property of every maximizing input. No later example formula
or operational coding theorem is used.

C22.03's four-target producer/consumer and aggregate build, early focused and
umbrella signature/axiom probes, all nine documentation examples, static/generated
checks and the full compiled compatibility/trust audit passed on their recorded
inputs. Independent review assessed all four selected criteria as satisfied with
no findings; the parent reconciled those assessments against source and evidence.
Current inventory is 762 declarations in 52 owners. The compiled audit confirms
the preserved 92 root exports and 94 reviewed simp names. Earlier failed attempts
and successful corrections remain separate records.
This is validation-ready status. Final source applicability and scoped closure
are established only by `.lit-review/setup/c22-03-completion-20261024.json`
when present, including fresh final static/scope checks and exact R-to-F
comparison. C22.04 onward has not started. C22.08 retains the separate cumulative
clean and current API-documentation milestone. See C22 notes sections 13–14.

Actual records preserve three producer elaboration timeouts. An explicitly typed
intermediate objective function and separately converted inequalities, reusing
the existing C18 consumer proof structure, resolved these without raising the
heartbeat limit or changing the theorem. Consumer rewrites were similarly made
explicit where dependent enumeration instances prevented direct rewriting;
the fixtures and intended statements were preserved. A proposition-level local
instance used `let` to satisfy the retained style policy.

The first scope check detected line-ending normalization in the preexisting
project log. The parent restored the exact old bytes and retained only the new
entry; corrected scope checks pass. The first documentation attempt overlapped
the producer rebuild and encountered a temporarily absent Shannon object file.
The corrected run uses the completed stable producer and all nine examples pass.
These failures remain actual failed records, not passing evidence. The later
four-target build and early probes retain their own actual source identities.

The full audit overlapped independent source review under the lead's
procedural discretion, as in prior C22 steps, and subsequently passed on the
unchanged Lean inputs. Every acceptance obligation remained required before closure. No clean cumulative suite, current two-pass doc-gen,
commit, publication, or later-step execution is claimed.

## 14. C22.03 independent review and final applicability — 2026-10-24

The persistent independent reviewer returned an original source-bound STEP
report covering all four criteria, each SATISFIED, with no findings. The parent
independently reconciled the arbitrary-input marginal upper chain, the actual
coordinate-maximizer product witness, all-n capacity and arbitrary-input bounds,
and the permanent heterogeneous/correlated/empty/singleton/zero-one consumers.
No mathematical source correction or normative plan change was justified.

The reviewer freshly compiled the producer, all permanent consumers and umbrella
callers, inspected the three public signatures and allowed axioms, checked import
boundaries and selected source hashes, and passed the static contract. The
reviewer also read and visually inspected PW24 PDF 131–132 after verifying its
registered hash; this is distinct from the parent's text-only reading. Failed
reviewer checks caused by an interrupted batch, a missing command argument and
late Classical scope in a caller remain retained beside their passing replacements.
They were reviewer harness failures and required no repository source change.

The first native transmission contained one mistyped tooling inventory hash.
The parent interrupted it, preserved its real call/result and known mismatched
body, and retained the supported preflight refusal. The same frozen request was
then transmitted with the corrected hash. That corrected call returned empty;
its submission receipt remains UNCERTAIN, and delivery was confirmed from the
actual completed native report retained before classification. The known-body
correction is not represented as a first transmission or an acknowledgement.
No tool, journal, source snapshot or acceptance check was altered to bypass the
refusal. The reviewer retained the interrupted earlier batch as providing no
validation result. Review was read-only source evaluation, not blind or
OS-enforced isolation. Its original evidence, outputs and limits remain separate
from parent validation, source reasoning and the text-only reading in section 13.

The successful full audit is retained in
`.lit-review/setup/c22-03-trust-initial.json`, with exact compiled-input identities
before and after the run. Final applicability checks compare those identities
with actual final inputs and compare the final source with reviewed R. Only
canonical status/reference/notes and plan-editorial prose changes after R.
Fresh final static/scope checks cover that delta; retained focused, signature,
documentation and trust runs are reused only on unchanged applicable inputs and
are not called fresh reruns. The completion record named above owns actual F
and scoped closure. C22.04 remains unstarted; C22.08 keeps cumulative clean and
API-documentation qualification. No commit, push or publication is claimed.

## 15. C22.04 admission, implementation and proof advice — 2026-10-24

C22.01–C22.03 and their reviews are closed. Only C22.04 with review was
admitted after verifying Step 3's actual closure, all four satisfied criteria,
and all 278 final source/environment entries plus HEAD/index. The selected
standard-channel owner supplies noiseless capacity log(card A) and zero capacity
for an input-independent channel. Existing diagonal entropy and independent-joint
laws give the objectives for every input; the uniform noiseless law and every
constant-channel input attain the respective capacities.

The new owner imports only ChannelCapacity and joins the full Shannon umbrella.
Its private focused consumer joins Examples and checks actual uniform/pure
inputs, non-pure constant output, a sparse ternary input and singleton alphabets.
Input nonemptiness remains explicit where capacity is formed; a supplied output
law needs no additional output-nonempty hypothesis. No new channel wrapper is needed.

The actual conditional request, exact predecessor check and supported admission
are retained in `.lit-review/setup/c22-04-user-request-20261024.json`,
`c22-04-precheck-20261024.json` and `c22-04-admission-result-20261024.json`.
Step 3 closure is
`b1ca4d95bb9a149b9f3c44d7e955f6d337866798604a77f8bd0e3d704e73fdbb`;
this fresh applicability check does not rerun its earlier validation.

The parent read CT91 8.1.1 and 8.3 context at printed 184–185 and 190–191 /
PDF 206–207 and 212–213, verifying the registered hash. Only text extraction is
claimed. The binary example is generalized using existing finite entropy facts;
the constant-row result is derived from existing independent-joint semantics.
Neither source context nor notation introduces operational coding assertions.

Read-only producer and consumer probes showed that the existing ChannelCapacity
import closure suffices. StandardChannels, BinaryEntropy, Convexity and Units
imports are deferred until a later selected step actually needs them. The
generic constant theorem retains separate input/output universes; no selected
optimizer structure, noiseless/constant channel wrapper or new simp rule is needed.
These are routine implementation choices within the approved ownership boundary.

C22.04's final four-target producer/consumer and aggregate build, focused and
umbrella signature/axiom probes, all nine documentation examples, static/generated
checks and the full compiled compatibility/trust audit passed on their recorded
inputs. Independent review assessed all three selected criteria as satisfied with
no findings; the parent reconciled those assessments against source and evidence.
Current inventory is 764 declarations in 53 owners. The compiled audit confirms
the preserved 92 root exports and 94 reviewed simp names. The failed consumer
invocation, corrected probe and subsequent source builds remain separate records;
the parent proof refinement retains its own passing build evidence.
This is validation-ready status. Final source applicability and scoped closure
are established only by `.lit-review/setup/c22-04-completion-20261024.json`
when present, including fresh final static/scope checks and exact R-to-F
comparison. C22.05 onward has not started. C22.08 retains the separate cumulative
clean and current API-documentation milestone. See C22 notes sections 15–16.

After the first successful four-target build, the parent replaced the generic
nonnegativity lower bound in the constant-capacity proof with the core objective
bound applied directly to a pure input chosen from Nonempty A. This makes the
specified witness explicit in the public proof; it changes no statement or
assumption. The original passing source check/build and the refined passing
four-target build remain separate records. The latter qualifies the current source.

One consumer probe initially failed before elaboration because PowerShell did
not preserve a dotted Lean -D option without quoting. The corrected no-artifact
producer/consumer source probe passed; both actual outcomes and the original
merged-stream capture limitation remain recorded. The parent then compiled the
focused import and both aggregates against actual built artifacts. No source
proof failure, limit increase or acceptance-policy change was needed.

The full compiled audit and independent source review have both completed;
their actual results and applicability limits are recorded in section 16.
Every acceptance obligation remains required before closure. C22.08 retains the separate clean
routine and current two-pass API-documentation qualification; no commit,
publication or later-step execution is claimed.

## 16. C22.04 independent review and final applicability — 2026-10-24

The persistent independent reviewer returned an original source-bound STEP
report covering all three selected criteria, each SATISFIED, with no findings.
The parent reconciled the noiseless objective and universal bound, the actual
uniform attaining law, the constant-channel zero objective and explicit pure
witness, and the permanent non-pure-output, sparse and singleton consumers.
Consult the original retained report and criterion evidence for the reviewer's
actual checks, outputs and limitations; they remain separate from parent
validation and reasoning. The reviewer freshly compiled the producer and all
permanent consumers through stdin, checked public signatures and allowed axioms,
and passed corrected umbrella callers, static validation and selected source-hash
comparisons. The initial reviewer umbrella rewrite chain failed to match the
unreduced identity expression; applying the existing diagonal theorem with exact
resolved the harness issue without a repository edit. The original FAIL remains
retained separately and is not used as passing criterion evidence.

The reviewer independently extracted and visually inspected the selected CT91
pages at the registered PDF hash. That evidence is distinct from the parent's
text-only CT91 reading recorded in section 15. The reviewer did not claim the
then-pending full audit, a fresh maintained aggregate rebuild or documentation
example compilation; those remain separate actual parent checks.

The native submission returned empty, so its original receipt remains UNCERTAIN.
Delivery was confirmed from the actual completed native report, retained in full
before classification. No acknowledgement or second submission was invented.
The recorded provenance is cooperative, not cryptographic authentication; review
was read-only source evaluation, not blind or OS-enforced isolation.

Section 15 preserves the actual failed consumer invocation, corrected probe,
source builds and the parent's explicit-pure-witness proof refinement. Their
original outcomes and source identities are not replaced by this status text.

Before R, a bounded status edit clarified that independent-review overlap was
still planned. Request preparation correctly refused the earlier evidence as
stale after that edit. Fresh applicability evidence established the exact
one-line change and unchanged compiled inputs before request generation;
the earlier observations and refusal remain retained. No source snapshot,
tooling or acceptance check was altered to bypass that refusal.

The successful full audit is retained in
`.lit-review/setup/c22-04-trust-initial.json`, with identical compiled-input
identities before and after the run. Final applicability must compare those
identities with actual final inputs and compare final source F with reviewed R.
These canonical status/reference/notes and plan-editorial updates require fresh
final static/scope checks. Earlier focused, signature, documentation and trust
runs may be reused only on unchanged applicable inputs; reuse is not a fresh run.
This is validation-ready status. The actual F and scoped closure belong only to
`.lit-review/setup/c22-04-completion-20261024.json` when present, with its linked
final checks and exact source comparison. C22.05 remains unstarted; C22.08 keeps
cumulative clean and current API-documentation qualification. No commit, push
or publication is claimed.

## 17. C22.05 admission, implementation and proof advice — 2026-10-24

C22.01–C22.04 and their reviews are closed. Only C22.05 with review was
admitted after checking Step 4's actual closure, all three satisfied criteria,
all 280 final source/environment entries and HEAD/index. The BSC constructor
uses binaryMixture with crossover weight epsilon on the complemented bit.
The information owner proves the objective for every input, its universal bound,
capacity log 2 minus binary entropy, and direct uniform-input attainment.
The full closed parameter interval is retained, including crossover above one half.

Probability-only consumers check row masses and deterministic endpoints.
Focused information consumers exercise the public formulas at zero, one half
and one, an interior pure input, every-input zero attainment at one half, and
the biased input with true-mass 1/4 at crossover 3/4, whose output true-mass
is 5/8. No optimizer-uniqueness assertion or positive-mass premise is introduced.

The actual conditional request, predecessor applicability check and supported
admission are retained in `.lit-review/setup/c22-05-user-request-20261024.json`,
`c22-05-precheck-20261024.json` and `c22-05-admission-result-20261024.json`.
Step 4 closure is
`31896d768a0d25b41591170ab64b2bb365ab7de13b95d30db95d9baf7b194317`.
The fresh check preserves all 280 captured entries, environment and HEAD/index;
it does not rerun Step 4's earlier validation.

The parent reread CT91 8.1.4 at printed 186–187 / PDF 208–209 with adjacent
PDF 210 context, checking the registered hash. Only text inspection is claimed.
The source's bit expression is adapted to nats through the existing binEntropy
and finite entropy definitions. Information capacity remains distinct from any
operational channel coding theorem. The half-crossover degeneracy is explicit.

Existing binaryMixture fixes branch orientation; entropy_bool and the pinned
binEntropy symmetry identify row entropy. The public weighted-row MI formula
then yields the objective for all input PMFs. The uniform output calculation
and finite alphabet entropy bound give an actual witness and universal upper
bound. Exactly one raw constructor and three Shannon formulas are prescribed;
mass, row entropy and uniform-output helpers remain private. Probability stays
below Shannon; the focused information owner imports only the justified raw,
binary-entropy, core and weighted-row owners. BEC and Units remain later work.

C22.05's six-target producer/consumer and aggregate build, focused and
umbrella public signatures/axioms, all nine documentation examples, static/generated
checks and the full compiled compatibility/trust audit passed on recorded inputs.
The original independent review assessed all three criteria as satisfied with
no findings; the parent reconciled those assessments against source and evidence.
Current inventory is 768 declarations in 54 owners, with 92 root exports and
94 reviewed simp names preserved. Failed and stalled implementation probes
remain separate from the corrected source checks and successful final builds.
This is validation-ready status. Final source applicability and scoped closure
are established only by `.lit-review/setup/c22-05-completion-20261024.json`
when present, including fresh final static/scope checks and exact R-to-F
comparison. C22.06 onward has not started. C22.08 retains cumulative clean and
current two-pass API-documentation qualification. See C22 notes sections 17–18.

The first producer stdin probe failed at subtraction-toReal coercion and at
hash-command lint in its diagnostic appendix. The source repair uses the existing
`ENNReal.toReal_sub_of_le`; the appendix locally disables only hash-command lint
for its diagnostic prints. No project lint setting or theorem assumption changed.
The corrected source probe and parent producer build passed. Initial information
consumer probes exposed the inherited row failure, rational-bound coercions and
the representation of the half parameter. The corrected focused consumer passed,
and the final parent six-target build passed on the stable source.

An earlier PowerShell-piped consumer probe stalled before a Lean child was
observed and was terminated with exit 1. Its initial stdin text/source snapshot
was not retained, so it establishes no reusable proof evidence. That limitation
and the actual outcome remain in `c22-05-consumer-initial-stalled-20261024.json`.
Subsequent Python-wrapped source probes retain exact stdin, source hashes and
actual output. All failed probes remain separate from passing builds and are
listed in the private initial validation evidence. A support consistency check
also corrected the living summary's historical range through C22.04 before R.

## 18. C22.05 independent review and final applicability — 2026-10-24

The persistent bound reviewer received the complete neutral fixed-source request
for C22.05 through the installed collaboration transport. The genuine completed
native report was preserved before classification, then accepted and reconciled
through supported operations. All three original criterion assessments are
satisfied and the original finding list is empty. The parent separately checked
the raw crossover orientation, all-input objective/bound, explicit uniform witness
and direct public theorem, boundary degeneracies and biased public-interface
consumer. No mathematical, API or normative plan correction is justified by that
reconciliation. Native submission/delivery observations, original report and
parent decisions remain distinct durable records; no report is fabricated from
status summaries or an implementation transcript.

The reviewer freshly compiled both complete producers and both complete
permanent consumers through stdin with warnings as errors, checked the public
signatures and their allowed axioms, and compiled direct umbrella callers.
Fresh static validation and 23 selected source-hash comparisons passed. These
checks reused compiled dependencies; the report did not claim a fresh maintained
aggregate build, documentation-example compilation or full project trust audit.
Its relevant CT91 and PW24 readings support the crossover orientation and nats
adaptation, with the half-noise degeneracy explicitly preserved.

Reviewed source R: `f61e4362e26be05e000f04f6c6b265228ccd694886e14299ee799572f6b04d2e`.
Original accepted report capture: `ca2e98167ab7cc283eac897e64b764d8a7a38e4a8ca27bfb860fda33343f744e`.
The substantive parent reconciliation is retained in
`.lit-review/setup/c22-05-parent-reconciliation-20261024.json`.

The full parent compiled compatibility/trust audit completed successfully, with
identical before/after compiled-input identities. It is distinct from the
reviewer's own checks and from the earlier focused builds. The passing audit is
retained in `.lit-review/setup/c22-05-trust-initial.json` with SHA-256
`d5f18aebbbdce4d8b3809196376bcdc3902448aa86b460a16880a19736a70ac9`.

That audit rebuilt the maintained eight-target aggregate (3,135 jobs),
matched all 601 retained public signatures, checked the 54 supported module
imports and 768 public declarations, preserved 92 root exports and 94 reviewed
simp declarations, and audited all 3,758 project constants across 100 modules.
Only propext, Classical.choice and Quot.sound were used. These are actual
completed parent checks, separate from the reviewer's narrower verification.

Only eight canonical/reference/status/notes and plan-editorial documents are
updated after R. The Lean producers, permanent consumers, public inventory,
import policy, generated website artifacts, validator and pins stay fixed.
Fresh final static/scope checks and a complete R-to-final source comparison
remain required before F; retained compiled checks must match the final inputs.
The source captures all required prose before private closure, so no announcement
edit after F is needed. Actual completion is established by
`.lit-review/setup/c22-05-completion-20261024.json` when present, not by this
provisional status. C22.06 remains unstarted, and C22.08 retains the cumulative
clean/current API-documentation milestone. No commit or publication is claimed.

## 19. C22.06 admission, implementation and proof advice — 2026-10-24

C22.01–C22.05 and their reviews are closed. Only C22.06 with review was
admitted after verifying Step 5's actual closure, its three satisfied criteria,
all 282 final source/environment entries and HEAD/index. The BEC constructor
uses binaryMixture with erasure weight epsilon on none and transmission weight
one minus epsilon on some input. Its information objective is exactly
(1-epsilon) times input entropy for every Boolean law, and capacity is
(1-epsilon) times log 2 in nats, throughout the closed interval [0,1].

The focused consumer derives the actual uniform witness from the public
objective and capacity formulas with uniform entropy. Raw and information
consumers retain zero/full erasure, absent-symbol zeros, pure input and every-input
zero attainment at full erasure. The existing biased input at erasure 1/3
has output masses 1/3 at none, 1/6 at some true and 1/2 at some false;
its public objective gives (2/3) times input entropy. No probability division,
null-fiber assertion, positivity premise or optimizer uniqueness is introduced.

The actual conditional request and predecessor/admission checks are retained in
`.lit-review/setup/c22-06-user-request-20261024.json`,
`c22-06-precheck-20261024.json` and `c22-06-admission-result-20261024.json`.
Step 5 closure is
`c274e3c7715d7215e41851746ac79856b9409ff5571ecbc6d76f63c9df15b45e`.
All 282 final entries plus HEAD/index were freshly matched; this is applicability
of the completed predecessor evidence, not a rerun of its earlier validation.

The parent freshly read CT91 8.1.5 (PDF 209–210) and PW24 19.3 (BEC on PDF
405, adjacent context on 404–406) through text extraction at the registered
hashes. Only the BEC passages support this step; neighboring operational,
Z-channel and symmetry material does not expand scope. The canonical formula
corrects the missing erasure weight and retains every-input optimality at full
erasure. The source uses nats and asserts no operational coding theorem.

Existing binaryMixture fixes the erasure/transmission orientation. The Option
output entropy is computed from its actual three masses using entropy_eq_sum,
Fintype.sum_option, unconditional Real.negMulLog_mul and PMF.sum_toReal.
The weighted-row mutual-information identity cancels the binary erasure entropy,
leaving (1-epsilon) times input entropy. Multiplication of the alphabet bound
uses the nonnegativity supplied by epsilon at most one. The uniform Boolean
law supplies the matching lower bound. No new dependency, helper API, simp
attribute or separate BEC uniform-attainment export is needed.

On Bool, a law with proper support is pure. The pure-input consumer therefore
checks an explicit missing atom and its zero transmitted-symbol output mass,
as well as zero information at interior erasure. The biased non-pure input
reuses C22.05's actual quarter/three-quarter law. Its uniform witness consumer
uses public formulas and uniform entropy without unfolding the channel.

C22.06's six-target producer/consumer and aggregate build, focused and
umbrella public signatures/axioms, all nine documentation examples, static/generated
checks and the full compiled compatibility/trust audit passed on recorded inputs.
The original independent review assessed all three criteria as satisfied with
no findings; the parent reconciled those assessments against source and evidence.
Current inventory is 771 declarations in 54 owners, with 92 root exports and
94 reviewed simp names preserved. Failed and inconclusive implementation attempts
remain separate from the corrected source checks and successful final builds.
This is validation-ready status. Final source applicability and scoped closure
are established only by `.lit-review/setup/c22-06-completion-20261024.json`
when present, including fresh final static/scope checks and exact R-to-F
comparison. C22.07 onward has not started. C22.08 retains cumulative clean and
current two-pass API-documentation qualification. See C22 notes sections 19–20.

The initial producer check found only unused simp arguments, Ne.symm hb and
mul_ite. Removing those arguments preserved the theorem statements, proof
route and lint policy; the corrected package-option stdin check passed. The
first parent six-target build separately failed in the biased BEC output-mass
consumer because norm_num left Option constructor equalities unsimplified.
Its original command/output remains in c22-06-focused-final.json; subsequent
passing validation is recorded separately and does not relabel that failure.

Early producer and consumer feasibility checks encountered pre-Lean Lake waits
and short direct-compiler timeouts. Those records establish neither theorem
failure nor proof success. Consumer input/environment reconstruction and
retention-time hash observations, plus unavailable partial timeout streams,
remain explicitly qualified in the original records. Later source-bound checks
and parent maintained builds supply the actual passing evidence. No runtime,
dependency, theorem assumption or project lint configuration was changed.

A support documentation inspection caught a stale current closed-step range
and proposed edits inside historical C14 count paragraphs. The range was
corrected through C22.05 in the updater before use, and those historical count
edits were removed. Earlier source/history and unrelated work are preserved.

## 20. C22.06 independent review and final applicability — 2026-10-24

The accepted original independent report assesses all three C22.06 criteria as
satisfied and contains no findings. The parent agreed criterion by criterion
for the source-specific reasons retained in its separate reconciliation record.
The BEC source uses erasure weight epsilon on none, transmission weight one minus
epsilon on some input, and the all-input entropy objective on the full closed
interval. The specified uniform witness, endpoint degeneracies, explicit sparse
input and biased-input masses remain covered by the permanent focused consumers.
This step introduces no conditional-fiber assertion, probability division,
strict-positivity premise, optimizer-uniqueness claim or operational capacity
equality. No new mathematical correction or normative plan change is made by
this documentation update.

The following compact check summaries resolve the accepted report's verification
references to its original reviewer evidence. Methods, outcomes and limitations
come from those actual entries; full commands, outputs and report narrative stay
in the preserved private record. These reviewer checks, including any reuse or
inconclusive/failed observations recorded there, are distinct from the parent's
full audit below.

| Outcome | Reviewer-reported method | Limitations |
| --- | --- | --- |
| PASS | Verified the specifically authorized saved request's raw hash before reading; read every chunk and parsed the entire JSON. | Recovery verifies the authorized saved packet, not historical native transmission completeness. No other private workflow record was read. |
| PASS | Compared SHA-256 values against the recovered request before and after substantive checks. | This is a relevant-file applicability check, not independent recomputation of the complete 282-entry source capture or derived environment identity. |
| PASS | Inspected the actual raw constructor, its reused mixture implementation and permanent probability-only consumers. | Assessment is specific to the approved Boolean-input channel and its Option Bool output representation. |
| PASS | Reviewed the complete BEC proof chain against the normative contracts and exact reused declarations. | This establishes the intended finite-channel information-capacity calculation, not an operational channel-coding theorem or a replacement for complete compiled trust qualification. |
| PASS | Fresh hash verification and text extraction of exact local textbook pages, with in-memory visual inspection of the relevant displayed formulas. | Only the exact relevant textbook sections were assessed. Reference-register status claims were not used as validation evidence. No PDF files or rendered images were written. |
| PASS | Fresh warning-as-error stdin compilation of both complete producer files, followed by signature and axiom inspection appended to the capacity producer. | These runs freshly elaborate producer source but load existing compiled dependencies. They do not rebuild all dependencies or establish the complete retained-signature, import, simp and all-project axiom audit. |
| PASS | Inspected permanent interface consumers and freshly compiled both complete consumer files through stdin. | Focused consumers import existing compiled producer artifacts; those producers were separately re-elaborated from current source in reviewer:c22-06-producers. A pure Boolean law supplies the required sparse-input case. |
| PASS | Compiled an isolated public-interface consumer importing both maintained aggregate modules. | This checks aggregate importability and public composition against existing compiled imports; it is not a fresh maintained aggregate build. |
| PASS | Inspected source import closures, public inventories, generated declaration documentation, nearby APIs and relevant pinned-mathlib searches. | Closure counts are source-derived, not independently compiled environment-boundary audits. The consumer files' introductory prose still emphasizes earlier examples, but their explicit BEC sections and public-owner/generated documentation describe the added scope; this is not a material contract defect. |
| PASS | Ran the maintained non-mutating static release validator to completion. | Static success does not establish compiled compatibility, all-project trust, fresh compilation of documentation examples, a clean committed checkpoint, signature-bearing API documentation, publication readiness or workflow closure. The parent's required full exact-source qualification remains separate. |

Reviewed source R: `5116089ee35e39984640a036581542fe503c8e7d9f83e19c8e18146ff7b21a54`.
Original accepted report capture: `498a55d104eee12da50b1a41498b6575fa3843660d33bde7dd88e351e7ef45a8`.
The substantive parent reconciliation is retained in
`.lit-review/setup/c22-06-parent-reconciliation-20261024.json`.

The full parent compiled compatibility/trust audit completed successfully,
with identical before/after compiled-input identities matching the inputs
at this update. Its actual output records a completed maintained aggregate
build (3,135 jobs), 601 matching retained public
signatures, all 54 supported-module import probes and 771 public
declarations, 92 root exports and 94 reviewed simp declarations.
It audits 3,787 project constants across 100 modules. Only
propext, Classical.choice and Quot.sound occur in the reported axiom sets.
These counts are extracted from this completed audit, not inherited from
an earlier step. The actual passing record is
`.lit-review/setup/c22-06-trust-initial.json`, SHA-256
`07fd8c400b54c91246964c0440cac160fa2fb24ba055382e3f8f06469285f0c9`.

This update changes only the eight canonical/reference/status/notes and
plan-editorial documents. Earlier history and project-log entries are preserved;
the Lean producers, permanent consumers, imports, public inventory, generated
artifacts, policy, validator and pins are unchanged by this update. Failed and
inconclusive attempts retain their original evidence and limits in section 19.
Fresh final static/scope checks and the exact R-to-final comparison remain
required before F; retained compiled evidence must match the final inputs.
Actual completion is established only by
`.lit-review/setup/c22-06-completion-20261024.json` when present. This prose
records validation-ready status and does not itself close the step. C22.07
remains unstarted. C22.08 retains the cumulative clean routine and separately
authorized current two-pass API-documentation milestone. No commit or
publication is claimed.

## 21. C22.07 admission, bits and C23-facing consumers — 2026-10-24

C22.01–C22.06 and their reviews are closed. Only C22.07 with review was
admitted after verifying Step 6's actual closure, its three satisfied criteria,
all 282 final source/environment entries and HEAD/index. Four public `_bits`
equations now convert the existing standard-channel capacities with natsToBits:
log base 2 of the alphabet size for noiseless channels, zero for constant
channels, one minus converted binary entropy for BSC, and one minus epsilon
for BEC. Canonical information measures and channelCapacity remain in nats.

StandardChannelCapacity adds only the existing Units direct import, bringing
its production imports to five. The standard-capacity consumer additionally
imports ProductChannelCapacity for private product/repeated bits identities,
actual attaining laws and arbitrary-input/block bounds. The product-capacity
consumer retains its sole focused import. It applies the generic bounds to
arbitrary p and q and to a concrete noninjective encoder from Bool × Bool:
the encoder repeats the first coordinate, and its two-letter pushforward is
correlated. Zero- and one-letter cases are retained. No iid or injectivity
premise, channel-code abstraction or operational coding theorem is introduced.

The conditional request, predecessor applicability and admission are retained
in `.lit-review/setup/c22-07-user-request-20261024.json`,
`c22-07-precheck-20261024.json` and `c22-07-admission-result-20261024.json`.
All 282 Step 6 final source/environment entries plus HEAD/index matched before
admission. This establishes predecessor applicability rather than rerunning
the prior step's validation or selecting C22.08.

The fresh source-text record is `c22-07-reference-reading-20261024.json`.
CT91 printed 184 and 187–188 / PDF 206 and 209–210 supply the information
capacity and example-unit context. PW24 section 6.1, Theorem 6.1(a) and
Example 6.1, printed 106–107 / PDF 131–132, supply product additivity and
the strict-gap context. Both registered hashes were checked; this was text
extraction, not visual inspection. Operational passages do not expand scope.

The only production additions are channelCapacity_deterministicChannel_id_bits,
channelCapacity_const_bits, channelCapacity_binarySymmetricChannel_bits and
channelCapacity_binaryErasureChannel_bits. Their proofs rewrite the existing
nats formulas, unfold scalar conversion and use log 2 positivity where needed.
No theorem assumptions, old theorem bodies, root exports, simp attributes or
Units declarations change. Input and output universes remain independent;
the constant-channel equation requires no extra output-nonemptiness instance.
Both binary formulas retain the full closed parameter interval.

Private standard-channel consumers retain specified uniform/every-input
achievers, BSC zero/half/one and BEC zero/one endpoints, and degenerate
every-input attainment. They also convert product and repeated identities,
supplied product/iid witnesses and arbitrary p/q bounds, including n=0 and
n=1. Positivity of log 2 preserves inequality direction. ProductChannelCapacity
is added only to this example consumer's direct imports; production adds Units.

The focused C23-facing consumer applies both public capacity bounds without
unfolding channelCapacity or reproving a supremum argument. Its concrete
message law is the independent product of two fair Boolean laws. Repeating
the first coordinate gives a noninjective encoder for every block length;
at length two its pushforward is the already-proved correlated diagonal law.
The same public block bound applies, including zero and one letters. No
injectivity or iid-input premise, code abstraction, Fano argument or channel
coding theorem is introduced, and C23 itself has not started.

C22.07's focused producer/consumer and aggregate build, all 26 public
signature/axiom probes through focused imports and the full Shannon umbrella,
documentation-example checks, static/generated checks and the full compiled
compatibility/trust audit passed on the repaired recorded inputs. The fresh
original independent review assessed all three criteria as satisfied with no
findings on that repaired source; the parent
reconciled those assessments against source and evidence. Current inventory
is 775 declarations in 54 owners, with 92 root exports and 94 reviewed simp
names preserved. Failed implementation attempts remain separate from the
corrected source checks and successful maintained builds.
This is validation-ready status. Final source applicability and scoped closure
are established only by `.lit-review/setup/c22-07-completion-20261024.json`
when present, including fresh final static/scope checks and exact R-to-F
comparison. C22.08 has not started and retains the cumulative clean routine
and separately authorized current two-pass API-documentation qualification
and maintained handoff. C23 has not started. See C22 notes sections 21–22.

Initial validation is guarded by actual exit-zero records
`c22-07-focused-ready.json` and `c22-07-documentation-initial.json`, the
passing source-bound `c22-07-signatures-20261024.json`, and the generated
775/54 inventory. The producer's complete saved-source package-option stdin
check is `c22-07-producer-saved-source-20261024T110112-519c4c29.json`;
it passed without diagnostics and without producing Lean artifacts. Maintained
parent builds supply integration evidence separately.

The initial C23 in-memory probe failed with application type mismatches because
the untyped Boolean lambda parameter was grouped with the Fin 2 binder. Explicit
Bool and Fin 2 binders normalized the pushforward expression; the corrected
probe passed. The separate saved-source check with effective package lint
options also passed. The failed and corrected probes remain separately retained
in `c22-07-consumer-planning-failed-20261024.json` and
`c22-07-consumer-planning-corrected-20261024.json`; their stdin was reconstructed
at retention time from the unchanged original source and issued draft, as
their records state. Those preliminary probes used warnings as errors but
not every package option. The later saved-source record
`c22-07-consumer-saved-package-options-19c17637.json` supplies package-option
evidence. No unsuccessful attempt is relabelled as a passing check.

This initial documentation update preserves all earlier project-log bytes and
historical status blocks. Changes to the approved plan are confined to its
editorial status markers; the normative contracts and acceptance criteria are
unchanged. Full trust and the bound independent review passed and were reconciled;
fresh final applicability and the actual completion record still own closure. C22.08's cumulative qualification and maintained
handoff remain unstarted; clean-checkpoint and current API-documentation
permissions are separate.

## 22. C22.07 independent review and final applicability — 2026-10-24

The fresh accepted original independent report assesses all three C22.07 criteria
as satisfied on the repaired source and contains no findings. The parent agreed criterion by criterion
for the source-specific reasons retained in its separate reconciliation record.
The four public bits equations are scalar consequences of the existing nats
capacity formulas; Units remains unchanged. The producer's sole new direct
import is Units. Private standard-capacity consumers retain the specified achieving
laws, binary endpoints, product/repeated identities and arbitrary-input/block
bounds after positive scaling by the reciprocal of log 2. The product-capacity
consumer keeps its sole focused import and applies both generic public bounds
to arbitrary laws and a noninjective Bool × Bool encoder whose two-letter
pushforward is correlated, including zero- and one-letter cases. These
contracts require neither injectivity nor iid encoded words and introduce no
channel-code abstraction, Fano argument or operational coding theorem.
The four new public bits proof bodies were corrected before this update; their
statements, assumptions, Units, CodingRate, validator and pins are preserved.
No further mathematical correction or normative plan change is made by this
status update; C23 itself is not selected.

The following compact check summaries resolve the accepted report's verification
references to its original reviewer evidence. Methods, outcomes and limitations
come from those actual entries; full commands, outputs and report narrative stay
in the preserved private record. These reviewer checks, including any reuse or
inconclusive/failed observations recorded there, are distinct from the parent's
full audit below.

The initial full trust attempt is preserved separately in
`.lit-review/setup/c22-07-trust-initial.json`: exit 1 after all
601 retained public types matched. Its actual failure was the compiled
module/environment owner mismatch for natsToBase.eq_1. Read-only
metadata inspection found both natsToBase.eq_1 and natsToBits.eq_1
in CodingRate and StandardChannelCapacity module arrays, with CodingRate
as their full-environment owner. This was a duplicate lazy-equation
ownership failure, not a failed public mathematical statement.

A complete in-memory producer check replaced conversion unfolding in
the four new proof bodies with definitional `change` to the real quotient
formulas. The retained probe passed with package options and checked that
both lazy helpers were absent before and after elaboration. At this update,
the actual producer is required to match that tested correction; the
four public statements and preceding source remain exact. This no-artifact
probe supports the proof route; corrected maintained builds and the full
trust audit supply separate integration evidence. Metadata and probe records
remain `c22-07-ownership-diagnosis-20261024T114017-7c228a02.json` and
`c22-07-consumer-reduction-variant-2b72cc24.json`.

The ownership correction concerns the supported production modules.
The reviewer also observed generated unit equations in the non-stable
Examples environment; no global uniqueness claim is made across that
broader environment. The repaired production StandardChannelCapacity
module no longer declares the conflicting helpers.

The earlier accepted report assessed C22.07-API as CONTRADICTED_BY_FINDING
on source `019ceeb5d3f0cf5a7abf8b3c19ef5dc4117d2fe0a288617531a06b8efe1a9e2a`; its capture
`018cd4a01a0b8e31a9569f5bdf131d7ecacdd8f19ae4cc1bb6e977b8ba7d2b74` remains preserved. The fresh satisfactory
report below has its own original native capture and repaired source.
The earlier assessment and failed audit are not rewritten as passing
results. Only actual passing repaired records satisfy this update's guards.

| Outcome | Reviewer-reported method | Limitations |
| --- | --- | --- |
| PASS | Verified the authorized neutral packet's raw hash, read all 58,643 characters in chunks, parsed the complete JSON, checked request/attempt/source/binding identities, and checked scoped source hashes before and after verification. | Scoped hash verification is not universal semantic dependency analysis or authenticated provenance. Runtime profile settings beyond observable information are not asserted. |
| PASS | Reconstructed the previously reviewed producer entirely in memory using the current unchanged prefix and the previously inspected four proof bodies; compared its hash and the four exact public theorem headers. | This establishes the producer delta relative to the actually inspected prior file, not a claim about every repository change since HEAD. |
| PASS | Reassessed the repaired formulas against plan section 3.5, unchanged Units definitions, and the permanent scalar and attaining-law consumers. Refreshed the relevant consumer source directly. | Relevant earlier textbook comparison remains contextual evidence for unchanged statements; this correction review does not repeat an entire textbook or chunk audit. |
| PASS | Read the arbitrary-input interface consumer and concrete encoder proofs, including their correlation witness and boundary instantiations. | This is the specified finite-channel consumer contract, not implementation or qualification of C23. |
| PASS | Fresh isolated stdin compilation of the complete repaired producer and both complete permanent consumer sources; separate compiled signature inspection of all 26 C22 endpoints with universes enabled. | The reviewer wrote no Lean artifacts. Stdin compilation uses existing imported artifacts; their source applicability is separately supported by the completed maintained build/trust record. Compilation alone does not establish intended mathematical meaning. |
| PASS | Inspected Environment.getModuleIdxFor? and every imported ModuleData.constNames array for both generated unit-equation constants under focused, exact public-umbrella, and broader consumer imports. | PASS establishes removal of the original collision within the supported public boundary. It does not claim global uniqueness in non-stable Examples environments; the broader duplicate observation is expressly retained. |
| PASS | Reconciled endpoint inventory, exact supported imports/closures, generated line references, current policy, and unchanged boundary-checker behavior. | Supported-public ownership is distinct from non-stable Examples ownership. A broad print of public policy records exposed historical admission/status prose; those claims were not used as qualification evidence. No private parent assessments were consulted. |
| PASS | Ran the maintained non-mutating static validation entry point. | This static run is not a clean-tree release validation or the separately authorized API-documentation milestone. |
| PASS | Independently inspected the expressly authorized completed parent-run raw trust record and compatibility evidence; verified record/output hashes, exact input assembly, source applicability and dependency revisions. | The full trust command was run by the parent, not by this reviewer. Inspection establishes cooperative local evidence and exact recorded source applicability, not hostile-process isolation, a cold build, clean-tree validation, publication, or C22.08 closure. The all-project audit establishes its stated axiom property, not universal non-stable ownership uniqueness. |
| FAIL | Retained three failed assumptions in ad hoc read-only inspection commands and checked their corrections without changing source or validation policy. | Retained in verification for transparency and excluded from every SATISFIED criterion's passing-evidence list. They do not establish a source finding or alter the original historical failed trust result. |

Reviewed source R: `ab6903ae8020c8fb822f2ab4f03efcb039a69fdaec18e62d2ff157ab6fc0abbe`.
Original accepted report capture: `277f9bf0b5666eef41fe25dc29f0d558457de5b40432a7ddbc1b193b52868064`.
The substantive parent reconciliation is retained in
`.lit-review/setup/c22-07-repaired-parent-reconciliation-20261024.json`.

The full parent compiled compatibility/trust audit completed successfully,
with identical before/after compiled-input identities matching the inputs
at this update. Its actual output records a completed maintained aggregate
build (3,135 jobs), 601 matching retained public
signatures, all 54 supported-module import probes and 775 public
declarations, 92 root exports and 94 reviewed simp declarations.
It audits 3,815 project constants across 100 modules. Only
propext, Classical.choice and Quot.sound occur in the reported axiom sets.
These counts are extracted from this completed audit, not inherited from
an earlier step. The actual passing record is
`.lit-review/setup/c22-07-trust-repaired.json`, SHA-256
`6134ece0ceb648ddd79ea085088622bba74bbeef0171e7492b4a3535a9af3619`.

This update changes only the eight canonical/reference/status/notes and
plan-editorial documents. Earlier history and project-log entries are preserved;
the Lean producers, permanent consumers, imports, public inventory, generated
artifacts, policy, validator and pins are unchanged by this update. Failed and
inconclusive attempts retain their original evidence and limits in sections 21–22.
Fresh final static/scope checks and the exact R-to-final comparison remain
required before F; retained compiled evidence must match the final inputs.
Actual completion is established only by
`.lit-review/setup/c22-07-completion-20261024.json` when present. This prose
records validation-ready status and does not itself close the step or chunk.
C22.08 remains unstarted and retains the cumulative clean routine, separately
authorized current two-pass API-documentation milestone and maintained handoff.
C23 has not started. No commit or publication is claimed.

## 23. C22.08 cumulative preparation and authority boundary — 2026-10-24

Only the lead's conditional Step 8 request is admitted. Its fresh precheck
matched Step 7's actual closure, three satisfied criteria, all 282 final
source/environment entries and HEAD/index. The maintained
[handoff](../handoffs/chunk-22.md) records delivered contracts, all 26 exports,
exact focused imports/consumers, source departures, boundary assumptions,
prior evidence and C23's two required bounds. Canonical links and the current
API-documentation inspection contract were prepared before any approval request.

The support source-to-criterion matrix is a current implementation map, not a
formal cumulative verdict. Earlier original reports remain source-specific;
the initial C22.07 trust FAIL/API contradiction, proof-only correction, repaired
PASS and final finding disposition remain distinct. The supported-production
ownership repair does not assert global uniqueness in non-stable Examples.

One small documentary improvement was selected: the raw StandardChannels
consumer's top synopsis now describes its existing BEC checks as well as BSC.
The exact namespace body, declarations, imports and proofs are unchanged.
Its whole-file hash changes, so prior whole-file compiled identity is not
silently transferred; fresh focused validation and subsequent clean qualification
own that source. No new public helper, alias, theorem, import or simp rule is added.

Section 6 of the approved plan explicitly requires separate authorization for
the scoped local clean checkpoint and bounded amendments, and separately for
the current two-pass API-documentation gate. The concrete proposal is retained
under `.lit-review/setup/c22-08-checkpoint-proposal-20261024/` when present.
It excludes `.gitignore`, `AGENTS.md`, `docs/next-website-tasks.md` and the exact
pre-C22 relocation-log entry. Working intake bytes remain preserved. The inspected
registered validation checkout can be reused only after the actual approval and
fresh state checks. No checkpoint or API build is inferred from preparation.

Preparatory dirty checks and their source applicability are retained under
`.lit-review/setup/c22-08-*`; each actual record governs its command, actor,
outcome and limits. They are not the full clean routine or two-pass API milestone.
Initial-validation/readiness barriers and a neutral source-bound cumulative
review covering all 26 criteria remain after the required qualification. Final
canonical reconciliation, current evidence, R-to-F assessment and supported
private completion are still required before closure. C23 is not started;
operational capacity equality remains outside C22 and release follows C24.

## 24. C22.08 authorized milestone checks and cumulative readiness — 2026-10-24

The lead replied “Yes, i approve” to both concrete actions: the exact
26-path local checkpoint/bounded amendments/full clean runs in the existing
validation checkout, and the separately authorized two-pass local API gate
with reviewed Zig 0.16.0 and all 26 declaration inspections. The actual reply
and proposal hash are retained in c22-08-milestone-approval-20261024.json.
This continues the already admitted step; no new step selection was consumed.

The initial full clean routine and current API gate actually passed. The parent
read every rendered new signature, hypotheses, type, docstring, owner and source
link, preserving the explicit finite/nonempty domain, universes, arbitrary-law
and all-n scope, binary endpoints, BEC weights and scalar bits meanings. Actual
records retain source/configuration/dependency/attestation/output identity and
any failed attempts. Existing caches do not establish a cold build. File-mode
source links do not establish publication or GitHub line-range inspection.

Canonical qualification prose and the maintained handoff were updated within
the owned ten-document scope. Earlier log/notes bytes and normative plan are
preserved. The exact amended checkpoint must receive the complete routine
again and renewed API applicability before the cumulative request. Parent
source critique and separate reassessment, neutral current-source context,
genuine original report receipt, substantive reconciliation of all 26 criteria
and every report/finding, final qualification and supported closure retain
their distinct actual records. The actual completion record
`.lit-review/setup/c22-08-completion-20261024.json` and its linked evidence
determine their outcomes; this dated preparation note predicts none of them.
No mathematical endpoint, source proof, import, current/frozen API policy or
dependency pin changes. C23 remains unstarted, operational equality is excluded,
and release qualification remains after C24.
