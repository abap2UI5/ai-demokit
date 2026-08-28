# Running the ports locally (real app in your browser)

The ports are ABAP apps. With the abap2UI5 transpiler they run on a **Node
backend** (open-abap runtime + express), so you can start any port and click
through it in a normal browser — no SAP system needed.


## Never run `e2e:build` alongside anything else in the abap2UI5 checkout

`npm run e2e:build` downports a COPY of the framework into `<abap2UI5>/node/downport`
and transpiles it into `<abap2UI5>/node/output`. `npm run verify` in the framework
does the same thing, into the same two directories, and `abaplint --fix` rewrites
files in place while it runs. Running them concurrently corrupts the working tree:
on 2026-08-06 a parallel `verify` left **86 files under `src/` rewritten to their
downported v702 form** — `RAISE` parser errors and unresolved types everywhere, with
nothing in either command's output saying so.

The build takes ~25 minutes and holds the checkout for all of it. Start it, wait for
`e2e-build: done`, and only then touch the framework again. `git status` in the
abap2UI5 checkout is the check: if `src/` is dirty after a build, restore it with
`git checkout -- src/` and re-run `npm run app2abap` for the generated `src/01/03`.

## Quick start (two commands)

```sh
npm run node:setup     # once: clone abap2UI5 into .abap2UI5, install everything, build
npm run node:serve     # start the Node backend on http://localhost:3000
```

Then open <http://localhost:3000/?app_start=z2ui5_cl_smpc_app_000>.

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
http://localhost:3000/?app_start=z2ui5_cl_smpc_app_000
```

## Open a single port directly

Start any port via the `?app_start=<class>` query parameter:

```
http://localhost:3000/?app_start=z2ui5_cl_smpc_app_005     # Button
http://localhost:3000/?app_start=z2ui5_cl_smpc_app_060     # Menu
http://localhost:3000/?app_start=z2ui5_cl_smpc_app_092     # TableAutoPopin
```

The class name is `z2ui5_cl_smpc_app_<NNN>` — see `meta/` or the overview app for
the list. UI5 itself loads from the public CDN (`sdk.openui5.org`), so this
needs internet access on your machine (the CI sandbox blocks it, which is why
`npm run e2e` routes UI5 to the local `@openui5` packages instead).

## Automated smoke over every port

```sh
npm run e2e:build            # (re)build the transpiled backend — a port edited
                             # after the last build is not what the browser runs
npm run e2e                  # boots each port headless, asserts boot+render+no-error
```

`npm run e2e` takes two subsetting flags, and CI uses both:

```bash
node scripts/e2e-smoke.mjs --only 462,350   # named ports (debugging, and the PR job)
node scripts/e2e-smoke.mjs --shard 2/4      # the 2nd of 4 round-robin slices
```

The shard is taken round-robin over the SORTED class list, not in contiguous
blocks: the ports are numbered in batch order, so blocks would put a whole
library — and its whole class of failure — in one shard, and a shard that is
always red stops being read. It is deterministic, so a red shard is
reproducible with the same flag. The overview app rides with shard 1.

`e2e-pr.yaml` runs the ports a pull request touches (`--only`, from
`scripts/e2e-changed.mjs`) and `e2e-nightly.yaml` runs the corpus in four
shards (`--shard i/4`).

See `scripts/e2e-build.mjs` / `scripts/e2e-smoke.mjs` for details, and AGENTS.md
(`e2e_smoke` gate) for where it fits among the checks.

## Patched `open-abap-core`

`e2e-build` clones [open-abap-core](https://github.com/open-abap/open-abap-core)
into `<abap2UI5 checkout>/node/open-abap-core`, patches it with
`web/ci/patch_open_abap_xml.mjs` (which lives there because abap2UI5/mcp-server
executes that exact path — see `web/README.md`) and
transpiles against that copy. Upstream's `CALL TRANSFORMATION id … RESULT XML`
writes character data unescaped, so any app whose model carries a `<` saves a
draft its own `CL_IXML` cannot parse back — every later round-trip then fails
with `Network error: ASSERTION_FAILED`. The clone is reused across builds;
delete it to pick up a newer open-abap-core.
