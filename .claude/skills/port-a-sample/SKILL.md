---
name: port-a-sample
description: The complete recipe for rebuilding a UI5 demo kit sample as an abap2UI5 port class - class skeleton, dispatcher, model_init, view building with z2ui5_cl_ui5_view_builder, formatting rules, data binding and events, booleans, the 1.71 rule in practice, deviation types. Use when writing, changing or reviewing any port class under src/.
---

# Porting recipe — how a port is built

Part of the ai-demokit rulebook: `AGENTS.md` (always read first) defines
mission, scope, layout and the sidecar contract; this guide is the
**authoritative long form of the generation recipe**. When it changes in
substance, update `scripts/generation-prompt.txt` in the same change
(AGENTS.md "Generation prompt"). For the recurring hard idioms and the worked
reference ports see the `idiom-lookup` guide next to this one.

### App skeleton — how a port is built

This is the complete recipe for turning one UI5 demo kit sample into a port.
Follow it exactly so every port looks the same and stays maintainable.

**Inputs** — the sample's original files from the OpenUI5 checkout: the
`*.view.xml` (the UI), the controller (`*.controller.js` — event handlers),
`Component.js` / `manifest.json` (which model data is loaded), plus any local
`*.json` mock data. All of these are also copied verbatim into the sample's
`ui5/<library>/<SampleName>/` folder (AGENTS.md §4).

**Output** — one class `z2ui5_cl_smpc_app_<n>` implementing `z2ui5_if_app`, whose
view is a **1:1** rebuild of the sample's XML.

#### Class layout

