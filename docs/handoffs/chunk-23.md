# C23 handoff: deterministic channel codes and Fano weak converse

Initial milestone qualification is recorded on actual source `beb99362718489c17dfe150e5c8be0281ab34aa3`.
C23.01–C23.05 remain closed by Section 5. Step 6 baseline B remains `be97e81f7d8f08444c489c6a3ef06e513f5b7c6469da13c487177c8037f7dd0f`, distinct from R/F.

The separately approved initial scoped checkpoint `beb99362718489c17dfe150e5c8be0281ab34aa3` passed the complete maintained clean routine. The current local two-pass API build/check gate passed, and the parent substantively inspected all 36 new rendered signatures, hypotheses, result types, docstrings, owners and source links.

The exact local C23-only checkpoint, necessary bounded amendments/full clean reruns, reuse of the existing registered validation checkout and separate local API milestone were approved by the actual reply “yes, i approve”. Push, release, publication, C24 and external-project upgrades remain unapproved.

Every bounded amendment, including these documentation updates, requires the entire clean rerun and renewed API applicability before R; rerun the API gate if invalidated. Fresh original review of all 21 criteria, substantive all-criterion reconciliation and final qualification/applicability/capture remain pending. Only actual `.lit-review/setup/c23-06-completion-20261025.json` and its linked genuine original records determine completion; no cumulative SAT assessment or future result is predicted.
C24 remains proposed and unselected; no dedicated C24 contract is approved here.

## 1. Delivered mathematics and exact contracts

Channels remain functions `A → PMF B`; information quantities and rates use nats.
The code model is the transparent pair
`(Fin M → (Fin n → A)) × ((Fin n → B) → Fin M)`.
Its decoder is total, and it has no recovery, injectivity or independence field.
Input and output alphabets have independent universes.
Operational laws require `hM : 1 ≤ M`, deriving `Nonempty (Fin M)` locally.
There is no uniform zero-message law or operational zero-message convention.

Write `U = PMF.uniformOfFintype (Fin M)`,
`K = PMF.memorylessChannel W n` and `q = U.map c.encoder`.
The message/output law J is `PMF.channelJoint U (fun m => K (c.encoder m))`.
The right-associated message/input/output law Q is the channel extension
of the deterministic encoder graph by K.
Its message, input and output marginals are U, q and `q.bind K`.
Its message/input marginal is the encoder graph pushforward;
its input/output marginal is `PMF.channelJoint q K`;
its message/output marginal is exactly J.
Uniform messages therefore remain distinct when encoders collide.
The induced input law need not be uniform on the image or have independent coordinates.

Average error reuses `decodingErrorProbability J c.decoder`.
It agrees with the random-variable definition on Q and the real failure-event mass.
Its finite formula is the uniform average of conditional output error masses:
`(1/M) * ∑ m, ∑ y, if c.decoder y ≠ m then (K (c.encoder m) y).toReal else 0`.
The same error lies in [0,1]; no competing indicator or maximal-error definition is added.
Raw laws/error results require only `[Fintype B]`, not finite or nonempty A.

On Q, message → input → output and message → output → decoded message are Markov.
The public inequalities give
`I(message;decoded) ≤ I(message;output) ≤ I(input;output)`.
The last quantity is bounded by `n * channelCapacity W` using C22's theorem
on the actual arbitrary q, without an iid or injective-encoder assumption.
Capacity-bearing results require `[Fintype A] [Nonempty A] [Fintype B]`.
No base-capacity convention on empty input alphabets is introduced.

Uniform-source Fano gives, for every natural n and positive M,
`(1-Pe) * log M ≤ n*C(W) + log 2`.
For `0<n`, normalization gives
`(1-Pe) * codeRate n M ≤ C(W) + log 2/n`.
For `0<n`, `0<R` and `R ≤ codeRate n M`, the pointwise form is
`1-C(W)/R-log 2/(n*R) ≤ Pe`; it does not require `C(W)<R`.
The undivided theorem includes `Pe=1` and never divides by `1-Pe`.

Families use explicit `W, M, hM, c` over all natural lengths.
Vanishing error first yields the private eventual bound
`codeRate n (M n) ≤ 2*(C(W)+log 2)`.
The tolerance proof controls error times this fixed bound.
Nonnegative rates supply the lower/coboundedness needed by real limsup.
Consequently every positive δ gives eventual rate ≤ C(W)+δ, and real limsup ≤ C(W).
No bounded-rate premise, rate limit or limit of error times the actual rate is assumed.

