# Chunk 15 planning and feasibility notes

These notes are advisory evidence and evolving proof guidance for the
[proposed revision-2 plan](post-release-chunk-15.md). They are not approved
requirements, a formal PLAN review, implementation, or step completion.
Date: 2026-10-09 (Europe/Zurich).

## Revision 2: advisory suggestions and decisions

The lead authorized selective revision after the parent's advisory self-review
and a user-pasted General Assistant report. Both are advisory inputs. The latter
is attributed to the supplied report, not a report dispatched to the bound C15
reviewer. Its additional combined compiler probe did not complete and was
stopped; it claims no fresh compilation result from that attempt. This revision
does not create a formal PLAN session, assessment or acceptance.

| Advisory input | Disposition | Reason and selected implementation in the plan |
| --- | --- | --- |
| Parent boundary suggestion and General Assistant suggestion 2 | Adopt together | One shared mathematical family connects coordinate/TV convergence, channel/output maps, actual MI and conditional-entropy limits. This closes the gap left by endpoint-only `ContinuousAt` examples. |
| Parent named-instance integration suggestion | Adopt | Section 6.2 explicitly checks fresh focused and umbrella imports without local replacement instances; local-instance feasibility and declaration audits alone do not establish global inference. |
| Parent precise-validation suggestion | Adopt | Section 6.1 states minimum targets and commands for each step, objective documentation triggers and source-applicability rules. `trust` includes compatibility; duplicate standalone checks are unnecessary on identical inputs. |
| Parent stable-contract/proof-advice suggestion | Adopt | Preserve representations, assumptions, the actual MI objective, compact-extremum application and dependency boundaries in the plan; retain constructor, squeeze and named-extremum recipes here as advice. |
| General Assistant suggestion 1: promised generality | Adopt | Permanent direct theorem applications cover finite input/infinite output, arbitrary input for the joint map, `Finite`-only assumptions and independent universes. These check existing proposed signatures without adding public APIs. |
| General Assistant suggestion 3: singleton-event TV estimate | Adopt as preferred proof advice | Reuse the existing stronger event bound on a singleton. It avoids duplicating a coordinate estimate and adds no dependency; it does not become a new public theorem or a mandatory proof script. |
| Parent Section 3.2 Markdown correction | Apply | Repair the malformed `Fintype` inline-code delimiter. |

Retain the five steps, 17 criterion IDs, three mathematical owners and all
proposed public contracts. The additional requirements are focused validation
and connected permanent consumers. Keep C22 capacity, null-fiber conditional-law
continuity and general infinite-alphabet information theory outside C15.
Require the two boundary information limits that test MI and the disappearing
conditioning marginal; full interior entropy/MI formulas and another separate
entropy-path regression are unnecessary for that endpoint.

The exact pre-revision plan and notes are preserved privately under
`.lit-review/setup/c15-plan-r2-20261009/before-post-release-chunk-15.md` and
`before-post-release-chunk-15-notes.md`, with initial dirty-path/index hashes
in `before.json`. Initialization records below remain evidence about revision 1;
they are not retroactively relabelled as checks of revision 2.

### Preferred TV converse proof

The existing `PMF.abs_toOuterMeasure_sub_le_totalVariation` has an arbitrary
event argument. Applying it to `{a}` and rewriting with
`PMF.toOuterMeasure_apply_singleton` gives the stronger coordinate estimate
`|(p a).toReal - (q a).toReal| ≤ PMF.totalVariation p q`.
The prospective private proof is:

```lean
example {α : Type*} [Fintype α] (p q : PMF α) (a : α) :
    |(p a).toReal - (q a).toReal| ≤ PMF.totalVariation p q := by
  simpa only [PMF.toOuterMeasure_apply_singleton] using
    PMF.abs_toOuterMeasure_sub_le_totalVariation p q {a}
```

It uses only `LeanInfoTheory.Probability.TotalVariation`, whose existing
imports already expose the singleton law. Use the estimate directly in the
convergence argument or through a private helper; no new public coordinate
bound is justified. The original successful twice-TV feasibility proof remains
valid historical evidence, while this reuse route is preferred for C15.02.

Fresh revision-2 evidence is separate from the General Assistant's stopped
combined probe: the topology helper ran
`lake env lean -DwarningAsError=true tmp/c15-plan-r2-tv/probe.lean`.
It exited 0 without diagnostics. The exact source, empty compiler output and
result are preserved under
`.lit-review/setup/c15-plan-r2-20261009/singleton-tv/`; the disposable Lean
probe was deleted after checking its resolved location inside the ignored
project scratch directory. This checks only the small reuse lemma, not C15.02
or any integrated implementation.

### Boundary and generality implementation advice

For the Section 3.7 path, a convenient parameter is the existing interval
subtype `Set.Icc (0 : ℝ) 1`, with its endpoint zero and ordinary neighborhood
filter. This avoids defining a PMF from an invalid real parameter. Other
faithful representations of convergence within the interval remain possible.
The fixed joint law has input first and output second, so `condEntropy J_t`
is exactly input given output; its conditioning mass at `true` is `t/2`.
No swap or conditional-law construction is needed. The limiting joint law is
the point mass at `(false,false)`, establishing both zero endpoint values
through existing information APIs.

Reuse the small construction pattern of the existing private `booleanFamily`
in `Examples.TotalVariation`; those private declarations are not cross-module
API. Each new focused example may repeat its few necessary private constructors
and mass facts. Keep the same mathematical family and parameter convention,
without importing another Examples owner or creating a public/shared fixture.
The TV example uses both convergence bridges; the channel example applies
the delivered map theorems; the information example applies the actual-objective
and joint-law continuity results to explicit limits. This preserves the lighter
qualitative owner/consumer imports.

For the infinite-output bind consumer, the pure/fair channel can be mapped
into `Nat` via the Boolean embedding with values zero and one. Its output
type stays `PMF Nat`, despite its finite support. Generic consumers quantify
independent universes `u v`, use only `[Finite α]` for map/bind, and invoke
the delivered theorem directly rather than installing a local `Fintype`.
Only production proof internals choose enumeration when needed.

