/-
Copyright (c) 2026 Serhat Emre Coban. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Serhat Emre Coban
-/

/-!
# LeanInfoTheory

This lightweight file contains project-wide names that should be cheap to
import. Heavier mathlib information-theory anchors are recorded in
`LeanInfoTheory.MathlibFragments`.
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
