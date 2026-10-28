# C24 — Programme integration and release qualification

<!-- lit-review-status:start -->
**Status:** Active revision 2, accepted by the lead on 2026-10-25.
C24.01–C24.08 and their reviews are closed. Step 8 closure is
`0a8cb9718db8a34debb56af451c40a7ee31eeef48f790f67354c51bbb461554e` at final source `4939e0ef8fc71640c056396750229903b17fa6756c4ba34164db43327fcaec91`.
Only C24.09 is admitted, at B `41aae06401a77b67c36d5766f85b4170c573b6d8e0838ce78da9bdd0f7b6df67`, for cumulative qualification
and the [maintained handoff](../handoffs/chunk-24.md). Final candidate checks,
all-27-criterion/all-216-row original review, reconciliation and closure are
established only by actual `.lit-review/setup/c24-09-completion-20261028.json` and linked evidence when present.
No future result, final commit or publication is predicted. The 1 GB publication
blocker, host-navigation duty and optional version-prose deferral remain explicit;
PFR wording/link approval remains pending. See [notes](post-release-chunk-24-notes.md).
<!-- lit-review-status:end -->

## 1. Authority and intended outcome

This is the final chunk of the [C9–C24 programme](post-release-chunk-map.md).
Its outcome is an independently reviewed, precisely identified **qualified
candidate**, with honest mathematical coverage and a usable handoff to the
separate second-release chat. Completion does not publish or begin release work.

Outside the marked status block, this document is proposed normative material.
After exact approval, keep it frozen; evolving implementation advice, evidence
locations and chronology belong in the separate notes. Material changes to
meaning, required scope, public contracts, acceptance policy or dependency pins
require a plan-health decision and the supported revision procedure.

Planning instructions authorize only this proposal and its revisions, its notes,
and necessary private planning/reviewer records. Later approval does not select a
step. Each eligible request selects exactly one ordered step with its review
process; close that step and stop. Formal PLAN review waits for an explicit
request. Local checkpoint commits/amendments, validation-checkout movement or
creation, expensive API milestones, pushes, tags, releases, Pages and DOI actions
retain their separate action boundaries below.

No new theorem programme belongs in C24. A demonstrated interface defect may
receive a bounded correction preserving its approved meaning, after recording
the evidence and affected earlier acceptance. A missing required theorem,
stronger assumption, weakened endpoint, architectural change, dependency upgrade
or substantive new mathematical result requires the lead's decision. Do not
close a required gap merely by labeling it deferred or by adding a count-filling
alias. Keep optional polish distinct from mandatory acceptance.

## 2. Entry conditions and immutable baseline

Before C24.01 admission, recheck the actual C23 completion record, its original
review and substantive all-criterion reconciliation, qualification inputs and
final source applicability. The planning intake identified:

- C23 checkpoint `b577679892f4db40cfad480e0f487184ed91d4d5`;
- `.lit-review/setup/c23-06-completion-20261025.json`, supported closure
  `cf7340dfd6da41da94058a8375e224d97f93bcb7e4a78e060a7481d480e47cdb`;
- C23 final source `5f8885ada621055b58a189b4d4346d92f2c9689506a14038e06524229d58c323`.

The notes distinguish the completed original chain from frozen pre-closure
wording in captured documents. Neither such wording nor a completion label alone
determines current applicability. New C24 planning files are intentional additions
after that intake, not evidence that historical C23 closure failed.

Compare against exact released commit
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, annotated `v0.1.0` tag object
`bcd9090ea2720fe14b0a3e168c76ebeef1dafd47`, the fulfilled
[release contract](../v0.1-release-contract.md),
[release notes](../releases/v0.1.0.md), frozen manifest and retained structural
contract. Do not rewrite the tag, release archive, historical CFF, frozen API
manifest, retained contract or `/docs/v0.1.0/` route to describe current source.
Preserve the distinction between locally verified Git identities, historical
publication evidence and fresh remote verification.

Retain Lean/mathlib `v4.33.1` and exact installed pins unless separately approved.
Preserve the lightweight root, PMF-valued channels, nats, half-L1 TV,
support-aware statements, null-fiber limits and guarded Real conversions of KL.
Topology, KL, coding, heavy semantics and examples remain outside the lightweight
root. Existing non-stable anchors remain non-stable.

Preserve all pre-existing dirty bytes and hunks. At intake these are `.gitignore`,
`AGENTS.md`, `docs/next-website-tasks.md` and `docs/project-log.md`. Later canonical
edits to mixed files must preserve unrelated hunks and record selective candidate
projections. No blanket staging, cleanup, reset or commit of user work is allowed.
Create no Desktop folder and modify no unrelated folder. Use only approved
repository-local ignored locations for auxiliary projects/checkouts.

`docs/next-website-tasks.md` is private working material for this task: never
include its current local edits in a GitHub-bound change. It is already tracked
and present in the local frozen release tree; `.gitignore` cannot retroactively
exclude tracked or historical bytes. Record this conflict honestly. Before any
later publication, require an explicit reviewed candidate-content decision that
keeps the local file and its edits private while preserving the immutable release.
No history rewrite, untracking or deletion is authorized by planning.

## 3. Programme acceptance ledger

During execution maintain a public, portable ledger, proposed path
`docs/qualification/c24-programme.md`, with private raw evidence under
`.lit-review/`. The ledger must map **every agreed mathematical endpoint and
cross-chunk contract from the approved C9–C23 plans**, including complementary
and growth-gate work. Derive its row inventory from those plans and handoffs;
do not replace this with a list of 210 new names or a favorable summary.

Use stable mathematical/interface row IDs `C24-E-Cxx-nn`, process/qualification
row IDs `C24-P-Cxx-nn`, and `C24-X-01` through `C24-X-06` for Section 3.2's
connections. C24.01 establishes a complete crosswalk from every relevant approved
C9–C23 criterion to these rows. Give historical/process-only criteria an explicit
provenance/applicability treatment rather than inventing a mathematical endpoint
or repeating their closure. Record optional/out-of-scope dispositions with their
original authority; do not omit a required criterion silently.

