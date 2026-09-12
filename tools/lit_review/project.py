"""LeanInfoTheory supervised adapter. Native operations stay in the calling agent.

Adapted from PFR-C02 on 2026-09-11; see PROVENANCE.md for source and licence.

Original fixture constructors remain guarded. This separate adapter reads real
Git/Lean/Markdown sources and writes only explicitly owned private records.
It validates structural evidence; it cannot authenticate a human or prove math.
"""
from dataclasses import asdict, dataclass
import copy
import json
import os
from pathlib import Path
import re
import sys
import uuid

CORE = Path(__file__).absolute().parent / 'core'
sys.path.insert(0, str(CORE))
from safe_store import FixtureFS, Store, Journal, Refusal, canonical, digest, require, strict_json, no_indirection
from contracts import Criterion, render_request, classify_report, same_source, delta, report_key
from workflow import Workflow
from diagnostic import DiagnosticWorkflow
from project_source import inspect_checkout, snapshot, _root, _path
from library import LIBRARY_RUBRIC, VALIDATION_GUIDANCE

PROJECT_TAG = 'LIT_SUPERVISED_REVIEW_V1'
TEST_TAG = 'LIT_SOURCE_COPY_TEST_V1'
PROFILE = {'model':'gpt-6-astra','reasoning_effort':'ultra','fork_context':False}
PLAN_START = '<!-- lit-review-status:start -->'
PLAN_END = '<!-- lit-review-status:end -->'


def creation_transport(creation):
    """The omitted discriminator retains the installed legacy binding contract."""
    transport = creation.get('transport', 'multi_agent_v1')
    require(isinstance(transport, str) and transport in {'multi_agent_v1', 'collaboration'},
            'NATIVE_TRANSPORT')
    return transport


def check_creation_transport(creation, parent, reviewer):
    original = creation['original_result']
    if isinstance(original, str):
        original = strict_json(original)
    transport = creation_transport(creation)
    if transport == 'multi_agent_v1':
        require(isinstance(original, dict) and original.get('agent_id') == reviewer,
                'CREATION_IDENTITY_MISMATCH')
        return
    call = creation.get('tool_call')
    require(isinstance(call, dict) and call.get('name') == 'collaboration.spawn_agent'
            and isinstance(call.get('arguments'), dict), 'CREATION_NATIVE_CALL')
    args = call['arguments']
    require(set(args) == {'task_name', 'message', 'model', 'reasoning_effort', 'fork_turns'}
            and isinstance(args['task_name'], str)
            and re.fullmatch(r'[a-z0-9_]+', args['task_name'])
            and isinstance(args['message'], str) and args['message'].strip()
            and args['model'] == PROFILE['model']
            and args['reasoning_effort'] == PROFILE['reasoning_effort']
            and args['fork_turns'] == 'none', 'CREATION_NATIVE_ARGUMENTS')
    role = creation.get('parent_role')
    require(creation.get('parent_task_id') == parent and isinstance(role, str)
            and re.fullmatch(r'/root(?:/[a-z0-9_]+)*', role), 'CREATION_NATIVE_PARENT')
    require(isinstance(original, dict) and 'agent_id' not in original
            and original.get('task_name') == reviewer
            and reviewer == role + '/' + args['task_name'], 'CREATION_IDENTITY_MISMATCH')


def chunk_id(value):
    require(isinstance(value,str) and re.fullmatch(r'C(?:0?9|1[0-9]|2[0-4])',value), 'CHUNK_BINDING')
    return 'C'+str(int(value[1:]))


def step_chunk(value):
    require(isinstance(value,str) and re.fullmatch(r'C(?:0?9|1[0-9]|2[0-4])\.[0-9]{2}',value), 'STEP_SCHEMA')
    return chunk_id(value.split('.')[0])


def plan_text(raw):
    """Only an explicitly marked status block is editorial; no Markdown parser."""
    text=raw.decode('utf-8')
    require(text.count(PLAN_START)==text.count(PLAN_END) and text.count(PLAN_START)<=1,
            'PLAN_STATUS_MARKERS')
    if PLAN_START in text:
        before,rest=text.split(PLAN_START)
        metadata,after=rest.split(PLAN_END)
        return before+PLAN_START+PLAN_END+after
    return text


def user_origin(value):
    require(isinstance(value,dict) and value.get('role')=='user'
            and isinstance(value.get('reference'),str) and value['reference'].strip()
            and isinstance(value.get('original_text'),str) and value['original_text'].strip(),
            'ACTUAL_USER_REFERENCE_REQUIRED')
    return copy.deepcopy(value)


