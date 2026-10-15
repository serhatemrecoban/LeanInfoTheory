# Chunk 17: Product channels and memoryless extensions

<!-- lit-review-status:start -->
**Status:** Approved detailed plan, revision 2, 2026-10-15; C17.05 cumulative
qualification selected after actual C17.01--C17.04 completion/review. On 2026-10-16
the lead approved the nineteen-path local checkpoint, necessary Step 5 amendments
and reuse of the inspected clean checkout. Initial checkpoint `06c9610be44e8f0d5ecfc6f850a011137db341bc`
passed the full routine; separate actual two-pass API docs and twelve-declaration
inspection passed. Final candidate qualification, all-fifteen-criterion review,
reconciliation and closure are established only by actual source-bound records.
The maintained [handoff](../handoffs/chunk-17.md) and [notes](post-release-chunk-17-notes.md)
retain evidence and limits. No later chunk or release work is selected. Normative
requirements and pins are unchanged. Revision 1's formal PLAN review is historical;
no fresh revision-2 PLAN review is claimed. This editorial block changes no requirement.
<!-- lit-review-status:end -->

## 1. Scope and authority

Construct finite product channels from coordinate channels and their repeated
single-channel specialization, independently of any input distribution. Channels
remain raw functions `A → PMF B`, and output laws remain `p.bind W`. Reuse C16's
`PMF.finiteProduct`, existing block equivalences, `PMF.channelJoint` and
`PMF.channelComp`; introduce neither another product-law representation nor a
bundled channel, matrix replacement, global memorylessness predicate, or process.

Memorylessness constrains the conditional output law for each input word.
The input law can be arbitrarily correlated. Independent-input factorization is
a separate theorem with its explicit product input; it is not a constructor
premise or a conclusion about every output law.

Deliver atom, support, coordinate-marginal, injective restriction, block
transport, composition, deterministic and joint-law contracts below. Permanent
consumers must exercise both independent and correlated inputs, sparse rows,
null input fibers and zero/one blocklengths. Identify C18 and C23 inputs without
implementing their mathematics.

Excluded: new entropy/KL product identities, information inequalities or equality
criteria, AEP/typicality, coding/rate/error definitions or theorems, capacity,
feedback, infinite trajectories, infinite-output product constructions, dependency
upgrades, release preparation, publication, PFR and ShannonCert changes. Applying
an existing semantic theorem in a private compatibility consumer is permitted;
adding a new information theorem is not.

The lead has accepted revision 2 and selected C17.01 with its review process.
This authorizes that step's production, consumer, growth-policy and associated
documentation changes, with the validation and review duties below. Later steps,
dependency or review-tooling changes, commit, push, tag and deployment remain
unauthorized. Keep auxiliary work in established ignored repository locations;
do not create Desktop folders. Preserve all unrelated pending work.

## 2. Verified baseline and reference contract

Authorized checkout: `C:\Users\coban\Desktop\Lean Info Theory`.
Intake branch is `master`, HEAD
`fffd0968640bb4b2cbdf07d9bdcdc573950f0bb1`, five commits ahead of the locally
recorded `origin/master`; no fetch or current remote-state claim is made.
The four existing modified files are `.gitignore`, `AGENTS.md`,
`docs/next-website-tasks.md` and `docs/project-log.md`. Their bytes are protected.

C9--C16 are completed prerequisites, not work to reopen. In particular,
`.lit-review/setup/c16-05-completion-20261014.json` records
`SUPERVISED_STEP_COMPLETE`, all five C16 steps complete, no active step, zero
findings, and the same HEAD. Its closure is
`29ac907c57ecf8b47b79ff8e853dcb0938cb418297b49292cd21696002ffe4d8`;
final capture F is
`9606c2712a2db41a53f16ffd032ebcac32b27312d58b46f8b6fa323e333682d0`.
Fresh C17 intake compared all 248 real-file entries with no mismatch; virtual
`@environment` is separate. The installed inspection confirmed all nine root
dependencies clean at their configured revisions. C16's final clean routine,
fresh cumulative review/reconciliation and applicable two-pass API-doc evidence
are historical source-bound results, not freshly rerun C17 checks.

The living summary, map, C16 plan/notes and handoff intentionally preserve
pre-closure chronology. Their earlier pending wording does not override final
completion. Do not rewrite captured C16 records to make them appear retrospective.
Canonical C17 reconciliation will record the completed predecessor accurately.

Lean is `leanprover/lean4:v4.33.1`; mathlib is `v4.33.1`, resolved to
`0df444a360eaa60ab8c11dca51a86af692955474`. Keep every root/docbuild pin and the
frozen `v0.1.0` contract at release commit
`0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f` unchanged. Intake inventory is
686 documented supported declarations in 42 owners, 94 reviewed simp names and
92 root exports; inventory does not approve additions.

### 2.1 Inspected foundations

Paths here are relative to `LeanInfoTheory/` unless otherwise stated.

