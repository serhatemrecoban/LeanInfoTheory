# Chunk 31 — Finite memoryless channel coding and operational capacity

For finite channels with nonempty input, every nonnegative rate strictly below
information capacity is achievable. Information capacity is the least upper
bound of rates satisfying the same operational predicate. One positive-budget
deterministic code family has vanishing uniform-message average error and meets
every positive rate tolerance eventually. The family is chosen before the
tolerance. The one-message family supplies zero even at zero capacity.
[Approved plan](../plans/release-3-chunk-31.md) ·
[Cumulative criterion matrix](../plans/release-3-chunk-31-notes.md#complete-cumulative-criterion-matrix)

## Focused import and exact public interface

```lean
import LeanInfoTheory.Shannon.OperationalCapacity

open LeanInfoTheory.Shannon Filter
```

The owner directly imports `ChannelCodingAsymptotic`, `ChannelCodingOneShot` and
`IidInformationDensity`, all under `LeanInfoTheory.Shannon`. The full
`LeanInfoTheory.Shannon` umbrella imports it. The lightweight root does not.
The channel remains a raw function `X → PMF Y`; rates use nats per channel use.
[Owner and proofs](../../LeanInfoTheory/Shannon/OperationalCapacity.lean)

These are the source statements in the owner's `universe u v` context.

```text
def IsAchievableRate {X : Type u} {Y : Type v} [Fintype Y]
    (W : X → PMF Y) (R : ℝ) : Prop :=
  0 ≤ R ∧
    ∃ (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
      (c : ∀ n, BlockChannelCode X Y n (M n)),
      Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0) ∧
      ∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (M n)

theorem isAchievableRate_zero {X : Type u} {Y : Type v} [Nonempty X] [Fintype Y]
    (W : X → PMF Y) : IsAchievableRate W 0

theorem isAchievableRate_of_lt_channelCapacity
    {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]
    (W : X → PMF Y) {R : ℝ} (hR : 0 ≤ R) (hlt : R < channelCapacity W) :
    IsAchievableRate W R

theorem le_channelCapacity_of_isAchievableRate
    {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]
    (W : X → PMF Y) {R : ℝ} (h : IsAchievableRate W R) :
    R ≤ channelCapacity W

theorem isLUB_isAchievableRate
    {X : Type u} {Y : Type v} [Fintype X] [Nonempty X] [Fintype Y]
    (W : X → PMF Y) :
    IsLUB {R : ℝ | IsAchievableRate W R} (channelCapacity W)
```

The decoder is total and message-valued. Error is the released uniform-message
average for `PMF.memorylessChannel W n`. Message counts are positive at every
natural length, including zero. Initial segments may be arbitrary. Only the
starting length of a rate tail may depend on the tolerance. Neither the
definition nor the converse assumes that the family's rates converge.

## Construction and consumer evidence

The direct theorem fixes a capacity-attaining input law `p`, a slope
`R < s < I(p;W)` and the rounded budgets `roundedMessageSize n R`. C30 supplies
a code at each original length and budget with error at most the literal
true-pair miss plus the competing term. C28 controls that same miss at threshold
`n*s`. Rounding bounds the competing term by `exp(-n*(s-R))`. One classical
choice per length fixes the family before either operational clause. The
released rounded-rate lower bound is used only on the positive-length tail.
[C30 finite caller](../../LeanInfoTheory/Examples/ChannelCodingOneShotFinite.lean) ·
[C30 handoff](chunk-30.md)

The converse opens one witness and applies C23's tolerance cap to its identical
`M,hM,c,he`. Under `C<R`, the common rate floor and cap at `(R-C)/3` contradict
the gap. Leastness combines that upper bound, strict-subcapacity achievability
and the singleton witness. An upper bound below capacity would admit an
achievable midpoint above itself. No general capacity-membership claim is used.

[Permanent operational consumers](../../LeanInfoTheory/Examples/OperationalCapacity.lean)
exercise two tolerances on one witness, thin singleton assumptions, arbitrary
dependent families and both least-upper-bound clauses, including capacity zero.
The half-erasure BEC has capacity `Real.log 2 / 2` and positive achievable rate
`Real.log 2 / 4`. Any fixed output PMF on nonempty finite input has achievable
rate set exactly `{0}`, witnessed by the singleton family even though no
nonnegative strict-subcapacity target exists. Only the channel fixtures add
`Shannon.StandardChannelCapacity` on the consumer side.

The [C23 alternating-family regression](../../LeanInfoTheory/Examples/ChannelCodingAsymptotic.lean)
retains zero error and no rate limit. That same family witnesses target zero,
while arbitrarily late even lengths violate the floor for target `log 2 / 2`
at tolerance `log 2 / 4`. This negative statement concerns that family, not
the noiseless channel's achievable set.

## C32 caller and responsibilities

The final anonymous caller in
[Examples.OperationalCapacity](../../LeanInfoTheory/Examples/OperationalCapacity.lean)
opens an operational witness exactly once. It returns the same `M,hM,c`, error
limit and every-tolerance rate floor before any proposed retained budget is
supplied. Given any `M' : ℕ → ℕ` positive at every length, it assumes only the
eventual rate-loss inequality

```text
codeRate n (M n) - Real.log 2 / (n : ℝ) ≤ codeRate n (M' n).
```

For any `δ>0`, intersect the original floor at `δ/2`, that loss bound and the
positive-length tail where `log 2/n < δ/2`. The caller derives the eventual
floor `R-δ ≤ codeRate n (M' n)`. It uses only the public predicate and the
existing natural-denominator limit. It does not inspect private rounded
budgets, construct retained codes or transfer an error bound to nonexistent
codes.

C32 supplies per-message-index errors and their uniform mean, a nonempty set
of at least `ceil(M/2)` indices with errors at most twice the mean, reindexing
and total decoder transport, further restriction to any requested positive
budget, and the finite rate-loss estimate at positive lengths. One selected
new code must satisfy the error bound for every message prior. A different
relabeling for each prior does not discharge that contract. Preserve the
collision example and all-priors distinction in the
[C32 roadmap](../plans/release-3-chunk-map.md#c32-per-message-error-expurgation-and-message-restriction).
No C32 implementation or reviewer binding is started by this handoff.

## Source adaptations, validation and limits

[Registered source details](../references.md) distinguish PW24's decoder erasure
and tolerance-indexed existence from this total-decoder, one-family contract.
CT91 §8.5 uses maximal error for operational achievability; C31 takes the
deterministic uniform-average-error code selected in §8.7 before expurgation.
CT91 Theorem 8.7.1 is stated on printed p. 198; its proof is on pp. 199–202.
C31's nats, ceiling budgets, strict threshold and its closed miss, and C23's
arbitrary-budget tolerance converse are recorded adaptations. The registered
PW24 erasure-weight qualification remains applicable to its BEC display.
The cumulative reference pass freshly matched both book hashes and inspected
selected text only, with no new visual audit.

The supported growth is exactly five names, from C30's 852 to 857, in one new
owner, from 63 to 64 modules. The root keeps two direct imports, five reachable
modules and 92 exports; the reviewed simp set stays at 94. No helper or simp
attribute is promoted in closeout. The cumulative matrix links all thirteen
criteria to current source, permanent consumers and validation requirements.
Original checks, authorized source-matched clean-suite evidence, review,
reconciliation, final applicability and closure belong to
`.lit-review/setup/c31-05-20261112/completion.json` when established. Earlier
passes remain attributed to their original sources and do not replace fresh
cumulative qualification. The prior C30 checkpoint authority does not authorize
a C31 commit. The separate full API-documentation gate is not claimed here.

General achievability at capacity, a strong converse, maximal error, expurgation
and message restriction remain outside C31. C32 needs its own approved plan,
explicit selection and persistent reviewer.
