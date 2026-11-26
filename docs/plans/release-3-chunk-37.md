# C37 — Symbol counts, empirical laws and type classes

<!-- lit-review-status:start -->
**Plan status:** Approved revision 2. The lead selected C37.01 with review on 17 November 2026. The presented revision has SHA-256 `6f8fd3791d623eb116c87c9d9b5375cf21853f07c29192cf7c7ec1853a37e7fd`. The bound reviewer assessed all 17 criteria of revision 1 as satisfied. Revision 2 incorporates suggestions from that review, the lead's supplied General Assistant review and the parent's consumer checks. Later steps await separate selection.
<!-- lit-review-status:end -->

## Endpoint and representation

A word is the existing function `x : Fin n → A`. Index its type class by a vector `c : A → ℕ` whose entries sum to `n`. Counts work at length zero, give C38 natural arguments for the multinomial coefficient, and retain the labels of unused symbols. At positive length they determine a unique empirical PMF. Conversely, a PMF whose masses have a common denominator `n` determines a unique count vector. “Denominator” means the masses are exact multiples of `1/n`; it need not be their *least* common denominator.

Use one finite enumeration, `wordTypes A n`, and its existing finset subtype as the index. Use one class, `typeClass t : Finset (Fin n → A)`. C38 can take `(typeClass t).card`; C39 can pass that very finset to `(PMF.iid p n).toOuterMeasure (typeClass t)` by the usual coercion to a set. Membership by empirical-law equality is a theorem about this finset. The number of indices `(wordTypes A n).card` is a different quantity from the number of words in a fiber.

