"""Pure historical/current API policy checks for the standalone C9.02 gate.

Approval records are reviewed source, never generated inventory. References record
the review decision but cannot authenticate it. Root-boundary and retained-contract
requirements cannot be overridden by an additive approval. Compiled input must come
from the parent's fresh, source-bound audit; these functions do not establish build
freshness, authenticate JSON, compare retained types, or prove semantic equivalence.
"""

from __future__ import annotations

import copy
import json
import re
from typing import Any

from frozen_public_api import baseline_identity as release_identity
from generate_website_blueprint import classify_module


POLICY_SCHEMA = "lean-info-theory.current-api-policy.v1"
EXPECTED_SCHEMA = "lean-info-theory.current-api-policy-expectations.v1"
COMPILED_SCHEMA = "lean-info-theory.current-compiled-audit.v1"
ROOT_MODULE = "LeanInfoTheory"
FULL_MODULE = "LeanInfoTheory.Shannon"
UMBRELLAS = {FULL_MODULE, "LeanInfoTheory.Shannon.SemanticBridge"}
AGGREGATES = UMBRELLAS | {ROOT_MODULE, "LeanInfoTheory.InformationMeasures"}
ROOT_DIRECT = {"LeanInfoTheory.Probability.Finite", "LeanInfoTheory.InformationMeasures"}
ROOT_CLOSURE = ROOT_DIRECT | {
    ROOT_MODULE, "LeanInfoTheory.Shannon.Entropy", "LeanInfoTheory.Shannon.InfoMeasures",
}
KINDS = {"theorem", "def", "abbrev", "instance"}
NAME_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_']*(?:\.[A-Za-z_][A-Za-z0-9_']*)*")
REVIEW_FIELDS = {"rationale", "consumer", "approval_reference"}


class PolicyError(ValueError):
    """A bounded diagnostic with a stable machine-readable reason and subject."""

    def __init__(self, code: str, subject: str, expected: Any = None, actual: Any = None):
        self.code, self.subject = code, subject
        self.expected, self.actual = expected, actual
        detail = ""
        if expected is not None or actual is not None:
            detail = f"; expected={_short(expected)}, actual={_short(actual)}"
        super().__init__(f"{code}: {subject}{detail}")


def _short(value: Any) -> str:
    text = json.dumps(value, ensure_ascii=False, sort_keys=True)
    return text if len(text) <= 320 else text[:317] + "..."


def _require(condition: bool, code: str, subject: str, expected: Any = None, actual: Any = None) -> None:
    if not condition:
        raise PolicyError(code, subject, expected, actual)


def _object(value: Any, subject: str, keys: set[str] | None = None) -> dict:
    _require(isinstance(value, dict), "POLICY_SCHEMA", subject, "object", type(value).__name__)
    if keys is not None:
        _require(set(value) == keys, "POLICY_SCHEMA", subject, sorted(keys), sorted(value))
    return value


def _list(value: Any, subject: str) -> list:
    _require(isinstance(value, list), "POLICY_SCHEMA", subject, "array", type(value).__name__)
    return value


def _name(value: Any, subject: str, *, module: bool = False) -> str:
    _require(isinstance(value, str) and NAME_RE.fullmatch(value) is not None,
             "POLICY_SCHEMA", subject, "qualified identifier", value)
    if module:
        _require(value == ROOT_MODULE or value.startswith(ROOT_MODULE + "."),
                 "POLICY_SCHEMA", subject, "project module", value)
    return value


def _names(value: Any, subject: str, *, module: bool = False) -> list[str]:
    names = [_name(item, subject, module=module) for item in _list(value, subject)]
    _require(len(names) == len(set(names)), "POLICY_DUPLICATE", subject)
    return sorted(names)


def _imports(value: Any, subject: str) -> dict[str, list[str]]:
    value = _object(value, subject, {"local", "external"})
    local = _names(value["local"], subject + ".local", module=True)
    external = _names(value["external"], subject + ".external")
    _require(not any(name == ROOT_MODULE or name.startswith(ROOT_MODULE + ".") for name in external),
             "SOURCE_IMPORT_GRAPH", subject, "project imports classified as local", external)
    return {"local": local, "external": external}