An eventual lower rate R above capacity gives the quantitative pointwise bound
eventually, the positive eventual floor `(1-C(W)/R)/2`, and nonvanishing error.
Positivity of R is derived from `C(W)≥0`.
A fixed positive gap above capacity occurring infinitely often also prevents
vanishing error, including for unbounded rates.
That weaker premise asserts no eventual positive floor or error-to-one conclusion
and does not use an unguarded real-limsup convention.

Boundary contracts remain explicit: M=1 has zero error; n=0 has error `1-1/M`;
n=1 recovers the original-channel law and error sum.
`codeRate 0 M=0` is a scalar convention, not valid normalization.
Empty base types occur only in a raw zero-word consumer; its base capacity is not formed.

## 2. Exact public inventory and focused imports

The current inventory has 36 C23 additions: 23/7/6 across these three owners.
All names below are actual source/inventory names; none is a proposed alias.
The inventory remains 811 declarations in 57 supported owners, with 92 root
exports and 94 reviewed simp names at the completed Step 5 source.
Counts are descriptive, not substitutes for elaborated contract/owner checks.
No C23 declaration has an added attribute or simp membership.

### LeanInfoTheory.Shannon.ChannelCode

Direct imports:

- `LeanInfoTheory.Shannon.Fano`
- `LeanInfoTheory.Probability.ProductChannel`

Public names (23):

- `LeanInfoTheory.Shannon.BlockChannelCode`
- `LeanInfoTheory.Shannon.BlockChannelCode.decoder`
- `LeanInfoTheory.Shannon.BlockChannelCode.encoder`
- `LeanInfoTheory.Shannon.BlockChannelCode.errorProbability`
- `LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_eq_decodingErrorProbabilityOf`
- `LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_eq_sum`
- `LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_eq_toOuterMeasure`
- `LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_le_one`
- `LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_nonneg`
- `LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_one`
- `LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_one_length_eq_sum`
- `LeanInfoTheory.Shannon.BlockChannelCode.errorProbability_zero`
- `LeanInfoTheory.Shannon.BlockChannelCode.messageInputOutputLaw`
- `LeanInfoTheory.Shannon.BlockChannelCode.messageInputOutputLaw_map_input`
- `LeanInfoTheory.Shannon.BlockChannelCode.messageInputOutputLaw_map_inputOutput`
- `LeanInfoTheory.Shannon.BlockChannelCode.messageInputOutputLaw_map_message`
- `LeanInfoTheory.Shannon.BlockChannelCode.messageInputOutputLaw_map_messageInput`
- `LeanInfoTheory.Shannon.BlockChannelCode.messageInputOutputLaw_map_messageOutput`
- `LeanInfoTheory.Shannon.BlockChannelCode.messageInputOutputLaw_map_output`
- `LeanInfoTheory.Shannon.BlockChannelCode.messageOutputLaw`
- `LeanInfoTheory.Shannon.BlockChannelCode.messageOutputLaw_apply`
- `LeanInfoTheory.Shannon.BlockChannelCode.messageOutputLaw_map_fst`
- `LeanInfoTheory.Shannon.BlockChannelCode.messageOutputLaw_one_map`

### LeanInfoTheory.Shannon.ChannelCoding

Direct imports:

- `LeanInfoTheory.Shannon.ChannelCode`
- `LeanInfoTheory.Shannon.ProductChannelCapacity`
- `LeanInfoTheory.Shannon.CodingRate`

Public names (7):

- `LeanInfoTheory.Shannon.BlockChannelCode.isMarkovChainOf_decoder`
- `LeanInfoTheory.Shannon.BlockChannelCode.isMarkovChain_messageInputOutputLaw`
- `LeanInfoTheory.Shannon.BlockChannelCode.mutualInfoOf_decoder_le`
- `LeanInfoTheory.Shannon.BlockChannelCode.mutualInfoOf_message_le_input`
- `LeanInfoTheory.Shannon.BlockChannelCode.one_sub_channelCapacity_div_sub_le_errorProbability`
- `LeanInfoTheory.Shannon.BlockChannelCode.one_sub_errorProbability_mul_codeRate_le`
- `LeanInfoTheory.Shannon.BlockChannelCode.one_sub_errorProbability_mul_log_le`

