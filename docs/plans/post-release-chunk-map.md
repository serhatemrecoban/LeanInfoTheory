# Post-Release Chunk Map: Quantitative and Operational Information Theory

**Status:** Long-term map, revision 2, 2026-09-11. C10--C24 remain proposed; detailed C9 revision 2 was separately approved.
**Review follow-up:** C18/C23 clarifications accepted for this map; the 16-chunk structure is unchanged.
**Scope authorization:** This map's original authorization covered planning documentation and references. The separately approved [C9 plan](post-release-chunk-09.md) and eligible step requests own C9 execution.
**Execution:** C9.01--C9.06 are closed. C9.07 cumulative closeout is in preparation; its authorized clean checkpoint, complete routine suite, full fixtures, real current doc-gen, consolidated independent review and closure remain pending. [Maintained handoff](../handoffs/chunk-9.md). No C10 or later implementation is selected.
**Map-intake baseline inspected:** `master` at `80ea016c7ac64bb5bd79b2f769227a3fb2ccc3b3`,
with the existing uncommitted post-release documentation/discoverability work
preserved. The immutable `v0.1.0` mathematical baseline remains
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, Lean/mathlib `v4.33.1`.
**Proposed extent:** 16 chunks, numbered 9--24; each may have many detailed steps.
**Release target:** Candidate second-release programme, provisionally `v0.2.0`;
not a release contract, version bump, date commitment, or publication approval.

## 1. Purpose and approval boundary

The proposed release identity is:

> Finite information measures, quantitative comparison of laws, independent
> blocks, source coding, and channel-capacity foundations.

The programme combines a bounded complementary phase with the five packages
selected for planning by the project lead. It deliberately completes one
operational coding theorem, finite-iid fixed-length almost-lossless source
coding. Channel coding stops at information capacity and a Fano-based weak
converse; achievability is not hidden in the word "capacity".

This map assigns mathematical ownership, dependencies, endpoints, and major
risks. It does not prescribe declaration names, new module filenames, exact
step counts, or every helper lemma. Those choices belong to independently
reviewed detailed chunk plans. C9's current disposition is recorded below;
all later prospective contracts remain proposed, not implemented facts or
approved production statements.

The separately authorized review protocol is now installed; its
[operations](../review-operations.md) remain authoritative. Its setup was an
unnumbered prerequisite to implementation, not a theorem chunk or work
performed by this map. Automation may check and
review; it may not silently approve scope changes, weaken statements, begin
another step, change downstream pins, or publish. A chunk requires its own
approved plan; each implementation prompt remains one approved step unless
the project lead explicitly adopts a different workflow later.

## 2. What the library already supplies

The following are existing source anchors, not proposed replacements:

| Existing foundation | Owning source / examples of verified declarations |
| --- | --- |
| PMFs, finite real masses, support | `Probability/Finite.lean`; `PMF.sum_toReal`, `PMF.bind_toReal_apply`, `PMF.supportFinset` |
| Finite channels as PMF-valued functions | `Probability/FiniteChannel.lean`; `PMF.channelJoint`, `PMF.channelComp`, `PMF.channelJoint_eq_iff_eq_on_support` |
| Algebraic entropy, MI, CMI, chain rules | `Shannon/Entropy.lean`, `Shannon/InfoMeasures.lean`, `Shannon/SemanticBridge/Theorems.lean` |
| Expected self-information | `Shannon/SemanticBridge/Entropy.lean`; `selfInfo`, `entropy_eq_integral_selfInfo`, with the documented zero-mass convention |
| Independent pair products | `Shannon/SemanticBridge/Product.lean`; `indepProd` and its mass/measure bridges |
| Finite dependent families | `Shannon/FiniteFamily.lean` and `Shannon/SemanticBridge/FiniteFamily.lean`; marginal/restriction, chain, and subadditivity APIs |
| Mutual independence and entropy equality | `Shannon/SemanticBridge/FiniteFamilyIndependence.lean`; `familyEntropy_eq_sum_singletons_iff_isMutuallyIndependentFamily` |
| Markov, conditional laws, KL DPI | `Shannon/SemanticBridge/Markov.lean`, `Shannon/SemanticBridge/KL.lean`, `Shannon/SemanticBridge/DataProcessing.lean`; `condMutualInfoOf_eq_zero_iff_isMarkovChainOf` already exists |
| Conditional KL and joint chain rule | `Shannon/SemanticBridge/ConditionalKL.lean`; `klDiv_channelJoint_eq_add_conditionalKlDiv` |
| Concavity and finite-channel convexity | `Shannon/EntropyConcavity.lean`, `Shannon/SemanticBridge/Convexity.lean` |
| Decoding errors and finite Fano | `Shannon/Fano.lean`; `mutualInfo_fano_lower_bound_of_uniform_source` |
| Scalar units conversion | `Shannon/Units.lean`; `natsToBits` |

Paths in this table are relative to `LeanInfoTheory/`; Shannon declarations
live in `LeanInfoTheory.Shannon` unless their namespace is explicitly `PMF`.
The private `familyProduct` in the mutual-independence owner is a product of
the marginals of an already supplied law. It is not a supported public
constructor from arbitrary component PMFs. That distinction motivates C16.

Pinned mathlib source already supplies `PMF.ofFintype`, `stdSimplex`,
`isCompact_stdSimplex`, `Real.continuous_negMulLog`, variance/Chebyshev results,
and `ProbabilityTheory.strong_law_ae_real`. These are reusable ingredients,
not proof that the proposed PMF/topology/AEP bridges are already complete.
Source searches did not identify a ready-made finite PMF TV/maximal-coupling
surface in the inspected owners. Repeat the upstream search at the relevant
chunk's intake, particularly after any separately approved dependency upgrade.

## 3. Proposed chunk sequence

Dependencies below name required inputs beyond the released baseline; a
qualified input means the stated endpoint, not every theorem in that chunk.
C10 and later also require the agreed review protocol and C9's growth-gate
readiness, with separate approval to proceed. The displayed sequence is a
recommended order, not a chain of mandatory whole-chunk dependencies.

