# Chapter 2 Chunk 8: Finite Conditional KL, Conditional CMI, And Mutual Independence

**Plan status:** Complete; independently validated in the working tree
**Baseline commit:** `a27ef8d429d8aa5f0d707817cea9586c07118719`
**Preceding Chunk 7 Lean/source checkpoint:** `5e616d805649f6aa39c380f55e14a5d933fb6b2f`
**Plan path:** `docs/plans/chapter2-chunk-08.md`
**Number of steps:** 24
**Execution status:** `C8.01`--`C8.24` complete

The baseline is the clean checked-in commit titled
`Finalize Project B Chunk 8 handoff`. The preceding validated source
checkpoint is `Complete Project B Chunk 7`. At plan creation, `HEAD`,
`master`, and `origin/master` point to the baseline; the tracked working tree
is clean before this plan is added; and the Chunk 7 checkpoint is an ancestor
of the baseline.

Twenty-four steps are appropriate because the accepted contract has two
independent proof-complete feasibility gates, a separately reviewed
lightweight conditional-CMI block, five production conditional-KL stages, four
production mutual-independence stages after its predicate foundation, distinct
workstream checkpoints, two maintained example stages, an evidence-driven API
review, focused integration, canonical-memory reconciliation, generated public
documentation, and independent closeout. The gates are deliberately large
enough to prove the hard contracts rather than merely elaborate signatures.
The later steps remain small enough to review assumptions, public API growth,
and import effects independently.

## Chunk Objective

Close the remaining finite algebraic gaps in Cover--Thomas Sections 2.5--2.8
under the project's established finite-PMF conventions by providing:

- a canonical common-base channel-level conditional relative entropy;
- its unconditional finite weighted-fiber semantics;
- the unconditional finite joint KL chain rule and support-guarded Real forms;
- exactly four conditional finite-family mutual-information chain rules;
- finite mutual-independence predicates for dependent alphabets;
- empty, singleton, restriction, and pair-compatibility results;
- the equality characterization for n-way entropy subadditivity;
- maintained examples, reviewed opt-in APIs, reconciled project memory, and
  independent validation.

Chunk 8 introduces no new Section 2.8 theorem. Its new mathematics closes the
remaining finite algebraic work in Sections 2.5--2.6. The final Sections
2.5--2.8 closeout claim combines this work with the already completed Section
2.7 convexity package and Section 2.8 data-processing package.

The only approved completion claim is:

> The finite algebraic gaps in Cover--Thomas Sections 2.5--2.8 are closed.

This does not claim that all of Chapter 2 is complete.

## Approved Scope

### Conditional relative entropy

For a base law and two PMF-valued channels,

```text
r : PMF alpha
W V : alpha -> PMF beta
```

the canonical object is the KL divergence between the two joint laws with the
same base:

```text
conditionalKlDiv r W V :=
  InformationTheory.klDiv
    (PMF.channelJoint r W).toMeasure
    (PMF.channelJoint r V).toMeasure
```

The definition uses only the measurable-space assumptions needed for the two
PMF measures to elaborate. It does not require finiteness or measurable
singletons merely because later finite theorems do.

The public theorem surface contains:

- self-divergence;
- the unconditional finite `ENNReal` weighted-fiber formula;
- the unconditional finite two-base joint KL chain rule;
- a support-guarded Real weighted formula;
- a support-guarded Real joint KL chain rule.

Public support extensionality is not guaranteed. It may be proposed only after
maintained consumers demonstrate value. Any accepted theorem must be
two-sided in the channels and expressed on the base PMF support.

### Conditional finite-family mutual information

The lightweight API receives exactly four initial public declarations:

- a binary law-facing chain rule;
- a binary source-family chain rule;
- an ordered law-facing chain rule;
- an ordered source-family chain rule.

The ordered theorem permits duplicate variable names. The atoms may overlap,
and a listed name may already lie in the initial conditioning atom. No
`List.Nodup`, symmetry, permutation, reverse-orientation, or alias family is
included.

### Finite mutual independence

For a full dependent-family law

```text
q : PMF ((i : Var) -> alpha i)
s : Finset Var
```

mutual independence is pointwise factorization of `familyMarginal q s` into
the product of its coordinate marginals. The public surface contains:

- a law-facing predicate;
- a source-family predicate through `familyLawOf`;
- law-facing empty and singleton theorems;
- a law-facing restriction-to-subsets theorem;
- one source-facing distinct-index compatibility theorem with
  `IsIndependentOf`;
- a law-facing entropy-additivity iff mutual-independence theorem;
- a source-family entropy-additivity iff mutual-independence theorem.

There are no automatic source wrappers for empty, singleton, or subset laws.
The corresponding law-facing pair compatibility is exercised through a
private maintained consumer rather than added to the initial public API.

## Explicit Non-goals

- A two-base conditional-KL definition.
- A conditional-KL object attached to an arbitrary joint law through total
  conditional fibers.
- Conditional-KL equality characterizations, continuity, topology, lower
  semicontinuity, or variational formulas.
- A countable-alphabet public forwarding family for the finite joint KL chain
  rule.
- Public direct-`klDiv != top` plumbing.
- Public `iIndepFun`, product-measure, or dependent-product-PMF APIs.
- Pairwise-versus-mutual independence theory beyond the one approved
  distinct-index compatibility theorem.
- Source forwarding for elementary mutual-independence laws.
- Conditional-family CMI symmetry, permutation, `Nodup`, or
  reverse-orientation families.
- A new Section 2.8 theorem.
- Finite-family certificate adapters, new primitive inequalities, or changes
  to `EntropyExpr`, `ShannonEntropyVal`, checked certificates, validation, or
  the certificate trust boundary.
- Topology, Pinsker, tensorization, AEP, typicality, capacity, coding
  theorems, matrix/majorization work, process entropy, or minimal sufficiency.
- Refactoring established PMF channel or kernel ownership without an
  unavoidable feasibility-gate blocker and explicit approval.
- Importing any new Chunk 8 module from `LeanInfoTheory.lean`.
- A reusable general validation driver, maintained boundary/trust harness,
  full Lean doc-gen, theorem-level blueprint, or website redesign.

## Relevant Cover--Thomas Sections And Conventions

The local source is:

`info theory e-books/Elements_of_Information_Theory_Elements.pdf`

The exact relevant first-edition material is:

### Section 2.5, "Chain Rules for Entropy, Relative Entropy and Mutual Information"

Book pages 21--23; PDF pages 43--45.

- Theorem 2.5.1 gives the ordered entropy chain rule:

  ```text
  H(X_1, ..., X_n) =
    sum_i H(X_i | X_1, ..., X_(i-1)).
  ```

- Theorem 2.5.2 gives the ordered mutual-information chain rule:

  ```text
  I(X_1, ..., X_n; Y) =
    sum_i I(X_i; Y | X_1, ..., X_(i-1)).
  ```

- Equations (2.65)--(2.66) define conditional relative entropy as:

  ```text
  D(P_(Y|X) || Q_(Y|X) | P_X) =
    sum_x P_X(x) D(P_(Y|X=x) || Q_(Y|X=x)).
  ```

- Theorem 2.5.3 gives the relative-entropy chain rule:

  ```text
  D(P_XY || Q_XY) =
    D(P_X || Q_X) +
    D(P_(Y|X) || Q_(Y|X) | P_X).
  ```

### Section 2.6, "Jensen's Inequality and Its Consequences"

Book pages 23--28; PDF pages 45--50.

- Theorem 2.6.6 gives the independence bound:

  ```text
  H(X_1, ..., X_n) <= sum_i H(X_i),
  ```

  with equality if and only if the variables are mutually independent.

### Sections 2.7--2.8

Section 2.7, book pages 29--31 and PDF pages 51--53, is already implemented by
Chunk 7 for finite PMFs. Section 2.8, book pages 32--33 and PDF pages 54--55,
is already represented by the completed finite Markov and data-processing
layers from earlier chunks. Chunk 8 uses those established conventions but
adds no new Section 2.8 theorem.

### Convention differences

- Cover--Thomas uses base-two logarithms by default; LeanInfoTheory uses
  natural logarithms and nats.
- Canonical project KL divergence is mathlib's `ENNReal`-valued
  `InformationTheory.klDiv`.
- Real-valued KL statements require explicit support/finiteness guards because
  `ENNReal.toReal top = 0`.
- Channels remain functions `alpha -> PMF beta`; there is no second bundled
  channel representation.
- The finite-family API permits an arbitrary, possibly infinite variable-name
  type; finite atoms are `Finset Var`; and coordinate alphabets may depend on
  the variable.
- Empty and singleton selected families are valid. A `PMF` on an empty source
  type has no constructed inhabitant and is not used as an example fixture.
- Mutual independence means joint pointwise factorization, not merely pairwise
  independence.

## Existing LeanInfoTheory Infrastructure

The following existing declarations and owners have been verified in current
source.

### Lightweight finite-family API

In `LeanInfoTheory.Shannon.FiniteFamily`:

- `FamilyOutcome`;
- `familyLawOf`;
- `familyMarginal`;
- `familyEntropy`;
- `familyEntropyOf`;
- `familyCondMutualInfo`;
- `familyCondMutualInfoOf`;
- `familyMarginal_restrict`;
- `familyEntropy_empty`;
- `familyEntropy_singleton`;
- `familyEntropy_union`;
- `familyCondMutualInfo_eq_condEntropy_sub_condEntropy`;
- `familyMutualInfo_union_chain_rule`;
- `familyMutualInfo_eq_mutualInfoChain`;
- the corresponding existing source-family rewrites.

In `LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily`:

- `familyEntropy_le_sum_singletons`;
- `familyEntropyOf_le_sum_singletons`;
- `finiteFamilyEntropyVal`;
- `finiteFamilyEntropyValOf`.

### Pair independence

In `LeanInfoTheory.Shannon.SemanticBridge.Independence`:

- `IsIndependent`;
- `IsIndependentOf`;
- `isIndependent_iff_apply_eq_mul_marginals`;
- `isIndependentOf_iff_map_eq_indepProd`;
- `isIndependentOf_iff_indepFun`;
- `jointEntropy_eq_add_marginalEntropy_iff_isIndependent`;
- `jointEntropyOf_eq_add_entropyOf_iff_isIndependentOf`.

The new public finite-family predicate remains pointwise and PMF-first. Any
use of measurable independence in a proof remains private.

### Finite channels and KL

In `LeanInfoTheory.Probability.FiniteChannel`:

- `PMF.channelJoint`;
- `PMF.channelJoint_apply`;
- `PMF.mem_support_channelJoint_iff`;
- `PMF.channelJoint_eq_iff_eq_on_support`.

In `LeanInfoTheory.Shannon.SemanticBridge.DataProcessing`:

- `pmfChannelKernel`;
- `pmfChannelKernel_apply`;
- `channelJoint_toMeasure`.

In `LeanInfoTheory.Shannon.SemanticBridge.KL`:

- `toMeasure_absolutelyContinuous_iff_support_subset`;
- `klDiv_pmf_ne_top_iff_support_subset`;
- `klDiv_pmf_eq_top_iff_not_support_subset`;
- `klDiv_pmf_eq_zero_iff`;
- `toReal_klDiv_pmf_eq_sum`.

No existing LeanInfoTheory declaration provides the approved channel-level
conditional-KL object, its weighted formula, the four conditional-family CMI
chain rules, or the finite mutual-independence predicate/equality API.

## Verified Relevant Mathlib Infrastructure

The pinned mathlib revision provides:

- `PMF.toMeasure`, requiring only a measurable space;
- `PMF.toMeasure_apply_singleton`;
- `PMF.toMeasure_inj`;
- `InformationTheory.klDiv_self`;
- `InformationTheory.klDiv_ne_top_iff`;
- `InformationTheory.klDiv_compProd_left`;
- `InformationTheory.klDiv_compProd_eq_add`, with orientation

  ```text
  klDiv (mu tensor-kappa) (nu tensor-eta) =
    klDiv mu nu +
    klDiv (mu tensor-kappa) (mu tensor-eta);
  ```

- `ENNReal.toReal_add`;
- `ENNReal.toReal_sum`;
- `ENNReal.mul_top` and standard zero multiplication;
- `Fin.sum_univ_succ`;
- `ProbabilityTheory.iIndepFun_iff_map_fun_eq_pi_map`;
- finite product-measure evaluation such as `Measure.pi_pi`.

Mathlib does not provide the required finite weighted conditional-KL theorem.
The `iIndepFun` and product-measure results are optional private proof tools;
they are not approved public APIs and do not by themselves prove the entropy
equality characterization.

## Mathematical Dependency Overview

```text
C8.01 conditional-KL feasibility gate
  -> C8.06 elementary production API
  -> C8.07 weighted ENNReal formula
  -> C8.08 joint KL chain rule
  -> C8.09 Real weighted formula
  -> C8.10 Real joint chain rule
  -> C8.11 conditional-KL checkpoint

C8.02 mutual-independence feasibility gate
  -> C8.12 production predicates
  -> C8.13 empty/singleton laws
  -> C8.14 subset restriction
  -> C8.15 source-facing pair compatibility
  -> C8.16 law/source entropy equality
  -> C8.17 independence checkpoint

C8.03 binary conditional CMI
  -> C8.04 ordered conditional CMI
  -> C8.05 lightweight checkpoint

C8.05 + C8.11 + C8.17
  -> C8.18--C8.19 maintained examples
  -> C8.20 API review
  -> C8.21 focused integration
  -> C8.22 canonical memory
  -> C8.23 generated/public documentation
  -> C8.24 independent closeout
```

The two feasibility gates are mathematically independent, but a failed gate
makes its current step incomplete and stops the entire execution sequence. No
independent workstream may continue until the project lead explicitly approves
resumption or a plan revision.

## API And Three-Module Ownership Strategy

### `LeanInfoTheory.Shannon.FiniteFamily`

The existing lightweight module owns exactly the four new conditional-family
CMI chain rules. It acquires no semantic KL, measurable independence, kernel,
or certificate import.

### `LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL`

This tentative new, directly importable module owns:

- `conditionalKlDiv`;
- self-divergence;
- the finite weighted `ENNReal` semantics;
- the finite joint KL chain rule;
- support-guarded Real forms.

It imports the established `DataProcessing` owner to reuse
`channelJoint_toMeasure` and `pmfChannelKernel`, and it may explicitly import
the KL bridge whose support and finite-sum declarations it directly uses. It
does not refactor or duplicate the channel/kernel bridge.

### `LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence`

This tentative new, directly importable module owns:

- finite mutual-independence predicates;
- law-facing base and restriction results;
- the one approved source-facing pair compatibility theorem;
- the n-way entropy equality characterizations.

It imports `SemanticBridge.FiniteFamily` and
`SemanticBridge.Independence`. The current graph contains no cycle between
those owners.

After both new semantic APIs are complete, C8.17 adds them to the opt-in
`LeanInfoTheory.Shannon.SemanticBridge` aggregate. Neither module enters
`LeanInfoTheory.lean`. The existing `ShannonEntropyVal`, `EntropyExpr`,
primitive inequalities, and certificate trust paths remain unchanged.

All module and public declaration names introduced by this plan are tentative
until source elaboration and the scheduled C8.20 review under `AGENTS.md` and
Future Work Note 14.

## Principal Risks And Fallback Boundaries

1. The weighted conditional-KL theorem must distinguish finite and top
   branches. A proof based only on `toReal` equality is invalid.
2. Inactive fibers may have KL divergence `top`; their contribution must
   remain exactly `0 * top = 0`.
3. The two-base joint chain rule must use the numerator base `p` in the
   conditional term.
4. `channelJoint_toMeasure` has measurable-singleton and countability
   requirements; the public C8.08 contract intentionally remains finite.
5. The mutual-independence gate must prove dependent-alphabet insert,
   restriction, and pair-block factorization machinery before claiming the
   headline iff.
6. Pair independence of every pair is not mutual independence; the public
   predicate must retain full joint factorization.
7. Subtype coordinate proof witnesses can obstruct otherwise simple
   extensionality and product calculations.
8. Public forwarding families, support-extensionality, measurable
   independence, and helper abstractions can expand the API without consumer
   pressure.
9. A new heavy import can accidentally leak through the root or certificate
   layers.

An internal change of finite-sum organization, induction scheme, local
equivalence, private helper, or use of a verified mathlib theorem is allowed
when it preserves the approved statement, assumptions, modules, public API,
and trust boundary. A material theorem, representation, assumption, module,
public naming policy, trust, or scope change requires an explained plan
revision and explicit approval.

## Final Implementation Steps

### C8.01 - Conditional-KL Proof-Complete Hybrid Feasibility Gate

**Status:** complete

**Objective and reason:** Validate the actual CKB contract before any
dependent production theorem is accepted. Begin the proposed production
conditional-KL module, retain the approved public primitive, and prove enough
private hard infrastructure to establish both the common-base weighted formula
and the distinct-base joint chain rule.

**Prerequisites:** Clean baseline; accepted CKB definition; finite channel and
KL bridge modules; no prior Chunk 8 implementation.

**Verified LeanInfoTheory declarations to reuse:** `PMF.channelJoint`,
`PMF.channelJoint_apply`, `PMF.mem_support_channelJoint_iff`,
`channelJoint_toMeasure`, `pmfChannelKernel`,
`klDiv_pmf_ne_top_iff_support_subset`,
`klDiv_pmf_eq_top_iff_not_support_subset`, and
`toReal_klDiv_pmf_eq_sum`.

