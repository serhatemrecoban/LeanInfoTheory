"""LeanInfoTheory review instructions, included in every generated request."""

LIBRARY_RUBRIC = [
    'Check mathematical meaning and proof integrity, not just compilation; separate severity from confidence and optional advice from material concerns.',
    'Search existing LeanInfoTheory and pinned mathlib before duplicating declarations. Read exact relevant sections from docs/references.md; do not import PFR manuscript scope.',
    'Assess useful generality and explicit support, null-fiber, empty/singleton, finite/infinite KL assumptions. Preserve nats and guarded Real conversions.',
    'Check namespace/module ownership, focused imports, lightweight root and probability constructors below heavier Shannon semantics.',
    'Compare names, argument order and useful theorem forms with nearby released APIs. Record real discovery friction; no unrelated renaming migration.',
    'Keep one-off helpers private; justify public helpers and simp attributes by real proof or consumer need, not wrapper or abstraction quotas.',
    'Check retained public contracts and import compatibility. Keep certificate and paper-specific semantics downstream; do not modify PFR or ShannonCert.',
    'Exercise permanent consumers/examples of actual producer-consumer interfaces, not only isolated declaration compilation.',
    'Check owning documentation, future-work dispositions and applicable generated references. At closeout check cumulative criteria and maintained handoff prepared before F.',
    'Refresh relevant source and prior findings on every request. Plan review checks feasibility and contracts, not nonexistent implementation; it does not approve the plan.',
]

VALIDATION_GUIDANCE = {
    'entry_point': 'scripts/validate_release.py',
    'step': ['python scripts/validate_release.py focused <affected-targets>', 'python scripts/validate_release.py static'],
    'documentation': 'python scripts/validate_release.py documentation',
    'chunk': 'Approved cumulative focused/maintained-build/trust/documentation checks and independent consumers; record actual command/output and limitations.',
    'clean_checkpoint': 'python scripts/validate_release.py requires a clean committed tree; report pending authorization, never weaken the gate or commit user work to pass it.',
    'api_docs': 'python scripts/validate_release.py api-docs only at a justified API-documentation/release milestone, with AGENTS.md toolchain requirements.',
    'publication': 'Separate explicit authority required; no workflow operation publishes.',
    'growth_boundary': 'C9 owns future growth-ready compatibility/current-surface gates. This workflow uses the current validator, changes no frozen baseline/counts and does not certify growth readiness.',
}
