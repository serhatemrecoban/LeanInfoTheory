# Chunk 20 maintained handoff: fixed-length source codes and one-shot bounds

## Status and authority

C20.01--C20.04 closure, original-review reconciliation and exact final-source
applicability have been verified before cumulative qualification. The lead has
selected C20.05; its private admission record determines the completed admission
state. This handoff is prepared for that step, which adds no mathematical endpoint.
The [approved revision-2 plan](../plans/post-release-chunk-20.md) supplies all
eighteen criteria; the [notes](../plans/post-release-chunk-20-notes.md) retain
implementation choices, original failures, review history and limitations.

The separately authorized API-documentation milestone has passed both actual
local build/check passes, followed by inspection of all 24 new elaborated
signatures, hypotheses, docstrings, owners and source links. The first attempt
remains FAIL: regenerated declaration data was followed by cached final HTML,
leaving the two new owner pages missing. Three generated marker files were
preserved and moved, then the complete two-pass gate was rerun successfully.
The notes/private records retain exact source/configuration/output identities.
This was warm/incremental semantic inspection, not browser visual QA or a cold build.

The lead approved the prepared 24-path local checkpoint, necessary same-scope
C20.05 amendments and reuse of the existing detached validation checkout.
Initial checkpoint `940e5e76a1f35e3f67bf131b004b3b056f9024ea` passed the complete
maintained routine. API02 applies to the checkpoint: 114/115 API inputs and
107/108 compiled-validation inputs are byte-identical across checkouts; the sole
difference is the existing maintained frozen-manifest CRLF/LF allowance.
All raw Lean sources and pins match, and all 24 rendered extracts were rechecked.
Every amended candidate requires a complete clean rerun and fresh API applicability.
The candidate is validation-ready. Cumulative all-eighteen review, original-report
reconciliation, final validation, F capture and closure require their actual
private source-bound records; this handoff does not anticipate their results.

Finish and reconcile this handoff before final source capture. Later closure is
established only by `.lit-review/setup/c20-05-completion-20261023.json`, when
present, and its linked source-bound completion chain. This prose claims no
future result. Preserve captured status after F rather than editing it merely
to announce closure. C21--C24 and publication remain unselected here.

## Delivered public interface

C20 adds 24 supported declarations: sixteen theorems, three definitions and five
abbreviations. All are in `LeanInfoTheory.Shannon`; `SourceCode.*` below denotes
its nested namespace. There are no new public instances or simp attributes.

| Focused owner | Exact new names and contract |
| --- | --- |
| [Fano](../../LeanInfoTheory/Shannon/Fano.lean) | `decodingErrorProbabilityOf_eq_toOuterMeasure`: the existing error is exactly the original PMF's real failure-event probability, for arbitrary source/value types. |
| [SourceCoding](../../LeanInfoTheory/Shannon/SourceCoding.lean) | `SourceCode`, `BlockSourceCode`: transparent total encoder/decoder pairs and the `Fin n → A` word specialization. |
| SourceCoding | `SourceCode.encoder`, `SourceCode.decoder`, `SourceCode.errorProbability`: projections and an abbreviation of existing Fano error semantics. |
| SourceCoding | `SourceCode.successSet`, `SourceCode.mem_successSet`: finite enumeration and exact membership of actual correct decoding. |
| SourceCoding | `SourceCode.card_successSet_le`, `SourceCode.successProbability_eq_one_sub_errorProbability`: at most M successes and exact success/error complementarity. |
| SourceCoding | `exists_sourceCode_correctOn`, `exists_sourceCode_errorProbability_le`: selected-set recovery, then the same witness's complement error bound. |
| SourceCoding | `SourceCode.successProbability_le`: arbitrary-law success bound from a nonnegative atom cap on a selected set. |
| [CodingRate](../../LeanInfoTheory/Shannon/CodingRate.lean) | `codeRate`, `roundedMessageSize`: rate in nats and the natural ceiling of the target exponential. |
| CodingRate | `codeRate_nonneg`, `codeRate_zero`, `codeRate_one`: positive-budget nonnegativity and zero-length/one-message conventions. |
| CodingRate | `codeRate_le_iff`, `exp_mul_codeRate`: positive-length, positive-budget rate/budget equivalence and exponential recovery. |
| CodingRate | `roundedMessageSize_bounds`, `codeRate_roundedMessageSize_bounds`: all-real size bounds and the nonnegative-target rate sandwich. |
| CodingRate | `ceil_natsToBits_log_le_iff`, `natsToBits_codeRate_pow_two`: minimal fixed binary length and Units conversion. |

### Coding hypotheses and boundary conventions

