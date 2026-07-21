"use strict";

const state = {
  manifest: null,
  terms: [],
  filtered: [],
  selectedId: null,
  cache: new Map(),
};

const elements = {
  search: document.querySelector("#search"),
  clearSearch: document.querySelector("#clear-search"),
  domain: document.querySelector("#domain-filter"),
  status: document.querySelector("#status-filter"),
  count: document.querySelector("#result-count"),
  list: document.querySelector("#term-list"),
  detail: document.querySelector("#term-detail"),
  audience: document.querySelector("#audience-label"),
};

function normalize(value) {
  return value.normalize("NFKC").toLocaleLowerCase().trim().replace(/\s+/g, " ");
}

function titleCase(value) {
  return value
    .split("-")
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(" ");
}

function element(tag, className, text) {
  const node = document.createElement(tag);
  if (className) node.className = className;
  if (text !== undefined) node.textContent = text;
  return node;
}

function scoreTerm(record, query) {
  if (!query) return 0;
  const id = normalize(record.id);
  const names = [record.term, ...record.aliases].map(normalize);
  if (query === id || names.includes(query)) return 0;
  if (id.startsWith(query) || names.some((name) => name.startsWith(query))) return 1;
  if (id.includes(query) || names.some((name) => name.includes(query))) return 2;
  if (normalize(record.summary).includes(query)) return 3;
  return null;
}

function filterTerms() {
  const query = normalize(elements.search.value);
  const domain = elements.domain.value;
  const status = elements.status.value;
  state.filtered = state.terms
    .map((record) => ({ record, score: scoreTerm(record, query) }))
    .filter(({ record, score }) => {
      const domainMatches = domain === "all" || record.domains.includes(domain);
      const statusMatches = status === "all" || record.status === status;
      return score !== null && domainMatches && statusMatches;
    })
    .sort((left, right) => {
      if (left.score !== right.score) return left.score - right.score;
      return left.record.term.localeCompare(right.record.term);
    })
    .map(({ record }) => record);
  renderList();
}

function renderList() {
  elements.list.replaceChildren();
  elements.count.textContent = `${state.filtered.length} ${state.filtered.length === 1 ? "term" : "terms"}`;
  if (state.filtered.length === 0) {
    elements.list.append(element("p", "empty-state", "No matching terms."));
    return;
  }

  const fragment = document.createDocumentFragment();
  for (const record of state.filtered.slice(0, 250)) {
    const button = element("button", "term-row");
    button.type = "button";
    button.dataset.termId = record.id;
    button.setAttribute("aria-current", String(record.id === state.selectedId));
    button.append(
      element("span", "term-row-name", record.term),
      element("span", "term-row-summary", record.summary),
    );
    button.addEventListener("click", () => openTerm(record.id, true));
    fragment.append(button);
  }
  elements.list.append(fragment);
}

function addMetadata(record, container) {
  const metadata = element("div", "metadata");
  for (const domain of record.domains) {
    const badge = element("span", "badge badge-domain", titleCase(domain));
    badge.dataset.domain = domain;
    metadata.append(badge);
  }
  metadata.append(element("span", "badge badge-status", titleCase(record.status)));
  container.append(metadata);
}

function addTextSection(container, title, text) {
  if (!text) return;
  const section = element("section", "content-section");
  section.append(element("h2", "", title), element("p", "", text));
  container.append(section);
}

function addTermLinks(container, title, ids) {
  if (!ids || ids.length === 0) return;
  const byId = new Map(state.terms.map((record) => [record.id, record]));
  const section = element("section", "content-section");
  const links = element("div", "link-list");
  section.append(element("h2", "", title));
  for (const id of ids) {
    const target = byId.get(id);
    if (target) {
      const link = element("a", "term-link", target.term);
      link.href = `#${encodeURIComponent(id)}`;
      links.append(link);
    } else {
      // Authors may cite a concept before its record is written; show the
      // planned concept instead of hiding the dead-end link.
      const planned = element("span", "term-link term-link-planned", titleCase(id));
      planned.title = "This entry has not been written yet.";
      links.append(planned);
    }
  }
  if (links.childElementCount > 0) {
    section.append(links);
    container.append(section);
  }
}

function repositoryHref(ref) {
  if (ref.startsWith("http://") || ref.startsWith("https://")) return ref;
  return `../../../${ref}`;
}

