# LeanInfoTheory

[![Lean build and release gates](https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/lean_action_ci.yml/badge.svg)](https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/lean_action_ci.yml)
[![Deploy website](https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/pages.yml/badge.svg)](https://github.com/serhatemrecoban/LeanInfoTheory/actions/workflows/pages.yml)

Lean-certified finite discrete information theory over mathlib probability mass
functions.

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

## Release

`v0.1.0` is the first public-library release of LeanInfoTheory. It establishes
a reusable finite-information-theory foundation and the source-compatibility
baseline for the `0.1.x` line without claiming that all of information theory,
all of Cover--Thomas Chapter 2, or any particular paper has been formalized.
The release date is `2026-09-01` in Europe/Zurich. Under the approved automatic
post-release GitHub--Zenodo route, the tagged `CITATION.cff` and immutable
GitHub Release will intentionally contain no DOI; Zenodo issues the version DOI
after ingesting the Release.

The supported `0.1.x` surface contains 31 modules, 601 documented
project-owned declarations, 92 lightweight-root exports, and 94 reviewed
`simp` declarations. Maintained release validation rejects proof placeholders
and permits only `propext`, `Classical.choice`, and `Quot.sound` as axioms.
Signature-bearing API documentation covers all 601 supported declarations at
the versioned `/docs/v0.1.0/` route, with source links bound to the exact
release commit. The release process also validates a clean exact checkout and
a minimal external Lake consumer.

See the [release roadmap](docs/roadmap.md), the
[current Lean state](docs/current-lean-state.md), and the
[`v0.1.0` release notes](docs/releases/v0.1.0.md) for the precise scope and
validation contract.

## Installation

LeanInfoTheory `v0.1.0` targets Lean 4 and mathlib `v4.33.1`. Align the
consumer project's `lean-toolchain` with:

```text
leanprover/lean4:v4.33.1
```

Then add the tagged Git dependency to `lakefile.toml`:

```toml
[[require]]
name = "LeanInfoTheory"
git = "https://github.com/serhatemrecoban/LeanInfoTheory"
rev = "v0.1.0"
```

Update dependencies, fetch the mathlib cache, and build:

```sh
lake update
lake exe cache get
lake build
```

LeanInfoTheory declares `fixedToolchain = true`. Lake may prioritize that
toolchain during dependency resolution, so a consumer should not silently mix
LeanInfoTheory `v0.1.0` with incompatible Lean, mathlib, or other fixed-toolchain
dependencies. Use the immutable version tag rather than an untagged branch when
reproducibility matters.

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

| Import | Intended use |
| --- | --- |
| `LeanInfoTheory` | Lightweight finite-PMF support, entropy, and elementary information measures. |
| `LeanInfoTheory.Shannon` | Complete supported mathematical umbrella. |
| `LeanInfoTheory.Probability.FiniteChannel` | Raw PMF-valued channels and elementary channel laws. |
| `LeanInfoTheory.Shannon.EntropyBounds` | Sharp alphabet- and support-cardinality entropy bounds. |
| `LeanInfoTheory.Shannon.Fano` | Deterministic decoding error and finite Fano inequalities. |
| `LeanInfoTheory.Shannon.FiniteFamily` | Dependent finite families and chain-rule algebra. |
| `LeanInfoTheory.Shannon.Units` | Scalar conversion from nats to another valid base or bits. |
| `LeanInfoTheory.Shannon.SemanticBridge` | Complete conditional-law, KL, independence, Markov, data-processing, convexity, finite-family, and sufficiency bridge. |

Focused semantic submodules remain supported imports when the full bridge is
unnecessary. The exact supported list and every frozen project-owned
declaration are recorded in the
[`v0.1.x` public API contract](docs/v0.1-public-api.md) and its
[machine-readable manifest](docs/v0.1-public-api.json).

`LeanInfoTheory.Basic`, `LeanInfoTheory.MathlibFragments`, and the
`LeanInfoTheory.Examples` hierarchy are maintained development, reference, and
regression anchors, but they are not stable `0.1.x` API. Neither public
mathematical umbrella imports them.

## Supported mathematical scope

The `v0.1.0` release includes:

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

This is a reusable foundation, not a claim that information theory, Cover--
Thomas Chapter 2, or any paper has been completely formalized.

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

The release does not cover general measurable or continuous entropy,
entropy rates and stochastic processes, channel capacity or coding theorems,
AEP/typicality, Pinsker inequalities, full majorization/Birkhoff theory,
canonical or minimal sufficient statistics, certificate search/checking, or
paper-specific constructions. Some currently supported theorems intentionally
retain stronger finite-type assumptions documented in the public API contract.
See [Known Limitations and Open Questions](docs/lean-info-theory-living-summary.md#11-known-limitations-and-open-questions)
for the detailed register.

## Compatibility policy

Throughout `0.1.x`, the project intends to preserve the supported module paths,
project-owned public names, namespaces, types, assumptions, documented
semantics, root exports, and reviewed attributes recorded in the versioned
manifest. Patch releases may add declarations or compatibility aliases. A
necessary breaking change must be documented and deferred to a later minor
release such as `0.2.0`.

This promise does not cover private declarations, proof terms, generated names,
imported mathlib declarations, or the explicitly non-stable modules. It is a
source-compatibility baseline for `0.1.x`, not a permanent API freeze.

## Examples and documentation

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
gate](docs/api-documentation.md) renders the complete supported surface at the
stable versioned route. The supporting website is
<https://serhatemrecoban.github.io/LeanInfoTheory/>.

## Reproducing maintained builds

The repository validator requires Python 3.11 or newer; ordinary Lake consumers
do not need Python or documentation-build tools at runtime. Obtain the release
snapshot with Git, Elan/Lake, and Python 3.11+ available:

```sh
git clone --branch v0.1.0 --depth 1 https://github.com/serhatemrecoban/LeanInfoTheory.git
cd LeanInfoTheory
lake exe cache get
python scripts/validate_release.py
```

The validator runs the default build and the eight-target warning-as-error
build, compiles every marked README example independently, verifies every
supported direct-import closure, checks the frozen API, root exports, `simp`
surface, and approved axiom allowlist, scans for proof placeholders and
implementation shortcuts, checks generated artifacts and the website twice,
and finishes with strict repository hygiene. Run it from a clean checkout: it
rejects staged, unstaged, and unignored untracked files. The repository's LF
checkout policy keeps Lake manifests byte-stable on Windows as well as Unix.
This routine suite deliberately excludes the much heavier signature-bearing
documentation build.

Useful focused commands are:

```sh
python scripts/validate_release.py documentation
python scripts/validate_release.py focused LeanInfoTheory.Shannon.FiniteFamily
python scripts/validate_release.py static
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
to local `file:` source links, so its raw output is not publishable. The staging
tool removes those links for a clearly marked local preview; it does not turn
that preview into a release artifact. A clean exact-commit release reproduction
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
After that review, publication still requires explicit authorization. Only then
may the maintainer enable and verify immutable GitHub Releases, create the
annotated `v0.1.0` tag, publish the GitHub Release, allow Zenodo ingestion, and
deploy the prepared site. The Pages run's `head_sha` must equal the immutable
tag commit.

The approved automatic integration will ingest the immutable GitHub Release
and issue the version DOI afterward. `CITATION.cff` remains the canonical
repository metadata source; no `.zenodo.json` is used. École polytechnique
fédérale de Lausanne (EPFL) will be recorded as `RightsHolder` directly in
Zenodo after ingestion. Before accepting that record, verify its software type,
title `LeanInfoTheory`, version `0.1.0`, actual release date, Apache-2.0 licence,
repository URL, sole creator Serhat Emre Coban, exact creator affiliation
`EPFL, Mathematics of Information Laboratory`, and the exact institutional
`RightsHolder`. The issued DOI and any later default-branch
`CITATION.cff`, README, or website citation update are post-release state, not
part of the immutable `v0.1.0` snapshot.

The approved tag must not be moved. Any post-release correction belongs in a
documented follow-up release. Tag signing is preferred when an appropriate
maintainer signing identity is available, but it is not a `v0.1.0` blocker.

## Roadmap

The `v0.1.x` mathematical and public-import surface is frozen as documented.
No later theorem chunk is selected automatically. Post-release work includes
DOI propagation, documentation maintenance, and separately planned additions
to the reusable finite-information-theory library. See
[docs/roadmap.md](docs/roadmap.md).

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

LeanInfoTheory is an EPFL research software project from the Mathematics of
Information Laboratory, authored and led by Serhat Emre Coban. Copyright ©
2026 École polytechnique fédérale de Lausanne (EPFL), the project rights
holder. The project is licensed under the Apache License, Version 2.0; see
[LICENSE](LICENSE).

No statement in this repository claims approval by EPFL, MIL, or EPFL TTO.

## Citation

Please use the release metadata in [CITATION.cff](CITATION.cff) when citing
LeanInfoTheory. Its approved `date-released` value is `2026-09-01`. The tagged
`v0.1.0` CFF intentionally remains DOI-free under the
automatic post-release Zenodo route; the issued version DOI will be added only
to the later default-branch `CITATION.cff`, README, and website metadata.
