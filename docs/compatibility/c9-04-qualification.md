# C9.04 growth-gate qualification

This record covers the combined C9.01--C9.04 tooling before either approved new
production theorem. Requirements remain in the [approved plan](../plans/post-release-chunk-09.md),
especially C9-GROW-01 through C9-GROW-06 and Section 3.5. The
[step notes](../plans/post-release-chunk-09-notes.md) retain workflow provenance,
independent review and the intervening handoff. This document reports qualification;
it does not itself establish workflow closure or authorize the next step.

## Execution and evidence ownership

Fresh C9.04 production qualification and both complete fixture runners passed.
The parent executed the actual commands and preserved their original stdout,
stderr, exit status, elapsed time and source identities. Earlier C9.01--C9.03
results remain historical evidence and are not relabeled as these fresh runs.
Supporting agents inspect or improve bounded test/fixture code; their checks are
identified separately from the parent's checks and the persistent reviewer's work.

All deliberate fixture mutations stay in private ignored copies below this checkout's
`tmp/`. Project build outputs are private; clean pinned dependency caches may be
shared. Artifact-producing Lean commands run serially, including the serializer
test's real `lean --run` probe. The four growth cases retain their established
schedule: full unchanged trust comes from the separate production run, both changed
positives receive full trust, and restored source receives fresh static/standalone
compatibility. The runner explicitly does not repeat the restored all-project audit.

## Complete Section 3.5 matrix

The table maps every required row to a runnable check. Real source/compiler
integration, source-only checks, synthetic classification and synthetic HTML are
different evidence boundaries. Expected negative exits are successful fixture
outcomes only when the required diagnostic is present.

| Plan row | Runnable evidence | Boundary and expected result |
| --- | --- | --- |
| Unchanged release/current | Exact-release reproducer `--check`; retained runner `unchanged` and restored checks; production compatibility/trust | Real own-output release rebuild plus two equal complete exports; real current 601-contract pass. |
| Documented existing-owner addition | Both runners' `compatible_addition` | Real compiling addition; growth runner additionally checks full trust, exact inventory, direct consumer, synthetic docs and frozen preservation. |
| Approved opt-in owner and consumer | Growth `approved_module` | Real additional owner and umbrella import, two fixture-only approvals, full trust/direct consumer and actual checker on synthetic HTML. |
| Otherwise identical unapproved owner | Growth `unapproved_module` | Same Lean/generated/HTML bytes, approvals removed; ordinary compilation/consumer pass, static/trust/compatibility/docs specifically refuse import policy. |
| Extra retained assumption | Retained `extra_assumption` | Real compiling mutation; retained comparison identifies the named theorem's changed binder. |
| Changed source with old compiled artifact | Retained `stale_artifact` | Baseline owner artifact retained across mutation; standalone compatibility itself builds, replaces the old artifact and rejects the changed contract. Before/after artifact hashes are recorded runtime observations; transient `.olean` bytes are not separately archived. The original standalone build and exported contract difference remain preserved. |
| Result or argument contract | Retained `changed_result`, `named_binder`, `implicit_binder`; serializer probe | Real compiling source mutations exercise results and binders. The actual Lean serializer probe uses constructed synthetic Expr values for dependent/universe contracts and unsupported-expression refusal; it is not a source-level universe-change fixture. |
| Removal, rename or relocation | Retained `removed`, `renamed`; policy/compiled-owner tests | Removal/rename compile then fail named contract checks. Relocation is explicitly synthetic owner/classification evidence. |
| Retained/new simp membership | Retained `retained_simp_added`, `retained_simp_removed`, `retained_simp_relocated`, `unapproved_new_simp`; focused policy tests | Retained simp changes are detected with unchanged retained types and declaration counts; unapproved new simp is refused after its larger inventory is regenerated. The relocation case restores umbrella membership while losing focused membership. |
| Alias/import/non-stable boundary | Retained `extra_root_alias`, `heavy_root`, `focused_import`; policy/compiled tests | Three real source cases. Alias retarget/removal and non-stable leakage/classification are explicitly synthetic cases with named historical/current-boundary refusals. |
| Undocumented/unindexed addition, missing/duplicate blocks, stale attestation | Growth source-negative checks; current-inventory, API-doc, lifecycle and website tests | Actual source/generator/static negatives plus synthetic HTML/lifecycle tests. Counts alone cannot establish completeness; mocks are recorded as component evidence. |
| Same-manifest signature/body/docstring edits | Growth unchanged-case staleness checks; lifecycle tests | Three actual source edits preserve manifest bytes; actual checker refuses old synthetic HTML/configuration and accepts exact restoration. No compilation claim for these edits; lifecycle build calls are mocked. |
| Historical bytes/current-as-frozen route | Frozen verifier/generator tests; API-doc/staging/website regressions | Modified historical bytes are refused without repair; synthetic current/legacy staging inputs are refused before route copy. No publication occurs. |
| Same-type body edit | Retained `same_type_body` | Real change from base 2 to base 3 passes structural compatibility as an expected limitation; the existing Units consumer must fail at the specific base-2/base-3 type mismatch. Source/semantic review remains required. |

