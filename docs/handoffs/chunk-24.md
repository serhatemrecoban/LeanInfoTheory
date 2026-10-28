# Chunk 24 — programme qualification and second-release handoff

**Status: final C24.09 source preparation; unpublished v0.2.0 candidate.**
C24.01–C24.08 and their independent reviews are closed. This handoff is finalized
before its containing checkpoint and final source capture. Final C24 acceptance
exists only when `.lit-review/setup/c24-09-completion-20261028.json` records
`SUPERVISED_STEP_COMPLETE` and links the actual qualified commit/tree, B/R/F,
all-criterion original cumulative report, parent reconciliation, final checks
and supported closure. An absent or incomplete record means qualification is
unfinished. This document does not predict its own containing commit or a PASS.

The [approved plan](../plans/post-release-chunk-24.md) is revision 2, accepted
2026-10-25. The [notes](../plans/post-release-chunk-24-notes.md) record implementation
judgments; the [programme ledger](../qualification/c24-programme.md) and its
[machine-readable crosswalk](../qualification/c24-programme.json) retain all
216 stable rows and 276 mapped requirements (260 execution criteria plus 16
named C9 requirements). C24's final original review must assess every row and
all 27 C24 criteria, including the final three readiness/qualification/handoff
criteria. Earlier source-bound reports alone cannot supply final acceptance.

## Delivered mathematical scope and imports

The supported surface contains 811 declarations in 57 modules: 210 additions
and 26 additional owners relative to the original 601/31 release. The lightweight
root retains 92 aliases; reviewed public simp membership remains 94. These counts
measure inventory, not mathematical value or unchanged semantics. The detailed
[first-release comparison](../qualification/c24-programme-comparison.md) and
[current inventory](../current-public-api.json) supply the declaration/owner map.

| Programme | Delivered contracts and permanent consumer boundary |
| --- | --- |
| C9–C15 quantitative probability | Deterministic processing and decomposition, half-L1 TV, attained event/test forms, maximal coupling and transport/gluing, Pinsker/quantitative independence, continuity and finite-PMF topology. Consumers preserve actual marginals, coupling disagreement budgets, support and degeneracies. |
| C16–C18 products and channels | Dependent finite products, iid splitting/marginals, product entropy/KL/MI and raw product channels. The upper MI bound allows arbitrary correlated input; equality requires its actual independence hypotheses. |
| C19–C21 finite-iid source coding | Finite-moment/Chebyshev AEP, strict supported typical sets, deterministic fixed-length codes and one-family above-entropy achievability. Strong and unrestricted necessary-rate converses give an infimum threshold, without equality-rate attainment or an efficient-encoder claim. |
| C22 information capacity | An attained maximum over a nonempty finite input alphabet, arbitrary-input product upper bounds, attained product/repeated equalities and noiseless, constant, BSC and BEC examples with their actual maximizing laws. |
| C23 channel weak converse | Uniform-message actual code laws preserve encoder collisions and correlated pushforwards. Fano, DPI, capacity, error and rate compose on the same code/family. Undivided zero-length bounds, positive-length normalization, arbitrary-family limsup and distinct eventual/frequent gap conclusions remain separate. |

Use `LeanInfoTheory` for the lightweight `Probability.Finite` and
`InformationMeasures` facade. `LeanInfoTheory.Shannon` is the import-only umbrella
for the complete current stack. Focused imports include `Probability.Coupling`,
`Probability.TotalVariation`, `Probability.Iid`, `Shannon.SemanticBridge.AEP`,
`Shannon.SourceCodingAsymptotic`, `Shannon.ChannelCapacity` and
`Shannon.ChannelCodingAsymptotic`, each under `LeanInfoTheory.`. `Basic`, examples
and `MathlibFragments` remain non-stable and outside both mathematical umbrellas.

