# C29 — Random codebooks and a total decoder

<!-- lit-review-status:start -->
**Plan status:** Approved, revision 2. The lead accepted the presented revision with SHA-256 `ec9f66f94eec6d15a990fa46aabffc7eee3b1206ff20ee4ed5ade9e61ce12091` and selected C29.01 with its review process on 10 November 2026. The independent review of revision 1 remains attributed to that revision. Subsequent steps require their own selection.
<!-- lit-review-status:end -->

## Experiment and public contracts

Fix `n M : ℕ`. In the formulas below, `U = Fin n → X`, `V = Fin n → Y`, and `Book = Fin M → U` are notation for this plan. Let `q : PMF U` be any input-word law and `K : U → PMF V` any raw block channel. Write `P = PMF.iid q M`. Its product index is the message index. A draw from `q` is an entire word and may have arbitrary dependence among its letters. Books retain the original message indices, including indices carrying equal words.

Propose **six public declarations** in the focused module `LeanInfoTheory.Shannon.RandomCodebook`, in the `LeanInfoTheory.Shannon` namespace and its existing `BlockChannelCode` namespace as indicated. The following are schematic Lean headers. The definitions of `P`, `L m`, `C b` and `Err m` in this plan fix the meanings of the equations.

1. `codebookOutputLaw [Fintype X] (q : PMF U) (K : U → PMF V) (m : Fin M) : PMF (Book × V)` is `PMF.channelJoint (PMF.iid q M) (fun b => K (b m))`. Write `L m` for this law. The atom at `(b,y)` is `P b * K (b m) y`.
2. `codebookOutputLaw_map_sentOutput q K m` proves `(L m).map (fun z => (z.1 m, z.2)) = PMF.channelJoint q K`. Write `J` for the right side.
3. `codebookOutputLaw_map_competingOutput q K m j (hjm : j ≠ m)` proves `(L m).map (fun z => (z.1 j, z.2)) = indepProd q (q.bind K)`. Write `Q` for the right side. Every competitor sees the same sampled output. C30 needs only the individual pair laws and can allow dependence among competing pass events.
4. `BlockChannelCode.ofAcceptanceEvent (b : Book) (A : Set (U × V)) (hM : 1 ≤ M) : BlockChannelCode X Y n M` uses `b` as its encoder. On receiving `y`, it returns the **least** index `i` such that `(b i,y) ∈ A`, or the valid index `⟨0,hM⟩` when the passing set is empty. Write `C b` for this code. Use classical membership internally so callers can supply any set. This is a mathematical, total deterministic function, including on outputs of zero mass.
5. `BlockChannelCode.decoder_ofAcceptanceEvent_eq_of_unique` proves, for every `b, A, hM, m, y`, that `(b m,y) ∈ A` and `∀ j, j ≠ m → (b j,y) ∉ A` imply `(C b).decoder y = m`. The implication gives C30 a sufficient condition for success. A fallback can decode correctly even when the sent index fails.
6. `mean_codebookOutputLaw_error_eq_mean_errorProbability [Fintype X] [Fintype Y] (q : PMF U) (W : X → PMF Y) (A : Set (U × V)) (hM : 1 ≤ M)` identifies the two real probabilities below. Here `K = PMF.memorylessChannel W n` and `Err m = {z : Book × V | (C z.1).decoder z.2 ≠ m}`.

   ```lean
   (1 / (M : ℝ)) * (∑ m : Fin M, ((L m).toOuterMeasure (Err m)).toReal) =
     ∑ b : Book, (P b).toReal * (C b).errorProbability W hM
   ```

The raw projection laws require only the input enumeration used by the existing finite product. Their fixed `m : Fin M` already witnesses positivity. The constructor and its success theorem need neither alphabet to have a finiteness instance. The final finite sum enumerates books and uses the released error at the given single-letter channel `W`, original length `n` and positive budget `M`. All natural lengths, sparse input laws, repeated words and arbitrary deterministic events are in scope. At positive lengths the supplied PMFs already account for any necessary inhabitance. At zero length the word types have their unique empty function.

