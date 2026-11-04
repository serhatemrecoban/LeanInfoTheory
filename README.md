# LeanInfoTheory

[![Lean build and release gates](https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/lean_action_ci.yml/badge.svg)](https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/lean_action_ci.yml)
[![Deploy website](https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/pages.yml/badge.svg)](https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/pages.yml)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22229598.svg)](https://doi.org/10.5281/zenodo.22229598)

**A machine-checked information theory library for Lean 4.**

Build your next formalization on a substantial foundation of Shannon information
theory: entropy, mutual information, KL divergence, channels, Markov chains, data
processing, Fano inequalities, and sufficient statistics. LeanInfoTheory brings
these tools together in a reusable finite-discrete API built on mathlib.

**811 supported declarations. 57 supported modules.** Version **0.2.0**
adds quantitative probability, independent products, finite-iid source coding
and finite-channel capacity and weak converses. Definitions and theorems are
checked by Lean; release validation rejects proof placeholders.
License: **Apache-2.0**.

[Get started](#installation) ·
[Practical guides](https://serhatemrecoban.github.io/LeanInfoTheory/docs/) ·
[API reference](https://serhatemrecoban.github.io/LeanInfoTheory/docs/v0.2.0/) ·
[Theorem highlights](https://serhatemrecoban.github.io/LeanInfoTheory/theorems.html)

## What you can build

- **Research formalizations:** reuse information identities, inequalities, and
  equality characterizations in your own mathematical arguments.
- **Channel and inference proofs:** work with finite stochastic channels,
  conditional independence, data processing, and sufficient statistics.
- **Information-theoretic tools:** build downstream applications on checked
  mathematical results, without adding application-specific machinery to the
  library itself.

Start with [getting started](home_page/docs/getting-started.html),
[information measures](home_page/docs/information-measures.html), or
[Markov chains and data processing](home_page/docs/markov-data-processing.html).
The [research-project guide](home_page/docs/research-projects.html) explains how
to choose a release, map paper statements to APIs, and keep new mathematics in
the right project.

## Positioning

LeanInfoTheory is a reusable Lean 4 and mathlib library for finite Shannon
information theory. It complements mathlib's existing binary and q-ary entropy,
measure-theoretic KL divergence, and coding foundations with a coherent
finite-`PMF` API for entropy, information measures, channels, semantic bridges,
Markov structure, data processing, finite families, and sufficiency.

Certificate representations, parsers, checking DSLs, import adapters, and
application demonstrations belong to downstream projects. Paper-specific
constructions also remain downstream. Broadly reusable information-theory
results stay in LeanInfoTheory when their ownership and assumptions are general.

<details>
<summary>Release details, validation, and current development</summary>

## Release

Version **0.2.0**, dated **4 November 2026**, expands the library by 210
supported declarations and 26 modules while retaining the original surface.
The [release overview](docs/releases/v0.2.0-publication.md) describes the
mathematical coverage, assumptions and limits. The
[GitHub Releases page](https://github.com/serhatemrecoban/LeanInfoTheory/releases)
is the authoritative list of published tags and release assets; a source checkout
or prepared metadata does not establish publication.

The new mathematical coverage includes total variation, maximal couplings and
transport, Markov gluing, Pinsker, finite-alphabet continuity and topology;
independent finite products and iid blocks; weak AEP and fixed-length source
coding, with achievability strictly above entropy and source converses below
entropy; and attained finite-channel information capacity, product and standard
channel formulas, and actual-code finite/asymptotic weak converses.

Channel-coding achievability, operational channel-capacity equality and a channel
strong converse remain outside this release. Canonical units are **nats**;
finite/nonempty, support, independence and positive-budget hypotheses remain
explicit. These are mathematical existence and bound APIs, with no claim of an
efficient executable codec or a complete textbook formalization.

### Historical v0.1.0

The [original release notes](docs/releases/v0.1.0.md) and versioned documentation
remain available unchanged.

`v0.1.0` is the first public-library release of LeanInfoTheory. It establishes
a reusable finite-information-theory foundation and the source-compatibility
baseline for the `0.1.x` line. Its scope is deliberately foundational: this
release does not claim a complete formalization of information theory or of any
particular textbook or research paper.
The release date is `2026-09-01` in Europe/Zurich. Zenodo archived the immutable
GitHub Release and issued the version DOI
[`10.5281/zenodo.22229599`](https://doi.org/10.5281/zenodo.22229599). The
all-versions DOI is
[`10.5281/zenodo.22229598`](https://doi.org/10.5281/zenodo.22229598). The tagged
`CITATION.cff` and GitHub Release intentionally remain DOI-free. After v0.1.0
publication, default-branch citation metadata recorded the issued version DOI
without moving the tag; the current CFF prepares v0.2.0 with the approved date
`2026-11-04` and no version DOI. Archive verification and any DOI follow-up
remain separate from the immutable tagged citation.

The released `v0.1.0` surface contains 31 modules, 601 documented
project-owned declarations, 92 lightweight-root exports, and 94 reviewed
`simp` declarations. Maintained release validation rejects proof placeholders
and permits only `propext`, `Classical.choice`, and `Quot.sound` as axioms.
Signature-bearing API documentation covers all 601 supported declarations at
the versioned `/docs/v0.1.0/` route, with source links bound to the exact
release commit. The release process also validates a clean exact checkout and
a minimal external Lake consumer.

The historical release and its 601-declaration retained contract remain unchanged.
Validation compares that baseline and the complete 811-declaration surface
independently of current inventory, imports, attributes, documentation and trust.
See the [compatibility checks](docs/compatibility/README.md) for their limits.

</details>

## Installation

LeanInfoTheory `v0.2.0` targets Lean 4 and mathlib `v4.33.1`. Align the
consumer project's `lean-toolchain` with:

```text
leanprover/lean4:v4.33.1
```

For the published v0.2.0 release, add the tagged Git dependency to
`lakefile.toml`. When evaluating an unpublished checkout, use its exact
commit or the local-path instructions below instead of assuming the tag exists:

```toml
[[require]]
name = "LeanInfoTheory"
git = "https://github.com/serhatemrecoban/LeanInfoTheory"
rev = "v0.2.0"
```

Update dependencies, fetch the mathlib cache, and build:

```sh
lake update
lake exe cache get
lake build
```

LeanInfoTheory declares `fixedToolchain = true`. Lake may prioritize that
toolchain during dependency resolution, so a consumer should not silently mix
LeanInfoTheory `v0.2.0` with incompatible Lean, mathlib, or other fixed-toolchain
dependencies. Use the immutable version tag rather than an untagged branch when
reproducibility matters.

### Working from a source checkout

Use the pinned toolchain and build the complete mathematical umbrella:

```sh
lake exe cache get
lake build LeanInfoTheory.Shannon
```

A separate project can instead point to an existing local checkout with the
following path dependency, replacing the example path with its real location:

```toml
[[require]]
name = "LeanInfoTheory"
path = "../LeanInfoTheory"
```

Record the exact source tree and local changes used. A moving path dependency
does not provide an immutable release identity. The marked examples below are
checked in-tree. The [external consumer account](docs/qualification/c24-external-consumer.md)
and [qualification handoff](docs/handoffs/chunk-24.md) record the completed local runs; any successor SHA requires fresh external
compilation. For reproducible use, select a published immutable tag from the
GitHub Releases page and retain the resolved toolchain and manifest.

## Five-minute quick start

Each Lean block in this section is compiled independently with warnings treated
as errors by the maintained release validator. The larger in-tree example
hierarchy is linked below.

### Lightweight root

Use `LeanInfoTheory` for the lightweight finite-PMF and information-measure
surface:

<!-- lean-example:lightweight-root -->
```lean
import LeanInfoTheory

open LeanInfoTheory.Shannon

example : entropy (PMF.pure false) = 0 := by
  exact entropy_pure false
```

### Complete supported umbrella

Use `LeanInfoTheory.Shannon` when dependency weight is not a concern and the
complete supported mathematical stack is wanted:

<!-- lean-example:full-umbrella -->
```lean
import LeanInfoTheory.Shannon

open LeanInfoTheory.Shannon

example (p : PMF (Bool × Bool)) :
    condEntropy p ≤ entropy (fstMarginal p) := by
  exact condEntropy_le_entropy_fstMarginal p
```

### Focused channel import

Channels are ordinary functions `α → PMF β`; an input law `p` is sent through
`W` using `p.bind W`:

<!-- lean-example:focused-channel -->
```lean
import LeanInfoTheory.Probability.FiniteChannel

noncomputable def flipChannel : Bool → PMF Bool :=
  PMF.deterministicChannel Bool.not

example (p : PMF Bool) :
    p.bind flipChannel = p.map Bool.not := by
  exact PMF.bind_deterministicChannel p Bool.not
```

### Convert nats to bits

Canonical information quantities use natural logarithms. Conversion to bits is
an opt-in scalar operation:

<!-- lean-example:nats-to-bits -->
```lean
import LeanInfoTheory.Shannon.Units

open scoped BigOperators
open LeanInfoTheory.Shannon

example (p : PMF Bool) :
    natsToBits (entropy p) =
      ∑ b, -(p b).toReal * Real.logb 2 (p b).toReal := by
  simpa [natsToBits, natsToBase] using entropy_div_log p 2
```

### Keep the real-KL guard

Mathlib's canonical KL divergence is `ENNReal`-valued and can be infinite.
Real-valued consequences therefore retain a support or finiteness guard:

<!-- lean-example:guarded-real-kl -->
```lean
import LeanInfoTheory.Shannon.SemanticBridge.KL

open LeanInfoTheory.Shannon
open MeasureTheory

example {α : Type*} [Finite α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) (h : p.support ⊆ q.support) :
    (InformationTheory.klDiv p.toMeasure q.toMeasure).toReal = 0 ↔ p = q := by
  exact toReal_klDiv_pmf_eq_zero_iff p q h
```

## Choosing imports

The table describes v0.2.0. Rows marked **New in v0.2.0** extend the
original foundation; the frozen v0.1.0 manifest gives the historical surface. Umbrella imports load the supported stack of the version used.

| Import | Intended use |
| --- | --- |
| `LeanInfoTheory` | Lightweight finite-PMF support, entropy, and elementary information measures. |
| `LeanInfoTheory.Shannon` | Complete supported mathematical umbrella. |
| `LeanInfoTheory.Probability.FiniteChannel` | Raw PMF-valued channels and elementary channel laws. |
| `LeanInfoTheory.Shannon.EntropyBounds` | Sharp alphabet- and support-cardinality entropy bounds. |
| `LeanInfoTheory.Shannon.Fano` | Deterministic decoding error and finite Fano inequalities. |
| `LeanInfoTheory.Shannon.FiniteFamily` | Dependent finite families and chain-rule algebra. |
| `LeanInfoTheory.Shannon.Units` | Scalar conversion from nats to another valid base or bits. |
| `LeanInfoTheory.Shannon.SemanticBridge` | Complete conditional-law, KL, independence, Markov, data-processing, convexity, finite-family, Pinsker and sufficiency bridge in current source; Pinsker is new in v0.2.0. |
| `LeanInfoTheory.Shannon.SemanticBridge.Pinsker` | **New in v0.2.0:** canonical ENNReal Pinsker, support-guarded Real bounds and quantitative independence in nats. |
| `LeanInfoTheory.Probability.TotalVariation` / `Coupling` | New in v0.2.0: TV, maximal couplings and coupling transport. |
| `LeanInfoTheory.Probability.FiniteProduct` / `Iid` | New in v0.2.0: independent products and finite iid blocks. |
| `LeanInfoTheory.Shannon.SemanticBridge.AEP` | New in v0.2.0: finite-iid weak AEP and typical-set probability limit. |
| `LeanInfoTheory.Shannon.SourceCodingAsymptotic` | New in v0.2.0: fixed-length source achievability, converse and threshold APIs. |
| `LeanInfoTheory.Shannon.ChannelCapacity` / `StandardChannelCapacity` | New in v0.2.0: attained information capacity and standard-channel formulas. |
| `LeanInfoTheory.Shannon.ChannelCodingAsymptotic` | New in v0.2.0: vanishing-error rate upper bounds and weak-converse obstructions. |

Focused semantic submodules remain supported imports when the full bridge is
unnecessary. The exact historical supported list and frozen declarations are in
the [`v0.1.x` public API contract](docs/v0.1-public-api.md) and its
[frozen release manifest](docs/v0.1-public-api.json). The
[current manifest](docs/current-public-api.json) records the complete v0.2.0
surface; post-v0.1.0 modules such as Pinsker are absent from the frozen release.

`LeanInfoTheory.Basic`, `LeanInfoTheory.MathlibFragments`, and the
`LeanInfoTheory.Examples` hierarchy are maintained development, reference, and
regression anchors, but they are not part of the supported release API. Neither public
mathematical umbrella imports them.

## Supported mathematical scope

The retained foundation includes:

- finite `PMF` support, real-mass, map, bind, mixture, product, marginal, and
  raw channel utilities;
- finite entropy, conditional entropy, mutual information, conditional mutual
  information, their random-variable forms, and pair/triple/family chain rules;
- entropy bounds and equality cases, deterministic processing, recovery,
  submodularity, subadditivity, and finite Fano inequalities;
- finite-family entropy and information algebra, including dependent alphabets
  and mutual-independence equality characterizations;
- semantic conditional-law and expected-self-information views;
- finite PMF bridges to mathlib KL divergence, including support/finiteness,
  equality, log-sum, convexity, conditional-KL, and data-processing results;
- ordinary and conditional independence, finite Markov chains, stochastic
  channels, posteriors, and information-processing theorems; and
- fixed-prior and model-family sufficiency, exact recovery, Fisher--Neyman
  factorization, and guarded KL-preservation characterizations.

The mathematical development draws on standard references, including Thomas M.
Cover and Joy A. Thomas, *Elements of Information Theory* (John Wiley & Sons,
1991). See the [foundation conventions](docs/foundation-conventions.md) for the
broader reference set and the conventions used when adapting textbook
statements to Lean and mathlib.

## Mathematical conventions and limitations

- Canonical real-valued entropy and information quantities are measured in
  **nats**, matching mathlib's natural-logarithm APIs. `natsToBase b` is
  algebraically total, but its information-theoretic interpretation requires
  `1 < b`; `natsToBits` is the base-two specialization.
- Random-variable quantities are defined through pushforward laws using
  `PMF.map`. Product types are right-associated.
- Finite-alphabet assumptions remain visible in theorem statements. Source
  probability spaces are not made finite merely because a random variable has
  a finite codomain.
- Support-sensitive results keep their support hypotheses. Total conditional
  laws may use a documented fallback on null fibers, but no theorem assigns
  probabilistic meaning to that fallback.
- `InformationTheory.klDiv` remains canonically `ENNReal`-valued. Do not treat
  `ENNReal.toReal ⊤ = 0` as a finite KL value; establish support inclusion,
  absolute continuity, or another finiteness guard before real conversion.
- Channels remain functions `α → PMF β`; the library does not introduce a
  second bundled finite-channel abstraction.

Version 0.2.0 adds the quantitative, product, AEP, source-coding and
information-capacity areas described in the [release overview](docs/releases/v0.2.0-publication.md).
Channel achievability, operational channel-capacity equality and a channel strong
converse remain excluded. Continuous/differential entropy, general stationary or
ergodic source coding, randomized/list decoding, feedback, cost constraints and
variable/prefix coding are not supplied by these finite fixed-length results.
See the [limitations register](docs/lean-info-theory-living-summary.md#11-known-limitations-and-open-questions).

## Compatibility policy

The complete v0.2.x supported surface retains public module paths, project-owned
names, namespaces, types, assumptions, documented semantics, root exports and
reviewed attributes. No breaking migration is selected. A minor version number
does not waive a retained contract; a necessary breaking change needs an explicit
migration decision. Private declarations, proof terms, generated names, imported
mathlib declarations and explicitly non-stable modules are outside this promise.

The original 601-declaration contract remains a separate historical comparison.
The complete 811-declaration comparison retains elaborated types, universes,
ownership, import boundaries, root exports and reviewed attributes. Source
inventory and rendered documentation do not establish compatibility by themselves,
and equal types do not prove unchanged definition bodies or mathematical semantics.
See the [release contract](docs/v0.2-release-contract.md) and
[retained-API account](docs/compatibility/README.md).

## Examples and documentation

### Perfect Functional Representations case study

[PerfectFunctionalRepresentationsLean](https://serhatemrecoban.github.io/PerfectFunctionalRepresentationsLean/)
formalizes the definitions and main results of *On Perfect Functional Representations*,
within its documented finite-alphabet, support and auxiliary-variable qualifications.
It was completed using unchanged LeanInfoTheory v0.1.0, with paper-specific
constructions kept downstream. It demonstrates historical library reuse.

Historical use of v0.1.0 and the independent compatibility validation of v0.2.0
are distinct evidence. The [research-project guide](home_page/docs/research-projects.html#pfr-case-study)
describes the reuse lessons and the boundary between general library results and
paper-specific downstream constructions.

### Guides and examples

- [Getting started with information theory in Lean](home_page/docs/getting-started.html).
- [Entropy, mutual information, and KL divergence](home_page/docs/information-measures.html).
- [Markov chains and data processing](home_page/docs/markov-data-processing.html).
- [Formalizing a research paper](home_page/docs/research-projects.html).
- [LeanInfoTheory and mathlib](home_page/docs/mathlib.html).

Maintained Lean examples include:

- [`LeanInfoTheory.Examples.Units`](LeanInfoTheory/Examples/Units.lean) covers
  arbitrary-base, entropy, MI, CMI, and guarded real-KL conversion.
- [`LeanInfoTheory.Examples.SupportSensitive`](LeanInfoTheory/Examples/SupportSensitive.lean)
  covers support-cardinality bounds, null fibers, functional dependence, and
  recovery.
- [`LeanInfoTheory.Examples.StochasticChannels`](LeanInfoTheory/Examples/StochasticChannels.lean)
  covers stochastic channels, cascade support, KL contraction, and entropy
  growth.
- [`LeanInfoTheory.Examples.SufficientStatistics`](LeanInfoTheory/Examples/SufficientStatistics.lean)
  covers fixed-prior and family sufficiency, recovery, posterior, and KL
  boundaries.
- [`LeanInfoTheory.Examples.Fano`](LeanInfoTheory/Examples/Fano.lean) and
  [`LeanInfoTheory.Examples.FiniteFamily`](LeanInfoTheory/Examples/FiniteFamily.lean)
  provide concrete Fano and dependent-family consumers.

The non-stable [`LeanInfoTheory.Examples`](LeanInfoTheory/Examples.lean)
aggregate builds all maintained examples. The
[foundation conventions](docs/foundation-conventions.md) explain representation
and semantic choices. The source-derived
[declaration index](home_page/docs/api-index.html) remains a lightweight
supplement. The separate [signature-bearing API documentation
gate](docs/api-documentation.md) renders the current supported surface for local
inspection. The v0.2.0 API entry links to its complete versioned snapshot at
`/LeanInfoTheory-API/v0.2.0/`; the historical `/docs/v0.1.0/` route remains bound
to its original 601-declaration source. The supporting website is
<https://serhatemrecoban.github.io/LeanInfoTheory/>.

<details>
<summary>Contributor build and release procedures</summary>

## Reproducing maintained builds

The repository validator requires Python 3.11 or newer; ordinary Lake consumers
do not need Python or documentation-build tools at runtime. Obtain the release
snapshot with Git, Elan/Lake, and Python 3.11+ available:

```sh
git clone --branch v0.2.0 --depth 1 https://github.com/serhatemrecoban/LeanInfoTheory.git
cd LeanInfoTheory
lake exe cache get
python scripts/validate_release.py
```

The validator runs the default build and the eight-target warning-as-error
build, compiles every marked README example independently, verifies every
supported direct-import closure, checks the retained API, root exports, `simp`
surface, and approved axiom allowlist, scans for proof placeholders and
implementation shortcuts, checks generated artifacts and the website twice,
and finishes with strict repository hygiene. Run it from a clean checkout: it
rejects staged, unstaged, and unignored untracked files. The repository's LF
checkout policy keeps Lake manifests byte-stable on Windows as well as Unix.
This routine suite deliberately excludes the much heavier signature-bearing
documentation build.

On the development branch, `static` checks the exact generated current inventory
and reviewed growth policy, while `trust` also runs standalone retained
compatibility and audits every compiled project constant, including private and
non-stable code. Regeneration cannot approve an import or attribute change.

Useful focused commands are:

```sh
python scripts/validate_release.py documentation
python scripts/validate_release.py focused LeanInfoTheory.Shannon.FiniteFamily
python scripts/validate_release.py static
python scripts/validate_release.py compatibility
python scripts/validate_release.py trust
```

At release and documentation milestones, run the separate API-documentation
gate explicitly:

```sh
python scripts/validate_release.py api-docs
```

Linux uses a system `cc`. On Windows this command requires the exact reviewed
`zig.exe` from the official Zig 0.16.0 x86_64 archive, supplied through
`LEANINFOTHEORY_ZIG`; the validator checks both its version and SHA-256. This is
a build-only prerequisite, not a LeanInfoTheory dependency. The command defaults
to local `file:` source links, so its raw output is not publishable. Inspect
current development output directly under `docbuild/.lake/build/doc/`.
Its source-content attestation is invalidated by signature, body or docstring
changes even if the current manifest is unchanged. Current output cannot be
staged as `/docs/v0.1.0/`; historical preview/release staging requires the exact
release source, and maintenance combines a separately validated frozen route.
A clean exact-commit release reproduction
instead sets `DOCGEN_SRC=github`. See the
[API-documentation build contract](docs/api-documentation.md) for the exact
compiler hash, source-link rules, output boundary, and measured cost.

Ordinary push and pull-request CI runs only the routine gates. Release
qualification additionally uses manually dispatched, nonpublishing gates for the
signature-bearing API documentation and the complete Pages artifact. The API
documentation job has a 360-minute timeout. Publication remains a distinct,
explicitly authorized operation.

## Controlled release procedure

Publication is deliberately manual. The automatic toolchain-triggered release
workflow has been permanently removed, and ordinary branch pushes cannot
create a tag, GitHub Release, or Pages deployment. The Pages workflow prepares
and validates an artifact on manual dispatch but deploys only when its Boolean
`publish` input is explicitly true.

The release procedure freezes one exact candidate commit, validates it locally,
from a clean checkout, through an external Lake consumer, and through remote
nonpublishing gates, then subjects that same SHA to an independent final review.
GitHub publication, API deployment and main-site deployment each require
explicit authorization. Verify the API site before switching the main site's
stable links, then verify the archive and DOI.

For v0.1.0, the maintainer enabled immutable GitHub Releases, created the annotated
`v0.1.0` tag, published the GitHub Release, allowed Zenodo ingestion, and
deployed the prepared site. The release tag and deployed versioned API both
resolve to commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`.

The approved automatic integration archived the immutable GitHub Release as
[Zenodo record `22229599`](https://zenodo.org/records/22229599).
`CITATION.cff` remains the canonical repository metadata source; no
`.zenodo.json` is used. Zenodo and DataCite record École Polytechnique Fédérale
de Lausanne as the structured `RightsHolder`, while Serhat Emre Coban remains
the sole creator with affiliation `EPFL, Mathematics of Information
Laboratory`. The archived ZIP was verified byte-for-byte against the immutable
tag. The issued DOI and later default-branch citation updates are post-release
state and do not alter the `v0.1.0` snapshot.

The approved tag must not be moved. Any post-release correction belongs in a
documented follow-up release. Tag signing is preferred when an appropriate
maintainer signing identity is available, but it is not a `v0.1.0` blocker.

</details>

## Roadmap

Further work includes reusable finite information theory, downstream research
formalizations and improved theorem-level documentation. Channel achievability
and stronger channel-coding results require separate mathematical development;
they are not part of v0.2.0. See the [public roadmap](home_page/roadmap.html).

## AI-assisted development

LeanInfoTheory has been developed with extensive assistance from AI coding
agents, primarily OpenAI Codex and ChatGPT. Serhat Emre Coban defines the
mathematical scope and conventions, directs the implementation, reviews the
project architecture and public theorem statements, and validates released
code through Lean's kernel, project builds, continuous integration, and
explicit checks against proof placeholders. AI-generated code is treated as
untrusted until it passes Lean and the project's validation process. The
project does not claim that its Lean proof code was written manually or that
every proof has been manually audited line by line.

Lean's kernel checks that accepted formal declarations follow from their
formal assumptions. Kernel checking does not replace human responsibility for
selecting the intended theorem, stating the right assumptions, fixing semantic
and units conventions, reviewing the architecture, or checking that the formal
statement has the intended mathematical interpretation.

## Authorship, copyright, and license

I developed LeanInfoTheory at EPFL, Mathematics of Information Laboratory.
The software creator is Serhat Emre Coban. Copyright ©
2026 École polytechnique fédérale de Lausanne (EPFL), the project rights
holder. The project is licensed under the Apache License, Version 2.0; see
[LICENSE](LICENSE).

## Citation

[CITATION.cff](CITATION.cff) records version **0.2.0**, release date
**2026-11-04**, the creator and affiliation, and Apache-2.0 licensing. The tagged
metadata intentionally remains DOI-free under the GitHub–Zenodo archive route.
Use the verified version record for the software version actually used; before
publication, identify the exact source checkpoint instead of an assumed tag.
For published v0.1.0, the historical release date is `2026-09-01` and the version
DOI is [`10.5281/zenodo.22229599`](https://doi.org/10.5281/zenodo.22229599).
The all-versions DOI remains
[`10.5281/zenodo.22229598`](https://doi.org/10.5281/zenodo.22229598).
The immutable tagged `v0.1.0` CFF intentionally remains DOI-free; the issued
identifier is preserved in the historical release records. Version 0.2.0 does
not inherit that version DOI or assert a new Zenodo deposit.
