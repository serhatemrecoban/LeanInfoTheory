# Chunk 16 planning notes

These are advisory evidence, proof-route and implementation notes for the
[approved revision-2 plan](post-release-chunk-16.md). Date: 2026-10-13.
Sections 1--9 retain planning history; the later sections record C16.01--C16.04
implementation and C16.05 cumulative qualification history. These notes do not replace the execution
contract or original formal review. The plan owns requirements, scope,
public contracts and acceptance criteria.
Proof-route adjustments may update these notes with reasons; they cannot
silently change approved mathematical meaning or acceptance policy.

## 1. Intake and predecessor applicability

The user's pasted initialization request named this chat **Chunk 16**, designated
it the actual C16 planning and eventual implementation parent, and limited
current authority to initialization, inspection, narrow feasibility checks and
a proposed detailed plan. The chat was renamed accordingly. The authorized
checkout is `C:\Users\coban\Desktop\Lean Info Theory`, not the surrounding
chat's initial Documents directory. All repository work occurred in the former.

Read `AGENTS.md`, living-summary Quick Start and relevant architecture,
current-work/Future Work/validation material, C15's handoff, the chunk map,
current-state/reference documentation, targeted project-log entries and both
review documents. Inspected actual PMF/family/product/independence source and
the C15 topology and maximizing-input consumer. The source/current completion
record governs over stale pre-closure status prose in captured documents.

At intake and current source inspection, HEAD was
`0af7edcddc99fb01b2ec0658c0e800898b66632a`. The actual
`.lit-review/setup/c15-05-completion-20261013.json` reports
`SUPERVISED_STEP_COMPLETE`, production acceptance, no active step, all five
steps complete, all 17 criteria satisfied and zero findings. Closure:
`0ee38dfdf34e8328283d82654a4f5ab7b5263e0a3bfec1297fa6f06f46a73358`.
Final capture F:
`d346f66565c001670684f607ba62c84757a9716cb82104219ee93763abb1b979`.

The C16 parent freshly hashed all 232 real file entries in that capture and
found zero mismatches. `@environment` is a separate virtual entry, not a file
whose bytes were compared. Read-only installed inspection separately confirmed
the same HEAD, pin configuration and nine installed dependencies, all clean and
matching configured revisions. This establishes predecessor applicability; it
does not claim a newly run complete routine or a new C15 review. The original
completion's full clean routine and two-pass API-doc evidence retain their
original actors, paths and limitations.

The existing four modified files are preserved: `.gitignore`, `AGENTS.md`,
`docs/project-log.md`, and `docs/next-website-tasks.md`. Their SHA-256 values and
the three pin-file hashes were recorded before planning edits. No validation
checkout was created, inspected for reuse, or assumed available. No production
Lean file, documentation outside the two C16 planning documents, growth-policy
file or generated public artifact is changed by this planning work.

Private baseline records:

- `.lit-review/setup/c16-initial-protected-state-20261013.json`
- `.lit-review/setup/c16-c15-baseline-verification-20261013.json`
- `.lit-review/setup/c16-initial-inspect-20261013.json`
- `.lit-review/setup/c16-initial-api-20261013.json`

`python -B scripts/generate_current_public_api.py --check` passed during
planning: the current manifest matches source. Baseline counts are 669
supported declarations, 39 owners, 94 reviewed simp declarations and 92 root
exports. No growth approval is inferred from those counts.

## 2. Reviewer bootstrap history

Executed the installed read-only `inspect` and `api` commands, saving their
original JSON through the supported `--save` mechanism. These commands neither
open a plan session nor authorize mathematical work.

Actual originating `CODEX_THREAD_ID`:
`01a134aa-c212-7522-8ec6-7949e3e5245c`; canonical parent role `/root`.
Retained the exact user request and bootstrap intent before native creation.
Requested `collaboration.spawn_agent` arguments were:

```text
task_name = c16_reviewer
model = gpt-6-astra
reasoning_effort = ultra
fork_turns = none
```

The original creation result was exactly
`{"task_name":"/root/c16_reviewer"}`. The installed `bind` command succeeded
for C16, owned by this actual parent with purpose `CHUNK_IMPLEMENTATION`.
The original native `collaboration.list_agents` result contained this reviewer's
completed bootstrap acknowledgement: it had read the required reviewer documents,
assessed no proposal, made no edits/builds/commits/delegations, and awaited an
explicitly authorized source-bound request. The later revision-1 review is
recorded in Section 8 below.

The binding fixes the `collaboration` transport. Parent/reviewer **effective**
model settings and enforcement of parent-history isolation remain unknown;
the creation call records the **requested** profile and disabled copying.
Read-only instructions provide cooperative restrictions, not OS isolation.
No backend event ID, `agent_id`, submission ID or formal report was invented.
Local capture references are labelled as local. At bootstrap no plan or
execution session was opened, no formal review was dispatched, and no prior
chunk's binding was reused.

Private originals and supported binding:

- `.lit-review/setup/c16-reviewer-bootstrap-intent-20261013.json`
- `.lit-review/setup/c16-reviewer-creation-result-20261013.json`
- `.lit-review/setup/c16-reviewer-binding-input-20261013.json`
- `.lit-review/setup/c16-reviewer-binding-result-20261013.json`
- `.lit-review/setup/c16-reviewer-bootstrap-list-20261013.json`
- `.lit-review/setup/c16-reviewer-bootstrap-observation-20261013.json`
- `.lit-review/chunks/C16/binding.json`

Two separate support agents performed bounded planning research into product
feasibility and downstream consumers/references. They were not the persistent
reviewer and supplied no formal criterion assessments. Their work is source
research/probe preparation, not an independent plan-review certificate.

## 3. Reuse findings and precise source anchors

Paths below are relative to this checkout. Pinned mathlib paths use the prefix
`.lake/packages/mathlib/Mathlib/`.

