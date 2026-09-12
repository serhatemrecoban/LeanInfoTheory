# Chunk 9 maintained handoff

**Status, 2026-09-12:** C9.01--C9.06 are durably closed. C9.07 is open for
cumulative closeout preparation under the [approved revision-2 plan](../plans/post-release-chunk-09.md).
The clean checkpoint requires separate lead authorization. The complete routine
suite, fresh cumulative fixtures, current two-pass file-mode API documentation,
fresh full-chunk independent review and final private closure remain pending.
This maintained document records readiness and evidence locations; only the actual
private completion record establishes closure. Preparing it does not start C10.

## Delivered surface

Exactly two supported theorems were added. Both use the canonical
`LeanInfoTheory.Shannon` namespace, existing owners and imports, with no new simp
attribute or facade alias. The source type is arbitrary in both contracts.

| Contract | Declaration and focused import | Interface and permanent consumers |
| --- | --- | --- |
| C9-MATH-01 / C9-CONSUMER-01 | `isIndependentOf_comp_right`; `LeanInfoTheory.Shannon.SemanticBridge.Independence` | `IsIndependentOf p X Y` implies `IsIndependentOf p X (fun w => f (Y w))` for arbitrary types and map. No finiteness, measurability or injectivity premises. Private `Examples.IndependenceProcessing` consumers exercise arbitrary products, non-injective Nat halving, singleton image, left processing by existing symmetry and finite zero MI. |
| C9-MATH-02 / C9-CONSUMER-02 | `mutualInfoOf_condEntropyOf_decomposition`; `LeanInfoTheory.Shannon.InfoMeasures` | `I(Y;Z) = H(Y|X) - I(X;Z|Y) - H(Y|(X,Z)) + I(X;Z)` in nats, with exactly three observed-alphabet `Fintype` instances and ordered pair `(X,Z)`. Private `Examples.InformationDecomposition` consumers exercise the general identity, two-zero specialization, singleton auxiliary alphabet and sparse Boolean triple law. |

The decomposition is canonically visible through the existing lightweight root
owner, without a new `LeanInfoTheory.*` export alias. Independence remains opt-in.
Only the non-stable Examples aggregate imports the two new consumer modules;
neither supported umbrella imports examples. The root still directly imports
`Probability.Finite` and `InformationMeasures` and reaches exactly five local modules.

Proofs reuse existing PMF map/bind laws and elementary MI/CMI/conditional-entropy
identities respectively. The first transports an independent product law through
`(a,b) -> (a,f b)`; the second expands existing algebraic forms and reconciles pair
and triple orientation. No new conditional-law definition or application structure
is introduced. Note 14 retains the selected searchable names and declines aliases;
Note 25 discharges only deterministic right-processing. The zero-term consumer
assumes `I(X;Z)=0` and `H(Y|(X,Z))=0`; it proves the resulting generic algebraic
formula, not an application-specific Markov/perfectness equivalence.

