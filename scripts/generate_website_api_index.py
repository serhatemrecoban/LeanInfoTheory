#!/usr/bin/env python3
"""Generate a lightweight source-derived declaration index for the website.

This is not a replacement for Lean doc-gen. It records the public declarations
we can reliably extract from local Lean source files, together with module
names, declaration kinds, source locations, and nearby doc comments.
"""

from __future__ import annotations

import html
import json
import re
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEAN_ROOT = ROOT / "LeanInfoTheory"
ROOT_MODULE_FILE = ROOT / "LeanInfoTheory.lean"
OUTPUT_DIR = ROOT / "home_page" / "docs"
HTML_OUTPUT = OUTPUT_DIR / "api-index.html"
JSON_OUTPUT = OUTPUT_DIR / "declaration_index.json"
GITHUB_SOURCE_ROOT = "https://github.com/serhatemrecoban/LeanInfoTheory/blob/master"


DECL_RE = re.compile(
    r"^\s*"
    r"(?:(?P<private>private)\s+)?"
    r"(?:(?:noncomputable|partial|unsafe|protected)\s+)*"
    r"(?P<kind>abbrev|class|def|inductive|instance|lemma|structure|theorem)\s+"
    r"(?P<name>[A-Za-z_][A-Za-z0-9_'.!?]*)"
)


KIND_LABELS = {
    "abbrev": "Definition",
    "class": "Structure",
    "def": "Definition",
    "inductive": "Inductive",
    "instance": "Instance",
    "lemma": "Theorem",
    "structure": "Structure",
    "theorem": "Theorem",
}


@dataclass(frozen=True)
class Declaration:
    name: str
    short_name: str
    kind: str
    module: str
    path: str
    line: int
    doc: str


def lean_files() -> list[Path]:
    files = [ROOT_MODULE_FILE]
    files.extend(sorted(LEAN_ROOT.rglob("*.lean")))
    return files


def module_name_from_path(path: Path) -> str:
    if path == ROOT_MODULE_FILE:
        return "LeanInfoTheory"
    rel = path.relative_to(ROOT).with_suffix("")
    return ".".join(rel.parts)


def clean_doc_line(line: str) -> str:
    stripped = line.strip()
    if stripped.startswith("/--"):
        stripped = stripped[3:].strip()
    if stripped.endswith("-/"):
        stripped = stripped[:-2].strip()
    if stripped.startswith("*"):
        stripped = stripped[1:].strip()
    return stripped


def collect_doc(lines: list[str], start_index: int) -> tuple[str, int]:
    line = lines[start_index]
    if "-/" in line:
        return clean_doc_line(line), start_index

    doc_lines = [clean_doc_line(line)]
    index = start_index + 1
    while index < len(lines):
        doc_lines.append(clean_doc_line(lines[index]))
        if "-/" in lines[index]:
            break
        index += 1
    doc = " ".join(part for part in doc_lines if part)
    doc = re.sub(r"\s+", " ", doc).strip()
    return doc, index


def qualified_name(namespace_stack: list[str], short_name: str) -> str:
    if "." in short_name:
        prefix = ".".join(namespace_stack)
        return f"{prefix}.{short_name}" if prefix else short_name
    if namespace_stack:
        return ".".join([*namespace_stack, short_name])
    return short_name


def parse_declarations(path: Path) -> list[Declaration]:
    module = module_name_from_path(path)
    rel_path = str(path.relative_to(ROOT)).replace("\\", "/")
    lines = path.read_text(encoding="utf-8").splitlines()
    namespace_stack: list[str] = []
    pending_doc = ""
    declarations: list[Declaration] = []
    index = 0

    while index < len(lines):
        line = lines[index]
        stripped = line.strip()

        if stripped.startswith("/--"):
            pending_doc, index = collect_doc(lines, index)
            index += 1
            continue

        if stripped.startswith("namespace "):
            namespace = stripped.removeprefix("namespace ").strip()
            if namespace:
                namespace_stack.extend(namespace.split("."))
            pending_doc = ""
            index += 1
            continue

        if stripped.startswith("end "):
            name = stripped.removeprefix("end ").strip()
            if name and namespace_stack and namespace_stack[-1] == name.split(".")[-1]:
                namespace_stack.pop()
            pending_doc = ""
            index += 1
            continue

        match = DECL_RE.match(line)
        if match:
            short_name = match.group("name")
            kind = match.group("kind")
            if not match.group("private"):
                declarations.append(
                    Declaration(
                        name=qualified_name(namespace_stack, short_name),
                        short_name=short_name,
                        kind=kind,
                        module=module,
                        path=rel_path,
                        line=index + 1,
                        doc=pending_doc,
                    )
                )
            pending_doc = ""
            index += 1
            continue

        if stripped and not stripped.startswith("@[") and not stripped.startswith("/-"):
            pending_doc = ""

        index += 1

    return declarations


def all_declarations() -> list[Declaration]:
    declarations: list[Declaration] = []
    for path in lean_files():
        declarations.extend(parse_declarations(path))
    return sorted(declarations, key=lambda decl: (decl.module, decl.line, decl.name))


def decl_to_dict(decl: Declaration) -> dict[str, object]:
    return {
        "name": decl.name,
        "short_name": decl.short_name,
        "kind": decl.kind,
        "kind_label": KIND_LABELS[decl.kind],
        "module": decl.module,
        "path": decl.path,
        "line": decl.line,
        "doc": decl.doc,
    }


def kind_counts(declarations: list[Declaration]) -> dict[str, int]:
    counts: dict[str, int] = {}
    for decl in declarations:
        label = KIND_LABELS[decl.kind]
        counts[label] = counts.get(label, 0) + 1
    return dict(sorted(counts.items()))


