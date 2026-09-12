"""Load exact current inventory and independently reviewed source policy.

The generated file describes source, never approval. Comparing its entire byte
representation with a fresh generation validates the schema and all coverage,
including derived totals, duplicate-free records and documentation presence.
Compiled truth, retained types and trust remain separate maintained checks.
"""

from __future__ import annotations

from pathlib import Path

import check_public_api_compatibility as compatibility
import generate_current_public_api as generator

ROOT = Path(__file__).resolve().parents[1]
CURRENT_MANIFEST = ROOT / "docs/current-public-api.json"


def load_current_manifest() -> dict:
    raw = CURRENT_MANIFEST.read_bytes()
    current = compatibility.strict_json(raw)
    expected = generator.rendered_manifest().encode("utf-8")
    if raw != expected:
        raise ValueError(
            "current public API manifest is stale or invalid; run "
            "python scripts/generate_current_public_api.py"
        )
    frozen, retained = compatibility.load_baseline()
    compatibility.current_policy.validate_source_policy(
        frozen, retained, current, compatibility.direct_source_imports(),
        compatibility.strict_json(compatibility.POLICY.read_bytes()),
    )
    return current