### Proof details that remain advisory

The initial checked simplex construction uses `PMF.sum_toReal`,
`PMF.ofFintype`, `ENNReal.ofReal_sum_of_nonneg`, `ofReal_toReal` and
`toReal_ofReal`, followed by the inverse homeomorphism's compactness transport.
Internal `Finite`-only proofs can use `let := Fintype.ofFinite α`.
These are vetted routes, not frozen acceptance conditions.

The checked attainment route applies `IsCompact.exists_isMaxOn` to `Set.univ`
and obtains a witness from a pure input. An equivalent existing compact-extremum
theorem and equivalent nonemptiness construction are acceptable, provided the
permanent consumer optimizes the actual MI objective with compactness,
continuity and domain nonemptiness supplied by the delivered interfaces and
stated hypotheses. Neither assumed compactness nor an assumed maximizer is
acceptable. The topology's definitional identity and public assumptions remain
normative regardless of the proof script.

## Intake and preserved state

The actual parent is Codex thread
`01a11f3a-9a1a-78f0-9ceb-1c435509feb6`, native role `/root`, titled
**Chunk 15**. Work was directed to
`C:/Users/coban/Desktop/Lean Info Theory`, rather than the initially displayed
Documents workspace.

Read root instructions, living-summary quick start and relevant architecture,
coverage, future-work and validation context, C15/C22 in the map, the reference
register, review protocol/operations, C14 handoff and actual completion record.
Targeted log reading included the 2026-10-09 worktree relocation and the earlier
roadmap probe limitation. Actual probability/information definitions, focused
imports, current generated inventory and pinned mathlib were inspected.

C14 is closed at `e982ba7cb0ac0460c90777820659482eed4e2b0e`.
Its actual completion record, not the captured prospective prose, establishes
completion. The full 219-file predecessor comparison found exactly three
differences: `.gitignore`, `AGENTS.md`, and `docs/project-log.md`, all the
existing hygiene/relocation edits. Configuration, nine installed dependency
records and Git index identity match. This deliberately does not assert that
the complete old source snapshot equals today's source.

The fourth initial dirty file, `docs/next-website-tasks.md`, matches C14's
captured bytes, SHA-256
`8db54766aff44faaf5f2380f0e9c11103ab4ba5471d2928b1c2750a3f3a11887`.
It and the three hygiene files are preserved without staging or editing.
Only the new C15 plan/notes are intended tracked-document additions during
initialization; private evidence and an ignored context handoff stay private.
C14 historical documents and evidence are unchanged.

Read-only `git worktree list --porcelain`, status and HEAD inspection found
the registered relocated validation checkout clean at the C14 commit. No
checkout update, rebuild, dependency action, relocation or validation reuse
occurred. Its old path-dependent evidence is not renewed by this inspection.

Durable parent records under `.lit-review/setup/`:

- `c15-init-inspect-20261009.json`: original installed `inspect` result.
- `c15-init-api-20261009.json`: original installed `api` result.
- `c15-intake-preserved-paths-20261009.json`: four initial dirty-path hashes
  and Git index identity.
- `c15-predecessor-applicability-20261009.json`: actual C14 final-capture
  comparison, differences and limits.
- `c15-initialization-validation-20261009.json`: final initialization checks,
  hashes and scope; this is not a private step-completion record.

The fresh current-API generator check passed. Its observed 653 supported
declarations, 36 owners, 94 reviewed simp declarations and 92 root exports
remain the C14 source baseline; no C15 declaration has been installed.

## Reviewer bootstrap

The actual parent ran:

```text
python -B tools/lit_review/cli.py inspect --save c15-init-inspect-20261009.json
python -B tools/lit_review/cli.py api --save c15-init-api-20261009.json
```

Both succeeded. The supported native creation call was
`collaboration.spawn_agent` with `task_name="c15_reviewer"`,
`model="gpt-6-astra"`, `reasoning_effort="ultra"`, and
`fork_turns="none"`. Its original result was exactly
`{"task_name":"/root/c15_reviewer"}`. The full bootstrap message explicitly
forbade proposal assessment, edits, delegation and implementation and asked
only for readiness after reading the reviewer instructions.

The native `collaboration.list_agents({})` result records the matching
reviewer's completed bootstrap acknowledgement. This is original bootstrap
evidence only, not a source-bound PLAN report. No formal PLAN session, request,
dispatch, verdict, receipt or acceptance was manufactured.

The installed `bind` command succeeded using this parent's exposed thread ID
and actual creation result. The persistent binding is
`.lit-review/chunks/C15/binding.json`; requested settings and the exact original
tool call/result are retained. Effective parent/reviewer model, reasoning and
history settings are **unknown**, because the native result exposes no such
fields. Cooperative read-only restrictions are not OS isolation.

Original setup records are
`c15-reviewer-bootstrap-intent-20261009.json`,
`c15-reviewer-creation-result-20261009.json`,
`c15-reviewer-bootstrap-list-20261009.json`,
`c15-binding-input-20261009.json`, and
`c15-binding-result-20261009.json`.
The authority packet retains the user's actual pasted instruction as an
explicitly labelled local capture, not a fabricated native message ID.

[Official subagent documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents)
was consulted for platform context; the actual exposed native schema and
observed results govern this setup. The bootstrap adds no assertion about
effective settings beyond those observations. Future requests reuse this
handle and its own history without copying the parent's transcript.

The two other native agents, `/root/topology_feasibility` and
`/root/objective_feasibility`, were bounded planning helpers. Their
source/probe evidence is attributed as such and is not independent formal
review or acceptance. Neither is the bound reviewer.

## Important instance discovery

Initial source inspection showed that `PMF` is a `def` whose body is
`{f : α → ℝ≥0∞ // HasSum f 1}`
(`Mathlib/Probability/ProbabilityMassFunction/Basic.lean:46`).
It was initially tempting to assume automatic subtype topology inference.
Actual compilation refuted that assumption:

