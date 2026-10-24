# C22: attained finite-channel information capacity

<!-- lit-review-status:start -->
**Plan status:** Active — approved revision 2, 2026-10-24.
C22.01–C22.07 and their reviews are closed; only C22.08 is selected. The lead
separately approved the exact scoped local checkpoint/bounded amendments and
current two-pass API-documentation gate. Initial clean and API milestone checks
passed, with substantive inspection of all 26 new rendered declarations. Every
amendment still requires the full clean rerun and current API applicability.
Qualification and readiness evidence is prepared. Actual cumulative review,
substantive reconciliation, final applicability and closure are established only
by `.lit-review/setup/c22-08-completion-20261024.json` and its linked evidence;
no future outcome is asserted. Step 8 adds no mathematical endpoint.
See the [notes](post-release-chunk-22-notes.md)
and [maintained handoff](../handoffs/chunk-22.md). The retained revision-1 PLAN
report remains historical. C23 is unstarted; operational capacity equality is
outside C22 and release qualification remains after C24. No push/publication
is authorized.
<!-- lit-review-status:end -->

## 1. Scope, prerequisites and authority

C22 delivers finite-channel **information** capacity: an attained supremum of
the existing `mutualInfo (PMF.channelJoint p W)` objective, its elementary
properties, finite-product additivity, memoryless specialization, and all four
selected examples. Quantities are Real-valued nats. Explicit bits interpretations
use the existing `Shannon.Units` scalar conversion.

C15 compactness/continuity and C17/C18 product-channel mathematics are the
mathematical prerequisites. C21 is the preceding completed project milestone,
not a mathematical dependency of capacity. Its actual completion chain is
`.lit-review/setup/c21-05-completion-20261023.json`, final checkpoint
`33a367ace4fec271956974474b982a5c7a654a3b`. Planning intake verified its linked
closure, original report/reconciliation, evidence hashes and current source
applicability; historical provisional prose does not reopen it. Recheck
applicability before execution rather than assuming the checkout stayed fixed.

Preserve unrelated changes, including the intake modifications to `.gitignore`,
`AGENTS.md`, `docs/next-website-tasks.md`, and `docs/project-log.md`. A later
scoped canonical/log update must preserve their pre-existing bytes/meaning.
No dependency-pin change, commit, push, publication, C23 implementation or
unrelated-project modification is authorized by this plan proposal. Auxiliary
work stays inside authorized repository paths; no new Desktop folders.

There is no operational channel-capacity equality here. Channel codes and the
Fano weak converse belong to C23; channel achievability remains outside the
second-release commitment. C24 integration precedes release qualification and
separately authorized publication. Constrained/infinite-alphabet capacity,
minimax/information radius, uniqueness, algorithms, arbitrary symmetric-channel
classification, Z-channels, feedback and channel strong converses are excluded.

## 2. Exact sources and adaptations

Use the editions and hashes in [references](../references.md): CT91, Wiley
1991, and PW24, August 16, 2024 prepublication draft. The notes retain exact
reading ranges and visual checks. Source scope is:

| Source | Mathematical contract and limitation |
| --- | --- |
| CT91 8.1–8.3, printed 184–191 / PDF 206–213 | Equation (8.1), universal upper bounds and achieving uniform laws in 8.1.1, 8.1.4 and 8.1.5; (8.2)–(8.16); properties in 8.3. Convert bits to canonical nats. 8.2/Theorem 8.2.1 is context, not a required general weak-symmetry API. |
| PW24 Chapter 5, printed 91–105 / PDF 116–130 | Theorem 5.3 gives existing input concavity. Theorem 5.4 **assumes** an achieving input; it is not the attainment proof. Theorem 5.9 concerns an optimal output in a more general setting; do not substitute it for finite-input attainment. Gaussian, minimax and algorithmic sections do not expand C22 scope. |
| PW24 6.1, Theorem 6.1(a), printed 106–107 / PDF 131–132 | The upper bound concerns arbitrary input laws through conditional product channels; independent coordinate maximizing laws supply the matching lower bound. C18 already supplies the relevant MI facts. |
| PW24 19.3, printed 379–381 / PDF 404–406 | BSC and BEC capacity computations. Preserve full parameter interval and degenerate cases. Do not copy the unqualified “iff uniform” assertions at BSC 1/2 or BEC 1. The BEC calculation must retain the erasure probability in conditional entropy; the displayed draft omits that weight. |

