# Historical and current API evidence

`docs/v0.1-public-api.json` is the immutable released inventory.
`docs/current-public-api.json` is generated from the evolving source, using the
existing declaration parser and module classifier. Ordinary generation writes
only the current inventory:

```powershell
python -B scripts/generate_current_public_api.py
python -B scripts/generate_current_public_api.py --check
python -B scripts/generate_v0_1_public_api.py
python -B scripts/generate_v0_1_public_api.py --check
```

Both historical command forms verify identity without writing. The exact release
Git blob has SHA-256
`3201ced98b4516e9ef4bda166e75f667f47fe61e530d85af235b410894a7dd03`.
The untouched C9 intake working file has uniform CRLF and SHA-256
`d4c5bfa78588de605798f568b312a4cef2896855e36d3c983849270181e397be`.
Its sole byte difference from the Git blob is LF-to-CRLF conversion. The verifier
accepts exactly those two identities; it never normalizes files and rejects
mixed line endings, alternative JSON formatting and substantive changes.
The current artifact identifies the canonical Git blob, not a platform-specific
checkout representation. Counts in the current artifact are derived, not quotas.

## Retained type representation

[`v0.1.0-retained-contract.json`](v0.1.0-retained-contract.json) records all 601
released public declaration types from exact release commit
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, tag `v0.1.0`, with the pinned Lean
toolchain, all dependency revisions, release source hashes and exporter hash.
It supplements the released inventory; that inventory is not regenerated.

The build-only [Lean exporter](../../scripts/compatibility/ExportRetained.lean)
serializes complete `ConstantInfo.type` expressions and ordered universe
parameters. JSON arrays are tagged constructors. Names preserve their anonymous,
string and numeric components. Universe levels preserve zero, successor, max,
imax and parameter structure. Expressions preserve bound-variable indices,
sorts, constants and their universes, applications, lambdas, dependent foralls,
lets (including the nondependency flag), natural/string literals and projections.
Binders preserve names, order and explicit/implicit/strict-implicit/instance
information. There is no unfolding, binder renaming or other normalization.
Free variables, metavariables, unbound indices and expression metadata fail
explicitly. No unsupported form occurred on the released 601 declarations.

Each record retains both source kind and actual compiled kind. Lean's `defnInfo`
does not distinguish `def`, `abbrev` and `instance` syntax; original source kinds
come from the frozen manifest. The released Prop-valued instance
`pmfChannelKernel.instIsMarkovKernel` compiles as `thmInfo`. Exact compiled kinds
are retained rather than inferred from syntax. Owners come from the imported
Lean environment and are checked against the manifest.

The artifact also records original focused/root direct local and external imports,
92 facade alias targets and 94 reviewed simp names. The C9.02 checker compares
these historical records with current source and compiled environments. Lean
export aliases are name-resolution aliases, not 92 extra constants.

## Standalone current compatibility

```powershell
python -B scripts/validate_release.py compatibility
```

The [checker](../../scripts/check_public_api_compatibility.py) derives the current
inventory directly from source, verifies immutable baseline identities, pinned
configuration and all nine clean dependency revisions, and runs its own
warning-as-error `LeanInfoTheory.Shannon` build. No previous validator or build
invocation is required. It then exports every retained type using the unchanged
historical serializer. A mismatch reports the qualified declaration, structural
location and bounded old/current values. Added premises, named-argument changes,
binder implicitness, kinds, owners, removals and renames are compatibility changes.
Even harmless elaboration drift requires investigation; there is no normalization
or baseline-update flag.

The build-only [compiled audit](../../scripts/compatibility/CurrentAudit.lean)
checks actual public constants and owners, simp membership in the full umbrella
and every supported focused import, every supported
focused import's local closure and direct local/external module headers, the
five-module lightweight root closure, enumerated facade aliases and each required
alias's actual root resolution. It checks that each local `.olean` resolves to
this source copy's own build directory. Source and compiled imports must agree.
Pinned Lean 4.33.1 inserts two implicit external `Init` entries, one ordinary and
one meta (`Lean/Elab/Import.lean`, `HeaderSyntax.imports`), before explicit source
imports. The checker preserves raw headers, requires exactly those two additional
entries, then compares the remaining imports exactly. An explicit source
`import Init` therefore requires three raw entries. Other duplicates are errors.
The bounded source-header check rejects `prelude`, module-system headers and
modified import syntax rather than applying this normalization without its premise.
Unexpected declarations, non-stable modules, aliases or unreviewed simp membership
fail closed.
The source parser supplies `def`/`abbrev`/`instance` syntax while retained compiled
kinds are independently compared; neither source parsing nor alias resolution
alone substitutes for the compiled checks.

Compiled declaration discovery walks each actual local module's kernel-constant
array, checks environment membership and ownership, and applies the pinned public
declaration classifier. It does not iterate a requested declaration list. Pinned
Lean populates the imported kernel map from those same arrays; code-generation-
only extra names remain outside the kernel map. This avoids repeated scans of
unrelated dependency constants while preserving exact current coverage.

