# Chunk 14: Quantitative Continuity of Finite Information Measures

<!-- lit-review-status:start -->
**Status:** Approved, revision 2; C14.04 selected with review on 2026-10-08.
C14.01--C14.03 and their reviews are complete by their actual private records,
most recently `.lit-review/setup/c14-03-completion-20261007.json`.
All 219 captured entries matched Step 3's final source, including environment,
configuration and dependency identity, before the conditional Step 4 request
was accepted. This step adds no mathematics: it prepares cumulative qualification
and the [maintained handoff](../handoffs/chunk-14.md). Fresh preparation checks
and actual two-pass current API-doc qualification/inspection passed. The lead
explicitly authorized the 23-file local checkpoint, necessary C14.04-only
amendments and clean-checkout reuse. Initial checkpoint `ca079e2` passed the
complete routine suite. Final-candidate qualification, fresh all-twelve-criterion
review, reconciliation and private closure remain subject to source-bound
records; no future success is asserted here. C15, push and publication are unselected.
The lead instructed evidence-based adaptation while preserving mathematical
and review contracts. Revision-1 reports retain their original provenance and
unresolved formal admission; they are not implementation reviews. Statements
below about proposal/review status describe revision preparation on 2026-10-04;
this editorial status records later authority without changing normative contracts.
C13 is complete through C13.04 at `ebe48eaea4282b1e4f245f8f45440bc930b8df73`.
Historical pre-closure wording does not reopen completed steps.
<!-- lit-review-status:end -->

## 1. Scope and authority