### LeanInfoTheory.Shannon.ChannelCodingAsymptotic

Direct imports:

- `LeanInfoTheory.Shannon.ChannelCoding`
- `Mathlib.Analysis.SpecificLimits.Basic`
- `Mathlib.Order.LiminfLimsup`

Public names (6):

- `LeanInfoTheory.Shannon.BlockChannelCode.eventually_codeRate_le_channelCapacity_add`
- `LeanInfoTheory.Shannon.BlockChannelCode.eventually_one_sub_channelCapacity_div_sub_le_errorProbability`
- `LeanInfoTheory.Shannon.BlockChannelCode.eventually_pos_le_errorProbability_of_eventually_le_codeRate`
- `LeanInfoTheory.Shannon.BlockChannelCode.limsup_codeRate_le_channelCapacity`
- `LeanInfoTheory.Shannon.BlockChannelCode.not_tendsto_errorProbability_zero_of_eventually_le_codeRate`
- `LeanInfoTheory.Shannon.BlockChannelCode.not_tendsto_errorProbability_zero_of_frequently_channelCapacity_add_le_codeRate`

The raw pair and accessors need no class instances. ChannelCode's other twenty
public declarations require only finite outputs.
The two Markov results and decoder DPI require finite outputs; the encoded-input
DPI additionally requires finite inputs. The three finite capacity bounds and all
six asymptotic endpoints retain finite alphabets and nonempty base input.

The full `LeanInfoTheory.Shannon` umbrella imports all three owners.
The lightweight root and semantic-bridge aggregate do not acquire C23 imports.
Production coding imports neither StandardChannelCapacity nor Examples.
`codeRate` remains in `Shannon.CodingRate`; `natsToBits` remains in `Shannon.Units`.
The lighter ChannelCode import intentionally excludes those rate/unit names.
Two implementation helpers remain private: the finite actual-input MI bound and
the asymptotic eventual rate bound. No code-sequence structure is exported.

## 3. Permanent independent consumers

All added consumer declarations are private and enter only the non-stable Examples aggregate.

| Consumer | Direct imports and coverage |
| --- | --- |
| EC: `Examples.ChannelCode` | Sole `Shannon.ChannelCode` import. Actual marginals, RV/event/sum error, range, singleton/zero/one lengths, empty-base zero-word M=3 error 2/3, and unequal Fin 3 fibers with input masses 2/3 and 1/3, supported collision and error 1/3. |
| EF: `Examples.ChannelCoding` | `Shannon.ChannelCoding` and `Shannon.StandardChannelCapacity`. Fin 4 repeated-bit collision, correlated two-letter input, actual error 1/2, both Markov/DPIs, Fano-to-capacity chain, all finite forms, singleton/zero/one lengths and error-one decoder. Actual one-letter standard-channel consumers are described below. |
| EA: `Examples.ChannelCodingAsymptotic` | `Shannon.ChannelCodingAsymptotic` and `Shannon.StandardChannelCapacity`. Actual singleton and lossless alternating families, both limits, nonconvergent rates, zero/one members, positive-capacity finite/eventual obstruction, unbounded intermittent spikes and the complete same-family interface. |

EF's identity code uses uniform Fin 2 messages, encoding false/true and decoding
the received Boolean symbol. Noiseless error is zero; uniform independent output
gives error one half. BSC identity decoding has error ε for all ε∈[0,1].
BEC uses a total decoder: none and some false select message 0; some true selects 1.
Its actual average error is ε/2, including complete erasure.
Each displayed coding bound starts from the public finite converse and then
rewrites an actual-error identity and the delivered standard capacity.
Explicit ε=0,1/4,1 checks give BSC errors 0,1/4,1 and BEC errors 0,1/8,1/2.
The generic results also include half-noise; no optimal-decoder claim is made.

EA's lossless family alternates singleton and all-binary-word budgets.
Its errors are zero, while even/odd rates are 0/log 2 and have no real limit.
`alternating_complete_interface` uses these same code/channel/budget data for
sampling marginals, both error interpretations, both Markov/DPIs, Fano,
arbitrary-input capacity, finite/normalized/pointwise bounds and both limits.
The noiseless `4^n` constant-code family has error `1-1/4^n` and positive-length rate `2*log 2`.
Its public pointwise bound is `Pe≥1/2-1/(2*n)`; n=2 has M=16, actual Pe=15/16
and the independently derived public lower bound 1/4.
The constant-output family uses singleton budgets at even n and `2^(n*n)` at odd n.
It has arbitrarily late unbounded rate spikes and zero-error lengths, preventing
any eventual positive error floor despite the public frequent nonvanishing result.

