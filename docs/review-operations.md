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

Canonical chunks are `C9` through `C24`; `C09` aliases normalize storage to `C9`.
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

## Plan and session contract

The proposed map is not execution approval. Installation/inspection need no C9
plan; planning needs separate instruction. Plan review assesses a proposal only.
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

## Validation and plan review

Use the library validator, not downstream build recipes:

```text
python scripts/validate_release.py focused <targets>
python scripts/validate_release.py static
python scripts/validate_release.py documentation
python scripts/validate_release.py
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
Lean builds and inspect diagnostics. Installation changes no historical API counts,
frozen baseline or C9 growth gates.

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
migration, corruption repair, cancellation reactivation, conflict/substantive
adjudication or historical reopening is supported. Legacy `FIXTURE`/`DIAGNOSTIC`
labels do not establish provenance or acceptance scope.

Reusable C9 startup prompt, to be issued **only after separate planning instruction**:

> Begin C9 planning only. Read AGENTS.md, the living-summary quick start, the proposed
> C9--C24 map, relevant references, and both review documents. Run read-only `inspect`
> and `api`. Treat Chunks 1--8 as historically complete. As the actual C9 implementation
> parent, establish your own persistent gpt-6-astra/ultra reviewer with
> `fork_context=false`; retain raw native results and unknown effective settings.
> Prepare the detailed plan with exact C9.01-style IDs and a final cumulative
> review/documentation/disposition/handoff step. Use the installed workflow when I
> request plan review. Do not implement until I approve the exact plan; thereafter
> perform one eligible requested step with review and stop.

No C9 planning/binding occurs at installation. Distinguish model-free tests, replays,
live diagnostics and desktop queue use; report platform skips/unknown settings.
Cooperative checks establish neither hostile-process isolation nor unattended readiness.