**Verified mathlib APIs:** `PMF.toMeasure`,
`InformationTheory.klDiv_compProd_eq_add`,
`InformationTheory.klDiv_self`, `ENNReal.toReal_sum`,
`ENNReal.mul_top`, and finite big-operator identities.

**Proposed declarations:** Public `[tentative] conditionalKlDiv`. Private
candidate weighted, chain, active-support, joint-support, non-top, and finite
sum helpers. Private names are proof machinery and are not part of the public
naming inventory.

**Target files, namespaces, and imports:** Create
`LeanInfoTheory/Shannon/SemanticBridge/ConditionalKL.lean` in
`LeanInfoTheory.Shannon`. Import `SemanticBridge.DataProcessing` and the
existing KL bridge as needed. Do not change the semantic aggregate or root.

**Proof or implementation strategy:** Define `conditionalKlDiv` using the two
common-base joint PMF measures. Prove a private exact weighted theorem with the
C8.07 assumptions. Split on active support inclusion:

1. If some `x` in `r.support` has a fiber support violation, use a witness
   output atom to prove the joint support violation and hence joint KL `top`;
   prove the corresponding weighted summand is `top` because `r x != 0`.
2. If every active fiber has support inclusion, prove the joint KL and every
   active fiber KL are non-top, compare their finite Real expansions, and lift
   equality back to `ENNReal`.

Prove the distinct-base chain candidate by rewriting both channel joints with
`channelJoint_toMeasure` and applying
`InformationTheory.klDiv_compProd_eq_add` with numerator base `p`. Use ignored
disposable consumers for edge instantiation, then delete them.

**Edge cases:** Null base atoms; inactive fiber KL `top`; active fiber KL
`top`; positive-over-zero; `0 * top`; finite but empty alphabet types for
which no `PMF Empty` fixture is constructed; measurable-space and
measurable-singleton synthesis; PMF/ENNReal/Real coercions.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL
lake env lean tmp/codex-c8-conditional-kl-gate.lean
git diff --check
```

The disposable consumer must be removed after it compiles.

**Definition of done:** The production module contains the public primitive
and private reusable hard proofs. The unconditional weighted formula handles
both top branches and inactive `0 * top`. The chain candidate uses distinct
`p`, `q`, `W`, and `V`, with conditional term based on `p`. No support guard,
placeholder, stronger assumption, public helper, aggregate import, or retained
scratch artifact is present.

**Downstream effect:** Unlocks C8.06--C8.11. It does not itself publish the
weighted or chain theorem families.

**Documentation implications:** Update only this plan's factual status and
outcome. Do not update canonical memory or generated documentation.

**Risk level:** Very high.

**Fallback strategy:** Internal alternatives include a different finite
support split, double-sum normalization, or composition-product rewrite. Any
failure to prove the unconditional weighted theorem, distinct-base chain rule,
or exact top behavior makes C8.01 incomplete and stops the entire sequence.
CKC, a chain-only API, a guarded canonical theorem, or a representation change
requires explicit approval.

**Implementation outcome (2026-07-31):** Complete.
`LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL` now exists as a directly
importable opt-in semantic module. Its only public source declaration is the
approved `conditionalKlDiv` primitive, defined as KL divergence between the
two common-base channel-joint PMF measures. The definition requires only
measurable spaces; no finiteness, measurable-singleton, support, or positivity
assumption was added.

The module retains three private proof engines. The first characterizes joint
support inclusion exactly by support inclusion on nonzero base fibers. The
second proves the complete C8.07 weighted `ENNReal` identity under
`[Fintype alpha] [Finite beta]` and measurable singletons. Its active-support
branch proves both sides non-top, compares the finite Real KL expansions, and
lifts equality back to `ENNReal`; its failure branch proves both sides are
`top`. Inactive fibers may have infinite KL and contribute exactly
`0 * top = 0`. The third private theorem proves the distinct-base C8.08 chain
candidate from `InformationTheory.klDiv_compProd_eq_add`, with numerator base
`p` in `conditionalKlDiv p W V`.

The focused single-job Lake build passed with 2,748 jobs for
`LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL`.
An ignored disposable Boolean consumer compiled null-base/inactive-top,
active-top, positive-over-zero, finite active, and distinct-base chain
contracts, then was deleted. Guarded negative consumers confirmed that
`conditionalKlDiv` is absent from `LeanInfoTheory.lean` and both gate theorems
remain private; they were also deleted. The strict placeholder scan is clean.
No aggregate, root, certificate, canonical-memory, generated, website, or
Future Work file changed. The short mathematical public name needs no Future
Work Note 14 watch entry. C8.02 remains approval-gated.

### C8.02 - Dependent-Family Mutual-Independence Proof-Complete Hybrid Feasibility Gate

**Status:** `complete`

**Objective and reason:** Validate the full FIB contract for arbitrary finite
atoms and dependent alphabets before auxiliary public laws are developed.

**Prerequisites:** Clean C8.01 completion or explicit approval to resume after
any gate review; existing finite-family entropy and pair-independence APIs.
C8.02 is mathematically independent of C8.01 but is not procedurally allowed
to start after an incomplete gate.

**Verified LeanInfoTheory declarations to reuse:** `FamilyOutcome`,
`familyMarginal`, `familyMarginal_restrict`, `familyEntropy`,
`familyEntropy_empty`, `familyEntropy_singleton`, `familyEntropy_union`,
`familyEntropy_le_sum_singletons`,
`jointEntropy_eq_add_marginalEntropy_iff_isIndependent`,
`isIndependent_iff_apply_eq_mul_marginals`, and `familyLawOf`.

**Verified mathlib APIs:** `PMF.ext`, finite sums/products,
`Finset.induction_on`, subtype extensionality, and, only as a private option,
`ProbabilityTheory.iIndepFun_iff_map_fun_eq_pi_map` and `Measure.pi_pi`.

**Proposed declarations:** Public `[tentative] IsMutuallyIndependentFamily`
and `[tentative] IsMutuallyIndependentFamilyOf`. Private restriction, insert
decomposition/reconstruction, pair-block independence, factorization
transport, and complete entropy-iff helpers.

**Target files, namespaces, and imports:** Create
`LeanInfoTheory/Shannon/SemanticBridge/FiniteFamilyIndependence.lean` in
`LeanInfoTheory.Shannon`. Import `SemanticBridge.FiniteFamily` and
`SemanticBridge.Independence`. Do not change the semantic aggregate or root.

**Proof or implementation strategy:** State the law predicate as pointwise
factorization of `familyMarginal q s` into coordinate marginals; define the
source predicate through `familyLawOf`. Prove privately, or through a
simultaneous Finset induction:

1. factorization on `insert i t` restricts to factorization on `t`;
2. factorization on `t` plus independence of coordinate `i` from the `t`
   restriction reconstructs factorization on `insert i t`;
3. full factorization on `insert i t` produces the required pair
   independence;
4. entropy equality for `insert i t` forces both tail entropy equality and
   pair entropy equality;
5. the complete entropy-additivity iff pointwise-factorization theorem follows.

Keep dependent-coordinate equivalences and measurable independence private.
Use ignored disposable consumers for empty, singleton, heterogeneous, genuine
mutually independent, and both-direction tests, then delete them.

**Edge cases:** Arbitrary `Var` without `[Fintype Var]`; dependent finite
alphabets; empty and singleton atoms; zero-mass outcomes; subtype coordinate
proof irrelevance; order independence; pairwise versus mutual independence;
no public product PMF.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence
lake env lean tmp/codex-c8-mutual-independence-gate.lean
git diff --check
```

The disposable consumer must be removed after it compiles.

**Definition of done:** The public predicates and private proof-complete
dependent-family equivalence compile for arbitrary `s : Finset Var`, with no
global `Fintype Var`, no homogeneous-alphabet restriction, and both
implications proved. Restriction, insert reconstruction, and pair-block
independence are validated privately before the gate is declared successful.

**Downstream effect:** Unlocks C8.12--C8.17.

**Documentation implications:** Update only the plan outcome. Record genuine
proof pressure for later review without promoting speculative helpers.

**Risk level:** Very high.

**Fallback strategy:** Internal alternatives include simultaneous induction,
a private finite product-measure route, or different dependent-coordinate
equivalences. One direction only, homogeneous alphabets, ordered-list-only
independence, public `iIndepFun`, a different predicate, or stronger ambient
finiteness requires approval. Failure makes C8.02 incomplete and stops the
entire sequence.

**Implementation outcome (July 31, 2026):** Complete. Added the opt-in module
`LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence` with the two
approved public, type-generic predicates `IsMutuallyIndependentFamily` and
`IsMutuallyIndependentFamilyOf`. The law predicate is exactly pointwise
factorization of `familyMarginal q s` into its coordinate marginals; the
source predicate specializes it through `familyLawOf`.

The proof-complete gate uses a private normalized finite product PMF and
private dependent-coordinate transport through `Equiv.piFinsetUnion`. It
establishes restriction to either disjoint block, pair-block independence
from full factorization, reconstruction from block factorization plus pair
independence, and the full two-way equivalence

```text
familyEntropy q s = sum i in s, familyEntropy q {i}
  iff IsMutuallyIndependentFamily q s.
```

The final equivalence is proved by `Finset.induction_on`. Its forward
direction combines the existing singleton-sum upper bound and union
subadditivity to force equality for the tail and the inserted-coordinate
block; its reverse direction restricts factorization to the tail and converts
pair-block independence back to entropy additivity. Empty and singleton
factorization require no finiteness assumptions. The full theorem supports
arbitrary `s : Finset Var` without `[Fintype Var]`, dependent finite
alphabets, zero-mass outcomes, and subtype proof irrelevance. No product PMF,
transport lemma, pair-law helper, or entropy characterization was made public.

The disposable gate consumer compiled the generic and source-specialized
surfaces, arbitrary-law empty and singleton cases, and a heterogeneous
`Bool`/`Fin 3` dependent family. A second disposable check proved direct
factorization of an arbitrary multi-coordinate deterministic dependent family,
then both files were deleted. A guarded negative consumer confirmed that
importing `LeanInfoTheory` does not expose the new module.
Direct compilation and
`lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence`
both passed; the forbidden-placeholder scan, scratch cleanup, and focused
public-name audit passed. The two public names match the approved vocabulary
and do not create a Future Work Note 14 trigger. The semantic aggregate,
lightweight root, canonical project memory, and all later step statuses remain
unchanged. No fallback or scope deviation was required.

### C8.03 - Binary Conditional-Family CMI Chain Rules

**Status:** `complete`

**Objective and reason:** Add the binary law-facing and source-family
conditional-MI chain rules:

```text
I(A union B; C | D) =
  I(A; C | D) + I(B; C | A union D).
```

**Prerequisites:** C8.01--C8.02 complete; existing family CMI definitions and
union normalization.

**Verified LeanInfoTheory declarations to reuse:**
`familyCondMutualInfo`, `familyCondMutualInfoOf`,
`familyCondMutualInfo_eq_condEntropy_sub_condEntropy`, and `familyLawOf`.

**Verified mathlib APIs:** Finset union associativity/commutativity/idempotence
and Real ring normalization.

**Proposed declarations:** `[tentative]
familyCondMutualInfo_union_chain_rule` and `[tentative]
familyCondMutualInfoOf_union_chain_rule`.

**Target files, namespaces, and imports:** Modify
`LeanInfoTheory/Shannon/FiniteFamily.lean` in
`LeanInfoTheory.Shannon`. Add no import.

**Proof or implementation strategy:** Unfold the family CMI entropy
expression, prove only the necessary Finset union equalities extensionally,
and close the Real identity algebraically. Derive the source theorem by
specializing the law theorem to `familyLawOf`.

**Edge cases:** Empty atoms; arbitrary overlaps among all four atoms; repeated
membership; a left or right atom already contained in the conditioning atom;
no disjointness hypothesis.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
git diff --check
```

**Definition of done:** Exactly two new public declarations compile, the
source theorem is a thin consequence of the law theorem, and no disjointness,
`Nodup`, helper-facing name, or simp attribute is introduced.

**Downstream effect:** Supplies the induction step for C8.04.

**Documentation implications:** Update the plan outcome and audit both public
names under Future Work Note 14. No canonical-memory update.

**Risk level:** Low.

**Fallback strategy:** A small private Finset union-normalization lemma is
allowed if it removes genuine duplication. Disjointness, a changed
orientation, or additional public identities requires approval.

**Implementation outcome (July 31, 2026):** Complete. Added exactly the two
approved public declarations
`familyCondMutualInfo_union_chain_rule` and
`familyCondMutualInfoOf_union_chain_rule` to
`LeanInfoTheory.Shannon.FiniteFamily`. The law-facing theorem has the planned
orientation

```text
I(A union B; C | D) =
  I(A; C | D) + I(B; C | A union D)
```

for arbitrary, potentially overlapping finite atoms. Its proof unfolds only
`familyCondMutualInfo`, normalizes the necessary unions with commutativity and
left commutativity, and closes the resulting Real identity with `ring`. No
disjointness, `Nodup`, subset, or auxiliary helper is needed. The source-family
theorem is a thin `simpa only [familyCondMutualInfoOf]` specialization of the
law theorem to `familyLawOf p X`.

Direct source compilation and
`lake build LeanInfoTheory.Shannon.FiniteFamily` passed. A disposable consumer
compiled generic, empty-left, fully overlapping, conditioning-contained, and
source-family uses, then was deleted. The immediate downstream
`LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` and
`LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence` builds passed.
A guarded negative consumer confirmed that the lightweight root still does
not expose this opt-in finite-family theorem. The forbidden-placeholder and
scratch-hygiene scans passed. Both names extend the established
`familyMutualInfo[_Of]_union_chain_rule` vocabulary, preserve the `...Of`
distinction, and expose no implementation detail, so neither creates a Future
Work Note 14 trigger. No import, simp attribute, canonical-memory document, or
later-step status changed, and no fallback or scope deviation was required.

### C8.04 - Ordered Conditional-Family CMI Chain Rules

**Status:** `complete`

**Objective and reason:** Add duplicate-tolerant ordered law/source rules:

```text
I(l.toFinset; B | C) =
  sum k : Fin l.length,
    I({l.get k}; B | C union (l.take k).toFinset).
```

**Prerequisites:** C8.03 and the existing ordered family MI proof pattern.

**Verified LeanInfoTheory declarations to reuse:**
`familyCondMutualInfo`, `familyCondMutualInfoOf`,
`familyMutualInfo_eq_mutualInfoChain`, and the C8.03 binary law.

**Verified mathlib APIs:** `Fin.sum_univ_succ`, `List.take`,
`List.toFinset`, Finset insert/union laws, and list induction.

**Proposed declarations:** `[tentative] familyCondMutualInfo_chain_rule` and
`[tentative] familyCondMutualInfoOf_chain_rule`.

**Target files, namespaces, and imports:** Modify
`LeanInfoTheory/Shannon/FiniteFamily.lean`; no new import.

**Proof or implementation strategy:** Induct over the list using the binary
chain rule with the current initial conditioning atom. If a recursive
accumulator is clearer, parameterize it by the already-seen conditioning atom
and keep it private. Derive the source theorem from the law theorem.

**Edge cases:** Empty list; duplicate names; names already in `C`; names
repeated after entering a prefix; overlapping `B` and `C`; heterogeneous
alphabets; no `Nodup`.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
lake env lean tmp/codex-c8-ordered-cmi.lean
git diff --check
```

Delete the disposable duplicate-name consumer after validation.

**Definition of done:** Exactly two new public ordered rules compile for every
list, including duplicates. No public accumulator, `Nodup` corollary,
symmetry, permutation, reverse orientation, or simp attribute is added.

**Downstream effect:** Completes the exactly-four initial conditional-family
CMI inventory.

**Documentation implications:** Update the plan outcome and naming watchlist
only if a name is genuinely awkward.

**Risk level:** Medium.

**Fallback strategy:** Private recursion and a private initial-conditioning
helper are allowed. Weakening to distinct lists or expanding the public chain
API requires approval.

**Implementation outcome (July 31, 2026):** Complete. Added exactly the two
approved public declarations `familyCondMutualInfo_chain_rule` and
`familyCondMutualInfoOf_chain_rule` to
`LeanInfoTheory.Shannon.FiniteFamily`. The law-facing theorem states, for every
list without a `Nodup` assumption,

```text
I(l.toFinset; B | C) =
  sum k : Fin l.length,
    I({l.get k}; B | C union (l.take k).toFinset).
```

The proof is a direct list induction rather than a new recursive accumulator.
The empty case reduces the four-entropy definition. In the cons case,
`familyCondMutualInfo_union_chain_rule` splits off the head,
`Fin.sum_univ_succ` splits the ordered sum, and the induction hypothesis is
used with the head adjoined to the conditioning atom. The remaining local
equalities normalize the two equivalent prefix unions and use
`List.get_cons_succ`; no mathematical side condition or reusable helper is
needed. The source theorem is a thin
`simpa only [familyCondMutualInfoOf]` specialization through `familyLawOf`.