## 4. Sources and adaptations

Use the registered editions and hashes in [references](../references.md),
the [approved C23 plan](../plans/post-release-chunk-23.md), its
[notes](../plans/post-release-chunk-23-notes.md) and the [C22 handoff](chunk-22.md).
The C22 handoff's statements that C23 had not started describe its dated snapshot.

- CT91 §§8.5/8.9, printed 192–194/204–207, PDF 214–216/226–229: indexed deterministic codes, uniform average error and the Fano converse. Replace bits and informal exponential message sizes by nats and positive natural budgets.
- PW24 §17.1, Definition 17.1/(17.1), printed 342–343, PDF 367–368: actual message/input/output/decoded-message sampling. Preserve message identity under noninjective encoding and use a total Fin M decoder.
- PW24 §17.4, Theorem 17.3, printed 348–349, PDF 373–374: weak-converse context. Use the existing undivided Fano route; do not adopt the alternative test proof's inconsistent error-indicator wording or divide by 1-Pe at error one.
- PW24 §19.1/start of §19.2, printed 371–376, PDF 396–401: stationary memoryless/rate conventions. Information capacity remains distinct from operational capacity.
- CT91 §§8.1.4–8.1.5 and PW24 §19.3: standard-channel specialization through C22. Preserve erasure weighting, endpoint degeneracy and the total-decoder error; do not adopt the BEC display's omitted erasure weight or an unqualified optimizer-uniqueness assertion.

The arbitrary-rate tolerance/derived-boundedness and frequent-gap consequences
are explicit project derivations from the finite converse, not claims that the
references state these exact Lean formulations.
Prior source-reading and visual inspections retain their own evidence and limits.
This handoff adds no fresh textbook inspection claim and copies no textbook proof.

## 5. Prior source-bound completion and qualification

S1–S5 identify the actual completed scoped steps; together they cover 18 criteria.
Their original reports, failures, source limitations and reconciliations remain
unchanged evidence. Their satisfaction is distinct from the fresh cumulative
judgment, which is pending for every row in Section 6.
The completion files below are relative to `.lit-review/setup/`.

| Prior record | Completion file | Original reviewed source R | Original report capture | Final source F | Actual closure |
| --- | --- | --- | --- | --- | --- |
| S1: C23.01 | `c23-01-completion-20261024.json` | `1b3c6ac6aacf628a044d0438ff4417122d36d22707f4993899b502bc45ededb3` | `33a3ca8ab61b72a7b66a154162e679971734abe861efcfce4d905833537b081d` | `d915bb63da0a1edcf47d54d776a1c262d194c290ffa013a209dffb9777d5e446` | `ef8bd0ac9d8e3d8fd9e4c0b8f352c2959f125821dca53f5074f9a29d4674e52c` |
| S2: C23.02 | `c23-02-completion-20261024.json` | `2618c9b1562f59c917c6d2aed1b2c278953886a19ec1e7be7824fa5ac496cca5` | `4348bfbea03b5825f8c180fafe0a40b481b35c98f060c715dce1f6a0e180aab7` | `e59be6f4f3c4affda59314364862470055af51f04e551d55f25871d0da2d018b` | `5e0f0b0341c7b519e135c85b92c4d5b42ab2341ba04f57cfd9c8d2e7ebbce045` |
| S3: C23.03 | `c23-03-completion-20261025.json` | `5a0715cb38bbb7a4a4c6602f46b1e119ff4fb647d5da55d7dd8b5e562a152a99` | `0ca859cd8e475c2646cd34521aa8f489e11a4a1baede413d05c2082821b0936e` | `74290cce1859918d50f99e210a8951ca87fa98e72ffa33569ca1e916b0e130ae` | `b69457637d0a7fde431adde3b0d97e5a86b1ae1ea7b6d4c94cbcf4743669eb13` |
| S4: C23.04 | `c23-04-completion-20261025.json` | `ea441e8f54d95d2ba3d96f4a61a4fe461208ab62e8ed4236f50f9f46d6820a0a` | `5d8b8fd4aebc2bc1db62256ed10b5c0aa702c70a539475d39414b87a0d23eb0c` | `b244b861736768e2955baa68df1151736bd457c654547baa5eb613f36b435ff9` | `7284109da2b6bfc1b3aec2fc76524ce211312d99ec0d0943b677cb110c15a2d1` |
| S5: C23.05 | `c23-05-completion-20261025.json` | `ea32ab4e026967b3279a127ecf9e6c5549d997afc74f926082a586b31ba5c29b` | `bded7be29b38c550be9efd7df5e93f5817957497649130ca7615987411356fbc` | `40ff38fef3719e1dff6658b9a79fd55c3357e196c6c37fb413e298d61695e881` | `bf4814313e103823b52fce6835f0dd25ddcaabbc3ba2a31ecdf3cd1387254f53` |