## Ownership and proof guidance

The new owner imports `Shannon.ChannelCode` in C29.01. That focused import already brings in `Probability.Iid`, `Probability.FiniteProduct`, `Probability.FiniteChannel` and `Shannon.SemanticBridge.Product`. In C29.04 add the focused `Probability.TotalVariation` import for the existing `PMF.toOuterMeasure_toReal_eq_sum`. Prefix the module names here with `LeanInfoTheory.`. Expose the owner through the complete `LeanInfoTheory.Shannon` umbrella. Keep `Word`, `Book`, the book prior alias, coordinate transports, filtered passing set, proof of the minimum rule, event expansions and sum interchanges local or private. Use the released code pair and error directly. Alphabet-generic sampling, a bundled experiment, a separate expectation API and additional public aliases can be reconsidered if a later consumer needs them. Use the required EPFL/MIL header on new Lean files.

Permanent private examples belong in `LeanInfoTheory.Examples.RandomCodebook` and enter the development `Examples` aggregate. The literal-threshold caller adds the focused `Shannon.InformationDensity` import in the example. The mathematical owner accepts a set directly. C26 randomized tests and C28 asymptotics supply no premise or import to the owner.

- For the sent law, expand the channel joint and commute the projection with bind/map. The resulting law is the channel joint with input `P.map (fun b => b m)`. Unfold `PMF.iid` and apply `PMF.finiteProduct_map_eval`.
- For the competing law, let `μ := P.map (fun b => (b j, b m))`. The private bind/map calculation has the following endpoints.

  ```lean
  (L m).map (fun z => (z.1 j, z.2)) =
    (PMF.channelExtension μ K).map (fun s => (s.1, s.2.2))
  ```

  The extended triple is `(b j, (b m, y))`. This transport works even when the indices coincide. Use `j ≠ m` at the next rewrite, where `PMF.finiteProduct_map_pair` identifies `μ` with `PMF.channelJoint q (fun _ => q)`. Applying `PMF.channelExtension_map_endpoints` passes the **sent** word through `K` and gives the constant row `q.bind K`. Its joint with `q` is definitionally `indepProd q (q.bind K)`. A direct atom proof can instead sum over the finite books at a fixed output. Both raw projection statements quantify over arbitrary `Y`.
- For the decoder, filter `Finset.univ` by passing at `y`. Use `Finset.min'` on a nonempty passing set. Membership of the minimum proves success from uniqueness. When `m` passes, it wins exactly when every strictly earlier index fails. The public unique-pass theorem gives C30 its sufficient condition directly.
- For the equality, use the finite real event-mass sum and `PMF.channelJoint_apply` on the left. Separate the mass of the book and the conditional row, interchange the finite message/book/output sums, and use `BlockChannelCode.errorProbability_eq_sum` for each realized book. The encoder of `C b` is definitionally `b`. Uniform averaging is explicit because the index order and fallback can favor particular messages.

## Numerical checks for the two averaging laws

Use one private Boolean prior with masses `3/4, 1/4`. In both checks `M = 2`, the encoder is the sampled book and the experiment uses the actual `PMF.memorylessChannel W n`. The checks reuse this prior in different word laws. The uniform fixed-book example in C29.02 separately exhibits the effect of fixing a book.

**One noisy letter.** At `n = 1`, identify each word by its bit. Let `W 0` output 0 surely and `W 1` output a fair bit. The output marginal has masses `7/8, 1/8`. For sent index 0 and competing index 1, the pair of bit values `(0,1)` has sent-pair mass zero and competing-pair mass `(3/4)(1/8) = 3/32`. These are projections of the same `L 0`. For the code, accept equality of the words.

