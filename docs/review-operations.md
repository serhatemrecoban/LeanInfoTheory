# Supervised review operations

Use [the protocol](review-protocol.md) for policy and [tooling notes](../tools/lit_review/README.md)
for test boundaries. Run from the actual checkout with compatible Python 3 and
UTF-8 JSON; `-B` avoids bytecode clutter. This guide is not mathematical approval.

## Entry points and identities

```text
python -B tools/lit_review/cli.py inspect
python -B tools/lit_review/cli.py instructions
python -B tools/lit_review/cli.py api
python -B tools/lit_review/cli.py bind --input <binding-packet.json>
python -B tools/lit_review/cli.py open --input <session-packet.json>
python -B tools/lit_review/cli.py next --chunk C9 --input <actual-message.json>
python -B tools/lit_review/cli.py call --chunk C9 --input <operation.json>
```

`inspect` reads checkout/dependency and setup/plan facts without granting authority;
`instructions` loads both review documents; `api` prints supported signatures.
`--checkout` selects the root; `--input` is JSON, never code. Optional
`--save unique-name.json` writes an exclusive private setup result. Exit 0 is local
success; exit 2 is refusal with a reason. `call` accepts
`{"method":"inspect","args":[],"kwargs":{}}` and only allowlisted `api` methods;
importing `project.py` uses the same interfaces. Never patch journals to fix refusal.

Canonical chunks are `C9` through `C40`; `C09` aliases normalize storage to `C9`.
Use exact approved step IDs (`C9.01`, etc.); an approved padded `C09.01` is also
accepted but never silently rewritten to a different plan ID.
Prefixes are `lit-review:`, `lit-message:`, `lit-finding:`, and `lit-auth:`; owned
`.lit-review/` records remain separate from fixture/replay/diagnostic identities.

## Bind once in the actual chunk task

Only the actual chunk implementation parent binds a reviewer; installation,
GeneralAssistant/support parents and transferred bindings cannot supply it.
Retain the user instruction/bootstrap intent and use the schema actually exposed
by the originating task. The original supported transport is:

```text
multi_agent_v1.spawn_agent(model='gpt-6-astra', reasoning_effort='ultra', fork_context=false)
multi_agent_v1.send_input(target=<agent_id>, message=<exact-neutral-request>)
multi_agent_v1.wait_agent(...)
```

For that transport, creation returns `agent_id`, send may return `submission_id`,
and wait statuses carry the completed original report. The explicit
`creation.transport:"collaboration"` adapter instead uses the exposed
`collaboration.spawn_agent(..., fork_turns="none")`, `collaboration.followup_task`
and `collaboration.list_agents`. Creation returns the canonical `task_name`;
the list result must contain exactly one matching `agent_name` with a nonempty
string at `agent_status.completed`. Preserve that entire native result, the actual
call, and the exact extracted string. A running status or old bootstrap response
is not a source-bound review. No `agent_id` or submission ID is manufactured.
Never invent native `task_name`, `FINAL_ANSWER`, or wait wrappers. Direct runtime
messages may be preserved as original evidence, but this narrow collaboration
adapter accepts completion through the actual `list_agents` result only.

The inherited `bind` packet contains `chunk`, `parent`, `reviewer`, `approval`,
and `creation`. Use the actual originating task's exposed `CODEX_THREAD_ID` for
`parent`, not a role such as `/root`; `reviewer` is the returned canonical handle
for the bound transport (`agent_id` or `task_name`).
`creation` retains `canonical_reviewer`, requested profile, `original_result`,
honest `reference`, actual `parent_role`, `parent_purpose:"CHUNK_IMPLEMENTATION"`,
and observable effective fields if any. This purpose must describe the real task;
do not relabel an installation/support parent to bypass binding restrictions.
For the legacy transport, `original_result.agent_id` must equal `reviewer`. For
the explicit collaboration transport, retain `parent_task_id`, the actual canonical
`parent_role` and full original creation call in `tool_call`; the original
`task_name` must agree with that parent role and requested child task name.
The original result is preserved unchanged. Production also refuses the
`installer_parent` retained in `.lit-review/installation.json`.
Requested profile uses `model`, `reasoning_effort`, and `fork_context:false`.
Keep effective parent/reviewer settings unknown unless actually observable.
User observations carry `role:"user"`, real or explicitly local `reference`, and
exact `original_text`; Python validates structure, not authenticated human origin.

