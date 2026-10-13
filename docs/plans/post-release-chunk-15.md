# Chunk 15: Finite-simplex topology and optimization readiness

<!-- lit-review-status:start -->
**Status:** Active revision 2. The lead accepted this plan in the message
beginning "I liked this plan" and selected C15.01 with its review process on
2026-10-12. C15.01 completed successfully with review on 2026-10-13.
C15.02--C15.04 completed successfully with review on 2026-10-13. The lead
then conditionally selected C15.05 with review; its prerequisite and all 232
predecessor source entries were verified before intake. The lead authorized
the exact prepared 20-file local checkpoint, C15.05-only amendments within
those paths and reuse of the relocated clean validation checkout. The initial
checkpoint passed the complete clean routine suite; actual current two-pass
API-doc qualification and rendered inspection passed separately. Final amended
candidate qualification, exact applicability, fresh all-17-criterion review,
reconciliation and supported closure remain governed by their source-bound
records. C16 and later chunks remain unselected.
The approval applies to revision 2 as presented (full-file SHA-256
`5fbec3d00b4524f2b2bd3886d186a0a441d10610800c3889722cf3a87aae863e`);
this editorial status update changes no normative requirement.
The formal PLAN review was not requested or dispatched. The lead's subsequent
acceptance and explicit step selection supersede the earlier pending-authority
chronology below; they do not create a retrospective PLAN report.
The existing persistent reviewer remains bound for the STEP review.
C14 is complete through C14.04 at
`e982ba7cb0ac0460c90777820659482eed4e2b0e`, by its actual private completion
record. Historical pre-closure wording is not reopened or rewritten.
<!-- lit-review-status:end -->

## 1. Scope and authority

