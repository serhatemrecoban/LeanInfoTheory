# Chunk 10 maintained handoff: finite total variation

## Status and authority

C10.01--C10.06 have actual `SUPERVISED_STEP_COMPLETE` records, identified below.
C10.07 is the final authorized cumulative closeout step. Explicit authority permitted the
concrete local checkpoint. The initial clean routine suite and actual two-pass
current API-doc gate passed; a fresh full-chunk review assessed all 19 approved
criteria and its original report was explicitly reconciled.
Final amended-candidate validation, exact API-doc/review applicability, final
capture and completion are established by C10.07's source-bound private records.
This maintained chronology does not itself certify final F or closure, and
requirements are not PASS claims.
The [approved plan](../plans/post-release-chunk-10.md), especially Sections 4--6,
controls completion. Earlier favorable reports do not replace the fresh full-chunk review.
Neither this handoff nor the step request supplies checkpoint, amendment, push,
publication, or later-chunk implementation authority.

## Delivered public mathematical interface

The sole supported owner is `LeanInfoTheory.Probability.TotalVariation`, namespace `PMF`.
It exports exactly one definition and 24 theorems; every name below is public.
For finite PMFs, write `rp a := (p a).toReal` and `rq a := (q a).toReal`.
The definition is `TV(p,q) = (1/2 : ℝ) * ∑ a, |rp a - rq a|`.
The public finite-sum interfaces use `[Fintype α]`, with no additional `Nonempty` premise.

| Family | Public declarations | Contract |
| --- | --- | --- |
| Definition and range | `totalVariation`, `totalVariation_nonneg`, `totalVariation_le_one` | Real-valued TV lies in `[0,1]`. |
| Metric laws | `totalVariation_self`, `totalVariation_comm`, `totalVariation_eq_zero_iff`, `totalVariation_triangle` | Self-distance, symmetry, exact separation, and triangle inequality; no metric instance. |
| Event sums and positive part | `toOuterMeasure_toReal_eq_sum`, `totalVariation_eq_sum_pos` | Existing Set-event probability agrees with finite real sums; TV is the sum of nonnegative coordinate differences. |
| Event bound and attainment | `abs_toOuterMeasure_sub_le_totalVariation`, `totalVariation_eq_toOuterMeasure_sub` | Every absolute event discrepancy is bounded; the explicit event `A = {a | rq a ≤ rp a}` attains the signed value. |
| Event envelopes | `totalVariation_isGreatest_event`, `totalVariation_isGreatest_abs_event` | Constructive signed and absolute greatest-value statements over Set events. |
| Real overlap | `totalVariation_eq_sum_sub_min`, `totalVariation_eq_one_sub_sum_min` | TV equals `∑ (rp - min rp rq)` and `1 - ∑ min rp rq`. |
| ENNReal masses | `sum_min_eq_ofReal_one_sub_totalVariation`, `ofReal_totalVariation_eq_sum_sub` | Common mass is `ofReal (1-TV)`; the truncated residual total is `ofReal TV`. |
| Disjointness endpoint | `totalVariation_eq_one_iff_disjoint_support` | Distance one is equivalent to disjoint actual PMF supports. |
| Test bounds | `abs_sum_sub_le_totalVariation_of_mem_Icc`, `abs_sum_sub_le_mul_totalVariation` | Interval width times TV and radius `2*M*TV` bounds, including zero width/radius. |
| Test envelopes | `totalVariation_isGreatest_unitInterval`, `two_mul_totalVariation_isGreatest_bounded` | Absolute expectation discrepancy has greatest value TV on `[0,1]`, and `2*TV` on `abs f ≤ 1`. |
| Processing | `totalVariation_bind_le`, `totalVariation_map_le`, `totalVariation_map_equiv` | Common-channel contraction, deterministic-map contraction, and equivalence invariance. |

Events retain `PMF.toOuterMeasure` and `Set α`; there is no second event-probability definition.
The non-strict attaining event includes ties, whose signed contributions are zero.
No public event theorem requires measurability or a supplied decidability instance.
Residual subtraction is ENNReal truncated subtraction; both orientations follow by symmetry.
Processing permits independent universes for finite source and target alphabets.
`bind` uses one common channel `W : α → PMF β`, with no support or injectivity premise.
No positive-atom, full-support, absolute-continuity, likelihood-ratio, or nonzero-TV
premise was introduced. Test-radius nonnegativity and interval endpoint order
are the explicit guards stated by their public bounds.

