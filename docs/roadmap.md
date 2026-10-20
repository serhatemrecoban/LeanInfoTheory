# Roadmap

## C19.05 initial qualification and maintained handoff — 2026-10-20

C19.01--C19.04 and their reviews are complete by actual private records. C19.05
was admitted after exact predecessor closure/source verification and adds no
mathematical endpoint. Its maintained C20/C21 handoff records all eight public
declarations, permanent consumers and the sixteen approved criteria. Inventory
remains 721 declarations in 47 owners, with 92 root exports and 94 reviewed simp names.

The lead approved the exact 23-path local checkpoint, necessary C19.05-only
amendments, reuse of the existing detached validation checkout, and the separate
actual two-pass local API-documentation milestone.

Initial checkpoint `66b65b9e14af0d10cd127b66ad1f3d16f8cea3fd` passed the complete
`python scripts/validate_release.py` routine in the clean validation checkout.
API01 remains **FAIL**: its first build completed (6361 jobs), but the semantic
check found the new AEP and TypicalSet HTML pages missing after cached final
HTML replay. The parent preserved and moved only the final HTML marker and its
`.trace`/`.hash` companions; source, pins, checkers and Git identity were unchanged.
This bounded generated-cache recovery is not passing API evidence.

The parent reran `python scripts/validate_release.py api-docs` as API02 in the
primary checkout in file mode, using reviewed Zig 0.16.0. Both actual build/check
passes of API02 succeeded. The parent inspected all eight new declarations' actual
signatures, hypotheses, docstrings, owners and local source links, and verified
API-source correspondence to that clean checkpoint. These are warm/incremental
executions and local output, with no cold-build or publication claim.
Clean correspondence is byte-identical for 109/110 API inputs and 102/103 validation
inputs. The sole `docs/v0.1-public-api.json` difference is the existing maintained
LF/CRLF two-hash allowance: uniform CRLF-to-LF bytes and parsed values agree, and
the clean file equals the requested Git blob. Primary API02 inputs are unchanged.
Later applicability checks retain that explicit correspondence, configuration, dependencies and
the two owner pages; whole-tree validity is reused from completed API02 and its
original wrapper check, without claiming a fresh whole-tree rehash.

These are initial qualification facts. Any amended checkpoint requires the complete
clean rerun and exact API-evidence applicability assessment. The fresh all-sixteen-
criterion review, original-report reconciliation, final validation and F capture
are established only by their actual source-bound records. Final closure depends on
`.lit-review/setup/c19-05-completion-20261020.json`, when present, and its linked completion chain;
this prose asserts no future gate, review result or closure. C20--C24 and publication
remain unselected.

See the [C19 handoff](handoffs/chunk-19.md) for contracts and evidence limits.

## Historical C18.06 cumulative qualification and maintained handoff — selected

C9--C17 and C18.01--C18.05 are complete by actual private records. The
conditional C18.06 request was admitted after exact Step 5 closure/source
verification on 2026-10-18. The [approved C18 plan](plans/post-release-chunk-18.md)
now owns cumulative qualification and the [maintained handoff](handoffs/chunk-18.md).
No new mathematical endpoint is planned in this final step.

C16--C18's 44 additions connect dependent finite products and raw product
channels to entropy, support-aware KL, conditional-output entropy and both
channel/source MI bounds. Permanent consumers distinguish arbitrary correlated
inputs, positive dependence within independent pairs, output mutual versus
pairwise independence, null support and noninjective encoded laws. Current
coverage is 713 documented declarations in 45 owners, 81 modules/182 local
edges, five root-reachable/76 separate modules, 36 non-stable owners, 92 root
exports and 94 simp names. The source index has 828 declarations, 827 documented.
These counts describe the current package, not a growth quota.

The lead approved the exact 28-path local checkpoint, necessary C18.06-only
review/evidence amendments within that scope and reuse of the inspected detached
validation checkout. Initial checkpoint `8b30dc96e89a9b4e0224b059faed48e19a4e5f1e`
passed the complete maintained clean routine. The primary checkout preserves
the three excluded files and the older unrelated project-log entry.
Fresh actual two-pass current file-mode API documentation passed separately;
all fifteen signatures, hypotheses, docstrings, owners and source links were
inspected. The initial missing-page failure and bounded three-marker recovery
remain recorded with their evidence limits.

This is captured qualification prose. Review readiness, fresh all-twenty-criterion
independent review, explicit reconciliation and exact final validation/source
applicability require their actual source-bound records. Supported closure is
established only by those records and
`.lit-review/setup/c18-06-completion-20261018.json` when present;
this account does not certify those later events. Every amendment requires the
complete maintained clean rerun and exact API applicability.
C19 self-information/AEP, C22 capacity and C23 coding retain separate approval,
prerequisites and consumers as described in the handoff. Release work is unselected.

