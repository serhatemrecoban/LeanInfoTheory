# Chapter 2 Chunk 6: Finite Families And Concrete Entropy Valuations

**Plan status:** Implementation complete; checkpoint pending
**Baseline commit:** `b8012ef6dbcb69b56e8a9e896ba312b5c24b1b60`
**Last fully validated Lean/source checkpoint:** `ec78829707c548e7e1c866ebaafe52c25e910fc4`
**Plan path:** `docs/plans/chapter2-chunk-06.md`
**Number of steps:** 24

The baseline commit is the clean checked-in repository state titled
`Prepare Project B Chunk 6 handoff`. Its parent, `ec788297`, is the completed
and fully validated Chunk 5 Lean/source checkpoint. At plan creation,
`master` and `origin/master` both point to the baseline and the working tree is
clean apart from this new plan.

Twenty-four steps are appropriate because this chunk has four genuinely
different layers:

1. a lightweight dependent finite-family representation and algebraic API;
2. semantic Shannon inequalities and a concrete `ShannonEntropyVal`;
3. checked-certificate adaptation and permanent examples;
4. API review, canonical documentation, generated references, and independent
   final validation.

The high-risk dependent-product and ordered-chain arguments are isolated from
one another. Elementary identities and semantic inequalities are also split
into reviewable steps rather than accumulated into oversized theorem batches.
No later step begins without explicit user approval.

## Chunk Objective

Formalize the finite-family entropy semantics needed both for the remaining
Cover--Thomas Chapter 2 fundamentals and for the existing entropy-certificate
system. The chunk should:

- model a heterogeneous indexed family under one joint PMF;
- assign entropy to each finite set of variable names;
- expose family conditional entropy, mutual information, and conditional
  mutual information;
- connect the family API to the existing pair/triple random-variable API;
- prove binary and ordered finite-family chain rules;
- prove the core Shannon inequalities on finite entropy atoms;
- construct an actual `ShannonEntropyVal` from a joint family law;
- connect checked certificates to that concrete valuation;
- maintain a permanent example that exercises both checked and raw validation
  paths without changing the certificate trust boundary.

## Scope

The accepted semantic representation is:

```text
Var : Type u
[DecidableEq Var]
alpha : Var -> Type v
[forall i, Fintype (alpha i)]
q : PMF (forall i, alpha i)
s : Finset Var
```

The full index type `Var` need not be finite. Every component alphabet has a
`Fintype` instance, but entropy is formed only after restriction to a finite
atom. The implementation must never form `entropy q`, because the full
dependent function type need not be finite.

The primary semantic value of an atom is the entropy of the pushforward of
`q` along `s.restrict`. A source-PMF surface is also in scope:

```text
p : PMF Omega
X : forall i, Omega -> alpha i
```

It first forms the full family law by mapping `omega` to
`fun i => X i omega`, then uses the same finite-marginal semantics.

Ordered chain rules use `List Var`. The primary chain theorems should hold for
all lists, including lists with repeated indices. Repetition is semantically
harmless because a repeated variable contributes zero after it has already
entered the prefix atom. Public `List.Nodup` corollaries should present the
usual textbook enumeration contract.

Subsets are represented by `Finset Var`, exactly matching `EntropyAtom Var`.
Pair/triple compatibility must permit overlapping atoms and repeated
variables; no disjointness assumption is part of the public contract.

## Explicit Non-goals

- A bundled finite-family probability structure.
- A public injective `Fin n -> Var` chain-rule interface.
- A global `[Fintype Var]` assumption.
- Relative-entropy or KL chain rules.
- A binary conditional-mutual-information union chain rule without a real
  downstream consumer.
- Total correlation, interaction information, or multi-information.
- N-variable independence predicates or equality cases for n-way
  subadditivity.
- Product-cardinality entropy bounds or their equality cases.
- Index-relabeling/equivalence infrastructure without demonstrated consumers.
- Topology, continuity, lower semicontinuity, or entropy concavity.
- Coding theorems, capacity, AEP, typicality, or changes to finite Fano.
- New certificate primitives, constraints, search, autotagging, parsers, or
  external import.
- A public family-specific raw-certificate soundness wrapper unless later
  proof pressure justifies a plan revision.
- Any change to `ShannonEntropyVal`, `EntropyExpr`, the checked-certificate
  trust model, or existing theorem statements.
- Any new import from `LeanInfoTheory.lean`.
- A website redesign.

## Relevant Textbook Sections

The local source consulted is:

`info theory e-books/Elements_of_Information_Theory_Elements.pdf`

The exact Cover--Thomas first-edition material relevant to this chunk is:

- Section 2.1, "Entropy", book pp. 12--14, PDF pp. 34--36:
  entropy and nonnegativity.
- Section 2.2, "Joint Entropy and Conditional Entropy", book pp. 15--17,
  PDF pp. 37--39: vector-valued variables and the two-variable chain rule.
- Section 2.3, "Relative Entropy and Mutual Information", book pp. 18--19,
  PDF pp. 40--41: the definition and interpretation of mutual information.
- Section 2.4, "Relationship Between Entropy and Mutual Information",
  book pp. 19--21, PDF pp. 41--43: entropy-difference identities and
  `I(X;X) = H(X)`.
- Section 2.5, "Chain Rules for Entropy, Relative Entropy, and Mutual
  Information", book pp. 21--23, PDF pp. 43--45: Theorems 2.5.1 and 2.5.2
  and the definition of conditional mutual information.
- The relevant consequences in Section 2.6, book pp. 26--28,
  PDF pp. 48--50: MI/CMI nonnegativity, conditioning reduces entropy, and
  the independence bound on joint entropy.

The project uses natural logarithms and therefore nats, while the textbook
defaults to base-two bits. The identities and inequalities in this plan are
base-independent. The textbook writes ordered tuples; the project uses
unordered `Finset` atoms and introduces a list only when a chain order is
mathematically relevant. The project also fixes `H(empty) = 0`.

Relative-entropy statements in Sections 2.3, 2.5, and 2.6 are used only as
textbook context for already established semantic results. Chunk 6 does not
reformalize the KL chain rule.

## Existing Infrastructure

### Verified LeanInfoTheory declarations

The following names have been verified in the current source:

- `entropy`, `entropy_nonneg`, `entropy_pure`;
- `entropy_map_injective`;
- `entropyOf`, `entropyOf_id`, `entropyOf_comp_injective`;
- `jointEntropy`, `jointEntropyOf`, `jointEntropyOf_swap`;
- `condEntropy`, `mutualInfo`, `condMutualInfo`;
- `condEntropyOf`, `mutualInfoOf`, `condMutualInfoOf`;
- `condEntropyOf_eq`, `mutualInfoOf_eq`, `condMutualInfoOf_eq`;
- `mutualInfoOf_eq_entropyOf_sub_condEntropyOf`;
- `condMutualInfoOf_eq_condEntropyOf_sub_condEntropyOf`;
- `entropy_chain_rule_left`, `entropy_chain_rule_right`;
- `jointEntropyOf_chain_rule_left`, `jointEntropyOf_chain_rule_right`;
- `entropyOf_comp_le`;
- `condEntropyOf_nonneg`;
- `mutualInfo_nonneg`;
- `condMutualInfoOf_nonneg`;
- `condEntropyOf_le_entropyOf`;
- `mutualInfoOf_le_entropyOf_left`;
- `mutualInfoOf_le_entropyOf_right`;
- `jointEntropyOf_le_add_entropyOf`;
- `EntropyAtom`, `EntropyExpr`, `EntropyExpr.eval`;
- `ShannonEntropyVal` and its fields `value`, `empty_eq_zero`,
  `cond_nonneg`, and `cmi_nonneg`;
- `ShannonEntropyVal.eval`, `ShannonEntropyVal.eval_atom`;
- `Certificate.CheckedCert.sound`;
- `Certificate.RawCert.sound_of_toCheckedCert?_isSome`;
- `Certificate.Submodularity.checkedCert`;
- `Certificate.Submodularity.rawCert`;
- `Certificate.Submodularity.rawCert_toCheckedCert?_isSome`;
- `Certificate.Submodularity.entropy_submodularity`.

### Verified mathlib declarations and instances

- `PMF.map`, `PMF.map_comp`, `PMF.map_const`;
- `Finset.restrict`, `Finset.restrict₂`;
- `Finset.restrict₂_comp_restrict`;
- `Finset.restrict₂_comp_restrict₂`;
- `Equiv.piUnique`;
- dependent-Pi `Fintype` instances;
- `List.get`, `List.take`, `List.toFinset`;
- `List.toFinset_cons`, `List.toFinset_append`;
- `List.Nodup`;
- `Fin.sum_univ_succ`;
- `Finset.induction`, `Finset.sum_insert`.

No mathlib or LeanInfoTheory declaration already provides the proposed
finite-family entropy layer.

## Mathematical Dependency Overview

```text
full family law and finite restriction
                |
        finite family marginal
                |
           family entropy
       /        |         \
 empty/singleton |       pair/triple union bridges
                 |                 |
                 +-------- family H|, I, I|
                                  |
                 elementary difference and chain identities
                                  |
                      ordered prefix-sum chain rules
                                  |
             existing finite semantic nonnegativity theorems
                     /                       \
          entropy monotonicity          family CMI >= 0
                     \                       /
              derived Shannon inequalities
                                  |
                       concrete ShannonEntropyVal
                                  |
                    CheckedCert concrete semantics
                                  |
                       permanent examples
```

The concrete valuation has the exact field dependency:

```text
empty_eq_zero <- familyEntropy_empty
cond_nonneg   <- familyEntropy_mono for s subset insert i s
cmi_nonneg    <- familyCondMutualInfo_nonneg
```

It must not be proved through a certificate theorem. Certificates consume the
valuation only after those semantic fields have been established.

## API And Module Strategy

### Lightweight family core

Create `LeanInfoTheory/Shannon/FiniteFamily.lean` in namespace
`LeanInfoTheory.Shannon`. It may import:

- `LeanInfoTheory.Shannon.InfoMeasures`;
- the mathlib finite-dependent-function support needed for
  `Finset.restrict` and ordered finite sums.

It owns the representation, marginals, family information measures, pair and
triple compatibility, algebraic identities, and ordered chain rules. It must
not import KL, conditional laws, kernels, `EntropyVal`, certificates, or
examples.

### Semantic family bridge

Create `LeanInfoTheory/Shannon/SemanticBridge/FiniteFamily.lean` in namespace
`LeanInfoTheory.Shannon`. It may import:

- `LeanInfoTheory.Shannon.FiniteFamily`;
- `LeanInfoTheory.Shannon.SemanticBridge.Theorems`;
- `LeanInfoTheory.EntropyVal` when the concrete valuation is added.

It owns family nonnegativity, monotonicity, submodularity, derived Shannon
inequalities, n-way subadditivity, and the concrete valuation. Add this module
to the opt-in `LeanInfoTheory.Shannon.SemanticBridge` aggregate. Do not make
`EntropyVal.lean` import concrete family semantics.

### Certificate adapter

Create `LeanInfoTheory/Certificate/FiniteFamily.lean`. It imports:

- `LeanInfoTheory.Certificate.Checked`;
- `LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily`.

It owns one generic checked-certificate theorem that instantiates
`CheckedCert.sound` with the concrete valuation and returns an inequality under
`EntropyExpr.eval (familyEntropy q)`. Do not import it from
`LeanInfoTheory.Certificate` or `LeanInfoTheory.lean`.

No family-specific raw-certificate wrapper is initially approved. Raw examples
must use the verified generic
`RawCert.sound_of_toCheckedCert?_isSome` theorem.

### Examples

Create `LeanInfoTheory/Examples/FiniteFamily.lean` under
`LeanInfoTheory.Examples.FiniteFamily` and import it from
`LeanInfoTheory/Examples.lean`. It remains outside the root.

### Proposed public surface

Every name in this subsection is tentative until implemented and audited in
`C6.21`. Existing declarations listed above are not tentative.

Core proposed names:

- `FamilyOutcome`;
- `familyLawOf`;
- `familyMarginal`;
- `familyEntropy`, `familyEntropyOf`;
- `familyCondEntropy`, `familyCondEntropyOf`;
- `familyMutualInfo`, `familyMutualInfoOf`;
- `familyCondMutualInfo`, `familyCondMutualInfoOf`;
- `familyEntropyChain`, `familyMutualInfoChain`.

Representative proposed theorem families:

- marginal restriction and source-law projection;
- empty, singleton, and nonnegative family entropy;
- pair/triple union-entropy bridges;
- compatibility with existing `condEntropyOf`, `mutualInfoOf`, and
  `condMutualInfoOf`;
- MI/CMI symmetry and entropy-difference identities;
- binary entropy and MI union chain rules;
- all-list and `Nodup` entropy/MI chain rules;
- family entropy monotonicity and conditional-entropy nonnegativity;
- family CMI nonnegativity and entropy submodularity;
- MI bounds, conditioning-reduces-entropy, and subadditivity;
- `finiteFamilyEntropyVal`, `finiteFamilyEntropyValOf`;
- `Certificate.CheckedCert.sound_finiteFamily`.

The exact theorem spellings are intentionally provisional. Once a declaration
is introduced during the active theorem phase, do not rename it casually.
Record awkward names under Future Work Note 14 and make only
compatibility-preserving alias decisions in `C6.21`.

## Implementation Steps

### C6.01 - Approved Contract Activation And Feasibility Check

**Status:** complete (2026-07-27)

