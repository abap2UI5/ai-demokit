# CAPABILITIES.md — what abap2UI5 can express

The capability map for porting UI5 demo kit samples. **Read this before deciding
that a sample feature cannot be ported** — the most common generation mistake so
far was not wrong code but a wrong assumption about what abap2UI5 can do (a
Dialog declared "not expressible" although another port in this repo builds one;
CSS dropped although `core:HTML` can carry it). Every entry names the port that
proves it, so claims stay checkable.

Status legend: ✅ direct 1:1 · 🔶 expressible with a documented workaround ·
🧪 plausible, needs a LIVE-TEST port to confirm · ❌ not expressible today.

Verification levels in the Evidence column: **live-verified** = seen in a
running system; **source-verified** = traced in the abap2UI5 framework source
(2026-07-16 pass; clone the repos per TRAINING.md "Reference repositories") — strong enough to generate against, a
live check remains the final confirmation for rendering.

Maintenance rule (same discipline as AGENTS.md §10): whenever a port proves a
new technique, or disproves a ❌, update this table **in the same change** and
reference the port. Never declare an `IMPROVISED`/`DROPPED_171` deviation for a
feature this table marks ✅/🔶.

## Views & controls

| UI5 feature | Status | How in abap2UI5 | Evidence |
|---|---|---|---|
| Any XML view structure (containers, aggregations, namespaces) | ✅ | `z2ui5_cl_ai_xml` open/leaf/shut + `a()` | all ports |
| Aggregations filled by the controller in `onInit` (e.g. pre-set `tokens` on MultiInput) | ✅ | declare the aggregation in the view: `open( 'tokens' )` → `leaf( 'Token' )` per entry | missed in app 454 — the tokens aggregation is public since 1.16; do not skip these |
| MultiInput `addValidator` (free text + Enter → a new Token) | 🔶 | the bundled custom control `z2ui5.cc.MultiInputExt` (invisible companion referencing the MultiInput by id) installs exactly this validator — `addValidator(({text}) => new Token({key:text, text}))` — and mirrors added/removed tokens back via `addedTokens`/`removedTokens` + a `change` event. Declare `xmlns:z2ui5="z2ui5.cc"` and one `z2ui5:MultiInputExt` leaf with `MultiInputId` per input | source-verified in `app/webapp/cc/MultiInputExt.js`; app 454 wires it on both token inputs (first cc-control usage in these ports, converted 2026-07-18, LIVE-TEST pending) |
| Custom CSS (`style.css`, `html:style` blocks) | 🔶 | `core:HTML` leaf with the `content` **attribute** carrying `<style>…</style>` — the builder escapes attribute values, no CDATA node needed. **Literal CSS braces must be escaped `\{ … \}`**: the XMLView binding parser reads unescaped `{…}` in any attribute value as a binding and crashes (render-smoke proof 2026-07-18, app 431; pattern-lint gates it) | apps 404/431 inject their sample `style.css` exactly this way (escaped 2026-07-18, render-smoke green, LIVE-TEST pending); 404 also uses `content` for `<h2>…</h2>` markup |
| Composite/array properties (RangeSlider `range="[lo,hi]"`) | 🔶 | split into the scalar sibling properties the control keeps in sync (`value`/`value2`) | app 472 |
| Literal line breaks inside attribute values (`&#xA;` in the original) | ✅ | write the break as `\n` in a `\|...\|` template — `xml_escape` emits it as `&#xA;`/`&#xD;`/`&#x9;` so it survives XML attribute-value normalization | app 445 (`noDataText`); builder fix 2026-07-16 |
| Raw text / CDATA child nodes | ❌ | `z2ui5_cl_ai_xml` has element+attribute nodes only; for markup/CSS use the `core:HTML` `content` attribute (row above) | app 404 NOTES |

## Popups & messages