The additional source-negative cases reuse the valid compatible declaration but
remove its docstring or leave its current inventory stale, and add an unclassified
local owner. They test the actual generator/static boundary without another Lean
build. No production acceptance policy changes to make a fixture pass.

## Reproduction commands

Run these from the authorized checkout. Keep all Lean-producing commands serial.
For Python suites that use system temporary directories, set `TEMP`, `TMP` and
`TMPDIR` to a newly owned ignored directory below `tmp/` for that invocation.

```powershell
python -B scripts/generate_current_public_api.py --check
python -B scripts/generate_v0_1_public_api.py --check
python -B scripts/validate_release.py static
python -B scripts/validate_release.py build
python -B scripts/validate_release.py documentation
python -B scripts/validate_release.py compatibility
python -B scripts/validate_release.py trust
python -B scripts/compatibility/export_retained_api.py --baseline-source tmp/c9-01-release-20260911 --check
python -B scripts/compatibility/test_retained_export.py
python -B scripts/test_current_public_api.py
python -B scripts/compatibility/test_public_api_compatibility.py
python -B scripts/compatibility/test_current_policy.py
python -B scripts/test_validation_growth.py
python -B scripts/test_api_docs.py
python -B scripts/compatibility/test_growth_fixtures.py
python -B scripts/test_check_website.py
python -B scripts/compatibility/run_compatibility_fixtures.py
python -B scripts/compatibility/run_growth_fixtures.py
```

The reproducer verifies the exact release/tag source, private project output and
actual clean dependency pins before trusting the old copy. Its presence alone is
insufficient. The runnable compatibility test is in `scripts/compatibility/`;
Section 6's illustrative top-level path is a stale spelling. Using the existing
entrypoint changes no approved criterion. Default `build` includes the default
target and all eight maintained warning-as-error targets. `trust` independently
rebuilds compatibility and retained/current boundaries before the complete audit.

## Criterion traceability and readiness

| Criterion | Required consolidated evidence |
| --- | --- |
| C9.04-R1 | Every matrix row above, both complete live runners, fresh exact-release repeatability, synthetic/source-negative suites, original expected refusals and preservation/restoration comparisons. |
| C9.04-R2 | Fresh production generators/static, default and maintained builds, five README consumers, standalone compatibility and full current trust/import audit, bound to unchanged source/configuration/clean actual dependencies. |
| C9.04-R3 | This evidence table, maintained source applicability and readiness note, exact plan/step boundary, and independently reviewable combined gate design before either new theorem. |

All three readiness criteria have completed parent evidence. The persistent
reviewer independently assessed each as satisfied, with no findings; its original
report was accepted and explicitly reconciled. The step notes separate reviewer
checks from parent executions and preserve report provenance and limitations.
No new production theorem has been added. Final validation and exact-source
closure are determined by the private workflow completion record.

