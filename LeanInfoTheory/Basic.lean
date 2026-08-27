/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

/-!
# LeanInfoTheory

This development-anchor module contains project metadata and roadmap
vocabulary. It is not part of the stable mathematical API and is deliberately
not imported by `LeanInfoTheory` or `LeanInfoTheory.Shannon`.
-/

namespace LeanInfoTheory

/-- Public project name used by documentation and the website. -/
def projectName : String := "LeanInfoTheory"

/-- A small status vocabulary for roadmap items and generated documentation. -/
inductive Status where
  /-- The item exists as a scaffold or placeholder, but substantial work remains. -/
  | scaffolded
  /-- The item is actively being developed. -/
  | inProgress
  /-- The item is planned but has not been started. -/
  | planned
  /-- The item may eventually be suitable for upstreaming to mathlib. -/
  | upstreamCandidate
  deriving DecidableEq, Repr

end LeanInfoTheory