- `#synth TopologicalSpace (PMF Bool)` failed.
- Uniform/pseudo-metric/metric synthesis also failed in the inspected probe.
- Compactness of `stdSimplex ℝ Bool` succeeded.
- Real-coordinate continuity could not elaborate before a PMF topology was
  supplied.

A targeted search across pinned mathlib and the project found no dedicated
PMF topology/compactness instance. The proposed solution is one opt-in
forwarding instance, definitionally equal to the subtype instance:

```lean
local instance {α : Type*} : TopologicalSpace (PMF α) :=
  inferInstanceAs (TopologicalSpace {f : α → ENNReal // HasSum f 1})
```

This is the isolated-probe form, not installed project code. The plan proposes
a named public instance in the new probability topology owner. A compiling
`rfl` check identifies it with the underlying subtype topology. This
discovery is why the proposal explicitly approves a forwarding instance rather
than saying that no topology instance is needed. No upstream reducibility
attribute or new metric is required.

Remaining production obligations: check the named global instance with each
focused owner and the full umbrella, inspect instance diamonds/reachability,
and qualify it under current compatibility/trust policy. A successful local
instance probe does not discharge those future integration obligations.

## Pinned APIs and proof routes

| Need | Verified source/API route |
| --- | --- |
| Real atom continuity | Product evaluation and subtype projection, then `ENNReal.continuousAt_toReal (p.apply_ne_top a)` |
| Simplex forward | Existing `PMF.toReal_nonneg` and `PMF.sum_toReal` |
| Simplex inverse | `PMF.ofFintype`, `ENNReal.ofReal_sum_of_nonneg`, simplex sum-one, `ENNReal.ofReal_one` |
| Both inverses | `ENNReal.ofReal_toReal` using no-top; `ENNReal.toReal_ofReal` using nonnegative simplex coordinates |
| Simplex compactness | `isCompact_stdSimplex`, `stdSimplex.instCompactSpace_coe` in `Mathlib.Analysis.Convex.StdSimplex` |
| Transport to PMFs | Inverse homeomorphism's `Homeomorph.compactSpace`; `Mathlib.Topology.Homeomorph.Lemmas` |
| Coordinate convergence | `tendsto_subtype_rng`, `tendsto_pi_nhds`, `ENNReal.tendsto_toReal_iff` |
| TV convergence | `tendsto_finsetSum`, absolute differences, and `squeeze_zero` with twice-TV coordinate bound |
| Channel output | Existing `PMF.bind_toReal_apply`, real products and `continuous_finsetSum` |
| Pushforward | Existing map as bind of `PMF.pure ∘ f` |
| Induced joint law | `PMF.channelJoint_apply` and `ENNReal.toReal_mul`; no alphabet finiteness needed |
| Entropy | Existing `entropy_eq_sum` / definition, `Real.continuous_negMulLog`, `continuous_finsetSum` |
| Conditional entropy / MI | Existing `condEntropy` and `mutualInfo` definitions plus the two projection maps |
| Attainment | `isCompact_univ.exists_isMaxOn`, a pure input witness and the actual objective's `Continuous.continuousOn` |

Do not reuse guessed names from exploratory checks:
`Continuous.ennreal_toReal` is unavailable in this pin, and the maintained
finite-sum spelling is `continuous_finsetSum`. Original failed exploratory
checks are retained separately from corrected success.

The topology spike exercises a real homeomorphism with both coordinate
equations, finite compactness, arbitrary-filter coordinate and TV convergence,
and definitional agreement of the forwarding topology. The objective spike
exercises real-atom, bind, map, joint, entropy, conditional-entropy and MI
continuity, the actual fixed-channel composition, and continuity at a pure
input. Internal enumeration can be selected with
`let := Fintype.ofFinite α` for public `Finite`-only compactness/map/bind.

The objective spike's extremum application has an explicit
`CompactSpace (PMF α)` premise: it checks the exact optimization API and
nonemptiness assumptions. The separate topology spike supplies the missing
compactness construction. This pair establishes feasibility, not an integrated
permanent consumer or production proof. C15.04 must build the actual consumer
from delivered public interfaces without an assumed compactness premise.

## Direct route versus C14

Current local-source import closure inspection found 15 project owners below
`Shannon.Continuity`, including coupling, Fano and semantic information
owners. `Shannon.InfoMeasures` reaches three project owners; adding the raw
finite channel owner makes four, before adding the proposed topology owners.

Choose the direct `Real.continuous_negMulLog` finite-sum proof. It includes
zero masses, requires only finite alphabets and no-top atom facts, and avoids
proving the limit of C14's capped modulus. Quantitative bounds remain useful
optional downstream facts. This is a dependency choice, not a criticism of
C14 or a claim that its bounds fail to imply continuity.

Put simplex/PMF/channel topology in `Probability.FiniteTopology`; put the TV
comparison in `Probability.TotalVariationTopology`; put information continuity
in `Shannon.Topology`. This prevents the MI objective from importing TV,
coupling or Fano merely for qualitative continuity. Consumer-only extrema do
not justify a new optimization abstraction or a capacity definition.

## PW24 inspection

The helper independently verified the registered local SHA-256 and read
targeted relevant text. Relevant statement pages 103, 106 and 119 were also
rendered and visually inspected using the PDF skill. No source PDF, extracted
text or image is part of the plan or review capture.

Proposition 4.8's entropy part is the selected finite coordinate-sum argument;
its accompanying divergence discussion does not license global KL continuity.
Proposition 4.13(a) is the finite joint MI source. Part (b)'s arbitrary-output
fixed-channel result is stronger than C15; the plan deliberately uses only
the finite-both-alphabets specialization. Part (c) is not selected.

Section 5.1, Theorems 5.2/5.3 (printed page 92 / PDF page 117), supplies
conditional-entropy continuity and input-concavity context. C15 introduces no
new concavity result. Section 5.2, Theorem 5.4 (printed page 94 / PDF page 119),
assumes an attaining input. Finite attainment here comes from compactness and
continuity, not from silently treating that assumption as a theorem.
PW22 was neither used nor substituted.