**Implementation outcome:** The recorded baseline
`b8012ef6dbcb69b56e8a9e896ba312b5c24b1b60` was verified against local
`HEAD`, `master`, and `origin/master`. An ignored disposable Lean spike
elaborated the accepted dependent-family signatures and was deleted. It
exercised `Var := Nat` without `[Fintype Nat]`, heterogeneous alphabets
`Fin (i + 1)`, a pure full-family law, empty and singleton atoms, overlapping
pair/triple restrictions, repeated list indices, an empty index type, and a
constructor supplied by the exact three planned `ShannonEntropyVal` theorem
shapes. The spike confirmed two implementation details for later steps:
PMF-map and entropy definitions must be `noncomputable`, and an empty-index
consumer must provide the logically vacuous dependent `Fintype` family
explicitly because typeclass search does not synthesize it automatically.
Neither point changes the approved representation or assumptions. Canonical
project memory now records the approved 24-step plan as active. No production
Lean declaration, source file, import, public name, theorem statement, or
assumption changed.

**Objective:** Record that the representation and plan are approved before
production Lean work, and revalidate the most fragile type-level contracts in
a disposable proof spike.

**Prerequisites:** The repository remains at the recorded baseline or any
newer head has been reconciled explicitly. This approved plan is present.

**Proposed declarations:** None in production.

**Target files and namespaces:** Update the active-plan/status portions of
`docs/project-log.md` and `docs/lean-info-theory-living-summary.md` only when
this step is authorized. Use an ignored disposable Lean file under
`tmp/codex-handoffs/` or another verified ignored location, then delete it.
The spike uses a private test namespace.

**Strategy:**

1. Record that Future Work Note 1's representation gate is discharged and
   that the approved plan is active, without claiming implementation progress.
2. Elaborate the proposed core signatures.
3. Test `Var := Nat`, dependent alphabets such as `Fin (i + 1)`, and a pure
   full-family law without `[Fintype Nat]`.
4. Test an empty index type, an empty atom, singleton restrictions, overlapping
   pair/triple restrictions, and repeated list indices.
5. Check that the exact three `ShannonEntropyVal` fields can be supplied by
   the planned theorem shapes.
6. Delete the spike and retain no production declaration.

**Edge cases:** Infinite `Var`, empty `Var`, dependent alphabets, empty atoms,
repeated indices, proof-dependent subtype coercions, and no entropy of the full
law.

**Focused validation:** Compile the disposable file with `lake env lean`;
run `git diff --check`; verify that only the authorized status prose changed
and no spike remains.

**Definition of done:** The signatures elaborate under the accepted
assumptions, canonical memory says the plan is approved and active, and the
working tree contains no production Lean change.

**Downstream effect:** Authorizes C6.02's representation implementation only
after separate user approval.

**Documentation implications:** This is the early decision/status update
required by the adversarial review. It does not replace final reconciliation
in C6.22.

**Risk and fallback:** If a contract fails to elaborate, stop and explain the
discrepancy before changing this plan. Do not strengthen assumptions silently.

### C6.02 - Core Family Representation

**Status:** complete (2026-07-27)

**Implementation outcome:** Created the opt-in lightweight module
`LeanInfoTheory.Shannon.FiniteFamily` with exactly the five approved public
declarations:

- `FamilyOutcome {Var} (alpha : Var -> Type v) (s : Finset Var)`, an
  abbreviation for `(i : s) -> alpha i`;
- `familyLawOf (p : PMF omega)
  (X : (i : Var) -> omega -> alpha i)`, with no finiteness or decidable-
  equality assumption;
- `familyMarginal (q : PMF ((i : Var) -> alpha i)) (s : Finset Var)`, also
  with no finiteness or decidable-equality assumption;
- `familyEntropy`, requiring only `[DecidableEq Var]` and
  `[forall i, Fintype (alpha i)]`;
- `familyEntropyOf`, with the same two family-side instances and no finiteness
  assumption on the source type `omega`.

The module imports only `Shannon.InfoMeasures`,
`Mathlib.Data.Finset.Pi`, and `Mathlib.Data.Fintype.Pi`. The last import is the
precise owner of the dependent Pi `Fintype` instance; the focused build
identified that it was not supplied by `Data.Finset.Pi` alone.
`lake build LeanInfoTheory.Shannon.FiniteFamily` passed with 2,232 jobs, and
the unchanged lightweight root passed with 2,240 jobs. An ignored direct-
import consumer compiled with `Var := Nat`, alphabets `Fin (i + 1)`, no
`[Fintype Nat]`, an arbitrary source type, and a marginal whose component
alphabets had no finiteness instances. A root-only negative consumer failed
with the expected `unknownIdentifier` for
`LeanInfoTheory.Shannon.FamilyOutcome`. Both consumers were deleted. The
placeholder, import, declaration, naming, scratch-file, and scoped-diff audits
were clean. No name warrants a Future Work Note 14 entry at this stage.

**Objective:** Introduce the accepted unbundled family representation and its
primary entropy functions.

**Prerequisites:** C6.01 is complete.

**Proposed declarations:** Tentatively:

- `FamilyOutcome (alpha : Var -> Type v) (s : Finset Var)`;
- `familyLawOf`;
- `familyMarginal`;
- `familyEntropy`;
- `familyEntropyOf`.

**Target files and namespaces:** Create
`LeanInfoTheory/Shannon/FiniteFamily.lean` in
`LeanInfoTheory.Shannon`.

**Strategy:** Define `FamilyOutcome alpha s` as the dependent function type on
the subtype `s`. Define the marginal by `q.map s.restrict`. Define source laws
by mapping `omega` to `fun i => X i omega`. Define family entropy from the
finite marginal and the `...Of` form through the source family law.

Keep alphabet finiteness off `FamilyOutcome`, `familyLawOf`, and
`familyMarginal`; require it only where entropy needs a finite target.

**Edge cases:** No `[Fintype Var]`; empty `Var`; empty component alphabets make
theorems vacuous when no law exists; source type `Omega` need not be finite.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
```

Also compile a direct-import consumer using `Var := Nat`.

**Definition of done:** All five contracts elaborate with minimal assumptions,
the direct import succeeds, and the root does not expose the new names.

**Downstream effect:** Supplies the semantic object used by every later step.

**Documentation implications:** Record exact implemented signatures in the
step outcome. Add no broad status claim yet.

**Risk and fallback:** Universe and dependent-instance inference may require
explicit binders. Adjust binder presentation only; do not replace the accepted
representation.

### C6.03 - Marginal Restriction Calculus And Congruence

**Status:** complete (2026-07-27)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.FiniteFamily` with exactly five public theorems:

- `familyMarginal_restrict` states that mapping a `t`-marginal along
  `Finset.restrict₂ hst` gives the `s`-marginal whenever `s ⊆ t`;
- `familyMarginal_familyLawOf` identifies the marginal of `familyLawOf p X`
  with `p.map (fun x (i : s) => X i x)`;
- `familyEntropy_eq_entropyOf` rewrites family entropy as
  `entropyOf q s.restrict`;
- `familyEntropyOf_eq_entropyOf` gives the corresponding source-family
  selected-coordinate rewrite;
- `familyEntropyOf_congr` proves equality when two source families agree for
  every source point and every selected coordinate `i : s`, without requiring
  agreement outside `s`.

The two PMF laws require no decidable-equality or finiteness instance. The
entropy laws retain exactly `[DecidableEq Var]` and pointwise alphabet
finiteness. Proofs use `PMF.map_comp`,
`Finset.restrict₂_comp_restrict`, definitional entropy rewrites, and function
extensionality; no cast or proof-witness helper is public.
`lake build LeanInfoTheory.Shannon.FiniteFamily` passed with 2,232 jobs. An
ignored direct-import consumer passed for a twice-restricted marginal, equal
and empty atoms, an arbitrary source type, both entropy rewrites, and source
families that differ outside the selected singleton. A root-only negative
consumer failed with the expected `unknownIdentifier` for
`familyMarginal_restrict`; both consumers were deleted. Declaration,
attribute, placeholder, naming, scratch-file, and scoped-diff audits were
clean. No public name exposes `restrict₂` or private cast machinery, so no
Future Work Note 14 entry is justified.

**Objective:** Make nested restrictions and source-family marginals reusable
without repeated `PMF.map` calculations.

**Prerequisites:** C6.02.

**Proposed declarations:** A focused family containing:

- restriction of `familyMarginal q t` along `s subset t`;
- the marginal of `familyLawOf p X`;
- `familyEntropy` as `entropyOf q s.restrict`;
- the analogous source-family entropy rewrite;
- source congruence when two families agree on the selected atom.

Exact names are tentative.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/FiniteFamily.lean` in
`LeanInfoTheory.Shannon`.

**Strategy:** Use `PMF.map_comp`,
`Finset.restrict₂_comp_restrict`, and function extensionality. Expose the
stable PMF or scalar equality; keep proof-witness transport helpers private.

**Edge cases:** Empty `s`; `s = t`; proof irrelevance for subtype membership;
dependent codomain casts; source families agreeing only on `s`.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
```

Compile a consumer that restricts a finite marginal twice and another that
uses source congruence.

**Definition of done:** Later monotonicity and compatibility proofs can invoke
one named projection law, and no public theorem exposes a private cast helper.

**Downstream effect:** Supports C6.04--C6.07 and the semantic monotonicity
proof.

**Documentation implications:** Note any public name that exposes
`restrict₂` under Future Work Note 14 at the next authorized log update.

**Risk and fallback:** If dependent casts make the source congruence proof
awkward, prove it through equality of selected PMF marginals. Preserve the
approved public congruence contract.

### C6.04 - Empty, Singleton, And Nonnegative Family Entropy

**Status:** complete (2026-07-27)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.FiniteFamily` with the six approved public theorems:

- `familyEntropy_empty` and `familyEntropyOf_empty`;
- `familyEntropy_singleton` and `familyEntropyOf_singleton`;
- `familyEntropy_nonneg` and `familyEntropyOf_nonneg`.

The empty-family proof identifies the empty restriction with a constant map
into an explicitly constructed empty dependent function, then uses
`PMF.map_const` and `entropy_pure`. It requires no inhabitant of any component
alphabet. The singleton proof evaluates the unique selected coordinate and
applies `entropyOf_comp_injective`; its evaluator and injectivity proof are
private and inaccessible under their source names. Source-family forms derive
through `familyLawOf`, and nonnegativity applies `entropy_nonneg` directly to
the finite marginal. This is the entropy-nonnegativity coverage added by the
adversarial plan review.

`lake build LeanInfoTheory.Shannon.FiniteFamily` passed with 2,232 jobs. An
ignored consumer passed for an actually constructed empty-index law with an
explicit vacuous dependent `Fintype` family, heterogeneous alphabets
`Fin (i + 1)`, singleton alphabets, arbitrary source types and support, and a
formally empty component family supplied only as a hypothetical PMF argument.
Root-only and direct-import private-name consumers both failed with the
expected `unknownIdentifier`; all three consumers were deleted. Declaration,
private-helper, attribute, import, placeholder, naming, scratch-file, and
scoped-diff audits were clean. No support, nonempty, or `[Fintype Var]`
assumption was introduced, and no Future Work Note 14 entry is justified.

**Objective:** Establish the base cases and recover ordinary one-variable
entropy.

**Prerequisites:** C6.02--C6.03.

**Proposed declarations:** Tentatively:

- `familyEntropy_empty`;
- `familyEntropyOf_empty`;
- `familyEntropy_singleton`;
- `familyEntropyOf_singleton`;
- `familyEntropy_nonneg`;
- `familyEntropyOf_nonneg`.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/FiniteFamily.lean` in
`LeanInfoTheory.Shannon`.

**Strategy:** Treat the empty restriction as a constant map into a unique
dependent function and use `PMF.map_const` and `entropy_pure`. For a singleton,
evaluate the unique selected coordinate and use
`entropyOf_comp_injective`. Obtain nonnegativity directly from
`entropy_nonneg` on the finite marginal.

**Edge cases:** Empty index types, singleton alphabets, formally empty
component alphabets, and source PMFs with arbitrary support.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
```

Compile empty-index, singleton, and heterogeneous-alphabet consumers.

**Definition of done:** `H(empty) = 0`, `H({i}) = H(X_i)`, and `0 <= H(s)`
are available on PMF and source-family surfaces without nonempty or support
hypotheses.

**Downstream effect:** Supplies chain-rule base cases, semantic valuation
`empty_eq_zero`, and basic Chapter 2 coverage.

**Documentation implications:** Record that entropy nonnegativity was added
after adversarial review.

**Risk and fallback:** If singleton evaluation through an injective function
is cast-heavy, use a private explicit equivalence. Do not expose the
equivalence without another consumer.

### C6.05 - Pair And Triple Union-Entropy Bridges

**Status:** complete (2026-07-27)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.FiniteFamily` with four public union-entropy bridges:

- `familyEntropy_union` and `familyEntropyOf_union`, identifying entropy on
  `a ∪ b` with the joint entropy of the two restrictions;
- `familyEntropy_tripleUnion` and `familyEntropyOf_tripleUnion`, identifying
  entropy on `a ∪ b ∪ c` with entropy of the right-associated triple of
  restrictions.

The source-family counterparts were included because they give C6.07 the same
direct bridge surface as the full-family PMF API. The proofs use private
`splitUnion` and `splitTripleUnion` maps, prove global injectivity by dependent
function extensionality and membership case analysis, and apply
`entropyOf_comp_injective`. An explicit subtype coercion in the source-family
union binders avoids parsing a Finset union as a type-level union; it does not
change either theorem contract.

`lake build LeanInfoTheory.Shannon.FiniteFamily` passed with 2,232 jobs. An
ignored direct-import consumer passed for dependent heterogeneous alphabets
`Fin (i + 1)`, disjoint, nested, equal, partially overlapping, and empty atoms,
both PMF and source-family forms, and the required right-associated triple.
A root-only negative consumer and a direct-import private-name consumer failed
with the expected `unknownIdentifier` diagnostics; all consumers were deleted.
Import, declaration, helper-visibility, attribute, placeholder, naming, and
scratch-file audits were clean. The bridges require no disjointness, support,
nonempty, or `[Fintype Var]` assumption. Their names are concise and
mathematical, so no Future Work Note 14 entry is justified.

