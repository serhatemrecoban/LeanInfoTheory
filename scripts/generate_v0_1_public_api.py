#!/usr/bin/env python3
"""Generate and validate the LeanInfoTheory ``v0.1.x`` public API manifest.

The manifest freezes project-owned declaration names, owning modules,
declaration kinds, reviewed ``simp`` attributes, supported module paths, and
the lightweight-root export facade.  It deliberately does not try to replace
Lean's environment-generated, signature-bearing documentation.
"""

from __future__ import annotations

import argparse
import json
import re
from collections import Counter
from pathlib import Path

import generate_website_api_index as api_index
import generate_website_blueprint as blueprint


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "docs" / "v0.1-public-api.json"
FULL_UMBRELLA = "LeanInfoTheory.Shannon"
ROOT_MODULE = "LeanInfoTheory"
ROOT_FACADE = ROOT / "LeanInfoTheory" / "InformationMeasures.lean"
AGGREGATE_MODULES = {
    "LeanInfoTheory",
    "LeanInfoTheory.Examples",
    "LeanInfoTheory.InformationMeasures",
    "LeanInfoTheory.MathlibFragments",
    "LeanInfoTheory.Shannon",
    "LeanInfoTheory.Shannon.SemanticBridge",
}


def module_closure(
    root: str, infos: list[blueprint.ModuleInfo]
) -> set[str]:
    graph = {info.name: info.local_imports for info in infos}
    if root not in graph:
        raise ValueError(f"unknown local module: {root}")

    seen: set[str] = set()
    stack = [root]
    while stack:
        current = stack.pop()
        if current in seen:
            continue
        seen.add(current)
        stack.extend(graph[current])
    return seen


def parse_root_exports() -> list[str]:
    source = ROOT_FACADE.read_text(encoding="utf-8")
    match = re.search(
        r"export\s+Shannon\s*\((?P<body>[\s\S]*?)\)\s*\n\s*end\s+LeanInfoTheory",
        source,
    )
    if match is None:
        raise ValueError("could not find the explicit Shannon export block")
    names = re.findall(r"[A-Za-z_][A-Za-z0-9_]*", match.group("body"))
    if len(names) != len(set(names)):
        raise ValueError("the lightweight-root export block contains duplicates")
    return names


def has_simp_attribute(decl: api_index.Declaration) -> bool:
    lines = (ROOT / decl.path).read_text(encoding="utf-8").splitlines()
    index = decl.line - 1
    candidates = [lines[index]]
    cursor = index - 1
    while cursor >= 0 and lines[cursor].lstrip().startswith("@["):
        candidates.append(lines[cursor])
        cursor -= 1
    return any(re.search(r"@\[[^]]*\bsimp\b", line) for line in candidates)


def validate_surface(
    local_modules: set[str],
    supported_modules: set[str],
    non_stable_modules: set[str],
    all_declarations: list[api_index.Declaration],
    declarations: list[api_index.Declaration],
    root_exports: list[str],
) -> None:
    overlap = supported_modules & non_stable_modules
    if overlap:
        raise ValueError(f"non-stable modules entered the full umbrella: {sorted(overlap)}")

    partition = supported_modules | non_stable_modules
    if partition != local_modules:
        missing = sorted(local_modules - partition)
        unknown = sorted(partition - local_modules)
        raise ValueError(
            "supported and non-stable modules do not partition the local tree; "
            f"unclassified={missing}, unknown={unknown}"
        )

    names = [decl.name for decl in declarations]
    duplicates = sorted(name for name, count in Counter(names).items() if count > 1)
    if duplicates:
        raise ValueError(f"duplicate supported declaration names: {duplicates}")

    undocumented = [decl.name for decl in declarations if not decl.doc]
    if undocumented:
        raise ValueError(f"undocumented supported declarations: {undocumented}")

    invalid_namespaces = [
        decl.name
        for decl in declarations
        if not (
            decl.name.startswith("LeanInfoTheory.Shannon.")
            or decl.name.startswith("PMF.")
        )
    ]
    if invalid_namespaces:
        raise ValueError(
            "supported declarations outside LeanInfoTheory.Shannon/PMF: "
            f"{invalid_namespaces}"
        )

    aggregate_owned = [
        decl.name
        for decl in all_declarations
        if decl.module in AGGREGATE_MODULES
    ]
    if aggregate_owned:
        raise ValueError(f"aggregate modules own declarations: {aggregate_owned}")

    by_name = {decl.name: decl for decl in declarations}
    missing_exports = [
        name
        for name in root_exports
        if f"LeanInfoTheory.Shannon.{name}" not in by_name
    ]
    if missing_exports:
        raise ValueError(f"root exports without a supported target: {missing_exports}")