Attainment follows from continuity on a **nonempty compact** finite-PMF domain,
not merely from boundedness or concavity. For BEC the required exact identity is
`I(p,Wε) = (1-ε) * H(p)`. No division by ε or `1-ε`, nor interpretation of
a null conditional fiber, is needed. These adaptations govern intended meaning
even where informal textbook expressions omit boundary qualifications.

## 3. Normative mathematical contracts

In prose only, write `I(p,W) := mutualInfo (PMF.channelJoint p W)` and
`C(W) := channelCapacity W`. These abbreviations do not request new objective
definitions. Ordinary alphabets have independent universes.

<a id="capacity-contract"></a>
### 3.1 Capacity, attainment and order interface

For independent finite input/output alphabets and a nonempty input alphabet,
define with the domain assumptions explicitly bound:

```lean
noncomputable def channelCapacity {A : Type u} {B : Type v}
    [Fintype A] [Nonempty A] [Fintype B] (W : A → PMF B) : ℝ :=
  sSup (Set.range (fun p : PMF A => mutualInfo (PMF.channelJoint p W)))
```

The explicit `[Nonempty A]` binder is part of the definition's public contract;
an unused ambient section instance can be dropped by Lean elaboration.
Inspect the actual elaborated signature in C22.01 before dependent results.
Do not expose the empty-input `Real.sSup` default as a capacity convention.
Prove, without extra premises:

1. `I(p,W) ≤ C(W)` for every `p : PMF A`.
2. `C(W) ≤ r ↔ ∀ p : PMF A, I(p,W) ≤ r`, for every real `r`.
3. `∃ p : PMF A, I(p,W) = C(W)`, with an actual PMF witness.
4. `0 ≤ C(W)`, `C(W) ≤ log (Fintype.card A)`, and
   `C(W) ≤ log (Fintype.card B)` (cardinals coerced to Real).

Nonempty objective range and boundedness must be established before applying
conditionally complete Real supremum lemmas. Derive `Nonempty B` internally
from a supplied row `W a` and its nonempty support whenever needed. No separate
output-inhabited hypothesis, full-support premise, positive-mass premise or
chosen-maximizer definition is allowed for these endpoints.

<a id="processing-contract"></a>
### 3.2 Relabeling and postprocessing

For equivalences `e : A ≃ A'` and `f : B ≃ B'`, with finite renamed alphabets,
put `W' a' := (W (e.symm a')).map f`. Prove `C(W') = C(W)`; transport
input nonemptiness through `e` locally. Pure input and pure output relabeling
are specializations, exercised separately by consumers. This is simultaneous
law/channel transport, not invariance under changing labels in one argument only.

For any finite-output channel `V : B → PMF D`, prove
`C(PMF.channelComp W V) ≤ C(W)`. For any map `g : B → D` into a finite type,
prove `C(fun a => (W a).map g) ≤ C(W)`. Derive output nonemptiness when used;
no injectivity premise on postprocessing. These inequalities must follow for
all original input laws. The second-stage bottleneck `C(W;V) ≤ C(V)` is not
a separate required endpoint.

<a id="product-contract"></a>
### 3.3 Product channels and arbitrary block inputs

For `{J : Type u}`, `{A : J → Type v}`, `{B : J → Type w}`,
`[Fintype J] [∀ j, Fintype (A j)] [∀ j, Nonempty (A j)]`
and `[∀ j, Fintype (B j)]`, let `W : ∀ j, A j → PMF (B j)`.
Prove

```text
C(PMF.productChannel W) = ∑ j, C(W j).
```

The upper bound must pass through the actual marginals of **every**
`q : PMF (∀ j, A j)`:

```text
I(q, PMF.productChannel W)
  ≤ ∑ j, I(q.map (fun x => x j), W j)
  ≤ ∑ j, C(W j).
```

