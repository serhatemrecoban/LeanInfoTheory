"""Model-free REPLAYED delivery/format controls, never native reviewer calls."""
import copy
import json
import unittest

from diagnostic import create_toy, DiagnosticWorkflow, CRITERION
from safe_store import BUNDLE, Refusal, canonical, digest
from test_integration import IntegrationTests


class DeliveryTests(unittest.TestCase):
    auth=IntegrationTests.auth
    state=IntegrationTests.state
    refuse=IntegrationTests.refuse
    next=IntegrationTests.next
    ev=IntegrationTests.ev
    finding=IntegrationTests.finding
    prepared=IntegrationTests.prepared
    obs=IntegrationTests.obs
    submit=IntegrationTests.submit
    report=IntegrationTests.report
    receive=IntegrationTests.receive
    final_ready=IntegrationTests.final_ready

    def setUp(self):
        self.n=0
        self.w=create_toy('case-a','REPLAYED','replay-parent','replay-reviewer',
            profile={'parent_role':'/root','parent_task_id':'replay-parent'})
        self.w.initialize(['TEST-S01'],[CRITERION],self.auth('APPROVE_PLAN','fixture-plan:v1'))

    def arrival(self,req,raw):
        return self.obs(req,raw,original_event=json.dumps({'Message Type':'FINAL_ANSWER',
            'Task name':'/root','Sender':self.w.identity.reviewer,'Payload':raw}))

    def confirm(self,req,receipt,raw,observation=None,approval=None):
        return self.w.confirm_delivery(req['reference'],receipt,raw,
            self.arrival(req,raw) if observation is None else observation,
            self.auth('CONFIRM_DIAGNOSTIC_DELIVERY',req['reference']) if approval is None else approval)

    def confirmation_records(self):
        return [self.w.store.get(ref) for ref in self.state()['records']
            if self.w.store.get(ref).get('delivery_kind')=='REPORT_BACKED']

    def passive(self,status='UNCERTAIN'):
        req=self.w.detection_request('fixture-review-request:passive')
        self.w.detection_record(req['reference'],'INTENT','Synthetic replay intent',{})
        observation=self.obs(req,submission_result=status,original_event=json.dumps(''))
        if status=='ACKNOWLEDGED':
            result=self.w.detection_record(req['reference'],'SUBMISSION','',observation)
            receipt=result['record']
        else:
            self.refuse('DETECTION_SUBMISSION_UNCONFIRMED',lambda:self.w.detection_record(
                req['reference'],'SUBMISSION','',observation))
            receipt=[ref for ref in self.state()['records'] if self.w.store.get(ref).get('stage')=='SUBMISSION'][-1]
        return req,receipt

    def test_uncertain_report_confirmation_then_explicit_accept_reconcile_close(self):
        ev,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        original=self.w.fs.read('durable/objects/'+receipt+'.json')
        c=self.confirm(req,receipt,raw)
        self.assertFalse(c['report_accepted']);self.assertIsNone(self.state()['active']['report'])
        self.assertFalse(self.state()['completed']);self.assertEqual(self.state()['active']['phase'],'REVIEW_PENDING')
        self.assertEqual(self.w.fs.read('durable/objects/'+receipt+'.json'),original)
        self.w=DiagnosticWorkflow(self.w.fs,self.w.identity)
        result=self.receive(req,raw);self.assertEqual(result['classification'],'VALID')
        self.assertEqual(self.w.store.get(result['capture'],'capture')['original_text'],raw)
        self.w.reconcile_report();self.final_ready(ev)
        self.assertFalse(self.w.diagnostic_closure()['production_acceptance'])
        self.assertEqual(self.w.store.get(receipt,'submission_observation')['result'],'UNCERTAIN')

    def test_no_report_cannot_confirm_or_complete(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN')
        with self.assertRaises(Refusal):self.confirm(req,receipt,'',self.obs(req))
        self.assertFalse(self.confirmation_records())
        self.refuse('SUBMISSION_UNCERTAINTY_REQUIRES_SEPARATE_ADJUDICATION',
            lambda:self.w.recover(self.auth('RECOVER_RETRY','TEST-S01'),'retry'))
        self.assertEqual(self.next('after-absence')['status'],'SKIPPED_UNCLOSED')

    def test_original_output_and_observed_envelope_required(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        variants=[{'complete':False},{'text_role':'PARENT_SUMMARY'},{'extracted_text':'summary'},
            {'parent':'wrong-parent'},{'reviewer':'wrong-sender'},{'request_ref':'wrong'},
            {'origin':'UNSIGNED_OPERATOR_COPY'},{'original_event':'null'}]
        for changes in variants:
            o=self.arrival(req,raw);o.update(changes)
            with self.subTest(changes=changes),self.assertRaises(Refusal):self.confirm(req,receipt,raw,o)
        for field,value in [('Sender','body-claimed-reviewer'),('Task name','other-parent-role'),('Payload','summary')]:
            o=self.arrival(req,raw);e=json.loads(o['original_event']);e[field]=value;o['original_event']=json.dumps(e)
            with self.subTest(field=field),self.assertRaises(Refusal):self.confirm(req,receipt,raw,o)
        self.assertFalse(self.confirmation_records());self.assertFalse(self.state()['request_registry'][req['payload']['request_id']]['dispatched'])

    def test_wrong_request_attempt_binding_source_kind_refused(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN')
        for field,value in [('request_id','wrong'),('attempt',2),('source_ref','wrong'),('binding_digest','wrong'),('kind','PLAN')]:
            body=json.loads(self.report(req));body['report'][field]=value;raw=json.dumps(body)
            with self.subTest(field=field),self.assertRaises(Refusal):self.confirm(req,receipt,raw)
        self.assertFalse(self.confirmation_records())

    def test_current_source_must_match_then_positive_continuation(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        original=self.w.fs.read('project/Case.lean');self.w.fs.write('project/Case.lean',original+b'\n')
        self.refuse('SOURCE_DIVERGED',lambda:self.confirm(req,receipt,raw))
        self.w.fs.write('project/Case.lean',original)
        self.assertEqual(self.confirm(req,receipt,raw)['delivery'],'CONFIRMED_BY_ORIGINAL_REPORT')

    def test_negative_report_confirms_delivery_not_success(self):
        ev,req=self.prepared();receipt=self.submit(req,'UNCERTAIN')
        raw=self.report(req,[self.finding()],'CONTRADICTED_BY_FINDING',outcome='FAIL')
        self.confirm(req,receipt,raw);r=self.receive(req,raw)
        self.assertEqual(r['classification'],'VALID')
        e=self.w.store.get(r['capture'],'capture')['parsed']['verification'][0]
        self.assertEqual(self.w.store.get(e,'evidence')['outcome'],'FAIL')
        self.w.reconcile_report();self.final_ready(ev)
        with self.assertRaises(Refusal):self.w.diagnostic_closure()
        self.assertFalse(self.state()['completed'])

    def test_confirmation_is_not_report_validation(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN')
        body=json.loads(self.report(req));del body['report']['criteria'];raw=json.dumps(body)
        self.confirm(req,receipt,raw)
        self.assertEqual(self.receive(req,raw)['classification'],'INCOMPLETE')
        self.assertIsNone(self.state()['active']['report']);self.assertFalse(self.state()['completed'])

    def test_pause_can_release_but_cancel_cannot(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        self.w.control('PAUSE',self.auth('PAUSE','fixture-plan:v1'))
        self.refuse('AUTHORITY_PAUSED',lambda:self.confirm(req,receipt,raw))
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'))
        self.confirm(req,receipt,raw)
        self.setUp();_,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        self.w.control('CANCEL',self.auth('CANCEL','fixture-plan:v1'))
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'))
        with self.assertRaises(Refusal):self.confirm(req,receipt,raw)
        self.assertFalse(self.confirmation_records())

    def test_other_and_durable_blockers_not_cleared(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        self.w.block('LEAD_DECISION_REQUIRED');self.w.block('SUSPENDED')
        with self.assertRaises(Refusal):self.confirm(req,receipt,raw)
        self.assertTrue(self.state()['decision_obligations']);self.assertEqual(self.state()['active']['blocker'],'SUSPENDED')
        self.setUp();_,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        self.w.block('SUSPENDED')
        self.refuse('DELIVERY_UNRELATED_BLOCKER',lambda:self.confirm(req,receipt,raw))

    def test_duplicate_confirmation_idempotent_conflict_persistent(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        approval=self.auth('CONFIRM_DIAGNOSTIC_DELIVERY',req['reference'])
        first=self.confirm(req,receipt,raw,approval=approval)
        self.assertEqual(self.confirm(req,receipt,raw,approval=approval),first)
        self.assertEqual(len(self.confirmation_records()),1)
        self.refuse('REPORT_CONFLICT_UNRESOLVED',lambda:self.confirm(req,receipt,raw+' '))
        self.w.block('SUSPENDED')
        self.refuse('REPORT_CONFLICT_UNRESOLVED',lambda:self.confirm(req,receipt,raw))

    def test_conflicting_receive_after_delivery_never_accepted(self):
        _,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        self.confirm(req,receipt,raw)
        self.assertEqual(self.receive(req,raw+' ')['classification'],'CONFLICTING_DUPLICATE')
        self.assertIsNone(self.state()['active']['report'])

    def test_existing_deferred_report_can_continue_after_confirmation(self):
        ev,req=self.prepared();receipt=self.submit(req,'UNCERTAIN');raw=self.report(req)
        self.assertEqual(self.receive(req,raw)['classification'],'LATE_VALID_REPORT')
        self.confirm(req,receipt,raw)
        self.w.recover(self.auth('RECOVER_RECONCILE','TEST-S01'),'reconcile')
        self.w.reconcile_report();self.final_ready(ev);self.w.diagnostic_closure()

    def test_explicit_failures_refuse_both_paths(self):
        _,req=self.prepared();receipt=self.submit(req,'FAILED')
        self.refuse('DELIVERY_EXPLICIT_FAILURE',lambda:self.confirm(req,receipt,self.report(req)))
        self.setUp();req,receipt=self.passive('FAILED')
        self.refuse('DELIVERY_EXPLICIT_FAILURE',lambda:self.confirm(req,receipt,self.report(req)))

    def test_passive_positive_negative_and_duplicates(self):
        for negative in [False,True]:
            self.setUp();req,receipt=self.passive()
            raw=self.report(req,[self.finding()] if negative else [],
                'CONTRADICTED_BY_FINDING' if negative else 'SATISFIED',outcome='FAIL' if negative else 'PASS')
            prior=self.w.fs.read('durable/objects/'+receipt+'.json')
            self.confirm(req,receipt,raw)
            self.assertEqual(self.w.fs.read('durable/objects/'+receipt+'.json'),prior)
            r=self.w.detection_record(req['reference'],'REPORT',raw,self.arrival(req,raw))
            self.assertEqual(r['classification'],'VALID');self.assertFalse(r['normal_step_acceptance'])
            self.assertEqual(r['parsed']['criteria'][0]['status'],'CONTRADICTED_BY_FINDING' if negative else 'SATISFIED')
            self.assertIsNone(self.state()['active']);self.assertFalse(self.state()['completed'])
            self.assertEqual(self.w.detection_record(req['reference'],'REPORT',raw,self.arrival(req,raw))['classification'],'IDENTICAL_DUPLICATE')

    def test_passive_pause_cancel_and_conflict_preserved(self):
        req,receipt=self.passive();raw=self.report(req)
        self.w.control('PAUSE',self.auth('PAUSE','fixture-plan:v1'))
        self.refuse('AUTHORITY_PAUSED',lambda:self.confirm(req,receipt,raw))
        self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'));self.confirm(req,receipt,raw)
        self.assertEqual(self.w.detection_record(req['reference'],'REPORT',raw+' ',self.arrival(req,raw+' '))['classification'],'CONFLICTING_DUPLICATE')
        self.refuse('REPORT_CONFLICT_UNRESOLVED',lambda:self.confirm(req,receipt,raw))
        self.setUp();req,receipt=self.passive();raw=self.report(req)
        self.w.control('CANCEL',self.auth('CANCEL','fixture-plan:v1'));self.w.control('RELEASE',self.auth('RELEASE','fixture-plan:v1'))
        self.refuse('DETECTION_CANCELLED_NO_REACTIVATION',lambda:self.confirm(req,receipt,raw))

    def test_saved_report_replay_preserves_prose_and_original(self):
        ev,req=self.prepared();receipt=self.submit(req,'UNCERTAIN')
        original=(BUNDLE/'fixtures/saved-report.json').read_bytes();body=json.loads(original)
        prose=body['report']['earlier_reconciliation']
        # Only correlation/evidence ownership fields are rebound to this isolated
        # REPLAYED fixture. Mathematical prose, verdicts and outputs are unchanged.
        from dataclasses import asdict
        from safe_store import digest
        for k in ['request_id','attempt','source_ref','kind']:body['report'][k]=req['payload'][k]
        body['report']['binding_digest']=digest(asdict(self.w.identity))
        for e in body['new_evidence']:e['actor']=self.w.identity.reviewer;e['source_ref']=req['payload']['source_ref']
        raw=json.dumps(body,ensure_ascii=False)
        self.confirm(req,receipt,raw);r=self.receive(req,raw)
        self.assertEqual(r['classification'],'VALID')
        cap=self.w.store.get(r['capture'],'capture')
        self.assertEqual(cap['original_text'],raw);self.assertEqual(cap['parsed']['earlier_reconciliation'],[prose])
        self.assertEqual((BUNDLE/'fixtures/saved-report.json').read_bytes(),original)
        self.w.reconcile_report();self.final_ready(ev);self.w.diagnostic_closure()

    def test_prose_does_not_dispose_material_concern(self):
        ev,req=self.prepared();self.submit(req)
        body=json.loads(self.report(req,[self.finding()]));body['report']['earlier_reconciliation']='Still unresolved.\nKeep this exact text. '
        raw=json.dumps(body);r=self.receive(req,raw)
        self.assertEqual(self.w.store.get(r['capture'],'capture')['parsed']['earlier_reconciliation'],[body['report']['earlier_reconciliation']])
        self.w.reconcile_report();self.final_ready(ev)
        self.refuse('MATERIAL_FINDING_OPEN',self.w.diagnostic_closure)

    def test_existing_lists_preserved_and_other_invalid_types_refused(self):
        _,req=self.prepared();self.submit(req)
        body=json.loads(self.report(req))
        for bad in [None,{},4]:
            body['report']['earlier_reconciliation']=bad
            self.assertEqual(self.receive(req,json.dumps(body))['classification'],'INCOMPLETE')
        body['report']['earlier_reconciliation']=['Exact existing list note',{'retained':'structured entry'}]
        r=self.receive(req,json.dumps(body))
        self.assertEqual(self.w.store.get(r['capture'],'capture')['parsed']['earlier_reconciliation'],body['report']['earlier_reconciliation'])


class FormatConflictFixture:
    """Synthetic original arrivals; never read or modify a live chunk's records."""
    setUp = DeliveryTests.setUp
    auth = DeliveryTests.auth
    state = DeliveryTests.state
    refuse = DeliveryTests.refuse
    next = DeliveryTests.next
    ev = DeliveryTests.ev
    finding = DeliveryTests.finding
    prepared = DeliveryTests.prepared
    obs = DeliveryTests.obs
    submit = DeliveryTests.submit
    report = DeliveryTests.report
    final_ready = DeliveryTests.final_ready
    confirm = DeliveryTests.confirm
    fail_id = 'reviewer:format-context-transport'

    def arrival(self, req, raw):
        return self.obs(req, raw,
            event_ref='synthetic-replay:format-arrival-' + digest(raw.encode()),
            original_event=json.dumps({'Message Type': 'FINAL_ANSWER', 'Task name': '/root',
                'Sender': self.w.identity.reviewer, 'Payload': raw}))

    def capture_format_report(self, req, raw, **changes):
        observation = self.arrival(req, raw)
        observation.update(changes)
        return self.w.receive_report(raw, observation,
            req['payload']['request_id'], req['payload']['attempt'])

    def format_pair(self, initial_change=None, corrected_change=None):
        ev, req = self.prepared()
        receipt = self.submit(req, 'UNCERTAIN')
        body = json.loads(self.report(req))
        failure = copy.deepcopy(body['new_evidence'][0])
        failure.update(id=self.fail_id, outcome='FAIL',
            output='Synthetic failed transport probe; retained as a failed observation.')
        body['new_evidence'].append(failure)
        body['report']['verification'].append(self.fail_id)
        body['report']['criteria'][0]['evidence'].append(self.fail_id)
        body['report']['earlier_reconciliation'] = [
            'Verbatim fixture prose.\nRetain its whitespace. ',
            {'matrix': [{'id': 'C1', 'status': 'SATISFIED', 'note': 'Unchanged assessment'}]}]
        if initial_change:
            initial_change(body)
        initial_raw = json.dumps(body, indent=2)
        initial_observation = self.arrival(req, initial_raw)
        delivery = self.confirm(req, receipt, initial_raw, observation=initial_observation)
        initial = self.w.receive_report(initial_raw, initial_observation,
            req['payload']['request_id'], req['payload']['attempt'])
        self.assertEqual(initial['classification'], 'REPORT_EVIDENCE_INVALID')
        corrected = copy.deepcopy(body)
        corrected['report']['criteria'][0]['evidence'].remove(self.fail_id)
        if corrected_change:
            corrected_change(corrected)
        # Different JSON formatting is allowed; all decoded content except the
        # exact authorized citation must remain identical.
        corrected_raw = json.dumps(corrected, separators=(',', ':'))
        correction = self.capture_format_report(req, corrected_raw)
        self.assertEqual(correction['classification'], 'CONFLICTING_DUPLICATE')
        return dict(ev=ev, req=req, receipt=receipt, delivery=delivery,
            initial=initial['capture'], corrected=correction['capture'],
            initial_raw=initial_raw, corrected_raw=corrected_raw)

    def format_authority(self, pair):
        target = self.w.report_format_conflict_target(pair['initial'], pair['corrected'])
        return self.auth('RESOLVE_REPORT_FORMAT_CONFLICT', target)

    def resolve_format(self, pair, approval=None):
        return self.w.resolve_report_format_conflict(pair['initial'], pair['corrected'],
            self.format_authority(pair) if approval is None else approval)

    def retained_bytes(self):
        return {ref: self.w.fs.read('durable/objects/' + ref + '.json')
            for ref in self.state()['records']}

    def assert_retained(self, original):
        for ref, data in original.items():
            self.assertEqual(self.w.fs.read('durable/objects/' + ref + '.json'), data, ref)

    def assert_unaccepted(self):
        state = self.state()
        self.assertIsNone(state['active']['report'])
        self.assertFalse(state['active']['assessments'])
        self.assertFalse(state['completed'])
        with self.assertRaises(Refusal):
            self.w.reconcile_report()
        with self.assertRaises(Refusal):
            self.w.diagnostic_closure()


class ReportFormatConflictDeliveryTests(FormatConflictFixture, unittest.TestCase):
    def test_exact_authorized_single_fail_citation_resolution_retains_all_originals(self):
        pair = self.format_pair()
        before = self.retained_bytes()
        capture_refs = list(self.state()['captures'])
        target = self.w.report_format_conflict_target(pair['initial'], pair['corrected'])
        self.assertEqual(target,
            self.w.report_format_conflict_target(pair['initial'], pair['corrected']))
        result = self.resolve_format(pair)
        self.assertEqual(result['status'], 'RESOLVED_NOT_ACCEPTED')
        self.assertFalse(result['report_accepted'])
        self.assert_retained(before)
        self.assertEqual(self.state()['captures'], capture_refs)
        for key, classification in [('initial', 'REPORT_EVIDENCE_INVALID'),
                                     ('corrected', 'CONFLICTING_DUPLICATE')]:
            record = self.w.store.get(pair[key], 'capture')
            self.assertEqual(record['classification'], classification)
            self.assertEqual(record['original_text'], pair[key + '_raw'])
        corrected = json.loads(pair['corrected_raw'])
        self.assertIn(self.fail_id, corrected['report']['verification'])
        self.assertEqual(corrected['new_evidence'][1]['outcome'], 'FAIL')
        confirmation = self.w.store.get(pair['delivery']['confirmation'])
        self.assertEqual(confirmation['raw_sha256'], digest(pair['initial_raw'].encode()))
        self.assertEqual(self.w.store.get(pair['receipt'])['result'], 'UNCERTAIN')
        self.assert_unaccepted()

    def test_resolution_rejects_missing_wrong_and_reused_authority(self):
        pair = self.format_pair()
        good = self.format_authority(pair)
        delivery_authority = self.w.store.get(pair['delivery']['confirmation'])['authority']
        consumed_id = self.w.store.get(delivery_authority, 'authority')['id']
        variants = [None, {}, {**good, 'action': 'CONFIRM_DIAGNOSTIC_DELIVERY'},
            {**good, 'target': pair['req']['reference']}, {**good, 'binding': 'wrong-session'},
            {**good, 'contract_hash': 'wrong-contract'},
            {**good, 'id': consumed_id},
            {**good, 'provenance': {**good['provenance'], 'role': 'assistant'}}]
        for approval in variants:
            with self.subTest(approval=approval), self.assertRaises(Refusal):
                self.w.resolve_report_format_conflict(pair['initial'], pair['corrected'], approval)
        self.assert_unaccepted()
        self.resolve_format(pair, good)
        records = list(self.state()['records'])
        with self.assertRaises(Refusal):
            self.resolve_format(pair, good)
        self.assertEqual(self.state()['records'], records)
        self.assert_unaccepted()

    def test_resolution_rejects_every_broader_wrapper_delta(self):
        mutations = {
            'request': lambda b: b['report'].update(request_id='wrong-request'),
            'attempt': lambda b: b['report'].update(attempt=2),
            'R': lambda b: b['report'].update(source_ref='wrong-source'),
            'kind': lambda b: b['report'].update(kind='PLAN'),
            'binding': lambda b: b['report'].update(binding_digest='wrong-binding'),
            'scope': lambda b: b['report'].update(scope='Broader scope'),
            'prose': lambda b: b['report'].update(conclusion='Changed conclusion'),
            'matrix': lambda b: b['report']['earlier_reconciliation'][1]['matrix'][0].update(status='NOT_ESTABLISHED'),
            'criterion': lambda b: b['report']['criteria'][0].update(status='NOT_ESTABLISHED'),
            'other citation': lambda b: b['report']['criteria'][0]['evidence'].clear(),
            'findings': lambda b: b['report']['findings'].append(self.finding()),
            'FAIL outcome': lambda b: b['new_evidence'][1].update(outcome='PASS'),
            'evidence output': lambda b: b['new_evidence'][1].update(output='Changed observation'),
            'limitations': lambda b: b['new_evidence'][0].update(limitations='Erased replay limit'),
            'verification': lambda b: b['report']['verification'].remove(self.fail_id),
            'evidence deletion': lambda b: b['new_evidence'].pop(),
        }
        for name, mutate in mutations.items():
            with self.subTest(delta=name):
                self.setUp()
                pair = self.format_pair(corrected_change=mutate)
                before = self.retained_bytes()
                with self.assertRaises(Refusal):
                    self.resolve_format(pair)
                self.assert_retained(before)
                self.assert_unaccepted()

    def test_fail_must_remain_in_verification_and_removal_must_be_unique(self):
        modifications = {
            'missing verification': lambda b: b['report']['verification'].remove(self.fail_id),
            'duplicate citation': lambda b: b['report']['criteria'][0]['evidence'].append(self.fail_id),
        }
        for name, mutate in modifications.items():
            with self.subTest(case=name):
                self.setUp()
                pair = self.format_pair(initial_change=mutate)
                with self.assertRaises(Refusal):
                    self.resolve_format(pair)
                self.assert_unaccepted()

    def test_wrong_capture_order_and_non_original_origin_are_not_resolvable(self):
        pair = self.format_pair()
        approval = self.format_authority(pair)
        with self.assertRaises(Refusal):
            self.w.resolve_report_format_conflict(pair['corrected'], pair['initial'], approval)
        bad = self.capture_format_report(pair['req'], pair['corrected_raw'],
            reviewer='wrong-native-sender')
        self.assertNotEqual(bad['classification'], 'VALID')
        with self.assertRaises(Refusal):
            self.w.resolve_report_format_conflict(pair['initial'], bad['capture'], approval)
        self.assert_unaccepted()

    def test_unrelated_delivery_conflict_is_not_cleared_by_exact_pair(self):
        pair = self.format_pair()
        with self.assertRaises(Refusal):
            self.confirm(pair['req'], pair['receipt'], pair['corrected_raw'])
        with self.assertRaises(Refusal):
            self.resolve_format(pair)
        self.assert_unaccepted()
