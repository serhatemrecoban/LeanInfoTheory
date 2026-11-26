# Chunk 35 — Binary prefix codes and Kraft length realization

For a finite labeled alphabet, prescribed natural lengths can be realized by a binary prefix code exactly when their Kraft sum is at most one. C35 provides the two directions as separate theorems. The first applies to a given encoder. The second returns an encoder on the caller's label type, together with a length equation at each label. [Approved C35 plan](../plans/release-3-chunk-35.md) · [Step evidence](../plans/release-3-chunk-35-notes.md)

## Contracts for C36 and the C40 ledger

Import `LeanInfoTheory.Shannon.PrefixCode`. All three declarations are in `LeanInfoTheory.Shannon`. The owner directly imports `Mathlib.InformationTheory.Coding.KraftMcMillan` and `Mathlib.Data.Finset.Max`. The full Shannon umbrella exports it. The lightweight root keeps its two direct imports, five reachable modules and 92 exports. None of the three declarations carries a simp attribute. [Owner](../../LeanInfoTheory/Shannon/PrefixCode.lean) · [Shannon umbrella](../../LeanInfoTheory/Shannon.lean) · [Lightweight root](../../LeanInfoTheory.lean)

```lean
variable {S : Type u}

def IsBinaryPrefixCode (c : S → List Bool) : Prop :=
  ∀ ⦃a b : S⦄, List.IsPrefix (c a) (c b) → a = b

theorem IsBinaryPrefixCode.kraft_sum_le_one [Fintype S] {c : S → List Bool}
    (hc : IsBinaryPrefixCode c) :
    (∑ a : S, (1 / 2 : ℝ) ^ (c a).length) ≤ 1

theorem exists_isBinaryPrefixCode_of_kraft_sum_le_one [Fintype S] (ℓ : S → ℕ)
    (h : (∑ a : S, (1 / 2 : ℝ) ^ ℓ a) ≤ 1) :
    ∃ c : S → List Bool, IsBinaryPrefixCode c ∧ ∀ a, (c a).length = ℓ a
```

