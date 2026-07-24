# Chapter 2 Chunk 5: Finite Fano

**Plan status:** Approved for implementation
**Baseline commit:** `217e35cf9f1a76354b6f82a3fb0209818b32bab7`
**Plan path:** `docs/plans/chapter2-chunk-05.md`
**Number of steps:** 20

Twenty steps are appropriate because the chunk has three distinct proof layers:
the Boolean/error API, the conditional-fiber proof of Fano's inequality, and the
public corollary/integration surface. The steps keep each mathematical
dependency reviewable while reserving explicit checkpoints for API, examples,
documentation, and full validation.

The baseline commit identifies the checked-in starting point. Pre-existing
working-tree changes at plan creation are not part of this plan and must not be
reverted or silently absorbed.

## Chunk Objective

Formalize the finite deterministic-decoder form of Cover--Thomas Fano's
inequality in nats. Provide:

- a small Boolean-entropy bridge;
- a reusable deterministic decoding-error API;
- the exact finite-alphabet conditional-entropy bound;
- a `Real.qaryEntropy` presentation;
- random-variable wrappers;
- the standard weaker finite-alphabet form;
- error-probability lower bounds;
- uniform-message mutual-information corollaries;
- focused examples, documentation, and validation.

## Scope

The core input is a finite joint PMF on `alpha x beta` and a deterministic
decoder `beta -> alpha`. The public API should also expose wrappers for random
variables on a finite source PMF. The error indicator is Boolean, with
`true = error`.

The principal exact theorem should have no public alphabet-nondegeneracy
assumption. In particular, singleton alphabets must be handled by the theorem
rather than excluded. A hypothesis such as `2 <= Fintype.card alpha` is
introduced only for corollaries that divide by `Real.log (Fintype.card alpha)`.

## Explicit Non-goals

- Randomized decoders or decision kernels.
- Coding theorems, block codes, rates, capacity, or asymptotic converses.
- List decoding or support-adaptive Fano inequalities.
- Equality-case or sharpness classifications.
- A general decision-theory risk API.
- A generic public conditional-fiber entropy theorem without demonstrated
  downstream pressure.
- A public decoding-error PMF/law API unless implementation pressure requires
  it.
- Bernoulli-distribution wrappers that duplicate the Boolean PMF bridge.
- Changes to the lightweight root import or the semantic-bridge aggregate.
- Website redesign.

## Relevant Textbook Sections

The local Cover--Thomas first-edition material consulted for this chunk is:

- Section 2.1, "Entropy", pp. 12--14.
- Section 2.2, "Joint Entropy and Conditional Entropy", pp. 15--17.
- Section 2.5, "Chain Rules for Entropy, Relative Entropy, and Mutual
  Information", pp. 21--22.
- Section 2.6, "Jensen's Inequality and Its Consequences", pp. 27--28.
- Section 2.11, "Fano's Inequality", pp. 38--40.

The project uses natural logarithms, so all quantities are in nats. The
textbook's binary constant `1` bit is represented by `Real.log 2`. The
textbook's estimator is represented by an explicit deterministic decoder
`beta -> alpha`. The formalization must account explicitly for empty types,
singleton alphabets, and zero-probability conditioning fibers.

## Existing Infrastructure

The following LeanInfoTheory declarations are verified existing names:

- `entropy`, `entropy_eq_sum`, `entropyOf`, `jointEntropyOf`;
- `condEntropy`, `condEntropyOf`, `mutualInfo`, `mutualInfoOf`;
- `condEntropyOf_pair_chain_rule`;
- `condEntropyOf_deterministic_chain_rule`;
- `condEntropyOf_comp_eq_zero`;
- `condEntropyOf_le_entropyOf`;
- `condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd`;
- `condFstGivenSnd_apply_ne_zero_iff`;
- `condEntropyFstGivenSnd_of_sndMarginal_eq_zero`;
- `condEntropyFstGivenSnd_of_sndMarginal_ne_zero`;
- `condEntropyFstGivenSnd_eq_zero_iff_of_sndMarginal_ne_zero`;
- `entropy_le_log_support_ncard`;
- `entropy_uniformOfFintype`;
- `mutualInfo_eq_entropy_fstMarginal_sub_condEntropy`;
- `mutualInfoOf_eq_entropyOf_sub_condEntropyOf`;
- `fstMarginal_apply`, `sndMarginal_apply`;
- `PMF.toReal_nonneg`, `PMF.toReal_le_one`, `PMF.sum_toReal`.

The following mathlib declarations are verified existing names:

- `Real.binEntropy`, `Real.qaryEntropy`;
- `Real.binEntropy_eq_negMulLog_add_negMulLog_one_sub`;
- `Real.binEntropy_le_log_two`, `Real.qaryEntropy_two`;
- `Real.log_le_log`, `Real.log_pos`;
- `PMF.map`, `PMF.map_apply`, `PMF.map_comp`;
- `Fintype.sum_bool`;
- the standard `Fintype.card`, `Finset.card_erase_of_mem`, and `Set.ncard`
  lemmas.

