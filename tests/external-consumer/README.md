# External candidate consumer

This fixture exercises supported LeanInfoTheory APIs from a separate Lake package.
The recipe takes a full candidate Git SHA at execution; no containing commit is
embedded in the sources. It creates no candidate commit and publishes nothing.
Use it only after approval of the exact checkpoint and repository-local locations.

## Applications

Each module compiles separately with the imports listed here. The generated Lake
library has seven explicit roots; one module's imports cannot supply another's.
There are no imports of non-stable examples or references to their private helpers.

| Module | Import and application |
| --- | --- |
| `Consumer.RootOnly` | Lightweight `LeanInfoTheory`: retained relabeling and diagonal mutual information. |
| `Consumer.CouplingContinuity` | `Shannon.Continuity`: a supplied coupling's disagreement budget bounds entropy difference; maximal coupling attains TV. |
| `Consumer.ProductInformation` | `Shannon.SemanticBridge.ProductChannel`: actual marginal objectives bound arbitrary-input MI, including duplicated Boolean coordinates. |
| `Consumer.SourceCoding` | `Shannon.SourceCodingAsymptotic`: extract one above-entropy family and apply the general converse to those same budgets and codes. |
| `Consumer.Capacity` | `Shannon.StandardChannelCapacity`: extract an actual maximizing input and compose BSC uniform attainment with its capacity formula. |
| `Consumer.WeakConverse` | `Shannon.ChannelCodingAsymptotic`: all-length Fano and asymptotic weak-converse bounds for one actual code family and its error. |
| `Consumer.FullUmbrella` | `LeanInfoTheory.Shannon`: arbitrary-input repeated-BSC MI bound, including correlated inputs and length zero. |

Quantities use nats. Positive message budgets, finite/nonempty alphabets and actual
support requirements remain explicit. Source achievability is strictly above
entropy; channel achievability and a channel strong converse are not asserted.

## Run

Requires Python 3.11+, Git, Lake and the pinned Lean 4.33.1 toolchain. Network
access may be needed for the existing exact dependencies and mathlib's binary
cache. Incremental/downloaded caches are permitted and do not imply a cold build.

From the primary repository root, after the exact approval, supply the actual
clean candidate checkout and the SHA containing the intended fixture sources:

```powershell
$CandidateSha = '<full 40-character approved candidate commit>'
python -B tests/external-consumer/run.py `
  --repository '.worktrees/LeanInfoTheory-C12-validation-20261003' `
  --candidate-sha $CandidateSha --workspace . `
  --work-dir '.worktrees/LeanInfoTheory-C24-consumer-20261026/run-01' `
  --evidence-dir '.lit-review/setup/c24-06-20261026/external-run-01'
```

For public qualification after the exact commit is on GitHub, pass `--github`.
Use fresh work and evidence folders. This installs from the canonical HTTPS URL,
verifies the resolved Git origin, and runs the same seven compiler and origin checks.

Use approved paths appropriate to the execution host. Both output directories
must be new: the recipe refuses to overwrite or clean an earlier run. Keep prior
attempts and use a fresh numbered child under the approved consumer location
for a retry. A changed candidate/fixture still needs the applicable exact
checkpoint approval and fresh compilation.
The candidate checkout and consumer must be physically separate under the
primary repository's ignored `.worktrees/`; evidence stays in `.lit-review/`.
The default locations above are examples, not a grant to create/change them.

The recipe checks the candidate checkout's clean exact HEAD, unchanged toolchain,
and omission of the private website-task path. It compares its invoked fixture
bytes to `git show SHA:tests/external-consumer/...`, with explicit CRLF-to-LF
normalization, and materializes the committed Lean sources. The sole dependency
is a `file:` Git URL plus the exact supplied SHA, not the primary working tree.
It removes inherited `LEAN_PATH`, `LEAN_SRC_PATH`, `LEAN_SYSROOT`, package-directory
overrides and Git worktree/index redirection variables before invoking tools.

The recipe then:

1. Runs `lake update` and retains the complete resolved manifest.
2. Checks the exact candidate revision/URL and every transitive Git revision/URL
   against the candidate's committed manifest, and verifies clean physical clones.
3. Records the actual Lean version and prefix, obtains the pinned mathlib cache,
   and runs `lake --wfail build Consumer` with `warningAsError = true`.
4. Resolves both `.lean` and `.olean` origins for every fixture import through
   Lean's actual Lake search paths, requiring the materialized dependency clone.
5. Rechecks clone cleanliness, the candidate HEAD, manifest, toolchain,
   configuration and exact compiled fixture bytes after compilation.

Each command has its actual arguments, working directory, elapsed time, exit code,
raw output and output hash in the private evidence directory. `result.json`
records PASS or FAIL; a failed attempt remains a failure. A preflight or fixture
unit test is not evidence that an external candidate package compiled.

Run the recipe's bounded isolation tests from the repository root with:

```text
python -B -m unittest discover -s tests/external-consumer -p test_run.py -v
```

These tests cover environment isolation, exact pin/origin refusal and physical
origin substitution. They create only disposable files beneath the root's ignored
`.lake/`; they do not commit, stage, publish, or qualify a candidate.

## Applicability and discovery

Local-Git success establishes local exact-commit package use. It does not establish
remote installation, a public tag, a complete clean release suite, retained API
qualification, doc-gen artifacts, or publication readiness. No downstream PFR or
ShannonCert checkout is edited.

Every candidate-SHA, fixture, relevant configuration or dependency change requires
materializing/re-pinning as applicable and compiling again. Source inspection may
remain applicable across prose-only changes, but it cannot replace compilation
against the new SHA. Retain the resolved manifest and run logs outside tracked
sources rather than introducing a recursive containing-commit hash.

Record reproducible discovery friction in the project's downstream feedback
register; ordinary successful searches need no entry. Search source, generated
indexes, likely focused imports and pinned mathlib before proposing an alias.
The weak-converse methods belong to `Shannon.BlockChannelCode`; source-coding
existence/converse theorems belong directly to `Shannon`. This orientation is
used in the fixture without adding library aliases.