| Chunk | Package | Main endpoint | Required inputs beyond the released baseline |
| --- | --- | --- | --- |
| C9 | Complementary | Reviewed generic downstream helpers and growth-ready compatibility gates | Existing library and concrete downstream evidence |
| C10 | 1 | Finite TV characterizations and map/channel contraction | Existing PMF/channel core |
| C11 | 1 | Couplings and maximal coupling with disagreement exactly TV | C10 |
| C12 | 1 | Coupling transport, finite gluing, and composition | C11; existing conditional-channel reconstruction |
| C13 | 2 | Pinsker and bounded quantitative independence consequences | C10; existing KL/DPI |
| C14 | 2 | Quantitative entropy, conditional-entropy, and MI continuity | C10--C11; existing Fano/entropy algebra |
| C15 | 2 | Finite-simplex topology and continuous information objectives | C10 for the TV/topology comparison; pinned convex/topological mathlib |
| C16 | 3 | Finite product laws, iid blocks, restriction/reindexing | Existing family and PMF APIs |
| C17 | 3 | Product channels and memoryless block laws | C16; existing raw channels |
| C18 | 3 | Block entropy/KL additivity and MI single-letterization | C16--C17; existing family/conditional-KL APIs |
| C19 | 4 | Finite-iid AEP and usable typical-set bounds | C16's product mass/support/coordinate laws; pinned probability ingredients |
| C20 | 4 | Fixed-length source codes and one-shot coding bounds | C16; existing decoding-error API |
| C21 | 4 | Complete asymptotic source-coding threshold theorem | C19--C20 |
| C22 | 5 | Finite-channel information capacity, attainment, examples | C15's compactness/continuity; C17 and C18's channel MI bounds for product capacity |
| C23 | 5 | Block channel codes and quantitative/asymptotic weak converse | C17, C18's channel MI bound, C22's capacity API; shared rate conventions agreed with C20 |
| C24 | Integration | Independently qualified second-release candidate | C9--C23 and their approved completion criteria |

The important non-linearities are intentional. C14 does not need Pinsker:
maximal coupling plus Fano is a direct route. C15 can prove qualitative
continuity directly from finite sums and `Real.continuous_negMulLog`; C14 is
an optional quantitative route, not a required prerequisite. Neither is an
AEP prerequisite. C19 needs product mass and support laws, not C18's KL
additivity or memoryless-channel results. Existing entropy/expectation bridges
already identify the single-letter mean.

C22 can follow the relevant C18 endpoints without waiting for source coding.
C23 needs shared code/rate conventions, not C20's source-code one-shot proofs
or C21's source-coding theorem. C12's gluing API is a package endpoint, not a
forced dependency of every later theorem. These distinctions permit reviewed
rescheduling, not automatic partial closeout or progression between chunks.

### C9. Post-release complementary work

**Goal:** Prepare mandatory growth-ready validation, then address a short,
evidence-backed list of generic API gaps without importing application semantics.

**Current disposition:** The separately approved detailed plan delivered all
six growth-gate components and the two selected generic helpers through closed
C9.01--C9.06. Current source contains 603 supported declarations in 31 owners,
with the historical 601-entry baseline, 94 simp names and 92 facade aliases
preserved. C9.07 is preparing cumulative qualification and the
[maintained handoff](../handoffs/chunk-9.md); no final-checkpoint, fresh complete
fixture, real current doc-gen, cumulative review or closure pass is claimed.

The following two bands retain the original bounded planning intake and its
motivation. They are not a second active implementation plan; current authority
and exact completed/pending obligations live in detailed C9 and its handoff.

**Growth-gate preparation.** Before the first new public declaration, address
three different obligations:

1. Historical preservation: the immutable `v0.1.0` source, API baseline, and
   versioned documentation remain unchanged.
2. Compatibility on evolving source: retained declarations and imports still
   satisfy their contracts against the growing library, including signatures,
   assumptions, reviewed attributes, and import boundaries. Checking the old
   checkout alone cannot establish this.
3. Current-surface validation: all new supported declarations and modules
   receive inventory, documentation, trust, attribute, and import checks;
   legitimate growth must not fail solely for exceeding historical counts.

At the original intake, the API-doc checker expected exactly 601 declarations,
and the generator owned a `v0.1` inventory without signatures. C9.01--C9.03
separated current generation, strict retained structural types and exact current
coverage. The historical inventory remains unchanged; current generation never
authorizes import or attribute growth. The original baseline-preservation and
same-name type/assumption requirements are implemented, subject to C9.07's
still-pending cumulative qualification. Record the chosen check's limits: compilation against old statements
does not establish semantic equivalence of changed definitions. Retain explicit
source/API review. Do not prescribe a new fingerprinting framework here. Test
both directions in disposable fixtures: a compatible addition passes, while a
deliberately broken retained contract is detected. C9.04 supplied the first
complete pre-helper qualification; its dated evidence remains distinct from
C9.07's pending final cumulative rerun. This map does not substitute for either
validation point or the approved C9 operating contract.

**Bounded helper intake.** The authorized planning inspection covers the two
named candidates below; it neither authorizes broader PFR extraction nor
requires reopening that limited intake. Detailed statements and implementation
remain subject to approval, and paper-specific structures stay downstream.

- Reproduce and review deterministic-postprocessing independence. The PFR
  project now has `PerfectFunctionalRepresentations.isIndependentOf_comp_right`
  and a concrete canonical-representation consumer; its PMF contract has no
  finiteness or measurable-space premises. Review the lightest proper owner,
  names, attribution if implementation code is reused, and compatibility.
- Review the unconditional entropy/MI decomposition already implemented as
  `PerfectFunctionalRepresentations.mutualInfoOf_eq_pfr_decomposition`:
  `I(Y;Z) = H(Y|X) - I(X;Z|Y) - H(Y|(X,Z)) + I(X;Z)`.
  A generic library formulation should not mention PFR predicates or use a
  paper-specific name. Its structural specialization and perfectness/Markov
  equivalences stay downstream. Existing zero-CMI/Markov facts are not missing.
- Admit other conveniences only from a finite intake list with an actual
  consumer and a search/reproduction record. Do not publish every symmetry,
  recovery, injective-relabeling, or conditional-independence variant.

**Exit:** The accepted helper subset has permanent generic consumers and
focused validation; each rejected/deferred candidate has a recorded disposition;
new APIs can be validated without weakening the released regression baseline.
PFR/ShannonCert repositories and dependency pins are unchanged. This is not a
general cleanup, theorem-search engine, or full naming migration.
An undecided optional helper should not block C10 after the necessary gates
are ready: record its deferral and obtain the appropriate C9 closeout/scope
review. This does not permit leaving an approved required result unfinished,
declaring the chunk complete prematurely, or starting C10 automatically.

