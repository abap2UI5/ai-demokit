/*
 * The searchable catalogue — plain ES2020, no dependencies, no build step.
 *
 * Everything it knows comes from apps.json (scripts/generate-search-index.mjs),
 * which is regenerated on every Pages deploy. This file only filters and draws.
 *
 * Two decisions worth knowing before changing anything here:
 *
 *   The release facet is "runs on UI5 <x>", not "needs exactly <x>". A port's
 *   `minUi5` is the highest @since the linter found in the view it builds, so
 *   the useful question — "my system is 1.84, what will render on it?" — is
 *   `minUi5 <= chosen`, and the option labels carry the resulting count so the
 *   cost of an old system is visible before the click.
 *
 *   The playground button is live only for a port that build can actually
 *   run. It carries eight UI5 libraries and one pinned release; a port outside
 *   them would open a frame that renders nothing, so the button stays but goes
 *   disabled, with a title saying exactly what is missing.
 */

/* ------------------------------------------------------------------ state */

const $ = (id) => document.getElementById(id);

const els = {
  q: $('q'),
  release: $('release'),
  control: $('control'),
  library: $('library'),
  status: $('status'),
  results: $('results'),
  count: $('count'),
  total: $('total'),
  empty: $('empty'),
  more: $('more'),
  loadmore: $('loadmore'),
  reset: $('reset'),
  reset2: $('reset2'),
};

const PAGE = 60;           // cards drawn per batch
let DATA = null;           // the parsed apps.json
let MATCHES = [];          // the current result set
let drawn = 0;

/* --------------------------------------------------------------- helpers */

const esc = (s) => String(s == null ? '' : s)
  .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
  .replace(/"/g, '&quot;');

/** Numeric dotted-version compare — "1.9" < "1.71" < "1.120". */
function cmpVersion(a, b) {
  const pa = String(a).split('.').map(Number);
  const pb = String(b).split('.').map(Number);
  for (let i = 0; i < Math.max(pa.length, pb.length); i++) {
    const d = (pa[i] || 0) - (pb[i] || 0);
    if (d) return d;
  }
  return 0;
}

/** Wrap every query token found in `text`. Escapes first, so the marks are
 *  the only markup that reaches the card. */
function highlight(text, tokens) {
  const out = esc(text);
  if (!tokens.length) return out;
  const pattern = tokens
    .map((t) => t.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'))
    .sort((a, b) => b.length - a.length)
    .join('|');
  return out.replace(new RegExp(`(${pattern})`, 'gi'), '<mark>$1</mark>');
}

/** The one string a free-text query is matched against. */
const haystack = (app) => [
  app.class,
  app.title,
  app.summary,
  app.description,
  app.keywords,
  app.entity,
  app.sample,
  app.library,
  app.controlNames.join(' '),
  app.deviations.join(' '),
].join(' ').toLowerCase();

/* ----------------------------------------------------------------- facets */

/** Fill a <select> with `Any …` plus one option per value, each with a count. */
function fillSelect(select, anyLabel, entries) {
  const opts = [`<option value="">${esc(anyLabel)}</option>`];
  for (const [value, label] of entries) {
    opts.push(`<option value="${esc(value)}">${esc(label)}</option>`);
  }
  select.innerHTML = opts.join('');
}

function buildFacets() {
  /* Release: every distinct floor in the corpus, labelled with how many ports
   * a system on it can run — the cumulative count, not the count of ports
   * pinned exactly there. */
  const releases = DATA.releases.slice().sort(cmpVersion);
  fillSelect(els.release, `any release (${DATA.apps.length})`, releases.map((r) => {
    const n = DATA.apps.filter((a) => cmpVersion(a.minUi5, r) <= 0).length;
    return [r, `${r} and newer — ${n} port${n === 1 ? '' : 's'}`];
  }));

  /* Control: what the ports actually build, commonest first. This is the
   * facet `entity` cannot give — a port filed under sap.m.Page that happens
   * to contain the Table somebody is looking for. */
  const controlUse = new Map();
  for (const app of DATA.apps) {
    for (const name of app.controlNames) controlUse.set(name, (controlUse.get(name) || 0) + 1);
  }
  const controls = [...controlUse].sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]));
  fillSelect(els.control, `any control (${controls.length} in use)`,
    controls.map(([name, n]) => [name, `${name} — ${n}`]));

  const tally = (pick) => {
    const m = new Map();
    for (const app of DATA.apps) {
      const v = pick(app);
      if (v) m.set(v, (m.get(v) || 0) + 1);
    }
    return [...m].sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]));
  };

  fillSelect(els.library, 'any library',
    tally((a) => a.library).map(([v, n]) => [v, `${v} — ${n}`]));

  /* Status: the verification ladder, in ladder order rather than by count —
   * `checked` (a human saw it run in a real system) down to `generated`
   * (nobody has). The counts make the corpus' verification state visible
   * before any filter is chosen. */
  const statusCount = new Map(tally((a) => a.status));
  fillSelect(els.status, 'any status',
    ['checked', 'reviewed', 'generated', 'collection']
      .filter((s) => statusCount.has(s))
      .map((s) => [s, `${s} — ${STATUS[s] || ''} (${statusCount.get(s)})`]));
}

