# C38 — Exact type-class counting and entropy bounds

<!-- lit-review-status:start -->
**Plan status:** Approved revision 2, C38.06 cumulative review reconciled; final records govern closure, 18–19 November 2026. The lead accepted the presented revision 2 (SHA-256 `8b08ed6b9c1212d932ba59959ca938ee19da154de4176bcc8155606402ef2af1`) and separately requested step 1 with its review process. C38.01 closed successfully; its exact final source was verified before admitting the conditional step-2 request. Only this editorial status region has changed since that approval. All six steps and seventeen criteria remain in force; later steps require separate selection. Revision 1 received formal independent plan review with no material findings; revision 2 incorporated advisory refinements and has no separate formal plan-review result. The persistent reviewer remains bound to the actual C38 implementation parent. Requested settings are `gpt-6-astra` / `ultra`, with parent-history copying disabled; effective settings are unobservable. In-scope proof adjustments require reasons and evidence; material changes require the lead. C38.01 closure is recorded privately as c9947ff5afa8251b794a56eb994f8abf03f01958857014c4802495ec6bc84311. C38.02 closed successfully as c7c25ea6c6b3996ef37ed42484862b6e090471bbff1cb71a6a0c49006f33e8bb; its exact final source was verified before admitting the conditional step-3 request. C38.03 closed successfully as 70fcccae8cc70e9035d28f125b1171f32910fc67538b3f26a90720c4a3ef888e; its exact final source was verified before admitting the conditional step-4 request. C38.04 closed successfully as 51037c5d326e9250182b11344f5b632c837e40765aefa8de832f6ead271c44d2; its exact final source was verified before admitting the conditional step-5 request. C38.05 closed successfully as 48ac467748bb373002fdbba4b9b534fd86caa6f06e271c550f9dc01640284045. C38.06 admission and exact final-source verification: verified C38.05 F `ccd27dc6b07fac07d9647beb9fd6bfb6e1d91391f058772238558d62f8326e42` with no source difference, then admitted only C38.06; original records in `.lit-review/setup/c38-06-20261118/`. Only C38.06-VALIDATE, C38.06-RECONCILE, C38.06-HANDOFF and C38.06-REVIEW are selected. The complete seventeen-criterion matrix and source-bound candidate fulfilled the C38.06-REVIEW readiness duty. Fresh independent cumulative review (`c38c67f0b6c044aff0a5c5630554d31dc033d7fce7353d68af1a2f19ff7e0db3`) marks all four C38.06 criteria and all seventeen chunk criteria SATISFIED, with no material findings. The parent agrees in `b95f53aa4c31515e03695a491b0d2712d2657629a66dfbc2fa2abeb722ad930a`. The five public contracts and all permanent consumers are implemented. The first cumulative compatibility run failed on duplicate raw ownership of PMF.iid.eq_1 in AEP/Bounds; seven C38-only proof-body sites now use definitional finiteProduct conversion. Mathematical routes, statements, public contracts, imports and acceptance policy remain unchanged; no AEP/C36/C37 source change was made. Fresh corrected focused, compatibility, trust and documentation gates pass; their original results and source applicability are retained in the validation index. Cumulative validation, the fresh review, parent reconciliation and the maintained C39 handoff retain their original evidence. Final exact source/compiled/pin applicability is governed by `.lit-review/setup/c38-06-20261118/final-checks.json`; `.lit-review/setup/c38-06-20261118/completion.json` governs actual C38.06 and chunk closure. The 913-declaration/76-module surface, 94 simp names and root direct/reachable/export counts 2/5/92 remain the source baseline. C36, C37 and C38 complete clean-checkpoint suite/hygiene qualifications remain separate outstanding obligations. No C39 implementation, commit, publication or dependency-pin change is authorized.
<!-- lit-review-status:end -->

## Endpoint and scope

For every finite alphabet `A`, length `n` and supplied C37 index
`t : ↥(wordTypes A n)`, identify the cardinality of the existing `typeClass t`
with `Nat.multinomial Finset.univ t.val`. For `hn : 0 < n`, put
`q = empiricalPMF hn t` and `k = Fintype.card A`. Prove, in canonical nats,

```text
exp(n * entropy q) / (n+1)^k ≤ (typeClass t).card ≤ exp(n * entropy q).
```

