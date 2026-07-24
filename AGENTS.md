# AGENTS.md — abap2UI5-api

Single source of truth for agents working on **abap2UI5-api**.

> These instructions OVERRIDE any default behavior and must be followed exactly.
> This entire project is in **English** — code, comments, commit messages, PRs.

> **Core principle — abap2UI5 is a THIN FRONTEND.** As much logic as possible
> lives in the **ABAP backend**; the frontend only renders and forwards events.
> **Never put business logic in the frontend** — no computation, unit
> conversion, thresholds, classification or validation in a frontend formatter,
> expression binding or custom JS. Compute the result in ABAP and bind the
> finished value. A *formatter* is presentation-only (a date/number format, an
> icon glyph); a value like an `ObjectNumber` `state` derived from a measure +
> thresholds **is business logic** and must be computed server-side into a model
> field, then bound directly (`state="{WEIGHT_STATE}"`). When a UI5 sample does
> such logic in its `Formatter.js`, the faithful abap2UI5 port moves it to
> `model_init` and declares the difference — a *more* correct architecture, not a
> deviation from intent. (Prompted this: `Formatter.weightState` did KG
> conversion + Success/Warning/Error thresholds in the frontend — moved to ABAP
> `WEIGHT_STATE` in apps 009/010/022/092, 2026-07-22.)

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

**Batch planning is breadth-first.** The mission is gap discovery, and the
gap yield of a port drops sharply once its control is covered — many samples
are near-duplicates on the same control. So: port **one sample per
uncovered control first**; only when every in-scope control has at least one
port does depth (more samples per control) pay. `--backlog` encodes this:
rows are sorted `NEW-CONTROL` first (control has no port at all), then
`covered-control`; pick batches from the top. Rows marked `HOLDOUT` belong
to the hold-out set (`ui5/holdout.json`, TRAINING.md) and stay out of
regular batch planning.

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

| Folder   | CTEXT (`package.devc.xml`) | Library namespace | Status |
|----------|----------------------------|-------------------|--------|
| `src/01` | `sap.m`    | `sap.m`    | exists |
| `src/02` | `sap.ui`   | `sap.ui.*` (core, layout, unified, table, integration, model.type) | planned |
| `src/03` | `sap.uxap` | `sap.uxap` | planned |
| `src/04` | `sap.f`    | `sap.f`    | exists  |
| `src/05` | `sap.tnt`  | `sap.tnt`  | planned |

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

Ports are named `z2ui5_cl_ai_app_<n>` (lowercase). `<n>` is a stable, unique
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
cannot be verified offline — app 022 was missing its controller and table for a
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
  "class":   "z2ui5_cl_ai_app_007",
  "sample":  "sap.m.sample.CheckBoxTriState",   // join key to ui5/<lib>/<Name>/
  "entity":  "sap.m.CheckBox",
  "file":    "src/01/b02/z2ui5_cl_ai_app_007.clas.abap",
  "batch":   "b02",
  "audit":   { "frontend_action": false,        // uses _event_client? (note: which)
               "event_t_arg": true },           // passes event args via t_arg?
  "status":  "generated",                       // generated|reviewed|checked
  "checked": { "date": "2026-07-15", "note": "verified in a running system - ..." },
  "deviations": [ { "type": "IMPROVISED", "what": "..." } ]
}
```

- The generator writes the sidecar **together with** the class; overview app
  and coverage read only `meta/` (§7). `node scripts/validate-meta.mjs` checks
  schema + referential integrity (file/batch/template exist) and runs in CI.
- A human live check promotes `status` to `checked` and fills `checked`
  directly in the sidecar; `reviewed` is a manual promotion too. (There is no
  `golden` status — the category was retired 2026-07-22; former golden ports are
  plain `checked`, and any port may be refactored to the current conventions.)
- The abapGit `<DESCRIPT>` follows `<library> - <short description>`, truncated
  to 60 chars — the form `scaffold.mjs` emits (e.g. `sap.ui.unified - CurrencyInTable`).
  There is **no canonical description string offline** (`universe.json` carries
  none), so the scaffolder's `<library> - <sample name>` default is acceptable
  as-is; only improve the trailing text to a human phrase when you know one
  (e.g. `sap.m.Switch - Some say it is only a switch...`). Do not agonize over
  entity-vs-library — existing ports use both; keep the scaffolder default.
- The **control** must exist since UI5 1.71 and not be deprecated — samples
  whose control is newer or deprecated are **out of scope** (§1) and never
  enter a batch. **Members (properties/aggregations/associations/events)
  newer than 1.71 ARE kept when the original uses them — 1:1 fidelity wins**
  (policy decision 2026-07-16). Every such member must be declared with a
  `POST_171` deviation naming it (the `property_gate` enforces this via
  `ui5/properties.json`); the app then needs a UI5 release ≥ that member's
  version to render it. `DROPPED_171` remains only for the rare member that
  genuinely cannot be expressed.
  **Gate coverage — the property gate now covers ALL ported libraries**
  (`sap.m`, `sap.f`, `sap.ui.core/layout/table/unified`, `sap.uxap`, `sap.tnt`, …
  — extended 2026-07-24). `generate-properties.mjs` scans every lib's source
  **recursively** (nested controls too — `form/SimpleForm`, `cards/NumericHeader`)
  into `ui5/properties.json` (831 controls), and `property-check.mjs` resolves
  each control via the port's own `xmlns` declarations and walks the parent
  chain — so a post-1.71 member in any library is now caught automatically. The
  `generate_result` CI step clones the full OpenUI5 repo, so this holds in CI.
  You no longer need to `@since`-check by hand — but two facts about how the
  generator reads `@since` still matter if you're verifying a flag: **(a)** an
  inherited member's `@since` lives in the **parent class file** (the gate walks
  `X.extend(...)` up, e.g. `CalendarDateInterval` → `Calendar.js`); **(b)** a
  member with **no `@since` tag** is base-version (≤ 1.71). Two residual limits:
  enum *values* newer than 1.71 (e.g. `ObjectStatus` `Indication06`) are
  invisible at the attribute-name level, and a member **relocated to a newer base
  class** reads as that base's version (e.g. `NavigationListItem.expanded` shows
  1.121 though the property predates 1.71 — declare it with that note).
- **Before declaring any sample feature inexpressible, check `CAPABILITIES.md`**
  — the map of what abap2UI5 can express, each entry backed by a port that
  proves it. Never improvise around a feature it marks ✅/🔶 (app 042 replaced a
  Dialog with a toast although app 044 shows Dialogs work 1:1 via
  `popup_display`). When a port proves a new technique or disproves a ❌,
  update `CAPABILITIES.md` in the same change.
- **Every improvement idea for the abap2UI5 framework goes into `pr/`** — one
  folder per request with a self-contained, forwardable README (motivation
  with the sample/port that hit it, current behavior with source references,
  proposed change, example). Add it in the same change that discovers the
  gap; see `pr/README.md`.
- Every port must pass all three CI checks (§6).

### App skeleton — how a port is built

This is the complete recipe for turning one UI5 demo kit sample into a port.
Follow it exactly so every port looks the same and stays maintainable.

**Inputs** — the sample's original files from the OpenUI5 checkout: the
`*.view.xml` (the UI), the controller (`*.controller.js` — event handlers),
`Component.js` / `manifest.json` (which model data is loaded), plus any local
`*.json` mock data. All of these are also copied verbatim into the sample's
`ui5/<library>/<SampleName>/` folder (§4).

**Output** — one class `z2ui5_cl_ai_app_<n>` implementing `z2ui5_if_app`, whose
view is a **1:1** rebuild of the sample's XML.

#### Class layout

```abap
CLASS z2ui5_cl_ai_app_<n> DEFINITION PUBLIC.       " lowercase, not FINAL

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
    METHODS view_display.
    METHODS on_event.        " only if the app reacts to events
    METHODS model_init.      " only if the app has model data - declared LAST

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
  called from `main`**, depth-first (`view_display` → `on_event` → helpers
  right after their caller) — **except `model_init`, which always goes LAST**,
  after every other method (and is declared last in the DEFINITION too). It
  usually holds a large `VALUE #( )` block of mock data; keeping it at the
  bottom stops that data from interrupting the reading flow of the dispatcher,
  view and event methods. pattern-lint checks that main comes first and that
  model_init comes last.
