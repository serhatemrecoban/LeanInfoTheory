"""Join release-tagged inventory and doc-gen inputs to the mathematical edition."""
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass, field
from html.parser import HTMLParser
import json
from pathlib import Path
import re
import subprocess
from urllib.parse import unquote, urlsplit
from urllib.request import urlopen

ROOT = Path(__file__).resolve().parents[1]
REPOSITORY = "serhatemrecoban/LeanInfoTheory"
GITHUB = f"https://github.com/{REPOSITORY}"
KINDS = {"theorem": "Theorem", "def": "Definition", "abbrev": "Abbreviation", "instance": "Instance"}


def tagged_json(version, path):
    data = subprocess.check_output(["git", "show", f"{version}:{path}"], cwd=ROOT)
    return json.loads(data)


def unique_keys(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"Duplicate entry: {key}")
        result[key] = value
    return result


@dataclass
class Header:
    inputs: list[str] = field(default_factory=list)
    references: list[str] = field(default_factory=list)
    source: str = ""


class DocHeaders(HTMLParser):
    """Read only declaration binders, referenced names and immutable source URLs."""
    def __init__(self, html):
        super().__init__(convert_charrefs=True)
        self.headers = {}
        self.stack = []
        self.record = None
        self.binder = None
        self.in_header = False
        self.feed(html)
        self.close()

    def handle_starttag(self, tag, attrs):
        if tag in {"meta", "link", "input", "img", "br", "hr", "wbr", "source", "area", "base", "embed", "param", "track", "col"}:
            return
        attrs = dict(attrs)
        classes = attrs.get("class", "").split()
        marker = ""
        if tag == "div" and "decl" in classes:
            name = attrs["id"]
            if name in self.headers:
                raise ValueError(f"Duplicate doc-gen header: {name}")
            self.record = self.headers[name] = Header()
            marker = "record"
        elif self.record is not None:
            if "decl_header" in classes:
                self.in_header = True
                marker = "header"
            elif self.in_header and "decl_args" in classes:
                self.binder = []
                marker = "binder"
            elif tag == "a":
                href = attrs.get("href", "")
                if href.startswith(GITHUB + "/blob/") and not self.record.source:
                    self.record.source = href
                if self.in_header and "#" in href:
                    self.record.references.append(unquote(urlsplit(href).fragment))
        self.stack.append((tag, marker))

    def handle_endtag(self, tag):
        if not self.stack or self.stack[-1][0] != tag:
            return
        _, marker = self.stack.pop()
        if marker == "binder":
            binder = " ".join("".join(self.binder).split())
            if binder and binder != ":":
                self.record.inputs.append(binder)
            self.binder = None
        elif marker == "header":
            self.in_header = False
        elif marker == "record":
            self.record = None

    def handle_data(self, data):
        if self.binder is not None:
            self.binder.append(data)


@dataclass
class Entry:
    name: str
    kind: str
    statement: str
    inputs: list[str]
    references: list[str]
    api: str
    source: str


@dataclass
class Module:
    name: str
    summary: str
    imports: list[str]
    api: str
    entries: list[Entry]


def load_edition(version, content, api_root=None):
    manifest = tagged_json(version, "docs/current-public-api.json")
    graph = tagged_json(version, "home_page/blueprint/module_graph.json")
    contract = tagged_json(version, f"docs/compatibility/{version}-candidate-contract.json")
    api = contract["release_identity"]["api_url"]
    commit = subprocess.check_output(["git", "rev-parse", version + "^{commit}"], cwd=ROOT, text=True).strip()
    names = set(manifest["supported_modules"])
    scope = {row["name"]: row for row in manifest["declarations"]}
    graph = {mod["name"]: mod for mod in graph["modules"]}
    if len(names) != manifest["supported_module_count"] or len(scope) != manifest["declaration_count"]:
        raise ValueError("The tag inventory contains duplicate modules or declarations")
    by_module = {m: {} for m in names}
    for name, row in scope.items():
        by_module[row["module"]][name] = row
    statement_dir = content / "statements"
    if {p.stem for p in statement_dir.glob("*.json")} != {m for m in names if by_module[m]}:
        raise ValueError("Expected one prose file per declaring module in the release")

    def read_module(name):
        row = graph[name]
        route = name.replace(".", "/") + ".html"
        module_api = api + route
        entries = []
        if by_module[name]:
            prose = json.loads((statement_dir / (name + ".json")).read_text(encoding="utf-8"),
                               object_pairs_hook=unique_keys)
            if set(prose) != set(by_module[name]):
                raise ValueError(f"Prose coverage differs from the release for {name}")
            if api_root:
                html = (api_root / route).read_text(encoding="utf-8")
            else:
                with urlopen(module_api, timeout=40) as response:
                    html = response.read().decode("utf-8")
            headers = DocHeaders(html).headers
            for decl, header in headers.items():
                if decl not in prose:
                    continue
                expected_source = f"{GITHUB}/blob/{commit}/{row['path']}#L"
                if not header.source.startswith(expected_source) or not re.fullmatch(r"L\d+(?:-L\d+)?", urlsplit(header.source).fragment):
                    raise ValueError(f"Wrong source revision or lines for {decl}: {header.source}")
                statement = prose[decl]
                if not isinstance(statement, str) or not statement.strip():
                    raise ValueError(f"Empty mathematical statement: {decl}")
                refs = list(dict.fromkeys(ref for ref in header.references if ref in scope and ref != decl))
                entries.append(Entry(decl, KINDS[scope[decl]["kind"]], statement.strip(), header.inputs,
                                     refs, module_api + "#" + decl, header.source))
            if {e.name for e in entries} != set(prose):
                raise ValueError(f"Missing released doc-gen headers in {name}")
        return Module(name, row["summary"], [m for m in row["local_imports"] if m in names], module_api, entries)

    with ThreadPoolExecutor(max_workers=6) as pool:
        return list(pool.map(read_module, sorted(names)))