| Ordered book | Book mass | Error sending index 0 | Error sending index 1 | Released uniform-message error |
| --- | ---: | ---: | ---: | ---: |
| `(0,0)` | 9/16 | 0 | 1 | 1/2 |
| `(0,1)` | 3/16 | 0 | 1/2 | 1/4 |
| `(1,0)` | 3/16 | 1/2 | 0 | 1/4 |
| `(1,1)` | 1/16 | 0 | 1 | 1/2 |

The fixed-index ensemble errors are `3/32` and `23/32`. Their uniform mean and the book-weighted mean of released errors are both `13/32`. Giving the four books equal weight would give `3/8`.

**Two dependent letters.** At `n = 2`, draw one biased bit and repeat it in both positions. This gives `q(00) = 3/4`, `q(11) = 1/4` and zero mass on mixed words. Use the identity channel and the literal set `infoDensityThresholdEvent q (PMF.memorylessChannel W 2) 0`. Its strict test reduces to `q(x)^2 < q(x)` on the two supported diagonal atoms. Every other pair has zero joint mass, so the passing pairs are exactly `(00,00)` and `(11,11)`. A supported book with distinct entries has released error zero. A collision has released error `1/2` and occurs with probability `(3/4)^2 + (1/4)^2 = 5/8`. The expected released error is `5/16`.

## Ordered steps and acceptance criteria

### C29.01 — The book/output experiment and sent pair

- **C29.01-LAW** — Deliver the specified `codebookOutputLaw` and its sent-word pushforward under the full book/output experiment. Compile a permanent caller rewriting a sent-pair event probability under this experiment to its probability under `J`, for an arbitrary word law, raw channel and set.
- **C29.01-API** — Qualify the C28 input, reviewed new owner and full-umbrella import before public growth. Check the expected names from the focused and complete imports, current generated artifacts, incoming named compiler records and the lightweight root.

### C29.02 — One competing pair and the fixed-book distinction

- **C29.02-LAW** — Prove the specified competing-pair pushforward for every `j ≠ m`. Compile a permanent caller transporting a competing acceptance event under that same `L m` to `Q` for an arbitrary output alphabet. Instantiate it at `n = 1`, `M = 2`, `Y = ℕ`, sent index 0 and competing index 1, with an arbitrary raw row law and event. The output row always uses the sent word.
- **C29.02-BINARY** — At `n = 1` and `M = 2`, use the uniform binary word law and noiseless channel. With the fixed book `(0,1)` and message 0, map the row output to the competing word/output pair and check it is pure at `(1,0)`. Under `L 0`, evaluate the word coordinates to bits and check the competing pair is uniform on all four pairs. The same atom has masses one and one quarter respectively. Use the actual ensemble projection and the fixed row for the two calculations.
- **C29.02-MARGINAL** — For the asymmetric channel at length one, compute the actual output marginal `q.bind K` and use the two public pushforwards to check the sent and competing masses of `(0,1)` under the experiment. Keep this prior and channel available to C29.04 in the private example module.

### C29.03 — The event decoder at the caller's length and budget

- **C29.03-CODE** — Construct the specified code and prove the unique-pass success implication. A focused caller checks the encoder is the original book and consumes the theorem with the literal set `infoDensityThresholdEvent q K t` at any real `t`. C27's strict mass inequality governs ties and null atoms on the entire pair space.
- **C29.03-CASES** — Check three behaviors in the focused examples. With book `(0,1,1)`, output 1 and equality acceptance, both duplicate-word indices pass and index 1 wins. With an empty passing set the answer is index 0, including for a transmitted nonzero index. With `M = 1` the decoder always returns the sole index for any event, any output and any book. Use the order on message indices and keep collisions legal.

### C29.04 — Uniform ensemble error equals expected released error

