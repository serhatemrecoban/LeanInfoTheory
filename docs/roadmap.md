# Roadmap

This roadmap records planned technical milestones. The homepage, theorem
highlights, and module guide record what is implemented now.

## Now

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
- The approved 20-step [finite-Fano plan](plans/chapter2-chunk-05.md) is the
  next Project B phase after Chunk 4; all steps remain not started. Future Work
  Note 39 defers canonical/minimal sufficiency, general measurable sufficiency,
  and a larger iid count-statistic development until a later focused milestone.
- Maintain project notes in the foundation conventions and project log.
- Keep the lightweight finite API separated from heavier KL and coding imports.

## 3 Months

- Publish a genuine leanblueprint web page, blueprint PDF, and theorem-level
  dependency graph.
- Upgrade the current source-derived declaration index into full Lean doc-gen
  output, while keeping the hand-written module guide as a stable
  orientation page.
- Link generated docs and blueprint entries back to the curated theorem
  highlights and submodularity demo page.
- Implement the approved finite-Fano plan one explicitly authorized step at a
  time on top of the completed sufficient-statistics and recovery-equality API,
  without folding in a full coding theorem.

## 6 Months

- Add richer certificate constraints such as independence, functional
  dependence, and Markov constraints.
- Return to richer checked-certificate assumptions and recognizable converse
  steps after the planned Project B foundations are in place.
- Prepare focused mathlib PRs for generic finite-measure lemmas.

## 12 Months

- Add PSITIP/oXitip-style certificate import.
- Formalize selected converse proof skeletons.
- Write a technical report or short paper describing the Lean library and
  certificate pipeline.
- Stabilize project documentation, full Lean doc-gen output, and theorem-level
  blueprint dependency graph.