```abap
CLASS z2ui5_cl_smpc_app_<n> DEFINITION PUBLIC.       " lowercase, not FINAL

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
- A **fully static sample** (no data, no events — app 051's class) reduces the
  dispatcher to a bare `IF client->check_on_init( ). view_display( ). ENDIF.`
  — no `ELSEIF`, no `model_init`/`on_event` methods at all.
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
by ABAP; bindings reference them in braces (`{TITLE}`, `{PRODUCTID}`). **A
camelCase key mirrors verbatim — do not insert underscores**: `SupplierName` →
field `suppliername`, binding `{SUPPLIERNAME}` (never `SUPPLIER_NAME`) — a corpus
convention. (structural-diff would tolerate either — its `normBind` lower-cases
**and** strips underscores — so this is for consistency, not to satisfy the
gate. **The worked references 022/040 predate this convention and still use
`SUPPLIER_NAME`/`PRODUCT_ID` — do not copy their underscored field names; the
spec wins.**)
Keep the
data verbatim from the sample — **the full row set, no subsetting**: inline every
row of the referenced mock array (e.g. all 123 `/ProductCollection` rows of
`ui5/mock/products.json`), byte-identical to the mock (`SUBSET_DATA` is no longer
an accepted deviation — user decision). **Rows, not columns:** per row, inline
only the fields the view actually binds (the 040/022 practice — unbound mock
keys stay out of the row type); "full row set" never means all 20 JSON keys of
every row. Where the original itself binds a single record
(`{/ProductCollection/0}`) or a precomputed stats array
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
**Deviation type for the flattening:** a **pure prefix-drop that renders
identically** — same data, same leaf name, `structural-diff` 0 diffs
(`{ui>/rowMode}`→`{/ROWMODE}`, `{img>/products/pic1}`→`{/PIC1}` with the real
value) — is faithful → **`NOTE`**. Use **`IMPROVISED`** only when the fold
actually *loses or changes* something: drops bound columns, resolves a live
model statically, or substitutes values (app 006's `img>`→static URLs). When
binding a single record the original `bindElement`s (`/SupplierCollection/0`),
seed those fields at the **default-model root** — and then bind them
**absolutely** (`client->_bind( suppliername )`), *not* with the original's
relative `{SupplierName}`: without the element binding there is no context for
a relative path to resolve against (see the flattened-element-binding trap
below; the linter rule is `relative-binding-without-context`). Seed the
**actual mock row-0 values**,
verified against the mock, not a neighbour port (app 162/142 had copied wrong
values). Worked example: app 006 (`sap.m.Carousel`, `img>` → static URLs,
`IMPROVISED`); app 175 (`SimpleForm`, supplier row-0 flatten).

**Absent JSON properties must not become empty strings.** A flat ABAP row
serializes every field on every row; where the original JSON simply omits a
property, the port sends `""` — and UI5 rejects `""` on **enum**-typed
properties (`validateProperty` throws where the original's `undefined`
picked the default) and overrides non-empty property **defaults** (e.g.
`Link.target` `_blank`). Fill the UI5 default value explicitly in the ABAP
data, or split the aggregation into per-shape templates (the QuickView port's
`QuickViewGroupElementType`/`AvatarShape` crashed every page this way).

#### `view_display` — the view via `z2ui5_cl_ui5_view_builder`

Build the view with the generic builder **`z2ui5_cl_ui5_view_builder`**. The class lives
in abap2UI5 core (`src/02/`, migrated from this repo) and resolves through the
abap2UI5 abaplint dependency. It translates a
UI5 XML view 1:1 by method chaining — every control, property and namespace maps
directly, nothing is approximated. The navigation verbs are short so the `)->`
arrows line up:

| Verb | XML meaning | Tree action | Returns |
|------|-------------|-------------|---------|
| `ele( n ns )` | open a container tag `<X>` | add child **and descend** into it | the new child |
| `tag( n ns )` | a self-closing tag `<X/>` | add child, **stay** on current node | the same node |
| `end( )` | the closing `</X>` | **ascend** to the parent | the parent |
| `a( n v )` | one `name="value"` | add an attribute to the control just added | the same node |

Arguments: `n` = tag name, `ns` = namespace **prefix** (literal `f`, `l`, `core`,
`mvc` — omitted for the default `sap.m` namespace).

**Attributes go through `a( n = `key` v = `value` )`**, chained right after the
control's `ele`/`tag`. `a` always targets that control (the last-added child,
or the node itself if none yet), so it works after both `ele` and `tag`. `v` is
any string expression — a literal, a `client->_bind( … )` / `_event( … )` result,
or a `|…|` template. For an ABAP boolean pass `b` instead of `v` (see Booleans
below); `ele( )`/`tag( )` take `n` and `ns` only — there is no up-front
attribute table, every attribute gets its own `a( )`.

Both named XML aggregations (`<headerToolbar>`, `<layoutData>`) and controls are
just `ele`/`tag` calls — an aggregation is a nameless-namespace `ele` with no
attributes, e.g. `)->ele( \`headerToolbar\` )` (positional — a single named `n =`
would trip abaplint's `omit_parameter_name`).

**An aggregation carries the same `ns=` as the tag has in the XML** — which is
its parent control's namespace, not the default one. `<m:content>` under an
`sap.m.Page` is `)->ele( n = \`content\` ns = \`m\` )`; but a default-namespace
aggregation like `<columns>` / `<template>` / `<footer>` inside an
`sap.ui.table.Table` (whose view default `xmlns` is `sap.ui.table`) is the
nameless `)->ele( \`columns\` )`. Copy the prefix from the original tag; a
wrong or missing `ns` on an aggregation produces an unknown-aggregation node
that `render_smoke` rejects. (Worked example: app 164, `sap.ui.table` RowModes —
`m:content`/`m:OverflowToolbar` prefixed, `columns`/`extension`/`footer`/`template`
bare.)

`factory( )` returns an **empty root**. There is no implicit `<View>` — you open
the `<mvc:View>` and declare its `xmlns` namespaces yourself, exactly like any
other control:

```abap
DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

view->ele( n = `View` ns = `mvc`
    )->a( n = `xmlns`     v = `sap.m`
    )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
    )->a( n = `xmlns:f`   v = `sap.f`

    )->tag( `Slider`
        )->a( n = `value`      v = client->_bind( slider_value )
        )->a( n = `liveChange` v = client->_event( `SLIDER_MOVED` )

    )->ele( `Panel`
        )->a( n = `width` v = client->_bind( panel_width )
        )->ele( `headerToolbar`
            )->ele( `Toolbar`
                )->tag( `Title`
                    )->a( n = `text` v = `Header`

            )->end(
        )->end( ).

client->view_display( view->stringify( ) ).
```

`stringify( )` renders the whole tree to the XML string handed to
`client->view_display( )` as the standalone final statement. **It renders from
the root, so every tag is closed structurally — trailing `end( )`s before the
final `).` are optional.** `end( )` only moves the *cursor* up to add a sibling
at a higher level; once the last leaf/attr is placed you can end the chain with a
bare `).` (the still-open View/Panel/… nodes all close in the output). Both
styles pass every gate — a chain that closes back to the root explicitly, or one
that stops at the deepest node.

#### Formatting rules (strict — reviewers check these)

- **The closing paren rides with the arrow.** Never leave a `)` alone at a line
  end; carry it to the **start of the next segment** so it always reads `)->`.
  With the `a()` chain there is no nested `VALUE`, so the whole view ends in a
  single `` ).`` (not `) ).`).
- **Indent after every `ele`.** Each `ele( )` shifts its children's `)->` one
  level (4 spaces) to the right; `end( )` shifts back left. The `)->` of an
  `end` sits at the same column as the `ele` it closes.
- **A control's `a()` lines sit one level (4 spaces) in from the control's
  own `)->` line**; align the `v =` column across them.
- **Blank lines** (attrs never count — they belong to their control):
  - **never** between consecutive `tag`s, and **never** after a **one-liner
    `ele`** (an aggregation/container with no attrs) before its first child;
  - a blank **does** separate an `ele` that *has* attrs from its first child,
    and separates a new `ele`/`tag` block from the previous sibling;
  - a blank **before** every `end`; **none** after an `end` or between `end`s;
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
  `pattern-lint`'s `hardcoded-binding-path` rule flags ports still writing a
  binding by name. The **one unavoidable exception** is a *relative
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
  model field) and no gate catches it — structural-diff normalizes case,
  the render gate mocks the model (app 171).