**Objective:** Relate the atom-native family entropy to the established
right-associated pair/triple random-variable API.

**Prerequisites:** C6.03--C6.04.

**Proposed declarations:** Conceptual theorems identifying:

- the joint entropy of restrictions to `a` and `b` with
  `familyEntropy q (a union b)`;
- the entropy of the right-associated triple restriction with
  `familyEntropy q (a union b union c)`;
- source-family counterparts when they materially simplify C6.07.

Exact theorem names are tentative and should lead with the mathematical union
identity rather than a private split-map name.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/FiniteFamily.lean` in
`LeanInfoTheory.Shannon`. Restriction-splitting helpers remain private.

**Strategy:** Map an outcome on the union to the pair or right-associated
triple of restrictions. Prove this map globally injective by extensionality:
each coordinate belongs to at least one component. Apply
`entropyOf_comp_injective`.

**Edge cases:** Arbitrary overlaps, equal atoms, empty components, repeated
indices, right-associated products, and no support restriction.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
```

Compile consumers for disjoint, nested, equal, and partially overlapping
atoms.

**Definition of done:** Both bridges compile with no disjointness, support,
or `[Fintype Var]` hypothesis, and private split helpers are not public.

**Downstream effect:** Enables C6.07's exact compatibility with existing H|,
I, and I| definitions.

**Documentation implications:** Audit any long bridge names under the public
naming policy after their first consumers.

**Risk and fallback:** Dependent subtype equality is high risk. If the direct
injection is brittle, partition unions privately using set difference while
preserving the same public theorem statements.

### C6.06 - Family Conditional Entropy, MI, And CMI Definitions

**Status:** complete (2026-07-27)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.FiniteFamily` with the six approved algebraic
definitions:

- `familyCondEntropy` and `familyCondEntropyOf`;
- `familyMutualInfo` and `familyMutualInfoOf`;
- `familyCondMutualInfo` and `familyCondMutualInfoOf`.

The PMF-facing definitions use exactly

```text
H(A | B)   = H(A ∪ B) - H(B)
I(A ; B)   = H(A) + H(B) - H(A ∪ B)
I(A ; B|C) = H(A ∪ C) + H(B ∪ C)
             - H((A ∪ B) ∪ C) - H(C).
```

Thus the three-way union has the same left-associated normalization as the
C6.05 triple bridge. Each source-family definition is definitionally the
corresponding PMF form on `familyLawOf p X`, so the module retains one semantic
normal form.

`lake build LeanInfoTheory.Shannon.FiniteFamily` passed with 2,232 jobs. An
ignored direct-import consumer verified all six expansions by `rfl` with
dependent heterogeneous alphabets `Fin (i + 1)`, overlapping and repeated
atoms, an empty atom, and an arbitrary source type without a finiteness
instance. A root-only consumer failed with the expected `unknownIdentifier`
diagnostics for the three PMF definitions; both consumers were deleted.
Imports remain limited to `Shannon.InfoMeasures` and the two finite dependent-
Pi modules. Declaration, attribute, placeholder, naming, root-isolation, and
scratch-file audits were clean. The definitions require no support,
disjointness, nonempty, or `[Fintype Var]` assumption, and the established
PMF/`...Of` names need no Future Work Note 14 entry.

**Objective:** Introduce the full algebraic finite-family information-measure
surface.

**Prerequisites:** C6.02.

**Proposed declarations:**

- `familyCondEntropy`, `familyCondEntropyOf`;
- `familyMutualInfo`, `familyMutualInfoOf`;
- `familyCondMutualInfo`, `familyCondMutualInfoOf`.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/FiniteFamily.lean` in
`LeanInfoTheory.Shannon`.

**Strategy:** Define:

```text
H(A | B)   = H(A union B) - H(B)
I(A ; B)   = H(A) + H(B) - H(A union B)
I(A ; B|C) = H(A union C) + H(B union C)
             - H(A union B union C) - H(C)
```

Define source wrappers through `familyLawOf` so there is only one semantic
normal form.

**Edge cases:** Empty and overlapping atoms, repeated variables, union
association, and source PMFs on non-finite types.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
```

Check definitional expansions in a direct consumer.

**Definition of done:** All six definitions compile in the lightweight module
without semantic, KL, or certificate imports.

**Downstream effect:** Supplies the main API for C6.07 onward.

**Documentation implications:** Record the exact union normalization chosen.

**Risk and fallback:** None beyond correcting union association before
downstream theorem work; do not introduce alternative definitions.

### C6.07 - Compatibility With Existing Pair/Triple Measures

**Status:** complete (2026-07-27)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.FiniteFamily` with twelve public compatibility
theorems. The six general bridges are:

- `familyCondEntropy_eq_condEntropyOf` and
  `familyCondEntropyOf_eq_condEntropyOf`;
- `familyMutualInfo_eq_mutualInfoOf` and
  `familyMutualInfoOf_eq_mutualInfoOf`;
- `familyCondMutualInfo_eq_condMutualInfoOf` and
  `familyCondMutualInfoOf_eq_condMutualInfoOf`.

They identify each family measure with the established ordinary `...Of`
measure on the corresponding finite restriction-valued random variables. The
six ordinary-coordinate corollaries are:

- `familyCondEntropy_singletons` and
  `familyCondEntropyOf_singletons`;
- `familyMutualInfo_singletons` and
  `familyMutualInfoOf_singletons`;
- `familyCondMutualInfo_singletons` and
  `familyCondMutualInfoOf_singletons`.

The PMF bridge proofs expand `condEntropyOf_eq`, `mutualInfoOf_eq`, and
`condMutualInfoOf_eq`, rewrite joint entropies through C6.05, and use `ring`
only for the differing subtraction order in the CMI normal forms. Source
bridges derive uniformly through `familyLawOf` and `PMF.map_comp`. Singleton
corollaries use the existing singleton-entropy result plus two private
injective relabeling lemmas for pairs and right-associated triples. No
singleton-specific helper was exposed publicly.

`lake build LeanInfoTheory.Shannon.FiniteFamily` passed with 2,232 jobs. An
ignored direct-import consumer exercised all twelve declarations with
dependent heterogeneous alphabets `Fin (i + 1)`, overlapping atoms, equal and
repeated indices, an empty conditioning atom, arbitrary source types, and the
right-associated triple convention. Root-only and private-helper consumers
failed with the expected `unknownIdentifier` diagnostics; all consumers were
deleted. Imports, assumptions, attributes, placeholders, helper visibility,
root isolation, and scratch-file audits were clean. No support, disjointness,
nonempty, source-finiteness, or `[Fintype Var]` assumption was added.

The bridge direction consistently rewrites family measures to the established
`...Of` API. The name
`familyCondMutualInfoOf_eq_condMutualInfoOf` is long but predictable, preserves
the PMF/source distinction, and exposes no implementation detail. Preserve it
during active theorem work and reconsider discoverability with production
consumers in C6.21; add no alias now and carry the decision into C6.22's Future
Work Note 14 reconciliation.

**Objective:** Prove that the new family definitions are not a parallel,
incompatible information theory.

**Prerequisites:** C6.05--C6.06.

**Proposed declarations:** PMF and source-family bridge theorems from:

- `familyCondEntropy` to `condEntropyOf` on two restrictions;
- `familyMutualInfo` to `mutualInfoOf`;
- `familyCondMutualInfo` to `condMutualInfoOf`;
- singleton-atom forms to existing ordinary random variables.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/FiniteFamily.lean` in
`LeanInfoTheory.Shannon`.

**Strategy:** Expand the existing algebraic definitions using
`condEntropyOf_eq`, `mutualInfoOf_eq`, and `condMutualInfoOf_eq`; rewrite pair
and triple joint entropies through C6.05; normalize Finset unions.

**Edge cases:** Equal variables, overlapping atoms, empty conditioning atoms,
and right-associated triples.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
```

Compile consumers recovering existing H|, I, and I| for ordinary variables,
including a repeated-index case.

**Definition of done:** Every new information measure has a verified bridge to
the existing API, with no stronger assumption than the underlying entropy
requires.

**Downstream effect:** Allows semantic results to be reused rather than
reproved analytically.

**Documentation implications:** Record bridge direction and naming pressure;
do not add aliases yet.

**Risk and fallback:** Prove the full-family PMF bridge first and derive source
forms uniformly through `familyLawOf`.

### C6.08 - Elementary Family Information Identities

**Status:** complete (2026-07-27)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.FiniteFamily` with a controlled fourteen-theorem
elementary identity surface.

The PMF/source symmetry pairs are:

- `familyMutualInfo_swap` and `familyMutualInfoOf_swap`;
- `familyCondMutualInfo_swap` and `familyCondMutualInfoOf_swap`.

The five PMF-facing empty-atom reductions are:

- `familyCondEntropy_empty_right`, giving `H(A | ∅) = H(A)`;
- `familyCondEntropy_empty_left`, giving `H(∅ | B) = 0`;
- `familyMutualInfo_empty_right`, giving `I(A;∅) = 0`;
- `familyCondMutualInfo_empty_right`, giving `I(A;∅|C) = 0`;
- `familyCondMutualInfo_empty_conditioning`, giving
  `I(A;B|∅) = I(A;B)`.

The remaining declarations are `familyMutualInfo_self` and PMF/source forms of
the two approved entropy-difference identities:

- `familyMutualInfo_eq_entropy_sub_condEntropy` and
  `familyMutualInfoOf_eq_entropyOf_sub_condEntropyOf`;
- `familyCondMutualInfo_eq_condEntropy_sub_condEntropy` and
  `familyCondMutualInfoOf_eq_condEntropyOf_sub_condEntropyOf`.

Proofs unfold only the algebraic family definitions, normalize finite unions,
and use real-ring arithmetic. Source corollaries reduce uniformly through
`familyLawOf`. No private helper, reverse entropy-difference orientation,
source-specific empty duplication, binary CMI union chain rule, or simp
attribute was added. Left-empty MI and CMI forms were deliberately omitted:
an ignored consumer derived each in two explicit rewrites from symmetry and
the corresponding right-empty theorem.

`lake build LeanInfoTheory.Shannon.FiniteFamily` passed with 2,232 jobs. An
ignored direct-import consumer used every new declaration as an explicit
rewrite with dependent heterogeneous alphabets `Fin (i + 1)`, overlapping,
equal, and empty atoms, and arbitrary source types. The separate derived-form
consumer also passed. A root-only consumer failed with the expected
`unknownIdentifier` diagnostics; all consumers were deleted. Import,
declaration, assumption, attribute, placeholder, root-isolation, and scratch-
file audits were clean.

The four entropy-difference names, especially
`familyCondMutualInfoOf_eq_condEntropyOf_sub_condEntropyOf`, are long but
consistent with the established ordinary `...Of` family and expose no
implementation detail. Preserve them during active theorem work, add no alias
now, and carry their discoverability review into C6.21 and C6.22's Future Work
Note 14 reconciliation.

**Objective:** Provide the small representation-independent identities needed
for theorem discovery and later inequalities.

**Prerequisites:** C6.04 and C6.06--C6.07.

**Proposed declarations:** A controlled family including:

- symmetry of family MI and family CMI;
- empty-atom reductions;
- `I(A;A) = H(A)`;
- `I(A;B) = H(A) - H(A|B)`;
- `I(A;B|C) = H(A|C) - H(A|B union C)`;
- source-family corollaries for both symmetry families and both
  entropy-difference identities.

Do not add the binary CMI union chain rule.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/FiniteFamily.lean` in
`LeanInfoTheory.Shannon`.

**Strategy:** Use the algebraic definitions, `familyEntropy_empty`, Finset
union laws, and `ring`. Prefer one canonical orientation plus symmetry rather
than duplicating every algebraic direction.

**Edge cases:** Empty/equal/overlapping atoms and union normalization.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
```

Run explicit-rewrite consumers for each proposed normal form.

**Definition of done:** The principal entropy-difference identities are
discoverable and no non-reducing identity is added to global simp.

**Downstream effect:** Supports C6.09 and the derived inequality steps.

**Documentation implications:** Add awkward names to the future naming audit,
but preserve them through active theorem work.

**Risk and fallback:** If a symmetric `...Of` orientation has no consumer,
retain only the canonical theorem and explicit argument swapping.

### C6.09 - Binary Set Chain Rules

**Status:** complete (2026-07-27)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.FiniteFamily` with the six approved binary chain rules:

- `familyEntropy_union_chain_rule_right` and
  `familyEntropyOf_union_chain_rule_right`, stating
  `H(A ∪ B) = H(B) + H(A | B)`;
- `familyEntropy_union_chain_rule_left` and
  `familyEntropyOf_union_chain_rule_left`, stating
  `H(A ∪ B) = H(A) + H(B | A)`;
- `familyMutualInfo_union_chain_rule` and
  `familyMutualInfoOf_union_chain_rule`, stating
  `I(A ∪ B; C) = I(A; C) + I(B; C | A)`.

The entropy rules are direct algebraic consequences of
`familyCondEntropy`. The MI rule expands H/I/I|, uses a local equality
normalizing `(B ∪ C) ∪ A` to `(A ∪ B) ∪ C`, and closes by real-ring
arithmetic. This local normalization did not justify a private or public helper.
All source-family forms reduce uniformly through `familyLawOf`.