def _import_map(value: Any, subject: str) -> dict[str, dict[str, list[str]]]:
    value = _object(value, subject)
    return {_name(owner, subject, module=True): _imports(imports, subject + "." + owner)
            for owner, imports in sorted(value.items())}


def _review(record: dict, subject: str) -> None:
    for field in REVIEW_FIELDS:
        _require(isinstance(record[field], str) and bool(record[field].strip()),
                 "POLICY_REVIEW_REFERENCE", subject + "." + field)


def _unique(records: list[dict], key: str, subject: str) -> dict[str, dict]:
    result = {}
    for record in records:
        name = record[key]
        _require(name not in result, "POLICY_DUPLICATE", subject + "." + name)
        result[name] = record
    return result


def parse_policy(raw: str | bytes) -> dict:
    """Parse JSON without losing duplicate object keys or accepting NaN/Infinity."""
    _require(isinstance(raw, (str, bytes)), "POLICY_SCHEMA", "policy JSON input", "UTF-8 text or bytes")
    def pairs(items: list[tuple[str, Any]]) -> dict:
        result = {}
        for key, value in items:
            _require(key not in result, "POLICY_DUPLICATE", "JSON key " + key)
            result[key] = value
        return result

    def constant(value: str) -> None:
        raise PolicyError("POLICY_SCHEMA", "non-JSON numeric constant " + value)

    try:
        if isinstance(raw, bytes):
            raw = raw.decode("utf-8")
        return _object(json.loads(raw, object_pairs_hook=pairs, parse_constant=constant), "policy")
    except (UnicodeError, json.JSONDecodeError) as exc:
        raise PolicyError("POLICY_SCHEMA", "invalid UTF-8 policy JSON") from exc


def validate_policy(policy: dict, baseline_identity: dict) -> dict:
    """Validate a small, explicit approval document and return an independent copy.

    Import records contain exact post-change direct imports. Every new supported
    module needs its own ``new_module`` record; existing umbrella changes must be
    additive. ``focused_exception`` records identify explicit architecture review
    outside the five protected root owners. No wildcard or count approvals exist.
    """
    policy = _object(policy, "policy", {
        "schema", "baseline_identity", "import_approvals", "simp_additions", "root_export_additions",
    })
    _require(policy["schema"] == POLICY_SCHEMA, "POLICY_SCHEMA", "policy.schema", POLICY_SCHEMA, policy["schema"])
    _require(policy["baseline_identity"] == baseline_identity,
             "POLICY_IDENTITY", "policy.baseline_identity", baseline_identity, policy["baseline_identity"])
    result = copy.deepcopy(policy)
    for record in _list(result["import_approvals"], "import_approvals"):
        _object(record, "import approval", {"owner", "kind", "imports"} | REVIEW_FIELDS)
        _name(record["owner"], "import approval owner", module=True)
        _require(record["kind"] in ("umbrella_addition", "focused_exception", "new_module"),
                 "POLICY_SCHEMA", "import approval kind", actual=record["kind"])
        record["imports"] = _imports(record["imports"], record["owner"])
        _review(record, record["owner"])
    _unique(result["import_approvals"], "owner", "import_approvals")
    for record in _list(result["simp_additions"], "simp_additions"):
        _object(record, "simp approval", {"name", "owner"} | REVIEW_FIELDS)
        _name(record["name"], "simp approval name")
        _name(record["owner"], "simp approval owner", module=True)
        _review(record, record["name"])
    _unique(result["simp_additions"], "name", "simp_additions")
    for record in _list(result["root_export_additions"], "root_export_additions"):
        _object(record, "root export approval", {"alias", "target"} | REVIEW_FIELDS)
        _alias(record["alias"], "root export approval")
        _name(record["target"], "root export target")
        _review(record, record["alias"])
    _unique(result["root_export_additions"], "alias", "root_export_additions")
    return result


def _alias(value: Any, subject: str) -> str:
    name = _name(value, subject)
    _require(name.rsplit(".", 1)[0] == ROOT_MODULE, "POLICY_SCHEMA", subject, "immediate root facade alias", name)
    return name


