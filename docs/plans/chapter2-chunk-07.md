# Chapter 2 Chunk 7: Finite Log-Sum And Convexity

**Plan status:** Approved for implementation
**Baseline commit:** `9aa3bb1258206fb24a3645115955be8501ea3e5e`
**Preceding Chunk 6 Lean/source checkpoint:** `7b5f0db83f188bf65454f5aa7dcd2fe8ee221146`
**Plan path:** `docs/plans/chapter2-chunk-07.md`
**Number of steps:** 22
**Execution status:** `C7.01`--`C7.22` complete

The baseline is the clean checked-in commit titled
`Finalize Project B Chunk 7 handoff`. The completed Chunk 6 Lean/source
checkpoint is `Complete Project B Chunk 6`. The intervening handoff commits
change documentation and public status only; `git diff` from the Chunk 6
checkpoint to this baseline contains no Lean source change. At plan creation,
`HEAD`, `master`, and `origin/master` all point to the baseline and the working
tree is clean apart from this new plan.

Twenty-two steps are appropriate because the accepted contract has two
independent proof-complete feasibility gates, six scalar LS3 stages, a
separately reviewed finite-mixture layer, distinct entropy and KL inequality
and equality stages, two mutual-information directions, and four integration
and closeout stages. The draft had 21 steps. The final plan splits its original
feasibility work into scalar and binary-KL gates, moves production mixture work
after completion of LS3, and preserves the remaining mathematical coverage.
This makes each high-risk contract independently stoppable without combining
unrelated public APIs into oversized steps.

## Chunk Objective

Formalize the finite PMF version of Cover--Thomas Section 2.7 under the
project's established conventions. The chunk should provide:

- a representation-independent finite log-sum inequality with exact zero-safe
  extended-value behavior and equality characterization;
- a reusable finite-selector mixture surface through existing `PMF.bind`,
  together with a discoverable binary PMF mixture;
- entropy concavity and its approved strict binary equality case;
- canonical `ENNReal` KL joint convexity, guarded Real corollaries, and the
  approved binary support-aware equality case;
- mutual-information concavity in the input law and convexity in the channel;
- general finite-selector theorems plus binary textbook corollaries;
- opt-in module boundaries that leave the lightweight root and certificate
  trust model unchanged.

## Approved Scope

The public probability representations remain ordinary mathlib PMFs and
PMF-valued channels:

```text
r : PMF selector
P Q : selector -> PMF alpha
p : PMF alpha
W : alpha -> PMF beta
```

General finite mixtures are written with existing `r.bind P`. Binary mixtures
use `t : NNReal` with `ht : t <= 1`, matching `PMF.bernoulli`. The intended
orientation is true mass `t` and false mass `1 - t`.

The scalar log-sum layer is canonical over an arbitrary finite set:

```text
s : Finset iota
a b : iota -> NNReal
```

Its zero-safe term is EReal-valued so that positive-over-zero is represented
by `top`, while multiplication by zero realizes the textbook `0/0` and
zero-over-positive conventions. Guarded Real theorems are practical
corollaries, not the canonical unconditional statements.

KL divergence remains mathlib's
`InformationTheory.klDiv : Measure alpha -> Measure alpha -> ENNReal`.
Unconditional KL convexity is therefore `ENNReal`-valued. Real-valued
corollaries require explicit active-component support or finiteness guards.

The exact equality inventory is:

- full zero-safe finite log-sum equality;
- reuse, rather than duplication, of the existing KL-zero API;
- binary strict entropy-concavity equality for `0 < t < 1`;
- binary KL-convexity equality under component support inclusion and interior
  weight, in both canonical `ENNReal` and guarded Real presentations.

No equality characterization is planned for general selectors or for the
mutual-information theorems.

## Explicit Non-goals

- Finite-simplex structures, topology, continuity, or lower semicontinuity.
- KL continuity on fixed support or global KL lower semicontinuity.
- Real-coefficient binary-mixture forwarding APIs.
- A bundled channel abstraction or a public general channel-mixture
  definition without demonstrated pressure.
- General finite-selector equality classifications for entropy or KL.
- Equality cases for MI concavity, MI channel convexity, or specialized
  channel theorems.
- Finite-family wrappers; existing PMF theorems may be applied to
  `familyMarginal` directly.
- Conditional-relative-entropy objects, conditional-KL gap closure, or KL
  chain-rule work outside what is needed privately for this chunk.
- Pinsker, tensorization, AEP, typicality, capacity, or coding theorems.
- Changes to `EntropyExpr`, `ShannonEntropyVal`, primitive inequalities,
  checked certificates, validation, or the certificate trust boundary.
- New certificate examples or certificate-facing convexity rules.
- Changes to existing theorem statements or architecture.
- Importing any new Chunk 7 module from `LeanInfoTheory.lean`.
- Full Lean doc-gen, theorem-level blueprint work, or a website redesign.

## Relevant Cover--Thomas Sections And Conventions

The local source consulted is:

`info theory e-books/Elements_of_Information_Theory_Elements.pdf`

The exact first-edition material is Section 2.7, "The Log Sum Inequality and
Its Applications", book pages 29--31 and PDF pages 51--53:

- Theorem 2.7.1: the finite log-sum inequality and constant-ratio equality;
- the immediate reuse of log-sum for KL nonnegativity and KL-zero equality;
- Theorem 2.7.2: binary joint convexity of relative entropy;
- Theorem 2.7.3: concavity of entropy;
- Theorem 2.7.4: concavity of mutual information in the input law for a fixed
  channel and convexity in the channel for a fixed input law.

Directly required preceding conventions come from Sections 2.1--2.4:
finite PMFs, entropy, relative entropy, mutual information, and
`I(X;Y) = H(Y) - H(Y|X)`.

Convention differences:

- The textbook defaults to base-two logarithms; LeanInfoTheory uses natural
  logarithms and nats. Every theorem in this chunk is base-independent up to
  the common positive scale.
- The textbook writes `0 log 0 = 0`, positive-over-zero as infinity, and
  zero-over-zero as zero. The project represents the unconditional scalar
  term in `EReal` using `ENNReal.log`; guarded Real corollaries rely on
  `Real.log 0 = 0` only after positive-over-zero has been excluded.
- The textbook states binary convexity and concavity. The approved A3 surface
  proves reusable finite-selector forms and supplies binary corollaries.
- The textbook does not give the additional entropy or KL equality cases
  approved here. Those are finite, zero-safe consequences of the same strict
  convexity machinery and remain within the accepted EQ2 inventory.

No unrelated textbook chapter or later asymptotic result belongs to this
plan.

## Existing Infrastructure

### Verified LeanInfoTheory declarations

The following existing names and ownership have been verified in current
source:

- `PMF.sum_toReal`, `PMF.toReal_nonneg`, `PMF.toReal_le_one`, and
  `PMF.supportFinset`;
- `Shannon.entropy`, `entropy_eq_sum`, `entropy_nonneg`,
  `entropy_map_injective`, and `entropyOf`;
- `Shannon.fstMarginal`, `sndMarginal`, `condEntropy`, `mutualInfo`,
  `mutualInfo_eq`, and
  `mutualInfo_eq_entropy_sndMarginal_sub_condEntropy_swap`;
- `PMF.channelJoint`, `channelJoint_apply`, `channelJoint_map_fst`,
  `channelJoint_map_snd`, and `mem_support_channelJoint_iff`;
- `Shannon.indepProd`, `indepProd_apply`, `support_indepProd`,
  `fstMarginal_indepProd`, and `sndMarginal_indepProd`;
- `Shannon.toMeasure_absolutelyContinuous_iff_support_subset`;
- `Shannon.klDiv_pmf_ne_top_iff_support_subset`;
- `Shannon.klDiv_pmf_eq_top_iff_not_support_subset`;
- `Shannon.klDiv_pmf_eq_zero_iff`;
- `Shannon.toReal_klDiv_pmf_eq_zero_iff`;
- `Shannon.toReal_klDiv_pmf_eq_sum`;
- `Shannon.mutualInfo_eq_toReal_klDiv_joint_indepProd`;
- `Shannon.joint_toMeasure_absolutelyContinuous_indepProd_marginals`.

No existing LeanInfoTheory module defines a general finite-selector
probability mixture wrapper, scalar log-sum theorem, entropy-concavity family,
KL joint-convexity family, or the Section 2.7 mutual-information convexity
theorems.

### Verified mathlib declarations and behavior

- `PMF.bind`, `PMF.bind_apply`, `PMF.bind_bind`, `PMF.bind_comm`;
- `PMF.support_bind`, `PMF.mem_support_bind_iff`;
- `PMF.bernoulli`, `PMF.bernoulli_apply`,
  `PMF.support_bernoulli`, and `PMF.mem_support_bernoulli_iff`;
- `PMF.ext`, `PMF.tsum_coe`, `PMF.coe_le_one`, and `PMF.apply_ne_top`;
- `Real.convexOn_mul_log`, `Real.strictConvexOn_mul_log`;
- `Real.concaveOn_negMulLog`, `Real.strictConcaveOn_negMulLog`;
- `ConvexOn.map_sum_le`, `ConcaveOn.le_map_sum`;
- `StrictConvexOn.map_sum_eq_iff`,
  `StrictConvexOn.map_sum_eq_iff'`;
- `StrictConcaveOn.map_sum_eq_iff`,
  `StrictConcaveOn.map_sum_eq_iff'`;
- `ENNReal.log`, `ENNReal.log_zero`, `ENNReal.log_top`,
  `ENNReal.log_pos_real`, and `ENNReal.log_of_nnreal`;
- `ENNReal.toReal_sum`, `ENNReal.toReal_mul`,
  `ENNReal.toReal_le_toReal`, and `ENNReal.coe_sub`;
- `EReal.zero_mul`, `EReal.mul_top_of_pos`,
  `EReal.coe_ennreal_mul_top`, `EReal.add_top_of_ne_bot`,
  `EReal.top_add_of_ne_bot`, and `EReal.coe_ennreal_ne_bot`;
- `InformationTheory.klDiv`.

Mathlib does not currently provide the required two-argument zero-safe finite
log-sum theorem, finite PMF KL joint convexity, or an unconditional
extended-valued finite PMF KL sum expansion. The plan must not cite such a
theorem as existing.

## Mathematical Dependency Overview

```text
guarded Real finite log-sum inequality and equality (private)
                         |
extended log-sum term + term/sum != bottom
                         |
       canonical EReal inequality and full equality
                         |
             coherent public LS3 API
                         |
      binary KL equality feasibility gate
                         |
         PMF finite and binary mixtures
             /                    \
direct finite Jensen          scalar log-sum + KL bridge
      |                              |
entropy concavity              KL joint convexity
      |                              |
binary strict equality         binary KL equality
      |                              |
MI input concavity             MI channel convexity
             \                    /
              examples and API review
                         |
       project memory, references, final gate
```

The two feasibility gates are mandatory:

- C7.01 must prove the complete hard scalar LS3 bridges in a disposable Lean
  file before production scalar work.
- C7.07 must prove the complete binary support-aware KL equality contract in a
  disposable Lean file after LS3 is available and before mixture/KL production
  work.

If either gate fails, stop. Do not weaken LS3, EQ2, the zero conventions,
support assumptions, or the claim of full finite Section 2.7 coverage without
an explicitly approved plan revision.

## API And Four-Module Strategy

All new module and declaration names below are tentative until source
elaboration and the C7.19 naming review. Once a public declaration is added,
preserve it and prefer compatibility-preserving aliases over casual renaming.

### 1. `LeanInfoTheory.Probability.FiniteMixture`

Tentative path: `LeanInfoTheory/Probability/FiniteMixture.lean`

Namespace: `PMF`

It owns only reusable finite-PMF mixture construction and computation:

- `PMF.binaryMixture`;
- `PMF.binaryMixture_apply`;
- `PMF.binaryMixture_zero`;
- `PMF.binaryMixture_one`.

General selector mixtures continue to use `r.bind P`; no redundant public
`finiteMixture` synonym is planned. This module imports the finite PMF
foundation and no entropy, Jensen, KL, channel, or certificate module.

### 2. `LeanInfoTheory.Shannon.LogSum`

Tentative path: `LeanInfoTheory/Shannon/LogSum.lean`

Namespace: `LeanInfoTheory.Shannon`

It owns the representation-independent scalar LS3 layer. Tentative public
names are:

- `logSumTerm`;
- `logSumTerm_zero_left`;
- `logSumTerm_pos_zero`;
- `logSumTerm_ne_bot`;
- `sum_logSumTerm_ne_bot`;
- `logSum_inequality`;
- `logSum_eq_iff_exists_constant_ratio`;
- `real_logSum_inequality_of_support`;
- `real_logSum_eq_iff_exists_constant_ratio_of_support`.

The guarded Real proof engines in C7.02--C7.03 remain private. The public Real
family appears only in C7.06, alongside the complete extended API.

### 3. `LeanInfoTheory.Shannon.EntropyConcavity`

Tentative path: `LeanInfoTheory/Shannon/EntropyConcavity.lean`

Namespace: `LeanInfoTheory.Shannon`

Tentative public names are:

- `sum_mul_entropy_le_entropy_bind`;
- `binaryMixture_entropy_concave`;
- `binaryMixture_entropy_eq_iff`.

This module imports `Shannon.Entropy`,
`Probability.FiniteMixture`, and finite Jensen support. It proves entropy
concavity directly from `Real.concaveOn_negMulLog`. It must not import
`Shannon.LogSum` merely to reproduce the textbook proof route.

### 4. `LeanInfoTheory.Shannon.SemanticBridge.Convexity`

Tentative path:
`LeanInfoTheory/Shannon/SemanticBridge/Convexity.lean`

Namespace: `LeanInfoTheory.Shannon`

It owns KL and channel-facing convexity. Tentative public names are:

- `klDiv_bind_le_sum`;
- `toReal_klDiv_bind_le_sum`;
- `klDiv_binaryMixture_le`;
- `toReal_klDiv_binaryMixture_le`;
- `klDiv_binaryMixture_eq_iff`;
- `toReal_klDiv_binaryMixture_eq_iff`;
- `mutualInfo_channelJoint_eq_entropy_bind_sub_sum`;
- `sum_mul_mutualInfo_channelJoint_le`;
- `mutualInfo_binaryMixture_input_concave`;
- `mutualInfo_channelMixture_le_sum`;
- `mutualInfo_binaryChannelMixture_le`.

It imports the scalar log-sum module, entropy-concavity module, finite-mixture
and finite-channel cores, and existing semantic KL/product infrastructure
directly. General entropy and MI theorems use finite selector/output alphabets;
KL theorems additionally use the existing finite measurable-singleton
assumptions required by the PMF KL expansion. No theorem adds a `Nonempty`
assumption merely to make a finite selector or alphabet convenient. One-off
mixture-support, `channelJoint`, `indepProd`, coercion, and commutation helpers
remain private.

The module joins the existing opt-in aggregate
`LeanInfoTheory.Shannon.SemanticBridge` while remaining directly importable.
None of the four modules enters `LeanInfoTheory.lean`.

### Maintained examples

A tentative opt-in module
`LeanInfoTheory.Examples.Convexity` at
`LeanInfoTheory/Examples/Convexity.lean` may use names such as:

- `fairCoin`, `biasedCoin`;
- `binaryMixture_entropy_example`;
- `binaryKlEquality_example`;
- `mutualInfoInputConcavity_example`;
- `mutualInfoChannelConvexity_example`.

These example names are sketches, not approved API spellings. C7.18 and C7.19
must choose descriptive names from the implemented examples and audit them
under the same naming policy.

## Principal Risks And Fallback Boundaries

- `EReal` addition is delicate around `top` and `bottom`. The accepted term
  must be proved never `bottom`, as must its finite sum, before any extended
  algebra is trusted.
- The full extended equality includes empty, all-zero, zero-over-positive,
  positive-over-zero, mixed finite/`top`, and singleton cases. A guarded Real
  theorem alone is not an acceptable fallback.
- There is no existing extended finite PMF KL expansion. Canonical ENNReal KL
  convexity must use a top/finite split and the existing guarded Real
  expansion without treating `ENNReal.toReal top = 0` as meaningful.
- Binary KL equality is exact only with interior weight and component support
  inclusion. Removing either changes the mathematics by admitting endpoint or
  `top = top` degeneracies.
- Selector types may be empty in syntax, but a `PMF Empty` cannot be
  constructed. Empty scalar sums, singleton selectors, and zero-weight Bool
  components are the correct tests.
- `NNReal` subtraction and coercion must preserve `1 - t` under `ht : t <= 1`.
- Strict Jensen APIs may create reusable-helper pressure, but no helper may be
  promoted solely to shorten one proof.
- Mutual-information channel convexity needs exact private identities showing
  that channel joints, output laws, and fixed-input independent products
  commute with selector mixing. Those identities must not become public
  accidentally.