All information/rates use nats; bits are explicit scalar conversion. Canonical
KL is ENNReal-valued and can be infinite. Support-sensitive real conversion,
null-fiber fallbacks, finite/nonempty alphabet and positive-message/length/rate
hypotheses remain visible. No channel achievability, operational channel-capacity
equality, channel strong converse, continuous theory, variable/prefix coding,
stationary/ergodic AEP or full-textbook formalization is claimed. The source
strong converse is not a channel strong converse.

## Independent-package use and retained compatibility

The [external consumer contract](../qualification/c24-external-consumer.md) and
[portable recipe](../../tests/external-consumer/README.md) cover seven separate
import boundaries: retained/root, coupling-continuity, arbitrary/correlated
product MI, one-family source coding, attained/standard capacity, same-code weak
converse and full-umbrella use. They use public interfaces, not in-tree examples
or private helpers. Each new candidate SHA requires local-Git resolution, fresh
compilation and physical source/olean-origin and dependency-pin checks. Existing
caches are disclosed; local evidence does not prove remote installation or PFR use.

The immutable first release is `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`,
annotated tag object `bcd9090ea2720fe14b0a3e168c76ebeef1dafd47`. Its 601-name
retained contract stays separate. The [candidate retained contract](../compatibility/v0.2.0-candidate-contract.json)
protects all 811 supported declarations: exact elaborated types, universes,
binder information, kinds, ownership, imports/root aliases and reviewed attributes.
Neither inventory nor rendered HTML substitutes for this comparison.

| Candidate retention identity | Actual value |
| --- | --- |
| Clean export source | `05f9bec97d73329877d4f52a6c52f20e7fad4c92` |
| Export tree | `d13ecc992bf94ce05b8a9198aed8778aa289c3d5` |
| Artifact SHA256 | `5692fe044c43ec2061039ea1ad3bbdd7d7722ef59d8851b79d19b9b33b2af9b5` |
| Approval SHA256 | `ef53d4e42761ba803f3fb7938d97356f7ecdd2745cd5f60bf407866291131650` |

The [retention account](../qualification/c24-candidate-retention.md) links the
original examination, root decision and source/dependency identity. The export
source differs from the later containing candidates; capture-time observations
remain unchanged. Both historical and full-candidate comparisons are required
on the final candidate. Regeneration does not approve drift. A later justified
baseline revision needs explicit source/diff/review evidence, while the original
baseline and its history remain available. No general multiversion framework
is introduced. Exact type equality alone does not prove unchanged definition bodies.

## Qualification provenance and evidence limits

Step 7 closure is `7ca757d91e835400584fae1759560d1d83e0dbe269c42f73cbde377caffa6225`.
Step 8 closure is `0a8cb9718db8a34debb56af451c40a7ee31eeef48f790f67354c51bbb461554e`,
on candidate `ad6cf61f52738b8c381cd3179beedf52a963db0b`, tree
`d5fcbfbb0cecd2bc970805626079148649bba032`. Its final source is
`4939e0ef8fc71640c056396750229903b17fa6756c4ba34164db43327fcaec91`.
The actual Step 7/8 completion records under `.lit-review/setup/` bind original
reports, full parent reconciliation and final applicability; chronological prose
does not replace them.

All paths in the following table are beneath `.lit-review/setup/c24-08-20261027/`.
They describe the completed Step 8 execution, not an automatic qualification of
the future Step 9 SHA.

| Evidence | Actual record / SHA256 |
| --- | --- |
| Full maintained clean suite | `clean-policy-successor-01/result.json` / `4038670555d6de31512e77450aa33dcefe88e66b638f3f01404d5f3e587ff51f` |
| Fresh exact-SHA external qualification | `external-policy-successor-01/result.json` / `a69355c8284bf776772c186c3dfd863ba484e8c82782b51093b675de7ecc7d56` |
| Current two-pass file-mode API | `candidate-api-03/result.json` / `f1d2b5bc5e1a26e507bbea1b2676c2dc9f867865fabdcdefd2058c57b360c15f` |
| Rebuilt exact-release historical API | `historical-api-01/result.json` / `e24e5f43a91b61c9b6e0981194d3676a3212e576483536a8398f49114c2c8eb5` |
| Composed local staging/check | `candidate-staging-02/result.json` / `0d62137e86fa12dd402145cc0813a74786e386109475063507ca7e78e5fcbd47` |

