# C33 — Direct lossless source–channel separation

<!-- lit-review-status:start -->
**Plan status:** Approved revision 2. The lead selected C33.01 with its review on 14 November 2026. The bound reviewer assessed revision 1. Each later step awaits separate selection.
<!-- lit-review-status:end -->

## The theorem and its interface

For a finite iid source with law `p` and a finite memoryless channel with one-letter row `W`, use one channel use per source symbol. If `entropy p < channelCapacity W`, there is one deterministic encoder family and one deterministic reconstruction family whose block error tends to zero. Both maps are total at every natural length. The entropy, capacity and rates use nats. C34 owns the converse for arbitrary joint codes. Equality is outside the claim.

In the displays, `Word T n` stands for `Fin n → T`. It is notation for this plan. Give the source, input and output types `S, X, Y` independent universes. The proposed public declarations are in `LeanInfoTheory.Shannon`.

**The shared experiment.** For `[Fintype S] [Fintype Y]`, take `p : PMF S`, `W : X → PMF Y`, `n : ℕ` and arbitrary total maps `E : Word S n → Word X n` and `D : Word Y n → Word S n`. Define

```lean
sourceChannelErrorProbability p W n E D : ℝ :=
  decodingErrorProbability
    (PMF.channelJoint (PMF.iid p n) (fun s => PMF.memorylessChannel W n (E s))) D
```

Thus the coordinates are the original source word and its actual channel output, in that order. A code in the theorem is simply a pair of such maps. Message sets enter only in the construction. Evaluation needs neither a finite input enumeration nor an input inhabitant. The direct theorem additionally takes `[Fintype X] [Nonempty X]`, as C31 does. Zero-probability words, collisions, off-support outputs, singleton sources and length zero are admitted.

**The finite public bound.** Fix `a : BlockSourceCode S n K` and `b : BlockChannelCode X Y n K`. Use the abbreviations `q = PMF.iid p n` and `π = q.map a.encoder`. Propose

```lean
sourceChannelErrorProbability_comp_le (p : PMF S) (W : X → PMF Y)
    (a : BlockSourceCode S n K) (b : BlockChannelCode X Y n K) :
  sourceChannelErrorProbability p W n
      (b.encoder ∘ a.encoder) (a.decoder ∘ b.decoder) ≤
    a.errorProbability (PMF.iid p n) +
      b.errorProbabilityWithPrior W ((PMF.iid p n).map a.encoder)
```

The right side is source error plus the actual weighted row error at the shared budget. For `hK : 1 ≤ K`, C32 immediately bounds the channel term by `b.maximalErrorProbability W hK`. C33.02 also validates the corresponding inequality on the original embedded labels when `b` was obtained by restriction. Giving two codes at a common budget keeps the public inequality free of an inverse choice, a positivity proof and rate assumptions.

**The direct public theorem.** Under the three `Fintype` assumptions and `[Nonempty X]`, propose

```lean
exists_sourceChannelCode_tendsto_errorProbability_zero
    (p : PMF S) (W : X → PMF Y) (h : entropy p < channelCapacity W) :
  ∃ (E : ∀ n : ℕ, Word S n → Word X n) (D : ∀ n : ℕ, Word Y n → Word S n),
    Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n))
      atTop (nhds 0)
```

**Ownership.** The proposed finite owner `LeanInfoTheory.Shannon.SourceChannelCode` directly imports `Shannon.SourceCoding` and `Shannon.ChannelCodeExpurgation` under the full project prefix. It owns the shared error and finite inequality. C34 can import it without the direct theorem, random coding or asymptotic source coding. The proposed `LeanInfoTheory.Shannon.SourceChannelSeparation` directly imports the finite owner, `Shannon.SourceCodingAsymptotic`, `Shannon.OperationalCapacity` and `Shannon.OperationalExpurgation`. It owns the direct theorem. Export both owners from the full Shannon umbrella. Keep any indicator rearrangement, restricted-maximum comparison, budget reflection and prefix construction local or private. The three public additions need no new simp attributes. Development examples live outside both public umbrellas.

## Verified inputs

