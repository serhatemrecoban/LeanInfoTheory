#!/usr/bin/env python3
"""Run the development CI gates while retaining the v0.1.0 and v0.2.0 APIs."""

from __future__ import annotations

import argparse
import subprocess
import sys

import validate_published as published
import validate_release as release
import release3_state as r3


# Only the build workflow differs from the reviewed published-maintenance route.
DEVELOPMENT_CI_SHA256 = "b3907b8b8b01600147e8fbc2e6fd03cf1a23b5567c1b6a71bd57b7a57c4c5188"


def check_static() -> None:
    # Required even during preparation: removing the policy cannot fall back to v0.2.
    state = r3.check_metadata(release.ROOT)
    if "retained_api" in state:
        from compatibility import candidate_contract
        candidate_contract.load_release3_snapshot(release.ROOT)
    published.check_static(ci_sha256=DEVELOPMENT_CI_SHA256)
    release.run_command((sys.executable, "scripts/test_release3_state.py"))
    release.run_command((sys.executable, "scripts/compatibility/test_candidate_contract.py"))
    release.run_command((sys.executable, "scripts/test_release3_promotion.py"))
    release.run_command((sys.executable, "scripts/test_release3_links.py"))
    release.run_command((sys.executable, "scripts/test_release_pages.py"))
    release.run_command((sys.executable, "tests/external-consumer/test_run.py"))


def check_compiled() -> None:
    """Run the CI stages following the default warning-as-error Lake build."""
    release.run_maintained_build()
    release.check_release_documentation_contract()
    release.check_documentation_examples()
    release.check_trust_contract(development=True)
    release.check_hygiene(require_clean=True)
    state = r3.load_state(release.ROOT)
    if state["phase"] != "preparation":
        from reproduce_release3_checkpoint import verify
        ref = "HEAD"
        if state["phase"] == "published-maintenance" or (release.ROOT / published.PROMOTION_PINS).exists():
            ref = f"refs/tags/{r3.TAG}^{{commit}}"
            subprocess.run(["git", "merge-base", "--is-ancestor", ref, "HEAD"], cwd=release.ROOT, check=True)
        sha = subprocess.check_output(["git", "rev-parse", ref], cwd=release.ROOT).decode().strip()
        print("Reproduced the clean 918-declaration capture from the containing Git tree:",
              verify(release.ROOT, sha), flush=True)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", nargs="?", default="all",
                        choices=("all", "static", "compiled", "trust", "compatibility"))
    command = parser.parse_args().command
    if command == "compatibility":
        release.run_command((sys.executable, "scripts/check_development_api_compatibility.py"))
    elif command == "trust":
        release.check_trust_contract(development=True)
    elif command == "static":
        check_static()
    elif command == "compiled":
        check_compiled()
    else:
        release.check_clean_repository_state("before the complete development suite")
        check_static()
        release.run_command(("lake", "--wfail", "build"))
        check_compiled()
    return 0


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    try:
        raise SystemExit(main())
    except (OSError, ValueError, release.ValidationError) as error:
        print(f"development validation failed: {error}", file=sys.stderr)
        raise SystemExit(1)