| Existing owner | Reuse required before adding alternatives |
| --- | --- |
| `Probability.FiniteProduct` | `finiteProduct`, exact atom/support/evaluation, empty/pure laws, injective restriction, equivalence reindexing, sum split and distinct-pair projection. |
| `Probability.Iid` | Thin `iid`, `finiteProduct_map_append_symm`, `channelJoint_finiteProduct_map_append`, `iid_map_perm`; prefix is `Fin.castAdd`, suffix is `Fin.natAdd`. |
| `Probability.FiniteChannel` | Raw channel constructors, atom/support/projection laws, bind/composition and deterministic reductions, `channelExtension_map_endpoints`, `channelJoint_eq_iff_eq_on_support`. |
| `Shannon.SemanticBridge.FiniteProduct` | `familyMarginal_finiteProduct`, `isMutuallyIndependentFamily_finiteProduct`, `isIndependentOf_finiteProduct_eval`; retain the existing family/independence predicates. |
| `Shannon.SemanticBridge.Product` / `Markov` | Existing `indepProd`, conditional-channel reconstruction and null fallback; historical `mutualInfo_independent_channels_le` consumes a raw independently sampled binary output law. |
| Pinned mathlib | `Equiv.arrowProdEquivProdArrow` for dependent tuples of pairs, `Equiv.piCongrLeft`, `Equiv.sumPiEquivProdPi`, `Equiv.funUnique`, `Fin.appendEquiv`, `finSumFinEquiv`, `Fintype.prod_sum`, finite PMF map/bind algebra. |

### 2.2 Mathematical sources and adaptations

Read the registered **PW24**, August 16, 2024 draft, local SHA-256
`c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`:

- Section 6.1, Theorem 6.1 and proof, printed 106--107 / PDF 131--132:
  the product conditional-law premise and its distinction from independent
  sources motivate the C17 producer interfaces. Information identities,
  inequalities, equality conditions and capacity consequences are not C17 results.
- Section 19.1, printed 370--375 / PDF 395--400, especially Definition 19.1
  and equations (19.1)--(19.3), printed 371--372 / PDF 396--397: a finite
  block channel is a conditional law, with repeated identical coordinate
  channels giving the stationary memoryless specialization. C17 supplies finite
  raw PMF channels for each length, including the useful zero-length extension;
  it does not formalize the section's general sequence-of-kernels abstraction.
- Definition 19.2's encoder/decoder context is a future interface check only.
  Its erasure convention, capacity definitions and average/maximal-error results
  are outside C17. C23 retains the roadmap's deterministic non-erasure model and
  its own future approval; no code cardinality or units decision is made here.

The exact local PDF was hashed and the mathematical displays on PDF
131--132 and 396--397 were visually inspected. Do not transfer PW22 numbering
or claim the changing author-hosted URL identifies this copy. Probability
algebra uses `ENNReal`; canonical future information units remain nats.

Future Work Note 31 in `docs/project-log.md` deferred a binary constructor
until a second consumer and ownership review. C17's concrete independent-input
processing, sequential product processing and correlated-input consumers now
motivate one finite-family constructor below Shannon. No additional binary
constructor or Shannon synonym is selected. Retain a private compatibility
consumer for the old binary expression, and perform the Note 14 naming audit.

## 3. Mathematical contracts

Names and headers below are proposed, not implemented declarations. On approval,
the equations, hypotheses, orientations and required consumer facts are normative.
Proof routes in the notes remain advisory. Use separate universes `u v w z t`:
`I : Type u`, `A : I → Type v`, `B : I → Type w`, and when needed
`C : I → Type z` or `J : Type t`. A dependent family has a common fiber universe;
do not introduce mixed-universe casts or identify the input/output universes.

### 3.1 Product rows and restriction

In namespace `PMF`, propose:

```lean
noncomputable def productChannel
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (W : ∀ i, A i → PMF (B i)) :
    ((i : I) → A i) → PMF ((i : I) → B i)
```

Its defining equation is exactly
`productChannel W x = finiteProduct (fun i => W i (x i))`.
There is no input-law argument. Normalization is inherited from `finiteProduct`;
do not construct another normalized mass representation or export a redundant
normalization witness.

With precisely these instances, expose:

```lean
theorem productChannel_apply
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (W : ∀ i, A i → PMF (B i))
    (x : (i : I) → A i) (y : (i : I) → B i) :
    productChannel W x y = ∏ i, W i (x i) (y i)

theorem mem_support_productChannel_iff
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (W : ∀ i, A i → PMF (B i))
    (x : (i : I) → A i) (y : (i : I) → B i) :
    y ∈ (productChannel W x).support ↔ ∀ i, y i ∈ (W i (x i)).support

theorem productChannel_map_eval
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (W : ∀ i, A i → PMF (B i)) (x : (i : I) → A i) (i : I) :
    (productChannel W x).map (fun y => y i) = W i (x i)
```

These names provide channel-facing discovery for the requested row interfaces.
Their proofs must reuse C16; separate support-set, real-mass and zero-iff aliases
are not selected. Derive and exercise the zero-atom equivalence privately.

The selected restriction header is:

```lean
theorem productChannel_map_restrict
    {I : Type u} {J : Type t} {A : I → Type v} {B : I → Type w}
    [Fintype I] [Fintype J] [∀ i, Fintype (B i)]
    (W : ∀ i, A i → PMF (B i)) (x : (i : I) → A i) (e : J ↪ I) :
    (productChannel W x).map (fun y j => y (e j)) =
      productChannel (fun j => W (e j)) (fun j => x (e j))
```

The selected input/output fibers are exactly `A (e j)` and `B (e j)`.
For an arbitrary, possibly infinite ambient index `T` and a finite selection
`s : Finset T`, first instantiate `productChannel` on the finite subtype
`{i : T // i ∈ s}`. Supply channels and finite output instances only for these
selected coordinates. Restriction then operates between finite selected families,
using an embedding into this subtype; it does not project an infinite product
channel. No ambient `Fintype T` or finiteness outside `s` is required.
Nested selection agrees with the direct embedding by existing `map_comp`.
Genuine reindexing follows from this law or `finiteProduct_map_reindex`, using
`(Equiv.piCongrLeft B e).symm`.
Retain a heterogeneous round trip without adding an equivalence wrapper.

