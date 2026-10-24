# Mathematical Reference Register

This register identifies mathematical sources and exact local editions used
for project planning. It is not a claim that an entire book has been read or
formalized. Implementation coverage belongs in the living summary and approved
chunk plans; historical source usage remains in the project log.

The local filenames below are relative to `info theory e-books/`. These PDFs
are private reference material, not repository dependencies or files to commit.
Use the source ID, exact section/theorem, and edition in future plans and
mathematical documentation. Do not reproduce textbook prose or proofs.

## Source selection

- `CT91` remains the Chapter 2 historical anchor and supplies the textbook
  AEP/typical-set and finite-channel viewpoints.
- `PW24` is the preferred Polyanskiy--Wu planning reference for the proposed
  post-release programme. Keep `PW22` for provenance of earlier citations;
  never silently transfer a theorem/equation number between versions.
- `SA13` and `LP17` supplement finite coupling and quantitative continuity.
  Registering a source does not approve its entire theorem set.
- On a source conflict, compare exact statements, support/degeneracy
  conventions, units, and code/error models. Record the project adaptation in
  the owning plan rather than quietly changing the mathematical contract.
- Local statements and mathematical facts may guide formalization; external
  implementation reuse remains governed by `AGENTS.md`.

## CT91: Cover and Thomas

Thomas M. Cover and Joy A. Thomas, *Elements of Information Theory*, Wiley,
1991 edition. The local title/copyright pages identify 1991; channel capacity
is Chapter 8 in this edition, not Chapter 7.

- Local file: `Elements_of_Information_Theory_Elements.pdf` (563 PDF pages).
- SHA-256: `16f016eafbb1160c2d8e6c29ff28db870e0eb2e61c15ea39bea5b06d463a952f`.
- Historical coverage: Chapter 2, as documented in living-summary Section 15.
- Recorded C9 use: Section 2.8, printed pages 32--33/PDF 54--55, supplies
  deterministic-processing context for `isIndependentOf_comp_right`; its
  arbitrary-type PMF proof has no finite or measurable-space premise.
  Sections 2.4, printed pages 19--21/PDF 41--43, and 2.5, printed pages
  21--22/PDF 43--44, supply MI/CMI and chain-rule context for
  `mutualInfoOf_condEntropyOf_decomposition`. The latter is a derived identity,
  not a separately named CT91 theorem. All terms use canonical nats and the
  ordered conditioning pair `(X,Z)`. The [C9 step notes](plans/post-release-chunk-09-notes.md)
  preserve actual reading, proof and consumer evidence; this registration
  claims neither new reference access nor approval of further theorem families.
- Post-release planning: Sections 3.1--3.3 (AEP, typical sets, high-probability
  sets), 8.1--8.5 (channels, capacity, coding conventions), and 8.9 (Fano
  converse). Only relevant sections are to be used, not all intervening
  chapters. Chapter 3's variable-length description argument is not by itself
  the selected fixed-length, almost-lossless coding contract.
- C22.01 adaptation: Sections 8.1–8.3, printed 184–191 / PDF
  206–213, supply the finite-channel information-capacity viewpoint. The
  implementation uses the existing PMF-valued channel objective and canonical nats,
  an explicit nonempty input domain, actual attainment and alphabet bounds.
  Prior selected-section reading is recorded in the [C22 notes](plans/post-release-chunk-22-notes.md);
  this entry claims no fresh textbook inspection. C22.01 selected-step checks and
  independent review passed; the notes distinguish review and actual closure.
- C22.02 adaptation: Section 2.8, printed 32–33 / PDF 54–55.
  The parent freshly read these pages on 2026-10-24 through pypdf text
  extraction and checked the registered hash; no fresh visual inspection
  is claimed. Capacity inequalities apply existing finite-channel DPI to
  every input law. Relabeling transports law and channel together; no public
  symmetry or optimizer framework is added. C22.02 selected-step validation and
  independent review passed; see C22 notes sections 11–12 for evidence and limits.
