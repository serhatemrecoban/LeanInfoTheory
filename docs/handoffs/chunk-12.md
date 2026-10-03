# Chunk 12 maintained handoff: coupling transport and finite gluing

## Status and authority

C12.01--C12.03 have actual `SUPERVISED_STEP_COMPLETE` records, identified below.
C12.04 was selected after verification of C12.03's closure and exact final
source. It owns cumulative validation, documentation reconciliation and the
fresh full-chunk review. The [approved revision-2 plan](../plans/post-release-chunk-12.md),
especially Sections 4--7, controls completion.

The lead explicitly authorized the exact 35-file local checkpoint, a separate
clean validation checkout and necessary C12.04-only corrections and final-record
amendments. Initial checkpoint `44d300c97d86b1fc0f40e9c70eb33a16bbfe3abe`
passed the complete routine suite in the separate clean checkout described below.
Corrected focused/static checks, relevant regression tests and real two-pass
current file-mode API documentation also passed; the actual four new declaration
blocks and Gluing page were inspected. Final amended-candidate validation, exact
API-doc applicability, fresh all-13-criterion review, reconciliation and private
closure remain subject to the source-bound C12.04 records. This chronology does
not certify those later outcomes. Earlier step records retain their exact scope.

The source-bound C12.04 records determine the final candidate, checkpoint
authority, validation, original-report reconciliation, final capture and closure.
This handoff supplies no push, publication or later-chunk authority. Preserve
the unrelated `docs/next-website-tasks.md` bytes and exclude that file from any
C12 checkpoint. Finish captured documentation before final F; the private
completion record and final user report carry the actual closure reference.
Do not amend captured documents afterwards merely to insert that reference.

## Delivered public mathematical interface

C12 adds four public theorems. It adds no public definition, selected composition
operator, alias, instance or global simp attribute. Existing C11 declarations
remain in place.

| Public declaration | Owner and contract |
| --- | --- |
| `PMF.IsCoupling.map` | `Probability.Coupling`: mapping the two coordinates of a supplied coupling by `f` and `g` gives a coupling of the two pushforward laws. All four coordinate types and universes may differ. |
| `PMF.IsCoupling.bind` | `Probability.Coupling`: bind a supplied joint law through a supplied channel of joint output laws. Each channel row must couple the prescribed output rows only when its input pair belongs to the actual joint support. The result couples the two bound marginal laws. |
| `PMF.channelExtension_eq_iff_eq_on_support` | `Probability.FiniteChannel`: `channelExtension p W = channelExtension p V` iff `W b = V b` for every `b` in the support of `p.map Prod.snd`. This characterizes equality of the entire triple law. |
| `LeanInfoTheory.Shannon.exists_isMarkovChain_with_marginals` | `Shannon.SemanticBridge.Gluing`: pair laws `L : PMF (A × B)` and `R : PMF (B × C)` with equal middle marginals admit a triple with exactly those AB and BC marginals and `IsMarkovChain`. Only `[Finite C]` is required; A and B and all three universes remain arbitrary. |

The exact gluing result is:

```text
L.map Prod.snd = R.map Prod.fst ->
  exists T : PMF (A × B × C),
    fstSndMarginal T = L and sndThirdMarginal T = R and IsMarkovChain T.
```

Triples are right-associated. The raw transport and extension-equality theorems
need no finite, measurable-space, injectivity or global inhabitant premises.
Gluing introduces `Fintype C` internally from `Finite C`. Supplied PMFs rule out
empty coordinates; no fallback inhabitant is added. Pure and singleton laws
remain covered.

The API returns an existential witness. Consumers retain its pair marginals
and Markov property and derive its endpoint coupling by map composition. No
public endpoint-existence wrapper or uniqueness theorem is needed for those
consumers. A selected public composition would create additional identity,
associativity and reassociation contracts without a current production need;
the approved theorem-only design leaves those for a concrete later consumer.