| UI5 feature | Status | How in abap2UI5 | Evidence |
|---|---|---|---|
| Controller-built `sap.m.Dialog` (`new Dialog({...}).open()`) | ✅ | build a `core:FragmentDefinition` → `Dialog` with the same builder, show with `client->popup_display( )`, close via `client->_event_client( client->cs_event-popup_close )` | app 529 builds its error Dialog this way (its earlier toast substitution was a wrong improvisation); app 469 used the pattern as a workaround until 2026-07-18, now 1:1 via the popup-mode PDFViewer (row below) |
| Controller-created popup-mode control opened imperatively (`new PDFViewer(...)` + `.open()` on a view dependent) | ✅ | declare the control in the view's `mvc:dependents` aggregation (the `addDependent` equivalent), bind its inputs, open it with `client->control_call_by_id( id = … method = 'open' )` after the round-trip - `open`/`close` are whitelisted since 2026-07-18 (pr/control-call-whitelist) | app 469 (LIVE-TEST pending); source-verified in `app/webapp/core/FrontendAction.js` `CONTROL_METHODS` |
| `sap.m.MessageBox` | ✅ | `client->message_box_display` (actions, initialFocus, styleClass, and now `dependentOn` + `contentWidth` supported) | app 447 |
| `sap.m.MessageToast` (incl. the options object: `my`/`at`/`of`/`offset`/`collision` docking, `duration`, `width`, `class`) | ✅ | `client->message_toast_display( text = … my = 'center center' at = 'center center' … )` — the client method exposes the full MessageToast options object; dock strings ("center center", "begin top", …) are resolved in `Messages.js` | apps 448, 526; docking proven by app 439 (source-verified in `app/webapp/core/Messages.js`) |

## Models & binding