Split materially different hypotheses, witness/quantifier boundaries and consumer
obligations into separate rows. Related declarations may share a row only when
those boundaries and their evidence/disposition agree. Preserve established IDs;
record later splits, corrections or omissions explicitly against the approved
source requirement. The ledger elaborates the approved scope, not new obligations.

Each mathematical row must identify its approved criterion/reference; exact fully qualified
public declaration(s) and statement; universes, typeclasses, hypotheses, units,
quantifiers, edge cases and source adaptations; owning module and useful minimal
import; producer dependencies; an actual permanent consumer and the same objects
it supplies; historical evidence and source identity; fresh checks or justified
applicability; and a current disposition. Store full elaborated signatures in
linked exact-source evidence when too large for the readable ledger. Distinguish
public endpoints, upstream reuse, private machinery, aliases and consumer facts.
Process rows instead identify the maintained mechanism, required check, original
record and current applicability; they need not invent a public theorem/consumer.
Record evidence recency, outcome and build-cache use separately: a fresh check
may legitimately use incremental caches.

The independent report for each audit step must give a status, reason and evidence
for every ledger row in its scope, using `SATISFIED`, `NOT_ESTABLISHED` or
`CONTRADICTED_BY_FINDING`. Its original cumulative report must cover the complete
final row inventory as well as all C24 criteria. A linked original reviewer matrix
is acceptable; the parent cannot fill missing reviewer assessments. Freshly inspect
endpoint statements and important integrations; earlier proof reviews may supply
applicable supporting evidence without reopening historical closure records.

Inspect statements and important proof/use connections. Compiled compatibility
and axiom checks do not establish unchanged semantics by themselves. A bare
`#check`, import, declaration count, historical review or construction of an
unrelated witness cannot discharge mathematical consumer acceptance. Existing
meaningful consumers should be reused; add a private example only for a concrete
uncovered obligation, not to duplicate all existing proofs.

### 3.1 Required endpoint coverage

The following family inventory is a minimum coverage guide, not a replacement
for the approved-plan row inventory. Paths are relative to `LeanInfoTheory/`.

| Chunks | Required mathematical acceptance | Principal owners and permanent consumers |
| --- | --- | --- |
| C9 | Arbitrary-type deterministic independence processing; finite information decomposition with ordered conditioning; all six historical-preservation/current-growth/documentation gate obligations. | `Shannon/SemanticBridge/Independence`, `Shannon/InfoMeasures`; `Examples/IndependenceProcessing`, `InformationDecomposition`; compatibility qualification and fixtures. |
| C10 | Half-L1 TV, metric/event/test-function characterizations, overlap/residual and disjoint-support endpoints, map/common-channel contraction and equivalence invariance; correct constants for bounded versus signed tests. | `Probability/TotalVariation`; `Examples/TotalVariation`, `TotalVariationChannels`. |
| C11–C12 | Exact coupling marginals, maximal disagreement equality without positivity/full-support assumptions; map/bind transport; support-local extension equality; finite adjacent-law Markov gluing with honest null-fiber behavior. | `Probability/Coupling`, `FiniteChannel`, `Shannon/SemanticBridge/Gluing`; coupling, Fano, transport and gluing examples, including nonmaximal glued endpoint. |
| C13 | ENNReal Pinsker, correctly guarded Real/square-root consequences and quantitative joint-versus-own-product independence; singular KL and signed-test boundaries. | `Shannon/SemanticBridge/Pinsker`; `Examples/Pinsker`, `QuantitativeIndependence`. |
| C14 | Exact-TV entropy-difference bound, capped monotone budget modulus, conditional entropy and MI bounds, singleton/saturation/null-fiber cases; no new general sharpness/equality classification or unrestricted conditional-law continuity claim. | `Shannon/Continuity`; `Examples/Continuity`, using actual maximal couplings and Fano. |
| C15 | Finite simplex topology/compactness, coordinate/TV convergence equivalence, probability-map and information continuity, continuous actual channel-MI objective with boundary laws. | `Probability/FiniteTopology`, `TotalVariationTopology`, `Shannon/Topology`; topology and channel-optimization examples. |
| C16 | Dependent finite products and iid laws, support/masses/marginals, empty/pure products, injective restrictions, reindexing, ordered concatenation, distinct-pair and family-independence bridges. | `Probability/FiniteProduct`, `Iid`, `Shannon/SemanticBridge/FiniteProduct`; product, iid and semantic examples. |
| C17 | Raw product/memoryless channels, conditional rows, ordered composition and deterministic reduction; arbitrary-input marginals/restrictions and independent-input whole-law factorization. | `Probability/ProductChannel`; elementary and semantic product-channel examples, including correlated outputs, collisions and null rows. |
| C18 | Product/iid entropy and ENNReal KL including infinity; guarded Real KL; arbitrary-input conditional-output entropy and exact MI gap/subadditivity/equality; independent-input MI additivity and independent-source observation bounds. | Product/family semantic bridges; `Examples/FiniteProductSemantics`, `IidInformation`, `ProductKL`, `ProductChannelInformation`, `FiniteFamilyInformation`. |
| C19 | Supported block self-information, varying-space finite-iid AEP, strict support-aware typical sets, atom and cardinality bounds, probability tending to one; positive width/length and off-support limits. | `Shannon/SemanticBridge/AEP`, `Shannon/TypicalSet`; `Examples/AEP`, `TypicalSet`. |
| C20 | Total deterministic fixed-length codes, the existing error event, success-set cardinality and same-witness construction, arbitrary-law one-shot success bounds; natural budgets, shared nats rate, rounding and binary-length conversions. | `Shannon/Fano`, `SourceCoding`, `CodingRate`; code/rate/typical-set consumers. |
| C21 | One-family above-entropy achievability; below-entropy source strong converse; arbitrary-family vanishing-error necessary rate bounds; entropy as `IsGLB` threshold. Preserve witness-before-tolerances order and avoid exact-rate-H attainment or bounded/convergent-rate assumptions. | `Shannon/SourceCodingAsymptotic`; its permanent package, sparse compression, pure/singleton, oscillation and finite-prefix consumers. |
| C22 | Attained finite-channel information capacity on nonempty input domains, alphabet and processing bounds, arbitrary correlated-input product upper bounds and attained product/repeated equality; noiseless, independent-output, BSC and BEC values and actual achievers. | `Shannon/ChannelCapacity`, `ProductChannelCapacity`, `StandardChannelCapacity`, `Probability/StandardChannels`; corresponding four examples. |
| C23 | Actual uniform-message code laws/error and Markov/DPI; all-length undivided Fano converse, guarded normalized/pointwise forms; derived-boundedness eventual/real-limsup bounds; distinct eventual and frequent positive-gap obstructions. | `Shannon/ChannelCode`, `ChannelCoding`, `ChannelCodingAsymptotic`; actual-code examples including unequal fibers, correlated collisions, nonconvergent lossless rates and unbounded intermittent spikes. |

