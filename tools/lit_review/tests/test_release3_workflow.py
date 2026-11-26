"""Release 3 adapter qualification on temporary Git checkouts and synthetic records."""
import json
import os
import unittest
from unittest.mock import patch

import test_project_workflow as helpers


project = helpers.project
LEGACY_MAP = "docs/plans/post-release-chunk-map.md"
RELEASE3_MAP = "docs/plans/release-3-chunk-map.md"


class Release3WorkflowTests(unittest.TestCase):
    def setUp(self):
        transport = helpers.CollaborationTransportTests(methodName="runTest")
        self.addCleanup(transport.doCleanups)
        transport.setUp()
        self.f = transport.f
        self.f.put(RELEASE3_MAP, "# Release 3 fixture map\nProgramme guidance only.\n")

    def select_chunk(self, chunk):
        f = self.f
        f.chunk = chunk
        f.plan_path = f"docs/plans/{chunk.lower()}-source-copy-test.md"
        f.reviewer = f"/root/{chunk.lower()}_reviewer"
        f.claim1 = f"Inspect the exact {chunk}.01 fixture source."
        f.claim2 = f"Complete cumulative review and prepare the {chunk} fixture handoff."
        f.write_plan()

    def assert_rendered_request(self, req, kind, programme_map):
        f = self.f
        # This is the text delivered to a reviewer. The source inventory may
        # legitimately include both tracked maps; the reading list selects one.
        header, body = req["text"].split("\n\n", 1)
        self.assertIn("SOURCE REVIEW", header)
        rendered = json.loads(body)
        self.assertEqual(rendered, req["payload"])
        self.assertEqual(rendered["kind"], kind)
        maps = [p for p in rendered["context_documents"] if p in (LEGACY_MAP, RELEASE3_MAP)]
        self.assertEqual(maps, [programme_map])
        if programme_map == RELEASE3_MAP:
            self.assertIn(f.plan_path, rendered["context_documents"])
            self.assertTrue(any("source_reference" in rule and "normative_excerpt" in rule
                                and "chunk plan" in rule for rule in rendered["review_rules"]))
            guidance = rendered["validation_guidance"]
            self.assertEqual(guidance["entry_point"], "scripts/validate_development.py")
            self.assertEqual(guidance["step"], ["python scripts/validate_release.py focused <affected-targets>",
                                               "python scripts/validate_development.py static"])
            self.assertIn("python scripts/validate_development.py ", guidance["clean_checkpoint"])
            self.assertIn("both released baselines", guidance["growth_boundary"])
        else:
            self.assertEqual(rendered["context_documents"],
                             ["AGENTS.md", "docs/review-protocol.md", "docs/references.md", LEGACY_MAP])
            self.assertEqual(rendered["validation_guidance"], project.VALIDATION_GUIDANCE)
        self.assertEqual(rendered["target_id"], f.w.plan_id if kind == "PLAN" else f.chunk + ".01")
        self.assertEqual(rendered["binding"]["chunk"], f.chunk)
        self.assertEqual(rendered["binding"]["reviewer"], f.reviewer)
        self.assertEqual(rendered["binding"]["checkout"], str(f.root))
        self.assertEqual(rendered["requirements"], [f.criterion()])
        source = f.w.store.get(rendered["source_ref"], "manifest")
        for path in (programme_map, f.plan_path, "Case.lean"):
            raw = (f.root / path).read_bytes()
            self.assertEqual(rendered["source_inventory"][path]["sha256"], helpers.digest(raw))
            self.assertEqual(bytes.fromhex(source["source_bytes"][path]), raw)

    def test_source_bound_plan_and_step_text_at_programme_boundaries(self):
        f = self.f
        for chunk, programme_map in (("C24", LEGACY_MAP), ("C25", RELEASE3_MAP), ("C40", RELEASE3_MAP)):
            with self.subTest(chunk=chunk):
                self.select_chunk(chunk)
                f.write_plan("Proposed")
                f.session("PLAN")
                req = f.w.plan_review_request(f"lit-review:{chunk}:plan-fixture:routing")
                self.assert_rendered_request(req, "PLAN", programme_map)
                self.assertFalse(req["normal_step_authorized"])
                self.assertIsNone(f.state()["active"])
                # Select the approved STEP contract separately, with its own
                # exact bytes and criterion, to catch leakage from PLAN.
                f.claim1 += " Retain the approved step evidence."
                f.write_plan()
                f.open_bound_session("STEP")
                _, req = f.prepared("routing")
                self.assert_rendered_request(req, "STEP", programme_map)

    def test_programme_maps_cannot_supply_a_release3_session_contract(self):
        f = self.f
        self.select_chunk("C25")
        f.install_bind()
        for path in (LEGACY_MAP, RELEASE3_MAP):
            f.plan_path = path
            # Give the map every excerpt and even the status an exact STEP
            # contract would need. Only the document's role should reject it.
            f.write_plan()
            for kind, session in (("PLAN", "plan-fixture"), ("STEP", "execution")):
                with self.subTest(path=path, kind=kind):
                    with self.assertRaisesRegex(helpers.Refusal, "CHUNK_SPECIFIC_PLAN_REQUIRED"):
                        f.open_bound_session(kind)
                    self.assertFalse((f.root / ".lit-review/chunks/C25" / session).exists())

    def test_missing_programme_source_refuses_plan_request(self):
        f = self.f
        self.select_chunk("C25")
        (f.root / RELEASE3_MAP).unlink()
        f.write_plan("Proposed")
        f.session("PLAN")
        state = f.state()
        with self.assertRaisesRegex(helpers.Refusal, "REVIEW_CONTEXT_SOURCE_MISSING"):
            f.w.plan_review_request("lit-review:C25:plan-fixture:missing-map")
        self.assertEqual(f.state(), state)

    def test_new_chunk_closes_only_requested_step_and_preserves_historical_records(self):
        f = self.f
        # Establish both plan files before the historical source capture.
        self.select_chunk("C25")
        self.select_chunk("C24")
        f.session("PLAN")
        old_req = f.w.plan_review_request("lit-review:C24:plan-fixture:historical")
        chunk_dir = f.w.fs.root.parent

        def historical_bytes():
            return {p.relative_to(chunk_dir): p.read_bytes() for p in chunk_dir.rglob("*") if p.is_file()}

        before = historical_bytes()
        self.select_chunk("C25")
        f.session()
        skipped = f.named_next("unfinished-predecessor", "C25.02", "C25.01")
        self.assertEqual(skipped["status"], "SKIPPED_NAMED_TARGET")
        self.assertEqual(skipped["reason"], "NAMED_STEP_NOT_NEXT")
        self.assertTrue(skipped["consumed"])
        self.assertIsNone(f.state()["active"])
        self.assertFalse(f.state()["completed"])
        self.assertEqual(f.named_next("only-first", "C25.01")["status"], "ACCEPTED")
        result = f.complete_acknowledged("only-first", start=False)
        self.assertEqual(result["status"], "SUPERVISED_STEP_COMPLETE")
        self.assertFalse(result["production_acceptance"])
        self.assertFalse(result["next_step_started"])
        f.w = project.load_session(f.root, "C25", "execution", test=True)
        with self.assertRaisesRegex(helpers.Refusal, "WRONG_NAMED_PREDECESSOR"):
            f.named_next("wrong-predecessor", "C25.02", "C24.01")
        self.assertEqual(f.state()["completed"], {"C25.01": result["closure"]})
        self.assertIsNone(f.state()["active"])
        self.assertFalse((f.root / ".lit-review/chunks/C26").exists())
        historical = project.load_session(f.root, "C24", "plan-fixture", test=True)
        self.assertEqual(historical.store.get(old_req["reference"])["text"], old_req["text"])
        self.assertEqual(historical_bytes(), before)

    def test_refused_chunk_and_storage_paths_create_no_records(self):
        f = self.f
        project.setup(f.root, f.user(), test=True)
        for chunk in ("C8", "C41", "C025", "C25/../C24"):
            with self.subTest(chunk=chunk), self.assertRaisesRegex(helpers.Refusal, "CHUNK_BINDING"):
                project.bind(f.root, chunk, f.parent, f.reviewer, f.creation(), f.user(), test=True)
        for path in ("chunks/C09", "chunks/C8", "chunks/C41/execution", "chunks/C025/plan-fixture",
                     "chunks/C25/../C24", "chunks/C40/other"):
            with self.subTest(path=path), self.assertRaisesRegex(helpers.Refusal, "PRIVATE_RECORD_LOCATION"):
                project.ProjectRecordFS(f.root, path, create=True, test=True)
        self.assertFalse((f.root / ".lit-review/chunks").exists())

    def prepare_c40_succession(self):
        f = self.f
        self.select_chunk("C40")
        planning = f.session("PLAN")
        planning.plan_review_request("lit-review:C40:plan-fixture:planning")
        self.c40_planning_parent = f.parent
        original_root = planning.fs.root.parent
        old_bytes = {p: p.read_bytes() for p in original_root.rglob("*") if p.is_file()}
        predecessor = helpers.digest(old_bytes[original_root / "binding.json"])
        f.parent = "synthetic-c40-successor-parent"
        f.reviewer = "/root/c40_successor"
        pins = patch.multiple(project, C40_PLANNING_PARENT_SHA256=project.digest(self.c40_planning_parent),
                              C40_EXECUTION_PARENT_SHA256=project.digest(f.parent),
                              C40_PLANNING_BINDING_SHA256=predecessor)
        pins.start()
        self.addCleanup(pins.stop)
        env = patch.dict(os.environ, {"CODEX_THREAD_ID": f.parent})
        env.start()
        self.addCleanup(env.stop)
        packet = dict(chunk="C40", parent=f.parent, reviewer=f.reviewer, creation=f.creation(),
                      approval=f.user(scope="C40_EXECUTION_PARENT_SUCCESSION"), predecessor_sha256=predecessor)
        return original_root, old_bytes, packet

    def test_c40_successor_execution_preserves_the_original_plan_binding(self):
        f = self.f
        root, old_bytes, packet = self.prepare_c40_succession()
        with self.assertRaisesRegex(helpers.Refusal, "C40_EXECUTION_SUCCESSOR_REQUIRED"):
            f.open_bound_session("STEP")
        successor = project.bind_c40_successor(f.root, **packet, test=True)
        with self.assertRaisesRegex(helpers.Refusal, "ALREADY_EXISTS"):
            project.bind_c40_successor(f.root, **packet, test=True)
        with self.assertRaisesRegex(helpers.Refusal, "WRONG_ORIGINATING_PARENT"):
            project.load_session(f.root, "C40", "plan-fixture", test=True)
        with patch.dict(os.environ, {"CODEX_THREAD_ID": self.c40_planning_parent}):
            plan = project.load_session(f.root, "C40", "plan-fixture", test=True)
            self.assertEqual(plan.inspect()["state"]["settings"]["profile"]["canonical_reviewer"],
                             "/root/c40_reviewer")
            with self.assertRaisesRegex(helpers.Refusal, "WRONG_ORIGINATING_PARENT"):
                f.open_bound_session("STEP")
        f.open_bound_session("STEP")
        self.assertEqual(f.w.config["binding"], successor)
        self.assertIsNone(f.state()["active"])
        f.w = project.load_session(f.root, "C40", "execution", test=True)
        self.assertEqual(f.named_next("step-one", "C40.01")["status"], "ACCEPTED")
        _, req = f.prepared("step-one", start=False)
        self.assertEqual(req["payload"]["binding"]["reviewer"], f.reviewer)
        self.assertTrue(all(path.read_bytes() == raw for path, raw in old_bytes.items()))
        with self.assertRaisesRegex(helpers.Refusal, "C40_EXECUTION_ALREADY_EXISTS"):
            project.bind_c40_successor(f.root, **packet, test=True)
        binding = root / "binding.json"
        binding.write_bytes(old_bytes[binding] + b"\n")
        with self.assertRaisesRegex(helpers.Refusal, "C40_SUCCESSOR_PREDECESSOR"):
            f.w.inspect()

    def test_c40_succession_rejects_other_identities_and_incomplete_authority(self):
        f = self.f
        root, old_bytes, packet = self.prepare_c40_succession()
        for overrides, reason in (
            ({"chunk": "C39"}, "C40_SUCCESSOR_IDENTITY"),
            ({"parent": self.c40_planning_parent}, "C40_SUCCESSOR_IDENTITY"),
            ({"predecessor_sha256": "0" * 64}, "C40_SUCCESSOR_PREDECESSOR"),
            ({"approval": f.user()}, "C40_SUCCESSOR_APPROVAL"),
            ({"creation": {**packet["creation"], "original_result": {"task_name": "/root/other"}}},
             "CREATION_IDENTITY_MISMATCH"),
        ):
            with self.subTest(reason=reason), self.assertRaisesRegex(helpers.Refusal, reason):
                project.bind_c40_successor(f.root, **{**packet, **overrides}, test=True)
        f.reviewer = "/root/c40_reviewer"
        with self.assertRaisesRegex(helpers.Refusal, "C40_SUCCESSOR_REVIEWER"):
            project.bind_c40_successor(f.root, **{**packet, "reviewer": f.reviewer, "creation": f.creation()},
                                       test=True)
        with patch.dict(os.environ, {"CODEX_THREAD_ID": self.c40_planning_parent}):
            with self.assertRaisesRegex(helpers.Refusal, "WRONG_ORIGINATING_PARENT"):
                project.bind_c40_successor(f.root, **packet, test=True)
        (root / "execution").mkdir()
        with self.assertRaisesRegex(helpers.Refusal, "C40_EXECUTION_ALREADY_EXISTS"):
            project.bind_c40_successor(f.root, **packet, test=True)
        self.assertFalse((root / project.C40_SUCCESSOR_FILE).exists())
        self.assertTrue(all(path.read_bytes() == raw for path, raw in old_bytes.items()))
