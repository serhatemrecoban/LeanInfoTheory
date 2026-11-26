# Chunk 40 handoff — qualifications for the third release

Chunk 40 completed the integration of the six mathematical packages developed in Chunks 25–39. The clean C40 candidate `4f2cb443f74f5779324b5c3e60ce7872957c96fe` had 918 supported declarations in 77 modules. The tagged release has the same 168 tracked Lean source files. Its release metadata, compiled API contract, examples and publication checks were qualified separately at `d12af2d34d49ee493f55c8924cebff815b2953be`. [Chunk plan](../plans/release-3-chunk-40.md) · [Released source](https://github.com/serhatemrecoban/LeanInfoTheory/tree/v0.3.0) · [v0.3.0 API](https://serhatemrecoban.github.io/LeanInfoTheory-API-v0.3.0/v0.3.0/)

## Six packages and their boundaries

The ledger records each new declaration’s type, focused module, mathematical source, assumptions and caller. It also identifies results reused from earlier releases and mathlib. The six counts below total 107 additions to v0.2.0. Import `LeanInfoTheory.Shannon` for the full supported library. The lightweight `LeanInfoTheory` import retains its two direct imports, five reachable project modules and 92 exports. [Six-package ledger](../plans/release-3-chunk-40-ledger.md) · [Textbook editions and section references](../references.md#release-3-planning-locators)

| Package | Additions | What a caller can conclude |
| --- | ---: | --- |
| [Finite hypothesis testing and Neyman–Pearson](../plans/release-3-chunk-40-ledger.md#package-1) | 21 | A finite randomized test rejects the null with probability `f x`. One likelihood threshold and one common tie probability attain the prescribed size and maximize power among tests of at most that size. This includes endpoint levels and singular atoms. |
| [Information density and one-shot coding](../plans/release-3-chunk-40-ledger.md#package-2) | 20 | The bound gives a supported codebook and total deterministic decoder for a specified blocklength and positive message count, under the uniform message law. The strict mass test is defined everywhere. Its log interpretation requires joint support. |
| [Operational capacity and expurgation](../plans/release-3-chunk-40-ledger.md#package-3) | 21 | Capacity is the least upper bound of achievable rates. One code family works for every rate tolerance. For a positive message count that fits the good set, the restricted code works for all message priors. |
| [Lossless source–channel separation](../plans/release-3-chunk-40-ledger.md#package-4) | 5 | With one channel use per source symbol, strict entropy below capacity allows vanishing reconstruction error. The weak converse gives entropy at most capacity. Both use the message law induced by the source encoder. Achievability at equality remains open. |
| [Binary prefix coding](../plans/release-3-chunk-40-ledger.md#package-5) | 10 | The rounded Shannon encoder and an optimal encoder have separate witnesses on the actual support. At positive iid blocklength `n`, the per-symbol optimum is at least the entropy in bits and strictly below that entropy plus `1/n`. |
| [Method of types](../plans/release-3-chunk-40-ledger.md#package-6) | 30 | At positive blocklength, support inclusion gives finite canonical KL, per-word mass and class-probability bounds in nats. Class mass includes the class cardinality. An observed zero-prior symbol gives zero class mass and infinite canonical KL. |

## What C40 qualified

Independent cumulative review found all 19 criteria in the approved plan satisfied. The following checks explain which results apply to the C40 candidate. [Plan and criteria](../plans/release-3-chunk-40.md#numbered-execution-plan-and-acceptance-criteria)

| Step | Results |
| --- | --- |
| C40.01 | Matched the six packages to 107 new declarations, compiled signatures and public callers. Compared the 601 v0.1.0 and 811 v0.2.0 declarations with the candidate. |
| C40.02 | A focused finite-testing caller reproduced the attained total-variation losses, the exact-size optimal test, endpoint levels and common randomization. One test has size 1/4, power 3/8 and miss 5/8. |
| C40.03 | Five coding and separation inputs followed the sampled book through deterministic coding, rates, expurgation and reconstruction under the source-induced message law. A concentrated source gives reconstruction error one in an experiment whose uniform-message error is 1/4. |
| C40.04 | The external Lake fixture gained focused prefix-length and type-probability callers. Its ternary prefix example gives rounded mean two bits and optimum 5/3. A two-word class under a sparse prior has mass 2/9. |
| C40.05 | The full clean development suite and repository hygiene passed. Both earlier release contracts were retained, all 77 module boundaries and 94 reviewed simp declarations were checked, and the six integration inputs compiled again. A separate Git installation of the C40 candidate built all nine external callers. |
| C40.06 | Both passes of the API generator agreed on their signature-bearing output. The review compared 918 rendered signatures and 5,902 binders. Browser and link checks covered both historical versions and each featured package. |
| C40.07 | Rechecked source and caller identities, replayed each integration input and verified the staged documentation. Independent cumulative review reconciled the mathematical results, historical qualifications and release handoff. |

The trust audit covered 5,173 compiled constants in 149 project modules. It found only `propext`, `Classical.choice` and `Quot.sound`. The compiled compatibility, signature and consumer checks each apply to the source on which they ran. [Compatibility guide](../compatibility/README.md) · [Integration sources](../../tests/release-3-qualification) · [External caller fixture](../../tests/external-consumer)

## Four historical clean checkpoints

On 25 November 2026 the project lead accepted four specific source comparisons for release preparation. The original full clean-suite and hygiene run remains open individually for C36.06 (888 declarations), C37.07 (908), C38.06 (913) and C39.06 (918). The project log records each comparison, including the corrected proof ownership in C38 and the changed qualification inputs in C39. [Four checkpoint decisions](../project-log.md#release-3-historical-checkpoint-decisions)

## Documentation and hosting

The C40 rehearsal measured 1,325,717,955 uncompressed bytes for the combined API host. The separate composition measured 661,785,970 bytes for the main site, 662,452,623 for the historical API site and 663,265,811 for the proposed third site. Each fit the 1,000,000,000-byte limit. The released v0.3.0 API was built again from the tagged source. The original v0.1.0 and v0.2.0 documentation retains its historical URLs. [v0.1.0 API](https://serhatemrecoban.github.io/LeanInfoTheory/docs/v0.1.0/) · [v0.2.0 API](https://serhatemrecoban.github.io/LeanInfoTheory-API/v0.2.0/) · [v0.3.0 API](https://serhatemrecoban.github.io/LeanInfoTheory-API-v0.3.0/v0.3.0/)
