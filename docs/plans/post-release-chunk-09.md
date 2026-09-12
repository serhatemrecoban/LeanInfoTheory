# C9: Growth-Safe Validation and Bounded Generic Helpers

<!-- lit-review-status:start -->
**Plan status:** Approved; normative revision 2, 2026-09-11. Approval follows the lead's acceptance of the exact presented revision and subsequent explicit C9.01 request. Original presented full-file SHA-256: `b9914d8569de54baff0296ba6a40539f628dd841cee53c9dd3ed9c4302276bec`. Formal plan review has not been performed.
**Execution status:** C9.01--C9.06 completed independent review, reconciliation and durable closure. C9.06 closure is `82a1b5a429693718c24f2863d7d077c5010d9403e5836e5a30c61d307be16263`; its final source `f30aff1842d2b3b3fc95aca37eda1e2a5e4484b26694371ed7a7ef482c4fd559` was unchanged at C9.07 ingress. The explicit conditional request selected C9.07 only. Both selected helpers and private consumers are delivered; C9.06's original process findings remain disclosed and reconciled without retroactive compliance. C9.07 is preparing canonical reconciliation and the [maintained handoff](../handoffs/chunk-9.md). Its separately authorized clean checkpoint, complete routine suite, cumulative fixture matrix, current two-pass doc-gen, fresh full-chunk review and private closure remain pending. C10 is not selected.
**Parent task:** `01a090e5-167c-7181-8201-e0647c4c5e25`.
**Reviewer bootstrap:** The same `/root/c9_reviewer` remains bound through the installed collaboration adapter. Original native results and the initial refusal remain preserved. Requested profile: gpt-6-astra/ultra with no copied parent history; effective settings remain unreported. Formal plan review has not occurred.
<!-- lit-review-status:end -->