Write `P_q(E) := (q.toOuterMeasure E).toReal` for exposition only. A code is
`SourceCode X M = (X → Fin M) × (Fin M → X)`; a block source code uses
`X = Fin n → A`. Both maps are total. Operational budgets satisfy `1 ≤ M`.
No global encoder injectivity, inverse law, full support or independence is
assumed. Injectivity holds on the actual success set by correct decoding.

The error abbreviation is exactly
`decodingErrorProbabilityOf q id c.encoder c.decoder`. The generic Fano bridge
requires no finiteness or measurable-space assumptions. Finite success-set
enumeration includes zero-mass values and extra correct decodings outside a
chosen set; neither is discarded. Complement arithmetic justifies finiteness
before converting ENNReal probabilities to Real.

The two existence theorems use `[Finite X]`, not `[Fintype X]`. This is the
explicit Step 2 refinement of the plan's literal finite-carrier wording:
enumeration is internal, the finite-source domain and substantive contracts
are unchanged, and existing Fintype callers synthesize Finite. Statements
exposing the success finset retain `[Fintype X]`. No public DecidableEq premise
was added. The notes retain the refinement and its resolved Step 2 review disposition.

For `T.card ≤ M` and `1 ≤ M`, law-free existence uses `[Nonempty X]` and returns
a code recovering every member of T. Law-based existence obtains nonemptiness
from `q.support_nonempty` and returns one code with both recovery and
`error ≤ P_q((T : Set X)ᶜ)`. Empty T uses an ambient fallback; it never requires
choosing an element of T. Extra successes make this an inequality in general.

For an arbitrary code, `0 ≤ b` and `∀ x ∈ T, (q x).toReal ≤ b` give
`P_q(c.successSet) ≤ P_q((T : Set X)ᶜ) + (M : Real) * b`.
The cap must remain nonnegative even for empty T. No iid, typical-set or rate
assumption enters this finite converse.

A law and encoder force M positive. A raw `SourceCode Empty 0` exists but has
no source PMF and is not operational. In contrast, `Fin 0 → Empty` has the
unique empty word and admits a law. Every zero-length code with a positive
budget recovers that word and has zero error under every law on the word space.

### Rates, ceilings and binary padding

`codeRate n M = log (M : Real) / n` uses nats. Operational normalization needs
`0 < n` and `1 ≤ M`; the totalized value at n=0 is zero. Under those positive
guards, for every real R, rate ≤ R iff `M ≤ exp(nR)`, and exponentiating
length times rate recovers M. Cancellation at zero length is invalid.

For every n and real R, `M := roundedMessageSize n R` satisfies
`1 ≤ M`, `exp(nR) ≤ M` and `M < exp(nR)+1`. For n>0 and R≥0, its rate lies
between R and `R + log 2/n`. The upper rate estimate is not asserted for
negative R. Zero/nonpositive targets give budget one, as does zero length;
an integer exponential is not rounded up by an extra message.

Exactly k binary digits have cardinality `2^k`. For M≥1,
`ceil(natsToBits(log M)) ≤ k` iff `M ≤ 2^k`. Equality of the cardinalities
gives an equivalence; the inequality alone gives an embedding with possible
unused strings. Private actual padding extends the decoder totally and
preserves every recovered output, hence exact error, under every source law.
It changes the message budget and generally the rate. For minimal k and n>0,
`codeRate n M ≤ codeRate n (2^k) < codeRate n M + log 2/n`.
The public bit conversion also holds algebraically at zero length, without
giving that initial value an operational normalized-rate interpretation.

## Ownership and permanent consumers

SourceCoding directly imports Fano and `Mathlib.Data.Fintype.EquivFin`.
CodingRate directly imports Units and `Mathlib.Algebra.Order.Floor.Semiring`.
Neither owner imports the other, iid, TypicalSet, AEP or examples. Fano retains
its three prior direct imports; this boundary is not a measure-free claim.
The full Shannon umbrella imports both new owners. The lightweight root retains
its two direct imports, and the semantic umbrella gains no coding import.

