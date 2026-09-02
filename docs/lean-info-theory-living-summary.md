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
exact-SHA Lean build/placeholder and Pages deployment workflows both pass. No
later theorem phase has been selected.

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
9. For Lean changes, run focused builds while iterating and the maintained
   milestone suite before a checkpoint.

**Source order.** Read current source first, then current checked-in plans and
documentation, then the exact relevant textbook statements, then history and
temporary handoffs. See Section 4 for the conflict protocol.

**What to read next by task type.**

| Task | Read next |
| --- | --- |
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
| Last updated | 2026-09-02 |
| Last fully validated mathematical checkpoint | Chunk 8 source commit `1eef2289c3475ff978569f285329bdc78e060594`; the released `v0.1.0` source is exact commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f` |
| Repository transition state | `v0.1.0` is published from immutable tag object `bcd9090ea2720fe14b0a3e168c76ebeef1dafd47` and archived as Zenodo record `22229599`. The evolving default branch carries the current project pages and DOI metadata, while maintenance staging preserves `/docs/v0.1.0/` from exact release commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`; the tag, Release, archive, Lean source, and public API remain unchanged |
| Lean baseline | `v0.1.0` uses Lean `v4.33.1`, commit `819816b2e0a3bf405af45ae5c7af2491d8f5bee6` |
| mathlib baseline | `v0.1.0` uses input revision `v4.33.1`, manifest commit `0df444a360eaa60ab8c11dca51a86af692955474` |
| Source-snapshot phase | Post-release `v0.1.x` maintenance; publication date `2026-09-01`; version DOI `10.5281/zenodo.22229599`; Project B Chunks 1–8 remain checkpointed; no later theorem phase is selected |
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
- finite-PMF total-variation and maximal-coupling infrastructure, a Pinsker
  family, or finite-simplex topology and continuity theory;
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

### Finite Shannon layer

**[Current]** Implemented over finite PMFs and finite-valued pushforwards:

- entropy, random-variable entropy, and joint entropy;
- entropy nonnegativity and exact zero-entropy characterizations;
- invariance under equivalences, injective relabelings, swaps, and product
  reassociation;
- pair and triple marginals with pointwise mass and support infrastructure;
- algebraic conditional entropy, mutual information, and conditional mutual
  information;
- pair/triple chain rules, symmetry, self-information identities, and standard
  entropy-difference forms;
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
  `ProbabilityTheory.IndepFun`;
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
| **2.7 Log-sum and convexity applications** | **Implemented, independently validated, and checkpointed for finite PMFs in Chunk 7.** The scalar, mixture, entropy, KL, and MI theorem layers are complete through `C7.22` in checkpoint `5e616d8`. | `logSum_inequality`, `logSum_eq_iff_exists_constant_ratio`, `real_logSum_inequality_of_support`, `sum_mul_entropy_le_entropy_bind`, `binaryMixture_entropy_eq_iff`, `klDiv_bind_le_sum`, `klDiv_binaryMixture_eq_iff`, `sum_mul_mutualInfo_channelJoint_le`, `mutualInfo_channelMixture_le_sum` | Scalar `Shannon.LogSum`; PMF construction in `Probability.FiniteMixture`; Jensen entropy layer in `Shannon.EntropyConcavity`; KL/MI results in heavy `SemanticBridge.Convexity`. All remain opt-in. | Canonical KL statements are `ENNReal`-valued; Real forms have active support guards. General-selector equality classifications, MI/channel equality cases, finite-family wrappers, topology, and continuity remain deferred. |
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
| `LeanInfoTheory.Shannon.Entropy` | Entropy, entropy of pushforwards, joint entropy, zero and relabeling facts | Yes, through `InformationMeasures` |
| `LeanInfoTheory.Shannon.InfoMeasures` | Marginals, conditional entropy, MI, CMI, random-variable forms, core rewrites | Yes, through `InformationMeasures` |
| `LeanInfoTheory.InformationMeasures` | Explicit convenience re-export from `Shannon` into `LeanInfoTheory` | Yes |
| `LeanInfoTheory` | Lightweight public aggregate only | Root |
| `LeanInfoTheory.Shannon` | Import-only complete supported mathematical umbrella | No; subsumes the root |

After Step 7, the verified source-derived inventory contains 44 modules, 90
local import edges, 5 root-reachable modules, 39 separate-import modules, and
716 declarations (715 documented plus one explicit example-only instance).
The root directly imports exactly `Probability.Finite` and
`InformationMeasures`; its closure has five modules. It does not import bounds, units,
finite-family or mixture modules, log-sum/concavity modules, semantic bridges,
channel modules, examples, or mathlib coding anchors.

