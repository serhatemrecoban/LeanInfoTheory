#!/usr/bin/env python3
"""Generate the static module-level blueprint page from Lean imports.

This is intentionally modest: it parses local `import` lines, computes the
current LeanInfoTheory module dependency map, and emits website artifacts. It
does not try to generate theorem-level dependencies or declaration
documentation.
"""

from __future__ import annotations

import html
import json
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEAN_ROOT = ROOT / "LeanInfoTheory"
ROOT_MODULE_FILE = ROOT / "LeanInfoTheory.lean"
OUTPUT_DIR = ROOT / "home_page" / "blueprint"
HTML_OUTPUT = OUTPUT_DIR / "dep_graph_document.html"
JSON_OUTPUT = OUTPUT_DIR / "module_graph.json"


MODULE_SUMMARIES = {
    "LeanInfoTheory": "Lightweight public root import for stable finite Shannon and core certificate APIs.",
    "LeanInfoTheory.Basic": "Project namespace and shared status vocabulary.",
    "LeanInfoTheory.Probability.Finite": "Finite PMF real-mass bridge lemmas and pointwise PMF.map facts.",
    "LeanInfoTheory.Shannon.Entropy": "Finite Shannon entropy, entropy of finite-valued random variables, and first entropy invariance theorems.",
    "LeanInfoTheory.Shannon.EntropyBounds": "Jensen-based finite entropy upper bound and uniform-law equality theorem.",
    "LeanInfoTheory.Shannon.InfoMeasures": "Marginals, conditional entropy, mutual information, conditional mutual information, and orientation lemmas.",
    "LeanInfoTheory.Shannon.SemanticBridge": "Entry point for expected self-information, finite conditional laws, KL bridges, nonnegativity, and chain rules.",
    "LeanInfoTheory.Shannon.SemanticBridge.Product": "Independent-product PMFs, product-measure semantics, support formulas, and absolute-continuity facts.",
    "LeanInfoTheory.Shannon.SemanticBridge.FiniteSums": "Finite real-sum rewrites and mutual-information log-ratio formulas.",
    "LeanInfoTheory.Shannon.SemanticBridge.Conditional": "Finite conditional-law API and expected conditional entropy / conditional mutual-information formulas.",
    "LeanInfoTheory.Shannon.SemanticBridge.KL": "Finite KL expansion, mutual information as KL, and averaged conditional-KL bridge theorems.",
    "LeanInfoTheory.Shannon.SemanticBridge.Theorems": "User-facing semantic nonnegativity and first mutual-information chain-rule theorems.",
    "LeanInfoTheory.InformationMeasures": "Convenience re-export for the finite information-measure API.",
    "LeanInfoTheory.EntropyExpr": "Formal rational entropy-expression algebra and empty-entropy convention interface.",
    "LeanInfoTheory.EntropyVal": "Abstract Shannon entropy valuations for certificate soundness.",
    "LeanInfoTheory.PrimitiveIneq": "Primitive Shannon inequality expressions and soundness under abstract valuations.",
    "LeanInfoTheory.Certificate": "Nonnegative-combination certificate soundness and exact decomposition matching.",
    "LeanInfoTheory.Certificate.Checked": "Raw/checked certificate split with a first validator.",
    "LeanInfoTheory.Certificate.Submodularity": "First non-toy checked certificate demo, proving entropy submodularity.",
    "LeanInfoTheory.Certificate.Subadditivity": "Checked certificate demo proving entropy subadditivity.",
    "LeanInfoTheory.Certificate.Monotonicity": "Checked certificate demo proving one-variable entropy monotonicity.",
    "LeanInfoTheory.Certificate.ThreeWaySubadditivity": "Manual certificate pressure-test module for three-way entropy subadditivity.",
    "LeanInfoTheory.Examples": "Separately importable toy examples for the certificate layers.",
    "LeanInfoTheory.MathlibFragments": "Separately importable checklist of heavier mathlib information-theory and coding anchors.",
}


LAYER_ORDER = [
    "Root import",
    "Shared foundation",
    "Finite Shannon layer",
    "Semantic bridge layer",
    "Certificate layer",
    "Reference anchors",
]


@dataclass(frozen=True)
class ModuleInfo:
    name: str
    path: str
    local_imports: tuple[str, ...]
    external_imports: tuple[str, ...]
    layer: str
    root_reachable: bool
    summary: str


def module_name_from_path(path: Path) -> str:
    if path == ROOT_MODULE_FILE:
        return "LeanInfoTheory"
    rel = path.relative_to(ROOT).with_suffix("")
    return ".".join(rel.parts)