- If a feasibility gate fails, the fallback is a reviewed plan revision, not
  stronger assumptions, a reduced theorem, LS1-only support, a different
  representation, or an unapproved axiom.

## Implementation Steps

### C7.01 - Scalar LS3 Feasibility Gate

**Status:** complete

**Objective and reason:** Prove in a disposable Lean consumer that the complete
accepted scalar contract is feasible before creating production declarations.
This is the highest-risk EReal contract and must be proof-complete, not a
signature check.

**Prerequisites:** The repository remains compatible with the recorded
baseline; the accepted `Finset`/NNReal/EReal representation is unchanged.

**Verified declarations to reuse:** Existing finite-sum notation and PMF
infrastructure are not required. Reuse current project import conventions and
the verified mathlib APIs listed below.

**Verified mathlib APIs:** `Real.convexOn_mul_log`,
`Real.strictConvexOn_mul_log`, `ConvexOn.map_sum_le`,
`StrictConvexOn.map_sum_eq_iff`,
`StrictConvexOn.map_sum_eq_iff'`, `ENNReal.log`,
`ENNReal.log_zero`, `ENNReal.log_top`, `ENNReal.log_pos_real`,
`ENNReal.toReal_sum`, `ENNReal.toReal_mul`, `EReal.zero_mul`,
`EReal.mul_top_of_pos`, and the non-bottom/top addition lemmas.

**Proposed declarations:** None in production. The disposable file should use
local versions of the tentative `logSumTerm`, extended inequality, extended
equality iff, and private guarded Real engines.

**Target files, namespaces, and imports:** Use a verified ignored disposable
file under `tmp/codex-handoffs/` or another ignored scratch location and a
private namespace. Import only the candidate scalar mathlib dependencies.
Delete the file before completing the step.

**Strategy:** Compile complete proofs of:

1. the guarded Real inequality over arbitrary `s : Finset iota`;
2. its strict constant-ratio equality characterization;
3. the zero-safe EReal term and term/sum non-bottom invariants;
4. the unconditional extended inequality;
5. equality iff one `c : ENNReal` is the ratio on every active index
   `i in s`, where active means `a i != 0 or b i != 0`;
6. the conversion back to the guarded Real statements.

Use explicit case splits for positive-over-zero and total denominator zero.
Do not leave a representative branch, conversion, or equality implication
unproved.

**Edge cases:** Empty `s`; all-zero families; `0/0`; zero-over-positive;
positive-over-zero; one positive-over-zero mixed with finite-ratio terms;
total denominator zero; total denominator positive; singleton `s`; constant
ratio `0`, finite ratio, and `top`; nonconstant active ratios; no
`top + bottom`.

**Focused validation:**

```powershell
lake env lean <ignored-scalar-feasibility-file>
git diff --check
```

Also verify the scratch file is deleted and `git status` contains no
production change from this gate.

**Definition of done:** Every hard scalar theorem and conversion compiles
without placeholder or stronger assumption, the edge matrix is exercised, and
no scratch artifact remains.

**Downstream effect:** Authorizes C7.02 only after explicit user approval.

**Documentation implications:** Update only this plan's factual step outcome
when implemented. Canonical project-memory reconciliation remains C7.20.

**Risk level:** Critical.

**Fallback strategy:** Stop immediately if any complete proof fails. Explain
the exact branch or API obstruction and request approval for a plan revision.
Do not begin C7.02 and do not substitute a guarded-only theorem.

**Implementation outcome (2026-07-29):** Complete. An ignored disposable Lean
consumer proved the complete scalar LS3 contract over arbitrary
`s : Finset iota` and was deleted after validation. The spike established a
private guarded Real inequality by finite Jensen, its strict constant-ratio
equality characterization, the zero-safe EReal term, atomic and finite-sum
non-bottom invariants, the unconditional extended inequality, and the full
active-ratio equality iff with `c : ENNReal`. It then derived both guarded
Real statements back from the extended contract rather than merely retaining
the original proof engines.

The proof separated the support-guarded finite branch from the
positive-over-zero `top` branch. Compiled consumers covered the empty Finset,
all-zero data, `0/0`, zero-over-positive, positive-over-zero, mixed
finite/`top`, total denominator zero, singleton data, constant ratios `0`,
finite, and `top`, nonconstant ratios, and sum non-bottom. The focused command
`lake env lean -j 8 tmp/codex-handoffs/c7-01-logsum-feasibility.lean` passed.
The scratch placeholder scan was clean; `#print axioms` for the extended
inequality/equality and both Real round-trips reported only `propext`,
`Classical.choice`, and `Quot.sound`. The scratch path was verified ignored and
is absent after completion. No production declaration, public name, import,
canonical project-memory file, or Future Work item changed. C7.02 remains
approval-gated.

**Post-step scalar-regression follow-up (2026-07-29):** Complete. After C7.16,
an explicitly authorized exact-contract audit reconfirmed that the production
guarded Real family uses the intended support-sensitive hypothesis
`forall i in s, a i != 0 -> b i != 0`, rather than requiring every selected
denominator to be nonzero. It also reconfirmed that the unconditional extended
inequality and active-index `ENNReal` constant-ratio equality characterize the
accepted LS3 contract without weakening its `0/0` or positive-over-zero
behavior. No C7.01 spike, C7.02 proof engine, public declaration, theorem
statement, or simp attribute was rewritten.

The scalar subset of C7.18 was then pulled forward into a private regression
section in `LeanInfoTheory.Examples.Convexity`. Anonymous consumers exercise
the public C7.04--C7.06 declarations on the empty Finset, all-zero and `0/0`
data, zero-over-positive, positive-over-zero, mixed finite/`top` terms, total
denominator zero, a singleton, term and finite-sum non-bottom, common ratios
`0`, finite-positive, and `top`, a nonconstant active-ratio failure, and the
guarded Real family with a selected `(0, 0)` pair. The latter also proves that
the exact support guard holds while the stronger all-denominators-nonzero
condition fails. The new module is reached by the examples aggregate and
remains outside `LeanInfoTheory.lean`. C7.18 remains `not started` because its
mixture, entropy, KL, MI, and remaining boundary-consumer work is still
pending.

The combined focused build of `Shannon.LogSum`, `Examples.Convexity`, and the
examples aggregate passed with 2,772 jobs and no warnings. A guarded root-only
consumer failed with the expected unknown identifier for `Shannon.logSumTerm`
and was deleted. The strict placeholder scan, tracked and new-file diff checks,
scratch cleanup, and trailing-whitespace checks all passed. The reusable
general validation driver remains deferred under Future Work Note 17.

### C7.02 - Private Guarded Real Log-Sum Inequality

**Status:** complete

**Objective and reason:** Create the production scalar module and establish the
guarded Real log-sum inequality as private proof infrastructure for LS3.

**Prerequisites:** C7.01 is complete.

**Verified declarations to reuse:** Project naming, module, and documentation
conventions; no existing project scalar theorem duplicates this result.

**Verified mathlib APIs:** `Real.convexOn_mul_log`,
`ConvexOn.map_sum_le`, `ENNReal.toReal_sum`, ordinary Finset filtering and
sums, `Real.log_zero`, and NNReal-to-Real coercion lemmas.

**Proposed declarations:** A private theorem, provisionally
`real_logSum_inequality_aux`. It is not public API and its final private name
is implementation detail.

**Target files, namespaces, and imports:** Create the tentative
`LeanInfoTheory/Shannon/LogSum.lean` in
`LeanInfoTheory.Shannon`. Import the lightest direct mathlib modules providing
finite Jensen, `x * log x`, ENNReal log, and required EReal operations. Do not
import PMFs, entropy, KL, semantic bridges, or certificates.

**Strategy:** Assume
`forall i in s, a i != 0 -> b i != 0`. Split on the total denominator.
If it is zero, the guard forces every selected numerator to zero. Otherwise
normalize positive denominator masses, apply finite Jensen to
`x * Real.log x`, and clear the normalization. Keep all filtering and
coercion support private.

**Edge cases:** Empty `s`; total denominator zero; selected `(0,0)` terms;
zero-over-positive; no positive-over-zero by the guard; zero Jensen weights;
NNReal/Real coercions; no `Fintype iota`.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.LogSum
```

Run the placeholder scan on the new module and inspect its public declaration
surface to confirm the engine is private.

**Definition of done:** The private guarded Real inequality compiles for an
arbitrary Finset with exactly the support guard and no public theorem added
prematurely.

**Downstream effect:** Supplies C7.03 and the finite branch of C7.05.

**Documentation implications:** Add a source section comment explaining that
the guarded theorem is private infrastructure for the later zero-safe public
API.

**Risk level:** High.

**Fallback strategy:** Reuse the proof shape validated in C7.01. Private
refactoring is allowed, but do not strengthen the guard or publish an
intermediate theorem without review.

**Implementation outcome (2026-07-29):** Complete.
`LeanInfoTheory/Shannon/LogSum.lean` now exists as a directly importable,
scalar-only opt-in module. Its sole declaration is the private proof engine
`real_logSum_inequality_aux`. The theorem uses the approved guard
`forall i in s, a i != 0 -> b i != 0`; it does not require every denominator
to be positive and it requires neither `[DecidableEq iota]` nor
`[Fintype iota]`.

The proof handles zero total denominator first, where the support guard forces
all selected numerators to vanish. In the nonzero branch it filters precisely
the zero denominators, proves the corresponding numerators and Real summands
vanish, normalizes the remaining positive denominator masses, applies
`Real.convexOn_mul_log.map_sum_le`, and clears the normalization. This retains
selected `(0, 0)` terms and excludes only positive-over-zero terms. The
production theorem therefore uses the weaker approved support guard rather
than copying the all-denominators-nonzero convenience wrapper from the C7.01
spike; C7.01's extended proof had already validated this filtering regime.

`lake build LeanInfoTheory.Shannon.LogSum` passed with 2,180 jobs. A direct
import consumer passed, a negative consumer confirmed that the private engine
is inaccessible, the module has zero source-level public declarations, and
the placeholder, root-import-isolation, and diff checks passed. No root,
aggregate, PMF, entropy, semantic, certificate, canonical-memory, generated,
or website file changed. No public naming or Future Work entry is justified.
C7.03 remains approval-gated.

### C7.03 - Private Guarded Real Log-Sum Equality

**Status:** complete

**Objective and reason:** Establish the complete guarded Real equality case
privately so the extended equality can reuse a proved strict-Jensen core.

**Prerequisites:** C7.02.

**Verified declarations to reuse:** The private C7.02 inequality and its
normalization calculations.

**Verified mathlib APIs:** `Real.strictConvexOn_mul_log`,
`StrictConvexOn.map_sum_eq_iff`,
`StrictConvexOn.map_sum_eq_iff'`, Finset filtering, and finite-sum
nonnegativity/equality tools.

**Proposed declarations:** A private theorem, provisionally
`real_logSum_eq_iff_exists_constant_ratio_aux`.

**Target files, namespaces, and imports:** Extend
`LeanInfoTheory/Shannon/LogSum.lean`; no import expansion should be needed.

**Strategy:** Filter to indices with positive denominator. Under the support
guard, every positive numerator is retained and `(0,0)` contributes zero.
Apply strict Jensen equality to the normalized positive denominator weights.
Translate equality of normalized points into one common finite ratio on active
indices. Handle total denominator zero separately, where all selected pairs
are `(0,0)` and the active condition is vacuous.

**Edge cases:** Empty filtered set; all `(0,0)`; zero-over-positive with common
ratio zero; singleton positive denominator; indices outside `s`; proof that
the existential ratio is independent of a chosen witness; no denominator-zero
positive numerator.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.LogSum
```

Compile an ignored direct consumer that exercises empty, singleton, all-zero,
constant-ratio, and nonconstant-ratio guarded examples, then delete it.

**Definition of done:** Both equality directions compile under the exact
guard, and the theorem remains private.

**Downstream effect:** Supplies the finite branch of the public extended
equality in C7.06.

**Documentation implications:** Document the mathematical filtering idea in a
short private-helper comment if the proof is not self-explanatory.

**Risk level:** High.

**Fallback strategy:** Use the positive-weight equality API or its
nonnegative-weight primed form according to the cleanest proof. Do not weaken
the equality condition or expose raw Jensen bookkeeping.

**Implementation outcome (2026-07-29):** Complete.
`LeanInfoTheory/Shannon/LogSum.lean` now contains the private theorem
`real_logSum_eq_iff_exists_constant_ratio_aux`. Under the exact C7.02 support
guard, guarded Real log-sum equality is equivalent to the existence of one
common Real ratio on precisely the active selected pairs
`a i != 0 or b i != 0`. No `[DecidableEq iota]`, `[Fintype iota]`, stronger
positivity assumption, import expansion, or public declaration was added.

The proof separates the zero-total-denominator case, where the support guard
makes every selected pair `(0, 0)`, from the positive-total case. In the latter
case it uses `Real.strictConvexOn_mul_log.map_sum_eq_iff'` on the full selected
Finset with normalized nonnegative denominator weights. This is the
fallback explicitly allowed by the approved step and is cleaner than filtering:
the zero-weight `(0, 0)` indices are ignored by the primed strict-Jensen
contract itself. The proof then translates nonzero normalized weights to the
active-pair condition and proves the reverse direction by identifying the
weighted center with the supplied common ratio.

`lake build LeanInfoTheory.Shannon.LogSum` passed with 2,180 jobs and no
warnings after final cleanup. Temporary source-local private consumers compiled
the empty, all-zero, singleton, constant-ratio, and nonconstant-ratio cases and
were deleted before the final build. An external negative consumer confirmed
that both guarded Real helpers are inaccessible. The placeholder,
public-surface, root-import-isolation, and diff checks passed. No public naming
or Future Work entry is justified. C7.04 remains approval-gated.

### C7.04 - Extended Log-Sum Term And Non-Bottom Calculus

**Status:** complete

**Objective and reason:** Introduce the canonical zero-safe EReal term and
prove the safety facts needed for finite sums containing `top`.

**Prerequisites:** C7.03.

**Verified declarations to reuse:** The private guarded Real engines for later
conversion; no existing public project term.

**Verified mathlib APIs:** `ENNReal.log_zero`, `ENNReal.log_top`,
`ENNReal.log_pos_real`, `EReal.zero_mul`, `EReal.mul_top_of_pos`,
`EReal.coe_ennreal_mul_top`, `EReal.coe_ennreal_ne_bot`,
`EReal.add_top_of_ne_bot`, and finite-sum induction.

**Proposed declarations:** All tentative:

- `logSumTerm (a b : NNReal) : EReal`;
- `logSumTerm_zero_left`;
- `logSumTerm_pos_zero`;
- `logSumTerm_ne_bot`;
- `sum_logSumTerm_ne_bot`.

The intended definition is mathematically
`a * ENNReal.log (a / b)`, with explicit coercions through ENNReal/EReal as
needed by elaboration.

**Target files, namespaces, and imports:** Extend
`LeanInfoTheory/Shannon/LogSum.lean` in
`LeanInfoTheory.Shannon`. Add `Mathlib.Data.EReal.Operations` directly if the
proof uses its multiplication/top lemmas.

**Strategy:** Prove the four atomic cases before any larger algebra:

- `a = 0`: multiplication by zero gives zero, including `0/0`;
- `a != 0` and `b = 0`: the ratio and log are `top`, so the term is `top`;
- `a != 0` and `b != 0`: the term is a finite Real coercion;
- every case is different from `bottom`.

Prove finite-sum non-bottom by Finset induction using the atomic invariant.

