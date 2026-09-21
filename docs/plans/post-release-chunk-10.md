# Chunk 10: Finite Total Variation

<!-- lit-review-status:start -->
**Status:** Approved revision 2, 2026-09-20; C10.07 cumulative review reconciled.
Final validation and closure are established by the source-bound private records.
C10.01--C10.06 and their reviews remain complete by actual private records.
The lead explicitly authorized the concrete local checkpoint under Section 5.2.
The initial clean routine suite and real two-pass current API-doc gate passed;
a fresh full-chunk review assessed all 19 approved criteria and its original
report was explicitly reconciled. The [maintained handoff](../handoffs/chunk-10.md)
and [notes](post-release-chunk-10-notes.md) retain the source/evidence boundaries.
Final amended-clean-suite validation and exact API-doc/review applicability
are established by those private records. This maintained chronology does not
itself certify final F or closure. Revision 1 received formal plan review with no findings;
revision 2's accepted advisory refinements were approved by the lead, without
claiming an additional formal plan review. C9 remains complete; C11 and later
chunks are not selected. No push or publication is included.
<!-- lit-review-status:end -->

## 1. Authority, scope and non-goals

This draft refines [C10 in the proposed map](post-release-chunk-map.md#c10-finite-total-variation)
and its cross-cutting contracts. Approval of this exact plan and an explicit
request for one step are separate prerequisites to implementation. Formal plan
review requires its own explicit request. Each implementation turn performs only
the requested approved step, with the requested review process, and stops.

The mathematical endpoint is a small finite-PMF comparison layer with probability
normalization

`TV(p,q) = (1/2 : Real) * sum a, |(p a).toReal - (q a).toReal|`.

Deliver the range `[0,1]`, metric laws as theorems, attained event and bounded-test
characterizations, overlap and residual-mass identities, deterministic-map and
common-channel contraction, and permanent consumers connecting these forms.
There is one probability object (`PMF`) and one TV definition.

Excluded: coupling objects or constructions, maximal coupling, gluing, Pinsker,
entropy or information continuity, topology or metric instances, a general
f-divergence/IPM hierarchy, signed-measure TV, hypothesis-testing optimization,
channel achievability, coding, and external formalization reuse. C11--C15 retain
their own approval and implementation boundaries. No dependency upgrade, released
declaration relocation/rename, facade alias, or new simp rule is proposed.

Planning edits are limited to this plan, its planning notes, necessary ignored
private workflow records and ignored disposable probes. Production Lean,
dependencies, frozen release artifacts, website content and canonical status
documents are unchanged at this stage. No commit, push or publication is
authorized by planning, plan approval, or review completion.

## 2. Verified intake and source adaptations

### 2.1 Current prerequisite and validation baseline

- Intake HEAD: `6afede1a7e4e0bccd65742b0c61d7a92e51a6e93`, clean `master`.
- C9.07's actual private record is
  `.lit-review/setup/c9-07-completion-20260912.json`, with status
  `SUPERVISED_STEP_COMPLETE` and closure
  `6d1a5d4ade2a491ee8a70500902138867e806eea3127e41c3139ce443c1e84be`.
  It identifies source checkpoint `8ee0337b20c320c384d5637de852da7f4ee09728`,
  accepted review, final source, all satisfied criteria and cumulative evidence.
  Relevant originals and evidence hashes were checked; no C9 history was recreated.
- Since that checkpoint, two commits concern website/discovery work. Lean source,
  current and frozen API manifests, retained compatibility artifact, policy and
  dependency pins are unchanged. The current validator additionally checks four
  website-guide examples; C9 evidence does not certify the modified validator or
  its current API-doc fingerprint. This is a fresh-validation duty, not a C9 blocker.
- Current supported inventory: 603 declarations in 31 owners; 94 reviewed simp
  declarations and 92 facade aliases. The root has five local modules. The frozen
  v0.1.0 API retains 601 declarations. Inventories are observations, not quotas.
- Lean is `v4.33.1`; installed clean mathlib is
  `0df444a360eaa60ab8c11dca51a86af692955474`; isolated doc-gen4 is
  `e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015`. No pin change is needed.
- Both installed review commands, `inspect` and `api`, succeeded. The C10 binding
  uses the supported `collaboration` transport, requested `gpt-6-astra` / `ultra`
  / `fork_turns="none"`. Original native results are preserved; effective settings
  are unreported. Bootstrap is not formal review or execution approval.

### 2.2 Exact reference reading

The editions and hashes are registered in [references](../references.md). The
following are mathematical adaptations, not copied textbook proofs.

| Source inspected | Relevant statement | C10 interpretation |
| --- | --- | --- |
| LP17 Sections 4.1--4.2, printed 47--52 / PDF 63--68 | Definition (4.1), Proposition 4.2, Remark 4.3, triangle remark, Proposition 4.5 | LP17 starts with maximum absolute event discrepancy, then proves half-L1 and positive-part formulas. C10 defines half-L1 and proves the event maximum, including a witness. |
| LP17 Proposition 4.5, equation (4.7), printed 49 | Half the supremum of the signed expectation difference for `abs f <= 1` | The unscaled bound is `2 * TV`, attained by the sign test; unit-interval tests instead have bound `TV`. |
| LP17 Section 4.2, Proposition 4.7 and (4.13) | Coupling interpretation and overlap mass `1-TV` | Only the overlap identity is implemented in C10; the coupling construction and its endpoint normalization branches belong to C11. |
| PW24 Section 7.3, Theorem 7.7(a), (7.18), printed 122--123 / PDF 147--148 | Signed event supremum and half the bounded-test supremum, with attainment | Finite `Set` events need no measurability premise. Both signed and absolute event forms are provided. |
| PW24 equation (7.3), definition cross-reference used by Section 7.3 | Half-L1 and common minimum mass, under a dominating measure | Finite counting sums implement the same normalization. No likelihood ratio or support inclusion is required. |
| PW24 Section 7.3, Theorem 7.7(b) and remaining discussion, printed 123--126 | Couplings; Hellinger, testing asymptotics and contiguity | Read for boundaries; none of these additional theorem families is C10 scope. |

PW24's first proof sentence on printed page 123 says the second supremum
"lower bounds TV", whereas the preceding inequality establishes that half of
that supremum is at most TV. The displayed theorem and LP17 agree; C10 follows
those equations and proves each direction explicitly. The signed maximizing
event can use `p >= q` (LP17) or `p > q` (PW24); equality atoms contribute zero.
Choose `q(a).toReal <= p(a).toReal` consistently. There is no normalization
conflict requiring a different project convention.

The interval bound, ENNReal normalization interfaces and direct finite-channel
proof are derived finite-algebra contracts. They are not attributed as separately
numbered theorems in these sections. PW24's density notation supplies context,
not permission to add absolute continuity or likelihood-ratio hypotheses.

### 2.3 Reuse and feasibility boundary

Searches covered project source and generated inventory, likely probability
owners and pinned mathlib. No existing finite-PMF TV API was found. Upstream
signed/vector-measure variation and bounded variation of functions are different
owners, with heavier machinery or different objects; they do not justify a
core dependency. A future semantic comparison would be a separate opt-in bridge.

Reuse `PMF.sum_toReal`, `PMF.bind_toReal_apply`, `PMF.toReal_nonneg`,
`PMF.toReal_le_one`, `PMF.apply_ne_top`, PMF extensionality and map/bind laws.
Reuse the existing outer-measure event evaluation and its finite-sum/map formulas;
do not introduce another event-probability definition. Reuse ENNReal finite-sum,
minimum and truncated-subtraction conversion lemmas after checking their guards.
The pinned `tsub_min` already reconciles subtraction of the common minimum with
truncated subtraction; reuse it in the normalization consumer rather than add
a public wrapper solely for that rewrite.

The [notes](post-release-chunk-10-notes.md) distinguish source-verified names,
compiling checks, proof-complete disposable probes, and unproved proposals.
The entire chunk is not already proved by those probes. Production proof routes
and private helpers remain advisory; public mathematical contracts below are
the proposed approval surface.

## 3. Ownership, assumptions and proposed API

### 3.1 Module and import decision

Propose one supported owner, `LeanInfoTheory.Probability.TotalVariation`, in
namespace `PMF`. Its local import is only `LeanInfoTheory.Probability.Finite`.
The candidate explicit external tactic imports are `Mathlib.Tactic.Linarith`
and `Mathlib.Tactic.Ring`; no Shannon, KL, kernel, signed-measure or topology
import is allowed. Final necessary direct imports must be recorded exactly in
the reviewed growth policy. Removing a redundant tactic import is an advisory
refinement; adding a heavier mathematical dependency requires plan-health review.

Add exactly this owner to the import-only `LeanInfoTheory.Shannon` umbrella,
preserving its four existing imports. Record both a `new_module` approval and an
`umbrella_addition` in `docs/compatibility/current-api-policy.json`, with exact
resulting local/external imports, rationale, permanent consumer and the actual
approval reference. These records may be written only after an actual approval;
generated inventory never supplies it. No import is added to
`LeanInfoTheory.lean`, `Probability.Finite` or `InformationMeasures`, and the
five-module root closure remains exact.

Raw `p.bind W` needs no `FiniteChannel` import in the TV owner. The channel
integration consumer separately imports `Probability.FiniteChannel`. One owner
suffices because all selected proofs are finite probability algebra. Do not split
files merely to match step IDs. Add no measure-TV bridge in C10; evaluating
existing `PMF.toOuterMeasure` events already lies in the inherited PMF closure.

### 3.2 Common notation and assumptions

In the tables below, `r_p a := (p a).toReal`,
`E_p(s) := (p.toOuterMeasure s).toReal`,
`D(p,q,f) := (sum a, r_p a * f a) - (sum a, r_q a * f a)` and
`A(p,q) := {a | r_q a <= r_p a}` are **document notation**, not proposed new
public definitions. Only `PMF.totalVariation` is a new quantity.

- The definition exposes `[Fintype alpha]` and returns `Real`. TV theorems
  inherit that instance; map/bind comparison has `[Fintype alpha] [Fintype beta]`
  with arbitrary universes. There are no duplicate `[Finite]` wrappers. When
  only internal finiteness is needed for an ancillary result, prefer `[Finite]`.
- No public `DecidableEq`, `DecidablePred`, `Inhabited`, `Nonempty`, full-support,
  support-inclusion or positivity-of-TV premise is needed. Use local classical
  instances for set filters and finite sums. Explicit PMFs themselves imply a
  nonempty support when a proof needs a witness.
- Canonical events are `Set alpha`. Finsets interoperate by coercion and the
  finite-sum bridge; a parallel predicate/Finset family is unnecessary.
- PMF atoms and event probabilities are finite. Every `toReal` injectivity or
  subtraction argument must establish its exact finiteness/order hypotheses.
  ENNReal subtraction below is deliberately truncated. No argument treats
  `top.toReal` as an ordinary infinite real value.
- Empty alphabets admit no PMF: universally quantified comparisons remain
  meaningful without a global nonempty assumption. A singleton/subsingleton
  alphabet has one possible law and distance zero. No fake empty law is built.

The following names are proposed public spellings, not declarations asserted to
exist. Review checks names against the final pinned environment. Any accepted
spelling refinement must be settled before freezing execution contracts; later
public-contract changes follow the installed protocol.

### 3.3 Core laws (C10.01)

| Proposed declaration | Contract |
| --- | --- |
| `PMF.totalVariation` | `noncomputable def`, exactly `(1/2 : Real) * sum a, abs (r_p a - r_q a)`. |
| `PMF.totalVariation_nonneg` | `0 <= totalVariation p q`. |
| `PMF.totalVariation_le_one` | `totalVariation p q <= 1`. |
| `PMF.totalVariation_self` | `totalVariation p p = 0`. |
| `PMF.totalVariation_comm` | `totalVariation p q = totalVariation q p`. |
| `PMF.totalVariation_eq_zero_iff` | `totalVariation p q = 0 <-> p = q`. |
| `PMF.totalVariation_triangle` | `totalVariation p r <= totalVariation p q + totalVariation q r`. |

These remain explicit theorems, with no new metric/topology instance or simp
attributes. Separation must recover ENNReal atom equality using `apply_ne_top`.

### 3.4 Event characterization (C10.02)

| Proposed declaration | Contract |
| --- | --- |
| `PMF.toOuterMeasure_toReal_eq_sum` | `E_p(s) = sum a, s.indicator (fun a => r_p a) a`, for every set `s`. Use the existing noncomputable indicator to avoid a public decidability premise. |
| `PMF.abs_toOuterMeasure_sub_le_totalVariation` | `abs (E_p(s) - E_q(s)) <= totalVariation p q`. |
| `PMF.totalVariation_eq_sum_pos` | `totalVariation p q = sum a in univ.filter (fun a => r_q a <= r_p a), (r_p a - r_q a)`. |
| `PMF.totalVariation_eq_toOuterMeasure_sub` | `totalVariation p q = E_p(A(p,q)) - E_q(A(p,q))`. |
| `PMF.totalVariation_isGreatest_event` | `IsGreatest (Set.range (fun s : Set alpha => E_p(s)-E_q(s))) (totalVariation p q)`. |
| `PMF.totalVariation_isGreatest_abs_event` | The same greatest-value statement for `abs (E_p(s)-E_q(s))`. |

An explicit equality for the displayed set is required; an abstract supremum
alone is insufficient. `IsGreatest` packages membership/attainment and universal
upper bounds without requiring an order-topology construction. It implies the
textbook maximum/supremum. No extra `sSup` wrappers are required initially.
The real event expansion is justified as a reused interface for event and test
consumers. Keep complement/balance bookkeeping private unless a second production
consumer demonstrates a missing general PMF fact.

### 3.5 Overlap and normalization interface (C10.03)

| Proposed declaration | Contract |
| --- | --- |
| `PMF.totalVariation_eq_one_sub_sum_min` | `totalVariation p q = 1 - sum a, min (r_p a) (r_q a)`. |
| `PMF.totalVariation_eq_sum_sub_min` | `totalVariation p q = sum a, (r_p a - min (r_p a) (r_q a))`. The opposite residual follows by symmetry. |
| `PMF.sum_min_eq_ofReal_one_sub_totalVariation` | `(sum a, min (p a) (q a)) = ENNReal.ofReal (1 - totalVariation p q)`. |
| `PMF.ofReal_totalVariation_eq_sum_sub` | `ENNReal.ofReal (totalVariation p q) = sum a, (p a - q a)`. |
| `PMF.totalVariation_eq_one_iff_disjoint_support` | `totalVariation p q = 1 <-> Disjoint p.support q.support`. |

The ENNReal formulas serve C11's actual PMF normalization, so it need not repeat
all conversion work or import Shannon semantics. Their proofs use finite PMF
masses and correct truncated subtraction, without dividing by overlap or TV.
No normalized residual PMF, branch fallback, or coupling is constructed here.

The separately importing normalization consumer must also work for arbitrary
finite `p,q`. For this consumer only, write `T := totalVariation p q`,
`C := sum a, min (p a) (q a)`,
`R_p := sum a, (p a - min (p a) (q a))` and
`R_q := sum a, (q a - min (p a) (q a))`, all three sums in ENNReal.
Derive `C = ENNReal.ofReal (1-T)` and
`R_p = R_q = ENNReal.ofReal T` from the public API and existing scalar lemmas,
including the pointwise residual rewrites to `p a - q a` and `q a - p a`.
Derive that all three totals are less than `top` without strict-TV hypotheses.
Under `0 < T` and `T < 1`, also derive `0 < C`, `0 < R_p` and `0 < R_q`.
Express the totals as `tsum`s using finite-sum interoperability and obtain the
nonzero/non-top premises of the existing `PMF.normalize`, without applying that
constructor. The strict-TV hypotheses belong only to this private interior-case
consumer; the public identities remain unconditional. Keep the endpoint tests
as separate obligations. No reciprocal, normalized law or extra public helper
is required by this consumer.

### 3.6 Bounded tests with sharp constants (C10.04)

For real tests `f : alpha -> Real`, use explicit weighted sums. Do not add an
expectation object, Bochner-integral layer, or normed function-space structure.

| Proposed declaration | Contract |
| --- | --- |
| `PMF.abs_sum_sub_le_totalVariation_of_mem_Icc` | Given `l <= u` and `forall a, l <= f a and f a <= u`, `abs D(p,q,f) <= (u-l) * totalVariation p q`. Includes `l=u`. |
| `PMF.abs_sum_sub_le_mul_totalVariation` | Given `0 <= M` and `forall a, abs (f a) <= M`, `abs D(p,q,f) <= 2*M*totalVariation p q`. Includes `M=0`. |
| `PMF.totalVariation_isGreatest_unitInterval` | TV is `IsGreatest` of the set of `d` such that `exists f, (forall a, 0 <= f a and f a <= 1) and d = abs D(p,q,f)`. |
| `PMF.two_mul_totalVariation_isGreatest_bounded` | `2*TV` is `IsGreatest` of the set of `d` such that `exists f, (forall a, abs (f a) <= 1) and d = abs D(p,q,f)`. |

Both attainment proofs must exhibit the concrete indicator of `A(p,q)` and the
sign test `if a in A(p,q) then 1 else -1`, respectively, and prove their
nonnegative signed differences equal TV and `2*TV`. Keep those witness proofs
private if the greatest-value statements and event witness give all consumer
access needed. Require separate private generic consumers, for arbitrary finite
`p,q`, deriving both signed greatest-value statements from the exported API:

- `IsGreatest {d : Real | exists f : alpha -> Real, (forall a, 0 <= f a and f a <= 1) and d = D(p,q,f)} (totalVariation p q)`.
- `IsGreatest {d : Real | exists f : alpha -> Real, (forall a, abs (f a) <= 1) and d = D(p,q,f)} (2 * totalVariation p q)`.

These consumers must include `p=q`, use no positive-TV premise and require no
access to private production witness lemmas. They establish the signed textbook
formulations without adding public aliases or duplicating the TV definition.
The false bound `abs D <= TV` for general `abs f <= 1` is explicitly excluded.

### 3.7 Map and common-channel contraction (C10.05)

| Proposed declaration | Contract |
| --- | --- |
| `PMF.totalVariation_bind_le` | For any one channel `W : alpha -> PMF beta`, `TV (p.bind W) (q.bind W) <= TV p q`. |
| `PMF.totalVariation_map_le` | For any `f : alpha -> beta`, `TV (p.map f) (q.map f) <= TV p q`. |
| `PMF.totalVariation_map_equiv` | For `e : alpha equiv beta`, `TV (p.map e) (q.map e) = TV p q`. |

The finite types need not have equal cardinality. Maps need not be injective
for contraction; channel rows need not have full support. The channel really is
common to both laws. No bound for arbitrary distinct `W,V` is claimed. A channel
to an empty target exists only vacuously on an empty input; a supplied source PMF
rules that case out without strengthening the public statement.

Prove bind contraction from real finite sums and normalized rows, or from the
unit-interval test form after verifying the event-bind expansion. Map contraction
may specialize to pure channels or use event preimages. Equivalence invariance
uses contraction twice and inverse-map laws. The proof route is advisory.

## 4. Steps, dependencies and acceptance criteria

All criterion sentences below are proposed normative anchors for the installed
workflow. Every step also obeys Section 5's common validation, ownership,
documentation and review requirements. Earlier outcomes must remain valid.
Later steps are never selected automatically.

### C10.01 - Definition, range and metric laws

**Depends on:** approved exact plan, actual C10 binding, verified C9 endpoint.
**Owned changes:** new TV owner; additive full-umbrella import and the two reviewed
policy entries; minimal new `Examples.TotalVariation` consumer and its examples
aggregate import; corresponding generated inventory/reference updates.

- **C10.01-MATH:** The exact Section 3.3 definition and all six core laws hold for finite PMFs with the stated assumptions and half-L1 normalization.
- **C10.01-BOUNDARY:** The TV owner imports only the approved probability/tactic dependencies, is supported through the full umbrella, and leaves the protected root, released API and reviewed attributes unchanged.
- **C10.01-CONSUMER:** A separately importing permanent consumer checks self-distance, separation and distance one between distinct pure Boolean laws.

**Early environment check:** before substantial edits, run one small native Lean
stdin check importing `LeanInfoTheory.Probability.Finite` and exercising an
existing finite-PMF identity, with `-DwarningAsError=true`. Use the pinned compiler
and this checkout's
dependency search paths; retain the exact input, command, streams, actual process
exit status and any timeout/interruption. Reuse an equivalent successful check
already obtained in this implementation turn if its source, configuration and
dependency inputs still apply. A pipeline status alone is insufficient. This
bounded check resolves the remaining strict-exit-status evidence gap; it neither
replays all planning proofs nor requalifies C9. It does not replace the following
maintained checks.

**Validation:** focused TV, consumer, root and full umbrella builds; deliberate
current generation, static gate, compiled compatibility for the new-module
boundary; inspect current imports/owners and exact frozen preservation.
**Risks:** finite-real separation, factor-of-two arithmetic, accidental root
reachability, approval records mistaken for generated metadata. Document actual
names/imports and log this first mathematical milestone.

### C10.02 - Attaining events and finite event interoperability

**Depends on:** C10.01.
**Owned changes:** Section 3.4 in the TV owner; focused event consumers.

- **C10.02-MATH:** Every Section 3.4 event contract holds, including the explicit maximizing set and both signed and absolute greatest-value characterizations.
- **C10.02-INTERFACE:** Existing Set-valued PMF event probability agrees with finite real sums and accepts Finset coercions without public decidability or measurability assumptions.
- **C10.02-CONSUMER:** Permanent consumers use the event theorem on empty/full events, tied masses, a nontrivial Boolean event and its Boolean indicator pushforward.

At this step the indicator-map consumer checks the event-probability/preimage
interface. The generic equality of TV before and after the maximizing-event
pushforward is scheduled in C10.06, after map contraction is available.

**Validation:** focused owner/consumer/full-umbrella builds, generation and static
checks; finite-set coercion and source/general-assumption inspection.
**Risks:** signed/absolute orientation, complement balance, event `toReal`
finiteness. Tests must use the public event interface, not only unfold TV.

### C10.03 - Overlap, residual masses and disjoint support

**Depends on:** C10.02 (the identities can use independent finite algebra).
**Owned changes:** Section 3.5 and overlap/residual consumers.

- **C10.03-MATH:** All Section 3.5 real and ENNReal overlap/residual identities and the exact disjoint-support characterization hold without support or positivity restrictions.
- **C10.03-CONSUMER:** A permanent normalization consumer proves Section 3.5's generic overlap and both residual-minimum total identities, their nonzero/non-top consequences when TV lies strictly between zero and one, overlap mass one and both residual masses zero for equal laws, overlap zero and both residual masses one for disjoint laws, and the specified sparse example's exact intermediate totals.

Use the sparse three-point laws `p=(1/2,1/2,0)` and `q=(0,1/2,1/2)` on
`Fin 3`. Require `TV=1/2`, overlap total `1/2`, and each residual total `1/2`.
This single pair covers zero masses, a positive tied mass and partial overlap.
Keep its construction and scalar bookkeeping private to the example module.

**Validation:** focused owner/consumer/umbrella builds, generation/static checks;
explicit audit of every `toReal`, `ofReal`, minimum and truncated-subtraction
guard. **Risks:** silently treating ENNReal subtraction as real subtraction or
dividing by zero. The consumer verifies the interface needed by C11 without
constructing any new normalized law.

### C10.04 - Bounded tests and constants

**Depends on:** C10.02--C10.03.
**Owned changes:** Section 3.6 and test-function consumers.

- **C10.04-MATH:** Every Section 3.6 bound and greatest-value characterization holds, with explicit indicator/sign witnesses and correct constants for unit-interval, signed-unit and arbitrary interval tests.
- **C10.04-CONSUMER:** Permanent consumers derive both generic signed greatest-value statements in Section 3.6 through the public API, attain TV and twice TV on a nontrivial two-point example, and verify constant-test, zero-radius and zero-width interval cases.

**Validation:** focused owner/consumer/umbrella builds, generation/static checks;
review quantifiers, signs and witness memberships. **Risks:** normalization
confusion, unnecessary strict interval width, a nonattained supremum, or a false
factor-one bound on signed unit tests. Use a shift/positive-part argument or
handle zero width explicitly before rescaling; no unguarded division.

### C10.05 - Deterministic and stochastic processing

**Depends on:** C10.01--C10.04.
**Owned changes:** Section 3.7 and a second private consumer owner,
`LeanInfoTheory.Examples.TotalVariationChannels`, imported by `Examples` only.
Its direct local imports are TV, `Probability.FiniteChannel` and, when used for
the stochastic example, `Probability.FiniteMixture`.

- **C10.05-MATH:** The common-bind, arbitrary-map and equivalence contracts in Section 3.7 hold without injectivity, full support or unnecessary nonempty assumptions.
- **C10.05-CONSUMER:** Permanent consumers exercise a noninjective map, constant collapse, identity/relabeling equality, the specified Boolean noisy channel's exact strict contraction and composition through existing channel laws.

For the noisy channel, each Boolean input is retained with probability `3/4`
and flipped with probability `1/4`. For source laws `pure false` and `pure true`,
prove input TV is `1` and output TV is exactly `1/2`. Use the public contraction
theorem as well as the explicit output calculation. This tests stochastic rows
and a strict decrease with a fixed expected value.

**Validation:** focused both TV consumers, TV owner, Examples/full umbrellas;
generation/static and compiled compatibility; inspect that `FiniteChannel` and
example imports do not become dependencies of the TV owner. **Risks:** swapping
sum indices, failing to use row normalization, accidentally comparing distinct
channels, or importing semantic DPI to prove elementary contraction.

### C10.06 - Integrated finite consumers and API readiness

**Depends on:** C10.01--C10.05.
**Owned changes:** complete the two existing C10 example modules; reconcile API
documentation, current generated references and affected canonical records.
Promote no helper simply to increase coverage counts.

- **C10.06-NORMALIZATION:** One shared explicit Boolean family has TV equal to the absolute parameter difference and connects finite sums, attaining event, overlap, unit-interval/sign tests and deterministic contraction, including parameter endpoints.
- **C10.06-BINARY:** A private generic consumer proves that pushing arbitrary finite p and q through the Boolean indicator of their maximizing event preserves TV exactly, using the public event and map interfaces without additional support or positivity assumptions.
- **C10.06-EDGES:** The permanent suite covers equal laws, zero masses, disjoint supports, pure laws, singleton/subsingleton alphabets, absence of an empty-alphabet PMF, and projection of a joint law without changing the theorem assumptions.
- **C10.06-API:** All public C10 declarations are documented, discoverable under the chosen owner, retained by exact current inventory and exercised by appropriate consumers; private proof machinery and examples stay outside supported API.

Use `PMF.ofFintype` on `Bool` with masses `t` and `1-t` for `0 <= t <= 1`, or
an already supported equivalent constructor. Do not use the pinned deprecated
`PMF.bernoulli`. Keep the family private to examples. For stochastic strict
contraction, retain and integrate C10.05's fixed Boolean flip-channel calculation.
Joint projections supply a lightweight C14-facing consumer without entropy.

For C10.06-BINARY, let `A := {a | (q a).toReal <= (p a).toReal}` and, with
local classical decidability, `b a := if a in A then true else false`. Require
`totalVariation (p.map b) (q.map b) = totalVariation p q` for arbitrary finite
`p,q`, including equal laws and disjoint supports. The proof must connect the
public attaining-event equality, the existing event-map preimage formula, the
public event bound and map contraction. Keep this generic theorem private in
`Examples.TotalVariation`; do not replace it with only a numerical instance or
rederive both distances by unfolding TV. This checks the C13 binary-reduction
interface without introducing KL or starting Pinsker's proof.

**Validation:** focused complete Examples and supported umbrella builds, current
generation/static, compiled compatibility and full `trust`, plus `documentation`
for affected release-facing examples. Review names, assumptions, direct imports,
simp, private/public inventory and all-project allowed axioms. Do not rerun C9's
entire fixture matrix absent an infrastructure change or demonstrated concern.
**Risks:** consumers restating definitions rather than connecting APIs, accidental
test-only public helpers, stale generated references, or retaining old counts as
current. Log actual API readiness and any remaining closeout work.

### C10.07 - Cumulative validation, independent review and handoff

**Depends on:** C10.01--C10.06 and explicit clean-checkpoint authority when needed.
This is the final step; it selects no work in C11.

- **C10.07-VALIDATION:** Fresh source-bound cumulative evidence establishes every C10.01--C10.06 criterion, the complete current routine suite and real two-pass current file-mode API documentation on an authorized clean candidate.
- **C10.07-READINESS:** Canonical records and the maintained chunk-10 handoff are reconciled before final capture, with delivered API/import/consumer facts, source and review references, remaining-work dispositions, owners and triggers.
- **C10.07-INDEPENDENCE:** The candidate is ready for a fresh independent full-chunk review against every approved criterion, with earlier required reviews reconciled, no unresolved material concern, complete original evidence and exact source applicability disclosed.

These criteria establish readiness for cumulative review, not a claim that the
future review is already complete. Required subsequent postconditions are the
fresh bound review, explicit reconciliation even of a clean report, correction
and re-review of material changes or reviewer criterion gaps, final applicable
validation, exact final F and supported private closure. A favorable report alone
does not establish completion. Reuse the existing persistent C10 reviewer; it must
reassess the whole current chunk rather than concatenate earlier verdicts.

Prepare `docs/handoffs/chunk-10.md`, link it from canonical context, and reconcile
the living summary, current Lean state, roadmap/map, references, relevant log and
Future Work Notes. Update release-facing or generated documentation only where
C10 actually changes its claims; keep historical release claims distinct. Finish
all captured edits before F, retaining provisional wording such as "validation
ready; closure subject to the private completion record". Record actual closure
only privately and in the final user report; no post-F captured-file edit.

**Validation:** Section 5's complete clean suite and API-doc milestone, plus
independent source/meaning/consumer/import/API examination against all criteria.
Revalidate amended inputs before closure. **Risks:** unauthorized checkpointing,
stale validation after documentation/policy edits, favorable review without
reconciliation, or starting C11 from a handoff. Stop after reporting this step.

## 5. Validation and review execution contract

### 5.1 Common per-step duties

Use the existing growth-aware validator as the executable target/trust authority.
Serialize artifact-producing Lean/Lake commands. For each check retain actor,
source/config/dependency identity, command, output, exit status and limits in
private records. Distinguish fresh checks from earlier applicable evidence and
reviewer-reported checks. Ordinary compiler acceptance is not mathematical
source interpretation or proof that a consumer uses the intended API.

After approved public growth, deliberately regenerate the current inventory and
source-derived references, then run non-mutating checks:

```text
python -B scripts/generate_current_public_api.py
python -B scripts/generate_v0_1_public_api.py --check
python -B scripts/generate_website_blueprint.py
python -B scripts/generate_website_api_index.py
python -B scripts/validate_release.py static
python -B scripts/validate_release.py focused <affected owners and consumers>
```

Generation is future implementation work, not authorized during planning.
Update narrowly necessary new-module summary metadata through existing generator
mechanisms; no website redesign or publication is included. The historical
manifest, retained artifact, frozen route, version, licence and dependency pins
must remain untouched. Use `compatibility` at module/import integration and
`trust` at cumulative API readiness; the complete suite already includes them,
so avoid duplicating full builds when the inputs and evidence remain applicable.
The existing generated architecture probes check focused import reachability and
exact negative root boundaries; permanent mathematical examples remain the
primary consumers. Do not replace either with a custom C10 validator.

No `sorry`, `admit`, unapproved axiom, opaque/undefined/unsafe/native shortcut or
equivalent placeholder is permitted. Preserve the permitted-axiom set, exact
retained signatures/assumptions/imports, facade and simp behavior. Add private
helpers by default. Keep naming/alias and conservative simp review under standing
Notes 14--16. Log coherent milestones, not each algebraic lemma.

For an explicitly requested review, follow [protocol](../review-protocol.md) and
[operations](../review-operations.md): capture B before edits; retain self-critique
and separate reassessment; finish edits and validation before R and dispatch;
preserve intent before sending, original native responses and uncertainties;
reconcile findings and original criterion assessments; assess R-to-F impact and
close only through the installed mechanism. No parent transcript or expected
verdict is supplied to the reviewer. Formal plan review uses an expressly opened
`plan-*` session, not an execution session or bootstrap acknowledgment.

### 5.2 Clean checkpoint and final documentation gate

The complete validator requires a clean committed tree. The current instruction
forbids commits; neither plan approval nor a step/review request supplies checkpoint
authority. During C10.07, first finish and make reviewable the precise owned
candidate, list its paths and unrelated work, then request explicit authority
for that checkpoint (and any necessary subsequent amendment). Until granted,
retain pending full-suite status and stop at that boundary; do not commit other
work, stash it, delete it, weaken hygiene, or call dirty focused checks a full pass.
C9's checkpoint authority does not transfer to C10.

Once an exact clean candidate is authorized and exists, run:

```text
python -B scripts/validate_release.py
python -B scripts/validate_release.py api-docs
```

The second command is expressly proposed as C10's API-documentation milestone,
because this chunk introduces a supported owner and new public theorem families.
Use `DOCGEN_SRC=file`, `DISABLE_EQUATIONS=1`, and the reviewed Windows Zig 0.16.0
executable through `LEANINFOTHEORY_ZIG`, verifying its actual path/hash. Require
both real passes and the current v2 content-bound attestation. Inspect output
under `docbuild/.lake/build/doc/`; never relabel it as frozen v0.1.0 output.
No staging or deployment is required. Read maintained targets from
`python -B scripts/validate_release.py targets`; do not freeze a historical target
count in this plan. Re-run affected gates after any candidate amendment and the
complete suite after a checkpoint amendment as required by AGENTS.md.

C9's fixture qualification is retained prior infrastructure evidence. Re-run
targeted policy/growth tests if actual C10 integration reveals a relevant issue;
do not redesign mechanisms or rerun the complete old matrix merely because a
new chunk exists. Report any demonstrated limitation and obtain approval before
changing acceptance policy or infrastructure scope.

## 6. Permanent consumers and downstream contracts

| Consumer / future owner | Exact interface required | Boundary |
| --- | --- | --- |
| `Examples.TotalVariation` (new, private declarations) | One Boolean family connects representations; sparse ternary totals, generic interior normalization, signed tests and TV-preserving maximizing-event reduction supplement endpoint/degenerate cases | Focused TV import, no Shannon/KL. Introduced in C10.01 and expanded by subsequent requested steps. |
| `Examples.TotalVariationChannels` (new, private declarations) | Map, the Boolean flip channel's exact `1` to `1/2` TV decrease, channel composition and joint-projection comparisons | Separately imports existing raw channel/mixture owners; never imported by a supported mathematical owner. |
| C11 | Real and ENNReal overlap/both-residual totals, residual-minimum rewrites, generic nonzero/non-top interior totals, range and support-disjoint boundary | C11 chooses its coupling interface and handles residual normalization at TV=0/1. C10 constructs no witness law. |
| C12 | `totalVariation_bind_le` and deterministic transport on the same PMFs | Later coupling transport/gluing remains separate; no maximality-under-composition claim. |
| C13 | Signed attaining event and exact TV preservation under its Boolean pushforward, exercised generically in C10.06; nonnegative real TV for `ENNReal.ofReal` | C13 supplies the KL part of binary reduction and all infinite-KL guards. |
| C14 | Equality/separation, range, marginal-map contraction and singleton behavior | C11 supplies maximal coupling; C14 separately imports entropy/Fano. |
| C15 | Explicit finite real coordinate formula and separation/triangle | C15 selects topology/instances and proves coordinate convergence equivalence; C10 creates no instance. |

The module additions and consumer locations are proposals awaiting approval, not
existing files. Future cross-chunk usefulness is tested now by elementary
interface consumers, not by implementing the future theorems early.

## 7. Risks, dispositions and lead decisions

| Risk or deferred item | Disposition / owner / trigger |
| --- | --- |
| Factor-of-two ambiguity | C10 keeps the probability convention; exact two-point indicator/sign consumers are acceptance requirements. |
| ENNReal coercions, zero overlap/residuals | C10 proves guarded finite conversion identities; C11 owns construction branches. No support assumptions may be added to bypass them. |
| Event/test proof granularity | One Set event representation and constructive greatest-value contracts are selected. Add wrappers only after concrete consumer need and API review. |
| Import growth or current-policy mismatch | Use the delivered C9 approvals and exact import audit; lead decides any heavier boundary or protocol/acceptance change. |
| Current vs frozen docs and stale evidence | C10 final source gets fresh routine and API-doc gates; Note 9's broader blueprint/equation/publication work stays with its existing owner and trigger. |
| Naming/simp/module guardrails | Notes 14--18 remain standing. C10 closes no global naming, validation or architecture note. Alias friction goes to the existing downstream-feedback register only if observed. |
| Independence conveniences | Note 25's delivered deterministic slice remains closed; other variants are consumer-triggered and not C10 prerequisites. |
| Coupling, Pinsker, continuity, topology, coding | Retain map owners C11--C15 and later; none starts or is approved by this plan. |

**Decisions requested with exact-plan approval:** accept the single opt-in PMF
owner and additive full-umbrella import; the `[Fintype]`, Set-event and
`IsGreatest` contracts; the small ENNReal overlap/residual interface for C11;
the seven units and final real API-doc milestone. These are concrete proposals,
not unresolved mathematical prerequisites. Formal plan review remains a separate
request. Clean-checkpoint permission is intentionally requested only when its
exact candidate is concrete and reviewable. No immediate production action follows
from presenting this draft.
