#!/usr/bin/env python3
"""Verify the immutable v0.1.0 public API manifest without writing it.

Both ordinary and --check invocations only verify the exact historical bytes.
Generate current inventory with scripts/generate_current_public_api.py instead.
"""

from __future__ import annotations

import argparse
import sys

from frozen_public_api import FROZEN_PATH, verify_frozen_manifest


OUTPUT = FROZEN_PATH


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--check", action="store_true",
        help="verify historical identity (ordinary invocation also only verifies)",
    )
    parser.parse_args(argv)
    try:
        verify_frozen_manifest(OUTPUT)
    except (OSError, ValueError) as exc:
        print(f"historical public API verification failed: {exc}", file=sys.stderr)
        return 1
    print("immutable v0.1.0 public API manifest identity verified; no files written")
    return 0


if __name__ == "__main__":
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    raise SystemExit(main())