The lower bound chooses actual achieving `p j` and applies the existing identity
for `PMF.finiteProduct p`. Prove this product law attains the sum. Independence
is a construction for the lower witness; it never restricts the supremum's domain.
Do not introduce a second product-channel construction or a binary-only detour.

For ordinary finite `A,B`, `[Nonempty A]`, `W : A → PMF B` and every `n : ℕ`:

```text
C(PMF.memorylessChannel W n) = (n : ℝ) * C(W)
∀ q : PMF (Fin n → A),
  I(q, PMF.memorylessChannel W n) ≤ (n : ℝ) * C(W).
```

If `p` achieves `C(W)`, the law `PMF.iid p n` must be shown to achieve
the repeated capacity, using the existing independent-input identity.
No `n > 0`, nonempty index, input independence or output independence premise
may enter these statements. Empty products are singleton word spaces with
capacity zero. An inhabited component input plus its channel supplies inhabited
component output. At `n=0`, a vacuous base channel with empty base types can
also be tested directly on its singleton word domain, without forming `C(W)`
on the empty base input.

<a id="examples-contract"></a>
### 3.4 Four required standard examples

No new wrappers for identity or constant channels are needed. The only new raw
constructors use `PMF.binaryMixture` with `(ε : NNReal) (hε : ε ≤ 1)`;
write `e := (ε : ℝ)` below. Their first branch has weight ε.

```text
PMF.binarySymmetricChannel ε hε a =
  PMF.binaryMixture ε hε (PMF.pure (!a)) (PMF.pure a)
PMF.binaryErasureChannel ε hε a =
  PMF.binaryMixture ε hε (PMF.pure none) (PMF.pure (some a))
```

BSC has input/output `Bool`; BEC has input `Bool` and output `Option Bool`,
with `none` the erasure symbol. Neither is a bundled channel or a new noise-law
representation. Parameters range over the entire closed interval `[0,1]`.

| Channel | Exact objective and universal upper bound | Capacity and actual achieving input |
| --- | --- | --- |
| Noiseless `PMF.deterministicChannel (id : A → A)` | `I(p,W)=H(p)≤log(card A)` for every finite-input PMF p | `C(W)=log(card A)`; `PMF.uniformOfFintype A` achieves it. |
| Input-independent `fun _ : A => r`, `r : PMF B` | `I(p,W)=0` for every p | `C(W)=0`; every p achieves it (and nonempty A supplies a pure witness). |
| `PMF.binarySymmetricChannel ε hε` | `I(p,W)=H(p.bind W)-Real.binEntropy e≤log 2-Real.binEntropy e` for every p | `C(W)=log 2-Real.binEntropy e`; uniform Bool input achieves it. |
| `PMF.binaryErasureChannel ε hε` | `I(p,W)=(1-e)*H(p)≤(1-e)*log 2` for every p | `C(W)=(1-e)*log 2`; uniform Bool input achieves it. |

Each capacity proof must establish its universal upper bound and an actual
achieving law, not only evaluate a candidate. Permanent consumers must verify
the specified law attains the public capacity, not merely invoke generic
existence without identifying that law. Uniform optimizers need not be unique.

Expose the BSC uniform witness directly through the public theorem
`mutualInfo_channelJoint_binarySymmetricChannel_uniformOfFintype`, with contract

```text
mutualInfo (PMF.channelJoint (PMF.uniformOfFintype Bool)
  (PMF.binarySymmetricChannel ε hε)) =
  channelCapacity (PMF.binarySymmetricChannel ε hε).
```

It holds for every permitted ε, including all boundary values. A focused
permanent consumer must use this theorem directly. For BEC, obtain uniform
attainment in a focused consumer from the public all-input MI formula,
`entropy_uniformOfFintype`, and the capacity formula, without unfolding the
channel or repeating a row/output entropy calculation. No separate BEC
uniform-attainment export is required.