`lake build LeanInfoTheory.Shannon.FiniteFamily` passed with 2,232 jobs. An
ignored direct-import consumer exercised both entropy orientations and MI
telescoping with dependent heterogeneous alphabets `Fin (i + 1)`, partially
overlapping, equal, and empty atoms, and arbitrary source types. A root-only
consumer failed with the expected `unknownIdentifier` diagnostics; both
consumers were deleted. Import, declaration, assumption, attribute,
placeholder, root-isolation, and scratch-file audits were clean. No
disjointness, freshness, support, nonempty, source-finiteness, or
`[Fintype Var]` assumption was introduced.

All six declarations remain explicit rewrites. Their successful consumers
provide additional evidence for Future Work Note 16's existing decision not to
choose an automatic entropy-expanded normal form. Preserve the no-`[simp]`
policy through active work and carry this evidence into C6.21 and C6.22. The
left/right names match the established textbook-facing pair chain-rule
vocabulary and expose no representation detail, so no separate Future Work
Note 14 entry is needed at this stage. The deferred conditional-MI union chain
rule was not added.

**Objective:** Establish the binary algebraic recurrence used by ordered
chains.

**Prerequisites:** C6.06 and C6.08.

**Proposed declarations:**

- left and right family entropy union chain rules;
- the MI union chain rule
  `I(A union B; C) = I(A;C) + I(B;C|A)`;
- source-family counterparts for all three rules.

The conditional-MI union chain rule remains deferred.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/FiniteFamily.lean`.

**Strategy:** Prove entropy rules directly from `familyCondEntropy`. Prove the
MI rule by expanding H/I/I| and normalizing unions and real arithmetic.

**Edge cases:** Empty/equal/overlapping atoms; no disjointness or freshness
hypothesis.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
```

Test both entropy orientations and MI telescoping on overlapping atoms.

**Definition of done:** C6.11 and C6.12 can telescope using named binary
identities, and all chain rules remain explicit rather than `[simp]`.

**Downstream effect:** Supplies the inductive engine for ordered chains.

**Documentation implications:** This step is a Future Work Note 16
chain-rule simp-policy input.

**Risk and fallback:** If direct ring normalization is fragile, use short
intermediate entropy equalities privately without publishing a new theorem
family.

### C6.10 - Ordered Prefix-Sum Definitions

**Status:** complete (2026-07-27)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.FiniteFamily` with exactly the two approved public
ordered-prefix definitions:

- `familyEntropyChain q l`, defined as
  `∑ k : Fin l.length, familyCondEntropy q {l.get k}
    (l.take k).toFinset`;
- `familyMutualInfoChain q l b`, defined as
  `∑ k : Fin l.length, familyCondMutualInfo q {l.get k} b
    (l.take k).toFinset`.

The public representation is the direct textbook finite sum. It uses the
position type `Fin l.length`, `List.get` for the current variable, and
`List.take` followed by `List.toFinset` for the preceding atom. No recursive
accumulator, `List.Nodup` hypothesis, source-specific duplicate, or global
finiteness assumption was introduced. The module section comment records that
lists may repeat variable names and that later chain theorems account for their
contributions.

`lake build LeanInfoTheory.Shannon.FiniteFamily` passed with 2,232 jobs. An
ignored direct-import consumer unfolded both definitions on `[]`, `[i]`,
`[i,j]`, and `[i,i]`; all eight expected prefix-sum formulas simplified
exactly, including the duplicate prefix `{i}`. A root-only consumer failed with
the expected `unknownIdentifier` diagnostics; both consumers were deleted.
Imports, declarations, assumptions, attributes, placeholders, root isolation,
and scratch-file audits were clean. The definitions work with dependent
heterogeneous alphabets `Fin (i + 1)` and require neither `[Fintype Var]` nor
`List.Nodup`.

Both names are the concise mathematical names approved by the plan and expose
no accumulator or coercion detail, so no Future Work Note 14 entry or other
future-work addition is justified.

**Objective:** Give the accepted list interface a textbook-readable
right-hand side.

**Prerequisites:** C6.06 and C6.09.

**Proposed declarations:**

- `familyEntropyChain q l`;
- `familyMutualInfoChain q l b`.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/FiniteFamily.lean`.

**Strategy:** Define:

```text
familyEntropyChain q l =
  sum k : Fin l.length,
    H({l[k]} | (l.take k).toFinset)

familyMutualInfoChain q l b =
  sum k : Fin l.length,
    I({l[k]}; b | (l.take k).toFinset)
```

The definitions are total for every list. A private recursive accumulator may
be used for proofs but must not replace this public mathematical presentation.

**Edge cases:** Empty and singleton lists, duplicate indices, coercion from
`Fin l.length` to `Nat`, and prefix-to-Finset conversion.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
```

Check the definitions on `[]`, `[i]`, `[i,j]`, and `[i,i]`.

**Definition of done:** Both definitions compile and unfold to the intended
prefix sums without requiring `List.Nodup`.

**Downstream effect:** Fixes the statement target for C6.11--C6.12.

**Documentation implications:** Explain in the module section comment that
duplicate indices are allowed and later contributions vanish by theorem.

**Risk and fallback:** If direct finite-index induction is unwieldy, prove an
equivalence with a private `(seen,total)` accumulator.

### C6.11 - Ordered Entropy Chain Rule

**Status:** complete (2026-07-27)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.FiniteFamily` with the duplicate-tolerant all-list
theorems `familyEntropy_eq_entropyChain` and
`familyEntropyOf_eq_entropyChain`, together with the direct finite-sum
textbook corollaries `familyEntropy_chain_rule_of_nodup` and
`familyEntropyOf_chain_rule_of_nodup`. The primary theorems require no
`List.Nodup` assumption; the latter two retain that assumption only to expose
the familiar distinct-variable textbook surface.

The proof uses a private recursive accumulator parameterized by the already
seen atom. One private induction identifies the public `Fin l.length`
prefix-sum definition with that accumulator, and a second telescopes entropy
over `s ∪ l.toFinset` using
`familyEntropy_union_chain_rule_left`. Specializing to the empty atom and
using `familyEntropy_empty` gives the public PMF theorem; all other public
forms are corollaries. Repeated names are handled by finite-set idempotence,
with no freshness assumption and no global `Fintype Var`.

`lake build LeanInfoTheory.Shannon.FiniteFamily` passed with 2,232 jobs. An
ignored direct-import consumer compiled the all-list theorem at list lengths
zero, one, and three, the repeated list `[i,i]`, the source-family surface, and
both `Nodup` corollaries over the infinite index type `Nat` with heterogeneous
alphabets `Fin (i + 1)`. Guarded negative consumers confirmed that the four new
public declarations remain absent from `import LeanInfoTheory` and that all
four recursive proof declarations are private; the disposable consumers were
deleted. Imports and simp attributes are unchanged, no placeholder or new
assumption was introduced, and the public names are concise and
representation-independent enough not to require a Future Work Note 14 entry.

**Objective:** Formalize Cover--Thomas Theorem 2.5.1 for named finite
families.

**Prerequisites:** C6.04 and C6.09--C6.10.

**Proposed declarations:**

- a primary all-list theorem equating
  `familyEntropy q l.toFinset` with `familyEntropyChain q l`;
- a source-family version;
- public `List.Nodup` textbook corollaries.

Exact names are tentative.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/FiniteFamily.lean`.

**Strategy:** Telescope successive prefix atoms using C6.09. Prove the
duplicate-tolerant result directly or through a private accumulator. Derive
the `Nodup` theorem without making its assumption part of the stronger primary
contract.

**Edge cases:** Empty list, singleton list, repeated indices, heterogeneous
alphabets, and no global finite index type.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
```

Compile 0-, 1-, 3-variable, repeated-index, and source-family consumers.

**Definition of done:** Both all-list and textbook `Nodup` surfaces compile,
and repeated indices require no false freshness assumption.

**Downstream effect:** Supplies the entropy half of the Chapter 2
finite-family chain layer and supports n-way subadditivity.

**Documentation implications:** State clearly which theorem is stronger and
which is the textbook-facing corollary.

**Risk and fallback:** Keep recursive proof machinery private. If the all-list
contract unexpectedly fails, stop for plan review rather than adding
`Nodup` silently.

### C6.12 - Ordered Mutual-Information Chain Rule And Core Checkpoint

**Status:** complete (2026-07-27)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.FiniteFamily` with the duplicate-tolerant all-list
theorems `familyMutualInfo_eq_mutualInfoChain` and
`familyMutualInfoOf_eq_mutualInfoChain`, together with the explicit finite-sum
textbook corollaries `familyMutualInfo_chain_rule_of_nodup` and
`familyMutualInfoOf_chain_rule_of_nodup`. The primary theorems permit repeated
list indices and arbitrary overlap with the comparison atom `b`; only the
textbook surfaces carry `List.Nodup`.

The proof uses a private recursive accumulator parameterized by the comparison
atom and the already-seen atom. One induction identifies the public
`Fin l.length` prefix sum with that accumulator, and a second telescopes
`familyMutualInfo q (s ∪ l.toFinset) b` through
`familyMutualInfo_union_chain_rule`. Mutual-information symmetry and
`familyMutualInfo_empty_right` discharge the empty initial atom. The source and
`Nodup` forms are direct corollaries. No public helper, `Fin n` interface,
freshness, disjointness, support, nonempty, or `[Fintype Var]` assumption was
introduced.

`lake build LeanInfoTheory.Shannon.FiniteFamily` passed with 2,232 jobs, and
`lake build LeanInfoTheory` passed with 2,240 jobs. A direct-import consumer
resolved all 68 public declarations in the completed C6.02--C6.12 core.
Separate consumers compiled the new theorem family over the infinite index
type `Nat` with heterogeneous alphabets `Fin (i + 1)`, repeated names,
overlapping comparison atoms, `b = ∅`, arbitrary source types, and an actually
empty index type. Guarded negative consumers confirmed that representative
family declarations remain absent from the lightweight root and that all eight
ordered-chain accumulator declarations are private. All disposable consumers
were deleted. Axiom inspection of all four new public declarations reported
only `propext`, `Classical.choice`, and `Quot.sound`. Imports, public
attributes, assumptions, placeholders, root isolation, and scratch-file
hygiene were clean.

The approved project-log checkpoint records the frozen lightweight surface.
Future Work Note 14 now records the complete 68-name audit: the ordered chain
names require no watch entry, while the already identified compatibility-
bridge and entropy-difference groups remain `watching` for C6.21 and C6.22.
No declaration was renamed and no compatibility alias was added.

**Objective:** Formalize Cover--Thomas Theorem 2.5.2 and validate the complete
lightweight family core.

**Prerequisites:** C6.07 and C6.09--C6.11.

**Proposed declarations:**

- a primary all-list theorem
  `I(l.toFinset;b) = familyMutualInfoChain q l b`;
- a source-family version;
- public `List.Nodup` textbook corollaries.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/FiniteFamily.lean`.

**Strategy:** Telescope `I(prefix;b)` with the binary MI chain rule. Permit
overlap between `b` and the list atom. Then audit the full core declarations,
imports, attributes, and theorem statements.

**Edge cases:** Empty list, duplicate indices, `b = empty`, overlap between
`b` and prefixes, and infinite `Var`.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily
```

Also run:

- a positive direct-import consumer covering all core declaration families;
- an infinite-index dependent-alphabet consumer;
- an empty-index consumer;
- a guarded negative consumer showing `import LeanInfoTheory` does not expose
  the family API.

**Definition of done:** Both all-list and `Nodup` MI chain surfaces compile,
all lightweight core APIs are directly importable, and root isolation holds.

**Downstream effect:** Freezes the lightweight dependency surface consumed by
the semantic layer.

**Documentation implications:** Add a meaningful project-log checkpoint and
audit all C6.02--C6.12 names under Future Work Note 14.

**Risk and fallback:** Derive through repeated binary chain applications if
direct prefix-sum algebra becomes opaque. Do not introduce a `Fin n` surface.

### C6.13 - Family Entropy Monotonicity And Conditional Nonnegativity

**Status:** complete (2026-07-27)

**Implementation outcome:** Created the separately importable semantic module
`LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` and added it to the
existing semantic aggregate only after its focused build passed. The module
contains exactly the four approved public theorems:

- `familyEntropy_mono`;
- `familyEntropyOf_mono`;
- `familyCondEntropy_nonneg`;
- `familyCondEntropyOf_nonneg`.

For `s ⊆ t`, the PMF monotonicity proof changes the goal to entropy of the two
finite marginal laws, rewrites the smaller law through
`familyMarginal_restrict`, and applies `entropy_map_le` to the deterministic
restriction map from the `t`-outcomes to the `s`-outcomes. It never forms
`entropy q` for the potentially infinite full-family law. Source monotonicity
specializes this result to `familyLawOf p X`; both conditional-entropy
nonnegativity theorems use `b ⊆ a ∪ b` and the algebraic definition of
`familyCondEntropy`.

`lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` passed with
2,700 jobs, and `lake build LeanInfoTheory.Shannon.SemanticBridge` passed with
2,751 jobs after aggregate integration. An ignored direct-import consumer
compiled with `Var := Nat`, heterogeneous alphabets `Fin (i + 1)`, nested,
equal, empty, and overlapping atoms, and an arbitrary source type. Guarded
negative consumers confirmed that the four semantic declarations remain
absent from both `import LeanInfoTheory` and the lightweight
`import LeanInfoTheory.Shannon.FiniteFamily`; all disposable files were
deleted. Axiom inspection reported only `propext`, `Classical.choice`, and
`Quot.sound`. No support, injectivity, nonempty, source-finiteness, or global
`[Fintype Var]` assumption was introduced.

The focused module imports only the lightweight finite-family core and
`SemanticBridge.Theorems`, the exact owner of `entropy_map_le`. The new
theorems have no `[simp]` attributes, expose no restriction implementation
detail, and are concise enough not to require a Future Work Note 14 entry.
No canonical project-memory document changed in this step.

**Objective:** Prove the first semantic Shannon property needed by
`ShannonEntropyVal`.

**Prerequisites:** C6.03, C6.06, and the C6.12 core checkpoint.

**Proposed declarations:**

- `familyEntropy_mono`;
- `familyEntropyOf_mono`;
- `familyCondEntropy_nonneg`;
- `familyCondEntropyOf_nonneg`.

**Target files and namespaces:** Create
`LeanInfoTheory/Shannon/SemanticBridge/FiniteFamily.lean` in
`LeanInfoTheory.Shannon`; add it to the semantic aggregate only after its
module compiles.

**Strategy:** For `s subset t`, view the smaller finite marginal as the
deterministic restriction of the larger finite marginal. Apply
`entropy_map_le` to `familyMarginal q t`, or equivalently apply
`entropyOf_comp_le` with the full law only as the unrestricted source. Never
apply finite entropy directly to the full law. Derive H| nonnegativity from
monotonicity.

**Edge cases:** Empty and equal atoms, infinite `Var`, dependent alphabets,
and no support assumptions.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily
lake build LeanInfoTheory.Shannon.SemanticBridge
```

