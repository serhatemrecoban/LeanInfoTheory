# Chunk 11 maintained handoff: finite couplings and maximal coupling

## Status and authority

C11.01--C11.05 have actual `SUPERVISED_STEP_COMPLETE` records, identified below.
C11.06 was selected after verification of C11.05's closure and exact predecessor
source. The lead explicitly authorized the exact 24-file local checkpoint and
necessary C11.06-only amendments. Initial checkpoint
`2147dd3449af620f41d9bed8d37c5be8252f20e8` passed the clean complete routine
suite and real two-pass current API-doc gate; the original evidence is recorded
below. Final amended-candidate validation, exact API-doc applicability, the fresh
all-17-criterion review and original-report reconciliation, final capture and
closure are established by C11.06's source-bound private records. This maintained
chronology does not itself certify completion. Earlier step reviews do not replace
the cumulative review. The [approved revision-2 plan](../plans/post-release-chunk-11.md),
especially Sections 4--6, controls completion; requirements below are not PASS claims.

This handoff records source contracts, prior evidence and continuation boundaries.
The source-bound C11.06 private records determine exact candidate identity,
checkpoint authority, validation, review applicability, final capture and closure.
Checkpoint and necessary C11.06-only amendment authority comes from the explicit
lead approval captured privately, within its exact 24-file scope. No push,
publication or later-chunk authority is supplied by this handoff. Finish captured document changes before
final F; do not edit captured files afterwards to insert a closure reference.

## Delivered public mathematical interface

The supported owner is `LeanInfoTheory.Probability.Coupling`, namespace `PMF`.
It contains exactly ten public declarations: two definitions and eight theorems.
The first coordinate has law `p`; the second has law `q`.

| Public declaration | Contract and assumptions |
| --- | --- |
| `IsCoupling joint p q` | Joint-first predicate: `joint.map Prod.fst = p` and `joint.map Prod.snd = q`. Coordinate types and universes may differ; no finite or measurable-space premise. |
| `isCoupling_channelJoint_const` | The actual law `channelJoint p (fun _ => q)` couples the supplied laws. |
| `exists_isCoupling` | Existence witnessed by that independent law, without choosing an inhabitant. |
| `isCoupling_map_diag` | `p.map (fun a => (a,a))` couples `p` with itself. |
| `IsCoupling.map_swap` | The coordinate swap of any supplied coupling couples `q` with `p`. |
| `IsCoupling.totalVariation_le` | On a common `[Fintype alpha]`, TV is at most the supplied joint law's Real disagreement probability, with coefficient one. |
| `maximalCoupling` | The actual common-mass joint PMF for supplied laws on a common `[Fintype alpha]`. |
| `isCoupling_maximalCoupling` | Both ordered marginals of that actual constructor are exactly the supplied laws. |
| `maximalCoupling_toOuterMeasure_ne` | The actual constructor's disagreement event has ENNReal mass `ENNReal.ofReal (totalVariation p q)`. |
| `maximalCoupling_toOuterMeasure_ne_toReal` | Its Real disagreement probability is exactly `totalVariation p q`. |

The event is the existing Set event `{xy | xy.1 != xy.2}`, evaluated through
`PMF.toOuterMeasure`. The predicate and four elementary witnesses remain
type-generic; the inequality and four constructor declarations use a common finite
alphabet. No public coupling contract requires positive TV, full support, a cardinality lower bound,
measurability, a supplied equality decision or a global inhabitant. Empty inputs
are impossible because an empty alphabet has no PMF; universal contracts need no
fallback law. No independent optimization abstraction or uniqueness result is
exposed. The exact-event formula and universal inequality establish attained
minimum disagreement through the public API.

## Construction and proof choices

Let `delta = totalVariation p q`, `d = ENNReal.ofReal delta`, and
`m a = min (p a) (q a)`. At `delta = 0`, the constructor is the diagonal map.
At positive TV it uses `PMF.ofFintype` with ENNReal atom mass

```text
K(a,b) = (if a=b then m a else 0) + (p a - q a) * (q b - p b) / d.
```

Subtraction in this formula is truncated ENNReal subtraction. C10's overlap and
residual-total identities give row sum `p a` and column sum `q b`; the reverse
residual total uses TV symmetry. Normalization follows from the row sums. The
only cancellation denominator is nonzero and finite when TV is positive. The
formula avoids dividing by overlap and needs no strict TV<1 premise or
normalized residual-PMF API.

