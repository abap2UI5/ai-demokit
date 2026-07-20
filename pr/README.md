# pr/ — forwardable framework requests

Every gap in the **abap2UI5 framework** that porting a UI5 demo kit sample
reveals is written up here as a ready-to-forward request — **one folder per
request, one README.md each**, self-contained (motivation, current behavior
with source references, proposed change, example) so it can be pasted
directly into an issue/PR at
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5).

Convention (see AGENTS.md §10 / TRAINING.md "Distill"): whenever porting or
reviewing surfaces an improvement idea for the framework — a missing API
parameter, a capability marked ❌ in CAPABILITIES.md that upstream could
close, a behavior gap — add or extend a request folder here **in the same
change**. When a request is implemented upstream, update CAPABILITIES.md,
remove its folder and record it in the "Implemented" table below — from then
on the details live upstream and in CAPABILITIES.md/STATUS.md.

## Open

| Request | Summary | Priority |
|---------|---------|----------|
| [`menu-item-selected-path`](menu-item-selected-path/) | A resolvable payload for the selected menu item's ancestor-text breadcrumb (`Create New Site > Official Store`), or a documented capability boundary. From b07 apps 060/061; today only the leaf `${$parameters>/item/text}` is transportable. **Deferred** (2026-07-20, user decision) — cosmetic (toast text) and likely resolves as a documented boundary rather than a framework change; kept for a later call | low — deferred |

## Declined / deferred (folder removed 2026-07-19)

| Request | Decision |
|---------|----------|
| named-json-models | **Too complicated with the current abap2UI5 approach** — every view slot serializes exactly one ABAP-fed default JSONModel per roundtrip; a second named model would have to be carried through bind, serialization and model-update on every slot. Declined for now, possibly worth re-discussing in the future if the model layer changes. Workaround stays: flatten into the default model or resolve statically (IMPROVISED deviation, apps 006/031/046, same family app 044) |
| message-manager-binding (not filed) | **Already covered** — considered while deferring the `MessagePopoverMessageHandling` sample (b07), but the `message>` model + `handleValidation` auto-collection landed 2026-07-18 (implemented `message-model`) and the plain-ABAP-table MessagePopover approach (app 038) both already express the family (CAPABILITIES.md rows for `MessageView`/`MessagePopover` = ✅). No framework change needed; that sample is a porting task, not a gap |

## Implemented (folders removed 2026-07-19)

| Request | Implemented | Upstream result |
|---------|-------------|-----------------|
| control-call-whitelist | 2026-07-18 | `open`, `close`, `setExpanded` added to the `CONTROL_BY_ID` whitelist (`app/webapp/core/FrontendAction.js` `CONTROL_METHODS`); ports 469/471 converted, IMPROVISED deviations dropped. 2026-07-19: the interim `control_call`/`control_call_by_id` wrapper methods were consolidated into `follow_up_action` + `cs_event-control_global`/`control_by_id` |
| message-box-dependent-on | 2026-07-17 | `message_box_display` carries `dependenton`/`contentwidth`; the client resolves the id to a `sap.ui.core.Element` before `MessageBox.show` |
| device-model-in-popups | 2026-07-17 | the shared `device>` model is bound on every view slot at creation — popup, popover and nested views, not just the main view |
| formatter-registry | 2026-07-18 | curated formatter module in the standard app layout (`app/webapp/model/formatter.js`, a served script, CSP-clean) — an eval-based `register_formatter` was implemented and reverted the same day for security |
| formatter-demokit-pack | 2026-07-18 | six suffixed demo kit formatters shipped in the curated module (`weightStateByValue`, `stockStatusState`/`Icon`, `round2DP`, `dimensions`, `deliveryStatusState`); beta sample `z2ui5_cl_demo_app_453` |
| binding-call | 2026-07-18 | declarative filter/sort on aggregation bindings via `cs_event-binding_call` (whitelisted methods/operators, built from data); beta samples `z2ui5_cl_demo_app_454`/`_455`. 2026-07-19: the interim `binding_call_by_id` wrapper method was consolidated into `follow_up_action` + `cs_event-binding_call` |
| message-model | 2026-07-18 | every view slot carries the central UI5 message model as `message>` with `handleValidation` registration; beta sample `z2ui5_cl_demo_app_458` |
| control-method-args | 2026-07-19 | `to` takes an optional transitionName, `open` an optional page key, `goToStep: [controlId, bool]` whitelisted; `castArgs` no longer pads missing trailing args (open() stays no-arg, no NaN ints). Found by hold-out probe #1 (apps 609/624/625) |
| control-methods-openby-setactivepage | 2026-07-20 | new `domRef` arg kind (control id → DOM element, control fallback) + `openBy: [domRef]` (unblocks app 016's hidden DatePicker; covers the TimePicker/Menu anchored-open family) and `setActivePage: [controlId]`. Found by batch b05 (apps 016/012). Note: 536's Carousel re-sync stays dropped — template-clone page ids are not backend-addressable; an index-based page resolution would be a new request if more samples need it |
| binding-call-compound-filters | 2026-07-20 | `BINDING_CALL` `filter` accepts a JSON groups payload — OR inside each group, AND across groups, operators whitelisted, empty clears; the positional single-filter form is unchanged (a path can never start with `[`). Port 401 converted to the compound form — the ABAP-side model rebuild and its `t_products_all` mirror are gone |
| tree-expand-collapse | 2026-07-20 | `expandToLevel: ["int"]` and `collapseAll: []` added to the `CONTROL_BY_ID` whitelist (`app/webapp/core/FrontendAction.js` `CONTROL_METHODS`) for `sap.m.Tree` / `sap.ui.table.TreeTable`; the overview app's tree gains client-side Expand-all / Collapse-all buttons via `_event_client( cs_event-control_by_id … )` |
| menu-toggle-openby | 2026-07-20 | `toggleBy: ["domRef"]` added to `CONTROL_METHODS` — like `openBy`, but `control.isOpen() ? close() : openBy(anchor)`, so a press-to-toggle popup (`sap.m.Menu`) round-trips 1:1 without the backend mirroring open state. Unit tests added; b07 app 060 converted (openBy → toggleBy), IMPROVISED toggle-reduction dropped |
| formatter-inline-icon | 2026-07-20 | `expandInlineIcons(text)` added to the curated `model/formatter.js`: replaces `%%icon:sap-icon://<name>%%` placeholders with the `sapMMsgStripInlineIcon` markup (glyph via `IconPool`), the `MessageStripUtilities.getInlineIcon` equivalent — CSP-clean, no ABAP API. Unit tests added; b07 app 062's inlineIconsHelper converted (placeholders + `core:require` formatter binding), guessed-codepoint IMPROVISED dropped |