## Ownership, reuse, and import boundaries

The owner's exact direct imports are `LeanInfoTheory.Probability.Finite`
and `Mathlib.Tactic.Linarith`; no direct `Ring` or `FiniteChannel` import is needed.
Proofs reuse finite PMF normalization, guarded real-mass conversion, extensionality,
map/bind laws, and ENNReal minimum/truncated-subtraction algebra from pinned mathlib.
Common-bind contraction follows finite real sums, the absolute-sum bound, and row normalization.
Map contraction specializes bind; equivalence invariance uses contraction in both directions.
All auxiliary proof machinery remains private. There are no new attributes, aliases,
metric/topology instances, probability abstractions, or semantic variation bridges.

The full `LeanInfoTheory.Shannon` umbrella adds TV to its four retained direct imports.
The lightweight root still directly imports exactly `Probability.Finite` and
`InformationMeasures`, retaining its exact five-local-module closure.
`Examples.TotalVariation` imports only TV; `Examples.TotalVariationChannels` imports
TV and `Probability.FiniteChannel`. Both are included only by the non-stable Examples aggregate.
Neither mathematical umbrella imports examples. The reviewed growth policy records
the new owner and full-umbrella addition; generated inventories do not supply approval.

## Permanent private consumers and their limits

All declarations in the two TV example modules, including the family and witness helpers,
are private. They exercise the public interface without enlarging it.
The cumulative source assessment found semantic consumer use of all 25 public TV declarations.

| Consumer group | Delivered evidence of use |
| --- | --- |
| Core and events | Self/separation, distinct pure Bool distance one, range, reverse triangle, empty/full/tied events, Finset coercion, and a nontrivial Bool discrepancy. |
| Overlap and residuals | Generic real/ENNReal totals in both orientations, residual-minus-min reconciliation, finite/non-top totals, interior positive/nonzero premises, and equal/disjoint endpoints. |
| Sparse alphabet | Ternary laws `(1/2,1/2,0)` and `(0,1/2,1/2)` connect TV, overlap, and both residual totals at `1/2`. |
| Bounded tests | Signed greatest-value forms derived externally from the public absolute-value API; constants and zero width/radius; sharp indicator and sign tests. |
| Shared Boolean family | One private law with true mass `t` and false mass `1-t`, for `0≤t≤1`, connects sums, events, overlap, tests, and processing; TV is `abs (t-s)` without an ordering hypothesis. |
| Boolean degeneracies | The family handles both parameter orders, ties/equality, and parameters 0 and 1, including pure/disjoint and zero-mass endpoints. |
| Empty and singleton cases | Subsingleton/Unit laws have distance zero; an empty alphabet has no PMF, without imposing finiteness on that impossibility result. |
| Channel examples | Nonconstant noninjective merging, constant collapse, identity/equivalence, deterministic postprocessing, and channel composition use the processing API. |
| Strict contraction | A Boolean channel retaining with probability `3/4` and flipping with probability `1/4` takes distinct pure inputs from TV one to TV one half. |
| Marginal projections | Both projections of arbitrary finite joint laws satisfy map-contraction comparisons without entropy assumptions. |

The generic binary-reduction consumer explicitly defines, with local classical reasoning,
`b a := if a ∈ A then true else false`, for the public attaining event `A`.
It uses attaining-event equality, the existing map/preimage event formula,
the public absolute event bound, and public map contraction to prove exact TV preservation.
It does not unfold TV or add positivity/support hypotheses.
This is a private consumer proof, not an exported binary-reduction theorem.
Likewise, generic interior normalization checks expose usable premises but construct no coupling law.

## Current and historical identities

Counts describe inspected metadata, not quotas for future work.