def _aliases(value: Any, subject: str) -> dict[str, str]:
    result = {}
    for entry in _list(value, subject):
        _object(entry, subject, {"alias", "target"})
        alias = _alias(entry["alias"], subject)
        _require(alias not in result, "POLICY_DUPLICATE", subject + "." + alias)
        result[alias] = _name(entry["target"], subject)
    return dict(sorted(result.items()))


def _declarations(manifest: dict, subject: str) -> dict[str, dict]:
    result = {}
    for entry in _list(manifest.get("declarations"), subject + ".declarations"):
        _object(entry, subject + ".declaration", {"name", "module", "kind", "attributes"})
        name = _name(entry["name"], subject)
        _name(entry["module"], subject, module=True)
        _require(isinstance(entry["kind"], str) and entry["kind"] in KINDS,
                 "POLICY_SCHEMA", subject + ".kind", actual=entry["kind"])
        _require(entry["attributes"] in ([], ["simp"]), "POLICY_SCHEMA", subject + ".attributes", actual=entry["attributes"])
        _require(name not in result, "POLICY_DUPLICATE", subject + "." + name)
        result[name] = entry
    _require(type(manifest.get("declaration_count")) is int and manifest["declaration_count"] == len(result),
             "SOURCE_INVENTORY_SCHEMA", subject + ".declaration_count", len(result), manifest.get("declaration_count"))
    return result


def _closure(owner: str, graph: dict[str, dict[str, list[str]]]) -> list[str]:
    seen, pending = set(), [owner]
    while pending:
        name = pending.pop()
        _require(name in graph, "SOURCE_IMPORT_GRAPH", owner, "known local module", name)
        if name not in seen:
            seen.add(name)
            pending.extend(graph[name]["local"])
    return sorted(seen)


def _equal(code: str, subject: str, expected: Any, actual: Any) -> None:
    _require(expected == actual, code, subject, expected, actual)


def _require_imports(condition: bool, code: str, subject: str, expected: dict | None, actual: dict) -> None:
    """Preserve the caller's predicate and show only changed import entries."""
    if condition:
        return
    before = expected if expected is not None else {"local": [], "external": []}
    removed = {kind: sorted(set(before[kind]) - set(actual[kind])) for kind in ("local", "external")}
    added = {kind: sorted(set(actual[kind]) - set(before[kind])) for kind in ("local", "external")}
    raise PolicyError(code, subject, {"present": expected is not None, "removed": removed},
                      {"present": True, "added": added})