| Completed C9.04 execution | Result and preserved originals |
| --- | --- |
| Production build, documentation, compatibility and trust | All passed. Default build plus eight maintained warning-as-error targets; five independently compiled README examples; all 601 retained/current declarations and 31 focused imports; 94 simp declarations, 92 root aliases, 480 opt-in exclusions; all 1382 compiled local constants across 44 modules use only the three allowed axioms. Original command arrays, streams and results: `tmp/c9-04-native-1789196080633300500/`. |
| Exact-release reproduction and serializer/envelope suite | Fresh release rebuild and two complete exports passed the reproducer's internal byte-equality check and reproduced the 601-declaration retained artifact exactly. Eleven tests passed, including the real Lean synthetic-expression serializer probe. The native directory retains original CLI streams and the emitted probe command/source hash/raw output; separate raw first/second release export streams are not claimed. |
| Current/frozen generation, static and Python suites | All passed: 9 inventory, 14 retained-compatibility, 29 policy, 6 validation/lifecycle, 25 API-doc, 20 growth-runner and 31 website/staging tests, totaling 134 distinct Python-only tests; with the 11 exporter tests, 145 distinct tests. Static repeats the website suite without increasing this count. Originals: `tmp/c9-04-python-1789196498602954100/`. |
| Complete retained runner | All 17 cases passed their expected outcomes. The standalone stale-artifact check replaced the prior owner artifact and rejected the changed assumption. The same-type body case passed structural compatibility but failed the existing Units consumer at the specific base-2/base-3 mismatch. Originals: `tmp/c902-1d422d0bd59e40adbf697c18ff11425a/`. |
| Complete growth runner | All four cases passed expected outcomes. Both changed positives passed full trust and direct consumers (602 declarations, 31/32 supported owners, 1383 compiled constants across 44/45 modules). The otherwise identical unapproved source compiled and its consumer passed, while static/trust/compatibility/docs refused missing import approval. Originals: `tmp/c903-30bf26a4d39649ac9de266d1ca27b6e5/`. |
| Additional growth boundary checks | Three same-manifest source edits invalidated old documentation evidence; three source-only negatives refused undocumented/unindexed additions and an unclassified owner for their specific reasons. Exact restoration passed the corresponding actual checker. Synthetic HTML and no-compilation cases remain identified in each record. |
| Generation and preservation | Twice-generated current/index/blueprint bytes matched, check modes were nonmutating, and both frozen artifacts remained exact. Restored static and standalone compatibility passed. Parent comparisons verified every copied input restored and all 140 production-input hashes unchanged through both runners. Queue command originals, case summaries and complete restoration comparisons: `tmp/c9-04-fixtures-1789197916892891700/`. |

The completed production trust and documentation identities cover respectively
62 source inputs with nine actual clean dependencies and 69 source/configuration
inputs with 14 actual clean docbuild dependencies. Subsequent changes are confined
to the recorded qualification/canonical prose. Fresh applicability and static/link
checks before review and final capture preserve the distinction between an actual
completed native execution and a later identity comparison.

Intermediate generated files after each generation/check pass are not archived
separately. The actual runner enforces repeatability and nonmutation and preserves
the resulting hashes and original command results. Final copied-source equality
is separately recomputed after restoration.

Original supplemental scratch-harness failures remain separate from later passes:
one source-negative smoke copy lacked CCShim; two supporting mocked stale-artifact
harness attempts lacked frozen inputs or an old artifact. Correcting only those
scratch setups produced passing checks. None was used as passing live qualification
or changed production acceptance policy. The complete live runners above use the
maintained source-copy setup and preserve their own original results.

## Limits and remaining-work dispositions

Equal retained types do not prove unchanged definition bodies, referenced meaning,
notation or intended mathematics. Strict serialization may reject a harmless
elaboration change; no automatic acceptance of that drift follows. Clean source
hashes and pinned dependencies provide cooperative provenance, not hostile-process
isolation or proof of compilation. Synthetic classification/HTML and mocked
external builds are never presented as real Lean/doc-gen results.

After C9.04's review, reconciliation, final validation and durable closure, C9.05
and C9.06 remain separate explicitly requested theorem/consumer steps. C9.07 owns
the final cumulative qualification and independent chunk review, separately
authorized clean checkpoint/default suite, actual final-source two-pass current
doc-gen, canonical reconciliation, remaining-work dispositions and maintained
`docs/handoffs/chunk-9.md`. This step neither runs nor weakens those later gates.
