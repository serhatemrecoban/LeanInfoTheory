# Chunk 16: Finite products and iid block laws

<!-- lit-review-status:start -->
**Status:** Approved revision 2; C16.01--C16.04 and their reviews are complete
by their private records. Step 4's 248 source entries matched before C16.05
admission on 2026-10-13. The lead authorized the exact 24-file local checkpoint,
necessary C16.05-only amendments and inspected-checkout reuse on 2026-10-14.
Initial checkpoint `d9a3f32d396cbad91c10c7778b00d0cae50361e3` passed the complete
maintained clean routine suite; the runner recorded 3293.619 seconds.
The separate actual two-pass current API-doc gate and three-owner inspection
passed on their recorded primary inputs; the initial failure and bounded cache
recovery remain retained. The [handoff](../handoffs/chunk-16.md) records the
authorization, exclusions, source differences and evidence limits. Every
amended candidate requires complete clean routine revalidation and exact API-doc
applicability. Readiness, fresh all-15-criterion review, original-report
reconciliation and final-source qualification remain required. Only
`.lit-review/setup/c16-05-completion-20261014.json`, when present, establishes closure.
Normative requirements are unchanged; revision 1's PLAN review remains historical,
not formal revision-2 review. Earlier malformed intake and consumed skips remain
preserved. No push, publication or later chunk is authorized. C15 is complete at
`0af7edcddc99fb01b2ec0658c0e800898b66632a` by its private record.
<!-- lit-review-status:end -->

## 1. Scope and authority