Compile an infinite-index monotonicity consumer.

**Definition of done:** Monotonicity and H| nonnegativity compile with no
`[Fintype Var]`, support, injectivity, or nonempty hypothesis.

**Downstream effect:** Supplies `ShannonEntropyVal.cond_nonneg` and several
derived inequalities.

**Documentation implications:** Record the finite-marginal proof route so no
later refactor accidentally forms `entropy q`.

**Risk and fallback:** If marginal rewriting is brittle, use
`entropyOf_comp_le` directly. Do not strengthen the theorem.

### C6.14 - Family CMI Nonnegativity And Submodularity

**Status:** complete (2026-07-27)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` with exactly the four
approved public theorems:

- `familyCondMutualInfo_nonneg`;
- `familyCondMutualInfoOf_nonneg`;
- `familyEntropy_submodular`;
- `familyEntropyOf_submodular`.

The PMF CMI theorem rewrites through
`familyCondMutualInfo_eq_condMutualInfoOf` and applies the established
`condMutualInfoOf_nonneg` theorem to the three finite restriction-valued
variables. The source theorem is definitionally the PMF theorem on
`familyLawOf p X`, so its proof uses direct elaboration rather than a broad
simplifier call.

Submodularity is stated in the exact abstract/certificate form

```text
0 <= H(A) + H(B) - H(A union B) - H(A inter B).
```

It specializes family CMI nonnegativity to conditioning atom `A ∩ B`. Three
local finite-set equalities normalize `A ∪ (A ∩ B)`, `B ∪ (A ∩ B)`, and
`(A ∪ B) ∪ (A ∩ B)`; no helper declaration is introduced. This is exactly the
four-entropy expression used by `ShannonEntropyVal.cmi_nonneg` and
`Certificate.Submodularity.entropy_submodularity`, without importing either
abstract certificate module into the semantic family module.

`lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` passed with
2,700 jobs, and `lake build LeanInfoTheory.Shannon.SemanticBridge` passed with
2,751 jobs. An ignored infinite-index, dependent-alphabet consumer compiled
the expanded CMI expression and PMF/source submodularity for equal, nested,
disjoint, and partially overlapping atoms, including an empty intersection.
Guarded negative consumers confirmed that the four declarations remain absent
from both the lightweight root and `Shannon.FiniteFamily`; all disposable
files were deleted. Axiom inspection reported only `propext`,
`Classical.choice`, and `Quot.sound`.

No conditional-fiber, support, disjointness, nonempty, source-finiteness, or
global `[Fintype Var]` assumption was added. The four names are concise and
mathematical, expose no normalization helper, carry no `[simp]` attribute, and
need no Future Work Note 14 entry. No canonical project-memory document changed
in this step.

**Objective:** Prove the second semantic Shannon property needed by
`ShannonEntropyVal` and the central polymatroid inequality.

**Prerequisites:** C6.07 and C6.13.

**Proposed declarations:**

- `familyCondMutualInfo_nonneg`;
- `familyCondMutualInfoOf_nonneg`;
- `familyEntropy_submodular`;
- `familyEntropyOf_submodular`.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/SemanticBridge/FiniteFamily.lean`.

**Strategy:** Rewrite family CMI as existing `condMutualInfoOf` on three
restrictions and apply `condMutualInfoOf_nonneg`. Obtain submodularity by
specializing CMI to conditioning atom `a inter b` and normalizing unions.

**Edge cases:** Equal, nested, disjoint, and partially overlapping atoms;
empty intersection; no conditional-fiber or support assumptions.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily
lake build LeanInfoTheory.Shannon.SemanticBridge
```

Test all four overlap patterns.

**Definition of done:** CMI nonnegativity and submodularity compile on PMF and
source-family surfaces and match the exact `ShannonEntropyVal.cmi_nonneg`
expression.

**Downstream effect:** Supplies the valuation's `cmi_nonneg` field and the
remaining Shannon inequality band.

**Documentation implications:** Compare the concrete submodularity statement
with the existing abstract certificate expression.

**Risk and fallback:** Prove PMF-facing CMI first, then derive source and
submodularity forms. Keep set-normalization helpers private.

### C6.15 - Family MI Nonnegativity And Entropy Bounds

**Status:** complete (2026-07-27)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` with exactly the eight
approved PMF/source-family inequalities:

- `familyMutualInfo_nonneg`;
- `familyMutualInfoOf_nonneg`;
- `familyMutualInfo_le_entropy_left`;
- `familyMutualInfo_le_entropy_right`;
- `familyMutualInfoOf_le_entropyOf_left`;
- `familyMutualInfoOf_le_entropyOf_right`;
- `familyCondEntropy_le_entropy`;
- `familyCondEntropyOf_le_entropyOf`.

The PMF family-MI theorem is the direct semantic bridge: it rewrites through
`familyMutualInfo_eq_mutualInfoOf`, unfolds the established random-variable
definition, and applies `mutualInfo_nonneg` to the finite
restriction-valued pair law. The left MI bound is an atom-native consequence
of `familyMutualInfo_eq_entropy_sub_condEntropy` and
`familyCondEntropy_nonneg`; the right bound uses
`familyMutualInfo_swap`. Conditioning reduces entropy follows atom-natively
from family-MI nonnegativity and the same entropy-difference identity. Each
source theorem is definitionally the corresponding PMF theorem on
`familyLawOf p X`.

`lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` passed with
2,700 jobs, and `lake build LeanInfoTheory.Shannon.SemanticBridge` passed with
2,751 jobs. A disposable direct-import consumer resolved all eight
declarations and exercised empty, equal, disjoint, and partially overlapping
atoms on both PMF and source surfaces. A guarded root consumer failed with the
expected unknown identifier, so the new API remains opt-in. Axiom inspection
reported only `propext`, `Classical.choice`, and `Quot.sound`; all disposable
files were deleted.

No disjointness, nonemptiness, support, equality-classification,
source-finiteness, or global `[Fintype Var]` assumption was added. The names
are concise, mathematical, and consistent with the established `...Of`
distinction; they expose no marginal, projection, or helper machinery and
need no Future Work Note 14 entry. No canonical project-memory document
changed in this step.

**Objective:** Add the principal two-set information inequalities without
mixing them with conditioning monotonicity or n-way induction.

**Prerequisites:** C6.08 and C6.13--C6.14.

**Proposed declarations:**

- family MI nonnegativity;
- left and right bounds `I(A;B) <= H(A)` and `I(A;B) <= H(B)`;
- `H(A|B) <= H(A)`;
- source-family counterparts.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/SemanticBridge/FiniteFamily.lean`.

**Strategy:** Prefer C6.07 bridges to the existing finite random-variable
theorems. Where algebra is clearer, use the C6.08 entropy-difference identities
with C6.13--C6.14 nonnegativity.

**Edge cases:** Empty/equal/overlapping atoms, zero entropy, and no equality
classification.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily
lake build LeanInfoTheory.Shannon.SemanticBridge
```

**Definition of done:** All stated inequalities compile in both PMF and source
forms, and no independence equality theorem is added.

**Downstream effect:** Supports the textbook consequence surface and later
certificate-facing examples.

**Documentation implications:** Record which results are direct bridges and
which are atom-native corollaries.

**Risk and fallback:** Omit only redundant symmetric aliases, not the
mathematical left/right results.

### C6.16 - Conditioning Reduction And Binary Subadditivity

**Status:** complete (2026-07-28)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` with the four approved
PMF/source-family inequalities:

- `familyCondEntropy_union_le_condEntropy`;
- `familyCondEntropyOf_union_le_condEntropyOf`;
- `familyEntropy_union_le_add`;
- `familyEntropyOf_union_le_add`.

The additional-conditioning theorem states the atom-native Cover--Thomas
inequality

```text
H(A | B union C) <= H(A | C).
```

Its proof rewrites `familyCondMutualInfo_nonneg` through
`familyCondMutualInfo_eq_condEntropy_sub_condEntropy` and reads the resulting
nonnegative difference as the desired order. This is strictly stronger than
the unconditional `familyCondEntropy_le_entropy` theorem added in C6.15 and
does not duplicate it. Binary subadditivity uses the right-oriented family
entropy chain rule, bounds `H(A | B)` by `H(A)`, and normalizes the final
addition order. Both source forms are direct corollaries on
`familyLawOf p X`.

An initial validation pass exposed an order mismatch in the subadditivity
`calc`: `add_le_add_left` produced the opposite syntactic addition order.
Replacing it with `add_le_add_right` preserved the approved statement and
proof strategy and removed the error. Lean's import phase was unusually slow
during this step; a profiler pass confirmed that the delay was import
overhead rather than a new theorem elaboration problem.

The final focused build
`lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` passed with
2,700 jobs, and the aggregate build
`lake build LeanInfoTheory.Shannon.SemanticBridge` passed with 2,751 jobs.
A disposable direct-import consumer resolved all four declarations and
exercised empty added conditioning, nested conditioning, equal atoms, and
partially overlapping unions on both PMF and source surfaces. A guarded root
consumer failed with the expected unknown identifier. Axiom inspection
reported only `propext`, `Classical.choice`, and `Quot.sound`; all disposable
files were deleted.

No disjointness, freshness, nonemptiness, support, equality-classification,
source-finiteness, or global `[Fintype Var]` assumption was added. The four
names expose the mathematical union orientation without leaking restriction,
marginal, or proof-helper machinery, so no Future Work Note 14 entry is
needed. The equality case of Cover--Thomas Theorem 2.6.5 remains intentionally
outside this step. No canonical project-memory document changed.

**Objective:** Complete the remaining binary Shannon inequalities required for
the n-way bound.

**Prerequisites:** C6.09 and C6.13--C6.15.

**Proposed declarations:**

- conditioning-reduces-entropy in atom form;
- family entropy union subadditivity;
- source-family counterparts.

Exact names and orientation are tentative.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/SemanticBridge/FiniteFamily.lean`.

**Strategy:** Express the loss from additional conditioning as family CMI and
use C6.14. Obtain binary subadditivity from H| nonnegativity/upper bounds or
the existing pair theorem through C6.07.

**Edge cases:** Empty added conditioning, nested conditioning atoms, equal and
overlapping entropy atoms, and equality cases intentionally omitted.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily
lake build LeanInfoTheory.Shannon.SemanticBridge
```

**Definition of done:** Both inequality families compile explicitly, with no
global simp orientation or independence characterization.

**Downstream effect:** Supplies the induction step for C6.17.

**Documentation implications:** Relate the conditioning theorem to
Cover--Thomas Theorem 2.6.5 without claiming its equality case.

**Risk and fallback:** If one proof route creates avoidable union algebra, use
the already compiled pair compatibility theorem instead.

### C6.17 - N-Way Entropy Subadditivity

**Status:** complete (2026-07-28)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` with the four approved
n-way entropy inequalities:

- `familyEntropy_le_sum_singletons`;
- `familyEntropyOf_le_sum_singletons`;
- `familyEntropy_subadditivity_of_nodup`;
- `familyEntropyOf_subadditivity_of_nodup`.

The primary PMF theorem states

```text
H(S) <= sum i in S, H({i})
```

for an arbitrary finite atom `S`. Its proof uses `Finset.induction_on`.
The empty case is `familyEntropy_empty`; the insertion step rewrites
`insert i s` as `{i} union s`, applies `familyEntropy_union_le_add`, and
combines the induction hypothesis with `Finset.sum_insert`. It requires no
ordering of `S` and no global `[Fintype Var]`. The source Finset theorem is the
same result on `familyLawOf p X`.

The textbook list theorem retains an explicit `List.Nodup` assumption and
uses the same `Fin l.length` indexing convention as the existing ordered
entropy chain rule. It rewrites with
`familyEntropy_chain_rule_of_nodup` and bounds every conditional-entropy term
by its singleton entropy using `familyCondEntropy_le_entropy` and
`Finset.sum_le_sum`. The source list theorem again follows through
`familyLawOf`. Duplicate lists are not assigned a misleading occurrence-wise
theorem: their deduplicated atom remains covered by the stronger primary
Finset result.

The module now opens `BigOperators` locally; no import changed. The focused
build `lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` passed
with 2,700 jobs, and
`lake build LeanInfoTheory.Shannon.SemanticBridge` passed with 2,751 jobs. A
disposable direct-import consumer exercised 0-, 1-, and 3-variable atoms, a
duplicate-list Finset use, both `Nodup` list corollaries, an infinite `Nat`
index, and heterogeneous alphabets `Fin (i + 1)` on PMF and source surfaces.
A guarded root consumer failed with the expected unknown identifier. Axiom
inspection reported only `propext`, `Classical.choice`, and `Quot.sound`; all
disposable files were deleted.

