# Chunk 19: Self-information, finite-iid AEP, and weak typical sets

<!-- lit-review-status:start -->
**Status:** Approved revision 2, 2026-10-18. The lead accepted this plan and
initially selected C19.01 with its review process. Current selected-step and
closure status are recorded in the living summary and private completion records;
this approval history does not select another step.
Approval permits evidence-based in-scope adjustments with
recorded reasons; it does not require following advisory proof choices blindly.
The lead authorized this revision after reading two advisory reviews. The
existing C19 reviewer found no substantive defect in revision 1; its report
remains advisory because the dispatched request contained a hash transcription
error. The user also supplied the General Assistant's independent suggestions.
Revision 2 has no separate formal plan-review acceptance. The
[companion notes](post-release-chunk-19-notes.md) record the
selected suggestions, deferred alternatives, original evidence and limitations.
This region records status only.
<!-- lit-review-status:end -->

## 1. Authority and scope

Deliver a finite-iid asymptotic equipartition property (AEP) and usable weak
typical sets for arbitrary finite PMFs. Canonical information is Real-valued
and measured in nats. The AEP is a numerical probability limit over varying
finite word spaces. Entropy additivity alone does not satisfy it.

Work in `C:\Users\coban\Desktop\Lean Info Theory`. Implementation requires
approval of this exact plan and an explicit request selecting one step. Each
authorized step follows the installed review process and stops after its own
closure. A plan-review request separately authorizes a proposal review, not
implementation. Preserve existing unrelated work and completed predecessor
closures. This proposal authorizes no commit, push, deployment, tag or release.

Excluded: source-code objects and coding theorems, capacity/channel converses,
entropy rates, stationary/ergodic or infinite-trajectory constructions, strong
typicality, method of types, exponential convergence rates, dependency upgrades,
review-tool changes, external formalization repositories and other chunks.
C20/C21 own operational source coding; C22/C23 own capacity and channel
converses. A second release remains deferred until C24 and separate authorization.

The scope, mathematical contracts, ownership, step criteria and gates in
sections 1 and 3--8, together with the reuse obligations in section 2.1, form
the proposed normative contract. Section 2's baseline and source-audit facts
are historical evidence. Text explicitly marked advisory is not a requirement.
Evolving proof advice, artifact/cache observations and evidence live in the
companion notes; conditional requirements apply only to their selected route.
Proof-route changes preserving the approved contracts need an evidenced notes
entry; changes to mathematical meaning, hypotheses, required scope, public
contracts, acceptance policy or dependency pins require the lead.

## 2. Verified baseline and source anchors

Intake HEAD is `aaaa6e7befe246832743b5df1716f9e26954a482`.
The four pre-existing modified paths are `.gitignore`, `AGENTS.md`,
`docs/next-website-tasks.md` and `docs/project-log.md`. Their intake bytes are
privately hashed. They must not be staged, reverted or absorbed into a checkpoint
without specific authority for the relevant changes.

C18 is complete through C18.06 by
`.lit-review/setup/c18-06-completion-20261018.json` and its source-bound records,
not by its provisional captured prose. Fresh C19 intake checks matched all 258
captured real-file entries, 601 bound evidence files, Git/configuration/dependency
fields and the original accepted report hash. All six closures are present, no
step is active and all twenty cumulative criteria are SATISFIED. The final closure
is `91e22d904cbfec9935ef91b961398374fd1945a8d43aa3e6329d6bbe31eea34d`.
C16/C17 completion records and relevant handoffs were also inspected. Historical
qualification wording does not reopen those chunks. These are applicability
checks, not a newly executed complete validation suite.

Lean/mathlib remain v4.33.1; mathlib resolves to
`0df444a360eaa60ab8c11dca51a86af692955474`. All nine root dependencies match
their pins and are clean at intake. Current inventory is 713 supported
declarations in 45 owners; the root exports 92 names and the reviewed simp set
contains 94 names. Counts are baseline facts, not growth targets.

Read the exact registered editions in [references](../references.md):