**Edge cases:** `0/0`; `0/b`; `a/0`; finite positive ratios below, at, and
above one; negative finite logarithms; `top` plus finite negative terms;
empty finite sum; no `bottom` summand.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.LogSum
```

Compile direct reductions for all atomic cases and the empty/singleton sums.
Do not assign `[simp]` broadly before C7.19.

**Definition of done:** The term computes with the accepted conventions and
both the term and every finite selected sum are proved never `bottom`.

**Downstream effect:** Makes C7.05's unconditional inequality and C7.06's
equality statement safe.

**Documentation implications:** The public definition docstring must state
the `0/0`, zero-over-positive, and positive-over-zero conventions explicitly.

**Risk level:** Critical.

**Fallback strategy:** Adjust coercion spelling or private case lemmas only.
Do not replace EReal with Real/ENNReal or encode positive-over-zero by a finite
sentinel.

**Implementation outcome (2026-07-29):** Complete.
`LeanInfoTheory/Shannon/LogSum.lean` now exposes exactly the approved
extended-scalar surface: `logSumTerm`, `logSumTerm_zero_left`,
`logSumTerm_pos_zero`, `logSumTerm_ne_bot`, and
`sum_logSumTerm_ne_bot`. The definition uses an NNReal coefficient coerced
through ENNReal into EReal and `ENNReal.log` of the ENNReal ratio. Its docstring
records that every zero numerator contributes zero, including `0/0`, while a
positive numerator over zero contributes `top`.

The two atomic reduction theorems prove those conventions directly.
`logSumTerm_ne_bot` uses the exact four-clause characterization
`EReal.mul_ne_bot`: the coefficient is finite, nonnegative, and never
`bottom`, while a nonzero numerator makes the ENNReal ratio nonzero and hence
its logarithm non-bottom. This also covers finite negative logarithms and the
positive-over-zero `top` case without unsafe extended-real rearrangement.
`sum_logSumTerm_ne_bot` then uses Finset induction and
`EReal.add_ne_bot_iff`; it covers the empty sum and sums containing `top` plus
finite negative terms.

`lake build LeanInfoTheory.Shannon.LogSum` passed with 2,180 jobs and no
warnings. A direct-import consumer verified `0/0`, zero-over-positive,
positive-over-zero, the exact finite Real formula for nonzero NNReal pairs,
ratios below, at, and above one, empty and singleton sums, and a mixed
top/finite sum; it was deleted afterward. The public theorem axiom audit found
only `propext`, `Classical.choice`, and `Quot.sound`. The placeholder,
public-surface, no-premature-simp, root-import-isolation, and whitespace checks
passed. No import changed, and no public name is unusually long,
hard-to-discover, or representation-exposing, so no Future Work Note 14 entry
is justified. C7.05 remains approval-gated.

### C7.05 - Canonical Extended Log-Sum Inequality

**Status:** complete

**Objective and reason:** Publish the unconditional zero-safe finite log-sum
inequality over an arbitrary Finset.

**Prerequisites:** C7.02 and C7.04.

**Verified declarations to reuse:** C7.02's private guarded Real inequality
and C7.04's term and non-bottom calculus.

**Verified mathlib APIs:** EReal order and coercion lemmas, ENNReal division
zero/top behavior, `ENNReal.log_pos_real`, Finset sums, and
`ENNReal.toReal_sum`.

**Proposed declarations:** Tentatively `logSum_inequality`, with orientation:

```text
logSumTerm (sum i in s, a i) (sum i in s, b i)
  <= sum i in s, logSumTerm (a i) (b i)
```

**Target files, namespaces, and imports:** Extend
`LeanInfoTheory/Shannon/LogSum.lean`; no new project import.

**Strategy:** Split on whether any selected index is
positive-over-zero.

- If one exists and the total denominator is positive, the right side is
  `top` while the aggregate term is finite, so the inequality is immediate.
- If the total denominator is zero and the total numerator is positive, both
  the aggregate and at least one summand are `top`; use the non-bottom sum
  invariant to normalize the right side safely.
- If no positive-over-zero occurs, apply the private guarded Real inequality
  and transport it through EReal coercions.

Avoid subtraction or rearrangement across `top`.

**Edge cases:** Every C7.01 scalar case; especially mixed
positive-over-zero plus finite terms, total denominator zero, all-zero and
empty sums, and finite negative summands next to `top`.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.LogSum
```

Compile an ignored direct-import consumer for each extended branch and delete
it.

**Definition of done:** The exact unconditional inequality compiles with no
guard, no `Fintype`, and no unsafe EReal algebra.

**Downstream effect:** Supplies the canonical scalar engine for KL convexity.

**Documentation implications:** Add a theorem docstring that matches the
textbook orientation and refers to the term's documented zero conventions.

**Risk level:** Critical.

**Fallback strategy:** Follow the proof-complete C7.01 case split. Any need to
weaken the theorem or omit an extended branch requires an approved revision.

**Implementation outcome (2026-07-29):** Complete.
`LeanInfoTheory/Shannon/LogSum.lean` now exposes the unconditional theorem
`logSum_inequality` with the approved orientation

```text
logSumTerm (sum i in s, a i) (sum i in s, b i)
  <= sum i in s, logSumTerm (a i) (b i).
```

Its signature has only an arbitrary `s : Finset iota` and NNReal families
`a`, `b`; it has no support guard, `[Fintype iota]`, or other typeclass
assumption. If a selected pair is positive-over-zero, the proof isolates that
summand with `Finset.add_sum_erase`. C7.04's non-bottom sum invariant then
justifies `top + remainder = top`, so the result follows without rearranging
extended values. If no such pair exists, the negated witness supplies the
guard expected by C7.02. A zero total denominator is handled as the forced
all-zero case; otherwise local finite-conversion calculations transport the
private guarded Real inequality through `EReal.coe_le_coe`.

`lake build LeanInfoTheory.Shannon.LogSum` passed with 2,180 jobs and no
warnings. A direct-import branch matrix compiled the empty, all-zero, `0/0`,
zero-over-positive, finite positive-ratio, positive-over-zero, mixed
top/finite-negative, zero-total-denominator, and arbitrary-`Finset Nat` cases,
then was deleted. The exported signature audit confirmed the absence of
`Fintype` and guards. Its axiom audit found only `propext`,
`Classical.choice`, and `Quot.sound`. The placeholder, public-surface,
no-premature-simp, root-import-isolation, disposable-artifact, and whitespace
checks passed. No import changed, no public helper was added, and
`logSum_inequality` is concise and textbook-facing, so no Future Work Note 14
entry is justified. C7.06 remains approval-gated.

### C7.06 - Extended Equality And Coherent Public LS3 API

**Status:** complete

**Objective and reason:** Complete LS3 with the full zero-safe equality
characterization and publish exactly one guarded Real inequality/equality
family.

**Prerequisites:** C7.03--C7.05.

**Verified declarations to reuse:** All private guarded Real infrastructure
and public extended term/inequality results from C7.02--C7.05.

**Verified mathlib APIs:** Strict-Jensen equality, ENNReal ratio and top
behavior, EReal coercion injectivity away from infinities, and finite-sum
equality tools.

**Proposed declarations:** All tentative:

- `logSum_eq_iff_exists_constant_ratio`;
- `real_logSum_inequality_of_support`;
- `real_logSum_eq_iff_exists_constant_ratio_of_support`.

The extended equality condition is:

```text
exists c : ENNReal,
  forall i in s,
    (a i != 0 or b i != 0) ->
      (a i : ENNReal) / (b i : ENNReal) = c
```

**Target files, namespaces, and imports:** Complete
`LeanInfoTheory/Shannon/LogSum.lean`.

**Strategy:** Prove equality by the same exhaustive top/finite split validated
in C7.01. In the finite branch, use C7.03. In the total-denominator-zero
branch, equality holds exactly when all active ratios are `top`; in the
all-zero branch the active condition is vacuous. For the public Real family,
expose the exact support guard and reuse the private proofs rather than
creating a second near-duplicate API.

**Edge cases:** Empty active set; existential ratio witness when `s` is empty;
all-zero; all zero-over-positive; all positive-over-zero; mixed top/finite;
singleton; finite constant ratio including zero; nonconstant ratios; support
guard equivalence `a != 0 -> b != 0`.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.LogSum
```

Compile positive direct-import consumers for extended and guarded Real APIs,
verify no names are root-reachable through `LeanInfoTheory`, run the
placeholder scan, and run `git diff --check`.

**Definition of done:** LS3 is complete: canonical inequality, full equality,
edge laws, non-bottom invariants, and one practical guarded Real family all
compile. No private auxiliary is public.

**Downstream effect:** Unlocks the C7.07 binary KL feasibility gate and all
later scalar consumers.

**Documentation implications:** Record the exact public declaration list and
the fact that guarded Real results are corollaries of one zero-safe contract.
Fintype/univ wrappers remain optional and are not completion criteria unless a
real consumer appears.

**Risk level:** Critical.

**Fallback strategy:** No LS1-only fallback is approved. If the full equality
or conversion cannot be completed, stop and request a material plan revision.

**Implementation outcome (2026-07-29):** Complete. The scalar LS3 block now
exposes the three approved declarations:

- `logSum_eq_iff_exists_constant_ratio`;
- `real_logSum_inequality_of_support`;
- `real_logSum_eq_iff_exists_constant_ratio_of_support`.

The extended equality theorem has exactly the approved active-component
contract over an arbitrary `s : Finset iota`: there is one common ENNReal
ratio for every selected pair other than `(0, 0)`. Its proof separates the
genuinely extended branch from the finite branch. If a positive-over-zero
component occurs, equality forces every active denominator to vanish and the
common witness is `top`; conversely that common top ratio makes both sides
`top`. If no such component occurs, a zero total denominator is the all-zero,
vacuous-active-set case. A nonzero total denominator is transported through
the C7.03 guarded strict-Jensen equality theorem, with an active selected
denominator used as the finite ratio anchor.

Repeated C7.05/C7.06 proof pressure justified three private conversion helpers
for an individual finite term, a support-compatible finite sum, and a sum
containing a positive-over-zero term. C7.05's proof now reuses those private
helpers without changing its public statement. A fourth private bridge proves
equivalence of ENNReal and Real ratio equalities under nonzero denominators.
No auxiliary is public. The two guarded Real declarations are thin public
wrappers around the C7.02 and C7.03 proof engines and retain the exact
`a i != 0 -> b i != 0` guard, so selected `(0, 0)` pairs remain legal.

`lake build LeanInfoTheory.Shannon.LogSum` passed with 2,180 jobs and no
warnings. A warning-free direct-import consumer exercised empty and all-zero
families, zero-over-positive, finite constant ratios, all
positive-over-zero, singleton selection, mixed top/finite ratios, unequal
finite ratios, both guarded Real declarations, and an arbitrary `Finset Nat`;
it was deleted afterward. Signature and axiom inspection confirmed no
`Fintype` or stronger guard and only `propext`, `Classical.choice`, and
`Quot.sound`. Negative consumers confirmed that all four new conversion
helpers are private and that the opt-in module is not root-reachable; they
were deleted afterward. The public-surface, no-premature-simp, placeholder,
disposable-artifact, root-isolation, and whitespace audits passed.

The public names are systematic and textbook-facing. The long but exact
`real_logSum_eq_iff_exists_constant_ratio_of_support` remains unchanged for
the scheduled C7.19 naming review; no compatibility alias or new Future Work
item is justified during this active theorem step. No canonical project-memory
file or import boundary changed. C7.07 remains approval-gated.

### C7.07 - Binary Support-Aware KL Equality Feasibility Gate

**Status:** complete

**Objective and reason:** Prove the complete approved binary KL equality
contract in a disposable Lean consumer before production mixture or KL
convexity work.

**Prerequisites:** C7.06 is complete.

**Verified declarations to reuse:** `logSum_inequality`,
`logSum_eq_iff_exists_constant_ratio`,
`toMeasure_absolutelyContinuous_iff_support_subset`,
`klDiv_pmf_ne_top_iff_support_subset`,
`toReal_klDiv_pmf_eq_sum`, `PMF.bernoulli`, and `PMF.bind`.

**Verified mathlib APIs:** `PMF.bernoulli_apply`, `PMF.bind_apply`,
`PMF.support_bind`, `ENNReal.toReal_le_toReal`,
`ENNReal.toReal_sum`, and finite-sum equality/nonnegativity lemmas.

**Proposed declarations:** None in production. The disposable consumer uses a
local BP3a binary mixture definition and proves the exact future C7.15 theorem
and its guarded Real companion.

**Target files, namespaces, and imports:** Use a verified ignored disposable
file and delete it. Import `Shannon.LogSum`, the existing KL/product bridge,
and only the PMF/channel support needed by the candidate proof.

**Strategy:** For `0 < t` and `t < 1`, and
`p1.support subset q1.support`,
`p2.support subset q2.support`, compile a complete proof that equality in
binary KL convexity is equivalent to:

```text
forall x, p1 x * q2 x = p2 x * q1 x
```

Expand finite Real KL under support inclusion, apply the scalar log-sum
equality pointwise, sum nonnegative gaps, translate common ratios into the
cross-product condition, and lift the finite equality back to ENNReal.
Compile the Real iff as well. No implication or boundary case may be left as
an implementation promise.

**Edge cases:** Both reference masses zero; exactly one reference mass zero;
corresponding numerator forced zero by support; both references positive with
one numerator zero; disjoint supports; equal laws; unequal ratios; interior
NNReal coercions; exclusion of endpoints; no `top = top` degeneracy.

**Focused validation:**

```powershell
lake env lean <ignored-kl-equality-feasibility-file>
git diff --check
```

Verify deletion of the spike and absence of production change.

**Definition of done:** The exact ENNReal and guarded Real binary equality iff
statements compile proof-completely under the accepted hypotheses.

**Downstream effect:** Authorizes C7.08 only after explicit user approval.

**Documentation implications:** Update only the C7.07 outcome in this plan.

**Risk level:** Critical.

**Fallback strategy:** Any failure stops the implementation sequence. Do not
drop equality, add global positivity, replace support with full support, or
admit only one direction without explicit approval.

**Implementation outcome (2026-07-29):** Complete. A proof-complete ignored
consumer established both approved future C7.15 contracts over an arbitrary
finite alphabet:

```text
klDiv (binaryMixture t ht p1 p2) (binaryMixture t ht q1 q2)
    = t * klDiv p1 q1 + (1 - t) * klDiv p2 q2
  iff
forall x, p1 x * q2 x = p2 x * q1 x
```

and the corresponding equality after applying `ENNReal.toReal` to each KL
term. The exact assumptions were only `0 < t`, `t < 1`,
`p1.support subset q1.support`, and
`p2.support subset q2.support`, in addition to the BP3a proof `ht : t <= 1`
and the existing finite measurable-singleton typeclasses. No full-support,
positive-atom, common-support, or endpoint assumption was introduced.

The spike defined the BP3a mixture locally through `PMF.bernoulli` and
`PMF.bind` and proved its pointwise weighted-sum law. At each output atom, it
converted finite PMF masses to NNReal, applied C7.06's guarded Real log-sum
inequality and equality, and proved that the active common-ratio condition is
equivalent to the cross-product law. That equivalence was established by
explicit branches for both reference masses zero, exactly one reference mass
zero, and both reference masses nonzero. Component support inclusion supplied
exactly the forced zero numerators needed in the boundary branches.

For the global Real iff, finite KL expansions turned both sides into atomwise
sums. The scalar inequality made every right-minus-left gap nonnegative, so
equality of the finite sums forced every pointwise gap to vanish; the scalar
equality iff then yielded the cross-product condition. The reverse direction
used pointwise equality and `Finset.sum_congr`.

For the canonical ENNReal iff, the spike separately proved component-mixture
support transport, finiteness of both component KL terms, finiteness of the
mixed KL term, and finiteness of the weighted right side. Only then did it use
`ENNReal.toReal_eq_toReal_iff'` to transfer the complete Real iff. Thus neither
direction can be satisfied accidentally through `ENNReal.toReal top = 0`, and
no uninformative `top = top` equality remains.

`lake env lean tmp/codex-handoffs/c7-07-kl-equality-feasibility.lean` passed
without warnings. Maintained-in-spike consumers covered equal component laws,
disjoint supports, a three-point law with a both-reference-zero atom,
one-sided-zero-reference atoms, and unequal finite ratios; both the ENNReal and
Real unequal-ratio equalities were rejected. Printed signatures confirmed the
exact approved assumptions. Both feasibility theorems depended only on
`propext`, `Classical.choice`, and `Quot.sound`. Placeholder, production-name,
and whitespace checks passed. The ignored consumer was deleted, and no Lean
source, import, public declaration, simp attribute, root exposure, or
canonical project-memory file changed.

The proof gives concrete implementation guidance for C7.11 and C7.15:
PMF-mass-to-NNReal conversion, component-mixture support transport, finite KL
sum normalization, and the zero-safe ratio/cross-product bridge should remain
private unless independent downstream pressure appears. No new public-name
audit or Future Work item is justified. C7.08 remains approval-gated.

### C7.08 - Production Finite-Mixture API

**Status:** complete

**Objective and reason:** Add the reusable binary PMF mixture construction
after both high-risk contracts are known to be feasible.

**Prerequisites:** C7.07.

**Verified declarations to reuse:** `PMF.bind`, `PMF.ext`, and the existing
`Probability.Finite` PMF support.

**Verified mathlib APIs:** `PMF.bernoulli`, `PMF.bernoulli_apply`,
`PMF.support_bernoulli`, `PMF.bind_apply`, `PMF.bind_bind`,
`PMF.bind_comm`, `ENNReal.coe_sub`.

**Proposed declarations:** All tentative:

- `PMF.binaryMixture (t : NNReal) (ht : t <= 1) (p q : PMF alpha)`;
- `PMF.binaryMixture_apply`;
- `PMF.binaryMixture_zero`;
- `PMF.binaryMixture_one`.

The definition is:

```text
(PMF.bernoulli t ht).bind (fun b => if b then p else q)
```

**Target files, namespaces, and imports:** Create
`LeanInfoTheory/Probability/FiniteMixture.lean` in namespace `PMF`, importing
only `LeanInfoTheory.Probability.Finite` and the exact PMF monad/construction
support needed.

