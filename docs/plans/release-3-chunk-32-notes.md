# C32 implementation notes

## C32.01 — Sent-index, actual-prior and maximal error

Only C32.01 is selected. The approved revision 2 supplies the mathematical
contract and six-step boundaries. Nine declarations implement the three
definitions, uniform mean, weighted sum, uniform/pure specialization,
maximum characterization and every-prior bound. The two specialization
theorems support permanent consumers and downstream inspection directly.
All belong to `Shannon.ChannelCodeExpurgation`, with ChannelCode as its
only direct import. No additional attribute or probability abstraction is
introduced.

The consumer needs only that focused owner. Generic examples retain arbitrary
input types, finite outputs and every natural length. It proves row and
maximum ranges from the public pure-prior identity and Fano bounds. A
two-label, one-letter code sends the same Boolean word for both indices
and always decodes label zero. Its row errors differ, its uniform error
is one half, and pure priors yield zero and one. A zero-length code on empty
base alphabets protects the finite definition without a positive-length
premise.

The [approved source basis](release-3-chunk-32.md#incoming-evidence-and-mathematical-sources)
and reference register distinguish CT91's row/mean/max definitions from
PW24's randomized/erasure convention and from the project's arbitrary-prior
extension. Fresh read-only support matched both hashes and inspected
CT91 printed 193–194 visually and textually; PW24 342–343 textually.

Intake matched C31.05's exact captured project files and dependency pins.
The new C32 plan was the sole added project path. Fresh compiled comparison retains all 857 C31 records and the historical
601/811 contracts. Current growth is nine names, to 866 in 65 supported
modules. Preserve all prior names, the
two direct lightweight-root imports / five reachable modules / 92 exports,
and the 94 reviewed simp names. Actual commands, output, source applicability,
original report, reconciliation and closure are retained under
`.lit-review/setup/c32-01-20261113/`. This step's completion depends on its
supported private `completion.json`. Later steps await their own selection.


The focused warning-as-error build, static gate, compiled compatibility and
all-project axiom audit passed on the reviewed source. The axiom audit covers
4508 local constants across 126 project modules and uses only propext,
Classical.choice and Quot.sound. Exact named comparison also preserves all
C31 types, focused imports and reviewed attributes. The full routine clean
suite, release documentation gate and cumulative closeout remain C32.06.

The original persistent review assessed C32.01-ROW, C32.01-PRIOR and
C32.01-MAX as SATISFIED, independently compiling both focused Lean files
and a caller for an arbitrary prior. Its one nonmaterial wording finding
is corrected in the consumer header: the code's weighted error changes
with its prior, while the never-decoded index's row error stays one.
The correction changes no declaration or proof. Final focused/static
validation and the explicit R-to-F applicability assessment govern closure.
Initial proof/linter failures and the interrupted duplicate standalone
check remain non-passing records in the private evidence.


## C32.02 — Restriction and total decoder transport

The conditional instruction admitted only C32.02 after C32.01's supported
closure and original report/reconciliation were verified against the exact
final checkout. Three declarations in the existing finite owner define
restriction along an embedding, preserve correct decoding on every output,
and bound the restricted row error by the old error at the embedded label.
The new encoder is definitionally the old encoder composed with the
embedding. Function.extend supplies the inverse on the image and redirects
every discarded decoder label to the explicit fallback. This construction
needs no channel law or output enumeration. Probability sums still expose
the existing finite-output hypothesis.

The prior comparison is a private consumer theorem. It uses the local
sum_map_toReal_mul argument already present privately in
Shannon.SemanticBridge.ProductChannel, avoiding a heavy production import or
an extra public abstraction. The scalar sum identity itself needs no
injectivity. The code restriction uses the specified embedding. A second
restriction is checked using the rowwise theorem twice.

The four-index noiseless fixture and both fallback choices exercise the
exact criterion in the approved revision 2. Its original uniform mean is
1/4, whereas the old error under the transported two-point prior is 1/2.
New fallback 0 (old label 0) preserves row errors (0,1); new fallback 1
(old label 3) improves them to (0,0). The generic fallback check ranges over every
output, independently of its channel mass. No global encoder injectivity
or rate statement is introduced.

The [approved source basis](release-3-chunk-32.md#incoming-evidence-and-mathematical-sources)
and reference register distinguish textbook extraction/reindexing from the
explicit project fallback and prior-transport consequences. Fresh
read-only reference support matched both PDF hashes and inspected only
the relevant passages as text.

Current growth is 866 to 869 names in 65 supported modules. All 866 incoming
source records and the prior producer/consumer declaration prefixes are retained;
imports, root exports, reviewed simp and pins are unchanged. Focused
warning-as-error builds, nonmutating static checks and compiled probes for
the three new public signatures/axioms passed. The complete compiled compatibility
and all-project axiom evidence from C32.01 retains its actual source
attribution. C32.06 owns the next cumulative clean full suite. Current
checks, independent review, reconciliation and closure are retained under
`.lit-review/setup/c32-02-20261113/`; only its supported completion record
establishes completion. C32.03 remains unselected.

The bound independent reviewer satisfied both C32.02-DECODE and C32.02-ERROR.
It independently elaborated the producer, consumer and an arbitrary-alphabet
failure/point-prior caller, reran static checks, queried permitted axiom
dependencies and checked the actual supplied parent outputs. Its 432-case
finite enumeration is supplementary to the generic compiled proofs. The sole
nonmaterial finding asked that the summary distinguish new fallback 1 from
old label 3. Both current summary copies now do so. Read-only scope support
also prompted explicitly saying that preservation applies to retained indices.
The parent accepted both original assessments and resolved the finding.
Only the summary, project log and these advisory notes change after R;
all Lean source, generated output, imports, attributes and pins remain exact.
Final static checks and that R-to-F comparison govern applicability, without
claiming fresh complete historical compiled or whole-project trust gates.


## C32.03 — Count all good indices and select exact budgets

Only this step was admitted after verifying C32.02's supported completion,
original satisfied report and reconciliation, final source bytes, Git and
environment. The existing finite owner gains two public statements:
`half_le_card_filter_messageErrorProbability` and
`exists_expurgated_restrictions`. No new owner, import or public helper is
needed. The count proof uses the released uniform-mean identity. At zero
mean its nonnegative sum forces every row to vanish, giving the whole set.
At positive mean the bad rows bound their count times `2e`; cancellation
and natural arithmetic give the ceiling-half bound.

The exact theorem enumerates every good original index with
`G.equivFin.symm`, then includes its subtype into the original labels.
Its range equality prevents an arbitrary good subset from replacing the
whole set. Prefixing this enumeration handles every positive `K ≤ G.card`.
The returned code identity records restriction of the original code and
its total fallback. The maximum is bounded before the final `∀ π`, so
arbitrary and point-mass priors use that same selected code. No rate result
is claimed for the requested smaller budget.

The focused consumers exercise arbitrary requested budgets, the full good
count, budget one with traced encoder values, pure and arbitrary priors,
odd original count and zero-mean/all-good behavior. Their finite statements
have no positive-blocklength hypothesis. C32.05 retains its discriminating
numerical expurgation and boundary fixtures. C32.04 retains rate/family work.
Fresh source checks matched the registered CT91/PW24 hashes and targeted
expurgation passages as text; the source register records the adaptations.

The source inventory has grown from 869 to 871 names in 65 supported modules. All 869 incoming
records and the prior declaration bodies, imports, attributes, root boundary
and pins remain retention controls. Focused builds, static and compiled new
signature/axiom checks qualify this additive step; complete historical
compiled and whole-project trust results retain their C32.01 attribution.
C32.06 owns cumulative clean qualification. Actual checks, original review,
reconciliation and closure live under `.lit-review/setup/c32-03-20261113/`;
only its supported completion establishes closure. C32.04 remains unselected.


The fresh focused warning-as-error build, static and compiled new-signature/
targeted-axiom checks passed. The initial build's sole unused proof-binder
warning was fixed by naming that existential proof `_hL`; no mathematical
contract or assumption changed. The initial nonpassing record is retained.
The source audit retains all 869 incoming declaration records and the exact
earlier producer/consumer prefixes, with 871 current names in 65 modules.

The original bound independent report satisfies both C32.03-COUNT and
C32.03-EXACT with no findings. Besides independently compiling the producer
and consumer, it compiled a full-budget caller recovering old correct
decisions from the exact range and returned code identity, on the same code
that supplies the every-prior bound. Its static rerun, targeted axiom queries,
source/reference inspection and parent-output digest checks passed. Its
5460 exact rational-vector checks (including six zero vectors and 980
positive-mean tie cases) are supplementary reviewer-reported evidence.
The parent reconciles and accepts both original assessments; earlier prose
and strict-fallback findings remain resolved in the unchanged source.
Only three Markdown documents change after R. Every Lean source, generated
artifact, import, attribute, policy and pin remains exact. Final static and
the explicit R-to-F comparison govern applicability. No fresh complete
historical compiled or whole-project trust gate is claimed. The supported
private completion record alone establishes this step's closure.


## C32.04 — Positive-length rate loss and one supplied family

C32.03's actual closure, clean report/reconciliation and exact final source,
Git and environment were checked before only this step was admitted. The
scalar lemma derives positive M and L, applies log monotonicity to M≤2L,
expands log(2L), and divides by positive length. It belongs in CodingRate
and adds no imports. Its hypothesis is a budget comparison; the full good
count supplies that comparison. Arbitrarily smaller requested budgets have
no rate guarantee without their own M≤2K condition.

OperationalExpurgation imports exactly the two planned local owners. The
needed limit declarations are already in their transitive import closure;
no capacity, random-coding or extra external import is added. At each n it
uses the finite exact theorem at K=G.card, eliminates the identity prefix
embedding and retains the full set. Classical selection fixes L,hL,D once.
A pure prior at a retained fallback supplies nonnegativity of each maximum;
the twice-mean bound and he.add he give its limit. The old rate tail at δ/2
and the positive-length log 2/n tail give the retained rate floor at δ.
The real R appears only in the input/output rate floors and needs no new
nonnegativity or rate-convergence assumption.

The C31-facing consumer imports the new owner and OperationalCapacity,
opens one IsAchievableRate witness, passes its actual components and obtains
the same D before two independent positive tolerances. The exact original
code identity and full good-set range are retained at every n, including
zero. Positive length is used for normalized rate loss. Smaller budgets,
priors varying with length and numerical expurgation fixtures remain C32.05.

The new-module and full-umbrella growth records identify the approved
ownership/criteria, actual selected instruction and verified predecessor.
The source inventory has grown from 871 to 873 names in 66 supported modules. Retained-name,
import, root 2/5/92, reviewed simp 94 and pin controls remain in force.
Fresh focused/static and compiled new-signature/targeted-axiom checks qualify
this step; full cumulative clean qualification belongs to C32.06. Actual
evidence, original review, reconciliation and closure live under
`.lit-review/setup/c32-04-20261113/`; its completion alone closes the step.


The fresh scalar and full warning-as-error focused builds, static and
owner-only compiled new-signature/targeted-axiom checks passed. The new owner
needs only its two approved imports. All 871 old declaration records and
earlier CodingRate bytes are retained, with other old Lean files unchanged
except the reviewed import-only aggregate additions. The current surface is
873 names in 66 supported modules, with unchanged root/simp/pin controls.

The original bound independent report satisfies C32.04-RATE and C32.04-FAMILY
with no findings. The parent separately reconciles and accepts both original
assessments against the scalar hypotheses, full retained-code identities,
maximum-error squeeze, positive-length rate tail and one-witness/two-tolerance
caller. Original reviewer checks and their limitations remain in its retained
report; parent-run checks retain their own source and actor. Only three
Markdown records change after R, so every reviewed Lean source, generated
artifact, import, attribute, growth policy and pin remains exact. Final static
validation and the explicit R-to-F comparison govern applicability. No fresh
complete historical compiled or whole-project trust gate is claimed; C32.06
retains cumulative clean qualification. The supported completion record alone
closes C32.04, and no C32.05 implementation is selected.


## C32.05 — Discriminating consumers and varying priors

Only this step was admitted after exact C32.04 closure/source verification.
Both edits are nonstable consumer modules. The finite module keeps all earlier
fixtures and adds CodingRate for the required too-small-budget counterexample.
The operational module keeps its two imports and strengthens the same anonymous
C31 caller, preserving the full-family identities, maxima, rate loss and
two-tolerance floor. No public helper or producer change is needed.

The finite examples inspect actual returned embedding ranges, never enumeration
order. The odd-five fixture rules out taking the first three old labels.
The four-label full code has maximum zero; the generic smaller-budget call
selects its code before every prior. Earlier {0,3} fallback/prior-transport
tests remain intact. Singleton and empty-word statements quantify arbitrary
codes; M=2 at n=0 checks equality at the threshold in the real finite theorem.

For every K,hK,hfit the caller defines d by restricting D. It proves the new
maximum is at most D's using the rowwise inequality and finite maximum iff;
every prior error is below the new maximum. Both p.map f and pure j specialize
the same d n. Every prior sequence has vanishing actual error by squeezing.
L alone carries the rate floor. C33 must prove its source budgets fit on a tail,
define its exceptional lengths and prove the joint reconstruction estimate.
These remain C33 duties rather than new assumptions or composition in C32.

The initial focused build's arithmetic proof gap and two long-line diagnostics
were corrected locally. The nonpassing output is retained. Fresh strict focused,
static, generated-artifact and all-project axiom records qualify this candidate;
source retention checks all 873 public records and every producer byte, with
66 supported modules, root 2/5/92, reviewed simp 94, policies and pins unchanged.
Historical full compiled compatibility retains its C32.01 source attribution;
complete clean cumulative qualification and the maintained handoff remain
unselected C32.06. Independent review and closure are recorded privately.


The original independent report satisfies C32.05-COLLISION, C32.05-BOUNDARY
and C32.05-CALLER with no findings. The parent separately reconciles every
original assessment against the actual returned ranges, finite boundary
examples and family/budget/prior quantifiers. Earlier findings retain their
original resolutions and current-source applicability. All original reviewer
checks and limitations remain in the retained report, distinct from parent
checks. Only this note, the summary and project log change after R. Every
Lean and generated file, import, policy and pin remains byte-identical.
Fresh final static and exact R-to-F comparison support applicability. The
all-project axiom audit is fresh C32.05 evidence; full historical compiled
compatibility remains attributed to C32.01. C32.06 retains clean cumulative
qualification and the maintained C33 handoff. Its implementation is unselected.
The supported private completion record alone closes this step.


## C32.06 — Cumulative criteria and C33 handoff

C32.05's exact private closure, original clean report/reconciliation and final
source/Git/environment admit this final step only. The private startup-list
typo was caught before state mutation; its failed record remains preserved.
No mathematical statement, public declaration/import, simp attribute, policy,
root or pin changes in closeout. Fresh compiled compatibility catches duplicate
`errorProbability.congr_simp` raw module ownership in ChannelCoding and the
new operational owner. C29.04 provides the same compiler-artifact precedent.
An exact source clone reproduces the raw collision; serialized separate-import
probes identify the set-coercion and twice-error-limit simplifier calls as the
minimal two-site cause. The proof now uses `Finset.coe_filter_univ` and
`Tendsto.const_mul` with targeted rewriting. The retained-code identity proof,
statement, assumptions and imports stay unchanged. All other Lean bytes match
C32.05. Failed original and positive/negative serialized controls remain
attributed, and the complete gate set is rerun on the corrected candidate. The maintained
[handoff](../handoffs/chunk-32.md#coverage-and-evidence) contains the complete
fifteen-criterion source/consumer matrix, exact contracts and C33 obligations.
It distinguishes the transported old prior from the old uniform prior, allows
strict improvement via fallback, keeps all threshold ties and chooses one
exact-budget family before every prior sequence. No additional wrappers or
maximal-error operational predicate are justified by current consumer pressure.

Actual fresh focused/generated/static/documentation/compatibility/trust results
and named compiled 857→873 retention are stored under the C32.06 private setup.
Equal source-provider observations bind the main qualification. A separate
exact raw-manifest checkpoint authority is required for the clean full suite;
previous checkpoint grants do not transfer. All original helper bytes and
primary state are preserved and restored by that scoped qualification.
The original persistent reviewer must assess every approved criterion on the
fixed candidate. Its report, parent decisions, source applicability and private
completion establish outcome; these readiness notes are not acceptance.
All required source/docs edits precede final capture. If the source remains
unchanged after the cumulative review, the same clean-suite source and R apply
to F without a documentation-only checkpoint amendment. A material correction
requires fresh qualification and any renewed independent assessment.
C33 requires its own approved plan and explicit step selection.
