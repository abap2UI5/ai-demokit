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

**Porting scope**: a sample is in scope when its **control exists since UI5
1.71** and is **not deprecated** in the current release (legacy-free ready) —
computed per sample from `ui5/universe.json` by `generate-coverage.mjs`
(`scopeOf`). Out-of-scope samples stay listed in `api.md` (marked `✗`) but are
never ported; `node scripts/generate-coverage.mjs --backlog` prints the
in-scope, unported samples for batch planning.

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
| `ui5/`  | The original UI5 demo kit templates (JS/XML/manifest), one folder per ported sample (§4). |

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

Inside a library folder, ports are grouped into **batch subpackages**
`src/<NN>/b<nn>/` — one folder per generation/review batch (~10 related
samples, e.g. `b01` display & navigation), each with its own
`package.devc.xml`, so every batch is a separate ABAP package in the system
and one PR in git. A port's batch is recorded in its `meta/<class>.json`
(derived from the path). New ports always go into a new batch folder, never
into a closed one — see TRAINING.md for the batch process.

Because `FOLDER_LOGIC=PREFIX`, class names never encode the folder — moving a
class between folders needs no rename.

### Class naming

Ports are named `z2ui5_cl_api_app_<n>` (lowercase). `<n>` is a stable, unique
number; it is the app's identity linking a port to its template (see §4).

---

## 4. The `ui5/` folder — original templates

Every port's source template is collected under `ui5/`. **The template folder is
named after the sample**, filed by source library:

```
ui5/<library>/<SampleName>/   ← original Component.js, *.view.xml,
                                  manifest.json, controllers, resources
```

