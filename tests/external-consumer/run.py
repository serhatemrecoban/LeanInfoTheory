#!/usr/bin/env python3
"""Materialize and check the external fixture at an explicitly supplied local SHA.

Invoke only after the separate checkpoint/location approval. This program makes
no candidate commits and does not modify the primary checkout or other projects.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
import tomllib

MODULE_IMPORTS = {
    'RootOnly': 'LeanInfoTheory',
    'CouplingContinuity': 'LeanInfoTheory.Shannon.Continuity',
    'ProductInformation': 'LeanInfoTheory.Shannon.SemanticBridge.ProductChannel',
    'SourceCoding': 'LeanInfoTheory.Shannon.SourceCodingAsymptotic',
    'Capacity': 'LeanInfoTheory.Shannon.StandardChannelCapacity',
    'WeakConverse': 'LeanInfoTheory.Shannon.ChannelCodingAsymptotic',
    'FullUmbrella': 'LeanInfoTheory.Shannon',
}
FIXTURE_FILES = ['README.md', 'run.py', 'test_run.py'] + [
    f'Consumer/{name}.lean' for name in MODULE_IMPORTS]
PINNED_TOOLCHAIN = 'leanprover/lean4:v4.33.1'
PINNED_MATHLIB = '0df444a360eaa60ab8c11dca51a86af692955474'


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def child_of(path: Path, parent: Path) -> bool:
    return path != parent and path.is_relative_to(parent)


def clean_environment(inherited: dict[str, str]) -> tuple[dict[str, str], list[str]]:
    names = {'LEAN_PATH', 'LEAN_SRC_PATH', 'LEAN_SYSROOT', 'LAKE_PACKAGES_DIR',
             'GIT_DIR', 'GIT_WORK_TREE', 'GIT_INDEX_FILE', 'GIT_COMMON_DIR',
             'GIT_OBJECT_DIRECTORY', 'GIT_ALTERNATE_OBJECT_DIRECTORIES',
             'GIT_CONFIG_COUNT'}
    removed = sorted(k for k in inherited if k in names or
                     k.startswith(('GIT_CONFIG_KEY_', 'GIT_CONFIG_VALUE_')))
    return {k: v for k, v in inherited.items() if k not in removed}, removed


def manifest_packages(manifest: dict) -> dict[str, dict]:
    rows = manifest['packages']
    result = {row['name']: row for row in rows}
    require(len(result) == len(rows), 'duplicate manifest package names')
    require(all(row['type'] == 'git' and re.fullmatch('[0-9a-f]{40}', row['rev'])
                for row in rows), 'every dependency must be an exact Git commit')
    return result


def check_manifest(expected: dict[str, dict], resolved: dict, candidate_sha: str,
                   candidate_url: str) -> dict[str, dict]:
    packages = manifest_packages(resolved)
    require(set(packages) == set(expected) | {'LeanInfoTheory'},
            'resolved dependency inventory differs from the candidate')
    own = packages['LeanInfoTheory']
    require(own['rev'] == candidate_sha and own['url'] == candidate_url,
            'LeanInfoTheory resolved to the wrong commit or repository')
    for name, row in expected.items():
        got = packages[name]
        require((got['rev'], got['url']) == (row['rev'], row['url']),
                f'{name}: resolved pin or origin differs from candidate')
    return packages


def check_origin(module: str, source: Path, olean: Path, package: Path) -> None:
    stem = Path(*module.split('.'))
    package_root = package.resolve()
    source_real, olean_real = source.resolve(), olean.resolve()
    require(child_of(source_real, package_root) and child_of(olean_real, package_root),
            f'{module}: physical origin escapes the materialized dependency')
    require(source_real == (package / stem.with_suffix('.lean')).resolve(),
            f'{module}: source resolved outside the materialized dependency')
    expected = package / '.lake/build/lib/lean' / stem.with_suffix('.olean')
    require(olean_real == expected.resolve(),
            f'{module}: olean resolved outside the materialized dependency')
    require(source.is_file() and olean.is_file(), f'{module}: missing origin file')


def configuration(url: str, revision: str) -> str:
    require(re.fullmatch('[0-9a-f]{40}', revision) is not None, 'full SHA required')
    roots = ', '.join(json.dumps('Consumer.' + name) for name in MODULE_IMPORTS)
    return (f'name = "C24ExternalConsumer"\nversion = "0.0.0"\n'
            f'defaultTargets = ["Consumer"]\nfixedToolchain = true\n\n'
            f'[leanOptions]\nrelaxedAutoImplicit = false\nwarningAsError = true\n\n'
            f'[[require]]\nname = "LeanInfoTheory"\ngit = {json.dumps(url)}\n'
            f'rev = {json.dumps(revision)}\n\n'
            f'[[lean_lib]]\nname = "Consumer"\nroots = [{roots}]\n')


class Commands:
    def __init__(self, evidence: Path, environment: dict[str, str]):
        self.evidence, self.environment, self.records = evidence, environment, []

    def run(self, arguments: list[str], cwd: Path, *, stdin: bytes | None = None) -> bytes:
        number = len(self.records) + 1
        log = self.evidence / f'command-{number:02d}.log'
        started = time.monotonic()
        result = subprocess.run(arguments, cwd=cwd, env=self.environment, input=stdin,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        log.write_bytes(result.stdout)
        record = {'argv': arguments, 'cwd': str(cwd), 'exit_code': result.returncode,
                  'seconds': round(time.monotonic() - started, 3), 'log': str(log),
                  'log_sha256': sha256(result.stdout),
                  'stdin_sha256': sha256(stdin) if stdin is not None else None}
        self.records.append(record)
        (self.evidence / 'commands.json').write_text(json.dumps(self.records, indent=2) + '\n')
        print(f'command {number}: exit {result.returncode}: {arguments}', flush=True)
        require(result.returncode == 0, f'command {number} failed; see {log}')
        return result.stdout

    def git(self, repository: Path, *arguments: str) -> bytes:
        return self.run(['git', '--no-optional-locks', '-C', str(repository), *arguments],
                        repository)

    def clean(self, repository: Path, revision: str) -> None:
        require(self.git(repository, 'rev-parse', 'HEAD').decode().strip() == revision,
                f'wrong checkout revision: {repository}')
        require(not self.git(repository, 'status', '--porcelain', '--untracked-files=normal'),
                f'dirty dependency checkout: {repository}')


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--repository', type=Path, required=True,
                        help='approved clean candidate checkout (local Git source)')
    parser.add_argument('--candidate-sha', required=True)
    parser.add_argument('--workspace', type=Path, required=True,
                        help='primary repository owning the approved ignored locations')
    parser.add_argument('--work-dir', type=Path, required=True,
                        help='new approved directory beneath workspace/.worktrees')
    parser.add_argument('--evidence-dir', type=Path, required=True,
                        help='new private directory beneath workspace/.lit-review')
    args = parser.parse_args(argv)
    repository, workspace = args.repository.resolve(), args.workspace.resolve()
    work, evidence = args.work_dir.resolve(), args.evidence_dir.resolve()
    require(re.fullmatch('[0-9a-f]{40}', args.candidate_sha) is not None, 'full SHA required')
    require(child_of(repository, workspace / '.worktrees'),
            'candidate checkout must be in the approved repository-local location')
    require(child_of(work, workspace / '.worktrees') and not work.exists(),
            'consumer directory must be new and beneath workspace/.worktrees')
    require(child_of(evidence, workspace / '.lit-review') and not evidence.exists(),
            'evidence directory must be new and beneath workspace/.lit-review')
    require(not child_of(work, repository) and not child_of(repository, work),
            'consumer and candidate checkouts must be physically separate')
    environment, removed = clean_environment(dict(os.environ))
    evidence.mkdir(parents=True, exist_ok=False)
    commands = Commands(evidence, environment)
    report = {'schema': 1, 'status': 'RUNNING', 'candidate_sha': args.candidate_sha,
              'repository': str(repository), 'work_dir': str(work),
              'removed_inherited_environment_names': removed,
              'evidence_class': 'LOCAL_GIT_EXTERNAL_PACKAGE',
              'remote_installation_verified': False, 'full_clean_suite': False}
    try:
        commands.run(['git', '--no-optional-locks', '-C', str(workspace),
                      'check-ignore', '--quiet', str(work)], workspace)
        commands.clean(repository, args.candidate_sha)
        require(not commands.git(repository, 'ls-tree', args.candidate_sha, '--',
                                 'docs/next-website-tasks.md'),
                'candidate tree still contains the private working-material path')
        toolchain = commands.git(repository, 'show', args.candidate_sha + ':lean-toolchain')
        require(toolchain.decode().strip() == PINNED_TOOLCHAIN, 'toolchain drift')
        candidate_manifest_raw = commands.git(repository, 'show',
                                              args.candidate_sha + ':lake-manifest.json')
        expected = manifest_packages(json.loads(candidate_manifest_raw))
        require(expected['mathlib']['rev'] == PINNED_MATHLIB, 'mathlib drift')
        fixture = Path(__file__).resolve().parent
        fixture_bytes = {}
        for name in FIXTURE_FILES:
            data = commands.git(repository, 'show',
                                args.candidate_sha + ':tests/external-consumer/' + name)
            require((fixture / name).read_bytes().replace(b'\r\n', b'\n') == data,
                    f'{name}: invoked fixture differs from candidate commit')
            fixture_bytes[name] = data
        report['fixture_sha256'] = {k: sha256(v) for k, v in fixture_bytes.items()}
        work.mkdir(parents=True, exist_ok=False)
        for name, data in fixture_bytes.items():
            if name.endswith('.lean'):
                target = work / name
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(data)
        (work / 'lean-toolchain').write_bytes(toolchain)
        url = repository.as_uri()
        (work / 'lakefile.toml').write_text(configuration(url, args.candidate_sha), encoding='utf-8')
        report['package_configuration_sha256'] = sha256((work / 'lakefile.toml').read_bytes())
        commands.run(['lake', 'update'], work)
        raw = (work / 'lake-manifest.json').read_bytes()
        (evidence / 'resolved-lake-manifest.json').write_bytes(raw)
        resolved = json.loads(raw)
        packages = check_manifest(expected, resolved, args.candidate_sha, url)
        packages_dir = (work / resolved['packagesDir']).resolve()
        require(child_of(packages_dir, work), 'packagesDir escapes consumer')
        for name, row in packages.items():
            location = (packages_dir / name).resolve()
            require(child_of(location, packages_dir), 'package location escapes consumer')
            commands.clean(location, row['rev'])
        commands.run(['lake', 'env', 'lean', '--version'], work)
        commands.run(['lake', 'env', 'lean', '--print-prefix'], work)
        commands.run(['lake', 'exe', 'cache', 'get'], work)
        commands.run(['lake', '--wfail', 'build', 'Consumer'], work)
        modules = sorted(set(MODULE_IMPORTS.values()))
        probe = 'import Lean\n\n#eval do\n  let sp ← Lean.getSrcSearchPath\n'
        for module in modules:
            probe += (f'  let s ← Lean.findLean sp `{module}\n'
                      f'  let o ← Lean.findOLean `{module}\n'
                      f'  IO.println s!"{module}\\t{{← IO.FS.realPath s}}\\t{{← IO.FS.realPath o}}"\n')
        (evidence / 'origins-probe.lean').write_text(probe, encoding='utf-8')
        output = commands.run(['lake', 'env', 'lean', '--stdin'], work, stdin=probe.encode())
        origins = []
        for line in output.decode().splitlines():
            parts = line.split('\t')
            if len(parts) == 3 and parts[0] in modules:
                name, source, olean = parts
                check_origin(name, Path(source), Path(olean), packages_dir / 'LeanInfoTheory')
                origins.append({'module': name, 'source': source, 'olean': olean,
                                'source_sha256': sha256(Path(source).read_bytes()),
                                'olean_sha256': sha256(Path(olean).read_bytes())})
        require({row['module'] for row in origins} == set(modules) and
                len(origins) == len(modules), 'incomplete/duplicate physical-origin results')
        report['physical_origins'] = origins
        for name, row in packages.items():
            commands.clean(packages_dir / name, row['rev'])
        commands.clean(repository, args.candidate_sha)
        require((work / 'lake-manifest.json').read_bytes() == raw,
                'resolved manifest changed during compilation')
        require((work / 'lakefile.toml').read_text(encoding='utf-8') ==
                configuration(url, args.candidate_sha), 'consumer configuration changed')
        require((work / 'lean-toolchain').read_bytes() == toolchain,
                'consumer toolchain changed')
        for name, data in fixture_bytes.items():
            if name.endswith('.lean'):
                require((work / name).read_bytes() == data, f'{name}: fixture changed')
        report['resolved_manifest_sha256'] = sha256(raw)
        report['status'] = 'PASS'
    except Exception as exc:
        report.update(status='FAIL', error_type=type(exc).__name__, error=str(exc))
    finally:
        report['commands'] = commands.records
        (evidence / 'result.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({'status': report['status'], 'result': str(evidence / 'result.json')}))
    return 0 if report['status'] == 'PASS' else 1


if __name__ == '__main__':
    sys.exit(main())
