# Chunk 18 maintained handoff: product information and single-letterization

## Captured qualification and authority

**INITIAL CHECKPOINT QUALIFIED — 2026-10-18.** C18.01--C18.05 and their reviews
are complete by actual private records. The parent freshly verified all 258
captured entries of C18.05 F, environment and Git state before admitting the
conditional C18.06 request. Only C18.06 is selected; it adds no mathematical endpoint.

The [approved revision-2 plan](../plans/post-release-chunk-18.md) owns all twenty
criteria. The [notes](../plans/post-release-chunk-18-notes.md) preserve actual
checks, failures, source applicability and original-review dispositions.
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

Actual completion is established only by
`.lit-review/setup/c18-06-completion-20261018.json` after supported closure.
Earlier captured provisional wording does not reopen completed steps. Revision 1
had PLAN review; revision 2 has no separate PLAN review. The original reports,
corrections and limitations remain distinct. No push, tag, publication, dependency
change, later-chunk implementation or unrelated work is authorized here.
Module names below have the `LeanInfoTheory.` prefix unless otherwise stated.

### Bounded review-record recovery, 2026-10-18

The amended checkpoint `b5e77c741caca836ea8d0a769d140bd1771cb34a` subsequently
passed the complete clean routine. The cumulative reviewer assessed all twenty
criteria SATISFIED with no findings, but its first report incorrectly cited a
FAIL disclosure as passing evidence. The complete corrected original removes
only that citation and preserves every observation and substantive assessment.
The recorder retained the first report as `REPORT_EVIDENCE_INVALID` and the
correction as `CONFLICTING_DUPLICATE` against the first delivery's byte hash.
Neither report was accepted, and that run did not close C18.06.

The lead separately approved a bounded review-tooling repair and requalification.
The repair preserves both originals, classifications and delivery records;
exact-pair resolution grants no acceptance. A separately authorized fresh
validation/readiness/source-review sequence is required for the changed tooling.
Its actual tests, independent technical review, expanded local checkpoint,
clean rerun and API applicability belong to
`.lit-review/setup/c18-06-remediation-20261018/`. Historical checks remain bound
to their original sources. Only the eventual completion record named above
establishes final closure; this paragraph claims neither recovery nor closure
in advance. The fifteen mathematical endpoints and later-chunk responsibilities
remain unchanged.

## Delivered interface

C18 adds fifteen public theorems in five semantic owners. All belong to
`LeanInfoTheory.Shannon`; no new probability constructor, information definition,
public helper, alias, instance or simp attribute is introduced by C18.

For the equations in the following table only, write:

- `P(p) = PMF.finiteProduct p`, `H = entropy`, and `MI = mutualInfo`.
- `D(p,q) = InformationTheory.klDiv p.toMeasure q.toMeasure`, valued in ENNReal.
- `K = PMF.productChannel W`, `J = PMF.channelJoint q K`,
  `q_i = q.map (fun x => x i)`, `J_i = PMF.channelJoint q_i (W i)`.
- `O = q.bind K`, `O_i = q_i.bind (W i)` and
  `E = Equiv.arrowProdEquivProdArrow I A B`.

These are expository abbreviations, not additional Lean declarations.