Bootstrap requests read-only review, no delegation/edits/unrelated access, and
waiting for the source-bound request; omit implementation transcripts/verdicts.
Reuse one binding for plan/execution sessions; do not recreate it after error.
Read-only instructions are not OS isolation; conflicting settings are not "unknown."

### C40 execution in the lead-designated successor chat

The lead authorized a successor implementation parent for C40 after plan review
and before execution. The original planning parent's `binding.json` and both
plan journals retain their original reviewer and identity. This exception uses
the original binding's SHA-256, the two recorded parent IDs, and an independent
reviewer created by the successor parent. It applies only to C40 execution.

From the successor chat, use `python -B tools/lit_review/cli.py bind-c40-successor
--input <packet.json>` (one command). Include the ordinary collaboration
`bind` fields and the top-level `predecessor_sha256`
`200127d8e587016457ccc8f02bfa430e53997772c6fb5ae4744f2ddffd881157`.
Use the actual lead instruction and its reference in `approval`, with scope
`C40_EXECUTION_PARENT_SUCCESSION`. Preserve the new native creation call and
result with a distinct reviewer handle. The recorder writes the exclusive
`.lit-review/chunks/C40/execution-parent-successor.json` record only before
an execution session exists. The successor then uses ordinary `open`, `next`
and step review with its own identity, approved plan and step selection.

## Plan and session contract

In rendered PLAN and STEP requests, C9--C24 use the
[post-release map](plans/post-release-chunk-map.md) and C25--C40 use the
[Release 3 map](plans/release-3-chunk-map.md) for programme context. Review the
exact chunk plan and its criteria. Planning needs a separate instruction, and
plan review assesses a proposal only. The C24.05 and C24.06 exceptions below
apply only to their original steps.
Do not create dummy plans or retrospective automation acceptance for Chunks 1--8.

`open` retains `chunk`, `session`, `contract`, and actual `approval`. Use `execution`
for steps and `plan-<local-id>` for plan review. Execution approval has
`scope:"APPROVED_IMPLEMENTATION_PLAN"` and the exact `plan_sha256`; plan review
uses `scope:"PLAN_REVIEW"`. Execution requires the actual Approved/Active plan and
explicit lead approval of that revision. Opening a session starts no step.

Contract fields: `plan_path` under `docs/plans/`, full-file `plan_sha256`, `kind`
(`STEP`/`PLAN`), explicit additional relative file `scope`, ordered `steps`,
`plan_criteria`, and exact nonempty `normative_anchors`. Execution step records use
`{"id":"C9.01","criteria":[...]}` with empty `plan_criteria`; plan review has empty
`steps` and criteria about the proposal. Criteria contain unique `id`, `description`,
`source_reference` (`plan_path#anchor`), exact `normative_excerpt`, `scope` and
`required_evidence`. IDs/excerpts must occur in the real plan. Verify faithful
coverage yourself: substring checks are not a semantic parser.

Keep approved normative requirements frozen and evolving proof advice in separate
captured notes. A plan may deliberately reserve an editorial region between
`<!-- lit-review-status:start -->` and `<!-- lit-review-status:end -->` for status
or chronology, never requirements; otherwise the whole plan is normative.
Advisory changes need reasons; material replacement needs the lead and a supported
transition, not hash editing. Reserve the final step for cumulative criteria,
fresh review, canonical documents, dispositions and `docs/handoffs/chunk-N.md`.
Separate readiness criteria from later receipt/reconciliation/private closure duties.

Capture includes working bytes, dirty/untracked files, deletions, Git/configuration
and installed dependencies; `@environment` is derived, never invented. This is the
library itself, not a second-checkout dependency. Explicitly scope pinned declarations
and consumers; imports are not inferred. Pins must match the manifest. Records,
scratch, builds and reference media stay outside capture; preserve unrelated work.
`historical_baseline` identifies the release commit and completed Chunk 8 plan,
not fresh automated acceptance or a PFR C01 prerequisite recheck.

## One processed message and review cycle

