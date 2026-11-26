"""Model-free, temporary-source-copy tests for bounded C24.06/C25.05/C26.05 repairs.

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


def source_copy_fixture(c25=False):
    # Keep this subclass local: unittest must not rediscover the entire inherited
    # ProjectWorkflowTests suite when discovering this focused test module.
    class Fixture(helpers.ProjectWorkflowTests):
        chunk = "C25" if c25 else "C24"
        reviewer = "/root/c25_reviewer" if c25 else "/root/c24_reviewer"
        plan_path = "docs/plans/release-3-chunk-25.md" if c25 else "docs/plans/post-release-chunk-24.md"
        step = "C25.05" if c25 else "C24.06"
        criterion_names = ("EXAMPLES", "CALLER") if c25 else CRITERIA
        collaboration = True

        def contract(self, kind="STEP"):
            criteria = [{
                "id": self.step + "-" + name, "description": "Synthetic " + name,
                "source_reference": self.plan_path + "#" + self.step.lower().replace(".", ""),
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
                    "task_name": self.reviewer.rsplit("/", 1)[1], "model": "gpt-6-astra", "reasoning_effort": "ultra",
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
    c25 = False

    def setUp(self):
        self.f = source_copy_fixture(self.c25)
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)
        f = self.f
        f.put(f.plan_path, "# Synthetic plan\n\n**Status:** Approved\n\n## " + f.step + "\n" +
              "\n".join("Synthetic Step 6 " + name + " obligation." for name in f.criterion_names) + "\n")
        if self.c25:
            f.put("README.md", "# Synthetic C25 source-copy fixture; no live README identity.\n")
            f.put("docs/plans/release-3-chunk-map.md", "# Synthetic C25--C40 map\n**Status:** Approved\n")
        # These are audited bytes in a temporary repository, never executable
        # replacements of the real adapter. The new test path is absent at R.
        f.put(REPAIR_PATHS[0], "# Synthetic adapter before repair.\n")
        f.put(REPAIR_PATHS[2], "# Synthetic operations before repair.\n")
        f.git("add", ".")
        f.git("commit", "-qm", "Synthetic " + f.step + " source-copy baseline")
        f.head = f.git("rev-parse", "HEAD").decode().strip()
        if not self.c25:
            f.git("update-ref", CANDIDATE_REF, f.head)

    def pending(self, *, kind="STEP", repair=True, rejected_preflight=True):
        f = self.f
        f.session(kind)
        if kind == "STEP":
            ev, req = f.prepared("noncanonical-original")
        else:
            ev = None
            req = f.w.plan_review_request(f"lit-review:{f.chunk}:plan-fixture:noncanonical-original")
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
            f.w.prepare_review(f"lit-review:{f.chunk}:execution:too-early", [case["ev"]])
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
        new_req = f.w.prepare_review(f"lit-review:{f.chunk}:execution:fresh", [fresh])
        self.assertEqual(new_req["payload"]["attempt"], 2)
        self.assertNotEqual(new_req["payload"]["source_ref"], case["req"]["payload"]["source_ref"])
        f.acknowledged_report(new_req)
        self.assertFalse(f.state()["completed"])
        f.w.reconcile_report()
        f.final_ready(fresh)
        closed = f.w.project_closure()
        self.assertFalse(closed["production_acceptance"])
        self.assertIn(f.step, f.state()["completed"])
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
        self.f.step = "C25.04" if self.c25 else "C24.05"
        plan = (self.f.root / self.f.plan_path).read_text(encoding="utf-8")
        self.f.put(self.f.plan_path, plan + "\n## " + self.f.step + "\nSynthetic out-of-scope step.\n")
        case = self.pending()
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_CASE_SCOPE"):
            self.target(case)

    def test_missing_native_criterion_is_outside_repair_scope(self):
        self.f.criterion_names = self.f.criterion_names[:-1]
        case = self.pending()
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_CASE_SCOPE"):
            self.target(case)

    def test_plan_review_is_outside_repair_scope(self):
        f = self.f
        f.session("PLAN")
        req = f.w.plan_review_request(f"lit-review:{f.chunk}:plan-fixture:noncanonical-exclusion")
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
                f.w.recover(f.auth("RECOVER_" + mode.upper(), f.step), mode)
        receipt = f.w.record_submission(case["req"]["reference"], "UNCERTAIN", f.empty_submission(case["req"]))
        for mode in ("continue", "retry", "reconcile"):
            with self.subTest(receipt=receipt, mode=mode), self.assertRaisesRegex(Refusal, "SUBMISSION_UNCERTAINTY_REQUIRES_SEPARATE_ADJUDICATION"):
                f.w.recover(f.auth("RECOVER_" + mode.upper(), f.step), mode)

    def test_ordinary_acknowledged_failure_recovery_is_unchanged(self):
        f = self.f
        case = self.pending(repair=False)
        observation = f.empty_submission(case["req"])
        observation["original_event"] = json.dumps({"task_name": f.reviewer})
        f.w.record_submission(case["req"]["reference"], "ACKNOWLEDGED", observation)
        f.w.block("SUSPENDED")
        f.w.recover(f.auth("RECOVER_RETRY", f.step), "retry")
        self.assertEqual(f.state()["active"]["phase"], "REVIEW_READY")
        self.assertIsNone(f.state()["active"]["pending"])
        self.assertFalse(f.state()["completed"])


class C25NoncanonicalDispatchTests(NoncanonicalDispatchTests):
    """Repeat all common refusal/freshness guards for the separate C25 case."""
    c25 = True

    def evidence(self, req, new):
        evidence = super().evidence(req, new)
        canonical = req["payload"]["source_inventory"]["README.md"]["sha256"]
        # Synthetic README has a synthetic hash. Exercise the same insertion
        # shape; the exact live pair is separately required in OBSERVED mode.
        observed = canonical[:31] + "71f" + canonical[31:]
        evidence["root_observation"]["known_example"] = {
            "path": "README.md", "canonical_sha256": canonical,
            "emitted_visible_sha256": observed}
        evidence["reviewer_observation"]["model_visible_comparison"]["mismatches"] = [{
            "field": "source_inventory[README.md].sha256",
            "model_visible_received": observed, "canonical": canonical}]
        evidence["candidate"] = {k: new["git"][k] for k in
                                 ("head", "index_entries_sha256", "cached_diff_sha256")}
        return evidence

    def test_candidate_ref_commit_and_tree_must_match(self):
        # This case has no C24 branch prerequisite and cannot borrow its evidence.
        f = self.f
        case = self.pending()
        self.target(case)
        for key, value in (("head", "0" * 40), ("index_entries_sha256", "0" * 64),
                           ("cached_diff_sha256", "0" * 64)):
            bad = copy.deepcopy(case)
            bad["evidence"]["candidate"][key] = value
            with self.subTest(key=key), self.assertRaisesRegex(Refusal, "NONCANONICAL_CANDIDATE"):
                self.target(bad)
        bad = copy.deepcopy(case)
        bad["evidence"]["candidate"] = {"ref": CANDIDATE_REF, "commit": f.head,
            "tree": f.git("rev-parse", f.head + "^{tree}").decode().strip()}
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_CANDIDATE"):
            self.target(bad)
        # A changing read after snapshot capture is also checked before mutation.
        real_git = project._git
        def moved_head(checkout, *args):
            return b"0" * 40 if args == ("rev-parse", "HEAD") else real_git(checkout, *args)
        with patch.object(project, "_git", side_effect=moved_head):
            with self.assertRaisesRegex(Refusal, "NONCANONICAL_CANDIDATE_DRIFT"):
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
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_CANDIDATE"):
            self.target(case)
        # Even updating the claimed candidate cannot authorize staged drift.
        case["evidence"]["candidate"]["index_entries_sha256"] = digest(f.git("ls-files", "--stage", "-z"))
        case["evidence"]["candidate"]["cached_diff_sha256"] = digest(
            f.git("diff", "--cached", "--binary", "--no-ext-diff", "--no-textconv"))
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_CANDIDATE"):
            self.target(case)

    def test_extra_criterion_is_outside_repair_scope(self):
        self.f.criterion_names += ("UNAPPROVED",)
        plan = (self.f.root / self.f.plan_path).read_text(encoding="utf-8")
        self.f.put(self.f.plan_path, plan + "Synthetic Step 6 UNAPPROVED obligation.\n")
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_CASE_SCOPE"):
            self.target(self.pending())

    def test_corroborated_other_mismatch_is_not_this_case(self):
        case = self.pending()
        canonical = case["evidence"]["root_observation"]["known_example"]["canonical_sha256"]
        for observed in (canonical, "0" * 64, "0" * 67, canonical[:31] + "000" + canonical[31:]):
            bad = copy.deepcopy(case)
            bad["evidence"]["root_observation"]["known_example"]["emitted_visible_sha256"] = observed
            bad["evidence"]["reviewer_observation"]["model_visible_comparison"]["mismatches"][0][
                "model_visible_received"] = observed
            with self.subTest(observed=observed), self.assertRaisesRegex(Refusal, "NONCANONICAL_KNOWN_MISMATCH"):
                self.target(bad)

    def test_observed_mode_does_not_accept_synthetic_incident_pins(self):
        case = self.pending()
        # A mode change first invalidates the recorded project profile. Exact
        # observed incident pins are exercised separately by C25ObservedPinTests.
        with patch.object(self.f.w, "mode", "OBSERVED"):
            with self.assertRaisesRegex(Refusal, "PROJECT_PROFILE_CHANGED"):
                self.target(case)


class C25ObservedPinTests(unittest.TestCase):
    """Pure structural tests of the live incident pins, never a live operation."""
    def pins(self):
        return {
            "request_ref": "1dbf1a64bcdb40c328073a04f1154e3843e79b3bb64cbcd9ce8cb733ac065d93",
            "payload": {
                "request_id": "lit-review:C25:execution:c25-05-r1-20261106", "attempt": 1,
                "source_ref": "4b1fb420550a05a552e868f76bf55a301416a9439d9d281d8e4656f617807767",
                "binding": {"project": "LeanInfoTheory", "checkout": "synthetic/checkout",
                    "chunk": "C25", "parent": "synthetic-c25-parent",
                    "reviewer": "/root/c25_reviewer", "session": "execution", "input_mode": "OBSERVED",
                    "tag": "LIT_SUPERVISED_REVIEW_V1", "generation": 1, "host": "local", "schema": 1}},
            "call": {"call_id": "synthetic-c25-native-call"},
            "example": {"path": "README.md",
                "canonical_sha256": "74c6c416f679b0af3a00d890944bf1e71f4268650ad177d9054713774bb8ff94",
                "emitted_visible_sha256": "74c6c416f679b0af3a00d890944bf1e71f71f4268650ad177d9054713774bb8ff94"},
            "candidate": {
                "head": "2eb80d0e746688511618aaefc2624ffa4ae88f6e",
                "index_entries_sha256": "3dc563e8c905ebcbd9ca18752d57526e3df8897ae2030d03e4cafcbcabf9cb59",
                "cached_diff_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"}}

    def setUp(self):
        # The historical predicate stays pinned to its original evidence in production.
        # Public fixtures exercise the same positive path and every field mutation.
        fixture = self.pins()
        binding = project.digest(fixture["payload"]["binding"])
        self.assertNotEqual(binding, project.C25_OBSERVED_BINDING_SHA256)
        pins = patch.multiple(project, C25_OBSERVED_BINDING_SHA256=binding,
                              C25_NATIVE_CALL_SHA256=project.digest(fixture["call"]["call_id"]))
        pins.start()
        self.addCleanup(pins.stop)

    def test_exact_observed_pin_tuple_and_each_wrong_component(self):
        pins = self.pins()
        project._check_c25_noncanonical_observed(**pins)
        fields = [("request_ref",), ("payload", "request_id"), ("payload", "attempt"),
                  ("payload", "source_ref"), ("call", "call_id")]
        fields += [("payload", "binding", k) for k in pins["payload"]["binding"]]
        fields += [("example", k) for k in pins["example"]]
        fields += [("candidate", k) for k in pins["candidate"]]
        for keys in fields:
            bad = copy.deepcopy(pins)
            cursor = bad
            for key in keys[:-1]:
                cursor = cursor[key]
            cursor[keys[-1]] = 2 if isinstance(cursor[keys[-1]], int) else "wrong-" + cursor[keys[-1]]
            with self.subTest(keys=keys), self.assertRaisesRegex(Refusal, "NONCANONICAL_C25_OBSERVED_CASE"):
                project._check_c25_noncanonical_observed(**bad)



C26_OMITTED_PATHS = (
    "LeanInfoTheory/Examples/Fano.lean",
    "LeanInfoTheory/Shannon/SemanticBridge/FiniteFamilyIndependence.lean",
)
C26_STOP_TEXT = (
    "Stopped the C26.05 review after confirming that the delivered request omitted two inventory entries. "
    "I sent the partial checks and interruption details to the parent. "
    "No criterion report or acceptance credit was issued."
)


def c26_source_copy_fixture():
    """A distinct REPLAYED fixture; existing C24/C25 constructors keep their defaults."""
    fixture = source_copy_fixture(c25=True)
    fixture.chunk = "C26"
    fixture.reviewer = "/root/c26_reviewer"
    fixture.plan_path = "docs/plans/release-3-chunk-26.md"
    fixture.step = "C26.05"
    fixture.criterion_names = ("RANDOMIZED", "SINGULAR")
    return fixture


class C26ReceiptDispatchTests(unittest.TestCase):
    """Synthetic tests for the one receipt-bearing C26 incident."""

    def setUp(self):
        self.f = c26_source_copy_fixture()
        self.f.setUp()
        self.addCleanup(self.f.doCleanups)
        f = self.f
        f.put(f.plan_path, "# Synthetic C26 plan\n\n**Status:** Approved\n\n## " + f.step + "\n" +
              "\n".join("Synthetic Step 6 " + name + " obligation." for name in f.criterion_names) + "\n")
        f.put("docs/plans/release-3-chunk-map.md", "# Synthetic C25--C40 map\n**Status:** Approved\n")
        for path in C26_OMITTED_PATHS:
            f.put(path, "-- Synthetic omission source at " + path + "\n")
        f.put(REPAIR_PATHS[0], "# Synthetic adapter before C26 repair.\n")
        f.put(REPAIR_PATHS[2], "# Synthetic operations before C26 repair.\n")
        f.git("add", ".")
        f.git("commit", "-qm", "Synthetic C26.05 source-copy baseline")
        f.head = f.git("rev-parse", "HEAD").decode().strip()
        self.receipt_result = "UNCERTAIN"

    def pending(self, **kwargs):
        return NoncanonicalDispatchTests.pending(
            self, rejected_preflight=False, **kwargs)

    def evidence(self, req, new):
        evidence = NoncanonicalDispatchTests.evidence(self, req, new)
        f = self.f
        root = evidence["root_observation"]
        root.pop("known_example")
        omissions = [{"path": path,
                      "canonical_sha256": req["payload"]["source_inventory"][path]["sha256"],
                      "emitted_visible_entry": None} for path in C26_OMITTED_PATHS]
        root["known_omissions"] = copy.deepcopy(omissions)
        root["receipt_canonical_claim_contradicted"] = True
        evidence["reviewer_observation"]["model_visible_comparison"] = {
            "known_omissions": copy.deepcopy(omissions),
            "full_received_hash_or_counts": None,
            "complete_mismatch_count": None,
        }
        evidence["candidate"] = {k: new["git"][k] for k in
                                 ("head", "index_entries_sha256", "cached_diff_sha256")}
        if self.receipt_result is None:
            receipt_ref, receipt = "0" * 64, {}
        else:
            observation = f.empty_submission(req)
            if self.receipt_result != "UNCERTAIN":
                observation["original_event"] = json.dumps(
                    {"task_name": f.reviewer} if self.receipt_result == "ACKNOWLEDGED"
                    else {"error": "Synthetic explicit failed send"})
            receipt_ref = f.w.record_submission(
                req["reference"], self.receipt_result, observation)
            receipt = f.w.store.get(receipt_ref, "submission_observation")
        evidence["contradicted_receipt"] = {
            "reference": receipt_ref, "record": receipt,
            "disposition": "CANONICAL_MESSAGE_CLAIM_CONTRADICTED",
            "acceptance_credit": False,
        }
        call_id = "synthetic-c26-stopped-review-call"
        evidence["stop_native_call"] = json.dumps({"payload": {
            "type": "function_call", "namespace": "collaboration", "name": "list_agents",
            "call_id": call_id, "arguments": json.dumps({"path_prefix": f.reviewer})}})
        evidence["stop_native_result"] = json.dumps({"payload": {
            "type": "function_call_output", "call_id": call_id,
            "output": json.dumps({"agents": [
                {"agent_name": f.reviewer, "agent_status": {"completed": C26_STOP_TEXT}}]})}})
        root["physical_frames"] = {key: digest(evidence[key].encode()) for key in
            ("native_call", "native_result", "stop_native_call", "stop_native_result")}
        return evidence

    target = NoncanonicalDispatchTests.target
    adjudicate = NoncanonicalDispatchTests.adjudicate
    retained_bytes = NoncanonicalDispatchTests.retained_bytes
    assert_preserved = NoncanonicalDispatchTests.assert_preserved

    def test_exact_uncertain_receipt_repair_preserves_history_and_requires_fresh_cycle(self):
        f = self.f
        case = self.pending()
        prior = copy.deepcopy(f.state()["active"])
        completed = copy.deepcopy(f.state()["completed"])
        receipt_ref = case["evidence"]["contradicted_receipt"]["reference"]
        original_receipt = copy.deepcopy(f.w.store.get(receipt_ref, "submission_observation"))
        self.assertEqual(prior["pending"]["submission_receipt"], receipt_ref)
        self.assertEqual(original_receipt["result"], "UNCERTAIN")
        self.assertEqual(original_receipt["observation"]["tool_call"]["arguments"]["message"],
                         case["req"]["text"])
        retained = self.retained_bytes()
        self.assertEqual(self.target(case), self.target(case))
        self.assertEqual(self.retained_bytes(), retained)
        result = self.adjudicate(case)
        self.assertEqual(result["status"], "REQUALIFICATION_REQUIRED")
        f.w = project.load_session(f.root, f.chunk, "execution", test=True)
        state = f.state()
        active = state["active"]
        self.assertEqual(active["phase"], "IMPLEMENTING")
        self.assertEqual(active["B"], prior["B"])
        self.assertEqual(active["requests"], prior["requests"])
        self.assertEqual(state["completed"], completed)
        self.assertEqual(f.w.identity.reviewer, "/root/c26_reviewer")
        for key in ("pending", "R", "F", "self_review", "reassessment",
                    "initial_handoff", "documentation", "report"):
            self.assertIsNone(active[key], key)
        for key in ("assessments", "reports", "reconciliations"):
            self.assertFalse(active[key], key)
        old_status = state["request_registry"][case["req"]["payload"]["request_id"]]
        self.assertEqual(old_status["status"], "SUPERSEDED")
        self.assertFalse(old_status["dispatched"])
        self.assertEqual(f.w.store.get(receipt_ref, "submission_observation"), original_receipt)
        recorded = f.w.store.get(result["adjudication"], "noncanonical_adjudication")
        self.assertEqual(recorded["prior_active"], prior)
        self.assertEqual(recorded["evidence"], case["evidence"])
        self.assert_preserved(retained)
        with self.assertRaises(Refusal):
            f.w.project_closure()
        with self.assertRaises(Refusal):
            f.w.initial_validation([case["ev"]])
        with self.assertRaises(Refusal):
            f.w.prepare_review("lit-review:C26:execution:premature", [case["ev"]])
        with self.assertRaises(Refusal):
            self.adjudicate(case)
        fresh = f.w.parent_evidence("Fresh synthetic C26 inspection",
            "Synthetic model PASS, no actual compiler or reviewer.",
            "Temporary source-copy fixture only.")
        f.w.initial_validation([fresh])
        f.w.self_review([], "Fresh synthetic contextual reassessment.")
        f.w.reassess({})
        with self.assertRaises(Refusal):
            f.w.prepare_review(case["req"]["payload"]["request_id"], [fresh])
        new_request = f.w.prepare_review("lit-review:C26:execution:fresh-after-repair", [fresh])
        self.assertEqual(new_request["payload"]["attempt"], 2)
        self.assertNotEqual(new_request["payload"]["source_ref"], case["req"]["payload"]["source_ref"])
        f.acknowledged_report(new_request)
        f.w.reconcile_report()
        f.final_ready(fresh)
        closed = f.w.project_closure()
        self.assertFalse(closed["production_acceptance"])
        self.assertIn("C26.05", f.state()["completed"])
        self.assert_preserved(retained)
        self.assertEqual(f.w.store.get(receipt_ref, "submission_observation"), original_receipt)

    def test_missing_or_nonuncertain_receipt_is_refused(self):
        for result in (None, "ACKNOWLEDGED", "FAILED"):
            with self.subTest(result=result):
                # Each case owns a new temporary fixture/session.
                other = type(self)(methodName="runTest")
                other.setUp()
                try:
                    other.receipt_result = result
                    case = other.pending()
                    with self.assertRaises(Refusal):
                        other.target(case)
                finally:
                    other.doCleanups()

    def test_receipt_reference_record_and_disposition_are_exact(self):
        case = self.pending()
        edits = [
            (("reference",), "f" * 64),
            (("record",), {}),
            (("record", "result"), "ACKNOWLEDGED"),
            (("record", "observation", "limits"), "Synthetic rewritten original"),
            (("record", "observation", "tool_call", "arguments", "message"), "Synthetic changed claim"),
            (("disposition",), "DELIVERY_CONFIRMED"),
            (("acceptance_credit",), True),
        ]
        for keys, value in edits:
            bad = copy.deepcopy(case)
            cursor = bad["evidence"]["contradicted_receipt"]
            for key in keys[:-1]:
                cursor = cursor[key]
            cursor[keys[-1]] = value
            with self.subTest(keys=keys), self.assertRaises(Refusal):
                self.target(bad)
        bad = copy.deepcopy(case)
        bad["evidence"]["root_observation"]["receipt_canonical_claim_contradicted"] = False
        with self.assertRaises(Refusal):
            self.target(bad)
        self.f.w._change("SYNTHETIC_MISSING_PENDING_RECEIPT_POINTER",
            lambda state: state["active"]["pending"].update(submission_receipt=None))
        with self.assertRaises(Refusal):
            self.target(case)

    def test_any_additional_retained_receipt_blocks_repair(self):
        f = self.f
        case = self.pending()
        req = case["req"]
        original = case["evidence"]["contradicted_receipt"]["reference"]
        before = self.retained_bytes()
        # Distinct synthetic provenance makes a second immutable receipt. An
        # identical duplicate content-addresses to the original ref instead.
        observation = f.empty_submission(req)
        observation["event_ref"] += "-distinct-second-observation"
        with self.assertRaisesRegex(Refusal, "SUBMISSION_ALREADY_RECORDED"):
            f.w.record_submission(req["reference"], "UNCERTAIN", observation)
        extra = [ref for ref in f.state()["records"] if ref not in before and
                 project.strict_json(f.w.fs.read(
                     f"{f.w.store.prefix}/objects/{ref}.json"))["kind"] == "submission_observation"]
        self.assertEqual(len(extra), 1)
        self.assertNotEqual(extra[0], original)
        record = f.w.store.get(extra[0], "submission_observation")
        self.assertEqual(record["request"], req["reference"])
        self.assertEqual(record["result"], "UNCERTAIN")
        self.assertEqual(record["observation"], observation)
        self.assertEqual(f.state()["active"]["pending"]["submission_receipt"], original)
        self.assert_preserved(before)
        retained = self.retained_bytes()
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_ARRIVAL_EXISTS"):
            self.target(case)
        self.assert_preserved(retained)

    def test_confirmed_delivery_or_accepted_report_cannot_be_superseded(self):
        f = self.f
        case = self.pending(repair=False)
        req = case["req"]
        receipt = case["evidence"]["contradicted_receipt"]["reference"]
        original = f.report(req)
        result = f.w.confirm_delivery(req["reference"], receipt, original,
            f.observation(req, original),
            f.auth("CONFIRM_DIAGNOSTIC_DELIVERY", req["reference"]))
        self.assertFalse(result["report_accepted"])
        with self.assertRaises(Refusal):
            self.target(case)
        accepted = f.w.receive_report(original, f.observation(req, original),
            req["payload"]["request_id"], req["payload"]["attempt"])
        self.assertEqual(accepted["classification"], "VALID")
        with self.assertRaises(Refusal):
            self.target(case)

    def test_exact_two_known_omissions_and_unknown_full_comparison_are_required(self):
        case = self.pending()
        root = case["evidence"]["root_observation"]["known_omissions"]
        variants = [[], root[:1], root + [root[0]]]
        for key, value in (("path", "Case.lean"), ("canonical_sha256", "0" * 64),
                           ("emitted_visible_entry", "0" * 64)):
            changed = copy.deepcopy(root)
            changed[0][key] = value
            variants.append(changed)
        for omissions in variants:
            bad = copy.deepcopy(case)
            bad["evidence"]["root_observation"]["known_omissions"] = omissions
            bad["evidence"]["reviewer_observation"]["model_visible_comparison"][
                "known_omissions"] = copy.deepcopy(omissions)
            with self.subTest(omissions=omissions), self.assertRaises(Refusal):
                self.target(bad)
        for field, value in (("complete_mismatch_count", 2),
                             ("full_received_hash_or_counts", "0" * 64)):
            bad = copy.deepcopy(case)
            bad["evidence"]["reviewer_observation"]["model_visible_comparison"][field] = value
            with self.subTest(field=field), self.assertRaises(Refusal):
                self.target(bad)
        bad = copy.deepcopy(case)
        bad["evidence"]["reviewer_observation"]["model_visible_comparison"]["known_omissions"] = []
        with self.assertRaises(Refusal):
            self.target(bad)

    def test_native_stopped_review_is_required_and_correlated(self):
        case = self.pending()
        for field in ("stop_native_call", "stop_native_result"):
            for value in ("", "{}", "not-json"):
                bad = copy.deepcopy(case)
                bad["evidence"][field] = value
                with self.subTest(field=field, value=value), self.assertRaises(Refusal):
                    self.target(bad)
        def change_stop(agents):
            bad = copy.deepcopy(case)
            frame = json.loads(bad["evidence"]["stop_native_result"])
            frame["payload"]["output"] = json.dumps({"agents": agents})
            bad["evidence"]["stop_native_result"] = json.dumps(frame)
            return bad
        good_entry = {"agent_name": self.f.reviewer,
                      "agent_status": {"completed": C26_STOP_TEXT}}
        for agents in (
            [],
            [good_entry, good_entry],
            [{"agent_name": "/root/other", "agent_status": {"completed": C26_STOP_TEXT}}],
            [{"agent_name": self.f.reviewer, "agent_status": "running"}],
            [{"agent_name": self.f.reviewer, "agent_status": {"completed": "Synthetic criterion PASS"}}],
        ):
            with self.subTest(agents=agents), self.assertRaises(Refusal):
                self.target(change_stop(agents))
        for field, value in (("call_id", "different-stop-call"), ("output", "not-json")):
            bad = copy.deepcopy(case)
            frame = json.loads(bad["evidence"]["stop_native_result"])
            frame["payload"][field] = value
            bad["evidence"]["stop_native_result"] = json.dumps(frame)
            with self.subTest(field=field), self.assertRaises(Refusal):
                self.target(bad)

    def test_observations_cannot_claim_plaintext_or_acceptance(self):
        case = self.pending()
        for keys, value in (
            (("root_observation", "acceptance_credit"), True),
            (("root_observation", "status"), "PASS"),
            (("root_observation", "submission_id"), "invented-id"),
            (("reviewer_observation", "native_received_event", "retained"), True),
            (("reviewer_observation", "native_received_event", "decoded_body_sha256"), "0" * 64),
            (("reviewer_observation", "partial_observations", "acceptance_credit"), True),
        ):
            bad = copy.deepcopy(case)
            cursor = bad["evidence"]
            for key in keys[:-1]:
                cursor = cursor[key]
            cursor[keys[-1]] = value
            with self.subTest(keys=keys), self.assertRaises(Refusal):
                self.target(bad)

    def test_wrong_step_extra_or_missing_criteria_are_outside_scope(self):
        f = self.f
        f.step = "C26.06"
        f.put(f.plan_path, (f.root / f.plan_path).read_text(encoding="utf-8") +
              "\n## C26.06\nSynthetic next step remains unauthorized.\n")
        with self.assertRaises(Refusal):
            self.target(self.pending())

    def test_plan_review_has_no_c26_receipt_recovery(self):
        f = self.f
        f.session("PLAN")
        req = f.w.plan_review_request("lit-review:C26:plan-fixture:excluded-repair")
        f.w.plan_review_record(req["reference"], "INTENT", "Synthetic passive plan", {})
        with self.assertRaises(Refusal):
            f.w.noncanonical_dispatch_target({}, {})
        with self.assertRaises(Refusal):
            f.w.adjudicate_noncanonical_dispatch({}, {}, None, "Synthetic excluded plan")

    def test_new_or_missing_criterion_is_outside_c26_case(self):
        for criterion_names in (("RANDOMIZED",), ("RANDOMIZED", "SINGULAR", "UNAPPROVED")):
            with self.subTest(criteria=criterion_names):
                other = type(self)(methodName="runTest")
                other.setUp()
                try:
                    other.f.criterion_names = criterion_names
                    text = (other.f.root / other.f.plan_path).read_text(encoding="utf-8")
                    if "UNAPPROVED" in criterion_names:
                        other.f.put(other.f.plan_path,
                            text + "Synthetic Step 6 UNAPPROVED obligation.\n")
                    with self.assertRaises(Refusal):
                        other.target(other.pending())
                finally:
                    other.doCleanups()

    def test_c26_protected_head_index_and_unrelated_source_are_checked(self):
        C25NoncanonicalDispatchTests.test_candidate_ref_commit_and_tree_must_match(self)
        # The C25 helper above already exercises each protected Git field and
        # the live Git reread. Use a fresh fixture for staging/source mutations.

    def test_source_and_staged_drift_cannot_be_relabelled_as_repair(self):
        C25NoncanonicalDispatchTests.test_unrelated_source_and_staged_git_drift_are_rejected(self)

    test_wrong_identity_or_request_binding_is_rejected = (
        NoncanonicalDispatchTests.test_wrong_identity_or_request_binding_is_rejected)
    test_malformed_frames_and_nonempty_native_result_are_rejected = (
        NoncanonicalDispatchTests.test_malformed_frames_and_nonempty_native_result_are_rejected)
    test_qualification_requires_exact_source_and_independent_pass = (
        NoncanonicalDispatchTests.test_qualification_requires_exact_source_and_independent_pass)
    test_authority_must_bind_exact_action_target_parent_and_original_user = (
        NoncanonicalDispatchTests.test_authority_must_bind_exact_action_target_parent_and_original_user)
    test_repairs_are_exact_allowed_before_and_after_bytes = (
        NoncanonicalDispatchTests.test_repairs_are_exact_allowed_before_and_after_bytes)
    test_pause_cancel_and_plan_restriction_remain_barriers = (
        NoncanonicalDispatchTests.test_pause_cancel_and_plan_restriction_remain_barriers)
    test_substantive_decision_obligation_is_not_discharged = (
        NoncanonicalDispatchTests.test_substantive_decision_obligation_is_not_discharged)
    test_external_blocker_is_not_discharged = (
        NoncanonicalDispatchTests.test_external_blocker_is_not_discharged)
    test_report_capture_blocks_adjudication = (
        NoncanonicalDispatchTests.test_report_capture_blocks_adjudication_even_without_receipt)
    test_pre_adjudication_evidence_is_not_fresh_even_on_repaired_bytes = (
        NoncanonicalDispatchTests.test_old_evidence_on_unchanged_repaired_source_is_still_not_fresh)

    def test_ordinary_recovery_still_refuses_this_uncertain_receipt(self):
        f = self.f
        self.pending()
        for mode in ("continue", "retry", "reconcile"):
            with self.subTest(mode=mode), self.assertRaisesRegex(
                    Refusal, "SUBMISSION_UNCERTAINTY_REQUIRES_SEPARATE_ADJUDICATION"):
                f.w.recover(f.auth("RECOVER_" + mode.upper(), f.step), mode)

    def test_observed_mode_refuses_synthetic_pins(self):
        case = self.pending()
        # As for C25, changing mode first invalidates the recorded profile;
        # C26ObservedPinTests separately exercises every exact incident pin.
        with patch.object(self.f.w, "mode", "OBSERVED"):
            with self.assertRaisesRegex(Refusal, "PROJECT_PROFILE_CHANGED"):
                self.target(case)


class C26ObservedPinTests(unittest.TestCase):
    """Pure pin comparisons with simulated frame digests, never live provenance."""

    FRAME_DIGESTS = {
        b"synthetic-native_call": "62fbfad3a0b6316a27fd1f736c05170d39989802233091ffc9d67caec2eac438",
        b"synthetic-native_result": "3e69a3ba8b455ba091ac02a601904c8c2cd7d651539e97e6f505b6535cc3979d",
        b"synthetic-stop_native_call": "334d6a2cc4ab8d1e8e764246b19a56125551a0dd6c3add62031e2c4b1059241d",
        b"synthetic-stop_native_result": "5f38f90bd85f18ed9ce51bc531ed6596d4013332f13dedd0e61888daee288120",
    }

    def pins(self):
        return {
            "request_ref": "dbabcf14746813d5e1b48bdaba6594449c80262e9f02f3a2012e006658bac7cd",
            "payload": {
                "request_id": "lit-review:C26:execution:c26-05-r1-20261107",
                "attempt": 1,
                "source_ref": "70b7b030b5ac6ba3b55e3a22b17e74ab7a5ca7631433d27040e3701d60ea8820",
                "binding": {
                    "project": "LeanInfoTheory",
                    "checkout": "synthetic/checkout",
                    "chunk": "C26",
                    "parent": "synthetic-c26-parent",
                    "reviewer": "/root/c26_reviewer",
                    "session": "execution",
                    "input_mode": "OBSERVED",
                    "tag": "LIT_SUPERVISED_REVIEW_V1",
                    "generation": 1, "host": "local", "schema": 1,
                },
            },
            "evidence": {
                "native_call": "synthetic-native_call",
                "native_result": "synthetic-native_result",
                "stop_native_call": "synthetic-stop_native_call",
                "stop_native_result": "synthetic-stop_native_result",
                "contradicted_receipt": {
                    "reference": "78516b58a05484259ff8f4ea4f4e1e2e4f43c936329ec3f6f7cafb885b2d1391"},
                "candidate": {
                    "head": "2eb80d0e746688511618aaefc2624ffa4ae88f6e",
                    "index_entries_sha256": "3dc563e8c905ebcbd9ca18752d57526e3df8897ae2030d03e4cafcbcabf9cb59",
                    "cached_diff_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
                },
            },
        }

    def setUp(self):
        # The historical predicate stays pinned to its original evidence in production.
        # Public fixtures exercise the same positive path and every field mutation.
        fixture = self.pins()
        binding = project.digest(fixture["payload"]["binding"])
        self.assertNotEqual(binding, project.C26_OBSERVED_BINDING_SHA256)
        pins = patch.multiple(project, C26_OBSERVED_BINDING_SHA256=binding)
        pins.start()
        self.addCleanup(pins.stop)

    def test_exact_pin_tuple_and_each_changed_component(self):
        # Only the pure pin predicate sees these simulated digests. The separate
        # REPLAYED integration tests parse synthetic frames through every guard.
        original_digest = project.digest
        def simulated_digest(value):
            if isinstance(value, bytes) and value in self.FRAME_DIGESTS:
                return self.FRAME_DIGESTS[value]
            return original_digest(value)
        pins = self.pins()
        with patch.object(project, "digest", side_effect=simulated_digest):
            project._check_c26_noncanonical_observed(**pins)
            keys = [("request_ref",), ("payload", "request_id"), ("payload", "attempt"),
                    ("payload", "source_ref"), ("evidence", "contradicted_receipt", "reference")]
            keys += [("payload", "binding", key) for key in pins["payload"]["binding"]]
            keys += [("evidence", key) for key in
                     ("native_call", "native_result", "stop_native_call", "stop_native_result")]
            keys += [("evidence", "candidate", key) for key in pins["evidence"]["candidate"]]
            for path in keys:
                bad = copy.deepcopy(pins)
                cursor = bad
                for key in path[:-1]:
                    cursor = cursor[key]
                old = cursor[path[-1]]
                cursor[path[-1]] = old + 1 if isinstance(old, int) else "wrong-" + old
                with self.subTest(path=path), self.assertRaisesRegex(
                        Refusal, "NONCANONICAL_C26_OBSERVED_CASE"):
                    project._check_c26_noncanonical_observed(**bad)



class C26CompactInventoryTests(unittest.TestCase):
    """Exact-r2 display tests in temporary REPLAYED source copies."""

    INVENTORY_PATH = ".lake/compatibility/c26-05-recovery-20261107/review-source-inventory.json"
    REQUEST_ID = "lit-review:C26:execution:c26-05-r2-20261107"
    setUp = C26ReceiptDispatchTests.setUp
    pending = C26ReceiptDispatchTests.pending
    evidence = C26ReceiptDispatchTests.evidence
    target = C26ReceiptDispatchTests.target
    adjudicate = C26ReceiptDispatchTests.adjudicate

    def ready(self):
        f = self.f
        case = self.pending()
        self.adjudicate(case)
        current = f.w.current(f.state(), "SYNTHETIC_R2_INVENTORY_SOURCE")
        inventory = {path: {"sha256": entry["hash"], "role": entry["role"]}
                     for path, entry in current["inventory"].items()}
        f.put(self.INVENTORY_PATH, json.dumps(inventory, sort_keys=True, indent=2))
        fresh = f.w.parent_evidence("Fresh synthetic repair inspection",
            "Synthetic PASS; no native model or Lean invoked.",
            "Only the temporary fixture source is assessed.")
        f.w.initial_validation([fresh])
        f.w.self_review([], "Fresh synthetic contextual review.")
        f.w.reassess({})
        return fresh, inventory, f.root / self.INVENTORY_PATH

    def prepare(self):
        fresh, inventory, path = self.ready()
        request = self.f.w.prepare_review(self.REQUEST_ID, [fresh])
        return request, inventory, path

    def test_compact_view_binds_entire_inventory_and_keeps_request_content(self):
        request, inventory, path = self.prepare()
        payload = request["payload"]
        view = json.loads(request["text"].split("\n\n", 1)[1])
        self.assertEqual(payload["attempt"], 2)
        self.assertEqual(payload["source_inventory"], inventory)
        self.assertNotIn("source_inventory", view)
        self.assertEqual(view, {key: value for key, value in payload.items()
                                if key != "source_inventory"})
        reference = view["source_inventory_reference"]
        self.assertEqual(reference["path"], self.INVENTORY_PATH)
        self.assertEqual(reference["sha256"], digest(path.read_bytes()))
        self.assertEqual(reference["bytes"], len(path.read_bytes()))
        self.assertEqual(reference["entries"], len(inventory))
        for omitted in C26_OMITTED_PATHS:
            self.assertIn(omitted, inventory)
        instructions = reference["instructions"]
        self.assertIn("read this entire JSON inventory", instructions)
        self.assertIn("verify its SHA256 and byte/entry counts", instructions)
        self.assertIn("paths/hashes/roles", instructions)
        for field in ("requirements", "binding", "source_ref", "report_format",
                      "review_rules", "library_rubric", "context_documents"):
            self.assertIn(field, view)
            self.assertEqual(view[field], payload[field])
        self.f.w.dispatch_intent(request["reference"])
        pending = self.f.state()["active"]["pending"]
        self.assertEqual(pending["diagnostic_intent"]["request_payload"], payload)

    def test_missing_inventory_refuses_preparation(self):
        fresh, _, path = self.ready()
        path.unlink()
        with self.assertRaisesRegex(Refusal, "C26_REVIEW_INVENTORY_MISSING"):
            self.f.w.prepare_review(self.REQUEST_ID, [fresh])

    def test_changed_inventory_map_refuses_preparation(self):
        fresh, inventory, path = self.ready()
        changed = copy.deepcopy(inventory)
        changed.pop(C26_OMITTED_PATHS[0])
        path.write_text(json.dumps(changed), encoding="utf-8")
        with self.assertRaisesRegex(Refusal, "C26_REVIEW_INVENTORY_MISMATCH"):
            self.f.w.prepare_review(self.REQUEST_ID, [fresh])

    def test_correct_contents_at_another_path_are_insufficient(self):
        fresh, inventory, path = self.ready()
        path.unlink()
        self.f.put(self.INVENTORY_PATH + ".other", json.dumps(inventory))
        with self.assertRaisesRegex(Refusal, "C26_REVIEW_INVENTORY_MISSING"):
            self.f.w.prepare_review(self.REQUEST_ID, [fresh])

    def test_missing_inventory_refuses_dispatch_after_preparation(self):
        request, _, path = self.prepare()
        path.unlink()
        with self.assertRaisesRegex(Refusal, "C26_REVIEW_INVENTORY_MISSING"):
            self.f.w.dispatch_intent(request["reference"])
        self.assertEqual(self.f.state()["active"]["phase"], "REVIEW_READY")

    def test_changed_map_refuses_dispatch_after_preparation(self):
        request, inventory, path = self.prepare()
        changed = copy.deepcopy(inventory)
        changed.pop(C26_OMITTED_PATHS[1])
        path.write_text(json.dumps(changed), encoding="utf-8")
        with self.assertRaisesRegex(Refusal, "C26_REVIEW_INVENTORY_MISMATCH"):
            self.f.w.dispatch_intent(request["reference"])

    def test_same_map_with_different_bytes_refuses_dispatch(self):
        request, inventory, path = self.prepare()
        path.write_text(json.dumps(inventory, indent=4), encoding="utf-8")
        self.assertEqual(json.loads(path.read_bytes()), inventory)
        with self.assertRaisesRegex(Refusal, "C26_REVIEW_INVENTORY_CHANGED"):
            self.f.w.dispatch_intent(request["reference"])
        self.assertEqual(self.f.state()["active"]["phase"], "REVIEW_READY")

    def test_other_second_request_keeps_complete_inline_inventory(self):
        fresh, _, _ = self.ready()
        request = self.f.w.prepare_review(
            "lit-review:C26:execution:another-second-request", [fresh])
        view = json.loads(request["text"].split("\n\n", 1)[1])
        self.assertEqual(view, request["payload"])
        self.assertIn("source_inventory", view)
        self.assertNotIn("source_inventory_reference", view)

    def test_attempt_one_with_the_planned_id_keeps_complete_inline_inventory(self):
        f = self.f
        f.session()
        _, request = f.prepared("c26-05-r2-20261107")
        self.assertEqual(request["payload"]["request_id"], self.REQUEST_ID)
        self.assertEqual(request["payload"]["attempt"], 1)
        view = json.loads(request["text"].split("\n\n", 1)[1])
        self.assertEqual(view, request["payload"])
        self.assertIn("source_inventory", view)
        self.assertNotIn("source_inventory_reference", view)


    def test_ordinary_unrelated_retry_with_planned_id_stays_inline_without_inventory(self):
        """An actual ordinary retry is not this incident, even with the same ID."""
        f = self.f
        f.session()
        ev, first = f.prepared("ordinary-unrelated-first")
        f.acknowledged_submission(first)
        f.w.block("SUSPENDED")
        f.w.recover(f.auth("RECOVER_RETRY", f.step), "retry")
        self.assertEqual(f.w._noncanonical_adjudications(f.state()), [])
        self.assertFalse((f.root / self.INVENTORY_PATH).exists())
        second = f.w.prepare_review(self.REQUEST_ID, [ev])
        self.assertEqual(second["payload"]["attempt"], 2)
        self.assertEqual(second["payload"]["request_id"], self.REQUEST_ID)
        self.assertFalse(f.w._incident_compact_request(second["payload"]))
        view = json.loads(second["text"].split("\n\n", 1)[1])
        self.assertEqual(view, second["payload"])
        self.assertIn("source_inventory", view)
        self.assertNotIn("source_inventory_reference", view)
        f.w.dispatch_intent(second["reference"])
        self.assertEqual(f.w._noncanonical_adjudications(f.state()), [])
        self.assertEqual(f.state()["active"]["pending"]["diagnostic_intent"]["request_payload"],
                         second["payload"])

    def test_compact_selector_requires_the_entire_current_binding(self):
        request, _, _ = self.prepare()
        w = self.f.w
        self.assertTrue(w._incident_compact_request(request["payload"]))
        for key in request["payload"]["binding"]:
            with self.subTest(binding_field=key):
                changed = copy.deepcopy(request["payload"])
                changed["binding"][key] = str(changed["binding"][key]) + "-unrelated"
                self.assertFalse(w._incident_compact_request(changed))

    def test_compact_selector_requires_related_history_and_fresh_current_request(self):
        """Pure selector adversaries: no writes to immutable synthetic history."""
        request, _, _ = self.prepare()
        w = self.f.w
        snapshot = w.journal.load()
        records = w._noncanonical_adjudications(snapshot["state"])
        self.assertEqual(len(records), 1)
        self.assertTrue(w._incident_compact_request(request["payload"]))
        with patch.object(w, "_noncanonical_adjudications", return_value=[]):
            self.assertFalse(w._incident_compact_request(request["payload"]))
            with self.assertRaisesRegex(Refusal, "C26_REVIEW_INVENTORY_SCOPE"):
                w.dispatch_intent(request["reference"])
        # Hold the already validated record constant while testing the selector's
        # additional relationship and freshness checks. The integrated positive
        # test above obtains these records through the real validator.
        for label, change in (
            ("other_baseline", lambda s: s["active"].update(B="unrelated-baseline")),
            ("other_original", lambda s: s["active"]["requests"].__setitem__(0, "unrelated-request")),
            ("stale_self_review", lambda s: s["active"].update(self_review=s["active"]["B"])),
            ("stale_reassessment", lambda s: s["active"].update(reassessment=s["active"]["B"])),
            ("missing_pending", lambda s: s["active"].update(pending=None)),
            ("other_pending", lambda s: s["active"]["pending"].update(request="unrelated-request")),
            ("other_source", lambda s: s["active"].update(R="unrelated-source")),
            ("other_phase", lambda s: s["active"].update(phase="IMPLEMENTING")),
        ):
            with self.subTest(scope=label):
                changed = copy.deepcopy(snapshot)
                change(changed["state"])
                with patch.object(w.journal, "load", return_value=changed), \
                     patch.object(w, "_noncanonical_adjudications", return_value=records):
                    self.assertFalse(w._incident_compact_request(request["payload"]))
        other = copy.deepcopy(request["payload"])
        other["source_inventory_reference"]["bytes"] += 1
        self.assertFalse(w._incident_compact_request(other))



class C28PreflightDispatchTests(unittest.TestCase):
    """REPLAYED rejected preflight with an independently correlated, unaccepted report."""

    REQUEST_ID = "lit-review:C28:execution:c28-01-r2-20261109"
    INVENTORY_PATH = ".lake/compatibility/c28-01-recovery-20261109/review-source-inventory.json"
    target = NoncanonicalDispatchTests.target
    adjudicate = NoncanonicalDispatchTests.adjudicate
    ready = C26CompactInventoryTests.ready
    prepare = C26CompactInventoryTests.prepare

    def setUp(self):
        f = self.f = source_copy_fixture(c25=True)
        f.chunk = "C28"
        f.step = "C28.01"
        f.reviewer = "/root/synthetic_c28_reviewer"
        f.plan_path = "docs/plans/release-3-chunk-28.md"
        f.criterion_names = ("SUM", "API")
        f.setUp()
        self.addCleanup(f.doCleanups)
        f.put(f.plan_path, "# Synthetic plan\n**Status:** Approved\n## C28.01\n" +
              "\n".join("Synthetic Step 6 " + name + " obligation." for name in f.criterion_names))
        f.put("docs/plans/release-3-chunk-map.md", "# Synthetic map\n")
        for path in REPAIR_PATHS:
            f.put(path, "# Synthetic before " + path + "\n")
        f.git("add", ".")
        f.git("commit", "-qm", "Synthetic C28.01 fixture")

    def pending(self):
        return NoncanonicalDispatchTests.pending(self, rejected_preflight=False)

    def evidence(self, req, new):
        f = self.f
        call_id = "synthetic-c28-dispatch"
        list_id = "synthetic-c28-report"
        args = {"target": f.reviewer.split("/")[-1], "message": "synthetic opaque argument"}
        list_args = {"path_prefix": f.reviewer}
        def invoked(name, identifier, arguments):
            return json.dumps({"payload": {"type": "function_call", "call_id": identifier,
                "namespace": "collaboration", "name": name, "arguments": json.dumps(arguments)}})
        def returned(identifier, output):
            return json.dumps({"payload": {"type": "function_call_output", "call_id": identifier,
                                           "output": output}})
        native_result = returned(call_id, "")
        obs = f.observation(req, original_event=native_result, event_ref="native:" + call_id,
                            tool_call={"name": "collaboration.followup_task", "arguments": args})
        with self.assertRaisesRegex(Refusal, "OBSERVED_SUBMISSION_TARGET"):
            f.w.record_submission(req["reference"], "UNCERTAIN", obs)
        preflight = f.state()["records"][-1]
        original = f.report(req)
        report_obs = f.observation(req, original, event_ref="native:" + list_id, tool_call={
            "name": "collaboration.list_agents", "arguments": list_args})
        canonical_text = req["text"].encode()
        return {"schema": 1, "preflight": preflight,
            "disposition": "REJECTED_PREFLIGHT_AND_ORIGINAL_REPORT_NO_CREDIT",
            "canonical_file": {"sha256": digest(canonical_text), "bytes": len(canonical_text),
                               "entries": len(req["payload"]["source_inventory"])},
            "native_call": invoked("followup_task", call_id, args), "native_result": native_result,
            "report_call": invoked("list_agents", list_id, list_args),
            "report_result": returned(list_id, report_obs["original_event"]),
            "original_report": original, "report_observation": json.dumps(report_obs),
            "candidate": {k: new["git"][k] for k in ("head", "index_entries_sha256", "cached_diff_sha256")},
            "qualification": NoncanonicalDispatchTests.evidence(self, req, new)["qualification"]}

    def test_exact_repair_retains_preflight_and_report_without_acceptance(self):
        f = self.f
        case = self.pending()
        old = copy.deepcopy(f.state()["active"])
        original = case["evidence"]["original_report"]
        preflight = case["evidence"]["preflight"]
        before = f.w.store.get(preflight, "native_submission_preflight")
        with self.assertRaisesRegex(Refusal, "SUBMISSION_UNCERTAINTY_REQUIRES_SEPARATE_ADJUDICATION"):
            f.w.recover(f.auth("RECOVER_RETRY", f.step), "retry")
        self.assertEqual(self.target(case), self.target(case))
        result = self.adjudicate(case)
        record = f.w.store.get(result["adjudication"], "noncanonical_adjudication")
        self.assertEqual(record["prior_active"], old)
        self.assertEqual(record["evidence"]["original_report"], original)
        self.assertEqual(f.w.store.get(preflight, "native_submission_preflight"), before)
        state = f.state()
        self.assertEqual(state["active"]["phase"], "IMPLEMENTING")
        self.assertEqual(state["active"]["B"], old["B"])
        for field in ("R", "F", "self_review", "reassessment", "pending", "report"):
            self.assertIsNone(state["active"][field], field)
        for field in ("assessments", "reports", "reconciliations"):
            self.assertFalse(state["active"][field], field)
        self.assertFalse(state["completed"])
        self.assertFalse(state["captures"])
        self.assertFalse(state["seen_reports"])
        with self.assertRaises(Refusal):
            f.w.initial_validation([case["ev"]])

    def test_rejects_unmatched_frames_forgeries_and_scope(self):
        case = self.pending()
        evidence = case["evidence"]
        def modified_frame(key, field, value):
            frame = json.loads(evidence[key])
            frame["payload"][field] = value
            return json.dumps(frame)
        for key, value in (
            ("canonical_file", {**evidence["canonical_file"], "bytes": 1}),
            ("canonical_file", {**evidence["canonical_file"], "sha256": "0"*64}),
            ("canonical_file", {**evidence["canonical_file"], "entries": 0}),
            ("native_result", modified_frame("native_result", "output", "{}")),
            ("report_result", modified_frame("report_result", "call_id", "different-id")),
            ("native_call", modified_frame("native_call", "arguments",
                json.dumps({"target": "different", "message": "synthetic opaque argument"}))),
            ("candidate", {**evidence["candidate"], "head": "f"*40}),
            ("report_observation", json.dumps({**json.loads(evidence["report_observation"]),
                "reviewer": "/root/different"})),
            ("original_report", evidence["original_report"] + " "),
            ("disposition", "ACCEPTED")):
            with self.subTest(key=key, value=value[:30] if isinstance(value,str) else value):
                with self.assertRaises(Refusal):
                    self.target({**case, "evidence": {**evidence, key: value}})
        with self.assertRaises(Refusal):
            self.adjudicate(case, self.f.auth("ADJUDICATE_NONCANONICAL_DISPATCH", "another-scope"))
        # Even a second, refused send to the correct recipient creates ambiguity.
        obs = self.f.empty_submission(case["req"])
        obs["tool_call"]["arguments"]["message"] = "different"
        with self.assertRaisesRegex(Refusal, "OBSERVED_SUBMISSION_MESSAGE"):
            self.f.w.record_submission(case["req"]["reference"], "UNCERTAIN", obs)
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_C28_PREFLIGHT_HISTORY"):
            self.target(case)

    def test_replacement_preserves_all_normative_text_and_rechecks_inventory(self):
        req, inventory, path = self.prepare()
        view = json.loads(req["text"].split("\n\n", 1)[1])
        payload = req["payload"]
        self.assertEqual(view, {k: v for k, v in payload.items() if k != "source_inventory"})
        self.assertEqual(payload["source_inventory"], inventory)
        ref = view["source_inventory_reference"]
        self.assertEqual((ref["path"], ref["sha256"], ref["bytes"], ref["entries"]),
                         (self.INVENTORY_PATH, digest(path.read_bytes()), path.stat().st_size, len(inventory)))
        with patch.object(self.f.w, "_noncanonical_adjudications", return_value=[]):
            with self.assertRaisesRegex(Refusal, "C28_REVIEW_INVENTORY_SCOPE"):
                self.f.w.dispatch_intent(req["reference"])
        raw = path.read_bytes()
        path.write_bytes(raw + b"\n")
        with self.assertRaisesRegex(Refusal, "C28_REVIEW_INVENTORY_CHANGED"):
            self.f.w.dispatch_intent(req["reference"])
        path.write_bytes(raw)
        self.f.w.dispatch_intent(req["reference"])
        # Replacement uses ordinary checks: opaque ciphertext does not match
        # the canonical message, and the actual empty result permits only UNCERTAIN.
        obs = self.f.empty_submission(req)
        obs["tool_call"]["arguments"]["message"] = "synthetic opaque string"
        with self.assertRaisesRegex(Refusal, "OBSERVED_SUBMISSION_MESSAGE"):
            self.f.w.record_submission(req["reference"], "UNCERTAIN", obs)
        with self.assertRaisesRegex(Refusal, "EMPTY_SUBMISSION_MUST_BE_UNCERTAIN"):
            self.f.w.record_submission(req["reference"], "ACKNOWLEDGED", self.f.empty_submission(req))
        receipt = self.f.w.record_submission(req["reference"], "UNCERTAIN", self.f.empty_submission(req))
        self.assertEqual(self.f.w.store.get(receipt)["result"], "UNCERTAIN")

    def test_any_receipt_blocks_this_no_receipt_case(self):
        case = self.pending()
        f = self.f
        receipt = f.w.record_submission(case["req"]["reference"], "UNCERTAIN",
                                        f.empty_submission(case["req"]))
        self.assertIn(receipt, f.state()["records"])
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_PENDING_SCOPE"):
            self.target(case)

    def test_failed_confirmation_with_only_a_delivery_basis_blocks_target(self):
        case = self.pending()
        f = self.f
        req = case["req"]
        original = case["evidence"]["original_report"]
        with self.assertRaisesRegex(Refusal, "UNKNOWN_DELIVERY_RECORD"):
            f.w.confirm_delivery(req["reference"], "0" * 64, original,
                                 f.observation(req, original), None)
        self.assertFalse(f.state()["captures"])
        self.assertFalse(f.state()["active"]["pending"].get("submission_receipt"))
        with self.assertRaisesRegex(Refusal, "NONCANONICAL_C28_OTHER_REQUEST_RECORD"):
            self.target(case)

    def test_nonempty_native_frame_does_not_acknowledge_its_empty_output(self):
        f = self.f
        f.session()
        _, req = f.prepared("wrapped-submission-result")
        f.w.dispatch_intent(req["reference"])
        for output in ("", "  ", "{}", "[]", "null"):
            frame = {"type": "function_call_output", "call_id": "synthetic-send", "output": output}
            for obj in (frame, {"type": "response_item", "payload": frame}):
                obs = f.empty_submission(req)
                obs["original_event"] = json.dumps(obj)
                for status in ("ACKNOWLEDGED", "FAILED"):
                    with self.subTest(output=output, status=status, wrapped="payload" in obj):
                        with self.assertRaisesRegex(Refusal, "EMPTY_SUBMISSION_MUST_BE_UNCERTAIN"):
                            f.w._check_collaboration_submission(req["reference"], status, obs)
        # Exercise both native representations through the normal entry point.
        empty_frame = {"type": "response_item", "payload": {
            "type": "function_call_output", "call_id": "synthetic-send", "output": ""}}
        for raw in (json.dumps(""), json.dumps(empty_frame)):
            for status in ("ACKNOWLEDGED", "FAILED"):
                obs = f.empty_submission(req)
                obs["original_event"] = raw
                with self.assertRaisesRegex(Refusal, "EMPTY_SUBMISSION_MUST_BE_UNCERTAIN"):
                    f.w.record_submission(req["reference"], status, obs)
                state = f.state()
                self.assertFalse(state["active"]["pending"].get("submission_receipt"))
                self.assertFalse(f.w._registration(state, req["reference"])["dispatched"])
                self.assertEqual(f.w._registration(state, req["reference"])["status"], "PENDING")
        frame = {"type": "function_call_output", "call_id": "synthetic-send"}
        obs = f.empty_submission(req)
        obs["original_event"] = json.dumps({"type": "response_item", "payload": frame})
        with self.assertRaisesRegex(Refusal, "OBSERVED_SUBMISSION_OUTPUT"):
            f.w.record_submission(req["reference"], "ACKNOWLEDGED", obs)
        frame["output"] = json.dumps({"task_name": "/root/wrong"})
        obs["original_event"] = json.dumps({"type": "response_item", "payload": frame})
        with self.assertRaisesRegex(Refusal, "OBSERVED_SUBMISSION_TARGET"):
            f.w.record_submission(req["reference"], "ACKNOWLEDGED", obs)
        frame["output"] = ""
        obs["original_event"] = json.dumps({"type": "response_item", "payload": frame})
        receipt = f.w.record_submission(req["reference"], "UNCERTAIN", obs)
        saved = f.w.store.get(receipt)["observation"]["original_event"]
        self.assertEqual(saved, obs["original_event"])
        self.assertEqual(f.state()["active"]["blocker"], "DISPATCH_UNCERTAIN")

    def test_extra_unregistered_arrival_blocks_target(self):
        case = self.pending()
        f = self.f
        req = case["req"]
        raw = case["evidence"]["original_report"]
        # Even when the ordinary recorder cannot accept an arrival without its
        # receipt, the registered capture prevents this incident-specific repair.
        f.w.receive_report(raw, f.observation(req, raw), req["payload"]["request_id"], 1)
        self.assertTrue(f.state()["captures"])
        with self.assertRaises(Refusal):
            self.target(case)


if __name__ == "__main__":
    unittest.main()
