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

**[Current] Mathematical phase.** Project B is active. Cover--Thomas Chapter 2
Chunks 1-6 are checkpointed; `7b5f0db` is the last fully validated committed
Lean/source baseline. The approved Chunk 7 execution plan is
[`docs/plans/chapter2-chunk-07.md`](plans/chapter2-chunk-07.md), and all 22
steps are complete. The finite Section 2.7 scalar log-sum, finite-mixture,
entropy-concavity, KL joint-convexity/equality, and MI input/channel-convexity
surfaces, maintained examples, API review, generated references, public
documentation, and independent milestone validation all pass in the current
working tree. Chunk 7 is validated and checkpoint-ready but remains
uncommitted; it is not yet checkpointed, pushed, or deployed.

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
| Chunk 7 review or checkpoint preparation | The approved Chunk 7 plan; Sections 3, 6-9, 11-14, and 16; Future Work Notes 2-4, 9, 14-18, 24, 28, and 36; the four new production modules plus `Examples.Convexity` |
| Review of an existing Lean theorem | Sections 3, 7, 9, and 16; the owning source module and its direct imports |
| API or module review | Sections 7, 9, 10, 11, and Future Work Notes 2-4, 14-16, 18, and 26 |
| Certificate work | Sections 2, 5, 7, 11, and 13; `EntropyExpr`, `EntropyVal`, `PrimitiveIneq`, and `Certificate.Checked` |
| Documentation or website work | Sections 1, 4, 5, 7, 11, and 16; `AGENTS.md` website rules |
| Grant or project-description work | Sections 2, 5, 6, 8, 11, and 13; distinguish implemented work from plans |
| General Assistant maintenance | Read the whole summary, then reconcile the project log, roadmap, and current Git state |

## 1. Document Status

| Field | Value |
| --- | --- |
| Last updated | 2026-07-29 |
| Last fully validated committed Lean/source baseline | `7b5f0db83f188bf65454f5aa7dcd2fe8ee221146` |
| Repository transition state | Checked-in head `9aa3bb1258206fb24a3645115955be8501ea3e5e` is the documentation-only final Chunk 7 handoff above checkpoint `7b5f0db`; the current Chunk 7 implementation is independently validated through `C7.22` but remains an uncommitted working tree |
| Lean baseline | Lean `v4.30.0`, commit `d024af099ca4bf2c86f649261ebf59565dc8c622` |
| mathlib baseline | mathlib input revision `v4.30.0`, manifest commit `c5ea00351c28e24afc9f0f84379aa41082b1188f` |
| Current phase | Project B, Chunks 1-6 checkpointed; Chunk 7 complete and validated through `C7.22`, awaiting a coherent checkpoint |
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
- **[Superseded planning]** The original eight-chunk topic boundaries were
  revised by implementation. Conditional independence moved into Chunk 2;
  channels, DPI, and one-step doubly stochastic entropy growth moved into
  Chunk 3; sufficiency became Chunk 4. Use current source and Note 29, not the
  original labels, to assign ownership.

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
- dependent finite-family laws with finite `Finset` atoms, PMF/source entropy,
  conditional entropy, MI, CMI, pair/triple compatibility, and binary plus
  duplicate-tolerant ordered chain rules;
- deterministic entropy and mutual-information processing with support-aware
  equality/recovery cases;
- pair and triple inequality bands;
- finite-family monotonicity, submodularity, MI bounds, conditioning
  reduction, binary subadditivity, and n-way singleton subadditivity;
- alphabet- and support-cardinality entropy bounds with exact uniformity
  equality cases;
- opt-in logarithm-base conversion.

Representative owners are `Shannon.Entropy`, `Shannon.InfoMeasures`,
`Shannon.FiniteFamily`, `Shannon.EntropyBounds`, `Shannon.Units`,
`Shannon.SemanticBridge.Theorems`, and
`Shannon.SemanticBridge.FiniteFamily`.

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

### Finite Fano and estimation error

**[Current]** The opt-in finite Fano layer includes:

- `entropy_bool`, identifying project entropy on `PMF Bool` with mathlib
  `Real.binEntropy`;
- type-generic deterministic decoding-error indicator and probability
  definitions on joint PMFs and random variables;
- a finite-sum error formula, probability range bounds, and entropy identities
  for the Boolean error indicator;
- exact expanded and `Real.qaryEntropy` Fano inequalities on PMF and
  random-variable surfaces;
- the conventional weak finite-alphabet inequality;
- generic decoding-error lower bounds; and
- mutual-information and normalized-error lower bounds under a uniform source
  law.

The exact and weak entropy forms include singleton source alphabets. The
cardinality hypothesis `2 <= Fintype.card alpha` appears only in the
corollaries that divide by `log |alpha|`. The owners are
`Shannon.BinaryEntropy` and `Shannon.Fano`; both remain outside the lightweight
root and semantic-bridge aggregate.

### Certificate layer

**[Current]** The trusted checking path includes:

- entropy atoms and sparse rational entropy expressions;
- abstract Shannon entropy valuations;
- empty-entropy, conditional-entropy, and CMI primitive expressions;
- primitive soundness;
- raw and checked certificate structures;
- nonnegative checked coefficients and exact decomposition equality;
- raw-to-checked validation and validation-to-soundness theorems;
- concrete `finiteFamilyEntropyVal` and `finiteFamilyEntropyValOf`
  constructions satisfying the unchanged abstract contract;
- `Certificate.CheckedCert.sound_finiteFamily`, applying checked soundness to
  actual finite-family Shannon entropy without a new trust path;
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
  marginal-only recovery;
- a perfect decoder, a singleton source alphabet, and a fair Boolean source
  with a concrete nonzero decoding-error probability exercising the finite
  Fano API;