| Purpose | Inspected declaration and owner |
| --- | --- |
| Existing private constructor | `familyProduct` and its atom/factorization/split lemmas, `LeanInfoTheory/Shannon/SemanticBridge/FiniteFamilyIndependence.lean`, beginning near line 75. It uses products of a supplied full law's coordinate marginals. |
| Normalization | `PMF.ofFintype`, `PMF.ofFintype_apply`, `PMF.support_ofFintype`, `Probability/ProbabilityMassFunction/Constructions.lean:204`; `PMF.tsum_coe`, `.../Basic.lean:63`; `Fintype.prod_sum`, `Algebra/BigOperators/Ring/Finset.lean:301`. |
| Support | `PMF.mem_support_iff`; `Finset.prod_eq_zero_iff` / `prod_ne_zero_iff`, `Algebra/BigOperators/GroupWithZero/Finset.lean:54,60`. |
| Injective atom transport | Project `PMF.map_apply_of_injective` and `map_apply_equiv`, `LeanInfoTheory/Probability/Finite.lean:131,181`. |
| Binary PMF law | `PMF.channelJoint`, its atom and `channelJoint_map_fst`/`channelJoint_map_snd` laws, `LeanInfoTheory/Probability/FiniteChannel.lean:64,94,130,151`. |
| Dependent reindexing | `Equiv.piCongrLeft`, `piCongrLeft_symm_apply`, `Logic/Equiv/Basic.lean:847,858`; `Equiv.prod_comp`, `Algebra/BigOperators/Group/Finset/Defs.lean:750`. |
| Predicate/complement split | `Equiv.piEquivPiSubtypeProd`, `Logic/Equiv/Prod.lean:468`; `Fintype.prod_subtype_mul_prod_subtype`, `Algebra/BigOperators/Group/Finset/Basic.lean:1035`. |
| Coordinate extraction | `Equiv.piSplitAt`, `Logic/Equiv/Prod.lean:480`; `Fintype.prod_eq_mul_prod_subtype_ne`, `Data/Fintype/BigOperators.lean:106`. |
| Injection onto range | `Equiv.ofInjective` and its inverse application lemmas, `Logic/Equiv/Set.lean:531–539`. |
| Sum split | `Equiv.sumPiEquivProdPi` / `prodPiEquivSumPi`, `Logic/Equiv/Prod.lean:352,361`; `Fintype.prod_sum_type`. |
| Block transport | `finSumFinEquiv`, `Logic/Equiv/Fin/Basic.lean:228`; `Fin.appendEquiv`, same owner:405; `Fin.append` and coordinate equations, `Data/Fin/Tuple/Basic.lean:307–322`; `Fin.prod_univ_add`, `Algebra/BigOperators/Fin.lean:159`. |
| Existing family representation | `FamilyOutcome`, `familyLawOf`, `familyMarginal`, `familyMarginal_restrict`, `LeanInfoTheory/Shannon/FiniteFamily.lean:42,51,57,143`. |
| Existing semantic predicates | `IsMutuallyIndependentFamily` / `IsMutuallyIndependentFamilyOf`, `.../SemanticBridge/FiniteFamilyIndependence.lean:54,67`; source-pair equivalence, restriction and entropy-equality APIs later in that same owner. |
| Stable binary product | `indepProd` and atom/support/marginal/measure interfaces, `.../SemanticBridge/Product.lean:45` onward. The low-level constant-channel joint has the same bind/map definition. |
| C19 bridge anchor | `isIndependentOf_iff_indepFun`, `.../SemanticBridge/Independence.lean:238`; pinned `ProbabilityTheory.IndepFun.variance_sum`, `Probability/Moments/Variance.lean:422`. |

Searches inspected the pinned PMF directory, relevant infinite-sum owners and
likely indexed-product declarations across mathlib. No existing finite
dependent PMF constructor or ready `tsum_pi`/finite-product normalization API
was found in those searches. This is a bounded search finding, not a claim
that no equivalent theorem exists anywhere. `ENNReal.tsum_prod` and
`tsum_prod'` in `Topology/Algebra/InfiniteSum/ENNReal.lean:98,101` are binary.

The finite-alphabet normalization is short: rewrite the total mass with the
reverse of `Fintype.prod_sum`; each component sum is one by `tsum_fintype`
and `PMF.tsum_coe`. This directly generalizes the inspected private proof to
arbitrary supplied component laws. Supporting infinite component alphabets
would require further summability/induction or measure-product infrastructure
with no identified C17–C19 need, so it is explicitly deferred rather than
silently assumed proved.

## 4. Proof-complete probes and limits

Planning probes use `lake env lean -DwarningAsError=true --stdin` in the
authorized primary checkout, with exact sources retained as ignored `.lean.txt`
evidence. They introduce no production Lean source or public declarations.
These are bounded proof checks against existing compiled dependencies, not
full release validation, a cold build, or implementation of an approved step.

The initial probe tests upstream signatures, an anonymous normalized-product
existence/atom proof, independent index/alphabet universes, dependent
precomposition orientation, the empty law on `Fin 0 → Empty`, and both
directions of `Fin.appendEquiv`. Its retained run exited 1 because an unverified
lookup used `PMF.fst_channelJoint`; the actual project name is
`PMF.channelJoint_map_fst`. A Python console encoding failure occurred while
printing Unicode after the raw streams and actual Lean result had already
been saved. Neither failure is erased or counted as a successful probe.

The support researcher prepared an additional bounded private proof of
dependent equivalence reindexing and sum splitting to `PMF.channelJoint`.
The parent combined it with the corrected initial probe for a serial Lean
check. Exact source, result and both output streams live under:

- `.lit-review/setup/c16-feasibility-probe-20261013.*`
- `.lit-review/setup/c16-dependent-transport-probe-20261013.lean.txt`
- `.lit-review/setup/c16-combined-feasibility-probe-20261013.*`

The corrected combined run passed with exit code 0 and warnings as errors in
21.410 seconds. Its exact source SHA-256 is
`2d51f9ce527a22df94847c7fd7d696e88280b0719263d839b49d0acc87c95a1c`.
Both dependent reindexing and sum splitting were accepted as complete proofs,
not merely checked as candidate signatures. The normalized constructor term,
empty-law witness and both Fin equivalence orientation examples also passed.
This does not establish the unimplemented contracts listed below.

### Advisory proof route for unimplemented contracts

1. **C16.01:** prove coordinate evaluation directly using private
   `Equiv.piSplitAt` mass splitting, finite product algebra and the existing
   `channelJoint_map_fst`. A direct marginal sum proof is also permitted.
   This helper is private Step 1 infrastructure, not an early public sum-split
   endpoint. L4's singleton round trip uses evaluation and the existing
   function equivalence. L1b's restriction of a larger family waits for Step 2.
2. **C16.02:** obtain reindexing from `PMF.map_apply_equiv` and `Equiv.prod_comp`. The map
   `(Equiv.piCongrLeft A e).symm` is ordinary dependent precomposition;
   transporting in the opposite direction introduces equality casts.
3. Split a product by a predicate/complement using
   `Equiv.piEquivPiSubtypeProd` and finite product partition algebra. The
   pushforward atom factors into the two block masses, hence is their
   constant-channel joint.
