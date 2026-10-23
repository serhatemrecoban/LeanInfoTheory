# Chunk 20: Fixed-length source codes and one-shot bounds

<!-- lit-review-status:start -->
**Status:** Approved revision 2, 2026-10-22. C20.01--C20.04 and their reviews
are complete by their private source-bound records. The conditional Step 5
request was admitted after exact Step 4 closure and source-applicability checks.
C20.05 owns cumulative qualification, the [maintained handoff](../handoffs/chunk-20.md)
and fresh independent review of all eighteen criteria; it adds no endpoint.
The local two-pass API-documentation milestone and all-24 declaration inspection
have passed. The lead approved the scoped local checkpoint, same-scope amendments
and existing validation-checkout reuse. Initial checkpoint `940e5e7` passed the
complete clean routine; every amendment requires a complete rerun and fresh
API applicability. The candidate is validation-ready; cumulative review and
closure are established by actual source-bound records. Only the private C20.05 completion
record establishes closure. Revision 2 has not received formal plan review;
revision 1's unresolved reviewer-context limitation remains retained. The
[notes](post-release-chunk-20-notes.md) record evidence and limitations. This
region records status only; later chunks and publication are unselected.
<!-- lit-review-status:end -->

## 1. Authority, endpoint and exclusions

Deliver deterministic fixed-length source codes, exact existing-error semantics,
finite success-set counting, the two arbitrary-law one-shot interfaces below,
and integer message/rate utilities sufficient for C21. Retain the block interface
`(Fin n → A) → Fin M` with total decoder `Fin M → (Fin n → A)` and an operational
budget `1 ≤ M`. Canonical information and rates are real-valued in nats.

Work only in `C:\Users\coban\Desktop\Lean Info Theory`. Approval of the exact
plan and an explicit request selecting one step are required before production
implementation. Each selected step uses the installed review process, closes
only that step and stops. A separately requested plan review assesses the
proposal without approving execution. This plan supplies no authority to
commit, push, deploy, publish, tag, release, upgrade dependencies or start
another chunk.

Excluded: Huffman, prefix and Kraft--McMillan coding; general erasure or list
decoding frameworks; random coding; efficient/executable compression algorithms;
variable-length coding; optimal-code classifications; channel-coding proofs;
C21's asymptotic threshold theorem, exact-entropy-rate claims and error exponents.
The second release remains planned after C24 and separately authorized.
External formalization repositories and review-tool changes are outside scope.

Sections 1, 3--8 and the reuse obligations in 2.1 are the proposed normative
contract. Section 2 records baseline/source evidence. Evolving implementation
advice belongs in the separate notes. Changes to meaning, assumptions, required
scope, important public contracts, acceptance policy or pins require the lead;
an evidenced proof-route adjustment preserving them does not.

## 2. Baseline and source interpretation

Intake HEAD is `d60927259558e5ebbe4d332954adf564e52d04f4`. The four pre-existing
modified files are `.gitignore`, `AGENTS.md`, `docs/next-website-tasks.md` and
`docs/project-log.md`. Their bytes are privately recorded and must be preserved.
C19 completion is established by
`.lit-review/setup/c19-05-completion-20261020.json` and its linked final source,
review, reconciliation and validation records, including closure
`a7b1c05e6b405cfc4f57b1e6662429e30708ac4cbfd74676bfac672300eef5e8`.
Captured provisional prose does not reopen C19 or its predecessors.

The current generated inventory and fresh static gate report 721 documented
supported declarations in 47 owners, 92 root exports and 94 reviewed simp names.
These are baseline counts, not targets or approvals. Lean/mathlib remain
v4.33.1; pinned mathlib is `0df444a360eaa60ab8c11dca51a86af692955474`.
The installed inspection reports all nine root dependencies clean at their pins.
No fresh complete clean routine or API-documentation build is claimed at intake.

Read the registered editions in [references](../references.md). The complete
PW24 section 11.1 was inspected, with section 11.2 and CT91 Chapter 3 used only
for the downstream distinctions below.