- homogeneous Boolean and heterogeneous Boolean/ternary finite families,
  ordered chains, overlapping entropy atoms, empty-family entropy, and
  distinct checked/raw certificate paths.

The website has a hand-written module guide, theorem highlights, certificate
demo, generated module dependency map, and source-derived declaration index.
It does not yet have full doc-gen or theorem-level leanblueprint output.

## 6. Cover-Thomas Chapter 2 Coverage Matrix

Status terms refer to the project's finite-discrete scope. "Complete" does not
claim a general measure-theoretic formalization of the whole subject.

| Topic | Status and provenance | Representative declarations | Owner and layer | Limitations, downstream use, and remaining work |
| --- | --- | --- | --- | --- |
| **2.1 Entropy** | **Substantially complete.** Core predates the eight-chunk programme; zero/equality and units were strengthened in Chunk 1; the maintained Boolean bridge is Chunk 5. | `entropy`, `entropyOf`, `entropy_nonneg`, `entropy_eq_zero_iff`, `entropyOf_eq_zero_iff`, `entropy_eq_integral_selfInfo`, `entropy_div_log`, `entropy_bool` | `Shannon.Entropy` is lightweight; semantic expectation, units, and `Shannon.BinaryEntropy` are opt-in. | Nats are canonical. The Boolean bridge reuses mathlib `Real.binEntropy`; no parallel binary-entropy definition is maintained. |
| **2.2 Joint and conditional entropy** | **Substantially complete for pairs, triples, and finite subfamilies.** Core and expected-fiber semantics predate the programme; functional dependence is Chunk 1; equality cases use Chunk 2 independence; finite-family atoms are Chunk 6. Chain-rule work is catalogued under 2.5. | `jointEntropyOf`, `condEntropy`, `familyEntropy`, `familyEntropyOf`, `familyCondEntropy`, `condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd`, `condEntropyOf_eq_zero_iff_exists_function` | Pair/triple algebra in lightweight `InfoMeasures`; dependent finite-atom algebra in opt-in `Shannon.FiniteFamily`; conditional PMFs and inequality/equality consequences in semantic modules. | `Var` may be infinite, alphabets may depend on the variable, and entropy is applied only after finite restriction. Null fibers use explicit zero or totality conventions. Family-level independence equality cases are deferred. |
| **2.3 Relative entropy and mutual information** | **Substantially complete at finite PMF level.** MI/KL bridges predate the programme; support/finiteness, equality, and uniform-reference results are Chunk 2; channel KL is Chunks 3-4; finite joint convexity is Chunk 7. | `mutualInfo`, `mutualInfo_eq_toReal_klDiv_joint_prod_marginals`, `toMeasure_absolutelyContinuous_iff_support_subset`, `klDiv_pmf_ne_top_iff_support_subset`, `klDiv_pmf_eq_zero_iff`, `toReal_klDiv_pmf_uniformOfFinset`, `klDiv_bind_le_sum` | `InfoMeasures` plus heavy `SemanticBridge.KL`, `DataProcessing`, and `SemanticBridge.Convexity`; KL itself is mathlib's `InformationTheory.klDiv`. | Real KL requires support/finiteness guards. No project-local generic conditional-relative-entropy object. |
| **2.4 Entropy/MI relationships** | **Complete for the finite pair and finite-atom algebraic surfaces.** Symmetry predates the programme; the pair identity family is Chunk 1; overlapping-atom family identities are Chunk 6. | `mutualInfoOf_eq_entropyOf_sub_condEntropyOf`, `mutualInfoOf_swap`, `mutualInfoOf_self`, `familyMutualInfo_eq_entropy_sub_condEntropy`, `familyCondMutualInfo_eq_condEntropy_sub_condEntropy` | Lightweight `Shannon.InfoMeasures` plus opt-in lightweight `Shannon.FiniteFamily`. | Rewrites remain explicit. Reverse-oriented aliases and exhaustive PMF/source mirrors are intentionally not generated without proof pressure. |
| **2.5 Chain rules** | **Substantially complete for finite entropy and MI.** Pair/triple rules predate or belong to Chunk 1; Chunk 6 adds binary-union and duplicate-tolerant ordered finite-family entropy/MI rules; mathlib's KL chain rule is reused in Chunk 3. | `entropy_chain_rule_left`, `condEntropyOf_pair_chain_rule`, `familyEntropy_union_chain_rule_right`, `familyEntropy_eq_entropyChain`, `familyMutualInfo_eq_mutualInfoChain`, `familyMutualInfo_chain_rule_of_nodup`, `klDiv_channel_eq_add_posterior` | Lightweight pair/triple and finite-family algebra plus heavy semantic/KL decomposition. | The list theorems permit repeated indices; `Nodup` corollaries expose the textbook enumeration. A binary/ordered conditional-MI family and a project-local relative-entropy chain-rule family remain deferred. |
| **2.6 Jensen and consequences** | **Substantially complete for currently used finite consequences.** Initial alphabet bounds predate the programme; sharp support/equality and pair independence endpoints are Chunks 1-2; finite-family monotonicity, submodularity, conditioning reduction, MI bounds, and n-way subadditivity are Chunk 6. | `entropy_le_log_card`, `entropy_eq_log_card_iff_eq_uniformOfFintype`, `familyEntropy_mono`, `familyEntropy_submodular`, `familyCondEntropy_union_le_condEntropy`, `familyEntropy_le_sum_singletons` | Jensen-heavy `EntropyBounds` is opt-in; family inequalities live in opt-in `SemanticBridge.FiniteFamily`; semantic equality cases remain heavier. | The project reuses mathlib Jensen/strict concavity rather than formalizing a local general Jensen theorem. Equality in n-way subadditivity and a family-level mutual-independence API are deferred. |
| **2.7 Log-sum and convexity applications** | **Implemented and independently validated for finite PMFs in Chunk 7.** The scalar, mixture, entropy, KL, and MI theorem layers are complete through `C7.22` in the validated but uncommitted working tree. | `logSum_inequality`, `logSum_eq_iff_exists_constant_ratio`, `real_logSum_inequality_of_support`, `sum_mul_entropy_le_entropy_bind`, `binaryMixture_entropy_eq_iff`, `klDiv_bind_le_sum`, `klDiv_binaryMixture_eq_iff`, `sum_mul_mutualInfo_channelJoint_le`, `mutualInfo_channelMixture_le_sum` | Scalar `Shannon.LogSum`; PMF construction in `Probability.FiniteMixture`; Jensen entropy layer in `Shannon.EntropyConcavity`; KL/MI results in heavy `SemanticBridge.Convexity`. All remain opt-in. | Canonical KL statements are `ENNReal`-valued; Real forms have active support guards. General-selector equality classifications, MI/channel equality cases, finite-family wrappers, topology, and continuity remain deferred. |
| **2.8 Data processing** | **Substantially complete for finite PMFs and finite-valued random variables.** Deterministic processing is Chunk 1; Markov and stochastic MI/KL DPI are Chunk 3; KL equality/recovery is Chunk 4. | `IsMarkovChainOf`, `mutualInfoOf_markov_chain_rule`, `mutualInfoOf_dataProcessing`, `mutualInfoOf_dataProcessing_eq_iff`, `klDiv_channel_le`, `toReal_klDiv_channel_le` | `SemanticBridge.Markov` and `DataProcessing` are opt-in; the raw channel core is lighter but still outside root. | No general measurable stochastic-variable coupling API. Strict-loss variants and some symmetric forms remain proof-pressure deferred. |
| **2.9 Second law / stochastic entropy growth** | **Partial.** One-step finite consequences are Chunk 3. | `klDiv_channel_invariant_le`, `toReal_klDiv_channel_invariant_le`, `entropy_le_entropy_bind_of_uniform_invariant`, `entropy_le_entropy_bind_of_doublyStochastic` | Heavy `SemanticBridge.DataProcessing`; examples in `Examples.StochasticChannels`. | No iterated channel powers, stationary-process object, entropy rate, matrix bridge, or Birkhoff/majorization theory. A matrix-facing bridge is deferred by Note 38. |
| **2.10 Sufficient statistics** | **Substantially complete for finite fixed-prior and finite family recovery.** Chunk 4. | `IsSufficientStatisticOf`, `IsSufficientChannel`, `IsSufficientStatistic`, `isSufficientStatisticOf_iff_exists_recovery`, `isSufficientChannel_iff_exists_common_posterior`, `isSufficientStatistic_iff_exists_fisherNeymanFactorization`, `klDiv_channel_eq_iff_exists_common_recovery` | Lightweight `Sufficiency`; posterior/KL statements in downstream heavy modules. | Canonical/minimal statistics, iid count-statistic infrastructure, and general measurable sufficiency are deferred. Larger-family pairwise KL equality does not yield a global witness. |
| **2.11 Fano's inequality** | **Substantially complete for finite deterministic decoding.** Chunk 5 through `C5.20`. | `decodingErrorIndicator`, `decodingErrorProbability`, `entropy_decodingErrorIndicator`, `condEntropy_fano`, `condEntropy_fano_qary`, `condEntropyOf_fano`, `condEntropy_fano_weak`, `decodingErrorProbability_fano_lower_bound`, `mutualInfo_fano_lower_bound_of_uniform_source` and their `...Of` companions | Opt-in `Shannon.BinaryEntropy` and `Shannon.Fano`; permanent consumers in `Examples.Fano`. | Exact and weak entropy forms include singleton alphabets; normalized error bounds require `2 <= |alpha|`. Equality/sharpness, randomized estimators, list decoding, and coding theorems remain later work. |