- C22.04 adaptation: Section 8.1.1 and the capacity properties in 8.3,
  printed 184–185 and 190–191 / PDF 206–207 and 212–213. The parent freshly
  inspected these pages as UTF-8 text on 2026-10-24 and verified the registered
  hash; no visual inspection is claimed. The binary noiseless example extends
  to finite nonempty alphabets through existing diagonal MI and uniform entropy.
  The input-independent result follows from the existing independent-joint MI
  theorem: every input has zero objective and attains zero capacity. Canonical
  nats, sparse laws and singleton alphabets are retained. This does not assert
  operational capacity or a general symmetry theorem. Selected-step validation
  and independent review passed; see C22 notes sections 15–16 for actual evidence,
  reconciliation and applicability limits.
- C22.05 adaptation: Section 8.1.4, printed 186–187 / PDF 208–209,
  supplies BSC row entropy, the output-entropy bound and uniform attainment.
  The parent freshly extracted PDF 208–210 as text on 2026-10-24 at the
  registered CT91 hash; adjacent BEC material is context, not selected work.
  Replace the bit-valued expression by log 2 minus Real.binEntropy in nats.
  The raw channel parameter is exactly the crossover probability on [0,1].
  The uniform input attains capacity, without uniqueness at crossover one half;
  every input attains zero there. Pure and biased inputs need no full-support
  premise. Selected-step validation and independent review passed, including
  the full compiled trust audit. Final applicability and scoped closure remain
  tied to the actual private completion record. See C22 notes sections 17–18.
  No operational capacity equality is asserted.
- C22.06 adaptation: Section 8.1.5, printed 187–188 / PDF 209–210,
  supplies BEC output entropy and uniform attainment. The parent freshly
  extracted those pages as text on 2026-10-24 at the registered hash, and
  compared PW24 section 19.3, printed 380 / PDF 405, with adjacent context
  from PDF 404–406 at its registered hash. No parent visual check is claimed.
  The exact all-input identity is (1-epsilon) times input entropy; the capacity
  is (1-epsilon) times log 2 in nats. This retains the erasure weight omitted
  in PW24's displayed conditional-entropy expression and avoids its unqualified
  uniform-only equality claim at full erasure. Existing finite-sum entropy
  and negMulLog product algebra cover zero masses without conditional fibers
  or division. Selected-step validation and independent review passed, including
  the full compiled trust audit. Final applicability and scoped closure remain
  tied to the actual private completion record. See C22 notes sections 19–20.
  No operational capacity equality is asserted.
- C22.07 adaptation: the parent freshly extracted CT91 printed 184 and
  187–188 / PDF 206 and 209–210, and PW24 section 6.1, Theorem 6.1(a) and
  Example 6.1, printed 106–107 / PDF 131–132, as text on 2026-10-24 at the
  registered hashes. No visual inspection is claimed. Four scalar bits
  equations follow from the existing nats capacity values through natsToBits;
  the same achieving laws remain witnesses. Private consumers convert product
  and repeated capacity identities and arbitrary-input bounds. The C23-facing
  encoded-word consumer permits noninjective encoders and correlated inputs.
  This adds no operational coding theorem or capacity definition in bits.
  Selected-step validation and independent review passed, including the full
  compiled trust audit. Final applicability and scoped closure remain tied to
  the actual private completion record. See C22 notes sections 21–22 for evidence
  and limits.
- C22.08 cumulative preparation: no new mathematical endpoint or convention.
  The [maintained handoff](handoffs/chunk-22.md) reconciles the delivered finite
  information-capacity contracts, source adaptations and boundary consumers.
  Previous readings retain their actual actors/pages/hashes. Authorized initial
  clean and current two-pass API checks passed; all 26 rendered entries were
  inspected. The actual C22.08 private completion record and linked evidence
  determine current-candidate applicability, cumulative independent review,
  substantive reconciliation and closure; no future outcome, operational
  capacity equality or C23 implementation is asserted.