No independence assumption, equality characterization, support,
nonemptiness, source-finiteness, or global index finiteness was added. The
four names are mathematical and expose no accumulator, restriction, or
projection machinery, so no Future Work Note 14 entry is needed. The equality
iff mutual independence direction remains explicitly deferred. No canonical
project-memory document changed.

**Objective:** Formalize the inequality part of the Cover--Thomas independence
bound.

**Prerequisites:** C6.04, C6.11, and C6.16.

**Proposed declarations:**

- a primary Finset theorem
  `H(s) <= sum i in s, H({i})`;
- a source-family Finset form;
- `Nodup` list textbook corollaries on PMF and source-family surfaces.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/SemanticBridge/FiniteFamily.lean`.

**Strategy:** Use `Finset.induction` and binary subadditivity as the primary
proof. Derive list forms using `List.toFinset` and `List.Nodup`; alternatively
use the ordered entropy chain plus conditioning reduction if that produces a
cleaner corollary.

**Edge cases:** Empty and singleton atoms, duplicate lists, and no equality or
independence assumption.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily
lake build LeanInfoTheory.Shannon.SemanticBridge
```

Test 0-, 1-, and 3-variable cases.

**Definition of done:** The Finset theorem and approved textbook corollaries
compile without a global finite index type.

**Downstream effect:** Completes the planned Chapter 2 finite-family Shannon
inequality layer.

**Documentation implications:** State explicitly that the equality iff
independence direction is deferred.

**Risk and fallback:** Prefer the shorter of the Finset-induction and
chain-rule derivations while retaining the Finset theorem as the primary API.

### C6.18 - Concrete `ShannonEntropyVal`

**Status:** complete (2026-07-28)

**Implementation outcome:** Extended
`LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` with the two approved
concrete valuation constructors:

- `finiteFamilyEntropyVal`;
- `finiteFamilyEntropyValOf`.

It also adds four strict constructor-elimination theorems:

- `finiteFamilyEntropyVal_apply`;
- `finiteFamilyEntropyValOf_apply`;
- `finiteFamilyEntropyVal_eval`;
- `finiteFamilyEntropyValOf_eval`.

`finiteFamilyEntropyVal q` has `value := familyEntropy q`. Its
`empty_eq_zero` field is `familyEntropy_empty q`. Its `cond_nonneg` field uses
`familyEntropy_mono q (Finset.subset_insert i s)` and `sub_nonneg.mpr`; the
existing structure's freshness hypothesis is therefore accepted but the
concrete proof establishes the stronger monotonicity fact without needing it.
Its `cmi_nonneg` field is definitionally the exact four-entropy expression
proved by `familyCondMutualInfo_nonneg q`. No union-normalization helper,
stronger field, or extra assumption is required. The source constructor is
the same valuation on `familyLawOf p X`.

All four application/evaluation theorems are reflexive constructor
reductions. They are `[simp]` rules directed only from the concrete wrapper to
`familyEntropy`, `familyEntropyOf`, or their `EntropyExpr.eval` forms. Consumer
tests confirmed that they terminate and do not unfold the certificate
algebra. `LeanInfoTheory.EntropyVal` is now imported only by the semantic
finite-family module; `EntropyVal.lean`, the lightweight finite-family core,
the project root, and the abstract certificate contract are unchanged.

The focused build
`lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` passed with
2,702 jobs, and the aggregate build
`lake build LeanInfoTheory.Shannon.SemanticBridge` passed with 2,753 jobs. A
disposable direct-import consumer invoked `empty_eq_zero`, `cond_nonneg`, and
`cmi_nonneg` directly on both constructors; checked all four `[simp]`
reductions; and exercised `Var := Nat`, heterogeneous alphabets
`Fin (i + 1)`, and an explicitly empty index type with its vacuous dependent
`Fintype` family. Guarded consumers confirmed that neither the lightweight
root nor `Shannon.FiniteFamily` exposes the constructors. Axiom inspection
reported only `propext`, `Classical.choice`, and `Quot.sound`; all disposable
files were deleted.

No certificate theorem, support or nonemptiness condition, source-finiteness
assumption, global `[Fintype Var]`, placeholder, or unapproved axiom was
introduced. The six names are direct constructor/application/evaluation names
and expose no marginal, restriction, or proof-helper machinery, so no Future
Work Note 14 entry is needed. The targeted project-memory update remains
assigned to the later authorized reconciliation step; no canonical document
changed here.

**Objective:** Prove that actual finite-family Shannon entropy satisfies the
existing abstract certificate contract.

**Prerequisites:** C6.04, C6.13, and C6.14.

**Proposed declarations:**

- `finiteFamilyEntropyVal`;
- `finiteFamilyEntropyValOf`;
- constructor-reducing application lemmas;
- evaluation lemmas connecting `ShannonEntropyVal.eval` to
  `EntropyExpr.eval (familyEntropy q)`.

**Target files and namespaces:** Extend
`LeanInfoTheory/Shannon/SemanticBridge/FiniteFamily.lean` in
`LeanInfoTheory.Shannon`. Import `LeanInfoTheory.EntropyVal` here; do not edit
`EntropyVal.lean`.

**Strategy:** Construct the structure transparently:

```text
value         := familyEntropy q
empty_eq_zero := C6.04
cond_nonneg   := C6.13 applied to s subset insert i s
cmi_nonneg    := C6.14, definitionally normalized
```

The source constructor is the same valuation applied to `familyLawOf p X`.
Only strict constructor-elimination lemmas are candidates for `[simp]`.

**Edge cases:** Infinite `Var`, empty `Var`, dependent alphabets, empty atoms,
and exact union association in the `cmi_nonneg` field.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily
lake build LeanInfoTheory.Shannon.SemanticBridge
```

Compile a consumer that invokes each structure field directly, including
`Var := Nat`.

**Definition of done:** Both constructors compile with exactly the existing
`ShannonEntropyVal` fields, no extra assumptions, no certificate theorem, and
no change to the abstract structure.

**Downstream effect:** Unlocks concrete checked-certificate semantics.

**Documentation implications:** This is a major project-memory milestone and
should receive a targeted project-log entry when authorized.

**Risk and fallback:** Union normalization may obscure definitional equality.
Use a short proved bridge, not a stronger structure field or assumption.

### C6.19 - Checked-Certificate Concrete Semantics

**Status:** complete (2026-07-28)

**Implementation outcome:** Created the opt-in module
`LeanInfoTheory.Certificate.FiniteFamily`, importing exactly
`LeanInfoTheory.Certificate.Checked` and
`LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily`, and added the approved
adapter theorem:

- `Certificate.CheckedCert.sound_finiteFamily`.

For an arbitrary checked certificate `cert` and dependent finite family law
`q`, the theorem proves
`0 <= EntropyExpr.eval (Shannon.familyEntropy q) cert.target`. Its proof
applies the existing `CheckedCert.sound` theorem to
`Shannon.finiteFamilyEntropyVal q` and uses only
`Shannon.finiteFamilyEntropyVal_eval` to expose the concrete evaluator. It
does not inspect the certificate decomposition, introduce another validation
path, specialize to submodularity, or add a family-specific raw-certificate
wrapper.

The focused build
`lake build LeanInfoTheory.Certificate.FiniteFamily` passed with 2,706 jobs.
A disposable direct-import consumer checked the public theorem and applied it
both generically and with the infinite index type `Nat` and dependent
alphabets `Fin (i + 1)`. Axiom inspection reported only `propext`,
`Classical.choice`, and `Quot.sound`. Guarded consumers importing,
respectively, the lightweight project root and
`LeanInfoTheory.Certificate.Checked` both rejected the adapter as an unknown
constant, confirming that the new leaf module remains opt-in. All disposable
files were deleted.

The theorem name is a short specialization of the established
`CheckedCert.sound` API and exposes no marginal, restriction, projection, or
proof-helper machinery, so no Future Work Note 14 entry is warranted. No
aggregate, root, canonical project-memory document, placeholder, or
unapproved axiom changed.

**Objective:** Provide one reusable, discoverable theorem applying a checked
certificate to actual family entropy.

**Prerequisites:** C6.18 and the existing checked-certificate API.

**Proposed declarations:** Tentatively
`Certificate.CheckedCert.sound_finiteFamily`, returning:

```text
0 <= EntropyExpr.eval (familyEntropy q) cert.target
```

No family-specific raw-certificate declaration is approved initially.

**Target files and namespaces:** Create
`LeanInfoTheory/Certificate/FiniteFamily.lean`, extending the appropriate
`LeanInfoTheory.Certificate.CheckedCert` namespace or another namespace
selected by the C6.01 contract check.

**Strategy:** Apply verified `CheckedCert.sound` to
`finiteFamilyEntropyVal q`, then rewrite only the concrete constructor and
evaluator. Do not inspect or bypass the checked certificate's decomposition.

**Edge cases:** Arbitrary certificate targets, arbitrary finite atoms,
infinite `Var`, and no specialization to submodularity.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Certificate.FiniteFamily
```

Compile a generic checked-certificate consumer and a guarded root non-exposure
consumer.

**Definition of done:** The theorem is certificate-generic, concrete-family
generic, and proved solely through existing checked soundness.

**Downstream effect:** Supplies the checked path used by C6.20.

**Documentation implications:** Explain that this is an adapter, not a new
trust mechanism.

**Risk and fallback:** If the theorem is only a syntactic alias with no
discoverability benefit, stop for user review before removing it; the selected
scope explicitly requested a reusable checked connection.

### C6.20 - Permanent Finite-Family And Certificate Examples

**Status:** complete (2026-07-28)

**Implementation outcome:** Created
`LeanInfoTheory.Examples.FiniteFamily` and added it only to the opt-in
`LeanInfoTheory.Examples` aggregate. The new module contains two maintained
source-driven models.

`Examples.FiniteFamily.BooleanModel` defines:

- the three-name index type `Var`, with no `Fintype` instance;
- a uniform two-bit `source`;
- the left, right, and parity `coordinates`;
- the full family `law` via `Shannon.familyLawOf`;
- the two-name `order` and `mutualInfo_chain_rule`;
- the overlapping atoms `leftAtom` and `rightAtom`;
- `submodularity_checked`, proved by
  `Certificate.CheckedCert.sound_finiteFamily`;
- `submodularity_raw`, proved from
  `Certificate.Submodularity.rawCert_toCheckedCert?_isSome` through the
  generic `Certificate.RawCert.sound_of_toCheckedCert?_isSome`.

The checked theorem therefore consumes a proof-carrying certificate directly,
whereas the raw theorem explicitly depends on prior validation of the
primitive tag and exact decomposition. Both conclude an `EntropyExpr`
inequality evaluated by the actual family entropy of the Boolean law.

`Examples.FiniteFamily.HeterogeneousModel` defines:

- a two-name index type `Var`, again with no `Fintype` instance;
- the dependent coordinate family `Alphabet`, with Boolean and `Fin 3`
  fibers;
- a uniform product `source`, dependent `coordinates`, and their full `law`;
- the two-name `order` and source-level `entropy_chain_rule`;
- `empty_entropy`, confirming the empty-family convention.

Only the heterogeneous coordinate alphabets receive a `Fintype` instance,
kept private to the example module. Lean required its two branch targets to be
made explicit as `Fintype Bool` and `Fintype (Fin 3)`; this was an elaboration
detail and did not alter the approved representation or public API.

The focused build
`lake build LeanInfoTheory.Examples.FiniteFamily` passed with 2,708 jobs, and
`lake build LeanInfoTheory.Examples` passed with 2,769 jobs. A disposable
direct-import consumer checked all model laws and maintained theorems. Axiom
inspection of both chain rules, both certificate theorems, and the empty case
reported only `propext`, `Classical.choice`, and `Quot.sound`. Guarded checks
confirmed that neither model index type synthesizes `Fintype` and that the
lightweight project root does not expose the example module. All disposable
files were deleted.

The module and aggregate summaries distinguish the checked and raw trust
paths and retain the example module outside the root. The public names are
short, mathematical, and scoped under descriptive model namespaces; no
Future Work Note 14 entry is warranted. No canonical project-memory document,
placeholder, unapproved axiom, or unrelated module changed.

**Objective:** Exercise the complete public surface and both certificate
soundness paths in maintained code.

**Prerequisites:** C6.12 and C6.18--C6.19.

**Proposed declarations:** Example-specific family laws and theorems under
`LeanInfoTheory.Examples.FiniteFamily`, including:

- a small finite Boolean-family model;
- a heterogeneous-alphabet model;
- entropy and MI chain-rule consumers;
- a concrete Shannon inequality through
  `CheckedCert.sound_finiteFamily`;
- a concrete raw submodularity proof using
  `Submodularity.rawCert_toCheckedCert?_isSome` and the verified generic
  `RawCert.sound_of_toCheckedCert?_isSome`.

**Target files and namespaces:** Create
`LeanInfoTheory/Examples/FiniteFamily.lean`; update only the opt-in
`LeanInfoTheory/Examples.lean` aggregate.

**Strategy:** Use a small source PMF and `familyLawOf`. Keep the probability
model transparent and avoid unrelated numerical entropy calculations. Make
the checked and raw proof paths visibly distinct.