**Strategy:** Define the binary mixture through the Bernoulli selector. Prove
the pointwise formula and endpoints by PMF extensionality and Bernoulli/bind
computation. Keep general selector use as `r.bind P`; do not add a synonym.

**Edge cases:** `t = 0`; `t = 1`; `0 < t < 1`; NNReal truncated subtraction;
coercion of `1 - t` to ENNReal and Real; proof irrelevance for different
proofs of `t <= 1`; zero-mass components; singleton output alphabets; no
constructed `PMF Empty`.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Probability.FiniteMixture
```

Compile a direct-import consumer for endpoint and pointwise laws and a
root-only negative consumer showing `PMF.binaryMixture` is not exposed.

**Definition of done:** The four intended declarations compile with no entropy
or semantic import, endpoint laws are proof-irrelevant, and the root remains
isolated.

**Downstream effect:** Supplies all binary corollaries and the shared
finite-selector surface for C7.09 onward.

**Documentation implications:** Explain true/false weight orientation in the
definition docstring. Defer simp attributes to C7.19.

**Risk level:** Medium.

**Fallback strategy:** Adjust theorem binder/proof presentation only. Do not
switch to Real coefficients, a subtype parameter, or a custom general mixture
structure.

**Implementation outcome (2026-07-29):** Complete.
`LeanInfoTheory/Probability/FiniteMixture.lean` now provides exactly the four
approved declarations in namespace `PMF`:

- `binaryMixture`;
- `binaryMixture_apply`;
- `binaryMixture_zero`;
- `binaryMixture_one`.

The definition has the approved BP3a contract
`(t : NNReal) (ht : t <= 1)` and is the Bernoulli bind that selects the first
component on `true` and the second component on `false`. Its docstring records
that orientation explicitly. The pointwise theorem computes the resulting mass
as

```text
(t : ENNReal) * p a + ((1 - t : NNReal) : ENNReal) * q a.
```

The two endpoint theorems quantify over the supplied bound proof and establish
weight zero as the second component and weight one as the first component.
Their proofs use PMF extensionality and the pointwise formula. The module is a
noncomputable section because mathlib's `PMF.bind` is noncomputable; this is a
local implementation requirement and does not change the approved API.
General selector mixtures remain the existing `r.bind P`; no synonym,
coefficient forwarding family, support wrapper, or custom mixture structure
was added.

`lake build LeanInfoTheory.Probability.FiniteMixture` passed with 1,698 jobs
and no warnings. A warning-free direct-import consumer checked the pointwise
orientation, both endpoints, equality under two proofs of `t <= 1`, a
zero-mass second component, the concrete half-weight Bernoulli orientation,
and a singleton output alphabet; it was deleted afterward. Signature
inspection confirmed the absence of `Fintype`, entropy, semantic, or
measurability assumptions. All four declarations depend only on `propext`,
`Classical.choice`, and `Quot.sound`.

Negative consumers confirmed that neither `LeanInfoTheory` nor
`LeanInfoTheory.Probability.Finite` exposes the opt-in child module; they were
deleted afterward. The module imports only
`LeanInfoTheory.Probability.Finite`. The exact four-declaration surface,
placeholder, no-premature-simp, root-isolation, disposable-artifact, and
whitespace checks passed. The names are concise, conventional, and expose the
mathematical PMF construction rather than proof machinery, so no Future Work
Note 14 entry or compatibility alias is justified. No canonical
project-memory file or existing import changed. C7.09 remains approval-gated.

### C7.09 - General-Selector Entropy Concavity By Jensen

**Status:** complete

**Objective and reason:** Prove the reusable finite-selector entropy
concavity theorem directly from finite Jensen, independently of the log-sum
module.

**Prerequisites:** C7.08.

**Verified declarations to reuse:** `entropy`, `entropy_eq_sum`,
`PMF.sum_toReal`, `PMF.toReal_nonneg`, and `PMF.binaryMixture` only for later
corollaries.

**Verified mathlib APIs:** `PMF.bind_apply`,
`Real.concaveOn_negMulLog`, `ConcaveOn.le_map_sum`,
`ENNReal.toReal_sum`, and `ENNReal.toReal_mul`.

**Proposed declarations:** Tentatively `sum_mul_entropy_le_entropy_bind`:

```text
sum i, (r i).toReal * entropy (P i)
  <= entropy (r.bind P)
```

for finite selector and output alphabets.

**Target files, namespaces, and imports:** Create
`LeanInfoTheory/Shannon/EntropyConcavity.lean` in
`LeanInfoTheory.Shannon`. Import `Shannon.Entropy`,
`Probability.FiniteMixture`, and finite Jensen directly. Do not import
`Shannon.LogSum`.

**Strategy:** Rewrite entropy and the finite bind mass pointwise. For each
output atom, apply concavity of `Real.negMulLog` to selector weights
`(r i).toReal` and component masses `(P i x).toReal`. Sum the resulting
inequalities and exchange finite sums.

**Edge cases:** Zero selector weights; component atoms of zero mass; singleton
selector; singleton output; syntactically empty selector type with no
constructible PMF; no `[Nonempty selector]` or unnecessary full-support
assumption; finite-toReal coercions.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.EntropyConcavity
```

Compile singleton-selector and zero-weight Bool consumers. Confirm the module
does not import `Shannon.LogSum` and remains root-isolated.

**Definition of done:** The general inequality compiles with no selector
support or positivity guard and no general equality theorem.

**Downstream effect:** Supplies C7.10 and C7.16.

**Documentation implications:** State that the theorem is the finite-selector
generalization of textbook binary entropy concavity and that its proof uses
direct Jensen.

**Risk level:** Medium.

**Fallback strategy:** Use a private finite-mass conversion helper if repeated
coercions obscure the proof. Do not route through log-sum or add a public
general equality classification.

**Implementation outcome (2026-07-29):** Complete.
`LeanInfoTheory/Shannon/EntropyConcavity.lean` now exposes exactly one
declaration:

```text
sum_mul_entropy_le_entropy_bind :
  sum i, (r i).toReal * entropy (P i) <= entropy (r.bind P).
```

Its signature has only finite selector and output alphabets, a selector PMF,
and a PMF-valued family. It has no `Nonempty`, selector-support, positive-weight,
full-support, measurability, or equality assumption.

The proof is direct finite Jensen. For each output atom, the selector masses
`(r i).toReal` are nonnegative and sum to one, while the component masses
`(P i a).toReal` lie in `Set.Ici 0`. Applying
`Real.concaveOn_negMulLog.le_map_sum` gives the pointwise entropy-term
inequality. A theorem-local calculation rewrites the bind mass through
`PMF.bind_apply`, `tsum_fintype`, `ENNReal.toReal_sum`, and
`ENNReal.toReal_mul`. The proof then sums over output atoms and commutes the
two finite sums. No scalar log-sum result, support argument, or KL bridge is
used, and no conversion helper was promoted.

The new opt-in module imports only
`LeanInfoTheory.Probability.FiniteMixture`,
`LeanInfoTheory.Shannon.Entropy`, and
`Mathlib.Analysis.Convex.Jensen`; in particular, it does not import
`Shannon.LogSum`.

`lake build LeanInfoTheory.Shannon.EntropyConcavity` passed with 2,232 jobs
and no warnings. Warning-free direct consumers exercised a singleton selector,
a zero-weight Bool component, and a singleton output alphabet. Signature and
axiom inspection confirmed the exact assumptions and only `propext`,
`Classical.choice`, and `Quot.sound`. Negative consumers confirmed that the
theorem is unavailable through both `LeanInfoTheory` and
`LeanInfoTheory.Shannon.Entropy`, and that importing the new module does not
make `logSum_inequality` reachable; they were deleted afterward.

The one-theorem surface, placeholder, no-general-equality,
no-premature-simp, root-isolation, disposable-artifact, and whitespace checks
passed. `sum_mul_entropy_le_entropy_bind` follows the established mathematical
orientation and uses the canonical PMF `bind`, so no Future Work Note 14 entry
or alias is justified. No canonical project-memory file or existing import
changed. C7.10 remains approval-gated.

### C7.10 - Binary Entropy Concavity And Strict Equality

**Status:** complete

**Objective and reason:** Publish the textbook binary entropy inequality and
the approved interior equality characterization.

**Prerequisites:** C7.09.

**Verified declarations to reuse:** `sum_mul_entropy_le_entropy_bind`,
`PMF.binaryMixture`, and its pointwise law.

**Verified mathlib APIs:** `Real.strictConcaveOn_negMulLog`,
`StrictConcaveOn.map_sum_eq_iff`,
`StrictConcaveOn.map_sum_eq_iff'`, Finset sum equality from pointwise
nonnegative gaps, and `PMF.ext`.

**Proposed declarations:** Tentative:

- `binaryMixture_entropy_concave`;
- `binaryMixture_entropy_eq_iff`.

The equality theorem assumes `0 < t` and `t < 1` and characterizes equality by
`p = q`.

**Target files, namespaces, and imports:** Extend
`LeanInfoTheory/Shannon/EntropyConcavity.lean`.

**Strategy:** Derive the inequality from C7.09 specialized to the Bernoulli
selector. For equality, use strict concavity at each output mass with both
weights positive. Show equality of the finite entropy sum forces every
pointwise Jensen gap to vanish, then use PMF extensionality. Prove the reverse
direction by substitution.

**Edge cases:** `t = 0` and `t = 1` remain valid inequality endpoints but are
excluded from the iff; zero component masses need no full-support assumption;
singleton output alphabet; `p = q`; distinct PMFs; proof arguments for
`t <= 1`.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.EntropyConcavity
```

Compile interior equality, endpoint inequality, equal-law, and unequal-law
consumers.

**Definition of done:** Both binary textbook declarations compile, and the
only equality theorem in this module is the approved interior binary result.

**Downstream effect:** Completes entropy concavity and supplies examples and
MI input-law intuition.

**Documentation implications:** Record whether this independent strict-Jensen
consumer triggers a useful helper under Future Work Note 24. Do not extract or
publish one automatically.

**Risk level:** High.

**Fallback strategy:** Keep the strict-Jensen setup local if no coherent
shared helper emerges. Any weakening of `p = q` or added positivity assumption
on PMF atoms requires review.

**Implementation outcome (2026-07-29):** Complete.
`LeanInfoTheory/Shannon/EntropyConcavity.lean` now additionally exposes:

```text
binaryMixture_entropy_concave :
  t * entropy p + (1 - t) * entropy q
    <= entropy (PMF.binaryMixture t ht p q)

binaryMixture_entropy_eq_iff :
  0 < t -> t < 1 ->
  (t * entropy p + (1 - t) * entropy q
    = entropy (PMF.binaryMixture t ht p q) <-> p = q).
```

Here the displayed coefficients suppress the declaration's explicit
`NNReal`-to-`Real` coercions. The inequality is the direct Bool-selector
specialization of `sum_mul_entropy_le_entropy_bind`, so it includes both
endpoints and requires no support or atom-positivity assumption.

For the equality theorem, the proof rewrites the assumed entropy equality as
equality between two finite sums of pointwise Jensen terms. The existing
pointwise concavity inequalities and
`Finset.sum_eq_sum_iff_of_le` force equality at every output atom.
`Real.strictConcaveOn_negMulLog.map_sum_eq_iff`, applied to the two strictly
positive Bernoulli weights, then identifies the component masses pointwise;
`ENNReal.toReal_eq_toReal_iff'` and `PMF.ext` yield `p = q`. The reverse
direction uses `PMF.bind_const` and the fact that the two real coefficients
sum to one. Zero component masses are admitted throughout.

`lake build LeanInfoTheory.Shannon.EntropyConcavity` passed with 2,232 jobs.
Disposable consumers compiled the two endpoint inequalities, the equal-law
interior case, a distinct pair of pure Bool laws (which cannot attain
equality), and a singleton output alphabet. Signature and axiom inspection
confirmed the intended assumptions and only `propext`, `Classical.choice`,
and `Quot.sound`. Negative consumers confirmed root and base-entropy
isolation, and that importing this module still does not expose
`logSum_inequality`; all disposable files were deleted.

The module now has exactly three public theorems and exactly the one approved
binary equality theorem. Neither new declaration is a simp rule. The names
are systematic, discoverable, and do not expose proof machinery, so no Future
Work Note 14 entry is justified.

This proof is a second independent production use of strict Jensen for an
entropy equality case, so Future Work Note 24 now has genuine review pressure.
No helper was extracted here: the existing note's bounds-layer
constant-mass helper would not be reusable by this lower, separately
importable module without an undesirable dependency. C7.19 should decide
whether a coherent lower-layer abstraction exists; C7.20 should reconcile
that conclusion in canonical project memory. No canonical memory or import
aggregate changed. C7.11 remains approval-gated.

### C7.11 - Private KL Support, Finiteness, And `toReal` Infrastructure

**Status:** complete

**Objective and reason:** Lock the four private bridges required to prove
canonical ENNReal KL convexity without an unavailable extended PMF KL
expansion.

**Prerequisites:** C7.06 and C7.08.

**Verified declarations to reuse:** `PMF.support_bind`,
`toMeasure_absolutelyContinuous_iff_support_subset`,
`klDiv_pmf_ne_top_iff_support_subset`,
`toReal_klDiv_pmf_eq_sum`, `logSum_inequality`,
`PMF.sum_toReal`, and `PMF.apply_ne_top`.

**Verified mathlib APIs:** `PMF.mem_support_bind_iff`,
`ENNReal.toReal_sum`, `ENNReal.toReal_mul`,
`ENNReal.toReal_le_toReal`, top multiplication behavior, and finite Finset
sum bounds.

**Proposed declarations:** No public declarations. Private helpers must
establish:

1. a non-top weighted KL sum makes every active component KL non-top;
2. active component support inclusions imply support inclusion of the two
   selector mixtures;
3. `toReal` of the finite weighted KL sum is the corresponding Real weighted
   sum when non-top;
4. the mixed KL is non-top in that finite branch.

A private guarded finite Real KL-convexity calculation may be included here if
it cleanly packages the finite branch of C7.12.

**Target files, namespaces, and imports:** Create
`LeanInfoTheory/Shannon/SemanticBridge/Convexity.lean` in
`LeanInfoTheory.Shannon`. Import `Shannon.LogSum`,
`Shannon.EntropyConcavity`, `Probability.FiniteMixture`,
`Probability.FiniteChannel`,
`Shannon.SemanticBridge.KL`, and `Shannon.SemanticBridge.Product` directly as
used. Do not import the semantic aggregate into its own child.

**Strategy:** Work only over finite selector/output alphabets. Express active
components as `r i != 0`. Use bind support to transport component support,
the existing KL finiteness iff to move between support and non-top, and
unconditional `toReal_mul` plus guarded `toReal_sum` for the weighted RHS.
Keep every helper private until a second independent consumer demonstrates API
pressure.

**Edge cases:** Inactive component with KL `top` contributes `0 * top = 0`;
active component with KL `top` makes the RHS `top`; selector support not full;
zero-mass output atoms; empty selector type has no PMF; finite sums with one
top term; no accidental use of `toReal top = 0`.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity
```

Inspect the declaration surface to confirm every helper is private.

**Definition of done:** All four bridges compile with exact active-component
contracts and are sufficient to state and prove C7.12 without a new public KL
sum expansion.

**Downstream effect:** Supplies C7.12--C7.15 and C7.17.

**Documentation implications:** Add a source section comment explaining the
top/finite proof architecture, without exposing helper spellings.

**Risk level:** Critical.

**Fallback strategy:** Split private helpers more finely if Lean arithmetic
requires it. Do not add a public extended KL expansion, strengthen all
components to full support, or move these facts into the lightweight layer.

**Implementation outcome (2026-07-29):** Complete.
Created
`LeanInfoTheory/Shannon/SemanticBridge/Convexity.lean` with exactly four
source declarations, all private:

```text
component_klDiv_ne_top_of_weighted_sum_ne_top
support_bind_subset_of_active
toReal_sum_mul_klDiv_of_ne_top
klDiv_bind_ne_top_of_weighted_sum_ne_top
```

The first helper uses `ENNReal.sum_ne_top` to isolate the weighted term at an
active selector index, then
`ENNReal.lt_top_of_mul_ne_top_right` to show that component KL is finite. It
does not require output finiteness. The support helper rewrites both bind
supports with `PMF.mem_support_bind_iff`; a witness in the first mixture is
also a witness in the second because membership in the selector support makes
its weight nonzero. This helper requires no finiteness or measurable-space
assumption.

The third helper applies guarded `ENNReal.toReal_sum` to the finite weighted
KL sum and then unconditional `ENNReal.toReal_mul`. Its contract remains
correct when an inactive component KL is `top`: the corresponding ENNReal
product and Real product are both zero. It likewise needs only a finite
selector. The fourth helper combines active component finiteness, the
finite-PMF theorem `klDiv_pmf_ne_top_iff_support_subset`, and support transport
to prove that the mixed KL is non-top. It uses `[Finite alpha]`, rather than an
unnecessarily enumerating output `Fintype`.

No private guarded Real convexity calculation was added: the four approved
bridges compile independently and expose exactly the contracts needed by the
finite branch of C7.12. In particular, no helper converts a potentially top
weighted sum to Real, and no component support condition is imposed at a
zero-weight selector index.

The new module has the approved direct opt-in imports for finite channels,
finite mixtures, entropy concavity, scalar log-sum, KL, and product-law
infrastructure. Neither `LeanInfoTheory.lean` nor the semantic-bridge
aggregate imports it yet.

`lake env lean LeanInfoTheory/Shannon/SemanticBridge/Convexity.lean` passed.
The final
`lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity` passed with 2,703
jobs and no warnings. An expected-failure consumer confirmed that all four
private names are inaccessible after importing the module and was deleted.
The private-only surface, import isolation, placeholder, whitespace,
disposable-artifact, and `git diff --check` inspections passed.

There is no public-name or simp audit delta, no Future Work item is justified,
and no canonical project-memory file changed. C7.12 remains approval-gated.

### C7.12 - General-Selector ENNReal KL Joint Convexity

**Status:** complete

**Objective and reason:** Publish the canonical unconditional finite-selector
KL joint-convexity theorem.

**Prerequisites:** C7.11.

**Verified declarations to reuse:** The four C7.11 private bridges,
`logSum_inequality`, `toReal_klDiv_pmf_eq_sum`, and
`klDiv_pmf_ne_top_iff_support_subset`.

**Verified mathlib APIs:** `InformationTheory.klDiv`,
`ENNReal.toReal_le_toReal`, ENNReal top/order arithmetic, and finite sums.

**Proposed declarations:** Tentatively `klDiv_bind_le_sum`:

```text
klDiv (r.bind P).toMeasure (r.bind Q).toMeasure
  <= sum i, r i * klDiv (P i).toMeasure (Q i).toMeasure
