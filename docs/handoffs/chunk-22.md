# C22 handoff: attained finite-channel information capacity

Maintained handoff, 2026-10-24: qualification and readiness evidence prepared;
closure is subject to the actual private completion record. C22.01–C22.07 have actual
source-bound completion records. The lead approved the exact 26-path checkpoint,
bounded review/evidence amendments, existing validation checkout and separate
current two-pass API gate. The initial full clean routine and both API passes
completed; the parent read all 26 actual elaborated declaration blocks.

Every amendment requires a complete clean rerun and renewed API applicability.
Actual candidate qualification, source-bound independent review of all 26
criteria, substantive reconciliation of every report and finding, final
applicability and closure are established only by
`.lit-review/setup/c22-08-completion-20261024.json` and its linked evidence.
Earlier results do not automatically qualify changed inputs. This wording
asserts no future review result or closure; C23 has not started and publication
is not authorized.

## Delivered mathematics and contracts

Finite channels remain functions `A → PMF B`. The canonical objective is
`mutualInfo (PMF.channelJoint p W)` and all information quantities are real
nats. `channelCapacity W` is precisely the real supremum of the range of
that objective over all `p : PMF A`. It explicitly binds `[Fintype A]`,
`[Nonempty A]` and `[Fintype B]`, with independent alphabet universes.
There is no capacity convention on an empty input alphabet. A supplied row
derives output nonemptiness internally when needed.

The core supplies the bound for every input, the universal-upper-bound iff,
an actual attaining PMF, nonnegativity and both log-cardinality bounds.
Attainment uses the existing finite-PMF compact domain and continuous objective;
boundedness or concavity alone is not used to assert existence. Simultaneous
relabeling pushes the input law by `e` and uses rows `W (e.symm a')` followed
by output pushforward. Input nonemptiness is transported locally. Stochastic
composition and arbitrary output maps cannot increase capacity.

Finite dependent product capacity equals the sum of coordinate capacities.
The upper bound first applies the C18 arbitrary-input bound to the actual
coordinate marginals of every joint input law. The lower bound chooses actual
coordinate maximizers and uses their existing `PMF.finiteProduct` law. No
independence hypothesis restricts the capacity domain. Repeated capacity is
`(n : ℝ) * channelCapacity W` for every natural `n`, and `PMF.iid p n`
attains it whenever the supplied `p` attains one-letter capacity.

The four standard capacities are:

| Channel | All-input objective / universal bound | Capacity and specified attaining law |
| --- | --- | --- |
| `PMF.deterministicChannel id` | `I(p,W) = entropy p ≤ log(card A)` | `log(card A)`; actual uniform law |
| `fun _ : A => r` | `I(p,W) = 0` | zero; every input law, including a pure witness |
| `PMF.binarySymmetricChannel ε hε` | output entropy minus `Real.binEntropy (ε : ℝ)`, bounded by `log 2` minus that term | `log 2 - Real.binEntropy (ε : ℝ)`; uniform Bool law |
| `PMF.binaryErasureChannel ε hε` | `(1 - (ε : ℝ)) * entropy p`, bounded by `(1 - (ε : ℝ)) * log 2` | `(1 - (ε : ℝ)) * log 2`; uniform Bool law |

The raw binary constructors use `ε : NNReal` and `hε : ε ≤ 1`. Their first
binary-mixture branch has weight ε: complemented input for BSC, `none` for
BEC. BEC's second branch is `some a`; no alternate channel or noise-law
abstraction is introduced. Four `_bits` equations apply the existing scalar
`natsToBits`, yielding log base 2 of input cardinality, zero,
`1 - natsToBits (Real.binEntropy (ε : ℝ))`, and `1 - (ε : ℝ)` respectively.
No second capacity definition is introduced.

## Exact public surface and focused imports

The approved 26 additions occupy exactly four owners. Current source-derived
inventory is 775 public declarations in 54 supported owners; root exports are
92 and reviewed simp names 94. The actual full clean routine supplies compiled
qualification at its recorded candidate; this document itself is not that evidence.