Private generic identities identify the selected law with the diagonal at TV=0
and with constant `channelJoint` at TV=1. At the latter endpoint, vanishing common
mass makes the residuals the original laws. This independent-law identity is
stronger than marginal and maximality claims and remains private. The exact-event
proof explicitly treats both endpoints: diagonal event transport at zero TV,
and disjoint actual supports at unit TV. In the positive branch, one residual
vanishes at each diagonal atom, so agreement equals the total common mass.
A finite event partition gives disagreement as its complement with a finite-total
guard. The ENNReal equality precedes the Real conversion, which uses TV
nonnegativity. No unguarded `toReal` injectivity or cancellation is used.

The coupling inequality uses C10's attaining event and finite real indicator
sums. It compares a marginal event discrepancy with disagreement directly.
Projection, agreement, complement and normalization machinery stays private.

## Ownership, imports and compatibility boundaries

- `Probability.Coupling` imports exactly `Probability.FiniteChannel` and
  `Probability.TotalVariation`.
- `LeanInfoTheory.Shannon` includes the new owner through an approved direct
  import while retaining its earlier imports. The actual growth-policy records,
  not generated inventories, approve the new owner and umbrella addition.
- The lightweight root still directly imports exactly `Probability.Finite` and
  `InformationMeasures`, with its unchanged five-local-module closure.
- `Examples.Coupling` imports only `Probability.Coupling`.
- `Examples.CouplingFano` imports exactly `Probability.Coupling`, `Shannon.Fano`
  and `Shannon.SemanticBridge.Product`.
- Both private consumers join only `LeanInfoTheory.Examples`. Neither mathematical
  umbrella imports examples. The low-level owner adds no Shannon, KL, Markov,
  Product, measure-product or kernel dependency.

There are no new aliases, instances or global simp attributes. The current
supported surface contains 638 documented declarations in 33 owners, including
all ten coupling declarations; the 94 reviewed simp declarations and 92 root
exports remain unchanged. The source-derived inventory records 52 modules,
110 local import edges, five root-reachable and 47 separate-import modules,
753 indexed declarations, 752 documented and one example-only instance.
Nineteen non-stable modules are excluded from the supported API. The frozen
601-declaration release manifest, retained signatures, dependency pins, legal
metadata and versioned website route remain protected.

## Permanent private consumers and their limits

All declarations in the two coupling example modules remain private. They use
the public producer contracts rather than its private construction machinery.
All ten public coupling declarations have maintained consumer uses.

| Consumer group | Actual source coverage |
| --- | --- |
| Generic elementary laws | Independent ordered marginals, existence for heterogeneous `Nat`/`Bool` coordinates, diagonal marginals, swap and repeated swap, and empty-alphabet impossibility. |
| Universal inequality | Arbitrary couplings in both event orientations; diagonal and subsingleton equality; disjoint-support lower bound and distinct pure Bool endpoints. |
| Strict non-maximal example | Identical fair Bool marginals have TV zero; their independent joint law has disagreement `1/2`, while the diagonal has zero. The inequality and strictness are explicit. |
| Actual attaining witness | Generic and swapped marginals, exact ENNReal disagreement and no-greater Real disagreement than any competing coupling. |
| Actual endpoints and interior | Equal/disjoint/pure cases, sparse ternary laws `(1/2,1/2,0)` and `(0,1/2,1/2)` with disagreement `1/2` in both orders, pure-versus-fair and strictly interior quarter-versus-fair Boolean laws, subsingletons and empty inputs. |
| Private constructor checks | In the probability owner, generic diagonal/independent endpoint identities and sparse middle-diagonal and first-to-last residual atoms, each of mass `1/2`. |
| Fano in both coordinate orders | The actual `maximalCoupling p q` and its `map Prod.swap`, four ordered marginal equalities, transported ENNReal disagreement and both identity-decoder errors equal to the same `totalVariation p q`. Existing expanded Fano bounds apply in nats. Equal/subsingleton laws have zero errors and conditional entropies. |
| Independent-product semantics | Constant `channelJoint` is definitionally `Shannon.indepProd`; existing whole product-measure and measurable-rectangle theorems apply. Different coordinate types/universes remain generic. Only these measure consumers require coordinate measurable spaces; rectangles also require their two sets measurable. |