## Validation scope and remaining choices

The exact final topology compiler output, selected initial diagnostics,
corrected probe source text and helper reports/outcomes are retained privately
under `.lit-review/setup/c15-feasibility-20261009/`. The complete original
failed-attempt streams were not all captured as files; summaries are labelled
as such and are not original transcripts. The notes do not treat failures as
passes. Disposable
Lean spikes are removed before the initialization report. No production Lean
file, supported declaration, generated artifact, policy, dependency or workflow
has changed.

Initialization uses targeted probe compilation, a current inventory check,
document/link/criterion checks, static validation and a preservation audit.
The parent static gate passed in 8.679 seconds, including two non-mutating
generated-artifact passes, current/frozen inventory checks, source website and
34 website-checker tests, discovery metadata and diff/scratch hygiene. Its exact
streams and result are `c15-init-static-20261009.*` under private setup records.
It does not run or claim the full clean-checkpoint routine, a new all-project
axiom qualification, current two-pass API docs, or a formal PLAN review.

Final topology command: `lake env lean -DwarningAsError=true tmp/c15-topology/Bridge.lean`,
exit 0 with no diagnostics. Final objective command:
`lake env lean tmp/c15-objective/Probe.lean`, exit 0 with no diagnostics;
the latter was warning-free but did not set the warning-as-error flag.
Both are helper-run no-output-file Lean probes using local forwarding instances.
Their source text is preserved after deleting the disposable Lean files.

The major representation and proof-route risks are resolved at probe level.
Remaining work is future integration, naming/API review, meaningful permanent
consumer coverage and full validation under the approved step process.
No tactic transcript is a requirement: constructor simplification, helper
placement and exact proof-required imports can evolve in these notes.
Important changes to contracts or acceptance require the lead.

Next user decisions are the formal PLAN-review request and exact approval of
the resulting revision, including the two proposed instance additions and the
three-owner split. After that, one explicit named step request selects work.
Checkpoint/reuse authority belongs to the concrete final candidate, not this
initialization. No further clarification is needed to present this proposal.


## C15.01 implementation, 2026-10-12

The lead accepted revision 2 and selected C15.01 with review. Its editorial
status block records that chronology without changing normative requirements;
no formal PLAN acceptance is invented. The existing bound reviewer confirmed
availability with retained history. Exact authority, intake and source records
are under `.lit-review/setup/c15-01-20261012/`.

The implementation follows the successful simplex probe using the approved
`FiniteChannel` local import and exact `StdSimplex`/`Homeomorph.Lemmas` imports.
`PMF.instTopologicalSpace` definitionally forwards the subtype instance;
real-coordinate continuity uses `continuousAt_toReal` at each no-top PMF atom.
The inverse uses `ofFintype`, nonnegative `ofReal` normalization and both
conversion identities. Finite compactness installs an internal `Fintype`
only within its proof. Arbitrary-filter convergence is derived from subtype,
product and no-top `toReal` equivalences without `NeBot` or alphabet finiteness.

The permanent focused example reconstructs PMF convergence from arbitrary
simplex-coordinate limits, in addition to sparse coordinates, round trips,
pure vertices, empty-law impossibility and singleton mass/compactness.
The read-only topology helper supplied source-backed consumer suggestions;
those suggestions are implementation advice, not formal independent review.
The full Shannon and focused imports receive separately compiled instance probes.
No later C15 mathematics is implemented.

### Qualification and review, 2026-10-13

The first focused build failed in two private consumer proofs: simplification
of `Fin 3` numeral inequalities needed `Fin.ext_iff`, and the inverse-coordinate
proof needed an explicit public rewrite before applying `ENNReal.toReal_ofReal`.
Only those proof bodies changed. The failure (exit 1, 324.416 seconds) is retained
separately; it is not passing evidence. The successful four-target rerun used
`python -B scripts/validate_release.py focused
LeanInfoTheory.Probability.FiniteTopology LeanInfoTheory.Examples.FiniteTopology
LeanInfoTheory.Shannon LeanInfoTheory.Examples` (exit 0, 32.741 seconds).

The two fresh-import probes used `lake env lean -DwarningAsError=true` with
separate focused-owner and full-umbrella sources. Both passed without diagnostics
(207.671 and 37.901 seconds). They check the actual global instances, definitional
subtype-topology agreement, generic `Finite`-only compactness, Empty/Unit/Bool,
public coordinate continuity and both convergence directions under unrelated
universes. Their source and outputs remain in the evidence records after removal
of the disposable Lean files. No replacement instances or desired-class premises
were supplied.

The complete `python -B scripts/validate_release.py trust` passed in 1115.679
seconds: retained 601-declaration compatibility, current 660-declaration/37-owner
checks, strict builds, all direct supported imports, exact API/root/simp
boundaries and the audit of all 62 modules/2,082 constants using only the three
permitted axioms. The full input and output inventories are identical and match
the reviewed source. Fresh parent static validation passed in 12.626 seconds,
including both non-mutating generator passes and all 34 website-checker tests.
Exact commands, streams and manifests are retained under
`.lit-review/setup/c15-01-20261012/attempt-2/` and the parent setup directory.

Self-review and its separate reassessment found no actionable recommendation.
The initial independent review was prepared after focused, instance, static and
compiled compatibility checks passed, while the remaining trust audit completed
on frozen source. This follows Section 6.1's completed-step evidence requirement;
all mandatory gates still had to pass before closure. The completed trust result
was supplied as factual parent evidence during the review.

The same bound reviewer returned all four criteria satisfied with no material
or optional findings. It independently inspected signatures/proofs, consumers,
pinned APIs and boundaries, compared 31 relevant file hashes before and after
its checks, and ran both fresh-import probes and the static gate. It explicitly
labels the required parent builds/trust results as parent-reported evidence and
does not claim to reconstruct the entire source/environment fingerprint.
The parent retained the complete original native report, confirmed delivery
from that report after the initial empty submission result, received it and
reconciled it without changing the original assessments.

