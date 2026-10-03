"""Behavioral regressions for current validation and doc-evidence lifecycle.

The warning-policy tests compile a small isolated Lake package. Compiler/doc-gen
execution is replaced only in the other orchestration tests below. Real growth
compilation is exercised separately by run_growth_fixtures.py.
"""

import copy
import io
import json
from pathlib import Path
import sys
import tempfile
import unittest
from contextlib import ExitStack, redirect_stderr, redirect_stdout
from unittest.mock import patch

import current_api
import validate_release as validator


class LakeWarningEnforcementTests(unittest.TestCase):
    def exercise_entry_point(self, entry_point):
        (validator.ROOT / "tmp").mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(prefix="warning-policy-", dir=validator.ROOT / "tmp") as directory:
            fixture = Path(directory)
            (fixture / "lean-toolchain").write_bytes((validator.ROOT / "lean-toolchain").read_bytes())
            (fixture / "lakefile.toml").write_text(
                'name = "warningfixture"\n'
                'defaultTargets = ["WarningFixture"]\n'
                '\n[[lean_lib]]\nname = "WarningFixture"\n',
                encoding="utf-8",
            )
            source = fixture / "WarningFixture.lean"
            source.write_text(
                "set_option linter.unusedVariables true\n\n"
                "def warningWitness (unused : Nat) : Nat := 0\n",
                encoding="utf-8",
            )
            run_command = validator.run_command

            def run_in_fixture(command, **kwargs):
                # Keep real process execution and error handling; redirect only
                # the package location and close stdin for the isolated build.
                result = run_command(
                    command, cwd=fixture, input_text="", capture_output=True, **kwargs
                )
                print(result.stdout, end="")
                print(result.stderr, end="", file=sys.stderr)
                return result

            def validate():
                stdout, stderr = io.StringIO(), io.StringIO()
                argv = ["validate_release.py", entry_point]
                if entry_point == "focused":
                    argv.append("WarningFixture")
                with patch.object(sys, "argv", argv), \
                     patch.object(validator, "MAINTAINED_TARGETS", ("WarningFixture",)), \
                     patch.object(validator, "run_command", side_effect=run_in_fixture), \
                     redirect_stdout(stdout), redirect_stderr(stderr):
                    status = validator.main()
                return status, stdout.getvalue() + stderr.getvalue()

            fresh_status, fresh_output = validate()
            self.assertEqual(fresh_status, 1, fresh_output)
            self.assertIn("warning: WarningFixture.lean", fresh_output)
            self.assertTrue((fixture / ".lake/build/lib/lean/WarningFixture.olean").is_file())

            replay_status, replay_output = validate()
            self.assertEqual(replay_status, 1, replay_output)
            self.assertIn("Replaying WarningFixture", replay_output)
            self.assertIn("warning: WarningFixture.lean", replay_output)

            source.write_text(source.read_text(encoding="utf-8").replace("(unused :", "(_unused :"),
                              encoding="utf-8")
            clean_status, clean_output = validate()
            self.assertEqual(clean_status, 0, clean_output)
            self.assertIn("Build completed successfully", clean_output)
            self.assertNotIn("warning:", clean_output)

    def test_maintained_build_rejects_fresh_and_replayed_warnings(self):
        self.exercise_entry_point("maintained-build")

    def test_focused_build_rejects_fresh_and_replayed_warnings(self):
        self.exercise_entry_point("focused")


class CurrentManifestTests(unittest.TestCase):
    def test_current_checkout_loads_exact_inventory_and_policy(self):
        manifest = current_api.load_current_manifest()
        self.assertEqual(manifest["schema"], "lean-info-theory.current-public-api.v1")
        self.assertEqual(manifest["declaration_count"], len(manifest["declarations"]))

    def test_stale_entry_and_duplicate_key_are_not_blessed_by_loading(self):
        raw = current_api.CURRENT_MANIFEST.read_bytes()
        missing = json.loads(raw)
        missing["declarations"].pop()
        (validator.ROOT / "tmp").mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(prefix="c903-validation-", dir=validator.ROOT / "tmp") as directory:
            path = Path(directory) / "current.json"
            with patch.object(current_api, "CURRENT_MANIFEST", path):
                for content in (json.dumps(missing).encode(), b'{"schema":1,"schema":2}'):
                    with self.subTest(content=content[:50]):
                        path.write_bytes(content)
                        with self.assertRaises(ValueError):
                            current_api.load_current_manifest()
                        self.assertEqual(path.read_bytes(), content)


