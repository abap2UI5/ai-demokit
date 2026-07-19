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

| Request | Status |
|---------|--------|
| [named-json-models](named-json-models/README.md) | open — `_bind`/`_bind_edit` still have no named-model parameter (verified against `z2ui5_if_client` 2026-07-19) |

## Implemented (folders removed 2026-07-19)

| Request | Implemented | Upstream result |
|---------|-------------|-----------------|
| control-call-whitelist | 2026-07-18 | `open`, `close`, `setExpanded` added to the `control_call_by_id` whitelist (`app/webapp/core/FrontendAction.js` `CONTROL_METHODS`); ports 469/471 converted, IMPROVISED deviations dropped |
| message-box-dependent-on | 2026-07-17 | `message_box_display` carries `dependenton`/`contentwidth`; the client resolves the id to a `sap.ui.core.Element` before `MessageBox.show` |
| device-model-in-popups | 2026-07-17 | the shared `device>` model is bound on every view slot at creation — popup, popover and nested views, not just the main view |
| formatter-registry | 2026-07-18 | curated formatter module in the standard app layout (`app/webapp/model/formatter.js`, a served script, CSP-clean) — an eval-based `register_formatter` was implemented and reverted the same day for security |
| formatter-demokit-pack | 2026-07-18 | six suffixed demo kit formatters shipped in the curated module (`weightStateByValue`, `stockStatusState`/`Icon`, `round2DP`, `dimensions`, `deliveryStatusState`); beta sample `z2ui5_cl_demo_app_453` |
| binding-call | 2026-07-18 | declarative filter/sort on aggregation bindings via `binding_call_by_id` + `cs_event-binding_call` (whitelisted methods/operators, built from data); beta samples `z2ui5_cl_demo_app_454`/`_455` |
| message-model | 2026-07-18 | every view slot carries the central UI5 message model as `message>` with `handleValidation` registration; beta sample `z2ui5_cl_demo_app_458` |