| Source | Exact mathematical anchor | C19 adaptation |
| --- | --- | --- |
| CT91, 1991 edition, section 3.1 | Theorems 3.1.1--3.1.2, equations (3.2)--(3.16), printed 51--53 / PDF 73--75 | Finite iid convergence, weak typicality, atom and counting bounds; natural logarithms and exponentials replace bits and powers of two. |
| CT91, section 3.2 | Theorem 3.2.1, (3.17)--(3.23), printed 53--55 / PDF 75--77 | Read for context only: variable-length expected description length is not the selected fixed-length coding model. |
| CT91, section 3.3 | Theorem 3.3.1, (3.24)--(3.30), printed 55--56 / PDF 77--78; relevant Exercise 7 outline (3.34)--(3.38), printed 58 / PDF 80 | High-probability-set counting motivates the later converse; no general minimal-set or coding API is required here. |
| PW24, August 16, 2024 draft, section 11.2 | Proposition 11.6, equation (11.2) and complete proof, printed 217--218 / PDF 242--243 | Finite PMFs, supported weak typicality and probability/cardinality estimates. Its coding consequence stays with C20/C21. |

PW24 is not PW22 or the published 2025 edition. PW24's displayed closed
typicality convention and a strict inequality in its proof must not be copied
inconsistently. C19 chooses strict normalized deviation below epsilon and the
complementary weak deviation inequality at least epsilon. The exported mass
bounds below are non-strict consequences. Textbook files and substantial source
text must not be committed.

### 2.1 Reuse obligations

| Existing owner | Reuse anchor and assumptions |
| --- | --- |
| `Shannon.SemanticBridge.Entropy` | Existing `selfInfo`, `selfInfo_of_toReal_eq_zero`, `selfInfo_of_toReal_ne_zero`, `toReal_mul_selfInfo`; `entropy_eq_integral_selfInfo` requires `Fintype`, a measurable space and measurable singletons. Do not redefine self-information or entropy. |
| `Probability.FiniteProduct`, `Probability.Iid` | `PMF.finiteProduct_apply`, `PMF.mem_support_finiteProduct_iff`, `PMF.finiteProduct_map_eval`, `PMF.finiteProduct_map_pair`, pure/empty laws and thin `PMF.iid`. No separate word or iid-law representation. |
| `Shannon.SemanticBridge.FiniteProduct`, `Independence` | `isIndependentOf_finiteProduct_eval`, `isIndependentOf_iff_indepFun`, `entropy_iid`; the private `Examples.FiniteProductSemantics.coordinate_indepFun` already demonstrates coordinate measure-independence. |
| Pinned PMF `Basic`, `Integrals` | Finset event sums, support-intersection invariance, measure/outer-measure equality, `toMeasure_map` and `integral_eq_sum`; actual finiteness before ENNReal-to-Real conversion. |
| Pinned `Probability.Moments.Variance`, if using Chebyshev | Reuse `IndepFun.variance_sum`, `variance_map`, `variance_const_mul`, `meas_ge_le_variance_div_sq`; square-integrability and composition measurability must actually be proved. |
| Existing `Probability.TotalVariation` | `PMF.toOuterMeasure_toReal_eq_sum` is already public. Do not invent a duplicate general event-sum theorem. |

Source searches include current inventory/index and permanent consumers. Every
new public theorem must have a genuine consumer; incidental integral, variance,
measurability, coercion and log helpers stay private unless separately justified.

The early C19.01 checkpoint must first obtain/build the artifacts needed by the
selected route at unchanged pins and then compile the connected proof specified
in section 5. Declaration checks alone do not satisfy this checkpoint.

**Feasibility evidence, not a completed gate:** planning is source-audited; no
connected analytic proof has successfully compiled. Earlier bounded probes
encountered missing pinned artifacts or were stopped without output. The notes
retain the exact attempts and limits. This does not establish an implementation
defect in the completed baseline, which does not import the new analytic owner.

## 3. Mathematical contracts

### 3.1 Common notation and event probabilities

Let `{A : Type u} [Fintype A]`, `p : PMF A`, `n : Nat`, and `epsilon : Real`.
Use words `Fin n -> A`, `q_n := PMF.iid p n`, `H := entropy p`, and
`L_n(x) := selfInfo q_n x`. Write `r_n(x) := (q_n x).toReal`.

For a set `E` of words, `P_n(E)` means `(q_n.toOuterMeasure E).toReal`.
This is notation in the plan, not a new public probability abstraction.
For a finset `T`, coerce it explicitly to a set when forming its probability:

```text
P_n(T) = sum_{x in T} (q_n x).toReal.
```