| Source anchor | Interpretation and C20 adaptation |
| --- | --- |
| PW24, August 16, 2024, section 11.1, printed 212--217 / PDF 237--242 | One-shot fixed-length source coding. Replace binary-budget notation by integer `M` and convert logarithms explicitly to nats. This is not PW22. |
| Definition 11.1 and Theorem 11.2, printed 213 / PDF 238 | Detectable-error decoder has an erasure value and reserves an index in its countable-alphabet construction. Its `2^k-1` success budget and exact optimal tail are not C20's total-decoder contracts. |
| Remark 11.1, printed 214 / PDF 239 | Undetected errors are permitted, but the decoder codomain still allows erasure. For nonempty source alphabets, replace erasures by a fixed source value: existing successes are preserved, so error cannot increase. C20 uses this total-decoder adaptation with all `M` indices available and no reserved erasure index. |
| Theorem 11.4 and complete proof, printed 214--215 / PDF 239--240 | Splitting a success set into a threshold complement and bounded-mass atoms motivates the arbitrary-set converse. C20 states the stronger reusable finite counting interface, not a verbatim optimal-erasure theorem. |
| Theorem 11.5 and remarks, printed 215--217 / PDF 240--242 | Random-coding argument read to delimit the section; no random-coding endpoint selected. |
| PW24 section 11.2, Proposition 11.6, printed 217--218 / PDF 242--243 | Downstream context only. C19's strict supported typical set resolves the book's closed-definition/strict-proof discrepancy; C20 does not redefine it. |
| CT91 section 3.1, printed 51--53 / PDF 73--75, and section 3.3, printed 55--56 / PDF 77--78 | AEP and high-probability-set counting context. Coding still requires C20's actual finite maps. |
| CT91 section 3.2, Theorem 3.2.1, printed 53--55 / PDF 75--77 | Variable-length expected-description-length argument, with flag and different lengths. It is not the fixed-length almost-lossless theorem selected here. |

The registered local PDF hashes and actor-specific reading evidence are in the
notes. No reference media, substantial textbook text or external implementation
code belongs in the repository changes.

### 2.1 Reuse obligations

| Existing source | Reuse and constraint |
| --- | --- |
| `Shannon.Fano` | Reuse `decodingErrorProbability` and `decodingErrorProbabilityOf`, their Boolean indicator and probability bounds. Extend with one generic event bridge; do not define a competing error semantics. |
| `Probability.Finite` and pinned PMF `Basic`/`Constructions` | Reuse finite real atom masses, `PMF.sum_toReal`, support nonemptiness, map/preimage event equality, singleton/finset event sums and event complements. Establish finite ENNReal values before subtraction, summation or order conversion. |
| `Probability.TotalVariation` | The generic `PMF.toOuterMeasure_toReal_eq_sum` already exists. Reuse it if its import is justified; otherwise derive local finite-set instances directly from pinned PMF lemmas. Do not add a duplicate public generic event-sum theorem. |
| Pinned `Data.Fintype.EquivFin` and `Logic.Function.Basic` | Finite-cardinality embeddings and `Function.extend`/`Function.Injective.extend_apply` supply an inspected candidate construction route. Reuse suitable existing machinery; the exact proof recipe is advisory. One-off inverse/choice machinery stays private. |
| `Probability.Iid` and C16 handoff | Words are `Fin n → A` and iid laws are `PMF.iid p n`. Arbitrary laws on the word space remain valid inputs. No new word or iid datatype. |
| `Shannon.Units` | Reuse `natsToBits` and `natsToBase`. Do not create a parallel bit-valued information/rate theory. |
| Pinned floor/log/cardinality owners | Reuse `Nat.le_ceil`, `Nat.one_le_ceil_iff`, `Nat.ceil_lt_add_one`, `Nat.ceil_le`, positive log/exp equivalences and function-space cardinality. |
| `Shannon.TypicalSet`, `SemanticBridge.AEP` and C19 handoff | Use their supported public statements in a separate permanent integration consumer. The private `Examples.AEP.typical_inputs` is a reference for the exact contract, never a production dependency. |

Search current inventory, focused sources and pinned mathlib before expanding
the public surface. Existing source names in this table were inspected;
declaration elaboration and full C20 proof feasibility are distinct evidence.
The first implementation checkpoints below must compile connected proof
fragments, not merely repeat declaration searches.

## 3. Mathematical contracts

### 3.1 Core and block interfaces

Propose these transparent aliases in `LeanInfoTheory.Shannon`:

~~~text
SourceCode (X : Type u) (M : Nat) :=
  (X → Fin M) × (Fin M → X)
BlockSourceCode (A : Type u) (n M : Nat) :=
  SourceCode (Fin n → A) M
~~~

Named `SourceCode.encoder` and `SourceCode.decoder` expose the two maps.
They impose no global injectivity or inverse law. The finite-carrier core is
justified by both one-shot statements applying to arbitrary finite laws and
by simpler cardinality proofs; the block alias is a required public interface.
No public structure, class, new validation-tool feature or generic coding
framework is required.