1. Inspect state, approved plan and the real processed message. **Before `next`,
   resolve its named target/predecessor and verify exact IDs, ordered next position,
   predecessor closure/source, pause/cancellation and plan/chunk boundaries.**
   The helper does not understand arbitrary English or choose another authorized
   target. Retain a consume/skip disposition for unfinished/blocked prerequisites;
   do not retry them, clear blockers or revive consumed skips. A still-unprocessed
   message is evaluated when processed. The ingress packet retains `message_id`
   (`lit-message:<native-or-local-id>`), `user_observation`, exact `target_step`
   (for example `C9.02`), and named `predecessor` when conditional (`C9.01`).
   `next` calls `process_named_next`; these structured fields check resolved IDs,
   not English meaning. Do not bypass the precheck using raw `process_next`.
   Label local IDs honestly, reuse identifiable redelivery IDs, never invent messages.
2. On the one eligible step capture B before edits. `begin_edit(paths, reason)`
   retains before-images; patch normally and `finish_edit(ref)`. Restore only your
   own changes after comparing current bytes with saved after-images, then record
   `finish_reversal(ref)`. These records do not authorize overwriting other work.
   The already selected C24.05 candidate package transition has one narrow recorder:
   `begin_edit(['lakefile.toml'], reason, candidate_version_metadata=True)`. It
   requires the approved C24.05 metadata criterion, unchanged historical config,
   preparation/pending state, then records only the exact 0.1.0→0.2.0 version line.
   `finish_edit` also requires candidate/pending state and unchanged options,
   toolchain, manifest and absence of alternate Lake config. Normal configuration
   edits remain refused. This is edit accounting, not new approval or acceptance.
3. Run required checks; `parent_evidence` records actual output, source, command,
   outcome and limitations. `initial_validation`, read-only `self_review` and
   separate `reassess` retain the two decision phases. Use stable `lit-finding:`
   IDs. Apply justified changes and support every disposition with reasons/evidence.
4. `prepare_review` freezes R. Use unique IDs such as
   `lit-review:C9:execution:<unique-id>` (or the exact plan session). Inspect rendered
   neutral text for the full library rubric, relevant read instructions and criteria;
   no private verdicts/transcripts. `dispatch_intent` precedes the native send.
5. Send to the recorded canonical reviewer handle using its bound transport;
   `record_submission` preserves the full actual
   result as `ACKNOWLEDGED`, `UNCERTAIN`, or `FAILED`. Record bounded waits (at most
   60 seconds each); pending status is not a report. Empty output never warrants
   blind resend. Keep any observable submission ID separate from report acceptance;
   an absent ID remains absent. For an idle collaboration reviewer, use
   `followup_task`; `send_message` alone does not start its turn.
6. Preserve the complete raw completed status/report before classification, with
   extraction method and available origin/correlation metadata. Observation fields
   include `input_mode:"OBSERVED"`, `origin:"RUNTIME_EVENT"`, `parent`, `reviewer`,
   `request_ref`, honest `event_ref`, and JSON-encoded actual `original_event`.
   Retain the actual call in `tool_call`. The legacy transport requires
   `name:"multi_agent_v1.wait_agent"` and its original `arguments`, including
   `targets`, and extracts `status[agent_id].completed`. The explicit collaboration
   transport requires `name:"collaboration.list_agents"` and its original arguments,
   and extracts the unique matching `agents` entry's `agent_status.completed`.
   Neither transport accepts the other's result shape under its binding.
   Full reports add `event_kind:"FULL_REPORT"`, `complete:true`,
   `text_role:"ORIGINAL_NOT_SUMMARY"`, and exact `extracted_text`; these local
   classifications do not replace native origin evidence. Retain uncertainty honestly.
7. If needed, separately `confirm_delivery` from the correlated original report;
   preserve the original uncertain receipt. The inherited specific authority action
   `CONFIRM_DIAGNOSTIC_DELIVERY` is a legacy label, not diagnostic provenance.
   `authority(action,target,"lit-auth:<unique-id>",user_observation)` uses real
   authorized user evidence, never reviewer prose. `receive_report`, explicitly
   `reconcile_report` even when clean, and evaluate findings/criteria independently.
