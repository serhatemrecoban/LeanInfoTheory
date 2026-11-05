"""Model-free, temporary-source-copy tests for the bounded C24.06 repair.

All native frames, observations, qualification and authority below are synthetic.
No test communicates with a model, opens the live recorder, or certifies Lean.
"""
from __future__ import annotations

import copy
import json
from pathlib import Path
import sys
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).absolute().parent))
import test_project_workflow as helpers

project = helpers.project
Refusal = helpers.Refusal
digest = helpers.digest

REPAIR_PATHS = (
    "tools/lit_review/project.py",
    "tools/lit_review/tests/test_noncanonical_dispatch.py",
    "docs/review-operations.md",
)
CANDIDATE_REF = "refs/heads/codex/c24-candidate"
CRITERIA = ("IDENTITY", "USE", "REPRODUCIBILITY")


def source_copy_fixture():
    # Keep this subclass local: unittest must not rediscover the entire inherited
    # ProjectWorkflowTests suite when discovering this focused test module.
    class Fixture(helpers.ProjectWorkflowTests):
        chunk = "C24"
        reviewer = "/root/c24_reviewer"
        plan_path = "docs/plans/post-release-chunk-24.md"
        step = "C24.06"
        criterion_names = CRITERIA
        collaboration = True

        def contract(self, kind="STEP"):
            criteria = [{
                "id": "C24.06-" + name, "description": "Synthetic " + name,
                "source_reference": self.plan_path + "#c2406",
                "normative_excerpt": "Synthetic Step 6 " + name + " obligation.",
                "scope": "Case.lean exact source-copy fixture bytes",
                "required_evidence": "Synthetic source inspection; no compiler or model claim.",
            } for name in self.criterion_names]
            return {"plan_path": self.plan_path,
                "plan_sha256": digest((self.root / self.plan_path).read_bytes()),
                "kind": kind, "scope": ["Case.lean"],
                "normative_anchors": [c["normative_excerpt"] for c in criteria],
                "steps": [{"id": self.step, "criteria": criteria}] if kind == "STEP" else [],
                "plan_criteria": criteria if kind == "PLAN" else []}

        def creation(self):
            if not self.collaboration:
                return super().creation()
            return {"canonical_reviewer": self.reviewer, "requested": copy.deepcopy(project.PROFILE),
                "transport": "collaboration", "parent_task_id": self.parent,
                "parent_role": "/root", "parent_purpose": "CHUNK_IMPLEMENTATION",
                "reference": "synthetic-source-copy:collaboration-creation",
                "original_result": {"task_name": self.reviewer},
                "tool_call": {"name": "collaboration.spawn_agent", "arguments": {
                    "task_name": "c24_reviewer", "model": "gpt-6-astra", "reasoning_effort": "ultra",
                    "fork_turns": "none", "message": "Synthetic bootstrap; no native call."}}}

        def observation(self, req, raw=None, **extra):
            result = super().observation(req)
            if raw is not None:
                result.update(event_kind="FULL_REPORT", complete=True,
                    text_role="ORIGINAL_NOT_SUMMARY", extracted_text=raw,
                    tool_call={"name": "collaboration.list_agents", "arguments": {}},
                    original_event=json.dumps({"agents": [
                        {"agent_name": "/root", "agent_status": "running"},
                        {"agent_name": self.reviewer, "agent_status": {"completed": raw}}]}))
            result.update(extra)
            return result

        def empty_submission(self, req):
            return self.observation(req, original_event=json.dumps(""),
                tool_call={"name": "collaboration.followup_task", "arguments": {
                    "target": self.reviewer, "message": req["text"]}})

        def acknowledged_submission(self, req):
            self.w.dispatch_intent(req["reference"])
            observation = self.empty_submission(req)
            observation["original_event"] = json.dumps({"task_name": self.reviewer})
            return self.w.record_submission(req["reference"], "ACKNOWLEDGED", observation)

    return Fixture(methodName="runTest")


