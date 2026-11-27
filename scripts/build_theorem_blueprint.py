"""Build the current published release's theorem blueprint as HTML and PDF."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

from theorem_blueprint_data import load_edition, unique_keys
from theorem_blueprint_pages import Edition

ROOT = Path(__file__).resolve().parents[1]
BLUEPRINT = ROOT / "blueprint"
REPO = "serhatemrecoban/LeanInfoTheory"


def latest_release() -> str:
    release = json.loads(subprocess.check_output(
        ["gh", "release", "view", "--repo", REPO, "--json", "tagName,isDraft,isPrerelease"],
        text=True,
    ))
    version = release["tagName"]
    if release["isDraft"] or release["isPrerelease"] or not re.fullmatch(r"v\d+\.\d+\.\d+", version):
        raise ValueError(f"Expected a published stable release, got {version!r}")
    return version


def find_browser() -> str:
    for command in ("google-chrome", "chromium", "chromium-browser", "msedge"):
        found = shutil.which(command)
        if found:
            return found
    for env_name in ("PROGRAMFILES", "PROGRAMFILES(X86)", "LOCALAPPDATA"):
        folder = os.environ.get(env_name)
        if folder:
            for exe in ("Google/Chrome/Application/chrome.exe", "Microsoft/Edge/Application/msedge.exe"):
                path = Path(folder) / exe
                if path.is_file():
                    return str(path)
    raise ValueError("Supply the path to Chrome, Chromium or Edge with --browser.")


def build(output: Path, browser: str, api_root: Path | None = None) -> None:
    version = latest_release()
    content = BLUEPRINT / "versions" / version
    modules = load_edition(version, content, api_root)
    titles = json.loads((content / "module-titles.json").read_text(encoding="utf-8"), object_pairs_hook=unique_keys)
    article = (content / "finite-testing.html").read_text(encoding="utf-8")
    template = (BLUEPRINT / "page-template.html").read_text(encoding="utf-8")
    pages = Edition(version, modules, titles, article, template)

    with tempfile.TemporaryDirectory(prefix="leaninfotheory-blueprint-") as scratch:
        stage = Path(scratch)
        edition = stage / version
        (edition / "modules").mkdir(parents=True)

        def write(path, text):
            path.write_text(text, encoding="utf-8", newline="\n")

        write(edition / "index.html", pages.directory(""))
        write(stage / "index.html", pages.directory(version + "/"))
        write(edition / "search.html", pages.search_page())
        write(edition / "search-index.js", pages.search_data())
        write(edition / "finite-testing.html", pages.frame("Finite hypothesis testing", "finite-testing.html", "", article))
        for module in modules:
            write(edition / "modules" / (module.name + ".html"), pages.module_page(module))
        shutil.copyfile(BLUEPRINT / "theorem-blueprint.css", edition / "blueprint.css")
        shutil.copyfile(BLUEPRINT / "blueprint.js", edition / "blueprint.js")
        book = edition / "print.html"
        write(book, pages.print_book())
        pdf = edition / "blueprint.pdf"
        subprocess.run([
            browser, "--headless", "--disable-extensions", "--disable-background-networking",
            "--no-first-run", f"--user-data-dir={stage / 'browser-profile'}",
            "--no-pdf-header-footer", f"--print-to-pdf={pdf}", book.as_uri(),
        ], check=True, timeout=240)
        if not pdf.is_file() or not pdf.read_bytes().startswith(b"%PDF-"):
            raise ValueError("Browser failed to print the complete blueprint")
        book.unlink()
        shutil.copytree(edition, output / version, dirs_exist_ok=True)
        shutil.copyfile(stage / "index.html", output / "index.html")
    print(f"Built {version}: {len(pages.owner)} mathematical entries in {len(modules)} modules, search and PDF.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True, help="Companion site's publishing directory")
    parser.add_argument("--browser", help="Chrome, Chromium or Edge executable for PDF printing")
    parser.add_argument("--api-root", type=Path, help="Local copy of the release-specific doc-gen site")
    args = parser.parse_args()
    build(args.output.resolve(), args.browser or find_browser(), args.api_root)