Step 5's actual full maintained trust returned exit 0 with empty stderr in
2867.5190156000317 seconds; its recorded result SHA-256 is
`3d886d80c878542976d0cd6872f58a63e8c60e17a21b7708b7adea481eda288e`.
It checked all 601 retained types, 57 direct imports, 811 declarations/94 simp
names, 92 root exports/689 exclusions, and 4064 local constants in 106 modules.
Only `propext`, `Classical.choice` and `Quot.sound` occurred.
This is prior working-tree evidence, not a Step 6 clean or API-doc result.

Step 5 also completed its eight-target build, all 36 focused/full-import contract
checks, legacy owner checks, static/generation and nine documentation examples.
Its original report retained ten passing observations and a separate failed
JSON-shape inspection; no criterion received passing credit from that failure.
Earlier proof, binder, import-probe and warning failures remain separate from
their corrected successful results. No failed invocation is relabeled as passing.
Source-derived indexes are not the signature-bearing API-documentation milestone.
The existing C22 API output cannot qualify changed C23 source.

## 6. Exact cumulative all-criterion matrix

The approved plan supplies exactly 21 criteria: 4+4+4+3+3+3.
Each full requirement below is copied verbatim from its normative criterion.
PC/PF/PA mean `Shannon.ChannelCode` / `ChannelCoding` / `ChannelCodingAsymptotic`;
EC/EF/EA are the consumer owners in Section 3.
S1–S5 provide prior original review/source/F/closure identities from Section 5.
Fresh cumulative judgments must come from the new original independent report.
No entry below claims that report exists or predicts its assessment.

