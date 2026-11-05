# Chunk 18: Block information and single-letterization

<!-- lit-review-status:start -->
**Status:** Active, approved revision 2. C18.01--C18.05 and their reviews are
complete by actual private records. Exact C18.05 source, environment and Git
identity were verified before the conditional C18.06 request was admitted on
2026-10-18. Only C18.06 is selected; it adds no mathematical endpoint.
The lead approved the exact 28-path local checkpoint, necessary C18.06-only
review/evidence amendments within that scope and reuse of the inspected detached
validation checkout. Initial checkpoint `8b30dc96e89a9b4e0224b059faed48e19a4e5f1e`
passed the complete maintained clean routine. The primary checkout preserves
the three excluded files and the older unrelated project-log entry.
Fresh actual two-pass current file-mode API documentation passed separately;
all fifteen signatures, hypotheses, docstrings, owners and source links were
inspected. The initial missing-page failure and bounded three-marker recovery
remain recorded with their evidence limits.
This is captured qualification prose. Review readiness, fresh all-twenty-criterion
independent review, explicit reconciliation and exact final validation/source
applicability require their actual source-bound records. Supported closure is
established only by those records and
`.lit-review/setup/c18-06-completion-20261018.json` when present;
this account does not certify those later events. Every amendment requires the
complete maintained clean rerun and exact API applicability.
No push, release or later-chunk work is authorized here.
Revision 2 has no separate PLAN review; revision-1 evidence and its recording
limitation remain in the [notes](post-release-chunk-18-notes.md). The actual
C18 parent retains its persistent reviewer binding. This editorial region
records status only; normative mathematical requirements below remain unchanged.
<!-- lit-review-status:end -->

## 1. Scope and authority

Deliver finite-product entropy and KL additivity, arbitrary-input product-channel
conditional-output entropy and mutual-information bounds, independent-pair and
iid equality cases, and the complementary independent-source inequality for one
general finite observation. Reuse the existing PMF products, raw channels,
family independence predicates, information quantities and exact joint transports.

Memorylessness concerns conditional outputs at a supplied input word. It does
not imply independent inputs or independent unconditional outputs. The two MI
inequalities have different hypotheses; neither is a substitute for the other.

The exact channel MI gap and equality iff output coordinates are mutually
independent are preferred **optional** refinements. Evaluate them within C18.04;
they create no total-correlation definition or separate programme. All other
mathematical contracts in Section 3 are required, including the general-observation
independent-source inequality. An interface obstacle must be reported and resolved
without silently dropping that endpoint or strengthening its hypotheses.

Excluded: capacity and capacity additivity (C22), AEP/typicality (C19), codes,
rates and converses (later chunks), infinite-alphabet/process results, feedback,
new channel abstractions, dependency upgrades, review-tooling changes, release
preparation/publication, and PFR/ShannonCert changes. The second-release chat
remains waiting for programme completion and qualification.

Implementation requires lead approval of this exact revision. Each eligible
request selects only one approved step with its required review process,
followed by a stop. Evidence-based proof and advisory-plan adaptations must
retain the intended mathematical goals and be explained for meaningful review.
Commits, pushes, tags, deployment and Desktop-folder creation require separate
permission. Preserve unrelated pending work.

## 2. Verified starting point and references

Work only in `C:\Users\coban\Desktop\Lean Info Theory`. Intake is `master`, HEAD
`dacb55f97c1f942db929c59e99ea0fb9b8ac7cdd`, six commits ahead of the locally
recorded `origin/master`. No fetch or claim about current remote state is made.
Four pre-existing modified files are protected: `.gitignore`, `AGENTS.md`,
`docs/next-website-tasks.md`, and `docs/project-log.md`.

C9--C17 are completed predecessors. C17's actual record
`.lit-review/setup/c17-05-completion-20261016.json` reports all five steps closed,
no active step, zero findings, and checkpoint HEAD matching intake. Its closure is
`b4eef2917fc985d6c14de64230a898d7a5ed7210255e0406118479b4398d072d`;
final capture F is
`5b0675faa3093e3403a5d8c5e7d9977344540bbabbd6d35026b669bf44017e96`.
Fresh C18 hashing matched all 245 real-file entries, and separately matched its
Git, configuration and installed-dependency records. This is applicability
evidence, not a newly run complete suite or a retrospective review.

C16's actual completion record, its maintained handoff and C17's maintained
handoff were inspected. Preserved pre-closure wording in captured plans,
handoffs, the living summary and roadmap does not reopen either chunk.
Retain the source-bound original evidence rather than editing their history.