Direct source compilation and
`lake build LeanInfoTheory.Shannon.FiniteFamily` passed. A disposable consumer
compiled the generic theorem, the empty list, repeated names, names already
present in both the observed and conditioning atoms, a heterogeneous
`Bool`/`Fin 3` family with a repeated coordinate, and the source theorem, then
was deleted. Downstream builds of
`LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` and
`LeanInfoTheory.Certificate.FiniteFamily` passed. A guarded negative consumer
confirmed that the lightweight root does not expose the ordered theorem. The
forbidden-placeholder and scratch-hygiene scans passed. The two names are the
direct conditional counterparts of the established ordered family
mutual-information vocabulary, preserve the `...Of` distinction, and expose
no helper detail, so neither creates a Future Work Note 14 trigger. No public
accumulator, `Nodup` corollary, symmetry or permutation variant, import, simp
attribute, canonical-memory edit, or later-step status was added. No fallback
or scope deviation was required.

### C8.05 - Lightweight Conditional-CMI Checkpoint

**Status:** `complete`

**Objective and reason:** Freeze and validate the exactly-four lightweight CMI
surface before proceeding with heavy semantic production work.

**Prerequisites:** C8.03--C8.04.

**Verified LeanInfoTheory declarations to reuse:** The four new CMI rules,
existing finite-family semantic theorems, `finiteFamilyEntropyVal`, and the
finite-family certificate adapter.

**Verified mathlib APIs:** No new mathlib theorem is required; this is an
integration and API-inventory step.

**Proposed declarations:** None by default. A private helper may be extracted
only if the two production proofs demonstrate identical nontrivial plumbing.

**Target files, namespaces, and imports:** Inspect
`Shannon.FiniteFamily`, `SemanticBridge.FiniteFamily`,
`Certificate.FiniteFamily`, and direct consumers. Do not modify canonical
memory or generated files.

**Proof or implementation strategy:** Exercise binary, empty, overlapping,
ordered, duplicate, and source forms. Verify that plain `simp` does not expand
chain rules and that no heavy import reaches the lightweight module or root.

**Edge cases:** All C8.03--C8.04 cases; proof irrelevance in duplicate subtype
coordinates; root and certificate import boundaries.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily
lake build LeanInfoTheory.Certificate.FiniteFamily
git diff --check
```

Use disposable positive and guarded negative import consumers as needed, then
delete them.

**Definition of done:** Exactly four public CMI declarations are present,
their orientations and assumptions are reviewed, all focused downstream
builds pass, chain rules remain explicit, and root isolation is preserved.

**Downstream effect:** Establishes the lightweight workstream checkpoint used
by examples and final integration.

**Documentation implications:** Update only the plan outcome.

**Risk level:** Low.

**Fallback strategy:** Correct implementation defects or retain explicit
rewrites. Any public API expansion or new import requires approval.

**Implementation outcome (July 31, 2026):** Complete with no Lean source
change. The lightweight conditional-family CMI surface contains exactly the
four approved public declarations:

- `familyCondMutualInfo_union_chain_rule`;
- `familyCondMutualInfoOf_union_chain_rule`;
- `familyCondMutualInfo_chain_rule`;
- `familyCondMutualInfoOf_chain_rule`.

The two binary rules retain the left-to-right union orientation from C8.03,
and the two ordered rules retain the duplicate-tolerant prefix orientation
from C8.04. All four require only `[DecidableEq Var]` and dependent finite
coordinate alphabets; none requires `[Fintype Var]`, disjointness, `Nodup`,
subset assumptions, homogeneous alphabets, or support hypotheses. The
`...Of` rules remain thin source specializations.

A disposable positive consumer imported the finite-family certificate adapter
and compiled the generic binary and ordered rules, empty and overlapping
atoms, repeated names already present in both the observed and conditioning
atoms, both source forms, `finiteFamilyEntropyVal`,
`finiteFamilyEntropyValOf`, and `CheckedCert.sound_finiteFamily`. Guarded
checks confirmed that plain `simp` does not close either generic chain rule,
and a source-wide attribute search confirmed that none of the four rules is a
simp theorem. The consumer was deleted.

Guarded negative consumers established both import boundaries and were then
deleted. Importing `LeanInfoTheory.Shannon.FiniteFamily` does not expose
`finiteFamilyEntropyVal`, `conditionalKlDiv`,
`IsMutuallyIndependentFamily`, or `CheckedCert.sound_finiteFamily`; importing
the lightweight root exposes none of the four new CMI rules. Thus no semantic,
KL, mutual-independence, or certificate dependency leaked downward or into the
root.

The combined focused command
`lake build LeanInfoTheory.Shannon.FiniteFamily
LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily
LeanInfoTheory.Certificate.FiniteFamily` passed with 2,706 jobs. The
forbidden-placeholder, scratch-hygiene, declaration-inventory, naming, and
diff checks passed. No helper extraction, public API expansion, import change,
simp attribute, Future Work Note 14 entry, canonical-memory edit, or later-step
status change was justified.

### C8.06 - Production Conditional-KL Definition And Elementary API

**Status:** `complete`

**Objective and reason:** Harden the C8.01 primitive and publish only the clean
self-divergence law.

**Prerequisites:** C8.01 and C8.05.

**Verified LeanInfoTheory declarations to reuse:** `PMF.channelJoint` and the
C8.01 `conditionalKlDiv` primitive.

**Verified mathlib APIs:** `PMF.toMeasure`,
`InformationTheory.klDiv_self`, and the probability-measure/SigmaFinite
instances available for `PMF.toMeasure`.

**Proposed declarations:** Existing gate declaration `[tentative]
conditionalKlDiv`; new `[tentative] conditionalKlDiv_self`. Public support
extensionality is not guaranteed.

**Target files, namespaces, and imports:** Modify
`Shannon/SemanticBridge/ConditionalKL.lean`; keep its direct imports and
leave aggregate/root files unchanged.

**Proof or implementation strategy:** Give the definition and null-fiber
convention a precise module comment. Prove self-divergence by reducing to
`InformationTheory.klDiv_self`. Do not add finiteness or measurable-singleton
assumptions to the definition or self theorem unless elaboration proves them
unavoidable. Do not mark the theorem `[simp]` yet.

**Edge cases:** Arbitrary measurable spaces; no finite assumption at
definition time; channels with arbitrary behavior outside base support;
SigmaFinite inference for PMF measures.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL
git diff --check
```

**Definition of done:** The public definition has the weakest clean
assumptions, self-divergence is unconditional under those natural assumptions,
and no support-extensionality family or simp attribute is added speculatively.

**Downstream effect:** Stabilizes the vocabulary used by C8.07--C8.10.

**Documentation implications:** Update the plan outcome and record the public
names for C8.20 review.

**Risk level:** Medium.

**Fallback strategy:** Internal changes to instance setup or a private
SigmaFinite helper are allowed. Adding finiteness to the definition, changing
the representation, or guaranteeing support extensionality requires approval.

**Implementation outcome (July 31, 2026):** Complete. The existing public
`conditionalKlDiv` definition retains the C8.01 common-base joint-law
representation and its weakest clean assumptions: arbitrary input and output
types with measurable spaces, with no finiteness, measurable-singleton,
support, positivity, or non-top hypothesis.

The module and definition comments now state the null-base-fiber contract
precisely. If `r x = 0`, both induced joint laws assign zero mass to every
`(x, y)`, so `W x` and `V x` are ignored by the definition. This is a
consequence of the joint-law representation and does not assign a fallback or
separate probabilistic meaning to the null fiber.

Added the single approved elementary theorem
`conditionalKlDiv_self`, with the same assumption-minimal measurable-space
surface:

```text
conditionalKlDiv r W W = 0.
```

Its proof unfolds `conditionalKlDiv` and applies
`InformationTheory.klDiv_self`; the `SigmaFinite` instance for the induced PMF
measure is inferred without local setup. The theorem is deliberately not a
simp rule. No public support-extensionality theorem or other elementary
wrapper was added.

Direct source compilation and
`lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL` passed with
2,748 jobs. A disposable consumer compiled the theorem over arbitrary
measurable spaces and over infinite `Nat` input/output alphabets without
finiteness assumptions, and confirmed that plain `simp` does not close the
generic theorem; it was deleted. Guarded negative consumers confirmed that the
C8.01 weighted and chain gate engines remain private and that neither
`conditionalKlDiv` nor `conditionalKlDiv_self` is exposed by the lightweight
root; they were also deleted. The public source inventory now contains exactly
the definition and self theorem. Placeholder, scratch, attribute, public
support-theorem, and whitespace checks passed.

Both public names are short, mathematically direct, and expose no joint-law
helper detail. They are recorded here for the C8.20 inventory and do not create
a Future Work Note 14 trigger. No import, aggregate, root, canonical-memory,
generated-documentation, or later-step status changed, and no fallback or
scope deviation was required.

### C8.07 - Canonical Weighted `ENNReal` Conditional-KL Formula

**Status:** `complete`

**Objective and reason:** Publish the unconditional finite weighted-fiber
semantics:

```text
conditionalKlDiv r W V =
  sum x, r x *
    InformationTheory.klDiv (W x).toMeasure (V x).toMeasure.
```

**Prerequisites:** C8.01 private hard proof and C8.06 production definition.

**Verified LeanInfoTheory declarations to reuse:**
`PMF.channelJoint_apply`, `PMF.mem_support_channelJoint_iff`,
`klDiv_pmf_ne_top_iff_support_subset`,
`klDiv_pmf_eq_top_iff_not_support_subset`, and
`toReal_klDiv_pmf_eq_sum`.

**Verified mathlib APIs:** `ENNReal.toReal_sum`,
`ENNReal.mul_top`, `ENNReal.toReal` injectivity below `top`, finite sum
rearrangements, and `Fintype.ofFinite`.

**Proposed declarations:** `[tentative] conditionalKlDiv_eq_sum`.

**Target files, namespaces, and imports:** Modify
`Shannon.SemanticBridge.ConditionalKL`; no aggregate/root change.

**Import implications:** The public contract is:

```text
[Fintype alpha] [Finite beta]
[MeasurableSpace alpha] [MeasurableSingletonClass alpha]
[MeasurableSpace beta] [MeasurableSingletonClass beta]
```

Obtain `Fintype beta` locally only where finite sums over `beta` are needed.

**Proof or implementation strategy:** Reuse and clean the gate proof. The
public proof must visibly preserve the two branches:

1. An active fiber support violation makes the corresponding fiber KL `top`;
   since `r x != 0`, its weighted term is `top`. The same witness violates
   joint support inclusion, so the left side is `top`.
2. If all active fiber supports are included, prove the left side and every
   weighted summand are non-top. Expand the joint and fiber KL values to
   finite Real sums, use `PMF.channelJoint_apply`, rearrange the double sum,
   and lift the Real equality back to `ENNReal`.

For `x` outside `r.support`, prove the summand is exactly zero even when the
fiber KL is `top`.

**Edge cases:** `0 * top`; active `top`; all-zero inactive rows; empty output
type impossibility for an actual channel PMF; finite versus Fintype instances;
measurable singletons; coercions among PMF masses, `ENNReal`, and `Real`.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL
lake env lean tmp/codex-c8-weighted-conditional-kl.lean
git diff --check
```

The disposable consumer must include inactive-top and active-top fixtures and
must be deleted.

**Definition of done:** The theorem has exactly the locked assumptions, no
support guard, and both top/non-top branches are proved explicitly. No proof
relies only on equality of `toReal` values.

**Downstream effect:** Supplies C8.09 and the semantic interpretation used by
examples.

**Documentation implications:** Update the plan outcome and audit the
tentative public name.

**Risk level:** High.

**Fallback strategy:** Internal finite-sum and support-witness refactoring is
allowed. A guarded theorem, a `tsum` surface, stronger positivity, `[Fintype
beta]`, or loss of inactive-top behavior requires approval.

**Implementation outcome (July 31, 2026):** Complete. Promoted the
proof-complete C8.01 weighted gate directly to the public theorem
`conditionalKlDiv_eq_sum`; no forwarding wrapper or duplicate proof theorem
was retained. Its canonical unconditional `ENNReal` statement is

```text
conditionalKlDiv r W V =
  sum x, r x *
    InformationTheory.klDiv (W x).toMeasure (V x).toMeasure.
```

The public signature is exactly the locked contract:
`[Fintype alpha] [Finite beta]`, measurable spaces, and measurable singletons
on both alphabets. A `Fintype beta` instance is installed only locally inside
the proof. There is no support, positivity, absolute-continuity, non-top, or
global active-fiber guard in the theorem statement.

The promoted proof visibly retains both complete branches. Under active-fiber
support inclusion, it proves the joint KL and every weighted summand non-top,
compares finite Real expansions using `PMF.channelJoint_apply`, and lifts the
equality back to `ENNReal` with both non-top facts. When active support
inclusion fails, one positive-mass witness makes its fiber KL and weighted
term `top`; the same witness violates joint support inclusion, so the joint KL
and the full finite sum are both `top`. A null base fiber is handled before
fiber finiteness is required, giving exactly `0 * top = 0`.

Direct source compilation and
`lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL` passed with
2,748 jobs. A disposable consumer compiled the generic theorem with only
`[Finite beta]`, then exercised two Boolean models. In the inactive-top model,
the component KL at the zero-mass base atom is `top`, its weighted term is
zero, and `conditionalKlDiv` is zero. In the active-top model, the same
pure-fiber support violation has positive base mass, so the weighted term and
`conditionalKlDiv` are both `top`. The consumer was deleted. Guarded negative
consumers confirmed that the old gate name is absent, the distinct-base joint
chain engine remains private, and the lightweight root does not expose the
new theorem; they were also deleted.

The public source inventory now contains `conditionalKlDiv`,
`conditionalKlDiv_self`, and `conditionalKlDiv_eq_sum`. Placeholder, scratch,
privacy, root-isolation, and whitespace checks passed. The new name is short,
matches the established `..._eq_sum` vocabulary, and exposes no proof helper,
so it creates no Future Work Note 14 trigger. No import, aggregate, root,
canonical-memory, generated-documentation, or later-step status changed, and
no fallback or scope deviation was required.

### C8.08 - Unconditional Finite Joint KL Chain Rule

**Status:** `complete`

**Objective and reason:** Publish the finite PMF-channel form of
Cover--Thomas Theorem 2.5.3:

```text
D(channelJoint p W || channelJoint q V) =
  D(p || q) + conditionalKlDiv p W V.
```

**Prerequisites:** C8.01 chain candidate and C8.06 definition.

**Verified LeanInfoTheory declarations to reuse:** `channelJoint_toMeasure`,
`pmfChannelKernel`, and `conditionalKlDiv`.

**Verified mathlib APIs:**
`InformationTheory.klDiv_compProd_eq_add`.

**Proposed declarations:** `[tentative]
klDiv_channelJoint_eq_add_conditionalKlDiv`.

**Target files, namespaces, and imports:** Modify
`Shannon.SemanticBridge.ConditionalKL`; no aggregate/root change.

**Import implications:** Use the approved finite J1 contract:

```text
[Finite alpha] [Finite beta]
[MeasurableSpace alpha] [MeasurableSingletonClass alpha]
[MeasurableSpace beta] [MeasurableSingletonClass beta]
```

Do not generalize the public theorem to merely countable alphabets.

**Proof or implementation strategy:** Rewrite
`(PMF.channelJoint p W).toMeasure` and its three counterparts with
`channelJoint_toMeasure`. Instantiate
`InformationTheory.klDiv_compProd_eq_add` with numerator base `p`, denominator
base `q`, numerator kernel `pmfChannelKernel W`, and denominator kernel
`pmfChannelKernel V`. Fold the common-base final term back to
`conditionalKlDiv p W V`.

**Edge cases:** Base or conditional KL `top`; `top + x`; no support
hypothesis; finite-to-countable instance synthesis; measurable singletons;
correct numerator-base orientation.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL
lake env lean tmp/codex-c8-joint-kl-chain.lean
git diff --check
```

Delete the distinct-base disposable consumer.

**Definition of done:** The exact unconditional finite theorem compiles with
conditional term based on `p`, no support assumptions, no countable forwarding
theorem, and no duplicated kernel bridge.

**Downstream effect:** Supplies C8.10 and the principal textbook-facing
conditional-KL chain rule.

**Documentation implications:** Update the plan outcome and naming watchlist
as appropriate.

**Risk level:** Medium after C8.01.

**Fallback strategy:** Private rewrite helpers or explicit local
`Countable` instances are allowed. A common-base-only theorem, countable public
generalization, support guard, or alternate conditional term requires
approval.

**Implementation outcome (July 31, 2026):** Complete. Promoted the
proof-complete C8.01 distinct-base gate directly to the public theorem
`klDiv_channelJoint_eq_add_conditionalKlDiv`; no forwarding wrapper,
common-base intermediate theorem, or duplicate kernel bridge was retained.
The theorem states

```text
D(channelJoint p W || channelJoint q V) =
  D(p || q) + conditionalKlDiv p W V.
```

The conditional term is explicitly based on the numerator law `p`, not the
denominator law `q`. The public signature is exactly the approved finite J1
contract: `[Finite alpha] [Finite beta]`, measurable spaces, and measurable
singletons. Local `Fintype` instances are introduced only inside the proof.
There is no support, absolute-continuity, positivity, non-top, or
common-base assumption, and no countable public generalization.