4. Derive subtype restriction from the first marginal of that joint. Combine
   range restriction with `Equiv.ofInjective` for arbitrary injective selection.
   These routes may reuse Step 1's private mass-splitting ideas without making
   Step 1 depend on the later public restriction theorem.
5. **C16.03:** derive Fin split/concatenation from sum splitting and reindexing, with
   `Fin.appendEquiv` fixing the prefix/suffix orientation. Iid only specializes
   these laws. Derive the pair law for distinct coordinates by selecting the
   corresponding two coordinates and splitting them.
6. **C16.04:** in the semantic owner, unfold existing family marginal/predicate meanings
   and use product restriction/evaluation. Reuse the low-level constructor in
   the old private `familyProduct`; never make the core import its bridge.

At revision 1, general injective restriction and coordinate marginals had only
the source-based routes above. The revision-2 probe below now establishes
those routes in a private scratch proof. All production APIs remain
unimplemented; full Fin probability transport and semantic bridge proofs
have not been established by these probes. Any unexpected need for stronger
hypotheses or a changed public contract still triggers plan-health review.

### Revision-2 marginal and injective-selection probe

The bounded support researcher proved coordinate/complement mass splitting
directly using `PMF.map_apply_equiv`, `Equiv.piSplitAt` and
`Fintype.prod_eq_mul_prod_subtype_ne`. Mapping that equality by `Prod.fst`
gives the coordinate marginal through `channelJoint_map_fst`. This proves
the C16.01 route without relying on any C16.02 public endpoint. The private
split helper uses classical equality internally; its public-facing marginal
statement needs no extra `DecidableEq` assumption.

The same probe also proves predicate/complement splitting, subtype
restriction, and complete general injective selection for independent index
universes and dependent alphabets. Selection composes range restriction with
reindexing along `Equiv.ofInjective`. Its function-plus-injectivity statement
specializes directly to the plan's embedding argument. A verified private
detail is aligning the two available range-enumeration instances locally:

```lean
let : Fintype (Set.range f) :=
  Subtype.fintype (fun i => i ∈ Set.range f)
```

The fourth retained attempt passed
`lake env lean -DwarningAsError=true --stdin`, exit 0, no diagnostics, in
17.129 seconds. Exact source SHA-256:
`276ac5e4cd8dda8bd11f650575576bc13e32fbebeb0a29d5530bc4bddcf1162f`.
Source, result and original streams are retained as
`.lit-review/setup/c16-marginal-selection-r2-attempt4-20261013.*`.
Attempts 1–3 remain alongside it: an overcomplicated `calc` failed elaboration;
then range/subtype `Fintype` instances disagreed; finally the style linter
required `let` instead of `letI`. Only the fourth complete command is counted
as passing. No timeout or failed command is relabelled as success.

The parent inspected the successful source and result. This is planning
feasibility supplied by the support agent, not the persistent reviewer's
assessment, a parent rerun, production implementation or release validation.

### Revision-2 signature elaboration

The parent extracted all 11 new theorem headers from the plan and checked
their universally quantified type expressions against temporary private
normalized-product/iid definitions and the existing semantic imports. The
check also included the generic selected-subtype evaluation signature with
only selected-alphabet finiteness. It added no project declarations and
proved none of those 11 theorem statements.

The corrected check passed
`lake env lean -DwarningAsError=true --stdin`, exit 0, in 20.982 seconds.
Source SHA-256:
`32ec41415cc72beacac0529abbdf5c9e705b700472634ac24d98ded7d86f72ae`.
Exact source, result and output are retained under
`.lit-review/setup/c16-r2-signature-probe-attempt2-20261013.*`.
The first attempt, retained under `c16-r2-signature-probe-20261013.*`, failed
only on unused bound proof/instance names in the generated `∀` expressions.
The second prefixed those names with `_`; it changed no types, assumptions,
plan headers or warning policy. The actual theorem proofs will use their
named hypotheses. These checks establish statement elaboration, not complete
Fin law proofs, semantic bridge proofs or permanent consumer coverage.

## 5. Downstream contracts and reference inspection