The current raw API tree has 5554 files, 5539 HTML files and 664,519,346 bytes,
with digest `94282030393035c82f9b6a4e89230b9a6430b78ead7fdb55c38aa51144139980`.
Its source fingerprint is `cdd39e72924b31200bfcd82c3faaec8bd01dc44e47e56749d8229f83a4b6053b`.
File-mode source links are local inspection evidence. The historical rebuild uses
the exact v0.1.0 release and GitHub mode; its raw digest is
`e7b0aaf7f245638f856a0dcf3487bbdd45cf6e74d09a8e4df0dc587339546245`.
It is a newly retained rebuild, not a claim to have recovered unavailable bytes
from an earlier deployment. Its frozen staged route has 5534 files and digest
`9f38d8dd291c780fb72dff42701d7a116a2e33e7181553a9bdd492cfaa7e656f`.

The Step 8 composition digest is
`0621cc9303203ef978036b7defb3a6119e91bac6ee108839901196f63ba90f71`.
It has 11,130 files, 11,066 HTML files and **1,316,901,390 bytes**. It is explicitly
`NOT_FOR_PUBLICATION`, above the unchanged 1 GB publication guard. Local preview
permission does not waive that guard or the per-file limit. Step 9 document/site
changes require a fresh exact-commit composition/check and changed-page inspection.
Raw API reuse is permitted only after actual unchanged input/configuration/dependency,
output and source-link-meaning checks, retaining API03's original execution attribution.
Any invalidated gate must be rerun under its required authority.

Step 8 includes substantive independent review of all 218 selected rendered
contracts (210 additions plus eight retained contexts), 32 owner pages and frozen
route preservation. Earlier inspections retain their actual actors and dates;
exact correspondence supports reuse, not an invented fresh inspection. Final Step 9
evidence must identify the actual clean-suite and both-baseline results, exact-SHA
external fixture revision/resolution, raw-API applicability or rerun, site composition,
visual checks and final source/review applicability in its completion record.

Retain failed attempts, warnings, interrupted scans, unsupported native transport
proof, original report-path correction and review-tooling repair history separately.
Effective reviewer model settings were not observed; read-only restrictions are
cooperative. The Step 8 reviewer independently assessed source but disclosed limited
exposure to root factual/status labels; do not describe that review as fully blind.
Warm-cache local Windows qualification is not cold-build, Linux, public CI or
publication evidence.

## Remaining owners and concrete triggers

| Item | Disposition, owner and trigger |
| --- | --- |
| Site size | Release/website owner must produce and qualify a publication-eligible composition before deployment. The current 1.317 GB local preview remains blocked; do not raise or bypass the guard silently. |
| Raw navbar paths | Current and frozen `navbar.html` retain `.//LeanInfoTheory.html`. Step 8 passed only with the examined local server's repeated-slash canonicalization. The release/website owner must check root/search/owner/return navigation on the intended host, or obtain a separately reviewed generator/artifact correction with required requalification. Preserve frozen historical bytes; do not claim the raw defect fixed or production hosting qualified. |
| Shannon version sentence | `LeanInfoTheory/Shannon.lean:41` still says `0.1.x`; the complete present stack is the unpublished v0.2.0 candidate. Root revised the optional Step 8 timing suggestion: the exact retained producer hashes every Lean file, and a docstring edit would require a new clean capture/examination/binding solely for one sentence. Keep this limitation explicit and expose the deferral to cumulative review. The separate final release/baseline-binding owner must correct it with explicit source/diff/review approval and full affected requalification before publication. The original finding is unchanged and not marked fixed. |
| Retained baseline release binding | Release owner binds the verified full surface to the actual final qualified public source, preserves the original historical baseline and prior candidate captures, and records any justified source-bound revision. |
| External cache verification cost | `lit-finding:C24.06:SELF-CACHE-VERIFY-DUPLICATION` remains optional. The external-fixture maintainer may examine the update hook and explicit cache retrieval at the next separately selected recipe change; preserve explicit cache availability when the hook is disabled. The two successful invocations need not have identical scope. Keep the qualified recipe unchanged until such work is selected, and recompile at the resulting candidate SHA. |
| Optional mathematics/API convenience | Prior handoffs retain their theorem, alias, constructor, finite-prefix fixture and blueprint/equation-expansion triggers. Additions require actual proof/consumer pressure and their owning approved task. No optional idea is silently made required or claimed delivered. |
| Standing maintenance | Preserve root/import ownership, support/null-fiber conventions, conservative simp policy, source adaptations, trust and hygiene. Future Work Notes remain standing unless their specific delivered slice was already closed; C24 does not close them wholesale. |