This plan refines [C15 in the chunk map](post-release-chunk-map.md#c15-finite-simplex-topology-and-optimization-readiness).
Its endpoint is a permanent independent consumer obtaining a maximizing input
for the actual function
`p ↦ LeanInfoTheory.Shannon.mutualInfo (PMF.channelJoint p W)`
by applying an existing mathlib compact-extremum theorem.

The probability objects remain mathlib PMFs. Real coordinates use the existing
`stdSimplex ℝ α`; entropy, conditional entropy, MI and total variation retain
their existing definitions, nats, coordinate orientation and half-L1 convention.
The underlying subtype topology is retained and exposed through an explicit
forwarding instance: pinned instance search does not unfold the PMF definition
automatically. No parallel probability or channel structure, replacement
topology, or TV metric instance is selected.

Excluded: capacity definitions/properties (C22), general minimax, constrained
optimization, KL continuity or lower-semicontinuity, conditional-law continuity
at null fibers, coding, and infinite-alphabet information theory. A generic
coordinate or channel lemma may omit unnecessary finiteness assumptions without
expanding the finite information-theory endpoint.

The current authority covers initialization, advisory assessment and revision
of this proposal, targeted source inspection and isolated feasibility probes.
A separate explicit request is required to dispatch
formal PLAN review. Exact plan approval authorizes no implementation by itself:
perform only the one subsequently requested step with its required review
process, then stop. No commit, push, dependency change, publication, later step,
or later chunk is authorized. Obtain separately scoped authority for a clean
checkpoint and validation-checkout reuse when the final gate is ready.

## 2. Verified baseline and sources

### 2.1 Intake

Work in `C:\Users\coban\Desktop\Lean Info Theory`, on `master` at the C14
commit above. Intake has unstaged changes to `.gitignore`, `AGENTS.md`,
`docs/project-log.md` (workspace-hygiene/relocation work), and
`docs/next-website-tasks.md`. Preserve all existing changes. The last file is
protected: do not stage, commit, revert, relocate or otherwise modify it.

The C14 completion record is
`.lit-review/setup/c14-04-completion-20261008.json`, with status
`SUPERVISED_STEP_COMPLETE`, all four steps complete, no material findings,
and closure
`97cbfc6f0afff299022ec1f15ea51529d44ad07748ab630afa8dd113986f54e3`.
Its final source is
`b25d8e5cde12c441f02a1874e57afa58f9a744942004b21c0bd718d39b7c29c9`.
Comparison of its 219 real file entries found only the three expected hygiene
edits above; configuration, all nine installed dependency records and Git index
identity match. The protected website notes match their C14 captured bytes.
This is predecessor applicability evidence, not a fresh complete validation.

Lean remains `v4.33.1`; mathlib remains
`0df444a360eaa60ab8c11dca51a86af692955474`. The current public-API manifest
check passes: the baseline has 653 supported declarations in 36 owners,
94 reviewed simp declarations and 92 root exports. These are observations,
not growth quotas.

The existing registered validation checkout is
`C:\Users\coban\Desktop\Lean Info Theory\.worktrees\LeanInfoTheory-C12-validation-20261003`.
Read-only inspection found it clean at the same C14 commit. Its old Desktop
location must not be recreated. This inspection grants no reuse authority;
old path-dependent attestations remain historical. Auxiliary folders belong
inside authorized Lean-project paths, never directly on the Desktop.

### 2.2 Mathematical sources and adaptations

The reference is **PW24**, Polyanskiy--Wu, August 16, 2024 prepublication
version, local SHA-256
`c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
Keep it distinct from the October 20, 2022 PW22 draft.

- Section 4.5, Proposition 4.8, printed page 78 / PDF page 103:
  finite entropy continuity, using continuity of the scalar summands.
- Section 4.7, Proposition 4.13(a), printed page 81 / PDF page 106:
  finite joint-law MI continuity via entropy algebra.
- Proposition 4.13(b), printed pages 81--82 / PDF pages 106--107:
  fixed-channel input continuity has a stronger arbitrary-output source
  statement. C15 selects the finite-input, finite-output specialization only.
- Sections 5.1--5.2 provide optimization context. Theorem 5.4, printed page 94 /
  PDF page 119, assumes an attaining input; it does not supply the compactness
  proof required here. No saddle-point or capacity theorem is imported into C15.

Conditional-entropy continuity is a derived consequence of the existing
entropy-difference definition, with first coordinate conditioned on second.
Finite compactness and attainment use pinned mathlib topology APIs. All
information quantities are in nats. The [notes](post-release-chunk-15-notes.md)
retain exact inspection/probe evidence and its limitations without reproducing
textbook prose or proofs.

## 3. Proposed mathematical contracts

The spellings below are proposed discovery names. Any spelling refinement must
be reconciled before exact approval; proof tactics and private helper choices
remain advisory in the notes.

### 3.1 Existing topology, coordinates and simplex

Pinned `PMF α` is definitionally a subtype of `α → ℝ≥0∞`, with the probability
normalization predicate. However, the pinned environment cannot synthesize
`TopologicalSpace (PMF Bool)` directly. Source search found no dedicated PMF
topology instance. Propose one named `PMF.instTopologicalSpace`, defined by
`inferInstanceAs (TopologicalSpace {f : α → ℝ≥0∞ // HasSum f 1})`.
This forwards exactly the existing product/subtype topology; verify that
identity by definitional equality. It requires no topology on `α` and no
finiteness. Do not change the reducibility of the upstream PMF definition.

In namespace `PMF`, propose:

1. `continuous_apply_toReal (a : α)`:
   `Continuous (fun p : PMF α => (p a).toReal)`.
2. `homeomorphStdSimplex [Fintype α] : PMF α ≃ₜ stdSimplex ℝ α`.
   Its forward coordinate is `(p a).toReal`; its inverse coordinate is
   `ENNReal.ofReal (x a)`. Expose only the two useful coordinate equations
   (`homeomorphStdSimplex_apply`, `homeomorphStdSimplex_symm_apply`), leaving
   constructor/normalization helpers private.
3. `tendsto_iff_forall_toReal_tendsto`: for any filter `l : Filter ι`,
   `f : ι → PMF α` and `p : PMF α`,
   `Tendsto f l (𝓝 p) ↔ ∀ a, Tendsto (fun i => (f i a).toReal) l (𝓝 ((p a).toReal))`.
   No sequence-only restriction, `NeBot`, positivity or support premise.
4. One named `PMF.instCompactSpace : CompactSpace (PMF α)` instance under `[Finite α]`,
   justified by existing simplex compactness and the homeomorphism.
   Apart from the explicit subtype-topology
   forwarding instance above, add no topological, uniform, pseudo-metric or
   metric instance.

The bridge must respect nonnegativity, normalization and both inverse laws.
Atom evaluation and conversion to Real must be justified at every PMF atom,
including zero, using the fact that PMF atoms are never top. Do not assert
global continuity of `ENNReal.toReal`. Specific constructor, conversion and
compactness lemmas are vetted proof advice in the notes.

### 3.2 Fixed finite-alphabet TV convergence

In the separate TV/topology bridge, with `[Fintype α]`, propose:

- `PMF.continuous_totalVariation`:
  `Continuous (fun pq : PMF α × PMF α => PMF.totalVariation pq.1 pq.2)`.
- `PMF.tendsto_iff_totalVariation_tendsto_zero`: for the same `f,l,p`,
  `Tendsto f l (𝓝 p) ↔ Tendsto (fun i => PMF.totalVariation (f i) p) l (𝓝 0)`.

Together with Section 3.1 this establishes equivalence of coordinate, existing
topological and TV convergence on one fixed finite alphabet. Reuse the existing
TV interface before adding local proof machinery; any one-use coordinate
estimate stays private. The notes record the singleton-event bound as the
preferred converse route, without freezing a particular proof script.
Neither an equality with an inherited `dist` nor an infinite-alphabet
equivalence is claimed.

### 3.3 Channel and pushforward maps

In the finite probability topology owner, propose:

- `PMF.continuous_map`: for `g : α → β` and finite source `α`,
  `Continuous (fun p : PMF α => p.map g)`.
- `PMF.continuous_bind`: for fixed `W : α → PMF β` and finite source `α`,
  `Continuous (fun p : PMF α => p.bind W)`.
- `PMF.continuous_channelJoint`: for fixed `W : α → PMF β`,
  `Continuous (fun p : PMF α => PMF.channelJoint p W)`.

Use `[Finite α]` for the public map and bind theorems; no finiteness or
nonemptiness premise on `β` is needed for these probability maps. The
coordinate-product joint-law proof needs no finiteness premise on `α` either.
No varying-channel API is required by this plan. Marginal continuity follows
by `continuous_map` with the two projections; avoid redundant public aliases.

Finite PMF domains are compact, so continuous output and joint-law images are
compact by existing mathlib image APIs. A permanent consumer must exercise
this fact on the actual `bind` map; no specialized public image-compactness
wrapper is needed.

### 3.4 Finite information objectives

In namespace `LeanInfoTheory.Shannon`, propose:

- `continuous_entropy` on `PMF α` under `[Fintype α]`;
- `continuous_condEntropy` and `continuous_mutualInfo` on
  `PMF (α × β)` under `[Fintype α] [Fintype β]`;
- `continuous_mutualInfo_channelJoint (W : α → PMF β)`:
  `Continuous (fun p : PMF α => mutualInfo (PMF.channelJoint p W))`,
  with both finite alphabets.

Use the existing finite entropy sum and scalar continuity at zero, the existing
algebraic entropy formulas, and the delivered probability maps. The notes
record the direct `Real.continuous_negMulLog` route and composition with
`continuous_channelJoint`; individual lemma applications remain advisory.
No separate MI objective definition is necessary.

C14 quantitative estimates remain available to consumers but are not proof
dependencies. Their route would require interpreting a modulus limit and
importing coupling/Fano machinery; the direct route needs neither. Preserve
C14's focused owner and its declarations unchanged.

### 3.5 Mandatory attainment consumer

A private, generic permanent theorem must have the mathematical conclusion

```text
[Fintype α] [Nonempty α] [Fintype β] (W : α → PMF β) :
  ∃ p : PMF α, ∀ q : PMF α,
    mutualInfo (PMF.channelJoint q W) ≤ mutualInfo (PMF.channelJoint p W)
```

Its proof must apply an existing mathlib compact-extremum theorem to this
actual objective on the full PMF input domain, using delivered compactness
and objective continuity and deriving domain nonemptiness from `[Nonempty α]`.
The notes record a checked application route; the exact theorem spelling and
witness construction are not acceptance requirements.
Do not accept a consumer with an assumed compactness/continuity hypothesis,
a surrogate scalar objective, or an assumed maximizing distribution.

Only input nonemptiness is necessary beyond the supplied finite channel.
Given `a : α`, `W a` implies `Nonempty β`; do not add an independent output
nonemptiness premise for convenience. The consumer asserts existence, not
uniqueness, a formula for the optimizer, or a capacity value.

### 3.6 Boundary and degeneracy policy

- Zero atom masses and changing supports are included throughout. Use
  `Real.negMulLog` at zero rather than a strictly positive logarithm argument.
- If `α` is empty, `PMF α` and the real simplex are empty. They are still
  compact; continuity and homeomorphism statements remain meaningful.
  An optimizing input does not exist. Never infer it from compactness alone.
- On a singleton input alphabet the sole input is pure and the actual MI
  objective is zero. On a singleton output alphabet every input gives zero MI.
  These claims must be exercised through existing information APIs.
- If input is nonempty and output empty, no supplied channel exists.
- All finite-sum `ENNReal`-to-`Real` conversions must use no-top evidence,
  including normalization and weighted sums. No silent replacement of a
  potentially infinite quantity by its real projection.
- Conditional entropy is continuous as a joint-law function. This does not
  make conditional PMFs continuous at null fibers or give fallback rows
  probabilistic meaning. No unrestricted KL continuity follows.

### 3.7 Connected boundary consumer

Use one small mathematical family across C15.02--C15.04. For `0 ≤ t ≤ 1`, let
`p_t : PMF Bool` have real masses `p_t(false) = 1 - t` and `p_t(true) = t`,
so `p_0 = PMF.pure false`. Fix the channel with rows
`W(false) = p_0` and `W(true) = p_(1/2)`, and let
`J_t = PMF.channelJoint p_t W`.

The permanent consumers must establish the following connections:

- C15.02: the exact coordinates and `PMF.totalVariation p_t p_0 = t`,
  and convergence to `p_0` as `t` tends to zero within the parameter interval,
  using the public coordinate/topological/TV equivalences.
- C15.03: the only potentially nonzero joint masses are `1 - t` at
  `(false,false)` and `t/2` at each of `(true,false)` and `(true,true)`;
  `(false,true)` has mass zero. The output's true mass is `t/2`. Use the
  public map continuity and projection interfaces to propagate input
  convergence to the output and joint laws. The second output fiber is
  positive when `t > 0` and null at zero.
- C15.04: explicit `Tendsto` conclusions for both
  `mutualInfo (PMF.channelJoint p_t W)` and `condEntropy J_t`, each tending
  to zero along that family. Supply the endpoint values through existing
  information APIs and use the delivered channel/objective/joint-law
  continuity interfaces. Merely specializing `ContinuousAt` at the endpoint
  does not meet this consumer requirement.

The parameter representation and local proof details belong in the notes.
These are the same mathematical family, not a new public fixture API:
keep the tiny constructors private in each focused example owner as needed.
Do not import another example module or create a fixture module solely to
share them. Only the TV example requires the TV bridge; the qualitative
channel/information consumers retain their focused imports. No binary-capacity
formula, optimizer formula, full entropy formula along the path, or
conditional-law limit is required.

## 4. Ownership and dependency contract

| Proposed owner | Responsibility | Intended direct local imports |
| --- | --- | --- |
| `Probability.FiniteTopology` | Inherited PMF topology, real simplex bridge, finite compactness, coordinate convergence and finite probability maps | `Probability.FiniteChannel` (which supplies `Probability.Finite`) |
| `Probability.TotalVariationTopology` | Existing TV's continuity and convergence equivalence | `Probability.TotalVariation`, `Probability.FiniteTopology` |
| `Shannon.Topology` | Qualitative entropy/conditional-entropy/MI continuity and actual fixed-channel MI objective | `Shannon.InfoMeasures`, `Probability.FiniteTopology` |
| `Examples.FiniteTopology` | Bridge/degeneracy and channel compact-image consumers | Focused `Probability.FiniteTopology` |
| `Examples.TotalVariationTopology` | Coordinate/topological/TV convergence consumers | Focused `Probability.TotalVariationTopology` |
| `Examples.ChannelOptimization` | Boundary information objectives and actual MI attainment | Focused `Shannon.Topology`; existing focused information results only when a concrete regression requires them |

Mathlib owners include `Mathlib.Analysis.Convex.StdSimplex` and the existing
topological/ENNReal/compact-extremum APIs; add only exact proof-required imports,
never `import Mathlib`. The separate TV bridge prevents the information
continuity owner from acquiring a TV dependency. No new owner imports
`Shannon.Continuity`, coupling, Fano, Pinsker, KL, Jensen entropy bounds or
semantic aggregates just to establish qualitative continuity.

All three mathematical owners join the full `LeanInfoTheory.Shannon`
import-only umbrella. Examples join only `LeanInfoTheory.Examples`.
The lightweight root retains exactly its two direct imports, five-module
closure and 92 exports. Existing supported declarations, signatures, assumptions,
semantics and import contracts remain compatible. New names/helpers/instances
receive the ordinary namespace, discoverability, trust and generated-doc review.
No new simp attributes or aliases are preapproved; the selected instances are
the subtype-topology forwarder and finite PMF compactness. Do not change review
settings, dependency pins, historical release artifacts or publication workflows.

## 5. Ordered steps and acceptance criteria

Every theorem step includes focused owner/consumer/umbrella checks, import/API
and trust review, current generated artifacts, canonical documentation as
applicable, retained self-review and reassessment, independent review and
reconciliation under the installed protocol. Step selection always requires a
fresh explicit user instruction after exact approval.

### C15.01 — PMFs, real simplex and finite compactness

Implement Section 3.1 in `Probability.FiniteTopology` and its permanent focused
consumer. Establish instance compatibility before using compactness downstream.

- **C15.01-BRIDGE:** The existing PMF topology admits the stated homeomorphism
  with the existing real standard simplex, with both coordinate equations,
  normalized inverse and no second probability representation.
- **C15.01-COMPACT:** Finite PMFs are compact through this bridge. The topology
  forwarder is definitionally the existing subtype topology, with no new
  uniform or metric instance. The selected compactness instance works under
  `Finite` and both instances coexist with current imports without diamonds.
- **C15.01-COORDINATES:** The arbitrary-filter real-coordinate convergence iff
  has the stated support-free contract and justified no-top conversions.
- **C15.01-CONSUMERS:** Permanent focused examples exercise round trips and
  real coordinates for a sparse law, pure vertices, empty-law impossibility,
  singleton compactness, and public interface use. Separate fresh-import
  probes check the named global instances under the focused owner and full
  umbrella, exactly as specified in Section 6.2.

Validation: the C15.01 row of Section 6.1 and the fresh-import checks in
Section 6.2. Check no unrelated instance or root export change. A compactness
premise or local replacement topology supplied by a probe is not completion.

### C15.02 — Coordinate and total-variation convergence

Depends on C15.01. Implement Section 3.2 in its separate probability bridge and
private permanent convergence consumers.

- **C15.02-TV:** The joint TV function is continuous in the inherited topology,
  and tending to a fixed PMF is equivalent to TV tending to zero.
- **C15.02-EQUIVALENCE:** Permanent consumers compose both public iff theorems
  in both directions, retaining arbitrary filters and the fixed finite alphabet;
  they do not merely unfold the TV definition.
- **C15.02-BOUNDARY:** The Section 3.7 Boolean family approaches its pure
  boundary law with exact coordinates and TV, using the delivered convergence
  equivalences. Singleton TV and impossible empty limits are also covered
  without positivity assumptions.

Validation: the C15.02 row of Section 6.1, including the generic and concrete
permanent consumers. Confirm the new bridge has no Shannon dependency and
imports no competing distance/topology structure.

### C15.03 — Continuous finite probability maps

Depends on C15.01; the ordered workflow also closes C15.02 before selection.
Implement Section 3.3 in the same `Probability.FiniteTopology` owner.

- **C15.03-MAPS:** Fixed pushforward and bind maps are continuous with only
  finite source hypotheses; the fixed-channel joint map has its stated
  coordinatewise contract without unnecessary finiteness/nonemptiness.
  Permanent direct applications of these public theorems check a map
  `Bool → Nat`, a channel `Bool → PMF Nat`, and joint-map continuity for
  `Nat → PMF Bool`. Also check generic independent universes
  `{α : Type u} {β : Type v}`, with only `[Finite α]` for map/bind and no
  finiteness assumptions for the joint map. These checks must not install a
  local `Fintype`, add an output-finiteness premise, or replace `Nat` with a
  finite subtype. They test the promised signatures, not new infinite-alphabet
  information theory.
- **C15.03-COMPACT-IMAGE:** A permanent consumer uses existing compact-image
  machinery on the actual channel-output map and delivered PMF compactness.
- **C15.03-CONSUMERS:** Exercise a nonconstant, noninjective finite deterministic
  map and the Section 3.7 stochastic channel with distinct rows. Check its
  output/joint mass formulas and projection compatibility, and propagate the
  approaching input family through the delivered continuous maps. Verify the
  unused input row and vanishing output marginal at the endpoint.

Validation: the C15.03 row of Section 6.1, the permanent generality checks above,
and the fresh-import checks in Section 6.2 after changing the probability owner.
Verify finite sums and products justify the ENNReal conversions, and source
finiteness has not accidentally become an output-finiteness requirement.
Do not add channel bundles or null-fiber inverse maps.

### C15.04 — Information continuity and actual MI attainment

Depends on C15.01--C15.03. Implement Section 3.4 in `Shannon.Topology` and
Sections 3.5--3.6 in the permanent `Examples.ChannelOptimization` consumer.

- **C15.04-INFORMATION:** Entropy, conditional entropy and MI are continuous
  on their entire finite PMF domains, using the existing quantities and
  conditioning orientation, including distributions with zero masses.
- **C15.04-CHANNEL-OBJECTIVE:** The actual fixed-channel input MI objective is
  continuous at every input, with no full-support or positivity assumption and
  no coupling/Fano/KL dependency.
- **C15.04-ATTAINMENT:** The permanent generic consumer directly applies an
  existing compact-extremum theorem to that objective and obtains the exact
  Section 3.5 witness under nonempty finite input and finite output. Its proof
  supplies compactness, continuity and nonemptiness from delivered interfaces.
- **C15.04-BOUNDARY:** Permanent consumers prove the two explicit information
  limits in Section 3.7 along the nonconstant boundary family, including the
  actual fixed-channel MI objective and conditional entropy with a disappearing
  conditioning marginal. Exercise singleton input/output objective zero and
  empty-input/empty-output distinctions. No theorem asserts continuity of
  fallback conditional laws or unrestricted KL.

Validation: the C15.04 row of Section 6.1. Inspect the extremum application and
its actual objective, supplied hypotheses and focused imports; check both
boundary limits. No capacity symbol or capacity-value example is introduced.

### C15.05 — Cumulative qualification, reconciliation and handoff

Final step; no additional mathematics. Depends on all four completed steps.

- **C15.05-VALIDATION:** Qualify the complete final source with the maintained
  clean-checkpoint routine suite and the separate actual two-pass current
  file-mode API-documentation gate. Recheck final applicability after any edit
  or amendment, preserving original failures and successful evidence separately.
- **C15.05-READINESS:** The complete candidate is ready for fresh independent
  cumulative review against every approved criterion in C15.01--C15.05, with
  exact source/dependency identity, completed owned edits, validation, retained
  self-review, separate reassessment, and reconciled earlier step reports.
- **C15.05-HANDOFF:** Reconcile canonical status, current API/import/generated
  documentation, naming/remaining-work dispositions and
  `docs/handoffs/chunk-15.md` before final capture. Record delivered interfaces,
  useful focused imports, actual MI consumer, topology/edge decisions, source
  and review evidence, limitations, owners/triggers, and next-chunk prerequisites.

The cumulative reviewer assesses all **17** criteria, including these three.
Dispatch the fresh all-criteria review once readiness is established. The
original satisfactory cumulative report and reconciliation of every finding
and criterion assessment are later closure obligations, not evidence that
can exist before dispatch. No material issue or required criterion gap may
remain at closure.

Obtain the necessary authority for a concrete clean checkpoint and reuse of the
relocated checkout. Do not commit user changes to satisfy hygiene. Run
`python -B scripts/validate_release.py` on the authorized clean candidate and
repeat after amendment. Preserve the validator's default/eight-target strict
builds, independently compiled README/guide consumers, retained/current
compatibility, all-project axiom policy, exact import/root/simp contracts,
generated references, legal/release metadata, website and clean hygiene gates.

Run `python -B scripts/validate_release.py api-docs` using the existing reviewed
Zig 0.16.0 and pinned doc-gen configuration. Inspect rendered new signatures,
hypotheses, docstrings, links and owners. The current local output remains
`docbuild/.lake/build/doc/`; never replace the historical v0.1.0 route.
A relocated old attestation is not a fresh two-pass result.

Finish captured documents with provisional closure wording. Only the supported
private completion mechanism establishes final closure; retain its actual
reference privately and in the user report without a post-F historical rewrite.
Stop after this step; the handoff neither selects C16 nor creates/transfers its
reviewer.

## 6. Cross-cutting validation and review evidence

### 6.1 Required validation by step

All commands run from the actual checkout. In the table, `F` means
`LeanInfoTheory.Probability.FiniteTopology`, `T` means
`LeanInfoTheory.Probability.TotalVariationTopology`, and `S` means
`LeanInfoTheory.Shannon.Topology`. `E_F`, `E_T` and `E_S` mean the respective
permanent consumers `LeanInfoTheory.Examples.FiniteTopology`,
`LeanInfoTheory.Examples.TotalVariationTopology` and
`LeanInfoTheory.Examples.ChannelOptimization`. `U` and `E` mean
`LeanInfoTheory.Shannon` and `LeanInfoTheory.Examples`.

| Step | Required focused targets | Other minimum commands/checks |
| --- | --- | --- |
| C15.01 | `F E_F U E` | `static`, `trust`, and Section 6.2 fresh-import instance checks |
| C15.02 | `T E_T E_F U E` | `static`, `trust`, generic convergence and concrete boundary consumers |
| C15.03 | `F T E_F E_T U E` | `static`, `trust`, permanent generality consumers and Section 6.2 fresh-import instance checks |
| C15.04 | `F T S E_F E_T E_S U E` | `static`, `trust`, `documentation`, Section 6.2 checks with the completed umbrella, actual-objective attainment and the connected boundary limits |
| C15.05 | All C15 owners/consumers through the complete maintained suite | Authorized clean-candidate default suite, separate real two-pass `api-docs`, rendered-API inspection and fresh all-criterion review |

Expand the target names in
`python -B scripts/validate_release.py focused <targets>`; this command runs
warning-as-error builds. The other named commands use
`python -B scripts/validate_release.py <command>`. Compile the separate
instance probes with `lake env lean -DwarningAsError=true <probe>` and retain
their source, imports and actual results. Remove disposable Lean files after
recording their evidence; permanent mathematical/signature consumers remain
in the example owners.

Run `documentation` in C15.01--C15.03 too if that step changes README examples,
maintained website guide examples, or release-facing documentation contracts.
It is mandatory in C15.04 and is included in the C15.05 default suite.
`trust` already includes compiled compatibility and the all-project axiom
audit; do not duplicate a standalone `compatibility` run on identical inputs
merely to satisfy this table. During proof iteration, use focused checks;
the table specifies minimum completed-step evidence before closure.

Every theorem step needs its own source-applicable successful evidence after
its implementation. A prior step's checks do not validate newly added code.
Within a step, unchanged successful evidence may be reused only with an
explicit comparison of that check's source, configuration, dependencies,
generated policy inputs and relevant outputs. If those inputs change or a
failure/concern remains unresolved, rerun the affected check. A later prose-only
edit still needs document/link/diff checks and a recorded applicability
decision; static consistency never substitutes for compiled compatibility.
C15.05's clean default suite must be repeated after any checkpoint amendment,
and API-documentation evidence must meet the exact source/configuration/output
identity requirements in the review operations.

### 6.2 Named-instance integration checks

Use two separately compiled, fresh-import probes: one imports only the project
owner `LeanInfoTheory.Probability.FiniteTopology`, and the other imports only
the project umbrella `LeanInfoTheory.Shannon`. Do not supply local replacement
topology/compactness instances, assume the desired classes as hypotheses, or
add local `Fintype` instances just to make these checks pass.

Each must verify automatic synthesis of the proposed global topology, its
definitional agreement (`rfl`) with the underlying product/subtype topology,
and automatic `CompactSpace (PMF α)` synthesis with only `[Finite α]`.
Check empty, singleton and Boolean cases and direct use of the public
real-coordinate continuity and convergence interfaces. Rerun after C15.03's
changes to the probability owner and C15.04's completed umbrella additions.
Building the owner/umbrella and running
declaration/import/signature/trust audits do not by themselves establish
these instance-inference facts. The focused mathematical example owner must
not import the full umbrella merely to perform the second probe.

### 6.3 API, documentation and evidence duties

After approved public declarations/imports change, deliberately update the
current growth policy with real approval references and regenerate the current
public API, website blueprint and declaration index. Verify the frozen manifest
without writing it. Generated inventory supplies no mathematical or API approval.

During a dirty step use focused checks and `python -B scripts/validate_release.py static`;
do not weaken the clean gate. Run the maintained `documentation` mode when
release-facing examples/contracts change. Serialize artifact-producing builds,
retain actual commands/results and distinguish compiler acceptance from
mathematical interpretation. Trust permits only `propext`, `Classical.choice`
and `Quot.sound`; no placeholders, extra axioms or bypasses.

Search pinned mathlib and the project source/generated API before exposing
helpers. Keep evolving proof routes in [separate notes](post-release-chunk-15-notes.md).
Review new names under Future Work Note 14, private-helper pressure under Note 29,
current API docs under Note 9, and standing import/compatibility/milestone rules.
Do not fabricate downstream search friction or add aliases without evidence.

For future source-bound review explicitly capture the plan, notes, actual owners,
consumers, aggregate imports, affected current API policy/generated references,
applicable canonical docs, validation tooling, dependency configuration and the
exact relevant pinned mathlib files. Scope existing hygiene changes honestly;
exclude private review state, scratch and copyrighted references. Bootstrap and
helper feasibility reports are not independent PLAN/STEP acceptance.

## 7. Decisions and approval boundary

The proposed choices are: one forwarder for the existing subtype topology;
one real-simplex homeomorphism; one finite compactness instance;
a separate TV/topology bridge; direct finite-sum
Shannon continuity; fixed-channel probability maps; and private permanent generic
MI attainment without a capacity definition. These require review and exact plan
approval, not additional implementation during initialization.

Remaining tactical choices (constructor simplification, finite-sum rewriting,
private bounds, and exact proof-required external imports) may evolve in the
notes within these contracts. A change to mathematical meaning, required
assumptions/scope, important public contracts, acceptance policy or dependency
pins needs the lead.

Next authority required: an explicit formal PLAN-review request, followed by
approval of the exact resulting plan revision and then one named step request.
Clean-checkpoint and relocated-worktree reuse authority is deferred until the
final candidate is concrete. There is no setup blocker that justifies silently
substituting another reviewer or weakening an acceptance criterion.

