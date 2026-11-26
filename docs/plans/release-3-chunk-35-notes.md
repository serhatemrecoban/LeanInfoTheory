# C35 implementation notes

## C35.04 — Cumulative qualification

The maintained [C35 handoff](../handoffs/chunk-35.md) identifies the three
declarations, the focused imports, the permanent examples and all twelve
acceptance criteria. The source baseline is the C34.04 export of 878
elaborated signatures qualified at C35.01. C35 adds one predicate and two
theorems. The full public surface is 881 declarations in 70 modules, with
92 exports from the lightweight root and 94 reviewed simp declarations.

The three earlier step closures and the resolved C35.01 dependency-count
finding are indexed in the handoff. For C35.04 the primary gate receipts,
the independent report and the final source are recorded in
`.lit-review/setup/c35-04-20261114/`. For the clean development suite and
hygiene result, use the verified checkpoint receipt with its commit and
tree. The final completion record identifies which checks apply to the
reviewed source. C36 requires a separate plan and step selection.

## C35.03 — Permanent prefix-code consumers

CT91 §5.1, equation (5.3) (printed p. 79), assigns the words `0`, `10`
and `11` to its three labels in that order. The examples use the labels
`a`, `b` and `c`. They verify the displayed encoder and its exact Kraft
sum, and independently use realization to recover lengths `(1,2,2)` and
apply necessity to the returned code. For lengths `(3,1,2)`, a second
call recovers each label's length from a strict budget of `7/8`. For
`(1,1,1)`, public necessity would imply `3/2 ≤ 1`.

An empty alphabet has Kraft sum zero. A singleton of length zero realizes
the empty word and has sum one. Its codeword image fails unrestricted
unique decodability because one and two copies of the empty word flatten
to the same list. At every prescribed count there is only one source tuple.

For the Boolean point mass at `false`, the encoder's domain is
`↥(PMF.pure false).supportFinset`. The example checks that `false` belongs
to this support, that `true` lies outside it, and that every supported
label receives length zero and the empty word. This uses PW24 §10.1's
single-shot support convention (printed pp. 197–198) and distinguishes it
from the stream convention in §10.3 (pp. 206–207).
[Lean consumers](../../LeanInfoTheory/Examples/PrefixCode.lean) · [Reference register](../references.md#source-selection)

The independent reviewer assessed all four C35.03 criteria as satisfied and
reported no findings. The five-target warning-as-error build and development
static gate passed. The compiled audit retained all 881 public declarations
with byte-identical signature output. It checked the two direct example
imports, the development aggregate, all 70 supported modules, the 92 root
exports and the 94 reviewed simp declarations. C35.04 owns cumulative
validation and the C36 handoff.

## C35.02 — Realization of prescribed lengths

Import `LeanInfoTheory.Shannon.PrefixCode` for
`LeanInfoTheory.Shannon.exists_isBinaryPrefixCode_of_kraft_sum_le_one`.
Given `[Fintype S]`, a length function `ℓ : S → ℕ` and
`(∑ a : S, (1 / 2 : ℝ) ^ ℓ a) ≤ 1`, the theorem returns
`∃ c : S → List Bool, IsBinaryPrefixCode c ∧ ∀ a, (c a).length = ℓ a`.
A caller can apply Kraft necessity to the chosen encoder or substitute
the prescribed length for its codeword length at any label.

For a new label of maximal length `d`, the candidate leaves are all
`List.Vector Bool d`. The depth-`d` leaves with a given old word of length
`k ≤ d` as a prefix form the image of appending every length-`d − k`
Boolean suffix to that word. This identifies the filtered set of leaves
with an image of cardinality at most `2^(d−k)`, also when `k = d`.
Scaling the Kraft bound by `2^d` leaves room for at least one leaf outside
the union of these images.

The induction maintains a total assignment with length and prefix proofs
on the finite set of labels already assigned. Its empty case assigns
`[]` everywhere. At insertion, `Function.update` gives the chosen leaf
to the new label. An old word cannot prefix that leaf. If the new word
prefixes an old word, maximality forces equal lengths, hence equal words,
contradicting the same exclusion. This argument handles equal maximal
lengths, strict slack and depth zero. Taking the full finite set yields
the two pointwise obligations on the original alphabet.

The independent reviewer assessed both the free-leaf and labeled-assignment
criteria as satisfied and reported no findings. The five-target
warning-as-error build and development static gate passed. A compiled
comparison preserved all 880 incoming signatures. The realization theorem
is the sole addition, bringing the supported surface to 881 declarations
in 70 modules. The focused probes checked tied lengths, the label order
in the strict-slack case, singleton length zero and the empty alphabet.
The full clean qualification is scheduled for C35.04. C35.03 owns the permanent numerical and support
consumers. [Approved step](release-3-chunk-35.md#c3502--realize-admissible-lengths-on-their-original-labels) · [Textbook passages](../references.md#source-selection)

## C35.01 — Labeled binary prefix codes and Kraft necessity

Import `LeanInfoTheory.Shannon.PrefixCode` for `IsBinaryPrefixCode` and
`IsBinaryPrefixCode.kraft_sum_le_one`, both in `LeanInfoTheory.Shannon`.
For `c : S → List Bool`, a prefix relation between two assigned words
forces their labels to agree. Reflexivity of list prefix therefore makes
the assignment injective. For `[Fintype S]`, the real sum over labels of
`(1 / 2 : ℝ) ^ (c a).length` is at most one.

If every word is nonempty, a private lemma proves mathlib's
`InformationTheory.UniquelyDecodable` for `Finset.univ.image c`. Leading
words of two equal flattenings are comparable prefixes of the same list.
The labeled hypothesis identifies them, and left cancellation gives the
induction hypothesis for the tails. A nonempty first word rules out the
two cases where exactly one list of words is empty. The public proof
applies `InformationTheory.kraft_mcmillan_inequality` and uses
`Finset.sum_image` with label injectivity. Equal lengths at distinct
words thus contribute once per label.

If a label is assigned `[]`, it prefixes every assigned word. All labels
equal that label and the unique term is one. For an empty label type the
sum is zero. Stream decoding of an unknown number of empty words would lose
the symbol count. The result uses the known-count convention of the
[approved plan](release-3-chunk-35.md). The [focused consumer](../../LeanInfoTheory/Examples/PrefixCode.lean)
derives the property from an injective encoder with a prefix-free image,
applies the label sum bound and rejects the constant two-label encoder.

At intake, C34.04's 878 elaborated signature rows matched their recorded
export digest. All 210 recorded producer inputs, including the 69 compiled
owners, matched. The nine verified pins cover mathlib and its eight inherited packages.
C35.01 adds one predicate
and one theorem in a single focused owner. The lightweight root retains
92 exports and the reviewed simp set retains 94 declarations. The
source-matched intake and command records are under
`.lit-review/setup/c35-01-baseline-20261114/` and
`.lit-review/setup/c35-01-20261114/`.

The five-target warning-as-error build and development static gate passed.
The compiled audit compared all 878 incoming rows and identified exactly
the two new declarations. It also checked all 70 supported direct-import
sets, the root boundary, simp membership and the permitted axioms.
The bound reviewer independently compiled the focused and aggregate callers,
checked the exact sums for the empty alphabet and the singleton empty word,
and repeated the 878-row comparison. The reviewer assessed all three
C35.01 criteria as satisfied. Their one finding corrected the dependency
count above. The cumulative clean suite belongs to C35.04.