The inequalities are in `ℝ`, with explicit natural casts. The polynomial uses
the **ambient** alphabet size, including zero-count symbols. These are universal
statements about every admissible index, with no separate realizability,
full-support, positive-entropy or nonempty-alphabet premise. Reuse C37's index,
empirical PMF and single class finset. No parallel class, bundled count structure,
word representation or new probability distribution API is needed.

C38 also establishes the required own-law iid atom and class-mass identities
directly from existing finite products. The general-prior word/class formulas,
KL estimates, support-inclusion branch and infinite-KL branch remain C39 work.
There is no required dependency on C39, prefix coding, asymptotics, Stirling
estimates, Sanov's theorem, sharper support-size factors or second-order terms.

The [C37–C39 map](release-3-chunk-map.md#c38-counting-and-entropy-of-a-type-class)
and proof advice are references; the contracts and acceptance criteria here govern
the proposed work. Justified proof-route adjustments belong in separate notes.
Changing mathematical meaning, required scope, important public contracts,
acceptance policy or dependency pins requires the lead's decision.

## Verified intake and source basis

The [C37 handoff](../handoffs/chunk-37.md), actual
[count owner](../../LeanInfoTheory/Shannon/WordType.lean),
[empirical owner](../../LeanInfoTheory/Shannon/EmpiricalPMF.lean) and
[permanent consumers](../../LeanInfoTheory/Examples/WordType.lean) agree on the
twenty-declaration interface. `wordTypes` is `Finset.univ.piAntidiag n`;
`typeClass` is the finite fiber of `wordType`. Realization, unique membership,
position invariance, actual empirical support and `card_wordTypes_le` are available.
The example-only arbitrary-weight partition is not a public theorem: production
proofs should use upstream `Finset.sum_fiberwise` rather than import Examples.

C37 is closed by `.lit-review/setup/c37-07-20261117/completion.json`, closure
`5757260db89c5bb06ed280b4d88256cf24db8abc8c5feb3f8b7bc01512bc93b1`.
Its original-report capture and reconciliation are retained privately. The
handoff's pre-final wording is interpreted through that receipt, not rewritten
as a new C37 acceptance event. C36 and C37 each still have outstanding complete
clean-checkpoint validation and hygiene. Neither qualification is supplied by
this plan or by C38's dirty-tree checks; their mathematics is not reopened.

Intake is the dirty primary checkout on `master`, HEAD
`2eb80d0e746688511618aaefc2624ffa4ae88f6e`. Lean is 4.33.1 and mathlib is
`0df444a360eaa60ab8c11dca51a86af692955474`. Installed `inspect` and `api` passed;
all nine installed dependency states match their pins. All 226 recorded C37
cumulative producer fingerprints match at intake. Fresh warning-as-error focused
builds passed for WordType, EmpiricalPMF, Examples.WordType, Probability.Iid and
Shannon.Entropy. The current supported inventory is 908 declarations in 74 modules;
the root retains two direct imports, five reachable project modules and 92 exports,
and the reviewed simp set contains 94 names. This is intake applicability, not a
fresh full retained-signature export or a clean qualification.

CT91, *Elements of Information Theory*, 1991, §12.1 is the mathematical source:
the class and type-count statements are on printed pp. 280–281 (PDF 302–303);
the own-law corollary is (12.15), printed p. 281; Theorem 12.1.3, (12.16)–(12.17),
gives the two-sided estimate and exact multinomial count on p. 282. Its probability
comparison and lower-bound argument continue through p. 284, (12.23)–(12.39).
The registered file's SHA-256 was freshly matched. PDF 301–306 were read as text,
and the displayed class-size/factorial argument on PDF 304–306 was visually
checked. [Reference register](../references.md#ct91-cover-and-thomas)

Adapt the source's powers of two and bit entropy to `Real.exp` and nats. Prove
the own-law specialization without first proving the general-prior divergence
formula. Replace probability ratios and potentially negative powers at zero
counts by a division-free natural inequality. All-length combinatorial boundaries
are explicit project extensions. Do not copy textbook proof prose into the repo.

## Proposed public contracts

All five names below are **proposals, not existing declarations**. They belong to
`LeanInfoTheory.Shannon`, with `{A : Type u} [Fintype A] {n : ℕ}`. No public
`DecidableEq A`, chosen ordering or `Nonempty A` instance is required; use classical
decisions locally. Existing declarations and their signatures remain unchanged.

```lean
theorem card_typeClass_eq_multinomial (t : ↥(wordTypes A n)) :
    (typeClass t).card = Nat.multinomial Finset.univ t.val

theorem iid_empiricalPMF_apply_of_mem_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n))
    {x : Fin n → A} (hx : x ∈ typeClass t) :
    ((PMF.iid (empiricalPMF hn t) n) x).toReal =
      Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t))

theorem iid_empiricalPMF_toOuterMeasure_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    ((PMF.iid (empiricalPMF hn t) n).toOuterMeasure (typeClass t)).toReal =
      ((typeClass t).card : ℝ) *
        Real.exp (-(n : ℝ) * entropy (empiricalPMF hn t))

theorem card_typeClass_le_exp_entropy
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    ((typeClass t).card : ℝ) ≤
      Real.exp ((n : ℝ) * entropy (empiricalPMF hn t))

theorem exp_entropy_div_pow_le_card_typeClass
    (hn : 0 < n) (t : ↥(wordTypes A n)) :
    Real.exp ((n : ℝ) * entropy (empiricalPMF hn t)) /
        ((n : ℝ) + 1) ^ Fintype.card A ≤
      ((typeClass t).card : ℝ)
```

The first theorem holds at **every** length. Unfolding `Nat.multinomial` and
using C37's sum witness gives `n! / ∏ a, (t.val a)!` in `ℕ`; the division-free
factorial identity is available through upstream `Nat.multinomial_spec`.
Separate public factorial aliases, mode theorems, combined-bound wrappers and
word-index specializations are unnecessary for the initial API. A caller may
pair the two inequalities or specialize `t` to `wordType x` directly.

The probability statements use the same class coerced to a set. They expose real
masses for the entropy calculation, with finite PMF atoms and a finite event
justifying every `ENNReal.toReal` operation. They do not change the PMF or KL
conventions. C38.05 must exercise recovery of the ENNReal class identity from the
public real identity, with an explicit proof that the event mass is not infinity
and that the real right-hand side is nonnegative. Use finite-mass injectivity or
`ENNReal.ofReal_toReal`; unrestricted injectivity of `toReal` is invalid. This
generic private caller supplies the C39 handoff without a duplicate public alias.

At `n=0`, there is one empty word and its class has cardinality one, even for
`A=Empty`; the multinomial is one. For empty `A` and positive `n`, no index exists.
For singleton `A`, every class has size one. The empirical PMF remains defined
only for positive length. No default law is assigned to zero counts. With
`t.val a=0`, the factorial contribution is `0!=1`, the natural power convention
is `0^0=1`, and the entropy contribution is zero. A competing vector using that
symbol positively has zero mass under the target empirical law.

## Ownership and import boundaries

Propose two new focused modules, exported by the import-only
`LeanInfoTheory.Shannon` umbrella:

| Owner | Responsibility and proposed direct dependencies |
| --- | --- |
| `Shannon.TypeClassCardinality` | Exact count only. Import `Shannon.WordType`, `Mathlib.Data.Nat.Choose.Multinomial`, `Mathlib.GroupTheory.Perm.DomMulAct`, and `Mathlib.GroupTheory.GroupAction.Quotient` for the preferred route. No project PMF, entropy, iid or KL dependency. |
| `Shannon.TypeClassBounds` | Own-law identities and entropy bounds. Import `Shannon.TypeClassCardinality`, `Shannon.EmpiricalPMF`, `Probability.Iid`, and `Shannon.Entropy`; add only focused pinned mathlib imports actually needed by the proof. No semantic-KL or coding owner. |
| `Examples.TypeClass` | Private permanent binary (including a biased probability-versus-size comparison), pure, sparse and boundary fixtures plus a generic public-interface caller with ENNReal mass recovery. Import the focused bound owner, not the full umbrella or example-private C37 helpers. Include it in `LeanInfoTheory.Examples` only. |

The new cardinality owner keeps permutation-count dependencies out of the existing
WordType and EmpiricalPMF imports. If a lighter verified exact-count route succeeds,
record the dependency reduction and review the actual direct imports; the focused
combinatorics/probability boundary is required. Do not add imports to the lightweight
root, pull Examples into either supported umbrella, or modify upstream notices.
Every new project Lean file uses the exact EPFL/MIL header. No new simp attributes,
public instances or helper structures are proposed. One-off orbit equivalences,
count-weight functions, factorial comparisons, log regrouping and casts stay private.

## Checked proof routes and alternatives

The following is advisory implementation guidance, distinct from the contracts.
The pinned declarations were read from source and checked in a Lean lookup probe;
this establishes their existence and statement shape, not completed C38 proofs.

1. **Exact counting.** Realize `t` by C37's `wordType_surjective`. Equal symbol
   counts give equal cardinalities of position fibers. `Fintype.equivOfCardEq`
   and `Equiv.ofFiberEquiv` / `Equiv.ofFiberEquiv_map` construct a position
   permutation taking one word to the other. Identify the class with the orbit
   under precomposition. Pinned `DomMulAct.stabilizer_card` counts the preserving
   permutations as `∏ a, (symbolCount x a)!`.
   `MulAction.card_orbit_mul_card_stabilizer_eq_card_group` and
   `Fintype.card_perm` give class size times that product equal to `n!`.
   Compare with `Nat.multinomial_spec` and cancel the positive factorial product.
   Check the domain-action orientation against C37's `x ∘ e` convention; an
   inverse permutation has the same orbit but must not silently reverse a stated
   equation. The fiber/orbit bridge is the main unimplemented combinatorial risk.

2. **Own-law mass.** Unfold `PMF.iid` only to use `PMF.finiteProduct_apply`.
   Regroup the position product by symbols with `Finset.prod_fiberwise'` and
   C37 membership/count equality. This gives, privately, the count product
   `∏ a, (q a).toReal ^ t.val a`. Use `empiricalPMF_apply`,
   `mem_support_empiricalPMF_iff` and `entropy_eq_sum` to identify it with
   `exp(-n H(q))`. Split off zero counts before logarithmic cancellation; all
   positive-count atoms are strictly positive. Sum the constant mass with
   `PMF.toOuterMeasure_apply_finset` and `ENNReal.toReal_sum`, justified by
   `PMF.apply_ne_top`. No logarithm of a zero atom acquires probability meaning.
   A private equivalent product formula in counts is useful for the lower bound.

3. **Upper bound.** The real sum over one class is at most the sum over all
   words, which is one by `PMF.sum_toReal`. Apply the own-law class identity and
   multiply by the strictly positive reciprocal exponential. This uses no
   asymptotic, uniformity or KL assumption.

4. **Preferred lower bound: direct factorial comparison.** For natural `a,b`,
   establish privately `a! * a^b ≤ b! * a^a`. If `a≤b`, use
   `Nat.factorial_mul_pow_sub_le_factorial`; if `b≤a`, use
   `Nat.factorial_mul_descFactorial` and `Nat.descFactorial_le_pow`. Both cases
   include zero. For fixed target counts `a=t.val` and competing admissible `b`,
   put `M(b)=Nat.multinomial Finset.univ b` only as private notation and
   `W_a(b)=M(b) * ∏ i, a i ^ b i`. Multiply the scalar inequalities, use equal
   totals and `Nat.multinomial_spec`, and cancel positive factorials to prove
   `W_a(b) ≤ W_a(a)`. This maximizes probability weights, **not** `M(b)`.

   `Finset.sum_pow_eq_sum_piAntidiag`, with the very antidiagonal defining
   `wordTypes`, gives `∑ b ∈ wordTypes A n, W_a(b) = n^n` in `ℕ`. Keep weights,
   factorial comparisons and this normalization in `ℕ`. For `hn : 0 < n`, fix
   `q = empiricalPMF hn t`; for every competing index `s : ↥(wordTypes A n)`,
   establish the private bridge

   ```text
   ((PMF.iid q n).toOuterMeasure (typeClass s)).toReal
     = (W_a(s.val) : ℝ) / (n : ℝ)^n.
   ```

   Use the exact count and grouped iid product. Cast before dividing, prove
   `(n : ℝ)^n > 0`, and justify finite mass conversion; natural division is not
   the normalization. The law stays fixed to the target `t`, including when
   `s ≠ t`; this is a private empirical-target bridge, not a general-prior public
   theorem. If some `a i=0<s.val i`, its weight and probability under this fixed
   law are zero; otherwise the factor comparisons remain legitimate without
   deleting unused labels. Summing the mode inequality and applying
   `card_wordTypes_le` gives `n^n ≤ (n+1)^k * W_a(a)` in `ℕ`. Cast and divide by
   the positive real denominator, connect the target case `s=t` to the own-law
   class identity, and rearrange to the required bound.
   This division-free version avoids a termination proof for repeated transfers
   and avoids dividing by a competing probability that might vanish.

5. **Alternatives and triggers.** If the orbit bridge produces disproportionate
   coercion/instance pressure, use a direct equivalence between labeled-slot
   bijections and a class word with permutations of its fibers; this proves the
   same factorial product identity. List permutation length alone is insufficient:
   it counts repeated occurrences. `Multiset.countPerms` is algebraically defined
   using multinomials and does not itself remove the counting bridge. If the
   direct mode algebra proves awkward, the roadmap's transfer argument is valid
   on positive-probability competitors: move one count from an overrepresented
   symbol `i` to an underrepresented `j`, use ratio
   `b_i*a_j / ((b_j+1)*a_i) ≥ 1`, and prove a natural distance decreases. Handle
   zero-mass competitors separately. Successive binomial bounds are another
   option only with an explicit derivation of the same ambient `(n+1)^k` factor.
   A weaker polynomial or stronger support assumption is not an alternative
   implementation of the approved endpoint.

Pinned source anchors are
[Multinomial](../../.lake/packages/mathlib/Mathlib/Data/Nat/Choose/Multinomial.lean),
[permutation stabilizers](../../.lake/packages/mathlib/Mathlib/GroupTheory/Perm/DomMulAct.lean),
[orbit–stabilizer](../../.lake/packages/mathlib/Mathlib/GroupTheory/GroupAction/Quotient.lean),
[fiber equivalences](../../.lake/packages/mathlib/Mathlib/Logic/Equiv/Basic.lean), and
[factorial inequalities](../../.lake/packages/mathlib/Mathlib/Data/Nat/Factorial/Basic.lean).
No external information-theory formalization was consulted.

## Numbered implementation steps

Each step needs its own explicit selection after exact-plan approval. Perform
only that step with its review cycle, then stop. The steps are ordered dependencies,
not authorization to execute a batch. Generic acceptance requirements below apply
to each step as well as its explicit criteria.

### C38.01 — Exact multinomial cardinality

- **C38.01-RETAIN** — Before public growth, qualify the incoming 908 named
  signatures against their producer source, exporter, compiled artifacts and
  dependency pins; freshly export if provenance or applicability is inadequate.
  Preserve all existing work, historical baselines, root exports and reviewed
  attributes. Record a source-bound baseline for cumulative retention.
- **C38.01-COUNT** — Implement `card_typeClass_eq_multinomial` for every supplied
  index and every length, in the focused combinatorial owner. A public-only
  caller constructs an index from its sum proof and derives the factorial
  product identity through the public result and mathlib.
- **C38.01-BOUNDARY** — Compile callers showing cardinality one at length zero
  over arbitrary finite alphabets, including `Empty`, and on a singleton alphabet;
  preserve zero coordinates. Check the exact owner without importing entropy,
  iid or project PMF modules.

### C38.02 — Own-law iid atom and event masses

- **C38.02-WORD** — Implement the stated own-law atom theorem for every member
  of the supplied class at positive length. The proof depends only on the
  released iid product formula and the C37 interface; retain a usable private
  grouped-product identity. Explain positive-count logarithms and zero factors.
- **C38.02-CLASS** — Implement the stated class-event identity for exactly the
  existing finset under its own empirical iid law. Justify finite real conversion
  and distinguish one-word mass from whole-class mass. A focused caller uses both
  identities with arbitrary `A,n,t,x`; no full-support assumption is introduced.

### C38.03 — Entropy upper bound

- **C38.03-UPPER** — Implement `card_typeClass_le_exp_entropy` with exactly the
  displayed positive-length contract. Derive it from own-law probability at most
  one, retaining ambient zero-count symbols. A caller obtains the bound for a
  supplied index and for `wordType x`; no new public specialization is needed.

### C38.04 — Count-vector mode and entropy lower bound

- **C38.04-MODE** — Establish privately the target count-vector probability
  maximality and normalization needed by the chosen route. For the preferred
  route, prove the division-free factorial comparison, its product consequence,
  the exact natural `n^n` sum, and the displayed real weight/probability bridge
  for each competing index under the fixed target empirical law. Cast before
  division and prove the denominator positive. Explicitly handle a competitor
  using a target-zero symbol. An alternative must establish an equally sufficient
  lower-bound mechanism without maximizing class size.
- **C38.04-LOWER** — Implement `exp_entropy_div_pow_le_card_typeClass` with the
  exact ambient exponent `Fintype.card A` and no additional assumptions. Combine
  it with C38.03 in an arbitrary-object public caller. The proof and import graph
  remain independent of general-prior type probability and KL results.

### C38.05 — Permanent consumers

- **C38.05-BINARY** — For Boolean length three counts `(2,1)`, prove that the
  class consists of `001`, `010`, `100` and has size three; obtain the same size
  from the multinomial theorem. Check its own-law word mass `4/27` and class mass
  `4/9`, and apply both entropy inequalities. An exact simplification may record
  `exp(3H(2/3,1/3))=27/4`, giving `27/64 ≤ 3 ≤ 27/4`; the theorem applications,
  correct class and mass distinctions are required, not a particular log tactic.
  Also compare Boolean length-four classes under the fixed target empirical law
  `q=(3/4,1/4)`: counts `(3,1)` have cardinality `4` and event mass `27/64`,
  whereas counts `(2,2)` have cardinality `6` and event mass `27/128`. Check the
  strict opposite orderings of cardinality and probability. Compute the competing
  event mass directly from the iid product and finite sum, using no new public
  mode/general-prior theorem and no access to the bound owner's private helpers.
- **C38.05-PURE** — On an ambient alphabet with unused labels, give a positive
  length pure count vector, show its class is the singleton constant word, its
  empirical law is pure, entropy is zero and both own-law masses are one. Apply
  the bounds; the upper bound is equality and the lower retains ambient `k`.
- **C38.05-SPARSE** — Over `Fin 3`, use length four counts `(2,2,0)` and obtain
  class size six, support `{0,1}`, own-law word mass `1/16`, class mass `3/8`,
  and both entropy bounds with exponent three. Check `exp(4H(q))=16`, hence
  `16/125 ≤ 6 ≤ 16`. A competing class using symbol `2` has mass zero under
  the fixed target law `q=(1/2,1/2,0)`, not under the competitor's own empirical
  law. This last example is a direct product check, not a C39 general-prior API.
- **C38.05-BOUNDARY** — Preserve all-length count conclusions: zero-length class
  and multinomial both one, including `Empty`; no positive-length empty-alphabet
  index; singleton classes one. No zero-length empirical law is introduced.
- **C38.05-CALLER** — Maintain a generic caller using only supported focused
  imports. It starts from an arbitrary count function and sum proof, obtains
  exact counting and both bounds, and uses that same finset as an iid event.
  It also starts from an independently supplied PMF with a denominator witness,
  uses C37's equivalence to recover its index/law, and transports the bounds.
  For arbitrary positive-length `t`, recover from the public real class identity
  the ENNReal identity, with `q=empiricalPMF hn t`,

  ```text
  (PMF.iid q n).toOuterMeasure (typeClass t)
    = ENNReal.ofReal (((typeClass t).card : ℝ) * Real.exp (-(n : ℝ) * entropy q)).
  ```

  Explicitly prove the event mass is not infinity using its finite sum of finite
  PMF atoms, and record nonnegativity of the real right-hand side. Recover the
  identity with finite-mass conversion; do not assume global `toReal` injectivity.
  Use no example-private proof in this interface check. All fixtures are private
  development consumers, excluded from supported umbrellas.

### C38.06 — Cumulative qualification and C39 handoff

- **C38.06-VALIDATE** — Validate the entire C38 candidate and all earlier C38
  criteria together. Run cumulative owner/consumer/aggregate builds, generated
  and static checks, compiled retention against both released contracts and the
  incoming 908 rows, full maintained trust/import/axiom checks and documentation
  validation. Recheck the independent public-only caller against current source.
  Distinguish fresh evidence from qualified earlier evidence and dirty-tree
  qualification from the pending complete clean suite and hygiene.
- **C38.06-RECONCILE** — Reconcile source, imports, public policy, generated
  inventory, exact source adaptations, project log, living summary, reference
  register and programme map before final capture. Preserve C36/C37's outstanding
  clean qualification separately. Give every remaining item an owner/trigger or
  explicit scope disposition; no required theorem may be silently deferred.
- **C38.06-HANDOFF** — Maintain `docs/handoffs/chunk-38.md` with exact final
  signatures/imports, consumer locations, source and validation identities,
  private proof choices, known limits and C39 prerequisites. C39 receives the
  single class, count formula, both bounds, independent own-law seed and the
  generic caller's checked finite-mass ENNReal recovery. Its
  general-prior atom exponent is `-n*(H(q)+D(q||p))`; class bounds require multiplying
  by the class cardinality. Record support inclusion and the zero-probability /
  infinite-KL branch as C39 obligations, not delivered C38 results. Carry the clean
  qualification and release/publication boundaries forward.
- **C38.06-REVIEW** — Prepare a complete auditable matrix for all seventeen
  C38 criteria and a review-ready cumulative candidate, with exact source and
  evidence available for fresh independent assessment of the whole approved
  contract. Earlier step assessments do not substitute for this cumulative
  assessment. Readiness documents reserve final acceptance for the actual
  completion receipt rather than claiming that review or closure already exists.

After preparing that candidate, C38.06 must obtain the fresh independent review
from the same bound reviewer, reconcile every original assessment/finding,
correct and revalidate as required, and complete supported private closure.
These are actual completion duties, separate from pre-review readiness claims.
Never edit captured documents after final capture merely to turn readiness into
a completion claim.

## Acceptance, compatibility and review operations

The per-step process includes actual validation, contextual read-only self-review,
a separate reassessment, justified corrections, a neutral source-bound independent
review, substantive reconciliation, final checks and supported closure. Follow
[review protocol](../review-protocol.md) and [operations](../review-operations.md).
One review cannot certify nonexistent later proofs. For plan review, assess the
proposal's feasibility, statement fidelity, ownership and complete criteria;
assessment does not approve execution. Inline or verified-file delivery is
authorized when the lead requests review and needs no routine delivery-choice
question. Preserve original calls/results and exact reports; unknown settings and
uncertain delivery remain explicitly unknown/uncertain. Reuse the established
reviewer; do not replace it after an error. Private `.lit-review/` is durable state.

Before growth, use the C37 cumulative export at
`.lake/compatibility/c37-07-facts-20261117/cumulative-20261117T210428698928Z/current-908.stdout`
(SHA-256 `9fb98ac1399f4c3615cdec784e062a386a64d0584d0ec1ba84c20ab757dd8829`)
only after qualifying its linked compiler receipt, source/compiled inputs, exporter
and pins. The validation index is
`.lake/compatibility/c37-07-validation-20261117/index.json`. Intake matching does
not replace the first step's baseline check. At closeout compare all retained
names, full structural types, binder/universe data, kinds and owners; audit actual
imports, root reachability and reviewed attributes. Generated inventory is not
growth approval. Apply reviewed additions/imports to
`docs/compatibility/current-api-policy.json` under the exact approved plan.
Preserve the 601- and 811-declaration release contracts unchanged.

For each coherent Lean change, use the shared focused validator with the touched
owners, permanent consumers and important downstream `Shannon` / `Examples` /
light-root aggregates. After approved public additions/imports, deliberately
regenerate current API and source-derived website artifacts, check the frozen
historical manifest without rewriting it, and run development static checks:

```powershell
python scripts/validate_release.py focused <affected-targets>
python scripts/generate_current_public_api.py
python scripts/generate_v0_1_public_api.py --check
python scripts/generate_website_blueprint.py
python scripts/generate_website_api_index.py
python scripts/validate_development.py static
```

Cumulative qualification additionally runs:

```powershell
python scripts/validate_development.py compatibility
python scripts/validate_development.py trust
python scripts/validate_release.py documentation
```

Use warning-as-error caller probes and complete mathematical assumption, naming,
public/private, simp, import and axiom audits. Permit only the maintained three
axioms. No placeholders or prohibited proof shortcuts. Record awkward new names
under Future Work Note 14 only if evidence warrants it; do not introduce aliases
without consumer pressure. Delete disposable proof spikes before the milestone,
preserving original validation evidence and private review records.

The full `python scripts/validate_development.py` and hygiene gate require a
separately authorized clean committed checkpoint, and must repeat after amendment.
Without that authority, report them outstanding; do not relax the gates or commit
existing work to pass. API-doc generation, exact-commit external-consumer release
qualification and publication remain separately authorized milestones. No commit,
push, publication, dependency-pin change, new Desktop folder, C39 implementation
or automatic next-step execution follows from approval or closure of this plan.