The [C37–C39 roadmap](release-3-chunk-map.md#c37-empirical-laws-and-type-classes) supplies the endpoints. CT91 §12.1, printed pp. 279–281 (PDF 301–303), defines relative frequencies, the class in (12.2), and the bound on the number of types in Theorem 12.1.1, (12.6). The registered 1991 file matched SHA-256 `16f016eafbb1160c2d8e6c29ff28db870e0eb2e61c15ea39bea5b06d463a952f`. Realization, unique membership and position invariance make the textbook's indexing usable in Lean. The length-zero count interface is a project extension. The binary and sparse fixtures below are project examples. Theorem 12.1.3 and (12.17) concern the size of one class (C38); Theorems 12.1.2 and 12.1.4 concern iid mass (C38's own-law specialization and C39's general result). None of those estimates is a C37 obligation. [Reference register](../references.md#ct91-cover-and-thomas)

## Proposed public contracts

The signatures below are proposed, not existing declarations. All are in `LeanInfoTheory.Shannon`. Write `T` below for `↥(wordTypes A n)` **only as a local abbreviation in this plan**; its elements have an ordinary natural-valued function `t.val`. No new word wrapper, count-vector structure, `Fintype` instance, alphabet order, public `DecidableEq A`, or new simp attribute is required. The displayed equations are contracts even where a proof can be definitional.

| Counts and classes | Signature or defining equation |
| --- | --- |
| `symbolCount` | `(x : Fin n → A) → A → ℕ`; at `a`, the cardinality of the positions satisfying `x i = a`. No finiteness assumption on `A` for this operation. |
| `symbolCount_zero` | For `x : Fin 0 → A` and every `a`, `symbolCount x a = 0`. |
| `sum_symbolCount` | With `[Fintype A]`, `∑ a, symbolCount x a = n` (the sum runs over the full alphabet). |
| `wordTypes`, `mem_wordTypes`, `wordTypes_zero` | `wordTypes (A : Type u) [Fintype A] (n : ℕ) : Finset (A → ℕ)`; `c ∈ wordTypes A n ↔ (∑ a, c a) = n`; `wordTypes A 0 = {0}`. |
| `wordType` | `(x : Fin n → A) → T`, with `(wordType x).val = symbolCount x`. The remaining index and class contracts assume `[Fintype A]`. |
| `wordType_surjective` | `Function.Surjective (wordType : (Fin n → A) → T)`. The supplied index precedes the existential word. |
| `typeClass`, `mem_typeClass` | `typeClass (t : T) : Finset (Fin n → A)`; `x ∈ typeClass t ↔ wordType x = t`. |
| `existsUnique_mem_typeClass` | For every word `x`, `∃! t : T, x ∈ typeClass t`. Together with surjectivity, the fibers are all nonempty, pairwise disjoint, and cover the words. |
| `symbolCount_comp_perm`, `wordType_comp_perm` | For `e : Equiv.Perm (Fin n)`, `symbolCount (x ∘ e) a = symbolCount x a` (arbitrary `A`) and `wordType (x ∘ e) = wordType x` (finite alphabet). Position `i` of the new word reads old position `e i`. |
| `card_wordTypes_le` | `(wordTypes A n).card ≤ (n + 1) ^ Fintype.card A`, all lengths. Realization and unique membership identify the indices with the distinct classes. |

The empirical owner adds the following contracts, with `hn : 0 < n` an explicit argument. The law of a word is `empiricalPMF hn (wordType x)`. This convention also lets C38 use the law of an arbitrary supplied index without choosing a representative word.

| Empirical laws | Signature or defining equation |
| --- | --- |
| `empiricalPMF`, `empiricalPMF_apply` | `empiricalPMF (hn : 0 < n) (t : T) : PMF A`; for each `a`, `empiricalPMF hn t a = (t.val a : ℝ≥0∞) / (n : ℝ≥0∞)`. |
| `mem_support_empiricalPMF_iff` | `a ∈ (empiricalPMF hn t).support ↔ 0 < t.val a`. At a word this is exactly positivity of its symbol count; the released `PMF.mem_supportFinset` supplies finite-set membership. |
| `wordTypeEquivPMF` | `(hn : 0 < n) → T ≃ {q : PMF A // ∃ c : A → ℕ, (∑ a, c a) = n ∧ ∀ a, q a = (c a : ℝ≥0∞) / (n : ℝ≥0∞)}`. The witness is a proposition about a PMF; different witness proofs do not create different indices. |
| `wordTypeEquivPMF_apply` | `((wordTypeEquivPMF hn) t).val = empiricalPMF hn t`. The equivalence's two inverse laws must recover the supplied count index and the supplied witnessed PMF, respectively. |
| `mem_typeClass_iff_empiricalPMF_eq` | `x ∈ typeClass t ↔ empiricalPMF hn (wordType x) = empiricalPMF hn t`. This is CT91 (12.2) on the original class. |

At `n = 0` there is one empty word and one zero index even if `A` is empty. For empty `A` and positive `n` there is neither a word nor an admissible index. For singleton `A` the unique count is `n`. The plan assigns no PMF to zero counts, adds no default symbol or PMF, and imposes no full-support or nonempty-alphabet hypothesis.

## Ownership, checked dependencies and proof route

Propose two separately importable owners, both exported by the full import-only `LeanInfoTheory.Shannon`. `LeanInfoTheory.Shannon.WordType` owns the counts, enumeration, class and bound; its proposed direct imports are `Mathlib.Algebra.Order.Antidiag.Pi` and `Mathlib.Data.Fintype.BigOperators`. `LeanInfoTheory.Shannon.EmpiricalPMF` adds only the positive-length law and conversion, importing the count owner and `LeanInfoTheory.Probability.Finite`. Neither production owner needs iid, prefix coding, entropy or KL. Keep the lightweight root at its existing two direct imports, five reachable modules and 92 exports. Development examples may separately import iid to exercise the event expression. [Finite PMF support](../../LeanInfoTheory/Probability/Finite.lean) · [Iid position convention](../../LeanInfoTheory/Probability/Iid.lean) · [Existing finset-as-event consumer](../../LeanInfoTheory/Shannon/TypicalSet.lean)

The following proof choices are advisory. Keep local equivalences, casts, enumerations and cancellation calculations private; freeze the public meanings and criteria upon approval.

1. Count with the filtered universal finset of positions, using local classical decisions. `Finset.card_eq_sum_card_fiberwise` partitions the positions. For the type enumeration use `Finset.univ.piAntidiag n`: `Finset.mem_piAntidiag` says its entries sum to `n` and their support is contained in the universal alphabet; the second condition is automatic. `Finset.piAntidiag_zero` handles the singleton at zero. This reuses the pinned enumeration and gives downstream finite sums without a new instance. [Antidiagonal source](../../.lake/packages/mathlib/Mathlib/Algebra/Order/Antidiag/Pi.lean)
2. Given `t`, the labeled slots `Σ a : A, Fin (t.val a)` have cardinality `∑ a, t.val a = n` by `Fintype.card_sigma`. Use `Fintype.equivOfCardEq` to identify `Fin n` with these slots, and read the first projection to obtain a word. For each label, `Equiv.subtypeEquivOfSubtype` transports its position fiber and `Equiv.sigmaSubtype` identifies the target fiber with `Fin (t.val a)`. `Fintype.card_subtype` connects this fiber calculation to the filtered count. No ordering of symbols, default inhabitant, or nonzero slot is needed. Define the class by filtering all words on equality to the given index.
3. Precompose by `e` and transport each position fiber along that equivalence, in the direction used by `PMF.iid_map_perm`. For the polynomial bound, take the total `∑ b, t.val b = n` from `mem_wordTypes`. Splitting off label `a` with `Finset.add_sum_erase` gives `t.val a + (∑ b ∈ Finset.univ.erase a, t.val b) = n`, so `t.val a ≤ n`. These bounds give the coordinatewise injection of `T` into `A → Fin (n+1)`. Apply `Fintype.card_le_of_injective`, `Fintype.card_coe` and `Fintype.card_fun`. Realization and unique membership identify each distinct nonempty class with exactly one index.
4. Normalize the cast counts with `PMF.normalize`: their finite sum is `(n : ℝ≥0∞)`, nonzero by `hn` and finite because it is a natural cast. `PMF.normalize_apply` and `PMF.mem_support_normalize_iff` give the public atom and support formulas. For the inverse conversion, choose a supplied exact count witness and apply `mem_wordTypes` to its total. Two witnesses have equal counts: multiply equal atoms by the nonzero finite denominator using `ENNReal.div_mul_cancel`, then use injectivity of the natural cast. This proves independence of the chosen witness and both inverse laws. PMF extensionality and the equivalence give the membership characterization; reduced fractions, real rounding and a PMF-indexed class constructor are unnecessary. [Pinned normalization](../../.lake/packages/mathlib/Mathlib/Probability/ProbabilityMassFunction/Constructions.lean)

At intake the warning-as-error focused build of `Probability.Finite` and `Probability.Iid` passed under Lean 4.33.1 and pinned mathlib `0df444a360eaa60ab8c11dca51a86af692955474`. Declaration lookups and statement-shape checks concern existing APIs; they do not constitute proofs of C37. The project source and generated declaration index had no existing word-type family. [Toolchain](../../lean-toolchain) · [Pins](../../lake-manifest.json)

## C37.01 — Counts at every length

- **C37.01-COUNTS** — Before public growth, qualify the incoming 888 named signatures against the actual producers and pins as specified below. Define the filtered-position count; prove the sum theorem without positivity or nonempty-alphabet assumptions and the zero-length pointwise equation without a finite-alphabet assumption.
- **C37.01-INDEX** — Supply the finite admissible count enumeration, its exact membership iff, singleton zero enumeration, and the word index with its stated count projection. A focused caller constructs an index from a plain function and its sum proof and reads its labeled natural entries. Check the count owner independently of the PMF layer.

## C37.02 — Realization and partition

- **C37.02-REALIZE** — Prove surjectivity for every admissible index at every length, preserving the original labels, including any zero coordinates. A caller starting with an arbitrary vector of total `n` must obtain an actual `Fin n → A` with those very counts.
- **C37.02-CLASS** — Supply the single finset fiber, membership iff and unique-membership theorem. Use the public results to show that each supplied index has a nonempty class, that two indices sharing a word agree, and that equal class finsets imply equal indices. Cover all words without postulating realizability.

## C37.03 — Position permutations and number of classes

- **C37.03-PERM** — Prove the pointwise count and bundled type equations for every position permutation, with the displayed orientation. Derive for arbitrary `t` that `x ∘ e ∈ typeClass t ↔ x ∈ typeClass t` in a focused caller. This is wordwise, for every length.
- **C37.03-BOUND** — Prove the stated natural-cardinality upper bound with exponent `Fintype.card A`. Explain the injection, and connect its domain to distinct realized classes using C37.02. Check empty-alphabet and zero-length boundaries. No estimate of `(typeClass t).card` substitutes for this criterion.

## C37.04 — The positive-length empirical PMF

- **C37.04-LAW** — Construct the PMF on the original alphabet from the given index and explicit `hn`. Prove its exact atom formula on every label, and specialize it to `symbolCount x a / n` with the indicated casts. Derive equality of empirical PMFs after arbitrary position reordering from C37.03. Build the empirical owner independently of the full umbrella.
- **C37.04-SUPPORT** — Prove the actual-support iff for all indices, including unused labels, and derive the word and `supportFinset` forms through the public interfaces. Check that positive length enters the normalization and that no constructor interpreting all-zero counts as a law is exposed.

## C37.05 — Exact denominator and round trips

- **C37.05-CONVERT** — Give the displayed equivalence and identify its forward law with `empiricalPMF`. In a generic caller use `symm_apply_apply` on an arbitrary admissible index and `apply_symm_apply` on an independently supplied witnessed PMF. Recover its labeled numerator counts; justify why different admissible witnesses for the same PMF cannot alter the answer.
- **C37.05-MEMBER** — Establish the displayed empirical-membership iff on the C37.02 finset in both directions. The backward direction must recover the counts of the supplied index, without choosing an ordering of words or introducing a second event.

## C37.06 — Permanent consumers

Use `LeanInfoTheory.Examples.WordType`, in the development `Examples` aggregate, with the focused empirical owner. For the shared-event caller add only the released iid owner as a direct project import. Exercise the following with ordinary compiled Lean proofs.

- **C37.06-BINARY** — Write `0` for `false` and `1` for `true`. For the word `001`, supply the labeled counts `(2,1)`, prove membership, compute the masses `(2/3,1/3)` and recover the counts through the inverse PMF conversion. For the position cycle `e : 0 ↦ 1 ↦ 2 ↦ 0`, check that `001 ∘ e` reads `010` and that precomposition with the inverse reads `100`. Check that the forward cycle preserves the class and empirical PMF. Exclude `011` from the original class by its counts `(1,2)`, even though its empirical support also contains both labels. Enumerate the four possible pairs `(3,0), (2,1), (1,2), (0,3)` and apply C37.03 to their number, giving `4 ≤ 4² = 16`.
- **C37.06-SPARSE** — On `Fin 3` take the word `(0,1,0,1)` with counts `(2,2,0)`. Construct its law independently with masses `(1/2,1/2,0)` and an exact denominator-four witness. Check that the inverse recovers `(2,2,0)`, that its support contains exactly 0 and 1, and that any word containing 2 is outside this class. Pair this with the fair Boolean law `q` at length three. For `h₃ : 0 < (3 : ℕ)`, prove `¬ ∃ t : ↥(wordTypes Bool 3), empiricalPMF h₃ t = q`. Equality at `false` would force its natural count `k` to satisfy `2 * k = 3`. This pair exercises both possible and impossible denominators for the same atom mass `1/2`.
- **C37.06-BOUNDARY** — Exercise the unique empty word/class with zero counts even on an empty alphabet, the absence of positive-length indices on that alphabet, and the unique positive-length count on a singleton. No empty-word PMF is used.
- **C37.06-CALLER** — Using the public focused imports, prove `x ∈ typeClass t ↔ ∀ a, symbolCount x a = t.val a` in both directions and the displayed partition identity for an arbitrary word weight at every length. Keep these two proofs private to the example module. Compile an independent caller using only public declarations that takes `(typeClass t).card` and `(PMF.iid p n).toOuterMeasure (typeClass t)` on the same finset and, at positive length, uses the empirical-membership iff.

  ```lean
  (∑ t : ↥(wordTypes A n), ∑ x ∈ typeClass t, f x) = ∑ x : Fin n → A, f x
  ```

  Here `f : (Fin n → A) → M` is any function with `[AddCommMonoid M]`. For pointwise membership use `mem_typeClass`, the count projection and extensionality. For the sum, identify each class with the fiber of `wordType` by its membership iff and apply `Finset.sum_fiberwise`.

## C37.07 — Cumulative qualification, review and C38 handoff

- **C37.07-VALIDATE** — Build both focused owners, permanent consumers, full Shannon and example aggregates, and lightweight root. Check all contracts, boundary cases, direct imports, ownership, preserved root exports and simp set, axioms, and both the incoming and released signature comparisons. Record the exact source, actual results, and any outstanding clean qualification.
- **C37.07-HANDOFF** — Before final capture, reconcile the living summary, references, project log, step notes and maintained `docs/handoffs/chunk-37.md`. Give C38 the final signatures and focused imports for realization, class cardinality, positive-length conversion and support. Link the compiled examples that recover labeled counts from membership, establish membership from counts and sum weights over all classes. Show C39's iid event expression on the same finset. Record source adaptations, naming decisions and outstanding qualifications. C38 owns exact multinomial class size and entropy estimates. C39 owns general iid type probabilities and KL, including support failure.
- **C37.07-REVIEW** — Present all approved criteria, cumulative source, permanent and independent consumers, actual validation and maintained handoff for fresh independent review by the bound reviewer. Reconcile the original assessments and every finding; resolve gaps under the installed procedure, verify final-source applicability, and complete document edits before final capture. Only the private supported completion record establishes closure; report its actual reference then.

## Validation and review boundaries

The [C36 handoff](../handoffs/chunk-36.md#qualification-and-review-identities) and quick start were written before final capture. The subsequent C36.06 receipt records supervised closure `4fc4ee595fde988debd5d3b7170baab475f05105b2802fa00cde4ab47067b09c` on final source `0d2df93e9266fcbfc21244a3e555b434163e66c5b3ab8c326befa25217822973`. Its primary-checkout checks stand on their recorded inputs. **The complete clean-checkpoint suite and clean hygiene gate remain outstanding for the C36 candidate.** No earlier checkpoint, focused C37 lookup or later C37 run retroactively qualifies it. C36 mathematics stays closed.

The primary checkout is on `master` at `2eb80d0e746688511618aaefc2624ffa4ae88f6e` with pre-existing changes. The C36 export `.lake/compatibility/c36-06-facts-20261117/current-888.json` matched its recorded SHA-256 `ac164a66e1acdf3ad050d5a5c420d11c3c4c6a08caa538bc8b4939e2eab944bc` at planning intake. The digest identifies the export; before C37.01 growth, match its producer inputs, compiled owners and dependency pins to the actual tree, or obtain a fresh attributable pre-growth comparison. Account for every incoming name, kind, owner and type at closeout. Keep the frozen 601- and 811-declaration contracts separate from that development comparison.

For each approved, separately selected step: capture its actual baseline; use the required EPFL/MIL header on new Lean files. For approved public growth update the separately reviewed current-API policy, regenerate the current manifest, blueprint and website index, and check each in non-mutating mode, including the historical generator's `--check`. Run `python scripts/validate_release.py focused <touched owners and aggregates>` and `python scripts/validate_development.py static`; serialize artifact-producing builds. Compare reviewed direct imports, the five-module root, 92 root exports and 94 simp declarations. Keep implementation and proof adjustments in separate notes; a material contract or acceptance change returns to the lead.

At closeout also run `python scripts/validate_development.py compatibility`, `python scripts/validate_development.py trust` and `python scripts/validate_release.py documentation`. The complete `python scripts/validate_development.py` and clean hygiene require an authorized clean checkpoint; repeat after amendment, or state precisely what remains outstanding. Do not commit existing work to obtain a pass. The isolated `api-docs` build and external-consumer release qualification have their own milestones. [Development compatibility guide](../compatibility/README.md)

The actual C37 parent ran the installed `inspect` and `api` commands and bound `/root/c37_reviewer` with requested profile `gpt-6-astra`, `ultra`, `fork_turns="none"`. Effective settings were not reported. The recorded independent assessment and reconciliation concern revision 1. A further plan review requires a separate request against the specified revision. The parent chooses inline or verified-file delivery and retains the originals and dispositions. Implementation requires lead approval of the exact plan and selection of one step and its requested review. [Review protocol](../review-protocol.md) · [Operations](../review-operations.md)
