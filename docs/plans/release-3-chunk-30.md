# C30 — One-shot channel-coding achievability

<!-- lit-review-status:start -->
**Plan status:** Approved, revision 2. The lead accepted the presented revision with SHA-256 `878487e1161e49252e32b31bf2b797fa7d1795e7854c84bc130490d5e4e40a78` and selected C30.01 with its review process on 11 November 2026. The formal plan review covers revision 1. Proof guidance may evolve through documented judgment. Later steps require their own selection.
<!-- lit-review-status:end -->

## What a caller gets

Fix the caller's `n M : ℕ`, `hM : 1 ≤ M`, and **any** `q : PMF (Fin n → X)`. A deterministic code with exactly these parameters can attain uniform-message error at most

**J(Aᶜ) + (M−1) Q(A).**

Here `U = Fin n → X`, `V = Fin n → Y`, and `Book = Fin M → U` are notation in this plan. For `K : U → PMF V`, put `J = PMF.channelJoint q K` and `Q = indepProd q (q.bind K)`. Write `μ(S)` for `(μ.toOuterMeasure S).toReal`. The coefficient in the public real inequalities is `((M : ℝ) - 1)`. For `A = infoDensityThresholdEvent q K t` the false-match term can be replaced by `((M : ℝ) - 1) * Real.exp (-t)`. The miss is the literal complementary event under `J`. These are upper bounds for a supported deterministic construction and may exceed one.

`P = PMF.iid q M` samples whole words independently over **message labels**. `L m = codebookOutputLaw q K m` retains the book and the output obtained by sending its word at index `m`. `C_A b = BlockChannelCode.ofAcceptanceEvent b A hM` uses that book as encoder. It decodes to the first passing label, with label zero as fallback. Define the following expressions **only as notation in the plan**.

- `D m = {z : Book × V | (C_A z.1).decoder z.2 ≠ m}`.
- `E = (1 / (M : ℝ)) * ∑ m : Fin M, (L m)(D m)`, with real event masses as above.
- `e_K(b) = (1 / (M : ℝ)) * ∑ m : Fin M, (K (b m))({y | (C_A b).decoder y ≠ m})`.
- `B_A = J(Aᶜ) + ((M : ℝ) - 1) * Q(A)`.

The fixed-book expression measures each error under the row actually used by that book. Whole-experiment projection identities are applied under `L m`. Distinct labels may carry equal words. The selected encoder pushes uniform message labels forward to its own input law. Membership in `P.support` constrains the words it can use and imposes no equality of this induced law with `q`.

## Proposed public surface

Four theorems in `LeanInfoTheory.Shannon`, in a new focused `LeanInfoTheory.Shannon.ChannelCodingOneShot` module. Names below are proposals. This owner brings together the random experiment, deterministic extraction, and finite operational guarantee. In C30.01 its sole direct import is `Shannon.RandomCodebook`. In C30.03 add `Shannon.InformationDensity`. Both module names have prefix `LeanInfoTheory.`. The full Shannon umbrella imports the new module. Place private regression and downstream callers in `LeanInfoTheory.Examples.ChannelCodingOneShot` and the development Examples aggregate. This gives C31 a single focused import and preserves C29's independent sampling interface.

| Proposed theorem | Contract |
| --- | --- |
| `mean_codebookOutputLaw_error_le` | For a raw `K`, event `A`, and positive budget, `E ≤ B_A`. |
| `exists_mem_support_codebook_error_le` | For the same data, `∃ b ∈ P.support, e_K(b) ≤ B_A`, with the explicit row-event mean in the statement. |
| `exists_blockChannelCode_errorProbability_le_of_acceptanceEvent` | For `W : X → PMF Y`, set `K := PMF.memorylessChannel W n`. Return a code with the support and decoder guarantees below and `c.errorProbability W hM ≤ B_A`. |
| `exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold` | For the same `W` and any real `t`, use the literal C27 event `A`. Return the same form of witness with `c.errorProbability W hM ≤ J(Aᶜ) + ((M : ℝ) - 1) * Real.exp (-t)`. |

The two raw statements use `[Fintype X]`, as required by C29's book law, and allow arbitrary `Y`. Only books and message indices need enumeration. The two released-error statements also take `[Fintype Y]`, matching the released channel and error. In both, the conclusion has the following shape, with `r` expanded to the specified bound.

```lean
∃ c : BlockChannelCode X Y n M,
  c.encoder ∈ (PMF.iid q M).support ∧
  c = BlockChannelCode.ofAcceptanceEvent c.encoder A hM ∧
  c.errorProbability W hM ≤ r
```

The equality records which decoder the witness uses. A caller can discard it and the support conjunct to obtain a plain code-existence result. At the threshold, relax the bound on the event theorem's very same witness. Keep per-message inclusion, event transports, finite-mass conversion, change of averaging order, and the finite-minimum argument private. No public error definition, extra sampling structure, simp attribute, or change to a released signature is proposed.

