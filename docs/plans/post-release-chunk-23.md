# C23: channel codes and Fano weak converse

<!-- lit-review-status:start -->
**Plan status:** Active revision 2; only C23.06 is selected. Initial authorized clean/API milestones and all 36 rendered inspections passed at their actual recorded inputs.

The exact local C23-only checkpoint, necessary bounded amendments/full clean reruns, reuse of the existing registered validation checkout and separate local API milestone were approved by the actual reply “yes, i approve”. Push, release, publication, C24 and external-project upgrades remain unapproved.

Every bounded amendment, including these documentation updates, requires the entire clean rerun and renewed API applicability before R; rerun the API gate if invalidated. Fresh original review of all 21 criteria, substantive all-criterion reconciliation and final qualification/applicability/capture remain pending. Only actual `.lit-review/setup/c23-06-completion-20261025.json` and its linked genuine original records determine completion; no cumulative SAT assessment or future result is predicted.

C23.01–C23.05 remain closed by their original supported chains. See the [handoff](../handoffs/chunk-23.md) and [notes](post-release-chunk-23-notes.md), Section 23. No new mathematical endpoint, public contract or pin is added.
<!-- lit-review-status:end -->

## 1. Scope and authority

C23 turns the delivered finite-channel information capacity into an operational
upper bound for deterministic block channel codes with uniform messages and
average block error. The principal endpoint is

`(1 - Pe) * Real.log (M : ℝ) ≤ (n : ℝ) * channelCapacity W + Real.log 2`.

Its asymptotic consequences concern arbitrary positive natural message budgets
and actual code families. Neither encoder injectivity, independent input
coordinates, bounded rates nor convergent rates is an assumption.

This proposal authorizes no execution. After approval of the exact plan revision,
one explicit eligible step request selects one step and its review process, then
the parent stops. Formal PLAN review requires its own explicit request. Commits,
clean validation checkpoints and the expensive current API-documentation gate
require their separate approvals; push and publication require separate authority.
No C22 authorization transfers to C23.

Exclude channel-coding achievability, operational/information capacity equality,
an error-to-one channel strong converse, maximal-error equivalence, randomized
encoders/decoders, list decoding, feedback, cost constraints and infinite-alphabet
extensions. Simple exact noiseless codes used as regression consumers do not
constitute a general achievability theorem. No new general code-sequence framework,
channel bundle, optimizer framework or source-coding theorem is requested.

Preserve the existing unrelated changes in `.gitignore`, `AGENTS.md`,
`docs/next-website-tasks.md` and `docs/project-log.md`. Future scoped canonical
updates must preserve their pre-existing content. Do not access unrelated
projects, create Desktop folders or change dependency pins. The lightweight root
and frozen release contract remain intact.

## 2. Prerequisites, sources and adaptation

The [C22 handoff](../handoffs/chunk-22.md) and
`.lit-review/setup/c22-08-completion-20261024.json` establish the completed
predecessor. Intake verified its closure object, original report/reconciliation
references, linked evidence hashes, all 282 captured file entries and the derived
environment against current inputs. The 26-row cumulative matrix and three
native closeout criteria are satisfied in that historical record. These are
fresh correspondence checks, not newly run clean or API builds.

The mathematical dependency chain is C17 raw product/memoryless channel laws,
C18 arbitrary-input information bounds and Markov interfaces, C22 capacity,
the existing uniform-source Fano theorem, and C20 scalar `codeRate` conventions.
C21 supplies a useful unbundled dependent-family convention, not a production
source-code dependency. See the relevant [C18](../handoffs/chunk-18.md),
[C20](../handoffs/chunk-20.md) and [C21](../handoffs/chunk-21.md) handoffs.

Use the exact registered editions and hashes in [references](../references.md).

