# Programme comparison with the first release

This account describes the current C9-C23 mathematical programme during C24.03.
The [acceptance ledger](c24-programme.md) and actual source-bound review records
determine qualification. C24.03 acceptance and closure are established only by
the actual `.lit-review/setup/c24-03-completion-20261026.json` and linked originals
when present. Candidate identity, complete retained-baseline capture, external
package use, clean/API milestones and final release handoff belong to later steps.

## Baseline and measured growth

The first-release baseline is commit
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f`, with annotated `v0.1.0` tag object
`bcd9090ea2720fe14b0a3e168c76ebeef1dafd47`. Current mathematical source is the
working source admitted at C24.03 B
`e18672fb6063d877dd52a0e037effa042a3eb4f51732e67db019a09283f774ee`, over HEAD
`b577679892f4db40cfad480e0f487184ed91d4d5`. No new release or public commit
availability is asserted by this comparison.

| Measure | Released baseline | Current programme |
| --- | ---: | ---: |
| Supported declarations | 601 | 811 |
| Supported modules, including mathematical umbrellas | 31 | 57 |
| Theorems | 535 | 716 |
| Definitions | 56 | 75 |
| Abbreviations | 9 | 17 |
| Instances | 1 | 3 |
| Lightweight-root exports | 92 | 92 |
| Reviewed public simp declarations | 94 | 94 |

There are 210 additions, a 34.94% increase. The earlier rough-doubling estimate
is not met. Mathematical usefulness and the agreed endpoint scope govern the
programme; no extra family or alias is introduced to meet that estimate.

All 601 released names remain, with identical generated declaration metadata.
The lightweight root retains its two direct imports and 92 exports. These are
inventory and architecture observations. Compiled retained-type checks and
statement/producer/consumer inspection supply separate compatibility evidence.

## What the programme supplies

The released library already contained finite probability and PMF-valued channels,
nats-valued entropy/information measures, conditional/KL interpretations,
independence, finite-family identities, Markov/data processing, sufficiency and
Fano. The following additions extend that foundation through focused imports.

| Programme family | Delivered mathematical content and useful composition | Boundaries retained |
| --- | --- | --- |
| C9 processing and decomposition | Arbitrary-type deterministic independence processing and finite information decomposition with ordered conditioning. | No new measurable-space or global finiteness premise on the arbitrary-type processing endpoint. |
| C10-C12 total variation and coupling | Half-L1 TV with event/test characterizations and transport; maximal disagreement coupling; support-local extension and adjacent-law gluing. The actual maximal joint and its swap supply Fano applications in continuity. | Sparse/equal/singleton laws and null conditional rows remain explicit. A glued endpoint need not be maximal. |
| C13 Pinsker and quantitative independence | Canonical ENNReal Pinsker, guarded Real/square-root consequences and distance of an actual joint from its own marginal product. | Singular KL may be top; Real conversion is guarded. Bounded and signed tests retain their different constants. |
| C14-C15 continuity and topology | Exact-TV entropy bounds, a capped monotone budget modulus, finite conditional-information bounds and finite-PMF topology/compactness with continuous actual MI objectives. These supply capacity's actual optimizer. | Singleton/saturation/support boundaries remain. There is no unrestricted conditional-law continuity theorem or general equality classification. |
| C16-C18 products and channel information | Dependent products, selected-coordinate transport, iid laws, raw conditional product channels and exact joint projections; product entropy/KL and information bounds on actual input/output laws. | Repeated coordinates require their correct hypotheses. Raw channels need finite outputs; correlated input is allowed in the upper bound. Equality uses full output independence. Independent-source observation bounds use a distinct source premise. |
| C19 AEP and typicality | Supported block self-information, finite-moment/Chebyshev AEP on the varying word spaces, strict supported typical sets and probability/atom/cardinality estimates. | No off-support log identity, fixed infinite probability-space assumption, stationary/ergodic extension or general error exponent is asserted. Width, length and deficit guards remain visible. |
| C20-C21 source coding | Total deterministic finite codes, actual Fano error, selected-set recovery and success counting, natural budgets/rates/rounding/binary padding; one-family above-entropy achievability, source strong converse, necessary rates for arbitrary reliable families and an IsGLB threshold. | Private rounded-family facts are distinct from public existential guarantees. No exact-rate-at-entropy attainment, efficient encoder claim or rate-convergence assumption is added. The model is fixed-length. |
| C22 information capacity | A nonempty finite input domain, a genuinely bounded objective range and compactness/continuity give an actual maximizing PMF. Arbitrary correlated block inputs obey the product upper bound; genuine coordinate maximizers give attained product/repeated equalities. Noiseless, input-independent, BSC and BEC values have actual attaining laws. | Information capacity is separate from operational coding capacity. Sparse laws, empty product indices, zero words, all crossover/erasure endpoints and nonunique zero-capacity attainment remain included. |
| C23 channel weak converse | Uniformity is over message indices. Actual code laws preserve collisions and induce the encoder pushforward, which need not be uniform or iid. Fano, Markov/DPI, the actual-q capacity bound and shared rate compose on the same code. | The undivided bound includes zero length and error one. Division needs positive length/rate. Arbitrary-family real limsup uses derived boundedness and lower control. Frequent gaps imply nonvanishing without an eventual error-floor assertion. |

The permanent channel consumers include unequal encoder fibers with masses 2/3
and 1/3 and actual error 1/3, a correlated repeated-bit collision, lossless
nonconvergent rates, a positive-capacity eventual obstruction and unbounded
intermittent spikes with infinitely many zero-error lengths. Those examples
distinguish the actual contracts from stronger false replacements. The extra
C23 finite-prefix mutation fixture remains optional under its approved criteria;
the theorems themselves allow arbitrary finite-prefix behavior.

## Compatibility, evidence and remaining duties

The [frozen manifest](../v0.1-public-api.json) and
[historical retained contract](../compatibility/v0.1.0-retained-contract.json)
remain protected. Their retained types/imports and the current names, owners,
root exports and simp policy have actual compiled evidence, reused only after
checking its unchanged maintained source/configuration/dependency inputs.
The broader historical trust observation still has its disclosed two incidental
fixture-file differences. Input applicability is a fresh identity comparison,
not a new execution of the full trust gate.

The three signature audits cover all 210 programme additions and four retained
producer interfaces: [quantitative](c24-quantitative-signatures.json),
[products/source](c24-products-source-signatures.json) and
[channels](c24-channel-signatures.json). Their 214 distinct types are audit
evidence. C24.04 must still implement the complete supported candidate's retained
baseline, including universes, ownership, imports and reviewed attributes, and
the new-type drift regression. The old 601-type baseline remains separate.

No breaking mathematical/API migration is selected in this step. Compatible
growth evidence does not by itself choose the new package version, finalize
release metadata or qualify a changed future candidate. Existing public names,
argument forms and the probability/lightweight/heavy semantic split are retained;
no application-specific certificate interface is introduced upstream.

The complete crosswalk contains 260 execution criteria plus 16 named C9 items,
mapped to 216 stable rows. C24.03 enriches 43 rows and requires an original review
of those rows plus the four earlier integration rows, giving 47 current original
assessments and all six integration chains. The 148 earlier row objects stay
unchanged; the 25 remaining historical/process rows retain their C24.09 owner
and unassessed status. Their explicit disposition inventory is part of coverage,
without predicting their later acceptance.

Source/module/header/consumer inspection and focused compilation establish the
meaning and usability of this mathematical package. Inventory counts alone do
not prove semantic compatibility, and this account does not assert equality of
every retained definition body with the released source. Earlier proof reviews,
current exact types and actual same-object consumers have separate roles.

The local comparison preserves the existing frozen-manifest bytes: its working
copy SHA256 is `d4c5bfa78588de605798f568b312a4cef2896855e36d3c983849270181e397be`.
The release Git blob SHA256 is
`3201ced98b4516e9ef4bda166e75f667f47fe61e530d85af235b410894a7dd03`.
They have identical JSON and exact CRLF-to-LF byte correspondence. Neither copy
was rewritten to obtain the comparison. This is local Git evidence, not a fresh
remote-publication check.

Channel-coding achievability, operational channel-capacity equality, the channel
strong converse, general maximal-error equivalence, randomized/list decoding,
feedback/cost constraints, infinite alphabets, variable/prefix coding and
stationary/ergodic AEP remain outside the programme. The source strong converse
does not supply a channel strong converse. Later clean/API/external-package and
release-handoff qualification must identify their actual final candidate and
requalify affected evidence after amendment.