## Ordered steps and acceptance criteria

### C30.01 — Bound the uniform ensemble error for a raw channel

- **C30.01-ENSEMBLE** — Deliver the raw-channel ensemble theorem at all natural lengths. For fixed `m`, prove that `D m` is contained in the union of the preimage of `Aᶜ` under `z ↦ (z.1 m,z.2)` and the pass preimages under `z ↦ (z.1 j,z.2)` for `j ∈ Finset.univ.erase m`. Apply C29's unique-pass implication in the complement. Use only the sent projection and each distinct-index competing projection, finite subadditivity, and the cardinality `M - 1`. Average the resulting per-index bound over every `m`, using `hM` to normalize the sum. Compile a focused consumer with arbitrary raw rows and event.
- **C30.01-DEPENDENCE** — At length one use three labels, a fair binary output row independent of the input, and acceptance whenever the output bit is true. Send label zero. The two rivals pass together, so each pass event and their intersection have mass `1/2`. On true the least passing label is zero. On false the fallback is zero. Prove that the decoder-error event is empty while the union of the sent miss and the two rival passes is the whole space. Instantiate the ensemble bound for these data. At a singleton budget the competitor finset is empty and its term is zero.
- **C30.01-API** — Qualify the incoming 848 named records and import boundaries before growth. Record reviewed growth for the new owner, theorem and full-umbrella import. Compile from both supported imports, include the private consumer in Examples, and check the root boundary.

**Proof route.** Use `MeasureTheory.measure_union_le` and `MeasureTheory.measure_biUnion_finset_le` for the PMF outer measure, then `PMF.toOuterMeasure_map_apply` with C29's two projection equalities. Every PMF event mass is finite by `PMF.toOuterMeasure_apply` and `PMF.tsum_coe_indicator_ne_top`. Discharge finiteness of the *sum* before applying monotonicity of `ENNReal.toReal` and distributing it over the finite sum. Reduce the erased finset's cardinality as a natural number, then cast using `hM`. If the fallback succeeds on a miss, or a later passing label loses to the sent label, the inclusion can be strict.

### C30.02 — Extract a supported deterministic book for a raw channel

- **C30.02-BOOK** — Prove the supported-book theorem for arbitrary `q,K,A`. Show privately that `E = ∑ b : Book, (P b).toReal * e_K(b)`. Obtain a supported book with error at most this mean, then apply C30.01. A focused caller must retain the witness's actual membership in `(PMF.iid q M).support` together with its row-error bound.
- **C30.02-SPARSE** — At length two, give words `00` and `11` masses `3/4` and `1/4`. Draw one word independently for each of two labels, use the identity channel and accept word equality. The collision probability and event bound are both `5/8`. A collision has uniform-message error `1/2`, and a book with distinct words has error zero, so the sampling-weighted mean is `5/16`. Apply the private selection lemma used in C30.02-BOOK before relaxing to the event bound. From its witness's support and error at most `5/16`, deduce that both words lie in `{00,11}`, the two labels have distinct words, and this book has error zero. The public bound `5/8` alone admits every supported book.

**Proof route.** Unfold the book/output joint into a bind over books and a map tagging each output with its book. Apply `PMF.toOuterMeasure_bind_apply` and `PMF.toOuterMeasure_map_apply`, turn the sum over finite books into a finite real weighted sum, and exchange the message and book sums. This integrates a row event directly and permits arbitrary output types. For selection, use `Finset.exists_min_image` on the nonempty `P.supportFinset`. Multiply the supported minimum inequality by each nonnegative book mass, drop zero-weight terms outside support, and sum using `P.sum_toReal`. For the sparse consumer, unfold the iid law over labels and use `PMF.mem_support_finiteProduct_iff`. The focused Examples module can use the pinned Batteries `open private` command scoped to the one example that tests the selector. Check the public existential separately through an ordinary focused import.

### C30.03 — Return an actual code and specialize the literal threshold