```

with no support guard.

**Target files, namespaces, and imports:** Extend
`LeanInfoTheory/Shannon/SemanticBridge/Convexity.lean`.

**Strategy:** Split on whether the weighted RHS is `top`. The top branch is
immediate. In the finite branch, derive active component support inclusion,
mixed support inclusion, and finiteness; prove the corresponding Real
inequality from finite KL expansions and scalar log-sum; then lift it using
`ENNReal.toReal_le_toReal`.

**Edge cases:** Inactive top component; active top component; singleton
selector; zero-weight Bool selector; output support mismatch; both mixtures
equal; finite branch coercions; no support hypotheses in the public theorem.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity
```

Compile consumers with one inactive infinite-KL component and one active
finite component.

**Definition of done:** The unconditional ENNReal theorem compiles and handles
top values canonically without converting them to Real.

**Downstream effect:** Supplies guarded Real and binary KL corollaries and MI
channel convexity.

**Documentation implications:** State explicitly that `0 * top = 0` makes
inactive components harmless and that the theorem is canonical in ENNReal.

**Risk level:** Critical.

**Fallback strategy:** Reuse the validated top/finite architecture. A
support-guarded-only public theorem is not an approved substitute.

**Implementation outcome (2026-07-29):** Complete.
`LeanInfoTheory/Shannon/SemanticBridge/Convexity.lean` now exposes:

```text
klDiv_bind_le_sum :
  klDiv (r.bind P).toMeasure (r.bind Q).toMeasure
    <= sum i, r i * klDiv (P i).toMeasure (Q i).toMeasure
```

The exact typeclass contract is `[Fintype iota] [Finite alpha]`, together
with the finite-output measurable-space and measurable-singleton assumptions.
The output alphabet does not require a chosen public `Fintype`; the proof
constructs one privately only for finite KL expansions. There is no selector
support, active-component support, full-support, positivity, or global
finiteness hypothesis.

The proof follows the approved top/finite split. If the weighted component
sum is `top`, the ENNReal inequality is immediate. Otherwise, C7.11's private
bridges show that every active component KL and the mixed KL are non-top,
transport active support inclusion through `PMF.bind`, and safely convert the
weighted right side to Real.

The finite branch is packaged in one additional private helper,
`toReal_klDiv_bind_le_toReal_sum_of_ne_top`. It expands the mixed KL and each
active component KL with `toReal_klDiv_pmf_eq_sum`. For each output atom it
applies `real_logSum_inequality_of_support` to the NNReal masses

```text
(r i).toNNReal * (P i x).toNNReal
(r i).toNNReal * (Q i x).toNNReal.
```

The scalar support guard is derived only when the numerator product is
nonzero: this makes the selector component active, after which component KL
finiteness supplies the required support inclusion. Selector-weight
cancellation is split on `r i = 0`; the zero branch is simplified directly,
and the active branch uses a nonzero real selector mass. Thus neither `0/0`
nor `ENNReal.toReal top = 0` is used to justify an invalid cancellation.
Finite sums are then commuted, inactive component expansions disappear under
their zero weights, and `ENNReal.toReal_le_toReal` lifts the completed Real
inequality only after both ENNReal sides are known non-top.

Using the guarded Real member of the completed LS3 API, rather than converting
the extended theorem inside this already-finite branch, is a proof-level
refinement of the approved scalar log-sum strategy. The linter-driven
replacement of `[Fintype alpha]` by `[Finite alpha]` weakens the public
assumption without changing scope or mathematics.

`lake env lean LeanInfoTheory/Shannon/SemanticBridge/Convexity.lean` passed.
The final
`lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity` passed with 2,703
jobs and no warnings. A disposable direct-import consumer verified:

- an inactive disjoint-support component whose KL is `top`;
- the corresponding active-top selector branch;
- a singleton selector;
- equal component families;
- use with an output alphabet carrying only `[Finite]`.

Signature inspection confirmed the unconditional theorem contract. Its axiom
audit found only `propext`, `Classical.choice`, and `Quot.sound`. Expected
negative consumers confirmed that the theorem is not yet available from
either the lightweight root or the semantic-bridge aggregate; all disposable
files were deleted.

The public name is concise, follows the existing `klDiv_*_le_sum` vocabulary,
and exposes no support or scalar proof machinery, so no Future Work Note 14
entry or alias is justified. No simp attribute, canonical project-memory
change, aggregate import, or new Future Work item was added. C7.13 remains
approval-gated.

### C7.13 - Guarded Real KL Joint Convexity

**Status:** complete

**Objective and reason:** Publish the practical Real-valued general-selector
corollary with the weakest clean active-component support contract.

**Prerequisites:** C7.12.

**Verified declarations to reuse:** `klDiv_bind_le_sum`,
`klDiv_pmf_ne_top_iff_support_subset`, and the private C7.11 toReal bridge.

**Verified mathlib APIs:** `ENNReal.toReal_le_toReal`,
`ENNReal.toReal_sum`, `ENNReal.toReal_mul`, and PMF support membership.

**Proposed declarations:** Tentatively `toReal_klDiv_bind_le_sum`, with guard:

```text
forall i, r i != 0 -> (P i).support subset (Q i).support
```

**Target files, namespaces, and imports:** Extend the semantic convexity
module.

**Strategy:** Use the active support guard to prove both sides of C7.12 are
finite, apply `toReal` to the ENNReal inequality, and rewrite the weighted RHS
to a Real finite sum. Prefer this derivation over duplicating the scalar KL
calculation.

**Edge cases:** Inactive component with failed support inclusion; active
support inclusion; selector endpoint support; singleton selector; `toReal`
injectivity requires non-top on both sides; no global full-support assumption.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity
```

Compile a consumer where an inactive component has infinite KL but the Real
theorem remains applicable.

**Definition of done:** The Real theorem compiles with exactly active support
guards and no unsafe top conversion.

**Downstream effect:** Supplies binary Real corollaries and the finite KL route
for MI channel convexity.

**Documentation implications:** Document why the support guard is conditional
on selector activity.

**Risk level:** High.

**Fallback strategy:** An equivalent explicit hypothesis that the weighted
RHS is non-top may be used privately, but do not publish redundant guard
families without consumer pressure.

**Implementation outcome (2026-07-29):** Complete.
`LeanInfoTheory/Shannon/SemanticBridge/Convexity.lean` now also exposes:

```text
toReal_klDiv_bind_le_sum :
  (forall i, r i != 0 -> (P i).support subset (Q i).support) ->
  (klDiv (r.bind P).toMeasure (r.bind Q).toMeasure).toReal
    <= sum i, (r i).toReal *
      (klDiv (P i).toMeasure (Q i).toMeasure).toReal
```

Its typeclass contract matches C7.12:
`[Fintype iota] [Finite alpha]`, a measurable output alphabet, and measurable
singletons. The sole mathematical guard is support inclusion for active
selector components. In particular, no support condition is imposed on an
index with `r i = 0`, and there is no full-support or global component-KL
finiteness assumption.

The proof derives rather than duplicates C7.12. At an active index, the
support guard and `klDiv_pmf_ne_top_iff_support_subset` make component KL
non-top. At an inactive index, the weighted ENNReal term is zero even when
that component KL is `top`. Consequently every weighted term and their finite
sum are non-top; C7.11's mixed-finiteness bridge makes the left side non-top
as well. The proof applies `ENNReal.toReal_le_toReal` to
`klDiv_bind_le_sum` only after establishing both facts, then rewrites the
right side with `toReal_sum_mul_klDiv_of_ne_top`. No scalar KL calculation or
unsafe top conversion is repeated.

`lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity` passed with 2,703
jobs and no warnings. A disposable direct-import consumer proved the theorem
for a Bool selector whose inactive component has disjoint support and
infinite KL. Further consumers covered a singleton selector, equal component
families, and an output alphabet carrying only `[Finite]`. Signature
inspection confirmed the exact active-support contract. The theorem's axiom
audit found only `propext`, `Classical.choice`, and `Quot.sound`.

Expected negative consumers confirmed that the declaration is not yet
available through either the lightweight root or semantic-bridge aggregate;
all disposable files were deleted. The public-surface, no-simp, placeholder,
whitespace, import-isolation, artifact, and `git diff --check` inspections
passed.

The name follows `klDiv_bind_le_sum` directly and exposes no implementation
detail, so no Future Work Note 14 entry or compatibility alias is justified.
No plan deviation, canonical project-memory edit, aggregate import, or new
Future Work item was needed. C7.14 remains approval-gated.

### C7.14 - Binary KL Textbook Corollaries

**Status:** complete

**Objective and reason:** Provide discoverable binary forms of KL joint
convexity with correct endpoint behavior.

**Prerequisites:** C7.08, C7.12, and C7.13.

**Verified declarations to reuse:** `PMF.binaryMixture`,
`binaryMixture_apply`, `klDiv_bind_le_sum`, and
`toReal_klDiv_bind_le_sum`.

**Verified mathlib APIs:** Bernoulli mass/support formulas, NNReal subtraction,
and ENNReal/Real coercion of `t` and `1 - t`.

**Proposed declarations:** Tentative:

- `klDiv_binaryMixture_le`;
- `toReal_klDiv_binaryMixture_le`.

The ENNReal theorem is unconditional. The Real theorem uses active endpoint
guards:

```text
t != 0 -> p1.support subset q1.support
t != 1 -> p2.support subset q2.support
```

**Target files, namespaces, and imports:** Extend the semantic convexity
module.

**Strategy:** Specialize the selector theorems to
`PMF.bernoulli t ht` and the Bool-indexed pair of component laws. Normalize
the bind to `PMF.binaryMixture` and selector weights to `t` and `1 - t`.

**Edge cases:** `t = 0`; `t = 1`; interior `t`; only the active component
support is needed at an endpoint; inactive component KL may be top; proof
irrelevance for `ht`; NNReal/ENNReal/Real subtraction normalization.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity
```

Compile endpoint consumers that deliberately violate support inclusion in the
inactive component.

**Definition of done:** Both binary inequalities compile, the Real theorem has
active rather than unconditional component guards, and no equality theorem is
smuggled into this step.

**Downstream effect:** Supplies the textbook API and C7.15's equality
left-hand/right-hand expressions.

**Documentation implications:** State the endpoint guard behavior explicitly.

**Risk level:** Medium.

**Fallback strategy:** Keep the theorem as a direct specialization even if
the proof needs explicit Bool sum calculations. Do not strengthen endpoint
guards for convenience.

**Implementation outcome (2026-07-29):** Complete.
`LeanInfoTheory/Shannon/SemanticBridge/Convexity.lean` now exposes the two
binary textbook forms:

```text
klDiv_binaryMixture_le :
  klDiv (binaryMixture t ht p1 p2) (binaryMixture t ht q1 q2)
    <= t * klDiv p1 q1 + (1 - t) * klDiv p2 q2

toReal_klDiv_binaryMixture_le :
  (t != 0 -> p1.support subset q1.support) ->
  (t != 1 -> p2.support subset q2.support) ->
  toReal (klDiv (binaryMixture t ht p1 p2)
    (binaryMixture t ht q1 q2))
    <= t * toReal (klDiv p1 q1) +
      (1 - t) * toReal (klDiv p2 q2).
```

The displayed notation suppresses measure arguments and the explicit
NNReal-to-ENNReal/Real coefficient coercions. Both declarations require only
`[Finite alpha]` plus the finite measurable-singleton structure. The ENNReal
theorem is unconditional.

Each proof is a direct Bool-selector specialization: `PMF.bernoulli t ht`
selects the first component on `true` with weight `t` and the second on
`false` with weight `1 - t`. Simplification through
`PMF.binaryMixture`, `PMF.bernoulli_apply`, `Fintype.univ_bool`, and
`ENNReal.coe_sub` turns C7.12 and C7.13 into the textbook statements.

For the Real theorem, the general active-selector support guard is proved by
cases on Bool. A nonzero `true` mass rules out `t = 0` and therefore invokes
the first support implication. A nonzero `false` mass rules out `t = 1` and
invokes the second. Consequently, at `t = 0` the first component may have
failed support inclusion and infinite KL, while at `t = 1` the same is true
of the second component. No stronger endpoint contract was introduced.

`lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity` passed with 2,703
jobs and no warnings. Disposable consumers exercised:

- unconditional ENNReal convexity at `t = 0` with an inactive infinite-KL
  component;
- the Real theorem at `t = 0` with failed first-component support;
- the Real theorem at `t = 1` with failed second-component support;
- an interior half-weight with both support inclusions;
- proof irrelevance for two proofs of `t <= 1`.

Printed signatures confirmed the exact endpoint implications and
`[Finite alpha]` contract. Both axiom audits found only `propext`,
`Classical.choice`, and `Quot.sound`. Expected negative consumers confirmed
that neither theorem is available through the lightweight root or the
semantic-bridge aggregate; all disposable files were deleted.

The module now has four public KL-convexity inequalities and still no equality
theorem. Neither new declaration is a simp rule. Both names are concise,
parallel, and textbook-facing, so no Future Work Note 14 entry or alias is
justified. No plan deviation, canonical project-memory change, aggregate
import, or new Future Work item was needed. C7.15 remains approval-gated.

### C7.15 - Binary Support-Aware KL Equality

**Status:** complete

**Objective and reason:** Publish the approved exact binary KL convexity
equality case in ENNReal and guarded Real form.

**Prerequisites:** C7.07 and C7.14.

**Verified declarations to reuse:** The proof-complete C7.07 spike,
`logSum_eq_iff_exists_constant_ratio`,
`klDiv_binaryMixture_le`,
`toReal_klDiv_pmf_eq_sum`,
`klDiv_pmf_ne_top_iff_support_subset`, and existing KL-zero equality for
sanity corollaries only.

**Verified mathlib APIs:** Finset sum equality for nonnegative gaps,
ENNReal multiplication/cross multiplication under finite PMF masses,
`PMF.ext`, and toReal injectivity away from top.

**Proposed declarations:** Tentative:

- `klDiv_binaryMixture_eq_iff`;
- `toReal_klDiv_binaryMixture_eq_iff`.

Assumptions are `0 < t`, `t < 1`,
`p1.support subset q1.support`, and
`p2.support subset q2.support`. The conclusion is equality iff:

```text
forall x, p1 x * q2 x = p2 x * q1 x
```

**Target files, namespaces, and imports:** Extend the semantic convexity
module.

**Strategy:** Transfer the complete proof from C7.07 into production, sharing
private C7.11 infrastructure where helpful. Show pointwise scalar equality is
equivalent to the cross-product law in all support-boundary cases. Use support
inclusion to keep every KL finite and make the ENNReal and Real equalities
equivalent.