- `check_on_init( )` fires once when the app starts — seed the data, draw the view.
- `check_on_event( )` fires on every user interaction — dispatch in `on_event( )`.
- Add `model_init( )` / `on_event( )` **only when the app actually has data /
  events** — never a pass-through method with a single statement. A static app
  (like app 051) has just `view_display( )` under `check_on_init( )`. A
  **data-less-but-stateful** app (its only "model" is one or two control-state
  flags a button toggles, e.g. `expanded`) seeds those flags **inline in `main`**
  (or `view_display`), no `model_init` — the single-statement-method rule wins
  (app 128 precedent).
- **A scalar literal → two-way binding is faithful, not a structural difference.**
  Turning `expanded="false"` into `expanded="{/EXPANDED}"` to reproduce a
  controller's imperative `setExpanded` is the idiomatic thin-frontend move;
  `structural-diff` does **not** flag it (it compares control/attr presence, and
  binding *values* only where the original itself binds). Declare a `LIVE_TEST`
  only because the round-trip *behaviour* is unverified, not because the diff
  requires it (app 128/172 precedent).
- If the sample re-displays on navigation, add an
  `ELSEIF client->check_on_navigated( ). view_display( ).` branch.

#### `model_init` — the model

The sample's JSON model becomes ABAP: one `ty_s_`/`ty_t_` type per JSON array,
filled with `VALUE #( ( … ) ( … ) )`. Field names are the JSON keys, upper-cased
by ABAP; bindings reference them in braces (`{TITLE}`, `{PRODUCT_ID}`). **A
camelCase key mirrors verbatim — do not insert underscores**: `SupplierName` →
field `suppliername`, binding `{SUPPLIERNAME}` (never `SUPPLIER_NAME`);
structural-diff case-normalizes but an inserted underscore would not match. Keep the
data verbatim from the sample — **the full row set, no subsetting**: inline every
row of the referenced mock array (e.g. all 123 `/ProductCollection` rows of
`ui5/mock/products.json`), byte-identical to the mock (`SUBSET_DATA` is no longer
an accepted deviation — user decision 2026-07-22). Where the original itself
binds a single record (`{/ProductCollection/0}`) or a precomputed stats array
(`/ProductCollectionStats/Filters`), reproduce exactly that — that is the 1:1
data, not a shortening. A packed field must carry enough `DECIMALS` for the mock
(e.g. `Price` has 2-decimal values, so `TYPE p … DECIMALS 2`).