## Construction, support and representation choices

Coordinate transport uses pushforward composition. Channel lifting pushes the
coordinate projections through `bind`, identifies the supported rows through
the existing channel-joint equality theorem and rewrites the input marginals.
The row condition is on the supplied joint support, not the product of the
marginal supports.

For extension equality, projecting equal triples to their output pair gives
necessity through `channelJoint_eq_iff_eq_on_support`. For sufficiency, supported
middle rows agree. Outside middle support every contributing input-pair atom
is zero, so both extension atoms vanish. The statement imposes no condition on
unused rows and does not give those rows conditional-probability meaning.

Gluing takes the existing total conditional channel
`condFstGivenSndChannel (R.map Prod.swap)` and extends L through it. Input
projection gives L. Output-pair projection, the common-middle equation,
existing conditional reconstruction and double swap give R. The existing
`isMarkovChain_channelExtension` supplies Markov structure. The new proof
introduces no division. Existing conditional reconstruction already handles
the nonzero supported mass and finite-mass cancellation guards.

The private consumer identifies the public witness with an explicit extension
using existing Markov factorization, output-pair equality, channel-joint support
equality and the new extension support iff. This identification uses both pair
laws and the Markov property. Pair laws alone do not determine independent
endpoints.

## Ownership, imports and compatibility

- `Probability.Coupling` imports exactly `Probability.FiniteChannel` and
  `Probability.TotalVariation`.
- `Probability.FiniteChannel` still imports only `Probability.Finite`.
- The new `Shannon.SemanticBridge.Gluing` imports only
  `Shannon.SemanticBridge.Markov`. The semantic aggregate imports Gluing; the
  full Shannon umbrella reaches it through that aggregate.
- `Examples.CouplingTransport` imports only `Probability.Coupling`.
- `Examples.CouplingGluing` imports exactly `Probability.Coupling` and
  `Shannon.SemanticBridge.Gluing`.
- Both consumers join only `LeanInfoTheory.Examples`. Neither mathematical
  umbrella imports examples. The lightweight root still directly imports
  `Probability.Finite` and `InformationMeasures`, with five local modules in
  its closure.

The cumulative mathematical surface records 642 documented declarations in
34 supported modules: 573 theorems, 59 definitions, nine abbreviations and one
instance. The 94 reviewed simp declarations and 92 root exports are unchanged.
The source-derived inventory records 55 local modules, 117 local import edges,
five root-reachable and 50 separate-import modules, with 757 indexed declarations
(756 documented and one example-only instance). Twenty-one non-stable modules
remain outside the supported API. Growth approvals belong to the reviewed
current policy, not the generated inventory. The frozen 601-declaration release
contract, dependency pins and versioned website route remain protected.

## Maintained private consumers

All declarations in the two new example owners are private. They test every
new public theorem from the minimal imports above.

| Consumer group | Delivered evidence in Lean source |
| --- | --- |
| Generic transport | Both mapped and lifted marginals; deterministic lifting equals coordinate transport; identity, composition, swap and constant maps; heterogeneous noninjective `Nat × Bool` to `Bool × Unit`; pure, singleton and impossible-empty cases. |
| Actual joint support | The diagonal fair-Bool joint supports only equal pairs, although both values occur in both marginal supports. A swapped pure row at the unused `(false,true)` has both marginals wrong. Supported rows meet the premise and lifting still returns the original diagonal law. |
| Generic gluing and endpoints | One invocation of the public existence theorem supplies both exact pair laws and Markov structure. Projection of that same witness gives an endpoint coupling. A private identification lemma connects it to explicit extensions. |
| Arbitrary null fallbacks | Every total channel agreeing with the canonical conditional channel on actual middle support gives the same whole public witness. Equality is not limited to endpoint projections or to two chosen fallback rows. |
| Two positive middle fibers | The middle `Fin 3` law has masses `(1/2,1/2,0)`. The first two rows give different deterministic Bool outputs. At the null third value, pure false and pure true are different rows but give the same triple. Exact pair atoms and diagonal endpoints belong to the same public witness. |
| Gluing edge cases | Exact pure triple, singleton law, impossible empty coordinates and `Nat`/`Nat`/`Bool` ambient alphabets. The last example does not assume `Finite Nat`. |

