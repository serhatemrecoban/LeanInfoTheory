# C40 — Programme integration and third-release candidate qualification

<!-- lit-review-status:start -->
**Plan status:** Approved revision 2. On 24 November 2026 the lead directed the successor Chunk 40 chat to use this revision and requested C40.01 with review. The approved proposal has SHA-256 `9665bee8f74243ab37db0085ad6fb066243e68ef8f12385026b815be70d12131`. The independent plan review covered all 19 criteria of revision 1. Revision 2 incorporates the two sets of advisory suggestions. The separate **LeanInfoTheory Third Release** thread owns release decisions.
<!-- lit-review-status:end -->

C40 completed on 25 November 2026. The cumulative review covered all 19 criteria. The handoff distinguishes results on the C40 candidate, the four historical clean-checkpoint obligations and the subsequent tagged release. [C40 handoff](../handoffs/chunk-40.md)

## Intake and source of authority

C40 will qualify one identifiable, local, clean candidate containing the six mathematical packages. The [programme map](release-3-chunk-map.md#c40-programme-integration-and-release-qualification) supplies context. The approved C25–C39 plans and actual declarations supply the contracts. The [C39 handoff](../handoffs/chunk-39.md) links the six endpoint handoffs. C40 integrates existing theorems. A missing required result is a finding for the lead, never an alias, assumed lemma, or silent reduction in scope.

The original C39.06 `completion.json` in `.lit-review/setup/c39-06-20261124/` records `SUPERVISED_STEP_COMPLETE`, all 18 cumulative criteria, and no next step. Its closure is `d3ddf84699ffbaa2d237039be1e55a79691b2f7271983238448894e60885c7de` and its final reviewed/corrected source F is `7e4c322f411099529a5ca4326432b874e17c40562cecdf3d1023bb83a39b0aa5`. Original report `0b343eaa003ec7bdbca0cdc38b0d51728539ed4f2822cbbf9b0f0fb9a87b5ae5` and reconciliation `688ad740d6a70cbc4a38feccf78e10367e3ffd5c18d6f0f225b9c9e7e53084c6` belong to C39. The cumulative index `.lake/compatibility/c39-06-validation-20261124/index.json` has SHA-256 `c825ad070ec713e7dd727f2ff18a934c3977ebbc7dacde709ada3cd470069820`. Its 918 declarations, 77 supported modules, 94 reviewed simp names, two root imports, five root-reachable modules and 92 root exports are comparison data. Aggregate counts alone cannot certify a theorem, approval, or build. C39's full trust audit covered 5,173 local constants in 149 modules on that source.

Initial inspection found a dirty primary at `2eb80d0e746688511618aaefc2624ffa4ae88f6e`. Two presentation commits followed. Commit `412663f88c55fcf3a07e9fad912ad1bfdc00b554` touched `README.md`, `CONTRIBUTING.md` and `home_page/index.html`. Commit `85ca68878c96fab7f3f11103147e7a44e0c33504`, the planning base observed for revision 2, updated acknowledgments in the README and homepage. C40 inherits these changes. Refresh HEAD and the actual diff when proposing the candidate. The Release 3 mathematics requires its own exact clean commit.

## Six mathematical packages

Paths in this table are focused imports following `LeanInfoTheory.`. `Examples.*` names permanent in-tree consumers. The linked handoffs give the original evidence, and the appendix reproduces representative exact source signatures for every package. Each receipt prefix below identifies the historical scope, independently of future C40 checks. The textbook abbreviations CT91 (Cover–Thomas) and PW24 (Polyanskiy–Wu) refer to the [registered editions](../references.md#release-3-planning-locators).

| Package and supported import | Delivered contract and source adaptation | Permanent consumer, historical evidence and limit |
| --- | --- | --- |
| **1. Finite testing** · `Probability.BinaryTesting` and `Probability.NeymanPearson` | Reject with probability `f x`. `PMF.BinaryTest.isLeast_errorSum` attains `1−TV`, and `isLeast_equalPriorError` attains half that value. `exists_likelihoodThresholdTest` chooses one nonnegative threshold and common tie randomization for each pair of finite laws and level in [0,1]. That test has exactly the requested size and dominates every competitor of at most that size. PW24 §§14.1–2, 14.4 Thm 14.11 uses the complementary decision and reciprocal ratio. The finite mass comparison also handles zero threshold and singular atoms. | `Examples.BinaryTesting` and `Examples.NeymanPearson`. At size 1/4 randomization gives power 3/8 and miss 5/8. A disjoint alternative gives power one at size zero. Preserve endpoint levels and common-null indifference. Simple finite hypotheses only. [C26.06, `963c196f79dd`](../handoffs/chunk-26.md) |
| **2. Information density and one-shot coding** · `Shannon.InformationDensity`, `IidInformationDensity`, `RandomCodebook` and `ChannelCodingOneShot` under `Shannon` | The joint mean of supported information density is MI. Globally test `exp(t)Q < J` with true law `J` and independent law `Q`. Under iid input, the true miss at threshold `n s` tends to zero for `s<I`. For each arbitrary input-word law, n, positive M, W and t, `exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold` exhibits a deterministic supported book and its total decoder at those exact n and M. Its released uniform error is at most `J(Eᶜ)+(M−1)exp(−t)`. The acceptance-event form keeps `Q(E)`. PW24 §§18.1–3, Thms 18.5–6 and §19.2, CT91 §8.6. The decoder uses a first match and fallback. | `Examples.InformationDensity`, `IidInformationDensity`, `RandomCodebook` and `ChannelCodingOneShot{Binary,Ternary,Sparse,Finite}` under `Examples`. Ternary event bound 11/32 vs exponential bound 2/5. Competitor law holds after randomizing the book, including collisions. A log threshold is equivalent to the global event only on joint support. [C30.06, `3548adaefc79`](../handoffs/chunk-30.md) |
| **3. Operational capacity and expurgation** · `Shannon.OperationalCapacity`, `Shannon.ChannelCodeExpurgation`, `Shannon.OperationalExpurgation` | `isLUB_isAchievableRate` identifies information capacity as the least upper bound. One positive-budget family for all n precedes all positive rate tolerances. Zero is achievable even at zero capacity. `BlockChannelCode.exists_expurgated_restrictions` retains the full weak-threshold good set, then for each fitting positive K chooses one code good for **all** priors. The lengthwise result gives vanishing maximal error and loss at most log(2)/n for the full retained family. CT91 §§8.5, 8.7 (8.81) and PW24 §§19.1–2, expressed in nats with a total decoder. | `Examples.OperationalCapacity`, `ChannelCodeExpurgation` and `OperationalExpurgation` under `Examples`. Half-erasure channel and zero capacity, collision with uniform error 1/4 and point-mass prior error 1. Rate guarantee for the full good set need not hold for every smaller restriction. Capacity equality as a supremum does not exhibit an operational capacity-achieving family. [C31](../handoffs/chunk-31.md) · [C32.06, `9f5f840e2d1f`](../handoffs/chunk-32.md) |
| **4. Lossless separation** · `Shannon.SourceChannelCode`, `Shannon.SourceChannelSeparation` and `Shannon.SourceChannelConverse` | `sourceChannelErrorProbability_comp_le` uses a channel prior equal to the pushforward of the iid source by the encoder. Under H<C a single pair of total families E,D gives vanishing error at one channel use per source symbol. For **every** joint E,D the finite Fano bound implies that vanishing of the very same error forces H≤C. CT91 §8.13 Thm 8.13.1 and PW24 §19.7 Thm 19.22 specialize to finite iid, lossless, equal-length DMC coding. | `Examples.SourceChannelCode`, `SourceChannelSeparation`, `SourceChannelConverse` and `SourceChannelSeparationPackage` under `Examples`. Repeated-symbol encoded inputs can be correlated. A compressed source can concentrate on the channel code's worst message. Strict direct / weak converse only. [C33](../handoffs/chunk-33.md) · [C34.04, `de4f50736d95`](../handoffs/chunk-34.md) |
| **5. Binary prefix lengths** · `Shannon.PrefixCode`, `Shannon.PrefixCodeLength` and `Shannon.PrefixCodeLengthIid` | Both directions of Kraft hold on indexed symbols. On the actual support, `exists_isBinaryPrefixCode_length_eq_ceil` gives one rounded encoder and its strict upper bound. `isLeast_optimalPrefixLength` gives an attained minimum against every competitor. `optimalPrefixLength_iid_div_bounds` gives H in bits ≤ optimum per symbol < H in bits + 1/n for n>0; attainment uses the whole-block support. CT91 §§5.2–4 and PW24 §§10.1, 10.3, with an explicit nats-to-bits conversion and strict rounding bound. | `Examples.PrefixCode` and `Examples.PrefixCodeLength`. A biased binary source has rounded mean 5/4 and optimum 1. A two-symbol construction proves an upper bound 27/32 per symbol. A point mass permits the empty word with known symbol count. No Huffman or universal-code algorithm. [C36.06, `4fc4ee595fde`](../handoffs/chunk-36.md) |
| **6. Method of types** · `Shannon.WordType`, `Shannon.EmpiricalPMF`, `Shannon.TypeClassCardinality`, `Shannon.TypeClassBounds` and `Shannon.TypeClassProbability` | C37 realizes the count indices and a single class. C38 proves its exact multinomial cardinality, both entropy bounds and own-law probabilities. At positive length with empirical q and prior p, inclusion of actual supports gives finite canonical D(q‖p), member-word mass exp(−n(H(q)+D)), class mass equal to that times its cardinality, and bounds exp(−nD)/(n+1)^∣A∣ and exp(−nD). Failed inclusion gives actual ENNReal class probability zero and canonical KL top. CT91 §§2.3 and 12.1, Thms 12.1.2–4, in nats and with the ambient alphabet exponent. | `Examples.WordType`, `Examples.TypeClass`, `Examples.TypeClassProbability` and `Examples.TypeClassProbabilityInterface`. Fair (2,1) gives 1/8 per word and 3/8 per class; biased gives 9/64 and 27/64. Singular gives zero and top. Sparse finite KL gives log 2, mass 1/4 and lower bound 1/108. Combinatorics allows n=0; empirical laws require positive length. The zero-event iff top result is a composed private caller, not a sixth public C39 theorem. [C37](../handoffs/chunk-37.md) · [C38](../handoffs/chunk-38.md) · [C39.06, `d3ddf84699ff`](../handoffs/chunk-39.md) |

## Numbered execution plan and acceptance criteria

Each bold criterion is independently assessable. Start a step only after exact plan approval, an explicit selection, and verification of predecessor closure and source applicability. Complete the selected step and its independent review, then stop. Use the [protocol](../review-protocol.md) and [operations](../review-operations.md) throughout. If implementation reveals a better proof, caller or validation method, use it within the approved step and record the reason, evidence and effect on later steps in the notes. Bring changes to mathematical meaning, required scope, public contracts, acceptance policy or pins to the lead. All C40 qualification checks below are prospective.

### C40.01 — Build the six-package coverage ledger

- **C40.01-CONTRACTS** — Map each approved endpoint, including its component results, to its actual qualified Lean name, full elaborated type, binder order/universes/instances, focused import, source passage and adaptation, permanent caller, and explicit limits. Capture the actual declaration exports and compile representative public callers. Compare to both original release controls. Classify new mathematics, reused results, representations, aliases, examples and tooling separately.
- **C40.01-PROVENANCE** — Verify the C39.06 receipt and establish current applicability of endpoint handoffs, examples and historical receipts against source bytes, reviewed policy, Git state, toolchain, dependency revisions and original logs. Carry failures and later corrections in chronological order, including C38's generated iid-equation ownership correction. For every gap, identify what evidence would resolve it, its owner, and whether it blocks candidate qualification.

### C40.02 — Qualify finite testing on its own

- **C40.02-TESTS** — Independently compile an import-isolated caller of `LeanInfoTheory.Probability.NeymanPearson` with warnings as errors. Use the supported TV and threshold theorems to attain both TV optima and construct the prescribed-level test, extracting its exact size and the universal comparison. Inspect the project import closure for coding/Shannon/Examples dependencies. Archive caller, exact imports/types, command and output.
- **C40.02-LEVELS** — Check levels 0 and 1, randomization on a shared tie, and null-only, alternative-only and common-null atoms. Reproduce the randomized (1/4,3/8,5/8) and singular (0,1,0) size/power/miss examples from their laws. Test which decision is rejection. The deterministic coding decoder has its own qualification route.

### C40.03 — Trace one coding experiment through separation

- **C40.03-ONESHOT** — Compile interface callers for supported information density, strict threshold and closed miss, iid concentration, sent/competing pair projections from the sampled book, and supported deterministic selection. Use the actual `BlockChannelCode.errorProbability` at W. Exercise an off-support pair of positive Q mass at a negative threshold, a tie, a duplicate-word book, M=1 and one nontrivial finite numerical bound. Record which equalities require joint support or averaging.
- **C40.03-RATE** — Given `0 ≤ R < channelCapacity W`, fix one input law p and slope s with `0 ≤ R < s < I(p;W)`. Specialize `q=PMF.iid p n`, `K=PMF.memorylessChannel W n`, `M=roundedMessageSize n R` and `t=n*s`. Identify the one-shot miss with the concentration theorem's miss, show the competing term vanishes, and exhibit one positive-budget family for all lengths before quantifying over positive rate tolerances. Separately apply `isAchievableRate_zero W` on a nonempty input alphabet: the one-message family has zero error and rate at every length, including when capacity is zero. Pair both cases with the weak converse and the least-upper-bound statement. Qualify the full expurgated family and, for each fitting positive K, a restriction chosen before the message prior. Check rounding and the log(2)/n rate loss on the family to which they apply.
- **C40.03-SEPARATION** — Exercise the finite composition inequality with the induced message prior, the eventually fitting source/channel budgets with total choices at earlier lengths, and the direct and converse families in the two focused owners. Verify the converse uses arbitrary E,D on the same joint sampling/error law, including correlated channel inputs, and inspect the finite Fano inequality at n=0. Use the permanent concentrated-prior example to expose an invalid replacement by uniform error. Preserve each interface witness and archive the C40.02 and C40.03 caller files, hashes, direct imports, commands and warning flags for replay in C40.05.

### C40.04 — Prepare the external Lake project and checkpoint proposal

- **C40.04-PREFIX** — Extend the existing [external fixture](../../tests/external-consumer/run.py) with an independently compiled module importing only `LeanInfoTheory.Shannon.PrefixCodeLengthIid`. Construct the rounded witness and the independently attained optimum, use leastness against an arbitrary supported competitor and specialize block leastness/the iid interval at positive n. Check the distinction on the biased or another independently computed witness. Use no private examples or declarations copied from them.
- **C40.04-TYPES** — Add a separate module importing only `LeanInfoTheory.Shannon.TypeClassProbability`. Enter via raw counts summing to n and via an independently given law with exact denominator-n witnesses using `wordTypeEquivPMF hn`. Work on the original class. Obtain the per-word formula, cardinality multiplier and both bounds for the same prior/event. Use `klDiv_pmf_ne_top_iff_support_subset` before the real divergence calculation. Independently assemble the actual zero-event / canonical-top equivalence by cases, using `klDiv_pmf_eq_top_iff_not_support_subset` and positivity of the finite lower bound. Compile a finite sparse and a singular specialization. The zero-event theorem itself has no measurable-space assumptions.
- **C40.04-FREEZE** — Compile each proposed caller locally and independently with warnings as errors. Read its actual Lean import header and require exactly its named focused owner as the sole project import. Compare it with the runner's module list and preserve the seven existing caller roots. Exercise the [runner isolation tests](../../tests/external-consumer/test_run.py), including rejection of an incorrect pin and an `.olean` from another checkout. Record these as local preflight. The end-to-end runner needs committed fixtures and a clean checkout.

  Before the expensive builds, refresh the base and propose the exact inclusion/exclusion manifest, source and fixture hashes, configuration and pins, intended isolated checkout/ref, and protection of the primary index. For **each** C36–C39 row below, identify an appropriate authorized historical checkout, propose specific successor evidence for the lead to accept, or record the row as open with its owner and release consequence. Submit the exact clean-commit scope to the lead or identify an already-authorized matching commit.

### C40.05 — Qualify the authorized clean commit and the external consumer

- **C40.05-CLEAN** — Call the candidate commit **A**. Use a lead-supplied exact clean commit or obtain separate lead authorization to create it at the proposed base, scope, ref and location. Step selection and plan approval do not authorize staging, committing or amending user work. Verify the registered checkout under `.worktrees/`, record A's full commit and tree IDs, require clean staged/unstaged/unignored state before and after qualification, and protect the primary index. If A is unavailable, keep the exact-candidate gate open.
- **C40.05-RETAIN** — Run `python scripts/validate_development.py` on that commit. Retain its full logs, both compiled comparisons (601 for v0.1.0, 811 for v0.2.0), focused reachability, root exports, exact import sets, reviewed simp policy, frozen manifests and current reviewed growth. Confirm the root's only direct imports are `LeanInfoTheory.Probability.Finite` and `LeanInfoTheory.InformationMeasures`. Inspect generated/static, warning-as-error, documentation and all-project trust outputs. Permitted axioms are `propext`, `Classical.choice` and `Quot.sound`. Record each of the four historical obligations independently according to the table below.

  Replay the archived C40.02 finite-testing caller and all C40.03 coding-to-separation callers against A's compiled library in a clean import environment. Keep the inputs, flags and source hashes from their original runs and record the resolved library paths, A's SHA and the result for each route. Write replay outputs outside the clean source tree. The maintained suite and these two replays supply distinct evidence.
- **C40.05-CONSUMER** — Materialize the external project separately from A, in a fresh sibling under `.worktrees/`. Resolve a local Git URL pinned to A's full SHA via Lake. Preserve the manifests, toolchain, cleanliness, dependency HEAD, all nine transitive pins and resolved source/olean paths. Run the end-to-end runner against A with a clean import environment. Verify its fixtures against `git show` at A, inspect the actual project imports in each materialized caller again, and run `lake --wfail build Consumer` covering both focused roots and the seven retained roots. Archive commands, logs and per-module evidence outside A. Public installation is a later release check.

| Separate clean obligation | Historical source, shown as closure / F prefixes | Qualification required |
| --- | --- | --- |
| C36.06 | `4fc4ee595fde / 0d2df93e9266` | Complete clean development suite and hygiene on an authorized checkpoint covering the prefix package, with its own lineage and evidence. |
| C37.07 | `5757260db89c / 76c279d56e07` | Same gates for the count/class and empirical-law checkpoint, with its own mapping. |
| C38.06 | `eb8e38e49978 / c6c395812b68` | Same gates on the corrected C38 lineage. Retain the original failed ownership comparison and its corrected evidence. |
| C39.06 | `d3ddf84699ff / 7e4c322f4110` | Same gates on the complete five-theorem C39 source and its consumers. |

Each F identifies a captured source. For each row, retain the original F, the authorized target SHA or open status, relevant input differences and their effect, the actual full-suite and hygiene receipts, the disposition, owner and release consequence. Credit a successor run only within the scope accepted by the lead and supported by that comparison. Date and attribute evidence to the SHA actually tested. C40 also requires its own clean pass on A.

### C40.06 — Qualify signature-bearing documentation and complete host layouts locally

- **C40.06-API** — On the exact clean candidate, run the separate two-pass `python scripts/validate_release.py api-docs` with the reviewed doc-gen project, pinned dependencies and Windows Zig 0.16.0 via `LEANINFOTHEORY_ZIG` (or the supported Linux toolchain). Use `DOCGEN_SRC=github` for exact-commit source targets, recording both passes, SHA/tree, manifest, source fingerprint, link mode and output digest. Verify candidate signatures against the ledger, coverage, and dependency assets. Default file mode is local inspection evidence only.
- **C40.06-SIZE** — In fresh local staging, build complete host compositions with an explicitly provisional candidate route. Preserve `/LeanInfoTheory/docs/v0.1.0/`, the `/LeanInfoTheory/docs/v0.2.0/` entry and the `/LeanInfoTheory-API/v0.2.0/` snapshot, including their identities/digests and destinations. The existing candidate staging/split/promotion scripts contain v0.2-specific assumptions. Reuse compatible validators and independently check provisional paths without repointing historical routes. Inventory each whole proposed host recursively, including dependency pages, search data, selectors, entry pages and retained snapshots. Record per-file sizes/hashes, tree digest, file count, uncompressed byte total, largest file and signed headroom `1,000,000,000−total`. Require **strictly less** than 1,000,000,000 bytes per host and no individual file over 100 MiB. Compare complete co-hosted and, if necessary, separate snapshot compositions. An oversized proposal must have a measured, working alternative or the hosting gate stays open. The earlier split preview totals of 661,575,985 and 655,316,062 bytes are historical only.

  Compare each staged historical route with independently retained release bytes. For v0.1.0, verify the [recovered deployed route](v0.2-release-preparation.md): 5,534 files, 660,408,008 bytes, SHA-256 `cb58864f20938cde83cffae0b230f654135bb3ffa68c4fba489cc6a834d4566f`. The C24 rebuild (`9f38d8dd…`) differed in 26 files and remains separate evidence. For v0.2.0, authenticate the retained Release 2 archive against its release pins and the whole API-site receipt in `.lake/v02-pages-953b785f/pair/receipt.json` (site SHA-256 `bd7c79fe8d0404faa656ca63e8f352c2fa1c207d6091cd3e032a8ad9798b0b87`). Then compare the archive's `v0.2.0/` subtree with the staged subtree by relative path and file bytes. Record the archive identity, comparison scope and outcome for each composition. If trusted historical bytes cannot be recovered, keep the preservation check open.
- **C40.06-LINKS** — Mount each complete layout at its actual project subpath on a local server, with distinct host/path mappings for cross-site routes. From maintained entry pages, follow version selectors to the candidate and both historical routes. Follow the existing navigation on each frozen snapshot and verify its historical destinations. On the candidate, search interactively for named endpoints of all six packages and follow results to their exact theorem anchors. Verify module/dependency links, return navigation and source destinations and line ranges against the intended commit for each version. Record browser interactions, crawler results, failures and corrected reruns. Check private exact-SHA links against local Git objects. Hosted HTTP and final public-SHA verification belong to the release thread.

### C40.07 — Cumulative validation, independent review and release handoff

- **C40.07-VALIDATE** — Prepare a cumulative pass/fail/open evidence table for all 19 approved criteria. Include all six endpoints, the two exact-A integration replays, the external project, full and lightweight imports, maintained builds, generated artifacts, both historical API comparisons, the trust audit, source documentation, two-pass API attestation and complete-host size/route checks. Mark fresh runs and identify the source, pins, environment and original receipts for any reused evidence. Rerun affected checks and serialize Lean builds sharing outputs.
- **C40.07-RECONCILE** — Give this thread's bound reviewer the review-ready handoff, evidence table and reviewed source capture R for a fresh cumulative assessment of every criterion. Preserve the original report, native observations and failed checks. Reconcile each assessment and finding with its evidence, severity and disposition. Obtain further independent assessment for any outstanding required criterion. Finish handoff and canonical-document edits before final capture F. Validate the differences from R to F and establish which evidence applies to A. The private completion record supplies the eventual closure reference.
- **C40.07-HANDOFF** — Maintain `docs/handoffs/chunk-40.md` for **LeanInfoTheory Third Release** as a separate record about the already-tested A. Prepare it for review with A's full SHA/tree, six-package ledger, supported imports and examples, both integration replays, external fixtures, validation receipts, documentation digests and host measurements, the four checkpoint dispositions, and release-only decisions with owners and triggers. Link the relevant living-summary, project-log, plan/notes, references and programme-map entries. Give the stable location for the eventual private completion record and distinguish pending review/closure from recorded passes. Finalize the handoff after reconciliation in the working records outside A. If a later handoff-bearing or amended commit **B** is selected as the candidate, obtain separate authority for any commit creation and qualify B under the rules below. The release thread must always be able to identify the exact SHA actually tested.

## Release-thread requalification

1. Compare the selected release SHA/tree with A and record any changes to package, citation, source, documentation, fixture or workflow inputs. A different selected SHA, including a handoff-bearing B or a final metadata/source amendment, requires the complete clean suite and hygiene, both released comparisons, trust, the archived finite-testing and coding-to-separation replays, and the external consumer pinned to that SHA. Keep exact tagged validators available. Historical metadata/promotion assertions in the development validator require separately reviewed release tooling for any future version transition.
2. Rebuild and reattest the two-pass API output if its manifest, source/docstrings, pins, generator, link mode or embedded source commit changes. At final public identity, check actual public installation and commit-line reachability. Rebuild the **final complete** site layouts, compare component identities/digests, remeasure every host and recheck all three permanent paths, selectors, search, anchors and source links at the final bases.
3. The current manual [promotion workflow](../../.github/workflows/promote-release-pages.yml) pins the v0.2.0 tag/source, bundle repository revision, ZIP/TAR SHA-256 and API-stage digest; the deploy input defaults to false. The release thread needs reviewed replacements and explicit authorization for metadata, hosting/provisioning, tagging, pushing and publication. After authorized deployment verify actual hosted bytes, navigation and public-commit source links. No version, date, DOI, promotion change or deployment is part of C40.

## Appendix — Endpoint signatures at planning intake

The following statement headers are extracted from the owning Lean files. Source links give the opening line. Types involving filters or scoped notation use the owner's local opens. C40.01 will bind the full ledger to a new compiled export.

<details>
<summary>LeanInfoTheory.Probability.BinaryTesting</summary>

Namespace `PMF.BinaryTest`, with `{X : Type u} [Fintype X]`. [Owning Lean source](../../LeanInfoTheory/Probability/BinaryTesting.lean#L142)

```lean
theorem isLeast_errorSum (P0 P1 : PMF X) :
    IsLeast (Set.range (fun f : BinaryTest X => errorSum f P0 P1))
      (1 - PMF.totalVariation P0 P1)

theorem isLeast_equalPriorError (P0 P1 : PMF X) :
    IsLeast (Set.range (fun f : BinaryTest X => equalPriorError f P0 P1))
      ((1 - PMF.totalVariation P0 P1) / 2)
```

</details>

<details>
<summary>LeanInfoTheory.Probability.NeymanPearson</summary>

Namespace `PMF.BinaryTest`, with `{X : Type u} [Fintype X]`. [Owning Lean source](../../LeanInfoTheory/Probability/NeymanPearson.lean#L272)

```lean
theorem exists_likelihoodThresholdTest (P0 P1 : PMF X) (a : ℝ)
    (ha : a ∈ Set.Icc (0 : ℝ) 1) :
    ∃ (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1),
      let fStar := likelihoodThresholdTest P0 P1 c γ
      size fStar P0 = a ∧
        ∀ g : PMF.BinaryTest X, size g P0 ≤ a → power g P1 ≤ power fStar P1
```

</details>

<details>
<summary>LeanInfoTheory.Shannon.ChannelCodingOneShot</summary>

Namespace `LeanInfoTheory.Shannon`. [Owning Lean source](../../LeanInfoTheory/Shannon/ChannelCodingOneShot.lean#L258)

```lean
theorem exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold
    {X : Type u} {Y : Type v} [Fintype X] [Fintype Y] {n M : ℕ}
    (q : PMF (Fin n → X)) (W : X → PMF Y) (t : ℝ) (hM : 1 ≤ M) :
    ∃ c : BlockChannelCode X Y n M,
      c.encoder ∈ (PMF.iid q M).support ∧
      c = BlockChannelCode.ofAcceptanceEvent c.encoder
        (infoDensityThresholdEvent q (PMF.memorylessChannel W n) t) hM ∧
      c.errorProbability W hM ≤
        ((PMF.channelJoint q (PMF.memorylessChannel W n)).toOuterMeasure
          (infoDensityThresholdEvent q (PMF.memorylessChannel W n) t)ᶜ).toReal +
            ((M : ℝ) - 1) * Real.exp (-t)
```

</details>

<details>
<summary>LeanInfoTheory.Shannon.OperationalCapacity</summary>

Namespace `LeanInfoTheory.Shannon`. [Owning Lean source](../../LeanInfoTheory/Shannon/OperationalCapacity.lean#L135)

```lean
theorem isLUB_isAchievableRate
    {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]
    (W : X → PMF Y) :
    IsLUB {R : ℝ | IsAchievableRate W R} (channelCapacity W)
```

</details>

<details>
<summary>LeanInfoTheory.Shannon.ChannelCodeExpurgation</summary>

Namespace `LeanInfoTheory.Shannon.BlockChannelCode`, with `{X : Type u} {Y : Type v} [Fintype Y] {n M : ℕ}`. [Owning Lean source](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean#L200)

```lean
theorem exists_expurgated_restrictions (c : BlockChannelCode X Y n M)
    (W : X → PMF Y) (hM : 1 ≤ M) :
    let G := Finset.univ.filter
      (fun m => c.messageErrorProbability W m ≤ 2 * c.errorProbability W hM)
    ∃ (_hL : 1 ≤ G.card) (i : Fin G.card ↪ Fin M),
      (M + 1) / 2 ≤ G.card ∧ Set.range i = (G : Set (Fin M)) ∧
      ∀ (K : ℕ) (hK : 1 ≤ K) (hKL : K ≤ G.card),
        ∃ d : BlockChannelCode X Y n K,
          d = c.restrictMessages ((Fin.castLEEmb hKL).trans i) ⟨0, hK⟩ ∧
          d.maximalErrorProbability W hK ≤ 2 * c.errorProbability W hM ∧
          ∀ π : PMF (Fin K), d.errorProbabilityWithPrior W π ≤
            2 * c.errorProbability W hM
```

</details>

<details>
<summary>LeanInfoTheory.Shannon.SourceChannelCode</summary>

Namespace `LeanInfoTheory.Shannon`. [Owning Lean source](../../LeanInfoTheory/Shannon/SourceChannelCode.lean#L52)

```lean
theorem sourceChannelErrorProbability_comp_le {S : Type u} {X : Type v} {Y : Type w}
    [Fintype S] [Fintype Y] {n K : ℕ} (p : PMF S) (W : X → PMF Y)
    (a : BlockSourceCode S n K) (b : BlockChannelCode X Y n K) :
    sourceChannelErrorProbability p W n (b.encoder ∘ a.encoder) (a.decoder ∘ b.decoder) ≤
      a.errorProbability (PMF.iid p n) +
        b.errorProbabilityWithPrior W ((PMF.iid p n).map a.encoder)
```

</details>

<details>
<summary>LeanInfoTheory.Shannon.SourceChannelSeparation</summary>

Namespace `LeanInfoTheory.Shannon`. [Owning Lean source](../../LeanInfoTheory/Shannon/SourceChannelSeparation.lean#L35)

```lean
theorem exists_sourceChannelCode_tendsto_errorProbability_zero
    {S : Type u} {X : Type v} {Y : Type w} [Fintype S] [Fintype X] [Nonempty X] [Fintype Y]
    (p : PMF S) (W : X → PMF Y) (h : entropy p < channelCapacity W) :
    ∃ (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X)) (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S)),
      Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n)) atTop (nhds 0)
```

</details>

<details>
<summary>LeanInfoTheory.Shannon.SourceChannelConverse</summary>

Namespace `LeanInfoTheory.Shannon`. [Owning Lean source](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L50)

```lean
theorem mul_entropy_le_mul_channelCapacity_add_error
    {S : Type u} {X : Type v} {Y : Type w} [Fintype S] [Fintype X] [Nonempty X] [Fintype Y]
    (p : PMF S) (W : X → PMF Y) (n : ℕ)
    (E : (Fin n → S) → (Fin n → X)) (D : (Fin n → Y) → (Fin n → S)) :
    (n : ℝ) * entropy p ≤ (n : ℝ) * channelCapacity W + Real.log 2 +
      sourceChannelErrorProbability p W n E D * (n : ℝ) * Real.log (Fintype.card S : ℝ)

theorem entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability
    {S : Type u} {X : Type v} {Y : Type w} [Fintype S] [Fintype X] [Nonempty X] [Fintype Y]
    (p : PMF S) (W : X → PMF Y)
    (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X))
    (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S))
    (he : Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n))
      atTop (nhds 0)) :
    entropy p ≤ channelCapacity W
```

</details>

<details>
<summary>LeanInfoTheory.Shannon.PrefixCodeLength</summary>

Namespace `LeanInfoTheory.Shannon`, with `{A : Type u} [Fintype A]`. [Owning Lean source](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean#L83)

```lean
theorem exists_isBinaryPrefixCode_length_eq_ceil (p : PMF A) :
    ∃ c : ↥p.supportFinset → List Bool, IsBinaryPrefixCode c ∧
      (∀ a, (c a).length = ⌈-Real.logb 2 (p a.val).toReal⌉₊) ∧
      expectedCodewordLength p c < natsToBits (entropy p) + 1

theorem isLeast_optimalPrefixLength (p : PMF A) :
    IsLeast {t : ℝ | ∃ c : ↥p.supportFinset → List Bool,
      IsBinaryPrefixCode c ∧ expectedCodewordLength p c = t}
      (optimalPrefixLength p)

theorem optimalPrefixLength_bounds (p : PMF A) :
    natsToBits (entropy p) ≤ optimalPrefixLength p ∧
      optimalPrefixLength p < natsToBits (entropy p) + 1
```

</details>

<details>
<summary>LeanInfoTheory.Shannon.PrefixCodeLengthIid</summary>

Namespace `LeanInfoTheory.Shannon`. [Owning Lean source](../../LeanInfoTheory/Shannon/PrefixCodeLengthIid.lean#L28)

```lean
theorem optimalPrefixLength_iid_div_bounds {A : Type u} [Fintype A]
    (p : PMF A) (n : ℕ) (hn : 0 < n) :
    natsToBits (entropy p) ≤ optimalPrefixLength (PMF.iid p n) / (n : ℝ) ∧
      optimalPrefixLength (PMF.iid p n) / (n : ℝ) <
        natsToBits (entropy p) + 1 / (n : ℝ)
```

</details>

<details>
<summary>LeanInfoTheory.Shannon.TypeClassProbability</summary>

Namespace `LeanInfoTheory.Shannon`, with `{A : Type u} [Fintype A] {n : ℕ}`. The first four headers use `[MeasurableSpace A] [MeasurableSingletonClass A]`. The fifth explicitly omits both. [Owning Lean source](../../LeanInfoTheory/Shannon/TypeClassProbability.lean#L67)

```lean
theorem iid_apply_of_mem_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support)
    {x : Fin n → A} (hx : x ∈ typeClass t) :
    ((PMF.iid p n) x).toReal =
      Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
        (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal))

theorem iid_toOuterMeasure_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support) :
    ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal =
      ((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * (entropy (empiricalPMF hn t) +
          (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal))

theorem iid_toOuterMeasure_typeClass_le_exp_neg_klDiv
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support) :
    ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal ≤
      Real.exp (-(n : ℝ) *
        (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal)

theorem exp_neg_klDiv_div_pow_le_iid_toOuterMeasure_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : (empiricalPMF hn t).support ⊆ p.support) :
    Real.exp (-(n : ℝ) *
        (InformationTheory.klDiv (empiricalPMF hn t).toMeasure p.toMeasure).toReal) /
        ((n : ℝ) + 1) ^ Fintype.card A ≤
      ((PMF.iid p n).toOuterMeasure (typeClass t)).toReal

theorem iid_toOuterMeasure_typeClass_eq_zero_of_not_support_subset
    (hn : 0 < n) (t : ↥(wordTypes A n)) (p : PMF A)
    (h : ¬ (empiricalPMF hn t).support ⊆ p.support) :
    (PMF.iid p n).toOuterMeasure (typeClass t) = 0
```

</details>
