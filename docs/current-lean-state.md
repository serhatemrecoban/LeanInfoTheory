# Current Lean State

Last milestone checkpoint: July 14, 2026. Project B Chunk 1 was committed as
`7ab3aa0`, and Project B Chunk 2 is now complete after passing its full
milestone build/check suite. All 18 Chunk 2 steps are finished. The chunk began
from the clean Chunk 1 checkpoint, its new theorem contracts were validated by
temporary
no-placeholder Lean proofs, and the finite KL support, equality, and
uniform-reference APIs, sharp finite entropy equality cases, and ordinary
independence predicates, mathlib `IndepFun` bridge, and zero-MI
and pair-entropy equality characterizations are public. Zero averaged
conditional mutual information is now equivalent to zero mutual information
on every positive-mass conditional fiber. The proof-independent
`IsCondIndependent` and `IsCondIndependentOf` predicates are public, and the
PMF predicate is equivalent to ordinary independence on every positive-mass
conditional joint law. Zero conditional mutual information is now equivalent
to conditional independence at both PMF and random-variable levels, and the
corresponding conditioning-equality and conditional-additivity cases are
public. The opt-in `Examples.SupportSensitive` and `Examples.KLTop` modules now
exercise the support-aware theorem contracts and the non-absolutely-continuous
real-KL zero trap without changing the lightweight root.
The scheduled API review retained every existing declaration and added only
four short additive-entropy aliases. Simp policy, module ownership, and import
boundaries remain unchanged; the proposed fiber, uniform-law, general KL, and
MI relabeling APIs remain deferred for concrete theorem pressure. The final
integration pass rebuilt all ten milestone targets, regenerated both public
reference sets, passed the website and repository hygiene checks, and left the
lightweight root unchanged.

This is a handoff note for future Lean-focused work. It summarizes the current
architecture and the next useful Lean tasks without changing theorem
statements.

## Current Lean Architecture

- `LeanInfoTheory.lean` is the lightweight root import. It imports the stable
  finite information-measure API and the core certificate/checker definitions,
  but not heavier theorem, semantic bridge, demo, coding, or reference modules.
- `LeanInfoTheory.Basic` holds lightweight namespace/status vocabulary.
- `LeanInfoTheory.Probability.Finite` contains reusable finite `PMF` helper
  lemmas, including real-mass facts, the canonical finite `PMF.supportFinset`
  view, pointwise `PMF.map` formulas, and the singleton-support characterization
  `PMF.eq_pure_iff_support_eq_singleton`.
- `LeanInfoTheory.Shannon.Entropy` defines finite Shannon entropy in nats using
  mathlib `PMF`s and `Real.negMulLog`.
- `LeanInfoTheory.Shannon.InfoMeasures` defines finite marginal laws,
  conditional entropy, mutual information, conditional mutual information, and
  random-variable versions via `PMF.map`.
- `LeanInfoTheory.Shannon.Units` is a separately importable logarithm-base
  conversion layer. It leaves the canonical definitions in nats and supplies
  division-by-`Real.log`/`Real.logb` bridge theorems.
- `LeanInfoTheory.Shannon.EntropyBounds` is separately importable and contains
  the Jensen-based alphabet- and support-cardinality entropy bounds and their
  exact uniform-law equality characterizations.
- `LeanInfoTheory.Shannon.SemanticBridge` and its subfiles are the heavier
  bridge layer connecting the finite Shannon API to `PMF.toMeasure`, product
  measures, conditional laws, and `InformationTheory.klDiv`, including finite
  PMF support characterizations of absolute continuity, finiteness, and the
  KL zero-equality case, support-aware uniform-reference identities, and the
  separately importable independence module, including its conditional-
  independence definitions and positive-fiber characterization.
- `LeanInfoTheory.EntropyExpr`, `LeanInfoTheory.EntropyVal`, and
  `LeanInfoTheory.PrimitiveIneq` form the abstract entropy-expression and
  primitive Shannon inequality layer.
- `LeanInfoTheory.Certificate` and `LeanInfoTheory.Certificate.Checked` contain
  the checked certificate skeleton and raw-to-checked validation path.
