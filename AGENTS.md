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

## Lean Checks

Use these commands for Lean checks:

```powershell
lake build LeanInfoTheory
lake build LeanInfoTheory.Shannon.EntropyBounds
lake build LeanInfoTheory.Shannon.SemanticBridge
lake build LeanInfoTheory.MathlibFragments
lake build LeanInfoTheory.Certificate.Submodularity
lake build LeanInfoTheory.Certificate.Subadditivity
lake build LeanInfoTheory.Certificate.Monotonicity
lake build LeanInfoTheory.Examples
```
