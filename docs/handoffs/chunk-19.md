# Chunk 19 maintained handoff: finite-iid AEP and weak typical sets

## Initial qualification and authority

C19.01--C19.04 closure, original reviews/reconciliations and exact Step 4 final-source
applicability were verified before C19.05 admission. The
[approved revision-2 plan](../plans/post-release-chunk-19.md) supplies all sixteen criteria. C19.05 adds no
mathematical endpoint; the [notes](../plans/post-release-chunk-19-notes.md) retain
actual checks, failures, dispositions and limits.

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

## Delivered interface

C19 adds eight supported declarations: one definition and seven theorems, all in
`LeanInfoTheory.Shannon`. There is no new public variance/probability abstraction,
concentration bound, helper alias, instance or simp attribute.

For the equations below only, let `[Fintype A]`, `p : PMF A`, `n : Nat`,
`q_n := PMF.iid p n`, `H := entropy p`, `L_n(x) := selfInfo q_n x`,
`r_n(x) := (q_n x).toReal`, and `P_n(E) := (q_n.toOuterMeasure E).toReal`.
Write `T := weakTypicalSet p n ε` and coerce this finset to a set for probabilities.
These abbreviations are expository, not additional declarations.

| Exact public name | Focused owner | Contract |
| --- | --- | --- |
| `selfInfo_iid_of_mem_support` | [SemanticBridge.AEP](../../LeanInfoTheory/Shannon/SemanticBridge/AEP.lean) | For `x ∈ q_n.support`, `L_n(x) = ∑ i : Fin n, selfInfo p (x i)`, including `n=0`. |
| `tendsto_selfInfo_iid_deviation` | [SemanticBridge.AEP](../../LeanInfoTheory/Shannon/SemanticBridge/AEP.lean) | For `ε>0`, `P_n({x : Fin n → A \| ε ≤ abs(L_n(x)/(n:ℝ)-H)}) → 0` along natural blocklengths. |
| `weakTypicalSet` | [TypicalSet](../../LeanInfoTheory/Shannon/TypicalSet.lean) | Finite set of words satisfying positive length, actual iid support and strict normalized deviation. |
| `mem_weakTypicalSet` | [TypicalSet](../../LeanInfoTheory/Shannon/TypicalSet.lean) | Membership iff `0<n ∧ x∈q_n.support ∧ abs(L_n(x)/(n:ℝ)-H)<ε`. |
| `weakTypicalSet_mass_bounds` | [TypicalSet](../../LeanInfoTheory/Shannon/TypicalSet.lean) | Membership implies `exp(-(n:ℝ)*(H+ε)) ≤ r_n(x) ≤ exp(-(n:ℝ)*(H-ε))`. |
| `tendsto_prob_weakTypicalSet` | [SemanticBridge.AEP](../../LeanInfoTheory/Shannon/SemanticBridge/AEP.lean) | For `ε>0`, `P_n(T) → 1`. |
| `card_weakTypicalSet_le` | [TypicalSet](../../LeanInfoTheory/Shannon/TypicalSet.lean) | For every `n, ε`, `(T.card:ℝ) ≤ exp((n:ℝ)*(H+ε))`. |
| `prob_mul_exp_le_card_weakTypicalSet` | [TypicalSet](../../LeanInfoTheory/Shannon/TypicalSet.lean) | For every `n, ε`, `P_n(T)*exp((n:ℝ)*(H-ε)) ≤ (T.card:ℝ)`. |

### Hypotheses and boundary conventions

- Information is Real-valued in nats; words have type `Fin n → A`.
- Public endpoints need a finite alphabet and supplied PMF, with only their
  stated support or positive-width premises. They add no measurable-space,
  `DecidableEq`, full-support, positive-entropy or extra nonemptiness assumption.
- `selfInfo` is zero at zero mass. Unrestricted block additivity is false:
  for `(1/2,1/2,0)` and word `(0,2)`, the block value is zero while the coordinate
  sum is `log 2 > 0`. Supported or almost-everywhere identities are essential.
- Typicality is strict and support-aware. Impossible words remain excluded even
  when `ε>H`; replacing membership by the raw numerical band changes the set.
- `T_{0,ε}=∅`, although the empty word has iid mass one and block information zero.
  Nonpositive widths also give an empty set. A base `PMF Empty` is not available.