Injectivity is necessary: repeating a noisy output coordinate repeats the same
sample, whereas the product of the repeated row samples independently. Retain
the fair-Boolean off-diagonal counterexample. Repetition of the same input value
at *different channel coordinates* is allowed and is not repeated output
sampling; the distinction must remain explicit.

### 3.2 Independent-input processing and channel algebra

The additional finite-input premise belongs only to constructions using a
finite product of input laws. Expose:

```lean
theorem finiteProduct_bind_productChannel
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (p : ∀ i, PMF (A i)) (W : ∀ i, A i → PMF (B i)) :
    (finiteProduct p).bind (productChannel W) =
      finiteProduct (fun i => (p i).bind (W i))

theorem channelComp_productChannel
    {I : Type u} {A : I → Type v} {B : I → Type w} {C : I → Type z}
    [Fintype I] [∀ i, Fintype (B i)] [∀ i, Fintype (C i)]
    (W : ∀ i, A i → PMF (B i)) (V : ∀ i, B i → PMF (C i)) :
    channelComp (productChannel W) (productChannel V) =
      productChannel (fun i => channelComp (W i) (V i))

theorem productChannel_deterministicChannel
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (f : ∀ i, A i → B i) :
    productChannel (fun i => deterministicChannel (f i)) =
      deterministicChannel (fun x i => f i (x i))
```

Composition samples `W` first, then `V`, as in the retained `channelComp`.
The composition theorem must not acquire finite original-input alphabets or an
input-law hypothesis: at each `x`, the intermediate product law is available.
No positivity, support inclusion, nonempty index or full-support assumption is
needed. Use finite `ENNReal` sum/product interchange; avoid division and a
measure-theoretic Fubini import.

Required derived consumers: identity and constant channels; coordinatewise
deterministic preprocessing/postprocessing through the existing deterministic
composition laws; and
`(finiteProduct p).map (fun x i => f i (x i)) =
 finiteProduct (fun i => (p i).map (f i))`.
This last law is obtained from the bind and deterministic interfaces, without
exporting a second coordinatewise-processing API. On any input law `q`, use
`bind_channelComp` to identify sequential and composite output laws exactly.

### 3.3 Repeated channels and finite block transports

Choose **`memorylessChannel`**, documenting that it repeats the *same* channel;
`productChannel` also allows nonidentical coordinate channels. There is no
second spelling `iidChannel` or new independence predicate.

```lean
noncomputable def memorylessChannel
    {A : Type v} {B : Type w} [Fintype B]
    (W : A → PMF B) (n : ℕ) : (Fin n → A) → PMF (Fin n → B)
```

The defining equation is
`memorylessChannel W n = productChannel (fun _ : Fin n => W)`.
The phrase iid specialization refers to identical channel use and conditional
independent sampling, not an iid input or an unconditional iid output.
Every atom/support/evaluation/restriction/composition/deterministic consumer
uses the general contracts by unfolding the thin definition.

For general homogeneous alphabets and nonidentical
`W : Fin (m+n) → A → PMF B`, at every `x : Fin (m+n) → A`, require the
following **derived**, permanently exercised split law:

```text
(productChannel W x).map (Fin.appendEquiv m n).symm
  = channelJoint
      (productChannel (fun i => W (Fin.castAdd n i))
        (fun i => x (Fin.castAdd n i)))
      (fun _ => productChannel (fun j => W (Fin.natAdd m j))
        (fun j => x (Fin.natAdd m j)))
```

The first output is the prefix, the second the suffix. Apply C16's
`finiteProduct_map_append_symm` to the row and use
`channelJoint_finiteProduct_map_append` for inverse concatenation. Exercise
both projections, the inverse and an explicit nonidentical `1+2` case.
Sum-indexed dependent blocks likewise reuse `finiteProduct_map_sum`.
No additional public split/concatenation names are required in C17.

For `e : Equiv.Perm (Fin n)`, the required covariance is

```text
(memorylessChannel W n x).map (fun y i => y (e i))
  = memorylessChannel W n (fun i => x (e i)).
```

Do not replace this by unconditional invariance at a fixed nonconstant input.
Restriction to a prefix/suffix gives the channel on the corresponding input
prefix/suffix; it is unaffected by the discarded input coordinates. The same
finite restriction law supplies compatibility across lengths for any supplied
sequence of coordinate channels, without constructing an infinite law.

At length zero the row is the pure unique empty output and its sole atom is 1.
At length one evaluation of input/output identifies the channel with `W`, and
the inverse `Equiv.funUnique` reconstruction recovers the one-letter row.
Include `0+n`, `n+0` and `0+0`; do not add `n > 0` to probability laws.

### 3.4 Joint laws for arbitrary and independent inputs

For arbitrary `q : PMF ((i : I) → A i)` and `K = productChannel W`, the
joint is **exactly** `channelJoint q K`. Existing channel laws and Section 3.1
give the following required derived facts:

```text
channelJoint q K (x,y) = q x * ∏ i, W i (x i) (y i)
(x,y) ∈ (channelJoint q K).support
  ↔ x ∈ q.support ∧ ∀ i, y i ∈ (W i (x i)).support
(channelJoint q K).map Prod.fst = q
(channelJoint q K).map Prod.snd = q.bind K.
```