### Quantitative transport through actual maximal witnesses

For a common finite input alphabet and finite output alphabet, the private
consumer sets

```text
J = maximalCoupling p q
K(a,b) = maximalCoupling (W a) (W b)
L = J.bind K.
```

The new lifting theorem supplies the output marginals. C11's exact ENNReal
disagreement law and bind event evaluation give

```text
L.toOuterMeasure {cd | cd.1 != cd.2}
  = sum ab, J ab * ENNReal.ofReal (totalVariation (W ab.1) (W ab.2)).
```

Each PMF atom and `ofReal` factor is non-top; the finite weighted sum and event
therefore have non-top guards. Conversion to Real gives the corresponding sum
of `(J ab).toReal * totalVariation (W ab.1) (W ab.2)`. Equal input coordinates
give zero row discrepancy; other coordinates use TV at most one. Writing D for
Real disagreement, the resulting chain is

```text
TV(p.bind W, q.bind W) <= D(L) <= D(J) = TV(p,q).
```

C10's `totalVariation_bind_le` is applied to exactly those output laws. The
deterministic specialization uses `totalVariation_map_le`; equal inputs,
constant rows and subsingleton outputs give zero cases. These are private
producer/consumer checks, with no new expectation, cost or contraction API.

### Adjacent maximality does not survive this Markov gluing

Let u be fair Bool and d be `pure false`. The supplied adjacent laws are
`channelJoint u (fun _ => d)` and `channelJoint d (fun _ => u)`. Each has the
ordered marginals indicated by its arguments, TV `1/2` and disagreement `1/2`.
The universal coupling inequality compares each supplied law with every
competing coupling and certifies both adjacent maximalities.

The consumer calls the public gluing theorem once and identifies that witness
using its pair laws and Markov structure. Its atoms are

```text
T(a,false,c) = ENNReal.ofReal (1/4)
T(a,true,c)  = 0.
```

Its endpoint law is exactly `channelJoint u (fun _ => u)`, with ENNReal
disagreement `ENNReal.ofReal (1/2)` and Real disagreement `1/2`. Endpoint TV is
zero. The diagonal endpoint coupling has ENNReal and Real disagreement zero,
and both strict comparisons are proved. Every channel V with `V false = u`
gives the same extension T; `V true` is arbitrary. This proves failure of
maximality for this conditionally independent gluing. It does not assert that
all gluings of the adjacent pair laws have independent endpoints.

All numerical disagreement claims first establish the ENNReal event equality
and non-top guard. Real conversion also uses TV nonnegativity where needed;
no unguarded `toReal` injectivity or cancellation is used.

## Mathematical sources and adaptations

The [reference register](../references.md) records exact editions and hashes.
The registered local file identities were checked during planning and the
targeted C12.03 reread. No reference PDF or substantial source text is copied
into the repository.

- LP17, second edition (2017), Section 4.2: coupling definition and Example 4.6,
  printed pages 49--50 / PDF pages 65--66; Proposition 4.7, Remark 4.8 and
  equations (4.8)--(4.13), printed pages 50--52 / PDF pages 66--68.
  These supply coupling conventions, the fair-bit comparison, the universal
  inequality and attainment.
- PW24, August 16, 2024 draft, Section 7.3, Theorem 7.7(b), equation (7.20),
  printed page 122 / PDF page 147, with proof on printed page 123 / PDF
  page 148: coupling characterization of half-L1 total variation.

