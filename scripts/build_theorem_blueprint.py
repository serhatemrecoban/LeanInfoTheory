"""Build the current published release's theorem blueprint as HTML and PDF."""
from __future__ import annotations

import argparse
from html import escape
import json
import os
from pathlib import Path
import re
import shutil
from string import Template
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
BLUEPRINT = ROOT / "blueprint"
REPO = "serhatemrecoban/LeanInfoTheory"
PAGES = "https://serhatemrecoban.github.io"


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


def build(output: Path, browser: str) -> None:
    version = latest_release()
    fragments = sorted((BLUEPRINT / "versions" / version).glob("*.html"))
    if not fragments:
        raise ValueError(f"No theorem blueprint source for the latest release {version}")
    articles = "\n".join(p.read_text(encoding="utf-8") for p in fragments)
    template = Template((BLUEPRINT / "page-template.html").read_text(encoding="utf-8"))
    shared = (ROOT / "home_page/styles.css").read_text(encoding="utf-8")
    styles = shared + "\n" + (BLUEPRINT / "theorem-blueprint.css").read_text(encoding="utf-8")

    def render(prefix: str) -> str:
        return template.substitute(
            version=escape(version), prefix=prefix, articles=articles,
            permalink=f"{PAGES}/LeanInfoTheory-Blueprint/{version}/",
            api=f"{PAGES}/LeanInfoTheory/docs/{version}/",
            release_url=f"https://github.com/{REPO}/releases/tag/{version}",
        )

    with tempfile.TemporaryDirectory(prefix="leaninfotheory-blueprint-") as scratch:
        stage = Path(scratch)
        edition = stage / version
        edition.mkdir()
        index = edition / "index.html"
        index.write_text(render(""), encoding="utf-8", newline="\n")
        (edition / "blueprint.css").write_text(styles, encoding="utf-8", newline="\n")
        pdf = edition / "blueprint.pdf"
        subprocess.run([
            browser, "--headless", "--disable-extensions", "--disable-background-networking",
            "--no-first-run", f"--user-data-dir={stage / 'browser-profile'}",
            "--no-pdf-header-footer", f"--print-to-pdf={pdf}", index.as_uri(),
        ], check=True, timeout=120)
        if not pdf.is_file() or not pdf.read_bytes().startswith(b"%PDF-"):
            raise ValueError("Browser failed to print the versioned blueprint")
        latest = stage / "index.html"
        latest.write_text(render(version + "/"), encoding="utf-8", newline="\n")
        destination = output / version
        destination.mkdir(parents=True, exist_ok=True)
        for file in edition.iterdir():
            shutil.copyfile(file, destination / file.name)
        shutil.copyfile(latest, output / latest.name)
    print(f"Built the {version} edition and the latest entry in {output}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True, help="Companion site's publishing directory")
    parser.add_argument("--browser", help="Chrome, Chromium or Edge executable for PDF printing")
    args = parser.parse_args()
    build(args.output.resolve(), args.browser or find_browser())