The version-prose item reconciles both original IDs,
`lit-finding:C24.05:REVIEW-UMBRELLA-VERSION-WORDING` and
`lit-finding:C24.08-SHANNON-VERSION-PROSE`, as one unchanged optional defect.

## PFR case study and separate release actions

The [case-study draft](../qualification/c24-pfr-case-study-draft.md) remains planned
release content awaiting exact wording/link approval. The project is
PerfectFunctionalRepresentationsLean, distinct from `teorth/pfr`. The recorded
public observations are dated 2026-10-26 at `943578126eae7425fe16e9fa43b678eeb4807e5f`;
its dependency is historical LeanInfoTheory v0.1.0, not this candidate. Public
material, new summary wording, private assessment disclosure and outreach are
separate permissions. Refresh intended public links before approval/publication;
do not infer a project rebuild, dependency upgrade, private disclosure or candidate
adoption from those observations.

The release owner must separately approve and record the following unexecuted actions:

1. Final version/date/citation metadata and any further source amendment or checkpoint.
2. Actual public commit availability and remote CI for the final qualified identity.
3. Final full-surface retained-baseline binding and the source-prose correction above.
4. Publishable GitHub-mode API links against the actual clean public commit, correct
   current/frozen/reserved route composition, site-size guards and host navigation.
5. Push, tag, GitHub Release, versioned `/docs/v0.2.0/`, stable-pointer switch and Pages deployment.
6. Exact PFR summary wording/link approval; private disclosure or outreach only if separately authorized.
7. Archive/DOI creation or verification, with the actual final release identity and citation metadata.

Stable remains v0.1.0 throughout C24. The candidate has no issued date/version DOI
or v0.2.0 tag. Canonical package/CFF say unpublished 0.2.0; Lean/mathlib stay 4.33.1.
Apache-2.0, EPFL rights-holder, creator and affiliation remain unchanged. Historical
identifiers stay historical. No second-release chat is started or messaged by this handoff.

## Requalification after C24

C24 acceptance remains bound to its actual qualified source. Later work records
new evidence without rebinding old closure or artifact records.

| Later change | Required qualification |
| --- | --- |
| Any final source or metadata amendment | Full maintained clean suite and both retained-baseline comparisons on the resulting candidate; resolve and compile the external consumer at its exact SHA. Valid incremental caches remain allowed and disclosed. |
| API generation inputs, source-link mode or relevant documentation artifacts | Check exact applicability and rerun invalidated API/artifact gates. Publication needs verified GitHub-mode links against the actual clean public commit; local file-mode evidence is insufficient. |
| Mathematical/API/import/assumption or dependency-pin change | Required explicit approval, affected producer/consumer checks and both API contracts, plus renewed appropriate independent review and the clean/artifact duties. Never regenerate away a compatibility failure. |
| Unchanged-source publication/site transition | Recheck commit/tag/artifact identities, route composition, stable-pointer targets, host navigation and publication guards; execute only separately authorized actions and preserve actual outcomes. Source changes invoke the rows above. |

Publication must identify the **actual final qualified commit**. It cannot inherit
readiness silently from the Step 8 candidate or any earlier Step 9 checkpoint.
