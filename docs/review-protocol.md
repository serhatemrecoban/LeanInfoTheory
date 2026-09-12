# LeanInfoTheory supervised review protocol

This document owns the installed review rules, not mathematical approval, a live
chunk binding, or unattended readiness. Helpers live in `tools/lit_review/`;
ignored private records live in `.lit-review/`. See [operations](review-operations.md).
Installation does not approve the proposed [C9--C24 map](plans/post-release-chunk-map.md),
begin C9 planning, implement growth gates, or reopen completed Chunks 1--8.

## 1. Invocation and discretion

Opt in with an implementation request **with review** or an explicit plan-review
request. Ordinary discussion, inspection, and reviewer work do not recursively
invoke the workflow. Python records and checks state; the implementation agent
makes native calls. There is no coordinator, scheduler, or next-step generator.

One eligible message authorizes one approved step: implementation and validation,
contextual self-review, separate reassessment and justified improvements, neutral
independent review, evidence-based reconciliation/corrections, final validation,
documentation, scoped closure, and a concise report. Then stop.

Use judgment on routine Lean/tooling problems, proof routes, organization, and
in-scope plan details. Retain the reasons and actual reviewed records; keep evolving
proof advice separate from frozen requirements. Advisory changes alone do not need
new user approval. Improve or safely restore only owned changes, decline optional
advice with reasons, and ask the same reviewer neutral clarification as needed.
Reassess plan health when discoveries affect later steps. Mathematical meaning,
required scope, important public contracts, acceptance policy, or dependency-pin
changes require the lead. Never weaken a theorem, strengthen assumptions for
convenience, alter approval records, hide evidence, or endanger unrelated work.
Unsupported exceptional recovery stops honestly with the unresolved references.
Review completion authorizes no commit, push, publication, or later step/chunk.

## 2. Conditional messages

For "Do step N+1 with its review process if step N and its review process are
completed," evaluate the condition **when the message is processed**. Before
invoking `next`, resolve the named target and predecessor to exact approved-plan
IDs; compare them with the current session, ordered next step, durable predecessor
closure, and source applicability. The helper does not parse arbitrary English.
Never silently substitute another target or cross a plan/chunk boundary.

Inspect active/incomplete, pending, blocked, failed, suspended, source-diverged,
paused, or cancelled work. An unfinished/blocked prerequisite consumes and skips
the conditional request without starting its target, retrying the predecessor, or
clearing a blocker. A consumed skip never revives. A still-unprocessed message may
become eligible after separately authorized continuation actually closes the
predecessor. Preserve explicit pause/cancellation and one step per eligible message.
No queue drain, batch, re-arming ceremony, or internally generated request is needed.

Retain native message references when exposed; otherwise label a local capture ID.
Do not derive identity from repeated wording or invent backend IDs. Identifiable
redelivery keeps its disposition; conflicting identity/content refuses. Do not
claim exactly-once native delivery or actual desktop queue testing from fixtures.

## 3. Source and library review

Read root `AGENTS.md`, the [living-summary quick start](lean-info-theory-living-summary.md),
the exact plan and criteria, relevant [reference-register](references.md) entries
and textbook sections, and targeted project-log/Future Work Notes. Inspect actual
owning Lean modules, direct imports, reused pinned mathlib declarations, and
important consumers. Current source/builds establish implementation facts; approved
plans and explicit lead decisions establish intent. Report conflicts and limits.
PFR/ShannonCert may supply authorized downstream use cases, not an invitation to
edit them or import application semantics into this library.

Self-review, independent plan/step review, and cumulative closeout use this rubric:

- Mathematical meaning and proof integrity; canonical nats, `PMF` laws and
  pushforwards, explicit source departures, and no proof placeholders.
- Reuse of existing LeanInfoTheory and pinned mathlib declarations before local
  alternatives; verify search candidates rather than guessing names.
- Appropriate generality and explicit assumptions: support, null fibers,
  empty/singleton alphabets, `Finite`/`Fintype`, finite/infinite KL and `ENNReal.top`.
- Namespace/module ownership, focused imports, the lightweight root, and separation
  of probability constructions/lightweight algebra from heavy Shannon semantics.
- Naming consistency and discoverability against nearby public APIs.
- Public/private helper boundaries, useful theorem forms, argument conventions,
  coordinate orientation, and justified, terminating simp attributes.
- Compatibility of retained declarations/imports, assumptions and semantics; no
  unrelated naming migration or downstream application-specific ownership.