def validate_source_policy(frozen: dict, retained: dict, current: dict,
                           direct_imports: dict, policy: dict) -> dict:
    """Derive exact compiled expectations without modifying any supplied input.

    The caller independently verifies the frozen bytes, retained artifact/types and
    source freshness. This function checks their policy-relevant cross-links and
    compares fresh current parser facts with historical facts and explicit approvals.
    ``direct_imports`` is the complete current project source map, including the
    non-stable modules, with local/external lists already parsed by the shared parser.
    """
    for value, subject in ((frozen, "frozen"), (retained, "retained"), (current, "current")):
        _object(value, subject)
    _equal("POLICY_SCHEMA", "frozen.schema", "lean-info-theory.public-api.v0.1.v1", frozen.get("schema"))
    _equal("POLICY_SCHEMA", "retained.schema", "lean-info-theory.retained-contract.v0.1.0.v1", retained.get("schema"))
    _equal("POLICY_SCHEMA", "current.schema", "lean-info-theory.current-public-api.v1", current.get("schema"))
    identity = release_identity()
    _equal("POLICY_IDENTITY", "retained.release", identity, retained.get("release"))
    _equal("POLICY_IDENTITY", "current.baseline_identity", identity, current.get("baseline_identity"))
    for manifest, subject in ((frozen, "frozen"), (current, "current")):
        _equal("SOURCE_INVENTORY_SCHEMA", subject + ".full_umbrella", FULL_MODULE, manifest.get("full_umbrella"))
        _equal("SOURCE_INVENTORY_SCHEMA", subject + ".lightweight_root", ROOT_MODULE, manifest.get("lightweight_root"))
    policy = validate_policy(policy, identity)
    old = _declarations(frozen, "frozen")
    now = _declarations(current, "current")
    old_modules = set(_names(frozen.get("supported_modules"), "frozen.supported_modules", module=True))
    modules = set(_names(current.get("supported_modules"), "current.supported_modules", module=True))
    _require(old_modules <= modules, "RETAINED_MODULE_MISSING", "supported modules",
             sorted(old_modules), sorted(modules))
    old_imports = _import_map(retained.get("direct_imports"), "retained.direct_imports")
    _equal("HISTORICAL_IMPORT_SCHEMA", "retained direct-import owners", sorted(old_modules), sorted(old_imports))
    source = _import_map(direct_imports, "source.direct_imports")
    non_stable = set(_names(current.get("non_stable_modules"), "current.non_stable_modules", module=True))
    _equal("SOURCE_IMPORT_GRAPH", "complete local partition", sorted(source), sorted(modules | non_stable))
    _require(not modules & non_stable, "NON_STABLE_LEAKAGE", "current supported partition")
    for owner, imports in source.items():
        try:
            classified_non_stable = classify_module(owner) == "Non-stable anchors"
        except ValueError as exc:
            raise PolicyError("SOURCE_IMPORT_GRAPH", "unclassified module " + owner) from exc
        _require(classified_non_stable == (owner in non_stable), "NON_STABLE_LEAKAGE", owner)
        _require(set(imports["local"]) <= set(source), "SOURCE_IMPORT_GRAPH", owner,
                 "existing local imports", imports["local"])
    _equal("SOURCE_IMPORT_GRAPH", "full supported closure", sorted(modules), _closure(FULL_MODULE, source))
    for name, entry in now.items():
        _require(entry["module"] in modules, "SOURCE_INVENTORY_SCHEMA", name, "supported owner", entry["module"])
        _require(entry["module"] not in AGGREGATES, "SOURCE_INVENTORY_SCHEMA", name, "focused owner", entry["module"])
        _require(name.startswith("PMF.") or name.startswith("LeanInfoTheory.Shannon."),
                 "SOURCE_INVENTORY_SCHEMA", name, "supported public namespace")
    for name, entry in old.items():
        _require(name in now, "RETAINED_NAME_MISSING", name, entry, None)
        _equal("RETAINED_OWNER_CHANGED", name, entry["module"], now[name]["module"])
        _equal("RETAINED_KIND_CHANGED", name, entry["kind"], now[name]["kind"])
        _equal("RETAINED_SIMP_CHANGED", name, entry["attributes"], now[name]["attributes"])

    retained_names = {}
    for entry in _list(retained.get("declarations"), "retained.declarations"):
        _object(entry, "retained declaration")
        name = _name(entry.get("name"), "retained declaration")
        _require(name not in retained_names, "POLICY_DUPLICATE", "retained." + name)
        retained_names[name] = entry
    _equal("RETAINED_ARTIFACT_MISMATCH", "retained names", sorted(old), sorted(retained_names))
    for name, entry in old.items():
        _equal("RETAINED_ARTIFACT_MISMATCH", name + ".owner", entry["module"], retained_names[name].get("owner"))
        _equal("RETAINED_ARTIFACT_MISMATCH", name + ".source_kind", entry["kind"], retained_names[name].get("source_kind"))
    old_simp = {name for name, entry in old.items() if "simp" in entry["attributes"]}
    _equal("RETAINED_ARTIFACT_MISMATCH", "reviewed simp", sorted(old_simp),
           _names(retained.get("reviewed_simp"), "retained.reviewed_simp"))
    old_aliases = _aliases(frozen.get("root_exports"), "frozen.root_exports")
    _equal("RETAINED_ARTIFACT_MISMATCH", "root exports", old_aliases,
           _aliases(retained.get("root_exports"), "retained.root_exports"))

    _equal("ROOT_IMPORT_BOUNDARY", "historical root direct imports",
           {"local": sorted(ROOT_DIRECT), "external": []}, old_imports.get(ROOT_MODULE))
    _equal("ROOT_IMPORT_BOUNDARY", "historical root closure", sorted(ROOT_CLOSURE), _closure(ROOT_MODULE, old_imports))
    _equal("ROOT_IMPORT_BOUNDARY", "current root closure", sorted(ROOT_CLOSURE), _closure(ROOT_MODULE, source))
    for owner in sorted(ROOT_CLOSURE):
        _equal("ROOT_IMPORT_BOUNDARY", owner, old_imports[owner], source[owner])
    _equal("ROOT_IMPORT_BOUNDARY", "current root manifest imports", sorted(ROOT_DIRECT),
           _names(current.get("lightweight_root_direct_imports"), "current root imports", module=True))

    import_approvals = _unique(policy["import_approvals"], "owner", "import_approvals")
    used_imports = set()
    for owner in sorted(modules):
        if owner in old_imports and source[owner] == old_imports[owner]:
            continue
        _require_imports(owner in import_approvals, "IMPORT_APPROVAL_REQUIRED", owner,
                         old_imports.get(owner), source[owner])
        approval = import_approvals[owner]
        expected_kind = ("new_module" if owner not in old_modules else
                         "umbrella_addition" if owner in UMBRELLAS else "focused_exception")
        _equal("IMPORT_APPROVAL_KIND", owner, expected_kind, approval["kind"])
        _require_imports(approval["imports"] == source[owner], "IMPORT_APPROVAL_MISMATCH", owner,
                         approval["imports"], source[owner])
        if expected_kind == "umbrella_addition":
            for category in ("local", "external"):
                _require_imports(set(old_imports[owner][category]) <= set(source[owner][category]),
                                 "UMBRELLA_IMPORT_REMOVAL", owner + "." + category,
                                 old_imports[owner], source[owner])
        used_imports.add(owner)
    _equal("POLICY_UNUSED_APPROVAL", "import_approvals", sorted(import_approvals), sorted(used_imports))

    simp_approvals = _unique(policy["simp_additions"], "name", "simp_additions")
    used_simp = set()
    now_simp = {name for name, entry in now.items() if "simp" in entry["attributes"]}
    for name, record in simp_approvals.items():
        _require(name not in old, "POLICY_RETAINED_OVERRIDE", name)
        _require(name in now, "POLICY_UNUSED_APPROVAL", name)
        _equal("POLICY_OWNER_MISMATCH", name, now[name]["module"], record["owner"])
    for name in sorted(now_simp - old_simp):
        _require(name in simp_approvals, "SIMP_APPROVAL_REQUIRED", name)
        used_simp.add(name)
    _equal("POLICY_UNUSED_APPROVAL", "simp_additions", sorted(simp_approvals), sorted(used_simp))

    aliases = _aliases(current.get("root_exports"), "current.root_exports")
    counts = {
        "supported_module_count": len(modules), "non_stable_module_count": len(non_stable),
        "local_module_count": len(source), "root_export_count": len(aliases),
        "simp_declaration_count": len(now_simp), "documented_declaration_count": len(now),
    }
    for key, value in counts.items():
        _require(type(current.get(key)) is int and current[key] == value,
                 "SOURCE_INVENTORY_SCHEMA", "current." + key, value, current.get(key))
    for alias, target in old_aliases.items():
        _require(alias in aliases, "RETAINED_ALIAS_MISSING", alias, target, None)
        _equal("RETAINED_ALIAS_CHANGED", alias, target, aliases[alias])
    alias_approvals = _unique(policy["root_export_additions"], "alias", "root_export_additions")
    for alias, record in alias_approvals.items():
        _require(alias not in old_aliases, "POLICY_RETAINED_OVERRIDE", alias)
        _require(record["target"] in now, "POLICY_TARGET_MISMATCH", alias, actual=record["target"])
        _require(now[record["target"]]["module"] in ROOT_CLOSURE, "ROOT_EXPORT_BOUNDARY", alias)
    used_aliases = set()
    for alias, target in aliases.items():
        _require(target in now, "POLICY_TARGET_MISMATCH", alias, actual=target)
        if alias not in old_aliases:
            _require(alias in alias_approvals, "ROOT_EXPORT_APPROVAL_REQUIRED", alias)
            _equal("POLICY_TARGET_MISMATCH", alias, alias_approvals[alias]["target"], target)
            used_aliases.add(alias)
    _equal("POLICY_UNUSED_APPROVAL", "root_export_additions", sorted(alias_approvals), sorted(used_aliases))
    return {
        "schema": EXPECTED_SCHEMA,
        "supported_modules": sorted(modules),
        "direct_imports": {owner: copy.deepcopy(source[owner]) for owner in sorted(modules)},
        "module_closures": {owner: _closure(owner, source) for owner in sorted(modules)},
        "declarations": [{"name": name, "owner": entry["module"]} for name, entry in sorted(now.items())],
        "simp": sorted(old_simp | used_simp),
        "root_closure": sorted(ROOT_CLOSURE),
        "root_exports": [{"alias": alias, "target": target} for alias, target in aliases.items()],
    }