function addReferences(container, record) {
  const refs = [
    ...(record.doc_refs || []).map((value) => ({ type: "link", value })),
    ...(record.source_refs || []).map((value) => ({
      type: value.startsWith("http://") || value.startsWith("https://") ? "link" : "code",
      value,
    })),
    ...(record.lean_refs || []).map((value) => ({ type: "code", value })),
  ];
  if (refs.length === 0) return;

  const section = element("section", "content-section");
  const list = element("ul", "reference-list");
  section.append(element("h2", "", "References"));
  for (const ref of refs) {
    const item = document.createElement("li");
    if (ref.type === "link") {
      const link = element("a", "", ref.value);
      link.href = repositoryHref(ref.value);
      if (ref.value.startsWith("http")) {
        link.target = "_blank";
        link.rel = "noreferrer";
      }
      item.append(link);
    } else {
      item.append(element("code", "", ref.value));
    }
    list.append(item);
  }
  section.append(list);
  container.append(section);
}

function renderTerm(record) {
  state.selectedId = record.id;
  elements.detail.replaceChildren();
  addMetadata(record, elements.detail);
  elements.detail.append(element("h1", "term-heading", record.term));
  elements.detail.append(element("p", "term-summary", record.summary));

  if (record.aliases && record.aliases.length > 0) {
    elements.detail.append(
      element("p", "alias-line", `Also called: ${record.aliases.join(", ")}`),
    );
  }
  if (record.notation) {
    const notation = element("p", "notation-line", "Notation: ");
    notation.append(element("code", "", record.notation));
    elements.detail.append(notation);
  }

  addTextSection(elements.detail, "Explanation", record.explanation);
  addTextSection(elements.detail, "Why it matters", record.why);
  addTextSection(elements.detail, "Example", record.example);
  addTextSection(elements.detail, "Convention note", record.conventions);
  addTermLinks(elements.detail, "Builds on", record.prerequisites);
  addTermLinks(elements.detail, "Related terms", record.related);
  addTermLinks(elements.detail, "Compare with", record.contrasts);

  const backlinks = record.backlinks || {};
  addTermLinks(elements.detail, "Needed by", backlinks.prerequisite_of);
  addTermLinks(elements.detail, "Linked from", backlinks.related_from);
  addTermLinks(elements.detail, "Contrasted by", backlinks.contrasted_by);
  addReferences(elements.detail, record);
  document.title = `${record.term} | ${state.manifest.title}`;
  renderList();
}

async function openTerm(id, updateHash) {
  if (!state.terms.some((record) => record.id === id)) return;
  if (updateHash && window.location.hash !== `#${id}`) {
    window.location.hash = id;
    return;
  }
  try {
    let record = state.cache.get(id);
    if (!record) {
      const response = await fetch(`terms/${encodeURIComponent(id)}.json`);
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      record = await response.json();
      state.cache.set(id, record);
    }
    renderTerm(record);
    if (window.matchMedia("(max-width: 780px)").matches && updateHash) {
      elements.detail.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  } catch (error) {
    elements.detail.replaceChildren(
      element("p", "error-state", `Could not load ${id}.`),
    );
  }
}

function populateFilters() {
  for (const domain of state.manifest.domains) {
    const option = document.createElement("option");
    option.value = domain;
    option.textContent = titleCase(domain);
    elements.domain.append(option);
  }
}

async function initialize() {
  try {
    const [manifestResponse, indexResponse] = await Promise.all([
      fetch("manifest.json"),
      fetch("search-index.json"),
    ]);
    if (!manifestResponse.ok || !indexResponse.ok) throw new Error("data unavailable");
    state.manifest = await manifestResponse.json();
    state.terms = await indexResponse.json();
    elements.audience.textContent = state.manifest.audience
      .split("-")
      .map(titleCase)
      .join(" ");
    populateFilters();
    filterTerms();
    const requested = decodeURIComponent(window.location.hash.slice(1));
    const initialId = state.terms.some((record) => record.id === requested)
      ? requested
      : state.terms[0]?.id;
    if (initialId) await openTerm(initialId, false);
  } catch (error) {
    elements.detail.replaceChildren(
      element("p", "error-state", "Glossary data could not be loaded."),
    );
  }
}

elements.search.addEventListener("input", filterTerms);
elements.domain.addEventListener("change", filterTerms);
elements.status.addEventListener("change", filterTerms);
elements.clearSearch.addEventListener("click", () => {
  elements.search.value = "";
  filterTerms();
  elements.search.focus();
});
elements.search.addEventListener("keydown", (event) => {
  if (event.key === "Escape") {
    elements.search.value = "";
    filterTerms();
  }
  if (event.key === "ArrowDown") {
    event.preventDefault();
    elements.list.querySelector("button")?.focus();
  }
});
window.addEventListener("hashchange", () => {
  const id = decodeURIComponent(window.location.hash.slice(1));
  if (id) openTerm(id, false);
});

initialize();