Under a local discrete measurable structure this also equals
`(q_n.toMeasure E).toReal`. Atom and event masses are finite and at most one;
establish finiteness before using `ENNReal.toReal_sum`, order conversions or
complement subtraction. Public finite-PMF endpoints should require no measurable
instances, `DecidableEq`, full support or extra nonemptiness. Semantic private
lemmas may use measurable-singleton hypotheses; a discrete instance can be
chosen locally in the measure proof.

### 3.2 Supported block self-information

For every `n`, including zero:

```text
x in q_n.support -> L_n(x) = sum_{i : Fin n} selfInfo p (x i).
```

The corresponding almost-everywhere identity is available internally when
using measures. There is no unrestricted ambient-word additivity theorem.
The supplied base PMF is still required at `n=0`; no `PMF Empty` is fabricated.

A permanent counterexample uses the sparse ternary law `(1/2, 1/2, 0)` and
word `(0,2)`: the block self-information is zero while the coordinate sum is
`log 2 > 0`. The supported word `(0,1)` obeys additivity. This regression must
prove the actual mismatch, not merely check that the impossible mass is zero.

### 3.3 Genuine finite-iid AEP

For every finite PMF `p` and every `epsilon > 0`, prove:

```text
Tendsto
  (fun n : Nat => P_n({x | epsilon <= abs(L_n(x) / (n : Real) - H)}))
  atTop (nhds 0).
```

These are real numbers on varying finite block spaces. No common infinite
sample space is required. The total Real expression at zero makes a total
sequence; all normalized finite-block estimates require `0 < n`. A finite
initial value has no effect on the limit. Do not replace `>= epsilon` by a
different event without proving the required implication or equivalence.

The selected proof must establish the connected finite probability/integrability
checkpoint in C19.01 before the concentration and limit argument in C19.02.
Write the finite centered second moment as

```text
V_p := sum_a (p a).toReal * (selfInfo p a - H)^2.
```

This is notation for internal contracts and concrete consumers, not a new public
variance definition. It is finite and nonnegative, including zero for deterministic
sources. The Chebyshev route must identify it with the measure-theoretic variance
under the locally chosen discrete measurable structure.

**Advisory route:** prefer Chebyshev's bound
`P_n(D_{n,epsilon}) <= V_p / ((n : Real) * epsilon^2)` for `n > 0` and
`epsilon > 0`, followed by a scalar limit and squeeze. The notes contain its
proof outline and alternatives. The bound is private proof machinery, not an
additional public endpoint. A justified alternative with the same AEP contract
and no extra assumptions may be recorded in the notes. Its C19.01 checkpoint
must discharge the actual finite-law, support, measurability and integrability
interface required by the selected concentration/LLN theorem before C19.02.
Changing the AEP contract needs lead approval.

### 3.4 Support-aware weak typical sets

Define one noncomputable finite set, proposed name `weakTypicalSet p n epsilon`:

```text
T_{n,epsilon} = univ.filter (fun x =>
  0 < n and x in q_n.support and abs(L_n(x) / (n : Real) - H) < epsilon).
```

This explicitly chooses `T_{0,epsilon} = empty`. For positive blocklength,
membership is exactly support plus strict normalized typicality. Nonpositive
widths give an empty set. These conventions must be documented and tested.
No total-log or total-division convention may admit an impossible word.

For `n > 0`, let `D_{n,epsilon}` be the deviation event in section 3.3. Prove
or derive for permanent consumers:

```text
P_n(T_{n,epsilon}^c) = P_n(D_{n,epsilon}) = 1 - P_n(T_{n,epsilon}).
```

The first equality is of probabilities: the ambient sets can differ outside
support. No claim of literal set equality is permitted. Consequently, for
`epsilon > 0`, `P_n(T_{n,epsilon}) -> 1` and its complement probability tends
to zero. Expose one probability-to-one theorem; derive the complement form
in the downstream consumer unless a public wrapper has concrete justification.

For `x in T_{n,epsilon}` (membership itself supplies `n > 0` and
`epsilon > 0`, so the atom-bound API need not repeat these arguments):

```text
exp (-(n : Real) * (H + epsilon)) <= r_n(x)
r_n(x) <= exp (-(n : Real) * (H - epsilon)).
```

The strict event yields stronger strict inequalities, but the specified weak
bounds are sufficient. Do not require `epsilon < H` or `H > 0`.