| Exact public name | Owner under `Shannon.SemanticBridge` | Contract |
| --- | --- | --- |
| `entropy_finiteProduct` | [`FiniteProduct`](../../LeanInfoTheory/Shannon/SemanticBridge/FiniteProduct.lean) | `H(P(p)) = ∑ i, H(p i)`. |
| `entropy_iid` | [`FiniteProduct`](../../LeanInfoTheory/Shannon/SemanticBridge/FiniteProduct.lean) | `H(PMF.iid p n) = (n : ℝ) * H(p)`, including zero length. |
| `mutualInfo_map_piProd_eq_sum_of_isMutuallyIndependentFamily` | [`FiniteProduct`](../../LeanInfoTheory/Shannon/SemanticBridge/FiniteProduct.lean) | For `r : PMF (∀ i, A i × B i)` and `hr : IsMutuallyIndependentFamily r Finset.univ`, `MI(r.map E) = ∑ i, MI(r.map (fun z => z i))`. No channel representation or independence within a pair is assumed. |
| `klDiv_finiteProduct` | [`ProductKL`](../../LeanInfoTheory/Shannon/SemanticBridge/ProductKL.lean) | `D(P(p),P(q)) = ∑ i, D(p i,q i)`, without support restrictions and including infinity. |
| `toReal_klDiv_finiteProduct` | [`ProductKL`](../../LeanInfoTheory/Shannon/SemanticBridge/ProductKL.lean) | The corresponding Real sum identity under `∀ i, (p i).support ⊆ (q i).support`. |
| `klDiv_iid` | [`ProductKL`](../../LeanInfoTheory/Shannon/SemanticBridge/ProductKL.lean) | `D(PMF.iid p n,PMF.iid q n) = (n : ENNReal) * D(p,q)`, including `0 * ⊤ = 0`. |
| `toReal_klDiv_iid` | [`ProductKL`](../../LeanInfoTheory/Shannon/SemanticBridge/ProductKL.lean) | The corresponding Real scalar identity under `p.support ⊆ q.support`. |
| `condEntropy_channelJoint_productChannel` | [`ProductChannel`](../../LeanInfoTheory/Shannon/SemanticBridge/ProductChannel.lean) | `condEntropy (J.map Prod.swap) = ∑ i, condEntropy (J_i.map Prod.swap)` for arbitrary input law `q`. |
| `sum_mutualInfo_sub_mutualInfo_productChannel` | [`ProductChannel`](../../LeanInfoTheory/Shannon/SemanticBridge/ProductChannel.lean) | `(∑ i, MI(J_i)) - MI(J) = (∑ i, H(O_i)) - H(O)`. Selected optional exact gap. |
| `mutualInfo_channelJoint_productChannel_le` | [`ProductChannel`](../../LeanInfoTheory/Shannon/SemanticBridge/ProductChannel.lean) | `MI(J) ≤ ∑ i, MI(J_i)` for arbitrary input law `q`. |
| `mutualInfo_channelJoint_productChannel_eq_sum_iff` | [`ProductChannel`](../../LeanInfoTheory/Shannon/SemanticBridge/ProductChannel.lean) | `MI(J) = ∑ i, MI(J_i)` iff `IsMutuallyIndependentFamily O Finset.univ`. Selected optional equality criterion. |
| `mutualInfo_channelJoint_finiteProduct` | [`ProductChannel`](../../LeanInfoTheory/Shannon/SemanticBridge/ProductChannel.lean) | `MI(PMF.channelJoint (P(p)) K) = ∑ i, MI(PMF.channelJoint (p i) (W i))`. |
| `mutualInfo_channelJoint_iid` | [`ProductChannel`](../../LeanInfoTheory/Shannon/SemanticBridge/ProductChannel.lean) | `MI(PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n)) = (n : ℝ) * MI(PMF.channelJoint p W)`. |
| `condEntropyOf_pi_le_sum` | [`FiniteFamily`](../../LeanInfoTheory/Shannon/SemanticBridge/FiniteFamily.lean) | `condEntropyOf p (fun ω i => X i ω) Y ≤ ∑ i, condEntropyOf p (X i) Y`, without independence. |
| `sum_mutualInfoOf_le_mutualInfoOf_pi` | [`FiniteFamilyIndependence`](../../LeanInfoTheory/Shannon/SemanticBridge/FiniteFamilyIndependence.lean) | `(∑ i, mutualInfoOf p (X i) Y) ≤ mutualInfoOf p (fun ω i => X i ω) Y`, assuming only `IsMutuallyIndependentFamilyOf p X Finset.univ`. |

### Essential hypotheses and boundary conventions

Product entropy, product KL and channel statements use independent universes
`I : Type u`, `A : I → Type v`, and, where relevant, `B : I → Type w`.
They enumerate finite indices and finite value alphabets through `[Fintype I]`
and the corresponding fiber Fintypes. Each dependent family has one fiber
universe; index/input/output universes are not identified. The pair fibers are
in `Type (max v w)`. The iid specializations retain independent base input/output
universes and take every natural blocklength.

KL additionally takes `[∀ i, MeasurableSpace (A i)]` and
`[∀ i, MeasurableSingletonClass (A i)]`, using the standard Pi measurable
structure. It does not demand a particular syntactic choice of discrete
measurable space. Product Real conversion establishes finite coordinate KL
and finite product KL from actual support inclusion; full support is unnecessary.
The iid Real guard expresses the finite-information contract. Unconditional
`ENNReal.toReal_mul` does not need that guard algebraically: singular iid values
collapse to zero on both Real sides. In contrast, K2 proves that unguarded
heterogeneous Real summation can fail. No unguarded public alias is supplied.

