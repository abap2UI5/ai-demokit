# abap2UI5 MCP server — build, run and *see* abap2UI5 apps, no SAP system needed

An [MCP](https://modelcontextprotocol.io) server that gives any AI coding
agent (Claude Code, Cursor, or any MCP client) the full abap2UI5 development
loop:

```
capabilities  ->  deploy_app  ->  build_backend  ->  run_app
 (what can           (write ABAP,      (transpile         (boot headless,
  I express?)         lint)             to Node)           errors + SCREENSHOT)
```

The agent writes an ABAP class, deploys it, boots it in a real browser and
**looks at the screenshot** — then iterates. Everything runs locally on the
repo's existing infrastructure: the abaplint transpiler + open-abap runtime
(`scripts/e2e-build.mjs`), the framework's express shim, and the same
Playwright boot gate the nightly e2e uses (`scripts/e2e-smoke.mjs`). No SAP
system, no deployment, no CDN.

## Setup

```sh
npm ci                  # this repo's deps (includes the MCP SDK + playwright)
npm run node:setup      # once: clone abap2UI5 into .abap2UI5 and build
npx playwright install chromium   # if no local chromium yet
```

Register the server in your MCP client, e.g. Claude Code:

```sh
claude mcp add abap2ui5 -- node mcp/server.mjs
```

(Run from the repo root, or give the absolute path to `mcp/server.mjs`.)

## Tools

| Tool | What it does |
|---|---|
| `capabilities` | Query the verified capability map (CAPABILITIES.md, parsed live — no drift). Ask before assuming a UI5 feature is impossible: `{ query: "tree binding" }`, `{ status: "not-expressible" }` |
| `generation_rules` | The rulebook for writing an app with the generic view builder (`scripts/generation-prompt.txt`) |
| `scope_of` | In/out-of-scope verdict for UI5 controls (since <= 1.71, not deprecated), from the OpenUI5 source JSDoc |
| `deploy_app` | Write `<class>.clas.abap` + abapGit sidecar into the gitignored sandbox `src/zz_dev/`, then abaplint it |
| `build_backend` | Rebuild the transpiled Node backend (framework + ports + dev apps). A few minutes — batch deploys, build once |
| `run_app` | Boot any app class headless (`?app_start=<class>`), return boot status, real page errors (benign UI5 noise filtered, same rules as e2e-smoke) and a full-page **screenshot as an image** |
| `backend` | `status` / `start` / `stop` / `restart` of the local express backend (run_app auto-starts it) |
| `remove_app` | Delete a dev app from `src/zz_dev/` (or list the deployed ones) |

`run_app` works for new dev apps and equally for the 276 existing ports and
`z2ui5_cl_ai_app_overview` — useful as a reference: "run the closest existing
port, look at it, then build mine".

## The intended agent loop

1. `capabilities { query: ... }` — check the feature is expressible (and how)
   before writing a line of ABAP. Never improvise around an entry marked
   expressible.
2. `generation_rules` — once per session.
3. Write the class, `deploy_app` — fix lint findings until clean.
4. `build_backend` — once per batch of changes.
5. `run_app` — read the errors, **look at the screenshot**, compare with what
   was asked. Edit, deploy, build, run again.

## Notes

- **Dev sandbox:** `src/zz_dev/` is gitignored — nothing an agent deploys can
  leak into a commit. Promote a finished app by moving it into a real package
  (or the samples repo) deliberately.
- **Port:** the backend listens on 3000 (`A2UI5_MCP_PORT` overrides).
- **UI5 sources:** served from the installed `@openui5` packages, so the loop
  works fully offline; `sdk.openui5.org` requests are routed locally exactly
  like in e2e-smoke.
- **Screenshots:** also written to `mcp/screenshots/<class>.png` (gitignored)
  so a human can look at the same image the agent saw.
- **Real system deployment** stays what it is today: abapGit. This server is
  the inner dev loop; nothing here talks to an SAP system.