**Edge cases:** Both references zero; one reference zero; disjoint component
supports; zero numerators; both references positive; equal and unequal
ratios; interior weight; no endpoint or unguarded top equality.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity
```

Compile equal-law, disjoint-support, one-sided-zero-reference, and unequal
ratio consumers. Run the placeholder and public-name audits.

**Definition of done:** Both exact iff theorems compile under the accepted
hypotheses and no general-selector, MI, or channel equality theorem is added.

**Downstream effect:** Completes EQ2 and the KL part of finite Section 2.7.

**Documentation implications:** Explain that support guards exclude
uninformative `top = top` equalities. Audit the long names under Future Work
Note 14.

**Risk level:** Critical.

**Fallback strategy:** Use private pointwise lemmas if needed, preserving the
public iff exactly. Any one-direction-only or stronger-positivity fallback
requires explicit approval.

**Implementation outcome (2026-07-29):** Complete. The semantic convexity
module now exposes the two approved exact binary equality characterizations:

```text
klDiv_binaryMixture_eq_iff
toReal_klDiv_binaryMixture_eq_iff
```

Both retain the existing `[Finite alpha]`, finite measurable-singleton,
`t : NNReal`, and `ht : t <= 1` surface. They require the exact interior
hypotheses `0 < t` and `t < 1` together with
`p1.support subset q1.support` and `p2.support subset q2.support`. In both the
canonical `ENNReal` and guarded Real presentations, equality in the C7.14
binary KL-convexity expression is equivalent to the zero-safe pointwise law

```text
forall x, p1 x * q2 x = p2 x * q1 x.
```

The production proof transfers the proof-complete C7.07 argument without
strengthening its contract. Private scalar infrastructure specializes the
guarded Real log-sum equality theorem to the two interior weighted
components. Its common-ratio condition is equivalent to the cross-product law
by explicit cases on both reference masses: both zero, exactly one zero, or
both nonzero. Component support inclusion forces the corresponding numerator
to vanish in each null-reference branch, so no full-support or atom-positivity
assumption is needed.

At the PMF level, private mass-conversion lemmas identify binary-mixture
`NNReal` masses with the weighted scalar masses. The guarded Real KL
expansions turn global equality into equality of finite sums. Pointwise
log-sum inequalities make every scalar gap nonnegative, so a zero total gap
forces pointwise equality and hence the cross-product law; the reverse
direction is termwise. A private support-transport lemma proves the mixed KL
finite. The canonical theorem then uses component and mixture finiteness plus
`ENNReal.toReal` injectivity, avoiding every `top = top` ambiguity. The
enumeration-only private helpers use `[Finite alpha]` and install
`Fintype.ofFinite` locally.

`lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity` passed with 2,703
jobs and no warnings. A disposable direct-import consumer compiled equal-law,
disjoint-component-support, one-sided-zero-reference, and unequal-ratio
cases, exercising both public iff theorems. Printed signatures confirmed the
exact assumptions and conclusion. Both axiom audits found only `propext`,
`Classical.choice`, and `Quot.sound`; the repository-wide Lean placeholder
scan was clean. Expected negative consumers confirmed that the declarations
remain unavailable from the lightweight root and the semantic-bridge
aggregate, while a direct-import check confirmed that all equality helpers
remain private. All disposable files were deleted.

The two public names are long but form the direct, discoverable equality
continuation of `klDiv_binaryMixture_le` and
`toReal_klDiv_binaryMixture_le`; neither exposes scalar ratios, support
transport, or another implementation detail. No compatibility alias or
Future Work Note 14 entry is justified before the scheduled C7.19 coherent
API review. No general-selector, mutual-information, channel equality, simp
attribute, import change, canonical project-memory edit, or unapproved
fallback was introduced. C7.16 remains approval-gated.

### C7.16 - MI Input-Law Concavity And Channel Entropy Identity

**Status:** complete

**Objective and reason:** Prove the public fixed-channel entropy identity and
use it to establish MI concavity in the input law, including a binary
textbook corollary.

**Prerequisites:** C7.09 and the finite channel core.

**Verified declarations to reuse:** `PMF.channelJoint`,
`channelJoint_apply`, `channelJoint_map_fst`,
`channelJoint_map_snd`, `mutualInfo`,
`mutualInfo_eq_entropy_sndMarginal_sub_condEntropy_swap`,
`entropy`, and `sum_mul_entropy_le_entropy_bind`.

**Verified mathlib APIs:** `PMF.bind_apply`, `PMF.bind_bind`,
`PMF.bind_comm`, finite sum rearrangement, `ENNReal.toReal_sum`, and
`ENNReal.toReal_mul`.

**Proposed declarations:** All tentative:

- `mutualInfo_channelJoint_eq_entropy_bind_sub_sum`;
- `sum_mul_mutualInfo_channelJoint_le`;
- `mutualInfo_binaryMixture_input_concave`.

The public identity is:

```text
mutualInfo (PMF.channelJoint p W)
  = entropy (p.bind W) - sum x, (p x).toReal * entropy (W x)
```

**Target files, namespaces, and imports:** Extend
`LeanInfoTheory/Shannon/SemanticBridge/Convexity.lean`.

**Strategy:** Prove the identity by finite sums or by the existing
`H(Y) - H(Y|X)` theorem plus a finite channel conditional-entropy
calculation, choosing the cleaner statement-preserving route. Keep any
zero-input-fiber and bind-commutation calculation private. For concavity,
apply output entropy concavity to `p_i.bind W` and use linearity of the
expected channel-entropy term in the input law. Specialize to binary mixture.

**Edge cases:** Input atoms with zero mass; arbitrary channel behavior there;
zero selector weights; singleton input/output/selector; no full support;
finite alphabet assumptions only where sums occur; empty alphabet cases are
vacuous when no PMF exists.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity
```

Compile general and binary direct consumers and verify the channel entropy
identity is clean without exposing a null-fiber helper.

**Definition of done:** The clean public identity and both MI input-concavity
surfaces compile with no unnecessary support assumption.

**Downstream effect:** Completes the first half of Theorem 2.7.4 and supplies a
future coding-theory identity.

**Documentation implications:** Give the identity a textbook-facing docstring
and record its long provisional name for C7.19 review if discoverability is
poor.

**Risk level:** High.

**Fallback strategy:** If the identity's proof requires substantial private
machinery, keep that machinery private while preserving the clean statement.
If the statement itself becomes assumption-heavy or representation-exposing,
stop for review rather than publishing it.

**Implementation outcome (2026-07-29):** Complete. The semantic convexity
module now exposes exactly the three approved declarations:

```text
mutualInfo_channelJoint_eq_entropy_bind_sub_sum
sum_mul_mutualInfo_channelJoint_le
mutualInfo_binaryMixture_input_concave
```

The first theorem gives the clean finite-channel identity

```text
I(X;Y) = H(p.bind W) - sum x, p(x) * H(W(x)).
```

It requires only finite input and output alphabets. A private joint-entropy
calculation expands the channel-joint law pointwise using
`PMF.channelJoint_apply`, `ENNReal.toReal_mul`, and
`Real.negMulLog_mul`; summing the channel masses to one gives
`H(X,Y) = H(X) + sum_x p(x) H(W(x))`. The public identity then uses the
existing channel-joint marginal projections and elementary Real arithmetic.
No conditional-fiber object or null-fiber convention enters the public API.

The general-selector theorem states that, for a fixed channel `W`,

```text
sum i, r(i) * I(P(i), W) <= I(r.bind P, W).
```

Its proof applies `sum_mul_entropy_le_entropy_bind` to the component output
laws `(P i).bind W`. A second private finite-sum lemma proves linearity of
`sum_x p(x) H(W(x))` under `PMF.bind`, using `PMF.bind_apply`,
`ENNReal.toReal_sum`, `ENNReal.toReal_mul`, and `Finset.sum_comm`.
`PMF.bind_bind` identifies the selector mixture of output laws with the output
law of the mixed input. Subtracting the common expected channel-entropy term
then yields input-law concavity. The binary theorem is the exact Bool/Bernoulli
specialization through `PMF.binaryMixture`, with weight `t` on the first input
law and `1 - t` on the second.

`lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity` passed with 2,703
jobs and no warnings. A disposable direct-import consumer compiled the public
identity, the general selector theorem, both binary endpoints, a law with a
zero-mass input atom and arbitrary unused channel fiber, and a singleton
selector/input/output case. Printed signatures confirmed that there are no
support, positivity, full-support, or nonempty-alphabet assumptions. All three
axiom audits found only `propext`, `Classical.choice`, and `Quot.sound`.
Expected negative consumers confirmed lightweight-root and semantic-bridge
aggregate isolation and private-helper invisibility. The repository-wide Lean
placeholder scan was clean, and every disposable file was deleted.

The long name
`mutualInfo_channelJoint_eq_entropy_bind_sub_sum` is mathematically precise
but exposes the `channelJoint`/`bind`/finite-sum presentation. Preserve it and
test whether a compatibility alias along the tentative
`mutualInfo_channel_eq_outputEntropy_sub_expectedEntropy` pattern materially
improves textbook discovery during C7.19; this sketch is not approved
vocabulary. `sum_mul_mutualInfo_channelJoint_le` deliberately parallels
`sum_mul_entropy_le_entropy_bind`, while
`mutualInfo_binaryMixture_input_concave` is already textbook-facing, so
neither needs a separate naming watch. No public joint-entropy helper,
support helper, simp rule, new import, canonical project-memory edit, or
unapproved theorem was added. C7.17 remains approval-gated.

### C7.17 - MI Convexity In The Channel

**Status:** complete

**Objective and reason:** Prove MI convexity for a fixed input law under
general finite-selector channel mixtures and provide the binary textbook
corollary.

**Prerequisites:** C7.12--C7.14 and existing MI/KL/product bridges.

**Verified declarations to reuse:** `PMF.channelJoint`,
`channelJoint_map_snd`, `indepProd`,
`indepProd_apply`,
`joint_toMeasure_absolutelyContinuous_indepProd_marginals`,
`mutualInfo_eq_toReal_klDiv_joint_indepProd`,
`toReal_klDiv_bind_le_sum`, and `PMF.binaryMixture`.

**Verified mathlib APIs:** `PMF.bind_bind`, `PMF.bind_comm`,
`PMF.ext`, bind support, and finite sum coercion.

**Proposed declarations:** Tentative:

- `mutualInfo_channelMixture_le_sum`;
- `mutualInfo_binaryChannelMixture_le`.

The general mixed channel is written directly as:

```text
fun x => r.bind (fun i => W i x)
```

The binary channel uses:

```text
fun x => PMF.binaryMixture t ht (W1 x) (W2 x)
```

**Target files, namespaces, and imports:** Extend the semantic convexity
module; no new module.

**Strategy:** For each component channel, represent MI as Real KL between its
channel joint and the product of its fixed input and output law. Prove
privately that selector mixing commutes with:

- the channel joint for fixed input;
- the output law;
- `indepProd` when its input factor is fixed.

Apply guarded Real KL joint convexity. Component support inclusion follows
from the existing joint-to-product absolute-continuity theorem. Keep every
commutation and support helper private.

**Edge cases:** Zero selector weights; component channel with output atoms
outside another component's support; singleton selector; binary endpoints;
input atoms of zero mass; arbitrary channel values on those atoms; no channel
equality theorem; no public channel-mixture definition.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity
lake build LeanInfoTheory.Shannon.SemanticBridge
```

Compile general-selector and binary fixed-input consumers.

**Definition of done:** Both MI channel-convexity theorems compile, private
mixture identities remain hidden, and the semantic aggregate can import the
new module without a cycle.

**Downstream effect:** Completes finite Cover--Thomas Theorem 2.7.4.

**Documentation implications:** Document the concave-input/convex-channel
orientation clearly and avoid presenting private representation identities as
public API.

**Risk level:** High.

**Fallback strategy:** Use pointwise PMF extensionality for private
commutation. Do not publish helper theorems or switch to a bundled channel
unless repeated independent consumers justify a separately approved change.

**Implementation outcome (2026-07-29):** Complete. The semantic convexity
module now publishes `mutualInfo_channelMixture_le_sum`, the general
finite-selector theorem for a fixed input law, and
`mutualInfo_binaryChannelMixture_le`, its exact `NNReal` binary textbook form.
The theorem direction is explicitly channel convexity: mutual information of
the selector-mixed channel is at most the selector average of the component
mutual informations.

The proof introduces only three private commutation lemmas. They identify
selector mixing of channel joints with the joint of the pointwise mixed
channel, commute the selector with the output law using `PMF.bind_comm`, and
identify a selector mixture of fixed-left independent products with the
independent product of the mixed output. The component support guard for
`toReal_klDiv_bind_le_sum` follows from
`joint_toMeasure_absolutelyContinuous_indepProd_marginals` and the existing
PMF absolute-continuity/support equivalence. A locally chosen discrete
measurable structure then lets the existing mutual-information/KL bridge
rewrite the mixed and component divergences. The binary result is a direct
Bernoulli-selector specialization of the general theorem.

No public channel-mixture definition, cross-component support hypothesis,
channel equality theorem, alias, simp rule, or reusable support/product helper
was added. The semantic aggregate now imports
`Shannon.SemanticBridge.Convexity`; the lightweight root remains unchanged.
The direct module build passed with 2,703 jobs and the semantic aggregate build
passed with 2,758 jobs, both without warnings. Disposable aggregate consumers
compiled the general, binary, singleton-selector, and both endpoint forms.
Guarded negative consumers confirmed privacy of all three commutation helpers
and root isolation, then were deleted. Both new public theorems report only
`propext`, `Classical.choice`, and `Quot.sound` under `#print axioms`.

The public-name review found the approved names concise, mathematical, and
consistent with the input-concavity family, so Future Work Note 14 needs no new
entry. This completes the finite Cover--Thomas Theorem 2.7.4 orientation pair.
C7.18 remains approval-gated, with only its scalar regression subset already
completed by the separately authorized post-C7.01 follow-up.

### C7.18 - Maintained Examples And Boundary Consumers

**Status:** complete

**Objective and reason:** Exercise the complete Section 2.7 surface with
small permanent examples and explicit import-boundary consumers.

**Prerequisites:** C7.06, C7.10, and C7.12--C7.17.

**Verified declarations to reuse:** Every implemented Chunk 7 public
declaration, existing `PMF.bernoulli`, Bool PMFs/channels, and the project's
example-module conventions.

**Verified mathlib APIs:** Concrete `PMF.bernoulli` computation, Bool
finiteness, `decide`, `norm_num`, and extensionality as actually needed.

**Proposed declarations:** Tentative example names listed in the module
strategy, refined from the final examples. No new mathematical API theorem is
planned here.

**Target files, namespaces, and imports:** Create tentative
`LeanInfoTheory/Examples/Convexity.lean` under a descriptive example namespace.
Import the opt-in Chunk 7 modules directly. Add it to the existing examples
aggregate only if that matches current aggregate conventions; never to the
lightweight root.

**Strategy:** Maintain examples or theorem consumers covering:

- scalar empty/all-zero and positive-over-zero conventions;
- singleton selector and zero-weight Bool component;
- binary mixture endpoints and proof irrelevance;
- entropy inequality and interior equality;
- finite and support-boundary KL inequality/equality;
- MI input concavity and channel convexity.

Use disposable positive direct-import and negative root-only consumers for
boundary checks, then delete them.