Lean remains `leanprover/lean4:v4.33.1`; mathlib is `v4.33.1`, resolved to
`0df444a360eaa60ab8c11dca51a86af692955474`. All nine root dependencies are
installed, clean and match their pins. Docbuild configuration/pins match C17's
capture; a separate read-only audit also verified all fourteen installed Git
dependencies clean at their configured revisions. No fresh API build is claimed.
Preserve the frozen v0.1.0 contract at
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, the root's two direct imports,
five-module local closure and 92 exports, and the 94 reviewed simp names.
Intake has 698 supported declarations in 43 owners; inventory supplies no
growth approval or declaration target.

### 2.1 Reuse and feasibility evidence

| Inspected owner | Existing reusable interface |
| --- | --- |
| `Probability.FiniteProduct` / `Iid` | Product masses/support, evaluation, restriction/reindexing, sum/pair and ordered block transports, thin `iid`. |
| `Probability.ProductChannel` | Product rows, actual-input coordinate/restricted joints, independent-input output product, exact tuple-of-pairs joint transport, thin `memorylessChannel`. |
| `SemanticBridge.FiniteProduct` | Product family marginals and full mutual independence, distinct-coordinate independence. |
| `FiniteFamily` / `SemanticBridge.FiniteFamilyIndependence` | Selected family entropy, singleton and RV bridges, entropy additivity iff mutual independence. |
| `SemanticBridge.FiniteFamily` / `Theorems` | Family entropy subadditivity, conditional monotonicity, binary RV conditional subadditivity. No general conditional tuple-sum theorem was identified. |
| `SemanticBridge.Convexity` | Public `mutualInfo_channelJoint_eq_entropy_bind_sub_sum`. Its neighboring joint-entropy and expectation helpers are private. |
| `SemanticBridge.ConditionalKL` / `KL` | Unconditional ENNReal joint chain rule and weighted conditional KL, support iff KL finiteness/top, guarded Real forms. |
| Pinned mathlib | `klDiv_compProd_eq_add`, `klDiv_map_le`, `Fintype.induction_empty_option`, `Equiv.piOptionEquivProd`, dependent pair/sum equivalences and finite sum/product algebra. |

Targeted pinned mathlib information-theory searches found no direct finite-pi KL
additivity replacement. Existing project adapters should precede new measure
machinery. `SemanticBridge.DataProcessing` has a **private** KL equivalence
lemma; use a private derivation from map contraction in both directions unless
actual consumer pressure justifies separately reviewed promotion.

Source inspection and checks of existing declarations establish available
interfaces. They do not establish compilation of the proposed proofs. The notes
distinguish these evidence levels and identify the dependent KL induction and
general conditional-subadditivity proof as the principal implementation risks.

### 2.2 Exact mathematical sources

Use registered **PW24**, August 16, 2024, SHA-256
`c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
PW22 is the separate October 20, 2022 draft; its numbering is not interchangeable.

| PW24 anchor | Selected meaning / adaptation |
| --- | --- |
| Section 1.1, Theorem 1.4(g), (1.3), printed 12 / PDF 37 | Finite entropy subadditivity and equality iff full mutual independence; reuse established family machinery for products. |
| Section 1.1, Definition 1.3, printed 10 / PDF 35 | Weighted conditional entropy; zero input masses contribute zero. |
| Section 2.5, Theorem 2.16(d), printed 33--34 / PDF 58--59; chain rules 2.15 and 2.16(c), printed 32--34 / PDF 57--59 | Product KL tensorization, including infinity. Project adaptation uses finite PMFs, ENNReal first and explicit Real guards. |
| Section 3.2, Theorem 3.4(b)--(c), (3.2)--(3.3), printed 44--45 / PDF 69--70 | MI/conditional-entropy identities, with the project's first-given-second orientation and nats. |
| Section 6.1, Theorem 6.1(a)--(b), (6.1)--(6.2), printed 106--107 / PDF 131--132 | Arbitrary-input product-channel upper bound and general-observation independent-source lower bound. |

The exact gap is a derived finite-alphabet identity, not a separately numbered
source theorem. Do not reuse the neighboring KL equality discussion for infinite
values. PW24 Example 6.1's last bullet discusses coordinate observations while
(6.2) uses the same observation in every summand; use the displayed theorem and
proof, with the XOR consumer below, rather than copying that strictness example.
No additional reference or external formalization is needed for these contracts.

## 3. Mathematical contracts

All declaration names below are proposed. Equations, hypotheses, orientation,
required endpoints and consumer obligations become normative only on exact lead
approval. Names may receive evidence-based spelling adjustments under the naming
policy; changing mathematical meaning or important public contracts requires
the lead. All declarations belong to `LeanInfoTheory.Shannon` unless stated.

Use independent universes: `I : Type u`, `A : I → Type v`, `B : I → Type w`.
Assume `[Fintype I]`, `[∀ i, Fintype (A i)]` and, where B occurs,
`[∀ i, Fintype (B i)]`. Each dependent family has one fiber universe; do not
identify index, input or output universes. Information definitions enumerate
finite value alphabets. No public `DecidableEq`, positivity, full-support or
nonempty-index premise is required; classical choices remain internal.

### 3.1 Entropy of products

Required public endpoints:

```lean
entropy_finiteProduct (p : ∀ i, PMF (A i)) :
  entropy (PMF.finiteProduct p) = ∑ i, entropy (p i)