## 7. Current Lean Module and API Architecture

### Root and lightweight finite layer

| Module | Responsibility | Root-visible? |
| --- | --- | --- |
| `LeanInfoTheory.Basic` | Project namespace and status vocabulary | Yes |
| `LeanInfoTheory.Probability.Finite` | Reusable PMF real-mass, finite-bind, map, support, and pure-law helpers | Yes |
| `LeanInfoTheory.Shannon.Entropy` | Entropy, entropy of pushforwards, joint entropy, zero and relabeling facts | Yes, through `InformationMeasures` |
| `LeanInfoTheory.Shannon.InfoMeasures` | Marginals, conditional entropy, MI, CMI, random-variable forms, core rewrites | Yes, through `InformationMeasures` |
| `LeanInfoTheory.InformationMeasures` | Explicit convenience re-export from `Shannon` into `LeanInfoTheory` | Yes |
| `LeanInfoTheory.EntropyExpr` | Entropy atoms and sparse rational expressions | Yes |
| `LeanInfoTheory.EntropyVal` | Abstract Shannon entropy valuations | Yes |
| `LeanInfoTheory.PrimitiveIneq` | Primitive Shannon expressions and soundness | Yes |
| `LeanInfoTheory.Certificate` | Generic certificate combination and soundness skeleton | Yes |
| `LeanInfoTheory.Certificate.Checked` | Raw/checked certificates and validator | Yes |
| `LeanInfoTheory` | Lightweight public aggregate only | Root |

The tracked generated reference state now contains the 48 modules in the
validated Chunk 7 working tree: 11 are root-reachable and 37 are opt-in. The
root does not import bounds, units, finite-family or mixture modules,
log-sum/concavity modules, semantic bridges, channel modules, demos, examples,
or mathlib coding anchors.

### Opt-in finite and semantic layers