`LeanInfoTheory.Shannon.ChannelCapacity` exports these ten names in
`LeanInfoTheory.Shannon`:

- `channelCapacity`
- `mutualInfo_channelJoint_le_channelCapacity`
- `channelCapacity_le_iff`
- `exists_mutualInfo_channelJoint_eq_channelCapacity`
- `channelCapacity_nonneg`
- `channelCapacity_le_log_card_input`
- `channelCapacity_le_log_card_output`
- `channelCapacity_congr_equiv`
- `channelCapacity_channelComp_le`
- `channelCapacity_map_output_le`

Its direct imports are `LeanInfoTheory.Shannon.Topology`,
`LeanInfoTheory.Shannon.EntropyBounds` and
`LeanInfoTheory.Shannon.SemanticBridge.Markov`.

`LeanInfoTheory.Shannon.ProductChannelCapacity` exports three names in
`LeanInfoTheory.Shannon`:

- `channelCapacity_productChannel`
- `channelCapacity_memorylessChannel`
- `mutualInfo_channelJoint_memorylessChannel_le`

Its direct imports are `LeanInfoTheory.Shannon.ChannelCapacity` and
`LeanInfoTheory.Shannon.SemanticBridge.ProductChannel`. The dependent product
retains independent index/input/output universes, and no public DecidableEq,
positive-length or independent-input premise is added.

`LeanInfoTheory.Probability.StandardChannels` exports only
`PMF.binarySymmetricChannel` and `PMF.binaryErasureChannel`. Its sole direct
import is `LeanInfoTheory.Probability.FiniteMixture`; it stays below Shannon.

`LeanInfoTheory.Shannon.StandardChannelCapacity` exports eleven names in
`LeanInfoTheory.Shannon`:

- `channelCapacity_deterministicChannel_id`
- `channelCapacity_const`
- `mutualInfo_channelJoint_binarySymmetricChannel`
- `channelCapacity_binarySymmetricChannel`
- `mutualInfo_channelJoint_binarySymmetricChannel_uniformOfFintype`
- `mutualInfo_channelJoint_binaryErasureChannel`
- `channelCapacity_binaryErasureChannel`
- `channelCapacity_deterministicChannel_id_bits`
- `channelCapacity_const_bits`
- `channelCapacity_binarySymmetricChannel_bits`
- `channelCapacity_binaryErasureChannel_bits`

Its direct imports are `LeanInfoTheory.Probability.StandardChannels`,
`LeanInfoTheory.Shannon.BinaryEntropy`, `LeanInfoTheory.Shannon.ChannelCapacity`,
`LeanInfoTheory.Shannon.SemanticBridge.Convexity` and
`LeanInfoTheory.Shannon.Units`. The noiseless call is
`channelCapacity_deterministicChannel_id (A := A)`; the constant call is
`channelCapacity_const (A := A) r`. Binary objective arguments are `p ε hε`;
capacity and BSC-uniform arguments are `ε hε`. Bits capacity arguments agree
with their nats counterparts.

All four owners are included by the full `LeanInfoTheory.Shannon` umbrella.
The lightweight root still imports only `Probability.Finite` and
`InformationMeasures`; the existing semantic aggregate does not import capacity.
There are no added public optimizer, row-mass, symmetry, concavity, conversion
helper or simp declarations. Existing `PMF.binaryMixture_apply` and transparent
constructors suffice for the concrete raw consumers.

## Permanent consumers and boundary evidence

All added consumer declarations remain private and are included only through
the non-stable `LeanInfoTheory.Examples` aggregate.