| Private permanent owner | Actual interface pressure |
| --- | --- |
| [Examples.SourceCoding](../../LeanInfoTheory/Examples/SourceCoding.lean) | `lossy_*` checks real encoder collision and exact error/success 1/2; `arbitrary_law_bounds` combines construction/converse; `constructed_fair_singleton` uses the public converse to force the constructed witness's exact error. |
| Same owner | `empty_construction_strict`, `diagonal_*`, `selected_zero_mass_word`, `spare_message_index`: extra successes, strict error inequality, correlated sparse words, guaranteed recovery of an impossible word and an actual unused index. Pure/singleton constructions and `arbitrary_zero_length_code`/`no_zero_message_operational_code` cover operational degeneracies. |
| [Examples.CodingRate](../../LeanInfoTheory/Examples/CodingRate.lean) | Every scalar declaration; `binary_recovered`, `binary_error`, `padded_recovered`, `padded_error` and the minimal-rate consumer use an actual embedding/total decoder. M=3/k=2 has an unused string and fallback; M=1/k=0, integer ceilings and negative/zero boundaries remain explicit. |
| [Examples.SourceCodingTypicalSet](../../LeanInfoTheory/Examples/SourceCodingTypicalSet.lean) | `rounded_typical_family` chooses one dependent family with all-length recovery/error bounds and positive-length rates. `typical_success_bound`, `typical_rate_converse` and `typical_coding_inputs` retain arbitrary-code finite converses beside existing complement convergence. |

All three belong only to the non-stable Examples aggregate. The integration
owner alone imports AEP; it uses public C19 statements, never another example's
private declaration. These private anchors document successful interface
composition, not a supported downstream import surface.

The criterion map identifies evidence and obligations, not a cumulative verdict.

| Exact criterion identifiers | Source or qualification obligation |
| --- | --- |
| C20.01-MODEL, C20.01-ERROR, C20.01-COUNT, C20.01-FEASIBILITY | Core/block pairs, Fano event bridge, success counting and the recorded connected construction checkpoint; current public construction and permanent consumers retain the behavior. |
| C20.02-ACHIEVABILITY, C20.02-CONVERSE, C20.02-ARBITRARY, C20.02-BOUNDARY | Both same-witness existence endpoints, actual-success counting converse, generic/correlated laws and selected-set/message-budget boundaries. |
| C20.03-RATE, C20.03-ROUNDING, C20.03-BITS, C20.03-BOUNDARY | CodingRate endpoints and actual binary transport, exact error, minimal overhead and negative/zero examples. |
| C20.04-CONSUMERS, C20.04-C19, C20.04-ARCHITECTURE | Operational degeneracies, the dependent typical family and arbitrary-code converses, public-interface coverage and preserved import boundaries. |
| C20.05-VALIDATION, C20.05-READINESS, C20.05-HANDOFF | Local API inspection and initial clean qualification; current amended-candidate readiness and all-eighteen review request, canonical reconciliation and this maintained handoff before F. Exact final records govern closure. |

## Registered sources and adaptations