- `LeanInfoTheory.Certificate.Submodularity`,
  `LeanInfoTheory.Certificate.Subadditivity`,
  `LeanInfoTheory.Certificate.Monotonicity`,
  `LeanInfoTheory.Certificate.ThreeWaySubadditivity`, and
  `LeanInfoTheory.Examples` are separately importable demonstration and
  pressure-test modules. `LeanInfoTheory.Examples.SupportSensitive` and
  `LeanInfoTheory.Examples.KLTop` can also be imported directly when only the
  new semantic examples are wanted.
- `LeanInfoTheory.MathlibFragments` is a separately importable anchor/checklist
  for mathlib APIs that the project expects to use later.

## Finite Shannon Layer Status

The finite Shannon layer is PMF-based and uses real-valued entropy in nats.

Implemented and building:

- finite entropy `Shannon.entropy`;
- entropy as a finite sum of `Real.negMulLog` terms;
- entropy nonnegativity;
- deterministic-law entropy `H(delta_a) = 0`;
- zero entropy characterized by purity through
  `Shannon.entropy_eq_zero_iff`;
- random-variable zero entropy characterized by constancy on the source PMF
  support through `Shannon.entropyOf_eq_zero_iff`;
- entropy of random variables via pushforward laws;
- joint entropy as entropy of a joint `PMF`;
- invariance under equivalences, injective relabelings, coordinate swaps, and
  product reassociation;
- marginal laws for pairs and triples, including first-second, first-third,
  second-third, and third-coordinate projections, with pointwise mass formulas
  and domination/zero-mass helper lemmas;
- finite conditional entropy, mutual information, and conditional mutual
  information as entropy identities;
- pair conditional-entropy decompositions and the triple random-variable chain
  rules `H(X,Y|Z) = H(Y|Z) + H(X|Y,Z)` and
  `H(X,Y|Z) = H(X|Z) + H(Y|X,Z)`, together with swap invariance for the
  conditioned pair;
- mutual information symmetry and conditional mutual information symmetry
  under coordinate swaps, plus random-variable symmetry theorems
  `I(Y;X) = I(X;Y)` and `I(Y;X|Z) = I(X;Y|Z)`;
- the equivalent mutual-information identities
  `I(X;Y) = H(X) - H(X|Y)` and `I(X;Y) = H(Y) - H(Y|X)`, at both PMF and
  random-variable levels, together with `I(X;X) = H(X)`;
- the random-variable conditional-mutual-information identities
  `I(X;Y|Z) = H(X|Z) - H(X|Y,Z)`, its symmetric form in `Y`, and
  `I(X;Y|Z) = H(X|Z) + H(Y|Z) - H(X,Y|Z)`;
- opt-in change of logarithm base through `Shannon.div_log_change_base`,
  `Shannon.negMulLog_div_log`, `Shannon.entropy_div_log`, and
  `Shannon.entropyOf_div_log`;
- Jensen-based bound `H(P) <= log |alpha|` for nonempty finite alphabets;
- support-sensitive bounds `H(P) <= log |support P|` and
  `H(X) <= log |support (law X)|` through
  `Shannon.entropy_le_log_support_ncard` and
  `Shannon.entropyOf_le_log_support_ncard`;
- alphabet-cardinality equality exactly for `PMF.uniformOfFintype`, and
  support-cardinality equality exactly for uniformity on the PMF support, at
  both PMF and random-variable levels.

The layer intentionally does not introduce a project-local probability type.
It should continue to reuse mathlib `PMF`, `PMF.map`, `PMF.bind`,
`PMF.toMeasure`, `Real.negMulLog`, and measure-theoretic information theory
where possible.

## Semantic Bridge Status

The semantic bridge is separated from the lightweight finite Shannon files so
that KL divergence, measure products, kernels, and conditional probability
imports do not become root-import dependencies.

Implemented and building:

- `Shannon.selfInfo p a`, with zero-mass convention;
- finite entropy as expected self-information over `PMF.toMeasure`;
- independent product PMF `indepProd`, including support, marginal, and
  product-measure bridge lemmas;
- PMF independence `Shannon.IsIndependent` and random-variable independence
  `Shannon.IsIndependentOf`, with pointwise marginal factorization,
  independent-product construction, symmetry theorems, and the explicit
  `Shannon.isIndependentOf_iff_indepFun` measure-theoretic bridge;
- zero mutual information characterized by ordinary independence through
  `Shannon.mutualInfo_eq_zero_iff_isIndependent` and
  `Shannon.mutualInfoOf_eq_zero_iff_isIndependentOf`;