The proof rewrites both channel-joint measures through
`channelJoint_toMeasure`, instantiates
`InformationTheory.klDiv_compProd_eq_add` with numerator base `p`,
denominator base `q`, numerator kernel `pmfChannelKernel W`, and denominator
kernel `pmfChannelKernel V`, then folds the common-numerator term back to
`conditionalKlDiv p W V`. The mathlib theorem supplies the complete
unconditional `ENNReal` behavior, including either summand being `top`.

Direct source compilation and
`lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL` passed with
2,748 jobs. A disposable consumer compiled the theorem under generic
`[Finite]` assumptions and instantiated syntactically distinct bases and
channels. A disjoint-base model verified the base-`top` branch with zero
conditional divergence, while an equal-base model with an active pure-fiber
support violation verified zero base KL plus `top` conditional KL and hence
`top` joint KL. The consumer was deleted. Guarded negative consumers confirmed
that the old gate name is absent and the lightweight root does not expose the
public theorem; they were also deleted.

The public module inventory now contains `conditionalKlDiv`,
`conditionalKlDiv_self`, `conditionalKlDiv_eq_sum`, and
`klDiv_channelJoint_eq_add_conditionalKlDiv`. Placeholder, scratch, privacy,
root-isolation, and whitespace checks passed. The new name is long but
systematic and directly identifies both sides of the mathematical statement;
it exposes no private kernel or rewrite helper. It is recorded here for C8.20
review and does not currently justify a Future Work Note 14 alias watch entry.
No import, aggregate, root, canonical-memory, generated-documentation, or
later-step status changed, and no fallback or scope deviation was required.

### C8.09 - Support-Guarded Real Weighted Formula

**Status:** `complete`

**Objective and reason:** Convert C8.07 to a practical Real finite sum under
the weakest approved active-fiber support guard.

**Prerequisites:** C8.07 and finite PMF KL support/finiteness results.

**Verified LeanInfoTheory declarations to reuse:**
`klDiv_pmf_ne_top_iff_support_subset` and C8.07.

**Verified mathlib APIs:** `ENNReal.toReal_sum`, `ENNReal.toReal_mul`,
standard `ENNReal` non-top multiplication facts, and `Fintype.ofFinite`.

**Proposed declarations:** `[tentative]
toReal_conditionalKlDiv_eq_sum`, with guard:

```text
forall x in r.support,
  (W x).support subset (V x).support.
```

**Target files, namespaces, and imports:** Modify
`Shannon.SemanticBridge.ConditionalKL`.

**Import implications:** Retain C8.07's `[Fintype alpha] [Finite beta]` and
measurable-singleton assumptions. No direct public `klDiv != top` theorem is
added.

**Proof or implementation strategy:** Prove every weighted summand is non-top:
on active base atoms use the support guard and
`klDiv_pmf_ne_top_iff_support_subset`; on inactive atoms reduce the coefficient
to zero without needing a fiber guard. Prove `conditionalKlDiv` itself
non-top from C8.07, then apply `ENNReal.toReal_sum` and the multiplication
coercion.

**Edge cases:** Inactive infinite fiber KL; active support failure excluded by
the hypothesis; `toReal top = 0`; zero coefficient; PMF mass coercions.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL
lake env lean tmp/codex-c8-real-weighted-conditional-kl.lean
git diff --check
```

**Definition of done:** The public hypothesis quantifies only over
`r.support`; inactive top fibers are accepted; the Real formula follows from
proved non-top facts; and direct-ne-top plumbing remains private.

**Downstream effect:** Supplies the conditional part of C8.10 and guarded
examples.

**Documentation implications:** Update the plan outcome; record any awkward
support-facing name under Note 14.

**Risk level:** High.

**Fallback strategy:** A private theorem converting support inclusion to
weighted-sum non-top is allowed. Guards on every input atom, global positivity,
or a public direct-ne-top contract requires approval.

**Implementation outcome (July 31, 2026):** Complete. Added the public theorem
`toReal_conditionalKlDiv_eq_sum` in
`LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL`. Its hypothesis has the
approved support-sensitive form

```text
forall x in r.support,
  (W x).support subset (V x).support,
```

and the conclusion converts the canonical C8.07 `ENNReal` identity to

```text
toReal (conditionalKlDiv r W V) =
  sum_x toReal (r x) * toReal (D(W x || V x)).
```

No condition is imposed on a null base fiber. The proof establishes that each
weighted `ENNReal` summand is non-top: a zero base mass reduces the whole
summand to zero even when the fiber KL is `top`, while an active base mass
turns the public support hypothesis into component-KL finiteness through
`klDiv_pmf_ne_top_iff_support_subset`. It then rewrites with
`conditionalKlDiv_eq_sum`, applies `ENNReal.toReal_sum`, and distributes
`toReal` over multiplication. A separate public direct-ne-top theorem and a
private helper were both unnecessary.

Direct source compilation and
`lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL` passed, the
latter with 2,748 jobs. A disposable consumer compiled the theorem on a
Boolean model with an inactive pure-fiber support violation. It verified that
the inactive component KL is `top`, its base coefficient is zero, and the
support-guarded Real formula remains applicable. The same consumer verified
that moving the violating fiber into the active support makes the required
support hypothesis false. The consumer was deleted after validation.

The public assumptions remain exactly `[Fintype alpha] [Finite beta]`,
measurable spaces, measurable singletons, and the active-support inclusion
guard. No positivity, all-fiber support, global non-top, or absolute-continuity
assumption was added. The new name follows the established
`toReal_..._eq_sum` family, exposes no implementation detail, and creates no
Future Work Note 14 trigger. No import, aggregate, root, canonical-memory,
generated-documentation, or later-step status changed, and no fallback or
scope deviation was required.

### C8.10 - Support-Guarded Real Joint KL Chain Rule

**Status:** `complete`

**Objective and reason:** Provide the Real-valued finite chain rule with
PMF-facing support assumptions:

```text
toReal D(channelJoint p W || channelJoint q V) =
  toReal D(p || q) + toReal (conditionalKlDiv p W V).
```

**Prerequisites:** C8.08--C8.09.

**Verified LeanInfoTheory declarations to reuse:**
`klDiv_pmf_ne_top_iff_support_subset`, C8.08, and C8.09.

**Verified mathlib APIs:** `ENNReal.toReal_add`.

**Proposed declarations:** `[tentative]
toReal_klDiv_channelJoint_eq_add_conditionalKlDiv`, under:

```text
p.support subset q.support
forall x in p.support,
  (W x).support subset (V x).support
```

**Target files, namespaces, and imports:** Modify
`Shannon.SemanticBridge.ConditionalKL`.

**Import implications:** Use `[Finite alpha] [Finite beta]` plus measurable
spaces and measurable singletons. If an explicit finite sum is needed
privately, obtain local Fintype instances without strengthening the public
statement.

**Proof or implementation strategy:** Derive marginal KL non-top from the base
support guard and conditional KL non-top from the active-fiber guard. Rewrite
C8.08 with `ENNReal.toReal_add`. Keep the non-top bridge private.

**Edge cases:** Base support failure; active-fiber support failure; inactive
top fibers; both summands finite; coercion and toReal orientation.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL
lake env lean tmp/codex-c8-real-joint-kl-chain.lean
git diff --check
```

**Definition of done:** The theorem uses exactly the two approved PMF-facing
support guards, not global positivity or direct-ne-top hypotheses. The
unconditional `ENNReal` theorem remains primary.

**Downstream effect:** Completes the approved Real conditional-KL API.

**Documentation implications:** Update the plan outcome and audit the long
tentative name under Note 14.

**Risk level:** Medium.

**Fallback strategy:** Private finiteness lemmas or local Fintype synthesis are
allowed. Stronger public guards, a different conditional base, or public
direct-ne-top theorems require approval.

**Implementation outcome (July 31, 2026):** Complete. Added the public theorem
`toReal_klDiv_channelJoint_eq_add_conditionalKlDiv` in
`LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL`. It states the
Real-valued joint KL chain rule under exactly the two approved PMF-facing
guards:

```text
p.support subset q.support
forall x in p.support,
  (W x).support subset (V x).support.
```

The public signature uses `[Finite alpha] [Finite beta]`, measurable spaces,
and measurable singletons. It adds no positivity, global fiber-support,
absolute-continuity, explicit non-top, or `Fintype` assumption. The
conditional term remains based on the numerator law `p`.

The proof converts the base support guard to marginal KL finiteness with
`klDiv_pmf_ne_top_iff_support_subset`. It converts the active-fiber guard to
conditional KL finiteness through the existing private
`channelJoint_support_subset_iff_active` equivalence and the same public KL
finiteness characterization. Rewriting with the unconditional C8.08 theorem
then reduces the result to `ENNReal.toReal_add`. This direct support route
avoids an unnecessary finite-sum expansion, local `Fintype` synthesis, or
public direct-ne-top bridge. C8.09 remains the companion weighted Real
semantics theorem but need not be unfolded in this proof.

Direct source compilation and
`lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL` passed, the
latter with 2,748 jobs. A disposable consumer compiled the theorem under
generic `[Finite]` assumptions. Its Boolean boundary model verified that a
fiber KL equal to `top` is accepted when its numerator base mass is zero. The
same consumer separately verified that base-support failure invalidates the
first guard and that moving the violating fiber into active numerator support
invalidates the second guard. The consumer was deleted after validation.

A lightweight-root negative consumer confirmed that the opt-in theorem is not
exposed by `LeanInfoTheory`; the axiom audit reported only `propext`,
`Classical.choice`, and `Quot.sound`. Placeholder, scratch, root-isolation, and
whitespace checks passed. The public name is long but forms the exact
`toReal_` companion to C8.08, uses only mathematical API terms, and exposes no
private support helper. It is retained for the scheduled C8.20 naming review
without creating a separate Future Work Note 14 trigger. No import, aggregate,
root, canonical-memory, generated-documentation, or later-step status changed,
and no fallback or material scope deviation was required.

### C8.11 - Conditional-KL Integration Checkpoint

**Status:** `complete`

**Objective and reason:** Independently review the completed CKB workstream
before mutual-independence production hardening and aggregate wiring.

**Prerequisites:** C8.06--C8.10.

**Verified LeanInfoTheory declarations to reuse:** All new conditional-KL
declarations, `DataProcessing`, and the existing KL bridge.

**Verified mathlib APIs:** No new theorem; this step checks the use and
orientation of the verified KL/ENNReal APIs.

**Proposed declarations:** None by default. Public support extensionality may
not be added here without maintained consumer evidence.

**Target files, namespaces, and imports:** Inspect
`SemanticBridge.ConditionalKL` and its dependency closure. Leave the semantic
aggregate, root, canonical documents, and generated files unchanged.

**Proof or implementation strategy:** Audit exact assumptions, declaration
orientation, active support guards, top behavior, private-helper visibility,
and direct importability. Run positive direct consumers and a guarded negative
root/private-helper consumer.

**Edge cases:** All C8.06--C8.10 cases; finite versus Fintype assumptions;
measurable-singleton instances; root reachability; proof placeholders.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL
lake build LeanInfoTheory.Shannon.SemanticBridge.DataProcessing
lake build LeanInfoTheory
git diff --check
```

Also run the strict placeholder scan and delete all consumers.

**Definition of done:** The complete CKB public surface passes focused,
direct-import, root-isolation, private-helper, placeholder, and diff checks.
No theorem has been weakened, generalized to countable alphabets, or given an
unreviewed simp attribute.

**Downstream effect:** Establishes the conditional-KL integration checkpoint
for examples and aggregate exposure.

**Documentation implications:** Update only the plan outcome and genuine
Future Work pressure. Do not update canonical status.

**Risk level:** Low if prior steps pass.

**Fallback strategy:** Fix implementation or private-helper defects and rerun
the checkpoint. Public statement, assumption, or module changes require
approval.

**Implementation outcome (July 31, 2026):** Complete. Independently reviewed
the completed C8.06--C8.10 conditional-KL workstream without changing Lean
source. The directly importable module exposes exactly six public
declarations:

```text
conditionalKlDiv
conditionalKlDiv_self
conditionalKlDiv_eq_sum
toReal_conditionalKlDiv_eq_sum
klDiv_channelJoint_eq_add_conditionalKlDiv
toReal_klDiv_channelJoint_eq_add_conditionalKlDiv
```

The only additional theorem declaration is the private
`channelJoint_support_subset_iff_active` proof bridge. The definition and
self-zero theorem retain their non-finite contracts; the explicit weighted
sum uses `[Fintype alpha] [Finite beta]`; both joint chain rules use
`[Finite alpha] [Finite beta]`; and the two Real theorems expose only their
approved active-support guards. No theorem was weakened, generalized to
countable alphabets, assigned a simp attribute, or given a public non-top or
support-extensionality helper.

The independent checkpoint builds passed:

```text
lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL  (2,748 jobs)
lake build LeanInfoTheory.Shannon.SemanticBridge.DataProcessing (2,747 jobs)
lake build LeanInfoTheory                                      (2,240 jobs)
```

A disposable direct-import consumer applied all six public declarations at
their exact assumption levels. Its Boolean support-boundary model verified
that an inactive fiber KL equal to `top` is accepted by the guarded Real
weighted theorem, while activating the same violating fiber makes the
unconditional weighted conditional KL equal to `top`. The consumer was
deleted after validation.

Guarded negative consumers confirmed that `conditionalKlDiv` remains
unavailable from the lightweight root and that
`channelJoint_support_subset_iff_active` remains private. Axiom audits for all
five public theorems reported only `propext`, `Classical.choice`, and
`Quot.sound`. The strict repository-wide placeholder scan, no-simp and
no-countable-contract checks, scratch cleanup, `git diff --check`, and
untracked-file whitespace checks all passed.

No source, import, aggregate, root, canonical-memory, generated-documentation,
or Future Work change was needed. The completed CKB surface is ready for later
examples and aggregate exposure, and C8.12 remains untouched.

### C8.12 - Production Finite Mutual-Independence Predicates

**Status:** `complete`

**Objective and reason:** Harden the gate predicates as the stable PMF-first
law/source vocabulary for finite mutual independence.

**Prerequisites:** C8.02 and C8.11.

**Verified LeanInfoTheory declarations to reuse:** `familyMarginal`,
`familyLawOf`, and PMF coordinate maps.

**Verified mathlib APIs:** Finite products over subtype Fintypes and `PMF.ext`.

**Proposed declarations:** Gate declarations `[tentative]
IsMutuallyIndependentFamily` and `[tentative]
IsMutuallyIndependentFamilyOf`.

The intended law predicate is pointwise:

```text
forall x : FamilyOutcome alpha s,
  familyMarginal q s x =
    product i : s, (q.map (fun y => y i)) (x i).
```

The source predicate delegates through `familyLawOf p X`.

**Target files, namespaces, and imports:** Modify
`SemanticBridge.FiniteFamilyIndependence` in
`LeanInfoTheory.Shannon`; retain direct imports only.

**Proof or implementation strategy:** Finalize documentation and reducibility
of the two predicates without exposing product measures or dependent-coordinate
equivalences. Verify that mere statement formation requires neither
`[Fintype Var]` nor alphabet finiteness beyond what the expression actually
uses.

**Edge cases:** Empty selected subtype; arbitrary ambient `Var`; dependent
coordinates; zero product factors; proof irrelevance; no ordering.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence
git diff --check
```

**Definition of done:** The two public predicates exactly match the approved
pointwise contract, source independence is a thin law specialization, and no
public measurable-independence or product-measure API is introduced.

**Downstream effect:** Supplies C8.13--C8.16.

**Documentation implications:** Update the plan outcome and add both
tentative names to the C8.20 naming review.

**Risk level:** Medium.

**Fallback strategy:** Internal notation or elaboration changes are allowed.
A different public representation, extra ambient finiteness, or measurable
predicate requires approval.

**Implementation outcome (July 31, 2026):** Complete. Hardened the two
proof-complete C8.02 gate definitions as the production law/source vocabulary
without changing either declaration body, public name, namespace, import, or
reducibility:

```text
IsMutuallyIndependentFamily
IsMutuallyIndependentFamilyOf
```

`IsMutuallyIndependentFamily q s` remains exactly the pointwise
factorization of `familyMarginal q s` into the product of the ordinary
one-coordinate pushforward masses. `IsMutuallyIndependentFamilyOf p X s`
remains definitionally the same law predicate specialized to
`familyLawOf p X`. The module and declaration comments now state this
production contract explicitly, including the absence of a parallel source
semantics or public product-PMF representation.

The declarations require no `[Fintype Var]`, no finite ambient variable type,
no finite component alphabets, no decidable equality merely to state a
general atom, and no ordering. Empty and singleton atoms are valid predicate
inputs; entropy-specific finiteness remains confined to later theorems and
the existing private feasibility infrastructure.

`lake build
LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence` passed with
2,704 jobs. A disposable direct-import consumer checked both definitional
contracts by `rfl`, an infinite `Nat` ambient index, empty and singleton atom
formation, and a genuinely dependent `Bool`/`Nat` alphabet whose second
component is infinite. The consumer was deleted after validation.

Guarded negative consumers confirmed that the predicates are not yet exposed
through either the semantic aggregate or the lightweight root and that the
private normalized `familyProduct` remains inaccessible. The strict
repository-wide placeholder scan, no-simp audit, scratch cleanup,
`git diff --check`, and untracked-file whitespace checks passed.

