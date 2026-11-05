# Chunk 17 maintained handoff: product channels and memoryless extensions

## Status and authority

**CUMULATIVE QUALIFICATION — 2026-10-16.** C17.01--C17.04 and their reviews
are complete by actual records. The lead approved the concrete nineteen-path
local checkpoint, necessary C17.05-only amendments within that scope, and reuse
of the inspected clean detached validation checkout. Initial checkpoint
`06c9610be44e8f0d5ecfc6f850a011137db341bc` passed the complete maintained clean routine.
Separate actual two-pass current file-mode API docs and semantic inspection of
all twelve declaration signatures/docstrings and source links passed.

This maintained handoff is captured before final closure. It does not itself
assert completed C17 qualification: the exact amended candidate needs its own
applicable clean routine, retained contextual self-review and separate
reassessment, fresh all-fifteen-criterion independent review, every reconciliation
and supported final capture/closure. The [approved plan](../plans/post-release-chunk-17.md)
owns all fifteen criteria; the [notes](../plans/post-release-chunk-17-notes.md)
retain source-bound evidence and failures. Actual completion is established only
by `.lit-review/setup/c17-05-completion-20261016.json`, when present, and the final
user report. Earlier step checks alone do not discharge cumulative duties.

The three protected files and unrelated log entry remain excluded and preserved.
No push, tag, release, publication, downstream change or later chunk is authorized.
Toolchain, dependency pins, mathematical source and review tooling are unchanged.

## Delivered public interface

C17 supplies raw PMF-valued product channels independently of any input law.
Memorylessness means independent conditional output coordinates at a supplied
input word; it imposes no independence on the input law or unconditional output.

The sole new supported owner is
[`Probability.ProductChannel`](../../LeanInfoTheory/Probability/ProductChannel.lean),
in namespace `PMF`: two definitions and ten theorems, with no public alias,
instance or simp addition.

| Declaration | Contract |
| --- | --- |
| `productChannel` | Conditional product from supplied coordinate channels, reusing `finiteProduct`. |
| `productChannel_apply` | Row atom equals the product of coordinate row masses. |
| `mem_support_productChannel_iff` | Row support is exactly coordinatewise support. |
| `productChannel_map_eval` | Output evaluation recovers the selected input row. |
| `productChannel_map_restrict` | Injective output selection gives the selected product at the selected input. |
| `finiteProduct_bind_productChannel` | Independent input products give the product of coordinate output laws. |
| `channelComp_productChannel` | Sequential product channels compose coordinatewise in sampling order. |
| `productChannel_deterministicChannel` | Deterministic coordinate channels form the existing deterministic word channel. |
| `memorylessChannel` | Thin identical-channel specialization on `Fin n`. |
| `channelJoint_productChannel_map_eval` | Coordinate joint uses the actual input marginal. |
| `channelJoint_productChannel_map_restrict` | Restricted joint uses the actual restricted input law. |
| `finiteProduct_channelJoint_map` | Independent-input whole joint is the transported product of coordinate joints. |

### Hypotheses, orientations and boundaries

The constructor takes `{I : Type u}`, `{A : I → Type v}`, `{B : I → Type w}`,
`[Fintype I]`, `[∀ i, Fintype (B i)]` and `W : ∀ i, A i → PMF (B i)`.
The index, input and output universes are independent; each dependent fiber
family has a common universe. No finite-input, public `DecidableEq`, positive-mass,
full-support or nonempty-index premise is required. Independent-input bind and
whole-joint factorization additionally require finite input fibers. Composition
requires finite intermediate and final outputs, but permits infinite original
inputs. Arbitrary-input joint projections do not require finite inputs.

Atoms are `ENNReal` masses, including zeros. Restriction uses `e : J ↪ I`,
with a separate universe for `J`; selected fibers are exactly `A (e j)` and
`B (e j)`. Injectivity prevents treating two uses of one output sample as
independent samples. Finite selections from infinite ambient indices first
instantiate the constructor on a finite selected subtype; no infinite product
is constructed or projected.

`memorylessChannel W n` repeats a supplied base channel. Empty indices give the
pure empty output; a zero-length specialization still requires the supplied
base channel. Empty input types permit vacuous channels, while an inhabited
input cannot have a PMF-valued row on an empty output. Positive-length empty
input words admit no PMF. No positive-blocklength premise is imposed.

Reindexing is simultaneous input/output covariance, not fixed-input invariance.
Ordered blocks reuse C16 and the existing `Fin.appendEquiv`, with prefix
`Fin.castAdd` and suffix `Fin.natAdd`; both marginals and inverse concatenation
are exercised. Independent joint factorization maps a word of pairs to a pair
of words using `Equiv.arrowProdEquivProdArrow I A B`. The inverse remains a
private consumer, not an additional exported alias.

### Imports and retained interfaces

