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
  Edit/Save/Cancel through bound visible flags (2026-08-16): 312-337, all
    26 ports of the Form/SimpleForm family on ONE module - Edit swaps the
    form, CANCEL restores the record the EDIT handler cloned, SAVE keeps
    the edited one
  CAL_SELECT expression-arg round-trips (2026-08-16): 304 (+ Select Today)
    305 (the SAME day clicked twice, which is the branch that CLEARS the
    selection) 306 (two clicks make an interval)
  TOGGLE_EXPAND on a SideNavigation (2026-08-16): 299 300 - pressed TWICE,
    because a flag that latches on would pass a single click. Note the
    navigation is NOT inside a ToolPage in 299: match on
    [class*="sapTntSideNavigation"] and read NotExpanded off its class
  SideNavigation itemSelect -> NavContainer 'to' (2026-08-16): 302 303 -
    .sapTntNLI is not clickable where its text is; getByText() is
  the anchored ColorPicker ResponsivePopover (2026-08-16): 309 310 - the
    picker has no "Hue" label until it is OPEN; assert on
    .sapUiColorPicker-ColorPickerMatrix instead
  a static port that had never been SEEN to render (2026-08-16): 413 - the
    ObjectPage header IDENTIFIER and header CONTENT are two different DOM
    subtrees, so one assertion cannot cover both
  the enum an emptied aggregation breaks (2026-08-16): 308 - pressing the
    ToggleButton twice clears the table, UI5 evaluates the template with no
    row, and an enum-typed property refuses the `` it gets. The port was
    FIXED by this module; see abap2UI5's ui5-check §4
  a facet selection that must SURVIVE listClose (2026-08-17): 352 - the
    round-trip used to answer HTTP 500 (`DELETE ... INDEX sy-tabix` inside its
    own `LOOP AT`, abap2UI5's abap-check section 5). Two traps: not crashing is
    not the assertion the LIVE_TEST asks for, and filtering to LAPTOPS proves
    nothing because the unfiltered table already opens with Notebook Basic
    15/17/18 - measured, 10 rows before and the same 10 after. Accessories
    changes the first row, which is the cheap way to see the selection travel
  a SearchField that is not on the page (2026-08-17): 354 - the toolbar
    OVERFLOWS at the smoke's viewport, so the field exists only inside the
    "Additional Options" popover; without opening it first the module dies in a
    30s locator timeout that reads like a broken port. Same class as the
    overflow note above. This module reaches `filter_apply( )` - the method the
    sy-tabix fix touched - but it deliberately does NOT close 354's LIVE_TEST,
    which is about the COLUMN filter's prevented default and enableCellFilter;
    those need a sap.ui.table column header menu
  the sap.ui.table batch (2026-08-21): 356 (the bound plugin limit /
    selectionMode / showHeaderSelector reach the plugin with no round-trip, and
    the selectionChange expression arg reports the count) 357 (both round-trips
    re-read all 115 rows; neither answers with a toast, so the MODEL is the
    assertion) 360 (a real ClipboardEvent dispatched at the table - its onpaste
    bails out when the focus sits in an input and reads the cells off the
    native event) 362 (the vetoed client sort plus the server-side SORT, read
    off the first row's binding CONTEXT rather than a rendered cell) 363 (the
    Apply clamp writes the corrected number back INTO the Input) 364/366 (the
    arrayNames tree really expands - 366 also asserts it does NOT open deeper
    than its one expanded level, without which a flat list is
    indistinguishable) 365 (expandToLevel's numeric argument reaches the
    method, proven by the level the tree stops at)
  the uxap header/ObjectPage batch (2026-08-21): 401 408 414 (a bound flag
    pressed TWICE - one press passes on a flag that latches, which is the
    defect 401's first draft had) 409 (a static port, asserted on the nested
    block geometry) 410 (the parent-chain event arg resolving to a runtime id)
    412 (anchored QuickView + in-popover pageLink + setSelectedSection + two
    client toasts) 415 (two anchored popovers, ITEM_SELECT closing one, both
    breadcrumb toasts) 416 (the breadcrumb round-trip) 417 (the breakpoint
    transport measured where it ALONE decides the flag: side content open at
    breakpoint S)
  the three modules that used to be DOM DUMPS (2026-08-21): 301 (the ShellBar
    menuButtonPressed popover, itemSelect -> NavContainer 'to', and the
    selectedKey surviving the popover being REBUILT - the leg that caught the
    literal selectedKey defect) 351 (Add/Remove really re-render the bound
    contentAreas, a typed Min-Size reaches SplitterLayoutData as an integer,
    the bound orientation flips) 353 (the rowSelectionChange rowIndex moving a
    NAMED row, and MOVE_UP reordering). validate-meta now rejects a module
    that can never fail, which is what let these three count as coverage
  407 (2026-08-21), the five-wire tnt one: itemSelect navigation, the
    quickCreate popup, the LIVE_CHANGE filter, announceSearchMatchCount read
    off the static area's polite aria-live node, and MENU_TOGGLE resetting the
    search
  still open: 353's four drag & drop wires (HTML5 dnd, which Playwright's
    dragTo cannot produce for sap.ui.table's pointer extension - dispatching
    the DataTransfer events by hand would test the harness), 354's
    column-filter leg (see above), 233's confirm leg (neither click nor Enter on a dialog row
    reaches the SelectDialog's confirm headless), the hidden-picker
    openBy class (016/256/257, Popover.onfocusin recursion), and 359's
    row-action press: the row actions never render in the smoke at all, and
    calling setRowActionCount(2) + invalidate() DIRECTLY on the table through
    its own API - bypassing the port - still leaves every row without a
    _rowAction, which rules the port out. 359's module therefore closes only
    the bound-rowActionCount half and its LIVE_TEST stays OPEN
