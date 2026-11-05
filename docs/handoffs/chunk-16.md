# Chunk 16 maintained handoff: finite products and iid block laws

## Status and authority

**INITIAL CHECKPOINT QUALIFIED — 2026-10-14; final qualification pending.** C16.01--C16.04 and their review processes are
complete by the source-bound private records. C16.05 is selected for cumulative
qualification, canonical reconciliation and this maintained handoff. The
[approved revision-2 plan](../plans/post-release-chunk-16.md) governs all 15
criteria. The [notes](../plans/post-release-chunk-16-notes.md) retain original
attempts, implementation decisions, report reconciliations and evidence limits.
Revision 1's formal PLAN review is historical; it is not a formal review of
revision 2.

C16.05 adds no mathematical endpoint.
On 2026-10-14 the lead authorized the exact prepared 24-file local checkpoint,
necessary C16.05-only corrections and final-evidence amendments within those
paths, and reuse of the inspected clean detached validation checkout. The
three protected files and pre-existing relocation log entry remain excluded.
Initial checkpoint `d9a3f32d396cbad91c10c7778b00d0cae50361e3` passed the complete
maintained clean routine suite; the runner recorded 3293.619 seconds.
The actual two-pass current file-mode API-doc gate and all-three-owner inspection
passed separately on their recorded primary source/configuration. The failure
and recovery history remain retained. Every amended candidate needs complete
clean routine revalidation and exact API-doc applicability. Readiness, fresh
all-15-criterion review, report reconciliation and final-source closure remain
required. Only `.lit-review/setup/c16-05-completion-20261014.json`, when present, and the
user report establish final completion; this captured status remains provisional.
C17--C19, push, publication and dependency changes are not selected.

## Delivered public interface

The chunk adds exactly 17 declarations: two definitions and 15 theorems, with
no new public instance, alias or simp attribute. `PMF` owns the probability
interfaces; the semantic bridges belong to `LeanInfoTheory.Shannon`.

| Focused owner | Exact public declaration | Contract |
| --- | --- | --- |
| [`Probability.FiniteProduct`](../../LeanInfoTheory/Probability/FiniteProduct.lean) | `PMF.finiteProduct` | Normalized dependent product law from supplied component PMFs. |
| Same | `PMF.finiteProduct_apply` | Atom mass equals the finite product of coordinate masses. |
| Same | `PMF.mem_support_finiteProduct_iff` | Support is exactly coordinatewise support. |
| Same | `PMF.finiteProduct_map_eval` | Evaluation pushforward recovers the chosen component PMF. |
| Same | `PMF.finiteProduct_of_isEmpty` | An empty index gives the pure empty outcome. |
| Same | `PMF.finiteProduct_pure` | Pure components give the pure dependent tuple. |
| Same | `PMF.finiteProduct_map_reindex` | Equivalence precomposition transports the component family. |
| Same | `PMF.finiteProduct_map_restrict` | Injective coordinate selection gives the selected product. |
| Same | `PMF.finiteProduct_map_sum` | Sum-indexed products split into ordered left/right blocks. |
| Same | `PMF.finiteProduct_map_pair` | Distinct evaluations give the constant-channel joint law. |
| [`Probability.Iid`](../../LeanInfoTheory/Probability/Iid.lean) | `PMF.iid` | Thin constant-family specialization on `Fin n → A`. |
| Same | `PMF.finiteProduct_map_append_symm` | Split a general non-iid `Fin (m+n)` product into prefix and suffix. |
| Same | `PMF.channelJoint_finiteProduct_map_append` | Concatenate independent product blocks, allowing different component laws. |
| Same | `PMF.iid_map_perm` | Coordinate permutations preserve the iid law. |
| [`Shannon.SemanticBridge.FiniteProduct`](../../LeanInfoTheory/Shannon/SemanticBridge/FiniteProduct.lean) | `LeanInfoTheory.Shannon.familyMarginal_finiteProduct` | Existing selected marginal equals the selected product. |
| Same | `LeanInfoTheory.Shannon.isMutuallyIndependentFamily_finiteProduct` | Existing mutual independence holds on every selected finite atom. |
| Same | `LeanInfoTheory.Shannon.isIndependentOf_finiteProduct_eval` | Distinct evaluations satisfy existing random-variable independence. |

### Hypotheses, orientations and edge cases