8. Retain FAIL evidence and every original report. After reconciliation use
   `begin_corrections()` before independent-review fixes or final-validation edits.
   Use supported dispositions and `extra_review` for productive linked questions.
   Reviewer gaps/contradictions need a new satisfactory reviewer assessment, not
   implementer evidence alone. Follow the protocol's initial and targeted barriers.
9. Finish required canonical and handoff edits before final capture; keep closure
   status provisional. `finish_corrections()` enters final validation. Run current
   checks, refresh stale disposition evidence, `assess` every required criterion,
   `finalize_documents(reason)`, then `prepare_final(validation, impact=..., rationale=...)`.
   `BOUNDED_CORRECTION` needs a justified R-to-F assessment and cannot excuse material
   invalidation. `project_closure()` verifies exact F and all obligations, closes
   only this step, and starts nothing. Record the closure reference through private
   completion and the user report; do not edit captured documents after F.

## Verified-file delivery (PLAN and STEP)

Choose delivery when preparing the authorized review. Use inline for small
requests or `verified_file=true` for large requests or unreliable inline sends.
There is no required threshold, failed inline attempt, or separate lead prompt.

1. Pass the keyword `verified_file=true` to `plan_review_request` or
   `prepare_review` (in CLI JSON: `"kwargs":{"verified_file":true}`). Call
   `verified_file_packet(request_ref)` with the resulting reference. It exports
   the frozen request's exact UTF-8 text, without a BOM or newline conversion,
   into the owned session. It neither sends nor acknowledges anything.
2. Record the usual PLAN `INTENT` or STEP `dispatch_intent`. Send the packet's
   exact `message` to its `target` using the bound native tool. The reviewer may
   read that one file, not neighboring private records. It must compute the byte
   count and SHA-256, read the full request (in sections if needed), review it,
   and end `report.scope` with the specified line only if verification succeeded.
3. Record the actual native call (name and exact target/message arguments) and
   its original result through ordinary PLAN `SUBMISSION` or STEP
   `record_submission`. Empty is still `UNCERTAIN`, not a reason to resend.
   When a correlated original report arrives for an uncertain file send, use
   `confirm_verified_file_delivery(request_ref, receipt_ref, original_text,
   observation)` before normal report intake. It uses the originating plan-review
   or step instruction and all ordinary confirmation checks; it does not approve
   the report. Preserve real native evidence, including negative findings.
4. If the reviewer or file cannot be verified, do not claim delivery or accept
   the review. Surface the blocker rather than substituting a summary, changing
   reviewers, or switching the mode of an already dispatched request. No
   historical records, separate step approvals, or closure rules change.

## Validation and plan review

For C25–C40, use the development CI gates and the library's focused build commands:

```text
python scripts/validate_release.py focused <targets>
python scripts/validate_development.py static
python scripts/validate_development.py compatibility
python scripts/validate_development.py trust
python scripts/validate_release.py documentation
python scripts/validate_development.py
python scripts/validate_release.py api-docs
```

While dirty, choose focused touched modules/consumers and static checks;
`documentation` checks release-facing contracts/README examples as applicable.
`targets` lists maintained targets. Closeout uses approved cumulative checks; the
full suite requires an authorized clean checkpoint and repeats after amendment.
Report pending clean gates; never weaken them or commit user work to pass.
API-docs is a justified separate milestone, not a per-step/publication requirement.
Windows needs Zig 0.16.0 via `LEANINFOTHEORY_ZIG`; file mode is local-only and
`DOCGEN_SRC=github` needs a clean exact-commit checkout. Serialize artifact-producing
Lean builds and inspect diagnostics. Match the development qualification evidence
to the actual checkout before the first public addition. The
[compatibility guide](compatibility/README.md) describes the two retained
comparisons, approval fixtures and separate exact-release replay.

For `plan-*` sessions use `plan_review_request`, `plan_review_record` stages
`INTENT`, `SUBMISSION`, `REPORT`, `reconcile_plan_review(decisions)`, then
`plan_review_result()`. The result awaits exact lead approval and authorizes no step.
Explicitly pass `--session plan-<local-id>` for every `call`/`backup`; default is
`execution`. Same native/original-report rules apply. Revised plan review uses a
fresh explicitly requested session and the same reviewer, retaining earlier records.

## Durable state and startup