| Module | Responsibility |
| --- | --- |
| `LeanInfoTheory.Shannon.EntropyBounds` | Jensen-based alphabet/support bounds and exact uniform equality |
| `LeanInfoTheory.Shannon.Units` | Logarithm-base conversion |
| `LeanInfoTheory.Shannon.BinaryEntropy` | Boolean-PMF entropy bridge to mathlib `Real.binEntropy` |
| `LeanInfoTheory.Shannon.Fano` | Type-generic decoding error and finite exact/weak Fano inequalities and corollaries |
| `LeanInfoTheory.Shannon.FiniteFamily` | Dependent finite-family laws, finite-atom entropy/MI/CMI algebra, pair/triple compatibility, and binary/ordered chain rules |
| `LeanInfoTheory.Probability.FiniteMixture` | Binary PMF mixtures with `NNReal` weights and exact endpoint laws; general selectors use `PMF.bind` |
| `LeanInfoTheory.Shannon.LogSum` | Zero-safe `EReal` finite log-sum inequality/equality and guarded Real corollaries |
| `LeanInfoTheory.Shannon.EntropyConcavity` | General-selector entropy concavity and binary strict equality, proved directly by Jensen |
| `LeanInfoTheory.Probability.FiniteChannel` | Raw PMF channel constructions and elementary laws, with no Shannon/KL dependency |
| `LeanInfoTheory.Shannon.SemanticBridge.Product` | Independent product PMFs and product-measure bridges |
| `LeanInfoTheory.Shannon.SemanticBridge.FiniteSums` | Finite real-mass and log-ratio expansions |
| `LeanInfoTheory.Shannon.SemanticBridge.Conditional` | Positive conditional PMFs and expected fiber formulas |
| `LeanInfoTheory.Shannon.SemanticBridge.KL` | PMF KL support/equality/uniform-reference results and MI/CMI KL bridges |
| `LeanInfoTheory.Shannon.SemanticBridge.Theorems` | Nonnegativity, chain rules, processing, functional dependence, and inequality consequences |
| `LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` | Finite-family Shannon inequalities and concrete `ShannonEntropyVal` constructors |
| `LeanInfoTheory.Shannon.SemanticBridge.Independence` | Ordinary/conditional independence and equality characterizations |
| `LeanInfoTheory.Shannon.SemanticBridge.Markov` | Markov predicates, total conditional channel, factorization, MI DPI |
| `LeanInfoTheory.Shannon.SemanticBridge.Sufficiency` | Fixed-prior and family sufficiency core, directly importing `Markov` |
| `LeanInfoTheory.Shannon.SemanticBridge.DataProcessing` | PMF-kernel bridge, posterior KL decomposition, KL DPI, entropy growth |
| `LeanInfoTheory.Shannon.SemanticBridge.Sufficiency.KL` | Downstream exact-recovery and KL equality integration |
| `LeanInfoTheory.Shannon.SemanticBridge.Convexity` | Finite-selector and binary KL joint convexity/equality plus MI input/channel convexity |
| `LeanInfoTheory.Shannon.SemanticBridge` | Heavy semantic aggregate |

**[Decision] Dependency direction.**

```text
InfoMeasures -> Product / FiniteSums / Conditional
Product + FiniteSums + Conditional -> KL -> Theorems -> Independence
FiniteChannel + Independence -> Markov -> Sufficiency
Markov + Sufficiency + focused mathlib KL/kernel
    -> DataProcessing -> Sufficiency.KL
Entropy + mathlib binary entropy -> BinaryEntropy
BinaryEntropy + EntropyBounds + Theorems -> Fano
InfoMeasures + finite dependent-Pi support -> FiniteFamily
FiniteFamily + Theorems + EntropyVal -> SemanticBridge.FiniteFamily
Probability.Finite -> Probability.FiniteMixture
FiniteMixture + Entropy + finite Jensen -> EntropyConcavity
finite EReal/ENNReal log arithmetic + Jensen -> LogSum
FiniteMixture + EntropyConcavity + LogSum + KL/Product
    -> SemanticBridge.Convexity
```

The exact file graph is generated in
[`home_page/blueprint/module_graph.json`](../home_page/blueprint/module_graph.json).
New work should use the lightest owner whose statement and proof dependencies
justify it.

### Certificates, examples, and anchors

- `Certificate.Submodularity`, `Subadditivity`, `Monotonicity`, and
  `ThreeWaySubadditivity` are opt-in checked-certificate demonstrations.
- `Certificate.FiniteFamily` is an opt-in adapter from existing checked
  soundness to concrete finite-family Shannon entropy; it adds no validation
  path or trusted assumption.
- `Examples.SupportSensitive`, `KLTop`, `CommonCause`,
  `StochasticChannels`, `SufficientStatistics`, `Fano`, `FiniteFamily`, and
  `Convexity` are separately importable. `Examples.Convexity` contains only
  private maintained regression consumers.
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

For the completed Chunk 6 checkpoint, the tracked regenerated references
report:

- module graph input: 43 modules, 75 local edges, 11 root-reachable, 32 opt-in;
- reviewed declaration surface: 834 public declarations, all documented.

`C6.23` corrected nested ordinary block-comment handling, removed the false
`Certificate.FiniteFamily.to` candidate, and regenerated both reference sets
twice with byte-identical second passes. All declaration links, anchors,
module summaries, JSON structure, and website links pass their checks.