The general constructor takes `{I : Type u} {A : I → Type v}`,
`[Fintype I] [∀ i, Fintype (A i)]` and `p : ∀ i, PMF (A i)`.
Index and alphabet universes are independent; one dependent family has a common
fiber universe. No public `DecidableEq`, nonempty-index, component-nonempty,
positive-mass or full-support hypothesis is added. Atoms are `ENNReal` values;
zero masses are allowed. Normalization reuses `PMF.ofFintype` and
`Fintype.prod_sum`, rather than a second probability representation.

Restriction uses `e : J ↪ I`, with an independent index universe for `J`:
the map is `fun x j => x (e j)` and the exact target alphabet is
`fun j => A (e j)`. Reindexing uses `e : J ≃ I` and
`(Equiv.piCongrLeft A e).symm`, definitionally the same precomposition.
Inverse transport and nested-selection equality are consumer derivations, not
additional public aliases. An arbitrary coordinate map is insufficient:
duplicating a fair Boolean coordinate gives zero off-diagonal mass, whereas
the independent pair gives mass `1/4`.

Sum splitting maps by `Equiv.sumPiEquivProdPi A`; `Sum.inl` is the first
block and `Sum.inr` the second. Its result is `PMF.channelJoint` of the first
product with the constant second-product channel. Pair projection similarly
requires `hij : i ≠ j` and preserves the stated `(i,j)` order. That constant
channel law is definitionally the released `Shannon.indepProd`; compatibility
is retained privately without a redundant public bridge name.

For homogeneous blocks, `PMF.iid p n` is definitionally
`PMF.finiteProduct (fun _ : Fin n => p)`. The general split has explicit
lengths `m n`, maps by `(Fin.appendEquiv m n).symm`, and selects prefix
coordinates with `Fin.castAdd n` and suffix coordinates with `Fin.natAdd m`.
Concatenation infers lengths from `p : Fin m → PMF A` and `q : Fin n → PMF A`,
maps by `Fin.appendEquiv m n`, and returns the product of `Fin.append p q`.
These transports do not assume iid. Permutations use `fun x i => x (e i)`.
No project block datatype, split operator or reassociation API is introduced.

For arbitrary ambient `Var` and `s : Finset Var`, instantiate the constructor
with `I := s`: only `[∀ i : s, Fintype (A i.1)]` and selected component PMFs
are needed, without a finite ambient index or an ambient joint law. The full-law
semantic bridge deliberately starts with a finite full product instead.
`FamilyOutcome A s` is already the selected dependent function type.
Both existing mutual-independence predicates retain their arbitrary-type
generality; new finiteness requirements apply only to constructor uses.

An empty index admits a product even over an empty ambient alphabet, as
`Fin 0 → Empty` has one outcome. A selected empty alphabet admits no component
PMF. In particular, `iid p 0` still requires its supplied base law and cannot
manufacture `PMF Empty`. Singleton evaluation and inverse transport, pure
components, singleton alphabets, `0+n` and `n+0` are retained consumers.
Normalized information statements with positive blocklength belong later.

### Imports and preserved semantics

`Probability.FiniteProduct` has only `Probability.FiniteChannel` as a direct
project import; its other imports are focused mathlib algebra/equivalence
owners. `Probability.Iid` imports it plus `Mathlib.Logic.Equiv.Fin.Basic`.
Neither probability owner reaches project Shannon or finite-topology owners.
The semantic owner imports the product owner and the existing
`SemanticBridge.FiniteFamilyIndependence`.

The old mutual-independence owner preserves both original direct imports and
adds the downward `Probability.FiniteProduct` import. Only its private
`familyProduct` construction is replaced by the public constructor on selected
coordinate marginals; predicates, public signatures, attributes and meanings
are preserved. Private induction and transport helpers remain private.

The full `LeanInfoTheory.Shannon` umbrella includes both probability owners;
its semantic aggregate includes the bridge. The three private example owners
join only `LeanInfoTheory.Examples`. The root still imports exactly
`Probability.Finite` and `InformationMeasures`, with its five-module local
closure and 92 exports. The focused semantic route includes existing released
information results but requires no future C18 owner.

## Permanent consumers and cumulative acceptance map

All new example helpers are private. Tiny fixtures are repeated where needed
to preserve focused imports; one example owner does not import another to
share its fixture.

