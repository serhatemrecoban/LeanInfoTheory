# Chunk 12 implementation notes

The [approved revision-2 plan](post-release-chunk-12.md) fixes the public
contracts and step boundaries. These notes record proof choices and evidence
without changing those obligations. Each step's completion is established by
its private review record.

## C12.01 — Generic transport and supplied coupling channels

The coordinate-map proof composes pushforwards and uses the two supplied
marginal equalities. Channel lifting pushes each coordinate map through `bind`,
uses `channelJoint_eq_iff_eq_on_support` to equate the supported output rows,
then projects the resulting joint equality and rewrites the input marginal.
The two output universes remain independent. No public bind-congruence helper,
new import, finiteness assumption or simp attribute is needed.

The permanent `Examples.CouplingTransport` consumer imports only
`Probability.Coupling`. Its diagonal fair-Bool regression uses swapped pure
rows: the supported diagonal rows have the prescribed marginals, while the
unused `(false,true)` row has both marginals wrong even though each coordinate
is individually supported. The public lifting theorem still applies.

These are derived consequences of PMF pushforward/bind algebra and the coupling
definition. The approved plan's LP17/PW24 references supply the coupling
convention; no separately numbered textbook transport theorem is asserted.

The initial ordinary owner build stalled and was stopped without a Lean proof
diagnostic. Its failure is retained separately from subsequent compilation.
Source-bound validation and the original independent report belong in the
private C12 execution records; this note does not certify their outcome.

At C12.01 closure, gluing and null-fiber extension equality were left for
C12.02, and the quantitative contraction consumer for C12.03. No naming
friction justified an alias or promotion of private machinery.

## C12.02 — Null-fiber invariance and finite gluing

The extension equality theorem projects an equality of triples to the output
pair and reuses `channelJoint_eq_iff_eq_on_support` for necessity. For sufficiency,
the atom formula and supported-row equality handle positive middle fibers.
Outside middle support, any nonzero input-pair atom would put its second
coordinate in that support, so the input-pair atom is zero. Both extension
atoms then vanish. This proof needs no Shannon marginal or conditional API.

The gluing theorem obtains `Fintype gamma` locally from `Finite gamma`, takes
the total conditional channel of `R.map Prod.swap`, and extends `L`. Input
projection gives `L`; output-pair projection, the common-middle equation,
existing conditional reconstruction and double swap give `R`. The existing
channel-extension theorem supplies Markov structure. The supplied PMFs provide
the null fallback through the existing conditional-channel definition; no
inhabitant is selected and no division is introduced in the new proof.

The semantic owner contains one existence theorem and imports only Markov.
The consumer identifies the returned witness with an explicit extension using
existing Markov factorization and the new support equality theorem. Any such
identification remains private. The construction is derived from existing PMF
and conditional-channel algebra; the plan's reference sections establish the
coupling convention but are not cited as a numbered gluing theorem.

The maintained consumer uses a fair Boolean law mapped into middle values
`0` and `1` of `Fin 3`. The two supported rows return different deterministic
Boolean outputs. At middle value `2`, changing the output from pure false to
pure true gives unequal channel rows, yet the support theorem proves equality
of the whole extension. Private Markov factorization identifies the same triple
returned by the public gluing theorem with this extension, so its exact pair
laws and diagonal endpoint law are properties of that witness.

The generic endpoint consumer obtains both pair laws from the public theorem
and uses coordinate map composition to derive the two endpoint marginals.
It does not call unrelated endpoint-coupling existence. A generic pure-law
consumer identifies the returned triple as the exact supplied point mass.
Separate singleton and impossible empty-coordinate cases, and a
`Nat`/`Nat`/`Bool` consumer, check degenerate and non-finite ambient alphabets
without strengthening the public assumptions.

## C12.03 — Quantitative consumers and maximality regression

The transport consumer uses the actual C11 maximal constructor for both the
input coupling and every output row. The new support-aware lifting theorem
gives the two prescribed output marginals. The PMF bind event formula and C11's
exact ENNReal disagreement formula give the finite weighted sum of row TVs.
Each weighted term is non-top because the PMF mass and `ENNReal.ofReal` factor
are non-top; their finite sum is non-top as well. The input disagreement has
the same guard through its exact maximal-coupling formula. `toReal_sum`,
`toReal_mul` and TV nonnegativity then give the Real weighted formula.

The middle contraction bound compares each summand with the corresponding
input disagreement indicator. Equal input coordinates give TV zero; different
coordinates use TV at most one and nonnegative input mass. The universal
coupling inequality supplies the lower bound, and C11's exact input event value
supplies the upper endpoint. C10's stochastic contraction is applied to those
same output laws. The deterministic consumer rewrites both outputs with the
existing deterministic-channel identity and uses C10's map contraction. Equal
inputs, constant channel rows and subsingleton outputs provide degenerate cases.