- The released `exists_blockSourceCode_tendsto_errorProbability_zero p hrs` returns positive budgets `K n` and one family `a n` witnessing both vanishing iid source error and the eventual **upper** bound `codeRate n (K n) ≤ r_s`. The theorem exposes neither a prescribed budget sequence nor an all-length rate bound. [SourceCodingAsymptotic](../../LeanInfoTheory/Shannon/SourceCodingAsymptotic.lean)
- C31's supported `isAchievableRate_of_lt_channelCapacity W hnonneg hlt` returns `IsAchievableRate W r_c`. Open it once for positive `M n`, the deterministic family `c n`, vanishing **uniform-message** error and an eventual lower rate bound for every positive tolerance on that family. [OperationalCapacity](../../LeanInfoTheory/Shannon/OperationalCapacity.lean)
- C32's supported finite interface includes `errorProbabilityWithPrior_eq_sum`, the prior-to-maximum bound, `restrictMessages`, its decoder-preservation and row-error theorems, `maximalErrorProbability_le_iff`, and `exists_expurgated_restrictions` for exact positive budgets in the full good set. Its supported `exists_expurgated_family_of_tendsto_errorProbability` takes the components of the C31 witness. It gives one positive full retained family `L,hL,B`, a maximal-error limit and every eventual floor on `L`, already accounting for the expurgation loss. [C32 finite owner](../../LeanInfoTheory/Shannon/ChannelCodeExpurgation.lean) · [C32 operational owner](../../LeanInfoTheory/Shannon/OperationalExpurgation.lean) · [All sixteen names](../handoffs/chunk-32.md)
- The anonymous caller in `Examples.OperationalExpurgation` assumes `∀ n, K n ≤ L n`. It constructs the exact-budget family first, derives maximum monotonicity under further restriction, and then proves convergence under any sequence of priors. The finite example derives a transported-prior comparison too. Neither derived comparison nor the example's family conclusion is a named supported theorem. C33 will use the supported restriction and row bounds directly. [Family caller](../../LeanInfoTheory/Examples/OperationalExpurgation.lean) · [Finite caller](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean)
- At intake, the private C32.06 completion record, durable closure and projection, original report and reconciliation, fifteen cumulative assessments, and clean qualification agree. All 388 captured project files, the Git observation, configuration and installed dependency records matched. Closure `9f5f840e2d1fe3f2891c5aa0c3d70c73c12babce4a111c2d30fa121084cb5ccd` closed C32.01–06. Its complete suite passed at clean checkpoint `aab42d0214007adb546cdfc48edbbd1b13f78138`. The C32 baseline has 873 supported names in 66 modules, two direct root imports, five reachable modules, 92 root exports and 94 reviewed simp names. The clean run belongs to C32. C33 planning checked the incoming interfaces with a read-only Lean signature lookup. [C32 handoff](../handoffs/chunk-32.md) · [Programme contracts for C33 and C34](release-3-chunk-map.md#c33-lossless-source-channel-separation-construction)

**Registered sources.** CT91 (1991), §8.13, Theorem 8.13.1, printed pp. 215–217 (PDF 237–239), gives the source-word and conditional-output weighting in (8.142) and the direct construction in (8.143)–(8.147). For PW24 (16 August 2024), §19.7, cite the statement of Theorem 19.22 and its displayed achievability estimate on printed p. 393 (PDF 418). That estimate uses maximal channel error after compression. The prose immediately following it refers to the weak converse. For the source producer see PW24 §11.1, Corollary 11.3, p. 214. For channel coding see PW24 §19.2, Theorem 19.9, p. 377, and CT91 §§8.5, 8.7, pp. 193–194 and 202, for sent-label error and expurgation. Intake matched both registered PDF hashes and inspected the relevant text. C33 specializes to finite iid source words, equal source and channel blocklengths, nats, positive integer component budgets and total decoders. The pushforward-prior inequality and the all-length witness are explicit project contracts. The strict entropy comparison also covers zero entropy without taking a ratio. [Reference register](../references.md)

## Proposed steps and acceptance criteria

### C33.01 — Define the common block reconstruction error

- **C33.01-LAW** — Introduce `sourceChannelErrorProbability` with the arbitrary maps and joint PMF displayed above. In a focused consumer identify the atom at `(s,y)` as `q s * PMF.memorylessChannel W n (E s) y`, its first marginal as `q`, and the error as the sum of these real atom masses on `D y ≠ s`. Reuse `PMF.channelJoint_apply`, `PMF.channelJoint_map_fst` and `decodingErrorProbability_eq_sum`. Check that `condEntropy_fano_weak` on this joint with decoder `D` exposes the *same* error by unfolding, for arbitrary `E,D`.
- **C33.01-PROJECTION** — In a compiling development example, set `q := PMF.iid p n`, `Wn := PMF.memorylessChannel W n` and `J := PMF.channelJoint q (fun s => Wn (E s))`. For every total encoder `E`, prove the exact PMF identity

  ```lean
  J.map (fun z => (E z.1, z.2)) = PMF.channelJoint (q.map E) Wn
  ```

  This check uses the same sampled output on both sides and allows arbitrary collisions of source words, with no extra assumptions on `X`. One proof route unfolds `PMF.channelJoint`, moves the outer map through the bind with `PMF.map_bind` and composes the two maps on each row with `PMF.map_comp`. On the right, `PMF.bind_map` expands the pushforward source prior. The right side is exactly the input/output joint in the existing block-capacity bound when instantiated at `q.map E` under that theorem’s finite-channel assumptions. Link the compiled example from the C34 handoff. [Joint-law definition](../../LeanInfoTheory/Probability/FiniteChannel.lean) · [Block-capacity bound](../../LeanInfoTheory/Shannon/ProductChannelCapacity.lean)
- **C33.01-BOUNDARY** — Check the error is in `[0,1]` by existing decoding-error bounds. At `n=0` prove it is zero for arbitrary maps because any two source words are equal. Exercise a many-to-one encoder and a total decoder, including outputs of zero mass. A singleton source has error zero at every length. Use separate source, input and output types. Build the new owner, finite consumer and affected umbrellas and verify their import boundaries.

### C33.02 — Prove the finite composition inequality

- **C33.02-PRIOR** — Prove `sourceChannelErrorProbability_comp_le` before any limit argument. At a joint atom `(s,y)`, let `j = a.encoder s`. Failure of the composite implies `a.decoder j ≠ s ∨ b.decoder y ≠ j`. Multiply the indicator bound by the nonnegative actual atom mass and sum. Summing out the normalized row gives exactly `a.errorProbability q` for the first event via the released source failure semantics. The second event has mass `∑ s, (q s).toReal * b.messageErrorProbability W (a.encoder s)`. Regroup by encoder value, including collisions, to obtain `∑ j, (π j).toReal * b.messageErrorProbability W j = b.errorProbabilityWithPrior W π`. One route expands `PMF.map` with `PMF.bind_toReal_apply` and interchanges finite sums. Null or unused labels contribute zero without division. Both failures may occur on the same atom.
- **C33.02-RESTRICT** — Compile a generic finite caller with `C : BlockChannelCode X Y n L`, `i : Fin K ↪ Fin L`, `j₀ : Fin K`, and `b := C.restrictMessages i j₀`. Trace its encoder to `C.encoder (i j)` and its total decoder to the inverse on `Set.range i`, returning `j₀` for discarded decoder outputs. Derive source error plus the prior error of `b`, then source error plus its maximum for a positive budget. Also derive source error plus `∑ j, (π j).toReal * C.messageErrorProbability W (i j)` and the resulting bound by the maximum on the embedded labels, hence by the full positive-budget maximum of `C`. Use C32 rowwise monotonicity and normalization of `π`. This also gives `maximalError(b) ≤ maximalError(C)` by the two maximum characterizations. Check the equal-budget case. For a proper embedding, retain old labels `0,1` in C32’s length-one collision code. Verify maximum `0` over the two embedded rows and maximum `1` over all four original rows. On the constant output word `2`, the old decoder returns discarded label `2`, so the restricted decoder must return `j₀`. This output has zero mass from both retained inputs and exercises totality. Keep these checks in the development consumer. [C32 collision fixture](../../LeanInfoTheory/Examples/ChannelCodeExpurgation.lean)

### C33.03 — Test the induced prior and a strict composition bound

- **C33.03-COLLISION** — In a development-only consumer reuse C32's private `collision` fixture and its proved row/mean calculations with scoped `open private`. It sends the four indices as `(0,1,2,2)` over the noiseless ternary channel at length one. Use `S = Fin 4`, `p = PMF.pure 3`, and the identity source code under the length-one equivalence, encoding by `s 0` and decoding by the constant word. Prove that the actual source-induced prior is `PMF.pure 3`, source error is `0`, the released uniform channel error is `1/4`, and channel error at that prior is `1`. Compute reconstruction error independently from the shared joint. The original word is constant 3, the sole output is constant 2 and reconstruction is constant 2, so its value is `1`. Apply the finite theorem to the same codes and establish the strict violation of the hypothetical uniform-mean bound. This test uses the original four-message code before expurgation.
- **C33.03-REPAIR** — Reuse that original channel code in a second private length-one example. Let source symbols `(a,b,c)` have masses `(1,3,4)/8`. Under the length-one word equivalence take source encoder `(3,3,0)` and total source decoder `(c,c,b,a)` in channel-label order `0,1,2,3`. Check the induced prior `(4,0,0,4)/8` by aggregating the masses of `a,b` at label `3`. The source code alone reconstructs `(a,a,c)`, the channel decoder returns `(2,2,0)`, and the composite reconstructs `(b,b,c)`. Thus source failure occurs on `b`, channel failure on `a,b`, and reconstruction failure on `a`. Compute the three probabilities under their actual laws and apply C33.02 to these codes. The computed values give the strict comparison `1/8 < 3/8 + 4/8`. On `b` the wrong channel decision repairs the source error. Label `2` has zero sent mass and positive decoded mass, so its source decoder value matters.

### C33.04 — Construct one family on all lengths and prove convergence

- **C33.04-FIT** — Choose `entropy p < r_s < r_c < channelCapacity W`. Derive `0 ≤ r_c` from `entropy_nonneg p`. Choose the released source witness once at `r_s`, open C31 once at `r_c`, and feed those channel witnesses to C32 once. Set `δ = (r_c-r_s)/2`. Intersect the source upper tail, the **full retained** lower tail and `0 < n`. There `codeRate n (K n) ≤ r_s < r_c-δ ≤ codeRate n (L n)`. Apply `codeRate_le_iff` with target `codeRate n (L n)` and simplify the exponential with `exp_mul_codeRate` at the positive retained budget. Reflect the resulting real inequality back to natural numbers to obtain `K n ≤ L n` eventually. The C32 floor already absorbs the half-budget loss. The proof consumes the floor only on `L`.
- **C33.04-FAMILY** — Define the pair of maps together for every `n`. Write `j₀ := ⟨0,hK n⟩ : Fin (K n)` for source index zero and `ℓ₀ := ⟨0,hL n⟩ : Fin (L n)` for retained channel index zero.

  - If `0 < n ∧ K n ≤ L n`, put `bₙ := (B n).restrictMessages (Fin.castLEEmb hfit) j₀`. Use encoder `bₙ.encoder ∘ (a n).encoder` and decoder `(a n).decoder ∘ bₙ.decoder`. If the old channel decoder returns a label outside the embedding, the restricted decoder returns `j₀`.
  - At every other length use encoder `fun _ => (B n).encoder ℓ₀` and decoder `fun _ => (a n).decoder j₀`. Each is a constant map to a word supplied by its own positive-budget family. This gives valid maps when, for instance, `n=1, K n=4, L n=3`, and the unique empty words at `n=0`.

  Verify both branch equations inside the construction, where the component families and budget witnesses are available.
- **C33.04-LIMIT** — Prove the displayed direct public theorem for these maps. On the fitting tail use C33.02 with `πₙ = (PMF.iid p n).map (a n).encoder` and derive

  ```text
  reconstruction error ≤ source error + prior error of bₙ
                       ≤ source error + maximal error of bₙ
                       ≤ source error + maximal error of B n.
  ```

  The final upper sequence tends to zero by the two previously fixed families. Apply the eventual squeeze using nonnegativity of reconstruction error at every length. Check that the witnesses precede `Tendsto`, both maps have the same length index, and the only hypothesis beyond the alphabet/data assumptions is the strict gap. The proof uses neither a rate guarantee for the smaller restricted code nor an all-length fit premise.

### C33.05 — Exercise the construction on a biased source and noisy channel

- **C33.05-GAP** — Use the existing example law `Examples.StochasticChannels.biasedLaw` with Boolean masses `(1/4,3/4)` and `PMF.binaryErasureChannel (1/8) hε`. Check the masses and specialize `entropy_bool` and `channelCapacity_binaryErasureChannel`. The entropy is `2 log 2 − (3/4) log 3`, and the capacity is `(7/8) log 2`. Their difference `C − H = (3/8) log(9/8)` is strictly positive because `9 > 8`. Verify the gap in nats by exact logarithm identities. [Biased law](../../LeanInfoTheory/Examples/StochasticChannels.lean) · [Capacity formula](../../LeanInfoTheory/Shannon/StandardChannelCapacity.lean)
- **C33.05-CALLER** — Feed that gap into `exists_sourceChannelCode_tendsto_errorProbability_zero` and obtain its encoder family `E`, reconstruction family `D` and error limit once. Prove for these witnesses that `∀ ε : ℝ, 0 < ε → ∀ᶠ n in atTop, sourceChannelErrorProbability p W n (E n) (D n) < ε`. C33.04 verifies their construction and fitting-tail inequality inside the proof of the public theorem. This example tests its public conclusion by using the returned pair for every tolerance. Keep the consumer and its fixture imports in the development Examples aggregate.

### C33.06 — Cumulative qualification, independent review and the C34 handoff

- **C33.06-VALIDATE** — Assemble a criterion-by-criterion matrix of exact statements, assumptions, imports, consumers, checks, source identities and outcomes. Rebuild the source producer, C31 and C32 producers and affected callers, both C33 owners, permanent tests and the Shannon/Examples aggregates with warnings as errors. Verify fresh compiled named retention of C32's 873 entries, both released 601/811 contracts, exact approved growth, current owners, root 2/5/92, reviewed simp 94, pins and permitted axioms. Run the generated checks, development static, compatibility and trust, and release documentation. Qualify the complete development suite and hygiene on a separately authorized, source-matched clean checkpoint and repeat after any amendment. Attribute the earlier C32 suite and each fresh result to its own checkout and source.
- **C33.06-HANDOFF** — Prepare `docs/handoffs/chunk-33.md` with the exact C34-facing import, arbitrary map types, direct theorem, finite bound, restriction and fallback, eventual-fit proof, collision and repair calculations, biased erasure-channel caller, edge cases, source adaptations and dispositions. Link the compiling C33.01 examples for both laws. Give the source/output joint consumed by `condEntropy_fano_weak` and its pushforward to the input/output joint consumed by `mutualInfo_channelJoint_memorylessChannel_le` at `(PMF.iid p n).map (E n)`. C34 owns the data-processing comparison and converse for arbitrary joint codes. Record its positive-length normalization and singleton/equality boundaries. Reconcile relevant living summary, project log, reference register, roadmap and step notes before final capture. Link the handoff from canonical context.
- **C33.06-REVIEW** — Complete contextual self-review and separate reassessment, then prepare the fixed cumulative candidate, handoff and matrix for fresh independent assessment of every approved criterion by the bound C33 reviewer. Cover the arbitrary-code C34 interface, the induced-prior inequality and sharper restriction bound, both branches of the all-length family, both finite error regressions and the biased-source caller.

After receipt, preserve the original native report and each finding. Reconcile each assessment against its evidence, resolve material gaps, revalidate final source applicability and obtain renewed assessment where required. Apply handoff corrections before final capture and use the supported private closure for the actual completion record. C34 requires its own plan and selection.

## Execution boundaries

Each selected step runs the installed supervised cycle against its captured baseline. Serialize artifact-producing builds with `python scripts/validate_release.py focused <targets>`, run `python scripts/validate_development.py static` on the working tree and audit touched producers, consumers and import boundaries. For approved API growth, record the applicable reviewed module/import decisions, regenerate current API, website blueprint and declaration index, and run their non-mutating checks and the frozen historical manifest check. Preserve existing Desktop changes and use the repository's clean-checkpoint process for the full suite. The separate signature-bearing API-documentation gate is reserved for its designated milestone.

Planning established the originating chat's reviewer `/root/c33_reviewer` using the installed collaboration adapter. The creation request specified `gpt-6-astra`, `ultra`, and `fork_turns="none"` for `fork_context=false`. The native records identify the reviewer, its bootstrap acknowledgement and its original revision 1 report. Effective model and reasoning settings were unreported. Read-only conduct is by instruction. The private setup preserves the native creation and acknowledgement results separately from the binding and the successful `inspect` and `api` outputs. Formal plan review, exact plan approval and selection of one implementation step are separate actions. Stop after each selected step and its review. [Review protocol](../review-protocol.md) · [Review operations](../review-operations.md)