This plan refines [C14 in the chunk map](post-release-chunk-map.md#c14-quantitative-continuity-of-information-measures).
Its endpoint is an exact-TV entropy inequality, a monotone bound for a supplied
TV budget, and conditional-entropy/MI bounds for close finite joint laws.
All information quantities are in nats; TV is the existing half-L1 distance.
The mathematical prerequisites are the relevant C10 TV and C11 maximal-coupling
interfaces, existing Fano, and existing entropy algebra. C12 gluing and C13
Pinsker are not prerequisites and must not be added as proof dependencies.

The four steps separate the coupling argument, scalar threshold argument,
derived information bounds, and final qualification. Each has a mathematical
or qualification endpoint that can be independently assessed. Consumer and
API obligations accompany the theorem steps; there is no implementation-only
step whose usefulness is deferred to closeout.

After exact approval, perform only the explicitly requested step with its
required review process, report its result, and stop. Plan review requires a
separate explicit request using the installed PLAN workflow. Bootstrap is not
review. Neither plan approval nor a favorable review authorizes a checkpoint,
push, publication, dependency change, next step or next chunk. The final clean
validation checkpoint requires separate authority at that time.

Excluded: C15 topology/compactness or new metric/topology instances, coding,
countable alphabets, KL continuity, local-distance refinements, a general
optimality/equality classification, conditioning-alphabet-independent sharp
bounds, CMI wrappers, and a second probability or information representation.
Scope expansion requires a concrete consumer and separate lead approval.

## 2. Verified intake and mathematical source

### 2.1 Checkout and predecessor

The actual checkout is `C:\Users\coban\Desktop\Lean Info Theory`, on `master`
at `ebe48eaea4282b1e4f245f8f45440bc930b8df73`. Its sole initial tracked change
is `docs/next-website-tasks.md`; preserve its bytes, staging state and location.
Do not stage, commit, revert, move or otherwise alter that file. Its intake
SHA-256 is `8db54766aff44faaf5f2380f0e9c11103ab4ba5471d2928b1c2750a3f3a11887`.

The actual `.lit-review/setup/c13-04-completion-20261003.json` records all four
C13 steps complete, no active step, all 13 criteria satisfied, and closure
`d81a4bca712d2024707bc1385aaf0a1a89315919ddf9da398b877d13747fbb52`.
Its final capture F is
`a5b292aba21df7b9f60be8f199009650c52a73a8f317a8ffb7597b95869b90fe`.
The C14 intake compares all 217 real file entries and the separately serialized
environment entry against F: no mismatch. Configuration and all nine installed
dependency records match. The completed C13.01--C13.03 records were also read.
The final applicability record is
`.lit-review/setup/c14-prerequisite-applicability-v3-20261004.json`;
earlier diagnostic attempts are retained with their corrections disclosed.

A fresh `python -B scripts/generate_current_public_api.py --check` confirms the
source-derived manifest. Current coverage is **647 documented declarations in
35 supported owners, 94 reviewed simp declarations and 92 root exports**.
These counts are observations, not quotas. This intake is not a rerun of the
full compiled compatibility, axiom or release suite. C13's recorded final full
routine passed on this exact commit in its authorized clean validation checkout;
that earlier result and its cache/checkout limitations remain separately attributed.

Lean remains `v4.33.1`; mathlib remains
`0df444a360eaa60ab8c11dca51a86af692955474`. Preserve every dependency pin,
including isolated doc-gen4, the frozen `v0.1.0` release at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, its manifest/retained signatures,
legal metadata and versioned documentation. No remote publication state is
inferred from local Git state.

Read for intake: `AGENTS.md`, the living-summary Quick Start and relevant
conventions/coverage/architecture/limitations/active-work/validation sections,
C14 and shared map contracts, C10/C11/C13 handoffs, the reference register,
both review documents, targeted C11.05 and C13 qualification log entries,
and Future Work Notes 14 and 29. The stale C13 chronology is resolved through
the actual completion capture, not edited retrospectively.

### 2.2 SA13 and adaptation

SA13 is Igal Sason, *Entropy Bounds for Discrete Random Variables via Maximal
Coupling*, registered arXiv `1209.5259v5`, July 23, 2013. The local 22-page
PDF hash was rechecked as
`90e7f4bf903ecc2583329b0bf33d58a580649d4d5f8490b0730158a8019ec6e6`.
Read: page 1 Definition 3/(2) for half-L1 TV; page 3 Theorem 2/(10) and
the base-e convention; Section II, Theorem 3/(11), its complete proof and
upper-budget discussion on PDF/printed pages 3--4. Both theorem/proof pages
were rendered and inspected. The [version-pinned source](https://arxiv.org/abs/1209.5259v5)
and [reference register](../references.md#sa13-sason) identify the edition.

The mathematical route is maximal coupling, the two conditional entropies,
Fano, and entropy identities. The library uses a joint PMF with exact ordered
marginals rather than introducing coupled random variables on a new sample
space. The same witness and its coordinate swap suffice; no equality between
separately selected maximal witnesses is assumed. Section II explicitly
distinguishes exact distance from an upper estimate and uses `log m` beyond
`1 - 1/m`. It attributes prior versions of the bound to earlier work; C14
cites Sason's route and claims no new attribution or formalized optimality theorem.

The displayed source formula needs separate singleton interpretation. The
Lean expression uses Nat subtraction before casting, consistently with Fano,
and total `Real.log`; zero-mass entropy terms use the existing zero convention.
Conditional-entropy/MI formulas below are derived from library identities and
TV contraction, not separately numbered SA13 results. No additional mathematical
source or external formalization is used.

## 3. Normative mathematical and API contracts

### 3.1 Exact entropy difference

Write `m = Fintype.card A`, `delta = PMF.totalVariation p q`, and
`h = Real.binEntropy`. Supply the public PMF theorem

```text
|entropy p - entropy q| <= h(delta) + delta * log((m - 1 : Nat) : Real).
```

For `m >= 2` this is exactly the conventional SA13 expression. The proposed
Lean theorem retains only `[Fintype A]` and `p q : PMF A`, like existing
expanded Fano. The compiling probe supports this stronger total statement:
at `m = 1`, both laws are equal, both entropies and TV are zero, so the
expression is zero; at `m = 0` no PMF exists. Document and test these cases
explicitly instead of ascribing a probabilistic meaning to `log 0`.
There is no support inclusion, full support, positive-distance, measurability,
decidable-equality or extra `Nonempty` premise. Enumeration is justified by
the existing entropy/TV definitions; local helpers may need only `Finite`.

### 3.2 Monotone upper-budget bound

Introduce one public scalar function, proposed name `entropyContinuityBound`,
with parameters `m : Nat` and `epsilon : Real`. Write it as `B_m(epsilon)`:

```text
B_m(epsilon) = 0                                      if m <= 1;
             h(epsilon) + epsilon * log(m - 1)        if m >= 2 and epsilon <= 1 - 1/m;
             log m                                   if m >= 2 and 1 - 1/m < epsilon.
```

Here `log(m - 1)` always abbreviates the cast of Nat subtraction, while
`1/m` is Real division after casting `m`. The analytic guarantees are for
**all real `epsilon >= 0`**, including `epsilon > 1`; no `epsilon <= 1`
hypothesis is required. The function is total, but its negative arguments
carry no approximation guarantee. `m = 0` is assigned zero only as a benign
scalar convention; it introduces no empty-alphabet law.

Prove a public `MonotoneOn (entropyContinuityBound m) (Set.Ici 0)` theorem
for each `m`, and the public law bound

```text
TV(p,q) <= epsilon ->
  |entropy p - entropy q| <= B_m(epsilon).
```

The TV hypothesis itself implies `0 <= epsilon`; derive this internally
instead of exposing a redundant sign hypothesis on the law-bound theorems.

Required scalar facts, which may remain private and be externally checked
by unfolding the public definition, are: `B_m(0) = 0`; for `m >= 2`,
the two branches agree at `t_m = 1 - 1/m`, with value `log m`; nonnegativity
and `B_m(epsilon) <= log m` for `m >= 1, epsilon >= 0`; saturation for
`epsilon >= t_m`; and zero for `m <= 1`. Equality uses the lower branch.
The exact-distance expression at delta one remains `log(m-1)`, not `log m`.
In particular, distinct pure binary laws have entropy gap zero even though
the upper-budget bound at epsilon one is `log 2`.

The proof must justify substitution only inside the monotone interval.
Above threshold it may use the elementary entropy range, deriving a local
`Nonempty A` instance from the supplied PMF for `entropy_le_log_card`.
No new derivative, topology or optimization API is required.

### 3.3 Conditional entropy and mutual information

Let `p q : PMF (A × B)`, with independent universes, `[Fintype A]`,
`[Fintype B]`, `m = card A`, `n = card B`, and `TV(p,q) <= epsilon`
(hence `epsilon >= 0`, without a separate premise). The first coordinate is the conditioned variable and
the second the conditioning variable. Supply public inequalities

```text
|condEntropy p - condEntropy q| <= B_(m*n)(epsilon) + B_n(epsilon);
|mutualInfo p - mutualInfo q|   <= B_m(epsilon) + B_n(epsilon) + B_(m*n)(epsilon).
```

Every cardinal here is the entire common finite alphabet, not a claimed
support-union size. The joint cardinal is the natural product `m*n`.
Use `condEntropy = H(joint) - H(second marginal)` and
`mutualInfo = H(first marginal) + H(second marginal) - H(joint)`.
Both marginal TV distances contract from the given joint distance. Each
entropy term uses its own capped bound; the thresholds need not coincide.
For `m,n >= 2` and epsilon below all three thresholds, the conditional
bound has two `h(epsilon)` terms and log coefficient
`log(m*n-1) + log(n-1)`; MI has three and coefficient
`log(m-1) + log(n-1) + log(m*n-1)`. These constants are intentionally bounded,
not claimed optimal. No public expanded-form aliases are required.

The formulas remain valid when either coordinate is singleton. Actual
conditional entropy is zero when the first alphabet is singleton; when
the second is singleton it reduces to ordinary entropy. MI is zero if
either is singleton. These reductions must be tested; the displayed loose
bounds need not themselves become optimal in every degenerate case.
An empty coordinate makes a joint PMF impossible. Sparse laws and null
conditioning fibers require no full support. Nothing asserts pointwise
continuity of `condFstGivenSnd` or gives a null-fiber fallback probabilistic
meaning. Reverse conditional orientation is an external swap consumer,
not a second public theorem. RV forms are external applications to common
finite-valued joint pushforwards over arbitrary source spaces; do not
require the original sample spaces to be finite.

### 3.4 Ownership and public/private boundary

Proposed new supported owner: `LeanInfoTheory.Shannon.Continuity`, namespace
`LeanInfoTheory.Shannon`. Its justified direct imports are exactly
`Probability.Coupling` and `Shannon.Fano`. Fano already reaches binary entropy,
entropy bounds and semantic nonnegativity. Do not import Examples, Pinsker,
Gluing, the full Shannon umbrella or a new general measure layer into it.
Do not move existing supported declarations or enlarge lower-level imports.

The proposed public family comprises one scalar definition, its monotonicity
theorem, and four inequalities: exact entropy, budget entropy, budget
conditional entropy and budget MI. Suggested names are
`abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log`,
`entropyContinuityBound`, `entropyContinuityBound_mono`,
`abs_entropy_sub_le_entropyContinuityBound`,
`abs_condEntropy_sub_le_entropyContinuityBound`, and
`abs_mutualInfo_sub_le_entropyContinuityBound`.
Final spelling receives the ordinary naming review; names are not permission
to alter these contracts or publish extra families. Record genuine awkwardness
under Note 14 and deduplicated search friction in downstream API feedback.

Keep decoder/event bridges, both signed orientations, the q-ary rewriting
bridge, scalar arithmetic, swap forms, RV wrappers and consumer constructors
private. Future Work Note 29's q-ary helper trigger was inspected: C14 may
normalize the `m >= 2` branch locally and consume existing Fano directly.
This plan does not promote Fano's private all-cardinality bridge or require
a public change to `Shannon.BinaryEntropy`. Reassess only on actual reuse
pressure; public API expansion still needs justification/review.

Add the new focused owner to the full `LeanInfoTheory.Shannon` umbrella while
retaining its historical direct imports. Keep `LeanInfoTheory.lean` importing
exactly `Probability.Finite` and `InformationMeasures`, with its five-module
local closure, unchanged root exports and reviewed simp set. No new global
simp attributes, aliases, instances or notation are planned.
Record deliberate growth in `docs/compatibility/current-api-policy.json`;
generated inventory is not approval. New consumers live in private
`Examples.Continuity`, importing only the focused owner, and join only the
non-stable Examples aggregate. Preserve all existing consumers.

### 3.5 Proposed Lean declaration contracts

The declaration headers below fix binder order, implicit budget parameters,
independent universes and casts for the six proposed declarations in
`LeanInfoTheory.Shannon`, with `universe u v`. The definition body records the
piecewise convention. The theorem headers intentionally omit proofs: these
are planning contracts, not declarations already implemented or compiled.
Names retain Section 3.4's ordinary naming-review allowance.

```text
noncomputable def entropyContinuityBound (m : Nat) (epsilon : Real) : Real :=
  if m <= 1 then 0
  else if epsilon <= 1 - 1 / (m : Real) then
    Real.binEntropy epsilon + epsilon * Real.log ((m - 1 : Nat) : Real)
  else Real.log (m : Real)

theorem abs_entropy_sub_le_binEntropy_add_totalVariation_mul_log
    {alpha : Type u} [Fintype alpha] (p q : PMF alpha) :
    |entropy p - entropy q| <=
      Real.binEntropy (PMF.totalVariation p q) +
        PMF.totalVariation p q *
          Real.log ((Fintype.card alpha - 1 : Nat) : Real)

theorem entropyContinuityBound_mono (m : Nat) :
    MonotoneOn (entropyContinuityBound m) (Set.Ici (0 : Real))

theorem abs_entropy_sub_le_entropyContinuityBound
    {alpha : Type u} [Fintype alpha] (p q : PMF alpha)
    {epsilon : Real} (hTV : PMF.totalVariation p q <= epsilon) :
    |entropy p - entropy q| <=
      entropyContinuityBound (Fintype.card alpha) epsilon

theorem abs_condEntropy_sub_le_entropyContinuityBound
    {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (p q : PMF (alpha × beta))
    {epsilon : Real} (hTV : PMF.totalVariation p q <= epsilon) :
    |condEntropy p - condEntropy q| <=
      entropyContinuityBound (Fintype.card alpha * Fintype.card beta) epsilon +
        entropyContinuityBound (Fintype.card beta) epsilon

theorem abs_mutualInfo_sub_le_entropyContinuityBound
    {alpha : Type u} {beta : Type v} [Fintype alpha] [Fintype beta]
    (p q : PMF (alpha × beta))
    {epsilon : Real} (hTV : PMF.totalVariation p q <= epsilon) :
    |mutualInfo p - mutualInfo q| <=
      entropyContinuityBound (Fintype.card alpha) epsilon +
        entropyContinuityBound (Fintype.card beta) epsilon +
          entropyContinuityBound (Fintype.card alpha * Fintype.card beta) epsilon
```

The order above groups contracts for reading; it does not change the step
order. C14.01 adds only the exact inequality; C14.02 adds the scalar definition,
monotonicity and entropy-budget theorem; C14.03 adds the two joint-law bounds.

## 4. Steps and independently assessable criteria

All criteria below are required. Evidence must identify actual source,
commands/results and limitations. Each step includes the common duties in
Section 5 and its selected-step independent review, reconciliation and
supported private closure. A successful probe is not completion evidence.

### C14.01 — Exact-distance entropy continuity

**Dependencies:** verified C10/C11 interfaces and existing Fano/entropy algebra.
Implement Section 3.1 in the new owner, with the Section 3.4 import boundary,
full-umbrella/policy integration and initial private consumer module.
Use the actual maximal witness and its swap, both exact decoder errors and
both entropy-difference orientations. Public scope is the one exact bound;
all coupling-to-Fano glue stays private.

**Permanent consumers:** both law orders, zero TV, equal laws, singleton and
empty alphabets; distinct pure binary laws at TV one; and the following concrete
nonbinary pair, which also supplies a law with zero masses. On `Fin 3`, compare
the point mass at zero with the uniform law: establish TV `2/3`, entropy gap
`log 3`, and `h(2/3) + (2/3) * log 2 = log 3`. This exercises the nonzero
alphabet-size term and can be reused for the budget threshold in C14.02.
Consumers apply the public theorem, not its private proof. Retain the
pure-versus-fair binary case with entropy gap `log 2` and TV `1/2`.

- **C14.01-EXACT:** The exact nats/half-L1 absolute entropy inequality has the
  Sections 3.1/3.5 signature and semantics, with both orientations established from
  actual coupling marginals, exact disagreement and Fano. Evidence: owner proof,
  elaborated signature/axioms and focused warning-as-error compilation.
- **C14.01-DEGENERACY:** Permanent public-API consumers prove zero-distance,
  singleton/impossible-empty, sparse and maximal-distance behavior, including
  the binary half-distance gap and the concrete ternary threshold equality
  with nonzero logarithmic term. Evidence: consumer source, exact masses/TV/
  entropy claims and successful compilation.
- **C14.01-BOUNDARY:** The new owner and aggregates follow Section 3.4; historical
  signatures/import closures, root/simp boundaries and dependency pins are
  preserved. Evidence: explicit reviewed policy, current manifest/generator
  checks, focused aggregate and compiled compatibility/trust checks.

### C14.02 — Capped scalar bound and entropy budgets

**Dependencies:** C14.01; pinned q-ary entropy monotonicity and existing entropy
range. In the same owner implement the scalar definition, public monotonicity
and upper-budget entropy theorem from Section 3.2. Derive nonemptiness locally;
private scalar computations and normalization do not enlarge the public API.

**Permanent consumers:** exact threshold agreement and both branches; epsilon
zero, one and greater than one; singleton zero; the binary pure/fair threshold
example; the C14.01 ternary pair with `B_3(2/3) = log 3`, explicitly checking
agreement of the raw expression and logarithmic cap at equality; and a binary
counterexample to unrestricted substitution (a pair at
TV `1/2` satisfies TV `<= 1` but its entropy gap is positive while `h(1)=0`).
Also apply the public budget theorem after an actual common-channel or
noninjective-map TV contraction, with output alphabet size controlling entropy.
Add a private generic budget-weakening consumer: from `TV(p,q) <= epsilon`
and `epsilon <= eta`, first obtain the bound at epsilon and then apply the
public `entropyContinuityBound_mono` theorem to obtain the bound at eta.
Exercise strict threshold crossing at `m = 3`, `epsilon = 1/2`, `eta = 3/4`,
with explicit `B_3(1/2) = (3/2) * log 2` and `B_3(3/4) = log 3`.
The actual marginal-law instance in C14.03 reuses this consumer; C14.02 does
not depend on those later joint-law constructions.

- **C14.02-MODULUS:** The total scalar definition and public monotonicity theorem
  have precisely Section 3.2's cardinal, epsilon-domain, threshold and endpoint
  conventions. Evidence: scalar proofs, exact elaborated contracts and checks
  of zero, threshold equality, saturation, nonnegativity and the logarithmic cap.
- **C14.02-BUDGET:** TV bounded by any nonnegative real epsilon implies the
  advertised entropy bound, without full support, extra nonemptiness or an
  epsilon upper restriction. Evidence: proof of the small/large budget branches
  and an external contraction-to-entropy consumer compiled from focused imports.
- **C14.02-ENDPOINTS:** Permanent consumers establish threshold, maximal-budget,
  epsilon-greater-than-one and singleton behavior and refute unrestricted
  substitution into the raw expression. They explicitly evaluate the ternary
  threshold and apply public monotonicity to weaken a budget across it.
  Evidence: exact Lean propositions and warning-as-error compilation, not
  numerical sampling alone.

### C14.03 — Joint-law conditional entropy, MI and approximation consumers

**Dependencies:** C14.02, both C10 marginal contractions, and the actual
`condEntropy_eq`/`mutualInfo_eq` identities. Implement exactly the two public
bounds in Sections 3.3/3.5 in the same owner. Reconcile the joint cardinality
with the natural product `m*n`; the particular rewrite is advisory proof
guidance. Keep triangle-inequality and projection helpers private. No additional
conditional-PMF machinery or support hypothesis enters.

**Permanent consumers:** one generic finite-joint-law approximation consumer
uses the public results to control joint entropy, conditional entropy and MI
from the same epsilon budget, with explicit `m`, `n`, `m*n` constants. Reuse
three private laws on `Bool × Fin 3`: the diagonal fair law `D` on
`(false,0)` and `(true,1)`; the independent law `I` assigning `1/4` to each
of the four atoms with second coordinate zero or one; and the point mass `P`
at `(false,0)`. The second-coordinate value two has zero mass in all three.

- Compare `D` and `I`: joint TV is `1/2`, their marginals agree, and their
  joint-entropy, conditional-entropy and MI gaps are each `log 2`. This supplies
  the null-fiber consumer and a nonzero MI difference.
- Compare `P` and `I`: joint TV is `3/4`, both marginal TVs are `1/2`, joint
  entropy gap is `2 * log 2`, both marginal entropy gaps are `log 2`, and the
  conditional-entropy gap is `log 2`. Both MIs are zero. This exercises strict
  contraction in both projections and nonzero changes in each entropy term.
- At the common budget `3/4`, prove the scalar evaluations
  `B_2(3/4) = log 2`, `B_3(3/4) = log 3`, and
  `B_6(3/4) = h(3/4) + (3/4) * log 5`. The marginal caps have saturated;
  the joint branch has not, since its threshold is `5/6`. Apply the public
  joint/conditional/MI bounds with these explicit ambient-cardinality constants.
  Final loose inequalities alone do not replace the scalar branch checks.
- Use the second marginals of `P` and `I` to instantiate C14.02's public-
  monotonicity consumer, weakening their actual TV budget from `1/2` to `3/4`
  across the size-three threshold `2/3`.

Prove these masses, distances and information values rather than assuming
them. Shared private constructors/calculations may serve multiple checks;
no general sharpness theorem or additional public wrapper is required.
Also check both singleton-coordinate reductions, zero distance, empty-coordinate
impossibility, swapped conditioning orientation, and an RV application via
finite-valued joint pushforwards over arbitrary source types. RV wrappers
remain private consumers.

- **C14.03-DERIVED:** Conditional entropy and MI satisfy exactly Section 3.3's
  sums of capped bounds, with independently universe-polymorphic finite
  alphabets, both marginal contractions and correct coordinate orientation.
  Evidence: elaborated signatures, entropy-identity derivations and successful
  focused compilation; no exact-distance expression is substituted at a mere
  marginal upper estimate without the cap argument.
- **C14.03-CONSUMER:** The generic approximation, both sparse joint comparisons,
  changing marginals, mixed threshold branches, concrete budget weakening,
  singleton, zero-distance, empty, swap and arbitrary-source RV consumers
  meaningfully use the public API and explicit constants. Evidence: actual laws,
  established joint/marginal TV and information values, explicit scalar branch
  evaluations, consumer proofs and warning-as-error compilation.
- **C14.03-API:** Every new public declaration has a useful documented consumer;
  helper/alias/attribute and ownership boundaries satisfy Section 3.4. Evidence:
  current inventory/policy, naming audit, generated references, focused/root/full
  umbrella checks, compiled compatibility and project trust audit.

### C14.04 — Cumulative qualification, independent review and handoff

**Dependencies:** actual private completion of C14.01--C14.03 and their reviews,
with exact source applicability. Add no new mathematical scope or public API.
Prepare all canonical and handoff edits before final capture. Reconcile the
living summary, current Lean state, chunk map/roadmap where affected, reference
register, project log, naming/feedback dispositions, API/module guidance and
generated references against source, approved contracts and actual evidence.

Maintain `docs/handoffs/chunk-14.md`, linked from canonical context. It records
delivered contracts/names, imports, consumers, units/cardinality/null-fiber
decisions, source/review/validation references, limitations and every remaining
item's disposition, owner and reopening trigger. C15 requires its own planning
and approval; its qualitative continuity route does not require C14.

- **C14.04-VALIDATION:** The final candidate passes the maintained cumulative
  routine suite in an explicitly authorized clean checkpoint and the real
  two-pass current file-mode API-doc milestone, with new rendered declarations
  inspected. Evidence includes exact commit/source/configuration identity,
  original command results, fresh or explicitly applicable checks after every
  amendment, and the protected historical/root/dependency boundaries. If clean
  checkpoint authority is absent, report this criterion pending; never weaken
  the gate, hide user changes or infer commit authority from plan approval.
- **C14.04-READINESS:** Before dispatch, all owned edits and planned consumers
  are finished, earlier accepted reports/criterion assessments have explicit
  reconciliation, no material obligation remains unresolved, and all twelve
  criteria in this plan are ready for fresh cumulative assessment. Evidence:
  source-stable candidate, earlier review/disposition ledger, validation records
  and retained parent critique/reassessment. This criterion does not require
  the not-yet-delivered cumulative report or final closure.
- **C14.04-HANDOFF:** Canonical documentation and the maintained handoff accurately
  reconcile delivered mathematics, interfaces, original evidence and remaining
  work, without asserting C15 approval or claiming null-fiber continuity.
  Evidence: source/document cross-check and explicit disposition/owner/trigger
  entries for every deferred or unresolved item, with useful next-chunk inputs.

After readiness, request a **fresh independent cumulative review of all twelve
criteria**, including the earlier mathematical steps. Preserve and admit its
original native report, reconcile all findings and original assessments,
perform supported corrections and final validation, assess R-to-F applicability,
and obtain the supported private closure. Reviewer gaps require a new satisfactory
reviewer assessment. Earlier step reviews do not replace the cumulative review.
Keep captured documents provisional until private closure; do not edit them
after F merely to insert a completion reference. Then report and stop.

## 5. Validation and review operations

During each theorem step, run focused owner/consumer/aggregate builds through
`scripts/validate_release.py`, inspect diagnostics and enforce warnings as errors
for new consumer probes where the focused mode does not itself enforce them.
Serialize artifact-producing builds. At minimum affected targets include the new
owner, `Examples.Continuity`, `Examples.CouplingFano`, `LeanInfoTheory.Shannon`,
`LeanInfoTheory.Examples` and the lightweight root. Use the installed validator's
actual target/signature interfaces rather than guessed commands.

Deliberately update reviewed growth policy before regeneration; regenerate the
current API manifest and source-derived website blueprint/index, verify the
frozen manifest without rewriting it, then run non-mutating `static` checks.
Run `trust` for public-surface changes; the installed command includes compiled
`compatibility` checks of retained signatures/imports/root exports/attributes
and the project-wide axiom audit. A separate `compatibility` run is useful for
focused diagnosis but need not duplicate a successful same-source trust run.
Permitted axioms remain only `propext`,
`Classical.choice` and `Quot.sound`. No proof placeholders or native-decision
shortcuts. Documentation checks compile maintained README/website examples as
applicable. Every new project Lean file uses the exact EPFL/MIL header.

Final C14.04 uses the full maintained routine plus the justified API-documentation
milestone because this chunk adds a supported owner/public family. Preserve
the actual two-pass attestation and inspect all new signatures, assumptions,
docstrings, owner links and the full-umbrella page. On Windows use the existing
reviewed Zig 0.16.0 via `LEANINFOTHEORY_ZIG`; do not alter pins. Existing caches
may be used but must be disclosed. Reproduce and retain failures before a
bounded repair; no preemptive cache deletion or reuse of stale body/docstring
attestations. File-mode docs remain local and never replace `/docs/v0.1.0/`.

Private source capture includes actual working bytes of affected owners,
consumers, aggregates, policy/generated artifacts, relevant canonical documents,
validation configuration and explicit pinned source dependencies. It excludes
reference PDFs, build products, disposable scratch and `.lit-review/` itself.
Preserve the unrelated website notes and record any omission from review scope
honestly. The protocol's baseline B, reviewed R and final F stay distinct.
Clean routine gates require authorized clean state, not a manufactured clean
tree containing another task's work. Delete disposable probes before milestone
reports; durable original evidence under `.lit-review/` is never scratch.

The C14 parent is `01a10666-9835-7cc0-9c49-fbeb5068c306`, canonical role `/root`.
Its own reviewer is `/root/c14_reviewer`, bound through the installed explicit
`collaboration` transport. Creation requested `gpt-6-astra`, `ultra`,
`fork_turns="none"`; observable effective settings remain unknown. Retain the
unaltered creation result, actual call and original `list_agents` bootstrap
result under `.lit-review/setup/c14-reviewer-*`, with the successful bind result.
This is cooperative read-only instruction, not OS isolation. Reuse this binding
for explicitly requested plan/step/cumulative reviews; do not replace it with
another chunk's reviewer or a feasibility worker.

`inspect` and `api` were run from this checkout and saved as
`c14-initial-inspect-20261004.json` and `c14-initial-api-20261004.json` under
`.lit-review/setup/`. Revision 1 was submitted in `plan-r1-20261004`; its
original native report and parent dispositions are retained. The actual
file-referencing dispatch did not equal the full rendered request text, so
the adapter refused its receipt (`OBSERVED_SUBMISSION_MESSAGE`) and report
admission (`SUBMISSION_REQUIRED`). No formal completion is claimed, and this
revision does not rewrite or rebind that session's evidence. The lead-supplied
General Assistant report is separately attributed advice, not this binding's
original report. See the notes for review provenance and suggestion decisions.

A formal review of revision 2 requires a fresh explicitly requested `plan-*`
session with the same reviewer, exact current proposal/criterion text, the full
library rubric, original-report retention and explicit reconciliation. Dispatch
must contain the exact rendered request text. Its result still awaits exact
lead approval and authorizes no step. All implementation steps
retain separate self-review critique/reassessment, independent review,
reconciliation and source-bound completion under the installed protocol.

## 6. Evidence, decisions and remaining-work boundary

Evolving proof advice and the dated feasibility ledger live separately in
[C14 planning notes](post-release-chunk-14-notes.md). They are advisory, not
substitutes for the normative contracts or approved completion criteria above.
The notes distinguish source inspection, signature checks, compiling proof
probes and work not yet verified. Mathematical meaning, required scope,
important public contracts, acceptance policy and pins require lead approval
to change; routine proof-route improvements may be recorded with evidence.

The proposal selects an all-finite exact bound consistent with existing Fano,
a named scalar cap valid for every nonnegative real budget, and one focused
owner with six proposed public declarations. These are explicit plan choices
for review/approval, not silently accepted implementation decisions. Remaining
production risks are the concrete sparse/threshold consumer construction,
integration into growth/compiled import gates, and source-bound cumulative
review/validation; disposable proofs do not discharge those obligations.

| Item outside initial scope | Owner and reopening trigger |
| --- | --- |
| Finite-simplex topology, compactness, continuous objectives | C15 owner after its own approved plan; scalar analytic lemmas here create no topology commitment. |
| Sharper conditional constants or support-size refinements | Future continuity/API work after a concrete approximation consumer and explicit scope approval. |
| CMI, RV, reversed-condition or channel convenience wrappers | API maintainer after repeated independent consumer friction; keep present examples private. |
| Public q-ary normalization/helper promotion | Note 29/Note 14 review after proof pressure demonstrates benefit beyond a bounded local rewrite. |
| Equality/optimality classification, local-distance/countable extensions | Separately approved mathematical phase with exact source and assumptions. |
| Coding, capacity or application certificates | Respective later chunk/downstream owner under separate authorization. |
| Doc-gen cache tooling and website tasks | Existing documentation owner and recorded triggers; preserve unrelated website notes. |
| Commit, push, publication, release or dependency upgrade | Project lead's separate explicit authorization; none is supplied here. |

Revision-1 assessments found no blocking mathematical scope issue. Revision 2
adopts the bounded consumer/API clarifications recorded in the notes; it has
not received a fresh formal review or exact approval. A later selected-step
request also remains pending. Planning stops here without executing C14.01.
