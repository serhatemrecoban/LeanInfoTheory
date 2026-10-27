# C24 candidate metadata matrix and release handoff

**Status: Unpublished candidate retention established; C24.07 qualification in progress.**
The primary working tree and clean export checkpoint 05f9bec are distinct from a future final
qualified successor. Stable remains v0.1.0. See the
[candidate contract](../v0.2-release-contract.md) and
[candidate notes](../releases/v0.2.0.md).

## Metadata and identity matrix

| Surface | Candidate preparation | Historical/stable identity and remaining duty |
| --- | --- | --- |
| Root `lakefile.toml` | Only `version = "0.2.0"` changes | Options, license, dependency declarations and toolchain remain exact after the approved one-line projection. |
| Canonical `CITATION.cff` | Version 0.2.0; explicit unpublished message; no issued date/DOI | v0.1.0 date 2026-09-01 and version DOI 10.5281/zenodo.22229599 stay in historical records; all-versions DOI 10.5281/zenodo.22229598 is not a candidate version DOI. |
| Authorship/legal/provenance | Sole creator Serhat Emre Coban; EPFL MIL affiliation; Apache-2.0 | EPFL remains rights holder. Source notices, LICENSE and third-party notices are preserved. No institutional endorsement is implied. |
| Toolchain/runtime dependencies | Lean/mathlib v4.33.1 and existing exact manifest | No pin, Lean option or alternate effective Lake configuration change. Internal docbuild package version/pins remain unchanged. |
| README/install guidance | Current source811/57; unpublished local checkout/path use; marked examples | Published Git install remains `rev = "v0.1.0"`; no remote availability is inferred for the local working tree or an unpushed SHA. |
| Supported API | 811 declarations/57 modules;92 root aliases;94 reviewed simp declarations | Immutable601-name historical contract stays separate. Complete candidate retained types/universes/owners/imports/attributes now bind the examined checkpoint 05f9bec capture; successor comparison/qualification remains required. |
| Website and documentation | Existing design, candidate coverage/import map and explicit local-candidate status | Stable still selects `/docs/v0.1.0/`; `/docs/current/` awaits its qualified candidate artifact and `/docs/v0.2.0/` is reserved. No absent public artifact is advertised. |
| PFR case study | Public references verified; scoped summary prepared | Exact wording/link approval pending; historical dependency v0.1.0, no candidate-use evidence. Private disclosure and outreach are separate. |
| Source/checkpoint | Primary HEAD b577679892f4db40cfad480e0f487184ed91d4d5 plus dirty C24 work; clean export source `05f9bec97d73329877d4f52a6c52f20e7fad4c92` | The export checkpoint is not the containing successor. Exact successor approval, tree correspondence and complete requalification remain required. |

The candidate state is `candidate` with `retention=established`; publication is
disabled. Final release date, candidate version DOI, tag, release archive,
stable-pointer switch, public source availability and deployment are unexecuted.
The [retention account](c24-candidate-retention.md) binds actual capture and
examination identities. The [content-proposal history](c24-candidate-content-proposal.md)
records the approved checkpoint 05f9bec omission and preserves local private-file bytes. The
containing successor still requires separate exact checkpoint approval.

## Remaining qualification and handoff obligations

1. C24.06 is closed on its actual checkpoint 05f9bec local external-package evidence. In-tree
   examples are not that proof; a successor SHA requires fresh external compilation.
2. C24.07 retains the examined complete baseline and must still qualify its
   containing clean successor, normal comparison, full suite and new external run,
   followed by original formal review/reconciliation and closure.
3. C24.08 qualifies the actual two-pass signature-bearing API and composed local
   artifact, including exhaustive substantive rendered-contract applicability.
   Root package/state metadata changes invalidate automatic reuse of an earlier
   API content identity; no new API gate is claimed by C24.05.
4. C24.09 reconciles cumulative criteria, final exact bytes/commit and handoff.
   Source-bound original review and closure, not these provisional descriptions,
   determine completion. No later step starts automatically.
5. The separate release chat approves exact final metadata, PFR wording/links,
   publication inputs, public commit availability and publication itself.

Any final source or metadata amendment requires the maintained complete clean
suite on the resulting candidate. Documentation-generation or source-link-mode
changes require renewed API/artifact qualification; assess all inputs and
rerun invalidated gates. Mathematical/API changes additionally require affected
consumers and renewed review. Preserve valid inspection evidence only with an
explicit unchanged-input/output/meaning match. Publication must identify the
**actual final qualified commit** and its artifact; it cannot silently inherit
qualification from an earlier SHA.

## C24.05 evidence boundary

Required Step5 evidence is the actual documentation validator and all nine
maintained README/guide example outputs, non-mutating source-derived checks
after deliberate regeneration, focused metadata/recorder guards, bounded
site/link checks and local visual inspection. Parent execution, self-review,
independent original review, reconciliation and final source applicability
remain distinct. Existing incremental Lake caches are disclosed. No clean
candidate, external consumer, new retained baseline, signature-bearing API build,
remote CI, publication or PFR rebuild is inferred from these focused checks.