The earlier milestone snapshots below retain their original chronology and
counts. Their provisional wording does not reopen a chunk closed by its record.

## Historical C14.04 cumulative qualification and maintained handoff snapshot

C9--C13 are complete by their source-bound private records; C13 completed at
`ebe48eaea4282b1e4f245f8f45440bc930b8df73`. The approved
[C14 revision-2 plan](plans/post-release-chunk-14.md) has completed C14.01--C14.03
with review, most recently by `.lit-review/setup/c14-03-completion-20261007.json`.
All 219 entries of Step 3's final source inventory matched before the conditional
C14.04 request was accepted on 2026-10-08.

The six public declarations in `Shannon.Continuity` give the exact-TV entropy
bound, a capped scalar bound monotone on all nonnegative budgets, and entropy,
conditional-entropy and mutual-information budget bounds. Private consumers
cover binary and ternary endpoints, sparse joint laws, changing marginals,
mixed thresholds, budget weakening, degeneracy, swap and arbitrary-source RVs.
The [C14 handoff](handoffs/chunk-14.md) records contracts, evidence limits and
remaining-work owners; the [notes](plans/post-release-chunk-14-notes.md) retain
implementation decisions and original validation attempts.

Current coverage is 653 documented public declarations in 36 supported owners,
with 94 reviewed simp declarations, 92 root exports and 24 non-stable modules.
The generated graph has 60 modules, 129 local edges, five root-reachable and
55 separate-import modules. Its declaration index has 768 entries: 767 documented
and one example-only instance. The lightweight root and dependency pins are unchanged.

C14.04 has an explicitly authorized 23-file local checkpoint, necessary
C14.04-only amendment authority and clean-checkout reuse. Initial checkpoint
`ca079e2` passed the complete routine suite; the current two-pass API-doc gate
and all-six-declaration inspection also passed. The handoff records exact
source and evidence limits. Any amended candidate requires renewed full routine
validation and exact API-doc applicability. Fresh cumulative review of all
12 criteria, reconciliation and private closure remain subject to source-bound
records; this pre-closure snapshot does not itself certify completion.
C15--C24 remain unselected; push and publication require separate authority.

## Release and predecessor history