- `client->_bind( var )` — bind an ABAP `DATA` member two-way (the value
  flows back into `var` on the next round-trip), e.g.
  `)->a( n = `items` v = client->_bind( t_items )`. **`client->_bind_edit( )`
  is obsolete — `_bind` is two-way; always use `_bind`, including for
  display-only bindings.**
- Inside a bound aggregation, child properties use UI5 binding braces on the
  upper-cased field name: `)->a( n = `text` v = `{TITLE}``.
  **But a field shared by the whole app lives at the model ROOT, and a relative
  `{FIELD}` inside a template resolves against the ROW** — it silently renders
  empty when the row has no such column. Bind those with the absolute path from
  `client->_bind( field )` even inside a template (app 207: every
  `StandardListItem`'s `type` follows one Select; the relative form left every
  item `Inactive` and the Select dead — no gate sees this, only the e2e
  interaction did).
  **The same trap outside any template: a "flattened element binding".** When
  the original does `bindElement('/ProductCollection/0')` (or a `binding=`
  attribute) and the port seeds that record's fields at the model root, the
  view must bind them **absolutely** too — a relative `{NAME}` on a control
  with *no binding context at all* resolves against nothing and renders empty.
  Seven ports carried the wrong form with a sidecar note claiming the opposite
  (142 175 195 206 209 229 243, all fixed). **That audit is static now**: the
  linter rule `relative-binding-without-context` reports a `_bind`-less
  `` v = `{FIELD}` `` on a control with no binding context whose FIELD is a
  declared class attribute (a `template` aggregation counts as a row context,
  so `sap.ui.table` column templates are not judged).