| Criterion | Full approved wording | Source/consumer or required evidence anchors | Prior source-bound satisfaction | Fresh cumulative judgment |
| --- | --- | --- | --- | --- |
| C23.01-MODEL | Deliver the transparent block pair with the exact encoder/decoder orientations, explicit positive-budget operational interface, independent alphabet universes and no recovery, injectivity or independence fields. | PC: BlockChannelCode, encoder, decoder; EC: actual_marginals and raw boundary consumers. | S1: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.01-LAWS | Construct `J` and `Q` and prove all message/input/output and pair-marginal identifications in Section 3.1 using existing raw PMF channel constructions, retaining message identity under collisions. | PC: messageOutputLaw, messageInputOutputLaw and all seven marginal maps; EC: actual_marginals, unequal_actual_input. | S1: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.01-ERROR | Identify the same error with the existing Fano PMF/RV/event definitions and the uniform finite average formula; prove its range without a replacement indicator or unjustified probability division. | PC: errorProbability, RV/event/sum equalities and range; EC: actual_error, actual_average. | S1: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.01-BOUNDARIES | Prove and independently consume `M=1` zero error, arbitrary-positive-budget `n=0` error `1-1/M`, and a one-letter law/error reduction. Include the unequal-fiber `Fin 3` noiseless Boolean code: messages 0/1 encode `false`, message 2 encodes `true`, and decoding selects 0/2. Check induced input masses `2/3` and `1/3` and actual error `1/3`, preserving distinct positive-mass colliding messages; no new finiteness/nonemptiness premises on raw laws beyond their construction needs. | PC: singleton/zero/one-length results; EC: singleton_message, zero_length, one_letter_law/average, empty_base_zero_word_error and unequal_*. | S1: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.02-PROCESSING | Establish the two actual-law Markov chains and both information-processing inequalities of Section 3.2, with correct coordinate order and no null-fiber interpretation. | PF: both actual-law Markov theorems and both MI inequalities; EF: repeated_markov_chains and repeated_information_processing. | S2: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.02-FINITE | Prove `(1-Pe)*log M ≤ n*C(W)+log 2` for every natural blocklength and positive message budget, applying existing uniform-source Fano and the existing capacity bound to the actual encoder pushforward. | PF: one_sub_errorProbability_mul_log_le and private actual-input MI bound; EF: repeated_fano_to_capacity and repeated_finite_converse. | S2: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.02-NORMALIZED | Deliver the normalized rate and positive-rate pointwise error bounds with exactly the positivity hypotheses needed for division; preserve `Pe=1` in the undivided result and derive the signs used in multiplication. | PF: normalized and positive-rate error bounds; EF: repeated_normalized_converse, repeated_pointwise_converse and complete_failure_bound. | S2: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.02-CONSUMERS | Consume the complete law-to-Fano-to-capacity chain for a `Fin 4` repeated-bit colliding encoder with a correlated two-letter law and actual error `1/2` over the noiseless Boolean channel; also apply the finite theorem at `M=1`, `n=0` and `n=1` through focused imports. | EF: repeated_supported_collision, repeated_input_correlated, repeated_error, complete Fano/capacity chain and singleton/zero/one bounds. | S2: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.03-BOUNDEDNESS | Derive eventual rate boundedness from the finite bound and vanishing error, with an explicit finite bound and lower/coboundedness justification; no bounded-rate or rate-convergence premise may appear in the result or be hidden in a helper's use. | PA: private eventually_codeRate_le_bound; inspect finite-bound derivation, error times fixed bound, and explicit limsup lower/coboundedness. | S3: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.03-TOLERANCE | Prove every positive-tolerance eventual rate cap in Section 3.3 for one arbitrary dependent code family, allowing arbitrary behavior at finitely many lengths and all positive natural budgets. | PA: eventually_codeRate_le_channelCapacity_add; EA: singleton_family and alternating_public_endpoints. | S3: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.03-LIMSUP | Obtain the real limsup upper bound using the derived boundedness/coboundedness and the tolerance theorem, without identifying real limsup with an arbitrary unbounded-sequence convention. | PA: limsup_codeRate_le_channelCapacity and bounded/cobounded side conditions; EA: singleton_family, alternating_public_endpoints. | S3: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.03-CONSUMERS | Apply both endpoints to actual singleton-message families and a lossless noiseless family with nonconvergent rates (alternating one message and all binary words). Consumer code data, not just scalar sequences, must underlie the applications. An additional genuine finite-prefix mutation and limit-transfer fixture is optional proof-pressure coverage; arbitrary finite-prefix behavior remains part of the required theorem contract, and zero/one-length consumers remain mandatory. | EA: fullWordCode, singleton_family, alternating_error_tendsto_zero, alternating_rates_not_convergent, singleton_zero_one and alternating_zero_one. | S3: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.04-EVENTUAL | Under eventual `R ≤ r n` and `C(W)<R`, prove the exact eventual quantitative lower bound in Section 3.4, an explicit eventual positive error floor and failure of vanishing error, deriving `R>0` rather than assuming a bounded rate family. | PA: three eventual quantitative/floor/nonvanishing endpoints; EA: four_public_eventual. | S4: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.04-FREQUENT | Under a fixed positive rate gap infinitely often, prove failure of vanishing error for arbitrary possibly unbounded rates, using the explicit frequent formulation and no eventual-above-capacity premise or unguarded real limsup. | PA: fixed-positive-gap frequent nonvanishing endpoint; EA: intermittent_public_frequent_obstruction. | S4: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.04-SEPARATION | Provide actual code-family consumers showing the two premises have different consequences. For the eventual premise, use the noiseless Boolean channel with positive capacity `log 2`, budgets `M n = 4^n`, and constant encoding/decoding: prove actual error `1-1/(4^n)` and rate `2*log 2` for `n>0`; specialize the public pointwise bound with `R=2*log 2` to `Pe_n ≥ 1/2-1/(2*n)`, including the finite nonvacuous instance `n=2`, `M=16`, `Pe≥1/4`, and separately apply the public eventual obstruction. For the frequent premise, retain a zero-capacity constant-output channel with singleton budgets on even lengths and `2^(n*n)` on odd lengths. Prove unbounded rate spikes, infinitely many error-zero lengths and no eventual positive error floor. | EA: fourCode_error, four_rate, four_pointwise_bound, four_finite_nonvacuous; intermittent_unbounded_spikes, frequent zero error and no eventual error/rate floor. | S4: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.05-STANDARD | Consume the public coding bound with all four delivered standard capacities. Include one-letter noiseless identity, input-independent output, BSC identity decoding with actual error equal to crossover, and BEC total erasure fallback with actual error equal to half the erasure probability; retain endpoints and at least one interior noisy value. | EF: identityCode/erasureCode, public one-letter law/error applications, four capacity-specialized bounds, endpoint and quarter-noise error/bound fixtures. | S5: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.05-INTEGRATION | Check the complete same-code/same-channel sampling, error, information, rate and limit interfaces; retain both unequal-fiber and correlated collision fixtures, singleton and zero/one lengths, nonconvergent lossless rates, the positive-capacity finite/eventual obstruction and unbounded intermittent-rate consumers from prior steps. The additional finite-prefix mutation fixture remains optional. Do not substitute generic scalar inequalities or import example-private helpers into production. | EA: alternating_complete_interface on actual alternatingCode/noiseless data; retain EC unequal fibers, EF correlated collisions and every earlier EA fixture. | S5: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.05-API | Reconcile actual public names/types/owners/direct imports/simp sets, source adaptations, generated inventory and website references; verify focused downstream usability and preserved historical/root contracts, with helpers kept private absent concrete consumer pressure. | All 36 actual contracts/owners/attributes through focused/full imports, current inventory/import policy, codeRate/Units ownership, frozen/root contracts and source/reference indexes. | S5: SATISFIED at its original source; preserve report and final applicability. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.06-VALIDATION | Qualify the complete candidate with the maintained clean suite on a separately authorized exact clean checkpoint, rerunning it after every amendment; complete the separately authorized current two-pass API-documentation milestone and inspect every new rendered signature, hypothesis, docstring, owner and source link. Preserve failures and distinguish new checks from reused applicable evidence. | New exact clean candidate and maintained clean result; separately approved two-pass API result and all 36 rendered inspections. Prior Step 5 working-tree trust is supporting history only. | No prior Step 6 assessment. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.06-READINESS | Before cumulative dispatch, finish owned edits, retain actual validation, contextual self-review and separate reassessment, and reconcile earlier accepted reports/findings at their actual sources. Supply a neutral current-source request and an exact matrix of every approved C23 criterion, without claiming a future review outcome. | Complete current source/evidence matrix; initial validation, contextual self-review, separate reassessment and substantive prior-report reconciliation before neutral cumulative dispatch. | No prior Step 6 assessment. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |
| C23.06-HANDOFF | Maintain `docs/handoffs/chunk-23.md` and canonical links before final capture, recording delivered APIs/imports/consumers, mathematical adaptations, review/validation identities and limits, unresolved/deferred dispositions with owners and triggers, and C24 prerequisites. Make no release, operational-capacity-equality or publication claim. | This handoff and canonical links finalized before capture; actual qualification/review/applicability identities, retained limitations and owned C24/deferred dispositions. | No prior Step 6 assessment. | Determined only by the genuine original cumulative report linked from actual `.lit-review/setup/c23-06-completion-20261025.json`; no assessment predicted. |