### 3.2 Required producer–consumer connections

1. **C11 to C14:** the actual maximal joint, its exact marginals and its swap
   supply both Fano applications and identity-decoder error equal to TV.
   Preserve equal-law, singleton and sparse boundary consumers.
2. **C16 to C18:** dependent product law/restriction/reindexing and existing
   family-law independence agree on the same coordinates. Probability constructors
   do not acquire Shannon imports; test both minimal and semantic directions.
3. **C16 to C19:** supported product-log additivity, coordinate laws and actual
   iid independence/integrability feed the probability argument. No off-support
   logarithm identity or fixed probability-space fiction is substituted.
4. **C19/C20 to C21:** the same strict typical set, atom/cardinality estimates,
   selected-set code, positive natural budget, actual success/error law and
   one-shot bound produce one asymptotic code family. Check sparse and zero-entropy
   sources, rounding, quantifier order and arbitrary-rate converses.
5. **C15/C17/C18 to C22:** compactness and continuity maximize the actual channel
   MI objective. The upper product bound applies to arbitrary correlated input
   via its actual marginals; the lower bound uses genuine coordinate maximizers.
6. **C17/C20/C18/C22 to C23:** the encoder pushforward need not be uniform or iid.
   Its exact code law, existing decoding error, Markov/DPI, repeated-channel
   capacity bound, uniform-message Fano and shared `codeRate` compose on the
   same code/family. Derived eventual boundedness precedes the real-limsup step.

For each connection retain source locations, a substantive explanation of the
composition, boundary/adversarial consumers and actual compiled evidence. This
audits useful mathematics, not only declaration availability.

## 4. Scope, comparison and candidate contract

### 4.1 Honest comparison

Prepare a baseline-versus-candidate account of substantive families, assumptions,
imports, compatibility, limitations and any separately approved migration.
The first release excluded TV/Pinsker/continuity/topology, AEP/typicality, coding
theorems and capacity; the programme supplies the bounded families in Section 3.
Separate information-capacity attainment from an operational coding theorem.

At planning intake the manifests contain 601 versus 811 names: +210, about 35%,
with 31 versus 57 supported owners and unchanged 92 root exports/94 reviewed simp
names. Recompute at the actual candidate and classify growth meaningfully.
These counts neither prove semantic compatibility nor meet the historical
rough-doubling estimate. Report that difference; no filler or extra theorem family
is authorized to repair a numerical estimate.

**Channel-coding achievability, operational channel-capacity equality and the
channel strong converse remain outside this programme.** The C21 source strong
converse is not a channel strong converse. General maximal-error equivalence,
randomized/list decoding, feedback, costs, infinite alphabets, variable/prefix
coding, stationary/ergodic AEP and the other map exclusions remain excluded.
Existential source encoders are not claimed to be efficient executable algorithms.

### 4.2 Proposed version and documentation arrangement — approval required

Recommend **`v0.2.0` as the next release target**, retaining all historical public
contracts. A minor version is not permission to break them. During C24 use an
explicit unpublished candidate state tied to an exact checkpoint; no existing or
future tag, release date or DOI is invented. Candidate package metadata may carry
`0.2.0` only with the reviewed state-aware documentation/validation contract.

Prepare a separate **candidate retained API baseline for the complete supported
surface**, currently 811 declarations, not only the historical 601. It must retain
exact elaborated types, ordered universes and binder information, source/compiled
kinds, ownership, focused/root import contracts, root aliases and reviewed
attributes including focused/umbrella simp membership. Bind it to the actual
mathematical inputs, exporter, toolchain and dependencies. Reuse the existing
structural representation where suitable; rendered HTML and source inventory
alone are insufficient. Keep the immutable v0.1.0 baseline and its checks intact.

C24.04 prepares the bounded exporter/checker extension and capture contract;
C24.07 establishes the reviewed complete candidate snapshot and qualifies the
clean checkpoint containing it; C24.09 compares the final surface against it.
Include an isolated unchanged positive control and a negative regression in which
a post-v0.1.0 declaration keeps its name/owner/count, compiles and exports with a
changed signature, and is then rejected by the retained-type comparison with a
declaration-specific structural diagnostic. A compiler failure or stale-inventory
rejection alone does not satisfy that regression. Regeneration cannot approve drift.
Any justified baseline revision requires explicit source/diff/review evidence.
The release contract must state compatibility expectations for the complete
v0.2.x surface. Final immutable release binding belongs to the release chat after
its exact candidate is qualified; no general multi-version framework is required.

