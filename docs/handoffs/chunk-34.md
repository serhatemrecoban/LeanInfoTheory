# Chunk 34 — Lossless separation for arbitrary joint codes

For a finite iid source and one use of a finite memoryless channel per source symbol, C33 constructs a family with vanishing block reconstruction error whenever `entropy p < channelCapacity W`. C34 proves that every family whose error vanishes satisfies `entropy p ≤ channelCapacity W`. In particular, strict excess of entropy over capacity rules out vanishing error for **every** deterministic encoder and reconstruction decoder. The same error is used in both directions. General achievability at equality and convergence of the error to one above capacity remain open under these contracts. [Two-owner consumer](../../LeanInfoTheory/Examples/SourceChannelSeparationPackage.lean) · [Approved C34 plan](../plans/release-3-chunk-34.md)

## Contracts for downstream consumers and the C40 ledger

All declarations below are in `LeanInfoTheory.Shannon`. Logs are natural. Each family consists of total maps at every natural length. The three alphabets have independent universes. A source PMF supplies a source inhabitant and the channel row at an available input supplies an output inhabitant. No encoder injectivity, recovery map, source/channel code factorization, uniform prior or independence of the encoded coordinates is required.

Import `LeanInfoTheory.Shannon.SourceChannelCode` for the supported error definition. Its direct dependencies are `Shannon.SourceCoding` and `Shannon.ChannelCodeExpurgation`. For a source-word/input-word map `E` and an output-word/source-word map `D`, the shared error is definitionally

```lean
sourceChannelErrorProbability p W n E D =
  decodingErrorProbability
    (PMF.channelJoint (PMF.iid p n) (fun s => PMF.memorylessChannel W n (E s))) D
```

Import `LeanInfoTheory.Shannon.SourceChannelSeparation` for the direct theorem. It uses the finite owner, `Shannon.SourceCodingAsymptotic`, `Shannon.OperationalCapacity` and `Shannon.OperationalExpurgation`. The C33 producer composes codes at compatible budgets and bounds the channel term under the actual source-encoder prior. [Error definition and finite composition](../../LeanInfoTheory/Shannon/SourceChannelCode.lean) · [Direct proof](../../LeanInfoTheory/Shannon/SourceChannelSeparation.lean) · [C33 validation and adaptations](chunk-33.md)

```lean
theorem exists_sourceChannelCode_tendsto_errorProbability_zero
    {S : Type u} {X : Type v} {Y : Type w} [Fintype S] [Fintype X] [Nonempty X] [Fintype Y]
    (p : PMF S) (W : X → PMF Y) (h : entropy p < channelCapacity W) :
    ∃ (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X)) (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S)),
      Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n)) atTop (nhds 0)
```

Import `LeanInfoTheory.Shannon.SourceChannelConverse` for both C34 theorems. Its only direct imports are `LeanInfoTheory.Shannon.SourceChannelCode` and `LeanInfoTheory.Shannon.ProductChannelCapacity`. Both declarations are exported by the full Shannon umbrella and have no simp attribute. The development caller imports just the direct and converse owners. [Converse owner](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean) · [Strict-regime caller](../../LeanInfoTheory/Examples/SourceChannelSeparationPackage.lean)

```lean
theorem mul_entropy_le_mul_channelCapacity_add_error
    {S : Type u} {X : Type v} {Y : Type w} [Fintype S] [Fintype X] [Nonempty X] [Fintype Y]
    (p : PMF S) (W : X → PMF Y) (n : ℕ)
    (E : (Fin n → S) → (Fin n → X)) (D : (Fin n → Y) → (Fin n → S)) :
    (n : ℝ) * entropy p ≤ (n : ℝ) * channelCapacity W + Real.log 2 +
      sourceChannelErrorProbability p W n E D * (n : ℝ) * Real.log (Fintype.card S : ℝ)

theorem entropy_le_channelCapacity_of_tendsto_sourceChannelErrorProbability
    {S : Type u} {X : Type v} {Y : Type w} [Fintype S] [Fintype X] [Nonempty X] [Fintype Y]
    (p : PMF S) (W : X → PMF Y)
    (E : ∀ n : ℕ, (Fin n → S) → (Fin n → X))
    (D : ∀ n : ℕ, (Fin n → Y) → (Fin n → S))
    (he : Tendsto (fun n => sourceChannelErrorProbability p W n (E n) (D n))
      atTop (nhds 0)) :
    entropy p ≤ channelCapacity W
```