**Edge cases:** Do not construct `PMF Empty`; use empty scalar Finsets,
singleton selectors, and zero-weight Bool selectors. Include one inactive
infinite-KL component and one support-boundary binary equality example.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Examples.Convexity
lake build LeanInfoTheory.Examples
```

Also run positive/negative import consumers and delete them.

**Definition of done:** Permanent examples cover each public theorem family
without becoming an exhaustive API mirror, and root/aggregate boundaries are
demonstrated.

**Downstream effect:** Supplies real consumer evidence for C7.19's naming,
helper, and simp decisions.

**Documentation implications:** Add source-level explanations of the
mathematics, not instructions about using the UI or project.

**Risk level:** Medium.

**Fallback strategy:** Keep examples algebraically small and separate scalar,
KL, and MI models if one large model obscures the APIs. Do not add new public
helpers solely to shorten examples.

**Early scalar-regression subset outcome (2026-07-29):** Complete, without
starting C7.18 as a whole. A bounded post-C7.01 follow-up created
`LeanInfoTheory.Examples.Convexity`, imported it through the examples aggregate,
and added maintained private coverage of the complete scalar LS3 edge matrix
and exact support-sensitive guarded Real contract. No public example theorem,
helper, alias, or simp rule was added. C7.18 remains `not started`; its
finite-mixture endpoint and proof-irrelevance examples, entropy and strict
equality examples, finite/support-boundary KL examples, MI input/channel
examples, and remaining positive/negative boundary consumers still await the
normal C7.18 step after C7.17.

**Pre-implementation Future Work reconciliation (2026-07-29):** A review of
the complete active Future Work register after C7.17 found no theorem,
abstraction, alias, or simp change that should precede C7.18. The new notes
instead sharpen the consumer evidence that this step must collect before
C7.19 makes API decisions. Without changing this step's scope or status, the
remaining maintained examples and disposable consumers should cover:

- `PMF.binaryMixture_apply`, both endpoint laws, and propositionally distinct
  proofs of `ht : t <= 1`, including one function-valued channel use;
- general-selector entropy concavity, plus binary concavity at both endpoints
  and an interior weight, equality for identical components, and strict
  inequality for distinct components;
- the canonical and guarded Real binary KL inequalities at both endpoints,
  including an inactive component with infinite KL and an active finite
  support case;
- the C7.11 selector/KL branch matrix: inactive infinite, active infinite,
  active finite-support, and inactive finite components, using compact Bool
  selectors where possible; if the active-infinite case would only restate
  `le_top` verbosely, record that the branch was inspected instead of forcing
  a low-value maintained fixture;
- the ENNReal and guarded Real binary KL equality theorems on one
  support-boundary equality model and one unequal-active-ratio model that
  rejects equality;
- the general-selector and binary mutual-information input-concavity and
  channel-convexity surfaces, together with direct use of
  `mutualInfo_channelJoint_eq_entropy_bind_sub_sum`; and
- positive direct-import consumers plus guarded negative consumers for the
  examples aggregate, semantic aggregate, and lightweight root boundaries.

The maintained scalar subset already exercises
`real_logSum_eq_iff_exists_constant_ratio_of_support`, so no duplicate scalar
fixture is required. These consumers may expose naming, proof-irrelevance,
endpoint-simp, strict-Jensen, bind-mass, or private-helper pressure, but this
step must only record that evidence. Compatibility aliases, simp changes,
helper extraction or promotion, and source refactors remain C7.19 decisions.
The reusable milestone-validation driver and permanent boundary/trust harness
from Future Work Notes 9 and 17 also remain deferred; C7.18 should use the
approved focused builds and disposable boundary consumers.

**Implementation outcome (2026-07-29):** Complete. The existing private scalar
regression section was preserved and `LeanInfoTheory.Examples.Convexity` was
extended with 26 maintained private consumers for the remaining Chunk 7
surface. Shared Bool models now exercise:

- the pointwise binary-mixture formula, both endpoint laws with
  propositionally different bound proofs, and an endpoint beneath a
  function-valued channel;
- general-selector entropy concavity, both binary endpoints, interior
  equality for identical laws, and strict concavity for distinct pure laws;
- inactive infinite KL with `0 * top = 0`, active finite support, an ordinary
  inactive finite component, both canonical and Real binary endpoint
  inequalities, support-boundary equality in both codomains, and rejection of
  equality for unequal active likelihood ratios; and
- the public channel entropy identity together with the general-selector and
  binary forms of mutual-information input concavity and channel convexity.

The active-infinite general-selector KL branch was inspected but not retained
as a maintained theorem: after the weighted right-hand side becomes `top`, its
conclusion is only `le_top`, exactly the low-value case allowed by the
pre-implementation reconciliation. No public fixture, helper, alias, theorem,
simp attribute, or reusable API declaration was introduced.

`lake build LeanInfoTheory.Examples.Convexity` passed with 2,704 jobs, and
`lake build LeanInfoTheory.Examples` passed with 2,775 jobs. Six disposable
positive consumers compiled through the four direct Chunk 7 modules, the
semantic aggregate, and the examples aggregate. A root-only consumer failed
only on the four expected unknown Chunk 7 identifiers, confirming lightweight
root isolation; all disposable files were deleted.

The consumer review found no pre-C7.19 naming or helper defect. The watched
guarded-Real log-sum equality and
`mutualInfo_channelJoint_eq_entropy_bind_sub_sum` were discoverable and
readable in direct use, proof irrelevance normalized endpoint bound proofs
without casts, and no example needed a public strict-Jensen, bind-mass,
cross-product, selector-normalization, or commutation helper. C7.19 should
still perform its approved whole-surface tests before making the final alias,
simp, and extraction decisions.

**Post-step double-check outcome (2026-07-29):** Complete. A requirement-level
audit found that the initial four binary KL endpoint consumers instantiated
the canonical and guarded Real inequalities at `t = 0` and `t = 1`, while the
separate mixture consumers checked endpoint reduction, but no single
maintained check explicitly showed each KL inequality's two displayed sides
normalizing to the same exact value as requested by Future Work Note 15. Four
additional private examples now prove those exact endpoint equalities, one for
each endpoint and codomain, using propositionally different proofs of the
coefficient bound. The endpoint rewrites specify all PMF arguments explicitly
so the regression remains elaboration-stable inside nested KL expressions.

The non-scalar C7.18 coverage therefore comprises 30 private consumers, with
46 private examples in the module including the earlier scalar subset. No
public declaration, import boundary, theorem statement, alias, helper, or simp
attribute changed. Direct Lean elaboration passed without warnings;
`lake build LeanInfoTheory.Examples.Convexity` again passed with 2,704 jobs,
and `lake build LeanInfoTheory.Examples` again passed with 2,775 jobs. This
follow-up closes the only discrepancy found by the double-check and leaves
C7.18 complete.

**Post-step fixture-strengthening outcome (2026-07-29):** Complete. The two
support-boundary KL equality consumers were strengthened without changing
their statements' theorem family or adding another fixture. Instead of taking
all four component laws to be `pureFalse`, they now use
`p1 = q1 = pureFalse` and `p2 = q2 = pureTrue`. The component pairs have
disjoint supports, so at each Boolean atom exactly one pair is active and the
division-free cross-product proof exercises both one-sided-zero orientations.
The same model continues to cover the canonical `ENNReal` and guarded Real
equality declarations. No example count, public declaration, helper, import,
or API changed. Direct elaboration passed without warnings, the focused
examples build again passed with 2,704 jobs, and the aggregate examples build
again passed with 2,775 jobs. The associated critical-review decisions were
reconciled under existing Future Work Notes 2, 15, 17, and 28 rather than
creating a duplicate numbered item.

### C7.19 - API, Naming, Simp, Helper, And Import Review

**Status:** complete

**Objective and reason:** Freeze the implemented API after real theorem and
consumer pressure, applying standing naming and simplification policies.

**Prerequisites:** C7.18.

**Verified declarations to reuse:** The complete Chunk 7 public surface,
current generated declaration index, AGENTS.md naming rules, and Future Work
Notes 14--18 and 24.

**Verified mathlib APIs:** Existing simp behavior for PMF bind/Bernoulli,
proof irrelevance, and the actual imported modules. No new mathematical API is
assumed.

**Proposed declarations:** No new theorem family by default.
Compatibility-preserving aliases or narrowly justified computation simp
attributes may be proposed only from demonstrated consumer pressure. All name
sketches in this plan remain tentative until this review.

**Target files, namespaces, and imports:** Review all four Chunk 7 modules,
the example module, semantic aggregate, and `LeanInfoTheory.lean`. Modify only
the owning source files when an accepted review finding requires it.

**Strategy:** Audit:

- mathematical discoverability before representation details;
- PMF and semantic naming consistency;
- unusually long names under Future Work Note 14;
- whether edge/endpoint computation laws are safe `[simp]` rules;
- proof irrelevance across different `ht : t <= 1` proofs;
- endpoint and zero-weight support normalization;
- absence of accidental general-selector equality or public proof helpers;
- private status of support transport, channel-joint, independent-product,
  and mixture commutation;
- direct imports, aggregate exposure, and root isolation;
- whether C7.10 creates genuine shared strict-Jensen pressure under Note 24.

Test locally before assigning any simp attribute. Keep chain rules and
representation-changing identities explicit under Notes 15--16.

**Edge cases:** Simp loops between mixture definitions and bind; endpoint
proof terms; zero-weight support; EReal edge reductions; name collisions;
aliases creating competing vocabulary; hidden root import paths.

**Focused validation:**

```powershell
lake build LeanInfoTheory.Probability.FiniteMixture
lake build LeanInfoTheory.Shannon.LogSum
lake build LeanInfoTheory.Shannon.EntropyConcavity
lake build LeanInfoTheory.Shannon.SemanticBridge.Convexity
lake build LeanInfoTheory.Shannon.SemanticBridge
lake build LeanInfoTheory.Examples.Convexity
lake build LeanInfoTheory
```

Run direct/root consumers, placeholder scan, import reachability checks, and
`git diff --check`.

**Definition of done:** Names, aliases, simp attributes, helper visibility,
imports, and root behavior have recorded decisions backed by consumers. Every
new public name is either retained or watched under Note 14 with a reason.

**Downstream effect:** Freezes the API for project-memory and generated
documentation work.

**Documentation implications:** Record review decisions in the plan outcome
and update the appropriate existing Future Work Notes when their pressure
conditions are met. Do not create duplicate notes.

**Risk level:** High.

**Fallback strategy:** Prefer retaining explicit theorems and current names.
Do not rename declarations during the active phase; use
compatibility-preserving aliases only after approval.

**Implementation outcome (2026-07-29):** Complete. The whole Chunk 7 public
surface was reviewed against the 46 maintained C7.18 examples, focused source
searches, and disposable direct/root consumers.

One evidence-supported lightweight declaration was added:
`PMF.bind_toReal_apply` in `Probability.Finite`. It states the finite-selector
real-mass formula for arbitrary `PMF.bind`, requires no finite output alphabet,
support, positivity, or measurable-space assumptions, and follows the
established marginal `..._toReal_apply` naming pattern. It replaces four
identical production conversion blocks: two in `EntropyConcavity`, one in the
private finite KL engine, and one in the private expectation-under-bind proof.
It remains explicit rather than `[simp]` because expanding a bind into a sum is
a representation choice. No import edge changed; the theorem is available
through the already-root-imported lightweight probability module.

`PMF.binaryMixture_zero` and `PMF.binaryMixture_one` are now `[simp]`.
Candidate and exported-attribute probes verified proof irrelevance across
different endpoint-bound proofs, rewriting under lambdas and nested contexts,
pointwise PMF use, strict constructor reduction, and termination with the
definition, Bernoulli bind, and pointwise mass API. The representation-changing
`PMF.binaryMixture_apply` remains explicit, the coefficient proof argument is
unchanged, and no private or public Bool-selector normalization helper was
added.

The source comments for `klDiv_binaryMixture_eq_iff` and
`toReal_klDiv_binaryMixture_eq_iff` now explain both the ordinary positive-
reference likelihood-ratio case and the support-forced zero-mass case handled
by the division-free cross product. The watched
`real_logSum_eq_iff_exists_constant_ratio_of_support` and
`mutualInfo_channelJoint_eq_entropy_bind_sub_sum` names were retained without
aliases: maintained and direct consumers found both discoverable, while the
shorter sketches hid or blurred real contract information. No general scalar
cross-product equality theorem was added.

The private binary ratio bridge, scalar normalization proofs, KL support and
finiteness helpers, channel-mixture commutation lemmas, and channel-joint
entropy expansion remain private. The finite KL engine remains coherent after
the bind-mass extraction and was not fragmented. One local parameterized
`hMIKL` fact now removes duplicated applications of the existing public
mutual-information/KL bridge inside
`mutualInfo_channelMixture_le_sum`; it creates no declaration. The strict-
Jensen comparison found that mathlib already owns the generic equality
machinery and that the entropy-bound and binary-concavity conclusions are
different, so no shared wrapper was introduced.

Focused builds passed for `Probability.Finite`,
`Probability.FiniteMixture`, `Shannon.LogSum`,
`Shannon.EntropyConcavity`, `Shannon.SemanticBridge.Convexity`, the semantic
aggregate, `Examples.Convexity`, the examples aggregate, and
`LeanInfoTheory`. A direct consumer exercised every reviewed family, the new
bind theorem with infinite output alphabet `Nat`, endpoint simp behavior, and
representative changed proofs. A guarded root consumer exposed
`PMF.bind_toReal_apply` but rejected the four representative opt-in Chunk 7
names. Representative `#print axioms` output contained only `propext`,
`Classical.choice`, and `Quot.sound`; the strict placeholder, scratch, and
temporary-file checks passed. All probes were deleted. Future Work Notes 14,
15, 17, 24, and 36 record the final decisions. Generated references and the
independent full milestone suite remain C7.21 and C7.22 work.

### C7.20 - Canonical Project-Memory Reconciliation

**Status:** complete

**Objective and reason:** Reconcile canonical project context with the
implemented and reviewed Chunk 7 state before public reference generation.

**Prerequisites:** C7.19.

**Verified declarations to reuse:** The frozen Chunk 7 source and actual build
evidence; current canonical-document ownership in AGENTS.md.

**Verified mathlib APIs:** None; this is documentation reconciliation.

**Proposed declarations:** None.

**Target files, namespaces, and imports:** Update only current-facing,
hand-maintained project memory as warranted:

- `docs/lean-info-theory-living-summary.md`;
- `docs/project-log.md`;
- `docs/current-lean-state.md`;
- `docs/roadmap.md`;
- `README.md`;
- this plan's factual outcomes/status.

Do not edit AGENTS.md, generated references, or website files in this step.

**Strategy:** Reconcile exact module/declaration coverage, theorem assumptions,
open risks, validation status, and Future Work disposition against source and
Git history. State that implementation/API review is complete while generated
references and independent final validation remain pending. Preserve
historical prose and distinguish working-tree, committed, validated, and
deployed states.

**Edge cases:** Do not claim final completion before C7.22; do not close a
Future Work Note merely because it was consulted; do not conflate source
declarations with generated environment names; preserve side-thread notes and
standing guardrails.

**Focused validation:**

```powershell
git diff --check
```

Run targeted consistency searches for stale Chunk 7 status and verify no Lean
or generated file changed in this documentation-only step.

**Definition of done:** Canonical documents agree with frozen source and
accurately describe the pending C7.21/C7.22 gates.

**Downstream effect:** Supplies authoritative metadata for generated and
public documentation.

**Documentation implications:** This step owns the main canonical
reconciliation. C7.22 may make a narrow final-status amendment after the
independent gate passes.

**Risk level:** Medium.

**Fallback strategy:** Prefer precise partial-status wording over broad
claims. If canonical documents conflict materially, stop and resolve the
source-of-truth discrepancy before C7.21.

**Implementation outcome (2026-07-29):** Complete. The approved
documentation-only scope was reconciled against the C7.19-frozen working
source and the checked-in Git baseline. Updated
`docs/lean-info-theory-living-summary.md`, `docs/project-log.md`,
`docs/current-lean-state.md`, `docs/roadmap.md`, and `README.md`, together
with this factual plan outcome. No Lean source, AGENTS policy, generated
reference, or website file changed during C7.20.

The canonical documents now agree that the finite Cover--Thomas Section 2.7
implementation and API/import review are complete, while Chunk 7 remains
uncommitted and not final. They record the four new opt-in production modules,
the private `Examples.Convexity` regression owner, the root-visible but
import-neutral `PMF.bind_toReal_apply` bridge, the exact 28-declaration public
source increase, the unchanged certificate trust boundary, and the focused
C7.19 evidence. They also distinguish the frozen working-source topology
(48 modules, 90 local edges, 11 root-reachable, 37 opt-in, 862 source
declarations) from the still-tracked Chunk 6 generated references
(43 modules and 834 declarations).

The Future Work reconciliation preserved the relevant module-splitting and
boundary, generated-documentation, naming, simp, validation-harness,
no-placeholder, strict-Jensen, example-pedagogy, and finite-bind records under
Notes 2-4, 9, 14-18, 24, 28, and 36. No new numbered item was added and no
existing guardrail was closed. Generated/public-documentation refresh remains
exclusively `C7.21`; the independent full build, trust, boundary, placeholder,
website, and hygiene closeout remains `C7.22`.

### C7.21 - Generated References And Public-Documentation Consistency

**Status:** complete

**Objective and reason:** Regenerate source-derived references and make the
public documentation accurately expose the new opt-in modules and theorem
families.

**Prerequisites:** C7.20.

**Verified declarations to reuse:** Frozen Chunk 7 modules, current reference
generators, `scripts/check_website.py`, and existing module/public status
conventions.

**Verified mathlib APIs:** None directly.

**Proposed declarations:** None.

**Target files, namespaces, and imports:** Regenerate:

- `home_page/blueprint/dep_graph_document.html`;
- `home_page/blueprint/module_graph.json`;
- `home_page/docs/api-index.html`;
- `home_page/docs/declaration_index.json`.

Update hand-written website/module/status pages only where required for
consistency. Do not redesign the website.

**Strategy:** Add curated generator metadata for each new module, regenerate
both reference sets twice, compare second-pass output for idempotence, inspect
the semantic module/edge/declaration delta, and run the website checker.
Describe the semantic aggregate and root boundary accurately. Add selected
theorem highlights only if the existing page's editorial scope clearly calls
for them; Note 9's larger doc-gen work remains deferred.

**Edge cases:** Private helpers must not appear as public declarations;
tentative module names must match source exactly; no generic module-summary
fallback; source-line links and HTML anchors must be valid; generated counts
must be described as source-declared, not full environment counts.

**Focused validation:**

