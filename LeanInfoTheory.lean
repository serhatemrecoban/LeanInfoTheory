import LeanInfoTheory.Basic
import LeanInfoTheory.Probability.Finite
import LeanInfoTheory.InformationMeasures
import LeanInfoTheory.EntropyExpr
import LeanInfoTheory.EntropyVal
import LeanInfoTheory.PrimitiveIneq
import LeanInfoTheory.Certificate
import LeanInfoTheory.Certificate.Checked

/-!
# LeanInfoTheory root import

This root module gathers the lightweight project API that should be convenient
for users to import. It includes the finite information-measure re-export and
the core certificate/checker definitions, but not demo files, heavier theorem
files, bridge files, or reference modules.

Import these separately when needed:

- `LeanInfoTheory.Shannon.EntropyBounds` for Jensen-based finite entropy
  bounds;
- `LeanInfoTheory.Shannon.SemanticBridge` for KL/conditional-law bridge work;
- `LeanInfoTheory.MathlibFragments` for heavier mathlib information-theory and
  coding anchors;
- `LeanInfoTheory.Certificate.Submodularity` and `LeanInfoTheory.Examples` for
  demonstration files.
-/