def write_json(declarations: list[Declaration]) -> None:
    documented = sum(1 for decl in declarations if decl.doc)
    data = {
        "schema": "lean-info-theory.declaration-index.v1",
        "declaration_count": len(declarations),
        "documented_count": documented,
        "undocumented_count": len(declarations) - documented,
        "kind_counts": kind_counts(declarations),
        "modules": sorted({decl.module for decl in declarations}),
        "declarations": [decl_to_dict(decl) for decl in declarations],
    }
    JSON_OUTPUT.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def source_link(decl: Declaration) -> str:
    return f"{GITHUB_SOURCE_ROOT}/{decl.path}#L{decl.line}"


def declaration_id(decl: Declaration) -> str:
    slug = re.sub(r"[^A-Za-z0-9_-]+", "-", decl.name).strip("-")
    return f"decl-{slug}"


def doc_text(decl: Declaration) -> str:
    if decl.doc:
        return html.escape(decl.doc)
    return '<span class="muted">No doc comment found.</span>'


def metric_cards(declarations: list[Declaration]) -> str:
    counts = kind_counts(declarations)
    documented = sum(1 for decl in declarations if decl.doc)
    modules = len({decl.module for decl in declarations})
    theorem_count = counts.get("Theorem", 0)
    definition_count = counts.get("Definition", 0)
    return f"""
        <div class="metric-grid">
          <div class="metric-card"><strong>{len(declarations)}</strong><span>public declarations</span></div>
          <div class="metric-card"><strong>{modules}</strong><span>modules with declarations</span></div>
          <div class="metric-card"><strong>{theorem_count}</strong><span>theorems and lemmas</span></div>
          <div class="metric-card"><strong>{definition_count}</strong><span>definitions and abbrevs</span></div>
          <div class="metric-card"><strong>{documented}</strong><span>with doc comments</span></div>
        </div>
"""


def kind_rows(declarations: list[Declaration]) -> str:
    rows = []
    for label, count in kind_counts(declarations).items():
        rows.append(f"<tr><td>{html.escape(label)}</td><td>{count}</td></tr>")
    return "\n".join(rows)


def declaration_rows(declarations: list[Declaration]) -> str:
    rows = []
    for decl in declarations:
        rows.append(
            f"<tr id=\"{html.escape(declaration_id(decl))}\">"
            f"<td><code>{html.escape(decl.name)}</code></td>"
            f"<td>{html.escape(KIND_LABELS[decl.kind])}</td>"
            f"<td><code>{html.escape(decl.module)}</code></td>"
            f"<td>{doc_text(decl)}</td>"
            f"<td><a href=\"{html.escape(source_link(decl))}\">line {decl.line}</a></td>"
            "</tr>"
        )
    return "\n".join(rows)


def generated_html(declarations: list[Declaration]) -> str:
    return f"""<!doctype html>
<html lang="en-US">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Generated declaration index | LeanInfoTheory</title>
    <link rel="stylesheet" href="../styles.css">
  </head>
  <body>
    <header class="page-header" role="banner">
      <h1 class="project-name">Generated Declaration Index</h1>
      <h2 class="project-tagline">Source-derived declaration inventory for LeanInfoTheory.</h2>
      <nav class="project-links" aria-label="Project links">
        <a href="../" class="btn">Home</a>
        <a href="../theorems.html" class="btn">Theorems</a>
        <a href="../submodularity-demo.html" class="btn">Demo</a>
        <a href="./api-index.html" class="btn">API Index</a>
        <a href="../blueprint/" class="btn">Blueprint</a>
        <a href="https://github.com/serhatemrecoban/LeanInfoTheory" class="btn">GitHub</a>
      </nav>
    </header>
    <main class="main-content" role="main">
      <section class="status-strip" aria-label="Generation status">
        <p>
          Generated by <code>scripts/generate_website_api_index.py</code> from
          local Lean source files. This is a lightweight declaration index,
          not full Lean doc-gen output.
        </p>
      </section>

      <section aria-labelledby="metrics-heading">
        <h2 id="metrics-heading">Current Index</h2>
{metric_cards(declarations)}
      </section>

      <section aria-labelledby="kind-heading">
        <h2 id="kind-heading">Declaration Kinds</h2>
        <table class="status-table">
          <thead>
            <tr>
              <th scope="col">Kind</th>
              <th scope="col">Count</th>
            </tr>
          </thead>
          <tbody>
{kind_rows(declarations)}
          </tbody>
        </table>
      </section>

      <section aria-labelledby="declarations-heading">
        <h2 id="declarations-heading">Declarations</h2>
        <table class="status-table">
          <thead>
            <tr>
              <th scope="col">Declaration</th>
              <th scope="col">Kind</th>
              <th scope="col">Module</th>
              <th scope="col">Doc comment</th>
              <th scope="col">Source</th>
            </tr>
          </thead>
          <tbody>
{declaration_rows(declarations)}
          </tbody>
        </table>
        <p>
          The machine-readable declaration index is available as
          <a href="declaration_index.json"><code>declaration_index.json</code></a>.
        </p>
      </section>
    </main>
  </body>
</html>
"""


def write_html(declarations: list[Declaration]) -> None:
    HTML_OUTPUT.write_text(generated_html(declarations), encoding="utf-8")


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    declarations = all_declarations()
    write_json(declarations)
    write_html(declarations)
    print(f"wrote {HTML_OUTPUT.relative_to(ROOT)}")
    print(f"wrote {JSON_OUTPUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
