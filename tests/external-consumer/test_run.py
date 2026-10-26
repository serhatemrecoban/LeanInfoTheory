"""Focused isolation checks for the external-consumer recipe; no Git mutations."""
from contextlib import contextmanager
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

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
    def test_inherited_search_path_and_git_redirects_do_not_reach_child(self):
        inherited = dict(os.environ)
        inherited.update(LEAN_PATH='a-primary-checkout', LEAN_SRC_PATH='a-primary-source',
                         GIT_INDEX_FILE='an-unrelated-index', GIT_CONFIG_COUNT='1',
                         GIT_CONFIG_KEY_0='core.worktree', GIT_CONFIG_VALUE_0='elsewhere')
        environment, removed = run.clean_environment(inherited)
        output = subprocess.check_output([sys.executable, '-B', '-c',
            'import os,json; print(json.dumps({k:os.getenv(k) for k in '
            '["LEAN_PATH","LEAN_SRC_PATH","GIT_INDEX_FILE","GIT_CONFIG_COUNT",'
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
            with self.subTest(package=package, field=field), self.assertRaises(ValueError):
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
            for path in (source, olean):
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(b'origin-test')
            run.check_origin('LeanInfoTheory.Shannon', source, olean, clone)
            with self.assertRaises(ValueError):
                run.check_origin('LeanInfoTheory.Shannon', root / 'primary/Shannon.lean',
                                 olean, clone)
            with self.assertRaises(ValueError):
                run.check_origin('LeanInfoTheory.Shannon', source,
                                 root / 'sibling/Shannon.olean', clone)
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
