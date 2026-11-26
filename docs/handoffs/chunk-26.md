# Chunk 26 — finite Neyman–Pearson testing

**Status: maintained source handoff; cumulative completion follows the private record.**
C26.01–C26.05 have supported closure records and reconciled independent reviews.
The new conditional instruction selects C26.06 after checking C26.05's actual
closure and exact final source. This handoff records delivered mathematics and
cumulative qualification requirements. It predicts no clean-suite result,
independent verdict or chunk closure. Actual candidate, checks, original report,
reconciliation and supported completion are retained under
`.lit-review/setup/c26-06-20261107/`; `completion.json` there is the maintained
pointer when established. C27 remains unselected.

The [approved revision 2 plan](../plans/release-3-chunk-26.md) supplies all twelve
criteria. The [implementation notes](../plans/release-3-chunk-26-notes.md)
preserve adaptations, source/evidence mappings, earlier findings and dispositions.
The [revision 3 programme map](../plans/release-3-chunk-map.md) remains advisory.

## Interface and import boundary

Import `LeanInfoTheory.Probability.NeymanPearson` for the threshold rule and
finite prescribed-level theorem. Its sole direct import is
`LeanInfoTheory.Probability.BinaryTesting`. The local dependency chain is
NeymanPearson → BinaryTesting → TotalVariation → Finite; it imports no project
coding module. `LeanInfoTheory.Shannon` exposes the complete testing interface.
`LeanInfoTheory` stays lightweight: two direct imports, a five-module closure
and 92 root exports, with testing excluded. The permanent private consumers in
`LeanInfoTheory.Examples.NeymanPearson` import only the focused owner and belong
to the development Examples aggregate, outside both supported umbrellas.

Reuse C25's `PMF.BinaryTest X = X → Set.Icc (0 : ℝ) 1`. Test value one rejects
the null law. `size f P0` and `power f P1` are real finite sums of rejection
probabilities under their respective laws; `typeIIError f P1 = 1 - power f P1`.
C26 adds exactly four supported declarations, with no new instance or simp rule.
The supported inventory is 832 declarations in 59 modules, retaining the 94
reviewed simp declarations. The historical 601 and 811 contracts and all 828
C25 declarations remain separate compatibility obligations.

The following are the actual public headers in namespace `PMF.BinaryTest`,
with `{X : Type u}` and `open scoped NNReal`. The first two require no finiteness.

```lean
noncomputable def likelihoodThresholdTest (P0 P1 : PMF X)
    (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1) : PMF.BinaryTest X

theorem likelihoodThresholdTest_apply (P0 P1 : PMF X)
    (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1) (x : X) :
    (likelihoodThresholdTest P0 P1 c γ x : ℝ) =
      if (c : ℝ) * (P0 x).toReal < (P1 x).toReal then 1
      else if (P1 x).toReal < (c : ℝ) * (P0 x).toReal then 0
      else (γ : ℝ)
```

The remaining headers require `[Fintype X]`:

```lean
theorem power_le_power_likelihoodThresholdTest (P0 P1 : PMF X)
    (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1) (g : PMF.BinaryTest X)
    (hg : size g P0 ≤ size (likelihoodThresholdTest P0 P1 c γ) P0) :
    power g P1 ≤ power (likelihoodThresholdTest P0 P1 c γ) P1

theorem exists_likelihoodThresholdTest (P0 P1 : PMF X) (a : ℝ)
    (ha : a ∈ Set.Icc (0 : ℝ) 1) :
    ∃ (c : ℝ≥0) (γ : Set.Icc (0 : ℝ) 1),
      let fStar := likelihoodThresholdTest P0 P1 c γ
      size fStar P0 = a ∧
        ∀ g : PMF.BinaryTest X, size g P0 ≤ a → power g P1 ≤ power fStar P1
```

These are signature excerpts, not a standalone Lean file. The
[owner](../../LeanInfoTheory/Probability/NeymanPearson.lean) gives the exact
declarations. The same chosen test precedes the universal competitor quantifier.
A private general caller derives an attained least type-II error under the cap
using the existing definition, without adding a public wrapper.

## Threshold semantics and finite proof

Write `pᵢ x = (Pᵢ x).toReal`. The rule rejects above `p₁ x = c * p₀ x`, accepts
below, and uses the same boundary rejection probability γ at every tied atom.
It permits `c = 0`. Positive alternative mass at a null atom is always rejected
and contributes zero size. A common-null atom receives γ and contributes zero
to both operating characteristics. No absolute continuity, positivity,
observation ordering, event decidability or separate inhabitance is assumed.
The laws themselves exclude an empty observation type.

The supplied-threshold comparison proves the signed pointwise inequality for
every randomized competitor and sums it. Nonnegative c turns the size cap
into power dominance. This argument needs no likelihood division.

Calibration restricts ratios to `P0.supportFinset`, where null masses are
strictly positive. Private strict-tail and boundary masses U and B sum null
**mass**, rather than numbers of atoms. A private identity gives size U+γB;
off-support terms vanish even where the test rejects. Among realized levels,
the greatest level whose weak null tail reaches a brackets a between U and
U+B. The least realized level qualifies by normalization. A next-greater
realized level identifies the strict tail; absence of a successor makes it
zero. A realized boundary has B>0. Thus γ=(a−U)/B is in [0,1] and attains
exact size, including a=0, a=1 and a single realized level.

The proof uses pinned mathlib `v4.33.1`, commit
`0df444a360eaa60ab8c11dca51a86af692955474`: PMF normalization/support,
finite extrema, `Finset.exists_next_right`, filtered finite sums and guarded
real division. One-off calibration machinery stays private. Sorting,
fractional-knapsack exchange and compact maximization were considered; the
finite-set crossing route constructs the requested threshold and common tie
weight directly.