- conditioning preserves entropy and joint entropy is additive exactly under
  ordinary independence, at both PMF and random-variable levels;
- `Shannon.condMutualInfo_eq_zero_iff_condMutualInfoFstSndGivenThird_eq_zero`,
  which extracts zero mutual information on every positive-mass conditional
  fiber from zero averaged conditional mutual information and proves the
  converse;
- conditional independence predicates `Shannon.IsCondIndependent` and
  `Shannon.IsCondIndependentOf`, with the former defined by atomwise
  cross-product factorization and characterized by
  `Shannon.isCondIndependent_iff_isIndependent_condFstSndGivenThird` as
  independence of every positive-mass conditional joint law;
- zero conditional mutual information characterized by conditional
  independence through `Shannon.condMutualInfo_eq_zero_iff_isCondIndependent`
  and `Shannon.condMutualInfoOf_eq_zero_iff_isCondIndependentOf`;
- conditioning preserves conditional entropy exactly under conditional
  independence through
  `Shannon.condEntropy_eq_condEntropy_fstThirdMarginal_iff_isCondIndependent`
  and `Shannon.condEntropyOf_eq_condEntropyOf_iff_isCondIndependentOf`;
- conditional joint entropy is additive exactly under conditional independence
  through `Shannon.condEntropy_pair_eq_add_condEntropy_iff_isCondIndependent`
  and
  `Shannon.condEntropyOf_pair_eq_add_condEntropyOf_iff_isCondIndependentOf`;
- absolute-continuity helpers from a joint finite law to the product of its
  marginals;
- finite log-ratio formulas for mutual information;
- mutual information as KL divergence from the joint law to the independent
  product law and to the product of marginal measures;
- finite conditional laws `P_{A | B=b}` for nonzero-marginal fibers, with
  factorization lemmas;
- zero entropy on a positive conditional fiber characterized by purity of its
  canonical conditional PMF through
  `Shannon.condEntropyFstGivenSnd_eq_zero_iff_of_sndMarginal_ne_zero`;
- global zero conditional entropy characterized by support-wise functional
  dependence through `Shannon.condEntropy_eq_zero_iff_exists_function` and
  `Shannon.condEntropyOf_eq_zero_iff_exists_function`;
- deterministic and self-conditioning consequences
  `Shannon.condEntropyOf_comp_eq_zero` and
  `Shannon.condEntropyOf_self_eq_zero`, together with PMF and random-variable
  joint-entropy equality characterizations;
- conditional entropy as `sum_b P_B(b) H(P_{A | B=b})`;
- PMF-facing triple conditional-entropy chain rules for `pairThirdLaw`, in both
  variable orders;
- deterministic entropy processing for PMFs and random variables, with equality
  characterized by injectivity on the relevant law support;
- the conditional deterministic chain rule
  `H(X|Z) = H(f(X)|Z) + H(X|f(X),Z)`, its entropy-processing inequality, and
  equality characterized by support-wise recovery of `X` from `(f(X), Z)`,
  together with PMF-facing first-coordinate forms;
- conditional mutual information as averaged fiber mutual information;
- conditional mutual information as averaged fiber KL divergence;
- semantic nonnegativity of conditional entropy, mutual information, and
  conditional mutual information;
- random-variable conditional-mutual-information nonnegativity through
  `Shannon.condMutualInfoOf_nonneg`;
- pair-level inequalities `H(A|B) <= H(A)`,
  `I(A;B) <= H(A), H(B)`, and
  `H(A), H(B) <= H(A,B) <= H(A) + H(B)`, together with random-variable forms;
- mutual-information chain rules:
  `I(A; B, C) = I(A; C) + I(A; B | C)` and
  `I(A; B, C) = I(A; B) + I(A; C | B)`, plus random-variable forms;
- deterministic mutual-information processing, including
  `I(X;Y) = I(f(X);Y) + I(X;Y|f(X))`, one-sided and two-sided random-variable
  inequalities, and PMF coordinate-map corollaries;
- both PMF conditional-entropy difference forms for conditional mutual
  information;
- triple-level conditional inequalities in PMF and random-variable forms:
  `I(X;Y|Z) <= H(X|Z), H(Y|Z)` and
  `H(X|Z), H(Y|Z) <= H(X,Y|Z) <= H(X|Z) + H(Y|Z)`;