Final updates are confined to the living summary, project log and these notes.
They record the actual chronology and narrow stale current topology deferrals;
Lean code, public contracts, generated policy, dependencies and the normative
plan remain unchanged after review. The parent records exact final applicability
and reruns the static/document/link/diff checks before private completion.
No clean-checkpoint routine or current two-pass API-doc gate is claimed here;
those remain C15.05 duties. Later C15 steps remain unselected.


## C15.02 implementation, 2026-10-13

Conditional intake checked the actual C15.01 completion and unchanged final
source before selecting this step. The normative revision-2 plan is unchanged;
only its editorial status reflects the new selection.

Joint continuity follows directly from finite sums of absolute differences of
continuous real PMF coordinates. The converse uses the existing singleton-event
bound exactly as the preferred advice suggests; no private or public bound
wrapper is needed. Explicit `Function.comp_def` simplification resolves the two
initial compilation mismatches without changing statements or assumptions.
The original failed owner command and exact owner source are retained.
The next five-target build compiled both new mathematical files but failed the
strict umbrella target on a module-doc line longer than 100 characters. The
line was wrapped; no proof, signature or import changed. That failed overall
command is retained separately, and its static/trust stages were not run.

The implementation helper independently compiled a no-output boundary prototype
from the existing TV and finite-topology imports (exit 0, no diagnostics), after
removing an unnecessary nonexistent Bool simp name in its first probe. That
helper result is implementation advice, not formal review or final qualification.
The permanent consumer uses the closed-unit-interval subtype, exact coordinates,
`p_0 = PMF.pure false`, and exact pairwise TV before specializing to the endpoint.
It uses both delivered convergence iff theorems in both directions, including
PMF convergence derived from the exact TV formula. Singleton TV and impossible
empty target limits require no positivity or nontrivial-filter assumption.
The same mathematical family remains available for the later channel/objective
consumers, without a public fixture or cross-example import.

### Qualification and review, 2026-10-13

The first owner build failed in 76.747 seconds; the next five-target attempt
failed in 42.096 seconds on the strict documentation warning described above.
Neither failure is passing evidence. The successful serial commands were
`python -B scripts/validate_release.py focused
LeanInfoTheory.Probability.TotalVariationTopology
LeanInfoTheory.Examples.TotalVariationTopology
LeanInfoTheory.Examples.FiniteTopology LeanInfoTheory.Shannon
LeanInfoTheory.Examples` (exit 0, 12.403 seconds),
`python -B scripts/validate_release.py static` (exit 0, 8.608 seconds) and
`python -B scripts/validate_release.py trust` (exit 0, 1370.242 seconds).
The trust gate passed all 601 retained signatures, 662 supported declarations
in 38 owners, 94 simp declarations, 92 root exports and all 64 modules/2,104
local constants with only the three permitted axioms. Static included both
generator passes and all 34 website-checker tests. Complete input/output
inventories are identical and their path/hash/role projection matches every
entry in the review request. Commands, streams and manifests are retained under
`.lit-review/setup/c15-02-20261013/attempt-3/`.

Self-review and its separate reassessment found no actionable recommendation.
Independent review overlapped the serialized full trust audit on frozen source
after focused/static success. Section 6.1 requires all mandatory evidence before
closure; no gate was waived. The completed trust result was supplied as factual
parent evidence before the verdict.

The same bound reviewer returned all three criteria satisfied with no material
or optional findings. It inspected the proofs, permanent consumers, boundaries,
policy and targeted documents, compared 37 relevant supplied file hashes before
and after, freshly elaborated the exact consumer and generic public-interface
probes, and independently ran the static gate. Its first probe wrapper failed
printing Unicode after Lean returned zero; the corrected UTF-8 rerun passed.
The full original report retains both observations and distinguishes parent-run
build/trust evidence from independent checks. Selected hashes do not reconstruct
the complete environment fingerprint, and the no-output compiler probes use
existing imported artifacts rather than rebuilding their closure.

The parent preserved the complete native report, confirmed report-backed
delivery after the initial empty submission result, received the report and
reconciled it without changing its assessments. A separate helper documentation
check suggested clearer wording for the forward proof and future milestone
selection; those prose refinements are adopted without public-contract changes.
Final updates are confined to the living summary, project log and these notes.
Lean code, signatures/imports, configuration, dependencies, policy, generated
references and normative plan remain unchanged after review. The parent must
record exact final applicability and fresh static/document-link/diff checks
before supported private completion. No later C15 step, clean checkpoint,
commit or current API-doc milestone is selected.


## C15.03 implementation, 2026-10-13

Conditional intake verified the successful C15.02 closure, all three criteria
and every captured source entry before selecting this step. The normative plan
is unchanged; only its editorial status reflects the new selection.

The producer extends the existing probability owner with exactly the three
approved continuity theorems. The bind proof internally chooses enumeration
under `Finite`, rewrites `bind_toReal_apply` and uses continuity of finite sums
of products. Its existing real formula explicitly discharges no-top summands.
Map is the existing bind with pure outputs. Joint continuity uses the arbitrary-
alphabet coordinate iff, `channelJoint_apply` and `ENNReal.toReal_mul`.
No additional import or public helper is necessary.

The initial parent owner build failed (104.025 seconds) because a `simpa using`
continuous-product expression did not elaborate to the coordinate Tendsto goal.
Goal-directed simplification followed by `exact` fixed it without changing any
statement. The corrected owner build passed (15.327 seconds). The first exact
owner source and both original command results are retained separately. The
example file changed during the owner-only run; it is not an input to that
target, so this result is not claimed for an unchanged complete candidate.

