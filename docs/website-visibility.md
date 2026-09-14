# Website Visibility and Adoption

This is the focused record for the visibility pass authorized on 2026-09-14.
It does not change mathematical scope, release identity, or publication controls.

## Positioning

Lead with **a machine-checked information theory library for Lean 4** and the
released library's usable capabilities. Use confident, concrete language:
substantial foundations, reusable results, and research formalizations. Keep
finite-discrete scope and assumptions discoverable. Do not imply a complete
textbook, a completed downstream case study, institutional endorsement, or a
comparative ranking that has not been established.

The release has 601 documented public declarations in 31 supported modules;
these are not 601 theorems. Current development coverage is separate. The
canonical release and its versioned API remain immutable.

## Baseline and implementation

The 2026-09-14 inspection found an old project-oriented GitHub description,
no repository topics, no project sitemap, and no canonical/Open Graph/Twitter
metadata on the homepage. The host-level robots file already permits all
crawlers. Its sitemap lists only the personal homepage. A retrieved search
result still described the former certificate-checker scope, despite the
updated live homepage. This is a dated observation, not a Google rank audit.

GitHub's description and eight topics were updated and read back through its
API: `lean4`, `mathlib`, `information-theory`, `formal-verification`,
`theorem-proving`, `entropy`, `probability`, and `mathematics`.

Prepared local changes:

- Confident README and homepage introductions, with release procedures folded
  away from the getting-started path rather than erased.
- Five guides: installation, information measures, Markov/data processing,
  research projects, and the relationship with mathlib.
- Four independently compiled guide examples added to the documentation gate.
- Nine curated pages with canonical, description, and social-sharing metadata,
  plus a project sitemap. Social cards use text metadata, not a fabricated image.
- Regression checks for metadata, sitemap consistency, example identities,
  and HTML entity decoding. Existing release/trust checks remain intact.

The sitemap deliberately promotes the landing pages and guides. It is not a
copy of the 5,000-plus-page imported API dependency tree. All reference pages
remain accessible through normal links. Deep API links in guides point to the
published immutable version, which is not present in full in the source tree.

## Publication and account actions

Validation completed: focused Markov/Theorems build (2,753 jobs), five README
and four guide examples with warnings as errors, static checks including
two-pass generated-artifact checks, 34 website tests, and 40 other validator
regressions. Seven pages passed browser layout checks at widths 1440, 390,
and 320; screenshots were inspected. All four published guide deep links
returned HTTP 200. The clean-checkpoint suite and full staged publication gate
remain for the publication checkpoint, not waived by these component passes.

The GitHub About changes are live. The README and website changes remain local
until committed/pushed and the guarded Pages maintenance workflow is approved
and run. The starting checkout already had two unrelated unpushed commits;
this visibility pass does not silently publish them. No tag,
release, DOI, frozen route, workflow, or dependency pin is changed here.

The lead subsequently approved the checkpoint, push including the two existing
C9 commits, and guarded Pages publication. Execution must retain the complete
clean-tree and frozen-API publication gates; approval is not a deployment result.

For Google Search Console, the owner should sign in and add the URL-prefix
property `https://serhatemrecoban.github.io/LeanInfoTheory/`. If it is not
already verified, provide the HTML verification tag or file for installation.
After deployment and verification, submit
`https://serhatemrecoban.github.io/LeanInfoTheory/sitemap.xml`, inspect the
homepage and main guides, and request indexing where appropriate. A sitemap
and indexing request do not guarantee inclusion or ranking.

No new robots file is needed. Rules for this host belong at
`https://serhatemrecoban.github.io/robots.txt`, not under `/LeanInfoTheory/`.
Updating the personal site's sitemap or adding a reference to the project
sitemap there is optional and belongs to that separate website repository.

Before broad contributor outreach, revisit Future Work Note 10's contributor
guidance. Publish community announcements only after the owner reviews their
wording and the new pages are live. Downstream authors decide when their case
studies are public. No private PFR or ShannonCert material is published here.

## Measurement

After deployment, record dated Search Console impressions, clicks, and query
positions. Compare fresh search-enabled assistant responses to a small fixed
set of unseeded questions, recording model, date, search setting, citations,
and whether the stated scope/version is correct. Do not infer ranking from one
personalized search or one assistant answer. Suggested questions:

- What information theory libraries can I use in Lean 4?
- How can I formalize entropy and mutual information in Lean?
- Is there a Lean library with Markov-chain data processing and Fano's inequality?

No recurring automation, analytics tracker, or ranking service is installed.
No improvement in rank or assistant recommendations is claimed before measurement.

## Announcement draft

LeanInfoTheory v0.1.0 is an open-source, machine-checked information theory
library for Lean 4 and mathlib. It brings entropy, mutual information, KL
divergence, stochastic channels, Markov chains, data processing, Fano
inequalities, and sufficient statistics into a reusable finite-discrete API.
The release includes 601 documented public declarations across 31 supported
modules, versioned API documentation, and a tagged Lake dependency. It is
designed for researchers formalizing information-theoretic mathematics and
developers building on checked mathematical foundations. Explore the guides
and try it in your own Lean project:
https://serhatemrecoban.github.io/LeanInfoTheory/

This is a draft, not a posted announcement or a claim of completed case studies.

## Discovery references

- [Google: AI search guidance](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide).
- [Google: sitemaps](https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap).
- [OpenAI: search and training crawlers](https://developers.openai.com/api/docs/bots).
- [Anthropic: search, user, and training crawlers](https://privacy.claude.com/en/articles/8896518-does-anthropic-crawl-data-from-the-web-and-how-can-site-owners-block-the-crawler).
- [GitHub: repository topics](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/classifying-your-repository-with-topics).

Search access and model training are distinct. The priority is accurate,
crawlable public documentation and genuine adoption, not hidden instructions,
keyword stuffing, manufactured endorsements, or guaranteed-ranking claims.