| UI5 feature | Status | How in abap2UI5 | Evidence |
|---|---|---|---|
| JSON model data | ✅ | ABAP `VALUE #( … )` + `client->_bind_edit` (never `_bind`) — keep the data verbatim, full row set | AGENTS §5; silent row subsets bit apps 433/440/441 |
| Two-way property binding incl. live client-side updates | ✅ | shared `_bind_edit` path on both controls — no event round-trip needed | app 527 (Switch↔Select), app 530 (Breadcrumbs separatorStyle↔Select) |
| Expression bindings (`{= … }`) over bound paths | ✅ | inline `client->_bind_edit( var )` calls composed into the expression string template — never captured in a variable | app 421 (the AGENTS §5 worked example) |
| Imperative controller logic that only derives view state (setWidth/setExpanded from a control value) | 🔶 | prefer a pure expression binding over an event round-trip (`{= ${slider} + '%' }`) | app 421 is the pattern; the avoidable round-trips in 486/530 were removed 2026-07-16 (LIVE-TEST pending) |
| Nested tables / tree binding (`items="{path: '/'}"` over nested `nodes`) | ✅ | nested ABAP table types serialize into nested JSON arrays; two-way delta write-back is nested-aware; the framework even ships a `z2ui5.cc.Tree` control preserving expand state | source-verified: ajson `convert_table` recursion + `delta_apply_nodes` (z2ui5_cl_core_srv_model); app 487 renders it (visual LIVE-TEST pending) |
| Named JSON models fed from ABAP (`img>`, view models) | ❌ | no second ABAP-fed JSON model — flatten into the default model or resolve statically, with an IMPROVISED deviation. But note what DOES exist: `device>` (row below), named OData models via `cs_event-set_odata_model`, the default model switched to OData with the ABAP model re-attached as `http>` (`view_display( switch_default_model_path = ... )`), and a `template>` preprocessor model for XML templating | source-verified (frontendaction/view1_js); apps 420, 434 flattened correctly |
| `sap.ui.Device` / device model bindings | ✅ | the `device>` named model (JSONModel over sap.ui.Device) is set on **every** view slot — main, popup, popover and nested views — so `{device>/system/phone}` bindings work everywhere; the same data is also mirrored server-side in `client->get( )-s_device` | source-verified: view1_js binds the one shared model in all slot factories (displayFragment/displayPopover/displayNestedView) plus the main view; apps 433/473 use it in main views (LIVE-TEST pending) |
| Date-**object** properties (`type: "object"`: `CalendarAppointment.startDate/endDate`, `PlanningCalendar.startDate/minDate/maxDate`, `SinglePlanningCalendar.startDate`, `DatePicker.dateValue`) | 🔶 | keep ISO strings in the ABAP model and convert **at the point of use**: `\|\{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' \}\|` with `core:require="\{Formatter: 'z2ui5/model/formatter'\}"` (POST_171). A plain string binding is ❌ — view creation crashes (`Date must be a JavaScript or UI5Date date object`); standard binding **types** are ❌ too (`Date.formatValue` throws a FormatException for the `object` target — unlike the Currency/sorter pass-through). Model-level auto-revival of `utclong` fields was **deliberately rejected**: it would silently retype every timestamp field (a plain `\{CREATED_AT\}` Text would render JS `toString()`), so conversion stays per-binding. String date properties (`DatePicker.value` + `valueFormat`) take model strings directly and need none of this | headless probe `scripts/probes/date-object-probe.mjs` (2026-07-18): string ❌ crash / Date ✅ / formatter ✅ render identically; beta sample `z2ui5_cl_demo_app_456` (abap2UI5/samples 00/08) |
| Binding `sorter` (no grouping) | ✅ | keep the original binding-info string: `\|\{ path: '{ client->_bind_edit( val = t path = abap_true ) }', sorter: \{ path: 'COL' \} \}\|` — no ABAP SORT, no deviation needed | apps 423/440/527 converted 2026-07-17; same pass-through as the group-sorter row below |
| Binding `sorter` with `group: true` + default group headers | ✅ | keep a raw binding-info string `{path: '…', sorter: {path: '…', group: true}}` — get the bare model path via `client->_bind_edit( val = t_products path = abap_true )` (human-taught 2026-07-16); only a *custom* `groupHeaderFactory` is out | source-verified on BOTH sides: abap2UI5 passes attribute values to `XMLView.create` unmangled, and UI5's default group header IS `new SeparatorItem({text: group.text \|\| group.key})` (openui5 `ComboBoxBase.addItemGroup`); app 452 converted 2026-07-16 (LIVE-TEST pending) |
| Standard composite binding **types** (`sap.ui.model.type.Currency`, Date/Number types) | ✅ | keep the original binding-info string 1:1 — `\|\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}\|` — over a numeric ABAP field (`price TYPE p`); the type is a client-side standard resolved on the frontend, and abap2UI5 passes the attribute value to `XMLView.create` unmangled (the same pass-through as the sorter rows) | apps 440/401 converted 2026-07-17 (LIVE-TEST pending); same idiom as curated samples `z2ui5_cl_demo_app_369` / `_172`. App 460 keeps a static single-record resolution for an unrelated reason ({/ProductCollection/0}), not because the type is inexpressible |
| Controller-applied binding filter/sort (`oList.getBinding('items').filter(new Filter(...))`, `.sort(...)`) | ✅ | `client->binding_call_by_id( id = … method = 'filter'/'sort' params = path/operator/value… )` after a backend event, or roundtrip-free via `_event_client( val = cs_event-binding_call t_arg = id/aggregation/method/params… )` with a `${$parameters>/…}` value resolved client-side. Whitelisted methods + filter operators, built from data (no code strings); empty filter value clears the filter. The model stays untouched — selection on filtered-out rows survives, unlike ABAP-side data filtering | implemented 2026-07-18 (pr/binding-call); source-verified in `app/webapp/core/FrontendAction.js` `evBindingCall`; beta samples `z2ui5_cl_demo_app_454`/`_455` (abap2UI5/samples 00/08, LIVE-TEST pending) |
| Custom JS formatter **functions** (`Formatter.js`, a `formatter: '.fn'` controller method) | 🔶 | if the function is in the framework's **curated formatter module** (standard app layout `model/formatter.js`, a served script, CSP-clean; grows via abap2UI5 PRs - implemented 2026-07-18, pr/formatter-registry): wire it like the original wires its formatter - `core:require="\{Formatter: 'z2ui5/model/formatter'\}"` on the view root (UI5 ≥ 1.74, declare POST_171) and keep the original binding structure with `formatter: 'Formatter.<fn>'`; pre-1.74 use the published global `z2ui5.Formatter.<fn>`. Otherwise: reproduce the logic as a `{= … }` expression binding when it fits the parser's whitelisted globals (`parseFloat`, `isNaN`, `Math`, …), or preformat in ABAP; note it. **Never via runtime-compiled JS strings** - an eval-based `register_formatter` was rejected the same day for security (needs unsafe-eval, invites building code from data). Factories returning controls (`groupHeaderFactory`, item factories) are ❌ either way. **Demo kit pack shipped 2026-07-18** (pr/formatter-demokit-pack): `weightStateByValue`, `stockStatusState`/`stockStatusIcon`, `round2DP`, `dimensions`, `deliveryStatusState` — covers every unported in-scope sample with a dedicated formatter file; a renamed reference (original binds `Formatter.weightState`/`.status`) needs a `NOTE` deviation | app 401 requires the module on its view root and keeps the original parts+formatter binding as `Formatter.weightState` (LIVE-TEST pending); source-verified in abap2UI5 `app/webapp/model/formatter.js` + `Component.js`; beta sample `z2ui5_cl_demo_app_453` (abap2UI5/samples 00/08) exercises the whole pack |
| `sap.m.MessageView` / `MessageItem` / `MessagePopover` | ✅ | bind the messages as a plain ABAP table on the `items` aggregation with a `MessageItem` template (`client->_bind_edit( t_messages )`) - `type`/`title`/`subtitle`/`description`/`groupName` map to columns; grouping, Dialog and Popover hosting all work | app 449; curated port proves the full set incl. grouping + MessagePopover (`z2ui5_cl_demo_app_038` in abap2UI5/samples) |
| MessageManager auto-collection (the global `message>` model gathering **control validation** messages client-side) | ✅ | since 2026-07-18 (pr/message-model, beta) every view slot carries the central message model as `message>` and is registered with `handleValidation`: bind `items="\{message>/\}"` 1:1 (MessagePopover family), and binding **type**/constraint errors on `_bind_edit` paths collect/clear automatically incl. the control's `valueState` — no app code, no roundtrip. For static message sets, driving a plain ABAP table stays fine (app 449) | probe-verified headless (invalid Integer input → message + valueState, valid input clears); beta sample `z2ui5_cl_demo_app_458` (abap2UI5/samples 00/08, LIVE-TEST pending) |