No project Fano theorem or maintained decoding-error API exists at the
baseline. Names introduced below are proposed names unless explicitly labeled
as verified existing names. They remain tentative until the API review in
`C5.17`.

## Mathematical Dependency Overview

```text
Boolean PMF entropy
        |
deterministic error indicator and error probability
        |
H(E) = binEntropy(Pe) and 0 <= Pe <= 1
        |
H(X | Y) = H(E | Y) + H(X | E,Y)
        |
no-error fiber = 0       error fiber support <= |alpha| - 1
        \                 /
         residual conditional-entropy bound
                       |
        exact Fano inequality and q-ary packaging
                       |
      random-variable wrappers and weak Fano
                       |
       error and mutual-information lower bounds
                       |
       examples, API review, documentation, validation
```

Implementation conveniences, especially a private fiber helper, are not
mathematical prerequisites. They should be extracted only when a production
proof demonstrates that they clarify or de-duplicate the argument.

## API And Module Strategy

### `LeanInfoTheory.Shannon.BinaryEntropy`

Create `LeanInfoTheory/Shannon/BinaryEntropy.lean`. It should import the
project entropy layer and mathlib's binary-entropy module, and provide the
small bridge from entropy of a Boolean PMF to `Real.binEntropy`.

### `LeanInfoTheory.Shannon.Fano`

Create `LeanInfoTheory/Shannon/Fano.lean`. It may import:

- `LeanInfoTheory.Shannon.BinaryEntropy`;
- `LeanInfoTheory.Shannon.EntropyBounds`;
- `LeanInfoTheory.Shannon.SemanticBridge.Theorems`.

It owns the deterministic decoding-error definitions, the Fano proof, and its
public PMF/random-variable corollaries. Fano must remain opt-in:

- do not import it from `LeanInfoTheory.lean`;
- do not import it from `LeanInfoTheory.Shannon.SemanticBridge`;
- do not move general semantic-bridge declarations into this module.

The implementation may use classical equality internally. Public definitions
and theorem statements should not expose `[DecidableEq alpha]` merely to
compute whether decoding was correct.

### Examples

Create `LeanInfoTheory/Examples/Fano.lean` and add it to
`LeanInfoTheory/Examples.lean`. Examples are opt-in and must not affect the
lightweight root.

### Proposed Public Surface

The following names are tentative proposed declarations:

- `entropy_bool`;
- `decodingErrorIndicator`;
- `decodingErrorProbability`;
- `decodingErrorProbabilityOf`;
- `decodingErrorIndicator_eq_true_iff`;
- `decodingErrorIndicator_eq_false_iff`;
- `decodingErrorProbability_eq_sum`;
- PMF and random-variable range theorems for decoding error;
- `entropy_decodingErrorIndicator`;
- `entropyOf_decodingErrorIndicator`;
- `condEntropy_fano`, `condEntropy_fano_qary`;
- `condEntropyOf_fano`, `condEntropyOf_fano_qary`;
- weak finite-alphabet PMF and random-variable Fano corollaries;
- generic error-probability lower bounds;
- uniform-message mutual-information lower bounds.

`condEntropy_fano` is reserved for the expanded textbook expression

```text
binEntropy(Pe) + Pe * log(card alpha - 1).
```

`condEntropy_fano_qary` is the `Real.qaryEntropy` packaging. This naming
choice keeps the primary theorem readable without making the proof depend on
mathlib's internal integer-cast representation of `qaryEntropy`.

## Implementation Steps

### C5.01 - Contract And Proof-Feasibility Spike

**Status:** not started

**Objective:** Verify the exact broad theorem contract, the intended decoder
argument order, the Boolean error convention, and the viability of the
conditional-fiber proof before adding production declarations.

**Prerequisites:** Baseline modules build; verified entropy, conditional
entropy, and conditional-fiber APIs are available.

**Proposed declarations:** None in production. A disposable local theorem may
prototype the expanded Fano statement.

**Target files and namespaces:** An ignored disposable file under
`tmp/codex-handoffs/`; namespace `LeanInfoTheory` or a private test namespace.
No tracked source file changes.

**Strategy:** Instantiate the likely PMF theorem signature, test singleton and
binary alphabets, locate exact card/support lemmas, and confirm that classical
decidable equality can remain inside definitions/proofs.

**Edge cases:** Empty `alpha` or `beta`, singleton `alpha`, `Pe = 0`, `Pe = 1`,
zero-mass conditioning fibers, and the Nat-versus-Int representation of
`card alpha - 1`.

**Focused validation:** `lake env lean tmp/codex-handoffs/chunk5-contract-spike.lean`

**Definition of done:** The disposable consumer compiles, is deleted, and the
approved public theorem contracts remain viable or any discrepancy is brought
back for plan revision before production edits.

**Downstream effect:** Locks the proof contract for `C5.02`--`C5.15`.

**Documentation implications:** Record no canonical project-memory change
unless the spike forces a plan revision.

### C5.02 - Boolean PMF Entropy Bridge

**Status:** not started