The two source-family endpoints have the exact data

```lean
{I : Type u} {A : I → Type v} {Ω : Type w} {C : Type z}
[Fintype I] [∀ i, Fintype (A i)] [Fintype C]
(p : PMF Ω) (X : ∀ i, Ω → A i) (Y : Ω → C)
```

Only the MI endpoint adds unconditioned mutual independence of the full source
family. There is no finite-source assumption, relationship between `v` and `z`,
independence of `Y`, or conditional-product-law premise. Every summand uses the
same observation `Y`; conditioning can make the source coordinates dependent.

No endpoint adds a public DecidableEq, full-support, nonempty-index or
positive-length premise. Empty index means a unique empty word. An actual
singleton alphabet differs from a singleton index. An empty component alphabet
cannot supply its component PMF; `iid p 0` still requires the base PMF, and a
repeated channel still takes its base channel. C18's information theorems use
finite value alphabets even though C17's raw channel rows/joint projections
can permit infinite input alphabets.

`condEntropy` means first given second. The swap in the channel theorem is
therefore essential for `H(output | input)`. All finite Shannon quantities are
Real-valued nats. Product-channel structure constrains conditional output rows,
not the input law or unconditional output independence. Conditional row recovery
is valid on actual input support only. On a null input, the existing total
conditional-channel fallback is the output marginal, without conditional meaning.

### Focused ownership and imports

| Producer | Direct project imports |
| --- | --- |
| `SemanticBridge.FiniteProduct` | `Probability.FiniteProduct`, `Probability.Iid`, `SemanticBridge.FiniteFamilyIndependence`. |
| `SemanticBridge.ProductKL` | `Probability.Iid`, `SemanticBridge.ConditionalKL`. |
| `SemanticBridge.ProductChannel` | `Probability.ProductChannel`, `SemanticBridge.FiniteProduct`, `SemanticBridge.Convexity`. |
| `SemanticBridge.FiniteFamily` | `Shannon.FiniteFamily`, `SemanticBridge.Theorems`. |
| `SemanticBridge.FiniteFamilyIndependence` | `SemanticBridge.FiniteFamily`, `SemanticBridge.Independence`, `Probability.FiniteProduct`. |

Here `SemanticBridge` abbreviates `Shannon.SemanticBridge` in import columns.
Probability owners stay below Shannon semantics. The general pair theorem
does not acquire a ProductChannel or ProductKL dependency. ProductChannel does
not import ProductKL. The two new semantic owners join the semantic aggregate
and hence the full Shannon umbrella. The lightweight root still directly
imports exactly `Probability.Finite` and `InformationMeasures`.

## Five permanent consumer owners

All C18 consumer declarations are private. Consumers join only
`LeanInfoTheory.Examples`, not either supported mathematical umbrella. Their
focused imports make the delivered interfaces usable without the full aggregate.