### 3.5 Cardinality contracts

For every `n : Nat`, every `epsilon : Real`, and
`a_n := P_n(T_{n,epsilon})`, prove both without positivity premises:

```text
(T_{n,epsilon}.card : Real) <= exp ((n : Real) * (H + epsilon))
a_n * exp ((n : Real) * (H - epsilon)) <= (T_{n,epsilon}.card : Real).
```

At zero length or nonpositive width, the set, its probability and its cardinality
are zero, so both bounds remain valid. The membership-based atom bounds also
permit a uniform finite-sum proof. Positive blocklength remains required for
the normalized moment identities, and positive width for the AEP limit.

The lower bound retains the actual probability factor. Typicality does not
guarantee nonempty sets at every positive length. A permanent derived consumer
must prove, for every `epsilon > 0` and independent `delta > 0`, that eventually
`(1-delta) * exp ((n : Real) * (H-epsilon)) <= (T_{n,epsilon}.card : Real)`.
Do not identify epsilon with delta or require `delta < 1`. No asymptotic
equivalence of cardinalities or exponent-rate theorem is required.

### 3.6 Edge cases and assumptions

All endpoints allow zero-probability symbols. For deterministic sources and
positive length/width, the typical set is exactly the singleton supported word,
its probability is one and deviation probability is zero. Test this on an
ambient alphabet containing impossible words, as well as a singleton alphabet.
Length one is checked against the original PMF via existing coordinate laws.
Length zero has mass one on the empty word and block self-information zero,
but the chosen typical set is empty. No normalized positive-length claim is
applied there. An empty alphabet has no supplied PMF; existing general empty
product constructions are not a substitute for that missing source law.

### 3.7 One nonuniform source for moment and strict-boundary consumers

Use a private binary source `p_*` with masses `p_*(0)=1/3` and `p_*(1)=2/3`.
With `ell := log 2 > 0`, check the exact finite identities

```text
H(p_*) = log 3 - (2/3) * ell
abs(selfInfo p_* 0 - H(p_*)) = (2/3) * ell
abs(selfInfo p_* 1 - H(p_*)) = (1/3) * ell
V_{p_*} = (2/9) * ell^2 > 0.
```

The public AEP consumer uses this source in addition to the sparse and
deterministic cases. If using Chebyshev, a permanent private check in the AEP
owner, where the moment helpers are in scope, proves under the locally chosen
discrete structure:

```text
variance (fun x => selfInfo (PMF.iid p_* 2) x / 2) (PMF.iid p_* 2).toMeasure
  = (1/9) * ell^2
0 < (1/9) * ell^2.
```

It must exercise the actual block observable and its support/AE connection,
not merely simplify `V_{p_*}/2` arithmetically. No public variance API is added.

At `n=1` and `epsilon=ell/3 > 0`, prove that `weakTypicalSet p_* 1 epsilon`
is empty and its probability is zero: the common symbol is exactly on the
excluded boundary and the rare symbol is farther away. This exercises the
public membership theorem and demonstrates why a positive-length lower
cardinality bound cannot drop its probability factor. With the same source and
length, also check `epsilon=2*ell/3`: the typical set consists exactly of the
common word and has probability `2/3`, while the rare word is on the excluded
boundary. The same deviation calculations thus exercise both empty and
nonempty strict bands. These are required future Lean checks, not claims of
newly compiled results.

## 4. Ownership, imports and proposed public surface

Use two new supported focused owners in namespace `LeanInfoTheory.Shannon`:

| Proposed owner | Responsibility and direct-import design |
| --- | --- |
| `Shannon.TypicalSet` | Finite typical-set definition, membership, atom and cardinality bounds. Imports existing `SemanticBridge.Entropy`, `Probability.Iid` and only needed focused finite-set/logarithm facts. It does not import AEP, the semantic aggregate or new concentration/limit modules. |
| `Shannon.SemanticBridge.AEP` | Supported iid block identity, numerical AEP and typical-probability convergence. Imports existing `SemanticBridge.Entropy`, `SemanticBridge.FiniteProduct`, and the new `TypicalSet` owner once C19.03 introduces it; use only the focused mathlib additions needed by the selected route. |