The raw pair is a total Lean type. Operational budgets require `1 ≤ M`:
constructors take it explicitly, and a code with a source law already forces
it because `q.support_nonempty` gives an `x` and `encoder x : Fin M`.
A raw zero-message pair exists only on an empty carrier, on which no PMF
exists. Such a lawless degeneracy is not an operational source code.
This convention is explicit; positivity is not hidden in a typeclass.

Finite statements use `{X : Type u} [Fintype X]`. Definitions and the generic
error bridge need no finite instance unless their statement enumerates values.
Choose classical decidability internally; no public `DecidableEq` or measurable
instance is imposed. A law-free construction takes `[Nonempty X]` explicitly.
A construction supplied `q : PMF X` obtains its fallback from that law and
adds no unnecessary nonemptiness or full-support premise.

### 3.2 Events, error and success counting

For a source law `q : PMF X`, notation in this plan only:

~~~text
P_q(E) := (q.toOuterMeasure E).toReal
e_q(c) := decodingErrorProbabilityOf q id c.encoder c.decoder
S(c) := {x | c.decoder (c.encoder x) = x}
~~~

`SourceCode.errorProbability` abbreviates exactly the existing expression
`e_q(c)`, not a separately chosen probability definition.
`SourceCode.successSet` is the finite enumeration of `S(c)`. For any finset
`T : Finset X`, write its event explicitly as `(T : Set X)`; in particular,

~~~text
P_q(T) = ∑ x ∈ T, (q x).toReal
P_q(Tᶜ) = 1 - P_q(T).
~~~

The generic Fano bridge must prove, for arbitrary source and value types,

~~~text
decodingErrorProbabilityOf q X Y decoder
  = (q.toOuterMeasure {ω | decoder (Y ω) ≠ X ω}).toReal.
~~~

Its code specialization gives the exact failure-event probability.
Prove also `P_q(S(c)) = 1 - e_q(c)`, hence success plus error equals one.
Use finite probability bounds, not an unguarded `ENNReal.toReal` complement
rewrite. Neither impossible words nor extra successes are discarded.

The encoder restricted to `S(c)` is injective: equality of indices and correct
decoding imply equality of source values. Consequently
`c.successSet.card ≤ M`. No assertion of ambient encoder injectivity is allowed.
Cardinality is a property of actual correct decoding, independent of `q`.

### 3.3 Arbitrary-law one-shot interfaces

For every finite `X`, `q : PMF X`, `T : Finset X`, natural `M`, and valid code:

**Converse.** For `b : Real`,

~~~text
0 ≤ b →
(∀ x ∈ T, (q x).toReal ≤ b) →
P_q(S(c)) ≤ P_q((T : Set X)ᶜ) + (M : Real) * b.
~~~

Keep `b ≥ 0` even for an empty `T`: multiplying a cardinality inequality by a
negative number is invalid. The pointwise formula must be usable for arbitrary
finite laws and for arbitrary indices of a future code sequence.

**Construction and achievability.** If `T.card ≤ M` and `1 ≤ M`, first provide
a law-free existence theorem

~~~text
[Nonempty X] →
∃ c : SourceCode X M, ∀ x ∈ T, c.decoder (c.encoder x) = x.
~~~

Then, supplied `q` and without an extra nonemptiness premise, provide

~~~text
∃ c : SourceCode X M,
  (∀ x ∈ T, c.decoder (c.encoder x) = x) ∧
  c.errorProbability q ≤ P_q((T : Set X)ᶜ).
~~~

Retaining correct-on-`T` for the same witness makes the operational contract
usable without unfolding a private constructor. The encoder and decoder must
be total, recover every member of `T`, and handle `T=∅` using an ambient fallback
without choosing an element of `T`. The finite-embedding/inverse-extension
recipe is advisory and recorded in the notes; an equivalent construction that
preserves these contracts is permitted. Additional correct decodings outside
`T` are permitted. The error conclusion is an inequality and must not become
an unjustified equality.

These are the required one-shot endpoints. A new public self-information
threshold family or information-spectrum abstraction is not required. Any
private threshold consumer must guard support: project `selfInfo` is zero at
impossible atoms, so a raw numerical band can have a false counting bound.

### 3.4 Rate and integer rounding

Use shared scalar `codeRate (n M : Nat) : Real := Real.log (M : Real) / n`.
Its operational interpretation requires `0 < n` and `1 ≤ M`. Prove
nonnegativity for positive budgets, rate zero for `M=1`, and the total
zero-length value `codeRate 0 M = 0` as an initialization convention only.
There is no normalized zero-length theorem obtained by cancellation.