Candidate baseline inputs must not include the artifact's own output or containing
commit hash recursively. Record the actual export-source checkpoint and relevant
input fingerprint separately from the later checkpoint containing the artifact;
check correspondence against the final candidate and include new checker/artifact
inputs in validation identities. Attach full qualified commit/tree identities
through separate completion evidence. The current
historical checker also compares `lakefile.toml` with v0.1.0: allow only the exact
reviewed package-version metadata projection for the new candidate state, with
negative tests retaining unchanged Lean options, toolchain and dependency pins.
Do not weaken the historical path or alter its retained artifact to permit a bump.

Proposed routes under the existing `/LeanInfoTheory/` project subpath:

- `/docs/v0.1.0/`: immutable historical API, exact release checkout and digest.
- `/docs/current/`: clearly labeled development/candidate API, independently bound
  to its current source, configuration, dependencies, manifest and link mode.
- `/docs/` remains the documentation landing; its stable-release choice continues
  to identify released `v0.1.0` until separately authorized publication.
- `/docs/v0.2.0/`: reserved for the later immutable approved release. C24 may
  prepare and test isolated staging for that route, but must not advertise it as
  released, deploy it or switch a stable pointer.

The candidate/current route and historical route must have separate manifests,
source identities and attestations. Reject current output in the historical route,
stale body/docstring inputs, mismatched versions/commits, machine-local links in
publishable output and unsupported source-link targets. Keep preview artifacts
marked `NOT_FOR_PUBLICATION`. Use existing site design and navigation patterns.
Provide a local nonpublishing staging mode for an approved clean exact-commit
checkout, including a detached validation checkout. It must not require invented
CI environment variables or relax publication mode's branch/identity/authority
checks; test that local candidate staging cannot authorize deployment.

Existing validators/staging hardcode first-release metadata and routing. Review a
bounded state-aware extension rather than globally replacing `0.1.0`. Preserve
historical validation, manual Pages defaults (`publish=false`) and the absent
automatic tag/release workflow. Do not create a general hosting framework.

### 4.3 Documentation, citation and case-study duties

Prepare candidate release notes, installation/import examples, scope/migration
notes, citation/metadata consistency and current website coverage. Keep stable
installation valid; candidate instructions pin an actual locally available commit
or explicitly describe local checkout use. A not-yet-pushed SHA or nonexistent
tag cannot be advertised as remotely installable. Verify examples as external
package use where claimed. Clearly label prospective post-publication commands.

Preserve Apache-2.0, EPFL rights-holder, sole creator and MIL affiliation as
established by the legal/metadata contract. Do not reuse the first version's DOI
or date as candidate metadata. Candidate citations must be honestly unpublished;
historical release citations retain their issued identifiers. Final date, new
version DOI, archive and public metadata submission belong to the release chat.

Treat a scoped **PFR case-study summary as planned release content awaiting
wording approval**, separately from optional broader outreach. The supplied
advisory report relays the lead's subsequent publication of PFR's repository and
website; do not treat the older assessment's privacy warning as current public
status. During C24.05 verify the relevant public project documentation/links and
record their observed scope. This revision records reported context, not fresh
remote verification.

Retain the existing assessment and its limits: its recorded PFR checkpoint uses
unchanged LeanInfoTheory `v0.1.0`. It supplies historical downstream-use evidence,
not candidate compatibility, a fresh full build or coverage of every manuscript/
algorithm claim. Distinguish public project material, the new summary requiring
wording/link approval, and private assessment evidence requiring separate disclosure
authority. Do not publish private records or change PFR/ShannonCert source,
dependencies or visibility. Minimal contributor guidance remains optional only
if broader outreach is selected; it is not a C24 completion criterion by default.

## 5. Evidence and validation contract

Every result records actor, exact source/checkpoint/tree and dirty projection,
command/method, input/configuration/dependency identities, actual output/exit,
artifact identity, cache/link mode, applicability and limits. Keep four classes
separate: fresh checks; applicable earlier evidence; failed attempts or
timeouts; unverified claims. A retry does not erase failure; a marker repair is
not a successful full gate. Warm/incremental checks are not cold rebuilds.

Use the installed validator and obtain its current target list at execution:

```text
python scripts/validate_release.py targets
python scripts/validate_release.py focused <affected owners and permanent consumers>
python scripts/validate_release.py static
python scripts/validate_release.py documentation
python scripts/validate_release.py compatibility
python scripts/validate_release.py trust
python scripts/validate_release.py
python scripts/validate_release.py api-docs
```

Focused/static/documentation checks serve dirty iterations; select targeted
tooling tests for changed release, API, staging, compatibility and safety contracts.
At a fixed checkpoint, avoid redundant separate trust/compatibility runs when the
complete routine already supplies the same exact checks. Serialize Lean and
doc-gen artifact-producing operations and preserve diagnostics.

Use this division of current checks and historical applicability:

| Work | Required treatment |
| --- | --- |
| C24.01–C24.03 endpoint/integration rows | Fresh statement and same-object use inspection, relevant focused consumer/import compilation and current static checks; retain source-bound prior proof evidence and explicit limits. |
| Historical C9 growth/closeout obligations | Map all six gate obligations to maintained mechanisms and original evidence; assess applicability without replaying old workflow closure or repeating every unchanged historical fixture. |
| C24.04 version/baseline/staging changes | Run the positive/negative tests for every affected mechanism, including new-type drift and narrow version projection; requalify affected C9 gate evidence even when no Lean theorem changes. |
| C24.07 and final amendments | Complete maintained clean routine and full candidate-baseline comparison; do not reuse an earlier clean pass for an amended candidate. |
| C24.08 and final API applicability | Fresh two-pass candidate gate, exhaustive contract coverage under the reuse rule below, and exact artifact/mode correspondence; rerun invalidated gates. |

