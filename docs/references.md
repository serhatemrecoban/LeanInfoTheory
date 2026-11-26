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

C39 cumulative qualification rechecked the registered 1991 Cover–Thomas PDF digest and read §2.3 (2.26)–(2.27), printed 18/PDF 40, and §12.1 Theorems 12.1.2–12.1.4, printed 281–282 and 285–286/PDF 303–304 and 307–308, as extracted text. The one-word formula (12.7), class identity (12.55)–(12.57) and bounds (12.54), (12.58) use empirical q, sampling p and natural logarithms here. The polynomial uses the ambient alphabet. The actual-support split handles observed zero-prior symbols separately. C38 supplies the cardinality bounds of (12.16). [Formal endpoints and fixtures](handoffs/chunk-39.md)

C39.04 uses CT91 §2.3 (2.26)–(2.27), printed p. 18/PDF p. 40, and
§12.1 Theorem 12.1.2, (12.7)–(12.14), printed p. 281/PDF p. 303.
Positive count at a zero-prior symbol makes every member word impossible.
The canonical KL support theorem gives infinity in the empirical-to-prior
orientation. The finite lower bound from (12.58) supplies the converse
in the private zero-event characterization. [C39 notes](plans/release-3-chunk-39-notes.md)

C39.03 uses CT91 §12.1 Theorem 12.1.4, (12.58), printed p. 286/PDF p. 308.
The factors from Theorem 12.1.3 cancel the entropy term from (12.57) after
conversion from base two to nats. The polynomial exponent counts the entire
alphabet. The finite formula assumes actual empirical-to-sampling support
inclusion. [Step notes](plans/release-3-chunk-39-notes.md)