- The AEP sequence uses total Real division at zero. Normalized mean/variance
  and the finite Chebyshev estimate require `n>0`; the finite initial value does
  not affect convergence. The deviation event is exactly `ε ≤ abs(...)`.
- For `n>0`, typical-complement and deviation probabilities agree. The ambient
  sets can differ off support; literal ambient-set equality is not claimed.
- Both cardinality bounds allow every length and width, including empty sets.
  The lower bound's actual probability factor cannot be dropped.
- Deterministic sources have `H=0`; at positive length and width their typical
  set is the singleton supported word with probability one. No `ε<H` is needed.
- The eventual lower consumer keeps independent `ε>0` and `δ>0`:
  eventually `(1-δ)*exp((n:ℝ)*(H-ε)) ≤ (T.card:ℝ)`, without `δ<1`.

### Focused ownership and imports

Use `import LeanInfoTheory.Shannon.TypicalSet` for the finite definition and
bounds. Its only direct imports are `Shannon.SemanticBridge.Entropy` and
`Probability.Iid`; it does not import AEP or concentration. This does not make
it measure-free: its existing entropy/self-information dependency is semantic.

Use `import LeanInfoTheory.Shannon.SemanticBridge.AEP` for the supported block
identity and probability limits. Its direct imports are
`Shannon.SemanticBridge.Entropy`, `Shannon.SemanticBridge.FiniteProduct`,
`Shannon.TypicalSet`, `Mathlib.Probability.Moments.Variance` and
`Mathlib.Analysis.SpecificLimits.Basic`.

The semantic umbrella imports AEP and the complete Shannon umbrella imports
TypicalSet. The lightweight root retains its two direct imports and 92 exports.
The two example owners belong only to `LeanInfoTheory.Examples`; examples are
private, non-stable source anchors, not supported imports for production proofs.

## Producer-to-consumer chains

The [C18 handoff](chunk-18.md) supplies the predecessor chain: C16 product/iid
laws and coordinate independence, existing finite self-information expectation,
and C18 product/iid entropy. C19 reuses those facts rather than replacing them.

1. Supported block additivity gives the actual iid observable's AE identity.
   Private coordinate law, expectation, `MemLp`, composed independence and
   variance transports feed `iid_moment_checkpoint` in the AEP owner.
2. Private `iid_deviation_le` applies Chebyshev with positive length/width and
   explicit finite ENNReal-to-Real conversion. A scalar `constant/n` limit and
   squeeze prove the public probability limit on varying finite block spaces.
3. Support-intersection equality and finite probability complement algebra give
   typical probability tending to one. The finite owner independently obtains
   both atom bounds from supported logarithms and positive length.
4. Summing lower atom bounds and comparing with `PMF.sum_toReal=1` proves the
   upper cardinality bound. Summing upper atom bounds over the actual finite
   event proves the probability-weighted lower bound. Positive exponentials
   cancel without division at zero; empty sums handle all boundary cases.
5. Public typical probability and the lower cardinality theorem give the
   independent-δ eventual lower bound. Public interfaces also assemble the
   common mathematical inputs for both later coding directions.

One-off analytic, AE, event-complement and moment machinery remains private.
The existing generic event-sum theorem in `Probability.TotalVariation` was
considered; `PMF.toOuterMeasure_apply_finset`, `ENNReal.toReal_sum` and
`PMF.apply_ne_top` fit the finite proof without adding that owner or a duplicate
general bridge. Naming follows the approved eight-name surface without aliases.

## Permanent consumers

