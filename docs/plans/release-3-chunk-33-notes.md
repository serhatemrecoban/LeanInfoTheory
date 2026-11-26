# C33 implementation notes

## C33.01 — Common block reconstruction error (14 November 2026)

The lead selected C33.01 under [approved revision 2](release-3-chunk-33.md).
The focused [finite owner](../../LeanInfoTheory/Shannon/SourceChannelCode.lean)
imports `Shannon.SourceCoding` and `Shannon.ChannelCodeExpurgation`.
Its single public declaration, `sourceChannelErrorProbability p W n E D`,
evaluates the released `decodingErrorProbability` on the original source
word and actual channel output. Source and output types have `Fintype`
instances. The definition takes arbitrary total maps between the indicated
word types, with independent universes for source, input and output.

Write `q = PMF.iid p n` and `Wn = PMF.memorylessChannel W n`.
The [development consumer](../../LeanInfoTheory/Examples/SourceChannelCode.lean)
has three obligations from the plan.

- **C33.01-LAW** identifies the joint atom at `(s,y)` as
  `q s * Wn (E s) y`, the source marginal as `q`, and the real error
  as the mass of the pairs with `D y ≠ s`. Unfolding supplies the same term
  in the weak Fano bound.
- **C33.01-PROJECTION** maps the joint by `(s,y) ↦ (E s,y)`, obtaining
  `PMF.channelJoint (q.map E) Wn`. The output coordinate is preserved
  while the pushforward aggregates source words sharing the same input.
  This identifies the law C34 can use in the product-channel capacity bound.
- **C33.01-BOUNDARY** checks the range `[0,1]`, zero error for the unique
  empty source word and for a singleton source at any length, and a
  many-to-one encoder whose decoder is total on zero-mass outputs.