- conditioning-reduces-entropy:
  `H(A | B, C) <= H(A | C)`, plus the random-variable form.

The semantic bridge API remains separately importable. The Chunk 1 API review
added compatibility-preserving left/right/both aliases for the pair bounds,
deterministic processing, and conditional inequality band while retaining all
descriptive marginal/coordinate names. More speculative MI/CMI-difference,
fiber, reverse-identity, and relabeling aliases remain deferred pending real
proof pressure.

## Certificate Layer Status

The certificate layer is abstract: it works over entropy atoms, rational
linear combinations of entropy atoms, and abstract Shannon entropy valuations.

Implemented and building:

- entropy atoms as finite sets of variables;
- sparse rational entropy expressions;
- explicit empty-entropy convention;
- abstract `ShannonEntropyVal`, packaging `H(empty) = 0`, conditional entropy
  nonnegativity, and conditional mutual information nonnegativity;
- primitive Shannon inequality expressions for empty entropy, conditional
  entropy, and conditional mutual information;
- soundness theorems for primitive inequalities under a
  `ShannonEntropyVal`;
- checked certificate structures with nonnegative rational coefficients;
- raw certificate data and a raw-to-checked validator;
- exact decomposition matching over normalized rational entropy expressions;
- soundness theorem: if raw data validates to a checked certificate, then the
  target entropy expression is nonnegative under every `ShannonEntropyVal`;
- ergonomic raw-validator soundness theorem
  `Certificate.RawCert.sound_of_toCheckedCert?_isSome`, for demos that prove
  only that validation succeeds;
- checked certificate demos for entropy submodularity, entropy
  subadditivity, one-variable entropy monotonicity, and three-way entropy
  subadditivity.

The current project has the checking/validation side, not automatic
certificate generation. Future PSITIP/oXitip-style integration should remain
untrusted: external tools can search for certificates and emit raw data, while
Lean validation remains the trusted step.

## Certificate Demo Status

`LeanInfoTheory.Certificate.Submodularity` is the first non-toy checked
certificate demo.

It proves the abstract entropy submodularity inequality

```text
0 <= H(A) + H(B) - H(A union B) - H(A inter B)
```

for every `ShannonEntropyVal`, by validating a one-step certificate whose
primitive ingredient is

```text
I(A \ B ; B \ A | A inter B) >= 0.
```

The demo includes:

- the target entropy expression;
- the corresponding primitive conditional-mutual-information expression;
- set identities showing the expressions match;
- checked and raw certificate data;
- a theorem that the raw certificate validates;
- a final soundness theorem derived through the generic checker.

This is a real checked-certificate path, but it is still a small example. It
does not yet include independence, Markov, or functional-dependence
assumptions.

Two additional small checked-certificate demos now exercise the validator on
more primitive combinations:

- `LeanInfoTheory.Certificate.Subadditivity` proves
  `0 <= H(A) + H(B) - H(A union B)` by validating the two-step certificate
  `I(A;B | empty) + H(empty)`.
- `LeanInfoTheory.Certificate.Monotonicity` proves
  `0 <= H(insert i S) - H(S)` under `i notin S` by validating a
  conditional-entropy primitive certificate.

## Website Status

Website source lives under `home_page/`. The current website includes a
homepage dashboard, theorem highlights, submodularity demo, module guide,
development page, prior-art page, roadmap, generated module-level dependency
map, and generated declaration index.

The declaration index is source-derived and is not full Lean doc-gen. The
dependency map is module-level and is not theorem-level leanblueprint. Keep
website wording honest about what is proved, demoed, generated, planned, and
future work.

## Important Design Constraints

- Do not use `sorry`, `admit`, `axiom`, `opaque`, or `undefined` in Lean
  source.
- Keep root imports lightweight.
- Keep semantic bridge, entropy bounds, demos, and reference modules separately
  importable where appropriate.
- Prefer mathlib definitions and APIs over local replacements.
- Do not redefine probability theory locally.
- Do not change Lean theorem statements during website-only tasks.
- Keep certificate generation and certificate validation conceptually
  separated.
- Keep future external certificate importers untrusted; Lean validation is the
  trusted step.
- When upgrading mathlib, re-run the semantic bridge API audit and check
  whether mathlib has added canonical finite PMF product, finite KL expansion,
  or averaged conditional-KL APIs.