| Consumer | Retained coverage |
| --- | --- |
| [`Examples.FiniteProduct`](../../LeanInfoTheory/Examples/FiniteProduct.lean), L1a--L6 | Fair Boolean/sparse ternary dependent laws; exact atoms, support and coordinate marginals; singleton selection; genuine three-coordinate non-iid data; nested restriction and heterogeneous reindexing in both directions; independent universes; ordered sum split/reconstruction and pairs; empty/singleton/pure products; duplicate-coordinate failure; selected-only finiteness over a concrete infinite `ℕ` ambient family. Sole import: its focused probability owner. |
| [`Examples.Iid`](../../LeanInfoTheory/Examples/Iid.lean), B1--B3 | General laws specialized to fair/sparse iid blocks; genuine permutation and injective selection; non-iid `1+2` split/reconstruction and orientation; iid specialization; zero/one lengths and both empty sides; singleton/empty alphabet distinctions; sparse word `(0,2)` has zero mass while `(0,1)` has mass `1/4`. Sole import: its focused block owner. |
| [`Examples.FiniteProductSemantics`](../../LeanInfoTheory/Examples/FiniteProductSemantics.lean), S1/S2 | Existing selected-outcome/marginal/support semantics; empty/singleton/two-coordinate independence; identity-source semantics; both ordered `indepProd` pairs and an impossible atom; full three-coordinate non-iid mutual independence through the new public bridge, with full atom cardinality three and differing fair/biased Boolean laws; existing `IndepFun` bridge under explicit measurable hypotheses. Sole import: the focused semantic owner. |
| Existing [`Examples.FiniteFamily`](../../LeanInfoTheory/Examples/FiniteFamily.lean) and separate I1 probes | Retained semantic consumers; probability-only and semantic import boundaries; arbitrary-type old predicates; independent universes and selected-only finiteness. Generated import/trust probes supplement permanent mathematical examples. |

This acceptance map identifies evidence and remaining qualification; it is not
a fresh cumulative reviewer verdict.

| Criterion | Source or qualification obligation |
| --- | --- |
| C16.01-LAW | Constructor normalization, exact atoms/support, supported and impossible heterogeneous outcomes. |
| C16.01-MARGINALS | Evaluation, empty and pure laws; singleton evaluation/reconstruction consumers. |
| C16.01-BOUNDARY | L1a/L4/L6, including selected finite fibers in an infinite ambient family; probability-only import probe. |
| C16.02-TRANSPORT | Injective restriction, dependent reindexing, nested/direct agreement and heterogeneous inverse transport. |
| C16.02-SPLIT | Ordered sum split/inverse consumer, both block marginals, distinct-pair law and empty sides. |
| C16.02-REPETITION | Fair-coordinate duplication has off-diagonal mass zero versus independent mass `1/4`. |
| C16.03-IID | Thin iid definition; generic atom/support/marginal use, genuine permutation and injective selection. |
| C16.03-BLOCKS | General non-iid Fin transports, explicit `1+2` orientation and reconstruction, iid specialization. |
| C16.03-DEGENERATE | Zero/one lengths, both empty sides, singleton alphabets, impossible symbols and empty-base-law distinction. |
| C16.04-FAMILY | Exact existing family marginal and independence bridges; identity source; full non-iid three-coordinate atom. |
| C16.04-INDEPENDENCE | Ordered `indepProd` compatibility, existing `IsIndependentOf` and conditional use of the existing `IndepFun` bridge without C18. |
| C16.04-COMPATIBILITY | Private-constructor reuse, retained public contracts/imports, old finite-family and both lightweight consumers. |
| C16.05-VALIDATION | Initial authorized checkpoint `d9a3f32d396cbad91c10c7778b00d0cae50361e3` passed the complete clean routine suite. The separate actual two-pass API-doc gate and owner inspection passed on their recorded inputs. Each amendment requires renewed complete clean routine validation and exact API-doc/final-source applicability. |
| C16.05-READINESS | Pending: finish owned edits, retain actual validation, contextual self-review and separate reassessment, and reconcile all earlier reports before fresh independent review of all 15 criteria. Review receipt/reconciliation and closure follow separately. |
| C16.05-HANDOFF | This handoff and canonical reconciliation must preserve precise APIs, reference adaptations, boundaries, remaining-work owners and actual evidence limits before final capture. |

## Mathematical sources and adaptations