For the validated Chunk 7 working tree, the regenerated references report 48
modules, 90 local edges, 11 root-reachable modules, 37 opt-in modules, and 862
documented source declarations. The 28-declaration increase is four
finite-mixture, nine log-sum, three entropy-concavity, eleven semantic
convexity, and one lightweight finite-bind declaration. Both generators are
byte-stable on a second pass, and the source-line, anchor, module-summary, JSON,
and website checks pass.

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
| 5 | `ec78829` | Finite Fano and estimation error | Boolean entropy bridge, type-generic deterministic error, exact/q-ary/weak Fano, error and uniform-source corollaries, permanent examples, API freeze |
| 6 | `7b5f0db` | Finite families and concrete entropy valuations | Complete and independently validated: dependent finite-atom entropy/MI/CMI, binary and ordered chain rules, Shannon inequalities, concrete valuation, certificate adapter, permanent examples, generated references, and full milestone closeout |
| 7 | Working tree above `9aa3bb1` | Finite log-sum and convexity | Implemented and API-reviewed through `C7.20`: zero-safe scalar LS3, finite mixtures, entropy concavity/equality, KL joint convexity/equality, MI input/channel convexity, and private maintained examples; generated references and independent closeout remain pending |

Cleanup checkpoints `e72e68c`, `7de8ff5`, and `11e071c` reconciled
post-chunk documentation and prepared the Chunk 5 handoff. Commits `cb8eb6b`
and `2413cb1` consolidated project memory, approved the detailed Chunk 5 plan,
and adopted shared living-summary ownership without changing Lean source.

### Checkpointed Chunk 5 implementation

**[Current]** The approved plan has completed `C5.01` through `C5.20`.
`Shannon.BinaryEntropy`, `Shannon.Fano`, and `Examples.Fano` now exist in the
checkpointed source, with 25 core public declarations and six example
declarations.
`C5.17` froze their names, simp policy, and import boundaries without adding an
alias. C5.19 regenerated and checked the source-derived references and
reconciled the hand-written finite-Fano status prose. C5.20 then passed the
focused and complete milestone builds, guarded boundary consumers, axiom and
placeholder audits, repeated generated-reference checks, website checker, and
final repository hygiene. Commit `ec78829` is the coherent Chunk 5 checkpoint.

### Checkpointed Chunk 6 implementation

**[Current]** The approved 24-step plan has completed `C6.01` through
`C6.24`. `Shannon.FiniteFamily` provides the 68-declaration lightweight
dependent-family core. `Shannon.SemanticBridge.FiniteFamily` adds 30
declarations covering the Shannon inequality band and concrete
`ShannonEntropyVal` constructors. `Certificate.FiniteFamily` adds one checked-
soundness adapter, and `Examples.FiniteFamily` adds 18 explicit declarations
that exercise homogeneous and dependent alphabets plus checked and raw
certificate paths.

`C6.21` froze names, simp policy, helper visibility, and import boundaries.
`C6.22` reconciled canonical project memory, `C6.23` regenerated and checked
the public references, and `C6.24` passed the focused, ten-target, default-
build, consumer, axiom, placeholder, website, and hygiene gates. Commit
`7b5f0db` is the coherent Chunk 6 Lean/source checkpoint.

### Active Chunk 7 implementation

**[Current]** The approved 22-step plan has completed source implementation,
maintained examples, and API/import review through `C7.19`; `C7.20` is this
canonical reconciliation. `Probability.FiniteMixture`, `Shannon.LogSum`,
`Shannon.EntropyConcavity`, `Shannon.SemanticBridge.Convexity`, and
`Examples.Convexity` now exist in the uncommitted working tree. They add 27
public declarations, while the independently pressured
`PMF.bind_toReal_apply` bridge adds the twenty-eighth declaration in the
existing lightweight `Probability.Finite` owner.

Both proof-complete feasibility gates passed. The scalar API handles empty and
singleton finsets, all-zero and `0/0` data, zero-over-positive,
positive-over-zero, mixed finite/`top`, and common-ratio equality at zero,
finite values, and `top`. The binary KL equality API uses interior weights,
component support inclusion, and a division-free pointwise cross-product
condition. Forty-six private maintained examples exercise these contracts,
mixture endpoints and proof irrelevance, inactive infinite KL, and the four MI
input/channel theorem forms.

`C7.19` retained the public names and module boundaries, added only the
evidence-supported finite-bind bridge, marked only the exact binary mixture
endpoint laws `[simp]`, and kept representation-changing pointwise and chain
rules explicit. The focused nine-target build passed with 2,780 jobs, direct
and root-isolation consumers passed, representative axioms were limited to
`propext`, `Classical.choice`, and `Quot.sound`, and placeholder/scratch/
whitespace/diff checks were clean. `C7.21` subsequently regenerated and checked
the public references, and `C7.22` independently passed the direct and complete
milestone builds, boundary and trust audits, website checks, and repository
hygiene. The chunk is complete and validated but remains uncommitted.

## 9. Stable Design Decisions and Rationale

| Decision | Rationale to preserve |
| --- | --- |
| Use mathlib `PMF` | Enforces probability laws, integrates with measures/kernels, and avoids a mathematically inadequate rational toy model |
| PMF-first finite API | Makes finite sums, examples, pushforwards, and textbook statements tractable while retaining measure semantics downstream |
| Entropy in `Real`, nats first | Matches `Real.negMulLog`, `Real.log`, and mathlib binary/q-ary entropy; base conversion needs no duplicate hierarchy |
| Type-generic decoding-error definitions | Equality is chosen internally; finiteness belongs only on finite sums and entropy theorems that need enumeration |
| Singleton-inclusive exact Fano | The exact and weak entropy bounds need no artificial `2 <= |alpha|`; that hypothesis appears only when division by `log |alpha|` requires positivity |
| Pushforward definition of random-variable quantities | Keeps laws distributional and makes relabeling/marginals compositional |
| Dependent finite-family law with `Finset` atoms | Supports heterogeneous alphabets and an infinite variable-name type while taking entropy only after finite restriction |
| Finite mixtures through `PMF.bind`, binary weights through `NNReal` | Reuses mathlib probability structure, keeps general selectors reusable, and matches `PMF.bernoulli` without a parallel simplex type |
| Zero-safe scalar log-sum in `EReal` | Represents positive-over-zero by `top`, keeps `0/0` inactive, and supports an exact equality statement without silently strengthening support assumptions |
| Separate direct-Jensen entropy concavity | Avoids an unnecessary dependency from the entropy layer to scalar log-sum while preserving the textbook finite proof |
| Ordered chains over `List Var` | Gives textbook prefix sums, permits repeated names in the stronger theorem, and reserves `Nodup` for presentation corollaries |
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
| Concrete family valuation before certificate adaptation | Proves the Shannon assumptions semantically, then lets the unchanged checked-certificate theorem consume that valuation |
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

