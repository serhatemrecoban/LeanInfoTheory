# Chunk 15 maintained handoff: finite PMF topology and attainment

## Status and authority

C15.01--C15.04 and their independent reviews are complete by their actual
private records. The parent verified all 232 entries of Step 4's final source
before accepting the conditional C15.05 request on 2026-10-13. The
[approved revision-2 plan](../plans/post-release-chunk-15.md) controls all
17 cumulative criteria. Earlier provisional wording in the
[implementation notes](../plans/post-release-chunk-15-notes.md) is history.

C15.05 adds no mathematics. The lead authorized the exact prepared 20-file
local checkpoint, C15.05-only amendments within those paths and reuse of the
relocated clean validation checkout. Initial checkpoint `000aae22bf2db249e0286183b6cd3ebf4e910aba` passed the complete maintained routine suite in 3435.257 seconds.
The actual two-pass current API-doc gate and rendered inspection also passed,
with their own exact applicability records. Final amended-candidate validation,
fresh all-criteria review, reconciliation and supported closure remain governed
by their source-bound records. This handoff does not certify those later results.
C16, push, publication and dependency changes remain unselected.

## Delivered public interface

The chunk adds 16 declarations: 13 theorems, one definition and two named
instances. Names beginning `PMF.` are owned by that namespace; information
theorems belong to `LeanInfoTheory.Shannon`. No alias or simp attribute is added.

| Focused owner | Public declarations and hypotheses |
| --- | --- |
| [`Probability.FiniteTopology`](../../LeanInfoTheory/Probability/FiniteTopology.lean) | `instTopologicalSpace` forwards the existing ENNReal product/subtype topology for arbitrary alphabets. `continuous_apply_toReal` and `tendsto_iff_forall_toReal_tendsto` also allow arbitrary alphabets and arbitrary filters. |
| Same owner | `homeomorphStdSimplex` identifies `PMF α` with `stdSimplex ℝ α` under `[Fintype α]`; `homeomorphStdSimplex_apply` gives the forward real coordinate and `homeomorphStdSimplex_symm_apply` the inverse `ENNReal.ofReal` coordinate. `instCompactSpace` requires only `[Finite α]`. |
| Same owner | `continuous_bind` and `continuous_map` require only `[Finite α]` for the input and allow arbitrary output. `continuous_channelJoint` permits arbitrary input and output alphabets. Channels remain functions `α → PMF β`. |
| [`Probability.TotalVariationTopology`](../../LeanInfoTheory/Probability/TotalVariationTopology.lean) | `continuous_totalVariation` and `tendsto_iff_totalVariation_tendsto_zero` relate existing half-L1 TV and topological convergence on one fixed `[Fintype α]`, for arbitrary filters. |
| [`Shannon.Topology`](../../LeanInfoTheory/Shannon/Topology.lean) | `continuous_entropy` requires `[Fintype α]`. `continuous_condEntropy`, `continuous_mutualInfo` and `continuous_mutualInfo_channelJoint` require `[Fintype α] [Fintype β]` in independent universes. The last theorem concerns the actual objective `fun p => mutualInfo (PMF.channelJoint p W)`. |

All statements retain zero masses and changing supports. None adds full-support
or positivity assumptions. Information quantities remain Real-valued in nats;
conditional entropy on `PMF (α × β)` means the first coordinate given the second.

Import only the owner needed by a consumer. The finite-topology owner's local
dependency is `Probability.FiniteChannel`, with exact mathlib simplex/topology
imports. The TV bridge imports `Probability.TotalVariation` and
`Probability.FiniteTopology`. Information continuity imports only
`Shannon.InfoMeasures` and `Probability.FiniteTopology`: no TV, coupling, Fano,
Pinsker, KL or semantic aggregate is needed for these proofs. All three owners
join `LeanInfoTheory.Shannon`; the root keeps two direct imports, a five-module
closure and 92 exports. Example owners join only `LeanInfoTheory.Examples`.

## Mathematical decisions and sources

The upstream PMF definition is a subtype, but the pinned instance search does
not unfold it automatically. The named topology instance forwards exactly that
topology by definitional equality; PMF reducibility is unchanged. Finite PMF
compactness is transported from the existing real simplex. There is no second
probability representation, TV metric or extra uniform structure.

Real atom continuity uses that every PMF atom is not top. The simplex inverse
uses nonnegative normalized real coordinates. Bind uses a finite real weighted
sum through the existing guarded conversion lemma; joint continuity uses atom
products. The TV converse reuses the existing singleton-event TV bound rather
than adding a coordinate estimate API.