The Boolean regression uses `channelJoint` with a constant pure middle row and
a constant fair output row. Direct finite event calculations establish ENNReal
disagreements first, then non-top and Real values. Both adjacent disagreements
equal their TVs, and the universal coupling inequality compares each supplied
law against every competing coupling. This establishes maximality without a
new predicate or dependence on the maximal constructor's implementation.

The consumer calls the public gluing theorem once. The private witness
identification helper from C12.02 uses both pair marginals and Markov structure
to identify that returned triple with the constant-fair extension. Atom and
endpoint projections then give the quarter/zero triple atoms and independent
fair endpoints. The exact endpoint disagreement is one half; the diagonal law
has zero disagreement, proving strict non-maximality of this particular Markov
gluing. The null-row clause permits every channel whose false row is fair and
uses the whole-extension support iff to identify its extension with the same
triple. No assertion concerns all arbitrary gluings with these pair marginals.

The targeted reference reread covered LP17 Section 4.2 (coupling definition,
fair-bit example and universal/attained disagreement bound) and PW24 Section
7.3, Theorem 7.7(b). Their registered file identities were verified. The
weighted contraction and specified non-maximal gluing are derived applications,
not separately numbered source theorems. No external implementation was used.

The optional endpoint error-accumulation inequality remains omitted. The
required weighted consumer already provides substantive quantitative composition;
another private bound is not needed to test a remaining public contract. The
four public theorems all have maintained consumers, and no naming or proof
pressure calls for a public alias or helper. The approved normative plan and
C12.04 cumulative boundary remain unchanged. Source-bound validation and review
results are retained in the private execution record.

## C12.04 — Cumulative qualification and handoff

C12.03's actual private closure and exact final source were verified before
selecting C12.04. The four public theorem contracts and all mathematical source
remain unchanged during initial closeout preparation. The maintained
[C12 handoff](../handoffs/chunk-12.md) reconciles delivered consumers, imports,
source adaptations, prior reports and deferred work with owners and triggers.
Canonical status and current counts now distinguish C12 from historical C11.

The build-command audit found that `-KwarningAsError=true` passes a Lake
configuration option; this package does not consume it as a Lean option.
Successful earlier invocations remain compilation evidence with no observed
warnings, without treating that flag as enforced warning rejection. The pinned
Lake interface exposes `--wfail`. An isolated fixture confirmed that the old
flag accepts a warning while `--wfail` rejects both fresh and replayed warnings
and accepts clean source. The maintained validator, compatibility/export/fixture
builds and CI build arguments now use `--wfail`; direct Lean warning options
remain intact. Eight validation tests and fourteen compatibility tests passed,
including real small Lake builds through both maintained and focused entry points.
This repairs implementation of the existing validation requirement, without
changing the accepted warning policy, mathematical contracts or dependency pins.

The first cumulative static run then rejected the changed Pages workflow's
exact fingerprint, as intended. Parent and helper inspected the complete
workflow and verified that its only change is that warning flag. Manual-only
dispatch, default-false publication, guarded deployment, immutable action and
release identities, and separate current/frozen artifacts are preserved.
The expected fingerprint was updated after that explicit release-safety check;
the initial failed check remains evidence. The cumulative reviewer must still
assess this correction along with the candidate.

Corrected focused/static checks and eleven retained-export tests passed.
The first C12 API-doc attempt then rejected a missing Gluing HTML page despite
updated `docInfo`. Inspection confirmed the historical aggregate-marker failure
mode. Exactly the three ignored Shannon marker/sidecar files were preserved and
invalidated; the unchanged maintained gate then passed both actual file-mode
build/semantic-check passes. All four new declaration blocks, source links and
the new owner page were inspected against the source. The handoff identifies
original results, recovery bytes, exact digests and the v2 attestation.

The lead subsequently authorized the exact 35-file checkpoint, necessary
C12.04-only corrections/final-record amendments and a separate clean validation
checkout. Initial checkpoint `44d300c97d86b1fc0f40e9c70eb33a16bbfe3abe` passed
the complete routine suite in that clean checkout with ordinary copied pinned
dependencies and caches. The original checkout retains the unrelated website
notes unchanged and outside the checkpoint. The handoff identifies the original
result and separates it from the API-doc passes in the original checkout.
Final amended-candidate validation and exact source/configuration applicability
must still be established. C12.04 remains open until fresh all-13 review,
reconciliation, final capture and private closure are complete.