The producer imports only `Probability.Iid`, reaching the existing finite
product and raw channel algebra. It imports no project Shannon, information,
topology or semantic owner. The full `LeanInfoTheory.Shannon` umbrella imports
it; the lightweight root retains `Probability.Finite` and `InformationMeasures`,
its five-module local closure and 92 exports. Current source inventory is 698
declarations in 43 supported owners, with 94 reviewed simp declarations.
The frozen v0.1.0 surface remains a separate historical contract.

[`Examples.ProductChannel`](../../LeanInfoTheory/Examples/ProductChannel.lean)
imports only the probability owner. Its helpers are private and cover:

- heterogeneous Boolean/sparse ternary rows, supported and zero atoms,
  nested restriction, heterogeneous reindex round trips, finite selections
  from `Nat`, repeated-output failure and separate universes;
- independent processing, order-sensitive stochastic composition, infinite
  original inputs and deterministic identity/constant/pre/postprocessing;
- genuine nonconstant-input permutation covariance, nonidentical `1+2` blocks,
  inverse concatenation, both marginals, dependent sum blocks, zero/one lengths,
  empty sides, singleton outputs and vacuous boundaries;
- exact arbitrary-input joints and sequential endpoints, sparse factorization
  in both directions, and iid zero/one specialization;
- diagonal correlated inputs through identity and noisy channels: the noisy
  all-false output mass is `1/8`, versus `1/16` for the product of marginals;
- independent fair source bits encoded by `(a,b) ↦ (a,a)`, a nonconstant map
  with supported collisions and correlated codewords, with exact source/joint/
  extension sampling identities and no injectivity premise.

[`Examples.ProductChannelSemantics`](../../LeanInfoTheory/Examples/ProductChannelSemantics.lean)
imports exactly the product owner, `SemanticBridge.FiniteProduct` and
`SemanticBridge.Markov`. It privately reaches selected/full family independence
for nonidentical rows and independent coordinate pairs, and the retained binary
`indepProd` processing expression. Both examples join only the Examples aggregate.

Supported reconstruction has the generic contract
`condFstGivenSndChannel ((PMF.channelJoint q K).map Prod.swap) x = K x`
for `x ∈ q.support`, with arbitrary input type and finite output type. The swap
is essential: conditional entropy/recovery is first-given-second. Product and
natural-number input specializations compile. At null inputs the unchanged
fallback is `q.bind K`, a totalization convention without conditional meaning.
Two raw product channels differing at an absent coordinate value induce equal
joints while remaining unequal functions; no global row-recovery law is asserted.

## Mathematical sources and adaptations