### C10. Finite total variation

**Goal:** A small finite-PMF comparison layer independent of entropy and KL.

Use the probability convention `TV(p,q) = (1/2) sum_a |p(a)-q(a)|`, with real
masses and range `[0,1]`. Prove symmetry, separation, triangle inequality,
event characterization with an attaining event, overlap/minimum-mass
characterization, and the bounded-test-function form with explicit constants.
Include deterministic-map and common-channel contraction using existing PMF
maps/binds. Avoid importing a general signed-measure construction solely to
define the finite sum; any measure bridge belongs in an opt-in semantic layer.

**Exit:** These formulations interoperate, including zero masses, equal laws,
disjoint supports, and pure laws; an explicit finite example verifies the
normalization. No topology, general f-divergence hierarchy, or coupling
construction is required yet. Sources: `LP17` 4.1--4.2; `PW24` 7.3.

### C11. Couplings and maximal coupling

**Goal:** A reusable law-level coupling interface and an attaining witness.

A coupling carries a joint `PMF (alpha x beta)` with prescribed pushforward
marginals. Reuse an adequate pinned upstream object if found; otherwise choose
one thin interface over PMF at intake. Do not create independent law- and
random-variable-level probability representations. Include existence via the
independent product, diagonal coupling, symmetry, the disagreement/coupling
inequality on a common alphabet, and a maximal coupling with disagreement
probability exactly TV. Prove the equality for the actual constructed law,
not merely an infimum over hypothetical couplings.

Keep the joint-law constructor and elementary marginal/support laws in the
low-level probability layer. Inspect `PMF.channelJoint p (fun _ => q)` as an
existing lightweight independent-coupling construction. Compatibility with
`Shannon.indepProd`, Fano, and measure semantics belongs in separately importing
bridge modules, not in a back-import from the probability core. Require both a
minimal-construction consumer and a separate semantic consumer; preserve all
stable declarations and avoid a duplicate product representation.

**Exit:** Both marginals and the exact disagreement formula are available to
C14 and downstream finite-TV consumers. Separate the zero-overlap and full-
overlap branches so residual normalization never requires false strict
positivity assumptions. Keep full support unnecessary. Sources: `SA13` I,
Theorems 1--2; `LP17` 4.2; `PW24` 7.3.

### C12. Coupling transport and finite gluing

**Goal:** Make coupling witnesses composable and useful with the existing
channel vocabulary.

Include coordinate-map transport, lifting through supplied coupling channels,
and finite gluing: pair laws on `A x B` and `B x C` with the same `B` marginal
extend to a triple law with both prescribed pairs. Construct the conditionally
independent extension through existing total conditional channels, proving
that arbitrary choices on null middle fibers do not affect the resulting law.
Obtain a coupling of the endpoints by projection. If composition is exposed as
a public operation, supply its identity and associativity contracts under
consistent middle marginals; otherwise keep witness selection private and
publish the gluing theorem. Resolve that choice in the detailed plan.
If the proof uses the heavier Markov reconstruction module, its owner must be
a separately importing semantic bridge, not a dependency of the low-level
coupling constructor. No stable declaration move is presumed.

Composition is not claimed to preserve maximality. Reserve one small regression
for the detailed plan: on a common two-point alphabet, take the first and
third laws uniform and the middle law a point mass. Both adjacent couplings
are maximal, with disagreement `1/2`; their conditionally independent gluing
has independent endpoints and disagreement `1/2`, while endpoint TV is zero.
This is a proposed finite counterexample consumer, not a theorem already
formalized or an additional optimal-transport programme.

**Exit:** A three-law consumer composes couplings and tracks both marginals;
channel transport agrees with C10's contraction surface. This is finite gluing,
not optimal transport, a category library, or process-level coalescence.
Sources: coupling vocabulary in `LP17` 4.2/`PW24` 7.3; construction reconciled
with current project conditional-channel laws.

### C13. Pinsker and quantitative independence

**Goal:** Relate canonical KL and TV without losing the infinite-KL case.

Prove the nats inequality `2 * TV(p,q)^2 <= D(p||q)` with the left side lifted
to `ENNReal`. Derive Real/square-root corollaries only under an explicit
finiteness or support contract. The preferred route is event/binary reduction
via existing KL DPI and a boundary-correct Bernoulli inequality; compare it
with the current log-sum API at intake rather than assuming a proof route.
Specialize to a joint law and the product of its marginals to quantify small
MI as closeness to independence. This is a canonical mathematical consumer,
not a broad stability theory.

**Exit:** Singular support and degenerate Bernoulli cases are tested; a
`top.toReal = 0` false corollary is impossible. Reverse Pinsker, optimal joint
ranges, other divergences, and refined constants stay deferred. Source:
`PW24` 7.4, Theorem 7.10; existing MI-as-KL bridge.

### C14. Quantitative continuity of information measures

**Goal:** Convert joint-law closeness into explicit information bounds.

For a common alphabet of size `m >= 2`, use maximal coupling and existing Fano
to prove `|H(p)-H(q)| <= h(delta) + delta * log(m-1)` at exact
`delta = TV(p,q)`. Also supply a usable monotone modulus for `TV <= epsilon`:
use that expression on `[0,1-1/m]` and `log m` above the threshold; handle
singleton alphabets separately. Do not substitute an upper estimate into the
non-monotone exact-distance expression without its range condition.

Derive bounded finite-alphabet conditional-entropy and MI continuity from
joint/marginal entropy identities and TV contraction. Explicitly name the
alphabet sizes controlling each bound. Continuity under close joint laws does
not assert pointwise continuity of every conditional PMF at a null fiber.
Tighter conditioning-alphabet-independent constants and CMI wrappers are
optional only after a concrete consumer and scope review.

**Exit:** A law-approximation consumer controls H, conditional H, and MI;
zero-distance, threshold, and singleton tests pass. The initial contract does
not demand every best-known continuity bound. Source: `SA13` II, Theorem 3;
the derived conditional/MI forms must record their algebraic derivation.

### C15. Finite-simplex topology and optimization readiness

