# C36 — Expected length of finite binary prefix codes

<!-- lit-review-status:start -->
**Plan status:** Approved revision 2. The lead selected C36.01 with review on 16 November 2026. The independent plan review assessed revision 1. Revision 2 strengthens the dyadic and iid block examples and incorporates proof advice from the lead’s supplied review. Later steps await separate selection.
<!-- lit-review-status:end -->

## Endpoint and conventions

For a finite PMF `p`, assign one finite binary word to each possible source symbol. The labels are exactly `↥p.supportFinset`. The mean counts binary digits per source symbol. Every admissible mean is at least the entropy in bits. A single prefix encoder with the prescribed Shannon lengths has mean strictly below entropy plus one bit. The set of admissible means has a least member, attained by a prefix encoder. Applying the result to one iid block gives less than one bit of overhead **per block**, hence less than `1/n` per symbol at positive length. [C36 roadmap](release-3-chunk-map.md#c36-expected-length-and-the-variable-length-source-coding-theorem) · [C35 handoff](../handoffs/chunk-35.md)

Write `H_bits(p)` in prose for `LeanInfoTheory.Shannon.natsToBits (entropy p)`. The conversion divides by `Real.log 2`. The supported atoms have finite, strictly positive real mass summing to one. A PMF supplies nonempty support even on an ambient type with no supplied `Nonempty` instance. A singleton support may receive the empty word when the symbol count is known. Recovering a stream's unknown symbol count requires a different convention. Huffman optimality, universal coding, arbitrary single-shot injections and stationary-source entropy rates are outside the endpoint.

## Proposed public contracts

The following are signatures and defining equations in `LeanInfoTheory.Shannon`. Only the implicit alphabet and its finite enumeration are common parameters. Internal choices, including decidability for finite search, are classical. The witness theorem returns both properties of **the same encoder**.

```lean
variable {A : Type u} [Fintype A]

noncomputable def expectedCodewordLength (p : PMF A)
    (c : ↥p.supportFinset → List Bool) : ℝ :=
  ∑ a : ↥p.supportFinset, (p a.val).toReal * ((c a).length : ℝ)

theorem natsToBits_entropy_le_expectedCodewordLength (p : PMF A)
    {c : ↥p.supportFinset → List Bool} (hc : IsBinaryPrefixCode c) :
    natsToBits (entropy p) ≤ expectedCodewordLength p c

theorem exists_isBinaryPrefixCode_length_eq_ceil (p : PMF A) :
    ∃ c : ↥p.supportFinset → List Bool, IsBinaryPrefixCode c ∧
      (∀ a, (c a).length = ⌈-Real.logb 2 (p a.val).toReal⌉₊) ∧
      expectedCodewordLength p c < natsToBits (entropy p) + 1

noncomputable def optimalPrefixLength (p : PMF A) : ℝ :=
  sInf {t : ℝ | ∃ c : ↥p.supportFinset → List Bool,
    IsBinaryPrefixCode c ∧ expectedCodewordLength p c = t}

theorem isLeast_optimalPrefixLength (p : PMF A) :
    IsLeast {t : ℝ | ∃ c : ↥p.supportFinset → List Bool,
      IsBinaryPrefixCode c ∧ expectedCodewordLength p c = t}
      (optimalPrefixLength p)

theorem optimalPrefixLength_bounds (p : PMF A) :
    natsToBits (entropy p) ≤ optimalPrefixLength p ∧
      optimalPrefixLength p < natsToBits (entropy p) + 1

theorem optimalPrefixLength_iid_div_bounds (p : PMF A) (n : ℕ) (hn : 0 < n) :
    natsToBits (entropy p) ≤ optimalPrefixLength (PMF.iid p n) / (n : ℝ) ∧
      optimalPrefixLength (PMF.iid p n) / (n : ℝ) <
        natsToBits (entropy p) + 1 / (n : ℝ)
```

`(isLeast_optimalPrefixLength p).1` supplies an encoder, its prefix proof and equality to the optimum. Its second projection compares the optimum with the mean of every prefix encoder via set membership. This interface specifies tie handling through existence. Neither the Shannon witness nor an optimizer needs a canonical bit pattern.

**Focused imports.** Place the first six declarations in the proposed `LeanInfoTheory.Shannon.PrefixCodeLength`, importing `LeanInfoTheory.Shannon.PrefixCode` and `LeanInfoTheory.Shannon.Units`. The latter already imports finite entropy and the real base-log API. Place the iid theorem in `LeanInfoTheory.Shannon.PrefixCodeLengthIid`, importing `LeanInfoTheory.Shannon.PrefixCodeLength` and `LeanInfoTheory.Shannon.SemanticBridge.FiniteProduct`. Export the two owners from the import-only Shannon umbrella. Keep the support-sum identities, ceiling arithmetic, finite search type and reindexing private. The plan adds no public simp attributes. The lightweight root retains its two direct imports, five reachable modules and 92 exports. Keep the examples in the development aggregate. [C35 owner](../../LeanInfoTheory/Shannon/PrefixCode.lean) · [Units](../../LeanInfoTheory/Shannon/Units.lean) · [Iid entropy owner](../../LeanInfoTheory/Shannon/SemanticBridge/FiniteProduct.lean)

## Source interpretation and proof choices

The proof routes here are advisory. The displayed contracts and the acceptance criteria below govern each step. Keep later proof-pressure notes in a separate step-notes file. Changes to a public contract, mathematical meaning or acceptance criterion require the lead.

At intake the warning-as-error focused build passed for `Shannon.PrefixCode`, `Examples.PrefixCode`, `Shannon.Units` and `Shannon.SemanticBridge.FiniteProduct` under Lean/mathlib v4.33.1. A separate lookup using only the two proposed scalar imports checked `IsBinaryPrefixCode.kraft_sum_le_one`, `exists_isBinaryPrefixCode_of_kraft_sum_le_one`, `PMF.mem_supportFinset`, `ENNReal.toReal_pos`, `Nat.le_ceil`, `Nat.ceil_lt_add_one`, `Real.le_logb_iff_rpow_le`, `Nat.le_floor`, `Finset.exists_min_image` and `IsLeast.csInf_eq`. Read-only Lean probes elaborated the displayed scalar and iid contract expressions with local parameters for the proposed quantities. These checks concern the existing dependencies and statement forms. [C35 declarations](../../LeanInfoTheory/Shannon/PrefixCode.lean) · [C35 permanent consumers](../../LeanInfoTheory/Examples/PrefixCode.lean) · [Toolchain pin](../../lean-toolchain)

- **Textbooks.** CT91 §5.3, Theorem 5.3.1, gives the converse with normalized Kraft weights. §5.4, Theorem 5.4.1 and (5.30)–(5.37), gives the rounded construction, strict upper bound and iid division (printed pp. 85–88, PDF 107–110 for these arguments). PW24 §10.1 gives the single-shot support convention (pp. 197–198, PDF 222–223). §10.3, Remark 10.3(3) and Theorems 10.9–10.10 (pp. 206–209, PDF 231–234), treats unknown-length streams, Kraft and optimization over integer lengths. PW24 (10.13) states a weak upper bound. C36 takes the strict inequality from CT91 and proves it by strict rounding on positive support. C35's known-count singleton convention accounts for the empty word. Both registered local file hashes matched. The parent also inspected the displayed statements on CT91 PDF 110 and PW24 PDF 234. [Reference register](../references.md) · [C35 singleton and stream examples](../../LeanInfoTheory/Examples/PrefixCode.lean)
- **Sums over support.** For a real summand `f : A → ℝ` that vanishes off `p.supportFinset`, use the identity `∑ a : ↥p.supportFinset, f a.val = ∑ a : A, f a`. Use the same private specialization in C36.01 and C36.02. Mathlib’s `Finset.sum_congr_set` gives the identity in the reverse orientation by restricting `f` to the support. The project also has a finset-based proof in `EntropyBounds` using `Finset.sum_attach` and `Finset.sum_subset`. Apply the identity to the real masses and to the entropy summands in `entropy_eq_sum` and `entropy_div_log p 2`. This keeps log inequalities and divisions by atom mass on positive support. [Mathlib sum over a set](../../.lake/packages/mathlib/Mathlib/Algebra/BigOperators/Group/Finset/Basic.lean#L478) · [Existing support reindexing](../../LeanInfoTheory/Shannon/EntropyBounds.lean#L141) · [Entropy in bits](../../LeanInfoTheory/Shannon/Units.lean#L75)
- **Converse.** Set `mₐ = (p a.val).toReal`, `wₐ = (1/2)^length(c a)`, and `Z = ∑ wₐ` over the support. C35 gives `Z ≤ 1`, and every weight and mass is positive. Apply `Real.log_le_sub_one_of_pos` to `wₐ/mₐ`. Multiplying by `mₐ` and summing gives `entropy p − L * Real.log 2 ≤ Z − 1 ≤ 0`. Divide by the positive `Real.log 2`. Zero ambient masses drop out of the entropy sum before any ratio is taken. The textbook alternative sets `qₐ = wₐ/Z` and obtains `L − H_bits(p) = (D(p‖q) − log Z)/log 2` on the support. In Lean this requires constructing two subtype PMFs, establishing absolute continuity and guarding the real KL expansion with support inclusion. The existing guarded real log-sum theorem also applies to positive `NNReal` weights. The scalar log inequality already suffices under the proposed imports. [Finite real masses and support](../../LeanInfoTheory/Probability/Finite.lean) · [Finite KL expansion and finiteness](../../LeanInfoTheory/Shannon/SemanticBridge/KL.lean) · [Guarded log-sum](../../LeanInfoTheory/Shannon/LogSum.lean)
- **Witness.** For `xₐ = -Real.logb 2 mₐ ≥ 0`, take the natural ceiling `ℓₐ`. The inequalities `xₐ ≤ ℓₐ < xₐ + 1` imply `(1/2)^ℓₐ ≤ mₐ` and a strict weighted mean bound. Sum the widths, apply C35 realization on the original support labels, then substitute its pointwise length equation. At mass one, the natural ceiling is zero. `entropy_div_log p 2` identifies the weighted information with entropy in bits. A nonempty support of strictly positive weights preserves strictness upon summing.
- **Minimum.** Let `B` be the mean of the feasible Shannon witness. Each code of mean at most `B` satisfies `mₐ * length(c a) ≤ B` at each supported atom, so its natural length is at most `Kₐ = ⌊B/mₐ⌋₊`. Enumerate the finite type `(a : ↥p.supportFinset) → Fin (Kₐ + 1)` and retain profiles with Kraft sum at most one. The witness profile belongs to this set. Minimize the weighted sum on it with `Finset.exists_min_image` and realize the chosen profile with C35. A competitor of mean at most `B` occurs in the search. Any competitor of larger mean loses to the incumbent, which itself was available to the search. This proves global leastness, including ties and `B = 0`. Use `IsLeast.csInf_eq` to identify that attained mean with the defined value. This is a classical finite existence argument.
- **Uniform-cap fallback.** If transporting profiles into the dependent `Fin (Kₐ + 1)` types complicates C36.03, use `Finset.exists_min_image` on the nonempty support to choose an atom of least mass `m_min > 0`. A competitor of mean at most `B` satisfies `m_min * length(c a) ≤ mₐ * length(c a) ≤ B` at every label. One cap `K = ⌊B/m_min⌋₊` therefore suffices, and the search type becomes `↥p.supportFinset → Fin (K + 1)`. The same Kraft filter, realization and global comparison apply. Only one search proof is needed.
- **Blocks.** Apply the scalar bounds to `PMF.iid p n : PMF (Fin n → A)`, then rewrite `entropy_iid p n` in nats. Conversion gives `natsToBits (entropy (PMF.iid p n)) = (n : ℝ) * natsToBits (entropy p)`. Divide by positive `(n : ℝ)`. This encodes the whole supported word as one symbol and allows a separate optimizer for each block law. The iid entropy identity itself holds at zero.

## C36.01 — Supported mean and converse

- **C36.01-MEAN** — Qualify the incoming 881 named signatures against the actual C35 source and pins before the first addition. Implement the displayed real mean on the positive-support subtype and check the private support sums for mass one and entropy, including ambient zeros. A focused caller supplies only a finite ambient PMF and a word assignment.
- **C36.01-LOWER** — Prove the displayed lower bound for every C35 binary prefix encoder on that subtype, with no full-support, nonempty-word, optimality or extra alphabet assumptions. Check the use of C35 necessity, support positivity and the direction of the conversion by `Real.log 2`. Build the scalar owner and check the focused signature and umbrella export.

## C36.02 — Shannon lengths on the original labels

- **C36.02-ROUND** — Establish the nonnegative information, lower ceiling bound, strict upper rounding bound and labeled real Kraft budget for all positive support masses, including mass one.
- **C36.02-WITNESS** — The public existential returns one C35 prefix encoder with the specified natural ceiling at every label and strict mean bound in bits. Exercise both projections on the very same witness in a focused caller.

## C36.03 — An attained scalar optimum

- **C36.03-ATTAIN** — Define the optimum with the displayed set of admissible costs and prove the displayed `IsLeast` theorem. Show why a feasible incumbent bounds the search, why minimization returns a realizable profile, and why the comparison covers unrestricted competitors. Extract an actual attaining encoder and compare its cost against an arbitrary admissible code in a focused caller.
- **C36.03-BOUNDS** — Derive both scalar bounds for the attained value. Apply C36.01 to a minimizing encoder and apply leastness to the C36.02 witness for the strict upper bound. The proof and consumer must permit different encoders on the two sides.

## C36.04 — Per-symbol bounds for iid blocks

- **C36.04-IID** — Prove the displayed result for every finite PMF and every positive `n`. Check the actual support domain of the block PMF, the multiplicative entropy identity in nats, and the real division yielding the strict `1/n` overhead. Build and exercise the new iid owner independently of the full umbrella. Keep the finite-product semantic dependency out of the one-symbol owner.

## C36.05 — Permanent examples

Add `LeanInfoTheory.Examples.PrefixCodeLength` to `LeanInfoTheory.Examples`. Import the focused iid owner, which exposes the scalar API. Use finite PMF constructors and local calculations for the fixtures. Compile these exact checks, including their prefix witnesses.

- **C36.05-DYADIC** — Give four ambient labels masses `(1/2, 1/4, 1/4, 0)`. Verify that the fourth label is outside the code domain. Assign `(0, 10, 11)` in order to the three supported labels and check the prefix condition and Kraft sum `1`. Using the actual law, words and universal converse, prove that their mean, `natsToBits (entropy p)` and `optimalPrefixLength p` all equal `3/2` bits. A further finite word for the zero-mass label would put the Kraft sum above one.
- **C36.05-BIASED** — On `Bool` take `p true = 3/4` and `p false = 1/4`. Extract the C36.02 witness, prove its respective lengths are `1` and `2` and its mean is `5/4`. Exhibit a one-bit word for each label. An empty word would prefix the other supported word, so every admissible code gives both labels length at least one. Prove its least mean is exactly `1` and the Shannon witness costs strictly more. Use exact arithmetic and logarithm inequalities.
- **C36.05-PURE** — On `PMF.pure false : PMF Bool` show that the other ambient label has zero mass and lies outside the domain. Exhibit the supported encoder with word `[]`, verify it is prefix and prove its mean, converted entropy and optimum are all zero. Retain the known-count interpretation exercised in C35.
- **C36.05-BLOCK** — Instantiate the iid theorem on the biased law at `n = 2` with upper overhead `1/2` per symbol. For the supported pairs `(TT, TF, FT, FF)` in coordinate order, check the masses `(9, 3, 3, 1)/16` under `PMF.iid p 2`. Assign `(0, 10, 110, 111)` respectively, verify the prefix condition and compute the mean `27/16` bits per pair. Concatenating two copies of the one-bit optimizer from C36.05-BIASED costs `2` bits per pair. Use C36.03 to obtain an encoder attaining the block optimum and to show `optimalPrefixLength (PMF.iid p 2) / 2 ≤ 27/32 < 1 = optimalPrefixLength p`. The explicit encoder supplies the comparison witness. Also compile an independent caller using only the focused iid import and public results on an arbitrary input law.

## C36.06 — Cumulative review, qualification and C37 handoff

- **C36.06-VALIDATE** — Build both owners, permanent examples, full Shannon and development aggregates and the lightweight root. Recheck the exact contracts, independent caller, approved direct imports, root visibility, simp and axiom policy. Compare every incoming C35 named type, owner and kind and account for the seven proposed additions separately. Run the applicable cumulative gates below and distinguish clean-checkpoint evidence from primary-checkout results.
- **C36.06-HANDOFF** — Before final capture, reconcile the living summary, targeted project log, reference register, release map and step notes. Link a maintained `docs/handoffs/chunk-36.md` with the exact public signatures/imports, support and unit conventions, numerical consumers, validation identities, review/disposition references and remaining limits. Supply the C40 endpoint ledger with the quantifiers and actual witnesses. For C37 record its independent starting point, positive-length count-vector/empirical-law choice, realizability and coordinate-permutation obligations, and the empty-word normalization boundary from the roadmap. C37 planning and implementation require their own selection.
- **C36.06-REVIEW** — Prepare the complete candidate and handoff for fresh cumulative independent review by the bound C36 reviewer against every approved criterion. Make the universal converse, strict Shannon witness, global minimum, iid specialization, three contrasting laws and earlier finding dispositions independently checkable at the reviewed source.

Retain the original cumulative report, reconcile every finding and assessment, and validate final-source applicability after corrections under the installed procedure. Finish captured-document edits before final capture. Record the actual closure reference in the private completion record and user report.

## Validation and review boundaries

For each separately selected step, record the actual working-tree baseline and inspected pins. Run `python scripts/validate_release.py focused <targets>` on the touched owners and relevant consumers, serializing Lean builds, and `python scripts/validate_development.py static`. The C35 cumulative named export compared 878 incoming types and identified all 881 current ones. Its private `c35-04-audit-20261114/run-20261114T222353064531Z/export.stdout` has SHA-256 `10f262ace43aef4e7b46c1933dc67c2a73e3271560eab094f38bec3489a2c229`. Match its source inputs to this checkout, or produce a fresh identified 881-name baseline before growth. Preserve the two released contracts (601 and 811), the 94 reviewed simp declarations and all unrelated work. [C35 qualification](../handoffs/chunk-35.md#validation-and-review-identities) · [Compatibility guide](../compatibility/README.md)

For approved growth, update the reviewed current-API policy, regenerate `docs/current-public-api.json`, the website blueprint and source index with their maintained generators, run their non-mutating `--check` commands and `python scripts/generate_v0_1_public_api.py --check`. Audit exact declaration ownership, imports, compiled types, root reachability and axioms. Use the project EPFL/MIL header for new Lean files.

At closeout run `python scripts/validate_development.py compatibility`, `python scripts/validate_development.py trust` and `python scripts/validate_release.py documentation`. The full `python scripts/validate_development.py` and hygiene check require an authorized clean checkpoint. Record the exact source or explicitly outstanding qualification and repeat after amendment. The isolated `api-docs` gate is reserved for a separately justified documentation or release milestone.

For an authorized plan review, assess the signatures and quantifiers against the endpoint, proof feasibility against the named APIs and source passages, and whether the scoped steps, consumers and closeout can detect a false or weakened result. The actual C36 parent bound `/root/c36_reviewer` with the installed `gpt-6-astra` / `ultra` profile and `fork_turns="none"`. Effective settings were unreported. The installed `inspect` and `api` commands succeeded. The parent chooses inline or verified-file delivery under the recorder and retains the original request, native evidence, report and reconciliation. Plan review awaits its own request. Implementation requires approval of the exact revision and selection of one step. [Review protocol](../review-protocol.md) · [Review operations](../review-operations.md)