For `0 < n`, `1 ≤ M` and any `R : Real`, prove the exact budget/rate bridge

~~~text
codeRate n M ≤ R ↔ (M : Real) ≤ exp ((n : Real) * R)
exp ((n : Real) * codeRate n M) = (M : Real).
~~~

These forms also let C21 rewrite the converse remainder as
`exp(n * (codeRate n M - H + ε))`. The private C19 integration consumer must
exercise their composition with the one-shot bound: for `q_n=PMF.iid p n`,
`T_n=weakTypicalSet p n ε`, `H=entropy p`, `ε>0`, an arbitrary code `c`,
`0<n`, `1≤M`, and `codeRate n M≤R`, derive

~~~text
1 - c.errorProbability q_n
  ≤ P_{q_n}((T_n : Set (Fin n → A))ᶜ)
    + exp (-(n : Real) * (H - ε - R)).
~~~

Keep `R` arbitrary: neither `R<H-ε` nor boundedness, rate convergence or an
eventual rate premise belongs to this pointwise finite statement. The code
must remain arbitrary, independently of the achievable rounded family.

Define the integer budget

~~~text
roundedMessageSize n R := Nat.ceil (exp ((n : Real) * R)).
~~~

For every real `R` and natural `n` prove

~~~text
1 ≤ roundedMessageSize n R
exp ((n : Real) * R) ≤ (roundedMessageSize n R : Real)
(roundedMessageSize n R : Real) < exp ((n : Real) * R) + 1.
~~~

For `0 < n` and `0 ≤ R` prove the usable two-sided estimate

~~~text
R ≤ codeRate n (roundedMessageSize n R)
codeRate n (roundedMessageSize n R) ≤ R + Real.log 2 / n.
~~~

Do not claim the second bound for negative `R` without changing its statement:
`exp(nR)+1 ≤ 2 exp(nR)` uses `0 ≤ nR`. The arbitrary-real budget bounds remain
available. At `n=0` and at `R=0` the budget is exactly one; integer exponentials
must not acquire an extra message from an off-by-one rounding convention.
Ceiling supplies an upper-budget approximation with an explicit overhead, not
an exact claim `codeRate ≤ R` at each finite length.

### 3.5 Binary digits and message cardinalities

Use existing cardinality/equivalence machinery to prove in a permanent consumer
that `Fintype.card (Fin k → Bool) = 2^k`. Hence an exactly `k`-digit alphabet is
equivalent to `Fin (2^k)`. It is equivalent to `Fin M` only when `M=2^k`;
`M≤2^k` supplies an embedding, allowing unused strings.

Prove the scalar endpoint, for `1 ≤ M` and `k : Nat`,

~~~text
Nat.ceil (natsToBits (Real.log (M : Real))) ≤ k ↔ M ≤ 2^k.
~~~

This specifies the minimal fixed binary length without a second public length
datatype. Prove
`natsToBits (codeRate n (2^k)) = (k : Real) / n`, including the total algebraic
zero-length convention; interpret it as a rate only for `n>0`.
A permanent consumer must actually pad an `M`-index source code through an
embedding into `k` bits and extend its decoder, preserving the recovered value
for every source input and therefore its exact error. Do not merely state
cardinality equality and assume a code transport. The transport can stay private.

For `1≤M`, `0<n` and `k=Nat.ceil (natsToBits (Real.log (M : Real)))`, the same
private consumer must connect the original and padded rates:

~~~text
codeRate n M ≤ (k : Real) * Real.log 2 / n
(k : Real) * Real.log 2 / n < codeRate n M + Real.log 2 / n.
~~~

The middle quantity is `codeRate n (2^k)`, the rate of the padded message
alphabet. Padding preserves recovered outputs and error, but generally changes
the message budget and rate. This finite composition check adds no public API.

### 3.6 Shared downstream conventions

C21 proposes an unbundled sequence:
`M : Nat → Nat`, `hM : ∀ n, 1 ≤ M n` and
`c : ∀ n, BlockSourceCode A n (M n)`. Its numerical error is
`c n |>.errorProbability (PMF.iid p n)` and its rate is `codeRate n (M n)`.
Use `M 0=1` for the constructed rounded family. Arbitrary code families in
converse statements may have any positive `M 0`; their decoder necessarily
returns the unique empty word, their error at zero is zero, and the totalized
rate at zero is zero. Finite changes at zero do not affect later limits.
No public sequence structure is added in C20.

