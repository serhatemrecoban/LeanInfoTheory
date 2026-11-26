# C34 implementation notes

## C34.04 — Cumulative qualification and handoff (14 November 2026)

The [C35 handoff](../handoffs/chunk-34.md) gives the three endpoint signatures,
the C33 error definition, the two joint laws and both strict regimes. It maps
all thirteen approved criteria to their proof, consumer or qualification
record and records the disposition of both revision 1 findings. The C33
source-matched export and C33 clean checkpoint are distinct historical
inputs. The cumulative check compares the same 876 elaborated rows, then
accounts for the two new declarations. The independent prefix-code
package retains its own intake.

C34.04 records primary command outputs, named and clean qualification, the
original verified-file report, reconciliation and the final closure under
`.lit-review/setup/c34-04-20261114/`. Each result belongs to the candidate
identified in its own record. The maintained handoff points to these records
so the checkpoint can also contain the handoff it qualifies.

## C34.03 — Permanent consumers and separation boundaries (14 November 2026)

For two independent fair bits, the encoder repeats the first bit over the
noiseless Boolean channel. The output retains one bit of information.
Both source/output and input/output mutual information are `Real.log 2`, as
is the conditional entropy of the source given the output. Reconstruction by
identity fails on the two unequal-bit words. Replacing the actual input law
with the product of its marginals doubles the mutual information.

For C33's biased Boolean source at length four, `4 H(p) − 3 log 2 = log (32/27) > 0`.
The finite converse forces error strictly greater than one half for every
encoder and decoder on the constant-output channel. The fair-source example
separately rules out vanishing error for every all-length code family. A
singleton source has error zero at every length, and the empty source word
has error zero even for the Boolean alphabet.

A separate caller imports only the direct and converse owners. Below capacity,
it passes the error-limit witness constructed by C33 to C34 for the same pair
of families. Above capacity the converse rules out existence of such a pair.
The strict regimes leave general equality and a strong converse undecided.

The six-target warning-as-error build and development static gate passed. Adding the two-import caller increased the development module count by one. The manifest retains the same 878 supported declarations, 69 supported modules, 94 reviewed simp declarations and 92 lightweight-root exports.

The independent reviewer verified the 83,043-byte request and all 405 inventory entries, compiled both example files and their aggregate, and independently enumerated the Boolean laws. All five criteria were satisfied. The parent accepted each assessment. Original evidence is retained under `.lit-review/setup/c34-03-20261114/`. C34.04 owns cumulative validation and the C35 handoff.

[Concrete consumers](../../LeanInfoTheory/Examples/SourceChannelConverse.lean) · [Two-import caller](../../LeanInfoTheory/Examples/SourceChannelSeparationPackage.lean)


## C34.02 — Vanishing error forces the entropy bound (14 November 2026)

`entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability` takes arbitrary total families `E` and `D` and the limit of C33's error for exactly those families. For every positive length, C34.01 gives

```text
H(p) ≤ C(W) + log 2 / n + Pe(n) · log |S|.
```

The first correction tends to zero with reciprocal blocklength. The second tends to zero by the error hypothesis multiplied by the fixed real logarithm. Closedness of the real order gives `entropy p ≤ channelCapacity W`. This also handles singleton sources. CT91 §8.13, Theorem 8.13.1, and PW24 §19.7, Theorem 19.22 and (19.36), specialize here to an iid source and one channel use per source symbol.

The focused examples consume the result with arbitrary word maps and rule out a zero error limit for the same families when capacity is strictly below source entropy. C33 constructs a family below capacity. These two directions leave equality and convergence of the error to one outside the theorem. The clean cumulative validation belongs to C34.04.

The bound reviewer independently compiled the owner and its focused callers, verified both criteria, and reported no findings. The parent accepted both assessments. The focused warning-as-error build and static gate passed. The 878-row compiled export retains all 877 prior declaration records exactly. The local review evidence is under `.lit-review/setup/c34-02-20261114/`.

[Limit theorem](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean) · [Focused examples](../../LeanInfoTheory/Examples/SourceChannelConverse.lean) · [Approved plan](release-3-chunk-34.md)

## C34.01 — Finite-block converse (14 November 2026)

The new theorem in `Shannon.SourceChannelConverse` bounds iid block entropy by blocklength times channel capacity, plus the binary Fano overhead and the actual reconstruction error times the log cardinality of the source-word alphabet. The encoder may identify source words of positive mass and its output coordinates may be dependent.

A private finite-law lemma constructs the triple by extending the deterministic encoder joint with the channel row. Its two projections are the source/output law and the channel-input/output law at the encoder pushforward. Reversing this Markov chain bounds the former mutual information by the latter. Weak Fano uses the actual decoder on the former joint. The memoryless bound applies to the latter with its actual input prior. The result is undivided and applies at length zero, where it gives `0 ≤ Real.log 2`.

The focused consumer rearranges the theorem to isolate the entropy excess and specializes to the empty word. C34.02 owns positive-length normalization and the family limit. The incoming baseline is the C33.06 export of 876 compiled names. The new owner adds one supported theorem and directly imports only the error owner and product capacity.

### Validation and independent review

The four-target warning-as-error build covered the focused theorem and examples and both umbrellas. The development static gate and the four generated-artifact checks passed. The compiled audit checked the exact public type, its three permitted axioms, and all 876 inherited declaration records against C33.06. The new surface contains 877 declarations in 69 modules, with 94 reviewed simp declarations and 92 lightweight-root exports.

The independent reviewer verified the 78,623-byte request, all 403 captured files and the environment entry. They compiled the owner and both examples, checked the reversed Markov comparison and C33's error under the original joint law, and confirmed the focused import and umbrella boundaries. They assessed C34.01-LAWS, C34.01-FANO and C34.01-BOUND as satisfied and reported no findings. The parent accepted each assessment. The cumulative clean development suite belongs to C34.04.

The original report, compiled audit, parent reconciliation and closure evidence are retained under `.lit-review/setup/c34-01-20261114/`.

[Approved plan](release-3-chunk-34.md) · [Finite theorem](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean) · [Focused consumer](../../LeanInfoTheory/Examples/SourceChannelConverse.lean)