def build_manifest() -> dict[str, object]:
    infos = blueprint.build_module_infos()
    local_modules = {info.name for info in infos}
    supported_modules = module_closure(FULL_UMBRELLA, infos)
    non_stable_modules = {
        info.name for info in infos if info.layer == "Non-stable anchors"
    }
    all_declarations = api_index.all_declarations()
    declarations = [
        decl
        for decl in all_declarations
        if decl.module in supported_modules
    ]
    declarations.sort(key=lambda decl: decl.name)
    root_exports = parse_root_exports()

    validate_surface(
        local_modules,
        supported_modules,
        non_stable_modules,
        all_declarations,
        declarations,
        root_exports,
    )

    declaration_entries = []
    for decl in declarations:
        attributes = ["simp"] if has_simp_attribute(decl) else []
        declaration_entries.append(
            {
                "attributes": attributes,
                "kind": decl.kind,
                "module": decl.module,
                "name": decl.name,
            }
        )

    root_info = next(info for info in infos if info.name == ROOT_MODULE)
    namespace_counts = Counter(
        "PMF" if decl.name.startswith("PMF.") else "LeanInfoTheory.Shannon"
        for decl in declarations
    )
    kind_counts = Counter(decl.kind for decl in declarations)
    simp_count = sum(
        "simp" in entry["attributes"] for entry in declaration_entries
    )

    return {
        "schema": "lean-info-theory.public-api.v0.1.v1",
        "release_line": "0.1.x",
        "full_umbrella": FULL_UMBRELLA,
        "lightweight_root": ROOT_MODULE,
        "lightweight_root_direct_imports": list(root_info.local_imports),
        "local_module_count": len(local_modules),
        "aggregate_declaration_counts": {
            module: sum(
                decl.module == module for decl in all_declarations
            )
            for module in sorted(AGGREGATE_MODULES)
        },
        "supported_module_count": len(supported_modules),
        "supported_modules": sorted(supported_modules),
        "non_stable_module_count": len(non_stable_modules),
        "non_stable_modules": sorted(non_stable_modules),
        "declaration_count": len(declarations),
        "documented_declaration_count": len(declarations),
        "kind_counts": dict(sorted(kind_counts.items())),
        "namespace_counts": dict(sorted(namespace_counts.items())),
        "simp_declaration_count": simp_count,
        "root_export_count": len(root_exports),
        "root_exports": [
            {
                "alias": f"LeanInfoTheory.{name}",
                "target": f"LeanInfoTheory.Shannon.{name}",
            }
            for name in root_exports
        ],
        "declarations": declaration_entries,
        "scope_notes": [
            "This manifest covers project-owned public declarations in the transitive closure of LeanInfoTheory.Shannon.",
            "Imported mathlib declarations and private declarations are outside this manifest.",
            "LeanInfoTheory.Basic, LeanInfoTheory.MathlibFragments, and the LeanInfoTheory.Examples hierarchy are non-stable.",
            "Declaration types and assumptions remain governed by the Lean source and signature-bearing API documentation.",
        ],
    }


def rendered_manifest() -> str:
    return json.dumps(build_manifest(), indent=2, sort_keys=True) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--check",
        action="store_true",
        help="fail unless the checked-in manifest matches the current source",
    )
    args = parser.parse_args()

    rendered = rendered_manifest()
    if args.check:
        if not OUTPUT.exists():
            print(f"missing generated manifest: {OUTPUT.relative_to(ROOT)}")
            return 1
        if OUTPUT.read_text(encoding="utf-8") != rendered:
            print(
                "public API manifest is stale; run "
                "python scripts/generate_v0_1_public_api.py"
            )
            return 1
        print("v0.1.x public API manifest is current")
        return 0

    OUTPUT.write_text(rendered, encoding="utf-8")
    manifest = json.loads(rendered)
    print(
        "Wrote "
        f"{OUTPUT.relative_to(ROOT)} with "
        f"{manifest['supported_module_count']} modules, "
        f"{manifest['declaration_count']} declarations, and "
        f"{manifest['root_export_count']} root exports."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