- Units: typically bits; adapt through the project's existing units layer.

## PW22: Polyanskiy and Wu, historical draft

Yury Polyanskiy and Yihong Wu, *Information Theory: From Coding to Learning*,
October 20, 2022 draft.

- Local file: `Polyanskiy and Wu, Information Theory From Coding to Learning.pdf`
  (620 PDF pages).
- SHA-256: `10f0681859c27c951277fc2c2e31a17b8417369dfda4b8fe194fdda0c470f32c`.
- Retained for historical source anchors, including the earlier Section 3.5
  sufficiency and Section 6.3 Fano references. Individual older citations
  still require verification before being used as exact statement evidence.
- This is neither the newer draft nor the published 2025 edition.

## PW24: Polyanskiy and Wu, newer draft

Yury Polyanskiy and Yihong Wu, *Information Theory: From Coding to Learning*,
August 16, 2024 prepublication version. The source footer identifies the date.

- Local file: `Polyanskiy-Wu Newer.pdf` (730 PDF pages).
- SHA-256: `c76c5cd867818ef66e9d63c2f899dccdff9a501456160df153d0fa981db83de3`.
- [Author-hosted PDF](https://people.lids.mit.edu/yp/homepage/data/itbook-export.pdf).
  This URL can change; the local hash identifies the copy inspected here.
- Section 7.3, Theorem 7.7: total variation characterizations and coupling.
- Recorded C10 use: Theorem 7.7(a), equation (7.18), printed pages 122--123 /
  PDF pages 147--148, supplies attained event and bounded-test forms. C10 uses
  half-L1 probability normalization, with constants 1 for unit-interval tests
  and 2 for signed-unit tests. The displayed mathematics resolves the proof
  prose's inequality-direction ambiguity. Coupling in part (b) is C11 scope;
  C10's [handoff](handoffs/chunk-10.md#mathematical-sources-and-adaptations)
  records the finite-algebra adaptations and actual reading evidence.
- Recorded C11 use: Section 7.3, Theorem 7.7(b), equation (7.20), printed
  pages 122--123 / PDF pages 147--148, and overlap equation (7.3), printed
  page 116 / PDF page 141. The actual finite-PMF witness attains disagreement
  equal to TV. The [C11 handoff](handoffs/chunk-11.md) records the finite event
  convention, endpoint handling and remaining-work boundaries.
- Recorded C12 use: Section 7.3, Theorem 7.7(b), equation (7.20), printed
  pages 122--123 / PDF pages 147--148, for coupling conventions and the attained
  disagreement bound. Transport, finite gluing and the quantitative regressions
  are derived uses of existing PMF/channel algebra. The
  [C12 handoff](handoffs/chunk-12.md) records adaptations and limits.
- Section 7.4, Theorem 7.10: Pinsker via binary reduction; its full
  f-divergence/joint-range programme is not selected.
- Recorded C13.01 use: Theorem 7.10, equation (7.27), printed pages
  126--127 / PDF pages 151--152. The canonical finite-PMF inequality uses
  nats and half-L1 TV, so its constant is 2. The proof uses C10's attained
  event and KL map data processing, then closed-interval convexity for the
  binary estimate, with explicit reference endpoints and singular support.
  The [C13 implementation notes](plans/post-release-chunk-13-notes.md)
  record the adaptation and its validation scope.
- C13.02 derives the Real and square-root forms from that canonical theorem
  using actual support inclusion and finite KL. The sparse and singular
  consumers make the guard explicit; no further textbook theorem or stronger
  support assumption is used.
- C13.03 applies those bounds to the existing independent product of the
  joint law's marginals. Existing absolute continuity establishes finite KL
  before the MI-as-KL identity is used. Event and bounded-test estimates are
  derived uses of C10, with factor two for signed tests. This adds no separately
  numbered textbook theorem. The [C13 handoff](handoffs/chunk-13.md) records
  the delivered contracts, source adaptation and deferred refinements.
- Section 4.5, Proposition 4.8: finite entropy continuity; Section 4.7,
  Proposition 4.13: finite MI continuity. Sections 5.1--5.2 provide information
  optimization context; general-measure minimax and infinite-alphabet results
  are not commitments.
- C22.01 adaptation: Chapter 5, printed 91–105 / PDF 116–130,
  supplies optimization context. Theorem 5.4 assumes an achieving input; it
  does not prove the selected finite attainment result. The implementation instead
  applies C15 compactness and continuity to the nonempty finite-PMF domain.
  It asserts neither constrained/infinite-alphabet capacity nor operational
  coding equivalence; the C22 notes retain the earlier reading, selected-step validation and independent review.
- C22.02 adaptation: Theorem 5.3, printed 92–93 / PDF 117–118.
  The parent freshly read these pages on 2026-10-24 through pypdf text
  extraction and checked the registered hash; no fresh visual inspection
  is claimed. A private consumer combines existing input concavity and the
  capacity bound to show that mixtures of maximizing laws still maximize,
  including weights 0 and 1. No public convex-set or optimizer framework
  is introduced. C22.02 selected-step validation and independent review passed;
  see C22 notes sections 11–12 for evidence and limits.
- Section 6.1, Theorem 6.1: block MI and memoryless-channel single-letterization.
- C22.03 adaptation: Theorem 6.1(a) and Example 6.1, printed 106–107 /
  PDF 131–132. The parent freshly read the text on 2026-10-24 and checked
  the registered hash. The first extraction reached page 106 but failed to
  print page 107 under the console encoding; an explicit UTF-8 extraction
  then supplied page 107. No new visual inspection is claimed. Existing C18
  bounds for arbitrary correlated inputs and independent-product identities,
  together with C22.01 attainment, prove finite dependent-alphabet capacity
  additivity. A product of maximizers is sufficient; optimizer uniqueness
  or necessary input independence is not asserted. Empty products and n=0
  are retained, including the vacuous empty-base zero-word consumer. The
  duplicated-bit strict-gap consumer uses nats. Selected-step validation and
  independent review passed; see C22 notes sections 13–14 for actual evidence,
  reconciliation and applicability limits.
- Recorded C16 use: Section 6.1, Theorem 6.1/proof, printed pages 106--107 /
  PDF 131--132; Section 11.2, Proposition 11.6/proof, printed pages 217--218 /
  PDF 242--243, in this exact hashed draft. The planning notes record the
  original reading and visual inspection. These passages provide product
  notation and downstream motivation; C16 constructs finite-alphabet PMFs
  and proves normalization/transport using existing PMF algebra, not those
  information or AEP results. The [C16 handoff](handoffs/chunk-16.md#mathematical-sources-and-adaptations)
  records the adaptation and remaining C19 support/strict-versus-closed
  typicality decisions. Closeout does not claim new textbook inspection.
- Recorded C17 use: Section 6.1, Theorem 6.1/proof, printed 106--107 /
  PDF 131--132; Section 19.1, printed 370--375 / PDF 395--400, especially
  Definition 19.1 and (19.1)--(19.3), printed 371--372 / PDF 396--397.
  The [C17 handoff](handoffs/chunk-17.md#mathematical-sources-and-adaptations)
  records finite dependent conditional products, the identical-coordinate
  repeated specialization, and conditional versus input independence.
  C17 proves raw PMF channel/joint laws; the source information, capacity and
  coding conclusions remain later work. The notes retain earlier reading;
  closeout preparation rechecked the saved selected-page extraction, not a
  new visual PDF audit. No matrix-channel replacement is introduced.
- Section 11.1: one-shot source coding; Section 11.2, Proposition 11.6:
  AEP, typicality, and their coding consequence. These sections differ from
  the older draft, which grouped AEP under Section 11.1.
- C21.01 source use: Section 11.2 motivates above-entropy achievability,
  assembled from C19 strict supported typicality and C20 selected-set coding
  and rounded integer budgets. The source uses nats, total deterministic
  decoders and one dependent code family; the complement probability is an
  error bound, not an asserted equality. Pure and biased sparse sources require
  no full-support premise. C21.01 is closed by its source-bound record. The
  [C21 notes](plans/post-release-chunk-21-notes.md)
  retain prior reference evidence and adaptations; this update claims no new
  textbook inspection, converse or entropy-threshold endpoint.
- Historical C21.02 source use (subsequently completed by its source-bound
  private record): the strong source converse combines C20 one-shot success
  counting with C19 strict supported typicality and atom/mass bounds. Pointwise
  rate estimates and positive-gap decay yield error tending to one under an
  eventual cap below entropy. No broader information-spectrum API or channel
  strong converse is asserted. Validation: Initial focused builds, static checks, all nine documentation examples and compiled compatibility/trust checks passed on their recorded inputs. The candidate is validation ready; final-source qualification and applicability require their actual evidence.
  Review: The original independent report is accepted and reconciled, with all three C21.02 criteria satisfied. Closure remains subject to the private completion record and its linked source-bound certificate. The C21 notes retain actual evidence/adaptations;
  fresh PW24 text inspection covered the relevant source-coding/AEP passages
  (printed 214--215 and 218, PDF 239--240 and 243). No Step 2 closure is claimed.
- Historical C21.03 source adaptation (subsequently completed by its source-bound
  private record): the general necessary-rate converse reuses
  the pointwise C20/C19 success estimate at arbitrarily large low-rate indices,
  with one fixed positive gap and an eventual positive success lower bound.
  Thus vanishing error excludes those indices without assuming bounded or
  convergent rates. The public endpoint is
  `eventually_entropy_sub_le_codeRate_of_tendsto_errorProbability_zero`.
  Consumer status: Compiled private fair-source families cover exact recovery with zero error and unbounded oscillating rates plus a persistent bounded branch, and intermittent low rates with one fixed positive gap, no eventual below-entropy cap and nonvanishing error derived through the public general converse. Validation: C21.03 producer and four-target consumer/aggregate builds, all nine documentation examples, static/scope checks and compiled compatibility/trust qualification passed on their recorded inputs. The candidate is validation ready; final-source qualification and applicability require their actual evidence.
  Review: The original independent C21.03 report is accepted and reconciled, with all three criteria satisfied. Closure remains subject to the actual private completion record and its linked source-bound certificate. Actual reference inspection, evidence and
  adaptations are recorded in C21 notes section 11. The full
  entropy-threshold endpoint remains C21.04; no Step 3 closure is claimed.
- Historical C21.04 source adaptation (subsequently completed by its
  source-bound private record): `sourceCoding_threshold` combines
  established achievability and the general converse as an `IsGLB` statement for
  the inline set of asymptotic upper rates of actual almost-lossless families.
  One budget/code family serves every positive tolerance at a chosen rate. The
  theorem asserts neither membership at entropy nor a universal exact-rate code
  there. Required operational consumers combine all four endpoints for the same
  finite source and nats, and include strict compression below support size and
  a valid finite-prefix modification. Consumer status: Compiled private consumers assemble all four endpoints for one source, prove biased sparse compression with support cardinality two and 0<H<R<log 2 using one actual family, and cover explicit pure/singleton codes plus a genuinely changed finite prefix with scalar limit and eventual-cap preservation.
  Validation: C21.04 producer and four-target consumer/aggregate builds, all nine documentation examples, static/scope checks and compiled compatibility/trust qualification passed on their recorded inputs. The candidate is validation ready; final-source qualification and applicability require their actual evidence. Review: The original independent C21.04 report is accepted and reconciled, with all four criteria satisfied. Closure remains subject to the actual private completion record and its linked source-bound certificate. Actual reference
  inspection and evidence belong in C21 notes section 12; no additional textbook
  inspection or Step 4 closure is inferred here.
- C21.05 adds no mathematical source claim or new textbook inspection.
  C21.01--C21.04 and their reviews are closed. The
  [maintained C21 handoff](handoffs/chunk-21.md) reconciles the delivered
  PW24/CT91 adaptations, total-decoder/natural-budget/nats conventions,
  strict supported typicality and same-family operational quantifiers.
  Initial authorized clean/API qualification and all-four API inspection have
  passed on recorded inputs. Final candidate qualification, readiness, cumulative acceptance and closure are established only by `.lit-review/setup/c21-05-completion-20261023.json` and its linked actual current-candidate validation/API applicability, genuine original independent report, complete seventeen-criterion matrix, substantive parent reconciliation and final-source qualification. This wording asserts no future PASS or closure.
  No new textbook reading or mathematical source claim follows from validation.
- Chapters 17 and 19: code/error conventions, operational capacity, and
  channel examples. The proposed release proves only an upper bound on
  operationally achievable rates, not the full noisy-channel coding theorem.
- Adaptations to settle explicitly: arbitrary message cardinalities instead
  of informal nonintegral bit lengths, nats versus bits, and total deterministic
  decoding versus a reserved detectable-erasure symbol. The draft also switches
  log/rate conventions in its discussion; do not copy them unexamined.

## SA13: Sason

Igal Sason, *Entropy Bounds for Discrete Random Variables via Maximal Coupling*,
IEEE Transactions on Information Theory 59(11), 7118--7131, 2013.
The local copy is arXiv `1209.5259v5`, dated July 23, 2013.

- Local file: `papers/1209.5259v5.pdf` (22 PDF pages).
- SHA-256: `90e7f4bf903ecc2583329b0bf33d58a580649d4d5f8490b0730158a8019ec6e6`.
- [Version-pinned paper](https://arxiv.org/abs/1209.5259v5).
- Sections I--II, Theorems 1--3: maximal coupling, disagreement equal to TV,
  and the finite entropy-difference bound using Fano. This is the proposed
  bounded intake, not a commitment to the whole paper.
- Recorded C11 use: Section I, Theorem 1 and equations (3)--(9), printed/PDF
  pages 2--3; Theorem 2 and equation (10), page 3. The finite construction uses
  the common diagonal mass and an independent residual matrix, with explicit
  zero/unit-TV endpoints. Section II's continuity result is the C14 source below.
- Recorded C14 planning use (2026-10-04): Definition 3/(2), page 1; Theorem
  2/(10) and the base-e convention, page 3; Section II, Theorem 3/(11), its
  proof and upper-distance-budget discussion, pages 3--4. The local hash was
  rechecked and both theorem/proof pages visually inspected. The
  [C14 plan](plans/post-release-chunk-14.md) records exact-TV versus
  capped-budget contracts, Nat-cardinality/singleton conventions, and derived
  conditional-entropy/MI bounds. Compiling feasibility probes are not production
  implementation or formal plan approval. No sharpness classification or
  Section III refinement is selected.
- Recorded C14.01 implementation use (2026-10-07): Section II, Theorem 3/(11)
  and its complete proof on pages 3--4. `Shannon.Continuity` uses one actual
  maximal joint PMF and its swap, exact identity-decoder errors, existing Fano
  and entropy identities. The public theorem extends the conventional
  cardinal-at-least-two expression to all finite PMFs by the library's Nat
  subtraction and total-log conventions, with explicit singleton/empty
  consumers. The threshold discussion explains why this step accepts exact TV
  only; the capped upper-budget theorem remains C14.02. The ternary example
  tests equality at `2/3` without asserting a general sharpness classification.
- Recorded C14.02 implementation use (2026-10-07): the upper-distance-budget
  discussion following Theorem 3 on pages 3--4 motivates the cap at `log m`.
  The public scalar modulus equals the raw expression through `1 - 1/m`,
  including equality, and saturates above it for every nonnegative real budget.
  Singleton and zero-cardinal scalar conventions are explicit; an empty law
  remains impossible. Pinned mathlib q-ary monotonicity supplies the interval
  argument, and the existing entropy range supplies the saturated law bound.
- Recorded C14.03 implementation use (2026-10-07): the two joint-law bounds
  are derived library consequences, not separately numbered SA13 theorems.
  Existing conditional-entropy/MI identities and both projection TV contractions
  combine the C14.02 entropy-budget result with separate joint/marginal alphabet
  sizes. No new attribution, optimality claim or null-fiber continuity is made.
- C14.04 qualification adds no mathematical source claim. The
  [maintained C14 handoff](handoffs/chunk-14.md) reconciles the exact/capped/derived
  distinction, implemented consumers, prior evidence and deferred refinements.
- Section II credits prior entropy-continuity results; cite the actual route
  used without claiming that every ingredient originated in this paper.
- Uses natural logarithms. Distinguish a bound at exact TV distance from a
  monotone bound given only an upper estimate on that distance. Treat the
  singleton alphabet separately from formulas containing `log (M - 1)`.
- Local-distance refinements, countable-alphabet extensions, and Poisson/Stein
  applications remain outside the proposed release scope.

## LP17: Levin and Peres

David A. Levin and Yuval Peres, *Markov Chains and Mixing Times*, second
edition, with contributions by Elizabeth L. Wilmer, 2017.

- Local file: `mcmt2e (Levin-Peres).pdf` (461 PDF pages).
- SHA-256: `9ef39f9467d9647ff3f5e8747b9ce24b7a90d13be2f8156fbd827b95b661a772`.
- [Author-hosted second edition](https://pages.uoregon.edu/dlevin/MARKOV/mcmt2e.pdf).
- Sections 4.1--4.2, especially Proposition 4.7: finite TV, coupling
  inequality, and attainment. These are the initial relevant sections.
- Recorded C10 use: Definition (4.1), Proposition 4.2, Remark 4.3 and
  Proposition 4.5 in Section 4.1, printed pages 47--49 / PDF pages 63--65,
  agree with the delivered half-L1, attained-event and sharp-test interfaces.
  Section 4.2's overlap identity is used without constructing a coupling;
  Proposition 4.7's coupling witness remains C11 work. C10 consistently uses
  the non-strict dominating event; tied atoms contribute zero.
- Recorded C12 use: Section 4.2 definition and Example 4.6, printed pages
  49--50 / PDF pages 65--66; Proposition 4.7, Remark 4.8 and equations
  (4.8)--(4.13), printed pages 50--52 / PDF pages 66--68. These establish
  the convention; the [C12 handoff](handoffs/chunk-12.md) distinguishes the
  delivered derived gluing and consumer proofs from numbered source theorems.
- Recorded C11 use: Section 4.2, Proposition 4.7, Remark 4.8 and equations
  (4.8)--(4.13), printed pages 50--52 / PDF pages 66--68, with the definition
  on printed page 49 / PDF page 65. The universal coupling inequality and an
  actual attaining law are delivered; no general gluing or process theorem is
  attributed to this section.
- Chapter 5 is optional background for later coupling applications, not a
  Markov-process or mixing-time commitment. The C12 finite gluing law
  is proved using conditional PMFs; no unverified numbered gluing theorem
  is attributed to this book.

## Other available background

The existing Billingsley, Durrett, Klenke, Csiszar--Korner, Yeung, and
El Gamal--Kim PDFs remain available. This update does not re-audit those
editions or promote all their chapters to selected sources. Add exact entries
when a chunk actually chooses a theorem or proof from them. Pinned mathlib is
an implementation dependency, whose reusable declarations must be checked
against the local checkout independently of textbook citations.

## Intake record

2026-09-11: filenames, page counts, hashes, and relevant sample mathematical
pages were checked; the newer sources were registered for post-release
planning. Selected AEP, tensorization, coding-model, Pinsker, TV, and coupling
sections informed the chunk map. Detailed chunks must still read and audit
their complete relevant proofs before freezing theorem statements. No reference
PDF was modified or added to Git.