def lean_files() -> list[Path]:
    files = [ROOT_MODULE_FILE]
    files.extend(sorted(LEAN_ROOT.rglob("*.lean")))
    return files


def parse_imports(path: Path) -> list[str]:
    imports: list[str] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if stripped.startswith("import "):
            imports.append(stripped.removeprefix("import ").strip())
    return imports


def classify_module(name: str) -> str:
    if name == "LeanInfoTheory":
        return "Root import"
    if name in {"LeanInfoTheory.Basic", "LeanInfoTheory.Probability.Finite"}:
        return "Shared foundation"
    if name == "LeanInfoTheory.MathlibFragments":
        return "Reference anchors"
    if name.startswith("LeanInfoTheory.Shannon.SemanticBridge"):
        return "Semantic bridge layer"
    if name.startswith("LeanInfoTheory.Shannon") or name == "LeanInfoTheory.InformationMeasures":
        return "Finite Shannon layer"
    return "Certificate layer"


def root_reachable_modules(import_graph: dict[str, list[str]]) -> set[str]:
    seen: set[str] = set()
    stack = ["LeanInfoTheory"]
    while stack:
        current = stack.pop()
        if current in seen:
            continue
        seen.add(current)
        stack.extend(import_graph.get(current, []))
    return seen


def build_module_infos() -> list[ModuleInfo]:
    files = lean_files()
    local_modules = {module_name_from_path(path) for path in files}
    raw_imports = {module_name_from_path(path): parse_imports(path) for path in files}
    local_graph = {
        module: sorted(imp for imp in imports if imp in local_modules)
        for module, imports in raw_imports.items()
    }
    reachable = root_reachable_modules(local_graph)

    infos = []
    for path in files:
        name = module_name_from_path(path)
        imports = raw_imports[name]
        local_imports = tuple(sorted(imp for imp in imports if imp in local_modules))
        external_imports = tuple(sorted(imp for imp in imports if imp not in local_modules))
        infos.append(
            ModuleInfo(
                name=name,
                path=str(path.relative_to(ROOT)).replace("\\", "/"),
                local_imports=local_imports,
                external_imports=external_imports,
                layer=classify_module(name),
                root_reachable=name in reachable,
                summary=MODULE_SUMMARIES.get(name, "Local LeanInfoTheory module."),
            )
        )
    return sorted(infos, key=lambda info: (LAYER_ORDER.index(info.layer), info.name))


def status_label(info: ModuleInfo) -> str:
    if info.name == "LeanInfoTheory":
        return "root"
    if info.root_reachable:
        return "root reachable"
    return "separate import"


def status_class(info: ModuleInfo) -> str:
    if info.root_reachable:
        return "proved"
    return "separate"


def code_list(items: tuple[str, ...]) -> str:
    if not items:
        return "<span class=\"muted\">none</span>"
    return "<br>".join(f"<code>{html.escape(item)}</code>" for item in items)


def module_to_dict(info: ModuleInfo) -> dict[str, object]:
    return {
        "name": info.name,
        "path": info.path,
        "layer": info.layer,
        "root_reachable": info.root_reachable,
        "local_imports": list(info.local_imports),
        "external_imports": list(info.external_imports),
        "summary": info.summary,
    }


def write_json(infos: list[ModuleInfo]) -> None:
    local_edge_count = sum(len(info.local_imports) for info in infos)
    data = {
        "schema": "lean-info-theory.module-graph.v1",
        "root": "LeanInfoTheory",
        "module_count": len(infos),
        "local_edge_count": local_edge_count,
        "root_reachable_count": sum(1 for info in infos if info.root_reachable),
        "separate_import_count": sum(1 for info in infos if not info.root_reachable),
        "layers": LAYER_ORDER,
        "modules": [module_to_dict(info) for info in infos],
    }
    JSON_OUTPUT.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def layer_summary_rows(infos: list[ModuleInfo]) -> str:
    rows = []
    for layer in LAYER_ORDER:
        layer_infos = [info for info in infos if info.layer == layer]
        if not layer_infos:
            continue
        root_count = sum(1 for info in layer_infos if info.root_reachable)
        rows.append(
            "<tr>"
            f"<td>{html.escape(layer)}</td>"
            f"<td>{len(layer_infos)}</td>"
            f"<td>{root_count}</td>"
            f"<td>{len(layer_infos) - root_count}</td>"
            "</tr>"
        )
    return "\n".join(rows)