The two names preserve the established PMF/source `...Of` distinction and
expose no product, projection, equivalence, or proof-helper detail. They remain
explicit inputs to the scheduled C8.20 naming review as approved, but no
separate Future Work Note 14 trigger or compatibility alias is justified now.
No public measurable-independence, product-measure, or auxiliary theorem was
introduced. C8.13 remains untouched, and no fallback or scope deviation was
required.

### C8.13 - Law-Facing Empty And Singleton Independence

**Status:** `complete`

**Objective and reason:** Establish the two canonical base cases for the
law-facing mutual-independence predicate.

**Prerequisites:** C8.12 and the private C8.02 base-case machinery.

**Verified LeanInfoTheory declarations to reuse:** `familyMarginal`,
`familyEntropy_empty`, `familyEntropy_singleton`, and PMF map normalization.

**Verified mathlib APIs:** Empty and singleton finite products, PMF total mass,
subtype extensionality, and function extensionality.

**Proposed declarations:** `[tentative]
isMutuallyIndependentFamily_empty` and `[tentative]
isMutuallyIndependentFamily_singleton`.

**Target files, namespaces, and imports:** Modify
`SemanticBridge.FiniteFamilyIndependence`; no import change.

**Proof or implementation strategy:** For the empty atom, identify the unique
empty-family outcome and reduce both sides to one. For a singleton, identify
the selected marginal mass with the ordinary coordinate pushforward and the
one-factor product. Keep any evaluator or equivalence private.

**Edge cases:** Empty `Finset`; no constructed `PMF Empty`; singleton subtype
proof witnesses; arbitrary ambient `Var`; no source forwarding theorem.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence
lake env lean tmp/codex-c8-independence-base.lean
git diff --check
```

Delete the disposable consumer.

**Definition of done:** Exactly two law-facing public base theorems compile.
No source wrappers or simp attributes are added.

**Downstream effect:** Supplies reviewed base cases for C8.14--C8.16 and
examples.

**Documentation implications:** Update the plan outcome; reserve simp
decisions for C8.20.

**Risk level:** Medium.

**Fallback strategy:** Private singleton/empty equivalences are allowed.
Source wrappers, stronger alphabet assumptions, or simp attributes require
later evidence and approval where material.

**Implementation outcome (July 31, 2026):** Complete. Promoted exactly the
two proof-complete C8.02 law-facing base lemmas to the public API:

```text
isMutuallyIndependentFamily_empty
isMutuallyIndependentFamily_singleton
```

Both theorem bodies remain unchanged from the feasibility gate. The empty
proof identifies the unique empty-family restriction, rewrites its pushforward
as a constant PMF, and reduces the empty coordinate product to one. The
singleton proof maps the selected marginal through a private injective
evaluator, identifies that map with the ordinary coordinate pushforward, and
reduces the product to its sole factor.

The public signatures require no finite ambient variable type, finite
component alphabet, measurable structure, positivity, or caller-supplied
decidable equality. The private `singletonFamilyEval` and
`singletonFamilyEval_injective` declarations remain implementation details,
so singleton subtype membership witnesses do not leak into the public API.

`lake build
LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence` passed with
2,704 jobs. A disposable direct-import consumer instantiated both theorems
generically and on a dependent `Bool`/`Nat` family, including the
infinite-valued singleton coordinate. It was deleted after validation.
Guarded negative consumers confirmed that the singleton evaluator remains
private, no source-facing empty wrapper exists, and the lightweight root does
not expose the new theorem.

Axiom audits reported only `propext`, `Classical.choice`, and `Quot.sound`.
The strict repository-wide placeholder scan, no-simp and no-source-wrapper
audits, scratch cleanup, `git diff --check`, and untracked-file whitespace
checks passed.

No source-facing wrapper, simp attribute, new helper, alias, import, aggregate,
root, canonical-memory, generated-documentation, or Future Work item was
added. The two names are systematic extensions of the predicate vocabulary
and remain subject to the scheduled C8.20 naming/simp review. C8.14 remains
untouched, and no fallback or scope deviation was required.

### C8.14 - Law-Facing Restriction To Subsets

**Status:** `complete`

**Objective and reason:** Publish that mutual independence of a finite atom is
inherited by every selected subset.

**Prerequisites:** C8.02 private restriction proof, C8.12 predicate, and
C8.13 base cases.

**Verified LeanInfoTheory declarations to reuse:**
`familyMarginal_restrict` and finite PMF normalization.

**Verified mathlib APIs:** Finite dependent products and sums,
Finset subset/difference laws, `Fintype.ofFinite`, and PMF extensionality.

**Proposed declarations:** `[tentative]
isMutuallyIndependentFamily_mono`, with orientation:

```text
IsMutuallyIndependentFamily q t ->
s subset t ->
IsMutuallyIndependentFamily q s.
```

Final argument order and name remain subject to C8.20.

**Target files, namespaces, and imports:** Modify
`SemanticBridge.FiniteFamilyIndependence`; no new import unless the gate
demonstrated an unavoidable direct finite-product dependency.

**Proof or implementation strategy:** Reuse the gate's private restriction
proof. Marginalize the factorized law on `t`, sum out the finitely many removed
coordinates, and normalize each removed coordinate marginal to total mass
one. Keep projection witnesses and dependent casts private.

**Edge cases:** Empty subset; equality of atoms; dependent finite alphabets;
arbitrary ambient `Var`; subtype proof irrelevance; no source forwarding
theorem.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence
lake env lean tmp/codex-c8-independence-restrict.lean
git diff --check
```

**Definition of done:** One law-facing subset theorem compiles without
`[Fintype Var]`, without exposing `Finset.restrict2`-style proof machinery, and
without a source wrapper.

**Downstream effect:** Supplies a reviewed public theorem and the restriction
fact needed by C8.16.

**Documentation implications:** Update the plan outcome and naming watchlist.

**Risk level:** High.

**Fallback strategy:** Private finite-sum or product-measure proofs are
allowed. Restriction only to initial segments, homogeneous alphabets, public
projection helpers, or source forwarding requires approval.

**Implementation outcome (July 31, 2026):** Complete. Added the single
approved law-facing restriction theorem
`isMutuallyIndependentFamily_mono` with argument order

```text
(h : IsMutuallyIndependentFamily q t)
(hst : s subset t)
```

and conclusion `IsMutuallyIndependentFamily q s`. Its public assumptions are
only pointwise `[forall i, Finite (alpha i)]`; the ambient variable type is
arbitrary, and neither `[Fintype Var]` nor `[DecidableEq Var]` appears in the
signature.

The proof keeps all projection and dependent-coordinate machinery private. It
uses classical decidable equality locally, decomposes `t` as
`s union (t \ s)` with `Finset.union_sdiff_of_subset`, observes the two blocks
are disjoint, and applies the proof-complete private left-block restriction
theorem. No finite product, marginal projection, subtype witness, or
`Finset.restrict2` detail is exposed publicly.

`lake build
LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence` passed with
2,704 jobs. A disposable direct-import consumer exercised the theorem
generically, on equality and empty subsets, with an infinite ambient `Nat`
index, and on a proper subset of a dependent `Bool`/`Fin 3` family. The
heterogeneous fixture supplied its pointwise finite instances explicitly; no
ambient enumeration was needed. The consumer was deleted after validation.

Guarded negative consumers confirmed that the private disjoint-union
restriction helper remains inaccessible, no source-facing monotonicity
wrapper exists, and the lightweight root does not expose the theorem. The
axiom audit reported only `propext`, `Classical.choice`, and `Quot.sound`.
The strict repository-wide placeholder scan, no-simp and no-source-wrapper
audits, scratch cleanup, `git diff --check`, and untracked-file whitespace
checks passed.

The `..._mono` name matches the established `familyEntropy_mono` vocabulary,
states the mathematical inheritance direction, and exposes no implementation
detail. It remains an explicit input to the scheduled C8.20 naming review but
does not justify a separate Future Work Note 14 entry now. No source wrapper,
simp attribute, alias, import, aggregate, root, canonical-memory, or
generated-documentation change was made. C8.15 remains untouched, and no
fallback or scope deviation was required.

### C8.15 - Source-Facing Distinct-Index Pair Compatibility

**Status:** `complete`

**Objective and reason:** Connect finite mutual independence to the existing
pairwise random-variable API with one public textbook-facing theorem.

**Prerequisites:** C8.02 pair-block machinery, C8.12 predicates, and existing
`IsIndependentOf`.

**Verified LeanInfoTheory declarations to reuse:**
`IsIndependentOf`, `isIndependentOf_iff_map_eq_indepProd`,
`isIndependent_iff_apply_eq_mul_marginals`, `familyLawOf`, and
`familyMarginal`.

**Verified mathlib APIs:** PMF map composition, two-element Finset
normalization, dependent subtype extensionality, and pair extensionality.

**Proposed declarations:** One public `[tentative]
isMutuallyIndependentFamilyOf_pair_iff_isIndependentOf`, expressing for
`i != j`:

```text
IsMutuallyIndependentFamilyOf p X {i, j} <->
  IsIndependentOf p (X i) (X j).
```

No law-facing public bridge is proposed.

**Target files, namespaces, and imports:** Modify
`SemanticBridge.FiniteFamilyIndependence`; no aggregate/root change.

**Proof or implementation strategy:** Use a private equivalence between a
two-index dependent family outcome and the ordered product
`alpha i x alpha j`. Normalize the source family law and coordinate marginals,
then apply the existing pointwise or independent-product pair
characterization. Maintain a private law-facing consumer to confirm
interoperability without publishing a second theorem.

**Edge cases:** `i != j` is essential; coordinate orientation; dependent
alphabets; subtype proof witnesses; zero masses; avoiding exposure of the
private equivalence.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence
lake env lean tmp/codex-c8-source-pair-independence.lean
git diff --check
```

The consumer must exercise the public source theorem and private law
compatibility and then be deleted.

**Definition of done:** Exactly one source-facing public pair theorem compiles
with `i != j`, and the law-facing compatibility is tested privately. No second
bridge or coordinate-equivalence API is exposed.

**Downstream effect:** Connects the new n-way API to Chunk 2's pair API and
supports examples.

**Documentation implications:** Update the plan outcome. Audit the unusually
long tentative name under Note 14.

**Risk level:** High.

**Fallback strategy:** Internal equivalence or map-normalization changes are
allowed. If the source theorem cannot be stated cleanly without exposing
dependent-coordinate machinery, stop and request approval before choosing a
law-facing public theorem or private-only fallback.

**Implementation outcome (July 31, 2026):** Complete. Added the one approved
source-facing theorem
`isMutuallyIndependentFamilyOf_pair_iff_isIndependentOf`. For distinct
`i` and `j`, it identifies mutual independence of the selected source atom
`{i, j}` exactly with `IsIndependentOf p (X i) (X j)`. The theorem supports
dependent component alphabets and arbitrary source and ambient index types.
It requires only `[DecidableEq Var]`, which is the representation-level
instance used to form the ordered two-element `Finset`; it adds no alphabet
finiteness, support, positivity, or measurable-space assumption.

The proof uses a private injective evaluator from the dependent two-coordinate
outcome to `alpha i x alpha j`, together with a private constructor for
arbitrary ordered pairs. A private finite-product normalization converts the
subtype-indexed factorization into the product of the `i` and `j` coordinate
masses. A private law-facing equivalence then transports the family marginal
through the evaluator and applies
`isIndependent_iff_apply_eq_mul_marginals` in both directions. Finally,
`familyLawOf` and `PMF.map_comp` reduce this law statement to the existing
source-facing `IsIndependentOf` predicate. All dependent casts, subtype
witnesses, product normalization, and law-facing transport remain private;
no coordinate equivalence or second public bridge was added.

`lake build
LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence` passed with
2,704 jobs. A disposable direct-import consumer compiled the public theorem,
its `.mp` and `.mpr` directions, the reversed `j`/`i` orientation, and the
corresponding law-facing identity obtained from the coordinate-evaluation
source family. The theorem's axiom audit reported only `propext`,
`Classical.choice`, and `Quot.sound`. The consumer was deleted after
validation. The strict placeholder scan, import audit, scratch and whitespace
hygiene checks, and `git diff --check` passed.

The public name is unusually long but follows the exact
`IsMutuallyIndependentFamilyOf`/`IsIndependentOf` vocabulary and exposes none
of the private representation machinery. Future Work Note 14 records it for
the scheduled C8.20 consumer review; no alias or rename was introduced during
the active theorem phase. No existing declaration, import, simp attribute,
aggregate, root, certificate, canonical semantic contract, or generated
documentation changed. C8.16 remains untouched, and no fallback or scope
deviation was required.

### C8.16 - Law/Source N-Way Entropy-Equality Characterizations

**Status:** `complete`

**Objective and reason:** Publish the equality case of Cover--Thomas Theorem
2.6.6 for arbitrary finite dependent-family atoms:

```text
familyEntropy q s =
    sum i in s, familyEntropy q {i}
  <->
IsMutuallyIndependentFamily q s.
```

and its source-family counterpart.

**Prerequisites:** C8.02 proof-complete iff, C8.12 predicates, C8.13 base
cases, C8.14 restriction, and the existing n-way subadditivity inequality.

**Verified LeanInfoTheory declarations to reuse:**
`familyEntropy_le_sum_singletons`,
`familyEntropyOf_le_sum_singletons`,
`familyEntropy_union`,
`jointEntropy_eq_add_marginalEntropy_iff_isIndependent`, and `familyLawOf`.

**Verified mathlib APIs:** Finset induction, finite sums, linear-order
antisymmetry, and Real arithmetic.

**Proposed declarations:** `[tentative]
familyEntropy_eq_sum_singletons_iff_isMutuallyIndependentFamily` and
`[tentative]
familyEntropyOf_eq_sum_singletons_iff_isMutuallyIndependentFamilyOf`.

**Target files, namespaces, and imports:** Modify
`SemanticBridge.FiniteFamilyIndependence`; no aggregate/root change.

**Proof or implementation strategy:** Refactor the gate's private exact iff
into the public law theorem without weakening it. Derive the source theorem by
specialization to `familyLawOf p X` and normalization of singleton source
entropies. Keep insert reconstruction, pair-block maps, and measurable
independence private.

**Edge cases:** Empty and singleton atoms; dependent finite alphabets; no
`Fintype Var`; ordering independence; zero-mass outcomes; mutual rather than
pairwise independence; both directions of the iff.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence
lake env lean tmp/codex-c8-entropy-independence-iff.lean
git diff --check
```

The consumer must exercise both directions and the source theorem, then be
deleted.

**Definition of done:** Both exact public iff theorems compile for arbitrary
finite atoms and dependent alphabets. No ordered-list hypothesis, public
`iIndepFun`, product PMF, or stronger ambient assumption appears.

**Downstream effect:** Completes the approved finite mutual-independence
mathematics.

**Documentation implications:** Update the plan outcome and Note 14 watchlist
for the long tentative names.

**Risk level:** High, controlled by C8.02.

**Fallback strategy:** Internal induction and private-helper refactoring is
allowed. One direction only, homogeneous alphabets, changed factorization, or
stronger assumptions requires approval.

**Implementation outcome (July 31, 2026):** Complete. Published the two
approved exact characterizations:

- `familyEntropy_eq_sum_singletons_iff_isMutuallyIndependentFamily`;
- `familyEntropyOf_eq_sum_singletons_iff_isMutuallyIndependentFamilyOf`.

The law-facing theorem is the proof-complete private C8.02 characterization
promoted under its approved public name without changing its statement,
assumptions, or induction. It applies to every `s : Finset Var`, requires
pointwise finite dependent alphabets and `[DecidableEq Var]`, and does not
require `[Fintype Var]`, an ordering of `s`, support or positivity hypotheses,
or homogeneous component types. The source theorem is a definitional
specialization to `familyLawOf p X`; unfolding `familyEntropyOf` and
`IsMutuallyIndependentFamilyOf` normalizes every singleton term without a
second proof.

The law proof handles the empty atom with the existing empty-independence and
zero-entropy laws. In the insert case, the forward implication combines n-way
subadditivity and binary union subadditivity to force equality on the tail,
uses the pair entropy-equality characterization to recover block
independence, and reconstructs mutual independence. The reverse implication
restricts mutual independence to the tail and the singleton/tail blocks,
converts block independence back to entropy additivity, and applies the
induction hypothesis. All normalized product PMFs, block maps, subtype casts,
and pair-law machinery remain private.

`lake build
LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence` passed with
2,704 jobs. A disposable direct-import consumer exercised both directions of
the law theorem, both directions of the source theorem, the empty and
singleton cases, and a finite atom in an infinite `Nat`-indexed Boolean
family. Both public declarations reported only `propext`,
`Classical.choice`, and `Quot.sound` in their axiom audits. The consumer was
deleted after validation. The strict placeholder scan, public-declaration and
import audits, scratch and whitespace hygiene checks, and `git diff --check`
passed.

Future Work Note 14 records both long names for the scheduled C8.20 consumer
review and a provisional `...additive_iff_...` alias pattern; neither current
name was changed and no alias was added during the active theorem phase.
Exactly two public declarations were added. No existing theorem statement,
import, simp attribute, aggregate, root, certificate, generated reference, or
website file changed. C8.17 remains untouched, and no fallback or scope
deviation was required.