The `LeanInfoTheory.Shannon` umbrella directly imports the root, `Shannon.Fano`,
`Shannon.SemanticBridge`, and `Shannon.Units`. Its 31-module closure contains
the complete supported mathematical stack and excludes the 13 non-stable
`Basic`, example, and `MathlibFragments` anchors. The new non-stable
`Examples.Units` consumer does not change that closure.

The exact supported closure contains 601 documented project-owned public
declarations: 535 theorems, 56 definitions, nine abbreviations, and one named
instance. `InformationMeasures` preserves 92 explicit root convenience exports,
and 94 supported declarations carry reviewed `simp` attributes. See the
[`v0.1.x` public API contract](v0.1-public-api.md) and deterministic
[`v0.1-public-api.json`](v0.1-public-api.json) manifest.

### Opt-in finite and semantic layers

| Module | Responsibility |
| --- | --- |
| `LeanInfoTheory.Shannon.EntropyBounds` | Jensen-based alphabet/support bounds and exact uniform equality |
| `LeanInfoTheory.Shannon.Units` | Scalar conversion from canonical nats to arbitrary valid logarithm bases and bits |
| `LeanInfoTheory.Shannon.BinaryEntropy` | Boolean-PMF entropy bridge to mathlib `Real.binEntropy` |
| `LeanInfoTheory.Shannon.Fano` | Type-generic decoding error and finite exact/weak Fano inequalities and corollaries |
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
| `LeanInfoTheory.Shannon.SemanticBridge.Independence` | Ordinary/conditional independence and equality characterizations |
| `LeanInfoTheory.Shannon.SemanticBridge.Markov` | Markov predicates, total conditional channel, factorization, MI DPI |
| `LeanInfoTheory.Shannon.SemanticBridge.Sufficiency` | Fixed-prior and family sufficiency core, directly importing `Markov` |
| `LeanInfoTheory.Shannon.SemanticBridge.DataProcessing` | PMF-kernel bridge, posterior KL decomposition, KL DPI, entropy growth |
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
- The exact supported names, owners, kinds, reviewed attributes, module paths,
  and 92 root exports are frozen in
  [`v0.1-public-api.json`](v0.1-public-api.json).

### Generated documentation and website pipeline

The scripts:

```text
scripts/validate_release.py
scripts/check_api_docs.py
scripts/generate_website_blueprint.py
scripts/generate_website_api_index.py
scripts/generate_v0_1_public_api.py
scripts/check_website.py
```

provide the canonical release gate and produce or validate:

- a module-level graph derived from local import lines;
- a source-derived public declaration index;
- HTML views of those artifacts;
- internal website links and JSON structure.

The isolated `docbuild/` environment additionally pins `doc-gen4` `v4.33.1` at
commit `e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015` without adding documentation
tooling to the downstream runtime graph. Step 11's checker requires exactly 31
supported module pages and 601 declarations with rendered signatures, 92
canonical export targets, 13 non-stable exclusions, and zero equation rows in
the approved `DISABLE_EQUATIONS=1` mode. Disabling equations omits only optional
equation pages; signatures, docstrings, attributes, and sorry markers remain.
No signature-fingerprint file is committed. The public manifest and canonical
targets jointly record the 92 root aliases.

The validated local file-linked output is unpublished and contains 5,521 files
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
- Finite-simplex topology and continuity; global KL likely needs a
  lower-semicontinuity or support-stratified treatment rather than an
  unqualified continuity theorem.
- Pinsker-type divergence comparisons.
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

- No theorem-level blueprint pipeline. Full doc-gen is a manual release gate;
  remote capacity and exact-commit GitHub-source reproduction are external
  candidate-validation evidence.

Certificate search, coefficient solving, primitive autotagging, and external
certificate parsers are downstream application work, not LeanInfoTheory gaps.

## 12. Active Work

### `v0.1.0` release and maintenance status