This table describes the final dependency direction: AEP imports TypicalSet,
never the reverse. C19.01--C19.02 use only AEP's existing-source dependencies;
C19.03 adds TypicalSet and its AEP import without an earlier placeholder module.
Finite typical-set users thereby avoid the new concentration dependencies.
This does not make TypicalSet measure-free: the existing self-information owner
already imports PMF integrals.

The semantic aggregate imports AEP; the complete Shannon umbrella imports
TypicalSet. The lightweight root, all probability constructors, retained v0.1
types and frozen manifest remain unchanged. Neither probability owner imports
Shannon/measure-information proofs. Do not extend the existing elementary
information-measures layer with variance or limits.

Proposed discoverable public names are listed below; the contracts above govern
their mathematical content. Avoid aliases and unreviewed simp attributes.

| Proposed declaration | Owner | Contract |
| --- | --- | --- |
| `selfInfo_iid_of_mem_support` | AEP | Section 3.2 supported identity, all lengths. |
| `tendsto_selfInfo_iid_deviation` | AEP | Section 3.3 exact real-probability AEP. |
| `weakTypicalSet` | TypicalSet | Section 3.4 finite set with explicit positive-length guard. |
| `mem_weakTypicalSet` | TypicalSet | Exact membership characterization, retaining all three guards. |
| `weakTypicalSet_mass_bounds` | TypicalSet | Both per-word exponential inequalities as one conjunction. |
| `tendsto_prob_weakTypicalSet` | AEP | Real event probability tends to one for positive width. |
| `card_weakTypicalSet_le` | TypicalSet | Upper real-cast cardinality bound for every length and width. |
| `prob_mul_exp_le_card_weakTypicalSet` | TypicalSet | Probability-weighted lower cardinality bound for every length and width. |

`Examples.TypicalSet` imports the focused finite owner and exercises its finite
contracts without AEP. `Examples.AEP` imports the focused AEP owner and exercises
both limits, the eventual independent-delta lower bound and the assembled
C20/C21 input consumer. Keep fixtures private; do not create a shared public
fixture or import AEP into the finite examples merely to share a small PMF.

This is a deliberately small surface, not a quota. AE rewrites, moment
transport, Chebyshev algebra and probability-complement rewrites remain private
or derived in consumers. Any public expansion requires actual consumer pressure,
naming/import review and the normal API-growth approval record; generated
inventory is not approval. Keep new names under the established Note 14 policy.

## 5. Ordered steps and acceptance criteria

Five steps separate the analytic risk, probabilistic endpoint, finite typicality,
counting interface and cumulative closeout. Only the explicitly selected step
may run. Criteria below are cumulative requirements for final review.

### C19.01 — Supported information and the probability bridge

Depends on the verified C16--C18 baseline. Introduce the focused AEP owner and
supported iid identity; establish the private support/AE, finite expectation and
integrability machinery needed by the selected proof. If using Chebyshev, finish
the coordinate-composition independence, `MemLp 2`, coordinate mean/variance
transport and variance-of-sum argument, including the normalized identities
below, before declaring this step ready.
Reuse `entropy_eq_integral_selfInfo` and `entropy_iid`; do not prove a second
entropy implementation.

For Chebyshev, the exact private exit contract uses
`S_n(x) := sum_i selfInfo p (x i)` and `Z_n(x) := S_n(x)/(n : Real)` under
`mu_n := q_n.toMeasure`, with locally chosen discrete measurable structures:

```text
S_n = L_n almost everywhere under mu_n                    (all n)
integral S_n dmu_n = (n : Real) * H                       (all n)
variance S_n mu_n = (n : Real) * V_p                      (all n)
MemLp Z_n 2 mu_n, integral Z_n dmu_n = H                  (0 < n)
variance Z_n mu_n = V_p / (n : Real)                      (0 < n)
P_n(D_{n,epsilon}) =
  (mu_n {x | epsilon <= abs(Z_n(x) - H)}).toReal          (0 < n).
```

The event bridge includes the finite-probability guards needed for real
conversion. If another route is selected, record its equally concrete private
exit statement in the notes and compile the actual theorem interface required
by that route. C19.02 owns applying the concentration/LLN theorem to obtain the
finite-n bound or convergence conclusion, then completing the public AEP limit;
those are not C19.01 completion claims.

- **C19.01-SUPPORT:** Supported block additivity holds for every length without
  full support; the permanent sparse impossible-word regression proves that
  unrestricted additivity fails.