## Events

| UI5 feature | Status | How in abap2UI5 | Evidence |
|---|---|---|---|
| Controller event handlers | ✅ | `client->_event( val = 'NAME' … )` + `check_on_event( )` CASE branches | all interactive ports |
| Passing event/source values to the backend | ✅ | `$`-prefixed `t_arg` forms: `${COL}`, `$event.oSource.sId`, `${$parameters>/value}` — never a bare `{COL}` | source-verified on both sides: abap2UI5 passes `$`/`{`-prefixed args raw (z2ui5_cl_core_srv_event `get_t_arg`), and UI5's `EventHandlerResolver` parses `${…}` via `BindingParser.parseExpression` — a bare `{COL}` is no binding there; apps 486, 526 |
| Boolean event parameters | 🔶 | arrive as `abap_bool` (`X`/space) — map back to `true`/`false` when echoing to the UI | source-verified (z2ui5_cl_core_handler `request_parse_event_args`); app 421 (correct), app 422 fixed |
| Reading control-internal state via `$parameters>/…/mProperties/…` | ❌ | private UI5 internals, fragile across patches — restructure to a two-way binding or a public parameter instead | apps 401/474/530 were all migrated off it (2026-07-16); pattern-lint blocks any new use |
| Controller-read list selection (`getSelectedItems`, FacetFilter/List multi-select) | ✅ | bind `selected="{FLAG}"` / `selectedKey` two-way — the incoming model is applied to the app object BEFORE `on_event` runs, so handlers read post-interaction state; clearing server-side + `view_model_update` resets the client | source-verified: `factory_by_frontend` applies `model_json_parse` before recording the event (z2ui5_cl_core_action:55-77); apps 401/474 (visual LIVE-TEST pending) |
| Opening external URLs (`URLHelper.redirect`) | ✅ | `client->_event_client( client->cs_event-open_new_tab, t_arg = ( url ) )` | app 460 |
| Client-side-only behaviour with no backend effect | ✅ | `client->_event_client( … )` frontend actions | overview app popup close |
| Post-render actions (focus, scroll, …) | ✅ | `client->follow_up_action( val = client->cs_event-… )` — queued to run AFTER the response is rendered, so the DOM exists | source-verified (z2ui5_cl_core_client:43-55) |
| Imperative one-shot control methods with no binding equivalent (`open`, `close`, `setExpanded`, `scrollToIndex`, `scrollTo`, `focus`, NavContainer `to`/`back`) | ✅ | `client->control_call_by_id( id = … method = … params = … )` — whitelisted per method with arg-kind casting (`bool` takes the ABAP `X`/space), runs client-side after render; `open`/`close`/`setExpanded` added 2026-07-18 (pr/control-call-whitelist) | apps 469 (`open`) and 471 (`setExpanded`), LIVE-TEST pending; source-verified in `app/webapp/core/FrontendAction.js` `CONTROL_METHODS` |
| Drag & drop reorder (`dnd:DragDropInfo`, controller reorders the model on `drop`) | ✅ | declarative dnd config in the view; the drop event ships dragged/drop index and position via client-side resolved `$`-args (`${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl})`, `${$parameters>/dropPosition}`), ABAP reorders the table + `view_model_update` | shipped samples in abap2UI5/samples: 307 (GridList, 01/08/02) and 459 (sap.m.Table incl. `dropPosition=Between`, 01/02); view structure probe-verified |
| Timers / polling | ✅ | `cs_event-start_timer` (callbackEvent, delayMs) + `_event( s_ctrl = VALUE #( check_allow_multi_req = abap_true ) )` for events during a running round-trip | source-verified (frontendaction:348-362) |
| Rich event payloads beyond strings | ✅ | `_event( r_data = ref )` snapshots ABAP data at render time; read back via `client->get( )-r_event_data` | source-verified (core_client:404-414) |