Reflexivity of list prefix makes the first condition imply encoder injectivity. An injective encoder whose distinct image words never prefix one another satisfies the condition. Only the sum theorems require a finite enumeration. Both allow an empty label type, repeated lengths, a singleton of length zero and strict slack in the real budget. The realization witness specifies the length of each word. Its bit pattern and the choice among available leaves are free. [Image equivalence and duplicate-label check](../../LeanInfoTheory/Examples/PrefixCode.lean#L30)

## Mathematical dependencies and adaptations

**Necessity.** For nonempty assigned words, form `T := Finset.univ.image c`. Two equal concatenations of words in `T` have comparable leading words, since both prefix the same concatenation. The label condition identifies them, and left cancellation reduces the equality to the tails. A nonempty first word rules out the asymmetric empty-list cases. This proves `InformationTheory.UniquelyDecodable (↑T : Set (List Bool))`. The pinned `InformationTheory.kraft_mcmillan_inequality` is a real inequality over a finite set of words for a finite nonempty **digit** alphabet. Taking that alphabet to be `Bool` gives denominator two. `Finset.sum_image` and encoder injectivity reindex the sum by source labels, counting distinct labels of equal length separately. If some label receives `[]`, list prefix forces every label to equal it and the sum is one. [Necessity proof](../../LeanInfoTheory/Shannon/PrefixCode.lean#L39) · [Pinned theorem](../../.lake/packages/mathlib/Mathlib/InformationTheory/Coding/KraftMcMillan.lean#L145) · [Pinned decoding predicate](../../.lake/packages/mathlib/Mathlib/InformationTheory/Coding/UniquelyDecodable.lean#L35)

**Realization.** Induct on a finite set of original labels, adding a label of maximal length `d` in the enlarged set. A previous word of length `k ≤ d` forbids precisely the depth-`d` leaves obtained by appending a Boolean suffix of length `d − k`. There are at most `2^(d−k)` such leaves. After multiplying the Kraft budget by `2^d`, the sum of all these bounds plus one is at most `2^d`. The union of forbidden leaves therefore omits an actual element of `List.Vector Bool d`. Updating the encoder at the new label preserves every earlier assignment. If the chosen word prefixed an old word, maximality would make their lengths equal and the old word would forbid the chosen leaf. Taking the finite set to be the whole domain gives the public result. The suffix image, counting arguments and choice of leaf stay private. [Suffix count](../../LeanInfoTheory/Shannon/PrefixCode.lean#L89) · [Budget and leaf choice](../../LeanInfoTheory/Shannon/PrefixCode.lean#L112) · [Assignment](../../LeanInfoTheory/Shannon/PrefixCode.lean#L146)

CT91 §5.1, printed pp. 79–81 (PDF 101–103), gives the symbol and stream conventions and encoder (5.3). Section 5.2, Theorem 5.2.1, pp. 82–83 (PDF 104–105), gives both finite Kraft directions and the fixed-depth descendant count. Section 5.5, Theorem 5.5.1, pp. 90–92 (PDF 112–114), gives the uniquely decodable inequality. PW24 §10.1, pp. 197–198 (PDF 222–223), treats single-shot losslessness on support. Section 10.3, Definitions 10.6–10.8 and Remark 10.3(3), pp. 206–207 (PDF 231–232), treats streams of unspecified length and rules out empty codewords there. Theorem 10.9, pp. 207–208 (PDF 232–233), gives Kraft necessity and label-indexed realization for positive lengths. Its interval construction can place the next interval directly at the preceding endpoint. The Lean tree construction handles adjacent leaves, ties and depth zero without choosing binary expansions. [Registered editions and adaptations](../references.md#source-selection)

## Permanent consumers and cumulative criteria

The development consumer imports just the focused owner and `LeanInfoTheory.Probability.Finite`. It is included in `LeanInfoTheory.Examples`. The following locations identify evidence for the twelve criteria in the approved plan. The final three depend on the C35.04 assessment and its final-source record. [Consumer imports](../../LeanInfoTheory/Examples/PrefixCode.lean#L12) · [Development aggregate](../../LeanInfoTheory/Examples.lean)

| Criterion | Evidence or closeout obligation |
|---|---|
| C35.01-CODE | [Predicate](../../LeanInfoTheory/Shannon/PrefixCode.lean#L36), [equivalence with injectivity and a prefix-free image](../../LeanInfoTheory/Examples/PrefixCode.lean#L30), and [rejection of duplicate words](../../LeanInfoTheory/Examples/PrefixCode.lean#L48). |
| C35.01-BRIDGE | [First-word comparison and cancellation](../../LeanInfoTheory/Shannon/PrefixCode.lean#L39) prove unique decodability for the nonempty-word image. |
| C35.01-KRAFT | [Labeled real sum](../../LeanInfoTheory/Shannon/PrefixCode.lean#L74), including the direct singleton calculation and the image-to-label reindexing. |
| C35.02-SPACE | [Forbidden leaves as a suffix image](../../LeanInfoTheory/Shannon/PrefixCode.lean#L89), [scaled integer budget](../../LeanInfoTheory/Shannon/PrefixCode.lean#L112) and [choice outside the union](../../LeanInfoTheory/Shannon/PrefixCode.lean#L127). |
| C35.02-ASSIGN | [Maximum-length induction](../../LeanInfoTheory/Shannon/PrefixCode.lean#L146) constructs a single encoder and proves each original label's length. |
| C35.03-FEASIBLE | [Explicit words](../../LeanInfoTheory/Examples/PrefixCode.lean#L81) give `(0,10,11)` and sum one. A [separate realization call](../../LeanInfoTheory/Examples/PrefixCode.lean#L88) checks all three lengths `(1,2,2)` and feeds its encoder to necessity. The [unsorted assignment](../../LeanInfoTheory/Examples/PrefixCode.lean#L99) realizes `(3,1,2)` at the named labels with sum `7/8`. |
| C35.03-IMPOSSIBLE | [Three length-one words](../../LeanInfoTheory/Examples/PrefixCode.lean#L110) would force `3/2 ≤ 1` for every proposed prefix encoder. |
| C35.03-EMPTY | [Empty alphabet](../../LeanInfoTheory/Examples/PrefixCode.lean#L120) has sum zero. The [singleton cases](../../LeanInfoTheory/Examples/PrefixCode.lean#L125) give one tuple at any fixed count, encoder word `[]`, sum one, and unequal lists `[[]]` and `[[], []]` with equal flattenings. |
| C35.03-SUPPORT | [Boolean point mass](../../LeanInfoTheory/Examples/PrefixCode.lean#L140) realizes length zero at its only supported label, `false`, and verifies that `true` lies outside the domain. |
| C35.04-VALIDATE | Compare all 878 incoming signatures, account for the three additions and check aggregates, architecture, attributes, axioms, generated and frozen artifacts, both released baselines, documentation and applicable clean gates. Use the cumulative command and source records below for results. |
| C35.04-HANDOFF | This file supplies the public interfaces, consumer and source anchors, qualification references and C36 boundary for the living summary, log, release map and step notes. |
| C35.04-REVIEW | The bound reviewer's cumulative original report, parent reconciliation, final validation and completion record supply the independent assessment against all twelve criteria. |

## Validation and review identities

The qualified C34 input was the 878-name export in `.lit-review/setup/c34-04-20261114/named/run-20261114T151428Z/current.stdout`, SHA-256 `0c364e39264b9d00599153acdd664a72aa65ae7cf9313b0573979a47c349333d`. C35.01 checked the associated 210 source inputs, including the 69 compiled owners. The source-match receipt is `.lit-review/setup/c35-01-baseline-20261114/result.json`. The three additions bring the supported inventory to 881 declarations in 70 modules, with 94 reviewed simp names. [Incoming C34 evidence](chunk-34.md#qualification-identities) · [C35 step checks](../plans/release-3-chunk-35-notes.md)

| Step | Final source manifest | Independent step closure |
|---|---|---|
| C35.01 | `73a232c753629b3198b821de4b1d4764a9d137da407001340665aa61db720a7c` | `0cda90a2503041178ab5406477f6d1ecd7bdd19417ce934267b24fb591cda2cb` |
| C35.02 | `a464a9a94d22c67c1d92cb6abd7cb9a7c5bd99020db1b74b0d197eb17dcbf979` | `a4ae8784f3e3724192661b011b4d505b7a681db3107c96be453ec8c351db0ac6` |
| C35.03 | `5d17644c13f08643982cc54706b8c5c24c98ae218d22d158108a2026c095028e` | `a1242b69a77059689247c24130157fb63805abcf5558b91bb7e2f70c832adead` |

The three prior reports assessed all nine mathematical and consumer criteria as satisfied. C35.01 corrected finding `lit-finding:c35-01-notes-pin-count` in the notes: nine verified pins comprise mathlib and its eight inherited packages. C35.02 and C35.03 reported no findings. Their respective `original-report.json` and `completion.json` files under `.lit-review/setup/c35-01-20261114/`, `c35-02-20261114/` and `c35-03-20261114/` identify each assessment and its final-source validation. The plan review of revision 1 has its own record in `.lit-review/setup/c35-plan-review-r1-20261114/`. Revision 2 is the approved implementation plan.

The private C35.04 directory is `.lit-review/setup/c35-04-20261114/`. Consult its command receipts for the primary gates and `.lit-review/setup/c35-04-audit-20261114/` for the fresh named comparison. Attribute a complete clean-suite result only to the clean candidate and commit identified by its receipt, including final-source applicability after any amendment. The separate cumulative `original-report.json` and `completion.json` records identify the actual assessment, dispositions, final validation and closure once issued. [Cumulative obligations](../plans/release-3-chunk-35.md#c3504--cumulative-validation-independent-review-and-c36-handoff)

## Handoff to C36

For a PMF `p` on a finite ambient alphabet, take the label type to be `↥p.supportFinset`. Membership is equivalent to `p a ≠ 0`, hence to positive mass. Both Kraft theorems apply to this subtype. The sum ranges only over supported symbols, so no leaves are reserved for unused ambient symbols. The point-mass caller demonstrates the distinction on a two-symbol ambient alphabet. A known count `n` on a singleton determines the unique source tuple even for `n = 0`. The same empty bit string can represent one or two singleton symbols if the count is unknown. [Support membership](../../LeanInfoTheory/Probability/Finite.lean#L86) · [Known-count and support examples](../../LeanInfoTheory/Examples/PrefixCode.lean#L125)

C36 can apply necessity to every candidate code and use realization to turn admissible Shannon lengths into a witness with a pointwise length equation. Expected lengths are measured in binary digits, while the library's entropy is in nats. `LeanInfoTheory.Shannon.natsToBits (entropy p)` divides by `Real.log 2`. C36 owns minimum attainment on positive support, the lower bound for every prefix code, a witness strictly below entropy in bits plus one, and the per-symbol version for positive iid blocklength. The upper witness and the minimizing code may differ. C35 establishes feasibility and supplies the two inputs to those proofs. [Units](../../LeanInfoTheory/Shannon/Units.lean#L46) · [Release-map C36 contract](../plans/release-3-chunk-map.md#c36-expected-length-and-the-variable-length-source-coding-theorem)