**Edge cases:** Heterogeneous alphabets, overlapping atoms, one maintained
empty- or singleton-atom sanity theorem, and no accidental requirement that
`Var` be finite beyond the concrete example itself.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Examples.FiniteFamily
lake build LeanInfoTheory.Examples
```

**Definition of done:** The examples compile, exercise the intended direct
imports, use the new checked adapter, and preserve raw validation through the
existing generic theorem.

**Downstream effect:** Provides real consumers for the C6.21 API review.

**Documentation implications:** Example declarations and module summaries
must describe exactly which validation path they exercise.

**Risk and fallback:** Simplify the sample probability model if proof noise
obscures the API, but retain heterogeneous typing and a genuine certificate
validation path.

### C6.21 - API, Naming, Simp, And Import Review

**Status:** complete (2026-07-28)

**Implementation outcome:** Completed the scheduled review across
`Shannon.FiniteFamily`, `Shannon.SemanticBridge.FiniteFamily`,
`Certificate.FiniteFamily`, `Examples.FiniteFamily`, and their intended
aggregates. The public declaration surface is frozen at 68 lightweight-core
declarations, 30 semantic declarations, one checked-certificate adapter, and
18 explicit example declarations. No declaration was renamed, no
compatibility alias or source-family mirror was added, and no theorem
statement, namespace, or import edge changed.

The PMF/`...Of` audit found coherent paired families throughout the scalar
core and semantic layer. PMF-only restriction and elementary reduction
theorems remain primitive where source callers can reduce through
`familyLawOf`; the permanent examples did not justify mirroring every such
theorem. The certificate adapter remains PMF-law facing, with source users
able to pass `familyLawOf p X`, so no speculative
`sound_finiteFamilyOf` wrapper was introduced.

The Future Work Note 14 watch groups were exercised in a direct consumer.
The compatibility bridge name
`familyCondMutualInfoOf_eq_condMutualInfoOf` is repetitive but precise, and
the four family MI/CMI entropy-difference names are long but mathematical and
systematic. None caused discovery or proof-readability friction in the
permanent examples or review consumer. All current names are therefore
retained without aliases. The semantic, valuation, certificate, and example
names are short within their established namespaces and expose no private
restriction, split, accumulator, marginal, coordinate-swap, or proof-helper
machinery.

Eight existing, strictly reducing normalization theorems are now `[simp]`:

- `familyEntropy_empty`;
- `familyEntropyOf_empty`;
- `familyCondEntropy_empty_right`;
- `familyCondEntropy_empty_left`;
- `familyMutualInfo_empty_right`;
- `familyCondMutualInfo_empty_right`;
- `familyCondMutualInfo_empty_conditioning`;
- `familyMutualInfo_self`.

Before promotion, the existing global simp set made no progress on the
representative goals. With the attributes enabled, direct PMF and source
empty cases, nested overlapping empty cases, self MI, concrete valuation
evaluation, and `Var := Nat` with alphabets `Fin (i + 1)` all normalized
without a loop or unstable orientation. The first seven rules remove empty
arguments or empty conditioning; the self rule removes a repeated MI
constructor. All union, binary, and ordered chain rules, symmetry theorems,
compatibility bridges, and entropy-difference identities remain explicit
under Future Work Notes 15--16. Promoting the PMF empty theorem made the
existing source-empty proof's `simpa` redundant, so it was reduced to the
warning-free proof `simp [familyEntropyOf]`.

The repeated finite-set identity in the entropy and MI telescoping proofs was
extracted once as private `union_cons_toFinset`. It replaces two identical
local extensionality calculations with one-line rewrites and remains
inaccessible to importing consumers. All other restriction, split,
singleton-evaluation, and recursive-accumulator helpers remain private. The
new modules expose no genuine split pressure: the lightweight core is large
but mathematically coherent, while semantic, certificate, and example
dependencies already occupy separate opt-in modules.

The approved six-target command passed with 2,770 jobs:

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily `
  LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily `
  LeanInfoTheory.Certificate.FiniteFamily `
  LeanInfoTheory.Examples.FiniteFamily `
  LeanInfoTheory.Shannon.SemanticBridge `
  LeanInfoTheory.Examples
```

Positive consumers passed for the lightweight core, semantic aggregate,
direct certificate adapter, and examples aggregate. Guarded consumers
confirmed that the project root does not expose finite-family entropy, the
core does not expose semantic inequalities or concrete valuations, neither
the semantic nor certificate aggregate exposes the certificate adapter, and
all private split/accumulator helpers remain inaccessible. Axiom inspection
of the promoted rules and both ordered chain theorems reported only
`propext`, `Classical.choice`, and `Quot.sound`. All disposable files were
deleted.

No canonical project-memory document was changed by C6.21. Future Work Notes
2, 14, and 16, including the representative-versus-exhaustive wording from
the C6.20 review, remain assigned to the authorized C6.22 reconciliation.

**Objective:** Freeze a coherent Chunk 6 API after production consumers exist.

**Prerequisites:** C6.20.

**Proposed declarations:** No theorem is required merely to increase API
symmetry. Compatibility aliases may be added only when the examples or direct
consumers demonstrate material discovery or readability pressure.

**Target files and namespaces:** Review all four new modules and their
aggregates. Update source only for approved aliases, attributes, private-helper
cleanup, or import corrections.

**Strategy:**

1. Audit PMF versus `...Of` consistency.
2. Audit every public name under Future Work Note 14.
3. Keep chain rules and algebraic representation changes explicit under
   Future Work Notes 15--16.
4. Add `[simp]` only to strict constructor-elimination or empty-normalization
   rules that terminate under representative tests.
5. Check that no private restriction/split/accumulator helper leaked.
6. Check the root, semantic aggregate, certificate aggregate, and examples
   boundaries.
7. Review whether the new files reveal a genuine split pressure under Future
   Work Note 2. Do not split silently.

**Edge cases:** Alias collisions, rewrite cycles, duplicate PMF/source theorem
families, root exposure, and representation-heavy names.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily `
  LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily `
  LeanInfoTheory.Certificate.FiniteFamily `
  LeanInfoTheory.Examples.FiniteFamily `
  LeanInfoTheory.Shannon.SemanticBridge `
  LeanInfoTheory.Examples
```

Run positive direct-import and guarded negative root consumers.

**Definition of done:** Names, imports, simp behavior, and public/private
boundaries are explicitly reviewed; every alias decision has a recorded
reason; no silent rename occurs.

**Downstream effect:** Freezes the source surface used by documentation and
generated references.

**Documentation implications:** Update Future Work Notes 2, 14, 16, and any
new proof-pressure record in C6.22; do not edit them prematurely in this step
unless the authorized implementation prompt includes that update.

**Risk and fallback:** If a module split or material statement change is
needed, stop and revise this plan with user approval before making it.

### C6.22 - Canonical Documentation And Project-Memory Reconciliation

**Status:** complete (2026-07-28)

**Implementation outcome:** Reconciled the API-frozen Chunk 6 working tree
across this plan, `docs/project-log.md`,
`docs/lean-info-theory-living-summary.md`, `docs/current-lean-state.md`,
`docs/roadmap.md`, and `README.md`. The documents now record the 68 reviewed
lightweight-core declarations, 30 semantic/concrete-valuation declarations,
one checked-certificate adapter, and 18 explicit maintained example
declarations; the dependent-alphabet/no-`Fintype Var` contract; the concrete
`ShannonEntropyVal` construction; the unchanged certificate trust boundary;
the C6.21 naming/simp/private-helper decisions; and the four-module opt-in
architecture.

The reconciliation explicitly distinguishes the checked-in handoff head
`b8012ef`, the last fully validated committed source checkpoint `ec78829`, and
the focused but not yet milestone-validated Chunk 6 working tree. It records
the C6.21 six-target 2,770-job build and guarded consumer/axiom evidence
without claiming that the complete `C6.24` milestone gate has passed. Future
Work Note 1 remains the active Chunk 6 sequence anchor; Notes 2, 14--16, and
18 record the reviewed module, naming, simp, explicit-rewrite, and chunk-
boundary decisions; Note 17 now records that generated-reference and full
milestone validation remain pending.

Read-only use of the module parser found the expected 43 modules, 75 local
edges, 11 root-reachable modules, and 32 opt-in modules. The declaration-index
parser currently reports 835 candidates because it mistakes the module-doc
line beginning "theorem to actual" in `Certificate.FiniteFamily` for a
declaration. The reviewed source surface is 834 actual declarations, adding
117 in Chunk 6. Correcting that immediate parser input issue and regenerating
the tracked 39-module/717-declaration references remain assigned to `C6.23`;
the independent complete build, trust, boundary, placeholder, website, and
hygiene gate remains assigned to `C6.24`.

A post-implementation double-check corrected the living-summary Quick Start
row to include Future Work Notes 15--16 alongside Notes 14 and 17--18. Those
standing simp and explicit-rewrite guardrails were already accurately recorded
elsewhere; only the onboarding cross-reference had omitted them.

No Lean source, public declaration, theorem statement, import, namespace,
attribute, or trust mechanism changed in this documentation-only step. All
named paths exist, a source-derived check resolved every representative
declaration named by the reconciliation, and `git diff --check` reported no
whitespace error beyond the working tree's existing LF/CRLF notices. No Lean
build was required. `C6.23` and `C6.24` remain not started and separately
approval-gated.

**Objective:** Reconcile canonical project memory with the API-frozen Chunk 6
implementation before final public generation.

**Prerequisites:** C6.21.

**Proposed declarations:** None.

**Target files and namespaces:** Update, as factually required:

- this plan's implementation outcomes and statuses;
- `docs/project-log.md`;
- `docs/lean-info-theory-living-summary.md`;
- `docs/current-lean-state.md`;
- `docs/roadmap.md`;
- `README.md`.

Do not edit `AGENTS.md` unless a separate stable-policy change is explicitly
approved.

**Strategy:** Reconcile every statement against source and focused builds.
Record Note 1's disposition, Note 2 module decision, Note 14 naming review,
Note 16 chain simp decision, Note 17 validation still pending, and Note 18
chunk boundary. Preserve unrelated Future Work Notes and all historical
records.

Do not yet claim that C6.24's full validation has passed.

**Edge cases:** Distinguish the baseline head, current working tree, last
validated source checkpoint, generated local references, and deployed website.

**Focused validation:** Check every named declaration and path against source;
run `git diff --check`; inspect the documentation-only semantic diff.

**Definition of done:** Canonical documents accurately describe the
implemented and API-reviewed chunk, its remaining final gate, and all
deferrals.

**Downstream effect:** Supplies accurate source prose for generated and public
documentation.

**Documentation implications:** This is the primary canonical-memory step;
C6.24 may amend only exact final validation evidence and completion status.

**Risk and fallback:** Keep historical detail in the project log and concise
canonical facts in the living summary. Never overwrite unrelated thread work.

### C6.23 - Generated References And Public Documentation

**Status:** complete (2026-07-28)

**Implementation outcome:** Corrected the source-derived declaration parser
to skip possibly nested ordinary Lean block comments. This removes the false
`LeanInfoTheory.Certificate.FiniteFamily.to` declaration caused by module
prose without weakening the parser input or rewriting the mathematically
useful module comment. A synthetic nested-comment check passed.

Added curated module-graph summaries for all four Chunk 6 modules and updated
the aggregate summaries that now reach finite-family semantics or examples.
The regenerated references record 43 local modules, 75 local import edges, 11
root-reachable modules, 32 separate-import modules, and 834 reviewed
source-declared public declarations. All 834 declarations have source doc
comments. Relative to the checked-in C5 artifacts, the semantic delta is
exactly four modules, ten local edges, and 117 declarations: 68 in
`Shannon.FiniteFamily`, 30 in `Shannon.SemanticBridge.FiniteFamily`, one in
`Certificate.FiniteFamily`, and 18 in `Examples.FiniteFamily`. No module uses
the generic fallback summary, and all 117 new declaration source links resolve
to the expected declaration line.

Updated only the existing hand-written public status and import surfaces that
were stale: the site home page, roadmap, module guide, development guide,
concept note, and hand-written blueprint overview. They now distinguish the
implemented C6.23 working tree from the still-pending C6.24 independent
milestone validation. The theorem-highlight and demo pages were deliberately
left unchanged because the generated declaration index already provides
adequate Chunk 6 discovery and the approved step made such curation optional.
The API metric now says "source-declared public declarations" so it is not
confused with full Lean doc-gen.

The post-implementation double-check found that the source doc comments for
`EntropyExpr.RespectsEmpty` and `ShannonEntropyVal` still described concrete
finite-family semantics as future work. Those documentation comments now
identify the existing opt-in `finiteFamilyEntropyVal` and
`finiteFamilyEntropyValOf` constructions while preserving the foundational
modules' lightweight imports. Regeneration propagates the corrected wording
and updated source lines into the declaration index.

Both generators were run twice after the final edits; the second-pass HTML and
JSON outputs were byte-identical. `python scripts/check_website.py` checked 12
HTML files and two generated JSON files successfully. Independent semantic
count checks passed, stale pre-implementation Chunk 6 website prose was absent,
and `git diff --check` reported no whitespace error beyond the working tree's
existing LF/CRLF notices.

Only Lean documentation comments changed in `EntropyExpr.lean` and
`EntropyVal.lean`; no declaration, theorem statement, namespace, import,
attribute, or trust mechanism changed. The focused
`lake build LeanInfoTheory.EntropyExpr LeanInfoTheory.EntropyVal
LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily` check passed with 2,702
jobs after the final wording. C6.24 remains not started and separately
approval-gated.

A post-step critical review added no new numbered Future Work item. It expanded
Future Work Note 9 with evidence-driven triggers for declaration-parser
regression tests, stable website-checker invariants, broader lexical coverage,
selective finite-family theorem highlights, shared-status generation, and a
desktop/mobile rendered smoke test, while retaining Future Work Note 17 as the
owner of milestone-validation orchestration.

**Objective:** Make the new modules and declarations discoverable in the
existing generated/public documentation without redesigning the website.

**Prerequisites:** C6.22.

**Proposed declarations:** None.

**Target files and namespaces:** Regenerated module/declaration reference
artifacts and only the hand-written website/module-guide/status pages that
need factual Chunk 6 updates.

**Strategy:** Run both generators twice, compare second-pass output for
idempotence, inspect the semantic module/edge/declaration delta, and update
short public descriptions from verified source. Preserve the distinction
between the module graph, source-derived declaration index, and full doc-gen.

**Edge cases:** Stale status prose, accidental website redesign, unrelated
generated churn, fallback module descriptions, and deployed/local state
confusion.

**Focused validation:**

```powershell
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/check_website.py
git diff --check
```

Repeat both generators and verify byte-identical second-pass output.

**Definition of done:** All four new public modules and all intended declarations
appear in generated references, links and JSON validate, and public prose
matches source.

**Downstream effect:** Leaves only independent final validation and closeout.

**Documentation implications:** No theorem-level blueprint or full Lean
doc-gen claim is introduced.

**Risk and fallback:** Optional theorem-highlight curation may be omitted if
the generated index already provides adequate discovery; generated and module
status accuracy is mandatory.

### C6.24 - Final Chunk Validation And Closeout

**Status:** complete (2026-07-28)

**Implementation outcome:** The independent closeout pass completed without
changing a Lean declaration, theorem statement, import edge, namespace,
attribute, or trust mechanism. The six-target focused build passed with 2,770
jobs:

```powershell
lake build LeanInfoTheory.Shannon.FiniteFamily `
  LeanInfoTheory.Shannon.SemanticBridge.FiniteFamily `
  LeanInfoTheory.Certificate.FiniteFamily `
  LeanInfoTheory.Examples.FiniteFamily `
  LeanInfoTheory.Shannon.SemanticBridge `
  LeanInfoTheory.Examples
```