Fano's first coordinate is the source and second is the observation. Its identity
decoder tests `second != first`; the private finite-sum bridge reconciles that
with coupling's `first != second`. The bridge uses `[Finite alpha]` and introduces
enumeration internally. It does not require a measurable space. The Fano bound
retains Nat subtraction before casting `card alpha - 1` to Real and includes
singletons without a cardinality lower bound. The consumer uses the same witness
and its swap; it neither assumes nor proves equality with `maximalCoupling q p`.
No entropy-difference, continuity, randomized-decoding or Fano equality-classification
result is delivered here.

## Mathematical sources and adaptations

Exact editions and hashes are in the [reference register](../references.md).
Local reference text and proofs are not redistributed.

- SA13, arXiv `1209.5259v5`, Section I, Theorem 1 and equations (3)--(9),
  PDF/printed pages 2--3; Theorem 2 and equation (10), page 3: common-mass
  agreement and disagreement equal to half-L1 TV.
- LP17, second edition, Section 4.2, Proposition 4.7 and Remark 4.8,
  printed pages 50--52 / PDF pages 66--68: universal coupling bound and an
  attaining joint law.
- PW24, August 16, 2024 draft, Section 7.3, Theorem 7.7(b), equation (7.20),
  printed page 122 / PDF page 147; proof on printed 123 / PDF 148: coupling
  characterization of TV. C10 already owns the event/test normalization.
- The existing Fano contract is supported by CT91 Section 2.11, Theorem 2.11.1,
  equation (2.144), printed pages 38--40 / PDF 60--62, and PW22 Section 6.3,
  Theorem 6.3, equation (6.8), printed page 82 / PDF 103. CT91's bit convention is
  adapted to canonical nats; PW22's randomized-estimator extension is not consumed.

The finite matrix is the algebraically flattened form of the normalized-mixture
construction. Explicit zero/unit-TV branches and finite guards resolve the
sources' informal unused endpoint denominators. No general measurable-diagonal
condition is needed for the finite outer-measure event. Singleton logarithmic
conventions are handled by the existing Lean Fano theorem. PW22 numbering is not
transferred to PW24. No external information-theory formalization was consulted.

## Prior completion and review evidence

The following records are under `.lit-review/setup/`. All five observed records
say `SUPERVISED_STEP_COMPLETE`; all 14 registered earlier-step criteria are
`SATISFIED`. Each original report is retained and explicitly reconciled through
its `c11-0N-review-parent-reconciliation-20260926.json` record. Those records have
no finding decisions or outstanding criterion gaps. This is historical evidence
for each captured source, not a C11.06 verdict.

| Step | Completion record | Original report | Criteria |
| --- | --- | --- | --- |
| C11.01 | `c11-01-completion-20260926.json` | `c11-01-review-original-report-20260926.txt` | 3 satisfied |
| C11.02 | `c11-02-completion-20260926.json` | `c11-02-review-original-report-20260926.txt` | 2 satisfied |
| C11.03 | `c11-03-completion-20260926.json` | `c11-03-review-original-report-20260926.txt` | 3 satisfied |
| C11.04 | `c11-04-completion-20260926.json` | `c11-04-review-original-report-20260926.txt` | 3 satisfied |
| C11.05 | `c11-05-completion-20260926.json` | `c11-05-review-original-report-20260926.txt` | 3 satisfied |

The content-addressed references below come from the actual completion records.
The accepted-report reference is not claimed to be the raw wrapper file's hash.

