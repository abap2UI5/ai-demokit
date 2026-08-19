# web — the searchable catalogue on GitHub Pages

**<https://abap2ui5.github.io/samples-controls/>** — every port in this
repository, searchable, as a static page. `web/search/` is the whole site:
three hand-written files and one generated JSON, uploaded as the Pages
artefact by the [`deploy-web`](../.github/workflows/deploy-web.yaml) workflow.

```
web/search/index.html   the page
web/search/search.css   light and dark off one set of custom properties
web/search/search.js    filtering and drawing — plain ES2020, no dependencies
web/search/apps.json    generated, NOT committed (see below)
```

## What it answers

`SAMPLES.md` answers "is there a port that shows X" for somebody who scrolls.
The two questions this corpus is actually asked, nothing here could answer:

> *"my system runs UI5 1.84 — which of these will render on it?"*
> *"which ports use `sap.m.Table` at all, not just the one filed under it?"*

Neither is in the sidecars. `entity` is the ONE control a sample is *about*, so
a port that merely uses a Table inside a page about something else is invisible
to it; and a port's UI5 floor is written nowhere — the `POST_171` deviations
name it in prose, which is a sentence for a human, not a filter.

Both come out of [`@abap2UI5/linter`](https://www.npmjs.com/package/@abap2ui5/linter),
which already reconstructs the view a builder chain produces and resolves every
control against the UI5 metadata snapshot — the same pass `view-gates` runs,
render gate off. It is asked for two things it computes anyway:

| | |
|---|---|
| `stats.types` | every control the port **builds**, with occurrences |
| `*-too-new` findings | everything above the 1.71 floor, each carrying its `@since` |

The highest of those `@since` values **is** the port's minimum release, and the
floor itself when there are none. Derived rather than restated, so the page
cannot drift from the corpus.

Free text runs over the demo kit's descriptions, each class's `@summary` and
`@keywords` line, the entity and the controls. Three facets: *runs on UI5
&lt;release&gt;*, *uses control*, *library*. Filters live in the URL, so a
search is linkable.

## `apps.json` is not committed

It is derived twice over — from the sidecars and from a linter run — and it is
~350 KB. Committing it would put that diff on every port PR while adding a gate
that can only restate what the linter already says. `deploy-web` regenerates it
on every deploy instead, so it is never staler than the site serving it.

```bash
npm ci                                    # in the repository root
node scripts/generate-search-index.mjs    # or: npm run search:index
```

## Running it locally

Nothing to build:

```bash
npx http-server web/search -p 8099
#  or: python3 -m http.server 8099 -d web/search
```

Both links on every card are absolute (GitHub, and the playground), so they
work from a local server exactly as they do in production.

## The two links per port

**Source** is the class on GitHub. Every port is a single class, so that link
is the whole sample.

**Run in the playground** opens the class in
[abap2UI5/playground](https://abap2ui5.github.io/playground/) via
`?src=<its raw URL>` — the ABAP in an editor with the app running beside it, no
system anywhere.

That build carries eight UI5 libraries (`sap.ui.core`, `sap.m`, `sap.f`,
`sap.ui.layout`, `sap.ui.table`, `sap.ui.unified`, `sap.tnt`, `sap.uxap`) at one
pinned release, and a port outside them would open a frame that renders
nothing. Such a port keeps the button **disabled**, with a title naming the
library that is missing — a dead link is worse than no link, and a button that
silently vanished would leave a reader wondering whether they misread the row.
Those two constants are copied from the playground's `tools/build-ui5.mjs`; if
that build gains a library, the copy here goes stale in the safe direction — a
button greyed out, never a link that fails.

## What used to be here

Until 2026-08-19 this folder built the whole **in-browser demo**: the abap2UI5
framework and all 430 ports cloned, downported to 702 with `abaplint --fix`,
transpiled to JavaScript, and webpacked with sql.js into a 28 MB bundle that
answered the apps' own round-trips in-page — a *"Run here"* link per port and
no backend anywhere. It was removed by maintainer decision.

The downport alone cost twenty minutes of every deploy, and what it bought the
playground does better and maintains in its own repository: an editor beside the
app, abaplint and the abap2UI5 linter live against the real framework sources,
and one UI5 build kept current there rather than here. It is one `git revert`
away if that changes.

## `web/ci/` is NOT part of this page

Two scripts survived the removal because they were never only about it:

| | |
|---|---|
| `patch_open_abap_xml.mjs` | makes `CALL TRANSFORMATION id … RESULT XML` escape character data — upstream writes element values raw, so a model holding a `<` persists a draft the transpiled `CL_IXML` cannot parse back, and the next round-trip dies in an uncatchable `ASSERT`. |
| `patch_follow_up_action.mjs` | the follow-up-action rewrite both transpiled builds need. |

`scripts/e2e-build.mjs` executes both, and **abap2UI5/mcp-server executes
`web/ci/patch_open_abap_xml.mjs` by that exact path** — which is why
`scripts/check-mcp-contract.mjs` fails the build if it moves. Do not "tidy" them
into `scripts/` without changing mcp-server first. Upstream fix tracked as
[`backlog/items/open-abap-xml-escaping`](https://github.com/abap2UI5/abap2UI5/blob/main/backlog/items/open-abap-xml-escaping.md);
drop both the patch and this section once it is merged there.
