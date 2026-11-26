# Chunk 37 — Symbol counts, empirical laws and type classes

C37 supplies the finite-word interface for the method of types. Natural count vectors totaling the length are the primary indices. Every index is realized by a word, and one finite `typeClass` serves both counting and probability consumers. At positive length, an equivalence converts the index to a PMF with an exact denominator witness and back. All seventeen approved criteria are included in cumulative qualification; actual review, reconciliation and closure are determined by the private completion record described below. [Approved revision 2](../plans/release-3-chunk-37.md) · [Implementation notes](../plans/release-3-chunk-37-notes.md)

## Public contracts and focused imports

All twenty additions belong to `LeanInfoTheory.Shannon`: six definitions and fourteen theorems. Import `LeanInfoTheory.Shannon.WordType` for counts and classes; import `LeanInfoTheory.Shannon.EmpiricalPMF` for the positive-length conversion as well. The first owner directly imports only `Mathlib.Algebra.Order.Antidiag.Pi` and `Mathlib.Data.Fintype.BigOperators`. The second directly imports the first and `LeanInfoTheory.Probability.Finite`. Neither depends on prefix coding, iid probabilities, entropy estimates or KL. The full Shannon umbrella exports both; the lightweight root retains two direct imports, five project modules and 92 exports. [Count owner](../../LeanInfoTheory/Shannon/WordType.lean) · [Empirical owner](../../LeanInfoTheory/Shannon/EmpiricalPMF.lean)

The signatures below use namespace `LeanInfoTheory.Shannon`, `open scoped BigOperators ENNReal`, variables `{A : Type u} {n : ℕ}`, and `[Fintype A]` except for `symbolCount`, `symbolCount_zero` and `symbolCount_comp_perm`, which need no finite-alphabet instance. All definitions are noncomputable. Declaration bodies remain authoritative in the linked source.

```lean
symbolCount (x : Fin n → A) (a : A) : ℕ
symbolCount_zero (x : Fin 0 → A) (a : A) : symbolCount x a = 0
sum_symbolCount (x : Fin n → A) : (∑ a, symbolCount x a) = n
wordTypes (A : Type u) [Fintype A] (n : ℕ) : Finset (A → ℕ)
mem_wordTypes (c : A → ℕ) : c ∈ wordTypes A n ↔ (∑ a, c a) = n
wordTypes_zero (A : Type u) [Fintype A] : wordTypes A 0 = {0}
wordType (x : Fin n → A) : ↥(wordTypes A n)
wordType_surjective :
  Function.Surjective (wordType : (Fin n → A) → ↥(wordTypes A n))
typeClass (t : ↥(wordTypes A n)) : Finset (Fin n → A)
mem_typeClass {x : Fin n → A} {t : ↥(wordTypes A n)} :
  x ∈ typeClass t ↔ wordType x = t
existsUnique_mem_typeClass (x : Fin n → A) :
  ∃! t : ↥(wordTypes A n), x ∈ typeClass t
symbolCount_comp_perm (x : Fin n → A) (e : Equiv.Perm (Fin n)) (a : A) :
  symbolCount (x ∘ e) a = symbolCount x a
wordType_comp_perm (x : Fin n → A) (e : Equiv.Perm (Fin n)) :
  wordType (x ∘ e) = wordType x
card_wordTypes_le (A : Type u) [Fintype A] (n : ℕ) :
  (wordTypes A n).card ≤ (n + 1) ^ Fintype.card A
empiricalPMF (hn : 0 < n) (t : ↥(wordTypes A n)) : PMF A
empiricalPMF_apply (hn : 0 < n) (t : ↥(wordTypes A n)) (a : A) :
  empiricalPMF hn t a = (t.val a : ℝ≥0∞) / (n : ℝ≥0∞)
mem_support_empiricalPMF_iff (hn : 0 < n) (t : ↥(wordTypes A n)) (a : A) :
  a ∈ (empiricalPMF hn t).support ↔ 0 < t.val a
wordTypeEquivPMF (hn : 0 < n) :
  ↥(wordTypes A n) ≃
    {q : PMF A // ∃ c : A → ℕ, (∑ a, c a) = n ∧
      ∀ a, q a = (c a : ℝ≥0∞) / (n : ℝ≥0∞)}
wordTypeEquivPMF_apply (hn : 0 < n) (t : ↥(wordTypes A n)) :
  ((wordTypeEquivPMF hn) t).val = empiricalPMF hn t
mem_typeClass_iff_empiricalPMF_eq (hn : 0 < n)
    {x : Fin n → A} {t : ↥(wordTypes A n)} :
  x ∈ typeClass t ↔ empiricalPMF hn (wordType x) = empiricalPMF hn t
```