| Consumer | Direct imports and useful coverage |
| --- | --- |
| `Examples.ChannelCapacity` | Core capacity, Convexity and `Mathlib.Logic.Equiv.Fin.Rotate`. Reuses the same extracted maximizer, checks pure ternary zero masses, singleton input/output, absent empty-input laws and impossible empty-output rows; tests both one-sided relabelings and a Fin 3 cycle with masses 1/2, 1/6, 1/3 and distinct rows; proves the inverse convention changes a joint atom and output mass if reversed; includes a non-pure stochastic stage, noninjective collapse and mixtures of achievers at all weights including 0/1. |
| `Examples.ProductChannelCapacity` | Sole focused `Shannon.ProductChannelCapacity` import. Actual selected and supplied product witnesses, iid repetition of any supplied achiever, heterogeneous alphabets, a duplicated fair-bit correlated law with strict objective-capacity gap, singleton/empty products, n=0/n=1 and the vacuous Empty-to-Empty base repeated zero times. Also supplies the C23-facing consumers below. |
| `Examples.StandardChannels` | Sole probability-only `Probability.StandardChannels` import. Exact BSC crossover/retention masses and identity/complement endpoints, half-noise constant rows; exact BEC erasure/transmission/absent-symbol masses and zero/full-erasure endpoints. |
| `Examples.StandardChannelCapacity` | Focused `Shannon.StandardChannelCapacity` and `Shannon.ProductChannelCapacity` imports. Actual noiseless/BSC/BEC uniform witnesses, every-input constant attainment, explicit pure input with non-pure output, sparse Fin 3 law, singleton cases, BSC 0, 1/2, 1 and BEC 0, 1 degeneracies, biased laws, and bits product/repeated/attainment/arbitrary-input conversions. |

BSC's direct public uniform-attainment equation is consumed as such. BEC's
uniform witness is derived only from its public all-input objective formula,
uniform entropy and capacity formula. Every input attains the zero capacities
at BSC ε=1/2 and BEC ε=1. Uniform optimizers are not asserted unique.
The BEC sparse Boolean case uses a pure input with the other input atom and
its impossible transmitted output atom zero. No probability division or
null-fiber interpretation is used. A separate Fin 3 sparse law has masses
1/2, 1/2, 0 for noiseless and constant consumers.

For the common biased Boolean input with true mass 1/4 and false mass 3/4,
BSC ε=3/4 has output true mass 5/8 and objective
`Real.binEntropy (5/8) - Real.binEntropy (3/4)`. BEC ε=1/3 has output masses
1/3 at none, 1/6 at some true and 1/2 at some false, with objective
`(2/3) * entropy p`. Mass statements are checked after `ENNReal.toReal`.

The empty dependent product and zero-letter spaces are inhabited singleton
word domains. The vacuous `Empty → PMF Empty` base is only used at blocklength
zero, and its base capacity is never formed. General repeated theorems keep
the explicit nonempty base-input premise even at n=0.

## Sources and adaptations

Use the exact editions/hashes in [references](../references.md), the
[approved plan](../plans/post-release-chunk-22.md) and its
[notes](../plans/post-release-chunk-22-notes.md).

- CT91, Wiley 1991, §§8.1–8.3, printed 184–191 / PDF 206–213:
  information-capacity definition, examples and alphabet bounds. Convert its
  bits convention to nats. Finite attainment is proved by compactness and
  continuity; boundedness alone is insufficient. The general weak-symmetry
  theorem and operational coding equality are not delivered by C22.
- CT91 §2.8, printed 32–33 / PDF 54–55, and PW24 Theorem 5.3, printed
  92–93 / PDF 117–118: existing DPI and concavity support processing and the
  private mixture-of-achievers consumer. PW24 Theorem 5.4 assumes a maximizer;
  it is not the attainment argument used here.
- PW24, August 16, 2024 draft, §6.1, Theorem 6.1(a) and Example 6.1,
  printed 106–107 / PDF 131–132: arbitrary-input product upper bound,
  independent achieving construction and duplicated-bit strict gap. Input
  independence is sufficient for the lower witness, not a necessary condition
  on maximizing inputs or the supremum domain.
- CT91 §§8.1.4–8.1.5 and PW24 §19.3: BSC/BEC values. Preserve the full closed
  parameter interval and zero masses. The PW24 BEC display omits the erasure
  weight in its conditional-entropy expression; the implemented all-input
  identity is exactly `(1-ε)H(p)`. Its unqualified uniform-only equality
  wording is not valid at the all-erasure endpoint; similarly BSC half-noise
  admits every input. No optimizer-uniqueness theorem is claimed.

