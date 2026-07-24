# LeanInfoTheory Living Project Summary

This is the canonical living project-memory document for LeanInfoTheory. It is
an orientation and reconciliation layer, not a replacement for Lean source,
`AGENTS.md`, the project log, or focused mathematical plans.

Status labels used below:

- **[Current]** verified against the validated Lean/source baseline in Section 1;
- **[Decision]** an active design rule with historical rationale;
- **[History]** useful context that does not itself describe current status;
- **[Superseded]** an earlier plan or status replaced by later work;
- **[Uncertain]** a question that must be rechecked before implementation.

## Table of Contents

- [0. AI Assistant Quick Start](#0-ai-assistant-quick-start)
- [1. Document Status](#1-document-status)
- [2. Project Mission and Scope](#2-project-mission-and-scope)
- [3. Stable Mathematical Conventions](#3-stable-mathematical-conventions)
- [4. Source-of-Truth Hierarchy](#4-source-of-truth-hierarchy)
- [5. Current Mathematical Coverage](#5-current-mathematical-coverage)
- [6. Cover-Thomas Chapter 2 Coverage Matrix](#6-cover-thomas-chapter-2-coverage-matrix)
- [7. Current Lean Module and API Architecture](#7-current-lean-module-and-api-architecture)
- [8. Development History by Phase](#8-development-history-by-phase)
- [9. Stable Design Decisions and Rationale](#9-stable-design-decisions-and-rationale)
- [10. Rejected and Superseded Approaches](#10-rejected-and-superseded-approaches)
- [11. Known Limitations and Open Questions](#11-known-limitations-and-open-questions)
- [12. Active Work](#12-active-work)
- [13. Future-Work Register](#13-future-work-register)
- [14. Completed, Superseded, or Obsolete Future Work](#14-completed-superseded-or-obsolete-future-work)
- [15. Textbook and Reference Coverage](#15-textbook-and-reference-coverage)
- [16. Validation State](#16-validation-state)
- [17. Guidance for Different Assistant Roles](#17-guidance-for-different-assistant-roles)
- [18. Pointers to Detailed Historical Records](#18-pointers-to-detailed-historical-records)

## 0. AI Assistant Quick Start

**[Current] What this project is.** LeanInfoTheory is a Lean 4/mathlib library
for finite discrete information theory and Lean-checked entropy-inequality
certificates. Its two long-term branches are:

- **Project B:** textbook-facing finite Shannon theory over mathlib `PMF`s,
  including semantic bridges to measures, KL divergence, channels, Markov
  structure, data processing, and sufficient statistics;
- **Project A:** formal entropy expressions and a trusted Lean validator for
  primitive Shannon-inequality certificates, intended eventually to support
  network-information-theory converse proofs.

**[Current] Mathematical phase.** Project B is active. Cover-Thomas Chapter 2
Chunks 1-4 are complete. The next phase is **Chunk 5: finite Fano's
inequality and estimation error**. Its approved 20-step plan exists at
[`docs/plans/chapter2-chunk-05.md`](plans/chapter2-chunk-05.md), with every step
not started. No Chunk 5 Lean module or declaration exists yet.

**[Decision] Architectural rules that must be preserved.**

1. Use mathlib `PMF`, measure, kernel, KL, binary-entropy, and q-ary-entropy
   APIs. Do not create a toy or parallel probability theory.
2. Keep `LeanInfoTheory.lean` lightweight. Entropy bounds, semantic bridges,
   units, examples, certificate demos, coding anchors, and other heavy layers
   remain explicit imports.
3. Keep canonical finite information measures in `Real` and in nats.
   Base conversion is theorem-level, opt-in infrastructure.
4. Keep lightweight algebraic definitions separate from heavier semantic
   PMF/measure/KL theorems.
5. Do not introduce `sorry`, `admit`, project axioms, `opaque`, or
   `undefined`.
6. Preserve support guards, `ENNReal.top`, and null-fiber conventions. They
   are mathematical contracts, not implementation noise.
7. During active theorem work, do not rename correct public declarations.
   Record awkward names in Future Work Note 14 and review aliases at a planned
   API checkpoint.
8. Add helpers, aliases, bundled structures, and symmetric theorem variants
   only after concrete proof or consumer pressure.
9. For Lean changes, run focused builds while iterating and the maintained
   milestone suite before a checkpoint.

**Source order.** Read current source first, then current checked-in plans and
documentation, then the exact relevant textbook statements, then history and
temporary handoffs. See Section 4 for the conflict protocol.

**What to read next by task type.**

| Task | Read next |
| --- | --- |
| Chunk 5 planning or implementation | The approved [Chunk 5 plan](plans/chapter2-chunk-05.md); Sections 3, 6, 7, 9, 11, 12, 15, and 16; Future Work Note 29 in the project log |
| Review of an existing Lean theorem | Sections 3, 7, 9, and 16; the owning source module and its direct imports |
| API or module review | Sections 7, 9, 10, 11, and Future Work Notes 2-4, 14-16, 18, and 26 |
| Certificate work | Sections 2, 5, 7, 11, and 13; `EntropyExpr`, `EntropyVal`, `PrimitiveIneq`, and `Certificate.Checked` |
| Documentation or website work | Sections 1, 4, 5, 7, 11, and 16; `AGENTS.md` website rules |
| Grant or project-description work | Sections 2, 5, 6, 8, 11, and 13; distinguish implemented work from plans |
| General Assistant maintenance | Read the whole summary, then reconcile the project log, roadmap, and current Git state |

## 1. Document Status

| Field | Value |
| --- | --- |
| Last updated | 2026-07-24 |
| Validated Lean/source baseline | `217e35cf9f1a76354b6f82a3fb0209818b32bab7` (`master` and `origin/master` when validated) |
| Lean baseline | Lean `v4.30.0`, commit `d024af099ca4bf2c86f649261ebf59565dc8c622` |
| mathlib baseline | mathlib input revision `v4.30.0`, manifest commit `c5ea00351c28e24afc9f0f84379aa41082b1188f` |
| Current phase | Project B, Chunk 5 plan approved; implementation not started |
| Document ownership | Shared across project threads, with the project lead as decision authority |

**Purpose.** This file gives future assistants one maintained entry point for
project state, mathematical coverage, architecture, rationale, open questions,
and navigation. It should be detailed enough for planning and review but should
link to the project log instead of reproducing its chronology.

**Relationship to other documents.**

- [`AGENTS.md`](../AGENTS.md) is the operational instruction file. If an
  instruction here conflicts with `AGENTS.md`, follow `AGENTS.md` and repair
  this summary.
- [`docs/project-log.md`](project-log.md) is the detailed chronological record
  and currently owns the numbered Future Work Notes.
- [`docs/current-lean-state.md`](current-lean-state.md) is the long Lean status
  and completed-step record.
- [`docs/roadmap.md`](roadmap.md) is the public milestone roadmap.
- This living summary is the canonical cross-thread orientation and
  reconciliation layer among those sources.

**Update policy.**

1. Any project thread may edit this file when its work materially changes
   canonical project context. Separate authorization from the General
   Assistant is not required; the editing thread must reconcile affected
   sections against the governing source, builds, approved plans, project-log
   entries, and Git history.
2. Advance the validated Lean/source baseline after a coherent Lean checkpoint
   or source-changing merge. Documentation-only checkpoints do not redefine it.
3. Update Sections 0, 5, 6, 8, 12, 13, and 16 after each major mathematical
   chunk.
4. Update Sections 3, 7, 9, and 10 only when a convention, module boundary, or
   design decision actually changes.
5. Preserve completed rationale in Sections 8, 10, and 14 rather than silently
   deleting it.
6. Mark unresolved claims as **[Uncertain]**. Do not convert a conversation
   proposal into an approved plan without repository or user confirmation.
7. Verify every public declaration and module path named here against current
   source or the generated declaration index.
8. Keep this file readable as an onboarding document. Detailed step logs stay
   in `docs/project-log.md`.

## 2. Project Mission and Scope

### Mathematical goal

**[Current]** Build a rigorous, reusable finite-discrete information-theory
library that follows standard textbook mathematics while exposing theorem
statements useful for later coding, statistics, network information theory,
and converse arguments.

The present mathematical spine is Cover and Thomas, Chapter 2. Other local
references are used to refine theorem boundaries and later compatibility:
Yeung for entropy identities and certificate-facing algebra, El Gamal-Kim for
network-information-theory conventions, Polyanskiy-Wu for kernels,
sufficiency, tensorization, and estimation viewpoints, and Csiszar-Korner for
finite channels and divergence.

### Formalization goal

**[Current]** Connect three layers without conflating them:

```text
finite PMF information measures
    -> semantic PMF / measure / kernel / KL theorems
    -> abstract entropy expressions and checked certificates
```

Project B supplies the mathematical semantics. Project A supplies scalable,
kernel-checked algebra once suitable semantic assumptions have been packaged.
The long-term objective is not merely a list of entropy lemmas, but a path from
standard information-theoretic models to checked inequality certificates and
recognizable converse steps.

### Relationship to mathlib

**[Decision]** The project is mathlib-based and complementary to existing
formalization:

- reuse `PMF`, `PMF.map`, `PMF.bind`, `PMF.pure`, `PMF.toMeasure`, measures,
  kernels, and coding foundations;
- reuse `Real.negMulLog`, `Real.binEntropy`, and `Real.qaryEntropy`;
- reuse `InformationTheory.klDiv` and mathlib KL chain rules;
- add finite PMF-facing definitions and bridge theorems that are absent or
  inconvenient at the pinned version;
- upstream small generic lemmas only after assumptions and names stabilize;
- keep certificate syntax and import machinery local unless mathlib
  maintainers request a generic framework.

### Intended users

- information theorists who want finite PMF and random-variable APIs;
- Lean/mathlib contributors interested in reusable finite probability or KL
  lemmas;
- researchers building checked entropy-inequality or converse automation;
- students and contributors working on bounded formalization tasks;
- documentation, grant, and project-description authors who need an honest
  implementation map.

### Current exclusions

**[Current]** The following are not part of the completed implementation:

- full source- or channel-coding theorems, channel capacity, or coding
  converses;
- AEP, typicality, method of types, entropy rates, or a stochastic-process
  hierarchy;
- general measurable-space entropy and sufficient-statistics theory;
- a finite-family entropy representation and a concrete PMF construction of
  `ShannonEntropyVal`;
- automatic certificate search, primitive recognition, or PSITIP/oXitip
  import;
- canonical or minimal sufficient statistics;
- a local standalone log-sum inequality, general KL convexity, entropy
  concavity, Pinsker family, or finite-simplex continuity theory;
- full Lean doc-gen and a theorem-level leanblueprint.

Chunk 5 is also explicitly bounded away from a full coding theorem.

## 3. Stable Mathematical Conventions

### Finite probability and entropy

- **[Decision]** A finite distribution is a mathlib `PMF alpha`.
- `Shannon.entropy` requires `[Fintype alpha]` because its definition is the
  explicit finite sum
  `sum a, Real.negMulLog (p a).toReal`.
- Entropy values are `Real`.
- Canonical units are nats because the underlying logarithm is `Real.log`.
- `Shannon.Units` converts a nat-valued quantity to base `b` by division by
  `Real.log b`; there is no duplicate hierarchy of base-indexed definitions.
- Zero-mass atoms contribute zero through `Real.negMulLog 0 = 0`.
- `selfInfo p a` also uses a zero branch at a zero-mass atom; only weighted
  statements assign it semantic significance there.

### Random variables and products

- A random-variable quantity is defined through the pushforward law
  `p.map X`. The source type need not be finite when only the value alphabet
  needs a finite sum.
- Joint entropy is entropy of a product-valued pushforward.
- Pair and triple marginals are `PMF.map` abbreviations.
- Lean products are right-associated. In ASCII notation, a triple law has type
  `Prod alpha (Prod beta gamma)`.
- Coordinate maps, swaps, and reassociations are explicit implementation
  devices. Public aliases should prefer mathematical left/right terminology
  only when it improves discovery without hiding a substantive orientation.

### Algebraic and semantic definitions

- `condEntropy`, `mutualInfo`, and `condMutualInfo` are defined in the
  lightweight layer by entropy identities.
- The semantic bridge proves the expected-conditional-law and KL forms.
- These are equivalent mathematical views, but keeping the algebraic forms
  definitional supports Project A's linear entropy-expression certificates.
- Entropy and conditional-entropy chain rules are explicit rewrite theorems,
  not general `[simp]` normalizations.

### Support and null fibers

- PMF support is the set of nonzero atoms; `PMF.supportFinset` is the canonical
  finite view when a `Fintype` is available.
- Support-aware statements use the law's actual support. For example,
  deterministic entropy preservation is characterized by injectivity on the
  mapped law's support, not global injectivity.
- `condFstGivenSnd` is defined only for a positive conditioning fiber.
  Numeric fiber entropy/CMI wrappers contribute zero on a null fiber.
- `condFstGivenSndChannel` and `channelPosterior` are total channels. On null
  fibers they use a documented fallback solely for totality. Weighted,
  support-restricted, or almost-everywhere theorems must make that choice
  irrelevant.
- No theorem should attribute conditional-probability meaning to a total
  posterior on a null fiber.

### Channels, Markov structure, and KL

- A finite channel is the raw function type `alpha -> PMF beta`; there is no
  bundled project channel structure.
- Output remains `p.bind W`; identity remains `PMF.pure`.
- `IsMarkovChainOf p X Y Z` means that `X` and `Z` are conditionally
  independent given `Y`.
- `IsCondIndependent` is defined by the null-fiber-safe cross-product identity;
  positive-fiber conditional-law statements are equivalences.
- Mathlib `InformationTheory.klDiv` is the canonical KL divergence and has
  codomain `ENNReal`.
- Unconditional KL contraction is stated in `ENNReal`. Real-valued KL theorems
  require support or finiteness hypotheses because `ENNReal.toReal top = 0`.
- For finite PMFs, support inclusion is the operative absolute-continuity and
  KL-finiteness condition.

### Sufficiency

- `IsSufficientStatisticOf` is a fixed-law or fixed-prior predicate expressed
  by the reverse Markov chain `Theta -> T(X) -> X`.
- `IsSufficientChannel model W` is prior-free and family-level. Its quantifier
  order is `exists R, forall t`: one recovery channel is shared by the family.
- Family sufficiency requires exact recovery of the complete output-input
  joint law, not merely recovery of the input marginal.
- `IsSufficientStatistic` is exactly the deterministic-channel specialization
  of `IsSufficientChannel`.
- Pairwise KL equality for a larger model family does not automatically supply
  one coherent common recovery witness.

### Lean assumptions

- Prefer `[Fintype alpha]` when a statement exposes a finite sum or canonical
  enumeration.
- Prefer `[Finite alpha]` when finiteness is only used internally.
- Local measurable-space and measurable-singleton assumptions belong in
  measure/KL bridges, not in the elementary PMF vocabulary.
- Some current finite theorems intentionally carry stronger assumptions than
  the most general mathematics; Section 11 records the known cases.

### Certificate semantics

- `EntropyAtom` is a finite set of variable names.
- `EntropyExpr` is a sparse rational linear combination of entropy atoms.
- The empty entropy atom is explicit; arbitrary interpretations do not
  automatically satisfy `H(empty) = 0`.
- `ShannonEntropyVal` packages empty entropy, elemental conditional-entropy
  nonnegativity, and conditional-mutual-information nonnegativity.
- Raw certificate coefficients are `Rat`; checked coefficients are `NNRat`.
- External search or parsing is untrusted. Lean validation of primitive tags,
  coefficient nonnegativity, and exact normalized expression equality is the
  trust boundary.

## 4. Source-of-Truth Hierarchy

Use this order when claims disagree:

| Priority | Source | Use |
| --- | --- | --- |
| 1 | Current Lean source and successful builds | Declaration existence, theorem statement, assumptions, proof status, imports, and current behavior |
| 2 | Current checked-in instructions and approved plans | Operational policy, active phase, intended module boundaries, and approved next work |
| 3 | Exact relevant textbook statements | Mathematical intent, terminology, conventional orientation, and scope |
| 4 | Git history and targeted project-log entries | Why a design was chosen, what was tried, and when a boundary changed |
| 5 | Historical handoff reports | Conversation rationale not recoverable elsewhere; never authoritative for current names or status |
| 6 | Remote GitHub and deployed website | Public synchronization, CI, and presentation consistency |

### Conflict protocol

1. Verify the declaration or import in current source.
2. Verify the current branch, baseline commit, and build result.
3. Check `AGENTS.md`, the active project-log plan, and the roadmap.
4. Consult the exact textbook section only for mathematical intent, not for
   Lean ownership.
5. Use history to explain the discrepancy.
6. Record the conflict and its practical consequence. Do not silently select
   the most convenient source.

### Known source discrepancies at this baseline

- **[Current documentation gap]** `docs/concept-note.md` still says general
  stochastic data processing and independence equality cases are future work.
  Current source completed those in Chunks 2-4. Treat that limitation paragraph
  as stale historical positioning.
- **[Current CI gap]** `AGENTS.md` and the local milestone suite explicitly
  build `LeanInfoTheory.Shannon.Units`; `.github/workflows/lean_action_ci.yml`
  does not list `Units` among its separately importable targets. Current local
  validation includes it, but a future CI cleanup should decide whether to add
  the missing explicit target.
- **[Superseded planning]** The original eight-chunk topic boundaries were
  revised by implementation. Conditional independence moved into Chunk 2;
  channels, DPI, and one-step doubly stochastic entropy growth moved into
  Chunk 3; sufficiency became Chunk 4. Use current source and Note 29, not the
  original labels, to assign ownership.
- **[Historical count only]** Older log paragraphs mention fewer documented
  declarations. The current generated index is authoritative at this baseline:
  686 public declarations, all 686 documented.

## 5. Current Mathematical Coverage

### Finite Shannon layer

**[Current]** Implemented over finite PMFs and finite-valued pushforwards:

- entropy, random-variable entropy, and joint entropy;
- entropy nonnegativity and exact zero-entropy characterizations;
- invariance under equivalences, injective relabelings, swaps, and product
  reassociation;
- pair and triple marginals with pointwise mass and support infrastructure;
- algebraic conditional entropy, mutual information, and conditional mutual
  information;
- pair/triple chain rules, symmetry, self-information identities, and standard
  entropy-difference forms;
- deterministic entropy and mutual-information processing with support-aware
  equality/recovery cases;
- pair and triple inequality bands;
- alphabet- and support-cardinality entropy bounds with exact uniformity
  equality cases;
- opt-in logarithm-base conversion.

Representative owners are `Shannon.Entropy`, `Shannon.InfoMeasures`,
`Shannon.EntropyBounds`, `Shannon.Units`, and
`Shannon.SemanticBridge.Theorems`.

### Semantic PMF, conditional-law, and KL layer

**[Current]** The semantic bridge supplies:

- expected self-information;
- independent-product PMFs and product-measure semantics;
- finite conditional PMFs and expected fiber entropy;
- MI as a finite log-ratio sum and as KL to the product of marginals;
- CMI as averaged fiber MI and averaged fiber KL;
- PMF support characterizations of absolute continuity, finite/infinite KL,
  KL zero, and uniform-reference KL;
- ordinary and conditional independence, including bridges to mathlib
  `ProbabilityTheory.IndepFun`;
- zero MI/CMI and entropy equality cases.

The primary modules are `SemanticBridge.Product`, `FiniteSums`, `Conditional`,
`KL`, `Theorems`, and `Independence`.

### Channels, Markov chains, and data processing

**[Current]** The channel layer includes:

- `PMF.deterministicChannel`, `PMF.channelComp`, `PMF.channelJoint`, and
  `PMF.channelExtension`;
- atom, projection, composition, deterministic, and support laws;
- total conditional channels and posterior reconstruction;
- PMF and random-variable Markov predicates;
- cross-product, positive-fiber, zero-CMI, reversal, canonical-factorization,
  and existential-factorization characterizations;
- the exact Markov information-loss identity;
- MI data processing, deterministic and stochastic one-sided/two-sided forms,
  channel cascades, and equality through the reverse Markov chain;
- a PMF-channel to mathlib-kernel bridge;
- exact posterior KL decomposition;
- unconditional `ENNReal` and support-guarded real KL data processing;
- invariant-reference contraction and one-step entropy growth under
  uniform-preserving or finite doubly stochastic channels.

The owners are `Probability.FiniteChannel`,
`SemanticBridge.Markov`, and `SemanticBridge.DataProcessing`.

### Sufficient statistics and KL equality

**[Current]** The finite sufficiency layer includes:

- fixed-prior sufficiency and its reverse-Markov, zero-CMI, MI-preservation,
  conditional-entropy-preservation, and exact-recovery characterizations;
- family-level sufficient channels with one common recovery witness;
- deterministic sufficient statistics as a specialization;
- supported common-posterior characterization;
- every-prior consequences and full-support/all-priors converses;
- a finite Fisher-Neyman factorization iff;
- posterior equality criteria for equality in KL data processing;
- common-recovery KL preservation and guarded converses;
- pairwise KL preservation for sufficient families and a guarded Boolean
  two-law converse.

The core owner is `SemanticBridge.Sufficiency`, whose only direct project
import is `SemanticBridge.Markov`. Posterior/kernel equality and recovery/KL
integration remain downstream in `SemanticBridge.DataProcessing` and
`SemanticBridge.Sufficiency.KL`. Generic `SemanticBridge.KL` is nevertheless
already in the core's transitive dependency closure through `Markov`,
`Independence`, and `Theorems`.

### Certificate layer

**[Current]** The trusted checking path includes:

- entropy atoms and sparse rational entropy expressions;
- abstract Shannon entropy valuations;
- empty-entropy, conditional-entropy, and CMI primitive expressions;
- primitive soundness;
- raw and checked certificate structures;
- nonnegative checked coefficients and exact decomposition equality;
- raw-to-checked validation and validation-to-soundness theorems;
- checked demos for submodularity, subadditivity, one-variable monotonicity,
  and three-way subadditivity.

This is validation, not certificate generation or search.

### Examples and public documentation

**[Current]** Separately importable examples exercise:

- support-sensitive entropy, functional dependence, and side information;
- the `KL = top` versus `toReal KL = 0` trap;
- a noisy common-cause Markov model;
- genuinely stochastic contraction and strict entropy growth;
- noninjective sufficient statistics, non-sufficiency, and the failure of
  marginal-only recovery.

The website has a hand-written module guide, theorem highlights, certificate
demo, generated module dependency map, and source-derived declaration index.
It does not yet have full doc-gen or theorem-level leanblueprint output.

## 6. Cover-Thomas Chapter 2 Coverage Matrix

Status terms refer to the project's finite-discrete scope. "Complete" does not
claim a general measure-theoretic formalization of the whole subject.

| Topic | Status and provenance | Representative declarations | Owner and layer | Limitations, downstream use, and remaining work |
| --- | --- | --- | --- | --- |
| **2.1 Entropy** | **Substantially complete.** Core predates the eight-chunk programme; zero/equality and units were strengthened in Chunk 1. | `entropy`, `entropyOf`, `entropy_nonneg`, `entropy_eq_zero_iff`, `entropyOf_eq_zero_iff`, `entropy_eq_integral_selfInfo`, `entropy_div_log` | `Shannon.Entropy` is lightweight; semantic expectation and units are opt-in. | Nats are canonical. No maintained theorem yet identifies a Bernoulli PMF entropy with `Real.binEntropy`; that bridge is expected when Fano needs it. |
| **2.2 Joint and conditional entropy** | **Substantially complete for pairs and triples.** Core and expected-fiber semantics predate the programme; functional dependence is Chunk 1; equality cases use Chunk 2 independence. Chain-rule work is catalogued under 2.5. | `jointEntropyOf`, `condEntropy`, `condEntropyOf`, `condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd`, `condEntropyOf_eq_zero_iff_exists_function` | Algebraic definitions in lightweight `InfoMeasures`; conditional PMFs and equality consequences in semantic modules. | Pair/triple chain-rule coverage is catalogued under 2.5; no n-variable family representation or general chain rule exists. Null fibers use explicit zero or totality conventions. Feeds Fano, sufficiency, and certificates. |
| **2.3 Relative entropy and mutual information** | **Substantially complete at finite PMF level.** MI/KL bridges predate the programme; support/finiteness, equality, and uniform-reference results are Chunk 2; channel KL is Chunks 3-4. | `mutualInfo`, `mutualInfo_eq_toReal_klDiv_joint_prod_marginals`, `toMeasure_absolutelyContinuous_iff_support_subset`, `klDiv_pmf_ne_top_iff_support_subset`, `klDiv_pmf_eq_zero_iff`, `toReal_klDiv_pmf_uniformOfFinset` | `InfoMeasures` plus heavy `SemanticBridge.KL` and `DataProcessing`; KL itself is mathlib's `InformationTheory.klDiv`. | Real KL requires guards. No project-local generic conditional-relative-entropy object or general KL convexity theorem. |
| **2.4 Entropy/MI relationships** | **Complete for the finite pair surface.** Symmetry predates the programme; full identity and self-information family is Chunk 1. | `mutualInfoOf_eq_entropyOf_sub_condEntropyOf`, its swapped form, `mutualInfoOf_eq`, `mutualInfoOf_swap`, `mutualInfoOf_self` | Lightweight `Shannon.InfoMeasures`. | Rewrites remain explicit. Reverse-oriented aliases are intentionally not generated without proof pressure. Used throughout DPI and sufficiency. |
| **2.5 Chain rules** | **Partial.** Pair/triple entropy and MI chain rules predate or belong to Chunk 1; mathlib's KL chain rule is reused in Chunk 3. | `entropy_chain_rule_left`, `entropy_chain_rule_right`, `condEntropyOf_pair_chain_rule`, `mutualInfoOf_chain_rule_fst`, `mutualInfoOf_chain_rule_snd`, `klDiv_channel_eq_add_posterior` | Lightweight algebraic rules plus heavy semantic/KL decomposition. | No finite-family n-variable entropy/MI chain rule and no local standalone relative-entropy chain-rule family. Planned finite-family work must choose a representation first. |
| **2.6 Jensen and consequences** | **Substantially complete for currently used consequences.** Initial alphabet bound predates the programme; sharp support/equality and independence endpoints are Chunks 1-2. | `entropy_le_log_card`, `entropy_eq_log_card_iff_eq_uniformOfFintype`, `entropy_le_log_support_ncard`, `mutualInfo_nonneg`, `mutualInfo_eq_zero_iff_isIndependent`, `condEntropy_eq_entropy_left_iff_isIndependent` | Jensen-heavy `EntropyBounds` is opt-in; semantic equality cases are heavy. | The project reuses mathlib Jensen/strict concavity rather than formalizing a local general Jensen theorem. General n-way independence bounds are not packaged. |
| **2.7 Log-sum and convexity applications** | **Deferred.** A direct log-sum route to DPI was considered, but Chunk 3 chose mathlib's kernel KL chain rule. | No project-local `logSum` theorem, general joint convexity of KL, entropy concavity, or channel-convexity family. | Any future layer should remain opt-in and reuse mathlib where possible. | DPI being complete does not mean this section is formalized. Assignment to a later chunk remains **[Uncertain]**. |
| **2.8 Data processing** | **Substantially complete for finite PMFs and finite-valued random variables.** Deterministic processing is Chunk 1; Markov and stochastic MI/KL DPI are Chunk 3; KL equality/recovery is Chunk 4. | `IsMarkovChainOf`, `mutualInfoOf_markov_chain_rule`, `mutualInfoOf_dataProcessing`, `mutualInfoOf_dataProcessing_eq_iff`, `klDiv_channel_le`, `toReal_klDiv_channel_le` | `SemanticBridge.Markov` and `DataProcessing` are opt-in; the raw channel core is lighter but still outside root. | No general measurable stochastic-variable coupling API. Strict-loss variants and some symmetric forms remain proof-pressure deferred. |
| **2.9 Second law / stochastic entropy growth** | **Partial.** One-step finite consequences are Chunk 3. | `klDiv_channel_invariant_le`, `toReal_klDiv_channel_invariant_le`, `entropy_le_entropy_bind_of_uniform_invariant`, `entropy_le_entropy_bind_of_doublyStochastic` | Heavy `SemanticBridge.DataProcessing`; examples in `Examples.StochasticChannels`. | No iterated channel powers, stationary-process object, entropy rate, matrix bridge, or Birkhoff/majorization theory. A matrix-facing bridge is deferred by Note 38. |
| **2.10 Sufficient statistics** | **Substantially complete for finite fixed-prior and finite family recovery.** Chunk 4. | `IsSufficientStatisticOf`, `IsSufficientChannel`, `IsSufficientStatistic`, `isSufficientStatisticOf_iff_exists_recovery`, `isSufficientChannel_iff_exists_common_posterior`, `isSufficientStatistic_iff_exists_fisherNeymanFactorization`, `klDiv_channel_eq_iff_exists_common_recovery` | Lightweight `Sufficiency`; posterior/KL statements in downstream heavy modules. | Canonical/minimal statistics, iid count-statistic infrastructure, and general measurable sufficiency are deferred. Larger-family pairwise KL equality does not yield a global witness. |
| **2.11 Fano's inequality** | **Planned, not started.** The approved 20-step Chunk 5 plan has no completed step. | No project Fano declaration; no maintained binary/q-ary bridge theorem. Mathlib anchors are `Real.binEntropy` and `Real.qaryEntropy`. | The approved plan assigns opt-in `Shannon.BinaryEntropy` and `Shannon.Fano` modules plus `Examples.Fano`; none exists yet. | The deterministic-decoder, Boolean-error, exact/weak Fano, error-lower-bound, and uniform-message contracts are approved. Names remain tentative until the planned API review. Coding theorems remain out of scope. |

## 7. Current Lean Module and API Architecture

### Root and lightweight finite layer

| Module | Responsibility | Root-visible? |
| --- | --- | --- |
| `LeanInfoTheory.Basic` | Project namespace and status vocabulary | Yes |
| `LeanInfoTheory.Probability.Finite` | Reusable PMF real-mass, map, support, and pure-law helpers | Yes |
| `LeanInfoTheory.Shannon.Entropy` | Entropy, entropy of pushforwards, joint entropy, zero and relabeling facts | Yes, through `InformationMeasures` |
| `LeanInfoTheory.Shannon.InfoMeasures` | Marginals, conditional entropy, MI, CMI, random-variable forms, core rewrites | Yes, through `InformationMeasures` |
| `LeanInfoTheory.InformationMeasures` | Explicit convenience re-export from `Shannon` into `LeanInfoTheory` | Yes |
| `LeanInfoTheory.EntropyExpr` | Entropy atoms and sparse rational expressions | Yes |
| `LeanInfoTheory.EntropyVal` | Abstract Shannon entropy valuations | Yes |
| `LeanInfoTheory.PrimitiveIneq` | Primitive Shannon expressions and soundness | Yes |
| `LeanInfoTheory.Certificate` | Generic certificate combination and soundness skeleton | Yes |
| `LeanInfoTheory.Certificate.Checked` | Raw/checked certificates and validator | Yes |
| `LeanInfoTheory` | Lightweight public aggregate only | Root |

At the current generated dependency baseline, 11 of 36 modules are
root-reachable. The root does not import bounds, units, semantic bridges,
channel modules, demos, examples, or mathlib coding anchors.

### Opt-in finite and semantic layers

| Module | Responsibility |
| --- | --- |
| `LeanInfoTheory.Shannon.EntropyBounds` | Jensen-based alphabet/support bounds and exact uniform equality |
| `LeanInfoTheory.Shannon.Units` | Logarithm-base conversion |
| `LeanInfoTheory.Probability.FiniteChannel` | Raw PMF channel constructions and elementary laws, with no Shannon/KL dependency |
| `LeanInfoTheory.Shannon.SemanticBridge.Product` | Independent product PMFs and product-measure bridges |
| `LeanInfoTheory.Shannon.SemanticBridge.FiniteSums` | Finite real-mass and log-ratio expansions |
| `LeanInfoTheory.Shannon.SemanticBridge.Conditional` | Positive conditional PMFs and expected fiber formulas |
| `LeanInfoTheory.Shannon.SemanticBridge.KL` | PMF KL support/equality/uniform-reference results and MI/CMI KL bridges |
| `LeanInfoTheory.Shannon.SemanticBridge.Theorems` | Nonnegativity, chain rules, processing, functional dependence, and inequality consequences |
| `LeanInfoTheory.Shannon.SemanticBridge.Independence` | Ordinary/conditional independence and equality characterizations |
| `LeanInfoTheory.Shannon.SemanticBridge.Markov` | Markov predicates, total conditional channel, factorization, MI DPI |
| `LeanInfoTheory.Shannon.SemanticBridge.Sufficiency` | Fixed-prior and family sufficiency core, directly importing `Markov` |
| `LeanInfoTheory.Shannon.SemanticBridge.DataProcessing` | PMF-kernel bridge, posterior KL decomposition, KL DPI, entropy growth |
| `LeanInfoTheory.Shannon.SemanticBridge.Sufficiency.KL` | Downstream exact-recovery and KL equality integration |
| `LeanInfoTheory.Shannon.SemanticBridge` | Heavy semantic aggregate |

**[Decision] Dependency direction.**

```text
InfoMeasures -> Product / FiniteSums / Conditional
Product + FiniteSums + Conditional -> KL -> Theorems -> Independence
FiniteChannel + Independence -> Markov -> Sufficiency
Markov + Sufficiency + focused mathlib KL/kernel
    -> DataProcessing -> Sufficiency.KL
```

The exact file graph is generated in
[`home_page/blueprint/module_graph.json`](../home_page/blueprint/module_graph.json).
New work should use the lightest owner whose statement and proof dependencies
justify it.

### Certificates, examples, and anchors

- `Certificate.Submodularity`, `Subadditivity`, `Monotonicity`, and
  `ThreeWaySubadditivity` are opt-in checked-certificate demonstrations.
- `Examples.SupportSensitive`, `KLTop`, `CommonCause`,
  `StochasticChannels`, and `SufficientStatistics` are separately importable.
- `Examples` aggregates the semantic examples and original certificate toys.
- `MathlibFragments` is an opt-in import checklist for binary/q-ary entropy,
  KL, KL chain rules, PMF constructions, and Kraft-McMillan. It intentionally
  declares no replacement API.

### Namespaces and public API

- `LeanInfoTheory.Shannon` is the canonical namespace for finite information
  measures and semantic theorems.
- `LeanInfoTheory.InformationMeasures` exports selected names into
  `LeanInfoTheory` for root users.
- PMF-specific reusable constructions and facts extend the `PMF` namespace.
- Certificate declarations live under `LeanInfoTheory.Certificate` and
  descriptive demo namespaces.
- Existing descriptive theorem names are stable. Compatibility aliases are
  additive and review-driven.

### Generated documentation and website pipeline

The scripts:

```text
scripts/generate_website_blueprint.py
scripts/generate_website_api_index.py
scripts/check_website.py
```

produce or validate:

- a module-level graph derived from local import lines;
- a source-derived public declaration index;
- HTML views of those artifacts;
- internal website links and JSON structure.

At this baseline:

- module graph: 36 modules, 59 local edges, 11 root-reachable, 25 opt-in;
- declaration index: 686 public declarations, all documented.

These artifacts are not theorem-level dependency data and not full Lean
doc-gen.

## 8. Development History by Phase

### Pre-roadmap foundation

**[History]** The phase from `6623632` through `7855d0d` established both
branches and the repository's working discipline:

| Commit | Durable result |
| --- | --- |
| `6623632` | Project, CI, website, initial expression/certificate skeleton |
| `a356010` | Finite PMF Shannon definitions, marginals, helpers, first semantic layout |
| `6f6cd82` | Strict placeholder policy, empty entropy, `ShannonEntropyVal` |
| `cfd850d` | Primitive inequalities, checked certificates, validator, submodularity |
| `9b92b72` | Relabeling helpers, Jensen entropy bound, expected self-information |
| `e197db2` | Product, conditional-law, finite-sum, KL, and semantic theorem bridge |
| `098892c` | Symmetry, chain rules, conditioning, and more certificate demos |
| `7855d0d` | Three-way certificate pressure test and explicit Project B transition |

The pre-roadmap API remained in place. Later chunks were overwhelmingly
additive and preserved inherited public names.

### Formal Chapter 2 programme

| Chunk | Checkpoint | Purpose | Actual result |
| --- | --- | --- | --- |
| 1 | `7ab3aa0` | Complete finite pair/triple Shannon identities before channels | Zero/equality cases, functional dependence, chain rules, deterministic entropy/MI processing, inequality bands, units |
| 2 | `e5e9825` | Finite KL support semantics and independence | Support/finiteness/top KL, KL zero, uniform reference, sharp entropy equality, ordinary and conditional independence, zero MI/CMI |
| 3 | `a5cc9e9` | Channels, Markov chains, and data processing | Raw PMF channels, total conditional channel, Markov factorization, MI DPI, PMF-kernel bridge, KL DPI, invariant contraction, entropy growth |
| 4 | `f990f2e` | Finite sufficient statistics and equality in data processing | Fixed-prior/family sufficiency, exact recovery, common posteriors, all-prior and Fisher-Neyman results, guarded KL equality |

Cleanup checkpoints `e72e68c`, `7de8ff5`, and `11e071c` reconciled
post-chunk documentation and prepared the current Chunk 5 handoff.

### Current preparation for Chunk 5

**[Current]** Commit `11e071c` records the Fano handoff and `217e35c` is a
website-only author-profile link on top of it. The approved plan at
`docs/plans/chapter2-chunk-05.md` has 20 not-started steps. No Fano source file
or theorem has been created.

## 9. Stable Design Decisions and Rationale

| Decision | Rationale to preserve |
| --- | --- |
| Use mathlib `PMF` | Enforces probability laws, integrates with measures/kernels, and avoids a mathematically inadequate rational toy model |
| PMF-first finite API | Makes finite sums, examples, pushforwards, and textbook statements tractable while retaining measure semantics downstream |
| Entropy in `Real`, nats first | Matches `Real.negMulLog`, `Real.log`, and mathlib binary/q-ary entropy; base conversion needs no duplicate hierarchy |
| Pushforward definition of random-variable quantities | Keeps laws distributional and makes relabeling/marginals compositional |
| Algebraic core, semantic bridge | Supports certificate algebra without losing textbook expected-fiber and KL meanings |
| Lightweight root | Prevents Jensen, KL, kernels, examples, and coding imports from burdening ordinary finite-entropy users |
| Raw channel functions, not a bundled channel | Reuses `PMF.bind` and keeps the elementary construction layer type-generic and cheap |
| Cross-product conditional independence | Gives a proof-independent, null-fiber-safe primary predicate |
| Total conditional channel with documented fallback | Avoids extra nonempty assumptions while ensuring null fibers have no semantic force |
| `ENNReal` as primary unconditional KL codomain | Preserves infinite divergence and avoids the `toReal top = 0` trap |
| Kernel-chain-rule proof of KL DPI | Reuses mathlib's analytic engine and supports later equality/posterior reasoning |
| Fixed-prior and family sufficiency are distinct | Separates a chosen joint law from prior-free recovery for an entire model family |
| Exact full-joint family recovery | Preserves input-output coupling; marginal recovery alone is too weak |
| One shared recovery witness | `exists R, forall t` is the mathematical family-sufficiency contract |
| Sufficiency core before posterior/KL integration | Keeps the fixed-prior and recovery API independent of `DataProcessing` and `Sufficiency.KL`; generic `SemanticBridge.KL` remains transitively reachable through `Markov` |
| Proof-pressure API growth | Avoids speculative aliases, helper families, bundled structures, and symmetric theorem clutter |
| Compatibility aliases instead of active renames | Preserves downstream code while improving discovery only when examples justify it |
| Explicit entropy rewrites | Avoids choosing one arbitrary expanded/unexpanded entropy normal form through `[simp]` |
| Exact certificate decomposition | Keeps the trusted checker algebraic and kernel-verifiable |
| Untrusted certificate generation/import | External tools may propose data; Lean validates the result |

## 10. Rejected and Superseded Approaches

These should not be retried without new evidence or an explicit architecture
review.

- **Rejected:** `Probability := Rat` or bare rational-valued distributions.
  Entropy is generally real and probability normalization must be structural.
- **Rejected:** a measure-first public core for all finite use. Measures and
  kernels remain essential semantic bridges, not replacements for PMF-facing
  textbook APIs.
- **Rejected:** local redefinitions of binary entropy, q-ary entropy, KL,
  product measures, kernels, or Kraft-McMillan.
- **Rejected:** base-indexed copies of entropy, conditional entropy, MI, and
  CMI. Use `Shannon.Units`.
- **Rejected:** expected conditional formulas as the primary definitions.
  Algebraic entropy identities remain definitional; semantic equivalences are
  theorems.
- **Rejected:** assigning a canonical conditional distribution meaning to a
  null fiber. Total fallbacks are technical only.
- **Rejected for Chunk 3:** a project-local direct log-sum proof of KL DPI.
  The mathlib kernel chain rule was selected.
- **Rejected:** a second bundled channel representation or a public
  statistical-experiment object before repeated consumers require one.
- **Rejected:** marginal-only recovery as the definition or characterization
  of sufficiency.
- **Rejected:** inferring one family-wide recovery channel from unrelated
  pairwise KL-equality witnesses.
- **Rejected:** broad `[simp]` use for chain rules, symmetry, or entropy
  difference identities.
- **Rejected for now:** automatic primitive recognition, a certificate DSL,
  and external certificate import before the checked format receives more
  pressure.
- **Deferred rather than rejected:** splitting `InfoMeasures` or
  `Independence`, adding a product-channel constructor, general injective MI
  relabeling, generic posterior wrappers, and matrix channels.
- **[Superseded]** The original eight-chunk map bundled log-sum/DPI,
  sufficiency, doubly stochastic channels, and Fano differently. Actual chunk
  ownership in Section 8 is authoritative.

## 11. Known Limitations and Open Questions

### Mathematical gaps

- **Immediate:** finite Fano's inequality, including maintained binary/q-ary
  entropy bridges and error-probability corollaries.
- N-variable entropy/MI chain rules and concrete finite-family semantics.
- Standalone log-sum, KL joint convexity, entropy concavity, and MI
  concavity/convexity.
- Finite-simplex topology and continuity; global KL likely needs a
  lower-semicontinuity or support-stratified treatment rather than an
  unqualified continuity theorem.
- Pinsker-type divergence comparisons.
- Tensorization/single-letterization beyond current pair/triple results.
- Matrix-facing doubly stochastic/majorization/Birkhoff theory.
- Canonical and minimal sufficient statistics.
- General measurable sufficiency and larger iid/count-statistic examples.
- A direct bridge from the local finite conditional PMF to mathlib
  `ProbabilityTheory.condDistrib`.

### API gaps and unsettled contracts

- **[Uncertain]** Exact Chunk 5 theorem surface, module ownership, decoder
  representation, singleton-alphabet behavior, and binary/q-ary bridge names.
- **[Uncertain]** Finite-family representation: `Fin n`, named finite sets,
  vectors, dependent alphabets, or another structure.
- Whether `Shannon.InfoMeasures` should eventually split; it is currently
  large but coherent.
- Whether injective MI relabeling should be global or support-aware.
- Whether a general real-KL zero iff under an explicit `klDiv != top`
  hypothesis has enough consumers.
- Whether uniform-reference KL should support an infinite ambient type with a
  finite reference support.
- Whether posterior APIs need `[Finite]` wrappers or a public weighted
  fiber-KL expansion.
- Whether a generic common bind-recovery KL retraction theorem has an
  independent consumer.
- Whether a matrix compatibility bridge belongs in a new opt-in module.

### Lean and mathlib difficulties

- `ENNReal.toReal top = 0` makes unguarded real KL equality statements false or
  uninformative.
- Measure-theoretic theorems require careful local measurable-space,
  measurable-singleton, and kernel instances.
- Pointwise `PMF.map` and marginal formulas often require nontrivial support or
  finite-sum infrastructure.
- Support transport through `map`, `bind`, and channel composition is a
  recurring proof burden.
- Positive and null conditional fibers require separate reasoning.
- Kernel `compProd` rewrites and posterior equalities are sensitive to
  coordinate orientation and explicit intermediate equalities.
- On Windows, fresh Lean/Lake startup can be slow. This is an environment
  issue, not accepted proof debt.

### Assumptions possibly stronger than mathematically necessary

- `channelPosterior` exposes `[Fintype alpha]`.
- The finite Fisher-Neyman theorem assumes `[Finite alpha] [Nonempty alpha]`
  and finite `ENNReal` factor values. The normalization primarily consumes
  finiteness of the parameter-independent factor, but the public contract
  retains both factor-finiteness conditions.
- All-prior converses use a finite nonempty parameter alphabet to construct a
  full-support prior.
- Real KL equality and contraction theorems use support inclusion to exclude
  `top`.

These are intentional current contracts, not claims of maximal generality.

### Documentation gaps

- `docs/concept-note.md` has stale limitations for results completed in
  Chunks 2-4.
- `docs/roadmap.md` is accurate that Fano is next but its "Now" section is
  dominated by completed chunk narratives and begins with Chunk 2. The living
  summary should be the cross-thread orientation until the roadmap is
  streamlined.
- Full Lean doc-gen, theorem-level dependency data, and a blueprint PDF remain
  absent.
- A minimal contributor guide and beginner issue surface remain absent.

### Automation gaps

- No certificate search or coefficient solver.
- No primitive autotagging.
- No PSITIP/oXitip parser.
- No concrete PMF construction of `ShannonEntropyVal`.
- No theorem-level blueprint or doc-gen pipeline.

## 12. Active Work

### Current active chunk

**Project B Chunk 5: finite Fano.**

The approved execution plan is
[`docs/plans/chapter2-chunk-05.md`](plans/chapter2-chunk-05.md). Its 20 stable
steps are all not started, and each requires separate user authorization.

### Approved scope

- a finite decoder or estimator and its error event or indicator;
- bridges from project entropy to mathlib `Real.binEntropy` and
  `Real.qaryEntropy` as actually needed;
- the standard conditional-entropy Fano bound in nats;
- a weaker finite-alphabet corollary;
- the uniform-message error lower bound used in later converse arguments.

### Explicit non-scope

- no source- or channel-coding theorem;
- no channel capacity;
- no AEP, typicality, method of types, entropy rates, or stochastic-process
  hierarchy;
- no finite-family certificate semantics;
- no canonical/minimal sufficiency;
- no unrelated log-sum/convexity milestone.

### Current implementation status

- the detailed 20-step plan is approved, but no step has started;
- no Fano module or declaration exists;
- no maintained Bernoulli/q-ary entropy bridge exists;
- the existing conditional-entropy, entropy-bound, deterministic-processing,
  Markov, DPI, and sufficiency APIs are available foundations;
- an old ignored smoke proof reportedly related Bernoulli PMF entropy to
  `Real.binEntropy`, but it is not a tracked API and must not be treated as
  current evidence.

### First approved step

`C5.01` is a disposable contract and proof-feasibility spike with no tracked
source edit or production declaration. It tests the deterministic-decoder
contract, Boolean error convention, conditional-fiber route, and empty,
singleton, endpoint-error, and null-fiber cases. Any contract failure requires
a plan-health review before production work.

### Next review point

The next review point is the result of `C5.01`; passing it does not authorize
`C5.02` automatically. Naming, simp, module, and proof-pressure reviews remain
scheduled inside the approved chunk.

## 13. Future-Work Register

The detailed numbered register is in `docs/project-log.md`. At this baseline it
contains 40 notes: 39 active or standing and one closed historical note.
"Active" includes guardrails and proof-pressure triggers; it does not mean
"implement immediately." Each numbered note has exactly one primary category
below; relationships between categories are described without listing a note
again.

### Active near-term work

| Note | Work |
| --- | --- |
| 29 | **Partially completed Project B sequence.** Sufficiency is complete; the approved 20-step finite-Fano plan is the only immediate mathematical phase, and all of its steps remain not started. |

### Standing architecture and maintenance guardrails

| Notes | Guardrail |
| --- | --- |
| 2-4 | Split large files only when a real dependency boundary appears; keep core imports light; keep `MathlibFragments` opt-in. |
| 6, 8 | Upstream conservatively and re-audit mathlib after upgrades. |
| 14-16 | Preserve names during active work and retain the reviewed conservative simp policy; completed review events do not close these policies. |
| 17-18 | Run milestone checks and preserve completed chunk/module boundaries. |
| 26 | Do not split `SemanticBridge.Independence` solely because of file size. |

### Later Chapter 2 and finite-foundation work

| Note | Work |
| --- | --- |
| 1 | Choose and implement the finite-family entropy representation; later connect it to certificates. |
| 38 | **Partially discharged later milestone.** Permanent stochastic examples exercise the PMF-facing results; add a matrix bridge only when majorization/Birkhoff consumers exist. |
| 39 | Plan canonical/minimal sufficiency, support-aware statistic comparison, and later iid/count-statistic or measurable extensions. |
| Unnumbered | Assign standalone log-sum, KL convexity, entropy concavity, Pinsker, tensorization, topology, and continuity to later chunks before implementation. |

The inherited rough direction calls the finite-family phase Chunk 6, topology
and continuity Chunk 7, and selected extended fundamentals Chunk 8. Those
boundaries are **[Uncertain]** planning context, not approved execution plans.

### Broader information-theory work

| Note | Work |
| --- | --- |
| 5 | Add Kraft-McMillan and other coding material in a later coding layer. |

The active finite-Fano phase excludes channel powers, stationary processes,
entropy rates, capacity, AEP, typicality, method of types, source/channel
coding, and nontrivial network converses. These remain later roadmap work
rather than hidden parts of Chunks 5-8.

### Certificate work

| Note | Work |
| --- | --- |
| 7 | **Standing guardrail.** Keep PSITIP/oXitip-style infrastructure local unless upstream maintainers request otherwise. |
| 11 | Add independence, functional-dependence, and Markov certificate constraints after concrete converse pressure. |
| 12 | Add primitive recognition/autotagging only after larger manually tagged examples show the need. |
| 13 | Add external certificate import only after the internal checked format stabilizes; parsing remains untrusted. |

The crucial later bridge is a concrete finite-family construction showing that
actual joint random variables instantiate `ShannonEntropyVal`.

### Channel and Markov proof-pressure-deferred API work

| Note | Triggered question |
| --- | --- |
| 21 | Add a coherent injective MI relabeling family only after repeated augmentation proofs. |
| 25 | Add ordinary-independence conveniences only for concrete downstream proofs. |
| 27 | Add conditional-independence symmetry, closure, or representation conveniences only at their recorded consumer triggers. |

### Other proof-pressure-deferred API work

| Note | Triggered question |
| --- | --- |
| 19 | Promote the private deterministic-entropy decomposition only after a genuine second consumer. |
| 22 | Add a general real-KL zero iff under explicit `klDiv != top` only after repeated branch-elimination proofs. |
| 23 | Generalize uniform-reference KL to infinite ambient alphabets only when finite-support consumers need it. |
| 24 | Extract strict-Jensen equality infrastructure only after another extremization proof repeats it. |
| 30 | **Partially discharged.** `PMF.channelJoint_eq_iff_eq_on_support` was promoted; broader weighted null-fiber laws or opposite reconstruction orientation still require repeated use. |
| 31 | Add a product-channel constructor only after a second independent-channel consumer. |
| 32 | Add subtractive or reversed Markov information-loss forms only after quantitative proofs require them. |
| 33 | **Partially discharged.** The conditional-entropy DPI equality branches are complete; strict-loss variants remain consumer-deferred. |
| 34 | Keep stochastic-channel processing PMF-first until a natural random-variable coupling contract appears. |
| 35 | Keep finite KL equivalence relabeling private until a second caller needs it. |
| 36 | Keep bind-support monotonicity private until repeated production use. |
| 37 | Add `[Finite]` posterior wrappers or weighted fiber-KL expansions only after repeated consumers. |
| 40 | Add a generic common-bind-recovery KL retraction theorem only after an independent non-sufficiency consumer. |

### Possible mathlib upstreaming

- Generic PMF map, support, or finite-measure lemmas may be upstream candidates
  after their contracts stabilize.
- Re-run the semantic bridge audit on every mathlib upgrade before extending a
  local helper family.
- Substantial project-facing definitions should remain local until names,
  assumptions, and downstream use are stable.
- Certificate syntax and external import are not current upstream targets.

### Documentation and website work

| Note | Work |
| --- | --- |
| 9 | Add full Lean doc-gen, theorem-level leanblueprint, and eventually a blueprint PDF. |
| 10 | Add `CONTRIBUTING.md`, beginner tasks, issue labels, and upstream guidance before broad contributor outreach. |
| 28 | Later improve the side-information example pedagogy without changing existing declarations. |

Routine website redesign is not current work. Existing pages should be kept
accurate and regenerated after public Lean declarations or imports change.

### Speculative research directions

- topology and continuity of finite PMFs and support-sensitive KL;
- Pinsker and other divergence comparisons;
- tensorization and single-letterization;
- constrained entropy/MI extremization;
- canonical/minimal sufficiency and experiment comparison;
- matrix majorization and Birkhoff-von Neumann bridges;
- richer network converse certificate semantics.

These are not approved theorem tasks until assigned to a focused phase.

## 14. Completed, Superseded, or Obsolete Future Work

- **Note 20 is closed.** The proposed elementary MI example module was judged
  redundant; theorem pressure and API probes were sufficient.
- Partially discharged active entries and standing policies with completed
  review events remain in their single primary categories in Section 13.
- **[Superseded]** Earlier claims that semantic bridges, certificate
  validation, independence, DPI, or sufficiency were merely planned are
  historical only.
- **[Superseded]** The original eight-chunk boundaries are not current module
  ownership. See Sections 6 and 8.

## 15. Textbook and Reference Coverage

### Reviewed during this reconciliation

**Cover and Thomas, Elements of Information Theory, Chapter 2**

- Sections 2.1-2.6 were checked for entropy, conditional entropy, relative
  entropy, MI/CMI relationships, chain rules, Jensen consequences, equality
  cases, and alphabet bounds.
- Section 2.7 was checked for log-sum, KL convexity, entropy concavity, and
  channel-convexity topics that remain absent locally.
- Section 2.8 was checked for the Markov definition, DPI, deterministic
  processing, equality through the reverse chain, and the conditional
  corollary.
- Section 2.9 was checked for KL contraction, invariant distributions,
  doubly stochastic entropy growth, and the distinction between one-step laws
  and process-level claims.
- Section 2.10 was checked for sufficiency as a reverse Markov condition, MI
  preservation, and minimal sufficiency.
- Section 2.11 was checked for the error indicator, binary entropy term,
  conditional-entropy Fano bound, weaker cardinality bound, and error lower
  bound.

The coverage matrix in Section 6 follows this section order. The local project
uses nats rather than the textbook edition's default bits.

**Polyanskiy and Wu, Information Theory: From Coding to Learning**

- Section 3.5 was checked for prior-free recovery-channel sufficiency, the
  every-prior Markov/MI equivalences, Fisher factorization, and the two-law KL
  equality viewpoint.
- Section 6.3 was checked for finite prediction error, binary/q-ary entropy
  notation, Fano's inequality, randomized estimators, and later converse use.

### Historical reference inputs

Project records state that earlier design work also consulted:

- El Gamal and Kim, Chapter 2, for network-information-theory conventions;
- Yeung, Chapter 2, for entropy identities and the algebraic viewpoint used by
  certificates;
- Csiszar and Korner, early finite-alphabet/channel/divergence chapters;
- Rocq `infotheo`, PFR, and current mathlib APIs for formalization comparison.

These historical consultations inform rationale, but this summary does not
claim that every section of those books was reread at the current baseline.
Consult the exact relevant section when a future theorem depends on it.

### Copyright boundary

This document records topics, theorem families, and conventions only. It does
not reproduce textbook prose or proofs.

## 16. Validation State

### Current versions and validated source baseline

- Lean: `v4.30.0`
- mathlib input revision: `v4.30.0`
- mathlib manifest commit:
  `c5ea00351c28e24afc9f0f84379aa41082b1188f`
- validated Lean/source commit: `217e35c`; `master` and `origin/master` were
  synchronized when validation ran

### Most recent local validation

On 2026-07-24, with the current worktree's Lean source unchanged from that
validated source commit, the maintained ten-target command completed
successfully with 2,776 jobs:

```powershell
lake build LeanInfoTheory `
  LeanInfoTheory.Shannon.EntropyBounds `
  LeanInfoTheory.Shannon.Units `
  LeanInfoTheory.Shannon.SemanticBridge `
  LeanInfoTheory.MathlibFragments `
  LeanInfoTheory.Certificate.Submodularity `
  LeanInfoTheory.Certificate.Subadditivity `
  LeanInfoTheory.Certificate.Monotonicity `
  LeanInfoTheory.Certificate.ThreeWaySubadditivity `
  LeanInfoTheory.Examples
```

The Lean-source placeholder scan found no `sorry`, `admit`, `axiom`,
`opaque`, or `undefined`.

### Focused build policy

During theorem work, build the touched module and its important downstream
aggregate. Before a milestone, run the full suite above. The maintained
individual commands are listed in `AGENTS.md`.

### CI expectations and remote state

`.github/workflows/lean_action_ci.yml`:

1. regenerates and checks the website module/declaration artifacts;
2. runs the strict Lean placeholder scan;
3. invokes `leanprover/lean-action@v1` for the default project build;
4. explicitly builds entropy bounds, the semantic aggregate,
   `MathlibFragments`, four certificate demos, and `Examples`.

The GitHub Actions run for validated source baseline `217e35c` completed on
2026-07-23:

- build and placeholder check:
  `https://github.com/serhatemrecoban/LeanInfoTheory/actions/runs/30012026501`;
- website deployment:
  `https://github.com/serhatemrecoban/LeanInfoTheory/actions/runs/30012026200`.

**Open CI discrepancy:** the workflow's explicit opt-in list omits
`Shannon.Units`, although the local milestone suite includes it.

### Generated documentation and website checks

Use:

```powershell
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/check_website.py
```

Current generated state:

- 36 modules and 59 local import edges;
- 11 root-reachable and 25 separately importable modules;
- 686 public declarations and 0 undocumented declarations.

The deployed homepage, roadmap, module guide, and generated API-index HTML were
checked against their local `home_page/` files and matched exactly after line
ending normalization. The public site is:
`https://serhatemrecoban.github.io/LeanInfoTheory/`.

### Placeholder and trust restrictions

- No `sorry`, `admit`, unapproved `axiom`, `opaque`, or `undefined` in project
  Lean source.
- No external certificate parser or solver is part of the trusted core.
- Successful compilation does not by itself prove an API is appropriately
  scoped; module, support, null-fiber, and equality contracts still require
  review.

## 17. Guidance for Different Assistant Roles

### General Assistant

1. Read Sections 0-4, 8, 11-14, and 16.
2. Check current Git status, `origin/master`, current CI, and any new project
   log entries.
3. Perform periodic cross-thread reconciliation after chunks or architectural
   checkpoints without treating this role as exclusive ownership or a
   prerequisite for other project threads' materially justified edits.
4. Keep future-work status separate from immediate work.
5. Do not silently rewrite history or promote an uncertain plan.

### Chunk implementation assistant

1. Read `AGENTS.md`, Sections 0, 3, 6, 7, 9, 11, 12, and 16.
2. Read the owning source modules and direct imports before editing.
3. Read the exact textbook theorem family for the active step.
4. Use temporary proof spikes to validate difficult contracts, then delete
   them.
5. Run focused builds, audit new names under Note 14, update the log as
   requested, and run the full suite at the milestone.

### Proof-review assistant

1. Treat current source and the compiled theorem statement as primary.
2. Check support, `ENNReal.top`, null fibers, coordinate orientation,
   `Fintype` versus `Finite`, and local measurable assumptions.
3. Check whether private helper promotion or a new alias is truly justified.
4. Verify downstream consumers and missing edge-case tests.
5. Report findings before summaries, with file and line references.

### Documentation assistant

1. Read Sections 0, 1, 4-8, 11, and 16.
2. Use the generated declaration index for current names and paths.
3. Distinguish proved, reused from mathlib, demonstrated by an example,
   generated, planned, and speculative work.
4. Do not call the current dependency map theorem-level leanblueprint or the
   API index full doc-gen.
5. Regenerate and check website artifacts after public Lean import or
   declaration changes.

### Mathematical brainstorming assistant

1. Read Sections 2, 3, 6, 9-13, and 15.
2. Separate mathematical desirability from current Lean feasibility and
   module ownership.
3. Identify which current declarations a proposal reuses.
4. State edge cases and likely support/finiteness assumptions.
5. Mark alternatives as proposals until the project lead approves a plan.

## 18. Pointers to Detailed Historical Records

### Maintained documents

- [README](../README.md): public project status and module overview.
- [Agent instructions](../AGENTS.md): operational and naming rules.
- [Current Lean state](current-lean-state.md): detailed completed chunk and
  theorem status.
- [Project log](project-log.md): chronological implementation record and all
  40 numbered Future Work Notes.
- [Foundation conventions](foundation-conventions.md): stable mathematical and
  import conventions.
- [Roadmap](roadmap.md): public near-, medium-, and long-term milestones.
- [Semantic bridge design](semantic-bridge-design.md): original bridge design
  and conditional-law choices.
- [Semantic bridge API audit](semantic-bridge-api-audit.md): audited mathlib
  and local helper boundaries.
- [Blueprint overview](../blueprint/README.md): current generated-documentation
  scope and long-term blueprint layers.

### Generated references

- [Declaration index](../home_page/docs/declaration_index.json)
- [Module graph](../home_page/blueprint/module_graph.json)
- [Hand-written module guide](../home_page/module-guide.html)

### Phase checkpoints

- Pre-roadmap transition: `7855d0d`
- Chunk 1: `7ab3aa0`
- Chunk 2: `e5e9825`
- Chunk 3: `a5cc9e9`
- Chunk 4: `f990f2e`
- Chunk 5 handoff cleanup: `11e071c`
- Validated Lean/source baseline: `217e35c`

### Temporary historical inputs

The ignored reports
`tmp/codex-handoffs/pre-roadmap-inherited-context.md` and
`tmp/codex-handoffs/chunks-1-4-inherited-context.md` were reconciliation
inputs for this document. They are not canonical, may be deleted, and must
never override current source or maintained documentation.