## Frontend-action catalog (source-verified 2026-07-16)

`client->_event_client( client->cs_event-… )` / `follow_up_action` support far
more than the ports use so far — relevant when a sample's controller does
browser things: `popup_close`, `popover_close`, `open_new_tab`,
`location_reload`, `history_back`, `set_focus`, `scroll_to`,
`scroll_into_view`, `set_title(_launchpad)`, `clipboard_copy`,
`download_b64_file`, `urlhelper` (redirect / email / sms / tel),
`store_data` (session/local storage), `play_audio`, `start_timer`,
`display_message_box` / `display_message_toast` (options object 1:1),
`wizard_set_next_step`, `set_size_limit`, `set_odata_model`, nav-container
`*_nav_container_to` per view slot, `z2ui5` (call registered custom JS).
Newest (branch, pending release): the generic **`control_call`** /
**`control_call_by_id`** — call a *whitelisted* method on a global object
(MessageToast, MessageBox, BusyIndicator, Theming) or on a control resolved
by id (`to`, `back`, `focus`, `scrollToIndex`, `scrollTo`, and since
2026-07-18 also `open`, `close`, `setExpanded` — pr/control-call-whitelist),
client-side after render, without adding a dedicated action constant per case;
and the sibling **`binding_call`** (`binding_call_by_id` /
`cs_event-binding_call`, pr/binding-call) — apply a declarative filter/sorter
to an aggregation binding, also wireable roundtrip-free via `_event_client`.
Also available: nested view slots (`nest_view_display`), `popover_display(
by_id )` anchored to any control, app-stack navigation with typed results
(`nav_app_call/leave` + `get_app_prev`), and bundled custom controls
(`z2ui5.cc`: Timer, Storage, Focus, Geolocation, History, Tree,
FileUploader, CameraPicture, MultiInputExt / SmartMultiInputExt,
UploadSetExt, …). Details: the abap2UI5/abap2UI5 sources
`z2ui5_if_client` + `z2ui5_cl_app_frontendaction_js`.
