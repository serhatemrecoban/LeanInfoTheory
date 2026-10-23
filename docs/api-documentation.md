# API documentation build

LeanInfoTheory's current and historical API documentation is generated from the elaborated
Lean environment with [`doc-gen4`](https://github.com/leanprover/doc-gen4).
The build is deliberately separate from the library package: downstream users
still acquire only LeanInfoTheory and its pinned mathlib dependency.

## Pinned environment

The nested [`docbuild/lakefile.toml`](../docbuild/lakefile.toml) and
[`docbuild/lake-manifest.json`](../docbuild/lake-manifest.json) pin:

- Lean and mathlib `v4.33.1`, with mathlib commit
  `0df444a360eaa60ab8c11dca51a86af692955474`;
- `doc-gen4` `v4.33.1`, commit
  `e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015`; and
- every transitive documentation-build Git dependency to an exact commit.

The nested project duplicates the root's exact `lean-toolchain` pin, disables
Reservoir resolution, shares the existing package cache, and depends on the
parent LeanInfoTheory package by path. The validator requires both toolchain
files to agree. The root `lakefile.toml` and runtime manifest do not contain
`doc-gen4`.

## Maintained generation and validation

The full documentation build is an explicit release/milestone gate, not part of
the routine `python scripts/validate_release.py` suite. From the repository root,
run:

```powershell
python scripts/validate_release.py api-docs
```

The command builds the exact module facet
`+LeanInfoTheory.Shannon:docs` twice and checks byte stability of the relevant
output across the incremental pass. It requires:

- exactly the supported local module pages in the current full Shannon closure;
- every current supported project declaration exactly once, with a rendered
  declaration header, nonempty type and docstring, and reviewed simp markup;
- source ownership consistent with the source-derived inventory;
- every reviewed lightweight-root export to have its documented canonical target;
- no `sorried` declaration block in a supported local page;
- exclusion of every current non-stable `Basic`, example, and reference module;
- the standard doc-gen runtime/search assets named by the checker; and
- zero rows in doc-gen4's optional definition-equation table.

The 92 `LeanInfoTheory.*` convenience exports do not receive independent
doc-gen declaration blocks because Lean `export` commands do not create new
environment constants. The exact export table in
[`current-public-api.json`](current-public-api.json) and the generated page for each
canonical target jointly document that façade.

Doc-gen also emits documentation for imported Lean, Lake, Std, and mathlib
modules. Those dependency pages are not part of the current LeanInfoTheory
support claim. Likewise, doc generation is not the proof-completeness gate:
the maintained source, build, axiom, and placeholder checks remain
authoritative because doc-gen can technically render declarations that use
`sorry`.

The maintained build sets `DISABLE_EQUATIONS=1`. This omits only doc-gen4's
optional definition-equation extraction; it does not omit declaration names,
headers, types, documentation text, source links, or direct `sorried` markers.
Equation rows are outside the v0.1 documentation contract, and the checker
requires their count to be exactly zero.

The current manifest is schema-validated by exact comparison with a fresh
source-derived generation; the checker also validates the separately reviewed
growth policy. Regeneration cannot approve new imports or attributes. Current
coverage has no historical count ceiling. The 31/601/92/13 counts remain exact
for the historical `v0.1.0` route, whose frozen manifest is unchanged.

The generated pages document elaborated signatures. The separate
[retained structural contract](compatibility/README.md) protects released
signatures and assumptions; neither rendered HTML nor equal type fingerprints
establish unchanged definition bodies or mathematical semantics. Source review
and the maintained trust/consumer checks remain necessary.

### Windows native-build prerequisite

Doc-gen4's pinned `leansqlite` and `UnicodeBasic` dependencies call a
GCC-compatible `cc` and require ordinary C library headers. Lean's bundled
Windows Clang does not supply those headers. Windows validation therefore pins
official Zig `0.16.0` as its native compiler and directly compiles the
project-authored [`CCShim.lean`](../docbuild/CCShim.lean) forwarding executable
with the pinned `lean` and `leanc` tools. Keeping this bootstrap outside the
nested Lake target graph lets the wrapper provide `cc` before doc-gen4's
native dependencies are built.

Download `zig-x86_64-windows-0.16.0.zip` from the
[official Zig 0.16.0 release](https://ziglang.org/download/0.16.0/). Its
reviewed SHA-256 is:

```text
68659eb5f1e4eb1437a722f1dd889c5a322c9954607f5edcf337bc3684a75a7e
```

Then set the full executable path before running the maintained command:

```powershell
$env:LEANINFOTHEORY_ZIG = "C:\path\to\zig.exe"
python scripts/validate_release.py api-docs
```

The validator rejects every Zig version other than `0.16.0`. Ubuntu CI uses
its system `cc`; neither Zig nor the forwarding executable is a runtime
dependency of LeanInfoTheory.

The extracted `zig.exe` is also checked against SHA-256
`086ce9d47ba42f33a514e1a6e04eb1d4a8fa1d75e0868e0213caad447c91e864`,
and the forwarding helper is compiled through the docbuild-scoped Lean
`v4.33.1` toolchain at commit
`819816b2e0a3bf405af45ae5c7af2491d8f5bee6`.

## Source-link modes

The maintained command always chooses a source mode explicitly:

- With `DOCGEN_SRC` unset, it uses `file` links. This is the development and
  local-inspection mode; its output is local and must not be published. Inspect
  current output directly under `docbuild/.lake/build/doc/`.
- With `DOCGEN_SRC=github`, it requires a completely clean checkout and checks
  every project declaration link against the repository's exact 40-character
  `HEAD`, source path, and a valid bounded line range containing the exact
  source declaration line. This permits doc-gen's range to begin at the
  declaration's documentation comment or attributes while still rejecting a
  range that points outside the declaration. Branch links such as `master`,
  `main`, and `HEAD` are rejected. In `file` mode every link must resolve to
  the exact local source file.

The v2 build configuration records doc-gen, Lean, mathlib, source mode/identity,
equation policy, and `api_identity` from `scripts/api_doc_identity.py`.
That identity binds raw current-manifest and retained-contract bytes, frozen
baseline identity, all local Lean source (including bodies and docstrings), root
and nested build configuration/locks, the documentation shim, and the explicitly
listed checker/generator/compatibility inputs. It records every fingerprint input
and verifies the installed pinned documentation Git dependencies. A local checkout
path alone is not a content identity.

The checker revalidates this identity against the current source before using
the output. The two-pass attestation repeats the configuration; the validator
checks source/configuration/dependency equality again before issuing it. Signature,
body or docstring changes invalidate stale evidence even with unchanged manifest
entries. Source-content changes invalidate the attestation/configuration stamp
while retaining incremental build caches. Source-link mode, equation or compiler
configuration changes invalidate the generated mode-sensitive database, data,
manifest and HTML. On Windows,
the pinned Zig and docbuild-scoped Lean prerequisites are checked before that
targeted invalidation, so a missing or invalid prerequisite does not discard a
valid prior documentation output. A failed rebuild leaves no success attestation.

The release-candidate gate runs GitHub mode from a clean exact commit. Tag
publication and live-link verification remain explicitly approved publication
and post-publication work.

## Current C21 milestone — initial local API qualification passed

C21.01--C21.04 and their reviews are closed. Selected C21.05 adds no new
mathematics. The separately authorized initial checkpoint `463021c1493dd2b28e0730dc64fbace3fd29a67a` passed the complete maintained clean routine. Both actual local API build/check passes and the parent inspection of all four new elaborated declarations passed on their recorded inputs. That initial candidate is validation-ready. Final candidate qualification, readiness, cumulative acceptance and closure are established only by `.lit-review/setup/c21-05-completion-20261023.json` and its linked actual current-candidate validation/API applicability, genuine original independent report, complete seventeen-criterion matrix, substantive parent reconciliation and final-source qualification. This wording asserts no future PASS or closure. Every amended checkpoint, including the evidence updates here, requires the complete clean rerun and renewed API applicability before qualification; these initial results do not qualify later writes automatically. The final checkpoint identity belongs in that actual evidence chain, not in a prediction of a commit containing this text.

| Actual evidence | Retained record / identity |
| --- | --- |
| Human milestone approvals | `.lit-review/setup/c21-05-milestone-approval-20261023.json`, SHA-256 `94b252282f81a756b11228b297b7e5479a69e12a8b9a5d10f7495300791dd4b7` |
| Full clean routine at `463021c1493dd2b28e0730dc64fbace3fd29a67a` | `.lit-review/setup/c21-05-clean-01/result.json`, SHA-256 `6c8981a2d3bb5119252c62b1c2fe48ccefcffa1b89a4cd11c2f580a55e32c093` |
| Actual two-pass local API retry 02 | `.lit-review/setup/c21-05-api-retry-02.json`, SHA-256 `399d0a94125797029e22b0f328507fd00d3c517766ec0799a2ae261fda913b29` |
| All four parent API meaning inspections | `.lit-review/setup/c21-05-api-inspection-20261023.json`, SHA-256 `9b016b5c7a120de836f91302e1567d9fae895acf1bbd0435a6339035e17549d7` |
| Actual four-declaration extracts | `.lit-review/setup/c21-05-api-extracts-20261023.json`, SHA-256 `5ae161dd0ce0b38a3adc6d081a7fd10010cb29fa5618380f388ff713957de473` |
| API/inspection/clean applicability | `.lit-review/setup/c21-05-api-applicability-01.json`, SHA-256 `0ac684748ceab720b00ecdc9d630a4f31898279b3313e3dd5153ed526d609d93` |
| API source content / attestation | `9fd39bdc6b51749c437996c0734eea75d03ecdd7bed7d3d08f5ca36f9d337d66` / `44a5d9b96ff81c5438f3245277c9fa2f5e480659639626c6e9e0ffb1d0d3225a` |
| API relevant / full-tree output | `26e57f955a4352af74ae8cbc86770c54789e56e54055f39c83c0a5b46dc3d2a1` / `903adee15aa8491b77eece8bc211234b599e3420d118b0e9736a1c1a50469453` |
| Initial API FAIL, retained | `.lit-review/setup/c21-05-api-initial.json`, SHA-256 `7241e858b0039a9d8ee0be3295f0df42cf638be555e418bfbcda17a21f059ddf` |
| Bounded generated-marker recovery | `.lit-review/setup/c21-05-api-cache-recovery-20261023/result.json`, SHA-256 `f0c9f575d7065aa3bb75520458ece718afb7e03d3a5d6daca36448e2e7b0500c` |

The first API attempt remains FAIL: new-owner declaration data built, but cached final HTML replay omitted its page. The parent preserved the exact three generated final-facet markers before the bounded recovery, with source/configuration/pins unchanged. Recovery is not a passing milestone; the complete two-pass retry and subsequent inspection are separate evidence.

The parent inspected all four actual elaborated signatures, hypotheses,
docstrings, owners and local source links in `Shannon.SourceCodingAsymptotic`.
The inspection checks same-family quantifiers, the eventual cap in the strong
converse, the unrestricted general converse and the exact inline threshold set.
The gate used reviewed Zig 0.16.0, local file links and available incremental
caches; no cold-build, browser visual-QA or publication claim is made.
Historical C20 output does not qualify this owner. Recheck source/configuration/
dependency, attestation and output applicability after every amendment.

See the [C21 notes](plans/post-release-chunk-21-notes.md#13-c2105-cumulative-qualification-and-maintained-handoff)
and [maintained handoff](handoffs/chunk-21.md). The actual completion record and
its linked evidence determine any final qualification or closure under the
conditions above. All seventeen criteria require fresh independent consideration
and substantive parent reconciliation; neither a native status nor this initial
API milestone substitutes for those obligations. Publication and frozen-route
staging are unauthorized.

## Historical C20 milestone — local API qualification

The approved C20 plan and explicit Step 5 selection authorize this local milestone.
Both actual file-mode build/check passes have succeeded with reviewed Zig 0.16.0.
The parent inspected all 24 C20 additions: the generic Fano event bridge, twelve
SourceCoding declarations and eleven CodingRate declarations, including each
elaborated signature, hypothesis, docstring, owner and local source link.
Current coverage is 745 public declarations in 49 owners, with 92 root exports,
94 reviewed simp names and 41 non-stable exclusions.

Exact configuration/source/attestation identities and original failures are in
the [C20 notes](plans/post-release-chunk-20-notes.md#15-c2005-cumulative-qualification-and-handoff)
and private Step 5 records. The [maintained handoff](handoffs/chunk-20.md)
distinguishes these warm/incremental local results from pending authorized
clean-checkpoint qualification, cumulative review and source-bound closure.
Generated output stays in `docbuild/.lake/build/doc/`; no publication or frozen
release-route staging is authorized. Reassess source/configuration/dependency
applicability after every amendment; prose status is not a completion certificate.

## Historical C19 milestone — initial qualification

The lead approved the exact 23-path local checkpoint, necessary C19.05-only
amendments, reuse of the existing detached validation checkout, and the separate
actual two-pass local API-documentation milestone.

Initial checkpoint `66b65b9e14af0d10cd127b66ad1f3d16f8cea3fd` passed the complete
`python scripts/validate_release.py` routine in the clean validation checkout.
API01 remains **FAIL**: its first build completed (6361 jobs), but the semantic
check found the new AEP and TypicalSet HTML pages missing after cached final
HTML replay. The parent preserved and moved only the final HTML marker and its
`.trace`/`.hash` companions; source, pins, checkers and Git identity were unchanged.
This bounded generated-cache recovery is not passing API evidence.

The parent reran `python scripts/validate_release.py api-docs` as API02 in the
primary checkout in file mode, using reviewed Zig 0.16.0. Both actual build/check
passes of API02 succeeded. The parent inspected all eight new declarations' actual
signatures, hypotheses, docstrings, owners and local source links, and verified
API-source correspondence to that clean checkpoint. These are warm/incremental
executions and local output, with no cold-build or publication claim.
Clean correspondence is byte-identical for 109/110 API inputs and 102/103 validation
inputs. The sole `docs/v0.1-public-api.json` difference is the existing maintained
LF/CRLF two-hash allowance: uniform CRLF-to-LF bytes and parsed values agree, and
the clean file equals the requested Git blob. Primary API02 inputs are unchanged.
Later applicability checks retain that explicit correspondence, configuration, dependencies and
the two owner pages; whole-tree validity is reused from completed API02 and its
original wrapper check, without claiming a fresh whole-tree rehash.

API source-content SHA-256: `379a1d1f9b542279941b11b78bfd0c1b4f032e85a86abdd149147e2824b708bf`.
Configuration SHA-256: `ddf4e00291e15a882bfd8de74a166591d706f3e93eae99d9b6df74a31a3f11ba`.
Two-pass attestation SHA-256: `f544cbfac344b81539655e2345c65819d41265fca1b622117170a590e1ef7491`.
Applicability covers 110 API input files and 103 compiled-validation
input files with their recorded dependencies and the one explicit frozen-manifest
line-ending correspondence above. Original commands, complete logs and
before/after identities are retained under `.lit-review/setup/c19-05-20261020/`
in `checkpoint-01/`, `clean-01/` and successful `api-milestone-02/`. The original
`api-milestone-01/` failure and `api-cache-recovery-01/` marker-move evidence remain
separate; neither supports a passing criterion. `api-inspection.json` records the
parent's API02 substantive inspections separately from automated extraction.
`api-cache-recovery-guard-failure.json` separately retains the parent's observed
first recovery-helper refusal before any move or output-directory creation;
its tuple/list comparison diagnosis is distinct from the actual API01 failure.
`api-applicability-attempt01-observation.json` retains the later private guard
refusal before the inspection record: it overlooked that maintained frozen-file
allowance, created no record and changed no source/workflow. API02 remains PASS.

| Declaration | Owner | Signature/hypotheses/docstring/source link |
| --- | --- | --- |
| `card_weakTypicalSet_le` | `Shannon.TypicalSet` | Inspected |
| `mem_weakTypicalSet` | `Shannon.TypicalSet` | Inspected |
| `prob_mul_exp_le_card_weakTypicalSet` | `Shannon.TypicalSet` | Inspected |
| `selfInfo_iid_of_mem_support` | `Shannon.SemanticBridge.AEP` | Inspected |
| `tendsto_prob_weakTypicalSet` | `Shannon.SemanticBridge.AEP` | Inspected |
| `tendsto_selfInfo_iid_deviation` | `Shannon.SemanticBridge.AEP` | Inspected |
| `weakTypicalSet` | `Shannon.TypicalSet` | Inspected |
| `weakTypicalSet_mass_bounds` | `Shannon.TypicalSet` | Inspected |

These are initial qualification facts. Any amended checkpoint requires the complete
clean rerun and exact API-evidence applicability assessment. The fresh all-sixteen-
criterion review, original-report reconciliation, final validation and F capture
are established only by their actual source-bound records. Final closure depends on
`.lit-review/setup/c19-05-completion-20261020.json`, when present, and its linked completion chain;
this prose asserts no future gate, review result or closure. C20--C24 and publication
remain unselected.

See the [C19 handoff](handoffs/chunk-19.md). The C18 account below is historical evidence.

## Historical C18 milestone

C18 adds fifteen theorems across semantic FiniteProduct, ProductKL,
ProductChannel, FiniteFamily and FiniteFamilyIndependence. Current source
coverage is 713 documented declarations in 45 supported owners, with 92 root
exports, 94 reviewed simp declarations and 36 non-stable exclusions.

<!-- c18-06-api-docs:start -->
Both actual current file-mode build/check passes passed; the full successful
gate took 693.925 seconds. The parent inspected all fifteen new
declaration signatures, hypotheses, docstrings, owners and local source links
against the v2 content/configuration identity and two-pass attestation. Guarded
Real KL, swapped conditional-output entropy, actual marginals, full output mutual
independence, unrestricted length and arbitrary-source/four-universe statements
match source. This was semantic HTML inspection, not browser visual QA.
The first missing-page failure and bounded three-marker recovery remain retained.
All source/configuration/dependency inputs were unchanged during the successful
gate; evidence-prose changes require separate applicability. Existing caches
were used. Under the lead's scoped checkpoint/amendment/reuse approval, initial
checkpoint `8b30dc96e89a9b4e0224b059faed48e19a4e5f1e` passed the complete
maintained clean routine separately. Readiness, fresh cumulative review,
reconciliation, exact final applicability and closure require their actual
source-bound records, including `.lit-review/setup/c18-06-completion-20261018.json`
when present; this captured account does not certify them. Every amendment
requires the complete maintained clean rerun and exact API applicability.
<!-- c18-06-api-docs:end -->

The [C18 handoff](handoffs/chunk-18.md) records captured qualification and evidence boundaries.
Actual local output stays under `docbuild/.lake/build/doc/`; the frozen v0.1.0
route, dependencies and build/checker contracts are unchanged. The API gate,
complete maintained clean routine, cumulative independent review and exact
closure retain separate evidence and applicability requirements.

## Historical C14 milestone

C14 adds `Shannon.Continuity` and six public declarations. Current coverage is
653 documented declarations in 36 supported owners, with 92 root exports,
94 reviewed simp declarations and 24 non-stable exclusions. Inspect the exact-TV
entropy statement, total capped scalar definition, monotonicity on nonnegative
budgets and the three entropy/conditional-entropy/MI budget statements. Preserve
Nat subtraction, independent coordinate universes, the sole TV-budget premise,
and separate joint/marginal cardinalities and thresholds.

<!-- c14-04-api-docs:start -->
Both actual current file-mode build/check passes passed (160.9s and 22.0s),
followed by inspection of all six new declaration blocks and the full Shannon
umbrella against the v2 source/configuration identity and two-pass attestation.
The original missing-Continuity-page failure and bounded three-marker repair
remain separately recorded. The recovered run kept all tracked/unignored source
unchanged. Later result-recording prose does not alter the exact API inputs;
applicability is checked separately. Existing pinned dependencies/caches were used.
The clean routine, cumulative review and closure remain pending.
<!-- c14-04-api-docs:end -->

The [C14 handoff](handoffs/chunk-14.md) records source/configuration identities,
original checks, failures and limits. Current output stays in
`docbuild/.lake/build/doc/`, outside the frozen release route. Exact applicability
must be checked after any source amendment; caches may be reused without calling
this a cold rebuild.

## Historical C13 milestone

C13 added `Shannon.SemanticBridge.Pinsker` and five public theorems. Its milestone
coverage was 647 documented declarations in 35 supported owners, with 92
canonical exports, 94 reviewed simp declarations and 23 non-stable exclusions.
The new page must retain canonical ENNReal KL, both explicit support guards,
the constant two and the two MI forms without public measurable-space premises.
The [C13 handoff](handoffs/chunk-13.md) and private C13.04 records retain the actual
checks and their limits. Both actual build/check passes succeeded (112.2s and
14.6s), followed by all-five-declaration inspection and v2 attestation checks.
The initial missing-Pinsker-page failure and bounded aggregate-marker repair
remain separately recorded. Exact applicability is checked after amendments.
C12 output is historical and cannot qualify the new source. The clean routine
suite and cumulative review remain separate requirements. Current generated
output stays in `docbuild/.lake/build/doc/`, outside the frozen release route.

## Historical C12 milestone

C12 adds the supported `Shannon.SemanticBridge.Gluing` owner and four public
theorems across Gluing, Coupling and FiniteChannel. That milestone covered 642
documented declarations in 34 supported modules, with 92 canonical exports,
94 reviewed simp declarations and 21 non-stable modules excluded.
C12.04's preparation completed both actual current file-mode passes and
inspection of all four new declarations, including the new Gluing page.
The initial stale aggregate-HTML-marker failure and bounded recovery are retained
separately from that success; exact applicability must be checked after changes.
The [C12 handoff](handoffs/chunk-12.md) and private C12.04 evidence retain the exact
source/configuration identity, output attestation, observations and failures.
Earlier C11 output is historical evidence and does not qualify the C12 source.
The full clean routine suite and fresh cumulative review are separate duties.
Current output stays local and separate from the frozen release route.

## Historical C11 milestone

C11 adds `LeanInfoTheory.Probability.Coupling` and its ten public declarations.
The explicitly authorized initial C11 checkpoint
`2147dd3449af620f41d9bed8d37c5be8252f20e8` completed both real checked file-mode
passes: `234.8s and 19.9s`, with 638 declarations, 33 supported module pages,
92 canonical export targets, 19 non-stable exclusions and zero equation rows.
`.lit-review/setup/c11-06-api-docs-recovered-20260927/result.json` preserves the original result. `.lit-review/setup/c11-06-api-doc-inspection-utf8-20260927.json` records the
actual Coupling page, all ten signatures/docstrings and correct ownership.
The v2 attestation is `docbuild/.lake/build/api-doc-build-attestation.json`, with
its original source/configuration/dependency evidence retained privately.

The run used local file mode, disabled equation extraction and the reviewed
Windows Zig executable. The [maintained C11 handoff](handoffs/chunk-11.md) identifies original evidence
and applicability limits. Amended candidates require exact attestation
applicability or a new complete two-pass run. Source-bound C11.06 private records
establish final validation, cumulative review, reconciliation and closure.
Current local output must not be staged under the frozen release route.

The first API-doc run failed its semantic check because the generated manifest
omitted the new Coupling HTML page, although Coupling and Shannon docInfo rebuilt.
The original failure remains at
`.lit-review/setup/c11-06-api-docs-checkpoint-20260927/result.json`. The recovery
record `.lit-review/setup/c11-06-doc-marker-recovery-20260927.json` preserves the
bytes of exactly three ignored Shannon HTML completion-marker/hash/trace files
before their invalidation. The complete two-pass rerun passed at
`.lit-review/setup/c11-06-api-docs-recovered-20260927/result.json`. No maintained
source, validator, dependency pin or API contract changed. Both attempts replayed
upstream Qq docInfo warnings for `mkLambdaQ` and `withLetHave`; all current
supported signatures passed the successful rerun's semantic checks.

The first page inspector saved all ten successful declaration checks before its
console output failed on a Unicode symbol. The same read-only inspector passed
with Python UTF-8 output; the original inspection and the console-error
observation remain preserved beside the successful inspection record.

## Historical C10 milestone evidence and applicability

The initial C10.07 gate completed both real file-mode passes, covering 628
documented declarations across 32 supported module pages, 92 canonical export
targets, 17 excluded non-stable modules and all 25 TV declarations. The current
v2 source-content attestation and original process results are identified in the
[C10 handoff](handoffs/chunk-10.md) and source-bound private records.
The clean routine suite and fresh full-chunk review also succeeded, with the
original review explicitly reconciled. Final amended-candidate validation, exact
API-doc/review applicability and completion are established by C10.07's
source-bound private records. This maintained chronology does not itself certify
closure. Counts and stale output do not qualify changed inputs. No current output is staged under
`/docs/v0.1.0/` or published by this work.

Historical C9.07 qualified the then-current 603 declarations, 31 owners,
92 export targets and 15 non-stable exclusions. Its [handoff](handoffs/chunk-9.md)
and private closure preserve that result. C10's added owner, declarations and
consumers invalidate reuse of the old current-source attestation.

## Verified local result and cost

The following measurements describe historical release-preparation output;
they do not validate the current development source.

The completed Step 11 file-mode run produced 31 supported LeanInfoTheory module
pages, 601 rendered-signature declarations, 92 resolved canonical export
targets, 13 enforced non-stable exclusions, and zero equation rows. The full
local/unpublished doc tree, including dependency documentation and runtime
assets, contains 5,521 files and is 624.6 MiB.

One diagnostic first pass in the existing working tree took 17,547.3 seconds
(4h 52m 27.3s) after a nested docbuild clean had removed shared package build
artifacts; its immediate incremental pass took 154.8 seconds. This was neither a
fresh checkout nor clean/cold-checkout evidence. An earlier fully warm pair
completed in 5.5 seconds per pass. After the independent-review fixes, the
maintained two-pass gate completed in 31.8 seconds and 11.9 seconds with the
same relevant-output digest,
`fa46bbc0de9359ea1e14e79d9e3bce9ac425f33cb2e9efb54086a4e28d6730fe`.

That digest intentionally covers the generated manifest, all supported local
module pages, and the required runtime assets. It is an incremental stability
check for the maintained surface, not a committed signature fingerprint and not
a byte promise for every imported dependency page. Remote runner capacity is
recorded by the Step 16 exact-candidate validation report rather than embedded
in this source snapshot.

## Continuous integration boundary

Ordinary push and pull-request CI runs the routine release gates and excludes
the full doc-gen build. The workflow exposes a boolean `api_docs` input only for
manual `workflow_dispatch`; when enabled, a separate GitHub-mode job runs after
the normal gates with a maximum timeout of 360 minutes. A successful exact-
candidate run, identified in the external validation report, is the capacity
evidence.

## Versioned website staging and local inspection

Generated output is intentionally ignored under:

```text
docbuild/.lake/build/doc/
```

Current v2 docbuild output is for direct inspection and is refused before any
copy into `/docs/v0.1.0/`, even while its names and counts still equal the release.
Legacy v1 preview is accepted only with an exact, clean release checkout and
matching local source identity. A new published current API route requires separate authorization.
The unversioned declaration index labels its `master` source links as current
development and warns that dirty local lines may differ. Maintenance staging
rebinds those links to its exact site commit; publishable checks still reject
mutable source links.

The historical raw doc-gen tree was an input, not the website artifact. Step 12 added
[`stage_website.py`](../scripts/stage_website.py), which assembles the tracked
site and the generated reference under the Pages-shaped project subpath
`.lake/website-stage/LeanInfoTheory/`. Preview mode requires the checked
file-source build, replaces all 151,458 machine-local source links with a clear
`source unavailable in local preview` marker, repairs 5,496 missing `#top`
targets in generated pages, and writes both structured provenance and a
`NOT_FOR_PUBLICATION.txt` interlock. It does not rewrite local links into
unverified branch links.

Staging also requires `api-doc-build-attestation.json`. The API-doc gate removes
any previous attestation before it starts and writes a replacement only after
both checked passes, repository-state preservation, and digest equality have
succeeded. That historical attestation bound all 5,521 copied input files to
SHA-256 `838335fb72d891ad9e6dd090e1556ed225c13b1408b754ed8a8da32f12b34fbe`
and records the supported-surface digest
`fa46bbc0de9359ea1e14e79d9e3bce9ac425f33cb2e9efb54086a4e28d6730fe`.
The staging command recomputes the complete-tree digest before replacing its
owned destination, so a stale, failed, or manually altered ignored build cannot
be promoted merely by retaining an old configuration file.

The generated API is served at the stable versioned route `/docs/v0.1.0/`.
Navigation connects the hand-written project site, the generated reference,
the supplementary source inventory, licensing/provenance information, and a
route back from every generated page. The tracked route contains an explicit
placeholder so the checked source tree never pretends to contain the ignored
624.6 MiB artifact.

For an exact historical release checkout only, assemble and validate its local
preview after a successful historical documentation build:

```powershell
python scripts/stage_website.py preview
python scripts/check_website.py --site-root .lake/website-stage/LeanInfoTheory --mode preview
python -m http.server 8000 --directory .lake/website-stage
```

Then open `http://localhost:8000/LeanInfoTheory/`. The Step 12 served-preview
checks exercised project-subpath navigation, search, declaration deep links,
the generated `find` redirect, imported-by and instance population, theme
selection, runtime assets, return navigation, source-link suppression, and the
404 fallback.

The full staged check covers 5,520 HTML files, 2,951,158 links/assets, two
generated JSON files, and 654,015,176 bytes. It reports zero project-owned or
runtime failures. It also records 111 non-blocking link advisories originating
inside imported upstream dependency documentation. Those pages are included
for doc-gen navigation but are outside the 31-module LeanInfoTheory support
claim; the advisories must be reassessed in the clean publication candidate
rather than represented as project-owned link correctness. Their reviewed
breakdown is 109 missing targets and two casing mismatches, and the checker pins
the full sorted-message SHA-256
`bf8682253b1141fa6d97226f32d94fe599e4af7e4f69d8e363609f2155cfdd12`;
any count, kind, or message drift is blocking until reviewed.

`release` staging is intentionally frozen: it accepts only the clean immutable
`v0.1.0` checkout at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, requires GitHub-mode doc-gen
output for that exact commit, and produces the self-contained versioned API
artifact. Post-release `maintenance` staging then copies the current tracked
`home_page/`, pins its Lean source links to the current clean `master` commit,
and inserts the already validated `/docs/v0.1.0/` tree byte-for-byte. Root
composition metadata records the current-site identity and frozen API identity
separately and hashes the entire frozen route; the version route retains its
original release metadata.

The Pages workflow therefore uses two checkouts: current `master` supplies the
unversioned project-status pages, while the exact release commit supplies the
signature-bearing `v0.1.0` API. The publishable checker requires every project
source link below `/docs/v0.1.0/` to use the release commit and every deployed
unversioned Lean source link to use the current site commit. Mutable
`master`/`main`/`HEAD` blob links remain forbidden. The workflow remains
manual-only, prepares and uploads a checked artifact when `publish=false`, and
runs the separately permissioned deploy job only after the user explicitly
selects `publish=true`.

## Third-party provenance

Doc-gen4 is an Apache-2.0-licensed build-only dependency and is not vendored
into LeanInfoTheory. The generated tree copies 13 identified doc-gen runtime/
search assets and also contains imported dependency documentation. The staged
artifact carries the root Apache-2.0 licence plus an indexed set of exact
upstream licence files for doc-gen4, Lean 4/Lake/Std/Init, mathlib, Aesop,
Batteries, ImportGraph, LeanSearchClient, Plausible, ProofWidgets, and Qq. It
records the exact Lean, mathlib, doc-gen, and dependency revisions and
identifies four externally loaded font/polyfill/MathJax resources. The concrete
inventory found no reason to add a redundant root `NOTICE`, and the Step 14
attribution review confirmed that final determination. Exact upstream licence
copies and the provenance inventory remain part of the assembled artifact.
Project EPFL/MIL headers are not applied to upstream or generated material.