- Equality conditions and sharpness for finite Fano, randomized-estimator and
  list-decoding variants, and coding-theorem applications of the completed
  deterministic-decoder inequality.
- N-way independence and equality cases for the completed finite-family
  subadditivity surface; binary or ordered conditional-MI chain rules.
- General-selector equality classifications for log-sum-derived entropy/KL
  results, MI input/channel equality cases, and finite-family wrappers for the
  completed PMF-first convexity API remain intentionally deferred.
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

- **[Decision]** The approved Chunk 6 finite-family representation uses an
  arbitrary decidable variable-name type `Var`, dependent pointwise-finite
  alphabets `alpha : Var -> Type`, a full joint `PMF` on
  `forall i, alpha i`, and finite atoms `Finset Var`. It does not assume
  `[Fintype Var]` and applies entropy only to finite marginals. The production
  core and semantic declarations are implemented and API-frozen through
  `C6.21`.
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
- Fano's exact and weak entropy forms require finite source and observation
  value alphabets but no cardinality lower bound. Error bounds that divide by
  `log |alpha|` require `2 <= Fintype.card alpha`; uniform-source statements
  use the existing `PMF.uniformOfFintype` contract and therefore expose
  `[Nonempty alpha]`.

These are intentional current contracts, not claims of maximal generality.

### Documentation gaps

- Full Lean doc-gen, theorem-level dependency data, and a blueprint PDF remain
  absent.
- A minimal contributor guide and beginner issue surface remain absent.

### Automation gaps

- No certificate search or coefficient solver.
- No primitive autotagging.
- No PSITIP/oXitip parser.
- No theorem-level blueprint or doc-gen pipeline.

## 12. Active Work

### Current phase status

**Project B Chunk 7 is complete and independently validated through `C7.22`,
but remains uncommitted and is not yet checkpointed.**

Chunks 5 and 6 remain checkpointed as `ec78829` and `7b5f0db`. The current
checked-in head is documentation-only handoff commit `9aa3bb1`; the Chunk 7
source is an uncommitted working tree above it. The approved execution plan is
[`docs/plans/chapter2-chunk-07.md`](plans/chapter2-chunk-07.md).

### Frozen Chunk 7 implementation

- `Shannon.LogSum` implements the canonical zero-safe `EReal` finite log-sum
  inequality/equality API and coherent support-guarded Real corollaries.
- `Probability.FiniteMixture` supplies the binary textbook PMF construction;
  general finite-selector mixtures remain `PMF.bind`.
- `Shannon.EntropyConcavity` proves general-selector entropy concavity
  directly by Jensen and the binary interior equality iff the component PMFs
  are equal.
- `Shannon.SemanticBridge.Convexity` proves canonical `ENNReal` and guarded
  Real KL joint convexity, the binary support-aware equality iff pointwise
  cross-product law, a channel entropy identity, MI input-law concavity, and
  MI channel convexity.
- `Probability.Finite` now contains the pressure-justified
  `PMF.bind_toReal_apply` bridge. It is root-visible through the existing
  import but adds no root edge.
- `Examples.Convexity` contains 46 private maintained examples; the four
  production modules and example module remain opt-in.
- `C7.19` retained names and import boundaries, promoted only binary mixture
  endpoint normalization to `[simp]`, and passed the focused nine-target,
  consumer, root-isolation, representative axiom, placeholder, and hygiene
  checks.
- `C7.20` reconciled current-facing hand-maintained project memory; `C7.21`
  regenerated and checked the source-derived references and public pages.
- `C7.22` passed the direct-owner and full maintained milestone builds,
  positive and guarded negative boundary consumers, the 26-theorem axiom
  manifest, strict placeholder scan, repeated generators, website checker,
  source/index audits, and repository-hygiene gates.

### Next repository action

Create one coherent checkpoint for the validated but uncommitted Chunk 7
working tree. Do not describe it as checkpointed, pushed, or deployed until
those operations are independently completed and verified.

### Next review point

After the checkpoint, choose any later Chapter 2, certificate, or maintenance
phase through a separate bounded readiness and approval process. Chunk 7
closeout does not authorize that scope. Deferred Future Work remains governed
by its recorded pressure triggers rather than becoming automatic checkpoint
work.

## 13. Future-Work Register

The detailed numbered register is in `docs/project-log.md`. At this baseline it
contains 40 notes: 38 active or standing and two closed historical notes.
"Active" includes guardrails and proof-pressure triggers; it does not mean
"implement immediately." Each numbered note has exactly one primary category
below; relationships between categories are described without listing a note
again.

### Active near-term work

| Note | Work |
| --- | --- |
| Unnumbered | **Chunk 7 checkpoint.** The implementation and all `C7.01`--`C7.22` validation gates are complete; create a coherent checkpoint before beginning a separately approved later phase. |
| 29 | **Finite-Fano phase checkpointed.** Commit `ec78829` completes the approved phase; its evidence-based Fano follow-ups remain open and deferred. |