class DocumentationLifecycleTests(unittest.TestCase):
    def setUp(self):
        (validator.ROOT / "tmp").mkdir(exist_ok=True)
        self.temporary = tempfile.TemporaryDirectory(prefix="c903-validation-", dir=validator.ROOT / "tmp")
        self.addCleanup(self.temporary.cleanup)
        self.output = Path(self.temporary.name) / "build"
        self.output.mkdir()
        self.stack = ExitStack()
        self.addCleanup(self.stack.close)
        for name, value in {
            "DOCBUILD_OUTPUT": self.output,
            "DOCBUILD_CONFIG_STAMP": self.output / "api-doc-build-config.json",
            "DOCBUILD_ATTESTATION": self.output / "api-doc-build-attestation.json",
        }.items():
            self.stack.enter_context(patch.object(validator, name, value))
        self.stack.enter_context(patch.object(validator, "check_docbuild_output_roots"))
        self.config = {
            "schema": "lean-info-theory.api-doc-build-config.v2",
            "source_mode": "file", "source_identity": "local",
            "docgen_revision": "a" * 40, "lean_revision": "b" * 40,
            "mathlib_revision": "c" * 40, "disable_equations": True,
            "api_identity": {"source_content_sha256": "d" * 64},
        }

    def seed(self):
        validator.write_api_doc_build_configuration(self.config)
        (self.output / "doc").mkdir()
        (self.output / "doc" / "preserved.html").write_text("cached")
        (self.output / "api-docs.db").write_text("database")
        validator.DOCBUILD_ATTESTATION.write_text("old evidence")

    def test_content_change_invalidates_evidence_and_keeps_incremental_cache(self):
        self.seed()
        changed = copy.deepcopy(self.config)
        changed["api_identity"]["source_content_sha256"] = "e" * 64
        validator.prepare_api_doc_build_configuration(changed)
        self.assertFalse(validator.DOCBUILD_ATTESTATION.exists())
        self.assertEqual((self.output / "doc/preserved.html").read_text(), "cached")
        self.assertEqual((self.output / "api-docs.db").read_text(), "database")
        self.assertEqual(json.loads(validator.DOCBUILD_CONFIG_STAMP.read_text()), changed)

    def test_link_mode_change_invalidates_mode_sensitive_output(self):
        self.seed()
        changed = dict(self.config, source_mode="github", source_identity="f" * 40)
        validator.prepare_api_doc_build_configuration(changed)
        self.assertFalse((self.output / "doc").exists())
        self.assertFalse((self.output / "api-docs.db").exists())
        self.assertFalse(validator.DOCBUILD_ATTESTATION.exists())

    def test_failed_rebuild_cannot_retain_success_attestation(self):
        self.seed()
        for name in ("check_docbuild_contract", "documentation_c_environment"):
            self.stack.enter_context(patch.object(validator, name, return_value={}))
        self.stack.enter_context(patch.object(validator, "repository_state_snapshot", return_value=("dirty", "same")))
        self.stack.enter_context(patch.object(validator, "api_doc_build_configuration", return_value=self.config))
        self.stack.enter_context(patch.object(validator, "run_command", side_effect=validator.ValidationError("build failed")))
        self.stack.enter_context(patch.dict(validator.os.environ, {"DOCGEN_SRC": "file"}))
        with self.assertRaisesRegex(validator.ValidationError, "build failed"):
            validator.run_api_docs()
        self.assertFalse(validator.DOCBUILD_ATTESTATION.exists())

    def test_source_change_during_two_pass_sequence_refuses_attestation(self):
        self.seed()
        changed = copy.deepcopy(self.config)
        changed["api_identity"]["source_content_sha256"] = "e" * 64
        for name in ("check_docbuild_contract", "documentation_c_environment", "run_command"):
            self.stack.enter_context(patch.object(validator, name, return_value={}))
        self.stack.enter_context(patch.object(validator, "repository_state_snapshot", return_value=("dirty", "same")))
        self.stack.enter_context(patch.object(validator, "api_doc_build_configuration", side_effect=[self.config, changed]))
        self.stack.enter_context(patch.object(validator, "api_doc_relevant_digest", return_value="f" * 64))
        self.stack.enter_context(patch.object(validator, "api_doc_tree_digest", return_value=("a" * 64, 1, 1, 5)))
        self.stack.enter_context(patch.dict(validator.os.environ, {"DOCGEN_SRC": "file"}))
        with self.assertRaisesRegex(validator.ValidationError, "source/configuration/dependencies changed"):
            validator.run_api_docs()
        self.assertFalse(validator.DOCBUILD_ATTESTATION.exists())


if __name__ == "__main__":
    unittest.main()
