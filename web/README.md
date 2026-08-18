# web — run the samples-controls ports in the browser (GitHub Pages)

This folder builds a **fully client-side** version of the samples-controls ports:
the abap2UI5 framework and every `z2ui5_cl_smpc_app_*` port are transpiled to
JavaScript, bundled with webpack, and run in the browser with **no ABAP
backend** — the transpiled `z2ui5_cl_http_handler` answers the app's own
roundtrips in-page (a `fetch` interceptor), and sql.js (WASM) provides the
draft database. The result is the static site in `build/`, which the
`deploy-web` workflow uploads to GitHub Pages.

It is a thin adaptation of the official
[abap2UI5/web-abap2UI5](https://github.com/abap2UI5/web-abap2UI5) build
(transpiler, express-icf-shim and webpacking by
[larshp](https://github.com/larshp)) — the only change is that it assembles
**this repo's ports** instead of the `samples` repo, and lands on the port
overview (`z2ui5_cl_smpc_app_000`) instead of the framework home page.

## How it works

1. **assemble** — clone the abap2UI5 framework into `src/` (which brings the
   `z2ui5_cl_ui5_view_builder` builder along), then copy this repo's `../src` (every
   `z2ui5_cl_smpc_app_*` port + the overview) into `src/ai-demokit/`.
2. **downport** — copy `src/` → `downport/` and `abaplint --fix` it to v702
   (the transpiler cannot take modern ABAP directly).
3. **transpile** — `@abaplint/transpiler` emits `output/*.mjs` (+ the
   express-icf-shim and open-abap-core runtime libs).
4. **webpack:build** — bundle `app/web.mjs` + the transpiled backend + sql.js
   into `build/` (one `app.bundle.js` + the WASM files).

`build/` is what `deploy-web` uploads to GitHub Pages, and it is not
committed: the bundle is ~28 MB, and a copy of it in the repository was both
a second thing to keep current and the largest object in the history.

## Rebuild

```bash
cd web
npm ci
npm run all        # assemble → downport → transpile → webpack
```

Nothing to commit afterwards — `build/` is a build output and `deploy-web`
produces its own. Test locally (the `document.write` boot does not work with
webpack-dev-server HMR):

```bash
npm run serve:build   # serves web/build on http://localhost:8081
```

Note: the served frontend loads OpenUI5 from `https://sdk.openui5.org` (CDN),
which is reachable from GitHub Pages and any normal browser but may be blocked
in a restricted sandbox — there the controls render but stay unthemed.

## Landing page

`app/index.html` sets `?app_start=z2ui5_cl_smpc_app_000` when no app is
requested, so the bare Pages URL opens the port overview. Each overview row
has a *"Start this abap2UI5 app in a new tab"* link (`?app_start=<class>`).

## Patched transpiler lib (`open-abap-core`)

`assemble` clones [open-abap-core](https://github.com/open-abap/open-abap-core)
into `open-abap-core/` and runs
[`ci/patch_open_abap_xml.mjs`](ci/patch_open_abap_xml.mjs) over it;
`ci/abap_transpile.json` points at that folder instead of letting the
transpiler clone the lib itself. The patch makes
`CALL TRANSFORMATION id … RESULT XML` **escape character data**: upstream
writes element values raw, so an app whose model holds a `<` (the overview's
generation notes) persists a draft that the transpiled `CL_IXML` cannot parse
back — the next round-trip then dies in an uncatchable `ASSERT` and the page
shows `Network error: ASSERTION_FAILED` (reported 2026-07-31 for the
overview's links / generation-notes popovers). Forwarded upstream as
[`backlog/items/open-abap-xml-escaping`](https://github.com/abap2UI5/abap2UI5/blob/main/backlog/items/open-abap-xml-escaping.md)
in abap2UI5; drop the clone, the patch and this section once it is merged
there.

## Known limitation

A few ports drive behaviour through backend roundtrips (toggles, mode
switches, toasts) — these work in-browser. Interactions that depend on
recently whitelisted frontend methods need a framework clone that already
carries them (the split-container navigation set was merged upstream as
abap2UI5 #2470, 2026-07-24). Initial render of every port is unaffected.

A round-trip is also **noticeably slower here than on a real server**: the
transpiled `CL_IXML` re-parses the persisted draft on every request and its
parser is quadratic in the draft size. Keep the bound model small (only what
the view renders — see AGENTS §10) and round-trips stay in the
fraction-of-a-second range.