Original command output, compiled JSON, current source inventory, before/after
source and dependency hashes, effective compiler version, and the final result
remain in a new `.lake/compatibility/<run-id>/` directory. A failed run preserves
its failure and any completed commands. Inherited `LEAN_PATH` is removed for
child commands, redirected or hardlinked project outputs are rejected, and input
changes during a run invalidate success. Lake may reuse valid incremental
artifacts after checking current input; the gate is not a forced clean rebuild.

The audit uses pinned Lean frontend initialization to load import extensions for
classification, simp and aliases. Sequential focused environments use Lean's
`withImportModules` ownership wrapper with extensions disabled, returning only
fresh serialized text before their imported regions are freed. Inside each owned
focused callback, the audit reconstructs simp state from that environment's typed
imported entries using the pinned registered simp importer. It compares the exact
public membership for that closure, so registering an attribute only in a later
umbrella cannot hide a focused consumer's loss. It does not initialize unrelated
extensions or return borrowed entries/state past region release. The extension-
loaded full/root environments remain alive. These IO auditing mechanics reside
outside the production library and do not change its proof-trust policy.

## Reviewed growth policy

[`current-api-policy.json`](current-api-policy.json) is maintained review data,
separate from generated inventory. Its initial approval lists are empty. Current
generation never writes this policy and cannot grant approval. A compatible new
ordinary declaration in an existing supported owner needs no import/attribute
record; it must still satisfy compiled coverage and the other project gates.

Each approval carries nonempty `rationale`, `consumer` and `approval_reference`
fields that document an actual review decision. They are cooperative records,
not authenticated authorization. Import approvals also carry `owner`, `kind`
and the exact resulting `imports` object with `local` and `external` arrays:

| Import change | Required kind and boundary |
| --- | --- |
| Add imports to the full or semantic umbrella | `umbrella_addition`; existing imports remain |
| Add a supported opt-in module | `new_module`; record its complete direct imports |
| Change a retained focused module outside the lightweight closure | `focused_exception`; explicit architecture review |

The protected root closure and its direct imports cannot be overridden by these
records. A new module plus an umbrella import needs both applicable records.
Simp additions name the new declaration and its owner; they cannot add or remove
retained simp behavior. Root-export additions give an exact `alias`/`target` pair
whose target belongs to a supported lightweight owner. Retained aliases cannot
be removed or retargeted. Duplicate, conflicting, missing and unused approvals
are errors, so obsolete records must be reconciled deliberately.

## Focused regression commands

```powershell
python -B scripts/compatibility/test_current_policy.py
python -B scripts/compatibility/test_public_api_compatibility.py
python -B scripts/compatibility/run_compatibility_fixtures.py
```

The real fixture command runs 17 cases and retains its source copy and logs.
Use `--cases <case> [<case> ...]` for a targeted rerun; preserve its selected case
list and source identity, and report it as a subset rather than a complete run.

The Python suites distinguish synthetic policy/compiled JSON and mocked command
ordering from actual Lean evidence. The fixture runner uses a new ignored source
copy under `tmp/`, private copied project outputs and only shared pinned dependency
caches. It builds the copy, saves actual commands and outputs, restores original
source between cases, and verifies the real checkout's input hashes afterward.
The stale-artifact case leaves the old compiled theorem in place, changes only
the copy's source, then invokes compatibility alone. No preparatory build of that
mutation can supply its freshness evidence.

Attribute fixtures distinguish an exported annotation from local state changes.
Removing the actual `@[simp]` annotation must fail. A separate fixture changes it
to `@[local simp]` and restores global membership only in the full umbrella; the
focused audit must still reject it. An out-of-line `attribute [-simp]` command
alone does not erase an exported annotation in pinned Lean and is not used as
evidence of a retained export removal.

The same-type-body case deliberately changes the copy's `natsToBits` definition
from base 2 to base 3. Its retained signatures and generated inventory can stay
unchanged, so a compatibility pass is an expected semantic limitation. The
existing `Examples.Units` consumer must reject that changed meaning. Such a
fixture pass never approves the semantic change; source review and appropriate
mathematical consumers remain necessary. C9.03 owns default/trust/API-doc
integration and the real approved/unapproved new-module pair. C9.04 and C9.07
retain their complete fixture and cumulative qualification duties.

## Reproduce without overwriting either baseline

Prepare an isolated exact `git archive v0.1.0` source copy below this checkout's
ignored `tmp/`, with the pinned dependencies available at `.lake/packages` and
its own `.lake/build`. Sharing dependency caches is allowed; sharing or redirecting
project build output is rejected. Keep dependency sources clean at their exact
manifest revisions. The reproducer verifies release/tag identity, exact project
source/configuration bytes and dependency identities before and after the run.
It builds `LeanInfoTheory.Shannon` with warnings as errors before exporting twice.

```powershell
python -B scripts/compatibility/export_retained_api.py --baseline-source tmp/c9-01-release-20260911 --output tmp/retained-comparison.json
python -B scripts/compatibility/export_retained_api.py --baseline-source tmp/c9-01-release-20260911 --check
```

