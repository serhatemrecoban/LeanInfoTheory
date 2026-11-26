"""Focused isolation checks for the external-consumer recipe; no Git mutations."""
from contextlib import contextmanager
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import tomllib
import unittest
from unittest.mock import Mock, patch

import run


@contextmanager
def scratch():
    # Run from the repository root. Keep temporary files in its ignored .lake.
    base = (Path.cwd() / '.lake').resolve()
    base.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='external-consumer-test-', dir=base) as name:
        path = Path(name).resolve()
        assert path.is_relative_to(base) and path != base
        yield path


class IsolationTests(unittest.TestCase):
    def test_nine_roots_and_their_compiler_reported_imports(self):
        names = ['RootOnly', 'CouplingContinuity', 'ProductInformation', 'SourceCoding',
                 'Capacity', 'WeakConverse', 'FullUmbrella', 'PrefixIid', 'TypeProb']
        config = tomllib.loads(run.configuration('file:///candidate', 'a' * 40))
        self.assertEqual(config['lean_lib'][0]['roots'], ['Consumer.' + name for name in names])
        self.assertTrue(config['leanOptions']['warningAsError'])
        commands = Mock(spec=run.Commands)
        rows = [self.import_row(module) for module in run.MODULE_IMPORTS.values()]
        commands.run.return_value = json.dumps({'imports': rows}).encode()
        fixture = Path('fixture')
        imports = run.check_caller_imports(commands, fixture, Path('checkout'))
        commands.run.assert_called_once_with(['lean', '--deps-json', *[
            str(fixture / 'Consumer' / f'{name}.lean') for name in names]], Path('checkout'))
        self.assertEqual(imports['Consumer.PrefixIid'], ['LeanInfoTheory.Shannon.PrefixCodeLengthIid'])
        self.assertEqual(imports['Consumer.TypeProb'], ['LeanInfoTheory.Shannon.TypeClassProbability'])

    @staticmethod
    def import_row(*modules):
        implicit = [{'module': 'Init', 'isMeta': False}, {'module': 'Init', 'isMeta': True}]
        return {'errors': [], 'result': {'imports': implicit + [
            {'module': module, 'isMeta': False} for module in modules]}}

    def test_focused_headers_reject_substitution_extra_imports_and_parse_errors(self):
        commands = Mock(spec=run.Commands)
        focused = run.MODULE_IMPORTS['TypeProb']
        for row in [self.import_row('LeanInfoTheory.Shannon'), self.import_row(),
                    self.import_row(focused, 'Consumer.RootOnly'), self.import_row(focused, focused),
                    self.import_row(focused, 'Init'), {'errors': ['invalid import header']}]:
            rows = [self.import_row(module) for module in run.MODULE_IMPORTS.values()]
            rows[list(run.MODULE_IMPORTS).index('TypeProb')] = row
            commands.run.return_value = json.dumps({'imports': rows}).encode()
            with self.subTest(row=row), self.assertRaisesRegex(ValueError, 'Consumer.TypeProb'):
                run.check_caller_imports(commands, Path('fixture'), Path('checkout'))
        commands.run.return_value = b'{"imports":[]}'
        with self.assertRaisesRegex(ValueError, 'incomplete Lean import-header results'):
            run.check_caller_imports(commands, Path('fixture'), Path('checkout'))

    def test_inherited_search_path_and_git_redirects_do_not_reach_child(self):
        inherited = dict(os.environ)
        inherited.update(LEAN_PATH='a-primary-checkout', LEAN_SRC_PATH='a-primary-source',
                         ELAN_TOOLCHAIN='other-toolchain',
                         GIT_INDEX_FILE='an-unrelated-index', GIT_CONFIG_COUNT='1',
                         GIT_CONFIG_KEY_0='core.worktree', GIT_CONFIG_VALUE_0='elsewhere')
        environment, removed = run.clean_environment(inherited)
        output = subprocess.check_output([sys.executable, '-B', '-c',
            'import os,json; print(json.dumps({k:os.getenv(k) for k in '
            '["LEAN_PATH","LEAN_SRC_PATH","ELAN_TOOLCHAIN","GIT_INDEX_FILE","GIT_CONFIG_COUNT",'
            '"GIT_CONFIG_KEY_0","GIT_CONFIG_VALUE_0"]}))'], env=environment)
        self.assertTrue(all(value is None for value in json.loads(output).values()))
        self.assertIn('LEAN_PATH', removed)
        self.assertEqual(environment.get('PATH'), inherited.get('PATH'))

    def test_manifest_accepts_exact_local_sha_and_retained_dependency_pin(self):
        expected = {'mathlib': {'name': 'mathlib', 'type': 'git',
                    'rev': 'a' * 40, 'url': 'https://example.invalid/mathlib'}}
        resolved = {'packages': [*expected.values(), {'name': 'LeanInfoTheory',
                    'type': 'git', 'rev': 'b' * 40, 'url': 'file:///candidate'}]}
        self.assertEqual(set(run.check_manifest(expected, resolved, 'b' * 40,
                                               'file:///candidate')),
                         {'mathlib', 'LeanInfoTheory'})

    def test_manifest_rejects_source_substitution_and_transitive_pin_drift(self):
        expected = {'mathlib': {'name': 'mathlib', 'type': 'git',
                    'rev': 'a' * 40, 'url': 'https://example.invalid/mathlib'}}
        base = {'packages': [*expected.values(), {'name': 'LeanInfoTheory',
                'type': 'git', 'rev': 'b' * 40, 'url': 'file:///candidate'}]}
        for package, field, value in [('LeanInfoTheory', 'rev', 'c' * 40),
                                      ('LeanInfoTheory', 'url', 'file:///primary'),
                                      ('mathlib', 'rev', 'd' * 40),
                                      ('mathlib', 'url', 'file:///other')]:
            changed = json.loads(json.dumps(base))
            next(p for p in changed['packages'] if p['name'] == package)[field] = value
            reason = ('wrong commit or repository' if package == 'LeanInfoTheory'
                      else 'resolved pin or origin differs')
            with self.subTest(package=package, field=field), self.assertRaisesRegex(ValueError, reason):
                run.check_manifest(expected, changed, 'b' * 40, 'file:///candidate')

    def test_manifest_rejects_duplicate_names_and_path_dependencies(self):
        row = {'name': 'mathlib', 'type': 'git', 'rev': 'a' * 40, 'url': 'x'}
        with self.assertRaises(ValueError):
            run.manifest_packages({'packages': [row, row]})
        with self.assertRaises(ValueError):
            run.manifest_packages({'packages': [{'name': 'mathlib', 'type': 'path'}]})

    def test_physical_origin_accepts_clone_and_rejects_primary_or_sibling_olean(self):
        with scratch() as root:
            clone = root / 'clone'
            source = clone / 'LeanInfoTheory/Shannon.lean'
            olean = clone / '.lake/build/lib/lean/LeanInfoTheory/Shannon.olean'
            foreign_source = root / 'primary/LeanInfoTheory/Shannon.lean'
            foreign_olean = root / 'sibling/.lake/build/lib/lean/LeanInfoTheory/Shannon.olean'
            for path in (source, olean, foreign_source, foreign_olean):
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(b'origin-test')
            run.check_origin('LeanInfoTheory.Shannon', source, olean, clone)
            with self.assertRaisesRegex(ValueError, 'physical origin escapes'):
                run.check_origin('LeanInfoTheory.Shannon', foreign_source, olean, clone)
            with self.assertRaisesRegex(ValueError, 'physical origin escapes'):
                run.check_origin('LeanInfoTheory.Shannon', source, foreign_olean, clone)
            self.assertFalse(run.child_of(root, root))
            self.assertFalse(run.child_of(root / 'sibling', clone))

    def test_branch_name_is_not_an_exact_candidate_revision(self):
        with self.assertRaises(ValueError):
            run.configuration('file:///candidate', 'master')

    def test_ignored_build_redirect_cannot_resolve_into_primary(self):
        # Model realpath behavior of a junction without requiring link privileges.
        with scratch() as root:
            clone = root / 'clone'
            source = clone / 'LeanInfoTheory/Shannon.lean'
            olean = clone / '.lake/build/lib/lean/LeanInfoTheory/Shannon.olean'
            for path in (source, olean):
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(b'origin-test')
            outside = root / 'primary/LeanInfoTheory/Shannon.olean'
            original = Path.resolve

            def redirected(path, *args, **kwargs):
                if path == olean:
                    return outside
                return original(path, *args, **kwargs)

            with patch.object(Path, 'resolve', redirected), self.assertRaises(ValueError):
                run.check_origin('LeanInfoTheory.Shannon', source, olean, clone)


if __name__ == '__main__':
    unittest.main()