- `client->_event( \`NAME\` )` — wire a control event (press, liveChange…) to an
  event named `NAME`. **Always** dispatch in `on_event( )` with a
  `CASE client->get( )-event.` … `WHEN \`NAME\`.` … `ENDCASE` — even for a single
  event (never an `IF check_on_event( )`). After changing bound data in an event,
  call `client->view_model_update( )` to push it back (no full redraw).
- **Client handle strings (`_event`, `_bind`, `follow_up_action`, …) are
  written inline at each control — never captured in a variable**, even when
  the same call repeats on many controls and even inside expression bindings
  (human decision, apps 005/053/007; pattern-lint blocks
  `DATA(x) = client->_…(`).
- Read event parameters (declared via `_event( … t_arg = … )`) with
  `client->get_event_arg( )` — the index defaults to 1; **write it only for
  position 2+** (`get_event_arg( 2 )`), never `get_event_arg( 1 )`
  (pattern-lint flags it). A **boolean** parameter (e.g. a CheckBox
  `selected`, `${$parameters>/selected}`) already arrives as `abap_bool`
  (`X` / space), **not** the string `` `true` `` — assign it straight into an
  `abap_bool` field (`flag = client->get_event_arg( ).`); never test `… = \`true\``.
- **Passing a value *into* an event uses the `$`-prefixed form — never a bare
  `{…}`.** The runtime (`z2ui5_cl_ui5_srv_event=>get_t_arg`) sends every
  `t_arg` entry that starts with `$` or `{` to the frontend **verbatim** and
  wraps everything else in quotes as a string literal. Only a **`$`-prefixed**
  arg is then resolved by UI5 (against the row's binding context / the event
  object) before the round-trip; a bare-brace `{…}` is *not* resolved and the
  value reaches `get_event_arg( )` empty. So the same model column that is a
  correct **property** binding as `` `{NOTES}` `` in an attribute
  (`)->a( n = \`tooltip\` v = \`{NOTES}\``) must be written `` `${NOTES}` `` in a
  `t_arg` (`t_arg = VALUE #( ( \`${NOTES}\` ) )`). The same `$`-prefix rule
  covers the UI5 event object: `` `$event.oSource.sId` `` (the pressed
  control's id — app 005), `` `${$source>/text}` `` (a bound property of the
  event source — app 003), `` `$event.mParameters.selectedItems` `` (app 022).