## Where the two joint laws enter

Write `q = PMF.iid p n`, `K = PMF.memorylessChannel W n`, `J = PMF.channelJoint q (fun s => K (E s))`, and `L = PMF.channelJoint (q.map E) K`. In `J`, an atom has mass `q s * K (E s) y` and reconstruction fails exactly when `D y ≠ s`. In `L`, source words sent to the same input word contribute to the same atom. The C33 specialization of weak Fano and the identity `J.map (fun z => (E z.1, z.2)) = L` are proved by anonymous examples. The general `condEntropy_fano_weak` and the PMF channel and projection operations are supported library declarations. [C33 law, Fano and projection examples](../../LeanInfoTheory/Examples/SourceChannelCode.lean#L35)

Projecting the first coordinate gives `mutualInfo L ≤ mutualInfo J`. The converse uses the other direction. For any finite source law, deterministic map and channel, the right-associated triple first applies the deterministic encoder, then samples the channel row at its result. It is Markov. Reverse the chain, apply data processing, and identify its endpoint and output-pair marginals to get `mutualInfo J ≤ mutualInfo L`. This private lemma holds before imposing either product assumption. Memorylessness then gives `mutualInfo L ≤ n * channelCapacity W` at the actual, possibly correlated prior `q.map E`. The iid law gives `n H(p) = mutualInfo J + condEntropy J`. Weak Fano at `J,D` bounds the conditional entropy using the shared error and `log |Sⁿ| = n log |S|`. [Private comparison and finite bound](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L30) · [Arbitrary-prior block capacity](../../LeanInfoTheory/Shannon/ProductChannelCapacity.lean#L97)

The undivided bound applies at length zero. On the positive-length tail it gives `H(p) ≤ C(W) + log 2 / n + Pe(n) · log |S|`. The reciprocal term tends to zero. The other correction tends to zero by multiplying the given error limit by a fixed real number, including when that number is zero. Closedness of the real order gives the converse. The only division is by positive blocklength. [Limit proof](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L76)

CT91, first edition, §8.13, Theorem 8.13.1, printed pp. 216–218 (PDF 238–240), gives the error (8.142) and converse (8.148)–(8.157). The Lean argument specializes stationary-source entropy to iid blocks, uses §2.8 data processing and §2.11 weak Fano (2.145), and expresses the one-bit overhead in nats. PW24 §19.7, Theorem 19.22, printed pp. 391–393 (PDF 416–418), allows different source and channel lengths. The project sets them equal in the direct construction and in the converse estimate (19.36), retaining the induced prior and the finite correction. [Registered editions](../references.md)

## Cumulative criterion evidence

| Approved criterion | Source, consumer or acceptance record |
|---|---|
| C34.01-LAWS | [Private comparison](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L30) works for any finite law and channel. The [C33 projection](../../LeanInfoTheory/Examples/SourceChannelCode.lean#L65) identifies the induced joint. |
| C34.01-FANO | [Source-word joint](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L60), actual decoder, first marginal, iid entropy and word-alphabet logarithm. |
| C34.01-BOUND | [Undivided theorem](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L50) with arbitrary maps and block prior, including the [zero-length caller](../../LeanInfoTheory/Examples/SourceChannelConverse.lean#L40). |
| C34.02-TAIL | [Positive-length normalization and closed order](../../LeanInfoTheory/Shannon/SourceChannelConverse.lean#L85). |
| C34.02-FAMILY | [Universal-family caller and strict contrapositive](../../LeanInfoTheory/Examples/SourceChannelConverse.lean#L45) keep the supplied families fixed. |
| C34.03-COLLISION | [Two fair bits on a noiseless channel](../../LeanInfoTheory/Examples/SourceChannelConverse.lean#L99). Sending the first bit twice gives two diagonal output atoms of mass one half, error one half, both mutual informations and conditional entropy equal to `log 2`. Substituting independent fair input coordinates gives `2 log 2`. |
| C34.03-BIASED | [Four uses of a constant channel](../../LeanInfoTheory/Examples/SourceChannelConverse.lean#L191). For the Boolean source of true mass three quarters, `4 H(p) − 3 log 2 = log(32/27) > 0`. Every encoder and decoder has error strictly greater than one half. |
| C34.03-IMPOSSIBLE | [Fair source on the constant channel](../../LeanInfoTheory/Examples/SourceChannelConverse.lean#L225) has positive entropy and capacity zero. No pair can have vanishing error. |
| C34.03-SINGLETON | [Singleton and empty words](../../LeanInfoTheory/Examples/SourceChannelConverse.lean#L239). Unique reconstruction gives zero error, including at length zero for a nonsingleton alphabet. The singleton realizes one equality case. |
| C34.03-PACKAGE | [Two direct imports](../../LeanInfoTheory/Examples/SourceChannelSeparationPackage.lean#L32). The same error witness constructed below capacity is consumed by C34. Above capacity the caller rules out existence of such families. |
| C34.04-VALIDATE | Named retention, compiled owner/import/root/simp and axiom probes, focused and aggregate builds, generated/frozen, static, released 601/811, trust and documentation gates. Source-matched clean development and hygiene evidence is bound separately. |
| C34.04-HANDOFF | The public contracts, source adaptations, permanent consumers and proof limits above supply the C40 ledger. The release map, living summary, reference register, log and step notes identify the C35 boundary. |
| C34.04-REVIEW | The original cumulative report, separate parent dispositions and final source are bound in the step completion record after assessment of all thirteen criteria. |

## Qualification identities

| Step | Reviewed final source manifest | Independent step closure |
|---|---|---|
| C34.01 | `a01375c82190630ba53d2dd5c0cb4822a9a6f698633d98e738c8a7c3193ac5bc` | `97f399afae73ad6e9a0e428c598fd7fc9ba9e0efbb5cedadce12bc58a6be9293` |
| C34.02 | `b0dcf0663f1ed170d36715ac55da3c7f35c5bdbb9177c38c4e602198261d49ce` | `f079b6d77def0b4bf162070e84c8732ab070eb451e8ca31cd3146a754826b498` |
| C34.03 | `a04db79095e02367093efa0968e3208ff6ba392b09afdc8df3608ea25b6e8d15` | `c55582ec660d6bed4cace5b9c40919c5303aa71a54bb10184b615cdbe67b4635` |

The three earlier independent step reports accepted all ten mathematical and consumer criteria. The revision 1 reviewer identified two issues. The concrete constant-channel calculations now import their capacity theorem explicitly and the strict-regime consumer uses just the two focused owners. For signature retention, the exact 876-name C33.06 export from the source-matched Desktop checkout has SHA-256 `51bd871a781b840fac5929d1039c8845ff5b069941c476e36510369415a51cb6`. The historical clean C33 suite belongs to commit `a14c3b9f001eaae3914e264d0ca2f1945c39a2b6`. C34 adds two theorems in one owner, giving 878 supported names in 69 modules. The lightweight root has two direct imports, five reachable modules and 92 exports. The supported reviewed simp set has 94 names. [Step evidence](../plans/release-3-chunk-34-notes.md)

The private cumulative directory is `.lit-review/setup/c34-04-20261114/`. The named export covers all retained names and records both additions separately. Each primary gate has a command record and its original output. The clean qualification binds the candidate file bytes, checkpoint commit and tree, the complete development command and the hygiene result. The original cumulative report and `completion.json` bind independent assessment and reconciliation to the final source. These separate records let the checkpoint identify its own qualification without embedding its own Git hash. [C33 incoming record](chunk-33.md#validation-identities) · [C34 obligations](../plans/release-3-chunk-34.md#c3404--cumulative-qualification-independent-review-and-c35-handoff)

## Handoff to C35

The information-density, random-coding, operational capacity, expurgation and separation chain now supplies both strict regimes for the stated model. This removes the coding dependency from the release map's post-C34 estimate. Keep C35 then C36 in the default order. Their prefix-code construction and expected-length optimization can proceed independently of the channel-coding results. C35 should distinguish symbol-index injectivity from a set of words, check the pinned Kraft–McMillan necessity theorem, and establish realization of admissible lengths. It should choose the support alphabet for C36 and document the singleton empty word with known symbol count. C35 begins with its own plan and step selection. [Release map and C35 scope](../plans/release-3-chunk-map.md#c35-binary-prefix-codes-and-kraft-length-realization)