- **C30.03-RELEASED** — Set `K := PMF.memorylessChannel W n`. For every fixed book `b`, prove privately that `e_K(b) = (C_A b).errorProbability W hM`. Expand the released error with `BlockChannelCode.errorProbability_eq_sum` and each row event with `PMF.toOuterMeasure_toReal_eq_sum`. The encoder of `C_A b` is definitionally `b`. Apply C30.02 once and return `C_A b` for that witness, carrying its support and row-error bound through the equality at the original `n,M,W,hM`. Compile a direct code caller. Independently, use C29's `mean_codebookOutputLaw_error_eq_mean_errorProbability` with C30.01 to check the bound on the expected released error. Check the released `M = 1` and `n = 0` formulas, including empty input/output alphabets at zero length.
- **C30.03-THRESHOLD** — Deliver the threshold-code theorem for every `t : ℝ`. Use `indepProd_infoDensityThresholdEvent_le q K t` and nonnegativity of `((M : ℝ) - 1)` to relax the event theorem on the same code. The event is globally `Real.exp t * (Q z).toReal < (J z).toReal`. Equality and zero-joint atoms fail, including when `t < 0`. Preserve the literal miss in the conclusion. Use C27's support-restricted log equivalence and its equality of joint miss masses only in their stated domains.
- **C30.03-CALLER** — Compile a permanent C31-style *finite* caller at `q := PMF.iid p n`, `M := roundedMessageSize n R`, `hM := (roundedMessageSize_bounds n R).1`, and `t := (n : ℝ) * s`. It should obtain an actual code at that budget and its released-error inequality. Match the miss term verbatim to the function in `tendsto_prob_infoDensityThresholdEvent_iid_compl`. The caller must be able to insert any supplied upper bound on that miss by transitivity. C28's limit and the rounded-budget import belong on the consumer side.

### C30.04 — Compute the noisy binary bounds

- **C30.04-BINARY** — At `n = 1, M = 2` instantiate the released `PMF.binarySymmetricChannel` with crossover `1/8`, the uniform input word law and `t = Real.log (3/2)`. Prove C27's event is equality of the two bits. Under `J` each diagonal atom has mass `7/16` and each off-diagonal atom `1/16`. Under `Q` each atom has mass `1/4`. Thus the true miss is `1/8`, the false-match probability is `1/2`, and its relaxation is `2/3`. Compile the event and threshold inequalities on an actual supported length-one code. The right sides evaluate to **5/8** and **19/24**.

Use the word channel `PMF.memorylessChannel W 1`. Evaluate a word at its sole coordinate for the finite arithmetic. In both roadmap examples, take one supported code from the event theorem and derive the relaxed inequality for that code. Also instantiate the public threshold theorem as a caller.

### C30.05 — Show that the ternary guarantee beats constant decoding

- **C30.05-TERNARY** — At `n = 1, M = 2`, take a noiseless channel on `Fin 3`, input masses `3/8,3/8,1/4` and `t = Real.log (5/2)`. Check the strict event on the whole pair space. Its diagonal likelihood ratios are `8/3,8/3,4`. Every off-diagonal pair has zero joint mass. The true miss is zero and `Q(A) = (3/8)^2 + (3/8)^2 + (1/4)^2 = 11/32`. Compile the supported released-error guarantees with right sides **11/32** and **2/5**.
  On the same channel and prior, change only `t` to `Real.log (8/3)`. The two diagonal atoms with input mass `3/8` are exact ties and fail C27's strict test. Only the diagonal atom with input mass `1/4` passes. Prove `J(Aᶜ) = 3/4` and `Q(A) = 1/16` for this event.
- **C30.05-COMPARISON** — For these two uniform messages show that any code whose decoder is constant has released error exactly `1/2`, irrespective of its encoder or constant output label. Use the released per-message formula or uniform message marginal. Prove that `11/32` and `2/5` are each strictly below `1/2`. The binary and ternary existence results assert upper bounds for the selected code's error.

### C30.06 — Qualify the whole chunk and hand off to C31

- **C30.06-VALIDATE** — Map every approved criterion to its source, permanent consumer and applicable checks. Rebuild the C29 laws, C27 event, released code, C28 and rounded-budget interfaces, one-shot owner, focused examples, Shannon and Examples with warnings as errors. Check generated artifacts, documentation, both compiled release contracts, the 848 incoming compiler rows, focused visibility, root and simp boundaries, and the project axiom audit. Run the complete development suite on an authorized clean checkpoint matching the intended source bytes and installed pins. Repeat after any amendment and record what each run qualifies.
- **C30.06-HANDOFF** — Reconcile the living summary, project log, source adaptations in the reference register, step notes and the package-2 effort assessment. Link a maintained `docs/handoffs/chunk-30.md` with exact headers and imports, a compiling C31 caller, the supported code at the supplied indices, the two numerical bounds for each channel, and the literal C28 miss including threshold ties. Illustrate the sampling prior with the ternary example. It charges all three symbols, and an encoder with two message labels can use at most two. Record the remaining C31 choices of input, rate margin, one code per length, and limit argument, along with dispositions for deferred ideas.
- **C30.06-REVIEW** — Complete contextual self-review and separate reassessment. Prepare fresh, source-bound independent review of the cumulative candidate and handoff against *all* approved criteria, including prior finding dispositions and a criterion-to-evidence matrix.

After dispatch, retain the original report, reconcile every finding and assessment, obtain a satisfactory new assessment for any gap, and revalidate corrections. Finish canonical and handoff edits before final capture. Record scoped closure privately and report its reference.

