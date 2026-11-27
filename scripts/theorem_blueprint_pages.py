"""HTML and print views of one version of the theorem blueprint."""
from html import escape
import json
from string import Template

HOST = "https://serhatemrecoban.github.io/LeanInfoTheory-Blueprint/"
HOME = "https://serhatemrecoban.github.io/LeanInfoTheory/"
GROUPS = ("Probability", "Shannon theory", "Semantic bridge", "Library imports")
NEYM = "PMF.BinaryTest.exists_likelihoodThresholdTest"


def group(name):
    if name in {"LeanInfoTheory", "LeanInfoTheory.InformationMeasures", "LeanInfoTheory.Shannon", "LeanInfoTheory.Shannon.SemanticBridge"}:
        return "Library imports"
    if name.startswith("LeanInfoTheory.Shannon.SemanticBridge."):
        return "Semantic bridge"
    if name.startswith("LeanInfoTheory.Shannon."):
        return "Shannon theory"
    if name.startswith("LeanInfoTheory.Probability."):
        return "Probability"
    return "Library imports"


def route(name):
    return "modules/" + name + ".html"


def link(href, label, attrs=""):
    return f'<a href="{escape(href, quote=True)}"{attrs}>{escape(label)}</a>'


class Edition:
    def __init__(self, version, modules, titles, article, template):
        self.version = version
        self.modules = modules
        self.by_name = {m.name: m for m in modules}
        if set(titles) != set(self.by_name):
            raise ValueError("Module titles differ from the supported inventory")
        self.titles = titles
        self.article = article
        self.template = Template(template)
        self.owner = {entry.name: m.name for m in modules for entry in m.entries}
        self.groups = {g: sorted((m for m in modules if group(m.name) == g),
                                 key=lambda m: titles[m.name].casefold()) for g in GROUPS}

    def tree(self, base, current):
        groups = []
        for label, modules in self.groups.items():
            links = []
            for m in modules:
                active = ' aria-current="page"' if current == m.name else ""
                links.append("<li>" + link(base + route(m.name), self.titles[m.name], active) + "</li>")
            expanded = " open" if (current and group(current) == label) or (not current and label == "Probability") else ""
            groups.append(f'<details class="tree-group"{expanded}><summary>{label}</summary><ul>{"".join(links)}</ul></details>')
        return ('<nav class="module-nav" aria-label="Module tree"><details class="module-drawer" open>'
                '<summary>Browse modules</summary><div class="tree-body">' + link(base + "index.html", "All modules")
                + "".join(groups) + "</div></details></nav>")

    def frame(self, title, path, base, main, toc="", current="", search_page=False):
        return self.template.substitute(
            title=escape(title), version=self.version, canonical=HOST + self.version + "/" + path,
            base=base, home=HOME, edition=HOST + self.version + "/",
            api=self.by_name["LeanInfoTheory"].api.removesuffix("LeanInfoTheory.html"),
            tree=self.tree(base, current), main=main, toc=toc, state="search" if search_page else "reader",
        )

    def entry(self, e, base, printing=False):
        visible = [arg for arg in e.inputs if arg.startswith("(")]
        context = [arg for arg in e.inputs if not arg.startswith("(")]
        if not visible:
            visible, context = context, []
        code = lambda values: escape(" ".join(values))
        inputs = f'<code class="inputs">{code(visible)}</code>' if visible else ""
        extra = ""
        if context:
            extra = f'<details class="context"><summary>Implicit inputs</summary><code class="inputs">{code(context)}</code></details>'
            if printing:
                extra = f'<code class="inputs">{code(context)}</code>'
        refs = ""
        if e.references and not printing:
            links = [link(base + route(self.owner[n]) + "#" + n, n) for n in e.references]
            refs = f'<details class="uses"><summary>Definitions and results in this statement</summary>{" ".join(links)}</details>'
        example = ""
        if e.name == NEYM:
            url = HOST + self.version + "/finite-testing.html" if printing else base + "finite-testing.html"
            example = link(url, "Read the worked proof")
        return (f'<article class="entry" id="{escape(e.name)}" data-kind="{e.kind}">'
                f'<div class="entry-meta"><span>{e.kind}</span></div><h3><code>{escape(e.name)}</code></h3>'
                f'<p class="meaning">{escape(e.statement)}</p>{inputs}{extra}{refs}'
                f'<div class="entry-links">{link(e.api, "Lean API")} {link(e.source, "Source")} {example}</div></article>')

    def intro(self, m, base, printing=False):
        title = self.titles[m.name]
        summary = m.summary if m.summary != "Local LeanInfoTheory module." else ""
        text = f'<p class="lead">{escape(summary)}</p>' if summary else ""
        if not m.entries:
            text += '<p>This module collects results through its imports. Follow a module below to read its definitions and theorems.</p>'
        return (f'<p class="module-path">{escape(m.name)}</p><h1>{escape(title)}</h1>{text}'
                + ('' if printing else f'<p class="module-links">{link(m.api, "Open module in the Lean API")}</p>'))

    def imports(self, m, base, printing=False):
        if not m.imports:
            return ""
        items = [link(("#module-" + n) if printing else (base + route(n)), self.titles[n]) for n in m.imports]
        return '<details class="imports"' + (' open' if not m.entries else '') + '><summary>Imported library modules</summary><div>' + " · ".join(items) + '</div></details>'

    def module_page(self, m):
        base = "../"
        main = self.intro(m, base) + self.imports(m, base)
        if m.entries:
            main += f'<h2 class="entries-heading">Definitions and results <small>{len(m.entries)}</small></h2>'
            main += "".join(self.entry(e, base) for e in m.entries)
        items = "".join("<li>" + link("#" + e.name, e.name.split(".")[-1]) + "</li>" for e in m.entries)
        toc = ('<nav class="outline" aria-label="On this page"><details open><summary>On this page</summary>'
               f'<ul>{items}</ul></details></nav>') if items else ""
        return self.frame(self.titles[m.name], route(m.name), base, main, toc, m.name)

    def directory(self, base):
        parts = [f'<header class="intro"><p class="module-path">LeanInfoTheory {self.version}</p>'
                 f'<h1>Theorem blueprint</h1><p class="lead">Browse the mathematical statements of all {len(self.owner)} '
                 f'public declarations in {len(self.modules)} modules. Each entry gives the Lean name, its inputs, '
                 'and a link to the formal statement and source.</p></header>']
        for label, modules in self.groups.items():
            items = []
            for m in modules:
                count = str(len(m.entries)) if m.entries else "imports"
                items.append(f'<li>{link(base + route(m.name), self.titles[m.name])}<small>{count}</small></li>')
            parts.append(f'<section class="directory-section"><h2>{escape(label)}</h2><ul class="directory">{"".join(items)}</ul></section>')
        parts.append('<p class="worked-link">' + link(base + "finite-testing.html", "Worked proof of the finite Neyman–Pearson theorem") + "</p>")
        return self.frame("Mathematical reference", "", base, "".join(parts))

    def search_page(self):
        main = ('<h1>Search the blueprint</h1><p id="search-status" role="status">Search by a Lean name, a module, or a mathematical term.</p>'
                '<noscript><p>Enable JavaScript to search across modules, or use the module tree.</p></noscript>'
                '<ol id="search-results" class="results"></ol><button type="button" id="show-more" hidden>Show more results</button>')
        return self.frame("Search", "search.html", "", main, search_page=True)

    def search_data(self):
        data = []
        for m in self.modules:
            title = self.titles[m.name]
            data.append([title, m.name, "Module", route(m.name), m.summary if m.summary != "Local LeanInfoTheory module." else ""])
            for e in m.entries:
                data.append([e.name, title, e.kind, route(m.name) + "#" + e.name, e.statement])
        return "window.blueprintSearchIndex=" + json.dumps(data, ensure_ascii=False, separators=(",", ":")) + ";\n"

    def print_book(self):
        parts = [f'<header><h1>LeanInfoTheory theorem blueprint</h1><p>{self.version} · {len(self.owner)} public declarations · {len(self.modules)} modules</p></header><h2>Contents</h2>']
        for label, modules in self.groups.items():
            parts.append("<h3>" + label + "</h3><ul class='print-index'>" + "".join(
                "<li>" + link("#module-" + m.name, self.titles[m.name]) + "</li>" for m in modules) + "</ul>")
        parts.append("<p>" + link("#worked-example", "Worked proof of the finite Neyman–Pearson theorem") + "</p>")
        for modules in self.groups.values():
            for m in modules:
                parts.append(f'<section class="print-module" id="module-{m.name}">' + self.intro(m, "", True))
                if not m.entries:
                    parts.append(self.imports(m, "", True))
                parts.extend(self.entry(e, "", printing=True) for e in m.entries)
                parts.append("</section>")
        parts.append('<section class="print-module" id="worked-example">' + self.article + "</section>")
        return (f'<!doctype html><html lang="en"><head><meta charset="utf-8"><title>LeanInfoTheory {self.version} theorem blueprint</title>'
                '<link rel="stylesheet" href="blueprint.css"></head><body class="book"><main>' + "".join(parts) + "</main></body></html>")