### C8.17 - Independence Checkpoint And Semantic-Aggregate Wiring

**Status:** `complete`

**Objective and reason:** Independently review the completed independence
workstream, then expose both completed heavy Chunk 8 modules through the
opt-in semantic aggregate.

**Prerequisites:** C8.11 and C8.12--C8.16.

**Verified LeanInfoTheory declarations to reuse:** All new independence and
conditional-KL declarations; the existing
`LeanInfoTheory.Shannon.SemanticBridge` aggregate.

**Verified mathlib APIs:** No new theorem; this step validates existing proof
dependencies and public visibility.

**Proposed declarations:** None by default. Add imports for the two new
semantic modules to the aggregate.

**Target files, namespaces, and imports:** Review
`SemanticBridge.FiniteFamilyIndependence`; modify
`LeanInfoTheory/Shannon/SemanticBridge.lean` to import
`SemanticBridge.ConditionalKL` and
`SemanticBridge.FiniteFamilyIndependence`. Do not modify
`LeanInfoTheory.lean`.

**Proof or implementation strategy:** Audit the exact public declaration
inventory, pair bridge, source forwarding restraint, private helper
visibility, direct imports, aggregate import order, and absence of cycles.
Build direct and aggregate consumers and guard a negative root consumer.

**Edge cases:** Empty/singleton/restriction/equality contracts; proof
irrelevance; direct importability; aggregate exposure; root and certificate
isolation.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence
lake build LeanInfoTheory.Shannon.SemanticBridge
lake build LeanInfoTheory
git diff --check
```

Run the placeholder scan and delete all disposable consumers.

**Definition of done:** The independence API passes focused checks; both heavy
modules are directly importable and aggregate-visible; neither reaches the
root; no cycle, public measurable-independence bridge, or certificate change
appears.

**Downstream effect:** Establishes the second heavy-workstream checkpoint and
unlocks maintained examples.

**Documentation implications:** Update only the plan outcome and genuine
Future Work pressure.

**Risk level:** Medium.

**Fallback strategy:** Reorder aggregate imports or remove accidental
transitive dependencies. Consolidating modules, altering ownership, or
exposing either through the root requires approval.

**Implementation outcome (July 31, 2026):** Complete. Independently reviewed
the completed conditional-KL and finite-family-independence workstreams, then
added both modules to the opt-in
`LeanInfoTheory.Shannon.SemanticBridge` aggregate. The aggregate import order
keeps `FiniteFamilyIndependence` after its `FiniteFamily` and `Independence`
dependencies and `ConditionalKL` after `DataProcessing`; no reverse aggregate
import or dependency cycle was introduced. The aggregate module summary now
records the conditional-KL weighted/chain-rule surface and the mutual-
independence factorization/equality surface.

The reviewed public inventory is exact: `ConditionalKL` exposes one definition
and five theorems, while `FiniteFamilyIndependence` exposes two predicates and
six theorems. The latter surface contains only the approved empty, singleton,
distinct-pair source compatibility, law-facing restriction, and law/source
entropy-equality declarations. It adds no source forwarding wrappers for the
base cases or restriction theorem and no public `iIndepFun`, product PMF,
pair-block law, coordinate equivalence, projection, or measurable n-way
independence bridge. `ConditionalKL` retains one private active-support helper;
all finite-family product, block, projection, evaluator, constructor, and
induction helpers remain private.

The two direct modules built together successfully with 2,753 jobs.
`lake build LeanInfoTheory.Shannon.SemanticBridge` passed with 2,760 jobs, and
`lake build LeanInfoTheory` passed with 2,240 jobs. Separate direct-import
consumers checked all six conditional-KL and all eight finite-family-
independence declarations. An aggregate consumer checked all fourteen names
and audited every public theorem; each theorem reported only `propext`,
`Classical.choice`, and `Quot.sound`.

Guarded negative consumers confirmed that neither new API is visible from
`LeanInfoTheory` or `LeanInfoTheory.Certificate.Checked`, and that the watched
private support, product, and pair-law helpers are inaccessible. All
disposable consumers were deleted. The strict placeholder scan, root and
certificate isolation audits, scratch and whitespace hygiene checks, and
`git diff --check` passed.

No public declaration, theorem statement, proof, simp attribute, certificate
surface, or lightweight-root import changed. No existing semantic submodule's
dependency list was altered; only the approved aggregate imports were added.
No genuine helper, alias, or Future Work pressure arose. C8.18 remains
untouched, and no fallback or architectural deviation was required.

### C8.18 - Maintained Conditional-KL Examples

**Status:** `complete`

**Objective and reason:** Add maintained, non-public examples that exercise the
conditional-KL API and its support/top boundaries.

**Prerequisites:** C8.11 and C8.17.

**Verified LeanInfoTheory declarations to reuse:** The complete
conditional-KL API, finite pure/uniform PMFs, channel joints, and existing
example conventions.

**Verified mathlib APIs:** `InformationTheory.klDiv_self`, standard PMF pure
support simplification, and ENNReal top/zero arithmetic.

**Proposed declarations:** No new public mathematical declaration. Private or
anonymous example declarations only. Proposed module name `[tentative]
LeanInfoTheory.Examples.ConditionalKL`.

**Target files, namespaces, and imports:** Create
`LeanInfoTheory/Examples/ConditionalKL.lean` and import it from
`LeanInfoTheory/Examples.lean`. Do not import it from the root.

**Proof or implementation strategy:** Use small finite bases and output
alphabets. Include:

- a null base fiber;
- an active finite fiber;
- an inactive fiber whose component KL is `top`;
- an active component KL equal to `top`;
- the unconditional distinct-base joint chain rule;
- the guarded Real weighted theorem;
- the guarded Real chain rule.

Use the examples to test whether two-sided support extensionality has genuine
consumer value. Do not add it merely because it is mathematically available.

**Edge cases:** `0 * top`; positive-over-zero; base and active-fiber support
guards; no constructed PMF on an empty base; root isolation.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Examples.ConditionalKL
lake build LeanInfoTheory.Examples
git diff --check
```

**Definition of done:** Every required branch is maintained in a separately
importable example module, no test-only public helper is added, and the
examples aggregate and root boundary remain correct.

**Downstream effect:** Supplies evidence for C8.20 naming, simp, helper, and
support-extensionality decisions.

**Documentation implications:** Update the plan outcome only. Record
support-extensionality pressure if and only if an example genuinely benefits.

**Risk level:** Medium.

**Fallback strategy:** Simpler private fixtures or anonymous examples are
allowed. A new public helper, support theorem, or representation requires
review and approval.

**Implementation outcome (July 31, 2026):** Complete. Added the separately
importable `LeanInfoTheory.Examples.ConditionalKL` module and wired it only
into the opt-in `LeanInfoTheory.Examples` aggregate. Its Boolean fixtures and
all regression declarations are private. No public mathematical declaration,
alias, simp rule, reusable test helper, semantic import, certificate surface,
or lightweight-root import was added.

The maintained examples exercise `conditionalKlDiv_self`, the unconditional
weighted `ENNReal` formula, the support-guarded Real weighted formula, the
unconditional distinct-base joint chain rule, and the support-guarded Real
joint chain rule. The Real chain-rule consumer composes
`toReal_klDiv_channelJoint_eq_add_conditionalKlDiv` with
`toReal_conditionalKlDiv_eq_sum`, exposing the fully expanded finite textbook
formula without adding a duplicate public corollary.

One compact model puts all base mass on `false`. Its active fiber compares a
point mass with the full-support uniform law, so its KL divergence is finite
and nonzero. Its null `true` fiber compares mutually singular point masses, so
the component KL divergence is `top` while the weighted term is exactly
`0 * top = 0`; the total conditional KL is therefore the active finite,
nonzero component. A second private channel makes the singular fiber active
and confirms that the total conditional KL is `top`. The examples also check
the null base mass, active support guards, base support inclusion, and that the
two base laws used by the joint chain rule are genuinely distinct. No PMF on
an empty type is constructed.

A post-step audit against the strengthened Future Work Note 17 assignment
also restored both maintained joint-chain `top` branches from the C8.08
consumer matrix: disjoint base laws give base KL `top` with zero conditional
KL, while equal base laws with the active singular channel give zero base KL
with conditional KL `top`. Both complete joint divergences reduce to `top`.
These additional checks remain private and add no fixture or mathematical API.

Direct source elaboration passed. The final post-audit
`lake build LeanInfoTheory.Examples.ConditionalKL` passed with 2,749 jobs, and
the combined `lake build LeanInfoTheory.Examples LeanInfoTheory` passed with
2,781 jobs. A guarded negative root consumer confirmed that
`conditionalKlDiv_eq_sum` remains unavailable from `LeanInfoTheory` and was
deleted. The strict placeholder, public-declaration, conflict-marker,
step-scratch, and whitespace scans passed, as did `git diff --check`.

The examples required no two-sided support-extensionality theorem and did not
create genuine helper, assumption, naming, or Future Work pressure. The long
joint-chain theorem names were usable through direct rewrites; their final
discoverability review remains assigned to C8.20. C8.19 remains not started.

### C8.19 - Maintained CMI And Independence Examples

**Status:** `complete`

**Objective and reason:** Exercise the complete lightweight CMI and finite
mutual-independence surfaces on permanent finite-family models.

**Prerequisites:** C8.05 and C8.12--C8.17.

**Verified LeanInfoTheory declarations to reuse:** Existing
`Examples.FiniteFamily` Boolean and dependent-alphabet models; the four new CMI
rules; the independence predicates, base cases, restriction, pair bridge, and
entropy iff theorems.

**Verified mathlib APIs:** Finite sums/products and `decide` for small concrete
finite propositions where appropriate.

**Proposed declarations:** No public mathematical API. Maintained examples may
use private or anonymous declarations.

**Target files, namespaces, and imports:** Extend
`LeanInfoTheory/Examples/FiniteFamily.lean`; keep
`LeanInfoTheory.Examples` as its aggregate owner.

**Proof or implementation strategy:** Exercise:

- binary law/source conditional CMI;
- ordered law/source conditional CMI;
- empty and overlapping atoms;
- duplicate ordered names;
- a name already in the initial conditioning atom;
- empty and singleton mutual independence;
- dependent-alphabet factorization;
- strict subset restriction;
- the public source-facing distinct pair theorem;
- private law-facing pair compatibility;
- both directions of law/source entropy equality.

Test whether source users experience real friction from the absence of
elementary source forwarding. Report evidence during C8.20; do not add wrappers
silently.

**Edge cases:** Arbitrary non-Fintype variable-name type; dependent alphabets;
proof irrelevance; pairwise versus mutual independence; duplicate list
positions; overlapping atoms.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Examples.FiniteFamily
lake build LeanInfoTheory.Examples
git diff --check
```

**Definition of done:** Every approved family contract has a maintained
consumer, including both directions of entropy equality and private law-facing
pair compatibility. No public test-only helper or automatic source forwarding
is introduced.

**Downstream effect:** Supplies consumer evidence for C8.20.

**Documentation implications:** Update the plan outcome and record only
genuine API pressure.

**Risk level:** Medium.

**Fallback strategy:** Add compact private fixtures within the existing
example module. A separate public model API or source-forwarding family
requires approval.

**Implementation outcome:** Completed July 31, 2026. Extended
`LeanInfoTheory.Examples.FiniteFamily` with maintained private or anonymous
consumers for all four conditional-mutual-information chain rules. The law and
source binary examples cover overlapping and empty atoms; the ordered examples
use a repeated variable name and an initial conditioning atom that already
contains that name.

The existing dependent-alphabet model now checks empty and singleton mutual
independence and proves its Boolean/ternary pair factorization through the
public source-facing pair theorem. A private generic consumer recovers the
law-facing pair equivalence from that same public theorem and the identity
source map. This required only a short local `PMF.map_id` bridge and created no
pressure for public source forwarding or exposure of the private production
pair theorem.

Two stronger private fixtures exercise the substantive boundaries requested by
the later Future Work review. A nondegenerate three-bit product source proves
full source/law mutual independence, strict-subset restriction, positive
singleton entropies, and both directions of both law/source entropy-additivity
characterizations. The Boolean xor family proves all three distinct pairs
independent through the public pair bridge, then refutes three-way mutual
independence at the all-false outcome: its joint mass is `1/4`, whereas the
product of the three uniform coordinate masses is `1/8`. This keeps the
pairwise-versus-mutual distinction computationally explicit.

All new fixtures, helper equivalences, factorization calculations, and the
three-coordinate variable type are private; no public declaration, alias,
simp rule, theorem statement, or reusable helper was added. The example module
now directly imports `Shannon.EntropyBounds` for the positive singleton-entropy
check and `Shannon.SemanticBridge.FiniteFamilyIndependence` for the approved
surface. Its existing aggregate ownership is unchanged, and neither import
reaches `LeanInfoTheory.lean`.

The initial and final focused builds of
`lake build LeanInfoTheory.Examples.FiniteFamily` passed with 2,711 jobs; the
final run rebuilt the module after its documentation-title cleanup. The
aggregate `lake build LeanInfoTheory.Examples` passed with 2,778 jobs, and
`lake build LeanInfoTheory` passed with 2,240 jobs. The strict placeholder,
conflict-marker, root-import-isolation, C8.19 scratch, and whitespace/diff
checks passed. All three disposable proof probes were deleted. No genuine
name, helper, forwarding, assumption, or new Future Work pressure arose;
C8.20 remains not started.

**Post-step verification follow-up (July 31, 2026):** A targeted reread of the
post-C8.17 review in Future Work Note 1 found that it explicitly assigned an
empty-*list* ordered-CMI regression to C8.19. The initial implementation
covered an empty Finset atom but not `l = []`. Added one private law-facing
empty-order consumer of `familyCondMutualInfo_chain_rule`; the existing source
empty-atom, law/source repeated-order, overlap, heterogeneous, and initial-
conditioning cases remain unchanged. This closes the only discrepancy found
by the post-step contract audit without adding public API or beginning C8.20.

**Post-step critical-review polish (July 31, 2026):** Added concise internal
section comments separating the Boolean conditional-MI, pairwise-versus-mutual
independence, and certificate consumers, plus the heterogeneous mutual-
independence block. This comment-only cleanup makes the expanded maintained
example module easier to audit and does not perform C8.20's API, source-owner,
naming, simp, assumption, or import review. No theorem, proof, fixture,
declaration, import, or attribute changed.

### C8.20 - API, Naming, Simp, Helper, Assumption, And Import Review

**Status:** `complete`

**Objective and reason:** Freeze the complete Chunk 8 public and import surface
before canonical documentation and generated references are updated.

**Prerequisites:** C8.18--C8.19 and every mathematical step complete.

**Verified LeanInfoTheory declarations to reuse:** Current generated
declaration inventory; all new Chunk 8 declarations; `AGENTS.md` public naming
and architecture rules; Future Work Notes 14--18, 24, 36, 38, and 39.

**Verified mathlib APIs:** No new theorem. Review the actual use and visibility
of KL, ENNReal, finite-product, and optional private independence APIs.

**Proposed declarations:** None by default. Compatibility-preserving naming
decisions, private helper extraction, or attributes are evidence-driven.
Public support extensionality may be proposed only if C8.18 demonstrated value.

**Target files, namespaces, and imports:** Review every touched Lean and
example module plus semantic/root aggregates. Do not update canonical memory,
generated references, or website files.

**Proof or implementation strategy:** Audit:

- public naming under Note 14;
- theorem orientation and source/law discoverability;
- the exact `[Finite]`/`[Fintype]`/measurable assumptions;
- active support guards and direct-ne-top privacy;
- proof irrelevance and dependent-coordinate names;
- private helper pressure;
- public declaration count and no accidental forwarding;
- direct imports, aggregate imports, root and certificate reachability;
- simp candidates and critical pairs.

Test, but do not preapprove, `[simp]` for
`conditionalKlDiv_self`, empty mutual independence, and singleton mutual
independence. Verify chain rules remain explicit. Test endpoint, proof-
irrelevance, zero-weight/top, and no-premature-simp goals.

**Edge cases:** Every mathematical boundary from C8.01--C8.19; rewrite cycles;
unexpected unfolding of predicates; support-hypothesis strengthening; aliases
that create competing vocabulary.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence
lake build LeanInfoTheory.Shannon.SemanticBridge
lake build LeanInfoTheory.Examples
lake build LeanInfoTheory
git diff --check
```

Run direct/root/private consumers and the strict placeholder scan; delete all
disposable files.

**Definition of done:** Every new public name, assumption, theorem
orientation, simp decision, helper, import, and visibility boundary is
reviewed and recorded. No speculative alias, source forwarding, public
measurable-independence bridge, direct-ne-top family, or support
extensionality theorem is added without demonstrated pressure and approval.

**Downstream effect:** Freezes the source/API state for integration and
documentation.

**Documentation implications:** Update the plan outcome and relevant Future
Work notes only for decisions or demonstrated pressure. Canonical status
remains unchanged until C8.22.

**Risk level:** Medium.

**Fallback strategy:** Retain explicit rewrites and current names when no
better reviewed choice exists. Material renaming, module, theorem, assumption,
or trust changes require approval before editing the plan.