| Inventory | Current C10 source | Frozen v0.1.0 |
| --- | --- | --- |
| Supported documented declarations / owners | 628 / 32 | 601 / 31 |
| Local modules / import edges | 49 / 101 | 44 / 90 |
| Root-reachable / separately imported modules | 5 / 44 | 5 / 39 |
| Non-stable anchors | 17 | 13 |
| Source-index declarations / documented | 743 / 742 | 716 / 715 |
| Reviewed simp declarations / facade aliases | 94 / 92 | 94 / 92 |

Current supported kinds are 561 theorems, 57 definitions, 9 abbreviations, and 1 named instance.
The source index additionally includes non-stable declarations and one example-only instance;
it is distinct from the supported manifest and signature-bearing doc-gen output.
C9's interim baseline was 603 supported declarations, 46 modules, 94 edges, and 15 non-stable anchors.
C10 adds 25 supported declarations and three modules to that baseline.
Lean remains `v4.33.1`; mathlib remains `0df444a360eaa60ab8c11dca51a86af692955474`.
Isolated doc-gen4 remains `e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015`.
Frozen release identity remains `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`.
The frozen API manifest, retained artifact, release route, dependency pins, licence,
and release metadata are protected historical inputs, not current-generation outputs.

## Mathematical sources and adaptations