There is no finite-input, independence or support premise here beyond the
instances needed for `K`. Expose two genuinely useful joint transport laws:

```lean
theorem channelJoint_productChannel_map_eval
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (B i)]
    (q : PMF ((i : I) → A i)) (W : ∀ i, A i → PMF (B i)) (i : I) :
    (channelJoint q (productChannel W)).map (fun xy => (xy.1 i, xy.2 i)) =
      channelJoint (q.map (fun x => x i)) (W i)

theorem channelJoint_productChannel_map_restrict
    {I : Type u} {J : Type t} {A : I → Type v} {B : I → Type w}
    [Fintype I] [Fintype J] [∀ i, Fintype (B i)]
    (q : PMF ((i : I) → A i)) (W : ∀ i, A i → PMF (B i)) (e : J ↪ I) :
    (channelJoint q (productChannel W)).map
        (fun xy => ((fun j => xy.1 (e j)), (fun j => xy.2 (e j)))) =
      channelJoint (q.map (fun x j => x (e j)))
        (productChannel (fun j => W (e j)))
```

Derive the corresponding output laws by mapping `Prod.snd`, in particular
`(q.bind K).map (fun y => y i) = (q.map (fun x => x i)).bind (W i)`.
General block output restriction similarly uses the restricted *actual* input
law. Mixing conditional product rows under correlated inputs need not produce
an independent output product. No separate exported output-marginal alias is
selected.

For independent inputs, expose the canonical forward factorization:

```lean
theorem finiteProduct_channelJoint_map
    {I : Type u} {A : I → Type v} {B : I → Type w}
    [Fintype I] [∀ i, Fintype (A i)] [∀ i, Fintype (B i)]
    (p : ∀ i, PMF (A i)) (W : ∀ i, A i → PMF (B i)) :
    (finiteProduct (fun i => channelJoint (p i) (W i))).map
        (Equiv.arrowProdEquivProdArrow I A B) =
      channelJoint (finiteProduct p) (productChannel W)
```

The equivalence splits the tuple of coordinate `(input,output)` pairs into
the ordered pair of input/output words. Its inverse zips the words; derive and
exercise that inverse equality without adding a second public alias. The
coordinate-pair alphabet lives in `Type (max v w)`, without equating `v` and `w`.
Use exact laws, not only an atom factorization or an independence proposition.
Specialize to `iid p n` and `memorylessChannel W n`; the joint becomes the
transport of `iid (channelJoint p W) n`, and the output is `iid (p.bind W) n`.
These are derived consumers, not new iid theorem families.

### 3.5 Support, empty alphabets and semantic boundary

`Fintype I` and finite output fibers expose finite products and enumerate outputs.
No public `DecidableEq`, `Nonempty`, measurable-space, full-support or positive-mass
premises are added. Use `classical` internally. No `Finite` convenience overload
is selected; it would not remove the constructor's finite enumeration.

Zero row/input masses remain legal everywhere. A zero coordinate output mass
annihilates the row atom; a zero input mass annihilates the joint atom regardless
of its defined row. PMF atoms are never top. No logarithm, division or Real KL
conversion is part of these contracts.

An empty index has a unique input and output word even if the proposed base
alphabets are empty. A present input coordinate with an empty alphabet makes
the input-word type empty: raw channels and their pointwise equations may still
exist vacuously, but an input PMF cannot be supplied. A nonempty input alphabet
with empty output cannot supply a channel row. In particular,
`Empty → PMF Empty` exists vacuously although `PMF Empty` does not.
`memorylessChannel W 0` still takes a supplied `W`; unlike `iid p 0`, this does
not imply a base PMF exists. Test the empty-to-empty channel at zero and positive
lengths, and the impossible nonempty-input/empty-output case. Never manufacture
a fallback law to hide an empty alphabet.

The given product row is defined at every input word. Conditional laws recovered
from its induced joint agree with it only on `q.support`. Reuse
`channelJoint_eq_iff_eq_on_support` and the existing conditional reconstruction
after swapping coordinates; do not assert global equality with a total
conditional channel. Its documented null-fiber fallback remains unchanged and
has no conditional probabilistic meaning there.

S2 must include the following **generic private consumer** in
`Examples.ProductChannelSemantics`, followed by its specialization to
`K = PMF.productChannel W` under an arbitrary input-word law:

```lean
private theorem supported_channel_row
    {X : Type v} {Y : Type w} [Fintype Y]
    (q : PMF X) (K : X → PMF Y) {x : X} (hx : x ∈ q.support) :
    LeanInfoTheory.Shannon.condFstGivenSndChannel
      ((PMF.channelJoint q K).map Prod.swap) x = K x
```

No finite-input, full-support or additional nonempty premise belongs on this
consumer. Finite output words provide its `Fintype Y` instance in the product
specialization. This is a private application of existing reconstruction and
support-sensitive equality, not another exported conditional-channel theorem.

Also retain a concrete comparison of **two product channels**. Use two Boolean
coordinates and input law concentrated on the all-false word. Start with the
identity channel at both coordinates; change only coordinate 0's row at `true`
to `PMF.pure false`. The two product channels agree on the input support, so
their induced joints are equal, but their rows at the word `(true,false)` differ.
The changed coordinate value is absent from its input marginal support. A null
whole word alone would not justify a coordinate-row change, since that value
could occur in another supported word. Keep the null-fallback convention intact;
the concrete comparison complements, and cannot replace, the generic recovery
consumer above. All these conditional and null-fiber semantic consumers belong
to C17.04.

