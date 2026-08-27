# LeanInfoTheory Agent Instructions

LeanInfoTheory is a Lean 4/mathlib library for finite discrete information
theory. Certificate representation, checking, and import belong to downstream
applications rather than the LeanInfoTheory release surface. This file contains
stable operating rules. Use
[`docs/lean-info-theory-living-summary.md`](docs/lean-info-theory-living-summary.md)
for canonical project context, coverage, architecture, and current status.

## Required startup context

Before substantial planning or implementation:

1. Read this `AGENTS.md`.
2. Read Section 0, **AI Assistant Quick Start**, in the living summary.
3. Read only the living-summary sections relevant to the task.
4. Read the active chunk plan when one exists.
5. Search for relevant `docs/project-log.md` entries instead of reading the
   entire chronological log indiscriminately.
6. Inspect the actual Lean declarations, imports, and relevant builds before
   relying on documentation.

Small, direct tasks may use a proportionate subset, but no assistant should
guess current declarations or project status.

## Authority and conflict handling

Use the following source order:

1. Local Lean source and successful builds determine current implementation
   facts.
2. Approved plans and the living summary determine current project intent and
   status.
3. Exact relevant textbook sections determine intended mathematical source
   statements, subject to the project's documented conventions.
4. Git history and targeted project-log entries explain historical rationale.
5. GitHub and the public website determine relevant remote, CI, and publication
   state.

Report conflicts explicitly. Do not silently choose the most convenient
source, treat historical prose as current implementation, or promote a proposal
to an approved plan.

## Stable mathematical conventions

- Use mathlib `PMF` for finite probability laws.
- Canonical entropy and information measures are `Real`-valued and use nats.
  Keep change-of-base results in the opt-in `Shannon.Units` layer.
- Define random-variable quantities through pushforward laws with `PMF.map`.
  Lean product types are right-associated.
- Keep conditional entropy, mutual information, and conditional mutual
  information algebraic in the lightweight layer; prove conditional-law and KL
  interpretations in semantic modules.
- Use actual PMF support in support-sensitive statements. Do not replace
  support-aware injectivity or recovery with unnecessarily global hypotheses.
- Treat null conditional fibers explicitly. Total conditional channels may use
  a documented fallback, but no theorem may assign that fallback probabilistic
  meaning on a null fiber.
- Use mathlib `InformationTheory.klDiv` in `ENNReal` as the canonical
  unconditional KL divergence. Real-valued KL results need hypotheses that
  exclude the `ENNReal.top` case.
- Represent finite channels as functions `alpha -> PMF beta`, with output
  `p.bind W`; do not introduce a second bundled channel abstraction without an
  approved need.
- Prefer `[Fintype alpha]` when exposing finite sums or enumeration and
  `[Finite alpha]` when finiteness is only internal.

## Architecture and API rules

- Put finite Shannon definitions and theorems in
  `LeanInfoTheory.Shannon`. Put reusable PMF constructions and facts in `PMF`
  when that ownership is mathematically natural. Examples use descriptive
  example namespaces. Keep certificate DSLs, validators, adapters, and demos
  downstream.
- Keep `LeanInfoTheory.lean` lightweight and mathematical. Its supported direct
  imports are `Probability.Finite` and `InformationMeasures`.
- `LeanInfoTheory.Shannon` is the import-only umbrella for the complete
  supported mathematical stack. Keep focused modules separately importable.
- `Basic`, `Examples`, and `MathlibFragments` are non-stable development,
  regression, and reference anchors; neither public mathematical umbrella
  imports them.
  Do not pull heavy Jensen, measure, KL, kernel, example, or coding imports into
  the root casually.
- Keep elementary algebraic information measures separate from the semantic
  bridge. Place each new declaration in the lightest existing module justified
  by its statement and proof dependencies.
- Reuse mathlib and existing project declarations before creating local
  alternatives. Search the pinned mathlib version when upstream ownership is
  plausible.
- Keep one-off proof machinery private or local. Promote helpers, aliases,
  symmetric variants, structures, and abstractions only after real production
  or consumer pressure.
- Preserve correct public names during active theorem work. Record unusually
  long, hard-to-discover, or representation-exposing names in Future Work Note
  14 and make compatibility-preserving alias decisions at planned API reviews.
- Keep chain rules, symmetry, and representation-changing identities explicit
  unless a reviewed, terminating `[simp]` policy justifies an attribute.
- Do not add certificate representations, parsers, checking DSLs, adapters, or
  application-specific demonstrations merely for a downstream project.
  General information-theory results needed by such projects may remain or be
  added upstream when they satisfy the ordinary ownership and API rules.

## Proof integrity

