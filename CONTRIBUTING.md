# Collaborating on LeanInfoTheory

I welcome people who want to help build this information-theory library.
You can contribute mathematics without knowing Lean, or contribute Lean expertise
without being an information theorist.

## Where to start

- **Need a theorem?** [Open an issue](https://github.com/serhatemrecoban/LeanInfoTheory/issues)
  with the statement in ordinary mathematical notation, a reference if you have
  one, and a sentence about how you want to use it. A proof sketch or a small
  example is helpful, but not required.
- **Found an unclear explanation or a small bug?** A focused pull request is
  welcome without a prior issue. For a bug report, include the release or commit
  and the smallest example that shows what you expected and what happened.
- **Planning a larger formalization?** Look through the [open issues](https://github.com/serhatemrecoban/LeanInfoTheory/issues)
  first. Before investing in a proof, propose the main theorem, its hypotheses,
  and which existing results you expect to use. We can discuss what belongs in
  this library and what is specific to your application. No formal blueprint is
  needed to start that conversation.

## Preparing a pull request

1. Work on a branch in your fork, using the repository's pinned Lean toolchain
   and dependencies. The [source checkout instructions](README.md#working-from-a-source-checkout)
   cover setup. Send the pull request to the project's `master` branch.
2. For mathematics, check whether the result already exists in LeanInfoTheory
   or mathlib. Follow the [foundation conventions](docs/foundation-conventions.md):
   for example, entropy is in nats unless stated otherwise, and hypotheses about
   support matter when a symbol can have probability zero.
3. For a Lean change, build the affected module and add a small example that
   uses the result through its intended import. A good test makes a hypothesis
   matter: for instance, try a distribution with a zero-probability symbol
   when testing a support condition. Submit complete proofs without placeholders.
   For a documentation-only change, check the affected examples or links.
4. In the pull request, explain what changed, why it is useful, and what you
   checked. For a theorem adapted from a paper or book, identify the statement
   and note any difference in assumptions or units.

For a suggested topic, a proof review, or feedback from using the library in
another project, the [issue tracker](https://github.com/serhatemrecoban/LeanInfoTheory/issues)
is also the place to reach me.

Serhat Emre Coban, creator and maintainer · [Contributors and acknowledgments](README.md#contributors-and-acknowledgments)