def _pairs(value: Any, subject: str) -> list[dict[str, str]]:
    result = {}
    for entry in _list(value, subject):
        _object(entry, subject, {"name", "owner"})
        name = _name(entry["name"], subject)
        _require(name not in result, "POLICY_DUPLICATE", subject + "." + name)
        result[name] = _name(entry["owner"], subject, module=True)
    return [{"name": name, "owner": owner} for name, owner in sorted(result.items())]


def _equal_members(code: str, subject: str, expected: list | dict, actual: list | dict) -> None:
    """Keep exact equality, but show differing entries before truncating output."""
    if expected == actual:
        return
    if isinstance(expected, dict):
        removed = {key: value for key, value in expected.items() if actual.get(key) != value}
        added = {key: value for key, value in actual.items() if expected.get(key) != value}
    else:
        removed = [item for item in expected if item not in actual]
        added = [item for item in actual if item not in expected]
    raise PolicyError(code, subject, {"removed": removed}, {"added": added})


def _compiled_import_map(value: Any, expected: dict) -> dict[str, dict[str, list[str]]]:
    """Remove only pinned Lean's ordinary/meta Init pair from copied arrays.

    Lean 4.33.1 Elab/Import.lean HeaderSyntax.imports inserts both entries before
    explicit imports. The source orchestrator must reject prelude and unsupported
    header modes; this pure interface deliberately requires the default pair.
    """
    value = _object(value, "compiled imports")
    owners = sorted(_name(owner, "compiled imports", module=True) for owner in value)
    _equal("COMPILED_IMPORT_COVERAGE", "direct imports", sorted(expected), owners)
    result = {}
    for owner in owners:
        entry = _object(value[owner], "compiled imports " + owner, {"local", "external"})
        external = list(_list(entry["external"], "compiled external imports " + owner))
        explicit_init = int("Init" in expected[owner]["external"])
        _equal("COMPILED_IMPLICIT_INIT_MISMATCH", owner + ".Init", 2 + explicit_init, external.count("Init"))
        external.remove("Init")
        external.remove("Init")
        result[owner] = _imports({"local": entry["local"], "external": external}, "compiled imports " + owner)
    return result