| Source owner | Exact private anchors and purpose |
| --- | --- |
| [Examples.AEP](../../LeanInfoTheory/Examples/AEP.lean) | `sparse_impossible_not_additive`, `sparse_supported_additivity`, `iid_zero_selfInfo`, `iid_one_selfInfo`, `singleton_alphabet_selfInfo`, `no_empty_base_law`: actual support and length boundaries. |
| [Examples.AEP](../../LeanInfoTheory/Examples/AEP.lean) | `nonuniform_deviation_tendsto`, `sparse_deviation_tendsto`, `pure_deviation_probability`: public AEP for nonuniform/sparse laws and deterministic zero deviation probability at every length and positive threshold. |
| [Examples.AEP](../../LeanInfoTheory/Examples/AEP.lean) | `nonuniform_typical_probability`, `sparse_typical_probability`, `typical_complement_probability`, `eventually_card_weakTypicalSet_lower`, `typical_inputs`: limits, independent tolerances and the assembled downstream package. |
| [Examples.TypicalSet](../../LeanInfoTheory/Examples/TypicalSet.lean) | `zero_length_empty`, `nonpositive_width_empty`, `iid_one_typical_mem`, `pure_typical_set`, `pure_typical_probability`, `pure_ambient_impossible`, `singleton_alphabet_typical`: finite boundaries using the actual iid law. |
| [Examples.TypicalSet](../../LeanInfoTheory/Examples/TypicalSet.lean) | `sparse_supported_typical`, `sparse_typical_mass_bounds`, `sparse_impossible_excluded`, `sparse_impossible_passes_raw_band`: supported/impossible words even at widths exceeding entropy. |
| [Examples.TypicalSet](../../LeanInfoTheory/Examples/TypicalSet.lean) | `nonuniform_positive_width_empty_regression`, `nonuniform_middle_set`, `nonuniform_middle_probability`, `nonuniform_common_on_small_boundary`, `nonuniform_rare_on_middle_boundary`: exact strict binary boundaries. |
| [Examples.TypicalSet](../../LeanInfoTheory/Examples/TypicalSet.lean) | `zero_length_cardinality`, `nonpositive_width_cardinality`, `pure_cardinality_bounds`, `nonuniform_empty_requires_probability_factor`, `nonuniform_middle_cardinality`: applications of both public counting endpoints. |
| [SemanticBridge.AEP](../../LeanInfoTheory/Shannon/SemanticBridge/AEP.lean) | Private `aepBiased_second_moment`, `aepBiased_second_moment_pos`, `aepBiased_block_two_variance`: nonuniform analytic regression where private moment machinery is in scope. |

For the binary `(1/3,2/3)` source, `H=log 3-(2/3)*log 2` and the two deviations
are `(2/3)*log 2` and `(1/3)*log 2`. At length one, width `log 2/3>0` gives an
empty typical set and probability zero; width `2*log 2/3` gives the common word
alone with probability `2/3`. The common word lies exactly on the smaller-width
boundary; the rare word lies exactly on the larger-width boundary.
The centered second moment is `(2/9)*(log 2)^2>0`. The actual normalized
length-two block self-information has variance `(1/9)*(log 2)^2>0`; its proof
uses the block support/AE identity, not merely a numerical simplification of V/2.

## Exact C20/C21 inputs and remaining responsibilities

The single private `Examples.AEP.typical_inputs` fixes arbitrary finite `p` and
`ε>0` and obtains together, for the same `weakTypicalSet p n ε`:

- `P_n(T^c) → 0`;
- `x∈T → r_n(x) ≤ exp(-(n:ℝ)*(H-ε))`;
- `(T.card:ℝ) ≤ exp((n:ℝ)*(H+ε))`;
- for any supplied `M : Nat`, `exp((n:ℝ)*(H+ε)) ≤ (M:ℝ)` implies
  `T.card≤M`, `1≤M` and `Fintype.card (Fin M)=M`.

Exponential positivity supplies the nonempty budget; no independent `M≥1`
premise is needed for that conversion. This consumer chooses no budget and
performs no integer rounding. The probability-weighted lower theorem and its
independent-δ consumer remain available alongside this assembled interface.

C20 remains independent of AEP. It owns arbitrary-law coding interfaces of the
forms `P_success ≤ q(T^c)+M*b` when `0 ≤ b`, at most M words are correctly
decoded and each atom in T is at most b, and code existence with
`P_error ≤ q(T^c)` when
`card T≤M` and `1≤M`. Code/decoder definitions, integer message cardinalities
and actual budget rounding belong there.

C21 combines those interfaces with C19, using
`b=exp(-(n:ℝ)*(H-ε))` for the converse and the upper cardinality bound for
achievability. Exponential positivity supplies the nonnegative atom-cap premise. It owns code sequences, achievability above H, error tending to
one under an eventual rate bound below H, and the general vanishing-error
liminf statement. Eventual/extended-real rate conventions and total-decoder
fallback remain C20/C21 decisions. Correct decoding outside T is allowed, so
the error bound is not generally an equality. Preserve H=0 and zero-length
initialization; no result at exact rate H is supplied by C19.