| Source | Selected material and adaptation |
| --- | --- |
| CT91 §§8.5/8.9, printed 192–194 and 204–207; PDF 214–216 and 226–229 | Deterministic indexed codes, uniform-message average error, arbitrary-input memoryless bound, Fano converse and quantitative obstruction. Replace bit units and informal `2^(nR)` sizes by nats and arbitrary positive natural `M`. Keep the message index as the Fano source even when encoding collides. The extension from fixed `R` to arbitrary rate sequences requires a derived bound, not a presumed limit of `Pe_n * r_n`. |
| PW24 §17.1, Definition 17.1/(17.1), printed 342–343; PDF 367–368 | Actual message/input/output/decoded-message sampling model. Select total deterministic decoders to `Fin M`; no reserved erasure index. Messages, rather than distinct codewords, remain equiprobable. |
| PW24 §17.4, Theorem 17.3, printed 348–349; PDF 373–374 | Weak converse context. Use the library's Fano theorem and the undivided `log 2` bound, including `Pe=1`; do not import a denominator `1-Pe` without positivity. The alternative test proof's error-indicator definition disagrees with its displayed success probabilities; use the verified existing Fano route. |
| PW24 §19.1 and start of §19.2, Definitions 19.1–19.3/19.6, Theorem 19.7, printed 371–376; PDF 396–401 | Repeated stationary memoryless channel and rate conventions. Distinguish information capacity from operational definitions. No `M*`, epsilon-capacity, expurgation equivalence or achievability API is added. |

The notes record exact reading and visual checks. Do not reproduce textbook
proofs or private reference media in tracked documentation.

## 3. Normative mathematical contracts

The notation below specifies mathematical meaning. Proposed new declaration
names are identified in Section 4; they are not claims of existing Lean APIs.
Let `A : Type u` and `B : Type v` have independent universes.

<a id="code-law-contract"></a>
### 3.1 Code, sampling law and error

Use a transparent deterministic block-code pair, with no recovery or injectivity
field:

```lean
abbrev BlockChannelCode (A : Type u) (B : Type v) (n M : ℕ) :=
  (Fin M → (Fin n → A)) × ((Fin n → B) → Fin M)
```

The encoder and decoder have the displayed orientations. The raw pair needs no
finiteness instances. Operational laws and theorems have explicit `hM : 1 ≤ M`;
derive `Nonempty (Fin M)` locally. There is no uniform law on `Fin 0` and no
operational zero-message convention. The raw pair alone need not encode validity.

For `W : A → PMF B`, `[Fintype B]`, a code `c`, and `hM`, put
`U := PMF.uniformOfFintype (Fin M)`, `K := PMF.memorylessChannel W n`, and
`q := U.map c.encoder`. Construct the actual laws using existing PMF operations:

```text
J = PMF.channelJoint U (fun m => K (c.encoder m))
Q = PMF.channelExtension
      (PMF.channelJoint U (PMF.deterministicChannel c.encoder)) K
```

`J` has type `PMF (Fin M × (Fin n → B))` and `Q` has the right-associated
type `PMF (Fin M × (Fin n → A) × (Fin n → B))`. Identify all of the following:

- The message marginal is `U`, the input marginal is `q`, and the output
  marginal is `q.bind K`.
- The message/input marginal is the graph pushforward
  `U.map (fun m => (m, c.encoder m))`.
- The input/output marginal is `PMF.channelJoint q K`.
- The message/output marginal of `Q` is exactly `J`.

Define `Pe` by the existing `decodingErrorProbability J c.decoder`. Prove exact
agreement with `decodingErrorProbabilityOf Q` for the message and output
projections, and with the real error-event probability. Expose the finite
average-error formula

```text
Pe = (1 / (M : ℝ)) * ∑ m, ∑ y,
       if c.decoder y ≠ m then (K (c.encoder m) y).toReal else 0.
```

Reuse existing Fano indicator, finite-sum/event and range results; obtain
`0 ≤ Pe ≤ 1`. Do not replace message identity by a codeword equivalence class,
infer a uniform law on the encoder image, or divide by a zero fiber probability.
Raw-law results need no `[Fintype A]` or `[Nonempty A]` merely for convenience.

<a id="finite-converse-contract"></a>
### 3.2 Markov, data processing and finite bounds

