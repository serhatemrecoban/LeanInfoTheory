# LeanInfoTheory Agent Instructions

LeanInfoTheory is a Lean 4/mathlib project for finite discrete information
theory and Lean-checked entropy-inequality certificates. This file contains
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
  when that ownership is mathematically natural. Certificate APIs live under
  `LeanInfoTheory.Certificate`; examples use descriptive example namespaces.
- Keep `LeanInfoTheory.lean` lightweight. It may expose the elementary finite
  probability, information-measure, entropy-expression, primitive-inequality,
  and checked-certificate layers.
- Keep entropy bounds, units, finite channels, semantic bridges, examples,
  certificate demonstrations, and `MathlibFragments` separately importable.
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
- Treat raw certificates and external generators or parsers as untrusted.
  Soundness must pass through Lean validation of primitive tags, nonnegative
  coefficients, and exact normalized expression equality before using a
  checked certificate.

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
- Use GitHub and the deployed website only for relevant remote, CI, issue, or
  public-documentation questions.
- Avoid loading unrelated repository files, textbook chapters, log history, or
  website content merely for completeness.

## Validation

During iteration, run focused `lake build` commands for the touched module and
its important downstream aggregate. Before a release, commit, chunk completion,
or milestone, run the maintained suite:

```powershell
lake build LeanInfoTheory `
  LeanInfoTheory.Shannon.EntropyBounds `
  LeanInfoTheory.Shannon.Units `
  LeanInfoTheory.Shannon.SemanticBridge `
  LeanInfoTheory.MathlibFragments `
  LeanInfoTheory.Certificate.Submodularity `
  LeanInfoTheory.Certificate.Subadditivity `
  LeanInfoTheory.Certificate.Monotonicity `
  LeanInfoTheory.Certificate.ThreeWaySubadditivity `
  LeanInfoTheory.Examples
```

The Lean source placeholder scan must return no matches:

```powershell
$placeholderHits = rg -n --glob '*.lean' '\b(sorry|admit|axiom|opaque|undefined)\b' `
  LeanInfoTheory LeanInfoTheory.lean
$placeholderStatus = $LASTEXITCODE
if ($placeholderStatus -gt 1) { throw "Placeholder scan failed with rg exit code $placeholderStatus." }
if ($placeholderStatus -eq 0) {
  $placeholderHits
  throw "Lean source contains a forbidden placeholder."
}
$LASTEXITCODE = 0
```

After public declarations or imports change, regenerate and validate the
source-derived website artifacts:

```powershell
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/check_website.py
git diff --exit-code -- `
  home_page/blueprint/dep_graph_document.html `
  home_page/blueprint/module_graph.json `
  home_page/docs/api-index.html `
  home_page/docs/declaration_index.json
```

Run `python scripts/check_website.py` after website changes. For a new opt-in
public module, also test a positive direct-import consumer and verify that the
lightweight root does not expose it. Delete disposable proof spikes and inspect
`git status`, the final diff, generated-file idempotence, and scratch artifacts
before a milestone report. The generated module graph is module-level, and the
declaration index is not full Lean doc-gen; do not overclaim either artifact.

## Local references

- Local textbooks and reference files may be consulted for mathematical
  planning and verification.
- Read only the sections relevant to the current theorem or convention.
- Do not commit local copyrighted references, reproduce substantial textbook
  text, or copy textbook proofs into project documentation.
- Identify the relevant textbook and section when a mathematical claim or
  formalization contract depends on it.
