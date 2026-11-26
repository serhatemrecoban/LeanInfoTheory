# Release 3 chunk map: finite statistical decisions and fundamental coding theorems

**Planning reference, revision 3, 2026-11-05.** The lead selected all six mathematical packages and their preferred order. The allocation remains proposed, not an approved implementation plan, version number, release date or declaration quota. Stable baseline: published [v0.2.0](../releases/v0.2.0-publication.md), commit `953b785fbdbcc9bffe22834124d5e1cbd14a4835`. It already delivers fixed-length almost-lossless source coding, attained *information* capacity, block-code laws and a channel weak converse. Do not reimplement those or describe prefix coding as the first source-coding theorem.

## Reading and revising this map

Use this map as C9--C24 used the [previous map](post-release-chunk-map.md): to agree on what downstream work can rely on, not to prescribe every proof. A **required handoff** is a mathematical capability; named modules, estimates, proof routes and examples below are guidance unless adopted in the detailed plan. Sixteen chunks happen to fit the interfaces, not the other way around. No detailed C25 plan or execution is started here.

Each chunk thread should recheck the incoming handoff against actual Lean source and a meaningful consumer; choose its own steps, imports, names, proofs and validation; and obtain approval before implementation. During execution, revise local steps, split difficult work, or replace a proof route when justified. Record why, what prior evidence still applies, and what downstream plans need to change. Use the supported plan-revision procedure where required; do not rewrite an approved hash or retrospectively change acceptance. Ask the lead before changing an endpoint, strengthening its hypotheses, changing public semantics/architecture, or dropping a package. Update this map at package boundaries when reality differs. Preserve completed IDs and historical dispositions; no automatic next step or publication.

| Package | Proposed chunks | Endpoint for users |
| --- | --- | --- |
| 1. Finite statistical decisions | C25--C26 | Evaluate two errors, attain the TV optimum, and use a most-powerful test at a prescribed level. |
| 2. Information density and one-shot coding | C27--C30 | Relate a true pair to an independent pair; obtain concentration and an explicit finite-block error guarantee for an actual code. |
| 3. Noisy-channel coding | C31--C32 | Operational capacity equals information capacity; sufficiently reliable subcodes also work for nonuniform messages. |
| 4. Source-channel separation | C33--C34 | One channel use per source symbol: direct theorem below capacity and impossibility above it. |
| 5. Variable-length source coding | C35--C36 | For a finite source, optimal expected binary prefix length lies between entropy in bits and entropy plus one. |
| 6. Method of types | C37--C39 | Construct empirical laws and type classes, bound their sizes, and bound their iid probabilities including singular cases. |
| Integration | C40 | Independently qualify one exact candidate, exercise package interfaces, and hand off to a separate release decision. |

Default order is the table order. C35--C36 and C37--C39 can move earlier independently; neither blocks channel achievability. Statistical testing is first because it needs only elementary finite probability and offers a language for decoding, not because channel coding requires the full Neyman--Pearson optimality proof. Seek a representative lab use case at C25 intake if available; do not block on a reply, publicize private material, or build a lab-specific API.

## Before the first supervised chunk

The installed [review operations](../review-operations.md) and [adapter](../../tools/lit_review/project.py) recognize C9--C24 in chunk IDs, step IDs and storage paths. C25 cannot simply bind under an old ID. Separately authorize and independently check a bounded workflow extension **before** trying formal C25 plan review or execution. Test a new ID from binding through scoped closure in fixtures, refusal of an invalid ID or wrong predecessor, and unchanged access to historical records. Do not generalize C24-specific exceptions or transfer its reviewer. Use an explicit bootstrap decision, not a step whose review presupposes the change.

**Test what the reviewer actually reads.** The adapter's request renderer currently lists the earlier chunk map in `context_documents`. In isolated fixtures render the actual source-bound PLAN and STEP request text for C25 and C40; assert the programme reference is `docs/plans/release-3-chunk-map.md` and the exact chunk-specific plan/criteria remain the authority. Render C24 as a historical control: its reference must still be `docs/plans/post-release-chunk-map.md`. A successful bind/close or a unit test of a path selector alone cannot catch incorrect reviewer context. Do not dispatch real reviews or rewrite old requests for this test.

Before the first public API addition, settle the development validation policy. The [published validator](../../scripts/validate_published.py) and [complete candidate checker](../../scripts/check_candidate_api_compatibility.py) protect particular release inputs and an exact surface. Establish how to compare all 811 released declarations on evolving source **while accepting reviewed additions**, preserving the earlier 601 contract, lightweight imports, root exports, simp policy, and immutable artifacts. Use matched fixtures: the unmodified release, a documented declaration in a new focused module with both its new-module approval and its import approval through `LeanInfoTheory.Shannon`, and a compiling signature mutation to a post-v0.1.0 declaration that the 601-only comparison would miss. Compile the positive fixture through both the focused module and full umbrella; verify the lightweight root does not gain its import or export. Check that omitting either approval is rejected and that the 811 comparison rejects the signature mutation; distinguish development checks from replaying the exact release. Do not patch a frozen baseline to make growth pass. Qualify the actual build/CI route on the selected development checkout; estimate this enabling work separately if substantial. Neither tool changes nor pushes are authorized by this map.