The maintained routine must cover the default build, all eight maintained targets
with warnings as errors, all maintained README/guide examples, source/trust gates,
all retained types and supported names/imports/owners/root exports/simp attributes,
exact current inventory and direct imports, all-project axiom audit, generated
reference checks, metadata/documentation/site checks and clean hygiene. Allow only
`propext`, `Classical.choice`, `Quot.sound`. Do not weaken a gate to pass a candidate.

The **clean checkpoint milestone** requires a separate concrete approval of exact
paths/hunks, excluded dirty work, checkpoint mechanism and validation location.
Prefer a suitable registered checkout under `.worktrees/` after inspection; no
new checkout or Git mutation is inferred from this plan. Retain primary-byte to
committed/validation-byte correspondence, including justified line endings and
mixed-log projection. Supply the reviewer with a path/hunk manifest relating the
actual captured bytes to the clean candidate, identifying every exclusion and why
it cannot affect the claimed candidate. State exactly which bytes were reviewed
and compiled; cleanliness alone is insufficient. The full routine reruns after
every candidate amendment.

The **API milestone** requires separate explicit approval. Run the complete
two-pass signature-bearing gate with pinned doc-gen4 and reviewed Windows Zig
0.16.0 through `LEANINFOTHEORY_ZIG`. Use **file mode for C24's local milestone**;
GitHub-mode generation and live link verification belong to the later separately
authorized release work. Record source-content fingerprints, configuration,
dependencies, output digests and both pass results. Maintain exhaustive substantive
inspection coverage for all programme-added rendered public contracts (currently
210), plus changed retained contracts and representative root/umbrella/owner
navigation: signatures, assumptions, docstrings, simp markup, ownership and links.

A prior substantive inspection may discharge an unchanged contract's coverage
when its original inspection is retained and its current rendered content, owner,
semantic source/dependency inputs and source-link meaning are explicitly matched.
The fresh candidate gate must validate the current generation/checking environment.
Every changed or unmatched contract requires fresh substantive inspection; neither
sampling nor an inventory count fills a gap. Mark reused inspections as reused.

For the historical route, prefer an available frozen artifact only after verifying
its exact release identity, applicable two-pass attestation, digest and link mode.
If unavailable or invalidated, include a separate exact-release rebuild in the
concrete API milestone approval proposal. Local reuse does not remove the existing
publication workflow's frozen-route rebuild/check requirements.

Any signature, proof/body, docstring, source-link mode, configuration, tool or
dependency change requires an applicability assessment. Rerun invalidated gates;
preserve valid incremental caches. Documentation-only amendments still require
the full clean routine, while API reuse requires explicit evidence that all its
inputs and relevant output remain applicable. No check on C23 or an earlier C24
candidate automatically qualifies the final candidate.

### External consumer

Use a separate minimal Lake package in an approved ignored location inside this
repository, depending on the exact candidate commit via a local Git URL/ref if
the commit is not public. Record the resolved manifest revision, toolchain,
dependency cleanliness and physical module origins. Clear inherited `LEAN_PATH`
and show the package does not accidentally import the primary working checkout.
Label local-Git or path-dependency evidence accurately; remote-installation claims
wait for actual remote availability. No PFR/ShannonCert checkout is modified.

Maintain reviewable fixture source/recipe (proposed
`tests/external-consumer/`) separately from disposable artifacts. Parameterize the
recipe by candidate SHA supplied at execution; retain its resolved manifest in
the evidence rather than embedding its containing commit into tracked files.
Compile actual
public theorem applications across coupling/continuity, product/correlated MI,
same-family source coding, attained/standard capacity and the weak converse,
plus one retained-baseline use. Put root-only, focused-import and full-umbrella
checks in separate modules so a broader import cannot mask the narrower contract.
Do not rely on project-private examples or count `#check` as a mathematical
application. Record discovery friction without automatically adding aliases.

Resolve/materialize and compile the exact final candidate SHA. Every change to
candidate SHA, fixture or relevant configuration/dependencies requires re-pinning
as applicable and a new consumer compilation; valid incremental caches are allowed.
Reuse an earlier run only when all those identities, including the candidate SHA,
are unchanged. Substantive source inspection may remain applicable across a
documentation-only amendment, but it cannot replace compilation of the new SHA.

## 6. Ordered implementation steps

All steps require the Section 7 review cycle, explicit source scope and actual
evidence. Dependencies are the preceding closed step and its source applicability,
plus the named external approval where stated. Proposed output paths may be
adjusted editorially in notes if scope/ownership is unchanged; new public contracts
and acceptance requirements cannot be altered that way.

Keep nine steps. Within the largest audits use these bounded work sections, each
with its own ledger coverage and validation references:

| Step | Audit sections within its single review cycle |
| --- | --- |
| C24.01 | Entry/frozen baseline; complete criterion-to-row inventory; C9 helpers and six gate mechanisms; C10–C12 TV/coupling/gluing; C13–C15 quantitative bounds/topology. |
| C24.02 | C16–C17 raw product/channel laws; C18 information semantics; C19 AEP/typicality; C20–C21 operational source coding. |
| C24.03 | C22 attainment/product/standard capacities; C23 actual-code converse interfaces; six-connection and whole-programme reconciliation. |

These sections are not new step IDs or automatic separate review rounds. One
successful compiled invocation may serve several rows when it covers their actual
consumers. If a discovered gap makes a step incoherent, seek a plan-health decision;
do not split or advance it silently. Maintain factual canonical status during the
responsible steps, preserving historical evidence and unrelated hunks. Start the
handoff outline with documentation preparation and populate it as evidence arrives;
C24.09 reconciles and finalizes it before capture rather than beginning it from scratch.

<a id="c24-01"></a>
### C24.01 — predecessor, baseline and quantitative-package acceptance

**Dependencies:** exact plan approval and a request for C24.01. **Scope:** C23
completion evidence; approved C9–C15 plans/handoffs; frozen/current contracts;
quantitative owners/consumers; the new programme ledger, notes and bounded current-
status pointers. No broad
documentation rewrite or candidate version change.