- **C19.01-BRIDGE:** A proof-complete private checkpoint connects the actual iid
  PMF, its finite event probabilities and the selected concentration/LLN proof
  machinery with all measurability and integrability obligations discharged.
  For Chebyshev this includes the displayed normalized moment/event identities,
  mean and variance transport and pairwise independence of self-information
  compositions, not just raw coordinates. An alternative route has its explicit
  private exit statement and the same discharged interface obligations.
- **C19.01-BOUNDARY:** Permanent consumers cover length zero/one, pure sources
  and singleton alphabets; focused imports preserve probability/root boundaries
  and the existing selfInfo convention.

Validation: focused AEP and `Examples.AEP` compilation with warnings as errors,
relevant aggregates, source/API/import/simp checks and the common step gates in
section 6. Record the internal checkpoint separately from declaration checks.

### C19.02 — Numerical finite-iid AEP

Depends on C19.01. Prove the exact section 3.3 probability limit. The preferred
route proves a private finite-n Chebyshev bound, obtains the scalar bound's
limit and squeezes the nonnegative probabilities. Eliminate public measurable
instances through the finite event formulation. An alternative route must
retain the same support, epsilon and varying-space contract.

- **C19.02-LIMIT:** For every finite PMF and positive epsilon the stated
  `>= epsilon` real event probability tends to zero along natural blocklengths.
- **C19.02-PROBABILITY:** The actual PMF atom/event-to-measure conversions and
  support/AE substitution are correct; every normalized estimate requires
  positive blocklength and every ENNReal-to-Real step has its finiteness guard.
- **C19.02-CONSUMERS:** `Examples.AEP` consumes the public limit for the binary
  `(1/3,2/3)` source and a sparse source, and verifies deterministic zero
  deviation. The exact positive finite second moment in section 3.7 is checked;
  if using Chebyshev, the private AEP-owner check exercises normalized variance
  at `n=2`. Uniform zero-variance examples alone are insufficient.

Validation: focused owner/consumer and aggregate builds, common gates, and
review of the exact limit expression and selected analytic bound's provenance.
Do not classify a finite expectation equality as AEP completion.

### C19.03 — Weak typicality, probability and word masses

Depends on C19.02. Introduce TypicalSet with the exact section 3.4 convention,
supported membership and per-word mass bounds, using only its finite-owner
dependencies. Then import it into AEP, establish complement/deviation equality
in probability for positive lengths, and prove typical-probability convergence
there. Examples.TypicalSet remains independent of the AEP import.

- **C19.03-EVENT:** The supported strict finite set and its membership theorem
  have the specified positive-length guard, zero-length and nonpositive-width
  behavior; no impossible word is admitted, even for epsilon greater than H.
- **C19.03-LIMIT:** Typical probability tends to one and its complement tends
  to zero; the support-null argument justifies probability equality without
  asserting false ambient-set equality. The public convergence theorem is owned
  by AEP and consumed in `Examples.AEP`.
- **C19.03-MASS:** Both exponential atom bounds hold with the specified signs,
  Real masses and nats, without a positive entropy or full-support premise.
- **C19.03-CONSUMERS:** `Examples.TypicalSet` checks deterministic/singleton,
  sparse supported/impossible, zero/one length and nonpositive widths using the
  public definition and theorems. It proves the section 3.7 positive-length,
  positive-width empty typical-set regression, the nonempty probability-`2/3`
  case and exact-boundary exclusion.

Validation: focused builds of both owners and both consumers, common gates,
finite-owner import-boundary and exact membership/exponential-sign review.
Preserve one typical-set convention for both later coding directions.

### C19.04 — Cardinality bounds and the C20/C21 interface

Depends on C19.03. Derive the section 3.5 bounds from finite probability sums
and atom bounds. Exercise their use with natural message-size parameters as
mathematical inputs only; introduce no code, rate or error definitions.
One assembled private consumer in `Examples.AEP` must obtain the section 7
input package using only supported interfaces; independent wrappers that never
combine the results do not satisfy this obligation. The eventual lower-bound
consumer keeps epsilon and delta independent.

- **C19.04-UPPER:** The real-cast upper cardinality bound follows for every
  natural length and real width, including empty boundary cases and entropy zero.