## Recommended Next Lean Tasks

1. Review the Project B formalization map and live future-work notes, then fix
   the scope and theorem contracts of the next focused chunk before editing
   Lean.
2. Keep the root import unchanged. Entropy bounds, semantic theorems, units,
   demos, and reference anchors remain separately importable where appropriate.
3. Treat a stochastic-channel, Markov, and data-processing dependency layer as
   the leading next-chunk candidate. Audit mathlib's finite-kernel contracts
   and settle module ownership before choosing public definitions.
4. Keep sufficient statistics, Fano, binary/q-ary bridges, and finite-family
   entropy in later focused chunks unless the next planning pass establishes a
   direct prerequisite.
5. Continue updating the project log after each completed implementation step,
   with focused Lake builds during development and a full suite at each
   milestone boundary.

## Completed Project B Chunk 2 Plan

Current status: all 18 steps are complete. The chunk covers finite KL
support/equality, uniformity, independence, and conditional independence, and
the final milestone suite and hygiene checks pass.

1. Completed on July 14, 2026: checkpoint the completed Chunk 1 milestone as
   commit `7ab3aa0` with a clean worktree.
2. Completed on July 14, 2026: lock theorem shapes, names, ownership, support
   conventions, and proof routes through temporary no-placeholder Lean spikes.
3. Completed on July 14, 2026: promote the lightweight finite
   `PMF.supportFinset` API and make `EntropyBounds` consume it while retaining
   the stronger support-restriction PMF as private implementation machinery.
4. Completed on July 14, 2026: characterize PMF absolute continuity by support
   inclusion and, on finite alphabets, characterize finite and infinite KL
   divergence by whether that inclusion holds.
5. Completed on July 14, 2026: specialize mathlib's KL zero-equality theorem to
   PMFs and prove the real-valued zero characterization under the finite
   support-inclusion guard.
6. Completed on July 14, 2026: prove the support-aware KL identity against
   `PMF.uniformOfFinset` and its full-alphabet `PMF.uniformOfFintype` corollary.
7. Completed on July 14, 2026: characterize equality in the alphabet- and
   support-cardinality entropy bounds by uniformity, at both PMF and
   random-variable levels, using strict Jensen in the opt-in bounds module.
8. Completed on July 14, 2026: introduce ordinary PMF and random-variable
   independence predicates, pointwise/product-law characterizations, and
   symmetry in the separately importable semantic independence module.
9. Completed on July 14, 2026: bridge mapped-law independence to mathlib
   `ProbabilityTheory.IndepFun` under explicit measurability and measurable-
   singleton assumptions.
10. Completed on July 14, 2026: characterize zero mutual information by
    `IsIndependent` and `IsIndependentOf`, with the discrete measurable-space
    choice confined locally to the KL proof.
11. Completed on July 14, 2026: characterize equality in conditioning-reduces-
    entropy and joint-entropy subadditivity by ordinary independence, at both
    PMF and random-variable levels.
12. Completed on July 14, 2026: characterize zero averaged conditional mutual
    information by zero mutual information on every positive-mass conditional
    joint fiber.
13. Completed on July 14, 2026: introduce `IsCondIndependent` and
    `IsCondIndependentOf` through proof-independent cross-product factorization
    and prove the PMF predicate equivalent to independence of every positive-
    mass conditional joint law.
14. Completed on July 14, 2026: characterize zero conditional mutual
    information by `IsCondIndependent` and `IsCondIndependentOf` at PMF and
    random-variable levels.
15. Completed on July 14, 2026: characterize preservation of conditional
    entropy and additivity of conditional joint entropy by conditional
    independence, at PMF and random-variable levels.
16. Completed on July 14, 2026: add separately importable support-sensitive and
    non-absolutely-continuous examples using the public theorem contracts.
17. Completed on July 14, 2026: review names, aliases, simp policy, module
    pressure, and deferred relabeling; add only the four approved additive-
    entropy compatibility aliases.
18. Completed on July 14, 2026: integrate the accumulated work, regenerate both
    public reference sets, run the complete ten-target milestone suite and
    repository hygiene checks, and prepare the clean Chunk 2 checkpoint.

### Locked Step 2 Contract

- `PMF.supportFinset` will expose only membership, set coercion, cardinality,
  and nonemptiness facts. The stronger support-restriction PMF remains private.