**Goal:** A minimal bridge between finite PMFs and existing finite-dimensional
topology, sufficient for maximizing mutual information later.

Relate PMFs to the real standard simplex; reconcile existing subtype/topology
instances before adding any new instance. Prove the agreement of coordinate
and TV convergence on a fixed finite alphabet, compactness, and continuity of
the finite channel-output map and entropy/conditional entropy/MI objectives.
Include the fixed-channel input objective that C22 will optimize, including
boundary distributions with zero masses. Reuse `stdSimplex` and continuity of
`negMulLog`; do not make a parallel bundled probability representation.

**Exit:** An independent consumer applies an existing compact-extremum theorem
to the actual finite-channel MI objective. General minimax, constrained
optimization, global KL continuity, and KL lower-semicontinuity are not needed
to establish finite-channel attainment. Sources: `PW24` 4.5, Proposition 4.8
(entropy), and 4.7, Proposition 4.13 (MI); 5.1--5.2 for optimization context;
pinned mathlib convex/topological owners for compactness.

### C16. Finite products and iid block laws

**Goal:** Construct independent laws from component PMFs and manipulate their
coordinates without duplicating finite-family semantics.

Use finite dependent function types for the general product and `Fin n -> A`
for homogeneous blocks. Provide normalized atom/support laws, empty and
singleton products, coordinate marginals, restriction, equivalence reindexing,
and splitting/concatenation. Iid blocks are a specialization of the product
constructor, not a second implementation. Bridge to `FamilyOutcome` and
`familyMarginal` through existing equivalences. Reuse the private product
proof ideas only after reviewing the correct lightweight ownership.
The constructor and elementary atom/support/marginal/transport laws must not
import Shannon mutual independence merely to prove their compatibility with
it. Put those compatibility theorems in a separately importing bridge and
check low-level and semantic consumers independently. Coordinate independence
needed for C19's probability argument must be reachable without requiring
C18's information inequalities; the measure/variance bridge itself belongs
to C19 unless earlier concrete consumers justify it.

**Exit:** Consumers construct both heterogeneous products and iid blocks,
restrict/reorder/split them, and obtain the existing mutual-independence and
family interfaces. A general infinite product or a new global independence
predicate is outside scope. Sources: `PW24` 6.1/11.2; existing family modules.

### C17. Product channels and memoryless extensions

**Goal:** Construct block channels independently of the input distribution.

From coordinate channels build the product-valued PMF channel and its iid
specialization. Prove atom, support, coordinate marginal, block restriction,
composition, and deterministic-channel laws needed by C18/C23. The input law
may be arbitrarily correlated: memorylessness constrains the channel given
the input, not the input itself. Provide exact joint-law compatibility for
independent inputs and with the existing `PMF.channelJoint`/`channelComp` APIs.

**Exit:** Both independent and correlated input consumers use the same raw
PMF-valued-function channel, with zero/one-length block behavior checked.
No matrix-as-channel replacement, feedback channel, or process constructor.
Sources: `PW24` 6.1 and 19.1; Future Work Note 31 ownership constraints.

### C18. Block information and single-letterization

**Goal:** The reusable information identities and bounds needed for coding.

- Entropy of a finite independent product is the sum of coordinate entropies,
  with iid specialization `H(p^n) = n * H(p)`; reuse the family equality API.
- KL of finite products is the sum of coordinate KL divergences in `ENNReal`;
  give Real forms only with the required support/finiteness assumptions.
  The empty product and `n = 0` do not justify unguarded Real conversions.
- For a memoryless channel, conditional output entropy is the sum of the
  coordinate conditional entropies even for correlated inputs. Derive
  `I(X^n;Y^n) <= sum_i I(X_i;Y_i)` and equality for independent input-output
  pairs. Iid input/channel gives the single-letter MI multiple.
- Preferred optional refinement during detailed C18 planning: expose the exact
  gap for the same memoryless law, still allowing correlated inputs:
  `sum_i I(X_i;Y_i) - I(X^n;Y^n) = sum_i H(Y_i) - H(Y^n)`.
  The planned conditional-entropy identity cancels the conditional terms.
  With the existing finite-family entropy-additivity characterization, this
  yields `I(X^n;Y^n) = sum_i I(X_i;Y_i)` exactly when the output coordinates
  are mutually independent, not merely pairwise independent. Independent
  inputs or input-output pairs are sufficient, not necessary; constant-output
  channels can attain equality even for correlated inputs. Prefer deriving
  the bound and equality criterion from the exact gap if the representation
  bridges fit the planned proof naturally. This is not an additional required
  endpoint, a new total-correlation definition, or a separate theorem programme.
- Include the complementary finite independent-source inequality
  `sum_i I(X_i;Y) <= I(X^n;Y)` where its general finite observation contract
  fits the existing family chain rules. Do not impose product conditional
  laws on this different statement.

**Exit:** A correlated-input example rules out an accidental iid premise in
the channel bound; singular-product KL and empty/singleton blocks are covered.
Capacity additivity belongs to C22, not this chunk's as-yet-undefined capacity.
Sources: `PW24` 6.1, Theorem 6.1; existing family and conditional-KL APIs.

### C19. Self-information, finite-iid AEP, and typical sets

**Goal:** A usable probabilistic AEP, not just the identity `H(p^n)=nH(p)`.

Reuse `selfInfo` and `entropy_eq_integral_selfInfo` from the existing entropy
semantic bridge; add only the finite expectation/variance and block identities
actually needed. Write `p^n` for C16's iid law and `L_n(x) = selfInfo (p^n) x`.
The required AEP contract is: for every `epsilon > 0`,

```text
Pr_{p^n}[abs(L_n / n - H(p)) >= epsilon] -> 0  as n -> infinity.
```

Here `Pr` is the real event probability under the corresponding finite block
law. This is a limit of numbers over varying finite sample spaces, not an
assertion requiring all block random variables on one fixed probability space.
Normalized finite-block statements require `n > 0`.

The preferred Chebyshev feasibility target is

```text
Pr_{p^n}[abs(L_n / n - H(p)) >= epsilon]
  <= Var_p(selfInfo p) / (n * epsilon^2),   n > 0, epsilon > 0.
```