The maintained ten-target milestone suite passed with 2,783 jobs, and the
default `lake build` passed with 2,240 jobs.

Four positive direct-import consumers exercised the complete core, semantic,
certificate, and example surfaces. Their edge cases included an infinite
variable-name type without `[Fintype Var]`, dependent heterogeneous alphabets
`Fin (i + 1)`, an actually empty index type, empty and singleton atoms,
overlapping atoms, duplicate list entries, arbitrary infinite source types,
the concrete `finiteFamilyEntropyVal` evaluation, generic
`CheckedCert.sound_finiteFamily`, and both maintained example models. The
first disposable core fixture used an opaque local `def` for its dependent
alphabet alias and therefore failed typeclass unfolding; changing that
ignored fixture to `abbrev` made the intended contract elaborate. This was a
validation-harness correction, not a source or API defect.

Six guarded negative consumers failed with the expected diagnostics. They
confirmed that the lightweight root does not expose family entropy, the core
does not expose semantic inequalities, the semantic and certificate
aggregates do not expose the checked finite-family adapter, private chain-rule
machinery remains inaccessible, and `Examples.FiniteFamily` does not create a
global `Fintype` instance for its Boolean variable-name type. All disposable
consumers were removed.

The strict project-source placeholder scan found no `sorry`, `admit`, `axiom`,
`opaque`, or `undefined`. A mechanically generated `#print axioms` audit
covered all 89 new public theorems: 55 core, 28 semantic, one certificate, and
five example theorems. Every report contained only `propext`,
`Classical.choice`, and `Quot.sound`; no `sorryAx` or project axiom appeared.

Both reference generators were run twice and reproduced all four generated
artifact hashes byte for byte. Independent semantic checks confirmed 43
modules, 75 local import edges, 11 root-reachable modules, 32 opt-in modules,
and 834 documented source declarations, including the exact Chunk 6 counts
68/30/1/18. There are no duplicate declaration names or HTML anchors, no
generic module-summary fallback, no false
`LeanInfoTheory.Certificate.FiniteFamily.to`, and every new source-line link
resolves to its declaration. `python scripts/check_website.py` checked 12 HTML
files and two generated JSON files successfully.

The lightweight root is unchanged. Import, root-reachability, placeholder,
axiom, tracked-textbook, scratch-file, generated-artifact, whitespace, and
complete-diff audits are clean. Validation was incremental rather than a cold
cache rebuild, consistent with Future Work Note 17's release-hardening policy.
The checked-in head remains `b8012ef`; `ec78829` remains the last fully
validated committed Lean/source checkpoint. This complete and independently
validated Chunk 6 state is still an uncommitted working tree, so no checkpoint
commit is claimed.

The approved target list named only this plan, the project log, and living
summary for final evidence. Completion also made the existing current-facing
README, current-state, roadmap, site-home, and site-roadmap lines factually
stale. Those status lines were therefore updated narrowly to say that Chunk 6
is complete and validated in the working tree but not yet checkpointed. No
later chunk or deferred work is authorized by this closeout.

A post-closeout critical review found no mathematical, architectural, trust,
or documentation defect and does not reopen this step. It expanded existing
Future Work Notes 9 and 17 rather than creating a new numbered item. Note 9
now records the additional repeated-status pressure and the need to keep
validation, checkpoint, and deployment states distinct. Note 17 records that
the reusable validation-driver trigger is satisfied, asks a future
boundary/axiom harness to use an inventory independent of the website parser,
preserves the C6.24 positive/negative boundary matrix, retains cold builds as
release hardening, and tightens scoped-baseline and target-list revision
practice for future closeouts. These are later maintenance improvements, not
C6.24 corrections or prerequisites for the Chunk 6 checkpoint.

**Objective:** Independently establish that Chunk 6 satisfies its mathematical,
architectural, trust, documentation, and hygiene criteria.

**Prerequisites:** C6.23.

**Proposed declarations:** None unless validation exposes a defect, in which
case return to the owning step rather than patching silently here.

**Target files and namespaces:** No planned theorem file. Amend this plan,
project log, and living summary only with exact final evidence after all checks
pass.

**Strategy:** Treat this as an independent closeout pass. Do not repair a
failed theorem, import, or document silently inside the validation step;
return to the owning step and preserve the failure record.

**Focused validation:**

1. Build all new focused modules and important aggregates.
2. Run the maintained milestone suite:

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

3. Run default `lake build`.
4. Re-run positive direct-import consumers.
5. Re-run guarded negative root and aggregate-boundary consumers.
6. Re-run the infinite-index, empty-index, duplicate-list, overlap, and
   heterogeneous-alphabet consumers.
7. Scan Lean source for `sorry`, `admit`, `axiom`, `opaque`, and `undefined`.
8. Audit `#print axioms` for every new public theorem family.
9. Re-run generated-reference idempotence and `scripts/check_website.py`.
10. Run `git diff --check`, inspect `git status`, inspect the complete diff,
    and verify that no scratch or textbook file is tracked.
11. Record exact commands/results and mark the chunk complete only after every
    required check passes.

**Edge cases:** Cached builds hiding missing imports, root exposure, stale
generated files, forgotten spikes, unapproved axioms, and documentation that
claims more than the final evidence.

**Definition of done:** Every completion criterion below is met, exact
validation evidence is recorded, and the working tree contains only
intentional Chunk 6 changes.

**Downstream effect:** Declares Chunk 6 ready for a coherent checkpoint. It
does not authorize Chunk 7 or any deferred work.

**Documentation implications:** Amend C6.22 records with final pass counts,
completion status, and any remaining follow-up; rerun affected documentation
checks.

**Risk and fallback:** Any failed check keeps the chunk incomplete. Return to
the owning step, preserve the failure record, and obtain approval before
resuming later work.

## Integration Checkpoints

1. **After C6.05:** The representation, marginal calculus, empty/singleton
   semantics, nonnegativity, and pair/triple union encoding compile.
2. **After C6.12:** The full lightweight H/H|/I/I| API and all-list plus
   `Nodup` chain rules compile under direct imports without `[Fintype Var]`.
3. **After C6.18:** The semantic inequality layer compiles and the concrete
   family entropy genuinely instantiates `ShannonEntropyVal`.
4. **After C6.20:** Checked and raw certificate paths are exercised by
   maintained concrete examples.
5. **After C6.21:** Public names, simp policy, helper visibility, module
   boundaries, and root isolation are reviewed and frozen.
6. **After C6.24:** Full build, trust, project-memory, generated-reference,
   website, and repository-hygiene evidence agree.

No checkpoint or completed step authorizes beginning the next step. Explicit
user approval is required each time.

## Chunk-completion Criteria

Chunk 6 is complete only when:

- the accepted dependent-family representation is implemented without
  `[Fintype Var]`;
- no proof forms finite entropy of the full family law;
- empty, singleton, and nonnegative family entropy theorems compile;
- pair/triple union bridges support overlapping atoms;
- family H|, I, and I| agree with the existing pair/triple API;
- the principal entropy-difference identities compile;
- binary entropy and MI chain rules compile;
- all-list entropy and MI chain rules compile, with public `Nodup` textbook
  corollaries;
- monotonicity, H| nonnegativity, CMI nonnegativity, and submodularity compile;
- MI bounds, conditioning reduction, binary subadditivity, and n-way
  subadditivity compile;
- `finiteFamilyEntropyVal` satisfies the existing structure fields directly
  and without extra assumptions;
- the checked-certificate adapter uses `CheckedCert.sound` without bypassing
  validation;
- the permanent example exercises the new checked adapter and the existing
  generic raw-validation theorem;
- no placeholder or unapproved axiom is introduced;
- core, semantic, certificate, example, aggregate, and root boundaries pass
  their positive/negative consumers;
- the lightweight root remains unchanged;
- public naming and simp behavior are reviewed;
- canonical documents, generated references, and public status agree with
  source;
- all focused, milestone, default-build, website, axiom, placeholder, and
  hygiene checks pass;
- every deviation, cancellation, supersession, and follow-up is recorded
  honestly.

## Explicitly Deferred Work

- A public `Fin n` ordering API.
- The binary CMI union chain rule unless a later consumer triggers it.
- A family-specific raw-certificate soundness wrapper.
- Index-equivalence and relabeling theorems.
- A bundled finite-family structure.
- Family product-cardinality entropy bounds.
- N-way independence and equality cases for subadditivity.
- Total correlation, multi-information, and interaction information.
- Relative-entropy/KL chain rules.
- Entropy concavity, finite-simplex topology, and continuity.
- Coding theory, capacity, AEP, typicality, and asymptotic converses.
- New certificate constraints, primitive recognition, search, parsing, or
  external import.
- Splitting `InfoMeasures.lean` without demonstrated maintenance pressure.
- Full Lean doc-gen, theorem-level blueprint work, and website redesign.
- Unrelated finite-Fano follow-ups retained by Future Work Note 29.

The exact disposition of numbered Future Work Notes must be re-read from the
current project log during C6.22. This list defines scope and does not itself
authorize closing a note.

## Proposed Future-work Candidates

Create or refine a future-work entry only when implementation or consumer
evidence supports it:

- add injective `Fin n` chain-rule wrappers if positional consumers repeatedly
  need list conversions;
- publish duplicate-specific chain simplification lemmas only if repeated-list
  consumers need more than the all-list theorem;
- add index-equivalence invariance after at least two family models require
  relabeling;
- develop n-way independence/equality and total correlation in a later
  extended-fundamentals chunk;
- add product-cardinality bounds in a separately importable family-bounds
  module if extremization or coding work consumes them;
- revisit a bundled family object only if repeated parameter lists materially
  impair theorem statements;
- add a family-specific raw-certificate wrapper only if the permanent example
  or a second consumer demonstrates real ergonomic pressure;
- add the deferred CMI union chain rule when an ordered conditional-MI or later
  chain consumer needs it;
- consider upstreaming only after names, assumptions, and module ownership
  stabilize.

Do not duplicate standing Future Work Notes 1--4, 6, 8, 14--18, or 29. Update
their existing entries where they already own the issue.

## Known Risks

- Dependent subtype coercions may make restriction and union-injection proofs
  brittle.
- A careless use of `entropy_map_le` can accidentally demand finiteness of the
  full index product rather than the selected marginal.
- Prefix sums over `Fin l.length`, `List.take`, and `List.toFinset` may require
  a private recursive accumulator for tractable induction.
- Duplicate-tolerant chain rules are mathematically valid but must be stated
  and documented so users do not mistake `toFinset` collapse for lost entropy.
- Pair/triple bridge names can expose `restrict`, subtype, or split-map
  implementation details.
- Systematic PMF and `...Of` wrappers can create redundant declarations if
  consumer pressure is not checked.
- Importing concrete valuation semantics in the wrong direction could make
  the root or abstract certificate layer heavy.
- A family-specific certificate theorem can become a useless alias or,
  worse, obscure the existing trust path if its proof is not transparent.
- The example can become over-specialized to submodularity unless its family
  and valuation APIs remain generic.
- Large core or semantic files may trigger real module-split pressure during
  C6.21.
- Canonical and generated status documents can drift while a long chunk is in
  progress.

## Plan-revision Policy

- Implementation discoveries may justify changing later steps.
- Every proposed plan change must be explained to the user before this plan is
  edited.
- Completed implementation history must not be rewritten misleadingly.
- Cancelled or superseded steps remain in the plan under their original
  stable ID with a factual reason and replacement reference.
- New steps receive new stable IDs; completed or cancelled IDs are never
  recycled.
- If a theorem statement changes materially, record the original proposal,
  the revised contract, and the mathematical/API reason.
- Scope, public API, representation, module ownership, trust-boundary, or
  naming-policy changes require explicit user approval.
- A private proof-strategy change may be recorded in the step outcome when it
  preserves the approved public contract and architecture.
- No later step begins without the user's explicit approval.
- Completing a step or integration checkpoint does not authorize beginning
  the next step.
- If a discovery invalidates the dependency graph, assumption policy,
  no-`Fintype Var` invariant, certificate trust path, or approved theorem
  contract, stop implementation and return for review.