One implementation helper compiled alternate private versions of all three
proofs plus generic/universe, infinite-alphabet and compact-image applications
through stdin on its first attempt. Another compiled the final mass algebra
and sparse deterministic-map calculation with only `FiniteChannel` imported.
Its initial missing `one_mul`, temporarily unavailable topology artifact during
the parent rebuild, and recursive direct map-sum simplification attempts remain
separate failures. Reusing `bind_toReal_apply` avoids that map-sum expansion.
These helper checks are implementation advice, not independent step review.

The permanent consumer locally copies the small interval-family construction
and coordinate-limit proof, with no cross-example import or public fixture.
Its generic checks use the delivered theorems directly without local enumeration
or replacement instances; concrete targets include `PMF Nat`. The actual bind
image uses `IsCompact.image` and delivered compactness. Distinct stochastic
rows give exact joint masses `1 - t`, `0`, `t/2`, `t/2`; output convergence is
proved both directly by bind and through the joint law's second projection.
The first projection, unused row at zero, positive-to-null true output mass,
and nonconstant/noninjective sparse deterministic map are explicit consumers.

The initial six-target build failed after 55.313 seconds on the private
`boundaryJoint_tendsto` function alias. Explicit `unfold boundaryJoint` before
composing limits resolves that elaboration issue; no statement changes. The
failed command and full input snapshot are retained; its later instance, static
and trust stages did not run.

### Qualification and review, 2026-10-13

The successful serial commands were
`python -B scripts/validate_release.py focused
LeanInfoTheory.Probability.FiniteTopology
LeanInfoTheory.Probability.TotalVariationTopology
LeanInfoTheory.Examples.FiniteTopology
LeanInfoTheory.Examples.TotalVariationTopology LeanInfoTheory.Shannon
LeanInfoTheory.Examples` (exit 0, 28.425 seconds),
two separate `lake env lean -DwarningAsError=true --stdin` instance probes
(focused exit 0, 12.766 seconds; umbrella exit 0,
13.943 seconds),
`python -B scripts/validate_release.py static` (exit 0, 10.263 seconds)
and `python -B scripts/validate_release.py trust` (exit 0,
1686.256 seconds). Exact probe sources, streams and results are
retained without disposable Lean files or compiler outputs. This preserves
Section 6.2's independent fresh imports and instance checks.

Trust passed all 601 retained signatures, 665 supported declarations in
38 owners, 94 simp declarations, 92 root exports and all 64 modules/2,155
local constants with only the three permitted axioms. Static included both
generator checks and all 34 website-checker tests. Complete input/output
inventories are identical and their path/hash/role projection matches all
230 entries in the review request. Commands, streams and manifests are retained
under `.lit-review/setup/c15-03-20261013/attempt-3/`.

Self-review and its separate reassessment found no actionable recommendation.
Independent review overlapped the serialized full trust audit on frozen source
after focused/instance/static success. Section 6.1 requires completed mandatory
evidence before closure; no gate was waived. The completed trust result and
full input/output comparison were supplied before the final criterion report.

The same bound independent reviewer assessed all three C15.03 criteria satisfied
with no material or optional findings. It inspected the proofs, permanent
consumers, imports, policy and pinned APIs; compared 40 supplied/supplemental
file hashes before and after; independently ran both fresh-import instance and
generality probes; re-elaborated the exact owner and consumer sources through
Lean stdin; and passed the maintained static gate. Its initial plan-excerpt
printing command failed under Windows cp1252; the UTF-8 rerun passed. That
failure did not invoke Lean or modify source and remains separate evidence.

The original report distinguishes parent-run focused/trust results from those
independent checks. Its 40-file comparison does not reconstruct the full source
fingerprint; imported artifacts were reused by its no-output compiler probes.
The parent separately verified all 230 inventory entries and retained the
completed trust result. The trust command's maintained target build is not the
clean default validation suite; no clean-candidate or API-doc milestone is claimed.

The parent preserved the complete native report, confirmed report-backed
delivery after the initial empty submission result, received the report and
reconciled it without changing its assessments. A separate implementation
documentation check found the mathematical descriptions consistent and identified
pending status paragraphs to refresh. No public-contract or plan change is needed.
Final updates are confined to the living summary, project log and these notes.
Lean code, contracts/imports, configuration, dependencies, policy, generated
references and normative plan remain unchanged after review. Exact final
applicability and fresh static/document-link/diff checks precede supported
private completion. No later C15 step, clean checkpoint, commit or current
API-doc milestone is selected.

## C15.04 implementation decisions, 2026-10-13

The conditional request was accepted only after C15.03's actual successful
closure, all three satisfied criteria and all 230 final source entries were
verified. Only Step 4 is selected. The plan's normative contracts are unchanged;
its editorial region records this selection.

The four public proofs use the existing finite entropy sum and
`Real.continuous_negMulLog`, then subtraction/addition and continuity of the
existing marginal maps. Fixed-channel objective continuity composes the joint
map with mutual information. This includes zero masses and needs no TV,
coupling, Fano, Jensen or KL project owner. Both universes remain independent.
The private generic maximizing-input theorem uses
`isCompact_univ.exists_isMaxOn`, delivered PMF compactness, the public actual
objective continuity and a pure law chosen from nonempty input. No independent
output nonemptiness, assumed continuity/compactness or optimizer is introduced.

The connected consumer privately repeats the tiny interval-family constructor
to retain a single focused import. It derives endpoint MI and conditional
entropy zero from the actual pure joint and existing information definitions
and `entropy_pure`, and composes the delivered continuity interfaces into two
explicit `Tendsto` conclusions. Its second marginal has real true mass `t/2`,
positive for `t > 0` and null at zero. Singleton objectives use existing
`entropy_map_injective`; empty input and empty output retain distinct behavior.
No public fixture, extremum wrapper, objective definition or new simp rule is
needed. Note 29 helper promotion remains pressure-driven; these helpers stay
private. Note 14 retains the four approved `continuous_...` names with no alias
or naming migration: no independent discovery friction was found. Note 9's
clean/current-API-documentation milestone remains assigned to C15.05.

