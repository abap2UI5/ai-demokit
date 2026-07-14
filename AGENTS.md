# AGENTS.md — abap2UI5-api

Single source of truth for agents working on **abap2UI5-api**.

> These instructions OVERRIDE any default behavior and must be followed exactly.
> This entire project is in **English** — code, comments, commit messages, PRs.

---

## 1. Mission — an automated repository

This repo exists to **clone every official UI5 demo kit sample and independently
rebuild it as an abap2UI5 sample**. Doing that systematically reveals the gaps
between what UI5 ships and what abap2UI5 can already express — and those gaps
become the backlog to close.

The pipeline (run by a coding agent):

1. **Read** — clone [OpenUI5](https://github.com/SAP/openui5), scan every demo
   kit sample at `src/<library>/test/<library>/demokit/sample/<Name>/`.
2. **Generate** — rebuild each sample 1:1 as an abap2UI5 app (a class
   implementing `z2ui5_if_app`), filed by library under `src/`.
3. **Store templates** — keep the untouched original UI5 JS/XML templates in the
   `ui5/` folder.
4. **Report** — regenerate `COVERAGE.md`: every sample marked ✅ ported /
   ❌ missing, with a coverage figure per module.

Curated, hand-reviewed samples ultimately graduate to the
[abap2UI5/samples](https://github.com/abap2UI5/samples) repo. Everything here is
machine-generated and carries the "not yet manually reviewed" marker (§5).

---

## 2. Layout — two trees in one branch

Everything lives on the working branch, in two separate top-level trees:

| Path    | Content |
|---------|---------|
| `src/`  | The generated abap2UI5 ports (`*.clas.abap`) — the abapGit project (§3). |
| `ui5/`  | The original UI5 demo kit templates (JS/XML/manifest), one folder per port (§4). |

Keep them separate: only `src/` is the abapGit / abaplint scope; `ui5/` is
plain JS/XML held for reference and to feed the generator.

---

## 3. Repository layout — the ABAP ports

abapGit project, `FOLDER_LOGIC=PREFIX`, `STARTING_FOLDER=/src/`. Ports are split
by the UI5 **library** of the demo kit sample they rebuild:

| Folder   | CTEXT (`package.devc.xml`) | Library namespace |
|----------|----------------------------|-------------------|
| `src/01` | `sap.m`    | `sap.m`    |
| `src/02` | `sap.ui`   | `sap.ui.*` (core, layout, unified, table, integration, model.type) |
| `src/03` | `sap.uxap` | `sap.uxap` |
| `src/04` | `sap.f`    | `sap.f`    |
| `src/05` | `sap.tnt`  | `sap.tnt`  |

The split key is the **second-level namespace** of the sample's entity. New
libraries get the next free `src/NN` folder with a matching `package.devc.xml`.

Because `FOLDER_LOGIC=PREFIX`, class names never encode the folder — moving a
class between folders needs no rename.

### Class naming

Ports are named `z2ui5_cl_demo_app_<n>` (lowercase). `<n>` is a stable, unique
number; it is the app's identity linking a port to its template (see §4).

---

## 4. The `ui5/` folder — original templates

Every port's source template is collected under `ui5/`. **The template folder is
named after the port class**, filed by source library:

```
ui5/<library>/<z2ui5_cl_demo_app_n>/   ← original Component.js, *.view.xml,
                                          manifest.json, controllers, resources
```

The folder name (class) is the join key between a port (`src/`) and its template
(`ui5/`). Templates are held verbatim — never edited to fit ABAP; that is the
generator's job. `COVERAGE.md` links the two together (§7).

---

## 5. Generation rules

Each generated port carries ABAP Doc directly above `CLASS ... DEFINITION`:

```abap
"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: <demo kit url>
"! <full, untruncated sample description>
```

- The `<demo kit url>` ends in `/sample/<lib>.sample.<Name>` — this is what the
  coverage generator parses to match a port to its source sample (§7). **Never
  remove or reword this line.**
- The abapGit `<DESCRIPT>` follows `<entity> - <demo kit description>`
  (e.g. `sap.m.Switch - Some say it is only a switch...`), truncated to 60 chars.
- Use **only** controls and properties available since UI5 1.71; never a
  deprecated one. If a sample needs anything newer or deprecated, **do not
  port it** — leave it as an ❌ gap in the coverage report.
- Every port must pass all three CI checks (§6).

### Generation prompt

The prompt used to port one sample is kept in `README.md` (the "Generation
prompt" section). Keep the two in sync.

---

## 6. CI checks & downport

Three abaplint checks run on every pull request; all must report **0 issues**:

| Build           | Command | abaplint syntax |
|-----------------|---------|-----------------|
| `ABAP_STANDARD` | `abaplint ./abaplint.jsonc`                     | `v750` |
| `ABAP_CLOUD`    | `abaplint .github/abaplint/abap_cloud.jsonc`    | `Cloud` |
| `ABAP_702`      | `npm run downport` → `abaplint .github/abaplint/abap_702.jsonc` | `v702` |

Every sample must be **ABAP Cloud ready** *and* **downportable to 7.02** — there
is no `src/00` "restricted" area here (unlike abap2UI5/samples); everything must
survive all three builds. The `auto_cloud` / `auto_downport` workflows rebuild
the `cloud` / `702` branches via `auto_branch.yaml`.

**Run before every commit:**
```bash
npm ci
npx abaplint ./abaplint.jsonc          # expect 0 issues
```

### abapGit file format (all serialized files)

- Encoding UTF-8 (BOM allowed); line endings **LF only**; **final newline**.
- Indentation 2 spaces. Max **255 characters** per `.abap` line (split long
  literals with `&&`).

---

## 7. Coverage report — always (re)generated

`COVERAGE.md` is generated, never hand-edited. It lists every demo kit sample of
every library and marks ✅/❌, with per-module coverage.

```bash
OPENUI5_DIR=../openui5 node scripts/generate-coverage.mjs
```

- **Universe of samples** — every `demokit/sample/<Name>` directory in the
  OpenUI5 checkout at `$OPENUI5_DIR` (default `./openui5`).
- **Ported set** — parsed from each `src/**/*.clas.abap` port's
  `Rebuild of the UI5 demo kit sample: .../sample/<lib>.sample.<Name>` line.
- A port matches a sample on `(library, Name)`.

The `generate_coverage` workflow (`workflow_dispatch` + weekly) shallow-clones
OpenUI5, runs the script, stamps the `<!-- last-run -->` timestamp into
`README.md`, and opens a pull request. Edit the **script**, never the generated
`COVERAGE.md`.

---

## 8. ABAP code conventions

Follow the [SAP Clean ABAP style guide](https://github.com/SAP/styleguides/blob/main/clean-abap/CleanABAP.md)
and the detailed conventions in the
[abap2UI5/samples AGENTS.md](https://github.com/abap2UI5/samples/blob/main/AGENTS.md)
(§7 code conventions, §9 app lifecycle, §10 view building, §11 app structure) —
the ports share that style. Essentials:

- Class names **lowercase** in `DEFINITION` and `IMPLEMENTATION`; not `FINAL`;
  `DEFINITION PUBLIC.` (never `CREATE PUBLIC`).
- Always include `PROTECTED SECTION.` and `PRIVATE SECTION.` (keep `PRIVATE`
  empty). Order per section: `TYPES`, then `DATA`, then `METHODS`.
- Backticks for string literals; string templates (`|...{ }...|`) for
  concatenation; `VALUE #( )` to reset, never `CLEAR`.
- Prefix only tables (`t_`) and structures (`s_`); local types `ty_s_` / `ty_t_`.
- Lifecycle: chain `check_on_init( )` / `check_on_navigated( )` /
  `check_on_event( )` with `ELSEIF`. Re-display the view in the
  `check_on_navigated( )` branch.
- Build views with `z2ui5_cl_xml_view` (typed) or `z2ui5_cl_util_xml` (generic);
  `client->view_display( view->stringify( ) )` as a standalone final statement.

**Run `abaplint` after every change — 0 issues before committing.**

---

## 9. Dependencies

* [abap2UI5](https://github.com/abap2UI5/abap2UI5) — the framework the ports run on.
* [OpenUI5](https://github.com/SAP/openui5) — the source of the demo kit samples.