- For finite PMFs, `p.toMeasure ≪ q.toMeasure` is represented by
  `p.support ⊆ q.support`; on a finite alphabet this is equivalent to
  `klDiv p.toMeasure q.toMeasure ≠ ∞`, while failure of inclusion is equivalent
  to KL being `∞`.
- The project continues to use mathlib's `InformationTheory.klDiv : ENNReal`.
  A real-valued zero theorem must assume support inclusion/finiteness so that
  `ENNReal.toReal ∞ = 0` cannot create a false equality characterization.
- The uniform-reference identity has the generalized support-aware shape
  `D(p || uniform(s)) = log |s| - H(p)` under `support(p) ⊆ s`.
- Entropy-bound equality remains in `Shannon.EntropyBounds` and uses strict
  Jensen. The KL identity remains in the separately importable semantic layer.
- `Shannon.IsIndependent p` means that a joint PMF equals the independent
  product of its marginals. `Shannon.IsIndependentOf p X Y` applies this to the
  mapped joint law. The mathlib bridge uses explicit measurability assumptions.
- `Shannon.IsCondIndependent p` is primarily the proof-independent statement
  `p(a,b,c) * p_C(c) = p_AC(a,c) * p_BC(b,c)` for every atom. Independence of
  each positive conditional joint law is an equivalent theorem; null fibers
  satisfy the primary factorization automatically.
- The primary KL families use support-explicit names such as
  `klDiv_pmf_ne_top_iff_support_subset`,
  `klDiv_pmf_eq_top_iff_not_support_subset`, and
  `toReal_klDiv_pmf_eq_zero_iff`. The main equality theorems use
  `mutualInfo_eq_zero_iff_isIndependent` and
  `condMutualInfo_eq_zero_iff_isCondIndependent`, with parallel `...Of` forms.
- The ordinary- and conditional-independence APIs live in the separately
  importable `Shannon.SemanticBridge.Independence` module. The aggregate
  semantic bridge imports it, but the lightweight root does not.
- Stochastic channels, Markov chains, general data processing, sufficient
  statistics, Fano, and finite-family entropy remain outside this chunk.

## Completed Project B Chunk 1 Plan

Current status: all 14 steps are complete. Step 1 fixed the theorem
contract; steps 2 and 3 completed the ordinary-entropy block; steps 4 and 5
completed the zero-conditional-entropy and functional-dependence block; step 6
completed the pair/triple conditional-entropy chain-rule block; step 7 completed
deterministic entropy processing and its equality cases; step 8 completed the
elementary mutual-information identity family; step 9 completed the pair-level
entropy and mutual-information inequalities; step 10 completed deterministic
mutual-information processing; step 11 completed the conditional-mutual-
information identity family; step 12 completed the triple-level conditional
inequality band; step 13 completed opt-in units and the pressured API review;
step 14 completed the integration review, public-status refresh, generated
references, and full milestone suite.

1. Completed on July 12, 2026: freeze theorem statements, support conventions,
   names, file ownership, and proof routes. Temporary no-placeholder Lean
   proofs validated both `H(X) = 0` iff purity and `H(X|Y) = 0` iff support-wise
   functional dependence.
2. Completed on July 12, 2026: prove `Shannon.entropy_eq_zero_iff`, stating
   that a finite PMF has zero entropy exactly when it is pure, and
   `Shannon.entropyOf_eq_zero_iff`, stating that a finite-valued random
   variable has zero entropy exactly when it is constant on the source PMF
   support.
3. Completed on July 12, 2026: prove
   `Shannon.entropy_le_log_support_ncard` and
   `Shannon.entropyOf_le_log_support_ncard` by restricting the PMF to its
   finite nonzero support and reusing `entropy_le_log_card`.
4. Completed on July 12, 2026: prove
   `Shannon.condEntropyFstGivenSnd_eq_zero_iff_of_sndMarginal_ne_zero`, reducing
   positive-fiber zero entropy exactly to purity of the canonical conditional
   PMF.
5. Completed on July 12, 2026: characterize PMF and random-variable zero
   conditional entropy by support-wise functional dependence; add deterministic
   function, self-conditioning, and joint-entropy equality corollaries; and
   promote the reused singleton-support PMF lemma.
6. Completed on July 12, 2026: prove random-variable conditioned-pair swap
   invariance and both triple conditional-entropy chain rules, together with
   PMF-facing `pairThirdLaw` forms. The new rules remain explicit rewrites.