This plan refines [C16 in the chunk map](post-release-chunk-map.md#c16-finite-products-and-iid-block-laws).
Construct a normalized law from a finite dependent family of finite-alphabet
PMFs, then expose coordinate, restriction, reordering, splitting and block
interfaces. Homogeneous outcomes are `Fin n → A`. Iid laws specialize the
same constructor. Existing finite-family and independence meanings remain
authoritative; this chunk introduces neither a new probability representation
nor an independence predicate.

Excluded: product channels and their composition (C17), entropy/KL additivity
and block information inequalities (C18), self-information/variance/measure
independence infrastructure and AEP (C19), capacity, coding, infinite products,
and arbitrary infinite component alphabets. No Lean/mathlib pin change or
lightweight-root expansion is proposed. Semantic consumers exercise existing
family and independence laws; new product entropy identities remain C18 work.

The lead must approve the exact plan before production implementation. An
explicit formal plan-review request is separate from bootstrap. After approval,
execute only one explicitly requested step with its review process, then stop.
This proposal grants no commit, checkpoint, push, publication, later-step or
later-chunk authority. Clean-checkpoint and validation-checkout authority must
be obtained separately when concrete final changes are ready for inspection.

## 2. Verified baseline and references

Work only in `C:\Users\coban\Desktop\Lean Info Theory`. HEAD is the C15
checkpoint above. Intake found only the four expected modified tracked paths:
`.gitignore`, `AGENTS.md`, `docs/project-log.md`, and
`docs/next-website-tasks.md`. Preserve those pending changes; the website-task
file remains untouched. Planning adds this plan, its separate
[notes](post-release-chunk-16-notes.md), and ignored private evidence. It does
not update public implementation inventories or claim canonical completion.

The actual predecessor record is
`.lit-review/setup/c15-05-completion-20261013.json`, with status
`SUPERVISED_STEP_COMPLETE`, all five steps complete and all 17 recorded
criteria satisfied. Its closure is
`0ee38dfdf34e8328283d82654a4f5ab7b5263e0a3bfec1297fa6f06f46a73358`.
All 232 real paths in its final source capture match current working bytes.
The current implementation supplies finite-PMF topology/compactness,
coordinate/TV convergence, fixed-map/channel and information continuity, and
the private actual maximizing-input theorem in `Examples.ChannelOptimization`.
The [C15 handoff](../handoffs/chunk-15.md) is useful evidence, not a reason to
reopen its completed work. The older leading headings of
`current-lean-state.md`, the living summary and the roadmap contain captured
chronology; current source and the completion record resolve that chronology.

Lean is `v4.33.1`; mathlib is
`0df444a360eaa60ab8c11dca51a86af692955474`. All nine installed dependencies
match their configured revisions and were clean at intake. Current inventory
is 669 supported declarations in 39 owners, 94 reviewed simp declarations and
92 root exports. These are baseline observations, not growth quotas. No
existing validation checkout is assumed available or authorized for C16.
Any later authorized checkout belongs under this repository's ignored
`.worktrees/`; do not create Desktop directories.

### 2.1 Mathematical and source anchors

- **PW24**, registered August 16, 2024 draft, SHA-256
  `c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`:
  Section 6.1, Theorem 6.1 and proof, printed pages 106–107 / PDF 131–132;
  Section 11.2, Proposition 11.6 and proof, printed pages 217–218 / PDF 242–243.
  These supply product notation and downstream motivation. C16's finite
  PMF construction/transport proofs derive from normalization and existing
  PMF algebra; they do not establish those sections' information or AEP results.
  The planning reference inspection read and visually checked all four pages.
- `Shannon.FiniteFamily`: `FamilyOutcome`, `familyLawOf`, `familyMarginal`,
  `familyMarginal_restrict`, and existing pair/family coordinate equivalences.
- `Shannon.SemanticBridge.FiniteFamilyIndependence`: type-generic existing
  predicates, private `familyProduct`, restriction and entropy-equality APIs.
  Its private normalized-product proof is a reuse anchor, not an additional
  public representation to preserve.
- `Shannon.SemanticBridge.Product`: released `indepProd`, atom/support,
  marginal and measure interfaces. `Probability.FiniteChannel` already gives
  the definitionally identical low-level `channelJoint p (fun _ => q)`.
- Pinned mathlib: `PMF.ofFintype`, `Fintype.prod_sum`, `PMF.tsum_coe`,
  finite-product zero/nonzero lemmas, `Equiv.piCongrLeft`,
  `Equiv.piEquivPiSubtypeProd`, `Equiv.piSplitAt`,
  `Equiv.sumPiEquivProdPi`, `Equiv.ofInjective`, `Fin.appendEquiv`,
  and `Fin.prod_univ_add`. The notes record precise owners and probe results.

Consult [references](../references.md), the living-summary Quick Start and
relevant architecture/Future Work Notes, and both
[review protocol](../review-protocol.md) and [operations](../review-operations.md).
Do not consult other information-theory formalization repositories without
separate authorization. Preserve local reference PDFs outside source capture.

## 3. Mathematical contracts

The names below are proposed public vocabulary. Equations and hypotheses are
the intended contracts; no declaration is claimed to exist yet. Resolve naming
collisions before approval. Once approved, changing a public contract or its
assumptions requires a lead decision; private proof routes remain advisory.
The Lean headers use universe variables `u v w` and omit proof bodies. They
fix explicit/implicit arguments and instances for the delicate interfaces.

### 3.1 General constructor, atoms and support

Propose the following in namespace `PMF`:

```lean
noncomputable def finiteProduct
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) : PMF ((i : I) → A i)
```

For `P = PMF.finiteProduct p`, require:

1. `finiteProduct_apply`: `P x = ∏ i, p i (x i)` in `ENNReal`, with total
   mass one proved by the constructor. Reuse `PMF.ofFintype`; do not add a
   second normalized-mass structure or a redundant normalization theorem.
2. `mem_support_finiteProduct_iff`: `x ∈ P.support ↔ ∀ i, x i ∈ (p i).support`.
   A product atom is zero exactly when some coordinate atom is zero. The
   latter is a required derived consumer fact, not a second public alias.
3. `finiteProduct_map_eval`: `P.map (fun x => x i) = p i` for each `i : I`.
   This is an equality of laws, not merely equality of their supports.
4. `finiteProduct_of_isEmpty`: under `[IsEmpty I]`, `P` is pure at the unique
   dependent empty function `fun i => isEmptyElim i`.
5. `finiteProduct_pure`: the product of `fun i => PMF.pure (a i)` equals
   `PMF.pure a`. This is used for deterministic blocks and zero/one-symbol
   source consumers.

The coordinate-marginal header is:

```lean
theorem finiteProduct_map_eval
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (i : I) :
    (finiteProduct p).map (fun x => x i) = p i
```

C16.01 may develop the minimal **private** coordinate/complement splitting
lemma needed for this marginal, directly from `Equiv.piSplitAt` and finite
product algebra. A direct marginal proof is equally acceptable. This local
proof infrastructure does not depend on a C16.02 public theorem: general
restriction, reindexing, sum splitting and pair projection remain C16.02
endpoints. Reuse the private machinery in that later step when useful.

Keep index universe `u` independent of alphabet universe `v`. One dependent
family has a common fiber universe; C16 does not invent mixed-universe casts.
Use different alphabets in that universe and universe-polymorphic tests.
Index transport may use a third universe. No `DecidableEq`, `Nonempty I`,
component `Nonempty`, full-support, positivity, or positive-cardinality premise
is added to these public contracts. Use `classical` internally when needed.
`Fintype` is deliberate here because the finite atom product and its finite
normalization are the public interface. A `Finite`-only overload is not selected.
For `s : Finset Var` with arbitrary ambient `Var`, instantiate `I := s`;
only the selected components need finite alphabets for this construction.
No `Fintype Var` or law on the entire ambient family is required to construct
that selected product. Mapping a finite full product to a selected family is
the separate bridge contract below.

Singleton products are identified with their sole component by evaluation and
the existing dependent-function equivalence. Prove both directions in a
retained consumer; do not add a one-use singleton equivalence wrapper.
The generic empty product exists even when the ambient proposed alphabet is
empty. If an index is actually present and its alphabet is empty, a component
PMF cannot be supplied. Do not manufacture a fallback component law.
PMF atoms are never top; zero masses remain allowed in all formulas.

### 3.2 Coordinate restriction and reindexing

Require the following forward restriction law in namespace `PMF`:

```lean
theorem finiteProduct_map_restrict
    {I : Type u} {J : Type w} {A : I → Type v}
    [Fintype I] [Fintype J] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (e : J ↪ I) :
    (finiteProduct p).map (fun x j => x (e j)) =
      finiteProduct (fun j => p (e j))
```

The target alphabet is exactly `fun j => A (e j)`. Subtype/finset restriction
and deletion of coordinates are applications of this theorem. A consumer
must compose two restrictions and compare with the direct embedding using
`PMF.map_comp`; no new public composition helper is selected.

For an equivalence `e : J ≃ I`, use the same precomposition equation:

```lean
theorem finiteProduct_map_reindex
    {I : Type u} {J : Type w} {A : I → Type v}
    [Fintype I] [Fintype J] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (e : J ≃ I) :
    (finiteProduct p).map (Equiv.piCongrLeft A e).symm =
      finiteProduct (fun j => p (e j))
```

Its map is definitionally `fun x j => x (e j)`.
The inverse equation follows by mapping along `Equiv.piCongrLeft A e`;
test the round trip rather than exposing a symmetric alias. This orientation
keeps dependent casts out of consumer statements. The explicit equivalence
form is justified by heterogeneous reordering and block permutations.

Injectivity is essential. An arbitrary map `J → I` may repeat a coordinate;
its pushforward is a valid law but generally is not the product of the repeated
coordinate laws. Retain the exact fair-Boolean diagonal/off-diagonal
counterexample. Coordinatewise functions on alphabet values, general bind
factorization, and product-channel processing are deferred to C17 if needed.

### 3.3 Splitting and coordinate pairs

For independent index universes, require:

```lean
theorem finiteProduct_map_sum
    {I : Type u} {J : Type w} {A : I ⊕ J → Type v}
    [Fintype I] [Fintype J] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) :
    (finiteProduct p).map (Equiv.sumPiEquivProdPi A) =
      channelJoint
        (finiteProduct (fun i => p (Sum.inl i)))
        (fun _ => finiteProduct (fun j => p (Sum.inr j)))
```

The first output block is the `inl` block; the second is the `inr` block.
The inverse equivalence concatenates them, with exact mapped-law equality
derived and exercised in a consumer. No new binary-product constructor is
introduced. Finset partition proofs may use private complement/subtype
equivalences; callers need not unfold that machinery.

For distinct coordinates, require:

```lean
theorem finiteProduct_map_pair
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) {i j : I} (hij : i ≠ j) :
    (finiteProduct p).map (fun x => (x i, x j)) =
      channelJoint (p i) (fun _ => p j)
```

This concrete two-coordinate law is the lightweight C19 independence input.
It must be available without project Shannon, information/KL, finite-topology
or C18 owners. This restriction does not deny PMF's existing upstream dependencies.
It is valid for zero masses, heterogeneous alphabets, and either ordered pair
of distinct indices. No independence theorem is asserted for coincident
indices; pure repeated-coordinate cases do not justify dropping distinctness.

### 3.4 Homogeneous blocks and iid specialization

The general non-iid block law is `finiteProduct p` for
`p : Fin n → PMF A`; do not wrap it in a second block-law structure.
The thin specialization in namespace `PMF` is:

```lean
noncomputable def iid {A : Type v} [Fintype A] (p : PMF A) (n : ℕ) :
    PMF (Fin n → A) := finiteProduct (fun _ : Fin n => p)
```

Atom, support and coordinate consumers must obtain their
results from Section 3.1 by unfolding this thin definition, not reproving them.

Expose two block transport forms in the focused block owner. The split
lengths are explicit because the source length `m+n` does not determine them;
concatenation lengths are inferred from the two component families.

```lean
theorem finiteProduct_map_append_symm
    {A : Type v} [Fintype A] (m n : ℕ) (p : Fin (m + n) → PMF A) :
    (finiteProduct p).map (Fin.appendEquiv m n).symm =
      channelJoint
        (finiteProduct (fun i => p (Fin.castAdd n i)))
        (fun _ => finiteProduct (fun j => p (Fin.natAdd m j)))

theorem channelJoint_finiteProduct_map_append
    {A : Type v} [Fintype A] {m n : ℕ}
    (p : Fin m → PMF A) (q : Fin n → PMF A) :
    (channelJoint (finiteProduct p) (fun _ => finiteProduct q)).map
        (Fin.appendEquiv m n) = finiteProduct (Fin.append p q)
```

The concatenation result handles different coordinate laws, so it does not
silently impose iid. Reuse the sum/reindex contracts and upstream `Fin.append`;
do not introduce a project block datatype, split operation or reassociation API.
Iid splitting and concatenation specialize these same theorems. The small
public `iid_map_perm` convenience theorem states invariance under
`x ↦ fun i => x (e i)` for `e : Equiv.Perm (Fin n)`; it is justified by
the retained sparse-block permutation consumer and C18 reordering.

```lean
theorem iid_map_perm {A : Type v} [Fintype A]
    (p : PMF A) (n : ℕ) (e : Equiv.Perm (Fin n)) :
    (iid p n).map (fun x i => x (e i)) = iid p n
```

Require `n = 0` pure empty-word behavior, `n = 1` evaluation to `p` and inverse
singleton transport, and splits `0+n` and `n+0`, without `n > 0` assumptions.
Because `iid` takes `p : PMF A`, the phrase `iid p 0` still requires that input
law. A law on `Fin 0 → Empty` exists via the general empty product; it is not
an application of iid to a nonexistent `PMF Empty`. Positive blocklength and
division by length belong to later normalized information statements.

### 3.5 Existing family and independence compatibility

A separate semantic owner supplies these proposed Shannon theorems:

- `familyMarginal_finiteProduct`: for `s : Finset I`, the existing
  `familyMarginal (finiteProduct p) s` equals the same constructor over `i : s`
  with components `p i`. `FamilyOutcome A s` is already definitionally this
  outcome type; introduce no second finite-family semantics.
- `isMutuallyIndependentFamily_finiteProduct`: the constructed law satisfies
  the existing `IsMutuallyIndependentFamily` on every selected finite atom.
- `isIndependentOf_finiteProduct_eval`: the two distinct evaluation variables
  satisfy the existing `IsIndependentOf` under the constructed law.

The headers in namespace `LeanInfoTheory.Shannon` are:

```lean
theorem familyMarginal_finiteProduct
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (s : Finset I) :
    familyMarginal (PMF.finiteProduct p) s =
      PMF.finiteProduct (fun i : s => p i.1)

theorem isMutuallyIndependentFamily_finiteProduct
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) (s : Finset I) :
    IsMutuallyIndependentFamily (PMF.finiteProduct p) s

theorem isIndependentOf_finiteProduct_eval
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    (p : ∀ i, PMF (A i)) {i j : I} (hij : i ≠ j) :
    IsIndependentOf (PMF.finiteProduct p) (fun x => x i) (fun x => x j)
```

Binary compatibility must prove the Section 3.3 law also equals released
`Shannon.indepProd (p i) (p j)`, using its existing definition. A retained
consumer can establish this by the low-level theorem and definitional equality;
no redundant public bridge alias is required. Retain a source-facing mutual
independence application via existing `familyLawOf`/predicate definitions,
without another source-facing wrapper. Existing equivalences and
`familyMarginal_restrict` remain the selected transport vocabulary.

Replace only the private `familyProduct` construction in
`SemanticBridge.FiniteFamilyIndependence` by an application of
`PMF.finiteProduct` to the existing coordinate marginals over `s`. Preserve
every public predicate, signature, theorem, attribute and historical meaning.
The original predicate continues to accept arbitrary ambient index and
alphabet types; new finiteness assumptions belong only to the new constructor
applications. Keep private induction, block and complement helpers private.

C19 may use the new two-coordinate law directly, or the focused semantic
theorem and existing `isIndependentOf_iff_indepFun`. Its `MemLp`, measurability,
composition with `selfInfo`, and variance-of-sum bridge remain C19 duties.
C16 must not depend on any future C18 owner. It need not remove existing
released information results from the already established semantic imports.

## 4. Ownership and public-surface policy

| Proposed owner | Contents and allowed dependency direction |
| --- | --- |
| `Probability.FiniteProduct` | Constructor and Sections 3.1–3.3 laws in `PMF`; direct local import `Probability.FiniteChannel` (which imports `Probability.Finite`), plus the focused mathlib finite-product/equivalence owners actually used. No project Shannon owner or aggregate. |
| `Probability.Iid` | Finite homogeneous block transports and iid laws: thin iid definition and Section 3.4 general non-iid transports; imports `Probability.FiniteProduct` and focused mathlib Fin/equivalence owners. No information-theory dependencies. |
| `Shannon.SemanticBridge.FiniteProduct` | Section 3.5 compatibility; direct local imports `Probability.FiniteProduct` and `Shannon.SemanticBridge.FiniteFamilyIndependence`. |
| Existing `SemanticBridge.FiniteFamilyIndependence` | Retain both existing direct imports; add only the downward `Probability.FiniteProduct` import for private constructor reuse. Never import the new semantic bridge back here. |
| `Examples.FiniteProduct` / `Examples.Iid` | Separate private retained mathematical consumers importing only their corresponding focused probability owner. |
| `Examples.FiniteProductSemantics` | Separate private consumer importing the focused semantic bridge, plus `Probability.Iid` only when its block examples need it. |

The full `Shannon` umbrella adds both probability owners. The semantic
aggregate adds the new semantic owner; the full umbrella already imports
that aggregate. The `Examples` aggregate adds the three private consumer
owners. These are deliberate opt-in growth proposals. Preserve every retained
direct import. `LeanInfoTheory.lean` keeps exactly its existing two direct
imports, five-module local closure and 92 exports.

Do not add public normalization witnesses, complement/range equivalences,
projection wrappers, event helpers, aliases, a bundled product structure or a
global independence abstraction. The listed public declarations each serve
the retained consumers or C17–C19 interfaces. Singleton, real-mass, support-set
equality, zero-iff and symmetric transport variants are derived privately
unless new independent consumer evidence justifies a separately reviewed change.
Default to no new simp attributes; explicit representation-changing equations
avoid rewrite loops. An attribute addition requires a separate termination,
consumer and compatibility review within the approved workflow.

After approval, record exact actual import/declaration growth and its real
approval provenance in `docs/compatibility/current-api-policy.json`. Generated
inventory is not approval. Preserve the frozen v0.1 manifest, retained contract,
trust policy and EPFL/MIL headers. Update source-derived artifacts deliberately;
do not regenerate historical API data. No production growth policy changes
are authorized during this planning turn.

## 5. Retained consumer matrix

All new consumer helpers/theorems are private or anonymous. Existing public
examples and declarations remain unchanged. A build must exercise the public
producer interfaces, rather than only elaborating definitions.

| ID / owner | Required concrete evidence |
| --- | --- |
| L1a / `Examples.FiniteProduct` | Heterogeneous dependent Boolean and ternary components: fair Boolean mass and ternary masses `1/2, 1/2, 0`; exact atoms, both coordinate marginal laws, and supported/impossible outcomes. Required in C16.01. |
| L1b / same | Restrict L1a's two-coordinate law to a singleton through the public `finiteProduct_map_restrict` interface. Required in C16.02. |
| L2 / same | A genuine three-coordinate non-iid family; restrict three to two to one, prove equality with direct restriction, and reorder a heterogeneous family using the exact transported alphabet. Include independent index universes in a generic signature consumer. |
| L3 / same | Sum split/concatenation of nonidentical components; both law directions and coordinate orientation; empty side. Two distinct coordinates have the required binary joint law. |
| L4 / same | Empty index with empty ambient alphabet (`Fin 0 → Empty`), singleton index, singleton alphabet, pure components, and impossibility of supplying a PMF on a selected empty alphabet. |
| L5 / same | Duplicate a fair Boolean coordinate: off-diagonal mass is zero whereas the independent pair has mass `1/4`. This rules out arbitrary repeated-coordinate restriction. |
| L6 / same | Construct a selected product for arbitrary `Var`, `s : Finset Var`, `A : Var → Type v`, only `[∀ i : s, Fintype (A i.1)]`, and `p : ∀ i : s, PMF (A i.1)`. Apply the public atom, support and evaluation laws with no `Fintype Var`, global finite-alphabet instance or ambient joint law. Instantiate `Var := ℕ`, `s := {0,1}`, with `Bool`/`Fin 3` at the selected indices and `ℕ` at every other index. Required in C16.01. |
| B1 / `Examples.Iid` | Nondegenerate Boolean iid and sparse ternary iid; obtain exact masses, support and coordinates from the general constructor; genuine permutation invariance and injective block selection. |
| B2 / same | A length-three non-iid block split as `1+2`, concatenated back to the same law; iid specialization; `0+n`, `n+0`, `n=0`, and `n=1` behavior. No reassociation casts in the exposed law statements. |
| B3 / same | Sparse length-two word `(0,2)` has zero mass, while supported words have the expected product mass. Supply C19's support regression without proving a self-information identity. |
| S1 / `Examples.FiniteProductSemantics` | The same kind of heterogeneous sparse law reaches `FamilyOutcome`, exact `familyMarginal`, mutual independence for empty/singleton/two-coordinate atoms, and a source-facing identity-family application. Also use L2's three-coordinate non-iid data to obtain `IsMutuallyIndependentFamily` on the full three-coordinate atom through `isMutuallyIndependentFamily_finiteProduct`, not only pair-independence interfaces. Repeat the tiny fixture privately in this owner as needed. |
| S2 / same | Distinct coordinates reach `indepProd` and existing `IsIndependentOf`; the constructed family's existing mutual-independence predicate is ready for C18's family equality API. No product entropy identity is implemented in C16. |
| I1 / separate import probes | Probability-only imports do not reach project Shannon/KL/topology owners. The focused semantic route gives C19's independence interface with no C18 dependency. Full umbrella compilation preserves the root boundary. |

Examples may repeat tiny private fixtures so lightweight consumers do not
import semantic examples. Exercise sparse laws rather than relying entirely
on pure laws, which would hide accidental independence assumptions.

## 6. Proposed execution steps and acceptance criteria

The order is `C16.01 → C16.02 → C16.03 → C16.04 → C16.05`.
Each step includes the workflow in Section 7, applicable documentation,
permanent consumers and focused validation. A step request selects only that
step. The final step is exclusively cumulative qualification and reconciliation.

### C16.01 — Normalized finite dependent products

Implement Section 3.1 in the new lightweight owner, with private proof
infrastructure only as needed, including the minimal coordinate/complement
split for marginals if that proof route is used. No C16.02 public theorem is
assumed. Add L1a, L4, L6 and the pure-coordinate consumer;
register the approved owner/umbrella/example growth and generated references.
L4's singleton round trip uses evaluation and the existing equivalence.
L1b's restriction of a larger family is deliberately left to C16.02.

- **C16.01-LAW:** The constructor, atom and support contracts of Section 3.1
  hold with the stated universes and assumptions, including normalized mass,
  zero atoms and no independent nonemptiness premises.
- **C16.01-MARGINALS:** Coordinate evaluation, empty products, singleton
  round-trip consumers and products of pure laws have the exact stated laws.
- **C16.01-BOUNDARY:** L1a/L4/L6 and a fresh probability-only import probe
  compile, including construction using only selected-alphabet finiteness
  over an infinite ambient index type. Ownership, root, retained compatibility
  and trust boundaries are preserved.

Validation: focused build of `Probability.FiniteProduct`,
`Examples.FiniteProduct`, `LeanInfoTheory`, `Shannon`, and `Examples`; static,
documentation and trust/compatibility gates as specified in Section 7. Review
normalization and coordinate marginal proofs, not just the constructor term.

### C16.02 — Restriction, reindexing, splitting and pairs

Implement Sections 3.2–3.3 and L1b/L2/L3/L5, reusing the C16.01 private
marginal infrastructure where appropriate. Any subset/complement/range
machinery remains private. Retain the actual inverse split and reindex consumers.

- **C16.02-TRANSPORT:** Injective restriction and equivalence reindexing have
  the exact dependent target types/directions; nested restrictions and a
  heterogeneous round trip are proved without strengthening hypotheses.
  L1b uses the general public restriction law for its singleton target.
- **C16.02-SPLIT:** Sum splitting, inverse concatenation consumer and distinct
  pair projection have the ordered low-level law equalities of Section 3.3,
  including empty sides and nonidentical/sparse components.
- **C16.02-REPETITION:** L5 proves the concrete repeated-coordinate failure;
  all coordinate-independence-producing interfaces retain their necessary
  distinctness/injectivity hypotheses and lightweight imports.

Validation: the C16.01 targets and applicable static/documentation/trust gates,
with fresh transport/independent-universe and import probes. Reassess the later
block/semantic plan if dependent transports need public-contract changes.

### C16.03 — Homogeneous blocks and iid specialization

Implement Section 3.4 and B1–B3 in the focused block owner/consumer. Register
their approved umbrella/import/public growth and regenerate current references.

- **C16.03-IID:** Iid is a thin specialization of the same constructor;
  sparse mass/support, coordinates, injective selection and permutation
  invariance are obtained through the public generic laws.
- **C16.03-BLOCKS:** Both exact Fin splitting/concatenation interfaces operate
  on nonidentical components and specialize to iid; the `1+2` round trip has
  the prescribed prefix/suffix orientation.
- **C16.03-DEGENERATE:** B2/B3 cover zero/one lengths, both empty-side splits,
  singleton alphabets and impossible symbols, explicitly distinguishing an
  empty general product from an unavailable base `PMF Empty` for iid.

Validation: focus both probability owners and both lightweight consumer owners,
the root/full/example aggregates and applicable static/documentation/trust
gates. Independently compile the focused `Probability.Iid` import boundary.

### C16.04 — Family and existing-independence bridge

Implement Section 3.5, S1/S2 and the semantic import probe. Reuse the public
constructor inside only the old private `familyProduct`; preserve all stable
interfaces and rebuild its existing consumers. No semantic dependency may
flow back into a probability owner.

- **C16.04-FAMILY:** `FamilyOutcome`/`familyMarginal` compatibility and existing
  mutual independence hold for the constructed laws and all selected atoms;
  source-facing consumers reuse existing semantics. S1 explicitly applies
  the new public bridge to the full three-coordinate non-iid atom.
- **C16.04-INDEPENDENCE:** Distinct coordinate pairs agree with released
  `indepProd` and satisfy existing `IsIndependentOf`; the C19 route is
  accessible without any new C18 owner or measure/variance infrastructure.
- **C16.04-COMPATIBILITY:** Private-constructor reuse preserves every retained
  predicate/theorem signature, assumptions, meaning, attributes and direct
  imports; new downward imports are separately recorded. S1/S2, old
  `Examples.FiniteFamily`, and both lightweight consumer owners compile.

Validation: additionally focus `SemanticBridge.FiniteFamilyIndependence`,
`SemanticBridge.FiniteProduct`, `Examples.FiniteProductSemantics`, and
`Examples.FiniteFamily`, plus the semantic/full/example aggregates. Run the
full trust/compiled compatibility gate and source-derived static/documentation
checks. No entropy/KL additivity result is included in this step.

### C16.05 — Cumulative qualification, review and handoff

Add no new mathematical endpoint. Verify all predecessor closures and source
applicability. Reconcile actual deliverables and evidence into canonical
documents, remaining-work dispositions, and `docs/handoffs/chunk-16.md` before
final source capture. Obtain only the separately authorized clean checkpoint
needed for the full gate, without absorbing unrelated pending work.

- **C16.05-VALIDATION:** The exact cumulative candidate passes the complete
  maintained clean routine suite, all permanent/import consumers, compatibility,
  current API/owner/import/simp checks, trust, documentation and hygiene.
  This chunk is an API-documentation milestone: obtain a fresh actual two-pass
  current file-mode API-doc gate and inspect the three new focused owner pages.
  Record exact source/dependency/output applicability; repeat required gates
  after any amendment. Pending authority or a failed gate is not completion.
- **C16.05-READINESS:** Finished owned edits, actual validation, retained
  contextual self-review and separate reassessment, and every earlier report's
  explicit reconciliation establish readiness for fresh cumulative review
  covering all 15 criteria in this plan. Preserve original findings and gaps;
  final report receipt/reconciliation and supported closure are subsequent
  duties, not pre-dispatch assumptions.
- **C16.05-HANDOFF:** Canonical context and the maintained handoff accurately
  record APIs, useful imports, consumers, references, conventions, finite-type
  and empty/support/transport distinctions, actual evidence limits and all
  remaining-work owners/triggers. State C17/C18/C19 prerequisites separately;
  do not approve or start those chunks or transfer this reviewer binding.

Fresh independent cumulative review must assess every C16.01–C16.05 criterion,
not just the three closeout rows. Reconcile the original report and every
criterion assessment through the installed workflow. Reviewer gaps require
fresh satisfactory reviewer assessment; parent checks do not override them.
Finish corrections, final validation, document finalization and supported
closure against exact F. Captured documents use provisional closure wording;
only the private completion record and user report claim actual completion.

## 7. Validation, review and documentation gates

Use `python -B scripts/validate_release.py focused <targets>` for touched
owners, important downstream consumers and aggregates, serializing builds.
Retain actual commands, exit codes, diagnostics, actor/source identities and
limitations. A compiling example is not a mathematical review, and cached
dependencies are not a claimed cold build.

For every public/import change, update the reviewed current growth policy with
the actual approved plan/step reference, then deliberately run the current
public API and website blueprint/index generators. Verify the historical
manifest with `generate_v0_1_public_api.py --check`; do not rewrite it.
Run `validate_release.py static`, `documentation`, and `trust` (which includes
compiled compatibility) before step review/closure. Independently compile new
focused mathematical consumers with warnings as errors. Inspect exact local
and external direct imports, transitive project reachability and reviewed simp
sets; do not infer dependency boundaries only from source import spelling.
Integrate retained consumer owners into maintained aggregate validation.

While the checkout is intentionally dirty, use the supported focused/static
gates and report clean-gate limitations. The complete default validator
requires a clean committed tree; no temporary exclusion or automatic commit
of user work is allowed. At closeout, prepare the exact owned changes first,
then seek any necessary separate checkpoint/checkout authority. A validation
checkout must be explicitly inspected and authorized, remain inside ignored
`.worktrees/`, and be compared with candidate source/configuration/dependencies.
No earlier chunk's clean-checkout or path-dependent attestation is presumed
to apply. Windows API-doc validation uses the exact reviewed Zig 0.16.0 tool
through `LEANINFOTHEORY_ZIG`; file mode is local, not publication evidence.

The actual C16 parent owns one persistent reviewer, requested
`gpt-6-astra`/`ultra`, with `fork_turns="none"` through the supported
`collaboration` transport. Preserve original native creation/list/dispatch
results and distinguish requested settings from unknown effective settings.
Read-only conduct is cooperative, not OS isolation. Do not reuse another
chunk's binding or replace a missing reviewer silently. Formal PLAN sessions
await the lead's explicit request; execution sessions await exact-plan approval
and explicit step selection. Bind source B/R/F, exact criteria, neutral rubric,
scope and reference evidence using installed APIs. Preserve every refusal and
stop rather than editing journals or fabricating receipts.

Each selected step retains read-only self-review, separate reassessment,
justified improvements and applicable validation before dispatch. Review is
independent, source-bound and read-only; preserve and reconcile the original
report even when clean. Remaining material findings, unresolved required
criteria or uncertain source identity block supported closure. Review completion
itself grants no commit or later-step authority.

Required cumulative documents are the living summary's relevant status,
coverage/architecture, future-work and validation sections;
`docs/current-lean-state.md`; the relevant roadmap execution status;
`docs/references.md` for actual source adaptations; current API/generated
references; and the maintained handoff. Meaningful project-log updates during
future implementation must preserve existing unrelated bytes/hunks and must
not absorb them into any C16 checkpoint. During this planning turn that file
is untouched. Preserve `docs/next-website-tasks.md` untouched throughout.

## 8. Decisions for approval and remaining-work dispositions

The proposal asks the lead to approve the finite-alphabet contract, the five
steps and 15 criteria, the three focused owners/import directions, injective
restriction and forward reindexing orientation, thin iid specialization, the
small selected public theorem set, private-product reuse, and the cumulative
validation/API-documentation milestone. These are proposals, not existing
approvals. Formal plan review, if desired, requires an explicit request.

Revision 2 keeps those five steps, all 15 criterion IDs, the selected public
declarations and the three focused owners. It makes the critical signatures
explicit, resolves the private marginal-proof/public-transport ordering, and
adds selected-subset and three-coordinate semantic consumers within existing
steps. Keep `Probability.Iid`: its documentation must clearly include the
general non-iid Fin block transports it owns. A separate paired-law support
regression is deferred for consideration with C18's singular-product KL work.
The [notes](post-release-chunk-16-notes.md) record each advisory disposition,
actual bounded probe evidence and the limits of revision-1 review applicability.

No mathematical meaning is deliberately left undecided. Proof routes and
minimal mathlib import lists remain evidence-driven implementation details;
the notes distinguish compiled probes from source-based feasibility. If the
required transport cannot be proved under these hypotheses, stop for plan
health rather than strengthening assumptions or quietly narrowing criteria.

| Remaining work | Owner / trigger |
| --- | --- |
| Arbitrary component alphabets or `Finite`-only convenience interface | Later probability API proposal only after a concrete consumer and proof/import review; no infinite product follows from such a proposal. |
| Coordinatewise maps/binds, product channels and joint-law composition | C17 detailed planning, using the same component constructor for every input; correlated inputs remain permitted. |
| Product entropy/KL, block information, memoryless bounds | C18, consuming exact family/pair interfaces; guarded Real KL and singular laws remain its obligations. |
| Supported block logarithms, measure independence, integrability/variance and AEP | C19; use sparse support facts and distinct-coordinate law without C18. Freeze its own typical-set boundary convention. |
| Aliases, extra projections, symmetric/support/real variants | Standing Notes 14/29; require actual independent consumer/search pressure. Private feasibility helpers are not an API obligation. |
| Programme-size calibration | Record actual substantive growth separately from wrappers/examples; C15's 27 C13–C15 additions are historical evidence. Reassess the C16–C18 package at C18 without adding filler. |
| Commit, push, publication, next chunk | Separate explicit lead authority; no C16 workflow result supplies it. |

The final handoff must give explicit completed/deferred/rejected dispositions,
owners and reopening triggers, rather than describing all unimplemented ideas
as C16 failures or silently dropping required scope.