## Chunk contracts

### C25. Finite binary tests and the TV decision problem

**Decision problem.** Write P0 for the null law and P1 for the alternative on the same finite observation alphabet. A test value f(x) in [0,1] is the probability of rejecting P0. Size is E0[f], power is E1[f], and type-II error is 1 - E1[f]. Include ordinary events as indicator tests. Binary refers to decisions, not the number of observations.

**Endpoint.** The minimum of size plus type-II error is 1 - TV(P0,P1), and the event where P1(x) > P0(x) attains it. The lower bound is for *all* randomized tests, not just events; use the [bounded-test TV inequality](../../LeanInfoTheory/Probability/TotalVariation.lean). Equal-prior average risk is half the sum. At intake compare the bounded-function and Boolean-channel representations; choose one public convention. Pinned mathlib's `Probability.Decision.Risk.Defs` already defines general kernel risks: consider an opt-in bridge only if a consumer needs one, not a duplicate risk hierarchy. Check equal laws, disjoint supports and a partially overlapping example.

### C26. Neyman--Pearson for finite experiments

**Endpoint.** For each level a in [0,1], produce a single test f* with size exactly a and power at least that of every test g with size at most a. Specify its likelihood-threshold rule, not merely existence of a maximizer. This gives the attained type-II error tradeoff without requiring a full ROC theory.

**Suggested construction.** Reject P0-null atoms with positive P1 mass at no size cost. On positive P0 mass, sort the finitely many likelihood levels and find the boundary where inclusion first reaches a. Randomize on that level to fill the remaining size. At common-null atoms the choice is immaterial. Treat a=0 and a=1 directly; do not divide by an empty boundary mass. For optimality, compare P1(x) to c P0(x) pointwise with c nonnegative: summing gives E1[g-f*] <= c E0[g-f*] <= 0. An alternative is a finite fractional-knapsack/exchange proof if pinned order lemmas make it simpler; it must still exhibit a threshold optimizer and handle ties.

**Consumers.** P0=(1/2,1/2), P1=(3/4,1/4), a=1/4 forces randomization to reach power 3/8. Separately use P0=(1,0), P1=(0,1): at size zero the optimal power is one. The second example catches a likelihood implementation that silently discards singular alternative mass.

### C27. Information density and the two competing laws

For input law p and raw channel W, use the existing joint J and its input/output product Q. Provide a support-correct log likelihood ratio in nats, its J-mean equal to mutual information, and a usable threshold event. On positive J-mass, Q is positive; Q can have mass where J vanishes. A totalized real logarithm at zero must not cause such points to pass a decoder threshold. A division-free test is `J(x,y) > exp(t) Q(x,y)`; under Q its probability is at most `exp(-t)`. Relate it to the information-density threshold under J.

**Consumer:** diagonal noiseless joint with positive independent-pair mass off the diagonal, and an independent joint with zero information. Use C25's conventions with Q as null, J as alternative; do not import C26 solely for terminology. Individual information densities can be negative even though their joint mean is nonnegative; do not clip them. Prefer a real-valued density on joint support plus a global mass-comparison event unless a consumer needs extended log likelihoods. If J=0<Q and t<0, a default real value of zero would incorrectly pass the log test; require literal event agreement on joint support, not pointwise on all pairs.

### C28. Iid block information density and concentration

Transport the iid law on pairs to the actual input/output word law for iid inputs and a memoryless channel. Prove supported additivity and convergence in probability of normalized block information density to single-letter MI on the varying finite block spaces. In particular, a fixed threshold strictly below MI has vanishing true-pair miss probability.