## Registered sources and adaptations

The [reference register](../references.md) identifies CT91 (1991) and PW24
(August 16, 2024); PW22 is a different draft with different numbering.
CT91 §3.1, Theorems 3.1.1--3.1.2, printed 51--53/PDF 73--75, supplies the AEP
and typical-set probability/mass/cardinality argument. Equation (3.7) separates
ε and δ before identifying them for notation; (3.8)--(3.16) supplies the counting
argument. PW24 §11.2, Proposition 11.6 and (11.2), printed 217--218/PDF 242--243,
supplies probability convergence and the exponential cardinality upper bound.

The books use WLLN; finite-second-moment Chebyshev is the selected implementation,
not a separately displayed source bound. The all-length probability-weighted
lower bound is the underlying finite algebra, not a separately numbered theorem.
Nats, finite PMFs, strict supported bands and the empty zero-length convention
are explicit project adaptations. Closed textbook definitions are not silently
identified with this strict set. No operational coding conclusion is imported.

Earlier reference actors checked the registered local editions and relevant
passages; Step 4's independent reviewer performed recorded local extraction/hash
checks. The supporting handoff audit inspected source and those accounts.
During C19.05 preparation the parent also freshly verified both registered PDF
hashes and extracted CT91 PDF 73--75 and PW24 PDF 242--243 with `pdftotext`.
The finite counting argument and independent tolerances agree with the selected
contracts; imperfect CT91 extraction glyphs do not replace direct Lean sign
inspection. This was text inspection, not fresh visual page review.
No reference media or external formalization code is added to the project.

## Sixteen-criterion source and obligation map

This map identifies source evidence and remaining work, not a cumulative verdict.
All sixteen criteria remain in the required fresh C19.05 independent review.

| Exact criterion | Source or remaining obligation |
| --- | --- |
| C19.01-SUPPORT | Supported identity and actual sparse impossible-word additivity counterexample. |
| C19.01-BRIDGE | Private `iid_moment_checkpoint`, coordinate mean/variance/composed independence, normalized moment and finite event guards. |
| C19.01-BOUNDARY | Zero/one, pure, singleton and empty-alphabet consumers; focused ownership and unchanged self-information convention. |
| C19.02-LIMIT | `tendsto_selfInfo_iid_deviation` with exactly the `≥ε` Real event probability. |
| C19.02-PROBABILITY | Supported/AE substitution, finite conversions and positive-length normalized estimates in AEP. |
| C19.02-CONSUMERS | Nonuniform/sparse public limits, deterministic exact-zero probability, positive second moment and actual n=2 normalized block variance. |
| C19.03-EVENT | Guarded strict `weakTypicalSet`, membership, zero/nonpositive and impossible-word regressions. |
| C19.03-LIMIT | Public typical-probability limit, private support-intersection bridge and public-interface complement consumer. |
| C19.03-MASS | `weakTypicalSet_mass_bounds`, both signs and support-derived positivity, including entropy zero. |
| C19.03-CONSUMERS | Finite pure/singleton/sparse/zero/one consumers and both exact binary strict-boundary cases. |
| C19.04-UPPER | `card_weakTypicalSet_le`, finite normalization and all-length/all-width boundary consumers. |
| C19.04-LOWER | `prob_mul_exp_le_card_weakTypicalSet`, independent-δ eventual consumer and counterexample to dropping probability. |
| C19.04-HANDOFF | One private `typical_inputs` combines the same set/probability family and natural-M conversion through supported interfaces. |
| C19.05-VALIDATION | Initial checkpoint clean routine and API02 actual two-pass file-mode gate passed, with all eight declarations inspected and explicit frozen-manifest LF/CRLF source correspondence. API01 remains FAIL. Every amendment still needs its required clean rerun and API applicability. |
| C19.05-READINESS | Requires retained current-candidate self-review, separate reassessment, predecessor/review obligations and fresh all-sixteen-criterion review readiness; the actual completion chain establishes their status. |
| C19.05-HANDOFF | This maintained handoff records contracts, evidence limits and C20/C21 responsibilities and is linked from canonical context; reconcile actual qualification facts before F, then supported closure. |

## Qualification evidence and limits

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