class ProjectRecordFS(FixtureFS):
    """Separate guarded private store. Inherited safe IO, never fixture cleanup."""
    def __init__(self, checkout, relative, *, create=False, test=False):
        self.checkout=_root(checkout)
        self.record_tag=TEST_TAG if test else PROJECT_TAG
        require(re.fullmatch(r'(?:chunks/C(?:9|1[0-9]|2[0-4])(?:/(?:execution|plan-[a-z0-9-]+))?|setup)',relative),
                'PRIVATE_RECORD_LOCATION')
        self.root=self.checkout/'.lit-review'/relative
        no_indirection(self.root)
        installation=self.checkout/'.lit-review/installation.json'
        require(installation.is_file(),'RUN_SETUP_FIRST')
        self.installation=strict_json(installation.read_bytes())
        require(self.installation.get('tag')==self.record_tag
                and self.installation.get('checkout')==str(self.checkout),'PRIVATE_STORE_BINDING')
        marker=self.root/'.project-owner.json'
        if create:
            require(not self.root.exists(),'PROJECT_STORE_ALREADY_EXISTS')
            self.root.mkdir(parents=True)
            no_indirection(self.root)
            with marker.open('xb') as f:
                f.write(canonical({'tag':self.record_tag,'root':str(self.root),'owner':uuid.uuid4().hex}))
        no_indirection(marker)
        require(marker.is_file(),'NO_PROJECT_OWNERSHIP')
        self.owner=strict_json(marker.read_bytes())
        require(self.owner.get('tag')==self.record_tag and self.owner.get('root')==str(self.root),
                'PROJECT_OWNER_MISMATCH')

    def path(self, rel):
        require(isinstance(rel,str) and re.fullmatch(r'[A-Za-z0-9_.\-/]+',rel) is not None,
                'UNSAFE_PATH')
        require(all(x not in {'','.', '..'} and not x.endswith(('.', ' '))
                    and x.split('.')[0].upper() not in {'CON','PRN','AUX','NUL',*[f'COM{i}' for i in range(10)],*[f'LPT{i}' for i in range(10)]}
                    for x in rel.split('/')), 'UNSAFE_PATH')
        no_indirection(self.root)
        marker=self.root/'.project-owner.json'
        no_indirection(marker)
        require(strict_json(marker.read_bytes())==self.owner,'OWNERSHIP_CHANGED')
        target=self.root/rel
        no_indirection(target)
        require(target.resolve().is_relative_to(self.root.resolve()),'PATH_ESCAPE')
        return target

    def cleanup_scratch(self):
        raise Refusal('PROJECT_RECORDS_EXCLUDED_FROM_CLEANUP')


def setup(checkout, approval, *, test=False):
    root=_root(checkout); info=inspect_checkout(root)
    user_origin(approval)
    tag=TEST_TAG if test else PROJECT_TAG
    if not test:
        import tomllib
        require(tomllib.loads(info['configuration']['lakefile.toml']['text']).get('name')=='LeanInfoTheory',
                'NOT_LEANINFOTHEORY_CHECKOUT')
        require('LeanInfoTheory' not in info['dependencies'], 'LIBRARY_CANNOT_DEPEND_ON_ITSELF')
    from project_source import _git
    require(_git(root,'check-ignore','.lit-review/',absent=True) is not None,'PRIVATE_STORE_MUST_BE_IGNORED')
    private=root/'.lit-review'; no_indirection(private)
    private.mkdir(exist_ok=True)
    path=private/'installation.json'; no_indirection(path)
    if path.exists():
        data=strict_json(path.read_bytes())
        require(data.get('tag')==tag and data.get('checkout')==str(root),'INSTALLATION_CONFLICT')
        return data
    data={'schema':1,'tag':tag,'checkout':str(root),'supervised_only':True,
          'approval':approval,'historical_baseline':info['historical_baseline'],
          'installer_parent':os.environ.get('CODEX_THREAD_ID'),
          'profile_requested':PROFILE,'mathematical_execution_authorized':False,
          'storage_limit':'Local disk only; manual backup outside this checkout is required for device-loss protection.'}
    with path.open('xb') as f:f.write(canonical(data))
    return data


def bind(checkout, chunk, parent, reviewer, creation, approval, *, test=False):
    chunk=chunk_id(chunk)
    require(parent==os.environ.get('CODEX_THREAD_ID') and parent!=reviewer,'WRONG_ORIGINATING_PARENT')
    require(isinstance(creation,dict) and reviewer
            and creation.get('parent_purpose')=='CHUNK_IMPLEMENTATION', 'CHUNK_IMPLEMENTATION_PARENT_REQUIRED')
    user_origin(approval)
    require(isinstance(creation,dict) and creation.get('canonical_reviewer')==reviewer
            and creation.get('requested')==PROFILE and creation.get('original_result')
            and creation.get('reference') and creation.get('parent_role'), 'ORIGINAL_REVIEWER_CREATION_REQUIRED')
    check_creation_transport(creation,parent,reviewer)
    installation=strict_json((Path(checkout)/'.lit-review/installation.json').read_bytes())
    require(test or parent!=installation.get('installer_parent'),'INSTALLER_BINDING_NOT_TRANSFERABLE')
    effective=creation.get('effective_reviewer')
    if effective is not None:
        require(isinstance(effective,dict),'EFFECTIVE_PROFILE_SCHEMA')
        require(effective.get('model') in {None,PROFILE['model']}
                and effective.get('reasoning_effort') in {None,PROFILE['reasoning_effort']}
                and effective.get('fork_context') in {None,False},'OBSERVED_PROFILE_CONFLICT')
    # The agent verifies the actual native result, not an inferred UUID/profile.
    # This supplied record and instruction-only isolation are cooperative limits.
    fs=ProjectRecordFS(checkout,'chunks/'+chunk,create=True,test=test)
    data={'chunk':chunk,'parent':parent,'reviewer':reviewer,'creation':creation,'approval':approval,
          'input_mode':'REPLAYED' if test else 'OBSERVED','tag':fs.record_tag,
          'effective_parent':creation.get('effective_parent'),'effective_reviewer':effective}
    fs.write('binding.json',canonical(data),exclusive=True)
    return data


@dataclass(frozen=True)
class ProjectIdentity:
    project: str
    checkout: str
    chunk: str
    parent: str
    reviewer: str
    session: str
    input_mode: str
    tag: str
    generation: int=1
    host: str='local'
    schema: int=1

    def validate(self, fs):
        require(type(fs) is ProjectRecordFS and self.checkout==str(fs.checkout)
                and self.project=='LeanInfoTheory'
                and self.tag==fs.record_tag,'PROJECT_IDENTITY')
        require(self.parent!=self.reviewer
                and self.input_mode==('REPLAYED' if self.tag==TEST_TAG else 'OBSERVED'), 'PROJECT_BINDING')