The detailed plan must connect coordinate independence and square-integrability
to the selected variance theorem, using a focused PMF/measure bridge or finite-
sum calculation. Pinned mathlib's pairwise-independent variance-of-sum API is
one candidate; a general indexed-independence or stochastic-process development
is not required. Finite alphabets give the needed integrability, but its Lean
bridge still needs proof. A different approved proof route may establish the
AEP contract without making this quantitative bound a separate release endpoint.

Prove `L_n = sum_i selfInfo p (x_i)` only on block support, or almost everywhere.
Because `selfInfo` is zero at impossible atoms, this is not a valid unrestricted
identity for every ambient word; include a zero-mass regression. Retain a
strong-law route only if it demonstrably simplifies the proof without changing
the finite-block contract. An infinite trajectory PMF is not a prerequisite.

Define weak typical sets with explicit support or positive-mass constraints.
Lean's total real logarithm at zero must not admit impossible words. Prove
probability tending to one, per-word exponential mass bounds, the upper
cardinality bound, and the probability-weighted lower cardinality bound.
Separate blocklength zero from normalized statements.

**Exit:** The exact typical-set bounds consumed in C21 are ready; deterministic
sources and zero-probability alphabet symbols require no full-support premise.
No entropy rates, stationary ergodic AEP, strong typicality, method of types,
or exponential convergence rate is promised. Sources: `CT91` 3.1--3.3;
`PW24` 11.2, Proposition 11.6.

### C20. Fixed-length source codes and one-shot bounds

**Goal:** A small operational coding interface with finite one-shot theorems.

Represent compression by an encoder `A^n -> Fin M` and a total deterministic
decoder `Fin M -> A^n`, with `M >= 1`. Correct decoding is required only on
the success set, not globally. Reuse the existing decoding-error semantics;
do not demand encoder injectivity on all source words. Establish the success-
set cardinality bound and construction from any set of at most M words.
Use the source law's nonempty alphabet, or an explicit nonemptiness premise
for law-free constructions, to supply the total decoder's fallback.
Derive threshold/counting one-shot achievability and converse inequalities,
including integer rounding, for later asymptotic use.

Keep the one-shot interface independent of AEP. For an arbitrary finite law q,
a set T, and a code with at most M correctly decoded words, use the forms
`P_success <= q(T^c) + M*b` whenever every atom of T has mass at most `b >= 0`,
and `exists code, P_error <= q(T^c)` whenever `card T <= M`. Correct decoding
outside T is allowed; do not replace the last inequality with a false equality.
C21 substitutes the typical set and its mass/cardinality bounds.

Define rate by `log M / n` for positive n, with bits-facing conversion through
`Shannon.Units`. A codebook of M indices and a binary string of k bits have
different exact cardinality contracts; prove the bridge instead of writing
`Fin (exp(nR))`. Share only genuine rate/error utilities with C23, not a large
abstract coding framework. Standard non-erasure decoding is the proposed
primary model; explain its relationship to PW24's detectable-erasure model.
Agree on the shared meanings of integer message size, positive-blocklength
rate, code sequence, and eventual/asymptotic rate bounds before freezing C21
or C23's detailed plans. Keep source and channel codes distinct; share only
the needed rate/error utilities. Section 4 records the cross-chunk contracts.

**Exit:** Explicit finite encoders/decoders, a nonzero-error example, and both
one-shot inequalities compile without AEP. No Huffman/prefix/Kraft-McMillan,
random coding, computable compression algorithm, or erasure API is required.
Sources: `PW24` 11.1; existing Fano error definitions.

### C21. Complete finite-iid source coding

**Goal:** Finish the fixed-length, asymptotically almost-lossless theorem.

For every finite source p and every `R > H(p)`, construct a sequence of codes
with errors tending to zero and `limsup r_n <= R`, where `r_n = log M_n / n`.
For any sequence with an eventual rate bound `r_n <= R < H(p)`, prove the
strong source converse: error tends to one. This also covers extended-real
`limsup r_n < H(p)` by choosing an intermediate R.

Separately prove that vanishing error implies, for every `delta > 0`,
eventually `r_n >= H(p) - delta`, equivalently `liminf r_n >= H(p)` in the
extended reals. This includes oscillating or unbounded source-code rates;
do not assume convergence or an unnecessary upper bound. Express primary
contracts through eventual bounds or extended-real limits, not an unguarded
conditionally complete Real limsup/liminf. Derive the entropy threshold for
the same code model, without replacing sequences by single-block claims.

The shared strong-converse input is the specialization of C20's one-shot bound:

```text
P_success,n <= Pr_{p^n}[T_{n,epsilon}^c]
               + M_n * exp(-n * (H(p) - epsilon)).
```

Here T is C19's support-restricted typical set. Its probability tends to one,
and the second term vanishes when the rate gap exceeds epsilon. The analogous
achievability consumer uses C19's upper cardinality bound and C20's construction
from T. No broader information-spectrum API is needed.

The source strong converse is included because the C19 typical-set mass bound
and C20 success-set cardinality argument already provide its natural route.
It does not imply a channel strong converse. Treat `H(p)=0`, singleton
alphabets, and actual message-cardinality rounding. No universal assertion at
exact fixed rate `R=H(p)` or error exponent is part of this contract.

**Exit:** Achievability and converse concern the same code model and rate
units; a top-level theorem and consumer demonstrate the full operational
threshold. Do not call the package complete after typicality alone. Sources:
`CT91` 3; `PW24` 11.1--11.2, reconciled to the chosen total-decoder model.

### C22. Finite-channel information capacity

**Goal:** A usable optimization quantity with an attained maximum.

For finite channels with nonempty input alphabet, define information capacity
as the supremum of the existing `I(p,W)` objective and prove that it is attained.
Nonempty output follows when such a channel and an input exist; state any
explicit instance assumptions transparently. Include nonnegativity, alphabet
bounds, relabeling/postprocessing properties, product-channel additivity and
the memoryless n-fold specialization. Reuse C15 compactness and continuity,
existing input concavity, and C18's correlated-input bound.

Selected example endpoints: noiseless and input-independent channels, the
binary symmetric channel, and the binary erasure channel, including their
degenerate parameters. Prove the capacity values and achieving inputs; simply
evaluating MI at a candidate input is insufficient. Retain nats with explicit
bits conversions. Do not silently generalize finite existence to infinite
alphabets or constrained distributions.