**Objective:** Relate project entropy on `PMF Bool` to mathlib binary entropy.

**Prerequisites:** `entropy_eq_sum`, `Fintype.sum_bool`,
`Real.binEntropy_eq_negMulLog_add_negMulLog_one_sub`, and PMF mass
normalization.

**Proposed declarations:** `entropy_bool` (tentative), expressing
`entropy p = Real.binEntropy (p true).toReal`.

**Target files and namespaces:**
`LeanInfoTheory/Shannon/BinaryEntropy.lean`, namespace `LeanInfoTheory`.

**Strategy:** Expand the Boolean finite sum, rewrite the false mass as
`1 - (p true).toReal`, and close using the mathlib binary-entropy identity.

**Edge cases:** Both endpoint distributions must simplify without positivity
hypotheses.

**Focused validation:** `lake build LeanInfoTheory.Shannon.BinaryEntropy`

**Definition of done:** The bridge compiles without placeholders and does not
pull Fano or semantic-bridge imports into the entropy core.

**Downstream effect:** Supplies `H(E) = h(Pe)` for `C5.05`.

**Documentation implications:** Add a concise module/header comment explaining
the bridge and nats convention.

### C5.03 - Deterministic Decoding-Error Definitions

**Status:** not started

**Objective:** Define the Boolean error event and its probability for joint
PMFs and random variables.

**Prerequisites:** `PMF.map`, project random-variable conventions, and the
contract confirmed in `C5.01`.

**Proposed declarations:** `decodingErrorIndicator`,
`decodingErrorProbability`, `decodingErrorProbabilityOf`,
`decodingErrorIndicator_eq_true_iff`, and
`decodingErrorIndicator_eq_false_iff` (all tentative).

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, namespace
`LeanInfoTheory`.

**Strategy:** Use a Boolean indicator with `true` exactly when
`decoder y != x`. Define error probability from the `true` mass of the mapped
Boolean PMF. Define the random-variable wrapper by mapping the source PMF to
the joint law, following existing `...Of` conventions.

**Edge cases:** Hide classical decidable equality internally; avoid public
`DecidableEq` assumptions; preserve the declared `true = error` convention.

**Focused validation:** `lake build LeanInfoTheory.Shannon.Fano`

**Definition of done:** Definitions and endpoint characterization theorems
compile with stable reducibility and no unapproved assumptions.

**Downstream effect:** Establishes the common error object used by every later
theorem.

**Documentation implications:** Docstrings must state argument roles and the
Boolean convention explicitly.

### C5.04 - Error-Probability Semantics And Range

**Status:** not started

**Objective:** Give a usable finite-sum meaning to decoding error and prove it
is a probability.

**Prerequisites:** `C5.03`, `PMF.map_apply`, `PMF.toReal_nonneg`,
`PMF.toReal_le_one`, and finite sum normalization.

**Proposed declarations:** `decodingErrorProbability_eq_sum` plus PMF and
random-variable nonnegativity and upper-bound theorems. Exact range theorem
names are tentative.

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, namespace
`LeanInfoTheory`.

**Strategy:** Expand the mapped PMF at `true`, rewrite the preimage as decoder
mismatch, and derive `0 <= Pe` and `Pe <= 1` from the PMF mass.

**Edge cases:** The sum theorem should correctly handle empty index types and
duplicate no mass. Its statement should be convenient for concrete examples
without exposing internal map implementation details.

**Focused validation:** `lake build LeanInfoTheory.Shannon.Fano`

**Definition of done:** The semantic sum formula and both range bounds compile
for PMF and `...Of` surfaces.

**Downstream effect:** Supplies range assumptions required by binary/q-ary
entropy lemmas and arithmetic corollaries.

**Documentation implications:** Explain that the sum theorem is the main
event-probability elimination theorem.

### C5.05 - Entropy Of The Error Indicator And Import Checkpoint

**Status:** not started

**Objective:** Identify the entropy of the decoding-error indicator with
`Real.binEntropy Pe`.

**Prerequisites:** `C5.02`--`C5.04`, `PMF.map_comp`, and `entropyOf`.

**Proposed declarations:** `entropy_decodingErrorIndicator` and
`entropyOf_decodingErrorIndicator` (tentative).

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, namespace
`LeanInfoTheory`.

**Strategy:** Reduce the error law to a Boolean mapped PMF, apply
`entropy_bool`, and use map composition for the random-variable wrapper.

**Edge cases:** Endpoint error probabilities, hidden classical equality, and
coercions from `ENNReal` PMF mass to `Real`.

**Focused validation:**
`lake build LeanInfoTheory.Shannon.BinaryEntropy LeanInfoTheory.Shannon.Fano LeanInfoTheory`

**Definition of done:** Both entropy identities compile; a positive consumer
can import Fano directly; a root-only consumer cannot access Fano declarations
without the opt-in import.

**Downstream effect:** Completes the public error API needed by the proof
engine.

**Documentation implications:** Record the first integration checkpoint in
the plan status when implemented.

### C5.06 - Private Conditional Chain Identity