Semantic consumers use existing C16 mutual independence on each fixed row and
on the independent coordinate-pair product. They may use existing
`familyMarginal`/`familyLawOf` and `indepProd`; no new semantic owner or global
predicate is required. The old binary independently sampled law is obtained by
existing tuple/pair equivalences or C16 pair projection, without a binary-channel
alias. Preserve all old semantic signatures and imports.

## 4. Ownership, public surface and dependencies

| Owner | Selected responsibility |
| --- | --- |
| New `LeanInfoTheory/Probability/ProductChannel.lean` | All 12 proposed public declarations below, in `PMF`. Direct local import `Probability.Iid`, which already reaches `FiniteProduct` and `FiniteChannel`; focused mathlib imports only when actually needed. No project Shannon, information, KL, topology, kernel, measure-bridge or example import. |
| New `Examples.ProductChannel` | Private elementary consumers, importing only `Probability.ProductChannel`. |
| New `Examples.ProductChannelSemantics` | Private compatibility consumers importing `Probability.ProductChannel`, `Shannon.SemanticBridge.FiniteProduct` and `Shannon.SemanticBridge.Markov`, plus a focused existing owner only when a used declaration needs it. |
| Existing `LeanInfoTheory.Shannon` | Add the focused probability owner to the full opt-in umbrella; retain existing imports. |
| Existing `LeanInfoTheory.Examples` | Add both private consumer owners so maintained aggregate validation exercises them. |

One owner is intentional: the repeated-channel specialization is thin, and C16
already owns block transport. Do not add an otherwise empty memoryless or semantic
owner. `FiniteChannel` must not import `ProductChannel`: C16 already imports
`FiniteChannel`, so that direction would create a cycle and enlarge old boundaries.
`LeanInfoTheory.lean` retains its exact two direct imports, five-module local
closure and 92 exports. Existing focused owner direct imports stay intact.

The selected public surface is two definitions and ten theorems:

| Step | Proposed declarations |
| --- | --- |
| C17.01 | `productChannel`, `productChannel_apply`, `mem_support_productChannel_iff`, `productChannel_map_eval`, `productChannel_map_restrict` |
| C17.02 | `finiteProduct_bind_productChannel`, `channelComp_productChannel`, `productChannel_deterministicChannel` |
| C17.03 | `memorylessChannel` |
| C17.04 | `channelJoint_productChannel_map_eval`, `channelJoint_productChannel_map_restrict`, `finiteProduct_channelJoint_map` |

This is a bounded proposed surface, not a growth quota. The repeated-channel
atom/support/zero/one/reindex/split/inverse and Real-mass forms remain consumer
derivations. Keep algebraic helpers private. New aliases or an additional public
contract need concrete pressure and an explicit recorded plan-health decision;
do not quietly strengthen assumptions to make a proof compile.

Default to **no new simp attributes**. Factorization, composition and transport
equalities remain explicit. Audit naming against retained vocabulary, generated
index, actual Lean declarations and pinned mathlib before adding names. Do not
rename existing APIs or change the old MI theorem to use a new representation.

After exact approval, record each actual declaration/owner/import addition and
its approval provenance in `docs/compatibility/current-api-policy.json`, then
deliberately regenerate current inventory and source-derived website artifacts.
Generated inventory supplies no authority. Preserve the frozen manifest,
retained signatures, trust policy and exact EPFL/MIL headers.

## 5. Permanent consumer matrix

All new example declarations are private or anonymous. They must use the public
producer APIs, not merely unfold definitions to bypass missing interface proofs.
Tiny private fixtures may repeat across owners to preserve lightweight imports.