Targeted reading revisited registered PW24 (August 16, 2024), Section 4.5
Proposition 4.8 (PDF 103 / printed 78), Section 4.7 Proposition 4.13(a)-(b)
(PDF 106-107 / printed 81-82) and Section 5.2 Theorem 5.4 (PDF 119 / printed 94).
All four page renders were inspected, then removed from ignored scratch.
Finite entropy and finite-joint MI continuity support the selected statements.
Part 4.13(b) is more general in the output alphabet; the approved finite-output
specialization uses joint continuity instead of its divergence argument.
Theorem 5.4 assumes an attaining input and is not an existence proof: the
consumer obtains existence from compactness and continuity. No saddle-point,
capacity, unrestricted KL or null-fiber conditional-law continuity is claimed.
Exact source hashes and supplemental pinned mathlib API observations are retained
privately without changing the frozen review scope or dependency pins.

The objective implementation helper compiled all four public proofs and the
actual extremum consumer through Lean stdin on its first attempt. The boundary
helper's first attempt failed on an underspecified rewrite argument in the
singleton-output proof; specifying the actual marginal fixed it, and its entire
corrected prototype compiled. Those helper checks used InfoMeasures and
FiniteTopology, generated no artifacts, and are implementation advice rather
than the independent review. The parent checks the final focused owner and
consumer, including the new explicit information-limit compositions.

The initial parent owner/consumer build failed after 58.451 seconds only on the
private joint-law alias in the explicit MI limit. The public owner compiled.
An explicit `change` of the goal to that alias fixes the elaboration mismatch
without changing the actual-objective statement. The original source, command
and streams are retained separately. A subsequent console-printing failure used
Windows cp1252 for a Unicode success marker; it did not change the recorded
compiler result. Later runners use UTF-8 console output.

The first complete candidate passed all eight focused targets (302.598 seconds)
and both fresh-import instance probes (11.422 and 12.315 seconds). Static then
rejected the English verb `admit` in the consumer module docstring, before
documentation/trust started. Rewording it as `have` removes that scanner match;
no proof placeholder or mathematical change was involved. The full failed
attempt remains retained, and the corrected candidate receives fresh checks.

### C15.04 qualification and review, 2026-10-13

The successful corrected-candidate commands were
`python -B scripts/validate_release.py static` (exit 0,
8.696 seconds),
`python -B scripts/validate_release.py focused
LeanInfoTheory.Probability.FiniteTopology
LeanInfoTheory.Probability.TotalVariationTopology
LeanInfoTheory.Shannon.Topology LeanInfoTheory.Examples.ChannelOptimization
LeanInfoTheory.Examples.FiniteTopology
LeanInfoTheory.Examples.TotalVariationTopology LeanInfoTheory.Shannon
LeanInfoTheory.Examples` (exit 0, 21.284 seconds),
two separate `lake env lean -DwarningAsError=true --stdin` instance probes
(focused exit 0, 11.334 seconds; umbrella exit 0,
12.413 seconds),
`python -B scripts/validate_release.py documentation` (exit 0,
117.973 seconds) and
`python -B scripts/validate_release.py trust` (exit 0,
1184.253 seconds). Exact streams and stdin sources are
retained without disposable Lean probes or output artifacts.

Documentation independently compiled all five README and four website guide
examples. Trust preserved all 601 retained signatures and verified 669 supported
declarations in 39 owners, 94 simp declarations, 92 root exports and all
66 modules/2,198 local constants with only the three permitted axioms.
Static passed both generator checks and all 34 website-checker tests.
Complete input/output inventories agree and their path/hash/role projection
matches all 232 entries in the review request. Evidence is retained under
`.lit-review/setup/c15-04-20261013/attempt-2/`.

Self-review and its separate reassessment found no actionable recommendation.
Independent review overlapped the serialized full trust audit after focused,
instance, static and documentation success on unchanged source. No required
gate was waived: the actual completed trust result and full source comparison
were supplied before the final criterion report.

The same bound independent reviewer assessed all four C15.04 criteria satisfied
with no material or optional findings. It inspected the information proofs,
actual extremum application, boundary/degeneracy consumers, focused closure,
policy and source adaptations; independently compared 50 supplied/supplemental
hashes before and after; rechecked the registered PW24 file and exact pages;
ran both fresh-import instance probes; re-elaborated the exact owner with
additional generic, empty, pure-boundary and arbitrary-filter applications and
axiom checks; re-elaborated the exact consumer; and passed the maintained static
gate. All its fresh checks passed.

The original report separates these independent checks from parent-run focused,
documentation and full trust results. Its 50-path hash check does not reconstruct
the complete source fingerprint; imported artifacts were reused by its stdin
probes. The parent separately verified all 232 inventory entries and supplied
the completed trust result before the final report. Neither party claims a
clean default suite, current API-doc milestone or retrospective per-olean
attestation. Cooperative review provenance is not OS isolation.

The parent preserved the original native report and separately confirmed
delivery after the initial empty response, received it and reconciled every
original assessment. Final updates are confined to the living summary, log and
these notes. Exact final source/configuration/dependency applicability and fresh
static/document-link/diff checks precede supported completion. No public
contract, proof, import, policy, generated reference or normative-plan change
occurred after review. C15.05, a clean checkpoint and the current API-doc
milestone remain separately selectable; no later work is started.

## C15.05 cumulative preparation, 2026-10-13 (pre-authorization history)

This subsection preserves the preparation state before scoped checkpoint/reuse
authorization. The initial-checkpoint result below supersedes its pending-status
wording without rewriting the original preparation sequence.

Step 4's successful completion record, all four satisfied original assessments,
absence of findings and exact 232-entry final inventory were verified before
accepting the conditional Step 5 instruction. The actual native authority
selects C15.05 only. No new mathematics or public declaration is needed.

The maintained [handoff](../handoffs/chunk-15.md) identifies all 17 cumulative
criteria, delivered interfaces and source adaptations, actual private MI
attainment, the connected boundary family, named-instance integration and
empty/singleton/null-fiber policy. Two read-only implementation helpers checked
source/consumer coverage and the checkpoint boundary; they did not compile,
edit, access private review records or provide formal cumulative review.
Canonical status and the long-term map's editorial header are reconciled.
The small stray plus in the living-summary optimization bullet is corrected.