API source-content SHA-256: `379a1d1f9b542279941b11b78bfd0c1b4f032e85a86abdd149147e2824b708bf`.
Configuration SHA-256: `ddf4e00291e15a882bfd8de74a166591d706f3e93eae99d9b6df74a31a3f11ba`.
Two-pass attestation SHA-256: `f544cbfac344b81539655e2345c65819d41265fca1b622117170a590e1ef7491`.
Applicability covers 110 API input files and 103 compiled-validation
input files with their recorded dependencies and the one explicit frozen-manifest
line-ending correspondence above. Original commands, complete logs and
before/after identities are retained under `.lit-review/setup/c19-05-20261020/`
in `checkpoint-01/`, `clean-01/` and successful `api-milestone-02/`. The original
`api-milestone-01/` failure and `api-cache-recovery-01/` marker-move evidence remain
separate; neither supports a passing criterion. `api-inspection.json` records the
parent's API02 substantive inspections separately from automated extraction.
`api-cache-recovery-guard-failure.json` separately retains the parent's observed
first recovery-helper refusal before any move or output-directory creation;
its tuple/list comparison diagnosis is distinct from the actual API01 failure.
`api-applicability-attempt01-observation.json` retains the later private guard
refusal before the inspection record: it overlooked that maintained frozen-file
allowance, created no record and changed no source/workflow. API02 remains PASS.

These are initial qualification facts. Any amended checkpoint requires the complete
clean rerun and exact API-evidence applicability assessment. The fresh all-sixteen-
criterion review, original-report reconciliation, final validation and F capture
are established only by their actual source-bound records. Final closure depends on
`.lit-review/setup/c19-05-completion-20261020.json`, when present, and its linked completion chain;
this prose asserts no future gate, review result or closure. C20--C24 and publication
remain unselected.

Previous parent step checks include focused producers/consumers/aggregates,
documentation examples, static checks and compiled compatibility/trust on their
recorded inputs. The latest Step 4 parent trust run passed 601 retained types,
47 supported direct imports, 721 declarations, 94 simp names, 92 root exports
and the transitive axiom audit of 3,340 local constants.

The Step 4 reviewer separately completed seven-target focused compilation,
static validation, five README/four guide examples, a targeted signature/axiom
probe and selected-input identity checks. It did not rerun full compiled trust.
Earlier failed attempts, malformed delivery/report observations and their
specific recoveries remain separately retained in the notes/private records;
they are not recast as passing mathematical evidence.

The earlier supporting handoff audit was read-only source/document preparation.
It supplied no formal review or compilation. The initial C19.05 qualification
above records separate actual parent executions; cumulative review retains its
own actor, candidate, original report and limitations.
Retain B, R and F separately; assess exact post-review applicability before
closure. Generated inventory and agreement of names/counts alone do not validate
API-documentation output or authorize completion.

## Remaining work, owners and reopening triggers

| Item | Owner and disposition | Reopening/completion trigger |
| --- | --- | --- |
| Exact clean candidate and full maintained routine | C19.05; initial authorized checkpoint passed. | Rerun the complete maintained routine after every amendment; retain the exact final candidate/result in the completion chain. |
| Two-pass API documentation | C19.05; authorized API02 two-pass gate and all-eight inspection passed; API01 remains FAIL. | Recheck exact evidence applicability after amendments; rerun when source/configuration/dependency changes invalidate it. |
| Cumulative review and closure | C19.05; admitted, with each later result separately source-bound. | All sixteen criteria, original report/reconciliation, dispositions, final validation, linked handoff before F and supported private closure; actual completion-chain records establish their status. |
| Arbitrary-law coding and natural budgets | C20; deferred, not selected here. | Separately approved/selected C20 work; maintain AEP independence and total-decoder/message-cardinality decisions. |
| Asymptotic source-coding conclusions | C21; deferred. | C20 interfaces plus this C19 package; settle rates, rounding, H=0 and zero-length initialization. |
| Public complement, variance or concentration wrappers | No C19 addition. | Concrete downstream reuse pressure and ordinary API/plan review; private consumer existence alone is insufficient. |
| Cardinality-rate equivalence, exact-rate H, entropy rates or infinite processes | Outside C19. | Separate mathematical scope/plan decision; no completion gap is inferred here. |
| Publication, dependency changes and later chunks | Unselected. | Separate explicit lead authorization; handoff preparation does not start them. |