/** What the sidecar's `status` means to somebody who has not read AGENTS.md. */
const STATUS = {
  checked: 'checked in a running system',
  reviewed: 'reviewed against the original',
  generated: 'generated, not yet reviewed',
  collection: 'SAPUI5 collection',
};

/** What a deviation type means, for the badge title. */
const DEVIATION = {
  POST_171: 'uses something newer than UI5 1.71, kept for fidelity',
  DROPPED_171: 'something newer than UI5 1.71 was left out',
  IMPROVISED: 'the original construct has no abap2UI5 equivalent yet',
  LIVE_TEST: 'an interaction still to be confirmed in a running system',
  NOTE: 'a documented difference from the original',
};

/* ----------------------------------------------------------------- filter */

function currentFilters() {
  return {
    q: els.q.value.trim().toLowerCase(),
    release: els.release.value,
    control: els.control.value,
    library: els.library.value,
    status: els.status.value,
  };
}

function apply() {
  const f = currentFilters();
  const tokens = f.q ? f.q.split(/\s+/).filter(Boolean) : [];

  MATCHES = DATA.apps.filter((app) => {
    if (f.release && cmpVersion(app.minUi5, f.release) > 0) return false;
    if (f.control && !app.controlNames.includes(f.control)) return false;
    if (f.library && app.library !== f.library) return false;
    if (f.status && app.status !== f.status) return false;
    return tokens.every((t) => app.hay.includes(t));
  });

  /* A query that names a control or a class should put that port first;
   * otherwise the corpus order (class number) is the stable one. */
  if (tokens.length) {
    const score = (app) => {
      const name = `${app.entity} ${app.class} ${app.title}`.toLowerCase();
      return tokens.reduce((acc, t) => acc + (name.includes(t) ? 1 : 0), 0);
    };
    MATCHES = MATCHES
      .map((app) => ({ app, s: score(app) }))
      .sort((a, b) => b.s - a.s || a.app.class.localeCompare(b.app.class))
      .map((x) => x.app);
  }

  const n = MATCHES.length;
  els.count.textContent = n === DATA.apps.length
    ? `${n} ports`
    : `${n} of ${DATA.apps.length} port${n === 1 ? '' : 's'}`;

  const dirty = !!(f.q || f.release || f.control || f.library || f.status);
  els.reset.hidden = !dirty;
  els.empty.hidden = n > 0;

  els.results.innerHTML = '';
  drawn = 0;
  draw(tokens);
  writeUrl(f);
}

/* ----------------------------------------------------------------- render */

function card(app, tokens) {
  const src = `${DATA.source}${app.file}`;
  const raw = `${DATA.raw}${app.file}`;
  const play = `${DATA.playground}?src=${encodeURIComponent(raw)}`;

  const badges = [];
  badges.push(app.minUi5 === DATA.minUi5
    ? `<span class="badge ui5" title="Nothing in this view is newer than UI5 ${esc(DATA.minUi5)}">UI5 ${esc(app.minUi5)}+</span>`
    : `<span class="badge ui5 up" title="${esc(app.needs.map((x) => `${x.name} — since ${x.since}`).join('\n'))}">UI5 ${esc(app.minUi5)}+</span>`);
  if (app.status) {
    badges.push(`<span class="badge ${app.status === 'checked' ? 'checked' : 'plain'}" title="${esc(STATUS[app.status] || '')}">${esc(app.status)}</span>`);
  }
  for (const d of app.deviations) {
    if (d === 'NOTE') continue;                  // on 935 of them; separates nothing
    badges.push(`<span class="badge plain" title="${esc(DEVIATION[d] || '')}">${esc(d)}</span>`);
  }

  /* Why this port needs more than the floor — the argument behind the badge,
   * so a filtered-out port can be checked rather than only trusted. */
  const needs = app.needs.length ? `
      <details>
        <summary>needs ${app.needs.length} thing${app.needs.length === 1 ? '' : 's'} newer than UI5 ${esc(DATA.minUi5)}</summary>
        <ul>${app.needs.map((x) => `<li>${esc(x.name)} <span class="since">since ${esc(x.since)}</span></li>`).join('')}</ul>
      </details>` : '';

  const controls = app.controlNames.length ? `
      <details>
        <summary>builds ${app.controlNames.length} control type${app.controlNames.length === 1 ? '' : 's'}</summary>
        <ul>${app.controlNames.map((c) => `<li>${highlight(c, tokens)}</li>`).join('')}</ul>
      </details>` : '';

  /* A port the playground's UI5 build cannot serve keeps the button, disabled
   * and saying why: a link to a frame that renders nothing is worse than no
   * link, and dropping the button silently leaves a reader wondering whether
   * they misread the row. */
  const missing = app.libraries.filter((l) => !DATA.playgroundLibraries.includes(l) && !l.startsWith('z2ui5.'));
  const why = missing.length
    ? `The playground's UI5 build does not carry ${missing.join(', ')} — only ${DATA.playgroundLibraries.join(', ')}.`
    : `The playground's UI5 build is ${DATA.playgroundUi5}; this port needs ${app.minUi5}.`;
  const run = app.runnable
    ? `<a class="primary" href="${esc(play)}" target="_blank" rel="noopener">Run in the playground ↗</a>`
    : `<span class="disabled" title="${esc(why)}" aria-disabled="true">Run in the playground</span>`;

  /* The thumbnail — the render gate's photograph of the port's first screen,
   * written into thumbs/ by scripts/generate-screenshots.mjs on every deploy
   * (never committed, like apps.json). Best effort by design: an <img> whose
   * file the deploy could not photograph removes itself, so the card simply
   * has no picture — the same fallback the samples overview page proved. */
  const shot = `<img class="shot" loading="lazy" alt="" aria-hidden="true"
      src="thumbs/${esc(app.class)}.png" onerror="this.remove()">`;

  /* The .body wrapper exists for the float: the card itself is a flex
   * column (it pins .actions to the bottom), and a float is inert inside a
   * flex container — the image needs a block formatting context to wrap the
   * text around it (flow-root in the CSS). */
  return `
    <article class="card">
      <div class="body">
        ${shot}
        <h2>${highlight(app.title || app.class, tokens)}</h2>
        <p class="entity">${highlight(app.entity || app.class, tokens)}</p>
        ${app.summary ? `<p class="blurb">${highlight(app.summary, tokens)}</p>` : ''}
      </div>
      <div class="badges">${badges.join('')}</div>
      ${needs}${controls}
      <div class="actions">
        <a href="${esc(src)}" target="_blank" rel="noopener">Source ↗</a>
        ${run}
      </div>
    </article>`;
}

