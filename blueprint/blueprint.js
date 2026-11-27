(() => {
  "use strict";
  const base = document.body.dataset.base;
  const searchPage = document.body.dataset.page === "search";
  const input = document.querySelector("#query");
  const form = input.form;
  const suggestions = document.querySelector("#suggestions");
  const params = new URLSearchParams(location.search);
  const outline = document.querySelector(".outline details");
  const drawer = document.querySelector(".module-drawer");
  const narrow = matchMedia("(max-width: 44rem)");
  const compact = matchMedia("(max-width: 64rem)");
  new ResizeObserver(([entry]) => {
    document.documentElement.style.setProperty("--mast-height", entry.target.offsetHeight + "px");
  }).observe(document.querySelector(".masthead"));
  function adapt() {
    drawer.open = !narrow.matches;
    if (outline) outline.open = !compact.matches;
  }
  adapt();
  narrow.addEventListener("change", adapt);
  compact.addEventListener("change", adapt);
  if (!searchPage && !location.pathname.includes("/modules/") && !location.pathname.endsWith("finite-testing.html")
      && ["#tests", "#optimality", "#exact-size", "#fixed-threshold-comparison", "#threshold-calibration", "#most-powerful-test"].includes(location.hash)) {
    location.replace(base + "finite-testing.html" + location.hash);
    return;
  }
  let loading;
  let records;
  const synonyms = new Map(Object.entries({
    "tv": "total variation", "dpi": "data processing", "cmi": "conditional mutual information",
    "kl": "relative entropy", "aep": "asymptotic equipartition", "pmf": "probability mass function"
  }));
  const normalize = value => value.normalize("NFKD").replace(/\p{M}/gu, "").toLowerCase()
      .replace(/[^\p{L}\p{N}]+/gu, " ").trim();
  async function load() {
    if (!loading) {
      loading = new Promise((resolve, reject) => {
        const script = document.createElement("script");
        script.src = base + "search-index.js";
        script.onload = resolve;
        script.onerror = () => reject(new Error("Search index unavailable"));
        document.head.append(script);
      }).then(() => {
        records = window.blueprintSearchIndex.map(row => {
          const [name, topic, kind, url, meaning] = row;
          const label = normalize(name.replace(/([a-z])([A-Z])/g, "$1 $2"));
          const short = normalize(name.split(".").pop().replace(/([a-z])([A-Z])/g, "$1 $2"));
          return {name, topic, kind, url, meaning, label, short, text: normalize(name + " " + label + " " + topic + " " + meaning)};
        });
      }).catch(error => { loading = null; throw error; });
    }
    await loading;
  }
  function ranked(value) {
    const query = normalize(value);
    const words = query.split(" ");
    const alternate = synonyms.get(query);
    return records.map(r => {
      const exact = r.name.toLowerCase() === value.trim().toLowerCase();
      const tokens = words.every(w => r.text.includes(w));
      if (!tokens && !(alternate && r.text.includes(alternate))) return null;
      const score = exact ? 100 : r.short === query ? 80 : r.label === query ? 70
        : r.short.startsWith(query) ? 55 : r.label.includes(query) ? 45 : r.text.includes(query) ? 30 : 10;
      return [score + (r.kind === "Module" ? 3 : 0), r];
    }).filter(Boolean).sort((a,b) => b[0]-a[0] || a[1].name.localeCompare(b[1].name)).map(pair => pair[1]);
  }
  function element(tag, text) {
    const el = document.createElement(tag);
    el.textContent = text;
    return el;
  }
  function anchor(text, url) {
    const a = element("a", text);
    a.href = base + url;
    return a;
  }
  const status = document.querySelector("#search-status");
  const results = document.querySelector("#search-results");
  const more = document.querySelector("#show-more");
  let limit = 25;
  let generation = 0;
  function dismiss() { suggestions.hidden = true; }
  function showResults(matches, query) {
    status.textContent = matches.length ? matches.length + (matches.length === 1 ? " result" : " results") + " for “" + query + "”." : "No results for “" + query + "”. Try another spelling or a shorter mathematical term.";
    results.replaceChildren();
    for (const r of matches.slice(0,limit)) {
      const li = document.createElement("li");
      li.append(anchor(r.name, r.url), element("small", r.kind + " · " + r.topic));
      if (r.meaning) li.append(element("p", r.meaning));
      results.append(li);
    }
    more.hidden = matches.length <= limit;
  }
  async function update() {
    const run = ++generation;
    const q = input.value.trim();
    if (!q) {
      dismiss();
      if (searchPage) {
        results.replaceChildren();
        more.hidden = true;
        status.textContent = "Search by a Lean name, a module, or a mathematical term.";
      }
      return;
    }
    try { await load(); } catch {
      if (searchPage) status.textContent = "Search could not load. Browse the modules or try again.";
      return;
    }
    if (run !== generation) return;
    const found = ranked(q);
    if (searchPage) { showResults(found,q); return; }
    if (!form.contains(document.activeElement)) return;
    suggestions.replaceChildren();
    for (const r of found.slice(0,6)) suggestions.append(anchor(r.name, r.url));
    if (!found.length) suggestions.append(element("p","No matching entries."));
    suggestions.append(anchor("Search all entries for “" + q + "”", "search.html?q=" + encodeURIComponent(q)));
    suggestions.hidden = false;
  }
  if (searchPage) {
    input.value = params.get("q") || "";
    more.addEventListener("click", () => { limit += 25; update(); });
    update();
  }
  input.addEventListener("input", () => {
    limit = 25;
    if (searchPage) {
      const url = new URL(location.href);
      if (input.value) url.searchParams.set("q", input.value); else url.searchParams.delete("q");
      history.replaceState(null,"",url);
    }
    update();
  });
  input.addEventListener("focus", () => { if (input.value) update(); });
  form.addEventListener("focusout", event => { if (!form.contains(event.relatedTarget)) dismiss(); });
  form.addEventListener("keydown", event => {
    if (event.key === "Escape") { input.focus(); dismiss(); }
    if (!suggestions.hidden && ["ArrowUp","ArrowDown"].includes(event.key)) {
      const links = [...suggestions.querySelectorAll("a")];
      const current = links.indexOf(document.activeElement);
      const next = current + (event.key === "ArrowDown" ? 1 : -1);
      event.preventDefault();
      if (next < 0) input.focus();
      else links[Math.min(next,links.length-1)].focus();
    }
  });
})();