- **Don't fake a value you can actually read from the event.** When the original
  controller reads something off the event/source (`evt.getSource().getId()`,
  `evt.getParameter(...)`), transport it with the `$event.…` arg above and read
  it back with `get_event_arg( )` — do **not** substitute a static placeholder
  (app 005's toast carries the real control id via `` `$event.oSource.sId` ``).
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
value comes from an ABAP boolean variable, pass it as `b` instead of `v`:
`)->a( n = `editable` b = flag )` — the builder renders it as `true`/`false`
itself, while a raw `abap_false` fed through `v` would serialise to an empty
string. Never feed `abap_true`/`abap_false` straight into `v`. Exactly one of
the two is passed, never both and never neither.

#### The 1.71 rule in practice

The **control** must exist since UI5 1.71 and not be deprecated — otherwise
the sample is out of scope and is never ported (pre-check with
`node scripts/scope-of.mjs <entity>`); never silently substitute a different
control. **Members** (properties/aggregations/associations/events) newer than
1.71 ARE kept when the original uses them — 1:1 fidelity wins (AGENTS §5) —
and each one is declared as a `POST_171` deviation naming the member (app 040
keeps `showClearIcon` @1.94 that way; the app then needs a UI5 release ≥ that
member's version to render it). `DROPPED_171` remains only for the rare
member that genuinely cannot be expressed.

#### Generation notes — record every caveat in the sidecar

When the port is **not** a clean 1:1 — you improvised, dropped/downgraded
something for 1.71, replaced a controller-only behaviour, or relied on a
binding/event form you could not verify — record it as an entry in the
`deviations` array of `meta/<class>.json` (the sidecar contract is AGENTS.md §5). One entry per caveat,
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
- `SUBSET_DATA` — **retired: no longer accepted.** Ports inline the full mock
  row set (see `model_init` above); `validate-meta` now rejects this type.
  Kept in the vocabulary only so historical diffs stay readable.
- `NOTE` — a faithful port with a caveat worth recording but **no loss**. This
  is the type for a **pure named-model prefix-drop that renders identically** —
  same data, same leaf name, `structural-diff` 0 diffs (`{ui>/rowMode}`→`{/ROWMODE}`,
  `{img>/pic1}`→`{/PIC1}` with the real value); the model layer differs, the
  output does not, so it is not IMPROVISED. Also: a deterministic-date
  substitution, a device-branch simplification, anything else worth flagging.
  **Settled policy:** NOTE for a same-data prefix-drop, IMPROVISED only for a
  lossy/static fold.
  **Refinement:** "renders identically" is **not** sufficient for NOTE when
  the fold **drops a control/config artifact** — a `sap.uxap:ModelMapping`
  (or its `ModelMappingBlock`), a `core:CommandExecution`, an `i18n` resource
  model. Removing a control the original declares (even a zero-visual-output
  config element) or losing a behaviour (runtime language switch, keyboard
  command) **is a loss → IMPROVISED**, regardless of pixel-identical render. The
  pure-render test decides only the *prefix-drop* case; dropping an artifact is
  lossy by definition. (Apps 230 ModelMapping, 232 CommandExecution, 233 i18n.)

The `what` text carries the full explanation. Keep the array **empty** for a
faithful 1:1 port. Still add the inline `"` comment at the exact spot of each
deviation in the ABAP code; the sidecar is the scannable summary of those —
the structural diff (§6) matches undeclared view differences against exactly
these entries.


#### Porting gotchas (distilled lessons — same discipline as AGENTS.md §10)

- **A bare decimal literal is not valid ABAP** — `price = 2.3` inside a
  `VALUE #( )` lexes as `2` · `.` · `3`, and the dot ENDS the statement, so the
  whole block becomes a parser error (and a generated 123-row block reports it
  once per row). Write the number as a character literal, `` price = `2.3` ``,
  which converts into the packed field on assignment (the app-174 style);
  integers stay bare. abaplint catches it, but only after the file is written —
  a data generator must emit it right (batch b20).
- **`DELETE itab WHERE` takes no functional expression** — `DELETE t WHERE
  to_upper( name ) NS q.` is a parser error, the `WHERE` of an internal-table
  statement accepts only comparisons of components against values. Loop
  instead: `LOOP AT t INTO DATA(row). IF … . DELETE t INDEX sy-tabix. ENDIF.
  ENDLOOP.` (apps 352/354).
- **A DOTTED element name in the original view is a sub-package, not a
  control name** — `<plugins.MultiSelectionPlugin>` under a `sap.ui.table`
  default `xmlns` (and `<m:plugins.PasteProvider>`) resolves as
  `sap.ui.table.plugins.MultiSelectionPlugin` / `sap.m.plugins.PasteProvider`.
  The builder has no such form, so declare a real prefix
  (`xmlns:tp="sap.ui.table.plugins"`) and write `tp:MultiSelectionPlugin`;
  structural-diff compares the qualified name, so name the swap in a
  deviation (app 360).

- **The default namespace is not always `sap.m`.** A `sap.uxap` / `sap.ui.table`
  sample often declares its own library as `xmlns` and gives **`sap.m` the
  prefix** (`xmlns:m="sap.m"`, `<m:List>`). Copy that assignment as-is:
  `structural-diff` compares the **qualified** control name, so a `List`
  written without `ns` in such a view is a different control from the
  original's `m:List` and is reported in both directions (app 293).

- **One builder chain per view — never split it across ABAP statements.** The
  builder keeps its cursor across statements at runtime, so
  `popover->ele( \`Popover\` … ).` followed by a separate
  `popover->ele( \`List\` … ).` *works in a system* — but the linter's
  reconstructor reads a chain as one statement and re-roots the second one, so
  the document comes out with two roots and the render gate rejects it
  ("Using native HTML content in XMLViews is deprecated"). It also removes the
  temptation behind the split: a popup helper parameterized with id/title
  (`COND #( … )` in an attribute) is unreconstructable *and* leaves
  `structural-diff` counting one popup where the original has three. Write one
  method with one chain per fragment, as the original has one file per
  fragment (app 285).

- **A per-keystroke round-trip is LOSSY, not queued.** abap2UI5 serializes
  round-trips: an event fired while one is in flight is **dropped**, so a
  `liveChange`/`liveSearch` wire that round-trips shows the value of the last
  *completed* trip, skipping intermediate ones under fast typing (measured on
  app 280 — typing `abc` with no delay left the bound field at `a` while the
  TextArea held `abc`; it converges as soon as typing pauses). Prefer a two-way
  binding or an expression binding whenever the sample's point allows it; when
  the round-trip is required, say so in the sidecar and make any e2e
  interaction **type with a delay** — a no-delay `pressSequentially` asserts a
  value the wire never promised.
- **Event args need the `$`-prefixed form** (`${COL}`, `$event.oSource.sId`), not
  a bare `{COL}` — see "Data binding & events" in this guide.
- **A UI5 *association* cannot be data-bound** — only properties and
  aggregations can, so the scalar-literal->two-way-binding move (this guide) does not
  apply to one. `sap.uxap.ObjectPageLayout.selectedSection` reads like a
  property but is declared under `associations:`; drive it through
  `follow_up_action( val = cs_event-control_by_id t_arg = ( id )
  ( \`setSelectedSection\` ) ( … ) )` instead. An **empty/null association
  argument is not transportable** either — pass the id you actually want (app
  263 resets to the first section's id, which is what UI5's own
  `_adjustSelectedSectionByUXRules` falls back to when the association is
  empty). Before binding something that "should" be a property, grep the
  control source for `associations:`.
- **abap2UI5 has only one default model** — flatten any named-model binding into
  it — see "`model_init` — the model" in this guide.
- **`_bind( val = x path = abap_true )` returns the bare model path**
  (no braces) — use it when composing raw binding-info strings
  (`{ path: '...', sorter: ... }`); never reconstruct the path with substring
  tricks (app 039).
- **An event parameter that is an ARRAY arrives as JSON, not as a joined
  string.** `${$parameters>/fieldGroupIds}` reaches `on_event` as
  `["Billing Information"]`, brackets and quotes included. Index it in the
  expression — `${$parameters>/fieldGroupIds}[0]`, which is also literally
  what the original controller does — the UI5 expression grammar accepts
  `[n]` and method calls (app 272). Do not "fix" this by string-stripping in
  ABAP.
- **UI5 2.x validates control property types strictly** — a bound value that
  serializes as a JSON string is rejected when the property is a number/boolean
  (`"100" is of type string, expected float` on `sap.m.Slider.value`, app 053).
  Type the bound ABAP field numerically (`i`/packed) or as `abap_bool`, never
  as `string`, so the model carries a real JSON number/boolean. But a
  **display-only** value with variable decimals bound into a *text template*
  (`{WIDTH} x {DEPTH}`, dimensions `40.8`) stays `TYPE string` — packed with a
  fixed `DECIMALS` would add trailing zeros (`40.80`); string keeps it exact.
- **A `client->_event( )` in the view needs an `on_event` branch that handles
  it** — otherwise the wire fires a full backend round-trip that falls through
  every `CASE` and the app does nothing, while *looking* wired (pattern-lint
  rule `dead-event-wire`: no class with `->_event(` and no
  `on_event`/`check_on_event`). Two legitimate resolutions, no third:
  **dispatch it** (a `CASE` branch that changes bound state and calls
  `view_model_update`, or a `message_box_display`/`popover_display`), or
  **drop the wire** — if the behaviour is genuinely inexpressible, the
  attribute goes away and the loss is declared. Before dropping, check
  CAPABILITIES.md: most "not reproducible" rationales in this class turned
  out to be wrong — the behaviour was expressible as a two-way binding +
  expression binding, a real dispatcher, or the full drag & drop reorder.
- **Range-check any index that arrives from the frontend before using it as a
  table index** — JS splices a nonsense index harmlessly, `t[ i ]` in ABAP
  **dumps**. A drag & drop `drop` handler receives both row indices from the
  client, so a stale or malformed value reaches `on_event` as an ordinary
  event arg. Guard with `lines( )` and return early rather than trusting the
  client (app 148).
- **An OPTIONAL date in a bound row needs a guard in the binding** — one bound
  template cannot omit an attribute per row, so a row whose date field is empty
  still goes through the formatter: `Formatter.DateCreateObject('')` is
  `new Date('')` = **Invalid Date**, which is *truthy*, so every consumer that
  branches on the property throws and the whole view dies — the app renders
  **zero** days, not a degraded one. Guard the conversion in the binding:
  ``` `{= ${END} ? Formatter.DateCreateObject(${END}) : null }` ``` in a
  **backtick** literal (a `|…|` template would eat the braces). Do **not**
  "fix" it by seeding `end = start`: `_checkDateEnabled` compares a range
  strictly exclusive and reaches its single-day branch only when there is no
  `endDate` at all, so that seeds a range disabling nothing (app 220;
  pattern-lint rule `unguarded-date-formatter`).
- **abaplint `commented_code` can fire on an ordinary English comment** — a
  `"` view-description comment containing a `/` next to CamelCase UI5 identifiers
  (e.g. `" bound to RowSettings highlight/highlightText`) lexes like ABAP and is
  rejected as commented-out code. Reword (drop the slash, or split the
  identifiers) — app 174.
- **Prefer a bindable property over a frontend action / round-trip** — if a
  control exposes its state as a property (`IconTabBar.selectedKey`,
  `visible="{= … }"`, the `device>` model), bind it (two-way) instead of
  driving it imperatively. Only methods with no bindable equivalent
  (`NavContainer.to`, `focus`, `scrollToIndex`) need a frontend action.
  Compare app 088 (NavContainer + action) with the IconTabBar samples.
- **Client-side-only state does not survive a view rebuild** — a value the
  frontend never sends back (a `SearchField` with no bound `value`) and a
  `binding_call` filter/sorter (it acts on the aggregation binding, not on the
  model) are gone the moment the backend rebuilds the view: another round-trip,
  a draft restore, the browser Back button after `nav_app_call`. Bind the value
  two-way so it travels with the next event, and re-apply the binding operation
  in `view_display` via `follow_up_action( cs_event-binding_call … )` when the
  restored value is non-initial (the overview app's search). Sort state stays
  client-only: a view-wired `follow_up_action` sort cannot write to the model, so it is
  deliberately lost.
- **A listed control method silently drops arguments beyond its
  declared kinds** — `castArgs` in `FrontendAction.js` maps over the
  `CONTROL_METHODS` kinds list, so a `to` transition name or a
  ViewSettingsDialog `open` page key never reaches the method; the call
  "works" and the behavior is quietly wrong. Verify the method's kinds in
  the framework source BEFORE wiring a parametrized call; if the sample
  needs the arg, that is a declared deviation **plus a pr/ request in the
  same change** — never a LIVE_TEST for something source-decidable
  (pr/control-method-args). An UNLISTED public method that does not match
  the deny regex runs too (plain setters/toggles) — see the cheat-sheet row.
- **POST_171 covers event *parameters* too** — a post-1.71 event parameter
  read via `${$parameters>/…}` (e.g. SearchField `searchButtonPressed`,
  since 1.114) needs its POST_171 deviation exactly like a bound member;
  the property gate enforces this (it scans `$parameters>/<name>` refs in
  `t_arg` and resolves them against the same member map as attributes, §6).