**Exit:** The maximum is a theorem about the actual channel objective, and
the examples verify both upper bounds and attainment. This is information
capacity; equality with operational channel capacity awaits achievability in
a later programme. Sources: `CT91` 8.1--8.3; `PW24` 5, 6.1, 19.3.

### C23. Channel codes and Fano weak converse

**Goal:** Convert the capacity bound into an operational limitation.

Define deterministic block encoders `Fin M -> A^n` and decoders
`B^n -> Fin M` for the memoryless channel, with uniform message law and average
block error and `M >= 1`. Do not assume iid codewords or an injective encoder.
Build the message/input/output joint law, expose its Markov/data-processing
relations, and identify the error with the existing Fano quantity. Reuse C20's rate and
cardinality conventions without conflating channel and source encoders.

Derive the finite-block bound
`(1-Pe) * log M <= n * C(W) + log 2`, then prove that vanishing-error code
sequences have, for every `delta > 0`, eventually `r_n <= C(W) + delta`, and
hence `limsup r_n <= C(W)`. Derive any eventual boundedness required for a
Real-limsup proof from this finite inequality and vanishing error itself;
do not assume bounded or convergent code rates merely to ease the limit proof.

Distinguish two above-capacity contracts. An eventual bound `r_n >= R > C(W)`
gives `Pe_n >= 1 - C(W)/R - log(2)/(n*R)` eventually, hence an eventual positive
error obstruction. For arbitrary code sequences, use the explicit premise
that some fixed `eta > 0` satisfies `r_n >= C(W) + eta` infinitely often.
Equivalently, use `limsup r_n > C(W)` in the extended reals, not an
unguarded Real-limsup convention: these sequences may have unbounded rates.
This weaker premise gives a subsequential obstruction to vanishing error,
not necessarily an eventual lower error bound. Eventual boundedness derived
in the vanishing-error implication is not a hypothesis here. The positive
denominator follows from `R > C(W) >= 0`. Keep the undivided inequality
meaningful at M=1 and handle n=0 separately.

**Exit:** The bound applies to arbitrary deterministic codes, including a
correlated codeword distribution. No channel achievability, error-to-one
strong converse, maximal-error equivalence, feedback, or cost constraints are
claimed. Sources: `CT91` 8.5/8.9; `PW24` 17/19 coding conventions; existing
uniform-source Fano theorem and C18.

### C24. Programme integration and release qualification

**Goal:** Qualify the completed mathematical surface as a library release
candidate, with no new theorem programme hidden in cleanup.

Audit every agreed endpoint against source and independent consumers, including
coupling-to-continuity, correlated-input single-letterization, full source
coding, attained information capacity, and the weak channel converse. Run the
maintained builds, trust/API/import/simp and compatibility checks, examples,
generated references, independent review, and candidate documentation gates.
Keep per-chunk documentation current throughout; this is final reconciliation,
not a reason to defer all examples or testing until the end.

Preserve the exact `v0.1.0` release and versioned website route. A proposed new
version, current/stable API documentation split, migration notes, and release
metadata need their own reviewed contract. Test an external consumer of the
candidate without silently upgrading PFR or ShannonCert. Prepare concise
contributor guidance if broader outreach is selected; no website redesign or
automatic publication. Actual commit/push/tag/release/Pages/DOI actions remain
subject to explicit authorization.

**Exit:** Independent review reports a qualified candidate and clearly states
any unresolved limitation. Publishing is a subsequent decision, not an
automatic effect of completing C24.

## 4. Architectural and mathematical contracts across chunks

- Canonical probabilities remain PMFs, channels remain PMF-valued functions,
  and information quantities remain nats. TV uses the half-L1 normalization.
- Generic finite probability constructions belong below Shannon semantics.
  Topology, KL, asymptotics, and coding stay opt-in. Preserve the lightweight
  root; review any proposed extension of the full Shannon umbrella explicitly.
  Constructors and elementary probability laws must not back-import Shannon
  semantics; separately importing bridge modules supply the semantic consumers.
  Test both import directions explicitly. No new module path in this map is
  asserted to exist, and no stable declaration relocation is presumed.
- Use finite dependent products internally with a convenient `Fin n -> A`
  block view. Reordering, restriction, and concatenation have explicit law
  equalities, not casts embedded in every later theorem statement.
- Preserve support-aware and null-fiber contracts. Probability-one arguments
  do not justify claims for zero-mass atoms. Finite alphabets do not imply
  finite KL between arbitrary laws.
- Coding defaults to deterministic maps and average block error, with
  integer-valued sizes and positive blocklength when normalized. Existential
  encoders are not automatically efficient executable algorithms.
- Proposed additions must preserve the released API unless a separately
  approved minor-release migration is necessary. Do not upgrade Lean/mathlib
  merely because a newer upstream implementation might exist.
- Sharpness is local to selected contracts: exact maximal-coupling equality,
  the selected entropy-continuity bound, and exact source/capacity endpoints.
  It is not a blanket promise of optimal constants for every derived wrapper.

### Cross-chunk consumer contracts

These are interface obligations, not proposed declaration names. Resolve each
before freezing the producer/consumer detailed plans; record permanent consumer
locations and actual validation when implemented, rather than marking this
table complete from documentation alone.

| Producer -> consumer | Contract to exercise |
| --- | --- |
| C11 -> C14 | Joint PMF on a common alphabet with both exact marginals and disagreement equal to TV; minimal construction import and separate Fano consumer, including equal laws and singleton cases. |
| C16 -> C18 | Product masses, coordinate marginals, restriction/reindexing, and pair/family-law compatibility; semantic independence does not become a constructor import. |
| C16 + existing entropy bridge -> C19 | C16 supplies product mass/support/coordinate laws; C19 supplies supported block-log additivity and the focused independence/integrability bridge to variance, reusing the existing single-letter mean identity. |
| C19 + C20 -> C21 | The same typical-set convention, atom mass/cardinality bounds, success-set cardinality bound, and code construction; derive the displayed one-shot success bound and vanishing-error construction. |
| C15 + C17/C18 -> C22 | Compact finite input domain, continuous actual channel-MI objective, and the upper MI bound for correlated inputs; maxima and product-capacity bounds use these same objects. |
| C17 + shared C20 rate conventions + C18/C22 -> C23 | Code-induced message/input/output law, exact agreement with existing decoding error, Markov/DPI access, correlated-input single-letterization, and common rate/limit conventions. |