Transport, finite gluing, the weighted contraction consumer and the specified
fair/point-mass/fair regression are derived applications of existing PMF,
channel and Markov algebra. No separately numbered gluing or composition theorem
is attributed to these reference sections. C10 supplies TV normalization and
contraction; C11 supplies the coupling predicate, universal inequality and
actual maximal witness. Finite Set events are evaluated through
`PMF.toOuterMeasure`, without a new measurable-diagonal assumption. Canonical
nats are unchanged; C12 adds no entropy or logarithm conversion. No external
information-theory implementation was consulted or reused.

## Prior completion and review evidence

The following records are under `.lit-review/setup/`. All three completion
records say `SUPERVISED_STEP_COMPLETE`. All ten earlier-step criteria are
`SATISFIED`; the original reports have no findings. Each exact original report
and its assessments are retained and explicitly reconciled in the corresponding
`c12-0N-review-parent-reconciliation-20261003.json`. Those reports establish
their recorded step assessments, not a C12.04 verdict.

| Step | Completion record | Original report | Criteria |
| --- | --- | --- | --- |
| C12.01 | `c12-01-completion-20261003.json` | `c12-01-review-original-report-20261003.txt` | MATH, CONSUMER, BOUNDARY: satisfied |
| C12.02 | `c12-02-completion-20261003.json` | `c12-02-review-original-report-20261003.txt` | NULL, GLUING, ENDPOINT, BOUNDARY: satisfied |
| C12.03 | `c12-03-completion-20261003.json` | `c12-03-review-original-report-20261003.txt` | CONTRACTION, REGRESSION, API: satisfied |

These content-addressed references come from the actual completion records.
An accepted-report reference is not asserted to be the raw report-file hash.

| Step | Closure | Final source F | Accepted report |
| --- | --- | --- | --- |
| C12.01 | `e02ead2410aa3633d0a3baa575dc3c9fbee2dc3f991f659c451bbfb1a81e4265` | `e387434294954dd73a9617164c6bcccdf38e2ae9a99b43990a493a2a521eaa35` | `4ac01159d551b5a378c5ad7de655b2fef78118cd7743c1f1f8e8aa7360c3ca40` |
| C12.02 | `e54a76bcc47a23b94c6c126502ef43853349af76b14e20f658db43fbce4c39a8` | `94e7b16642e52807597be8a56123ec08f54e3a89c5828758608406f1d9b13816` | `48e1da9c2abc36243bb9176c20823e2283002e15fd10d6796b14328bdc8b2e9d` |
| C12.03 | `baa6ba14e2ce1cd9a353104abde88ba22ebfa8d93e0576aa6079dc652d317a06` | `0a1cea40c1c2e5f4b8a6d82050fe4a2a8451222b45ccbad0edde0480363fbadc` | `eafc1243681e8ca1cc718324b3a9aaac0fadd692bd4952c859a1bcf116d8c4d2` |

### Actual validation history and limits

C12.01 and C12.02 retain successful parent focused/static/trust records and
separate original reviewer checks and attributions. C12.03's parent records
include the following successful invocations on their recorded source:

| Record under `.lit-review/setup/` | Actual result |
| --- | --- |
| `c12-03-focused-20261003/result.json` | Twelve-target integrated focused check: exit 0, 62.735 seconds. |
| `c12-03-documentation-20261003/result.json` | Documentation gate: exit 0, 218.968 seconds; five README and four website-guide examples compiled. |
| `c12-03-trust-20261003/result.json` | Trust gate: exit 0, 1830.542 seconds; retained signatures, current environment/import/attribute checks and all-project allowed-axiom audit. |
| `c12-03-review-original-report-20261003.txt` | Reviewer reports its own twelve-target focused and static checks passing; the trust result is explicitly attributed to the parent. The focused run is incremental, not a claimed clean rebuild. |