## Validation, authority and intake evidence

C29.05's private completion record closes all five C29 steps at `29571552cf7eb2153d0432f9e204efa5386ca9444d00414698daf95fdf5e5692`. Its final source is `48ea4df5cc3f21d9ad83eaddb317dc52c23d1b6afeac932188faefdf546fed56`. Before this proposal was added, all 370 captured entries, nine dependency pins, protected HEAD, index and status matched the Desktop checkout. The accepted original and its parent reconciliation cover the final review and all fourteen cumulative criteria. The earlier complete-suite pass belongs to clean C29 candidate `0d79586f200258a9e81539a61e11fd5a1d246223`. The living summary and C29 handoff deliberately describe readiness before final capture and direct the reader to that completion record. [C29 handoff](../handoffs/chunk-29.md) · [C29 completion record](../../.lit-review/setup/c29-05-20261110/completion.json)

Preserve the two historical released contracts of 601 and 811 declarations. Against C29's 848-row compiler export compare names, owners, source/compiled kinds, ordered universes, elaborated types and binders. Its SHA-256 is `a5b29627b258e3bec078f2e5ab99d7ebe83f05be5084a6aeeb25bfd73ce9f595`. Preserve incoming focused views except the approved complete-umbrella growth. The root imports `LeanInfoTheory.Probability.Finite` and `LeanInfoTheory.InformationMeasures` directly, with five modules in closure, 92 exports and 94 reviewed simp names across the library. Four additions in one owner would give 852 declarations in 63 supported modules. Counts supplement the named comparisons. [Compatibility guide](../compatibility/README.md)

On each separately selected step use the installed baseline, edit, validation, self-review, reassessment, neutral review, reconciliation, final validation and scoped closure operations. Check source and dependency applicability before reusing evidence. Regenerate the current manifest, website blueprint and declaration index after approved growth, verify the frozen manifest, and run focused builds and the non-mutating development static gate. Use the compiled compatibility and trust checks for public growth. At closeout add the documentation gate and `python scripts/validate_development.py` on the matched clean checkpoint. A concrete checkpoint requiring additional authority must identify its exact source and preservation method. The expensive API-doc gate and publication have their own milestones. [Review protocol](../review-protocol.md) · [Review operations](../review-operations.md)

PW24 §18.1, Corollary 18.4, printed p. 353 (PDF 378), supplies the independent-pair tail. Section 18.2, Theorem 18.5 and its proof, printed pp. 354–355 (PDF 379–380), supplies independent whole-word draws, the per-rival comparison, the union bound, and selection of a realization. Display (18.10) uses weak acceptance, a unique match and an erasure. Its estimate uses strict pass and closed miss. C30 consistently uses C27's global strict comparison and C29's total decoder. PW24 §18.3, Theorem 18.6's proof, printed p. 356 (PDF 381), uses first-match order for a sharper estimate. CT91 §8.5, (8.28)–(8.32), printed pp. 193–194 (PDF 215–216), fixes uniform code error. Section 8.7, proof of Theorem 8.7.1, printed pp. 199–202 (PDF 221–224), averages over books and messages and fixes a book before expurgation. Here `q` can have dependent letters, all labels survive selection, and the witness belongs to actual sampling support. The registered PDFs and key displays were checked at planning intake. [Reference register](../references.md#release-3-planning-locators)

At C31's rounded budget, `roundedMessageSize_bounds` gives `(M : ℝ) - 1 < exp (n * R)`. At `t = n * s`, this is the rate margin that bounds the second term by `exp (-n * (s - R))`. C28 controls the first term for `s < mutualInfo (PMF.channelJoint p W)`. C31 owns the choice of `R < s`, a single positive-budget family, vanishing error and operational capacity. Defer an earlier-rival or dependence-testing refinement until a consumer needs a tighter finite bound. No material change to the roadmap contract is proposed. Any change to the guarantees, witness support, public assumptions, original indices, or acceptance criteria requires a lead decision. [C30 and C31 map](release-3-chunk-map.md#c30-one-shot-achievability)

## Formal plan-review criteria

- **C30-PLAN-ENSEMBLE** — Assess the strict-inclusion example, same-output competing laws, raw-channel generality, averaging, supported extraction at the weighted mean, edge cases and source adaptation.
- **C30-PLAN-CODE** — Assess the fixed-book error identity, transfer of the same witness at the supplied length and budget, strict C27 event including a positive-mass tie, both numerical examples and literal finite C31 caller.
- **C30-PLAN-SCOPE** — Assess owner and public/private boundary, retained interfaces, actionable step criteria, validation, independent cumulative review, handoff and C31 ownership.

The lead requests formal plan review separately. Approval of an exact revision and selection of one step authorize only that step and its supervised review cycle. Stop after its scoped result.