**Implementation outcome:** Completed July 31, 2026. Reviewed all 18 new Chunk
8 public declarations through their owning modules and one direct-import
manifest. The exact theorem orientations and `Finite`/`Fintype`, measurable-
singleton, active-support, arbitrary ambient-index, and dependent-alphabet
contracts remain unchanged. No public declaration, alias, source forwarding,
support-extensionality theorem, measurable-independence bridge, direct-`ne_top`
family, or support-indexed formula was added.

The three Future Work Note 14 watch names were retained without aliases after
the C8.19 maintained consumers and direct review found their explicit wording
more discoverable than the proposed abbreviations. In particular,
`isMutuallyIndependentFamilyOf_pair_iff_isIndependentOf` preserves both
established predicate names, while the two entropy iff names make the exact
sum-of-singletons equality visible rather than overloading `additive`.

Focused local and exported-attribute probes justified three strictly reducing
`[simp]` rules: `conditionalKlDiv_self`,
`isMutuallyIndependentFamily_empty`, and
`isMutuallyIndependentFamily_singleton`. They normalize direct, nested,
`ENNReal.toReal`, source-unfolded, and empty entropy-characterization goals
without selecting the weighted, joint-chain, or private product-law
representations. All four conditional-mutual-information chain rules remain
explicit and continue to be exercised by name in the maintained overlap,
duplicate, empty-list, and initially-conditioned consumers.

Two production proofs repeated the same active-support-to-weighted-KL-
finiteness calculation, so the argument was extracted as the private
`weighted_klDiv_ne_top_of_active_support` and reused without moving `toReal`
conversion or changing a public guard. The conditional-KL module title and
semantic-aggregate summary now distinguish the type-generic definition and
self theorem from the finite weighted and chain-rule formulas. Finite-family
comments now record overlap and duplicate tolerance, pair distinctness, and
the separate selected-atom and alphabet finiteness conditions. Internal
section headings make the independence proof engine navigable without
promoting or splitting private machinery.

All six approved builds passed: `Shannon.FiniteFamily` (2,232 jobs),
`Shannon.SemanticBridge.ConditionalKL` (2,748),
`Shannon.SemanticBridge.FiniteFamilyIndependence` (2,704), the semantic
aggregate (2,760), the examples aggregate (2,778), and the lightweight root
(2,240). Exported simp probes, the 18-name direct consumer, guarded root-
isolation checks, private-helper invisibility, and the strict placeholder scan
also passed. The complete diff, scratch, conflict-marker, whitespace, and
`git diff --check` hygiene checks passed; all disposable probes were deleted.
Relevant decisions were reconciled in Future Work Notes 14, 15, and 17. C8.21
remains not started.

**Post-step critical-review follow-up (July 31, 2026):** Tightened two comments
without changing Lean declarations or imports. The restriction theorem now
describes `[forall i, Finite (alpha i)]` accurately as pointwise finiteness of
the ambient family, rather than suggesting finiteness only for the selected
atom. The semantic aggregate now distinguishes the unconditional `ENNReal`
weighted-fiber and joint-chain formulas from their support-guarded real-valued
counterparts. Permanent tests whose success specifically depends on the three
new simp attributes remain assigned to the future internal regression layer in
Future Work Notes 15 and 17; no duplicate follow-up item was created. C8.21
remains not started.

### C8.21 - Focused Integration Validation

**Status:** `complete`

**Objective and reason:** Validate the frozen mathematical and API source
before canonical project-memory edits.

**Prerequisites:** C8.20 complete.

**Verified LeanInfoTheory declarations to reuse:** All Chunk 8 modules,
semantic and examples aggregates, root, finite-family certificate adapter, and
existing milestone-validation conventions.

**Verified mathlib APIs:** No new theorem; this step validates compiled use of
the existing mathlib dependencies.

**Proposed declarations:** None.

**Target files, namespaces, and imports:** No planned source edit unless a
validation defect is found. Do not update canonical or generated files.

**Proof or implementation strategy:** Run focused builds across all new
owners and important downstream consumers. Compile positive direct-import and
aggregate consumers. Compile guarded negative consumers confirming root
isolation and private-helper invisibility. Begin the all-new-public-theorem
axiom inventory. Run placeholder, scratch, conflict, whitespace, and diff
hygiene checks.

**Edge cases:** Post-review names and attributes; root reachability; aggregate
cycles; private declaration leakage; certificate/trust preservation.

**Focused validation commands:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence
lake build LeanInfoTheory.Shannon.SemanticBridge
lake build LeanInfoTheory.Certificate.FiniteFamily
lake build LeanInfoTheory.Examples.ConditionalKL
lake build LeanInfoTheory.Examples.FiniteFamily
lake build LeanInfoTheory.Examples
lake build LeanInfoTheory
git diff --check
```

Also run the strict placeholder scan and delete every disposable consumer.

**Definition of done:** All focused and downstream builds pass; positive and
negative boundary consumers behave as expected; the preliminary axiom audit
finds no unapproved axiom; only intended tracked files differ; and canonical
memory still honestly says independent final validation is pending.

**Downstream effect:** Authorizes C8.22 canonical-memory reconciliation.

**Documentation implications:** Update only the plan outcome. Do not yet claim
independent chunk validation.

**Risk level:** Low to medium.

**Fallback strategy:** Fix source, import, or validation defects and rerun
affected checks. A contract-changing fix requires approval and plan revision.

**Implementation outcome:** Completed July 31, 2026. One combined invocation
of all nine approved focused and downstream targets completed successfully with
2,783 jobs: `Shannon.FiniteFamily`,
`Shannon.SemanticBridge.ConditionalKL`,
`Shannon.SemanticBridge.FiniteFamilyIndependence`, the semantic aggregate,
`Certificate.FiniteFamily`, both new example owners, the examples aggregate,
and the lightweight root. `Examples.FiniteFamily` was the slow target at 310
seconds but remained responsive and completed without diagnostics.

A direct-import consumer elaborated all 18 new Chunk 8 public declarations,
the existing finite-family certificate adapter, and exported simp behavior for
conditional-KL self divergence and empty/singleton mutual independence. A
separate aggregate consumer reached representative conditional-CMI,
conditional-KL, mutual-independence, certificate, and examples imports through
their intended aggregates. Guarded negative diagnostics confirmed that the
lightweight root exposes none of the three new opt-in API families or
`CheckedCert.sound_finiteFamily`. After importing the two semantic owners,
four representative proof-engine names remained inaccessible:
`channelJoint_support_subset_iff_active`,
`weighted_klDiv_ne_top_of_active_support`, `familyProduct`, and
`isMutuallyIndependentFamily_pair_iff_isIndependent`.

The first root-boundary run found only a test-expectation wording mismatch:
Lean reports the absent certificate theorem as an unknown *constant* rather
than an unknown *identifier*. The guarded expectation was corrected and the
consumer then passed; no source, API, or import defect was involved.

An explicit preliminary `#print axioms` manifest covered all 15 new public
theorems. Every entry reported only the accepted foundations `propext`,
`Classical.choice`, and `Quot.sound`; no `sorryAx`, project axiom, or unapproved
dependency appeared. The strict Lean placeholder scan, conflict-marker scan,
scratch deletion, tracked-`tmp` and textbook checks, intended-file status
review, whitespace inspection, and `git diff --check` all passed. Every
disposable consumer was deleted.

No Lean source, import, canonical-memory document, generated reference, or
website file changed in C8.21. The canonical documents remain at their
pre-Chunk-8 account and do not claim independent Chunk 8 validation; C8.22 now
owns their factual reconciliation while preserving that final validation is
still pending. C8.22 has not started.

**Post-step verification follow-up (July 31, 2026):** A reread of Future Work
Note 17 identified one narrow gap in the original boundary evidence: the
direct consumer imported several downstream modules together and therefore did
not independently test the intermediate `Shannon.FiniteFamily` boundary. A
new disposable consumer importing only `LeanInfoTheory.Shannon.FiniteFamily`
elaborated all four binary/ordered law/source conditional-mutual-information
chain rules. Exact guarded diagnostics simultaneously confirmed that this
lightweight owner does not expose `finiteFamilyEntropyVal`, `conditionalKlDiv`,
`IsMutuallyIndependentFamily`, or `CheckedCert.sound_finiteFamily`. In this
minimal namespace context Lean reported the last missing name as an unknown
identifier; the disposable guard was adjusted to that exact diagnostic and
then passed.

A second disposable consumer importing the intended semantic and certificate
owners elaborated `finiteFamilyEntropyVal`, `finiteFamilyEntropyValOf`, and
`CheckedCert.sound_finiteFamily`. This completes the positive and negative
intermediate-boundary matrix preserved by Future Work Note 17. Both consumers
were deleted after passing.

The audit also found one stale module comment in
`Shannon.SemanticBridge.FiniteFamily`: it still described the mutual-
independence equality characterization as deferred even though C8.16 now owns
that result in the separate downstream
`Shannon.SemanticBridge.FiniteFamilyIndependence` module. The comment now points
to that module. No declaration, theorem statement, proof, attribute,
namespace, or import changed. Rebuilding the comment owner, the downstream
independence module, `Certificate.FiniteFamily`, and the semantic aggregate
completed successfully with 2,764 jobs. The broader maintained boundary/trust
harness remains deferred under Future Work Note 17; no duplicate future-work
item is justified. C8.21 remains complete, and C8.22 has not started.

### C8.22 - Canonical Project-Memory Reconciliation

**Status:** `complete`

**Objective and reason:** Reconcile collective canonical project memory with
the frozen implementation after focused integration, while stating explicitly
that independent final validation is pending.

**Prerequisites:** C8.21.

**Verified LeanInfoTheory declarations to reuse:** The final source
declaration inventory and validated module graph from C8.20--C8.21.

**Verified mathlib APIs:** None; this is a documentation and factual
reconciliation step.

**Proposed declarations:** None.

**Target files, namespaces, and imports:** Update this plan's outcomes,
`docs/lean-info-theory-living-summary.md`,
`docs/current-lean-state.md`, `docs/project-log.md`, `docs/roadmap.md`, and
relevant `README.md` status/module/build sections. Do not change `AGENTS.md`,
Lean source, generated references, or website files.

**Proof or implementation strategy:** Reconcile the Chapter 2 coverage matrix,
module architecture, current work, limitations, Future Work register, and
validation state against source, focused builds, the approved plan, and Git
history. State that Chunk 8 adds new Sections 2.5--2.6 results and no new
Section 2.8 theorem. Preserve distinctions among implemented, focused-
validated, independently validated, checkpointed, pushed, deployed, and
remotely validated.

**Edge cases:** Dirty working-tree status; generated references still
describing Chunk 7; no independent closeout yet; no checkpoint/push/deployment
claim.

**Focused validation commands:**

```powershell
git diff --check
git status --short
```

Verify every declaration name and module path mentioned in the edited
documents.

**Definition of done:** Canonical documents agree that implementation and
focused integration are complete while C8.24 independent validation remains
pending. They use only the approved eventual Sections 2.5--2.8 claim and do
not claim all Chapter 2 complete.

**Downstream effect:** Supplies authoritative factual metadata for generated
references and public documentation.

**Documentation implications:** This is the canonical-memory step. Preserve
all historical records and side-thread Future Work additions.

**Risk level:** Medium.

**Fallback strategy:** Narrow or correct factual wording. Policy changes,
history rewriting, or a broader completion claim requires approval.

**Implementation outcome:** Completed July 31, 2026. Captured a read-only
pre-edit status, hash, and scoped-diff snapshot for the six assigned documents,
then reconciled `docs/lean-info-theory-living-summary.md`,
`docs/current-lean-state.md`, `docs/project-log.md`, `docs/roadmap.md`, and the
relevant README status, module, import, roadmap, and build sections. This plan
records the completed step. No Lean source, `AGENTS.md`, generated reference,
or website file changed in C8.22.

The canonical account now records the frozen 18-declaration surface: four
lightweight conditional-family CMI chain rules, six common-base conditional-KL
declarations, and eight finite-family mutual-independence declarations. It
records the two new semantic owners, the new private conditional-KL example
owner, the extended finite-family examples, semantic/examples aggregate
exposure, unchanged lightweight root, and unchanged certificate API and trust
boundary. The Chapter 2 matrix now assigns the new work to Sections 2.5--2.6,
states explicitly that Chunk 8 adds no Section 2.8 theorem, and reserves only
the limited eventual claim that the finite algebraic gaps in Sections
2.5--2.8 are closed rather than claiming all Chapter 2 complete.

Current status is intentionally split: the source is implemented, API-frozen,
and focused-validated through C8.21; canonical reconciliation is complete in
C8.22; the tracked generated references still report the independently
validated Chunk 7 checkpoint; C8.23 owns their regeneration and public-
documentation pass; and C8.24 owns independent final validation and the only
permitted working-tree completion claim. No checkpoint, commit, push,
deployment, remote validation, or independent Chunk 8 validation is claimed.

Future Work Note 17 now records the completed C8.21 focused build, preliminary
axiom manifest, and exact core/semantic/certificate boundary matrix while
retaining the broader reusable validation driver and maintained boundary/trust
harness as future infrastructure. Existing Notes 9, 14--18, and 24 remain in
force; no duplicate numbered item was created.

The source-backed audit verified all 18 declaration names, all six cited owner
and plan paths, and the current 51-file Lean module count. It also confirmed
that the tracked generated counts remain deliberately stale until C8.23.
`git diff --check` and the scoped status review passed. No Lake build was
repeated for this documentation-only reconciliation because C8.21 supplied the
current focused build evidence and C8.24 deliberately owns independent final
validation. C8.23 has not started.

**Post-step double-check follow-up (July 31, 2026):** A full reread of the
relevant Future Work additions found two documentation omissions and no source,
API, architecture, validation, or status defect. The living summary now states
explicitly that, for finite discrete laws, pointwise mass factorization is the
mass-function form of the textbook finite-intersection/event-factorization
definition of mutual independence, without adding a measurable-independence
API. Future Work Note 18 now records that Chunk 8 completed the previously
deferred conditional-family CMI and n-way independence work in its separately
approved lightweight/downstream owners while preserving the root and
certificate boundaries. Existing Notes 9, 14--17, and 24 already contain the
remaining documentation, naming, simp, validation-harness, and strict-Jensen
follow-ups in sufficient detail; no new note or duplicate task was added.
C8.23 remains not started.

**Post-step critical-review follow-up (July 31, 2026):** A later adversarial
review found one additional stale limitation in the living summary: it still
listed the n-way entropy-equality/independence case and binary or ordered
conditional-family CMI chain rules as open even though C8.03--C8.04 and
C8.13--C8.16 completed them. That entry now records the genuinely deferred
global indexed-family or measurable-independence bridges and broader
pairwise-versus-mutual theory instead. The stable-conventions section now also
records the two durable Chunk 8 contracts: finite-family mutual independence
is selected-atom pointwise factorization rather than pairwise or global
independence, and `conditionalKlDiv` compares two channel joints over one
common base with canonical `ENNReal` and explicitly guarded Real forms. No new
Future Work item was created because these were immediate canonical-memory
corrections; existing Notes 9 and 17 continue to own structured-status and
validation-harness improvements. No Lean source, generated reference, website,
or unrelated canonical document changed, and C8.23 remains not started.

### C8.23 - Generated References And Public-Documentation Consistency

**Status:** `complete`

**Objective and reason:** Regenerate source-derived references and align public
documentation with the frozen Chunk 8 source and pending-final-validation
state, without redesigning the website.

**Prerequisites:** C8.22.

**Verified LeanInfoTheory declarations to reuse:** Final source imports,
module comments, and public declaration inventory.

**Verified mathlib APIs:** None; this is generated/public documentation work.

**Proposed declarations:** None.

**Target files, namespaces, and imports:** Update generator metadata only as
needed for the three owners and `Examples.ConditionalKL`; regenerate the
dependency graph and declaration index; update relevant existing public status
or module-guide pages. Do not redesign layout or add unrelated website work.

**Proof or implementation strategy:** Add accurate module summaries, run both
generators, inspect module edges and declaration anchors, verify direct-import
guidance, run the website checker, and rerun generation to establish
idempotence. Public wording must distinguish local working-tree output from
checkpointed and deployed state.

**Edge cases:** Tentative names finalized by C8.20; private helper leakage;
duplicate anchors; fallback module summaries; stale counts; broken source
links; website still reflecting a prior deployed commit.

**Focused validation commands:**

```powershell
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/check_website.py
git diff --check
```

Run both generators a second time and confirm byte-identical output.

**Definition of done:** Generated module/declaration references match source;
website checks pass; public status is factual and does not overclaim final
validation, commit, push, deployment, or remote validation; no website
redesign occurred.

**Downstream effect:** Leaves only independent final validation and closeout.

**Documentation implications:** This step owns generated references and public
website consistency. Full doc-gen and shared-status tooling remain deferred
under Note 9.

**Risk level:** Low to medium.

**Fallback strategy:** Correct generator metadata or public wording and rerun
the checks. Generator architecture or website redesign requires separate
approval.