**Status:** not started

**Objective:** Establish the proof-engine identity
`H(X | Y) = H(E | Y) + H(X | E,Y)` for deterministic error `E`.

**Prerequisites:** `C5.03`, `condEntropyOf_pair_chain_rule`,
`condEntropyOf_deterministic_chain_rule`, and
`condEntropyOf_comp_eq_zero`.

**Proposed declarations:** A private helper only; no public name is approved.

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, private
section in namespace `LeanInfoTheory`.

**Strategy:** Apply the deterministic conditional chain rule in both
directions to the pair `(E, X)` conditioned on `Y`, then simplify the
deterministic conditional-entropy term.

**Edge cases:** Ensure tuple orientation agrees with the established
`condEntropyOf_pair_chain_rule` API; do not expose pair projections or
implementation-specific marginal names publicly.

**Focused validation:** `lake build LeanInfoTheory.Shannon.Fano`

**Definition of done:** The exact identity is available privately with no
stronger assumptions than the eventual public Fano theorem.

**Downstream effect:** Splits Fano into the error-entropy and residual-fiber
bounds.

**Documentation implications:** A short proof-structure comment is appropriate
if tuple bookkeeping is otherwise difficult to read.

### C5.07 - No-error Fiber Entropy

**Status:** not started

**Objective:** Show that conditioned on `E = false` and an observation `y`,
the source symbol is determined by `decoder y`, so the corresponding
conditional entropy is zero.

**Prerequisites:** `C5.03`, `C5.06`, conditional PMF semantics, and existing
zero-entropy characterizations.

**Proposed declarations:** Private helper(s) only.

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, private
section.

**Strategy:** Separate zero-mass and nonzero-mass conditioning fibers. On a
nonzero fiber, use the error-indicator characterization to show support is a
singleton; then invoke the existing entropy-zero/support API.

**Edge cases:** Null fibers use the project's total conditional-PMF
convention; no division by a marginal mass may leak into the public theorem.

**Focused validation:** `lake build LeanInfoTheory.Shannon.Fano`

**Definition of done:** The false-error contribution vanishes in the residual
conditional entropy.

**Downstream effect:** Leaves only true-error fibers to bound.

**Documentation implications:** Document the null-fiber branch locally, not
as a new public convention.

### C5.08 - Positive-error Fiber Support Exclusion

**Status:** not started

**Objective:** Show that a positive-mass true-error conditional fiber cannot
contain the decoder output.

**Prerequisites:** `C5.03`, `condFstGivenSnd_apply_ne_zero_iff`, and the
project's conditional-law support transport.

**Proposed declarations:** Private support inclusion/exclusion helper(s).

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, private
section.

**Strategy:** Translate nonzero conditional mass to nonzero joint mass, unfold
the true-error event, and derive membership in the complement of the singleton
`{decoder y}`.

**Edge cases:** Zero-mass fibers, decidable equality hidden internally, and
the difference between support as a set and finite support cardinality.

**Focused validation:** `lake build LeanInfoTheory.Shannon.Fano`

**Definition of done:** A production proof can bound every relevant
true-error fiber support by the decoder-output complement.

**Downstream effect:** Supplies the cardinal input for `C5.09`.

**Documentation implications:** Keep the helper private unless a second
downstream consumer demonstrates genuine API pressure.

### C5.09 - True-error Fiber Entropy Bound

**Status:** not started

**Objective:** Bound each true-error conditional entropy by
`Real.log (Fintype.card alpha - 1)`.

**Prerequisites:** `C5.08`, `entropy_le_log_support_ncard`, and finite-cardinal
lemmas for erasing the decoder output.

**Proposed declarations:** Private fiber-bound helper(s).

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, private
section.

**Strategy:** Apply the support-cardinality entropy bound, prove support is
contained in the erased alphabet, compare `Set.ncard` with
`Fintype.card alpha - 1`, and use monotonicity of `Real.log`. Keep the proof
engine in the Nat-subtraction representation.

**Edge cases:** `card alpha = 0` and `card alpha = 1`, zero support, log at
zero, and the preconditions of `Real.log_le_log`.

**Focused validation:** `lake build LeanInfoTheory.Shannon.Fano`

**Definition of done:** The true-error fiber bound compiles under exactly the
broad public theorem assumptions.

**Downstream effect:** Provides the pointwise estimate summed in `C5.10`.

**Documentation implications:** Note why Nat subtraction is intentional and
why no public nondegeneracy hypothesis is needed.

### C5.10 - Residual Conditional-Entropy Bound

**Status:** not started

**Objective:** Prove
`H(X | E,Y) <= Pe * log(card alpha - 1)`.

**Prerequisites:** `C5.04`, `C5.07`, `C5.09`, and
`condEntropy_eq_sum_sndMarginal_mul_condEntropyFstGivenSnd`.

**Proposed declarations:** A private residual-bound theorem.

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, private
section.

**Strategy:** Expand conditional entropy as a weighted sum of conditional
fiber entropies, split the Boolean error coordinate, eliminate the no-error
term, apply the true-error pointwise bound, and identify the sum of true-error
weights with `Pe`.