- **C29.04-ERROR** — Prove the displayed real equality with arbitrary `q`, the original `n,M,W,hM`, and the released `BlockChannelCode.errorProbability`. The left side measures the decoder of the sampled book on the output coupled to that book. The right side weights each realized code's error by its book mass.
- **C29.04-CALLER** — Compile a permanent C30-style consumer with `A = infoDensityThresholdEvent q (PMF.memorylessChannel W n) t` and arbitrary `r : ℝ`. From `∀ m : Fin M, ((L m).toOuterMeasure (Err m)).toReal ≤ r`, derive `∑ b : Book, (P b).toReal * (C b).errorProbability W hM ≤ r`. Sum the per-message bounds and use `hM` to normalize the sum of the constant `r`, then apply the public equality. C30 supplies the per-message estimate. Exercise the singleton and empty-length formulas using `BlockChannelCode.errorProbability_one` and `BlockChannelCode.errorProbability_zero`.
- **C29.04-WEIGHTS** — Reuse C29.02's asymmetric prior and channel with equality acceptance. Evaluate the two fixed-index ensemble failure probabilities as `3/32, 23/32`. Independently weight the four realized codes' released errors from the table, and instantiate the public equality at these data. Both averaging orders must give `13/32`.
- **C29.04-WORD** — Instantiate the literal strict event with the repeated-bit word law and the noiseless channel at length two. In the private consumer use the collision calculation above and the released error equality to check the value `5/16` at the original length and budget.

### C29.05 — Cumulative validation, independent review and C30 handoff

- **C29.05-VALIDATE** — Map every approved criterion to its producer, focused consumer and applicable checks. Rebuild the new owner and examples, the relevant product/channel and C23/C27 producers, the C28 focused consumer, Shannon and Examples with warnings as errors. Check static/generated artifacts, documentation, both released compiled baselines, all 842 incoming named records, focused visibility, full/root boundaries, reviewed simp sets and all project axioms. Run the full development suite on a separately authorized, clean candidate matching the final main source bytes and dependency pins. Repeat after amendment. Attribute prior and fresh checks to their actual source.
- **C29.05-HANDOFF** — Reconcile the living summary, project log, reference register and step notes. Link a maintained `docs/handoffs/chunk-29.md` giving exact signatures and imports, both projections from the same experiment, their output-alphabet assumptions, the fixed-book and weighted examples, decoder/fallback semantics, and the compiling per-message-to-expected-error caller. Document why only an earlier passing index can defeat a passing sent index. Identify C30's required event inclusion, union bound and supported deterministic book extraction, its finite fixtures, and C31's later choice of iid input and below-MI threshold. Record outstanding decisions and deferred items.
- **C29.05-REVIEW** — Complete contextual self-review and separate reassessment. Prepare a fresh, neutral, source-bound cumulative review covering all criteria for the same bound reviewer, with the candidate, handoff, prior findings and criterion-to-evidence matrix available.

After dispatch, retain the original report, reconcile every finding and criterion, obtain a satisfactory new assessment for any gap, and recheck review and validation applicability after corrections. Finish canonical and handoff edits before final capture. Record supported closure and its reference privately, report it to the lead and stop.

## Retention and step workflow

C28's five steps have durable closure records. C28.05 closed at `d2698eb090e0de7f77e77231a1d6742fe1bada0223a5454a892d0cbd2335f46d`. Its handoff and living-summary wording were written before final capture and point to that completion record. Before adding this proposal, a read-only check matched the 367-entry final snapshot `f37ac0905ebc133ef4dab8e258b3a5a1c67eead221b507fcfd105345e4d1e5b2`, protected Git state, 151 validation inputs and nine installed pins. C28's full-suite pass belongs to its clean candidate `849bd93d1224c3e0569bdbb208fa27a705772214`. The main checkout has pre-existing work at `2eb80d0e746688511618aaefc2624ffa4ae88f6e`. [C27 handoff](../handoffs/chunk-27.md) · [C28 handoff](../handoffs/chunk-28.md)