Under `Q`, establish message → input → output and message → output → decoded
message using the existing predicates. Identify the sampling laws in the actual
theorems, not only a statement about an unrelated abstract Markov triple. Obtain

```text
I(message; decoded message) ≤ I(message; output)
I(message; output) ≤ I(input; output)
I(input; output) ≤ (n : ℝ) * channelCapacity W.
```

The last step must consume
`mutualInfo_channelJoint_memorylessChannel_le W n q` for the actual possibly
correlated `q`. Capacity-bearing results retain `[Fintype A] [Nonempty A]
`[Fintype B]`; derive output nonemptiness from a row if needed. Do not form the
base capacity on an empty input alphabet, including when `n=0`.

Apply `mutualInfo_fano_lower_bound_of_uniform_source` to `J` and its proved
uniform first marginal to obtain the principal finite-block bound for every
`n : ℕ` and `M ≥ 1`. Do not add `M ≥ 2`, `n > 0` or `Pe < 1` to that endpoint.
The stronger equality of message/output and input/output information may stay
private; it is not an additional completion requirement.

For `0 < n`, expose the normalized inequality

`(1 - Pe) * codeRate n M ≤ channelCapacity W + Real.log 2 / (n : ℝ)`.

For `0 < n`, `0 < R` and `R ≤ codeRate n M`, expose the pointwise consequence

`1 - channelCapacity W / R - Real.log 2 / ((n : ℝ) * R) ≤ Pe`.

Use `Pe ≤ 1` when replacing the actual rate by its lower bound. An assumption
`R > channelCapacity W` is needed for the positive asymptotic obstruction, not
for this algebraic pointwise inequality.

<a id="vanishing-error-contract"></a>
### 3.3 Vanishing error, derived boundedness and real limsup

Fix one channel and unbundled data
`M : ℕ → ℕ`, `hM : ∀ n, 1 ≤ M n`, and
`c : ∀ n, BlockChannelCode A B n (M n)`. Write
`e n := (c n).errorProbability W (hM n)` and `r n := codeRate n (M n)`.
All limits and eventual/frequent statements use `Filter.atTop` on `ℕ`.

From `Tendsto e atTop (nhds 0)`, prove

```text
∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, r n ≤ channelCapacity W + δ
Filter.limsup r atTop ≤ channelCapacity W.
```

Derive an eventual upper bound on `r` from the finite inequality and vanishing
error before invoking a conditionally complete real limsup theorem. One suitable
bound is `r n ≤ 2 * (channelCapacity W + Real.log 2)` eventually, using
`e n ≤ 1/2` and `n ≥ 1`. Nonnegativity of `codeRate` supplies the needed lower
control/coboundedness. Do not assume a bounded range, a rate limit, an eventual
rate cap, or convergence of the product `e n * r n`. No global positive-length
hypothesis is imposed on a family indexed by all naturals.

<a id="above-capacity-contract"></a>
### 3.4 Two different above-capacity conclusions

For the same arbitrary family, with no vanishing-error premise:

1. If `channelCapacity W < R` and `∀ᶠ n in atTop, R ≤ r n`, prove
   `∀ᶠ n in atTop, 1 - channelCapacity W / R -
   Real.log 2 / ((n : ℝ) * R) ≤ e n`.
   Derive `R > 0` from capacity nonnegativity. Prove an eventual positive
   obstruction, for example `ε = (1 - channelCapacity W / R) / 2 > 0` with
   `∀ᶠ n in atTop, ε ≤ e n`, and consequently failure of `e → 0`.
2. If some fixed `η > 0` satisfies
   `∃ᶠ n in atTop, channelCapacity W + η ≤ r n`, prove failure of `e → 0`.
   This is the chosen explicit infinitely-often formulation. Neither boundedness
   nor convergence of the rates is required. It does not conclude an eventual
   positive error bound. A quantitative frequent error bound may be a private
   consumer consequence; no public EReal limsup equivalence is required.

The real limsup theorem in Section 3.3 is under vanishing error, where boundedness
has been derived. It must not be repurposed as an unguarded characterization of
the arbitrary, possibly unbounded sequences in item 2.

<a id="boundary-contract"></a>
### 3.5 Boundary behavior

- `M=1`: error is zero for every code/channel/blocklength and `codeRate n 1=0`.
- `n=0`, `M≥1`: the received empty word is unique, so error is exactly
  `1 - 1 / (M : ℝ)`. The undivided finite inequality still applies.
  `codeRate 0 M=0` is a scalar convention, not a legitimate normalization.
- `n=1`: the laws/error and finite theorem specialize to the original channel.
- Preserve zero atoms, unused message indices at the decoder, singleton
  alphabets, and collisions on messages of positive uniform mass.
- Raw zero-word laws may exercise empty base types without evaluating a base
  `channelCapacity` outside its established domain. Empty output rows with an
  inhabited input are impossible, not a new capacity convention.

## 4. Ownership and public surface

Choose three focused owners to keep the code-law interface independent of
capacity optimization and keep limit imports out of finite consumers:

| Proposed owner | Intended declarations and direct imports |
| --- | --- |
| `Shannon.ChannelCode` | `BlockChannelCode`, its `encoder`/`decoder`, `messageOutputLaw`, `messageInputOutputLaw`, `errorProbability`, exact marginal/error/range and boundary contracts. Direct project imports: `Shannon.Fano`, `Probability.ProductChannel`. The existing error API already requires Fano; no new Probability module or competing error definition. |
| `Shannon.ChannelCoding` | Code-specific Markov/DPI interface, undivided Fano-capacity bound, normalized and positive-rate error forms. Direct project imports: `Shannon.ChannelCode`, `Shannon.ProductChannelCapacity`, `Shannon.CodingRate`. Markov tools are available in the inspected capacity dependency closure. |
| `Shannon.ChannelCodingAsymptotic` | Eventual rate cap, derived-bound proof, real limsup, eventual and infinitely-often error obstructions. Direct project import: `Shannon.ChannelCoding`; focused mathlib limit/limsup imports as required. |

New names are proposed, not implemented or compiler-verified. Use the
`LeanInfoTheory.Shannon.BlockChannelCode` namespace for code-specific operations
and theorem families, with existing `..._eq_...`, `..._le_...`, `eventually_...`,
`limsup_...` and `..._of_...` vocabulary. Prefer `errorProbability` to inventing
a second average-error name. Review final signatures/names for discovery before
growth approval. Elementary projection/error glue should be exposed only where
the planned finite theorem or independent consumers need it; other helpers stay
private. No standalone message-law wrapper or general sequence structure is needed.

The following signature schemas fix the intended exported endpoints without
claiming elaborated Lean declarations. Use the code/law arguments of Section 3.1
and family data of Section 3.3; `C := channelCapacity W`, `L := Real.log 2`,
`Pe := c.errorProbability W hM`, `r n := codeRate n (M n)`, and
`e n := (c n).errorProbability W (hM n)`. Every capacity-bearing row retains
`[Fintype A] [Nonempty A] [Fintype B]`. Budgets have explicit positive proofs;
family statements use `atTop` on all naturals, without global `n>0` hypotheses.

| Public endpoint | Required hypotheses and conclusion |
| --- | --- |
| Finite Fano-capacity bound | `hM : 1 ≤ M` gives `(1-Pe) * log M ≤ n*C + L`, including `n=0` and `Pe=1`. |
| Normalized bound | Additionally `0<n` gives `(1-Pe) * codeRate n M ≤ C + L/n`. |
| Pointwise error lower bound | `hM : 1 ≤ M`, `0<n`, `0<R` and `R ≤ codeRate n M` give `1-C/R-L/(n*R) ≤ Pe`; no `C<R` premise. |
| Eventual rate cap and real limsup | `Tendsto e atTop (nhds 0)` gives each `δ>0` eventual `r n ≤ C+δ`, and separately `Filter.limsup r atTop ≤ C`. Boundedness is derived internally. |
| Eventual quantitative error lower bound | `C<R` and eventual `R ≤ r n` give eventual `1-C/R-L/(n*R) ≤ e n`. |
| Eventual positive error obstruction | The same premises give `0 < (1-C/R)/2` and eventual `(1-C/R)/2 ≤ e n`, together with the failure-of-vanishing-error consequence. |
| Infinitely-often error obstruction | `η>0` and frequent `C+η ≤ r n` give `¬ Tendsto e atTop (nhds 0)`, with no rate-boundedness premise or eventual-error-floor conclusion. |

The model operations, finite average-error formula, error range and zero/one
boundary contracts form the public `ChannelCode` interface. Expose the marginal
identifications and actual-law Markov/DPI facts needed across module boundaries
or by the required independent consumers. Keep the derived eventual boundedness
lemma, limsup side-condition glue, optional MI equality, and consumer-specific
equivalence/power/parity calculations private unless an actual downstream use
justifies promotion. Final spelling and minimal grouping of public declarations
are checked in the owning step; these schemas are not an alias or API-count quota.

Add supported owners to the full `LeanInfoTheory.Shannon` umbrella and reviewed
current API/import policy at their selected steps. Do not import them into
`LeanInfoTheory.lean` or the semantic-bridge aggregate. Keep examples private in
separate `Examples.ChannelCode`, `Examples.ChannelCoding` and
`Examples.ChannelCodingAsymptotic` owners, reached only through `Examples`.
Standard-channel consumers may import `StandardChannelCapacity`; production
coding modules must not acquire that dependency.

Preserve Lean/mathlib `v4.33.1`, all other pins, historical signatures and root
exports. New project Lean files use the exact EPFL/MIL header. No new simp policy
is presumed; any attribute needs explicit terminating-use justification and
reviewed inventory. The allowed axioms remain `propext`, `Classical.choice` and
`Quot.sound`; no placeholders, unsafe shortcuts or stronger convenience premises.

## 5. Ordered steps and acceptance criteria

Each criterion below is normative. The owning step must provide source and
independent consumer evidence, applicable validation records and source-bound
review under Sections 6–7. The parent owns implementation/reconciliation;
the persistent reviewer independently assesses criteria. These are six review
boundaries chosen by dependency and mathematical risk, not an API-count target.

<a id="c23-01"></a>
### C23.01 — deterministic codes, actual laws and average error

**Dependencies:** Section 2 prerequisites; no earlier C23 step.
**Ownership:** `ChannelCode`, its focused consumer and supporting integration.

- **C23.01-MODEL:** Deliver the transparent block pair with the exact encoder/decoder orientations, explicit positive-budget operational interface, independent alphabet universes and no recovery, injectivity or independence fields.
- **C23.01-LAWS:** Construct `J` and `Q` and prove all message/input/output and pair-marginal identifications in Section 3.1 using existing raw PMF channel constructions, retaining message identity under collisions.
- **C23.01-ERROR:** Identify the same error with the existing Fano PMF/RV/event definitions and the uniform finite average formula; prove its range without a replacement indicator or unjustified probability division.
- **C23.01-BOUNDARIES:** Prove and independently consume `M=1` zero error, arbitrary-positive-budget `n=0` error `1-1/M`, and a one-letter law/error reduction. Include the unequal-fiber `Fin 3` noiseless Boolean code: messages 0/1 encode `false`, message 2 encodes `true`, and decoding selects 0/2. Check induced input masses `2/3` and `1/3` and actual error `1/3`, preserving distinct positive-mass colliding messages; no new finiteness/nonemptiness premises on raw laws beyond their construction needs.

**Validation/review:** Focused producer and consumer, Shannon/Examples aggregates,
actual signatures through focused/umbrella imports, static/generated and compiled
compatibility/trust checks. Review the finite average formula and association of
the triple especially carefully. No capacity or asymptotic endpoint is selected.

<a id="c23-02"></a>
### C23.02 — Markov/DPI bridge and finite Fano converse

**Dependencies:** Closed C23.01 and C22's arbitrary-input capacity bound.
**Ownership:** `ChannelCoding` and its focused consumer.

- **C23.02-PROCESSING:** Establish the two actual-law Markov chains and both information-processing inequalities of Section 3.2, with correct coordinate order and no null-fiber interpretation.
- **C23.02-FINITE:** Prove `(1-Pe)*log M ≤ n*C(W)+log 2` for every natural blocklength and positive message budget, applying existing uniform-source Fano and the existing capacity bound to the actual encoder pushforward.
- **C23.02-NORMALIZED:** Deliver the normalized rate and positive-rate pointwise error bounds with exactly the positivity hypotheses needed for division; preserve `Pe=1` in the undivided result and derive the signs used in multiplication.
- **C23.02-CONSUMERS:** Consume the complete law-to-Fano-to-capacity chain for a `Fin 4` repeated-bit colliding encoder with a correlated two-letter law and actual error `1/2` over the noiseless Boolean channel; also apply the finite theorem at `M=1`, `n=0` and `n=1` through focused imports.

**Validation/review:** Step checks from C23.01 plus dependency/owner auditing for
CodingRate/Units interaction. Inspect elaborated ownership early, in view of
C22's resolved generated-equation collision. No Units implementation change or
trust-policy relaxation is authorized. No asymptotic theorem is selected.

<a id="c23-03"></a>
### C23.03 — vanishing-error rate cap and real limsup

**Dependencies:** Closed C23.02; existing C20 rate and pinned filter/limit tools.
**Ownership:** `ChannelCodingAsymptotic` and its focused consumer.

- **C23.03-BOUNDEDNESS:** Derive eventual rate boundedness from the finite bound and vanishing error, with an explicit finite bound and lower/coboundedness justification; no bounded-rate or rate-convergence premise may appear in the result or be hidden in a helper's use.
- **C23.03-TOLERANCE:** Prove every positive-tolerance eventual rate cap in Section 3.3 for one arbitrary dependent code family, allowing arbitrary behavior at finitely many lengths and all positive natural budgets.
- **C23.03-LIMSUP:** Obtain the real limsup upper bound using the derived boundedness/coboundedness and the tolerance theorem, without identifying real limsup with an arbitrary unbounded-sequence convention.
- **C23.03-CONSUMERS:** Apply both endpoints to actual singleton-message families and a lossless noiseless family with nonconvergent rates (alternating one message and all binary words). Consumer code data, not just scalar sequences, must underlie the applications. An additional genuine finite-prefix mutation and limit-transfer fixture is optional proof-pressure coverage; arbitrary finite-prefix behavior remains part of the required theorem contract, and zero/one-length consumers remain mandatory.

**Validation/review:** Focused finite/asymptotic owners and consumers, both
aggregates, signature and trust/compatibility/static checks. Review the precise
filter quantifiers and each boundedness premise used by real limsup. General
above-capacity obstruction theorems remain C23.04.

<a id="c23-04"></a>
### C23.04 — eventual and infinitely-often above-capacity obstructions

**Dependencies:** Closed C23.03, with finite pointwise bounds from C23.02.
**Ownership:** `ChannelCodingAsymptotic` and its focused consumer.

- **C23.04-EVENTUAL:** Under eventual `R ≤ r n` and `C(W)<R`, prove the exact eventual quantitative lower bound in Section 3.4, an explicit eventual positive error floor and failure of vanishing error, deriving `R>0` rather than assuming a bounded rate family.
- **C23.04-FREQUENT:** Under a fixed positive rate gap infinitely often, prove failure of vanishing error for arbitrary possibly unbounded rates, using the explicit frequent formulation and no eventual-above-capacity premise or unguarded real limsup.
- **C23.04-SEPARATION:** Provide actual code-family consumers showing the two premises have different consequences. For the eventual premise, use the noiseless Boolean channel with positive capacity `log 2`, budgets `M n = 4^n`, and constant encoding/decoding: prove actual error `1-1/(4^n)` and rate `2*log 2` for `n>0`; specialize the public pointwise bound with `R=2*log 2` to `Pe_n ≥ 1/2-1/(2*n)`, including the finite nonvacuous instance `n=2`, `M=16`, `Pe≥1/4`, and separately apply the public eventual obstruction. For the frequent premise, retain a zero-capacity constant-output channel with singleton budgets on even lengths and `2^(n*n)` on odd lengths. Prove unbounded rate spikes, infinitely many error-zero lengths and no eventual positive error floor.

**Validation/review:** Standard step checks plus direct review of denominator
signs, frequent/eventual negations and the two concrete families. Do not infer an
error-to-one strong converse or eventual obstruction from the weaker premise.

<a id="c23-05"></a>
### C23.05 — independent integration consumers and API reconciliation

**Dependencies:** Closed C23.01–C23.04.
**Ownership:** Private consumer modules, reviewed API policy/inventory and
mathematical/reference documentation. No new mathematical theorem family.

- **C23.05-STANDARD:** Consume the public coding bound with all four delivered standard capacities. Include one-letter noiseless identity, input-independent output, BSC identity decoding with actual error equal to crossover, and BEC total erasure fallback with actual error equal to half the erasure probability; retain endpoints and at least one interior noisy value.
- **C23.05-INTEGRATION:** Check the complete same-code/same-channel sampling, error, information, rate and limit interfaces; retain both unequal-fiber and correlated collision fixtures, singleton and zero/one lengths, nonconvergent lossless rates, the positive-capacity finite/eventual obstruction and unbounded intermittent-rate consumers from prior steps. The additional finite-prefix mutation fixture remains optional. Do not substitute generic scalar inequalities or import example-private helpers into production.
- **C23.05-API:** Reconcile actual public names/types/owners/direct imports/simp sets, source adaptations, generated inventory and website references; verify focused downstream usability and preserved historical/root contracts, with helpers kept private absent concrete consumer pressure.

**Validation/review:** Build all C23 producers/consumers and important aggregates;
run static, documentation and compiled compatibility/trust gates. Independently
consume public theorems rather than reprove their conclusions locally. Cumulative
clean/API qualification and fresh all-criterion review remain the final step.

<a id="c23-06"></a>
### C23.06 — cumulative qualification, reconciliation and C24 handoff

**Dependencies:** Closed C23.01–C23.05 and separately approved validation actions.
**Ownership:** C23 parent, same persistent reviewer, canonical documentation and
`docs/handoffs/chunk-23.md`. No new mathematical endpoint.

- **C23.06-VALIDATION:** Qualify the complete candidate with the maintained clean suite on a separately authorized exact clean checkpoint, rerunning it after every amendment; complete the separately authorized current two-pass API-documentation milestone and inspect every new rendered signature, hypothesis, docstring, owner and source link. Preserve failures and distinguish new checks from reused applicable evidence.
- **C23.06-READINESS:** Before cumulative dispatch, finish owned edits, retain actual validation, contextual self-review and separate reassessment, and reconcile earlier accepted reports/findings at their actual sources. Supply a neutral current-source request and an exact matrix of every approved C23 criterion, without claiming a future review outcome.
- **C23.06-HANDOFF:** Maintain `docs/handoffs/chunk-23.md` and canonical links before final capture, recording delivered APIs/imports/consumers, mathematical adaptations, review/validation identities and limits, unresolved/deferred dispositions with owners and triggers, and C24 prerequisites. Make no release, operational-capacity-equality or publication claim.

After readiness, obtain a fresh original independent review of **all approved
C23 criteria**, including cumulative readiness, validation and handoff. Reconcile
every accepted report and original criterion assessment substantively. A reviewer
gap/contradiction requires a new satisfactory assessment, not an implementer
override. Final validation, R-to-F applicability and supported private closure
follow Section 7. Earlier source-specific reports remain intact. Completion does
not select C24 or authorize publication.

## 6. Validation and capture policy

For each selected implementation step, capture the actual baseline B, reviewed
source R and final source F distinctly. Scope the owning modules, reused local
and pinned declarations, consumers, configuration/pins, plan/notes, reviewed API
policy and applicable canonical/generated documents. The helper does not infer
imports. Include relevant dirty/untracked paths explicitly and preserve unrelated
changes. Keep `.lit-review`, build output and copyrighted media outside captures.

Run serialized focused checks through the maintained validator:

```text
python scripts/validate_release.py focused <touched owners and consumers> LeanInfoTheory.Shannon LeanInfoTheory.Examples
python scripts/validate_release.py static
python scripts/validate_release.py documentation
python scripts/validate_release.py trust
```

Regenerate the current API manifest and source-derived website artifacts after
approved public changes, and check the frozen manifest without modifying it.
Inspect public elaborated signatures and axioms through focused imports and the
full Shannon umbrella. Review generated-equation ownership early; source counts
alone are insufficient. No API count or alias quota is predetermined.

The final complete maintained `python scripts/validate_release.py` needs an
authorized clean committed candidate. Do not commit unrelated work or weaken
hygiene to make it run. Prefer an inspected suitable registered validation
checkout under the repository's `.worktrees/` when separately approved.

The expensive `python scripts/validate_release.py api-docs` is a separate
milestone, not a routine per-step gate. C23.06 requires its separate approval,
reviewed Windows Zig 0.16.0 via `LEANINFOTHEORY_ZIG`, and both actual build/check
passes. Use local file links unless a clean exact-commit source-link mode is
separately selected. Retain source/configuration/dependency/output identities and
reassess applicability after every amendment. Historical C22 API output cannot
qualify changed C23 code. Neither clean validation nor API checks authorize a push,
release or website publication.

## 7. Review boundaries and completion

Use the installed [protocol](../review-protocol.md) and
[operations](../review-operations.md). The actual implementation parent owns its
new C23 binding. Requested settings are `gpt-6-astra`/`ultra`, parent-history
copying disabled; observable effective settings remain unknown. The bound
transport is `collaboration`, with later idle-reviewer dispatch through
`followup_task` and original completion capture through actual `list_agents`.
Preserve full native results and exact extracted text. A bootstrap acknowledgement
is neither formal review nor evidence satisfying a plan criterion.

Formal PLAN review waits for an explicit request. Exact plan approval and each
one-step execution selection remain separate authorities. Approved normative
requirements stay fixed; evolving proof advice belongs in the notes. Escalate
changes to mathematical meaning, required scope, important public contracts,
acceptance policy or pins; do not silently strengthen assumptions or weaken endpoints.

For a selected step, retain initial validation, read-only contextual self-review
and separate recommendation reassessment before dispatch. Send the reviewer a
self-contained neutral source-bound request with exact criteria, dependencies,
normative reference anchors and the library rubric. Do not send implementation
transcripts, private verdicts or expected findings. Preserve original reports,
failed checks, uncertainty and every substantive reconciliation/disposition.

Finish source, documents and handoff before F. Keep human-readable status
conditional where necessary; only the supported private completion record proves
closure. Revalidate final source and R-to-F applicability, renewing review where
materially invalidated. Record the actual closure reference privately and in the
user report, without a post-F edit that invalidates the captured candidate. Then stop.

## 8. Decisions requested from the lead

1. Approve or revise this exact six-step mathematical plan and three-owner split,
   including explicit `M≥1` laws, raw-law minimal assumptions and exact zero-length
   channel error.
2. Approve the selected asymptotic surface: derived boundedness plus real limsup
   under vanishing error, and an explicit infinitely-often positive-gap obstruction
   for arbitrary rates; no additional EReal-limsup equivalence is required.
3. Approve the consumer commitments and cumulative validation requirements.
   Actual clean checkpoints, API gates and publication retain separate action
   approvals. The immediate next action remains the lead's choice: request formal
   PLAN review or approve a particular revision; neither is inferred from silence.

After exact plan approval, implement only one explicitly requested C23 step with
its review process and stop. No step is selected by this proposal.