- Do not introduce `sorry`, `admit`, an unapproved `axiom`, `opaque`,
  `undefined`, or an equivalent proof placeholder.
- Do not silently weaken a theorem, add stronger assumptions merely to make a
  proof compile, or change an approved theorem statement or architecture.
- Do not present an invented or remembered declaration name as verified.
  Search the current source or generated declaration index.
- State and review assumptions and edge cases, especially support inclusion,
  `ENNReal.top`, null fibers, empty or singleton alphabets, coordinate
  orientation, and `Fintype` versus `Finite`.
- After each coherent Lean change, build the touched module and important
  downstream aggregates. Audit new public declarations, imports, simp
  attributes, and root reachability before reporting completion.

## Chunk workflow

- A new chunk requires an approved plan before production implementation.
- Each implementation prompt addresses one approved step. Complete and validate
  that step, report its result, and stop.
- Do not begin a later step automatically.
- If a discovery invalidates or materially changes later steps, stop for a
  plan-health review rather than continuing against a stale plan.
- Record deferred ideas and proof-pressure triggers without pulling them into
  the active step.
- Chunk completion requires an independent validation pass against its approved
  completion criteria, including builds, architecture, API, documentation, and
  repository hygiene as applicable.

## Canonical-document ownership

- `docs/lean-info-theory-living-summary.md` is shared canonical context. Any
  project thread may edit it when that thread's work materially changes
  canonical project context; separate authorization from the General Assistant
  is not required. The project lead remains the decision authority.
- A thread editing the living summary must reconcile the affected sections
  against source, builds, approved plans, relevant project-log entries, and Git
  history rather than merely copying its own progress report.
- Threads that materially change canonical context but do not update the
  living summary directly should write structured handoff reports under the
  ignored `tmp/codex-handoffs/` directory. Verify that the temporary path is
  ignored before writing.
- The General Assistant performs periodic cross-thread reconciliation but is
  neither the exclusive editor nor an approval gate for living-summary changes.
- Update `docs/project-log.md` at meaningful theorem steps, decisions,
  reviews, and milestones, not after every trivial helper lemma.
- Change `AGENTS.md` only when a stable operating rule, convention, or
  ownership boundary changes.

## Targeted source reading

- Begin with the living-summary quick start and the active plan.
- Inspect the relevant Lean dependency closure: owning module, direct imports,
  reused declarations, and important downstream consumers.
- Search targeted project-log entries and Future Work Notes.
- Read the exact relevant textbook sections for the theorem family and
  convention at issue.
- Consult targeted Git history when provenance, rejected alternatives, or
  rationale matters.
- Apart from pinned dependencies such as mathlib, do not consult or reuse
  external information-theory formalization repositories unless the project
  lead explicitly requests it. If external implementation code is consulted
  or reused, record its source and any required attribution.
- Use GitHub and the deployed website only for relevant remote, CI, issue, or
  public-documentation questions.
- Avoid loading unrelated repository files, textbook chapters, log history, or
  website content merely for completeness.

## Validation

The cross-platform release validator is the executable source of truth for the
maintained target list and trust policy. During iteration, run focused targets
through it:

```powershell
python scripts/validate_release.py focused LeanInfoTheory.Shannon.FiniteFamily
```

During an intentionally dirty implementation pass, use focused and static
checks. Once the candidate or checkpoint changes are committed into a clean
tree, run the complete maintained suite and repeat it after any amendment:

```powershell
python scripts/validate_release.py
```

The default command and the standalone `hygiene` command require no staged,
unstaged, or unignored untracked paths. The root `.gitattributes` fixes tracked
text to LF so Lake manifests remain byte-stable in ordinary Windows checkouts.
The default command runs non-mutating generated-artifact checks, the default
Lake build, the eight-target warning-as-error build, independently compiles all
marked README Lean examples with warnings as errors, checks exact direct-import
closures for all supported modules, audits the frozen public API/root exports
and reviewed `simp` set, runs the full project axiom audit, checks exact
package/preliminary legal and release-documentation metadata, checks the
website, and performs final repository hygiene. It is the routine suite and
deliberately does not run the full signature-bearing API-documentation build.
Use `python scripts/validate_release.py targets` to display the maintained
target list. Use `python scripts/validate_release.py documentation` to check the
release-facing documentation contract and compile the README examples without
rerunning the complete suite. The trust gate permits only `propext`,
`Classical.choice`, and `Quot.sound`; the source gate also rejects `sorry`,
`admit`, project `axiom`,
`opaque`, `undefined`, unsafe or partial declarations, external implementation
hooks, native-decision shortcuts, and run tactics.

At a release-candidate or API-documentation milestone, run the separate gate:

```powershell
python scripts/validate_release.py api-docs
```