C20's private C19 consumer must assemble one actual dependent family with
`M n := roundedMessageSize n (entropy p + ε)`. For this same family, retain
correct decoding on `T_n` and the complement error bound for every `n`, plus
the two-sided rate estimate for `n>0`. In particular, exercise `M 0=1` and the
empty-word decoder. Choosing the family from pointwise existence is permitted;
it is not a public code-sequence abstraction or an asymptotic theorem.

C21's primary rate assertions are eventual inequalities, or limits in `EReal`
of the real rate sequence. Vanishing error must imply
`∀ δ>0, ∀ᶠ n in atTop, H-δ ≤ codeRate n (M n)` without assuming rates converge
or are bounded. The pointwise one-shot bound remains available along low-rate
indices; an eventual-low-rate strong converse alone does not establish this
liminf claim for oscillating sequences. Achievability above entropy may select
an intermediate target `H<R'<R` and use the ceiling overhead, or derive the
extended-real limsup from the same estimates. C21 owns all such limit proofs.

C23 retains distinct channel codes: encoder `Fin M → (Fin n → A)` and decoder
`(Fin n → B) → Fin M` with uniform message law. It may share `codeRate`,
integer-budget/bit conventions and the generic Fano event bridge. It does not
reuse source-code types with reversed names. C23 must derive any eventual
boundedness needed for real limsup from its finite inequality and vanishing
error; arbitrary above-capacity sequences use eventual or `EReal` formulations.
These are proposed interface agreements, not authorization to implement C21/C23.

## 4. Proposed public ownership and import boundaries

The following names and meanings are proposed contracts, not assertions that
the declarations already exist. Ordinary argument inference may be refined
without changing the explicit hypotheses, witness strength or mathematical meaning.

| Owner | Proposed public declarations |
| --- | --- |
| Existing `Shannon.Fano` | `decodingErrorProbabilityOf_eq_toOuterMeasure`, the type-generic failure-event bridge. No relocation or change to existing declarations. |
| New `Shannon.SourceCoding` | `SourceCode`, `BlockSourceCode`, `SourceCode.encoder`, `SourceCode.decoder`, `SourceCode.errorProbability`, `SourceCode.successSet`, `SourceCode.mem_successSet`, `SourceCode.card_successSet_le`, `SourceCode.successProbability_eq_one_sub_errorProbability`. |
| Same finite coding owner | `exists_sourceCode_correctOn`, `exists_sourceCode_errorProbability_le`, `SourceCode.successProbability_le`, with the contracts in 3.3. |
| New `Shannon.CodingRate` | `codeRate`, `codeRate_nonneg`, `codeRate_zero`, `codeRate_one`, `codeRate_le_iff`, `exp_mul_codeRate`, `roundedMessageSize`, `roundedMessageSize_bounds`, `codeRate_roundedMessageSize_bounds`, `ceil_natsToBits_log_le_iff`, `natsToBits_codeRate_pow_two`. |

Use namespace `LeanInfoTheory.Shannon` throughout, including the nested
`SourceCode` namespace. No new public instances or simp attributes are proposed.
Definition projection reductions and membership facts may be used explicitly.
No extra public constructor, inverse machinery, event-probability abstraction,
binary-code datatype, threshold wrapper or sequence abstraction is required.

Proposed direct imports:

- `Shannon.SourceCoding`: `Shannon.Fano` and
  `Mathlib.Data.Fintype.EquivFin`. Pinned PMF and function-extension facts are
  available through this closure. Add only a specifically justified focused
  mathlib import if the compiled checkpoint demonstrates a need.
- `Shannon.CodingRate`: `Shannon.Units` and
  `Mathlib.Algebra.Order.Floor.Semiring`; focused log arithmetic is already in
  the Units closure. Put binary equivalence imports in the consumer if only
  the consumer needs them.
- `Shannon.Fano`: retain its three existing direct imports; test the new generic
  bridge before proposing an import change.
- Full `LeanInfoTheory.Shannon` umbrella: add the two focused owners only.
  Neither semantic umbrella nor `LeanInfoTheory.lean` gains a coding import.

The coding owners must not import `Probability.Iid`, `Shannon.TypicalSet`,
`SemanticBridge.AEP`, example modules, or each other. Their formulas do not
need those dependencies. Fano's existing semantic dependency is acknowledged;
independence from AEP is not a claim that the entire transitive closure is
measure-free.

Private permanent owners:
`Examples.SourceCoding` (finite arbitrary-law constructions and bounds),
`Examples.CodingRate` (scalar/binary interfaces), and
`Examples.SourceCodingTypicalSet` (explicit C19 integration).
Only the last imports typical sets/AEP and iid. All join the non-stable
Examples aggregate and stay outside mathematical umbrellas.

