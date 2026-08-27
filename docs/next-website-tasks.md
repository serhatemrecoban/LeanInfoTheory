# Next Website Tasks

## Completed in the current website-improvement pass

- Step 1: navigation and generated-artifact terminology.
- Step 2: homepage summary.
- Step 3: two-branch architecture diagram.
- Step 4: theorem highlights are more clickable / source-linked where implemented.
- Step 5: prior-art page strengthened with links/comparison material where implemented.
- Step 6: submodularity demo has a visual trusted-flow diagram.
- Step 7: improve roadmap/status presentation with clear completed/active/planned labels.

## Completed release staging

- Release Step 12 assembles the existing site and all 5,521 generated files at
  the stable `/docs/v0.1.0/` route without changing the site's visual design.
- Preview staging removes all 151,458 machine-local source links, labels their
  absence clearly, repairs generated `#top` targets, and adds an explicit
  `NOT_FOR_PUBLICATION.txt` interlock.
- The served preview passed navigation, search, declaration deep-link, source-
  suppression, imported-by, instance, theme, runtime-asset, project-subpath,
  return-route, and 404 checks.
- The full checker covered 5,520 HTML files, 2,951,158 links/assets, two
  generated JSON files, and 654,015,176 bytes with zero project-owned or runtime
  errors. It retained 111 advisories from imported dependency documentation for
  publication-candidate reassessment.
- Staging records 13 generated runtime/search assets, four external runtime
  resources, exact tool/dependency revisions, the root project licence, and an
  indexed set of exact upstream licences. The Step 14 attribution audit found
  no concrete root-`NOTICE` requirement; the exact licence inventory remains
  the distribution record.
- Pages publication is manual-only. Preview staging is deliberately
  unpublishable; release staging requires a clean GitHub-source build bound to
  exact `HEAD`.

## Release publication controls

- The tracked candidate contains completed release staging and the guarded
  manual-only Pages workflow.
- Exact-commit GitHub-source generation, publishable-site checking, remote
  capacity evidence, and reassessment of the 111 imported-dependency advisories
  belong to the external candidate-validation record.
- Ordinary pushes cannot deploy. A `publish=true` dispatch requires explicit
  Step 18 authorization and proof that its ref and SHA equal the validated tag
  commit.
- No tracked website text asserts that a GitHub Release, Pages deployment,
  Zenodo record, or DOI exists.

## Later milestones

- theorem-level leanblueprint;
- blueprint PDF;
- post-release documentation enhancements beyond the supported v0.1 API.

## Constraints

- Website-only work unless explicitly asked otherwise.
- Do not change Lean theorem statements.
- Do not call the module-level dependency map a theorem-level graph.
- Do not call the source-derived declaration index full Lean doc-gen.
- Do not present local `file:` links or the ignored Step 11 output tree as a
  published release artifact.
- Do not describe imported dependency pages as part of the 31-module supported
  LeanInfoTheory API or their 111 current advisories as project-owned failures.
- Do not claim that generated signatures are committed signature fingerprints.
- Keep wording honest about proved/demo/planned/future status.