Required endpoint cases: BSC ε=0 and ε=1 are deterministic identity/complement
with capacity `log 2`; ε=1/2 has input-independent output and capacity zero.
BEC ε=0 is the noiseless `some` embedding with capacity `log 2`; ε=1 always
erases and has capacity zero. Every input achieves the latter zero-capacity
cases. Treat pure/sparse input laws and all zero output masses without artificial
positivity assumptions. Singleton noiseless and singleton-input/output constant
cases have capacity zero. No probability law exists on an empty input alphabet.

Also use one private biased Boolean input law p with `p(true)=1/4` and
`p(false)=3/4` in the standard-channel information consumers. At BSC crossover
`ε=3/4`, check output true-mass `5/8` and derive
`I(p,W)=Real.binEntropy (5/8)-Real.binEntropy (3/4)` through the public objective
formula. At BEC erasure `ε=1/3`, check output masses `1/3` at `none`, `1/6` at
`some true`, and `1/2` at `some false`, then derive `I(p,W)=(2/3)*H(p)` through
the public objective formula. Interpret these masses in Real after `toReal`.
Exact rational and symbolic entropy identities suffice; no numerical logarithm
estimates or optimizer-uniqueness claim is required.

<a id="bits-contract"></a>
### 3.5 Explicit bits interpretations

Provide public scalar consequences, in the opt-in capacity-example owner using
`Shannon.Units`, with no second bits-capacity or base-indexed MI definition:

```text
natsToBits C(noiseless A) = Real.logb 2 (Fintype.card A)
natsToBits C(input-independent r) = 0
natsToBits C(BSC ε) = 1 - natsToBits (Real.binEntropy e)
natsToBits C(BEC ε) = 1 - e.
```

The same achieving laws remain valid after positive scaling by `1/log 2`.
Permanent consumers also convert the arbitrary-input objective bound and the
all-n block bound to bits, and convert product/repeated capacity identities.
Retain zero blocklength and endpoints. Generic algebra can remain private.

## 4. Ownership, public surface and reuse

All proposed Shannon declarations belong to `LeanInfoTheory.Shannon`.
Names below are proposals to approve with this revision, not existing facts.

| Owner | Proposed declarations and concrete consumers |
| --- | --- |
| `Shannon.ChannelCapacity` | `channelCapacity`, `mutualInfo_channelJoint_le_channelCapacity`, `channelCapacity_le_iff`, `exists_mutualInfo_channelJoint_eq_channelCapacity`, `channelCapacity_nonneg`, `channelCapacity_le_log_card_input`, `channelCapacity_le_log_card_output`; C22 examples/product theory and C23 use these. Add `channelCapacity_congr_equiv`, `channelCapacity_channelComp_le`, `channelCapacity_map_output_le` in C22.02. |
| `Shannon.ProductChannelCapacity` | `channelCapacity_productChannel`, `channelCapacity_memorylessChannel`, `mutualInfo_channelJoint_memorylessChannel_le`; heterogeneous/repeated consumers and C23 need the arbitrary-input endpoint. |
| `Probability.StandardChannels` (namespace `PMF`) | Only `binarySymmetricChannel`, `binaryErasureChannel`; reusable raw constructors consumed by the capacity-example owner and private probability consumers. |
| `Shannon.StandardChannelCapacity` | `channelCapacity_deterministicChannel_id`, `channelCapacity_const`, `mutualInfo_channelJoint_binarySymmetricChannel`, `channelCapacity_binarySymmetricChannel`, `mutualInfo_channelJoint_binarySymmetricChannel_uniformOfFintype`, `mutualInfo_channelJoint_binaryErasureChannel`, `channelCapacity_binaryErasureChannel`. The two general MI formulas and the explicit BSC uniform-attainment equation serve the focused consumers in section 3.4. |
| Same opt-in example owner, C22.07 | Four explicit bits equations, named by adding `_bits` to the four capacity-value theorem names. No change to the dependency-light existing `Units` owner. |

This is 26 proposed public declarations, not a growth quota. Pointwise masses,
transport identities, bounds on the objective range, selected maxima, row entropy,
uniform-output calculations and singleton/empty specializations stay private
unless new concrete reuse is reviewed. No optimizer structure, chosen optimizer,
symmetry framework, concavity alias or automatic simp attribute is requested.
The existing public `PMF.binaryMixture_apply` and transparent constructors
supply raw mass access. Reconsider specialized public `_apply` lemmas only
if implementation establishes repeated consumer need that this interface
does not adequately serve; they are not mandatory additions in this revision.