`(wordType x).val` is definitionally `symbolCount x`. Construct a supplied index as `⟨c, (mem_wordTypes c).2 hc⟩` from `hc : (∑ a, c a) = n`. Surjectivity realizes that exact index, including its original alphabet labels. Together with `mem_typeClass`, it gives nonemptiness of every class. Unique membership and nonemptiness show that distinct indices give distinct classes, so the bound on indices also bounds the number of classes. It says nothing about the number of words in one class.

For positive `hn`, the ordinary equivalence laws `(wordTypeEquivPMF hn).symm_apply_apply t` and `(wordTypeEquivPMF hn).apply_symm_apply q` recover an arbitrary supplied index and an arbitrary independently witnessed law respectively. Injectivity recovers every labeled count from equal empirical laws. The existential count witness is a proposition, not a second index or a choice of representation. A prescribed denominator need not be least: `(1/2,1/2,0)` has denominator four, whereas the fair binary law has no denominator-three witness.

## One class for downstream callers

The permanent private consumer proves exactly

```lean
x ∈ typeClass t ↔ ∀ a, symbolCount x a = t.val a
```

It uses only `mem_typeClass`, subtype extensionality and the definitional count projection. The forward direction reads multiplicities; the reverse establishes membership from a calculation. It remains a consumer rather than an extra public alias. A second private consumer proves, for every `AddCommMonoid M` and word weight `w`,

```lean
(∑ t : ↥(wordTypes A n), ∑ x ∈ typeClass t, w x) = ∑ x, w x
```