entropy_iid {α : Type v} [Fintype α] (p : PMF α) (n : ℕ) :
  entropy (PMF.iid p n) = (n : ℝ) * entropy p
```

The family instances above are implicit in these schematic headers. Reuse
`familyEntropy_eq_sum_singletons_iff_isMutuallyIndependentFamily` and C16's
product-independence theorem. Derive full-word and singleton representation
bridges; do not duplicate a logarithmic proof of entropy additivity. Keep bridges
private unless repeated production/consumer uses warrant a reviewed public form.

### 3.2 Product KL, including singular laws

Additionally use `[∀ i, MeasurableSpace (A i)]` and
`[∀ i, MeasurableSingletonClass (A i)]`, with the standard dependent-product
measurable structure. Use `InformationTheory.klDiv` on the PMFs' measures;
no new KL definition is proposed.

For arbitrary `p q : ∀ i, PMF (A i)`, require:

```lean
klDiv_finiteProduct
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    [∀ i, MeasurableSpace (A i)] [∀ i, MeasurableSingletonClass (A i)]
    (p q : ∀ i, PMF (A i)) :
    InformationTheory.klDiv (PMF.finiteProduct p).toMeasure
        (PMF.finiteProduct q).toMeasure =
      ∑ i, InformationTheory.klDiv (p i).toMeasure (q i).toMeasure

toReal_klDiv_finiteProduct
    {I : Type u} {A : I → Type v}
    [Fintype I] [∀ i, Fintype (A i)]
    [∀ i, MeasurableSpace (A i)] [∀ i, MeasurableSingletonClass (A i)]
    (p q : ∀ i, PMF (A i)) (h : ∀ i, (p i).support ⊆ (q i).support) :
    (InformationTheory.klDiv (PMF.finiteProduct p).toMeasure
        (PMF.finiteProduct q).toMeasure).toReal =
      ∑ i, (InformationTheory.klDiv (p i).toMeasure (q i).toMeasure).toReal
```

These are proposed Lean headers with explicit binders, not newly elaborated
declarations. The implementation checkpoint below must verify the dependent
measurable/product transports without strengthening these assumptions.

No support assumption is imposed on the ENNReal identity. The Real theorem
must establish finiteness of every coordinate divergence and the product before
using finite-sum conversion. Full support is unnecessarily strong. Equivalent
finite-KL facts may be used internally; no duplicate public guard variant is
selected without a consumer.

Required homogeneous specializations, with the same finite/discrete measurable
assumptions on α, are:

```lean
klDiv_iid
    {α : Type v} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) (n : ℕ) :
    InformationTheory.klDiv (PMF.iid p n).toMeasure (PMF.iid q n).toMeasure =
      (n : ENNReal) * InformationTheory.klDiv p.toMeasure q.toMeasure

toReal_klDiv_iid
    {α : Type v} [Fintype α]
    [MeasurableSpace α] [MeasurableSingletonClass α]
    (p q : PMF α) (h : p.support ⊆ q.support) (n : ℕ) :
    (InformationTheory.klDiv (PMF.iid p n).toMeasure
        (PMF.iid q n).toMeasure).toReal =
      (n : ℝ) * (InformationTheory.klDiv p.toMeasure q.toMeasure).toReal