`Shannon.ChannelCapacity` starts from `Shannon.Topology`, `Shannon.EntropyBounds`
and `Shannon.SemanticBridge.Markov`; add the focused `Convexity` import only
where an actual production dependency requires it. `ProductChannelCapacity`
imports the core and existing `Shannon.SemanticBridge.ProductChannel`.
`Probability.StandardChannels` imports `Probability.FiniteMixture` and stays
below Shannon/topology. `StandardChannelCapacity` imports the core, raw standard
channels and `BinaryEntropy`, with `Convexity` for the public weighted-row
identity and, at C22.07, `Units`. Keep direct imports minimal after checking
actual dependency closure; no production import of `Examples` is allowed.

The supported owners join the full `LeanInfoTheory.Shannon` umbrella with
explicitly reviewed current-API/import growth. They do not join the lightweight
root or force capacity into the existing semantic aggregate. Permanent private
consumer owners are `Examples.ChannelCapacity`, `Examples.ProductChannelCapacity`,
`Examples.StandardChannels`, and `Examples.StandardChannelCapacity`, included
only in `LeanInfoTheory.Examples`. Their roles are core, product, probability-only
and selected-example/units integration respectively.

Reuse the actual public C15 topology/continuity producers; the private C15
maximizer consumer demonstrates the composition, but production cannot import it.
Reuse C17 `productChannel`/`memorylessChannel`, C18 correlated-input bound and
independent-input identities, existing weighted-row MI, input concavity, entropy
bounds, deterministic channel algebra, map/DPI and Units. Search current source,
generated indexes, relevant rendered API and pinned mathlib before adding helpers.
Preserve the frozen v0.1 API, existing assumptions/imports/names, root's two direct
imports and five-module closure, and the reviewed simp set. New source files
use the exact EPFL/MIL header. No convenience public `DecidableEq` or collapsed
universe assumptions.

At C22.01–C22.03, inspect the actual definitions/theorems with focused
`#check`/`#print` and compiling public-interface consumers before downstream
results depend on their signatures. C22.01 checks the retained nonempty-input
binder and core argument order; C22.02 checks local target-nonemptiness transport
and independently varying input/output universes; C22.03 checks the dependent
product's three independent universes and arbitrary-q/all-n quantifiers.
These are early checks within the existing steps, with no placeholder proofs
or additional implementation step. The cumulative API inspection remains required.

## 5. Ordered steps and acceptance criteria

All **26 criteria** below are mandatory. Sections 3, 4, 6 and 7 apply to every
step. Each step includes its own validation, review, reconciliation and scoped
closure, then stops. Steps 1–3 form internal theory checkpoints; completion of
those does not complete C22 or remove any of the four required examples.

<a id="c22-01"></a>
### C22.01 — Capacity, attainment and basic bounds

Dependencies: C15 and existing finite MI/entropy bounds. Owner/consumer:
`Shannon.ChannelCapacity` and `Examples.ChannelCapacity`.

- **C22.01-CAPACITY:** Define precisely section 3.1's supremum and prove
  the objective bound and universal-upper-bound iff, with genuine nonempty
  and bounded range evidence for Real supremum operations. Perform section 4's
  early signature check, including the explicit retained `[Nonempty A]` binder.
- **C22.01-ATTAINMENT:** Produce an actual input law attaining that same
  supremum using the public compact domain and continuous objective; no
  Examples import or assumed optimizer/compactness/continuity.
- **C22.01-BOUNDS:** Prove nonnegativity and both alphabet bounds. Derive
  output nonemptiness from the supplied channel instead of adding a premise.
- **C22.01-DOMAIN:** Permanent consumers extract and use the same maximizing
  PMF, cover pure laws on larger alphabets, singleton input/output, and
  demonstrate the empty-input/no-output impossibilities. Compile focused
  and umbrella access without changing root reachability or existing attributes.

<a id="c22-02"></a>
### C22.02 — Relabeling and postprocessing

