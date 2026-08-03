# Running the ports locally (real app in your browser)

The ports are ABAP apps. With the abap2UI5 transpiler they run on a **Node
backend** (open-abap runtime + express), so you can start any port and click
through it in a normal browser — no SAP system needed.

## Quick start (two commands)

```sh
npm run node:setup     # once: clone abap2UI5 into .abap2UI5, install everything, build
npm run node:serve     # start the Node backend on http://localhost:3000
```

Then open <http://localhost:3000/?app_start=z2ui5_cl_ai_app_overview>.

`node:setup` clones abap2UI5 into `.abap2UI5` (in-repo, git-ignored), runs
`npm ci` there and here, and builds the backend. Re-run it any time to pull the
latest abap2UI5 and rebuild. After editing ports, rebuild with `npm run
node:build` (no re-clone). All Node commands need Node ≥ 22 and, for the clone,
`git` + internet.

<details>
<summary>Manual setup (own abap2UI5 checkout)</summary>

Prefer your own checkout instead of the in-repo clone? Point at it with
`A2UI5_HOME` (it wins over `.abap2UI5`), install its deps and this repo's once,
then build + serve:

```sh
cd ../abap2UI5 && npm ci && cd -   # framework deps
npm ci                             # this repo's deps
A2UI5_HOME=../abap2UI5 npm run node:build
A2UI5_HOME=../abap2UI5 npm run node:serve
```

The checkout is resolved in this order: `A2UI5_HOME`, then `.abap2UI5`, then a
sibling `../abap2UI5`.
</details>

## Open the overview (front door — lists every port)

The simplest entry point is the overview app: it lists all ported samples in
one flat table (the only view of the catalog), and every row has a **Start this abap2UI5 app in a new tab**
button that launches the port right there.

```
http://localhost:3000/?app_start=z2ui5_cl_ai_app_overview
```

## Open a single port directly

Start any port via the `?app_start=<class>` query parameter:

```
http://localhost:3000/?app_start=z2ui5_cl_ai_app_005     # Button
http://localhost:3000/?app_start=z2ui5_cl_ai_app_060     # Menu
http://localhost:3000/?app_start=z2ui5_cl_ai_app_092     # TableAutoPopin
```

The class name is `z2ui5_cl_ai_app_<NNN>` — see `meta/` or the overview app for
the list. UI5 itself loads from the public CDN (`sdk.openui5.org`), so this
needs internet access on your machine (the CI sandbox blocks it, which is why
`npm run e2e` routes UI5 to the local `@openui5` packages instead).

## Automated smoke over every port

```sh
npm run e2e:build            # (re)build the transpiled backend — a port edited
                             # after the last build is not what the browser runs
npm run e2e                  # boots each port headless, asserts boot+render+no-error
```

See `scripts/e2e-build.mjs` / `scripts/e2e-smoke.mjs` for details, and AGENTS.md
(`e2e_smoke` gate) for where it fits among the checks.

## Patched `open-abap-core`

`e2e-build` clones [open-abap-core](https://github.com/open-abap/open-abap-core)
into `<abap2UI5 checkout>/node/open-abap-core`, patches it with
`web/ci/patch_open_abap_xml.mjs` (the same patch the browser build applies) and
transpiles against that copy. Upstream's `CALL TRANSFORMATION id … RESULT XML`
writes character data unescaped, so any app whose model carries a `<` saves a
draft its own `CL_IXML` cannot parse back — every later round-trip then fails
with `Network error: ASSERTION_FAILED`. The clone is reused across builds;
delete it to pick up a newer open-abap-core.