- **C19.04-LOWER:** For every natural length and real width, the lower bound
  retains the actual typical probability; a permanent consumer derives the
  stated independent-delta eventual form for positive epsilon and delta.
- **C19.04-HANDOFF:** One assembled private consumer obtains, for the same
  typical-set family and the same real event-probability representation,
  complement convergence, atom and cardinality upper bounds and the explicit
  natural-message-size conversion in section 7. It uses only supported
  interfaces, with no private AEP helpers, full-support, positive-entropy or
  rate-convergence assumption, and creates no new public package abstraction.

Validation: focused builds of both owners and both consumers, common gates and
an audit against the exact downstream contracts in section 7. No integer-rounding
or source-code theorem is implemented as a purported C19 consumer.

### C19.05 — Cumulative qualification, review and maintained handoff

Depends on closure of C19.01--C19.04. Adds no mathematical endpoint. Complete
the canonical/generated documentation, remaining-work dispositions and
`docs/handoffs/chunk-19.md` before final source capture. Obtain the separately
authorized exact clean checkpoint and API-documentation milestone described
in section 6. Perform a fresh independent review against all sixteen criteria
in this section, explicitly reconcile the original report and every earlier
report/finding, and use supported final capture and private closure.

- **C19.05-VALIDATION:** The exact candidate passes the complete maintained
  clean routine and the separate actual two-pass current API-documentation
  gate with inspected new signatures/docstrings/source links; retained API,
  root/import/simp and trust boundaries are checked. Amendments receive the
  required clean rerun and exact API-evidence applicability assessment.
- **C19.05-READINESS:** All earlier step closures, validations, contextual
  self-review, separate reassessment and report reconciliations are retained;
  the final candidate is ready for fresh independent all-criterion review,
  with each remaining item given an owner, disposition and reopening trigger.
- **C19.05-HANDOFF:** Canonical context, applicable generated references and the
  maintained handoff accurately record delivered contracts, conventions,
  consumers, actual evidence/limits and distinct C20/C21 responsibilities.
  The handoff is linked from canonical context before final capture.

These readiness criteria do not assert future receipt or closure. After the
review, reconcile its actual assessments, correct within scope, validate and
assess R-to-F applicability; material invalidation needs renewed review.
Only the supported private completion record establishes final closure.
Do not modify captured documents afterward to manufacture completed prose.

## 6. Validation and authorization gates

For each mathematical step, build touched producers and permanent consumers
with warnings as errors, then relevant `Shannon`, `SemanticBridge` and `Examples`
aggregates. Serialize artifact-producing builds. Check the exact proposed
public signatures, ownership, direct-import closures, root reachability and
simp attributes. Maintain meaningful examples instead of implementation-mirroring
tests. Add the new private examples only to the Examples aggregate.

After approved public growth/import changes, deliberately update the reviewed
growth policy and current inventory/generated source references. Run:

```text
python scripts/generate_current_public_api.py
python scripts/generate_v0_1_public_api.py --check
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/validate_release.py static
python scripts/validate_release.py documentation
python scripts/validate_release.py trust
```

Use `python scripts/validate_release.py focused <touched targets>` for focused
validation. The frozen v0.1 generator remains check-only. The trust gate includes
compiled retained compatibility and the all-project axiom audit. No placeholders,
unapproved axioms, native-decision shortcuts or stronger assumptions for proof
convenience are permitted. Preserve the root's two direct imports and retained
v0.1 contracts. New sources carry the exact EPFL/MIL header.

Dirty implementation checks do not replace the clean routine:

```text
python scripts/validate_release.py
```

The complete routine requires a clean, exact candidate. Before requesting
checkpoint authority, prepare the concrete scoped diff and exact file list,
excluding unrelated pending changes. A commit or amendment, and creation/reuse
of a validation worktree when needed, require separate explicit authority;
keep any authorized auxiliary checkout under the existing repository's ignored
`.worktrees/` directory. Do not commit unrelated work or weaken hygiene to pass.
Every checkpoint amendment requires a complete clean routine rerun.

The separate API-documentation milestone is also a required C19 closeout gate:

```text
python scripts/validate_release.py api-docs
```

