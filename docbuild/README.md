# LeanInfoTheory documentation build

This nested Lake project keeps `doc-gen4` out of LeanInfoTheory's runtime
dependency graph. It duplicates the root's fixed Lean `v4.33.1` toolchain pin
and uses the same frozen mathlib release environment. Doc-gen4 is pinned at
`v4.33.1`, commit `e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015`, with all
transitive Git dependencies locked by the nested manifest.

Run the maintained build and coverage check from the repository root:

```powershell
python scripts/validate_release.py api-docs
```

That command explicitly uses local `file:` source links unless `DOCGEN_SRC` is
set to `github`. GitHub mode is accepted only for a clean checkout and produces
exact-commit links; local file-linked output is not a publication artifact.
Generated files live under `docbuild/.lake/build/doc` and are intentionally
untracked. See [`docs/api-documentation.md`](../docs/api-documentation.md) for
the full build, validation, serving, and publication-boundary contract.

This command is the explicit release/milestone gate. The routine
`python scripts/validate_release.py` suite and ordinary push/pull-request CI do
not run it. A manual workflow dispatch can opt into the separate `api_docs`
GitHub-mode job after the routine gates.

On Windows, set `LEANINFOTHEORY_ZIG` to the `zig.exe` from the pinned official
Zig 0.16.0 x86_64 archive. The validator requires SHA-256
`086ce9d47ba42f33a514e1a6e04eb1d4a8fa1d75e0868e0213caad447c91e864`
for the executable and compiles the small project-authored `CCShim.lean`
forwarding executable directly with the pinned Lean toolchain. Linux uses a
system `cc`; downstream library users need neither compiler setup.

The maintained documentation build disables doc-gen4's optional equation
extraction and validates that the database contains zero equation rows.
Rendered declaration names, headers, types, documentation, and source links are
unaffected. Expected pages, declarations, canonical export targets and non-stable
exclusions come from the schema-validated, source-matching
[`current manifest`](../docs/current-public-api.json) and reviewed growth policy.
The historical v0.1.0 result was 31 pages, 601 declarations, 92 targets and 13
exclusions; these are not current count ceilings.

The v2 build configuration and two-pass attestation identify current source
content, manifest/retained-contract bytes, build/checker inputs and pinned
dependencies. A signature, definition body or docstring edit invalidates old
evidence even if manifest entries are unchanged. Content changes preserve
incremental caches; link-mode changes invalidate generated mode-sensitive output.
Inspect current file-mode output directly here: it cannot be staged under the
frozen `/docs/v0.1.0/` route. The separate frozen release/maintenance procedures
retain their exact identities and publication guards. Generated types document
the current tree; retained structural fingerprints and source review govern
compatibility, and matching types do not establish unchanged semantics.

## C9 current milestone requirements

C9.07 requires the current 603-declaration/31-module milestone, with 92 canonical
export targets and 15 excluded non-stable modules. The real two-pass file-mode
build and source-content attestation must pass, together with the complete
routine suite and fixtures on an authorized clean candidate, before cumulative
independent review. Review reconciliation and private closure remain mandatory
postconditions. The [maintained handoff](../docs/handoffs/chunk-9.md) identifies
the actual source-bound records that determine results and closure status.
Synthetic fixtures and historical release HTML cannot establish this current
build's result. Keep the pinned environment and direct-inspection route above;
no current publication or frozen-route staging is authorized.
