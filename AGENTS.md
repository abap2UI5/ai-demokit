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
4. **Report** — regenerate the coverage (`README.md` summary + `api.md`) and the
   in-system overview app: every sample marked ✅ ported / ❌ missing, with a
   coverage figure per module.

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

Ports are named `z2ui5_cl_api_app_<n>` (lowercase). `<n>` is a stable, unique
number; it is the app's identity linking a port to its template (see §4).

---

## 4. The `ui5/` folder — original templates

Every port's source template is collected under `ui5/`. **The template folder is
named after the port class**, filed by source library:

```
ui5/<library>/<z2ui5_cl_api_app_n>/   ← original Component.js, *.view.xml,
                                          manifest.json, controllers, resources
```

The folder name (class) is the join key between a port (`src/`) and its template
(`ui5/`). Templates are held verbatim — never edited to fit ABAP; that is the
generator's job. `ui5/` is the generator's local input store; the `api.md`
**Javascript** column links to the sample's source in the upstream
[OpenUI5 repository](https://github.com/SAP/openui5), not to this copy (§7).

---

## 5. Generation rules

Each generated port carries ABAP Doc directly above `CLASS ... DEFINITION`:

```abap
"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! <entity> - <SampleName>
"! <demo kit url>
```

- Line 1 is fixed and literal. Line 2 is `<entity> - <SampleName>`, e.g.
  `sap.m.CheckBox - CheckBoxTriState` (the `<SampleName>` is the sample id tail
  after `.sample.`).
- Line 3 `<demo kit url>` is the **OpenUI5** demo kit link
  (`https://sdk.openui5.org/entity/<entity>/sample/<lib>.sample.<Name>`) — its
  `.../entity/<entity>/sample/<lib>.sample.<Name>` tail is what the coverage and
  overview generators parse to match a port to its source sample (§7). Always use
  the OpenUI5 host (`sdk.openui5.org`), never the commercial SAPUI5 one. **Never
  remove or reword this URL line.**
- The abapGit `<DESCRIPT>` follows `<entity> - <demo kit description>`
  (e.g. `sap.m.Switch - Some say it is only a switch...`), truncated to 60 chars.
- Use **only** controls and properties available since UI5 1.71; never a
  deprecated one. If a sample needs anything newer or deprecated, **do not
  port it** — leave it as an ❌ gap in the coverage report.
- Every port must pass all three CI checks (§6).

### App skeleton — how a port is built

This is the complete recipe for turning one UI5 demo kit sample into a port.
Follow it exactly so every port looks the same and stays maintainable.

**Inputs** — the sample's original files from the OpenUI5 checkout: the
`*.view.xml` (the UI), the controller (`*.controller.js` — event handlers),
`Component.js` / `manifest.json` (which model data is loaded), plus any local
`*.json` mock data. All of these are also copied verbatim into the port's
`ui5/<library>/<class>/` folder (§4).

**Output** — one class `z2ui5_cl_api_app_<n>` implementing `z2ui5_if_app`, whose
view is a **1:1** rebuild of the sample's XML.

#### Class layout

```abap
CLASS z2ui5_cl_api_app_<n> DEFINITION PUBLIC.       " lowercase, not FINAL

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    " local types for the model data (ty_s_ / ty_t_) + the DATA that back the
    " bindings live here, so the framework can serialise them across round-trips
    TYPES: BEGIN OF ty_s_item, ... END OF ty_s_item.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.
    " ONLY bound DATA belongs in PUBLIC: the round-trip model scan walks the
    " public instance attributes, so every non-bound helper/backup kept here
    " just slows the binding search. Put such state in PROTECTED (see below).

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS data_init.       " only if the app has model data
    METHODS on_event.        " only if the app reacts to events
    METHODS view_display.

  PRIVATE SECTION.           " always present, kept empty
ENDCLASS.
```

#### `z2ui5_if_app~main` — the dispatcher

```abap
METHOD z2ui5_if_app~main.

  me->client = client.
  IF client->check_on_init( ).
    data_init( ).
    view_display( ).
  ELSEIF client->check_on_event( ).
    on_event( ).
  ENDIF.

ENDMETHOD.
```

- `check_on_init( )` fires once when the app starts — seed the data, draw the view.
- `check_on_event( )` fires on every user interaction — dispatch in `on_event( )`.
- Add `data_init( )` / `on_event( )` **only when the app actually has data /
  events** — never a pass-through method with a single statement. A static app
  (like app 408) has just `view_display( )` under `check_on_init( )`.
- If the sample re-displays on navigation, add an
  `ELSEIF client->check_on_navigated( ). view_display( ).` branch.

#### `data_init` — the model

The sample's JSON model becomes ABAP: one `ty_s_`/`ty_t_` type per JSON array,
filled with `VALUE #( ( … ) ( … ) )`. Field names are the JSON keys, upper-cased
by ABAP; bindings reference them in braces (`{TITLE}`, `{PRODUCT_ID}`). Keep the
data verbatim from the sample (same rows, same text). See app 416 / 454.

#### `view_display` — the view via `z2ui5_cl_api_xml`

Build the view with the generic builder **`z2ui5_cl_api_xml`**. It translates a
UI5 XML view 1:1 by method chaining — every control, property and namespace maps
directly, nothing is approximated. The four navigation verbs are all 4 chars so
the `)->` arrows line up:

| Verb | XML meaning | Tree action | Returns |
|------|-------------|-------------|---------|
| `open( n ns a )` | open a container tag `<X>` | add child **and descend** into it | the new child |
| `leaf( n ns a )` | a self-closing tag `<X/>` | add child, **stay** on current node | the same node |
| `shut( )` | the closing `</X>` | **ascend** to the parent | the parent |
| `attr( n v )` | one `name="value"` | add an attribute to the control just opened/leaf'd | the same node |

Arguments: `n` = tag name, `ns` = namespace **prefix** (literal `f`, `l`, `core`,
`mvc` — omitted for the default `sap.m` namespace).

**Attributes go through `attr( n = `key` v = `value` )`**, chained right after the
control's `open`/`leaf`. `attr` always targets that control (the last-added child,
or the node itself if none yet), so it works after both `open` and `leaf`. `v` is
any string expression — a literal, a `client->_bind( … )` / `_event( … )` result,
or a `|…|` template. (An `open`/`leaf` also accepts an up-front `a = VALUE #( ( `key=value` ) … )`
string table, split on the first `=` — handy for attributes built in a loop.)