The [reference register](../references.md) identifies the exact local copies consulted.
LP17 is Levin--Peres, second edition (2017), `mcmt2e (Levin-Peres).pdf`, 461 pages,
SHA-256 `9ef39f9467d9647ff3f5e8747b9ce24b7a90d13be2f8156fbd827b95b661a772`.
PW24 is the August 16, 2024 Polyanskiy--Wu prepublication version,
`Polyanskiy-Wu Newer.pdf`, 730 pages,
SHA-256 `c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
LP17 Sections 4.1--4.2, especially Proposition 4.2 and Proposition 4.5/(4.7),
and PW24 Section 7.3, Theorem 7.7(a)/(7.18), supply the event/test normalization.
C10 takes half-L1 as its definition and proves the attained event characterizations.
For signed unit tests the unscaled greatest value is `2*TV`; for `[0,1]` tests it is TV.
PW24's page-123 proof wording about the second supremum conflicts with the preceding
inequality; the approved adaptation follows the displayed theorem and LP17 and proves both directions.
The non-strict maximizing event differs harmlessly from PW24's strict version on zero-contribution ties.
Interval bounds, ENNReal normalization interfaces, and common-channel finite algebra are
derived contracts, not separately numbered textbook results. Density notation adds no support premise.
TV is unitless. Nats and the factor two in future Pinsker belong to the later KL contract.
LP17's coupling interpretation and PW24 Theorem 7.7(b) remain future C11 work;
SA13 coupling/entropy-continuity material is not implemented by this chunk.

## Cumulative criterion traceability

The exact normative descriptions remain in [plan Section 4](../plans/post-release-chunk-10.md#4-steps-dependencies-and-acceptance-criteria).
This map identifies the delivered surface to recheck; earlier success does not
replace the fresh C10.07 source and consumer assessment.

| Required criteria | Current source and evidence to reassess cumulatively |
| --- | --- |
| C10.01-MATH / BOUNDARY / CONSUMER | Half-L1 definition and six core laws; exact focused/full/root imports and reviewed policy; pure/self/separation consumers. |
| C10.02-MATH / INTERFACE / CONSUMER | Set-event sum and attaining event, signed/absolute greatest values; Finset coercion, empty/full/tied and Boolean consumers. |
| C10.03-MATH / CONSUMER | Real/ENNReal overlap and residuals, disjoint supports; generic both-law normalization premises, endpoints and sparse ternary totals. |
| C10.04-MATH / CONSUMER | Sharp arbitrary interval/radius bounds and explicit witnesses; externally derived signed maxima, equal laws and zero-width/radius cases. |
| C10.05-MATH / CONSUMER | Common bind/map contraction and equivalence invariance; noninjective, constant, identity, exact noisy channel and composition consumers. |
| C10.06-NORMALIZATION / BINARY / EDGES / API | Shared closed-interval Boolean family; exact generic event reduction; degenerate alphabets and both projections; all 25 documented and meaningfully consumed declarations. |
| C10.07-VALIDATION / READINESS / INDEPENDENCE | Authorized clean current suite and actual two-pass docs; reconciled canonical records/handoff; fresh full-chunk review against all criteria, followed by reconciliation and private closure. |

## Actual prior-step completion and original-report ledger

The actual C10 implementation parent is `01a0bdea-63b6-7060-b05b-47542dd8a81c`;
its persistent reviewer is `/root/c10_reviewer`. Requested creation settings were
`gpt-6-astra`, `ultra`, and `fork_turns="none"` through native collaboration.
Effective settings were unreported; cooperative read-only instructions are not
OS isolation. Support reconstructions are not the installed independent review.

All basenames below are under `.lit-review/setup/`; all six actual records say
`SUPERVISED_STEP_COMPLETE`. These are prior-step facts, not a C10.07 verdict.
The hashes are the records' content-addressed `closure`, `F`, and `report` references;
the report reference is not asserted to be the raw wrapper file's SHA-256.

| Step | Actual completion record | Original report artifact |
| --- | --- | --- |
| C10.01 | `c10-01-completion-20260920.json` | `c10-01-independent-review-original-20260920.json` |
| C10.02 | `c10-02-completion-20260920.json` | `c10-02-original-review-report-20260920.txt` |
| C10.03 | `c10-03-completion-20260920.json` | `c10-03-original-review-report-20260920.txt` |
| C10.04 | `c10-04-completion-20260920.json` | `c10-04-original-review-report-20260920.txt` |
| C10.05 | `c10-05-completion-20260920.json` | `c10-05-original-review-report-20260920.txt` |
| C10.06 | `c10-06-completion-20260921.json` | `c10-06-original-review-report-20260921.txt` |

| Step | Closure | Final source F | Accepted report |
| --- | --- | --- | --- |
| C10.01 | `d51e9f8a210680595187711a8c017bf81feea77177de2602673fe691a4559012` | `c4305ced6833b888ef1a209e32d33bd8f680b8867a8da375585e954032953932` | `ad925ded0783837996401ad9a5576b9c247f88999123d76df258fdfdb0bfdc4c` |
| C10.02 | `0cec6abc60aeb7bf5971f6237bcb55c83eee525bddcdff0507dce3b235e91731` | `b8815c7451a03b84a671d00b53b194c420ba7453b2cbf6ac6e4bf95b59e9f384` | `7cd2d64e54c6ba286eb04611b73dd6ff290298f12c38c6a48ec2227b777ef747` |
| C10.03 | `1f84f3add71772bd5bebd9470ccade41caac5451e63ba27298861a2de907c509` | `2ed6c3cb4265d8d9ec50728cb827ce8c8ac6b9a10785a661de452c58b8d72ca4` | `bff37343ebb0d092cb4aaa1fd3b0131cd5cf527e29a312f6a863133028379aa9` |
| C10.04 | `596cc2e6255423161abe84a5ccc86e27c77cc089d239744b396328699e9c2fdc` | `5729ca0c2914356eb7ebbf2845af0255f5caadc1b84af4a43d7cff602d07247b` | `ee24f00ad8de9e99c7db33a22d703ca29642f60b4d5ed8d6e56380efe4d2fa58` |
| C10.05 | `77c47fb227a752ed347ff192b9f08f52476c5ade0c15e53e5b0165452ac989d5` | `f179895565ad70631e7cb18ab2a5b88e17be61733174847e90a8b221a144af16` | `b5e6dab1c7820d8c91cf561bcce4a1edfbf633adf5a90e21e1cd24d8602a63eb` |
| C10.06 | `c1577c9e4d566cefbd3be28e0f9be27304460da7ae8ccd6898c1922169e1716a` | `f867c44fd1b7d252b59a187c0703f8b6d5a3f46fc234c97f6f151a3ae281abc5` | `ca477882af576f6fae1aa07178d25c7b5bba947c0a02f5faf44fc189000dcb11` |

## C10.07 initial evidence and closure protocol

The lead explicitly authorized the initial local checkpoint
`d8cc00050d98aa5f1fad4d7395d886957728bef2`. The following are completed initial
checks, not evidence for unchecked later amendments:

| Check | Observed original evidence |
| --- | --- |
| Complete clean routine suite | `.lit-review/setup/c10-07-full-checkpoint-20260921/result.json`; actual exit `0`, duration `1972.486` seconds; observed scope `eight warning-as-error targets, five README and four website examples, 601 retained types, 32 exact module imports, 628 supported declarations, 94 simp names, 92 root exports, 49 modules and 1541 local constants with only the three permitted axioms, plus static/site/clean hygiene`. |
| Real current file-mode API docs | `.lit-review/setup/c10-07-api-docs-recovered-20260921/result.json`; both real checked passes, actual exit `0`, pass times `118.5s and 13.3s`; observed counts `628 declarations / 32 module pages / 92 export targets / 17 non-stable exclusions / 25 TV declarations; zero equation rows`; v2 attestation `docbuild/.lake/build/api-doc-build-attestation.json`. |
| Cumulative independent review | Original `.lit-review/setup/c10-07-original-review-report-20260921.txt`; observed criterion outcome `all 19 cumulative assessments SATISFIED, with the three registered C10.07 criteria also SATISFIED`; findings/reconciliation `no findings; original report and all registered criterion assessments explicitly reconciled`. |

The two API-doc passes used `DOCGEN_SRC=file`, `DISABLE_EQUATIONS=1`, and the
verified reviewed Windows Zig 0.16.0 executable. Output remains local under
`docbuild/.lake/build/doc/`, separate from the frozen release route.
Original commands, streams, actor and source/config/dependency identities remain
private; distinguish parent checks from reviewer-reported checks and input reuse.

1. Finish the chronology-only amendments and any authorized review corrections, preserving the normative plan, historical tails, mathematical source and protected boundaries.
2. Use the already granted authority for necessary C10.07-only checkpoint amendments. Run the complete routine suite again on the resulting authorized clean candidate; record its actual result privately.
3. Establish exact API-doc and review applicability after every changed input; rerun affected gates and obtain re-review for material changes or criterion gaps. Successful initial checks do not qualify amended inputs automatically.
4. Reassess review-to-final impact, capture exact F only after all captured edits and final applicable validation, and complete the installed private closure process. No post-F captured-file edit inserts its identity.
5. Report actual closure to the user and stop. C11 and later work remain unselected; no push, publication, staging or validator redesign is included.

The complete suite includes compatibility and trust. C9 fixture qualification
remains prior infrastructure evidence; repeat relevant fixtures only for a
changed mechanism or demonstrated concern. This sequence governs finalization;
its actual execution and completion are recorded privately.

### Documentation-cache observation carried forward

The first C10.07 API-doc attempt rebuilt TV/Shannon `docInfo` but replayed the
aggregate HTML marker, omitting the new TV page. The existing semantic checker
rejected that output. Invalidating only the ignored
`doc-data/LeanInfoTheory.Shannon--module.docs_built` marker and its `.hash`/`.trace`
sidecars forced actual HTML generation; the complete two-pass rerun then passed.
The initial failure and original marker bytes are retained. Cached upstream Qq
warnings about `mkLambdaQ` and `withLetHave` remain disclosed, outside the supported
project declarations. No dependency or validator code was changed.
The documentation maintainer owns this Note 9 observation: reconsider aggregate
HTML cache invalidation on the next module addition or a reproduced stale-output
failure; it does not justify broad infrastructure work in C10.

## Remaining work and next-chunk boundaries

| Item | Owner and next authorized trigger | Boundary carried forward |
| --- | --- | --- |
| Maximal coupling | C11, after its own approved plan and explicit step request | Choose upstream reuse or one thin joint-PMF interface; construct exact marginals/disagreement TV and handle TV=0/1 and zero/full-overlap normalization branches. C10 supplies totals and tested premises, not a witness law. |
| Coupling transport/gluing | C12, after separate approval and concrete coupling consumers | Reuse common bind/map contraction; finite gluing, null fibers, and consistent marginals remain later. No maximality-under-composition claim. |
| Binary reduction and Pinsker | C13, after separate approved planning | Reuse the attaining event, map contraction, and demonstrated private TV-preserving Bool proof; supply KL data processing, Bernoulli boundary cases, nats `2*TV²≤KL`, and all infinite-KL/support guards. |
| Entropy/information continuity | C14, after maximal coupling and its own approved step | Range, separation, singleton and marginal-map interfaces are ready; import entropy/Fano separately and preserve endpoint conditions. |
| Topological consequences | C15, under its own approval | Use finite-coordinate TV, separation, and triangle; choose topology/instances and coordinate-convergence equivalence later. |
| Naming and aliases, Note 14 | API maintainer, on reproducible recurring consumer/discovery friction | Preserve current names; record deduplicated evidence in `docs/downstream-api-feedback.md`; no speculative aliases. |
| Simp and chain rules, Notes 15--16 | API/theorem maintainer, on a concrete terminating reduction needed by permanent consumers | Keep transformations explicit and the reviewed 94-entry simp set; no automatic entropy expansion. |
| Validation and module boundaries, Notes 17--18 | Each chunk implementer at milestones; architecture maintainer/lead for an exception | Preserve exact imports, assumptions, evidence applicability, and lightweight root boundaries. These standing duties remain open. |
| Broader documentation/publication, Note 9 | Documentation maintainer, after separate approval or a concrete maintenance need | Current two-pass API docs are the C10 milestone; broader blueprint/equation/status tooling and publication are not selected. |
| Further independence conveniences, Note 25 | Future theorem owner, on a concrete consumer need | C9's delivered deterministic slice stays closed; other variants are not C10 prerequisites. |

C11 may investigate reuse of `PMF.channelJoint p (fun _ => q)` for independent products;
that is a future design candidate, not a selected C10 construction or a required new abstraction.
Other Future Work Notes retain their category, owner, and trigger. No broad note closure,
coding result, or downstream certificate/application work follows from this handoff.

## Source identity and continuation

Before the authorized checkpoint, HEAD was
`6afede1a7e4e0bccd65742b0c61d7a92e51a6e93` on `master`; its dirty diff contained
the completed C10 steps and initial closeout documents. The explicitly authorized
initial clean checkpoint was `d8cc00050d98aa5f1fad4d7395d886957728bef2`.
These historical Git identities are not the workflow baseline or final F.
Step intake verified exact C10.06 source applicability before capturing its own B;
final amended-candidate identity and applicability are established privately.
The current TV owner SHA-256 is
`d5ec3f4830692b3d73b45db0d45e81f8008f57ccb49303e11dd6a9b80f6042ae`;
the two consumer hashes are
`e02e99257ed32578f608e97d2bc4834c89b3b91bff25877e5fbcedf4e9e8d0f2`
and `372e48c9199e2766da37f25010e9328814c458f7e5d10f66180edb8b0d00ae31`.
C10.07's prepared edits are documentation only; these Lean bytes remain unchanged.

The exact current supported manifest SHA-256 is
`5787c86b94a116cb3874694590f414feaf3dad436ed466d59e2ffb0596be4b83`;
the reviewed policy is
`59582e097815c2162e0851ef0eb555bf905fc6ea3983345a81cc48a5e5c56df7`.
The historical frozen manifest is
`d4c5bfa78588de605798f568b312a4cef2896855e36d3c983849270181e397be`;
the retained structural artifact is
`b4beab492f4b782613dd89b157855a6ca59636a8f35b7f4fa97c15d27653d5ed`.
Equal signatures and hashes do not establish mathematical meaning; source
interpretation and permanent consumers remain separate review obligations.

Current C10 status and links are reconciled in README, current Lean state,
living summary, roadmap/map, the reference register and both API-doc guides.
Historical intake/release/log records and the approved plan outside its reserved
status region are preserved. The [step notes](../plans/post-release-chunk-10-notes.md)
retain the actual chronology, failures and applicability limits.

Read actual C10.07 private records to determine current checkpoint, full-suite,
two-pass API-doc, original reviewer report, reconciliation, R, F and closure.
Do not predict those identities or edit captured files after F to insert them.
If closeout is pending, continue only its authorized remainder. If the actual
private closure exists, this snapshot's provisional wording does not reopen it.
C11 still requires its own detailed plan, approval, explicit step and reviewer;
no reviewer or checkpoint authority transfers from this handoff.