Retain the 601 v0.1.0 and 811 v0.2.0 declarations under their separate released contracts. Compare C28's 842 compiler records by name, owner, kind, ordered universes and elaborated type, including binders. Baseline producer and boundary digests are in `.lit-review/setup/c28-05-20261110/main-named-retention.json`. The 842-name export has SHA-256 `3c4807bc56aaca9163a88e97d7619d5356c67b641cae33d5fb8b59db4e6f7193`. Preserve the 61 incoming supported modules and their focused visibility, including C27's seven and C28's three results. Review only the identified import and declaration growth. The root directly imports `LeanInfoTheory.Probability.Finite` and `LeanInfoTheory.InformationMeasures`, with a five-module closure and 92 exports. Preserve all 94 reviewed simp names. The six proposed additions imply 848 declarations in 62 supported modules. Counts supplement the named and boundary checks.

Each separately selected step gets a baseline capture, owned edits, focused builds, applicable static/compiled checks, contextual self-review, separate reassessment, independent review, reconciliation, final validation and scoped closure. Use `python scripts/validate_release.py focused <targets>` and `python scripts/validate_development.py static` on the working source. Regenerate the current API manifest, website blueprint and declaration index after approved growth and verify the frozen manifest. Check the development `compatibility` and `trust` gates and the C28 named comparison for public changes. Closeout adds `python scripts/validate_release.py documentation` and the complete `python scripts/validate_development.py` at the exact clean candidate. A concrete clean checkpoint requires its own authority if needed. API-doc generation and publication are separate milestones. [Compatibility guide](../compatibility/README.md) · [Review protocol](../review-protocol.md) · [Review operations](../review-operations.md)

## Registered sources and later ownership

PW24 §18.2, proof of Theorem 18.5, printed pp. 354–355 (PDF 379–380), samples independent codewords from a given input law, averages over books and identifies the competing word's independence from the output in step (a). Its display (18.10) uses weak acceptance, uniqueness and an external erasure symbol. The proof of Theorem 18.6 in §18.3, printed p. 356 (PDF 381), gives a least-passing-index precedent. C29 uses a supplied deterministic set, C27's strict mass comparison in its threshold caller, and a fallback in `Fin M`. A threshold tie is a failed test even when the decoder happens to return the sent message.

CT91 §8.5, (8.28)–(8.32), printed pp. 193–194 (PDF 215–216), supplies the code and uniform average of per-message errors. The proof of Theorem 8.7.1 in §8.7, printed pp. 199–201 (PDF 221–223), distinguishes the realized code and the random experiment. Its coordinate-iid words and jointly typical test are specializations. The local reference check matched the registered PW24 and CT91 file hashes and inspected these passages as text. [Reference register](../references.md#release-3-planning-locators)

C30 will bound the uniform error by `J(Aᶜ) + (M−1) Q(A)`, extract a supported deterministic book and apply C27's independent-law tail. Its binary symmetric and ternary numerical checks stay there. C31 will specialize `q = PMF.iid p n`, use C28 on the literal miss at `t = (n : ℝ) * s`, and construct the achievable code family. [Release 3 map](release-3-chunk-map.md#c29-random-codebooks-and-a-total-decoder)

First-match order leaves a possible C30 refinement. A sent index `m` has `m.val` strictly earlier competitors. The pass hypothesis enters the pointwise decoder argument. The count itself is averaged over all transmitted indices with their original uniform weights, giving `((M : ℝ) - 1) / 2`. Record this counting observation in the handoff. A sharper one-shot inequality would be a separate C30 decision.

## Formal plan-review criteria

- **C29-PLAN-LAWS** — Assess the whole-experiment state, two ordered projections, private endpoint calculation, arbitrary output type, reference adaptation, fixed-book witness and asymmetric output marginal.
- **C29-PLAN-CODE** — Assess the total first-match rule, unique-pass implication, edge cases, literal strict event, per-message bound caller and released-error equality at the original types, including the noisy and correlated-word numerical checks.
- **C29-PLAN-BOUNDARY** — Assess public names and private machinery, import and retention checks, focused consumers, cumulative validation, review and the C30/C31 handoff. Formal plan review, approval of the exact plan and selection of an execution step are separate actions.
