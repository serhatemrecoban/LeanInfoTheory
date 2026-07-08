# Next Website Tasks

This note records the remaining website-specific work from the current
seven-step website improvement plan. It is a planning checklist for the static
site only.

## Current Plan Status

1. Completed or in progress: navigation and generated-artifact terminology.
   The top navigation now uses compact labels such as `Theorems`, `Demo`,
   `API Index`, and `Blueprint`, while the generated pages use precise titles.
2. Completed or in progress: homepage summary.
   The homepage now includes a concise project summary explaining the current
   finite information-theory library, certificate checker, and longer-term
   network-information-theory direction.
3. Completed or in progress: two-branch architecture diagram.
   The homepage now separates the formal finite-Shannon/semantic-library branch
   from the certificate-validation branch, and shows how they meet in checked
   theorem demos.
4. Completed: theorem highlights source/API links.
   The theorem highlights page now links highlighted declarations to stable
   generated declaration-index anchors and to their GitHub source locations.
5. Completed: prior-art links and comparison table.
   The prior-art page now links to mathlib information-theory foundations,
   PFR, Rocq Infotheo, and entropy-inequality search/checking tools, and it
   includes a compact comparison table explaining LeanInfoTheory's role.

## Remaining Website Tasks

6. Add a visual trusted-flow diagram to the submodularity demo page.
   The demo should visually separate untrusted raw certificate data, Lean
   validation, checked certificate data, exact entropy-expression matching, and
   the final theorem. The diagram should make clear that external search/import
   tools are untrusted and Lean validation is the trusted step.

7. Improve roadmap/status presentation with clear completed/active/planned
   labels.
   The roadmap and homepage status areas should distinguish completed Lean
   theorems, active website/documentation work, planned theorem work, and later
   infrastructure milestones.

## Later Milestones

- Add a theorem-level leanblueprint page after there is enough stable theorem
  structure to make it useful.
- Add a rendered blueprint PDF after the theorem-level blueprint source is
  meaningful enough to publish.
- Add full Lean doc-gen output and link it from the homepage, theorem
  highlights, module guide, generated declaration index, and documentation
  landing page.

## Constraints

- This is a website-only task list.
- Do not change Lean theorem statements while working through these website
  tasks.
- Do not call the current module dependency map a theorem-level graph.
- Do not call the current declaration index full Lean doc-gen output.
