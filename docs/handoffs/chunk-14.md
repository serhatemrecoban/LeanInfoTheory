# Chunk 14 maintained handoff: quantitative continuity

## Status and authority

C14.01--C14.03 and their independent reviews have actual
`SUPERVISED_STEP_COMPLETE` records. The parent verified Step 3's complete final
source inventory, configuration and dependency identity before selecting C14.04
on 2026-10-08. The [approved revision-2 plan](../plans/post-release-chunk-14.md)
controls the contracts and all twelve criteria. Earlier candidate wording in
the [notes](../plans/post-release-chunk-14-notes.md) records pre-closure history.

C14.04 prepares cumulative qualification, canonical reconciliation and this
handoff. It adds no mathematical declaration. The lead explicitly authorized
the prepared 23-file local checkpoint, necessary C14.04-only amendments and
reuse of the clean validation checkout. The initial checkpoint's full routine
suite and current API-documentation milestone passed, as recorded below.
Fresh cumulative review, reconciliation, final-source qualification and private
closure remain subject to their source-bound records; this handoff does not
itself certify completion. C15, push, publication and dependency changes remain
unselected. Preserve the unrelated `docs/next-website-tasks.md` bytes, location
and staging state.

Finish captured documentation before final F. The private completion record
and user report carry the eventual closure reference; do not edit captured
documents after F merely to insert that reference.

## Delivered interface

The six declarations are in `LeanInfoTheory.Shannon`, owned by
[`Shannon.Continuity`](../../LeanInfoTheory/Shannon/Continuity.lean):

| Declaration | Contract |
| --- | --- |
| `abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log` | For `p q : PMF alpha` and `[Fintype alpha]`, the absolute entropy difference is at most `Real.binEntropy d + d * Real.log ((Fintype.card alpha - 1 : Nat) : Real)`, where `d = PMF.totalVariation p q`. |
| `entropyContinuityBound` | Total scalar function of natural alphabet size `m` and real budget `epsilon`, defined by the cases below. |
| `entropyContinuityBound_mono` | `MonotoneOn (entropyContinuityBound m) (Set.Ici (0 : Real))` for every natural `m`. |
| `abs_entropy_sub_le_entropyContinuityBound` | Sole budget premise `PMF.totalVariation p q <= epsilon` gives absolute entropy difference at most `B_m(epsilon)`. |
| `abs_condEntropy_sub_le_entropyContinuityBound` | For joint laws on `alpha × beta`, sole joint-TV budget premise gives absolute conditional-entropy difference at most `B_(m*n)(epsilon) + B_n(epsilon)`. |
| `abs_mutualInfo_sub_le_entropyContinuityBound` | The same joint-TV premise gives absolute MI difference at most `B_m(epsilon) + B_n(epsilon) + B_(m*n)(epsilon)`. |

Here `B_m` denotes `entropyContinuityBound m`; `m` and `n` are the whole
alphabet cardinalities. The two joint theorems use independent universes for
`alpha` and `beta`, require their `Fintype` instances, take explicit laws and
implicit `epsilon`, and add no support, nonemptiness, sign or upper-budget
hypothesis. The TV premise already implies budget nonnegativity. Conditional
entropy means the first coordinate given the second.

```text
B_m(epsilon) = 0                                     if m <= 1;
             h(epsilon) + epsilon * log(m - 1)       if m >= 2 and epsilon <= 1 - 1/m;
             log m                                  otherwise.
```

Entropy is in nats, TV is half the L1 distance, and subtraction inside
`log(m - 1)` occurs in Nat before casting to Real. Equality at the threshold
belongs to the lower branch; both expressions equal `log m`. Budgets above
one remain valid. Negative scalar arguments have no approximation guarantee.
The zero-cardinality value is a scalar convention; an empty alphabet carries
no PMF. Singleton laws have zero entropy and TV.

The exact-distance expression is not a monotone upper-budget bound on the
whole unit interval. The pure/fair binary example at budget one proves why
direct replacement of exact distance by a larger budget would be false.

## Proof decisions and dependencies