**Edge cases:** Nonnegative weights, multiplication by a potentially
zero-valued log term for singleton alphabets, sum rearrangement, and null
fibers.

**Focused validation:** `lake build LeanInfoTheory.Shannon.Fano`

**Definition of done:** The complete private analytic estimate needed for the
public theorem compiles without a generic public fiber abstraction.

**Downstream effect:** Ends the internal proof-engine phase and unlocks
`C5.11`.

**Documentation implications:** Update the plan's second integration
checkpoint after implementation.

### C5.11 - Exact PMF Fano Theorems

**Status:** not started

**Objective:** Publish the exact finite deterministic-decoder Fano inequality
for joint PMFs in expanded and q-ary forms.

**Prerequisites:** `C5.05`, `C5.06`, `C5.10`,
`condEntropyOf_le_entropyOf`, and the q-ary bridge verified in `C5.01`.

**Proposed declarations:** `condEntropy_fano` and
`condEntropy_fano_qary` (tentative).

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, namespace
`LeanInfoTheory`.

**Strategy:** Combine the private chain identity, conditioning-reduces-entropy
for `E`, the Boolean entropy identity, and the residual bound. For the q-ary
form, privately reconcile Nat subtraction with mathlib's integer-cast
definition of `Real.qaryEntropy`.

**Edge cases:** No public `2 <= card alpha` hypothesis; singleton and
mathematically impossible empty-alphabet cases; `Pe = 0` and `Pe = 1`.

**Focused validation:** `lake build LeanInfoTheory.Shannon.Fano`, followed by
disposable singleton and binary consumers.

**Definition of done:** Both PMF statements compile, are mathematically
equivalent, and the expanded theorem is the primary textbook-facing API.

**Downstream effect:** Establishes the main result of Chunk 5.

**Documentation implications:** Full theorem docstrings should state nats,
decoder direction, error convention, and edge-case contract.

### C5.12 - Exact Random-variable Fano Wrappers

**Status:** not started

**Objective:** Expose the exact Fano theorem for a finite source PMF and random
variables `X` and `Y`.

**Prerequisites:** `C5.11`, `condEntropyOf`, and the existing joint-law
wrapping conventions.

**Proposed declarations:** `condEntropyOf_fano` and
`condEntropyOf_fano_qary` (tentative).

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, namespace
`LeanInfoTheory`.

**Strategy:** Apply the PMF theorem to the joint mapped law of `(X,Y)`, then
normalize the error-probability and conditional-entropy definitions.

**Edge cases:** Map composition, tuple orientation, source spaces with zero
mass at some outcomes, and avoiding unnecessary `Fintype omega`.

**Focused validation:** `lake build LeanInfoTheory.Shannon.Fano`

**Definition of done:** Both wrappers compile with only the finite alphabet
assumptions genuinely needed by the project definitions.

**Downstream effect:** Gives textbook users the natural random-variable
surface used by later examples and converse work.

**Documentation implications:** Cross-reference the PMF theorem rather than
duplicating its mathematical explanation.

### C5.13 - Weak Finite-alphabet Fano Corollaries

**Status:** not started

**Objective:** Derive the familiar weaker form
`H(X | Y) <= log 2 + Pe * log(card alpha)`.

**Prerequisites:** `C5.04`, `C5.11`, `C5.12`,
`Real.binEntropy_le_log_two`, and log/card monotonicity.

**Proposed declarations:** PMF and random-variable weak Fano theorems. Final
names are tentative and must be reviewed in `C5.17`.

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, namespace
`LeanInfoTheory`.

**Strategy:** Bound binary entropy by `log 2`; compare
`log(card alpha - 1)` with `log(card alpha)`; multiply by nonnegative `Pe`;
reuse the exact theorem.

**Edge cases:** Preserve the broad no-nondegeneracy contract if Lean's log
lemmas permit it; do not add `2 <= card alpha` merely for convenience.

**Focused validation:** `lake build LeanInfoTheory.Shannon.Fano`

**Definition of done:** Both weak forms compile and are simple corollaries of
the exact API.

**Downstream effect:** Supplies the conventional form used to isolate error
probability.

**Documentation implications:** State that the `log 2` term is the
one-bit textbook constant expressed in nats.

### C5.14 - Generic Error-probability Lower Bounds

**Status:** not started

**Objective:** Rearrange weak Fano into a lower bound on decoding-error
probability.

**Prerequisites:** `C5.13` and positivity of
`Real.log (Fintype.card alpha)` under `2 <= Fintype.card alpha`.

**Proposed declarations:** PMF and random-variable lower-bound theorems,
tentatively of the form
`(H - log 2) / log(card alpha) <= Pe`.

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, namespace
`LeanInfoTheory`.

**Strategy:** Use the weak inequality, prove the denominator positive from the
cardinality hypothesis, and apply ordered-field division lemmas.

**Edge cases:** This is the first step allowed to require
`2 <= Fintype.card alpha`; denominator positivity and Real coercions must be
explicit.