It builds the pinned, isolated doc-gen4 project twice and validates the
signature-bearing output. On Windows it requires the exact reviewed Zig 0.16.0
`zig.exe` through `LEANINFOTHEORY_ZIG`; Linux uses a system `cc`. The default
`file` source-link mode is for local inspection only. Use `DOCGEN_SRC=github`
only from a clean exact-commit checkout. Ordinary push and pull-request CI do
not run this expensive gate; it is a separate conditional `workflow_dispatch`
job after the routine gates.

After a successful file-mode API-doc gate, assemble and check the ignored local
website preview with:

```powershell
python scripts/stage_website.py preview
python scripts/check_website.py --site-root .lake/website-stage/LeanInfoTheory --mode preview
```

Serve `.lake/website-stage` and inspect `/LeanInfoTheory/` so local testing uses
the GitHub Pages project subpath. Preview staging requires the two-pass API-doc
attestation, removes machine-local source links, and writes
`NOT_FOR_PUBLICATION.txt`. `stage_website.py release` is reserved for a clean
exact-commit GitHub-source build; it does not deploy. The Pages workflow is
manual-only, and its `publish` input must remain false unless the user has
explicitly approved publication.

After approved public declarations or imports change, deliberately regenerate
the versioned public-API manifest and source-derived website artifacts, then
run the non-mutating static gate before the complete suite:

```powershell
python scripts/generate_v0_1_public_api.py
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/validate_release.py static
```

The two website generators and the public-API generator all support `--check`
without modifying an intentionally dirty tree. The validator checks each
generated artifact twice, preserves permanent mathematical examples as the
primary consumers, and uses generated Lean environment probes only for
architecture and trust regression. Delete disposable proof spikes before a
milestone report. The generated module graph is module-level, the declaration
index is not full Lean doc-gen, and the `v0.1` manifest does not enforce
same-name signature fingerprints. The separate generated API pages render the
current elaborated types and validate declaration coverage, but do not by
themselves freeze those types. Do not overclaim any of these artifacts.

Before any accumulated toolchain or website release-candidate change reaches
the default branch, land and remotely verify a separately approved safety-only
workflow change based directly on `origin/master`. Its allowed repository diff
is the deletion of the automatic tag/release workflow and either deletion of
the old Pages workflow or replacement by a self-contained inert/manual-only
workflow with no deploy job or deployment permission. It must exclude the
pre-existing local `4aa2c79` commit and every candidate file, retaining the old
toolchain and site content. Add the functional final Pages workflow only with
the release candidate. Do not combine the safety landing with that candidate
push. Before publication, GitHub's immutable-Releases setting must be enabled
and verified. A Pages deployment from `master` is acceptable only when the
workflow run's exact `head_sha` equals the immutable release tag commit.

## Local references

- Local textbooks and reference files may be consulted for mathematical
  planning and verification.
- Read only the sections relevant to the current theorem or convention.
- Do not commit local copyrighted references, reproduce substantial textbook
  text, or copy textbook proofs into project documentation.
- Identify the relevant textbook and section when a mathematical claim or
  formalization contract depends on it.

## Legal metadata and provenance

- LeanInfoTheory is an EPFL research software project from the Mathematics of
  Information Laboratory. École polytechnique fédérale de Lausanne (EPFL) is
  the rights holder; Serhat Emre Coban is the author, software creator, and
  project lead. Use `Coban` in repository and release metadata unless an
  official field explicitly requires another spelling.
- Every new project-authored Lean source file must use the exact EPFL/MIL
  header recorded in Section 7 of `docs/v0.1-release-contract.md`.
- Never overwrite mathlib, upstream, vendored, dependency, or other
  third-party notices. Update generated notices through their generator or
  template. Add a `NOTICE` file only for a concrete attribution or
  redistribution requirement.
- Keep Apache-2.0 as the project licence and preserve the canonical licence
  text in `LICENSE`. Do not claim approval by EPFL, MIL, or EPFL TTO.
- AI-assistance disclosure belongs in release-facing documentation, not source
  copyright headers. AI systems and their providers are not project authors or
  software creators.
- `CITATION.cff` is the canonical release metadata source and uses the
  affiliation `EPFL, Mathematics of Information Laboratory`. Under the
  approved automatic post-release GitHub--Zenodo route, the tagged CFF remains
  DOI-free and no `.zenodo.json` is added. The approved `v0.1.0` publication
  date is `2026-08-27`; if that day changes before publication, update every
  release-date surface and revalidate before freezing the candidate.
- Do not create, register, link, or configure a Zenodo account for the project
  lead. When a signed-in account is required for the integration preflight, ask
  the project lead to create or connect it, then inspect it read-only unless a
  separate instruction explicitly authorizes a setting change.