| Consumer owner | Exact direct imports | Permanent coverage |
| --- | --- | --- |
| [`Examples.FiniteProductSemantics`](../../LeanInfoTheory/Examples/FiniteProductSemantics.lean) | `Shannon.SemanticBridge.FiniteProduct` | E1 extends the existing heterogeneous sparse/non-iid family with product entropy, full-word/family and singleton-index/alphabet consequences. E2 constructs independent diagonal fair pairs, each with MI `log 2 > 0` and block MI `2 * log 2`, plus a heterogeneous sparse/nonidentical pair family. It uses no ProductChannel import. |
| [`Examples.IidInformation`](../../LeanInfoTheory/Examples/IidInformation.lean) | `Shannon.SemanticBridge.FiniteProduct` | E1 uses a positive-entropy sparse ternary law and fair bits for general `n`, explicit zero/one lengths, missing words, a singleton alphabet, a genuine empty product over `Empty`, and impossibility of a base `PMF Empty`. |
| [`Examples.ProductKL`](../../LeanInfoTheory/Examples/ProductKL.lean) | `Shannon.SemanticBridge.ProductKL` | K1 uses heterogeneous sparse laws and actual support inclusion, finite ENNReal/Real KL and boundary specializations. K2 uses `(fair,pure false)` versus `(pure false,fair)`: overlapping supports with explicit witnesses against each inclusion, coordinate KLs top and positive finite `log 2`, top product KL, and failed unguarded Real summation. Supported and singular iid zero/one cases are explicit. |
| [`Examples.ProductChannelInformation`](../../LeanInfoTheory/Examples/ProductChannelInformation.lean) | `Shannon.SemanticBridge.ProductChannel`, `Shannon.SemanticBridge.Markov` | C1 covers noisy correlated inputs, actual marginal joints, absent-coordinate row invariance, supported recovery and a null fallback differing from the supplied row. C2 covers strict correlated identity, correlated constant/singleton-output equality, heterogeneous sparse product inputs and general/zero/one iid lengths. C3 covers parity-related outputs. H1 covers supported encoder collisions, correlated induced words, the repeated-channel bound, generic coordinate-objective caps and product-input objective values. |
| [`Examples.FiniteFamilyInformation`](../../LeanInfoTheory/Examples/FiniteFamilyInformation.lean) | `Shannon.SemanticBridge.FiniteFamilyIndependence` | S1 retains generic four-universe/arbitrary-source consumers. Independent fair bits observed through XOR have coordinate MI sum zero and tuple MI `log 2`; conditional tuple entropy is `log 2` versus coordinate sum `2 * log 2`, and conditional independence fails explicitly. A Bool/Fin 3 family uses an infinite ambient carrier and `ULift.{1} Bool` observation. Empty/singleton families derive equalities through both public endpoints. |

The concrete infinite carrier is `ℕ × (Bool × Fin 3)` with a finitely supported
law; it genuinely lacks a finite-carrier assumption but does not itself test
an infinitely supported law. The generic S1 consumers restrict neither source
carrier nor source support. Prior C16/C17 probability consumers remain useful
for selected-only finiteness, ordered blocks, sparse atoms, composition and
encoded joint/extension sampling; C18 does not replace them.

## Producer-to-consumer chains and implementation decisions

1. **Product to entropy:** C16 `finiteProduct`, evaluation/restriction and full
   mutual independence feed the existing family entropy-additivity iff. An
   injective full-univ restriction identifies family entropy with word entropy;
   singleton marginals identify the summands. This proves product and iid entropy
   without another logarithmic additivity proof.
2. **Product to KL:** Constant channels in the existing joint KL chain rule give
   binary ENNReal additivity, including infinity. Private equivalence invariance
   comes from map contraction in both directions. Option-index splitting and
   `Fintype.induction_empty_option` extend this to dependent finite products.
   C16 support characterization supplies guarded Real conversion; K2 retains
   the formerly deferred paired-support regression.
3. **Rows to conditional entropy:** Product-row entropy plus finite expectation
   transport gives the arbitrary-input formula. The row-entropy formula is
   derived privately from the existing public channel-MI expression. Null input
   rows have zero weight; the proof never reconstructs an unsupported row.
4. **Joint to MI:** Output entropy subadditivity and the conditional-output
   identity give the gap, bound and equality iff. For equality under product
   inputs, C17 `finiteProduct_channelJoint_map` identifies the transported product
   of actual coordinate joints, and the general independent-pair MI theorem
   supplies additivity. The latter computes word marginals and uses entropy
   invariance under the pair-to-word equivalence; dependence within each pair
   is allowed. Iid equality is the constant-family specialization.
5. **Encoded law to bound:** `q = sourceBits.map encodeBits`, with
   `encodeBits (a,b) = (a,a)`, is explicitly correlated and has supported
   collisions. The actual repeated-channel theorem applies to this `q` and its
   actual coordinate marginals. No encoder injectivity or iid-codeword assumption
   enters the bound. The generic cap consumer then substitutes any valid
   coordinate objective bounds; no supremum is constructed.
6. **Independent sources to common observation:** A private conditional-entropy
   equivalence bridge, empty tuple projection and Option tuple-to-pair split
   extend binary conditional subadditivity to dependent finite indices. Source
   entropy additivity under unconditioned mutual independence then gives the MI
   lower bound. The XOR consumer distinguishes this from the channel upper bound.

Typed intermediate statements and local `convert!` steps resolve classical/native
finite-Pi Fintype coherence in the implementation. These adjustments did not
strengthen signatures, change imports for convenience, raise compiler limits,
disable linters or introduce public normalization wrappers. Detailed failed
drafts and actual corrections remain in the step notes/private evidence.