[PW24](../references.md#pw24-polyanskiy-and-wu-newer-draft) is the registered
August 16, 2024 draft, SHA-256
`c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
The planning notes record reading and visual inspection of §6.1, Theorem 6.1
and proof, printed pages 106--107/PDF 131--132, and §11.2, Proposition 11.6
and proof, printed pages 217--218/PDF 242--243. These provide product notation
and downstream context. C16 proves finite normalization and transport through
PMF algebra; it does not establish those sections' information, channel or AEP
results. No fresh textbook inspection is claimed by this closeout preparation.

The selected formalization uses finite dependent functions, actual PMF support,
explicit embeddings/equivalences and existing family predicates. Canonical
information units remain nats, though no information identity is added here.
PW24's typicality definition and later proof wording use differing strict/closed
inequalities; C19 must choose one consistent support-aware event convention.
Do not transfer numbers from PW22, infer full support from the notation, or
copy an unrestricted block-log identity. Private PDFs remain reference material,
not source-capture inputs or committed artifacts. No external formalization
implementation was consulted for this work.

## Evidence, inventory and growth

C16.01--C16.04 are complete with review. Their notes record focused strict
owner/consumer/aggregate builds, standalone consumers and import probes,
source-derived static/documentation checks, and full trust/compiled
compatibility. Earlier checks retained all 601 historical signatures and only
the permitted `Quot.sound`, `Classical.choice` and `propext` axioms. These are
predecessor results, not a substitute for C16.05's cumulative gates.

The current manifest records 686 documented declarations in 42 supported
owners: 611 theorems, 63 definitions, nine abbreviations and three instances.
There are 72 local modules, including 30 non-stable modules, with 94 reviewed
simp declarations and 92 root exports. C16 adds 17 declarations and three
supported owners to the C15 baseline of 669/39; the historical release remains
601 declarations in 31 owners. Current generated inventory records the source,
not approval. Growth approval is recorded separately in the reviewed policy.

The normalized dependent product and its transport/factorization laws are the
main new infrastructure. `iid` is deliberately a thin definition; permutation
and semantic compatibility reuse general laws; singleton and inverse variants
remain private derivations. The 17-name increase is not 17 independent deep
results. It is the first delivered portion of the roadmap's C16--C18 package;
reassess that package after C18 using actual channel/information consumers.
Neither the rough declaration estimate nor the programme's approximate total
is a quota or a reason to add wrappers.

The lead granted the exact 24-file scoped checkpoint, C16.05-only amendment
and inspected-checkout reuse authority on 2026-10-14. Continue preserving the unrelated `.gitignore`, `AGENTS.md`, `docs/next-website-tasks.md`
changes and the pre-existing project-log relocation entry; do not absorb them
into a C16 checkpoint. Inspect any proposed checkout under ignored `.worktrees/`
and compare source, configuration and dependency inputs rather than assuming
an earlier chunk's authorization or attestation applies.

The complete maintained routine suite requires a clean committed candidate.
The actual API-doc gate is separate: two current file-mode build/check passes
and inspection of all three new focused owner pages, with exact source,
dependency, configuration and output applicability. Windows uses the reviewed
Zig 0.16.0 tool. Current output belongs in `docbuild/.lake/build/doc/`, not the
frozen historical release route; local file-mode output is not publication
evidence. Retain actual commands, failures, actor identities and cache limits;
an incremental pass is not a cold rebuild. Every amendment requires renewed
required gates and exact applicability. Fresh all-15-criterion review and its
original-report reconciliation remain mandatory after readiness.

### Actual API-documentation qualification

The actual current file-mode API-documentation gate passed both build/check
passes on stable source inputs (659.475 seconds). All 17 new declaration HTML
blocks were inspected for exact owner, signature, hypotheses, docstrings and
file source links; rendered inspection covered all three focused owner pages.
The exact v2 source/configuration/dependency identity, relevant-output digest
and two-pass attestation are retained privately. Whole-tree digest evidence
comes from the maintained gate, separately from the fresh owner-page inspection.
The reviewed Zig 0.16.0 and pinned incremental caches were used; no cold rebuild
or publication qualification is claimed.

The first attempt failed after new declaration extraction because the aggregate
HTML reused an old completion marker and omitted all three owner pages. The
original 529.920-second failed result and unchanged-input captures are retained.
After inspecting the pinned generator, the parent preserved and invalidated
exactly its three ignored Shannon HTML marker/hash/trace files and reran both
actual passes. No source, dependency or validation rule changed. Replayed
upstream Qq extraction warnings remain in the logs. Current output remains in
`docbuild/.lake/build/doc/`, outside the frozen historical release route.

At the October 13 API-qualification stage, clean checkpoint/reuse authority
was still pending. The later scoped approval and actual initial clean-suite
result are recorded below.
The API-doc result does not replace that gate, fresh all-15-criterion review,
original-report reconciliation or final-source applicability. The source-bound
private completion record alone establishes eventual closure.

### Authorized initial checkpoint qualification, 2026-10-14

On 2026-10-14 the lead authorized the exact prepared 24-file local checkpoint,
necessary C16.05-only corrections and final-evidence amendments within those
paths, and reuse of the inspected clean detached validation checkout. The
three protected files and pre-existing relocation log entry remain excluded.
The authorized checkout is
`C:/Users/coban/Desktop/Lean Info Theory/.worktrees/LeanInfoTheory-C12-validation-20261003`.
No push, tag, publication, dependency/review-setting change or later-chunk work
is authorized by this scoped approval.

Initial checkpoint `d9a3f32d396cbad91c10c7778b00d0cae50361e3` passed the complete
maintained clean routine suite; the runner recorded 3293.619 seconds.
The actual command was `python -B scripts/validate_release.py` in the authorized
validation checkout. Its recorded exit code is zero. The checkout was clean
and detached before and after the suite, its tracked files equal the exact
committed blobs, and all 24 selected blobs match the proposal. Primary and
validation inputs stayed unchanged during the suite; all nine root dependencies
remained clean at their configured revisions, and authority inputs were unchanged.
Original streams, actual command/result, source inventories, checkout comparison
and dependency identities remain under
`.lit-review/setup/c16-05-20261013/full-checkpoint/`.

The complete maintained gate includes default and strict builds, README and
website-guide consumers, retained/current compatibility, import/root/simp
contracts, the permitted-axiom audit, generated references, legal/release
metadata, website checks and final clean hygiene. Existing incremental caches
were used; this is not a cold rebuild or a replacement for mathematical review.

The primary checkout retains `.gitignore`, `AGENTS.md`,
`docs/next-website-tasks.md` and the exact earlier relocation log entry. The first
three files are excluded wholesale; the mixed project-log selection excludes
only that historical entry and preserves its original working bytes. The two
selected blueprint files differ only by declared CRLF/LF representation across
checkouts. The historical C9-notes/frozen-manifest CRLF/LF differences are also
recorded. Whole-checkout raw-byte identity is not claimed.

The earlier actual two-pass current file-mode API-doc gate (659.475 seconds)
and inspection of 17 declaration blocks/all three owner pages remain separate
evidence, bound to their exact primary source, configuration, dependencies and
recorded outputs. This clean routine neither reruns that gate nor renews its
attestation. Its applicability to the checkpoint and each amendment must be
recorded separately, accounting for the declared cross-checkout differences.
The retained initial API failure, bounded cache recovery and output provenance
are unchanged; local output is not publication evidence.

This qualifies the initial checkpoint, not subsequent amendments. Every
amended candidate requires complete clean routine revalidation and exact
API-documentation/source/configuration/dependency applicability. Finished
owned edits, retained contextual self-review and separate reassessment, and
earlier-report reconciliation must establish readiness before fresh review
of all 15 criteria. The original cumulative report, its reconciliation,
final-source qualification and supported closure remain required. Only
`.lit-review/setup/c16-05-completion-20261014.json`, when present, and the user report
establish actual final completion; this captured prose is provisional.

## Remaining work, owners and triggers

| Disposition | Owner and trigger |
| --- | --- |
| Delivered mathematical scope: C16.01--C16.04 and permanent L1a--L6/B1--B3/S1/S2 consumers. | C16.05 qualifies the cumulative source without adding a new endpoint. Source-bound predecessor records establish earlier completion. |
| Final amended-candidate qualification, canonical reconciliation and supported closure remain required. | C16.05: remain within the authorized 24 paths, preserve protected bytes, repeat the complete clean routine after every amendment, and establish exact API-doc applicability; finish readiness, obtain/reconcile fresh all-15-criterion review, and bind final evidence to final source. |
| Keep `Probability.Iid` despite its general non-iid block transports. | Naming/watchlist work only after concrete recorded discovery friction. A rename was not selected in revision 2. |
| Keep singleton/inverse/zero-iff/source-facing/`indepProd` variants and proof machinery private. | Future Work Notes 14/29 and actual independent consumer pressure; no speculative aliases, normalization wrappers or global abstraction. |
| Product channels and coordinatewise processing are deferred. | Separately approved C17 plan; revisit Future Work Note 31 with actual product-channel consumers and explicit lightweight ownership. |
| Product entropy/KL and block information inequalities are deferred. | Separately approved C18 plan; include the deferred paired-product support regression alongside singular KL cases. |
| Self-information, integrability, variance, AEP and typical sets are deferred. | Separately approved C19 plan; retain supported/a.e. log additivity and sparse impossible-word regression. |
| Infinite component alphabets and infinite products are outside C16. | Require a new concrete use and separate scope decision; selected finite fibers over an infinite ambient index do not establish these results. |
| No new PMF representation, global independence predicate, block datatype or speculative equivalence API. | Rejected for this chunk because existing PMF/family/upstream equivalence interfaces suffice; reconsider only through separately justified requirements. |
| No later-chunk start, reviewer-binding transfer, push or publication. | Fresh lead selection and the applicable independent authority/process; this handoff supplies prerequisites only. |

### C17 prerequisites and remaining contract

C17 can construct each conditional block law from `finiteProduct` and use its
atom/support/evaluation/restriction/split interfaces. Channels remain raw
PMF-valued functions; reuse `PMF.channelJoint` and `channelComp`. Memorylessness
constrains output coordinates given an input word, not the input distribution.
C17 must supply its own product-channel constructor/specialization, composition,
deterministic reductions and joint-law compatibility, with both independent and
correlated input consumers and zero/one lengths. No product channel is delivered
by C16. Sources and ownership pressure are PW24 §6.1/§19.1 and Future Work Note 31.

### C18 prerequisites and remaining contract

C18 receives exact masses/marginals/transports and full mutual independence
through the existing family predicate. Reuse the existing finite-family
entropy-additivity characterization to derive product entropy and iid
`H(p^n) = n * H(p)`. Product KL remains an `ENNReal` statement first; Real
forms need their actual support/finiteness guards, including empty and singular
products. C17 then supplies memoryless channels for conditional-output entropy
and the correlated-input MI upper bound. The complementary independent-source
inequality has a different contract and must not assume product conditional laws.

The exact MI gap and equality iff output coordinates are mutually independent
remain preferred optional refinements for detailed C18 planning, not new
required C16 endpoints. Pairwise independence is insufficient for that equality
criterion; independent inputs are sufficient, not necessary. Capacity additivity
remains C22. The exact roadmap requirements remain in
[C18](../plans/post-release-chunk-map.md#c18-block-information-and-single-letterization).

### C19 prerequisites and remaining contract

C19 has two routes to coordinate independence: the lightweight
`finiteProduct_map_pair`, or the focused semantic
`isIndependentOf_finiteProduct_eval` followed by existing
`isIndependentOf_iff_indepFun`. The private semantic consumer demonstrates the
latter under explicit measurable hypotheses. This route is available without
any C18 owner, but does not itself prove measurability of future self-information
compositions or their square-integrability.

Reuse `selfInfo` and `entropy_eq_integral_selfInfo` from
[`SemanticBridge.Entropy`](../../LeanInfoTheory/Shannon/SemanticBridge/Entropy.lean).
The pinned candidate `ProbabilityTheory.IndepFun.variance_sum` in
`Mathlib/Probability/Moments/Variance.lean` requires `MemLp` and pairwise
independence of the summands. C19 must connect those obligations to finite PMFs,
or justify another approved finite-probability proof route.

The required AEP is a numerical event-probability limit over varying finite
block spaces; normalized statements require `n > 0`. Supported/a.e. block-log
additivity is essential: `selfInfo` is zero at impossible atoms, and C16's sparse
word `(0,2)` is the regression against an unrestricted identity. C19 must supply
support-aware typical sets, probability tending to one, exponential word-mass
bounds and the upper/probability-weighted lower cardinality bounds required by
C21. The Chebyshev estimate is a preferred feasibility target, not an extra
endpoint automatically selected by C16. No infinite trajectory PMF, entropy
rate, strong typicality or exponential convergence rate is promised. Sources are
CT91 §§3.1--3.3 and PW24 §11.2, Proposition 11.6; see the exact
[C19 roadmap contract](../plans/post-release-chunk-map.md#c19-self-information-finite-iid-aep-and-typical-sets).