function draw(tokens) {
  const slice = MATCHES.slice(drawn, drawn + PAGE);
  els.results.insertAdjacentHTML('beforeend', slice.map((a) => card(a, tokens)).join(''));
  drawn += slice.length;
  els.more.hidden = drawn >= MATCHES.length;
}

/* -------------------------------------------------------------- url state */

const PARAMS = ['q', 'release', 'control', 'library', 'status'];

function writeUrl(f) {
  const p = new URLSearchParams();
  for (const key of PARAMS) {
    if (f[key]) p.set(key, f[key]);
  }
  const q = p.toString();
  history.replaceState(null, '', q ? `?${q}` : location.pathname);
}

function readUrl() {
  const p = new URLSearchParams(location.search);
  els.q.value = p.get('q') || '';
  for (const key of ['release', 'control', 'library', 'status']) {
    const v = p.get(key);
    /* Only a value the current index still knows — a link from before a
     * control was renamed must not leave a dead filter selected. */
    if (v && [...els[key].options].some((o) => o.value === v)) els[key].value = v;
  }
}

function reset() {
  els.q.value = '';
  for (const key of ['release', 'control', 'library', 'status']) els[key].value = '';
  apply();
  els.q.focus();
}

/* ------------------------------------------------------------------- boot */

async function boot() {
  let raw;
  try {
    const res = await fetch('apps.json');
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    raw = await res.json();
  } catch (err) {
    els.count.textContent = '';
    els.results.innerHTML = `<p class="empty">The catalogue could not be loaded (${esc(err.message)}). It is written by the deploy build; on a local checkout run <code>node scripts/generate-search-index.mjs</code> first.</p>`;
    return;
  }

  DATA = raw;
  /* Resolve the shared control dictionary once, and precompute the search
   * string — 431 ports is small enough that filtering can stay a plain scan. */
  for (const app of DATA.apps) {
    app.controlNames = app.controls.map((i) => DATA.controls[i]);
    app.hay = haystack(app);
  }

  els.total.textContent = String(DATA.apps.length);
  buildFacets();
  readUrl();
  apply();

  els.q.addEventListener('input', apply);
  for (const key of ['release', 'control', 'library', 'status']) els[key].addEventListener('change', apply);
  els.reset.addEventListener('click', reset);
  els.reset2.addEventListener('click', reset);
  els.loadmore.addEventListener('click', () => draw(els.q.value.trim().toLowerCase().split(/\s+/).filter(Boolean)));
  document.getElementById('filters').addEventListener('submit', (e) => e.preventDefault());

  /* `/` focuses the search box, the way a documentation site does. */
  document.addEventListener('keydown', (e) => {
    if (e.key === '/' && !/^(INPUT|TEXTAREA|SELECT)$/.test(document.activeElement.tagName)) {
      e.preventDefault();
      els.q.focus();
      els.q.select();
    }
  });
}

boot();