Durable `.lit-review/` is never scratch. `backup --chunk ... --input ...` takes
`{"name":"fixture-backup-<unique-lowercase-name>"}` (legacy filename convention),
making only a same-disk journal copy. With no writer, manually back up the full store
and checkout/version privately. Before restore inspect tip, identities, source and
outstanding dispatch; never overwrite blindly. No automatic stale-lock removal,
migration, corruption repair, cancellation reactivation, general conflict or
substantive adjudication, or historical reopening is supported. The bounded
exceptions below require separate exact authority. Legacy `FIXTURE`/`DIAGNOSTIC`
labels do not establish provenance or acceptance scope.

For an invalid report followed by a reviewer-authored correction that removes
exactly one FAIL citation from one SATISFIED criterion, use the read-only
`report_format_conflict_target(initial_capture, corrected_capture)` to obtain the
exact authority target. After the lead authorizes that pair and correction, call
`resolve_report_format_conflict` with `RESOLVE_REPORT_FORMAT_CONFLICT` authority.
It retains both original classifications and delivery bytes, and appends only a
resolution. It does not accept either report or clear any other persistent barrier.

After independently reviewing and testing the remedial tooling, use separately
scoped `REQUALIFY_REPORT_FORMAT_CONFLICT` authority with
`requalify_report_format_conflict(resolution_ref, approval, reason)`, with an
explicit source-change and requalification rationale. This supersedes only
the unaccepted old request and resets the step to `IMPLEMENTING`, retaining its
history. Complete fresh initial validation, self-review, separate reassessment
and a newly captured source-bound review through the usual operations. Keep
actual old checks attributed to their original source; changed tooling needs
qualification. Never edit journal objects, relabel the conflicting capture,
resend an old report as a new arrival, or use ordinary `recover` to bypass this
procedure. Inspect retained results after any partial operation before continuing.

For the separately approved C24.06 noncanonical dispatch repair, the project API
offers `noncanonical_dispatch_target(evidence, repairs)` and
`adjudicate_noncanonical_dispatch(evidence, repairs, approval, reason)`.
This is limited to the three C24.06 criteria and a pending collaboration dispatch
with an empty native result, known independently corroborated inventory mismatch,
no canonical receipt, and no original report or acceptance. Ordinary `recover`
continues to refuse that missing-receipt case. A rejected submission preflight is
retained as a preflight, never promoted to a receipt.

Preserve both original native frames and the root/reviewer transport observations;
opaque message bytes remain opaque, and no full received-text hash is asserted.
Prepare exact before/after bytes only for `tools/lit_review/project.py`,
`tools/lit_review/tests/test_noncanonical_dispatch.py`, and this operations guide.
Record actual focused tests and independent examination against the complete
fixed-label `NONCANONICAL_REPAIR_SOURCE` snapshot before application. The returned
target binds the original request/source, qualified repair snapshot, evidence and
byte delta. Use the actual lead authorization with action
`ADJUDICATE_NONCANONICAL_DISPATCH`; the mutator recomputes the target and all live
guards. Check the separately approved candidate ref/tree and protected primary
index before applying. The operation grants no checkpoint or publication authority.

The append-only adjudication supersedes only the unaccepted request and resets
readiness to `IMPLEMENTING`, preserving B, completed steps, findings, originals and
all history. Complete fresh initial validation, contextual self-review, separate
reassessment and a new unique request/attempt. Changed tooling needs its own
qualification; unchanged compiler evidence retains its exact original source and
candidate attribution. No delivery, report, criterion or closure credit follows
from adjudication. The original review, reconciliation and closure gates still
apply. This exceptional API has no CLI exposure or general force-recovery option.

The separately approved C25.05 repair uses those same two API operations and
append-only/fresh-readiness guards, with a distinct incident scope. It requires
exactly `C25.05-EXAMPLES` and `C25.05-CALLER`; in `OBSERVED` mode it pins the original
request `1dbf1a64bcdb40c328073a04f1154e3843e79b3bb64cbcd9ce8cb733ac065d93`, source
`4b1fb420550a05a552e868f76bf55a301416a9439d9d281d8e4656f617807767`, complete binding,
attempt 1 and the native call identified by the recorded evidence digest. The known
`README.md` discrepancy is the independently corroborated 67-character value
`74c6c416f679b0af3a00d890944bf1e71f71f4268650ad177d9054713774bb8ff94`, compared with
canonical `74c6c416f679b0af3a00d890944bf1e71f4268650ad177d9054713774bb8ff94`.
This identifies one known difference; it asserts no complete plaintext comparison.
Retain the original interrupted-review/stop evidence without treating it as a
criterion report or successful validation.