Dependency: C22.01. Extend its owner and consumer.

- **C22.02-RELABEL:** Prove the simultaneous equivalence contract of section
  3.2, with correctly oriented input inverse/output pushforward and locally
  transported nonempty instance; test each one-sided specialization and the
  early signature/universe checks in section 4.
- **C22.02-PROCESSING:** Prove stochastic composition and deterministic
  output-map capacity inequalities for arbitrary input laws using existing DPI.
- **C22.02-CONSUMERS:** A permanent private relabeling consumer uses the `Fin 3`
  cycle `0↦1↦2↦0`, a nonuniform input law with distinct masses and three
  distinct channel rows. Check the joint-law transport under `p.map e` and
  `fun a' => W (e.symm a')`, the unchanged output law and objective, and the
  public capacity equality. The law-level check must distinguish e from its
  inverse; capacity equality alone is insufficient. Include a stochastic
  postprocessing stage and noninjective output collapse. Use existing input
  concavity plus the new objective bound to show
  a binary mixture of two achieving inputs still achieves capacity, including
  mixture weights 0 and 1. Keep that consumer/private reasoning out of the API.

<a id="c22-03"></a>
### C22.03 — Product capacity and memoryless single-letter bound

Dependencies: C22.01, C17 and C18 (execution order follows C22.02).
Owner/consumer: `Shannon.ProductChannelCapacity`, `Examples.ProductChannelCapacity`.

- **C22.03-UPPER:** Establish the section 3.3 upper chain for every possibly
  correlated q through its actual marginals and coordinate capacities. An
  independent-input-only argument cannot satisfy this criterion.
- **C22.03-LOWER:** Select actual coordinate maximizing PMFs and prove their
  existing finite product attains the sum; conclude heterogeneous dependent-
  alphabet product capacity equality with independent index/input/output universes.
  Perform section 4's early dependent-product and memoryless signature checks.
- **C22.03-MEMORYLESS:** Prove all-n repeated capacity and the explicit
  arbitrary-block-input objective bound; show iid repetition of any supplied
  achieving input attains the repeated value.
- **C22.03-EDGE:** Permanent consumers cover heterogeneous channels, a genuinely
  correlated duplicated-bit input with a strict objective-versus-capacity gap,
  independent attainment, singleton index/alphabet, empty dependent product,
  n=0 and n=1. Include the vacuous-base zero-word case described in section 3.3.
  Establish the early strict-gap consumer from existing C18 objective calculations
  and the core capacity bound, without depending on later example formulas.

<a id="c22-04"></a>
### C22.04 — Noiseless and input-independent capacities

Dependency: C22.01 (after the product checkpoint in execution order).
Owner/consumer: `Shannon.StandardChannelCapacity`, `Examples.StandardChannelCapacity`.

- **C22.04-NOISELESS:** Prove the noiseless objective identity, universal
  alphabet upper bound, uniform-input attainment and public capacity formula.
- **C22.04-CONSTANT:** Prove zero objective for every input law of an
  input-independent channel, zero capacity and attainment by every input law.
- **C22.04-CONSUMERS:** Exercise the public formulas with actual uniform and
  pure inputs, a non-pure constant output law, a sparse input, and singleton
  input/output alphabets. No new noiseless/constant channel wrappers.

<a id="c22-05"></a>
### C22.05 — Binary symmetric channel

Dependency: C22.04's example owner and existing binary-mixture/entropy APIs.
Add the BSC raw constructor in `Probability.StandardChannels`; extend the
supported capacity-example owner and both raw/information private consumers.

- **C22.05-MODEL:** Define the Boolean crossover channel using existing
  binary mixture with ε∈[0,1], correct branch weights and actual PMF rows.
  Probability-only consumers check masses and deterministic endpoints.
- **C22.05-CAPACITY:** Prove the public BSC objective formula, universal bound,
  uniform-input attainment and capacity `log 2 - Real.binEntropy e` under
  exactly the section 3.4 contract. Export its direct uniform-attainment equation
  and exercise that theorem through the focused public interface.
