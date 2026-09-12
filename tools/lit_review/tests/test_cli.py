"""Small command-surface checks; no native transport or production acceptance.

Adapted from PFR-C02 for LeanInfoTheory, 2026-09-11; see ../PROVENANCE.md.
Additional cases are local installation regressions.
"""
import ast
import tempfile
from pathlib import Path
import unittest
from unittest.mock import Mock, patch
import sys

sys.path.insert(0, str(Path(__file__).absolute().parents[1]))

import cli


class CommandTests(unittest.TestCase):
    def test_api_exposes_real_signatures_without_transport(self):
        result=cli.entry(Path.cwd(),'api')
        self.assertEqual(set(result['methods']),set(cli.METHODS))
        self.assertIn('question',result['methods']['prepare_review'])
        self.assertNotIn('own_edit',result['methods'])
        self.assertIn('Python never does',result['native_calls'])

    def test_instructions_are_read_from_selected_checkout(self):
        with tempfile.TemporaryDirectory(prefix='lit-cli-') as folder:
            root=Path(folder); (root/'docs').mkdir()
            expected={}
            for filename in ('review-protocol.md','review-operations.md'):
                rel='docs/'+filename; expected[rel]='Source-copy instructions: '+filename
                (root/rel).write_text(expected[rel],encoding='utf-8')
            self.assertEqual(cli.entry(root,'instructions'),expected)

    def test_generic_call_rejects_unlisted_method(self):
        with patch.object(cli,'load_session',return_value=object()):
            with self.assertRaisesRegex(ValueError,'METHOD_NOT_EXPOSED'):
                cli.entry(Path.cwd(),'call',{'method':'__getattribute__'},chunk='C10')

    def test_generic_call_rejects_code_shaped_arguments(self):
        with patch.object(cli,'load_session',return_value=object()):
            with self.assertRaisesRegex(ValueError,'CALL_ARGUMENTS'):
                cli.entry(Path.cwd(),'call',{'method':'inspect','args':'not a list'},chunk='C10')

    def test_next_requires_named_target_without_guessing_from_english(self):
        workflow = Mock(plan_id='C10:execution')
        with patch.object(cli, 'load_session', return_value=workflow):
            with self.assertRaises(KeyError):
                cli.entry(Path.cwd(), 'next', {'message_id': 'lit-message:no-target',
                    'user_observation': {'original_text': 'Do step C10.01 with its review process.'}}, chunk='C10')
        workflow.process_next.assert_not_called()
        workflow.process_named_next.assert_not_called()

    def test_next_passes_exact_target_and_optional_predecessor(self):
        for predecessor in (None, 'C10.01'):
            with self.subTest(predecessor=predecessor):
                workflow = Mock(plan_id='C10:execution')
                origin = {'role': 'user', 'reference': 'synthetic-cli:user',
                          'original_text': 'Opaque fixture wording; target is already resolved.'}
                packet = {'message_id': 'lit-message:named-cli', 'user_observation': origin, 'target_step': 'C10.02'}
                if predecessor is not None:
                    packet['predecessor'] = predecessor
                with patch.object(cli, 'load_session', return_value=workflow) as load:
                    result = cli.entry(Path.cwd(), 'next', packet, chunk='C10')
                load.assert_called_once_with(Path.cwd().absolute(), 'C10', 'execution')
                workflow.process_named_next.assert_called_once_with(packet['message_id'], origin['original_text'],
                    workflow.authority.return_value, 'C10.02', predecessor)
                workflow.process_next.assert_not_called()
                self.assertIs(result, workflow.process_named_next.return_value)

    def test_current_validator_routes_exist_without_running_lean(self):
        root = Path(__file__).absolute().parents[3]
        tree = ast.parse((root / 'scripts/validate_release.py').read_text(encoding='utf-8'))
        choices = []
        for node in ast.walk(tree):
            if (isinstance(node, ast.Call) and isinstance(node.func, ast.Attribute)
                    and node.func.attr == 'add_argument' and node.args
                    and isinstance(node.args[0], ast.Constant) and node.args[0].value == 'command'):
                choices = next(ast.literal_eval(item.value) for item in node.keywords if item.arg == 'choices')
        self.assertTrue({'all', 'focused', 'static', 'documentation', 'api-docs', 'hygiene', 'targets'} <= set(choices))


if __name__=='__main__':unittest.main()