Finite entropy uses the existing sum of `Real.negMulLog`, including continuity
at zero. Conditional entropy and MI follow their algebraic entropy formulas.
The reference is [PW24](../references.md), the August 16, 2024 version,
SHA-256 `c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`:
Proposition 4.8, PDF 103 / printed 78; Proposition 4.13(a)--(b), PDF 106--107 /
printed 81--82. C15 deliberately specializes the latter's stronger
arbitrary-output statement to finite output for information objectives.
Conditional-entropy continuity is a derived library result. Theorem 5.4,
PDF 119 / printed 94, assumes attainment; it is not the existence proof here.

## Actual attainment and permanent consumers

[`Examples.ChannelOptimization`](../../LeanInfoTheory/Examples/ChannelOptimization.lean)
contains a private generic theorem with the exact conclusion

```text
[Fintype α] [Nonempty α] [Fintype β] (W : α → PMF β) :
  ∃ p : PMF α, ∀ q : PMF α,
    mutualInfo (PMF.channelJoint q W) ≤ mutualInfo (PMF.channelJoint p W)
```

It applies `isCompact_univ.exists_isMaxOn` to the actual objective, supplying
delivered compactness, public continuity and a pure law from input nonemptiness.
It assumes neither a maximizer nor compactness/continuity. No independent
`Nonempty β` premise, public optimizer wrapper, capacity value, uniqueness or
optimizer formula is introduced.

| Consumer | Coverage |
| --- | --- |
| [`Examples.FiniteTopology`](../../LeanInfoTheory/Examples/FiniteTopology.lean) | Sparse real-simplex round trips, pure vertices, empty-law impossibility and singleton compactness; actual bind compact images; nonconstant noninjective `Fin 3 → Bool`; independent universes and `Finite`-only map/bind, `Bool → Nat`, `Bool → PMF Nat` and `Nat → PMF Bool` joint-map applications. |
| [`Examples.TotalVariationTopology`](../../LeanInfoTheory/Examples/TotalVariationTopology.lean) | Both directions of coordinate/topological/TV convergence through the public iff theorems, arbitrary filters, singleton TV, empty-law impossibility, and exact boundary-family masses and TV. |
| `Examples.ChannelOptimization` | Actual attainment, explicit MI and conditional-entropy limits to zero, singleton input/output MI zero through existing information APIs, empty input without an optimizer, and impossibility of a channel from nonempty input to empty output. |

The connected family has parameter `t ∈ [0,1]`, masses `1-t` at false and `t`
at true, and pure endpoint at zero. Its exact TV to that endpoint is `t`.
The fixed channel sends false to the pure endpoint and true to the fair law.
Its joint masses are `1-t`, `0`, `t/2`, `t/2` in Boolean coordinate order;
the true output mass is `t/2`. Public continuity propagates the input limit to
output and joint laws, then to both information quantities with actual endpoint
value zero. The second conditioning fiber is positive for `t > 0` and null at
zero. Tiny constructors are private in each focused example; no example imports
another merely to share a fixture.

An empty input PMF space is compact but has no optimizer. Singleton objectives
are zero. None of these results gives conditional-law continuity at null fibers
or probabilistic meaning to a fallback row, or unrestricted KL continuity.

## Cumulative acceptance map

This map identifies evidence to inspect, not a fresh reviewer verdict.