The join key between a port (`src/`) and its template is `meta/<class>.json` →
`sample`. Only **ported** samples are archived: each generation batch copies
its samples over from the OpenUI5 checkout when the batch is generated — the
446-sample universe is not mirrored here. Templates are held verbatim — never
edited to fit ABAP; that is the generator's job. `ui5/` is the generator's
local input store; the `api.md` **Sample** column links to the sample's
source in the upstream
[OpenUI5 repository](https://github.com/SAP/openui5), not to this copy (§7).

Archive **everything** the sample's `manifest.json` lists under `sap.ui5 >
config > sample > files` (resolving `../<OtherSample>/` references), or fidelity
cannot be verified offline — app 401 was missing its controller and table for a
while. Shared demo kit mock data (`sap/ui/demo/mock/*.json`) is snapshotted once
under `ui5/mock/` (see its README for provenance); upstream it lives in the
[UI5/openui5](https://github.com/UI5/openui5) repository (the SAP/openui5 URLs
redirect) at `src/sap.ui.documentation/test/sap/ui/documentation/sdk/`.

---

## 5. Generation rules

**Port classes carry no ABAP Doc header** — the class starts directly with
`CLASS ... DEFINITION` (pattern-lint enforces this). Everything that identifies
and annotates a port lives in its sidecar **`meta/<class>.json`**, the single
source of truth:

```jsonc
{
  "class":   "z2ui5_cl_api_app_421",
  "sample":  "sap.m.sample.CheckBoxTriState",   // join key to ui5/<lib>/<Name>/
  "entity":  "sap.m.CheckBox",
  "file":    "src/01/b02/z2ui5_cl_api_app_421.clas.abap",
  "batch":   "b02",
  "audit":   "(a) frontend_action (_event_client): NO | (b) event t_arg: YES",
  "status":  "generated",                       // generated|reviewed|checked|golden
  "checked": { "date": "2026-07-15", "note": "verified in a running system - ..." },
  "deviations": [ { "type": "IMPROVISED", "what": "..." } ]
}
```

- The generator writes the sidecar **together with** the class; overview app
  and coverage read only `meta/` (§7). `node scripts/validate-meta.mjs` checks
  schema + referential integrity (file/batch/template exist) and runs in CI.
- A human live check promotes `status` to `checked` and fills `checked`
  directly in the sidecar; `reviewed`/`golden` are manual promotions too.
- The abapGit `<DESCRIPT>` follows `<entity> - <demo kit description>`
  (e.g. `sap.m.Switch - Some say it is only a switch...`), truncated to 60 chars.
- Use **only** controls and properties available since UI5 1.71; never a
  deprecated one. Samples whose **control** is newer than 1.71 or deprecated
  are **out of scope** (§1) and never enter a batch. When an in-scope sample
  merely uses a newer *optional property*, drop it with a `DROPPED_171`
  deviation.
- **Before declaring any sample feature inexpressible, check `CAPABILITIES.md`**
  — the map of what abap2UI5 can express, each entry backed by a port that
  proves it. Never improvise around a feature it marks ✅/🔶 (app 529 replaced a
  Dialog with a toast although app 469 shows Dialogs work 1:1 via
  `popup_display`). When a port proves a new technique or disproves a ❌,
  update `CAPABILITIES.md` in the same change.
- Every port must pass all three CI checks (§6).

### App skeleton — how a port is built

This is the complete recipe for turning one UI5 demo kit sample into a port.
Follow it exactly so every port looks the same and stays maintainable.

**Inputs** — the sample's original files from the OpenUI5 checkout: the
`*.view.xml` (the UI), the controller (`*.controller.js` — event handlers),
`Component.js` / `manifest.json` (which model data is loaded), plus any local
`*.json` mock data. All of these are also copied verbatim into the sample's
`ui5/<library>/<SampleName>/` folder (§4).

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
    METHODS model_init.       " only if the app has model data
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
    model_init( ).
    view_display( ).
  ELSEIF client->check_on_event( ).
    on_event( ).
  ENDIF.

ENDMETHOD.
```

- **Method order in the implementation**: `z2ui5_if_app~main` is always the
  **first** method; the remaining methods follow **in the order they are
  called from `main`**, depth-first (`model_init` → `view_display` →
  `on_event` → helpers right after their caller). pattern-lint checks that
  main comes first.
- `check_on_init( )` fires once when the app starts — seed the data, draw the view.
- `check_on_event( )` fires on every user interaction — dispatch in `on_event( )`.
- Add `model_init( )` / `on_event( )` **only when the app actually has data /
  events** — never a pass-through method with a single statement. A static app
  (like app 408) has just `view_display( )` under `check_on_init( )`.
- If the sample re-displays on navigation, add an
  `ELSEIF client->check_on_navigated( ). view_display( ).` branch.

#### `model_init` — the model

The sample's JSON model becomes ABAP: one `ty_s_`/`ty_t_` type per JSON array,
filled with `VALUE #( ( … ) ( … ) )`. Field names are the JSON keys, upper-cased
by ABAP; bindings reference them in braces (`{TITLE}`, `{PRODUCT_ID}`). Keep the
data verbatim from the sample (same rows, same text); a row subset needs an
IMPROVISED note (checkable against `ui5/mock/`). See app 454.

**abap2UI5 serves a single default model — there are no named models.** A sample
that binds against a named model (`img>/products/pic1`, a separate `JSONModel`,
`sap/ui/demo/mock/*.json`) must be **flattened** into the one default model:
merge the extra model's fields into the row type, or — for pure display assets
like image URLs that are the same for every row — inline them as literals /
build them from a shared base (a non-bound `base_url` kept in `PROTECTED`, not
`PUBLIC`, so the round-trip model scan stays small). Record the flattening as an
`IMPROVISED:` note. Worked example: app 420 (`sap.m.Carousel`, `img>` model →
static image URLs).

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
| `a( n v )` | one `name="value"` | add an attribute to the control just opened/leaf'd | the same node |

Arguments: `n` = tag name, `ns` = namespace **prefix** (literal `f`, `l`, `core`,
`mvc` — omitted for the default `sap.m` namespace).

**Attributes go through `a( n = `key` v = `value` )`**, chained right after the
control's `open`/`leaf`. `a` always targets that control (the last-added child,
or the node itself if none yet), so it works after both `open` and `leaf`. `v` is
any string expression — a literal, a `client->_bind_edit( … )` / `_event( … )` result,
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
    )->a( n = `xmlns`     v = `sap.m`
    )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
    )->a( n = `xmlns:f`   v = `sap.f`

    )->leaf( `Slider`
        )->a( n = `value`      v = client->_bind_edit( slider_value )
        )->a( n = `liveChange` v = client->_event( `SLIDER_MOVED` )

    )->open( `Panel`
        )->a( n = `width` v = client->_bind_edit( panel_width )
        )->open( `headerToolbar`
            )->open( `Toolbar`
                )->leaf( `Title`
                    )->a( n = `text` v = `Header`

            )->shut(
        )->shut( ).

client->view_display( view->stringify( ) ).
```

`stringify( )` renders the whole tree to the XML string handed to
`client->view_display( )` as the standalone final statement.

#### Formatting rules (strict — reviewers check these)

- **The closing paren rides with the arrow.** Never leave a `)` alone at a line
  end; carry it to the **start of the next segment** so it always reads `)->`.
  With the `a()` chain there is no nested `VALUE`, so the whole view ends in a
  single `` ).`` (not `) ).`).
- **Indent after every `open`.** Each `open( )` shifts its children's `)->` one
  level (4 spaces) to the right; `shut( )` shifts back left. The `)->` of a
  `shut` sits at the same column as the `open` it closes.
- **A control's `a()` lines sit one level (4 spaces) in from the control's
  own `)->` line**; align the `v =` column across them.
- **Blank lines** (attrs never count — they belong to their control):
  - **never** between consecutive `leaf`s, and **never** after a **one-liner
    `open`** (an aggregation/container with no attrs) before its first child;
  - a blank **does** separate an `open` that *has* attrs from its first child,
    and separates a new `open`/`leaf` block from the previous sibling;
  - a blank **before** every `shut`; **none** after a `shut` or between `shut`s;
  - **none** between a control and its own `a()`s.
- Long text/binding values split with `&&` at ~255 chars max per line (§6).

#### Data binding & events

- `client->_bind_edit( var )` — bind an ABAP `DATA` member two-way (the value
  flows back into `var` on the next round-trip), e.g.
  `)->a( n = `items` v = client->_bind_edit( t_items )`. **`client->_bind( )`
  (one-way) is obsolete — always use `_bind_edit`, even for display-only
  bindings.**
- Inside a bound aggregation, child properties use UI5 binding braces on the
  upper-cased field name: `)->a( n = `text` v = `{TITLE}``.
- `client->_event( \`NAME\` )` — wire a control event (press, liveChange…) to an
  event named `NAME`. **Always** dispatch in `on_event( )` with a
  `CASE client->get( )-event.` … `WHEN \`NAME\`.` … `ENDCASE` — even for a single
  event (never an `IF check_on_event( )`). After changing bound data in an event,
  call `client->view_model_update( )` to push it back (no full redraw).
- Read event parameters (declared via `_event( … t_arg = … )`) with
  `client->get_event_arg( )` — the index defaults to 1; **write it only for
  position 2+** (`get_event_arg( 2 )`), never `get_event_arg( 1 )`
  (pattern-lint flags it). A **boolean** parameter (e.g. a CheckBox
  `selected`, `${$parameters>/selected}`) already arrives as `abap_bool`
  (`X` / space), **not** the string `` `true` `` — assign it straight into an
  `abap_bool` field (`flag = client->get_event_arg( ).`); never test `… = \`true\``.
- **Passing a value *into* an event uses the `$`-prefixed form — never a bare
  `{…}`.** The runtime (`z2ui5_cl_core_srv_event=>get_t_arg`) sends every
  `t_arg` entry that starts with `$` or `{` to the frontend **verbatim** and
  wraps everything else in quotes as a string literal. Only a **`$`-prefixed**
  arg is then resolved by UI5 (against the row's binding context / the event
  object) before the round-trip; a bare-brace `{…}` is *not* resolved and the
  value reaches `get_event_arg( )` empty. So the same model column that is a
  correct **property** binding as `` `{NOTES}` `` in an attribute
  (`)->a( n = \`tooltip\` v = \`{NOTES}\``) must be written `` `${NOTES}` `` in a
  `t_arg` (`t_arg = VALUE #( ( \`${NOTES}\` ) )`). This exact confusion was the
  overview-app bug (`{NOTES}` → `${NOTES}`) — the property-binding brace form
  was wrongly reused as an event arg. The same `$`-prefix rule covers the UI5
  event object: `` `$event.oSource.sId` `` (the pressed control's id — app 526),
  `` `${$source>/text}` `` (a bound property of the event source — app 530),
  `` `$event.mParameters.selectedItems` `` (app 401).
- **Don't fake a value you can actually read from the event.** When the original
  controller reads something off the event/source (`evt.getSource().getId()`,
  `evt.getParameter(...)`), transport it with the `$event.…` arg above and read
  it back with `get_event_arg( )` — do **not** substitute a static placeholder.
  App 526 originally toasted a hard-coded `` `Button Pressed` `` on the wrong
  assumption that the client-side control id could not reach the backend; it can,
  via `` `$event.oSource.sId` ``.
- **A property computed from several bound values → a UI5 expression binding
  `{= … }`.** Capture each bind handle once
  (`DATA(child1_bind) = client->_bind_edit( child1 ).`), reuse it both as a plain
  binding (`v = child1_bind`) and inside the expression, embedding every handle
  with `${ … }`. Build the expression with an ABAP string template, escaping the
  UI5 braces and any pipes: e.g. a "select all"/"partially selected" pair —
  `` v = |\{= ${ child1_bind } \|\| ${ child2_bind } \|\| ${ child3_bind } \}| `` (OR)
  and `` v = |\{= !(${ child1_bind } && ${ child2_bind } && ${ child3_bind })\}| ``
  (NOT-AND). Worked example: app 421 (`sap.m.CheckBox` tri-state parent). Do the
  logic in the binding, not by round-tripping — no event needed to keep the
  parent box in sync.

#### Booleans

A literal boolean is just `)->a( n = `editable` v = `true``. **Only** when the
value comes from an ABAP boolean variable, wrap it with `as_bool( )`:
`)->a( n = `editable` v = z2ui5_cl_api_xml=>as_bool( flag )` — a raw
`abap_false` would otherwise serialise to an empty string. Never feed
`abap_true`/`abap_false` straight into an attribute value.

#### The 1.71 rule in practice

Use **only** controls/properties available since UI5 1.71; never a deprecated
one. When a sample uses something newer, either omit that one optional property
with a one-line comment (see app 454: `showClearIcon` dropped, `" … omitted to
stay compatible with UI5 1.71`) if the sample still works without it, or — if the
sample's whole point needs the newer/deprecated control — **do not port it** and
leave it as an ❌ gap. Never silently substitute a different control.

#### Generation notes — record every caveat in the sidecar

When the port is **not** a clean 1:1 — you improvised, dropped/downgraded
something for 1.71, replaced a controller-only behaviour, or relied on a
binding/event form you could not verify — record it as an entry in the
`deviations` array of `meta/<class>.json` (§5 intro). One entry per caveat,
with a closed `type` vocabulary so deviations stay countable:

- `LIVE_TEST` — needs checking in a running system: an unverified
  binding/event path, or uncertain rendering (e.g. app 530's `${$source>/text}`
  event arg).
- `IMPROVISED` — deviates from the sample: e.g. a named model flattened to
  static values (app 420), or a MessageManager replaced by a hardcoded message
  table (app 449). Only improvise what `CAPABILITIES.md` does not mark
  expressible — app 529's Dialog→toast substitution was a wrong improvisation;
  app 469 shows the 1:1 way (`popup_display`).
- `DROPPED_171` — a control / property / enum value newer than 1.71 was
  dropped or downgraded (app 529's `Indication06`+ states set to `None`).
- `SUBSET_DATA` — the port binds a row subset of the sample's mock data
  (checkable against `ui5/mock/`).
- `NOTE` — anything else worth flagging.

The `what` text carries the full explanation. Keep the array **empty** for a
faithful 1:1 port. Still add the inline `"` comment at the exact spot of each
deviation in the ABAP code; the sidecar is the scannable summary of those —
the structural diff (§6) matches undeclared view differences against exactly
these entries.

#### Worked references

Three PoC ports show the full range — read them before writing a new one:

| App | Sample | Shows |
|-----|--------|-------|
| `src/01/b01/z2ui5_cl_api_app_408` | `sap.m.Text` | static view, no data/events, `&&`-split text |
| `src/01/b02/z2ui5_cl_api_app_421` | `sap.m.CheckBox` | two-way bind, expression bindings, boolean event arg (CHECKED in-system) |
| `src/01/b02/z2ui5_cl_api_app_454` | `sap.m.MultiInput` | data, bound aggregation, `core:Item`, tokens, NOTES block |

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

The **root** `abaplint.jsonc` carries the full curated rule set (correctness +
style aligned with §8: `keyword_case`, `types_naming ^TY_`,
`object_naming ^Z2UI5_CL_API_`, `unused_*`, `obsolete_statement`,
`avoid_use` incl. `defaultKey` — always `WITH EMPTY KEY`, `commented_code`,
`definitions_top`, `whitespace_end`, …). The cloud/702 configs stay on the
correctness core, because the 702 config also drives `abaplint --fix` in the
downport. When adding a rule, run all three builds — a rule that fights the
generated view-chain style (e.g. `empty_line_in_statement`, `double_space`)
stays off deliberately.

Every sample must be **ABAP Cloud ready** *and* **downportable to 7.02** — there
is no `src/00` "restricted" area here (unlike abap2UI5/samples); everything must
survive all three builds. The `auto_cloud` / `auto_downport` workflows rebuild
the `cloud` / `702` branches via `auto_branch.yaml`.

A fourth workflow, `checks`, runs three deterministic gates on every PR:

| Job | Command | Fails when |
|-----|---------|------------|
| `pattern_lint` | `node scripts/pattern-lint.mjs` | a known-bad pattern reappears (each rule encodes a distilled §10 lesson; known open findings live in the script's BASELINE and in STATUS.md) |
| `structural_diff` | `node scripts/structural-diff.mjs --strict` | a port's rendered view deviates from the original `view.xml` without a declared deviation |
| `generated_in_sync` | regenerate `meta/` + overview, `git diff --exit-code` | a change forgot to regenerate the generated artifacts |

**When a distilled lesson is greppable, add it as a pattern-lint rule in the
same change** — that is what makes a lesson unrepeatable rather than advisory.

**Run before every commit:**
```bash
npm ci
npx abaplint ./abaplint.jsonc          # expect 0 issues
node scripts/pattern-lint.mjs          # expect 0 errors
node scripts/structural-diff.mjs --strict
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
- **`api.md`** — ONE flat table, one row per UI5 demo kit sample, sorted
  module → control → sample. Columns: **Module** · **Control** (→ OpenUI5 API,
  ~~struck~~ when deprecated) · **Since** · **Deprecated** (deprecation version
  + replacement hint from the release's `api.json`, empty = not deprecated) ·
  **Sample** (→ OpenUI5 repo source, ↗ → live fullscreen sample) · **ABAP**
  (→ generated class, `—` = not ported; those rows are the backlog). There is
  no separate deprecated-controls section — everything sits in this table.
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
node scripts/generate-coverage.mjs          # README + api.md (offline, from ui5/universe.json)
node scripts/generate-overview.mjs          # the overview app (src only, from meta/)
node scripts/validate-meta.mjs              # sidecar schema + referential integrity
node scripts/structural-diff.mjs [--strict] # port vs original view check
node scripts/pattern-lint.mjs               # distilled-lesson gate
```

- **`validate-meta.mjs`** checks the `meta/<class>.json` sidecars — the source
  of truth for sample/entity/status/checked/deviations (§5); `meta/` sits
  outside `src/` so abapGit ignores it. See TRAINING.md.
- **`structural-diff.mjs`** compares each port's builder-emitted view structure
  (controls + attribute names) against its archived original view.xml and fails
  (`--strict`) on any difference not covered by a declared deviation — run it
  before committing a new or changed port; every hit means: fix the port or
  declare the deviation in the sidecar.

- **Universe of samples** — `ui5/universe.json`, a committed snapshot of every
  `demokit/sample/<Name>` of the focused libraries (`FOCUS_LIBS` in
  `generate-coverage.mjs`, currently `sap.m`) with entity/Since/deprecation
  from the release's `api.json`. When an OpenUI5 checkout is present
  (`$OPENUI5_DIR`), `generate-coverage.mjs` REBUILDS the snapshot from it (the
  weekly `generate_result` workflow does exactly that); offline it reads the
  snapshot, so coverage regenerates without a checkout.
- **Ported set** — the `meta/<class>.json` sidecars; a port matches a sample on
  `(library, Name)` from `meta.sample`. Ports matching no universe sample are
  reported as orphans (rename/removal upstream, or outside `FOCUS_LIBS`).
- **api.md links are external** (absolute URLs, overridable via env) and point
  at **OpenUI5** — only the ABAP column links back to this repo:
  Control → the control's OpenUI5 API reference
  (`DEMOKIT`=`https://sdk.openui5.org`/api/`<entity>`),
  Sample → the sample's source folder in the OpenUI5 repository
  (`OPENUI5`=`https://github.com/SAP/openui5`/tree/`OPENUI5_REF`/src/…/demokit/sample/`<Name>`),
  Sample ↗ → the live OpenUI5 fullscreen sample runner
  (`DEMOKIT`/resources/…/index.html?sap-ui-xx-sample-id=…&sap-ui-xx-sample-lib=…),
  ABAP → the generated `.clas.abap` (`REPO`/`REF`).

The `generate_result` workflow (`workflow_dispatch` + weekly) shallow-clones
OpenUI5, refreshes `ui5/universe.json`, regenerates coverage + overview, stamps
the `<!-- last-run -->` timestamp into `README.md`, and opens a pull request. The overview app must stay abaplint-clean
(§6) — it lives in `src/` and is part of every CI build.

---

## 8. ABAP code conventions

Follow the [SAP Clean ABAP style guide](https://github.com/SAP/styleguides/blob/main/clean-abap/CleanABAP.md)
and the detailed conventions in the
[abap2UI5/samples AGENTS.md](https://github.com/abap2UI5/samples/blob/main/AGENTS.md)
(§7 code conventions, §9 app lifecycle, §10 view building, §11 app structure) —
the ports share that style. Essentials:

- **Always the simplest possible notation**: omit parameters that equal the
  default (`get_event_arg( )`, not `get_event_arg( 1 )`), no pass-through
  methods, no explicit forms where the implicit one reads the same.
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
- Build views with `z2ui5_cl_api_xml` (see §5 — the only view builder in this
  repo); `client->view_display( view->stringify( ) )` as a standalone final
  statement.
- **ABAP Doc (`"!`) is parsed as HTML.** A raw `<…>` is read as an HTML tag, so
  never put a literal UI5 element (`<mvc:View>`) or any other `<tag>` in a `"!`
  comment — write it plain (`mvc:View element`). A `<tag>` there is flagged as an
  unsupported *and* unclosed HTML tag (was a warning on `z2ui5_cl_api_xml`).

**Run `abaplint` after every change — 0 issues before committing.**

---

## 9. Dependencies

* [abap2UI5](https://github.com/abap2UI5/abap2UI5) — the framework the ports run on.
* [OpenUI5](https://github.com/SAP/openui5) — the source of the demo kit samples.

---

## 10. Lessons learned — capture them, never repeat them

**This file is the project's memory. Whenever you discover and fix a non-obvious
mistake, write the rule back here in the same change — before you finish.** That
is the only mechanism that stops the next agent (or you, next session) from
making it again: every agent reads this file first, nothing else is guaranteed to
be read. No automation can judge what is worth recording, so this is a manual
discipline, not a background job.

What counts as worth capturing: a CI/linter rule you did not know, a framework
quirk, a wrong assumption you had to unlearn, a tool that behaved destructively.
What does not: a one-off typo, anything already stated above.

How to record it:

- Put the rule where an agent will hit it — a **step-specific** lesson goes in
  that step's section (e.g. an event-arg rule in §5 "Data binding & events"); a
  **cross-cutting** one goes in the list below or §8.
- Write the **rule**, not the war story: one line on what to do / avoid, and a
  short why. Reference the app or class where it bit us, so it can be checked.
- Keep it deduplicated — extend the existing bullet rather than adding a second.

### Known gotchas (cross-cutting)

- **`npm run downport` rewrites the working tree in place** — it runs
  `abaplint --fix` over every `src/**` file *and overwrites `abaplint.jsonc`* with
  the 702 config. Never run it on the tree you intend to commit; run it in a
  throwaway `git worktree` (or copy) and check `abap_702.jsonc` there. If you did
  run it in place, `git checkout -- .` to restore before committing.
- **ABAP Doc (`"!`) is HTML** — no raw `<tag>` (e.g. `<mvc:View>`); see §8.
- **Event args need the `$`-prefixed form** (`${COL}`, `$event.oSource.sId`), not
  a bare `{COL}` — see §5 "Data binding & events".
- **abap2UI5 has only one default model** — flatten any named-model binding into
  it — see §5 "`model_init` — the model".
- **Port classes carry no ABAP Doc header** — everything (sample, entity,
  status, checked, deviations, audit) lives in `meta/<class>.json`; edit the
  sidecar, never write `"!` lines into a port (pattern-lint blocks them, and
  `validate-meta.mjs` checks the sidecars). The old header-marker parsing in
  `generate-overview.mjs` is gone — the overview and the coverage read `meta/`.
