# Chunk 12: Coupling Transport and Finite Gluing

<!-- lit-review-status:start -->
**Status:** Approved, revision 2, 2026-10-03.
The lead accepted this revision. C12.01--C12.03 and their review processes are
complete by verified private completion records. The conditional C12.04 request
was selected after C12.03 closure and exact source applicability were checked.
C12.04 prepares cumulative validation, fresh full-chunk review and the maintained
handoff; actual closure is subject to its private completion record. A clean
checkpoint requires separate explicit authority under Section 5.2. C13--C24
remain unselected. Reasoned in-scope adaptations remain authorized.
Revision 1's advisory reports and unresolved plan-review submission record
remain historical evidence; no formal plan-review acceptance is claimed.
C11 is complete through C11.06 by its verified private completion record at
`bbead98`; earlier chunks remain complete.
<!-- lit-review-status:end -->

## 1. Authority and endpoint

This plan refines [C12 in the chunk map](post-release-chunk-map.md#c12-coupling-transport-and-finite-gluing)
and its shared architecture, consumer, validation and revision contracts.
The lead must approve the exact plan before production implementation. Plan
review requires a separate explicit request. After approval, execute only one
explicitly requested step with its required review process, report, and stop.
Neither planning, review, nor plan approval authorizes a commit, push,
deployment, release change, dependency change, or another chunk.

The endpoint is a small extension of the existing raw-PMF coupling interface:

- Transport supplied couplings through heterogeneous coordinate maps.
- Lift a supplied coupling through a supplied channel of couplings, requiring
  its marginal laws only on the input coupling's actual support.
- Glue two supplied pair laws with a common middle marginal into one
  conditionally independent triple law, retaining both exact pair marginals.
- Prove that changing a conditional channel on null middle fibers leaves the
  **whole triple law** unchanged.
- Derive an endpoint coupling from that same triple and maintain a three-law
  consumer, a substantive C10 contraction consumer, and the specified
  non-preservation-of-maximality regression.

**Proposed decision:** expose a gluing existence theorem; keep witness selection
private. Do not add a public pair-coupling composition operation, bundled
coupling/channel object, public uniqueness theorem, or category interface.
The existing `PMF.channelExtension` remains the construction. Its existing
channel-composition laws are not asserted to be pair-coupling composition laws.
If the lead instead selects a public composition operation, revise and approve
the plan first: identity laws with diagonal couplings and associativity for
four consistent marginal laws must include the exact domains, common-marginal
hypotheses, endpoint projections and product reassociations. Those obligations
cannot be deferred after publishing such an operation.

Pinsker, entropy/MI continuity, general measurable coupling, optimal transport,
process coupling, category infrastructure and downstream certificate work are
out of scope. No stable declaration is moved. Planning changes only this
proposal and permitted private evidence or isolated scratch.

## 2. Intake, references and evidence applicability

### 2.1 Checkout and completed prerequisites

Work in `C:\Users\coban\Desktop\Lean Info Theory`, not the chat's initial
Documents directory. Intake HEAD is
`bbead98abfd2ac94f95b615652365a65228e49c5`, on `master`. The only initial Git
change was `docs/next-website-tasks.md`. Preserve that file byte-for-byte; do
not stage, commit, push, restore, or include its notes in C12 changes.
Its intake SHA-256 is
`8db54766aff44faaf5f2380f0e9c11103ab4ba5471d2928b1c2750a3f3a11887`.
Local tracking refs are not a fresh remote-state check.

Verified C11 completion is recorded in
`.lit-review/setup/c11-06-completion-20260927.json`: all six steps complete,
no active step, and all 17 cumulative assessments satisfied. Its closure is
`e52dea61a462e36046353d8d38a6fb9fe5a68458c15cd651b9dfd1439b4047c4`;
F is `b1d8a8e78fd9b1c479e76c6529d44c9fa051797fb39d7d18a83111ed6ecdb6e7`.
The read-only predecessor verification, exact comparisons and original
diagnostic history are retained in
`.lit-review/setup/c12-c11-predecessor-verification-corrected-20261003.json`
and its cited records. This evidence establishes prior completion.

The captured provisional wording in the living summary, map and
[C11 handoff](../handoffs/chunk-11.md) predates private closure; it is not
unfinished C11 work. The [C10 handoff](../handoffs/chunk-10.md) likewise records
a completed predecessor. Follow `AGENTS.md`, the relevant living-summary
sections, both handoffs, the reference register and both review documents.
Notes 9, 14--18, 26, 30, 31,
34 and 37 remain guardrails or consumer-triggered work; C12 does not broadly
close them.

| Baseline | Observed identity |
| --- | --- |
| Lean | `v4.33.1` |
| mathlib | Clean configured/installed `0df444a360eaa60ab8c11dca51a86af692955474` |
| doc-gen4 | Pinned `e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015` |
| Current supported surface | 638 declarations in 33 owners, including ten coupling declarations |
| Frozen release | 601 declarations; commit `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f` |
| Root / attributes | Five local modules, 92 facade exports, 94 reviewed simp declarations |

Counts describe the baseline; they are not growth quotas or approvals.

### 2.2 Source declarations and reuse

Locations below refer to the intake source. Recheck line numbers after edits.
Paths under `Mathlib/` are in `.lake/packages/mathlib/` at the pin above.
Searches covered source, the current declaration inventory, generated API
material and pinned PMF files. No ready-made finite PMF gluing/coupling API was
identified by those searches; this is not a claim about every upstream theorem.

| Source location | Existing contract used by C12 |
| --- | --- |
| `Probability/Coupling.lean:48–88` | `PMF.IsCoupling`, constant-channel existence, diagonal and swap; ordered pushforwards, independent universes, no finiteness. |
| `Probability/Coupling.lean:86,169,178,271,290` | Universal TV/disagreement bound, actual maximal witness and exact ENNReal/Real disagreement. |
| `Probability/FiniteChannel.lean:48–75` | Raw deterministic channel, `channelComp`, `channelJoint`, right-associated `channelExtension`. |
| `Probability/FiniteChannel.lean:102–280` | Joint/extension atom formulas, input pair, output pair, output and endpoint projection laws. |
| `Probability/FiniteChannel.lean`, `channelJoint_eq_iff_eq_on_support` | Equality of induced joint laws iff total channels agree on actual input support; reuse for the forward direction of the extension contract. |
| `Shannon/InfoMeasures.lean:35–39,80–87,147–189` | First/second and pair/triple marginal abbreviations and swap laws; no alternate marginal representation. |
| `Shannon/SemanticBridge/Markov.lean:72` | Null-safe Markov cross-product identity. |
| `Shannon/SemanticBridge/Markov.lean:210–274` | Total `condFstGivenSndChannel`, positive/null branches, weighted reconstruction and `channelJoint_condFstGivenSndChannel`. |
| `Shannon/SemanticBridge/Markov.lean:285` | Every `channelExtension L V` is Markov without finite assumptions. |
| `Shannon/SemanticBridge/Markov.lean:338–418,425` | Canonical reconstruction with `[Fintype C]`; existential channel factorization already exposes `[Finite C]`. Reconstruction is one available private route to identifying the regression witness. |
| `Probability/TotalVariation.lean`, `totalVariation_bind_le`, `totalVariation_map_le`, `totalVariation_map_equiv` | C10 common-channel contraction, deterministic specialization and equivalence invariance. |
| `Examples/TotalVariationChannels.lean:83–150` | Existing exact Boolean noise contraction, channel composition and marginal projection consumers. |
| `Examples/Coupling.lean` | Existing private fair-Bool independent-vs-diagonal disagreement and maximal-coupling consumers; reuse mathematics without exporting its private helpers. |
| `Mathlib/Probability/ProbabilityMassFunction/Constructions.lean:60,64,67,72,76` | `mem_support_map_iff`, `map_id`, `map_comp`, `map_bind`, `bind_map`. |
| `Mathlib/Probability/ProbabilityMassFunction/Monad.lean:105–155,191–226` | `bind`, its atom/event expansions, associativity, `bindOnSupport` and its ordinary-bind bridge. A new dependent-support constructor is unnecessary. |

The source paths in the table have prefix `LeanInfoTheory/` unless they start
with `Mathlib/`. Elementary transport uses `map_comp`, `map_bind`, `bind_map`
and support-aware equality of weighted terms. Equality of supported channel
rows can reuse `channelJoint_eq_iff_eq_on_support` and then project with
`channelJoint_map_snd`, avoiding a new bind-congruence API. Do not assume a guessed upstream
`bind_congr` declaration. Existing channel and posterior names must not move
out of Markov to make the new bridge appear light.

### 2.3 Mathematical references and adaptations

The local [reference register](../references.md) selects these exact copies.
Planning research checked the registered PDF hashes and relevant pages. PDFs,
extracted text and rendered reference pages stay private and outside commits.
No external information-theory implementation was consulted.

| Reference | Exact location and use |
| --- | --- |
| LP17, Levin–Peres, second edition, 2017; `mcmt2e (Levin-Peres).pdf`, SHA-256 `9ef39f9467d9647ff3f5e8747b9ce24b7a90d13be2f8156fbd827b95b661a772` | Section 4.2 definition and Example 4.6, printed pp. 49–50 / PDF pp. 65–66; Proposition 4.7, Remark 4.8, equations (4.8)–(4.13), printed pp. 50–52 / PDF pp. 66–68. Coupling vocabulary, independent/diagonal examples, universal bound and attainment. |
| PW24, Polyanskiy–Wu, 2024-08-16 prepublication draft; `Polyanskiy-Wu Newer.pdf`, SHA-256 `c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3` | Section 7.3, Theorem 7.7(b), equation (7.20), printed p. 122 / PDF p. 147; proof printed p. 123 / PDF p. 148. Minimum disagreement characterization with the same probability-normalized TV. |

These sections do not supply a numbered gluing theorem. C12's construction is
derived from the project's existing conditional PMFs and channel reconstruction.
The textbook random-variable formulation becomes one raw joint PMF and exact
`map` marginals. Finite disagreement uses `toOuterMeasure` on a Set, without
measurable-diagonal assumptions. TV and disagreement are unitless; no log-base
conversion or entropy theorem enters C12. The non-maximality example is a
derived finite regression, not attributed to an unverified textbook theorem.

### 2.4 Planning evidence and reuse limits

Detailed commands, outputs and chronology remain in durable private records;
the following is an evidence index. It does not create repeated implementation
gates. Reassess applicability when the proposed contracts, source, dependency
pins or relevant configuration change. Permanent consumers and Section 5's
validation remain required for the implemented candidate.

| Evidence | Result and limit |
| --- | --- |
| `.lit-review/setup/c12-planning-inspect-20261003.json` and `c12-planning-api-20261003.json` | Installed inspection and API discovery succeeded; neither grants execution authority. |
| `c12-planning-focused-baseline-20261003.json` in the same directory | Warning-as-error focused validation passed for the existing coupling/channel/TV/Markov owners, existing coupling/channel consumers, full Shannon and root. This checks prerequisites only. |
| Private records with prefix `c12-planning-gluing-probe-20261003` | The saved three-theorem probe compiled: extension/support iff, gluing with only `[Finite C]`, and null-fiber fallback irrelevance. Axioms were only `propext`, `Classical.choice`, `Quot.sound`. Research-agent evidence; the broader probe imports do not establish future minimal-import boundaries. |
| `c12-plan-review-original-report-20261003.json` and `c12-plan-review-advisory-assessment-20261003.json` | Revision 1's bound reviewer reported no material defect. Its fresh Lean probe timed out; another probe's outcome was unavailable. The submission recording failed because the sent message pointed to the saved request instead of containing its full text. These records establish no accepted workflow result. |
| General Assistant report supplied by the lead | Reports a successful independent warning-as-error rerun of the saved feasibility probe, with the same three allowed axioms, after an initial stall. This is attributed reviewer evidence for that probe, not verification of future production code. |

Initial failures, uncertainty and the original reports remain retained. The
revision-1 source is preserved as
`.lit-review/setup/c12-plan-revision-1-before-revision-2-20261003.md`.
No revision-1 assessment is represented as a review of this revised text.

## 3. Proposed mathematical and ownership contracts

The following are statement contracts, with proposed names. `A`, `B`, `C`, `D`
have independent universes. No public contract adds measurable spaces,
`Nonempty`, global `DecidableEq`, full support, or positivity of all atoms.
Use local classical reasoning where required. All new declarations have
docstrings; new files use the exact project header. Add no simp attributes,
facade aliases, instances or bundled objects.

### 3.1 Coordinate transport

In existing `Probability.Coupling`, namespace `PMF`, propose `IsCoupling.map`:

```text
h : IsCoupling J p q, f : A -> C, g : B -> D
---------------------------------------------------------------
IsCoupling (J.map (fun ab => (f ab.1, g ab.2))) (p.map f) (q.map g)
```

No finiteness or injectivity premise. Both marginal equalities are part of the
result. Generic identities, composed maps, swap and equivalence consumers use
existing map algebra; do not export every specialization.

### 3.2 Lifting through a supplied coupling channel

In the same owner, propose `IsCoupling.bind`:

```text
h : IsCoupling J p q
W : A -> PMF C, V : B -> PMF D, K : A × B -> PMF (C × D)
hK : forall ab, ab ∈ J.support -> IsCoupling (K ab) (W ab.1) (V ab.2)
------------------------------------------------------------------
IsCoupling (J.bind K) (p.bind W) (q.bind V)
```

`K` is supplied, total and raw; the theorem does not select fiber couplings.
Only its supported rows require the stated marginals. On an unsupported row,
its contribution is zero regardless of its value. An all-rows hypothesis is
an immediate application, not a second public theorem. The proof compares each
mapped bind with its corresponding marginal bind. Any bind-congruence helper
stays private unless later independent production uses justify promotion.
The consumer must distinguish `J.support` from the product of the two marginal
supports: an unused pair can have individually supported coordinates while its
channel row has incorrect marginals.

### 3.3 Whole-law independence of null middle fibers

In existing `Probability.FiniteChannel`, namespace `PMF`, propose
`channelExtension_eq_iff_eq_on_support`:

```text
L : PMF (A × B), W V : B -> PMF C
channelExtension L W = channelExtension L V
  <-> forall b, b ∈ (L.map Prod.snd).support -> W b = V b
```

This is type-generic. Necessity projects to the output pair and reuses
`channelJoint_eq_iff_eq_on_support`; sufficiency uses the extension atom formula
and vanishing input-pair mass on a null second marginal. It gives equality of
PMFs, not just equal endpoint marginals or one weighted atom. No conditional
PMF or Shannon import belongs in this theorem. C12's gluing and concrete
fallback-change consumers provide the use that motivates this small extension
of Note 30; broader posterior conveniences remain deferred.

### 3.4 Finite conditionally independent gluing

Create the opt-in owner `Shannon.SemanticBridge.Gluing`, namespace
`LeanInfoTheory.Shannon`, with the single direct local import
`Shannon.SemanticBridge.Markov` and no new external imports. Propose
`exists_isMarkovChain_with_marginals`:

```text
[Finite C]
L : PMF (A × B), R : PMF (B × C)
hmid : L.map Prod.snd = R.map Prod.fst
--------------------------------------------------------------
exists T : PMF (A × B × C),
  fstSndMarginal T = L ∧ sndThirdMarginal T = R ∧ IsMarkovChain T
```

The right-associated type is `A × (B × C)`. The maps are explicitly
`piAB t = (t.1,t.2.1)`, `piBC t = t.2`, and `piAC t = (t.1,t.2.2)`.
Use the existing marginal abbreviations in semantic statements. Only `C`
needs finiteness for the present reconstruction route; `A` and `B` remain
arbitrary. Obtain `Fintype C` internally from `Finite C`. This includes all
finite triples without making enumeration part of the public interface.

The private construction is

```text
V := condFstGivenSndChannel (R.map Prod.swap)  -- C given B
T := PMF.channelExtension L V
```

Use `channelExtension_map_input` for AB and
`channelExtension_map_outputPair`, `hmid`, conditional reconstruction and
double swap for BC. `isMarkovChain_channelExtension` supplies conditional
independence. Its cross-product contract is

```text
T(a,b,c) * q(b) = L(a,b) * R(b,c),   q := L.map Prod.snd.
```

For supported `b`, this agrees with conditional independence of endpoints
given `B=b`; when stating the existing positive-fiber PMF equivalence in a
consumer, supply its actual finite endpoint assumptions locally. On null
middle fibers, both pair-law slices and the triple slice vanish. Do not claim
anything about the meaning or equality of the arbitrary fallback channels there.

For every alternative total `V'` agreeing with `V` on `q.support`, Section 3.3
must prove `channelExtension L V' = T`; hence it has the same two pair marginals
and Markov property. The fallback may vary independently for each null `b`.
In an isolated proof or private consumer, equivalently identify the positive
rows with the canonical `condFstGivenSnd` via its nonzero-fiber theorem.
Do not export a fallback parameter, selected gluing definition, or public
uniqueness wrapper merely to expose this evidence.

If `hL : IsCoupling L p q` and `hR : IsCoupling R q r`, then
`hL.2.trans hR.1.symm` supplies `hmid`. From the returned **same** triple and
its AB/BC equalities, `map_comp` proves `IsCoupling (T.map piAC) p r`.
This endpoint result is a required maintained consumer. An unrelated call to
C11's already-existing endpoint coupling existence theorem would not satisfy it.
No separate public endpoint-existence wrapper is needed.

### 3.5 Boundaries and supported surface

| Owner or consumer | Planned imports and responsibility |
| --- | --- |
| `Probability.Coupling` | Retain exactly `Probability.FiniteChannel` and `Probability.TotalVariation`; add map/bind coupling theorems. |
| `Probability.FiniteChannel` | Retain exactly `Probability.Finite`; add the extension equality/support theorem. |
| New `Shannon.SemanticBridge.Gluing` | Import only existing Markov; add the existential gluing theorem. Markov transitively supplies the raw-channel owner. |
| `Shannon.SemanticBridge` aggregate | Add Gluing as a separately approved umbrella import while retaining all old imports. Full `Shannon` reaches it through this aggregate; no new direct full-umbrella import is needed. |
| New `Examples.CouplingTransport` | Import only `Probability.Coupling`; private transport, support and C10 contraction consumers. |
| New `Examples.CouplingGluing` | Import `Probability.Coupling` and `Shannon.SemanticBridge.Gluing`; private heterogeneous three-law, null-fiber and non-maximality consumers. |
| `Examples` aggregate | Include both new consumer owners; neither mathematical umbrella imports examples. |

This proposal adds four public theorems and no definitions. That is an explicit
initial API budget, not permission to remove a necessary contract to meet a
count. Any extra public theorem needs a concrete consumer, ownership and naming
assessment before inclusion; a material contract change needs lead approval.
Existing ten coupling declarations, C10 contracts and all retained signatures,
attributes and imports remain unchanged except for approved additive growth.
The lightweight root keeps exactly its two direct imports and five-module closure.
Do not add Markov, Gluing, KL, Product, kernels or examples to the low-level owners.

## 4. Steps, dependencies and acceptance criteria

Four steps follow actual dependencies. Transport is independent of conditional
reconstruction. Gluing then supplies the witness consumed by the quantitative
regression. The third step connects both producers to their permanent consumers;
the fourth qualifies the complete chunk. No later step starts automatically.

### C12.01 — Generic transport and supplied coupling channels

Implement Sections 3.1–3.2 in the existing coupling owner. Start the private
`Examples.CouplingTransport` owner and add it to `Examples`. Check exact
namespace/signature discovery before adding the two names. Maintain both
marginal orientations, different types/universes, map composition, deterministic
specialization, constant/identity maps and support-restricted channel rows.

Use the following private support regression. For the fair Bool law `u`, take
`J := u.map (fun b => (b,b))`, `W := PMF.pure`, `V := PMF.pure`, and
`K(a,b) := PMF.pure (b,a)`. The supported pairs are exactly the two diagonal
points, while both marginal supports contain both Boolean values. On those
diagonal pairs, `K` has the prescribed marginals. At `(false,true)`, its first
and second marginals are both wrong for `W false` and `V true`. Apply the new
lifting theorem, obtain a coupling of `u,u`, and prove `J.bind K = J`.

- **C12.01-MATH:** Coordinate-map transport and support-aware channel lifting
  have exactly the contracts in Sections 3.1–3.2, without finite, measurable,
  inhabitance, injectivity or all-rows premises.
- **C12.01-CONSUMER:** A minimal-import private consumer obtains both output
  marginals from each theorem, proves deterministic lifting equals coordinate
  transport, and proves the diagonal fair-Bool support regression above. Show
  explicitly that the unused off-diagonal row fails the prescribed coupling
  condition despite both coordinates lying in their marginal supports, while
  lifting still gives both correct output laws and `J.bind K = J`.
  Include an explicitly heterogeneous consumer, pure/singleton cases and
  empty-input impossibility rather than a fabricated fallback inhabitant.
- **C12.01-BOUNDARY:** The coupling and raw-channel owners retain their exact
  imports; current inventory, retained contract, root exports and reviewed simp
  set remain valid under this additive growth. Helpers and examples stay private.

Validate the touched owner and consumer, existing coupling/TV channel consumers,
`Examples`, full `Shannon` and root; regenerate applicable current artifacts and
run static checks. Apply Section 5's review and evidence requirements, then stop.

### C12.02 — Null-fiber independence and finite gluing

Depends on C12.01's completed reviewed source. Implement Sections 3.3–3.4,
create the semantic and consumer owners, and add their approved aggregate
imports and growth-policy records. This step owns the delicate reconstruction
boundary and must finish it before any quantitative regression relies on it.

Use a concrete `Bool`/`Fin 3`/`Bool` example with middle law
`q(0) = q(1) = 1/2` and `q(2) = 0`. Prescribe `L(false,0) = L(true,1) = 1/2`
and `R(0,false) = R(1,true) = 1/2`, with all other pair masses zero. Thus the
two positive middle fibers have different deterministic endpoint laws. Obtain
the public gluing witness, verify both pair marginals and identify its endpoint
law as `u.map (fun b => (b,b))` for fair Bool `u`. Relate that same triple to
`channelExtension L V`, where `V 0 = pure false` and `V 1 = pure true`.
Changing `V 2` from `pure false` to `pure true` must leave the whole triple
unchanged. This example covers varying positive fibers and a genuinely changed
null fallback; pure/singleton cases remain separate consumers.

- **C12.02-NULL:** The type-generic extension equality theorem proves the
  Section 3.3 iff. For arbitrary changes on null middle fibers, the entire
  constructed gluing law is unchanged. Maintain a concrete null-fiber consumer
  with unequal alternative fallback laws and unchanged triple PMF.
- **C12.02-GLUING:** Given the exact common middle marginal, the public theorem
  returns one right-associated triple with both prescribed pair laws and
  `IsMarkovChain`, with only `[Finite C]`. Construction uses the existing total
  conditional channel with the correct swapped orientation, handles null fibers,
  and introduces no unguarded division or new probability representation.
- **C12.02-ENDPOINT:** A generic three-law consumer passes supplied couplings
  of `p,q` and `q,r` to the gluing theorem, tracks both original pair laws and
  derives the endpoint coupling of `p,r` from the same triple. The concrete
  `Bool`/`Fin 3`/`Bool` example above proves both exact pair laws, the diagonal
  endpoint law and whole-triple invariance under changing the null fallback.
  Include singleton cases and impossible empty alphabets. A separate consumer
  with a non-finite ambient first or middle alphabet checks that no hidden
  finiteness premise leaked in.
- **C12.02-BOUNDARY:** Gluing imports Markov only in the separate semantic
  owner; independent compilation of the transport consumer still needs only
  the low-level coupling owner. Approved current policy covers the new owner
  and semantic aggregate import. Existing declarations are not relocated.

Focused checks include all changed owners/consumers, Markov, semantic/full
aggregates, `Examples` and root. Audit the exact direct and transitive imports,
signatures, source/axiom policy and updated inventory. Apply Section 5 and stop.

### C12.03 — Quantitative consumers and maximality regression

Depends on reviewed C12.01–C12.02. Complete both consumer owners and audit the
integrated four-theorem surface. Use private consumer helpers throughout.

**Channel contraction consumer.** With `[Fintype A] [Fintype C]`, a common channel
`W : A -> PMF C`, and input laws `p,q`, take
`J := maximalCoupling p q`,
`K(a,b) := maximalCoupling (W a) (W b)`, and `L := J.bind K`.
Use private notation `D_enn(M) := M.toOuterMeasure {xy | xy.1 ≠ xy.2}` and
`D(M) := (D_enn(M)).toReal` for a joint PMF on a common alphabet. The new
lifting theorem gives both output marginals. Prove the weighted equalities

```text
D_enn(L) = sum ab : A × A,
  J ab * ENNReal.ofReal (TV(W ab.1, W ab.2))
D(L) = sum ab : A × A,
  (J ab).toReal * TV(W ab.1, W ab.2).
```

The sums are finite. The bind event formula and C11's exact ENNReal maximal
disagreement give the first equality. For the Real conversion, record event
and termwise non-top guards from PMF masses and `ENNReal.ofReal`, together with
TV nonnegativity. These identities are private consumer obligations; they add
no public expectation helper. Then prove

```text
TV(p.bind W, q.bind W) <= D(L) <= D(J) = TV(p,q).
```

Use C11's actual witness and exact disagreement at both levels. On equal input
coordinates, the fiber discrepancy is zero; elsewhere it is at most one.
The weighted equality supplies the middle bound. Apply C10's
`totalVariation_bind_le` to these identical output laws, and maintain the
deterministic specialization with `totalVariation_map_le`. This checks real
producer/consumer compatibility without a duplicate public contraction theorem.
No claim says arbitrary supplied coupling channels preserve maximality.

**Required Bool regression.** Let `u` be the fair law, `d := pure false`,
`JAB := channelJoint u (fun _ => d)`,
`JBC := channelJoint d (fun _ => u)`.
Their ordered marginals are `u,d` and `d,u`. Prove both adjacent TVs and
disagreements are `1/2`; C11's universal inequality then establishes that these
supplied adjacent couplings are maximal. No new maximality predicate or equality
with the particular `maximalCoupling` constructor is needed. The contraction
consumer above already exercises that constructor. Obtain a Markov triple from
the public gluing theorem. Using its two pair laws and Markov property, identify
its atoms as

```text
T(a,false,c) = 1/4,     T(a,true,c) = 0.
```

Existing canonical Markov reconstruction is one private proof route; the
existing cross-product characterization is another. The required atom law and
use of the same public witness are fixed; the private proof route may evolve.

Consequently its endpoint law is exactly `channelJoint u (fun _ => u)`,
its endpoint disagreement is `1/2`, and `totalVariation u u = 0`.
The diagonal endpoint coupling has disagreement zero. Prove the strict
inequality, so this particular conditionally independent gluing is demonstrably
non-maximal. Do not make the false stronger claim that every gluing of these
two adjacent pair laws has independent endpoints. Null-middle-fiber fallback
changes leave this triple unchanged by C12.02.

- **C12.03-CONTRACTION:** The actual lifted maximal-coupling construction
  proves both displayed weighted equalities and the two-stage bound, with
  guarded Real conversion, and agrees with C10 on exactly the same output laws.
  Deterministic and degenerate cases use the public interfaces.
- **C12.03-REGRESSION:** The fair/point-mass/fair example proves both adjacent
  maximalities, both exact pair laws, conditional independence, independent
  endpoints, endpoint disagreement `1/2`, endpoint TV zero and strict failure
  of maximality. Identify the triple returned by the public gluing interface
  using its supplied pair laws and Markov property. The private proof method
  remains flexible; substituting an unrelated chosen product does not satisfy
  this criterion.
- **C12.03-API:** Every new public theorem has a meaningful permanent consumer,
  correct ownership, documented assumptions and reviewed naming/attributes.
  ENNReal event equalities and finite/non-top guards justify the Real
  inequalities and numerical values. No public composition, uniqueness, cost
  abstraction, entropy theorem or additional scope has entered the API.

Run the integrated checks in Section 5.1. Reconcile actual source/reference
adaptations and plan health; record remaining issues for closeout, then stop.

### C12.04 — Cumulative validation, full-chunk review and handoff

Depends on all three earlier steps and their actual completion records.
Reserve this entire final step for cumulative qualification. It adds no new
mathematical scope and does not start C13 or any other chunk.

- **C12.04-VALIDATION:** The exact cumulative candidate passes the maintained
  full routine suite at an authorized clean checkpoint, applicable focused
  consumer checks and real two-pass current file-mode API documentation.
  Preserve current API/source/configuration attestations and inspect the actual
  new Gluing page plus new declarations in Coupling and FiniteChannel. Earlier
  evidence is reused only with explicit source/dependency/configuration
  applicability; the frozen release route remains untouched.
- **C12.04-READINESS:** Before the cumulative reviewer is dispatched, all owned
  source and documentation edits are finished, earlier original reviews and
  every criterion assessment are reconciled, material concerns are resolved or
  explicitly escalated, and the exact candidate is ready for fresh independent
  assessment against all 13 criteria in this plan. This is readiness for the
  review, not a circular assertion that that later review has completed.
- **C12.04-HANDOFF:** Canonical documentation and a maintained
  `docs/handoffs/chunk-12.md` agree with source and actual evidence. They record
  delivered contracts/imports/consumers, theorem-only witness selection,
  null-fiber and maximality limits, source and review references, all remaining
  work with owners/triggers, and later-chunk prerequisites without starting them.

Required postconditions after those readiness criteria: obtain the bound
reviewer's fresh full-chunk original report, preserve the native result and
exact body, explicitly reconcile every finding and original assessment,
correct/revalidate within authority, and obtain renewed satisfactory reviewer
assessments for any criterion gaps. Assess R-to-F applicability, finish all
captured edits before F, then complete the installed private closure process.
A favorable report alone is not completion. Report the actual closure reference
and stop; do not edit captured documents afterwards to insert that reference.

## 5. Validation, evidence and review workflow

### 5.1 Per-step checks and capture

Use the maintained validator as the executable source of truth; historical
target counts are descriptive. During a dirty implementation pass run focused
builds and static checks. Independently elaborate permanent consumers from their
declared minimal imports, with warnings as errors, and audit new assumptions,
attributes, owners and root reachability. No disposable probe is a substitute
for a maintained mathematical consumer.

After approved public/API/import changes:

```text
python scripts/generate_current_public_api.py
python scripts/generate_v0_1_public_api.py --check
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/validate_release.py static
```

Record separately reviewed growth-policy approvals when the new owner and
semantic-aggregate import are introduced. Generation does not grant approval.
Use the following schedule; every command uses the current candidate. In the
table, named gates mean `python scripts/validate_release.py <gate>`. Focused
targets use their full `LeanInfoTheory.` module names, with `LeanInfoTheory`
itself for the root. Run artifact-producing Lean builds serially.

| Step | Focused targets | Other required checks |
| --- | --- | --- |
| C12.01 | `Probability.Coupling`, `Examples.CouplingTransport`, `Examples.Coupling`, `Examples.TotalVariationChannels`, `Examples`, `Shannon`, root | Regenerate applicable current artifacts, then `static` and `trust`. Run `documentation` if README examples or release-facing documentation change. |
| C12.02 | `Probability.FiniteChannel`, `Probability.Coupling`, `Shannon.SemanticBridge.Markov`, `Shannon.SemanticBridge.Gluing`, `Shannon.SemanticBridge`, `Examples.CouplingTransport`, `Examples.CouplingGluing`, `Examples`, `Shannon`, root | Regenerate applicable current artifacts, then `static` and `trust`; inspect exact new owner/aggregate boundaries. Run `documentation` if README examples or release-facing documentation change. |
| C12.03 | All C12.02 targets plus `Examples.Coupling` and `Examples.TotalVariationChannels` | Refresh source-derived artifacts when their inputs change; run `static`, `documentation` and `trust` for the integrated candidate. |
| C12.04 | Recheck affected permanent consumers from their minimal imports; earlier focused evidence needs explicit applicability | Authorized clean checkpoint, complete routine suite, real two-pass `api-docs`, actual page inspection and cumulative independent review under Sections 4 and 5.2–5.3. Repeat invalidated checks after amendments. |

The `trust` gate invokes the maintained compatibility checker itself. A separate
`compatibility` run is useful for diagnosis or an earlier candidate, but is not
an additional gate immediately before a passing `trust` on unchanged inputs.
The full routine suite also includes compatibility, trust and documentation;
its required final run remains mandatory. Repeat other passing checks when
source/configuration changes or unresolved failures invalidate their evidence.
The trust gate permits only `propext`, `Classical.choice` and `Quot.sound`;
no placeholders, unchecked axioms or native-decision shortcuts.

Before opening a future plan-review/execution session, declare a faithful
capture scope including this exact plan, relevant canonical/reference documents,
existing owning modules and consumers, aggregates, current and
frozen policies, validator/generators, toolchain/manifests and the reused pinned
PMF/marginal/conditional/ENNReal dependencies. Add source paths explicitly;
the adapter does not infer the import closure. Planned files that do not yet
exist are creation targets, not missing-file entries in the initial capture.
Ensure both new consumer owners and the new semantic owner are captured once
created and before review. Capture membership is evidence scope, not commit
ownership: record the unrelated website-notes difference and its lack of
mathematical impact while preserving and excluding those notes from C12 changes.
Keep `.lit-review/`, builds, reference PDFs and scratch outside source capture.

Keep the actual step baseline B, reviewed candidate R and final candidate F
distinct. Record actor, command/method, source and actual result for every
check; separate fresh checks from earlier applicable evidence, researcher
probes and reviewer-reported results. Retain original failures and limitations.

### 5.2 Clean-checkpoint and API-documentation boundary

The full `python scripts/validate_release.py` and standalone `hygiene` require
a clean committed tree. This planning request supplies **no commit authority**.
Prepare and validate the complete scoped candidate and exact file list before
requesting a checkpoint. If unrelated notes remain dirty, use a separately
authorized clean-checkout/checkpoint arrangement that preserves their bytes
and excludes them from the commit; do not hide them, weaken hygiene, or infer
permission to commit from a final-step request. If required authority is absent,
report the clean gate pending and stop before claiming closeout.

C12 adds a supported semantic owner and therefore selects a current API-doc
milestone in C12.04:

```text
python scripts/validate_release.py
python scripts/validate_release.py api-docs
```

On Windows, use the already reviewed Zig 0.16.0 through `LEANINFOTHEORY_ZIG`,
`DOCGEN_SRC=file`, and the maintained two-pass build/checker. Preserve exact
current signatures, docstrings, owners, attribute coverage, output identity
and the v2 attestation. Do not stage current documentation into `/docs/v0.1.0/`
or publish. The C10/C11 stale aggregate-HTML-marker failures are diagnostic
history: inspect real output before any bounded cache repair; do not delete
caches preemptively. After an authorized amendment repeat the full routine
suite and establish exact API-doc/review applicability, rerunning invalidated
evidence. Full-suite and API-doc success are independent requirements.

### 5.3 Persistent independent reviewer

Reuse the existing binding for C12 parent
`01a0feb9-5b87-7ae0-a78d-8212067a2306`, native role `/root`, and reviewer
`/root/c12_reviewer`. The requested profile was `gpt-6-astra`, `ultra`,
`fork_turns="none"`; effective runtime settings remain unknown. Original
creation/bootstrap evidence is retained at
`.lit-review/setup/c12-reviewer-native-creation-20261003.json` and
`c12-reviewer-bootstrap-list-native-20261003.json`; the installed binding is
`.lit-review/chunks/C12/binding.json`.

Cooperative read-only instructions are not OS isolation or authenticated
provenance. Check native availability when review is requested. Preserve prior
reports and unresolved records; do not transfer or silently replace the binding.

For an explicitly requested plan review, use the installed PLAN session and
proposal criteria; assess feasibility/contracts, not nonexistent implementation.
A review of this revised proposal requires a fresh explicitly requested plan
session with its exact source, retaining the revision-1 history in Section 2.4.
For each selected implementation step, retain validation, contextual self-review
and a separate reassessment before neutral independent dispatch. Use the exact
protocol rubric, source scope, IDs and normative excerpts. Do not forward
implementation transcripts or self-review verdicts to the reviewer.

Persist the exact rendered request and dispatch intent before
`collaboration.followup_task`, and send that full request text as the message.
A pointer to a saved request does not satisfy the installed submission contract.
Preserve original native receipts. The installed collaboration adapter accepts
completion from the actual `collaboration.list_agents` entry with the matching
`agent_name` and nonempty `agent_status.completed`; preserve that full native
result and exact extracted body. Running signals or a bootstrap cannot be
substituted. No missing IDs, results, effective settings or origin evidence may
be manufactured. Criterion gaps require renewed satisfactory reviewer assessment.

## 6. Edge cases, proof risks and approval checkpoints

| Issue | Required treatment or checkpoint |
| --- | --- |
| Product orientation | Right-associated triples; swapped `R` supplies C-given-B. Check AB, BC and AC maps separately. No implicit casts or unreviewed reassociation simp rules. |
| Supported channel rows | `hK` is needed only on `J.support`. The diagonal fair-Bool consumer has an unused pair with individually supported coordinates and incorrect row marginals. Neither all rows nor the product of marginal supports may replace joint support. |
| Null middle fibers | Marginal zero implies every contributing pair atom is zero. Prove whole-law equality for arbitrary fallback changes; no null-fiber conditional interpretation. |
| Finite vs Fintype | Gluing exposes only `[Finite C]`; TV/event finite-sum consumers use `[Fintype]` as actually needed. A/B/C/D remain heterogeneous and universe-polymorphic. |
| Empty/singleton types | Supplied PMFs rule out empty coordinates; do not add arbitrary inhabitants. Explicit singleton laws and pure laws must satisfy all applicable contracts. |
| ENNReal boundary | Gluing itself stays in ENNReal PMFs. Existing reconstruction's cancellation uses nonzero supported mass and `apply_ne_top`. Real event/sum conversions require finite event values and termwise non-top evidence. No use of unguarded `toReal` injectivity. |
| Selected vs arbitrary gluing | Pair laws alone do not force endpoint independence. Use the public witness's Markov property and both pair laws to identify the required atoms; existing reconstruction and the cross-product characterization are available proof routes. |
| Maximality | Test the actual adjacent maximal witnesses and the same gluing output. Do not infer maximal endpoint coupling from adjacent maximality. |
| Proof feasibility | Section 2.4 records completed planning probes and their limits. Repeat a bounded probe only for a specific unresolved feasibility question or invalidated dependency/contract evidence; maintained consumers still require compilation. If an approved contract needs stronger hypotheses or a public constructor, stop for a plan-health decision. |
| Imports/API growth | New semantic owner and aggregate addition need actual approval in current policy; no stable declaration move or root growth. |
| Validation authority | Present an exact reviewable checkpoint before requesting commit authority. Preserve website notes and durable review records. Missing clean-gate authority is not a passing gate. |

Approval of this exact revision would select the theorem-only surface, the
support-aware lifting premise, the one-finite-endpoint gluing contract, the
new semantic owner/import addition and the four step boundaries above.
These are proposed decisions, not approvals already granted. An explicit plan
review may be requested first; it is separate from approval and execution.

Implementation tactics, private helper names and proof organization may evolve
within these contracts with recorded evidence. Changing mathematical meaning,
required scope, public assumptions, ownership/import policy, acceptance criteria
or dependency pins requires the lead. Keep evolving proof advice in a separately
captured `post-release-chunk-12-notes.md` after implementation is authorized,
leaving approved normative requirements fixed. Record newly demonstrated naming
friction under Note 14 and the downstream feedback register; do not add aliases
preemptively. No decision about a public composition API is left to proof pressure.

## 7. Canonical reconciliation and remaining-work handoff

During authorized steps, update meaningful project-log milestones and applicable
source-derived artifacts. At closeout reconcile the living summary's Quick
Start, coverage, module graph, active work, future-work dispositions and validation
against actual source and private completion evidence. Reconcile C12's map entry,
reference adaptations and current API documentation; preserve historical plans
and C11's captured handoff. Link the maintained C12 handoff from canonical context.

The handoff must distinguish delivered APIs from private examples and retain:

- Minimal transport and separate gluing imports; both pair and endpoint laws.
- The absence of a public selected composition law and why that choice was made.
- Null-fiber independence and the exact non-maximality regression.
- C10/C11 interfaces consumed, exact source/reference adaptations and checked
  ENNReal-to-Real boundaries.
- Actual step/full-chunk review and validation references with their limits,
  including clean-checkpoint and current documentation applicability.
- Remaining public composition, uniqueness, generalized coupling, posterior
  conveniences and documentation observations with owners and concrete triggers.
- Deferred endpoint error accumulation: on a common alphabet, the endpoint
  disagreement is at most the sum of the two preserved pair disagreements,
  by event inclusion and the union bound. It needs no Markov assumption and
  adds no coverage required by this chunk's existing consumers. A later
  coupling-consumer step may take it up when an approved downstream use needs
  composed error bounds; keep any initial proof private and guard Real
  conversions. It is not a C12 implementation or approval condition.
- C13/Pinsker, C14/continuity and later work as separately approved future work;
  C12 completion is not authority to begin them or transfer this reviewer.

Captured documents should say validation-ready and closure-subject-to-private-record
when appropriate. Finish them before F. The private completion mechanism and
final user report carry the actual closure reference. Preserve the user's
website notes throughout. Stop after presenting this proposal until further
explicit authorization.