Update exact direct-import approvals and generated current API/reference
artifacts only after authorized implementation. Preserve the frozen v0.1
manifest, retained signatures, root's two direct imports and 92 exports,
existing attributes and dependency pins. A tooling limitation does not authorize
changing validation policy to accept a different representation.

## 5. Ordered steps and exact acceptance criteria

Each criterion below is normative. Its identifier is the stable review key;
the text after the identifier is its required result. Apply the common
validation/review duties in section 7 to every selected step.

<a id="c20-01"></a>
### C20.01 — Code representation, exact error and success counting

Implement the core/block aliases and accessors, generic Fano event bridge,
code error and success finset, membership, success/error complement and
success-cardinality theorem. Establish early construction feasibility without
claiming the later one-shot theorem completed.

- **C20.01-MODEL:** The public pair-based core and block specialization expose
  exactly the encoder/total-decoder types in 3.1, with the documented positive
  operational budget, internal decidability and no global injectivity premise.
- **C20.01-ERROR:** The type-generic Fano bridge and finite code specialization
  prove exact failure-event semantics and success probability equal to one
  minus existing error; probability conversions justify every finiteness step.
- **C20.01-COUNT:** Correct decoding makes the encoder injective on its actual
  success set and proves `successSet.card ≤ M` without assumptions on a law.
  A genuinely colliding encoder is a permanent consumer.
- **C20.01-FEASIBILITY:** Before expanding later API, compile connected checks
  of the generic PMF-map/event bridge and an actual finite selected-set code
  under `T.card≤M`, `1≤M` and explicit ambient nonemptiness. Check total maps,
  correct recovery on `T`, and empty `T` with an ambient fallback. Verify new
  aliases/accessors are admitted by existing inventory/import/trust tooling.
  Declaration-only checks do not satisfy this criterion; the exact construction
  recipe remains advisory.

If the existing toolchain cannot express the pair interface or a total
selected-set construction under these contracts, record the evidence and resolve
plan health before proceeding; do not switch to an unapproved public structure
or partial decoder.

<a id="c20-02"></a>
### C20.02 — Arbitrary-law construction and one-shot converse

Complete both existence statements and the success bound in 3.3. Keep the same
finite owner and exact event representation.

- **C20.02-ACHIEVABILITY:** For every finite `T` with `T.card ≤ M` and `1 ≤ M`,
  law-free existence uses explicit ambient nonemptiness; law-based existence
  derives it from `q` and retains correct-on-`T` plus the error upper bound for
  the same witness.
- **C20.02-CONVERSE:** For every finite law, arbitrary code, finite `T` and
  nonnegative atom cap `b` on `T`, prove precisely the success inequality in
  3.3 using the actual success-set count; no iid or typicality assumptions.
  Apply it to the fair binary one-message example with `T=univ`, `b=1/2`,
  obtaining the attained success upper bound `1/2`, strictly below one.
- **C20.02-ARBITRARY:** Permanent consumers use an arbitrary-law generic theorem
  application and an explicit non-iid/correlated block law, without importing
  AEP or typical sets into the finite coding owner or its focused consumer.
- **C20.02-BOUNDARY:** Consumers cover empty `T`, `T.card=M`, `M=1`, spare
  indices, zero-mass atoms and an example with extra correct decoding outside
  `T`, demonstrating that the construction guarantee need not be equality.

<a id="c20-03"></a>
### C20.03 — Rates, integer ceilings and binary representation

Implement only the finite scalar endpoints in 3.4--3.5 and their permanent
consumers. Compile the rounding/log proof and exact binary padding early in
this step before proliferating wrapper names.

- **C20.03-RATE:** The shared rate is `log M/n` in nats; prove its range,
  `M=1` and zero-length conventions, positive-length rate/budget iff and exact
  exponential identity under the stated guards.
- **C20.03-ROUNDING:** Natural ceiling budgets satisfy positivity and both
  all-real size estimates; positive-length nonnegative targets satisfy the
  two-sided rate estimate with `log 2/n` overhead. Exact integer boundaries,
  zero target and zero length are exercised.
- **C20.03-BITS:** Prove the ceiling-bit-length iff and Units conversion.
  A permanent consumer proves binary cardinality and uses an actual embedding
  and total decoder extension to preserve a code's recovered output and error,
  distinguishing `M≤2^k` from `M=2^k`. For minimal `k` it also proves the
  original-to-padded rate bounds in 3.5 under `1≤M` and `0<n`, privately.