| Step | Closure | Final source F | Accepted report |
| --- | --- | --- | --- |
| C11.01 | `ded46abba16c99f2481475214aa2497df93c47c3e6154e3967f0c9345016c548` | `8e087dada8204a56b8fc02fb23e5f007932aaade7c28a7b1427d437eaf0038bf` | `c25853957994c71238ebd0376f4fedca7e860e50cc979df83442d75ee5df4d39` |
| C11.02 | `6eb7052bf552305eafe005fe9d06a04d7c147863d6b0e0e89aa221324aed31b9` | `c4eb335bcb764cfb5e10b85caa041bcfd216f22d94b9e89562789889a49b3893` | `77367ff265d6dbe8dcdf12e53b02d743a267c93ef8f23322f8bfba8219929338` |
| C11.03 | `e0531bb9a816dd85e2e5416bfeb1e227ddbb94e705c5b99f9854c5f0d8f00c04` | `d079e59fb131c39966410945c8e40358ffe9ceb95d9d6a4b46a7637858759403` | `0b916c267173469bad2db16577763012620b335c642cee0cd0674b9e6c005753` |
| C11.04 | `b84f753138c591faece3cb1885f8945468fd51a23d2000bc3a8e7a6e979e3907` | `99fef39a8ef77559e245baa2557a3455ba665c14802c948098af8ccbe5b80418` | `71d32dbe2d09f562514471c6196dba6f2950605fc0294095ea2e5a9a784b3429` |
| C11.05 | `9164f2e0361cb2f7c425f49337f3e4935c6138f985c0b8f18fd784f59833831f` | `cea589d4f2d81c30ae5224af2ac631c6201b78b461f6e2ea38d3f9c5a308df24` | `63afe54d8e35dd86701d267ee4a991f45ef4ea0e55d3a308413e2e2a88dd119e` |

### Plan-review chronology

Revision 1's bound report identified the circular cumulative-review criterion and
judged the other 16 planning requirements adequate. Report admission failed
because the original `inspected_source` fields were lists where the parser
required strings. Its original report and failed admission remain preserved
under `c11-plan-review-*`; neither formal acceptance of that report nor a fresh
formal revision-2 plan-review acceptance is inferred. The lead approved revision 2.
Its substantive correction separates readiness for the cumulative assessment
from the mandatory later report, reconciliation, correction, validation and
closure. Later step reviews explicitly address that correction. The lead's
General Assistant advisory report remains separately attributed advisory input.
The new fresh full-chunk review must still assess all 17 criteria.

### Latest prior validation evidence

These actual C11.05 result records report exit 0 on their recorded source. They
provide useful predecessor evidence; C11.06 must establish its own applicability
and required cumulative gates.

| Prior check | Actual result reference | Recorded duration |
| --- | --- | --- |
| Focused owner/consumers/Fano/Product/Examples/Shannon/root | `.lit-review/setup/c11-05-focused-final-20260926.json` | 31.221 seconds |
| Current generated/static checks | `.lit-review/setup/c11-05-static-final-20260926.json` | 14.482 seconds |
| Documentation gate | `.lit-review/setup/c11-05-documentation-final-20260926.json` | 203.559 seconds |
| Full trust, including fresh compiled compatibility | `.lit-review/setup/c11-05-trust-final-20260926.json` | 1573.068 seconds |
| Ten-declaration signature/axiom probe | `.lit-review/setup/c11-05-api-final-20260926.json` | 19.885 seconds |

Original failures and warning-bearing iterations are preserved. Corrected
consumer/owner linter premises use `Finite` where enumeration is only internal;
no linter or contract was weakened. C11.05's two earlier focused-result JSONs
retain their original final-labelled log field after the record/log files were
renamed. The exact mapping to the retained initial and intermediate logs is
explicit in `c11-05-source-audit-20260926.json`, field
`initial_iteration_evidence_not_final_validation`. Neither warning-bearing run
is final validation evidence. C11.04's signature-probe formatting correction
likewise retains its original failed evidence separately.

Pinned cancellation uses `Mathlib/Data/ENNReal/Inv.lean`, transitively imported
by the captured `BigOperators.lean`. The immutable execution scope does not
separately list `Inv.lean`; the notes explicitly supplement its dependency
identity. Checkout SHA-256 is
`f88286bd4a1367d8076f6828a3ca88e0309cf0cad3d8fce60532fbba0617b03e`, while the
pinned LF blob SHA-256 is
`bbc0988d1a084ec35346dc7ab70b455efe86a833c84c499ec5e4dc0b07550d72`.
The recorded clean mathlib commit is `0df444a360eaa60ab8c11dca51a86af692955474`;
CRLF checkout versus LF blob explains their raw-byte difference. Preserve the
supplement and recheck identity when assessing dependency applicability.

## C11.06 initial evidence and applicability

The lead authorized initial local checkpoint
`2147dd3449af620f41d9bed8d37c5be8252f20e8` and necessary C11.06-only amendments
within the exact 24 approved paths. These are completed initial checks; later
amendments require their own applicable evidence.