| ID / owner | Required evidence |
| --- | --- |
| P1 / `Examples.ProductChannel` | Heterogeneous and nonidentical input-dependent coordinate channels, with Boolean and sparse ternary output rows. Exact supported/impossible atoms, support, normalization through the PMF, evaluation and singleton restriction; include an actual zero row mass. |
| P2 / same | Three-to-two-to-one selection equals direct restriction; genuine heterogeneous reindex round trip; construct on a finite selected subtype of an infinite ambient index and then restrict within that finite family, with no ambient finiteness requirement; repeated-output counterexample (off-diagonal zero versus independent mass `1/4`). |
| P3 / same | Nonidentical independent inputs and stochastic rows use `finiteProduct_bind_productChannel`; sequential nontrivial stochastic channels use `channelComp_productChannel` in the correct order. Include an atom distinguishing reversed order. Coordinatewise deterministic maps, identity and constant channels use the selected reductions. |
| B1 / same | Repeated channel with nonconstant input, exact row/support/coordinate laws, genuine permutation covariance, prefix/suffix restriction, nonidentical `1+2` split and inverse concatenation, plus repeated-channel specialization. |
| B2 / same | Zero/one lengths, `0+n`, `n+0`, `0+0`, singleton outputs, empty-index/empty-output construction, empty-to-empty channel, and impossibility of a PMF on a present empty input or a row on an empty output from a nonempty input. |
| J1 / same | Independent inputs use full coordinate-pair joint factorization, forward and inverse tuple/pair transport, output factorization and the same raw `channelJoint`; sparse input and output masses, plus zero/one-length specializations. |
| J2 / same | Correlated diagonal Boolean input (fair common bit repeated twice) through the repeated identity channel remains diagonal: off-diagonal atom 0, diagonal atom `1/2`, while the product of output marginals has off-diagonal atom `1/4`. Apply arbitrary-input coordinate and block joint laws without an independence premise. |
| J3 / same | Same correlated input with stochastic `W false = fair`, `W true = pure true`: output atom `(false,false)` is `1/8`, whereas the product of output marginals assigns `1/16`; each fixed row still factors. Verify actual joint/output marginals through the public laws. This distinguishes a nontrivial noisy example from a pure-channel tautology. |
| J4 / same | Retain the generic deterministic source-to-word pushforward/composition law without injectivity. Also use two independent fair Boolean source coordinates `(a,b)` mapped to the word `(a,a)`: the map is nonconstant and has collisions between supported source values. Verify that its pushforward is the fair diagonal input from J2/J3; pass it through J3's noisy repeated channel and use existing deterministic composition and `channelExtension_map_endpoints` to check the joint/extension endpoint identities against direct sampling. Reuse the same diagonal and noisy fixtures. This is a law/composition consumer, with no code structure, rate, decoder or information bound. |
| S1 / `Examples.ProductChannelSemantics` | Fixed rows reach existing selected-family and full mutual-independence semantics, including a full three-coordinate nonidentical row; independent coordinate pairs reach that same predicate using the inverse J1 transport. Binary output compatibility agrees with the released `indepProd` expression used in `mutualInfo_independent_channels_le`. No new information result. |
| S2 / same | Prove Section 3.5's generic private supported-input reconstruction with arbitrary input type and finite output type, then specialize it to product channels. Separately exercise the two-product-channel comparison specified there: change a coordinate row at a value absent from its input marginal support, obtain unequal raw channels but equal induced joints by `channelJoint_eq_iff_eq_on_support`. Preserve the null fallback without claiming global recovery. |
| I1 / separate focused probes | Independent index/input/output universes; a genuinely infinite input alphabet with finite outputs for constructor, composition and arbitrary-input joint laws; exact new-owner import closure excludes project Shannon/KL/topology. Full umbrella and retained consumers preserve root, old owner/import/simp and trust contracts. |

## 6. Ordered steps and acceptance criteria

Order: **C17.01 → C17.02 → C17.03 → C17.04 → C17.05**.
Each step includes its applicable permanent consumers, documentation, validation,
self-review/reassessment, independent review and supported closure from Section 7.
One eligible explicit request selects one approved step and then stops. Later
contracts may guide design, but their production implementation stays in their
own selected step. There are 15 criteria, all required.

### C17.01 — Product rows, support and coordinate restriction

Implement Section 3.1 in the new focused owner. Section 3.5 contributes only
constructor-level zero masses, empty-index/empty-alphabet distinctions and
basic empty/pure-row facts to this step. Add P1/P2 and I1's constructor/import
probes. Repeated-channel zero/one and split cases belong to C17.03; generic
conditional recovery and the two-product-channel null-input comparison belong
to C17.04/S2. Register only this step's actual approved growth.

- **C17.01-ROWS:** The normalized raw constructor and exact atom/support/evaluation contracts hold with separate universes and finite outputs only; no input law, finite-input, positivity or nonempty premise is introduced.
- **C17.01-RESTRICTION:** Injective restriction has the exact dependent input/output types; nested restriction, heterogeneous reindexing and repeated-output failure are exercised through P1/P2.
- **C17.01-BOUNDARY:** Empty-index/empty-alphabet distinctions, construction on finite selected subtypes without ambient finiteness, and infinite-input consumers compile; focused imports, retained API/root/simp contracts and trust boundaries are preserved.

Focused validation: new owner, `Examples.ProductChannel`, root, full `Shannon`
and `Examples` aggregates, existing C16 probability consumers; applicable
static/documentation/trust checks and fresh standalone import/type probes.

### C17.02 — Independent processing, composition and deterministic reduction

Implement Section 3.2 and P3. Derive composition from the independent-input
bind law at each input row. Keep finite sum/product proof machinery private;
do not implement joint factorization early merely to avoid its planned owner step.

- **C17.02-BIND:** Independent input products produce the exact product of component output laws, with the stated finite-input/output hypotheses and zero masses allowed.
- **C17.02-COMPOSITION:** Sequential product channels equal the coordinatewise composite in sampling order; arbitrary original inputs and finite intermediate/final alphabets suffice, and stochastic order-sensitive consumers pass.
- **C17.02-DETERMINISTIC:** Coordinatewise deterministic channels reduce to the existing deterministic-channel function; identity, constant, pre/postprocessing and finite-product map consumers reuse retained APIs without extra exported aliases.

Focused validation: C17.01 targets plus existing `Examples.StochasticChannels`;
compile the no-finite-original-input composition signature independently. Apply
the per-step static/documentation/trust gates. Reassess feasibility if dependent
finite sum/product interchange cannot establish the approved assumptions.

### C17.03 — Repeated-channel specialization and block interfaces

Implement only the thin repeated-channel definition and the Section 3.3/B1/B2
consumer family, reusing C16 transport and C17.01--02. No extra block datatype,
split equivalence, split alias or repeated-channel theorem family is selected.

- **C17.03-MEMORYLESS:** The repeated channel is a specialization of the same constructor and generic laws; nonconstant-input permutation covariance and prefix/suffix consistency have the stated orientation without input independence.
- **C17.03-BLOCKS:** Nonidentical `1+2` rows and repeated-channel rows split/reconstruct exactly through existing Fin equivalences, with both block marginals and inverse concatenation exercised.
- **C17.03-DEGENERATE:** Zero/one lengths and both empty split sides, singleton outputs and empty-alphabet/vacuous-channel distinctions satisfy B2 with no positive-blocklength premise or fabricated base PMF.