- Permanent consumers/examples exercising actual producer-consumer interfaces,
  not only isolated definition compilation.
- Applicable canonical documentation, generated-reference, and validation duties.

Concrete usefulness and approved scope govern the API: do not require maximum
abstraction, every symmetric wrapper, or more public declarations for appearance.
No finding is required; distinguish optional advice from material correctness/API
problems, and severity from confidence. Plan review assesses feasibility/contracts,
not nonexistent completed proofs. The request renderer must directly include this
library rubric and relevant document-reading instructions, not merely link an
unused policy page. Inspect the rendered request for completeness and neutrality.

Declare justified capture scope, including relevant dirty/untracked files,
configuration, dependencies and documents; preserve unrelated changes. Keep **B**,
the actual step baseline, distinct from changes since HEAD; **R**, reviewed source,
distinct from **F**, final corrected source. Record omissions/impact uncertainty:
the adapter is not an import oracle or semantic Markdown parser. Never invent
missing snapshots, production plans, environment facts, or retrospective reviews.

For each check retain actor, source, command/method, actual result, and limitations.
Separate fresh checks, applicable earlier evidence, reviewer-reported checks, and
unavailable evidence. A compiler pass proves Lean acceptance, not intended meaning;
structural evidence validity does not establish mathematical interpretation.

## 4. Self-review and independent reviewer

Self-review is read-only inspection by the implementation assistant, not an
impersonated independent reviewer. Retain the critique before corrections, with
stable finding IDs, claim/location, evidence/uncertainty, materiality, separate
severity/confidence, current/earlier/unrelated attribution, and handling trade-offs.
Separately reassess every recommendation: apply, investigate, defer with trigger,
reject with reason, or escalate. Self-authorship is not evidence of correctness.
Initial review preparation **and dispatch** require this retained critique,
reassessment, applicable validation, finished owned edits and supported dispositions.
Material concerns need resolution/refutation; optional advice may be declined.

Each actual C9--C24 implementation parent binds its own persistent reviewer for
plan review, steps, and cumulative closeout. GeneralAssistant/support identities
cannot own chunk bindings. Installation creates no C9 binding and transfers no
PFR/diagnostic reviewer. Requested profile: `gpt-6-astra`, `ultra`, parent-history
copying disabled via the actual exposed creation call: legacy
`multi_agent_v1.spawn_agent(..., fork_context=false)` or explicitly bound
`collaboration.spawn_agent(..., fork_turns="none")`. Record the returned canonical
reviewer handle (`agent_id` or `task_name`) and originating parent identity, not a display name;
reuse the reviewer's own history without copying implementation conversation or
self-review verdicts. Do not silently replace a missing reviewer.

Requested and observable effective settings are separate; unknown stays unknown.
Cooperative read-only instructions/source checks are not OS isolation or proof of
initialization settings. These disclosed limits are accepted for initial use, not
wrong identity, demonstrated leakage/source damage, or unresolved material issues.
See the [official subagent documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents)
for the platform boundary; the exposed native schema governs actual calls. The
explicit transport remains fixed in the original binding. Its adapter checks the
corresponding genuine result format; adapting presentation never manufactures origin
or relaxes request/source/criterion/reconciliation requirements.

Send a self-contained neutral request: unique request/attempt/kind and binding,
fixed scope/non-goals, exact source identity/access, criterion IDs/descriptions,
normative plan/reference anchors, required dependencies/evidence, rubric/read
instructions, and report format. Separate normative excerpts from verdicts in
mixed documents; factual observations need provenance. Do not forward transcripts,
assessment objects or expected defects. Refresh source and prior findings each time;
the reviewer's history is useful context, not assumed current truth.
Request one consolidated original report with scope/limits, findings and evidence,
earlier reconciliation, exact checks/results, criterion assessments and conclusion.
Review permits read-only checks/isolated probes, not fixes, document/plan/dependency
edits, delegation, commits, or new steps. A report is evidence, never authority.

## 5. Delivery, original reports, and findings

Persist exact request and dispatch intent before sending. Preserve complete native
results as acknowledged, uncertain, or failed. Empty immediate results are
**UNCERTAIN**, not a reason for blind resend. Pending/progress/wait signals are not
reports. Retain raw results and correlation before fallible classification, with
actual origin metadata, extraction method and original body; a summary is not an
original. Do not fabricate `task_name`, `FINAL_ANSWER`, or wait wrappers. Genuine
events from the bound runtime remain original evidence; use only the corresponding
supported extractor described in operations. Preserve unknown or absent fields.