- **C20.03-BOUNDARY:** Consumers include `k=0`, `M=1`, a non-power-of-two
  message size, negative target behavior without a false rate sandwich, and
  positive-length/zero-length separation. No limit theorem is required here.

<a id="c20-04"></a>
### C20.04 — Permanent operational and C19 integration consumers

Consolidate public-interface examples and test the proposed handoff without
proving C21. This step adds no new public mathematical endpoint.

- **C20.04-CONSUMERS:** Permanent consumers demonstrate the construction and
  converse together, a genuinely nonzero-error code with exact probability,
  a deterministic/pure source, a singleton alphabet, the empty word including
  an empty ambient alphabet, and impossibility of a zero-message operational
  code. They use supported producer interfaces rather than private proof helpers.
- **C20.04-C19:** In a separate private owner, instantiate both one-shot
  theorems for the same `q_n=PMF.iid p n` and
  `T_n=weakTypicalSet p n ε`. For `ε>0` expose the existing complement limit
  beside the finite success bound with `b=exp(-n(H-ε))`. Assemble one actual
  family `c : ∀ n, BlockSourceCode A n (M n)` with
  `M n := roundedMessageSize n (H+ε)`, retaining recovery on `T_n` and the
  complement error bound for the same family at every `n`; prove its rate
  sandwich for `n>0` and exercise its zero-length initialization. Separately,
  for an arbitrary code and budget, derive the pointwise rate-form converse
  of 3.4 under `0<n`, `1≤M` and `codeRate n M≤R`, with arbitrary real `R`.
  The set/probability conventions match `Examples.AEP.typical_inputs` exactly,
  using only public C19 declarations and no private-example import.
- **C20.04-ARCHITECTURE:** Verify arbitrary-law owners remain independent of
  iid/AEP/typical-set imports, all new public declarations have permanent
  consumers, root and frozen contracts are preserved, and the unbundled
  sequence/eventual-or-extended-real conventions in 3.6 are documented for
  C21/C23 without implementing their asymptotic or channel conclusions.

The C19 consumer may restate/derive its existing complement convergence and
must form the dependent code family above. It must not prove vanishing code
error, operational limsup/liminf, an entropy threshold, or any channel theorem.

<a id="c20-05"></a>
### C20.05 — Cumulative qualification, reconciliation and maintained handoff

Reserve this final step for cumulative work only. It adds no coding endpoint.
Every approved criterion from C20.01 onward remains in the fresh independent
review; earlier completed steps are evidence, not a reason to omit criteria.

- **C20.05-VALIDATION:** Qualify the exact final candidate with the maintained
  complete clean routine, affected focused consumers/aggregates, compiled
  compatibility/trust and current generated/API/import/simp documentation
  checks. Qualify the separately justified two-pass local API-documentation
  milestone and inspect every new public signature/docstring/owner/source link;
  retain exact applicability and failures separately.
- **C20.05-READINESS:** Retain current-candidate validation, read-only contextual
  self-review and separate reassessment, exact predecessor and original-report
  obligations, and a source-bound request covering all eighteen criteria.
  Material concerns and unowned changes must have explicit dispositions.
- **C20.05-HANDOFF:** Before final source capture, reconcile canonical context
  and generated references and maintain `docs/handoffs/chunk-20.md` with actual
  APIs/imports/consumers, source adaptations, rate/rounding/sequence conventions,
  evidence limits, remaining-work owners and precise C21/C23 boundaries.
  Link it from canonical context.

Readiness criteria are assessed before dispatch; later review receipt,
reconciliation, correction validation and supported private closure are separate
workflow obligations. A clean report still requires explicit reconciliation.
Any criterion gap or contradiction requires a satisfactory new reviewer
assessment under the protocol, not an implementer-only override.

Finish all source/docs/handoff edits before F. Record captured status as
validation ready with closure subject to the private completion record; only
the supported completion mechanism establishes closure. Preserve B/R/F, every
original report and failure, assess R-to-F applicability, and do not edit
captured prose after F just to assert completion. Stop after C20 closure.

## 6. Permanent consumer matrix