Focused validation: product owner/consumer, existing `Examples.Iid` and root/full/
example aggregates; standalone block/import consumers and the per-step gates.

### C17.04 — Joint-law compatibility and semantic consumers

Implement Section 3.4's three public theorems and J1--J4/S1/S2. Add the separate
private semantic consumer owner. Use existing semantic bridges rather than
introducing new public Shannon declarations. Explicitly document the C18/C23
producer interfaces and support boundary from Section 8.

- **C17.04-JOINT:** For arbitrary input laws, exact coordinate/block joint and output marginal laws, joint atoms/support and sequential sampling compatibility hold; J2/J3 demonstrate correlated inputs and non-product unconditional outputs. J4 supplies the generic source-to-word law without injectivity and the concrete nonconstant `(a,b) ↦ (a,a)` regression with supported collisions and correlated codewords.
- **C17.04-FACTORIZATION:** Independent-input joint laws equal the transported product of coordinate joints through the existing dependent equivalence; both directions, sparse laws and iid zero/one specializations are permanently exercised.
- **C17.04-SEMANTICS:** S1/S2 reach the existing family/independence/binary/conditional APIs. S2 supplies generic supported-input reconstruction without finite-input or full-support premises, its product-channel specialization, and the two-product-channel null-input comparison; all old public contracts/imports and the null fallback remain intact, and no C18/C23 endpoint is added.

Focused validation: both new consumer owners, all C16 consumer owners,
`Examples.StochasticChannels`, `Examples.SupportSensitive`, root/full/example
aggregates; new standalone consumers, static/documentation and full trust/
compiled compatibility. Check the complete API and all import boundaries.

### C17.05 — Cumulative qualification, fresh review and maintained handoff

Add no mathematical endpoint. Verify all predecessor closures and applicability;
finish canonical reconciliation, remaining-work dispositions and
`docs/handoffs/chunk-17.md` before final capture. Prepare a concrete scoped
checkpoint proposal if needed for the clean gate; obtain separate authority
before committing or reusing/creating a validation checkout.

- **C17.05-VALIDATION:** The exact cumulative candidate passes the complete maintained clean routine suite, all permanent/focused import consumers, retained/current API, owner/import/simp, trust, documentation and hygiene gates. Obtain a fresh actual two-pass current file-mode API-doc gate and inspect the new ProductChannel owner page and all new declaration signatures/docstrings; preserve exact source/configuration/dependency/output applicability and repeat required gates after amendments.
- **C17.05-READINESS:** Finished owned edits, actual applicable validation, retained contextual self-review, separate reassessment and explicit reconciliation of every earlier report establish readiness for fresh independent cumulative review of all 15 criteria. Original report receipt/reconciliation and supported final closure are subsequent duties, not assumed pre-dispatch successes.
- **C17.05-HANDOFF:** Canonical documents and the maintained C17 handoff accurately state delivered APIs/imports/consumers, mathematical source adaptations, input-versus-conditional independence, finite/empty/support/null-fiber conventions, actual evidence limits, and explicit remaining-work owners/triggers including separate C18/C23 contracts; no release or next-chunk work is started.

The fresh cumulative report assesses every C17.01--C17.05 criterion. Reconcile
its original findings and criterion assessments through the installed workflow;
reviewer gaps require a fresh satisfactory reviewer assessment. Complete final
validation, document finalization, R-to-F applicability and `project_closure`
against exact F. Captured documents remain provisionally worded; only the
supported private completion record and final user report assert actual closure.

## 7. Validation, review and documentation gates

Use `python -B scripts/validate_release.py focused <targets>` for touched owners,
important downstream consumers and aggregates. Serialize artifact-producing Lean
builds and inspect diagnostics. Independently compile the new focused examples
with warnings as errors. Retain actor, exact source, command, exit status and
limitations; successful compilation is not a mathematical review or a cold-build
claim. There is no requirement to rerun the complete suite at every small step.

For every approved public/import change, deliberately regenerate current API,
website blueprint and declaration index; run the frozen manifest verifier in
check mode. Run `validate_release.py static`, `documentation`, and `trust`
(including compiled compatibility) before each step's review/closure. Inspect
actual direct imports, transitive project reachability, public/private ownership,
retained types and simp sets. Generated probes supplement permanent mathematical
consumers; they do not replace them. No proof placeholder or trust escape is allowed.

While dirty, report the limitation and use supported focused/static gates. The
complete default validator requires a clean committed candidate. This proposal
does not authorize a commit or absorb unrelated work to pass that gate. At C17.05,
finish a reviewable scoped change set first and seek any required separate
checkpoint/checkout authority. Inspect a proposed validation checkout under the
repository's ignored `.worktrees/` and compare its exact source/configuration/
dependencies; earlier-chunk authorization and path-dependent evidence do not
transfer. Pending authority or a failed gate means closeout remains incomplete.

C17 closeout is a current API-documentation milestone, not release preparation.
The separate actual two-pass `validate_release.py api-docs` gate uses reviewed
Zig 0.16.0 through `LEANINFOTHEORY_ZIG` on Windows. Inspect current local output
under `docbuild/.lake/build/doc/`; do not change the frozen v0.1.0 route, stage a
release or publish. A documentation-only amendment still needs appropriate
clean-suite rerun and exact API-documentation applicability.

