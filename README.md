# LeanInfoTheory

Lean-certified information measures and entropy-inequality automation for
classical and network information theory.

## Positioning

Lean/mathlib already contains important information-theoretic fragments:
binary and q-ary entropy functions, measure-theoretic KL divergence, coding
basics, and the Kraft-McMillan inequality. Recent downstream projects such as
PFR also developed substantial entropy infrastructure. This repository is meant
to be complementary: an information-theorist-facing Lean library for finite
information measures, entropy-inequality certificates, and eventually
network-information-theory converse proofs.

The project is deliberately mathlib-based. It should not grow a toy probability
model such as `Probability := Rat`; entropy values live in `Real`, distributions
come from mathlib probability objects, and generic lemmas should be upstreamed
when they stabilize.

## Current Status

- Lake project initialized with Lean `v4.30.0` and mathlib `v4.30.0`.
- Mathlib cache fetched successfully for local builds.
- Initial module structure added under `LeanInfoTheory/`.
- Finite Shannon entropy and entropy-derived information measures now use
  mathlib `PMF`s and `Real.negMulLog`.
- Closed theorem examples are present in the algebraic certificate layer.
- Website MVP lives in `home_page/`.
- Blueprint and roadmap notes live in `blueprint/` and `docs/`.

## Lean Modules

- `LeanInfoTheory.Basic`: lightweight project namespace and shared status
  vocabulary.
- `LeanInfoTheory.MathlibFragments`: heavier mathlib anchors we expect to use
  later, including binary/q-ary entropy, KL divergence, KL chain rules, PMF
  constructions, and Kraft-McMillan.
- `LeanInfoTheory.Probability.Finite`: real-mass bridge lemmas in the `PMF`
  namespace for finite Shannon sums.
- `LeanInfoTheory.Shannon.Entropy`: finite Shannon entropy in nats.
- `LeanInfoTheory.Shannon.InfoMeasures`: conditional entropy, mutual
  information, conditional mutual information, named marginals, and
  random-variable versions.
- `LeanInfoTheory.Shannon.SemanticBridge`: separated heavier import boundary
  for future KL-divergence and conditional-law equivalence theorems.
- `LeanInfoTheory.InformationMeasures`: public re-export for finite information
  measures and their first rewrite lemmas. Binary and q-ary entropy remain mathlib names:
  `Real.binEntropy` and `Real.qaryEntropy`.
- `LeanInfoTheory.EntropyExpr`: formal rational linear combinations of entropy
  atoms.
- `LeanInfoTheory.Certificate`: soundness skeleton for nonnegative certificate
  combinations.
- `LeanInfoTheory.Examples`: toy closed examples for the certificate layer.

## Roadmap

1. Prove equivalence between the algebraic finite definitions and textbook
   conditional-law/KL definitions.
2. Audit mathlib, PFR, and divergence-project entropy/KL APIs for reusable
   theorems.
3. Expand entropy-expression normalization and certificate checking.
4. Certify 5-10 toy and recognizable network-information-theory converse steps.
5. Prepare small mathlib PRs for generic, stable pieces.

## Build

```powershell
lake exe cache get
lake build
```

The public project website can be opened locally from:

```text
home_page/index.html
```

## Website Deployment

The repository includes `.github/workflows/pages.yml`, which deploys the
contents of `home_page/` to GitHub Pages.

After pushing to GitHub:

1. Open the repository settings on GitHub.
2. Go to **Pages**.
3. Set **Source** to **GitHub Actions**.
4. Push to `master` or `main`, or run the **Deploy website** workflow manually.

For a repository named `LeanInfoTheory` under `serhatemrecoban`, the deployed
site should appear at:

```text
https://serhatemrecoban.github.io/LeanInfoTheory/
```