| Criterion | Delivered source or remaining qualification |
| --- | --- |
| C15.01-BRIDGE | Homeomorphism, normalized inverse, both inverse laws and real/ENNReal coordinate equations. |
| C15.01-COMPACT | Named subtype forwarder and `Finite` compactness; separate focused/umbrella instance probes. |
| C15.01-COORDINATES | Arbitrary-filter real-coordinate iff with atom no-top evidence. |
| C15.01-CONSUMERS | Sparse/pure/empty/singleton consumers and direct public interfaces. |
| C15.02-TV | Continuous existing TV and fixed-finite-alphabet convergence iff. |
| C15.02-EQUIVALENCE | Permanent consumers compose both public iff theorems in both directions. |
| C15.02-BOUNDARY | Exact Boolean coordinates and TV `t`, approach to a pure law, singleton/empty cases. |
| C15.03-MAPS | Finite-input map/bind and unrestricted joint map; permanent generality applications. |
| C15.03-COMPACT-IMAGE | Actual bind image compactness from delivered PMF compactness. |
| C15.03-CONSUMERS | Noninjective deterministic processing, distinct channel rows, exact masses, projections and propagated limits. |
| C15.04-INFORMATION | Entropy/conditional-entropy/MI continuity, including zeros and existing orientation. |
| C15.04-CHANNEL-OBJECTIVE | Continuity of actual fixed-channel input MI with focused dependencies. |
| C15.04-ATTAINMENT | Actual extremum application with supplied compactness, continuity and nonemptiness. |
| C15.04-BOUNDARY | Explicit MI and conditional-entropy limits, vanishing fiber and all degeneracies. |
| C15.05-VALIDATION | Initial authorized checkpoint passed the clean default suite; actual two-pass API-doc qualification and rendered inspection passed separately. Every amendment requires renewed full routine validation and exact API-doc applicability. |
| C15.05-READINESS | Final amended-candidate qualification, exact source identity, completed edits, retained self-review/reassessment and earlier-report reconciliation precede dispatch of fresh all-17-criterion review. Readiness is distinct from its later verdict and closure. |
| C15.05-HANDOFF | This handoff, canonical reconciliation, exact inventories and explicit remaining-work owners/triggers; source-bound private records and the user report retain actual final evidence and closure without a post-capture status rewrite. |

## Evidence and current inventory

The four `c15-0N-completion-20261013.json` records under ignored
`.lit-review/setup/` establish successful earlier steps, with all 14 criteria
satisfied and no findings. Original native reports, uncertain immediate receipts,
separate delivery confirmations, explicit reconciliations and failures remain
retained. Formal PLAN review was never requested or dispatched; the approved
revision and advisory reports do not create a retrospective PLAN verdict.

Step 4 closure is
`ff30d08305252fa9002a7a2d6b8b24b9d5a370a39ff32fbc3db01b7a117370cf`,
final source `3d734da7fa47ae8b6671ede139e8a3655bac0fdce6549578188d8b9466230d3d`.
Its eight focused targets, separate focused/umbrella instance probes, static,
documentation and trust passed. Trust retained all 601 historical signatures
and audited 2,198 local constants with only `Quot.sound`, `Classical.choice`
and `propext`. Documentation compiled five README and four website-guide
examples. The independent reviewer performed additional source, instance,
owner/consumer elaboration and static checks; its limits are recorded separately.
Those earlier results do not replace C15.05's clean cumulative gates.

The actual current file-mode API-documentation gate passed both build/check
passes on source-stable inputs (528.972 seconds). All 16 new
declaration HTML blocks were checked for exact owner, signature/hypotheses,
useful docstrings and file source links. Browser inspection covered the three
new owner pages and the full Shannon umbrella page. The exact v2 source/configuration,
relevant-output digest and two-pass attestation are retained privately. The
whole-tree digest is attributed to the maintained gate, separately from the
parent's fresh relevant-page inspection. Existing reviewed Zig 0.16.0 and
pinned doc-gen caches were used; this is not a cold rebuild.

The first attempt failed because aggregate HTML generation reused an old
completion marker after extracting the new declarations, leaving all three
C15 owner pages missing. Its source and API inputs remained unchanged. The
parent retained that failure and the original bytes of exactly three ignored
Shannon HTML marker/hash/trace files, invalidated those files and ran both real
passes successfully. No source, dependency or validation rule was changed for
the recovery. Replayed upstream Qq extraction warnings remain in the logs;
the complete semantic checks passed. Current output stays in
`docbuild/.lake/build/doc/` and does not replace the historical release route.


### Authorized initial checkpoint and final-candidate boundary

The lead explicitly authorized the prepared 20-file local checkpoint,
necessary C15.05-only amendments within those paths, and reuse of
`C:/Users/coban/Desktop/Lean Info Theory/.worktrees/LeanInfoTheory-C12-validation-20261003`.

Initial checkpoint `000aae22bf2db249e0286183b6cd3ebf4e910aba` passed the complete maintained routine suite in 3435.257 seconds.

The validation checkout was detached and clean before and after the suite;
its tracked files equal the committed blobs. The primary checkout deliberately
retains four unrelated dirty paths: `.gitignore`, `AGENTS.md`,
`docs/next-website-tasks.md` and the pre-existing relocation entry within
`docs/project-log.md`. The first three files are excluded wholesale; only that
unchanged historical entry is omitted from the checkpoint's log. The other
selected bytes match exactly. The two historical primary/clean byte differences
in `docs/plans/post-release-chunk-09-notes.md` and `docs/v0.1-public-api.json`
are CRLF versus LF only and remain preserved. These four exclusions and two
EOL distinctions are explicit; whole-checkout raw-byte identity is not claimed.