The exact entropy proof uses one actual `PMF.maximalCoupling p q` and its
coordinate swap. Both identity-decoder errors equal the same exact TV.
Existing Fano, the two entropy chain rules and conditional-entropy
nonnegativity control both signed entropy differences. The source is SA13,
Section II, Theorem 3/(11), pages 3--4; the
[reference register](../references.md#sa13-sason)
records conventions and attribution. The two joint-law consequences are
derived library results, not separately numbered SA13 theorems.

The scalar proof adapts pinned mathlib `Real.qaryEntropy_strictMonoOn` on its
increasing interval, explicitly normalizes Int versus Nat subtraction, and
proves branch agreement. The saturated PMF bound uses the existing entropy
range. It needs no global antitone/q-ary-maximum theorem. Keep
`delta Real.binEntropy` in the threshold calculation: an earlier unfolding
generated duplicate lazy `Real.binEntropy.eq_1` ownership alongside Pinsker.
That failed audit and its successful source correction remain recorded.

The derived bounds use projection TV contraction, the entropy-budget theorem
and the algebraic conditional-entropy/MI identities. Each entropy term keeps
its own cardinality and saturation threshold. These modest constants are not
asserted optimal. No conditional law, conditioning-fiber continuity or
probabilistic meaning for a null-fiber fallback is required.

Import the focused owner for all six declarations:

```lean
import LeanInfoTheory.Shannon.Continuity
```

Its exact direct imports are `LeanInfoTheory.Probability.Coupling` and
`LeanInfoTheory.Shannon.Fano`. Pinsker, gluing and topology are not proof
dependencies. `LeanInfoTheory.Shannon` imports the owner. The lightweight
root retains its two direct imports, five-module closure and 92 exports.
No public alias, helper, instance or simp rule is added.

[`Examples.Continuity`](../../LeanInfoTheory/Examples/Continuity.lean) imports
only the focused owner, joins the non-stable Examples aggregate and remains
outside both mathematical umbrellas. All its new constructors and lemmas are
private. Scalar glue, branch calculations and coupling adapters stay private
in the mathematical owner too.

## Permanent consumers

| Family | Required behavior actually exercised |
| --- | --- |
| Exact entropy | Equal/zero-TV laws, Unit, distinct pure Boolean laws, pure/fair Boolean laws, and both orders of pure/uniform `Fin 3`; exact distances, entropy gaps, sparse zero masses and empty-law impossibility. |
| Nonbinary threshold | Pure/uniform `Fin 3` has TV `2/3`, entropy gap `log 3`, and `h(2/3) + (2/3) log 2 = log 3`; it exercises the nonzero alphabet term and capped threshold equality. |
| Scalar and supplied budgets | Zero, binary/ternary thresholds, budgets one and two, singleton/zero cardinality, the false unrestricted raw substitution, and direct use of public monotonicity for budget weakening. |
| Deterministic processing | A nonconstant, noninjective `Fin 3 -> Bool` map with exact output masses/TV and positive entropy gap; contraction followed by entropy continuity uses the output alphabet size two. |
| Sparse joint laws | Diagonal fair law `D`, independent marginal product `I`, and supported point mass `P` on `Bool × Fin 3`; all share zero mass on the second-coordinate fiber at two. |
| `D` versus `I` | Joint TV `1/2`, equal marginals, joint-entropy, conditional-entropy and MI absolute differences `log 2`; the MI discrepancy is nonzero. |
| `P` versus `I` | Joint TV `3/4`, joint-entropy gap `2 * log 2`, both marginal TVs `1/2`, both marginal entropy gaps and absolute conditional-entropy difference `log 2`; both MIs are zero. Both projections strictly contract TV. |
| Mixed branches | At budget `3/4`, size two and three terms equal `log 2` and `log 3`; the size-six joint term is still `h(3/4) + (3/4) log 5`. Actual second marginals use public monotonicity to weaken `1/2` to `3/4`. |
| Generic and edge laws | Generic approximation, zero distance, each singleton coordinate, impossible empty coordinates, swapped conditioning, and finite-valued random variables from independently arbitrary source types. |

These are explicit Lean calculations and applications of the public interface,
not only loose inequalities. They do not establish a general sharpness or
equality classification.

## Current inventory and historical boundary

The current manifest has 653 documented declarations in 36 supported owners:
583 theorems, 60 definitions, nine abbreviations and one instance. It retains
94 reviewed simp declarations and 92 root exports, excluding 24 non-stable
modules. Generated references record 60 modules, 129 local edges, five
root-reachable and 55 separate-import modules, and 768 indexed declarations
(767 documented and one example-only instance).

The frozen `v0.1.0` release stays at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`: 601 supported declarations in 31
owners. Lean stays `v4.33.1`; mathlib stays
`0df444a360eaa60ab8c11dca51a86af692955474`. Current local file-mode API output
belongs in `docbuild/.lake/build/doc/`, never the historical release route.

## Evidence and review reconciliation

Original records live under the ignored `.lit-review/setup/`; they are durable
local evidence and are not included in a source checkpoint.

- `c14-01-completion-20261007.json`, `c14-02-completion-20261007.json` and
  `c14-03-completion-20261007.json` establish the three completed steps. Step 3
  closure is `defa03cfc8a3aa2dabd597566bf06cc89b225640b8ed734042849bbc70cf17e3`;
  final source is `af38d2bc615aa117940892579b0c4affc779e4a6c8968f2d79ef04a4f7484265`.
- Each step's original report, native delivery, explicit reconciliation and
  final applicability are retained separately. All nine earlier criteria were
  assessed satisfied without findings. They still require fresh cumulative
  assessment at C14.04.
- Step 3's full trust check passed in 1729.329 seconds: all 601 retained types,
  the current public/import/simp inventory, and 2042 project constants using
  only `propext`, `Classical.choice` and `Quot.sound`. Focused six-target,
  signature and static gates also passed. These are earlier source-bound
  checks, not the clean cumulative routine milestone.
- Revision 1's PLAN report remains formally unadmitted because its original
  dispatch referenced a request file instead of sending the rendered request.
  It is historical advice. The independently pasted General Assistant report
  remains separately attributed advice. Neither is an implementation review.
- The adopted ternary and mixed-branch suggestions are implemented. Public
  monotonicity has both a generic and an actual marginal consumer. Further
  ternary families and public scalar helpers were declined for lack of a
  demonstrated gap. Earlier failed builds, the duplicate-equation audit and
  the uncertain initial native receipts remain preserved alongside successful
  corrections and report-backed delivery confirmations.

<!-- c14-04-validation:start -->
Fresh six-target warning-as-error compilation passed (3.836s),
as did the maintained documentation contract with five README and four website
guide examples (157.728s), and static/generated/site validation
(12.218s). Final non-mutating static validation is required after these
result-recording prose edits; its exact result is retained privately.
The actual source-stable current file-mode API-documentation gate passed
(731.686s total; build/check passes 160.9s and 22.0s).
All six rendered declaration signatures, assumptions, useful docstrings, owner
source links and the full Shannon umbrella were inspected. The v2 source,
configuration and two-pass attestation are retained under
`.lit-review/setup/c14-04-api-doc-inspection-20261008.json`; exact post-edit
applicability is required and recorded separately. Existing reviewed Zig 0.16.0,
pinned doc-gen dependencies and incremental caches were used, not a cold rebuild.

The initial missing-Continuity-page failure is retained separately. The parent
preserved and invalidated exactly three ignored Shannon aggregate HTML marker
files after reproducing the stale-marker failure. That initial attempt also
overlapped tracked prose edits and two owned EOL normalizations; its exact API
inputs were unchanged, but it is failed evidence only. The successful rerun
kept the entire candidate unchanged. No source, pin or validator was changed
for the recovery. The two upstream Qq extraction warnings were replayed in
doc-gen logs; both complete maintained semantic checks passed.

On 2026-10-08 the lead explicitly authorized the prepared 23-file local
checkpoint, necessary C14.04-only amendments and reuse of
`C:/Users/coban/Desktop/LeanInfoTheory-C12-validation-20261003`.
Initial checkpoint `ca079e2d11ecccffbe2b91fe1848be5bad3541f2` passed the complete
maintained routine suite there in 3256.611 seconds. Existing pinned
dependencies and incremental caches were used; this was not a cold rebuild.
The actual command was `python -B scripts/validate_release.py` in the
authorized clean checkout. Original streams, results and complete before/after
input hashes are retained in `.lit-review/setup/c14-04-full-checkpoint-20261008/`;
the explicit cross-checkout and primary API-doc applicability record is
`.lit-review/setup/c14-04-checkpoint-applicability-20261008.json`.
The suite passed default and eight-target strict builds, five README and four
website examples, 601 retained signatures, 36 supported import closures,
653 public declarations, 94 reviewed simp declarations, 92 root exports,
the 2,042-constant project axiom audit, generated artifacts, website checks
and clean final hygiene. Only `propext`, `Classical.choice` and `Quot.sound`
were reported. All 23 checkpointed files match primary and clean bytes exactly.
The actual user approval and checkpoint are retained in
`c14-04-checkpoint-authority-20261008.json` and
`c14-04-checkpoint-result-20261008.json` under `.lit-review/setup/`.

The unrelated website notes remain untouched in primary and excluded from the
checkpoint; the clean checkout retains their committed baseline.

Cross-checkout applicability preserves two historical byte distinctions:
`docs/plans/post-release-chunk-09-notes.md` and `docs/v0.1-public-api.json`
have unchanged CRLF bytes in primary and committed LF bytes in the clean
checkout. Each pair differs only by those line endings; both exact frozen-
manifest representations are explicitly accepted. Neither file is normalized.
Current file-mode API attestation belongs to the primary source/configuration
and its pinned dependencies. Its raw input fingerprint is not asserted equal
to the clean checkout's; the clean routine validates its own committed inputs.

These results establish the initial checkpoint's qualification, not any later
amendment's success. Every amended candidate requires renewed complete routine
validation and exact current API-documentation applicability. Fresh assessment
of all twelve criteria, reconciliation, final-source applicability and private
closure must be established by the source-bound private records. This entry
records pre-closure qualification; the eventual completion record and user
report resolve its status without a post-F edit. C15--C24, push and publication
remain unselected.
<!-- c14-04-validation:end -->

## Remaining work and reopening triggers

| Item | Disposition | Owner | Trigger |
| --- | --- | --- | --- |
| Final candidate qualification and cumulative review | Initial authorized checkpoint passed the full routine; every amendment needs renewed qualification, then fresh all-twelve-criterion review and source-bound closure | C14 parent and existing bound reviewer | Final candidate with applicable successful gates, review readiness and explicit reconciliation; initial-checkpoint evidence does not certify an amendment |
| C15 simplex/topology and qualitative continuity | Separate planning and approval; C14 is optional input | Future C15 parent and project lead | Explicit C15 planning/step request; direct finite-sum continuity through `Real.continuous_negMulLog` remains available |
| Sharper conditional/MI constants, support-size or local-distance refinements | Deferred outside the six-declaration contract | Future theorem owner and project lead | A concrete consumer needing a stronger bound and an approved mathematical contract |
| General equality/sharpness classification and countable alphabets | Deferred; finite threshold examples are regressions only | Future theorem owner | Approved distinct theorem project with exact source and scope |
| Scalar evaluation/nonnegativity/cap helpers or q-ary API promotion | Private; no demonstrated reusable public gap | Mathematical owner, Future Work Note 29 | Repeated production use or concrete downstream friction and ordinary API approval |
| Long names and optional aliases | Retain all six systematic names; Note 14 dispositions stand | API maintainer | Deduplicated real search friction at an API checkpoint; no invented feedback |
| CMI, RV, swap, channel or units wrappers | Use existing pushforwards, symmetry, TV contraction and opt-in conversion; no new wrappers | Future consumer/API owner | Repeated awkward public composition that justifies a reviewed addition |
| Conditional laws on null fibers and KL continuity | Not consequences of these theorems; excluded | Future separately approved owner | A valid mathematical contract with necessary guards; never reinterpret total fallback laws |
| Coding, capacity and application certificates | Outside C14; reusable coding mathematics follows later approved chunks, certificate representations stay downstream | Future coding/capacity owner and downstream application owner | Separate scoped approval and concrete consumer requirements |
| Doc-gen cache tooling and website tasks | Existing documentation work only; no new cache automation or protected-note edits in C14 | Documentation/website maintainer | Reproduced tooling defect or separately authorized website task under existing review rules |
| Work beyond the approved local checkpoint/amendments; push, publication or dependency upgrades | Separate authority; the existing approval covers only the prepared 23-file checkpoint, necessary C14.04-only amendments and clean-checkout reuse | Project lead and relevant workflow owner | Explicit scoped instruction and applicable validation; historical release route unchanged |
| Revision-1 formal PLAN admission limitation | Retained history; no retrospective certification | C14 parent/project lead | Only a separately requested fresh plan review could assess a revised proposal; execution completion cannot repair old provenance |

C15 should start from its own approved intent, inspect the focused owner and
current public inventory, and choose whether quantitative bounds help its
qualitative route. Topology instances and further mathematical obligations remain outside C14.