def module_rows(infos: list[ModuleInfo]) -> str:
    rows = []
    for info in infos:
        rows.append(
            "<tr>"
            f"<td><code>{html.escape(info.name)}</code></td>"
            f"<td>{html.escape(info.layer)}</td>"
            f"<td><span class=\"status-pill {status_class(info)}\">{html.escape(status_label(info))}</span></td>"
            f"<td>{html.escape(info.summary)}</td>"
            f"<td><code>{html.escape(info.path)}</code></td>"
            "</tr>"
        )
    return "\n".join(rows)


def dependency_rows(infos: list[ModuleInfo]) -> str:
    rows = []
    for info in infos:
        rows.append(
            "<tr>"
            f"<td><code>{html.escape(info.name)}</code></td>"
            f"<td>{code_list(info.local_imports)}</td>"
            f"<td>{len(info.external_imports)}</td>"
            "</tr>"
        )
    return "\n".join(rows)


def generated_html(infos: list[ModuleInfo]) -> str:
    module_count = len(infos)
    edge_count = sum(len(info.local_imports) for info in infos)
    root_count = sum(1 for info in infos if info.root_reachable)
    separate_count = module_count - root_count
    return f"""<!doctype html>
<html lang="en-US">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Generated module dependency map | LeanInfoTheory</title>
    <link rel="stylesheet" href="../styles.css">
  </head>
  <body>
    <header class="page-header" role="banner">
      <h1 class="project-name">Generated Module Dependency Map</h1>
      <h2 class="project-tagline">Module-level graph generated from Lean import lines.</h2>
      <nav class="project-links" aria-label="Project links">
        <a href="../" class="btn">Home</a>
        <a href="../theorems.html" class="btn">Theorems</a>
        <a href="../submodularity-demo.html" class="btn">Demo</a>
        <a href="../docs/api-index.html" class="btn">API Index</a>
        <a href="./" class="btn">Blueprint</a>
        <a href="https://github.com/serhatemrecoban/LeanInfoTheory" class="btn">GitHub</a>
      </nav>
    </header>
    <main class="main-content" role="main">
      <section class="status-strip" aria-label="Generation status">
        <p>
          Generated by <code>scripts/generate_website_blueprint.py</code> from
          local Lean <code>import</code> lines. This is a module-level dependency map; a
          theorem-level leanblueprint graph and full Lean doc-gen output are
          still future milestones.
        </p>
      </section>

      <section aria-labelledby="metrics-heading">
        <h2 id="metrics-heading">Current Graph</h2>
        <div class="metric-grid">
          <div class="metric-card"><strong>{module_count}</strong><span>local modules</span></div>
          <div class="metric-card"><strong>{edge_count}</strong><span>local import edges</span></div>
          <div class="metric-card"><strong>{root_count}</strong><span>root-reachable modules</span></div>
          <div class="metric-card"><strong>{separate_count}</strong><span>separate-import modules</span></div>
        </div>
      </section>

      <section aria-labelledby="layers-heading">
        <h2 id="layers-heading">Layer Summary</h2>
        <table class="status-table">
          <thead>
            <tr>
              <th scope="col">Layer</th>
              <th scope="col">Modules</th>
              <th scope="col">Root reachable</th>
              <th scope="col">Separate import</th>
            </tr>
          </thead>
          <tbody>
{layer_summary_rows(infos)}
          </tbody>
        </table>
      </section>

      <section aria-labelledby="modules-heading">
        <h2 id="modules-heading">Module Inventory</h2>
        <table class="status-table">
          <thead>
            <tr>
              <th scope="col">Module</th>
              <th scope="col">Layer</th>
              <th scope="col">Import surface</th>
              <th scope="col">Summary</th>
              <th scope="col">Source file</th>
            </tr>
          </thead>
          <tbody>
{module_rows(infos)}
          </tbody>
        </table>
      </section>

      <section aria-labelledby="deps-heading">
        <h2 id="deps-heading">Local Import Edges</h2>
        <table class="status-table">
          <thead>
            <tr>
              <th scope="col">Module</th>
              <th scope="col">Local imports</th>
              <th scope="col">External imports</th>
            </tr>
          </thead>
          <tbody>
{dependency_rows(infos)}
          </tbody>
        </table>
        <p>
          The machine-readable graph is available as
          <a href="module_graph.json"><code>module_graph.json</code></a>.
        </p>
      </section>
    </main>
  </body>
</html>
"""


def write_html(infos: list[ModuleInfo]) -> None:
    HTML_OUTPUT.write_text(generated_html(infos), encoding="utf-8")


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    infos = build_module_infos()
    write_json(infos)
    write_html(infos)
    print(f"wrote {HTML_OUTPUT.relative_to(ROOT)}")
    print(f"wrote {JSON_OUTPUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