7. Completed on July 12, 2026: prove PMF and random-variable deterministic
   entropy monotonicity with equality exactly under injectivity on the law
   support; prove the conditional deterministic chain identity, monotonicity,
   and equality exactly under support-wise recovery from `(f(X), Z)`, together
   with PMF-facing first-coordinate forms.
8. Completed on July 14, 2026: prove both PMF and random-variable forms of
   `I(A;B) = H(A) - H(A|B)` and `I(A;B) = H(B) - H(B|A)`, plus the diagonal-law
   and self identities `I(A;A) = H(A)`, all in the lightweight finite layer.
9. Completed on July 14, 2026: prove PMF and random-variable forms of
   conditioning-reduces-entropy, MI upper bounds by both marginal entropies,
   both marginal-to-joint entropy bounds, and joint entropy subadditivity;
   independence-based equality cases remain deferred.
10. Completed on July 14, 2026: add random-variable conditional-MI
    nonnegativity, prove the exact deterministic chain decomposition
    `I(X;Y) = I(f(X);Y) + I(X;Y|f(X))`, and derive one-sided and two-sided
    deterministic mutual-information processing for random variables and joint
    PMFs. Stochastic channels and conditional-independence equality
    characterizations remain deferred.
11. Completed on July 14, 2026: add random-variable forms of
    `I(X;Y|Z) = H(X|Z) - H(X|Y,Z)`, its symmetric `Y` form, and
    `I(X;Y|Z) = H(X|Z) + H(Y|Z) - H(X,Y|Z)` in the lightweight layer; add the
    missing symmetric PMF difference identity in the semantic theorem layer.
12. Completed on July 14, 2026: prove PMF and random-variable forms of
    `I(X;Y|Z) <= H(X|Z), H(Y|Z)` and
    `H(X|Z), H(Y|Z) <= H(X,Y|Z) <= H(X|Z) + H(Y|Z)`; conditional-independence
    equality cases remain deferred.
13. Completed on July 14, 2026: add the separately importable
    `Shannon.Units` change-of-base module; add compatibility-preserving
    left/right/both aliases for the pressured chain-rule, inequality, and
    deterministic-processing families; and promote only canonical PMF
    swap/diagonal and RV self reductions to `[simp]`.
14. Completed on July 14, 2026: review the accumulated Chunk 1 diff and module
    boundaries, update public status, regenerate the dependency graph and
    434-declaration API index, and pass the complete root, bounds, units,
    semantic bridge, reference, certificate-demo, examples, website,
    placeholder, and diff-hygiene suite.

### Locked Step 1 Contract

- Equalities of random variables are support-wise: `X omega = f (Y omega)` is
  required only for `omega in p.support`. No global equality outside the
  probability law's support is imposed.
- The primary zero-entropy theorems will use the names
  `entropy_eq_zero_iff` and `entropyOf_eq_zero_iff`.
- The primary zero-conditional-entropy theorems will use the names
  `condEntropyFstGivenSnd_eq_zero_iff_of_sndMarginal_ne_zero`,
  `condEntropy_eq_zero_iff_exists_function`, and
  `condEntropyOf_eq_zero_iff_exists_function`.
- Deterministic entropy equality is characterized by
  `Set.InjOn f (p.map X).support`, not injectivity of `f comp X` on the source
  support. Conditional deterministic equality instead uses recovery of
  `X` from `(f(X), Z)` on the source support.
- The new support bounds will be named
  `entropy_le_log_support_ncard` and
  `entropyOf_le_log_support_ncard`; they will not require an artificial
  `[Nonempty alpha]` assumption because a PMF has nonempty support.
- Lightweight algebraic identities and the new conditional chain rules remain
  in `Shannon/InfoMeasures.lean`. Zero entropy remains in
  `Shannon/Entropy.lean`, support bounds remain in
  `Shannon/EntropyBounds.lean`, and semantic nonnegativity/equality consequences
  remain in `Shannon/SemanticBridge/Theorems.lean` unless actual file pressure
  justifies a later split.
- Base conversion is opt-in and leaves nats canonical. `Shannon.Units` exposes
  division-by-`Real.log`/`Real.logb` bridge theorems rather
  than duplicate the entropy, conditional-entropy, MI, and CMI definition
  hierarchy.