The registered PW24 draft is identified in [references](../references.md) by
SHA-256 `c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
Section 6.1, Theorem 6.1/proof (printed 106--107, PDF 131--132), distinguishes
memoryless-channel assumptions from independent-source assumptions. Section
19.1 (printed 370--375, PDF 395--400), especially Definition 19.1 and
(19.1)--(19.3) on printed 371--372, supplies finite-block channel conventions.
The earlier C17 notes record actual reading; qualification preparation rechecked
the retained selected-page extraction rather than claiming a new PDF visual audit.

The public repeated-channel name denotes the identical-coordinate, stationary
memoryless specialization; the general product permits nonidentical coordinates.
C17 adapts the conditional-law construction to finite dependent output fibers
and existing PMF algebra. It proves no source information bound, capacity,
coding theorem, infinite process or feedback result. No matrix replaces the
raw channel representation. No external formalization was consulted.

Future Work Note 31's constructor/ownership question is discharged by the
lightweight product owner and independent permanent consumers. Its raw-channel
and minimal-API discipline remains a standing guardrail. The old binary MI law
is unchanged; exact compatibility is a private consumer, not a public alias.
Further naming/alias proposals remain evidence-driven under Note 14.

## Qualification and cumulative acceptance map

Actual predecessor records are `.lit-review/setup/c17-01-completion-20261015.json`
through `c17-04-completion-20261015.json`. Step 4 closure is
`931d93ec216c50b0486e88862de2380153f56598a03e42e82a923fd4d814f3c0`,
with F `a2069e0b0bcf4bf724b6c16e2bd82b6a0a61abfe0de139ef3b52040eeb0cfb7a`.
All four records have three satisfied criteria, no findings and explicit report
reconciliation. They establish completed steps, not C17.05 qualification.

| Criteria | Permanent evidence / remaining closeout duty |
| --- | --- |
| C17.01-ROWS / RESTRICTION / BOUNDARY | Producer constructor/row laws; private P1/P2, finite-selection, universe and empty/infinite-input consumers. |
| C17.02-BIND / COMPOSITION / DETERMINISTIC | Producer algebra; heterogeneous sparse, order-sensitive noisy and deterministic consumers. |
| C17.03-MEMORYLESS / BLOCKS / DEGENERATE | Thin specialization; private B1/B2 covariance, split/inverse/marginal and zero/one/empty consumers. |
| C17.04-JOINT / FACTORIZATION / SEMANTICS | Exact joint laws and private J1--J4/S1/S2, including correlated noisy inputs, supported collisions and null fibers. |
| C17.05-VALIDATION / READINESS / HANDOFF | Initial clean routine and separate actual two-pass API docs/signature inspection passed. Exact amended-candidate qualification, readiness, fresh all-fifteen review, reconciliation and closure are established by actual source-bound records. |

Step 4's focused/standalone/static/documentation/trust checks and the independent
reviewer's fresh checks passed on their recorded source. Exact current reuse
must be explicit; it is not a new clean-suite or API-doc run. Step 5 evidence
belongs under `.lit-review/setup/c17-05-20261016/`. Requested persistent reviewer
settings are `gpt-6-astra` / `ultra` with history copying disabled; effective
settings remain unknown and cooperative read-only review is not OS isolation.


### Actual local API-documentation evidence, 2026-10-16

The maintained two-pass current file-mode gate returned exit 0 in
686.252 seconds on unchanged source/configuration/dependency inputs.
All twelve ProductChannel HTML declaration blocks were inspected against actual
source for signatures, hypotheses, docstrings, owner and file source links.
This is semantic HTML inspection, not a visual/browser rendering audit.
The retained v2 attestation records source-content identity
`f8a954ba8685772a6aad7f75d733a7c44b89d2232e3e522fabc5dfeba8210175`,
relevant-output digest `c2de849c8dd69e638e3f08bafdad42540c67321a731721e675ecac16b4902c57`
and full-tree digest `db64369bf22e013b29bf9edfa1f6e53db305716358af5572d3f4ee65d65406a4`.
Original streams, configuration, attestation and page assessment are under
`.lit-review/setup/c17-05-20261016/`.

The initial gate remains a failure: new owner/Shannon extraction succeeded,
but the stale aggregate HTML marker replayed and the semantic checker rejected
the absent ProductChannel page. After inspecting the pinned generator, exactly
the ignored Shannon aggregate marker and its hash/trace sidecars were preserved
and invalidated. The complete two-pass gate then ran again. The original failure
and cache-recovery record remain separate from success; replayed upstream Qq
warnings are retained. No source, dependency or validation rule was changed.
This is local incremental output, not a cold build, clean routine or publication
qualification. Current docs remain outside the frozen v0.1.0 route.

### Authorized initial clean qualification

The actual command `python -X utf8 -B scripts/validate_release.py` ran in
`C:/Users/coban/Desktop/Lean Info Theory/.worktrees/LeanInfoTheory-C12-validation-20261003`
at initial checkpoint `06c9610be44e8f0d5ecfc6f850a011137db341bc` and returned exit 0
in 3584.820 seconds. The complete maintained routine covers default/strict
builds, permanent aggregates, README and guide consumers, retained/current API,
owner/import/root/simp checks, permitted axioms, metadata/generated website
checks and final clean hygiene. The candidate stayed clean and detached; exact
source and nine runtime dependency identities were unchanged throughout.

All nineteen selected blobs match the scoped proposal. Eight raw differences
between primary and validation are disclosed: the three excluded unrelated
files, the mixed project log, two selected generated files with CRLF/LF differences,
and two historical CRLF/LF files (C9 notes and the frozen API manifest). No
whole-checkout raw identity or cold build is claimed. API output remains bound
to the primary file-mode source/configuration and fourteen documentation pins;
its current applicability is checked separately, not inferred from this suite.
Original results/comparisons are under `.lit-review/setup/c17-05-20261016/clean-initial/`.

This qualifies the initial checkpoint only. Final amended-candidate routine,
API applicability, original cumulative review/reconciliation and supported
closure must be established by their actual records before claiming completion.
The final source identity is recorded privately to avoid a self-referential
commit hash in captured source. No new endpoint is introduced in this step.

## Remaining-work owners and triggers

| Owner / disposition | Exact interface or reopening trigger |
| --- | --- |
| C17.05, cumulative closeout | The nineteen-path checkpoint/reuse and necessary Step 5 amendments are authorized. Qualify exact candidates, review all criteria, reconcile reports and capture/close exact final source. Repeat required gates after amendments; actual completion comes from the private certificate. |
| C18, separately planned | Row product, actual-input joint projections, independent joint factorization, repeated specialization and C16 full family independence. Own new entropy/KL/additivity, conditional-output entropy and information bounds, with optional exact-gap/equality refinement. KL is `ENNReal` first; Real conversion needs support/finiteness guards. |
| C23, separately planned | Arbitrary induced word laws, repeated channels, deterministic reduction and existing joint/composition/extension endpoints. Encoders need not be injective and codewords need not be iid. Own code/message/decoder/error definitions, Markov packaging, rates and Fano converse using C18/C22 inputs. |
| C19 / C22 | Supported logarithms, variance, AEP and typicality / capacity, attainment and additivity, respectively; C17 establishes none of these endpoints. |
| Notes 14/31, standing guardrails | New bind/map conveniences, binary aliases or semantic wrappers require repeated independent consumer pressure and naming/ownership review; no API padding. |
| Excluded scope | Infinite outputs/processes, feedback or a replacement channel representation need separate scope and architecture approval. |
| Release and next chunks | Separate explicit selection; no release preparation, publication, downstream-project change or reviewer transfer follows from C17 closure. |
