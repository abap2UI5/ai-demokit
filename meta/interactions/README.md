# meta/interactions — per-port e2e interaction modules

One module per port: `<class>.mjs`, default-exporting
`async (page, expect) => { … }` (Playwright `page`, the tiny `expect`
from e2e-smoke's `makeExpect`). `scripts/e2e-smoke.mjs` loads every module
here and runs it after the port boots; the generic boot+render+no-error gate
runs for EVERY port regardless. Shared assertions live in
`scripts/lib-e2e.mjs` — import them relatively
(`import { … } from '../../scripts/lib-e2e.mjs'`).

One file per port keys the map by FILENAME, so a duplicate key is impossible
by construction — the old in-file map carried two `z2ui5_cl_smpc_app_133`
entries and the last one silently won (the shadowed leg is preserved as a
comment in that file, pending a merge decision).

`node scripts/e2e-smoke.mjs --dump-interactions` prints every loaded
interaction (key + source) without needing the backend — the loader's
contract check and the refactor-diff tool.
`node scripts/validate-meta.mjs` enforces that every file here matches a
port sidecar (or the overview app); a port with an open LIVE_TEST deviation
and no module here is reported as an advisory gap count (not yet a hard
gate — the newest batches ship LIVE_TESTs before their interactions are
written).

GROW THIS DIRECTORY — it is the automated close path for the LIVE_TEST backlog
(STATUS.md open findings): each entry proves one LIVE_TEST *class* end to
end, so a green nightly run stands in for the human live check of every
port that only carries that class. Covered so far (one line per class,
the per-port modules here):
  client-composed toast (_event_client MESSAGE_TOAST, $event.*/$source>/
    $parameters> args, {N} templates, {N?a:b} conditional): 003 005
    049 061 074 076 080 134 156 198 (008's palette squares render a
    zero-height box headless, so its colorSelect toast stays uncovered;
    016's hideInput DatePicker openBy loops in Popover.onfocusin headless
    — the calendar opens, but the focus-restore bounces off the hidden
    input — so its check stays with the human live run, 091 covers the
    hidden-picker openBy class)
  popup_display / dependents dialog: 019 103 104 236
  popover_display (anchored by_id, BIND_ELEMENT, fragment rebuild):
    094 112 170 229 243
  anchored open via control_by_id openBy/toggleBy: 060 066 067 091 227
  two-way bound property flipped on a round-trip: 128 130 133 177
  frontend-action chains (BUSY_INDICATOR+START_TIMER, NavContainer.to,
    FileUploader upload guard): 147 242 246
  KEYBOARD_SHORTCUT combo → backend event: 232
  check_prevent_default (eBP wire): 241 093 (093 adds the confirm-then-
    remove flow: MessageBox onclose action + bound-row delete)
  breakpointChange → bound displaySize: 244
  semantic action state transport: 107
  audit-fix wires (2026-07-30): 122 157 167 168 234 238
  uxap ObjectPage batch b05 (2026-07-31): 258 (Translucent anchor bar +
    inlined blocks) 259 (ProgressIndicator/RatingIndicator header facets)
    260 (preserveHeaderStateOnScroll survives a real scroll) 261 (folded
    ModelMapping records) 262 (showFooter round-trip + breadcrumb toast)
    263 (NavContainer.to via control_by_id, there and back)
  boundFilters @1.146 (2026-07-31): 264 (bound prefix re-filters, empty
    prefix drops the filter, toggle re-bakes the set) 265 (per-row bound
    filter over a relative value1)
  bound valueState/valueStateText over an aggregation: 253 254 255
  DynamicSideContent (2026-08-01): 267 (a real viewport resize drives
    breakpointChanged → the bound Toggle `enabled`) 269 (both
    setShowSideContent follow-up actions, there and back)
  a control property the user drags into place: 270 (the Slider keyboard-
    driven, Panel width follows the expression binding with no round-trip)
  271 (layoutChange round-trip + containerQuery expression binding)
  268 covers only the anchored ColorPickerPopover open — picking a colour
    needs the picker's own zero-size-headless controls
  "controller sets a width from a slider": 144 (round-trip) 176 213 214
    (expression binding) — one shared assertion, sliderDrivenWidth()
  the device branch resolved server-side: 173
  a bound record/aggregation really resolving against the SERIALIZED model
    (render-smoke only ever sees a mocked one): 206 209 226, and 225 for a
    sorter inside a raw binding-info string
  a record FLATTENED onto the model root, bound absolutely: 142 175 195
    (plus the extra leg on 229/243) — all four rendered empty before
    2026-08-01, see AGENTS §5
  two-way bound control properties on a grid Table: 174
  fieldGroupIds / validateFieldGroup: 272
  controller-built Dialogs as popup_display fragments: 273 274
  OverflowToolbar controls ARE drivable — open the overflow popover
    ("Additional Options") first, then click inside it: 174 207 247
    (2026-08-01; an overflowed SegmentedButton renders as a Select there,
    and the binding TEMPLATE sits in the Element registry next to the real
    rows, so filter on getBindingContext() before asserting over rows)
  round-trip that opens a MessageBox: 101 (the wizard Cancel)
  a11y announce round-trip writing a bound Text: 141
  u:Currency over inlined arrays: 196
  client-side growing (no wire at all): 276
  a controller replaced by a device-model expression: 277
  KEYBOARD activation for controls with no layout box: 008 (a palette
    swatch, focus + Enter) 233 (F4 on the Input opens the SelectDialog) —
    a DOM click does NOT reach either of them
  still open: 233's confirm leg (neither click nor Enter on a dialog row
    reaches the SelectDialog's confirm headless) and the hidden-picker
    openBy class (016/256/257, Popover.onfocusin recursion)