```powershell
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/check_website.py
git diff --check
```

Run both generators a second time and verify byte-stable output.

**Definition of done:** Generated references are idempotent, public pages
match the reviewed source and module boundaries, and all website checks pass.

**Downstream effect:** Leaves only the independent final validation gate.

**Documentation implications:** Record exact generated counts and checks in
the step outcome without overclaiming full Lean doc-gen or deployment.

**Risk level:** Medium.

**Fallback strategy:** Correct generator metadata or parser defects in their
own tooling when demonstrated. Do not rewrite source prose merely to hide a
parser error or broaden this into a site redesign.

**Implementation outcome (2026-07-29):** Complete. Added exact blueprint
summaries for `Probability.FiniteMixture`, `Shannon.LogSum`,
`Shannon.EntropyConcavity`, `Shannon.SemanticBridge.Convexity`, and
`Examples.Convexity`; updated the existing `Probability.Finite`, semantic
aggregate, and examples-aggregate summaries; and classified all
`LeanInfoTheory.Probability.*` modules in the shared-foundation layer. The
classifier change corrects the pre-existing placement of
`Probability.FiniteChannel` and prevents the new mixture owner from appearing
in the certificate layer. It changes generated presentation only, not imports.

Regenerated the four assigned source-derived artifacts. Their reviewed output
contains 48 modules, 90 local import edges, 11 root-reachable modules, 37
separate-import modules, and 862 source-declared public declarations. All 862
declarations have doc comments. The 28-declaration increase over Chunk 6 is
four declarations in `Probability.FiniteMixture`, nine in `Shannon.LogSum`,
three in `Shannon.EntropyConcavity`, eleven in
`Shannon.SemanticBridge.Convexity`, and the existing-module
`PMF.bind_toReal_apply` bridge. `Examples.Convexity` contributes no public
declaration, as intended. Every module has curated metadata; source paths,
source lines, declaration anchors, and existing hand-written API-index
fragment links resolve.

Updated the hand-written homepage, roadmap, module guide, development import
guide, concept note, and blueprint overview without changing site structure or
styling. They expose the four opt-in production modules, the private regression
owner, the semantic aggregate edge, and the exact pending state: implementation
and public-documentation refresh are complete through `C7.21`, while
independent final validation and checkpoint readiness remain `C7.22`. The
curated theorem-highlights page was left unchanged because the generated index
already exposes the complete API and the existing Future Work policy reserves
representative theorem curation for a deliberate editorial pass.

Both generators were run twice after the final metadata edit, and the four
second-pass SHA-256 hashes were byte-identical to the first-pass hashes.
`python scripts/check_website.py` passed with 12 HTML files and two generated
JSON files. Additional read-only checks confirmed the exact counts, unique
anchors, no fallback summaries, no private-declaration leakage, correct
aggregate edges, and unchanged lightweight-root reachability. No Lean source,
root import, AGENTS policy, certificate file, or trust boundary changed. No
Lean build was required for this generated/public-documentation-only step;
`C7.22` retains the independent full build and closeout suite.

A post-step double-check tightened three related editorial ambiguities. The
`Examples.Convexity` summary now distinguishes entropy concavity from KL
convexity. The semantic summaries now distinguish general-selector KL
convexity from the binary-only equality characterization, and the entropy
summaries state the binary interior-weight equality contract instead of the
less precise phrase `strict equality`. These changes match the actual theorem
directions and scopes without changing any mathematical or module contract.
Both generators were again run twice with byte-identical second passes; the
website, count, metadata, source-line, anchor, root-boundary, and hygiene checks
still pass. The corrections are fully discharged within C7.21 and create no
Future Work item.

### C7.22 - Independent Final Validation And Closeout

**Status:** complete

**Objective and reason:** Independently verify every mathematical,
architectural, trust, documentation, and repository-hygiene completion
criterion before declaring Chunk 7 complete.

**Prerequisites:** C7.21.

**Verified declarations to reuse:** The complete reviewed Chunk 7 source,
maintained validation commands in AGENTS.md, generated-reference tools, and
existing axiom/placeholder audit patterns.

**Verified mathlib APIs:** None new; all theorem dependencies are already
compiled by their owning steps.

**Proposed declarations:** None unless a validation failure returns work to an
owning earlier step under an approved revision.

**Target files, namespaces, and imports:** Validate all four new modules,
semantic and examples aggregates, lightweight root, canonical documents,
generated references, and website. Update only factual closeout status in this
plan and affected canonical/public status files after every gate passes.

**Strategy:** Run:

1. direct builds of every new module and example;
2. the complete maintained milestone build suite;
3. semantic and examples aggregate builds;
4. positive direct-import and guarded negative root-isolation consumers;
5. all-new-public-theorem axiom inspection;
6. forbidden-placeholder scan;
7. generated-reference idempotence and website validation;
8. import/declaration/simp/helper visibility review;
9. scratch-artifact, untracked-file, diff-hygiene, and `git diff --check`
   audits.

Reconcile final documentation only after the evidence exists.

**Edge cases:** Clean incremental builds do not prove root isolation by
themselves; source-derived declaration inventory is not an axiom audit;
negative consumer failures must be guarded and expected; generated output
must distinguish working-tree state from a commit or deployment; no scratch
spike may remain.

**Focused validation:**

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

Also build every new Chunk 7 module directly, rerun generators/checkers,
perform the placeholder and axiom audits, and inspect final `git status` and
diff.

**Definition of done:** Every completion criterion below has current evidence,
all failures have been resolved in their owning step, the working tree
contains only intentional Chunk 7 changes, and canonical/public status says
"validated but uncommitted" rather than "checkpointed".

**Downstream effect:** Declares Chunk 7 ready for a coherent checkpoint. It
does not authorize Chunk 8 or any deferred task.

**Documentation implications:** Record exact final commands/results and amend
the pending-validation language from C7.20/C7.21. Do not predict the next
chunk's scope.

**Risk level:** Critical.

**Fallback strategy:** Any failed gate keeps Chunk 7 incomplete. Return to the
owning step, preserve the failure and correction history, and obtain approval
before resuming later work.

**Implementation outcome (2026-07-29):** Complete. Independent final
validation passed for the complete accumulated Chunk 7 working tree. A direct
build of `Probability.Finite`, all four new production owners, and
`Examples.Convexity` completed successfully with 2,704 jobs. The maintained
ten-target milestone suite then completed successfully with 2,789 jobs,
covering the lightweight root, entropy bounds, units, the semantic aggregate,
mathlib anchors, all four maintained certificate demonstrations, and the
examples aggregate.

Disposable direct-import consumers exercised all 28 new public declarations
through their owning modules. Separate aggregate consumers confirmed the
semantic and examples exposure, while guarded negative consumers confirmed
that the four opt-in production surfaces remain absent from the lightweight
root and that selected private proof/example helpers remain inaccessible. The
root continues to expose only the new `PMF.bind_toReal_apply` bridge through
its pre-existing `Probability.Finite` edge. Every disposable consumer and
audit file was deleted.

An explicit `#print axioms` manifest covered all 26 new theorems; every entry
reported only `propext`, `Classical.choice`, and `Quot.sound`. The strict Lean
placeholder scan returned no matches. Independent source and generated-index
audits confirmed the exact 28-name surface, 862 unique documented declaration
anchors, valid source paths and lines, no fallback module summaries, no private
declaration leakage, and the reviewed `4/9/3/11/0` declaration split across
the four production modules and `Examples.Convexity`. Only
`PMF.binaryMixture_zero` and `PMF.binaryMixture_one` are `[simp]`; the
pointwise, representation-changing, chain, and convexity theorems remain
explicit.

Both generators were rerun twice. Their second-pass SHA-256 hashes were
byte-identical:

- dependency graph HTML:
  `86636015CD60FF29CBAC0ACFA92D6AB846136A841B7C8E16A4734FA7C8217988`;
- module graph JSON:
  `B65EA09069ED8C1CDDD6CB11972DF76663928B1FE446C1BF449C18BDA54D99E9`;
- API index HTML:
  `1D8B67084A9D6EDF747FC072675E8F543F9B106B73E96C1B4300577332885872`;
- declaration index JSON:
  `78CF959EBCDC093E6C6624A2DA51C24FFABAD2504E0650AE0ADD201A99441C61`.

The generated graph records 48 modules, 90 local edges, 11 root-reachable
modules, and 37 opt-in modules. The website checker passed for 12 HTML files
and two generated JSON files. Conflict-marker, disposable-probe, untracked-
file, whitespace, and `git diff --check` audits found only the intentional
Chunk 7 working-tree changes. The validation used the incremental Lake cache;
no C7 disposable source or Lake artifact remains, and pre-existing ignored
`tmp/` material was left untouched. No cold release build was required.
Canonical and public status now describe Chunk 7 as complete and validated but
uncommitted, never checkpointed or deployed. No later chunk or deferred task
is authorized by this closeout, and no new Future Work item is justified.

## Integration Checkpoints

1. **After C7.06:** The complete scalar LS3 API, including extended equality,
   guarded Real corollaries, and non-bottom invariants, compiles.
2. **After C7.10:** Production mixtures and entropy concavity/equality compile
   with direct Jensen and correct endpoint behavior.
3. **After C7.15:** General and binary KL convexity, active Real guards, and
   binary support-aware equality compile.
4. **After C7.17:** Both directions of Cover--Thomas Theorem 2.7.4 compile,
   and all representation-specific bridge helpers remain private.
5. **After C7.19:** Public names, simp behavior, proof irrelevance, helper
   visibility, aggregate exposure, and root isolation are reviewed and frozen.
6. **After C7.22:** Builds, trust audits, canonical memory, generated
   references, public documentation, and repository hygiene agree.

Neither a feasibility gate nor an integration checkpoint authorizes beginning
the next step. Explicit user approval is required for every later step.

## Chunk-Completion Criteria

Chunk 7 is complete only when:

- the scalar API is canonical over arbitrary `s : Finset iota`;
- `0/0` and zero-over-positive evaluate to zero;
- positive-over-zero evaluates to `top`;
- every scalar term and finite term sum is proved not `bottom`;
- the unconditional extended log-sum inequality and full active-ratio equality
  iff compile;
- one coherent guarded Real log-sum family compiles without a duplicate public
  engine;
- general selector mixtures use `PMF.bind` and the binary BP3a construction
  has correct pointwise and endpoint laws;
- entropy concavity is proved directly by finite Jensen;
- binary entropy equality is exactly `p = q` for interior weights;
- general ENNReal KL joint convexity is unconditional and top-safe;
- general and binary Real KL corollaries use active support guards;
- binary KL equality is exactly the cross-product condition under component
  support and interior weight;
- the channel entropy identity is public, clean, and independently reusable;
- MI is concave in the input law for fixed channel, with general and binary
  forms;
- MI is convex in the channel for fixed input, with general and binary forms;
- no general-selector or MI/channel equality family is introduced;
- all one-off support, joint/product, coercion, and commutation helpers remain
  private;
- no finite-family, topology, continuity, conditional-KL, or certificate API
  changes occur;
- all four new modules remain directly importable and outside the lightweight
  root;
- `SemanticBridge.Convexity` is exposed through the opt-in semantic aggregate;
- maintained examples exercise scalar, mixture, entropy, KL, and both MI
  directions without constructing `PMF Empty`;
- public names and simp behavior pass C7.19 review;
- Future Work Notes 9, 14--18, and 24 are reconciled without speculative work;
- no placeholder or unapproved axiom is introduced;
- canonical documents, generated references, and public status agree with
  source and validation state;
- every focused, aggregate, milestone, root-isolation, axiom, placeholder,
  generator, website, and hygiene check passes;
- every deviation, cancellation, supersession, and follow-up is recorded
  honestly.

## Explicitly Deferred Work

- Finite-simplex topology and continuity of entropy.
- KL continuity on fixed support and global lower semicontinuity.
- A Real-coefficient binary mixture forwarding family.
- A public general finite-mixture or channel-mixture wrapper beyond `PMF.bind`.
- General finite-selector entropy or KL equality classifications.
- MI input/channel equality cases and specialized channel equality theorems.
- Finite-family wrappers for the new PMF theorems.
- Conditional KL objects, chain rules, and gap closure not required privately.
- Pinsker, tensorization, total variation consequences, and variational forms.
- Capacity, coding theorems, AEP, typicality, asymptotic converses, and
  sufficient-statistics extensions.
- Changes to `ShannonEntropyVal`, `EntropyExpr`, primitive inequalities,
  checked certificates, or certificate validation.
- Full Lean doc-gen, theorem-level blueprinting, shared-status tooling, and
  website redesign.
- Upstream mathlib proposals until the local names, assumptions, and module
  ownership stabilize.

## Proposed Future-Work Candidates

Create or refine a Future Work entry only if implementation or consumer
evidence satisfies its pressure condition:

- Under Future Work Note 9, retain full doc-gen, theorem-level blueprinting,
  shared structured status, and broader validation tooling as later work.
  Chunk 7 generated-reference updates do not automatically authorize them.
- Under Note 14, record any unusually long or representation-exposing public
  LS3, KL, channel-joint, or binary-mixture name, with a reason and a
  provisional compatibility alias pattern where useful.
- Under Note 15, record only simp decisions supported by endpoint,
  proof-irrelevance, zero-weight, and EReal critical-pair consumers.
- Under Note 16, keep entropy/MI chain rules explicit; Chunk 7 does not create
  a new automatic chain-rule orientation.
- Under Note 17, preserve focused iteration versus full milestone validation,
  root-isolation consumers, and future validation-driver pressure.
- Under Note 18, record that no certificate semantic assumption or trust path
  changed. Do not add a convexity certificate primitive.
- Under Note 24, determine whether C7.10 is sufficiently similar to the
  existing entropy-extremization strict-Jensen proof to justify a coherent
  private shared helper. If the proof shapes differ or ownership would create
  a bad import, record that no extraction is justified.
- Consider Fintype/univ scalar wrappers only if at least two downstream
  consumers repeatedly perform the same `Finset.univ` specialization.
- Consider a public channel-mixture helper only if multiple coding/channel
  consumers need the same expression independently of the MI theorem.
- Consider a public extended finite-PMF KL sum formula only after repeated
  proofs need it and its `top`/support contract is clear.
- Consider general-selector equality classifications only in a separately
  approved later phase.
- Consider upstreaming generic scalar log-sum infrastructure only after the
  EReal contract and names survive downstream use.

Do not create a new numbered note merely because a candidate is listed here.
Update an existing owner where one exists and add a new note only for
demonstrated, otherwise unowned pressure.

## Known Risks

- Full extended log-sum equality may require lengthy top/finite case analysis.
- EReal simplification can hide a `bottom` branch unless the non-bottom
  invariants are used deliberately.
- Coercions among NNReal, ENNReal, EReal, and Real may make otherwise simple
  scalar identities brittle.
- A private guarded Real proof can accidentally become a second public API
  family if visibility is not audited.
- Finite selector sums and PMF bind use different surface notation and may
  need careful finite-tsum normalization.
- `toReal top = 0` can silently invalidate a Real KL theorem if active support
  guards are omitted.
- Binary endpoint guards can be strengthened accidentally when specializing
  from the general selector theorem.
- Cross-product equality is exact only with component support and interior
  weight; weakening those assumptions changes the theorem.
- Direct entropy Jensen and strict equality may duplicate enough setup to
  create Note 24 pressure, but sharing across modules can make imports worse.
- The public channel entropy identity may acquire an awkward long name or
  expose coordinate orientation if stated through existing marginals.
- MI channel convexity can tempt promotion of one-off joint/product mixture
  identities.
- Adding `SemanticBridge.Convexity` to the aggregate can create a circular
  import if it imports the aggregate rather than direct children.
- Generated and canonical status may drift during a long 22-step chunk.

## Plan-Revision Policy

- Implementation discoveries may justify changing later steps.
- Every proposed change must be explained to the user before this plan is
  edited.
- Completed implementation history must not be rewritten misleadingly.
- Cancelled or superseded steps remain recorded under their original stable ID
  with a factual reason and replacement reference.
- New IDs are never substituted for completed history, and completed or
  cancelled IDs are never recycled.
- A material theorem, scope, representation, module, public API,
  trust-boundary, or naming-policy change requires the user's explicit
  approval.
- If a theorem statement changes materially, preserve the original proposal,
  record the revised contract, and explain the mathematical/API reason.
- Private proof-strategy changes may be recorded in a step outcome when they
  preserve the approved statement, assumptions, architecture, and trust
  boundary.
- Failure of C7.01 or C7.07 blocks all later work until an explicitly approved
  revision; neither gate may be downgraded to a signature check.
- No later step begins without the user's explicit approval.
- Completing a step or integration checkpoint does not authorize beginning
  the next step.
- If a discovery invalidates the dependency graph, zero conventions,
  support/top policy, module boundary, or claim of full finite Section 2.7
  coverage, stop implementation and return for review.