**Proof routes.** Reuse [C19's self-information AEP](../../LeanInfoTheory/Shannon/SemanticBridge/AEP.lean): on support, information density is input plus output self-information minus joint self-information. Three deviations and a union bound are a candidate route, **not** an independence assumption between input and output. The [pair-to-word transport](../../LeanInfoTheory/Probability/ProductChannel.lean) already exists as `PMF.finiteProduct_channelJoint_map`. With that transport, apply `tendsto_selfInfo_iid_deviation` to the joint and each marginal; three tolerances summing to the requested tolerance suffice. A direct finite-sum variance proof is a fallback if transport of events is harder than the moment calculation. C31 needs the specific event with **unnormalized threshold n times a fixed per-symbol value**; formulate the miss event with the complement of C27's strict test, including equality.

**Consumer:** a sparse or deterministic channel with impossible pairs; distinguish the true pair from independently sampled words. Normalize only at positive lengths.

### C29. Random codebooks and a total decoder

**Sampling experiment.** Fix blocklength n, M >= 1, input word law q and block channel K. Draw independent words B[0],...,B[M-1] from q, then send B[m] for a fixed index m and draw Y from K(B[m]). Averaging over books, (B[m],Y) has law J = joint(q,K); for j != m, (B[j],Y) has law Q = q times the output marginal. A fixed book generally does **not** give these two ensemble laws. In particular, even for an injective fixed book, one must not treat the wrong word as a fresh draw from q. The proof may fix m throughout and average uniformly at the end; it need not build a conditional PMF on an event.

**Decoder and handoff.** A realized book and a deterministic acceptance **event** define an actual [block-channel code](../../LeanInfoTheory/Shannon/ChannelCode.lean). Use a unique-match or first-match decoder with a total fallback. If the transmitted index passes and no other index passes, that decoder succeeds. Do not import randomized Neyman--Pearson tie-breaking into the decoder without an explicit derandomization proof. Use the [finite-product coordinate-pair law](../../LeanInfoTheory/Probability/FiniteProduct.lean) or expand the finite sum over books; independence *among all competing error events* is not needed. Check duplicate words, no matches, and M=1. Handoff the expectation of C23's actual uniform-message error, not just a new scalar called error.

### C30. One-shot achievability

**Finite deliverable.** In C29's experiment, for an acceptance event A the expected uniform-message error is at most J(A-complement) + (M-1) Q(A). The first term is a true-pair miss; the second is a union bound over false matches. Because this is an expectation over a finite PMF, some **supported, deterministic book** has error no greater than that bound. For C27's threshold event the second term is at most (M-1) exp(-t). The theorem is useful at finite n even without an iid input assumption.

**Required C31-facing result.** Given a single-letter channel W from X to PMFs on Y, a blocklength n, a positive budget M (hM : 1 <= M), and **any** input-word PMF q, instantiate K = `PMF.memorylessChannel W n`. Use J = joint(q,K) and Q = q times (q.bind K). Return a deterministic `c : BlockChannelCode X Y n M` with `c.errorProbability W hM <= J(A-complement) + (M-1) Q(A)`, and the corresponding threshold bound. Both the n and M are the caller's; q need not be iid. In particular, q is the ensemble sampling prior, not a claim about the empirical encoder distribution of the selected book. The [released definition](../../LeanInfoTheory/Shannon/ChannelCode.lean) forms K internally from W. An arbitrary-K lemma or alphabet-generic one-use proof is fine internally, but supply the transport and a compiling use of the released error, not a second error definition or a word-of-one proxy. A stronger dependence-testing or Feinstein bound is optional.

**Numerical check.** For the one-use binary symmetric channel with crossover 1/8, uniform input, M=2 and exp(t)=3/2, A is equality of the two bits. The event bound is 1/8 + 1/2 = 5/8; the exponential relaxation is 1/8 + 2/3 = 19/24. Both are bounds, not assertions that a good code has precisely those errors.

**Check that the guarantee can force useful decoding.** For a noiseless ternary channel, q=(3/8,3/8,1/4), M=2 and exp(t)=5/2, the strict test accepts exactly the diagonal: each diagonal likelihood ratio is 1/q(x)>5/2. Hence miss=0 and Q(A)=sum q(x)^2=11/32. Even the relaxed bound 2/5 is strictly below the 1/2 error of any constant decoder for two uniform messages. Keep the binary example for a nonzero miss term and the ternary example for this separation. Re-estimate random-coding effort at this checkpoint.

**C30 checkpoint and package 2 reassessment (11 November 2026).** Four one-shot
theorems and five permanent consumers preserve sample support, original n/M and
released error. The shared-output union bound, weighted-mean selection and
fixed-book transfer retire the main random-coding risks. Both numerical fixtures
and the strict positive-mass tie are implemented. The [C31 handoff](../handoffs/chunk-30.md)
and [cumulative matrix](release-3-chunk-30-notes.md#complete-cumulative-criterion-matrix)
record exact interfaces and deferred refinements. C31 still owns the input/rate
margin, one code per length, vanishing-error/rate limits and operational capacity.
C30 cumulative qualification depends on fresh checks, authorized matched clean
suite, original review/reconciliation and private completion. No C31 work starts.

### C31. Finite memoryless channel coding and operational capacity

**Endpoint and quantifiers.** For the finite channels covered by the [capacity API](../../LeanInfoTheory/Shannon/ChannelCapacity.lean), call a nonnegative R achievable if **one** positive-budget family has average error tending to zero and, for every delta > 0, eventually rate >= R - delta. Use this same predicate for both directions; do not choose new codes for each tolerance after stating the limit. Prove achievability for every 0 <= R < C(W), and C(W) is the least upper bound of achievable rates. The [C23 tolerance converse](../../LeanInfoTheory/Shannon/ChannelCodingAsymptotic.lean) gives the upper bound without any rate-limit assumption. The singleton family supplies zero even at zero capacity. Do not promise an exact message budget exp(n C) or a strong converse.

**Direct proof to try first.** Choose an input p and real s with R < s < I(p;W). Use the existing [rounded message budget](../../LeanInfoTheory/Shannon/CodingRate.lean) M(n) = ceil(exp(n R)) and threshold t(n)=n s. The natural rounding is favorable: M(n)-1 < exp(n R), so the false-match term is bounded by exp(-n(s-R)); C28 kills the miss term on exactly the same law. Select one good book per n; zero length is not used in a normalized estimate. A jointly typical decoder is a valid alternative if it supplies both a vanishing true miss and a quantitative independent-pair bound with that rate margin. Concentration under the joint alone is not a competing-codeword bound. Check a noisy positive-capacity channel and a zero-capacity constant channel.

**C31 qualification and C32 handoff (12 November 2026).** The five-declaration
operational endpoint uses one positive-budget family before every rate tolerance
in both directions, including the singleton zero witness and zero-capacity
leastness. Permanent consumers cover a noisy positive-capacity BEC, the exact
constant-row achievable set, and the conditional rate-floor transfer after a
log 2/n loss. The [maintained C32 handoff](../handoffs/chunk-31.md) and
[thirteen-criterion matrix](release-3-chunk-31-notes.md#complete-cumulative-criterion-matrix)
record the delivered interface and outstanding C32 constructions. Actual
cumulative validation, exact clean-checkpoint authority/full-suite results,
original review/reconciliation and private completion determine qualification.
The supported surface is 857 names / 64 modules; root and simp boundaries stay
unchanged. This historical C31 intake precedes the C32 qualification below.

### C32. Per-message error, expurgation and message restriction

**Operational handoff.** Define the error conditional on each *message index* by evaluating its channel row and the total decoder. Prove the uniform mean equals the existing block error e. Keep the nonempty set of indices with conditional error <= 2e: it has at least ceil(M/2) elements (if e=0 all errors vanish). Reindex those messages and redirect outputs decoded to discarded indices to a retained fallback. For each retained message, this cannot turn an originally correct decision into an error. Prove this also for further restriction to any requested positive budget not exceeding the retained size. The single new code then has error <= 2e for **every** prior on that budget. The rate loss from keeping at least half is at most log(2)/n for n>0.

**Discriminating check.** On a noiseless three-symbol channel, map four messages to (0,1,2,2) and decode to one representative per symbol. Average error is 1/4, but a prior concentrated on the never-decoded index can have error one. Restrict to the three correctly decoded indices: maximal error is zero. Verify the finite bounds without assuming the encoder is injective. Expurgation is the preferred proof; another construction must still deliver a single reliable code independent of the prior, not a different relabeling for each prior.

**C32 delivered interface and cumulative qualification (13 November 2026).**
The [maintained C33 handoff](../handoffs/chunk-32.md) and its fifteen-criterion
matrix link the sixteen public additions and permanent tests. One full good-set
family from C31 keeps the eventual rate floors and has vanishing maximal error.
Every fitting positive budget sequence then has one exact-budget family before
all varying prior sequences; the actual errors vanish on that same family.
The rate floor belongs to the full retained count. The two fallback choices,
non-prefix odd fixture, zero mean, singleton, empty words and too-small-budget
rate counterexample are exercised. The supported surface is 873 names in
66 modules, retaining the root and simp boundaries. Actual fresh validation,
separately authorized source-matched clean suite, original cumulative review,
reconciliation and closure follow the C32.06 completion record. This context
does not select C33 or discharge its actual-joint reconstruction inequality,
eventual fitting/short lengths or biased-source composition example.

### C33. Lossless source-channel separation: construction

The [C33 handoff](../handoffs/chunk-33.md) records the implemented direct
theorem, its finite proof, the biased erasure example and the exact joint-law
interfaces for C34. C34 still owns the converse and its positive-length limit.

**Shared model with C34.** Fix a finite source law p, finite raw channel W (nonempty input), one channel use per iid source symbol, and total maps from source words to input words and output words to source words. Draw S^n from iid(p,n), encode it, then draw Y^n from the actual memoryless row. Use the probability that the reconstructed word differs from S^n as the common block error. A paper-specific encoder, a uniform source, or a new bundled channel type is unnecessary.

**Construction.** If H(p) < C(W), choose H(p) < r_s < r_c < C(W). The [released source theorem](../../LeanInfoTheory/Shannon/SourceCodingAsymptotic.lean) supplies one vanishing-error family with eventual rate <= r_s. Use C31/C32 at r_c; choose a tolerance strictly smaller than r_c-r_s after accounting for expurgation. For large positive n the source budget fits the channel budget by monotonicity of log, so inject source indices into retained channel indices and give the inverse a total fallback. Fill exceptional short lengths with arbitrary valid codes. The end-to-end error is bounded by source error plus channel maximal error, without independence of the two error events. Test composition on an actually biased source with a strict entropy-capacity gap, using the produced code families rather than a noiseless identity shortcut.

**Finite handoff before taking limits.** For a source code with encoder f, let pi be the source-word law pushed forward by f. Let i embed its indices into the channel message set; after channel decoding, undo i on its image (choose a fallback source index outside the image), then apply the source decoder. Write e(j) for the channel-row probability of decoding to an index other than j when j is sent, defined even for unused j. Then

`Pe_reconstruction <= Pe_source + sum_m pi(m) * e(i(m)) <= Pe_source + max_m e(i(m)).`

If the source decoder would reconstruct correctly from f(s) and the channel decoder returns i(f(s)), the composition succeeds. Taking the failure union bound under the actual joint law gives the first inequality; C32 supplies the uniform-in-prior bound on the last term. **Regression:** use C32's four-message collision code, an identity source code and a source concentrated on its never-decoded fourth index. Source error is 0, *uniform* channel error is 1/4, but induced-prior channel error and reconstruction error are both 1. Substituting the uniform mean would assert 1 <= 1/4.

**Alternative for this step only.** For a fixed source-index prior, averaging a relabeling/injection into channel indices can give an assignment whose prior-weighted error is at most the uniform channel mean. This can avoid maximal-error bookkeeping inside the separation proof. It is a *prior-dependent* assignment, so it cannot discharge C32's stronger all-priors handoff.

### C34. Separation converse for arbitrary joint codes

For an arbitrary deterministic joint source/channel code family in the same model, vanishing reconstruction error implies H(S) <= C(W). It is not enough to rule out only concatenations of our two constructors.

**Proof route.** Apply [`condEntropy_fano_weak`](../../LeanInfoTheory/Shannon/Fano.lean) to the joint of source word and output word, using the actual reconstruction decoder; this is not the uniform-message Fano specialization. DPI bounds the source/output MI by input/output MI even when source words collide at the encoder. With iid entropy and the [arbitrary-input bound](../../LeanInfoTheory/Shannon/ProductChannelCapacity.lean) this gives `n H(p) <= n C(W) + log 2 + Pe(n) * n * log |S|`. Divide only on the positive-length tail; never divide by log |S| (the singleton case) or by the error probability.

**Consumer:** positive-entropy source and constant-output channel; a singleton source separately protects zero-entropy conventions. Deliver direct and converse for the same end-to-end error. No claim at equality, no lossy coding guarantee, bandwidth expansion, or error-to-one conclusion.

**Post-C34 re-estimate.** The two-owner consumer now passes the C33 witness directly to C34 under one reconstruction error. Arbitrary joint codes, correlated encoded words, the strict upper regime, singleton sources and length zero have permanent checks. The coding theorem chain supplies its C40 ledger inputs. Keep C35 and C36 in the default order. Their remaining work is constructive Kraft realization and expected-length optimization on the chosen source support. Neither depends on the channel proof. [C34 handoff, evidence and limits](../handoffs/chunk-34.md)

### C35. Binary prefix codes and Kraft length realization

Independent of C25--C34. Give finite source symbols injective binary codewords with no distinct word prefixing another. Relate lengths to the Kraft sum and prove or reuse the *construction direction*: any admissible finite list of integer lengths is realized by a prefix code. Pinned mathlib's `InformationTheory/Coding/KraftMcMillan.lean` already gives `kraft_mcmillan_inequality` for finite uniquely decodable **sets**; check the bridge rather than reproving it or assuming it constructs a code. Explicitly choose a support-alphabet convention for C36. Allow an empty codeword for a known one-symbol source encoded one symbol at a time; do not assert that repeated empty words are uniquely decodable without a known symbol count.

**Proof choice:** sort integer lengths in nondecreasing order and allocate aligned dyadic intervals of widths 2^(-length), or maintain free slots in a finite binary tree one level at a time. Either construction must return words assigned to the original labeled symbols, including repeated lengths; counting available slots alone is insufficient. Prove prefix implies unique decodability for nonempty words, using a first-word cancellation argument if needed; the exceptional singleton empty word satisfies Kraft directly.

**Consumers:** feasible lengths (1,2,2), impossible lengths (1,1,1), plus the singleton convention.

**C35 handoff.** Both directions are available on the original finite labels.
C36 can use the positive-support subtype for its length function and encoder.
The point-mass example checks the singleton empty word and excludes the
unused ambient symbol. [Signatures, examples and remaining work](../handoffs/chunk-35.md)

### C36. Expected length and the variable-length source-coding theorem

Use C35 to prove for a finite PMF on its support that the minimum expected binary prefix length satisfies `H_bits <= L_opt < H_bits + 1`. Give the lower bound for every admissible code, and a witnessing code (e.g. Shannon lengths) for the upper bound. Justify minimum attainment, not merely a bound on an infimum: a candidate of bounded mean bounds each positive-mass symbol's length, leaving finitely many competitors.

**Route.** For the lower bound let Z be the positive Kraft sum and normalize the weights 2^(-length) by Z. Then mean length minus entropy in bits equals the base-two KL to those weights minus log2(Z), both contributions nonnegative. For the upper witness use ceil(-log2 p(x)) on positive support; only after summing in bits convert to or from canonical nats. Use [explicit unit conversion](../../LeanInfoTheory/Shannon/Units.lean). Do not require unused alphabet symbols to be assigned leaves and then claim the same strict upper bound for point masses.

**Consumers:** dyadic source attaining equality at the lower bound, binary source (3/4,1/4), and a point mass on a larger ambient alphabet. For (3/4,1/4), Shannon lengths (1,2) give mean 5/4 bits, whereas lengths (1,1) give mean 1 bit, the minimum: with two supported symbols neither word can be empty. The upper-bound witness need not be an optimizer. For iid blocks of positive length n derive expected length per symbol between entropy and entropy plus 1/n bit (upper bound strict). Huffman optimality, universal coding and expected-length claims for arbitrary non-prefix injections are not required.

**C36 handoff.** The cumulative candidate supplies the binary converse for
every supported prefix encoder, a rounded encoder within one bit, an
attaining minimum and its positive-length iid specialization. The scalar
proof applies the logarithm inequality directly to each Kraft weight
divided by its positive atom mass. Both Kraft directions come from C35.
The C40 ledger records the actual theorem quantifiers, distinct witnesses,
numerical consumers and qualification identities. The next endpoint,
empirical laws, has no prefix-code dependency. [C40 endpoint ledger](../handoffs/chunk-36.md#c40-endpoint-ledger) · [Handoff to C37](../handoffs/chunk-36.md#handoff-to-c37)

### C37. Empirical laws and type classes

Independent of the coding and prefix packages. For positive blocklength n on a finite alphabet, give symbol counts, admissible count vectors summing to n, a word's empirical PMF, and the class of words having its counts. Prove realization of admissible counts, partition, permutation invariance, support facts and at most `(n+1)^k` types for alphabet size k. A count-vector subtype (total n) is convenient for combinatorics; a PMF together with an exact denominator-n witness is convenient for KL. Pick one indexing convention and prove conversion/round-trip at positive n, rather than parallel type-class definitions. Permutation invariance here means reordering word positions, not relabeling the source law. The empty word has counts, but it does not define a PMF by normalization.

**Consumer:** binary length three with counts (2,1), and a larger alphabet with a zero count.

The [maintained C37 handoff](../handoffs/chunk-37.md) records the delivered count
indices, realized finite classes, positive-length empirical equivalence, support,
focused imports and permanent public-interface consumers. Its cumulative
qualification distinguishes primary-checkout evidence from outstanding clean
qualification. C38 counts and C39 measures the same `typeClass` finset.

### C38. Counting and entropy of a type class

From C37, identify exact cardinality with the multinomial coefficient; check pinned mathlib's `Nat.multinomial` and permutation-count tools. For a realizable type q prove the polynomially sharp two-sided bound
`exp(n H(q))/(n+1)^k <= |T(q)| <= exp(n H(q))`.
For the upper bound, every word of this class has mass exp(-nH(q)) under q's own iid law. For the lower bound one useful route is to show the target counts a=nq are a mode of the multinomial **count-vector law**, not the largest class by cardinality. From positive-probability competing counts b, move one occurrence from an overrepresented i to an underrepresented j. The new/old probability ratio is b_i a_j / ((b_j+1) a_i) >= 1; competitors using q-zero symbols already have probability zero. Iteration reaches a. A mode among at most (n+1)^k count vectors has probability at least (n+1)^(-k). Alternatively use successive binomial counting bounds if they deliver the stated factor. Keep this proof independent of C39: seed the own-law word-mass identity directly from the released iid product formula. **Consumers:** class (2,1) has three words, a pure type has one, and a sparse type preserves the stated polynomial factor. No Stirling asymptotics or exact second-order estimate required.

C38.01 implements exact multinomial counting in the focused
`Shannon.TypeClassCardinality` owner at every length. C38.02 supplies independent
own-law atom/event identities in `Shannon.TypeClassBounds`; C38.03–04 supply
both entropy bounds with the full ambient alphabet. The preferred lower route
uses division-free natural weights, fixed-target probability maximality and
exact normalization; it does not maximize class size. C38.05 supplies the
binary/biased, pure, sparse, boundary and public-interface/ENNReal consumers and
is closed by receipt
`48ac467748bb373002fdbba4b9b534fd86caa6f06e271c550f9dc01640284045`.
C38.06 supplies cumulative validation, a fresh all17 review, canonical
reconciliation, remaining-work dispositions and the [C39 handoff](../handoffs/chunk-38.md).
`c38c67f0b6c044aff0a5c5630554d31dc033d7fce7353d68af1a2f19ff7e0db3` marks the four selected criteria and all seventeen chunk criteria
SATISFIED, without material findings; the parent agrees in `b95f53aa4c31515e03695a491b0d2712d2657629a66dfbc2fa2abeb722ad930a`.
Admission/exact-F applicability: verified C38.05 F `ccd27dc6b07fac07d9647beb9fd6bfb6e1d91391f058772238558d62f8326e42` with no source difference, then admitted only C38.06; original records in `.lit-review/setup/c38-06-20261118/`; current
validation: `.lake/compatibility/c38-06-validation-20261118/index.json` (original commands, outputs, actors and source maps; the generated/static records are sealed before review capture). Final applicability is governed by `.lit-review/setup/c38-06-20261118/final-checks.json`;
`.lit-review/setup/c38-06-20261118/completion.json` governs actual closure. An initial cumulative compatibility FAIL
identified duplicate generated iid-equation ownership in AEP/Bounds; seven
C38-only proof-body sites now use definitional finiteProduct conversion.
Mathematical routes, contracts, imports and acceptance policy are unchanged.
Corrected maintained reruns pass with their actual original receipts. The baseline remains913/76, simp94 and root2/5/92. General-prior/KL
statements remain C39. C36, C37 and C38 complete clean-checkpoint suite/hygiene
qualifications remain separate outstanding duties.
[Current evidence and limits](release-3-chunk-38-notes.md)

### C39. Type probabilities and finite KL

**C39.06, cumulative qualification.** The five general-prior results and their permanent consumers supply the method-of-types input to C40. The private equivalence links class probability zero exactly to infinite canonical KL at positive length. C36–C39 retain individual clean-checkpoint obligations. The [C40 handoff](../handoffs/chunk-39.md) gives the contracts, ledger, validation and final review status.

Use C37--C38 and the released iid law to give the mass of a word of type q and of its whole class under p. When q's support is contained in p's, show the class probability lies between `exp(-n D(q||p))/(n+1)^k` and `exp(-n D(q||p))`, in nats. If p assigns zero to an observed symbol, the class has zero probability and canonical KL is infinite; never use an unguarded real conversion at infinity.

**Check the scale:** on the finite-KL branch the mass of *one word* is exp(-n(H(q)+D(q||p))); multiply by the class cardinality before using the KL-only bounds. Products can instead be written over positive counts to avoid a log of zero or ambiguous 0 times infinity. For p=(1/2,1/2), n=3 and counts (2,1), verify word mass 1/8 and class mass 3/8; with p=(1,0) the same class is impossible. For p=(1/2,1/2,0), q=(1,0,0) and n=2, D(q||p)=log 2 in nats, the class contains just the first symbol twice, and its mass is 1/4. This finite branch needs support **inclusion**, not full support of p. Also check a biased full-support p. The bound is useful without Sanov's theorem. Type-based alternatives may inform earlier proofs, but do not create a backwards required dependency.

### C40. Programme integration and release qualification

Build a coverage ledger from the **approved** chunk contracts, not an assumed declaration count. For each of the six endpoint families, retain its exact final signature, focused import, source adaptation, permanent consumer, validation identity and explicit limits. Required gaps stay open. Audit the quantifier order in C26/C31/C32/C34/C36 and the singular branch of C39. Qualify both the testing API in isolation and the entire information-density-to-separation chain. Exercise the prefix-length and type-probability results in a separate consumer of the exact candidate, not via example-private helpers. Compare against both released baselines, prepare candidate documentation and report delivered mathematical growth separately from aliases or tooling. Record fresh versus applicable earlier checks, limitations and unexecuted publication actions. Target an independently reviewed candidate; do not choose a version/date/DOI, alter frozen archives or sites, or publish merely by closing the chunk.

**Documentation handoff, not deployment.** The [second-release split preview](v0.2-release-preparation.md) measured 661,575,985 bytes for the main site (including the historical API) and 655,316,062 for the separate API site. The project guard is 1,000,000,000 bytes **per complete site**, not per version directory or compressed archive. Measure the built release 3 candidate and the full proposed composition of each host, including dependency pages, search assets, selectors and retained snapshots. Record bytes, headroom and artifact identities. Check navigation, theorem anchors, search and source links under the actual project subpaths. Preserve `/LeanInfoTheory/docs/v0.1.0/`, the `/LeanInfoTheory/docs/v0.2.0/` entry point and its `/LeanInfoTheory-API/v0.2.0/` snapshot. If co-hosting does not fit, qualify a separate snapshot site with stable entry links or take a separately reviewed alternative; do not overwrite old routes or relax the guard. An oversized build without a viable route is not a passed hosting check.

The [current promotion workflow](../../.github/workflows/promote-release-pages.yml) pins v0.2.0 source, bundle revision and archive digests. Leave it intact here. In the release handoff identify the version-specific pins and approvals a future promotion would need. Carry forward a requalification checklist: final source/metadata amendments require the clean suite, retained comparisons and exact-SHA external consumer on the resulting commit; regenerate/recheck API output when its inputs or link mode change. For the final publication composition remeasure sizes, verify identities/digests, permanent routes, hosted navigation and public-commit source links. Separate local preview evidence from checks possible only after approval/publication. C40 does not provision a site, repin the live workflow, or publish.

## Handoffs, feasibility and scope control

| Producer -> consumer | What the detailed plans must agree on before building against it |
| --- | --- |
| C25 -> C26/C27 | Test orientation, admissible range, underlying PMFs, size/power vs miss/false alarm; ties and zero atoms. |
| C27 -> C28/C30 | True joint vs independent product, supported log identity and global threshold predicate on **both** laws. |
| C28/C30 -> C31 | Same input-word law and K = W^n in concentration and the miss event; C30 returns the original n/M code and bounds its released error at W. C31 specializes q to the chosen iid input. |
| C31/C32 + released source coding -> C33 | Check the finite induced-prior weighted-error inequality before using the asymptotic families and budget inclusion. C32 gives one code for all priors; a C33-only relabeling may depend on the induced prior. |
| C33 -> C34 | Identical source/channel sampling and reconstruction error, but a converse quantified over all joint codes. |
| C35 -> C36 | Symbol-index injectivity vs a set of words, constructive Kraft direction, support alphabet, empty-word convention and bits vs nats. |
| C37 -> C38 -> C39 | Same realizable counts, empirical law and class event. Seed the own-law word mass for C38 without importing C39; the general-p divergence identity belongs to C39. |

- **Feasibility, not preapproval.** At detailed intake inspect pinned sources. Prioritize small proof-complete probes for threshold attainment with singular atoms, wrong-codeword factorization, subcode decoder transport, constructive Kraft, and the per-type lower count bound. Obtain separate authorization for disposable spikes when needed. A name search or a compiling statement is not a proof.
- **Maintain quality at the existing cadence.** Keep probability constructions below heavy Shannon semantics; preserve the lightweight root and conservative simp policy. Use focused builds during work, permanent normal and adversarial consumers, current and retained type/import/attribute/trust checks, and documentation of departures from the sources. Use the installed supervised cycle once qualified for these IDs: original independent feedback, reasoned dispositions, current-source validation, and a maintained handoff. Act on one explicitly selected step at a time.
- **Re-estimate after C26, C30 and C34.** C26 tests whether the statistical API is usable without coding imports. C30 retires the main random-coding risk. C34 closes the coding theorem chain before unrelated branches consume capacity. Split or reorder when evidence warrants it; do not quietly move a hard required inequality or theorem out of scope. Record optional work with its owner and a concrete trigger instead of inflating a chunk.
- **Not this release by default:** composite/sequential tests, Stein/Chernoff exponents, a full hypothesis-testing divergence library, channel strong converse, second-order coding, general source/channel alphabets, exact-capacity attainment, Huffman algorithms, universal coding, Slepian--Wolf and rate--distortion. No downstream upgrade is a prerequisite. Normal maintenance remains active without becoming a seventh mathematical package.

## Source basis and limits

Use the [reference register](../references.md#release-3-planning-locators) for the exact local editions. PW24 sections 7.3, 14.1--14.2, 18.1--18.4, 19.2 and 19.7 anchor the testing/coding route; CT91 sections 8.6 onward provide the joint-typicality alternative. PW24 sections 10.1/10.3 and CT91 chapter 5 anchor the prefix work; CT91 section 12.1 anchors types. Do not import stronger generality or every result of those chapters. In particular the bounded separation endpoint above is the library's lossless, unit-bandwidth specialization, not a reproduction of a general lossy theorem.

Revision 2 retained the six packages and C25--C40 boundaries. It corrected the fixed-book interpretation, distinguished deterministic decoding from randomized tests and prior-specific from prior-uniform guarantees, and supplied proof routes and regressions for the major handoffs. These are planning choices, not independently accepted Lean results.

**Revision 3: independent-review dispositions.** Accepted all five points with the following scope:

1. Before C25: verify the rendered requests (C25/C40 and historical C24), and exercise new-module plus umbrella approvals in the growth fixture. These are bootstrap checks, not tool edits in this revision.
2. C29--C31: require a released-error specialization at the caller's W/n/M; retain the arbitrary-channel proof option and both numerical examples.
3. C32--C33: require the finite composition inequality with the actual source-index prior, and the point-mass counterexample to uniform averaging.
4. C36/C39: record exact outcomes separating a feasible prefix code from the optimum, and support inclusion from full support.
5. C40: qualify a size-feasible documentation layout and record final rechecks; choose the host from measurements rather than prescribing or publishing it now.

This map was checked against local source declarations, workflow restrictions, previous chunk handoffs, textbook contents and selected passages. The proposed math is not implemented or formally validated by this document. Before freezing a chunk's detailed contracts, read the precise proof in the registered edition, verify applicable declarations in pinned mathlib, and record any conventions or adaptations. No proof-feasibility spike, clean build, new reviewer binding, external-project change or release action is part of roadmap drafting.
