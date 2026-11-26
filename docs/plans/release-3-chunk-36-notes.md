# C36 implementation notes

## C36.06 — Cumulative qualification and C37 handoff

The review candidate comprises the six scalar declarations, the iid theorem
and the permanent examples. The scalar owner encodes only positive-mass
symbols. Its leastness theorem gives a minimizing encoder and compares its
mean with every prefix encoder on the same support. The Shannon theorem
supplies a separate encoder with both its pointwise length equation and its
strict upper bound. The iid result applies leastness to the whole block law,
so the minimizing encoder may depend on the block length. The C40 ledger
links these contracts to their owners, calling examples and source adaptations.
[C40 endpoint ledger](../handoffs/chunk-36.md#c40-endpoint-ledger)

The cumulative comparison begins with the 881 named C35 declarations and
accounts for all seven additions. The source and command receipts distinguish
the focused builds, caller, generated artifacts, compatibility, trust and
documentation checks in the dirty primary checkout from the complete
development suite, which requires a clean checkpoint. The clean-suite check
is outstanding. The private `.lit-review/setup/c36-06-20261117/` records
identify the original assessment, reconciliation and closure once issued.
[Qualification and review identities](../handoffs/chunk-36.md#qualification-and-review-identities)

C37 begins independently with counts of symbols in finite words. Its
empirical-law normalization requires a positive length even though the empty
word has well-defined counts. [Handoff to C37](../handoffs/chunk-36.md#handoff-to-c37)

## C36.05 — Permanent examples

The examples import `LeanInfoTheory.Shannon.PrefixCodeLengthIid` and
exercise both its block theorem and the scalar theorems it exposes.

| Law | Supported code and expected length |
| --- | --- |
| Four labels with masses `(1/2, 1/4, 1/4, 0)` | The words `0, 10, 11` use the full Kraft budget and average `3/2` bits. Entropy in bits and the optimum both equal `3/2`. Any extra finite word for the fourth label would exceed the budget. |
| Biased Boolean, `P(true) = 3/4` | The Shannon witness has lengths `(1, 2)` and mean `5/4`. The single-bit encoder attains `1`. Each supported label needs a nonempty word because the other label is also supported. |
| Boolean point mass at `false` | Only `false` needs a word. With known symbol count, the empty word gives mean, entropy in bits and optimum all zero. |
| Two iid biased Booleans | In order `TT, TF, FT, FF`, the masses are `(9, 3, 3, 1)/16`. Joint words `0, 10, 110, 111` average `27/16` bits per pair. Concatenating the one-symbol optimizer costs two. |

The joint encoder gives an upper bound of `27/32` bits per symbol on
the attained block optimum. This is strictly below the one-symbol
optimum of one bit. The iid theorem also places this per-symbol optimum
between the entropy in bits and the strict upper endpoint of that
entropy plus `1/2`. A generic caller obtains an attaining block encoder
and both bounds from the focused import. The dyadic and point-mass
examples attain the entropy bound itself. [Permanent Lean examples](../../LeanInfoTheory/Examples/PrefixCodeLength.lean)

The supported inventory entering the step has 888 declarations. Its
compiled export and 223 producer inputs are identified in the step's
private `baseline.json`. The focused build, separate caller, static and
generated checks, independent report and closure are recorded under
`.lit-review/setup/c36-05-20261117/`.

## C36.04 — Per-symbol bounds for iid blocks

Import `LeanInfoTheory.Shannon.PrefixCodeLengthIid`. In the Shannon
namespace, `optimalPrefixLength_iid_div_bounds p n hn` takes a finite
PMF and a proof `hn : 0 < n`. Its two projections bound the same quantity,
`optimalPrefixLength (PMF.iid p n) / (n : ℝ)`. The lower endpoint is
`natsToBits (entropy p)`. The upper endpoint adds `1 / (n : ℝ)`
and is strict. [Iid theorem](../../LeanInfoTheory/Shannon/PrefixCodeLengthIid.lean)

The encoder takes one entire block in `↥(PMF.iid p n).supportFinset`.
Such a word has `n` coordinates and every coordinate lies in the
support of `p`. Apply `isLeast_optimalPrefixLength (PMF.iid p n)` to
obtain an encoder attaining the block cost. The proof applies the scalar
bounds to that law and rewrites its entropy as `(n : ℝ) * entropy p`.
Conversion to bits divides by `Real.log 2` and commutes with the factor
`n`. Division by positive `n` preserves both inequalities and changes
the additive overhead from one bit per block to `1/n` bits per symbol.
At `n = 1` the overhead is one bit. The iid entropy identity also holds
at zero, while a per-symbol mean requires a positive block length.
[Scalar bounds](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean) ·
[Iid entropy](../../LeanInfoTheory/Shannon/SemanticBridge/FiniteProduct.lean) ·
[CT91 §5.4, (5.35)–(5.37)](../references.md#source-selection)

The focused caller checks an arbitrary positive length, length one,
and the support domain of an attaining block encoder. A Boolean point
mass exercises excluded block words. The build and compiled import
checks cover the new owner, its two direct imports, the full Shannon
umbrella and the lightweight root. The named comparison starts from
the 887 declarations in the C36.03 export. Its scoped audit index,
independent report and final completion record are under
`.lit-review/setup/c36-04-20261116/`.

## C36.03 — An attained scalar optimum

Import `LeanInfoTheory.Shannon.PrefixCodeLength` and open
`LeanInfoTheory.Shannon`. The real number `optimalPrefixLength p`
is the infimum of the expected lengths of all binary prefix encoders on
`↥p.supportFinset`. The following projections of its leastness theorem
give an attaining encoder and compare it with any competitor.

```lean
  have least := isLeast_optimalPrefixLength p
  obtain ⟨c, hc, hcost⟩ := least.1
  have hcompare : optimalPrefixLength p ≤ expectedCodewordLength p d :=
    least.2 ⟨d, hd, rfl⟩
```

Here `hd : IsBinaryPrefixCode d`, `hc : IsBinaryPrefixCode c`, and
`hcost : expectedCodewordLength p c = optimalPrefixLength p`.
The caller can use any competitor `d`, including one whose cost exceeds
the Shannon code's mean. Several encoders can attain the same value.
[Scalar API](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean)

Take the mean `B` of the Shannon encoder from C36.02. If a competitor
costs at most `B`, the contribution `m * k` of a supported label of
mass `m` and word length `k` is at most the entire mean. Since
`m > 0`, the label needs only the lengths from zero to `⌊B / m⌋`.
The product of these finite ranges contains the incumbent's profile.
Filter by the C35 Kraft inequality, minimize the weighted length on
this nonempty finite family, and use C35 realization for the winning
profile. Every competitor costing at most `B` is represented in the
search. A more expensive competitor costs more than the incumbent,
whose profile was available to the minimum. This proves global leastness
and identifies the attained cost with the infimum. If `B = 0`, each
range still contains zero. [Labeled Kraft theorems](../../LeanInfoTheory/Shannon/PrefixCode.lean)

`optimalPrefixLength_bounds p` gives both
`natsToBits (entropy p) ≤ optimalPrefixLength p` and
`optimalPrefixLength p < natsToBits (entropy p) + 1`.
The lower bound applies the universal converse to an attaining encoder.
For the upper bound, leastness compares with the independently obtained
Shannon encoder and C36.02 supplies its strict inequality.
PW24 §10.3 (10.12) formulates the integer-length minimum. CT91 §5.4,
Theorem 5.4.1, compares the minimizing and rounded costs and gives the
strict upper bound. [Registered editions](../references.md#source-selection)

C36.03 was selected after the C36.02 closure matched the checkout.
The pre-growth comparison qualified 884 compiled declaration records
against 220 producer inputs and nine dependency pins. The focused
caller checks attainment and the comparison with an arbitrary encoder.
It also checks a Boolean point mass against a competitor using a
three-bit word. The focused build covers the scalar owner, full Shannon
umbrella, lightweight root and C35 examples. The compiled audit covers
the retained types, the three scalar additions, imports, root exports,
reviewed simp attributes and the supported declarations' axioms.
The audit index is `.lit-review/setup/c36-03-20261116/scoped-audit.json`.
The independent report and final closure are recorded in the same directory.

## C36.02 — A prefix code with Shannon lengths

With `LeanInfoTheory.Shannon.PrefixCodeLength` imported, use
`obtain ⟨c, hc, hlen, hmean⟩ := exists_isBinaryPrefixCode_length_eq_ceil p`
in the Shannon namespace. The encoder `c` takes a label in
`↥p.supportFinset`. The proof `hc` gives its prefix condition, `hlen a`
gives its word length at label `a`, and `hmean` bounds the mean of that
same `c` strictly by `natsToBits (entropy p) + 1`. A point mass gives
length zero for its one possible label, even on a larger alphabet.
[Scalar owner](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean)

For a supported atom of mass `m`, its binary information
`x = −log₂ m` is nonnegative since `0 < m ≤ 1`. The natural
ceiling lies in `[x, x + 1)`. Its Kraft weight is at most `m`,
so the sum of the weights is at most one. C35 realizes these lengths
on the original labels. Multiplying the strict rounding inequality by
each positive mass and summing on the nonempty support preserves
strictness. The support masses sum to one and their weighted information
sums to the entropy in bits. This gives the feasible encoder used by
the later minimum-attainment proof.
[C35 realization](../../LeanInfoTheory/Shannon/PrefixCode.lean) ·
[Entropy conversion](../../LeanInfoTheory/Shannon/Units.lean)

CT91 §5.4, (5.29)–(5.32), gives the strict bound for the rounded
assignment before Theorem 5.4.1 compares with the optimum. PW24 §10.3,
Theorems 10.9–10.10, gives the same assignment and states the optimal
upper bound weakly in (10.13). [Registered editions](../references.md#source-selection)

C36.02 was selected after the C36.01 review closed and its final source
matched the checkout. Before adding the witness, all 220 producer inputs
to the C36.01 export and all nine dependency pins matched. The export
contains 883 named signatures. Its SHA-256 is
`116ca1f411f0d4c790112463fb3ecf3048963531062d427a94b220194f684f86`.

The focused caller extracts one witness and uses its length equation,
Kraft bound, C36.01 lower bound and strict upper bound together. On
`PMF.pure false : PMF Bool` it derives the actual empty word and zero
mean while excluding the unused label. The warning-as-error build covers
the scalar owner, Shannon umbrella, lightweight root and C35 examples.
The compiled comparison covers the incoming signatures, the one new
theorem, direct imports, reviewed simp attributes, axioms of the supported
declarations and root exports. The scoped audit is indexed by
`.lit-review/setup/c36-02-20261116/scoped-audit.json`. The final checks,
independent report and closure are recorded in the same directory.

## C36.01 — Supported mean and converse

Import `LeanInfoTheory.Shannon.PrefixCodeLength` and open
`LeanInfoTheory.Shannon`. Given a finite PMF `p` and an assignment
`c : ↥p.supportFinset → List Bool`, `expectedCodewordLength p c` is the
real sum of mass times binary word length. For `hc : IsBinaryPrefixCode c`,
`natsToBits_entropy_le_expectedCodewordLength p hc` proves
`natsToBits (entropy p) ≤ expectedCodewordLength p c`. An ambient
zero-mass label needs no assigned word. The singleton support can use
the empty word when the symbol count is known.
[Scalar owner](../../LeanInfoTheory/Shannon/PrefixCodeLength.lean)

For an atom of real mass `m > 0` assigned length `k`, put
`w = (1/2)^k`. The log inequality gives `m log(w/m) ≤ w − m`.
On summing, the left side is the entropy in nats minus the mean length
times `log 2`. The support masses sum to one, and C35 bounds the Kraft
sum by one. Dividing by positive `log 2` gives the converse in bits.
The private support-sum identity applies to any real function of the
atom mass that vanishes at zero. It covers both the mass sum and the
entropy sum. The proof uses `Finset.sum_coe_sort` to move from the subtype
to the support finset, then `Finset.sum_subset` to add the zero terms.
This keeps the finite enumeration identical to the one in the definition
of the mean. The two direct imports are the C35 prefix-code owner and
the units owner. [C35 necessity](../../LeanInfoTheory/Shannon/PrefixCode.lean)
· [Units](../../LeanInfoTheory/Shannon/Units.lean)

CT91 §5.3, Theorem 5.3.1 and (5.21)–(5.26), proves the arbitrary-code
converse using normalized Kraft weights. PW24 §10.3, Theorem 10.10 and
(10.13), gives the consequence for an optimizer. The scalar proof here
allows strict Kraft slack without constructing an auxiliary law.
[Registered editions](../references.md#source-selection)

The C35.04 export of 881 named signatures has SHA-256
`10f262ace43aef4e7b46c1933dc67c2a73e3271560eab094f38bec3489a2c229`.
Before growth, 220 producer inputs matched, including the 70 compiled
owners, and all nine dependency pins matched. The source-match receipt
is `.lit-review/setup/c36-01-audit-20261116/baseline.json`.

The focused warning-as-error build and development static gate passed.
A caller importing only the new owner checked the defining equation,
the converse with its exact assumptions, and the mean of a two-bit word
on the one supported label of a Boolean point mass. All 881 incoming
signatures matched. The two additions bring the public surface to 883
declarations in 71 supported modules. The audit checked direct imports,
the 94 reviewed simp declarations, the supported declarations' axioms
and the 92 lightweight-root exports. Its receipt is
`.lit-review/setup/c36-01-audit-20261116/run-20261116T104819469608Z/result.json`.
The independent review and final checks are recorded under
`.lit-review/setup/c36-01-20261116/`. The private completion record
identifies the final source and assessment when issued.