- **C22.05-BOUNDARY:** Permanent consumers cover ε=0, 1/2 and 1, pure input
  at an interior parameter, and every-input zero attainment at 1/2. No
  ε≤1/2 restriction, full support, strict positivity or false uniqueness claim.
  Include section 3.4's biased input at crossover 3/4, checking both the
  output mass and the symbolic MI formula through the public objective theorem.

<a id="c22-06"></a>
### C22.06 — Binary erasure channel

Dependencies: existing mixture/entropy APIs and C22.05's owner setup.
Extend the same raw, supported information and private consumer owners.

- **C22.06-MODEL:** Define the `Bool → PMF (Option Bool)` erasure channel,
  with erasure mass ε and transmitted-symbol mass 1-ε. Check raw masses,
  including absent-symbol zeros, ε=0 and ε=1.
- **C22.06-CAPACITY:** Prove the public identity `I(p,W)=(1-e)*H(p)` for
  every p, its universal upper bound, uniform attainment and capacity
  `(1-e)*log 2`; retain correct probability weights. Derive the specified
  uniform witness in the focused consumer from the public formulas and
  uniform entropy as required in section 3.4.
- **C22.06-BOUNDARY:** Permanent consumers cover pure/sparse input, the
  noiseless embedding at zero, all-erasure at one and every-input attainment
  there. No division by zero or assertion about a null conditional fiber.
  Include section 3.4's biased input at erasure 1/3, checking the three output
  masses and deriving the `(2/3)*H(p)` identity through the public objective theorem.

<a id="c22-07"></a>
### C22.07 — Bits, C23 interface and integrated API

Dependencies: C22.01–C22.06. Extend only the indicated example/consumer
owners and approved canonical/generated documentation as needed.

- **C22.07-BITS:** Supply all four public bits equations in section 3.5 and
  permanent consumers converting attainment, product capacity, repeated
  capacity and arbitrary-input bounds through positive log-2 scaling.
- **C22.07-C23:** A focused permanent consumer applies both required public
  bounds to arbitrary p and arbitrary block q. A second uses a pushforward
  `r.map encoder` with a concrete noninjective encoder and correlated words;
  derive the nC bound without iid/injectivity assumptions, a channel-code
  abstraction, Fano or a coding theorem. Exercise n=0 and n=1.
- **C22.07-API:** Reconcile all required endpoints, specified achieving laws,
  boundary consumers, exact owners/imports, naming, current growth approvals,
  generated inventory/docs and unchanged root/retained API/simp policy. Record
  discovery friction or proposed helper promotion with actual consumer evidence.

<a id="c22-08"></a>
### C22.08 — Cumulative qualification and maintained handoff

Dependencies: all earlier steps and reviews closed with current applicability.
This final step adds no mathematical endpoint.

- **C22.08-VALIDATION:** Qualify the exact candidate with the full maintained
  clean routine and separately authorized current two-pass API-documentation
  gate; inspect every new elaborated declaration's signature, hypotheses,
  docstring, owner and source link. Include applicable focused/aggregate,
  documentation, compiled compatibility/trust, import/API/simp and generated
  checks, preserving failures and precise source/configuration/pin applicability.
- **C22.08-READINESS:** Retain current validation, read-only contextual
  self-review, separate reassessment, predecessor checks, all original-report
  obligations and a neutral fixed-source request covering all 26 criteria.
  Every required endpoint/example has evidence; remaining work has an explicit
  disposition, owner and trigger. Readiness does not assert a future review pass.
- **C22.08-HANDOFF:** Before final capture, maintain `docs/handoffs/chunk-22.md`
  and reconciled canonical links, recording delivered APIs/imports/consumers,
  mathematical adaptations, boundary assumptions, actual validation/review
  references, limitations, dispositions and C23's two required capacity bounds.
  Keep operational capacity equality outside C22 and release after C24.

After readiness, obtain the genuine original cumulative report, substantively
reconcile every criterion/finding and every prior accepted report, correct and
revalidate as needed, finish canonical documents before F, and use the supported
private completion mechanism. Require satisfactory reviewer reassessment for a
criterion gap/contradiction; an implementer-only override cannot close it.
Preserve B/R/F identities and R-to-F applicability. Captured prose may say
“validation ready; closure subject to the private completion record”; record
actual closure privately and in the user report, without post-F announcement edits.
Stop; C23 starts only under separate planning/implementation authority.