- **C24.01-ENTRY:** Establish actual C23 closure and current-source applicability from originals, reconciliation and qualification; preserve frozen v0.1.0 identities and all unrelated dirty work, explicitly distinguishing historical wording from current evidence.
- **C24.01-COVERAGE:** Build the complete stable criterion-to-ledger crosswalk for C9–C23 and substantively qualify its C9–C15 rows, distinguishing mathematical endpoints from historical/process obligations and covering all C9 complementary/growth obligations and the actual coupling-to-Fano-to-continuity connection with its edge cases.
- **C24.01-EVIDENCE:** Compile the relevant existing permanent consumers and focused imports, check current static/compatibility boundaries as applicable, and record exact statements, sources, gaps and limits without declaring future rows satisfied.

**Required evidence:** linked completion/original hash checks and applicability;
exact baseline/current inventory; row-coverage crosswalk to approved plans;
quantitative source/dependency inspection; focused command output and dirty-state
preservation. Uncovered required mathematics triggers escalation, not filler.

<a id="c24-02"></a>
### C24.02 — products, AEP and complete source-coding integration

**Dependencies:** C24.01 closed. **Scope:** C16–C21 producers/consumers, relevant
pinned probability facts, references and ledger rows. This step does not reprove
the programme or enlarge the API.

- **C24.02-PRODUCT:** Qualify every C16–C18 endpoint, including dependent transport, minimal constructor imports, finite/infinite KL distinctions, correlated-input MI and independent-source observation bounds on the actual laws.
- **C24.02-SOURCE:** Qualify every C19–C21 endpoint and the same-typical-set/code/error/rate chain, retaining supported log identities, strict typicality, rounding, one-family quantifiers, source strong converse and IsGLB semantics.
- **C24.02-CONSUMERS:** Exercise permanent sparse, singleton, empty-index/zero-length, correlated, oscillatory and finite-prefix consumers through supported imports; reconcile reference adaptations and every uncovered interface obligation with source-bound evidence.

**Required evidence:** actual producer-use traces for Section 3.2 connections
2–4; exact statements and approved criterion crosswalk; compiled permanent
consumers and focused boundaries; recorded CT91/PW24 editions/adaptations and
remaining dispositions. Read exact registered source sections again where an
interpretation is disputed; do not pretend register reading is fresh PDF review.

<a id="c24-03"></a>
### C24.03 — capacity, weak converse and honest programme comparison

**Dependencies:** C24.02 closed. **Scope:** C22–C23 producers/consumers, all six
integration contracts, first-release comparison and programme ledger.

- **C24.03-CHANNEL:** Qualify attained actual finite-channel capacity, product/repeated capacity on arbitrary inputs, all four standard channels and the complete same-code weak-converse interfaces with their exact finite/asymptotic hypotheses.
- **C24.03-INTEGRATION:** Close all six producer–consumer rows using actual source and permanent consumers; preserve derived real-limsup boundedness, unequal encoder fibers, correlated inputs and the separating eventual/frequent examples.
- **C24.03-SCOPE:** Complete the C9–C23 acceptance crosswalk and a substantive first-release comparison, classify actual growth and compatibility/migration evidence, and explicitly retain the programme exclusions without claiming a doubling or operational channel-capacity equality.

**Required evidence:** source applications of compactness/continuity, actual-q
single-letterization and Fano; compiled standard/boundary/adversarial consumers;
all-row disposition inventory; baseline diff with semantic review and historical
contract checks. Keep required unresolved gaps blocking unless the lead explicitly
revises the approved programme claim.

<a id="c24-04"></a>
### C24.04 — candidate/version and API-routing contract implementation

**Dependencies:** C24.03 closed; exact approval of Section 4.2's version/routes.
**Scope:** proposed `docs/v0.2-release-contract.md`, bounded candidate retained-
baseline exporter/checker, validator/API/staging and website-checker changes,
associated tests and publication-content proposal.

- **C24.04-CONTRACT:** Implement the approved unpublished candidate identity and compatibility policy, the complete-candidate retained-baseline capture/comparison mechanism, narrow package-version projection, explicit metadata states, migration disposition and distinct current/stable/frozen documentation identities; retain all historical baseline protections, Lean options and dependency pins.
- **C24.04-ROUTES:** Implement and test isolated current/candidate staging from an exact clean checkout including local detached validation, and later-version reservation, while preserving exact v0.1.0 routing, digest and source boundaries; keep stable at the released version and publication disabled without weakening publication guards.
- **C24.04-SAFETY:** Demonstrate unchanged positive controls and rejection of a compiling post-v0.1.0 signature mutation, unapproved configuration drift, stale/swapped artifacts, changed historical output, invalid metadata/source links and automatic publication; document an exact future candidate-content treatment for the tracked private website-task file without changing its local bytes or historical release.

**Required evidence:** concrete state/route contract, targeted tests and static
checks, baseline artifact hashes and safety/workflow diff. Package version/date/
DOI checks must distinguish candidate from released state; global constant
replacement or weakening the first-release gate is unacceptable. This step may
prepare exact Git-content proposals but does not itself authorize commits/pushes.

<a id="c24-05"></a>
### C24.05 — release-facing documentation and metadata preparation

**Dependencies:** C24.04 closed. **Scope:** draft `docs/releases/v0.2.0.md`,
README/install examples, candidate package/citation metadata, API guide,
existing website coverage/navigation, planned PFR summary, handoff outline and
relevant generated references.

- **C24.05-DOCS:** Prepare accurate candidate release notes and installation/import examples tied to actual available identities, stating additions, retained compatibility or approved migration, units, assumptions, limitations and unreleased status without advertising a nonexistent public artifact.
- **C24.05-METADATA:** Reconcile package, citation, legal/provenance, README and site metadata under the approved candidate contract; preserve historical identifiers and leave final publication date, version DOI and stable-pointer transition explicitly unexecuted.
- **C24.05-COVERAGE:** Update existing website coverage and generated references without redesign; verify relevant public PFR references and prepare its scoped case-study summary for wording/link approval, distinguishing the historical v0.1.0 dependency evidence from candidate use and keeping private assessment disclosure and optional outreach separate.