The C12.03 trust record retains the 601 historical signatures, 34 supported
module probes, 642 current declarations, 94 simp declarations and 92 root
exports. Its all-project audit covers 55 local modules and 1746 local constants,
allowing only `propext`, `Classical.choice` and `Quot.sound`. These are attributed
results; this handoff does not claim an additional independent trust run.

Original helper failures and corrected successes remain distinct. In particular:

- C12.01's initial owner build stalled and was interrupted without a Lean proof
  diagnostic. Supplemental reviewer direct compilations were interrupted or
  timed out; they are not passing checks. Initial report-ingress schema failure
  and its explicit correction remain in the private history.
- C12.02 retains an isolated direct-file timeout and initial consumer proof/style
  failures. A parent display-wrapper encoding failure occurred after its child
  build succeeded; those two outcomes are recorded separately.
- C12.03's first transport build failed on an unqualified `measure_empty` and
  reported a deprecated membership spelling. Its corrected source subsequently
  compiled. The first gluing build failed on Bool sum order and a no-progress
  simplification and reported tactic/linter warnings; local corrections compiled.
  Original outputs and hashes are retained in
  `c12-03-negative-evidence-20261003.json` and the helper records.
- The gluing helper's `tmp/c12-03-gluing/focused-02.json` records exit 0 in
  18.369 seconds, empty stderr and a fresh consumer build on source hash
  `0d86dc2f737524215c77642328b2ab8b1e172a631d6daf7e4e4f1ca19a33fc53`.
  Its earlier failed `focused-01.json` remains preserved. Helper checks used
  UTF-8 output, explicitly closed stdin and a bounded timeout.

The historical focused command printed `lake -KwarningAsError=true build ...`.
C12.04 established that this was an ineffective Lake configuration flag for
warning enforcement and replaced 13 occurrences with `--wfail` across maintained
validator, compatibility/export/fixture and CI build commands and the associated
command assertion. Direct Lean `-DwarningAsError=true` invocations remain
unchanged. The transport research helper ran actual fresh and cached warning
fixtures, which failed as required, and a clean fixture, which passed. It also
ran eight passing validation-lifecycle tests and 14 passing compatibility tests.
The parent inspected those outputs and ran the separate eleven retained-export
tests below. This handoff does not claim an additional independent rerun.

The exit-zero outputs above are preserved as actual historical build results;
their old flag does not establish warning enforcement. The corrected focused
build passed with `--wfail`, as did static checks and the relevant regression
tests. Original outputs are not rewritten, and no historical failure is
relabeled as a success.

## Cumulative preparation and remaining qualification

The initial C12.04 static check rejected the changed Pages workflow fingerprint.
An explicit parent/helper release-safety inspection verified that the complete
workflow equals its prior source with only the warning flag changed. The manual
trigger, default-false publication input, guarded deployment, action pins and
separate current/frozen source and artifact checks are preserved. The expected
fingerprint was updated after that check. The original failure and inspection
are retained under `c12-04-static-20261003/` and
`c12-04-pages-safety-review-20261003.json`; final static validation and cumulative
review remain separate requirements.

Actual preparation evidence, retained under `.lit-review/setup/`:

| Record | Actual result |
| --- | --- |
| `c12-04-focused-20261003/result.json` | Corrected twelve-target `--wfail` build: exit 0, 3.674 seconds, incremental artifacts. |
| `c12-04-static-final-20261003/result.json` | Static/generated/site/pin/safety checks: exit 0, 11.357 seconds, after the reviewed Pages fingerprint correction. |
| `c12-04-retained-export-tests-20261003/result.json` | Eleven retained-export tests: exit 0, 14.188 seconds, including actual strict Lean serializer compilation. |
| `c12-04-api-docs-recovered-20261003/result.json` | Both actual file-mode build/semantic-check passes: exit 0, 720.151 seconds overall, unchanged source. |
| `c12-04-api-doc-inspection-20261003.json` | Parent inspected actual signatures, docstrings, attributes, owner and source links for all four new declarations; Gluing exposes exactly its one theorem. |