For C25.05, `evidence.candidate` is exactly
`{head, index_entries_sha256, cached_diff_sha256}` for the protected primary
checkout. Its approved HEAD is `2eb80d0e746688511618aaefc2624ffa4ae88f6e`, index hash
is `3dc563e8c905ebcbd9ca18752d57526e3df8897ae2030d03e4cafcbcabf9cb59`, and cached
diff hash is `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`
(empty staged diff). The adapter compares these with both snapshots and re-reads
them before applying; C25.05 does not use the C24 candidate branch. All three
listed repair paths must have their exact changed before/after bytes qualified.
The unchanged guards reject any receipt, report arrival, source drift or absent
exact user authority. After supersession, fresh readiness and a new unique
source-bound request to the same reviewer remain mandatory; C25.05 receives no
acceptance credit from this repair and C25.06 remains unselected. Temporary
`REPLAYED` tests use explicitly synthetic identities and hash values; they confer
no observed authority. The historical C24.06 scope and records are unchanged.

Historical C9 installation prompt (original planning context):

> Begin C9 planning only. Read AGENTS.md, the living-summary quick start, the proposed
> C9--C24 map, relevant references, and both review documents. Run read-only `inspect`
> and `api`. Treat Chunks 1--8 as historically complete. As the actual C9 implementation
> parent, establish your own persistent gpt-6-astra/ultra reviewer with
> `fork_context=false`; retain raw native results and unknown effective settings.
> Prepare the detailed plan with exact C9.01-style IDs and a final cumulative
> review/documentation/disposition/handoff step. Use the installed workflow when I
> request plan review. Do not implement until I approve the exact plan; thereafter
> perform one eligible requested step with review and stop.

The original installation did not start C9 or bind its reviewer. Distinguish model-free tests, replays,
live diagnostics and desktop queue use; report platform skips/unknown settings.
Cooperative checks establish neither hostile-process isolation nor unattended readiness.


### Approved C26.05 stopped-dispatch recovery

The lead separately authorized the incident-specific C26.05 recovery after the
reviewer detected two omitted inventory entries in the emitted request. This case
uses the same target/adjudication operations and fresh-readiness requirements,
not ordinary recovery or a new reviewer. It is limited to the two C26.05 consumer
criteria and exact request `dbabcf14746813d5e1b48bdaba6594449c80262e9f02f3a2012e006658bac7cd`,
source `70b7b030b5ac6ba3b55e3a22b17e74ab7a5ca7631433d27040e3701d60ea8820`,
attempt 1, complete binding and the original send/stop native frames. The observed
guard pins the four preserved frame byte hashes; opaque arguments remain opaque.
The known omitted entries are Examples/Fano.lean and
Shannon/SemanticBridge/FiniteFamilyIndependence.lean under LeanInfoTheory/.
Canonical hashes and semantic roles come from that prepared inventory. No full
received-plaintext comparison or exhaustive mismatch count is claimed.

Unlike the C24/C25 cases, the original uncertain receipt already exists:
`78516b58a05484259ff8f4ea4f4e1e2e4f43c936329ec3f6f7cafb885b2d1391`.
Preserve it unchanged. The repair evidence binds its entire immutable record and
appends `CANONICAL_MESSAGE_CLAIM_CONTRADICTED` with no acceptance credit. Its derived
canonical-message assertion is contradicted by the attributed root/reviewer
observations; the empty native result remains uncertain. Permit only that exact
attached uncertain record, rejecting every other receipt, delivery, acceptance,
report capture or criterion assessment. The genuine stopped-review list result is
retained as a delivery incident, never as a criterion report. Keep all partial and
interrupted checks under their original actor/source/limitations.