## 6. Validation and review obligations

Each selected step uses [review protocol](../review-protocol.md) and
[operations](../review-operations.md): inspect admission/source, capture B,
owned edits, initial validation, read-only self-review, separate reassessment,
finished edits and neutral R request, genuine bound-reviewer report,
reconciliation/corrections, final validation/documents, F and scoped closure.
The bound reviewer must receive no implementation transcript or self-review
verdict. Formal PLAN sessions require an explicit request; the retained
revision-1 session assesses only its original source. This revision's edits
do not alter that report or transfer its assessment to the changed plan.

Serialize artifact-producing Lean runs. During a dirty step, build its focused
producer and permanent consumers plus important aggregates with
`python scripts/validate_release.py focused <targets>`. Include
`LeanInfoTheory.Shannon`, `LeanInfoTheory.Examples` and root architecture checks
as applicable; test fresh focused imports and separate universes. Approved
public/import changes require deliberate current-API/website regeneration,
non-mutating frozen-manifest verification and `python scripts/validate_release.py static`.
Run `documentation` for affected documentation/examples and the maintained
compiled `compatibility`/`trust` checks for public growth. Check allowed axioms,
proof placeholders, exact import closures and reviewed simp attributes.
Do not weaken or replace the maintained validator.

C22.08 requires a concrete scoped checkpoint proposal, inspection of a suitable
existing validation checkout, and **separate lead authorization** before making
the clean local checkpoint or any required amendments. Then run the complete
`python scripts/validate_release.py` routine on that exact clean candidate;
rerun the whole suite after every amendment. Dirty checks are not a substitute,
and unrelated work must never be committed to satisfy the clean gate.

The current API-documentation milestone separately requires authorization for
`python scripts/validate_release.py api-docs`, reviewed Zig 0.16.0 on Windows
via `LEANINFOTHEORY_ZIG`, both actual passes and substantive declaration
inspection. File-mode output is local; GitHub source mode needs a clean exact
commit. Recheck source/content/configuration/dependencies/attestation/output
applicability after amendments and rerun when invalidated. The routine suite
does not itself supply this gate. These authorities grant no publication.
If either authority is pending, retain the pending obligation and do not claim
chunk closure. Prepare all authorized work before requesting the concrete approval.

Record actual actors, commands, outputs, source identities and limitations;
distinguish source searches, isolated planning probes, fresh builds, earlier
applicable evidence and reviewer checks. Remove disposable Lean spikes after
retaining their evidence. Private `.lit-review/` evidence is durable, not scratch.
No current planning probe establishes a future theorem or acceptance criterion.

Canonical reconciliation includes the living summary, current state, relevant
map/roadmap, reference/API documentation and meaningful project-log entries;
update the naming/discovery register only when warranted. Maintain these through
the selected steps, not only at closeout. Preserve unrelated text and frozen
release artifacts; do not rewrite historical conditional wording as an open task.

## 7. Plan health and decisions

The proposed boundary remains one C22 with eight individually selected steps.
Capacity/attainment, relabeling and product theory have distinct checkpoints
before example work. All four example endpoints remain required. If actual
elaboration requires stronger assumptions, dropped examples, changed meanings,
important API/ownership changes, dependency upgrades or a changed chunk boundary,
retain the evidence and seek the lead's decision before proceeding.

Routine proof organization and private helper choices may evolve in the notes.
The exact equivalence-transport elaboration and complete BSC/BEC entropy proofs
are still implementation work; bounded planning checks are not their completion.
No evidence currently justifies splitting or reducing this chunk.

Decisions requested: approve or revise this exact proposal, including its explicit
nonempty-input capacity domain, NNReal closed-interval parameters, Option Bool
erasure representation, focused owners and eight-step division. Formal plan review
may be requested separately; it does not approve implementation. Clean checkpoint,
API-documentation, release and publication approvals remain separate later actions.