Note 29 also preserves proof-pressure triggers from `C5.08`-`C5.11` and
`C5.13`, together with the `C5.16` pedagogy/sharpness follow-ups. They are
later work, not reasons to expand the frozen Chunk 5 API retroactively.

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
| 38 | **Partially discharged later milestone.** Permanent stochastic examples exercise the PMF-facing results; add a matrix bridge only when majorization/Birkhoff consumers exist. |
| 39 | Plan canonical/minimal sufficiency, support-aware statistic comparison, and later iid/count-statistic or measurable extensions. |
| Unnumbered | Chunk 7 now owns finite log-sum, KL convexity, entropy concavity, and MI input/channel convexity. Assign Pinsker, tensorization, topology, continuity, and any broader equality/generalization layer to later focused phases before implementation. |

The finite-family phase is complete, independently validated, and checkpointed
as `7b5f0db`. Chunk 7 explicitly excludes topology and continuity. Their
inherited rough chunk assignment and the assignment of selected extended
fundamentals to Chunk 8 remain **[Uncertain]** planning context rather than
approved execution plans.

### Broader information-theory work

| Note | Work |
| --- | --- |
| 5 | Add Kraft-McMillan and other coding material in a later coding layer. |

The completed finite-Fano theorem layer excludes channel powers, stationary
processes, entropy rates, capacity, AEP, typicality, method of types,
source/channel coding, and nontrivial network converses. These remain later
roadmap work rather than hidden parts of Chunks 5-8.

### Certificate work

| Note | Work |
| --- | --- |
| 7 | **Standing guardrail.** Keep PSITIP/oXitip-style infrastructure local unless upstream maintainers request otherwise. |
| 11 | Add independence, functional-dependence, and Markov certificate constraints after concrete converse pressure. |
| 12 | Add primitive recognition/autotagging only after larger manually tagged examples show the need. |
| 13 | Add external certificate import only after the internal checked format stabilizes; parsing remains untrusted. |

Chunk 6 has completed the previously crucial bridge: actual finite-family
joint laws now instantiate `ShannonEntropyVal`, and checked certificates can
be interpreted through that concrete valuation. Richer certificate
constraints and external import remain deferred under Notes 11--13.

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
| 9 | Add full Lean doc-gen, theorem-level leanblueprint, and eventually a blueprint PDF; later consider a structured source for repeated status fragments and complete verified module-summary metadata. |
| 10 | Add `CONTRIBUTING.md`, beginner tasks, issue labels, and upstream guidance before broad contributor outreach. |
| 28 | Later improve opt-in example pedagogy: the side-information recovery example, `KLTop` absolute-continuity notation, and, only if compact, matched numerical Boolean examples exhibiting strict MI input concavity and channel convexity. Preserve existing declarations and avoid new core helpers solely for pedagogy. |

Routine website redesign is not current work. Existing pages should be kept
accurate and regenerated after public Lean declarations or imports change.
C5.19 completed the Chunk 5 refresh; `C6.23` completed the Chunk 6 refresh;
`C7.21` completed the corresponding Chunk 7 refresh without redesigning the
site.

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

- **Note 1 is closed.** Chunk 6 implemented and independently validated the
  accepted dependent finite-family representation, concrete
  `ShannonEntropyVal`, checked-certificate adapter, examples, generated
  references, and milestone closeout. The note remains as representation and
  architecture rationale; it does not authorize a later chunk.
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
- Section 2.7 was checked for finite log-sum, KL joint convexity, entropy
  concavity, mutual-information concavity in the input law, and convexity in
  the channel. Chunk 7 implements this finite PMF scope; topology and
  continuity are explicitly outside it.
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
- last fully validated committed Lean/source baseline: `7b5f0db`
- documentation-only handoff commits `72f9f87` and current checked-in head
  `9aa3bb1` sit above that checkpoint without changing the validated
  Lean/source baseline
- the current Chunk 7 implementation is independently validated through
  `C7.22` but remains uncommitted and is not yet a source checkpoint

### Most recent local validation

On 2026-07-29, `C7.22` independently completed Chunk 7 validation. The direct
owner/example build passed with 2,704 jobs:

```powershell
lake build LeanInfoTheory.Probability.Finite `
  LeanInfoTheory.Probability.FiniteMixture `
  LeanInfoTheory.Shannon.LogSum `
  LeanInfoTheory.Shannon.EntropyConcavity `
  LeanInfoTheory.Shannon.SemanticBridge.Convexity `
  LeanInfoTheory.Examples.Convexity
```

The complete maintained ten-target milestone suite passed with 2,789 jobs.
Direct owner and aggregate consumers exercised all 28 new public declarations;
guarded root and private-helper consumers confirmed the intended boundaries.
All 26 new theorems reported only `propext`, `Classical.choice`, and
`Quot.sound`. The strict placeholder scan, exact declaration/source/anchor and
simp/import audits, twice-repeated byte-stable generators, website checker,
conflict-marker and disposable-probe scans, and final diff/hygiene checks all
pass. The generated references contain 48 modules, 90 local edges, 11
root-reachable modules, 37 opt-in modules, and 862 documented source
declarations. This validates the incremental uncommitted working tree; it does
not establish a commit or remote deployment.

On 2026-07-28, `C6.24` independently completed Chunk 6 validation. The six-
target focused build passed with 2,770 jobs:

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily `
  LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily `
  LeanInfoTheory.Certificate.FiniteFamily `
  LeanInfoTheory.Examples.FiniteFamily `
  LeanInfoTheory.Shannon.SemanticBridge `
  LeanInfoTheory.Examples