The support agent `/root/c22_examples_audit` freshly read registered-hash
CT91 PDF 206, 209–210, 212–213 and PW24 PDF 117–118, 131–132, 405 as text
during this preparation. This is not a claim of fresh parent reading or
visual PDF inspection. The exact hashes, pages and extracted text are retained
privately in `c22-08-source-reading-20261024.json`. Earlier recorded readings
retain their exact actor and scope.

## Prior scoped qualification and the C22.07 correction

Actual records `c22-01-completion-20261024.json` through
`c22-07-completion-20261024.json` under `.lit-review/setup/` each record
`SUPERVISED_STEP_COMPLETE`, their source-bound original review, final F,
criterion assessments and validation references. The criterion counts are
4, 3, 4, 3, 3, 3, 3 respectively. Their original reports remain reports about
their own source bindings; several honestly describe parent trust as still
pending at review time. Later completed trust and final applicability are
separate evidence in each completion chain, not edits to those reports.

The Step 7 initial trust run actually failed after all 601 retained signatures
matched: duplicate generated `natsToBase.eq_1` and `natsToBits.eq_1` ownership
in CodingRate and StandardChannelCapacity contradicted the supported compiled
owner check. The original report capture
`018cd4a01a0b8e31a9569f5bdf131d7ecacdd8f19ae4cc1bb6e977b8ba7d2b74`
at source
`019ceeb5d3f0cf5a7abf8b3c19ef5dc4117d2fe0a288617531a06b8efe1a9e2a`
assessed BITS/C23 SATISFIED and API CONTRADICTED_BY_FINDING, material finding
`lit-finding:C22.07-compiled-units-owner-collision`. Both that finding and
the failed `.lit-review/setup/c22-07-trust-initial.json` remain preserved.

The correction changed only the four new bits proof bodies to use definitional
quotient goals and algebra instead of realizing Units equation helpers. Public
statements/imports, previous proofs, Units, CodingRate, consumers, validator and
pins were preserved; source-derived indexes were regenerated. The unchanged
maintained full trust audit then passed in `c22-07-trust-repaired.json`, with
601 retained signatures, 775 declarations/54 owners, root 92, simp 94 and
the allowed-axiom audit. The fresh original report capture
`277f9bf0b5666eef41fe25dc29f0d558457de5b40432a7ddbc1b193b52868064`
at repaired source
`ab6903ae8020c8fb822f2ab4f03efcb039a69fdaec18e62d2ff157ab6fc0abbe`
assessed all three criteria SATISFIED with no findings. The actual Step 7 F is
`38246475df1260ab7e3f5c4f6fc0fa97d0f2480e5f50f7e759ef4b2f2d80a86c`.

The repair resolves the supported production-owner collision. The reviewer
also observed generated copies in non-stable Examples.StandardChannelCapacity;
no global ownership-uniqueness claim across Shannon-plus-Examples is made.
The all-project trust audit checks axioms, not universal compiled ownership.
Reviewer harness failures remain failed checks and are not passing evidence.

The private cumulative matrix draft retains exact prior review/source/F/closure
references and a current source-to-criterion map. Its support inspection does
not itself establish C22.08 readiness, a cumulative reviewer assessment or
clean/API-documentation qualification.

The raw consumer's module synopsis now mentions its existing BEC checks as
well as BSC. Imports, declarations and proofs are byte-preserved. Its whole-file
hash changed, so Step 7's old compiled identity was not transferred wholesale:
fresh focused checks and the current clean/API records cover the new bytes.

## C22.08 recorded qualification and conditional completion

The approved checkpoint excludes `.gitignore`, `AGENTS.md`,
`docs/next-website-tasks.md` and exactly the pre-C22 relocation-log entry.
Their primary working bytes are preserved. The existing registered detached
validation checkout holds the exact local candidate. The full maintained
routine covers static/generated checks, maintained warning-as-error builds,
documentation examples, exact direct-import/API/simp/root boundaries, all 601
retained signatures and the all-project allowed-axiom audit. Actual outputs,
candidate identities and primary/clean correspondence are retained privately.

