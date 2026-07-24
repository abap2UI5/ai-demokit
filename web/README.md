# web — run the ai-demokit ports in the browser (GitHub Pages)

This folder builds a **fully client-side** version of the ai-demokit ports:
the abap2UI5 framework and every `z2ui5_cl_ai_app_*` port are transpiled to
JavaScript, bundled with webpack, and run in the browser with **no ABAP
backend** — the transpiled `z2ui5_cl_http_handler` answers the app's own
roundtrips in-page (a `fetch` interceptor), and sql.js (WASM) provides the
draft database. The result is the static site in [`../docs`](../docs), which
GitHub Pages serves.

It is a thin adaptation of the official
[abap2UI5/web-abap2UI5](https://github.com/abap2UI5/web-abap2UI5) build
(transpiler, express-icf-shim and webpacking by
[larshp](https://github.com/larshp)) — the only change is that it assembles
**this repo's ports** instead of the `samples` repo, and lands on the port
overview (`z2ui5_cl_ai_app_overview`) instead of the framework home page.

## How it works

1. **assemble** — clone the abap2UI5 framework into `src/`, then copy this
   repo's `../src` (all 136 ports + the `z2ui5_cl_ai_xml` builder + the
   overview) into `src/ai-demokit/`.
2. **downport** — copy `src/` → `downport/` and `abaplint --fix` it to v702
   (the transpiler cannot take modern ABAP directly).
3. **transpile** — `@abaplint/transpiler` emits `output/*.mjs` (+ the
   express-icf-shim and open-abap-core runtime libs).
4. **webpack:build** — bundle `app/web.mjs` + the transpiled backend + sql.js
   into `build/` (one `app.bundle.js` + the WASM files).
5. **deploy:docs** — copy `build/` → `../docs` (the Pages source).

## Rebuild

```bash
cd web
npm ci
npm run all        # assemble → downport → transpile → webpack → copy to ../docs
```

Then commit the updated `../docs`. Test locally before committing (the
`document.write` boot does not work with webpack-dev-server HMR):

```bash
npm run serve:build   # serves ../build on http://localhost:8081
```

Note: the served frontend loads OpenUI5 from `https://sdk.openui5.org` (CDN),
which is reachable from GitHub Pages and any normal browser but may be blocked
in a restricted sandbox — there the controls render but stay unthemed.

## Landing page

`app/index.html` sets `?app_start=z2ui5_cl_ai_app_overview` when no app is
requested, so the bare Pages URL opens the port overview. Each overview row
has a *"Start this abap2UI5 app in a new tab"* link (`?app_start=<class>`).

## Known limitation

A few ports drive behaviour through backend roundtrips (toggles, mode
switches, toasts) — these work in-browser. Interactions that depend on the
b12 split-container navigation methods need the matching frontend whitelist
in the framework; the daily upstream framework clone may lag those until they
are merged. Initial render of every port is unaffected.
