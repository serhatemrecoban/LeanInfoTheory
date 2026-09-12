"""Non-mutating identity checks for the immutable v0.1.0 API inventory."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FROZEN_PATH = ROOT / "docs" / "v0.1-public-api.json"
RELEASE_COMMIT = "0bef5ef5124d7c33afc1aaed8d4f34a1c3a5ce8f"
RELEASE_TAG = "v0.1.0"
GIT_BLOB_SHA256 = "3201ced98b4516e9ef4bda166e75f667f47fe61e530d85af235b410894a7dd03"
INTAKE_CRLF_SHA256 = "d4c5bfa78588de605798f568b312a4cef2896855e36d3c983849270181e397be"


def verify_frozen_manifest(path: Path = FROZEN_PATH) -> dict[str, object]:
    """Accept exactly the Git blob or its recorded uniform CRLF representation.

    No file is normalized or rewritten. Arbitrary JSON-equivalent formatting,
    mixed line endings, and substantive changes are all rejected.
    """
    raw = path.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    if digest not in {GIT_BLOB_SHA256, INTAKE_CRLF_SHA256}:
        raise ValueError(
            f"frozen v0.1.0 manifest identity mismatch: {path} has SHA-256 {digest}; "
            "do not regenerate it from current source"
        )
    return json.loads(raw)


def baseline_identity() -> dict[str, str]:
    return {
        "release_commit": RELEASE_COMMIT,
        "release_tag": RELEASE_TAG,
        "manifest_path": "docs/v0.1-public-api.json",
        "git_blob_sha256": GIT_BLOB_SHA256,
    }