[PW24](../references.md#pw24-polyanskiy-and-wu-newer-draft) is the August 16,
2024 draft, SHA-256
`c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
It is distinct from PW22. Earlier source actors read complete §11.1, printed
212--217/PDF 237--242; the notes retain actor-specific evidence and limits.

Definition 11.1/Theorem 11.2 use detectable erasure and a reserved index.
Remark 11.1, printed 214/PDF 239, permits undetected errors but still allows
erasure outputs. Replacing erasures by a fixed source value preserves prior
successes on a nonempty source. C20 adopts that total-decoder model with all
M indices available. Its arbitrary-T converse generalizes Theorem 11.4's
success-set splitting proof, printed 214--215/PDF 239--240; it is not a
verbatim optimal-erasure theorem. Integer budgets and nats are explicit.

The Step 4 reference audit freshly checked PW24's hash and read complete §11.2,
printed 217--218/PDF 242--243; the parent read its narrow private text extract.
This was text inspection, not fresh visual review. The closed textbook band
and strict proof inequality are not silently identified with C19's strict
supported typical set. C20 preserves that set, its non-strict exponential
atom bounds and its empty zero-length convention. At zero, the complement
bound is loose even though the actual code error is zero.

CT91 §§3.1/3.3 provide AEP/counting context; §3.2, Theorem 3.2.1, printed
53--55/PDF 75--77, concerns variable-length expected description length.
It is not C20's fixed-length almost-lossless endpoint. This handoff preparation
inspected source and recorded reference accounts, without a new PDF extraction,
hash verification or visual review. No reference media, substantial textbook
text or external formalization implementation is included in project changes.

## Exact downstream contracts

### C21: the same source-code model, with limits still to prove

Use unbundled `M : Nat → Nat`, `hM : ∀ n, 1 ≤ M n` and
`c : ∀ n, BlockSourceCode A n (M n)`. Errors use `PMF.iid p n`; rates use
`codeRate n (M n)`. The constructed family has M0=1. Arbitrary converse
families may have any positive M0; their empty-word error and totalized rate
are zero. Finite initialization changes do not alter limits.

For ε>0, the private integration consumer combines the same strict supported
`T_n := weakTypicalSet p n ε`, its complement probability tending to zero,
and one chosen family with `M n := roundedMessageSize n (entropy p + ε)`.
That family retains recovery and the complement error bound at every n and
the rate sandwich at positive n. It assumes neither full support nor H>0.
C21 must derive vanishing code error and achievability above H, using an
intermediate target and the ceiling overhead when appropriate.

Separately, arbitrary codes satisfy
`1-error ≤ P(T_nᶜ) + M*exp(-n*(H-ε))`. At n>0, M≥1 and rate≤R, this gives
`1-error ≤ P(T_nᶜ) + exp(-n*(H-ε-R))`, with arbitrary real R.
C21 owns the eventual-below-H strong source converse and the distinct general
claim that vanishing error implies `∀ δ>0, eventually H-δ ≤ rate`.
An eventual-low-rate converse alone does not establish that claim for
oscillating rates: retain the pointwise bound along low-rate indices.
Use eventual inequalities or EReal liminf/limsup without assuming bounded or
convergent rates. No exact-rate-H theorem or error exponent is supplied.

### C23: distinct channel codes and a weak converse

Channel encoders map `Fin M → (Fin n → A)`; decoders map received words to
`Fin M`, with a uniform message law and M≥1. Reuse scalar rate/budget/bit
conventions and the generic Fano event bridge, not SourceCode with renamed
maps. Induced codewords may be correlated and encoding need not be injective.

C17/C18 supply sampling and information bounds; C22 supplies the capacity cap.
C23 still owns the joint-law/error identification, the finite inequality
`(1-Pe)*log M ≤ n*C(W)+log 2`, and its weak-converse limits. Derive eventual
boundedness from that inequality and vanishing error if using Real limsup.
Distinguish eventual rates above capacity from fixed positive excess
infinitely often: the latter gives a subsequential obstruction, not an
eventual error lower bound. Preserve M=1 and separate n=0. No channel
achievability or error-to-one strong converse is delivered by C20.

## Qualification, remaining work and reopening triggers

The current manifest reports 745 declarations in 49 owners, versus C19's
721/47; root exports remain 92 and reviewed simp names 94. Counts record the
surface, not approval or compiled compatibility. The frozen release remains
601 declarations in 31 owners. Current generated references and canonical
context must be reconciled against the final candidate and linked to this file.

| Disposition | Owner and concrete completion/reopening trigger |
| --- | --- |
| C20.01--C20.04 delivery and source applicability verified. | C20.05 retains predecessor evidence and checks all eighteen criteria cumulatively; earlier step closure does not omit a criterion. |
| Initial authorized checkpoint passed the complete clean routine. | C20.05 retains the granted 24-path/same-scope-amendment authority and protected unrelated intake changes. Reinspect the existing validation checkout and rerun the complete maintained routine after every amendment; final candidate/results are retained privately. |
| Two-pass local API milestone and all-24 declaration inspection passed. | C20.05 retains the initial missing-page failure, bounded generated-marker recovery and actual successful rerun. Reassess exact source/configuration/dependency/output applicability after every amendment and against the clean candidate. |
| Validation-ready candidate; cumulative review and closure require actual private records. | Retain current-candidate validation, contextual self-review, separate reassessment, original-report obligations and explicit dispositions; obtain/reconcile the all-eighteen report, qualify final source and use supported closure. |
| Complement/rate/padding helpers remain private. | Promote only after concrete independent production reuse or documented discovery friction and ownership/API review; private example repetition alone is insufficient. |
| Extra three/four-symbol converse examples not selected. | Reconsider only if a distinct counting/splitting risk appears; attained fair, generic and correlated consumers already exercise required boundaries. |
| Asymptotic source coding and channel converse remain downstream. | Separately approved/selected C21/C23 work, using the contracts above and the roadmap; C20 integration proves no coding-error or operational rate limit. |
| Optimal coding, prefix/variable-length schemes, executable compression, public threshold/sequence frameworks and infinite-source extensions are outside C20. | Require a concrete new need and separate mathematical scope/API decision, not cumulative-closeout expansion. |
| Publication, dependency changes and later chunks are unselected here. | Separate explicit authority; local validation and API documentation are not publication evidence. |

Preserve every actual failure and recovery as such. Record actors, commands,
candidate identity, warm/incremental cache limits and R-to-F applicability;
do not infer a cold build, fresh whole-tree rehash or passing result from counts
or old output. Historical reviewer-context limitations and original reports
remain in the notes and private records; advisory audits are not formal
acceptance. Only the actual completion chain establishes final C20 closure.
