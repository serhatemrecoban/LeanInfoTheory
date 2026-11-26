# C31 — Finite memoryless channel coding and operational capacity

<!-- lit-review-status:start -->
**Plan status:** Approved, revision 2. The lead accepted the presented revision (SHA-256 `fa48dac883983fb20aaaa193b3cfa96ebf915c25523cbf687b68ec72846bfc88`) and selected C31.01 with review on 12 November 2026. Formal plan review assessed revision 1. Later steps require their own selection.
<!-- lit-review-status:end -->

## Contract

For a finite memoryless channel `W : X → PMF Y` with nonempty input alphabet, every nonnegative rate strictly below `channelCapacity W` is achievable in nats per use. Information capacity is the least upper bound in ℝ of the rates that satisfy the following single predicate. Proposed declarations live in `LeanInfoTheory.Shannon`. With `open Filter`, the proposed definition is

```lean
def IsAchievableRate {X : Type u} {Y : Type v} [Fintype Y]
    (W : X → PMF Y) (R : ℝ) : Prop :=
  0 ≤ R ∧
    ∃ (M : ℕ → ℕ) (hM : ∀ n, 1 ≤ M n)
      (c : ∀ n, BlockChannelCode X Y n (M n)),
      Tendsto (fun n => (c n).errorProbability W (hM n)) atTop (nhds 0) ∧
      ∀ δ : ℝ, 0 < δ → ∀ᶠ n in atTop, R - δ ≤ codeRate n (M n)
```

The code at each natural length has a deterministic encoder and total decoder. Its error uses the released uniform law on message indices and the memoryless extension of the given channel. The witnesses may depend on the channel and target rate. Only the starting length in the eventual lower bound may depend on the tolerance. The statement permits repetitions in the encoder and arbitrary finite initial segments. The definition needs finite output enumeration for the released error. The three capacity statements additionally take `[Fintype X] [Nonempty X]`, exactly as in the released capacity API. No extra output inhabitant, decidability, support, or injectivity hypothesis is needed.

Proposed supported statements, with `W` explicit and `R : ℝ` implicit:

```text
isAchievableRate_zero [Nonempty X] :
  IsAchievableRate W 0
isAchievableRate_of_lt_channelCapacity (hR : 0 ≤ R) (hlt : R < channelCapacity W) :
  IsAchievableRate W R
le_channelCapacity_of_isAchievableRate (h : IsAchievableRate W R) :
  R ≤ channelCapacity W
isLUB_isAchievableRate (W) :
  IsLUB {R : ℝ | IsAchievableRate W R} (channelCapacity W)
```

One predicate and four theorems suffice. The `IsLUB` statement gives both the upper bound and comparison with every other upper bound directly. General achievability at capacity and a strong converse are outside the contract. C32 owns per-message and maximal error, expurgation, restriction and reliability for arbitrary message priors.

## Source basis and imports

The [C30 finite caller](../../LeanInfoTheory/Examples/ChannelCodingOneShotFinite.lean) instantiates C30 at the exact rounded budget and the literal C28 threshold complement. Its private miss abbreviation and anonymous examples guide the proof. Production code calls the public producers in their mathematical owners. C30.06's private completion records all six closed steps, fourteen satisfied cumulative criteria, parent reconciliation and closure `3548adaefc793cac951d4a5ab8e0783921b485a4989cb38312e68f5091bd318c`. The captured [handoff](../handoffs/chunk-30.md) and Quick Start refer forward to this record. The original full suite ran on separate clean candidate `30ea3314b74c284acc96b788bbc58b4d5b3559d2`. The Desktop has existing uncommitted development work.

Use one new focused owner, `LeanInfoTheory.Shannon.OperationalCapacity`. Start with `LeanInfoTheory.Shannon.ChannelCodingAsymptotic`, which supplies the released code, rate and capacity APIs through `ChannelCoding`. Add `LeanInfoTheory.Shannon.ChannelCodingOneShot` and `LeanInfoTheory.Shannon.IidInformationDensity` when the direct proof first uses them. Export the owner through the full `LeanInfoTheory.Shannon` umbrella. Keep the finite error bound, decoder construction, concentration and weak converse separately importable. The two example channels need `LeanInfoTheory.Shannon.StandardChannelCapacity` only on the consumer side. Keep helper results private, with no new simp attributes.

