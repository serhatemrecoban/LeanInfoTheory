# Chunk 11: Couplings and Maximal Coupling

<!-- lit-review-status:start -->
**Status:** Approved, revision 2; C11.06 selected with review, 2026-09-27.
C11.01--C11.05 and their reviews are complete by their source-bound private
completion records. The conditional step-6 request was selected after verifying
C11.05's closure and exact final source. The exact local checkpoint and necessary C11.06-only amendments were separately
authorized. Initial checkpoint `2147dd3449af620f41d9bed8d37c5be8252f20e8`
passed the clean routine suite and real two-pass current API-doc gate. The
maintained handoff preserves original evidence. Final amended-candidate
validation, fresh all-criterion review, original-report reconciliation and closure
are established by source-bound C11.06 private records. No later chunk, push or
publication is selected. The lead authorizes reasoned in-scope adjustments while preserving
mathematical goals, compatibility and review duties.
Revision 1's original reviewer report and evidence-field admission failure remain
preserved; revision 2 was approved by the lead, without a separate formal
plan-review acceptance claim. C10 is complete by its actual private record.
<!-- lit-review-status:end -->

## 1. Authority and endpoint

This plan refines [C11 in the chunk map](post-release-chunk-map.md#c11-couplings-and-maximal-coupling).
The lead must approve this exact revision and explicitly request one step before
implementation. A formal plan review requires its own request. After approval,
perform only the requested step with its applicable review process and stop.
Approval of this plan does not authorize a commit, push, deployment, another
step, or another chunk.

The required endpoint is a usable joint PMF with prescribed coordinate laws,
plus an actual maximal-coupling witness whose disagreement probability equals
the existing `PMF.totalVariation`. Existence only as an abstract infimum is
insufficient. The API must support different coordinate types for ordinary
couplings and a common finite alphabet for TV and maximal coupling.

Required work comprises:

- A thin law-level coupling interface, independent existence, diagonal coupling
  and coordinate-swap symmetry.
- The coupling inequality for every supplied coupling on a common finite alphabet.
- An actual PMF-valued construction with exact marginals and exact disagreement,
  including equal laws, disjoint supports, zero/full overlap and singleton laws.
- A minimal-import construction consumer and a separately importing information
  consumer that passes the constructed witness to the existing Fano API.
- Compatible API growth, generated references, trust/build checks, independent
  cumulative review, canonical reconciliation and a maintained C11 handoff.

Transport by general coordinate maps, lifting through coupling channels, gluing,
composition, transport costs, categories and process coupling belong to C12 or
later work. Entropy-difference/conditional-entropy/MI continuity belongs to C14.
Pinsker, topology, countable/general-measure maximal coupling, uniqueness of the
chosen maximal law, randomized decoding and Fano equality classifications are
outside C11. No new probability representation or dependency upgrade is planned.

During planning, edit only this draft and permitted private records or ignored
disposable probes. Do not edit production Lean, standing policies, generated
website artifacts, canonical status or publication state.

## 2. Verified intake and evidence

### 2.1 Checkout and completed prerequisite

The actual checkout is `C:\Users\coban\Desktop\Lean Info Theory`, not the
desktop task's initial working directory. Intake HEAD is
`37b4ba90d1ab321645f80cacef475f10a3a6ba43`; Git was clean before planning.
`.lit-review/setup/c10-07-completion-20260921.json` identifies this exact HEAD,
`SUPERVISED_STEP_COMPLETE`, all seven C10 steps complete, 19 cumulative criteria,
and closure `62b6db6329b7d7d3ece8e34b59d9e9253df575d13fd298b3c90bfe8a4e139e34`.
Its production acceptance is a supervised project-step record, not a claim of
mathematical certification. No intervening checkout change needs to be attributed
to C10. The [C10 handoff](../handoffs/chunk-10.md) deliberately delegates final
closure to this private record; its provisional chronology does not reopen C10.

Source and maintained documents were checked together: `AGENTS.md`, the living
summary's Quick Start and relevant conventions, coverage, architecture, active
work, future-work and validation sections; the map's C11/C12/C14 contracts; the
C10 handoff and targeted C10.03/C10.06/C10.07 log entries; references; both review
documents; current/frozen API policy and API-documentation instructions.
Relevant standing Notes 9 and 14--18, 26 and 29 remain guardrails or deferred
work. Historical target lists inside old log entries do not override today's
validator. No current mathematical contradiction was found in this intake.

Observed baseline:

| Item | Current identity or boundary |
| --- | --- |
| Lean | `v4.33.1` |
| mathlib | Clean pinned `0df444a360eaa60ab8c11dca51a86af692955474` |
| doc-gen4 | Pinned `e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015` |
| Current supported API | 628 documented declarations, 32 owners |
| Historical v0.1.0 API | 601 declarations; immutable release `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f` |
| Attributes and facade | 94 reviewed simp declarations, 92 root aliases |
| Lightweight root | Exactly five local modules; direct imports `Probability.Finite` and `InformationMeasures` |
| C10 TV owner | 25 public declarations; private examples are evidence, not exported helpers |

These counts are observations, not quotas. C10's successful validation belongs to
its captured source. It does not certify future C11 changes.

### 2.2 Exact mathematical sources

The local hashes of all three PDFs match [the reference register](../references.md).
Read only the relevant local sections and summarize the mathematics; do not
commit PDFs, copied proof text or rendered pages. No external information-theory
formalization repository was consulted.

| Source and exact location | Contract and adaptation |
| --- | --- |
| SA13, arXiv `1209.5259v5`, Section I; Theorem 1 and equations (3)--(9), PDF/printed pp. 2--3; Theorem 2 and (10), p. 3 | Maximal agreement is the common minimum mass; disagreement equals half-L1 TV. C11 selects finite PMFs from the paper's discrete scope. Natural logarithms matter only to the separate Fano consumer. |
| LP17, second edition, Section 4.2; Proposition 4.7, Remark 4.8, equations (4.8)--(4.13), printed pp. 50--52 / PDF pp. 66--68; section introduction printed p. 49 / PDF p. 65 | The coupling inequality and an attained optimum, with the law-level and random-variable descriptions reconciled. The displayed infimum is attained by the supplied construction. |
| PW24, August 16, 2024 draft, Section 7.3, Theorem 7.7(b), (7.20), printed p. 122 / PDF p. 147; proof printed p. 123 / PDF p. 148 | A minimum disagreement over couplings. The overlap normalization is (7.3), printed p. 116 / PDF p. 141. General measurable-diagonal conditions are unnecessary for the selected finite PMF event interface. |

SA13's "maximal" agreement and LP17's "optimal" disagreement name the same
contract. All three use probability-normalized TV in `[0,1]`. Their normalized
mixture presentations leave unused zero-denominator components informal; Lean
must explicitly handle the endpoint cases. C10 already records the ambiguous
directional prose in PW24 part (a); its displayed equations settle that issue.
No new inconsistency was found in the selected coupling statements.

### 2.3 Source inspection and reuse

Search the pinned dependency, not a remembered upstream API. Planning searches
of mathlib's probability/measure sources found no suitable PMF coupling object;
the sole unrelated measure-source occurrence concerned a bilinear pairing.
Project source and its current declaration index likewise contain no existing
coupling interface. This supports the thin local predicate below; repeat the
name/search check before introducing it.

Verified reuse:

- `PMF.channelJoint p (fun _ => q)` is the independent product already available
  in `Probability.FiniteChannel`. Its `channelJoint_apply`,
  `channelJoint_map_fst` and `channelJoint_map_snd` laws are generic in both types
  and universes. There is no need for a second independent-product definition.
- `PMF.map_comp`, `PMF.map_id`, `PMF.bind_const`, PMF extensionality and finite
  map/sum identities provide the elementary coupling laws.
- Pinned `PMF.normalize` accepts a nonzero, non-top total and its
  `normalize_apply` gives mass times inverse total; `PMF.ofFintype` accepts a
  finite unit-mass function. Both were exercised in the interior probe.
- C10's `sum_min_eq_ofReal_one_sub_totalVariation`,
  `ofReal_totalVariation_eq_sum_sub`, `totalVariation_comm`,
  `totalVariation_eq_zero_iff`, `totalVariation_eq_one_iff_disjoint_support`,
  `toOuterMeasure_toReal_eq_sum`, range and event theorems supply the TV side.
- The private consumers in `Examples.TotalVariation` establish both residual
  totals, nonzero/non-top premises, residual-minus-min reconciliation and sparse
  examples. They do not export a normalized residual PMF or maximal witness.
- `Shannon.indepProd` in `Shannon.SemanticBridge.Product` has the same bind/map
  expression as the constant `channelJoint`. It also supplies measure-product
  semantics. Preserve its released owner, signature and definition.
- `Shannon.decodingErrorProbability` takes a source/observation joint law in
  that order and a decoder from observation to source. `condEntropy_fano`
  requires finite coordinate alphabets, with no lower cardinality bound. Its
  exact formula uses `Real.log ((Fintype.card alpha - 1 : Nat) : Real)`.

### 2.4 Planning probes and their limits

Two small ignored Lean probes compiled with warnings treated as errors. The
planning investigation agent ran them; the parent inspected the preserved source
and result records. Original source, commands and outcomes are under
`.lit-review/setup/c11-planning-feasibility-*`.

| Actual probe | Observed result and scope |
| --- | --- |
| `lake env lean -j1 -DwarningAsError=true tmp/c11-planning/feasibility-interior.lean` | Exit 0, empty output. Generic independent/diagonal/swap laws; normalized common and residual PMFs; interior recombination; positive-TV matrix row and column totals; an actual `ofFintype` joint with both exact pushforward marginals; diagonal atom equal to the common minimum. Source SHA-256 `c8938990931538f974893075086d52142d0724d138d378e02b95121290e1fffa`. |
| `lake env lean -j1 -DwarningAsError=true tmp/c11-planning/feasibility-fano.lean` | Exit 0, empty output. Constant-channel equality with `indepProd` by `rfl`, definitional marginal compatibility, identity-decoder error equal to the chosen disagreement event, and Fano specialization given exact disagreement=TV. Source SHA-256 `828634e6d1198dc0c03c1f7966985bb4fd95f07c92df89a73df1d29fa3845982`. |

The interior probe uses a private normalized right residual, equivalently the
matrix formula in Section 3.3, and proves the difficult generic normalization
and marginal obligations. It does not prove the coupling inequality, final
off-diagonal event equality, total branch assembly or permanent witness/Fano
consumer. The Fano probe assumes the exact-event premise; its later replacement
by the actual producer's theorem remains mandatory in C11.05. Product-measure
compatibility is source-verified here and remains a compiling consumer duty.

Initial probe attempts encountered slow loading and corrected binder, rewrite
argument and finite-sum orientation errors; they are not successful evidence.
A concurrent unrelated Lean probe was observed and left untouched. Successful
probe source/results were retained before removing the two disposable Lean files.
That initial planning investigation changed no production Lean and performed no
formal review.

The parent also ran `python scripts/validate_release.py static`: exit 0. Current
generation matched on both passes, policy and source trust checks passed, website
checks and all 34 checker tests passed, and diff/scratch checks passed. This
checks the unchanged production baseline alongside the draft; it is not the
clean routine suite, compiled compatibility or the separate API-doc milestone.
Source inspection confirms the proposed probability owner's current local
dependency union is exactly Finite, FiniteChannel and TotalVariation, with no
local Shannon module. Draft checks found six step IDs, 17 unique criteria,
valid local link targets and no trailing whitespace.

### 2.5 Revision 1 review evidence and revision 2 decisions

Revision 1 had SHA-256
`ead4941a3351eaac75a196bc33765df8273ce53e6f08d31b03b3d765d3b1c260`.
The bound reviewer returned one material finding about the circular cumulative
review criterion and judged the other 16 criteria adequate as planning
requirements. Its fresh interface probe passed after a failed scratch attempt;
neither outcome establishes the future maximal-coupling implementation.
The unchanged original report, failed admission and parent dispositions are
preserved under `.lit-review/setup/c11-plan-review-*`. The parser required a
string for `inspected_source`, while the original report supplied lists; formal
report acceptance and workflow reconciliation were not completed. No original
report or session was rewritten to manufacture acceptance.

The lead also supplied a General Assistant advisory report recommending separate
public-interface and constructor checks, a strictly non-maximal coupling example,
and Fano in both coordinate orders. Its stated reference checks and successful
interior-probe rerun are attributed to that report, not fresh parent validation.
It does not replace the bound reviewer or authorize implementation. Section 7
records the selected changes and the optional suggestion deferred by this revision.

## 3. Proposed design and mathematical contracts

### 3.1 Representation and ownership

Use a predicate in namespace `PMF`, over the existing joint law:

```lean
universe u v

def PMF.IsCoupling {alpha : Type u} {beta : Type v}
    (joint : PMF (alpha × beta))
    (p : PMF alpha) (q : PMF beta) : Prop :=
  joint.map Prod.fst = p ∧ joint.map Prod.snd = q
```

The signature is a proposal, not an existing declaration. `alpha` and `beta`
have independent universes. No finiteness, `Nonempty`, decidable equality or
measurable-space instance belongs to this predicate. Its joint-first argument
order makes supplied-law evidence and later C12 projection use direct. The two
conjuncts expose exact marginals; do not duplicate them merely to add accessors.

An investigated alternative is a bundled structure carrying a PMF and two
proofs. It adds coercion/projection and API-inventory obligations without a
current consumer need: both C12 and Fano consume a raw joint PMF. An upstream
object would take priority if a suitable one is found. The proposed choice is
the predicate, with ordinary existential statements and a PMF-valued maximal
constructor. No second law or random-variable representation is introduced.

One new supported owner is proposed:
`LeanInfoTheory.Probability.Coupling`, directly importing
`LeanInfoTheory.Probability.FiniteChannel` and
`LeanInfoTheory.Probability.TotalVariation`. The latter already supplies the
scalar tactic dependencies. All generic, finite inequality and maximal-witness
facts live here. A split is not required by the current dependency boundary.
No Shannon, entropy, Product, measure-product, KL, Markov, example or kernel
back-import is permitted. Existing transitive PMF measure foundations are not
a claim that mathlib's entire closure is measure-free.

The full `LeanInfoTheory.Shannon` umbrella adds the new owner. The lightweight
root and every retained focused owner keep their imports. No new facade aliases,
instances or global simp attributes are proposed. Add a new-module approval and
update the single applicable full-umbrella approval with the exact resulting
imports, rationale, consumer and actual approval reference during C11.01.
Never create duplicate/unused approval records or treat generation as approval.

### 3.2 Proposed public surface

Names below are proposed choices for exact plan approval. Binder elaboration
and declaration discovery must be checked during C11.01; a substantive public
contract change needs lead approval. Pure proof rearrangements remain advisory.

| Proposed declaration | Required meaning |
| --- | --- |
| `PMF.IsCoupling` | Joint-first predicate above, generic independent coordinate types. |
| `PMF.isCoupling_channelJoint_const` | `IsCoupling (channelJoint p (fun _ => q)) p q`. |
| `PMF.exists_isCoupling` | For supplied `p` and `q`, `∃ joint, IsCoupling joint p q`, with the independent construction used as witness. |
| `PMF.isCoupling_map_diag` | `IsCoupling (p.map (fun a => (a,a))) p p`. |
| `PMF.IsCoupling.map_swap` | From `IsCoupling joint p q`, obtain `IsCoupling (joint.map Prod.swap) q p`. |
| `PMF.IsCoupling.totalVariation_le` | For `[Fintype alpha]` and a common-alphabet coupling, `totalVariation p q ≤ (joint.toOuterMeasure {z \| z.1 ≠ z.2}).toReal`. |
| `PMF.maximalCoupling` | `[Fintype alpha] → PMF alpha → PMF alpha → PMF (alpha × alpha)`, a noncomputable ordinary PMF. |
| `PMF.isCoupling_maximalCoupling` | Both exact marginals of that actual constructed PMF, unconditionally for supplied finite PMFs. |
| `PMF.maximalCoupling_toOuterMeasure_ne` | `(maximalCoupling p q).toOuterMeasure {z \| z.1 ≠ z.2} = ENNReal.ofReal (totalVariation p q)`. |
| `PMF.maximalCoupling_toOuterMeasure_ne_toReal` | Real-valued version of the same equality, with right side `totalVariation p q`. |

The table is a bounded initial surface, not a declaration-count target. All
declarations need mathematical docstrings and explicit source/orientation notes
where relevant. Marginal projection wrappers, a bundled maximality predicate,
named diagonal/independent constructors, an agreement-probability definition,
an infimum API and convenience aliases are optional and currently excluded.
The permanent consumer must demonstrate optimality by combining the actual
witness equality with the inequality for any competing coupling. No uniqueness
claim or preservation of maximality under later composition is intended.

Use the existing `toOuterMeasure` event vocabulary. Do not define another
`disagreementProbability` merely to shorten statements. The common-alphabet
event is ordered `z.1 ≠ z.2`. Fano with the identity decoder tests `z.2 ≠ z.1`;
the semantic consumer must prove the symmetry reconciliation explicitly.

### 3.3 Construction and Real/ENNReal boundary

Write `delta := PMF.totalVariation p q : Real` and
`d := ENNReal.ofReal delta`. For proof advice, write

```text
m a := min (p a) (q a)
r a := p a - q a
s a := q a - p a
```

Here subtraction is ENNReal truncated subtraction. `tsub_min` reconciles this
with removal of common mass. C10 gives `sum m = ofReal (1-delta)`,
`sum r = d` and, by symmetry, `sum s = d`. Atom masses and all these totals
are finite. For positive delta, `d ≠ 0`; `d ≠ top` follows from `ofReal`.
Do not use Real subtraction identities as ENNReal identities without their
order/finiteness guards.

The preferred construction uses two cases:

1. **Full overlap, delta = 0:** use `p.map (fun a => (a,a))`; C10 separation
   proves `p=q`. No residual normalization or fallback inhabitant occurs.
2. **Positive distance, 0 < delta <= 1:** construct with `PMF.ofFintype` from
   the matrix

   `K(a,b) = (if a=b then m a else 0) + r a * s b / d`.

The row sum must be `m a + r a = p a`; the column sum must be
`m b + s b = q b`. The reverse residual total requires TV symmetry.
Cancel only the nonzero finite denominator. Sum the row identity for unit
total mass, then prove the two `PMF.map` equalities for the resulting law.
At each atom one of `r a`, `s a` is zero, so the residual product contributes
no diagonal mass. Hence agreement is the common mass and disagreement is `d`.

**Zero overlap remains an explicit proof obligation.** When delta=1, C10's
overlap identity makes every `m a` zero, hence `r a = p a` and `s a = q a`.
Since `d=1`, the matrix becomes `p a * q b`. Prove that the actual selected PMF
equals `channelJoint p (fun _ => q)` by extensionality and `channelJoint_apply`.
Use C10's disjoint-support characterization to establish zero diagonal mass and
disagreement one. Marginals and maximality alone do not determine the independent
law for disjoint supports. The generic constructor equality is required and may
remain private; distinct pure-law examples do not replace it. This equality is
a future implementation obligation, not a result of the preserved planning probe.

This is the algebraically flattened form of the sources' mixture. Normalized
residual laws `r/d` and `s/d`, and the normalized common law `m/ofReal(1-delta)`,
are useful feasibility probes. The selected production formula need not define
all three: it avoids dividing by overlap altogether. Such auxiliary machinery
stays private/local unless a concrete maintained consumer justifies promotion.
The successful positive-TV probe already covers normalization and both marginals
without a delta<1 premise. A separate delta=1 computational branch is permitted
if it simplifies the proof; the selected endpoint laws, interior matrix and all
consumer obligations remain fixed. Record that proof-organization choice in the
step notes without adding public assumptions or changing the required identities.

Derive the ENNReal event equality before converting its finite value to Real.
Use `ENNReal.toReal_ofReal` with TV nonnegativity. A proof of an ENNReal equality
must not rely on `toReal` injectivity without excluding `top`. PMF event masses
are at most one; retain that guard when subtracting or taking complements.

### 3.4 Coupling inequality

For an arbitrary supplied coupling, its diagonal atom is bounded by each
marginal atom, hence by their minimum. Summing and using C10's overlap formula
bounds agreement by `1-TV`, which bounds disagreement below by TV. Finite
projection-sum and diagonal/complement identities may be private shared helpers.
An attained-event/indicator proof using C10 is an acceptable alternative if it
simplifies the formalization without changing the public statement.

No support inclusion, full-support, positivity or cardinality lower bound is
allowed. The coupling predicate remains generic; only contracts mentioning the
existing finite `totalVariation` use `[Fintype alpha]`. Avoid adding `[Finite]`
wrappers around the existing `[Fintype]` TV API without a consumer. Local
classical decidability is sufficient for diagonal tests and finite filtering.

### 3.5 Degenerate laws and consumers

Public-interface consumers and private constructor checks serve distinct duties.
The former use the declared public surface to check marginals, disagreement,
optimality and interoperability. The latter may unfold the selected construction
and use its local helpers to verify which law and atom masses it returns. Keep
constructor-specific equalities and pointwise checks private in
`Probability.Coupling`, where the normalization machinery is available; they
require no additional module, public computation lemma or global simp rule.
Both kinds of check must compile, with their ownership recorded below.

| Case | Required check |
| --- | --- |
| Equal laws / delta=0 / full overlap | Public consumer: both marginals and zero disagreement. Private constructor proof: actual law equals the diagonal map. |
| Disjoint supports / delta=1 / zero overlap | Public consumer: both marginals and disagreement one, including distinct pure Bool laws. Private generic constructor proof: actual law equals the independent `channelJoint`. |
| Sparse interior | Ternary laws `(1/2,1/2,0)` and `(0,1/2,1/2)`. Public consumer: ordered marginals and disagreement `1/2`. Private pointwise checks: common diagonal mass at the middle atom and residual mass from first to last atom, each `1/2`. |
| Unequal Boolean laws | Interior parameter choices and reversed order; marginal orientation cannot pass by accidental symmetry. |
| Strictly non-maximal coupling | For the fair Bool law `p`, public-interface examples show TV(p,p)=0 and disagreement `1/2` for `channelJoint p (fun _ => p)`, compared with zero for the diagonal coupling. Apply the universal inequality and establish strictness. |
| Singleton / subsingleton | Supplied laws coincide; TV and actual disagreement are zero, without a cardinality premise. |
| Empty alphabet | No PMF exists (`PMF.support_nonempty` suffices); universal theorems remain valid without a global inhabitant or fabricated fallback law. |
| Different coordinate types/universes | Independent coupling and swap compile for different types; no common-alphabet assumption leaks into generic contracts. |

Permanent consumer owners are proposed as follows:

- `LeanInfoTheory.Examples.Coupling` imports only `Probability.Coupling`.
  Its private examples use the public producer, both marginals and exact event
  formulas, and include the strict fair-Bool comparison. They do not unfold the
  maximal constructor or its private normalization machinery. Constructor-specific
  identities and atom checks reside in the probability owner as specified above.
- `LeanInfoTheory.Examples.CouplingFano` directly imports `Probability.Coupling`,
  `Shannon.Fano` and `Shannon.SemanticBridge.Product`. All helpers remain private.
  It proves the constant-channel law equals `Shannon.indepProd`, uses the
  existing rectangle/product-measure bridge under its own exact measurable-space
  assumptions, identifies identity-decoder error with the disagreement event,
  and applies `condEntropy_fano` to `joint := maximalCoupling p q` and to
  `joint.map Prod.swap`. Use `IsCoupling.map_swap` for the reversed marginals and
  prove disagreement-event transport under swap. Both identity-decoder errors
  must equal `totalVariation p q`, giving the existing bounds in both conditional
  entropy orientations. Consume the same witness's two marginals, and include
  equal-law and singleton specializations. Equality between the swapped witness
  and `maximalCoupling q p` is not required.

The Fano outputs are the existing conditional-entropy bounds for the constructed
joint law in both coordinate orders. Do not derive an entropy-difference or
continuity theorem. The product and measure checks certify interoperability,
not a new general coupling-to-measure theory. A public Fano bridge is optional
only after concrete reuse pressure and
API review; C14 can request it separately if the private consumer reveals a need.
Both example owners join only `LeanInfoTheory.Examples`, never a mathematical
umbrella.

## 4. Implementation steps and completion criteria

Requirements in Sections 1, 3, 5 and 6 apply to every step. Each step has an
independent stop point. Evidence consists of actual source, appropriate builds,
consumer use and the applicable supervised review records; a favorable discussion
does not close a criterion. The numbered criteria below are normative anchors
for later workflow contracts. They are requirements, not current PASS claims.

### C11.01 — Coupling interface and elementary witnesses

**Contract.** Introduce the proposed predicate, independent witness/existence,
diagonal coupling and swap theorem from Section 3.2. Preserve arbitrary alphabets
and independent universes. Empty types are handled through the supplied laws,
with no extra typeclass premise.

**Ownership and dependencies.** Add `Probability.Coupling` with the two planned
direct imports, its full-umbrella import, actual reviewed growth-policy records,
and the minimal consumer. Use `FiniteChannel` projection laws and existing
map/bind identities. Do not move or change `indepProd` or existing marginal APIs.

**Consumers.** Generic different-type independent laws, diagonal projections,
swap twice through `PMF.map`, and an empty-alphabet impossibility example.

**Validation.** Focused warning-as-error owner/consumer/full-umbrella/root builds;
current generators and static checks; fresh standalone compiled compatibility
because a supported owner/import approval is added. Check all names, docstrings,
exact imports and absence of new global attributes.

- **C11.01-MATH:** The generic interface and all elementary witnesses have the
  exact Section 3.2 contracts, with no unnecessary finite/nonempty/measurable premise.
- **C11.01-BOUNDARY:** The new owner and umbrella addition have actual approved
  policy records; retained declarations/imports, root closure, aliases and simp
  behavior pass source and compiled compatibility checks.
- **C11.01-CONSUMER:** The separately compiled minimal consumer exercises both
  ordered marginals, different types, diagonal and swap without semantic imports.

### C11.02 — Coupling inequality

**Contract.** Prove `IsCoupling.totalVariation_le` for every finite common-alphabet
coupling, using the existing TV and event definitions. Include equality in the
diagonal case and distance-one lower bounds for disjoint laws.

**Ownership and dependencies.** Extend only the low-level owner and minimal
consumer, depending on C11.01 and C10 overlap/event facts. Projection-sum,
diagonal-mass and complement machinery remain private unless separately justified.

**Consumers.** Apply the inequality to the elementary witnesses and an arbitrary
coupling hypothesis. Use asymmetric laws and both marginal directions. Check
subsingleton and pure/disjoint cases without stronger assumptions. For identical
fair Bool marginals, prove the independent coupling has disagreement `1/2` while
TV and the diagonal coupling's disagreement are zero; explicitly exhibit strict
inequality for the independent coupling. Keep these examples private.

**Validation.** Focused owner/consumer/full-umbrella builds, generated/static
checks, assumption and finite-event conversion audit; retain exact axiom evidence
for the new theorem under the existing trust policy.

- **C11.02-MATH:** Every supplied coupling bounds TV by its Real disagreement
  probability with coefficient one and no support/positivity/cardinality restriction.
- **C11.02-CONSUMER:** Public-API consumers establish correct event orientation
  and endpoint behavior, including the strict fair-Bool independent-versus-diagonal
  comparison; Real/ENNReal proof conversions exclude `top` where needed.

### C11.03 — Construct the attaining candidate and exact marginals

**Contract.** Define the actual `maximalCoupling` PMF using Section 3.3's
zero/positive-TV construction, prove positive-case normalization and both exact
pushforward marginals, and expose `isCoupling_maximalCoupling`. Prove the selected
constructor equals the diagonal law at TV=0 and the independent law at TV=1.
The name anticipates the proof of exact disagreement in C11.04; this step alone
does not claim maximality is delivered. The permitted separate TV=1 branch is
an internal proof-organization choice with the same required identities.

**Ownership and dependencies.** Extend the same probability owner. Depend on
C11.01 and C10's overlap/residual totals; C11.02 remains the completed ordered
predecessor. Keep residual PMFs, mass functions and cancellation helpers private.
Use `PMF.ofFintype`, not a parallel law representation or an entropy import.

**Consumers.** Instantiate the actual producer with generic laws and consume
both marginal equalities in the minimal-import example owner, including equal,
disjoint and sparse ternary laws and reversed marginals. In the probability
owner, prove the generic positive-case row and column identities and the actual
diagonal/independent constructor equalities privately. Check the sparse ternary
atom masses there using the construction. Numeric checks supplement the generic
normalization and marginal proofs.

**Validation.** Focused owner/consumer/full-umbrella builds, generated/static
checks, exact atom/marginal and denominator audit, trust evidence for constructor
dependencies. Verify no placeholder and no public nonzero-denominator hypothesis.

- **C11.03-NORMALIZATION:** The actual positive-TV matrix defines a unit-mass PMF;
  both residual totals and every cancellation/finiteness premise are established,
  including at TV=1 without assuming TV<1.
- **C11.03-MARGINALS:** The constructed law has exactly first marginal `p` and
  second marginal `q` in all cases, with only `[Fintype alpha]` and supplied PMFs.
- **C11.03-ENDPOINTS:** Private generic proofs identify the actual constructor
  with the diagonal/independent laws at full/zero overlap, and private sparse
  pointwise checks verify the chosen matrix. Public-interface consumers cover
  sparse interior, singleton and empty-type cases without a fallback inhabitant.

### C11.04 — Exact disagreement and maximality

**Contract.** Prove the ENNReal and Real disagreement formulas of Section 3.2
for the actual C11.03 producer. Establish vanishing residual diagonal mass,
common-mass agreement and event complements throughout the positive case.
Retain explicit independent-support and diagonal arguments for zero/full overlap,
using the constructor identities proved in C11.03 where useful.

**Ownership and dependencies.** Low-level owner and minimal consumer, depending
on C11.02--C11.03. No optimization abstraction or uniqueness theorem is needed.
Agreement/pointwise computation facts can remain private.

**Consumers.** Derive that this witness has no greater disagreement than any
competing coupling through the public API. Complete the full Section 3.5 edge
matrix under its stated ownership split. The minimal consumer checks the actual
sparse witness's marginals and disagreement `1/2`; private constructor checks in
the probability owner establish its specified nontrivial off-diagonal atom mass.

**Validation.** Focused builds, generation/static, guarded-conversion audit,
fresh compiled compatibility and full trust; inspect actual public theorem
statements and the constructor's proof dependencies.

- **C11.04-EXACT:** The actual witness's disagreement is exactly `ofReal TV` in
  ENNReal and exactly TV in Real for every supplied finite pair of laws.
- **C11.04-ATTAINMENT:** A minimal-import consumer combines exact marginals,
  exact disagreement and the universal inequality to prove attained optimality.
- **C11.04-EDGES:** Equal, disjoint, zero/full overlap, sparse interior,
  singleton/subsingleton and empty-alphabet situations are checked without
  positivity, full-support or inhabitance assumptions on the public API;
  public-interface examples and private constructor checks meet their separate
  Section 3.5 obligations.

### C11.05 — Fano interoperability and integrated API readiness

**Contract.** Add the separate semantic consumer in Section 3.5. The actual
constructed joint law and its coordinate swap must each enter the existing Fano
theorem with identity decoder and exact error `totalVariation p q`. Demonstrate
the independent-product equality and measure interoperability using existing
Product semantics. Audit the complete public surface, private-helper boundary
and downstream readiness.

**Ownership and dependencies.** `Examples.CouplingFano` imports the three focused
owners specified above and is included by `Examples`. C11.01--C11.04 are complete.
No heavy import is added to `Probability.Coupling`, TV, FiniteChannel or the root.
No change to Fano/Product contracts or C14 continuity theorem is included.

**Consumers.** Both exact marginals, `IsCoupling.map_swap`, disagreement-event
transport and identity-decoder orientation, generic Fano bounds with error TV
in both coordinate orders, equal laws and singleton alphabets. Use the same
actual witness and its swap; do not require equality with a separately chosen
`maximalCoupling q p`. Use
`channelJoint = indepProd` to reuse a measure rectangle theorem with its actual
measurability premises; these stay confined to the consumer.

**Validation.** Focused compilation of both consumer owners, Fano, Product,
Examples, Shannon and root; generated/static, documentation and full trust gates.
Audit every new public declaration for a meaningful producer/consumer use and
searchable naming. Record actionable repeated naming friction under Note 14 and
the feedback register only if found; avoid speculative aliases.

- **C11.05-FANO:** A separately compiled consumer applies existing Fano to the
  actual maximal witness and its coordinate swap with decoding error exactly
  `totalVariation p q` in both orientations, using the swap theorem and ordered
  marginals and including equal-law and singleton cases. The consumer stays
  within the existing Fano bounds on the same witness in both coordinate orders.
- **C11.05-INTEROP:** Independent existence reuses constant `channelJoint` and
  interoperates with existing `indepProd`/measure semantics in the separate consumer.
- **C11.05-API:** The complete surface, helper visibility, naming, assumptions,
  imports, documentation and consumer coverage pass integrated review and gates;
  there are no unnecessary aliases, instances or global simp additions.

### C11.06 — Cumulative validation, fresh review and maintained handoff

**Contract.** Independently assess every criterion in this plan on the cumulative
candidate. Complete the clean routine suite and separate current two-pass API-doc
milestone, reconcile canonical context and remaining work, and maintain
`docs/handoffs/chunk-11.md`. Earlier step reviews do not replace this fresh review.

**Ownership and dependencies.** All earlier C11 steps and their applicable
reviews are complete. Finish current API/source-generated references and relevant
living summary, project log, current Lean state, roadmap/map, README/reference/API
guidance and handoff changes as dictated by their actual content. Do not edit
unrelated historical prose or frozen normative requirements. See Section 5 for
checkpoint authority and Section 6 for capture/closure sequencing.

**Consumers and validation.** Recheck both focused consumers and the complete
approved edge matrix; run cumulative compatibility, exact-import/attribute/root
audits, all-project trust, example, generated-document/site and hygiene gates.
Obtain fresh independent assessments of all 17 criterion rows in this section,
including these three criteria for readiness at closeout. They are
assessed on the cumulative review candidate; the mandatory duties after receipt
of that fresh report are listed separately below.

- **C11.06-VALIDATION:** Fresh source-bound cumulative evidence establishes all
  C11.01--C11.05 criteria; the complete clean routine suite and actual current
  two-pass API-doc gate pass on the authorized cumulative review candidate.
- **C11.06-INDEPENDENCE:** The candidate is ready for a fresh independent
  full-chunk assessment of every approved criterion, with earlier required
  reviews explicitly reconciled, no unresolved material concern or earlier
  reviewer criterion gap, complete original evidence and exact source
  applicability disclosed.
- **C11.06-HANDOFF:** Canonical documents and the maintained C11 handoff accurately
  record delivered contracts/imports/consumers, evidence and limits, C12/C14
  prerequisites, and all remaining-work owners/triggers before final capture.

**Mandatory subsequent postconditions.** Obtain the fresh bound cumulative
report against all 17 criteria and explicitly reconcile every original finding
and criterion assessment, including a clean report. Complete corrections and
renew review for material changes or reviewer criterion gaps. Repeat the full
routine suite after every authorized amendment; reuse API-doc evidence only
when its exact source/configuration inputs and attestation remain applicable,
otherwise rerun the real two-pass gate. Establish final validation and review
applicability, finish required canonical/handoff edits, capture exact F and
complete the supported private closure. These duties remain required after the
readiness assessment; a favorable report alone does not complete C11.06.

## 5. Validation, compatibility and documentation gates

Serialize artifact-producing Lean builds. Before every step, check Git status,
pins, current plan and predecessor source applicability; preserve concurrent and
unrelated changes. The current validator, not historical target lists, controls
maintained gates. New project Lean files use the exact EPFL/MIL header.

During dirty implementation use the maintained focused command with the touched
owners/consumers and important aggregates:

```powershell
python scripts/validate_release.py focused <targets>
```

After approved API/import changes, deliberately update only current artifacts:

```powershell
python scripts/generate_current_public_api.py
python scripts/generate_v0_1_public_api.py --check
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/validate_release.py static
```

Run `compatibility` when specified above and at import/API milestones; `trust`
includes fresh compatibility and the all-project axiom audit. Run `documentation`
when release-facing documentation/examples change and at integrated closeout.
Preserve the frozen manifest, all 601 retained signatures and owners, the
released root/import/attribute contract, dependency pins, legal metadata and
historical website route. New imports require actual reviewed growth records;
inventory generation alone is insufficient. No compatibility-policy mechanism
or validator redesign is part of this chunk.

The trust gate permits only `propext`, `Classical.choice` and `Quot.sound` and
the standing source restrictions. Compiler success alone does not prove the
intended coupling, marginal orientation or event convention: the consumers and
source review supply those checks. Public names/types alone do not certify
unchanged bodies or meanings.

**Clean-checkpoint boundary.** `python scripts/validate_release.py` and `hygiene`
require a clean committed tree. Plan/step approval does not authorize a commit.
At C11.06, prepare the exact source/document candidate and reviewable scoped diff
first; if no separate checkpoint authority exists, request it then and report the
clean gate pending. Do not weaken hygiene, commit unrelated work or claim chunk
completion while a required clean gate is unavailable. Repeat the routine suite
after an authorized amendment and reassess all reused evidence.

**Separate API-documentation milestone.** C11 adds a supported module, so C11.06
requires the real two-pass `python scripts/validate_release.py api-docs` gate.
On Windows use the reviewed Zig 0.16.0 executable through `LEANINFOTHEORY_ZIG`.
Use local `DOCGEN_SRC=file`; GitHub source links require a clean exact commit.
Check actual new-module pages, signatures, docstrings, ownership and coverage
against the new current manifest, and retain v2 source/configuration attestation.
Inspect current docs directly in `docbuild/.lake/build/doc/`; do not stage them
as the historical v0.1.0 route or publish.

C10's first API-doc attempt regenerated module `docInfo` but reused the aggregate
HTML marker and omitted the TV page. Its semantic checker correctly failed.
The documented recovery invalidated only the ignored
`doc-data/LeanInfoTheory.Shannon--module.docs_built` marker and `.hash`/`.trace`
sidecars, then reran the complete two-pass gate. Carry this observation into
assessment of C11's new module. Do not preemptively delete caches, rewrite
tooling or infer success from a Lake exit alone. Preserve any actual failure,
diagnose current evidence, and make any necessary bounded recovery concrete.

## 6. Review workflow and final capture

`python -B tools/lit_review/cli.py inspect` and `api` succeeded in the actual
checkout. Original saved outputs are
`.lit-review/setup/c11-planning-inspect-20260926.json` and
`.lit-review/setup/c11-planning-api-20260926.json`.
The actual originating task is `01a0de32-1d31-7740-a3f7-b262c5e65f40`, role `/root`.
It created and bound its own persistent reviewer `/root/c11_reviewer` using the
installed explicit `collaboration` transport, with requested `gpt-6-astra`,
`ultra`, `fork_turns="none"`. Creation returned only the canonical `task_name`;
no agent ID or submission ID was invented. Observable effective parent/reviewer
settings remain unknown. Read-only instructions are cooperative, not OS isolation.

The binding is `.lit-review/chunks/C11/binding.json`. The exact creation call,
unchanged native result, bootstrap list result and user planning instruction are
retained in `.lit-review/setup/c11-native-*` and
`.lit-review/setup/c11-planning-bind-20260926.json`.
The bootstrap acknowledgment established readiness only, and no C10 binding
was reused. Revision 1's later review history and admission limitation are
recorded in Section 2.5; that report does not assess this revised source.

When the lead requests formal plan review, open a fresh `plan-<local-id>` session
for the exact full-file plan hash. Use `plan_review_request`, retain INTENT before
native dispatch, then SUBMISSION and the original REPORT, explicit
`reconcile_plan_review` and `plan_review_result`. Use the bound reviewer via
`collaboration.followup_task`; an idle reviewer is not started by `send_message`.
Extract a report only from an actual matching `collaboration.list_agents` completed
entry and retain the entire native result and exact call. Unknown settings stay
unknown. Formal review awaits exact lead approval and authorizes no implementation.
Review of a revised plan uses a fresh explicitly requested session and retains
all earlier originals and dispositions. Verify the installed report-field types
before dispatch, including the string-valued `inspected_source` evidence field;
never rewrite a received report or relax the parser to manufacture acceptance.

For each approved requested step follow [the protocol](../review-protocol.md)
and [operations](../review-operations.md): verify the actual message's target and
predecessor before `next`; capture B before edits; retain owned before/after
images, initial validation, read-only self-review and separate reassessment;
freeze R and inspect the neutral request/rubric; retain dispatch and native
delivery evidence; reconcile every original report and every criterion, even
with no findings. A reviewer gap needs a new satisfactory reviewer assessment.
Do not replace missing reviewer capability with a silently substituted reviewer.

Capture scope must explicitly include the owning source, examples, umbrella,
relevant existing TV/Finite/FiniteChannel and Fano/Product dependency closure,
current policy/manifest/generated inputs, applicable canonical documents and
the exact referenced pinned declarations. The adapter does not infer imports.
Record configuration/dependency identities through its supported mechanisms.
Private `.lit-review`, scratch, build output and reference media remain outside
source capture. Keep one workflow writer and preserve original failures.

At C11.06, finish canonical/handoff edits before F with provisional closure
wording. Review the complete criteria and record dispositions, perform required
corrections with supported operations, validate final inputs and assess R-to-F
applicability. Material change requires renewed review. Then finalize documents,
prepare F and use supported private closure. Do not edit captured files after F
to insert a closure reference. Report the actual private completion record to
the lead, start no later step/chunk, and preserve durable review records.

## 7. Plan health, optional work and decisions

The mathematical requirements and approved public contracts are frozen after
exact approval. Evolving proof advice belongs in separately captured step notes;
the reserved status region is editorial only. No criterion can be weakened by
calling a change advisory.

| Trigger | Disposition |
| --- | --- |
| A suitable pinned upstream coupling object is found | Investigate against all consumer and import contracts; seek approval for a material representation change. |
| Interior construction cannot be completed with the planned API/assumptions | Retain failed evidence and reassess the proof route; normalization helpers may stay private. Stronger public assumptions, weaker endpoints or scope expansion require the lead. |
| A bundled structure, public helper, new module split or semantic bridge seems necessary | Demonstrate the concrete consumer pressure and import/API impact before promotion; review material contract changes with the lead. |
| New direct tactic/import requirement | Prefer existing dependencies; record actual imports and the applicable reviewed policy decision, without silently changing retained boundaries. |
| Fano needs orientation/representation rewrites | Resolve them in the separate consumer; keep raw marginals and exact event theorem as the C14 contract. Do not prove continuity. |
| New-module HTML output is stale or absent | Retain the failure, compare with C10's cache observation, and diagnose bounded recovery; no automatic cache deletion or tooling programme. |
| Concurrent source, dependency or plan edits invalidate evidence | Preserve those changes, recapture/revalidate through supported operations and report applicability gaps. Do not silently reuse an earlier PASS. |
| Clean-suite authority or required reviewer capability is unavailable | Complete independent authorized preparation, state the exact pending gate and request only the needed concrete decision. Do not claim closure. |

Optional improvements currently excluded are public normalized residual/overlap
constructors, a public `IsMaximalCoupling`, infimum/IsLeast packaging, convenient
projection aliases, new simp rules and a general semantic coupling bridge.
Record a demonstrated need and its owner/trigger rather than adding them for
appearance. C12 receives joint laws and exact coordinate marginals; C14 receives
the actual witness, event equality and a working separate Fano consumer. Neither
chunk is planned in detail or selected for execution here.

### Revision 2 suggestion dispositions

| Suggestion | Decision and reason |
| --- | --- |
| Separate cumulative-review readiness from later reconciliation | Adopted in C11.06. This removes the circular criterion while preserving fresh review, all-report reconciliation, correction, validation and closure duties. The textual correction does not itself supply a fresh reviewer assessment. |
| Separate public-interface consumers from constructor-specific checks | Adopted in Section 3.5 and C11.03--C11.04. Private owner proofs/checks may inspect the construction; focused example consumers use the public contracts. No computation API is added solely for testing. |
| Include a strictly non-maximal coupling | Adopted in C11.02: identical fair Bool marginals with independent disagreement `1/2` versus diagonal disagreement zero. It exercises strictness using the existing elementary witnesses. |
| Apply Fano in both coordinate orders | Adopted in C11.05 on the same witness and its swap. It exercises the swap theorem and event orientation within the existing Fano scope. |
| Simplify the constructor's case split | Adopted as the preferred zero/positive-TV definition. The probe already supports the positive case; the generic TV=1 independent-law equality remains an explicit proof duty. A separate TV=1 computational branch remains an allowed internal choice. |
| Require a four-symbol interior example with two residual atoms on each side | Deferred as optional. Generic normalization/marginal/event proofs, the sparse interior checks, strict Boolean comparison and swapped Fano consumer form the required coverage. Add a private four-symbol check if implementation exposes a concrete residual-product coverage gap; it must not force public computation lemmas. |
| Clarify evidence after amendments and keep review chronology accurate | Adopted in C11.06 and the status/history sections. The routine suite must be rerun after an authorized amendment; API-doc reuse requires exact applicability. Historical review evidence is explicitly tied to revision 1. |

The lead's immediate decision is whether to approve this exact draft (or first
request a fresh formal plan review), including the predicate, one focused
probability owner, explicit endpoint identities, the consumer/check split and
Fano in both coordinate orders. A local checkpoint decision is deferred until
C11.06 has a concrete candidate to approve.