**Focused validation:** `lake build LeanInfoTheory.Shannon.Fano`

**Definition of done:** Both lower bounds compile with no assumption stronger
than alphabet cardinality at least two.

**Downstream effect:** Provides the direct estimation-error form used in
uniform-message corollaries and future coding converses.

**Documentation implications:** Explain why the cardinality hypothesis appears
here but not in the exact theorem.

### C5.15 - Uniform-message Mutual-information Corollaries

**Status:** not started

**Objective:** Combine Fano with uniform source entropy to derive
mutual-information and error lower bounds for uniform messages.

**Prerequisites:** `C5.14`, `entropy_uniformOfFintype`,
`mutualInfo_eq_entropy_fstMarginal_sub_condEntropy`, and the random-variable
analogue.

**Proposed declarations:** PMF and random-variable uniform-message
mutual-information lower bounds, plus the corresponding error-probability
forms. Names remain tentative.

**Target files and namespaces:** `LeanInfoTheory/Shannon/Fano.lean`, namespace
`LeanInfoTheory`.

**Strategy:** Rewrite mutual information as source entropy minus conditional
entropy, rewrite uniform entropy as `log(card alpha)`, apply weak Fano, and
rearrange. Reuse `C5.14` where it yields the cleanest proof.

**Edge cases:** State uniformity through the existing PMF equality surface;
retain `2 <= card alpha` only where division occurs; avoid introducing a new
uniform-distribution abstraction.

**Focused validation:** `lake build LeanInfoTheory.Shannon.Fano`

**Definition of done:** The standard finite uniform-message converse
inequalities compile on both PMF and `...Of` surfaces.

**Downstream effect:** Completes the mathematical theorem surface planned for
Chunk 5 and creates a clean bridge to future coding work.

**Documentation implications:** Mark the third integration checkpoint and
identify coding-theorem use as deferred.

### C5.16 - Permanent Fano Examples

**Status:** not started

**Objective:** Exercise the public API in representative finite cases.

**Prerequisites:** `C5.11`--`C5.15` and existing project example conventions.

**Proposed declarations:** Example theorems only; names will follow the
existing examples namespace and are not part of the core theorem API.

**Target files and namespaces:** New
`LeanInfoTheory/Examples/Fano.lean`; update
`LeanInfoTheory/Examples.lean`; examples namespace consistent with neighboring
files.

**Strategy:** Include a perfect decoder, a singleton alphabet, a concrete
nonzero-error example, and a uniform-message application. Exercise both the
expanded/q-ary and PMF/random-variable surfaces where this remains concise.

**Edge cases:** Examples must not hide theorem assumptions with accidental
nonempty/cardinality instances; the singleton example must genuinely test the
broad contract.

**Focused validation:**
`lake build LeanInfoTheory.Examples.Fano LeanInfoTheory.Examples`

**Definition of done:** All examples compile, use only public declarations,
and expose any ergonomic problem before API freeze.

**Downstream effect:** Supplies evidence for the naming and abstraction review
in `C5.17`.

**Documentation implications:** Examples should be discoverable through the
examples aggregate without changing the root import.

### C5.17 - API, Naming, Simp, And Import Review

**Status:** not started

**Objective:** Review the completed public surface as a reusable library API
before documentation closeout.

**Prerequisites:** `C5.02`--`C5.16`, permanent examples, AGENTS public API
naming policy, and Future Work Note 14.

**Proposed declarations:** No theorem is automatically added or renamed.
Compatibility-preserving aliases or narrowly justified bridge lemmas may be
proposed only when actual use demonstrates pressure.

**Target files and namespaces:** Chunk 5 Lean modules and examples only;
namespace `LeanInfoTheory`.

**Strategy:** Audit declaration length, discoverability, argument order,
implementation leakage, rewrite orientation, simp safety, duplicate theorem
surfaces, and module ownership. Compile positive and negative import
consumers. Preserve existing declarations if aliases are introduced.

**Edge cases:** Do not expose marginal, pair-projection, fiber-helper, or
Nat/Int implementation names in public declarations. Avoid global simp rules
that unfold error definitions or create map-rewrite loops.

**Focused validation:** Focused builds for BinaryEntropy, Fano, examples, and
root, plus disposable direct-import and root-isolation consumers.

**Definition of done:** Every new public name has been audited; any alias is
compatibility preserving and justified by concrete use; import boundaries are
confirmed.

**Downstream effect:** Freezes the Chunk 5 API for documentation and final
validation.

**Documentation implications:** Record awkward names and deferred alias
families in the canonical future-work register during `C5.18`, rather than
renaming declarations silently.

### C5.18 - Canonical Documentation And Project-memory Update

**Status:** not started

**Objective:** Under the shared canonical-document ownership policy, update
the canonical project memory directly in this Chunk 5 thread so the repository
itself accurately records the implemented theorem surface, scope decisions,
validation state, limitations, and future work.

**Prerequisites:** `C5.17` API review is complete and the final public theorem
surface is known.

**Proposed declarations:** None.