The measured C13--C15 package adds 27 supported declarations, including two
C15 instances and two coordinate equations, below the rough substantive-growth
estimate. The handoff reports the limit of counting and reassessment after C18;
it introduces no API padding or new endpoint. Current names and private-helper
choices remain appropriate without new alias/fixture pressure.

The precise checkpoint excludes `.gitignore`, `AGENTS.md`, protected website
notes and the earlier project-log relocation entry. Owned policy/blueprint
working bytes are normalized to LF before checkpoint review. Fresh checks and
the staged-versus-working applicability decision must use those actual bytes.
Separate checkpoint/reuse authority remains pending under the approved plan.
The complete routine suite and actual two-pass current file-mode API-doc gate
remain required after authorization; earlier trust/static results are not
substitutes. C16, push and publication are unselected.

### C15.05 actual API-documentation result and preparation corrections

The actual current file-mode API-documentation gate passed both build/check
passes on source-stable inputs (528.972 seconds). All 16 new
declaration HTML blocks were checked for exact owner, signature/hypotheses,
useful docstrings and file source links. Browser inspection covered the three
new owner pages and the full Shannon umbrella page. The exact v2 source/configuration,
relevant-output digest and two-pass attestation are retained privately. The
whole-tree digest is attributed to the maintained gate, separately from the
parent's fresh relevant-page inspection. Existing reviewed Zig 0.16.0 and
pinned doc-gen caches were used; this is not a cold rebuild.

The first attempt failed because aggregate HTML generation reused an old
completion marker after extracting the new declarations, leaving all three
C15 owner pages missing. Its source and API inputs remained unchanged. The
parent retained that failure and the original bytes of exactly three ignored
Shannon HTML marker/hash/trace files, invalidated those files and ran both real
passes successfully. No source, dependency or validation rule was changed for
the recovery. Replayed upstream Qq extraction warnings remain in the logs;
the complete semantic checks passed. Current output stays in
`docbuild/.lake/build/doc/` and does not replace the historical release route.

An additional read-only handoff check found two wording improvements. The
readiness row now correctly requires readiness before dispatch and keeps the
later independent verdict/reconciliation as closure obligations. Current
qualification text at that preparation point distinguished the already executed
API-doc gate from the clean routine suite awaiting checkpoint authority. These
were documentation clarifications only; formal cumulative review had not been
dispatched at that point.

### C15.05 authorized initial checkpoint and final-candidate boundary

The lead explicitly authorized the prepared 20-file local checkpoint,
necessary C15.05-only amendments within those paths, and reuse of
`C:/Users/coban/Desktop/Lean Info Theory/.worktrees/LeanInfoTheory-C12-validation-20261003`.

Initial checkpoint `000aae22bf2db249e0286183b6cd3ebf4e910aba` passed the complete maintained routine suite in 3435.257 seconds.

The validation checkout was detached and clean before and after the suite;
its tracked files equal the committed blobs. The primary checkout deliberately
retains four unrelated dirty paths: `.gitignore`, `AGENTS.md`,
`docs/next-website-tasks.md` and the pre-existing relocation entry within
`docs/project-log.md`. The first three files are excluded wholesale; only that
unchanged historical entry is omitted from the checkpoint's log. The other
selected bytes match exactly. The two historical primary/clean byte differences
in `docs/plans/post-release-chunk-09-notes.md` and `docs/v0.1-public-api.json`
are CRLF versus LF only and remain preserved. These four exclusions and two
EOL distinctions are explicit; whole-checkout raw-byte identity is not claimed.

The actual command was `python -B scripts/validate_release.py` in the reused
clean checkout. Original streams, actual command/result, input inventories,
dependency identity and checkout comparison are retained under
`.lit-review/setup/c15-05-20261013/full-checkpoint/`. The complete gate passed
default/eight-target strict builds, five README and four website-guide consumer
compilations, retained/current compatibility, exact import/root/simp contracts,
all-project permitted-axiom checks, generated references, legal/release metadata,
website checks and final clean hygiene. Existing pinned dependencies and
incremental caches were used; this was not a cold rebuild. Clean and primary
tracked inputs stayed unchanged during the run, and dependencies stayed clean
at their pinned revisions.

The earlier actual two-pass current file-mode API-doc gate and rendered
inspection are separate evidence, bound to the primary source/configuration
and recorded outputs. The clean routine does not rerun that gate or renew its
attestation. Exact applicability to the checkpoint and every amendment must be
recorded separately, including the stated cross-checkout differences. Current
output remains in `docbuild/.lake/build/doc/`, outside the frozen release route.

These results qualify the initial checkpoint, not a later amendment.
Every amended candidate requires another complete clean routine suite and
exact API-documentation/source/configuration/dependency applicability. Finish
owned edits, retain self-review and separate reassessment, reconcile earlier
step reports and establish readiness before fresh independent assessment of
all 17 criteria. The original cumulative report, every reconciliation and
final-source applicability remain closure obligations. Source-bound private
records and the eventual user report establish the actual final results and
supported closure; this captured prose is not a verdict and needs no post-capture
rewrite merely to insert the eventual success reference. C16, push, publication
and dependency changes remain unselected.

Before the initial commit, the staged whitespace check reported a blank line at
the new plan's EOF. The parent initially removed it as a formatting correction.
A subsequent contract audit found that the installed review identity includes
those exact bytes outside the editorial status block. This final-document
amendment therefore restores the approved trailing blank line and verifies the
exact original normative hash. The narrowly understood staged-formatting notice
is retained; no contract, validator or acceptance rule is changed to suppress it.
The initial warning, temporary formatting change and exact restoration remain
separate evidence. The clean candidate still receives every maintained diff and
hygiene check. The earlier missing-page API-doc failure and successful bounded
recovery remain recorded above.