- The root import, certificate architecture, and existing theorem statements
  remain unchanged throughout this chunk.

## Completed 9-Step Lean Theorem Plan

Current status: all nine steps are complete.

1. Completed on July 8, 2026: prove mutual-information symmetry through
   `Shannon.mutualInfo_map_swap` and `Shannon.mutualInfoOf_swap`.
2. Completed on July 8, 2026: prove conditional mutual-information symmetry
   through `Shannon.condMutualInfo_map_swap12` and
   `Shannon.condMutualInfoOf_swap`.
3. Completed on July 8, 2026: prove finite conditional entropy nonnegativity
   through `Shannon.condEntropy_nonneg` and `Shannon.condEntropyOf_nonneg`.
4. Completed on July 8, 2026: add conditional entropy chain-rule variants
   for joint PMFs and finite-valued random variables.
5. Completed on July 8, 2026: add mutual-information chain-rule variants
   beyond `mutualInfo_chain_rule_fst`, including the sibling
   `I(A;B,C) = I(A;B) + I(A;C|B)` and random-variable forms.
6. Completed on July 8, 2026: prove conditioning-reduces-entropy through
   `Shannon.condEntropy_le_condEntropy_fstThirdMarginal` and
   `Shannon.condEntropyOf_pair_le_condEntropyOf`.
7. Completed on July 8, 2026: add small checked-certificate examples beyond
   submodularity, namely entropy subadditivity and one-variable entropy
   monotonicity.
8. Completed on July 8, 2026: review certificate ergonomics after the new
   examples and add `Certificate.RawCert.sound_of_toCheckedCert?_isSome` to
   remove repeated option-splitting in demo soundness proofs.
9. Completed on July 8, 2026: refresh project notes, future-work notes, and
   website reference artifacts after the completed theorem/certificate phase.

## Completed Manual Certificate Pressure-Test Plan

Current status: all six steps are complete.

1. Completed on July 8, 2026: add the separately importable module
   `LeanInfoTheory.Certificate.ThreeWaySubadditivity`.
2. Completed on July 8, 2026: define the target expression
   `H(A) + H(B) + H(C) - H(A union B union C)` and prove its evaluation
   formula through `Certificate.ThreeWaySubadditivity.eval_expr`.
3. Completed on July 8, 2026: use a manually tagged two-block primitive
   certificate:
   `I(A;B | empty) + H(empty)` and
   `I(A union B;C | empty) + H(empty)`, proving
   `Certificate.ThreeWaySubadditivity.entropy_three_way_subadditivity`.
4. Completed on July 9, 2026: audit the conservative scope. The pressure-test
   module imports only `LeanInfoTheory.Certificate.Checked`, does not change
   the root import, and adds no assumptions, primitive recognition, certificate
   DSL, or finite-family entropy representation.
5. Completed on July 9, 2026: record the pressure-test lessons. The main
   friction was expression normalization in exact decomposition proofs; raw
   step boilerplate and explicit primitive tags are still manageable at this
   scale, and the descriptive theorem name
   `entropy_three_way_subadditivity` is acceptable.
6. Completed on July 9, 2026: refresh public artifacts, add the three-way
   theorem to hand-written theorem highlights, and run the relevant Lean and
   website checks.

### Pressure-Test Lessons

The three-way subadditivity example is the first certificate demo large enough
to say something useful about ergonomics beyond one- or two-step examples.

- Raw-step boilerplate is repetitive but still readable for a four-step
  certificate. It does not yet justify a certificate DSL.
- Explicit primitive tags are verbose but useful for the trust boundary. This
  example does not justify primitive-recognition/autotagging yet.
- Exact decomposition proofs are the first real pain point. The proof needed
  local additive-group normalization for associativity and cancellation after
  expanding the two CMI-plus-empty blocks.
- The theorem naming style remains workable: descriptive names such as
  `entropy_three_way_subadditivity` are clear enough for demo modules.
- The next larger certificate should watch whether expression normalization
  repeats; if it does, a small untrusted or proof-only normalization helper may
  be more urgent than primitive-tag inference.

## Commands After Lean Edits

Use the relevant subset, and run broader checks for shared API or theorem-layer
changes.

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

If Lean declarations or imports change, also refresh and check the website
reference artifacts:

```powershell
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/check_website.py
git diff --check
```