This roadmap records planned technical milestones. Chunk 8 is complete through
`C8.24`, checkpointed as commit `1eef228`, pushed, remotely build-validated,
and deployed. LeanInfoTheory `v0.1.0` was published on 2026-09-01 from exact
commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, with an immutable annotated
tag, successful tag-triggered validation, and exact-commit Pages deployment.
Zenodo record [`22229599`](https://zenodo.org/records/22229599) archives the
release under version DOI
[`10.5281/zenodo.22229599`](https://doi.org/10.5281/zenodo.22229599); the
all-versions DOI is
[`10.5281/zenodo.22229598`](https://doi.org/10.5281/zenodo.22229598). The
certificate subsystem is assigned downstream and removed from the `v0.1.0`
library surface, the public import architecture normalized, and the nats-first
scalar units API documented with maintained conversion consumers.
The released `v0.1.0` compatibility baseline contains 31 supported modules,
601 project-owned declarations, 92 lightweight-root exports and 94 reviewed
`simp` declarations; its 13 development, example and reference anchors were
non-stable. Its historical source inventory was 44 modules, 90 local edges,
5 root-reachable modules, 39 separate-import modules and 716 declarations.
Release API curation changed no Lean source. These historical counts are not
current-development ceilings. The maintained trust and CI gates and the
toolchain-fixed package/preliminary legal metadata are locally validated;
release-facing installation, import, scope, units, limitations, compatibility,
and final versioned release documentation is in place, and five exact README examples
compile independently under the maintained validator. The isolated pinned
documentation build now renders signatures for all 601 declarations across all
31 supported module pages, with the 92 canonical export targets reconciled and
all 13 non-stable anchors excluded. Step 12 assembled that output into a
versioned, served, explicitly unpublishable local preview, removed machine-local
source links, connected project/API navigation, and inventoried generated and
third-party assets. The Step 13 checkpoint found the mathematical/API plan
healthy and the overall release state amber. Step 14 has since finalized sole
software authorship, EPFL rights-holder/MIL-affiliation metadata, third-party
provenance, the no-`NOTICE` decision, and automatic post-release GitHub--Zenodo
ingestion with a DOI-free immutable tag. Step 14 is complete with the approved
`2026-09-01` publication date. Step 15 permanently removed the automatic
tag/Release workflow in safety-only commit `81ffef3`; `f0d06df` is the
intermediate reconciliation point. The guarded Pages replacement is manual-only
and cannot deploy on branch push. Exact-candidate qualification, independent
review, explicit publication approval, archival verification, structured EPFL
`RightsHolder` metadata, and post-release DOI propagation are complete.
C9 is complete through C9.07 by its actual private completion record at source
checkpoint `8ee0337b20c320c384d5637de852da7f4ee09728`. The
[maintained C9 handoff](handoffs/chunk-9.md) preserves delivered APIs, evidence
and remaining-work dispositions; its captured pre-closure wording does not reopen
that completed chunk.

C10 is complete through C10.07 at source checkpoint
`37b4ba90d1ab321645f80cacef475f10a3a6ba43`, by its actual private completion
record. The [C10 handoff](handoffs/chunk-10.md) preserves its delivered 25-declaration
TV API and evidence; its provisional chronology does not reopen the completed chunk.

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
That C13/C14 transition snapshot excluded unrelated website notes and left
later chunks unselected. The current C19.05 qualification boundary is recorded above;
publication still requires separate authority.

## Proposed Post-Release Programme

The [long-term chunk map](plans/post-release-chunk-map.md) proposes 16 chunks,
C9--C24: bounded complementary work; finite TV and coupling; quantitative
inequalities and continuity; products and block information; complete finite-iid
fixed-length source coding; finite-channel information capacity and a weak
coding converse; and independent release qualification. Channel achievability
is outside this programme. Dependencies, completion criteria, deferred work,
and future-work-note assignments live in that map, not in this overview.

Revision 2 reconciles the independent and self-reviews: it distinguishes
required dependencies from optional proof routes, separates growth-compatible
validation from optional helper intake, and makes the AEP/coding interfaces
explicit. Package-boundary reviews will also assess the roughly doubled-release
ambition by reusable mathematical content, with about 1,200 supported
declarations only an uncertain cross-check, not a quota.

The later programme remains a proposal for project-lead review, not an approved
execution plan or a release/date commitment. The separately authorized
[review workflow](review-operations.md) is installed. C9--C18 and C19.01--C19.04
are complete by actual records. The separately approved C19 plan and eligible
request select C19.05 for cumulative qualification and the
[maintained handoff](handoffs/chunk-19.md), including fresh all-sixteen-criterion
review and exact final validation. C20--C24 require separately approved detailed
plans and eligible execution requests. No release date or publication is authorized.
The [reference register](references.md) identifies the selected sources and
distinguishes the 2022 and 2024 Polyanskiy--Wu drafts. The calendar horizons
below remain broad aspirations, not delivery deadlines for the proposed chunks.

## Now

The completed Chunk descriptions below are historical checkpoint records.
Certificate-related components mentioned in the Chunk 6 or Chunk 8 baseline
were subsequently separated in release-preparation Step 4 and are not current
LeanInfoTheory release work.

- Project B Chunk 2 is complete. All 18 steps finished finite KL
  support/equality, uniform-reference identities,
  sharp alphabet- and support-cardinality entropy bounds, and ordinary finite
  independence predicates with their mathlib `IndepFun`, zero-MI, and pair-
  entropy equality bridges, plus positive-fiber zero MI and the cross-product
  definition of conditional independence. Zero conditional MI now exactly
  characterizes conditional independence, and the associated conditional-
  entropy equality cases are closed. The support-sensitive and non-absolutely-
  continuous examples are now separately importable. The API review retained
  the current simp/module boundaries and added only four additive-entropy
  compatibility aliases. The complete milestone build, generated-reference,
  website, and repository hygiene suites pass.
- Project B Chunk 3 is complete. All 20 steps of its revised finite-channel,
  Markov, and data-processing plan are finished. The opt-in
  `Probability.FiniteChannel` core now names the four repeated PMF channel
  constructions and proves their basic laws without changing the root or
  introducing heavier semantics. The new opt-in `SemanticBridge.Markov` module
  now defines the total conditional channel with its documented null-fiber
  fallback and proves its weighted atom and pair-law reconstruction laws. It
  also owns the PMF and random-variable Markov predicates, while the
  independence layer now supplies the required first-two-variable conditional-
  independence symmetry. Cross-product, positive-fiber, zero-CMI, and reversal
  characterizations are complete, and arbitrary pair laws extended through a
  channel on their second coordinate are now proved Markov. The exact identity
  `I(X;Y) = I(X;Z) + I(X;Y|Z)`, MI data processing, its conditional-entropy
  consequence, and its reverse-Markov equality case are available at PMF and
  random-variable levels. One-sided, independently two-sided, cascade, and
  deterministic output-map channel corollaries are also complete. The canonical
  total-conditional-channel and existential channel-factorization converses are
  now proved. The Step 13 no-placeholder checkpoint selected a finite kernel-
  chain-rule route to KL contraction, validated its posterior reconstruction,
  and locked an unconditional `ENNReal` theorem plus a real corollary guarded
  only by input support inclusion. The new opt-in
  `SemanticBridge.DataProcessing` module now supplies `pmfChannelKernel`, its
  Markov-kernel instance, and the `channelJoint_toMeasure` bridge to mathlib's
  measure-kernel composition product. It also supplies `channelPosterior`, its
  PMF reconstruction law, and the exact `klDiv_channel_eq_add_posterior`
  identity. The resulting public API now supplies unconditional `ENNReal` and
  input-support-guarded real KL contraction through a common channel, together
  with deterministic-map and channel-cascade forms. One-step contraction toward
  invariant reference laws and entropy growth under uniform-preserving and
  finite doubly stochastic channels are now complete. The common-cause and
  stochastic-channel examples now exercise the new API, and the scheduled
  naming, simp, module, and future-work review is complete. The final milestone
  build, generated-reference, website, consumer, root-isolation, and repository-
  hygiene suites pass; the lightweight root remains unchanged.
- The revised 20-step Project B Chunk 4 plan under Future Work Note 29 is
  complete. It develops finite sufficient statistics, exact full-joint recovery,
  every-prior characterizations, finite Fisher-Neyman factorization, and
  guarded KL data-processing equality while keeping posterior/kernel equality
  and recovery/KL integration in downstream modules. All 20 steps are complete,
  and the opt-in sufficiency core now owns the fixed-prior predicate, induced
  law, first equivalence band, exact full-joint recovery characterization, and
  the family channel predicate with its deterministic specialization. Common
  family recovery now gives every-prior reverse Markov structure, zero
  conditional mutual information, mutual-information preservation, and
  conditional-entropy preservation. One full-support prior now gives the
  converse, and finite nonempty parameter alphabets have the standard all-
  priors channel/statistic characterizations. The data-processing layer gives
  the supported common-posterior characterization, while marginal recovery
  remains only a one-way consequence. The midpoint consumers validate the
  noninjective sufficient, non-sufficient, marginal-only, null-fiber, module,
  naming, and root-isolation contracts. The finite Fisher-Neyman iff now gives
  the textbook factorization through a deterministic statistic with private
  fiber normalization. The downstream data-processing layer retains the
  almost-everywhere posterior theorem as a measure bridge and now gives the
  primary finite pointwise posterior criterion for both `ENNReal` and guarded
  real KL equality. The downstream `Sufficiency.KL` module now proves pairwise
  `ENNReal` KL preservation from one common exact recovery channel and, under
  input support inclusion, the guarded `ENNReal`/real converse with
  deterministic-map forms. Sufficient family channels and deterministic
  statistics now preserve `ENNReal` KL divergence between every pair of model
  laws. A directed support guard makes the converse exact for Boolean-indexed
  two-law families, without asserting a global witness from unrelated
  pairwise equalities in a larger family. The permanent opt-in
  `Examples.SufficientStatistics` module now exercises that full surface with a
  genuinely noninjective sufficient model, a non-sufficient constant statistic,
  and a marginal-only recovery false positive. The scheduled Step 19 review
  retained every current name, simp rule, and module boundary and completed
  the source documentation checklist. Step 20 passed the full ten-target build,
  guarded consumer, root-isolation, axiom, generated-reference, website, and
  hygiene suites.
- The approved 20-step [finite-Fano plan](plans/chapter2-chunk-05.md) has
  completed C5.01-C5.20: its deterministic-decoder mathematics, permanent
  examples, API review, canonical memory, generated references, full
  milestone suite, trust checks, and final hygiene review are current. The
  milestone is checkpointed as commit `ec78829`. Future Work Note 29 retains
  only evidence-driven Fano sharpness, randomized/list-decoding, and coding
  follow-ups.
- The approved 24-step
  [finite-family plan](plans/chapter2-chunk-06.md) is complete through
  `C6.24` and checkpointed as commit `7b5f0db`.
  The checkpoint contains the lightweight dependent-family entropy/MI/
  CMI core, pair/triple compatibility, binary and ordered chain rules,
  semantic Shannon inequalities, concrete `ShannonEntropyVal` constructors,
  one checked-certificate adapter, permanent homogeneous/heterogeneous
  examples, and the completed API/simp/import review. All four new modules
  remain opt-in and the certificate trust boundary is unchanged. The
  generated/public references, independent full build, trust, boundary,
  placeholder, website, and hygiene gates all pass. Bounded Chunk 7 context
  intake and planning subsequently used this checkpoint. Future Work Note 39
  continues to defer canonical/minimal sufficiency, general measurable
  sufficiency, and a larger iid count-statistic development.
- The approved 22-step
  [finite log-sum and convexity plan](plans/chapter2-chunk-07.md) is complete
  through `C7.22` and checkpointed as commit `5e616d8`. The implementation and
  API review provide the finite
  Cover--Thomas Section 2.7 package: a zero-safe `EReal` log-sum theorem and
  support-guarded Real family, binary and general-selector PMF mixtures,
  entropy concavity with binary interior-weight equality, `ENNReal` and
  guarded Real KL joint convexity with the support-aware binary equality case,
  and MI
  concavity in the input law plus convexity in the channel. The four production
  modules and `Examples.Convexity` remain opt-in; the root-visible addition is
  only the general finite bind-to-Real mass bridge in the already imported
  `Probability.Finite` module. The checkpoint has 28 new public
  source declarations and 46 maintained private examples. Generated
  references, public documentation, direct and milestone builds, boundary and
  trust audits, and repository hygiene all pass. Handoff commit `0324ee6` and
  both required remote workflows also pass. That transition supplied the
  baseline later used by the separately approved Chunk 8 plan.
- The approved 24-step
  [finite conditional-KL, conditional-CMI, and mutual-independence plan](plans/chapter2-chunk-08.md)
  is complete and independently validated through `C8.24`. Its frozen source
  adds four lightweight binary/ordered law/source conditional-family CMI chain
  rules; the separately importable
  `Shannon.SemanticBridge.ConditionalKL` module with common-base channel
  conditional KL, finite `ENNReal` weighted and joint chain rules, and
  support-guarded Real forms; and the separately importable
  `Shannon.SemanticBridge.FiniteFamilyIndependence` module with PMF/source
  factorization predicates, empty/singleton/restriction laws, pair
  compatibility, and n-way entropy-additivity iff mutual independence. The
  maintained conditional-KL and finite-family examples cover null and infinite
  fibers, duplicate/overlapping CMI chains, dependent alphabets, product
  families, and pairwise-but-not-mutual independence. Exactly 18 public
  declarations were added; all new heavy owners remain opt-in, while the
  root, certificate API, validator, primitive inequalities, and trust boundary
  remain unchanged. The focused, maintained, and default builds, boundary and
  trust suites, complete 15-theorem axiom audit, generated references, website,
  and repository-hygiene checks pass. Chunk 8 adds no Section 2.8 theorem: together
  with completed Chunks 3 and 7, it closes the remaining finite algebraic gaps
  in Cover--Thomas Sections 2.5--2.8 without claiming all Chapter 2 complete.
  Generated references record 51 modules, 100 local edges, 11 root-reachable
  modules, 40 opt-in modules, and 880 documented source declarations. The
  validated source is checkpointed as `1eef228`; its required Lean and Pages
  workflows both succeeded.
- Maintain project notes in the foundation conventions and project log.
- Keep the lightweight finite API separated from heavier KL and coding imports.

## 3 Months

- Preserve source compatibility throughout `0.1.x` and triage downstream
  adoption evidence through the focused
  [API-feedback process](downstream-api-feedback.md).
- Keep version-specific citations on DOI `10.5281/zenodo.22229599` and use
  concept DOI `10.5281/zenodo.22229598` for all-versions references.
- Maintain the post-release Pages split: unversioned project-status pages
  follow current `master`, while `/docs/v0.1.0/` is rebuilt from and remains
  source-linked to the immutable release commit.
- Consider a theorem-level blueprint and PDF after release documentation is
  stable.

## 6 Months

- Prepare focused mathlib PRs for generic finite-measure lemmas.
- Review the proposed post-release chunk map, then use separately approved
  detailed plans and dependency checks for its mathematical phases.
- Keep certificate constraints and recognizable certificate-driven converse
  applications in downstream projects.

## 12 Months

- Formalize selected converse proof skeletons.
- Write a technical report or short paper describing the Lean library.
- Maintain versioned signature-bearing API documentation and consider optional
  equation-expanded output and a theorem-level blueprint dependency graph only
  after their costs and concrete uses justify them.