The actual command was `python -B scripts/validate_release.py` in the reused
clean checkout. Original streams, actual command/result, input inventories,
dependency identity and checkout comparison are retained under
`.lit-review/setup/c15-05-20261013/full-checkpoint/`. The complete gate passed
default/eight-target strict builds, five README and four website-guide consumer
compilations, retained/current compatibility, exact import/root/simp contracts,
all-project permitted-axiom checks, generated references, legal/release metadata,
website checks and final clean hygiene. Existing pinned dependencies and
incremental caches were used; this was not a cold rebuild. Clean and primary
tracked inputs stayed unchanged during the run, and dependencies stayed clean
at their pinned revisions.

The earlier actual two-pass current file-mode API-doc gate and rendered
inspection are separate evidence, bound to the primary source/configuration
and recorded outputs. The clean routine does not rerun that gate or renew its
attestation. Exact applicability to the checkpoint and every amendment must be
recorded separately, including the stated cross-checkout differences. Current
output remains in `docbuild/.lake/build/doc/`, outside the frozen release route.

These results qualify the initial checkpoint, not a later amendment.
Every amended candidate requires another complete clean routine suite and
exact API-documentation/source/configuration/dependency applicability. Finish
owned edits, retain self-review and separate reassessment, reconcile earlier
step reports and establish readiness before fresh independent assessment of
all 17 criteria. The original cumulative report, every reconciliation and
final-source applicability remain closure obligations. Source-bound private
records and the eventual user report establish the actual final results and
supported closure; this captured prose is not a verdict and needs no post-capture
rewrite merely to insert the eventual success reference. C16, push, publication
and dependency changes remain unselected.

The current manifest records 669 documented declarations in 39 supported owners:
596 theorems, 61 definitions, nine abbreviations and three instances. It retains
94 reviewed simp declarations, 92 root exports and excludes 27 non-stable
modules. The module graph has 66 modules and 143 local edges; five modules are
root-reachable. The source index has 784 entries, 783 documented and one
example-only instance. The frozen release remains 601 declarations in 31 owners.
Lean `v4.33.1`, mathlib `0df444a360eaa60ab8c11dca51a86af692955474`, dependencies,
historical release files and review settings remain unchanged. Current local
API output belongs in `docbuild/.lake/build/doc/`, never the historical route.

## Remaining work, owners and triggers

| Disposition | Owner and trigger |
| --- | --- |
| Keep current names and private helpers; no new aliases, fixture or optimizer API. | Future Work Notes 14/29; reconsider only after concrete independent consumer or recorded discovery friction. |
| Qualify each amended final candidate, then obtain and reconcile fresh cumulative review; preserve separate API-doc applicability. | C15.05 within the authorized 20-file amendment/reuse scope; repeat the complete clean routine after every amendment. Source-bound final records establish actual review and closure without a post-capture historical rewrite. |
| Capacity and further optimization remain outside C15. | Separately planned C22 reuses the public compactness/objective-continuity interface; constrained optimization, minimax and KL continuity require independent scope decisions. |
| No conditional-law limit is inferred from continuous conditional entropy. | Future semantic work must address positive versus null fibers explicitly. |
| C16 is a planning handoff only. | A fresh lead request, detailed plan and approval precede product/iid implementation. Reuse existing PMF and family interfaces; keep product constructors light and family/independence compatibility in a separate bridge. |
| C17--C24 remain proposed. | Their own approved plans/step selections; no reviewer creation or transfer follows from this handoff. |
| Preserve unrelated local work. | Exclude `.gitignore`, `AGENTS.md`, `docs/next-website-tasks.md` and the earlier project-log relocation entry from the C15 checkpoint; retain working bytes and staging state. |

At this package boundary, C13--C15 add 27 supported declarations (5 + 6 + 16),
including C15's two forwarding/compactness instances and its two coordinate
equations. This is below the map's rough 40--100 substantive-addition estimate;
it is an upper count for that comparison, not 27 independent deep results.
The delivered families are Pinsker, quantitative finite information continuity,
PMF topology/compactness, TV convergence, channel continuity and actual MI
attainment. Reusing existing mathlib and algebraic interfaces keeps the surface
small. The current total is 68 above the released 601, well short of the map's
rough 1,200 cross-check. Do not add filler or change endpoints to meet a count;
report the smaller measured package and reassess after C18 using actual product,
channel and block-information consumers. No numeric future-output promise or
programme-scope change is inferred.