C39.02 implements the whole-class identity from CT91 §12.1 Theorem 12.1.4 proof (12.55)–(12.57), printed 285–286/PDF 307–308, freshly hash-verified and text-read. Sum the supported word formula over the existing class and multiply by its cardinality exactly once. Empirical P/sampling Q become q/p, and bits become nats/Real.exp. Finite PMF atoms guard the real sum; generic ENNReal recovery separately checks finite masses and nonnegative right-hand sides. The sparse singleton event check reuses the existing prior/counts. The KL-only bounds of (12.58) remain C39.03. No fresh visual inspection is claimed. [Step notes](plans/release-3-chunk-39-notes.md#c3902--whole-class-probability-20-november-2026)

C39.01 implements the one-word formula of CT91 §12.1 Theorem12.1.2, (12.7)–(12.14), printed281/PDF303, freshly text-read for this step. Source empirical P/sampling Q become q/p; bits become nats and Real.exp. The actual support premise supplies canonical finite KL before its real expansion; zero-count terms are handled before logarithmic cancellation. The proof uses existing count indices and supported finite-product/KL APIs. The early sparse word fixture tests unused positive-prior and common-null symbols. Whole-class and KL-only bounds remain later C39 steps. [Implementation and limits](plans/release-3-chunk-39-notes.md#c3901--supported-prior-word-mass-19-november-2026)

C39 planning freshly hash-verifies CT91 and text-reads §12.1 Theorem12.1.2, (12.7)–(12.14), printed281/PDF303 (one-word mass), Theorem12.1.4, (12.54)–(12.58), printed285–286/PDF307–308 (class identity and bounds), and §2.3, (2.26)–(2.27), printed18/PDF40 (KL zero conventions). C38's Theorem12.1.3 remains the cardinality input. Source P/Q becomes empirical q/sampling p; powers of two become Real.exp in nats, with explicit support inclusion/finite KL and a separate canonical-infinite branch. Unused labels and positive empirical length remain explicit. The parent's intake was text-only; the revision-1 reviewer subsequently reported hash-verified visual/text inspection of PDF303,304,307,308,40, retained in its original report. Neither is implementation evidence. Revision 2's private zero-event iff KL-top caller is a consequence of the proposed positive lower bound, singular theorem and existing KL support characterization; no new textbook theorem or source adaptation is introduced. [Proposed C39 contracts](plans/release-3-chunk-39.md) · [Evidence and adaptations](plans/release-3-chunk-39-notes.md#permanent-fixture-calculations-and-source-adaptations)

C38.06 reconciles the implemented C38 contracts against CT91 §12.1, corollary
(12.15) and Theorem12.1.3, (12.16)–(12.39), printed281–284/PDF303–306.
The implementation parent and support freshly text-read these pages and matched
the registered PDF hash; no fresh visual or whole-book inspection is claimed.
Existing adaptations are bit entropy/powers of two to nats/Real.exp, an own-law
seed independent of the general-prior formula, and division-free natural
factorial weights for fixed-target count-vector probability maximality. The
unused labels/full ambient exponent and explicit all-length combinatorial
boundaries are preserved. The C38.06 seven-site definitional iid proof-body
correction addresses compiler ownership after an actual compatibility failure;
it changes no mathematical source adaptation, public contract, import or
acceptance policy. General-prior/KL work remains C39.
Cumulative validation/review/closure status and source identities belong to the
[C38 notes](plans/release-3-chunk-38-notes.md) and [C39 handoff](handoffs/chunk-38.md),
not to this source-selection entry.

C38.05's selected consumers are original numerical and interface specializations
of CT91 §12.1: own-law probabilities (12.15), exact multinomial count (12.17)
and both entropy estimates in Theorem 12.1.3/(12.16), printed pp. 281–282
(PDF 303–304). The biased fixed-law comparison exercises the distinction used
in (12.23)–(12.39), printed pp. 282–284 (PDF 304–306): count-vector probability
is maximized, not class cardinality. The sparse fixture keeps the full ambient
alphabet and evaluates an unsupported competitor under the fixed target law.
Empty-word/empty-alphabet boundaries and the finite ENNReal conversion caller
are explicit project/interface checks. Nats and `Real.exp` remain canonical.
The implementation parent freshly text-read and hash-verified the registered
CT91 file at PDF 303–306; no fresh visual inspection is claimed. The private
consumer candidate compiles; review and closure are governed by its step record. No C39
general-prior/KL statement or new public source adaptation is introduced.
[Consumers and limits](plans/release-3-chunk-38-notes.md#c3805--permanent-type-class-consumers-18-november-2026)

C38.04 implements the lower half of CT91 §12.1 Theorem 12.1.3, (12.16),
using the count-vector probability-mode argument (12.23)–(12.39), printed
pp. 282–284 (PDF 304–306). The implementation parent freshly text-read those
pages and matched the registered file hash. The approved division-free factorial
comparison replaces the source's ratio comparison; exact multinomial weights
sum to `n^n`. A private bridge uses only the fixed target's empirical iid law,
with explicit zero actual ENNReal events for target-zero symbols. The bound is
in nats using `Real.exp` and full ambient alphabet size. Natural zero-length
boundaries are project extensions; no zero-length empirical law is introduced.
General-prior probabilities and KL remain C39. Review and validation status is
tracked in the C38 notes; scoped closure is governed by its private completion
receipt.
[Evidence and limits](plans/release-3-chunk-38-notes.md#c3804--count-vector-mode-and-entropy-lower-bound-18-november-2026)

C38.03 implements the upper half of CT91 §12.1 Theorem 12.1.3, (12.16),
using the probability argument (12.18)–(12.22), printed p. 282 (PDF 304).
The exact page was reread and its registered hash matched. C38.02's own-law
event identity and total probability at most one give the bound, expressed in
nats with `Real.exp`. C38.04 supplies the lower-half candidate with separate
review and closure qualification. [Evidence](plans/release-3-chunk-38-notes.md)

C38.02 implements the own-law specialization in CT91 §12.1, corollary (12.15),
printed p. 281 (PDF 303), in nats using `Real.exp`. The exact page was reread
and the registered file hash matched. The iid product is grouped by C37 counts;
zero counts are handled before positive-mass logarithmic cancellation. Summing
the common word mass over the existing finset gives the class-event identity.
No general-prior divergence formula is needed; that remains C39. C38.03–04
supply both cardinality estimates, with candidate qualification recorded separately. [Evidence](plans/release-3-chunk-38-notes.md)

C38.01 implements CT91 §12.1 equation (12.17), printed p. 282 (PDF 304), as
`card_typeClass_eq_multinomial` for the existing count-indexed finset. The exact
page was reread during implementation. The proof uses pinned mathlib
orbit–stabilizer and function-stabilizer counting, including empty symbol fibers.
The zero-length/empty-alphabet conclusion is an explicit project extension.
C38.02 supplies the own-law probability seed and C38.03–04 both entropy bounds;
C39 retains general-prior/KL statements. Step validation and closure are recorded in
the [C38 notes](plans/release-3-chunk-38-notes.md).

C38 planning freshly matched CT91's registered file hash and read §12.1,
printed pp. 279–284 (PDF 301–306), with visual inspection of PDF 304–306.
The own-law corollary (12.15), printed p. 281, supplies C38's independent iid
seed. Theorem 12.1.3 and (12.16)–(12.17), printed p. 282, give the entropy
bounds and exact multinomial count; (12.23)–(12.39) on pp. 283–284 compare
class probabilities and derive the lower bound. The proposal uses nats,
division-free natural factorial comparisons and explicit zero-count handling.
Zero-length combinatorial boundaries are project extensions. General-prior
mass and KL results remain C39. This is source verification for a proposal,
not a completed formalization claim. [C38 plan](plans/release-3-chunk-38.md)

C37.07 reconciles the complete count/type interface against CT91 §12.1,
printed pp. 279–281 (PDF 301–303): relative frequencies, class definition
(12.2), and the number-of-types bound, Theorem 12.1.1 (12.6). The primary count
representation, realized classes, labeled inverse conversion and all-length
boundaries are detailed in the maintained handoff. The exact class-size and
entropy estimates remain C38 work; general iid type probabilities and KL bounds
remain C39 work. Those future estimates use nats and the same finite class.
[C37 source interpretation and next-chunk handoff](handoffs/chunk-37.md)

C37.06 supplies original finite examples of CT91 §12.1's empirical types and
class definition, printed p. 280 (PDF 302), and its number-of-types bound,
Theorem 12.1.1. The sparse and impossible-denominator examples distinguish a
prescribed denominator from a least denominator. The all-length count
partition includes empty words without normalizing their counts into a law.
These consumers do not evaluate general class sizes or iid type probabilities.
[Permanent consumers](../LeanInfoTheory/Examples/WordType.lean)

C37.05 connects the natural count representation to CT91 §12.1's types
with denominator `n`, defined on printed p. 280 (PDF 302). The equivalence
and witness uniqueness make that representation usable in both directions;
the denominator is prescribed, not necessarily least. Empirical equality
characterizes the existing class as in equation (12.2), on the same page.
[Conversion and membership contracts](plans/release-3-chunk-37.md#c3705--exact-denominator-and-round-trips)

C37.04 formalizes the unnumbered empirical-distribution definition in
CT91 §12.1, printed pp. 279–280 (PDF 301–302). The law assigns each label
its count divided by the positive word length. The actual-support theorem
states that a label occurs in the empirical support exactly when its count
is positive.
[Empirical-law contracts](plans/release-3-chunk-37.md#c3704--the-positive-length-empirical-pmf)

C37.03 formalizes CT91 §12.1, Theorem 12.1.1, equation (12.6), printed
pp. 280–281 (PDF 302–303). Each labeled count lies between zero and the
word length, giving a polynomial bound on the number of possible types.
The count formulation also covers length zero and the empty alphabet.
[Permutation and type-count contracts](plans/release-3-chunk-37.md#c3703--position-permutations-and-number-of-classes)

C37.02 represents the type class in CT91 §12.1, equation (12.2), printed
p. 280 (PDF 302), as the finite fiber of a word's count vector. Realizing
every vector of total `n` establishes that each indexed class has a member.
The all-length count formulation also includes the empty word.
[Realization and partition](plans/release-3-chunk-37.md#c3702--realization-and-partition)

C37.01 uses the symbol counts underlying CT91 §12.1's definition of a type,
printed pp. 279–280 (PDF 301–302). Counting positions gives a natural vector
with total equal to the word length. The project admits the zero vector for
the empty word. Normalization at positive length belongs to C37.04.
[Count and index contracts](plans/release-3-chunk-37.md#proposed-public-contracts)

C36.06 reconciles CT91 §5.3, Theorem 5.3.1 and §5.4, Theorem 5.4.1,
with PW24 §§10.1 and 10.3. The registered CT91 text identifies the
converse, rounded assignment and iid division on printed pp. 85–88
(PDF 107–110). PW24 printed pp. 197–198 and 206–209 (PDF 222–223 and
231–234) distinguish single-shot losslessness on support from unique
decoding for streams of unspecified length. Fresh inspection of the
displayed formulas confirms CT91 (5.33) has a strict upper bound and
PW24 (10.13) has a weak one. The Lean result obtains strictness by
positive-support rounding. Its singleton empty word assumes a known
symbol count. The numerical consumers compare specific encoders and do
not use a Huffman construction. [Source adaptation and consumers](handoffs/chunk-36.md#permanent-consumers-and-source-interpretation)

C36.04 follows CT91 §5.4, (5.35)–(5.37), printed p. 88 (PDF p. 110).
Treating an iid block as one source symbol gives a strict overhead of
less than one bit on its optimal expected length. Dividing both bounds
by the positive block length gives the per-symbol result. Lean uses the
finite-product entropy identity in nats and the explicit conversion to
bits. PW24 §10.3, Theorem 10.10, (10.13), printed p. 209, states the
scalar upper bound weakly. [C36.04 source and proof notes](plans/release-3-chunk-36-notes.md#c3604--per-symbol-bounds-for-iid-blocks)

C36.03 formalizes the minimum over Kraft-feasible integer lengths in
PW24 §10.3, (10.12), printed p. 209. C35 supplies both directions
between feasible lengths and prefix encoders on the original labels.
The finite search proves that an encoder attains the infimum, including
when its only word is empty. The scalar entropy bounds follow CT91
§5.4, Theorem 5.4.1, (5.33)–(5.34), printed p. 88. Its comparison with
the rounded assignment supplies the strict upper bound. PW24 (10.13)
states the upper inequality weakly.
[C36.03 proof and source notes](plans/release-3-chunk-36-notes.md#c3603--an-attained-scalar-optimum)

C36.02 follows CT91 §5.4, (5.29)–(5.32), printed pp. 87–88, for
the rounded lengths and the strict expected-length bound. PW24 §10.3,
Theorems 10.9–10.10, printed pp. 208–209, gives labeled Kraft realization
and the Shannon assignment. Its (10.13) states a weak upper bound for the
optimum. The Lean witness gets the strict inequality from natural ceiling
rounding at positive masses and converts canonical entropy to bits.
[C36.02 proof and source notes](plans/release-3-chunk-36-notes.md#c3602--a-prefix-code-with-shannon-lengths)

C36.01 specializes the universal converse of CT91 §5.3, Theorem 5.3.1,
to binary words on the positive support. PW24 §10.1 supplies the support
convention, and §10.3, Theorem 10.10, gives the optimal-length bound and
the normalized Kraft argument. Here the scalar inequality
`m log(w/m) ≤ w − m` applies directly to each positive mass `m` and Kraft
weight `w`. C35 bounds the sum of the weights, including codes with
unused Kraft budget. Division by `log 2` converts the entropy from nats
to bits. [C36.01 proof and source notes](plans/release-3-chunk-36-notes.md)

C35.04 reconciles the two finite Kraft directions in CT91 §5.2, Theorem
5.2.1, with the word-set necessity in CT91 §5.5 and the stream conventions
in PW24 §10.3. CT91 §5.1 (5.3) supplies the permanent three-label encoder.
PW24 §10.1 supplies the single-shot support convention used in the C36
handoff. A singleton of prescribed length zero extends the positive-length
realization convention to known-count coding. [Adaptations, public contracts and permanent callers](handoffs/chunk-35.md)

C35.02 uses the finite realization direction of CT91 §5.2, Theorem 5.2.1
(printed pp. 82–83, PDF 104–105), particularly the count of descendants
at a fixed depth in Figure 5.2 and (5.7). PW24 §10.3, Theorem 10.9(2)
(printed pp. 207–208, PDF 232–233), specifies a codeword of the assigned
length for each label. Its dyadic construction on p. 208 assumes positive
lengths. Adjacent allocated intervals can share an endpoint, so the
distance between successive starts can equal the earlier width. The Lean
proof counts fixed-length Boolean words and also covers depth zero. An
empty word then represents a singleton when the symbol count is known.
The registered hashes and these passages were rechecked for C35.02.
[Source adaptation and proof](plans/release-3-chunk-35-notes.md#c3502--realization-of-prescribed-lengths)

C35.01 uses CT91 §5.1 (printed pp. 79–81), §5.2, Theorem 5.2.1
(pp. 82–83), and §5.5, Theorem 5.5.1 (pp. 90–92), for labeled
encoders, prefix codes and Kraft–McMillan necessity. PW24 §10.1
(pp. 197–198) distinguishes single-shot coding on support, and §10.3,
Definitions 10.6–10.8 and Remark 10.3(3) (pp. 206–207), explains the
nonempty-word restriction on stream decoding. Theorem 10.9(1)
(pp. 207–208) supplies the stream inequality. C35.01 reindexes the
mathlib result over source labels and evaluates the known-count singleton
separately. [C35.01 proof and source adaptation](plans/release-3-chunk-35-notes.md)

C34.02–04 use CT91 §8.13, Theorem 8.13.1 and PW24 §19.7, Theorem 19.22
for the arbitrary-code converse at one channel use per iid source symbol.
On positive lengths the overhead vanishes and the error multiplies a fixed
source-alphabet logarithm. The collision and constant-channel calculations
are project regression examples. The two-owner consumer checks the shared
error in both strict regimes. [Contracts and page references](handoffs/chunk-34.md)

C34.01 specializes CT91 §8.13, Theorem 8.13.1, (8.142) and (8.148)–(8.157)
(printed pp. 216–218, PDF 238–240), using weak Fano from §2.11 (2.145)
and reverse-chain data processing from §2.8. PW24 §19.7, Theorem 19.22,
(19.36) on printed p. 393 (PDF 418), allows arbitrary code maps. The finite
Lean result sets the two lengths equal, uses iid entropy, arbitrary induced
input priors and nats, and includes the empty block.

C33's cumulative handoff collects the finite and asymptotic adaptations of
CT91 §8.13 and PW24 §19.7. The biased erasure example also uses CT91
§2.1 (binary entropy) and §8.1.5 (channel capacity), with the nats conversion.
PW24 Theorem 19.22 and the maximal-error construction begin on printed p. 392.
The direct estimate continues on p. 393. The handoff identifies C34's
additional data-processing obligation. [C33 source and theorem matrix](handoffs/chunk-33.md)

C33.04 uses the direct part of CT91 §8.13, Theorem 8.13.1, printed
pp. 216–217 (PDF 238–239), especially (8.142)–(8.147). In PW24 §19.7 the
statement of Theorem 19.22 and the maximal-message-error construction begin
on printed p. 392 (PDF 417), and the achievability estimate continues on
p. 393 (PDF 418). For the component results see PW24 Corollary 11.3 and
Theorem 19.9. The Lean proof uses nats and chooses one total pair of families
at equal blocklengths. [Direct theorem and adaptations](plans/release-3-chunk-33-notes.md)

C33.02 matched the registered CT91 and PW24 hashes and read CT91 §8.13,
printed pp. 216–217 (PDF 238–239), and PW24 §19.7, printed pp. 392–393
(PDF 417–418). CT91 (8.142) weights the output by the encoded source word's
channel row. PW24 splits a failure of the composition into source and
message errors and uses a per-message bound. The finite Lean theorem keeps
the second term at the actual compressor-output prior. C32's retained
embedding and total fallback support the subsequent rowwise and maximum
bounds. [C33 step notes](plans/release-3-chunk-33-notes.md)

C33.01 matched the registered hashes of CT91 and PW24 and checked the
following passages as text on 14 November 2026. CT91 §8.13, printed p. 216
(PDF 238), equation (8.142) and Figure 8.12, weights each source word by
its own probability and each output by the channel row at the encoded word.
The decoder is judged against the original word. PW24 §19.7, printed p. 391
(PDF 416), defines deterministic word maps and block error for possibly
unequal source-word probabilities. Its converse argument on printed p. 393
(PDF 418) gives the source, input, output and reconstruction in that order.
C33.01 uses equal word lengths and an iid PMF. Pushing the source/output
joint forward by `(s,y) ↦ (E s,y)` gives the input/output joint under the
induced prior, also when several words share an encoding. This exact PMF
identity is a project derivation. [C33.01 notes](plans/release-3-chunk-33-notes.md)

C32.06 freshly matches both registered hashes and checks only relevant text:
CT91 §8.5 (8.28)–(8.34), printed 193–194/PDF 215–216, and §8.7 Theorem
8.7.1 proof step 3 (8.81), printed 202/PDF 224; PW24 §17.1 Definitions
17.1–17.2, printed 342–343/PDF 367–368, §19.1 Definition 19.2 and
Theorem 19.4, printed 373–375/PDF 398–400, and §19.7 Theorem 19.22,
printed 391–393/PDF 416–418. Sent-label/maximum/uniform error, fixed-fraction
extraction and nonuniform compressor output motivate the delivered interface.
Exact natural budgets, threshold ties, total fallback/inverse, transported
priors, one family before varying priors and nats are recorded project
contracts. C32.01's CT91 PDF 215–216 visual and planning's PDF 224 visual
retain their original attribution; no fresh C32.06 or PW24 visual is claimed.
[Maintained C33 handoff](handoffs/chunk-32.md)

C32.05 freshly matches both registered PDF hashes. Read-only reference
support checks CT91 §8.5, printed 193–194 / PDF 215–216, and §8.7 proof
step 3, printed 202 / PDF 224, plus PW24 §19.7, Theorem 19.22,
printed 391–393 / PDF 416–418, as targeted text. Maximal error accommodates
unequal source-encoder output masses. The collision/odd/zero/singleton/empty-word
fixtures are project calculations. Selecting one exact-budget family before
every varying prior sequence and squeezing by the full retained maxima are
project consequences; composition and its joint reconstruction inequality
remain C33. This is a fresh hash/text check with no fresh visual audit.
[C32 source basis](plans/release-3-chunk-32.md#incoming-evidence-and-mathematical-sources)

C32.04 freshly matches both registered PDF hashes and reads the targeted
CT91 §8.7, Theorem 8.7.1 proof step 3, printed 202 / PDF 224, (8.81), and
PW24 §19.1, Theorem 19.4 proof, printed 374–375 / PDF 399–400. CT91 selects
and reindexes a reliable half at a cost of one bit per block. The library's
natural logarithms give `log 2` nats per block, hence `log 2/n` per use at
positive n. The exact integer budget comparison and scalar logarithm proof
make this conversion explicit. PW24 supplies the fixed-fraction extraction.
Choosing one full retained family from the supplied C31 witness, squeezing
its maximal errors and transferring all tolerance tails are project
formalization consequences. This is a fresh text/hash check, not a new
rendered-page audit; the earlier planning visual remains separately attributed.
[C32 source basis](plans/release-3-chunk-32.md#incoming-evidence-and-mathematical-sources)

C32.03 freshly matches both registered PDF hashes. Targeted read-only text
inspection covers CT91 §8.7, Theorem 8.7.1 proof step 3, printed 202 / PDF 224,
(8.81), and PW24 §19.1, Theorem 19.4 proof, printed 374–375 / PDF 399–400.
The passages select a reliable half and count errors strictly above a
threshold. At threshold twice the uniform mean, integer cardinality yields
`(M+1)/2`. The project explicitly separates zero mean (every row is zero),
retains threshold ties, enumerates the whole good set, and restricts to any
fitting positive budget with the code chosen before all priors. The exact
range, total fallback and same-code/all-prior contract are project adaptations.
This check adds no fresh visual audit.
[C32 source basis](plans/release-3-chunk-32.md#incoming-evidence-and-mathematical-sources)

C32.02 freshly matches both registered PDF hashes through read-only reference
support. Targeted text checks cover CT91 §8.7, Theorem 8.7.1 proof steps 2–3,
printed 202 / PDF 224, especially (8.81), and PW24 §19.1, Definition 19.2
and Theorem 19.4, printed 373–375 / PDF 398–400. CT91 explicitly reindexes
after removing the worst half; PW24 extracts a smaller maximal-error code
and permits an erasure. Neither passage specifies redirection of discarded
old decoder labels. The project defines a total inverse on the retained
embedding's image with an explicit retained fallback. Preserving every
old correct decision proves the row-error bound under its identical channel
row. Comparing the new code under π with the old code under `π.map i`
is a finite weighted-sum consequence. This pass adds no fresh visual audit.
[C32 source basis](plans/release-3-chunk-32.md#incoming-evidence-and-mathematical-sources)

C32.01 freshly matches both registered PDF hashes. Read-only reference support
checks CT91 §8.5, printed 193–194 / PDF 215–216, as text and complete rendered
pages. Equations (8.28)–(8.33) give a total deterministic decoder, the sent-index
row error, its maximum and uniform mean. PW24 §17.1, printed 342–343 /
PDF 367–368, is freshly checked as text. Its uniform experiment permits
randomized maps and erasure. The project instead uses the released total
message-valued deterministic decoder. C32.01 extends the prior to any PMF
on the original labels, defining actual joint-law decoding error and deriving
the finite weighted sum. Direct row evaluation gives an error even at a
zero-prior label. This all-priors extension and its pure/uniform identities
are project consequences. [C32 source basis](plans/release-3-chunk-32.md#incoming-evidence-and-mathematical-sources)

C31.05 freshly matches both registered hashes and checks the cumulative selected
passages as text, with no new visual audit. PW24 §19.1, Definitions 19.2–19.3,
printed 373 / PDF 398, uses erasure and tolerance-indexed existence; §§18.1–18.2,
printed 353–355 / PDF 378–380, supply the threshold conventions; §19.2,
Theorems 19.7–19.9, printed 375–377 / PDF 400–402, supplies the direct/converse
comparison. CT91 §8.5, printed 193–194 / PDF 215–216, distinguishes average and
maximal error. Theorem 8.7.1 is stated on printed 198 / PDF 220; its proof spans
199–202 / PDF 221–224, with deterministic average-error selection on printed 202.
Section 8.9, printed 204–207 / PDF 226–229, supplies the uniform-message Fano
comparison. C31 uses a total decoder, nats, ceiling budgets, the literal strict
threshold complement and one family before every tolerance. C23 handles the
same arbitrary-budget witness without a rate limit. BEC/constant locators and
the registered PW24 erasure-weight qualification remain those below. The new
retained-budget rate-tail calculation is a project consequence of the public
predicate; expurgation, actual restriction and all-priors error remain C32.

C31.04 freshly matches the registered CT91/PW24 hashes through read-only reference
support. CT91 §8.1.5, (8.13)–(8.16), printed 187–188 / PDF 209–210, gives the BEC
capacity formula. The half-erasure consumer uses log 2 / 2 nats per use and the
strictly smaller positive rate log 2 / 4. PW24 §19.3, printed 380 / PDF 405,
corroborates the capacity value; the previously recorded erasure-weight
qualification remains applicable. CT91 (8.1), printed 184 / PDF 206, and the
independence criterion (2.91), printed 27 / PDF 49, justify zero capacity for
every fixed output row. The exact achievable set {0}, singleton witness and
operational least-upper-bound specializations use C31's public declarations.
These fresh checks were textual, with no new visual inspection.


C31.03 uses PW24 §19.2, Theorem 19.7, printed 375–376 / PDF 400–401,
and Theorem 19.9, (19.8), printed 377 / PDF 402. CT91 §8.9, printed 204–207 /
PDF 226–229, especially (8.106)–(8.112) on printed 206, gives the uniform-message
Fano converse at fixed nominal bits/use. Read-only reference support freshly
matched both registered hashes and checked those passages as text. The project
uses C23's eventual positive-tolerance cap on the identical operational witness,
with no rate-limit premise. Leastness follows from the zero-rate witness and a
strictly subcapacity midpoint for any alleged smaller upper bound. General
membership of capacity in the achievable set is unnecessary.


C31.02 freshly checks PW24 §19.2, Theorem 19.8 and (19.7), printed 376 /
PDF 401. It fixes one input law and one positive gap, then combines an iid
information-density miss with an exponential competing term. The Lean proof
uses C28's actual complementary strict-threshold event, including ties, and
the natural ceiling estimate M-1 < exp(nR) at threshold n*s. One selected code
family precedes every operational tolerance. CT91 §8.7, Theorem 8.7.1 proof
steps 1–2, printed 202 / PDF 224, selects a deterministic book with small
average error. Its subsequent expurgation is C32. The read-only source support
matched both registered PDF hashes and extracted these passages as text.


C31.01 uses PW24 §19.1, Definitions 19.2–19.3, printed 373 / PDF 398, for
the average-error operational viewpoint. PW24 permits an erasure and places
tolerances before code selection in its displayed supremum. The
[approved C31 source basis](plans/release-3-chunk-31.md#source-basis-and-imports)
fixes one positive-budget deterministic family before all rate tolerances,
using the released total message-valued decoder and nats. CT91 §8.5, printed
193–194 / PDF 215–216, distinguishes uniform average and maximal error and
defines achievability with maximal error. Its §8.7 proof selects a deterministic
book with small average error before expurgation. C31.01's read-only source
support and independent reviewer freshly matched the registered PDF hashes and
checked the relevant operational definitions as text. The reviewer also checked
the selected-book passage on PDF 224. These checks add no visual formula audit.

- C23.06 cumulative pointer: the [handoff](handoffs/chunk-23.md) and notes Section 23 bind actual approved initial clean/API/all-36 inspection records. Earlier source readings retain their actors, pages, hashes and limits; this documentation update claims no fresh PDF inspection. Every bounded amendment requires the entire clean rerun and renewed API applicability before R. All 21 fresh cumulative judgments and final reconciliation/closure depend only on the genuine original records linked by actual `.lit-review/setup/c23-06-completion-20261025.json`.

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
- C30.06 read-only reference support freshly matches this registered hash and
  reads as text §8.5 (8.28)–(8.32), printed 193–194/PDF 215–216, and §8.7 proof
  of Theorem 8.7.1, printed 199–202/PDF 221–224. Uniform-message error, book
  averaging and selection precede half-code expurgation for maximal error.
  C30 selects within actual support without discarding labels and retains n/M.
  Its sparse/numerical fixtures are project calculations. This is not a fresh
  visual formula or whole-book audit. [C30 handoff](handoffs/chunk-30.md)
- C29.05 freshly rechecks this registered hash and reads as text §8.5
  (8.28)–(8.32), printed 193–194 / PDF 215–216, and §8.7 proof of
  Theorem 8.7.1, printed 199–201 / PDF 221–223. The
  [C29 handoff](handoffs/chunk-29.md) preserves uniform-message error for a
  realized code and averaging over random books, with arbitrary word priors.
  Text extraction still omits parts of the scanned double-average displays;
  no new visual or whole-book inspection is claimed.
- C29.04 freshly matches this hash and reads as text §8.5 (8.28)–(8.32),
  printed 193–194 / PDF 215–216, and §8.7 proof of Theorem 8.7.1,
  printed 199–201 / PDF 221–223. These passages distinguish the uniform-message
  error of a realized code from averaging over sampled books. The scanned text
  omits parts of the double-average formula bodies; this is a text-only reading,
  not a fresh visual formula audit. The arbitrary-word-law released-error
  identity uses finite sums and explicitly averages all indices.
- C28.05's reference helper freshly rechecked this hash and read as text only
  Section 8.6 proof of Theorem 8.6.1(1)/(8.42)–(8.47), printed 195–196 / PDF 217–218.
  Its marginal/joint failure union argument supports three C19 AEP limits
  without input/output independence. Earlier Section 3.1, printed 51 / PDF 73, and
  Section 8.1.1, printed 184–185 / PDF 206–207, readings keep their actors/dates.
  The [C28 handoff](handoffs/chunk-28.md) records varying-word-space probabilities,
  nats, support and exact project null/tie fixtures. No fresh visual or whole-book
  claim is made.
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
- C23.01 adaptation: Section 8.5, printed 192–194 / PDF 214–216, supplies
  deterministic indexed codes and uniform-message average error. These pages
  were inspected during C23 planning at the registered hash; this entry claims
  no fresh PDF access. The actual encoder pushforward may be nonuniform or
  correlated, and colliding messages retain their distinct identities. Total
  decoders use every message index with no reserved erasure value. The source
  explicitly treats singleton messages and zero-length error `1-1/M`, while
  capacity/converse results remain outside C23.01. That step is now closed by its
  actual private completion chain; see the [C23 notes](plans/post-release-chunk-23-notes.md).
- C23.02 adaptation: Section 8.9, printed 204–207 / PDF 226–229, was freshly
  read through UTF-8 text extraction by the parent's read-only source support;
  the registered CT91 hash matched. No fresh visual check is claimed. Its Fano,
  actual-law data processing and arbitrary-input repeated-channel capacity route
  gives the undivided finite converse, with the bits constant 1 replaced by
  `log 2` in nats and arbitrary positive natural message budgets. The source
  includes zero length, singleton messages and complete error; positive length
  and a positive lower rate enter only when dividing. C23.02 producer/consumer
  and aggregate builds, focused/umbrella signatures, static/generated checks and
  all nine documentation examples and full maintained trust passed. The accepted
  independent review assessed all four criteria as satisfied with no findings;
  parent substantive reconciliation is complete. C23.02 is now closed by its
  actual supported private completion record. See
  [C23 notes](plans/post-release-chunk-23-notes.md).
- C23.03 adaptation: Section 8.9, printed 204–207 / PDF 226–229, was freshly
  read as UTF-8 text at the registered hash by read-only parent support. The
  complete PDF 228 page was also rendered and visually inspected in memory;
  no render or extraction artifact was saved. Its fixed-rate limiting argument
  motivates an additional derivation for arbitrary varying natural budgets:
  finite Fano and vanishing error first give an eventual uniform rate bound,
  then control error times that bound. The real limsup endpoint explicitly
  supplies derived upper boundedness and lower control from rate nonnegativity.
  Focused/aggregate builds, focused/umbrella signature and rate/unit ownership
  checks, static validation and all nine documentation examples passed. Full
  maintained trust passed, and the accepted original independent report assessed
  all four criteria as satisfied with no findings. Parent substantive
  reconciliation is complete. The reviewer separately verified the hash, reused
  its earlier weak-converse reading and visually checked PDF 228. C23.03 is
  now closed by its actual supported completion record. See
  [C23 notes](plans/post-release-chunk-23-notes.md).
- Historical C23.05 integration/qualification snapshot, subsequently closed: read-only support freshly matched the registered
  hash and read complete §8.1 PDF 206–210 (printed 184–188) and §8.9 PDF 228
  (printed 206) as UTF-8 text. Complete PDF 207, 209, 210 and 228 pages were also
  visually inspected in memory, including preferred Poppler reinspection. The
  standard capacity examples and finite Fano converse retain canonical nats,
  actual uniform-message sampling and explicit division guards. Private codes
  consume the existing bound/capacities; no production theorem or operational-
  capacity equality is added. Finite/composition/aggregate builds, all 36 focused/
  full compiled contracts, generation/static checks and all nine documentation
  examples and full maintained trust passed. The accepted original independent
  report satisfied all three criteria without findings and is substantively
  reconciled. The reviewer separately hash-verified/text-read nine book pages and
  visually inspected complete CT91 PDF 207, 209, 210 and 228 pages. Its inspection
  remains distinct from the parent support above. Fresh final static/applicability
  checks, capture and supported closure remain required. No extracts or renders
  were saved.
- Historical C23.04 adaptation snapshot, subsequently closed by its actual record: Section 8.9, printed 204–207 / PDF 226–229, was freshly
  read as UTF-8 text at the verified registered hash by read-only parent support.
  Complete PDF 228/229 pages were visually inspected in memory; no renders or
  extracts were saved. Equation 8.112's bits constant becomes `log 2` in nats.
  An eventual rate lower bound above capacity yields the quantitative eventual
  error bound and explicit half-gap floor, with positivity of the lower rate
  derived from nonnegative capacity. The frequent fixed-gap obstruction is a
  project consequence of the public tolerance theorem, not an explicit statement
  on these pages. Fixed-rate concatenation and strong-converse context do not
  imply an eventual floor for the intermittent family. Initial checks and full
  maintained trust passed. The accepted original independent report satisfied
  all three criteria with no findings; core and substantive parent reconciliation
  is complete. The reviewer separately hash-verified/extracted the relevant
  references and freshly visually inspected PDF 228–229. Fresh final static/
  applicability checks and supported closure remain required.
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
- C30.06 read-only reference support freshly matches this hash and reads as
  text §18.1 Corollary 18.4, §18.2 Theorem 18.5/proof and §18.3 first-match precedent,
  printed 353–356/PDF 378–381. Whole-word draws are independent across labels;
  union subadditivity needs no mutual independence of rival passes sharing the
  output. The source's weak-test unique-match/erasure display differs from C27's
  strict global mass test and C29's total first-pass decoder with zero fallback.
  Actual finite support, arbitrary correlated word q and exact n/M/released
  error are C30 contracts. Positive-mass ties and numerical fixtures are project
  calculations. The fresh bounded check is text-only, with no new visual audit.
- C30.03 freshly matches this hash and reads as text §18.1 Corollary 18.4
  and §18.2 Theorem 18.5, printed 353–355 / PDF 378–380. The strict pass has
  a closed joint miss and an exponential independent-law bound. The source's
  weak-test unique-match/erasure construction is distinct from this library's
  strict-event first-pass decoder with fallback. Arbitrary correlated word
  laws, actual finite sampling support, and the fixed-book identity with the
  released code error at exact n/M are project contracts. The global strict
  mass test, including ties and negative thresholds, remains C27's event;
  C28's literal miss is reused only in a finite C31-style consumer. This fresh
  text check does not claim a new visual formula audit.
- C30.02 freshly matches this hash and reads the final selection paragraph
  of §18.2, Theorem 18.5's proof, printed 355 / PDF380, as text. The source
  obtains a realization from the expected-error bound. Actual finite PMF
  support membership and error no greater than the weighted mean are explicit
  project witness requirements. Finite support minimization, arbitrary raw
  output rows and the repeated-bit regression are project adaptations.
- C30.01 freshly matches the registered hash and reads §18.2, Theorem 18.5
  and its proof, printed 354–355 / PDF 379–380, as text. Whole-word draws are
  independent across message labels. The per-rival union estimate depends
  only on each pair law under the common output. For C29's total first-pass
  decoder, unique sent pass implies success and gives error-event containment.
  C30.01 averages every sent label explicitly. Its arbitrary event avoids
  selecting a weak/strict threshold convention at this step. The globally
  strict C27 specialization is later C30 work. This is a text-only source
  check and supplies no new visual formula audit.
- C29.05 freshly rechecks this hash and reads as text §18.2, proof of
  Theorem 18.5, printed 354–355 / PDF 379–380, and §18.3, proof of
  Theorem 18.6, printed 356 / PDF 381. The maintained C29 handoff states the
  whole-codeword sampling and same-experiment sent/competing projections,
  least-index precedent and adaptations to a supplied strict event and valid
  fallback. The cumulative reference check supplies source context, not C30's
  union bound/extraction or C31's achievability.
- C29.04's reference helper freshly matches this hash and reads as text §18.2,
  proof of Theorem 18.5, printed 355 / PDF 380. It distinguishes fixed-book error and its
  expectation. C29 explicitly averages all message indices because ordered
  decoding and the valid zero fallback can give unequal fixed-index errors.
  The arbitrary word law, released-error equality and local numerical checks
  are project adaptations; no union bound or good-book extraction is proved
  in this step. The fresh check is text-only, not a visual formula audit.
- C29.03 freshly checks PW24 §18.3, proof of Theorem 18.6, printed 356 /
  PDF 381, as text for its least-passing-message precedent. The registered
  local hash is unchanged. The project constructor takes an arbitrary set,
  retains the original n/M and uses index zero when none passes; C27's strict
  mass comparison in the focused caller differs from the source weak test.
  The finite minimum proof, total valid-index fallback and duplicate/no-match/
  singleton consumers are project adaptations. No erasure symbol is added.
- C29.02 uses PW24 §18.2, proof of Theorem 18.5, printed 354–355 / PDF 379–380,
  especially step (a), for the competing-word/output ensemble law. The formal
  proof retains the competing and sent words as separate coordinates and
  passes only the sent word through the channel. Raw PMF pushforwards supply
  the arbitrary-output event transport. The fixed-book and biased-output
  checks are project fixtures.
- C29.01's reference helper freshly matched the registered PW24 hash and read
  §18.2, proof of Theorem 18.5, printed 354–355 / PDF 379–380, as text.
  Independent draws are across codeword labels. Specializing the input alphabet
  to whole words permits arbitrary dependence within each word. The sent-pair
  law averages over books at a fixed message index. The raw-PMF projection and
  arbitrary-output event caller are project adaptations.
- C28.05's reference helper freshly rechecked the registered hash and read as
  text only Section 18.2/(18.9)–(18.10), printed 354 / PDF 379, and Section 19.2 proof of
  Theorem 19.8/(19.7), printed 376 / PDF 401. The closed lower-tail miss agrees with
  C27's literal complement. Source weak decoder acceptance differs from the
  project's strict mass comparison; equality remains a miss. Earlier Section 18.1,
  printed 351 / PDF 376, density/mean readings retain their actors. The closed
  successor-length limit, all-natural n*s miss, real null convention and biased
  finite tie fixture are project adaptations in the [C28 handoff](handoffs/chunk-28.md).
  Fresh observations are text-only. Validation, review and closure stay separate.
- C27.06 cumulative preparation rechecked the registered PW24 hash and text
  in §18.1, Definition 18.1/(18.2), Proposition 18.2 and Corollary 18.4/(18.6),
  printed 351–353 / PDF 376–378, and §18.2/(18.9)–(18.10) plus the following
  proof, printed 354–355 / PDF 379–380. The [C27 handoff](handoffs/chunk-27.md)
  records signed nats, the supported log ratio, globally strict mass event,
  independent-law tail and closed joint miss. PW24's extended negative
  infinity at J-zero/Q-positive atoms is handled by the mass comparison;
  real totalization remains zero outside joint support. Equality belongs to
  the miss. CT91 §2.3/(2.28)–(2.30), printed 18–19 / PDF 40–41, was also
  rechecked as text for the existing finite-sum mean, with the project's nats
  convention. The reference helper's observations keep their actor and hashes;
  earlier visual checks keep their own dates and no fresh visual-page claim
  is made. Cumulative validation, original review and actual closure follow
  the private completion pointer in the [step notes](plans/release-3-chunk-27-notes.md).
- C26.06 cumulative preparation rechecked this hash and re-read Theorem14.11,
  printed284/PDF309, as text. The [maintained handoff](handoffs/chunk-26.md)
  reconciles the delivered threshold and exact-level contracts, both permanent
  consumers, zero/singular/common-null conventions and existence-only claim.
  Earlier section readings retain their original actors and limits; no fresh
  visual inspection is asserted. Cumulative validation/review and actual
  closure follow the private C26.06 completion pointer described there.
- C26.05 freshly verified the registered hash and read Theorem 14.11, printed
  284 / PDF 309, as text. Its private permanent consumers use the public
  supplied-threshold and prescribed-level theorems: the C25 Boolean fixture
  now has certified quarter-level optimal power, and disjoint point masses
  exercise zero-size singular rejection and a common-null tie. The
  [notes](plans/release-3-chunk-26-notes.md#c2605--two-permanent-threshold-consumers)
  preserve coordinate orientation, exact values and source-bound validation
  and review references. No uniqueness or fresh visual claim is made.
- C26.04 freshly checked the same registered hash and extracted Theorem 14.11,
  printed 284 / PDF 309, as text. The public existence proof calibrates one
  common boundary weight with positive null boundary mass, uses the private
  size identity, and applies the supplied-threshold comparison. The
  [notes](plans/release-3-chunk-26-notes.md#c2604--exact-level-and-finite-neymanpearson)
  record closed-interval attainment, singular/null conventions and private
  endpoint/type-II and four-atom checks. Both complete criteria received
  satisfactory independent assessments, preserved in the source-bound private
  records. No uniqueness or fresh visual claim.
- C26.03 freshly checked the registered hash and extracted Theorem 14.11,
  printed 284 / PDF 309, as text. Its private size equation and finite-level
  crossing adapt the threshold-attainment context using null-mass sums on
  positive null support, without a uniqueness claim. The
  [notes](plans/release-3-chunk-26-notes.md#c2603--threshold-size-and-finite-crossing)
  record the guarded division, zero-size null contributions and closed-interval
  finite-extrema argument. The implementation reuses PMF.supportFinset and
  its normalization-based nonemptiness fact with a private real-positivity
  bridge. Public calibration remains C26.04.
- C26.02 uses the finite signed-sum sufficiency argument for a supplied
  threshold test, following §14.4, Theorem 14.11, printed 284 / PDF 309.
  The [notes](plans/release-3-chunk-26-notes.md#c2602--supplied-threshold-power-comparison)
  record its division-free adaptation, zero-threshold/null-atom cases and
  distinction from the later prescribed-level existence theorem.
- C26.01 uses the finite mass-threshold convention in the
  [approved plan](plans/release-3-chunk-26.md) and
  [implementation notes](plans/release-3-chunk-26-notes.md).
  Sections 14.1–14.2 provide decision and extended-log conventions,
  printed 276–282 / PDF 301–307. The randomized attainment statement is
  §14.4, Theorem 14.11/(14.11), printed 284 / PDF 309. On jointly positive
  atoms the rejection rule uses c = exp(−τ), γ = 1 − λ. Common-null
  decisions can differ pointwise with zero contribution under both laws.
  C26.01 supplies construction and its application equation.
- C25.06 cumulative pointer: the [handoff](handoffs/chunk-25.md) records
  the delivered finite scalar API, complement-event proof, all-randomized
  attained minima and equal-prior normalization. Earlier text inspections of
  Section 7.3, Theorem 7.7(a)/(7.17)–(7.19), and Section 14.1/Table 14.1/(14.1)
  retain their actors, registered hash and page limits. Preparing this handoff
  claims no fresh PDF inspection or visual verification. C26 owns prescribed-
  level optimality; C27 owns the supported information-density/global-event
  bridge. Neither is delivered by C25. Cumulative qualification, original review
  and substantive reconciliation follow the source-bound records identified in
  the [step notes](plans/release-3-chunk-25-notes.md); the maintained completion
  pointer records an actual supported closure only once established. This source
  pointer predicts no review verdict or completion.
- C25.05 consumers: private equal, disjoint and overlapping finite laws
  exercise the Section 7.3 error-sum optimum and Section 14.1 prior weighting
  through the existing testing API. A symbolic rejection weight on one Boolean
  atom evaluates size and power, then specializes to the strict optimizer and
  a test meeting a smaller size cap. These numerical fixtures are local API
  regressions, not claimed textbook examples or a prescribed-level optimality
  theorem. The sparse construction follows the existing C10 TV consumer.
  Fresh targeted parent text extraction rechecked PDF 147–148 and 301–302 at
  the registered hash; no fresh visual-page check is claimed.
- C25.04 adaptation: Theorem 7.7(a)/(7.19), Section 7.3, printed
  122–123 / PDF 147–148, gives the attained error-sum minimum. The finite
  strict test rejects where the alternative atom mass exceeds the null
  mass; ties accept the null. The proof complements the released weak-
  dominance TV event and reuses C25.02 event identities. Section 14.1,
  Table 14.1/(14.1), printed 276–277 / PDF 301–302, supplies prior-weighted
  error; equal priors give half the conditional-error sum and half its
  attained minimum. These are finite scalar statements, without a formal
  bridge to mathlib decision kernels. Fresh targeted parent and read-only
  support text inspection used the registered hash; no fresh visual check
  is claimed.
- C25.03 adaptation: the lower-bound direction of Theorem 7.7(a),
  (7.17)–(7.19), Section 7.3, printed 122–123 / PDF 147–148, becomes
  the bound on `PMF.BinaryTest.errorSum` for every randomized test.
  The finite scalar proof specializes the released interval-width TV
  inequality to `[0,1]`; this sum has no prior weighting. Attainment and
  equal-prior normalization are supplied by C25.04 above. Fresh targeted parent text
  inspection used the registered hash; no fresh visual check is claimed.
- C25.02 adaptation: the deterministic decision-region indicator in Section
  14.1, printed 276 / PDF 301, becomes `PMF.BinaryTest.ofEvent`. Rejection
  uses the event mass and type-II error the complementary mass. A fresh
  targeted text inspection agrees with this orientation; no fresh visual
  PDF check is claimed. The proof reuses finite real event masses and
  mathlib's indicator-complement identity.
- C25.01 adaptation: Section 14.1, printed 276–277 / PDF 301–302,
  supplies the conditional rejection probability. Size is null rejection,
  power is alternative rejection, and type-II error is one minus power.
  The book's null-acceptance parameter is one minus size. Fresh text inspection
  was performed by read-only source support; no fresh visual check is claimed.
  The finite scalar interface needs no measurable-kernel risk import. See
  the [C25 implementation notes](plans/release-3-chunk-25-notes.md).
- C23.01 adaptation: Section 17.1, Definition 17.1/(17.1), printed 342–343 /
  PDF 367–368, supplies the message/input/output/decoded-message sampling model.
  The planning inspection at the registered hash is retained in the
  [C23 notes](plans/post-release-chunk-23-notes.md); no new PDF read is claimed.
  The selected interface uses total deterministic encoding/decoding, uniform
  positive message budgets and average error through the existing Fano API.
  Actual PMF marginals keep message identity under encoder collisions, with no
  iid input or image-uniformity premise. C23.01 constructs these laws and
  boundary identities and is closed by its actual private completion chain;
  the finite capacity converse is separately selected in C23.02.
- C23.02 adaptation: Section 17.4, Theorem 17.3, printed 348–349 /
  PDF 373–374, was freshly read as UTF-8 text by the parent's read-only source
  support at the verified registered hash. No fresh visual check is claimed.
  The divided textbook presentation is replaced by the existing undivided Fano
  lower bound, so `Pe=1` needs no division by `1-Pe`; binary entropy is bounded
  by `log 2` in nats. The extracted alternative proof defines its indicator with
  disagreement but then uses success probabilities. C23 consistently reuses the
  existing decoding-error semantics and actual message law. The normalized
  result needs `n>0`; the pointwise error result additionally needs `R>0` and
  `R≤codeRate n M`, without an above-capacity premise. This reading is support
  evidence, distinct from the accepted original C23.02 independent review, which
  also inspected the relevant textbook material. Review and parent substantive
  reconciliation passed; C23.02 is now closed by its actual supported private
  completion record.
- C23.03 adaptation: Sections 17.4 and 19.1/selected start of 19.2, printed
  348–349 and 371–376 / PDF 373–374 and 396–401, were freshly read as UTF-8 text
  at the registered hash by read-only parent support. Complete PDF pages 373,
  398 and 401 were also visually inspected in memory; no renders or extracted
  text artifacts were saved. Definition 19.2's block/rate convention is adapted
  to total deterministic decoders and nats `codeRate`; its optimized budgets and
  operational-capacity liminf definitions are context, not new project APIs.
  C23.03 bounds each supplied actual positive-budget family, deriving the
  boundedness needed for real limsup without rate convergence or a global
  positive-length premise. Definition 19.6/Theorem 19.7 separate information
  capacity from operational capacity. Expurgation and Theorem 19.8 achievability
  remain excluded context. The selected extra prefix-mutation fixture is optional
  and deferred absent proof pressure. Source reading is separate from completed
  initial build/signature/static/documentation and full trust checks. The
  accepted independent reviewer separately verified the hash, reused earlier
  weak-converse reading, freshly read PDF 396–401 as text and visually inspected
  PDF 373, 396, 398, 400 and 401. These five reviewer PW24 visual pages are
  distinct from the three parent-support PW24 visual pages above. All four
  review criteria are satisfied without findings; substantive parent
  reconciliation is complete. C23.03 is now closed by its actual supported
  completion record.
- Historical C23.05 integration/qualification snapshot, subsequently closed: read-only support freshly matched the registered
  hash and read complete §17.1 PDF 367–368 (printed 342–343) and the selected BEC
  discussion PDF 405 (printed 380) as UTF-8 text. Complete PDF 368 and 405 pages
  were visually inspected in memory, including preferred Poppler reinspection.
  Uniform message identities and average error remain distinct from codeword-image
  uniformity and maximum error. The private total BEC fallback gives error ε/2.
  The displayed BEC conditional-entropy omission and uniform-only optimizer
  wording at complete erasure are not adopted: production retains the correct
  erasure weighting without uniqueness. Initial consumer/interface/static and
  documentation checks and full maintained trust passed. The accepted original
  independent report and substantive reconciliation passed without findings. The
  reviewer separately hash-verified/text-read the selected references and visually
  inspected complete PW24 PDF 367, 368 and 405 pages; its additional PDF 367 visual
  check is distinct from the parent support above. Parent support totals nine text/
  six visual pages across both books; reviewer reading totals nine text/seven visual
  pages. Fresh final static/applicability, capture and supported closure remain
  required. No extracts/renders were saved.
- Historical C23.04 adaptation snapshot, subsequently closed by its actual record: Section 17.4, Theorem 17.3, printed 348–349 /
  PDF 373–374, was freshly text-read at the verified registered hash by read-only
  parent support. Complete PDF 373 was also visually inspected in memory;
  no render or extraction artifact was saved. Existing undivided Fano and its
  positive-rate consequence avoid division by `1-Pe`; eventual positive lengths
  and the derived positive lower rate justify the quantitative error bound.
  The displayed indicator/probability mismatch is retained as a source adaptation,
  without replacing the existing decoding-error semantics. The selected pages
  do not state the arbitrary-family frequent-gap theorem; C23 derives it from
  the tolerance cap under hypothetical vanishing error, with no bounded-rate
  premise or eventual-floor conclusion. Initial validation and full maintained
  trust passed. The accepted original independent report satisfied all three
  criteria without findings; substantive reconciliation is complete. The reviewer
  separately verified the hash/extracted relevant pages and inspected the PDF 373
  weak-converse context; its observations remain distinct from the parent
  support's explicitly recorded visual inspection. Fresh final static/applicability
  and supported closure remain required.
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

### Release 3 planning locators

The [release 3 chunk map](plans/release-3-chunk-map.md) uses the same registered
CT91 and PW24 editions. In PW24 see 7.3 and 14.1--14.2 (testing and likelihood
ratios), 18.1--18.4 and 19.2 (one-shot bounds and channel coding), 19.7
(joint source-channel coding), and 10.1/10.3 (variable-length and prefix codes).
In CT91 see chapter 5 (prefix lengths/Kraft), chapter 8 starting at 8.6
(joint typicality and channel coding), and 12.1 (types and cardinalities).
Supplementary open reference: [Polyanskiy and Wu, MIT 6.441 lecture notes](https://ocw.mit.edu/courses/6-441-information-theory-spring-2016/pages/lecture-notes/),
especially chapter 15 on information density and one-shot achievability.
These are section locators, not a claim that the proposed finite-PMF contracts
are verbatim textbook theorems or that the whole proofs have been audited.

### Additional books

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