The API output contains 34 supported pages and 642 signature-bearing declarations,
92 export targets, 21 non-stable exclusions and zero equation rows. Its relevant
digest is `59323b37d80b1c4b2333f68c7e366fbc10bdb61a94964872020d07e3bddc44e7`; the complete output digest is
`29d48c42ee735c86d28d254b36e83bc05f3c06c93ee1c2ed6cb9c6e9956e3955`. Exact v2 configuration, source/dependency
identity, both real passes and output hashes are preserved in the inspection
record and `docbuild/.lake/build/api-doc-build-attestation.json`.

The first C12 API-doc attempt failed after 598.339 seconds: updated Gluing
`docInfo` was present, but aggregate HTML generation replayed an old marker and
the semantic checker rejected the missing Gluing page. Parent and helper
inspected the actual output and pinned generator. The recovery preserved then
invalidated exactly the Shannon aggregate marker and its hash/trace sidecars;
compiled modules, extracted database and source/configuration remained intact.
The original failure is `c12-04-api-docs-20261003/`; exact recovered marker bytes
are in `c12-04-doc-marker-recovery-20261003.json`. The successful rerun exercised
both maintained passes and the unchanged checker. Replayed Qq extraction
advisories concern dependency declarations; project declaration coverage passed.

Final preparation applicability compares original check inputs with the complete
candidate. Later documentation edits do not alter compiled inputs or the verified
API-doc identity; the focused check additionally predates only the exact reviewed
Pages fingerprint constant correction. The final static run and explicit source
comparisons are retained in the private precheckpoint records.

### Authorized checkpoint and initial complete routine suite

The approval captured in `c12-04-checkpoint-authority-20261003.json` covers the
exact 35 C12 files, necessary C12.04-only correction/final-record amendments and
a separate clean validation checkout. `c12-04-checkpoint-result-20261003.json`
records initial commit `44d300c97d86b1fc0f40e9c70eb33a16bbfe3abe` on `master`.
The original checkout retains only the unrelated `docs/next-website-tasks.md`
change; its bytes were preserved and the file was not staged, committed,
restored or hidden.

The parent used the separate detached checkout
`C:\Users\coban\Desktop\LeanInfoTheory-C12-validation-20261003` at that exact
commit. Its nine pinned dependencies and build caches were ordinary copies.
The recorded comparison covers all 203 tracked files and verifies all nine runtime dependency revisions and clean working trees in both checkouts. The only logical source difference is the excluded website notes. Four nonmathematical files differ only in CRLF/LF bytes: `docs/plans/post-release-chunk-09-notes.md`, `docs/v0.1-public-api.json`, `home_page/blueprint/dep_graph_document.html` and `home_page/blueprint/module_graph.json`. All mathematical source, tooling and configuration bytes match; the original working files were preserved.
The full `python -B scripts/validate_release.py` returned exit 0 in
1731.262 seconds, recorded in `.lit-review/setup/c12-04-full-checkpoint-20261003/result.json` with its
original output and source/checkpoint identity. The audit checked 601 retained signatures, all 34 supported import closures, 642 supported declarations, 94 reviewed simp declarations, 92 root exports and all 1,746 compiled local constants across 55 modules. The only reported axioms were `propext`, `Classical.choice` and `Quot.sound`.
This was a clean-checkout run with reused build caches, not a claim that every
dependency or project module compiled from scratch. The API-doc gate's two real
passes ran in the original checkout; its independent result and exact
source/configuration applicability are retained above.

C12.04 adds no new mathematics. Initial full-suite success does not qualify a
later amended candidate automatically. Finish the remaining owned documentation
before review and F; use the authorized amendment scope and rerun the full
routine suite after amendment. The remaining obligations are:

1. The complete maintained routine suite on the exact authorized clean candidate,
   plus applicable focused checks of the permanent consumers from their minimal
   imports. Any amendment requires the repeated routine suite and reassessment
   of invalidated evidence.
