# LeanInfoTheory supervised review tooling

Start with [operations](../../docs/review-operations.md) and the
[canonical protocol](../../docs/review-protocol.md). Python validates/records local
workflow state; the actual implementation agent makes native reviewer calls.

- `cli.py`: explicit `inspect`, `instructions`, `api`, binding/session and phase
  entry points; no transport, scheduler, queue drain or next-step generator.
- `project.py`: LeanInfoTheory identities, owned `.lit-review/` records, exact
  plan contracts, chunk reviewer binding and supervised plan/step transitions.
- `project_source.py`: actual checkout/dependency facts and B/R/F working-byte capture.
- `library.py`: library rubric and existing-validator guidance embedded in requests.
- `core/`: inherited state, original-report/evidence contracts and guarded fixtures.
- `tests/`: isolated source-copy/adapter checks; not mathematical acceptance.

Canonical C9--C24 chunks use exact approved IDs such as `C9.01`; `C09` aliases do
not rename steps. Prefixes: `lit-review:`, `lit-message:`, `lit-finding:`, `lit-auth:`.
Private records are durable, outside source capture/scratch cleanup. Production,
replay and fixture identities remain separate regardless of legacy operation labels.
See operations for actual-chunk-parent binding. Installation neither binds C9 nor
starts its planning. The omitted creation `transport` retains the installed
`multi_agent_v1` contract; `transport: "collaboration"` explicitly selects the
additional native format below. The adapter never guesses between identity fields.

## Collaboration transport

For a collaboration binding, retain the complete original creation result and the
actual `tool_call` (`name: "collaboration.spawn_agent"`, original `arguments`).
Arguments must record the requested `model: "gpt-6-astra"`,
`reasoning_effort: "ultra"`, `fork_turns: "none"`, `task_name`, and bootstrap
`message`. The unchanged canonical `requested` profile still expresses
`fork_context: false`; it is policy metadata, not a rewritten native argument.
Keep effective settings unknown unless the runtime reports them.

Record the actual `parent_task_id` and canonical `parent_role` separately. The
parent task must match `CODEX_THREAD_ID`; the original returned `task_name` must
equal both the reviewer handle and `parent_role + "/" + arguments.task_name`.
Do not synthesize an `agent_id`. Transport and original provenance are frozen in
the binding and session, with the existing parent/installer separation unchanged.

After durable dispatch intent, use `collaboration.followup_task` for the idle
persistent reviewer. Preserve its exact target, request text, and entire result.
Empty immediate results must be recorded as `UNCERTAIN`, with no invented
submission ID. The existing original-report delivery confirmation can establish
delivery separately; it never constitutes report acceptance or closure.

This bounded transport accepts completed reports from an actual
`collaboration.list_agents` call. Preserve its full original JSON result and call
arguments. Exactly one entry must match the canonical reviewer `agent_name`, and
its `agent_status` must contain a nonempty `completed` string exactly equal to the
extracted original report. Running/progress states, duplicate matching entries,
wrong identities/tools, altered extraction, and stale request/source reports fail.
Direct `FINAL_ANSWER` messages can be retained as observations, but this adapter
does not convert them into invented list/wait results or accept them as this
transport's completion evidence. Observe the actual list result instead.

Both transports retain the same source, report-correlation, evidence, finding,
reconciliation and criterion-gap gates. Native provenance remains cooperatively
recorded, not authenticated. The narrow format support is not a live reviewer test.

## Checks and limits

Use `python -B tools/lit_review/cli.py api` for supported signatures. Test entry:
`python -B tools/lit_review/tests/run_tests.py`; run it only as authorized. Source-copy
tests may create synthetic commits in temporary repositories, never the real
checkout. Broaden inherited core regressions when shared behavior changes; maintained
test names do not make historical remediation stages a new installation programme.

Fixture guards/audit hooks are not OS isolation. Record commands, fingerprints,
outcomes and limits; report Windows symlink-privilege skips without changing machine
settings. Model-free sequences are not desktop queue tests; replays are not live
reviews or unattended readiness. Use `scripts/validate_release.py` for library
validation as documented; this port implements no C9 growth gates.

The adapter reuses the unchanged shared core, safeguards and criterion-gap policy,
not PFR live records, identities, manuscripts or historical archives. Provenance/
Apache-2.0 details are recorded in [PROVENANCE.md](PROVENANCE.md); preserve source notices.
