"""Check curated discovery metadata and extract maintained website Lean examples."""

from __future__ import annotations

from html.parser import HTMLParser
from pathlib import Path
import xml.etree.ElementTree as ET


SITE_ROOT = Path(__file__).resolve().parents[1] / "home_page"
BASE_URL = "https://serhatemrecoban.github.io/LeanInfoTheory/"
PAGES = (
    "index.html", "docs/index.html", "theorems.html", "module-guide.html",
    "docs/getting-started.html", "docs/information-measures.html",
    "docs/markov-data-processing.html", "docs/research-projects.html",
    "docs/mathlib.html",
)
EXAMPLE_IDS = (
    "guide-entropy-pure", "guide-mi-nonneg",
    "guide-data-processing", "guide-markov-zero-cmi",
)


class DiscoveryPage(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.in_head = False
        self.in_title = False
        self.title = ""
        self.meta: dict[str, list[str]] = {}
        self.canonicals: list[str] = []
        self.examples: list[tuple[str, str]] = []
        self.example_id: str | None = None
        self.code = ""

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == "head":
            self.in_head = True
        if self.in_head:
            if tag == "title":
                self.in_title = True
            if tag == "meta":
                key = attrs.get("name") or attrs.get("property")
                self.meta.setdefault(key, []).append(attrs.get("content", ""))
            if tag == "link" and "canonical" in (attrs.get("rel") or "").split():
                self.canonicals.append(attrs.get("href", ""))
        if tag == "code" and "language-lean" in (attrs.get("class") or "").split():
            self.example_id = attrs.get("data-lean-example", "")
            self.code = ""

    def handle_endtag(self, tag):
        if tag == "head":
            self.in_head = False
        if tag == "title":
            self.in_title = False
        if tag == "code" and self.example_id is not None:
            self.examples.append((self.example_id, self.code.strip() + "\n"))
            self.example_id = None

    def handle_data(self, data):
        if self.in_title:
            self.title += data
        if self.example_id is not None:
            self.code += data


def read_page(path: Path) -> DiscoveryPage:
    page = DiscoveryPage()
    page.feed(path.read_text(encoding="utf-8"))
    page.close()
    return page


def canonical_url(relative: str) -> str:
    return BASE_URL + (relative[:-10] if relative.endswith("index.html") else relative)


def read_guide_examples(site_root: Path = SITE_ROOT) -> list[tuple[str, str]]:
    examples = [example for path in PAGES for example in read_page(site_root / path).examples]
    if [name for name, _ in examples] != list(EXAMPLE_IDS):
        raise ValueError("website Lean examples must have the maintained unique IDs")
    if any(not source.startswith("import ") for _, source in examples):
        raise ValueError("each website Lean example must be independently importable")
    return examples


def check_discovery(site_root: Path = SITE_ROOT) -> None:
    for relative in PAGES:
        page = read_page(site_root / relative)
        url = canonical_url(relative)
        if page.canonicals != [url]:
            raise ValueError(f"{relative}: expected one exact canonical URL")
        description = page.meta.get("description", [])
        if len(description) != 1 or not description[0].strip():
            raise ValueError(f"{relative}: expected one nonempty description")
        expected = {
            "og:url": url, "og:type": "website", "og:site_name": "LeanInfoTheory",
            "og:title": page.title, "og:description": description[0],
            "twitter:card": "summary", "twitter:title": page.title,
            "twitter:description": description[0],
        }
        if not page.title.strip() or any(page.meta.get(k) != [v] for k, v in expected.items()):
            raise ValueError(f"{relative}: missing or inconsistent discovery metadata")
        for key in ("robots", "googlebot", "bingbot"):
            if any(token in value.lower() for value in page.meta.get(key, [])
                   for token in ("noindex", "nosnippet", "none")):
                raise ValueError(f"{relative}: restrictive indexing metadata")
    ns = "{http://www.sitemaps.org/schemas/sitemap/0.9}"
    tree = ET.parse(site_root / "sitemap.xml")
    locations = [node.text for node in tree.findall(f"{ns}url/{ns}loc")]
    expected_urls = sorted(canonical_url(path) for path in PAGES)
    if tree.getroot().tag != ns + "urlset" or sorted(locations) != expected_urls:
        raise ValueError("sitemap must list each curated canonical URL exactly once")
    read_guide_examples(site_root)


if __name__ == "__main__":
    check_discovery()
    print(f"discovery metadata and sitemap passed for {len(PAGES)} pages; four Lean examples found")