**abap2UI5 serves a single default model — there are no named models.** A sample
that binds against a named model (`img>/products/pic1`, a separate `JSONModel`,
`sap/ui/demo/mock/*.json`) must be **flattened** into the one default model:
merge the extra model's fields into the row type, or — for pure display assets
like image URLs that are the same for every row — inline them as literals /
build them from a shared base (a non-bound `base_url` kept in `PROTECTED`, not
`PUBLIC`, so the round-trip model scan stays small).
**Deviation type for the flattening — the rule that ends the IMPROVISED/NOTE
confusion:** a **pure prefix-drop that renders identically** — same data, same
leaf name, `structural-diff` 0 diffs (`{ui>/rowMode}`→`{/ROWMODE}`,
`{img>/products/pic1}`→`{/PIC1}` with the real value) — is faithful → **`NOTE`**.
Use **`IMPROVISED`** only when the fold actually *loses or changes* something:
drops bound columns, resolves a live model statically, or substitutes values
(app 006's `img>`→static URLs). When binding a single record the original
`bindElement`s (`/SupplierCollection/0`), seed those fields at the **default-model
root** so the view's *relative* child bindings (`{SupplierName}`) resolve — and
seed the **actual mock row-0 values**, verified against the mock, not a
neighbour port (app 162/142 had copied wrong values). Worked example: app 006
(`sap.m.Carousel`, `img>` → static URLs, `IMPROVISED`); app 175 (`SimpleForm`,
supplier row-0 flatten).

**Absent JSON properties must not become empty strings.** A flat ABAP row
serializes every field on every row; where the original JSON simply omits a
property, the port sends `""` — and UI5 rejects `""` on **enum**-typed
properties (`validateProperty` throws where the original's `undefined`
picked the default) and overrides non-empty property **defaults** (e.g.
`Link.target` `_blank`). Fill the UI5 default value explicitly in the ABAP
data, or split the aggregation into per-shape templates. Found by the
2026-07-19 hold-out probe (QuickView port: `QuickViewGroupElementType`/
`AvatarShape` crashed every page).

#### `view_display` — the view via `z2ui5_cl_ai_xml`

Build the view with the generic builder **`z2ui5_cl_ai_xml`**. It translates a
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
any string expression — a literal, a `client->_bind( … )` / `_event( … )` result,
or a `|…|` template. (An `open`/`leaf` also accepts an up-front `a = VALUE #( ( `key=value` ) … )`
string table, split on the first `=` — handy for attributes built in a loop.)

Both named XML aggregations (`<headerToolbar>`, `<layoutData>`) and controls are
just `open`/`leaf` calls — an aggregation is a nameless-namespace `open` with no
attributes, e.g. `)->open( \`headerToolbar\` )` (positional — a single named `n =`
would trip abaplint's `omit_parameter_name`).

**An aggregation carries the same `ns=` as the tag has in the XML** — which is
its parent control's namespace, not the default one. `<m:content>` under an
`sap.m.Page` is `)->open( n = \`content\` ns = \`m\` )`; but a default-namespace
aggregation like `<columns>` / `<template>` / `<footer>` inside an
`sap.ui.table.Table` (whose view default `xmlns` is `sap.ui.table`) is the
nameless `)->open( \`columns\` )`. Copy the prefix from the original tag; a
wrong or missing `ns` on an aggregation produces an unknown-aggregation node
that `render_smoke` rejects. (Worked example: app 164, `sap.ui.table` RowModes —
`m:content`/`m:OverflowToolbar` prefixed, `columns`/`extension`/`footer`/`template`
bare.)

`factory( )` returns an **empty root**. There is no implicit `<View>` — you open
the `<mvc:View>` and declare its `xmlns` namespaces yourself, exactly like any
other control:

```abap
DATA(view) = z2ui5_cl_ai_xml=>factory( ).

view->open( n = `View` ns = `mvc`
    )->a( n = `xmlns`     v = `sap.m`
    )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
    )->a( n = `xmlns:f`   v = `sap.f`

    )->leaf( `Slider`
        )->a( n = `value`      v = client->_bind( slider_value )
        )->a( n = `liveChange` v = client->_event( `SLIDER_MOVED` )

    )->open( `Panel`
        )->a( n = `width` v = client->_bind( panel_width )
        )->open( `headerToolbar`
            )->open( `Toolbar`
                )->leaf( `Title`
                    )->a( n = `text` v = `Header`

            )->shut(
        )->shut( ).

client->view_display( view->stringify( ) ).
```

`stringify( )` renders the whole tree to the XML string handed to
`client->view_display( )` as the standalone final statement. **It renders from
the root, so every tag is closed structurally — trailing `shut( )`s before the
final `).` are optional.** `shut( )` only moves the *cursor* up to add a sibling
at a higher level; once the last leaf/attr is placed you can end the chain with a
bare `).` (the still-open View/Panel/… nodes all close in the output). Both
styles pass every gate — a chain that closes back to the root explicitly, or one
that stops at the deepest node.

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

- **A binding path always comes from a binding method — never hard-code it as
  text.** `client->_bind( var )` (and `client->_bind( val = var path = abap_true )`
  for the raw path) derives the model path *from the ABAP variable*, so renaming
  the variable moves the binding with it. Writing the path literally instead
  (`'/T_ITEMS'`, `` `{/T_ITEMS}` ``, `items = '{/T_ITEMS}'`, `path: '/T_ITEMS'`)
  silently breaks on the next rename and is not allowed. This holds **everywhere a
  method can produce the path**: the aggregation / model-root path
  (`_bind( … path = abap_true )`), a slot element binding
  (`follow_up_action( val = cs_event-bind_element … t_arg = VALUE #( ( idx ) ( client->_bind( tab ) ) ) )`
  — pass `client->_bind( tab )`, never the text path), a `binding_call` target, etc.
  The overview's **Audit** column carries a `literal binding` badge that flags ports
  still writing a binding by name. The **one unavoidable exception** is a *relative
  child property* inside a bound aggregation template — `` `{TITLE}` `` /
  `` `{PRODUCT_ID}` `` referencing an upper-cased model field, which has no `_bind`
  form (see the next bullet); keep those, but never write the absolute / model-root
  path by hand.
- **A `path:` inside a raw binding-info string uses the ABAP (upper-cased) field
  name too** — same rule as the brace form, easy to miss. A typed/sorter/Currency
  binding copied from the original keeps its *structure* 1:1 but its `path:` must
  switch to the model field: original `` `{path:'exchangeRate', type:'sap.ui.model.type.Float'}` ``
  → `` \|\{ path: 'EXCHANGE_RATE', type: 'sap.ui.model.type.Float' \}\| ``. Copying
  the original camelCase `path:'exchangeRate'` verbatim renders nothing (no such
  model field) and no gate catches it — structural-diff normalizes case, render-smoke
  mocks the model. Found by the app-171 cold-read probe (2026-07-24).
- `client->_bind( var )` — bind an ABAP `DATA` member two-way (the value
  flows back into `var` on the next round-trip), e.g.
  `)->a( n = `items` v = client->_bind( t_items )`. **`client->_bind_edit( )`
  is obsolete — `_bind` is two-way; always use `_bind`, including for
  display-only bindings.**
- Inside a bound aggregation, child properties use UI5 binding braces on the
  upper-cased field name: `)->a( n = `text` v = `{TITLE}``.
- `client->_event( \`NAME\` )` — wire a control event (press, liveChange…) to an
  event named `NAME`. **Always** dispatch in `on_event( )` with a
  `CASE client->get( )-event.` … `WHEN \`NAME\`.` … `ENDCASE` — even for a single
  event (never an `IF check_on_event( )`). After changing bound data in an event,
  call `client->view_model_update( )` to push it back (no full redraw).
- **Client handle strings (`_event`, `_bind`, `_event_client`, …) are
  written inline at each control — never captured in a variable**, even when
  the same call repeats on many controls and even inside expression bindings
  (human decision 2026-07-17, apps 005/053/007; pattern-lint blocks
  `DATA(x) = client->_…(`).
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
  event object: `` `$event.oSource.sId` `` (the pressed control's id — app 005),
  `` `${$source>/text}` `` (a bound property of the event source — app 003),
  `` `$event.mParameters.selectedItems` `` (app 022).
- **Don't fake a value you can actually read from the event.** When the original
  controller reads something off the event/source (`evt.getSource().getId()`,
  `evt.getParameter(...)`), transport it with the `$event.…` arg above and read
  it back with `get_event_arg( )` — do **not** substitute a static placeholder.
  App 005 originally toasted a hard-coded `` `Button Pressed` `` on the wrong
  assumption that the client-side control id could not reach the backend; it can,
  via `` `$event.oSource.sId` ``.
- **A property computed from several bound values → a UI5 expression binding
  `{= … }`.** Write every `client->_bind( … )` call inline, embedded with
  `${ … }` — the never-capture rule above applies inside expression bindings
  too (repeated calls to `_bind` on the same variable return the same handle).
  Build the expression with an ABAP string template, escaping the UI5 braces
  and any pipes: e.g. a "select all"/"partially selected" pair —
  `` v = |\{= ${ client->_bind( child1 ) } \|\| ${ client->_bind( child2 ) } \|\| ${ client->_bind( child3 ) } \}| `` (OR)
  and `` v = |\{= !(${ client->_bind( child1 ) } && ${ client->_bind( child2 ) } && ${ client->_bind( child3 ) })\}| ``
  (NOT-AND). Worked example: app 007 (`sap.m.CheckBox` tri-state parent). Do the
  logic in the binding, not by round-tripping — no event needed to keep the
  parent box in sync.

#### Booleans

A literal boolean is just `)->a( n = `editable` v = `true``. **Only** when the
value comes from an ABAP boolean variable, wrap it with `as_bool( )`:
`)->a( n = `editable` v = z2ui5_cl_ai_xml=>as_bool( flag )` — a raw
`abap_false` would otherwise serialise to an empty string. Never feed
`abap_true`/`abap_false` straight into an attribute value.

#### The 1.71 rule in practice

Use **only** controls/properties available since UI5 1.71; never a deprecated
one. When a sample uses something newer, either omit that one optional property
with a one-line comment (see app 040: `showClearIcon` dropped, `" … omitted to
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
  binding/event path, or uncertain rendering (e.g. app 003's `${$source>/text}`
  event arg).
- `IMPROVISED` — **materially deviates** from the sample: the port loses or
  changes something. A named model flattened to **static values** (app 006's
  `img>`→hardcoded URLs), a MessageManager replaced by a hardcoded message table
  (app 038), a fold that **drops bound columns** or resolves a live model
  statically. Only improvise what `CAPABILITIES.md` does not mark expressible —
  app 042's Dialog→toast substitution was a wrong improvisation; app 044 shows
  the 1:1 way (`popup_display`).
- `DROPPED_171` — a control / property / enum value newer than 1.71 was
  dropped or downgraded (app 042's `Indication06`+ states set to `None`).
- `SUBSET_DATA` — **retired (2026-07-22): no longer accepted.** Ports inline the
  full mock row set (see `model_init` above); `validate-meta` now rejects this
  type. Kept in the vocabulary only so historical diffs stay readable.
- `NOTE` — a faithful port with a caveat worth recording but **no loss**. This
  is the type for a **pure named-model prefix-drop that renders identically** —
  same data, same leaf name, `structural-diff` 0 diffs (`{ui>/rowMode}`→`{/ROWMODE}`,
  `{img>/pic1}`→`{/PIC1}` with the real value); the model layer differs, the
  output does not, so it is not IMPROVISED. Also: a deterministic-date
  substitution, a device-branch simplification, anything else worth flagging.
  **Settled policy (2026-07-24):** NOTE for a same-data prefix-drop, IMPROVISED
  only for a lossy/static fold — this ends the earlier IMPROVISED/NOTE
  inconsistency the cold-read probes kept hitting.

The `what` text carries the full explanation. Keep the array **empty** for a
faithful 1:1 port. Still add the inline `"` comment at the exact spot of each
deviation in the ABAP code; the sidecar is the scannable summary of those —
the structural diff (§6) matches undeclared view differences against exactly
these entries.

#### Idiom cheat-sheet — the recurring hard cases

The idioms that cause the most first-try mistakes, each as the exact ABAP to
write. This is an index into the long-form rules above and in `CAPABILITIES.md`
(named there) — scan it before porting; when in doubt read the referenced row.
Braces `{ }` inside a `|…|` template are **always** escaped `\{ \}` (an
unescaped `{` is read as a binding by the XMLView parser and crashes view
creation).

| In the original you see… | Write in the port | Detail |
|---|---|---|
| A **named model** binding `{ui>/rowMode}`, `{img>/x}`, any `name>/…` | Drop the prefix, bind the field on the **one default model**: `client->_bind( rowmode )` → `{/ROWMODE}`. structural-diff matches on the last path segment | CAPABILITIES "Named JSON models"; apps 162/163/164 |
| A **typed / complex binding** `{path:'Q', type:'sap.ui.model.type.Integer'}` | Raw binding-info string, braces escaped: `` v = \|\{ path: 'Q', type: 'sap.ui.model.type.Integer' \}\| `` — passes through to `XMLView.create` unmangled. The `path:` uses the **upper-cased ABAP field name** (`'Q'`→`'PRICE'`), not the original camelCase — no gate catches a stale path | CAPABILITIES "composite … types"; apps 164/129/033/171 |
| A **nested single object** binding `{transactionAmount/size}` (control property → a sub-object, not an array) | Nested ABAP **structure** component in the row type; bind the relative sub-path `{TRANSACTION_AMOUNT/SIZE}`. Keep the nesting — do **not** flatten to `{OBJ_FIELD}` | CAPABILITIES "Nested single object"; app 171 |
| A **`sorter` / `sorter group:true`** on an aggregation | Keep the raw string; get the bare path via `client->_bind( val = t path = abap_true )`: `` \|\{ path: '{ … }', sorter: \{ path: 'COL', group: true \} \}\| `` | CAPABILITIES "Binding sorter"; app 039 |
| A **date-object** property (`CalendarAppointment.startDate`, `PlanningCalendar.startDate`, `DatePicker.dateValue`) | Formatter at point of use: `` \|\{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' \}\| `` + `core:require="\{Formatter: 'z2ui5/model/formatter'\}"` (POST_171). A plain string binding **crashes** | CAPABILITIES "Date-object"; apps 108/109 |
| A **boolean** attribute fed from an ABAP variable | `z2ui5_cl_ai_xml=>as_bool( flag )` (a literal is just `` v = \`true\` ``) — never feed `abap_true`/`abap_false` raw | §5 "Booleans"; app 007 |
| A property **computed from several bound values** | UI5 expression binding, `_bind` inlined: `` \|\{= ${ client->_bind( a ) } && ${ client->_bind( b ) } \}\| `` — no event round-trip | §5; app 007 |
| The controller **reads an event/source value** (`evt.getSource().getId()`) | Transport it, don't fake it: `t_arg` value `$event.oSource.sId` / `${COL}`, read back with `get_event_arg( )`. A bare `{COL}` is **not** resolved here | §5 "Data binding & events"; app 005 |
| `MessageToast.show("…" + evt.x)` (text built on the client) | Client-composed template, roundtrip-free. Exact `t_arg` tuple order = **object, method, template, arg(s)**: `` client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( \`MESSAGE_TOAST\` ) ( \`show\` ) ( \`Item selected: {0}\` ) ( \`${$parameters>/item}.getText()\` ) ) ) ``. The wire token is `MESSAGE_TOAST` (not `MessageToast`); `{0}` is filled by the resolved arg | CAPABILITIES; apps 005/060/172 |
| Custom **CSS / raw markup** (`style.css`, `<h2>`, a `core:HTML` `content` div) | `core:HTML` leaf, markup in the `content` **attribute** (no CDATA node exists). Two traps: **(a)** write the **decoded** literal markup — the original XML carries it entity-encoded (`&lt;div&gt;`), but you write `<div>`; the builder re-escapes on stringify, so copying the entities double-escapes them. **(b)** escape literal braces `\{ \}` in a **backtick** literal `` `…\{…\}…` `` — backtick passes `\{` through to the serialized attribute; a `\|…\|` template would collapse `\{`→`{` and re-crash (the **reverse** of the typed-binding row, which *wants* real braces and so uses the pipe) | CAPABILITIES "Custom CSS"; apps 026/028, 169 |
| Controller **`.filter()`/`.sort()`** on `oList.getBinding('items')` | `cs_event-binding_call` (whitelisted methods/operators, compound filter groups since 2026-07-20) — the model stays untouched | CAPABILITIES "Controller-applied binding filter"; app 022 |
| An **imperative control method** (`open`/`close`/`toggleStyleClass`/`toDetail`/`expandToLevel`/`setHiddenInPopin`…) | `follow_up_action( val = cs_event-control_by_id t_arg = id/method/args )` — **only** the whitelisted `CONTROL_METHODS`; an unlisted method is a declared deviation + a `pr/` request, never a hopeful LIVE_TEST | CAPABILITIES "Frontend-action catalog"; §5 |
| A control-created **popup** (`new Dialog().open()`, `new PDFViewer().open()`) | Build a `core:FragmentDefinition`, show with `client->popup_display( )` / declare in `mvc:dependents` + `control_by_id`/`open` | CAPABILITIES "Popups & messages"; apps 019/044 |

Two feature classes stay **❌ — don't improvise around them, declare the
deviation**: control-returning factories (`groupHeaderFactory`, item factories)
and app-authored JS formatter functions outside the curated `model/formatter.js`
pack (business logic goes to `model_init`, per the thin-frontend principle).

#### Worked references

> **A reference shows an *idiom*, not ground truth. When a nearby port conflicts
> with this §5, `CAPABILITIES.md`, or the sample's own source/mock, the spec and
> the source win — never copy a reference's *data values* blindly.** A cold-read
> probe (app 173, 2026-07-24) found its nearest reference (app 162) had copied
> the wrong mock image id (`HT-1000` instead of the mock's `HT-7777-large`) and a
> host-relative asset URL against the `sdk.openui5.org` rule — verify each seeded
> value against the sample's actual mock, not the neighbour.

Read the 2–3 nearest ones before writing a new port. Prefer `checked` ports
(live-verified) as references — several were previously flagged `golden`
(a category retired 2026-07-22; they stay good examples, just without the label):

| App | Sample | Shows |
|-----|--------|-------|
| `src/01/b01/z2ui5_cl_ai_app_051` | `sap.m.Text` | static view, no data/events, `&&`-split text |
| `src/01/b02/z2ui5_cl_ai_app_007` | `sap.m.CheckBox` | two-way bind, expression bindings, boolean event arg (GOLDEN) |
| `src/01/b02/z2ui5_cl_ai_app_040` | `sap.m.MultiInput` | data, bound aggregation, `core:Item`, tokens, cc control `z2ui5.cc.MultiInputExt` (GOLDEN) |
| `src/01/b04/z2ui5_cl_ai_app_022` | `sap.m.FacetFilter` | compound `binding_call` filter, curated formatter module, two-way facet selection (GOLDEN) |
| `src/01/b06/z2ui5_cl_ai_app_019` | `sap.m.Dialog` | fragment-popup dialogs, roundtrip-free live-enable expression, both popup_close paths (GOLDEN) |
| `src/01/b05/z2ui5_cl_ai_app_016` | `sap.m.DatePicker` | frontend action (`openBy`/domRef), `$event.oSource.sId` anchor transport, POST_171 discipline (GOLDEN) |

### Generation prompt

A condensed version of the recipe above, phrased as a porting task, lives in
**`scripts/generation-prompt.txt`** — the single source; `generate-coverage.mjs`
splices it into `README.md` between the `<!-- prompt:start/end -->` markers
(never edit the README block by hand). When this §5 changes in substance,
update the prompt file in the same change — this §5 is the authoritative
long form.

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
`object_naming ^Z2UI5_CL_AI_`, `unused_*`, `obsolete_statement`,
`avoid_use` incl. `defaultKey` — always `WITH EMPTY KEY`, `commented_code`,
`definitions_top`, `whitespace_end`, …). The cloud/702 configs stay on the
correctness core, because the 702 config also drives `abaplint --fix` in the
downport. When adding a rule, run all three builds — a rule that fights the
generated view-chain style (e.g. `empty_line_in_statement`, `double_space`)
stays off deliberately.

Every sample must be **ABAP Cloud ready** *and* **downportable to 7.02** — there
is no `src/00` "restricted" area here (unlike abap2UI5/samples); everything must
survive all three builds. The self-contained `auto_downport.yaml` workflow
rebuilds the `702` branch on every push to `main`.

A fourth workflow, `checks`, runs three deterministic gates on every PR:

| Job | Command | Fails when |
|-----|---------|------------|
| `pattern_lint` | `node scripts/pattern-lint.mjs` | a known-bad pattern reappears (each rule encodes a distilled §10 lesson; known open findings live in the script's BASELINE and in STATUS.md) |
| `structural_diff` | `node scripts/structural-diff.mjs --strict` | a port's rendered view deviates from the original `view.xml` — control multiset, attribute names or simple **binding values** — without a declared deviation. It flags only what the port is **missing** (a control/attr the original has that the port dropped) — extra controls/attrs the port adds are never flagged. It compares the full **qualified name incl. namespace prefix**, so use the original view's prefix on controls too (not a neighbour's convention). A diff is "declared" when some deviation's `what` text **contains the missing name verbatim** — so when you replace an imperative event handler with a binding (dropping the `press`/`change` attr), name that attribute in the deviation (e.g. "…the `change`/`press` attributes are dropped") or it stays UNDECLARED |
| `structure_lint` | `node scripts/structure-lint.mjs --strict` | the builder call tree is malformed — an **aggregation nested directly inside another aggregation** (a missing `)->shut(`, e.g. `<footer>` landing inside `<columns>`), or a `shut` with no open to close. A fast static tree check that runs before `render_smoke` so this class fails in milliseconds with a precise message instead of a cryptic UI5 load error. Helper-built views (RETURNING a `z2ui5_cl_ai_xml` handle) are skipped — their open/shut pairs span methods |
| `render_smoke` | `node scripts/render-smoke.mjs --strict` (`npm run smoke`) | a port's reconstructed view fails a real headless `XMLView.create` against the OpenUI5 runtime (invalid XML, unknown control/property, strict property-type violation, broken expression binding). Helper-method-built views (a captured node handle passed into a builder-returning helper and chained out — app 049) are reconstructed by the handle-aware path (`extractDocsWithHelpers`; a handle is a stack snapshot, each helper call inlined re-anchored to its argument). A port the reconstructor still cannot rebuild must declare `"render_smoke": { "skip": true, "reason": "…" }` in its sidecar — an **undeclared** non-reconstructable port FAILS. The same declared skip also covers a **reconstructable** port whose view genuinely does not render in the static headless harness — a control whose runtime layout/resource behaviour the reconstruction cannot satisfy (`sap.f.AvatarGroup`'s overflow measurement loops with no real layout box; an `sap.ui.integration` Card needs an external manifest). Every skip is **verified against the actual render each run**: it is honoured only while the view still errors, and the moment it renders clean the declaration is **stale** and FAILS — so the skip set can never drift (a render-hostile skip can never outlive its reason). Render-hostile ports must still pass every other gate (structural-diff, abaplint, e2e) |
| `e2e_smoke` (heavy, on-demand) | `npm run e2e:build` then `npm run e2e` (`scripts/e2e-build.mjs` + `e2e-smoke.mjs`) | a port fails to run as the **real app**: it starts the transpiled abap2UI5 backend (framework + all ports via `?app_start=<class>`, needs an abap2UI5 checkout — `A2UI5_HOME`), boots each port in headless Chromium (UI5 served from the local `@openui5` packages), and fails if it does not boot+render or if a backend request 4xx/5xx or a JS exception fires. Unlike `render_smoke` (static view reconstruction) this exercises the actual backend roundtrip, Component boot and event wiring. Not in the fast gate set (multi-minute transpile + browser); run before a release or when touching the framework wire/runtime. A small `INTERACTIONS` map adds real click→assert checks (e.g. 005 press→client-composed toast) |
| `meta_valid` | `validate-meta.mjs` + regenerate overview & coverage, `git diff --exit-code -- src README.md api.md` | an invalid sidecar, or a change forgot to regenerate the overview app / coverage docs |
| `property_gate` | `node scripts/property-check.mjs` | a port uses a control member introduced after UI5 1.71 (per-member `@since` from `ui5/properties.json`) without declaring it in a `POST_171` deviation — this covers both `a( n = … )` attributes **and** event parameters consumed via `${$parameters>/<name>}` in a `t_arg`. **Covers every ported library** (2026-07-24): `properties.json` is generated recursively from all libs' sources and the check resolves each control via the port's `xmlns` map + the parent chain, so `src/02`–`src/05` members are enforced too |

**When a distilled lesson is greppable, add it as a pattern-lint rule in the
same change** — that is what makes a lesson unrepeatable rather than advisory.

**Run before every commit:**
```bash
npm ci
npx abaplint ./abaplint.jsonc          # expect 0 issues
node scripts/validate-meta.mjs         # sidecar schema + referential integrity
node scripts/pattern-lint.mjs          # expect 0 errors
node scripts/structural-diff.mjs --strict
node scripts/structure-lint.mjs --strict # builder tree well-formedness (fast)
node scripts/render-smoke.mjs --strict # headless XMLView.create per port
node scripts/property-check.mjs        # no member newer than UI5 1.71
node scripts/generate-overview.mjs     # then: git diff must stay clean
node scripts/generate-coverage.mjs     # (README/api.md must stay clean too)
```

### Developer tooling — starting a port

Two helpers remove the mechanical boilerplate (they do **not** write the view —
that is the actual porting work):

- **`npm run scaffold <sample>`** (`scripts/scaffold.mjs`) — from an OpenUI5
  demo-kit sample id/name it archives the template into `ui5/<lib>/<Name>/`,
  picks the next app number + `src/<lib>/b<nn>` batch (`--new-batch` /
  `--batch bNN`), and writes the class stub, `clas.xml`, `package.devc.xml` and
  a valid `meta/` sidecar. The stub is a TODO placeholder view: it passes
  abaplint / pattern-lint / structure-lint / render-smoke immediately, and
  `structural_diff` (correctly) fails until you rebuild the view 1:1. Needs an
  OpenUI5 checkout (`OPENUI5_SRC`, default `../fork-openui5`). `--dry-run` to
  preview.
- **`npm run json-to-abap -- <file.json> [--path k] [--fields spec] [--var v]`**
  (`scripts/json-to-abap.mjs`) — turns a JSON array (a demo mock's
  `ProductCollection` …) into an ABAP `VALUE #( … )` literal for `model_init`
  (backtick-escaping and type inference handled; also exports `rowsToAbapValue`
  / `rowsToAbapType` for reuse). The scaffolder prints the exact command when
  the sample's controller loads a JSON mock. **Type inference scans all rows**
  (not just the first): a numeric column with any decimal value is emitted as a
  **backtick string literal** (never truncated to `i`) and the tool warns on
  stderr — declare that field `TYPE p LENGTH n DECIMALS m` for a numeric control
  property (a backtick literal converts to packed), or `TYPE string` when it is
  a display-only value bound into a text template (keeps the exact decimals,
  e.g. dimensions `40.8`). Do **not** leave a decimal column as `TYPE i`.

The last two are automated by the tracked **`.githooks/pre-commit`** hook: on
every commit it regenerates the overview app + coverage docs and stages them,
so they never drift from `meta/` (which the `meta_valid` CI job enforces on
PRs). It is enabled with `git config core.hooksPath .githooks`, which
`npm ci` / `npm install` runs automatically via the `prepare` script.

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
- **`src/z2ui5_cl_ai_app_overview.clas.*`** — the in-system overview **app**:
  an abap2UI5 app that lists every ported app as one row of a `sap.m.Table`,
  sorted by module → control → sample. Columns (all plain text — links moved to
  the trailing **Open** column): **Module** · **Control** · **Since** (the UI5
  release the control appeared in) · **Sample** · **abap2UI5** (class name) ·
  **Note** (green check when live-verified; hint
  button opens the deviations popup) · **Open** (a button that opens an anchored
  popover of every link: OpenUI5 API, OpenUI5 source, live fullscreen sample,
  the generated class on GitHub, and starting the app). The **Control** name and
  the **Since** value come from `ui5/universe.json`. **Text is never coloured**;
  a deprecated control's name is struck through (via a `sap.m.FormattedText`
  `htmlText`, so the strikethrough can vary per row — a bound `class` would not,
  being applied once at parse time). All current ports are in-scope (≤ 1.71,
  non-deprecated), so none is struck today. A **Switch** in the subheader
  toggles between the table and a **module → control → sample tree**
  (`sap.m.Tree`, built in `build_tree` from the full catalog, expanded by
  default via a `numberOfExpandedLevels` binding parameter, with Expand-all /
  Collapse-all buttons in its header toolbar — client-side
  `cs_event-control_by_id` `expandToLevel`/`collapseAll`) showing the same
  samples; each tree leaf has the same jump popover as the table's **Open**
  column. Both views are bound and their `visible` is an expression binding
  over the two-way `show_tree` flag, so the toggle runs entirely on the client
  (like app 007). The **search field** filters **only the table**, on the
  client (`binding_call` `Contains` over a per-row `filter` blob via
  `_event_client` — no round-trip); the **tree is intentionally not filtered**.
  Each column header also carries client-side ascending/descending **sort**
  icons via the same `binding_call` mechanism. **Every link opens in a new browser tab**
  (`target="_blank"`). All source links point at OpenUI5; only the class +
  start links are local. The per-row URLs are built in `view_display` (the
  start URL needs the runtime system origin), the static facts come from
  `get_catalog`. Ports are numbered gap-free `z2ui5_cl_ai_app_001..NNN` in this
  same overview order; a renumber is a repo-wide rename (class token, sidecar
  `class`/`file`, and every `app NNN` doc reference) followed by a regenerate.

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

The two authoritative ABAP style references for this repo are:

- **[SAP Clean ABAP](https://github.com/SAP/styleguides/tree/main/clean-abap)**
  (`clean-abap/CleanABAP.md`) — SAP's official style guide.
- **[DSAG ABAP-Leitfaden](https://github.com/1DSAG/ABAP-Leitfaden)** (1DSAG) —
  the German-community ABAP best-practice guide.

Plus the detailed conventions in the
[abap2UI5/samples AGENTS.md](https://github.com/abap2UI5/samples/blob/main/AGENTS.md)
(§7 code conventions, §9 app lifecycle, §10 view building, §11 app structure) —
the ports share that style. When these disagree, prefer Clean ABAP, then the
DSAG Leitfaden, then the samples style. Essentials:

- **Booleans use `abap_true` / `abap_false`, never the character literals `'X'` /
  `' '`** (Clean ABAP "Use abap_true and abap_false"); build them with
  `xsdbool( )`, feed a bound view attribute through `z2ui5_cl_ai_xml=>as_bool( )`.
  The **one deliberate exception is a positional `t_arg` element** (`t_arg TYPE
  string_table`): those are wire-protocol string tokens, so the descending flag of
  a `binding_call` sort etc. may be written as the plain string `` `X` `` — though
  `( abap_true )` (implicitly `c → string` = `'X'`) is preferred where it reads as
  the boolean it is (the framework defines that arg as "abap_bool as `X`/space").

- **Always the simplest possible notation**: omit parameters that equal the
  default (`get_event_arg( )`, not `get_event_arg( 1 )`), no pass-through
  methods, no explicit forms where the implicit one reads the same.
- **Derive values from the data when the original does** — `selected =
  t_items[ 1 ]-text.` like the sample's `oMData[0].text`, never the resolved
  literal (human fix in app 003, 2026-07-17).
- **`VALUE #( )` alignment is all-or-nothing**: one field per line with every
  `=` in the same column — and after renaming a field, re-align the WHOLE
  block including the TYPES definition (human fix in app 033, 2026-07-17).
- **Inline comments stay minimal**: one line at the exact spot of a deviation;
  multi-line rationale belongs in the sidecar, not the code (human deletion
  in app 039, 2026-07-17).
- **Named view slots go through the `cs_view-*` constants, never a literal.**
  For a `control_by_id` action the view is its own `view` parameter on
  `follow_up_action` / `_event_client` (no longer a positional `t_arg` slot):
  it defaults to `cs_view-main` (omit it for a main-view control — the id then
  resolves across all open slots), and for a popup/popover control pass
  `view = client->cs_view-popup` (`-popover` / `-nested` / `-nested2`), not the
  plain string `` `POPUP` `` (pattern of app 004; app 013 fixed 2026-07-21).
  The `t_arg` is now just `id, method, params`.
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
- Build views with `z2ui5_cl_ai_xml` (see §5 — the only view builder in this
  repo); `client->view_display( view->stringify( ) )` as a standalone final
  statement.
- **ABAP Doc (`"!`) is parsed as HTML.** A raw `<…>` is read as an HTML tag, so
  never put a literal UI5 element (`<mvc:View>`) or any other `<tag>` in a `"!`
  comment — write it plain (`mvc:View element`). A `<tag>` there is flagged as an
  unsupported *and* unclosed HTML tag (was a warning on `z2ui5_cl_ai_xml`).

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
- **Literal braces in attribute values are read as a BINDING by the XMLView
  parser** — CSS/JS braces inside a `core:HTML` `content` (or any literal
  attribute value) must be escaped `\{ … \}` or view creation crashes.
  Found by render-smoke on app 028 (2026-07-18); pattern-lint rule
  `unescaped-brace-in-style-content` gates the `<style>` case.
- **Event args need the `$`-prefixed form** (`${COL}`, `$event.oSource.sId`), not
  a bare `{COL}` — see §5 "Data binding & events".
- **abap2UI5 has only one default model** — flatten any named-model binding into
  it — see §5 "`model_init` — the model".
- **`_bind( val = x path = abap_true )` returns the bare model path**
  (no braces) — use it when composing raw binding-info strings
  (`{ path: '...', sorter: ... }`); never reconstruct the path with substring
  tricks. Human-taught fix in app 039, 2026-07-16.
- **abapGit pushes from a system can carry stale generated files** — a human
  who pulled before the latest repo change and pushes back from the system
  silently reverts it (happened to the overview app's SUBSET labels,
  2026-07-16). After every human push: regenerate the overview
  (`node scripts/generate-overview.mjs`) and diff; the `meta_valid` CI job
  catches it on PRs, direct pushes need the manual regen.
- **Port classes carry no ABAP Doc header** — everything (sample, entity,
  status, checked, deviations, audit) lives in `meta/<class>.json`; edit the
  sidecar, never write `"!` lines into a port (pattern-lint blocks them, and
  `validate-meta.mjs` checks the sidecars). The old header-marker parsing in
  `generate-overview.mjs` is gone — the overview and the coverage read `meta/`.
- **UI5 2.x validates control property types strictly** — a bound value that
  serializes as a JSON string is rejected when the property is a number/boolean
  (`"100" is of type string, expected float` on `sap.m.Slider.value`, app 053).
  Type the bound ABAP field numerically (`i`/packed) or as `abap_bool`, never
  as `string`, so the model carries a real JSON number/boolean. But a
  **display-only** value with variable decimals bound into a *text template*
  (`{WIDTH} x {DEPTH}`, dimensions `40.8`) stays `TYPE string` — packed with a
  fixed `DECIMALS` would add trailing zeros (`40.80`); string keeps it exact.
- **abaplint `commented_code` can fire on an ordinary English comment** — a
  `"` view-description comment containing a `/` next to CamelCase UI5 identifiers
  (e.g. `" bound to RowSettings highlight/highlightText`) lexes like ABAP and is
  rejected as commented-out code. Reword (drop the slash, or split the
  identifiers) — found on app 174.
- **Device APIs need a secure context (HTTPS)** — geolocation and the camera
  (`z2ui5.cc.Geolocation` / `CameraPicture`) silently do nothing over plain
  HTTP; `getCurrentPosition` / `getUserMedia` fail with a secure-origin error
  (logged via `Lib.logError`). Test over HTTPS or `localhost`, not `http://`.
- **A code change to a `checked` port invalidates the check** — `checked`
  certifies the code that was live-verified, not the class name. Any
  behavioral rework of a `checked` port resets `status` to `generated`
  (keep the historical check as context inside a `LIVE_TEST` deviation) or
  restamps `checked` after a fresh live run. App 003 carried a 07-15 check
  across its 07-16 round-trip removal and showed green in the overview while
  its central interaction path was unverified (found 2026-07-19).
- **Prefer a bindable property over a frontend action / round-trip** — if a
  control exposes its state as a property (`IconTabBar.selectedKey`,
  `visible="{= … }"`, the `device>` model), bind it (two-way) instead of
  driving it imperatively. Only methods with no bindable equivalent
  (`NavContainer.to`, `focus`, `scrollToIndex`) need a frontend action.
  Compare app 088 (NavContainer + action) with the IconTabBar samples.
- **A whitelisted control method silently drops arguments beyond its
  declared kinds** — `castArgs` in `FrontendAction.js` maps over the
  `CONTROL_METHODS` kinds list, so a `to` transition name or a
  ViewSettingsDialog `open` page key never reaches the method; the call
  "works" and the behavior is quietly wrong. Verify the method's kinds in
  the framework source BEFORE wiring a parametrized call; if the sample
  needs the arg, that is a declared deviation **plus a pr/ request in the
  same change** — never a LIVE_TEST for something source-decidable
  (hold-out probe apps 609/624, 2026-07-19; pr/control-method-args).
- **POST_171 covers event *parameters* too** — a post-1.71 event parameter
  read via `${$parameters>/…}` (e.g. SearchField `searchButtonPressed`,
  since 1.114) needs its POST_171 deviation exactly like a bound member;
  `property-check.mjs` only scans `a( n = … )` attributes and cannot see
  t_arg usage (gate blind spot found 2026-07-19, STATUS backlog).