**Target files and namespaces:**

- source/module comments in the Chunk 5 Lean files where useful;
- `docs/project-log.md`;
- `docs/lean-info-theory-living-summary.md`;
- this plan's step-status/history fields when implementation progress requires
  them.

`AGENTS.md` remains out of scope. `docs/current-lean-state.md` and
`docs/roadmap.md` are changed only if the canonical documents explicitly show
that they remain active synchronized surfaces and the user approves that
additional scope before editing.

**Strategy:**

1. Add a dated Chunk 5 project-log entry covering the mathematical results,
   public declarations, module/import decisions, examples, validation
   commands, deviations from the approved plan, and unresolved concerns.
2. Update the living summary directly under its shared-ownership policy,
   reconciling the Chapter 2 coverage matrix, current active work, module/API
   inventory, active future-work register, known limitations, and
   validation/build state against source, builds, this approved plan, relevant
   project-log entries, and Git history.
3. Reconcile relevant Future Work Notes, especially Notes 1--6, 8, 14, 17,
   18, 29, 30, and 39. Close, narrow, supersede, or retain each item only when
   the implementation evidence warrants it; preserve historical meaning.
4. Record newly justified future-work candidates from this chunk without
   pulling their implementation into Chunk 5.
5. Cross-check the two canonical documents against the code and this approved
   plan in one coordinated pass.

**Edge cases:** Do not claim builds that were not run; distinguish completed
results from proposed work; preserve dated history; do not rewrite earlier
project-log entries; do not mark broad coding or decision-theory work complete;
do not edit `AGENTS.md`.

**Focused validation:**

- `git diff --check -- docs/project-log.md docs/lean-info-theory-living-summary.md`
- targeted `rg` checks for every newly documented declaration and module;
- the repository's documentation/reference checker where applicable.

**Definition of done:** Both canonical project-memory documents agree with the
actual Chunk 5 code and validation evidence; future-work statuses are
evidence-based; source comments are accurate; no unrelated documentation is
rewritten.

**Downstream effect:** Publishes the verified Chunk 5 context directly for all
project threads. The General Assistant may later perform its normal periodic
cross-thread reconciliation, but that review is neither an approval gate nor
an exclusive editing step.

**Documentation implications:** This step is the canonical documentation
update, not a handoff request. This thread owns its materially justified edits,
and later project threads may maintain the living summary under the same
shared policy. Any later reconciliation must preserve verified Chunk 5 history
and coordinate with the current repository state.

### C5.19 - Generated References And Public-documentation Consistency

**Status:** not started

**Objective:** Regenerate derived API references and verify public
documentation consistency without redesigning the website.

**Prerequisites:** `C5.17` API freeze and `C5.18` canonical documentation
update.

**Proposed declarations:** None.

**Target files and namespaces:** Generated reference artifacts and existing
website data files only as produced by repository scripts.

**Strategy:** Run the repository's API-index/reference generators and website
checker. Inspect generated diffs for the new modules and declarations. Report,
rather than casually rewrite, any unrelated stale website prose.

**Edge cases:** Generated output may include unrelated churn; do not accept it
without inspection. Do not redesign website layout or copy.

**Focused validation:** The repository's documented reference-generation and
website-check commands, followed by `git diff --check`.

**Definition of done:** New public declarations appear in generated
references, website consistency checks pass, and generated diffs contain no
unexplained churn.

**Downstream effect:** Prepares a coherent public artifact set for final
validation.

**Documentation implications:** Record exact generator/checker results in the
final Chunk 5 report and, if necessary, append factual corrections to the
`C5.18` canonical closeout entry.

### C5.20 - Final Chunk Validation And Closeout

**Status:** not started

**Objective:** Validate the complete Chunk 5 implementation and establish a
clean handoff boundary.

**Prerequisites:** `C5.01`--`C5.19` complete or explicitly recorded as
cancelled/superseded.

**Proposed declarations:** None.

**Target files and namespaces:** No planned new source changes. Corrections
must stay within Chunk 5 scope and be followed by revalidation.

**Strategy:** Run focused module builds, examples, root build, full milestone
suite, import consumers, placeholder scans, generated-reference checks, and
working-tree hygiene review. Compare final code against every completion
criterion and ensure `C5.18` documentation still matches the final state.

**Edge cases:** No running build may be abandoned; no `sorry`, `admit`,
unapproved `axiom`, `opaque`, or `undefined`; preserve pre-existing unrelated
working-tree changes.

**Focused validation:** At minimum:

```text
lake build LeanInfoTheory.Shannon.BinaryEntropy
lake build LeanInfoTheory.Shannon.Fano
lake build LeanInfoTheory.Examples.Fano
lake build LeanInfoTheory.Examples
lake build LeanInfoTheory
lake build
```

Also run the repository's placeholder scan, API/reference generation checks,
website checker, and disposable import-boundary consumers.

**Definition of done:** All required commands pass; the final diff is
reviewed; canonical documentation agrees with code; the root remains
lightweight; all statuses and deviations are accurately recorded.