def compare_compiled_policy(expected: dict, compiled: dict) -> None:
    """Compare a fresh driver's exact audit with source/policy expectations.

    With source prelude/header modifiers rejected by the orchestrator, module
    headers must include exactly two implicit ``Init`` entries (ordinary and meta)
    plus one if explicitly sourced. Only the implicit pair is removed. Other
    duplicate imports and missing explicit imports remain errors; raw input stays
    unchanged. Every focused import must expose exactly the expected simp names
    belonging to declarations in its local closure, even if the full umbrella
    later restores a changed attribute. No alias, declaration or simp item is omitted.
    Olean path strings are canonicalized and checked by the driver; the parent
    establishes actual source/build provenance before supplying this JSON.
    """
    _object(expected, "expected", {"schema", "supported_modules", "direct_imports", "module_closures",
                                   "declarations", "simp", "root_closure", "root_exports"})
    _equal("POLICY_SCHEMA", "expected.schema", EXPECTED_SCHEMA, expected["schema"])
    _object(compiled, "compiled", {"schema", "supported_modules", "direct_imports", "module_closures",
                                   "declarations", "simp", "root_closure", "root_exports",
                                   "focused_declarations", "focused_simp", "root_resolutions", "olean_paths"})
    _equal("POLICY_SCHEMA", "compiled.schema", COMPILED_SCHEMA, compiled["schema"])
    modules = _names(expected["supported_modules"], "expected modules", module=True)
    _equal("COMPILED_MODULE_COVERAGE", "supported modules", modules,
           _names(compiled["supported_modules"], "compiled modules", module=True))
    declarations = _pairs(expected["declarations"], "expected declarations")
    _equal_members("COMPILED_DECLARATION_COVERAGE", "declarations", declarations,
           _pairs(compiled["declarations"], "compiled declarations"))
    simp = _names(expected["simp"], "expected simp")
    _equal_members("COMPILED_SIMP_MISMATCH", "simp", simp,
           _names(compiled["simp"], "compiled simp"))
    wanted_imports = _import_map(expected["direct_imports"], "expected imports")
    actual_imports = _compiled_import_map(compiled["direct_imports"], wanted_imports)
    _equal("COMPILED_IMPORT_COVERAGE", "direct imports", modules, sorted(actual_imports))
    _equal("POLICY_SCHEMA", "expected direct imports", modules, sorted(wanted_imports))
    closures = _object(compiled["module_closures"], "compiled module closures")
    focused = _object(compiled["focused_declarations"], "compiled focused declarations")
    focused_simp = _object(compiled["focused_simp"], "compiled focused simp")
    _equal("COMPILED_IMPORT_COVERAGE", "module closures", modules, sorted(closures))
    _equal("COMPILED_IMPORT_COVERAGE", "focused declarations", modules, sorted(focused))
    _equal("COMPILED_IMPORT_COVERAGE", "focused simp", modules,
           _names(list(focused_simp), "compiled focused simp modules", module=True))
    _equal("POLICY_SCHEMA", "expected module closures", modules, sorted(expected["module_closures"]))
    for owner in modules:
        actual = actual_imports[owner]
        wanted = wanted_imports[owner]
        _require_imports(wanted == actual, "COMPILED_DIRECT_IMPORT_MISMATCH", owner, wanted, actual)
        closure = _names(expected["module_closures"][owner], "expected closure " + owner, module=True)
        _equal("COMPILED_CLOSURE_MISMATCH", owner, closure,
               _names(closures[owner], "compiled closure " + owner, module=True))
        pairs = [entry for entry in declarations if entry["owner"] in closure]
        _equal_members("COMPILED_FOCUSED_COVERAGE", owner, pairs, _pairs(focused[owner], "focused " + owner))
        focused_names = {entry["name"] for entry in pairs}
        _equal_members("COMPILED_FOCUSED_SIMP_MISMATCH", owner,
                       [name for name in simp if name in focused_names],
                       _names(focused_simp[owner], "focused simp " + owner))
    _equal("COMPILED_ROOT_CLOSURE_MISMATCH", "root closure", _names(expected["root_closure"], "expected root", module=True),
           _names(compiled["root_closure"], "compiled root", module=True))
    aliases = _aliases(expected["root_exports"], "expected root exports")
    _equal_members("COMPILED_ROOT_ALIAS_MISMATCH", "enumerated root aliases", aliases,
           _aliases(compiled["root_exports"], "compiled root exports"))
    _equal_members("COMPILED_ROOT_RESOLUTION_MISMATCH", "resolved root aliases", aliases,
           _aliases(compiled["root_resolutions"], "compiled root resolutions"))
    paths = {}
    for entry in _list(compiled["olean_paths"], "compiled olean paths"):
        _object(entry, "compiled olean path", {"module", "resolved", "expected"})
        owner = _name(entry["module"], "compiled olean module", module=True)
        _require(owner not in paths, "POLICY_DUPLICATE", "olean path " + owner)
        for field in ("resolved", "expected"):
            _require(isinstance(entry[field], str) and bool(entry[field].strip()), "POLICY_SCHEMA", owner + "." + field)
        _equal("COMPILED_OLEAN_PATH_MISMATCH", owner, entry["expected"], entry["resolved"])
        paths[owner] = entry
    _equal("COMPILED_OLEAN_COVERAGE", "olean paths", modules, sorted(paths))
