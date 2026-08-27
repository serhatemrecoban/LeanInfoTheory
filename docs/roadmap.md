# Roadmap

This roadmap records planned technical milestones. Chunk 8 is complete through
`C8.24`, checkpointed as commit `1eef228`, pushed, remotely build-validated,
and deployed. Release-candidate source preparation is represented in this
snapshot. Exact candidate identity, qualification evidence, independent-review
result, and publication state are external; this tracked roadmap does not claim
them. The certificate subsystem is assigned downstream and removed from
the `v0.1.0` library surface, the public import architecture normalized, and the
nats-first scalar units API documented with maintained conversion consumers.
The `v0.1.x` public surface is frozen at 31 supported modules, 601
project-owned declarations, 92 lightweight-root exports, and 94 reviewed
`simp` declarations; all 13 development, example, and reference anchors remain
non-stable.
The verified mathematical source inventory is 44 modules, 90 local edges, 5
root-reachable modules, 39 separate-import modules, and 716 declarations. Public API
curation changed no Lean source. The maintained trust and CI gates and the
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
`2026-08-27` publication date. Step 15 permanently removed the automatic
tag/Release workflow in safety-only commit `81ffef3`; `f0d06df` is the
intermediate reconciliation point. The guarded Pages replacement is manual-only
and cannot deploy on branch push. The controlled publication procedure requires
exact-candidate qualification, independent review of the unchanged commit, and
explicit Step 18 authorization. No later mathematical phase has been selected.

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

- Preserve exact-SHA clean-checkout, external-consumer, automatic
  GitHub--Zenodo integration-preflight, remote documentation-capacity, and
  independent-review gates for `v0.1.0` publication.
- Publish `v0.1.0` and its Zenodo deposit only after all release gates pass and
  the project lead gives explicit approval.
- Consider a theorem-level blueprint and PDF after release documentation is
  stable.

## 6 Months

- Prepare focused mathlib PRs for generic finite-measure lemmas.
- Select later finite information-theory mathematics through a separate
  readiness and planning process.
- Keep certificate constraints and recognizable certificate-driven converse
  applications in downstream projects.

## 12 Months

- Formalize selected converse proof skeletons.
- Write a technical report or short paper describing the Lean library.
- Maintain versioned signature-bearing API documentation and consider optional
  equation-expanded output and a theorem-level blueprint dependency graph only
  after their costs and concrete uses justify them.
