# API documentation build

LeanInfoTheory's release API documentation is generated from the elaborated
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

- exactly the 31 supported local module pages in the full Shannon closure;
- all 601 supported project declarations, each exactly once, with a rendered
  declaration header and nonempty type;
- source ownership consistent with the source-derived inventory;
- all 92 lightweight-root exports to resolve to documented canonical targets;
- no `sorried` declaration block in a supported local page;
- exclusion of all 13 non-stable `Basic`, example, and reference modules;
- the standard doc-gen runtime/search assets named by the checker; and
- zero rows in doc-gen4's optional definition-equation table.

The 92 `LeanInfoTheory.*` convenience exports do not receive independent
doc-gen declaration blocks because Lean `export` commands do not create new
environment constants. The exact export table in
[`v0.1-public-api.json`](v0.1-public-api.json) and the generated page for each
canonical target jointly document that façade.

Doc-gen also emits documentation for imported Lean, Lake, Std, and mathlib
modules. Those dependency pages are not part of the 31-module LeanInfoTheory
support claim. Likewise, doc generation is not the proof-completeness gate:
the maintained source, build, axiom, and placeholder checks remain
authoritative because doc-gen can technically render declarations that use
`sorry`.

The maintained build sets `DISABLE_EQUATIONS=1`. This omits only doc-gen4's
optional definition-equation extraction; it does not omit declaration names,
headers, types, documentation text, source links, or direct `sorried` markers.
Equation rows are outside the v0.1 documentation contract, and the checker
requires their count to be exactly zero.

The versioned public-API manifest records declaration names, kinds, owners,
attributes, and exports, but it does not contain type/signature fingerprints.
The generated pages therefore show and validate nonempty signatures for the
current elaborated tree without creating a committed type fingerprint or
independently freezing signatures. Signature and assumption changes remain
governed by the compatibility policy and explicit API review.

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
  local-preview mode; its output is local and must not be published.
- With `DOCGEN_SRC=github`, it requires a completely clean checkout and checks
  every project declaration link against the repository's exact 40-character
  `HEAD`, source path, and a valid bounded line range containing the exact
  source declaration line. This permits doc-gen's range to begin at the
  declaration's documentation comment or attributes while still rejecting a
  range that points outside the declaration. Branch links such as `master`,
  `main`, and `HEAD` are rejected. In `file` mode every link must resolve to
  the exact local source file.

The build records its doc-gen, Lean, mathlib, source-mode/source-identity, and
equation configuration. If that stamp changes, the validator invalidates only
the mode-sensitive documentation database, data, manifest, and HTML before
rebuilding, rather than reusing links from a prior configuration. On Windows,
the pinned Zig and docbuild-scoped Lean prerequisites are checked before that
targeted invalidation, so a missing or invalid prerequisite does not discard a
valid prior documentation output.

The release-candidate gate runs GitHub mode from a clean exact commit. Tag
publication and live-link verification remain explicitly approved publication
and post-publication work.

## Verified local result and cost

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

The raw doc-gen tree is an input, not the website artifact. Step 12 added
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
succeeded. The current attestation binds all 5,521 copied input files to
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

Assemble and validate the local preview after a successful documentation build:

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

`release` staging is intentionally stricter: it accepts only a clean checkout
whose generated source mode is `github`, requires the recorded identity to be
the exact `HEAD`, and replaces project tag links with that same 40-character
commit. The Pages workflow is manual-only and prepares a checked publishable
artifact before a separately gated deploy job. Step 12 did not run that mode,
publish Pages, or establish remote runner-capacity evidence.

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