Both named XML aggregations (`<headerToolbar>`, `<layoutData>`) and controls are
just `open`/`leaf` calls — an aggregation is a nameless-namespace `open` with no
attributes, e.g. `)->open( \`headerToolbar\` )` (positional — a single named `n =`
would trip abaplint's `omit_parameter_name`).

`factory( )` returns an **empty root**. There is no implicit `<View>` — you open
the `<mvc:View>` and declare its `xmlns` namespaces yourself, exactly like any
other control:

```abap
DATA(view) = z2ui5_cl_api_xml=>factory( ).

view->open( n = `View` ns = `mvc`
    )->attr( n = `xmlns`     v = `sap.m`
    )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`
    )->attr( n = `xmlns:f`   v = `sap.f`

    )->leaf( `Slider`
        )->attr( n = `value`      v = client->_bind_edit( slider_value )
        )->attr( n = `liveChange` v = client->_event( `SLIDER_MOVED` )

    )->open( `Panel`
        )->attr( n = `width` v = client->_bind( panel_width )
        )->open( `headerToolbar`
            )->open( `Toolbar`
                )->leaf( `Title`
                    )->attr( n = `text` v = `Header`

            )->shut(
        )->shut( ).

client->view_display( view->stringify( ) ).
```

`stringify( )` renders the whole tree to the XML string handed to
`client->view_display( )` as the standalone final statement.

#### Formatting rules (strict — reviewers check these)

- **The closing paren rides with the arrow.** Never leave a `)` alone at a line
  end; carry it to the **start of the next segment** so it always reads `)->`.
  With the `attr()` chain there is no nested `VALUE`, so the whole view ends in a
  single `` ).`` (not `) ).`).
- **Indent after every `open`.** Each `open( )` shifts its children's `)->` one
  level (4 spaces) to the right; `shut( )` shifts back left. The `)->` of a
  `shut` sits at the same column as the `open` it closes.
- **A control's `attr()` lines sit one level (4 spaces) in from the control's
  own `)->` line**; align the `v =` column across them.
- **Blank lines** (attrs never count — they belong to their control):
  - **never** between consecutive `leaf`s, and **never** after a **one-liner
    `open`** (an aggregation/container with no attrs) before its first child;
  - a blank **does** separate an `open` that *has* attrs from its first child,
    and separates a new `open`/`leaf` block from the previous sibling;
  - a blank **before** every `shut`; **none** after a `shut` or between `shut`s;
  - **none** between a control and its own `attr()`s.
- Long text/binding values split with `&&` at ~255 chars max per line (§6).

#### Data binding & events

- `client->_bind( var )` — one-way bind (display); `client->_bind_edit( var )` —
  two-way bind (the value flows back into `var` on the next round-trip). Bind the
  ABAP `DATA` member, e.g. `)->attr( n = `items` v = client->_bind( t_items )`.
- Inside a bound aggregation, child properties use UI5 binding braces on the
  upper-cased field name: `)->attr( n = `text` v = `{TITLE}``.
- `client->_event( \`NAME\` )` — wire a control event (press, liveChange…) to an
  event named `NAME`. **Always** dispatch in `on_event( )` with a
  `CASE client->get( )-event.` … `WHEN \`NAME\`.` … `ENDCASE` — even for a single
  event (never an `IF check_on_event( )`). After changing bound data in an event,
  call `client->view_model_update( )` to push it back (no full redraw).
- Read event parameters (declared via `_event( … t_arg = … )`) with
  `client->get_event_arg( n )`. A **boolean** parameter (e.g. a CheckBox
  `selected`, `${$parameters>/selected}`) already arrives as `abap_bool`
  (`X` / space), **not** the string `` `true` `` — assign it straight into an
  `abap_bool` field (`flag = client->get_event_arg( 1 ).`); never test `… = \`true\``.

#### Booleans

A literal boolean is just `)->attr( n = `editable` v = `true``. **Only** when the
value comes from an ABAP boolean variable, wrap it with `as_bool( )`:
`)->attr( n = `editable` v = z2ui5_cl_api_xml=>as_bool( flag )` — a raw
`abap_false` would otherwise serialise to an empty string. Never feed
`abap_true`/`abap_false` straight into an attribute value.

#### The 1.71 rule in practice

Use **only** controls/properties available since UI5 1.71; never a deprecated
one. When a sample uses something newer, either omit that one optional property
with a one-line comment (see app 454: `showClearIcon` dropped, `" … omitted to
stay compatible with UI5 1.71`) if the sample still works without it, or — if the
sample's whole point needs the newer/deprecated control — **do not port it** and
leave it as an ❌ gap. Never silently substitute a different control.

#### Generation notes — record every caveat in the port

When the port is **not** a clean 1:1 — you improvised, dropped/downgraded
something for 1.71, replaced a controller-only behaviour, or relied on a
binding/event form you could not verify — record it as a `" NOTES (generation):`
comment block at the **top of the class `IMPLEMENTATION`** (right after
`CLASS … IMPLEMENTATION.`, before the first method), one bullet per caveat,
tagged so a reviewer can scan them:

- `LIVE-TEST:` needs checking in a running system — an unverified binding/event
  path, or uncertain rendering (e.g. app 530's `${$source>/text}` event arg).
- `IMPROVISED:` deviates from the sample — e.g. a controller-built Dialog shown
  as a `message_toast_display` instead (app 529), or an event that reads a
  client-only value replaced with a static one (app 526).
- `1.71:` a control / property / enum value newer than 1.71 was dropped or
  downgraded (app 529's `Indication06`+ states set to `None`).

Keep the block **only** when there is something to flag — omit it for a faithful
1:1 port. Still add the inline `"` comment at the exact spot of each deviation;
the NOTES block is the scannable summary of those.

#### Worked references

Three PoC ports show the full range — read them before writing a new one:

| App | Sample | Shows |
|-----|--------|-------|
| `src/01/z2ui5_cl_api_app_408` | `sap.m.Text` | static view, no data/events, `&&`-split text |
| `src/04/z2ui5_cl_api_app_416` | `sap.f.GridList` | data + two-way bind + `liveChange` event + `view_model_update` |
| `src/01/z2ui5_cl_api_app_454` | `sap.m.MultiInput` | data, bound aggregation, `core:Item`, 1.71 omission comment |

### Generation prompt

A condensed version of the recipe above, phrased as a porting task, is kept in
`README.md` (the "Generation prompt" section). **Keep the two in sync** — this
§5 is the authoritative long form.

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

## 7. Coverage & overview — always (re)generated

Three generated, never hand-edited artefacts. **Never hand-edit them — edit the
scripts.**

- **`README.md`** (between the `<!-- coverage:start/end -->` markers) — the
  per-module coverage summary.
- **`api.md`** — one flat table, the same layout as the overview app (minus its
  "start the app" link, since api.md is static). One row per UI5 demo kit sample,
  sorted module → control → sample. Columns: **Module** · **Control** (→ OpenUI5
  API) · **Sample** · **JavaScript** (↗ → OpenUI5 repo source) · **UI5 App**
  (↗ → live OpenUI5 fullscreen sample) · **ABAP** (↗ → generated class,
  `—` = not ported).
- **`src/z2ui5_cl_api_app_overview.clas.*`** — the in-system overview **app**:
  an abap2UI5 app that lists every ported app as one row of a `sap.m.Table`,
  sorted by module → control → sample. Columns:
  **Module** (text) · **Control** (link → OpenUI5 API) · **Sample** (text) ·
  **JavaScript** (↗ → OpenUI5 repo source) · **UI5 App** (↗ → live OpenUI5
  **fullscreen** sample runner) · **ABAP** (↗ → generated class on GitHub) ·
  **abap2UI5 App** (↗ → starts the app). **Every link opens in a new browser
  tab** (`target="_blank"`; the abap2UI5 App link is the `?app_start=<CLASS>`
  URL). All source links point at OpenUI5; only ABAP + the start link are local.
  The per-row URLs are built in `view_display` (the start URL needs the runtime
  system origin), the static facts come from `get_catalog`.

```bash
OPENUI5_DIR=../openui5 node scripts/generate-coverage.mjs   # README + api.md
node scripts/generate-overview.mjs                          # the overview app (src only)
```

- **Universe of samples** — every `demokit/sample/<Name>` directory in the
  OpenUI5 checkout at `$OPENUI5_DIR` (default `./openui5`).
- **Ported set** — parsed from each `src/**/*.clas.abap` port's header URL line
  `"! .../entity/<entity>/sample/<lib>.sample.<Name>`.
- A port matches a sample on `(library, Name)`.
- **Control (entity) for grouping / the demo kit link** — from each library's
  `demokit/docuindex.json` (`explored.entities[].samples[]`), with the port's
  header URL (`.../entity/<entity>/sample/...`) as fallback.
- **api.md links are external** (absolute URLs, overridable via env) and point
  at **OpenUI5** — only the ABAP column links back to this repo:
  Control → the control's OpenUI5 API reference
  (`DEMOKIT`=`https://sdk.openui5.org`/api/`<entity>`),
  JavaScript → the sample's source folder in the OpenUI5 repository
  (`OPENUI5`=`https://github.com/SAP/openui5`/tree/`OPENUI5_REF`/src/…/demokit/sample/`<Name>`),
  UI5 App → the live OpenUI5 fullscreen sample runner
  (`DEMOKIT`/resources/…/index.html?sap-ui-xx-sample-id=…&sap-ui-xx-sample-lib=…),
  ABAP → the generated `.clas.abap` (`REPO`/`REF`).

The `generate_result` workflow (`workflow_dispatch` + weekly) shallow-clones
OpenUI5, runs both scripts, stamps the `<!-- last-run -->` timestamp into
`README.md`, and opens a pull request. The overview app must stay abaplint-clean
(§6) — it lives in `src/` and is part of every CI build.

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
