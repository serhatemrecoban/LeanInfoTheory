# LeanInfoTheory Agent Instructions

This repository is a Lean 4/mathlib project for finite information theory and
entropy-certificate checking.

## Project Scope

- The Lean development focuses on finite information theory, Shannon entropy,
  semantic bridge lemmas, and checked entropy certificates.
- CI rejects `sorry`, `admit`, `axiom`, `opaque`, and `undefined` in Lean
  source.
- Keep the root import lightweight.
- Keep semantic bridge, entropy bounds, demos, and reference modules separately
  importable where appropriate.
- Do not change Lean theorem statements or project architecture during
  website-only tasks unless explicitly asked.

## Website

- Website source lives under `home_page/`.
- The website currently includes:
  - homepage dashboard;
  - theorem highlights;
  - submodularity demo;
  - module guide;
  - development page;
  - prior-art page;
  - roadmap;
  - generated module-level dependency map;
  - generated declaration index.
- The generated declaration index is not full Lean doc-gen.
- The generated dependency map is module-level, not theorem-level
  leanblueprint.
- Do not overclaim website status.
- Distinguish clearly between proved, demo, generated, planned, and future work.

## Website Generation And Checks

Use these commands for website generation and checks:

```powershell
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/check_website.py
```

## Public API Naming

- Do not interrupt an active theorem-development step merely to rename a
  correct public declaration whose descriptive name is long.
- When a new or newly pressured public theorem name is unusually long, hard to
  discover, or exposes representation machinery such as named marginals,
  coordinate maps, `Prod.swap`, or `pairThirdLaw`, append it to the naming and
  alias watchlist in Future Work Note 14 of `docs/project-log.md`.
- Record why the name is awkward and, when useful, a provisional shorter alias
  pattern. Do not treat a provisional alias as an approved API decision.
- Preserve existing names during ordinary theorem steps. Revisit the watchlist
  during a scheduled API review, preferring compatibility-preserving aliases
  unless an explicit migration has been approved.
- After each theorem-development step, check whether any newly added long
  public names should be added to Future Work Note 14.

## Lean Checks

Use these commands for Lean checks:

```powershell
lake build LeanInfoTheory
lake build LeanInfoTheory.Shannon.EntropyBounds
lake build LeanInfoTheory.Shannon.Units
lake build LeanInfoTheory.Shannon.SemanticBridge
lake build LeanInfoTheory.MathlibFragments
lake build LeanInfoTheory.Certificate.Submodularity
lake build LeanInfoTheory.Certificate.Subadditivity
lake build LeanInfoTheory.Certificate.Monotonicity
lake build LeanInfoTheory.Certificate.ThreeWaySubadditivity
lake build LeanInfoTheory.Examples
```