**Implementation outcome:** Completed July 31, 2026. Added source-verified
generator summaries for the three changed mathematical owners,
`Examples.ConditionalKL`, and the directly affected semantic/example
aggregates and `Examples.FiniteFamily` row. Regenerated the module graph and
declaration index, then reconciled the existing homepage, roadmap, module
guide, development import guide, and blueprint overview with the local Chunk 8
working-tree state. The public wording states that implementation, focused
integration, canonical memory, and locally generated references are complete
through C8.23 while C8.24 independent validation, checkpointing, pushing,
deployment, and remote validation remain pending. No layout, style, Lean
source, canonical project-memory document, or curated theorem-highlight entry
changed.

The first declaration-index pass exposed one narrow parser discrepancy: the
three new `[simp]` theorems whose attribute and theorem keyword share one line
were absent, leaving only 15 of the frozen 18 Chunk 8 declarations indexed.
Exactly those three source lines use that syntax. The declaration regex now
accepts leading inline attribute blocks; no Lean declaration was reformatted
to accommodate the generator. Regeneration then produced 51 modules, 100
local import edges, 11 root-reachable and 40 separately imported modules, and
880 reviewed source declarations, all with doc comments. All 18 Chunk 8
declarations are present exactly once; the three new modules remain opt-in;
the conditional-KL example module contributes no public declaration; the four
audited private proof-engine names remain absent; and no duplicate module,
declaration, anchor, invalid source path/line, or generic module-summary
fallback remains.

Both generators produced byte-identical output on the second pass. The
website checker passed over 12 HTML and two generated JSON files, and targeted
semantic JSON/HTML assertions passed for count self-consistency, graph edges,
root isolation, aggregate imports, source locations, unique anchors, and
private-helper exclusion. A local rendered smoke check at 1440-by-900 and
390-by-844 viewports found no document-level horizontal overflow or browser
console errors on the homepage, roadmap, or module guide. Final conflict,
scratch, whitespace, stale-status, and `git diff --check` checks passed. No
Lake build was repeated because this step changed no Lean source and C8.24
owns independent build validation. C8.24 has not started.

### C8.24 - Independent Final Validation And Working-Tree Closeout

**Status:** `complete`

**Objective and reason:** Independently validate the complete final working
tree against every mathematical, API, architecture, trust, documentation, and
hygiene criterion, then close Chunk 8 without claiming unperformed Git or
deployment operations.

**Prerequisites:** C8.23 and all previous steps complete.

**Verified LeanInfoTheory declarations to reuse:** The complete final
declaration inventory, maintained examples, semantic aggregate, root,
certificate modules, and canonical documents.

**Verified mathlib APIs:** No new theorem; this step audits the axioms and
compiled dependency use of all new public theorems.

**Proposed declarations:** None.

**Target files, namespaces, and imports:** Validate the complete repository.
After successful validation, update only factual closeout status in the plan
and canonical/public documents, then rerun affected checks. Do not commit,
push, deploy, or claim remote validation without separate authorization.

**Proof or implementation strategy:** Run:

1. the maintained milestone build suite;
2. focused builds for all new owners;
3. direct-import and semantic/examples aggregate consumers;
4. guarded negative root/private-helper consumers;
5. `#print axioms` for every new public theorem;
6. the strict forbidden-placeholder scan;
7. generated-reference idempotence and website validation;
8. public declaration/path/count checks;
9. scratch, ignored, untracked, conflict-marker, whitespace, and diff hygiene.

Assess whether Future Work Note 17's maintained boundary/trust harness trigger
has been reached. This step may recommend a concrete follow-up but must not
implement a harness without a separate explanation and explicit approval.

**Edge cases:** Stale Lake cache; expected guarded negative failures; private
declaration leakage; generated drift; final closeout edits occurring after
initial checks; working-tree versus checkpoint/deployment language.

**Focused validation commands:**

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

lake build LeanInfoTheory.Shannon.FiniteFamily
lake build LeanInfoTheory.Shannon.SemanticBridge.ConditionalKL
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamilyIndependence

python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/check_website.py
git diff --check
git status --short
```

Also run the strict placeholder scan, all-new-public-theorem axiom manifest,
boundary consumers, idempotence comparison, and repository hygiene checks.

**Definition of done:** Every approved mathematical theorem and edge case is
covered; all builds, consumers, trust audits, generators, website checks, and
hygiene checks pass; no placeholder or unapproved axiom appears; canonical and
public status agree with source; and the only closeout wording is:

> Chunk 8 is complete and independently validated in the working tree.

The repository must not describe the work as checkpointed, committed, pushed,
deployed, or remotely validated without separate authorization and evidence.

**Downstream effect:** Completes the approved Chunk 8 plan. It does not
authorize a commit, handoff, later chunk, or deferred mathematical phase.

**Documentation implications:** Record exact validation evidence and the
approved completion claim. Re-run relevant documentation and website checks
after factual closeout edits.

**Risk level:** Medium.

**Fallback strategy:** Repair defects and rerun every affected validation
stage. Do not mark the chunk complete while any gate, theorem, build, trust,
documentation, or hygiene criterion remains unresolved. A contract change
requires approval and plan revision.

**Implementation outcome:** Completed July 31, 2026. Independent validation
passed for the complete accumulated Chunk 8 working tree. The nine-target
Chunk 8 owner/downstream build completed successfully with 2,783 jobs. The
maintained ten-target milestone suite then completed with 2,792 jobs, and the
default project build completed with 2,240 jobs. The validation used the
existing incremental Lake cache rather than a cold release build; the two
slow focused nodes remained responsive and completed without diagnostics.

Disposable direct-import consumers exercised all 18 new public declarations
through their owning modules. Aggregate consumers reached representative
conditional-CMI, conditional-KL, mutual-independence, concrete entropy-
valuation, certificate-adapter, and example paths. Exact environment checks
confirmed that the lightweight root and the intermediate
`Shannon.FiniteFamily` owner do not expose the downstream semantic or
certificate APIs. The four reviewed private proof-engine names remained
inaccessible. Every disposable source was deleted after passing.

An explicit `#print axioms` manifest covered all 15 new public theorems. Every
entry reported only `propext`, `Classical.choice`, and `Quot.sound`; no
`sorryAx`, project axiom, or unapproved dependency appeared. The strict Lean
placeholder scan returned no match. The maintained examples and direct
consumers preserve the approved null/active fiber, finite/infinite KL,
support/`toReal`, overlap, duplicate, initially conditioned, dependent-
alphabet, product-family, restriction, and pairwise-versus-mutual edge-case
coverage.

Both source-derived generators were rerun twice and produced byte-identical
second-pass output. The generated graph records 51 modules, 100 local import
edges, 11 root-reachable modules, and 40 opt-in modules. The declaration index
records 880 unique documented source declarations; its delta from the Chunk 7
checkpoint is exactly the three approved modules and 18 approved declarations,
with no removal, duplicate anchor, invalid source path/line, fallback summary,
or private-helper leak. The website checker passed for 12 HTML files and two
generated JSON files.

The expected 25-entry working-tree inventory, conflict-marker, tracked-`tmp`,
textbook, disposable-source, whitespace, and `git diff --check` audits passed.
Ignored textbooks, historical handoffs and external audits, older QA browser
profiles, and editor `lake serve` processes predate this step and were left
untouched. Future Work Note 17's reusable validation-driver and maintained
boundary/trust-harness trigger was already active before this closeout; the
independent C8 matrix adds evidence to that existing task but does not justify
building the infrastructure inside C8.24.

Chunk 8 is complete and independently validated in the working tree. It is
not checkpointed, committed, pushed, deployed, or remotely validated, and
this closeout authorizes none of those operations or any later mathematical
phase.

## Integration Checkpoints

1. **After C8.01:** The actual CKB weighted and distinct-base chain contracts,
   including active/inactive top behavior, are proof-complete.
2. **After C8.02:** The full dependent-alphabet entropy-additivity iff
   pointwise-factorization contract and its hidden restriction/insert/pair
   machinery are proof-complete.
3. **After C8.05:** Exactly four lightweight conditional-family CMI rules
   compile and the lightweight/root/certificate boundaries pass.
4. **After C8.11:** The complete canonical and guarded Real conditional-KL API
   passes its independent workstream checkpoint.
5. **After C8.17:** The mutual-independence API passes independently; both new
   semantic modules are direct-importable and aggregate-visible but
   root-hidden.
6. **After C8.20:** Names, assumptions, simp attributes, helpers, imports, and
   public visibility are reviewed and frozen using maintained consumers.
7. **After C8.21:** Frozen source passes focused integration, boundary, trust,
   placeholder, and hygiene checks.
8. **After C8.24:** Source, builds, examples, trust audits, canonical memory,
   generated references, public documentation, and repository hygiene agree.

Neither a feasibility gate nor an integration checkpoint authorizes beginning
the next step. Explicit approval is required for every later step.

## Chunk-Completion Criteria

Chunk 8 is complete only when:

- both proof-complete feasibility gates pass their exact contracts;
- either gate failure has stopped the sequence until explicitly resolved;
- `conditionalKlDiv` uses the common-base joint-KL representation and the
  weakest natural definition assumptions;
- self-divergence compiles without speculative support or finite assumptions;
- the canonical weighted theorem is unconditional and uses
  `[Fintype alpha] [Finite beta]` plus the required measurable instances;
- active support failure makes both sides of the weighted formula `top`;
- inactive fiber KL `top` contributes exactly `0 * top = 0`;
- the joint chain rule is unconditional, finite, and uses numerator base `p`;
- Real weighted and chain forms use exactly the approved PMF-facing support
  guards;
- no public direct-ne-top family is introduced;
- exactly four initial conditional-family CMI chain rules exist;
- ordered CMI permits duplicate names and overlapping atoms without `Nodup`;
- law/source mutual-independence predicates use pointwise finite-family
  factorization;
- no `[Fintype Var]` or homogeneous-alphabet restriction is introduced;
- law-facing empty, singleton, and subset theorems compile;
- no automatic source forwarding for those elementary laws is added;
- exactly one public source-facing distinct-index pair compatibility theorem
  exists, with law-facing compatibility maintained privately;
- law/source entropy-additivity iff mutual-independence theorems compile for
  arbitrary finite atoms and dependent alphabets;
- no public `iIndepFun`, product-measure, or dependent-product-PMF API appears;
- support extensionality is absent unless maintained consumers justify and the
  project lead approves a clean two-sided theorem;
- simp attributes are adopted only after C8.20 critical-pair review;
- the two semantic modules remain directly importable, join only the opt-in
  semantic aggregate, and remain outside the root;
- certificate semantics, primitive inequalities, validation, and trust
  boundaries remain unchanged;
- maintained examples cover every required KL, CMI, and independence edge
  case without public test-only helpers;
- canonical memory explicitly records that Chunk 8 adds no Section 2.8
  theorem;
- generated references and public documentation match the final source;
- every focused, milestone, direct-import, aggregate, root-isolation, private-
  helper, axiom, placeholder, generator, website, and hygiene check passes;
- the final status distinguishes working-tree validation from commit, push,
  deployment, and remote validation;
- the project claims only that the finite algebraic gaps in Cover--Thomas
  Sections 2.5--2.8 are closed, not that all Chapter 2 is complete.

## Explicitly Deferred Work

- Countable-alphabet conditional-KL chain rules or forwarding theorems.
- Two-base and joint-law conditional-relative-entropy objects.
- Conditional-KL equality, topology, continuity, lower semicontinuity, and
  variational forms.
- Public support extensionality without demonstrated consumer value.
- Public direct-ne-top theorem families.
- Public `iIndepFun`, product-measure, or dependent product-PMF APIs.
- Source forwarding for empty, singleton, and subset independence.
- A second public pair compatibility theorem.
- Pairwise-versus-mutual independence comparison theory and counterexample
  libraries beyond maintained private tests.
- Conditional-family CMI symmetry, permutation, reverse orientation, or
  `Nodup` forwarding.
- A Markov/CMI forwarding theorem specific to Section 2.8.
- Tensorization, Pinsker, AEP, typicality, coding, capacity, process entropy,
  matrix/majorization, and minimal-sufficiency work.
- Changes to `ShannonEntropyVal`, `EntropyExpr`, primitive inequalities,
  checked certificates, raw validation, or the trust boundary.
- A reusable validation driver or maintained boundary/trust harness without a
  separately approved maintenance phase.
- Full Lean doc-gen, theorem-level blueprinting, shared-status generation, and
  website redesign.

## Proposed Future-Work Candidates

Create or refine a Future Work entry only when implementation or maintained
consumer evidence meets its pressure trigger:

- **Future Work Note 9:** Keep full doc-gen, theorem-level blueprinting,
  structured shared status, and broader validation tooling deferred. Chunk 8
  generated-reference work does not authorize those projects.
- **Note 14:** Record any unusually long, ambiguous, or representation-
  exposing conditional-KL, pair-compatibility, or entropy-iff name with its
  discoverability issue and a provisional compatibility alias pattern when
  useful. Do not rename declarations during active theorem steps.
- **Note 15:** Record only simp decisions supported by representative
  self-divergence, empty/singleton independence, proof-irrelevance, top, and
  critical-pair tests.
- **Note 16:** Keep all family chain rules explicit. Reopen automatic
  orientation only after a production consumer demonstrates a strictly
  reducing normal form.
- **Note 17:** Preserve focused iteration versus full milestone validation,
  root/private-helper consumers, and the later reusable validation-driver
  pressure. C8.24 may assess and recommend a boundary/trust harness but cannot
  implement one without separate approval.
- **Note 18:** Record that Chunk 8 changes no certificate semantic assumption,
  primitive inequality, validation path, or trust boundary.
- **Note 24:** Preserve strict-Jensen helper pressure unchanged; Chunk 8's new
  independence proof is not automatically another Jensen consumer.
- **Note 36:** If conditional-KL proofs repeat type-generic bind-support
  transport, compare that pressure with the existing one-consumer private
  helper before proposing public promotion. Do not promote it merely because
  Chunk 8 uses channel joints.
- **Note 38:** Keep matrix-facing stochastic bridges deferred; no Chunk 8
  theorem introduces a matrix representation.
- **Note 39:** Keep canonical/minimal sufficiency and iid statistic
  constructions deferred.
- Consider a countable-alphabet chain rule only after at least one nonfinite
  consumer appears and the finite primary theorem has stabilized.
- Consider public conditional-KL support extensionality only if at least one
  maintained example or later production proof materially improves with a
  two-sided support-aware theorem.
- Consider source forwarding for elementary mutual-independence laws only if
  multiple source-family consumers repeatedly unfold the predicate.
- Consider a public law-facing pair bridge only if the private maintained
  consumer becomes repeated production pressure.
- Consider a public finite-family/product-measure or `iIndepFun` bridge only
  after multiple downstream probability developments need that semantic view.
- Consider a broader pairwise-versus-mutual independence phase before
  tensorization or coding work only when those later consumers need it.

Do not create a new numbered note solely because a candidate appears here.
Update an existing owner where one exists and add a new note only for
demonstrated, otherwise unowned pressure.

## Known Risks

- The weighted conditional-KL proof may require lengthy support/top case
  analysis and delicate finite double-sum rearrangement.
- Equality of `toReal` values cannot distinguish finite `ENNReal` values from
  `top`; omitting the separate top branch would make C8.07 unsound.
- `0 * top` must be normalized before applying generic non-top or coercion
  lemmas.
- A support failure in one active fiber must be transported to the joint law
  with the correct pair-support witness.
- `channelJoint_toMeasure` may require explicit finite-to-countable and
  measurable-singleton instance management.
- Transitive imports through `DataProcessing` are heavy; duplicating or moving
  the kernel bridge to avoid them would violate the approved architecture.
- Dependent-family subset restriction may require substantial finite
  sum/product bookkeeping over removed coordinates.
- Reconstructing insert factorization from a pair-independent block and
  factorized tail can expose dependent equivalences and proof witnesses.
- The entropy equality converse must separate two nonnegative deficits without
  assuming an ordering of the public atom.
- Pairwise independence must not be mistaken for mutual independence.
- The source-facing pair theorem may acquire an awkward long name or expose
  coordinate orientation.
- Automatic source forwarding, aliases, support extensionality, or simp rules
  can create an unnecessarily broad first API.
- Adding the two semantic modules to the aggregate can reveal an import cycle
  if either module imports the aggregate rather than direct children.
- A long 24-step working tree can cause canonical, generated, checkpointed,
  and deployed status to drift unless C8.22--C8.24 preserve those distinctions.

## Plan-Revision Policy

- Implementation discoveries may justify changing later steps.
- Every proposed change must be explained to the project lead before this plan
  is edited.
- Completed implementation history must not be rewritten misleadingly.
- Cancelled or superseded steps remain recorded under their original stable ID
  with a factual reason and replacement reference.
- Completed, cancelled, or superseded IDs are never replaced, recycled, or
  silently assigned to different work.
- A material theorem, representation, assumption, module, trust,
  naming-policy, or scope change requires explicit approval.
- Internal proof-strategy changes may be recorded in a step outcome when they
  preserve the approved public statement, assumptions, architecture, and trust
  boundary.
- Failure of C8.01 or C8.02 makes that step incomplete and stops the entire
  execution sequence. No independent workstream may continue until explicit
  approval of resumption or a plan revision.
- Neither a completed step nor an integration checkpoint authorizes the next
  step.
- No later step begins without the project lead's explicit approval.
- If a discovery invalidates the dependency graph, finite/dependent-family
  representation, support/top policy, three-module architecture, certificate
  trust boundary, or approved completion claim, stop implementation and return
  for review.