A correctly correlated original response may separately establish delivery without
rewriting the uncertain receipt. Check binding, sender/recipient where observable,
request/attempt/kind, source and restrictions. Body identity assertions do not
replace observed origin. Delivery is not acceptance, reconciliation, or completion.
Partial, wrong-source, conflicting, cancelled and unclassified arrivals remain
non-success records; identical duplicates are harmless, conflicting originals block.
Valid late reports may be retained without authorizing resumption/acceptance.

Lossless presentation normalization requires retained originals and an explicit
mapping. Prose `earlier_reconciliation` becomes one verbatim derived list item;
lists stay unchanged. This adds no provenance, disposition or criterion evidence.
Never fill a substantive gap with fabricated evidence. A negative report may be
accepted **as a report**: source-attributed FAIL remains FAIL, not SATISFIED or
passing final validation. Keep reviewer checks, implementer reruns and decisions separate.

Every accepted report, including a clean one, requires exact durable reconciliation
of its findings and original criterion assessments. A later report, empty finding
list, retry, pointer change, suspension or release cannot discharge older obligations.
Retain stable finding identities, appearances, original labels and all disposition
history. Accept alternative fixes/refutations when evidenced; optional decline/defer
needs reasons/trigger. Material concerns need adequate resolution/refutation or a
lead decision; materiality downgrade needs specific lead authority. Reassessment
reopens disposition. Report affected earlier acceptance without rewriting certificates.

Required criteria are `SATISFIED`, `CONTRADICTED_BY_FINDING`, or `NOT_ESTABLISHED`.
**Unchanged criterion-gap policy:** a reviewer gap/contradiction requires a new
satisfactory reviewer assessment. Implementer satisfaction, fresh evidence alone,
no findings, or a bounded-correction label cannot override it.

One consolidated review is the default, not a round cap. Additional productive
review names a question/risk, linked findings, fresh request/attempt, current source
and expected evidence. Only after a valid initial handoff and accepted/reconciled
report may an independently reopened stable finding remain OPEN during a linked
targeted review. Preserve the initial exit snapshot, independent reopening episode,
and intervening history; every report need not repeat an unchanged OPEN finding.
A resolved episode does not license later implementer-only reopening. Recheck
validation, finished edits, context and barriers at preparation and dispatch; the
concern still blocks closure. Repeated non-progress, material dispute or incompatible
requirements needs the lead, not automatic rounds. Durable substantive obligations
survive recovery, restoration, reclassification, favorable reports and pause/release.
Continuation, deferred-report acceptance and unaccepted-request retry are distinct;
unsupported adjudication/rebasing or historical-closure reopening must stop.

## 6. Final step, closure, and storage

Every detailed plan reserves its **final step** for cumulative validation and fresh
independent review against all approved chunk criteria, canonical reconciliation,
remaining-work dispositions, and `docs/handoffs/chunk-N.md` (for C9, `chunk-9.md`).
The maintained handoff records delivered results/public APIs, useful imports and
consumers, design/naming decisions, source/review references, limitations, deferred
items and next-chunk prerequisites/decisions. Link it from canonical context.
Preparing context neither approves/starts the next chunk nor transfers its reviewer.

Finish all required source/document/handoff edits **before F**, with status such as
"validation ready; closure subject to the private completion record." Validate
affected source/consumers and assess R-to-F applicability; material invalidation
requires renewed review. Closure checks exact F, criteria, every accepted-report
reconciliation, findings, validation, documents, unfinished edits and authority.
Only the supported private completion mechanism establishes closure; record its
actual reference there and in the user report, not by post-F captured-file edits.
Before closure use supported refresh/revalidation if needed. Reusing earlier checks
requires explicit source/configuration/dependency applicability and limits.

Keep `.lit-review/` outside source capture and ordinary scratch cleanup: originals,
checks, findings, critique/reassessment, source references and journal state are
durable private evidence. Use one writer and supported revision/journal operations;
never reconstruct corrupt/uncertain state favorably. Hashes/cooperative storage
checks are not authentication, hostile-process isolation, or backup guarantees.
Do not store credentials, reference PDFs or unnecessary conversation exports.
Historical Chunks 1--8 retain existing acceptance records, not synthetic workflow
closures. Fixtures/replays never become library acceptance. Report the scoped
outcome, findings, checks, references and limits, then stop.