```

Include `n = 0` and `n = 1`. Empty products have KL zero, including the
ENNReal specialization `0 * ⊤ = 0`. This does not license an unguarded public
Real information theorem. Product-support comparison is an internal fact and
permanent regression obligation, not automatically an extra public API.

The guard has distinct roles in the two Real statements. Heterogeneous
finite-sum conversion can actually fail without finiteness, as K2 demonstrates.
For iid, the scalar identity is algebraically valid even for infinite base KL:
pinned `ENNReal.toReal_mul` is unconditional, and both Real sides collapse to
zero in the singular case. Retain the public iid support guard to express the
project's finite-information contract, including at zero length; do not describe
it as necessary for multiplication conversion or add an unguarded public alias.

### 3.3 Conditional output entropy for arbitrary inputs

For arbitrary `q : PMF ((i : I) → A i)` and
`W : ∀ i, A i → PMF (B i)`, use the following local notation only:

```text
K   = PMF.productChannel W
J   = PMF.channelJoint q K
q_i = q.map (fun x => x i)
J_i = PMF.channelJoint q_i (W i)
```

Required `condEntropy_channelJoint_productChannel` has equation

```text
condEntropy (J.map Prod.swap) = ∑ i, condEntropy (J_i.map Prod.swap).
```

Its proposed Lean header makes the actual marginal laws explicit:

```lean
condEntropy_channelJoint_productChannel
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (q : PMF ((i : I) → A i)) (W : ∀ i, A i → PMF (B i)) :
    condEntropy ((PMF.channelJoint q (PMF.productChannel W)).map Prod.swap) =
      ∑ i, condEntropy
        ((PMF.channelJoint (q.map (fun x => x i)) (W i)).map Prod.swap)
```

Thus it means `H(Y^I | X^I) = ∑ i H(Y_i | X_i)`. The swap is essential.
Use C17's exact joint projections for the coordinate laws. No independent-input
or full-support premise belongs here. A weighted row-entropy proof can reuse the
public channel-MI formula, product entropy and finite expectation transport.
No general conditional reconstruction theorem is required for that proof.

Semantic consumers must nevertheless respect supported-only reconstruction:
`condFstGivenSndChannel (J.map Prod.swap) x = K x` only for `x ∈ q.support`.
Null-fiber fallback remains the existing totalization, without conditional meaning.
Changing coordinate rows at values absent from their actual input marginal
supports leaves the induced joint and all these information quantities unchanged.

### 3.4 Channel MI bound, independent pairs and iid equality

With exactly Section 3.3's data, require the public channel-facing bound
`mutualInfo_channelJoint_productChannel_le`:

```text
mutualInfo J ≤ ∑ i, mutualInfo J_i.
```

The corresponding proposed Lean header is:

```lean
mutualInfo_channelJoint_productChannel_le
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (q : PMF ((i : I) → A i)) (W : ∀ i, A i → PMF (B i)) :
    mutualInfo (PMF.channelJoint q (PMF.productChannel W)) ≤
      ∑ i, mutualInfo (PMF.channelJoint (q.map (fun x => x i)) (W i))
```

Both channel headers are proposed, not newly compiled. The product-channel
constructor is essential: independent inputs alone do not justify this bound
for a channel that mixes input coordinates.

Required general independent-pair equality, proposed
`mutualInfo_map_piProd_eq_sum_of_isMutuallyIndependentFamily`, takes
`r : PMF ((i : I) → A i × B i)` and
`hr : IsMutuallyIndependentFamily r Finset.univ`:

```text
mutualInfo (r.map (Equiv.arrowProdEquivProdArrow I A B))
  = ∑ i, mutualInfo (r.map (fun z => z i)).
```

This asserts mutual independence of the coordinate **pairs**, not independence
between each pair's input and output, nor pairwise independence of the pairs.
It requires no channel representation. The pair fibers live in `Type (max v w)`.
Place this general theorem in `SemanticBridge.FiniteProduct`, delivering it in
C18.04; the channel-specific equalities below consume it from ProductChannel.
Its direct E2 consumer must include positive MI within each independent pair.

Required public product-input specialization, proposed
`mutualInfo_channelJoint_finiteProduct`, uses C17's exact joint factorization:

```text
mutualInfo (PMF.channelJoint (PMF.finiteProduct p) (PMF.productChannel W))
  = ∑ i, mutualInfo (PMF.channelJoint (p i) (W i)).
```

Required `mutualInfo_channelJoint_iid`, for finite α, β and any `p : PMF α`,
`W : α → PMF β`, `n : ℕ`, is

```text
mutualInfo (PMF.channelJoint (PMF.iid p n) (PMF.memorylessChannel W n))
  = (n : ℝ) * mutualInfo (PMF.channelJoint p W).