## Optional dispositions

The exact gap and equality iff were selected separately in C18.04 and both are
exported within the approved envelope. The iff concerns full mutual independence
of unconditional output coordinates, not pairwise independence. Independent
inputs suffice but are unnecessary: correlated inputs with constant outputs
give equality, including an actual singleton output alphabet.

Exporting the iff activated C3. Under identity processing of `(U,V,U xor V)`,
every distinct output pair is independent, output entropy and block MI are
`2 * log 2`, and coordinate sums are `3 * log 2`. The positive gap is `log 2`.
The consumer uses both public optional endpoints and refutes full output mutual
independence. No total-correlation definition or infinite-value cancellation
claim is introduced.

The advisory coordinate-swap regression was not added. For independent fair
inputs, `Y₀ = X₁`, `Y₁ = X₀` would give same-coordinate MI zero but block MI
`2 * log 2`; this channel is not coordinatewise in the required sense. The
constructor-specific theorem and current consumers preserve that boundary.
Reconsider a private regression in a separately selected downstream use if
C22/C23 work actually confuses independent input with product-channel structure;
it is not a missing C18 acceptance obligation or a new public endpoint.

## Registered sources and finite adaptations

The mathematical source is registered **PW24**, August 16, 2024, SHA-256
`c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
PW22 is a distinct draft with different numbering.

| PW24 anchor | Use and adaptation |
| --- | --- |
| Section 1.1, Definition 1.3, printed 10 / PDF 35; Theorem 1.4(g), (1.3), printed 12 / PDF 37 | Finite conditional entropy, entropy subadditivity and equality under full mutual independence; null fibers have zero weight. |
| Section 2.5, Theorem 2.16(d), printed 33--34 / PDF 58--59; chain rules 2.15 and 2.16(c), printed 32--34 / PDF 57--59 | Product KL tensorization adapted to finite PMFs, ENNReal first and explicit Real guards. |
| Section 3.2, Theorem 3.4(b)--(c), (3.2)--(3.3), printed 44--45 / PDF 69--70 | Finite MI/conditional-entropy identities, in nats with first-given-second orientation. |
| Section 6.1, Theorem 6.1(a)--(b), (6.1)--(6.2), printed 106--107 / PDF 131--132 | Product-channel upper bound and independent-source/common-observation lower bound. |

The exact gap is a derived finite identity, not a separately numbered source
theorem. PW24 Example 6.1's last bullet uses coordinate observations, while
(6.2) uses the same observation in every summand; the displayed theorem and XOR
consumer determine the selected source-side contract. Neighboring KL equality
discussion does not justify finite Real cancellation at infinite KL values.

Earlier implementation/reference actors verified the registered source and
inspected the selected pages, as recorded in the notes. The implementation-side handoff
audit inspected those accounts and actual Lean source; it did not freshly
hash, extract or visually inspect the PDF. No textbook text or images are
reproduced here, and no external formalization is claimed as a source.

## Twenty-criterion acceptance map

This is a source/qualification map, not a fresh reviewer verdict. Completed
step records establish C18.01--C18.05 closure. Every criterion remains within
the required fresh cumulative C18.06 review scope.

| Criterion | Concrete evidence or remaining obligation |
| --- | --- |
| C18.01-ENTROPY | `entropy_finiteProduct`, `entropy_iid`; existing family-independence reuse and separate universes. |
| C18.01-EDGES | E1 in FiniteProductSemantics/IidInformation: sparse/non-iid laws, empty/singleton indices, singleton alphabet and zero/one lengths. |
| C18.01-ARCHITECTURE | Focused semantic ownership; preserved probability/root boundaries, historical declarations and simp policy; fresh cumulative qualification pending. |
| C18.02-ENNREAL | Binary/splitting checkpoint and dependent product/iid KL identities, including top and zero length. |
| C18.02-REAL | Coordinate and product finiteness from actual support inclusion; guarded sum/scalar interfaces. |
| C18.02-SUPPORT | K1/K2 sparse supports, singleton alphabet, incomparable overlapping products and failed unguarded Real sum. |
| C18.02-ARCHITECTURE | ProductKL has its two focused imports and private equivalence/induction machinery; historical/root checks remain in cumulative qualification. |
| C18.03-CONDITIONAL | Arbitrary-input, correctly swapped product-channel conditional entropy identity. |
| C18.03-LAWS | Actual marginal-channel joints and genuinely noisy correlated C1 consumers. |
| C18.03-NULL | Supported recovery, absent-coordinate row invariance and explicit unchanged null fallback. |
| C18.04-BOUND | General product-channel bound; noisy correlated and noninjectively encoded-law consumers. |
| C18.04-EQUALITY | General independent pairs, product-input and iid equalities; positive within-pair E2 and zero/one lengths. |
| C18.04-OPTIONAL | Separate gap/iff selection, full output-independence meaning and mandatory C3 delivered; swap regression remains advisory. |
| C18.04-CONSUMERS | Positive/heterogeneous E2, strict/equality C2, parity C3 and concrete H1/C22 objective consumers with focused imports. |
| C18.05-CONDITIONAL | Dependent tuple-to-pair checkpoint and arbitrary-source/four-universe conditional bound without a factorization premise. |
| C18.05-SOURCE | Common-observation MI lower bound from unconditioned full source independence. |
| C18.05-CONSUMERS | XOR MI/conditional strictness and conditional dependence, infinite-carrier heterogeneous/higher-universe observation, empty/singleton endpoints. |
| C18.06-VALIDATION | The initial checkpoint passed the complete maintained clean routine. Actual two-pass API docs and all-fifteen semantic inspection passed separately. Exact-final retained/current API, imports/root/simp, consumers, trust and source/output applicability require their source-bound records; every amendment requires the complete clean rerun and exact API applicability. |
| C18.06-READINESS | Before dispatch: complete owned edits, contextual self-review, separate reassessment, prior-report reconciliation and dispositions against all twenty criteria. Fresh independent review/reconciliation follows this readiness boundary. |
| C18.06-HANDOFF | The maintained handoff is prepared. Exact evidence/status reconciliation, final-source applicability and supported closure are established only by actual source-bound records. |

## Qualification evidence and limits

C18 step notes record successful standalone warnings-as-errors checks, focused
producer/consumer builds, affected aggregates, maintained generated/static and
documentation checks, and compiled compatibility/trust qualification on their
identified inputs. Failed attempts and exact source snapshots remain retained;
passing corrections do not erase those failures. The notes distinguish parent,
implementation-subagent and independent-reviewer execution or inspection.

The preceding C18.05 records report 713 supported declarations in 45 owners,
92 root exports and 94 reviewed simp names. Those are inventory/qualification
facts at the recorded boundary, not declaration targets or a fresh audit run
performed for this handoff. Permitted axioms remain `Quot.sound`,
`Classical.choice` and `propext`.

The implementation-side handoff audit inspected targeted actual
producers/consumers, maintained C16/C17 handoffs, approved C18 Sections 3--7,
relevant notes and pinned variance API. It found no concrete mathematical gap
in the inspected chains. It ran no Lean or validation command, changed no
canonical source, performed no workflow operation and made no independent
acceptance claim. It did not exhaustively re-review every historical C16/C17
proof or independently verify their closure records; intake authority belongs
to the parent. Step 5 closure status above is the parent's verified intake fact.

Earlier step checks do not substitute for the separately recorded C18.06
complete maintained clean routine and actual two-pass API-documentation gate.
These local runs do not establish a cold rebuild, remote-state verification or
publication qualification. Cumulative results must retain their actual command,
actor, source/configuration/dependency identity, outputs, failures and applicability.
Initial checkpoint qualification does not certify any later amended candidate.
Every amendment requires the complete maintained clean rerun and exact API
applicability. Readiness, fresh cumulative independent review/reconciliation,
exact final qualification and supported closure require their actual source-bound
records; this captured account does not assert their outcomes.


### Actual C18.06 local API-documentation evidence

The complete maintained two-pass current file-mode gate returned exit 0 in
693.925 seconds. Both build/check passes and relevant-output
stability passed on unchanged source/configuration/dependency inputs. The parent
inspected actual HTML blocks for all fifteen new declarations across five owner
pages: signatures, hypotheses, docstrings, ownership and file source links.
This is semantic HTML inspection, not browser visual QA or independent-reviewer
execution. Source-content identity is
`735f41c40a81a723accc4ff07db1d81380ea662bbfbeee9198a230df85a93d6d`;
relevant output digest is `2f962ffcabdfebb70a133ee93e343387dcfdf485c781e2412d5c01b0e79f63c1`;
full-tree digest is `bbbda68c1474185bd6c2e89cf4d4b785724b97d1e35a8f22386d89e33fb29235`.

The first attempt remains FAIL: new declaration and aggregate extraction
succeeded, but old aggregate HTML replay left ProductKL/ProductChannel pages
absent. Inspection of the pinned generator justified preserving and invalidating
exactly the ignored Shannon HTML marker and its hash/trace sidecars. The full
two-pass gate then reran. Replayed upstream Qq warnings remain in original logs.
No source, pins or validator changed. The cache recovery did not edit or delete
the docInfo database. Actual streams, result,
configuration, attestation and fifteen-block extraction/assessment are under
`.lit-review/setup/c18-06-20261018/`. These API-documentation results used
existing caches. Their source/output applicability remains distinct from the
separately recorded clean routine and cumulative independent review.

### Authorized initial clean qualification

The lead's direct approval covers the exact 28-path local checkpoint, necessary
C18.06-only review/evidence amendments within that scope, and reuse of
`.worktrees/LeanInfoTheory-C12-validation-20261003`. Initial checkpoint
`8b30dc96e89a9b4e0224b059faed48e19a4e5f1e` passed the complete maintained
clean routine. The actual command, parent actor, duration, process result,
streams, source/dependency identities and checkout/primary preservation evidence
are retained under `.lit-review/setup/c18-06-20261018/clean-01/` and recorded in
the [notes](../plans/post-release-chunk-18-notes.md). This is initial-checkpoint
evidence; every amendment requires the full maintained clean rerun and exact
API applicability. The final candidate and final source capture must match the
applicable clean/API evidence before supported closure.

## Later-chunk prerequisites and remaining work

### C19: finite-iid AEP and typical sets

C16 supplies atom/support laws, iid blocks and pairwise coordinate independence.
Use `isIndependentOf_finiteProduct_eval` followed by
`isIndependentOf_iff_indepFun`, or the lightweight exact pair-law route. The
existing private `coordinate_indepFun` consumer in FiniteProductSemantics
demonstrates the semantic route under explicit measurable hypotheses.
`selfInfo` and `entropy_eq_integral_selfInfo` already supply the finite entropy
expectation interface. C18 supplies entropy of product/iid laws, not AEP.

Pinned `ProbabilityTheory.IndepFun.variance_sum` requires `MemLp` of each summand
and pairwise independence. C19 must connect self-information compositions,
measurability and square-integrability to the chosen variance theorem, or use
another separately approved finite-probability route. The exact product PMF
does not by itself discharge that analytic bridge.

Block-log additivity must be supported or almost everywhere: `selfInfo` is zero
at impossible atoms. C16's `Examples.Iid.sparse_impossible_mass` and
`sparse_impossible_not_supported` retain the word `(0,2)`; `(0,1)` is supported.
C18's sparse entropy consumers preserve this zero-mass boundary. C19 owns the
numerical probability limit over varying finite block spaces, support-aware
weak typical sets, exponential word-mass bounds and the upper/probability-weighted
lower cardinality bounds required by C21. Normalized statements need `n > 0`.
No infinite trajectory PMF, entropy rate or capacity development is a prerequisite.

### C22: actual channel objective and capacity

The objective is exactly `mutualInfo (PMF.channelJoint p W)`.
`mutualInfo_channelJoint_productChannel_le` supplies the upper product argument
at arbitrary correlated word laws; `mutualInfo_channelJoint_finiteProduct`
supplies the lower argument at products of coordinate optimizers. The private
`coordinate_objective_cap` consumer assumes `∀ i p, MI(channelJoint p (W i)) ≤ C i`
and derives the block cap `∑ i, C i`. `independent_input_objective_value` obtains
the corresponding product-law value from coordinate equalities.

C15 supplies finite-PMF compactness and `continuous_mutualInfo_channelJoint`.
`Examples.ChannelOptimization.exists_maximizing_input` already demonstrates
attainment of the actual objective for finite, nonempty inputs. C22 must define
information capacity, relate it to the attained maximum, prove its properties
and capacity examples, and combine these interfaces for product/repeated
capacity. C18 defines no supremum or capacity and proves no operational
achievability. Empty-input optimization and nonempty-input/empty-output
boundaries remain explicit.

### C23: encoded words, repeated channels and Fano

Use the bound at `q = messageLaw.map encode`; a deterministic encoder need not
be injective and induced codewords need not be iid. C18's supported-collision
fixture and `arbitrary_repeated_channel_bound` exercise this directly.
C17's `source_joint`, `source_extension` and encoded endpoint consumers derive
the required sampling identities from `PMF.channelJoint`, `channelComp`,
`channelExtension`, deterministic-channel reductions and their marginal maps.

`isMarkovChain_channelExtension` and existing information data processing are
available for message/input/output packaging. The existing
`mutualInfo_fano_lower_bound_of_uniform_source` supplies the undivided uniform
message bound, without a cardinality-at-least-two premise; its normalized error
variants have their explicit positive-denominator requirements. C22 must supply
the coordinate capacity cap.

C23 still owns message/code/decoder/error definitions, their identification with
existing Fano semantics, the finite inequality
`(1-Pe) * log M ≤ n * C(W) + log 2`, rates and asymptotic weak converse. Preserve
`M ≥ 1`, handle `n = 0` separately, and derive eventual boundedness for
vanishing-error rates rather than assume it. The roadmap distinguishes eventual
above-capacity rates from an infinitely-often excess; the latter gives a
subsequential obstruction, not an eventual error lower bound. No strong converse,
channel achievability, feedback or cost-constrained result is delivered here.

## Repeated private machinery and reopening triggers

C16's seventeen and C17's twelve declarations support the actual chains above;
C18 adds fifteen information theorems. These counts calibrate package usefulness,
not an API quota. Existing PMFs, raw PMF-valued channels and upstream equivalences
remain sufficient. No block datatype or replacement independence notion is needed.

| Observed pressure / disposition | Future owner and concrete trigger |
| --- | --- |
| Full-univ restriction-to-word entropy transport recurs in FiniteProduct, ProductChannel and FiniteFamilyIndependence. | Existing finite-family semantic owners, under a separately approved API cleanup or another real consumer requiring the same bridge. Review PMF/RV forms and naming before promotion; C18.06 needs no additional theorem. |
| Private `klDiv_map_equiv` occurs in DataProcessing and ProductKL. The former's comment anticipated another production consumer, which now exists. | KL/DataProcessing maintainers: assess a common relabeling theorem only through explicit ownership/API review. Dependency order matters: DataProcessing's older helper precedes its public map-contraction theorem, while ProductKL derives invariance from that theorem. Do not introduce a cycle by mechanically moving the short proof. |
| Supported row recovery repeats privately in ProductChannelSemantics and ProductChannelInformation. | Markov/conditional-channel owner when C23 or another independent production consumer needs that exact support-qualified contract. Preserve the swapped joint and null fallback; do not export unrestricted recovery. |
| Private weighted row-entropy, finite expectation transport, pair marginal normalization and Option splitting solve local proof needs. | Their existing focused owners only after concrete repeated production use. One induction or a convenient rewrite is not evidence for a public abstraction. |
| Classical/native finite-Pi instances require typed facts and `convert!` in several producers/consumers. | Later implementation work should reuse the local proof pattern; revisit API shape only if recurring downstream friction is recorded. No public DecidableEq or universe restriction is justified by this elaboration issue. |
| Small fair/sparse fixtures recur across example owners. | Keep private to preserve focused imports. A shared public fixture or cross-example dependency needs a substantive consumer requirement, not code deduplication alone. |
| `Probability.Iid` also owns general non-iid ordered block transports; inverse/singleton/binary wrappers remain private. | Notes 14/31 and recorded downstream discovery friction govern naming/alias review. Do not rename or pad the retained API during cumulative qualification. |
| Coordinate-swap counterexample remains an advisory illustration. | A separately selected C22/C23 use that actually confuses independent inputs with product-channel structure; add a focused private regression only if useful. |
| AEP/typicality, capacity and coding are not supplied by this package. | Separate C19/C22/C23 plans and explicit selection, with the exact prerequisites above. Infinite alphabets/processes and new channel representations require a separate scope decision. |

This handoff retains these dispositions and updates only actual
qualification/status facts as C18.06 progresses. It must not claim future
clean/API/review/closure evidence in advance or imply that this package starts
the next chunk automatically.
