"""REPLAYED source-copy integration checks; no models, native tools or Lean runs.

All user/reviewer inputs below are explicitly synthetic fixture records. The
same installed adapter is exercised with TEST_TAG, never production acceptance.

Adapted from PFR-C02 for LeanInfoTheory, 2026-09-11; see ../PROVENANCE.md.
Additional cases are local installation regressions.
"""
import ast
import copy
from dataclasses import asdict
import inspect
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import textwrap
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).absolute().parents[1]))
import project
from safe_store import FixtureFS, Refusal, digest


class AdapterParityTests(unittest.TestCase):
    def test_delivery_override_preserves_all_non_envelope_core_logic(self):
        original = ast.parse(textwrap.dedent(inspect.getsource(project.DiagnosticWorkflow.confirm_delivery)))
        adapted = ast.parse(textwrap.dedent(inspect.getsource(project.ProjectWorkflow.confirm_delivery)))
        legacy = ast.parse(textwrap.dedent('''\
            event=strict_json(observation["original_event"])
            require(isinstance(event,dict) and event.get("Message Type")=="FINAL_ANSWER"
                    and event.get("Sender")==self.identity.reviewer
                    and profile.get("parent_role") and event.get("Task name")==profile["parent_role"]
                    and event.get("Payload")==original_text,"DELIVERY_OBSERVED_ENVELOPE")
        ''')).body
        method = original.body[0]
        for obsolete in legacy:
            matches = [index for index, node in enumerate(method.body)
                       if ast.dump(node) == ast.dump(obsolete)]
            self.assertEqual(len(matches), 1, "Inherited delivery envelope changed; review adaptation explicitly.")
            del method.body[matches[0]]
        self.assertEqual(ast.dump(original), ast.dump(adapted))