**Downstream effect:** Declares Chunk 5 ready for checkpointing and later
planning. It does not authorize the next chunk.

**Documentation implications:** If final validation changes any result or
status, amend the `C5.18` canonical entries factually before declaring
completion.

## Integration Checkpoints

1. **After C5.05:** Boolean/error API compiles; Fano is opt-in; root isolation
   is tested.
2. **After C5.10:** The private conditional-fiber proof engine compiles under
   the broad theorem contract.
3. **After C5.15:** The complete mathematical API compiles on PMF and
   random-variable surfaces.
4. **After C5.17:** Public names, imports, simp behavior, and examples are
   reviewed and frozen.
5. **After C5.20:** Full build, documentation, generated references, and
   project-memory closeout agree.

No later step begins without explicit user approval, even at an integration
checkpoint.

## Chunk-completion Criteria

Chunk 5 is complete only when:

- `entropy_bool` or its approved replacement is available;
- the deterministic error indicator/probability API has clear semantics and
  range theorems;
- exact expanded and q-ary PMF Fano theorems compile without a public
  nondegeneracy assumption;
- exact random-variable wrappers compile;
- weak Fano and generic error lower bounds compile;
- uniform-message mutual-information/error corollaries compile;
- singleton, perfect-decoder, nonzero-error, and uniform examples compile;
- no placeholder or unapproved axiom is introduced;
- root and semantic-bridge import boundaries remain unchanged;
- public naming and simp behavior are reviewed;
- generated references and website checks pass;
- `docs/project-log.md` and `docs/lean-info-theory-living-summary.md` accurately
  record the completed chunk;
- all focused and full validation commands pass;
- every deviation, cancellation, or follow-up is recorded honestly.

## Explicitly Deferred Work

- Future Work Note 1: finite-family entropy semantics beyond what Fano needs.
- Future Work Note 5: coding-theorem and converse infrastructure.
- Future Work Notes 2--4: broad import/module guardrails not specifically
  exercised by this chunk.
- Future Work Note 6: upstreaming candidates before the API stabilizes.
- Future Work Note 8: broad project re-audit outside Chunk 5.
- Future Work Note 14: unrelated naming families; Chunk 5 names are audited in
  `C5.17`.
- Future Work Note 17: release/checkpoint policy beyond the final Chunk 5
  validation.
- Future Work Note 18: broader module-boundary work outside Fano's opt-in
  boundary.
- Future Work Note 29: portions beyond the finite deterministic-decoder Fano
  phase.
- Future Work Note 30: general null-fiber abstractions without repeated proof
  pressure.
- Future Work Note 39: sufficient-statistics work unrelated to finite Fano.
- Future Work Notes 11--13: certificate-system work.
- Randomized estimators, list/support-adaptive Fano, equality cases, capacity,
  generic public fiber bounds, a public error-law PMF, and Bernoulli aliases.

The exact disposition of these notes must be re-read from the current project
log in `C5.18`; this list records scope, not authority to close any note.

## Proposed Future-work Candidates

Add or refine a future-work entry only if implementation evidence supports it:

- randomized decoders and a decision/risk abstraction;
- list-decoding and support-adaptive Fano inequalities;
- equality and sharpness cases;
- a generic conditional-fiber support/cardinality entropy theorem after a
  second real consumer;
- a public decoding-error law, zero-error characterization, or Bernoulli
  bridge after demonstrated API pressure;
- coding-converse use of the uniform-message corollaries, owned by the existing
  coding future-work item;
- upstreaming generally useful bridges after names and statements stabilize.

## Known Risks

- The positive-error support proof may require careful transport through total
  conditional PMFs and null fibers.
- Identifying the sum of true-error conditional weights with `Pe` may expose
  awkward pair/marginal rewrites.
- The broad singleton contract can reveal hidden positivity assumptions in
  log/card lemmas.
- Mathlib's `Real.qaryEntropy` uses an integer-cast `q - 1`, while the natural
  finite-cardinality proof uses Nat subtraction.
- Classical equality can accidentally leak into public typeclass assumptions.
- Fano's semantic imports are intentionally heavier and must not reach the
  root.
- Premature aliases can create an incoherent theorem family.
- The baseline working tree contains pre-existing documentation changes that
  must be preserved and distinguished from Chunk 5 edits.
- Generated website/reference output may reveal stale prose or unrelated
  churn.

## Plan-revision Policy

- Implementation discoveries may justify changing later steps.
- Every proposed plan change must be explained to the user before editing this
  plan.
- Completed implementation history must not be rewritten misleadingly.
- Cancelled or superseded steps remain recorded with their original stable ID
  and a factual reason.
- New steps receive new IDs; completed IDs are never recycled.
- If a theorem statement changes materially, record the old proposal, the new
  contract, and the mathematical/API reason.
- Scope, public API, module ownership, or naming-policy changes require
  explicit user approval.
- No later step begins without the user's approval.
- Completing a step or checkpoint does not authorize beginning the next step.
- If a discovery invalidates the dependency graph or approved theorem
  contract, stop implementation and return for review.