Require all three original repair paths, exact before/after bytes, qualified
fixed-label source, independent examination, explicit lead authority and unchanged
other source/configuration/dependencies. C26 protects the main-checkout HEAD,
index and cached-diff tuple used by C25, not C24's candidate branch; re-read this
tuple before mutation. The append-only adjudication preserves B and all earlier
records, supersedes only this unaccepted request, and requires fresh validation,
self-review, reassessment and a new canonical request to the same bound reviewer.
There is no delivery, criterion, reconciliation or closure credit. C26.06 remains
unselected, including the already consumed conditional request. No commit,
publication or worktree authority follows. This exception has no CLI exposure and
does not relax either historical recovery case or the ordinary uncertainty guard.


Only the replacement C26.05 STEP request named
`lit-review:C26:execution:c26-05-r2-20261107`, attempt 2, uses a compact inventory
presentation. Its immutable payload still retains the entire source inventory.
Before rendering, the adapter reads
`.lake/compatibility/c26-05-recovery-20261107/review-source-inventory.json` and
requires exact equality to that payload inventory. The canonical native text
binds this neutral complete file by path, SHA-256, bytes and entry count and
requires the reviewer to read and verify it before assessing any criterion.
All normative criteria, binding/source identity, library rubric, reading rules
and report instructions remain directly present. Other requests keep their
original rendering. A missing or altered inventory refuses preparation. Dispatch intent rechecks the
reference and exact bytes, so changes between preparation and dispatch also
refuse. This
changes presentation, not capture, report classification or acceptance gates;
opaque native arguments remain opaque and no independent received-text hash is
asserted from the local file. Preserve the exact file as delivery evidence.


Compact presentation is selected by one predicate shared by rendering and
dispatch. The textual request ID and attempt are insufficient. It also checks
the current binding/session, the validated C26 incident adjudication linked to
the active first superseded request and original B, and fresh self-review and
reassessment recorded after that adjudication. In observed mode the original
pinned request/binding/frame tuple is revalidated. Dispatch additionally ties
the pending replacement and its R to the immutable payload. An ordinary
unrelated retry, including a different binding using the same textual ID,
retains its full inline inventory and requires no incident file. A stored
compact reference whose qualifying history is absent refuses dispatch.

### C28.01 rejected-preflight adjudication

The C28.01 exception to the missing-receipt barrier uses the project API's
`noncanonical_dispatch_target` and `adjudicate_noncanonical_dispatch`. It
applies only to attempt 1 of `lit-review:C28:execution:c28-01-r1-20261109`,
send identified by the recorded evidence digest. The rejected preflight preserved
the relative target, opaque stored message and empty result. The bound reviewer's
completed `list_agents` event corroborates its reading of the canonical 70,027-byte file.
Keep the four saved native frames, exact report and observation, including the
reviewer's two FAIL observations. The report and completion are incident evidence.
The operation grants no submission receipt, delivery, report acceptance, criterion
assessment or closure. Other receipts and registered arrivals block it.
This includes the delivery basis that an unsuccessful confirmation can retain
before checking its missing receipt.

Check the pinned original request, source, reviewer binding, preflight, artifact
hashes, and primary HEAD/index/cached-diff tuple. Record the before/after bytes
of all three permitted repair paths. Qualify the candidate with tests and
independent examination on the exact repaired snapshot. Obtain explicit lead
authority for the resulting `noncanonical-dispatch:<digest>` before adjudication.
The mutator rechecks that target. It supersedes only the old request and requires
fresh validation, self-review and reassessment, then a new source capture.

Only the linked replacement `lit-review:C28:execution:c28-01-r2-20261109`
uses the compact presentation. Put the full neutral inventory at
`.lake/compatibility/c28-01-recovery-20261109/review-source-inventory.json`.
Preparation and dispatch both check its contents and the byte-bound reference.
The reviewer must verify the file before assessment. All normative instructions
remain in the native text. Before dispatch, establish how the literal originating
invocation and its complete native result can be observed and preserved. Use
the canonical reviewer handle and send the exact rendered message. Retain any
opaque stored frame in its original representation, separately from the actual
model-visible invocation. A stored ciphertext or intended local file supplies
no observation of emitted plaintext. If genuine observation is unavailable,
leave delivery blocked. The recorder classifies the actual output field of a
native function-call result frame and preserves the complete original observation.
An empty output permits only UNCERTAIN, even when its outer frame is nonempty JSON.
All ordinary submission, delivery, reconciliation
and closure requirements continue to apply.