| Consumer family | Required mathematical pressure |
| --- | --- |
| Finite arbitrary law | Generic `q,T,M,b` applications of both one-shot theorems and exact Fano event semantics, without full support or iid assumptions. |
| Lossy/nonzero error | Two-point fair source with one message and constant decoder: one success, one failure, error `1/2`. Apply the converse with `T=univ`, `b=1/2`; its success upper bound `1/2` is attained. Encoder collision is real. |
| Construction strictness | Empty `T` with a nonempty law, or a selected set omitting a fallback success: actual error is strictly below complement mass. |
| Sparse correlated block | A finite law supported on selected two-letter words, with an impossible word and correlated coordinates; construct/reuse a code and apply the bound without product independence. |
| Degenerate cases | Pure source, singleton alphabet, `M=1`, empty selected set, exact capacity, unused indices; `Fin 0 → Empty` has an empty word but `PMF Empty` is unavailable. |
| Binary/rate | `M=1,k=0`; exact power of two; `M=3,k=2` with unused string; actual padding and its strict finite rate-overhead bound; integer ceiling boundary; zero/negative target behavior. |
| C19 finite integration | Same strict supported typical set, real outer-measure probability, natural ceiling budget, one dependent code family with all-length recovery/error and positive-length rate bounds, and public complement limit. Also test the rate-form converse for arbitrary codes, separately from that achievable family. No coding limit conclusion. |

Choose explicit small laws or existing supported constructors. Private example
definitions from other owners are reference material, not importable public API.
Keep law computations and test-only helpers private.

## 7. Validation, review and checkpoint authority

Use the maintained validator and serialize artifact-producing Lean builds.
Each coherent implementation step builds the touched producer and important
consumers, then the relevant Shannon/Examples aggregates. Run:

~~~text
python scripts/validate_release.py focused <affected maintained targets>
python scripts/validate_release.py static
python scripts/validate_release.py documentation
python scripts/validate_release.py trust
~~~

Use the executable validator's supported target/command list; standalone
`lake env lean` probes may supplement it but do not replace required gates.
Record command, actor, actual source, result and limitations. Update current
import approvals deliberately, regenerate the current API manifest and
source-derived website index/blueprint when approved public API changes, and
run their non-mutating checks. Preserve the historical manifest and retained
types; counts alone establish neither compatibility nor approval. Delete
disposable proof files before a milestone report, retaining relevant evidence
privately.

Closeout requires `python scripts/validate_release.py` from a clean authorized
checkpoint and a complete rerun after each amendment. This planning request
does not authorize such a commit. Prepare the exact scoped diff and validation
plan first; obtain the separate checkpoint authority when it is actually needed.
Preserve the four intake changes and any newly discovered unrelated work.
Prefer the existing detached validation checkout under
`.worktrees/LeanInfoTheory-C12-validation-20261003` after reinspection; no new
Desktop folder or checkout relocation is authorized.

The separate `python scripts/validate_release.py api-docs` milestone is justified
at final C20 qualification because two supported owners and a generic Fano
contract are being added. It is not a per-step gate or publication. Approval
of this exact plan and selection of C20.05 authorize that specified local build.
Retain actual two-pass results and inspect all new signatures, assumptions,
docstrings, owners and links. On Windows use
the reviewed Zig 0.16.0 via `LEANINFOTHEORY_ZIG` and local file source links.
Reassess source/configuration/dependency applicability after every amendment;
rerun when invalidated. A generated declaration index is not full API-doc evidence.

Neither clean qualification nor API documentation authorizes commit, push,
deployment, release or publication beyond the specifically granted action.
If an authority-dependent gate remains pending, state it and leave closeout
incomplete; do not weaken hygiene or silently create a commit to pass it.

For explicit plan review or implementation with review use
`docs/review-protocol.md` and `docs/review-operations.md`, the installed commands
and this parent's persistent `/root/c20_reviewer`. Retain exact original native
results, requested/effective-setting distinction, actual source and normative
anchors. No recursive reviewer delegation, substituted reviewer or bypass of
unsupported workflow operations is authorized.

## 8. Approval decisions and stop boundary

The proposed revision asks the lead to approve together:

1. The transparent arbitrary-carrier pair core plus required block alias,
   with explicit operational positivity instead of a new public structure.
2. Both arbitrary-set endpoints, including the same witness's correct-on-set
   guarantee and an error inequality; no mandatory public threshold family.
3. The ceiling-exponential budget and finite overhead bound, shared scalar
   rate/bit bridges, actual dependent-family and arbitrary-code rate consumers,
   and unbundled sequence conventions.
4. The five-step order, eighteen criteria, focused owners/consumers, and
   separate clean-checkpoint/API-documentation duties at final qualification.

Exact plan approval does not select C20.01. A separate explicit step request
selects one approved step with its review process, after which work stops.
A formal review of this revised proposal requires an explicit request. The
recorded reviewer-context concern must be resolved before independent-review
acceptance; the revision-1 report is not a clean acceptance or a review of
revision 2. This proposal ends without production implementation or an
execution session.