PW24's local PDF hash was freshly checked against the reference register:
`c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
The reference support agent read and visually inspected Section 6.1's
Theorem 6.1/proof on printed 106–107 / PDF 131–132, and Section 11.2's
Proposition 11.6/proof on printed 217–218 / PDF 242–243, using the PDF skill
and in-memory rendering. No PDF or page image was copied into source/evidence.

C16 uses these as product-law context. The textbook's information
tensorization, memoryless-channel statements and probabilistic AEP remain
C17–C19 endpoints. Its Section 11.2 typicality definition and later proof
wording use slightly different strict/closed inequalities; C19 must freeze
its own consistent event and support convention. C16 does not resolve that
future contract by introducing typical sets now.

Concrete pressure already exists: the private `ProductModel` in
`Examples.FiniteFamily` manually builds three independent bits with nested
binary products; the same file has a Boolean/ternary family model. C16's
retained sparse heterogeneous example checks a zero mass absent from an
all-positive product example. The length-three non-iid example prevents a
transport theorem from passing tests only because all coordinates coincide.

The low-level pair projection law is a useful C19 prerequisite independently
of C18. C19 can turn it into the existing `IsIndependentOf` and, with the
proper measurable structures/functions, mathlib `IndepFun`. The pinned
variance-of-sum theorem needs pairwise independence and `MemLp` assumptions;
C16 supplies no claim that those measure/integrability obligations are already
discharged. The sparse word `(0,2)` for ternary masses `1/2,1/2,0` supplies
C19's later counterexample to unrestricted self-information additivity.

The distinct-coordinate requirement is substantive: duplicating one fair
Boolean variable gives a diagonal pair with zero off-diagonal masses, while
its marginal product gives each off-diagonal atom mass `1/4`. An embedding
contract states exactly the selection that preserves coordinate independence.

## 6. Planning decisions and boundaries

The proposal uses five steps so generic laws precede block specialization and
semantic integration, while the final step is reserved for all-criteria
qualification. Each selected step remains separately reviewable and stops at
closure. All 15 criterion IDs are explicit in the plan; cumulative review
must assess every one.

Proposed ownership keeps generic PMF laws below Shannon and separates block
notation from the general constructor. Existing `FamilyOutcome`, marginals,
independence predicates and `indepProd` are preserved. The only proposed
change inside the old mutual-independence owner is a downward probability
import plus private constructor reuse. This avoids duplicate normalization
implementations without moving public declarations.

One dependent family uses a common fiber universe, with independent index
universes. No extra nonemptiness is assumed: supplied PMFs already ensure
nonempty support. Empty indices and empty selected alphabets are different;
`Fin 0 → Empty` has a unique outcome even though `PMF Empty` has no element.
The explicit finite-alphabet contract and these edge cases require lead
approval as part of the exact plan, not silent proof-time adjustments.

No wrappers are added just to meet the roadmap's rough declaration counts.
Generic atom/support laws serve iid directly; inverse reindexing, singleton,
zero-mass and real-coordinate variants remain consumer derivations. Public
pair independence is justified by C19's concrete probability argument. No
new entropy/KL additivity theorem, product channel or measure-product bridge
is selected.

The plan preserves the installed review, trust, documentation and compatibility
requirements. Its final clean full gate will need a separately authorized
scoped checkpoint and inspected checkout under `.worktrees/`. Preparing that
reviewable candidate precedes any permission request; preserving the four
unrelated pending paths is mandatory. `docs/next-website-tasks.md` is never a
C16 edit/checkpoint target.

## 7. Initial planning verification

Initial revision-1 evidence and protected-file verification are recorded in
`.lit-review/setup/c16-planning-final-verification-20261013.json`.
That record identifies the exact revision-1 plan/notes hashes, actual probe
results and final Git/protected-file state. It is a planning completion record,
not a supported mathematical step closure, a formal plan review or approval.

## 8. Revision-1 review and its applicability

The lead subsequently requested review while forbidding plan edits. The actual
C16 parent used the installed `plan-r1-20261013` session and the same bound
reviewer. The complete original report was received, classified `VALID` and
reconciled through the installed APIs. All 15 **proposed** criteria were
assessed `SATISFIED`, with no findings. This assessed feasibility and adequacy;
it did not establish production proofs, run future release gates or approve
implementation. The reviewer retained two failed scratch-wrapper attempts
and a successful corrected normalization/type-orientation probe.

Original revision-1 plan SHA-256:
`4aed769adfad2408836d379163e74ef740386194f90084574b92e024042fd10d`.
Original report SHA-256:
`4d2be3e92c459cc6a5e37a8b31cdff7689c7cf4fcc01124947d02656bc511db6`.
The empty native submission response was preserved as uncertain, with its
refusal; the correlated original full report subsequently confirmed delivery
through the supported append-only operation. No receipt was rewritten.

Retained private records include:

- `.lit-review/setup/c16-plan-r1-original-report-20261013.json`
- `.lit-review/setup/c16-plan-r1-parent-reconciliation-20261013.json`
- `.lit-review/setup/c16-plan-r1-final-result-20261013.json`
- `.lit-review/setup/c16-plan-r1-final-readonly-verification-20261013.json`

That review left the plan and notes unchanged and verified all 239 captured
real source files unchanged. The parent separately presented five optional
refinements; these were not findings attributed to the reviewer.

The lead then supplied a General Assistant advisory review with three further
suggestions. Its author reported read-only source/evidence inspection and no
Lean rerun. Treat it as user-supplied advisory input, not a substitute for the
installed source-bound report. No cross-thread message was sent to obtain it.

The present instruction authorizes choosing and applying useful suggestions.
It does not approve the revised plan or select an implementation step. The
revision-1 report and session remain immutable historical evidence: changes
to contracts or consumers are not covered by that old source capture. A new
formal review, if requested, uses a fresh session and the same reviewer.

## 9. Revision-2 advisory decisions

The selected combination improves precision and integration coverage while
retaining the five-step structure, 15 criterion IDs, three proposed owners,
public declaration set, finite-alphabet scope and later-chunk boundaries.

| Advisory suggestion | Disposition and reason |
| --- | --- |
| Parent: complete critical Lean signatures | **Accepted.** Explicit binders, instances, argument order, dependent target types and map directions now appear for evaluation, restriction/reindexing, sum/pair projection, Fin transports, iid and semantic bridges. In particular, split lengths are explicit because `m+n` does not determine them. |
| Parent: probe marginal/non-surjective restriction feasibility | **Accepted as bounded planning work.** Target the shared proof risk, with original sources/results retained. Probe success is evidence about that scratch proof, not implementation or a new approval gate. See Section 4 for exact coverage and limits. |
| Parent: resolve L1's Step 1/Step 2 boundary | **Accepted.** L1a supplies atoms, coordinate marginals and sparse outcomes in C16.01; L1b invokes the public singleton restriction interface in C16.02. The separate singleton-index round trip remains in L4/C16.01. |
| Parent: rename `Probability.Iid` | **Not selected.** Retain the compact existing proposal and document it as finite homogeneous block transports and iid laws. Its general non-iid signatures are explicit; a rename adds little proof or consumer value. Reconsider only on actual discovery friction. |
| Parent: add paired-law support regression | **Deferred for C18 planning.** C16 already tests zero masses, support and empty blocks. Comparing two product supports is most directly useful with C18's required singular-product KL cases; no new C16 consumer or public lemma is needed now. |
| General Assistant: resolve marginal-proof dependency early | **Accepted together with the marginal probe.** A minimal private coordinate/complement split belongs to C16.01 when needed; public general splitting remains C16.02. This removes the apparent forward dependency without moving an endpoint. |
| General Assistant: finite subset of an infinite ambient family | **Accepted as L6 within C16.01.** The generic signature assumes finiteness only at selected indices. A concrete `ℕ` ambient type with infinite unselected alphabets makes accidental stronger assumptions detectable. The lightweight consumer uses the dependent function outcome directly, without importing Shannon's `FamilyOutcome`. |
| General Assistant: full three-coordinate mutual independence | **Accepted within S1/C16.04.** Reuse L2's non-iid component data and invoke the new public mutual-independence bridge on the full atom. Repeat tiny private fixtures where import/privacy boundaries require it. No extra XOR fixture or entropy identity is added. |

The selected-subtype constructor consumer and the full-law semantic theorem
have different assumptions deliberately: the latter starts with a finite full
product, while L6 supplies only a finite selected component family. The
source-facing identity-family consumer uses `PMF.map_id` after unfolding
`familyLawOf`; it must not assume those PMFs are definitionally identical.

Revision-1 document bytes are preserved privately as
`.lit-review/setup/c16-r1-original-post-release-chunk-16.md.txt` and
`.lit-review/setup/c16-r1-original-post-release-chunk-16-notes.md.txt`.
Revision-2 verification, final document hashes and protected-file checks belong
to `.lit-review/setup/c16-plan-r2-final-verification-20261013.json` when the
revision is finalized. Only these two planning documents and ignored private
evidence are edited; no production step, commit or publication is performed.


## 10. C16.01 implementation and qualification, 2026-10-13

The lead accepted revision 2 and freshly requested "Continue Step 1 with
review." The supported intake accepted C16.01 and captured its baseline.
The earlier parent mistake (passing a user observation instead of the
workflow authority record) remains a consumed `AUTHORITY_SCHEMA` failure;
subsequent conditional Step 2--5 requests were ineligible and are not queued.
No session, binding, refusal or original receipt was rewritten.

The new focused probability owner exposes exactly six Section 3.1 declarations.
Normalization reuses `PMF.ofFintype` and `Fintype.prod_sum`; support uses finite
product nonzeroness. The private `Equiv.piSplitAt` law gives coordinate marginals
through `channelJoint_map_fst`, without any C16.02 public result. Index and
alphabet universes remain independent and all public assumptions are unchanged.
The pure-product proof was shortened to reuse the project's existing
`eq_pure_iff_support_eq_singleton` and upstream `apply_eq_one_iff`. An unnecessary
direct `Data.Fintype.Pi` import was removed; the finite distributivity import
already supplies it. These are in-scope proof/import choices, not plan changes.

L1a exercises sparse Boolean/ternary atoms, both marginals and supported/impossible
outcomes. L4 covers generic dependent singleton round trips, their sparse-law
specialization, empty indices with empty alphabets, pure coordinates, singleton
alphabets and impossible selected empty fibers. L6 exposes only selected-fiber
finiteness for arbitrary ambient indices; its concrete ℕ fixture uses Bool and
Fin 3 at 0 and 1, with ℕ at all unselected indices. Dependent pattern matching
makes the selected component endpoints definitionally the intended laws, avoiding
unnecessary equality casts. Every consumer declaration remains private.

The source-bound implementation/edit records and command logs are under
`.lit-review/setup/c16-01-20261013/`. The initial owner attempts exposed the
explicit argument arity of `pure_apply_of_ne`; their diagnostics are retained,
including a console-encoding failure after raw logs were already saved. The
simpler final pure proof reuses existing PMF facts. The first full focused build
compiled the owner, then found consumer simplification/cast issues and a full
umbrella line-length warning. These were corrected without changing contracts
or weakening warnings. Compiler-generated placeholder warnings from those failed
elaborations are failure diagnostics, not inserted source placeholders.

All required parent checks passed for the fixed implementation: focused
warning-as-error builds (owner, consumer, root/full/example aggregates), standalone
consumer compilation, a fresh probability-only import probe, static/generated
checks, documentation, compiled compatibility and the all-project trust audit.
The retained validation input/output inventories are identical. Current coverage
is 675 supported declarations in 40 owners, with 94 reviewed simp declarations
and 92 root exports. All 601 retained signatures match; the 2,273-constant
all-project audit permits only `Quot.sound`, `Classical.choice` and `propext`.
The probability owner's local closure is `Finite`, `FiniteChannel` and
`FiniteProduct`; the lightweight root's closure and dependency pins are unchanged.

The persistent reviewer independently assessed all three C16.01 criteria as
`SATISFIED`, with no findings. Its complete original report and genuine native
completion observation are retained separately from parent checks. The parent
reconciled every criterion and the report's verification limits. Empty immediate
dispatch output remains an uncertain receipt; the correlated original report
separately established delivery. Requested reviewer settings remain distinct
from unobservable effective settings, and cooperative read-only review is not
OS-enforced isolation.

The first original report was retained but refused because one evidence source
reference omitted two hash characters. A supported retry obtained a separately
preserved complete report from the same reviewer on unchanged physical source,
with accurate source references and a corrected policy-file path. The refusal,
original assessments and reused-check limits remain visible; no parent edited
the reviewer's original report or changed its substantive conclusions.

Final documentation corrects the stale proposed-plan introduction and clarifies
direct local imports. These bounded chronology/wording edits change no Lean
source, public contract, validation configuration or pinned dependency. Final
static checks and explicit source applicability are retained privately. The
source-bound completion record, when present at
`.lit-review/setup/c16-01-completion-20261013.json`, establishes closure; this
captured document does not. Full clean routine and actual two-pass API-doc
qualification remain C16.05 duties. No C16.02 endpoint, commit, push or
publication is selected.


## 11. C16.02 implementation and qualification, 2026-10-13

The fresh conditional Step 2 request was admitted only after the parent verified
C16.01's successful closure and all 244 final-source entries. Its original
review and reconciliation remain predecessor evidence; new Step 2 checks and
review are recorded independently under `.lit-review/setup/c16-02-20261013/`.
Earlier consumed conditional requests remain history, not queued authority.

The four public endpoints keep Sections 3.2--3.3's exact binders, universes,
map directions and hypotheses. Reindexing first compares masses through
`Equiv.piCongrLeft` and `Equiv.prod_comp`; injective selection then restricts to
the embedding's range and reindexes through `Equiv.ofInjective`. A private
predicate/complement split derives the private subtype marginal. The range's
local `Fintype` instance is aligned explicitly, as established by the retained
planning probe. No public decidability, nonemptiness or positivity premise is
introduced. Sum splitting compares atoms through `Equiv.sumPiEquivProdPi` and
finite product splitting over a sum.

For ordered coordinate pairs, reuse the existing private coordinate/complement
split, then map the complement to the second coordinate using
`finiteProduct_map_eval`. This avoids an extra two-index encoding and derives
the exact constant-channel joint law with the required distinctness hypothesis.
This is an in-scope improvement to advisory proof order: Section 4's historical
C16.03 pair-route note does not move the public pair endpoint out of C16.02.
All predicate/range/coordinate helpers remain private. The focused
`Logic.Equiv.Basic` and `Logic.Equiv.Set` imports expose the actual reindex/range
owners; Basic supplies the existing splitting owner transitively. No new local
project dependency or simp attribute is introduced. Names follow the approved
finite-product map family without a new alias or naming-watch entry.

L1b uses the public injective restriction theorem on the original heterogeneous
sparse law. L2 adds a third, biased Boolean component with masses one quarter
and three quarters, distinct from the first fair Boolean law. The dependent
index is `Bool ⊕ Unit`; nested three-to-two-to-one selection is compared to the
direct embedding by `PMF.map_comp`. Heterogeneous reindexing retains the exact
transported alphabet and maps back through the inverse equivalence. L3 splits
that same non-iid family, reconstructs it, checks both block projections and
both ordered sparse coordinate pairs, and covers either empty side with generic
independent index universes. L5 proves the duplicated fair coordinate has half
mass on each diagonal atom and zero off-diagonal, while the independent pair
has quarter mass; the repeated-coordinate restriction itself is not the product.
These private consumers preserve the Step 1 cases and the sole focused import.

The first owner proof compilation passed with warnings as errors and no
diagnostics; its exact snapshot, command, result and streams remain under
`proof-work/`. The final supported owner build also passed. Consumer attempts 1--2 exposed
only dependent-codomain transparency and lambda-inference errors in private
examples; their original diagnostics remain under `consumer-work/`. Explicit
map domains and typed congruence/composition proofs resolved them. Attempt 3
passed with warnings as errors and empty diagnostics, preserving every fixture
and statement. Focused aggregates, the fresh import/universe probe,
static/generated checks, documentation and full trust/compiled compatibility
have separate retained outcomes.
A successful scratch snapshot is not claimed as full-candidate validation.
The current growth policy records the fresh user authority and exact imports;
current generated coverage is 679 declarations in 40 owners, with the same
94 reviewed simp declarations and 92 root exports. Historical API identity is
verified without rewriting its manifest.

Independent source-bound review, reconciliation, final validation and closure
remain recorded separately. Only
`.lit-review/setup/c16-02-completion-20261013.json`, when present, establishes
successful Step 2 completion. Full clean routine and actual two-pass API-doc
qualification remain C16.05 duties. No later step, checkpoint, push or
publication is selected.


### C16.02 validation and original-report reconciliation

All required parent gates passed on an unchanged captured source inventory:
focused warning-as-error owner/consumer/root/full/example builds, standalone
consumer compilation, fresh independent-universe transport signatures and axiom
probes, static/generated checks, documentation and full trust/compiled compatibility.
All 601 retained signatures match; current coverage is 679 declarations in
40 owners, with 94 reviewed simp declarations and 92 root exports. The project
axiom audit permits only `Quot.sound`, `Classical.choice` and `propext`.

The same persistent reviewer returned one original source-bound report satisfying
all three C16.02 criteria with no findings. Its fresh focused build, standalone
consumer compilation, independent transport/import/axiom probe, static checks and
all nine documentation examples passed. The full trust gate remains parent-run
evidence, independently inspected and reused after source/configuration/dependency
applicability checks. The parent preserved and reconciled all eight original
evidence entries and three criterion assessments separately, including those
limits. The genuine empty immediate dispatch result remains uncertain;
the correlated original report separately confirms delivery. Neither hashes nor
cooperative read-only conduct establish authentication or OS isolation; requested
reviewer settings remain distinct from unknown effective settings.

Only five owned Markdown documents change after review, to record actual
validation and reconciliation. Mathematical source, public/import/simp policy,
generated references, validation configuration and pinned dependencies remain
identical. Fresh final static validation and explicit full-inventory applicability
are retained before final capture. The private completion record above, when
present, establishes closure. No later step or checkpoint is authorized.

## 12. C16.03 implementation decisions and qualification

The fresh conditional Step 3 request was admitted on 2026-10-13 only after
verifying C16.02's supported closure and all 244 final-source inventory entries.
The active owned edit covers the new probability and private consumer files,
approved aggregate/policy growth, generated references and current documentation.
The normative plan, previous product source/consumers and unrelated pending
changes remain unchanged. Earlier consumed conditional messages stay consumed.

`Probability.Iid` imports only `Probability.FiniteProduct` and the pinned
`Mathlib.Logic.Equiv.Fin.Basic`. Its four public declarations have exactly the
approved Section 3.4 signatures. `iid` is definitionally the constant-family
finite product; it has no second normalization or representation. Permutation
invariance directly specializes the public reindexing theorem. Generic atom,
support, coordinate and injective-selection laws are consumed privately after
unfolding this thin definition; no redundant public wrappers are added.

The generic split first reindexes a `Fin (m+n)` product along `finSumFinEquiv`,
then applies the sum split. The resulting map computes to the inverse of
`Fin.appendEquiv m n`, with `Fin.castAdd n` prefix and `Fin.natAdd m` suffix.
Concatenation maps back through that equivalence and simplifies the existing
`Fin.append_left`/`Fin.append_right` equations. The proofs introduce no helper
declaration, new simp attribute, positivity premise or iid restriction on the
component families. Explicit split lengths preserve the approved call shape.
This realizes the advisory proof route without changing the public contract.

The parent inspected the pinned definitions of `finSumFinEquiv`,
`Fin.appendEquiv`, `Fin.append`, `Equiv.piCongrLeft` and
`Equiv.sumPiEquivProdPi`, together with the actual product/map laws. The earlier
PW24 reference inspection remains the product-notation/downstream context;
these new transport proofs use PMF and equivalence algebra and establish no
information identity or AEP statement. No external formalization was consulted.

The first owner focused validator passed with warnings as errors and no Lean
diagnostics in 271.281 seconds. The exact source and original result/streams
are retained under `.lit-review/setup/c16-03-20261013/proof-work/`. After that
successful command, the outer wrapper encountered a console Unicode error while
replaying Lake's checkmark; the saved validator result and raw streams were
unaffected. That reporting failure remains separately recorded, not hidden or
misclassified as a proof failure or successful command.

Consumer attempts 1--2 are retained with their actual failures: a private fixture
name conflicted with Lean's `prefix` keyword, the concrete Fin permutation
inequality needed an explicit decidable proof, and the non-iid split needed an
explicit `change` to expose its private law alias before simplification. These
were private elaboration issues; no fixture or theorem statement was weakened.
Attempt 3 passed with warnings as errors and empty diagnostics in 18.98 seconds.
Its exact source/owner snapshots and all original streams/results remain under
`consumer-work/`. The subsequent parent gates validate the integrated candidate
separately from this consumer-only check.

`Examples.Iid` independently imports only the focused owner. Its private fixtures
use a fair Boolean law, a biased Boolean law proved different from it, and a
sparse ternary law with masses one half, one half and zero. B1 uses generic
product laws for exact iid masses, support and coordinates, a nonidentity
three-coordinate swap and injective selection of the last two coordinates.
B2 constructs a fair/biased/fair block, proves its nonidentical components,
splits it as `1+2`, reconstructs it through the other public transport and
checks all three coordinate orientations. It specializes both transports to
iid and retains zero/one lengths, inverse singleton transport, both empty
sides and singleton alphabets. B3 gives zero mass/non-support for `(0,2)` and
quarter mass/support for `(0,1)`. A separate general product on `Fin 0 → Empty`
and the impossibility of a base `PMF Empty` state the empty-alphabet distinction.

The full Shannon and Examples aggregates add their respective focused owner
without removing retained imports. The current growth policy records actual
Step 3 authority and exact direct imports; generated current coverage is
683 declarations in 41 owners, with the existing 94 simp
declarations and 92 root exports. Required parent validation, source-bound
independent review, reconciliation and final applicability have separate records
under `.lit-review/setup/c16-03-20261013/`. Only the completion record
`.lit-review/setup/c16-03-completion-20261013.json`, when present, establishes
closure. C16.04 semantics and C16.05 cumulative clean/API-doc qualification remain
later duties; no checkpoint, push or publication is selected.


### C16.03 validation and original-report reconciliation

All required parent gates passed on the same captured source inventory: focused
warning-as-error owner/consumer/root/full/example builds, standalone consumer
compilation, fresh focused Iid signature/universe/axiom probes, static/generated
checks, documentation and full trust/compiled compatibility. All 601 retained
signatures match; current coverage is 683 declarations in 41 owners, with
94 reviewed simp declarations and 92 root exports. The axiom audit permits only
`Quot.sound`, `Classical.choice` and `propext`.

The same persistent reviewer returned an original report satisfying all three
C16.03 criteria with no findings. The parent preserved and separately reconciled
its complete criterion and evidence record, including actual verification limits
and the distinction between fresh reviewer execution and reused parent evidence.
Two native transmissions contained inventory-hash transcription errors; their
original calls and exact-message refusals remain retained. The final corrected
transmission preserved the unchanged prepared request and source. The reviewer
independently verified the corrected identities. The genuine empty immediate
receipt for that final transmission remains uncertain; the correlated original
report separately confirms delivery. Cooperative provenance and source
hashes do not establish authentication or OS isolation; requested model settings
remain distinct from unknown effective settings.

Only five owned Markdown documents change after review to record actual outcomes.
Mathematical source, public/import/simp policy, generated references, validation
configuration and dependency pins remain identical. Fresh final static validation
and explicit full-inventory applicability precede final capture. Only the private
completion record above, when present, establishes closure. No later step or
checkpoint is authorized; C16.05 retains clean routine and actual API-doc duties.


## C16.04 implementation decisions, 2026-10-13

The fresh conditional Step 4 request was admitted only after successful Step 3
review closure and exact comparison of all 246 final-source entries. Earlier
consumed conditional skips remain history. Normative revision-2 requirements
are unchanged; this entry records implementation choices and evidence limits.

The new semantic owner has exactly the three approved public bridges. The
selected-marginal equality is the generic restriction theorem for the subtype
embedding. Mutual independence then rewrites the selected product atom and
each coordinate marginal through the existing public laws. Distinct-coordinate
independence uses the released map-equals-independent-product characterization
and the generic pair law; the constant-channel joint and `indepProd` agree
definitionally. No independent normalization, measure independence framework,
entropy identity, public alias, helper or simp attribute is introduced.

The existing private `familyProduct` now applies `PMF.finiteProduct` to its
selected coordinate marginals. Its signature still has arbitrary ambient
indices, and the unchanged atom theorem remains definitional. Both public
predicates and every declaration after that constructor remain text-identical;
all retained imports remain, with only the approved downward probability import
added. The module prose now identifies the public constructor and private
wrapper explicitly. Both probability owners and their consumers remain unchanged.

The private semantic consumer imports only the focused semantic bridge. Its
fair Boolean/sparse ternary family exercises `FamilyOutcome`, selected marginal
and support formulas, empty/singleton/two-coordinate mutual independence,
identity-source semantics, both ordered `indepProd` pairs and zero mass for
an impossible trit. A third biased Boolean law, proved different from the fair
law, gives the full three-coordinate atom with cardinality three. The new public
mutual-independence bridge supplies its full factorization and source-family
application directly. Existing `isIndependentOf_iff_indepFun` composes with the
new coordinate bridge under explicit measurable hypotheses; no C18 owner or
new C19 infrastructure is needed.

The parent inspected the actual predicate, family restriction and identity-law
definitions, the pair independence characterization and `indepProd`, and the
pinned PMF map/product algebra. The earlier registered PW24 product-notation
and downstream reference inspection remains relevant context; these semantic
bridges derive from existing exact definitions and establish no entropy, KL,
self-information or AEP theorem. No new textbook inspection or external
formalization search is claimed.

The semantic aggregate and Examples aggregate include the respective new owner;
the root and full Shannon umbrella bytes remain unchanged. Current growth policy
records both the new owner and the old owner's approved import addition. Source
generation is deliberate and separate from authority. Exact source comparisons,
original owner/consumer attempts and subsequent parent checks are retained under
`.lit-review/setup/c16-04-20261013/`. Failed attempts, if any, remain separate from
passing integrated gates; source review and independent review remain separate
from proof compilation. Only `.lit-review/setup/c16-04-completion-20261013.json`,
when present, establishes closure. C16.05 retains cumulative clean routine and
actual two-pass API-doc qualification. No later step, checkpoint, push or
publication is selected.


### C16.04 validation and original-report reconciliation

The first focused owner build passed in 302.928 seconds. The subsequent old-owner
change was only the overview clarification; the integrated focused gate rebuilt
that final source. The private semantic consumer passed on its first standalone
warning-as-error attempt in 23.07 seconds, with no diagnostics or source repair.

All required integrated gates passed on identical captured source/environment
inventories: focused probability/semantic owners, old/new/lightweight consumers,
root and aggregates; independent consumer and semantic import probes;
static/generated checks; documentation; and full trust/compiled compatibility.
The semantic probe confirms both retained predicates remain type-generic, and
a finite subset of an arbitrary ambient index type needs only selected finite
alphabets for product construction and its mutual-independence bridge. All
601 retained signatures match; coverage is 686 declarations in 42 owners, with
94 simp declarations and 92 root exports. Only `Quot.sound`, `Classical.choice`
and `propext` are permitted by the project axiom audit.

The same persistent reviewer returned one original source-bound report with all
three C16.04 criteria satisfied and no findings. The parent preserved and separately
reconciled the complete report, each criterion and each evidence entry, including
verification limits and the distinction between fresh independent execution and
reused parent evidence. The native transport receipt and correlated original
report are retained separately; no acknowledgement or effective model setting is
inferred from absent metadata. Cooperative source/provenance records establish
neither authentication nor OS isolation.

Only five owned Markdown documents change after review to record these outcomes.
Mathematical source, policy, generated references, validation configuration and
dependency inputs remain identical. Fresh final static checks and complete
inventory comparison establish final applicability before capture. Only the
private completion record above establishes closure. C16.05 remains unselected
and retains clean routine and actual two-pass API-doc duties. No checkpoint,
push or publication is authorized.


## C16.05 cumulative preparation, 2026-10-13

The fresh conditional Step 5 request was admitted after verifying C16.04's
supported completion, all four predecessor closures in order and all 248
entries of Step 4's final source. Earlier consumed requests remain history.
Step 5 adds no mathematical endpoint. Source audits find all twelve predecessor
criteria represented by actual owners and private consumers. Their historical
reports and current applicability are reconciled separately; they do not replace
fresh review of all fifteen criteria.

The [handoff](../handoffs/chunk-16.md) gives all seventeen public names and
useful focused imports. It distinguishes ten general-product contracts and two
Fin transports from thin iid/permutation and semantic adapters. Current coverage
is 686 declarations in 42 supported owners, with 94 simp declarations and 92
root exports. No public helper, alias, instance or attribute is added at closeout.
The existing architecture, source-family meaning, finite selected-subtype
construction, sparse support and empty/transport conventions remain unchanged.

Canonical status, architecture, active/future work and validation context now
refer to C16.05, including the previously stale C15.05 source-snapshot/future-work
rows. The roadmap receives editorial execution status only; future contracts
remain unchanged. The reference register records bounded PW24 context already
inspected during planning. No new textbook inspection or information identity
is claimed. C17/C18/C19 obligations and private-helper/alias reopening triggers
remain distinct in the maintained handoff.

The exact owned checkpoint must be prepared before its separate authorization.
The existing detached checkout inside `.worktrees/` was inspected read-only:
it is clean at C15's HEAD with all nine clean root dependencies matching pins.
That inspection is not authority to reuse it. Exclude `.gitignore`, `AGENTS.md`,
`docs/next-website-tasks.md` and the old project-log relocation entry from any
checkpoint while preserving their working bytes. Clean routine qualification,
actual two-pass file-mode API documentation/owner inspection, fresh cumulative
review, original-report reconciliation and final source applicability remain
required. Only the private C16.05 completion record establishes closure.


### C16.05 actual API-documentation qualification

The actual current file-mode API-documentation gate passed both build/check
passes on stable source inputs (659.475 seconds). All 17 new declaration HTML
blocks were inspected for exact owner, signature, hypotheses, docstrings and
file source links; rendered inspection covered all three focused owner pages.
The exact v2 source/configuration/dependency identity, relevant-output digest
and two-pass attestation are retained privately. Whole-tree digest evidence
comes from the maintained gate, separately from the fresh owner-page inspection.
The reviewed Zig 0.16.0 and pinned incremental caches were used; no cold rebuild
or publication qualification is claimed.

The first attempt failed after new declaration extraction because the aggregate
HTML reused an old completion marker and omitted all three owner pages. The
original 529.920-second failed result and unchanged-input captures are retained.
After inspecting the pinned generator, the parent preserved and invalidated
exactly its three ignored Shannon HTML marker/hash/trace files and reran both
actual passes. No source, dependency or validation rule changed. Replayed
upstream Qq extraction warnings remain in the logs. Current output remains in
`docbuild/.lake/build/doc/`, outside the frozen historical release route.

The clean complete routine still awaits separate checkpoint/reuse authority.
The API-doc result does not replace that gate, fresh all-15-criterion review,
original-report reconciliation or final-source applicability. The source-bound
private completion record alone establishes eventual closure.


### Authorized initial checkpoint qualification, 2026-10-14

On 2026-10-14 the lead authorized the exact prepared 24-file local checkpoint,
necessary C16.05-only corrections and final-evidence amendments within those
paths, and reuse of the inspected clean detached validation checkout. The
three protected files and pre-existing relocation log entry remain excluded.
The authorized checkout is
`C:/Users/coban/Desktop/Lean Info Theory/.worktrees/LeanInfoTheory-C12-validation-20261003`.
No push, tag, publication, dependency/review-setting change or later-chunk work
is authorized by this scoped approval.

Initial checkpoint `d9a3f32d396cbad91c10c7778b00d0cae50361e3` passed the complete
maintained clean routine suite; the runner recorded 3293.619 seconds.
The actual command was `python -B scripts/validate_release.py` in the authorized
validation checkout. Its recorded exit code is zero. The checkout was clean
and detached before and after the suite, its tracked files equal the exact
committed blobs, and all 24 selected blobs match the proposal. Primary and
validation inputs stayed unchanged during the suite; all nine root dependencies
remained clean at their configured revisions, and authority inputs were unchanged.
Original streams, actual command/result, source inventories, checkout comparison
and dependency identities remain under
`.lit-review/setup/c16-05-20261013/full-checkpoint/`.

The complete maintained gate includes default and strict builds, README and
website-guide consumers, retained/current compatibility, import/root/simp
contracts, the permitted-axiom audit, generated references, legal/release
metadata, website checks and final clean hygiene. Existing incremental caches
were used; this is not a cold rebuild or a replacement for mathematical review.

The primary checkout retains `.gitignore`, `AGENTS.md`,
`docs/next-website-tasks.md` and the exact earlier relocation log entry. The first
three files are excluded wholesale; the mixed project-log selection excludes
only that historical entry and preserves its original working bytes. The two
selected blueprint files differ only by declared CRLF/LF representation across
checkouts. The historical C9-notes/frozen-manifest CRLF/LF differences are also
recorded. Whole-checkout raw-byte identity is not claimed.

The earlier actual two-pass current file-mode API-doc gate (659.475 seconds)
and inspection of 17 declaration blocks/all three owner pages remain separate
evidence, bound to their exact primary source, configuration, dependencies and
recorded outputs. This clean routine neither reruns that gate nor renews its
attestation. Its applicability to the checkpoint and each amendment must be
recorded separately, accounting for the declared cross-checkout differences.
The retained initial API failure, bounded cache recovery and output provenance
are unchanged; local output is not publication evidence.

This qualifies the initial checkpoint, not subsequent amendments. Every
amended candidate requires complete clean routine revalidation and exact
API-documentation/source/configuration/dependency applicability. Finished
owned edits, retained contextual self-review and separate reassessment, and
earlier-report reconciliation must establish readiness before fresh review
of all 15 criteria. The original cumulative report, its reconciliation,
final-source qualification and supported closure remain required. Only
`.lit-review/setup/c16-05-completion-20261014.json`, when present, and the user report
establish actual final completion; this captured prose is provisional.