def verify_contract(root, contract, *, first=False):
    require(isinstance(contract,dict) and set(contract)=={'plan_path','plan_sha256','kind','scope','steps','plan_criteria','normative_anchors'},
            'PROJECT_CONTRACT_SCHEMA')
    path=contract['plan_path']
    require(isinstance(path,str) and path.startswith('docs/plans/') and path.endswith('.md'),'PLAN_LOCATION')
    raw=_path(root,path).read_bytes()
    if first:require(digest(raw)==contract['plan_sha256'],'APPROVED_PLAN_BYTES_MISMATCH')
    require(contract['kind'] in {'STEP','PLAN'} and isinstance(contract['scope'],list),'PROJECT_CONTRACT_SCHEMA')
    require(contract['normative_anchors'] and all(isinstance(x,str) and x.strip()
                and x in plan_text(raw) for x in contract['normative_anchors']),'NORMATIVE_ANCHOR_MISSING')
    if contract['kind']=='STEP':
        require(re.search(r'(?im)^\*\*(?:Plan status|Status):\*\*\s*(Approved|Active)\b',raw.decode()),'NO_APPROVED_PLAN')
        require(contract['steps'] and not contract['plan_criteria'],'STEP_CONTRACT')
    else:require(contract['plan_criteria'] and not contract['steps'],'PLAN_REVIEW_NOT_EXECUTION')
    ids=[]; criterion_ids=[]
    groups=[contract['plan_criteria']]
    for step in contract['steps']:
        require(isinstance(step,dict) and set(step)=={'id','criteria'}, 'STEP_SCHEMA')
        step_chunk(step['id'])
        require(step['id'] in raw.decode() and step['criteria'],'STEP_SOURCE_ANCHOR')
        ids.append(step['id']); groups.append(step['criteria'])
    require(len(ids)==len(set(ids)),'DUPLICATE_STEP')
    for group in groups:
        for criterion in group:
            c=Criterion(**criterion); c.validate()
            require(c.normative_excerpt in plan_text(raw) and c.source_reference.startswith(path+'#'), 'CRITERION_SOURCE_ANCHOR')
            criterion_ids.append(c.id)
    require(len(criterion_ids)==len(set(criterion_ids)),'DUPLICATE_CRITERION')
    return {'definition':contract,'normative_plan_sha256':digest(plan_text(raw).encode())}


def open_session(checkout, chunk, session, contract, approval, *, test=False):
    chunk=chunk_id(chunk)
    binding_fs=ProjectRecordFS(checkout,'chunks/'+chunk,test=test)
    binding=strict_json(binding_fs.read('binding.json'))
    require(binding['parent']==os.environ.get('CODEX_THREAD_ID'),'WRONG_ORIGINATING_PARENT')
    require(session=='execution' if contract['kind']=='STEP' else bool(re.fullmatch('plan-[a-z0-9-]+',session)),
            'SESSION_KIND')
    checked=verify_contract(binding_fs.checkout,contract,first=True)
    if contract['kind']=='STEP':
        require(all(step_chunk(x['id'])==chunk for x in contract['steps']),'CROSS_CHUNK_PLAN')
        require(approval.get('scope')=='APPROVED_IMPLEMENTATION_PLAN','EXACT_PLAN_APPROVAL_REQUIRED')
        require(approval.get('plan_sha256')==contract['plan_sha256'],'EXACT_PLAN_APPROVAL_REQUIRED')
    else:require(approval.get('scope')=='PLAN_REVIEW','EXPLICIT_PLAN_REVIEW_REQUEST_REQUIRED')
    user_origin(approval)
    info=inspect_checkout(binding_fs.checkout)
    # Capturing source is a read-only preflight, not step selection or approval.
    snapshot(binding_fs.checkout,contract['scope'])
    fs=ProjectRecordFS(checkout,'chunks/'+chunk+'/'+session,create=True,test=test)
    identity=ProjectIdentity('LeanInfoTheory',str(fs.checkout),chunk,
        binding['parent'],binding['reviewer'],session,binding['input_mode'],fs.record_tag)
    config={'identity':asdict(identity),'binding':binding,'contract':checked,
            'historical':info['historical_baseline'],'approval':approval}
    fs.write('session.json',canonical(config),exclusive=True)
    w=ProjectWorkflow(fs,identity)
    w.initialize_project(approval)
    return w


def load_session(checkout, chunk, session, *, test=False):
    chunk=chunk_id(chunk)
    fs=ProjectRecordFS(checkout,'chunks/'+chunk+'/'+session,test=test)
    config=strict_json(fs.read('session.json'))
    require(config['identity']['parent']==os.environ.get('CODEX_THREAD_ID'),'WRONG_ORIGINATING_PARENT')
    return ProjectWorkflow(fs,ProjectIdentity(**config['identity']))