**This revision contains the post-release DOI metadata and durable website
composition boundary for the published `v0.1.0` library.** The immutable release
source remains exact commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`;
this default-branch update changes no Lean source or frozen public surface.
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
pushed, remotely build-validated, and deployed. No later theorem phase has
been selected.**

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

The next review should choose scope rather than infer it from roadmap order.
Deferred Future Work remains governed by its recorded pressure triggers rather
than becoming automatic post-chunk work.

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

### Later Chapter 2 and finite-foundation work

| Note | Work |
| --- | --- |
| 38 | **Partially discharged later milestone.** Permanent stochastic examples exercise the PMF-facing results; add a matrix bridge only when majorization/Birkhoff consumers exist. |
| 39 | Plan canonical/minimal sufficiency, support-aware statistic comparison, and later iid/count-statistic or measurable extensions. |
| Unnumbered | Chunk 7 now owns finite log-sum, KL convexity, entropy concavity, and MI input/channel convexity. Assign Pinsker, tensorization, topology, continuity, and any broader equality/generalization layer to later focused phases before implementation. |

The finite-family phase is complete, independently validated, and checkpointed
as `7b5f0db`. Chunk 8 now closes the approved finite conditional-CMI,
conditional-KL chain-rule, and mutual-independence equality gaps without
adding topology or continuity. Topology, continuity, Pinsker, tensorization,
global indexed-family independence, and broader conditional-KL variants remain
separate future phases governed by their recorded pressure and approval rules.

### Broader information-theory work

| Note | Work |
| --- | --- |
| 5 | Add Kraft-McMillan and other coding material in a later coding layer. |

The completed finite-Fano theorem layer excludes channel powers, stationary
processes, entropy rates, capacity, AEP, typicality, method of types,
source/channel coding, and nontrivial network converses. These remain later
roadmap work rather than hidden parts of Chunks 5-8.

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
| 25 | Add ordinary-independence conveniences only for concrete downstream proofs. |
| 27 | Add conditional-independence symmetry, closure, or representation conveniences only at their recorded consumer triggers. |

### Other proof-pressure-deferred API work

| Note | Triggered question |
| --- | --- |
| 19 | Promote the private deterministic-entropy decomposition only after a genuine second consumer. |
| 22 | Add a general real-KL zero iff under explicit `klDiv != top` only after repeated branch-elimination proofs. |
| 23 | Generalize uniform-reference KL to infinite ambient alphabets only when finite-support consumers need it. |
| 24 | Extract strict-Jensen equality infrastructure only after another extremization proof repeats it. |
| 30 | **Partially discharged.** `PMF.channelJoint_eq_iff_eq_on_support` was promoted; broader weighted null-fiber laws or opposite reconstruction orientation still require repeated use. |
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
| 9 | Stage and maintain the local signature-bearing API docs; later add theorem-level leanblueprint data, a blueprint PDF, and optional equation-expanded pages if justified. Also consider a structured source for repeated status fragments and complete verified module-summary metadata. |
| 10 | Add `CONTRIBUTING.md`, beginner tasks, issue labels, and upstream guidance before broad contributor outreach. |
| 28 | Later improve opt-in example pedagogy: the side-information recovery example, `KLTop` absolute-continuity notation, and, only if compact, matched numerical Boolean examples exhibiting strict MI input concavity and channel convexity. Preserve existing declarations and avoid new core helpers solely for pedagogy. |

Routine website redesign is not current work. Existing pages should be kept
accurate and regenerated after public Lean declarations or imports change.
C5.19 completed the Chunk 5 refresh; `C6.23` completed the Chunk 6 refresh;
`C7.21` completed the corresponding Chunk 7 refresh without redesigning the
site.

### Speculative research directions

- topology and continuity of finite PMFs and support-sensitive KL;
- Pinsker and other divergence comparisons;
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
5. runs the environment-level 31-module API/import/simp/root-export checks and
   both the 601-declaration public and all-project-constant axiom audits; and
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

### Generated documentation and website checks

Use:

```powershell
python scripts/generate_v0_1_public_api.py --check
python scripts/generate_website_blueprint.py --check
python scripts/generate_website_api_index.py --check
python scripts/validate_release.py static
```

The separate, potentially multi-hour signature-documentation gate is:

```powershell
python scripts/validate_release.py api-docs
```

Run it only for the approved manual release gate or focused local Step 11
validation, not as an ordinary push/pull-request check. The static command above
checks the immutable documentation-tool pins and configuration without
regenerating the 624.6-MiB output.

The currently tracked pre-Step-4 generated artifacts record the historical
Chunk 8 surface:

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

Steps 4--7 changed and then froze that source surface. The current source-
derived website artifacts, which are distinct from Step 11 doc-gen, contain
44 modules, 90 local edges, 5 root-reachable modules, 39 separate-import
modules, and 716 declarations (715 documented plus one explicit example-only
instance). The separate `v0.1.x` manifest records the 31 supported modules,
601 supported declarations, 94 reviewed `simp` declarations, and 92 root
exports.
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