PW24 §19.1, Definitions 19.2–19.3 (printed p. 373), permits a decoder erasure and describes the operational supremum through tolerance-indexed code selection. C31 uses the released total decoder, which returns a message index on every output, and fixes its code family before quantifying over tolerances. PW24 §19.2, Theorems 19.7–19.9 (pp. 375–377), supplies the memoryless weak converse, iid direct argument and single-letter identification. Sections 17.4 and 18.1–18.2 underlie the C23 Fano and C30 independent-pair bounds. CT91 §8.5 (pp. 193–194) defines achievability using maximal error. In §8.7, the proof of Theorem 8.7.1 (pp. 199–202) selects a deterministic code with small uniform average error before expurgation. C31 uses that intermediate guarantee. C32 owns expurgation. CT91 §8.9 (pp. 204–207) gives the uniform-message Fano converse. The Lean statements use nats, natural ceiling budgets and the literal miss of a strict threshold. [Registered editions](../references.md) · [Roadmap](release-3-chunk-map.md#c31-finite-memoryless-channel-coding-and-operational-capacity)

## Steps and acceptance criteria

### C31.01 — Define achievability and exhibit the singleton family

- **C31.01-FAMILY** — Deliver the predicate with the stated binders and inspect its elaborated definition. Compile a generic focused consumer which opens one witness and uses its rate guarantee at two positive tolerances. Exercise the eventual quantifier in the [existing C23 example](../../LeanInfoTheory/Examples/ChannelCodingAsymptotic.lean) beside its private alternating family. Use that family explicitly to witness rate zero via its vanishing error and nonnegative rates, retaining the existing proof that its rates do not converge. For this same budget, take `R = Real.log 2 / 2` and `δ = Real.log 2 / 4`. The lower bound holds at every odd length and fails at every even length, however large. Verify the failure of the eventual lower bound for this witness. Add the focused C31 import to this development example and reuse its private definitions in place.
- **C31.01-ZERO** — Prove `isAchievableRate_zero` using `M n = 1`, a fixed input letter in every coordinate, and the unique message as decoder output. Use `BlockChannelCode.errorProbability_one` and `codeRate_one` at every length, including zero. Validate a one-message caller with only nonempty input and finite output.
- **C31.01-API** — Match C30's development qualification to the actual starting source before growth. Compile through the focused import and full umbrella, check the lightweight-root boundary, and review the new module, its imports and the two names against the growth policy. Regenerate current artifacts after approved growth.

### C31.02 — Construct one vanishing-error family below capacity

- **C31.02-BOUND** — Fix a capacity-attaining input law `p` using `exists_mutualInfo_channelJoint_eq_channelCapacity` and choose one slope `R < s < mutualInfo (PMF.channelJoint p W)`. Set `M n = roundedMessageSize n R`. First prove a pointwise existence statement. For every natural `n`, there exists a deterministic code at exactly `n, M n` whose released error is at most the true-pair miss plus `Real.exp (-(n : ℝ) * (s - R))`. Apply `exists_blockChannelCode_errorProbability_le_of_infoDensityThreshold` with `q = PMF.iid p n`, `K = PMF.memorylessChannel W n` as its induced block channel, and `t = (n : ℝ) * s`. The miss is the real mass of `(infoDensityThresholdEvent q K t)ᶜ` under `PMF.channelJoint q K`, including ties. By `roundedMessageSize_bounds`, `(M n : ℝ) - 1 < exp (n*R)`. Multiply by the positive `exp (-n*s)` and combine exponents to bound the competing term.
- **C31.02-LIMIT** — Make one classical choice of code per length from C31.02-BOUND, obtaining `c : ∀ n, BlockChannelCode X Y n (M n)` and its pointwise error inequality. For the fixed gap `d = s - R > 0`, use the short proof pattern in [SourceCodingAsymptotic](../../LeanInfoTheory/Shannon/SourceCodingAsymptotic.lean). Since `d * (n : ℝ)` tends to positive infinity, `Real.tendsto_exp_neg_atTop_nhds_zero` gives `exp (-(n : ℝ) * d) → 0` by composition. Keep this argument local to the channel proof. Apply `tendsto_prob_infoDensityThresholdEvent_iid_compl` at the fixed law and slope and squeeze the nonnegative errors of `c` against the sum of the two vanishing terms. Use this same `c` in C31.02-DIRECT.
- **C31.02-DIRECT** — Deliver `isAchievableRate_of_lt_channelCapacity`. Budget positivity holds at every length. On the tail `0 < n`, the lower half of `codeRate_roundedMessageSize_bounds` gives `R ≤ codeRate n (M n)` for the original nonnegative target. Deduce all positive-tolerance bounds. Compile a generic subcapacity caller through the focused owner and inspect its public assumptions. Keep exact rounded budgets internal to this construction.

### C31.03 — Prove the converse and least-upper-bound theorem

- **C31.03-UPPER** — Prove `le_channelCapacity_of_isAchievableRate` by unpacking the predicate once. If `C = channelCapacity W < R`, take `δ = (R-C)/3`. Intersect the witness's eventual lower bound with `BlockChannelCode.eventually_codeRate_le_channelCapacity_add W M hM c he δ hδ`. At a length on the common tail the inequalities force `R-δ ≤ C+δ`, a contradiction. Compile the theorem on arbitrary dependent witnesses, with no rate-limit or rate-boundedness input.
- **C31.03-LUB** — Deliver `isLUB_isAchievableRate` for exactly the same predicate. C31.03-UPPER gives membership in the upper bounds. For any upper bound `b`, the singleton witness gives `0 ≤ b`. If `b < C`, the midpoint of `b` and `C` is nonnegative, achievable by C31.02 and strictly above `b`. Compile projections of the upper and least clauses, also at zero capacity. The argument never needs membership of capacity in the achievable set.

### C31.04 — Exercise the public endpoint on two channels

- **C31.04-NOISY** — In a permanent development example import the focused owner and `StandardChannelCapacity`. For `PMF.binaryErasureChannel` at erasure probability `1/2`, instantiate `channelCapacity_binaryErasureChannel` to obtain `C = Real.log 2 / 2`. Prove positivity and achievability of `Real.log 2 / 4` and instantiate the least-upper-bound theorem at the computed value. Compile as a consumer of supported declarations.
- **C31.04-CONSTANT** — On a nonempty finite input and a fixed output row, use `channelCapacity_const` to compute zero capacity. Show `{R : ℝ | IsAchievableRate W R} = {0}` by the converse, nonnegativity and the singleton witness. Exercise the witness when strict subcapacity gives no nonnegative target. Include these consumers in the development Examples aggregate.

### C31.05 — Cumulative validation, independent review and C32 handoff

- **C31.05-VALIDATE** — Account for every criterion against current source and permanent consumers. Rebuild the focused owner, C30 finite caller, C23 alternating-family consumer, C31 examples and relevant umbrellas. Check generated artifacts, development static, compatibility and trust gates, release documentation and named retention against the C30 inventory. Expected current growth is 852 to 857 supported names and 63 to 64 modules, with the existing two direct root imports, five root-reachable modules, 92 root exports and 94 reviewed simp names. Verify the 601/811 historical contracts, exact direct imports, reviewed attributes, allowed axioms, dependency pins and checkout hygiene. Run the complete development suite on an authorized clean source-matched checkpoint and repeat after amendment. Record exact source, actors, commands, outputs and applicability. Distinguish pending gates from passes.
- **C31.05-HANDOFF** — Reconcile signatures, source adaptations, examples, family quantifiers and validation evidence in the living summary, project log, reference register and step notes as applicable. Maintain `docs/handoffs/chunk-31.md` with exact imports and a link to a permanent, compiling C31 example. The caller opens an achievable witness once and retains `M,hM,c`, its error limit and its rate guarantee. For any proposed retained budget `M' : ℕ → ℕ` with `1 ≤ M' n` at every length, assume the eventual inequality `codeRate n (M n) - Real.log 2 / (n : ℝ) ≤ codeRate n (M' n)`. For every `δ > 0`, intersect the original rate tail at `δ/2`, the assumed loss bound, and the positive-length tail where `Real.log 2 / (n : ℝ) ≤ δ/2`. Derive `R - δ ≤ codeRate n (M' n)` eventually. This caller uses only the operational witness. C32 supplies the retained code, finite rate-loss bound, decoder transport and error guarantee for every prior.
- **C31.05-REVIEW** — Complete contextual self-review and separate reassessment. Prepare the cumulative candidate and maintained handoff for fresh independent review. Give the reviewer a matrix linking every approved criterion to its evidence on the candidate, including permanent consumers, prior finding dispositions and any limits on earlier validation. The bound reviewer assesses the candidate, matrix and handoff against all approved criteria.

After dispatch, retain the original independent report, reconcile each finding and criterion, and resolve material gaps. Validate the final source and applicability of the evidence after corrections, complete maintained documents before final capture, record the private closure, and stop.

## Validation and supervision during execution

Each selected step follows the [review protocol](../review-protocol.md) and [operations](../review-operations.md). Record baseline, reviewed and final sources distinctly. During dirty work, serialize focused builds with `python scripts/validate_release.py focused <targets>` and run `python scripts/validate_development.py static`. Check current declaration, import and policy deltas for every public addition. Regenerate current manifest, blueprint and declaration index deliberately and verify the historical manifest. Use named compiled comparison and axiom evidence at its actual source. Before dispatch, perform self-review, separate reassessment and any justified corrections. Preserve original native receipts and reports, reconcile independently, run final checks, and stop after the selected step. At closeout run `python scripts/validate_development.py` on the qualified clean checkpoint. The separate signature-bearing API-doc gate belongs to its designated milestone.

The first proof route fits the roadmap. Changes to mathematical meaning, family quantifiers, supported contracts, chunk boundaries, acceptance policy or pins return to the lead. Editorial status is confined to the marked region above. Formal plan review requires a separate request. Execution requires approval of the exact plan and explicit selection of an individual step.