**Plan path:** `docs/plans/post-release-chunk-09.md`
**Step order:** `C9.01`, `C9.02`, `C9.03`, `C9.04`, `C9.05`, `C9.06`, `C9.07`.
**Checkout:** `C:\Users\coban\Desktop\Lean Info Theory`.
**Intake HEAD:** `80ea016c7ac64bb5bd79b2f769227a3fb2ccc3b3`, with pre-existing dirty/untracked documentation and review installation preserved.
**Historical release:** `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f` (`v0.1.0`).
**Toolchain:** Lean/mathlib `v4.33.1`; mathlib manifest/installed revision `0df444a360eaa60ab8c11dca51a86af692955474`.
**Context:** [proposed map, revision 2](post-release-chunk-map.md#c9-post-release-complementary-work), [reference register](../references.md), [review protocol](../review-protocol.md), [review operations](../review-operations.md).

## 1. Objective and authority

Make compatible library growth verifiable without rewriting the released API
baseline, then deliver the two explicitly selected generic helper contracts in
Section 4. The proposed map supplies context; approval of this exact detailed
plan selects C9's scope only. It does not approve C10--C24 or a release.

**C9-AUTH-01:** Production implementation requires explicit approval of this exact
plan revision and one subsequent eligible message naming one approved step.
Each such message authorizes that step's implementation, validation, self-review,
separate reassessment, independent review, reconciliation, corrections and scoped
closure; then the assistant stops. It does not authorize a later step.

**C9-AUTH-02:** Plan review is requested separately and uses the installed workflow
with the same persistent reviewer. A favorable review is evidence, not plan
approval. Preserve original native results, actual parent/reviewer identities,
requested versus observable settings, and refusals. Resolve the current native
schema mismatch through a supported, separately authorized workflow repair or
native interface before plan-review/execution sessions; do not manufacture an
`agent_id`, change original results, transfer another parent's binding, or silently
replace this reviewer. This prerequisite is outside the seven C9 steps.

**C9-AUTH-03:** Mathematical meaning, required scope, important public contracts,
acceptance policy, or dependency-pin changes require the lead. Routine proof
routes, private implementation details and justified advisory adjustments may be
resolved within approved scope with evidence. Keep requirements here and evolving
advice in [the companion notes](post-release-chunk-09-notes.md).

The marked status region is editorial only. Retain the exact reviewed/proposed
bytes and full-file hash. On approval, retain the actual user observation and
exact approval/contract hashes through supported workflow operations, including
any permitted status-only transition; never rewrite authority to fit a new hash.
Everything outside that region is normative for this revision.

No commit, push, tag, release, Pages publication, DOI change, downstream edit,
dependency upgrade, theorem-search subsystem, or automatic queue progression is
authorized by this plan. Chunks 1--8 remain historically complete; no synthetic
workflow acceptance or prerequisite reimplementation is needed.

## 2. Verified intake and source contracts

The current mathematical surface is the released 601 supported declarations in
31 supported modules, 92 facade exports and 94 reviewed simp declarations. The
source inventory also includes non-stable anchors: 44 modules and 716 declarations.
These are intake/historical facts, not future current-surface quotas.

| Source anchor | Consequence for C9 |
| --- | --- |
| `scripts/generate_v0_1_public_api.py`, `build_manifest` and `main` | Derives the current surface but writes/checks the frozen file; split these responsibilities before additions. |
| `docs/v0.1-public-api.json` and `docs/v0.1-public-api.md` | Preserve the released names, owners, kinds, attributes, aliases, assumptions, semantics and supported imports. The JSON currently lacks signatures. |
| `scripts/validate_release.py`, `check_direct_module_imports`, `check_supported_environment`, `check_root_boundary`, `check_all_project_axioms` | Reuse existing compiled-environment and trust checks. Current source-derived closures alone do not establish preservation of historical import boundaries. |
| `scripts/check_api_docs.py`, current 601/92 assertions | Current documentation needs an exact current inventory, while historical route checks retain fixed release identities/counts. |
| `scripts/stage_website.py`, `assemble_standard` and maintenance assembly | Growing current docbuild output must never be staged as `/docs/v0.1.0/`. Preserve the separately rebuilt frozen maintenance route. |
| `Shannon/SemanticBridge/Independence.lean`, `IsIndependentOf`, `isIndependentOf_iff_map_eq_indepProd` | The predicate is PMF-first with no finite or measurable-space premise. Keep its established owner and definition. |
| `Shannon/SemanticBridge/Product.lean`, `indepProd`; pinned `PMF.map_comp`, `PMF.map_bind`, `PMF.bind_map` | A direct law proof of deterministic postprocessing is available as a candidate route; do not route the general theorem through finite MI or measurable independence. |
| `Shannon/InfoMeasures.lean`, MI/CMI conditional-entropy rewrites and `condEntropyOf_pair_swap` | The decomposition is elementary entropy algebra and belongs in this lightweight owner. |

Lean paths above are relative to `LeanInfoTheory/`. Existing declarations are
source-inspected and subject to the recorded compiling checks in the companion
notes. No new C9 theorem or compatibility exporter was implemented or proved by
planning. `C9.01` contains the implementation feasibility gate for the exporter.

Mathematical sources are CT91 Section 2.4, Theorem 2.4.1; Section 2.5's CMI
definition and Theorem 2.5.2; and Section 2.8, Theorem 2.8.1 and its deterministic
processing corollary. The decomposition is a derived identity, not a claimed
separately numbered textbook theorem. CT91 uses bits; the library uses nats.
The general PMF postprocessing contract extends beyond that finite-entropy
presentation and is justified directly by mapped product laws. Null fibers keep
the existing algebraic conventions.

The map records the two named PFR declarations and a canonical-representation
consumer as bounded downstream evidence. This planning pass does not reopen PFR
or inspect another repository. Reprove generic facts from the existing library
and pinned mathlib. If later external implementation reuse is explicitly
authorized, record its actual source and licence; do not copy a proof without
provenance. PFR-specific predicates, perfectness and Markov specializations remain
downstream.

## 3. Growth-validation contract

### 3.1 Historical preservation

**C9-GROW-01:** Keep `docs/v0.1-public-api.json` byte-for-byte equal to its exact
release version. Its intake SHA-256 is
`d4c5bfa78588de605798f568b312a4cef2896855e36d3c983849270181e397be`.
Do not regenerate it from growing source. Preserve the immutable release commit,
tag, historical API route and release/maintenance publication safeguards.

Introduce `docs/current-public-api.json` and
`scripts/generate_current_public_api.py [--check]`, reusing the maintained source
parser and module classifier. Give the current artifact a distinct schema and
explicit baseline identity; derive its totals. Redirect ordinary generation and
currency checks there. Retain the old generator entry point as a clearly labeled
non-mutating historical verifier on the evolving branch; its ordinary invocation
must no longer overwrite the frozen file. Any intentional baseline reproduction
must require exact release source and write separately for comparison.

### 3.2 Retained contracts against evolving Lean

**C9-GROW-02:** Capture all 601 retained declaration types from an independently
built exact-release environment, then compare every retained entry with the
current compiled environment. Checking the old checkout alone is insufficient.
Use a bounded build-only Lean exporter under `scripts/compatibility/` and
`scripts/check_public_api_compatibility.py`, with the retained artifact at
`docs/compatibility/v0.1.0-retained-contract.json`.

The artifact must carry the release/tag identities, toolchain and dependency
revisions, exporter schema/version, baseline-manifest digest, exact covered names,
declaration kinds/owners, elaborated types, and direct local/external import
records. Reproduce the baseline export twice and verify exact coverage against
the frozen manifest. The initial captured signatures are historical evidence
derived from the release; they are not a replacement historical API release.

The comparison must deterministically cover complete elaborated types and
universe parameters, preserving binder order, names used by named arguments,
explicit/implicit/instance argument information and dependent assumptions/results.
Do not erase hypotheses, reorder arguments or accept ordinary pretty-printed HTML
as the comparison oracle. Unsupported or unresolved forms must fail explicitly.
Any normalization must be documented and tested without hiding a retained-contract
change. Full coverage and the positive/negative regressions are required;
serialization layout and private implementation details are advisory.

The preferred route is the bounded structural exporter described in the companion
notes. Establish its feasibility on the full retained surface at the start of
`C9.01`, before changing existing generator behavior. Adjust private implementation
details with evidence; any weaker compatibility guarantee or materially different
acceptance policy still requires the lead.

Standalone `compatibility` must establish fresh compiled input itself: run an
appropriate Lake build of the current supported dependency closure before exporting
signatures, and retain its actual result. `lake env lean` alone does not rebuild
imports. If the build fails or freshness cannot be established, fail/refuse instead
of reporting compatibility. Bind export evidence to the checked source/configuration
and dependencies, and reject source changes during that build/export sequence.
Reuse Lake's dependency tracking; no custom caching framework is required.

Require retained names, kinds, owners, signatures and reviewed simp membership to
match. Resolve every frozen root alias against its original target in current Lean.
All supported focused imports remain usable. Diagnostics identify the changed
declaration/import and old/current difference; regeneration must not bless drift.

Limitations are mandatory documentation: unchanged type fingerprints do not prove
unchanged definition bodies, meaning of referenced definitions, intended theorem
semantics, or source-level notation behavior. Review retained definition bodies
and relevant source changes explicitly. Strict representation comparison may flag
a harmless elaboration change; no automatic acceptance follows.

### 3.3 Imports, attributes and complete current coverage

**C9-GROW-03:** Preserve the lightweight root's exact two direct imports and
five-module local closure, the 92 existing facade exports and their targets, and
exclusion of heavy/non-stable modules. Preserve retained focused-owner direct
local/external imports by default. Compare these with release records, separately
from current-source/compiled-environment agreement.

An explicitly approved additive opt-in import at `LeanInfoTheory.Shannon` or
`LeanInfoTheory.Shannon.SemanticBridge` may extend the supported umbrella beyond
31 modules. It requires a reviewed addition record with owner, imports, rationale,
consumer and approval/plan reference, not a hard-coded numerical ceiling. A future
focused-owner import exception likewise requires explicit architecture review;
C9's two production helpers require none. Historical module identities remain.

Keep current import/attribute approvals in the small reviewed policy artifact
`docs/compatibility/current-api-policy.json`, distinct from generated inventory.
Regenerating current data cannot authorize a new simp attribute, root export,
focused import change or umbrella extension. New helper theorems in C9 are not
simp lemmas and receive no new root facade aliases.

**C9-GROW-04:** All current supported declarations and modules must have exact
inventory/compiled-environment agreement, ownership, documentation, attribute and
import checks. Audit every project compiled constant for the existing allowed
axioms `propext`, `Classical.choice`, `Quot.sound`, including non-stable examples
and private proof machinery. Preserve all source prohibitions. Missing current
entries, unclassified modules and unused audit coverage must fail; historical
minimum-count tests cannot replace exact current coverage.

### 3.4 Generated documentation and historical routes

**C9-GROW-05:** The current API-doc checker derives expected supported pages,
declarations and exports from the schema-validated current manifest and compares
exact coverage. Retain unique declaration blocks, nonempty signatures/docstrings,
correct ownership/source links, no sorry markers, reviewed attributes and
non-stable exclusions. Include current-manifest/contract identity and a fingerprint
of documentation-relevant source content and configuration in the two-pass
attestation. Cover the local Lean sources/docstrings, relevant documentation build
and checker inputs, and pinned dependencies; specify the fingerprint inputs.
Verify it before reusing evidence, including in file mode where a checkout path
alone is not a source identity. A signature, definition-body or docstring change
must invalidate old evidence even when names, counts and manifest entries remain
unchanged. Reuse Lake's incremental builds and invalidate stale attestations;
source fingerprint changes alone need not discard unaffected dependency caches.

Historical 31/601/92/13 route checks stay historical. Guard `stage_website.py preview`
before any copy if a growing/current attestation would be labeled `v0.1.0`.
For C9 inspect the current file-linked docbuild output directly; a new published
current-version route is outside scope. Preserve release and maintenance assembly
and their independently verified frozen route digests/source boundaries.

The current source-derived index must stop labeling new/changed lines as immutable
`v0.1.0` source. Use clearly identified current-development source links for the
unversioned index, with existing maintenance staging still pinning them to the
exact site commit. Dirty local evidence remains explicitly local. No current link
or current documentation count may be presented as frozen-release evidence.

### 3.5 Real positive and negative fixtures

**C9-GROW-06:** Before the first new production public declaration, exercise the
actual generator/checker paths in isolated, disposable source copies below the
authorized checkout's ignored `tmp/`. Never introduce deliberate breakage into the
real library. Retain commands, fixture source identity, compiler results, checker
results and expected-failure reasons separately from production evidence.

| Fixture | Required evidence |
| --- | --- |
| Unchanged release and current library | Full retained coverage passes; independent baseline exports agree. |
| Documented compatible addition in an existing supported module | Compiles and passes current inventory, compatibility and trust; frozen bytes unchanged. |
| Documented new opt-in module plus approved umbrella addition and consumer | Passes the real growth path; exact current inventory/import/trust/docs coverage includes it. |
| The same otherwise-valid opt-in addition without its required policy approval | Fails specifically at the policy boundary, even after regenerating the current inventory; counts, documentation and ordinary imports otherwise pass. |
| Same retained name/owner/kind with an extra assumption | Mutated source still compiles, but retained type comparison fails at the altered binder. |
| Changed retained declaration with its old compiled artifact left in place; invoke only standalone `compatibility` | Rebuilds and detects the incompatibility, or explicitly refuses unestablished freshness; it must never pass using the old artifact. |
| Changed result type or explicit/implicit/named-argument contract | Fails retained comparison; test binder-name protection. |
| Removed, renamed or relocated retained declaration | Fails with the declaration and contract mismatch. |
| Added/removed retained simp attribute, or unapproved new simp membership | Fails independently of signature/count checks. |
| Retargeted root alias, heavy root import, changed retained focused import or non-stable leakage | Fails at the appropriate historical/policy/current-environment boundary. |
| Undocumented or unindexed supported addition, missing/duplicate docs block, stale attestation | Fails without accepting a larger count as sufficient evidence. |
| Same-name signature, body or docstring edit with unchanged current-manifest entries | Rejects the previous documentation attestation by its source-content fingerprint; valid freshly built output can establish new evidence. |
| Modified historical manifest or current artifact labeled as frozen route | Fails preservation/staging checks before publication or copying into that route. |
| Same-type changed definition body | Records the expected signature-check limitation and required source-review obligation; no claim that fingerprints establish semantics. |

Fixtures should target these failure modes, not mirror internal helper functions.
Small synthetic tests can cover classification; the compatible declaration,
approved/unapproved opt-in module pair, broken retained assumption and stale-compiled-
artifact scenario must run real Lean/source-copy integration checks. Keep expected
policy refusals distinct from compiler failures. HTML/fingerprint fixtures do not
substitute for the real two-pass doc-gen milestone in final closeout.

## 4. Selected mathematical surface and consumers

Approval selects exactly two new supported theorems. Proposed names below are
intentional API decisions for review, not assertions that these names already exist.
Private helpers are allowed only as needed for these proofs and consumers.

### 4.1 Deterministic postprocessing of independence

**C9-MATH-01:** Add `LeanInfoTheory.Shannon.isIndependentOf_comp_right` in
`LeanInfoTheory/Shannon/SemanticBridge/Independence.lean` with this contract:

```lean
{omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
(p : PMF omega) (X : omega -> alpha) (Y : omega -> beta)
(f : beta -> gamma) (hXY : IsIndependentOf p X Y) :
  IsIndependentOf p X (fun omega => f (Y omega))
```

No `Finite`, `Fintype`, `Nonempty`, measurable-space, measurable-singleton,
measurability, injectivity, surjectivity or positive-mass hypotheses are added.
The theorem is not simp. Keep the predicate and supported declaration locations
unchanged; a new lighter predicate/module or public product-map family is not
justified by this single proof. The owner is already opt-in.

**C9-CONSUMER-01:** Add private permanent consumers in the proposed non-stable
`LeanInfoTheory/Examples/IndependenceProcessing.lean`, importing the focused
independence owner. Exercise arbitrary component PMFs on a product source,
non-injective deterministic postprocessing, a constant image/singleton target,
an infinite source or codomain instance (for example `Nat`), and a finite
zero-MI consequence through the existing equivalence. Exercise left processing
by existing symmetry plus the new theorem, without adding a second public wrapper.
Do not require or invent a PMF on an empty type; generic typechecking exposes no
unnecessary nonemptiness assumption. Include this module in `Examples` only.

### 4.2 Unconditional entropy/MI decomposition

**C9-MATH-02:** Add
`LeanInfoTheory.Shannon.mutualInfoOf_condEntropyOf_decomposition`
in `LeanInfoTheory/Shannon/InfoMeasures.lean` with this exact orientation:

```lean
{omega : Type u} {alpha : Type v} {beta : Type w} {gamma : Type x}
[Fintype alpha] [Fintype beta] [Fintype gamma]
(p : PMF omega) (X : omega -> alpha) (Y : omega -> beta)
(Z : omega -> gamma) :
  mutualInfoOf p Y Z =
    condEntropyOf p Y X - condMutualInfoOf p X Z Y -
      condEntropyOf p Y (fun omega => (X omega, Z omega)) +
      mutualInfoOf p X Z
```

The source type is arbitrary. No independence, Markov, recovery, PFR,
measurable-space, full-support or strict-positivity hypothesis is introduced.
Use canonical nats and existing algebraic conditional quantities. The ordered
conditioning pair is `(X,Z)`. Reuse existing MI/CMI identities and coordinate
transport, keeping this proof entirely in the current lightweight dependency
closure. No new import, simp attribute or facade export is needed. The theorem
becomes root-reachable by its existing owner; that one new canonical root-visible
name is deliberate, while the historical 92 facade aliases remain exact.

The name retains the searchable `mutualInfoOf` and `condEntropyOf` vocabulary
without spelling out the entire right-hand side. The docstring must lead with
"Decompose `I(Y;Z)` through an auxiliary variable `X`", state the full formula,
and identify `(X,Z)` as the ordered conditioning pair. Record this naming decision
under Note 14 with the actual consumer/search evidence; add no alias family.
This replaces a proposed name only; no existing supported declaration is renamed.

**C9-CONSUMER-02:** Add private permanent consumers in the proposed non-stable
`LeanInfoTheory/Examples/InformationDecomposition.lean`, importing only
`Shannon.InfoMeasures`. Exercise the general identity, a constant or singleton
variable specialization, a sparse finite joint law with zero-mass atoms, and an
algebraic specialization assuming `I(X;Z)=0` and `H(Y|(X,Z))=0` that derives
`I(Y;Z)=H(Y|X)-I(X;Z|Y)`. The latter is a generic information-theory use case;
no PFR predicates enter. Check explicit pair orientation and avoid semantic
imports solely to prove the zero assumptions. Include the owner in `Examples`.

The finite intake is closed at these two candidates. The decomposition remains
selected because the map records an actual downstream use and the planned
zero-term specialization exercises its generic interface; the example alone is
not new downstream demand. Both are required if this revision is approved.
A later deferral of either requires the lead's scope
decision; the map's optional-intake wording cannot excuse an unfinished approved
result. Other independence closures, constant/self-independence families,
injective relabeling, recovery variants, product constructors and aliases remain
consumer-triggered under their existing Future Work Notes.

## 5. Ordered implementation steps

Every step includes the common review process in Section 6 and a read-only
plan-health check for later-step consequences. Step criteria below have distinct
IDs for the installed contract. Capture their exact excerpts and evidence duties;
do not substitute the step title for the complete criterion.

These criteria describe work and evidence inspectable at review time. That same
step's independent-review completion, reconciliation, F capture and private closure
are mandatory workflow postconditions, not evidence its initial reviewer must
already possess. Earlier steps' closure records remain valid prerequisites.

### C9.01: Separate inventories and establish baseline feasibility

Prerequisites: exact plan approval, a working binding owned by this actual parent,
and an explicit `C9.01` implementation message.

First establish exporter feasibility in a verified ignored isolated directory
inside this checkout. Extract exact release source and build it with its own project
output identity and pinned dependencies; do not use copied current project oleans
as historical evidence. Reproduce all 601 type records twice, compare against a
freshly built unchanged current library, and run initial binder/assumption-change
fixtures. Record the selected representation and its limits in the companion notes.

Only after that succeeds, implement the historical/current manifest split and
non-mutating historical entry point, retain the exporter and small contract artifact,
and update the ordinary generation instructions affected by the split. Keep
historical source/build artifacts outside Git and capture. A failed feasibility
route must not leave changed generator behavior claimed ready. No production
theorem additions occur in this step.

- **C9.01-R1:** Historical manifest bytes and identities are preserved, and the separate current manifest exactly describes existing source. Evidence: byte/digest comparison, generator repeatability and both non-mutating checks.
- **C9.01-R2:** The pinned exporter deterministically covers all 601 retained types, preserves named and implicit argument contracts, and detects a compiling same-name extra-assumption fixture. Evidence: two original exports, provenance, current comparison and positive/negative Lean outputs.
- **C9.01-R3:** Changed Python/exporter code and current integration pass focused tests and static validation; no new production public declaration or dependency/import change exists. Evidence: source diff, test outputs and validator output.

### C9.02: Enforce retained contracts on current source

Prerequisite: durable closure of `C9.01` plus an explicit eligible request.

Complete the retained checker, historical focused-import records, reviewed current
policy and diagnostics described in Sections 3.2--3.3. Add
`python scripts/validate_release.py compatibility` as the focused entry point.
Check actual current signatures, names, kinds, owners, root resolution, attributes
and import-policy preservation; establish build freshness inside the standalone
command as required by C9-GROW-02. Exercise the old-artifact regression without
relying on an earlier validator/build invocation.

- **C9.02-R1:** Every retained declaration/alias/import has current-source compatibility evidence from freshly built input, with no baseline rewriting. Evidence: standalone compatibility command's build/export output tied to current source, toolchain and all relevant dependency identities.
- **C9.02-R2:** Required retained-contract mutations fail for their intended reason while unchanged source and a compatible addition pass; stale compiled artifacts cannot produce a pass. Evidence: compiling negative fixtures, the standalone old-artifact regression, named diagnostics, attribute/import/alias tests and source-isolation checks.
- **C9.02-R3:** The check's strictness, same-type semantic limitation and reviewed import/attribute decision path are documented and tested. Evidence: contract documentation, the same-type-body fixture disposition and focused/static results.

### C9.03: Integrate current-surface and documentation validation

Prerequisite: durable closure of `C9.02` plus an explicit eligible request.

Connect existing static/trust/default validation to historical preservation,
retained compatibility and the current manifest. Retain exact current environment,
owner, simp and all-project axiom audits. Adapt the API-doc checker, configuration
and attestation, truthful unversioned index links, and the historical-preview guard.
Preserve the frozen maintenance route and publication interlocks. Reconcile
`README.md`, `AGENTS.md`, `docs/v0.1-public-api.md`, `docs/api-documentation.md`,
`docbuild/README.md` and relevant generated/current website wording. The root
README must distinguish released `v0.1.0` counts and its frozen manifest from
current development coverage and the current manifest. Keep release-specific
counts and tagged installation instructions historical; do not replace them globally.

- **C9.03-R1:** Current supported growth receives exact inventory, import, documentation, attribute and trust coverage without a historical count ceiling; regeneration cannot authorize umbrella growth. Evidence: real added-declaration and matched approved/unapproved opt-in-module fixtures through maintained entry points and unchanged-source checks.
- **C9.03-R2:** Current API-doc expectations and attestations identify current source content; missing/duplicate coverage and same-manifest source edits invalidate stale evidence, while frozen-route identities and guards remain exact. Evidence: checker/fingerprint/attestation tests, preview refusal before copy, and preserved historical staging regressions.
- **C9.03-R3:** Generation is repeatable, check modes do not mutate source, and operating documentation including README distinguishes historical/current artifacts, source-link modes and clean-checkpoint gates. Evidence: twice-generated byte comparison, static/documentation tests and reconciled instructions.

### C9.04: Qualify the growth gates before mathematical additions

Prerequisite: durable closure of `C9.03` plus an explicit eligible request.

Run the full fixture matrix in Section 3.5, complete the real added-module and
retained-assumption integration checks, and resolve findings without new theorem
scope. On the real current tree run the cumulative dirty-compatible commands in
Section 6, including all maintained consumers and trust/import audits. This step's
independent review assesses the combined `C9.01`--`C9.04` gate design and evidence,
not merely the last fixture edit. Record readiness and known limits before helpers.

- **C9.04-R1:** The gate behavior in C9-GROW-01 through C9-GROW-06 is demonstrated on unchanged source and by the full fixture matrix, with real Lean positive/negative paths distinguished from synthetic cases. Evidence: consolidated fixture/criterion table, original outputs and preservation comparisons; actual final-source two-pass doc-gen remains a C9.07 duty.
- **C9.04-R2:** Static, default/maintained builds, documentation consumers, compatibility and complete current trust/import checks pass on the real source state. Evidence: cumulative command outputs and source/configuration/dependency identities.
- **C9.04-R3:** Gate qualification evidence is complete and ready for independent review before the first new public theorem, with final doc-gen/clean-checkpoint duties explicitly retained for C9.07. Evidence: prepared readiness note, criterion-to-check traceability and current source applicability.

### C9.05: Prove and consume independence postprocessing

Prerequisite: durable closure of `C9.04` plus an explicit eligible request.

Implement only Section 4.1, its permanent consumers and directly affected generated
references/canonical notes. Search again before proof work. Prefer mapped-law and
`indepProd` rewrites; keep one-off proof machinery private. Reconcile the selected
slice of Note 25, actual downstream feedback, naming and useful imports.

- **C9.05-R1:** C9-MATH-01 is proved with exactly the approved generality, owner and no simp/facade addition. Evidence: declaration/type comparison, focused source/API review, axiom and compatibility checks.
- **C9.05-R2:** C9-CONSUMER-01 passes, including infinite-type, non-injective/constant and finite zero-MI uses without speculative public wrappers. Evidence: permanent source and warning-as-error consumer/owner/aggregate builds.
- **C9.05-R3:** Current artifacts, relevant canonical context and dispositions match the delivered theorem; frozen release artifacts and pins are unchanged. Evidence: current source/document deltas, generation/check outputs and static/trust validation.

### C9.06: Prove and consume the information decomposition

Prerequisite: durable closure of `C9.05` plus an explicit eligible request.

Implement only Section 4.2, its focused permanent consumers and directly affected
generated references/canonical notes. Reuse existing algebraic identities. Do not
introduce semantic imports, application structure, a symmetric public variant or
an alias family. Record the selected naming disposition under Note 14.

- **C9.06-R1:** C9-MATH-02 is proved with the exact variable/pair orientation and assumptions in the lightweight owner. Evidence: declaration/type comparison, source/API review and compatibility/import/trust outputs.
- **C9.06-R2:** C9-CONSUMER-02 passes with the lightweight focused import, including the generic zero-term specialization and sparse/degenerate cases. Evidence: permanent source, focused warning-as-error builds and root/Examples aggregate checks.
- **C9.06-R3:** Both selected helper dispositions and current references are accurate, with exactly the approved supported additions and no historical baseline drift. Evidence: current source/document deltas, inventory delta, retained comparison, naming/feedback records and static/documentation validation.

### C9.07: Cumulative validation, independent review and maintained handoff

Prerequisite: durable closure of `C9.06` plus an explicit eligible request.

Validate the entire approved C9 outcome, including every growth obligation,
both mathematical contracts and both consumer contracts. Follow this order so
the initial cumulative reviewer receives existing evidence rather than promises
of future review or closure.

**Prepare source and documents.** Complete final source changes and the canonical
reconciliation/handoff described below, using provisional readiness wording.
Complete self-review, separate reassessment and any resulting improvements before
freezing the cumulative review candidate.

Reconcile living-summary Sections 0/1/7/11--13/16 as affected, meaningful project
log entries, the map's C9 disposition without rewriting later proposed contracts,
roadmap status, root README, API/docbuild instructions, feedback and Future Work Notes 9,
14--18 and 25. Preserve historical counts/claims where they describe the release;
label actual current totals and limits separately. Do not close entire standing
Future Work Notes because one selected slice was discharged.

Write `docs/handoffs/chunk-9.md` as a maintained, ordinary handoff and link it from
canonical context. It records actual delivered APIs/imports/consumers, validation
commands, design/naming decisions, exact source and review references, signature
checking limits, remaining-work dispositions, and C10 prerequisites/decisions.
Preparing it does not approve or start C10 or transfer C9's reviewer.

**Establish the review candidate's validation.** Obtain an explicitly authorized
clean checkpoint after the required source/document edits, then run the complete
routine suite, the cumulative fixture matrix and the real two-pass API-doc gate
in local file mode. Verify actual new declaration signatures and source-content
attestation with the pinned Windows Zig requirement. Do not stage growing output
under the frozen route. Retain original outputs privately and establish current
source applicability before preparing R. This plan grants no commit authority.

- **C9.07-R1:** Every C9-GROW, C9-MATH and C9-CONSUMER contract and the earlier step outcomes have applicable cumulative evidence, with earlier findings reconciled and no unresolved material self-review concern. Evidence: original checks, earlier reports/closures and dispositions, criterion traceability and current-source applicability.
- **C9.07-R2:** The complete maintained routine suite, cumulative fixture matrix and real two-pass current API-doc gate pass on the review candidate's authorized clean checkpoint. Evidence: actual command outputs, candidate source/configuration/dependency identity, doc-gen attestation and source/route boundary checks.
- **C9.07-R3:** Canonical documents, generated references and `docs/handoffs/chunk-9.md` are prepared, reconciled and validation-ready, and every remaining item has a disposition, owner/trigger and next-chunk implication. Evidence: prepared documents, local-link/generated checks and the maintained handoff linked from canonical context.

**Complete independent review and closure.** Obtain a fresh consolidated review
from the same reviewer against all chunk obligations and these readiness criteria.
Retain and reconcile every original report, including clean reports and negative
evidence. New findings are handled through the installed correction and reassessment
process; a reviewer gap or contradiction needs a new satisfactory reviewer
assessment. If corrections change the candidate, obtain the necessary authorized
clean checkpoint and repeat the complete routine suite after amendment; refresh
fixture/doc-gen evidence according to affected inputs and source applicability.
Material review invalidation requires renewed review.

After corrections and applicable final checks, assess all criteria and R-to-F
impact, record the already prepared documents with `finalize_documents`, and
capture F through the installed workflow. Use wording such as "validation ready;
closure subject to the private completion record" in captured files. Fresh review,
all accepted-report reconciliations, satisfactory final criteria/evidence and
`project_closure()` are mandatory postconditions. Only the actual private closure
establishes completion; record its reference privately and in the user report,
without editing captured source/documents after F.

If an authorized clean checkpoint is unavailable, finish safe component checks,
self-review and document preparation, report the precise pending gate, and leave
C9.07 open. Defer the initial final-step formal review until its required validation
evidence exists; do not dispatch a knowingly incomplete cumulative contract merely
to obtain a criterion gap. No dirty component pass substitutes for the full suite,
and no later-step request supplies missing checkpoint authority or closes C9.

## 6. Validation and review execution

### Validation levels

Serialize artifact-producing Lean builds. Retain the actual command, actor,
source/configuration/dependency identity, output, outcome and limitations.
Existing evidence may be reused only with explicit applicability; do not turn a
reviewer-reported check into an implementer rerun.

Use this schedule to keep checks proportionate while retaining both cumulative
qualification points. Earlier fixture outputs remain preserved even when rerun.

| Steps | Required emphasis |
| --- | --- |
| C9.01 | Full retained-surface exporter feasibility, repeatability and initial binder/assumption regressions, then inventory-split checks. |
| C9.02 | Newly implemented compatibility paths, including standalone build freshness and retained-contract mutations. |
| C9.03 | Growth/current-doc integration, approved/unapproved policy pair, source-fingerprint invalidation and README reconciliation. |
| C9.04 | Fresh complete Section 3.5 fixture matrix and real-library cumulative dirty-compatible checks. |
| C9.05--C9.06 | Changed owner/consumer builds, current/retained API, trust/import/attribute checks and affected documentation; rerun unrelated tooling fixtures only for a changed dependency or unresolved concern. |
| C9.07 | Fresh complete fixture matrix, complete routine suite at an authorized clean checkpoint, real two-pass current docs and full-chunk independent review. |

For each coherent Lean change, run the affected focused owners and consumers,
`LeanInfoTheory.Shannon`/semantic or root aggregate as affected, current generation,
static and compatibility checks. Run current trust/attribute/import audits after
public-surface changes. Keep tests proportionate to changed tooling and extend
existing staging/checker regressions when that behavior changes.

The cumulative dirty-compatible set uses existing commands, with the one proposed
compatibility command added by C9.02:

```text
python -B scripts/generate_current_public_api.py --check
python -B scripts/generate_v0_1_public_api.py --check
python -B scripts/validate_release.py static
python -B scripts/validate_release.py build
python -B scripts/validate_release.py documentation
python -B scripts/validate_release.py compatibility
python -B scripts/validate_release.py trust
python -B scripts/test_public_api_compatibility.py
```

`build` includes the default and maintained warning-as-error target builds;
`trust` also includes the maintained targets before the environment probes.
Avoid redundant reruns unless source impact or source applicability warrants them.
The maintained target list remains owned by `validate_release.py targets`.
After approved current declarations/imports change, regenerate the current
manifest and both source-derived website artifacts twice, check byte stability,
then run static/current/retained checks. Do not regenerate the frozen manifest.

At the authorized clean checkpoint the unchanged full-suite policy applies:

```text
python -B scripts/validate_release.py
python -B scripts/validate_release.py api-docs
```

API docs are included once as a real C9 milestone because C9 changes their
validation contract; they are not required after every helper edit. Preserve
Lean/mathlib/doc-gen pins, `DISABLE_EQUATIONS=1`, local file-mode status and Zig
0.16.0 via `LEANINFOTHEORY_ZIG`. Missing prerequisites or an unfinished expensive
build are unavailable evidence, not a pass. Public/GitHub-source documentation
or deployment remains separately authorized work.

### One-step workflow and evidence

Follow [review-protocol.md](../review-protocol.md) and the exact operations in
[review-operations.md](../review-operations.md) for named-message eligibility,
B/R/F captures, owned edits, validation, self-review and separate reassessment,
neutral dispatch, original native results, finding/criterion reconciliation,
corrections and scoped closure. Inspect rendered requests for the full library
rubric and C9-specific criteria. Preserve the existing criterion-gap policy;
reviewer satisfaction cannot be replaced by an implementer verdict. Each eligible
message closes only its named step and starts no later work.

Capture includes relevant source/documents, configuration, installed workflow and
pinned dependencies. The installed adapter automatically includes eligible tracked
and untracked files; explicit `scope` adds required files and is not an exclusion
list. Inspect that actual inventory and declare required pinned declarations and
consumers explicitly; the adapter does not infer their dependency closure. Reference
media, scratch/build outputs and durable private `.lit-review/` records stay outside
capture. Preserve unrelated work.

Advisory-file edits and plan status-only edits are still captured source changes.
The marked status block preserves only the normative contract hash, not evidence
freshness. Prepare such edits before validation/R where possible, hold captured
source fixed while review is pending, and use supported correction/revalidation
after changes. Do not edit captured files after F or add closure announcements to
them afterward. Review originals and the final closure reference belong privately
and in the user report. These cooperative checks do not establish authenticated
origin, OS isolation or mathematical meaning.

## 7. Plan-review criteria and remaining-work dispositions

When the lead explicitly requests plan review, open a fresh `plan-<local-id>`
session with empty execution steps, this exact proposal hash and the following
proposal criteria. Use `plan_review_request`, retain INTENT/SUBMISSION/REPORT
originals, `reconcile_plan_review`, and `plan_review_result`; pass the plan session
explicitly on every call. A revised requested review uses a fresh plan session and
the same reviewer, preserving older records. No execution session is opened now.

- **C9-PLAN-01:** The proposal faithfully separates historical preservation, retained-contract checks on current Lean and complete current-surface validation, with a bounded feasible strategy and meaningful positive/negative fixtures. Required evidence: relevant current scripts/contracts and Sections 2--3/C9.01--C9.04 feasibility and risk assessment.
- **C9-PLAN-02:** The two proposed theorem contracts, assumptions, owners, names and permanent consumers are mathematically appropriate, reuse current Lean/mathlib and respect the bounded downstream intake. Required evidence: Section 4, exact relevant CT91 sections, actual declarations/imports and explicit unproved planning limits.
- **C9-PLAN-03:** The step sequence, approval boundary, per-step checks, native original-result/reconciliation policy and final cumulative clean validation/review/documentation/handoff duties are coherent and non-circular. Required evidence: Sections 1/5--7, both review documents and the actual bootstrap limitation in the companion notes.

| Remaining item | Planned disposition and trigger |
| --- | --- |
| Native reviewer schema mismatch | Prerequisite outside C9 implementation; retain the existing reviewer and refusal. Resume workflow use only after supported resolution with authentic native evidence. |
| Two named helpers | Selected and required by this proposed revision; no silent optional deferral after approval. |
| Other Note 25 closure/degeneration variants | Deferred to a concrete new consumer; C9.05 closes only deterministic right-postprocessing. |
| Decomposition naming / future aliases | Select `mutualInfoOf_condEntropyOf_decomposition`, document exact orientation and record Note 14 evidence; no speculative alias. |
| Signature checker semantic blind spot | Permanent limitation plus explicit source/API review, not a claim of semantic equivalence. |
| Current public API-doc route / broader website work | Deferred to a separately reviewed publication/documentation contract. C9 validates current local output and preserves the frozen route. |
| Full clean-checkpoint suite | Required for C9.07 closure; awaits actual authorized clean checkpoint, never implicit commit permission. |
| C10 finite TV and later programme | Proposed later work; needs its own parent/reviewer, exact approved detailed plan and explicit step request after prerequisites. |
| Remaining numbered Future Work Notes | Preserve owners and triggers; no broad closure, renumbering, quota-driven additions or downstream migration. |

Expected growth is two supported theorems, zero aliases and private consumers/proof
helpers as needed. Classify the algebraic decomposition as a convenience identity
separately from substantive programme breadth; do not claim that two names are two
new theorem families. Measure actual current counts and report unexpected additions
for scope review. Tooling and private examples do not count as mathematical growth.