class NoncanonicalDispatchTests(unittest.TestCase):
    def setUp(self):
        self.f = source_copy_fixture()
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)
        f = self.f
        f.put(f.plan_path, "# Synthetic plan\n\n**Status:** Approved\n\n## C24.06\n" +
              "\n".join("Synthetic Step 6 " + name + " obligation." for name in CRITERIA) + "\n")
        # These are audited bytes in a temporary repository, never executable
        # replacements of the real adapter. The new test path is absent at R.
        f.put(REPAIR_PATHS[0], "# Synthetic adapter before repair.\n")
        f.put(REPAIR_PATHS[2], "# Synthetic operations before repair.\n")
        f.git("add", ".")
        f.git("commit", "-qm", "Synthetic C24.06 source-copy baseline")
        f.head = f.git("rev-parse", "HEAD").decode().strip()
        f.git("update-ref", CANDIDATE_REF, f.head)

    def pending(self, *, kind="STEP", repair=True, rejected_preflight=True):
        f = self.f
        f.session(kind)
        if kind == "STEP":
            ev, req = f.prepared("noncanonical-original")
        else:
            ev = None
            req = f.w.plan_review_request("lit-review:C24:plan-fixture:noncanonical-original")
        f.w.dispatch_intent(req["reference"])
        if rejected_preflight and f.collaboration:
            observation = f.empty_submission(req)
            observation["tool_call"]["arguments"]["message"] = "Synthetic noncanonical visible message."
            with self.assertRaisesRegex(Refusal, "OBSERVED_SUBMISSION_MESSAGE"):
                f.w.record_submission(req["reference"], "UNCERTAIN", observation)
        old = f.w.store.get(req["payload"]["source_ref"], "manifest")
        if repair:
            for path in REPAIR_PATHS:
                f.put(path, "# Synthetic repaired bytes for " + path + ".\n")
        new = f.w.current(f.state(), "NONCANONICAL_REPAIR_SOURCE")
        repairs = {path: {"before": old["source_bytes"].get(path),
                          "after": new["source_bytes"].get(path)} for path in REPAIR_PATHS} if repair else {}
        evidence = self.evidence(req, new)
        return {"ev": ev, "req": req, "old": old, "new": new,
                "repairs": repairs, "evidence": evidence}

    def evidence(self, req, new):
        f = self.f
        p = req["payload"]
        call_id = "synthetic-noncanonical-call"
        call = json.dumps({"payload": {"type": "function_call", "namespace": "collaboration",
            "name": "followup_task", "call_id": call_id,
            "arguments": json.dumps({"target": f.reviewer,
                "message": "Synthetic noncanonical visible message; not the canonical request."})}})
        result = json.dumps({"payload": {"type": "function_call_output", "call_id": call_id, "output": ""}})
        canonical = p["source_inventory"]["Case.lean"]["sha256"]
        observed = digest(b"Synthetic different visible source hash")
        return {"schema": 1, "parent": f.parent, "reviewer": f.reviewer,
            "request": req["reference"], "source_ref": p["source_ref"],
            "native_call": call, "native_result": result,
            "candidate": {"ref": CANDIDATE_REF, "commit": f.head,
                          "tree": f.git("rev-parse", f.head + "^{tree}").decode().strip()},
            "root_observation": {"actor": "/root", "native_call_id": call_id,
                "request_ref": req["reference"], "native_result": "UNCERTAIN",
                "submission_id": None, "acceptance_credit": False, "status": "FAIL",
                "canonical_text_sha256": digest(req["text"].encode()),
                "physical_frames": {"call": digest(call.encode()), "result": digest(result.encode())},
                "known_example": {"path": "Case.lean", "canonical_sha256": canonical,
                                  "emitted_visible_sha256": observed}},
            "reviewer_observation": {"actor": f.reviewer, "request_id": p["request_id"],
                "model_visible_comparison": {"mismatches": [{"field": "source_inventory[Case.lean].sha256",
                    "model_visible_received": observed, "canonical": canonical}],
                    "full_received_hash_or_counts": None, "complete_mismatch_count": None},
                "native_received_event": {"retained": False, "decoded_body_sha256": None,
                                          "raw_sha256": None, "raw_bytes": None},
                "partial_observations": {"acceptance_credit": False},
                "canonical_file": {"source_ref": p["source_ref"], "raw_sha256": digest(req["text"].encode())}},
            "qualification": {"source_digest": digest(new),
                "tests": {"actor": f.parent, "reference": "synthetic-source-copy:tests",
                    "original_text": "Synthetic model-free PASS; not an actual test-run attestation.", "outcome": "PASS"},
                "independent_review": {"actor": "/root/synthetic_repair_examiner",
                    "reference": "synthetic-source-copy:independent-examination",
                    "original_text": "Synthetic independent examination; not actual reviewer acceptance.", "outcome": "PASS"}}}

    def target(self, case):
        return self.f.w.noncanonical_dispatch_target(case["evidence"], case["repairs"])

    def adjudicate(self, case, approval=None):
        f = self.f
        if approval is None:
            approval = f.auth("ADJUDICATE_NONCANONICAL_DISPATCH", self.target(case)["target"])
        return f.w.adjudicate_noncanonical_dispatch(case["evidence"], case["repairs"], approval,
            "Synthetic exact repair; fresh validation and a new original review remain required.")

    def retained_bytes(self):
        f = self.f
        return {ref: f.w.fs.read(f"{f.w.store.prefix}/objects/{ref}.json") for ref in f.state()["records"]}

    def assert_preserved(self, before):
        f = self.f
        for ref, raw in before.items():
            self.assertEqual(f.w.fs.read(f"{f.w.store.prefix}/objects/{ref}.json"), raw, ref)

    def test_exact_repair_preserves_history_and_requires_full_fresh_cycle(self):
        f = self.f
        case = self.pending()
        prior = copy.deepcopy(f.state()["active"])
        retained = self.retained_bytes()
        self.assertIsNone(case["repairs"][REPAIR_PATHS[1]]["before"])
        self.assertIsNone(prior["pending"].get("submission_receipt"))
        self.assertEqual(self.target(case), self.target(case))
        self.assertEqual(self.retained_bytes(), retained)  # target helper is read-only
        result = self.adjudicate(case)
        self.assertEqual(result["status"], "REQUALIFICATION_REQUIRED")
        self.assertEqual(result["phase"], "IMPLEMENTING")
        f.w = project.load_session(f.root, f.chunk, "execution", test=True)
        state = f.state()
        active = state["active"]
        self.assertEqual(active["B"], prior["B"])
        self.assertEqual(active["requests"], prior["requests"])
        for key in ("pending", "R", "F", "self_review", "reassessment", "initial_handoff", "documentation", "report"):
            self.assertIsNone(active[key], key)
        for key in ("assessments", "reports", "reconciliations"):
            self.assertFalse(active[key], key)
        self.assertFalse(state["completed"])
        self.assertEqual(state["request_registry"][case["req"]["payload"]["request_id"]]["status"], "SUPERSEDED")
        adjudication = f.w.store.get(result["adjudication"], "noncanonical_adjudication")
        self.assertEqual(adjudication["prior_active"], prior)
        self.assertEqual(adjudication["evidence"], case["evidence"])
        self.assertEqual(adjudication["repairs"], case["repairs"])
        self.assert_preserved(retained)
        with self.assertRaises(Refusal):
            f.w.project_closure()
        with self.assertRaises(Refusal):
            f.w.initial_validation([case["ev"]])
        with self.assertRaises(Refusal):
            f.w.prepare_review("lit-review:C24:execution:too-early", [case["ev"]])
        with self.assertRaises(Refusal):
            self.adjudicate(case)
        fresh = f.w.parent_evidence("Fresh synthetic inspection after repair",
            "Synthetic PASS; no Lean or model executed.", "Only the temporary workflow model is exercised.")
        self.assertNotEqual(fresh, case["ev"])
        self.assertEqual(f.w.store.get(fresh)["noncanonical_adjudication"], result["adjudication"])
        f.w.initial_validation([fresh])
        f.w.self_review([], "Fresh synthetic contextual review.")
        f.w.reassess({})
        with self.assertRaises(Refusal):
            f.w.prepare_review(case["req"]["payload"]["request_id"], [fresh])
        new_req = f.w.prepare_review("lit-review:C24:execution:fresh", [fresh])
        self.assertEqual(new_req["payload"]["attempt"], 2)
        self.assertNotEqual(new_req["payload"]["source_ref"], case["req"]["payload"]["source_ref"])
        f.acknowledged_report(new_req)
        self.assertFalse(f.state()["completed"])
        f.w.reconcile_report()
        f.final_ready(fresh)
        closed = f.w.project_closure()
        self.assertFalse(closed["production_acceptance"])
        self.assertIn("C24.06", f.state()["completed"])
        self.assert_preserved(retained)

    def test_old_evidence_on_unchanged_repaired_source_is_still_not_fresh(self):
        f = self.f
        case = self.pending()
        # Model injection isolates the chronology guard: the evidence source is
        # already the repaired source, but its record predates adjudication.
        stale = []
        def record(state):
            evidence = copy.deepcopy(f.w.store.get(case["ev"], "evidence"))
            evidence["source"] = f.w._remember(state, "manifest", f.w.current(state, "EVIDENCE_SOURCE"))
            evidence["method"] = "Synthetic pre-adjudication evidence on repaired bytes"
            stale.append(f.w._remember(state, "evidence", evidence))
            state["active"]["evidence"].append(stale[0])
        f.w._change("SYNTHETIC_PRE_ADJUDICATION_EVIDENCE", record)
        self.adjudicate(case)
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_FRESH_VALIDATION_REQUIRED"):
            f.w.initial_validation(stale)

    def test_wrong_identity_or_request_binding_is_rejected(self):
        case = self.pending()
        for key, value in (("schema", 2), ("parent", "another-parent"), ("reviewer", "/root/another"),
                           ("request", "unknown-request"), ("source_ref", "0" * 64)):
            with self.subTest(key=key):
                bad = copy.deepcopy(case)
                bad["evidence"][key] = value
                with self.assertRaisesRegex(Refusal, "NONCANONICAL_BINDING"):
                    self.target(bad)
        with patch.dict(helpers.os.environ, {"CODEX_THREAD_ID": "foreign-parent"}):
            with self.assertRaisesRegex(Refusal, "WRONG_ORIGINATING_PARENT"):
                project.load_session(self.f.root, self.f.chunk, "execution", test=True)

    def test_malformed_frames_and_nonempty_native_result_are_rejected(self):
        case = self.pending()
        for key, value in (("native_call", ""), ("native_call", "{}"), ("native_call", '{"payload": []}'),
                           ("native_result", "{}"), ("native_result", '{"payload": null}')):
            with self.subTest(key=key, value=value):
                bad = copy.deepcopy(case)
                bad["evidence"][key] = value
                with self.assertRaises(Refusal):
                    self.target(bad)
        for key, field, value in (("native_call", "namespace", "other"),
                                 ("native_call", "name", "send_message"),
                                 ("native_result", "call_id", "another-call"),
                                 ("native_result", "output", "acknowledged")):
            with self.subTest(field=field, value=value):
                bad = copy.deepcopy(case)
                frame = json.loads(bad["evidence"][key])
                frame["payload"][field] = value
                bad["evidence"][key] = json.dumps(frame)
                with self.assertRaises(Refusal):
                    self.target(bad)

    def test_native_arguments_bind_recipient_and_keep_opaque_message_limits(self):
        case = self.pending()
        def with_arguments(arguments):
            changed = copy.deepcopy(case)
            frame = json.loads(changed["evidence"]["native_call"])
            frame["payload"]["arguments"] = arguments
            raw = json.dumps(frame)
            changed["evidence"]["native_call"] = raw
            changed["evidence"]["root_observation"]["physical_frames"]["call"] = digest(raw.encode())
            return changed
        # Only the readable outer target/message shape is checked. This fake
        # opaque message supplies no plaintext, delivery or acceptance evidence.
        opaque = {"target": self.f.reviewer, "message": "gAAAA-synthetic-not-plaintext"}
        self.target(with_arguments(json.dumps(opaque)))
        for arguments in (
            json.dumps({**opaque, "target": "/root/foreign-reviewer"}),
            json.dumps({"target": self.f.reviewer, "message": case["req"]["text"]}),
            "not-json-arguments",
            "gAAAA-not-a-readable-arguments-object",
        ):
            with self.subTest(arguments=arguments[:80]), self.assertRaises(Refusal):
                self.target(with_arguments(arguments))

    def test_observations_cannot_claim_delivery_complete_bytes_or_acceptance(self):
        case = self.pending()
        changes = [
            (("root_observation", "actor"), "/root/other"),
            (("root_observation", "native_call_id"), "other-call"),
            (("root_observation", "submission_id"), "pretend-receipt"),
            (("root_observation", "acceptance_credit"), True),
            (("root_observation", "status"), "PASS"),
            (("root_observation", "canonical_text_sha256"), "0" * 64),
            (("root_observation", "physical_frames", "call"), "0" * 64),
            (("root_observation", "known_example", "path"), "unregistered.lean"),
            (("reviewer_observation", "request_id"), "wrong-request"),
            (("reviewer_observation", "model_visible_comparison", "mismatches"), []),
            (("reviewer_observation", "model_visible_comparison", "full_received_hash_or_counts"), "0" * 64),
            (("reviewer_observation", "model_visible_comparison", "complete_mismatch_count"), 1),
            (("reviewer_observation", "native_received_event", "retained"), True),
            (("reviewer_observation", "native_received_event", "decoded_body_sha256"), "0" * 64),
            (("reviewer_observation", "native_received_event", "raw_sha256"), "0" * 64),
            (("reviewer_observation", "native_received_event", "raw_bytes"), "pretend raw event"),
            (("reviewer_observation", "partial_observations", "acceptance_credit"), True),
        ]
        for keys, value in changes:
            with self.subTest(keys=keys):
                bad = copy.deepcopy(case)
                cursor = bad["evidence"]
                for key in keys[:-1]:
                    cursor = cursor[key]
                cursor[keys[-1]] = value
                with self.assertRaises(Refusal):
                    self.target(bad)

    def test_qualification_requires_exact_source_and_independent_pass(self):
        case = self.pending()
        changes = [("source_digest", "0" * 64), ("tests", None), ("independent_review", {})]
        for key, value in changes:
            with self.subTest(key=key):
                bad = copy.deepcopy(case)
                bad["evidence"]["qualification"][key] = value
                with self.assertRaises(Refusal):
                    self.target(bad)
        for section, field, value in (("tests", "outcome", "FAIL"), ("tests", "original_text", " "),
                ("independent_review", "outcome", "FAIL"),
                ("independent_review", "actor", self.f.parent), ("independent_review", "actor", "/root")):
            with self.subTest(section=section, field=field, value=value):
                bad = copy.deepcopy(case)
                bad["evidence"]["qualification"][section][field] = value
                with self.assertRaises(Refusal):
                    self.target(bad)

    def test_authority_must_bind_exact_action_target_parent_and_original_user(self):
        f = self.f
        case = self.pending()
        target = self.target(case)["target"]
        good = f.auth("ADJUDICATE_NONCANONICAL_DISPATCH", target)
        variants = [None]
        for key, value in (("action", "RECOVER_RETRY"), ("target", "noncanonical-dispatch:" + "0" * 64),
                           ("binding", "0" * 64), ("contract_hash", "0" * 64)):
            bad = copy.deepcopy(good)
            bad[key] = value
            variants.append(bad)
        bad = copy.deepcopy(good)
        bad["provenance"]["role"] = "assistant"
        variants.append(bad)
        for approval in variants:
            with self.subTest(approval=approval), self.assertRaises(Refusal):
                f.w.adjudicate_noncanonical_dispatch(case["evidence"], case["repairs"], approval, "Synthetic reason")
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_REASON"):
            f.w.adjudicate_noncanonical_dispatch(case["evidence"], case["repairs"], good, " ")
        changed = copy.deepcopy(case)
        changed["evidence"]["qualification"]["tests"]["reference"] += "-changed"
        with self.assertRaisesRegex(Refusal, "AUTHORITY_SCOPE"):
            self.adjudicate(changed, good)
        self.adjudicate(case, good)

    def test_repairs_are_exact_allowed_before_and_after_bytes(self):
        case = self.pending()
        for label in ("empty", "missing-path", "wrong-before", "wrong-after", "extra-field", "forbidden-path"):
            with self.subTest(label=label):
                bad = copy.deepcopy(case)
                repairs = bad["repairs"]
                if label == "empty":
                    repairs.clear()
                elif label == "missing-path":
                    repairs.pop(REPAIR_PATHS[0])
                elif label == "wrong-before":
                    repairs[REPAIR_PATHS[0]]["before"] = None
                elif label == "wrong-after":
                    repairs[REPAIR_PATHS[0]]["after"] = "00"
                elif label == "extra-field":
                    repairs[REPAIR_PATHS[0]]["reason"] = "not an exact repair pair"
                else:
                    repairs["Case.lean"] = {"before": case["old"]["source_bytes"]["Case.lean"], "after": "00"}
                with self.assertRaises(Refusal):
                    self.target(bad)

    def test_no_source_change_is_not_an_adjudication_case(self):
        case = self.pending(repair=False)
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_REPAIR_SCOPE"):
            self.target(case)

    def test_unrelated_source_and_staged_git_drift_are_rejected(self):
        f = self.f
        case = self.pending()
        original = (f.root / "Case.lean").read_bytes()
        f.put("Case.lean", "-- Unrelated synthetic source drift.\n")
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_REPAIR_SCOPE"):
            self.target(case)
        (f.root / "Case.lean").write_bytes(original)
        f.git("add", REPAIR_PATHS[0])
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_GIT_DRIFT"):
            self.target(case)

    def test_candidate_ref_commit_and_tree_must_match(self):
        f = self.f
        case = self.pending()
        for key, value in (("ref", "refs/heads/other"), ("commit", "0" * 40), ("tree", "0" * 40)):
            with self.subTest(key=key):
                bad = copy.deepcopy(case)
                bad["evidence"]["candidate"][key] = value
                with self.assertRaises(Refusal):
                    self.target(bad)
        # Move only the candidate ref; HEAD/index and worktree remain unchanged.
        f.git("update-ref", CANDIDATE_REF, f.git("rev-parse", "HEAD^").decode().strip())
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_CANDIDATE_DRIFT"):
            self.target(case)

    def test_existing_submission_receipt_blocks_adjudication(self):
        f = self.f
        case = self.pending()
        receipt = f.w.record_submission(case["req"]["reference"], "UNCERTAIN", f.empty_submission(case["req"]))
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_PENDING_SCOPE"):
            self.target(case)
        self.assertEqual(f.w.store.get(receipt)["result"], "UNCERTAIN")

    def test_retained_receipt_without_pending_pointer_blocks_adjudication(self):
        f = self.f
        case = self.pending()
        original_change = f.w._change
        def interrupt_attachment(operation, action, *args, **kwargs):
            if operation == "RECORD_SUBMISSION_RESULT_NOT_REVIEW_COMPLETION":
                raise Refusal("SYNTHETIC_INTERRUPTION_BEFORE_RECEIPT_ATTACHMENT")
            return original_change(operation, action, *args, **kwargs)
        # Exercise the real first receipt transaction, then interrupt only the
        # second transaction in this isolated fixture. No live recorder is used.
        with patch.object(f.w, "_change", side_effect=interrupt_attachment):
            with self.assertRaisesRegex(Refusal, "SYNTHETIC_INTERRUPTION_BEFORE_RECEIPT_ATTACHMENT"):
                f.w.record_submission(case["req"]["reference"], "UNCERTAIN", f.empty_submission(case["req"]))
        self.assertIsNone(f.state()["active"]["pending"].get("submission_receipt"))
        retained = self.retained_bytes()
        receipts = [raw for raw in retained.values()
                    if json.loads(raw)["kind"] == "submission_observation"]
        self.assertEqual(len(receipts), 1)
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_ARRIVAL_EXISTS"):
            self.target(case)
        self.assert_preserved(retained)

    def test_report_capture_blocks_adjudication_even_without_receipt(self):
        f = self.f
        case = self.pending()
        req = case["req"]
        raw = f.report(req)
        captured = f.w.receive_report(raw, f.observation(req, raw), req["payload"]["request_id"], req["payload"]["attempt"])
        self.assertIsNotNone(captured["capture"])
        with self.assertRaises(Refusal):
            self.target(case)
        self.assertFalse(f.state()["completed"])

    def test_delivered_and_accepted_report_cannot_be_retired(self):
        f = self.f
        case = self.pending(repair=False)
        req = case["req"]
        receipt = f.w.record_submission(req["reference"], "UNCERTAIN", f.empty_submission(req))
        raw = f.report(req)
        delivered = f.w.confirm_delivery(req["reference"], receipt, raw, f.observation(req, raw),
            f.auth("CONFIRM_DIAGNOSTIC_DELIVERY", req["reference"]))
        self.assertFalse(delivered["report_accepted"])
        with self.assertRaises(Refusal):
            self.target(case)
        accepted = f.w.receive_report(raw, f.observation(req, raw), req["payload"]["request_id"], req["payload"]["attempt"])
        self.assertEqual(accepted["classification"], "VALID")
        with self.assertRaises(Refusal):
            self.target(case)
        self.assertFalse(f.state()["completed"])

    def test_pause_cancel_and_plan_restriction_remain_barriers(self):
        f = self.f
        case = self.pending()
        f.w.control("PAUSE", f.auth("PAUSE", f.w.plan_id))
        with self.assertRaisesRegex(Refusal, "AUTHORITY_PAUSED"):
            self.target(case)
        f.w.control("RELEASE", f.auth("RELEASE", f.w.plan_id))
        f.w.mark_plan_revision("synthetic-unapproved-plan-change")
        with self.assertRaisesRegex(Refusal, "AUTHORITY_PAUSED"):
            self.target(case)
        f.w.resolve_plan_revision(f.auth("RETAIN_ORIGINAL_PLAN", f.w.plan_id), retain_original=True)
        self.target(case)
        f.w.control("CANCEL", f.auth("CANCEL", f.w.plan_id))
        with self.assertRaisesRegex(Refusal, "AUTHORITY_PAUSED"):
            self.target(case)
        f.w.control("RELEASE", f.auth("RELEASE", f.w.plan_id))
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_PENDING_SCOPE"):
            self.target(case)

    def test_substantive_decision_obligation_is_not_discharged(self):
        f = self.f
        case = self.pending()
        f.w.block("LEAD_DECISION_REQUIRED")
        obligations = copy.deepcopy(f.state()["decision_obligations"])
        self.assertTrue(obligations)
        with self.assertRaisesRegex(Refusal, "RECOVERY_BLOCKER_UNSUPPORTED"):
            self.target(case)
        self.assertEqual(f.state()["decision_obligations"], obligations)

    def test_external_blocker_is_not_discharged(self):
        f = self.f
        case = self.pending()
        # An isolated model injection avoids fabricating an unrelated historical
        # finding solely to exercise the independent external-blocker guard.
        f.w._change("SYNTHETIC_EXTERNAL_BLOCKER", lambda state: state.update(external_blocker="SYNTHETIC_HISTORICAL_GAP"))
        with self.assertRaisesRegex(Refusal, "EXTERNAL_BLOCKER"):
            self.target(case)
        self.assertEqual(f.state()["external_blocker"], "SYNTHETIC_HISTORICAL_GAP")

    def test_wrong_step_is_outside_repair_scope(self):
        self.f.step = "C24.05"
        plan = (self.f.root / self.f.plan_path).read_text(encoding="utf-8")
        self.f.put(self.f.plan_path, plan + "\n## C24.05\nSynthetic out-of-scope step.\n")
        case = self.pending()
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_CASE_SCOPE"):
            self.target(case)

    def test_missing_native_criterion_is_outside_repair_scope(self):
        self.f.criterion_names = CRITERIA[:-1]
        case = self.pending()
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_CASE_SCOPE"):
            self.target(case)

    def test_plan_review_is_outside_repair_scope(self):
        f = self.f
        f.session("PLAN")
        req = f.w.plan_review_request("lit-review:C24:plan-fixture:noncanonical-exclusion")
        f.w.plan_review_record(req["reference"], "INTENT", "Synthetic passive plan intent", {})
        with self.assertRaisesRegex(Refusal, "NO_ACTIVE_STEP"):
            f.w.noncanonical_dispatch_target({}, {})
        with self.assertRaisesRegex(Refusal, "NO_ACTIVE_STEP"):
            f.w.adjudicate_noncanonical_dispatch({}, {}, None, "Synthetic plan exclusion")
        self.assertIsNone(f.state()["active"])
        self.assertFalse(f.state()["completed"])

    def test_legacy_transport_is_outside_repair_scope(self):
        self.f.collaboration = False
        case = self.pending(rejected_preflight=False)
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_INTENT"):
            self.target(case)

    def test_ordinary_recovery_still_refuses_unconfirmed_empty_submission(self):
        f = self.f
        case = self.pending(repair=False)
        for mode in ("continue", "retry", "reconcile"):
            with self.subTest(mode=mode), self.assertRaisesRegex(Refusal, "SUBMISSION_UNCERTAINTY_REQUIRES_SEPARATE_ADJUDICATION"):
                f.w.recover(f.auth("RECOVER_" + mode.upper(), "C24.06"), mode)
        receipt = f.w.record_submission(case["req"]["reference"], "UNCERTAIN", f.empty_submission(case["req"]))
        for mode in ("continue", "retry", "reconcile"):
            with self.subTest(receipt=receipt, mode=mode), self.assertRaisesRegex(Refusal, "SUBMISSION_UNCERTAINTY_REQUIRES_SEPARATE_ADJUDICATION"):
                f.w.recover(f.auth("RECOVER_" + mode.upper(), "C24.06"), mode)

    def test_ordinary_acknowledged_failure_recovery_is_unchanged(self):
        f = self.f
        case = self.pending(repair=False)
        observation = f.empty_submission(case["req"])
        observation["original_event"] = json.dumps({"task_name": f.reviewer})
        f.w.record_submission(case["req"]["reference"], "ACKNOWLEDGED", observation)
        f.w.block("SUSPENDED")
        f.w.recover(f.auth("RECOVER_RETRY", "C24.06"), "retry")
        self.assertEqual(f.state()["active"]["phase"], "REVIEW_READY")
        self.assertIsNone(f.state()["active"]["pending"])
        self.assertFalse(f.state()["completed"])


if __name__ == "__main__":
    unittest.main()