2. The real two-pass current `api-docs` gate with `DOCGEN_SRC=file` and the reviewed
   Zig 0.16.0 on Windows. Preserve the v2 source/configuration/output attestation
   and inspect the actual Gluing page and the new Coupling and FiniteChannel
   declarations. Old documentation output cannot certify changed source or
   docstrings. Inspect concrete output before any bounded cache repair.
3. Fresh assessment by the existing bound reviewer against all 13 plan criteria,
   after readiness is established. Preserve the native result and exact original
   report; explicitly reconcile every finding and assessment, correct and
   revalidate within authority, and obtain renewed satisfactory assessment of
   any criterion gaps.
4. Exact R-to-F applicability, all captured edits finished before F, final capture
   and the installed private closure process. A favorable review alone is not
   completion.

The existing C12 reviewer binding is retained. Cooperative read-only instructions
are not OS isolation or authenticated provenance. The current API output must
not be staged into `/docs/v0.1.0/`; no publication is authorized. Keep any
correction or final-record amendment within the approved 35-file scope, preserve
the original website-note bytes and retain strict clean-checkout hygiene.

## Remaining work, owners and triggers

| Work | Owner and concrete trigger |
| --- | --- |
| Public selected coupling composition | Coupling/API maintainer, only after a separately approved production consumer needs an operation with exact identity, associativity and reassociation contracts. Current consumers need only existential gluing. |
| Public uniqueness or endpoint projection convenience | Coupling/semantic API maintainer, after repeated independent consumers demonstrate friction that the current private identification and map composition cannot reasonably absorb. |
| Generalized gluing, measurable couplings or processes | A separately approved theorem phase, after representation and assumptions are specified. The current gluing contract requires only its final coordinate finite and makes no general process claim. C11's residual-law and optimization packaging also remain deferred until concrete consumers need them. |
| Posterior and null-fiber convenience wrappers | Semantic/channel maintainer, on repeated downstream demand under Future Work Notes 30 and 37. The extension support iff discharges only its specific null-fiber slice; neither whole note is closed by C12. |
| Endpoint error accumulation | A later approved coupling-consumer step needing composed error bounds. On a common alphabet, event inclusion and the union bound give endpoint disagreement at most the sum of the preserved pair disagreements. This needs no Markov assumption. Begin privately and guard Real conversions; it is not a missing C12 obligation. |
| Naming, aliases, simp policy and module splits | API/architecture maintainers, on actual repeated discovery, simplification or dependency pressure. Notes 14--18 and 26 remain standing observations; current consumers justify no alias or helper promotion. |
| Documentation and cache observations | Documentation maintainer under Note 9, at the current C12 API milestone or a reproduced cache failure. Broader curation or publication needs its own approved scope; historical C10/C11 cache failures do not authorize preemptive deletion. |
| C13 Pinsker and quantitative independence | Its future implementation owner after its own approved plan and explicit step request. Prerequisites are C10 TV and existing KL/DPI, including singular/infinite ENNReal cases and nats. C12 is not a required mathematical prerequisite. |
| C14 information continuity | Its future implementation owner after its own approved plan and request. Reuse C10--C11, Fano and entropy algebra; distinguish exact-distance bounds from monotone upper-distance moduli, handle singleton thresholds, and avoid pointwise continuity claims on null conditionals. C12 is not a required prerequisite. |
| C15 and later programme | Their future owners after separate approval and requests, following the [C9--C24 map](../plans/post-release-chunk-map.md). No later work or reviewer transfer follows automatically from C12 completion. |

The [implementation notes](../plans/post-release-chunk-12-notes.md) record private
proof choices without changing the approved contracts. The living summary,
reference register, chunk-map status and current API documentation must agree
with this handoff and the actual C12.04 evidence before cumulative readiness is
asserted. C11's captured historical handoff remains unchanged.