[CT91 §8.13 and PW24 §19.7](../references.md#source-selection) provide
the sampling and decision conventions. The finite pushforward equality
and Lean bridges to Fano and block capacity are project calculations.
The API grew by one declaration and one module, to
874 public names in 67 supported modules. The root and simp controls
are two direct imports, five reachable modules, 92 exports and 94
reviewed simp names.

**Validation and review.** The finite owner, focused consumer and Shannon and
Examples umbrellas passed the warning-as-error build. The development static
and trust gates passed. The compiled comparison retained all 601 and 811
historical declarations and every one of the 873 C32 signatures. The
all-project audit checked 4567 local constants and found only the three
permitted axioms. In the many-to-one example both Boolean words go to the same
input. The channel always emits zero and the reconstruction error is exactly
one half, with a specified decoder value at the impossible output.

The bound independent reviewer marked LAW, PROJECTION and BOUNDARY satisfied
with ten verification entries and no findings. The reviewer also compiled the
existing block-capacity inequality at the projected input prior. Parent
reconciliation accepted all three assessments. The original report, final
applicability checks and scoped completion record are retained under
`.lit-review/setup/c33-01-20261114/`. The full clean-checkpoint suite belongs
to C33.06. C33.02 awaits a separate selection.

## C33.02 — Finite composition inequality (14 November 2026)

The lead selected this step after the C33.01 closure, original review and
exact final source were verified. For a source code $a$ and a channel code
$b$ at the same budget, let $q$ be the iid source-word law and let $π$ be
its image under the source encoder.

- **C33.02-PRIOR.** The public theorem `sourceChannelErrorProbability_comp_le`
  bounds block reconstruction error by the sum of the source error at $q$
  and the channel error at $π$. A failed reconstruction requires a source
  failure or a wrong channel decision on that sampled pair. Summing over
  outputs recovers the source error. Grouping source words by the label
  they encode gives the prior-weighted channel error, including for a
  many-to-one encoder.
- **C33.02-RESTRICT.** The development caller follows the encoder embedding
  and the decoder's inverse and fallback. It compares the reconstructed
  error with the restricted prior and maximal errors, with the weighted
  original rows on the embedded labels, and with their maximum. The
  original full maximum bounds both the embedded and restricted maxima.
  At equal budget the identity embedding recovers the original code.
  In C32's four-label example, retaining labels 0 and 1 gives embedded
  maximum 0 while the full maximum is 1. Receiving the discarded label 2
  selects the supplied fallback even though that output is impossible from
  either retained input.

[Finite theorem](../../LeanInfoTheory/Shannon/SourceChannelCode.lean) ·
[Restriction consumer](../../LeanInfoTheory/Examples/SourceChannelCode.lean)

**Validation and review.** The finite owner, restriction consumer and both
affected umbrellas passed the warning-as-error build. The static and generated
artifact checks passed. A fresh export retained the exact compiled rows for
all 874 incoming declarations. The only addition is the stated theorem, in
the same owner, bringing the library to 875 declarations in 67 supported
modules. The statement compiled at separate universes for source, input and
output with no input-alphabet instance or positive-budget premise. Its axiom
set is the permitted three and it has no simp attribute. The lightweight root
retains two direct imports, five reachable modules and 92 exports.

The original independent report marked PRIOR and RESTRICT satisfied. Its
single editorial finding was resolved by correcting the current-phase link
label in the living summary. Parent reconciliation accepted both assessments.
The reviewer also enumerated 2,304 cases in a noisy finite channel model.
The induced-prior bound held in all of them. A uniform-prior substitution
failed in 96. The first focused
build flagged two long lines in the consumer. The first auxiliary simp query
also required an explicit monad lift. Corrected runs passed and both original
diagnostics are preserved. The reviewed step is identified by its private
completion record under `.lit-review/setup/c33-02-20261114/`. C33.01 retains
its own whole-project trust result. Full cumulative validation belongs to
C33.06.

## C33.03 — Testing the prior and the composition inequality (14 November 2026)

Both tests operate at length one on C32's original four-message collision
code. Its noiseless ternary channel and decoder reproduce labels 0, 1 and 2.
Sent label 3 produces the same channel input as label 2 and is decoded as 2.

- **C33.03-COLLISION.** The identity source code sends the single source
  symbol as its message and reconstructs the constant word. Concentrating
  the iid law on symbol 3 induces the pure prior on message 3. The source
  error is 0, the uniform channel error is 1/4, and the channel error under
  the actual prior is 1. In the source/output joint the only pair is the
  word 3 with output 2. Reconstruction therefore has error 1, which exceeds
  the proposed uniform-prior upper bound of 1/4.
- **C33.03-REPAIR.** Give symbols $(a,b,c)$ masses $(1,3,4)/8$. The
  compressor encodes them as $(3,3,0)$ and assigns reconstructions
  $(c,c,b,a)$ to labels 0 through 3. The sent prior is $(4,0,0,4)/8$.
  The source-only decisions are $(a,a,c)$, the received labels are
  $(2,2,0)$, and the final decisions are $(b,b,c)$. Label 2 carries zero
  sent mass and decoded mass 4/8. On $b$, both component decisions err and
  the composite recovers the source. The source error is 3/8, channel error
  is 4/8 and reconstruction error is 1/8, giving $1/8 < 3/8 + 4/8$.

The examples apply the public finite theorem to the same codes used for
the independent error calculations. These numerical fixtures are project
regressions for the sampling and error conventions in CT91 §8.13 and PW24
§19.7. [Lean examples](../../LeanInfoTheory/Examples/SourceChannelCode.lean)

**Validation and review.** The focused warning-as-error build compiled the
two regressions and the Examples aggregate. The development static gate
passed, including its generated-artifact checks. A separate exact-rational
enumeration reproduced both source priors, both channel decisions and all
six error probabilities. The supported sources, imports and API manifest
match C33.02, with 875 names in 67 modules.

The bound reviewer marked both criteria satisfied with no findings. Independent
exact enumeration reproduced the sent and decoded priors and the mass 3/8 on
which a wrong channel decision repairs the source error. The reviewer also
compiled the consumer and the Examples aggregate. Parent reconciliation
accepted both assessments.
The original independent report, parent reconciliation and scoped completion
record are retained under `.lit-review/setup/c33-03-20261114/`. C33.04
requires a separate selection.

## C33.04 — Direct lossless source–channel separation (14 November 2026)

The theorem `exists_sourceChannelCode_tendsto_errorProbability_zero` takes a
finite iid source, a finite memoryless channel with nonempty input alphabet,
and a strict entropy–capacity gap in nats. It returns an encoder family and
a reconstruction family on words of the same length. Both witnesses precede
the limit over blocklength. [Direct theorem](../../LeanInfoTheory/Shannon/SourceChannelSeparation.lean)

- **C33.04-FIT.** Choose two rates strictly inside the gap. The source family
  has an eventual upper bound at the lower rate. C31 supplies a channel
  family at the higher rate, and C32 gives its full retained family with
  vanishing maximal error. Applying its rate floor with half the difference
  between the two rates gives an eventual comparison at positive lengths.
  Exponentiating the rate comparison gives the natural budget inequality.
- **C33.04-FAMILY.** Where the lengths are positive and the source budget
  fits, embed the source labels into the retained labels in order and use
  the exact-size restricted channel code. Its decoder sends discarded
  labels to source index zero. Elsewhere the encoder always transmits the
  retained codeword at label zero, and the decoder always returns the
  source reconstruction at label zero. Both families have positive budgets
  at every length, so these words exist even at zero.
- **C33.04-LIMIT.** On the fitting tail, the finite bound uses the actual
  source-encoder message prior. Its channel term is bounded by the
  restricted maximum and then by the full retained maximum using C32's
  rowwise restriction theorem. The source error plus that full maximum
  tends to zero. Nonnegativity and the eventual upper bound give the limit
  for the one chosen pair of families.

CT91 §8.13, (8.142)–(8.147), gives the equal-blocklength direct argument.
In PW24 §19.7, Theorem 19.22 and its maximal-error construction start on
printed p. 392 (PDF 417). The achievability estimate continues on p. 393.
The eventual integer budget comparison and explicit exceptional-length maps
adapt it to the released Lean interfaces. [Source register](../references.md)

**Validation and review.** The focused warning-as-error build passed after three
proof-layout warnings were corrected. The original failure is preserved. The
development static gate passed with the regenerated API and website artifacts.
Fresh compiled comparison retained all 875 incoming public declarations and
checked the new theorem's statement with three independent universes, its
permitted axioms, all 68 supported direct-import sets and all 94 default-simp
names. A separate root-only probe checked two direct imports, five reachable
modules and 92 exports. A pure-source caller exercised the returned witnesses
at lengths zero and one. The supported surface is 876 declarations in 68 modules.
The cumulative clean development suite belongs to C33.06.

The independent reviewer marked FIT, FAMILY and LIMIT satisfied with no findings. Their compiled probes checked the two zero-length words, both constant maps when the budgets at length one are four and three, and the supplied fallback for a discarded decoded label. They also compiled the theorem owner, the Shannon umbrella and a generic caller reusing one pair of witnesses. Parent reconciliation accepted all three assessments.
The original report and parent reconciliation are retained under `.lit-review/setup/c33-04-20261114/`. C33.05 awaits separate selection.

## C33.05 — A biased source on a noisy channel (14 November 2026)

- **C33.05-GAP.** The existing Boolean source `StochasticChannels.biasedLaw`
  assigns mass $1/4$ to false and $3/4$ to true. The memoryless binary
  erasure channel has erasure probability $1/8$. Applying `entropy_bool`
  and `channelCapacity_binaryErasureChannel` gives
  $H=2\log 2-(3/4)\log 3$ and $C=(7/8)\log 2$ in nats. Thus
  $C-H=(3/8)\log(9/8)>0$, since $9/8>1$.
- **C33.05-CALLER.** The strict gap supplies the hypothesis of
  `exists_sourceChannelCode_tendsto_errorProbability_zero`. The example
  takes its encoder, decoder and error limit once. For any positive
  tolerance, the open interval below that tolerance contains zero, so the
  block error of the same maps eventually lies below it. Source and input
  words are Boolean and output words have symbols of type `Option Bool`.

The example has its own development module so its stochastic fixture and
concrete capacity imports stay with the caller.
[Biased erasure example](../../LeanInfoTheory/Examples/SourceChannelSeparation.lean)

CT91 §2.1, pp. 13–14, gives binary entropy. The binary erasure capacity
formula is in CT91 §8.1.5, pp. 187–188, and PW24 §19.3, p. 380.
The factor of $\log 2$ converts capacity from bits to nats.
[Reference register](../references.md)

**Validation and review.** The focused warning-as-error build compiled the
example and the Examples aggregate after one theorem call was wrapped to
meet the project's line-length rule. The initial warning is retained in the
private build log. The development static gate passed. A separate compiled
probe checked all six one-use channel atoms and tested the returned pair
before every tolerance. Exact rational arithmetic also gave
$\exp(8(C-H))=729/512>1$. The generated inventory adds the development
module and retains all 876 supported declarations in 68 modules. The full
clean development suite belongs to C33.06.

The independent reviewer marked GAP and CALLER satisfied with no findings. They checked the orientation of both source probabilities, recomputed the logarithm coefficients by exact rational arithmetic, and verified that the returned encoder and decoder precede every tolerance in the caller. They independently compiled the example and its aggregate with warnings as errors. Parent reconciliation accepted both assessments.
The original review and parent reconciliation are retained in `.lit-review/setup/c33-05-20261114/`. C33.06 awaits separate selection.

## C33.06 — Cumulative validation and C34 handoff (14 November 2026)

The fifteen-row matrix maps every approved criterion to its Lean owner,
consumer or closeout record. It lists the three supported declarations, the
separate uses of the source/output joint and its pushforward, the exact prior
and maximum bounds, the two finite examples and the biased-source application.
It records the previously resolved C33.02 link-label finding and all five
incoming closures. [Maintained handoff and source identities](../handoffs/chunk-33.md)

The fresh primary gates cover the mathematical producers, examples and
umbrellas, all generated artifacts, documentation, compiled retention,
compatibility and trust. The approved clean checkpoint and its unfiltered
development suite are recorded separately from the primary run. The exact
checkpoint commit, tree, suite outcome, reconciled independent assessments
and final source are identified by the private C33.06 completion record.
C34 requires its own plan and selection.