The separately authorized API command completed two build/check passes with
reviewed Zig 0.16.0 and local file links. The parent inspected all 26 rendered
signatures/hypotheses/types/docstrings/owners/source links, separately from the
automated coverage gate. Exact content/configuration/dependencies, attestation
and relevant output determine later applicability. Full output-tree digest is
retained from the actual gate; later applicability checks freshly rehash the
relevant output. No cold-build or browser visual-QA claim is made.

Initial milestone records: `.lit-review/setup/c22-08-checkpoint-01/full-clean/result.json` and `.lit-review/setup/c22-08-api-retry-02-20261024/result.json`; actual semantic
inspection: `.lit-review/setup/c22-08-api-parent-inspection-20261024.json`. Subsequent amendment/clean/applicability records
govern the current candidate. Actual cumulative independent review of all 26
criteria, substantive reconciliation of every prior report and finding, final
source applicability and closure are established only by
`.lit-review/setup/c22-08-completion-20261024.json` and its linked evidence.
This wording asserts no future outcome. Every actual amendment requires the
complete clean routine again and renewed API applicability; initial results
alone do not qualify later writes. Original failures and source-specific report
limitations remain unchanged evidence, including the C22.07 supported-ownership
repair boundary.

## C23 interface and explicit dispositions

The following existing calls are the required C23 handoff:

```lean
mutualInfo_channelJoint_le_channelCapacity p W
mutualInfo_channelJoint_memorylessChannel_le W n q
```

The first concludes `mutualInfo (PMF.channelJoint p W) ≤ channelCapacity W`.
The second concludes
`mutualInfo (PMF.channelJoint q (PMF.memorylessChannel W n)) ≤
  (n : ℝ) * channelCapacity W`
for arbitrary `q : PMF (Fin n → A)`, including n=0 and n=1. Both retain
finite input/output alphabets and nonempty base input, with independent
universes and no iid or encoder-injectivity premise. Import
`LeanInfoTheory.Shannon.ProductChannelCapacity` to obtain both.

The permanent C23 consumer chooses independent fair message bits, discards
the second bit and repeats the first. Its actual `messages.map (repeatedFirst n)`
is valid for every n. At n=2 it equals the diagonal fair-bit law and differs
from the product of its actual marginals; the public bound applies directly.
These are input-law consumers, not a channel-code abstraction or coding theorem.

| Disposition | Owner and trigger |
| --- | --- |
| Authorized initial clean/API milestone checks and all 26 rendered inspections completed; keep each candidate current | C22.08 parent; full clean rerun after every amendment and renewed exact API applicability, rerunning the gate if invalidated |
| Maintain this handoff and canonical links before final capture; actual completion is determined by the private record | C22.08 parent, within owned documentation edits; actual material corrections require renewed qualification, while a clean review may permit finalization with no source changes |
| Obtain the genuine fixed-source cumulative report, reconcile all 26 criteria and prior accepted reports, then final validation/F/closure | C22.08 parent and bound independent reviewer through the supported workflow; no implementer-only override of a gap or contradiction |
| Retain the non-stable Examples generated-equation observation | Maintenance owner; reconsider only if the supported ownership policy expands to those environments or a real consumer failure supplies pressure |
| Keep raw mass lemmas, conversion glue and optimizer helpers private | Future API owner; promote only after repeated concrete consumer need and explicit growth review |
| Channel codes and Fano weak converse | C23, only after separate planning/implementation authority, using the two arbitrary-input bounds above |
| Operational capacity equality/achievability, general weak symmetry, constrained/infinite capacity, uniqueness, algorithms, minimax, Z-channels, feedback and strong converses | Outside C22; require their own scoped decision, not inferred from the four examples |
| Integration and release qualification | C24 then separately authorized release/publication; no release is authorized here |

C23 has not started. C22 information capacity supplies its needed interface;
it does not establish equality with operational capacity.