The actual parent owns the persistent `/root/c17_reviewer` binding, requested
`gpt-6-astra` / `ultra`, with `fork_context=false` realized by the exposed
`collaboration.spawn_agent(..., fork_turns="none")` transport. Preserve original
creation/list/dispatch results; observable effective settings remain unknown.
Cooperative read-only instructions do not establish OS isolation. No previous
chunk's reviewer is reused. A missing capability or refusal must be reported,
not replaced silently or bypassed by journal edits.

Formal PLAN workflow starts only on an explicit plan-review request. An execution
session requires exact plan approval; each actual eligible message selects one
named step. Follow `docs/review-protocol.md` and `docs/review-operations.md`:
capture B before owned edits; retain contextual self-review and separate
reassessment; finish edits and applicable validation before neutral source-bound
review dispatch at R; preserve original reports/native results; reconcile every
finding and required criterion even for clean reports; perform justified
corrections and final checks; finalize all documents before F; use supported
closure. Material changes to mathematical meaning, public contracts, required
scope, acceptance policy or pins require the lead. Review grants no later step,
commit, publication or next-chunk authority.

Canonical closeout reconciliation covers relevant living-summary quick start,
status/coverage/architecture/future-work/validation sections;
`docs/current-lean-state.md`; the roadmap execution status; the reference register;
meaningful project-log entries; reviewed growth policy and generated current
references; this plan's editorial status, notes and maintained handoff.
Preserve unrelated project-log hunks and `docs/next-website-tasks.md` untouched.
Do not modify stable operating rules or review tooling as incidental C17 work.

## 8. Future interfaces, risks and decisions

### 8.1 Handoff interfaces and remaining-work dispositions

| Recipient / disposition | Exact interface or reopening trigger |
| --- | --- |
| C18, later separately approved | Pointwise row product, actual arbitrary-input coordinate joint laws, independent-input joint factorization, and iid specialization. Use existing C16 full mutual independence for row/pair products. `condEntropy` is first given second: output-given-input uses the swapped joint; S2 demonstrates generic recovery of its row on input support with finite outputs only, using existing public APIs. Existing `mutualInfo_channelJoint_eq_entropy_bind_sub_sum` supplies an established MI expression; C18 owns new entropy/KL/additivity/bounds and any gap/equality refinement. |
| C23, later separately approved | `memorylessChannel W n` accepts any input word and arbitrary induced word law. J4 demonstrates both generic deterministic source pushforward and a nonconstant map with supported collisions and correlated codewords; `channelJoint`, `channelComp`, deterministic reduction and `channelExtension_map_endpoints` compose unchanged. C23 owns code/message/error/Markov proof packaging, rates, Fano converse and the C18/C22 bounds; no iid codeword assumption is valid. |
| C19 / C22, deferred | C19 retains supported logs/AEP; C22 retains capacity/attainment/additivity. C17 changes no contracts or selected steps in those chunks. |
| General bind/map helpers, binary aliases or new semantic wrappers, deferred | Promote only after real independent consumers and naming/ownership review; existing equivalences and private derivations are the default. |
| Infinite outputs/processes/feedback/new channel representation, excluded | Separate mathematical scope and architecture approval, not proof convenience. |
| Clean checkpoint, push, release preparation/publication, later chunk | Separate explicit authority; no C17 planning or workflow result grants it. |

### 8.2 Genuine feasibility risks

1. **Dependent transports and universes.** Restriction changes both fiber
   families; joint factorization uses a universe-max pair family. Existing
   signatures are available, but the new full proof/elaboration has not been
   compiled in this planning turn. Early approved-step generic consumers must
   detect accidental equal-universe or finite-input assumptions.
2. **Finite bind/product interchange.** `Fintype.prod_sum`, `PMF.bind_apply`
   and `tsum_fintype` supply the anticipated proof route; arranging dependent
   products and multiplications may require private lemmas. Source inspection
   is feasibility evidence, not a completed C17 proof. Do not respond to proof
   difficulty by imposing full support or pulling in heavy measure machinery.
3. **Transport orientation.** Pair-of-words versus word-of-pairs, prefix/suffix
   order and simultaneous input/output reindexing can silently describe different
   laws even when types elaborate. The inverse, `1+2`, order-sensitive and
   correlated stochastic consumers are required to distinguish them.
4. **Conditional interpretation at null inputs.** Reconstruction cancellation is
   legitimate on support only. Existing support-sensitive equality and total
   conditional fallback already settle the convention; a global recovery theorem
   would change meaning and is disallowed.
5. **Qualification authority and runtime.** The full routine needs a separately
   authorized clean checkpoint, and actual two-pass API docs may be expensive or
   expose stale build output. Retain failures and exact applicability; do not
   substitute static checks, old output or another chunk's gate for required
   final evidence. The workflow's native transport may expose no effective model
   settings; record that limit without inventing it away.

### 8.3 Exact revision decision

Approve revision 2 only after reviewing its five steps, 15 criteria, 12 proposed
public contracts, one focused probability owner, two private consumer owners,
finite-output/no-input-law construction, support/empty conventions and cumulative
qualification requirements. The name `memorylessChannel` deliberately denotes
the repeated identical-channel specialization. No mathematical requirement is
left intentionally undecided; proof routes and minimal mathlib imports remain
implementation advice. Formal plan review requires its own explicit request and
does not itself approve execution. After approval, wait for one explicitly
requested eligible step with its review process, complete that step and stop.