using `Finset.sum_fiberwise`. This is the all-length weighted partition needed for later probability summation. [Both generic consumers](../../LeanInfoTheory/Examples/WordType.lean#L274)

C38 takes `(typeClass t).card`. With the additional focused import `LeanInfoTheory.Probability.Iid`, C39 takes `(PMF.iid p n).toOuterMeasure (typeClass t)`, using the coercion of that same finset to a set. The permanent caller type-checks these side by side. At positive length, `mem_typeClass_iff_empiricalPMF_eq hn` connects the event to empirical equality without defining another class. [Shared-class caller](../../LeanInfoTheory/Examples/WordType.lean#L349)

## Boundaries and permanent consumers

Counts, realization, unique membership, position permutation and the type-count bound hold at every length. At zero there is one all-zero index and one empty word, and its class is that singleton, even on `Empty`. At positive length `Empty` has no type indices or words. On `Unit` the only count is `n`. No empirical PMF is assigned to zero-length counts and no ambient `Nonempty A` assumption is added.

For `e : Equiv.Perm (Fin n)`, new position `i` reads old position `e i`, so the reordered word is `x ∘ e`. The invariance of `wordType` gives membership in every supplied class and, for positive length, the same empirical PMF. This acts on positions, not alphabet labels. Actual empirical support, and hence finite support through the released support API, consists exactly of positive-count labels.

| Consumer | Checks |
| --- | --- |
| Binary `001` at length three | Counts `(2,1)`, supplied-index membership, masses `(2/3,1/3)`, inverse labeled counts, directed cycle `001 → 010` versus inverse `001 → 100`, invariant class/law, and rejection of `011` despite the same support. Four distinct types satisfy the bound `4 ≤ 16`. [Binary](../../LeanInfoTheory/Examples/WordType.lean#L36) |
| Sparse `0101` over `Fin 3` | Counts `(2,2,0)`, independently supplied law `(1/2,1/2,0)` with denominator four, inverse counts, actual and finite support `{0,1}`, and exclusion of words using `2`. [Sparse](../../LeanInfoTheory/Examples/WordType.lean#L143) |
| Fair binary law at length three | A putative count would satisfy `2 * k = 3`; no empirical type has this law. [Impossible denominator](../../LeanInfoTheory/Examples/WordType.lean#L245) |
| Empty and singleton alphabets | Generic zero counts and singleton empty-word class, no positive `Empty` types, and the unique `Unit` index. [Boundary](../../LeanInfoTheory/Examples/WordType.lean#L295) |

The example module directly imports only the empirical and iid owners. Its helpers are private. `LeanInfoTheory.Examples` includes it; neither supported mathematical umbrella imports examples. The cumulative independent public-only caller additionally checks arbitrary objects, both equivalence round trips, supplied-witness recovery and uniqueness, class injectivity and cardinality, support, permutation, and shared event use without importing example-private helpers.

## Source interpretation and design decisions

CT91 §12.1, printed pp. 279–281 (PDF 301–303 in the registered 1991 file), supplies relative frequencies, the class definition (12.2) and the number-of-types bound, Theorem 12.1.1 (12.6). The reference file's SHA-256 remains `16f016eafbb1160c2d8e6c29ff28db870e0eb2e61c15ea39bea5b06d463a952f`. Realization, unique membership, explicit coordinate orientation and labeled inverse recovery make that interface usable in Lean. Zero-length counts and empty-alphabet cases are explicit project extensions; the concrete fixtures are original project consumers. No textbook proof text is reproduced. [Reference register](../references.md#ct91-cover-and-thomas)

The count finset uses pinned mathlib `Finset.piAntidiag`, with index subtype `↥(wordTypes A n)`. Realization uses slots `Σ a, Fin (t.val a)` and a cardinality equivalence from `Fin n`. The number-of-types proof bounds each natural entry directly from the sum and injects into `A → Fin (n+1)`; it does not depend on constructing a realizing word. Empirical laws use `PMF.normalize` only after positive length establishes a nonzero finite total. Private cancellation and `Equiv.ofBijective` supply the conversion; standard equivalence laws replace custom inverse-law aliases. The approved mathematical contracts are unchanged. No new simp attributes or naming aliases were needed; discovery follows the `symbolCount`, `wordTypes`, `wordType`, `typeClass`, `empiricalPMF` and `wordTypeEquivPMF` families.

## Cumulative criteria and qualification

| Approved step | Criteria | Source and evidence |
| --- | --- | --- |
| C37.01 | `COUNTS`, `INDEX` | Count owner: exact sums, zero counts, admissible indices. |
| C37.02 | `REALIZE`, `CLASS` | Surjectivity, membership, unique class; generic caller checks nonempty and distinct classes. |
| C37.03 | `PERM`, `BOUND` | Position invariance and direct count bound; directed binary cycle and empty boundaries. |
| C37.04 | `LAW`, `SUPPORT` | Atom formula at positive length and actual support; sparse and generic finite-support checks. |
| C37.05 | `CONVERT`, `MEMBER` | Both arbitrary-object round trips, labeled witness recovery/uniqueness and the original class's empirical-membership iff. |
| C37.06 | `BINARY`, `SPARSE`, `BOUNDARY`, `CALLER` | Permanent consumers, membership by counts, arbitrary-weight partition, public-only caller and shared class/event. |
| C37.07 | `VALIDATE`, `HANDOFF`, `REVIEW` | Cumulative source, compiled retention/import/trust checks, this maintained handoff and fresh assessment of all seventeen criteria. |

The exact approved revision 2 has SHA-256 `ef66cf73151cd428684542ce34ef9bebf57ac081ca3789254a897e4063ff325b`. Plan review assessed revision 1; user approval and execution selection apply to revision 2. The first six steps have supported private closures. Their originals, reconciliations and source references remain in `.lit-review/setup/c37-01-20261117/` through `c37-06-20261117/`; Step 6 closure is `6c8a45df8f2684a837b1b6baab4749a0c7c6a2652365a33db2d8e7e431a87b37`. No earlier report substitutes for the final cumulative review.

Fresh primary-checkout focused builds cover both owners, the permanent example, `Examples`, `Shannon` and the lightweight root. Generated-file checks, development static, separate retained compatibility, the full maintained trust/import/axiom gate, and release documentation/example validation passed. Exact commands, raw results, source fingerprints and attributable support checks are indexed in `.lake/compatibility/c37-07-validation-20261117/index.json`; private originals remain under `.lit-review/setup/c37-07-20261117/`. The public-only cumulative caller is under `.lake/compatibility/c37-07-caller-20261117/`; compiled controls are under `.lake/compatibility/c37-07-facts-20261117/`. Final checks and unchanged-source applicability are recorded separately before final capture.

The incoming C36 export contains 888 declarations and has SHA-256 `ac164a66e1acdf3ad050d5a5c420d11c3c4c6a08caa538bc8b4939e2eab944bc`. C37.01 qualified its producer provenance before growth. The cumulative comparison retains each original name, elaborated type, kind and owner and identifies exactly the twenty C37 additions. The current surface has 908 supported declarations in 74 modules, with 94 reviewed simp declarations. Both released baselines, 601 and 811 declarations, are separately retained. Root boundaries remain 2/5/92; examples remain outside both supported umbrellas. The allowed axioms remain only `propext`, `Classical.choice` and `Quot.sound`.

Validation is on the dirty primary checkout, branch `master`, HEAD `2eb80d0e746688511618aaefc2624ffa4ae88f6e`, with preexisting work preserved. Lean is 4.33.1 and mathlib is `0df444a360eaa60ab8c11dca51a86af692955474`; all nine dependency states are checked. No commit or clean C37 snapshot is authorized or created. The complete clean-checkpoint suite and its hygiene gate remain outstanding for C37. C36's corresponding qualification remains separately outstanding; its mathematics is closed and is not reopened or retroactively qualified here. Release API-documentation generation, exact-commit external-consumer qualification and publication remain separate milestones.

This is the maintained pre-final handoff, with validation ready. The exact original cumulative report, all seventeen assessments, parent reconciliation, final applicability and supported closure are established only by `.lit-review/setup/c37-07-20261117/completion.json` and its linked records once issued. No post-final source edit is needed to turn a readiness statement into an acceptance claim.

## Handoff to C38 and C39

C38 starts from the supplied natural count index and the existing finite class. It must identify `(typeClass t).card` with the exact multinomial coefficient, then prove the two-sided entropy estimate with factor `(n+1)^k`. Inspect pinned mathlib `Nat.multinomial` and permutation counting before selecting its proof route. The count bound is already available; the class is already nonempty. For the own-law mass identity, use `q = empiricalPMF hn t`, the atom formula and the released iid product formula. C38 must establish that seed independently of C39. For a mode-based lower bound, maximize the probability of a count vector under this own law, not class cardinality. Preserve zero-count symbols and the stated alphabet-size factor. Expected consumers include the three words of binary class `(2,1)`, a pure class of size one and a sparse alphabet. These cardinalities and entropy bounds are future C38 work.

C39 then uses the same `typeClass t` event under an arbitrary `p`, together with C38 cardinality. It owns general word/class masses, nats-valued finite-KL bounds under actual support inclusion, and the zero-probability/infinite-KL branch when an observed symbol has zero `p` mass. It must distinguish one-word mass from whole-class mass and guard every conversion from canonical `ENNReal` KL at infinity. C37 supplies no general iid probability or KL estimate. [C38 and C39 roadmap](../plans/release-3-chunk-map.md#c38-counting-and-entropy-of-a-type-class)

Neither next chunk is started or approved by this handoff. A future implementation parent establishes its own reviewer and approved detailed plan. The unresolved clean-checkpoint qualifications, release-documentation milestones and publication boundaries travel with the handoff.