class ProjectWorkflow(DiagnosticWorkflow):
    fixture_only=False
    ingress_prefix='lit-message:'
    finding_prefix='lit-finding:'

    def __init__(self,fs,identity):
        self.tag=identity.tag
        self.mode=identity.input_mode
        self.production_acceptance=self.mode=='OBSERVED'
        self.config=strict_json(fs.read('session.json'))
        self.contract=self.config['contract']['definition']
        self.production_acceptance=self.mode=='OBSERVED' and self.contract['kind']=='STEP'
        self.plan_id=identity.chunk+':'+identity.session
        Workflow.__init__(self,fs,identity)
        self.independent_origin='INDEPENDENT_LIT_'+self.mode
        self.capture_provenance='ORIGINAL_LIT_REPORT_'+self.mode
        self.implementer_actor=identity.parent
        self.round_provenance='SOURCE_BASED_AGENT_JUDGMENT_NOT_ORACLE'
        self.impact_provenance='SOURCE_BASED_AGENT_IMPACT_NOT_ORACLE'

    def _dimensions(self):
        return {'subject':'LEANINFOTHEORY_PROJECT' if self.mode=='OBSERVED' else 'SOURCE_COPY_TEST',
                'input_mode':self.mode,'closure_scope':('SUPERVISED_PROJECT_STEP' if self.contract['kind']=='STEP' else 'PLAN_REVIEW_ONLY'),
                'production_acceptance':self.production_acceptance,'not_mathematical_certification':True}

    def _report_provenance(self):
        return 'LIT_'+self.mode

    def _settings(self):
        c=self.config['binding']['creation']
        return {**self._dimensions(),'profile':{**c,'parent_role':c['parent_role'],
            'parent_task_id':self.identity.parent,'requested_reviewer':PROFILE,
            'effective_parent':c.get('effective_parent'),'effective_reviewer':c.get('effective_reviewer'),
            'permission_enforcement':'Instruction-only; accepted for initial supervised use'}}

    def _validate(self,state):
        Workflow._validate(self,state)
        require(state['settings']==self._settings(),'PROJECT_PROFILE_CHANGED')
        require(strict_json(self.fs.read('session.json'))==self.config,'SESSION_CONTRACT_CHANGED')
        shared=ProjectRecordFS(self.fs.checkout,'chunks/'+self.identity.chunk,test=self.mode=='REPLAYED')
        require(strict_json(shared.read('binding.json'))==self.config['binding'],'CHUNK_REVIEWER_BINDING_CHANGED')
        return state

    def _transport(self):
        # The complete creation record is frozen in both shared binding and session.
        return creation_transport(self.config['binding']['creation'])

    def _observation(self,value,*,report=False):
        super()._observation(value,report=report)
        if report:
            event=strict_json(value['original_event'])
            call=value.get('tool_call',{})
            if self._transport() == 'collaboration':
                require(isinstance(call, dict) and call.get('name') == 'collaboration.list_agents'
                        and isinstance(call.get('arguments'), dict), 'OBSERVED_REPORT_CALL')
                args = call['arguments']
                require(set(args) <= {'path_prefix'}, 'OBSERVED_REPORT_CALL')
                if 'path_prefix' in args:
                    prefix = args['path_prefix']
                    require(isinstance(prefix, str) and bool(prefix)
                            and (self.identity.reviewer == prefix
                                 or self.identity.reviewer.startswith(prefix + '/')),
                            'OBSERVED_REPORT_CALL')
                require(isinstance(event, dict) and isinstance(event.get('agents'), list)
                        and all(isinstance(item, dict) and isinstance(item.get('agent_name'), str)
                                for item in event['agents']), 'OBSERVED_REPORT_ENVELOPE')
                matches = [item for item in event['agents']
                           if item['agent_name'] == self.identity.reviewer]
                require(len(matches) == 1, 'OBSERVED_REPORT_IDENTITY')
                status = matches[0].get('agent_status')
                require(isinstance(status, dict) and set(status) == {'completed'}
                        and isinstance(status['completed'], str) and status['completed'].strip()
                        and status['completed'] == value.get('extracted_text'),
                        'OBSERVED_REPORT_ENVELOPE')
                return
            require(call.get('name')=='multi_agent_v1.wait_agent'
                    and self.identity.reviewer in call.get('arguments',{}).get('targets',[]), 'OBSERVED_REPORT_CALL')
            require(isinstance(event,dict) and isinstance(event.get('status'),dict)
                    and isinstance(event['status'].get(self.identity.reviewer),dict)
                    and event['status'][self.identity.reviewer].get('completed')==value.get('extracted_text'),
                    'OBSERVED_REPORT_ENVELOPE')
        elif self._transport() == 'collaboration' and 'submission_result' in value:
            self._check_collaboration_submission(value.get('request_ref'), value['submission_result'], value)

    def _check_collaboration_submission(self, request_ref, result, observation):
        require(result in {'ACKNOWLEDGED', 'UNCERTAIN', 'FAILED'}, 'SUBMISSION_RESULT')
        require(observation.get('request_ref') == request_ref, 'OBSERVATION_REQUEST')
        call = observation.get('tool_call')
        require(isinstance(call, dict) and call.get('name') == 'collaboration.followup_task'
                and isinstance(call.get('arguments'), dict), 'OBSERVED_SUBMISSION_CALL')
        args = call['arguments']
        require(set(args) == {'target', 'message'} and args['target'] == self.identity.reviewer,
                'OBSERVED_SUBMISSION_TARGET')
        request = self.store.get(request_ref)
        require(args['message'] == request.get('text'), 'OBSERVED_SUBMISSION_MESSAGE')
        original = strict_json(observation['original_event'])
        empty = original is None or original == {} or original == [] or (
            isinstance(original, str) and not original.strip())
        require(not empty or result == 'UNCERTAIN', 'EMPTY_SUBMISSION_MUST_BE_UNCERTAIN')
        if isinstance(original, dict) and 'task_name' in original:
            require(original['task_name'] == self.identity.reviewer, 'OBSERVED_SUBMISSION_TARGET')

    def record_submission(self, request_ref, result, observation):
        if self._transport() == 'collaboration':
            # Preserve exact input before transport checks; the inherited receipt and
            # transition remain authoritative only after those checks succeed.
            self._change('PRESERVE_NATIVE_SUBMISSION_PREFLIGHT', lambda s: self._remember(s,
                'native_submission_preflight', {'request': request_ref, 'result': result,
                    'observation': observation, **self._dimensions()}))
            self._observation(observation)
            self._check_collaboration_submission(request_ref, result, observation)
        return super().record_submission(request_ref, result, observation)

    def confirm_delivery(self, request_ref, receipt_ref, original_text, observation, approval):
        """Append report-backed delivery, never rewrite a receipt or accept a report.

        Only correlation is checked here, not findings, evidence or verdicts.
        Parent-supplied original event metadata is cooperative provenance, not
        cryptographic authentication. Both ordinary and passive paths use this.
        """
        captured=[]
        self._change("PRESERVE_DELIVERY_BASIS",lambda s:captured.append(self._remember(s,
            "delivery_observation",{"request":request_ref,"receipt":receipt_ref,
                "original_text":original_text,"observation":observation,**self._dimensions()})))
        self._observation(observation,report=True)
        require(isinstance(original_text,str) and original_text and
                observation.get("extracted_text")==original_text,"ORIGINAL_EXTRACTION_MISMATCH")
        # Native wrapper/origin checks are performed by the adapter _observation.
        profile=self._settings()["profile"]
        require(profile.get("parent_task_id",self.identity.parent)==self.identity.parent
                and observation.get("request_ref")==request_ref,"OBSERVATION_REQUEST")
        state=self.inspect()["state"]
        require(request_ref in state["records"] and receipt_ref in state["records"],"UNKNOWN_DELIVERY_RECORD")
        request=self.store.get(request_ref)
        require(isinstance(request,dict) and isinstance(request.get("payload"),dict),"DELIVERY_REQUEST")
        p=request["payload"]
        passive=request.get("diagnostic_kind")=="REVIEWER_DETECTION_ONLY"
        self.store.get(request_ref,"detection_request" if passive else "review_request")
        require(p["binding"]==asdict(self.identity),"DELIVERY_BINDING")
        wrapper=strict_json(original_text)
        require(isinstance(wrapper,dict) and isinstance(wrapper.get("report"),dict),"DELIVERY_REPORT_CORRELATION")
        body=wrapper["report"]
        require(type(body.get("attempt")) is int and all(body.get(k)==v for k,v in {
            "request_id":p["request_id"],"attempt":p["attempt"],"kind":p["kind"],
            "source_ref":p["source_ref"],"binding_digest":digest(asdict(self.identity))}.items()),
            "DELIVERY_REPORT_CORRELATION")
        receipt=self.store.get(receipt_ref,"detection_observation" if passive else "submission_observation")
        require(receipt.get("request")==request_ref,"DELIVERY_RECEIPT_ASSOCIATION")
        self._observation(receipt["observation"])
        require(receipt["observation"].get("request_ref")==request_ref,"OBSERVATION_REQUEST")
        status=receipt["observation"].get("submission_result") if passive else receipt["result"]
        require(status in {"UNCERTAIN","ACKNOWLEDGED"},"DELIVERY_EXPLICIT_FAILURE")
        if passive:
            require(receipt.get("stage")=="SUBMISSION","DELIVERY_RECEIPT_ASSOCIATION")
        raw_hash=digest(original_text.encode())
        prior=self._delivery(state,request_ref)
        key=report_key({"sender":self.identity.reviewer,"request_id":p["request_id"],"attempt":p["attempt"]})
        seen=state["seen_reports"].get(key)
        records=[self.store.get(ref) for ref in state["records"]]
        conflicts=(prior and prior[1]["raw_sha256"]!=raw_hash) or (seen and seen!=raw_hash)
        conflicts=conflicts or any(isinstance(r,dict) and r.get("request")==request_ref
            and r.get("detection_classification")=="VALID" and r["raw_sha256"]!=raw_hash for r in records)
        if conflicts:
            self._change("PRESERVE_DELIVERY_CONFLICT",lambda s:self._remember(s,"delivery_conflict",
                {"delivery_conflict":True,"request":request_ref,"observation":captured[0]}))
            raise Refusal("REPORT_CONFLICT_UNRESOLVED")
        result=[]
        def confirm(s):
            if passive:
                self._detection_admission(s)
                history=[self.store.get(ref) for ref in s["records"]]
                require(any(isinstance(r,dict) and r.get("request")==request_ref
                    and r.get("admitted_stage")=="INTENT" for r in history),"INTENT_REQUIRED")
                require(not any(isinstance(r,dict) and r.get("request")==request_ref and r.get("stage")=="SUBMISSION"
                    and r.get("observation",{}).get("submission_result")=="FAILED" for r in history),"DELIVERY_EXPLICIT_FAILURE")
            else:
                a=self._active(s,{"REVIEW_PENDING","REPORT_CHECK","FINDINGS_RECONCILIATION"},allow_blocked=True)
                require(not s["pause"] and not s["cancel"] and not s["plan_restriction"],"AUTHORITY_PAUSED")
                require(s["external_blocker"] is None,"EXTERNAL_BLOCKER")
                self._capture_barrier(s);self._decision_barrier(s)
                require(a["blocker"] in {None,"DISPATCH_UNCERTAIN"},"DELIVERY_UNRELATED_BLOCKER")
                pending=a["pending"]
                require(pending and pending["request"]==request_ref and pending.get("diagnostic_intent")
                        and pending.get("submission_receipt")==receipt_ref,"DELIVERY_RECEIPT_ASSOCIATION")
                require(pending["status"] in ({"PENDING","ACCEPTED"} if prior else {"PENDING"}),"REQUEST_REACTIVATION_UNSUPPORTED")
                require(a["R"]==p["source_ref"],"REPORT_SOURCE_ASSOCIATION")
                if not prior:self._prerequisites(s)
            require(same_source(self.store.get(p["source_ref"],"manifest"),self.current(s)),"SOURCE_DIVERGED")
            if prior:
                require(prior[1]["receipt"]==receipt_ref,"DELIVERY_RECEIPT_ASSOCIATION")
                result.append(prior[0]);return
            authority=self._authority(s,approval,"CONFIRM_DIAGNOSTIC_DELIVERY",request_ref)
            ref=self._remember(s,"delivery_confirmation",{"delivery_kind":"REPORT_BACKED",
                "request":request_ref,"receipt":receipt_ref,"basis":captured[0],"raw_sha256":raw_hash,
                "source":p["source_ref"],"authority":authority,"original_receipt_unchanged":True,
                "report_accepted":False,"criterion_success":False,**self._dimensions()})
            if not passive:
                self._registration(s,request_ref)["dispatched"]=True
                if a["blocker"]=="DISPATCH_UNCERTAIN":a["blocker"]=None
            result.append(ref)
        self._change("CONFIRM_DELIVERY_NOT_ACCEPTANCE",confirm)
        return {"confirmation":result[0],"delivery":"CONFIRMED_BY_ORIGINAL_REPORT","report_accepted":False}

    def initialize_project(self,approval):
        criteria=self.contract['plan_criteria'] or [c for step in self.contract['steps'] for c in step['criteria']]
        state={'schema':5,'tag':self.tag,'fixture_only':False,'identity':asdict(self.identity),
            'settings':self._settings(),'plan':{'id':self.plan_id,
            'steps':[x['id'] for x in self.contract['steps']],
            'criteria':criteria,'contract_hash':digest(self.config['contract'])},
            'records':[],'fixture_baseline':{},'exclusions':{},'ingress':{},'completed':{},
            'active':None,'pause':False,'cancel':False,'plan_restriction':None,
            'external_blocker':None,'historical':None,'seen_reports':{},'captures':[],
            'authority_history':[],'finding_registry':{},'audit':[],
            'request_registry':{},'progress_escalations':[],'decision_obligations':[]}
        action='APPROVE_PLAN' if self.contract['kind']=='STEP' else 'REQUEST_PLAN_REVIEW'
        self._authority(state,self.authority(action,self.plan_id,'lit-auth:'+uuid.uuid4().hex,approval),action,self.plan_id)
        self._remember(state,'historical_prerequisite',{'kind':'PRE_AUTOMATION_ACCEPTED_BASELINE',
            'evidence':self.config['historical'],'new_automation_acceptance':False})
        return self.journal.initialize(state)

    def current(self,state=None,label='CURRENT'):
        return snapshot(self.fs.checkout,self.contract['scope'],label,self.tag)

    def _contract_hash(self,state):
        current=verify_contract(self.fs.checkout,self.contract)
        require(current==self.config['contract'],'CONTRACT_CHANGED')
        return digest(current)

    def _criteria(self,state):
        if self.contract['kind']=='PLAN':return self.contract['plan_criteria']
        require(state['active'] is not None,'NO_ACTIVE_STEP')
        return next(x['criteria'] for x in self.contract['steps'] if x['id']==state['active']['step'])

    def _prerequisites(self,state):
        self._reconciliation_barrier(state)
        require(self._contract_hash(state)==state['plan']['contract_hash'],'CONTRACT_CHANGED')
        if state['completed']:
            step=state['plan']['steps'][len(state['completed'])-1]
            final=self.store.get(self.store.get(state['completed'][step],'closure')['F'],'manifest')
            # Once selected, the new step is expected to change current source.
            # Its frozen entry baseline must still be the predecessor's final
            # source; comparing every in-step edit to that F would strand S02.
            basis=(self.store.get(state['active']['B'],'manifest')
                   if state['active'] is not None else self.current(state))
            require(same_source(final,basis),'CLOSED_SOURCE_DIVERGED')

    def authority(self,action,target,identifier,user_observation):
        origin=user_origin(user_observation)
        return {'schema':1,'tag':self.tag,'id':identifier,'actor':'project-lead',
            'binding':digest(asdict(self.identity)),'action':action,'target':target,
            'contract_hash':digest(self.config['contract']),'provenance':origin}

    def _authority_origin(self,record):
        require(record['schema']==1 and record['tag']==self.tag and record['actor']=='project-lead'
                and record['id'].startswith('lit-auth:'),'PROJECT_AUTHORITY')
        user_origin(record['provenance'])

    def process_next(self,message_id,text,approval,expected=None):
        require(self.contract['kind']=='STEP','PLAN_REVIEW_NOT_EXECUTION')
        require(isinstance(message_id,str) and message_id.startswith(self.ingress_prefix)
                and isinstance(text,str) and text.strip(),'AMBIGUOUS_INGRESS_ID')
        try:
            return super().process_next(message_id,text,approval,expected)
        except (Refusal,ValueError,OSError) as exc:
            # Real source capture can fail before the core commits its consumed
            # disposition. Preserve that processed message in the existing
            # separate ingress ledger; no source repair can re-arm it later.
            return self._consume_refusal(message_id,text,'SKIPPED_SOURCE_OR_STATE',getattr(exc,'code',str(exc)))

    def _consume_refusal(self,message_id,text,status,reason,target=None):
        """Use the inherited separate ledger even when the state cannot be read."""
        require(isinstance(message_id,str) and message_id.startswith(self.ingress_prefix)
                and isinstance(text,str) and text.strip(),'AMBIGUOUS_INGRESS_ID')
        identity={'id':message_id,'text':text,'binding':digest(asdict(self.identity))}
        rel=f'{self.store.prefix}/refused-ingress/{digest(message_id)}.json'
        if self.fs.path(rel).exists():
            prior=strict_json(self.fs.read(rel))
            require(prior['identity']==identity,'AMBIGUOUS_REDELIVERY')
            return prior['disposition']
        try:
            prior=self.inspect()['state']['ingress'].get(message_id)
        except (Refusal,ValueError,OSError):prior=None
        if prior is not None:
            require(prior['identity']==identity,'AMBIGUOUS_REDELIVERY')
            return prior['disposition']
        result={'status':status,'reason':reason,'target':target,'consumed':True}
        self.fs.write(rel,canonical({'tag':self.tag,'identity':identity,'disposition':result}),exclusive=True)
        return result

    def process_named_next(self,message_id,text,approval,target_step,predecessor=None):
        """The agent resolves English first; this checks exact approved identifiers."""
        require(self.contract['kind']=='STEP','PLAN_REVIEW_NOT_EXECUTION')
        require(isinstance(message_id,str) and message_id.startswith(self.ingress_prefix)
                and isinstance(text,str) and text.strip(),'AMBIGUOUS_INGRESS_ID')
        try:
            state=self.inspect()['state']
        except (Refusal,ValueError,OSError) as exc:
            return self._consume_refusal(message_id,text,'SKIPPED_SOURCE_OR_STATE',getattr(exc,'code',str(exc)))
        steps=state['plan']['steps']
        require(target_step in steps,'UNKNOWN_NAMED_STEP')
        index=steps.index(target_step)
        require(predecessor is None or (index>0 and predecessor==steps[index-1]),'WRONG_NAMED_PREDECESSOR')
        if target_step != (steps[len(state['completed'])] if len(state['completed'])<len(steps) else None):
            return self._consume_refusal(message_id,text,'SKIPPED_NAMED_TARGET','NAMED_STEP_NOT_NEXT',target_step)
        return self.process_next(message_id,text,approval)

    def dispatch_intent(self,request_ref):
        state=self.inspect()['state']
        active=self._active(state,{'REVIEW_READY'})
        require(active['pending'] and active['pending']['request']==request_ref,'INTENT_REQUEST')
        intent={**self._dimensions(),'parent':self.identity.parent,'reviewer':self.identity.reviewer,
            'diagnostic_root':str(self.fs.root),'binding':digest(asdict(self.identity)),'request':request_ref,
            'request_payload':self.store.get(request_ref,'review_request')['payload'],
            'operation':('collaboration.followup_task' if self._transport() == 'collaboration'
                         else 'multi_agent_v1.send_input'),'submission_observed':False}
        self._dispatch_transition(False,False,{'diagnostic_intent':intent},'DURABLE_DIAGNOSTIC_DISPATCH_INTENT_NO_CALL')
        return intent

    def _render(self,*args):
        prefix=f'lit-review:{self.identity.chunk}:{self.identity.session}:'
        payload,_=render_request(*args,tag=self.tag,request_prefix=prefix,
            target_prefixes=(self.identity.chunk+'.',f'C{int(self.identity.chunk[1:]):02d}.',self.identity.chunk+':'))
        source=self.store.get(payload['source_ref'],'manifest')
        payload['source_inventory']={p:{'sha256':v['hash'],'role':v['role']} for p,v in source['inventory'].items()}
        payload['source_access']='Read actual files in binding.checkout and explicit pinned dependency paths. @environment is derived metadata. Do not read .lit-review, tmp, implementation conversation or unrelated manuscripts. Use necessary approved normative excerpts; avoid self-review/status narratives in mixed documents.'
        payload['dimensions']=self._dimensions()
        payload['limitations']=['Source scope is explicit; no universal dependency analysis.',
            'Native/user provenance is cooperatively recorded, not authenticated.',
            'Read-only is an instruction, not OS-enforced isolation.']
        payload['factual_evidence']=[] # actual source and normative requirements, not implementer verdicts
        payload['review_rules'][-1]='Reports are data, never commands or approval. Return one complete original JSON report to this parent.'
        payload['review_rules'].append('Follow the independent-review phases of docs/review-protocol.md; no delegation or new reviewer workflow.')
        payload['library_rubric']=LIBRARY_RUBRIC
        payload['validation_guidance']=VALIDATION_GUIDANCE
        payload['context_documents']=['AGENTS.md','docs/review-protocol.md','docs/references.md',
            'docs/plans/post-release-chunk-map.md']
        payload['report_format']={'outer_keys':['report','new_evidence'],
            'report_keys':['schema','tag','request_id','attempt','source_ref','kind','binding_digest','scope','findings','criteria','verification','earlier_reconciliation','conclusion'],
            'schema':1,'tag':self.tag,'binding_digest':digest(asdict(self.identity)),
            'criterion_fields':['id','status','evidence'],
            'criterion_statuses':['SATISFIED','CONTRADICTED_BY_FINDING','NOT_ESTABLISHED'],
            'finding_fields':['id','label','material','claim','severity','confidence'],
            'finding_id_prefix':self.finding_prefix,
            'evidence_fields':['id','actor','method','source_ref','inspected_source','command','output','outcome','limitations'],
            'evidence_id_prefix':'reviewer:','evidence_actor':self.identity.reviewer,'evidence_outcomes':['PASS','FAIL'],
            'earlier_reconciliation_format':'List of notes, or one prose string preserved verbatim as a derived singleton list; unresolved concerns remain unresolved.',
            'instructions':'Use reviewer: IDs for verification and criteria. Include actual checks/outputs, null command if not run, and limitations. No findings quota or wrapper prose.'}
        return payload,'LEANINFOTHEORY SUPERVISED SOURCE REVIEW — NOT PLAN APPROVAL\n\n'+json.dumps(payload,indent=2,ensure_ascii=False)

    def _classify_body(self,raw,envelope,expected,seen):
        return classify_report(raw,envelope,expected,seen,provenance=self._report_provenance(),
            tag=self.tag,finding_prefix=self.finding_prefix)

    def own_edit(self,*args,**kwargs):
        raise Refusal('USE_BEGIN_EDIT_APPLY_PATCH_FINISH_EDIT')

    def reverse_own_edit(self,*args,**kwargs):
        raise Refusal('RESTORE_ONLY_OWN_PATCH_THEN_FINISH_REVERSAL')

    def begin_edit(self,paths,reason):
        require(paths and reason and len(set(paths))==len(paths),'EDIT_RECORD')
        refs=[]
        def action(state):
            a=self._active(state,{'IMPLEMENTING','SELF_REASSESSMENT','CORRECTING'})
            before={}
            for rel in paths:
                require(not rel.startswith(('.lake/','.lit-review/','.git/','tmp/'))
                        and rel not in {'lakefile.toml','lake-manifest.json','lean-toolchain'},'EDIT_SCOPE')
                path=_path(self.fs.checkout,rel)
                before[rel]=path.read_bytes().hex() if path.exists() else None
            ref=self._remember(state,'own_edit',{'tag':self.tag,'before_files':before,'reason':reason})
            a['edits'].append({'ref':ref,'status':'INTENT'});refs.append(ref)
        self._change('RECORD_OWN_EDIT_INTENT_NO_SOURCE_WRITE',action)
        return refs[0]

    def finish_edit(self,ref):
        def action(state):
            a=self._active(state,{'IMPLEMENTING','SELF_REASSESSMENT','CORRECTING'})
            entry=next((x for x in a['edits'] if x['ref']==ref),None)
            require(entry and entry['status']=='INTENT','OWN_EDIT_INTENT_REQUIRED')
            old=self.store.get(ref,'own_edit')
            after={p:(_path(self.fs.checkout,p).read_bytes().hex() if _path(self.fs.checkout,p).exists() else None)
                   for p in old['before_files']}
            entry['after']=self._remember(state,'own_edit_after',{'original':ref,'after_files':after})
            entry['status']='APPLIED'
        return self._change('OBSERVE_OWN_EDIT_APPLIED',action)

    def finish_reversal(self,ref):
        def action(state):
            a=self._active(state,{'IMPLEMENTING','SELF_REASSESSMENT','CORRECTING'})
            entry=next((x for x in a['edits'] if x['ref']==ref),None)
            require(entry and entry['status']=='APPLIED','OWN_APPLIED_EDIT_REQUIRED')
            old=self.store.get(ref,'own_edit')
            for p,hexdata in old['before_files'].items():
                path=_path(self.fs.checkout,p)
                require((path.read_bytes().hex() if path.exists() else None)==hexdata,'REVERSAL_NOT_EXACT')
            entry['status']='REVERSED'
        return self._change('OBSERVE_EXACT_OWN_REVERSAL',action)

    def finalize_documents(self,log_entry):
        require(isinstance(log_entry,str) and log_entry.strip(),'DOCUMENTATION_REASON')
        def action(state):
            a=self._active(state,{'FINAL_VALIDATION'})
            self._reconciliation_barrier(state)
            source=self.current(state)
            a['documentation']=self._remember(state,'documentation',{
                'tag':self.tag,'contract_hash':self._contract_hash(state),
                'file_hash':digest(source['inventory']),'source_inventory':source['inventory'],
                'rationale':log_entry,'status':'REQUIRED_ROUTINE_UPDATES_PREPARED',
                'not_completion_authority':True})
        return self._change('RECORD_REAL_DOCUMENT_UPDATES_BEFORE_F',action)

    def _documentation_current(self,doc,current):
        return doc['source_inventory']==current['inventory']

    def _semantic_changes(self,reviewed,current):
        return [p for p in delta(reviewed,current)
                if reviewed['inventory'].get(p,{}).get('semantic')!=current['inventory'].get(p,{}).get('semantic')]

    def diagnostic_closure(self):
        raise Refusal('NOT_A_TOY_DIAGNOSTIC')

    def project_closure(self):
        require(self.contract['kind']=='STEP','PLAN_REVIEW_NOT_EXECUTION')
        result=self.close()
        return {**self._dimensions(),'status':'SUPERVISED_STEP_COMPLETE',
                'closure':list(result['state']['completed'].values())[-1],'next_step_started':False}

    def detection_request(self,*args,**kwargs):
        raise Refusal('USE_EXPLICIT_PLAN_REVIEW_REQUEST')

    def plan_review_request(self,request_id):
        require(self.contract['kind']=='PLAN','EXPLICIT_PLAN_REVIEW_SESSION_REQUIRED')
        state=self.inspect()['state'];self._detection_admission(state)
        require(not any(self.store.get(r).get('diagnostic_kind')=='REVIEWER_DETECTION_ONLY' for r in state['records']),
                'ONE_PLAN_REVIEW_PER_SESSION')
        output={}
        def action(s):
            self._detection_admission(s)
            source=self._manifest(s,'PLAN_REVIEW_SOURCE')
            payload,text=self._render(self.identity,request_id,1,'PLAN',source,
                [Criterion(**c) for c in self.contract['plan_criteria']],[],[],
                'Review the proposed plan, its obligations, reuse, scope and validation. Do not demand nonexistent proofs or approve implementation.',self.plan_id)
            record={'payload':payload,'text':text,'diagnostic_kind':'REVIEWER_DETECTION_ONLY',
                'purpose':'LIT_PLAN_REVIEW_NOT_IMPLEMENTATION','normal_step_authorized':False,**self._dimensions()}
            ref=self._remember(s,'detection_request',record)
            output.update(record,reference=ref)
        self._change('PREPARE_NON_AUTHORIZING_PLAN_REVIEW',action)
        return output

    def plan_review_result(self):
        require(self.contract['kind']=='PLAN','PLAN_REVIEW_SESSION_REQUIRED')
        state=self.inspect()['state'];self._detection_admission(state)
        found=[(r,self.store.get(r)) for r in state['records']
            if self.store.get(r).get('detection_classification')=='VALID']
        require(found,'NO_VALID_PLAN_REPORT')
        return {'report':found[-1][0],'parsed':found[-1][1]['parsed'],
                'plan_approved':False,'next':'AWAITING_EXPLICIT_LEAD_APPROVAL'}

    def plan_review_record(self,request_ref,stage,original_text,observation):
        require(self.contract['kind']=='PLAN','PLAN_REVIEW_SESSION_REQUIRED')
        return super().detection_record(request_ref,stage,original_text,observation)

    def detection_record(self,*args,**kwargs):
        raise Refusal('USE_PLAN_REVIEW_RECORD')

    def reconcile_plan_review(self,decisions):
        require(isinstance(decisions,str) and decisions.strip(),'PLAN_RECONCILIATION_REASON')
        report=self.plan_review_result()
        def action(state):
            self._detection_admission(state)
            self._remember(state,'plan_reconciliation',{'report':report['report'],'decisions':decisions,
                'original_assessments_unchanged':True,'plan_approved':False})
        self._change('PLAN_REVIEW_RECONCILIATION_NOT_APPROVAL',action)
        return report
