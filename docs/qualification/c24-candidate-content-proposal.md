# Candidate Git content: applied checkpoint and successor boundary

**Current — 2026-10-27:** The separately approved Step 6 candidate `05f9bec97d73329877d4f52a6c52f20e7fad4c92` already omits the protected website-task path; primary local bytes and historical release contents remain preserved. Step 7's containing successor must inherit that absence and requires a new exact checkpoint/CAS/location approval. Retention approval alone supplies no Git mutation authority.

## Historical C24.04 Proposal: future candidate Git content

**Proposal only; not executed by C24.04.** This is a concrete input to the later
separate checkpoint/location approval. It changes no local bytes, index or HEAD.

The future candidate tree must **omit `docs/next-website-tasks.md`**. Keep the
primary checkout's existing local bytes intact; its protection digest remains
private in the entry/completion records. Do not copy the file into validation
source fixtures, generated documentation, website staging, release archives or
GitHub-bound patches. Its contents need not be read to implement this treatment.

The file is currently tracked and appears in the local immutable `v0.1.0` tree.
That historical fact is preserved. Do not rewrite the release, tag, old commit,
manifest or frozen route, and do not claim a remote deletion or visibility change.

At the later approval, present the exact candidate-content diff and target
checkout/commit procedure. Prefer an approved isolated candidate checkout so the
primary checkout's private file and unrelated user changes remain untouched.
Apply the omission to that candidate Git tree only; verify the resulting tree
contains no entry at this path. Do not stage the private file's current dirty
contents, and do not silently include unrelated `.gitignore`/`AGENTS.md` changes.
Any needed ignore/exclude treatment must be part of that exact proposal.

Candidate clean/staging checks refuse a HEAD tree containing the path, using Git
tree metadata only. The working file is not deleted by that check. Preparation
metadata/documentation checks do not parse it; ordinary Git clean/diff checks
remain enforced. The absence of an entry in a future candidate tree is distinct
from local-file preservation and from historical presence.

This proposal supplies no commit, push, publication or private-assessment
disclosure authority. If the lead chooses a different treatment, revise the
bounded candidate policy and its tests before qualifying that candidate.