| Check | Observed original evidence |
| --- | --- |
| Clean complete routine suite | `.lit-review/setup/c11-06-full-checkpoint-20260927/result.json`; exit `0`; `1983.359` seconds. Observed scope: `complete maintained build/example, retained compatibility, exact current API/import/root/attribute, all-project trust, static/generated/site and clean-hygiene gates`. |
| Real current file-mode API docs | `.lit-review/setup/c11-06-api-docs-recovered-20260927/result.json`; exit `0`; both checked passes, `234.8s and 19.9s`. Coverage: 638 declarations, 33 supported pages, 92 export targets, 19 non-stable exclusions and zero equation rows. |
| Actual new-owner inspection | `.lit-review/setup/c11-06-api-doc-inspection-utf8-20260927.json`; actual Coupling module page and all ten public names have the expected signatures, docstrings and ownership. |
| Exact build identity | v2 `docbuild/.lake/build/api-doc-build-attestation.json`; `.lit-review/setup/c11-06-api-doc-inspection-utf8-20260927.json (embedded attestation and configuration)`. Original configuration and source/dependency identities are retained privately. |

The API-doc passes used `DOCGEN_SRC=file`, `DISABLE_EQUATIONS=1` and the reviewed
Windows Zig executable. Output stays local under `docbuild/.lake/build/doc/`.
Current output is separate from the frozen release route. The fresh cumulative
original report, all-criterion reconciliation and exact final completion belong
to the source-bound C11.06 private records; no earlier report supplies them.

The first API-doc run failed its semantic check because the generated manifest
omitted the new Coupling HTML page, although Coupling and Shannon docInfo rebuilt.
The original failure remains at
`.lit-review/setup/c11-06-api-docs-checkpoint-20260927/result.json`. The recovery
record `.lit-review/setup/c11-06-doc-marker-recovery-20260927.json` preserves the
bytes of exactly three ignored Shannon HTML completion-marker/hash/trace files
before their invalidation. The complete two-pass rerun passed at
`.lit-review/setup/c11-06-api-docs-recovered-20260927/result.json`. No maintained
source, validator, dependency pin or API contract changed. Both attempts replayed
upstream Qq docInfo warnings for `mkLambdaQ` and `withLetHave`; all current
supported signatures passed the successful rerun's semantic checks.

The first page inspector saved all ten successful declaration checks before its
console output failed on a Unicode symbol. The same read-only inspector passed
with Python UTF-8 output; the original inspection and the console-error
observation remain preserved beside the successful inspection record.

## Cumulative criteria and closure protocol