Request its separate milestone authorization when C19.05 has a concrete
qualified candidate; planning approval alone does not run it. On Windows it
requires the reviewed Zig 0.16.0 through `LEANINFOTHEORY_ZIG`. Use local file
mode, inspect every new declaration's actual elaborated signature, hypotheses,
docstring, ownership and source link, and retain both actual build passes and
their configuration/source fingerprints. Incremental-cache results are described
honestly. Later changes need exact applicability or renewed API qualification;
name/count agreement alone is insufficient. These gates authorize no publication.

For review, use the existing C19 binding and installed workflow with neutral,
self-contained source-bound requests. Preserve original native results and
requested-versus-observable settings. Follow current recovery rules; unsupported
operations stop without tooling bypass. Review criteria gaps require a new
satisfactory reviewer assessment. Keep B, R and F distinct and retain original
failures. Record actor, source, command, result and limits for every check.

## 7. Exact C20/C21 handoff

The maintained handoff will give actual declaration names/imports and permanent
consumer locations for the single `T_{n,epsilon}` convention above. For every
positive epsilon it supplies complement probability tending to zero, the atom
upper bound and upper cardinality bound, together with the probability-weighted
lower cardinality bound. These are the common finite-iid inputs for both coding
directions, with no full-support or positive-entropy restriction.

The assembled C19.04 consumer fixes an arbitrary finite `p` and `epsilon > 0`
and obtains together, for this same `T_{n,epsilon}`:

```text
Tendsto (fun n => P_n(T_{n,epsilon}^c)) atTop (nhds 0)
forall n x, x in T_{n,epsilon} ->
  r_n(x) <= exp (-(n : Real) * (H-epsilon))
forall n, (T_{n,epsilon}.card : Real) <= exp ((n : Real) * (H+epsilon))
forall n (M : Nat), exp ((n : Real) * (H+epsilon)) <= (M : Real) ->
  T_{n,epsilon}.card <= M and 1 <= M.
```

It also identifies `M` with `Fintype.card (Fin M)`. Positivity of the exponential
supplies the nonempty message-budget fact; no separate `M >= 1` assumption is
needed for this conversion. The consumer may be one private theorem or a local
proof assembling these facts, not a new public structure. It uses supported
typical-set results and PMF/mathlib conversions, never private AEP helpers.
It neither chooses or rounds M nor introduces code, decoder, rate or error data.

C20 remains independent of AEP and supplies the arbitrary-law interfaces:

```text
P_success <= q(T^c) + M*b
  when a code correctly decodes at most M words and every atom in T is <= b;
exists code, P_error <= q(T^c)
  when card T <= M and M >= 1.
```

C21 specializes the first with
`b := exp (-(n : Real) * (H - epsilon))` and the second with
`card T <= exp ((n : Real) * (H + epsilon))` plus C20's actual integer rounding.
Correct decoding outside T remains allowed; the error bound is not generally
an equality. C19 consumers check these mathematical inputs and their types,
without preimplementing either C20 theorem.

C21 owns code sequences, achievability above H, error tending to one under an
eventual rate bound below H, and the general vanishing-error liminf statement.
Eventual/extended-real rate conventions and the total-decoder fallback remain
C20/C21 decisions. C19 proves neither those results nor a claim at exact rate H.
The final handoff must explicitly retain `H=0`, zero-length initialization and
integer message-cardinality distinctions. No C20 or C21 step starts on handoff.

## 8. Approval decisions and plan-health triggers

The proposed choices for approval are: strict supported typicality with empty
zero-length set; Real outer-measure probabilities for public finite endpoints;
the two focused owners and small public surface; five dependency-driven steps;
the all-length/all-width cardinality contracts; the single nonuniform moment
and strict-boundary fixture; and the assembled C20/C21 input consumer.
Chebyshev remains an advisory private route, subject to the conditional
checkpoint and normalization checks when selected, rather than an extra public
endpoint. The notes explain the selected and deferred review suggestions.
No other mathematical prerequisite decision is currently required.

Before C19.01, obtain exact plan approval and explicit step selection. Formal
plan review runs only when requested. Later clean checkpoint/API-documentation
authority is distinct and will concern concrete reviewable work.

Reassess if the pinned analytic bridge fails, if a proposed public endpoint
requires extra hypotheses, if imports threaten the root/probability split, if
the two modules need a material ownership change, or if C20/C21 cannot use the
same typicality convention. Do not conceal such pressure by dropping the AEP,
weakening the probability-weighted lower bound or expanding into coding.