```

The arbitrary-input repeated-channel bound is a required permanent consumer of
the general bound, with actual coordinate marginals; no redundant wrapper is
automatically exported. All zero/one-length specializations remain meaningful.

**Preferred optional refinements**, proposed `sum_mutualInfo_sub_mutualInfo_productChannel`
and `mutualInfo_channelJoint_productChannel_eq_sum_iff`:

```text
(∑ i, mutualInfo J_i) - mutualInfo J
  = (∑ i, entropy (q_i.bind (W i))) - entropy (q.bind K)

mutualInfo J = ∑ i, mutualInfo J_i
  ↔ IsMutuallyIndependentFamily (q.bind K) Finset.univ.
```

Prefer deriving the required bound from the gap if representation bridges fit
naturally. Independent inputs suffice for equality but are not necessary;
constant-output channels give equality under correlated inputs. Pairwise output
independence is insufficient. Record separate selection/disposition decisions
for the gap identity and the equality iff in C18.04 notes and review. Exporting
the gap alone does not require exporting the iff. C3 becomes mandatory when the
iff is exported; a gap-only choice does not activate that consumer obligation.
Optional export is permitted within this approved
envelope if naturally obtained; defer with reasons if it creates a separate
programme. Optional difficulty cannot remove any required endpoint.

### 3.5 Independent sources and one general observation

Required reusable conditional-subadditivity interface, proposed
`condEntropyOf_pi_le_sum`, with explicit separate universes:

```lean
{I : Type u} {A : I → Type v} {Ω : Type w} {C : Type z}
[Fintype I] [∀ i, Fintype (A i)] [Fintype C]
(p : PMF Ω) (X : ∀ i, Ω → A i) (Y : Ω → C) :
  condEntropyOf p (fun ω i => X i ω) Y ≤
    ∑ i, condEntropyOf p (X i) Y
```

Required `sum_mutualInfoOf_le_mutualInfoOf_pi`, with the same data and only
the additional hypothesis
`hX : IsMutuallyIndependentFamilyOf p X Finset.univ`, has equation

```text
(∑ i, mutualInfoOf p (X i) Y)
  ≤ mutualInfoOf p (fun ω i => X i ω) Y.
