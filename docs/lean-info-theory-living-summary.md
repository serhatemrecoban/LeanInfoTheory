# LeanInfoTheory Living Project Summary

This is the canonical living project-memory document for LeanInfoTheory. It is
an orientation and reconciliation layer, not a replacement for Lean source,
`AGENTS.md`, the project log, or focused mathematical plans.

Status labels used below:

- **[Current]** verified against the validated Lean/source baseline in Section 1;
- **[Decision]** an active design rule with historical rationale;
- **[History]** useful context that does not itself describe current status;
- **[Superseded]** an earlier plan or status replaced by later work;
- **[Uncertain]** a question that must be rechecked before implementation.

## Table of Contents

- [0. AI Assistant Quick Start](#0-ai-assistant-quick-start)
- [1. Document Status](#1-document-status)
- [2. Project Mission and Scope](#2-project-mission-and-scope)
- [3. Stable Mathematical Conventions](#3-stable-mathematical-conventions)
- [4. Source-of-Truth Hierarchy](#4-source-of-truth-hierarchy)
- [5. Current Mathematical Coverage](#5-current-mathematical-coverage)
- [6. Cover-Thomas Chapter 2 Coverage Matrix](#6-cover-thomas-chapter-2-coverage-matrix)
- [7. Current Lean Module and API Architecture](#7-current-lean-module-and-api-architecture)
- [8. Development History by Phase](#8-development-history-by-phase)
- [9. Stable Design Decisions and Rationale](#9-stable-design-decisions-and-rationale)
- [10. Rejected and Superseded Approaches](#10-rejected-and-superseded-approaches)
- [11. Known Limitations and Open Questions](#11-known-limitations-and-open-questions)
- [12. Active Work](#12-active-work)
- [13. Future-Work Register](#13-future-work-register)
- [14. Completed, Superseded, or Obsolete Future Work](#14-completed-superseded-or-obsolete-future-work)
- [15. Textbook and Reference Coverage](#15-textbook-and-reference-coverage)
- [16. Validation State](#16-validation-state)
- [17. Guidance for Different Assistant Roles](#17-guidance-for-different-assistant-roles)
- [18. Pointers to Detailed Historical Records](#18-pointers-to-detailed-historical-records)

## 0. AI Assistant Quick Start

**[Current] What this project is.** LeanInfoTheory is a Lean 4/mathlib library
for reusable finite discrete information theory over mathlib `PMF`s, including
semantic bridges to measures, KL divergence, channels, Markov structure, data
processing, and sufficient statistics. Certificate representation, checking,
import, and application demonstrations belong to downstream projects and are
not part of the LeanInfoTheory `v0.1.0` surface.

**[Current] Mathematical phase.** Project B is active. Cover--Thomas Chapter 2
Chunks 1-8 are checkpointed, with Chunk 8 complete through `C8.24` at source
checkpoint `1eef2289c3475ff978569f285329bdc78e060594`. The frozen
18-declaration surface adds four lightweight conditional-family CMI chain
rules, common-base channel conditional KL with finite `ENNReal` weighted and
joint chain rules plus guarded Real forms, and finite-family mutual
independence with the n-way entropy-additivity equality case. All new heavy
owners remain opt-in, and the root and certificate trust boundary are
unchanged. Generated/public references and the independent build, consumer,
trust, website, and hygiene gates all pass. The checkpoint is pushed, and its
exact-SHA Lean build/placeholder and Pages deployment workflows both pass.
Post-release mathematical planning is authorized: the proposed
[C9--C24 chunk map, revision 2](plans/post-release-chunk-map.md) awaits review.
Its accepted second-review clarifications are recorded under C18/C23 and
Section 8. The separately authorized review-workflow installation is documented
in [the protocol](review-protocol.md) and [operations](review-operations.md).
C9 is complete through C9.07 by its actual private completion record at source
checkpoint `8ee0337b20c320c384d5637de852da7f4ee09728`. The
[maintained C9 handoff](handoffs/chunk-9.md) preserves delivered APIs, evidence
and remaining-work dispositions; its captured pre-closure wording does not reopen
that completed chunk.

C10 is complete through C10.07 at source checkpoint
`37b4ba90d1ab321645f80cacef475f10a3a6ba43`, by its actual private completion
record. The [C10 handoff](handoffs/chunk-10.md) preserves its delivered 25-declaration
TV API and evidence; its provisional chronology does not reopen the completed chunk.

The approved [C11 plan, revision 2](plans/post-release-chunk-11.md) is complete
through C11.06 by its private closure at `bbead98`. The following paragraphs
retain its checkpoint and validation history.
C11.01--C11.05 and their reviews are complete by their private records, most
recently `.lit-review/setup/c11-05-completion-20260926.json`. The completed
predecessor and its exact source were verified before selecting C11.06 with review.
The cumulative candidate retains the ten public coupling declarations and both
private consumer owners, including the actual maximal witness and its swap in
Fano with exact TV error and independent-product measure interoperability.
The C11 cumulative candidate recorded 638 documented declarations in
33 owners, with 94 reviewed simp declarations and 92 facade aliases. Its baseline inventory
recorded 52 modules, 110 local edges, 5 root-reachable and 47 separate-import
modules, with 753 indexed declarations (752 documented and one example-only instance).
The lead explicitly authorized the exact local checkpoint and necessary
C11.06-only amendments. Initial checkpoint
`2147dd3449af620f41d9bed8d37c5be8252f20e8` passed the clean complete routine
suite and real two-pass current file-mode API-doc gate; the
[maintained C11 handoff](handoffs/chunk-11.md) identifies original results and the
actual Coupling-page inspection. Any amended candidate requires renewed complete
routine validation and exact API-doc applicability. C11.06's source-bound private
records establish the fresh all-17-criterion review, original-report
reconciliation, final validation and review applicability, final capture and
closure. This maintained chronology does not itself certify completion.
C12 is complete through C12.04 at `492cd6e60c5d6b42a22ef2dcbb45d21067b6d378`,
by `.lit-review/setup/c12-04-completion-20261003.json`. Its captured provisional
wording is historical; the [C12 handoff](handoffs/chunk-12.md) preserves
contracts, validation and remaining-work owners. The lead accepted the
[C13 revision-2 plan](plans/post-release-chunk-13.md). C13.01--C13.03 and their
reviews are complete, most recently by
`.lit-review/setup/c13-03-completion-20261003.json`. C13.03's exact final source
was verified before the lead's conditional C13.04 request was accepted.
C13.04 selected cumulative qualification and the [C13 handoff](handoffs/chunk-13.md).
The lead authorized the 25-file checkpoint, separate clean validation checkout
and C13.04-only amendments. Initial checkpoint
`17fb736a00448ecdd0aa824fd1928713bf716f01` passed the full routine suite in
1975.056 seconds. The [C13 notes](plans/post-release-chunk-13-notes.md)
retain the initial-checkpoint evidence and limits; subsequent validation,
review and closure are established by C13.04's source-bound completion record.
C13.04 is now verified complete at `ebe48eaea4282b1e4f245f8f45440bc930b8df73`
by `.lit-review/setup/c13-04-completion-20261003.json`; the paragraphs above
retain captured pre-closure history. The lead accepted the
[C14 revision-2 plan](plans/post-release-chunk-14.md). C14.01--C14.03 and their
reviews are complete, most recently by
`.lit-review/setup/c14-03-completion-20261007.json`. All 219 captured entries
matched Step 3's final source before the conditional C14.04 request was accepted
on 2026-10-08. The focused `Shannon.Continuity` owner contains the six planned
declarations: exact entropy, the capped scalar bound and monotonicity, and
entropy/conditional-entropy/MI budget bounds. Private consumers exercise sparse
joint laws, changing marginals, mixed thresholds, degeneracy, swap orientation
and arbitrary-source RVs. The [C14 handoff](handoffs/chunk-14.md) records delivered
contracts and remaining-work boundaries; the [notes](plans/post-release-chunk-14-notes.md)
retain original evidence and the historical revision-1 review limitation.
C14.04 is selected. The lead authorized the prepared 23-file local checkpoint,
necessary C14.04-only amendments and clean-checkout reuse. Initial checkpoint
`ca079e2` passed the complete routine suite; current two-pass API-documentation
qualification and inspection also passed. Final-candidate qualification,
cumulative all-12-criterion review, reconciliation and closure remain subject
to source-bound private records. C15--C24 remain unselected.

**[History] C15.01 qualification, 2026-10-13.** C14 completed through C14.04 at
`e982ba7cb0ac0460c90777820659482eed4e2b0e`, by
`.lit-review/setup/c14-04-completion-20261008.json`; the preceding C14
qualification paragraphs are retained history. The lead accepted
[C15 revision 2](plans/post-release-chunk-15.md) and explicitly selected only
C15.01 with review. Its new `Probability.FiniteTopology` owner forwards the PMF
product/subtype topology, supplies the real-standard-simplex homeomorphism and
finite compactness, and characterizes arbitrary-filter convergence by real atom
masses. Both zero masses and empty alphabets are included. Validation and review
status are maintained in Sections 12 and 16; closure requires the private record.
C15.02--C15.05 and C16--C24 remain unselected. No formal PLAN report is claimed.

**[History] C15.02, 2026-10-13.** C15.01 completed successfully by
`.lit-review/setup/c15-01-completion-20261013.json`; the preceding qualification
paragraph retains its pre-closure chronology. The lead conditionally selected
C15.02 with review, and its exact predecessor source matched at intake.
`Probability.TotalVariationTopology` adds joint continuity of existing finite TV
and the TV-to-zero convergence iff. Its focused consumers compose both
coordinate/TV equivalences and approach a pure law through the specified Boolean
family, with exact masses and TV. Required validation passed and the independent
review satisfied all three criteria without findings. Sections 12/16 retain the
evidence limits; the supported private record establishes final closure.
C15.03--C15.05 and C16--C24 remain unselected.

**[History] C15.03, 2026-10-13.** C15.02 completed successfully by
`.lit-review/setup/c15-02-completion-20261013.json`; its exact final source
matched before the lead's conditional Step 3 request was accepted. The existing
`Probability.FiniteTopology` owner now adds fixed map/bind continuity with only
finite input and arbitrary output, and joint-law continuity for arbitrary
alphabets. Permanent consumers check those signatures, compact channel images,
a noninjective deterministic map and the connected stochastic boundary family.
Required validation passed, and the independent reviewer assessed all three
criteria satisfied with no findings. Sections 12/16 retain the evidence and
limits; final applicability and supported private closure establish completion.
C15.04--C15.05 and C16--C24 remain unselected.

**[History] C15.04, 2026-10-13.** C15.03 completed successfully by
`.lit-review/setup/c15-03-completion-20261013.json`, with all three criteria
satisfied and no findings. All 230 captured entries matched its final source
before the lead's conditional Step 4 request was accepted. The new focused
`Shannon.Topology` owner adds finite entropy, conditional-entropy, MI and actual
fixed-channel input MI continuity. The permanent `Examples.ChannelOptimization`
consumer obtains an actual maximizing input and checks connected boundary limits
and empty/singleton cases. Required validation passed and the independent
review assessed all four criteria satisfied with no findings. Sections 12/16
retain the evidence and limits; supported private closure determines completion.
C15.05 and C16--C24 remain unselected.

**[Current] C15.05, 2026-10-13.** C15.01--C15.04 and their reviews are
complete by their private records. Step 4 closure is recorded in
`.lit-review/setup/c15-04-completion-20261013.json`; all 232 final source entries
matched before conditional Step 5 intake. The [C15 handoff](handoffs/chunk-15.md)
records the 16 delivered public declarations, focused imports, actual maximizing
input consumer and boundary/degeneracy policy. The lead authorized the prepared
20-file local checkpoint, C15.05-only amendments within those paths and reuse
of the relocated validation checkout. Initial checkpoint `000aae22bf2db249e0286183b6cd3ebf4e910aba` passed the complete maintained routine suite in 3435.257 seconds.
Actual two-pass API-doc qualification and rendered inspection passed separately.
Amended-candidate qualification, fresh all-17-criterion review, reconciliation
and supported closure depend on their exact source-bound records. C16 and later
chunks remain unselected.

**[Current] `v0.1.0` release and maintenance.** The fulfilled release contract
is recorded in [`docs/v0.1-release-contract.md`](v0.1-release-contract.md). It
selects a certificate-free finite-information-theory library surface, canonical
nats with opt-in scalar conversion, Lean/mathlib `v4.33.1`, and versioned
signature-bearing API documentation. Certificate representation and checking
belong downstream; reusable finite-family, entropy, channel, KL, Markov,
independence, data-processing, and sufficiency mathematics remains upstream.
`ShannonCert` has not been accessed or modified.

The release was published on 2026-09-01 from exact commit
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`. Annotated tag object
`bcd9090ea2720fe14b0a3e168c76ebeef1dafd47` peels to that commit; the GitHub
Release is immutable, and the tag-triggered routine gates and exact-commit
Pages deployment passed. The standalone Step 15 safety commit
`81ffef37402909481c5dea51a42973dee9a79ae6` permanently removed the automatic
tag/Release workflow and nothing else; the later
`f0d06dfab4f411ced312294e63e96bb67bba859b` reconciliation remains an
intermediate history point. The Pages workflow remains manual-only, requires a
`publish` boolean that defaults to `false`, and guards deployment separately.
Its post-release maintenance path takes unversioned project-status pages from
current `master` and rebuilds `/docs/v0.1.0/` from the exact release checkout.
Separate current-site/frozen-API identities, a full route digest, and
path-scoped link checks prevent the versioned API from being rebound.

The release surface has a five-module lightweight root, a 31-module full
Shannon umbrella, 601 documented supported declarations, 92 root exports, and
94 reviewed `simp` declarations. All 13 development/example/reference anchors
remain non-stable. The complete source-derived inventory is 44 modules, 90
local edges, five root-reachable modules, 39 separate-import modules, and 716
declarations (715 documented plus one example-only instance). The validator
enforces builds, trust and placeholder policy, frozen API/import boundaries,
proof dependencies, generated references, final release-documentation markers,
five independently compiled README examples, website integrity, workflow
safety, metadata, and repository hygiene.

École polytechnique fédérale de Lausanne (EPFL) is the rights holder; Serhat
Emre Coban is the sole software creator with affiliation `EPFL, Mathematics of
Information Laboratory`; Apache-2.0 remains the licence. `CITATION.cff` is
canonical, `.zenodo.json` and a redundant `NOTICE` remain absent, and the
tagged CFF is DOI-free. The evolving default-branch CFF records version DOI
`10.5281/zenodo.22229599`; the all-versions DOI is
`10.5281/zenodo.22229598`. Zenodo record `22229599` and DataCite carry the
structured institutional `RightsHolder`, and the 897,807-byte archive matches
all 110 files in the immutable tag byte-for-byte. The fixed Europe/Zurich
publication date is `2026-09-01`. Post-release DOI propagation changes no Lean
source, public API, toolchain, dependency, licence, tagged file, or release
asset.

**[Decision] Architectural rules that must be preserved.**

1. Use mathlib `PMF`, measure, kernel, KL, binary-entropy, and q-ary-entropy
   APIs. Do not create a toy or parallel probability theory.
2. Keep `LeanInfoTheory.lean` lightweight and mathematical. Use
   `LeanInfoTheory.Shannon` for the complete supported mathematical stack and
   focused imports when dependency weight matters. `Basic`, examples, and
   reference anchors remain explicitly non-stable and outside both umbrellas.
3. Keep canonical finite information measures in `Real` and in nats.
   Base conversion is theorem-level, opt-in infrastructure.
4. Keep lightweight algebraic definitions separate from heavier semantic
   PMF/measure/KL theorems.
5. Do not introduce `sorry`, `admit`, project axioms, `opaque`, or
   `undefined`.
6. Preserve support guards, `ENNReal.top`, and null-fiber conventions. They
   are mathematical contracts, not implementation noise.
7. During active theorem work, do not rename correct public declarations.
   Record awkward names in Future Work Note 14 and review aliases at a planned
   API checkpoint.
8. Add helpers, aliases, bundled structures, and symmetric theorem variants
   only after concrete proof or consumer pressure.
9. Treat predictable API discovery as a design objective. Before reproving a
   result, follow the source/index/API-doc/module/mathlib/Lean-search process in
   [`docs/downstream-api-feedback.md`](downstream-api-feedback.md), verify any
   candidate with a compiling probe, and retain only deduplicated actionable
   downstream friction upstream.
10. For Lean changes, run focused builds while iterating and the maintained
   milestone suite before a checkpoint.

**Source order.** Read current source first, then current checked-in plans and
documentation, then the exact relevant textbook statements, then history and
temporary handoffs. See Section 4 for the conflict protocol.

**What to read next by task type.**

| Task | Read next |
| --- | --- |
| Post-release mathematics | The approved [C15 plan](plans/post-release-chunk-15.md), [notes](plans/post-release-chunk-15-notes.md), [C14 handoff](handoffs/chunk-14.md), [reference register](references.md), Sections 3, 7, 11--16 and actual Lean dependencies. C9--C14 are complete by private records. C15.01--C15.04 are complete by private records; C15.05 selects cumulative qualification and the [C15 handoff](handoffs/chunk-15.md). Later chunks remain unselected. |
| Chunk 8 review or later-phase intake | The completed Chunk 8 plan; Sections 3, 6-9, 11-14, and 16; the three Chunk 8 mathematical owners, two maintained example owners, semantic/examples aggregates, and current Future Work Notes 9, 14-18, and 24 |
| Review of an existing Lean theorem | Sections 3, 7, 9, and 16; the owning source module and its direct imports |
| API or module review | Sections 7, 9, 10, 11, and Future Work Notes 2-4, 14-16, 18, and 26 |
| Downstream certificate compatibility | Sections 2, 5, 7, 11, and 13; preserve general mathematical APIs without adding checker-specific ownership upstream |
| Documentation or website work | Sections 1, 4, 5, 7, 11, and 16; `AGENTS.md` website rules |
| Grant or project-description work | Sections 2, 5, 6, 8, 11, and 13; distinguish implemented work from plans |
| General Assistant maintenance | Read the whole summary, then reconcile the project log, roadmap, and current Git state |

## 1. Document Status

| Field | Value |
| --- | --- |
| Last updated | 2026-10-13 |
| Recorded pre-C9 mathematical checkpoint | Chunk 8 source commit `1eef2289c3475ff978569f285329bdc78e060594`; the released `v0.1.0` source is exact commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f` |
| Repository transition state | `v0.1.0` is published from immutable tag object `bcd9090ea2720fe14b0a3e168c76ebeef1dafd47` and archived as Zenodo record `22229599`. The evolving default branch carries the current project pages and DOI metadata, while maintenance staging preserves `/docs/v0.1.0/` from exact release commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`; the tag, Release, archive, released Lean source, and frozen public API remain unchanged |
| Lean baseline | `v0.1.0` uses Lean `v4.33.1`, commit `819816b2e0a3bf405af45ae5c7af2491d8f5bee6` |
| mathlib baseline | `v0.1.0` uses input revision `v4.33.1`, manifest commit `0df444a360eaa60ab8c11dca51a86af692955474` |
| Source-snapshot phase | Post-release `v0.1.x`; C9--C14 and C15.01--C15.04 are complete by private records. C15 revision 2 is accepted; C15.05 selects cumulative qualification, canonical reconciliation and handoff. The lead authorized the exact 20-file local checkpoint, C15.05-only amendments and relocated-checkout reuse. Initial clean routine validation and separate two-pass API-doc qualification/rendered inspection passed; amended-candidate qualification, fresh all-17-criterion review and supported closure remain source-bound obligations. No push, publication or later chunk is selected. |
| Document ownership | Shared across project threads, with the project lead as decision authority |

**Purpose.** This file gives future assistants one maintained entry point for
project state, mathematical coverage, architecture, rationale, open questions,
and navigation. It should be detailed enough for planning and review but should
link to the project log instead of reproducing its chronology.

**Relationship to other documents.**

- [`AGENTS.md`](../AGENTS.md) is the operational instruction file. If an
  instruction here conflicts with `AGENTS.md`, follow `AGENTS.md` and repair
  this summary.
- [`docs/project-log.md`](project-log.md) is the detailed chronological record
  and currently owns the numbered Future Work Notes.
- [`docs/current-lean-state.md`](current-lean-state.md) is the long Lean status
  and completed-step record.
- [`docs/roadmap.md`](roadmap.md) is the public milestone roadmap.
- This living summary is the canonical cross-thread orientation and
  reconciliation layer among those sources.

**Update policy.**

1. Any project thread may edit this file when its work materially changes
   canonical project context. Separate authorization from the General
   Assistant is not required; the editing thread must reconcile affected
   sections against the governing source, builds, approved plans, project-log
   entries, and Git history.
2. Advance the validated Lean/source baseline after a coherent Lean checkpoint
   or source-changing merge. Documentation-only checkpoints do not redefine it.
3. Update Sections 0, 5, 6, 8, 12, 13, and 16 after each major mathematical
   chunk.
4. Update Sections 3, 7, 9, and 10 only when a convention, module boundary, or
   design decision actually changes.
5. Preserve completed rationale in Sections 8, 10, and 14 rather than silently
   deleting it.
6. Mark unresolved claims as **[Uncertain]**. Do not convert a conversation
   proposal into an approved plan without repository or user confirmation.
7. Verify every public declaration and module path named here against current
   source or the generated declaration index.
8. Keep this file readable as an onboarding document. Detailed step logs stay
   in `docs/project-log.md`.

## 2. Project Mission and Scope

### Mathematical goal

**[Current]** Build a rigorous, reusable finite-discrete information-theory
library that follows standard textbook mathematics while exposing theorem
statements useful for later coding, statistics, network information theory,
and converse arguments.

The present mathematical spine is Cover and Thomas, Chapter 2. Other local
references are used to refine theorem boundaries and later compatibility:
Yeung for entropy identities and certificate-facing algebra, El Gamal-Kim for
network-information-theory conventions, Polyanskiy-Wu for kernels,
sufficiency, tensorization, and estimation viewpoints, and Csiszar-Korner for
finite channels and divergence.

### Formalization goal

**[Current]** Connect a lightweight finite-PMF information-measure layer to
reusable semantic PMF, measure, kernel, KL, channel, Markov, data-processing,
and sufficiency theorems without conflating their import costs. Downstream
applications may use this mathematics for certificate checking or converse
proofs, but their representations and validators are not upstream library
responsibilities.

### Relationship to mathlib

**[Decision]** The project is mathlib-based and complementary to existing
formalization:

- reuse `PMF`, `PMF.map`, `PMF.bind`, `PMF.pure`, `PMF.toMeasure`, measures,
  kernels, and coding foundations;
- reuse `Real.negMulLog`, `Real.binEntropy`, and `Real.qaryEntropy`;
- reuse `InformationTheory.klDiv` and mathlib KL chain rules;
- add finite PMF-facing definitions and bridge theorems that are absent or
  inconvenient at the pinned version;
- upstream small generic lemmas only after assumptions and names stabilize;
- keep application-specific certificate syntax, checking, and import machinery
  downstream unless a genuinely reusable abstraction earns separate review.

### Intended users

- information theorists who want finite PMF and random-variable APIs;
- Lean/mathlib contributors interested in reusable finite probability or KL
  lemmas;
- researchers building checked entropy-inequality or converse automation;
- students and contributors working on bounded formalization tasks;
- documentation, grant, and project-description authors who need an honest
  implementation map.

### Current exclusions

**[Current]** The following are not part of the completed implementation:

- full source- or channel-coding theorems, channel capacity, or coding
  converses;
- AEP, typicality, method of types, entropy rates, or a stochastic-process
  hierarchy;
- general measurable-space entropy and sufficient-statistics theory;
- certificate representations, checking, search, primitive recognition, or
  PSITIP/oXitip import;
- canonical or minimal sufficient statistics;
- optimization beyond the selected finite fixed-channel attainment consumer,
  including constrained optimization and general minimax;
- theorem-level leanblueprint data, a blueprint PDF, and optional
  equation-expanded API-documentation pages.

Chunk 5 is also explicitly bounded away from a full coding theorem.

## 3. Stable Mathematical Conventions

### Finite probability and entropy

- **[Decision]** A finite distribution is a mathlib `PMF alpha`.
- `Shannon.entropy` requires `[Fintype alpha]` because its definition is the
  explicit finite sum
  `sum a, Real.negMulLog (p a).toReal`.
- Entropy values are `Real`.
- Canonical units are nats because the underlying logarithm is `Real.log`.
- `Shannon.Units` converts a real-valued quantity measured in nats to base `b`
  with `natsToBase b x = x / Real.log b`; `natsToBits` selects base `2`, and
  there is no duplicate hierarchy of base-indexed definitions.
- Zero-mass atoms contribute zero through `Real.negMulLog 0 = 0`.
- `selfInfo p a` also uses a zero branch at a zero-mass atom; only weighted
  statements assign it semantic significance there.

### Random variables and products

- A random-variable quantity is defined through the pushforward law
  `p.map X`. The source type need not be finite when only the value alphabet
  needs a finite sum.
- Joint entropy is entropy of a product-valued pushforward.
- Pair and triple marginals are `PMF.map` abbreviations.
- Lean products are right-associated. In ASCII notation, a triple law has type
  `Prod alpha (Prod beta gamma)`.
- Coordinate maps, swaps, and reassociations are explicit implementation
  devices. Public aliases should prefer mathematical left/right terminology
  only when it improves discovery without hiding a substantive orientation.

### Algebraic and semantic definitions

- `condEntropy`, `mutualInfo`, and `condMutualInfo` are defined in the
  lightweight layer by entropy identities.
- The semantic bridge proves the expected-conditional-law and KL forms.
- These are equivalent mathematical views; keeping the algebraic forms
  definitional also makes the lightweight API convenient for downstream
  symbolic consumers.
- Entropy and conditional-entropy chain rules are explicit rewrite theorems,
  not general `[simp]` normalizations.
- Finite-family mutual independence means pointwise factorization of every
  selected finite joint atom into its singleton masses. It is stronger than
  pairwise independence and is not a global indexed-family or measurable-
  independence predicate.

### Support and null fibers

- PMF support is the set of nonzero atoms; `PMF.supportFinset` is the canonical
  finite view when a `Fintype` is available.
- Support-aware statements use the law's actual support. For example,
  deterministic entropy preservation is characterized by injectivity on the
  mapped law's support, not global injectivity.
- `condFstGivenSnd` is defined only for a positive conditioning fiber.
  Numeric fiber entropy/CMI wrappers contribute zero on a null fiber.
- `condFstGivenSndChannel` and `channelPosterior` are total channels. On null
  fibers they use a documented fallback solely for totality. Weighted,
  support-restricted, or almost-everywhere theorems must make that choice
  irrelevant.
- No theorem should attribute conditional-probability meaning to a total
  posterior on a null fiber.

### Channels, Markov structure, and KL

- A finite channel is the raw function type `alpha -> PMF beta`; there is no
  bundled project channel structure.
- Output remains `p.bind W`; identity remains `PMF.pure`.
- `IsMarkovChainOf p X Y Z` means that `X` and `Z` are conditionally
  independent given `Y`.
- `IsCondIndependent` is defined by the null-fiber-safe cross-product identity;
  positive-fiber conditional-law statements are equivalences.
- Mathlib `InformationTheory.klDiv` is the canonical KL divergence and has
  codomain `ENNReal`.
- Unconditional KL contraction is stated in `ENNReal`. Real-valued KL theorems
  require support or finiteness hypotheses because `ENNReal.toReal top = 0`.
- `conditionalKlDiv r W V` compares `PMF.channelJoint r W` with
  `PMF.channelJoint r V`: both channels use the same base law `r`. Its
  definition is `ENNReal`-valued, and the finite weighted identity is
  unconditional; Real forms use explicit active-support guards to exclude
  infinite fibers.
- For finite PMFs, support inclusion is the operative absolute-continuity and
  KL-finiteness condition.

### Sufficiency

- `IsSufficientStatisticOf` is a fixed-law or fixed-prior predicate expressed
  by the reverse Markov chain `Theta -> T(X) -> X`.
- `IsSufficientChannel model W` is prior-free and family-level. Its quantifier
  order is `exists R, forall t`: one recovery channel is shared by the family.
- Family sufficiency requires exact recovery of the complete output-input
  joint law, not merely recovery of the input marginal.
- `IsSufficientStatistic` is exactly the deterministic-channel specialization
  of `IsSufficientChannel`.
- Pairwise KL equality for a larger model family does not automatically supply
  one coherent common recovery witness.

### Lean assumptions

- Prefer `[Fintype alpha]` when a statement exposes a finite sum or canonical
  enumeration.
- Prefer `[Finite alpha]` when finiteness is only used internally.
- Local measurable-space and measurable-singleton assumptions belong in
  measure/KL bridges, not in the elementary PMF vocabulary.
- Some current finite theorems intentionally carry stronger assumptions than
  the most general mathematics; Section 11 records the known cases.

### Downstream certificate boundary

- Certificate expressions, primitive tags, raw/checked structures, validators,
  adapters, and demonstrations are not LeanInfoTheory APIs.
- General finite-family inequalities and semantic results remain upstream and
  may be consumed by downstream certificate applications.
- No downstream extraction decision authorizes modifying `ShannonCert` during
  this release-preparation task.

## 4. Source-of-Truth Hierarchy

Use this order when claims disagree:

| Priority | Source | Use |
| --- | --- | --- |
| 1 | Current Lean source and successful builds | Declaration existence, theorem statement, assumptions, proof status, imports, and current behavior |
| 2 | Current checked-in instructions and approved plans | Operational policy, active phase, intended module boundaries, and approved next work |
| 3 | Exact relevant textbook statements | Mathematical intent, terminology, conventional orientation, and scope |
| 4 | Git history and targeted project-log entries | Why a design was chosen, what was tried, and when a boundary changed |
| 5 | Historical handoff reports | Conversation rationale not recoverable elsewhere; never authoritative for current names or status |
| 6 | Remote GitHub and deployed website | Public synchronization, CI, and presentation consistency |

### Conflict protocol

1. Verify the declaration or import in current source.
2. Verify the current branch, baseline commit, and build result.
3. Check `AGENTS.md`, the active project-log plan, and the roadmap.
4. Consult the exact textbook section only for mathematical intent, not for
   Lean ownership.
5. Use history to explain the discrepancy.
6. Record the conflict and its practical consequence. Do not silently select
   the most convenient source.

### Known source discrepancies at this baseline

- **[Superseded planning]** The original eight-chunk topic boundaries were
  revised by implementation. Conditional independence moved into Chunk 2;
  channels, DPI, and one-step doubly stochastic entropy growth moved into
  Chunk 3; sufficiency became Chunk 4. Use current source and Note 29, not the
  original labels, to assign ownership.

## 5. Current Mathematical Coverage

### Finite PMF comparison

C10.01 delivers `PMF.totalVariation` and its six core laws in
`Probability.TotalVariation`. The half-L1 definition requires only `[Fintype alpha]`
and two PMFs; it adds no support, inhabitedness or measurability hypothesis.
C10.02 source adds finite real event sums, the sharp event bound, the positive-part
formula, an explicit maximizing set, and signed/absolute `IsGreatest` contracts.
C10.03 adds five overlap/residual and disjoint-support theorems. Private consumers
check generic ENNReal normalization premises without constructing a normalized
law, equal/disjoint endpoints and sparse three-point laws with TV and all three
component totals equal to one half. C10.04 adds the interval-width and signed-
radius bounds, explicit indicator/sign attainment, and greatest absolute test
values. Private generic consumers recover both signed textbook forms from the
public API. C10.05 adds common-channel and arbitrary-map contraction and exact
equivalence invariance. A separate consumer uses raw channel composition laws
and verifies the Boolean noise channel reduces TV from one to one half. C10.06
connects all of these interfaces through private integrated consumers, including
the exact generic maximizing-event Boolean reduction, a shared parameter family,
subsingleton and empty alphabets, and joint projections. It adds no public API.

### PMF couplings

C11.01 source provides `PMF.IsCoupling joint p q`, defined by the two exact
coordinate pushforwards. Independent existence reuses constant `channelJoint`;
diagonal coupling and coordinate swap reuse `PMF.map`. The types and universes
may differ, and no finiteness, nonemptiness or measurability premise is added.
`Examples.Coupling` uses only the focused owner and checks both marginals,
heterogeneous existence, diagonal laws, swap orientation, swapping twice and
empty alphabets. C11.02 adds `PMF.IsCoupling.totalVariation_le`: every common-
alphabet finite coupling bounds TV by its Real disagreement probability. The
proof uses the attaining event and finite indicator sums. Consumers check both
coordinate orders, diagonal/subsingleton equality, disjoint and pure endpoints,
and asymmetric and strict fair-Boolean cases.

C11.03 source defines the actual `PMF.maximalCoupling` law and proves its two
marginals through `PMF.isCoupling_maximalCoupling`. The positive-TV branch uses
`PMF.ofFintype` on the common diagonal mass plus the product of the two residual
masses divided by TV. Private row/column proofs establish normalization and
marginals without a strict upper bound on TV. Private endpoint identities give
the diagonal law at TV=0 and the independent law at TV=1; private ternary checks
verify the common and residual atoms. C11.04 source adds the exact ENNReal
disagreement formula `PMF.maximalCoupling_toOuterMeasure_ne` and its Real
corollary `PMF.maximalCoupling_toOuterMeasure_ne_toReal`. Private proofs identify
the common diagonal mass, take a guarded event complement and handle the
diagonal and disjoint-independent endpoints explicitly. The example owner uses
only the public constructor, marginal theorem and event formulas to combine
exact disagreement with the universal coupling inequality, establishing attained
optimality. Equal, disjoint, pure, sparse ternary, asymmetric and degenerate cases
are covered; C11.01--C11.04 are complete by their private records.

The completed C11.05 consumer `Examples.CouplingFano` applies existing Fano to
this actual witness and its coordinate swap, using their four ordered marginal
equalities and exact identity-decoder error TV. It includes equal/subsingleton
endpoints and connects constant `channelJoint` to `Shannon.indepProd`, measurable
rectangles and product measures. Its helpers remain private. C11.01--C11.05
and their reviews are complete for their captured source; the
[C11 handoff](handoffs/chunk-11.md) preserves the contracts and evidence limits.
C11.06 owns cumulative qualification; its handoff records the initial successful
gates, while source-bound private records establish final validation, fresh
review, reconciliation and closure.

C12.01 adds coordinate-map transport and supplied-channel lifting through
`PMF.IsCoupling.map` and `PMF.IsCoupling.bind`, without finite or measurable
assumptions. Lifting uses the joint support, which may be smaller than the
product of marginal supports. Its private minimal-import consumer checks this
distinction with a swapped pure row whose two marginals are wrong at an unused
pair, while the lifted joint remains the same fair diagonal law.

C12.02 adds type-generic whole-extension equality exactly when channels agree
on the second marginal's support. The separate semantic Gluing owner extends
two pair laws with a common middle marginal into a Markov triple with both
exact pair laws, requiring only `[Finite gamma]`. Its private consumer obtains
the endpoint coupling from that same witness and tests distinct positive rows
and whole-triple invariance under changing a null fallback.

C12.03's private consumers lift actual maximal input and row couplings, identify
the lifted disagreement with a weighted sum of row TV distances, and prove the
stochastic contraction chain with guarded ENNReal-to-Real conversions. The
fair/pure/fair gluing regression proves both adjacent couplings maximal, then
computes independent endpoints of that same Markov triple. Its disagreement is
one half, strictly above both endpoint TV and diagonal-coupling disagreement.

### Finite Shannon layer

**[Current]** Implemented over finite PMFs and finite-valued pushforwards:

- entropy, random-variable entropy, and joint entropy;
- entropy nonnegativity and exact zero-entropy characterizations;
- invariance under equivalences, injective relabelings, swaps, and product
  reassociation;
- pair and triple marginals with pointwise mass and support infrastructure;
- algebraic conditional entropy, mutual information, and conditional mutual
  information;
- pair/triple chain rules, symmetry, self-information identities, standard
  entropy-difference forms, and the auxiliary-variable entropy/MI decomposition;
- dependent finite-family laws with finite `Finset` atoms, PMF/source entropy,
  conditional entropy, MI, CMI, pair/triple compatibility, and binary plus
  duplicate-tolerant ordered entropy, MI, and conditional-MI chain rules;
- deterministic entropy and mutual-information processing with support-aware
  equality/recovery cases;
- pair and triple inequality bands;
- finite-family monotonicity, submodularity, MI bounds, conditioning
  reduction, binary subadditivity, n-way singleton subadditivity, and equality
  exactly under finite-atom mutual independence;
- alphabet- and support-cardinality entropy bounds with exact uniformity
  equality cases;
- opt-in logarithm-base conversion.

Representative owners are `Shannon.Entropy`, `Shannon.InfoMeasures`,
`Shannon.FiniteFamily`, `Shannon.EntropyBounds`, `Shannon.Units`,
`Shannon.SemanticBridge.Theorems`, and
`Shannon.SemanticBridge.FiniteFamily`.

### Semantic PMF, conditional-law, and KL layer

**[Current]** The semantic bridge supplies:

- expected self-information;
- independent-product PMFs and product-measure semantics;
- finite conditional PMFs and expected fiber entropy;
- MI as a finite log-ratio sum and as KL to the product of marginals;
- CMI as averaged fiber MI and averaged fiber KL;
- PMF support characterizations of absolute continuity, finite/infinite KL,
  KL zero, and uniform-reference KL;
- common-base channel conditional KL, its finite weighted-fiber semantics,
  joint KL chain rule, and support-guarded Real forms;
- ordinary and conditional independence, including bridges to mathlib
  `ProbabilityTheory.IndepFun`, and deterministic right postprocessing for
  arbitrary PMF source/observed types (left processing follows by symmetry);
- dependent finite-family mutual independence, restriction and pair
  compatibility, and n-way entropy equality;
- zero MI/CMI and entropy equality cases.

The primary modules are `SemanticBridge.Product`, `FiniteSums`, `Conditional`,
`KL`, `Theorems`, `Independence`, `ConditionalKL`, and
`FiniteFamilyIndependence`.

For the finite discrete laws formalized here, pointwise factorization of every
selected joint atom is the probability-mass-function form of the textbook
finite-intersection or event-factorization definition of mutual independence.
The project does not add measurable-space assumptions or a public `iIndepFun`
conversion merely to restate that finite equivalence.

### Channels, Markov chains, and data processing

**[Current]** The channel layer includes:

- `PMF.deterministicChannel`, `PMF.channelComp`, `PMF.channelJoint`, and
  `PMF.channelExtension`;
- atom, projection, composition, deterministic, and support laws;
- total conditional channels and posterior reconstruction;
- PMF and random-variable Markov predicates;
- cross-product, positive-fiber, zero-CMI, reversal, canonical-factorization,
  and existential-factorization characterizations;
- the exact Markov information-loss identity;
- MI data processing, deterministic and stochastic one-sided/two-sided forms,
  channel cascades, and equality through the reverse Markov chain;
- a PMF-channel to mathlib-kernel bridge;
- exact posterior KL decomposition;
- unconditional `ENNReal` and support-guarded real KL data processing;
- invariant-reference contraction and one-step entropy growth under
  uniform-preserving or finite doubly stochastic channels.

The owners are `Probability.FiniteChannel`,
`SemanticBridge.Markov`, and `SemanticBridge.DataProcessing`.

### Sufficient statistics and KL equality

**[Current]** The finite sufficiency layer includes:

- fixed-prior sufficiency and its reverse-Markov, zero-CMI, MI-preservation,
  conditional-entropy-preservation, and exact-recovery characterizations;
- family-level sufficient channels with one common recovery witness;
- deterministic sufficient statistics as a specialization;
- supported common-posterior characterization;
- every-prior consequences and full-support/all-priors converses;
- a finite Fisher-Neyman factorization iff;
- posterior equality criteria for equality in KL data processing;
- common-recovery KL preservation and guarded converses;
- pairwise KL preservation for sufficient families and a guarded Boolean
  two-law converse.

The core owner is `SemanticBridge.Sufficiency`, whose only direct project
import is `SemanticBridge.Markov`. Posterior/kernel equality and recovery/KL
integration remain downstream in `SemanticBridge.DataProcessing` and
`SemanticBridge.Sufficiency.KL`. Generic `SemanticBridge.KL` is nevertheless
already in the core's transitive dependency closure through `Markov`,
`Independence`, and `Theorems`.

### Finite Fano and estimation error

**[Current]** The opt-in finite Fano layer includes:

- `entropy_bool`, identifying project entropy on `PMF Bool` with mathlib
  `Real.binEntropy`;
- type-generic deterministic decoding-error indicator and probability
  definitions on joint PMFs and random variables;
- a finite-sum error formula, probability range bounds, and entropy identities
  for the Boolean error indicator;
- exact expanded and `Real.qaryEntropy` Fano inequalities on PMF and
  random-variable surfaces;
- the conventional weak finite-alphabet inequality;
- generic decoding-error lower bounds; and
- mutual-information and normalized-error lower bounds under a uniform source
  law.

The exact and weak entropy forms include singleton source alphabets. The
cardinality hypothesis `2 <= Fintype.card alpha` appears only in the
corollaries that divide by `log |alpha|`. The owners are
`Shannon.BinaryEntropy` and `Shannon.Fano`; both remain outside the lightweight
root and semantic-bridge aggregate.

C11.05's separate private `Examples.CouplingFano` consumer specializes
`condEntropy_fano` to the actual maximal coupling and its coordinate swap.
Identity decoding has error exactly TV in both orientations; equal and
subsingleton inputs have zero error. This consumes the existing nats-valued
bounds without changing Fano's assumptions or adding an entropy-continuity
result. C11.05 is complete by its private record. The C11.06 initial gates cover
the complete chunk; final applicability and the required fresh all-criterion
review are established by its source-bound private records.

C14.01 adds `abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log` in
`Shannon.Continuity`. For any two laws on a finite alphabet it bounds the
absolute entropy difference by `h(TV) + TV * log(card - 1)` in nats, with Nat
subtraction before casting. It needs no full support, cardinal lower bound or
extra nonemptiness assumption. Its four coupling/Fano helpers remain private;
the focused owner directly imports only Coupling and Fano. Permanent private
consumers establish zero/maximal TV, empty/singleton behavior, the pure/fair
Boolean gap and the pure/uniform `Fin 3` threshold equality. A bound at an
upper TV estimate uses C14.02's `entropyContinuityBound`: zero for cardinality
at most one, the raw expression up to and including `1 - 1/m`, then `log m`.
`entropyContinuityBound_mono` holds on all nonnegative real budgets, and
`abs_entropy_sub_le_entropyContinuityBound` needs only `TV(p,q) <= epsilon`,
deriving budget nonnegativity and local nonemptiness internally. No upper bound
on epsilon or full-support premise is imposed. The q-ary bridge and scalar
endpoint/range proofs remain private. Consumers explicitly cross the ternary
threshold and apply TV contraction through a noninjective map using output
cardinality. C14.03 adds `abs_condEntropy_sub_le_entropyContinuityBound` and
`abs_mutualInfo_sub_le_entropyContinuityBound`. For joint laws on A x B, they
bound conditional-entropy change by `B_(m*n) + B_n` and MI change by
`B_m + B_n + B_(m*n)` at the same TV upper budget. Coordinate universes are
independent; each term uses its own ambient alphabet and threshold. The proofs
use existing entropy identities and projection contractions without new helpers
or imports. Sparse D/I/P consumers establish changing marginal values, mixed
branches, singleton reductions and arbitrary-source RV applications; no
pointwise continuity of conditional PMFs at null fibers is claimed.

### Downstream certificate consumers

**[Current]** LeanInfoTheory owns the reusable mathematics needed by downstream
consumers, including finite-family monotonicity, submodularity,
subadditivity, KL, independence, Markov, data processing, and sufficiency. It
does not own an entropy-expression language, primitive-tag vocabulary,
raw/checked certificate structures, validators, adapters, or certificate-only
demonstrations.

### Examples and public documentation

**[Current]** Separately importable examples exercise:

- support-sensitive entropy, functional dependence, and side information;
- the `KL = top` versus `toReal KL = 0` trap;
- a noisy common-cause Markov model;
- genuinely stochastic contraction and strict entropy growth;
- noninjective sufficient statistics, non-sufficiency, and the failure of
  marginal-only recovery;
- a perfect decoder, a singleton source alphabet, and a fair Boolean source
  with a concrete nonzero decoding-error probability exercising the finite
  Fano API;
- the C11.05 maximal-coupling Fano consumer in both coordinate orders, with
  exact TV error, equal/subsingleton endpoints and independent-product measure
  interoperability;
- homogeneous Boolean and heterogeneous Boolean/ternary finite families,
  ordered chains, overlapping entropy atoms, empty-family entropy, product and
  pairwise-but-not-mutually-independent laws;
- common-base conditional KL across null, active, finite, and infinite fibers,
  together with guarded Real and joint-chain formulas.

The website has a hand-written module guide, theorem highlights, generated
module dependency map, and source-derived declaration index. Its Steps 4--5
certificate-free/import-architecture reconciliation is local. Step 11 produced
separate signature-bearing doc-gen output, and Step 12 now stages that output at
`/docs/v0.1.0/` inside a Pages-shaped local preview. Preview staging suppresses
machine-local source links, connects generated and hand-written navigation,
records provenance, and remains explicitly unpublishable. The site still has
no theorem-level leanblueprint output.

## 6. Cover-Thomas Chapter 2 Coverage Matrix

Status terms refer to the project's finite-discrete scope. "Complete" does not
claim a general measure-theoretic formalization of the whole subject.

| Topic | Status and provenance | Representative declarations | Owner and layer | Limitations, downstream use, and remaining work |
| --- | --- | --- | --- | --- |
| **2.1 Entropy** | **Substantially complete.** Core predates the eight-chunk programme; zero/equality and units were strengthened in Chunk 1; the maintained Boolean bridge is Chunk 5; release Step 6 names scalar arbitrary-base and bits conversion. | `entropy`, `entropyOf`, `entropy_nonneg`, `entropy_eq_zero_iff`, `entropyOf_eq_zero_iff`, `entropy_eq_integral_selfInfo`, `natsToBase`, `natsToBits`, `entropy_div_log`, `entropy_bool` | `Shannon.Entropy` is lightweight; semantic expectation, units, and `Shannon.BinaryEntropy` are opt-in. | Nats are canonical. The Boolean bridge reuses mathlib `Real.binEntropy`; no parallel base-indexed information-measure hierarchy is maintained. |
| **2.2 Joint and conditional entropy** | **Substantially complete for pairs, triples, and finite subfamilies.** Core and expected-fiber semantics predate the programme; functional dependence is Chunk 1; pair equality cases use Chunk 2 independence; finite-family atoms are Chunk 6; n-way equality is Chunk 8. Chain-rule work is catalogued under 2.5. | `jointEntropyOf`, `condEntropy`, `familyEntropy`, `familyEntropyOf`, `familyCondEntropy`, `condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd`, `familyEntropy_eq_sum_singletons_iff_isMutuallyIndependentFamily` | Pair/triple algebra in lightweight `InfoMeasures`; dependent finite-atom algebra in opt-in `Shannon.FiniteFamily`; conditional PMFs and equality consequences in semantic modules. | `Var` may be infinite, alphabets may depend on the variable, and entropy is applied only after finite restriction. Null fibers use explicit zero or totality conventions. Mutual independence is selected-atom pointwise factorization, not a global process predicate. |
| **2.3 Relative entropy and mutual information** | **Substantially complete at finite PMF level.** MI/KL bridges predate the programme; support/finiteness, equality, and uniform-reference results are Chunk 2; channel KL is Chunks 3-4; finite joint convexity is Chunk 7; common-base channel conditional KL is Chunk 8. | `mutualInfo`, `mutualInfo_eq_toReal_klDiv_joint_prod_marginals`, `toMeasure_absolutelyContinuous_iff_support_subset`, `klDiv_pmf_ne_top_iff_support_subset`, `klDiv_pmf_eq_zero_iff`, `klDiv_bind_le_sum`, `conditionalKlDiv`, `conditionalKlDiv_eq_sum` | `InfoMeasures` plus heavy `SemanticBridge.KL`, `DataProcessing`, `SemanticBridge.Convexity`, and `SemanticBridge.ConditionalKL`; KL itself is mathlib's `InformationTheory.klDiv`. | Real KL requires support/finiteness guards. The local conditional object compares two PMF channels over one common base; no arbitrary-joint or two-base conditional-KL definition is introduced. |
| **2.4 Entropy/MI relationships** | **Complete for the finite pair and finite-atom algebraic surfaces.** Symmetry predates the programme; the pair identity family is Chunk 1; overlapping-atom family identities are Chunk 6. | `mutualInfoOf_eq_entropyOf_sub_condEntropyOf`, `mutualInfoOf_swap`, `mutualInfoOf_self`, `familyMutualInfo_eq_entropy_sub_condEntropy`, `familyCondMutualInfo_eq_condEntropy_sub_condEntropy` | Lightweight `Shannon.InfoMeasures` plus opt-in lightweight `Shannon.FiniteFamily`. | Rewrites remain explicit. Reverse-oriented aliases and exhaustive PMF/source mirrors are intentionally not generated without proof pressure. |
| **2.5 Chain rules** | **Substantially complete for the finite algebraic scope.** Pair/triple rules predate or belong to Chunk 1; Chunk 6 adds binary-union and duplicate-tolerant ordered finite-family entropy/MI rules; Chunk 8 adds the corresponding law/source conditional-MI rules and finite common-base relative-entropy chain rules. | `entropy_chain_rule_left`, `familyEntropy_eq_entropyChain`, `familyMutualInfo_eq_mutualInfoChain`, `familyCondMutualInfo_union_chain_rule`, `familyCondMutualInfo_chain_rule`, `conditionalKlDiv_eq_sum`, `klDiv_channelJoint_eq_add_conditionalKlDiv` | Lightweight pair/triple and finite-family algebra plus opt-in `SemanticBridge.ConditionalKL`. | Ordered family rules permit repeated names, overlaps, and initial conditioning; no automatic permutation, reverse-orientation, or exhaustive source-wrapper families are generated. Conditional KL uses one common numerator base and canonical `ENNReal` values. |
| **2.6 Jensen and consequences** | **Substantially complete for currently used finite consequences.** Initial alphabet bounds predate the programme; sharp support/equality and pair independence endpoints are Chunks 1-2; finite-family monotonicity, submodularity, conditioning reduction, MI bounds, and n-way subadditivity are Chunk 6; the n-way equality case and finite-family mutual-independence API are Chunk 8. | `entropy_le_log_card`, `entropy_eq_log_card_iff_eq_uniformOfFintype`, `familyEntropy_mono`, `familyEntropy_submodular`, `familyEntropy_le_sum_singletons`, `IsMutuallyIndependentFamily`, `familyEntropy_eq_sum_singletons_iff_isMutuallyIndependentFamily` | Jensen-heavy `EntropyBounds` is opt-in; family inequalities live in `SemanticBridge.FiniteFamily`; equality and factorization live downstream in `SemanticBridge.FiniteFamilyIndependence`. | The project reuses mathlib Jensen/strict concavity rather than formalizing a local general Jensen theorem. The predicate is finite-atom pointwise factorization; no global indexed-family or public measurable-independence bridge is added. |
| **2.7 Log-sum and convexity applications** | **Implemented, independently validated, and checkpointed for finite PMFs in Chunk 7.** The scalar, mixture, entropy, KL, and MI theorem layers are complete through `C7.22` in checkpoint `5e616d8`. | `logSum_inequality`, `logSum_eq_iff_exists_constant_ratio`, `real_logSum_inequality_of_support`, `sum_mul_entropy_le_entropy_bind`, `binaryMixture_entropy_eq_iff`, `klDiv_bind_le_sum`, `klDiv_binaryMixture_eq_iff`, `sum_mul_mutualInfo_channelJoint_le`, `mutualInfo_channelMixture_le_sum` | Scalar `Shannon.LogSum`; PMF construction in `Probability.FiniteMixture`; Jensen entropy layer in `Shannon.EntropyConcavity`; KL/MI results in heavy `SemanticBridge.Convexity`. All remain opt-in. | Canonical KL statements are `ENNReal`-valued; Real forms have active support guards. General-selector equality classifications, MI/channel equality cases and finite-family wrappers remain deferred. C15.01 supplies the PMF topology/simplex/compactness foundation; C15.04 adds qualitative finite information continuity and a private actual-attainment consumer. |
| **2.8 Data processing** | **Substantially complete for finite PMFs and finite-valued random variables.** Deterministic processing is Chunk 1; Markov and stochastic MI/KL DPI are Chunk 3; KL equality/recovery is Chunk 4. | `IsMarkovChainOf`, `mutualInfoOf_markov_chain_rule`, `mutualInfoOf_dataProcessing`, `mutualInfoOf_dataProcessing_eq_iff`, `klDiv_channel_le`, `toReal_klDiv_channel_le` | `SemanticBridge.Markov` and `DataProcessing` are opt-in; the raw channel core is lighter but still outside root. | No general measurable stochastic-variable coupling API. Strict-loss variants and some symmetric forms remain proof-pressure deferred. |
| **2.9 Second law / stochastic entropy growth** | **Partial.** One-step finite consequences are Chunk 3. | `klDiv_channel_invariant_le`, `toReal_klDiv_channel_invariant_le`, `entropy_le_entropy_bind_of_uniform_invariant`, `entropy_le_entropy_bind_of_doublyStochastic` | Heavy `SemanticBridge.DataProcessing`; examples in `Examples.StochasticChannels`. | No iterated channel powers, stationary-process object, entropy rate, matrix bridge, or Birkhoff/majorization theory. A matrix-facing bridge is deferred by Note 38. |
| **2.10 Sufficient statistics** | **Substantially complete for finite fixed-prior and finite family recovery.** Chunk 4. | `IsSufficientStatisticOf`, `IsSufficientChannel`, `IsSufficientStatistic`, `isSufficientStatisticOf_iff_exists_recovery`, `isSufficientChannel_iff_exists_common_posterior`, `isSufficientStatistic_iff_exists_fisherNeymanFactorization`, `klDiv_channel_eq_iff_exists_common_recovery` | Lightweight `Sufficiency`; posterior/KL statements in downstream heavy modules. | Canonical/minimal statistics, iid count-statistic infrastructure, and general measurable sufficiency are deferred. Larger-family pairwise KL equality does not yield a global witness. |
| **2.11 Fano's inequality** | **Substantially complete for finite deterministic decoding.** Chunk 5 through `C5.20`. | `decodingErrorIndicator`, `decodingErrorProbability`, `entropy_decodingErrorIndicator`, `condEntropy_fano`, `condEntropy_fano_qary`, `condEntropyOf_fano`, `condEntropy_fano_weak`, `decodingErrorProbability_fano_lower_bound`, `mutualInfo_fano_lower_bound_of_uniform_source` and their `...Of` companions | Opt-in `Shannon.BinaryEntropy` and `Shannon.Fano`; permanent consumers in `Examples.Fano`. | Exact and weak entropy forms include singleton alphabets; normalized error bounds require `2 <= |alpha|`. Equality/sharpness, randomized estimators, list decoding, and coding theorems remain later work. |

## 7. Current Lean Module and API Architecture

### Root and lightweight finite layer

| Module | Responsibility | Root-visible? |
| --- | --- | --- |
| `LeanInfoTheory.Basic` | Non-stable project metadata and roadmap vocabulary | No |
| `LeanInfoTheory.Probability.Finite` | Reusable PMF real-mass, finite-bind, map, support, and pure-law helpers | Yes |
| `LeanInfoTheory.Probability.TotalVariation` | Half-L1 finite-PMF total variation, core laws, attained events, overlap/residual identities, disjoint support, sharp bounded tests and map/channel contraction, in `PMF` | No |
| `LeanInfoTheory.Probability.Coupling` | Generic coupling interface, support-aware map/channel transport, finite coupling inequality and actual maximal constructor, in `PMF` | No |
| `LeanInfoTheory.Shannon.Entropy` | Entropy, entropy of pushforwards, joint entropy, zero and relabeling facts | Yes, through `InformationMeasures` |
| `LeanInfoTheory.Shannon.InfoMeasures` | Marginals, conditional entropy, MI, CMI, random-variable forms, core rewrites and auxiliary-variable decomposition | Yes, through `InformationMeasures` |
| `LeanInfoTheory.InformationMeasures` | Explicit convenience re-export from `Shannon` into `LeanInfoTheory` | Yes |
| `LeanInfoTheory` | Lightweight public aggregate only | Root |
| `LeanInfoTheory.Shannon` | Import-only complete supported mathematical umbrella | No; subsumes the root |

The current generated C14 inventory contains 60 modules, 129 local import
edges, 5 root-reachable modules, 55 separate-import modules, and 768 indexed
declarations (767 documented plus one example-only instance). The root directly
imports exactly `Probability.Finite` and `InformationMeasures`.

`Probability.TotalVariation` imports only `Probability.Finite` and
`Mathlib.Tactic.Linarith`. The full Shannon umbrella retains this import and
its other released imports and adds the focused coupling owner. `Examples.TotalVariation` imports only the focused owner
and privately checks the core laws, events, Finset coercions and Boolean
pushforwards, followed by generic overlap/residual normalization premises,
equal/disjoint endpoints and sparse three-point overlap. Bounded-test consumers
also check generic signed greatest values, sharp Boolean witnesses and degenerate
interval/radius cases. The separate private `Examples.TotalVariationChannels`
imports the TV and raw `Probability.FiniteChannel` owners to exercise deterministic
and stochastic processing, exact Boolean contraction, channel composition and
joint-law projection. The focused TV consumer additionally connects its shared
Boolean family and exact generic event reduction, with degenerate-alphabet cases.
All 25 public TV declarations are exercised without promoting example helpers.
The non-stable Examples aggregate imports both consumers. Neither adds an import
to the TV owner or either mathematical umbrella. The lightweight root retains
its five-module closure; the frozen release retains 601 declarations in 31 modules.

`Probability.Coupling` directly imports only `Probability.FiniteChannel` and
`Probability.TotalVariation`. Its twelve declarations add no aliases, instances
or simp attributes. The constructor machinery, agreement/complement proofs,
endpoint identities and sparse atom checks remain private. `Examples.Coupling`
imports only that owner and consumes its public constructor, marginals and
exact-event formulas without unfolding it. The separate private
`Examples.CouplingFano` imports `Probability.Coupling`, `Shannon.Fano` and
`Shannon.SemanticBridge.Product`, and joins only the non-stable Examples
aggregate. It consumes both marginal orientations, Fano and measure-product
semantics. The root retains its five-module closure.

The current generated supported closure contains 669 documented public declarations:
596 theorems, 61 definitions, 9 abbreviations and 3 named instances. It excludes
all 27 non-stable development, example and reference modules. C15.01 adds seven
declarations in `Probability.FiniteTopology`: the subtype-topology forwarder,
real-coordinate continuity, real-simplex homeomorphism and its two coordinate
equations, arbitrary-filter convergence iff and finite compactness instance.
C15.02 adds joint TV continuity and the arbitrary-filter TV-to-zero convergence
iff in `Probability.TotalVariationTopology`. C15.03 adds fixed map/bind and
joint-law continuity in the existing `Probability.FiniteTopology` owner, with
finite input only where needed and no output finiteness requirement. C15.04
adds four qualitative finite information-continuity theorems in the focused
`Shannon.Topology` owner. Its private `Examples.ChannelOptimization` consumer
uses compactness and objective continuity to obtain a maximizing input and
proves both boundary information limits. C13.01 adds the
canonical Pinsker theorem; C13.02 adds its support-guarded Real and square-root
forms, and C13.03 adds two mutual-information bounds on TV to the joint law's
own marginal product, all in the same focused semantic owner. C14.01 adds the
exact-TV entropy theorem in the separate `Shannon.Continuity` owner; C14.02
adds its capped scalar definition, monotonicity and entropy-budget theorem, and
C14.03 adds conditional-entropy and MI budget bounds. The current manifest
includes C9's two approved helpers, C10.01's seven declarations and
C10.02's six event theorems, C10.03's five overlap/residual theorems and
C10.04's four bounded-test theorems, C10.05's three processing theorems and
C11.01's coupling predicate and four elementary theorems, C11.02's coupling
inequality, C11.03's constructor and exact-marginal theorem, and C11.04's two
exact-disagreement theorems. C12 adds two coupling-transport theorems, the
whole-extension support iff and one semantic gluing existence theorem.
`Examples.CouplingTransport` imports only Coupling; `Examples.CouplingGluing`
imports Coupling and Gluing. Both stay outside the mathematical umbrellas.
The [growth approval policy](compatibility/current-api-policy.json) records the
TV, Coupling, Gluing, Pinsker, Continuity, FiniteTopology, TotalVariationTopology
and Shannon.Topology owners' direct imports and approved aggregate
additions against the lead's approved plan and step request. Generation does not supply approval.
The historical [contract](v0.1-public-api.md), [frozen manifest](v0.1-public-api.json)
and [structural type artifact](compatibility/README.md) remain unchanged.

### Opt-in finite and semantic layers

| Module | Responsibility |
| --- | --- |
| `LeanInfoTheory.Probability.FiniteTopology` | Existing PMF subtype topology, real-standard-simplex homeomorphism, real-coordinate convergence and finite compactness; no metric instance |
| `LeanInfoTheory.Probability.TotalVariationTopology` | Joint continuity of finite TV and equivalence of PMF and TV-to-zero convergence; imports only the existing TV and finite-topology owners |
| `LeanInfoTheory.Shannon.Topology` | Qualitative continuity of finite entropy, conditional entropy, MI and actual fixed-channel input MI; imports only InfoMeasures and FiniteTopology |
| `LeanInfoTheory.Shannon.EntropyBounds` | Jensen-based alphabet/support bounds and exact uniform equality |
| `LeanInfoTheory.Shannon.Units` | Scalar conversion from canonical nats to arbitrary valid logarithm bases and bits |
| `LeanInfoTheory.Shannon.BinaryEntropy` | Boolean-PMF entropy bridge to mathlib `Real.binEntropy` |
| `LeanInfoTheory.Shannon.Fano` | Type-generic decoding error and finite exact/weak Fano inequalities and corollaries |
| `LeanInfoTheory.Shannon.Continuity` | Exact-TV entropy difference through maximal coupling/Fano; capped scalar modulus, monotonicity on nonnegative budgets and entropy/conditional-entropy/MI bounds from an upper TV estimate |
| `LeanInfoTheory.Shannon.FiniteFamily` | Dependent finite-family laws, finite-atom entropy/MI/CMI algebra, pair/triple compatibility, and binary/ordered entropy, MI, and conditional-MI chain rules |
| `LeanInfoTheory.Probability.FiniteMixture` | Binary PMF mixtures with `NNReal` weights and exact endpoint laws; general selectors use `PMF.bind` |
| `LeanInfoTheory.Shannon.LogSum` | Zero-safe `EReal` finite log-sum inequality/equality and guarded Real corollaries |
| `LeanInfoTheory.Shannon.EntropyConcavity` | General-selector entropy concavity and binary strict equality, proved directly by Jensen |
| `LeanInfoTheory.Probability.FiniteChannel` | Raw PMF channel constructions and elementary laws, with no Shannon/KL dependency |
| `LeanInfoTheory.Shannon.SemanticBridge.Entropy` | Self-information and finite entropy as expected self-information |
| `LeanInfoTheory.Shannon.SemanticBridge.Product` | Independent product PMFs and product-measure bridges |
| `LeanInfoTheory.Shannon.SemanticBridge.FiniteSums` | Finite real-mass and log-ratio expansions |
| `LeanInfoTheory.Shannon.SemanticBridge.Conditional` | Positive conditional PMFs and expected fiber formulas |
| `LeanInfoTheory.Shannon.SemanticBridge.KL` | PMF KL support/equality/uniform-reference results and MI/CMI KL bridges |
| `LeanInfoTheory.Shannon.SemanticBridge.Theorems` | Nonnegativity, chain rules, processing, functional dependence, and inequality consequences |
| `LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` | Finite-family Shannon inequalities |
| `LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL` | Common-base channel conditional KL, finite weighted semantics, joint KL chain rule, and guarded Real forms |
| `LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence` | Dependent-family mutual independence, restriction/pair laws, and n-way entropy equality characterization |
| `LeanInfoTheory.Shannon.SemanticBridge.Independence` | PMF-first ordinary/conditional independence, arbitrary-type deterministic postprocessing, zero MI/CMI, and entropy equality cases |
| `LeanInfoTheory.Shannon.SemanticBridge.Markov` | Markov predicates, total conditional channel, factorization, MI DPI |
| `LeanInfoTheory.Shannon.SemanticBridge.Gluing` | Existence of a Markov triple with prescribed pair marginals; only the final alphabet finite; imports Markov |
| `LeanInfoTheory.Shannon.SemanticBridge.Sufficiency` | Fixed-prior and family sufficiency core, directly importing `Markov` |
| `LeanInfoTheory.Shannon.SemanticBridge.DataProcessing` | PMF-kernel bridge, posterior KL decomposition, KL DPI, entropy growth |
| `LeanInfoTheory.Shannon.SemanticBridge.Pinsker` | Canonical finite-PMF Pinsker in nats, including infinite KL; support-guarded Real and square-root forms; mutual-information bounds on TV to the joint law's marginal product; private analytic and finite-KL machinery |
| `LeanInfoTheory.Shannon.SemanticBridge.Sufficiency.KL` | Downstream exact-recovery and KL equality integration |
| `LeanInfoTheory.Shannon.SemanticBridge.Convexity` | Finite-selector and binary KL joint convexity/equality plus MI input/channel convexity |
| `LeanInfoTheory.Shannon.SemanticBridge` | Import-only semantic aggregate |

**[Decision] Dependency direction.**

```text
InfoMeasures -> Product / FiniteSums / Conditional
Product + FiniteSums + Conditional -> KL -> Theorems -> Independence
FiniteChannel + Independence -> Markov -> Sufficiency
Markov + Sufficiency + focused mathlib KL/kernel
    -> DataProcessing -> Sufficiency.KL
Entropy + mathlib binary entropy -> BinaryEntropy
BinaryEntropy + EntropyBounds + Theorems -> Fano
InfoMeasures + finite dependent-Pi support -> FiniteFamily
FiniteFamily + Theorems -> SemanticBridge.FiniteFamily
DataProcessing + KL -> SemanticBridge.ConditionalKL
SemanticBridge.FiniteFamily + Independence
    -> SemanticBridge.FiniteFamilyIndependence
Probability.Finite -> Probability.FiniteMixture
FiniteMixture + Entropy + finite Jensen -> EntropyConcavity
finite EReal/ENNReal log arithmetic + Jensen -> LogSum
FiniteMixture + EntropyConcavity + LogSum + KL/Product
    -> SemanticBridge.Convexity
```

The exact file graph is generated in
[`home_page/blueprint/module_graph.json`](../home_page/blueprint/module_graph.json).
New work should use the lightest owner whose statement and proof dependencies
justify it.

### Examples and anchors

- `Basic`, every `Examples` module, and `MathlibFragments` are non-stable
  development, regression, or reference anchors. Neither mathematical umbrella
  imports them.
- `Examples.SupportSensitive`, `KLTop`, `CommonCause`,
  `StochasticChannels`, `SufficientStatistics`, `Fano`, `FiniteFamily`, and
  `Convexity`, `ConditionalKL`, and `Units` are separately importable.
  `Examples.Convexity`, `Examples.ConditionalKL`, and `Examples.Units` contain
  only private maintained regression consumers.
  `Examples.IndependenceProcessing` and `Examples.InformationDecomposition`
  likewise contain only private C9 consumers, using their focused owners.
- `Examples` aggregates the maintained mathematical examples.
- `MathlibFragments` is an opt-in import checklist for binary/q-ary entropy,
  KL, KL chain rules, PMF constructions, and Kraft-McMillan. It intentionally
  declares no replacement API.

### Namespaces and public API

- `LeanInfoTheory.Shannon` is the canonical namespace for finite information
  measures and semantic theorems; the module of the same name is the complete
  import-only mathematical umbrella.
- `LeanInfoTheory.InformationMeasures` exports selected names into
  `LeanInfoTheory` for root users.
- PMF-specific reusable constructions and facts extend the `PMF` namespace.
- Certificate declarations and checker-specific demo namespaces are downstream
  concerns and are not part of the LeanInfoTheory API.
- Existing descriptive theorem names are stable. Compatibility aliases are
  additive and review-driven.
- The exact released names, owners, kinds, reviewed attributes, module paths,
  and 92 root exports are frozen in
  [`v0.1-public-api.json`](v0.1-public-api.json).
- Predictable API discovery is a stable design objective. The canonical
  post-release intake and triage process is
  [`downstream-api-feedback.md`](downstream-api-feedback.md); Future Work Note
  14 remains the theorem-development naming watchlist, historical decision
  record, and source of standing alias-review criteria rather than serving as
  a second downstream feedback log.

### Generated documentation and website pipeline

The scripts:

```text
scripts/validate_release.py
scripts/check_api_docs.py
scripts/generate_website_blueprint.py
scripts/generate_website_api_index.py
scripts/generate_v0_1_public_api.py
scripts/generate_current_public_api.py
scripts/compatibility/export_retained_api.py
scripts/check_website.py
```

provide the canonical release gate and produce or validate:

- a module-level graph derived from local import lines;
- a source-derived public declaration index;
- HTML views of those artifacts;
- internal website links and JSON structure.

The isolated `docbuild/` environment additionally pins `doc-gen4` `v4.33.1` at
commit `e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015` without adding documentation
tooling to the downstream runtime graph. Historically, Step 11's checker required 31
supported module pages and 601 declarations with rendered signatures, 92
canonical export targets, 13 non-stable exclusions, and zero equation rows in
the approved `DISABLE_EQUATIONS=1` mode. Disabling equations omits only optional
equation pages; signatures, docstrings, attributes, and sorry markers remain.
The C9.01 retained artifact now records exact-release structural types separately
from the untouched historical manifest. It preserves complete binders and universe
parameters. C9.02 adds the standalone current compatibility checker; its focused
qualification passed all 17 expected fixture outcomes. C9.03 completed current
trust/API-doc integration; C9.04 completed cumulative gate qualification and
independent review/reconciliation and durable closure. Current source contains
both selected C9 helpers; current checks derive complete coverage separately
from the historical 601-declaration baseline. The
public manifest and canonical targets jointly record
the 92 root aliases. Type equality does not establish unchanged bodies or semantics.

The historically validated local file-linked output is unpublished and contains 5,521 files
totalling 624.6 MiB. Its configuration stamp keys generation mode, source
identity, and equation policy; targeted invalidation preserves compiled
dependencies. A first pass after cleaning the documentation build also removed
shared package outputs in the existing working tree and took 17,547.3 seconds
(4h52m27.3s), so it is not clean-checkout or cold-reproduction evidence. The
immediate incremental pass took 154.8 seconds. An earlier fully warm pair took
5.5 seconds per pass. The final post-review gate took 31.8 seconds and 11.9
seconds and reproduced digest
`fa46bbc0de9359ea1e14e79d9e3bce9ac425f33cb2e9efb54086a4e28d6730fe`.
Full generation is therefore outside ordinary push/pull-request CI and runs
only as a conditional `workflow_dispatch` `api_docs` release gate with a
360-minute maximum; exact-candidate remote capacity is recorded by the Step 16
validation report, while routine CI keeps static pin and configuration checks.
Those historical output counts and digests do not validate the C9.06 source.
That source was subsequently qualified in C9.07. C10 source changes need their
own documentation evidence at the C10.07 milestone.

For the completed Chunk 6 checkpoint, the tracked regenerated references
report:

- module graph input: 43 modules, 75 local edges, 11 root-reachable, 32 opt-in;
- reviewed declaration surface: 834 public declarations, all documented.

`C6.23` corrected nested ordinary block-comment handling, removed the false
`Certificate.FiniteFamily.to` candidate, and regenerated both reference sets
twice with byte-identical second passes. All declaration links, anchors,
module summaries, JSON structure, and website links pass their checks.

For the validated Chunk 7 working tree, the regenerated references report 48
modules, 90 local edges, 11 root-reachable modules, 37 opt-in modules, and 862
documented source declarations. The 28-declaration increase is four
finite-mixture, nine log-sum, three entropy-concavity, eleven semantic
convexity, and one lightweight finite-bind declaration. Both generators are
byte-stable on a second pass, and the source-line, anchor, module-summary, JSON,
and website checks pass.

For checkpointed Chunk 8 source, the regenerated references report 51 modules,
100 local edges, 11 root-reachable modules, 40
opt-in modules, and 880 documented source declarations. The delta from the
Chunk 7 checkpoint is exactly three opt-in modules and 18 public declarations.
Both generators are byte-stable on a second pass; source paths and lines,
unique anchors, module summaries, aggregate imports, root reachability, and
website checks pass.

The source-derived declaration index and module graph are not the Step 11
doc-gen output and are not theorem-level dependency data.

## 8. Development History by Phase

### Pre-roadmap foundation

**[History]** The phase from `6623632` through `7855d0d` established both
branches and the repository's working discipline:

| Commit | Durable result |
| --- | --- |
| `6623632` | Project, CI, website, initial expression/certificate skeleton |
| `a356010` | Finite PMF Shannon definitions, marginals, helpers, first semantic layout |
| `6f6cd82` | Strict placeholder policy, empty entropy, `ShannonEntropyVal` |
| `cfd850d` | Primitive inequalities, checked certificates, validator, submodularity |
| `9b92b72` | Relabeling helpers, Jensen entropy bound, expected self-information |
| `e197db2` | Product, conditional-law, finite-sum, KL, and semantic theorem bridge |
| `098892c` | Symmetry, chain rules, conditioning, and more certificate demos |
| `7855d0d` | Three-way certificate pressure test and explicit Project B transition |

The pre-roadmap API remained in place. Later chunks were overwhelmingly
additive and preserved inherited public names.

### Formal Chapter 2 programme

| Chunk | Checkpoint | Purpose | Actual result |
| --- | --- | --- | --- |
| 1 | `7ab3aa0` | Complete finite pair/triple Shannon identities before channels | Zero/equality cases, functional dependence, chain rules, deterministic entropy/MI processing, inequality bands, units |
| 2 | `e5e9825` | Finite KL support semantics and independence | Support/finiteness/top KL, KL zero, uniform reference, sharp entropy equality, ordinary and conditional independence, zero MI/CMI |
| 3 | `a5cc9e9` | Channels, Markov chains, and data processing | Raw PMF channels, total conditional channel, Markov factorization, MI DPI, PMF-kernel bridge, KL DPI, invariant contraction, entropy growth |
| 4 | `f990f2e` | Finite sufficient statistics and equality in data processing | Fixed-prior/family sufficiency, exact recovery, common posteriors, all-prior and Fisher-Neyman results, guarded KL equality |
| 5 | `ec78829` | Finite Fano and estimation error | Boolean entropy bridge, type-generic deterministic error, exact/q-ary/weak Fano, error and uniform-source corollaries, permanent examples, API freeze |
| 6 | `7b5f0db` | Finite families and concrete entropy valuations | Complete and independently validated: dependent finite-atom entropy/MI/CMI, binary and ordered chain rules, Shannon inequalities, concrete valuation, certificate adapter, permanent examples, generated references, and full milestone closeout |
| 7 | `5e616d8` | Finite log-sum and convexity | Complete and independently validated through `C7.22`: zero-safe scalar LS3, finite mixtures, entropy concavity/equality, KL joint convexity/equality, MI input/channel convexity, private maintained examples, generated references, and full milestone closeout |
| 8 | `1eef228` | Finite conditional KL, conditional CMI, and mutual independence | Complete, checkpointed, and remotely validated through `C8.24`: four conditional-family CMI chain rules, common-base conditional KL and joint chain rules, n-way mutual-independence equality, maintained examples, frozen API/imports, generated references, and complete build/boundary/trust/website/hygiene closeout |

Cleanup checkpoints `e72e68c`, `7de8ff5`, and `11e071c` reconciled
post-chunk documentation and prepared the Chunk 5 handoff. Commits `cb8eb6b`
and `2413cb1` consolidated project memory, approved the detailed Chunk 5 plan,
and adopted shared living-summary ownership without changing Lean source.

### Checkpointed Chunk 5 implementation

**[Current]** The approved plan has completed `C5.01` through `C5.20`.
`Shannon.BinaryEntropy`, `Shannon.Fano`, and `Examples.Fano` now exist in the
checkpointed source, with 25 core public declarations and six example
declarations.
`C5.17` froze their names, simp policy, and import boundaries without adding an
alias. C5.19 regenerated and checked the source-derived references and
reconciled the hand-written finite-Fano status prose. C5.20 then passed the
focused and complete milestone builds, guarded boundary consumers, axiom and
placeholder audits, repeated generated-reference checks, website checker, and
final repository hygiene. Commit `ec78829` is the coherent Chunk 5 checkpoint.

### Checkpointed Chunk 6 implementation

**[Current]** The approved 24-step plan has completed `C6.01` through
`C6.24`. `Shannon.FiniteFamily` provides the 68-declaration lightweight
dependent-family core. `Shannon.SemanticBridge.FiniteFamily` adds 30
declarations covering the Shannon inequality band and concrete
`ShannonEntropyVal` constructors. `Certificate.FiniteFamily` adds one checked-
soundness adapter, and `Examples.FiniteFamily` adds 18 explicit declarations
that exercise homogeneous and dependent alphabets plus checked and raw
certificate paths.

`C6.21` froze names, simp policy, helper visibility, and import boundaries.
`C6.22` reconciled canonical project memory, `C6.23` regenerated and checked
the public references, and `C6.24` passed the focused, ten-target, default-
build, consumer, axiom, placeholder, website, and hygiene gates. Commit
`7b5f0db` is the coherent Chunk 6 Lean/source checkpoint.

### Checkpointed Chunk 7 implementation

**[Current]** The approved 22-step plan has completed `C7.01` through
`C7.22`. `Probability.FiniteMixture`, `Shannon.LogSum`,
`Shannon.EntropyConcavity`, `Shannon.SemanticBridge.Convexity`, and
`Examples.Convexity` now exist in checkpointed source. They add 27
public declarations, while the independently pressured
`PMF.bind_toReal_apply` bridge adds the twenty-eighth declaration in the
existing lightweight `Probability.Finite` owner.

Both proof-complete feasibility gates passed. The scalar API handles empty and
singleton finsets, all-zero and `0/0` data, zero-over-positive,
positive-over-zero, mixed finite/`top`, and common-ratio equality at zero,
finite values, and `top`. The binary KL equality API uses interior weights,
component support inclusion, and a division-free pointwise cross-product
condition. Forty-six private maintained examples exercise these contracts,
mixture endpoints and proof irrelevance, inactive infinite KL, and the four MI
input/channel theorem forms.

`C7.19` retained the public names and module boundaries, added only the
evidence-supported finite-bind bridge, marked only the exact binary mixture
endpoint laws `[simp]`, and kept representation-changing pointwise and chain
rules explicit. The focused nine-target build passed with 2,780 jobs, direct
and root-isolation consumers passed, representative axioms were limited to
`propext`, `Classical.choice`, and `Quot.sound`, and placeholder/scratch/
whitespace/diff checks were clean. `C7.21` subsequently regenerated and checked
the public references, and `C7.22` independently passed the direct and complete
milestone builds, boundary and trust audits, website checks, and repository
hygiene. Commit `5e616d8` is the coherent Chunk 7 Lean/source checkpoint.

## 9. Stable Design Decisions and Rationale

| Decision | Rationale to preserve |
| --- | --- |
| Use mathlib `PMF` | Enforces probability laws, integrates with measures/kernels, and avoids a mathematically inadequate rational toy model |
| PMF-first finite API | Makes finite sums, examples, pushforwards, and textbook statements tractable while retaining measure semantics downstream |
| Entropy in `Real`, nats first | Matches `Real.negMulLog`, `Real.log`, and mathlib binary/q-ary entropy; base conversion needs no duplicate hierarchy |
| Type-generic decoding-error definitions | Equality is chosen internally; finiteness belongs only on finite sums and entropy theorems that need enumeration |
| Singleton-inclusive exact Fano | The exact and weak entropy bounds need no artificial `2 <= |alpha|`; that hypothesis appears only when division by `log |alpha|` requires positivity |
| Pushforward definition of random-variable quantities | Keeps laws distributional and makes relabeling/marginals compositional |
| Dependent finite-family law with `Finset` atoms | Supports heterogeneous alphabets and an infinite variable-name type while taking entropy only after finite restriction |
| Finite mixtures through `PMF.bind`, binary weights through `NNReal` | Reuses mathlib probability structure, keeps general selectors reusable, and matches `PMF.bernoulli` without a parallel simplex type |
| Zero-safe scalar log-sum in `EReal` | Represents positive-over-zero by `top`, keeps `0/0` inactive, and supports an exact equality statement without silently strengthening support assumptions |
| Separate direct-Jensen entropy concavity | Avoids an unnecessary dependency from the entropy layer to scalar log-sum while preserving the textbook finite proof |
| Ordered chains over `List Var` | Gives textbook prefix sums, permits repeated names in the stronger theorem, and reserves `Nodup` for presentation corollaries |
| Algebraic core, semantic bridge | Keeps the lightweight identities convenient without losing textbook expected-fiber and KL meanings |
| Lightweight root | Prevents Jensen, KL, kernels, examples, and coding imports from burdening ordinary finite-entropy users |
| Raw channel functions, not a bundled channel | Reuses `PMF.bind` and keeps the elementary construction layer type-generic and cheap |
| Cross-product conditional independence | Gives a proof-independent, null-fiber-safe primary predicate |
| Total conditional channel with documented fallback | Avoids extra nonempty assumptions while ensuring null fibers have no semantic force |
| `ENNReal` as primary unconditional KL codomain | Preserves infinite divergence and avoids the `toReal top = 0` trap |
| Kernel-chain-rule proof of KL DPI | Reuses mathlib's analytic engine and supports later equality/posterior reasoning |
| Fixed-prior and family sufficiency are distinct | Separates a chosen joint law from prior-free recovery for an entire model family |
| Exact full-joint family recovery | Preserves input-output coupling; marginal recovery alone is too weak |
| One shared recovery witness | `exists R, forall t` is the mathematical family-sufficiency contract |
| Sufficiency core before posterior/KL integration | Keeps the fixed-prior and recovery API independent of `DataProcessing` and `Sufficiency.KL`; generic `SemanticBridge.KL` remains transitively reachable through `Markov` |
| Proof-pressure API growth | Avoids speculative aliases, helper families, bundled structures, and symmetric theorem clutter |
| Compatibility aliases instead of active renames | Preserves downstream code while improving discovery only when examples justify it |
| Explicit entropy rewrites | Avoids choosing one arbitrary expanded/unexpanded entropy normal form through `[simp]` |
| Downstream certificate ownership | Keeps checker DSLs, validation, import, and application demonstrations out of the reusable mathematical library |

## 10. Rejected and Superseded Approaches

These should not be retried without new evidence or an explicit architecture
review.

- **Rejected:** `Probability := Rat` or bare rational-valued distributions.
  Entropy is generally real and probability normalization must be structural.
- **Rejected:** a measure-first public core for all finite use. Measures and
  kernels remain essential semantic bridges, not replacements for PMF-facing
  textbook APIs.
- **Rejected:** local redefinitions of binary entropy, q-ary entropy, KL,
  product measures, kernels, or Kraft-McMillan.
- **Rejected:** base-indexed copies of entropy, conditional entropy, MI, and
  CMI. Use `Shannon.Units`.
- **Rejected:** expected conditional formulas as the primary definitions.
  Algebraic entropy identities remain definitional; semantic equivalences are
  theorems.
- **Rejected:** assigning a canonical conditional distribution meaning to a
  null fiber. Total fallbacks are technical only.
- **Rejected for Chunk 3:** a project-local direct log-sum proof of KL DPI.
  The mathlib kernel chain rule was selected.
- **Rejected:** a second bundled channel representation or a public
  statistical-experiment object before repeated consumers require one.
- **Rejected:** marginal-only recovery as the definition or characterization
  of sufficiency.
- **Rejected:** inferring one family-wide recovery channel from unrelated
  pairwise KL-equality witnesses.
- **Rejected:** broad `[simp]` use for chain rules, symmetry, or entropy
  difference identities.
- **Assigned downstream:** primitive recognition, certificate DSLs, validation,
  and external certificate import.
- **Deferred rather than rejected:** splitting `InfoMeasures` or
  `Independence`, adding a product-channel constructor, general injective MI
  relabeling, generic posterior wrappers, and matrix channels.
- **[Superseded]** The original eight-chunk map bundled log-sum/DPI,
  sufficiency, doubly stochastic channels, and Fano differently. Actual chunk
  ownership in Section 8 is authoritative.

## 11. Known Limitations and Open Questions

### Mathematical gaps

- Equality conditions and sharpness for finite Fano, randomized-estimator and
  list-decoding variants, and coding-theorem applications of the completed
  deterministic-decoder inequality.
- Global indexed-family or measurable mutual-independence bridges, and
  broader pairwise-versus-mutual-independence theory beyond the maintained
  finite counterexample.
- General-selector equality classifications for log-sum-derived entropy/KL
  results, MI input/channel equality cases, and finite-family wrappers for the
  completed PMF-first convexity API remain intentionally deferred.
- Continuity and optimization beyond C15.04's selected finite information
  objectives and actual fixed-channel attainment consumer. Global KL likely needs a
  lower-semicontinuity or support-stratified treatment rather than an
  unqualified continuity theorem.
- Tensorization/single-letterization beyond current pair/triple results.
- Matrix-facing doubly stochastic/majorization/Birkhoff theory.
- Canonical and minimal sufficient statistics.
- General measurable sufficiency and larger iid/count-statistic examples.
- A direct bridge from the local finite conditional PMF to mathlib
  `ProbabilityTheory.condDistrib`.

### API gaps and unsettled contracts

- **[Decision]** The approved Chunk 6 finite-family representation uses an
  arbitrary decidable variable-name type `Var`, dependent pointwise-finite
  alphabets `alpha : Var -> Type`, a full joint `PMF` on
  `forall i, alpha i`, and finite atoms `Finset Var`. It does not assume
  `[Fintype Var]` and applies entropy only to finite marginals. The production
  core and semantic declarations are implemented and API-frozen through
  `C6.21`.
- Whether `Shannon.InfoMeasures` should eventually split; it is currently
  large but coherent.
- Whether injective MI relabeling should be global or support-aware.
- Whether a general real-KL zero iff under an explicit `klDiv != top`
  hypothesis has enough consumers.
- Whether uniform-reference KL should support an infinite ambient type with a
  finite reference support.
- Whether posterior APIs need `[Finite]` wrappers or a public weighted
  fiber-KL expansion.
- Whether a generic common bind-recovery KL retraction theorem has an
  independent consumer.
- Whether a matrix compatibility bridge belongs in a new opt-in module.

### Lean and mathlib difficulties

- `ENNReal.toReal top = 0` makes unguarded real KL equality statements false or
  uninformative.
- Measure-theoretic theorems require careful local measurable-space,
  measurable-singleton, and kernel instances.
- Pointwise `PMF.map` and marginal formulas often require nontrivial support or
  finite-sum infrastructure.
- Support transport through `map`, `bind`, and channel composition is a
  recurring proof burden.
- Positive and null conditional fibers require separate reasoning.
- Kernel `compProd` rewrites and posterior equalities are sensitive to
  coordinate orientation and explicit intermediate equalities.
- On Windows, fresh Lean/Lake startup can be slow. This is an environment
  issue, not accepted proof debt.

### Assumptions possibly stronger than mathematically necessary

- `channelPosterior` exposes `[Fintype alpha]`.
- The finite Fisher-Neyman theorem assumes `[Finite alpha] [Nonempty alpha]`
  and finite `ENNReal` factor values. The normalization primarily consumes
  finiteness of the parameter-independent factor, but the public contract
  retains both factor-finiteness conditions.
- All-prior converses use a finite nonempty parameter alphabet to construct a
  full-support prior.
- Real KL equality and contraction theorems use support inclusion to exclude
  `top`.
- Fano's exact and weak entropy forms require finite source and observation
  value alphabets but no cardinality lower bound. Error bounds that divide by
  `log |alpha|` require `2 <= Fintype.card alpha`; uniform-source statements
  use the existing `PMF.uniformOfFintype` contract and therefore expose
  `[Nonempty alpha]`.

These are intentional current contracts, not claims of maximal generality.

### Documentation gaps

- Theorem-level dependency data, a blueprint PDF, and optional equation-expanded
  documentation remain absent. Clean exact-commit source-link and remote
  capacity evidence belongs to the external candidate-validation record, not
  content baked into the candidate.
- A minimal contributor guide and beginner issue surface remain absent.

### Automation gaps

C9's structural retained-type checks preserve binders, assumptions and imports;
equal types do not establish unchanged definition bodies or mathematical meaning.
Current documentation fingerprints detect changed inputs, not semantic equivalence.
The [C9 handoff](handoffs/chunk-9.md) separates these permanent limits from required
final cumulative validation and the separately authorized publication route.

- No theorem-level blueprint pipeline. Full doc-gen is a manual release gate;
  remote capacity and exact-commit GitHub-source reproduction are external
  candidate-validation evidence.

Certificate search, coefficient solving, primitive autotagging, and external
certificate parsers are downstream application work, not LeanInfoTheory gaps.

## 12. Active Work

### C15.05 cumulative qualification and handoff, 2026-10-13

Step 4's original review, all four satisfied criteria, successful closure and
complete final source were verified before conditional intake. C15.05 adds no
mathematics. The [maintained handoff](handoffs/chunk-15.md) reconciles all 16
public additions, focused consumers, source adaptations, empty/singleton/null
fiber decisions, naming/private-helper dispositions and future owners/triggers.

The lead authorized the exact prepared 20-file local checkpoint, necessary
C15.05-only amendments within those paths and reuse of the relocated clean
validation checkout. The initial checkpoint passed the full clean routine;
current two-pass API-doc qualification and rendered inspection passed separately.
Unrelated hygiene/website work and the historical relocation log entry remain
excluded and preserved. Every amendment needs renewed full routine validation
and exact API-doc/source applicability. Completed edits, retained self-review
and separate reassessment establish review readiness; the fresh all-17-criterion
report, reconciliation and supported closure remain separate later obligations.

Package C13--C15 added 27 supported declarations, including two instances and
two coordinate equations in C15, below the map's rough 40--100 substantive
estimate. Existing mathlib reuse and a small useful API account for the scope
delivered. The handoff reports this calibration without a count quota, new
mathematics or a change to later endpoints; reassess after C18. The total is
669 versus the release's 601. C16 remains separately selectable.

### Historical C15.04 information continuity and actual MI attainment, 2026-10-13

C15.03 closed with all three criteria satisfied and no findings; its entire
final inventory matched before conditional intake. Only C15.04 is selected.
The four public `Shannon.Topology` theorems use continuous `negMulLog`, finite
sums, the existing marginal formulas and delivered channel-joint continuity.
They retain independently universe-polymorphic finite alphabets, zero masses
and the established `H(X | Y)` orientation. The owner imports only
`Shannon.InfoMeasures` and `Probability.FiniteTopology`.

The private `Examples.ChannelOptimization` consumer applies the existing
compact-extremum theorem to the actual channel MI objective on all input PMFs.
It supplies compactness, continuity and an explicit pure-law witness from
nonempty input; no independent output nonemptiness premise is added. The same
private Boolean family and pure/fair channel give explicit MI and conditional-
entropy limits to zero, with a positive-to-null conditioning marginal.
Singleton input/output objectives are zero. Empty input has channel functions
but no optimizer, whereas nonempty input and empty output admit no channel.

Generated coverage is 669 documented declarations in 39 owners, 94 reviewed
simp declarations, 92 root exports and 27 non-stable modules. The graph has
66 modules/143 local edges with five root-reachable modules; the source index
has 784 declarations, 783 documented and one example-only instance. All eight
focused targets, both separate instance probes, static, documentation and full
trust passed; the axiom audit covers 2,198 local constants. Self-review and
separate reassessment found no actionable recommendation. The same bound
independent reviewer assessed all four criteria satisfied with no findings.
Final source applicability and fresh document/static checks precede supported
private closure. The clean suite and current API-doc milestone remain C15.05,
which is unselected.

### Historical C15.03 continuous probability maps, 2026-10-13

C15.02 closed with all three criteria satisfied and no findings. Its complete
final inventory matched at conditional intake. Only C15.03 is selected.
The existing finite-topology owner adds `continuous_bind`, `continuous_map`
and `continuous_channelJoint`. The first two require only `Finite` input and
arbitrary output; the last needs no alphabet finiteness. No imports, instances,
aliases or simp attributes are added.

Private permanent consumers directly check independent universes, `Finite`-only
inputs, `Bool → Nat`, `Bool → PMF Nat` and `Nat → PMF Bool`. Compactness of the
actual bind image follows from delivered compactness and existing image APIs.
A nonconstant noninjective `Fin 3 → Bool` map sends the existing sparse law to
a fair Boolean law. The interval Boolean family passes through the prescribed
distinct-row stochastic channel: joint masses are `1 - t`, `0`, `t/2`, `t/2`,
and the output's true mass is `t/2`. Consumers check both projections, input,
output and joint limits, the unused input row at zero, and the positive-to-null
output mass. The family is private and the focused consumer imports no TV or
Shannon owner.

Generated coverage is 665 documented declarations in 38 owners, 94 reviewed
simp declarations, 92 root exports and 26 non-stable modules. The graph remains
64 modules/138 local edges with five root-reachable modules; the source index
has 780 declarations, 779 documented and one example-only instance. All six
focused targets, both fresh-import instance probes, static and full trust passed;
the axiom audit covers 2,155 local constants. Self-review/reassessment found no
actionable recommendation. The same bound independent reviewer assessed all
three criteria satisfied with no findings. Final prose records the actual
evidence and limits; source applicability and fresh final checks precede the
supported private closure. Later steps remain unselected.

### Historical C15.02 total-variation topology and convergence, 2026-10-13

C15.01 completed with all four criteria satisfied and no findings. Its exact
final source matched at the conditional C15.02 intake. Only C15.02 is selected.
The separate probability bridge supplies the two approved TV continuity/convergence
theorems, reusing the singleton-event bound in the converse. Generic permanent
consumers compose both public equivalences in both directions. The Boolean
family uses `t : Set.Icc (0 : ℝ) 1`, has masses `1 - t` and `t`, exact TV `t`
to its pure endpoint, and converges through the public interfaces. Singleton TV
and impossible empty limits are covered without positivity or `NeBot` premises.

Current generated coverage is 662 documented declarations in 38 supported owners,
94 reviewed simp declarations and 26 non-stable modules. The module graph has
64 modules and 138 local edges; five are root-reachable. The source index has
777 declarations, 776 documented and one example-only instance. These inventory
counts are distinct from compiled qualification. The five-target focused build,
static gate and complete trust audit passed on unchanged source. The original
independent report marks all three criteria satisfied with no findings; the parent
preserved and reconciled it. Final-source applicability and post-documentation
checks must precede supported closure, whose expected record is
`.lit-review/setup/c15-02-completion-20261013.json`. Later steps and
clean-checkpoint/API-doc milestones remain subject to separate selection.

### Historical C15.01 simplex topology and compactness, 2026-10-13

Only C15.01 of the accepted [revision-2 plan](plans/post-release-chunk-15.md)
is selected. The focused `Probability.FiniteTopology` owner adds the seven
planned declarations; `Examples.FiniteTopology` checks sparse coordinates,
both round trips, pure vertices, empty-law impossibility, finite/singleton
compactness, and reconstruction of law convergence from simplex coordinates.
The full Shannon umbrella exposes the owner; the root keeps its two direct
imports, five-module closure and 92 exports. Both new instances forward or
transport existing topology facts; no uniform/metric instance or simp rule is added.

Current generated coverage is 660 documented declarations in 37 supported
owners, 94 reviewed simp declarations and 25 non-stable modules. The module
graph has 62 modules and 133 local edges; five are root-reachable. The source
index has 775 declarations, 774 documented and one example-only instance.
These generated counts describe source inventory; separate compiled qualification
is recorded in Section 16. The original independent STEP report marks all four
criteria satisfied with no findings. The [notes](plans/post-release-chunk-15-notes.md)
retain proof decisions, actual validation, review and reconciliation evidence.
Final-source checks and supported private closure remain the completion authority;
the expected record is `.lit-review/setup/c15-01-completion-20261013.json`.
Later C15 steps, clean checkpoint, publication and C16 require separate
selection/authority.

### Historical C14.04 cumulative qualification and maintained handoff, 2026-10-08

C14 subsequently completed at `e982ba7c` by its actual private completion record.
The following paragraphs retain their original pre-closure chronology.

The [approved C14 plan](plans/post-release-chunk-14.md) separates exact entropy,
capped budgets, derived joint-law bounds and cumulative qualification.
C14.01--C14.03 and their reviews are complete by private records, most recently
`.lit-review/setup/c14-03-completion-20261007.json`. All 219 Step 3 final-source
entries matched before the conditional Step 4 request was accepted. The six
planned public declarations and all permanent private consumers are present.
The [C14 handoff](handoffs/chunk-14.md) preserves exact contracts, import choices,
evidence limits and remaining-work owners; the [notes](plans/post-release-chunk-14-notes.md)
retain the proof decisions and actual validation attempts.

C14.04 has an explicitly authorized 23-file local checkpoint, necessary
C14.04-only amendment authority and clean-checkout reuse. Initial checkpoint
`ca079e2` passed the complete routine suite; the current two-pass API-doc gate
and all-six-declaration inspection also passed. Any amended candidate requires
renewed complete routine validation and exact API-doc applicability. Fresh
cumulative review of all 12 criteria, reconciliation, final-source applicability
and private closure must be established by the source-bound records; this
pre-closure entry does not itself certify completion.
C15--C24 remain unselected. Preserve unrelated website notes, dependency pins,
the lightweight root and Notes 14/29's existing proof-pressure triggers.
Push and publication require separate authority.

Current coverage is 653 documented public declarations in 36 supported owners,
with 94 reviewed simp declarations, 92 root exports and 24 non-stable modules.
The graph has 60 modules, 129 local edges, five root-reachable and 55 separate-import
modules; the index has 768 declarations, 767 documented and one example-only instance.
The C14 parent retains its own persistent reviewer; the historical revision-1
PLAN admission limitation remains distinct from approved revision-2 execution.
The predecessor sections below retain historical qualification chronology.

### Historical C13.04 qualification and maintained handoff

C12 is complete through C12.04 at `492cd6e60c5d6b42a22ef2dcbb45d21067b6d378`,
by its actual private completion record. The [C12 handoff](handoffs/chunk-12.md)
preserves contracts and evidence; its captured provisional wording is historical.
The approved [C13 revision-2 plan](plans/post-release-chunk-13.md) is complete
through C13.04 at `ebe48eaea4282b1e4f245f8f45440bc930b8df73`, by
`.lit-review/setup/c13-04-completion-20261003.json`. The following checkpoint
figures and validation chronology are historical; the [C13 handoff](handoffs/chunk-13.md)
retains their source identities and limits.

C13 delivers five public theorems in `Shannon.SemanticBridge.Pinsker`: canonical
`ENNReal` Pinsker, support-guarded Real and square-root forms, and two bounds on
TV between a joint law and the product of its own marginals. All use nats and
half-L1 TV. The independence forms require only finite alphabets; actual finite
KL is established privately before the MI bridge. Permanent private consumers
cover binary endpoints, a positive three-point tied event, sparse finite KL,
singular counterexamples, MI/event/test budgets, arbitrary-source random variables
and a sparse joint with a null marginal row. Signed tests retain the factor two.

At the C13 checkpoint, coverage was 647 documented declarations in 35 supported owners,
with 94 reviewed simp declarations and 92 root exports. Its generated references contained
58 modules, 124 local edges, five root-reachable and 53 separate-import modules,
and 762 indexed declarations (761 documented and one example-only instance).
The [C13 handoff](handoffs/chunk-13.md) records exact contracts, useful imports,
source adaptations, earlier reviews and remaining-work owners and triggers.

The lead explicitly authorized the 25-file local checkpoint, a separate clean
validation checkout and necessary C13.04-only amendments. Initial checkpoint
`17fb736a00448ecdd0aa824fd1928713bf716f01` passed the complete routine suite in
1975.056 seconds. The two actual API-doc passes and all-five-declaration
inspection also passed. The [C13 handoff](handoffs/chunk-13.md) records evidence
and the primary/clean source-identity distinction.
The source-bound C13.04 records subsequently established final validation,
review, reconciliation and closure at `ebe48eaea4282b1e4f245f8f45440bc930b8df73`;
the initial-checkpoint evidence above is retained as history.
The unrelated website notes remain excluded. C14.04 now owns cumulative
qualification of the continuity family; C15--C24 remain unselected, and
publication is separate.


### C12.04 cumulative qualification history

The following is retained preparation history. C12 subsequently completed at
`492cd6e` by its actual private completion record; pending wording below does
not reopen C12 or override the current C14.04 selection.


C9, C10 and C11 are complete by their actual private records, most recently
C11.06 at `bbead98abfd2ac94f95b615652365a65228e49c5`. Their maintained handoffs
preserve the completed source and review history. C12.01--C12.03 and their
reviews are also complete. The lead's conditional request selected C12.04 after
verification of C12.03's closure and exact final source.

The approved [C12 revision-2 plan](plans/post-release-chunk-12.md) adds four
public theorems: `PMF.IsCoupling.map`, `PMF.IsCoupling.bind`,
`PMF.channelExtension_eq_iff_eq_on_support`, and
`Shannon.exists_isMarkovChain_with_marginals`. Transport is type-generic and
requires channel-row marginals only on the supplied joint law's support.
The extension theorem characterizes equality of whole triple laws by agreement
on the middle support. Gluing retains both prescribed pair laws and Markov
structure, with only the final alphabet finite; witness selection stays private.

The two private consumer owners cover heterogeneous and degenerate alphabets,
genuinely incorrect unsupported channel rows, different positive conditional
rows, arbitrary null-row changes and endpoint marginals of the same public
gluing witness. Quantitative consumers compute the weighted disagreement of
lifted maximal couplings and recover C10 contraction with guarded ENNReal-to-Real
conversion. The fair/point-mass/fair regression proves both adjacent couplings
maximal but their Markov gluing has endpoint disagreement `1/2`, strictly above
endpoint TV and diagonal disagreement, both zero.

The C12 candidate covered 642 documented declarations in 34 supported owners, with
94 reviewed simp declarations and 92 root exports. Generated references record
55 modules, 117 local edges, 5 root-reachable and 50 separate-import modules,
and 757 indexed declarations (756 documented and one example-only instance).
The [C12 handoff](handoffs/chunk-12.md) records exact contracts, imports,
source adaptations, earlier original reviews and remaining-work triggers.

The lead explicitly authorized the exact 35-file local checkpoint, a separate
clean validation checkout and necessary C12.04-only corrections and final-record
amendments. Initial checkpoint `44d300c97d86b1fc0f40e9c70eb33a16bbfe3abe`
passed the complete routine suite in the separate clean checkout. Corrected
focused/static checks and both actual current file-mode API-doc passes with
inspection of all four new declarations also passed. The original checkout
preserves the unrelated website notes outside the checkpoint. The source-bound
C12.04 records must establish final amended-candidate validation, exact API-doc
applicability, fresh all-13-criterion review, reconciliation and closure. This
chronology does not certify those later outcomes. No push, publication, pin change
or C13--C24 work is authorized.
The unrelated website notes remain outside the candidate.

### Completed C11.06 validation and handoff history

C9 is complete through C9.07 by its actual private completion record at source
checkpoint `8ee0337b20c320c384d5637de852da7f4ee09728`. The
[maintained C9 handoff](handoffs/chunk-9.md) preserves delivered APIs, evidence
and remaining-work dispositions; its captured pre-closure wording does not reopen
that completed chunk.

C10 is complete through C10.07 at source checkpoint
`37b4ba90d1ab321645f80cacef475f10a3a6ba43`, by its actual private completion
record. The [C10 handoff](handoffs/chunk-10.md) preserves its delivered 25-declaration
TV API and evidence; its provisional chronology does not reopen the completed chunk.

The approved [C11 plan, revision 2](plans/post-release-chunk-11.md) is complete
through C11.06 by its private closure at `bbead98`. The following paragraphs
retain its checkpoint and validation history.
C11.01--C11.05 and their reviews are complete by their private records, most
recently `.lit-review/setup/c11-05-completion-20260926.json`. The completed
predecessor and its exact source were verified before selecting C11.06 with review.
The cumulative candidate retains the ten public coupling declarations and both
private consumer owners, including the actual maximal witness and its swap in
Fano with exact TV error and independent-product measure interoperability.
The C11 cumulative candidate recorded 638 documented declarations in
33 owners, with 94 reviewed simp declarations and 92 facade aliases. Its baseline inventory
recorded 52 modules, 110 local edges, 5 root-reachable and 47 separate-import
modules, with 753 indexed declarations (752 documented and one example-only instance).
The lead explicitly authorized the exact local checkpoint and necessary
C11.06-only amendments. Initial checkpoint
`2147dd3449af620f41d9bed8d37c5be8252f20e8` passed the clean complete routine
suite and real two-pass current file-mode API-doc gate; the
[maintained C11 handoff](handoffs/chunk-11.md) identifies original results and the
actual Coupling-page inspection. Any amended candidate requires renewed complete
routine validation and exact API-doc applicability. C11.06's source-bound private
records establish the fresh all-17-criterion review, original-report
reconciliation, final validation and review applicability, final capture and
closure. This maintained chronology does not itself certify completion.
C12 is complete through C12.04 at `492cd6e60c5d6b42a22ef2dcbb45d21067b6d378`,
by `.lit-review/setup/c12-04-completion-20261003.json`. Its captured provisional
wording is historical; the [C12 handoff](handoffs/chunk-12.md) preserves
contracts, validation and remaining-work owners. The lead accepted the
[C13 revision-2 plan](plans/post-release-chunk-13.md). C13.01--C13.03 and their
reviews are complete, most recently by
`.lit-review/setup/c13-03-completion-20261003.json`. C13.03's exact final source
was verified before the lead's conditional C13.04 request was accepted.
C13.04 selected cumulative qualification and the [C13 handoff](handoffs/chunk-13.md).
The lead authorized the 25-file checkpoint, separate clean validation checkout
and C13.04-only amendments. Initial checkpoint
`17fb736a00448ecdd0aa824fd1928713bf716f01` passed the full routine suite in
1975.056 seconds. The [C13 notes](plans/post-release-chunk-13-notes.md)
retain the initial-checkpoint evidence and limits; subsequent validation,
review and closure are established by C13.04's source-bound completion record.
C13 subsequently completed at `ebe48eae`; C14.01--C14.03 are complete and
C14.04 is selected. C15--C24 remain unselected.

### Public visibility pass

**[Current, 2026-09-14]** The lead authorized stronger library positioning,
README/website improvements, practical guides, and discovery metadata. GitHub's
description and eight topics are updated. Published work adds five guides, four
Lean examples maintained by the documentation gate, and a nine-page sitemap
with canonical and social metadata. See the [visibility record](website-visibility.md)
for the dated baseline, validation scope, account actions, and announcement draft.
The source checkpoint `7537af70ab644655b678fd428ad038aa6bf83506` passed the
complete local suite and [remote CI](https://github.com/serhatemrecoban/LeanInfoTheory/actions/runs/34863514713).
The approved [Pages deployment](https://github.com/serhatemrecoban/LeanInfoTheory/actions/runs/34863515519)
succeeded, and all nine curated pages and the sitemap were checked live.
The published metadata pins the API to the original `v0.1.0` release commit.
Search Console verification and community outreach remain follow-ups; no ranking or
assistant-recommendation improvement has been measured. This does not select
a mathematical chunk or change the frozen release API.

### Post-release programme planning

**[Proposed, 2026-09-11]** The project lead authorized a long-term map and
reference registration for complementary library work plus five packages:
TV/coupling, quantitative inequalities/continuity, products/block information,
finite-iid fixed-length source coding, and finite-channel capacity/converses.
The [revision 2 map](plans/post-release-chunk-map.md) proposes 16 chunks,
C9--C24, with dependency-aware endpoints and an independent qualification
chunk. It does not approve production statements, new module names, or a
release version. Source coding is to reach a complete operational theorem;
channel achievability remains outside the proposed scope.

Revision 2 reconciles the independent and self-reviews while retaining the
chunk IDs. It clarifies three distinct compatibility obligations, constructor/
semantic import direction, the finite-block AEP and coding contracts, and true
dependencies. Section 6 of the map owns uncertain release-size calibration;
roughly 1,200 supported declarations is a cross-check on the doubling ambition,
not a quota. Section 8 records review dispositions. None of these estimates or
proposed endpoints changes the current mathematical inventory.

The second-review follow-up clarifies C23's arbitrary above-capacity premise
without assuming bounded rates and records C18's exact MI gap/output-independence
criterion as a preferred optional refinement. The 16-chunk structure and
required endpoints are unchanged; these are planning decisions, not new results.

The project lead separately authorized adapting/installing the working PFR-C02
review mechanism on 2026-09-11. `tools/lit_review/` and the
[protocol](review-protocol.md)/[operations](review-operations.md) own that opt-in
workflow; ignored `.lit-review/` stores its private records. The inherited core
is retained, with library-specific source, identity, rubric and validator bindings.
The installation alone granted no mathematical authority. The lead subsequently
approved detailed C9 revision 2 and selected its steps individually; C9 is now
closed through C9.07 with its persistent reviewer and maintained handoff.
C10 is complete at `37b4ba90d1ab321645f80cacef475f10a3a6ba43`, with evidence
in its private completion record and [handoff](handoffs/chunk-10.md). The lead
approved C11 revision 2; C11.01--C11.05 are complete with review. The next
request selected C11.06 after its predecessor closure and source were verified.
The actual C11 task completed its cumulative review and reconciliation through
its own persistent reviewer and private records. C12 completed through its
own reviewer and private records. C13 completed at `ebe48eae` through its own
bound reviewer. C14.01--C14.03 and their reviews are complete; C14.04 is selected
with its own persistent reviewer. Its authorized initial checkpoint passed the
full routine; final-candidate qualification, cumulative review and closure remain
subject to its source-bound private records.
C15--C24 remain unselected. Local review closure establishes
no publication or downstream adoption.
Exact reference versions and selected sections are recorded in
[`references.md`](references.md); detailed chunk assignments are not duplicated
in this summary.

### `v0.1.0` release and maintenance status

**This revision contains the post-release DOI metadata and durable website
composition boundary for the published `v0.1.0` library.** The immutable release
source remains exact commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`;
the historical DOI/website update changed no Lean source or frozen public surface.
Current C14.04 qualification is described separately above.
Step 14 fixed every legal/provenance
and Zenodo-route decision, and the final `date-released` value is
`2026-09-01`. The fulfilled release contract freezes Lean and mathlib at
`v4.33.1`, keeps nats canonical with opt-in base conversion, assigns certificate
representations and checking to downstream projects, and preserves the
completed legal-attribution and independent-review checkpoints.

Step 6 preserves the Step 5 public import architecture. `LeanInfoTheory` directly imports
only `Probability.Finite` and `InformationMeasures`; the import-only
`LeanInfoTheory.Shannon` umbrella subsumes that root and reaches the complete
31-module supported mathematical stack. `SemanticBridge.Entropy` now owns the
five expected-self-information declarations formerly placed in the aggregate,
with their names, statements, attributes, and proofs unchanged. Both umbrellas
exclude the 13 explicitly non-stable `Basic`, example, and `MathlibFragments`
anchors. `Shannon.Units` retains its lightweight four-module closure and adds
only `natsToBase` and `natsToBits`; `Examples.Units` compiles arbitrary-base,
entropy, MI, CMI, and absolute-continuity-guarded real-KL conversions. The
generated inventory is 44 modules, 90 local edges, 5 root-reachable modules, 39
separate-import modules, and 716 declarations.

Step 7 retains every current public declaration, assumption, name, namespace,
attribute, owner, and import boundary. It freezes the 31-module supported
closure at 601 documented project declarations, split between 557
`LeanInfoTheory.Shannon` declarations and 44 `PMF` extensions, together with 92
explicit lightweight-root exports and 94 reviewed `simp` declarations. The
audit promoted no example declaration and added no speculative compatibility
alias. The human contract and deterministic manifest are
[`docs/v0.1-public-api.md`](v0.1-public-api.md) and
[`docs/v0.1-public-api.json`](v0.1-public-api.json).

Step 4 removed the former entropy-expression/checker modules, finite-family
adapter, checker-only examples, and certificate-facing semantic constructors
from LeanInfoTheory ownership while retaining all general finite-family and
information-theory theorems. `ShannonCert` was not accessed or modified. The
post-separation generators reported 41 modules, 77 local edges, 6 root-reachable
modules, 35 opt-in modules, and 714 declarations; the focused, maintained, and
default builds plus the generator, website, source-removal, boundary, trust,
and hygiene checks pass.

The supplemental checkpoint applied the project lead's exact EPFL/MIL source-
notice decision to all 51 then-tracked project-authored Lean files, restored the root `LICENSE` to
canonical Apache-2.0 text, adds explicit Lake licence metadata and a validated
`CITATION.cff`, and adds the README's long-form AI-assistance disclosure. It
found no vendored Lean source or concrete `NOTICE` requirement. The exact
institutional header intentionally differs from mathlib's style-linter template,
so only that stylistic linter is conditionally disabled; a repository-specific
exact-header scan covers every tracked Lean file instead. The complete audit
inventory is in
[`docs/v0.1-legal-metadata-audit.md`](v0.1-legal-metadata-audit.md).

Step 14 later clarified that École polytechnique fédérale de Lausanne (EPFL)
alone is the rights holder and that the Mathematics of Information Laboratory
is the author affiliation/project laboratory. The exact source header remains
approved and unchanged; its MIL organizational line does not create a second
rights holder.

Step 9 reconciled that dated checkpoint with the then-current 44-file certificate-
free tree. Lake now describes a finite discrete information-theory package,
includes the Reservoir `math` keyword, and declares `fixedToolchain = true` in
both configuration and manifest. The shared static gate parses and checks the
exact package/library/dependency metadata, canonical Apache-2.0 licence,
reviewed CFF fields and sole author, exact release date, README
AI/legal/citation wording, and the reviewed absence of `NOTICE` and
`.zenodo.json`. At Step 9 it also required an absent DOI; the post-release gate
requires the exact issued version DOI. CFF schema validation, provenance,
author spelling, and the then-current 44 exact headers passed. Step 14 later
finalized all corresponding
decisions, initially fixed `date-released` as `2026-08-27`, and extended the
header audit to the 45-file tree including the documentation shim. The project
lead superseded that initial date on 2026-08-28 with `2026-09-01`; no other
Step 14 decision changed.

Step 10 made the release entry points usable without changing Lean source or
the frozen API. The README now gives the exact tag-pinned Lake dependency and
toolchain contract, lightweight/full/focused import guidance, supported scope,
nats and guarded-KL conventions, limitations, `0.1.x` compatibility, and
maintained reproduction commands. The release-candidate pass converted the versioned
[`docs/releases/v0.1.0.md`](releases/v0.1.0.md) and README to timeless final
release prose; while the candidate was frozen, transient commit, CI,
publication, and DOI state belonged only in external validation and release
records. This post-release revision now records the completed publication and
DOI propagation without changing the immutable source snapshot. The release
date is `2026-09-01`, and the immutable tag remains DOI-free. Five marked README examples compile independently
with warnings as errors through the shared local/CI validator; the static gate
also checks release-document markers and local links. No new example module was
needed, so the 44-module/90-edge/716-declaration source inventory and the
31-module/601-declaration supported surface remain unchanged.

Step 11 adds signature-bearing generated documentation without changing the
mathematical library or frozen API. Its isolated build pins `doc-gen4` `v4.33.1`
at commit `e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015` and leaves the package runtime
graph unchanged. The local checker confirms exactly 31 supported pages, all 601
declarations with rendered signatures, 92 canonical export targets, 13 non-
stable exclusions, and zero optional equation rows. The mathematical inventory
remains 44 modules; the project-authored header scan is now 45 Lean files because
it includes the build-only `docbuild/CCShim.lean` shim. No mathematical source,
supported API, root import, or runtime manifest changed. Independent final
review is complete and found no remaining issue after its corrections were
re-reviewed.

The automatic Lean-version tag/release workflow is permanently absent after the
Step 15 safety-only commit. The manual-only Pages workflow has no push trigger
and requires an explicit `publish=true` dispatch before deployment. The
historical release deployment was built entirely at the release commit; current
maintenance deployments instead compose current unversioned project pages with
the exact-release versioned API. The `v0.1.0` tag, immutable GitHub Release,
Zenodo record `22229599`, version DOI `10.5281/zenodo.22229599`, and structured
institutional `RightsHolder` are verified. The current workflow is not used to
publish one-identity artifacts from post-release `master`. Instead, maintenance
staging rebuilds the versioned API in the exact release checkout and composes
it with current unversioned project pages under separate identities and a
checked route digest. `ShannonCert` remains outside this repository. The Step 3
migration required compatibility edits across
22 Lean files, but the independent audit found no public signature,
assumption, namespace, attribute, import, dependency-boundary, or root-import
change; the Step 3 plan-health review then left the 17-step sequence intact.
The later Step 13 checkpoint amended that sequence to 18 steps for a separate
remote-safety landing.

**Project B Chunk 8 is complete through `C8.24`, checkpointed as `1eef228`,
pushed, remotely build-validated, and deployed.** Subsequent C9--C13 and
C14.01--C14.03 work is complete; C14.04 selects cumulative qualification.

Chunks 5--8 are checkpointed as `ec78829`, `7b5f0db`, `5e616d8`, and
`1eef228`. The
approved Chunk 8 execution plan is
[`docs/plans/chapter2-chunk-08.md`](plans/chapter2-chunk-08.md), based on
commit `a27ef8d`; all 24 steps are complete.

### Frozen Chunk 8 implementation

- `Shannon.FiniteFamily` now contains exactly four new law/source binary and
  ordered conditional-family CMI chain rules. They deliberately tolerate
  overlap, duplicates, and initially conditioned variables and remain
  explicit rather than `[simp]`.
- `Shannon.SemanticBridge.ConditionalKL` defines common-base channel
  `conditionalKlDiv`, proves self-divergence, the finite unconditional
  weighted `ENNReal` formula, the two-base joint KL chain rule, and
  active-support-guarded Real forms.
- `Shannon.SemanticBridge.FiniteFamilyIndependence` defines PMF/source
  finite-atom mutual independence by pointwise factorization and proves empty,
  singleton, restriction, pair compatibility, and PMF/source n-way entropy-
  additivity iff mutual-independence results.
- `Examples.ConditionalKL` and the expanded `Examples.FiniteFamily` maintain
  private regression coverage for null and infinite KL fibers, support and
  `toReal` boundaries, duplicate/overlap chains, dependent alphabets, product
  families, and pairwise-but-not-mutual independence.
- The source/API review retained all 18 public names, made only self/empty/
  singleton reducing rules simp, kept proof-engine helpers private, and left
  every new heavy owner outside `LeanInfoTheory.lean`.
- `C8.21` passed the nine-target focused build with 2,783 jobs, direct and
  aggregate consumers, exact guarded boundary checks, the preliminary
  15-theorem axiom manifest, strict placeholder scan, and repository hygiene.
  A narrow follow-up completed the intermediate import matrix and rebuilt the
  affected targets with 2,764 jobs.
- `C8.23` regenerated the source-derived references and reconciled the public
  pages. The resulting inventory is 51 modules, 100 local edges, 11 root-
  reachable modules, 40 opt-in modules, and 880 documented declarations.
- `C8.24` independently passed the 2,783-job owner/downstream build, the
  2,792-job maintained suite, default 2,240-job build, all direct and boundary
  consumers, the complete 15-theorem axiom audit, generators, website checker,
  placeholder scan, and repository hygiene.

### Exact-candidate and publication procedure

For any candidate represented by this source state, record the exact SHA and
qualification evidence externally. An unchanged commit must pass the local,
clean-checkout, external-consumer, remote routine, and nonpublishing API-doc/
Pages gates, then independent Step 17 review. Any source correction creates a
new candidate and repeats exact-candidate qualification. Step 18 publication
always requires separate explicit authorization; this tracked snapshot does not
claim which external gate has completed.

### Next review point

C15.01--C15.04 and their independent reviews are complete by their actual
private records. The authorized initial C15.05 checkpoint passed the complete
clean routine suite; actual two-pass API-doc qualification and rendered inspection
passed separately. Finish and qualify every amended candidate, preserve exact
source/API-doc applicability and retain self-review/reassessment before fresh
independent review of all 17 criteria. Its original report, reconciliation and
supported closure remain source-bound obligations. No later chunk, push or
publication is selected.
The following paragraphs preserve predecessor chronology; C14 is already complete
by its actual C14.04 completion record and is not reopened.

C9 is complete through C9.07 by its actual private completion record at source
checkpoint `8ee0337b20c320c384d5637de852da7f4ee09728`. The
[maintained C9 handoff](handoffs/chunk-9.md) preserves delivered APIs, evidence
and remaining-work dispositions; its captured pre-closure wording does not reopen
that completed chunk.

C10 is complete through C10.07 at source checkpoint
`37b4ba90d1ab321645f80cacef475f10a3a6ba43`, by its actual private completion
record. The [C10 handoff](handoffs/chunk-10.md) preserves its delivered 25-declaration
TV API and evidence; its provisional chronology does not reopen the completed chunk.

The approved [C11 plan, revision 2](plans/post-release-chunk-11.md) is complete
through C11.06 by its private closure at `bbead98`. The following paragraphs
retain its checkpoint and validation history.
C11.01--C11.05 and their reviews are complete by their private records, most
recently `.lit-review/setup/c11-05-completion-20260926.json`. The completed
predecessor and its exact source were verified before selecting C11.06 with review.
The cumulative candidate retains the ten public coupling declarations and both
private consumer owners, including the actual maximal witness and its swap in
Fano with exact TV error and independent-product measure interoperability.
The C11 cumulative candidate recorded 638 documented declarations in
33 owners, with 94 reviewed simp declarations and 92 facade aliases. Its baseline inventory
recorded 52 modules, 110 local edges, 5 root-reachable and 47 separate-import
modules, with 753 indexed declarations (752 documented and one example-only instance).
The lead explicitly authorized the exact local checkpoint and necessary
C11.06-only amendments. Initial checkpoint
`2147dd3449af620f41d9bed8d37c5be8252f20e8` passed the clean complete routine
suite and real two-pass current file-mode API-doc gate; the
[maintained C11 handoff](handoffs/chunk-11.md) identifies original results and the
actual Coupling-page inspection. Any amended candidate requires renewed complete
routine validation and exact API-doc applicability. C11.06's source-bound private
records establish the fresh all-17-criterion review, original-report
reconciliation, final validation and review applicability, final capture and
closure. This maintained chronology does not itself certify completion.
C12 is complete through C12.04 at `492cd6e60c5d6b42a22ef2dcbb45d21067b6d378`,
by `.lit-review/setup/c12-04-completion-20261003.json`. Its captured provisional
wording is historical; the [C12 handoff](handoffs/chunk-12.md) preserves
contracts, validation and remaining-work owners. The lead accepted the
[C13 revision-2 plan](plans/post-release-chunk-13.md). C13.01--C13.03 and their
reviews are complete, most recently by
`.lit-review/setup/c13-03-completion-20261003.json`. C13.03's exact final source
was verified before the lead's conditional C13.04 request was accepted.
C13.04 selected cumulative qualification and the [C13 handoff](handoffs/chunk-13.md).
The lead authorized the 25-file checkpoint, separate clean validation checkout
and C13.04-only amendments. Initial checkpoint
`17fb736a00448ecdd0aa824fd1928713bf716f01` passed the full routine suite in
1975.056 seconds. The [C13 notes](plans/post-release-chunk-13-notes.md)
retain the initial-checkpoint evidence and limits; subsequent validation,
review and closure are established by C13.04's source-bound completion record.
C13 subsequently completed at `ebe48eae`; C14.01--C14.03 are complete and
C14.04 is selected. C15--C24 remain unselected.

## 13. Future-Work Register

The detailed numbered register is in `docs/project-log.md`. At this baseline it
contains 40 notes: 38 active or standing and two closed historical notes.
"Active" includes guardrails and proof-pressure triggers; it does not mean
"implement immediately." Each numbered note has exactly one primary category
below; relationships between categories are described without listing a note
again.

### Active near-term work

| Note | Work |
| --- | --- |
| Unnumbered | **Chunk 8 is complete through `C8.24` and checkpointed as `1eef228`.** Its 18-declaration API, generated references, complete validation evidence, exact-SHA Lean workflow, and Pages deployment pass; any later theorem phase requires a separate decision. |
| Unnumbered | **C15.05 selected:** C9--C14 and C15.01--C15.04 are complete by private records. The approved [C15 plan](plans/post-release-chunk-15.md), [notes](plans/post-release-chunk-15-notes.md) and [handoff](handoffs/chunk-15.md) govern cumulative qualification, all-17-criterion review and final reconciliation. Later chunks remain unselected. |
| 29 | **Finite-Fano phase checkpointed.** Commit `ec78829` completes the approved phase; its evidence-based Fano follow-ups remain open and deferred. |

Note 29 also preserves proof-pressure triggers from `C5.08`-`C5.11` and
`C5.13`, together with the `C5.16` pedagogy/sharpness follow-ups. They are
later work, not reasons to expand the frozen Chunk 5 API retroactively.

### Standing architecture and maintenance guardrails

| Notes | Guardrail |
| --- | --- |
| 2-4 | Split large files only when a real dependency boundary appears; keep core imports light; keep `MathlibFragments` opt-in. |
| 6, 8 | Upstream conservatively and re-audit mathlib after upgrades. |
| 14-16 | Preserve names during active work and retain the reviewed conservative simp policy; completed review events do not close these policies. |
| 17-18 | Run milestone checks and preserve completed chunk/module boundaries. |
| 26 | Do not split `SemanticBridge.Independence` solely because of file size. |

Future Work Note 14 remains the theorem-development naming/alias watchlist,
historical decision record, and source of standing review criteria.
Deduplicated post-`v0.1.0` downstream discovery friction is owned by
[`downstream-api-feedback.md`](downstream-api-feedback.md), while raw search
attempts remain in the downstream project that observed them. C9 retains both
approved helper names, adds no aliases or simp rules, and preserves owner/import
boundaries. Notes 9 and 14--18 remain standing; their C9 dispositions, owners and
reopening triggers are consolidated in the [handoff](handoffs/chunk-9.md#remaining-work-and-c10).
Note 25 closes only its deterministic right-processing slice. C10 retains its
25 selected names without aliases or new simp rules. Its [handoff dispositions](handoffs/chunk-10.md#remaining-work-and-next-chunk-boundaries)
preserve Notes 9 and 14--18 with their owners and concrete reopening triggers;
the private normalization and binary-reduction consumers do not create exported
coupling or Pinsker APIs. C11's [remaining-work dispositions](handoffs/chunk-11.md#remaining-work-owners-and-triggers)
carry these standing duties forward together with Notes 26 and 29, the concrete
C12/C14 prerequisites and optional coupling API triggers. C11.06 qualifies the
completed coupling source without closing or renumbering those notes.

### Later Chapter 2 and finite-foundation work

| Note | Work |
| --- | --- |
| 38 | **Partially discharged later milestone.** Permanent stochastic examples exercise the PMF-facing results; add a matrix bridge only when majorization/Birkhoff consumers exist. |
| 39 | Plan canonical/minimal sufficiency, support-aware statistic comparison, and later iid/count-statistic or measurable extensions. |
| Unnumbered | Chunk 7 owns finite log-sum, KL convexity, entropy concavity, and MI input/channel convexity. C13 Pinsker and C14 quantitative continuity are complete. C15.01 supplies the topology/simplex foundation; C15.02 supplies the validated TV convergence bridge; C15.03 adds fixed probability-map continuity. C15.04 adds finite information continuity and actual maximizing-input consumers; cumulative qualification remains C15.05. Later tensorization retains its separate trigger. |

The finite-family phase is complete, independently validated, and checkpointed
as `7b5f0db`. Completed Chunk 8 closed the approved finite conditional-CMI,
conditional-KL chain-rule, and mutual-independence equality gaps without
adding topology or continuity. Completed C13 supplies bounded Pinsker results;
completed C14 supplies the bounded quantitative continuity family. C15.01 adds
the PMF topology/simplex/compactness foundation. C15.02 adds its TV convergence
bridge; C15.03 adds fixed-channel continuity and C15.04 adds finite
information continuity and actual MI attainment. Tensorization, global indexed-family
independence and broader conditional-KL variants remain separate future phases
governed by their recorded pressure and approval rules.

### Broader information-theory work

| Note | Work |
| --- | --- |
| 5 | Add Kraft-McMillan and other coding material in a later coding layer. |

The completed finite-Fano theorem layer excludes channel powers, stationary
processes, entropy rates, capacity, AEP, typicality, method of types,
source/channel coding, and nontrivial network converses. These remain later
roadmap work rather than hidden parts of Chunks 5-8.
The proposed post-release map selects finite blocks, finite-iid AEP,
fixed-length source coding, information capacity, and a weak channel converse;
stationary processes, entropy rates, types, channel achievability, and network
theorems remain outside it. Note 5's variable-length/Kraft-McMillan work is not
discharged by selecting fixed-length coding.

### Downstream certificate work

| Note | Work |
| --- | --- |
| 7 | **Transferred downstream.** Keep PSITIP/oXitip-style infrastructure outside LeanInfoTheory unless a reusable abstraction receives explicit review. |
| 11 | **Transferred downstream.** Certificate-specific independence, functional-dependence, and Markov constraints. |
| 12 | **Transferred downstream.** Primitive recognition/autotagging. |
| 13 | **Transferred downstream.** External certificate import and untrusted parsing. |

The old notes remain in the chronological project log as historical design
records. Step 4 reassigns their implementation ownership downstream; they are
not pending LeanInfoTheory release work.

### Channel and Markov proof-pressure-deferred API work

| Note | Triggered question |
| --- | --- |
| 21 | Add a coherent injective MI relabeling family only after repeated augmentation proofs. |
| 25 | **Partially discharged by C9.05:** deterministic postprocessing has the approved theorem and private consumers. Additional atom-level, constant/self-independence or public orientation conveniences remain consumer-triggered. |
| 27 | Add conditional-independence symmetry, closure, or representation conveniences only at their recorded consumer triggers. |

### Other proof-pressure-deferred API work

| Note | Triggered question |
| --- | --- |
| 19 | Promote the private deterministic-entropy decomposition only after a genuine second consumer. |
| 22 | Add a general real-KL zero iff under explicit `klDiv != top` only after repeated branch-elimination proofs. |
| 23 | Generalize uniform-reference KL to infinite ambient alphabets only when finite-support consumers need it. |
| 24 | Extract strict-Jensen equality infrastructure only after another extremization proof repeats it. |
| 30 | **Partially discharged.** `PMF.channelJoint_eq_iff_eq_on_support` and C12's `PMF.channelExtension_eq_iff_eq_on_support` handle induced joint and whole triple laws. Broader weighted null-fiber laws and opposite reconstruction orientation still require repeated use. |
| 31 | Add a product-channel constructor only after a second independent-channel consumer. |
| 32 | Add subtractive or reversed Markov information-loss forms only after quantitative proofs require them. |
| 33 | **Partially discharged.** The conditional-entropy DPI equality branches are complete; strict-loss variants remain consumer-deferred. |
| 34 | Keep stochastic-channel processing PMF-first until a natural random-variable coupling contract appears. |
| 35 | Keep finite KL equivalence relabeling private until a second caller needs it. |
| 36 | Keep bind-support monotonicity private until repeated production use. |
| 37 | Add `[Finite]` posterior wrappers or weighted fiber-KL expansions only after repeated consumers. |
| 40 | Add a generic common-bind-recovery KL retraction theorem only after an independent non-sufficiency consumer. |

### Possible mathlib upstreaming

- Generic PMF map, support, or finite-measure lemmas may be upstream candidates
  after their contracts stabilize.
- Re-run the semantic bridge audit on every mathlib upgrade before extending a
  local helper family.
- Substantial project-facing definitions should remain local until names,
  assumptions, and downstream use are stable.
- Certificate syntax and external import are not current upstream targets.

### Documentation and website work

| Note | Work |
| --- | --- |
| 9 | Maintain current local signature-bearing API docs separately from frozen-route staging; C10.07 requires a real two-pass result bound to its final source. Later add theorem-level leanblueprint data, a blueprint PDF, and optional equation-expanded pages if justified. Also consider a structured source for repeated status fragments and complete verified module-summary metadata. |
| 10 | Add `CONTRIBUTING.md`, beginner tasks, issue labels, and upstream guidance before broad contributor outreach. |
| 28 | Later improve opt-in example pedagogy: the side-information recovery example, `KLTop` absolute-continuity notation, and, only if compact, matched numerical Boolean examples exhibiting strict MI input concavity and channel convexity. Preserve existing declarations and avoid new core helpers solely for pedagogy. |

Routine website redesign is not current work. Existing pages should be kept
accurate and regenerated after public Lean declarations or imports change.
C5.19 completed the Chunk 5 refresh; `C6.23` completed the Chunk 6 refresh;
`C7.21` completed the corresponding Chunk 7 refresh without redesigning the
site.

### Speculative research directions

- topology and continuity questions beyond the selected C15 scope, including
  support-sensitive KL;
- divergence comparisons beyond the approved finite-PMF Pinsker family;
- tensorization and single-letterization;
- constrained entropy/MI extremization;
- canonical/minimal sufficiency and experiment comparison;
- matrix majorization and Birkhoff-von Neumann bridges;
- downstream network-converse applications.

These are not approved theorem tasks until assigned to a focused phase.

## 14. Completed, Superseded, or Obsolete Future Work

- **Note 1 is closed.** Chunk 6 implemented and independently validated the
  accepted dependent finite-family representation, concrete
  `ShannonEntropyVal`, checked-certificate adapter, examples, generated
  references, and milestone closeout. The note remains as representation and
  architecture rationale; it does not authorize a later chunk.
- **Note 20 is closed.** The proposed elementary MI example module was judged
  redundant; theorem pressure and API probes were sufficient.
- Partially discharged active entries and standing policies with completed
  review events remain in their single primary categories in Section 13.
- **[Superseded]** Earlier claims that semantic bridges, certificate
  validation, independence, DPI, or sufficiency were merely planned are
  historical only.
- **[Superseded]** The original eight-chunk boundaries are not current module
  ownership. See Sections 6 and 8.

## 15. Textbook and Reference Coverage

### Registered post-release sources

The [mathematical reference register](references.md), added on 2026-09-11,
records exact local files, edition dates, hashes, selected sections, and
source-model adaptations. It distinguishes Cover--Thomas 1991 (`CT91`), the
historically used Polyanskiy--Wu 2022 draft (`PW22`), the preferred 2024 planning
draft (`PW24`), Sason's version-pinned maximal-coupling paper (`SA13`), and
Levin--Peres second edition (`LP17`). Relevant sections informed the proposed
post-release map; neither registration nor planning means an entire source has
been read or formalized. The older section-number citations below remain
historical anchors, not references silently transferred to the newer draft.

C10 inspected LP17 Sections 4.1--4.2 and PW24 Section 7.3 in these exact editions.
Its half-L1/event/test normalization and finite-algebra adaptations are recorded
in the [C10 handoff](handoffs/chunk-10.md#mathematical-sources-and-adaptations).
C11.03--C11.04 source supplies the finite common-mass construction, exact
marginals and exact disagreement, following SA13 Section I and LP17 Section 4.2
as recorded in the approved C11 plan. The finite matrix and event proof make
zero/unit-TV branches explicit; the public formulas and universal inequality
express attained optimality. Those steps are complete by their private records.
C11.05 reuses the existing Fano contract: CT91 Section 2.11, Theorem 2.11.1,
printed pages 38--40 / PDF pages 60--62, and PW22 Section 6.3, Theorem 6.3,
printed page 82 / PDF page 103, support its conditional-entropy bound. The
consumer uses deterministic identity decoding, canonical nats and the existing
singleton-inclusive Lean contract. The PW22 theorem number is not transferred
to PW24. C11.05 and its review are complete by the actual private record;
C11.06 owns cumulative qualification, with exact validation, fresh review and
closure established by its private records. The
[C11 handoff](handoffs/chunk-11.md#mathematical-sources-and-adaptations) records
the source adaptations and their limits. The KL side of binary reduction remains
separate.

### Reviewed during this reconciliation

**Cover and Thomas, Elements of Information Theory, Chapter 2**

- Sections 2.1-2.6 were checked for entropy, conditional entropy, relative
  entropy, MI/CMI relationships, chain rules, Jensen consequences, equality
  cases, and alphabet bounds.
- Section 2.7 was checked for finite log-sum, KL joint convexity, entropy
  concavity, mutual-information concavity in the input law, and convexity in
  the channel. Chunk 7 implements this finite PMF scope; topology and
  continuity are explicitly outside it.
- Section 2.8 was checked for the Markov definition, DPI, deterministic
  processing, equality through the reverse chain, and the conditional
  corollary.
- Section 2.9 was checked for KL contraction, invariant distributions,
  doubly stochastic entropy growth, and the distinction between one-step laws
  and process-level claims.
- Section 2.10 was checked for sufficiency as a reverse Markov condition, MI
  preservation, and minimal sufficiency.
- Section 2.11 was checked for the error indicator, binary entropy term,
  conditional-entropy Fano bound, weaker cardinality bound, and error lower
  bound.

The coverage matrix in Section 6 follows this section order. The local project
uses nats rather than the textbook edition's default bits.

**Polyanskiy and Wu, Information Theory: From Coding to Learning**

- Section 3.5 was checked for prior-free recovery-channel sufficiency, the
  every-prior Markov/MI equivalences, Fisher factorization, and the two-law KL
  equality viewpoint.
- Section 6.3 was checked for finite prediction error, binary/q-ary entropy
  notation, Fano's inequality, randomized estimators, and later converse use.

### Historical reference inputs

Project records state that earlier design work also consulted:

- El Gamal and Kim, Chapter 2, for network-information-theory conventions;
- Yeung, Chapter 2, for entropy identities and the algebraic viewpoint used by
  certificates;
- Csiszar and Korner, early finite-alphabet/channel/divergence chapters;
- Rocq `infotheo`, PFR, and current mathlib APIs for formalization comparison.

These historical consultations inform rationale, but this summary does not
claim that every section of those books was reread at the current baseline.
Consult the exact relevant section when a future theorem depends on it.

### Copyright boundary

This document records topics, theorem families, and conventions only. It does
not reproduce textbook prose or proofs.

## 16. Validation State

### Current C15.05 qualification

The successful C15.04 closure and all 232 captured source entries matched at
intake. Its retained focused, instance, documentation, static and full trust
checks establish earlier mathematical qualification; they do not substitute
for C15.05's clean cumulative routine suite or fresh actual two-pass API-doc
milestone. The lead authorized the exact 20-file local checkpoint, scoped
C15.05-only amendments and reuse of the relocated clean checkout.
Initial checkpoint `000aae22bf2db249e0286183b6cd3ebf4e910aba` passed the complete maintained routine suite in 3435.257 seconds.
The command was `python -B scripts/validate_release.py`; original results and
checkout comparisons are retained under
`.lit-review/setup/c15-05-20261013/full-checkpoint/`. The clean candidate,
protected primary exclusions and two historical EOL differences are distinguished
in the handoff. Existing pinned dependencies and incremental caches were used.
The actual current two-pass API-doc gate and rendered inspection passed on
source-stable inputs; the retained initial missing-page failure and bounded
generated-marker recovery are recorded in the handoff.
Final evidence must record the exact candidate, dependency/configuration
identity, actual commands and results, rendered inspection, self-review and
separate reassessment, original all-17-criterion report, every reconciliation
and final applicability before supported private closure. Every checkpoint
amendment requires renewed full routine validation and separate exact API-doc
applicability. The actual final qualification/review/closure records and user
report establish eventual success without a post-capture prose rewrite. The
[C15 handoff](handoffs/chunk-15.md) records duties and evidence limits.

The actual current file-mode API-documentation gate passed both build/check
passes on source-stable inputs (528.972 seconds). All 16 new
declaration HTML blocks were checked for exact owner, signature/hypotheses,
useful docstrings and file source links. Browser inspection covered the three
new owner pages and the full Shannon umbrella page. The exact v2 source/configuration,
relevant-output digest and two-pass attestation are retained privately. The
whole-tree digest is attributed to the maintained gate, separately from the
parent's fresh relevant-page inspection. Existing reviewed Zig 0.16.0 and
pinned doc-gen caches were used; this is not a cold rebuild.

The first attempt failed because aggregate HTML generation reused an old
completion marker after extracting the new declarations, leaving all three
C15 owner pages missing. Its source and API inputs remained unchanged. The
parent retained that failure and the original bytes of exactly three ignored
Shannon HTML marker/hash/trace files, invalidated those files and ran both real
passes successfully. No source, dependency or validation rule was changed for
the recovery. Replayed upstream Qq extraction warnings remain in the logs;
the complete semantic checks passed. Current output stays in
`docbuild/.lake/build/doc/` and does not replace the historical release route.

### Historical C15.04 qualification

The predecessor closure and all 230 captured source entries were verified
before conditional intake. All eight required warning-as-error targets passed:
the three topology owners, three focused consumers, Shannon and Examples.
Both separate fresh-import probes passed automatic global topology/compactness,
definitional subtype agreement, `Finite`-only compactness, empty/singleton/Boolean
cases and direct coordinate continuity/convergence. Static passed the generated
references, architecture/policy checks and 34 website-checker tests. Mandatory
documentation passed five README and four website guide examples independently
with warnings as errors. Full trust preserved all 601 retained signatures,
verified 669 supported declarations in 39 owners, 94 simp declarations and
92 root exports, and audited all 66 modules/2,198 local constants using only
`Quot.sound`, `Classical.choice` and `propext`.

The complete before/after inventories agree and match all 232 reviewed entries.
Actual commands, streams and manifests are retained under
`.lit-review/setup/c15-04-20261013/attempt-2/`. Earlier parent failures on a
private limit alias and an English docstring scanner match remain separate;
their corrections changed no approved statement. Helper prototypes are
implementation feasibility evidence, not the independent step review.

The same bound independent reviewer assessed all four C15.04 criteria satisfied
with no material or optional findings. It inspected the information proofs,
actual extremum application, boundary/degeneracy consumers, focused closure,
policy and source adaptations; independently compared 50 supplied/supplemental
hashes before and after; rechecked the registered PW24 file and exact pages;
ran both fresh-import instance probes; re-elaborated the exact owner with
additional generic, empty, pure-boundary and arbitrary-filter applications and
axiom checks; re-elaborated the exact consumer; and passed the maintained static
gate. All its fresh checks passed.

The original report separates these independent checks from parent-run focused,
documentation and full trust results. Its 50-path hash check does not reconstruct
the complete source fingerprint; imported artifacts were reused by its stdin
probes. The parent separately verified all 232 inventory entries and supplied
the completed trust result before the final report. Neither party claims a
clean default suite, current API-doc milestone or retrospective per-olean
attestation. Cooperative review provenance is not OS isolation.

The original native report is preserved, delivery confirmed separately after
the empty immediate response, and all original assessments reconciled. Final
updates are confined to three prose documents; source/configuration/dependency
applicability and fresh static, local document-link and diff checks precede
supported private closure. No clean default suite or current two-pass API-doc
qualification is claimed here. C15.05 and later work remain unselected.

### Historical C15.03 qualification

All six required warning-as-error targets passed: both probability-topology
owners, both permanent topology consumers, Shannon and Examples. The two
separate fresh-import probes passed through Lean stdin, with exact source and
outputs retained: actual global topology/compactness synthesis, definitional
subtype agreement, `Finite`-only compactness, empty/singleton/Boolean cases and
coordinate continuity/convergence interfaces. Parent static passed both
generator checks and all 34 website-checker tests. Full trust preserved all 601
retained signatures and verified 665 current declarations in 38 owners,
94 simp declarations, 92 root exports and all 64 modules/2,155 local constants
using only `Quot.sound`, `Classical.choice` and `propext`. Complete before/after
source inventories agree and match the reviewed source. Original commands,
streams and manifests are retained under
`.lit-review/setup/c15-03-20261013/attempt-3/`.

The initial owner build failed in elaborating the joint-coordinate product;
goal-directed simplification corrected the proof and the owner-only rerun
passed. The first six-target attempt then failed on a private joint-limit
function alias; explicit unfolding corrected it. Later stages of that failed
attempt did not run. Both failures remain separate from successful evidence.

The same bound independent reviewer assessed all three C15.03 criteria satisfied
with no material or optional findings. It inspected the proofs, permanent
consumers, imports, policy and pinned APIs; compared 40 supplied/supplemental
file hashes before and after; independently ran both fresh-import instance and
generality probes; re-elaborated the exact owner and consumer sources through
Lean stdin; and passed the maintained static gate. Its initial plan-excerpt
printing command failed under Windows cp1252; the UTF-8 rerun passed. That
failure did not invoke Lean or modify source and remains separate evidence.

The original report distinguishes parent-run focused/trust results from those
independent checks. Its 40-file comparison does not reconstruct the full source
fingerprint; imported artifacts were reused by its no-output compiler probes.
The parent separately verified all 230 inventory entries and retained the
completed trust result. The trust command's maintained target build is not the
clean default validation suite; no clean-candidate or API-doc milestone is claimed.

The original native report is preserved, delivery confirmed separately after
the empty immediate response, and all original assessments reconciled. Only
three prose documents change after review; exact source/configuration/dependency
applicability and fresh static, document-link and diff checks precede supported
private closure. No README/guide or release-facing contract changed, so the
separate documentation mode is not additionally required here. Clean routine
and current API-doc milestones remain C15.05 duties; no later step is selected.

### Historical C15.02 qualification

The five required warning-as-error targets passed: the TV-topology owner, its
consumer, the existing finite-topology consumer and both aggregates. Parent static
validation passed, including all 34 website-checker tests. The full trust gate
passed all 601 retained signatures, 662 current declarations in 38 owners,
94 reviewed simp declarations and 92 root exports. It audited all 64 modules
and 2,104 local constants using only `Quot.sound`, `Classical.choice` and
`propext`. The complete before/after source inventories are identical and match
the reviewed source. Original commands, streams and manifests are retained under
`.lit-review/setup/c15-02-20261013/attempt-3/`.

The first owner compilation failed on two composition simplification mismatches;
explicit `Function.comp_def` reductions preserve both public statements. The next
five-target attempt compiled the new proofs but failed a strict umbrella
module-doc line-length warning; wrapping that line fixed it. Both failed
commands remain distinct from the successful run.

The independent reviewer inspected the proofs, consumers, imports and pinned
APIs, compared 37 relevant supplied hashes before and after, freshly elaborated
the exact consumer and public-interface probes, and ran the static gate. It
reported all three criteria satisfied with no findings and kept parent build/trust
evidence separate from its own checks. Its first probe wrapper failed to print
Unicode after Lean had succeeded; the corrected UTF-8 rerun passed and both
observations remain in the original report.

Only canonical documentation changes follow that review. Exact applicability of
the unchanged Lean/configuration/dependency/policy inputs and fresh static, local
document-link and diff checks are required before supported private closure.
No README/guide examples or release-facing contracts changed, so the separate
`documentation` mode is not additionally required here. The clean default and
current API-doc milestones remain C15.05 duties.

### Historical C15.01 qualification

The four required focused targets passed warning-as-error compilation, and
both separately compiled focused-owner and full-umbrella instance probes passed.
The complete trust gate passed: all 601 retained signatures, 660 current supported
declarations in 37 owners, 94 reviewed simp declarations and 92 root exports.
Its all-project audit checked 62 modules and 2,082 constants with only
`Quot.sound`, `Classical.choice` and `propext`. Parent static validation passed,
including both generated-artifact checks and all 34 website-checker tests.
Successful compiler/trust runs share an unchanged source inventory. The earlier
failed focused attempt and its two corrected private consumer proofs are retained
separately from the successful rerun. Exact commands, streams, probe sources and
manifests are under `.lit-review/setup/c15-01-20261012/`.

The independent reviewer checked the mathematics, consumers and API boundaries,
ran both fresh-import probes and the static gate, and marked all four C15.01
criteria satisfied with no findings. Its original report distinguishes these
independent checks from the parent-reported builds/trust audit. The parent
received and reconciled that report. Final prose updates require current static
and document/link/diff checks and explicit applicability of unchanged compiled
inputs; those final-source records and private closure govern completion.
Earlier C15 feasibility probes and C14 validation do not certify this candidate.

C15.01 does not change README or maintained website-guide examples or the
release-facing contract. The clean routine and two-pass current API-doc milestone
remain C15.05 duties; the old API-doc attestation does not cover the new owner.

### Historical C14.04 qualification

<!-- c14-04-validation:start -->
Fresh six-target warning-as-error compilation passed (3.836s),
as did the maintained documentation contract with five README and four website
guide examples (157.728s), and static/generated/site validation
(12.218s). Final non-mutating static validation is required after these
result-recording prose edits; its exact result is retained privately.
The actual source-stable current file-mode API-documentation gate passed
(731.686s total; build/check passes 160.9s and 22.0s).
All six rendered declaration signatures, assumptions, useful docstrings, owner
source links and the full Shannon umbrella were inspected. The v2 source,
configuration and two-pass attestation are retained under
`.lit-review/setup/c14-04-api-doc-inspection-20261008.json`; exact post-edit
applicability is required and recorded separately. Existing reviewed Zig 0.16.0,
pinned doc-gen dependencies and incremental caches were used, not a cold rebuild.

The initial missing-Continuity-page failure is retained separately. The parent
preserved and invalidated exactly three ignored Shannon aggregate HTML marker
files after reproducing the stale-marker failure. That initial attempt also
overlapped tracked prose edits and two owned EOL normalizations; its exact API
inputs were unchanged, but it is failed evidence only. The successful rerun
kept the entire candidate unchanged. No source, pin or validator was changed
for the recovery. The two upstream Qq extraction warnings were replayed in
doc-gen logs; both complete maintained semantic checks passed.

The lead authorized the prepared 23-file local checkpoint, necessary C14.04-only
amendments and reuse of the clean validation checkout. Initial checkpoint
`ca079e2d11ecccffbe2b91fe1848be5bad3541f2` passed the complete routine suite in
3256.611 seconds, using existing pinned dependencies and incremental
caches. The [handoff](handoffs/chunk-14.md) records the exact clean/primary
source distinctions and separate API-attestation limits; unrelated website
notes remain untouched and excluded from the checkpoint.

Every amended candidate requires renewed complete routine validation and exact
API-doc applicability. Fresh cumulative review of all twelve criteria,
reconciliation, final-source applicability and closure must be established by
the private source-bound records. This entry records initial-checkpoint
qualification without certifying future gates. The eventual completion record
and user report resolve this pre-closure wording; no post-F edit is required.
C15--C24, push and publication remain unselected.
<!-- c14-04-validation:end -->

### Historical C14.03 qualification

<!-- c14-03-validation:start -->
The strict owner build and final six-target owner/consumer/aggregate check passed.
The exact-contract probe verified the approved independently universe-polymorphic
signatures and permitted axioms. The maintained `trust` gate passed in
1729.329s: all 601 retained types, 653 supported declarations in 36
owners, 94 reviewed simp declarations, 92 root exports, and 2042 project
constants with only `propext`, `Classical.choice` and `Quot.sound`.
Existing incremental caches were used. Original attempts, commands, outputs
and source hashes are retained under `.lit-review/setup/c14-03-*`.
Static validation, original independent review, reconciliation and private closure
subsequently completed by `.lit-review/setup/c14-03-completion-20261007.json`.
The clean routine and current two-pass API-documentation milestone belong to
selected C14.04; its current status is recorded above.
<!-- c14-03-validation:end -->

### Historical C14.02 qualification

The focused owner and six maintained owner/consumer/aggregate targets passed
with warnings treated as errors, and the parent exact-contract/axiom probe
passed. The maintained `trust` gate passed in 2698.175s: all 601 retained
types, 651 supported declarations in 36 owners, 94 reviewed simp declarations,
92 root exports, and 1984 project constants with only `propext`,
`Classical.choice` and `Quot.sound`. Existing incremental caches were used.
Original attempts, failures, source hashes and outputs are retained under
`.lit-review/setup/c14-02-*`. Final static validation, original independent
review, reconciliation and private source-bound closure remain separate gates.
The clean routine and two-pass API-documentation milestone remain C14.04.

### Historical C14.01 qualification

The exact-TV owner, permanent continuity and retained CouplingFano consumers,
full Shannon/Examples aggregates and lightweight root passed focused compilation
with warnings as errors. The exact exported signature and axiom probe passed.
Full `trust` passed in 6916.613s, retaining all 601 historical types,
36 supported import closures, 94 reviewed simp declarations and 92 root exports;
the all-project audit covers 1930 constants with only the three permitted
axioms. The current manifest has 648 supported declarations.
The [C14 notes](plans/post-release-chunk-14-notes.md) retain original checks,
development failures, cache and evidence-script limitations. Final static/review
and closure receipts remain authoritative; this captured candidate prose does
not itself certify completion. Clean routine/API-doc qualification remains
C14.04. C14.01 closed successfully before the exact-source C14.02 intake.

### Historical C13 qualification

C13.01--C13.03 and their reviews are complete. Step 3's focused/static/trust
and strict signature checks passed, including all 601 retained signatures,
35 supported import closures and 1,906 compiled constants in 58 modules with
only the permitted axioms. Its exact final source was checked before selecting
C13.04. The [C13 handoff](handoffs/chunk-13.md) and private Step 4 records track
the separate actual API-doc milestone and clean complete routine suite.
The two API-doc build/check passes passed in 112.2s and 14.6s, with actual
inspection of all five Pinsker signatures/docstrings/owners and current v2
attestation. The reproduced missing-page failure and bounded marker repair
are retained separately. Focused and nine independent documentation examples
also passed. The lead authorized the 25-file checkpoint, separate clean checkout
and C13.04-only amendments. Initial checkpoint
`17fb736a00448ecdd0aa824fd1928713bf716f01` passed the complete routine suite in
1975.056 seconds. API-doc evidence remains bound to the primary checkout's
83 raw source inputs and file-source paths; the [handoff](handoffs/chunk-13.md)
records the clean checkout's historical EOL differences.
The source-bound C13.04 records subsequently established final validation,
review, reconciliation and closure at `ebe48eaea4282b1e4f245f8f45440bc930b8df73`;
the initial-checkpoint evidence above is retained as history.


### `v0.1.0` versions and historical mathematical baseline

- release-candidate source snapshot: Lean `v4.33.1`, commit
  `819816b2e0a3bf405af45ae5c7af2491d8f5bee6`
- release-candidate mathlib input revision: `v4.33.1`
- release-candidate mathlib manifest commit:
  `0df444a360eaa60ab8c11dca51a86af692955474`
- historical pre-release mathematical checkpoint: `1eef228`
- that checkpoint used Lean/mathlib `v4.30.0`, with mathlib
  manifest commit `c5ea00351c28e24afc9f0f84379aa41082b1188f`
- documentation-only handoff commits `72f9f87` and `9aa3bb1` precede the
  Chunk 7 source checkpoint and change no Lean source
- documentation-only handoff commit `0324ee6` follows checkpoint `5e616d8`;
  at the completed handoff gate local and remote master refs agreed there and
  both required workflows succeeded
- documentation-only baseline `a27ef8d` finalized the Chunk 8 handoff context
- source checkpoint `1eef228` contains the complete, independently validated
  Chunk 8 implementation; it was pushed on 2026-08-20 and both required
  exact-SHA workflows succeeded

### Release-preparation validation history

On 2026-09-01, the project lead explicitly authorized publication after two
independent final reviews passed candidate
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`. Immutable GitHub Releases was
enabled, annotated tag object `bcd9090ea2720fe14b0a3e168c76ebeef1dafd47`
was pushed, the GitHub Release was published, the tag-triggered routine gates
passed, and the exact-commit Pages artifact was manually deployed. Zenodo
accepted a redelivered `release.published` event, archived the release as record
`22229599`, and registered version DOI `10.5281/zenodo.22229599` and concept DOI
`10.5281/zenodo.22229598`. The maintainer added the ROR-normalized École
Polytechnique Fédérale de Lausanne contributor with type `RightsHolder`; both
Zenodo and DataCite expose that structured metadata. The archive checksum and
all 110 file contents match the immutable tag. On 2026-09-02, the project lead
authorized version-DOI propagation to the evolving default-branch CFF, README,
and tracked website sources without changing the tag, Release, archive, or Lean
API.

On 2026-08-28, after corrective candidate
`7989d54aefdf1ccaf8172ca9408e01cf0a5d645b` had passed its local, ordinary-
Windows, external-consumer, routine-CI, API-documentation, and nonpublishing
Pages gates, the project lead moved the planned Europe/Zurich publication date
from `2026-08-27` to `2026-09-01`. That choice supersedes the exact candidate,
so it must not be tagged and the SHA-sensitive Step 16 qualification gates must
be repeated on the date-amended candidate. No Lean source, public API,
toolchain, dependency, licence, authorship, rights-holder, Zenodo-route, or DOI
decision changed, and no tag, Release, deployment, Zenodo account, record, or
DOI was created.

On 2026-08-27, independent Step 17 review rejected initial candidate
`6a933d248dc183ddf9bd3c750f16e9cfdf772855` despite successful Lean, API-doc,
website, dependency-graph, metadata, and publication-safety gates. Current-
facing status pages still described Step 16 as pending and the validator
required that stale wording. An ordinary Windows checkout with
`core.autocrlf=true` also changed the raw bytes of `lake-manifest.json` from
CRLF to LF during `lake update`, leaving the tree dirty because no repository
EOL policy existed. The corrective source state adds an exact LF checkout
policy, strict clean-state and exact root-manifest validation, and timeless
status wording. Its exact candidate SHA and qualification evidence remain
external; no Zenodo account or integration action is performed by an agent.

On 2026-08-27, release-preparation Step 15 completed under the user's safety
amendment. The standalone default-branch commit
`81ffef37402909481c5dea51a42973dee9a79ae6` deleted only
`.github/workflows/create-release.yml`; remote verification found no tag,
Release, Pages deployment, Zenodo record, DOI, candidate change, or unintended
deployment. The old Pages workflow was deliberately retained until the user
approved the candidate's manual-only, `publish=false`-by-default replacement,
whose normalized SHA-256 is
`4a7e426f5fdf61ffd428503ac9364efdece71a11b9df7354c00e963643ed407c`.
The safety commit was reconciled without candidate drift at
`f0d06dfab4f411ced312294e63e96bb67bba859b`. At that checkpoint immutable
Releases was deliberately deferred; the contract permits enabling it only after
Step 17 review and explicit Step 18 publication approval.

On 2026-08-27, release-preparation Step 14 finalized every non-date legal and
provenance decision. The project lead confirmed sole copyrightable human
contribution and selected automatic post-release GitHub--Zenodo ingestion with
canonical `CITATION.cff`, no `.zenodo.json`, and no DOI in the immutable GitHub
Release or tagged CFF. École polytechnique fédérale de Lausanne (EPFL) is the
rights holder; Serhat Emre Coban remains sole creator with affiliation
`EPFL, Mathematics of Information Laboratory`; Apache-2.0 remains the licence.
The 45-file exact-header, canonical-licence, contributor, third-party, and
generated-asset audit found no missing attribution or concrete root-`NOTICE`
requirement. The project lead initially fixed the Europe/Zurich publication date
and `date-released` value as `2026-08-27`, completing Step 14; the approved
`2026-09-01` date superseded that initial choice on 2026-08-28. The exact 45-file
header/trust scan, canonical Apache check, focused
metadata and complete static gates, five README examples, and isolated CFF 1.2
schema validation pass. The then-current CFF SHA-256 was
`91e81c920d647899aa49a9621d6849ac0565d74c90cf42f7c0546e640c28057a`.
The refreshed ignored preview passes its complete checker at 5,520 HTML files,
2,951,158 links/assets, two generated JSON files, and 654,016,718 bytes with the
unchanged exact 111-advisory fingerprint. No external publication state changed
and `ShannonCert` was untouched.

On 2026-08-26, release-preparation Step 13 completed the release checkpoint and
plan-health review. A fresh complete routine suite passed the 2,605-job default
build, 3,072-job warning-as-error maintained build, five README examples, all
31 direct-import probes, the exact 601-declaration/94-`simp` full-umbrella and
92-export/480-exclusion root checks, and the 1,382-constant all-project axiom
audit. Only `propext`, `Classical.choice`, and `Quot.sound` are used. Independent
audits reproduced the 44-module/90-edge graph, five-module root, 31-module full
umbrella, certificate-free boundary, nats-first units layer, and fixed
Lean/mathlib `v4.33.1` package graph. No scope, API, or axiom plan-health trigger
fired.

The status-only Step 13 restage also passed the complete preview checker at
5,520 HTML files, 2,951,158 links/assets, two generated JSON files, and
654,016,210 bytes. The 111 imported-dependency advisories retain their exact
reviewed fingerprint; the 654,015,176-byte measurement remains the historical
Step 12 artifact record.

At the Step 13 checkpoint, the overall release verdict was amber but sound
because remote and publication evidence was absent. `origin/master` then
retained both the automatic toolchain-triggered release workflow and the old
push-triggered Pages workflow; the remote licence was `NOASSERTION`, immutable
Releases was disabled, and the Pages environment permitted only `master`. The
release sequence was amended to 18 steps. Step 15 was the separately approved
safety-only remote landing, Step 16 the release-ready metadata and exact
candidate/consumer/capacity gate, Step 17 the read-only independent dry run,
and Step 18 alone may publish. The Pages publication procedure must prove that
its workflow `head_sha` equals the immutable `v0.1.0` tag commit. Branch
protection remains beneficial but is not a `v0.1.0` blocker. The Step 15 record
above supersedes the two workflow-state facts while preserving this historical
checkpoint.

On 2026-08-26, release-preparation Step 11 locally completed the isolated,
signature-bearing documentation implementation. `doc-gen4` `v4.33.1` is pinned
at commit `e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015`; the package runtime graph is
unchanged. The hardened checker verifies 31 supported module pages, all 601
frozen declarations with rendered signatures, 92 canonical export targets, 13
non-stable exclusions, and zero equation rows. `DISABLE_EQUATIONS=1` removes
only optional equation pages and retains signatures, docstrings, attributes,
and sorry markers. The 5,521-file, 624.6-MiB local output uses file-linked
sources and is unpublished.

The first pass after cleaning the documentation build also removed shared
package build outputs in the existing working tree. It took 17,547.3 seconds
(4h52m27.3s) and is not clean-checkout or cold-reproduction evidence. The
immediate incremental run took 154.8 seconds. An earlier fully warm pair took
5.5 seconds per pass. The final post-review gate took 31.8 seconds and 11.9
seconds and reproduced digest
`fa46bbc0de9359ea1e14e79d9e3bce9ac425f33cb2e9efb54086a4e28d6730fe`.
A plan-health review moved full generation out of ordinary push/pull-request CI
into a conditional `workflow_dispatch` `api_docs` release gate with a 360-minute
maximum. Routine static pin checks remain in CI; remote runner capacity is
recorded externally against the exact candidate. The configuration stamp keys generation mode, source identity,
and equation policy, and targeted invalidation preserves compiled dependencies.

The mathematical library remains 44 modules, while the exact header scan now
covers 45 project-authored Lean files because it includes the build-only
`docbuild/CCShim.lean`. No mathematical source, 31-module/601-declaration API,
root import, or runtime manifest changed. Independent final Step 11 review is
complete after correcting the GitHub range predicate, Windows preflight order,
and Step 12 status wording; read-only re-review found no remaining issue. Step
12 subsequently completed the versioned local staging, navigation, provenance,
and served-preview work; Step 16 was assigned clean exact-commit GitHub-source
mode, remote-capacity measurement, and fresh-checkout reproduction. Publication
state is not claimed by this historical record.

On 2026-08-26, release-preparation Step 12 assembled the tracked site and the
5,521-file doc-gen tree into `.lake/website-stage/LeanInfoTheory/`, with the
supported reference at `/docs/v0.1.0/`. Preview mode removed 151,458 local
`file:` source links, repaired 5,496 generated `#top` targets, and added an
unpublishable marker plus structured provenance. Shared navigation connects the
project pages, generated reference, supplementary source inventory, and legal/
third-party pages without changing the established site design.

The complete staged checker covered 5,520 HTML files, 2,951,158 links/assets,
two generated JSON files, and 654,015,176 bytes with no project-owned or runtime
errors. It recorded 111 imported-dependency link advisories outside the
31-module LeanInfoTheory support claim and pins their complete reviewed message
fingerprint. Staging first recomputes a full-tree attestation written only after
both API-doc validation passes. Served browser checks covered the
project subpath, navigation, search, exact declaration and `find` links,
imported-by and instance population, themes, runtime assets, source-link
suppression, return routes, and the 404 page. Thirteen generated assets, four
external runtime resources, exact dependency pins, the project licence, and ten
upstream licence records are inventoried. Pages is manual-only and separates
artifact preparation from an explicit deployment input; neither mode was run
remotely, and nothing was published.

Previously on 2026-08-26, release-preparation Step 10 completed the release-facing README,
five exact compiling examples, and then-draft versioned release notes without
changing Lean source or the frozen public API. The static validator now checks
the tagged dependency and toolchain guidance, import/scope/units/limitations/
compatibility sections, the then-current publication state, all local README/release-note
links, and the exact five marked example IDs. The CI workflow and focused
`documentation` command compile each fence independently with warnings as
errors.

The complete local run passed the 2,605-job default build, the 3,072-job
warning-as-error maintained build, all five README examples, all 31
direct-import probes, the 601-declaration/94-`simp` full-umbrella audit, the
92-export/480-exclusion root audit, and the 1,382-constant all-project axiom
audit. Only `propext`, `Classical.choice`, and `Quot.sound` were reported. The
static gate also passed the 44-file source scan, package/legal/toolchain and
release-safety contracts, two non-mutating render checks for every generator,
11 HTML and two generated JSON website checks, local release-document links,
and repository hygiene. Three independent read-only reviews of the public
documentation, executable example/CI contract, and legal/release claims reran
the focused gates, reproduced the unchanged Lean-tree and public-manifest
hashes, and found no remaining Step 10 blocker. This remains local working-tree
evidence: no commit, push, tag, release, website publication, Zenodo action,
clean exact-commit release-candidate checkout, or external Lake consumer is
claimed.

Previously on 2026-08-26, release-preparation Step 9 made the package and preliminary
legal contract explicit without changing Lean source or the frozen public API.
Lake now describes LeanInfoTheory `0.1.0` as a finite discrete
information-theory library, restores the Reservoir `math` keyword, and sets
`fixedToolchain = true` for the frozen Lean/mathlib `v4.33.1` baseline. The
regenerated manifest records that flag. A second `lake update` was byte-
idempotent at SHA-256
`392f0f382a11ec1ce0e71cf39eaef062c5a6446e02520a890e68ba6987e1ace9`;
relative to the Step 8 manifest, the flag is its only semantic change.

The static validator now enforces exact package, library, dependency, manifest,
canonical Apache-2.0, sole-author CFF, README disclosure, and preliminary
pre-Zenodo metadata. At that Step 9 checkpoint all 44 then-current Lean headers
passed and the then-current CFF passed isolated `cffconvert` 2.0.0 validation.
Step 14 has since finalized institutional, contributor, third-party,
no-`NOTICE`, and automatic post-release DOI decisions. Its initial
`2026-08-27` release-date decision was superseded on 2026-08-28 by the approved
`2026-09-01` date; Step 14 remains complete while exact-SHA qualification is
repeated.

The final local run passed the 2,605-job default build, the 3,072-job maintained
warning-as-error build, all 31 direct-import probes, the 601-declaration and
94-`simp` full-umbrella audit, the 92-export/480-exclusion root audit, and the
1,382-constant all-project axiom audit. An independent read-only review passed
the metadata and static gates, Lake/Reservoir resolution, Python syntax,
canonical-licence comparison, manifest reconstruction, and CFF schema
validation. It reproduced the unchanged 44-file Lean-tree hash
`36b5f081cadcb102e8fe2508433ef7c12881c4de5ca35f20c5ddbf33b5374ace`
and public-manifest hash
`d4c5bfa78588de605798f568b312a4cef2896855e36d3c983849270181e397be`,
and reported no Step 9 blocker.

Previously, on 2026-08-26, release-preparation Step 8 established one executable local and
CI trust contract without changing Lean source or the frozen public API.
`scripts/validate_release.py` owns the maintained eight-target list, requires
the exact three reviewed workflow files, and runs
the default build, the warning-as-error maintained build, strict source and
toolchain checks, non-mutating repeated generated-artifact checks, website
validation, and repository hygiene. The two website generators now expose
non-mutating `--check` modes.

Lean environment probes import all 31 supported modules directly and compare
each exact local-module closure and reviewable declaration/owner set with the
checked module graph and public manifest. The full umbrella independently
matches all 601 declarations and all 94 recorded `simp` attributes; the
lightweight root resolves all 92 exports to their exact canonical targets and
excludes the 480 opt-in declarations. The public axiom audit permits only
`propext`, `Classical.choice`, and `Quot.sound`. A broader maintained aggregate
audit checks every compiled project constant across all 44 modules, including
private, generated, and non-stable declarations, against the same allowlist.

The final local run passed the 2,605-job default build, the 3,072-job maintained
build, all 31 direct-import probes, the exact umbrella and root audits, and the
1,382-constant all-project axiom audit. An independent read-only review
recomputed the unchanged Step 7 Lean-tree and API-manifest hashes, ran
actionlint across all three workflows, and found no remaining Step 8 blocker.

The Lean, Pages, and manual dependency-update workflows now pin every direct
action to a reviewed full commit. The Lean workflow runs the shared static,
build, trust, and hygiene gates; Pages runs the static contract before upload.
At the Step 8 checkpoint these revisions were locally validated but unpushed.
Step 15 later removed the automatic release workflow without carrying the
candidate. Step 16 was assigned the guarded workflow landing plus fresh-
checkout/external-consumer and remote nonpublishing validation. At the
Step 8 checkpoint,
Step 11 still owned signature-bearing API documentation; it has since been
implemented locally. The public manifest still does not claim to detect same-
name signature drift, and Step 11 did not add committed signature fingerprints.

Previously, on 2026-08-26, release-preparation Step 7 completed the public API freeze
without changing Lean source. The 31-module full umbrella contains 601 unique,
documented project declarations (535 theorems, 56 definitions, nine
abbreviations, and one instance), split between 557
`LeanInfoTheory.Shannon` declarations and 44 `PMF` extensions. The explicit
root façade contains 92 unique exports, and the reviewed supported simp surface
contains 94 declarations. The 31 supported and 13 non-stable modules partition
all 44 local modules; all six aggregate/façade/reference anchors own zero
declarations.

Lean resolved all 601 canonical names through `LeanInfoTheory.Shannon` and all
92 root aliases plus targets through `LeanInfoTheory`. Negative environment
probes excluded all 115 non-stable declarations from the full umbrella and all
480 opt-in supported declarations from the five-module root. The maintained
warning-as-error matrix passed with 3,072 jobs, and default `lake build` passed
with 2,605 jobs. All 601 declarations depend only on `propext`,
`Classical.choice`, and `Quot.sound`; strict placeholder and supplemental trust
scans are clean, and every one of the 44 Lean files has the exact EPFL/MIL
header.

`docs/v0.1-public-api.json` and both website generators found all five rendered
text artifacts current on two independent non-mutating passes. The manifest
`--check` mode and website checker passed, as did whitespace, conflict-marker,
JSON, and local-link checks. Three parallel read-only audits and a separate independent
final validation found no naming, assumption, attribute, helper-visibility,
namespace, export, ownership, manifest, or status blocker. The final review
also recomputed 120 private supported declarations (100 theorems and 20
definitions), all absent from the public manifest. No commit, push, tag,
release, Zenodo deposit, website publication, or `ShannonCert` access occurred.

Previously, on 2026-08-26, release-preparation Step 6 completed the nats-first
units surface. Its maintained warning-as-error matrix passed with 3,072 jobs,
default `lake build` passed with 2,605 jobs, and its focused units, example,
boundary, trust, generated-reference, website, and hygiene checks all passed.

On 2026-08-26, release-preparation Step 5 completed its local import and
declaration-ownership normalization. The new entropy semantic owner, old
semantic aggregate, full Shannon umbrella, and lightweight root passed a
3,057-job focused warning-as-error build. The updated eight-target maintained
warning-as-error matrix passed with 3,071 jobs, and default `lake build` passed
with 2,605 jobs. Four positive consumers checked the root, focused entropy
owner, compatibility aggregate, and full umbrella; eight expected-failure
consumers confirmed root/focused/umbrella isolation from heavier or non-stable
declarations.

The generated graph is acyclic and matches the exact Step 5 contract: 43
modules, 87 edges, a five-module root closure, a 31-module full-umbrella closure,
and 12 excluded non-stable anchors. All six aggregates/facades own zero indexed
declarations. The five moved declarations retain their indexed names, kinds,
documentation, signatures as checked by Lean, and standard
`propext`/`Classical.choice`/`Quot.sound` axiom set. Both generators were
byte-idempotent; the website checker passed across 11 HTML and two JSON files;
placeholder, unsafe, exact-header, conflict, scratch, whitespace, and diff
checks passed. No commit, push, tag, release, Zenodo deposit, website
publication, or `ShannonCert` access occurred.

Previously, on 2026-08-25, release-preparation Step 4 completed its local ownership
separation and validation. Ten certificate-owned modules, six semantic
valuation adapters, fifteen aggregate toy declarations, and four finite-family
certificate consumers were removed while all reusable mathematical declarations
remained upstream. The strict focused build passed for the root, finite-family
semantic owners, and semantic/example aggregates; the maintained six-target
warning-as-error matrix passed with 3,069 jobs, and default `lake build` passed
with 2,606 jobs. Representative direct-import consumers elaborated the entropy,
channel, family, Fano, KL, Markov, sufficiency, data-processing, conditional-KL,
independence, and convexity APIs, while a guarded root consumer rejected an
opt-in finite-family theorem.

Both source-derived generators were byte-idempotent and report 41 modules, 77
local edges, 6 root-reachable modules, 35 opt-in modules, and 714 declarations
(713 documented plus one explicit example-only instance). The website
checker passed across 11 HTML files and two generated JSON files. Placeholder,
unsafe, deleted-name/import, exact-header, representative axiom, conflict,
scratch, whitespace, and diff checks pass. `ShannonCert` was not accessed or
modified; no commit, push, tag, release, Zenodo deposit, or website publication
occurred. An independent final review confirmed the extraction boundary,
retained API, generated counts, documentation, and repository hygiene with no
blocker.

The remainder of this subsection preserves the preceding Step 3 and Chunk 8
validation evidence.

On 2026-08-25, release-preparation Step 3 completed the one-time Lean/mathlib
upgrade and froze the local baseline at `v4.33.1`. All nine package checkouts
match `lake-manifest.json`, and all eight inherited revisions match the pinned
mathlib manifest. A final idempotent `lake update` reported no downloads and
completed successfully. The maintained release matrix passed with 3,079 jobs:

```powershell
lake -KwarningAsError=true build LeanInfoTheory `
  LeanInfoTheory.Shannon.EntropyBounds `
  LeanInfoTheory.Shannon.Units `
  LeanInfoTheory.Shannon.SemanticBridge `
  LeanInfoTheory.MathlibFragments `
  LeanInfoTheory.Examples
```

Focused validation also rebuilt every migration owner and the complete examples
aggregate. Strict scans found no proof placeholders, project axioms, unsafe or
partial declarations, external implementation hooks, native/run tactics, or
deprecated Bernoulli remnants. The independent frozen-diff audit found no
public signature, assumption, namespace, attribute, import, or root-boundary
change. Both source-derived generators were byte-idempotent on a second pass,
and the website checker passed across 12 HTML and two generated JSON files.
The architecture remains 51 modules, 100 local edges, 11 root-reachable
modules, and 40 separate-import modules. The declaration index now contains
881 entries because the existing example-only instance
`ThreePoint.instFintype` is written explicitly for Lean 4.33 compatibility and
is therefore visible to the source parser; its qualified name, type, instance
status, and opt-in ownership are unchanged.

The subsequent legal-metadata checkpoint retained all theorem bodies and
imports while replacing or adding the exact EPFL/MIL notice on all 51 tracked
Lean files. The official CFF validator `cffconvert` 2.0.0 accepted
`CITATION.cff` against schema 1.2.0, the root licence matches the canonical
Apache-2.0 text after newline normalization, and the source-derived generators
were byte-idempotent on a second pass. The exact-header scan passed 51/51 files,
the website checker again passed 12 HTML and two generated JSON files, and the
strict maintained release matrix again completed successfully with 3,079 jobs.
The `weak.linter.style.header = false` package option is limited to the
incompatible mathlib header-style check; all other strict build warnings remain
errors.

This is a validated but uncommitted pre-separation working tree based on
documentation-only `HEAD` `32b2aec`. It does not advance the last fully
validated committed Lean/source baseline or permit a push while the Step 2
remote release-workflow interlock remains unresolved.

On 2026-07-31, `C8.24` independently completed Chunk 8 validation. The
nine-target direct-owner/downstream build passed with 2,783 jobs, the
maintained ten-target suite passed with 2,792 jobs, and default `lake build`
passed with 2,240 jobs:

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily `
  LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL `
  LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence `
  LeanInfoTheory.Shannon.SemanticBridge `
  LeanInfoTheory.Certificate.FiniteFamily `
  LeanInfoTheory.Examples.ConditionalKL `
  LeanInfoTheory.Examples.FiniteFamily `
  LeanInfoTheory.Examples `
  LeanInfoTheory

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

lake build
```

Direct and aggregate consumers exercised all 18 new declarations and the
existing concrete entropy-valuation/certificate path. Exact environment checks
confirmed root, intermediate-owner, certificate, and private-helper isolation.
All 15 new public theorems reported only `propext`, `Classical.choice`, and
`Quot.sound`. The strict placeholder scan, twice-idempotent generators,
website checker, exact declaration/module/source/anchor audit, and repository
hygiene pass. The generated state is 51 modules, 100 local edges, 11 root-
reachable modules, 40 opt-in modules, and 880 documented source declarations.
The pass used the incremental cache. At the time of C8.24 this was an
independently validated but uncommitted working tree. On 2026-08-20 the exact
validated source became checkpoint `1eef228`; its required remote build and
deployment workflows both succeeded.

On 2026-07-31, `C8.21` completed focused integration for the frozen Chunk 8
source. One combined build of the nine approved direct and downstream targets
passed with 2,783 jobs:

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily `
  LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL `
  LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence `
  LeanInfoTheory.Shannon.SemanticBridge `
  LeanInfoTheory.Certificate.FiniteFamily `
  LeanInfoTheory.Examples.ConditionalKL `
  LeanInfoTheory.Examples.FiniteFamily `
  LeanInfoTheory.Examples `
  LeanInfoTheory
```

Direct and aggregate consumers exercised all 18 new public declarations and
the existing finite-family certificate adapter. Exact guarded consumers
confirmed the root, intermediate-owner, certificate, and private-helper
boundaries. The preliminary audit of all 15 new public theorems reported only
`propext`, `Classical.choice`, and `Quot.sound`. The strict placeholder,
conflict-marker, scratch, tracked-reference, whitespace, and diff checks pass.
A post-step consumer completed Future Work Note 17's exact intermediate import
matrix, and the affected semantic/certificate rebuild passed with 2,764 jobs.
At that step this was focused working-tree evidence only; `C8.23` and `C8.24`
subsequently completed generated/public reconciliation and independent final
validation.

On 2026-07-29, `C7.22` independently completed Chunk 7 validation. The direct
owner/example build passed with 2,704 jobs:

```powershell
lake build LeanInfoTheory.Probability.Finite `
  LeanInfoTheory.Probability.FiniteMixture `
  LeanInfoTheory.Shannon.LogSum `
  LeanInfoTheory.Shannon.EntropyConcavity `
  LeanInfoTheory.Shannon.SemanticBridge.Convexity `
  LeanInfoTheory.Examples.Convexity
```

The complete maintained ten-target milestone suite passed with 2,789 jobs.
Direct owner and aggregate consumers exercised all 28 new public declarations;
guarded root and private-helper consumers confirmed the intended boundaries.
All 26 new theorems reported only `propext`, `Classical.choice`, and
`Quot.sound`. The strict placeholder scan, exact declaration/source/anchor and
simp/import audits, twice-repeated byte-stable generators, website checker,
conflict-marker and disposable-probe scans, and final diff/hygiene checks all
pass. The generated references contain 48 modules, 90 local edges, 11
root-reachable modules, 37 opt-in modules, and 862 documented source
declarations. This is the validation evidence preserved by source checkpoint
`5e616d8`; it does not establish remote build or deployment status.

On 2026-07-28, `C6.24` independently completed Chunk 6 validation. The six-
target focused build passed with 2,770 jobs:

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily `
  LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily `
  LeanInfoTheory.Certificate.FiniteFamily `
  LeanInfoTheory.Examples.FiniteFamily `
  LeanInfoTheory.Shannon.SemanticBridge `
  LeanInfoTheory.Examples
```

The maintained ten-target suite passed with 2,783 jobs, and default
`lake build` passed with 2,240 jobs. Positive direct-import consumers exercised
the lightweight core, semantic aggregate, certificate adapter, and examples
aggregate over infinite and empty index types, dependent heterogeneous
alphabets, empty/singleton/overlapping atoms, duplicate list entries,
arbitrary sources, concrete entropy valuation, and checked/raw certificate
paths. Six guarded negative consumers confirmed root and intermediate
aggregate isolation, private chain-helper visibility, and the absence of a
global example `Fintype` instance.

The strict placeholder scan was clean. A mechanical audit of all 89 new public
theorems reported only `propext`, `Classical.choice`, and `Quot.sound`. Both
generators were byte-idempotent; semantic checks confirmed 43 modules, 75 local
edges, 11 root-reachable modules, 32 opt-in modules, and 834 documented
declarations; and the website checker passed for 12 HTML files and two JSON
files. Root, imports, tracked textbooks, scratch files, generated artifacts,
whitespace, and the complete diff passed the final hygiene review. The pass
used the existing incremental cache rather than a cold release build.

On 2026-07-27, `C6.01` compiled an ignored disposable contract spike with
`lake env lean` and then deleted it. The check elaborated the approved
dependent-family representation for infinite and empty index types,
heterogeneous pointwise-finite alphabets, finite restrictions, repeated list
indices, and the exact `ShannonEntropyVal` field shapes. It changed no
production Lean source and therefore is feasibility evidence, not a new broad
milestone build.

On 2026-07-25, C5.20 passed the focused builds for
`Shannon.BinaryEntropy` (2,233 jobs), `Shannon.Fano` (2,702 jobs),
`Examples.Fano` (2,703 jobs), `Examples` (2,764 jobs), and the lightweight
root (2,240 jobs). The complete ten-target milestone suite passed with 2,779
jobs, and the default `lake build` passed with 2,240 jobs.

Disposable positive consumers exercised all 31 Chunk 5 declarations. Guarded
negative consumers confirmed the BinaryEntropy/Fano, Fano/examples,
private-helper, and lightweight-root boundaries. Axiom output for all 31
declarations contained only `propext`, `Classical.choice`, and `Quot.sound`.
The strict project-source placeholder scan was clean. All temporary consumers
were deleted.

Both generators were run again and reproduced all four artifact hashes byte
for byte. The website checker passed for 12 HTML files and two generated JSON
files. Final source, import, diff, temporary-file, process, textbook-file, and
whitespace hygiene checks found no unexplained artifact.

On 2026-07-25, C5.19 regenerated both source-derived reference sets twice with
byte-identical results. The website checker passed for 12 HTML files and two
generated JSON files, and the scoped diff-hygiene check passed.

On 2026-07-24, the `C5.18` documentation-only source rebuild completed
successfully with 2,764 jobs:

```powershell
lake build LeanInfoTheory.Shannon.Fano `
  LeanInfoTheory.Examples.Fano `
  LeanInfoTheory.Examples
```

The preceding `C5.17` API-freeze build completed successfully with 2,768 jobs:

```powershell
lake build LeanInfoTheory.Shannon.BinaryEntropy `
  LeanInfoTheory.Shannon.Fano `
  LeanInfoTheory.Examples.Fano `
  LeanInfoTheory.Examples `
  LeanInfoTheory
```

The current complete ten-target milestone suite was run on the final Chunk 5
working tree and completed with 2,779 jobs:

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

### Focused build policy

During theorem work, build the touched module and its important downstream
aggregate. Before a milestone, run the current maintained suite in `AGENTS.md`.
The command blocks immediately above are historical Chunk 5--8 evidence and
include pre-Step-4 modules that no longer belong to LeanInfoTheory.

### CI expectations and remote state

`.github/workflows/lean_action_ci.yml`:

1. uses read-only repository permissions, concurrency cancellation, a bounded
   job timeout, and immutable full-commit references for direct actions;
2. runs `python scripts/validate_release.py static`, which checks source trust,
   exact package and preliminary legal metadata, the frozen toolchain/manifest
   relation, the automatic-release interlock, all five generated artifacts
   twice without modifying them, website links and JSON, and repository
   hygiene;
3. invokes the pinned `lean-action` commit for an explicit warning-as-error
   default build and mathlib cache setup;
4. invokes the shared maintained eight-target warning-as-error build;
5. runs fresh retained compatibility and complete current API/import/simp/root-
   export checks, with public and all-project-constant axiom audits (currently
   603 supported declarations; the retained baseline remains 601); and
6. finishes with the shared hygiene gate.

The Pages workflow uses the same non-mutating static contract before uploading
`home_page`, and all direct actions in the Lean, Pages, and manual dependency-
update workflows are pinned to reviewed commits. These are local workflow
definitions only until an approved push produces an exact-SHA remote run.

The GitHub Actions run for validated source baseline `217e35c` completed on
2026-07-23:

- build and placeholder check:
  `https://github.com/serhatemrecoban/LeanInfoTheory/actions/runs/30012026501`;
- website deployment:
  `https://github.com/serhatemrecoban/LeanInfoTheory/actions/runs/30012026200`.

The July 26 post-checkpoint handoff adds `Shannon.Units` to that explicit
workflow list. The final cleanup requires a successful remote workflow run
after push; that operational result does not redefine the validated Lean/source
baseline.

The remote handoff gate for `0324ee6` completed on 2026-07-30:

- build and placeholder check:
  `https://github.com/serhatemrecoban/LeanInfoTheory/actions/runs/30546320537`;
- website deployment:
  `https://github.com/serhatemrecoban/LeanInfoTheory/actions/runs/30546320388`.

Both runs succeeded. This fresh-checkout evidence agrees with the local
Chunk 7 milestone evidence without redefining source checkpoint `5e616d8`.

The remote Chunk 8 source-checkpoint gate for `1eef228` completed on
2026-08-20:

- build and placeholder check:
  `https://github.com/serhatemrecoban/LeanInfoTheory/actions/runs/32380332070`;
- website deployment:
  `https://github.com/serhatemrecoban/LeanInfoTheory/actions/runs/32380332151`.

Both runs succeeded for the exact source checkpoint. The following
documentation-only reconciliation records that remote state without changing
the validated Lean/source baseline.

### C9.01 local tooling validation

At C9.01, the source and dependency identities of the then-unchanged mathematical
library matched the release. Two exports after the isolated release's own warning-as-error build
and one export after a fresh current build agree byte-for-byte on all 601 retained
types. Three real compiling source mutations preserve names while changing a
premise, binder name or binder implicitness; each changes exactly the intended
type. Restoring the source and rebuilding reproduces the original export.
See [the compatibility evidence](compatibility/README.md) and
[step notes](plans/post-release-chunk-09-notes.md) for commands, exact identities,
original-evidence locations and failure disclosures. Current/frozen generation
checks and exporter tests are focused C9.01 checks. They do not replace C9.04's
cumulative qualification or C9.07's clean-checkpoint/full-suite/API-doc duties.

### C9.02 standalone compatibility

```powershell
python -B scripts/validate_release.py compatibility
python -B scripts/compatibility/test_current_policy.py
python -B scripts/compatibility/test_public_api_compatibility.py
python -B scripts/compatibility/run_compatibility_fixtures.py
```

The standalone command derives source inventory and runs its own current build
before retained signatures and compiled import/alias/attribute checks. It
preserves source hashes and original outputs in `.lake/compatibility/`; the real
fixture runner uses an owned ignored source copy. Consult the
[compatibility guide](compatibility/README.md) for strictness, policy records and
the same-type semantic limitation. The Python suites distinguish synthetic and
mocked checks from actual Lean evidence. Qualification and review status is in
the [C9.02 handoff](plans/post-release-chunk-09-notes.md#c902-implementation-and-prepared-handoff-2026-09-12).
C9.03 completed default/trust/API-doc integration. C9.04's completed combined
qualification is recorded in its dated [qualification table](compatibility/c9-04-qualification.md)
and [handoff](plans/post-release-chunk-09-notes.md#c904-qualification-and-prepared-handoff-2026-09-12).
Dated C9.06 theorem/consumer evidence is recorded separately in the
[step handoff](plans/post-release-chunk-09-notes.md#c906-information-decomposition-and-prepared-handoff-2026-09-12); the dated C9.05 evidence remains historical.

### C9.07 completed prerequisite and C10 validation

C9.07's actual private completion record establishes its cumulative qualification
and closure. Its [maintained handoff](handoffs/chunk-9.md) preserves the historical
source and review references. C10.01 passed its required focused builds, static
gate, compiled compatibility and independent review, and is privately closed.
C10.02 also passed focused/static checks and independent strict owner/consumer
review, and is privately closed. C10.03 passed focused/static validation and
independent strict owner/consumer and conversion-guard review, and is privately
closed. C10.04 passed focused/static validation and independent strict checks of
the complete owner, consumer, four signatures and all 21 theorem axiom sets; its
clean report was reconciled and the step privately closed. C10.05 passed its
focused/static and compiled-compatibility checks, with explicit applicability
after private consumer refinements, and independent processing review; its
clean report was reconciled and the step privately closed. C10.06 passed current
focused, generated/static, full trust (including fresh compiled compatibility)
and release-documentation checks, plus independent integrated-consumer/API
review. All four criteria were satisfied, the empty findings were explicitly
reconciled, and exact final-source closure was recorded privately.
C10.07's initial authorized clean-candidate suite and real two-pass current
file-mode API documentation passed. A fresh full-chunk independent review
assessed all 19 approved criteria and its original report was explicitly reconciled.
The [handoff](handoffs/chunk-10.md) identifies evidence and its applicability boundaries.
Final amended-candidate validation, exact API-doc/review applicability and
completion are established by C10.07's source-bound private records. This
maintained chronology does not itself certify closure; prior success does not
validate subsequent changes. No C9 requalification or validator redesign is implied.

### C11.06 cumulative validation boundary

C11.01--C11.05 and their reviews are complete for their captured source. The
selected C11.06 candidate retains their Lean/public API and adds cumulative
qualification and maintained context. The explicitly authorized initial checkpoint
`2147dd3449af620f41d9bed8d37c5be8252f20e8` passed the complete clean routine
suite, including compatibility, exact imports/root/attributes, all-project trust,
examples, generated references, website and hygiene. Its real two-pass current
API-doc gate and actual inspection expose the Coupling owner and all ten public
declarations with exact source/configuration attestation. The
[handoff evidence](handoffs/chunk-11.md#c1106-initial-evidence-and-applicability)
identifies the original results. Amendments require renewed complete routine
validation and exact API-doc applicability.

A fresh bound full-chunk review must assess all 17 approved criteria, including
the complete edge matrix, both private consumers, earlier-report reconciliation
and handoff readiness. Preserve and reconcile every original finding and criterion
assessment, including a clean report. Correct material issues and obtain renewed
review for material changes or criterion gaps. After every authorized amendment,
repeat the full routine suite; reuse API-doc evidence only when its exact inputs
and attestation remain applicable, otherwise repeat both real passes. Establish
R-to-F applicability, finish captured documents, prepare exact F and complete the
supported private closure. A favorable earlier or cumulative report alone does
not complete C11.06.

The [maintained handoff](handoffs/chunk-11.md) and
[implementation notes](plans/post-release-chunk-11-notes.md) preserve actual prior
evidence, source decisions, original failures, dependency-identity supplements
and the C10 new-module HTML-cache observation. Consult the C11.06 source-bound
private records for actual cumulative results and exact completion status.
No later chunk, push, publication or current-doc staging into the frozen release
route is authorized by this closeout request.

### Generated documentation and website checks

Use:

```powershell
python scripts/generate_v0_1_public_api.py --check
python scripts/generate_current_public_api.py --check
python scripts/generate_website_blueprint.py --check
python scripts/generate_website_api_index.py --check
python scripts/validate_release.py static
```

The separate, potentially multi-hour signature-documentation gate is:

```powershell
python scripts/validate_release.py api-docs
```

Run it for an explicitly selected API-documentation milestone, including C14.04,
or the approved manual release gate, not as an ordinary push/pull-request check.
C14.04 requires a real two-pass current file-mode result on its exact
candidate; set the pinned Windows `LEANINFOTHEORY_ZIG` prerequisite. The static command above
checks the immutable documentation-tool pins and configuration without
regenerating the API-doc output.

The historical pre-release-Step-4 generated artifacts recorded the then-current
Chunk 8 surface (these are not the current files):

- 51 modules and 100 local import edges;
- 11 root-reachable and 40 separately importable modules;
- 880 public source declarations and 0 undocumented declarations.

`C6.23` corrected nested ordinary block-comment handling, so prose in
`Certificate.FiniteFamily` no longer creates a false declaration candidate.
`C7.21` retained that parser fix while adding curated Chunk 7 module metadata.
`C8.23` added the three Chunk 8 owners, corrected same-line leading attribute
recognition, and regenerated both reference sets. `C8.24` reproduced all four
artifacts byte-for-byte on the second pass and rechecked counts, source links,
unique anchors, module summaries, aggregate imports, root reachability, private
helper exclusion, and website consistency.

Steps 4--7 froze the historical release surface. The generated cumulative C12 totals
were 55 modules, 117 local edges, 5 root-reachable modules, 50 separate-import
modules and 757 declarations (756 documented). That supported surface contained
34 modules, 642 documented declarations, 94 reviewed simp declarations and
92 facade exports. The frozen release retains 601 declarations.
The source index is distinct from signature-bearing doc-gen. C10's completed
routine/API-doc checks and reconciled cumulative review remain evidence for
their captured source, not current documentation of the current Pinsker owner.
C11.01--C11.05 completion records preserve their focused/static/documentation/trust
evidence. C11.06's initial clean routine suite and real two-pass current API-doc
gate passed on the authorized checkpoint. The [C11 handoff](handoffs/chunk-11.md)
preserves original results; source-bound private records establish applicability
to amendments, fresh all-17-criterion review, reconciliation and exact completion.
C12.01--C12.03 have completed source-bound reviews and validation records.
The C12.03 full trust audit covered 55 modules and 1,746 local constants, using
only `propext`, `Classical.choice` and `Quot.sound`. C12.04's corrected
focused/static checks and actual current two-pass API docs with declaration
inspection passed. The authorized initial checkpoint `44d300c` also passed the
complete routine suite in the separate clean validation checkout. Final amended
candidate validation, exact documentation applicability and the fresh cumulative
review are preserved by the source-bound completion records at `492cd6e`. Its [handoff](handoffs/chunk-12.md)
distinguishes prior and current evidence and records the warning-enforcement audit.
Deployment status is checked from the Pages workflow after push rather than
inferred from local content. The public site is:
`https://serhatemrecoban.github.io/LeanInfoTheory/`.

### Placeholder and trust restrictions

- No `sorry`, `admit`, unapproved `axiom`, `opaque`, or `undefined` in project
  Lean source.
- No unsafe or partial declaration, external implementation hook,
  native-decision shortcut, or run tactic in project Lean source.
- Every compiled project constant may depend only on `propext`,
  `Classical.choice`, and `Quot.sound`.
- No certificate parser, checker, DSL, or solver is part of LeanInfoTheory.
- Successful compilation does not by itself prove an API is appropriately
  scoped; module, support, null-fiber, and equality contracts still require
  review.

## 17. Guidance for Different Assistant Roles

### General Assistant

1. Read Sections 0-4, 8, 11-14, and 16.
2. Check current Git status, `origin/master`, current CI, and any new project
   log entries.
3. Perform periodic cross-thread reconciliation after chunks or architectural
   checkpoints without treating this role as exclusive ownership or a
   prerequisite for other project threads' materially justified edits.
4. Keep future-work status separate from immediate work.
5. Do not silently rewrite history or promote an uncertain plan.

### Chunk implementation assistant

1. Read `AGENTS.md`, Sections 0, 3, 6, 7, 9, 11, 12, and 16.
2. Read the owning source modules and direct imports before editing.
3. Read the exact textbook theorem family for the active step.
4. Use temporary proof spikes to validate difficult contracts, then delete
   them.
5. Run focused builds, audit new names under Note 14, update the log as
   requested, and run the full suite at the milestone.

### Proof-review assistant

1. Treat current source and the compiled theorem statement as primary.
2. Check support, `ENNReal.top`, null fibers, coordinate orientation,
   `Fintype` versus `Finite`, and local measurable assumptions.
3. Check whether private helper promotion or a new alias is truly justified.
4. Verify downstream consumers and missing edge-case tests.
5. Report findings before summaries, with file and line references.

### Documentation assistant

1. Read Sections 0, 1, 4-8, 11, and 16.
2. Use the generated declaration index for current names and paths.
3. Distinguish proved, reused from mathlib, demonstrated by an example,
   generated, planned, and speculative work.
4. Do not call the current dependency map theorem-level leanblueprint or the
   API index full doc-gen.
5. Regenerate and check website artifacts after public Lean import or
   declaration changes.

### Mathematical brainstorming assistant

1. Read Sections 2, 3, 6, 9-13, and 15.
2. Separate mathematical desirability from current Lean feasibility and
   module ownership.
3. Identify which current declarations a proposal reuses.
4. State edge cases and likely support/finiteness assumptions.
5. Mark alternatives as proposals until the project lead approves a plan.

## 18. Pointers to Detailed Historical Records

### Maintained documents

- [README](../README.md): public project status and module overview.
- [Agent instructions](../AGENTS.md): operational and naming rules.
- [Current Lean state](current-lean-state.md): detailed completed chunk and
  theorem status.
- [Project log](project-log.md): chronological implementation record and all
  40 numbered Future Work Notes.
- [Foundation conventions](foundation-conventions.md): stable mathematical and
  import conventions.
- [Roadmap](roadmap.md): public near-, medium-, and long-term milestones.
- [Downstream API feedback](downstream-api-feedback.md): canonical intake and
  triage for deduplicated post-release discoverability evidence.
- [Chunk 9 handoff](handoffs/chunk-9.md): delivered growth gates/helpers, exact
  evidence references, cumulative closeout requirements and remaining-work triggers.
- [Chunk 11 handoff](handoffs/chunk-11.md): ten public coupling declarations,
  private consumers, prior evidence and limits, pending cumulative closeout, and
  C12/C14 prerequisites and remaining-work owners.
- [Chunk 14 handoff](handoffs/chunk-14.md): six continuity declarations, private
  mathematical consumers, completed Step 1--3 evidence, pending C14.04 cumulative
  qualification and remaining-work owners/triggers.
- [Chunk 5 plan](plans/chapter2-chunk-05.md): approved step contracts and
  implementation outcomes for the completed finite-Fano phase.
- [Chunk 6 plan](plans/chapter2-chunk-06.md): approved finite-family,
  concrete-valuation, and checked-certificate implementation sequence.
- [Chunk 7 plan](plans/chapter2-chunk-07.md): completed finite log-sum,
  mixture, entropy/KL convexity, and mutual-information implementation
  sequence with checkpoint evidence.
- [Chunk 8 plan](plans/chapter2-chunk-08.md): approved finite conditional-KL,
  conditional-family CMI, and mutual-independence implementation sequence;
  complete through `C8.24` and checkpointed as `1eef228`.
- [Semantic bridge design](semantic-bridge-design.md): original bridge design
  and conditional-law choices.
- [Semantic bridge API audit](semantic-bridge-api-audit.md): audited mathlib
  and local helper boundaries.
- [Blueprint overview](../blueprint/README.md): current generated-documentation
  scope and long-term blueprint layers.

### Generated references

- [Declaration index](../home_page/docs/declaration_index.json)
- [Module graph](../home_page/blueprint/module_graph.json)
- [Hand-written module guide](../home_page/module-guide.html)

### Phase checkpoints

- Pre-roadmap transition: `7855d0d`
- Chunk 1: `7ab3aa0`
- Chunk 2: `e5e9825`
- Chunk 3: `a5cc9e9`
- Chunk 4: `f990f2e`
- Chunk 5 handoff cleanup: `11e071c`
- Shared canonical-memory policy: `2413cb1`
- Chunk 5 implementation and validated Lean/source baseline: `ec78829`
- Chunk 6 implementation and validated Lean/source baseline: `7b5f0db`
- Chunk 7 implementation and validated Lean/source baseline: `5e616d8`
- Chunk 8 implementation and validated Lean/source baseline: `1eef228`

### Temporary historical inputs

The ignored reports
`tmp/codex-handoffs/pre-roadmap-inherited-context.md` and
`tmp/codex-handoffs/chunks-1-4-inherited-context.md` were reconciliation
inputs for this document. They are not canonical, may be deleted, and must
never override current source or maintained documentation.