The reviewer must assess all 21 rows, including validation, readiness and handoff.
The parent must substantively reconcile every original criterion and finding,
not infer cumulative acceptance from the earlier 18 satisfied rows.
A material gap or contradiction requires a satisfactory new assessment;
an implementer explanation cannot override it.

## 7. Recorded initial milestones and remaining cumulative duties

The separately approved initial scoped checkpoint `beb99362718489c17dfe150e5c8be0281ab34aa3` passed the complete maintained clean routine. The current local two-pass API build/check gate passed, and the parent substantively inspected all 36 new rendered signatures, hypotheses, result types, docstrings, owners and source links.

Actual approval/candidate/clean/API/extraction/inspection/applicability paths and hashes are retained in notes Section 23. This initial evidence qualifies only its recorded candidate.

Every bounded amendment, including these documentation updates, requires the entire clean rerun and renewed API applicability before R; rerun the API gate if invalidated. Fresh original review of all 21 criteria, substantive all-criterion reconciliation and final qualification/applicability/capture remain pending. Only actual `.lit-review/setup/c23-06-completion-20261025.json` and its linked genuine original records determine completion; no cumulative SAT assessment or future result is predicted.

Before R, finish the owned documentation amendment, rerun the entire clean routine, renew API applicability, and complete contextual self-review and separate reassessment. Then capture R and dispatch a neutral exact-source request for the same reviewer’s fresh all-21 report. Retain and substantively reconcile every criterion, original report, finding and stated limit. A reviewer gap requires a new satisfactory assessment; no implementer override is inferred.