**Required evidence:** documentation validator and all maintained example outputs;
source-derived non-mutating checks after deliberate regeneration where needed;
bounded site/link checks and local visual inspection of changed navigation/pages;
metadata matrix and PFR provenance/limits. Do not change PFR or ShannonCert.
If reported public material cannot be verified or approved wording is pending,
retain the draft, exact limitation and release-thread approval obligation; do not
silently drop the planned summary or assert unavailable public evidence.

<a id="c24-06"></a>
### C24.06 — external-package candidate use

**Dependencies:** C24.05 closed; separate exact local checkpoint/location approval
before any commit or validation-checkout change. **Scope:** external-consumer
fixture/recipe, ignored execution project and its exact candidate dependency.

- **C24.06-IDENTITY:** Establish a separate external Lake package resolved to the authorized exact candidate commit through a parameterized recipe, recording toolchain, manifest, clean pins and physical module origins with inherited LEAN_PATH removed and no downstream-project mutation.
- **C24.06-USE:** Compile meaningful supported-API applications for every external-consumer family required in Section 5, plus retained use and separate root-only, focused-import and full-umbrella modules, without relying on non-stable example-private helpers.
- **C24.06-REPRODUCIBILITY:** Retain reproducible fixture sources, commands, results and discovery-friction dispositions; distinguish local dependency success from remote installation and bind later reuse to candidate-input applicability.

**Required evidence:** reviewed concrete checkpoint projection/approval; external
manifest/commit and origin checks; actual successful compiler output; private raw
logs and portable instructions. Fix a concrete fixture mistake within scope;
escalate a changed library meaning or newly required theorem.

<a id="c24-07"></a>
### C24.07 — complete maintained clean-candidate qualification

**Dependencies:** C24.06 closed; separate exact checkpoint/amendment/location
approval. **Scope:** complete candidate, maintained suite, external fixture and
portable/private qualification evidence.

- **C24.07-CANDIDATE:** Establish and review the full candidate retained API baseline with exact export-source provenance, then establish the clean committed candidate containing it and its validation/review-source correspondence, including selective dirty-hunk exclusions, preserved local work, tool/pin identities and the approved private-file publication boundary.
- **C24.07-GATES:** Pass the entire maintained routine and compare the candidate against both the preserved historical and reviewed complete-candidate retained baselines, with no weakened trust, compatibility, import, root, simp, generated-reference, example, documentation, metadata, site or hygiene gate; retain all failed attempts and actual cache limits.
- **C24.07-EXTERNAL:** Resolve and compile the external consumer against this exact candidate SHA under Section 5, rerunning after any SHA, fixture or relevant configuration/dependency change, and record a precise coverage/limitations report without publication claims.

**Required evidence:** exact candidate manifest/projection; before/after clean
state; complete routine command/exit/log; immutable baseline checks; external
result correspondence. Repeat the full routine after every amendment. Pending
clean qualification is a blocker to this step, not a pass with a future promise.

<a id="c24-08"></a>
### C24.08 — signature-bearing API and documentation artifact qualification

**Dependencies:** C24.07 closed; separate expensive API milestone approval.
**Scope:** pinned isolated docbuild, all programme-added public rendered contracts,
candidate/current/historical staging, relevant link and navigation evidence.

- **C24.08-API:** Complete the actual two-pass file-mode API gate on the identified candidate, retain exact source/configuration/dependency/output attestations, and provide exhaustive substantive coverage for every programme-added rendered contract and any changed retained contract, using only the explicit per-contract inspection-reuse rule in Section 5.
- **C24.08-ARTIFACTS:** Validate separate current/candidate and frozen historical API artifacts and route composition, source-link modes, root/owner navigation and changed-page visual behavior, verifying historical-artifact reuse or a separately approved rebuild; preserve v0.1.0 bytes and keep all staging local/unpublished.
- **C24.08-LIMITS:** Record fresh versus applicable prior inspections, all failures, cached-build limits and unavailable remote-link/publication checks, with invalidated evidence rerun and no count-only or sampling substitute for required coverage.

**Required evidence:** two actual pass outputs; rendered inspection ledger;
artifact digests/mode/source matrix; staging/checker outputs and local visual
evidence. Any source/tool amendment triggers clean rerun and API applicability
assessment before this step closes; a failed API attempt is not completion.

<a id="c24-09"></a>
### C24.09 — final cumulative qualification and second-release handoff

**Dependencies:** C24.01–C24.08 closed; final amendments/checkpoint/API reruns
separately authorized where necessary. **Scope:** every C24 criterion, complete
programme ledger, canonical status/documents, qualification and handoff.

- **C24.09-READINESS:** Before cumulative dispatch, reconcile every prior accepted report and finding at its actual source, finish owned canonical/document/handoff edits, retain initial validation, contextual self-review and separate reassessment, and prepare an exact neutral matrix of all C24 criteria and programme endpoint dispositions.
- **C24.09-QUALIFICATION:** Qualify the final candidate after canonical amendments with the entire clean routine, both retained-baseline comparisons, external-consumer compilation at its exact SHA and valid API/artifact evidence, retaining exact source identities and rerunning invalidated milestones without promoting failures or historical labels to current success.
- **C24.09-HANDOFF:** Finalize docs/handoffs/chunk-24.md and canonical pointers before final capture, recording actual accepted scope, APIs/imports/consumers, compatibility, artifact/provenance identities, evidence limits, remaining-work owners/triggers, PFR summary/wording disposition and a concrete second-release handoff with explicit post-C24 requalification duties and separate release authority.