```

The maintained ten-target suite passed with 2,783 jobs, and default
`lake build` passed with 2,240 jobs. Positive direct-import consumers exercised
the lightweight core, semantic aggregate, certificate adapter, and examples
aggregate over infinite and empty index types, dependent heterogeneous
alphabets, empty/singleton/overlapping atoms, duplicate list entries,
arbitrary sources, concrete entropy valuation, and checked/raw certificate
paths. Six guarded negative consumers confirmed root and intermediate
aggregate isolation, private chain-helper visibility, and the absence of a
global example `Fintype` instance.

The strict placeholder scan was clean. A mechanical audit of all 89 new public
theorems reported only `propext`, `Classical.choice`, and `Quot.sound`. Both
generators were byte-idempotent; semantic checks confirmed 43 modules, 75 local
edges, 11 root-reachable modules, 32 opt-in modules, and 834 documented
declarations; and the website checker passed for 12 HTML files and two JSON
files. Root, imports, tracked textbooks, scratch files, generated artifacts,
whitespace, and the complete diff passed the final hygiene review. The pass
used the existing incremental cache rather than a cold release build.

On 2026-07-27, `C6.01` compiled an ignored disposable contract spike with
`lake env lean` and then deleted it. The check elaborated the approved
dependent-family representation for infinite and empty index types,
heterogeneous pointwise-finite alphabets, finite restrictions, repeated list
indices, and the exact `ShannonEntropyVal` field shapes. It changed no
production Lean source and therefore is feasibility evidence, not a new broad
milestone build.

On 2026-07-25, C5.20 passed the focused builds for
`Shannon.BinaryEntropy` (2,233 jobs), `Shannon.Fano` (2,702 jobs),
`Examples.Fano` (2,703 jobs), `Examples` (2,764 jobs), and the lightweight
root (2,240 jobs). The complete ten-target milestone suite passed with 2,779
jobs, and the default `lake build` passed with 2,240 jobs.

Disposable positive consumers exercised all 31 Chunk 5 declarations. Guarded
negative consumers confirmed the BinaryEntropy/Fano, Fano/examples,
private-helper, and lightweight-root boundaries. Axiom output for all 31
declarations contained only `propext`, `Classical.choice`, and `Quot.sound`.
The strict project-source placeholder scan was clean. All temporary consumers
were deleted.

Both generators were run again and reproduced all four artifact hashes byte
for byte. The website checker passed for 12 HTML files and two generated JSON
files. Final source, import, diff, temporary-file, process, textbook-file, and
whitespace hygiene checks found no unexplained artifact.

On 2026-07-25, C5.19 regenerated both source-derived reference sets twice with
byte-identical results. The website checker passed for 12 HTML files and two
generated JSON files, and the scoped diff-hygiene check passed.

On 2026-07-24, the `C5.18` documentation-only source rebuild completed
successfully with 2,764 jobs:

```powershell
lake build LeanInfoTheory.Shannon.Fano `
  LeanInfoTheory.Examples.Fano `
  LeanInfoTheory.Examples
```

The preceding `C5.17` API-freeze build completed successfully with 2,768 jobs:

```powershell
lake build LeanInfoTheory.Shannon.BinaryEntropy `
  LeanInfoTheory.Shannon.Fano `
  LeanInfoTheory.Examples.Fano `
  LeanInfoTheory.Examples `
  LeanInfoTheory
```

The current complete ten-target milestone suite was run on the final Chunk 5
working tree and completed with 2,779 jobs:

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

### Focused build policy

During theorem work, build the touched module and its important downstream
aggregate. Before a milestone, run the full suite above. The maintained
individual commands are listed in `AGENTS.md`; C5.20 completed the Chunk 5
assignment and C6.24 completed the Chunk 6 assignment.

### CI expectations and remote state

`.github/workflows/lean_action_ci.yml`:

1. regenerates and checks the website module/declaration artifacts;
2. runs the strict Lean placeholder scan;
3. invokes `leanprover/lean-action@v1` for the default project build;
4. explicitly builds entropy bounds, units, the semantic aggregate,
   `MathlibFragments`, four certificate demos, and `Examples`.

The GitHub Actions run for validated source baseline `217e35c` completed on
2026-07-23:

- build and placeholder check:
  `https://github.com/serhatemrecoban/LeanInfoTheory/actions/runs/30012026501`;
- website deployment:
  `https://github.com/serhatemrecoban/LeanInfoTheory/actions/runs/30012026200`.

The July 26 post-checkpoint handoff adds `Shannon.Units` to that explicit
workflow list. The final cleanup requires a successful remote workflow run
after push; that operational result does not redefine the validated Lean/source
baseline.

### Generated documentation and website checks

Use:

```powershell
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/check_website.py
```

The currently tracked generated Chunk 7 artifacts record:

- 48 modules and 90 local import edges;
- 11 root-reachable and 37 separately importable modules;
- 862 public source declarations and 0 undocumented declarations.

`C6.23` corrected nested ordinary block-comment handling, so prose in
`Certificate.FiniteFamily` no longer creates a false declaration candidate.
`C7.21` retained that parser fix while adding curated Chunk 7 module metadata
and regenerating both reference sets. `C7.22` reproduced all four artifact
hashes on the second pass and rechecked counts, source links, unique anchors,
module summaries, root reachability, and website consistency.
Deployment status is checked from the Pages workflow after push rather than
inferred from local content. The public site is:
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
- [Chunk 5 plan](plans/chapter2-chunk-05.md): approved step contracts and
  implementation outcomes for the completed finite-Fano phase.
- [Chunk 6 plan](plans/chapter2-chunk-06.md): approved finite-family,
  concrete-valuation, and checked-certificate implementation sequence.
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
- Shared canonical-memory policy: `2413cb1`
- Chunk 5 implementation and validated Lean/source baseline: `ec78829`
- Chunk 6 implementation and validated Lean/source baseline: `7b5f0db`

### Temporary historical inputs

The ignored reports
`tmp/codex-handoffs/pre-roadmap-inherited-context.md` and
`tmp/codex-handoffs/chunks-1-4-inherited-context.md` were reconciliation
inputs for this document. They are not canonical, may be deleted, and must
never override current source or maintained documentation.