Preserve frozen release artifacts, pins, root/import/simp boundaries and original failures. Final validation and exact R-to-F correspondence precede supported closure; do not edit captured source after F.

These are warm/cached local checks with file-mode owner links; no cold build, browser visual QA, GitHub line-range verification, operational-capacity equality or publication is claimed. Original failures retain their recorded outcomes.

## 8. Explicit dispositions, owners and triggers

| Disposition | Owner and trigger |
| --- | --- |
| Additional finite-prefix mutation fixture remains optional | Asymptotic consumer owner; add only if limit-transfer proof pressure or a concrete regression warrants it. Unrestricted finite-prefix theorem semantics and zero/one checks already remain required. |
| Extra BEC half-erasure n=4/M=16 fixture remains deferred | Consumer owner; reconsider if a noisy multi-letter specialization exposes a distinct gap. The present positive-capacity noiseless finite bound and standard BSC/BEC actual-error checks cover the approved commitments. |
| Derived-bound, MI glue, mass/parameter/equivalence helpers remain private | Future API owner; promote only after concrete downstream use and explicit growth review. No alias or simp quota is inferred from the handoff. |
| Non-stable generated-equation observations remain scoped | Maintenance owner; revisit if supported ownership policy expands or an actual consumer failure provides pressure. Do not claim global uniqueness across Shannon-plus-Examples. |
| Current-status links and historical headings are reconciled during preparation | C23.06 documentation owner maintains notes/roadmap/current canonical fronts through final capture, preserving dated original snapshots and source-bound reports. |
| Initial clean/API/all-36 inspection milestones recorded; keep each candidate current | C23.06 parent: every bounded amendment requires the entire clean rerun and renewed API applicability before R. Fresh all-21 review and final closure depend on their actual original records. |
| Achievability, operational-capacity equality, channel strong converse, maximal-error equivalence, randomized/list decoding, feedback, costs and infinite alphabets remain outside C23 | Future programme owner after a separately approved contract. Exact noiseless test codes do not establish a general achievability theorem. |
| Local C23 checkpoints approved; publication and external-project changes remain unauthorized | Exact scoped local checkpoints/necessary bounded amendments and local clean/API milestones are approved. Push, tag, release, Pages, DOI, C24 and PFR/ShannonCert upgrades need separate authority. |

## 9. C24 prerequisites and boundary

The proposed C24 scope is in the [programme map](../plans/post-release-chunk-map.md).
There is no dedicated approved C24 plan at this snapshot.
C23 completion does not select C24; it supplies interfaces and evidence for planning.

C24 should first verify actual C23.06 completion and current-source applicability,
then audit every agreed programme endpoint against source and independent consumers:
coupling-to-continuity, correlated-input single-letterization, full source coding,
attained information capacity and the channel weak converse.
It must reconcile earlier handoffs and limitations, not introduce a new theorem
programme through release cleanup or reinterpret source strong converse as channel strong converse.

Its separate reviewed contract must cover candidate versioning, current/stable API
documentation, migration/release metadata and an external consumer of the candidate.
Preserve exact v0.1.0 artifacts and the versioned website route.
Do not silently upgrade PFR or ShannonCert.
Contributor guidance is optional if outreach is selected; website redesign and
automatic publication are not implied.
The scoped local C23 checkpoint and necessary bounded amendments are approved; push, tag, release, Pages, DOI and external upgrades still require separate authority.

The intended exit is an independently reviewed qualified candidate with stated
limitations. Publication is a later decision.
Initial gates are recorded at their actual candidate. Fresh cumulative review, substantive
reconciliation and final qualification/closure remain pending; this handoff predicts no outcome.