```

There is no finite-source Ω premise, no relation between the universes v and z,
no product-conditional-law premise, and no independence assumption on Y.
The same arbitrary finite observation occurs in every term. Actual independence
of the unconditioned source family supplies entropy additivity; conditioning can
create dependence. A product-law-only or coordinate-observation-only interface
would not discharge this contract.

The existing binary conditional theorem supports a dependent finite-index
induction. Alternatively extend conditional family inequalities and transport
the observation into a common universe privately. `Sum I Unit` packaging alone
does not solve the distinct fiber/observation universes; do not erase that issue
by silently restricting the signature. Record any genuine blocker for lead
decision while preserving the required statement.

## 4. Ownership and permanent consumers

| Proposed owner | Contents and import boundary |
| --- | --- |
| Existing `Shannon.SemanticBridge.FiniteProduct` | Product/iid entropy in C18.01 and general independent-pair MI equality in C18.04, beside C16's family bridges; add `Probability.Iid` as needed. No new ProductKL or probability/semantic ProductChannel import. |
| New `Shannon.SemanticBridge.ProductKL` | Product/iid ENNReal and guarded Real KL; import `Probability.Iid` and `SemanticBridge.ConditionalKL`. Keep equivalence/induction/support plumbing private. |
| Existing `Shannon.SemanticBridge.FiniteFamily` | General conditional tuple subadditivity, using existing binary inequalities. No product-channel or ProductKL import. |
| Existing `Shannon.SemanticBridge.FiniteFamilyIndependence` | Independent-source MI inequality beside the existing entropy equality characterization; depends on the conditional-subadditivity producer. |
| New `Shannon.SemanticBridge.ProductChannel` | Conditional-output entropy, channel bound, product-input/iid equality and selected optional refinements. Consume general independent-pair equality from semantic FiniteProduct. Import probability ProductChannel, semantic FiniteProduct, and Convexity; do not import ProductKL just to share block terminology. |

All owners stay opt-in from the lightweight root. Add appropriate imports only
to the full Shannon umbrella; the root remains exactly `Probability.Finite` and
`InformationMeasures`. New proofs may refine focused direct imports with evidence
and growth-policy reconciliation, but no heavy information dependency enters a
probability owner. Preserve existing declarations, structural signatures, semantics,
attributes and imports required by the frozen contract. No new simp rules are
planned. Keep chain rules, symmetry and representation changes explicit.

Permanent consumers are private declarations in focused example owners, joined
only by `LeanInfoTheory.Examples`. Reuse existing fixtures where accessible;
duplicate tiny private fixtures across import/privacy boundaries when appropriate.

| Consumer | Required content and primary step |
| --- | --- |
| E1, `Examples.FiniteProductSemantics` / `Examples.IidInformation` | Heterogeneous non-iid sparse product entropy; actual family bridge; iid zero/one/general n, singleton and empty index, and a singleton alphabet with entropy zero. C18.01. |
| E2, `Examples.FiniteProductSemantics` | Direct general independent-pair equality under the focused FiniteProduct import: independent pairs `(U,U)` and `(V,V)` for independent fair bits, each with MI `log 2` and whole joint MI `2 * log 2`. Also retain a heterogeneous, nonidentical pair-family consumer; the Boolean example does not replace it. C18.04. |
| K1, `Examples.ProductKL` | Finite supported heterogeneous products with zero masses; guards and actual product support. Empty/singleton indices, a singleton alphabet with KL zero, and iid zero/one laws. C18.02. |
| K2, same owner | C16 deferred paired-support regression: P=(fair,pure false), Q=(pure false,fair). Supports overlap but neither includes the other; explicit witnesses in each direction. Product KL is top, coordinate KLs are top and positive finite log 2; the unguarded Real sum identity fails. C18.02. |
| C1, `Examples.ProductChannelInformation` | Arbitrary correlated diagonal inputs through genuinely noisy rows, using the actual marginal-law RHS; sparse null inputs, unchanged joint after absent-coordinate row changes, correctly swapped conditional entropy and supported-only row recovery. C18.03. |
| C2, same owner | Correlated fair diagonal through identity gives block MI log 2 versus sum 2 log 2; same input with constant outputs gives equality, including an actual singleton output alphabet with MI zero. Heterogeneous product-input equality; iid zero/one/general n. General pair equality is exercised separately by E2. C18.04. |
| C3, same owner | Three outputs (U,V,U xor V) under identity: pairwise independent but not mutually independent; positive entropy/MI gap. Required if optional exact equality criterion is exported; otherwise retain an explicit deferred disposition. C18.04. |
| S1, `Examples.FiniteFamilyInformation` | Arbitrary source type, heterogeneous source alphabets, separate observation universe and the direct RV interface. Independent fair bits with XOR observation have coordinate MI sum zero and joint MI log 2; they need not be conditionally independent. Empty/singleton family. C18.05. |
| H1, channel information owner | Noninjective encoding (a,b) ↦ (a,a) of independent source bits, correlated induced word law and repeated channel. Consume the bound directly, plus a generic coordinate-objective cap implication and product-input equality. C18.04 and cumulative handoff. |

Empty component alphabets cannot supply their component PMFs; do not manufacture
fallback laws. Empty index has a unique empty word. General channel information
requires a supplied input PMF; raw vacuous channels alone do not provide one.
For iid zero length, the definition still takes a base PMF, and the repeated
channel still takes W. Test these boundaries without adding gratuitous nonempty
or positive-length assumptions. Where no law exists, record the impossibility
or vacuous type boundary rather than claiming a probability calculation.
Distinguish a singleton index from a singleton alphabet (for example `PUnit`).
E1/K1 exercise the latter for entropy/KL, and C2 exercises singleton outputs;
these are small cases in existing example owners, not new public wrappers.

## 5. Ordered steps and acceptance criteria

The dependency order is deliberate: entropy supports row entropy and pair
equality; KL is a separate bounded branch; conditional-output entropy precedes
channel MI; the independent-source inequality has its own general conditional
interface. Each step includes focused validation, contextual self-review,
separate reassessment, fresh independent STEP review, explicit reconciliation,
final validation and source-bound closure. Stop after the selected step.

### C18.01 — Product and iid entropy

Implement Section 3.1 in the existing focused owner; build the representation
bridges only as needed and add E1 consumers. Resolve the full-word/univ reduction
before relying on it in later steps.

- **C18.01-ENTROPY:** Product and iid entropy satisfy Section 3.1 with heterogeneous families, separate universes, and existing mutual-independence reuse.
- **C18.01-EDGES:** E1 exercises sparse, empty/singleton-index, singleton-alphabet and zero/one-length cases through the public endpoints.
- **C18.01-ARCHITECTURE:** Probability/root boundaries, retained API and conservative simp policy are preserved and qualified on the actual source.

### C18.02 — Finite-product KL

Begin with an internal proof checkpoint: establish binary independent-product
KL additivity in ENNReal, including infinite values, and verify the dependent
product-splitting transport needed for induction with the proposed headers.
Resolve those representation issues before extensive K1/K2 development.
Then implement Section 3.2 in ProductKL, including dependent finite-index
transport, singular values and guarded Real forms. Complete K1/K2; make the support
regression concrete without exporting unused plumbing. This step depends only
on existing probability/KL foundations, not on channel MI or new capacity notions.
The checkpoint is part of C18.02, not another step, a public-helper obligation or
permission to strengthen hypotheses. It is a proof milestone, not a Git checkpoint.

- **C18.02-ENNREAL:** The binary/splitting checkpoint is resolved, and finite-product and iid KL additivity hold in ENNReal without support restrictions, including top and zero length.
- **C18.02-REAL:** Real product and iid forms require explicit support/finiteness guards and justify every ENNReal.toReal conversion.
- **C18.02-SUPPORT:** K1/K2 exercise actual sparse product supports, singleton alphabets, both support-inclusion failures, singular KL and a concrete failure of unguarded heterogeneous Real summation.
- **C18.02-ARCHITECTURE:** The separate KL owner reuses existing project/pinned mathlib machinery and preserves probability, root and historical API boundaries.

### C18.03 — Conditional output entropy

Implement Section 3.3 after C18.01, using C17's exact actual-input laws. Add C1
and the required null/support interpretation checks; do not promote private
conditional recovery or Convexity helpers solely for convenience.

- **C18.03-CONDITIONAL:** Output-given-input entropy adds for arbitrary correlated input laws with exactly Section 3.3's assumptions and orientation.
- **C18.03-LAWS:** Coordinate RHS terms are the actual projected channel joints, and noisy correlated inputs exercise that interface.
- **C18.03-NULL:** Sparse and absent-coordinate row changes preserve the induced joint and information values; conditional reconstruction remains supported-only with the existing null fallback.

### C18.04 — Channel single-letterization and equality cases

Implement all required Section 3.4 endpoints, E2, C2 and H1 after C18.03.
Deliver the general independent-pair theorem in semantic FiniteProduct and its
channel specializations in ProductChannel. Use the exact pair-to-word transport.
Evaluate optional gap and equality-iff exports separately within this step,
record each decision and its evidence, and add C3 if the iff is exported.

- **C18.04-BOUND:** The channel-facing MI upper bound applies to every finite input-word law, including the noisy and noninjectively encoded correlated consumers.
- **C18.04-EQUALITY:** General mutually independent pairs, product inputs and iid input/channel satisfy their required exact MI equalities, including zero/one lengths; E2 directly exercises positive within-pair MI without a ProductChannel import.
- **C18.04-OPTIONAL:** The gap identity and equality iff each have an explicit disposition. An exported iff characterizes full output mutual independence and requires C3; exporting only the gap does not require C3.
- **C18.04-CONSUMERS:** E2's positive-MI and heterogeneous/nonidentical pair consumers, strict correlated identity, correlated constant/singleton-output equality, heterogeneous independent processing and the concrete C22/C23 objective interfaces compile and preserve focused imports.

### C18.05 — Independent sources and a general observation

Begin with an internal proof checkpoint: verify the dependent tuple-to-pair
induction and required equivalence transport with arbitrary source Ω and
genuinely separate alphabet/observation universes. Resolve that route before
extensive S1 development; it creates no extra step or permission to strengthen
the statements. Then implement both Section 3.5 interfaces in their existing
family owners. Address the dependent-tuple and universe bridges without
strengthening assumptions.
Use S1 to verify the theorem's distinction from the channel upper bound.

- **C18.05-CONDITIONAL:** The tuple-to-pair/universe checkpoint is resolved, and general conditional tuple subadditivity permits arbitrary source type and an independently-universed finite observation, with no product-conditional-law premise.
- **C18.05-SOURCE:** The required sum-of-coordinate MI lower bound follows from unconditioned mutual independence and retains the full Section 3.5 signature.
- **C18.05-CONSUMERS:** The XOR strictness, heterogeneous/separate-universe and empty/singleton consumers qualify the actual public family interfaces; any obstacle is explicitly resolved rather than hidden by changed scope.

### C18.06 — Cumulative qualification and maintained handoff

Introduce no new mathematical endpoint. Reassess the C16--C18 package by usable
producer/consumer chains, then reconcile source, canonical/API documentation,
all review dispositions and later-chunk interfaces. Prepare
`docs/handoffs/chunk-18.md` before final capture.

- **C18.06-VALIDATION:** The exact final candidate passes cumulative maintained clean validation, applicable actual API-documentation qualification and semantic inspection, retained/current API, import/root/simp, permanent-consumer and trust checks.
- **C18.06-READINESS:** Before cumulative dispatch, owned edits, contextual self-review, separate reassessment, prior-report reconciliation and justified remaining-work dispositions are complete against every approved criterion.
- **C18.06-HANDOFF:** Canonical context and the maintained C18 handoff accurately record delivered contracts, useful consumers/imports, exact sources/evidence limits, optional dispositions, package usefulness and separate C19/C22/C23 prerequisites.

After readiness, obtain a **fresh** independent cumulative review of all 20
criteria, including the preceding three. Preserve the complete original report,
receive and explicitly reconcile it, correct/renew review when required, validate
final applicability, and close through the supported durable mechanism. A clean
report, readiness checklist or captured prose alone is not closure. Finish all
captured documentation before F, using provisional closure wording and pointing
to the eventual private completion record. No post-F source edit may claim closure.

## 6. Validation and review obligations

For each mathematical step, serialize Lean builds. Run focused producer and
permanent-consumer targets, the full Shannon and Examples aggregates as affected,
static generated/architecture checks, documentation checks as applicable, and
compiled trust/compatibility checks for public API/import growth. Independently
compile focused consumers so the umbrella cannot mask missing imports. Check
actual warning/error diagnostics, source trust rules and conservative attributes.

Update reviewed growth policy and regenerate current public API/website source
artifacts only as authorized by the approved step; preserve frozen manifests.
Applicable commands are the installed validator's `focused`, `static`,
`documentation` and `trust` entries and the documented current generators.
No source-count target or generated inventory substitutes for approval.

C18.06 requires the complete maintained routine on a clean authorized checkpoint,
repeated after every amendment, plus the separate actual two-pass current
file-mode API-doc gate and inspection of all changed signatures, hypotheses,
owners, docstrings and links. Preserve v0.1.0 routes; do not stage or publish a
release. On Windows use the reviewed Zig configuration. Earlier applicable
evidence may inform checks, but does not replace the required fresh cumulative
qualification. Any clean-checkpoint/reuse authority still missing is sought
only after the exact scoped candidate is prepared; never commit pending user
work to satisfy hygiene. Plan approval alone is not checkpoint permission.

Use this actual parent's bound `/root/c18_reviewer`, requested
`gpt-6-astra / ultra / fork_context=false`, through the explicitly bound
collaboration adapter. Effective settings remain unknown. Preserve original
creation, submission and matching native completion results; read-only
instructions are cooperative, not OS isolation. No other chunk's reviewer is
transferred. Initialization itself opened no PLAN/execution session. Formal plan review
is invoked only on explicit request; it does not approve the plan. Each eligible
implementation message follows the installed one-step workflow and then stops.

## 7. Concrete later interfaces and package reassessment

C22 receives the actual objective `mutualInfo (PMF.channelJoint q W)`:
the arbitrary-input product-channel bound supplies its upper product-capacity
argument, and product-input equality supplies the lower argument with coordinate
optimizers. C15 supplies compactness/continuity; C18 defines no capacity.
A permanent generic consumer may assume bounds `∀ r, I(r,W_i) ≤ c_i` and derive
the block objective bound by `∑ i c_i`, without constructing a supremum.

C23 receives the same bound at `q = messageLaw.map encode`, including
noninjective encoders and correlated codewords, specialized to `memorylessChannel`.
Exact C17 source/joint transports connect this law to existing Markov/DPI/Fano
interfaces. C22 will supply the coordinate capacity cap. C18 implements no code,
error, rate or converse definition. C19's product-support/self-information route
remains independently available; it does not wait for new capacity machinery.

C16 contributed 17 public declarations and C17 twelve. Those 29 declarations
are evaluated here by the product-to-entropy/KL, row-to-conditional-entropy,
joint-to-MI and encoded-law-to-bound consumer chains. The roadmap's package
estimates are calibration, never quotas. Record which bridges actually removed
consumer friction, repeated private work, remaining limitations and any justified
future API pressure. Do not pad the package with aliases, topology, total
correlation or redundant block constructors. Preserve Notes 14/31's standing
naming/minimal-API rules and assign every deferred item an owner and trigger.

Earlier PLAN review remains evidence about revision 1. Approval alone starts
no step: each eligible implementation request selects its named step and stops
after its review process. No later step, another chunk or release work starts
automatically.