The concrete code-sequence and limit representations are chosen during detailed
planning, not independently invented by C21 and C23. Uniform-message average
channel error is not source-law decoding error under a renamed encoder.

## 5. Future-work reconciliation

This map schedules consideration or a bounded slice of an existing note; it
does not close a note merely by mentioning it. The canonical numbered register
remains in `project-log.md`, and this map owns the detailed chunk assignment.

| Register owner | Proposed treatment |
| --- | --- |
| Note 25 | C9 has real PFR evidence for deterministic-postprocessing independence; other closure/degeneration forms remain consumer-triggered. |
| Note 31 | C17 supplies planned product-channel consumers. Review the raw-PMF versus Shannon ownership before introducing the constructor. |
| Note 29 | C14 and C23 reuse Fano; C23 addresses its coding-application slice. General Fano equality, randomized estimators, and list decoding stay deferred. |
| Note 5 | C20--C23 address a fixed-length coding slice only; Kraft-McMillan and variable-length coding remain open. |
| Unnumbered quantitative/block backlog | C10--C19/C22 allocate finite TV/coupling, Pinsker, continuity/topology, tensorization, AEP, and capacity. None is implemented by this allocation. |
| Note 1's historical follow-ups | C16/C18 may create pressure for marginal/restriction or finite-product independence bridges; the closed original finite-family task stays closed. |
| Notes 19, 21, 22, 27, 30, 32--37, 40 | Reconsider only where concrete proofs hit the recorded trigger; no blanket promotion in C9. |
| Notes 9, 10, 14--18, 28 | Naming, validation, examples, and generated documentation accompany each chunk; growth-aware gates begin in C9 and final qualification is C24. Contributor outreach and expensive blueprint work remain separate choices. |
| Notes 38--39 | Matrix/majorization and canonical/minimal sufficiency are not prerequisites here; remain deferred. |
| Downstream notes 7, 11--13 | Certificate-specific work stays in ShannonCert; PFR-specific structures stay in PFR. |

Outside this programme: channel achievability, channel strong converse/error
exponents, stationary/ergodic AEP, entropy rates, method of types, prefix and
universal coding, Slepian--Wolf/network/rate-distortion theorems, general
measurable coupling/optimal transport, countable-alphabet continuity, broad
f-divergence/reverse-Pinsker theory, general minimax, and matrix/minimal-
sufficiency developments. These exclusions prevent scope drift, not permanent
rejection. Existing owners remain authoritative; do not create duplicate notes
for each excluded theorem family.

## 6. Chunk planning, validation, and revision

Before approving each detailed chunk plan:

1. Recheck its dependency endpoints in actual source and current upstream APIs.
2. Lock proposed public contracts, assumptions, source IDs, and module/import
   ownership. Resolve any change in code, topology, units, or witness semantics.
3. Test the riskiest proof boundary with a focused, proof-complete disposable
   feasibility probe where needed, under a separate planning authorization.
   Elaboration alone is not evidence that a hard theorem is feasible.
4. Include permanent mathematical consumers, edge cases, per-step validation,
   naming/simp review, documentation reconciliation, and independent closeout.
5. Stop if the result requires a materially stronger hypothesis, new abstraction,
   dependency upgrade, missing prerequisite, or changed completion claim.

The highest-risk planning gates are retained-contract checks on growing source
in C9, residual normalization in C11, finite
gluing/null-fiber composition in C12, boundary Pinsker in C13, PMF topology in
C15, dependent product transport in C16--C18, finite-block probability/LLN in
C19, rounding and code-sequence quantifiers in C20--C21, and correlated-codeword
single-letterization in C23. These gates belong at intake, before many later
steps rely on an unproved contract.

Keep the current 16 chunks, but require bounded internal checkpoints for the
largest ones: C18 separates product entropy/KL from channel MI; C19 validates
its probability bridge before typicality; C22 separates capacity/attainment
and product theory from the four concrete channel examples. None of these
bands is automatically a new step ID. If detailed feasibility or proof scope
justifies splitting a chunk, seek a plan-health decision then. Do not preserve
the number 16 at the cost of an incoherent plan, or drop the BSC/BEC examples
to make a chunk appear finished.

After every chunk, record actual delivered results separately from proposals,
update the log at meaningful milestones, reconcile the living summary and
applicable future-work notes, and run independent validation against the
approved completion criteria. Review the remaining map at package boundaries
and whenever a dependency changes, including the release-size calibration
below, especially after C15 and C18. Automation must bind evidence to a precise
source state; a green build or a reviewer response alone is not permission to
advance.

Keep IDs stable after approval. Reorder independent chunks by explicit review;
do not silently recycle completed IDs. If a chunk must split, document the new
IDs and dependencies and retain the original disposition. Internal proof-route
changes preserving the approved contract need an outcome note; changes to
public semantics, assumptions, scope, architecture, or release endpoints need
project-lead approval. Intermediate releases/checkpoints remain possible, but
must state honestly which packages are incomplete.

### Release-size calibration

Treat the review's "roughly twice the first release" objective as a calibration
of reusable mathematical content, not a declaration quota. The frozen baseline
has 601 supported declarations; approximately 1,200 in the next release is one
rough numerical cross-check. Sixteen chunks, including integration and tooling,
do not by themselves establish that scale.

The following are deliberately broad planning estimates, not measured output,
statistical confidence intervals, approved budgets, or promises. They count
potential new substantive public definitions/theorems, excluding thin wrappers,
aliases, private proof machinery, and non-stable examples. Upstream reuse and
the granularity of the eventual API can change them substantially.

| Package | Reusable mathematical growth | Rough substantive additions |
| --- | --- | --- |
| Complementary C9 | Accepted generic helpers; tooling contributes no mathematical count | 0--10 |
| 1: C10--C12 | TV characterizations/contraction, couplings, maximality, finite gluing/transport | 60--120 |
| 2: C13--C15 | Pinsker, finite information-continuity bounds, simplex/topology bridges | 40--100 |
| 3: C16--C18 | Product/block laws and channels, transport, additivity and MI bounds | 70--140 |
| 4: C19--C21 | Finite AEP, typicality, source-code interface and complete coding theorem | 60--120 |
| 5: C22--C23 | Attained information capacity, standard examples and channel-code converse API | 50--110 |
| C24 | Integration, review, documentation and qualification, not another theorem family | No separate growth allocation |