**Required evidence:** final all-criterion matrix; current checkpoint/clean/API/
external/artifact evidence; updated living summary, current Lean state, roadmap,
project log and applicable reference/Future Work dispositions; maintained handoff;
fresh original independent cumulative review and substantive reconciliation.
Reconcile current statuses without deleting dated historical evidence or
rewriting earlier source-bound closure records.

After readiness obtain a fresh source-bound report from the same reviewer on
**all C24 criteria and the complete final ledger row inventory**, including
readiness, validation, documents and handoff. Unchanged rows may cite the same
reviewer's earlier source-bound assessments with an explicit current-applicability
reason; every row still needs an assessment in the original cumulative matrix.
Reconcile every original assessment and finding substantively. A reviewer gap or
contradiction needs a satisfactory new reviewer assessment; parent agreement or
a clean report elsewhere cannot override it. Complete corrections, final checks,
R-to-F applicability and supported private closure. Never predict review success
or add a captured-file completion claim after F.

The release handoff and its accompanying private completion record must identify
the qualified commit/tree and approved plan, source captures, mathematical/
compatibility ledgers, exact validation logs, candidate retained-baseline digest
and export-source identity, external fixture revision/resolved dependency, current
API source fingerprint/mode/digest, frozen API release/digest and site-composition
identity. Keep actual outcomes distinct from intended publication transitions.
Finalize the tracked handoff prose before its checkpoint/F; put the resulting
commit/F/closure identities in the supported private completion evidence, reached
through its documented conditional pointer, without editing captured files again.

Its unexecuted checklist covers
final date/version metadata, public SHA availability and remote CI, any further
checkpoint/amendment, push, tag, GitHub Release, versioned site/stable switch,
Pages, final retained-baseline release binding, PFR wording/link approval and
DOI/archive verification. Refresh context for the separate release chat only when
the user requests it; do not message it or transfer this reviewer.

The handoff must carry this **post-C24 requalification rule**. C24 acceptance stays
attached to its actual qualified identity; the release chat records later changes
and new evidence without rebinding old closure or artifact records.

| Later change | Required qualification before claiming the changed release candidate is ready |
| --- | --- |
| Any final source/metadata amendment producing a new candidate | Run the complete maintained clean suite and both retained-baseline comparisons on the resulting candidate; resolve/compile the external consumer at its exact SHA, with valid incremental caches allowed. |
| API generation inputs, source-link mode or relevant documentation artifacts | Reassess exact input/output applicability; rerun the invalidated API/artifact gates. Generate and verify publishable GitHub-mode links against the actual clean public commit before publication, rather than treating C24 file-mode evidence as sufficient. |
| Mathematical/API/import/assumption change or dependency-pin change | Obtain required explicit approval, validate affected producers/consumers and both API contracts, and obtain renewed appropriate independent review in addition to the clean/artifact duties. Do not normalize or regenerate away a compatibility change. |
| Unchanged-source publication/site transition | Recheck commit/tag/artifact identities, route composition, stable-pointer targets and publication guards; execute only separately authorized actions and retain their actual outcomes. Source mutation invokes the rows above. |

Publication must identify the **actual final qualified commit**, not inherit a
readiness claim from an earlier SHA. Freezing the new release baseline binds the
verified full surface to that identity while preserving the historical baseline.

## 7. Review, capture and completion discipline

Use [review protocol](../review-protocol.md) and
[operations](../review-operations.md) as installed. The actual C24 parent owns
`/root/c24_reviewer` through the explicitly bound `collaboration` transport.
The original native creation requested `gpt-6-astra`, `ultra`, `fork_turns="none"`;
effective settings remain unknown unless observed. Read-only instructions are
cooperative restrictions, not OS isolation. No other chunk's binding is reused.

For an explicitly requested plan review use a fresh `plan-*` session, the exact
proposal hash and complete normative criteria/read instructions. Reconcile its
original report; the result awaits exact lead approval and starts no step.
For execution record exact approved plan hash, ordered IDs, criterion excerpts,
source references, scope and required evidence through the supported API.

For each selected step distinguish B, R and F. Scope actual owning modules,
important consumers, pinned declarations, configuration, policies and applicable
documents; include relevant dirty/untracked bytes and deletions. Imports are not
inferred by the capture helper. Private review records, builds and reference media
remain outside source capture. Retain read-only self-review and separate
reassessment before independent dispatch, with all required validation and owned
edits complete. Send a neutral source-bound request with the complete library
rubric, no parent transcripts/verdicts and no expected findings.

Persist dispatch intent and genuine native send results. Dispatch later idle
reviews with `collaboration.followup_task`; preserve the actual completed
`collaboration.list_agents` result and exact extracted original text. A bootstrap
acknowledgement is not formal review. Never manufacture task/status wrappers or
substitute a reviewer silently. Preserve all originals, failures, reconciliation
obligations and uncertainty; use supported state operations only.

Finish canonical documents and handoff before F with closure-conditional wording.
Assess R-to-F changes; material invalidation requires renewed review and affected
qualification. Supported closure establishes only the selected step, and the final
step only the qualified C24 candidate. Report exact outcome and limitations, then
stop. No subsequent step, release action or other chat work is automatic.

## 8. Decisions requested

1. Approve or revise this exact nine-step plan and its evidence/consumer contracts;
   formal plan review remains a separately requested action before execution.
2. Approve or revise `v0.2.0` as the target, `/docs/current/` as explicitly current,
   stable remaining `v0.1.0` until publication, and later immutable `v0.2.0` routing.
3. Confirm the forward-looking private-file treatment: preserve local website-task
   content, exclude new private changes from GitHub-bound work, and decide its
   future candidate-tree exclusion explicitly without rewriting frozen history.

Broader outreach remains unselected. The PFR summary is planned content whose
exact wording/links need approval; private assessment disclosure and publication
remain separate actions. Exact clean checkpoint and expensive API approvals will
be requested only with concrete reviewable proposals at their steps; approving
this plan does not grant those actions or publication.
