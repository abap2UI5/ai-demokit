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
  live control state that must survive a view rebuild: 022 235 557 (the
    compound binding_call filter) 249 (setBadgeMinValue/MaxValue, which are
    NOT properties — Button keeps them in private fields) 534 (the branching
    Wizard's nextStep associations) 585 301 302 303 167 558 (a NavContainer /
    ToolPage POSITION, fixed 2026-08-27). The shape is always the same and is
    worth recognising: view_display( ) destroys the slot and XMLView.create
    builds a fresh control tree, so anything set through a control_by_id or
    binding_call is gone — while the class state DESCRIBING it survives, and
    the app then claims a state it does not show. Each of these legs asserts
    BOTH halves, because asserting only the reset half passes on a port that
    never set anything. 571 and 607 are the same mechanism from the other side (a
    declared sorter the rebuilt binding re-applies, and an ordering the rebuild
    drops). The six NavContainer ports were the last carrying it unfixed and
    are fixed as of 2026-08-27: 585 301 302 303 167 re-issue the guarded
    control_by_id 'to' from the end of view_display( ) against the surviving
    two-way bound selected key, 558 against a PROTECTED nav_page that parks the
    target the live navCon was last sent to. FIVE of the six legs drive the
    rebuild through the bookmark restore; 558 does not need it — four of its
    five view_display( ) branches are reachable only FROM tabContainerPage, so
    the tab bar's + button is one press away, and that is what its leg clicks.
    An earlier reading that firing addNewButtonPress "drove no round trip at
    all" was a HARNESS ARTEFACT, corrected 2026-08-27: eB DROPS any event fired
    while a round trip is in flight (View1.controller.js, `if
    (AppState.state.isBusy && !ignoreBusy) { BusyIndicator.show(0); return; }`)
    — the listener still runs and fireEvent still returns cleanly, so a press
    sent too early reads back as a dead control. Measured both ways on the
    built backend: fired while busy, no POST and the items never change; fired
    one second later on an idle frontend, TAB_ADD_NEW goes out and the tabs go
    2 → 3. The TabContainer's own add button (class sapMTSAddNewTabBtn, tooltip
    "Add New Tab", rendered into the control's TabStrip) takes a plain
    Playwright click with no force at 95x22 px. Every leg here that presses
    after a round trip therefore waits for `!z2ui5.isBusy` first.
    What the five restore legs measured BEFORE the fix, each against the very
    same draft: 585 and 167 came back on page2 while the SideNavigation read
    page1, 302 and 303 came back on page1 while the IconTabHeader read page2,
    and 301 came back on `home` — the lorem ipsum — while page_text read
    "Fired event to load page 7". None of the six navigates a
    sap.f.FlexibleColumnLayout, so the `to` cast fixed upstream by 977474af
    does not gate any of them.
    What the five actually DRIVE (2026-08-26). 022 235 557 open the
    FacetFilter — 022 through the Light type's whole summary bar, which is
    the opener there (the -add button has no DOM at all in that type), 235
    and 557 through the Simple type's per-facet button — tick Accessories
    and close it, measured at 34 of 123 rows and ONE aFilter. Then they
    rebuild the view through the framework's own bookmark restore,
    `?app_start=<class>#/z2ui5-xapp-state=<draft>`: that request carries no
    frontend id, so the backend takes factory_first_start -> db_load(draft),
    which sets check_on_navigated( ) while check_on_init( ) stays false —
    exactly the `ELSEIF check_on_navigated( )` branch, and the only way a
    port that calls no other app reaches view_display( ) a second time. The
    restored view must STILL read Accessories AND still show 34 rows over a
    non-empty aFilters; before the fix it came back reading Accessories over
    all 123. Remove the `IF filter_live IS NOT INITIAL. filter_issue( ).`
    from view_display( ) and the last assertion fails, which is what makes
    the leg worth its runtime. 557 drives the bound `lists` aggregation
    first (two groups, 16 Category and 12 SupplierName values off the nested
    values table). 235 and 557 close the facet popover through an OK button
    if there is one and Escape if there is not — a fallback, so a port that
    lost its OK is still confirmed by the Escape path. 249 arrows the
    StepInput up (the badge follows to 2 with no round trip), commits
    minimum 5 — which HIDES the indicator, because 2 is below it — and
    maximum 50, read off the private _badgeMaxValue; then it reloads the
    saved draft through the app-state hash and re-reads BOTH private fields
    on the fresh Button (5/50) plus the badge still being absent. 534 reads
    all NINE nextStep associations off the branching Wizard, not just the
    two branch points: Branching.controller applies path 0
    (A->B1->C->D->E->F1->F2->G) on EVERY render and that path RE-POINTS F1
    away from its own XML default G, so a leg that checked only A and E
    would pass on a controller that never re-pointed anything. The branching
    wizard is not VISIBLE at boot (the showcase starts linear), so it and
    its three path radio buttons are read from the registry rather than the
    rendered body
  check_prevent_default (eBP wire): 241 093 (093 adds the confirm-then-
    remove flow: MessageBox onclose action + bound-row delete, the closed
    tab's NAME travelling in the box rather than the static prefix, and the
    SALARY round trip below)
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
    swatch, focus + Enter) — a DOM click does NOT reach it. 233 stood here
    for F4 on the Input until 2026-08-26; its module drives no gesture at
    all any more and asserts the chain statically instead — see its own
    entry below, and "still open"
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
  rewritten on 2026-08-21 after review found them asserting the wrong thing:
    344 (clicked Toggle and asserted a Text was visible - true before, after,
    and whether the button worked at all, which is how a Toggle that could not
    toggle survived a green nightly; it reads the two grid cells' sapUiHidden
    class now, and presses TWICE) 341 (pressed Start loading ONCE, so the
    control_by_id refresh loop - which only runs on a LATER press - was never
    executed, while the deviation it closed named exactly that branch)
    363 (every assertion began by fill()ing over whatever was there, so a
    seeded "0" hiding three placeholders was invisible; it asserts the empty
    start now, and commits each Input with Enter before pressing Apply)
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
  the URLHELPER frontend action, read off sap.m.URLHelper's own public
    `redirect` event (2026-08-25): 084 - all four legs (TRIGGER_TEL,
    TRIGGER_SMS, TRIGGER_EMAIL, REDIRECT) assert the FINISHED URI, so a
    { TEL: '...' } object-literal t_arg that does not arrive shows up as a
    bare `tel:`/`sms:` - the exact defect the retired 2026-07-27 live note
    could not see. Nothing round-trips: follow_up_action( ) wired in the view
    IS the client event, so there is no POST to wait for and the redirect
    event (fired before the browser is handed the URI) is the only observable
    end of the chain. ONE leg is driven by a real click and the other three by
    the item's own firePress( ) - see the still-open note below
  PlanningCalendar appointment/interval wires (2026-08-25): 108 (both
    handleAppointmentSelect MessageBox legs - message_box_display, NOT a
    toast, which is what retired the port's 2026-07-27 live check; the
    appointment leg driven by a real focus+Enter selection on a rendered
    appointment so the calendar's own selection and getSelectedAppointments()
    run, the no-appointment leg fired with the `appointments` array UI5 only
    ever passes for a GROUP appointment; the showDayNamesLine ToggleButton
    moving the calendar's property through the shared two-way bound field with
    no round-trip; and intervalSelect inserting the sample's 'new appointment'
    at the LOCAL parts of the selected interval, asserted against the
    parameters the calendar actually delivered). Its ToggleButton leg carries a
    lesson worth the space: the registry-staleness filter
    (!bIsDestroyed && getDomRef() && document.body.contains(...)) belongs on the
    control whose STATE is the claim, never on every control the predicate
    touches. Flipping showDayNamesLine re-renders the header's OverflowToolbar
    and re-decides what overflows, so the ToggleButton moves into the CLOSED
    overflow popover - a perfectly live control with no rendered DOM. Requiring
    it to be in the document made the predicate unsatisfiable exactly when the
    toolbar re-laid out that way, which is a timing decision: the leg passed and
    failed on alternate runs while the gesture, the calendar and the model were
    all correct every time
  a value typed into a CELL and read back AFTER the round trip — the trip
    itself, not the keystroke (2026-08-26): 093 570. Both used to lose the
    entry in silence: delta_apply_field catches cx_root ##NO_HANDLER ("skip
    just this cell"), so a value the target field cannot take is dropped
    with no error, no toast and no valueState while the browser goes on
    showing it — which is why nothing short of driving the trip can see it.
    093 fills 1,455.22 into the SALARY Input, Tabs out of it, then takes the
    app's ONLY round trip (closing the LAST tab, so the edited row 0
    survives) and re-reads the Input: SALARY is a string field, so the
    assertion is that the typed text comes back VERBATIM. 570 is the other
    answer to the same problem and drives BOTH of its branches: PRICE is
    packed for the read-only Currency binding, so the editable cell binds a
    PRICE_TEXT string mirror — 1,250.00 is REJECTED (a "Not a number" toast,
    Save does NOT leave edit mode, the model's price is unchanged and the
    cell is restored from the packed value) and 1250.00 goes home and
    arrives in the row's binding context as 1250. 570 also drives the
    read-only/editable template swap and the Cancel rollback, and addresses
    its table by id: every sap.m.Input builds an INTERNAL sap.m.Table for
    its suggestion popup, so a bare find( ) for sap.m.Table can return one
    of those once the editable template has been shown
  sorting WHILE grouped, the conflicting path (2026-08-26): 571 — the four
    column header menus and the headerMenu association first, then Sort
    Ascending on price (Flyer leads), then Toggle Grouping, asserted through
    the items binding's own isGrouped( ), then Sort Ascending AGAIN with the
    grouper on. Upstream each quick action passes a ONE-element list to
    oBinding.sort( ), which REPLACES the grouper, so the second sort has to
    leave isGrouped( ) false and Flyer first; with a grouper still declared
    the rebuilt JSONListBinding re-applies SUPPLIERNAME as the primary key
    and some other row leads. That conflicting path is exactly what let this
    port's client-side grouper overrule the ABAP sort unnoticed, and the leg
    was proven by REMOVING the fix. The quick actions are fired through the
    menu entries' own firePress( ), not clicked, and the row count is
    asserted at 100 rather than 123: a JSONModel's default sizeLimit is 100
    and neither the sample nor the port raises it, so the original renders
    100 too
  a search term the JSON literal cannot carry (2026-08-26): 499 — the term
    is zz"zz\zz, which carries BOTH characters that break the literal the
    compound binding_call filter is built from. Unescaped, JSON.parse throws
    inside buildFilterGroups, which LOGS and returns WITHOUT calling
    binding.filter([]) — so the PREVIOUS filter stays on and the list still
    shows the Notebooks the first leg narrowed it to. The list going EMPTY
    is therefore the whole assertion: a leg that only asked for "not the
    Notebooks" would pass on a filter that was never applied at all. Both
    terms are raised through the SearchField's own setValue +
    fireLiveChange, not typed — `.sapMSFI` is the wrapper, not the input,
    and filling it left the control's value empty with the liveChange wire
    never running (measured 2026-08-22)
  a bound indicator whose symptom is INDIRECT, so the model is read first
    (2026-08-26): 529 — SemanticConfiguration binds MessagesIndicator
    .visible to a formatter over message>/, so a message model nothing fed
    renders no button at all. The module reads the message model's CONTENT
    first (Messaging.getMessageModel( ), with a fallback to the older
    getCore( )->getMessageManager( ) so it runs on either core) and fails on
    the count and on the sample's own "Something wrong happened" text,
    THEN asserts the indicator that a fed model makes visible. Asserting the
    button alone reports a missing button, which accuses the popover wire
    instead of the z2ui5.cc.MessageManager bridge that is the thing actually
    absent. It also drives ToggleFooter -> showFooter false
  the whole gesture replaced by a STATIC wire assertion, deliberately
    (2026-08-26): 233 — it waits for the Input's DOM (a DOM wait, not a
    registry poll: a waitForFunction over Element.registry.all( ) is itself
    part of the load on this view) and then reads in ONE evaluate:
    showValueHelp, that valueHelpRequest carries TWO handlers — the
    binding_call filter chained with the control_by_id open, where a 1 is
    the pre-2026-08-24 half-wire — the dependent SelectDialog's title
    ("Purchases") and its items binding length, and the IllustratedMessage
    TITLE. That last one is the 2026-08-26 correction: the control sits in a
    uxap:ObjectPageSubSection, which ObjectPageLayout renders LAZILY, so the
    old body-text scan was testing uxap's render SCHEDULE. It is read from the
    registry by EXISTENCE only, never through getDomRef( ), and off the
    property the expression binding over INPUTPOPULATED writes.
    **That diagnosis was half right and the port was NOT correct (2026-08-27).**
    The same view failed a SECOND time in bump-a2ui5 run 33087805313, now on the
    Input's visibility wait, and the cause of both is one port defect: the
    IllustratedMessage subsection carried the original's
    sapUxAPObjectPageSubSectionFitContainer, whose contract is an
    ObjectPageLayout with a definite height. abap2UI5 hosts the view in a
    content-sized sap.m.NavContainer, so there is none, and the class closed a
    feedback loop — one resize took the layout 329px -> 19,249px -> 60,142px and
    then pegged the renderer, after which no wait on the page can resolve and
    whichever assertion touches the layout first reports the timeout as its own.
    Moving an assertion to the registry made it immune to the symptom and left
    the defect in place; the class is now gone from the port (an IMPROVISED
    deviation), the Input's wait deliberately stays a VISIBILITY wait as the one
    check a pegged renderer cannot satisfy, and a final leg dispatches one
    resize and requires the ObjectPageLayout to stay under 5000px, so re-adding
    the class fails with its own sentence instead of as a mystery timeout.
    Reproducing it needs CI's browser: the harness prefers the sandbox's
    /opt/pw-browsers/chromium (full Chromium), CI runs playwright's
    chrome-headless-shell, and the boot-time race only showed up on the latter.
    What this entry does not claim: nothing here presses F4 or confirms a row —
    see "still open"
  SET_FOCUS, and the one transition where the wire alone decides the
    outcome (2026-08-26): 013 — the port's three focus follow-ups are
    SET_FOCUS, not a control_by_id `focus`. The buttons they aim at are
    INVISIBLE when the action runs (their `visible` is bound to the flag the
    same round trip flips), an invisible control renders through
    InvisibleRenderer as a sap-ui-invisible- placeholder, and Element.focus
    returns immediately when getFocusDomRef( ) is null — so a bare focus is
    a silent no-op. SET_FOCUS is "focus now if rendered, else once it is",
    which is the original's own _focusButton helper. ONE of the three is
    driven: Set Preferences -> the detail list appears, Save Preferences is
    visible with a DOM node, and document.activeElement has to BE it. The
    module also drives Cancel-with-details, which navigates back to the
    preview instead of closing the dialog. The other two SET_FOCUS calls are
    deliberately not asserted — see "still open"
  the branch a Wizard needs BEFORE the press, not with the answer to it
    (2026-08-26): 535 560 — WizardStep._complete fires `complete` and then
    calls Wizard._handleNextButtonPress in the SAME tick, so a branch that
    arrives with the round trip's answer arrives too late and the press
    throws "wizard is in branching mode and no next step is defined". Both
    modules assert PaymentTypeStep's declared nextStep (CreditCardStep) and
    its three subsequentSteps STANDING before anything is pressed, then
    press Next twice — ContentsStep -> PaymentTypeStep, and the FIRST press
    on PaymentTypeStep reaching CreditCardStep — and finally that arriving
    on BillingStep left it unvalidated with its two subsequentSteps. The
    presses go through the step's own _nextButton aggregation rather than a
    click, and the helper first requires that button to have a DOM node and
    to lack sapMWizardNextButtonHidden, so a Next that is not displayed
    fails the leg instead of passing quietly. 535 adds the Delete-mode row
    drop with the total recomputed in ABAP (5724 -> 4768); 560 the seeded
    payment default reaching the SegmentedButton and CreditCardStep starting
    invalidated on an empty name. Both also carry a REBUILD leg, added
    2026-08-27 and first RUN the same day — green — see the entry below
  the SinglePlanningCalendar modify dialog (2026-08-26): 549 609 — all four
    pickers of that dialog share ONE ISO string, and the pinned valueFormat
    (yyyy-MM-dd'T'HH:mm:ss) is what lets both pairs read it; unpinned, a
    DatePicker cannot parse an ISO datetime at all and showed the raw
    "2018-07-09T09:00:00" with no date value (headless probe, 2026-08-26),
    so both modules require all two DateTimePickers and two DatePickers to
    hold a real Date. Ticking All-day has to rewrite BOTH times to midnight
    (_setHoursToZero) — without the ALL_DAY wire an all-day appointment was
    saved as 09:00-10:00 — asserted on the two DatePicker VALUES ending
    T00:00:00, which is the client end of the wire and not a saved
    appointment. 609 adds DATE_CHECK: an end that is not AFTER the start
    disables OK and paints both DateTimePickers Error, which is the wire
    that stops a backwards appointment being saved, plus the whole
    CalendarDayType enum reaching the type Select (key === text, Type09
    present), the 35 seeded appointments over three views, and Cancel
    closing the dialog again. 549 adds the ISO-to-Date formatter on the
    calendar itself and the seeded drag/resize flags. Both All-day legs and
    609's DATE_CHECK are raised through the control's own setSelected +
    fireSelect / setValue + fireChange rather than a gesture: a port that
    wired the event to nothing still fails them, a port whose CheckBox
    cannot be clicked does not
  the three legs that were reasoned and are now MEASURED (2026-08-27):
    535 560 575 — the REBUILD legs on the two wizards and 575's
    COLUMN_RESIZE follow-up were written on 2026-08-27 and had never been
    executed once. They ran that day in a full-corpus run against
    `.abap2UI5` at 26a16a4, whose `app/webapp` is byte-identical to
    abap2UI5 main and therefore carries the `pageId` fix in
    core/actions/ControlCall.js, and all three passed — "pass  535
    (+interaction)", "pass  560  (+interaction)", "pass  575
    (+interaction)", under "e2e-smoke: 623 app(s), 0 failing." Each of the
    three assumptions the legs stood on is CONFIRMED, and each one
    separately, because no green is obtainable without it:
    (1) sap.f.FlexibleColumnLayout DOES fire columnResize in the headless
    harness — the port issues scrollToIndex from exactly ONE place, the
    `WHEN COLUMN_RESIZE` arm guarded by `press_index >= 0`, so the spy
    recording any call at all is that event having made the round trip;
    (2) SegmentedButton._buttonPressed's model write-back DOES reach the
    round trip — the branch target is a SWITCH over `selectedpayment`, so
    PaymentTypeStep re-pointing at BankAccountStep can only come from the
    two-way bound selectedKey arriving in ABAP;
    (3) the app-state restore DOES rebuild these two wizards the way it
    rebuilds 022/235/557/249 — the reloaded draft came back with a Wizard
    that has a DOM node and its eight steps.
    The three coverage gaps therefore CLOSE, and on more than the pass:
    each leg is differential against its own defect BY CONSTRUCTION. The
    rebuilt PaymentTypeStep is required to carry BankAccountStep, which is
    NOT the XML's static nextStep="CreditCardStep", and BillingStep
    declares no nextStep at all — so the two un-fixed answers
    (CreditCardStep, null) are each NAMED and rejected with their own
    sentence; and 575 requires the recorded index to BE 7, which nothing
    but the recorded press can produce. What is still NOT done, and this
    is the one notch these three sit below every entry above: none of them
    has been proven by DELETING the fix from the transpiled backend and
    watching the leg go red — for 535/560 that is the `branch_payment( )`
    / `branch_delivery( )` pair called from `view_display( )`, for 575 the
    `WHEN COLUMN_RESIZE` arm — see "still open"
  still open: 353's four drag & drop wires (HTML5 dnd, which Playwright's
    dragTo cannot produce for sap.ui.table's pointer extension - dispatching
    the DataTransfer events by hand would test the harness), 354's
    column-filter leg (see above), 233's confirm leg (neither click nor Enter on a dialog row
    reaches the SelectDialog's confirm headless), and 233's F4 -> SelectDialog
    leg with it: the wire is LIVE (measured 2026-08-25 both offline against the
    real core/actions/ControlCall and in ~15 harness runs), but this port boots
    in ~100 s against ~2 s for its neighbours - the heaviest view in the corpus,
    unthemed and unbundled - and in that state the smoke shows two failures that
    are not the port's. The dialog opens with its title on screen and is GONE
    before the assertion (diagnosed with valueHelpRequestHandlers = 2, i.e. the
    chain fully attached), and the Chromium process itself dies on the view (4
    in ~25 runs). The module therefore asserts the chain STATICALLY - two
    handlers on valueHelpRequest, the bound dependent SelectDialog titled
    Purchases with rows in its items binding, the IllustratedMessage state - and
    leaves the gesture to the human live run. A waitForFunction over
    Element.registry.all() is itself part of the load on a view this heavy and
    must not be used as its readiness check, the hidden-picker
    openBy class (016/256/257, Popover.onfocusin recursion), and 359's
    row-action press: the row actions never render in the smoke at all, and
    calling setRowActionCount(2) + invalidate() DIRECTLY on the table through
    its own API - bypassing the port - still leaves every row without a
    _rowAction, which rules the port out. 359's module therefore closes only
    the bound-rowActionCount half and its LIVE_TEST stays OPEN.
    Two more from 2026-08-25: 084's URLHelper hand-off, in two parts - the OS
    half is unobservable anywhere (headless Chromium registers no
    external-protocol handler, so tel:/sms:/mailto: are dropped AFTER the
    redirect event has fired and no dialer, SMS or mail client can be seen
    opening, and its Website leg's actual LOAD of http://www.sap.com is
    aborted at a context route - no egress, and a foreign page inside the run
    is what a redirect check must not do), and the GESTURE half is a harness
    limit MEASURED on 2026-08-25: the first press really assigns
    window.location.href, Chromium never commits that navigation and never
    delivers another input event to the tab - a later .click( ) reports
    success with no mousedown/click reaching the DOM at all, focus+Enter is
    swallowed the same way, and even a page.goto( ) reload does not bring
    input back, so exactly ONE URLHelper leg per tab can be given a real
    gesture (084 spends it on Telephone and fires the other three on the
    control's own press event, asserting the item is Active and HAS that one
    view-wired listener first); and 108's selected/deselected WORD,
    which rides on a boolean t_arg the transpiled runtime hands the backend as
    the string 'true' where `= abap_true` cannot match - so the harness always
    reads "deselected" while a real system reads "selected". Asserting the
    word would fail a correct port, so that half stays with the human live
    run, as does the group-appointment path that alone produces the
    no-appointment leg from a gesture.
    Four more from 2026-08-26/27. 013's OTHER two SET_FOCUS calls (the one
    on the dialog opening and the one after Cancel) do land and are then
    OVERRIDDEN by UI5 itself — the Dialog's own initial focus, the footer
    OverflowToolbar's focus restore — and the ORIGINAL loses them the same
    way, so there is no end state a leg could assert that a correct port
    would satisfy; only the Set Preferences transition is driven. What is
    still open on 535, 560 and 575 is no longer COVERAGE — their legs ran
    green on 2026-08-27 and the entry above records what that measured —
    but the DEFECT PROOF: not one of the three has been re-run with its
    fix deleted from the transpiled backend, which is what every other
    entry above rests on. A leg that passes is weaker evidence than a leg
    that has been made to go red on demand, so until someone does that,
    read a red on 535, 560 or 575 leg-first — a little more readily than
    you would a red anywhere else in this file. And
    the general limit app 578 exposed, which belongs to no single port: a
    leg that asserts getItems( ).length on a control it only found in the
    REGISTRY passes VACUOUSLY. A bound aggregation fills whether or not its
    control is on screen, and a page a NavContainer has swapped away leaves
    its controls alive with no DOM node — so 578's drill-down reads (16
    categories, 11 Laptops rows, and the supplier row it reaches for by
    index) proved the bindings resolved and NOT that any of it was
    displayed. That is why every one of them carries the rendered filter
    since 2026-08-27, and both of 578's legs — the begin-column `to` and
    the sort round-trip that must not lose the column — then RAN and
    PASSED the same day ("pass  578  (+interaction)") against a build
    carrying the `pageId` fix, so the swap is measured and not merely
    reasoned. The same reading still applies to every count in this
    directory taken off a bare registry find( ). The rule is the app-108
    one applied to the
    CLAIM: getDomRef( ) belongs on the control whose STATE is the
    assertion, and on no other — absent there it hides a page that never
    rendered, present everywhere else it makes the predicate unsatisfiable
    the moment a control legitimately has no box
