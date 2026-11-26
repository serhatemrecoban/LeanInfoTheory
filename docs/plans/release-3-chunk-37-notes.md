# C37 implementation notes

## C37.01 — Counts at every length

`symbolCount x a` is the cardinality of the positions at which `x i = a`.
It needs no finite enumeration of the alphabet. For finite `A`,
`sum_symbolCount` partitions the positions by their image under `x`.
`wordTypes A n` uses `Finset.univ.piAntidiag n`, so membership requires
exactly a natural-valued function of total `n`. In particular,
`wordTypes A 0 = {0}` also holds for an empty alphabet.
[Count owner](../../LeanInfoTheory/Shannon/WordType.lean) · [CT91 register](../references.md#source-selection)

A caller with `hc : (∑ a, c a) = n` constructs the index
`⟨c, (mem_wordTypes c).2 hc⟩`. The underlying function of `wordType x` is
definitionally `symbolCount x`. The focused owner is exported by the full
Shannon umbrella and has no project dependencies. Realizing an arbitrary
index by a word is C37.02.

Before growth, the primary checkout matched the C36 compiled export of
888 named declarations (SHA-256 `ac164a66e1acdf3ad050d5a5c420d11c3c4c6a08caa538bc8b4939e2eab944bc`).
The comparison matched 146 source/configuration inputs, 72 supported compiled
owners, two compiled development examples and nine dependency pins. C36's
supervised closure and its outstanding clean-checkpoint qualification apply
to the recorded C36 candidate. The C37.01 step records distinguish the new
focused, static and compiled comparisons from that incoming evidence.
[C36 qualification](../handoffs/chunk-36.md#qualification-and-review-identities) · [Approved criteria](release-3-chunk-37.md#c3701--counts-at-every-length)

## C37.02 — Realization and partition

For a supplied index `t`, the labeled slots `Σ a : A, Fin (t.val a)` have
cardinality `n`. An equivalence from `Fin n` to the slots gives a word by
reading the first projection. For each `a`, the positions reading `a` are
equivalent to `Fin (t.val a)`, so their count is exactly the supplied
entry. Zero entries contribute no slots. The construction works on the
empty alphabet at length zero without choosing a default label.

`typeClass t` is the finite fiber of `wordType`. Surjectivity supplies a
member of any given class. A word shared by two classes has both indices
as its own type, so those indices agree. In particular, if two class finsets
are equal, any member of the first witnesses equality of their indices.
C38 can count this finset and C39 can use its coercion to a set as an event.
[Class interface](../../LeanInfoTheory/Shannon/WordType.lean) · [Approved criteria](release-3-chunk-37.md#c3702--realization-and-partition)

## C37.03 — Position permutations and number of classes

In `x ∘ e`, new position `i` reads old position `e i`. For each fixed
label `a`, the map `i ↦ e i` gives an equivalence between the positions
carrying `a` in the two words. Their counts therefore agree on any alphabet.
For finite alphabets, extensionality gives `wordType_comp_perm`. Rewriting
both sides of a class-membership iff with `mem_typeClass` then gives
`x ∘ e ∈ typeClass t ↔ x ∈ typeClass t` for any supplied index `t`.

For `t ∈ wordTypes A n`, each labeled entry is at most `n` because it is
a term of a natural sum equal to `n`. Encoding each entry in `Fin (n + 1)`
gives an injection into `A → Fin (n + 1)`. Reading the natural values of
these coordinates recovers the index. The target has `(n + 1) ^ Fintype.card A`
elements. C37.02 supplies a word in each indexed class and shows that
different indices have different class finsets, so the bound counts distinct
classes. At length zero there is one type. Over an empty alphabet the bound
is one at every length, and at positive length there are zero types.
[Count and type theorems](../../LeanInfoTheory/Shannon/WordType.lean) · [CT91 source](../references.md#source-selection)

## C37.04 — The positive-length empirical PMF

`empiricalPMF hn t` normalizes the labeled count vector of `t` on its
original alphabet. The private total calculation casts the sum of natural
counts into `ENNReal`, giving `n`. The proof `hn : 0 < n` establishes
that this sum is nonzero, and its natural-number cast is finite.
`PMF.normalize_apply` then gives the atom `t.val a / n`.

Mathlib's support theorem for normalization reduces empirical support to
nonzero count. Casting the natural entry preserves its zero test, giving
`mem_support_empiricalPMF_iff`. The existing `PMF.mem_supportFinset`
translates this to finite support. The same formulas at `wordType x`
read `symbolCount x a`, and `wordType_comp_perm` gives invariance of
the law under reordering positions. These are caller derivations from
the three public declarations. The construction takes the positive-length
proof explicitly.
[Empirical owner](../../LeanInfoTheory/Shannon/EmpiricalPMF.lean) · [Approved criteria](release-3-chunk-37.md#c3704--the-positive-length-empirical-pmf)

## C37.05 — Exact denominator and round trips

`wordTypeEquivPMF hn` identifies an admissible count index with a PMF
carrying an existential natural count witness of total `n`. The forward
law is `empiricalPMF hn t`, as recorded by `wordTypeEquivPMF_apply`.
The denominator is prescribed; it need not be the least denominator of
the masses.

A private injectivity proof evaluates equal laws at each label and
multiplies by `(n : ENNReal)`. `ENNReal.div_mul_cancel` applies because
the supplied length is positive and its natural cast is finite. Injectivity
of the natural cast recovers the count at that very label, including zero
coordinates. A witnessed PMF is in the image by taking its supplied count
function and using PMF extensionality on the atom formulas.

The implementation packages these proofs with mathlib's `Equiv.ofBijective`.
This simplifies the advisory route in the plan: its existing inverse laws
replace hand-written choice-dependent inverse proofs. `symm_apply_apply`
recovers any supplied index; `apply_symm_apply` recovers an independently
supplied witnessed law. Equality of the forward images also proves that
different admissible witnesses for the same law have identical labeled
counts. The existential proof is not additional type data.

`mem_typeClass_iff_empiricalPMF_eq` uses the same private injectivity result
and `mem_typeClass`. It recognizes membership in the existing finset by
equality of empirical laws. No second PMF-indexed class or event is defined.
The original focused imports and the positive-length boundary are retained.
[Conversion contracts](release-3-chunk-37.md#c3705--exact-denominator-and-round-trips) · [Empirical owner](../../LeanInfoTheory/Shannon/EmpiricalPMF.lean)

## C37.06 — Permanent consumers

`Examples.WordType` imports only the focused empirical owner and the released
iid owner. Its fixtures and helper proofs are private. The binary word `001`
has counts `(2,1)` and empirical masses `(2/3,1/3)`; inverse conversion recovers
those labeled counts. The cycle reading old positions `1,2,0` gives `010`,
while its inverse gives `100`. The class and law are invariant. The word
`011` has the same support but belongs to a different class. Enumerating the
four count pairs at length three and applying `card_wordTypes_le` gives
`4 ≤ 4² = 16`; this is a bound on types, not words within one class.

On `Fin 3`, the word `0101` has counts `(2,2,0)`. An independently constructed
law has masses `(1/2,1/2,0)` and a denominator-four witness; its inverse
recovers all three entries. Its actual support is exactly `{0,1}`, and a
word containing `2` cannot belong to the class. The fair Boolean law cannot
be empirical at length three: equality at `false` would force a natural
count `k` to satisfy `2 * k = 3`. Thus a prescribed denominator need not be
least, but must be possible.

Generic boundary proofs cover zero counts and the singleton empty-word
class on every finite alphabet, including `Empty`. There are no positive-
length types on `Empty`. On `Unit`, the only count equals the length. These
proofs do not construct an empirical PMF at length zero.

The private `mem_typeClass_iff_counts` derives both directions of labeled
count membership using the public interface. The private `sum_typeClasses`
uses `Finset.sum_fiberwise` to partition an arbitrary `AddCommMonoid`-valued
word weight over all classes at every length. The permanent shared caller
and an independent focused compilation use `(typeClass t).card` and
`(PMF.iid p n).toOuterMeasure (typeClass t)` on the same finset, together with
the positive-length empirical membership iff.

No supported declarations, assumptions or imports change in this step. The
supported inventory remains 908 names in 74 modules, with 94 reviewed simp
declarations and 92 lightweight-root exports. Step-scoped builds, caller and
compiled comparisons are recorded separately from clean-checkpoint evidence.
C36's complete clean-checkpoint suite and hygiene gate remain outstanding;
its mathematics is not reopened. C37.07 owns cumulative qualification and
the maintained C38 handoff. Exact class sizes and entropy estimates remain
C38 work; iid type probabilities and KL bounds remain C39 work.
[Permanent consumers](../../LeanInfoTheory/Examples/WordType.lean) · [Approved criteria](release-3-chunk-37.md#c3706--permanent-consumers)

## C37.07 — Cumulative qualification and C38 handoff

The cumulative pass preserves the twenty public declarations and the six-step
proof route. Counts remain primary, `typeClass` remains the only class, and
positive length remains explicit on every empirical-law contract. The maintained
handoff lists all signatures, both focused imports, exact downstream membership,
weighted partition, support, round trips and boundary consumers. It records the
direct sum-based count bound and use of `Equiv.ofBijective` as justified proof-route
adaptations without changing the approved mathematical meaning.

Fresh primary focused/generated/static, 601/811 retained compatibility, full
trust/import/axiom and release-documentation checks passed. The cumulative compiled
audit compares the original 888-name C36 export to the current 908 names, while a
separate public-only caller checks arbitrary indices and independently witnessed
laws. All producer/configuration/dependency identities and actual command receipts
are retained in the cumulative validation index and private originals. The handoff
and canonical summary now distinguish the current 908/74 surface from the C36
888/72 historical surface, and Section 16 no longer calls C29 current.

The final review freshly assesses all seventeen approved criteria. Its original,
the parent reconciliation, final-source validation and actual supported closure
remain under `.lit-review/setup/c37-07-20261117/`; readiness text does not establish
closure. Final capture follows all required document edits. No Lean/API/pin change,
commit, clean snapshot, C38 implementation or publication is made in this step.
C37's complete clean-checkpoint suite and hygiene are outstanding. C36's separate
qualification remains outstanding without reopening its mathematics. Exact class
sizes and entropy bounds belong to C38; general iid type probabilities and KL
bounds belong to C39. The latter consume the same finite class.
[Maintained handoff](../handoffs/chunk-37.md) · [Final criteria](release-3-chunk-37.md#c3707--cumulative-qualification-review-and-c38-handoff)