The exact normative contracts remain in [plan Section 4](../plans/post-release-chunk-11.md#4-implementation-steps-and-completion-criteria).
This map identifies the cumulative source to assess and does not supply the
fresh independent assessment.

| Required criteria | Cumulative source/evidence |
| --- | --- |
| C11.01-MATH / BOUNDARY / CONSUMER | Generic joint-first interface and elementary witnesses; actual growth approvals and imports; heterogeneous, ordered, swap and empty consumers. |
| C11.02-MATH / CONSUMER | Universal coefficient-one finite inequality; event orientation, endpoint cases and explicit strict independent fair-Bool example. |
| C11.03-NORMALIZATION / MARGINALS / ENDPOINTS | Actual positive matrix with guarded denominator; row/column/unit mass; exact ordered marginals; private generic diagonal/independent and sparse-atom identities. |
| C11.04-EXACT / ATTAINMENT / EDGES | Exact ENNReal then Real disagreement, explicit endpoint arguments, public optimality consumer and the complete approved edge matrix. |
| C11.05-FANO / INTEROP / API | Same actual witness and swap in Fano; four marginals, exact errors and equal/subsingleton cases; independent-product measures; ten public declarations and private helpers/imports. |
| C11.06-VALIDATION / INDEPENDENCE / HANDOFF | Fresh cumulative gates and actual two-pass API docs; readiness for independent assessment with earlier reports reconciled; canonical reconciliation and this maintained handoff. All remain subject to C11.06 evidence and subsequent postconditions. |

Required continuation:

1. Finish the authorized C11.06-only chronology amendments within the exact
   approved paths, preserving the mathematical source, normative plan, historical
   evidence and standing notes. The default validator and hygiene require a clean
   committed tree; never weaken that gate or include unrelated work.
2. Repeat the complete routine validator after each authorized amendment. It
   controls the current target list, compatibility, root/import/attribute, trust,
   example, generated/site and hygiene gates. Trust allows only `propext`,
   `Classical.choice` and `Quot.sound`. Initial success does not qualify amended
   inputs automatically.
3. Establish exact API-doc applicability after each amendment. Reuse the original
   two-pass evidence only when its source/configuration and attestation remain
   applicable; otherwise repeat both real passes with reviewed Windows Zig 0.16.0
   and `DOCGEN_SRC=file`. Preserve actual Coupling-page inspection, all ten
   signatures/docstrings, current coverage and v2 attestation. Output stays local
   under `docbuild/.lake/build/doc/`, separate from the frozen `v0.1.0` route.
4. Obtain the bound fresh full-chunk report against all 17 criteria, preserve its
   original evidence and explicitly reconcile every finding and assessment,
   including a clean report. Correct material problems and obtain renewed review
   for material source changes or criterion gaps.
5. Finish canonical and handoff edits before review candidate R where possible,
   reassess R-to-F applicability after all captured changes, establish final
   validation/review applicability, capture F and complete the supported private
   closure. A clean applicable report permits closure without another chronology
   edit; material findings still require correction and revalidation. Do not edit
   captured files after F to insert its identity or closure.
6. Report the actual completion record and stop. No later chunk starts
   automatically; this local authority includes no push or publication.

C10's first new-module API-doc attempt reused an aggregate HTML marker and
omitted the TV page despite rebuilding module `docInfo`. The semantic checker
rejected it. Bounded invalidation of the ignored
`doc-data/LeanInfoTheory.Shannon--module.docs_built` marker and its `.hash`/`.trace`
sidecars was followed by a successful complete two-pass rerun. Preserve that
observation for the new Coupling page. Diagnose actual current failures before
any cache change; do not delete caches preemptively or infer success from a Lake
exit alone. Note 9's documentation maintainer owns a reproduced stale-output issue.

## Remaining work, owners and triggers

| Item | Owner and next authorized trigger | Boundary |
| --- | --- | --- |
| Cumulative C11 qualification and closure | C11 implementation task and bound reviewer during selected C11.06 | Complete the gates, exact applicability, all 17 assessments, reconciliation and private closure above. Earlier success cannot replace them. |
| Coupling transport, lifting and finite gluing | C12, after its own approved plan and explicit step | Consume raw joint PMFs and ordered marginals; use existing total conditional channels and prove null-middle-fiber choices irrelevant. A heavy Markov reconstruction dependency belongs in a separate semantic owner. Decide public composition versus a gluing theorem in that plan. |
| Composition/maximality regression | C12 detailed-plan owner when implementing conditionally independent gluing | Adjacent maximal couplings need not give a maximal endpoint coupling. The proposed uniform/point-mass/uniform two-point example has endpoint disagreement 1/2 despite endpoint TV 0; it remains an unimplemented downstream regression. |
| Pinsker and quantitative independence | C13 after separate approval | Reuse C10's event/binary reduction and KL DPI; retain nats, infinite-KL and singular-support guards. C11 adds no divergence inequality. |
| Entropy, conditional-entropy and MI continuity | C14 after its own approved plan | Consume this actual witness, both exact marginals, exact disagreement and the working Fano consumer. Separate the exact-distance expression from a monotone upper-estimate modulus; handle singletons and name controlling alphabet sizes. No pointwise conditional-law continuity at null fibers is implied. |
| Finite-simplex topology and optimization | C15 after separate approval | Reuse finite TV and entropy interfaces; review existing simplex/topology instances before additions. No topology or optimization framework is delivered by C11. |
| Public residual/common-law constructors, maximality or infimum packaging, projection aliases, semantic coupling/Fano bridge | Coupling/API maintainer, or C12/C14 owning a concrete repeated consumer need | Keep present helpers private; assess meaning, assumptions and import/API impact before promotion. A found pinned upstream coupling object requires the same compatibility review before a material representation change. |
| Four-symbol residual example | Coupling maintainer only if a concrete residual-product coverage gap appears | Optional private check with two residual atoms on each side; no public computation API is required by the present plan. |
| Naming/discovery, Note 14 | API maintainer on reproducible repeated consumer/search friction | Preserve the ten names, record deduplicated evidence in the feedback register and review any alias. C11.05 found no actionable recurring friction. |
| Simp and chain rules, Notes 15--16 | API/theorem maintainer on demonstrated terminating reduction in maintained consumers | Retain the reviewed 94-name set and explicit representation-changing rewrites. |
| Validation/import boundaries, Notes 17--18 | Each milestone implementer; architecture maintainer/lead for an exception | Preserve evidence applicability, assumptions, root reachability, exact imports and private examples. The current validator overrides historical target lists. |
| Independence-module boundary, Note 26 | Architecture maintainer on measured import, ownership or maintenance pressure | No preemptive split or declaration move follows from coupling/Fano consumers. |
| Documentation, Note 9 | Documentation maintainer on the current API-doc milestone, reproduced cache failure or separately approved curation/publication | Current generated source index differs from signature-bearing docs; preserve the frozen route. Theorem-level blueprint, equation expansion, recurring-status tooling and publication remain separately scoped. |
| Further independence conveniences, Note 25 | Future theorem owner on concrete consumer pressure | Earlier deterministic-processing work stays closed; no broad convenience expansion is a C11 prerequisite. |
| Fano follow-ups, Note 29 | Owning entropy/Fano maintainer on a second independent production use, or a separately approved pedagogy/sharpness phase | Retain the five groups: complement-of-one-atom entropy; repeated ENNReal error-weight extraction; q-ary normalization; positive-cardinality logarithm comparison; stronger pedagogy or exact-Fano sharpness. Optional theorem-highlights curation is separate. The coupling consumer does not promote those helpers. |

C14's proposed exact bound on an alphabet of size `m >= 2` is
`abs (H(p)-H(q)) <= h(delta) + delta * log(m-1)` at exact `delta = TV(p,q)`.
For only `TV <= epsilon`, the proposed monotone modulus uses that expression
through `1-1/m` and `log m` above it, with singletons handled separately.
C11 supplies prerequisites, not these continuity results. C12/C14 and the wider
C12--C24 programme still require their own detailed plans and execution authority.
Optimal transport, general measurable-space coupling, process coupling,
randomized/list decoding, equality classifications, coding theorems and downstream
certificate/application work are not added by this handoff. Other future-work
notes retain their existing owners and triggers; no broad note is closed here.

## Source identity and continuation

All five earlier completion records retain Git HEAD
`37b4ba90d1ab321645f80cacef475f10a3a6ba43` and report uncommitted source changes.
That Git identity is the C10 checkpoint retained by those earlier records.
The authorized initial C11 checkpoint is
`2147dd3449af620f41d9bed8d37c5be8252f20e8`; final source F and exact review
applicability remain private-record facts. The following hashes identify the
preserved mathematical source, current manifest and current policy at that initial
checkpoint:

| Path | SHA-256 |
| --- | --- |
| `LeanInfoTheory/Probability/Coupling.lean` | `d785822d7ee3da89ed88c4556580599786150dfdbf0adbc53174fccf49a7c9f9` |
| `LeanInfoTheory/Examples/Coupling.lean` | `094bbba9a3aa8f5765113d122e925211f228082f709c40f873fd4ec8c1da7fc5` |
| `LeanInfoTheory/Examples/CouplingFano.lean` | `5aedf2a15da6fb0181a749636d8a3ac3d6d62a9e15b4b5f85b78a515373b6e05` |
| `docs/current-public-api.json` | `2478b383502d5c458f21e614840ea9cfde36ed880c6de07258f4d99d675ee563` |
| `docs/compatibility/current-api-policy.json` | `a1c383035ebb9f9568136cdb49735581da9f2b38d70f6cd2cb552c8086a92c71` |

Equal names, types or hashes do not alone establish mathematical meaning;
source interpretation and permanent consumers are separate review obligations.
C11.06 must establish the applicability of these source identities to its actual
candidate. Its private records own the exact checkpoint, full-suite/API-doc
results, original report, reconciliation, R, F and completion. Do not predict
those identities. If a later actual closure exists, this snapshot's provisional
wording does not reopen it. Continue only the authorized remainder, preserve all
durable evidence and start no later chunk automatically.