This suggests roughly 280--600 substantive additions. Perhaps another 50--150
justified convenience/compatibility declarations would put the total supported
surface near 930--1,350 including the retained 601, but these estimates are too
uncertain to certify a doubling. Wrappers and aliases must be reported
separately, never manufactured to reach 1,200. Private lemmas, duplicate exports,
test declarations, and integration work do not establish mathematical breadth.

At package-boundary reviews, especially C15 and C18, compare actual supported
growth, distinct delivered theorem families, downstream usefulness, and revised
remaining effort with this envelope. Use the current-surface parser developed
in C9 for counts, supplemented by a human classification of mathematical
content. If the programme is materially smaller or larger than intended, report
the evidence to the project lead. Do not add filler, silently expand scope, or
drop the source-coding/capacity/converse endpoints to adjust the count.

## 7. Evidence and remaining uncertainty

The map is grounded in current Lean definitions and assumptions, the released
API contract and growth-sensitive scripts, targeted Future Work Notes,
the local PFR generic-helper consumers, and selected sections of the sources
registered in [the mathematical reference register](../references.md).
No unrelated third-party information-theory formalization repository was
consulted; local PFR was inspected read-only as requested downstream evidence.

Revision 1 planning verification distinguished existing compiled facts from
future proof ingredients. A focused umbrella-import probe checked the current channel,
Markov, family-independence, conditional-KL, Fano, and units anchors. The
simplex and probability-limit candidates were inspected in pinned mathlib
source; an attempted combined probe stopped at a missing local
`Mathlib.Probability.Moments.Variance` compiled artifact. No build failure in
the existing library or proof of a new theorem is inferred from that cache
limitation. Their owning chunks must compile the selected upstream imports
and prove the required bridges during feasibility review.

Revision 2 rechecked the relevant source contracts and selected PW24 source-
coding/AEP pages. Static/documentation validation, all five README consumers,
local links, source paths, chunk/dependency consistency, and calibration
arithmetic passed. The C12 counterexample was checked with exact rational
arithmetic, not formalized in Lean. No new proof-feasibility spike or full
clean-checkpoint build was undertaken for this documentation revision.

This is not a full proof feasibility audit or an independent implementation
review. Coupling interface shape, the PMF/simplex instance strategy, the precise
finite expectation bridge, source-rate predicates, detailed module names, and
step counts remain for their owning chunk's approved plan. No production Lean
source, dependency, workflow, immutable release artifact, downstream project,
or public website is changed by adopting or revising this document.

## 8. Revision 2 review dispositions

The project lead supplied an advisory review from Technical Discussion -
LeanInfoTheory and authorized selective documentation revisions. That review
assessed mathematical scope/interfaces; it did not reproduce local validation
or audit the reference register. Revision 2 reconciles it with the General
Assistant self-review. The five-package direction and C9--C24 IDs are retained;
no production statement, implementation step, or automation is approved here.

| Independent-review suggestion | Disposition |
| --- | --- |
| 1. Release-size calibration | **Accept with modification.** Section 6 adds uncertain package-level estimates and a roughly 1,200-declaration cross-check, not a quota or a claim that the programme already doubles the library. Reassess after C15/C18 and other package boundaries. |
| 2. C9 compatibility and helper intake | **Accept.** Separate historical preservation, evolving-source compatibility, and current-surface checks; separate the mandatory gate from optional helper decisions. The bounded mechanism and positive/negative fixtures are deferred to detailed C9 implementation planning. Existing limited PFR inspection is preserved; broader extraction is not authorized. |
| 3. Constructors versus semantic bridges | **Accept.** C11/C12/C16 and Section 4 make the import direction testable through distinct low-level and semantic consumers, without moving stable declarations or duplicating PMFs. |
| 4. Finite-block AEP contract | **Accept.** C19 states varying-space event-probability convergence, support-restricted log additivity, and a Chebyshev feasibility target. The minimal probability bridge and optional quantitative bound are settled in its detailed plan, not implemented now. |
| 5. Coding interfaces and quantifiers | **Accept.** C20/C21/C23 and Section 4 specify the one-shot handoff, shared rate conventions, source liminf guarantee, derived channel-rate boundedness, and eventual versus subsequential error obstructions. |
| 6. Maximality under composition | **Accept; defer the Lean regression to C12.** Record the two-point counterexample without adding an optimal-transport theorem or claiming it is already formalized. |

Self-review items 1, 2, 4, 5, and 6 overlap independent items 2--5 and are
incorporated there rather than duplicated. Self-review item 3 is accepted:
Section 3 now separates required endpoints, optional proof routes, and display
order. Item 8 is accepted through the cross-chunk consumer table. Item 7 is
accepted with modification: keep the chunk count for now, add internal
checkpoints, and defer any split decision to evidence-based detailed planning.

The review's praise of the existing exact-TV modulus, null-fiber handling,
infinite KL, correlated inputs, integer code sizes, and information/operational
capacity distinction is **already covered**; those protections are retained,
not replicated as new tasks. Reference registration remains as completed in
revision 1; this review introduces no new reference source or full-book audit.

### Second-review follow-up

The second advisory review endorsed revision 2's high-level structure and
suggested two narrow mathematical refinements. On 2026-09-11 the project lead
authorized incorporating them without starting implementation or C9 planning:

- **C23: accept the contract clarification.** Use the fixed-positive-gap,
  infinitely-often premise for arbitrary above-capacity sequences, equivalently
  an extended-real limsup. Keep it distinct from the vanishing-error implication
  where eventual boundedness is derived, not assumed.
- **C18: accept as a preferred optional refinement.** Consider the exact MI gap
  and output-mutual-independence equality criterion within the planned proof,
  reusing the existing family equality theorem. Representation compatibility
  remains for detailed C18 planning; no new definition or required endpoint is
  added, and no Lean proof of the proposed identity is claimed here.

These notes do not change the topic selection, chunk count, internal
checkpoints, or future-work assignments. The next activity is separately
reviewed review-protocol design, awaiting the project lead's instructions;
neither protocol setup nor detailed C9 planning is started by this revision.