class ProjectWorkflowTests(unittest.TestCase):
    chunk = "C10"
    parent = "source-copy-test-parent"
    reviewer = "synthetic-source-copy-reviewer"
    plan_path = "docs/plans/c10-source-copy-test.md"
    claim1 = "Fixture step one must preserve the declared source-copy contract."
    claim2 = ("Fixture step two must preserve the source-copy contract after step one, "
              "complete cumulative review, reconcile canonical context, and prepare a maintained handoff before final capture.")

    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="lit-workflow-test-")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        env = patch.dict(os.environ, {"CODEX_THREAD_ID": self.parent})
        env.start(); self.addCleanup(env.stop)
        self.n = 0
        self.git("init", "-q")
        self.git("config", "user.name", "Source-copy fixture")
        self.git("config", "user.email", "fixture@example.invalid")
        self.put(".gitignore", ".lit-review/\ntmp/\n.lake/\n__pycache__/\n")
        self.put("lean-toolchain", "leanprover/lean4:v4.33.1\n")
        self.put("lakefile.toml", 'name = "LeanInfoTheory"\n')
        self.put("lake-manifest.json", json.dumps({"packagesDir": ".lake/packages", "packages": []}))
        self.put("Case.lean", "-- Source-copy fixture; no production theorem or compiler claim.\n")
        self.put(self.plan_path, "# Source-copy fixture plan\n\n**Status:** Approved\n\n"
                 "## C10.01\n" + self.claim1 + "\n\n## C10.02\n" + self.claim2 + "\n")
        self.put("AGENTS.md", "# Synthetic library rules\nUse the maintained library rubric.\n")
        self.put("docs/review-protocol.md", "# Synthetic library review rules\n" +
                 "\n".join(project.LIBRARY_RUBRIC) + "\n")
        self.put("docs/references.md", "# Fixture reference register\nNo textbook or native model input.\n")
        self.put("docs/plans/post-release-chunk-map.md", "# Fixture map\n**Status:** Proposed\n")
        self.git("add", "."); self.git("commit", "-qm", "Source-copy fixture baseline")
        self.head = self.git("rev-parse", "HEAD").decode().strip()

    def put(self, rel, text):
        path = self.root / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8", newline="")

    def git(self, *args):
        return subprocess.check_output(["git", "-C", str(self.root), *args], stderr=subprocess.STDOUT)

    def user(self, **fields):
        self.n += 1
        return {"role": "user", "reference": f"synthetic-source-copy:user-{self.n}",
                "original_text": "Synthetic fixture instruction, not actual project authorization.", **fields}

    def install_bind(self):
        self.installation = project.setup(self.root, self.user(), test=True)
        return project.bind(self.root, self.chunk, self.parent, self.reviewer, self.creation(), self.user(), test=True)

    def creation(self):
        return {"canonical_reviewer": self.reviewer, "requested": copy.deepcopy(project.PROFILE),
                    "original_result": {"agent_id": self.reviewer, "fixture_note": "Synthetic creation; no native call."},
                    "reference": "synthetic-source-copy:creation", "parent_role": "CHUNK_IMPLEMENTATION",
                    "parent_purpose": "CHUNK_IMPLEMENTATION"}

    def criterion(self, step=1):
        return {"id": f"C10.0{step}-C1", "description": f"Source-copy fixture step {step}",
                "source_reference": self.plan_path + f"#c100{step}",
                "normative_excerpt": self.claim1 if step == 1 else self.claim2,
                "scope": "Case.lean exact source-copy fixture bytes",
                "required_evidence": "Inspect exact fixture bytes; no mathematical certification."}

    def contract(self, kind="STEP"):
        return {"plan_path": self.plan_path, "plan_sha256": digest((self.root / self.plan_path).read_bytes()),
                "kind": kind, "scope": ["Case.lean"], "normative_anchors": [self.claim1, self.claim2],
                "steps": [{"id": f"C10.0{i}", "criteria": [self.criterion(i)]} for i in (1, 2)] if kind == "STEP" else [],
                "plan_criteria": [self.criterion()] if kind == "PLAN" else []}

    def session(self, kind="STEP"):
        self.install_bind()
        contract = self.contract(kind)
        self.w = project.open_session(self.root, self.chunk, "execution" if kind == "STEP" else "plan-fixture",
            contract, self.user(scope="APPROVED_IMPLEMENTATION_PLAN" if kind == "STEP" else "PLAN_REVIEW",
                                plan_sha256=contract["plan_sha256"]), test=True)
        return self.w

    def state(self):
        return self.w.inspect()["state"]

    def auth(self, action, target):
        return self.w.authority(action, target, "lit-auth:" + str(self.n + 1), self.user())

    def next(self, identifier="next-1"):
        return self.w.process_next("lit-message:" + identifier, "Synthetic next one eligible step with review",
                                   self.auth("NEXT_STEP", self.w.plan_id))

    def named_next(self, identifier, target="C10.01", predecessor=None):
        return self.w.process_named_next("lit-message:" + identifier,
            "Synthetic already-resolved named-step request; not an English parser.",
            self.auth("NEXT_STEP", self.w.plan_id), target, predecessor)

    def ev(self):
        return self.w.parent_evidence("Fixture-only source inspection", "Synthetic PASS; no model or Lean run.",
                                      "REPLAYED source-copy test data, not actual mathematical evidence.")

    def prepared(self, identifier="first", start=True):
        if start:
            self.assertEqual(self.next(identifier)["status"], "ACCEPTED")
        ev = self.ev()
        self.w.initial_validation([ev]); self.w.self_review([], "Synthetic contextual review.")
        self.w.reassess({})
        req = self.w.prepare_review(f"lit-review:{self.chunk}:execution:{identifier}", [ev])
        return ev, req

    def observation(self, req, raw=None, **extra):
        result = {"input_mode": "REPLAYED", "origin": "SYNTHETIC_EVENT", "parent": self.parent,
                  "reviewer": self.reviewer, "event_ref": f"synthetic-source-copy:event-{self.n}",
                  "original_event": "Synthetic fixture event; not an actual tool response.",
                  "replay_of": "Authored source-copy fixture sample, no historical native claim.",
                  "request_ref": req["reference"]}
        if raw is not None:
            result.update(event_kind="FULL_REPORT", complete=True, text_role="ORIGINAL_NOT_SUMMARY", extracted_text=raw,
                          original_event=json.dumps({"status": {self.reviewer: {"completed": raw}}}),
                          tool_call={"name": "multi_agent_v1.wait_agent",
                                     "arguments": {"targets": [self.reviewer]}})
        result.update(extra)
        return result

    def report(self, req, status="SATISFIED", finding=False):
        p = req["payload"]
        findings = [{"id": "lit-finding:source-copy-extra-premise", "label": "Fixture material concern", "material": True,
                     "claim": "Synthetic unresolved source-copy contract concern.", "severity": "HIGH", "confidence": "HIGH"}] if finding else []
        return json.dumps({"report": {"schema": 1, "tag": project.TEST_TAG,
            "request_id": p["request_id"], "attempt": p["attempt"], "source_ref": p["source_ref"], "kind": p["kind"],
            "binding_digest": digest(asdict(self.w.identity)), "scope": "Source-copy fixture only",
            "findings": findings, "criteria": [{"id": c["id"], "status": status, "evidence": ["reviewer:fixture-check"]}
                                                 for c in p["requirements"]],
            "verification": ["reviewer:fixture-check"], "earlier_reconciliation": "Exact fixture prose.\nPreserve whitespace. ",
            "conclusion": "Fixture report data, never approval."},
            "new_evidence": [{"id": "reviewer:fixture-check", "actor": self.reviewer, "method": "Fixture source inspection",
            "source_ref": p["source_ref"], "inspected_source": "Case.lean and exact fixture contract",
            "command": None, "output": "Synthetic fixture observation; no actual model or compiler execution.",
            "outcome": "PASS" if status == "SATISFIED" else "FAIL", "limitations": "Authored REPLAYED test data."}]})

    def deliver(self, req, raw):
        self.w.dispatch_intent(req["reference"])
        receipt = self.w.record_submission(req["reference"], "UNCERTAIN", self.empty_submission(req))
        original = self.w.fs.read("durable/objects/" + receipt + ".json")
        confirmed = self.w.confirm_delivery(req["reference"], receipt, raw, self.observation(req, raw),
                                            self.auth("CONFIRM_DIAGNOSTIC_DELIVERY", req["reference"]))
        self.assertFalse(confirmed["report_accepted"])
        self.assertEqual(original, self.w.fs.read("durable/objects/" + receipt + ".json"))
        result = self.w.receive_report(raw, self.observation(req, raw), req["payload"]["request_id"], req["payload"]["attempt"])
        self.assertEqual(result["classification"], "VALID")
        return result

    def empty_submission(self, req):
        return self.observation(req, original_event=json.dumps(""),
            tool_call={"name": "multi_agent_v1.send_input", "arguments": {
                "id": self.reviewer, "message": req["text"]}})

    def acknowledged_submission(self, req):
        self.w.dispatch_intent(req["reference"])
        return self.w.record_submission(req["reference"], "ACKNOWLEDGED", self.observation(req,
            original_event=json.dumps({"submission_id": "synthetic-acknowledgement"}),
            tool_call={"name": "multi_agent_v1.send_input", "arguments": {
                "id": self.reviewer, "message": req["text"]}}))

    def acknowledged_report(self, req, raw=None):
        raw = self.report(req) if raw is None else raw
        self.acknowledged_submission(req)
        result = self.w.receive_report(raw, self.observation(req, raw),
                                       req["payload"]["request_id"], req["payload"]["attempt"])
        self.assertEqual(result["classification"], "VALID")
        return result

    def complete_acknowledged(self, identifier="complete", start=True):
        ev, req = self.prepared(identifier, start=start)
        self.acknowledged_report(req)
        self.w.reconcile_report()
        self.final_ready(ev)
        return self.w.project_closure()

    def final_ready(self, ev):
        self.w.finish_corrections()
        for criterion in self.w._criteria(self.state()):
            self.w.assess(criterion["id"], "SATISFIED", [ev], "Synthetic fixture final assessment.")
        self.w.finalize_documents("No fixture documentation changed; inspected owning source-copy files.")
        self.w.prepare_final([ev], impact="NO_SEMANTIC_CHANGE", rationale="Identical scoped fixture source.")

    def test_setup_is_not_execution_and_fixture_store_rejected(self):
        binding = self.install_bind()
        self.assertEqual(self.installation["tag"], project.TEST_TAG)
        self.assertFalse(self.installation["mathematical_execution_authorized"])
        self.assertEqual(binding["input_mode"], "REPLAYED")
        fs = project.ProjectRecordFS(self.root, "chunks/" + self.chunk, test=True)
        with self.assertRaises(Refusal): FixtureFS(fs.root)
        with self.assertRaises(Refusal): project.ProjectRecordFS(self.root, "chunks/" + self.chunk, test=False)
        with self.assertRaises(Refusal): fs.cleanup_scratch()
        self.assertFalse((fs.root / "execution").exists())

    def test_production_setup_and_test_records_cannot_share_identity(self):
        installation = project.setup(self.root, self.user())
        self.assertEqual(installation["tag"], "LIT_SUPERVISED_REVIEW_V1")
        self.assertFalse(installation["mathematical_execution_authorized"])
        self.assertFalse(installation["historical_baseline"]["recognized_historical_baseline"])
        fs = project.ProjectRecordFS(self.root, "setup", create=True)
        with self.assertRaisesRegex(Refusal, "PRIVATE_STORE_BINDING"):
            project.ProjectRecordFS(self.root, "setup", test=True)
        with self.assertRaisesRegex(Refusal, "INSTALLATION_CONFLICT"):
            project.setup(self.root, self.user(), test=True)
        with self.assertRaises(Refusal):
            FixtureFS(fs.root)
        with self.assertRaisesRegex(Refusal, "INSTALLER_BINDING_NOT_TRANSFERABLE"):
            project.bind(self.root, self.chunk, self.parent, self.reviewer, self.creation(), self.user())
        self.assertFalse((self.root / ".lit-review/chunks").exists())

    def test_test_setup_cannot_be_promoted_to_production(self):
        project.setup(self.root, self.user(), test=True)
        before = (self.root / ".lit-review/installation.json").read_bytes()
        with self.assertRaisesRegex(Refusal, "INSTALLATION_CONFLICT"):
            project.setup(self.root, self.user())
        self.assertEqual((self.root / ".lit-review/installation.json").read_bytes(), before)

    def test_production_setup_rejects_wrong_project_and_self_dependency(self):
        self.put("lakefile.toml", 'name = "UnrelatedFixture"\n')
        with self.assertRaisesRegex(Refusal, "NOT_LEANINFOTHEORY_CHECKOUT"):
            project.setup(self.root, self.user())
        self.assertFalse((self.root / ".lit-review").exists())
        self.put("lakefile.toml", 'name = "LeanInfoTheory"\n')
        self.put("lake-manifest.json", json.dumps({"packagesDir": ".lake/packages", "packages": [
            {"name": "LeanInfoTheory", "type": "git", "rev": "0" * 40}]}))
        with self.assertRaisesRegex(Refusal, "LIBRARY_CANNOT_DEPEND_ON_ITSELF"):
            project.setup(self.root, self.user())
        self.assertFalse((self.root / ".lit-review").exists())

    def test_store_rejects_relocated_installation_and_changed_owner(self):
        self.install_bind()
        marker = self.root / ".lit-review/installation.json"
        original = marker.read_bytes()
        changed = json.loads(original)
        changed["checkout"] = str(self.root / "different-checkout")
        marker.write_text(json.dumps(changed), encoding="utf-8")
        with self.assertRaisesRegex(Refusal, "PRIVATE_STORE_BINDING"):
            project.ProjectRecordFS(self.root, "chunks/C10", test=True)
        marker.write_bytes(original)
        fs = project.ProjectRecordFS(self.root, "chunks/C10", test=True)
        owner = fs.root / ".project-owner.json"
        changed = json.loads(owner.read_bytes())
        changed["root"] = str(self.root / "unrelated-owner")
        owner.write_text(json.dumps(changed), encoding="utf-8")
        with self.assertRaisesRegex(Refusal, "OWNERSHIP_CHANGED"):
            fs.read("binding.json")
        with self.assertRaisesRegex(Refusal, "PROJECT_OWNER_MISMATCH"):
            project.ProjectRecordFS(self.root, "chunks/C10", test=True)

    def test_creation_profile_purpose_and_native_identity_are_required(self):
        project.setup(self.root, self.user(), test=True)
        self.assertEqual(project.PROFILE, {"model": "gpt-6-astra", "reasoning_effort": "ultra", "fork_context": False})
        for field, value, reason in (
            ("parent_purpose", "INSTALLATION", "CHUNK_IMPLEMENTATION_PARENT_REQUIRED"),
            ("original_result", {"task_name": self.reviewer}, "CREATION_IDENTITY_MISMATCH"),
            ("requested", {"model": "gpt-6-astra", "reasoning_effort": "ultra", "fork_context": True},
             "ORIGINAL_REVIEWER_CREATION_REQUIRED"),
            ("effective_reviewer", {"fork_context": True}, "OBSERVED_PROFILE_CONFLICT"),
        ):
            creation = self.creation()
            creation[field] = value
            with self.subTest(field=field), self.assertRaisesRegex(Refusal, reason):
                project.bind(self.root, self.chunk, self.parent, self.reviewer, creation, self.user(), test=True)
            self.assertFalse((self.root / ".lit-review/chunks/C10").exists())
        binding = project.bind(self.root, self.chunk, self.parent, self.reviewer, self.creation(), self.user(), test=True)
        self.assertIsNone(binding["effective_reviewer"])
        self.assertIsNone(binding["effective_parent"])
        self.assertEqual(binding["input_mode"], "REPLAYED")

    def test_chunk_alias_range_and_step_spelling(self):
        self.assertEqual(project.chunk_id("C09"), "C9")
        self.assertEqual(project.step_chunk("C09.01"), "C9")
        self.assertEqual(project.step_chunk("C9.01"), "C9")
        for number in range(9, 25):
            self.assertEqual(project.chunk_id(f"C{number}"), f"C{number}")
        for value in ("C8", "C25", "C010", "PFR-C09", "c9"):
            with self.subTest(value=value), self.assertRaisesRegex(Refusal, "CHUNK_BINDING"):
                project.chunk_id(value)
        for value in ("C9-S01", "C9.1", "C09.001", "C25.01"):
            with self.subTest(value=value), self.assertRaisesRegex(Refusal, "STEP_SCHEMA"):
                project.step_chunk(value)

    def test_c10_contract_cannot_contain_c9_steps_or_retarget_to_them(self):
        self.install_bind()
        self.put(self.plan_path, (self.root / self.plan_path).read_text() + "\n## C09.01\n")
        contract = self.contract()
        contract["steps"][0]["id"] = "C09.01"
        with self.assertRaisesRegex(Refusal, "CROSS_CHUNK_PLAN"):
            project.open_session(self.root, self.chunk, "execution", contract,
                self.user(scope="APPROVED_IMPLEMENTATION_PLAN", plan_sha256=contract["plan_sha256"]), test=True)
        self.assertFalse((self.root / ".lit-review/chunks/C10/execution").exists())
        contract = self.contract()
        self.w = project.open_session(self.root, self.chunk, "execution", contract,
            self.user(scope="APPROVED_IMPLEMENTATION_PLAN", plan_sha256=contract["plan_sha256"]), test=True)
        for target in ("C9.01", "C09.01", "C11.01", "C10.1"):
            with self.subTest(target=target), self.assertRaisesRegex(Refusal, "UNKNOWN_NAMED_STEP"):
                self.named_next("wrong-chunk", target)
            self.assertIsNone(self.state()["active"])
        self.assertEqual(self.named_next("exact-target")["target"], "C10.01")

    def test_exact_plan_hash_and_approval_scope_are_required(self):
        self.install_bind()
        contract = self.contract()
        for approval in (self.user(scope="PLAN_REVIEW", plan_sha256=contract["plan_sha256"]),
                         self.user(scope="APPROVED_IMPLEMENTATION_PLAN", plan_sha256="0" * 64)):
            with self.assertRaisesRegex(Refusal, "EXACT_PLAN_APPROVAL_REQUIRED"):
                project.open_session(self.root, self.chunk, "execution", contract, approval, test=True)
        self.put(self.plan_path, (self.root / self.plan_path).read_text() + "\nUnapproved contract change.\n")
        with self.assertRaisesRegex(Refusal, "APPROVED_PLAN_BYTES_MISMATCH"):
            project.open_session(self.root, self.chunk, "execution", contract,
                self.user(scope="APPROVED_IMPLEMENTATION_PLAN", plan_sha256=contract["plan_sha256"]), test=True)
        self.assertFalse((self.root / ".lit-review/chunks/C10/execution").exists())

    def test_wrong_parent_creation_reviewer_and_unapproved_plan_refused(self):
        project.setup(self.root, self.user(), test=True)
        creation = {"canonical_reviewer": self.reviewer, "requested": project.PROFILE,
                    "original_result": {"agent_id": self.reviewer, "fixture_note": "Synthetic creation"},
                    "reference": "synthetic:creation", "parent_role": "CHUNK_IMPLEMENTATION",
                    "parent_purpose": "CHUNK_IMPLEMENTATION"}
        with self.assertRaisesRegex(Refusal, "WRONG_ORIGINATING_PARENT"):
            project.bind(self.root, self.chunk, "wrong-parent", self.reviewer, creation, self.user(), test=True)
        wrong_creation = copy.deepcopy(creation)
        wrong_creation["original_result"]["agent_id"] = "synthetic-diagnostic-reviewer"
        with self.assertRaisesRegex(Refusal, "CREATION_IDENTITY_MISMATCH"):
            project.bind(self.root, self.chunk, self.parent, self.reviewer, wrong_creation, self.user(), test=True)
        project.bind(self.root, self.chunk, self.parent, self.reviewer, creation, self.user(), test=True)
        self.put(self.plan_path, (self.root / self.plan_path).read_text().replace("Approved", "Draft"))
        contract = self.contract()
        with self.assertRaisesRegex(Refusal, "NO_APPROVED_PLAN"):
            project.open_session(self.root, self.chunk, "execution", contract,
                                 self.user(scope="APPROVED_IMPLEMENTATION_PLAN", plan_sha256=contract["plan_sha256"]), test=True)
        self.assertFalse((self.root / ".lit-review/chunks/C10/execution").exists())

    def test_unique_per_step_criteria_and_markdown_anchor_required(self):
        contract = self.contract()
        project.verify_contract(self.root, contract, first=True)
        bad = copy.deepcopy(contract); bad["steps"][1]["criteria"][0]["id"] = bad["steps"][0]["criteria"][0]["id"]
        with self.assertRaisesRegex(Refusal, "DUPLICATE_CRITERION"):
            project.verify_contract(self.root, bad, first=True)
        bad = copy.deepcopy(contract); bad["steps"][0]["criteria"][0]["normative_excerpt"] = "Not in actual Markdown."
        with self.assertRaisesRegex(Refusal, "CRITERION_SOURCE_ANCHOR"):
            project.verify_contract(self.root, bad, first=True)

    def test_two_steps_uncertain_delivery_and_original_prose_preserved(self):
        self.session()
        for i in (1, 2):
            if i == 2:
                self.assertEqual(self.next(str(i))["target"], "C10.02")
                edit = self.w.begin_edit(["Case.lean"], "Synthetic authorized second-step own patch")
                self.put("Case.lean", "-- Second-step source-copy fixture implementation.\n")
                self.w.finish_edit(edit)
            ev, req = self.prepared(str(i), start=i == 1)
            self.assertEqual([c["id"] for c in req["payload"]["requirements"]], [f"C10.0{i}-C1"])
            raw = self.report(req); result = self.deliver(req, raw)
            cap = self.w.store.get(result["capture"], "capture")
            self.assertEqual(cap["original_text"], raw)
            self.assertEqual(cap["parsed"]["earlier_reconciliation"], [json.loads(raw)["report"]["earlier_reconciliation"]])
            self.w.reconcile_report(); self.final_ready(ev)
            closure = self.w.project_closure()
            self.assertFalse(closure["production_acceptance"])
            self.assertFalse(closure["next_step_started"])
            if i == 2:
                cert = self.w.store.get(closure["closure"], "closure")
                before = self.w.store.get(cert["B"], "manifest")
                reviewed = self.w.store.get(cert["R"], "manifest")
                self.assertNotEqual(before["source_bytes"]["Case.lean"], reviewed["source_bytes"]["Case.lean"])
            self.assertIsNone(self.state()["active"])
            self.w = project.load_session(self.root, self.chunk, "execution", test=True)
        self.assertEqual(len(self.state()["completed"]), 2)
        self.assertEqual(self.next("third")["status"], "NO_ELIGIBLE_STEP")

    def test_negative_evidence_and_criterion_gap_block_closure(self):
        self.session(); ev, req = self.prepared()
        result = self.deliver(req, self.report(req, "NOT_ESTABLISHED"))
        cap = self.w.store.get(result["capture"], "capture")
        self.assertEqual(self.w.store.get(cap["parsed"]["verification"][0], "evidence")["outcome"], "FAIL")
        self.w.reconcile_report(); self.final_ready(ev)
        with self.assertRaisesRegex(Refusal, "REVIEW_COVERAGE_GAP"):
            self.w.project_closure()
        self.assertFalse(self.state()["completed"])

    def test_material_negative_finding_remains_open(self):
        self.session(); ev, req = self.prepared()
        self.deliver(req, self.report(req, "CONTRADICTED_BY_FINDING", finding=True))
        self.w.reconcile_report(); self.final_ready(ev)
        with self.assertRaisesRegex(Refusal, "MATERIAL_FINDING_OPEN"):
            self.w.project_closure()
        self.assertFalse(self.state()["completed"])

    def test_pending_consumed_skip_does_not_retry_then_fresh_request_can_continue(self):
        self.session(); ev, req = self.prepared()
        self.w.dispatch_intent(req["reference"])
        receipt = self.w.record_submission(req["reference"], "UNCERTAIN", self.empty_submission(req))
        pending = self.state()["active"]["pending"]
        skipped = self.next("queued")
        self.assertEqual(skipped["status"], "SKIPPED_UNCLOSED")
        self.assertEqual(pending, self.state()["active"]["pending"])
        raw = self.report(req)
        self.w.confirm_delivery(req["reference"], receipt, raw, self.observation(req, raw),
                                 self.auth("CONFIRM_DIAGNOSTIC_DELIVERY", req["reference"]))
        self.w.receive_report(raw, self.observation(req, raw), req["payload"]["request_id"], 1)
        self.w.reconcile_report(); self.final_ready(ev); self.w.project_closure()
        self.assertEqual(self.next("queued"), skipped)
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.next("new-after-closure")["target"], "C10.02")

    def test_named_wrong_target_consumed_before_predecessor_starts(self):
        self.session()
        skipped = self.named_next("too-early", "C10.02", "C10.01")
        self.assertEqual(skipped["status"], "SKIPPED_NAMED_TARGET")
        self.assertEqual(skipped["target"], "C10.02")
        self.assertTrue(skipped["consumed"])
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.named_next("first")["target"], "C10.01")
        self.complete_acknowledged("first", start=False)
        self.w = project.load_session(self.root, self.chunk, "execution", test=True)
        self.assertEqual(self.named_next("too-early", "C10.02", "C10.01"), skipped)
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.named_next("fresh", "C10.02", "C10.01")["target"], "C10.02")

    def test_named_unfinished_predecessor_skip_preserves_pending_and_never_revives(self):
        self.session()
        ev, req = self.prepared()
        self.acknowledged_submission(req)
        active = copy.deepcopy(self.state()["active"])
        skipped = self.named_next("queued-second", "C10.02", "C10.01")
        self.assertEqual(skipped["status"], "SKIPPED_NAMED_TARGET")
        self.assertTrue(skipped["consumed"])
        self.assertEqual(self.state()["active"], active)
        raw = self.report(req)
        self.w.receive_report(raw, self.observation(req, raw), req["payload"]["request_id"], 1)
        self.w.reconcile_report()
        self.final_ready(ev)
        self.w.project_closure()
        self.assertEqual(self.named_next("queued-second", "C10.02", "C10.01"), skipped)
        self.assertIsNone(self.state()["active"])
        with self.assertRaisesRegex(Refusal, "WRONG_NAMED_PREDECESSOR"):
            self.named_next("bad-predecessor", "C10.02", "C9.01")
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.named_next("unprocessed-until-now", "C10.02", "C10.01")["target"], "C10.02")

    def test_named_pause_is_consumed_and_fresh_message_needed_after_release(self):
        self.session()
        self.w.control("PAUSE", self.auth("PAUSE", self.w.plan_id))
        skipped = self.named_next("paused")
        self.assertEqual(skipped["status"], "SKIPPED_PAUSED")
        self.w.control("RELEASE", self.auth("RELEASE", self.w.plan_id))
        self.assertEqual(self.named_next("paused"), skipped)
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.named_next("fresh-after-release")["target"], "C10.01")

    def test_named_inspection_failure_is_consumed_before_recovery_and_reload(self):
        self.session()
        with patch.object(self.w, "inspect", side_effect=Refusal("INJECTED_UNREADABLE_STATE")):
            skipped = self.named_next("unreadable-state")
        self.assertTrue(skipped["status"].startswith("SKIPPED_"))
        self.assertEqual(skipped["reason"], "INJECTED_UNREADABLE_STATE")
        self.assertTrue(skipped["consumed"])
        self.assertIsNone(self.state()["active"])
        ledger = self.w.fs.path(f"{self.w.store.prefix}/refused-ingress/{digest('lit-message:unreadable-state')}.json")
        original = ledger.read_bytes()
        with patch.object(self.w, "inspect", side_effect=Refusal("ANOTHER_UNREADABLE_STATE")):
            self.assertEqual(self.named_next("unreadable-state"), skipped)
        self.w = project.load_session(self.root, self.chunk, "execution", test=True)
        self.assertEqual(self.named_next("unreadable-state"), skipped)
        self.assertEqual(ledger.read_bytes(), original)
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.named_next("fresh-after-state-recovery")["target"], "C10.01")

    def test_named_oserror_is_consumed_and_does_not_revive(self):
        self.session()
        with patch.object(self.w, "inspect", side_effect=OSError("Injected fixture read failure")):
            skipped = self.named_next("unreadable-file")
        self.assertTrue(skipped["status"].startswith("SKIPPED_"))
        self.assertTrue(skipped["consumed"])
        self.assertIsNone(self.state()["active"])
        self.w = project.load_session(self.root, self.chunk, "execution", test=True)
        self.assertEqual(self.named_next("unreadable-file"), skipped)
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.named_next("fresh-after-file-recovery")["target"], "C10.01")

    def test_native_empty_submission_confirmation_is_not_report_acceptance(self):
        self.session()
        _, req = self.prepared()
        intent = self.w.dispatch_intent(req["reference"])
        self.assertEqual(intent["operation"], "multi_agent_v1.send_input")
        empty = self.empty_submission(req)
        receipt = self.w.record_submission(req["reference"], "UNCERTAIN", empty)
        original_receipt = self.w.fs.read("durable/objects/" + receipt + ".json")
        self.assertEqual(self.w.store.get(receipt, "submission_observation")["observation"], empty)
        self.assertEqual(self.state()["active"]["blocker"], "DISPATCH_UNCERTAIN")
        with self.assertRaises(Refusal):
            self.w.dispatch_intent(req["reference"])
        raw = self.report(req)
        observation = self.observation(req, raw)
        confirmed = self.w.confirm_delivery(req["reference"], receipt, raw, observation,
            self.auth("CONFIRM_DIAGNOSTIC_DELIVERY", req["reference"]))
        self.assertEqual(confirmed["delivery"], "CONFIRMED_BY_ORIGINAL_REPORT")
        self.assertFalse(confirmed["report_accepted"])
        self.assertEqual(original_receipt, self.w.fs.read("durable/objects/" + receipt + ".json"))
        self.assertIsNone(self.state()["active"]["report"])
        self.assertFalse(self.state()["completed"])
        confirmation = self.w.store.get(confirmed["confirmation"], "delivery_confirmation")
        basis = self.w.store.get(confirmation["basis"], "delivery_observation")
        self.assertEqual(basis["observation"], observation)
        self.assertEqual(basis["original_text"], raw)
        received = self.w.receive_report(raw, observation, req["payload"]["request_id"], 1)
        self.assertEqual(received["classification"], "VALID")
        self.assertEqual(self.w.store.get(received["capture"], "capture")["original_text"], raw)
        self.assertFalse(self.state()["completed"])

    def test_false_origin_wrong_reviewer_and_old_envelope_are_preserved_not_accepted(self):
        self.session()
        _, req = self.prepared()
        self.acknowledged_submission(req)
        raw = self.report(req)
        wrong_status = json.dumps({"status": {"different-reviewer": {"completed": raw}}})
        old_event = json.dumps({"Message Type": "FINAL_ANSWER", "Task name": "/root",
                                "Sender": self.reviewer, "Payload": raw})
        observations = [
            self.observation(req, raw, origin="UNSIGNED_OPERATOR_COPY"),
            self.observation(req, raw, reviewer="different-reviewer"),
            self.observation(req, raw, original_event=wrong_status),
            self.observation(req, raw, original_event=old_event),
            self.observation(req, raw, tool_call={"name": "multi_agent_v1.wait_agent",
                                                "arguments": {"targets": ["different-reviewer"]}}),
            self.observation(req, raw, tool_call={"name": "collaboration.wait",
                                                "arguments": {"targets": [self.reviewer]}}),
            self.observation(req, raw, extracted_text="Parent-authored summary"),
        ]
        for observation in observations:
            with self.subTest(observation=observation):
                received = self.w.receive_report(raw, observation, req["payload"]["request_id"], 1)
                self.assertTrue(received["classification"].startswith("DIAGNOSTIC_INPUT_REFUSED:"))
                capture = self.w.store.get(received["capture"], "capture")
                self.assertEqual(capture["original_text"], raw)
                self.assertEqual(capture["envelope"]["observation"], observation)
                original = self.w.store.get(capture["original_capture"], "capture")
                self.assertEqual(original["original_text"], raw)
                self.assertEqual(original["envelope"]["observation"], observation)
                self.assertIsNone(self.state()["active"]["report"])
                self.assertFalse(self.state()["completed"])
        received = self.w.receive_report(raw, self.observation(req, raw), req["payload"]["request_id"], 1)
        self.assertEqual(received["classification"], "VALID")

    def test_old_delivery_envelope_cannot_establish_new_native_delivery(self):
        self.session()
        _, req = self.prepared()
        self.w.dispatch_intent(req["reference"])
        receipt = self.w.record_submission(req["reference"], "UNCERTAIN", self.empty_submission(req))
        raw = self.report(req)
        observation = self.observation(req, raw, original_event=json.dumps({
            "Message Type": "FINAL_ANSWER", "Task name": "/root", "Sender": self.reviewer, "Payload": raw}))
        with self.assertRaisesRegex(Refusal, "OBSERVED_REPORT_ENVELOPE"):
            self.w.confirm_delivery(req["reference"], receipt, raw, observation,
                self.auth("CONFIRM_DIAGNOSTIC_DELIVERY", req["reference"]))
        records = [self.w.store.get(ref) for ref in self.state()["records"]]
        self.assertTrue(any(r.get("original_text") == raw and r.get("observation") == observation for r in records))
        self.assertFalse(any(r.get("delivery_kind") == "REPORT_BACKED" for r in records))
        self.assertEqual(self.state()["active"]["blocker"], "DISPATCH_UNCERTAIN")

    def test_accepted_findings_require_reconciliation_and_retain_original_history(self):
        self.session()
        ev, req = self.prepared()
        raw = self.report(req, "CONTRADICTED_BY_FINDING", finding=True)
        received = self.acknowledged_report(req, raw)
        self.w.block("SUSPENDED")
        with self.assertRaisesRegex(Refusal, "REPORT_RECONCILIATION_REQUIRED"):
            self.w.recover(self.auth("RECOVER_RETRY", "C10.01"), "retry")
        self.assertEqual(self.state()["active"]["report"], received["capture"])
        self.assertEqual(self.state()["active"]["pending"]["status"], "ACCEPTED")
        self.assertFalse(self.state()["active"]["findings"])
        self.w.recover(self.auth("RECOVER_CONTINUE", "C10.01"))
        self.w.reconcile_report()
        finding_id = json.loads(raw)["report"]["findings"][0]["id"]
        finding = copy.deepcopy(self.state()["active"]["findings"][finding_id])
        self.assertEqual(finding["original"], json.loads(raw)["report"]["findings"][0])
        self.assertEqual(finding["history"][-1]["status"], "OPEN")
        with self.assertRaises(Refusal):
            self.w.disposition(finding_id, "REFUTED_WITH_EVIDENCE", "Unsupported synthetic disagreement.", [])
        self.assertEqual(self.state()["active"]["findings"][finding_id], finding)
        self.final_ready(ev)
        with self.assertRaisesRegex(Refusal, "MATERIAL_FINDING_OPEN"):
            self.w.project_closure()
        self.assertEqual(self.w.store.get(received["capture"], "capture")["original_text"], raw)
        self.assertEqual(self.state()["active"]["findings"][finding_id]["history"], finding["history"])

    def test_source_diverged_report_is_retained_and_cannot_complete(self):
        self.session()
        _, req = self.prepared()
        self.acknowledged_submission(req)
        raw = self.report(req)
        self.put("Case.lean", "-- Unrelated source-copy change after independent review capture.\n")
        observation = self.observation(req, raw)
        result = self.w.receive_report(raw, observation, req["payload"]["request_id"], 1)
        self.assertEqual(result["classification"], "SOURCE_DIVERGED")
        self.assertEqual(self.state()["active"]["blocker"], "SOURCE_DIVERGED")
        capture = self.w.store.get(result["capture"], "capture")
        self.assertEqual(capture["original_text"], raw)
        self.assertEqual(capture["envelope"]["observation"], observation)
        active = copy.deepcopy(self.state()["active"])
        self.assertTrue(self.named_next("later-on-divergence", "C10.02", "C10.01")["consumed"])
        self.assertEqual(self.state()["active"], active)
        self.assertFalse(self.state()["completed"])

    def test_closed_source_divergence_does_not_start_next_step(self):
        self.session()
        self.complete_acknowledged()
        original = (self.root / "Case.lean").read_bytes()
        self.put("Case.lean", "-- Unrelated source-copy edit after closure.\n")
        skipped = self.named_next("changed-after-closure", "C10.02", "C10.01")
        self.assertEqual(skipped["status"], "SKIPPED_AUTHORITY")
        self.assertEqual(skipped["reason"], "CLOSED_SOURCE_DIVERGED")
        self.assertIsNone(self.state()["active"])
        (self.root / "Case.lean").write_bytes(original)
        self.assertEqual(self.named_next("changed-after-closure", "C10.02", "C10.01"), skipped)
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.named_next("fresh-after-exact-restoration", "C10.02", "C10.01")["target"], "C10.02")

    def assert_library_request(self, req):
        payload = req["payload"]
        self.assertEqual(payload["library_rubric"], project.LIBRARY_RUBRIC)
        self.assertEqual(payload["validation_guidance"], project.VALIDATION_GUIDANCE)
        for instruction in project.LIBRARY_RUBRIC:
            self.assertIn(instruction, req["text"])
        for rel in payload["context_documents"]:
            self.assertTrue((self.root / rel).is_file(), rel)
            self.assertIn(rel, payload["source_inventory"])
        self.assertIn("docs/references.md", payload["context_documents"])
        self.assertEqual(payload["factual_evidence"], [])
        self.assertNotIn("Synthetic contextual review.", req["text"])
        self.assertNotIn("Synthetic PASS; no model or Lean run.", req["text"])
        validation = payload["validation_guidance"]
        self.assertEqual(validation["entry_point"], "scripts/validate_release.py")
        self.assertIn("python scripts/validate_release.py static", validation["step"])
        self.assertIn("python scripts/validate_release.py focused <affected-targets>", validation["step"])
        self.assertIn("clean committed tree", validation["clean_checkpoint"])
        self.assertIn("api-docs", validation["api_docs"])
        self.assertIn("Separate explicit authority", validation["publication"])
        self.assertIn("does not certify growth readiness", validation["growth_boundary"])

    def test_step_request_includes_actual_library_rubric_and_validation_routes(self):
        self.session()
        _, req = self.prepared()
        self.assert_library_request(req)

    def test_plan_request_includes_actual_library_rubric_without_execution(self):
        self.put(self.plan_path, (self.root / self.plan_path).read_text().replace("Approved", "Proposed"))
        self.session("PLAN")
        req = self.w.plan_review_request("lit-review:C10:plan-fixture:library-rubric")
        self.assert_library_request(req)
        self.assertFalse(req["normal_step_authorized"])
        self.assertIsNone(self.state()["active"])

    def test_final_step_captures_maintained_handoff_and_stops_without_next_chunk(self):
        self.session()
        self.complete_acknowledged("first")
        self.assertEqual(self.named_next("final-step", "C10.02", "C10.01")["target"], "C10.02")
        handoff = "docs/handoffs/c10-source-copy-test.md"
        context = "docs/lean-info-theory-living-summary.md"
        edit = self.w.begin_edit([handoff, context], "Synthetic final-step maintained handoff and canonical link.")
        text = ("# Synthetic C10 handoff\n"
                "Delivered APIs: source-copy fixture only; no mathematical claim.\n"
                "Imports and consumers: Case.lean fixture; no Lean run.\n"
                "Design and naming decisions: preserve exact C10.01 and C10.02.\n"
                "Source and review references: c10-source-copy-test.md; synthetic reviewer.\n"
                "Limitations and deferred items: no production acceptance or model run.\n"
                "Next chunk prerequisites: separate exact plan approval and new reviewer binding.\n")
        self.put(handoff, text)
        self.put(context, "# Fixture canonical context\n[Maintained C10 handoff](handoffs/c10-source-copy-test.md)\n")
        self.w.finish_edit(edit)
        ev, req = self.prepared("cumulative-closeout", start=False)
        self.assertIn("maintained handoff before final capture", req["payload"]["requirements"][0]["normative_excerpt"])
        self.assertIn(handoff, req["payload"]["source_inventory"])
        self.assert_library_request(req)
        self.acknowledged_report(req)
        self.w.reconcile_report()
        self.final_ready(ev)
        final_ref = self.state()["active"]["F"]
        final = self.w.store.get(final_ref, "manifest")
        self.assertEqual(bytes.fromhex(final["source_bytes"][handoff]), text.encode())
        self.assertIn(b"handoffs/c10-source-copy-test.md", bytes.fromhex(final["source_bytes"][context]))
        self.put(handoff, text + "Unreviewed post-F fixture edit.\n")
        with self.assertRaisesRegex(Refusal, "FINAL_SOURCE_CHANGED"):
            self.w.project_closure()
        self.put(handoff, text)
        closure = self.w.project_closure()
        certificate = self.w.store.get(closure["closure"], "closure")
        self.assertEqual(certificate["F"], final_ref)
        reviewed = self.w.store.get(certificate["R"], "manifest")
        self.assertEqual(reviewed["source_bytes"][handoff], final["source_bytes"][handoff])
        self.assertFalse(closure["next_step_started"])
        self.assertFalse(closure["production_acceptance"])
        self.assertIsNone(self.state()["active"])
        self.assertEqual(set(self.state()["completed"]), {"C10.01", "C10.02"})
        self.assertEqual(self.next("after-completion")["status"], "NO_ELIGIBLE_STEP")
        self.assertFalse((self.root / ".lit-review/chunks/C11").exists())
        self.assertFalse((self.root / "docs/plans/c11-source-copy-test.md").exists())
        self.assertEqual((self.root / handoff).read_bytes(), text.encode())

    def test_baseline_is_working_state_not_head_and_includes_untracked(self):
        self.session()
        self.put("Case.lean", "-- dirty fixture before current-step baseline\n")
        self.put("docs/untracked.md", "Untracked fixture note\n")
        self.assertEqual(self.next()["status"], "ACCEPTED")
        baseline = self.w.store.get(self.state()["active"]["B"], "manifest")
        self.assertEqual(baseline["git"]["head"], self.head)
        self.assertEqual(bytes.fromhex(baseline["source_bytes"]["Case.lean"]), (self.root / "Case.lean").read_bytes())
        self.assertNotEqual(bytes.fromhex(baseline["source_bytes"]["Case.lean"]), self.git("show", "HEAD:Case.lean"))
        self.assertIn("docs/untracked.md", baseline["inventory"])

    def test_missing_explicit_source_consumes_request_and_active_work_skips(self):
        self.install_bind()
        self.put("Extra.lean", "-- Explicit untracked source-copy fixture dependency.\n")
        contract = self.contract(); contract["scope"].append("Extra.lean")
        self.w = project.open_session(self.root, self.chunk, "execution", contract,
            self.user(scope="APPROVED_IMPLEMENTATION_PLAN", plan_sha256=contract["plan_sha256"]), test=True)
        (self.root / "Extra.lean").unlink()
        skipped = self.next("missing-source")
        self.assertEqual(skipped["status"], "SKIPPED_SOURCE_OR_STATE")
        self.assertTrue(skipped["consumed"]); self.assertIsNone(self.state()["active"])
        self.put("Extra.lean", "-- Explicit untracked source-copy fixture dependency.\n")
        self.assertEqual(self.next("missing-source"), skipped)
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.next("fresh-after-restoration")["target"], "C10.01")
        prior = copy.deepcopy(self.state()["active"])
        (self.root / "Extra.lean").unlink()
        self.assertEqual(self.next("active-with-missing-source")["status"], "SKIPPED_UNCLOSED")
        self.assertEqual(self.state()["active"], prior)

    def test_missing_plan_oserror_consumes_request_before_restoration(self):
        self.session()
        original = (self.root / self.plan_path).read_bytes()
        (self.root / self.plan_path).unlink()
        skipped = self.next("missing-plan")
        self.assertEqual(skipped["status"], "SKIPPED_SOURCE_OR_STATE")
        self.assertTrue(skipped["consumed"])
        self.assertIsNone(self.state()["active"])
        (self.root / self.plan_path).write_bytes(original)
        self.assertEqual(self.next("missing-plan"), skipped)
        self.assertIsNone(self.state()["active"])
        self.assertEqual(self.next("new-after-plan-restoration")["target"], "C10.01")

    def test_passive_plan_review_never_approves_or_selects_step(self):
        self.put(self.plan_path, (self.root / self.plan_path).read_text().replace("Approved", "Proposed"))
        proposed = (self.root / self.plan_path).read_bytes()
        self.session("PLAN")
        req = self.w.plan_review_request(f"lit-review:{self.chunk}:plan-fixture:first")
        self.w.plan_review_record(req["reference"], "INTENT", "Synthetic passive fixture intent", {})
        self.w.plan_review_record(req["reference"], "SUBMISSION", "Synthetic acknowledged submission",
                                self.observation(req, submission_result="ACKNOWLEDGED"))
        raw = self.report(req)
        result = self.w.plan_review_record(req["reference"], "REPORT", raw, self.observation(req, raw))
        self.assertEqual(result["classification"], "VALID")
        self.assertFalse(result["normal_step_acceptance"])
        self.assertFalse(self.w.plan_review_result()["plan_approved"])
        self.assertFalse(self.w.reconcile_plan_review("Synthetic fixture assessment retained; no implementation approval.")["plan_approved"])
        self.assertIsNone(self.state()["active"]); self.assertFalse(self.state()["completed"])
        self.assertEqual((self.root / self.plan_path).read_bytes(), proposed)
        self.assertFalse((self.root / ".lit-review/chunks/C10/execution").exists())
        with self.assertRaisesRegex(Refusal, "PLAN_REVIEW_NOT_EXECUTION"):
            self.next()

    def test_passive_plan_review_uncertain_delivery_recovers_without_approval(self):
        self.put(self.plan_path, (self.root / self.plan_path).read_text().replace("Approved", "Proposed"))
        proposed = (self.root / self.plan_path).read_bytes()
        self.session("PLAN")
        req = self.w.plan_review_request("lit-review:C10:plan-fixture:uncertain-delivery")
        self.w.plan_review_record(req["reference"], "INTENT", "Synthetic passive fixture intent", {})
        empty = self.empty_submission(req)
        empty["submission_result"] = "UNCERTAIN"
        with self.assertRaisesRegex(Refusal, "DETECTION_SUBMISSION_UNCONFIRMED"):
            self.w.plan_review_record(req["reference"], "SUBMISSION", "", empty)
        receipts = [ref for ref in self.state()["records"] if
                    self.w.store.get(ref).get("stage") == "SUBMISSION"]
        self.assertEqual(len(receipts), 1)
        receipt = receipts[0]
        original = self.w.fs.read("durable/objects/" + receipt + ".json")
        self.assertEqual(self.w.store.get(receipt, "detection_observation")["observation"], empty)
        self.w = project.load_session(self.root, self.chunk, "plan-fixture", test=True)
        raw = self.report(req, "NOT_ESTABLISHED")
        observation = self.observation(req, raw)
        with self.assertRaisesRegex(Refusal, "SUBMISSION_REQUIRED"):
            self.w.plan_review_record(req["reference"], "REPORT", raw, observation)
        confirmed = self.w.confirm_delivery(req["reference"], receipt, raw, observation,
            self.auth("CONFIRM_DIAGNOSTIC_DELIVERY", req["reference"]))
        self.assertEqual(confirmed["delivery"], "CONFIRMED_BY_ORIGINAL_REPORT")
        self.assertFalse(confirmed["report_accepted"])
        self.assertEqual(self.w.fs.read("durable/objects/" + receipt + ".json"), original)
        with self.assertRaisesRegex(Refusal, "NO_VALID_PLAN_REPORT"):
            self.w.plan_review_result()
        received = self.w.plan_review_record(req["reference"], "REPORT", raw, observation)
        self.assertEqual(received["classification"], "VALID")
        self.assertFalse(received["normal_step_acceptance"])
        self.assertEqual(received["parsed"]["criteria"][0]["status"], "NOT_ESTABLISHED")
        self.assertEqual(self.w.store.get(received["record"], "detection_observation")["original_text"], raw)
        self.assertFalse(self.w.plan_review_result()["plan_approved"])
        self.assertFalse(self.w.reconcile_plan_review("Retain negative fixture verdict; no implementation approval.")["plan_approved"])
        self.assertEqual(self.w.plan_review_record(req["reference"], "REPORT", raw, observation)["classification"],
                         "IDENTICAL_DUPLICATE")
        self.assertIsNone(self.state()["active"])
        self.assertFalse(self.state()["completed"])
        self.assertEqual((self.root / self.plan_path).read_bytes(), proposed)
        self.assertFalse((self.root / ".lit-review/chunks/C10/execution").exists())

    def test_own_edit_and_restore_barriers_preserve_unrelated_work(self):
        self.session(); self.next()
        restored = self.w.validate_restored_binding_and_source(expected_tip=self.w.inspect()["tip"])
        self.assertFalse(restored["automatic_resume"])
        original = (self.root / "Case.lean").read_bytes()
        with self.assertRaises(Refusal): self.w.own_edit("Case.lean", "not permitted")
        with self.assertRaisesRegex(Refusal, "EDIT_SCOPE"): self.w.begin_edit(["lean-toolchain"], "Fixture forbidden edit")
        ref = self.w.begin_edit(["Case.lean"], "Fixture-owned bounded patch")
        self.assertEqual(original, (self.root / "Case.lean").read_bytes())
        self.put("Case.lean", "-- own fixture patch\n"); self.w.finish_edit(ref)
        self.put("docs/unrelated.md", "Unrelated source-copy user work\n")
        with self.assertRaisesRegex(Refusal, "REVERSAL_NOT_EXACT"): self.w.finish_reversal(ref)
        (self.root / "Case.lean").write_bytes(original); self.w.finish_reversal(ref)
        self.assertEqual((self.root / "docs/unrelated.md").read_text(), "Unrelated source-copy user work\n")
        current = self.w.inspect()
        with self.assertRaisesRegex(Refusal, "STALE_RESTORED_STATE"):
            self.w.validate_restored_binding_and_source(expected_tip="0" * 64)
        with self.assertRaisesRegex(Refusal, "RESTORED_SOURCE_CONFLICT"):
            self.w.validate_restored_binding_and_source(expected_tip=current["tip"])