The [reference register](../references.md#ct91-cover-and-thomas) identifies exact
CT91 edition/hash. Sections 2.4/2.5 supply the MI/chain-rule derivation context;
Section 2.8 supplies finite data-processing context. The general PMF law extends
beyond that finite presentation. Bits-to-nats conversion is consistent across
all homogeneous terms. The decomposition is a derived identity, not a separately
numbered textbook theorem. No external implementation was copied. The
[downstream feedback entries](../downstream-api-feedback.md#current-register)
retain bounded prior PFR intake; no fresh downstream access, consumed-commit
identity, integration or adoption is claimed.

## Current and historical identities

| Surface | Released v0.1.0 | Current C9 source |
| --- | ---: | ---: |
| Supported owners / documented declarations | 31 / 601 | 31 / 603 |
| Reviewed simp / facade aliases | 94 / 92 | 94 / 92 |
| Local modules / non-stable anchors | 44 / 13 | 46 / 15 |
| Local import edges / root-reachable modules | 90 / 5 | 94 / 5 |
| Source-index declarations / documented | 716 / 715 | 718 / 717 |

The additional source-index instance is example-only. The 603 supported entries
comprise 537 theorems, 56 definitions, 9 abbreviations and 1 instance. Counts are
inventory observations, not approval quotas or claims of new theorem-family breadth.
C9.06's actual compiled audit covered 1,400 local constants across 46 modules;
that is dated native evidence, distinct from both inventories and the pending
C9.07 cumulative rerun.

- Historical release: `0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`.
- Intake/pre-checkpoint HEAD: `80ea016c7ac64bb5bd79b2f769227a3fb2ccc3b3`.
  Its dirty diff includes pre-existing planning/workflow work and multiple C9
  steps; it is not the C9.07 baseline or proof of a clean candidate.
- Approved normative plan SHA-256:
  `50ca17fdeace90726327924f0d31d08dacd752fc0da94784482ca1dbdf3870bf`.
  Original presented full-file SHA-256:
  `b9914d8569de54baff0296ba6a40539f628dd841cee53c9dd3ed9c4302276bec`.
- Lean `v4.33.1`, revision `819816b2e0a3bf405af45ae5c7af2491d8f5bee6`;
  mathlib `0df444a360eaa60ab8c11dca51a86af692955474`;
  doc-gen4 `e2af49a7b7e5e1a9224008c1f15e7aa4f58a4015`.
- Frozen manifest SHA-256:
  `d4c5bfa78588de605798f568b312a4cef2896855e36d3c983849270181e397be`.
- Retained structural artifact SHA-256:
  `b4beab492f4b782613dd89b157855a6ca59636a8f35b7f4fa97c15d27653d5ed`.
- Current manifest SHA-256:
  `360c3c81f2f3ed4b6f76eb654a487736e9e788d801291fdef92c0dfc1c012c37`.
- Reviewed current import/attribute policy SHA-256:
  `6d72003e0aea4d90505b14befae277e7a2dec92ed99e4567ade376b02963386e`.

Canonical source files are ordinary captured inputs. The exact checkpoint,
cumulative R, final F, report reconciliation and closure identities must be read
from the installed private records when they actually exist, not predicted from
this file's content. Do not edit captured files after F to insert its own hash.

## Growth contracts and cumulative traceability

The [compatibility guide](../compatibility/README.md) owns operating detail;
the [C9.04 qualification](../compatibility/c9-04-qualification.md) maps every
Section 3.5 fixture to its actual implementation and evidence boundary.

| Obligation | Delivered mechanism / earlier outcome | Required C9.07 evidence |
| --- | --- | --- |
| C9-GROW-01 | Separate generated current inventory; old generator is a non-mutating historical verifier; frozen route safeguards retained. | Frozen/current checks, unchanged pins/route inputs and complete preservation/staging regressions. |
| C9-GROW-02 | Exact-release structural exporter and all-601 retained comparison against a freshly built current environment, protecting universe parameters, binders, assumptions and results. | Fresh release reproduction, routine compatibility plus complete retained fixtures, including stale compiled input, assumption and binder changes. |
| C9-GROW-03 | Separate reviewed import/attribute policy, historical focused imports and exact root/alias boundaries. Generation grants no approval. | Routine compiled boundaries, approved/unapproved real opt-in pair, attribute/import/alias/non-stable regressions. |
| C9-GROW-04 | Exact current source/environment/owner coverage and allowed-axiom audit of every project compiled constant, including private/examples. | Complete routine audit and growth positives with full trust/direct consumers; explicit unindexed/undocumented/unclassified negatives. |
| C9-GROW-05 | Exact current doc coverage, content-bound v2 configuration/attestation and pre-copy current-as-frozen refusal. | Actual two-pass current file-mode doc-gen, both new signatures, all current pages, source/config/dependency identity and complete HTML/staleness/staging regressions. |
| C9-GROW-06 | Real retained and growth source-copy runners; C9.04 passed all 17 retained and 4 growth outcomes plus complementary component cases. | Fresh complete runners and component matrix, original negative diagnostics and fixture/production restoration evidence. |
| C9-MATH-01/02; C9-CONSUMER-01/02 | Both exact approved helpers and focused private consumers passed C9.05/C9.06 build, API/import/trust and independent review. | Cumulative source/type/meaning review, applicable earlier originals, current routine consumers and actual new doc-gen signatures. |
| C9.07-R1/R2/R3 | Earlier closures exist; canonical reconciliation and this handoff are prepared. | All current evidence above, no unresolved material concern, authorized clean candidate, fresh full-chunk review and final evidence/dispositions. Still pending. |

Structural equality does not certify unchanged definition bodies, the meaning of
referenced constants, notation or mathematical intent. Strict fingerprints may
reject harmless elaboration drift; they do not authorize accepting it. The
same-type body fixture deliberately demonstrates this limit and an existing Units
consumer detects its changed meaning. Documentation fingerprints detect changed
source inputs even when names/counts are unchanged; hashes do not prove semantics.
Synthetic HTML and mocked lifecycle/classification checks remain explicitly
separate from real Lean builds and actual doc-gen. Cooperative snapshots and
read-only instructions are not OS isolation or authenticated origin guarantees.

## Validation and review procedure

Finish source/docs, component validation, retained self-review and separate
reassessment first. Obtain the lead's explicit clean-checkpoint authority, then
run this complete schedule from the Desktop checkout. Serialize all commands
that produce Lean/Lake artifacts. Save actual streams, command, actor, duration,
exit status, source/configuration/dependency identities and limitations privately.

```text
python -B scripts/validate_release.py
python -B scripts/compatibility/export_retained_api.py --baseline-source tmp/c9-01-release-20260911 --check
python -B scripts/compatibility/test_retained_export.py
python -B scripts/test_current_public_api.py
python -B scripts/compatibility/test_public_api_compatibility.py
python -B scripts/compatibility/test_current_policy.py
python -B scripts/test_validation_growth.py
python -B scripts/test_api_docs.py
python -B scripts/compatibility/test_growth_fixtures.py
python -B scripts/test_check_website.py
python -B scripts/compatibility/run_compatibility_fixtures.py
python -B scripts/compatibility/run_growth_fixtures.py
python -B scripts/validate_release.py api-docs
```

The actual compatibility-test path above corrects the original plan's illustrative
shorthand without changing its frozen requirements. The default routine suite
already runs the maintained build, five README consumers, standalone compatibility,
current trust/import/attribute/root checks and clean hygiene. Its target list is
owned by `python -B scripts/validate_release.py targets`; avoid duplicating full
production builds without an input change or unresolved concern. A dirty component
pass never substitutes for the complete clean suite. Revalidate after amendment.

Run fixture mutations only in new ignored `tmp/` source copies, with their own
project build outputs. Set TEMP/TMP/TMPDIR to an owned directory and remove inherited
LEAN_PATH. Sharing clean pinned dependency caches does not establish source-copy
isolation by itself. Preserve negative results with the expected specific reason;
compare every copied input after restoration and production inputs before/after.
The growth runner receives unchanged full trust from production validation; its
restored source runs static/compatibility, not a second full all-project audit.

For API docs set `DOCGEN_SRC=file`, keep `DISABLE_EQUATIONS=1`, and set
`LEANINFOTHEORY_ZIG` to the verified official Windows Zig 0.16.0 executable
(SHA-256 `086ce9d47ba42f33a514e1a6e04eb1d4a8fa1d75e0868e0213caad447c91e864`).
The executable path must be located and verified at execution; it is not currently
supplied by this task's environment. The old v1 config/attestation is historical.
Inspect newly generated output directly under `docbuild/.lake/build/doc`; do not
stage it as `/docs/v0.1.0/`. Current source/config/dependencies must match both
passes and the resulting v2 attestation. See the [API-doc instructions](../api-documentation.md)
for the exact input fingerprint and source-mode boundary. Local output is unpublished.

Only after readiness evidence exists, prepare cumulative R and the full neutral
request using the installed [protocol](../review-protocol.md) and
[operations](../review-operations.md). Persist dispatch intent **before** the actual
native send. Preserve an empty receipt as uncertain without blind resend; obtain
the actual bound completion, preserve originals and explicitly reconcile even a
clean report. Corrections require supported owned edits, reassessment and fresh
applicable checks. Re-review material changes or reviewer gaps. Renew stale finding
dispositions against final source where required. Complete canonical/handoff edits
before final validation, `finalize_documents`, F and `project_closure()`.

## Source and review record ledger

The actual parent is `01a090e5-167c-7181-8201-e0647c4c5e25`; the persistent
reviewer is `/root/c9_reviewer`. Requested settings were gpt-6-astra / ultra /
`fork_context=false`, expressed by the exposed creation call as `fork_turns="none"`.
The native creation result exposed the canonical task name; effective model,
effort and history-copy settings remain **UNREPORTED**. Support inspectors are
not the formal reviewer. General Assistant advice and planning self-review do not
constitute installed plan review; formal plan review has not occurred.

The following are actual prior closure references, not C9.07 acceptance. Private
record basenames are below `.lit-review/setup/`; content-addressed references resolve
through the installed C9 execution store. Dated [step notes](../plans/post-release-chunk-09-notes.md)
retain original commands, failures and source/review limits.

| Step | Private completion file | Exact closure |
| --- | --- | --- |
| C9.01 | `c9-01-completion-20260911.json` | `bc046d53daef0394083815995ba0d4bb39fac0a3fbb27de60b4df7af720a35c5` |
| C9.02 | `c9-02-completion-20260912.json` | `dbcd6e9e69f37a24ec28232bfad28cecee4296ae1024f0bb28ada5f994a41730` |
| C9.03 | `c9-03-completion-20260912.json` | `8c5813a6d39faa5419a45c1ffe00f11220a77394eadaca7738d055dc2f178b5e` |
| C9.04 | `c9-04-completion-20260912.json` | `814390aea8408ec16cf050bd692d9e68ae480d5140fca1f87b79e9f09a3c076a` |
| C9.05 | `c9-05-completion-20260912.json` | `502e426a14dff8c25557b3a55fdd06ab427e675e552d3e9b048b7967a5bdff85` |
| C9.06 | `c9-06-20260912-completion.json` | `82a1b5a429693718c24f2863d7d077c5010d9403e5836e5a30c61d307be16263` |

C9.06 final source is
`f30aff1842d2b3b3fc95aca37eda1e2a5e4484b26694371ed7a7ef482c4fd559`;
reviewed R is `c173341b6f8c77518d333e679d036f4ef25b080aa7a0c4c959f0f164c9e25913`;
original report SHA-256 is
`b53cc6b0c60463c346498c2a80c7132985292b30c0709b4227d98b864746f684`;
accepted capture is `09bcdb29eae54dd453cc545ed261ca53fe747754015aa0ea158e154f257b0d84`;
explicit reconciliation is
`4cc831712875d2743142e19ac4b75bc213482987c67079cecffbd8421ab12ec7`.
All three original criteria were satisfied. Original findings
`lit-finding:c906-dispatch-order` and `lit-finding:c906-reviewer-write-boundary`
remain accepted nonmaterial findings. Final-source RESOLVED dispositions record
completed disclosure, retained failures, bounded source-impact checks and corrected
isolated evidence. They do not repair historical noncompliance: intent was late,
and four maintained generated files were rewritten with identical bytes. Initial
timestamp preservation was not established. A corrected reviewer probe must redirect
every concrete HTML_OUTPUT/JSON_OUTPUT path, not just a shared directory constant.

The C9.07 entry records are `c9-07-inspect-20260912.json`,
`c9-07-api-20260912.json`, `c9-07-conditional-precheck-20260912.json`,
`c9-07-conditional-request-20260912.json` and
`c9-07-conditional-disposition-20260912.json`. The precheck verified exact
predecessor-source equality, same binding, approved normative plan and step order.
Fresh cumulative results and the eventual R/F/closure will be retained separately;
their absence cannot be filled by this handoff or an earlier favorable report.

## Remaining work and C10

| Item | Disposition | Owner and trigger | Next-chunk implication |
| --- | --- | --- | --- |
| C9.07 clean checkpoint and all readiness gates | Required and pending; prepare a concrete reviewed source/document candidate first. | Lead authorizes checkpoint; C9 parent runs complete routine suite, full fixtures and real docs. | C9 closeout prerequisite remains unsatisfied until actual results and closure. |
| Fresh cumulative review, corrections, final criteria/F/closure | Required and pending; preserve every original and reassessment, including negatives. | Actual C9 parent and bound reviewer after readiness evidence exists. | Earlier step reviews cannot substitute; no C10 transition. |
| Native bootstrap schema mismatch | Supported collaboration binding is now in use; original refusal and creation evidence remain historical. | C9 parent retains binding; use supported recovery if runtime/binding becomes unavailable. | Each later actual chunk creates its own reviewer; C9 reviewer is not transferred. |
| Note 9: broader docs/publication/blueprint/equations/status tooling | Current inventory and source-identity checks delivered; local final docs pending; broader work deferred. | Documentation maintainer, on separately approved publication or demonstrated documentation need. | Local readiness does not publish a current route or imply a new release. |
| Note 14: names and aliases | Both selected names retained; no rename/symmetric/short alias added. | API maintainer, on concrete recurring discovery or consumer friction in feedback register. | C10 follows naming/reuse discipline, without a quota or migration. |
| Notes 15--16: simp and chain rules | Reviewed 94-member set retained; new helpers and chain-rule orientation remain explicit. | API/theorem maintainer, on demonstrated terminating reduction in permanent consumers. | Standing policy remains open; no automatic entropy expansion. |
| Notes 17--18: validation and module boundaries | Earlier steps validated; cumulative gates pending; existing owners and lightweight root preserved. | Chunk parent at each milestone; architecture maintainer and lead for an import exception. | C10 needs its own validation contract and focused PMF boundary. |
| Note 25: further independence conveniences | Selected right-processing slice delivered; atom-level, constant/self and additional public orientations deferred. | API maintainer, on repeated independent consumer need. | These optional variants do not enlarge C10's prerequisites. |
| Signature/semantic blind spot | Permanent disclosed limitation, with source/API review and consumers. | Every implementation parent/reviewer whenever definitions or their dependencies change. | Matching types/counts never establish intended meaning. |
| Broader Future Work Notes | Preserve existing ownership, category and trigger in living summary/project log. | Relevant future chunk or maintainer after its own approval. | No broad closure, renumbering or unrequested theorem family. |
| PFR/ShannonCert integration | Remains downstream; no new access or adoption evidence. | Downstream owner at its own integration/version decision. | No downstream edit or pin change implied. |
| C10 finite TV and later programme | Proposed, unselected. Re-read exact registered sources and current pinned PMF/channel APIs. | Lead selects its actual parent, exact detailed plan and step; that parent binds its own reviewer. | Settle TV convention, finite assumptions, ownership and reuse at C10 intake; later map contracts remain unchanged. |

Resume C9.07 in this same task and Desktop checkout. First inspect actual workflow
state and current source, then continue only its pending authorized work. Preserve
the original `.lit-review/` records across compaction and checkpointing. A request
for another step does not supply checkpoint authority or close C9 automatically.