`--output` requires a new file below this checkout's `tmp/`; it cannot overwrite
the retained artifact or historical inventory. `--check` reproduces and compares
without rewriting either baseline. The deterministic compact JSON contains no
timestamps or machine-specific paths. Build output goes to stderr. This command
is an exact-release reproducer, not a current compatibility gate. Its Python
envelope check validates coverage/schema/owners/kinds for fresh output from the
actual exporter; it is not a recursive parser for arbitrary submitted type trees.

## Initial capture provenance

The C9.01 source copy was extracted from the exact release without project
artifacts. Its own warning-as-error umbrella build completed successfully
(`3056 jobs`). Only dependency caches were shared. Two baseline exports and an
export after a fresh current umbrella build were byte-identical: 601 unique
names in frozen-manifest order, 3,922,366 bytes, SHA-256
`58d002e7e8dc8c6cba9b416f0b578a43e73ec9dd02c2a74ff095afec9414d802`.
The exporter source SHA-256 is
`c7d1be5d0b2e76901adae6443a9a6ef9c55d3c27b664fa887a29948bd635ed29`.
These checks preceded changes to the existing generator's behavior.

Three separate mutations of the final retained theorem
`familyEntropyOf_eq_sum_singletons_iff_isMutuallyIndependentFamilyOf` were made
only in that isolated source copy. Each compiled with warnings as errors and
exported all 601 records:

| Mutation | Observed structural difference |
| --- | --- |
| Add explicit `_c9extra : True` | One unused premise added to the target type |
| Rename `p` to `pRenamed` in its theorem and proof | Exactly one binder-name leaf changed |
| Change `(s : Finset Var)` to `{s : Finset Var}` | Exactly one explicit-to-implicit leaf changed |

In every case the other 600 records and the target's name, owner, kinds and
universe parameters were unchanged. Restoring the exact original source,
rebuilding and exporting reproduced the original export hash. The 48 release
source/configuration file identities, current source identities and all nine
dependency revisions/clean-source statuses matched before and after. Original
commands, outputs, mutation sources and restoration evidence are retained in the
private C9.01 workflow records; this paragraph reports observations, not an
independent review verdict. The initial scratch comparator error and first
reproducer's instance-kind error remain recorded separately from successful runs.

Focused maintained checks are:

```powershell
python -B scripts/test_current_public_api.py
python -B scripts/compatibility/test_retained_export.py
python -B scripts/validate_release.py static
```

Synthetic serializer/envelope tests are distinct from the three real compiling
mutations above. C9.02 adds the standalone current checker and its focused
failure diagnostics/freshness tests; C9.03 owns current trust/API-doc integration.
C9.04 and C9.07 retain the approved cumulative qualification duties.

## Current validation and documentation integration

`python scripts/validate_release.py static` verifies historical preservation,
the complete source-matching current manifest, and independently reviewed current
source policy. `trust` additionally invokes the standalone compatibility checker,
builds maintained consumers, and retains exact current direct-import, environment,
owner, root, simp and all-project compiled-constant axiom audits. The default clean
suite includes these gates. Static validation alone is not compiled compatibility.

Current API-doc coverage derives from the validated current manifest rather than
release counts. Its v2 configuration/attestation includes raw source-content,
current-manifest, retained-contract, configuration/checker and pinned-dependency
identities. Missing/duplicate blocks, empty signatures/docstrings, owner/source
errors and reviewed simp mismatches fail. Source/body/docstring edits invalidate
old evidence even if manifest entries stay the same. Current docs are inspected
directly; staging refuses to label them as `/docs/v0.1.0/` before copying.
The historical route and its separate maintenance assembly keep exact release
identities/counts and publication interlocks. See the
[documentation contract](../api-documentation.md) for fingerprint inputs and limits.

The C9.03 real growth runner is
`python -B scripts/compatibility/run_growth_fixtures.py`. It isolates a documented
addition and matched approved/unapproved opt-in-module pair in an ignored source
copy. Synthetic HTML checks qualify the checker boundary, not actual doc-gen;
the real two-pass milestone and cumulative fixture coverage remain C9.07/C9.04.

## C9.04 cumulative qualification

The [qualification record](c9-04-qualification.md) consolidates every approved
Section 3.5 fixture, exact source/dependency applicability, cumulative commands
and expected limitations. It distinguishes real compiler paths, source-only
refusals and synthetic classification/HTML. The runnable focused compatibility
suite is `scripts/compatibility/test_public_api_compatibility.py`.

## Limits

Equal type representations do not establish equal definition bodies, meanings of
referenced definitions, intended theorem semantics, notation behavior or unchanged
proof trust. Review relevant source changes and retain the existing axiom audit.
Strict representation comparison may also flag harmless elaboration changes;
there is no automatic acceptance of such drift. Source hashes and clean pinned
dependencies provide cooperative provenance, not hostile-process isolation or
cryptographic attestation of compiled artifacts. Current inventory generation
alone does not approve architecture/attribute growth. No mathematical declaration,
supported import, facade alias or dependency is added by C9.01.