## Mathematical source adaptation

PW24 §§14.1–14.2 give the decision conventions and likelihood language.
The randomized-attainment source is §14.4, Theorem 14.11/(14.11), printed
284 / PDF 309. The registered August 16, 2024 local copy has SHA-256
`c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
The parent re-read that page as text during cumulative preparation; this is
not a fresh visual inspection. Earlier exact section readings retain their
recorded actors and page limits in the
[reference register](../references.md#pw24-polyanskiy-and-wu-newer-draft).

The book's null acceptance α and alternative acceptance β become size 1−α
and power 1−β. On jointly positive masses its null-over-alternative log
threshold τ corresponds to c=exp(−τ), with rejection γ=1−λ on the boundary.
The finite mass rule also allows zero threshold. Common-null pointwise
decisions may differ from the book's extended-log convention, with zero
effect on either sum. The formal theorem asserts existence and makes no
uniqueness claim about c, γ or decisions on common-null atoms.

## Permanent consumers and calibration evidence

The [focused examples](../../LeanInfoTheory/Examples/NeymanPearson.lean)
use public producer interfaces throughout.

| Laws and threshold | Rejection weights | Size | Power | Miss |
| --- | --- | --- | --- | --- |
| P0=(1/2,1/2), P1=(3/4,1/4), c=3/2, γ=1/2 | (1/2,0), in (false,true) order | 1/4 | 3/8 | 5/8 |
| P0=pure 0, P1=pure 1 on Fin 3, c=2, γ=1/2 | (0,1,1/2) | 0 | 1 | 0 |

The first adapts C25's private fixture and proves power ≤3/8 for every test
under the cap by the public comparison. Every nonempty Boolean event costs
at least 1/2 null size, so every feasible deterministic event has power zero.
The second proves universal optimality and separately instantiates public
existence at zero. Its same returned c, γ and universal bound, compared with
the explicit feasible test and the unit power upper bound, establish power
one and zero miss. Its parameters are not identified with the explicit test.

The prescribed private four-atom development check uses
P0=(1/6,1/6,1/3,1/3), P1=(1/2,1/6,1/3,0). It verifies both rows:

| Size | Threshold | Tie weight | Rejection weights | Optimal power |
| --- | --- | --- | --- | --- |
| 1/3 | 1 | 1/3 | (1,1/3,1/3,0) | 2/3 |
| 5/6 | 0 | 1/2 | (1,1,1,1/2) | 1 |

This checks unequal null masses tied at the same level and the need for zero
threshold at an interior size. Retained input and successful/failed original
results are separate under `.lit-review/setup/c26-04-20261107/`; only actual
successful checks supply validation. It is not a third permanent example.

## Validation, review and exact-candidate boundary

The notes map all nine preceding criteria and the three cumulative criteria
to the actual source and evidence. C26.05 closed with both criteria satisfied
and no findings; its exact replacement review, independent Lean checks,
reconciliation and closure are under `.lit-review/setup/c26-05-r2-20261107/`.
Earlier findings keep their source-specific dispositions. The initial Step5
dispatch was stopped for an inventory omission. The authorized three-file
recovery preserves original frames, uncertain receipt, failed and partial
checks; its independent tooling qualification supplies no mathematical
criterion credit. The replacement ordinary STEP review supplies that credit.

Cumulative qualification requires focused C25/C26 owners and consumers,
Examples and Shannon, generated/static/documentation checks, the separate
601 and 811 retained comparisons, a named full-record comparison against
C25's 828-entry export, all 17 C25 focused declarations, and current imports,
root exports, reviewed attributes and all-project axioms. The accepted C25
checkpoint is `06c71043a28af231e11490443b6225ae3b9a76eb`; its preserved compiler
and boundary artifacts remain the specific C25 reference. Counts alone do
not establish retained types or visibility.

The full development suite needs the separately authorized exact clean
checkpoint and repeats after any amendment. The primary checkout's HEAD,
index, existing local bytes and unrelated work are protected. Fresh runs,
applicable earlier checks and independent reported checks remain separately
attributed. The separate full API-documentation gate is reserved for its own
milestone; this chunk does not publish or modify frozen release routes.

One persistent reviewer is reused for cumulative review. Its requested
gpt-6-astra/ultra/no-parent-history creation settings remain distinct from
unknown effective settings. Complete native requests/results and original
reports, including uncertain submissions and failed ancillary checks, remain
durable. Instructions and hashes imply neither OS isolation nor authenticated
human/model provenance. Fresh cumulative review, substantive reconciliation,
final applicability and the supported completion record remain necessary;
readiness alone is not closure.

## Next-chunk imports and deferred scope

C27 can import `LeanInfoTheory.Probability.BinaryTesting` for `ofEvent`, size,
power, miss and event-mass identities, using independent Q as null and joint
J as alternative. It need not import C26 solely for testing terminology.
Its global event can compare real masses `J(z) > exp(t) * Q(z)`; a logarithmic
agreement belongs on joint support. When J=0<Q and t<0, totalizing log density
to zero must not make an impossible pair pass. This handoff starts no C27 work.

| Deferred item | Owner and trigger |
| --- | --- |
| Information density and global joint-versus-independent event | C27, after separate planning and step selection |
| Full ROC theory and optimizer uniqueness | A separately approved consumer or mathematical scope decision |
| Kernel-valued risk interoperability | A concrete caller requiring the pinned mathlib measurable-risk interface |
| Public type-II minimizer wrapper or threshold aliases | Actual downstream search/use pressure beyond the private general caller |
| Randomized decoders or new channel abstractions | A separately approved coding consumer; no claim follows from randomized tests |

The testing package is usable independently of coding imports. Closing C26
does not select a release, choose metadata, approve publication or start C27.