class CollaborationTransportTests(unittest.TestCase):
    """Explicitly synthetic native-format samples in isolated REPLAYED source copies."""

    def setUp(self):
        self.f = ProjectWorkflowTests(methodName="runTest")
        self.f.reviewer = "/root/c9_reviewer"
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)
        self.f.creation = self.creation
        self.f.observation = self.observation
        self.f.empty_submission = self.empty_submission
        self.f.acknowledged_submission = self.acknowledged_submission

    def creation(self):
        return {"canonical_reviewer": self.f.reviewer, "requested": copy.deepcopy(project.PROFILE),
                "transport": "collaboration", "parent_task_id": self.f.parent,
                "parent_role": "/root", "parent_purpose": "CHUNK_IMPLEMENTATION",
                "reference": "synthetic-source-copy:collaboration-creation",
                "original_result": {"task_name": self.f.reviewer},
                "tool_call": {"name": "collaboration.spawn_agent", "arguments": {
                    "task_name": "c9_reviewer", "model": "gpt-6-astra", "reasoning_effort": "ultra",
                    "fork_turns": "none", "message": "Synthetic read-only bootstrap; no native call."}}}

    def observation(self, req, raw=None, **extra):
        result = ProjectWorkflowTests.observation(self.f, req)
        if raw is not None:
            result.update(event_kind="FULL_REPORT", complete=True, text_role="ORIGINAL_NOT_SUMMARY",
                extracted_text=raw, tool_call={"name": "collaboration.list_agents", "arguments": {}},
                original_event=json.dumps({"agents": [
                    {"agent_name": "/root", "agent_status": "running"},
                    {"agent_name": self.f.reviewer, "agent_status": {"completed": raw}}]}))
        result.update(extra)
        return result

    def empty_submission(self, req):
        return self.observation(req, original_event=json.dumps(""),
            tool_call={"name": "collaboration.followup_task",
                       "arguments": {"target": self.f.reviewer, "message": req["text"]}})

    def acknowledged_submission(self, req):
        self.f.w.dispatch_intent(req["reference"])
        observation = self.empty_submission(req)
        observation["original_event"] = json.dumps({"task_name": self.f.reviewer})
        return self.f.w.record_submission(req["reference"], "ACKNOWLEDGED", observation)

    def test_explicit_creation_requires_actual_arguments_parent_and_handle(self):
        f = self.f
        project.setup(f.root, f.user(), test=True)
        changes = [
            (("transport",), "unknown"),
            (("transport",), {}),
            (("transport",), "multi_agent_v1"),
            (("parent_task_id",), "different-parent"),
            (("parent_role",), "CHUNK_IMPLEMENTATION"),
            (("parent_role",), "/root/other"),
            (("tool_call", "name"), "multi_agent_v1.spawn_agent"),
            (("tool_call", "arguments", "model"), "different-model"),
            (("tool_call", "arguments", "reasoning_effort"), "low"),
            (("tool_call", "arguments", "fork_turns"), "all"),
            (("tool_call", "arguments", "task_name"), "other_reviewer"),
            (("tool_call", "arguments", "message"), ""),
            (("original_result",), {"agent_id": f.reviewer}),
            (("original_result",), {"task_name": f.reviewer, "agent_id": f.reviewer}),
            (("original_result",), {"task_name": "/root/different"}),
        ]
        for keys, value in changes:
            creation = self.creation()
            cursor = creation
            for key in keys[:-1]:
                cursor = cursor[key]
            cursor[keys[-1]] = value
            with self.subTest(keys=keys, value=value), self.assertRaises(Refusal):
                project.bind(f.root, f.chunk, f.parent, f.reviewer, creation, f.user(), test=True)
            self.assertFalse((f.root / ".lit-review/chunks/C10").exists())
        omitted = self.creation()
        del omitted["transport"]
        with self.assertRaisesRegex(Refusal, "CREATION_IDENTITY_MISMATCH"):
            project.bind(f.root, f.chunk, f.parent, f.reviewer, omitted, f.user(), test=True)
        invented_args = self.creation()
        invented_args["tool_call"]["arguments"]["fork_context"] = False
        with self.assertRaisesRegex(Refusal, "CREATION_NATIVE_ARGUMENTS"):
            project.bind(f.root, f.chunk, f.parent, f.reviewer, invented_args, f.user(), test=True)
        creation = self.creation()
        binding = project.bind(f.root, f.chunk, f.parent, f.reviewer, creation, f.user(), test=True)
        self.assertEqual(binding["creation"], creation)
        self.assertEqual(binding["reviewer"], "/root/c9_reviewer")
        self.assertIsNone(binding["effective_reviewer"])
        self.assertNotIn("agent_id", binding["creation"]["original_result"])

    def test_legacy_explicit_transport_preserves_legacy_creation(self):
        f = self.f
        creation = ProjectWorkflowTests.creation(f)
        creation["transport"] = "multi_agent_v1"
        project.setup(f.root, f.user(), test=True)
        binding = project.bind(f.root, f.chunk, f.parent, f.reviewer, creation, f.user(), test=True)
        self.assertEqual(binding["creation"], creation)

    def test_two_step_list_completion_keeps_review_and_closure_process(self):
        f = self.f
        f.session()
        first = f.complete_acknowledged("collaboration-first")
        self.assertFalse(first["next_step_started"])
        second = f.complete_acknowledged("collaboration-second")
        self.assertFalse(second["next_step_started"])
        self.assertEqual(set(f.state()["completed"]), {"C10.01", "C10.02"})
        self.assertIsNone(f.state()["active"])

    def test_uncertain_empty_followup_is_preserved_and_delivery_is_not_acceptance(self):
        f = self.f
        f.session()
        _, req = f.prepared()
        intent = f.w.dispatch_intent(req["reference"])
        self.assertEqual(intent["operation"], "collaboration.followup_task")
        empty = self.empty_submission(req)
        receipt = f.w.record_submission(req["reference"], "UNCERTAIN", empty)
        original = f.w.fs.read("durable/objects/" + receipt + ".json")
        self.assertEqual(f.state()["active"]["blocker"], "DISPATCH_UNCERTAIN")
        raw = f.report(req)
        observed = self.observation(req, raw)
        confirmed = f.w.confirm_delivery(req["reference"], receipt, raw, observed,
            f.auth("CONFIRM_DIAGNOSTIC_DELIVERY", req["reference"]))
        self.assertFalse(confirmed["report_accepted"])
        self.assertIsNone(f.state()["active"]["report"])
        self.assertEqual(original, f.w.fs.read("durable/objects/" + receipt + ".json"))
        self.assertEqual(f.w.store.get(receipt, "submission_observation")["observation"], empty)
        received = f.w.receive_report(raw, observed, req["payload"]["request_id"], 1)
        self.assertEqual(received["classification"], "VALID")
        self.assertFalse(f.state()["completed"])
        self.assertEqual(f.w.store.get(received["capture"], "capture")["original_text"], raw)
        with self.assertRaises(Refusal):
            f.w.finish_corrections()

    def test_submission_errors_preserve_original_before_refusal(self):
        f = self.f
        f.session()
        _, req = f.prepared()
        f.w.dispatch_intent(req["reference"])
        cases = []
        for raw in ("", None, {}, [], "  "):
            observed = self.empty_submission(req)
            observed["original_event"] = json.dumps(raw)
            cases.append(("ACKNOWLEDGED", observed))
        wrong_target = self.empty_submission(req)
        wrong_target["tool_call"]["arguments"]["target"] = "/root/other"
        cases.append(("UNCERTAIN", wrong_target))
        wrong_message = self.empty_submission(req)
        wrong_message["tool_call"]["arguments"]["message"] = "Parent summary, not the exact request."
        cases.append(("UNCERTAIN", wrong_message))
        wrong_tool = self.empty_submission(req)
        wrong_tool["tool_call"]["name"] = "collaboration.send_message"
        cases.append(("UNCERTAIN", wrong_tool))
        for result, observed in cases:
            with self.subTest(result=result, observed=observed), self.assertRaises(Refusal):
                f.w.record_submission(req["reference"], result, observed)
            records = [f.w.store.get(ref) for ref in f.state()["records"]]
            self.assertTrue(any(record.get("request") == req["reference"]
                                and record.get("result") == result
                                and record.get("observation") == observed for record in records))
            self.assertNotIn("submission_receipt", f.state()["active"]["pending"])
            self.assertFalse(f.state()["completed"])

    def test_invalid_native_completions_are_preserved_not_accepted(self):
        f = self.f
        f.session()
        _, req = f.prepared()
        self.acknowledged_submission(req)
        raw = f.report(req)
        correct = {"agent_name": f.reviewer, "agent_status": {"completed": raw}}
        events = [
            {"agents": []},
            {"agents": [dict(correct, agent_name="/root/other")]},
            {"agents": [correct, correct]},
            {"agents": [dict(correct, agent_status="running")]},
            {"agents": [dict(correct, agent_status={"progress": raw})]},
            {"agents": [dict(correct, agent_status={"completed": raw, "progress": "running"})]},
            {"agents": [dict(correct, agent_name=1)]},
            {"status": {f.reviewer: {"completed": raw}}},
            {"Message Type": "FINAL_ANSWER", "Task name": "/root", "Sender": f.reviewer, "Payload": raw},
        ]
        events.extend({"agents": [dict(correct, agent_status={"completed": value})]}
                      for value in (None, True, 123, {}, [], "", "  "))
        observations = [self.observation(req, raw, original_event=json.dumps(event)) for event in events]
        observations.extend([
            self.observation(req, raw, parent="different-parent"),
            self.observation(req, raw, reviewer="/root/other"),
            self.observation(req, raw, origin="UNSIGNED_OPERATOR_COPY"),
            self.observation(req, raw, extracted_text="Parent-authored summary"),
            self.observation(req, raw, tool_call={"name": "multi_agent_v1.wait_agent", "arguments": {"targets": [f.reviewer]}}),
            self.observation(req, raw, tool_call={"name": "collaboration.wait_agent", "arguments": {}}),
            self.observation(req, raw, tool_call={"name": "collaboration.list_agents", "arguments": {"targets": [f.reviewer]}}),
            self.observation(req, raw, tool_call={"name": "collaboration.list_agents", "arguments": {"path_prefix": "/root/other"}}),
        ])
        for observed in observations:
            with self.subTest(observed=observed):
                received = f.w.receive_report(raw, observed, req["payload"]["request_id"], 1)
                self.assertTrue(received["classification"].startswith("DIAGNOSTIC_INPUT_REFUSED:"))
                capture = f.w.store.get(received["capture"], "capture")
                self.assertEqual(capture["original_text"], raw)
                self.assertEqual(capture["envelope"]["observation"], observed)
                self.assertIsNone(f.state()["active"]["report"])
                self.assertFalse(f.state()["completed"])

    def test_prefixed_list_preserves_report_and_duplicate_conflict_rules(self):
        f = self.f
        f.session()
        _, req = f.prepared()
        self.acknowledged_submission(req)
        raw = f.report(req)
        observed = self.observation(req, raw, tool_call={"name": "collaboration.list_agents",
                                                       "arguments": {"path_prefix": "/root"}})
        accepted = f.w.receive_report(raw, observed, req["payload"]["request_id"], 1)
        self.assertEqual(accepted["classification"], "VALID")
        self.assertEqual(f.w.receive_report(raw, observed, req["payload"]["request_id"], 1)["classification"],
                         "IDENTICAL_DUPLICATE")
        changed = json.loads(raw)
        changed["report"]["conclusion"] = "Conflicting fixture conclusion."
        changed = json.dumps(changed)
        conflict = f.w.receive_report(changed, self.observation(req, changed), req["payload"]["request_id"], 1)
        self.assertEqual(conflict["classification"], "CONFLICTING_DUPLICATE")
        self.assertFalse(f.state()["completed"])

    def test_stale_bootstrap_and_wrong_report_correlation_do_not_pass(self):
        f = self.f
        f.session()
        _, req = f.prepared()
        self.acknowledged_submission(req)
        raws = ["Ready for a later review; no inspection performed."]
        for key, value in (("request_id", "lit-review:C10:execution:other"), ("attempt", 2),
                           ("source_ref", "wrong-source"), ("binding_digest", "wrong-binding"),
                           ("kind", "PLAN")):
            changed = json.loads(f.report(req))
            changed["report"][key] = value
            raws.append(json.dumps(changed))
        for raw in raws:
            with self.subTest(raw=raw):
                received = f.w.receive_report(raw, self.observation(req, raw), req["payload"]["request_id"], 1)
                self.assertNotEqual(received["classification"], "VALID")
                self.assertEqual(f.w.store.get(received["capture"], "capture")["original_text"], raw)
                self.assertIsNone(f.state()["active"]["report"])

    def test_source_divergence_still_blocks_original_list_report(self):
        f = self.f
        f.session()
        _, req = f.prepared()
        self.acknowledged_submission(req)
        raw = f.report(req)
        f.put("Case.lean", "-- Changed fixture source after R.\n")
        received = f.w.receive_report(raw, self.observation(req, raw), req["payload"]["request_id"], 1)
        self.assertEqual(received["classification"], "SOURCE_DIVERGED")
        self.assertEqual(f.state()["active"]["blocker"], "SOURCE_DIVERGED")
        self.assertFalse(f.state()["completed"])

    def test_criterion_gap_still_blocks_closure(self):
        f = self.f
        f.session()
        ev, req = f.prepared()
        f.acknowledged_report(req, f.report(req, status="NOT_ESTABLISHED"))
        f.w.reconcile_report()
        f.final_ready(ev)
        with self.assertRaisesRegex(Refusal, "REVIEW_COVERAGE_GAP"):
            f.w.project_closure()
        self.assertFalse(f.state()["completed"])

    def test_material_finding_still_blocks_closure(self):
        f = self.f
        f.session()
        ev, req = f.prepared()
        f.acknowledged_report(req, f.report(req, finding=True))
        f.w.reconcile_report()
        f.final_ready(ev)
        with self.assertRaisesRegex(Refusal, "MATERIAL_FINDING_OPEN"):
            f.w.project_closure()
        self.assertFalse(f.state()["completed"])

    def test_transport_is_frozen_in_shared_binding_and_session(self):
        f = self.f
        f.session()
        shared = project.ProjectRecordFS(f.root, "chunks/C10", test=True)
        binding = json.loads(shared.read("binding.json"))
        binding["creation"]["transport"] = "multi_agent_v1"
        shared.write("binding.json", json.dumps(binding))
        with self.assertRaisesRegex(Refusal, "CHUNK_REVIEWER_BINDING_CHANGED"):
            f.w.inspect()

    def test_passive_plan_review_with_uncertain_followup_does_not_approve(self):
        f = self.f
        f.put(f.plan_path, (f.root / f.plan_path).read_text().replace("Approved", "Proposed"))
        proposed = (f.root / f.plan_path).read_bytes()
        f.session("PLAN")
        req = f.w.plan_review_request("lit-review:C10:plan-fixture:collaboration")
        f.w.plan_review_record(req["reference"], "INTENT", "Synthetic collaboration intent", {})
        empty = self.empty_submission(req)
        empty["submission_result"] = "UNCERTAIN"
        with self.assertRaisesRegex(Refusal, "DETECTION_SUBMISSION_UNCONFIRMED"):
            f.w.plan_review_record(req["reference"], "SUBMISSION", "", empty)
        receipts = [ref for ref in f.state()["records"]
                    if f.w.store.get(ref).get("stage") == "SUBMISSION"]
        self.assertEqual(len(receipts), 1)
        receipt = receipts[0]
        original = f.w.fs.read("durable/objects/" + receipt + ".json")
        raw = f.report(req, status="NOT_ESTABLISHED")
        observed = self.observation(req, raw)
        confirmed = f.w.confirm_delivery(req["reference"], receipt, raw, observed,
            f.auth("CONFIRM_DIAGNOSTIC_DELIVERY", req["reference"]))
        self.assertFalse(confirmed["report_accepted"])
        self.assertEqual(original, f.w.fs.read("durable/objects/" + receipt + ".json"))
        received = f.w.plan_review_record(req["reference"], "REPORT", raw, observed)
        self.assertEqual(received["classification"], "VALID")
        self.assertEqual(received["parsed"]["criteria"][0]["status"], "NOT_ESTABLISHED")
        self.assertFalse(f.w.plan_review_result()["plan_approved"])
        self.assertFalse(f.w.reconcile_plan_review("Retain original negative fixture assessment.")["plan_approved"])
        self.assertEqual((f.root / f.plan_path).read_bytes(), proposed)
        self.assertIsNone(f.state()["active"])
        self.assertFalse(f.state()["completed"])


if __name__ == "__main__":
    unittest.main()
