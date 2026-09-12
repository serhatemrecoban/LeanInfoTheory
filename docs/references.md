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
- Section 7.4, Theorem 7.10: Pinsker via binary reduction; its full
  f-divergence/joint-range programme is not selected.
- Section 4.5, Proposition 4.8: finite entropy continuity; Section 4.7,
  Proposition 4.13: finite MI continuity. Sections 5.1--5.2 provide information
  optimization context; general-measure minimax and infinite-alphabet results
  are not commitments.
- Section 6.1, Theorem 6.1: block MI and memoryless-channel single-letterization.
- Section 11.1: one-shot source coding; Section 11.2, Proposition 11.6:
  AEP, typicality, and their coding consequence. These sections differ from
  the older draft, which grouped AEP under Section 11.1.
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
- Chapter 5 is optional background for later coupling applications, not a
  Markov-process or mixing-time commitment. The proposed finite gluing law
  will be proved using conditional PMFs; no unverified numbered gluing theorem
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
