# The journal — chronological history

_The append-only history of the project: batches, probes, audits, fixes —
one section per event, newest first. **New journal entries go here** (same
same-change discipline as AGENTS.md §10). The current point-in-time state
(generated counts) and the open findings backlog live in
[STATUS.md](../STATUS.md). Numbers quoted inside these sections are snapshots
of their date and are NOT kept current._

## 2026-08-22 — batch b49 (sap.uxap): the ObjectPage tail, and a fourth escape hatch (apps 586–599)

Every unported `sap.uxap` sample in one batch, which finishes the library at
**45 / 45** and the second-to-last of the ten: twelve more `ObjectPageLayout`
samples and the two remaining `ObjectPageSubSection` ones.

| app | sample | what it adds |
|---|---|---|
| 586 | AnchorBar | fifteen sections, one of them with no subsection at all |
| 587 | AnchorBarWithNumbers | section titles that carry their own counts, `subSectionLayout="TitleOnLeft"` (POST_171, `src/02`) |
| 588 | ObjectPageBeforeNavigate | a `beforeNavigate` veto driven by an edit mode, and the confirm dialog behind it (POST_171, `src/02`) |
| 589 | ObjectPageBlockViewTypes | the same block authored four ways — typed, JSON, HTML and XML |
| 590 | ObjectPageFormFocusableInput | `ColumnElementData` cell spans and a Focus action onto the first editable input (POST_171, `src/02`) |
| 591 | ObjectPageFormLayout | a `forms:Form` with two `FormContainer`s beside a `SimpleForm` (POST_171, `src/02`) |
| 592 | ObjectPageLazyLoadingWithoutBlocks | twenty-one stashed `ObjectPageLazyLoader`s — lazy loading with no custom block |
| 593 | ObjectPageOnJSONWithLazyLoading | the same heavy block eleven times (POST_171, `src/02`) |
| 594 | ObjectPageSelectedSection | `selectedSection` set statically in the view (POST_171, `src/02`) |
| 595 | ObjectPageState | `useIconTabBar` plus a `sap.ui.table.Table` with a 1.119 row mode (POST_171, `src/02`) |
| 596 | ObjectPageTabNavigationMode | app 594's view minus the one attribute (POST_171, `src/02`) |
| 597 | ObjectPageXML | section titles and subsection modes bound to a state model |
| 598 | ObjectPageSubSectionMultiView | 1..6 unsized blocks per subsection, laid out automatically |
| 599 | ObjectPageSubSectionSized | 359 blocks across 86 subsections, one `columnLayout` each |

**The gate change.** App 592's whole subject is a stashed `ObjectPageLazyLoader`
in a `blocks` aggregation — and the property gate rejects it, because
`ObjectPageSubSection.blocks` is declared `sap.ui.core.Control` while
`ObjectPageLazyLoader` extends `sap.ui.core.Element`. The declaration is simply
under-tight: `ObjectPageSubSection.addAggregation` opens with
``if (oObject instanceof ObjectPageLazyLoader)`` and either stashes it or
unwraps its content (ObjectPageSubSection.js:1337). This is the same shape as
batch b47's `columnmenu.Menu.items` — the metadata says one thing, the control
does another — but that one had a workaround and this one does not: satisfying
the rule would mean deleting the sample.

So the sidecars grew a fourth escape hatch, `property_gate`, deliberately
**narrower** than the three that already existed (`render_smoke`,
`data_fidelity`, `structural_diff`). It must NAME the finding types it covers —
`validate-meta` rejects a blanket skip — and a named type that does not fire is
stale and fails the port, exactly like a stale render skip. One port uses it,
for one type. The chain config gained the matching `invalid-aggregation-child:
false`: the finding is judged in `meta/`, and this file has no access to that
judgement.

Three more findings:

- **A sample can reference blocks the demo kit does not publish.** App 597's
  view pulls `sap.uxap.testblocks.multiview`, `.objectpageblock` and
  `.mixedblock`, plus a `sap.uxap.sample.Headers.block` — UI5 *test* resources
  and an unpublished sample, referenced by this one view and shipped nowhere.
  Three of the four are IMPROVISED and labelled as such in the view itself; the
  fourth is not invented, because `sap.uxap.sample.ObjectPageSubSection` ships a
  `MultiViewBlock` of its own (app 116 ports it) whose Collapsed view is the
  honest content.
- **Two attributes in that sample do not exist and never did.**
  `ObjectPageSection.icon` and `ObjectPageSubSection.icon` are in neither the
  1.71 metadata nor 1.151's; upstream XMLView drops them with a log line. They
  are DROPPED, not reproduced — the first `DROPPED_171` in this corpus raised by
  a property that was never there rather than one that arrived late.
- **A static sorter is data-fidelity's problem, not the view's.** App 595 binds
  its rows with `sorter: { path: 'Name' }`. The first draft seeded the 123 mock
  rows already in Name order — and the gate compares them POSITIONALLY against
  the mock, so all 123 failed. The fix is the app 298 idiom rather than a skip:
  seed the mock's own order verbatim and `SORT` in `model_init`, which also
  makes the sorter's field an honest fifth column of the ABAP table.

What the batch mostly is, though, is the same fifteen `SharedBlocks` inlined
over and over: apps 263, 588, 594, 595 and 596 carry byte-for-byte the same
section tree, and 587 and 593 most of it. Where they differ is one attribute
each — `selectedSection`, `beforeNavigate`, `subSectionLayout` — which is
exactly what the demo kit is demonstrating, and exactly what makes the sidecars
worth reading: the deviation lists are near-identical on purpose, and the one
NOTE that differs is the sample.

## 2026-08-22 — batch b48 (sap.f): the nine that were left, and the library is done (apps 577–585)

Every unported `sap.f` sample in one batch, which finishes the library at
**34 / 34**: four more `FlexibleColumnLayout` router apps, the two `GridList`
design samples and the three `ShellBar` ones.

| app | sample | what it adds |
|---|---|---|
| 577 | FlexibleColumnLayoutColumnResize | `autoFocus` / `restoreFocusOnBackNavigation` and a two-column resize (POST_171, `src/02`) |
| 578 | FlexibleColumnLayoutWithFullscreenPage | the full-screen column and the way back out of it |
| 579 | FlexibleColumnLayoutWithOneColumnStart | the reference three-column port: twelve bound `columnsDistribution` sizes, six navigation actions, sort / search / add |
| 580 | FlexibleColumnLayoutWithTwoColumnStart | the same app that STARTS on two columns — the mid column is bound before the first render |
| 581 | GridListBoxContainerReal | three `GridBoxLayout` box widths and a static gallery of recommended box content |
| 582 | GridListKeyboardArrowsNavigation | `borderReached`, four `GridItemLayoutData` span pairs, a slider that drives the container width |
| 583 | ShellBarProductSwitch | `sap.f.ProductSwitch` in a popover anchored on the button the event ships (POST_171, `src/02`) |
| 584 | ShellBarWithFlexibleColumnLayout | a `ShellBar` as the `customHeader` over the whole FCL |
| 585 | ShellBarWithSplitApp | a `ToolPage` with a bound `sideExpanded` and a `NavigationList` side navigation |

Four findings, and one repeat of a trap that has now cost three batches:

- **The five-view router app folds to one view, and the structural diff's whole
  missing/extra pairing is a PREFIX shift.** Apps 578–580 and 584 each archive
  five `view.xml` files with three different default namespaces (`sap.f` in
  FlexibleColumnLayout.view.xml and DetailDetail.view.xml, `sap.m` in
  List.view.xml and AboutPage.view.xml, `sap.uxap` in Detail.view.xml). One
  abap2UI5 view has ONE default namespace, so every control that was defaulted
  in its own file now carries a prefix — `ObjectPageLayout` becomes `uxap:`,
  `DynamicPage` becomes `f:`, `Avatar` and `ColumnListItem` lose their `m:`.
  Nothing is added or dropped; the counts just move between prefixes. Each of
  the four sidecars says so in one deviation rather than one per control.
- **`FlexibleColumnLayoutSemanticHelper` is JavaScript, so the six navigation
  buttons derive their visibility from the layout itself.** The samples bind
  `visible="{= ${/actionButtonsInfo/midColumn/fullScreen} !== null }"`, which
  is a model the helper writes. The ports read the same three states off the
  `layout` property directly: full-screen while that column is not full screen,
  exit-full-screen while it is, close while it is open.
- **Seed the control's documented default for every field the sample leaves
  absent** — the same defect class the e2e sweep found the day before, met
  here BEFORE it could bite. App 579's `columnsDistribution` model has twelve
  sizes and the sample seeds three; a flat ABAP row would send nine empty
  strings into `sap.f.FlexibleColumnLayoutData`. All twelve are seeded now, the
  nine with the value the control would have used anyway.
- **A sample's own private helper is a DROPPED_171, not an IMPROVISED.** Both
  GridList samples ship `RevealGrid/RevealGrid.js` — a debugging aid that reads
  the computed grid template off the rendered DOM and lays an overlay div over
  each cell. There is no control behind it and no server-side state to toggle,
  so the `Reveal Grid` ToggleButton keeps its label and loses its `press` in
  apps 581 and 582 alike.

Two smaller ones from app 582. `onSliderMoved` does
`byId("container").setWidth(value + "%")` on every `liveChange`; the port makes
the slider's `value` two-way bound and the `CSSGrid` width an expression over
it (``{= ${...} + '%' }``), so the width follows the slider in the BROWSER —
faster than a round trip per keystroke and, unlike one, lossless. And the
sample's actual subject, the keyboard hand-off BETWEEN the four grids, is an
IMPROVISED: `onBorderReached` compares `getBoundingClientRect()` geometry
across all four lists and calls `focusItemByDirection(direction, row, column)`
on the winner. Neither half travels. The port keeps the toast the sample also
shows, so arrow keys still navigate within a grid and still report when they
run out of it.

The repeat: **the right-hand name of a `WHERE` resolves to the COLUMN**, so a
local variable must not share it (`WHERE category = category` matches every
row). App 578 hit it after apps 520 and 524 did. It stays cheap to make and
invisible until the data is wrong, which is why every occurrence gets a comment
naming the two earlier ones.

## 2026-08-22 — the first full e2e sweep of the calendar batches: five port defects and a harness rule

The e2e harness was rebuilt after batch b46 and every port of b44, b45 and b46
was run against it for the first time. Nine of the thirty failed. Five were
real port defects, four were wrong assertions in the interaction modules —
and the four teach the same three things about reading a running abap2UI5 app.

**The port defects.** All five are the same shape: *a flat ABAP row serializes
EVERY field, so a property the sample leaves ABSENT arrives as an empty string
or a string where a number belongs, and UI5 rejects the value and terminates
the app.* The static render gate cannot see it because it mocks the model.

- `secondaryType` on a `DateTypeRange` (apps 541, 553) and `type` on a
  `RecurrenceRule` (apps 548, 555): empty string against an enum. Where the
  enum has a neutral value the port now seeds it (`None`); where it has none
  (`RecurrenceType` is Daily/Weekly/Monthly/Yearly, `RecurrenceRuleType` is
  DayOfMonth/DayOfWeek) the binding became ``{= ${X} || null }`` — UI5's
  `validateProperty` maps `null` to the property's default, which is exactly
  what "the field is absent" means in the sample's own JSON.
- `nonWorkingDays` / `nonWorkingHours` / `RecurrenceRule.days` (apps 537, 548,
  555): an `int[]` bound to a table of STRINGS serializes to `['5','6']`, and
  UI5 answers `"5,6" is of type object, expected int[]`. The tables are integer
  tables now. This also closes app 537's `render_smoke.skip` reasoning: the
  nesting was never the whole story.

**The harness rules.** Three of them, all about counting controls:

- **A bound aggregation's TEMPLATE is a live Element.** `Element.registry`
  always holds one row, one list, one item more than the model has, so an exact
  count from the registry is off by one and an `.every()` over it fails on the
  template (which has no binding context). Count through the aggregation —
  `pc.getRows()`, `ff.getLists()`, `list.getItems()`.
- **A JSONModel's default `sizeLimit` is 100.** A table bound to the 123-row
  product mock renders 100 rows — in the ORIGINAL too. Only app 567's sample
  sets a limit of its own (3) and app 558's raises it to 200.
- **A button in an `OverflowToolbar` may not be in the DOM at all**, so a
  text or title locator times out; fire it through the registry by id.

And one timing rule: a press fired while a round trip is still in flight is
dropped. Two selections in a row need the first to come back before the second
is sent (app 558).

## 2026-08-22 — batch b47 (sap.m): the Table family, all eleven that were left (apps 566–576)

Every unported `sap.m.Table` sample in one batch, which finishes the control:
the drill-down, the two column-width tables, the drag-and-drop pair, the
editable one, the column header menus, the merged cells and the master/detail
app that only pretends to be a table sample.

| app | sample | what it adds |
|---|---|---|
| 566 | TableBreadcrumb | a three-level hierarchy drill-down with a bound `Breadcrumbs.links` |
| 567 | TableColumnWidth | two tables whose `columns` aggregation is BOUND to a column array |
| 568 | TableContextualWidthStatic | `contextualWidth` as a bound property |
| 569 | TableDnD | rank-based drag and drop between two tables, both bound to one collection |
| 570 | TableEditable | a read-only and an editable row template, swapped by an `IF` |
| 571 | TableIColumnHeaderMenu | four column header menus; the sample's own `MenuBase` subclass cannot be defined from ABAP |
| 572 | TableLayout | `fixedLayout` per table, page and dialog |
| 573 | TableMergeCells | `mergeDuplicates` + `mergeFunctionName`, made to merge by the supplier sorter |
| 574 | TableMultiSelectMode | `itemActionCount` / `ListItemAction` / `sap.m.table.Title` (POST_171, `src/02`) |
| 575 | TableScrollToIndex | the corpus's first `sap.f.FlexibleColumnLayout` — a master/detail app (POST_171, `src/02`) |
| 576 | TableVerticalAlignment | `vAlign` rows with an Input in a cell |

Five findings, three of them about the view-builder reconstruction rather than
the ports:

- **A secondary chain must be BALANCED or no gate ever sees it.** App 570's
  footer hung off a captured `page` node and ended inside two open elements;
  the reconstructed view came back with no `<footer>` at all — the render gate,
  the property gate and the structural diff all judged a view that was missing
  it. A root chain may end unbalanced; a `node->…` statement may not. Close it
  with ``)->end(`` down to the node you started from.
- **An attribute whose value is a METHOD PARAMETER is invisible the same way.**
  Also app 570: an Edit form built by a helper that took the four binding
  strings reconstructed as `<Input type="Text"/>` with no `value` at all. The
  linter resolves literals and ``client->_bind( <attribute> )``, not
  parameters. Inline the attributes, or the gates check a different view than
  the one that ships.
- **Two branches of an `IF` are BOTH emitted into the reconstruction.** App 570
  shows eight cells in a four-column row, app 569 shows one table where the
  sample has two (a helper called twice is emitted once). Neither is wrong at
  runtime — but the same merge makes a conditional `items` attribute an
  *error*: "items is set twice on the same control". Hoist the value into a
  `COND` and set the attribute once (app 569).
- **`sap.m.table.columnmenu.Menu.items` is metadata-single.** The UI5 source
  omits `multiple: true` and relies on `ManagedObject`'s default of true, but
  the metadata snapshot records what the source says, so a Menu with two
  `ActionItem`s is rejected. `QuickAction.content` does carry the flag — which
  is where app 571's two sort buttons and three align buttons went, and it is
  the better fit anyway.
- **`t_products[ rank = 0 selected = abap_true ]` reads as a table INDEX to
  abaplint** (`invalid_table_index`, "Table index starts from 1"). Putting a
  non-numeric key first — `[ selected = abap_true rank = 0 ]` — parses fine.
  Same table expression, same semantics.

Three upstream slips are recorded in the sidecars rather than reproduced: app
574's `oTable.setMultiSelectionMode(...)` (the property is `multiSelectMode`,
so that setter does not exist) and its `itemActionPress="onItemActionPress"`
without the leading dot, and app 576's `type="{Text}"` / `fieldWidth="{60%}"`,
which are path bindings to fields that do not exist.

## 2026-08-22 — batch b46 (sap.m + sap.f): the popup-and-page tail (apps 556–565)

Ten samples with nothing in common but their shape: each one builds most of its
UI in a controller and shows it in a popup or a second page, so the port is
mostly a matter of rebuilding what the demo kit's `view.xml` does not contain.

| app | sample | what it adds |
|---|---|---|
| 556 | DatePickerMassEdit | a selection-gated Edit button and the mass-edit dialog behind it |
| 557 | FacetFilterCustomFilters | `lists="{…/Filters}"` kept BOUND, with the group's own values nested one level down |
| 558 | TabContainerMHC | the corpus's first `sap.m.TabContainer`, built over a bound items aggregation |
| 559 | DynamicPageAnalyticalTable | a `sap.ui.table.Table` in a `f:DynamicPage`, plus a numeric card in a popover |
| 560 | DynamicPageWithWizard | app 535's branching wizard, this time inside a `f:DynamicPage` |
| 561 | DialogWithinArea | three dialogs from one parameterised builder; `Popup.setWithinArea` has no declarative form |
| 562 | DialogWithMessagePopover | app 065's message handling, moved into a Dialog, with the severity formatters RESTORED |
| 563 | MessageViewInsidePopover | app 284's MessageView, anchored in a `Popover` instead of a Dialog |
| 564 | MessageViewInsideResponsivePopover | the same, in a `ResponsivePopover` with an `endButton` |
| 565 | PopoverNavCon | a `NavContainer` inside a popover; `bindElement` folded to root-seeded fields |

Five findings:

- **`sap.m.TabContainer` has no default aggregation.** App 558's item template
  as a direct child produced `Cannot add direct child without default
  aggregation` and the view never rendered. The template has to sit in an
  explicit ``)->ele( `items` )`` next to the `items` binding — the render gate
  caught it, the static gates did not.
- **A view-builder attribute whose value is a METHOD PARAMETER is invisible to
  every gate.** App 558 first built its Edit form in a helper taking the four
  binding strings; the reconstructed view came out with `<Input type="Text"/>`
  and no `value` at all, because the linter resolves literals and
  `client->_bind( <attribute> )`, not parameters. Nothing failed — the form was
  simply absent from the property gate, the render gate and the structural diff.
  Inline the attributes, or the gates are checking a different view than the one
  that ships.
- **The demo kit's shared `forms.json` has no `recipient` node**, so app 562's
  fragment title `Hello {/recipient/name}` renders a bare `Hello ` in the
  ORIGINAL. Confirmed against the upstream file rather than guessed; the port
  keeps the binding shape over an empty field so it renders identically. The
  rest of that mock is byte-equivalent to the snapshot the sibling sample
  (app 065) already carries.
- **The severity formatters app 065 dropped are portable after all.** App 562's
  `buttonIconFormatter` / `buttonTypeFormatter` / `highestSeverityMessages` scan
  the message list for the highest severity — a domain computation, so it runs
  in ABAP and feeds the button's bound `icon`, `type` and `text`. `btn_type` is
  seeded `Default`: an empty string would override the `sap.m.ButtonType` enum
  default and reject the whole view, the same trap b45 hit with `AvatarColor`.
- **Two advisory ratchets had been red since earlier batches.** `b43` landed
  apps 533/535's per-keystroke `liveChange` wires and `b45` landed apps 553/554's
  tooltip-less legend buttons, neither with a budget raise — so `view-gates
  --strict` has been failing on the committed tree for three batches. Both
  budgets are raised here with dated comments naming every port, rather than
  quietly re-baselined. b46 itself adds one `live-event-roundtrip` (app 560,
  inherited from app 535) and no accessibility debt: every icon-only button it
  ports got a tooltip.

## 2026-08-22 — batch b45 (sap.m): the calendar tail — three PlanningCalendars and seven SinglePlanningCalendars (apps 546–555)

The rest of the PlanningCalendar family plus seven of the nine
SinglePlanningCalendar samples, including the three heaviest ports the corpus
has: two create/edit dialogs and a details popover apiece.

| app | sample | what it adds |
|---|---|---|
| 546 | PlanningCalendarDnD | three roles gating drag / resize / create per row; the drop, resize and drag-create round-trips |
| 547 | PlanningCalendarModifyAppointments | one dialog serving create, create-with-context and edit; the owner change and the interval-header route |
| 548 | PlanningCalendarRecurringItem | `RecurringCalendarAppointment` @1.149 and `RecurringNonWorkingPeriod` @1.127 (POST_171, `src/02`) |
| 549 | SinglePlanningCalendar | the flagship: details popover, modify dialog, legend popover, three drag actions, more-link |
| 550 | SinglePlanningCalendarWeekNumbering | `calendarWeekNumbering` @1.110 on the single calendar (POST_171, `src/02`) |
| 551 | SinglePlanningCalendarSnappingHeader | `firstDayOfWeek` @1.98 — an INT fed from a Select's string key (POST_171, `src/02`) |
| 552 | SinglePlanningCalendarWithCustomViews | two custom view CLASSES, which a backend cannot define |
| 553 | SinglePlanningCalendarWithLegend | the legend in a `DynamicSideContent` with seven coloured special dates (POST_171, `src/02`) |
| 554 | SinglePlanningCalendarWithZoomInZoomOut | `scaleFactor` @1.99 stepped by two buttons (POST_171, `src/02`) |
| 555 | SinglePlanningCalendarRecurringItem | the recurrence stack plus a fourteen-field create dialog (POST_171, `src/02`) |

Four findings, two of them caught by the e2e harness rather than the gates:

- **An enum-typed property bound to an EMPTY field takes the whole view down.**
  App 531's QuickView seeded `backgroundColor` only on the page that has one;
  the other page sent the empty string, and UI5 answered `"" is of type string,
  expected sap.m.AvatarColor` — the app terminated. The static render gate never
  saw it because it mocks the model. Seed the UI5 DEFAULT explicitly on every
  row (`Accent6` here, `Circle` for app 532's `displayShape`), the way app 100
  already does for `QuickViewGroupElement.target`.
- **A view emitted from backend state has to be re-sent when that state
  changes.** App 526's drop handler reordered its order table and nothing moved:
  `view_display( )` only runs on init and navigate, so the client kept the old
  child order. The e2e run caught it; app 436 had the answer since b34 — call
  `view_display( )` again after the state change.
- **`SinglePlanningCalendar.selectedView` is an association, like
  `Wizard.currentStep`.** App 549's more-link should switch to the Day view; the
  association neither binds nor has a whitelisted setter, so that half is
  declared IMPROVISED while the date change survives. This is the same finding
  b43 recorded for the Wizard — the association rule is not control-specific.
- **The family's recurring theme: the property is bindable, so the handler is
  not needed.** Across ten ports, `calendarWeekNumbering`, `firstDayOfWeek`,
  `stickyMode`, `fullDay`, `scaleFactor`, `groupAppointmentsMode` and the three
  `enableAppointments*` flags all replace a controller setter with a shared
  field. Where the property is an INT and the Select's key is a string
  (`firstDayOfWeek`), the expression multiplies by 1 — the `Number( )` the
  original calls.

## 2026-08-22 — batch b44 (sap.m): the PlanningCalendar family, ten of thirteen (apps 536–545)

The first FAMILY batch since the sap.m tail: ten of the thirteen unported
`sap.m.PlanningCalendar` samples, all `covered-control(1)` rows over the one
port (app 108, PlanningCalendarSingle) that already covered the control.

| app | sample | what it adds |
|---|---|---|
| 536 | PlanningCalendar | `primaryCalendarType` @1.108 / `secondaryCalendarType` @1.109 and `rowHeaderPress` @1.119 (POST_171, `src/02`) |
| 537 | PlanningCalendarViews | four custom views, the non-working-day toggle over a bound `specialDates`, `groupAppointmentsMode` |
| 538 | PlanningCalendarMulti | `singleSelection="false"` — the interval push reaches EVERY selected row |
| 539 | PlanningCalendarOneLine | `appointmentHeight` @1.81 + `multipleAppointmentsSelection` @1.97 with a bound badge (POST_171, `src/02`) |
| 540 | PlanningCalendarMinMax | `minDate` / `maxDate` through the same date formatter |
| 541 | PlanningCalendarWithLegend | the legend in a `DynamicSideContent`, `DateTypeRange.color` @1.76 / `secondaryType` @1.81 (POST_171, `src/02`) |
| 542 | PlanningCalendarWithStickyHeader | `stickyHeader` with `showWeekNumbers` and the built-in views box |
| 543 | PlanningCalendarAppointmentSizes | `appointmentHeight` + `appointmentRoundWidth` @1.81 driven by two Selects (POST_171, `src/02`) |
| 544 | PlanningCalendarWeekNumbering | `calendarWeekNumbering` @1.110 with its four schemes (POST_171, `src/02`) |
| 545 | PlanningCalendarRelativeViews | `PlanningCalendarView.relative` + `intervalSize` @1.93 (POST_171, `src/02`) |

The family's shape is the same everywhere: a `startDate` plus rows of
appointments and interval headers, every date a JS `Date` the model cannot
carry, so all ten use the `Formatter.DateCreateObject` idiom app 108
established. What each sample adds on top is a handful of PlanningCalendar
PROPERTIES the controller sets imperatively — `primaryCalendarType`,
`groupAppointmentsMode`, `firstDayOfWeek`, `appointmentHeight`,
`appointmentRoundWidth`, `calendarWeekNumbering`,
`multipleAppointmentsSelection`, `builtInViews`, `standardItems` — and every
one of them is BINDABLE. So the recurring port move in this batch is: bind the
property, let the Select or ToggleButton share the same field, and drop the
change handler entirely.

Three findings:

- **The data is mechanical, so the transcription should be too.** These
  controllers inline hundreds of `UI5Date.getInstance(y, m, d, h, min)`
  appointments, with month 0-based and some values deliberately out of range
  (`"4", "33"` — JS normalises it to June 2). A converter that evaluates the
  literal with a stubbed `UI5Date` and prints local ISO strings gets every row
  right; hand-transcription would not. The data-fidelity gate compares what
  ends up seeded, and all ten passed first time.
- **A nested scalar table is not a scalar array to the static harness.** App
  537 binds `PlanningCalendarRow.nonWorkingDays` (int[]) to a table nested
  inside the bound row; the render harness mocks every nested table as an array
  of ROW OBJECTS, so UI5 rejects it. A ROOT-level scalar table is mocked
  correctly — app 490 binds one to `selectedKeys` and renders clean — so this is
  the harness's nesting rule, and app 537 carries a declared `render_smoke.skip`
  saying exactly that until the e2e harness confirms it against the real backend.
- **A string[] property needs an ARRAY from an expression binding, not a
  comma string.** App 541's `standardItems` first got
  `{= … ? 'Today,Selected,NonWorkingDay' : … }` and UI5 answered "Invalid value
  … must contain values from sap.ui.unified.StandardCalendarLegendItem": the
  comma splitting is XML-attribute syntax, not expression semantics. An array
  literal inside the expression (`['Today','Selected','NonWorkingDay']`) is what
  the binding needs.

## 2026-08-22 — batch b43 (sap.f + sap.m): the covered-control(1) head of the backlog (apps 526–535)

The first batch after the sap.m tail ran out. Every row is a
`covered-control(1)` entry — the three GridContainer samples, the free-style
SemanticPage, the GenericTag toolbar, the two QuickViews and the three
Wizards — so this is depth on controls the corpus already covers once.

| app | sample | what it adds |
|---|---|---|
| 526 | GridContainerDragAndDrop | a drop that reorders TEN STATIC grid children — the port emits them from an order table the round-trip rewrites |
| 527 | GridContainerDragAndDropFromList | drag and drop BETWEEN a List and a GridContainer, both model-bound |
| 528 | GridContainersNavigation | four grids, seven integration cards rebuilt declaratively, `borderReached` |
| 529 | SemanticPageFreeStyle | the full semantic action bar plus the `device>` model driving the two full-screen actions |
| 530 | OverflowToolbarSimple | ten OverflowToolbars resized by ONE expression binding; every `OverflowToolbarLayoutData` priority |
| 531 | QuickViewAvatarConfiguration | `QuickViewPage.avatar` @1.92 with a badge icon resolved per row (POST_171, `src/02`) |
| 532 | QuickViewNavOrigin | `navOrigin` — the clicked link's text travels and ABAP swaps page 2 (POST_171, `src/02`) |
| 533 | WizardSingleStep | a Wizard in a Dialog, `renderMode="Page"` @1.84 and `navigationChange` @1.101 (POST_171, `src/02`) |
| 534 | WizardCurrentStep | two nested XMLViews inlined into one view; linear and branching wizards side by side |
| 535 | WizardBranching | `enableBranching` driven by `setNextStep` round-trips; the shopping-cart flow end to end |

Four findings, three of them new to the corpus:

- **`Wizard.currentStep` is an ASSOCIATION, so it cannot be bound.** The XML
  parser takes the attribute's value as a control id and never as a binding, so
  `currentStep="{/CURRENT_STEP}"` becomes an id nothing answers to. Backend-driven
  wizard navigation goes through the framework's whitelisted `control_by_id`
  calls instead — `goToStep`, `setNextStep`, `discardProgress` are all in
  `CONTROL_METHODS` — which is what apps 533, 534 and 535 use.
- **An expression binding needs `${…}`, and the ABAP form is `${ … }` inside a
  string template.** `|\{= { client->_bind( x ) } … \}|` produces
  `{= {/X} … }` — a binding inside an expression, which UI5 rejects with
  "Unexpected === at position 4". The `$` has to be written literally before the
  embed: `|\{= ${ client->_bind( x ) } … \}|`. Apps 530, 533 and 535 all had
  it wrong first; app 124 has had it right since b12.
- **A `sap.ui.integration.widgets.Card` manifest is an object or a URL, nothing
  else.** Two of the three GridContainer samples keep several manifests in ONE
  file under wrapper keys (`{manifests>/listContent/mediumList}`), which neither
  form can address from a declarative view. Apps 526 and 528 rebuild each card
  as a declarative `sap.f.Card` carrying the manifest's own `card:Header` and
  its content — a List, a Table, a DisplayListItem list for the Object card, a
  VBox for the AdaptiveCard. App 342's URL trick only works where the sample
  ships one manifest per file.
- **An aggregation tag carries the namespace of its CONTROL, not of the view.**
  ``)->ele( `items` )`` under an `f:GridContainer` emits `<items>` in the
  default `sap.m` namespace and UI5 goes looking for `sap/m/items.js`; it has to
  be ``)->ele( n = `items` ns = `f` )``. The same slip is invisible under a
  `sap.m` control, which is why it took app 527 to surface it.

## 2026-08-22 — batch b42 (sap.m): ten ports, five of them post-1.71 (apps 516–525)

| app | sample | what it adds |
|---|---|---|
| 516 | SegmentedButtonVSD | a SegmentedButton opening a ViewSettingsDialog; `confirm` carries the dialog's `filterString` |
| 517 | GenericTileAsLaunchTile | eleven launch tiles — `frameType` OneByHalf/TwoByHalf @1.83, `url` @1.76, `appShortcut`/`systemInfo` @1.92 (POST_171, `src/02`) |
| 518 | ObjectHeaderActiveAttributes | the feedback Dialog built in a chain, plus `ariaHasPopup` @1.97 (POST_171, `src/02`) |
| 519 | MultiComboBoxSuggestionsAndValueState | six value states and the `formattedValueStateText` aggregation @1.78 (POST_171, `src/02`) |
| 520 | NotificationListGroupLazyLoading | `sap.m.NotificationList` @1.90 (POST_171, `src/02`); the lazy fill on expand kept as a round-trip |
| 521 | InputKeyValue | `textFormatMode="KeyValue"` with a value help pre-filtered by the Input's value |
| 522 | ListLoading | `enableBusyIndicator` + a refresh press that re-reads the bound rows |
| 523 | TableSelectCopy | the CellSelector @1.119 (POST_171, `src/02`); the CopyProvider **dropped** — see below |
| 524 | ListDeletion | `mode="Delete"`; the row's description travels and the row leaves the bound table |
| 525 | ListGrowingUpwards | `growingDirection="Upwards"` over the full mock collection |

Three findings, one of them a correction to an earlier port:

- **A control can refuse to be created without a JS callback.** App 523's
  `sap.m.plugins.CopyProvider` was first ported with the plugin kept and only
  `extractData` declared IMPROVISED, on the reading that it would then copy in
  some default format. It does not: UI5 throws `extractData property must be
  defined for Element sap.m.plugins.CopyProvider` at CREATE time and the WHOLE
  view goes down with it. The plugin is therefore dropped, not improvised-
  around, and the sidecar says so. When a JS callback cannot be registered, ask
  whether the control tolerates its absence before declaring it improvised.
- **`URLHELPER` is its own event target, not a `control_global` object.** App
  518 first wired `URLHelper.redirect` as
  `cs_event-control_global` + ``( `URLHELPER` ) ( `redirect` )``, which the
  frontend rejects silently (the accepted globals are MESSAGE_TOAST,
  MESSAGE_BOX, VIEW_SLOTS, ROUTER, BUSY_INDICATOR, THEMING, POPUP,
  INVISIBLE_MESSAGE, FORMATTING). The redirect goes through
  `cs_event-urlhelper` with ``( `REDIRECT` ) ( `{ URL: '…', NEW_WINDOW: true }` )``,
  as apps 073 and 084 already did.
- **`DELETE itab WHERE col = col.` compares the column with itself** — the
  b37 finding, found twice more here (apps 520 and 524) and once in an older
  port (app 085, fixed in this batch). The right-hand name inside WHERE always
  resolves to the COLUMN, never to the like-named local, so the statement
  empties the table. Name the event-arg variable `del_<col>`. The whole corpus
  was swept for the shape; those three were all of it.

## 2026-08-22 — batch b41 (sap.m): ten ports, four of them post-1.71 members (apps 506–515)

| app | sample | what it adds |
|---|---|---|
| 506 | IconTabBarDragDrop | `enableTabReordering` with `maxNestingLevel` @1.79 driven by a StepInput (POST_171, `src/02`) |
| 507 | InputGrouping | a **grouping** sorter on both a plain and a tabular suggestion binding |
| 508 | ListToolbar | `sticky` bound to the MultiComboBox selection; the info toolbar hidden by an expression over the toggle |
| 509 | InputSuggestionsOpenSearch | the OpenSearchProvider + MockServer replaced by a backend search filling the bound items |
| 510 | InputCustomValueHelpIcon | `valueHelpIconSrc` @1.84 (POST_171) plus the SelectDialog value help |
| 511 | SelectChangeEvents | `Select.liveChange` @1.100 and the change event's `previousSelectedItem` @1.95 (POST_171) |
| 512 | MultiInputModelUpdate | one table serving tokens, suggestions AND the model list the sample watches |
| 513 | ObjectHeaderResponsiveII | the `fullScreenOptimized="false"` sibling of app 453 |
| 514 | FlexBoxSizeAdjustments | five FlexBox panels plus the sample's own `style.css` |
| 515 | InputAssisted | a value help pre-filtered by the Input's current value, shared by two Inputs |

The recurring shape of this batch is the **JS callback that owns a control's
data**: an OpenSearchProvider (509), a validator (512), a value-help dialog
that filters its own binding (510/515). All four resolve the same way — the
data moves to the backend and the wire that fed it becomes a round-trip or a
`binding_call` — and the sidecars say which half of the original's behaviour
that costs.

App 512 is the one worth remembering: the sample keeps THREE things in sync
(the tokens, the suggestion items and a List showing the model), and the port
binds all three to ONE table. That is not a shortcut — it is what the sample is
demonstrating, and the port makes it structural rather than a handler.

## 2026-08-22 — batch b40 (sap.m): ten ports and the JS-callback tail (apps 496–505)

The batch where the remaining sap.m samples stop being view-only. Six of the
ten reproduce a JavaScript callback the framework cannot register, and each one
says in its sidecar exactly which half of the behaviour survives.

| app | sample | what it adds |
|---|---|---|
| 496 | TreeJSONLazyLoading | lazy tree loading: the item context PATH travels, ABAP parses it and appends the level below |
| 497 | ListSwipe | the swipe direction rewrites the bound swipe button; the swiped row is removed by index |
| 498 | ListActions | `itemActionCount` + `ListItemAction` @1.137, the Slider and the count sharing one field |
| 499 | ListSelectionSearch | `binding_call` search filter plus a selection count over a bound row flag |
| 500 | StandardNoMargins | two element-bound ObjectHeaders folded to root fields |
| 501 | MultiInputValidators | three `addValidator` callbacks re-expressed as backend `change` handling, including the confirm round-trip |
| 502 | ObjectHeaderTitleSel | the popover list moving the header's binding CONTEXT — folded to a copied root record |
| 503 | InputKeyValueTabularSuggestions | tabular suggestions; the row validator's key taken straight off the selected row |
| 504 | MultiInputTokenUpdate | the validator switch with `START_TIMER` standing in for its three `setTimeout`s |
| 505 | TableOutdated | a reused COMPONENT (`sap.m.sample.Table`) inlined, with `showOverlay` bound |

Two findings, both already in the corpus and both re-learned the hard way:

- **A bound aggregation needs its aggregation tag when the control's default
  aggregation is something else.** `sap.m.MultiInput`'s default aggregation is
  `suggestionItems`, so a `Token` template directly under it is rejected —
  apps 501 and 504 rendered `Missing template or factory function for
  aggregation tokens` until the template moved inside ``)->ele( `tokens` )``.
  App 085 got away without it because its control is a `Tokenizer`, whose
  default aggregation IS `tokens`. Same lesson as b37's IconTabBar, different
  control.
- **``IF client->get_event( ) <> `X`. RETURN.`` reads as a dead wire.** The
  linter's `event-without-handler` check looks for the event name in an
  affirmative dispatcher (``= `X` `` or ``WHEN `X` ``); the negated guard app 496
  first used matched nothing, so a fully handled event was reported as raised
  and never handled. Write the dispatcher the way the recipe prescribes.

`START_TIMER` earned its second use: app 504's asynchronous validator adds its
token after 3 seconds and its second one after 10, and the framework's timer
reproduces both without a client-side callback. What stays lost there is the
PASTE path the sample is written around — one `tokenUpdate` for three tokens at
once, where the port sees one `change` per value.

## 2026-08-22 — batch b39 (sap.m): ten ports, three of them post-1.71 picker properties (apps 486–495)

| app | sample | what it adds |
|---|---|---|
| 486 | ObjectHeaderTitleActive | the fragment popover anchored to the active title via `openBy` + `$event.oSource.sId` |
| 487 | PanelSticky | `stickyHeader` @1.117 over two 20-paragraph panels (POST_171, `src/02`) |
| 488 | TableNavigated | `ColumnListItem.navigated` @1.72, decided in ABAP per press |
| 489 | SegmentedButtonDialog | a `SegmentedButton` inside a `popup_display` dialog |
| 490 | MultiComboBox | the selection pair: a client-composed `selectionChange` toast and a `selectionFinish` list built in ABAP over bound `selectedKeys` |
| 491 | MultiComboBoxClearIcon | the same with `showClearIcon` @1.96 |
| 492 | ListGrouping | the grouping sorter kept, `groupHeaderFactory` declared as the control-factory boundary |
| 493 | ComboBoxLazyLoading | the suspended-OData lazy load expressed as a `loadItems` round-trip that fills the empty table |
| 494 | ComboBoxMaxPickerHeight | `maxPickerHeight` @1.150 in three variants over 100 items |
| 495 | MultiComboBoxMaxPickerHeight | the same on MultiComboBox |

**The `selectionFinish` shape is worth remembering.** The original lists the
TEXTS of every selected item, and a UI5 expression argument cannot map an array
of controls — the grammar has no loop, the same wall app 432's `tokenDelete`
hit. The way through is not a bigger expression but a bound PROPERTY: 
`selectedKeys` is two-way bound, so the round-trip already carries the whole
selection and ABAP composes the line. Reach for a bindable property before
trying to transport a collection through an event argument.

`groupHeaderFactory` joins `setFilterFunction` as a documented control-factory
boundary: the port keeps the sorter (so the grouping is real) and lets UI5
render its default group header, with the deviation saying which control the
sample builds that the port does not.

## 2026-08-22 — batch b38 (sap.m): eleven ports, and the JS-callback boundary twice more (apps 475–485)

| app | sample | what it adds |
|---|---|---|
| 475 | ComboBoxValidation | validation stays in ABAP: bound `valueState` + `valueStateText` written on the change wire |
| 476 | ObjectHeaderResponsiveVI | active intro/title links, the row-0 element binding folded to root fields |
| 477 | HeaderContainerOH | an ObjectHeader with a HeaderContainer of eight NumericContents raising one alert |
| 478 | MultiInputCustomFiltering | two MultiInputs whose only difference is a JS filter callback (IMPROVISED) |
| 479 | ComboBoxSearchBoth | `filterSecondaryValues` plus a formatter recomposed in ABAP on a change wire |
| 480 | ListUnread | `showUnread` with the random unread flag made deterministic |
| 481 | MultiComboBoxCustomFiltering | the same JS-callback boundary on two MultiComboBoxes |
| 482 | StandardListItemNavigated | `navigated` @1.72 (POST_171, `src/02`), one row at a time, decided in ABAP |
| 483 | StandardListItemTitle | `bindElement('/ProductCollection')` kept, `{0/…}`..`{3/…}` items with the empty and the missing description reproduced |
| 484 | StandardMarginsEnforceWidthAuto | `sapUiForceWidthAuto` and the device branch on `expanded` |
| 485 | TextAreaMaxLength | `showExceededText` with the ORIGINAL's own valueState expression kept |

Three things this batch settled:

- **A formatter is business logic even when it only joins two strings.** Apps
  479 and 482 both compute in ABAP what the sample computes in a `.formatter`,
  and both needed a wire the original does not have (a `change` on the ComboBox,
  a `press` carrying `${PRODUCTID}`) because a backend-composed value has to be
  told when to recompute. That added attribute is the honest cost and is
  declared.
- **`setFilterFunction` is the second reliable IMPROVISED of the corpus.** Four
  ports now carry it (470/471/478/481): a JS filter callback has no bindable or
  backend equivalent, so the ports ship UI5's default filtering and say which
  half of the sample's point is lost.
- **A sample can exist without a demo kit sentence.** `ObjectHeaderResponsiveVI`
  ships a complete manifest/view/controller and the coverage scanner offers it,
  but `docuindex.json` lists the family only up to V — so its summary is a
  `written` entry in `ui5/descriptions.json` with the reason, the fourth in the
  corpus.

## 2026-08-22 — batch b37 (sap.m): the IconTabBar/margins tail, 10 ports (apps 465–474)

Ten more, and the batch that produced the most reusable finding of the day.

| app | sample | what it adds |
|---|---|---|
| 465 | IconTabBarOverflowSelectList | 30 tabs the controller builds in a loop → a bound `items` template |
| 466 | IconTabBarStartAndEndOverflow | 50 tabs plus `tabsOverflowMode` @1.90 (POST_171, `src/02`) |
| 467 | IconTabBarInlineIcons | 12 tabs, `headerMode` Inline, the random icon walk made deterministic |
| 468 | StandardListItemIcon | list with sorter and the mock's picture icons |
| 469 | StandardMarginsCollapse | collapsing margins, static |
| 470 | ComboBoxFilteringContains | the custom `setFilterFunction` boundary (IMPROVISED) |
| 471 | ComboBoxFilteringStartsWith | the same boundary, where only the key half is lost |
| 472 | StandardMarginsResponsive | `sapUiResponsiveMargin`, static |
| 473 | InputSuggestionsDynamic | `suggest` → `binding_call` filter on `suggestionItems` |
| 474 | FlexBoxNav | `core:HTML` anchors as flex items plus the sample's `style.css` |

**A bound aggregation needs its aggregation TAG when the control has no default
aggregation.** All three IconTabBar ports rendered as an empty bar with
`Cannot add direct child without default aggregation defined for control
sap.m.IconTabBar` — the template has to sit inside ``)->ele( `items` )``, exactly
as app 087 writes it for the static case. The render gate is what caught it;
`structural-diff` was 0 for all three, because the template control IS there,
just parented wrongly. Worth knowing before the next bound-aggregation port:
Tokenizer (`tokens`) and Select (`items`) have a default aggregation and work
without the tag, IconTabBar does not.

**A JS `setFilterFunction` is a real boundary, not a NOTE.** Apps 470/471 call
it in `onInit` with a callback that matches the term case-insensitively
anywhere in the text OR in the key. There is no bindable or backend equivalent
(the app-authored-JS-function class), so both ports carry UI5's default
filtering and declare what is lost — `IMPROVISED`, not a note about a fold.

Two smaller lessons: a CSS literal glued from one rule per line still needs
splitting at 255 characters (app 474's `.ne-flexbox2 li` rule is 316 on its
own), and the random-icon loop of app 467 is the second "Math.random in a
sample" case of the day — same treatment as app 444, a deterministic walk over
the same list with the deviation saying so.

## 2026-08-22 — batch b36 (sap.m): the ComboBox/Input family, 10 ports (apps 455–464)

Ten small samples in one batch — the ComboBox, MultiComboBox, Input and
MultiInput filtering/suggestion family plus one margins page. They share the
same two mocks, so the batch is mostly the same shape ten times, which is
exactly what makes it cheap: nine of the ten are pure view + data with no wire
at all.

| app | sample | what it adds |
|---|---|---|
| 455 | ComboBoxClearIcon | `showClearIcon` @1.96 (POST_171, `src/02`) |
| 456 | InputAssistedTwoValues | `core:ListItem` suggestions with `additionalText` |
| 457 | MultiInputDatabinding | a bound `tokens` aggregation with a sorter |
| 458 | MultiComboBoxTwoColumnsLayout | `showSecondaryValues` over `core:ListItem` |
| 459 | MultiComboBoxDefaultFiltering | the sorter binding-info on `items` |
| 460 | InputSuggestionsCustomFilter | plain `core:Item` suggestions (the custom filter function stays a JS-only detail) |
| 461 | MultiInputMaxTokens | `maxTokens` with suggestion items |
| 462 | InputValueUpdate | the one wire of the batch: a real per-keystroke round-trip |
| 463 | ComboBoxDefaultFiltering | the 70-row countries mock, `additionalText` = key |
| 464 | StandardMarginsTwoSided | two-sided margin classes, fully static |

**App 462 is the interesting one, and it is deliberately a round-trip.** The
sample exists to COMPARE `oInput.getValue()` with the model property while
`valueLiveUpdate` is off — so the "getValue" Text must follow every keystroke,
and a binding cannot express a value the model does not have yet. The port
carries the live wire and the sidecar says what that costs: abap2UI5 serializes
round-trips, so an event fired while one is in flight is dropped and the Text
catches up when typing pauses. The `live-event-roundtrip` advisory budget rose
6 → 7 for it, with the same rationale the six existing entries carry.

A generator bug worth remembering: padding a field name to a fixed width and
then appending `TYPE` produced `suppliernameTYPE string` in four ports —
abaplint caught it as a parser error, but only because the corpus is linted;
the emitted ABAP looked plausible in a diff.

## 2026-08-22 — batch b35 (sap.m + sap.f): eight ports, three of them the awkward ones (apps 447–454)

The batch where the cheap rows ran out. Four of the eight needed an idiom the
corpus already had but had not combined this way.

| app | sample | the idiom it adds |
|---|---|---|
| 447 | MessageBoxInfo | `message_box_display` with `details` in all three forms — plain text, markup, a JSON object — plus the async-details boundary |
| 448 | SemanticPageDraftIndicator | the semantic FullscreenPage: `MessagesIndicator` + declared `MessagePopover`, the `z2ui5.cc.MessageManager` bridge, and `$event.oSource.getMetadata().getName()` as the toast's own subject |
| 449 | FlexibleColumnLayoutLandmarkInfo | `landmarkInfo` @1.95 on the three-column layout, all three column views inlined (app 234's shape) |
| 450 | FlexibleColumnLayoutLandmarkInfoArrow | the same with the four arrow labels — the pair that only differs in its accessibility attributes |
| 451 | TabContainerIcons | app 093's prevented-default `itemClose` + confirm flow, now with icons, `additionalText` and a `f:Form` per tab |
| 452 | CustomMessageStripDesign | `colorSet`/`colorScheme` @1.143 over ten strips driven by one expression binding |
| 453 | ObjectHeaderResponsiveI | a `binding="{/ProductCollection/0}"` element binding folded to absolute root bindings, with the Currency `parts` binding kept |
| 454 | TableSelectDialogGrowing | one fragment built with two property values (growing / initialFocus), `binding_call` search filter, the sample's OWN `weightState` rule computed in ABAP |

Three findings worth keeping:

- **A wired handler that does not exist.** App 454's fragment wires
  `confirm=".handleClose"` and `cancel=".handleClose"`; the controller defines
  no such method, so both resolve to nothing in the original. The port drops
  both attributes and says so, rather than inventing the close behaviour the
  names suggest.
- **The sample's own formatter beats the shared one.** `Formatter.weightState`
  here compares the RAW measure against 1000/2000 with no unit conversion —
  the opposite of the shared demo kit formatter the porting guide warns about
  (1 and 5 KG, grams divided first). Read the formatter that ships WITH the
  sample.
- **A handler whose first two calls can never be seen.** App 448's
  `handleLiveChange` runs `showDraftSaving( )`, `showDraftSaved( )` and
  `clearDraftState( )` in one tick, so only the clear ever paints. The port
  makes that one call (client-side, so no per-keystroke round-trip) and
  declares the two that have no visible effect as improvised rather than
  pretending to reproduce them.

Both FCL ports moved to `src/02/04`: `landmarkInfo` and
`FlexibleColumnLayoutAccessibleLandmarkInfo` are @1.95, and on the 1.71 floor
the unknown tag would take the whole view down — exactly the case the
aggregation-too-new rule was made an error for.

## 2026-08-22 — batch b34 (sap.m): eight more, and the first e2e closures of the day (apps 439–446)

The same picking rule as b33 — smallest `covered-control(2)` rows once the
cheap `(1)`s were gone — plus the first three LIVE_TESTs of this run closed the
automated way.

| app | sample | the idiom it adds |
|---|---|---|
| 439 | TextEmptyIndicator | `emptyIndicatorMode` On/Auto @1.87 (POST_171) and `toggleStyleClass` on a Panel via `control_by_id` |
| 440 | MenuEndContent | the `endContent` @1.131 menu items, anchored via `toggleBy` from the Button's `dependents` |
| 441 | BreadcrumbsWithoutCurrentPage | the `BreadcrumbsSeparatorStyle` list seeded in enum order; one two-way field on `Select.selectedKey` + `Breadcrumbs.separatorStyle`; six `${$source>/text}` toasts |
| 442 | PDFViewerMultiple | two PDFViewers on one bound `source`, switched by two round-trips; both documents re-hosted on the demo kit host |
| 443 | TextRenderWhitespace | `renderWhitespace` @1.89 over a text whose *content* is the demo: `&#xA;`/`&#x9;` runs written as `\n`/`\t` in a string template |
| 444 | MaxNumberOfNotificationsReached | 400 notifications the controller builds with `Math.random`, rebuilt as a deterministic walk over the same three lists; per-item close deletes its row |
| 445 | TextHyphenation | one `wrappingType` expression shared by five Texts in a `l:BlockLayout` |
| 446 | LinkSubtle | a `sorter` binding-info on the Table plus `subtle` Links and `MessageBox.alert` through `message_box_display` |

**The first automated LIVE_TEST closures of this run:** apps 424, 425 and 427
(batch b32) ran green in the e2e harness with their interaction modules and
`close-live-tests.mjs` converted their entries to `NOTE`s. Every port of b33 and
b34 that carries a `LIVE_TEST` ships its module too, so the backlog only grows
where the harness genuinely cannot reach.

Two housekeeping raises, both deliberate and both the shape the file already
documents: `missing-accessibility` 30 → 31 for app 440's tooltip-less
`endContent` icon Buttons, and app 445 joins the `7bit_ascii` exclude list —
its Bootstrap paragraph contains the sample's own en dash, which is data, not
a typo to fix.

## 2026-08-22 — batch b33 (sap.m): the covered-control(1) tail keeps going, 8 ports (apps 431–438)

Eight more depth ports, picked the way the planning rules say: the smallest
`covered-control(1)` rows first, so every one of them is the second port of its
control rather than the sixth of another.

| app | sample | the idiom it adds |
|---|---|---|
| 431 | ContainerResponsivePadding | `sapUiResponsiveContentPadding` on a Panel with a header Toolbar; the `img>` model folded to the mock's own value |
| 432 | TokenizerMultiLine | `multiLine` + `showClearAll` over a bound Token template; `tokenDelete` @1.82 (POST_171) carrying key **and** count |
| 433 | ContainerPaddingAndMargin | three device-dependent widths as `device>` expression bindings (app 031's shape, three of them) |
| 434 | ContainerPadding | a `core:FragmentDefinition` Dialog via `popup_display`, closed roundtrip-free on both buttons; the `app:` CustomData namespace kept |
| 435 | ProgressIndicatorWithAnnouncement | the id split (`…-button50` → indicator + value) transported via `$event.oSource.sId`, plus the `INVISIBLE_MESSAGE` announcement; `displayAnimation` @1.73 (POST_171) |
| 436 | TreeIcon | a **conditional subtree**: the controller's `new Menu(…)` / `destroyContextMenu( )` becomes a `contextMenu` aggregation the backend emits or omits (app 273's split-chain shape) |
| 437 | TreeSelection | one two-way field shared by `Select.selectedKey` and `Tree.mode` — all five selection modes without a round-trip |
| 438 | RefreshResponsive | the grow-by-one refresh plus the search filter done in ABAP; `PullToRefresh.hide( )` via `control_by_id`; the sample's own touch model folded onto `device>/support/touch` |

Two ports moved to `src/02/01` on a `POST_171` the property gate named
(432 `tokenDelete`, 435 `displayAnimation`) — again nothing the structural diff
could have seen, the same shape as 423/427 in the previous batch.

**0 undeclared structural differences across all eight**, and all six ports
that ship a `LIVE_TEST` ship their `meta/interactions/` module with it
(`validate-meta` reports no interaction gap).

Two things worth keeping:

- **`DELETE itab WHERE key = key` silently compares a field with itself.** App
  432's delete-by-key read the deleted key into a variable named like the
  column; ABAP resolves both sides to the component, so every row matches.
  Renaming the variable is the fix; no gate sees it, and the port would have
  cleared the whole tokenizer on the first X.
- **A conditional subtree is still counted by the structural diff.** App 436
  emits its `contextMenu` only while the toggle is on, but `structural-diff`
  reads the CHAIN, not a render, so Menu/MenuItem show up as `control extra` in
  both states — the deviation says so rather than the gate being worked around.

One more boundary the batch documented rather than improvised around: a UI5
expression argument cannot map an array of controls to their keys (the grammar
has no function literal), so app 432's `tokenDelete` transports the first key
plus the deleted COUNT — enough to tell Clear All from a single X, not enough
for a multi-select delete of a strict subset, which the sidecar declares
`IMPROVISED`.

The `missing-accessibility` advisory budget rose 29 → 30 for app 431's two
icon-only header Buttons, which the demo kit sample itself ships without a
tooltip — the same shape as every earlier raise.

## 2026-08-22 — batch b32 (sap.m): eight depth ports (apps 423–430)

The first slice of the "port the rest" mandate. `--backlog` has no
`NEW-CONTROL` row left that is not a HOLDOUT, so every remaining sample is a
depth port; this batch takes eight sap.m samples whose idiom is distinct from
their control's existing ports, and none of them needed a capability the
corpus did not already have.

| app | sample | the idiom it adds |
|---|---|---|
| 423 | SegmentedButtonContentModes | `contentMode` @1.142 (POST_171, `src/02`) — ContentFit vs EqualSized on one item set, fully static |
| 424 | ToolbarActive | one shared two-way flag drives `CheckBox.selected` and `OverflowToolbar.active`; the constant `press` toast is client-composed |
| 425 | ToolbarEnabled | the same shared-flag shape on `enabled`, which disables every control inside the toolbar |
| 426 | FlexBoxCols | the sample's `style.css` (equal-column min-height, flex-item padding) injected as a `core:HTML` `<style>` leaf |
| 427 | CarouselEmptyMessages | Slider value → `Carousel.width` expression binding (app 418's shape on a new control); `ariaLabelledBy` @1.125 (POST_171, `src/02`) |
| 428 | HeaderContainerNoDividers | `addAriaLabelledBy` over eight `core:InvisibleText`s written as the static association; eight constant client toasts |
| 429 | ListNavType | the element-binding form kept 1:1 — `binding="{/T_PRODUCTS}"` on the List, `{0/…}`/`{1/…}`/`{2/…}` relative on the items |
| 430 | StandardMarginsSingleSided | single-sided margin classes, fully static (the sample's model is never bound) |

Two ports moved to `src/02/01` on their first `POST_171` (423, 427) — the
`view_gates` property check named both members, which is the folder rule
working as designed: neither was visible in the structural diff.

**Every port has 0 undeclared structural differences**, and the three ports
that ship a `LIVE_TEST` (424, 425, 427) ship their `meta/interactions/` module
with it rather than adding to the interaction gap — the two shared-flag wires
and the slider-driven width are exactly the classes the harness already covers
(`sliderDrivenWidth`, the two-way-bound-property class).

## 2026-08-17 — the open requests leave `pr/`, and the ecosystem gets four backlogs

`pr/` held five open requests aimed at **three different upstreams** —
open-abap-core, the abaplint transpiler, the abap2UI5 linter and the framework
— with nothing in the folder distinguishing them, and it held them in the wrong
repository: a request about the framework was findable only by somebody who
already knew this corpus existed. Meanwhile the same kind of finding was being
written down in two other shapes elsewhere: upstream compiler bugs as bullets
in STATUS.md, linter rule candidates as prose in the framework's skills. Three
shapes, three repositories, and no way to answer *"what is there to file
against abaplint"* without reading all of them.

All five moved to `abap2UI5/abap2UI5` under
[`backlog/`](https://github.com/abap2UI5/abap2UI5/tree/main/backlog), which sorts
items into four generated pages by where each one gets filed — OPEN-ABAP,
ABAPLINT, ABAP2UI5-LINTER, ABAP2UI5 — with the item file itself written to be
pasted into an issue as it stands. The pages are generated from the items and
from `**Backlog:**` lines in the skills, so the analysis stays next to the
defect that produced it and the backlog fills itself; converting an item into
an issue stays a human step, and a shipped one is deleted rather than kept as a
row (the rule `pr/README.md` already had, now enforced by a gate).

**What stays here** is `pr/README.md`'s Implemented and Declined tables. They
are this repository's own record — every row came out of a port in `meta/`, and
`CAPABILITIES.md` cites them when it says a capability exists because somebody
asked for it. The two STATUS.md open-abap bullets now carry only what THIS
repository has to undo when each patch lands upstream; the analysis lives in
the item.

## 2026-08-13 — namespace `dmo` → `smpc`, the red badges, and why the nightly went red

Three unrelated pieces of housekeeping, one of which turned into a real
finding.

**The object namespace is `z2ui5_cl_smpc_`.** The repository is
`samples-controls`; the prefix still carried the generic `dmo` of the
ai-demokit days, which said nothing about which corpus an object belongs to
in a system that also pulls `samples` (`Z2UI5_CL_SMP_`). Mechanical
throughout — 1387 files renamed, plus the abaplint `object_naming` patterns,
the generators and gate scripts, the `meta/` sidecars and interaction
modules, the fixture corpus, the four generated artefacts and the committed
Pages bundle. The full offline chain is clean at the new names (abaplint on
both the standard and cloud configs, pattern-lint, validate-meta,
structural-diff --strict, data-fidelity, the tooling tests, view-gates
--strict 416/416).

**Four badges were reporting on the CI, not on the code.** ABAP_702 and
auto_downport both run `npm run downport` under a 10-minute budget; the step
needs ~44 passes of the downport rule and 300+ more of `definitions_top` at
416 ports, so every run since the corpus outgrew that died mid-step and the
badges read "cancelled". e2e_nightly takes ~40 min against a 45-minute
budget — six of the last twelve nightlies were cancelled timeouts rather
than verdicts. bump_a2ui5 had never succeeded: it ran `npx playwright
install` before any `npm ci`, so npx fetched the current release and
installed THAT browser build, node-setup's own `npm ci` then put the pinned
playwright in place, and the smoke asked for a build nobody had downloaded.
Budgets raised (60/60/90), `npm ci` moved first, and every action re-pinned
to its current release.

**The nightly's 27 failing ports are a transpiler gap, not broken ports.**
The 2026-08-11 nightly was green at 365 ports; the first one after the
corpus renamed its 439 `_event_client( )` wires to `follow_up_action( )`
failed 27. `follow_up_action( )` tells its view-wired form from its
statement form with `IF result IS SUPPLIED`, which is correct ABAP — for a
RETURNING parameter the predicate is true exactly when the method is called
functionally, and on a real server the corpus works. The transpiler does not
model it: it compiles the predicate to `(INPUT && INPUT.result)` and emits
the same call shape for both forms, so the wired branch is dead code. From
the actual built backend:

```js
// the caller (app 003, a wired press)
v: (await this.client.get().z2ui5_if_client$follow_up_action({val: …, t_arg: temp1}))
// the callee
async z2ui5_if_client$follow_up_action(INPUT) { …
  if ((INPUT && INPUT.result)) {          // no caller ever sets it
```

So every handler written into a view attribute arrives as the empty string
and the control reaches the browser with no handler at all — app 049's e2e
says it outright, *"no StepInput carries a change handler"*. Reproduced on
the pinned transpiler 2.13.40 and the newest published 2.13.59, so it is not
a stale pin. The Pages demo runs the same transpiled backend, which means
the breakage was live for its users, not only in CI.

Filed as `pr/transpiler-returning-is-supplied` (minimal repro + emitted JS +
the proposed change: pass the returning slot in `INPUT` when the result is
consumed). Until it lands, `web/ci/patch_follow_up_action.mjs` rewrites the
CONSUMED form back to `_event_client( )` — the same wire without the second
role, so there is nothing for it to detect — **in the build copy only**, in
both transpiled builds, exactly the shape of the open-abap XML patch beside
it. 431 call sites: 430 in the corpus, one in the framework's own
`z2ui5_cl_app_startup` (`open_new_tab`). The committed corpus keeps
`follow_up_action( )`; the classification was verified exhaustively over the
corpus (430 consumed · 129 statement · none spanning lines · the remaining
10 occurrences are prose inside the overview app's generated notes).

Measured end to end, not argued: the unpatched build reproduces the
nightly's failures locally (003, 008), and the patched build over the same
corpus reports **417 app(s), 0 failing** — all 27 gone, including the two
`Maximum call stack size exceeded` page errors (016/256, an empty `press=""`
reaching UI5) and app 233, which had been red since 2026-08-09 for the same
reason on a wire that already used the new name.

## 2026-08-12 — batch b08 (uxap): the whole covered-control(1) tail of sap.uxap, 10 ports (apps 408–417)

The corpus-wide breadth phase is done — `--backlog` offers no `NEW-CONTROL`
row that is not a HOLDOUT — so this batch is the depth phase's cheapest
slice: **all ten sap.uxap samples whose control has exactly one port**
(`covered-control(1)`), closing the BlockBase, ModelMapping,
HeaderFacetPattern and ObjectPageHeader families' n=1 tails in one PR.
sap.uxap moves 21 → 31 of 45. Every port green on the full chain (abaplint
×2 here + 702 in CI, pattern-lint, validate-meta, structural-diff --strict,
data-fidelity, view-gates --strict incl. render).

| app | sample | the idiom it adds |
|---|---|---|
| 408 | ObjectPageBlockBase | `columnLayout` blocks as `core:HTML` leaves; ConfigModel prefix-drop + `subSectionLayout` toggle round-trip |
| 409 | BlockBaseBlockInBlock | a block instantiating a block — both levels inlined to ONE nested-div `core:HTML` leaf |
| 410 | BlockBaseEventing | the block-event indirection (`fireDummy` on `oParentBlock`) folded to one wire via `$event.oSource.getParent().getParent().sId`; `html:div` wrappers → classed `m:VBox` |
| 411 | MPModelMapping | the static-path `ModelMapping` sibling of app 230, same root-fold, IMPROVISED per the config-control-drop rule |
| 412 | ObjectPageWithLinksAndObjectStatus | QuickView fragment 1:1 via `popover_display`, enum-default seeding, `setSelectedSection` association via `control_by_id` |
| 413 | ProfileObjectPageHeader | classic header with `navigationBar` Bar — fully static, the dead `ObjectPageModel` stays unseeded |
| 414 | AlternativeProfileObjectPageHeader | `showHeaderContent` two-way bound; unsaved-changes ResponsivePopover anchored via `$event.oSource.sId` |
| 415 | ObjectPageHeaderWithAllControls | ALL classic-header members; two anchored popover fragments, one chain per fragment; `buttons` named model folded |
| 416 | ChildObjectPage | `isChildPage` + breadcrumbs; the `.onFormat` controller formatter computed in `model_init` |
| 417 | ObjectPageDynamicSideContentBtn | `DynamicSideContent` around an ObjectPage: bound `showSideContent`, `breakpointChanged` t_arg, `SET_FOCUS` follow-ups |

The `missing-accessibility` advisory budget rose 52 → 55 for the three
alt-less profile/social `sap.m.Image`s the ObjectPageHeader samples ship
without alt (413/414/417) — same shape as every earlier raise, an alt would
be invented text. Nothing else in the batch needed a new capability: the
established BlockBase-inlining, popover-fragment and named-model-fold
idioms carried all ten, which is the depth-phase signal working as
intended. The ten LIVE_TESTs join the interaction backlog (the advisory
count in `validate-meta`).

## 2026-08-12 — sap.tnt closed at 100 % (app 407, UI5 runtime 1.150 → 1.151) plus two backlog one-liners

Three small items from the STATUS.md backlog, one commit:

- **App 298's trailing-`.0` dimensions are fixed** — `Width`/`Depth`/`Height`
  went from `p LENGTH 4 DECIMALS 1` to `TYPE string` (the `port-a-sample`
  rule for display-only values with variable decimals in a text template;
  app 377 already did it on the same mock). The three fields are bound only
  into the `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}` template, so nothing
  else changes; the port now renders `30 x 18 x 3 cm` like the original.
- **App 089's dead device binding is fixed** — `expanded="{device>/isNoPhone}"`
  bound a demo-kit helper property the framework's raw `device>` model does
  not carry, so it resolved to nothing; now the app-030 expression
  `{= !${device>/system/phone} }`, and the sidecar NOTE says so instead of
  calling the verbatim form intentional.
- **`sap.tnt.sample.SideNavigationSearch` is ported (app 407, batch b09)** —
  the last in-scope sap.tnt sample; the library is the seventh at 100 %.
  The sample's core feature (`SideNavigationSearchField`, `filterSection`,
  `highlightedText`, `announceSearchMatchCount`) is entirely `@since 1.151`,
  so **the `@openui5` runtime pin moved 1.150.0 → 1.151.0** (1.151.0 is the
  newest npm release; the metadata snapshot was already 1.152) — the full
  `view-gates --strict` run passes all 406 ports on the new runtime, 0
  regressions, advisory counts unchanged. The port resolves the
  `navigationItemFactory` server-side: the `/navigation` top level (one item,
  two groups) is declared statically, each `NavigationListGroup` binds its
  items table with the factory's item shape as a two-level bound template,
  and the search filters the tables in ABAP on the `liveChange` round-trip —
  `highlightedText` and the field's `value` share one two-way bound variable,
  so the highlight follows the filter for free. Filtered fixed items stay in
  the `fixedItem` section instead of merging into the main list (declared
  IMPROVISED, like the factory resolution itself). `announceSearchMatchCount`
  runs as a `control_by_id` action with the count computed like the
  original's `_countItems`; the quick-create Dialog is a 1:1
  `popup_display` fragment.

## 2026-08-12 — the samples-repo control-sample backlog is closed here (36 ports, apps 367–402)

The curated [samples](https://github.com/abap2UI5/samples) repo carries 98
1:1 demo kit rebuilds under `src/01/03` ("Control Library") plus three retired
ones under `src/00/99`. Matched against `api.md` on the sample id, **57 of
those 101 already had a port here** — the same original rebuilt twice across
the two repos — and **43 were still backlog**. This session ports the backlog
half so the redundancy can be resolved in favour of this repo.

**36 of the 43, not all 43.** Six are HOLDOUT samples (`ui5/holdout.json`:
BusyIndicator, Label, MessageStrip, RadioButtonGroup, RatingIndicator,
SearchField) and porting them from an existing reviewed implementation would
destroy exactly the measurement they exist for — `scaffold.mjs` refuses them
and that refusal is correct. The 37th, `sap.m.sample.PlanningCalendar`, sits in
the samples repo's retired `src/00/99` and belongs to a separate decision.

Five batches, every one green on the full gate chain (abaplint ×3,
pattern-lint, validate-meta, structural-diff --strict, data-fidelity,
view-gates --strict incl. the render gate):

| batch | apps | family |
|---|---|---|
| `src/01/b25` | 367–376 | input/text value states and wrapping |
| `src/01/b26` | 377–383 | the whole IconTabBar family |
| `src/01/b27` | 384–391 | combo/multi-input wrapping, tiles, SegmentedButtonLI |
| `src/01/b28` | 392–400 | FlexBox, OverflowToolbar, Panel, Carousel, Image, ObjectHeader |
| `src/03/b07` | 401–402 | the two remaining sap.uxap ObjectPage samples |

Nothing new had to be invented: every idiom the 36 needed already had a
precedent in the corpus, which is the useful signal. 377 reuses app 298's
123-row products mock, its ABAP-computed `weightState` and its verbatim
Currency parts binding, and turns `onFilterSelect`'s nested
`sap.ui.model.Filter`s into an ABAP filter driven by `${$parameters>/key}`.
378–381 express the demo kit's `{device>/isNoPhone}` helper model as
`{= !${device>/system/phone} }` (app 030). 388/389 follow app 275 for the tile
family's two shared idioms — the one-rule `style.css` through a `core:HTML`
style leaf and the constant-text `MessageToast` as a client toast. 397–401 fold
the named `img>` model into inlined, host-absolutized asset URLs (app 031).
401/402 are the SharedBlocks shape app 261 established: every `BlockBase`
inlined to its own view content, and 401's six `uxap:ModelMapping` elements
folded onto default-model root fields (app 230).

**One gate bug found and fixed.** `structural-diff.mjs`'s tag-body pattern only
skipped **double**-quoted attribute runs. `sap.m.sample.InputWrapping` writes
its `core:Item` texts in single quotes and one of them contains a `"`
(`text='7" Widescreen …'`), which opened a double-quote run that swallowed the
tag boundary and merged the following sibling into that tag: the gate read
**2 of 3** `core:Item`s and reported a correct port as `control extra`. Both
quote styles are handled now, on the tag and on the attribute level. The fix
changes no existing port's verdict (137 → 137 ports with diffs, 0 undeclared
both before and after) — 18 archived originals use single quotes somewhere, but
only this one has an embedded double quote.

**Advisory ratchet 45 → 50.** Five more alt-less `sap.m.Image`s and icon-only
`Button`s (apps 395/397/399/401), each alt/tooltip-less in the demo kit sample
itself — the same shape as the two earlier raises, so supplying one would
invent text the original does not have.

**Two pre-existing findings surfaced on the way** (recorded in STATUS.md, not
touched here): app 298 types the products mock's `Width`/`Depth`/`Height` as
packed `DECIMALS 1`, which renders the mock's integer `30` as `30.0` in the
`{WIDTH} x {DEPTH} x {HEIGHT}` template — app 377 uses `TYPE string` per the
spec's own rule for that case; and app 089 keeps `expanded="{device>/isNoPhone}"`
verbatim, a path the framework's `device>` model does not carry.

## 2026-08-10 — the INTERACTIONS map becomes one module per port, and the map had a silent duplicate

The ~1200-line hand-authored `INTERACTIONS` map inside `scripts/e2e-smoke.mjs`
is externalized to `meta/interactions/<class>.mjs` — one module per port,
default-exporting the untouched `async (page, expect) => { … }`; shared
assertions moved verbatim to `scripts/lib-e2e.mjs`; the driver just loads the
directory. The migration was mechanical and is proven: a new
`--dump-interactions` mode prints every loaded interaction (key + source), and
the dump before/after the split is **identical for all 105 effective
entries**.

105, not 106 — the extraction found the map carried **two**
`z2ui5_cl_smpc_app_133` keys. A JS object literal keeps the LAST duplicate
key, so the older entry (SegmentedButton `selectionChange` → bound
`GridList.mode`) had been silently dead since the 2026-08-01 faked-event-value
fix added the second one; nothing ever reported it. The same trap class as the
duplicate `"branch"` keys in the 702 abaplint config (also this session, see
`check_pins`): a duplicate key in a keyed literal is invisible to every
consumer that parses it. The per-file layout makes it impossible by
construction — the map is keyed by FILENAME now. The shadowed leg is kept as
a comment in `meta/interactions/z2ui5_cl_smpc_app_133.mjs` pending a merge
decision (it exercises a different wire than the surviving entry).

`validate-meta` now guards the directory: an orphan module (no port sidecar)
is a hard error; a port with an open LIVE_TEST deviation but no module is an
**advisory** gap count — the 2026-08-04 "every LIVE_TEST port has an
interaction" state no longer holds (the since-added batches, apps 299–366,
ship 61 LIVE_TESTs with no interaction yet), so the check reports instead of
failing every batch commit. `close-live-tests.mjs` reads the directory
instead of regexing the smoke script.

## 2026-08-10 — completed backlog items relocated from STATUS.md

STATUS.md keeps only OPEN work now; every closed `[x]` backlog item moved
here verbatim (seven items, each with its closing date in its own text).
As everywhere in this journal, the numbers inside them are snapshots of
their date — the current counts live in STATUS.md's generated state block.

- [x] **IMPROVISED harvest — 10 requests implemented, every probe measured, REWORK empty**
  (2026-08-05). The repo's purpose is to expose framework gaps, but the gaps
  were sitting in 136 `IMPROVISED` sidecar texts while `pr/` held exactly one
  open request. All 136 are now classified — repeatably, by
  `node scripts/probes/improvised-cluster.mjs` (`--family <key>` re-reads the
  evidence of one family, `--strict` fails on an unclassified entry, which is
  the ratchet for the next batch; deliberately not in `npm run gates`):

  | Verdict | at the harvest | today | Meaning |
  |---|---:|---:|---|
  | GAP | 15 | **0** | a framework gap — 10 requests filed across three sweeps, **all implemented upstream the same day**, and the last two entries turned out not to be gaps (below) |
  | PROBE | 16 | 1 | a *suspected* gap whose premise is unverified — measure before filing |
  | REWORK | 16 | **0** | expressible today; the port under-delivers — **empty since 2026-08-06** (115 and 118, the two big rebuilds, are done) |
  | BOUNDARY | 16 | 18 | outside abap2UI5 by nature (client-only APIs, sample-local JS, the deterministic-corpus rule, a deliberately unoffered resize round-trip) |
  | POLICY | 73 | 8 | a decided corpus rule; the rest are `NOTE`s now (see below) |

  The **POLICY half was the headline number**: 73 of 136 improvisations were
  the thin frontend, the single default model, mock flattening and BlockBase
  inlining doing what they were decided to do — behaviour-identical, and
  therefore `NOTE`s rather than `IMPROVISED`. **Retyped 2026-08-05** by
  `--retype-policy --write`, which is safe because a gate declaration matches
  the deviation TEXT, never its type (`structural-diff.mjs`, `d.what`). The
  retype is not blind: an entry whose text still NAMES a loss is **held back**
  and listed — 8 of the 73 were (app 261's dropped Expanded view, 267/269's
  lost model indirection, 012's routing, the BlockBase wrappers that lose their
  ids). `IMPROVISED` now means what it says — a behaviour of the original that
  is lost or substituted — and the count reads **39** instead of 136.

  **Implemented upstream + consumed by the corpus** (details in the
  `pr/README.md` Implemented table; each port's sidecar deviation moved from
  `IMPROVISED` to `NOTE`): `_bind( omit_initial )` → app **049** is the
  sample's one bound template again instead of 14 unrolled items ·
  `CONTROL_METHODS css` → apps **138/267/269** resize their `sap.m.Page`
  container from the Slider again · `controlIdOrNull` → app **263** clears the
  association instead of naming the first section · `INVISIBLE_MESSAGE` → app
  **289** announces its regenerated strip · `FORMATTING` → app **196** renders
  its two custom currencies with 4 and 5 decimals · `setSticky` is whitelisted
  but see the correction below.

  **Two premises did not survive contact with the code, and both are recorded
  rather than quietly dropped:**
  - `table-set-sticky` claimed the bound-array path was unproven. **App 009
    binds `sticky` to an ABAP string table and is live-verified**, so it was
    proven all along. The whitelist entry still closes a footgun (an imperative
    `setSticky` silently received a string), but apps **022/235** — which
    deleted the sticky Label + three CheckBoxes from their view — are plain
    REWORK against app 009's pattern, not gap victims. Open, in the rework
    backlog below.
  - `model-empty-vs-default` was filed as one request and needed **two**
    changes. `omit_initial` is all-or-nothing per bind, and a boolean that must
    send `false` cannot live with that (`abap_false` IS initial, so the filter
    drops it and the control falls back to its default `true`) — app 049's
    rebuild ran into it the moment it was written. The scoped form
    (`omit_initial_paths`) followed the same day, so 049 binds
    `enabled`/`editable` plainly again and has **no binding-value deviation
    left**; `pr/` now holds only the open-abap request.

  **All three pins are on feature branches and MUST become main SHAs before
  this change is merged**: `A2UI5_PIN` points at the abap2UI5 branch commit,
  the three abaplint configs carry a `"branch"` on the abap2UI5 dependency
  (without it `_bind( omit_initial )` and `s_ctrl-prevent_default_expr` are
  syntax errors to ABAP_STANDARD/CLOUD/702), and `@abap2ui5/linter` is pinned
  at the commit that mirrors the new global targets, the `eBP` stub and the
  `/media/range` model path.

  **Re-pinned 2026-08-10 for `_bind( json = abap_true )`** (the
  `card-manifest-object` request, implemented upstream). Same rule, same three
  places, and the 702 config needed a real fix rather than a re-point: it still
  carried the `"branch"` of the already-merged-and-deleted
  `ai-demokit-next-steps` branch **next to** its own `"branch": "702"` - two
  keys for one dependency, the first of them pointing at a branch that no
  longer exists. It is now a single key on the current feature branch. At merge
  time it goes back to `"702"`, and only after the framework's `auto_downport`
  has rebuilt that branch from the merged main - until then the 702 branch
  cannot know the new parameter.

  **The PROBE families are the open work** (the biggest one is now measured and closed) — each is a plausible gap that a
  measurement could refute, and this repo's rule is that a request is filed on
  evidence, not on a rationale (cf. the withdrawn `urlhelper-abap-api`, whose
  premise was simply wrong — and now `table-set-sticky`, whose premise was half
  wrong). In descending value:
  - ~~`event-value-unreachable`~~ **measured and closed 2026-08-05** — it was
    the biggest family (7 deviations) and it was **not a gap at all**.
    `scripts/probes/event-arg-expression-probe.mjs` boots real OpenUI5, wires
    each candidate the way the framework emits it, fires the event and reports
    what the handler received: **all six candidates resolve** — indexed access
    into an array-valued getter, indexed access into an array PARAMETER,
    chained calls, arithmetic, `.join( ',' )` over an array, and a class-name
    ternary. Six of the seven ports are reworked (see the journal): the four
    calendar ports (139/151/177/220) now report the **clicked day** instead of
    the server date — including 177's re-click deselect, reproduced through a
    `getSelectedDates().length > 0` guard in the wire — 228 composes the
    sample's full submenu/MenuTextFieldItem branch in one expression, and 186's
    two resize toasts carry their pane-size arrays. App **109** keeps its
    name-only `selectedDatesChange` toast: that parameter is an array of
    `DateRange` CONTROLS the original iterates and formats **per entry**, and
    the expression grammar has no loop (the same boundary as app 060's
    breadcrumb). Its sidecar is corrected to say that instead of "control
    references are not transportable".
  - ~~`imperative-aggregation`~~ **closed 2026-08-05** — none of the four was a
    gap. Two measurements did it: `removeToken`/`removeItem` accept an **ID
    string**, and UI5 runs a **`;`-separated pair** of event handlers. 203 folds
    the tokenizer the sample's add/delete work on into a bound aggregation and
    removes the other three tokenizers' static tokens by id; 076/077 remove the
    notification AND toast its title on one event; 241's Create button appends
    a row to a now-bound NavigationList.
  - ~~`event-veto`~~ **half closed 2026-08-05, the residual filed the same
    day**. App 136's rationale predated `s_ctrl-check_prevent_default` (merged
    2026-07-30): the flag is baked per wire at render time, which is enough
    there because the DIRECTION of the next toggle is known — an expanded panel
    can only collapse — so the flag is the switch that applies, and the
    round-trip re-bakes it. App **247** is the genuine residual: its veto is per
    **column** while the flag is per wire, and `columnResize` is declared on the
    Table, not the Column. Now `pr/conditional-prevent-default` — see the second
    sweep below.
  - ~~`window-resize-event`~~ **measured and filed 2026-08-05** as
    `pr/live-device-model` — see the second sweep below.
  - ~~`shortcut-scope`~~ **closed 2026-08-06** — filed and implemented the same
    day as `keyboard-shortcut-scope`. The registry was keyed by key combination
    alone, so a second registration of the same combo replaced the first and a
    popover-local command could not shadow the page-level one — which is
    exactly what app 232's sample demonstrates, with its own toggle for the
    difference. `cs_event-keyboard_shortcut` now takes a view slot as an
    optional third `t_arg` and dispatch picks the innermost OPEN scope, so 232
    registers `Ctrl+S` twice (unscoped → `SAVE`, popover-scoped → `PSAVE`) and
    its last residual deviation is closed.
  - ~~`template-clone-id`~~ **measured and closed 2026-08-06**, and the
    measurement changed the request. Three sidecars called an aggregation
    template's clone ids *nondeterministic*;
    `scripts/probes/aggregation-item-probe.mjs` shows they are not — UI5 mints
    `<templateId>-<parentId>-<index>` and they survive a model refresh **and** a
    reorder. The real gap is that the parent id carries the view prefix the
    framework assigns at runtime (`v1--tpl-v1--car-0`), which the backend never
    sees. So the fix is not "make the ids stable" but "resolve where the prefix
    is known": every control-resolving argument kind now accepts
    `<id>/<aggregation>/<index>` (`aggregation-item-address`, implemented
    upstream), and app 012 re-syncs its two Carousels again. **PROBE is down to
    one entry** — app 109's per-entry `DateRange` formatting, which the
    expression grammar has no loop for.

  **REWORK** adds three entries to the review backlog below that were not in
  it: app 166 (semantic action toasts + the missing `Messaging.addMessages`
  seed, expressible via `cc.MessageManager`), app 233 (a compound
  `binding_call` OR-filter and `open(searchValue)` both shipped, both unused)
  and apps 022/235 (the sticky controls, per the correction above).

  **Second sweep 2026-08-05 — two more requests, both measured first.** The
  question "are there any NEW request ideas left in the corpus" was answered by
  probing the two leftover families that had a mechanism behind them rather than
  a rationale. Both premises held, so both are filed:
  - **`live-device-model`** (**implemented upstream the same day**) — the shared `device>` model is
    `new JSONModel(Device)`, wrapping the LIVE `sap.ui.Device` object. Device
    mutates itself on resize/rotation, but a JSONModel only notifies its
    bindings when told, so it never is: `scripts/probes/device-model-live-probe.mjs`
    drives a real viewport from 1400px to 420px and reads the rendered binding
    back — `{device>/resize/width}` stays **`1400`**, and one `refresh(true)` on
    Device's own handlers makes it **`420`**. Eleven ports bind this model, so
    the change is unusually cheap for its reach. Two honest findings came with
    it: `{device>/system/phone}` is correctly STATIC (UA/screen based — a
    narrowing desktop window is not a phone), so the eleven ports' branches are
    right as they are and the request must not claim them; and the media RANGE,
    which is what a live breakpoint branch actually wants, has **no bindable
    path at all** (`Device.media` is methods only) — so the request adds
    `/media/range` alongside the refresh.
  - **`conditional-prevent-default`** (**implemented upstream the same day**) — the veto flag is a boolean baked per
    WIRE, so it cannot block one row/column and let the rest through the same
    event (app 247). The proposal reuses the mechanism that is already there: a
    `$`-prefixed value is emitted raw and resolved by
    `BindingParser.parseExpression`, so the veto can be an EXPRESSION.
    `scripts/probes/conditional-veto-probe.mjs` measures the proposed `eBP`
    signature against real OpenUI5 — **one** `columnResize` wire, **one**
    predicate, two columns: the blocked one is vetoed
    (`fireColumnResize` → `false`), the free one goes through, and both still
    round-trip with an identical payload.

  Both landed as `s_ctrl-prevent_default_expr` and a refreshing device model
  with a new `{device>/media/range}` path, and the corpus consumed them the
  same day: app **247** vetoes its delivery-date column again (and reports the
  column LABEL, which the reduction had also dropped), app **168**'s
  `attachLayoutChange` class swap is a live expression binding. App **012**
  is honestly NOT closed — its page count feeds a server-side slice, so a
  client-side count would desync the props it indexes; its sidecar says so.
  A third correction came out of the same round: the `ternary-with-newline`
  candidate had recorded that **a double quote cannot appear in an event-arg
  expression**. It can — that was measured on RAW XML, while
  `z2ui5_cl_util_xml` escapes every attribute value, so the parser never sees
  a bare quote. The `double-quote-escaped` candidate proves it (`"[" + n + "]"`
  → `[7]`), and CAPABILITIES no longer claims the boundary.

  **GAP reached zero on 2026-08-06**, and neither of the last two entries was
  closed by a framework change — both were closed by measuring.
  - App **250**'s `handleLiveChange` was written off as *"direct DOM
    manipulation outside any bindable property, not expressible in the thin
    frontend"*. The original paints the button's ICON by writing `rgba(…)` onto
    `getDomRef().firstChild.firstChild`, and the `css` action deliberately
    writes only on a control's OWN node. But a probe against real OpenUI5 shows
    the icon span **inherits** `color` from the button root — same computed
    colour, no internal DOM touched. The wire is roundtrip-free: the `rgba()`
    string is composed on the client from the four `liveChange` parameters. The
    verdict had been reached too quickly.
  - App **012**'s resize recalculation is reclassified as a **BOUNDARY**.
    Closing it would need a resize → BACKEND event wire, and that is
    deliberately not offered: it is chatty by construction, and every
    display-only case it would serve is already covered by the live device
    model without a round-trip. The one case it genuinely serves is 012's, where
    the count feeds a server-side slice — one port is not enough to file on, so
    the idea is recorded in the sidecar for the second sample that needs it.

  **App 118 closed the REWORK column on 2026-08-06**, the second of the two
  big rebuilds. It had been a single `widgets:Card` with an INVENTED manifest;
  it is now the whole `sap.ui.integration.sample.CardsLayout` page — the
  `f:ShellBar` with its menu and profile, the four-tab `IconTabBar`, and both
  `f:GridContainer`s with all **eight** integration Cards, their
  `GridContainerItemLayoutData` and the sample's `layout`/`layoutS` settings.
  The eight manifests come from `model/cardManifests.json` verbatim, each bound
  as a model field — the JSON must never enter the view XML, where a leading
  `{` reads as a binding. Two things stay declared: the `component` card's
  manifest is a URL to a UI5 Component (abap2UI5 has no place to ship one, so
  whether it loads is the host's CORS decision), and the structural-diff skip
  is **re-worded** — the archived folder carries `componentCard/View.view.xml`,
  which the diff unions into the original side, exactly app 120's shape.

  **A classifier defect fell out of the next sweep (2026-08-06), and it cut
  the count by six.** Two families were matching text that says the port
  AVOIDED their problem: `empty-vs-default` caught "initialized to 'None' so
  no empty string reaches the enum", "the expression can never emit an empty
  enum value", "a harmless string property, no enum/default override" — four
  ports filed as gap victims for *working around the gap correctly* — and
  `array-property` still carried apps 022/235's claim that "neither an array
  property binding nor a setSticky whitelist entry is a proven path", which
  had been false when it was written (app 009 binds it and is live-verified)
  and which those ports' own views had already disproved: both have the
  sticky Label and the three CheckBoxes back. Both patterns are tightened,
  the six sidecars corrected rather than deleted, and a new
  `random-determinism` family holds app 289 — a randomised original becoming a
  deterministic rotation IS a substitution, so it stays `IMPROVISED`, but as a
  BOUNDARY: the determinism is a corpus requirement no framework change would
  ever close. **31 IMPROVISED, and only 2 GAP entries left** (250's internal
  DOM reach, 012's server-side page slice).

  **The two new wires are e2e-verified, and the e2e found a design error in
  one of them** (2026-08-06). App 232's interaction failed on the first run:
  the shortcut scope had been built as a VIEW SLOT only, and the sample's
  Popover is a CONTROL declared in the view's dependents and opened with
  `openBy` — it never enters the framework's popover slot, so the scoped
  registration could never fire and Ctrl+S kept hitting the page command. The
  upstream change now takes a control id as a scope too (a control scope beats
  a slot scope, being the more specific statement), and both interactions pass
  against a real browser and a transpiled backend: 232 goes silent on Ctrl+S
  with the popover's own Save off and the popover open, and 247 vetoes exactly
  the delivery-date column through the same wire that lets every other column
  resize. This is the second time an e2e interaction caught something no unit
  test could — the first was the sap.tnt hollow pass on 2026-07-30.

  **The full sweep is green: 294/294, `--strict` exit 0.** It first reported
  two failures, and both turned out to be the INTERACTIONS, not the ports —
  which is worth writing down, because a wrong interaction is a false alarm
  that costs exactly as much as a real one.
  - App **241** clicked `getByText('Building')`. The sample renders its
    NavigationList **twice** (an expanded and a collapsed copy), so "Building"
    exists twice as an aggregation-template clone and the click landed on
    whichever copy the DOM offered first — no round-trip, no toast. It now
    fires `press` on the item that actually carries the wire.
  - App **049** drove its StepInput with ArrowUp+Enter, which no longer
    produces a `change` on this UI5 version. It keeps the keyboard route and
    falls back to firing `change` through the control API, reading the value
    back off the control so the asserted text is still the control's own.

  Before that was known, the two were checked against this session's framework
  changes by elimination rather than assumed innocent: with the new `eBP`
  signature patched back to its old form in the transpiled backend they still
  failed, and with the device model's refresh handlers removed on top of that
  they still failed. A premise was refuted on the way — the suspicion that
  UI5's `EventHandlerResolver` would choke on the bare `true` the flag form now
  emits in `eBP`'s condition slot. It resolves fine, and a probe candidate now
  proves it.

  A build trap cost about an hour and is written down in E2E.md so it does not
  again: `npm run e2e:build` and the framework's own `npm run verify` downport
  into the SAME two directories, and running them concurrently left 86 files
  under abap2UI5's `src/` rewritten to their v702 form, with nothing in either
  command's output saying so.

  **Two new linter rules, 2026-08-06**, distilled from traps this session hit
  rather than from the corpus (neither fires on any of the 295 files — both are
  things the corpus has avoided by hand so far, which is exactly what a rule
  should make impossible to hit again). `trailing-empty-event-arg`: `get_t_arg`
  buffers an empty argument and flushes it only when a later non-empty one
  follows, so an empty entry BETWEEN filled ones keeps its slot and a TRAILING
  one disappears — the handler's `get_event_arg( n )` reads initial with no
  error anywhere. That is what forced the second half of the
  `control-method-null-arg` fix upstream, and the framework's padding covers a
  nullable declared kind on a control method only, never a backend `_event`.
  `json-literal-in-attribute`: UI5 parses a leading `{` as a binding, so a raw
  JSON object literal in a view attribute is read as a binding path and the
  attribute ends up empty — the classic way to lose an integration Card's
  manifest, which is why app 118 keeps its eight in the model.

  **A linter defect fell out of app 115's rebuild**, and it was silent:
  `aggregationPath` matched the first `path:` with a GREEDY `[^}]*`, which
  runs past a nested object — there is no `}` before `sorter: {` — and
  captured the INNER path. So `{path:'/CATEGORIES', sorter:{path:'NAME'}}`,
  the ordinary sorted aggregation, resolved against `/NAME`, the row shape
  came out null, and **every relative field below such an aggregation stopped
  being checked**. One lazy quantifier fixes it, and the fixed rule reports
  three findings it had been blind to — all three the UI5 samples' own quirks
  that the ports carry verbatim (`type="{Text}"` in 012/094,
  `key="{ProductId}"` over `/Categories` in 115), each now carrying a
  `abap2ui5lint-disable-next-line` with that rationale.

  One gate consequence to re-check later: app 049 now declares a
  `render_smoke` skip. Its bound template binds the numeric StepInput
  properties over rows that deliberately do not set them, and UI5 logs
  "must be a number" for such a row — which the **original sample** produces
  just as well (its own template binds `min='{min}'` over rows without a min).
  The skip goes when the render gate learns to treat an absent numeric path as
  the control default.

- [x] **Metadata snapshot: both follow-ups done** (closed 2026-08-02).
  `ui5/properties.json` is now the output of the **linter's**
  `generate-metadata.mjs` run against this repo's own OpenUI5 checkout
  (`OPENUI5_DIR=… node node_modules/@abap2ui5/linter/scripts/generate-metadata.mjs
  --out ui5/properties.json`), so there is one metadata parser in the ecosystem
  and the snapshot still matches the `release` field of `ui5/universe.json`.
  Both pending
  items are settled:
  - **The dependency is pinned by SHA.** As of 2026-08-05 it points at
    **`c0e58d0`, a linter FEATURE-BRANCH commit** — the same SHA the VS Code
    extension pins, so the two consumers judge by one linter state. Over
    `5b17036` this adds no new rules: `9c2f2b1` brought fix/baseline plumbing
    for the extension (`attachNamespaceFixes` export, file-relative baseline
    keys, `./baseline` subpath), `c0e58d0` widens `view-never-displayed`'s
    display list by `popover_display`/`nest*_view_display` (a false positive
    the extension's snippet gate caught; can only remove findings, and the
    corpus had none). Gates re-ran green after each bump (293 ports,
    0 failing). The previous feature-branch pin `10920f7` is meanwhile part
    of linter main via its PR #9. The corpus
    now gates the eleven 2026-08-04 rules too (`popover-display-val`,
    `uncurated-formatter`, `hardcoded-binding-path`,
    `missing-view-display-on-navigated`, `separate-lifecycle-ifs`,
    `duplicate-for-iterator`, `binding-to-nonpublic`, `ui5-internal-access`,
    `commercial-ui5-host` gating; `unknown-event-parameter` as a budgeted
    advisory; `enum-value-too-new` in `VERSION_TYPES`, POST_171-excusable) —
    pattern-lint's whole generic half moved there across the two rounds.
    **This pin must become a main SHA before this change is merged**
    (linter AGENTS.md carries the same rule); corpus movement from the bumps:
    0 new violations (app 028's two `enum-value-too-new` findings land on its
    existing frameType POST_171 declarations — the rule's first run confirmed
    a hand-written audit), +1 advisory (app 268's forwarded `colorString`,
    inside the ratchet budget).
  - **The stale scope exception is gone.** The regenerated snapshot dropped the
    two false deprecations of the old parser (`sap.f.semantic.SemanticPage`,
    `sap.f.DynamicPageTitle` — a file-level `@deprecated` JSDoc block sitting
    on a local variable, attributed to the control) and gained the real one on
    `sap.ui.core.XMLComposite`. So app 166 is **in scope**, its
    `ui5/scope-exceptions.json` entry was removed (5 exceptions left), `sap.f`
    in-scope rose 32 → 34 and the two XMLComposite samples moved from *nonapp*
    to *deprecated*. The snapshot also carries the full member shape now (976
    controls, ~479 kB), which is what makes it the same artefact the linter
    generates for itself.

- [x] **Smart variant management: solved** (closed 2026-07-28). `sap.ui.comp`'s page
  variant never gets `setPersControler()` — `addPersonalizableControl()` returns early
  for `isPageVariant()`, so a controller-less app has neither the anchor
  (`_oPersoControl`) nor the control promise `initialise()` requires. abap2UI5 does
  the handshake through the `SMART_VARIANT_INIT` action, merged into abap2UI5 main
  with #2481; the PageVariantManagement port is **live-verified**: saving works and the
  saved views are back after a restart (`isInitialized: true`, 7 variants / 7 items).
  The port names the action through `client->cs_event-smart_variant_init` instead of the
  string literal, and now lives in abap2UI5/samples (`z2ui5_cl_demo_app_478`).
  Seven hypotheses died on live evidence before this one, kept so nobody walks them
  again: missing app component (resolves), `flexEnabled` (read only by `sap.ui.rta`),
  association-id prefixing (XMLViews prefix single associations), registration
  (2 controls, `loadVariants` clean), the SAPUI5 docs' page-variant wiring (registers
  **0** controls — the sample's wiring is the right one), `initialise()` as the setter
  (it only reads the field), and anchoring after the fact (the write path works, the
  load path does not).
- [x] **sap.ui.comp ports left this repo** (closed 2026-07-29). The five smart
  control ports needed a SAPUI5 runtime plus a Gateway service, so neither the
  universe, the property gate, `render_smoke` nor the e2e harness could see
  them — they sat outside every check this repo is built on. This repo is now
  **OpenUI5-only** (AGENTS §3): the ports moved to
  [abap2UI5/samples](https://github.com/abap2UI5/samples) `src/00/00`
  (*extended*, next to the existing smart control demos 313/314/319) as
  `z2ui5_cl_demo_app_475`–`_479`, rebuilt on `z2ui5_cl_xml_view`.
- [x] **Out-of-scope ported samples: KEEP permanently** (decided 2026-07-30
  under the session's standing continue-with-everything mandate; each entry
  in `ui5/scope-exceptions.json` carries the per-app rationale and is
  revertible by deleting the port + its entry). All six gate-verified ports
  stayed: 121 (UploadSet, deprecated — only upload-set coverage), 136
  (SidePanel @1.107), 141 (InvisibleMessage @1.78 — only a11y-announcement
  idiom), 165 (ProductSwitch @1.72, most borderline), 166 (sap.f
  SemanticPage, deprecated since 1.54 yet widely deployed) and 203
  (OverflowToolbarTokenizer, experimental @1.139). App 166 left the list
  again on 2026-08-02: the regenerated metadata snapshot dropped the false
  deprecation, so it is plainly in scope and 5 exceptions remain. The source-backed scope
  gate stays a **hard gate** (exit 1) for any NEW ported out-of-scope
  sample without a decided entry, so this class of debt cannot regrow.
- [x] **Non-app samples are out of scope** (user decision 2026-07-31, found
  while planning batch b05). Apps 258/259 took the last two portable
  `NEW-CONTROL` rows (`sap.uxap.ObjectPageDynamicHeaderTitle`); everything left
  under that marker was UI5's own **test infrastructure** (`sap.ui.test.*` —
  OPA5 / gherkin / matcher QUnit pages), **Component routing**
  (`sap.ui.core.routing.*`) and the **view-type / XML-templating /
  XMLComposite authoring** demos (`View.*`, `ViewTemplate.*`,
  `XMLComposite.*`) — samples whose control is 1.71-clean but that are not app
  views, so there is nothing to rebuild 1:1. They are now a **second scope
  rule** (AGENTS §1): the families live in `ui5/scope-nonapp.json` with a
  reason each, `scopeOf` returns `nonapp`, `--backlog` never offers them,
  `api.md` still lists them `✗`, and `scope-of.mjs --sample` reports
  `OUT_OF_SCOPE (not an app view — …)`. 39 samples moved out of scope, so the
  honest denominator is **626 in-scope** (was 665) and `sap.ui.core` reads
  80.0 % instead of 27.1 %. Batch planning is **depth-only** from here (lowest
  `covered-control(n)` first, idiom-first within equal n).
  `ControllerExtension` (`sap.ui.core.mvc.ControllerExtension`) joined the list
  in the same pass (user decision): abap2UI5 has no frontend controller to
  extend, so the sample carries no view idiom to rebuild. Deliberately kept
  **in** scope: the two `BoundFilters.*` samples (`sap.ui.model.Filter`) — real
  app views, ported the same day as apps 264/265, so **every remaining
  uncovered control in the backlog is a HOLDOUT**: breadth is closed and batch
  planning is depth-only.
- [x] pattern-lint stays regex-based **by decision** (2026-07-18), and since
  2026-08-04 it is **corpus-policy only**: the ten generic rules moved into
  the linter (token-/string-aware there, several with `--fix`) and are gated
  via `view_gates`; what stays here is method order, formatting, sidecar
  conventions and the corpus-specific lessons (`dead-event-wire`,
  `unguarded-date-formatter`). The syntax-awareness question answered itself:
  a rule that needs it belongs in the linter anyway.

## 2026-08-05 (eighth round) — three breadth probes become faithful ports

- **117** (`sap.f.Card`) is **1:1**: both cards instead of one simplified one -
  the booking card with its two sorted city ComboBoxes, DatePicker and Book
  button, and the whole second card (revenue List, CustomListItem template,
  Title/Text, ObjectStatus state). The named models fold into the default model,
  the ComboBox sorter rides along as a raw binding-info string. The gate then
  reported its `structural_diff` skip as **STALE** — no differences remain — and
  the skip is gone. That ratchet earns its keep.
- **121** (`sap.m.upload.UploadSet`) is **1:1** too. It had three INVENTED rows;
  both rows of the sample's own `items.json` are there verbatim now, with the
  five ObjectMarkers and four ObjectStatuses of the first, the item template's
  markers/statuses aggregations and uploadState, the UploadSet's file-size and
  media-type properties, and the full toolbar incl. the
  `UploadSetToolbarPlaceholder`. Skip gone as well.
- **116** (`sap.uxap.ObjectPageSubSection`) has all three subsections and all
  ten MultiViewBlock positions again, each inlined with its block view's
  content. MultiViewBlock ships two views and picks by the block MODE; abap2UI5
  has no BlockBase mode, so each block carries the variant its subsection asks
  for — what the sample renders on load. The per-block runtime switching is the
  declared residual.

**A tooling lesson worth keeping:** 116's first version built its eight blocks
through a helper method, and the structural diff reconstructs views
**statically** — it saw one SimpleForm instead of ten and reported the port as
missing everything. Views stay written out; a helper hides the view from the
gate that judges it.

Remaining from the flagged list: **115** (`sap.ui.table.Basic` — 13 columns,
derived Suppliers/Categories, a MultiInput with tokens + suggestions, the full
123-row mock) and **118** (`sap.ui.integration.CardsLayout` — several
manifest-driven Cards, the hard one). Both are half-a-day ports, not one-liners.

IMPROVISED: 42 → **39**.

## 2026-08-05 (seventh round) — 108, 114, 168 and a quoting boundary

- **108** (`PlanningCalendarSingle`) was the one port the 2026-07-27 review
  retyped from NOTE to IMPROVISED ("a lost behavior is IMPROVISED, not NOTE"),
  and all three of its lost behaviours are back. `handleAppointmentSelect`'s
  MessageBox is composed in ABAP from values the event carries — the
  appointment's title and new selected state, the number of selected
  appointments, and the appointments-array length for the branch where the
  interval hit no appointment — so both branches read exactly as in the
  original; the message is modal, so the round-trip costs nothing visible.
  `handleIntervalSelect` appends the sample's own new appointment
  ('new appointment', Type09) over the selected interval, whose start/end travel
  as LOCAL parts. `toggleDayNamesLine` is the bindable `showDayNamesLine`
  (@since 1.50) shared with the ToggleButton's `pressed` state.
- **114** carries all TWELVE language entries of the CodeEditor value again (it
  had been cut to four) and gets the brace escaping right: the braces come from
  `backtick` literals, which take the backslash verbatim, while the body uses
  `|…|` templates for the real newlines. Exactly the distinction that became the
  `escaped-brace-in-backtick` linter rule this morning.
- **168** needed no code — like 167, its sidecar still described the port before
  its rework and called handlers "STATIC toasts" that are bound properties and
  value-carrying toasts today. Corrected, with the two genuine drops named: the
  RevealGrid debug overlay and the `attachLayoutChange` margin swap.
- **165**'s rebuild made `sap.f.ProductSwitch`/`ProductSwitchItem` visible to the
  property gate for the first time (the port used to substitute them with a
  toast), so the port now declares them POST_171 — it is one of the five decided
  scope exceptions anyway.

**A new boundary, measured:** an event-arg expression cannot contain a DOUBLE
quote. The handler rides in a double-quoted XML attribute, so the first `"`
ends it and the view fails to parse. The probe found it while checking whether
a whole composed message fits in one arg (it does, `\n` included) — a message
that wraps a value in quotes therefore puts them in the client-composed template
or composes in ABAP. Recorded in CAPABILITIES next to the grammar it belongs to.

IMPROVISED: 45 → **42**.

## 2026-08-05 (sixth round) — six of the flagged breadth-probe ports

The 2026-07-27 review flagged thirteen ports as under-delivering and named the
technique for each; this round works that list.

- **119** injects the sample's `css/style.css` through a `core:HTML` content
  attribute, so the FixFlex background colours are back.
- **169**'s eight Sliders resize their grid wrappers again. The original walks
  the DOM to find the wrapper below each slider; every wrapper is statically
  known in the view, so each pair is a two-way bound value plus a width
  expression binding — roundtrip-free, the app-176 idiom.
- **221**'s three home Buttons reset their sibling IconTabHeader again. First
  attempt used `control_by_id setSelectedKey` and the **linter said no**:
  `settable-property-via-action`, because `selectedKey` is bindable. The rule
  was right — the port binds the key and resets it from the event handler.
- **222**'s Slider resizes its Panel through the same binding pair (the Panel
  HAS a width property, unlike the `sap.m.Page` of 138/267/269). Its RevealGrid
  toggle stays dropped: a sample-local JS debug overlay is not a capability.
- **165** is rebuilt 1:1 — the ProductSwitch popover fragment via
  `popover_display( by_id )`, the three products bound from `model/data.json`,
  and `fnChange`'s toast + `URLHelper.redirect` as two client actions chained
  on one change event, both reading the pressed item off the event. The port
  now has **no structural difference from the original at all**.
- **167** needed no code: its sidecar still described the pre-rework port and
  called handlers "STATIC toasts" that had long since been wired (bound
  `sideExpanded`, the item text in the toast, `to()` for the NavContainer, the
  user popover, the Create Item dialog). Corrected — a stale rationale is a
  defect like any other, and this one would have sent the next reader to redo
  finished work.

IMPROVISED: 51 → **45**.

## 2026-08-05 (fifth round) — IMPROVISED means what it says now, and two families closed

**The metric was fixed first.** More than half of the corpus' 118 IMPROVISED
deviations were a decided rule working as decided — the thin frontend, the
single default model, mock flattening, BlockBase inlining, fragments composed
into the one port view. Those render identically, so they are `NOTE`s;
IMPROVISED is meant to say "a behaviour of the original is lost or
substituted" (the 2026-07-27 review retyped app 108 the other way for exactly
that reason). `improvised-cluster.mjs --retype-policy --write` did the sweep:
safe because a gate declaration matches the deviation TEXT, never its type
(`structural-diff` reads `d.what`), and not blind because an entry whose text
still NAMES a loss is held back and listed — 8 of 73 were (261's dropped
Expanded view, 267/269's lost model indirection, 012's routing, the BlockBase
wrappers that lose their ids). **136 → 53.**

**`imperative-aggregation` is closed** with app **241**, the last of the four:
the sample's Create button does `getItem().addItem( new NavigationListItem(…) )`,
so the main NavigationList is a bound aggregation now and creating appends a
row with the sample's own defaults. Its rows use `omit_initial_paths`, with
`SELECTABLE` deliberately outside the list — the two external links must send
their explicit `false`. None of 076/077/203/241 was a framework gap.

**`event-veto` is half closed.** App **136**'s "an event veto is not
expressible" predated `s_ctrl-check_prevent_default` (merged 2026-07-30). The
flag is baked per wire at render time, and that is enough there because the
DIRECTION of the next toggle is known — an expanded panel can only collapse —
so the flag is whichever switch applies, the switches are two-way bound, and
the toggle round-trip re-bakes it. The handler is the original's if/else,
toast and switch reset included. App **247** is the genuine residual and now
says why: its veto is per COLUMN while the flag is per wire, and
`columnResize` is declared on the Table, not the Column.

IMPROVISED: **51 across 43 ports** — 8 GAP (all implemented upstream), 5 PROBE,
14 REWORK, 16 BOUNDARY, 8 POLICY.

## 2026-08-05 (fourth round) — the REWORK list cleared, two new linter rules, the last request closed

Four rounds in one day, all measured rather than argued.

**The imperative-aggregation family is closed** (076/077/203/241 minus 241).
Two new probe candidates answered it against real OpenUI5:
`removeToken`/`removeItem` accept an **ID STRING** (`ManagedObject.removeAggregation`
resolves it), so a static aggregation child can be removed through a wire that
can only carry strings; and UI5 runs a **`;`-separated PAIR** of event
handlers, so one event drives two client actions without a round-trip.
- **203** folds the first tokenizer's static tokens into a bound aggregation
  (the app-085 pattern) so onAddToken appends a row with the original's
  empty-input toast, and deletes the three other tokenizers' static tokens by
  id, roundtrip-free, with the original's "Token deleted: X" toast.
- **076/077** remove the notification item AND toast its title on the same
  close event, both client-side. The NotificationList gained an `id` (the wire
  needs a target for `removeItem`) — the port's only extra attribute.
- **241** is the one left: its Create button appends a `NavigationListItem` to
  a statically declared list, so the fold has to cover the whole nested
  navigation tree. Still REWORK, not a gap.

**022/235** got their sticky Label + three CheckBoxes back on app 009's proven
bound-array pattern, **166**'s semantic actions stopped being static toasts
(showFooter/edit visibility as bound state, the `Messaging.addMessages` seed
through the `cc.MessageManager` bridge, the MessagePopover declared in the
indicator's dependents), and **233** finally uses two capabilities that had
shipped in July and sat unused: the compound `binding_call` OR-filter and
`open( searchValue )`.

**Two lessons from 166 became linter rules** (the distillation rule, and both
mirror how this corpus learns):
- `escaped-brace-in-backtick` — brace escaping is a `|…|` TEMPLATE rule. A
  backtick literal has no escape processing, so `\{ path: … \}` lands in the
  attribute verbatim and UI5 never sees a binding. Only the render gate caught
  it. Measured over the corpus, the first cut reported five `<style>` ports
  (where the backslash MUST survive), so the rule now fires only when the value
  IS a binding.
- the **`css` property allowlist** is mirrored as a closed set with an
  `ACTION_ARGS` slot that applies only when the method is `css`, and
  `check-upstream` guards that mirror like the `GLOBAL_TARGETS` one.

**The last framework request closed itself the same day it was written.**
`model-empty-vs-default` needed two changes: the blanket `omit_initial` and,
because a boolean that must send `abap_false` is itself initial, the scoped
`omit_initial_paths`. With both, app 049 binds `enabled`/`editable` plainly
again and has **no binding-value deviation left**; `pr/` holds only the
open-abap-core request now.

IMPROVISED: 136 → **118**.

## 2026-08-05 (third round) — the biggest PROBE family measured: not a gap, six ports reworked

`event-value-unreachable` was the largest open family of the harvest (7
deviations) and rested on one sentence repeated across seven sidecars: the
value the original reads is **not transportable**, because it sits in an array
or a control reference on the event. That sentence is now **measured and
false**.

`scripts/probes/event-arg-expression-probe.mjs` boots the real OpenUI5 (the
`@openui5/*` packages the linter installs), creates a view whose controls carry
`.eB('EVT', <candidate>)` — exactly what `get_t_arg` emits for a `$`-prefixed
arg — fires the event and reports what the handler **received**. Six
candidates, all resolving:

| candidate | got |
|---|---|
| `${$parameters>/value} + '%'` (already shipped) | `60%` |
| `$event.oSource.getSelectedDates()[0].getStartDate()` | the picked Date |
| the three LOCAL date parts as three args | `2026, 3, 17` |
| `${$parameters>/tokens}[0].getKey()` | `k1` |
| class-name ternary over `getMetadata().getName()` | `B pressed` |
| `${$parameters>/sizes}.join(',')` | `30,70` |

So indexed access, chained calls, arithmetic, array joins and ternaries are all
inside the expression grammar. **Six of the seven ports are reworked:**

- **139 / 151 / 177 / 220** — the four calendar ports reported the **server
  date** where the original formats the clicked day. They now transport the day
  as its three LOCAL parts (year, month+1, day — not `toISOString()`, which
  shifts the day for any user east of Greenwich), each guarded by
  `getSelectedDates().length > 0`. That guard buys 177 its original else-branch
  for free: re-clicking the same day removes it, year 0 arrives, the Text falls
  back to "No Date Selected". 220 had no `select` wire at all and gained one,
  with `DateFormat({style:'long'})`'s English rendering composed in ABAP (the
  app-024 precedent). Residual in all four: the Today/Focus buttons still only
  write text — `addSelectedDate`/`focusDate` take a DateRange/Date **object**
  no wire can construct.
- **228** — the sample's whole `handleMenuItemPress` branch (skip a submenu
  parent, `getValue() + ' entered'` for a MenuTextFieldItem, `getText() +
  ' pressed'` otherwise) now travels as ONE client expression into the composed
  toast. The old rationale confused the layers: the class cannot be inspected
  by the BACKEND, but the expression runs on the client, where the sample's own
  code runs too.
- **186** — both PaneContainer resize toasts carry their `oldSizes`/`newSizes`
  arrays again via `.join( ',' )`, each guarded because the first resize has no
  old sizes.

**App 109 stays as it is, and its sidecar now says why properly:** its
`selectedDatesChange` parameter is an array of `DateRange` CONTROLS that the
original formats **per entry**, and the expression grammar has **no loop** —
the same boundary as app 060's parent-chain breadcrumb. Indexed access would
have worked for a single range; a per-entry map does not exist.

The `event-without-handler` advisory budget ratchets 7 → 4 with the four
calendar wires. IMPROVISED is down to 124 (from 136 at the start of the day).

## 2026-08-05 (second half) — the five requests implemented upstream, six ports rebuilt on them

Same day, three repos: the framework requests the harvest filed were
implemented in abap2UI5, mirrored in the linter, and consumed by the corpus.

**abap2UI5** (`_bind( omit_initial )`, `CONTROL_METHODS` `css` and `setSticky`,
the `controlIdOrNull` argument kind with `setSelectedSection`/`setSelectedItem`,
the `INVISIBLE_MESSAGE` and `FORMATTING` global targets). `npm run verify`
green; 7 new JS specs and one ABAP unit test asserting an initial field stays
absent from the serialized model. Two things were learned while implementing:

- **`get_t_arg` drops a TRAILING empty argument**, so "clear this association"
  arrived as a no-arg call and only worked by the control's own `undefined`
  handling. `castArgs` now pads a missing trailing argument when — and only
  when — its declared kind is nullable, so the null is explicit. Every other
  kind keeps the no-padding rule that makes `open()` a true no-arg call.
- **The `api-snapshot` gate reported an appended OPTIONAL parameter as a rule-5
  violation**, although rule 5 allows exactly that ("new optional
  parameters"). It distinguishes an additive optional parameter from a real
  signature change now — same clauses, nothing reordered, every appended
  parameter optional or defaulted — and still requires recording it.

**abap2UI5-linter**: the hand-maintained `GLOBAL_TARGETS` mirror gained the two
new targets (without it a correct wire fails `view_gates` as "not an accepted
global object"). `check-upstream` also parsed `word:` pairs out of `//`
comments inside a methods block — the payload example `{ CODE: { digits: n } }`
read as two methods — so it strips line comments before matching now.

**ai-demokit**: six ports rebuilt, each sidecar deviation moved
`IMPROVISED → NOTE`.

- **049** (`sap.m.sample.StepInput`) is the structural one: 14 unrolled static
  items became the sample's ONE bound `CustomListItem` template again, bound
  with `omit_initial`, and the template property `valueState` — dropped because
  no row sets it — is back. It also found the **open half** of its own request:
  `omit_initial` is all-or-nothing per bind, and `abap_false` IS initial, so
  the two boolean columns (`enabled`/`editable`) would be dropped and the
  disabled/read-only rows would render editable. They carry the original's
  literal in a string column plus an expression binding — the port's only
  remaining binding-value deviation, and the reason
  `pr/model-empty-vs-default` stays open for path scoping.
- **138 / 267 / 269**: the width Sliders resize their container again through
  `css`, roundtrip-free, with `${$parameters>/value} + '%'` as the argument —
  the string-concat half of the "an event arg is a full UI5 expression"
  capability, used here for the first time.
- **263** clears `selectedSection` with an empty argument instead of naming the
  first section; **289** announces its regenerated MessageStrip assertively;
  **196** registers BGN4/WWWW so list five renders 4 and 5 decimals.

**A premise died on the way, and it is recorded rather than dropped:**
`table-set-sticky` claimed neither a bound array property nor a whitelist entry
was a proven path. **App 009 binds `sticky` to an ABAP string table and is
live-verified** — the bound path worked all along. The whitelist entry still
closes a footgun (an imperative `setSticky` silently received a string through
the generalized allowlist), but apps 022/235, which deleted the sticky Label +
three CheckBoxes from their view, are plain REWORK against app 009's pattern,
not gap victims. That is the second request in this repo's history whose
premise did not survive contact with the source (after `urlhelper-abap-api`),
which is why the harvest classifies unverified premises as PROBE and not GAP.

**Pins are on feature branches** until the three PRs merge: `A2UI5_PIN`, a
`"branch"` entry on the abap2UI5 dependency in all three abaplint configs
(without it `_bind( omit_initial )` is a syntax error to ABAP_STANDARD/CLOUD/
702) and the `@abap2ui5/linter` commit. All three MUST become main SHAs before
merge — the rule STATUS.md already carries for the linter pin.

App 049 carries a new `render_smoke` skip: its bound template binds the numeric
StepInput properties over rows that deliberately do not set them, and UI5 logs
"must be a number" — which the ORIGINAL sample produces just as well, since its
own template binds `min='{min}'` over rows without a min. The skip goes when
the render gate treats an absent numeric path as the control default.

## 2026-08-05 — IMPROVISED harvest: 136 improvisations classified, 6 framework requests filed

No new port in this round. The corpus had **136 `IMPROVISED` deviations** and
`pr/` held **one** open request — i.e. the repo was accumulating evidence of
framework gaps faster than it was forwarding them, which inverts its stated
purpose. This round converts the existing porting work into product output
instead of adding coverage.

**The classification is a probe, not a reading.**
`scripts/probes/improvised-cluster.mjs` sorts every `IMPROVISED` entry into one
of five verdicts (GAP · PROBE · REWORK · BOUNDARY · POLICY) by ordered family
regexes, first match wins, review verdicts ("needs rework", "is WRONG", "is
refuted") matched *before* the topical families so a flagged port cannot hide
inside its own topic. `--strict` fails on an entry that matches no family:
that is the ratchet — a new improvisation shape has to be consciously judged
gap-or-not instead of joining the pile. It is deliberately **not** in
`npm run gates`; classifying is a reviewer's call, not a generation-time one.

Result: **GAP 15 · PROBE 16 · REWORK 16 · BOUNDARY 16 · POLICY 73.**

The POLICY share is the finding behind the finding: **more than half** of what
the corpus calls an improvisation is the thin-frontend rule, the single default
model, mock flattening or BlockBase inlining working as decided — 15 BlockBase
inlinings, 13 named-model folds, 18 thin-frontend recomputations, 11 mock
flattenings. Those are behaviour-identical and read more like `NOTE`s than
`IMPROVISED`s. Retyping them is left out of this change on purpose: gate
declarations match on deviation text, so a sweep of that size deserves its own
round.

**Six requests filed**, each verified against the framework source before
writing (the corpus rule that killed `urlhelper-abap-api` on a wrong premise):

- `model-empty-vs-default` — `z2ui5_cl_core_srv_model->main_json_stringify`
  serializes with `iv_ignore_empty = abap_false`, so an initial ABAP field
  arrives as an explicit `""`: enum properties reject it, control defaults are
  overridden, and app 049 had to **unroll a bound List into static items**
  because a template whose rows set different property subsets cannot work.
  The escape hatch already exists and no port uses it — `_bind( custom_filter )`
  is applied at exactly that point and `z2ui5_cl_ajson_filter_lib=>create_empty_filter( )`
  drops empty nodes — so the ask is ergonomics + path scoping
  (`omit_initial`), not a new mechanism. The highest-value of the six: the only
  gap that forces a *structural* deviation.
- `control-inline-style` — `sap.m.Page` has no `width` property, so the three
  DynamicSideContent/Grid sliders that resize their container by
  `byId(…).$().width(v + '%')` have nothing to bind and no method to call;
  `addStyleClass` carries a class name but no value. Asked for `css:
  ["string","string"]` on the control's own DOM ref (apps 138/267/269, plus
  250's icon tint as an explicitly optional half).
- `table-set-sticky` — `setSticky` is reachable through the generalized
  allowlist but `castArgAuto` infers a **string**, so the array never arrives.
  One line (`setSticky: ["object"]`, the shipped `setHiddenInPopin` shape)
  undoes app 009's server-side array mirror and gives apps 022/235 back the
  Label + three CheckBoxes they deleted from the view.
- `control-method-null-arg` — `castArgAuto("")` returns `false`, never `null`,
  so an association reset (`setSelectedSection(null)`, app 263) has no wire.
  The concept ships already for exactly one kind (`within`); asked for a
  general `controlIdOrNull`.
- `invisible-message-announce` — `sap.ui.core.InvisibleMessage` is a singleton:
  no id for `CONTROL_BY_ID`, no entry in `GLOBAL_TARGETS`. Filed despite a
  single porting hit (app 289) because it is the only possible route to an ARIA
  live announcement for **any** abap2UI5 app, and backend-driven content change
  is what the framework does.
- `custom-currency-formatting` — no `FORMATTING` global target, so
  `Formatting.setCustomCurrencies` (app 196's whole subject) is unreachable;
  affects any app with a non-standard `CURRDEC`, not just the sample.

**Six probe families are owed** (STATUS.md carries them). The biggest:
`event-value-unreachable` (7 deviations) rests on the premise that a value in
an array or a control reference cannot be transported — but an event arg is a
**full UI5 expression** (`EventHandlerResolver` → `BindingParser.parseExpression`),
which `pr/menu-item-selected-path` established and no port has tested for
indexed access. Four calendar ports (139/151/177/220) show the **server date**
instead of the clicked day; if `$event.oSource.getSelectedDates()[0].getStartDate()`
resolves, that is the corpus' largest remaining behaviour loss closed without a
framework change at all.

Two REWORK entries the earlier sweeps had missed also came out of it: app 166
(the `Messaging.addMessages` seed is expressible via `cc.MessageManager`) and
app 233 (compound `binding_call` OR-filter and `open(searchValue)` both shipped
since 2026-07-20, both unused).

## 2026-08-04 — gate-integrity round: linter bump, pattern-lint split, ratchet, LIVE_TEST closure path

One change set across linter + ai-demokit, driven by a full gates/tooling
review. The linter gained seven rules distilled from this corpus
(`popover-display-val` with `--fix`, `uncurated-formatter`,
`hardcoded-binding-path`, `missing-view-display-on-navigated`,
`separate-lifecycle-ifs`, `duplicate-for-iterator`, `unknown-event-parameter`
as a hint), a per-file-configurable `render-error` pseudo-rule and a CI drift
gate for its metadata snapshot; the pin moved to `15a07b8` (feature branch —
must become a main SHA before merge). Every rule was measured against this
corpus first: two false-positive shapes died in that measurement
(`DateRangeSelection change` widening an inherited event → existence is only
judged on self-declared events; `ColorPickerPopover` forwarding `colorString`
undeclared → the rule is a hint, not a warning).

Corpus side:

- **pattern-lint is corpus-policy only now** — its ten generic rules moved
  into the linter and are gated via `view_gates`. One rule set, two
  enforcement points was how the editor and CI drifted before.
- **`structural_diff.skip` expires like `render_smoke.skip`**: the diff is
  still computed and a skip with no remaining differences FAILS. First catch
  on activation: app 114's probe skip was stale (the port is a faithful
  rebuild) — removed.
- **Advisory ratchet in `view_gates`** (`ADVISORY_BUDGET`): advisory findings
  never gate per finding, but their per-type count must not grow. Pinned at
  41 missing-accessibility · 7 event-without-handler · 1
  unknown-event-parameter.
- **`validate-meta` hardened**: unknown sidecar top-level keys fail (a typo'd
  escape hatch was silently ignored), `structural_diff` got a schema,
  hold-out ports can never be `checked`, port numbering must be gap-free
  (231 pinned as the one historic exception), and `audit.event_t_arg` is now
  DERIVED-checked like `frontend_action` — defined as "passes `t_arg` in any
  event wire"; the stored flags had drifted beyond repair (44 of 293
  contradicted every plausible reading) and were swept to the derived truth.
- **The scaffolder enforces the scope + hold-out pre-checks** that were
  manual prose (the kind of step an agent skips): out-of-scope and HOLDOUT
  samples are refused with the facts printed, exceptions pass with a note,
  `--force` records a maintainer decision.
- **The LIVE_TEST loop is closed end to end**: the last three LIVE_TEST ports
  without an interaction got one (043 toolbar-press → two-way `expanded`
  flip, 096 radio → round-tripped mode toast, 149 REDIRECT → popup on the
  Card Explorer URL), `scripts/close-live-tests.mjs` converts green-verified
  deviations to `NOTE`s mechanically (text verbatim — gate declarations keep
  matching), and a red nightly now opens/updates an issue
  (`e2e nightly is red`) instead of hiding in the Actions tab.

A second linter round followed the same day (pin → `5b17036`): the 043
BINDING_ERROR became the generic rule `binding-to-nonpublic`; the
"enum values newer than 1.71 are invisible" residual limit closed as
`enum-value-too-new` (its first corpus run *confirmed* app 028's two
hand-written frameType POST_171 declarations — the rule now checks what a
human could only declare); `unknown-binding-path` covers `path: '/X'` and
`${/X}` forms (the `/T_ITEMS/9/...` row-index trap died in the corpus
measurement); pattern-lint's last two generic rules (`private-mproperties`,
`commercial-ui5-host`) moved over; and `view_gates`' render leg got the
linter's new page pool. Linter-side the metadata generator dropped from
~3 minutes to ~1.5 s (an unanchored regex was 167 of 172 seconds), which
also makes the weekly `generate_result` snapshot refresh here cheaper.

## The curated formatter shrinks to a marshalling layer, and a gate holds the line (2026-08-04)

A review of the framework's `model/formatter.js` against the thin-frontend
principle, prompted by the question whether shipping formatters contradicts it
at all. The answer turned out to be **not the mechanism, but half the content**.

Sorting the nine exports by *why* they cannot live in ABAP splits them cleanly:

- **`DateCreateObject` / `DateAbapDateToDateObject` /
  `DateAbapDateTimeToDateObject`** — not logic at all, **marshalling**. UI5
  properties typed `object` demand a real JS `Date` and JSON has no date type,
  so the ABAP model physically cannot carry one; a string binding crashes view
  creation. The conversion *has* to happen at the binding.
- **`expandInlineIcons`** — the glyph and font family come from the loaded
  theme's icon font via `IconPool`. Hardcoding a codepoint in ABAP would push a
  frontend detail into the backend: the thin-frontend rule **in reverse**.
- **`round2DP`, `dimensions`** — ABAP rounds and concatenates. They existed
  only to keep a port's binding structure 1:1 with the original, which is a
  porting-fidelity motive, not an architectural one.
- **`stockStatusState`, `stockStatusIcon`, `deliveryStatusState`** — lookup
  tables from a business status (`Available`, `Shipped`) to a `ValueState` and
  an icon. Presentation by the letter, but it put a demo domain's **vocabulary
  into the framework**, and mapping a status to a visual is classification.

The last five were **removed** (abap2UI5, 2026-08-04), following
`weightState`/`weightStateByValue` which went 2026-07-22 for the same reason.
The corpus paid nothing: of 293 ports, **7** bind a formatter at all — 40×
`DateCreateObject`, 5× `expandInlineIcons`, and **zero** uses of the five that
went. Meanwhile **27** ports carry a thin-frontend note for logic they moved
out of the original's `Formatter.js`. The principle was already being enforced
by hand in the ports; the framework module was the one place lagging behind it.

**What actually changed, so this does not drift back:**

- The module header now states three **admission criteria** — one value only;
  frontend-only for a technical reason (`js-type` | `icon-font` |
  `locale-theme`); no domain vocabulary — and
  `.github/scripts/formatter-scope-gate.mjs` enforces the two a machine can
  check: the export surface must match a manifest where every entry names its
  reason, and no `ValueState` or `sap-icon://` **string literal** may appear
  (comments and regexes are not scanned, so prose may still discuss them).
- **New pattern-lint rule `uncurated-formatter`** here: a
  `formatter: 'Formatter.<fn>'` or `Formatter.<fn>(` naming anything outside
  the four curated functions is an error. This is the failure mode that made
  the review urgent — two abap2UI5 samples (450, 453) still bound
  `weightState` / the removed pack **weeks after** it was deleted, and nothing
  caught it: UI5 resolves an unknown formatter name to nothing, so the property
  is never set and the cell renders **blank, with no error**. Both samples were
  rebuilt (450 now demonstrates the DATS/TIMS helpers, 453 the same table
  computed in ABAP).
- The call form deliberately allows **no space before the paren**
  (`Formatter.x(`), which is what keeps deviation prose like "its frontend
  `Formatter.js` (weightState: …)" from matching — four such false positives in
  the generated overview class during development.

The reusable criterion, from app 294 two days earlier and now the module's
criterion 1: *a formatter that reads more than the one value it formats is
business logic wearing a formatter's name.*


## 293/294 — an empty deviations array, and three formatters that were business logic (2026-08-02)

**293 `sap.uxap.sample.ObjectPageSubSectionBackground`** (`sap.uxap.ObjectPageSubSection`)
is 33 lines of pure markup with no controller at all, and the port is a **1:1
rebuild with zero deviations** — the first in a while. It earns its place for
one thing the corpus had not recorded: the view turns the usual namespace
assignment **around**. `sap.uxap` is the DEFAULT namespace and `sap.m` carries
the `m:` prefix (`<m:List>`).

That matters because `structural-diff` compares the **qualified** control name:
a `List` written without `ns` in such a view is a different control from the
original's `m:List` and would be reported in both directions. Copy the
original's namespace assignment as-is — now a gotcha in the porting guide.

**294 `sap.m.sample.MessageViewWithGrouping`** (`sap.m.MessageView`) is the
textbook case for the core principle. Its three *formatters* —
`buttonIconFormatter`, `buttonTypeFormatter`, `highestSeverityMessages` — each
walk the **whole message list** to find the highest severity
(Error > Warning > Success > Information) and count how many messages carry it.
That is not a presentation format, it is a computation over the data: it moves
into `model_init`, and the footer Button binds the three finished values
(`sap-icon://message-error`, `Negative`, `5`). A formatter that reads more than
the one value it formats is business logic wearing a formatter's name.

The rest follows app 284's shape — controller-built Dialog + MessageView
rebuilt as a `core:FragmentDefinition`, `visible` two-way bound instead of
`setVisible`, only `navigateBack` left as a frontend action — plus what this
sample adds: `groupItems` with `groupName` per message, and two deliberately
ungrouped messages that render outside the two Purchase Order groups.


## Batch b23 (291/292) — three levels of bound aggregation, and a port with no controller left (2026-08-02)

**291 `sap.m.sample.NotificationListGroupBindings`** (`sap.m.NotificationListGroup`).
The deepest binding structure in the corpus so far: `NotificationList.items`
over the groups, `NotificationListGroup.items` over that group's items, and
`buttons` over the group's *and* the item's own button rows — four bound
aggregations, three levels. The ABAP model mirrors it as nested tables
(`ty_t_group` > `groupitems` > `itembuttons`), and every relative binding
inside a template addresses its own row.

Four of the five handlers compose their toast from the pressed control and
stay on the client, roundtrip-free (`${$source>/title}`, `${$source>/text}`).
Only `onItemClose` needs the backend, because it **removes a row**: the item's
own title travels as a `$`-prefixed event arg and the handler deletes that row
from every group before pushing the model back. Worth noting for the next port
of this shape — a close/remove handler is the one member of the toast family
that cannot stay on the client, because the model is the truth.

**292 `sap.m.sample.PanelBackgroundDesign`** is the opposite extreme, and worth
recording as the shape to aim for: its controller reads the Select's key and
pushes it into the Panel with `setBackgroundDesign( )`. Both ends are
**bindable properties**, so `Select.selectedKey` and `Panel.backgroundDesign`
bind the *same* field — the Select writes it, the Panel reads it. No event, no
round-trip, no `on_event`, no `model_init`; the initial `Solid` is the field's
own `VALUE`. The `change` attribute is dropped and declared, because there is
nothing left for it to do.

`templateShareable: true` is kept verbatim on all four bindings and declared
by policy: it is a binding-info parameter, not a control member, so no gate
can ever see it (apps 264/265 precedent). `priorityFormatter` is dropped and
declared — mapping an unknown value to `Priority.None` is presentation logic
that belongs in `model_init`, and the mock's priorities are all valid anyway.

## Batch b22 (288/289/290) — a new control, and randomness as a backend decision (2026-08-02)

- **288 `sap.m.sample.PDFViewerEmbedded`** (`sap.m.PDFViewer`) — a control the
  corpus did not have. Two buttons swap the bound `source` between a valid and
  a deliberately missing PDF (that 404 *is* the sample: it demonstrates the
  viewer's loading error). Both paths are the ones the controller resolves with
  `sap.ui.require.toUrl( )`, pinned to the OpenUI5 host in their SDK form per
  the asset-URL rule — same file names, same sample folder, only the host-side
  prefix differs, which `data-fidelity` needs named in the sidecar. The two
  paths are PROTECTED `CONSTANTS`: a value that exists only to be assigned is
  not model data.
- **289 `sap.m.sample.DynamicMessageStripGenerator`** (`sap.m.MessageStrip`) —
  the controller destroys and re-creates a `MessageStrip` on every press, with
  `type`, `showIcon` and `showCloseButton` picked by `Math.random( )`. The port
  declares the strip in the view (one control more than the original view.xml,
  declared) and binds those four properties plus `visible`; rebinding the same
  control is the abap2UI5 form of destroy-and-recreate.

  **Randomness is a decision, so it moves to ABAP — and becomes deterministic
  there.** A press counter rotates the type through the four values and the two
  flags through their combinations: every press still changes the strip, and
  the port stays reproducible, which is the same rule the corpus already
  applies to "the current date" (apps 164/181).

  One trap paid for itself immediately: `strip_type` started out empty and the
  render gate rejected `""` on the enum property — the documented
  absent-property rule, so the field now carries the control's own default
  `Information` until the first press.

  The `InvisibleMessage.announce( )` accessibility call is dropped and
  declared: it is a JS singleton, not a control, so neither `CONTROL_BY_ID`
  (needs an id) nor `CONTROL_GLOBAL` (closed object list) reaches it. App 141
  covers the control-based announcement idiom.

- **290 `sap.m.sample.MultiInputValueHelp`** (`sap.m.MultiInput`) — the value
  help flow the corpus was missing. `handleValueHelp` becomes two follow-up
  actions in the controller's own order: `binding_call` filters the dialog's
  items binding by the typed text (the model stays untouched, exactly like
  `getBinding('items').filter([...])`), then `control_by_id` `open( value )` —
  `CONTROL_METHODS` declares that optional string, so
  `oValueHelpDialog.open(sInputValue)` travels whole. The MultiInput's `value`
  is bound two-way, so the typed text is already on the server when
  `valueHelpRequest` fires.

  **A list of controls cannot travel.** `_handleValueHelpClose` reads
  `evt.getParameter('selectedItems')` and builds a `Token` per item; nothing
  transports that. So the selection is read from the DATA instead — the
  `StandardListItem` template gains `selected={SELECTED}`, and the handler
  loops the rows, appends a token per selected row and clears the flag. The
  `tokens` aggregation is bound to that table, which is why the port carries a
  `Token` the original view.xml does not (it creates them in the controller).
  That is the general answer for every "the event hands me controls" sample:
  bind the state the controls stand for.

## Batch b21 (286/287) — the customData idiom, and a rule paying off twice (2026-08-02)

Two sap.m depth ports, both picked for an idiom the corpus did not have.

- **286 `sap.m.sample.BreadcrumbsWithCurrentPageLink`** (`sap.m.Breadcrumbs`) —
  the `currentLocation` aggregation (@since 1.123, POST_171) that renders the
  current page as a Link instead of plain text. Every Link keeps the original's
  client-side `MessageToast.show(evt.getSource().getText() + ' has been
  clicked')` as a roundtrip-free `_event_client` with the `{0}` template filled
  by `${$source>/text}` — so the class has **no `on_event` and no model at
  all**, which is the right shape for a view whose only behaviour is
  client-side.
- **287 `sap.m.sample.IconTabBarBadges`** (`sap.m.IconTabBar`) — nine
  IconTabBars, the first one filled with 30 filters in `onInit`. New idioms:
  the **`customData` aggregation** carrying a `sap.m.BadgeCustomData`
  (@since 1.80, POST_171 by policy — the property gate does not resolve it),
  `IconTabSeparator` between filters, and **nested `IconTabFilter.items`**
  (@since 1.77) for the sub-tab bar. The 30 generated filters become one bound
  aggregation over `T_TABS`, which is why the port carries exactly one
  `IconTabFilter`/`Text`/`BadgeCustomData` more than the original view.xml: the
  template itself.

**The rule from the previous entry paid off twice while writing them.**
287's `onTabDensityModeSelect` loops over all nine bars calling
`setTabDensityMode( )`; that is precisely what `settable-property-via-action`
reports, so the port bound `tabDensityMode` on every bar to one field from the
start and only the RadioButtonGroup round-trips (its `selectedIndex` bound
two-way, the three values derived server-side). A rule that changes what gets
written in the first place is worth more than one that flags it afterwards.

## A rule that found work: five ports move from action to binding (2026-08-02)

`settable-property-via-action` encodes the oldest unenforced rule in the book —
*prefer a bindable property over a frontend action* — and unlike the previous
four it did **not** measure 0 on the corpus. It found five ports driving a
property imperatively that the control lets you bind:

| Port | What it drove |
|---|---|
| 043 `PanelExpanded` | `sap.m.Panel.expanded` |
| 092 `TableAutoPopin` | `sap.m.Table.hiddenInPopin` |
| 096 `SplitContainer` | `sap.m.SplitContainer.mode` |
| 097 `SplitApp` | `sap.m.SplitApp.mode` |
| 269 `DynamicSideContentProduct` | `sap.ui.layout.DynamicSideContent.showSideContent` |

All five are converted; the corpus reports none. Three of them shrank
noticeably — 092's handler used to *build a JSON Priority array by hand* for
the action, and the MultiComboBox's `selectedKeys` it was built from is the
very same field, so both now bind `T_HIDDEN` and the handler is one
`view_model_update( )`.

**043 reverses an earlier decision, on purpose.** Its sidecar recorded (
2026-07-18) that the two-way `expanded` binding had been *replaced* by the
whitelisted `setExpanded` to "match the original view.xml exactly". An added
attribute is not a structural diff, and the rulebook has since settled the
other way; the sidecar now says so rather than quietly flipping. 043 and 096
lose their `checked` status for it (a behavioural rework invalidates the
check, AGENTS §10) — the historical check is kept as context in a `LIVE_TEST`.

Two things the rule needed, both of which say something about the linter's
shape:

- **What an id IS.** The ABAP-side rules only ever saw the class source; a
  `CONTROL_BY_ID` wire names an id, and whether `setX` may be replaced by a
  binding depends on the control's type. `collectControlIds` now bridges the
  view tree and the ABAP rules.
- **What "bindable" means.** Precision lives entirely in the metadata: an
  **association** (`ObjectPageLayout.selectedSection`) and a **function**-typed
  property (`MessagePopover.asyncURLHandler` — the reason the framework names a
  built-in URL policy instead) can never be bound, so they are excluded rather
  than reported and excused.

One more model defect fell out of 092's conversion: `DATA t_hidden TYPE
string_table.` — a standard ABAP table type, neither declared in the class nor
written in the inline `STANDARD TABLE OF` form — was modelled as a **scalar**,
so binding it to `hiddenInPopin` failed the render gate with `"" is of type
string, expected sap.ui.core.Priority[]`. The known scalar table types are
tables now.

## pr/popup-within-area implemented upstream — app 285 keeps the sample's point (2026-08-02)

The gap app 285 declared one entry ago is closed in the framework rather than
worked around here.

**abap2UI5** gains `POPUP` as a fourth `CONTROL_GLOBAL` target, with
`setWithinArea` as its only method and a new `within` argument kind: a control
id resolves to the **control** (which `Popup.convertWithin` dereferences when a
popup opens, so the area survives a re-render in between), and an **empty**
argument passes `null` — the documented form that releases the restriction.
The module is resolved lazily like `THEMING`, because `sap/ui/core/Popup`
exists on every release but `setWithinArea` is @since 1.89: an older runtime
then hits the existing *"not available"* guard instead of failing the whole
component load. Three JS unit specs cover the three paths.

**App 285** wires it and its `IMPROVISED` deviation becomes a `NOTE`. One
ordering fact came out of it and is now in CAPABILITIES: a **follow-up action
runs AFTER the popup of the same round-trip has opened**, so the within area
cannot be set in the press handler that opens the popover — it is set once
together with the view. For this app that is behaviour-identical (it opens no
other popup), and the `afterClose` release goes with it.

**The linter** needed the same round: its `GLOBAL_TARGETS` is a hand-maintained
copy of the framework's whitelist, so until it followed, it reported the
correct new wire as an `invalid-frontend-action` — the silent-breaking-change
direction its own AGENTS note warns about. The ai-demokit pin now points at
that linter commit; it is a **feature-branch SHA and must become a main SHA**
before this change is merged.

## The render gate was half blind — two model defects, and app 240's skip (2026-08-02)

Running the new linter over the corpus (the downstream check) found two
defects in its **reconstructor** that had been cancelling each other out, and
they concern this repo's own conventions:

- A `DATA t_x TYPE ty_t_x.` — the **named** table type this repo's newer ports
  write (`TYPES ty_t_x TYPE STANDARD TABLE OF ty_s_x.`) — was modelled as a
  **scalar**. The render gate then rendered an empty aggregation for such a
  port and **never instantiated its row template**, so nothing inside it was
  ever checked. The older inline `DATA t_x TYPE STANDARD TABLE OF ty_s_x` form
  was fine, which is why this survived.
- Fixing that surfaced the second: an **unseeded** table (one filled in code,
  `t_pages = t_company.`) was given an invented all-empty row in the *render*
  model, which fails strict validation on the first enum property — app 100's
  `"" is of type string, expected sap.m.AvatarShape` was the harness's own row,
  not the port. Unseeded tables are now empty for the renderer and a declared
  row in the shape, the same split scalars already had.

Both fixed upstream in the linter. Net effect here: the render gate now
actually sees the row templates of every named-table-type port.

**App 240 (`CalendarLegendNavigation`) declares a `render_smoke` skip.** Its 20
`DateTypeRange` rows are computed in `model_init` (a `DO` loop over `sy-datum`
into `VALUE #( BASE t_special )`), so a static reconstruction cannot resolve
`START_DATE`; `Formatter.DateCreateObject` then gets `undefined` and
`XMLView.create` fails with *Date must be a JavaScript or UI5Date date object*.
At runtime every row carries a real ISO date. The skip is re-verified against
the render each run, so it cannot outlive the reason.

## Batch b20 continued (285) — the flattened-element-binding trap becomes a rule (2026-08-02)

**285 `sap.m.sample.PopoverWithinArea`** (`sap.m.Popover`): three
controller-loaded fragment popovers, each `bindElement('/ProductCollection/0')`,
each opened with `openBy(oButton)`. Rebuilt as three `core:FragmentDefinition`
documents shown with `popover_display( by_id = $event.oSource.sId )`, the row-0
record seeded at the model root and bound **absolutely**.

Three things came out of it:

- **The rulebook contradicted itself.** The `idiom-lookup` bindElement row said
  to seed row 0 at the root and *keep the fragment's relative `{FIELD}`
  bindings ("they resolve against the root")*; the `port-a-sample` gotcha said
  the opposite and named the seven ports that had shipped the wrong form
  (142 175 195 206 209 229 243). The gotcha is right —
  `JSONModel._getObject` resolves a relative path against the context and
  returns `undefined` when there is none. Both guides now say bind absolutely,
  and the manual audit they described is the linter rule
  **`relative-binding-without-context`**.
- The rule's first version **reported four corpus bindings** — `sap.ui.table`
  column `template`s, which are cloned per row and take their context from the
  table's `rows` binding in a *sibling* aggregation. The corpus was right; a
  `template` aggregation now counts as a row context and the corpus is back to
  0 findings.
- **`Popup.setWithinArea` is not reachable from ABAP**, and it is the sample's
  whole point. `sap.ui.core.Popup` is a static module: `control_by_id` needs an
  id it has not got, and `control_global` knows a closed set of four objects.
  The port opens against the viewport, declares it, and the gap is filed as
  **`pr/popup-within-area`** (add `POPUP: ['setWithinArea']` to the
  `CONTROL_GLOBAL` targets, taking the existing `domRef` arg kind, with an
  empty argument reaching the method as `null`).

One porting rule fell out of the first draft: **one builder chain per view.**
The first version built the two list popovers from one parameterized helper and
split the chain across statements — which works in a system (the builder keeps
its cursor) but leaves the reconstructor re-rooting the second statement into a
two-root document, and left `structural-diff` counting one popup where the
original has three. Three methods, one chain each, one per original fragment
file.

## The metadata snapshot is now the linter's own artefact (2026-08-02)

`ui5/properties.json` regenerated with the **linter's** `generate-metadata.mjs`
against this repo's OpenUI5 checkout (1.152), and the dependency re-pinned from
the merged feature branch to the linter **main SHA `10c700b4`** — the two
follow-ups STATUS carried since the generator consolidation are closed.

What the new snapshot changed, exactly as predicted:

- The old parser's two **false deprecations** are gone. It attributed a
  file-level `@deprecated` JSDoc block sitting on a *local variable* to the
  CONTROL, marking `sap.f.semantic.SemanticPage` and `sap.f.DynamicPageTitle`
  deprecated @1.54 although neither class doc says so. App 166 is therefore
  **in scope**, its `scope-exceptions.json` entry was stale, the gate said so,
  and the entry is removed — 6 exceptions → 5, `sap.f` in-scope 32 → 34.
- `sap.ui.core.XMLComposite` gained the deprecation it always had (@1.88), so
  its two samples moved from *nonapp* to *deprecated* — no port affected, the
  family was never portable.
- The snapshot is the full member shape now (976 controls, ~479 kB against the
  old 925/159 kB), i.e. byte-for-byte the artefact the linter generates for
  itself, only at this repo's OpenUI5 version.

One diagnosis worth keeping: the richer snapshot made
`generate-overview.mjs` report `sap.m.HeaderContainer` as
**"no longer in OpenUI5"**. It never left — `ui5/openui5-entities.json` holds
only entities `properties.json` does *not* carry, and the control had just
been picked up by the growing snapshot. The message now reads "no longer
needed here", with the reason in a comment above the check.

## Batch b20 (284) — a controller-built dialog, and the id nothing validated (2026-08-02)

**284 `sap.m.sample.MessageViewInsideDialog`** (`sap.m.MessageView`). The
sample's `view.xml` is one Button; the Dialog, its custom-header Bar with the
nav-back Button and Title, the MessageView with its MessageItem template and
Link — all of it is built in `onInit`. The port rebuilds them as a
`core:FragmentDefinition` shown with `popup_display`, and splits the
controller's three imperative reaches the way the rulebook says: `setVisible`
and `setText` become **two-way bound state** (`visible={/BACK_VISIBLE}`,
`text={/DIALOG_TITLE}`), and only `navigateBack` — which has no bindable
equivalent — stays a `control_by_id` frontend action on the popup slot.

Which exposed the last unvalidated part of that wire: **the id**. Everything
else in a `CONTROL_BY_ID` call is checked (the action token, the method for
the closed-set actions, the obsolete empty view slot), but the id itself was
taken on trust — and a wrong one is silent in exactly the way the whole rule
family exists for: the frontend finds no control, logs it, and the button
does nothing. Now the linter rule **`frontend-action-unknown-id`**: every
literal id in a `CONTROL_BY_ID` wire is matched against the ids the class's
views declare, across all slots. It stays quiet unless *every* `id` attribute
in the class is a literal, so a class that builds ids at runtime is never
guessed at. 0 findings over the 284-file corpus; proven by miscasing 284's
own `messageView`.

## Batch b16 (282/283) — sap.ui.core reaches full in-scope coverage, and two gate defects (2026-08-02)

Two sap.ui.core depth ports, both idiom-first picks; they happen to be the
last two in-scope gaps of that library, so `sap.ui.core` is now **20/20**.

- **282 `sap.ui.core.sample.TypeDateAsDate`** (`sap.ui.model.type.Date`) —
  the sibling of 181 with the paradigm inverted: the original model holds a
  **JS `Date` object**, which is exactly what a JSON model cannot carry. The
  port keeps every binding-info 1:1 and only adds `formatOptions.source`
  `{ pattern: 'yyyy-MM-dd' }`. Without it `sap.ui.model.type.Date` raises a
  `FormatException` on the first `format()` and the field stays empty —
  invisible to both the property gate (the member is fine) and the render
  gate (it mocks the model). That gap became the linter rule
  **`date-type-without-source`** (0 findings over the 284-file corpus, proven
  to fire by stripping the source from 181).
- **283 `sap.ui.core.sample.ThemeCustomClasses`** (`sap.ui.core.theming`) —
  the first port whose `core:HTML` `content` carries a **real binding**
  (`{STYLECLASS}`), the exact opposite of the escaped-brace CSS case (app
  028): here the braces must stay unescaped. Its model is scraped from
  `document.styleSheets` in the original, which no backend can do, so the 26
  rows are seeded from the OpenUI5 base theme source (IMPROVISED). The
  original's `onAfterRendering` border patch becomes a computed `BORDERSTYLE`
  column — the thin-frontend form of the same effect. Upstream detail kept
  honest: the sample's `borderWidth = "1xp"` is a typo the browser drops, so
  it is not reproduced.

**Coverage was being measured wrong.** The README's `Ported` column counted
*every* port against the *in-scope* sample count, so the six documented
out-of-scope ports inflated it — `sap.ui.core` read 19/20 while 18 of its
ports were in scope. Adding this batch pushed it to 21/20 and the ratio > 1
crashed the whole gate chain in `String.repeat`
(`RangeError: Invalid count value: -1`) inside the coverage bar — a stack
trace where the real news was a miscount. `generate-coverage.mjs` now counts
in-scope ports only, states the out-of-scope ports on their own line, and
clamps the bar so the same class of bug can never again look like a broken
generator (lesson in the `regenerate-artefacts` guide).

## Live check closes 13 ports — and a round-trip that drops keystrokes (2026-08-02)

The maintainer live-checked the hidden-picker family and the whole b15 depth
run. **`checked` 51 → 63, open LIVE_TESTs 43 → 35 ports.**

- **016 / 256 / 257 — the hidden-picker class is closed.** All three anchors
  open the `hideInput` picker and the change toast carries the picked value.
  That also settles the 2026-07-30 headless finding: the `Popover.onfocusin`
  recursion (*Maximum call stack size exceeded*) is **headless-only** — the
  picker works in a real browser, so no port change is needed and the e2e
  interaction stays deliberately unarmed for this class (app 091 covers the
  openBy idiom). Recorded honestly: the check covered the visible behaviour,
  the console was not necessarily inspected for a silent recursion warning.
- **272–281 promoted to `checked`.** One open leg was deliberately kept: 277's
  phone-portrait branch of the `MessageStrip` expression needs a real device
  rotation, which neither a desktop check nor the harness performs.
- **Three new e2e interactions (279/280/281), green over two consecutive runs.**

The interesting part is what writing them measured:

- **A per-keystroke round-trip is lossy, not queued** (now AGENTS §10). Typing
  `abc` into app 280 with no delay left `GET_VALUE` at `a` while the TextArea
  itself held `abc`: abap2UI5 serializes round-trips and **drops** events fired
  while one is in flight. The port is correct — the original updates its Text
  client-side, so under fast typing the backend-held value lags and can skip
  intermediate values, converging as soon as typing pauses. The interaction
  types with a 700 ms delay; the limit is declared in the sidecar.
- **281's selectionFinish leg is not machine-drivable.** It fires only when the
  picker *closes*, and headless neither F4 nor Escape reaches the picker once
  focus sits in the item list, an outside click does not dismiss it, and
  `getPicker()` is null on the registry instance. The armed interaction covers
  the selectionChange leg (the toast carries the real item text via
  `${$parameters>/changedItem}.getText()`); the finish leg is live-verified.
- **279's load leg cannot be checked headless** either — the seeded product
  image sits on `sdk.openui5.org` and the harness serves only `/resources/`
  locally, so the error path already fires at boot. The interaction asserts the
  error→swap round-trip (via the control's own `getVisible()`, not just text).

One methodological note worth keeping: the harness truncates a thrown error
message to ~200 chars, which made a control-registry dump look as if two
`sap.m.Text` controls were missing from app 280 — they were there all along.
Write diagnostics to a **file** from the interaction (it runs in Node), never
into the error message.

## Four depth ports: the MessageBox matrix, an image error fallback, a live-update TextArea, select-all (2026-08-02)

Four idiom-first depth ports into b15 — 276 → 280 ports, every gate green
(abaplint ×3 incl. a 702 downport in a throwaway copy, validate-meta,
pattern-lint, structure-lint, structural-diff **0 undeclared**, render-smoke,
property-check, data-fidelity).

- **App 278** (`sap.m.sample.MessageBox`): the type matrix — `confirm`,
  `alert`, `error`, `information`, `warning`, `success`, plus the two
  action boxes and the responsive-padding one. `client->message_box_display`
  takes the sample's own method name as `type` (`Messages.js` resolves it as
  `MessageBox[TYPE]`), so the mapping is literally 1:1 and every per-method
  default (confirm's [OK, CANCEL], error's [CLOSE]) stays UI5's. The
  `onClose` toast is the interesting half: the original composes it on the
  client, the port lets the pressed action ride back through the `onclose`
  event and builds the same sentence in ABAP — the action becomes
  backend-visible, which is what that return path is for.
- **App 279** (`sap.m.sample.ImageErrorWithIllustration`): the `error`/`load`
  round-trip drives one `HAS_ERROR` flag, and the two `visible` expression
  bindings over it swap the `Image` for the `IllustratedMessage` (@1.98,
  declared POST_171 **by policy** — the control is not in `properties.json`,
  so no gate would have asked). The controller's `Device.system.phone` size
  branch is **not** resolved to one value: it stays a branch as an expression
  over the shared device model (the 277 precedent), so both sizes survive.
- **App 280** (`sap.m.sample.TextAreaValueUpdate`): the sample exists to show
  the gap between the control's own value and the model property while
  `valueLiveUpdate` is off — so the port must **not** bind both Texts to one
  field. `liveChange` carries `${$parameters>/value}` to the backend into a
  separate `GET_VALUE` field, the second Text keeps the TextArea's own field,
  and the `Switch` two-way binds `valueLiveUpdate` itself. Porting it any
  "simpler" would have deleted the demo.
- **App 281** (`sap.m.sample.MultiComboBoxSelectAll`): `showSelectAll`
  (@1.111, POST_171) over the full 123-row `ProductCollection` with the
  original's `sorter: { path: 'NAME' }`. `selectionFinish` needs the whole
  selection, so the control gains a `selectedKeys` binding (the 092 idiom —
  the original reads `getSelectedItems` imperatively) and ABAP joins the
  matching names into the sample's `['A','B']` form. Both toasts round-trip
  rather than being client-composed, which also carries the original's
  `width: 'auto'` option that the client-composed wire cannot pass.

Two samples were **skipped as near-duplicates** on the same pass, which is the
depth rule working: `BreadcrumbsWithoutCurrentPage` differs from the ported
`Breadcrumbs` (app 003) only by the missing `currentLocationText` and the link
captions, and `MultiComboBoxDefaultFiltering`-class rows exercise nothing app
039/281 do not.

Lesson recorded in AGENTS §6: a sparse OpenUI5 clone that carries only the
`demokit/sample` trees makes **`scope-of.mjs` answer `UNRESOLVED` for every
entity** — it reads the control JSDoc from `src/<lib>/src`. It looks like an
unknown control and is really a wrong checkout, so the scope pre-check stops
gating silently. One clone must carry both halves.

## Repository assessment follow-up: rename debt, AGENTS distillation, pinned scope decisions (2026-08-01)

Three findings from a repository review, fixed in one change:

- **The repo rename to `ai-demokit` had left `abap2UI5/api` behind in six
  places** — most consequentially in `auto_downport.yaml`'s
  `if: github.repository == 'abap2UI5/api'` guard, which meant **the 702
  branch has not been rebuilt since the rename** (the workflow was skipped on
  every push to main). Also fixed: the five README badge URLs (pointing at the
  old repo's actions), the README/AGENTS titles, `package.json`
  name/repository/homepage (+ lockfile), the `REPO` default in
  `generate-coverage.mjs` (every `api.md` ABAP link) and the class URL in
  `generate-overview.mjs` (the overview app's source links). Lesson recorded
  in AGENTS §10: after a repo rename, grep for the old `owner/name` — a
  `github.repository` guard fails **silently** (the workflow is skipped, not
  red).
- **AGENTS.md distilled to the rules** (1398 → 1323 lines): discovery dates,
  probe war stories and retired-history asides removed per §10's own "write
  the rule, not the story"; every rule, app reference and gate description
  kept. One stale contradiction fixed: the last §10 bullet still claimed
  `property-check.mjs` cannot see `${$parameters>/…}` event parameters in a
  `t_arg` — it scans them since the 2026-07-20 fix (as §6 already said).
- **Scope exceptions now pin the facts they were decided on.** Each
  `ui5/scope-exceptions.json` entry carries `decided: { scope, since,
  deprecated }` (the verdict + control `@since` + deprecation `@since` at
  decision time), and `generate-coverage.mjs` fails when a universe/properties
  refresh changes any of them — so the six KEEP decisions are re-validated
  automatically on every metadata refresh instead of silently outliving their
  rationale. An entry without `decided` facts fails too (negative path
  verified: a pinned `since` mismatch exits 1 with a re-decide message).

## e2e round 3 — a whole broken binding class, and 13 LIVE_TESTs closed (2026-08-01)

- **Seven ports rendered EMPTY in the running app.** App 206 came out of the
  new interaction showing `x x` where its dimensions belong: the port had
  flattened the original's `binding="{/ProductCollection/5}"` onto the model
  root but kept the bindings **relative** (`{NAME}`), and a relative path on a
  control with *no binding context at all* resolves against nothing. The same
  form (with a sidecar note claiming the opposite — *"the relative bindings
  resolve against the root"*) sat in **142 175 195 206 209 229 243**. All are
  now bound absolutely through `client->_bind( field )`, every wrong claim is
  corrected in place, and all seven are e2e-verified.
  This is the app-207 class one level up, and again **no static gate could see
  it**: structural-diff matches on the last path segment, render-smoke mocks
  the model, property-check reads member names. Two lint changes came out of it:
  - new rule **`relative-bind-on-root-field`** — a `{FIELD}` literal whose
    FIELD is a root-level `DATA` scalar of the class and no row column. Zero
    findings over the corpus after the fixes, so the class cannot regrow.
  - **`numeric-bound-as-string` is now control-aware.** It fired on the ZIP
    code and house number of 142/175 the moment they became visible as binds:
    `value` is a float on a `Slider` and a **string** on an `Input`, so the
    attribute name alone proves nothing. Only a hit in a `NUMERIC_PROPS`
    (control, property) pair is a defect now; a synthetic check confirms the
    Slider case still fails and the Input case does not.
- Eighteen new `INTERACTIONS` entries, all green: **253/254/255** (one shared
  assertion for the value-state pickers — every non-`None` state reaches the DOM
  exactly once as `sapMInputBaseContentWrapper<State>`, and the bound
  `valueStateText` is written into the value-state node), **267** and **269**
  (DynamicSideContent), **268** (the anchored ColorPickerPopover open),
  **270** (the keyboard-driven Slider resizing the Panel) and **271**
  (`layoutChange` round-trip + the `containerQuery` expression binding), plus
  the "controller sets a width from a slider" class in one shared assertion
  (**144** with its round-trip, **176/213/214** with the expression binding),
  the server-side device branch (**173**), the bound-record ports
  (**195/206/209/226**) and the sorter inside a raw binding-info string
  (**225**). Open LIVE_TESTs **57 → 44 ports**. Partial coverage is recorded as
  such: 268 keeps its LIVE_TEST for the two legs that need a real colour pick,
  229 for its second popover and the footer buttons.
- Two measurements worth keeping: a `GridLayoutBase` extends **ManagedObject**,
  not Element, so a `customLayout` is in **no** `Element.registry` — read it
  through its `CSSGrid` (that cost one wrong "the port drops the layout"
  conclusion). And app 271's `layoutChange` only fires once `containerQuery`
  is on **and** the container actually changes size, so the interaction flips
  the SegmentedButton and then shrinks the viewport.
- **Driving a control that has no layout headless.** Two selectors died on the
  same cause: the theme CSS never loads in the harness, so `sapUiIcon` and
  `sapMSliderHandle` render with a **zero-size box** and playwright refuses to
  click or focus them. The fixes are the two general workarounds, both real
  gestures: `locator.dispatchEvent('click')` for the icon (UI5's `Icon`
  listens for the DOM click) and `element.focus()` + `keyboard.press(…)` for
  the slider (the Slider's own key handling then moves the value through the
  two-way binding). Recorded in AGENTS §10.
- **A viewport resize is a legitimate test input.** App 267's whole
  `_updateToggleButtonState` wire only fires below 720 px, so the interaction
  calls `page.setViewportSize({ width: 400 })` and then waits for the bound
  `enabled` flag — the first interaction that produces its own breakpoint.
- `--only` now takes a comma-separated list (`--only 268,270`), which is what
  iterating on a handful of ports actually needs.
- **Full sweep green: 270/270 ports, 0 failing** (the build that carries the
  seven binding fixes).
- One more trap, now in AGENTS §10: **a deviation text is a gate escape.**
  Rewriting the `LIVE_TEST` prose of 176/213/214 into verified prose dropped
  the sentence that declared their missing `Slider.liveChange`, and
  structural-diff went from 0 to 3 undeclared findings. Keep the naming clause
  when you rewrite a deviation.

## Session close 2026-08-01 — state handed over

- Both faked-event-value fixes are **e2e-verified** on the rebuilt backend
  (100 boots clean, 133's press toast now names the item id).
- All gates green at hand-over: abaplint 0 · pattern-lint 0 · validate-meta
  276/276 · structure-lint 0 · data-fidelity 0 · property-check 0 ·
  render-smoke 276/0 failing (1 declared skip) · structural-diff 0 undeclared.
  The last **full e2e sweep was 274/274 green**; the three ports added after
  it (275–277) are each verified individually with their own interaction, so
  the next nightly is the first run to cover all 276 in one go.
- Where to pick up: **40 ports** still carry a `LIVE_TEST`, of which only 149
  and the three hidden-picker ports (016/256/257, the `Popover.onfocusin`
  recursion) have no interaction at all — the rest are partial legs named in
  their sidecars. Batch planning stays depth-only; sample templates come from
  the sparse OpenUI5 clone (`OPENUI5_SRC=/home/user/openui5-sparse`).

## The faked-event-value audit is closed — and it was a script (2026-08-01)

- The last open item of the review-sweep backlog turned into
  `scripts/probes/faked-event-value-audit.mjs`: for every port it reads the
  sample's own controller, keeps the `MessageToast.show(… + oEvent…)` calls
  that compose their text from event data, and reports the port if its own
  wire carries a **constant**. Four hits, **two real**:
  - **App 133** (`GridListModes`) toasted *"Selection changed"*, *"Delete
    item"*, *"Request details"* and *"Pressed item"* — four constants where
    the original names the item. Now client-composed:
    `{0?Selected:Unselected} item with ID {1}` over
    `${$parameters>/selected}` + `${$parameters>/listItem}.getId()`, and
    `… with ID {0}` over `$event.oSource.sId` for the other three.
  - **App 100** (`QuickView`) toasted *"A QuickView link was clicked"*,
    dropping both the link identity and the back-button branch. The navigate
    event now transports
    `${$parameters>/navOrigin} ? ${$parameters>/navOrigin}.getText() : ''`
    and an ABAP `COND` rebuilds the original's if/else.
  - The other two (118 `CardsLayout`, 203 `OverflowToolbarTokenizer`) are
    deliberately dropped interactions, already declared IMPROVISED — the probe
    prints them so a reader can re-check the decision, not fix it blindly.
- Neither defect was visible to any gate: structural-diff compares attribute
  names, render-smoke mocks the model, property-check reads member names. The
  same blind spot as the relative-binding class found this morning.

## The keyboard reaches what the mouse cannot (2026-08-01)

- The two ports written off in the morning round are covered after all, and
  the fix was the same in both cases: **focus + key instead of click**.
  App **008**'s palette swatch takes `Enter` and toasts
  *Color Selected: value - gold, defaultAction - false*; app **233**'s
  PurchaseID Input takes **F4**, the keyboard form of `valueHelpRequest`, and
  the SelectDialog opens client-side through `control_by_id` with its bound
  rows. A DOM click reached neither. Recorded in AGENTS §10 next to the
  zero-size-box rule: try focus+key before giving a control up.
- Still open on 233: the confirm leg — neither a click nor an `Enter` on a
  dialog row reaches the SelectDialog's `confirm` headless, so that stays a
  human check and the sidecar says so.
- Interactions for **101** (the wizard Cancel MessageBox), **141** (the
  announce round-trip writing the bound status Text), **196** (u:Currency over
  the four inlined arrays), **276** and **277** all pass on the new build.
  Open LIVE_TESTs **41 → 40 ports**; only 016/256/257 (the hidden-picker
  `Popover.onfocusin` recursion) and 149 now lack any interaction at all.

## Full sweep green on the fixed build: 274/274 (2026-08-01)

- The whole corpus re-run after the seven binding fixes and the re-armed
  overflow checks: **274 ports, 0 failing**, ~90 of them with a real
  click→assert interaction. Ports 276/277 were written after that build and
  are covered by the next one.

## Depth port TableContextualWidthDynamic — a controller that is one binding (2026-08-01)

- **App 277** (`sap.m.sample.TableContextualWidthDynamic`, b15): a
  `ResponsiveSplitter` over two `contextualWidth="Auto"` tables. Its whole
  controller — `onBeforeRendering` + `_orientationHandler` + `_showMessageStrip`
  + the `onExit` detach — exists to hide one MessageStrip on a **phone in
  portrait**. That is one expression binding on the shared device model:
  `visible = {= !${device>/system/phone} || ${device>/orientation/landscape} }`,
  which UI5 keeps current on every rotation. Four controller methods, no
  round-trip, and the added `visible` attribute is the only difference to the
  archived view.
- Both panes bind **one** inlined product table, mirroring the original's
  single model bound twice, so the two tables stay in sync as before.

## Depth port ListGrowing — a feature that needs no wire (2026-08-01)

- **App 276** (`sap.m.sample.ListGrowing`, b15): `growing` /
  `growingThreshold=4` / `growingScrollToLoad=false` are **pure client-side
  paging** over the bound aggregation, so the port needs no wire for them and
  stays init-only — **zero structural difference** to the archived view. The
  whole 123-row collection travels to the client exactly as the original's
  JSONModel holds it.
- One lesson from the same round (AGENTS §10): a sidecar text ends up
  **inside generated ABAP** — `generate-overview.mjs` inlines every deviation
  `what` into the overview app's literals, so app 275's NOTE quoting a CSS
  rule with raw braces next to the word "style" made pattern-lint's
  `unescaped-brace-in-style-content` fire on the *generated* file. Describe
  such things in words instead.

## Depth port GenericTileStates (2026-08-01)

- **App 275** (`sap.m.sample.GenericTileStates`, b15): the tile-state matrix —
  `Loaded` / `Loading` / `Failed` / `Disabled`, each once with and once
  without a press handler, plus a `SlideTile` over two news tiles. Purely
  declarative: the controller's single handler is a **constant**
  `MessageToast.show`, so every press is the roundtrip-free client toast and
  the app stays init-only. The four handler-less tiles keep no wire, so the
  "no press event" half of the sample still demonstrates exactly that.
- The sample's `style.css` is injected through a `core:HTML` `<style>` leaf
  (the 122/124/270 precedent) and declared as the one extra control. The two
  `SlideTile` background images point into **another** sample's folder and are
  kept verbatim, only host-absolutized — named in the sidecar so
  `data-fidelity` sees them.

## The overflow popover closes four more LIVE_TESTs (2026-08-01)

- With the fixed build all five re-run interactions pass (174, 218, 272, 273,
  274), and the **overflow-popover route was pushed further**: apps **207**
  and **247** — both written off as "not drivable headless" — are re-armed
  and green. 207's click-through (pick a list type, every bound row re-types)
  and 247's `WIDTHS_CHANGE` round-trip (pick 'Flexible', the columns come back
  at 25 %) are now machine-checked instead of human checks. 174 gained its
  third toolbar control, the SelectionMode Select.
- Two details that cost a red run each, now in AGENTS §10: an **overflowed
  `SegmentedButton` renders as a `Select`** in the popover, and the binding
  **template** of an aggregation sits in `Element.registry` beside the real
  rows with no binding context — `.every(row => …)` over "all items" fails on
  the template alone. Filter on `getBindingContext()`.
- Open LIVE_TESTs **44 → 41 ports**. 272 keeps its entry for the strip-close
  and Reset legs, with the two verified legs named.

## Five interactions, three lessons, one real port fix (2026-08-01)

- The first run of the newest interactions failed **5 of 5** — and four of the
  five were the harness being wrong, not the ports:
  - **App 272 was the real one.** The round-trip fired, but the toast read
    *Validation of field group '["Billing Information"]' triggered.* — an event
    parameter that is an **array arrives as JSON**, brackets and all. Fixed by
    indexing in the expression (`${$parameters>/fieldGroupIds}[0]`), which is
    also literally what the original controller does;
    `BindingParser.parseExpression` confirms the grammar takes `[n]` and even
    method calls.
  - **OverflowToolbar controls are drivable after all**: clicking
    `Additional Options` opens the associative popover and everything inside
    clicks normally (app 174's two ToggleButtons flip the grid Table's bound
    properties). That supersedes the "not drivable headless" note left on apps
    207/247 — their checks can be re-armed.
  - **App 218's ShellBar search is collapsed** behind a Search button; expand
    it first, then the SearchManager's client-composed liveChange toast fires.
  - 008 (a DOM click on a ColorPalette swatch fires no `colorSelect`) and 233
    (its ObjectPage header input never becomes actionable headless) stay
    **uncovered** — the interactions were removed again rather than left
    red, and both are named in the harness header.
- Both new AGENTS §10 entries came out of this round, plus one from a
  self-inflicted wound: `ps … | grep '[e]2e-build' | xargs kill` in a command
  line that also contains the plain string kills **your own shell** (exit 144,
  no output) — the same family as the `pkill -f express.mjs` case.

## Depth port DialogFullScreen — flags written only when set (2026-08-01)

- **App 274** (`sap.m.sample.DialogFullScreen`, b15): three controller-built
  Dialogs over the shared products mock (123 rows, `Name` + `Quantity`), again
  through one builder method — `popup_products_display( resizable draggable
  sized begin_ok )`. `showFullScreenButton` is **@since 1.149** and is the
  very property the sample demonstrates, so it stays and is declared
  `POST_171` (fidelity-first).
- Same discipline as 273, now with four flags: **each attribute is written
  only when the original passes it.** The plain dialog gets no
  `resizable="false"` and no `contentWidth` — a default written out explicitly
  is a fidelity loss no gate can see, because structural-diff compares
  attribute *names* and the name would match.

## Depth port DialogMessage — five controller Dialogs, one builder (2026-08-01)

- **App 273** (`sap.m.sample.DialogMessage`, b15): five press handlers that
  each `new Dialog({type: Message, title, state, content, beginButton})`. The
  port keeps the five trigger Buttons 1:1 and expresses every dialog as a
  `core:FragmentDefinition` shown with `popup_display` (app 019 precedent),
  built by **one** `popup_message_display( title state text )` method instead
  of five near-identical blocks — the handlers differ in nothing else.
- One detail worth the extra line of code: the **default** dialog is the only
  one the original builds *without* a `state`, so the port writes the
  attribute only when there is one. Emitting `state='None'` would have added
  an attribute the original never sets — a silent fidelity loss that
  structural-diff cannot see (it compares names, and the name would match).
- The OK button closes the dialog roundtrip-free via
  `_event_client( cs_event-popup_close )`, the direct form of the original's
  `this.oDialog.close()`.

## Depth port FieldGroup — the validateFieldGroup idiom (2026-08-01)

- **App 272** (`sap.ui.core.sample.FieldGroup`, new batch b15, `src/02`): the
  first port of `sap.ui.core.Control`'s **`fieldGroupIds`** + the form's
  **`validateFieldGroup`** event. Every Input/Select/ComboBox keeps its group
  id; leaving a group fires one backend event carrying
  `${$parameters>/fieldGroupIds}` (a single-element array that stringifies to
  the group name — the original reads `aFieldGroup[0]`), and the ABAP `CASE`
  is the controller's `mMessageMapping`. The three imperative setters per
  MessageStrip (`setType`/`setText`/`setVisible`) become a bound triple, and
  `onMsgStripClose` becomes one `close` event per strip because each target is
  statically known. **Zero structural diffs** — the view is 1:1.
- The sample sources came from a **blobless sparse clone** of SAP/openui5
  (~350 MB for the eight demokit sample trees): `/home/user/fork-openui5`
  carries only `src/<lib>/src` and has no samples at all, which reads like
  "no template available". Recipe recorded in AGENTS §6 next to the
  scaffolder.

## Depth port GridResponsiveness + a stale-build symptom worth naming (2026-07-31)

- **App 271** (`sap.ui.layout.sample.GridResponsiveness`, b14): the
  `GridResponsiveLayout` idiom — three `GridSettings` breakpoints
  (`layoutS`/`layout`/`layoutXL`) in the `CSSGrid`'s `customLayout`. Two
  controller handlers dissolve into bindings: the Slider→Panel width as in 270,
  and `onSegmentedButtonChange` (`setContainerQuery(key === 'true')`) as a
  **shared two-way field** — `selectedKey={/CONTAINER_QUERY}` next to
  `containerQuery={= ${/CONTAINER_QUERY} === 'true' }`, the string→boolean step
  the controller does in JS. No round-trip, no imperative setter.
  `layoutChange` does round-trip, because its `${$parameters>/layout}` is the
  only source for the info Text.
- Declared IMPROVISED: the **Reveal Grid** ToggleButton keeps its label but
  loses its handler — `RevealGrid.toggle()` is a sample-local JS module drawing
  a debug overlay (the same drop as app 145).
- **A stale transpiled backend now has a named signature** (AGENTS §10): a
  brand-new port fails e2e with `backend HTTP 500` whose body reads *"The app
  'Z2UI5_CL_SMPC_APP_269' does not exist in the system"*. That is always a missing
  `npm run node:build`, never a port defect. Two companion rules from the same
  round: never run `e2e-smoke` while a build is in flight (`e2e-build` wipes
  `node/output` first, so the run dies silently), and never wait for a build
  with `pgrep -f e2e-build` — the waiting shell matches its own command line and
  waits forever; grep the build log for `e2e-build: done` instead.
- Also this round: 097 (SplitApp `control_by_id` navigation) and 126
  (FileUploader upload toast) gained interactions; 126's assertion was corrected
  to the port's actual first toast (*'Uploading file to the local server …'*).

## Depth port NestedGrids — three known idioms in one port (2026-07-31)

- **App 270** (`sap.ui.layout.sample.NestedGrids`, b14): a `CSSGrid` inside a
  `CSSGrid`, the inner tiles positioned with `GridItemLayoutData`
  (`gridColumn="1 / 3"`, `gridRow`), the sample's `css/main.css` injected as a
  `core:HTML` `<style>` leaf (122/124 precedent) and `onSliderMoved` replaced by
  a two-way bound slider value plus the expression binding
  `{= ${/SLIDER_VALUE} + '%' }` on the Panel width — `sap.m.Panel` HAS a width
  property, so unlike apps 267/269 this jQuery-setter idiom binds cleanly
  (app 214 form). NOTE, not IMPROVISED: same rendered behaviour.
- **Two traps hit while writing it**, both worth knowing: writing the absolute
  path by hand (`{= ${/SLIDER_VALUE} …}`) trips pattern-lint's
  `hardcoded-binding-path`; and building it from
  `_bind( … path = abap_true )` inside `|…|` yields `${ /SLIDER_VALUE }` **with
  spaces**, which UI5 does not resolve — render-smoke caught it as
  `"null%" is of type string, expected sap.ui.core.CSSSize`. The correct form is
  the documented one: interpolate `_bind`'s braced result directly after the
  `$` (`|\{= ${ client->_bind( slider_value ) } + '%' \}|`).

## Depth port DynamicSideContentProduct + full sweep green (2026-07-31)

- **Full e2e sweep after the b14 ports: `266 port(s), 0 failing`** (268/269 came
  after that build and are covered by the next one).
- **App 269** (`sap.ui.layout.sample.DynamicSideContentProduct`, b14): the
  richer DynamicSideContent sample — `sideContentFallDown="BelowM"`, a
  `FeedListItem` list over the sample's own `feed.json` (4 rows verbatim) plus a
  `FeedInput`, and three controller behaviours reproduced server-side:
  `toggle()` and `setShowSideContent(false/true)` through `control_by_id`, and
  the `breakpointChanged` round-trip driving the Toggle button's `enabled`
  (S only) and the Open-Side-Content button's `visible`.
- The controller's **media model** (`new JSONModel(Device.system)`) is
  abap2UI5's shared `device>` model, so `{media>/phone}` folds to
  `{= !${device>/system/phone}}` on the same data — a NOTE, no loss.
- **One honest half-reproduction, declared:**
  `updateShowSideContentButtonVisibility` computes
  `!(breakpoint === 'S' || oDSC.isSideContentVisible())`. The second term is
  client state the backend cannot read, so the port binds the button to the
  breakpoint and flips the flag in both press handlers — identical in every
  path the sample offers, but a side-content change from elsewhere (the Toggle
  button) does not update it. IMPROVISED rather than a silent approximation.
- `sap.ui.layout` coverage 32.8 % → **34.4 %**.

## Depth port ColorPickerPopover — and two skipped near-duplicates (2026-07-31)

- **App 268** (`sap.ui.unified.sample.ColorPickerPopover`, b14): the controller
  lazily constructs four `sap.ui.unified.ColorPickerPopover`s (Default / Large /
  Simplified / with liveChange) and opens each with `openBy(input)`. The port
  declares all four in the Table's `dependents` with the same ids and
  configuration and opens them roundtrip-free via
  `_event_client( control_by_id, <id>/openBy/$event.oSource.sId )` — the
  anchored-open idiom of apps 016/060, now on a control the corpus had not
  used. `change` / `liveChange` round-trip so the backend writes the chosen
  colour into the right Input, toasts it and keeps the liveChange Text in sync.
- **IMPROVISED, deliberately**: `handleInputChange` validates the typed text
  with `sap.ui.core.CSSColor.isValid` and paints the Input's `valueState`. That
  is per-keystroke frontend logic; the thin-frontend rule forbids
  reimplementing it in a formatter, and a round-trip per keystroke would be a
  different behaviour — so an invalid entry is simply not flagged.
- **`ColorPicker` and `ColorPickerLarge` skipped as near-duplicates**: both are
  the already-ported app 112 (`ColorPickerSimplified`) with a different
  `displayMode` — same view, same controller. AGENTS §1 says a depth port that
  exercises nothing new is corpus weight without training signal, so the
  ColorPicker family contributes exactly one more port, the one with a genuinely
  new control and wiring.

## e2e round 2 results + depth port DynamicSideContentEqualSplit (2026-07-31)

- The 207 fix is live: the rebuilt backend shows `typeBinding: '/LISTTYPE'` and
  the model carries the shared field. Open LIVE_TESTs **55 → 52 ports** (029
  partial, 123/172/228 fully converted to `NOTE`s).
- **Two harness boundaries measured, not guessed.** A control that lives in an
  `OverflowToolbar` is *only instantiated when its overflow popover opens*, and
  in that popover it loses its usual root class — no viewport width brings it
  inline (tried up to 2200px). That killed the click-through for **207**'s type
  Select and **247**'s width SegmentedButton:
  - 207 keeps a `LIVE_TEST` but its interaction now guards the regression that
    actually bit us — it asserts through `page.evaluate` that the item template
    binds the **absolute** `/LISTTYPE`; a relative `{LISTTYPE}` would resolve
    against the row and kill the Select again.
  - 247's interaction was **removed** rather than left half-working; its
    `LIVE_TEST` stays open and honest.
- **App 267** (`sap.ui.layout.sample.DynamicSideContentEqualSplit`, b14):
  `toggle()` roundtrip-free via `control_by_id` (a public method needs no
  whitelist entry), `_updateToggleButtonState` as the `breakpointChanged`
  round-trip (`${$parameters>/currentBreakpoint}` → the bound `enabled` flag,
  enabled only on `S`), and the Slider's `visible` from the shared `device>`
  model — the declarative form of `onBeforeRendering setVisible(!phone)`.
  Declared IMPROVISED: the static `img>` fold and the dropped `liveChange`,
  whose jQuery width targets a `sap.m.Page` that has no width property to bind
  (apps 213/214 could bind theirs, this one cannot).

## Depth port SplitterNested1 — batch b14 opened (2026-07-31)

- **App 266** (`sap.ui.layout.sample.SplitterNested1`, `src/02/b14`): nested
  `sap.ui.layout.Splitter`s with per-pane `SplitterLayoutData`
  (`size` `auto`/`px`/`%`, `minSize`), the outer one `orientation="Vertical"`.
  Fully static, no controller — **zero deviations and zero structural diffs**,
  green on every gate first pass. `sap.ui.layout` is the thinnest ported
  library after the non-app scope rule, so depth starts here.
- The sibling `Splitter` sample was **skipped on purpose**: its controller
  builds the whole options panel imperatively (add/remove content area,
  invalidate, change orientation, a live resize counter). A port would drop
  most of it and carry a large IMPROVISED — weak training signal for a
  depth pick, so `SplitterNested1` is the better first Splitter port.

## e2e round 2: a dead Select found in app 207 (2026-07-31)

- Six more `INTERACTIONS` written (029, 123, 172, 207, 228, 247). 123 (bound
  `visible` flipped server-side), 172 (`SideNavigation.expanded` round-trip +
  itemSelect toast) and 228 (`sap.ui.unified.Menu` through the openBy fallback)
  pass; 029/247 wait on a backend rebuild.
- **App 207 (`ListItemTypes`) had a dead wire that no gate could see.** The
  `StandardListItem` template bound the shared type field **relatively**
  (`type="{LISTTYPE}"`), which resolves against the **row** — the rows carry no
  such column, so every item stayed `Inactive` and the type Select was
  completely without effect, while the sidecar claimed "selection re-types all
  items client-side". Fixed to the absolute path via `client->_bind( listtype )`.
- Why the gates were blind: `structural-diff` matches bindings on their **last
  path segment** (`listtype` == `listtype`, so relative and absolute look
  identical), and `render-smoke` mocks the model, so nothing renders differently.
  Only clicking in a real browser exposed it — the LIVE_TEST existed for exactly
  this and had been carried since the port was written.
- Rule recorded in AGENTS §5 (data binding): a field shared app-wide lives at
  the model **root**; inside a bound aggregation a relative `{FIELD}` silently
  renders empty, so bind it absolutely with `client->_bind( field )` even in a
  template.
- Three assertion fixes worth keeping as harness facts: the tnt navigation list
  is `.sapTntNL` (not `.sapTntNavLI`), 172's expanded state shows the sub items
  (`Office 01`), and 207's type Select lives in an **OverflowToolbar** — it is
  only instantiated once the overflow popover opens, so no viewport width makes
  it directly clickable. The harness gained `toHaveCountBelow` for the
  bound-`visible` case, where one of several same-named entries disappears.

## e2e interactions for batches b05/b13 — LIVE_TEST debt 62 → 55 ports (2026-07-31)

- With the transpiled backend freshly built (the expensive prerequisite), the
  named close path for the LIVE_TEST backlog was worth walking: **eight new
  `INTERACTIONS` entries** (258–265), each asserting what its sidecar had
  declared unverified, then the verified `LIVE_TEST`s converted to `NOTE`s.
  Open LIVE_TESTs: **62 → 55 ports**.
- What the new legs actually prove: 258 the `Translucent` anchor bar reaches
  the DOM; 259 the ProgressIndicator really displays `42%` (UI5 parses the
  `'42%'` string on the float property, as the original relies on) next to the
  RatingIndicator; 260 the header content survives a scroll to 1500px — that
  *is* `preserveHeaderStateOnScroll`; 261 the folded `ModelMapping` records
  render; 262 the `showFooter` round-trip plus the breadcrumb toast; 263
  `NavContainer.to` via `control_by_id`, there **and** back; 264 a bound prefix
  re-filters the rows, an empty prefix drops the filter again (the odata String
  type mapping `''`→null), and Toggle Filters re-bakes the set; 265 the per-row
  bound filter over the relative `value1: '{REGION}'`.
- **Three assertions failed first and each taught something**, so they are in
  the harness as measured facts rather than guesses: the `Translucent` class
  sits on the **in-flow** anchor bar (the sticky clone has a zero box, so
  `.last()` not `.first()`), `.sapUxAPObjectPageHeaderContent` **does not exist**
  in this release (assert the header text instead), and at 1280px the
  `Breadcrumbs` collapse into a `Select` — the link press is only reachable
  through its list.
- Residuals are named per sidecar instead of silently dropped: the title's
  `backgroundDesign='Solid'` has no DOM marker, `editHeaderButtonPress` needs
  header hover, the `setSelectedSection` reset has no stable marker without an
  icon tab bar, and `subSectionLayout='TitleOnLeft'` only changes the
  subsection's grid column math (`ObjectPageSubSection._calculateLayoutConfiguration`)
  — so 261 keeps its `LIVE_TEST` with the evidence appended rather than being
  promoted on a half-check.
- Harness gained `notToContainText` (poll-until-absent) — a filter assertion
  needs the negative form, and the previous helper had none.
- **Full sweep after the harness change: `264 port(s), 0 failing`** — the
  shared parts touched here (`notToContainText`, the extra 060 leg) regress
  nothing.

## pr/menu-item-selected-path closed — measured, not assumed (2026-07-31)

- The last open `pr/` request wanted the selected menu item's **ancestor
  breadcrumb** (`Create New Site > Official Store`) transportable; apps 060/061
  toasted only the leaf text, declared IMPROVISED on both.
- **Option 1 looked like a win.** Reading
  `sap/ui/core/mvc/EventHandlerResolver.js` shows the resolver hands the
  **whole** handler string to `BindingParser.parseExpression`, so a
  `$`-prefixed arg is a **full expression-binding expression** — embedded
  bindings mixed with method calls, `isA('…')`, string concat and ternaries.
  The corpus had only ever used the trivial `.getText()` form, which hid it.
  A ternary parent-walk was written into both ports and a throwaway browser
  probe (OpenUI5 1.152, `fireItemSelected` on a real nested `sap.m.Menu`)
  returned exactly `["Create New Site > Official Store", "Export Map"]`.
- **The e2e run against the transpiled backend then refuted it.** Clicking
  through the real menu still toasted the leaf text, and measuring the chain in
  the *opened* state explained why: `sap.m.Menu` re-parents its items through an
  internal `sap.m.MenuWrapper`, and the hop count to the parent `MenuItem`
  **changes with runtime state** — two hops while the submenu is closed
  (`MenuItem → MenuWrapper → MenuItem`), four once its popover exists
  (`MenuItem → MenuWrapper → Popover → ResponsivePopover → MenuItem`). An
  expression has no loop, so no fixed hop count is right in both states. The
  probe had only ever seen the closed state.
- **Closed as option 2 — a documented capability boundary.** The ports keep
  `${$parameters>/item}.getText()`; their deviations became **NOTEs** rather
  than IMPROVISED, because the same wrapper breaks the demo kit sample's own
  `while (oItem instanceof MenuItem) … getParent()` loop: **upstream toasts the
  leaf text too** on this release, so the ports were behaviour-identical with
  the live sample all along.
- Kept as the by-product: the **"an event arg is a full UI5 expression"** rule
  (AGENTS §5, CAPABILITIES frontend-action catalog) — real, proven, and useful
  for anything the client can compute from the event without a round-trip; only
  the *loop* is missing.
- The 060 e2e interaction gained a leg that selects the **nested** item and
  asserts the leaf toast, so the boundary is regression-guarded instead of
  merely written down. `e2e-smoke --only 060`: pass.
- `pr/menu-item-selected-path/` deleted per the pr/ convention (Implemented row
  left as the pointer). **`pr/` now holds no open request.**
- Process note: the first e2e failure was a **stale transpiled backend** plus a
  leftover express server from a debug run holding port 3000 — the browser kept
  getting the old wire. Rebuild with `npm run node:build` and check for a
  running `node .abap2UI5/node/srv/express.mjs` before believing an e2e verdict.

## Batch b13 — BoundFilters: breadth closed except the hold-out set (2026-07-31)

- **Apps 264/265** (`src/02/b13`, `sap.ui.model.Filter`): the two
  `BoundFilters.*` samples were the last `NEW-CONTROL` rows left after the
  non-app scope rule. With them ported, **every uncovered control in the
  backlog is a HOLDOUT** (`BusyIndicator`, `RadioButtonGroup`,
  `RatingIndicator`, reserved for the regression probe) — breadth is closed,
  planning is depth-only.
- **The idiom both samples exist for**: `boundFilters`, a binding-info
  parameter whose filter *values are binding expressions*, so the aggregation
  re-filters itself when a bound value changes (`ManagedObject.js:3711`,
  "Supported since 1.146.0"; both manifests declare `minUI5Version 1.146.0`).
  It goes into the raw `rows`/`items` binding-info string verbatim — 264 binds
  the four filter prefixes with `client->_bind( … )`, 265 uses the **relative
  row field** `value1: '{REGION}'` so every row's Select lists only its own
  region's account managers.
- **New property-gate blind spot recorded** (AGENTS §5): a binding-info
  parameter is not a control member, so it appears in **no** gate —
  `property-check` cannot see `boundFilters` at all. Declared `POST_171` by
  policy in both sidecars.
- **`onToggleFilters` → re-bake redraw** (app 241 idiom): the controller swaps
  the whole filter set with `oListBinding.filter(aOther,
  FilterType.ApplicationBound)`. abap2UI5 bakes binding info at render time, so
  `TOGGLE_FILTERS` flips the two-way bound `showorganizational` flag and calls
  `view_display( )` again with the other `boundFilters` list — same observable
  behaviour, no `binding_call` needed. CAPABILITIES' binding-filter row now
  carries both forms.
- Named-model fold in 264 (`filter>` + `ui>` → default-model root, same leaf
  names) is a **NOTE**, not IMPROVISED — same data, renders identically.
- Both ports land with **zero structural diffs** and green on every gate first
  pass: abaplint 0, pattern-lint 0, validate-meta 0, structural-diff 0
  undeclared, render-smoke 0 failing, property-check 0, data-fidelity 0,
  structure-lint 0. Coverage 264/741.

## Second scope rule: non-app samples are out of scope (2026-07-31)

- **User decision on the b05 finding**: the sample families that are not app
  views are **out of scope**, not an open ❌ gap. Implemented as a declarative
  `ui5/scope-nonapp.json` (one entry per family, each with its reason) read by
  both `generate-coverage.mjs` (`scopeOf` → new verdict `nonapp`) and
  `scripts/scope-of.mjs` (`--sample <Name>` → `OUT_OF_SCOPE (not an app
  view — …)`, exit 1), so the pre-port check and the coverage gate cannot
  drift apart.
- Families: `sap.ui.test.*` (OPA5 / gherkin / matcher — QUnit test pages),
  `sap.ui.core.routing.*` (Component routing across several views/targets;
  an abap2UI5 app serves one view per round-trip), and `View.*` /
  `ViewTemplate.*` / `XMLComposite.*` in `sap.ui.core` (view-type,
  OData-annotation templating and composite-control authoring demos — they
  demonstrate how a view is produced rather than being one).
- `sap.ui.core.mvc.ControllerExtension` joined the list in the same pass (user
  decision after the first cut): abap2UI5 has no frontend controller to extend,
  so the sample carries no view idiom to rebuild. Matching it by `entityPrefix`
  also fixed a hole in `scope-of.mjs`: its universe entry carries
  `entity: null` and the owning entity only comes from
  `ui5/entity-overrides.json`, which the CLI did not read — it now applies the
  overrides and evaluates the non-app verdict **before** the entity has to
  resolve in the fork checkout, so an unresolvable control no longer masks the
  verdict.
- Effect: **39 samples** move out of scope. In-scope denominator 665 → **626**,
  overall coverage 39.4 % → **41.9 %**, `sap.ui.core` 27.1 % → **80.0 %** —
  the honest numbers, since those 39 were never portable. `--backlog`'s
  `NEW-CONTROL` list drops from ~43 rows to two real ones
  (`BoundFilters.FilterBar`, `BoundFilters.FilteredListInTable`) plus the three
  HOLDOUTs. They stay listed in `api.md` marked `✗` for completeness.
- Deliberately left **in** scope: the two `BoundFilters.*` samples — real app
  views on `sap.ui.model.Filter`, worth porting. A ported sample matching a
  non-app family hits the same hard scope gate as a deprecated/newer one — no
  port matches today.

## sap.uxap batch b05 — the last two portable NEW-CONTROL rows + four ObjectPage idioms (2026-07-31)

- **Apps 258–263** (`src/03/b05`, the first uxap batch since b04): breadth-first
  first — `ObjectPageHeaderBackgroundDesign` (258) and
  `ObjectPageProgressRatingIndicators` (259) were the last two `NEW-CONTROL`
  rows in the backlog that are actually portable app samples
  (`sap.uxap.ObjectPageDynamicHeaderTitle`; `universe.json` carries `entity:
  null` for both, so the sidecars name the entity by hand). **Breadth is now
  exhausted**: every remaining `NEW-CONTROL` row is a `sap.ui.test`
  (Opa5/gherkin/matcher), routing, `View.*`/`ViewTemplate.*` or
  `XMLComposite.*` sample — QUnit/test-infrastructure demos, not app views.
  Batch planning is depth-only from here (see the STATUS.md finding).
- Then four idiom-first depth picks on `sap.uxap.ObjectPageLayout`, each
  carrying an idiom no existing uxap port has: 260 `ObjectPageHeaderExpanded`
  (`preserveHeaderStateOnScroll`), 261 `ObjectPageTitleOnLeft`
  (`subSectionLayout="TitleOnLeft"` + the `EmploymentBlockJob` ModelMapping
  fold), 262 `ObjectPageResponsiveAvatar` (the uxap twin of app 244:
  `breakpointChange` @1.147 → bound Avatar `displaySize`, `showFooter` toggle,
  `showEditHeaderButton`/`editHeaderButtonPress`, client-composed toasts) and
  263 `ObjectPageResetSelectedSection` (NavContainer `to` via
  `_event_client( control_by_id )`, the `navigate` round-trip, the
  `setSelectedSection` reset).
- **`selectedSection` is an ASSOCIATION, not a property** (`ObjectPageLayout.js`
  line 379) — so the usual scalar-literal→two-way-binding move does not apply,
  and a null association argument is not transportable through
  `control_by_id` either. App 263 therefore resets by setting the **first
  section's id**, which is exactly UI5's own fallback in
  `_adjustSelectedSectionByUXRules`. Rule recorded in AGENTS §10.
- **SharedBlocks archiving: tried, measured, rejected.** §4 says archive every
  file the manifest lists, so `ui5/sap.uxap/SharedBlocks/` +
  `SharedJSONData/` were copied in and the gates re-run. The six existing uxap
  ports stayed green, but the uxap manifests **over-list**: 259's manifest names
  the whole `EmploymentBlockJob*` set the view never instantiates, so
  `structural-diff` demanded phantom `layout:Grid`/`GridData`/`VerticalLayout`
  controls from ports that correctly do not render them. Reverted; the uxap
  block templates stay unarchived (as in every earlier uxap batch) and the
  block inlining stays declared per port. Rule recorded in AGENTS §4.
- Every block is inlined with its real view content (SimpleForm/Label/Text,
  the Grid tree of `EmploymentBlockJobCollapsed`, the six Panels of
  `ConnectionsBlock`) rather than a `core:HTML` placeholder — the 188/217
  practice, not the 161/187 coloured-div one. `POST_171` declared for
  `sap.m.Avatar` (control @1.73), `sap.m.Title.content` (@1.87, the Link nested
  in a Title of 259) and `ObjectPageLayout.breakpointChange` (@1.147).
- All gates green: abaplint 0, pattern-lint 0, validate-meta 0,
  structural-diff **0 undeclared** (262 ports), render-smoke 0 failing / 1
  declared skip, property-check 0, data-fidelity 0, structure-lint 0.
  Coverage 262/741.
## Pages demo: `Network error: ASSERTION_FAILED` on the overview's links / info popovers (2026-07-31)

- **User report**: on
  <https://abap2ui5.github.io/ai-demokit/?app_start=z2ui5_cl_smpc_app_overview>,
  pressing the chain-link or the information button of any row answered
  `Network error: ASSERTION_FAILED`. Those two buttons are the overview's only
  backend round-trips (everything else is `_event_client`), so the demo's front
  door was effectively read-only. Reproduced locally against the committed
  `docs/` bundle **and** against a freshly built Node backend
  (`npm run node:setup`), i.e. it was never app-specific.
- **Root cause — an open-abap serializer bug, not an app defect and not a
  "runtime limit".** `KERNEL_CALL_TRANSFORMATION`'s `LCL_DATA_TO_XML` builds
  `CALL TRANSFORMATION id … RESULT XML` output by string concatenation and
  writes element values **raw**. The overview's `NOTES` column carries
  deviation texts like `… are <= 1.71`, so `Z2UI5_CL_CORE_APP=>DB_SAVE`
  persisted a draft containing `<NOTES>… are <= 1.71 …</NOTES>`. The next
  request's `DB_LOAD` parses that back with the transpiled `CL_IXML`, whose
  parser reads the stray `<` as a tag start and dies in
  `ASSERT ls_match-offset = 0` — and an `ASSERT` is not catchable in the JS
  runtime, so the framework's `TRY … CATCH cx_root` around the draft load
  cannot absorb it and the round-trip 500s. A real ABAP server escapes the
  value and runs the same app fine. This also **corrects the 2026-07-27
  entry** below, which filed the same failure as an unfixable open-abap limit
  ("the overview cannot do a second roundtrip … dies in the transpiled
  `cl_ixml` parse").
- **Fix — patch the lib at build time.** `web/ci/patch_open_abap_xml.mjs`
  escapes `&`/`<`/`>` in character data on write (only for values that carry
  one, so everything else serializes byte-identically) and moves the `&amp;`
  replacement **last** in `LCL_ESCAPE=>UNESCAPE_VALUE` (a value containing a
  literal `&lt;` used to come back as `<`). Both transpiled builds now clone
  open-abap-core themselves and transpile against the patched copy: `web/`
  (`npm run assemble` + `ci/abap_transpile.json` `folder`) and
  `scripts/e2e-build.mjs` (`<A2>/node/open-abap-core` + a generated
  `e2e-transpile.json`). Forwarded upstream as `pr/open-abap-xml-escaping`;
  the patch scripts and their README sections go when it lands there.
- **Second half: the click was ~30 s even once it stopped failing.** The
  transpiled `CL_IXML` parse is quadratic in the draft size (it re-slices and
  `CONDENSE`s the remaining string per node), and the overview's draft was
  **578 kB** — 256 rows × generation notes, live-check text and four reference
  URLs, all of it public state only because the two popovers passed it back
  through the client as event args. Measured on the Node backend:
  `all_xml_parse` 29.8 s of a 31.3 s round-trip. The app now binds a slim
  `ty_s_row` (only what the table renders, sorts or filters on), keeps the full
  catalog in a local (`get_catalog( )` is a METHOD, so it is never persisted),
  and the presses carry only `${CLASS}` + the anchor id — `row_of( )` reads the
  pressed row and `derive( )` rebuilds its URLs server-side. Same UI, same
  popover content. Measured after: draft **199 kB**, `all_xml_parse` 3.4 s,
  click-to-popover ~3.9 s in the webpacked browser bundle (~5 s on the Node
  backend) — on this 4-core sandbox, so a normal machine is faster.
- Lessons written to AGENTS §10 (`ASSERTION_FAILED` in a transpiled build is a
  runtime artefact — table expressions and unescaped XML; every PUBLIC
  attribute is persisted state, so pass a key and look the payload up), plus
  `web/README.md` and `E2E.md`.

## Depth ports DateRangeSelection/DateTimePicker Hidden (2026-07-30)

- **Apps 256/257**: the 016 hidden-picker pattern (three anchors →
  roundtrip-free `openBy`, client-composed change toast) on the two sibling
  pickers, texts/ids/toast prefixes 1:1 from their samples. POST_171:
  `ariaHasPopup` (Button @1.84 / Link @1.86) + `hideInput`/`openBy` @1.97.
  Their LIVE_TESTs carry the 016 headless focus-loop caveat forward. The
  four-port picker family (253–257) closes the DatePicker-clan depth row.
  Coverage 256/741.

## Depth ports DateRangeSelectionValueState + DateTimePickerValueState (2026-07-30)

- **Apps 254/255**: the 253 valueState pattern applied to the two sibling
  pickers (254 adds the `delimiter` en dash, 255 the DTP id/labelFor pair).
  Both green across every gate first pass. Coverage 254/741.

## Depth port DatePickerValueState (2026-07-30)

- **App 253** (`sap.m.sample.DatePickerValueState`): bound
  valueState/valueStateText over a 5-row aggregation — every row carries a
  valueState, so the absent-enum trap does not apply, and the empty
  valueStateText falls back to the state default like the original's
  undefined. All gates green first pass. Coverage 252/741. The 251
  BusyDialog interaction moved to attached/detached asserts (the dialog box
  measures empty headless, the same class as the 238 popover).

## Depth port CarouselWithMorePages (2026-07-30)

- **App 252** (`sap.m.sample.CarouselWithMorePages`): the Carousel
  `customLayout` idiom — `CarouselLayout.visiblePagesCount` and the Input
  share one two-way field (`valueLiveUpdate` added so typing drives the
  carousel per keystroke like the original's `liveChange`), `scrollMode` is
  the expression binding over the two-way Switch state, and **onInit's
  `setSizeLimit(10)` rides 1:1 as the `set_size_limit` frontend action** —
  the full 123-row mock is inlined, exactly 10 pages render. POST_171:
  `ariaLabelledBy` (@1.125), `scrollMode` (@1.121). Coverage 251/741.

## Depth port BusyDialogLight — coverage crosses 250 (2026-07-30)

- **App 251** (`sap.m.sample.BusyDialogLight`): the controller's
  `oDialog.open()` + `setTimeout(close, 3000)` is the app-147 idiom applied
  to a dialog — `SHOW_BUSY` round-trips into `control_by_id BusyDialog open`
  plus `START_TIMER CLOSE_BUSY 3000`, the timer round-trip closes. The
  single-control `BusyDialog.fragment.xml` is inlined into `l:dependents`
  (the `core:Fragment` reference dropped, declared). Every fast gate green
  on the first pass. **Coverage 250/741.**

## Depth port ColorPalettePopover (2026-07-30)

- **App 250** (`sap.m.sample.ColorPalettePopover`, covered-control(1) depth):
  the controller lazily builds SIX differently configured
  `ColorPalettePopover` instances and `openBy()`s them — the port declares
  all six 1:1 in the view's `mvc:dependents` and opens each roundtrip-free
  via `control_by_id openBy` (the dependents-declared popup-mode idiom at
  its largest so far). `colorSelect` is the app-008 client-composed toast.
  Coverage 249/741.
- Two boundary findings, both declared: **an XML `string[]` attribute
  splits on commas**, so `hsl(0,100%,71%)` and `rgb(255,234,234)` cannot
  ride the `colors` attribute at all (CSSColor validation also rejects any
  escaping workaround) — they become their exact hex equivalents
  `#ff6b6b`/`#ffeaea`; and `handleLiveChange` paints the pressed button's
  icon via raw DOM styling (`getDomRef().firstChild...style.color`) —
  direct DOM manipulation with no bindable property, dropped IMPROVISED.

## Depth port ButtonWithBadge (2026-07-30)

- **App 249** (`sap.m.sample.ButtonWithBadge`, covered-control(1) depth pick,
  idiom-first): the badge idiom exists nowhere else in the corpus —
  `sap.m.BadgeCustomData` (@1.80, secondary control under the in-scope
  `sap.m.Button` headline, the app-244 Avatar precedent), `Button.badgeStyle`
  (@1.132) and the `BadgeEnabler` `setBadgeMin/MaxValue` methods via
  `control_by_id`. Coverage 248/741.
- Thin-frontend rewires, all declared: the StepInput and the badge share one
  two-way `/BADGECURRENT` field (the controller's `getBadgeCustomData().
  setValue()` copy becomes a binding, the StepInput `change` wire is
  dropped); the min/max clamp logic runs server-side with the
  reset-to-last-accepted behaviour of the original, and the accepted value
  reaches the button via `setBadgeMin/MaxValue` follow-ups; the icon/text
  `{= ${/flag} ? ${/value} : '' }` expression bindings port verbatim via the
  `_bind`-interpolation form. `badgeMin/Max` are `TYPE i` (the original
  model carries strings, the `numeric-bound-as-string` lint wants numbers —
  declared).

## Out-of-scope debt decided: all six ports KEEP permanently (2026-07-30)

- The six-port drop-vs-keep question (STATUS open findings since 2026-07-26)
  is **decided: KEEP, permanently** — taken in-session under the standing
  continue-with-everything mandate after the question had been surfaced to
  the maintainer four times without an objection; recorded so it can be
  revisited: reverting any one app is deleting the port + its
  `ui5/scope-exceptions.json` entry.
- Per-app rationale lives in the exceptions file: 121 UploadSet (deprecated,
  only upload-set coverage), 136 SidePanel (@1.107), 141 InvisibleMessage
  (@1.78, only a11y-announcement idiom), 165 ProductSwitch (@1.72, the most
  borderline), 166 sap.f SemanticPage (deprecated since 1.54, complements
  the sap.m.semantic ports), 203 OverflowToolbarTokenizer (experimental
  @1.139, documents the experimental-tag scanner lesson). All six are
  gate-verified working ports; deleting them would remove training signal
  the corpus has nowhere else.
- The class cannot regrow: the source-backed scope gate stays a **hard
  gate** (exit 1) for any NEW ported out-of-scope sample without a decided
  entry, and stale entries fail too. The generated STATUS row now reads
  "decided KEEP" instead of "pending".

## First GROUP-nested port: TreeTable.JSONTreeBinding (2026-07-30)

- **App 248** (`sap.ui.table.sample.TreeTable.JSONTreeBinding`) is the first
  port of a GROUP-nested sample (`<Group>.<Child>` universe naming, AGENTS
  §1) — and the only genuinely portable NEW-CONTROL entry left in the
  backlog tail (the rest is OPA/gherkin test samples, routing/view concept
  samples and OData tree bindings). `validate-meta`'s sample-name regex
  still rejected group names (`<lib>.sample.<Name>` with no dots); it now
  allows the dotted child part — the scaffolder already handled the
  mapping.
- The port models the fixed-depth Clothing tree as **nested ABAP types
  under a `CATALOG-CLOTHING` structure**, so the rows binding keeps the
  original's `/catalog/clothing` root + `arrayNames: ['CATEGORIES']`
  1:1 (`_bind` on a structure component resolves the deep path). Two
  homogeneous-type caveats are declared: a level-3 leaf carries an empty
  child array (JSONTreeBinding reads [] as a leaf), and a level-3 category
  row serializes initial `AMOUNT`/`SIZE` fields — `SIZE ''` stays hidden
  through the original's own `!!${size}` guard, and `Currency.value` gets
  the app-220 optional-value guard so category Price cells stay empty
  (declared; the plain `{amount}` would render `0.00`).
- All four toolbar actions are wired 1:1 roundtrip-free: `collapseAll` /
  `expandToLevel(1)` via `control_by_id`, and **Collapse/Expand selection
  via `$event.oSource.getParent().getParent().getSelectedIndices()`** —
  the resolved index array passes through `castArgAuto` untouched into the
  public `collapse`/`expand` methods. e2e interaction: expand first level →
  'Accessories' renders, collapse all → gone.
- Interactions batch 3 was trimmed to what proves stable headless: 132
  (tags-variant SideNavigation collapse round-trip) is armed and its
  LIVE_TEST converted; 097/101/172/207/233 need per-app debugging that
  outgrew this pass (Wizard footer clicks time out, SplitApp detail text
  never surfaces, the ListItemTypes Select id collides) — they stay
  LIVE_TEST, un-armed, for a later pass.

## Framework bug found by e2e: the MessageBox onclose action never reached the backend (2026-07-30)

- Arming the 093 close-confirm interaction surfaced a **real abap2UI5
  regression**: `Messages.js` passed the pressed MessageBox action INSIDE
  the event array (`eB([ONCLOSE, sAction])`, since #2441), but
  `Server.roundtrip` reads the event name from `ARGUMENTS[0][0]` and then
  **shifts the whole array away** — the action never landed in
  `T_EVENT_ARG`, so `get_event_arg( )` after an onclose event always
  returned initial. Every confirm dialog's OK/YES was indistinguishable
  from Cancel (silently — the wrong branch just ran). Fixed upstream on
  the abap2UI5 branch: the action rides as the first positional argument
  (`eB([ONCLOSE], sAction)`), the shape `evImageEditorPopupClose` already
  used; ABAP mirror regenerated (`app2abap`), abaplint 0.
- In the e2e harness the symptom was harsher than in a real system: the 702
  downport materializes the `t_event_arg[ v ]` table expression into a
  `READ TABLE` + `RAISE cx_sy_itab_line_not_found`, and e2e-build maps that
  RAISE to `ASSERT 1 = 0` — which the ABAP `TRY ... CATCH cx_root` does NOT
  catch, so the read of a missing arg 500s the round-trip instead of
  returning initial. Worth remembering when an e2e run shows
  `ASSERTION_FAILED at ...get_event_arg`: in a real system that path is a
  caught no-op.
- Affected ports: 093 (new close-confirm flow) and **101** (the Wizard's
  cancel/submit confirm — its `CANCEL_CLOSED` branch could never see `YES`
  under the broken wire). CAPABILITIES' MessageBox row now documents the
  regression window; both ports work unchanged with the fix. **With the fix
  in the rebuilt harness the 093 interaction runs green end to end** (close
  icon → confirm with the item name → OK → row removed + toast), and the
  audit interactions all pass (092/122/157/167/168/234/238 — 238's popover
  box measures empty headless, so its assertion reads the rendered text).
  Open-LIVE_TEST ports 49 → 47.

## Faked-event-value audit + formatter guard closure (2026-07-30, follow-up to the pr/-closure batch)

- **pr/formatter-date-empty-guard closed — already upstream.** The guard
  (`if (!s) return null;` in `DateCreateObject`) ships in abap2UI5's
  `model/formatter.js` with the exact Invalid-Date rationale as a source
  comment (ABAP mirror included). Folder deleted, Implemented row added;
  the port-side expression guards and the `unguarded-date-formatter`
  pattern-lint rule stay as defense in depth for systems on older
  framework releases. `pr/` is now down to ONE deliberately deferred
  request (`menu-item-selected-path`, user decision 2026-07-20).
- **The faked-event-value audit ran as a scripted sweep** over the 49
  `generated` ports (original controller reads `getParameter`/`getSource`
  values + port transports no `$`-arg + port toasts): four hits, each
  fixed 1:1 the same day:
  - **092** `TableAutoPopin`: `onPopinChanged` now composes
    `Number of hidden pop-ins: {0}` from
    `${$parameters>/hiddenInPopin}.length` client-side (was a static
    round-trip toast).
  - **093** `TabContainer`: the full `itemCloseHandler` —
    `check_prevent_default` on the itemClose wire (the original calls
    `preventDefault()` unconditionally), name + row index transported (the
    dnd `oParent.indexOfItem` idiom), `MessageBox.confirm` with `onclose`,
    OK deletes the bound row (`removeItem` for a bound aggregation) and
    toasts with the 500ms duration, Cancel toasts the cancel text.
  - **167** `ToolPage`: itemPress toasts the real item text, itemSelect
    navigates the NavContainer to the item's key page (roundtrip-free
    `control_by_id to` with `${$parameters>/item}.getKey()`),
    `sideExpanded` + the toggle tooltip are two-way bound with the
    pre-toggle tooltip semantics, the user popover (Feedback/Help/Logout)
    and the Quick Create dialog are rebuilt 1:1 (design guard server-side
    on `${$source>/design}`).
  - **168** `GridContainer`: the three switches now DRIVE the grid —
    `snapToRow`/`allowDenseFill`/`inlineBlockLayout` two-way bound to the
    switch states (007/128 pattern, change wires dropped and declared);
    `columnsChange` recomputes the bound columns counter; tile/card
    presses toast `Press was fired on - {0}` from
    `$event.oSource.getMetadata().getName()`; the sample-local RevealGrid
    helper stays dropped (145 precedent), now without a fake toast.
- Six new INTERACTIONS arm the fixes (093 confirm-close, 122, 157, 167,
  168, 234 FCL layout flip, 238 Card popover); results in the follow-up
  commit after the rebuild.

## Backlog sweep (2026-07-30) — three pr/ closed against upstream, the toast-substitution class reworked, INTERACTIONS 12 → 39

The two "deferred — too large" framework requests turned out to be **already
merged upstream** (abap2UI5 main had moved past our stale local ref):
`cs_event-keyboard_shortcut` and the MessagePopover URL policies landed with
**#2482**, and `s_ctrl-check_prevent_default` (the `eBP` wire) is in main too.
So the work was port integration, not framework code:

- **pr/ closed (3):** `core-commandexecution-keyboard-shortcuts` — app 232
  registers Ctrl+S/Ctrl+D on init, every `cmd:` button fires the same backend
  SAVE/DELETE/PSAVE events and the backend gates each command on its
  enabled/visible flags (residual: the registry is document-global, no
  popover-local command scope). `event-prevent-default` — app 241 bakes
  `check_prevent_default = prevent_default` into all eight press wires; the
  checkbox got a declared `select` wire whose redraw re-bakes the flag
  (status reset `checked` → `generated` per the invalidation rule).
  `messagepopover-async-url` — app 067 installs the `RELATIVE_ONLY` policy on
  init and wires the original's `urlValidated` toast 1:1. CAPABILITIES rows
  flipped ❌ → ✅ (keyboard shortcuts, conditional preventDefault) and a new
  `setAsyncURLHandler` row added; folders deleted, Implemented rows left.
- **Toast-substitution rework (9 ports, the STATUS backlog list):** 106/107
  (`${$source>/pressed}` toggle toast + the controller-built MessagePopover
  over the `message>` model as a MessagesIndicator dependent, seeded through
  the `z2ui5.cc.MessageManager` bridge), 112 (ResponsivePopover-with-
  ColorPicker via `popover_display`, the Device.system.phone branch as
  `device>` bindings), 147 (global BusyIndicator 1:1: `BUSY_INDICATOR`
  show(delay) + `START_TIMER` HIDE_BUSY duration → hide — the setTimeout
  chain as frontend actions), 149 (URLHELPER REDIRECT, the original's
  relative Card-Explorer URL), 170 (Card.fragment.xml rebuilt 1:1 into an
  anchored `popover_display` on both wired presses + the Edit button's
  `areaShrinkRatio` toggle as a two-way binding), 218 (the review-flagged
  `oSF.suggest()` popup-reopen wired as a second `control_by_id` follow-up),
  244 (`breakpointChange` @1.147 wired as a view attribute, POST_171 —
  Phone/Tablet/Desktop → bound Avatar `displaySize` + the media-range
  toast), 246 (the original `handleUploadPress`: two-way bound value,
  empty → 'Choose a file first', else `upload` + `clear` follow-ups;
  `checkFileReadable` declared inexpressible).
- **e2e INTERACTIONS 12 → 39**: per-port click→assert checks now cover every
  major LIVE_TEST class — client-composed toasts (003/005/008/016/049/061/
  074/076/080/134/156/198), popups & popovers (019/066/067/103/104/112/170/
  229/236/243), anchored opens (060/091/227), two-way round-trips (128/130/
  133/177), action chains (147/242/246), the new keyboard-shortcut (232),
  prevent-default (241), breakpointChange (244) and semantic-state (107)
  wires. The nightly e2e run is the close path that converts verified
  LIVE_TEST entries into NOTEs.
- All fast gates green at commit time (abaplint 0 across all three configs'
  root build, pattern-lint 0 — the 149 object-literal arg moved to the
  pipe-template form the `event-arg-bare-brace` rule expects —,
  structural-diff 0 undeclared, render-smoke 0 failing, data-fidelity 0,
  property-check 0).
- **e2e evidence + conversions (same day, follow-up commit):** the full
  246-port run finished **0 failing** with every armed interaction green
  against the freshly transpiled backend — including
  the three new framework wires (232 Ctrl+S → SAVE toast, 241 checkbox →
  redraw → 'Default was prevented', 244 viewport shrink → 'Media Range:'
  toast) and the reworked 147/170/112/246/107 flows. **Open-LIVE_TEST ports
  62 → 49**: fully covered entries became NOTEs with the run's evidence
  (003/005/049/060/074/080/091/130/133/147/156/177/198/236), partially
  covered ones keep LIVE_TEST with the evidence appended (061/066/067/076/
  103/104/112/128/134/227/229/232/241/242/243/246). Three harness findings:
  **(a)** `LIB_ROOTS` was a hand-kept six-package list, so `sap.tnt`/
  `sap.uxap`/`sap.ui.table`/`sap.ui.integration`/`sap.ui.codeeditor` ports
  "passed" the generic gate on their *Application Error popup* — the list is
  now discovered from `node_modules/@openui5` (the 241 interaction exposed
  the hollow pass); **(b)** app 016's `hideInput` DatePicker `openBy` opens
  the calendar but then loops in `Popover.onfocusin` headless (focus-restore
  bounces off the hidden input) — wiring is 1:1 with the original, recorded
  as a LIVE_TEST finding for the next live check, 091 covers the class;
  **(c)** app 008's palette squares render a zero-height box headless, so
  its colorSelect toast stays uncovered. The headless layout also collapses
  003's breadcrumb links into the overflow Select (the interaction goes
  through the picker) and hides 049's +/- icons (driven by keyboard).

## Backlog sweep (2026-07-28) — dead wires closed, an app-killing crash proved and fixed, the OpenUI5 snapshots refreshed

The open findings that were actionable without a live system, worked off in one
change:

- **`generate_result` had been failing since 2026-07-27** — its `npm ci` runs
  inside the freshly cloned OpenUI5 checkout, and OpenUI5's own committed
  `package-lock.json` had drifted from its `package.json` (`Missing: js-yaml@3.14.2,
  argparse@1.0.10, sprintf-js@1.0.3`), which `npm ci` treats as a hard EUSAGE
  failure. Nothing this repo can fix upstream, so the step falls back to
  `npm install` — we only need their jsdoc toolchain, not a reproducible install.
  **Verified end-to-end the same day, which also corrected the diagnosis**:
  OpenUI5 repaired their lock upstream on 2026-07-28, so `npm ci` succeeds again
  and the workflow would have recovered on its own. The fallback is therefore
  hardening against the next drift, not a live fix — but the outage was real and
  cost eight days of coverage refresh.
- **App 220 (`sap.ui.unified.CalendarMinMax`) did not just have a "crash risk" —
  it did not render at all**, and it is fixed. The 07-27 sweep had traced it in
  the sources; a probe now shows it empirically
  (`scripts/probes/calendar-empty-enddate-probe.mjs`, real OpenUI5 in headless
  Chromium, calendar focused on the month that carries the disabled dates):
  with the plain formatter binding over the empty `END` field the view throws
  *"Date must be a JavaScript or UI5Date date object"* and renders **0** calendar
  days; with the conversion guarded in the binding
  (`` `{= ${END} ? Formatter.DateCreateObject(${END}) : null }` ``, a backtick
  literal so the braces survive) the empty row yields `endDate` `null` and all 42
  days render. The probe also killed the obvious alternative fix: seeding
  `end = start` would disable **nothing**, because `Month._checkDateEnabled`
  compares a range strictly exclusive (`> start && < end`) and reaches its
  single-day branch only when there is no `endDate` at all. Distilled into
  AGENTS §10, CAPABILITIES (date-object row) and the new pattern-lint rule
  `unguarded-date-formatter`, which was regression-tested against the pre-fix code.
- **The dead-`_event`-wire class is closed** (BASELINE now empty). Six ports,
  each rebuilt the way the capability allows rather than left firing a
  round-trip no branch handled: 146 and 150 and 145 the thin-frontend way
  (two-way bound `value`/`selectedKey`/`selectedIndex` + an expression binding
  carrying the controller's own switch — the app-053 shape), 143 and 138 with a
  real `on_event` dispatcher over bound properties (`showFooter` /
  `areaShrinkRatio`, `showSideContent` / Toggle `enabled`), and 148 with the
  **full drag & drop reorder** — CAPABILITIES marks it ✅, so "reorder logic not
  reproduced" had been a wrong improvisation: the drop ships both row indices
  and the insert position as client-resolved `$`-args and `on_event` replays the
  original splice arithmetic in ABAP. 138 also now carries its
  `breakpointChanged` parameter (`${$parameters>/currentBreakpoint}`) instead of
  faking it. Two behaviours stay genuinely dropped and are declared as such:
  138's slider (a jQuery DOM width on a `sap.m.Page`, which has no width
  property) and 145's `RevealGrid` overlay (a sample-local helper module, not a
  UI5 API). The six keep status `generated` — the headline gap is closed and
  gate-verified, a full end-to-end re-review per port is not.
- **Five more capability-refuted substitutions replaced** in the same pass, each
  one a case where the port had claimed a loss the framework can express:
  **124** did a full backend round-trip per slider drag step → the same
  expression binding as 053/146; **160** toasted "Link pressed" where the
  original opens `MessageBox.alert('Link was clicked!')` → `message_box_display`
  (its own sidecar had already called this a wrong improvisation); **163**
  hardcoded each button's caption into its toast → `${$source>/text}`, and its
  dropped `ActionSheet.fragment.xml` is rebuilt 1:1 and anchored with
  `popover_display( by_id = $event.oSource.sId )`; **109** toasted only event
  names → `weekNumberPress`/`startDateChange` now carry their `weekNumber` /
  `date` parameters (`selectedDatesChange` stays name-only: its parameter is an
  array of DateRange *controls*, which is not transportable); **127** toasted a
  bare "Pressed" on the rationale that the runtime id is "not reproducible
  statically" → it does not need reproducing, `$event.oSource.sId` reads it off
  the event.
- **The dropped sample CSS of 122/124 is shipped** — and the "blocked" call that
  first went with it was wrong. `curl` to `raw.githubusercontent.com` is refused
  by this environment's proxy, and that was taken for "no OpenUI5 source
  reachable"; **`git clone` of `SAP/openui5` works fine**, which is what the
  pipeline uses anyway. With the checkout, both missing stylesheets were
  recovered and archived (closing that §4 archive gap) and injected into the
  ports through a `core:HTML` `<style>` leaf, the documented CAPABILITIES form.
  Both ports had been carrying the class names with no rules behind them: app
  122 rendered every icon at the default size (the sample is *about* icon
  sizes) and app 124's five grid tiles rendered as unstyled text instead of the
  blue rounded boxes. **Lesson: one blocked protocol is not a blocked network** —
  check the transport the tooling actually uses before declaring a task
  impossible.
- **The OpenUI5-derived snapshots were refreshed by hand** from that checkout,
  the work `generate_result` had not been doing since 2026-07-20:
  `ui5/properties.json` (831 → 928 controls), `ui5/universe.json` (736 → 741
  samples — five new `sap.f.HeroBanner` samples, all @1.152 and therefore out of
  scope) and `api.md`/README against real control metadata from OpenUI5
  **1.152.0**.
- **The `sap.ui.comp` overview rows no longer hand out links that 404.** The
  three OpenUI5 reference links (API, sample source, live runner) are built only
  for a library OpenUI5 actually ships; a `ui5_only` row renders just its ABAP
  class link plus a MessageStrip saying why. The commercial host stays excluded
  (`pattern-lint` `commercial-ui5-host`).
- **App 251 names the variant action through `client->cs_event-smart_variant_init`**
  now that abap2UI5 #2481 is on main — the last open cleanup of the smart-controls
  batch. `pr/smartvariant-initialise` is retired per the `pr/` convention (folder
  removed, recorded in the implemented table).
- **One new `pr/` request filed:** `formatter-date-empty-guard` — make
  `Formatter.DateCreateObject` return `null` for a falsy input instead of an
  Invalid Date. Low priority (every port can guard it itself, and pattern-lint
  now makes sure it does), but the unguarded failure mode is a whole-view crash
  that names neither the control nor the field.

Ladder unchanged (48 `generated` · 146 `reviewed` · 57 `checked`) — the reworked
ports keep their rung, the headline gap is what closed; open LIVE_TESTs 70 → 61. All gates green: abaplint STANDARD + CLOUD + the 702
downport, validate-meta, pattern-lint (incl. the new rule), structural-diff
--strict, structure-lint, property-check, data-fidelity, render-smoke.

## Overview state survives the browser Back button (2026-07-27)

User report: search something in the overview, or flip the Shell switch, start
an app and press Back - the overview comes back in its default state. Two
independent causes, both fixed.

- **Framework (abap2UI5, branch `claude/ai-demokit-state-loss-cyz42a`,
  pr/nav-app-call-caller-draft).** Every roundtrip saves the app under a NEW
  draft id, and `nav_app_call` saves the CALLING app - including the two-way
  model delta that arrived with the triggering event - under that fresh id.
  The caller's hash entry, however, still carried the draft of its last
  RENDER, so Back restored the state the user saw before touching any
  control. The response now carries `nav_app_call_prev_app`/`_id` and
  `View1._repointCallerEntry` `replaceHash`es the caller's entry onto the
  fresh draft before pushing the called app's route (KEEP mode; first hop of
  a request only, so `A -> B -> C` keeps A's entry). Covered by
  `node/tests/view1History.spec.js` (6 cases, the repoint one fails without
  the fix) and an extended `test_stack_call`.
- **Overview app.** The search query lived only in the frontend: the
  SearchField had no bound `value`, and the filter is a `binding_call` on the
  table's items binding, which a rebuilt view starts without. The query is
  now two-way bound (`search_query`), so it travels with the START_APP event
  and comes back with the app state, and `view_display` re-applies the very
  same `binding_call` filter through `follow_up_action` whenever the restored
  query is non-initial. The Shell/tree switches and the three filter
  checkboxes needed no app change - they were already two-way bound and only
  ever lost to the framework issue above.
- **Not covered by an e2e run**: the overview cannot do a second roundtrip on
  the transpiled Node backend at all - reloading its own draft dies in the
  transpiled `cl_ixml` parse (`ASSERTION_FAILED`, uncatchable in JS), and a
  `nav_app_call` to a fresh app dies in `main_attri_db_load` for the same
  reason. Both are open-abap runtime limits, not app defects (a real system
  runs this daily), so the browser-level proof stays a human check; the
  framework half is unit-tested instead.
  **[Corrected 2026-07-31]** this was not a runtime limit: open-abap's
  `CALL TRANSFORMATION id … RESULT XML` writes character data unescaped, so
  the overview's own draft was unparsable XML. Fixed by a build-time patch —
  see the top entry.

## sap.ui.comp smart controls ported — and two lessons (2026-07-27)

New library tree `src/06` (`sap.ui.comp`), batch `b01`, apps 248-252 rebuilt
from the SAPUI5 **Smart Controls tutorial** (SmartField, SmartForm,
SmartFilterBar+SmartTable, page variant management, SmartChart). `sap.ui.comp`
ships only with SAPUI5, so the ports sit outside the OpenUI5 universe, the
`render_smoke` runtime and the property gate by design — AGENTS §3 documents
each exception, `ui5/sap.ui.comp/README.md` the template provenance (the
public SAP-docs sources, since no OpenUI5 checkout carries these samples).

Three lessons came out of the review and the first live run, all now encoded:

- **Never invent a service path.** The first draft pointed every port at
  `/sap/opu/odata/sap/Z2UI5_SMART_TUT_0n_SRV/` — a name that exists in no
  system, which makes an app look runnable when it renders an empty control.
  Corrected to the Gateway demo service `GWSAMPLE_BASIC` (`ProductSet`,
  activate in `/IWFND/MAINT_SERVICE`) with the entity set / field-name
  adaptation declared IMPROVISED per port; where no standard service can
  serve the sample (app 252 needs an *analytical* one), the placeholder now
  reads as a placeholder: `…/<YOUR_ANALYTICAL_SERVICE>/`. Rule written into
  AGENTS §3 and CAPABILITIES.
- **The variant-save crash: solved, after seven refuted hypotheses.**
  Saving a view in app 251 throws `Cannot read properties of undefined
  (reading 'getId')`. `sap.ui.comp` is closed, but the crashing line is not:
  `sap/ui/fl/write/api/SmartVariantManagementWriteAPI.js:26` (and
  `SmartVariantManagementApplyAPI.loadVariants`) call
  `Utils.getAppComponentForControl(oControl).getId()` with no guard, and that
  helper returns `undefined` for an `undefined` control — the exact shape of the
  error. Four hypotheses then died on live evidence, in this order: the app
  component is missing (it resolves), `flexEnabled` gates it (the flag appears
  nowhere in `sap.ui.fl` — only `sap.ui.rta` reads it; a `pr/` request filed on
  that premise was withdrawn the same day), the `smartVariant` association does
  not resolve (XMLViews prefix single associations via `createId`), and no
  personalizable control is registered (`getPersonalizableControls()` returns 2
  and `loadVariants` resolves cleanly). The cause is still open — the lesson to
  keep is the method, not the answer: read the open-source half of the stack
  before filing anything, and check each hypothesis in the running app before
  writing it down as a finding. Port-side fixes landed regardless: the
  `pageVariantPersistencyKey` custom data the docs require, and the filter event
  moved off the backend round-trip.
- **Variant management needed a framework action — and got one.** Saving a
  view in app 251 threw `Cannot read properties of undefined (reading 'getId')`.
  Five hypotheses died on live evidence (app component, `flexEnabled`,
  association-id prefixing, registration, and the SAPUI5 docs' own page-variant
  wiring — which registers **0** controls where the sample's registers 2). The
  actual gap: `sap.ui.comp` expects a controller to call
  `initialise(fnCallback, oPersoControl)`; without it `_oPersoControl` stays
  `null` and `sap/ui/fl/write/api/SmartVariantManagementWriteAPI.js:26` dereferences
  it. Setting the field by hand in the console made Save As work at once, which
  sized the gap exactly. abap2UI5 now has `SMART_VARIANT_INIT` (branch
  `claude/smart-controls-samples-vdfr5y`, four specs, ABAP mirror regenerated;
  the test sandbox also needed the timer globals), and app 251 calls it via
  `follow_up_action`. Method note for next time: the closed half of a stack is
  usually reachable anyway — `sap.ui.fl` is open source and the running system
  serves the `-dbg` sources.
- **The answer: `setPersControler()`, the call a page variant never gets.**
  `addPersonalizableControl()` (read from the served `-dbg` sources) ends with
  `if (this.isPageVariant()) { return this }` **before** `setPersControler()` —
  the setter that both anchors the personalizable control and creates the control
  promise `initialise()` requires. A controller-less app therefore has neither:
  saving dies in `sap.ui.fl`, and once the field is forced by hand the write path
  works while the load path still aborts, so nothing shows after a restart.
  abap2UI5's `SMART_VARIANT_INIT` action now calls `setPersControler()` and then
  `initialise()` as soon as the control's wrapper exists. Live: `isInitialized:
  true`, 7 variants / 7 items, saved views back after a restart.
  What finally cracked it was a temporary tracing build the maintainer installed —
  every hypothesis before that was refuted by a console one-liner, and the ones
  that survived longest were the ones nobody could measure. **Method to keep:
  when the closed half of a stack blocks you, print the function itself
  (`String(oControl.someMethod)`) — sap.ui.comp's sources are served as `-dbg`
  files in the running app, so nothing here needed guessing at all.**
- **A SmartTable without a `UI.LineItem` annotation renders NO columns.**
  First live run of apps 250/251 against GWSAMPLE_BASIC came up with the
  "add columns to see the content" placeholder. The assumption written into
  the sidecars - that the control falls back to all metadata fields - was
  wrong; the initially visible fields have to be named. Both ports now carry
  `initiallyVisibleFields="ProductID,Name,Category,SupplierName,Price"` (an
  attribute the sample does not need, because its own service annotates its
  four columns), declared per port, and AGENTS §3 states the rule.
- **structural-diff was blind to camelCase namespace prefixes.** `isControl`
  matched the prefix as `[a-z]+:`, so every `smartForm:SmartForm`,
  `smartField:SmartField`, `smartTable:SmartTable`, … counted as a lowercase
  *aggregation* and was ignored on both sides — the whole comparison was
  vacuous for these five ports (they reported 0 diffs while one binding
  genuinely differed). The prefix is irrelevant to the control-vs-aggregation
  distinction; the regex now allows any prefix and the real diff surfaced
  (app 249 `{CategoryName}` → `{Category}`). No other port changed.

## pr/ backlog swept — two framework features landed, ports rewired (2026-07-27)

Full pass over the 12 `pr/` requests (user ask after the #37 merge). Result:
**8 implemented · 2 deliberately deferred · 2 niche-open**, every README now
carries an explicit status line.

- **Landed in abap2UI5** (branch `claude/ai-demokit-review-qavjtr`, one
  commit, abaplint 0, ABAP mirror regenerated via `npm run app2abap`):
  **(a)** the `openBy` dispatch falls back to
  `open(false, anchor, 'begin top', 'begin bottom', anchor)` for controls
  without an own `openBy` — `sap.ui.unified.Menu` — so the same wire covers
  every menu family (pr/unified-menu-open-anchored); **(b)**
  `enablePostButton: ["bool"]` listed in `CONTROL_METHODS`
  (pr/feedinput-enable-post-button).
- **Ports**: 227/228 needed no code change — their declared no-op `openBy`
  wires became functional (deviations rewritten IMPROVISED→NOTE, LIVE_TEST
  re-scoped). 236 rewired 1:1: the dialog buttons now toggle the owning
  FeedInput via `follow_up_action(enablePostButton)` + `popup_destroy`, the
  owning feed transported as a static button `t_arg` literal (added ids
  `feedActionPlain`/`feedActionIcon`, declared). Two new e2e INTERACTIONS
  (227 anchored unified.Menu open, 236 dialog→enable→close) verify both
  features against the transpiled framework.
- **Deferred with reasons in the READMEs**: `event-prevent-default` and
  `core-commandexecution-keyboard-shortcuts` both touch the core event
  protocol (eB array slots / a client shortcut registry) — too large to land
  without framework-side tests; `menu-item-selected-path` and
  `messagepopover-async-url` stay niche-open.
- AGENTS §5 cheat-sheet + CAPABILITIES frontend-action rows updated (the
  unified.Menu "current gap" caveat replaced by the fallback).

## Human live check + PR #38 distilled (2026-07-27, after the #37 merge)

- **Nine ports live-verified in a running system and promoted to `checked`**
  (065, 084, 085, 096, 108, 140, 164, 171, 241) — each closes a whole
  LIVE_TEST *class*: MessageManager cc, URLHelper triggers (the class the
  sandboxed e2e can never verify), Tokenizer two-way, SplitContainer
  `control_by_id` navigation, the date-object Formatter path, the two
  sweep-repaired ports (140/164), the nested-object runtime bind, and the
  tnt controller-built Dialog. CAPABILITIES upgraded in the same change:
  the nested single-object row is now **✅ live-verified** (was 🧪), and the
  MessageManager/URLHelper/SplitContainer-nav/date-object rows carry
  live-verified 2026-07-27 evidence.
- **PR #38 (human fix) distilled**: abapGit XML files MUST start with the
  UTF-8 BOM — four agent-written files lacked it; new pattern-lint rule
  `abapgit-xml-bom` gates every `src/**/*.xml` bytewise, and §10 documents
  it plus the second #38 lesson (a single giant `VALUE #( )` exceeds ABAP's
  maximum statement length — the overview catalog now splits in halves via
  `VALUE #( BASE result … )`, kept intact by the regenerated overview).
  The overview class was also regenerated with the merged generator — the
  #38 copy had been produced with a pre-#37 generator state and
  reintroduced the `<CLASS>` ABAP-Doc lint hit.

## Review sweep (2026-07-27) — the empty `reviewed` rung filled: 152 promoted, 49 flagged

The quality ladder's middle rung had been empty since its definition (0
`reviewed` ports). A full adversarial sweep over all 201 `generated` ports
(14 batches, each port read against its archived original, the mocks —
byte-level where inlined — and the abap2UI5/OpenUI5 sources) closed that:

- **152 ports promoted to `reviewed`**, ~60 of them after documentation/data
  fixes applied in the same pass: missing POST_171 declarations of
  gate-invisible members (control-level `NotificationList` @1.90,
  aggregation-level `Title.content` @1.87 / `StandardListItem.avatar` @1.98 /
  `IconTabFilter.items` @1.77, enum values Indication15–20 @1.120,
  `core:require` ≥1.74), wrong deviation vocabulary retyped per the settled
  policy, corrected audit flags, missing inline `"` comments, and real data
  fixes verified against the mocks (lost `&&`-join spaces in 076/077,
  neighbour-copied toast text in 157, an invented row + reordered tail in
  164, mock-contradicting literals in 113/115, ToolbarDesign enum order in
  086, missing `NEW_WINDOW` in 084, wrong token-delete text in 085, twelve
  malformed attribute lines in 140, §5 underscore-field renames in
  192/197/199/201/211/215/223/229/235).
- **49 ports stay `generated`** with corrected, honest sidecars — the rework
  backlog (STATUS.md open findings): dead `_event` wires without an
  `on_event` dispatcher (new pattern-lint rule `dead-event-wire`, 6 BASELINE
  entries), toast substitutions around expressible capabilities (the app-042
  class — several rationales were source-refuted, e.g. "MessageBox has no
  return path", "upload not whitelisted", "suggest not whitelisted"), faked
  event values where `$event.*` transport exists, dropped sample CSS
  (122/124 + §4 archive gaps), and one source-verified crash risk (app 220:
  `end=""` through `DateCreateObject` → invalid-date throw in
  `CalendarDate.fromLocalJSDate`).
- **New scope blind spot found and closed**: `sap.m.OverflowToolbarTokenizer`
  (app 203) is `@ui5-experimental-since 1.139` with no plain `@since` — both
  source scanners (`scope-of.mjs`, `generate-properties.mjs`) now read the
  experimental tag; 203 joins `ui5/scope-exceptions.json` pending the same
  maintainer decision as the other five.
- Concurrency note: the first sweep attempt hit the session limit mid-write
  (13 of 14 agents); partial edits were reverted and the batches re-run —
  only fully-reported batches were ever committed.

All gates green after the sweep (abaplint STANDARD+CLOUD, validate-meta,
pattern-lint incl. the new rule, structural-diff --strict, structure-lint,
property-check, data-fidelity, render-smoke). Ladder now: 49 `generated` ·
152 `reviewed` · 45 `checked`.

## Hold-out probe #2 (2026-07-26) — fidelity way up, syntax is the new frontier

Second regeneration probe, protocol identical to the 2026-07-19 baseline
(full write-up + gate table below). All 24
hold-out samples generated from scratch by fresh agents (restricted inputs,
no validation runs), scored once, adversarially reviewed (5 reviewers).

**Headline vs baseline:** review MAJORs **6 → 2**, undeclared structural
diffs **4 → 0**, render-smoke raw failures **2 → 0** (zero harness fixes,
was 2), invented data values **0** (data-fidelity green, reviewers verified
mocks byte-level). The two MAJORs are not rule gaps: 618 has a mechanical
paren-balance error (does not compile), 624 rebuilt a MessageBox as a
Dialog on a source-refutable claim (the app-042 lesson class —
`message_box_display` HAS `onclose`). abaplint-green-first-try dropped
22/25 → 19/24: **syntax slips in long builder chains (3 paren errors) are
now the dominant first-try failure mode**, while everything downstream of
syntax improved sharply. The property gate's documented enum blind spot bit
for real once (602 `CalendarDayType.NonWorking` @1.121, undeclared).
Friction logs contained zero capability complaints — nine recurring doc
gaps were distilled into AGENTS/CAPABILITIES in the same change (static-app
skeleton, camelCase-vs-references contradiction, rows-not-columns,
`controllerName` IGNORED_ATTRS, MessageBox `onclose`, MessageToast
positional call, leading-`{0}` template, stale whitelist-only
CONTROL_METHODS phrasing, sidecar `checked` omission). Probe ports were
never merged; only the report landed.

### Full write-up (moved here from `probes/` on 2026-08-18 — the directory collided in name with `scripts/probes/`, which holds executable probe scripts)

Second run of the TRAINING.md regeneration probe, protocol identical to
"Hold-out regeneration probe #1 (2026-07-19)" below (the baseline). All 24
hold-out samples of `ui5/holdout.json` generated **from scratch, first-try**
— no gate iteration, no self-checking tools — with the rule set as of commit
`54bd484` (post the 2026-07-26 infrastructure sweep: idiom cheat-sheet,
source-backed scope gate, data-fidelity gate, all-libs property gate).

### Protocol

Same as probe #1, with the deltas the repo's evolution forced:

- Workspace: a throwaway git worktree (probe batch `src/01/b90`, classes
  `z2ui5_cl_smpc_app_601..624`, numbered alphabetically by sample name). The
  probe ports are **never merged** — only this report lands on the branch.
- The hold-out set has 24 samples (probe #1 reported 25; the committed
  `ui5/holdout.json` carries 24 — same file, recounted).
- Originals: archived from the session's `fork-openui5` checkout per
  manifest `sample.files` into the worktree's `ui5/sap.m/<Name>/`.
- Generation: one fresh agent per sample; inputs restricted to
  `scripts/generation-prompt.txt`, `AGENTS.md`, `CAPABILITIES.md`, three §5
  worked references **(apps 007/040/022** — probe #1 used 408/421/454, the
  pre-renumber ids of the then-golden set; today's §5 table equivalents
  were used**)** with their originals/sidecars, `ui5/properties.json`,
  `ui5/universe.json`, `ui5/mock/`, and the sample's own original files. No
  other ports readable, no STATUS/TRAINING, no scripts, no validation runs.
- Scoring: all gates run once over the raw output (702 via `npm run
  downport` in a throwaway copy), then an adversarial AI review (5 reviewers
  × 4–5 apps) against the originals, the rules and the framework sources.
- Two gates exist today that probe #1 did not have (`structure_lint`,
  `data_fidelity`); they are reported additionally, not compared.

### First-try gate results (baseline #1 in parentheses)

| Gate | Result #2 | Failing apps | Baseline #1 |
|---|---|---|---|
| abaplint v750 | **19/24 green** (10 issues) | 602, 612, 613, 618, 624 | 22/25 (11 issues) |
| abaplint Cloud | 21/24 green (5 issues) | 612, 613, 618 | 22/25 (10 issues) |
| abaplint v702 (downport) | **not cleanly measurable this run** — `npm run downport`'s `--fix` chain aborts on the 3 parser-broken ports and leaves the copy half-rewritten (every file then reports downport errors, incl. clean 601); a pruned re-run exceeded the session budget (~10 min per fix pass). Treat v750/Cloud as this probe's syntax metric; the 3 parser apps are the known 702 blockers | 612, 613, 618 (parser) | 21/25 (12 issues) |
| validate-meta | **24/24** | — | 25/25 |
| pattern-lint | **24/24** (0 errors, 0 warnings) | — | 25/25 |
| structure-lint *(new)* | 24/24 | — | n/a |
| structural-diff --strict | **24/24 — 0 undeclared** (7 apps with declared diffs) | — | 23/25 (4 undeclared) |
| property-check | 24/24 (all-libs gate; but see review finding on 602) | — | 25/25 (sap.m-only, blind) |
| data-fidelity *(new)* | 24/24 — **0 invented asset/table values** | — | n/a |
| render-smoke --strict | **24/24 raw — 0 harness fixes needed** | — | 23/25 raw, 25/25 after 2 harness fixes |

### AI review verdicts

**18 CLEAN · 4 MINOR · 2 MAJOR** (baseline: 14 CLEAN · 5 MINOR · 6 MAJOR)

| App | Sample | Verdict | Core finding |
|---|---|---|---|
| 601 | BusyIndicator | CLEAN | |
| 602 | DatePicker | MINOR | undeclared POST_171: `CalendarDayType.NonWorking` enum value @1.121 (the documented enum blind spot, hit for real); pr/ candidate named in a deviation but not filed |
| 603 | Dialog | MINOR | pr/ candidate (escape-prevent bridge) named but not filed; otherwise clean incl. byte-exact 123-row mock |
| 604 | FormattedText | CLEAN | |
| 605 | Label | CLEAN | |
| 606 | MaskInput | CLEAN | |
| 607 | MessageStrip | CLEAN | |
| 608 | NavContainer | CLEAN | nav/toast idioms source-verified |
| 609 | ObjectMarker | MINOR | NOTE justifies a round-trip with a source-refutable claim (`get_t_arg` DOES quote a leading `{0}` template) — behaviour identical |
| 610 | OverflowToolbarDifferentControls | CLEAN | 70-row countries mock verbatim |
| 611 | PageFloatingFooter | CLEAN | controller-built panels faithfully rebuilt |
| 612 | Popover | CLEAN* | review clean, but abaplint parser errors (paren balance) — see below |
| 613 | QuickView | MINOR | POST_171 spots lack the required inline `"` comments; data fully faithful |
| 614 | RadioButtonGroup | CLEAN | |
| 615 | RatingIndicator | CLEAN | |
| 616 | ResponsivePopover | CLEAN | |
| 617 | SearchField | CLEAN | searchButtonPressed @1.114 declared |
| 618 | SelectDialog | MAJOR | does not compile: one extra `)` in a builder chain (+3 `omit_parameter_name`); fidelity content itself strong |
| 619 | StandardListItem | CLEAN | |
| 620 | TableAlternateRowColors | CLEAN | 123×7 fields verbatim |
| 621 | TimePicker | CLEAN | date-object/nested-structure idioms declared |
| 622 | Title | CLEAN | |
| 623 | ViewSettingsDialog | CLEAN | the 2026-07-19 `open [pageKey]` trap avoided correctly |
| 624 | Wizard | MAJOR | MessageBox replaced by a hand-built Dialog on a false framework claim — `message_box_display` HAS `onclose` and returns the chosen action (the app-042 lesson class) |

*612 reviewed CLEAN on fidelity but fails abaplint (paren balance) — counted red in the gate table, clean in review.*

### Reading vs the baseline

- **Fidelity is where the training signal went, and it shows.** MAJOR
  verdicts 6 → 2, undeclared structural diffs 4 → 0, invented/wrong data
  values 1-bug-class → 0 (data-fidelity green + reviewers verified mocks
  byte-level), render-smoke raw failures 2 → 0 with zero harness fixes.
  The two remaining MAJORs are NOT rule gaps: 618 is a mechanical paren
  slip, 624 violated an already-written rule ("never improvise around a
  feature CAPABILITIES marks expressible") on a claim the framework source
  refutes.
- **First-try SYNTAX is now the dominant failure mode**: 3 of 24 apps carry
  a paren-balance error in a long builder chain (612/613/618), one a
  255-char overflow (602), two a named-default-parameter style error
  (618/624). All are caught by the very first abaplint run in normal batch
  operation (the probe forbids it), none survive to a merged port — but
  they cost an iteration. abaplint-green-first-try dropped 22/25 → 19/24;
  everything downstream of syntax improved sharply.
- **The property gate's residual enum blind spot bit for real** (602
  `NonWorking` @1.121) — exactly as documented in §5; the by-policy manual
  declaration discipline remains necessary.
- **Corpus-consistency friction has replaced capability friction.** The
  friction logs contain zero "abap2UI5 can't express this" complaints and
  cluster on documentation gaps, all fixed in this change: the static-app
  skeleton (4 agents), the `generated`-sidecar shape (5), the
  `message_toast_display`/`message_box_display` signatures (5 — incl. the
  624-MAJOR-causing onclose gap), the camelCase-vs-references contradiction
  (2), rows-not-columns for mock inlining (3), the `controllerName`
  IGNORED_ATTRS exemption (4), the leading-`{0}` toast template (1 + the
  609 finding), and the stale whitelist-only CONTROL_METHODS phrasing
  (2 + the 624 finding).

### Distilled in the same change

AGENTS §5: static-app dispatcher skeleton; camelCase-references note;
rows-not-columns; sidecar `checked` omission; leading-`{0}` toast note;
CONTROL_METHODS listed-vs-denylist rule (+§10 gotcha update, + prompt).
AGENTS §6: `controllerName` in `IGNORED_ATTRS`. CAPABILITIES: MessageBox
`onclose` action return (with the 624 warning), MessageToast positional
one-text call. Fixing the probe ports themselves is out of scope — they are
never merged.

### Next probe

Repeat identically; compare against this file AND the baseline. Expected
movement: syntax-error rate down (nothing rule-side changed there — it is a
generation-care metric), MINORs down via the signature/sidecar doc fixes,
MAJORs staying ≤ 2 (the 624 class now has an explicit CAPABILITIES warning).

## Infrastructure sweep (2026-07-26) — scope gate wired, data-fidelity gate, STATUS split, e2e nightly

External review round ("was würdest du verbessern?"), all points implemented in
one change:

- **Scope gate is source-authoritative offline** (`pr/scope-since-from-source`
  → implemented): `generate-properties.mjs` now emits each control's
  class-level `@since`/`@deprecated` into `ui5/properties.json` (925 controls,
  621 with a class-level since), and `scopeOf` in `generate-coverage.mjs` (plus
  generate-overview + generate-status) falls back to it when `universe.json`
  carries null. First run surfaced **five** out-of-scope ported samples — the
  four known (121 UploadSet, 136 SidePanel, 141 InvisibleMessage, 165
  ProductSwitch) **plus app 166 (`sap.f.semantic.SemanticPage`, deprecated
  since 1.54)** the manual audit had missed. Pending maintainer decision,
  tracked in STATUS.md. The regenerated properties.json also caught two
  undeclared POST_171 members in app 121 (`UploadSet.mode` 1.100,
  `afterItemRemoved` 1.83) — declared.
- **Universe cleaned**: the 29 "without control metadata" rows classified
  against the checkout — 18 non-samples (shared helpers, test infra, group
  folders with nested samples) now excluded via `ui5/universe-excludes.json`,
  8 real samples mapped to their owning control via `ui5/entity-overrides.json`
  (docuindex gaps: ObjectHeaderResponsiveVI, Form480/SimpleForm480,
  ControllerExtension, 4× sap.uxap ObjectPage*), 3 demo apps
  (AIIntegration/UXCIntegration/TsHelloWorld) stay `unknown` by design.
  Universe: 707 → 689 samples, in-scope 641 → 639.
- **New gate `data_fidelity`** (`scripts/data-fidelity.mjs`, in `checks` CI):
  every asset literal in a port must exist (basename) in the sample's own
  archived files/mocks, full paths must match a mock occurrence, no SAPUI5
  CDN hosts. This is the deterministic half of the 2026-07-24 data audit —
  it reproduces the historical app-162 bug (HT-1000 vs HT-7777) exactly and
  found one live issue (app 121's invented `Screenshot.png`, now declared).
  Mock corpus resolution handles the demo-kit runner's implicit default
  products model (top-level-key match, not just file-name match). `--report`
  prints the value-level audit worksheet. Escapes: deviation naming the
  basename, or sidecar `data_fidelity.skip` (validated by validate-meta).
- **STATUS split**: the journal moved to `STATUS-history.md` (this file);
  STATUS.md is now a generated state block (`scripts/generate-status.mjs`,
  markers `<!-- state:start/end -->`, wired into pre-commit + meta_valid like
  the overview) + the hand-maintained open-findings backlog. The old
  hand-maintained "Where the repo stands" table had frozen at 109 ports/67
  sidecars while the corpus grew to 246 — generated counts cannot drift.
- **e2e nightly** (`.github/workflows/e2e_nightly.yaml`): the heavy real-app
  gate now runs every night (clones abap2UI5, transpiles, boots all ports in
  Chromium) instead of on-demand only; `e2e-smoke.mjs` no longer hardcodes
  the sandbox Chromium path. INTERACTIONS grew from 1 to 4 entries, each
  proving one LIVE_TEST class end to end: 005 client-composed toast, 019
  popup_display Dialog, 060 anchored toggleBy + item-select toast, 094
  popover BIND_ELEMENT. Growing this map is the automated close path for
  the 72-port LIVE_TEST backlog (STATUS.md).
- **Training pairs exportable** (`scripts/export-training-pairs.mjs`): the
  TRAINING.md fine-tune JSONL shape as a command — 45 `checked` pairs today,
  hold-outs always excluded.
- **i18n policy settled** (user decision): a frontend i18n/resource model
  **contradicts the thin-frontend principle by design** — ABAP translates
  natively (text elements/OTR, `sy-langu`) and serves finished strings as
  bound model fields. CAPABILITIES gained an "i18n texts" row; the §5
  cheat-sheet i18n row now says "never propose frontend i18n as a pr/".
- **Doc drift fixed**: README pipeline/scope text (was sap.m-only, now the
  ten-library reality), AGENTS §3 folder table (`src/02/03/05` were marked
  "planned" though long existing), AGENTS §7 overview description, and a
  pre-existing pattern-lint violation in the generated overview class
  (`<CLASS>` in ABAP Doc from the hash-routing PR) fixed at the generator.
- **Depth phase prepared (same day, second pass)**: the universe now includes
  the demo kit's GROUP-nested samples (47 added: `TreeTable.…`, `p13n.…`,
  `UploadSetwithTablePlugin.…`, `View.…`, `ViewTemplate.…`, …) — taken only
  when the docuindex lists the child as an official sample, named
  `<Group>.<Child>`, archived flat as `ui5/<lib>/<Group>.<Child>/`
  (scaffolder maps the path). Universe 689 → 736 samples, backlog 398 → 425
  with 47 on uncovered controls. `--backlog` now sorts depth rows ascending
  by `covered-control(n)`, and AGENTS §1/TRAINING document the idiom-first
  depth criteria (within equal n, pick the sample exercising something no
  existing port of that control does; skip true near-duplicates). Snapshot
  rebuilt from the fork — api.json metadata absent until the next weekly
  `generate_result` run, the properties.json control-level fallback covers
  Since/Deprecated meanwhile.
- **data_fidelity stage 2 (same day, second pass)**: the gate now also parses
  every `VALUE #( … )` table block (string-literal-aware — parens inside
  backtick literals are data, not nesting) and compares it against its ONE
  best-matching mock array: positional row/field string equality on a full
  inline, per-field set membership on a subset (a legitimate `/Coll/0..n`
  passes, an invented value fails), equality modulo the sanctioned
  sdk.openui5.org host-absolutization, numbers uncompared. Corpus is clean
  (0 errors over 246 ports); both paths regression-tested with injected
  142-class bugs. The out-of-scope check also became a **hard gate** the
  same day (`ui5/scope-exceptions.json`, stale entries fail), and the e2e
  INTERACTIONS grew 4 → 8 verified LIVE_TEST-class checks
  (+091 openBy hidden picker, +104 dialog + binding_call search, +130
  two-way busy round-trip, +133 GridList mode round-trip).
- **app 234 downport defect fixed + gated**: three `FOR i = …` iterators in
  one method downport to three `DATA i TYPE i` — the 702 build and the e2e
  transpiler both failed on it. Renamed to `i`/`j`/`k`; new pattern-lint
  rule `duplicate-for-iterator` (verified: fires 2× on the old code) + §10
  gotcha, per the "greppable lesson → rule" discipline.

## Property gate extended to all libraries (2026-07-24) — blind spot closed

The systemic follow-up (the property gate was `sap.m`-only, so post-1.71 members
in every other library passed vacuously — the root cause of the POST_171 debt
swept earlier). Fixed for real:

- **`generate-properties.mjs`**: `LIB_DIRS` now covers all ten ported libraries
  and scans each **recursively** (nested controls: `form/SimpleForm`,
  `cards/NumericHeader`, `sap.m/semantic/*`, …). `ui5/properties.json` grew
  263 → **831 controls**. A missing lib dir is skipped with a warning (not fatal).
  CI-safe: `generate_result` clones the full OpenUI5 repo, so all libs' `src/`
  are present (verified in `generate_result.yaml`).
- **`property-check.mjs`**: builds a prefix→namespace map from each port's own
  `xmlns` declarations and resolves every control's full dotted name (not just
  `sap.m.<X>`), then walks the parent chain as before. The `sap.m`-only skip is
  gone.
- **Two members the manual audit had missed/deferred, now caught and declared**:
  app 108 `CalendarAppointment.ariaHasPopup` (1.150.0, genuinely in the original
  view) and app 167 `NavigationListItem.expanded` (reads 1.121 — a base-class
  relocation, property predates 1.71; declared with that note). `property-check`
  is green across all 178 ports; the gate now enforces POST_171 for every library
  automatically, so this class of debt cannot silently return.

Residual limits (documented in §5): enum *values* newer than 1.71 stay invisible
at the attribute-name level; a member relocated to a newer base class reads as
that base's version.

## Subagent cold-read probe (2026-07-24) — app 178 (sap.uxap ObjectPage, BlockBase inlining)

Eighth cold-read port and the hardest so far: `sap.uxap.sample.ObjectPageSubSectionWithActions`
(app 178, `src/03`), the thinnest library. Machine-green all gates. Coverage
**178**, `sap.uxap` 2→3. The documented-but-barely-exercised **BlockBase-inlining
idiom worked cleanly** — three `blockcolor:BlockBlue` refs inlined as `core:HTML`
divs (app 161 precedent), one IMPROVISED deviation naming the block→content
substitution covered both structural-diff lines (`control missing` blockcolor:BlockBlue
+ `control extra` core:HTML). All uxap members @since-checked (≤ 1.71).

Even this hardest port surfaced only consistency nits (blank-line prose vs the 161
precedent; §4 "archive everything" vs the reality that SharedBlock sources aren't
copied into `ui5/`; the block-view path pattern). CAPABILITIES BlockBase row
clarified (block-view path, single-deviation declaration, not-offline-archived).
**Conclusion: the agent-file hardening is saturated** — eight consecutive
cold-read ports across seven libraries built machine-green from the docs alone;
recent friction is cross-corpus consistency, not capability or spec gaps.

## Subagent cold-read probe (2026-07-24) — app 177 (sap.ui.unified CalendarDateInterval)

Seventh cold-read port: `sap.ui.unified.sample.CalendarDateIntervalBasic` (app
177, first `sap.ui.unified.CalendarDateInterval`), machine-green, 0 diffs.
Coverage **177**, `sap.ui.unified` 5→6. Data-less-but-stateful (inline flag,
no `model_init`). One LIVE_TEST (event date simplified, same as app 139).

Friction is now down to `@since`-check refinements — both added to the §5
property-gate caveat: **(a)** an inherited member's `@since` lives in the
**parent class file** (follow the `extend` chain — `CalendarDateInterval` →
`Calendar.js`); **(b)** a member with **no `@since` tag** is base-version (≤ 1.71,
no POST_171). The core spec is otherwise saturated for this port class — recent
friction logs surface only cross-corpus consistency nits (references using
dispreferred-but-valid patterns, the scaffolder stub vs the data-less rule),
not capability gaps.

## Subagent cold-read probe (2026-07-24) — app 176 (sap.f GridList grouping)

Sixth cold-read port: `sap.f.sample.GridListBoxContainerGrouping` (app 176),
machine-green. Coverage **176**, `sap.f` 12→13. `sap.f.AvatarGroup` (the only
un-ported *new* sap.f control) was skipped — render-hostile (declared skip), so
a clean depth port was taken. All members @since-checked (≤ 1.71). Slider→width
done as a roundtrip-free expression binding (spec-preferred over the round-trip
that the nearest reference app 144 actually uses — the docs prefer it but no gate
enforces it; noted).

Two doc fixes from the friction log:
- **§5**: `stringify( )` renders from the root, so **trailing `shut( )`s are
  optional** — a chain may end at the deepest node with a bare `).` (all open
  nodes close structurally in the output). `shut( )` only moves the cursor to add
  a higher sibling. Confirmed in the builder (`stringify` → `root->render( )`).
- **generation-prompt.txt**: the `<DESCRIPT>` line now matches §5 (scaffolder's
  `<library> - <sample name>` default) instead of the old `<entity> - <desc>`
  that contradicted it.

## Subagent cold-read probe (2026-07-24) — app 175 (first SimpleForm) + ref bug

Fifth cold-read port: `sap.ui.layout.sample.SimpleFormToolbar` (app 175, first
`sap.ui.layout.form.SimpleForm` — a new control), machine-green, **0 structural
diffs**. Coverage **175**, `sap.ui.layout` 10→11. All SimpleForm members
@since-checked by hand (≤ 1.71, no POST_171).

- **app 142 fixed** — like 162, its nearest-neighbour data was wrong: it seeded
  `Titanium`/`Walldorf`/`Star Street`… but its sample `bindElement`s
  `/SupplierCollection/0` and the mock's only row is `Red Point Stores` / `Main
  St 1618` / `Maintown`. Corrected all address fields to the real row-0 values.
- **Recurring IMPROVISED-vs-NOTE confusion resolved in §5** (surfaced by 173/175
  and flagged earlier): a pure prefix-drop that renders identically (0 diffs) is
  `NOTE`; `IMPROVISED` only when the fold loses/changes data. Also documented the
  `bindElement('/X/0')` → seed-fields-at-default-model-root idiom, and that
  seeded values must be the actual mock row, verified — not a neighbour's.
- **§5**: a camelCase JSON key mirrors verbatim into the ABAP field / binding
  (`SupplierName`→`{SUPPLIERNAME}`, never `SUPPLIER_NAME`).

Pattern across the probes: the written spec builds correct ports, but several
**existing ports carry wrong seeded data copied from neighbours** (162, 142) —
the "verify against the sample's own mock, not the nearest port" caution (§5) is
now doubly proven.

**Data-fidelity audit run (2026-07-24):** all 175 ports scanned, the
single-record-flatten / named-model-scalar class verified value-by-value against
each sample's actual mock. Result: **one more bug — app 119 (FixFlexVertical)**
seeded `HT-1000.jpg` where its `{img>/products/pic1}` binding resolves to
`HT-7777-large.jpg` (same wrong-neighbour copy as 162). Fixed. Everything else
verified correct (image ports 006/031/046/162/173; supplier flatteners
020/084/142/175; product flatteners 041/071/073/087/089/048; date/wizard
017/018/101). The corpus is otherwise data-clean; multi-row verbatim tables were
spot-checked only (row 0 correct) and are lower-risk.

## Subagent cold-read probe (2026-07-24) — app 174 + json-to-abap truncation fix

Fourth cold-read port: `sap.ui.table.sample.RowHighlights` (app 174), machine-green
all gates. Coverage **174**, `sap.ui.table` 3→4. Chosen over the suggested
TreeTable because that needs a recursive/arbitrary-depth tree binding ABAP can't
type (new **CAPABILITIES ❌ row**) — a genuine boundary the probe pinned down.

The friction log drove several fixes:

- **`json-to-abap.mjs` truncation bug fixed** — it inferred a numeric column's
  type from the **first row only**, so a decimal column whose row 0 is
  integer-valued (`Price` 956) was typed `i` and every later decimal (`6.99`)
  silently `Math.trunc`ated. Now it scans **all rows**, emits any decimal column
  as a backtick string (no truncation) and warns. **app 170's data was corrupt
  from this** (Width/Depth/Height `40.8→40`, Price `6.99→6`) — regenerated with
  the fixed tool: dimensions now `TYPE string` (display-only text template, exact
  decimals), Price packed with decimals preserved.
- **`structural-diff` mechanics documented** (§6): it flags only *missing*
  controls/attrs (extras never), compares the full **qname incl. prefix**, and a
  diff is "declared" only when a deviation's `what` names the missing item
  verbatim — so dropping a `press`/`change` handler for a binding must name that
  attribute.
- **CAPABILITIES**: recursive TreeTable binding ❌ (fixed-depth nesting stays ✅).
- **§10 gotcha**: abaplint `commented_code` fires on English comments with `/` +
  UI5 identifiers — reword.

## Subagent cold-read probe (2026-07-24) — app 173 + a bug in its reference

Third cold-read port: `sap.ui.layout.sample.VerticalLayout` (app 173, first
`sap.ui.layout.VerticalLayout`), machine-green all gates. Coverage **173**,
`sap.ui.layout` 9→10. The written spec was sufficient to build a correct port —
the friction was that the **nearest reference (app 162, HorizontalLayout)
contradicted the spec**, and the probe caught a real bug in it:

- **app 162 fixed** — it seeded `pic1 = …/HT-1000.jpg` (host-relative), but the
  shared demo mock `sap/ui/demo/mock/img.json` has `products.pic1 =
  …/HT-7777-large.jpg`. Wrong image id **and** a relative URL against the
  `sdk.openui5.org` asset-host rule. Corrected to the absolute `HT-7777-large`
  URL (a model-seed value; no gate saw it — render-smoke mocks the model,
  structural-diff ignores data). app 173 seeded the correct value.
- **Doc fix** — §5 "Worked references" now warns that a reference shows an idiom,
  not ground truth: the spec/CAPABILITIES/sample-source win on conflict, and
  seeded data values must be checked against the sample's own mock, not the
  neighbour.

**Open maintainer question flagged by the probe:** the deviation *type* for a
named-model prefix-fold is inconsistent across the corpus — §5 says `IMPROVISED`,
CAPABILITIES frames a pure prefix-drop as the faithful standard (0 diffs), and
ports split (006/173 `IMPROVISED`, 162 `NOTE`). A one-line policy — `NOTE` for a
pure same-data prefix-drop, `IMPROVISED` only when the fold loses columns or
resolves statically — would make it countable. Left for a maintainer decision,
not rewritten unilaterally.

## Non-sap.m POST_171 audit (2026-07-24) — systemic debt swept

Prompted by the 128/132 finding, a full `@since` audit of all 61 non-`sap.m`
ports (`src/02`–`src/05`) — the libraries the property gate is blind to — every
member cross-checked against the OpenUI5 source, then independently re-verified
before fixing. **Undeclared post-1.71 debt found and corrected in 5 ports:**

| Port | Member(s) now declared | @since |
|---|---|---|
| 113 (`sap.tnt.InfoLabel`) | `InfoLabel.icon` | 1.74 |
| 128 (`sap.tnt.SideNavigation`) | `NavigationListItem.selectable` | 1.116 |
| 132 (`sap.tnt.SideNavigation`) | `NavigationListItem.selectable` + `tag` aggr. | 1.116 / 1.149 |
| 164 (`sap.ui.table.Table`) | `Table.rowMode` aggregation | 1.119 |
| 167 (`sap.tnt.ToolPage`) | `NavigationListItem.selectable`/`design`/`press`/`ariaHasPopup` (fixed a wrong @since citation) | 1.116 / 1.133 |

Excluded as false positives (base-class relocation, still functionally pre-1.71):
`NavigationListItem.expanded` (@since 1.121, the `NavigationListItemBase` split)
and `.visible` (@since 1.52). Every other non-`sap.m` port uses only members
`@since ≤ 1.71`. This closes the debt the blind gate had accumulated; the real
fix (extending `properties.json`/`LIB_DIRS` to the other libraries so the gate
enforces this automatically) remains the open follow-up, gated on the
`generate_result` CI checkout including those libs' `src/`.

## Subagent cold-read probe (2026-07-24) — app 172 + latent POST_171 debt found

Second subagent cold-read: `sap.tnt.sample.SideNavigationUnselectableParents`
(app 172, `src/05/b06`), machine-green (all gates incl. render-smoke), one
POST_171 (`NavigationListItem.selectable` 1.116) + two LIVE_TEST. Coverage
**172**, `sap.tnt` 7→8.

The probe's manual `@since` discipline (forced by the property-gate blindness
documented the same day) **found real latent debt**: apps **128 and 132** ship
`NavigationListItem.selectable="false"` (@since 1.116) with **no POST_171
declaration** — the blind gate had hidden it. Corrected both sidecars. (app 167
already declared it.) This is exactly the failure the property-gate caveat warns
about, now proven to have already happened; a broader `@since` sweep of all
non-`sap.m` ports (`src/02`–`src/05`) is a worthwhile follow-up.

Doc fixes from the friction log: the client-toast `t_arg` tuple order
(object/method/template/arg, wire token `MESSAGE_TOAST`) added to the §5
cheat-sheet; §5 now states a data-less-but-stateful app seeds its flag inline
(no `model_init`) and that a scalar literal→two-way binding is faithful, not a
structural-diff trigger (declare LIVE_TEST for the behaviour, not the diff).

## Subagent cold-read probe (2026-07-24) — app 171, first `sap.ui.unified.Currency`

A fresh subagent (its own context, no port memory) ported
`sap.ui.unified.sample.CurrencyInTable` from the agent files alone, ran every
gate green, and returned a friction log — the strongest test yet of "can an AI
build from the docs". Result: **machine-green** (abaplint STANDARD+CLOUD,
validate-meta, pattern-lint, structure-lint, structural-diff `--strict` 0
undeclared / clean 1:1, property-check, render-smoke pass). Coverage **171**,
`sap.ui.unified` 4→5. One deviation: LIVE_TEST on the nested-object bind.

Independently re-verified before commit. The probe surfaced four real doc gaps,
all fixed same change:

- **Nested single (non-array) object bind** `{transactionAmount/size}` was
  undocumented (only nested *arrays* were). New CAPABILITIES row (🧪) + §5
  cheat-sheet: keep a nested ABAP structure, bind the relative sub-path
  `{OBJ/FIELD}`, don't flatten. app 171 proves view-create; runtime bind LIVE_TEST.
- **`property_gate` covers `sap.m` only** — `properties.json` holds no other
  library, so for `src/02`–`src/05` the gate passes vacuously. §5/§6 now say so
  and require a manual `@since` check against the OpenUI5 source. (Re-checked
  169/170's non-sap.m members by hand: all ≤1.71 — `snappedTitleOnMobile` 1.63,
  Grid/GridData 1.15, DynamicPage* 1.42 — no undeclared POST_171.)
- **`path:` inside a raw binding string uses the upper-cased ABAP field name**
  (`'exchangeRate'`→`'EXCHANGE_RATE'`), same as the brace form — no gate catches
  a stale camelCase path. Added to §5 + the cheat-sheet typed-binding row.
- **`<DESCRIPT>` rule** contradicted the scaffolder and had no offline
  description source — §5 now endorses the scaffolder's `<library> - <name>`
  default.

## From-scratch probe (2026-07-24) — app 169, first `sap.ui.layout.Grid` port

The real regeneration probe the agents-usability pass owed: **built entirely
from the agent files**, from the OpenUI5 source (`oblomov-dev/fork-openui5`
cloned into the session), no reference to another port (there was none — new
control). Chosen breadth-first: `sap.ui.layout.sample.GridData`
(`sap.ui.layout.Grid` + the `GridData` responsive layoutData — span / indent /
linebreak / visibility), a single-view sample so `structural-diff` is meaningful.

**Machine-green on the first serious pass** — abaplint STANDARD + CLOUD (0
issues), validate-meta, pattern-lint (after fix, see below), structure-lint,
structural-diff `--strict` (**0 undeclared**; 2 declared: the injected CSS
`core:HTML` + the dropped `Slider.liveChange`), render-smoke (real
`XMLView.create`, **pass**), property-check (0 post-1.71). Coverage **169**;
`sap.ui.layout` 8→9. Deviations: 1 IMPROVISED (the eight Sliders'
`.onSliderMoved` resizes the grid wrapper by jQuery DOM traversal — no
server/bindable equivalent, dropped), 2 NOTE (CSS injected via `core:HTML`;
`core:HTML` div/`FormattedText` markup written decoded).

Two friction points a fresh AI hits — the docs were correct but not crisp, now
fixed in the same change (AGENTS §5 "Idiom cheat-sheet" CSS row + CAPABILITIES
"Custom CSS"):

- **`core:HTML content` needs decoded markup.** The original view.xml carries
  it entity-encoded (`&lt;div&gt;`); you must write the literal `<div>` because
  the builder re-escapes on stringify — copying the entities double-escapes.
- **Escaped braces `\{ \}` must be a backtick literal**, not a `|…|` template.
  Backtick passes `\{` through to the serialized attribute; a pipe collapses
  `\{`→`{` and re-crashes — the exact reverse of the typed-binding string (which
  wants real braces and so uses the pipe). Verified against apps 026/028.

A third, minor: `pattern-lint no-blank-before-shut` requires a blank line before
the first `)->shut(` of a closing group — easy to miss from the prompt's terse
"before shut". Fixed (15 warnings → 0); prompt wording left as-is (the rule
gates it anyway).

## Agents-usability pass (2026-07-24) — make the docs hand an AI the exact rule

Focus: lower the barrier for an AI to build a port first-try from the agent
files alone. Cold-read one weakly-covered port (app 164, `sap.ui.table`
RowModes) against ground truth + the offline gate baseline (all green:
validate-meta 168/168, pattern-lint 0/0, structural-diff `--strict` 0
undeclared, structure-lint 0). Full write-up below.

Three idioms were correct in the docs but **buried in prose** (an AI had to
re-derive the one-line action): named-model folding, typed/complex bindings with
escaped braces, and the aggregation namespace. Fixed same change:

- **`AGENTS.md` §5 — new "Idiom cheat-sheet"**: the ~12 recurring hard idioms as
  copy-paste one-liners (`original → port → detail`), each pointing at its
  long-form rule + proving app; the two ❌ boundaries (control factories,
  app-authored JS formatters) stated once as "declare, don't improvise".
- **`AGENTS.md` §5 — aggregation-namespace rule** made explicit (an aggregation
  carries its XML tag's namespace = its parent control's; a wrong `ns` is an
  unknown-aggregation node `render_smoke` rejects), app 164 as example.
- **`scripts/generation-prompt.txt`** — three lines added to the first-read
  prompt (aggregation ns, always-escape-`\{ \}`-in-`|…|`, one-default-model /
  typed binding); re-spliced into `README.md`.
- **overview app regenerated** — committed copy was stale (missing `ui5_only`),
  the "system push carries stale generated files" gotcha; idempotent regen.

No ports changed; coverage unchanged at 168. Owed next: a real from-scratch
regeneration probe per thin library once OpenUI5 is reachable — cold-read
catches doc-extraction friction, only a fresh port surfaces uncovered idioms.

### Full write-up (moved here from `probes/` on 2026-08-18 — the directory collided in name with `scripts/probes/`, which holds executable probe scripts)

Goal of this pass: make the agent files (`AGENTS.md`, `CAPABILITIES.md`,
`scripts/generation-prompt.txt`) help an AI build a port **first-try** with as
little friction as possible. Method: pick one port from a weakly-covered library,
read the agent files as the *only* guide, and check whether they hand an AI the
exact instruction it needs — or whether the instruction is buried and has to be
re-derived. Every place it had to be re-derived is a usability gap and was fixed
in the same change.

### Setup / constraints

- **Offline gate baseline** (all green, node-stdlib only, no OpenUI5 needed):
  `validate-meta` (168/168, 0 err), `pattern-lint` (0/0), `structural-diff
  --strict` (168 checked, 44 declared diffs, **0 undeclared**), `structure-lint`
  (0 errors). The self-check loop in AGENTS §6 works as documented.
- **OpenUI5 is not reachable** in this environment (raw.githubusercontent blocked
  at the proxy) and no un-ported sample is archived under `ui5/`, so a *new*
  faithful port could not be produced without inventing the source — which would
  break the 1:1 rule. The probe therefore runs as a **cold-read analysis** of an
  already-archived port against its ground truth, not a from-scratch regeneration.
  A real regeneration probe per weak library is still owed once OpenUI5 is
  reachable (see Recommendation).

### Probe subject — app 164, `sap.ui.table.sample.RowModes`

Chosen because `sap.ui.table` is weakly covered (3/17) and the sample stacks
three of the highest-friction idioms in one view. Cold-reading the agent files,
these are the points where the needed instruction existed but was **hard to
extract**:

1. **Named-model folding** (`{ui>/rowMode}` → one default model). The rule was
   correct but lived inside a ~200-word `CAPABILITIES.md` paragraph — an AI has
   to parse the whole thing to recover the one-line action (`_bind( rowmode )`,
   last-segment match).
2. **Typed/complex bindings** (`{path:'Quantity', type:'sap.ui.model.type.Integer'}`).
   Written 1:1 as a raw binding-info string with **escaped braces** `\{ … \}`.
   The escaping rule was documented only against the *CSS* case (app 028), not
   generalised to every `|…|` template — yet it applies here identically.
3. **Aggregation namespace.** `<m:content>` becomes `open( n='content' ns='m' )`
   but `<columns>` (default `sap.ui.table` namespace) becomes `open( 'columns' )`.
   The prose said an aggregation is "a nameless-namespace `open`", which is only
   true for a default-namespace aggregation — a genuine gap, and a wrong `ns`
   here produces an unknown-aggregation node that `render_smoke` rejects.
4. **The ❌ boundaries** (control-returning factories, app-authored JS
   formatters) were scattered across `CAPABILITIES.md` rows rather than stated
   once as "don't improvise, declare".

### Actions taken (same change)

- **`AGENTS.md` §5 — new "Idiom cheat-sheet"**: the ~12 recurring hard idioms as
  copy-paste one-liners (`In the original you see… → Write in the port → Detail`),
  each pointing at the long-form rule / proving app. Indexes the buried prose;
  does not duplicate it. Includes the two ❌ boundaries stated once.
- **`AGENTS.md` §5 — aggregation-namespace rule** made explicit (an aggregation
  carries its XML tag's namespace = its parent control's), with app 164 as the
  worked example.
- **`scripts/generation-prompt.txt`** — three lines added to the *first-read*
  prompt: aggregation namespace, always-escape-braces-in-`|…|`, and the
  one-default-model / typed-binding rule. Re-spliced into `README.md` via
  `generate-coverage.mjs`.
- **`src/z2ui5_cl_smpc_app_overview.clas.abap`** — regenerated; the committed copy
  was stale (missing the `ui5_only` field), the known "system push carries stale
  generated files" gotcha. Deterministic/idempotent regen from `meta/`.

### Recommendation

- The cheat-sheet is now the canonical quick index — keep new distilled idioms
  flowing into it (one row), not only into prose.
- Run a **real regeneration probe per newly-started library** (uxap, layout,
  table, unified are the thin ones) once OpenUI5 is reachable — the cold-read
  here catches doc-extraction friction, but only a from-scratch port surfaces
  idioms the docs don't cover *at all*. That is where the next genuine AGENTS
  additions will come from.

## Batches b05–b07 — stress-test ports, maximally-diverse controls (2026-07-23) — 12 ports

Three more diverse faithful batches to stress-test how far abab2UI5 reaches,
each internally maximally-different. All machine-green (abaplint
STANDARD/CLOUD/702, validate-meta, pattern-lint, structural-diff `--strict`,
property-check, render-smoke):

- **b05 (137–141):** `sap.ui.table.Table` multi-level column headers
  (multiLabels/headerSpan) · `sap.ui.layout.DynamicSideContent` · `sap.ui.unified.Calendar`
  · `sap.ui.layout.BlockLayout` (6 rows/7 cells, color shades A–F) ·
  `sap.ui.core.InvisibleMessage`.
- **b06 (142–145):** `sap.ui.layout.form.Form` (FormContainers + toolbars +
  GridData) · `sap.f.DynamicPage` (title/header/content/footer + tnt:InfoLabel)
  · `sap.f.GridList` GridBoxLayout · `sap.ui.layout.cssgrid` gridAutoFlow +
  RadioButtonGroup.
- **b07 (146–148):** `sap.ui.core` HyphenationAPI (core:HTML) ·
  `sap.ui.core.BusyIndicator` (global) · `sap.f.GridList` **drag & drop**
  (dnd:DragInfo + GridDropInfo).

New paradigms exercised without framework changes: the sap.ui.table grid table
with `multiLabels`/`headerSpan`, a full `sap.ui.layout.form.Form` tree,
`DynamicSideContent`/`DynamicPage` responsive containers, and drag-and-drop
config. One transpiler/checker footnote: the `sap.f.dnd` `GridDropInfo` keeps a
hyphen-free `dndgrid` xmlns alias (the original's `dnd-grid` prefix trips the
static regexes; the alias names the same URI). Coverage: **148** ports across
10 libraries.

## Where the repo stands

| Aspect | State |
|---|---|
| Ports | 109 / **403 in-scope** `sap.m` samples (27.0 %) — in scope = control exists since UI5 1.71 and is not deprecated; 43 of 446 samples are out of scope (16 deprecated, 21 newer, 6 without control metadata) |
| CI | ABAP_STANDARD, ABAP_CLOUD, ABAP_702 all green |
| Structural view diff | **0 undeclared differences** across all 64 ports (`node scripts/structural-diff.mjs --strict`) — including simple **binding values** and, since 2026-07-19, **`id` attributes** (name-level per control type; dropped original ids must be restored or declared) |
| Render smoke | **0 failing / 0 skipped** (`npm run smoke`): every port's view loads in a real headless `XMLView.create` — incl. app 049, now reconstructed by the **handle-aware path** (`extractDocsWithHelpers`: a builder handle is a stack snapshot, a captured handle passed into a builder-returning helper is inlined re-anchored per call). The declared-skip mechanism stays as a CI-enforced safety net for any future idiom the reconstructor cannot rebuild (undeclared non-reconstructable = FAIL, stale declaration = FAIL); harness carries `sap.f` and mocks scalar-row tables as empty arrays since b05 |
| Pattern lint | **0 errors, 0 warnings, empty baseline** (`node scripts/pattern-lint.mjs`) |
| Meta sidecars | 67 in `meta/` — status: 21 `generated`, 41 `checked`, **5 `golden`** (401, 421, 454, 540, 543 — promoted 2026-07-20 after the full live check); deviations: 39 IMPROVISED, 34 POST_171, 81 NOTE, 3 DROPPED_171 (the `p:ColumnAIAction` plugin in apps 009/022/534 — a whole control newer than 1.71, unlike the restorable members). **0 LIVE_TEST** (b07/b08 menu + message-popover paths live-checked 2026-07-22) and **0 SUBSET_DATA** (retired 2026-07-22 — every port now inlines the full mock row set). `audit` is a structured object since 2026-07-18 |
| Manually verified in a running system | **46 of 67 ports** — adds 060/061/066/067 (menu + MessagePopover, human live check 2026-07-22) to the 2026-07-20 checked set; the 21 remaining `generated` ports are b01–b04 apps that never carried an open question (machine-verified only) |
| Archive | `ui5/sap.m/<SampleName>/` — full originals for the 44 ported samples (+2 cross-referenced: `FacetFilterSimple`, `Table`); mock snapshot in `ui5/mock/`. Unported samples are copied over batch by batch. |

## Batch b04 — faithful diverse cross-library ports (2026-07-23) — 3 ports

Third diverse faithful batch, three libraries. All machine-green (abaplint
STANDARD/CLOUD/702, validate-meta, pattern-lint, structural-diff `--strict`
**0 diffs each**, property-check, render-smoke):

- **134** `sap.tnt.ToolHeader` — a shell-like app header: two ToolHeaders in a
  ScrollContainer with `OverflowToolbarButton`s, `ToolHeaderUtilitySeparator`,
  Avatar/Image, each item carrying `OverflowToolbarLayoutData`
  priorities/groups. Logo/Avatar presses → client toasts; the original's
  `Device.media` responsive-visibility handler is a device behaviour not
  reproduced server-side.
- **135** `sap.ui.model.type.Currency` (`sap.ui.core` TypeCurrency) — the
  **composite** data-type binding: every Input/Text binds
  `parts:['/amount','/currency']` with `type:'CurrencyType'` + formatOptions
  (showMeasure/showNumber/preserveDecimals/currencyCode/style). Paths generated
  via `_bind` (both fields land in the render-smoke mock model).
- **136** `sap.f.SidePanel` Single — a docked side panel: `f:mainContent`
  (buttons, veto Switches, ten body Texts) + `f:items` → `SidePanelItem`.
  `toggle` → client toast (the original's preventDefault veto by the two
  switches is a live interaction, not reproduced).

New batch folders `src/05/b04`, `src/02/b04`, `src/04/b03`. Coverage: **136**
ports across 10 libraries.

## Batch b03 — faithful diverse cross-library ports (2026-07-23) — 5 ports

Second diverse faithful batch, three libraries, chosen for paradigms b02 didn't
touch. All machine-green (abaplint STANDARD/CLOUD/702, validate-meta,
pattern-lint, structural-diff `--strict` **0 diffs each**, property-check,
render-smoke):

- **129** `sap.ui.model.type.Integer` (`sap.ui.core` TypeInteger) — the
  **data-type binding** paradigm: `core:require` pulls in the Integer type and
  `form:SimpleForm` Inputs/Texts bind `{path, type:'IntegerType', formatOptions}`
  (min/maxIntegerDigits) 1:1. The path is generated via `_bind(val=… path=X)`
  (never hardcoded — a pattern-lint rule), which also puts the field in the
  render-smoke mock model.
- **130** `sap.ui.core` ControlBusyIndicator — `busy` state on a Panel + Icon,
  toggled server-side (bound boolean); the original's 5 s setTimeout auto-reset
  is simplified to a toggle.
- **131** `sap.ui.core` BasicThemeParameters — MessageStrip + Link (the sample
  is just a pointer to the external Theme Parameter Toolbox).
- **132** `sap.tnt.SideNavigation` WithTags — richer than b02's 128: every
  `tnt:tag` carries an `ObjectStatus` badge (IndicationColor 15-20, inverted),
  plus `NavigationListGroup` + `fixedItem`; expand toggled server-side.
- **133** `sap.f.GridList` Modes — the **data-bound list** paradigm: 11 product
  rows inlined from `model/data.json`, a `GridListItem` template with
  `counter`/`highlight`/`type` bindings + `{= …}` expression-bound visibility,
  a `SegmentedButton` whose `selectionChange` drives `mode` + `headerText`
  server-side, `f:customLayout` → `GridBasicLayout`. Absent enum-ish JSON
  fields are seeded with their UI5 defaults (`type→Inactive`, `Status→None`) so
  the bound enum properties stay valid — renders identically, and
  structural-diff compares only binding paths.

New batch folders `src/02/b03`, `src/05/b03`, `src/04/b02`. Coverage: **133**
ports across 10 libraries.

## Batch b02 — faithful diverse cross-library ports (2026-07-23) — 7 ports

First **faithful** (structurally verified, not probe) batch that spans past
`sap.m`, picked for maximal control diversity across four libraries. All seven
are machine-green (abaplint STANDARD/CLOUD/702, validate-meta, pattern-lint,
structural-diff `--strict` with **0 diffs each**, property-check, render-smoke):

- **122** `sap.ui.core.Icon` — icon-font gallery (`core:Icon` × 5 in an HBox,
  each with `FlexItemData` layoutData; stethoscope press → client toast).
- **123** `sap.tnt.NavigationList` — nav tree with nested items; the two toolbar
  buttons flip `expanded` / a sub-item's `visible` server-side (boolean model
  fields, `view_model_update`).
- **124** `sap.ui.layout.cssgrid.CSSGrid` — CSS-grid page layout, five
  `core:HTML` tiles (raw HTML in `content`, escaped 1:1 incl. the original's
  quirks) + `GridItemLayoutData`; Slider `liveChange` → panel width roundtrip.
- **125** `sap.ui.layout.Splitter` — resizable split panes with
  `SplitterLayoutData` (fully static, no controller).
- **126** `sap.ui.unified.FileUploader` — file uploader + upload button
  (upload cycle reduced to client toasts — endpoint-dependent, LIVE_TEST).
- **127** `sap.ui.core.InvisibleText` — ARIA-description Page (12 buttons across
  customHeader/subHeader/content/footer, six `core:InvisibleText` targets,
  `ariaLabelledBy`/`ariaDescribedBy` associations 1:1).
- **128** `sap.tnt.SideNavigation` — side nav with `NavigationListGroup`s +
  `fixedItem`, external-link items; expand/hide toggles server-side.

New batch folders `src/02/b02` (sap.ui.* → 122/124/125/126/127) and
`src/05/b02` (sap.tnt → 123/128). Coverage: **128** ports across 10 libraries.
Two render-smoke lessons re-confirmed: (a) a nested aggregation (`layoutData`)
needs its **own** `shut()` plus one for the parent control before a sibling —
one missing `shut()` silently nests the next control inside the previous one;
(b) a bound property whose `DATA` uses an inline `VALUE` clause is invisible to
render-smoke's typed-model derivation (it only reads assignment seeds), so such
fields mock as empty string and fail strict boolean/numeric property typing —
seed them with a plain assignment on init instead.

## Beyond sap.m: sap.f library started (2026-07-22) — src/04/b01

First expansion past `sap.m`. **sap.f** (Fiori flagship) is now a second library
in coverage/universe and the render-smoke harness (its `@openui5` package ships
in `LIB_ROOTS`). Two ports, both machine-green: **110** ShellBar (static app
shell header with a sap.m Menu + profile Avatar) and **111** GridList (grid
layout list, 27 items, Slider→panel-width via a roundtrip-free expression
binding). Infra: `FOCUS_LIBS += sap.f`; the 42 sap.f demokit samples merged into
`ui5/universe.json` from the fork's docuindex (null since/deprecated — no built
SDK api.json, so a full regen would wipe sap.m's scope metadata; the manual
merge preserves it, sap.f starts with permissive scope). **structural-diff was
hardcoded to `ui5/sap.m/`** and now resolves `ui5/<lib>/<Name>` from the sample
library, so sap.f (and future libs) are structurally verified. Coverage:
109/488 across 2 libraries. Deferred (own follow-up batch): the sap.f controls
with popover fragments / named models (AvatarGroup — also hits a headless
AvatarGroup render-restart loop —, DynamicPage, FlexibleColumnLayout, Card,
GridContainer, ProductSwitch, SidePanel, SemanticPage).

## Batch b14 generated (2026-07-22) — planning calendars (2 ports)

The two calendar NEW controls, both machine-green including render-smoke:
**108** PlanningCalendar (the Single variant — a single-row day planner with 21
appointments + 3 interval headers) and **109** SinglePlanningCalendar (the
DateSelection variant — Day/WorkWeek/Week/Month views + 11 appointments). Both
prove the **date-object property** path end to end in the ai-demokit builder: the
model carries plain ISO strings and the object-typed `startDate`/`endDate`
(PlanningCalendar / SinglePlanningCalendar / `unified:CalendarAppointment`) are
converted at the binding with `Formatter.DateCreateObject` via
`core:require="{Formatter: 'z2ui5/model/formatter'}"` (POST_171, UI5 >= 1.74) —
**no framework change needed**, the curated formatter already ships it and
render-smoke registers the same module (the `xmlns:core` declaration is required
alongside `core:require`). The original `UI5Date.getInstance(y, month0, d, …)`
values are normalized to ISO 1:1 (0-based months; JS Date overflow rolled
forward). Interactive paths (appointment/interval select, view/date change,
mode toggle) are simplified toasts, `LIVE_TEST`. Remaining calendar work is
**depth only** — the other ~22 PlanningCalendar/SinglePlanningCalendar variants
now that both controls are covered.

## Batch b13 generated (2026-07-22) — sap.m.semantic pages (3 ports)

The `sap.m.semantic` page family, all machine-green: **105**
SemanticPageFullScreen (`FullscreenPage` + the full semantic-action set),
**107** SemanticPage (`SplitContainer` master/detail with SortSelect bound to a
2-row filter-type table, PagingButton, custom footer/share content) and **106**
SemanticPageFloatingFooter (same with `floatingFooter='true'`). Each semantic
action toasts its class name (passed as a t_arg literal); `positionChange` and
custom-button presses transport `${$parameters>/newPosition}` /
`$event.oSource.sId`. All interactive paths `LIVE_TEST`. No framework change
needed. **Remaining in-scope NEW controls**: only the `PlanningCalendar` and
`SinglePlanningCalendar` families are left — both need the date-object property
support (CAPABILITIES 🔶, per-binding `Formatter.DateCreateObject`) and warrant
a dedicated batch.

## Batch b12 generated (2026-07-22) — dialogs, pickers & master-detail (10 ports)

Ten breadth-first `NEW-CONTROL` ports (095–104), each machine-green (abaplint
STANDARD/CLOUD/702, validate-meta, pattern-lint, structural-diff `--strict`,
property-check, render-smoke `--strict`): **095** TimePickerSliders (dialog +
sliders), **096** SplitContainer, **097** SplitApp (master-detail),
**098** ViewSettingsDialog (sort/group/filter, 3 dialogs in `mvc:dependents`,
`open [pageKey]`), **099** QuickViewCard + **100** QuickView (nested
pages/groups/elements; QuickView flattens 4 named models into 4 ABAP tables),
**101** Wizard (4 steps + review NavContainer, validation in ABAP,
`goToStep`/`discardProgress`), **102** InputModelUpdate (OData mock → ABAP
timer), **103** SelectDialog + **104** TableSelectDialog (per-button config via
bound properties, full 123-row ProductCollection, client-side `binding_call`
search). All interactive navigation/selection paths are flagged `LIVE_TEST`.

**Paired framework change** (abap2UI5 branch
`claude/ai-demokit-next-batches-rq9sfy`, `pr/split-container-nav`, merged
upstream as **#2470**, folder removed):
six control methods whitelisted in `CONTROL_METHODS` (both `FrontendAction.js`
and the ABAP mirror `z2ui5_cl_app_frontendaction_js`) so the ports drive them
1:1 — `toDetail`/`toMaster`/`backDetail`/`backMaster`/`setMode`
(SplitApp/SplitContainer) and `navigateBack` (QuickView/QuickViewCard); 4 new
node tests (41 pass), abaplint clean.

## Real-app e2e smoke — runs every port as the actual app (2026-07-22)

`render-smoke` renders a *reconstructed* view; it cannot see the backend
roundtrip, Component boot or event wiring. New heavy, on-demand harness that
runs the **real** app:

- `scripts/e2e-build.mjs` (`npm run e2e:build`) — assembles the transpiled
  backend: copies the abap2UI5 framework src + all 94 ports + the
  `z2ui5_cl_ui5_view_builder` builder into a build dir, **downports a copy** to v702 with
  the framework's own `.github/abaplint/abap_702.jsonc` rule set (the transpiler
  rejects modern `COND … LET …`; a minimal downport produced undefined-var JS,
  so the full `check_syntax`/`definitions_top` rules are required), then
  transpiles with `@abaplint/transpiler` → `node/output`. The framework SOURCE
  is never mutated (only its gitignored build dirs). Needs an abap2UI5 checkout
  with `node_modules` (`A2UI5_HOME`, default `../abap2UI5`).
- `scripts/e2e-smoke.mjs` (`npm run e2e`) — boots the framework's express shim
  (`ZCL_SICF` → `z2ui5_cl_http_handler`, the same open-abap runtime as the
  framework's own e2e), then for each port opens headless Chromium at
  `?app_start=<class>`. UI5 is served from the local `@openui5` packages (the
  sandbox blocks the `sdk.openui5.org` CDN, so those requests are routed to the
  package sources). Generic assertions, no per-port authoring: **boots UI5 +
  renders controls + no backend 4xx/5xx + no JS exception** (benign
  theme/preload/i18n noise from unbundled source filtered by response URL). A
  small `INTERACTIONS` map adds real click→assert checks (005 press →
  client-composed "…​Pressed" toast).
- Result: **94/94 ports pass** — every port runs, boots and renders as the real
  app. Uses `playwright` core (no new dep) like render-smoke; not in the fast
  gate set (multi-minute transpile + browser), meant for pre-release / when the
  framework wire or runtime changes. This is the automated counterpart to the
  manual live check that the `LIVE_TEST` deviations track.

## Live-check fixes on b09–b11 (2026-07-22) + three new pr requests

Human live check surfaced six runtime issues (machine checks can't see them);
all fixed, all six checks still green:

- **094** — the popover's Action button used `cs_event-popup_close` (destroys
  the `POPUP` slot), so a `POPOVER` never closed → **`cs_event-popover_close`**.
- **080** — `${$source>/pressed}` did not resolve at runtime; the source id +
  pressed state now arrive via **`$event.oSource.sId`** and
  **`$event.oSource.getPressed()`** (the proven `$event.oSource.*` path).
- **092** — the `Slider.liveChange` / `MultiComboBox.selectionFinish` server
  round-trips returned an empty response and **blanked the view**; both were
  dropped at the time. **Superseded 2026-07-22**: `selectionFinish` is now wired
  1:1 through the new `setHiddenInPopin` control method (see the framework
  section below); only the `Slider.liveChange` (`setWidth`) stays inert.
  `popinChanged` still toasts.
- **085** — the first Tokenizer's tokens are now **model-bound** (`t_tokens`);
  add appends, delete removes by key (`$event.getParameter('tokens')[0].getKey()`).
- **081** — the incremental backend load is now reproduced 1:1 (start with one
  product, each pull appends the next via `fill_all` + a `shown` counter) instead
  of binding the full 123 up front.
- **084** — fixed with the real **`URLHELPER`** frontend action
  (`cs_event-urlhelper`): `TRIGGER_TEL`/`TRIGGER_SMS` take the number as a plain
  string param, `TRIGGER_EMAIL`/`REDIRECT` a `{ EMAIL/URL, … }` object-literal
  `t_arg` (`get_t_arg` emits `{`-prefixed args raw as UI5 event-handler object
  literals). An earlier claim that URLHELPER had "no ABAP path" was **wrong** —
  it is callable; the withdrawn `urlhelper-abap-api` pr is recorded in
  `pr/README` Declined. **`open_new_tab` is same-origin-only** (`isValidRedirectURL`),
  so it can't open external sites/`tel:`/`mailto:` — the external links in apps
  **041/073** were switched from `open_new_tab` to `urlhelper` REDIRECT
  (correctness fix), and CAPABILITIES.md updated.

Both **`pr/`** requests from the checks —
`table-hidden-in-popin` (092) and
`popover-bind-element` (094) — are now
**implemented** in the framework (see the next section).

## Framework features implemented (2026-07-22) — `setHiddenInPopin` + `BIND_ELEMENT`

Both were carried into abap2UI5 (branch `claude/ai-demokit-edge-cases-ftv30b`)
and the two demokit apps rewired to use them:

- **`setHiddenInPopin`** — new `sap.m.Table` entry in `CONTROL_METHODS`
  (`["object"]`), in both `app/webapp/core/FrontendAction.js` and the ABAP
  generator mirror `z2ui5_cl_app_frontendaction_js`. **App 092** now reproduces
  `onSelectionFinish` 1:1: the `MultiComboBox` `selectedKeys` are two-way bound
  to `t_hidden`, and `selectionFinish` forwards them as a JSON Priority array via
  `follow_up_action( cs_event-control_by_id, setHiddenInPopin )`.
- **`BIND_ELEMENT`** — new `cs_event-bind_element` constant + `evBindElement`
  action (both JS files) + brace-stripping arg formatting in
  `get_event_client`, so a whole view slot can be element-bound to a table row
  through `follow_up_action`. **App 094** now reproduces the original
  `oPopover.bindElement(...)`: the popover uses relative bindings
  (`{PRODUCT_ID}` / `{NAME}` / `{PRODUCT_PIC_URL}`) and
  `follow_up_action( val = cs_event-bind_element, view = cs_view-popover,
  t_arg = VALUE #( ( idx ) ( client->_bind( t_products ) ) ) )` binds the
  popover slot to `t_products/<index>`, the index taken from the pressed row's
  binding context. 3 node tests added (29 pass, abaplint clean).

Both apps stay machine-green (abaplint against the updated framework,
validate-meta, pattern-lint, structural-diff `--strict`, property-check,
render-smoke `--strict` — 094 now renders 2 docs incl. the popover). Their
sidecars' `IMPROVISED` deviations were rewritten from "dropped/inert" to the
faithful wiring. **LIVE-TEST pending** on both.

## Overview: always-shown Audit column (2026-07-22)

The overview table gained an **Audit** column (`scripts/generate-overview.mjs`,
computed from each port's ABAP source at generation time, always visible). One
badge per framework-wiring fact the port uses: `_event_client` (9 apps) and its
`t_arg` form (3), `follow_up_action` (14) and its `t_arg` form (14), opens a
`Popup` (8) or `Popover` (1), and **literal binding** (40) — a path written by
name in clear text (`{FIELD}` / `{/Path}`) instead of via `client->_bind`, the
form that breaks on a variable rename.

## Overview overhaul (2026-07-22) — releases, filters, Shell, split Open

Further reworked `scripts/generate-overview.mjs` (all offline, baked into the
generated class at generation time):

- **Title** now carries the ported-app count — `abap2UI5 Demo Kit (94)`.
- **Release column** (next to Sample): the direct UI5 release the whole *sample*
  needs = the control `since` raised by any kept post-1.71 member (parsed from the
  POST_171 deviation texts); blank = available since forever. The existing
  **Since** column keeps showing the *control's* own since (next to Control).
- **Deviation** rescaled 1→10 (`min(10, 1 + weighted deviations)`) and **no longer
  coloured** (plain text).
- **UI5 only column**: badges rows whose control is not part of OpenUI5. The
  membership oracle is `ui5/properties.json` ∪ `@openui5` source module (`.js`) ∪
  library.js / .library mentions — so statics (URLHelper) and CSS-class doc
  entities (StandardMargins/ContainerPadding) count as OpenUI5; only the two
  demo-kit-only composite *Pattern* samples (012/013) flag `ui5_only` (2).
- **Header filter checkboxes** (default all on), filtering the table entirely on
  the client via each row's `visible` expression (no round-trip): Hide non-OpenUI5,
  Hide newer than 1.71 (2020) (28 apps), Hide deprecated (0). Disabled while the
  tree is shown.
- **Shell switch** (next to Tree view) toggles the `sap.m.Shell` letterboxing
  (`appWidthLimited`), two-way bound, client-side.
- **Open column split into two buttons**: the first starts the abap2UI5 app
  **in-page from the backend** via `client->nav_app_call` (server event
  `START_APP`). The overview enables **hash routing** (UI5 Router style) once
  with `client->set_nav_routing( )`; the framework then pushes the bookmarkable
  route `#/app/<CLASS>` for the called app, and the native browser Back/Forward
  buttons navigate between the overview and the launched apps — no new tab, no
  page reload. The second button opens the reference-links popover, trimmed to
  the four external links (OpenUI5 API, source, live sample, ABAP class). The
  same two buttons sit on every tree leaf.

Follow-up refinements (2026-07-22): the **Release** column is renamed **Since**
and only shows a value when higher than the control's own since (otherwise it
just repeats it); **both Since columns are sortable and coloured orange**
(`ObjectStatus` Warning via a `{= … ? 'Warning' : 'None' }` expression) when newer
than 1.71. **UI5 only → Version** (still the orange SAPUI5 badge). The **Note
column is removed**; its info (checked status, post-1.71 note, generation notes)
moved **into the links popover**, which also carries the four reference links. The
two Open buttons are **swapped** (links-popover first, app-launch second), on the
table and the tree. The `Tree`-nested-in-`Table` startup crash from the first cut
is fixed (missing `shut()` restored). The popover's generation notes render as an
**HTML bullet list** (`FormattedText`, one `<li>` per bullet, the type label in
bold; the note text is HTML-escaped, then the builder's `xml_escape` + UI5's
single un-escape show it verbatim). The **sample-since version parser** was fixed:
it now takes the max of *all* version tokens in the POST_171 texts (the old
`since X.Y` regex missed the common `since UI5 1.84` phrasing, so the column was
nearly always blank); 28 rows now carry a sample-since (matching the 28 post-1.71
ports).

## Batch b11 generated (2026-07-22) — pages, pickers, tables & popovers (7 ports)

Classes **088–094**, breadth-first NEW-CONTROL: 088 StandardMarginsAll
(`sap.ui.core.StandardMargins`), 089 PageStandardClasses (`sap.m.Page`),
090 DialogSearch (`sap.m.SearchField`), 091 TimePickerHidden (`sap.m.TimePicker`),
092 TableAutoPopin (`sap.m.Table`), 093 TabContainer, 094
PopoverControllingCloseBehavior (`sap.m.Popover`). Machine-verified green
(abaplint, validate-meta, pattern-lint, structural-diff `--strict`,
property-check, render-smoke `--strict`); status `generated`.

Notables: **091** reuses the app-016 openBy pattern (source `sId` via
`$event.oSource.sId` → `control_by_id`/`openBy` follow-up); **092** keeps the
declarative `autoPopinMode` + `Column.importance` 1:1 (the imperative
setWidth/setHiddenInPopin handlers dropped) and reuses the curated
`Formatter.weightState`; **090** and **094** build their dialog/popover via
`popup_display`/`popover_display` in `on_event` (094 passes the row values as
event args and anchors by `sId`). **This batch is 7 ports, not 10**: the three
remaining backlog-top controls were **deferred** as too lossy for a 1:1 port
(AGENTS §5) — **SemanticPage** (semantic-page landmark aggregations),
**QuickView/QuickViewCard** (multi-page card navigation + navOrigin), and
**ViewSettingsDialog** (custom sort/filter/group tabs). They stay NEW-CONTROL in
the backlog for a dedicated effort, alongside the calendar family
(PlanningCalendar / SinglePlanningCalendar) and SplitApp/SplitContainer that now
dominate the backlog top.

## Batch b10 generated (2026-07-22) — toolbars, tiles & lists (10 ports)

Classes **078–087**, breadth-first NEW-CONTROL: 078 TileContent,
079 TitleLink (`sap.m.Title`), 080 ToggleButton, 081 PullToRefresh,
082 SlideTile, 083 StandardListItemAvatar (`sap.m.StandardListItem`),
084 UrlHelper (`sap.m.URLHelper`), 085 TokenizerBasic (`sap.m.Tokenizer`),
086 ToolbarDesign (`sap.m.OverflowToolbar`), 087 ContainerNoPadding
(`sap.ui.core.ContainerPadding`, an IconTabBar demo). Machine-verified green
(abaplint, validate-meta, pattern-lint, structural-diff `--strict`,
property-check, render-smoke `--strict`); status `generated`.

Notables: **083** keeps the original's `{/ProductCollection}` List element
binding + `{0/Name}..{3/Name}` index item bindings against the full 123-row
default-model table; **084** flattens `/SupplierCollection/0` to a `/S_SUPPLIER`
record and maps the URLHelper tel/sms/email triggers to toasts (website →
open_new_tab); **086** turns the Select `change` design/style handlers into
two-way binds + an expression-binding `visible`; **087** flattens the
`/ProductCollectionStats/Counts` to `/TOTAL /OK /HEAVY /OVERWEIGHT`.
The two heaviest OverflowToolbar samples (OverflowToolbarFooter, full table +
menu; OverflowToolbarTokenizer, many tokenizers + DateTimePicker/SegmentedButton)
were left in the backlog for a dedicated effort rather than forced in.

## Batch b09 generated (2026-07-22) — objects, inputs & notifications (10 ports)

The next 10 backlog-top NEW-CONTROL samples, breadth-first (one port per
uncovered control), classes **068–077**: 068 Slider, 069 RadioButton,
070 ProgressIndicator, 071 ObjectIdentifier, 072 ObjectNumber,
073 ObjectAttributes (`sap.m.ObjectAttribute`), 074 ObjectListItem,
075 SelectList, 076 NotificationListItem, 077 NotificationListGroup.
Machine-verified to green (abaplint ×STANDARD, validate-meta, pattern-lint,
structural-diff `--strict`, property-check, render-smoke `--strict`). Status
`generated` (no human live check yet).

Notables: the list ports (**074**, **075**) inline the full 123-row mock
per the 2026-07-22 no-subset rule; **074** precomputes the `.formatter.status`
ValueState into a `STATUS_STATE` field (the app-038/545 pattern). The
single-record display ports (**071**, **073**) reproduce the original's
`{/ProductCollection/0}` element binding as a one-record `/S_PRODUCT` structure
(the 041 pattern); **072** carries records 0–5 as a 6-row table and
element-binds each ObjectNumber to `/T_PRODUCTS/0..5` (index binding, inlined
`_bind` per control). **070**'s two interactive ProgressIndicators are set via
two-way bound percentValue/displayValue + a SET event (replacing the
controller's byId setters). New POST_171 firsts: `RadioButton.wrapping`/
`wrappingType` (1.126), `ProgressIndicator.displayAnimation` (1.73),
`ObjectNumber.inverted`/`active`/`press` (1.86), `ObjectAttribute.ariaHasPopup`
(1.97). The notification ports are static declarations (close's client-side
`removeItem` is not mirrored → toast; declared). Open LIVE_TESTs (machine-only):
the `${$source>/title}` event args (076/077), the interactive PI SET round-trip
(070), the feedback popup + open_new_tab (073), the ObjectNumber index bindings
(072).

## Full mock data + deviation score (2026-07-22)

Two user decisions this day:

- **No more data subsetting.** The nine `SUBSET_DATA` ports were rebuilt to
  inline the **full mock row set** (all 123 `/ProductCollection` rows of
  `ui5/mock/products.json`), byte-identical to the mock: **006, 030, 033, 034,
  039, 040** (product lists), **012** (all 123 rows loaded, the table binding
  still filters to `Category = Laptops` as the original does client-side; `price`
  bumped to `DECIMALS 2` so the 19 non-integer prices stay exact) and **022**
  (full products + the precomputed `/ProductCollectionStats/Filters` counters —
  16 categories / 12 suppliers — which is what the original binds). **041** keeps
  its single `/ProductCollection/0` binding (that is the original's own
  single-record binding, not a subset) — its tag was relabelled `NOTE`. The
  `SUBSET_DATA` deviation type is **retired**: `validate-meta` now rejects it and
  `AGENTS.md §model_init` requires the full row set. All checks stay green
  (abaplint, structural-diff `--strict`, validate-meta, pattern-lint,
  property-check, render-smoke `--strict`).
- **Rating (1–5) in the overview app.** A sortable **Rating** column in
  `z2ui5_cl_smpc_app_overview` scores, "by feel", how much attention a port
  deserves — not a strict deviation count. Four things push it up (all
  additive): **complexity** (a big view / rich interaction — LOC, `_event*`/
  `follow_up_action` count, control count), **rework** (every non-1:1
  substitution `IMPROVISED`/`DROPPED_171`/`SUBSET_DATA` or documented `NOTE`
  subtlety), **discussed** (a port reviewed together — it carries a `checked`
  block), and **test-priority** (pending `LIVE_TEST`s, roundtrip-free/runtime
  wiring, popups/popovers, a needs-newer-than-1.71 render). `score =
  min(5, max(1, round(1 + Σweights)))`; 1 = simple faithful 1:1, 5 = complex /
  reworked / worth a close look. Sort descending to find the samples worth a
  closer manual look. Computed in `scripts/generate-overview.mjs`. Current
  spread: **6×1, 32×2, 24×3, 15×4, 17×5** (was briefly rescaled to 1–10, taken
  back to 1–5 with the richer heuristic on user request 2026-07-22).
- **Four LIVE_TESTs closed.** 060 Menu, 061 MenuButton, 066 MessagePopover,
  067 MessagePopoverAsync were human live-checked (open/toggle + item paths) and
  promoted `generated → checked`; their `LIVE_TEST` entries became live-verified
  `NOTE`s. (Later that day the client-composed-toast conversions — 005, 060, 061,
  077, see below — re-opened a few `LIVE_TEST`s for the new roundtrip-free
  mechanism.)

## Client-composed toasts (2026-07-22)

The abap2UI5 branch gained `pr/message-toast-format`: a `control_global`
single-string method (`MessageToast.show`, `MessageBox.*`) composes its text
from a template + client-resolved args (`{0}`,`{1}`,… filled by `$event.*` /
`${$parameters>/…}`), so a **dynamic** toast is roundtrip-free — 1:1 with the
demo-kit `MessageToast.show("…" + evt.…)`. `get_t_arg` quotes a leading `{0}`
placeholder so a value-first template survives; a lone string is unchanged.
Ports **005** (Button, 12 presses), **060** (Menu), **061** (MenuButton) and
**077** (NotificationListGroup) converted — each loses its `on_event` entirely
and becomes **init-only**. Toasts whose text is computed server-side (019, 024,
…) correctly keep their round-trip. All gates green; the four converted ports
carry a `LIVE_TEST` for the new mechanism.

Follow-ups (same day): **003, 016, 074, 076, 091** converted (all init-only;
016 also moved its openBy from a round-trip to `_event_client`). Then two
framework additions closed the last gaps — a **conditional placeholder**
`{N?trueText:falseText}` (truthiness of the value) and **single-quote escaping**
in `get_t_arg` (`'` → `\'`) — which unblocked **080** (ToggleButton,
`{0} {1?Pressed:Unpressed}` from `getPressed()`), **049** (StepInput,
`Value changed to '{0}'`) and **008** (ColorPalette, two args incl. a `\n`).
Twelve ports total are now client-composed/init-only. Kept on their round-trip
by design: server-computed or model-mutating toasts (019, 024, 025's action
branch, 047, 085).

## control_by_id view-slot fix + golden category retired (2026-07-22)

- **Runtime bug fixed.** After the framework moved the view to its own `view`
  parameter (`get_event_client` inserts it at `t_arg` index 2 for
  `control_by_id`), the ports that still carried an explicit empty `( `` )` view
  slot ended up with `[id, '', '', method, …]`, so the frontend read
  `method = ''` and logged `CONTROL_BY_ID: method '' not allowed` (openBy/
  toggleBy never fired). Dropped the empty slot in **060, 065, 066, 067, 091**
  and in the overview generator's tree Expand-all/Collapse-all buttons; correct
  form is `( id ) ( method ) ( params )`. New pattern-lint rule
  `control-by-id-empty-view-slot` guards it.
- **`golden` status retired** (user decision — "erstmal keine golden kategorie").
  The five golden ports (007, 016, 019, 022, 040) are now plain `checked`;
  `validate-meta` drops `golden` from the status vocabulary; the overview
  generator drops the `golden` flag (it fed only the rating's "discussed"
  signal, now `checked`-only); AGENTS.md / TRAINING.md updated. Former golden
  ports may now be refactored to the current conventions like any other.

## Batches

The 34 existing ports are retro-grouped into review batches — one subpackage
`src/01/b<nn>` = one ABAP package = one review unit (recorded per port in
`meta/<class>.json` as `batch`):

| Batch | Theme | Apps | Live-checked |
|---|---|---|---|
| `b01` | Display & navigation | 408, 409, 431, 434, 440, 460, 529, 530 | 431, 434, 440, 460, 529, 530 |
| `b02` | Selection & input | 421, 422, 423, 439, 452, 454, 472, 481, 527, 528 | 421, 452, 454 |
| `b03` | Actions, toolbars & popups | 447, 448, 449, 469, 474, 486, 526 | 469, 474, 486, 526 |
| `b04` | Layout, lists & data | 401, 404, 420, 433, 441, 445, 471, 473, 487 | 401, 404, 420, 433, 471, 473, 487 |
| `b05` | Backlog top: bars, tables, custom items & patterns | 531, 532, 533, 534, 535, 536, 537, 538, 539, 540 | all (2026-07-20) |
| `b06` | Date pickers, dialogs, feeds & tiles | 541, 542, 543, 544, 545, 546, 547, 548, 549, 550 | all (2026-07-20) |
| `b07` | Icon tabs, tile content, menus, list items & message strips | IconTabHeader, ImageContent, InputListItem, LabelProperties, LightBox, Menu, MenuButton, MessageStrip, NewsContent, NumericContent (classes 055–064) | — (machine-verified only) |
| `b08` | Message popover (all three MessagePopover samples) | MessagePopoverMessageHandling (065), MessagePopover (066), MessagePopoverAsyncMessageHandling (067) | 065–067 (2026-07-22) |
| `b09` | Objects, inputs & notifications | Slider, RadioButton, ProgressIndicator, ObjectIdentifier, ObjectNumber, ObjectAttributes, ObjectListItem, SelectList, NotificationListItem, NotificationListGroup (classes 068–077) | — (machine-verified only) |
| `b10` | Toolbars, tiles & lists | TileContent, TitleLink, ToggleButton, PullToRefresh, SlideTile, StandardListItemAvatar, UrlHelper, TokenizerBasic, ToolbarDesign, ContainerNoPadding (classes 078–087) | — (machine-verified only) |
| `b11` | Pages, pickers, tables & popovers | StandardMarginsAll, PageStandardClasses, DialogSearch, TimePickerHidden, TableAutoPopin, TabContainer, PopoverControllingCloseBehavior (classes 088–094) | — (machine-verified only) |

New generation batches continue as `b08`, `b09`, … per the process in
TRAINING.md.

## Batch b08 generated (2026-07-20) — the whole MessagePopover family (3 ports)

All three `sap.m.MessagePopover` demo-kit samples, so the control has no
ambiguous representative. To port the canonical simple one, **`sap.m.sample.
MessagePopover` was taken out of the hold-out set** (`ui5/holdout.json`,
25 → 24; user decision 2026-07-20) — it is the clean base demo, so it earns a
port rather than staying a regression reference.

- **066 MessagePopover** (base) — the canonical demo: an empty Page + a footer
  button that toggles a MessagePopover listing five static messages
  (Error/Warning/Success/Error/Information) with a MessageItem `link`. The
  MessagePopover (built in the sample's controller) is declared in the button's
  `dependents`; `oMessagePopover.toggle(button)` becomes the new `toggleBy`
  frontend action anchored to `$event.oSource.sId`; the three severity
  formatters (icon/type/count) are precomputed from the static mock. app-038
  plain-table shape — no cc, no `message>` needed.
- **067 MessagePopoverAsyncMessageHandling** — same shape with
  `markupDescription=true` and an HTML-rich first message; the controller's
  `setAsyncURLHandler` (client-side async URL validation) has no equivalent and
  is dropped (declared).
- **065 MessagePopoverMessageHandling** — the message-model app, ported on a
  **new `z2ui5.cc.MessageManager`** companion control (abap2UI5, this branch)
  that bridges the UI5 message manager to a two-way bound ABAP table:
  app-authored messages (`items`) are reconciled into the manager with a target
  + the view's model as processor (field valueState), while binding-type/
  constraint validation still auto-collects into `message>`. The cc mirrors the
  MultiInputExt pattern, is unit-tested (add/dedup/remove-own/leave-foreign/
  defer) and in the preload. So the earlier "message-manager-binding already
  covered" note was only half-right: reading was covered by `message>`,
  **writing** needed this cc. Port: two forms bound to `/T_FORMS` (3-row
  subset) + `/T_EMPLOYMENT` with typed value bindings + constraints
  (auto-collection), MessagePopover on `{message>/}`, the cc on `/T_MESSAGES`,
  Save authors a demo message. Controller-only severity/group/scroll/
  CommandExecution dropped (declared).

All three machine-verified green (abaplint STANDARD+CLOUD, validate-meta,
pattern-lint, structural-diff `--strict`, render-smoke `--strict` with a new
`z2ui5.cc.MessageManager` harness mirror + empty `message>` model,
property-check). The message-manager runtime (065's auto-collection + cc
reconcile + valueState; the toggleBy toggle; activeTitlePress) stays LIVE_TEST
— unverifiable headlessly. Render-smoke bugs fixed while porting 065: a missing
Button-closing `shut` (MessagePopover leaked as a direct Button child), the
email regex needing `\\`-escaped backslashes for the binding parser, and
`DATA … TYPE <named-table-type>` not recognised as a table by the
reconstructor (switched to inline `STANDARD TABLE OF`, the AGENTS §5
convention).

## Batch b07 generated (2026-07-20)

The next 10 backlog-top NEW-CONTROL samples, breadth-first (one port per
uncovered control), classes **055–064**: 055 IconTabHeader, 056 ImageContent,
057 InputListItem, 058 LabelProperties (`sap.m.Label`), 059 LightBox,
060 Menu, 061 MenuButton, 062 MessageStripWithEnableFormattedText,
063 NewsContent, 064 NumericContentIcon. Machine-verified to green
(abaplint ×STANDARD+CLOUD, validate-meta, pattern-lint, structural-diff
`--strict`, render-smoke `--strict`, property-check). Adversarial AI review
(2 reviewers × 5 apps): **9 CLEAN, 1 MINOR, 0 MAJOR** — the MINOR was app 060's
press handler dropping the sample's toggle (close-if-open) branch; the menu's
open/closed state lives client-side and is not reliably mirrorable
server-side, so the port always (re-)opens and the reduction is now declared
in the sidecar.

Three controls at the top of the backlog were **deferred** rather than forced
into a lossy 1:1 (AGENTS §5 "if the sample's whole point needs an
inexpressible feature, do not port it"): **InitialPagePattern** (an
app-level pattern — seven fragments, value-help dialog, IllustratedMessage,
client filtering), **InputModelUpdate** (its whole point is oData v2 late
binding via `bindElement`/`dataReceived`, and abap2UI5 serves a single
default model), and **MessagePopoverMessageHandling** (built on the UI5
MessageManager / message model). They stay `NEW-CONTROL` in the backlog for a
later dedicated effort.

Techniques worth noting: **060 Menu** reuses the app-016 openBy
frontend action — the Menu is declared in the Button's `dependents`
aggregation and opened via `control_by_id`/`openBy` anchored to
`$event.oSource.sId`. **058 LabelProperties** is roundtrip-free: the four
controller handlers become two-way `state` binds (displayOnly/wrapping) plus
`{= }` expression bindings (`wrappingType = hyphenation ? 'Hyphenated' :
'Normal'`, container `width = slider_value + '%'`), the app-007 pattern.
**062 MessageStrip** keeps the post-1.71 `controls` multi-link aggregation
(1.129, declared) and the `enableFormattedText` HTML strips. New POST_171
firsts this batch: `Button.ariaHasPopup` (1.84, app 060),
`MenuButton.beforeMenuOpen` (1.94, app 061), `MessageStrip.controls` (1.129,
app 062). The b07 ports are `generated` (no human live check yet); the menu
item-arg paths (`${$parameters>/item/text}`) and the openBy anchoring are the
open LIVE_TESTs.

**Framework gaps from b07 — two implemented upstream, one deferred:**
- **`menu-toggle-openby` → implemented 2026-07-20**: `toggleBy: ["domRef"]`
  added to `CONTROL_METHODS` (`control.isOpen() ? close() : openBy(anchor)`,
  no server-side open state). App 060 converted openBy→toggleBy — the
  press-to-toggle menu is now 1:1 (the IMPROVISED toggle-reduction is gone).
  Framework unit tests added.
- **`formatter-inline-icon` → implemented 2026-07-20**: `expandInlineIcons`
  added to the curated `model/formatter.js` (replaces `%%icon:sap-icon://…%%`
  placeholders with the `sapMMsgStripInlineIcon` markup via `IconPool`, the
  `getInlineIcon` equivalent). App 062's inlineIconsHelper converted to
  placeholders + a `core:require` formatter binding — no more guessed
  codepoints. Framework unit tests added; the render-smoke harness formatter
  mirror gained `expandInlineIcons`.
- **`menu-item-selected-path` → deferred** (user decision): the selected menu
  item's ancestor breadcrumb for 060/061; cosmetic (toast text), likely a
  documented boundary rather than a framework change. Folder kept under `pr/`.

Both implemented requests removed their `pr/` folders and moved to the
`pr/README` Implemented table; CAPABILITIES.md updated (toggleBy row, formatter
`expandInlineIcons`). A fourth idea, exposing the MessageManager for the
deferred `MessagePopoverMessageHandling`, was **investigated and not filed** —
the `message>` model (2026-07-18) and the plain-table approach (app 038)
already cover the MessagePopover family, so that sample is a porting task, not
a framework gap.

## Full human live check (2026-07-20) — every open question cleared

The human worked through the complete interaction checklist in a running
system (batches b01–b06, all framework-mechanism firsts incl. the freshly
merged openBy/compound-filter paths, the review-fixed 550 scroll step, the
device> phone checks and the 530 restamp) and confirmed every item. All
LIVE_TEST deviations are closed, **40 of 54 ports are `checked`** — the
14 remaining `generated` ports are b01–b04 apps that never carried an open
question. Follow-up same day: **five ports promoted to `golden`** (401 compound
filter + formatter, 421 expression bindings, 454 cc-control tokens,
540 frontend action, 543 dialog flows) — the generation-prompt reference
set in AGENTS §5 now spans six worked references across the technique
range.

## Human visual pass over b05+b06 (2026-07-20, earlier the same day)

All 20 new ports were started in a running system and render without
errors (apps opened and looked at; interactions not exercised). Closed on
that basis: 401's weight-state colors and 542's date-type rendering half
(DateTimeWithTimezone composites, empty-string DTP11, Islamic calendar).
The interaction LIVE_TESTs stay open — a prioritized detail-check list
was handed to the human (top of the list: 454 tokens, 540 openBy,
401 compound filter, 469/471, 550's fixed initial scroll step).

## Batch b06 generated (2026-07-20)

The next 10 backlog-top NEW-CONTROL samples (breadth-first): 541
DateRangeSelection, 542 DateTimePicker, 543 DialogConfirm, 544
DisplayListItem, 545 DraftIndicator, 546 FeedContent, 547 Feed
(FeedInput), 548 FeedListItem, 549 GenericTag, 550 HeaderContainer.
Machine-verified to green (abaplint ×3, validate-meta, pattern-lint,
structural-diff --strict, render-smoke --strict, property-check);
generation fixes: 544 chain-end paren, 541 t_arg alignment, 543 fragment
extras declared. Adversarial AI review (2 reviewers × 5 apps): **7 CLEAN,
2 MINOR, 1 MAJOR** — the MAJOR was a real behavior bug in 550
(`scrollStepByItem` seeded 0 instead of the UI5 default 1: initial arrow
scroll was 200 px instead of one item, with a sidecar note asserting the
wrong default as fact — fixed, seeded 1). MINORs fixed: 544's
supplier.json is now snapshotted byte-identical in `ui5/mock/` (the
AGENTS §4 offline-verifiability lesson) and its false "first element
binding" LIVE_TEST rewrote to a NOTE (app 041 already proved the
mechanism); 547's date-rebuild note now names the server-vs-browser
timezone delta. The reviewers source-verified the heavy claims: 541/542's
date-type bindings (source patterns, DateTimeWithTimezone V4
constraints), 545's DraftIndicator setter-equivalence, and 548's
`.indexOfItem(...)` method-call event arg (legal per ExpressionParser).
Notables: 545 replaces the un-whitelisted DraftIndicator show* calls with
a source-verified equivalent two-way `state` binding; 542/541 carry the
full date-type battery (source patterns, DateTimeWithTimezone V4
constraints, DateCreateObject); 544 fetched the un-snapshotted
supplier.json from upstream and noted it.

## Batch b05 generated (2026-07-19) — first post-probe batch

The first 10 backlog-top NEW-CONTROL samples (breadth-first per AGENTS §1),
generated with the probe-hardened rule set, machine-verified to green
(abaplint ×3, validate-meta, pattern-lint, structural-diff --strict,
render-smoke --strict, property-check) and adversarially AI-reviewed
(2 reviewers × 5 apps): **7 CLEAN, 3 MINOR, 0 MAJOR, no BUG-class
findings** — none of the probe's three MAJOR root causes recurred. Review
findings fixed in-place: ComparisonPattern archive completed
(formatter.js/manifest.json beyond the sample's own incomplete `files`
list), 536/540 sidecar prose now references the filed pr, 534's four
numeric mock fields retyped packed (batch-consistent with 535), 535's
popinLayout round-trip converted to the 534 expression-binding form, and
535's sidecar corrected on the local-vs-shared products.json difference
(HT-9995 differs in content). Highlights:

- The probe's distilled rules visibly held: no `popover_display( val = )`
  recurrence, flattening declared everywhere, app 015 explicitly reasoned
  the empty-string/enum rule, app 010 seeded `popinLayout` non-empty.
- **App 009** re-applies the app-401 `DROPPED_171` decision for
  `p:ColumnAIAction` (plugin class newer than 1.71 — dropped, not POST_171).
- **Two new framework gaps** → pr/control-methods-openby-setactivepage,
  **implemented upstream 2026-07-20** (new `domRef` arg kind, `openBy`,
  `setActivePage`; folder archived in pr/README Implemented): app 016's
  hidden-DatePicker wiring is now valid (IMPROVISED→LIVE_TEST). App 012's
  Carousel re-sync stays dropped — aggregation-template clone ids are not
  backend-addressable (recorded in the sidecar + CAPABILITIES; an
  index-based page resolution would be a new request if more samples need
  it).
- Render-smoke harness extended for b05: `sap.f` library loaded
  (DynamicPage/GridList/Card in 536/537) and scalar-row tables
  (`TABLE OF string` bound to array properties like `Table.sticky`, app 009) mocked as empty arrays instead of `{}` rows.
- New LIVE_TESTs are tracked in the b05 sidecars (popup/timer cycle 533,
  image dialog 538, `$source>/selectedKey` arg 535, sticky round-trip 534,
  binding_call-on-init + `to` navigation 536, popup focus flow 537).

## Verified fixed (2026-07-16)

An AI cross-review of all 34 ports against their JS/XML originals (5 parallel
reviewers), followed by fixes:

- **generate-overview.mjs** — regex parser rewritten line-based: a blank line
  before `CLASS` no longer drops the NOTES, later header markers no longer leak
  into the CHECKED text, literal chunking can no longer split a doubled
  backtick. Output byte-identical on the existing 34 ports.
- **The view builder** — LF/CR/TAB in attribute values now escape to
  `&#xA;`/`&#xD;`/`&#x9;` (fixes app 035's lost noDataText line break at the
  root).
- **App 022 (FacetFilter)** — Reset now really resets (two-way `selected`
  binding per FacetFilterItem) and the fragile JSON parse of
  `$event.mParameters.selectedItems` (private internals, silent CATCH) is gone;
  full NOTES block added. LIVE-TEST pending.
- **App 040 (MultiInput)** — the 6+1 pre-set tokens from `onInit` render again
  (tokens aggregation), View height restored, NOTES block added.
- **App 008 (ColorPalette)** — boolean `defaultAction` echoed as `true`/`false`
  instead of raw `X`/space.
- **Apps 034/044/049** — existing deviations declared in the header NOTES.

## Verified fixed (2026-07-16, second pass — fidelity backlog)

- **529**: toast replaced by the original's controller-built Dialog
  (`popup_display` + FragmentDefinition, per CAPABILITIES.md).
- **404 / 431**: the dropped sample CSS is injected via a `core:HTML`
  `content` attribute; 431 also carries the `tileLayout` class again on the
  15 tiles that have it in the original.
- **530**: redundant `SEP_CHANGE` round-trip removed — selectedKey and
  separatorStyle share one two-way path; the private event path is gone.
- **486**: toolbar widths are a pure expression binding
  (`{= ${slider} + '%' }`); `on_event` removed.
- **474**: private event path replaced by a two-way bound `selectedKey`
  (+ item keys as a declared port addition).
- **420/433/440/441/452**: mock-data subsets declared per port (the mock has
  123 rows — full unrolls add no demo value); **423/527**: sorter→`SORT`
  declared; **440**: `pic_url` renamed to convention (`product_pic_url`).
- Idiom: **526** captures the shared press event once + indexed event args
  (later simplified to `get_event_arg( )` when the convention inverted);
  **528/434** blank-line fixes — pattern-lint is at 0/0 with an empty baseline.

## Distilled from human fixes (2026-07-17)

Two human correction commits so far; every change fed back as a rule:

- `_bind_edit( path = abap_true )` for bare model paths (452) → CAPABILITIES.
- `t_arg` continuations align under `val` (421/422) → pattern-lint warn rule.
- Client handles (bind AND event) inline at each control, never captured —
  even repeated, even in expression bindings (526, then 486; 481/421 aligned
  accordingly) → pattern-lint error rule + AGENTS §5. Process lesson: my
  first distillation scoped the rule too narrowly (events only, bind handles
  exempted citing app 007) — the human had to fix the same error class twice.
  When distilling, prefer the GENERAL principle over the narrowest reading.
- Derive values from data like the original (530 `t_items[ 1 ]-text`),
  all-or-nothing `VALUE #( )` alignment after renames (440), minimal inline
  comments (452) → AGENTS §8.
- Trap: abapGit pushes from a stale system state can revert newer generated
  files (overview, twice) → AGENTS §10 gotcha; regenerate + diff after every
  human push.

## Full-port audit (2026-07-17)

A framework-aware re-review of all 34 ports (4 parallel reviewers, one per
batch) against their JS/XML originals, the current AGENTS/CAPABILITIES rules,
and the latest abap2UI5 changes (`control_call`/`control_call_by_id`,
`message_box_display` `dependentOn`/`contentWidth`, the `device>` model on
every view slot, nested-table deltas, `_bind`→two-way). Result: 25 ports
unchanged (incl. the golden set 420/421/526 confirmed still-current), 9 would
be generated differently. Fixed in this change:

- **472 (RangeSlider)** — the ten bound `value`/`value2` fields were `TYPE
  string` seeded with numeric literals; UI5 2.x strict-type validation rejects
  a string on a numeric property (the same class as the app-486 Slider gotcha,
  AGENTS §10). Retyped to `TYPE i`. **No gate caught this** → new pattern-lint
  rule `numeric-bound-as-string`.
- **441 (ListCounter)** — `DATA t_products TYPE TABLE OF ...` (implicit default
  key), the only occurrence in `src/`; it slipped the abaplint `defaultKey`
  gate, which only matches an explicit `DEFAULT KEY`. Fixed to `TYPE STANDARD
  TABLE OF ... WITH EMPTY KEY` → new pattern-lint rule `default-key-table`.
- **529 (ObjectStatus)** — a stale inline comment claimed the press "is wired
  to a message toast"; the code builds the original Dialog via `popup_display`.
  Comment removed.
- **447 / 452** — the self-referential `IMPROVISED` deviations reclassified to
  `NOTE`: `message_box_display` (447) and the default group header (452) are
  the documented 1:1 paths in CAPABILITIES.md, not workarounds.

Second pass — the four remaining audit items worked off (2026-07-17):
- [x] **434** — the `imageContainer` background-color CSS is kept and the
  sample's `styles.css` injected via a `core:HTML` `content` attribute (as
  431/404); deviation IMPROVISED→LIVE_TEST. Structural diff still 0 (the EXTRA
  `core:HTML` is matched by the declaration).
- [x] **454** — `suggestionItems` converted to the raw `sorter` binding-info
  string (`{ path: '…', sorter: {path: 'NAME'} }`), the ABAP `SORT` dropped;
  the pre-set-tokens deviation IMPROVISED→NOTE (a ✅ capability, not a
  workaround).
- [x] **439** — the CenterCenter toast is now docked 1:1 via
  `message_toast_display( my = 'center center' at = 'center center' )` — the
  client method exposes the full MessageToast options object (source-verified
  in `Messages.js`). New CAPABILITIES row; the "not expressible" NOTE corrected.
- [x] **401** — reclassified the two mislabeled IMPROVISED deviations to NOTE
  (the two-way FacetFilter multi-select is CAPABILITIES ✅ with 401 as its own
  evidence port; the two static lists are a faithful equivalent). The
  structural rewrite into a doubly-nested `lists` aggregation-template was
  **deliberately not done**: no port proves that aggregation-of-aggregation
  shape and it cannot be live-tested here — recorded as a LIVE_TEST option, not
  shipped blind on a working source-verified port.

## Framework requests + capability wins from the audit (2026-07-17)

Two ideas the audit surfaced, handled per their true nature:

- **`pr/control-call-whitelist`** (new; **implemented upstream 2026-07-18**,
  see the section below) — a genuine framework gap: the
  `control_call_by_id` whitelist (`to/back/focus/scrollToIndex/scrollTo`) does
  not include the imperative methods two 1:1 ports need — `PDFViewer.open()`
  (469) and `Panel.setExpanded()` (471). Written up as a forwardable request to
  broaden the list (its own comment already scopes it to "imperative methods
  with no binding equivalent"). `addValidator` (454) is explicitly out of scope
  (a client callback, not a one-shot call).
- **Composite `Currency` type — NOT a framework gap** — a source + samples
  check showed `sap.ui.model.type.Currency` is a client-side standard type and
  the curated samples (`z2ui5_cl_demo_app_369`/`_172`) already bind it via a raw
  binding-info string; the builder only XML-escapes attribute values, so it
  passes through to `XMLView.create` unmangled — exactly the sorter story. So a
  framework PR would be wrong. Instead: CAPABILITIES.md row split (standard
  composite **types** ✅ via raw binding-info string; only custom JS formatter
  **functions** stay ❌), and ports **440**/**401** converted to keep the
  original Currency binding 1:1 over a numeric `PRICE` (`TYPE p`) field —
  IMPROVISED dropped, LIVE_TEST added. App 041 keeps its static single-record
  resolution (an unrelated deviation), not blocked by the type.
- **MultiInput `addValidator` — NOT a framework gap either** — the bundled
  custom control `z2ui5.cc.MultiInputExt` installs exactly the sample's
  free-text→token validator (`addValidator(({text}) => new Token({key:text,
  text}))`, source-verified in `app/webapp/cc/MultiInputExt.js`) and mirrors
  token changes back via `addedTokens`/`removedTokens` + `change`. CAPABILITIES
  row added (🔶) and the app-454 deviation corrected IMPROVISED→NOTE. Initially
  left unwired (first cc-control usage needs a live check); **wired 2026-07-18**
  (human direction): app 040 now declares `xmlns:z2ui5="z2ui5.cc"` and one
  `z2ui5:MultiInputExt` leaf per token input (`multiInput1`/`multiInput2`,
  matching the original's two addValidator calls); the render-smoke harness
  carries a metadata-only mirror of the cc control so view creation stays
  gate-checked, the behavior check remains a LIVE_TEST.

**Pattern worth noting:** of the four framework ideas the audit raised, only
one (`control_call` whitelist) is a real gap; the composite `Currency` type
and the MultiInput validator were both already in the framework — the map/ports
had wrongly treated them as ❌. Exactly the "declared impossible although it
already works" failure mode CAPABILITIES.md opens by warning against.

**Same failure mode again — `sap.m.MessageView` (2026-07-18):** app 038 was
marked `IMPROVISED` / the map carried "MessageManager / `message>` model ❌",
yet the port already renders the MessageView 1:1 by binding the messages as a
plain ABAP table on the `items` aggregation with a `MessageItem` template — the
documented idiomatic path, not a workaround. The curated sample
`z2ui5_cl_demo_app_038` (abap2UI5/samples) proves the full set incl. grouping,
Dialog and MessagePopover. Corrected: app-449 deviation `IMPROVISED`→`NOTE`, and
the CAPABILITIES row split — `sap.m.MessageView`/`MessageItem`/`MessagePopover`
is ✅, only the MessageManager **auto-collection** of client-side control
validation messages stays ❌ (a separate, rarely-needed mechanism, not required
to render a MessageView). Fourth "already works" case after Currency,
MultiInput validator and the popup-mode controls — the map is consistently more
pessimistic than the framework.

## Verification & process upgrades (2026-07-18)

A hardening pass over the pipeline itself (builder, gates, planning):

- **Render-smoke gate** (`scripts/render-smoke.mjs`, CI job `render_smoke`,
  `npm run smoke`) — every port's view XML is reconstructed from the builder
  calls, fed a typed mock model derived from its TYPES/DATA/model_init, and
  loaded with a real `XMLView.create` in headless Chromium against the
  OpenUI5 runtime from the `@openui5/*` npm packages (offline). The first run
  caught and led to fixing:
  - **431/404/434** — literal CSS braces in a `core:HTML` `content` attribute
    are parsed as a **binding** by the XMLView parser and crash view creation;
    the CSS-injection technique only works with `\{ … \}` escapes. Braces
    escaped in all three ports, CAPABILITIES.md row updated, new pattern-lint
    rule `unescaped-brace-in-style-content`. (404/434 had hidden it because
    the value sat in a helper variable the first parser version dropped.)
  - **433** — `quantity TYPE string` bound to the int property
    `StandardListItem.counter` → strict-type rejection; retyped `TYPE i`.
    Same class as 472/486, but on a **table field**, which the scalar
    pattern-lint rule cannot see — the smoke gate covers this class now.
- **Structural diff compares binding values** — where the original attribute
  is a plain `{path}` binding and the port writes a literal, the tokens must
  match (case/underscore-normalized, flattened paths on the last segment).
  First run flagged the app-401 `ObjectIdentifier` `{Category}` cell —
  verified correct against the original controller (it swaps that cell), and
  the app-460 sidecar now names its statically resolved bindings precisely.
- **Builder hardened + unit-tested** — `a()` on the empty root, `shut()`
  past the root and duplicate attribute names now ASSERT instead of silently
  producing wrong XML; the view builder carries a local test class
  (nesting, attr targeting, escaping, booleans).
- **Breadth-first batch planning** — `--backlog` sorts samples on uncovered
  controls (`NEW-CONTROL`) first; one port per control before depth
  (AGENTS §1). 190 of 369 backlog samples sit on uncovered controls.
- **Hold-out set defined** — `ui5/holdout.json`, 24 samples across control
  families (was 25 until `sap.m.sample.MessagePopover` was ported in b08,
  2026-07-20); marked `HOLDOUT` in `--backlog`, never prompt references, never
  `golden`. First regeneration probe is due **before batch b05**.
- **Generation prompt single-sourced** — `scripts/generation-prompt.txt`,
  spliced into README by `generate-coverage.mjs`; the `meta_valid` job also
  regenerates coverage so README/api.md cannot drift.
- **Sidecar `audit` structured** — `{ frontend_action, event_t_arg, note? }`,
  enforced by validate-meta.

## Whitelist request implemented + ports converted (2026-07-18)

The `pr/control-call-whitelist` request was implemented upstream in
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5): `CONTROL_METHODS`
in `app/webapp/core/FrontendAction.js` now also whitelists `open: []`,
`close: []` and `setExpanded: ["bool"]` (embedded frontend regenerated, unit
specs extended). Follow-through in this repo, same change:

- **469** — converted from the Dialog-embedding workaround to the original's
  popup mode: the `PDFViewer` is declared in the view's `mvc:dependents`
  aggregation (the `addDependent` equivalent), `source` is bound, and
  `SHOW_PDF` runs `view_model_update` + `control_call_by_id( method = 'open' )`.
  IMPROVISED narrowed to the per-image JSONModel flattening (named-models
  family); the Dialog deviation is gone.
- **471** — converted from the two-way bound `expanded` + `view_model_update`
  workaround to the original's imperative toggle: `TOOLBAR_PRESSED` inverts a
  server-side mirror and calls `control_call_by_id( method = 'setExpanded' )`.
  The view now matches the original `view.xml` exactly; IMPROVISED dropped.
- CAPABILITIES.md: new rows for popup-mode controls in `mvc:dependents` and
  for imperative one-shot control methods; frontend-action catalog updated.
- **`pr/formatter-registry`** (new; **implemented 2026-07-18 as a curated
  module — after a security detour worth recording**): app-supplied
  client-side formatter functions, the next-most-common remaining gap. An
  eval-based first design (`register_formatter` shipping JS strings, compiled
  client-side with the `Function` constructor before view creation) was
  implemented upstream and **reverted the same day as a security decision**
  (human review 2026-07-18): it required `unsafe-eval` in the CSP — against
  the framework's strict-CSP direction (security headers, `_runCustomJs`
  deprecation) — and an official register-a-JS-string API invites building
  formatter bodies from data, a server-mediated XSS foot-gun. The trust-model
  argument ("the server ships all frontend code anyway") does not justify the
  *mechanism class*. The shipped design instead mirrors an original UI5 app's
  **formatter file** (human direction 2026-07-18): abap2UI5 now serves a
  curated formatter module in the standard app layout —
  `app/webapp/model/formatter.js`, next to `model/models.js` — a real script
  resource, no ABAP API change, growth via framework PRs only (the
  `control_call_by_id` whitelist model). Views wire it via
  `core:require="{Formatter: 'z2ui5/model/formatter'}"` (UI5 ≥ 1.74,
  POST_171 in ports; the published `z2ui5.Formatter` global covers older
  releases). It re-exports the `z2ui5.Util` date helpers so Util can fold in
  over time. Outcome:
  - **401** — the appended table's weight state keeps the original
    parts+formatter binding: the view requires the module like the original
    controller requires `./Formatter`, and binds
    `formatter: 'Formatter.weightState'` — the alias reference mirrors the
    original's `.formatter.weightState`. The interim expression-binding
    version and the precomputed `WEIGHT_STATE` column are both gone.
  - render-smoke harness mirrors the module's fixed contract (faithful
    `weightState` registered as the named module `z2ui5/model/formatter`,
    kept in sync with abap2UI5).
  - CAPABILITIES.md formatter row is 🔶: curated-module reference first,
    expression binding for app-specific one-offs, ABAP preformatting as the
    fallback; factories returning controls stay ❌.

## Formatter pack + binding_call implemented (2026-07-18)

A demo kit census (all 446 sap.m samples: ~45 use formatters, 35 in scope,
three different `weightState` variants under one name; 61 controllers call
`getBinding(...)`) led to two framework additions, both implemented upstream
the same day and demoed by beta samples in abap2UI5/samples `src/00/08`:

- **pr/formatter-demokit-pack** — six curated functions in
  `z2ui5/model/formatter` (`weightStateByValue`, `stockStatusState`/`-Icon`,
  `round2DP`, `dimensions`, `deliveryStatusState`); with the existing
  `weightState` every unported in-scope sample with a dedicated formatter
  file now ports with its original `formatter:` binding structure (renamed
  references need a `NOTE` deviation). Beta sample 453.
- **pr/binding-call** — declarative filter/sort on an aggregation binding
  (`binding_call_by_id` after a backend event, or roundtrip-free via
  `_event_client` + `cs_event-binding_call` with `${$parameters>/…}` args);
  closes the `oBinding.filter(...)` controller pattern 1:1, model untouched.
  Beta samples 454 (backend) / 455 (live, no roundtrip). Unlocks the
  SearchField/SelectDialog/ViewSettingsDialog/ListSelectionSearch families
  (~15–20 backlog samples) without IMPROVISED model filtering.

CAPABILITIES rows added/extended; live checks of 453/454/455 are the next
LIVE_TEST candidates (sample 455 is the first `_event_client` + `$`-arg
resolution proof).

## Date-object properties probed + arg-serializer bug fixed (2026-07-18)

- **Calendar date properties** (`CalendarAppointment.startDate` etc.,
  `type: "object"`) demand real JS `Date`s — a headless probe against the
  OpenUI5 runtime (`scripts/probes/date-object-probe.mjs`) proved: plain
  string binding crashes view creation, binding types throw
  (`Date.formatValue` has no `object` target), but a
  `formatter: 'Formatter.DateCreateObject'` binding renders identically to
  a real-Date model. CAPABILITIES row added; beta sample 456
  (abap2UI5/samples) demos the pattern. A model-level `utclong`
  auto-reviver was considered and **rejected** (it would retype every
  timestamp field, changing unrelated plain bindings); a per-path opt-in
  reviver remains an option only if the modify/DnD calendar samples prove
  the `$event`-arg write-back insufficient. Unlocks the ~25
  PlanningCalendar/SinglePlanningCalendar display samples.
- **`get_t_arg` positional bug found live and fixed upstream**: the arg
  serializer dropped every empty argument, shifting the following ones —
  a `control_call_by_id` without `view` sent its method name in the view
  slot (`method 'X' not allowed`, beta samples 448/449). Fixed in
  abap2UI5 (inner empties kept as `''`, trailing empties still trimmed;
  unit-tested). **Ports 469/471 were affected** — their pending
  `control_call_by_id` LIVE_TESTs ran against the broken serializer and
  can now be re-tested.
- Same-day builder lesson from the live checks: `z2ui5_cl_xml_view`
  navigation is per-method — child-less controls like `object_status`
  still navigate INTO themselves (sibling needs `get_parent( )`); rule
  documented in the samples AGENTS.md (bit sample 453).

## message> model, DnD reorder, roundtrip e2e (2026-07-18, second round)

- **pr/message-model implemented** — every view slot now carries the UI5
  message model as `message>` with `handleValidation` registration;
  CAPABILITIES flipped the "MessageManager auto-collection" row ❌→✅
  (seventh "already/nearly free" case). Unlocks the MessagePopover family
  (4–5 samples); beta sample 458.
- **DnD reorder confirmed framework-complete** — no gap: `dnd:DragDropInfo`
  + `$`-arg indexes + ABAP reorder covers the pattern (samples 307/459);
  CAPABILITIES row added. The TableDnD/TreeDnD family ports need no
  framework change.
- **Transpiled-backend roundtrip limitation was stale** — the Node backend
  renders view XML (typed-variable fix in `check_on_init` took effect);
  abap2UI5's `roundtrip.spec.js` now asserts view XML on init, the
  model-delta-before-on_event contract and the browser-rendered message
  box. Relevant here: the wire contract the ports rely on is now
  regression-tested upstream.

## Control/binding calls consolidated into follow_up_action (2026-07-19)

The interim client methods `control_call`, `control_call_by_id` and
`binding_call_by_id` (branch-only, never released) were removed upstream;
their events are now public `cs_event` constants (`control_global`,
`control_by_id`, `binding_call`) scheduled via `follow_up_action` with
positional `t_arg` (`control_by_id`: id, view — `''` = global lookup: all
slots' local ids are searched, then the global element registry
(`ViewSlots.resolveById`) —, method, params; `control_global`: object,
method, params; `binding_call`: id, aggregation, method, params). Wire format and frontend whitelist are
unchanged, so no LIVE_TEST result is invalidated. Follow-through here:
ports 469/471 migrated to the event-based calls, meta sidecars + overview
regenerated, CAPABILITIES rows reworded.

## Full re-review against the current rule set (2026-07-19)

A "would this be generated differently today?" pass over all 34 ports
(4 parallel reviewers, one per batch, against the archived originals and the
current AGENTS/CAPABILITIES). 32 of 34 ports were already what today's rules
produce; two were regenerated, plus hygiene. All changes in this pass:

- **401 (FacetFilterLight)** — four upgrades: (1) the appended table's
  `items` keeps the original `sorter` binding-info string, the ABAP `SORT`
  is gone (the 2026-07-17 conversion wave had missed this port); (2) the
  Dimensions cell binds the original composite
  `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}` over real columns instead of a
  precomputed `DIMENSIONS` string; (3) the header toolbar is restored — the
  popin-layout ComboBox (two-way `selectedKey`; the Table's added
  `popinLayout` expression maps empty→Block like the controller default) and
  the Hide/Show ToggleButton (two-way `pressed`; the restored infoToolbar's
  `visible` is a pure expression) — only the sticky Label/CheckBoxes stay
  IMPROVISED (array property) and `p:ColumnAIAction` is now a proper
  DROPPED_171; (4) the ABAP-side model filtering is now **declared**: the
  nested AND-of-ORs filter exceeds the single-filter `binding_call`
  whitelist — CAPABILITIES row scoped accordingly, forwardable request
  **pr/binding-call-compound-filters** opened.
- **460 (ObjectHeader)** — converted from full static resolution to the
  original element binding + relative field bindings 1:1 (`binding=` on a
  one-record `/S_PRODUCT` structure, Currency number binding kept); only
  the context path deviates. First `binding=` context port, LIVE_TEST.
- **Self-referential deviations reclassified** IMPROVISED→NOTE in 472
  (range→value/value2), 486 (expression-bound widths), 474 (two-way
  selectedKey) — same class the 2026-07-17 audit fixed for 447/452/454/449;
  the counts above now reflect it. App 038's NOTE no longer claims "no
  MessageManager model" (stale since pr/message-model).
- **Checked-invalidation rule** (new, AGENTS §10 + TRAINING): a code change
  to a `checked` port resets the status until restamped. Applied to 530
  (07-15 check vs 07-16 rework).
- **Structural diff now compares `id` attributes** (name-level per control
  type): app 047 had dropped the original `SB1`/`selectedItemPreview` ids —
  restored; the gate keeps it from recurring. Extra port-added ids stay
  unflagged.
- **Style normalized**: 528 rewritten from the one-off `a = VALUE #( )`
  string-table form to the canonical chained `a()` calls; 526 `v =` columns
  realigned (golden reference); 486 double blank line removed; multi-line
  inline comments compressed to the §8 one-liner in 422/431/434/447/454/469.
- **AGENTS §5 fixed**: the expression-binding paragraph still instructed
  "capture each bind handle once" — contradicting the never-capture rule and
  pattern-lint; now shows the inline form (421's actual code). STATUS's
  `control_by_id` empty-view wording corrected to the framework behavior
  (global lookup, not "keeps the slot").

## Hold-out regeneration probe #1 (2026-07-19) — baseline set

The first TRAINING.md regeneration probe ran: all 25 hold-out samples
generated from scratch, first-try, scored by every gate plus a 5-reviewer
adversarial pass. Full protocol and per-app numbers:
below. Headlines: 21/25 CI-green on first try,
23/25 structural-diff-clean, 0 genuine render failures, review 14 CLEAN /
5 MINOR / 6 MAJOR with only **three root causes** behind all MAJORs —
each distilled in the same change:

- `popover_display( val = )` guessed by analogy (3 apps, does not compile)
  → exact signature in CAPABILITIES, pattern-lint rule
  `popover-display-val`, prompt updated.
- `CONTROL_METHODS` arg-kinds ignored (2 apps: `to` transition /
  ViewSettingsDialog `open` page silently dropped, mis-filed as LIVE_TEST)
  → AGENTS §10 gotcha + CAPABILITIES row warning + pr/control-method-args
  (**implemented upstream same day**: `to [transitionName]`,
  `open [pageKey]`, `goToStep [controlId, bool]`; `castArgs` no longer pads
  missing trailing args — folder removed, see pr/README Implemented).
- Empty-string flattening breaks enum properties / overrides defaults
  (1 app, QuickView) → AGENTS §5 model rule, prompt updated.

Probe-found infrastructure fixes (landed 2026-07-19): render-smoke
formatter mirror synced to the full upstream contract; `resolveExpr` now
resolves `&&`-chained templates. The probe ports themselves are never
merged (hold-out discipline); the worktree snapshot exists only locally.

### Full write-up (moved here from `probes/` on 2026-08-18 — the directory collided in name with `scripts/probes/`, which holds executable probe scripts)

First run of the TRAINING.md regeneration probe: all 25 hold-out samples
(`ui5/holdout.json`) generated **from scratch, first-try** — no gate
iteration, no self-checking tools — with the rule set as of commit
`028eb34` (post the 2026-07-19 full re-review / follow_up_action
consolidation). This file is the **baseline** every future probe compares
against; the numbers only mean something relative to the next run.

### Protocol (repeat identically next time)

- Workspace: a throwaway git worktree (probe batch `src/01/b90`, classes
  `z2ui5_cl_smpc_app_601..625`, numbered alphabetically by sample name).
  The probe ports are **never merged** — hold-outs stay out of the repo;
  only this report lands on the branch.
- Originals: fetched from a sparse OpenUI5 master checkout (same source as
  the weekly `generate_result` snapshot), archived per manifest
  `sample.files` into the worktree's `ui5/sap.m/<Name>/`.
- Generation: one agent per sample; inputs restricted to
  `scripts/generation-prompt.txt`, `AGENTS.md`, `CAPABILITIES.md`, the three
  §5 worked references (408/421/454 + their originals/sidecars),
  `ui5/properties.json`, `ui5/universe.json`, `ui5/mock/`, and the sample's
  own original files. No other ports readable, no STATUS/TRAINING, no
  scripts. Agents write class + abapGit XML + sidecar and must not run any
  validation tool.
- Scoring: all gates run once over the raw output (702 via `npm run
  downport` in a throwaway copy), then an adversarial AI review
  (5 reviewers × 5 apps) against the originals, the rules and the framework
  sources.

### First-try gate results

| Gate | Result | Failing apps |
|---|---|---|
| abaplint v750 | **22/25 green** (11 issues) | 607, 613, 617 |
| abaplint Cloud | 22/25 green (10 issues) | 607, 613, 617 |
| abaplint v702 (downport) | **21/25 green** (12 issues) | 607, 613, 617, 619 |
| validate-meta | **25/25** | — |
| pattern-lint | **25/25** (0 errors, 0 warnings) | — |
| property-check | 25/25 (but see blind spot below) | — |
| structural-diff --strict | **23/25** (4 undeclared diffs) | 603, 624 |
| render-smoke --strict | 23/25 raw / **25/25 after harness fixes** | 602, 622 (both harness gaps, no port defect) |

The two render-smoke failures were both **harness** gaps, fixed same day on
the branch: the inline formatter mirror had drifted (only `weightState`
while upstream had grown the date helpers + demo kit pack), and
`resolveExpr` mangled a binding-info template continued over `&&`
(leaked literal `| &&` — app 602). After the fixes all 25 load in headless
`XMLView.create`; the existing 34 ports stayed 0 failing / 1 skipped.

### AI review verdicts

**14 CLEAN · 5 MINOR · 6 MAJOR**

| App | Sample | Verdict | Core finding |
|---|---|---|---|
| 601 | BusyIndicator | CLEAN | |
| 602 | DatePicker | MINOR | reimplemented `isValidValue` accepts Feb-31 (flat day 01..31); `sy-datum` vs browser-local date |
| 603 | Dialog | CLEAN | (sdiff: fragment-built List/Items show as undeclared EXTRA — declaration-text mismatch) |
| 604 | FormattedText | CLEAN | |
| 605 | Label | CLEAN | |
| 606 | MaskInput | CLEAN | |
| 607 | MessagePopover | MAJOR | `popover_display( val = … )` — parameter is `xml`; does not compile |
| 608 | MessageStrip | CLEAN | |
| 609 | NavContainer | MAJOR | transition animation silently dead: `to` whitelist is `["controlId"]`, extra t_arg dropped client-side; framed as LIVE_TEST instead of deviation + pr/ |
| 610 | ObjectMarker | CLEAN | |
| 611 | OverflowToolbarDifferentControls | CLEAN | |
| 612 | PageFloatingFooter | CLEAN | |
| 613 | Popover | MAJOR | `popover_display( val = … )` ×2 — does not compile |
| 614 | QuickView | MAJOR | flattening serializes absent JSON props as `""` → enum `QuickViewGroupElementType`/`AvatarShape` validation throws, pages fail to render; `target=""` overrides the `_blank` default; all undeclared |
| 615 | RadioButtonGroup | CLEAN | |
| 616 | RatingIndicator | CLEAN | |
| 617 | ResponsivePopover | MAJOR | `popover_display( val = … )` ×2 — does not compile |
| 618 | SearchField | MINOR | undeclared POST_171: event **parameter** `searchButtonPressed` (since 1.114) read via `${$parameters>/…}` — invisible to property-check |
| 619 | SelectDialog | CLEAN | (702 gate: `MODIFY … FROM VALUE #( )` not downportable — the one 702-only fail) |
| 620 | StandardListItem | MINOR | mock-model flattening not declared (batch-inconsistent) |
| 621 | TableAlternateRowColors | CLEAN | |
| 622 | TimePicker | CLEAN | (raw smoke fail was the stale formatter mirror) |
| 623 | Title | MINOR | mock-model flattening not declared |
| 624 | ViewSettingsDialog | MAJOR | `open` whitelist is `[]` → the filter-page argument is dropped, 3 of 4 buttons lose their behavior; framed as LIVE_TEST, no pr/ filed |
| 625 | Wizard | MINOR | `goToStep` gap correctly worked around but no pr/ request filed |

Deviation usage across the 25 sidecars: 24 IMPROVISED, 23 NOTE, 15
POST_171, 12 LIVE_TEST, 2 SUBSET_DATA (76 total; 10 apps fully clean with
an empty array). Vocabulary use is broadly correct; the two flatten-NOTE
omissions (620/623) and the NOTE-vs-IMPROVISED wobble on flattening are the
main inconsistencies.

### Root causes behind the 6 MAJORs — only three

1. **API parameter guessed by analogy** (607/613/617): `popover_display`
   imports `xml`, the agents wrote `val` like `popup_display`. No worked
   reference demonstrates `popover_display`. → CAPABILITIES now names the
   exact signature; pattern-lint rule `popover-display-val` makes it
   unrepeatable; abaplint also catches it (never silent).
2. **Whitelist arg-kinds ignored** (609/624, near-miss 625): a
   `CONTROL_METHODS` method drops every argument beyond its declared kinds
   — `to` loses the transition, ViewSettingsDialog `open` loses the page.
   Both ports declared LIVE_TEST where the behavior is source-decidable
   (and false), and neither filed the pr/ request. → AGENTS §10 gotcha
   added; `pr/control-method-args` filed (to/open/goToStep).
3. **Empty-string flattening vs enums/defaults** (614): a flat ABAP row
   serializes absent JSON properties as `""`, which UI5 enum validation
   rejects (where the original's `undefined` picked the default). → AGENTS
   §5 model rule added.

### Baseline numbers for the next probe

- CI green first try (all three builds): **21/25 (84 %)**
- Undeclared structural diffs: **4 (2 apps)**
- Genuine render failures: **0** (after separating harness gaps)
- Review: **6 MAJOR / 5 MINOR**, 3 distinct MAJOR root causes
- Gate blind spots found: 2 (event-parameter POST_171; helper-built
  fragments invisible to render-smoke — the known 481 class)

A future probe run counts the same eight rows. The rule-set fixes from this
run (popover signature, whitelist-args gotcha, empty-string rule, prompt
update) predict: the 3 compile fails and 2 whitelist MAJORs should not
recur; watch whether new MAJOR classes appear instead.

## Compound binding_call filters implemented + 401 converted (2026-07-20)

The last open framework request, pr/binding-call-compound-filters, was
implemented upstream (`BINDING_METHODS.filter` accepts a JSON groups
payload: OR inside each group, AND across groups, whitelisted operators,
empty clears; the positional single-filter form is unchanged). Port 401
now expresses the original's nested FacetFilter exactly — apply_filter
builds the groups JSON from the two-way bound selected flags and schedules
`cs_event-binding_call`; the ABAP-side model rebuild and the
`t_products_all` mirror are gone (deviation IMPROVISED→NOTE, new
LIVE_TEST). **pr/ is empty again** — every request implemented or
declined; see pr/README.

## Open findings (backlog)

Live tests: **ALL CLEARED 2026-07-20** — the human live check followed the
interaction checklist through batches b01–b06 (facet compound filter + Reset
+ popin toggle 401, MultiInputExt tokens 454, popup PDFViewer 469, panel
toggle 471, group headers 452, slider widths 486, selection toast 474,
press Dialog 529, BusyDialog timer cycle 533, sticky round-trip 534,
ComparisonPattern navigation 536, cookie focus flow 537, image dialog 538,
hidden-DatePicker openBy 540, date-picker CHANGE round-trips 541/542,
dialog flows 543, feed sender args 547/548, scroll-step switching 550, the
device> phone checks 433/434/473, and the 530 RESTAMP). Every LIVE_TEST
deviation is closed and the apps are promoted to `checked` in their
sidecars; 40 of 54 ports are now live-verified (the remaining 14 are
b01–b04 ports that never carried an open question).

Idiom / style (low):
- [x] ~~`main` method placed last in several ports~~ — done 2026-07-16: new
  convention, `z2ui5_if_app~main` is always the first method and the rest
  follow in call order (17 ports reordered, pattern-lint enforces main-first);
  also `get_event_arg( )` is now the required simplest form (index only for
  position 2+ — the earlier index-1 rule was inverted by decision).

Infrastructure:
- [x] ~~Property-level 1.71 gate~~ — done 2026-07-16:
  `scripts/generate-properties.mjs` parses per-member `@since` from the
  OpenUI5 sources into `ui5/properties.json` (refreshed weekly by
  generate_result); `scripts/property-check.mjs` runs in CI. Policy decision
  same day: **1:1 beats 1.71-purity** — post-1.71 members are KEPT when the
  original uses them and must be declared as `POST_171` (the gate enforces
  the declaration); the previously dropped members were restored. First
  catch: app 006's Carousel `ariaLabelledBy` (association only since 1.125)
  had been silently copied without any declaration.
- [x] ~~generate-coverage.mjs: `FOCUS_LIBS` undocumented; orphan ports vanish
  silently; header-regex fragility~~ — done 2026-07-16: ported set comes from
  `meta/`, the universe from the committed `ui5/universe.json` snapshot
  (refreshed by generate_result from the checkout), orphan ports are warned
  about, `FOCUS_LIBS` documented in AGENTS §7; api.md is one flat table with
  the deprecation info inline.
- [x] ~~Builder hardening: `a()` on the empty root is silently dropped; `shut()`
  past the root null-refs; duplicate attribute names render invalid XML~~ —
  done 2026-07-18: all three ASSERT (fail fast at the call site), plus a local
  unit test class on the view builder.
- [x] ~~property-check blind spot (hold-out probe 2026-07-19): the gate only
  scans `a( n = … )` attributes, so a post-1.71 **event parameter** read via
  `${$parameters>/…}` in a `t_arg` slips through undeclared (probe app 618,
  SearchField `searchButtonPressed` since 1.114)~~ — done 2026-07-20:
  `usedMembers` now also scans each control slice for `$parameters>/<name>`
  and resolves the first path segment against the same flat member map
  (event parameters already carry their `@since` in `properties.json`, e.g.
  `sap.m.SearchField.searchButtonPressed` = 1.114), attributing the ref to
  the control that fired it (the one carrying the event `a()`, = last
  opened). Error message names it as an event parameter and a `POST_171`
  deviation clears it, exactly like a property. Zero new errors on the 54
  live ports (every existing `$parameters` ref is ≤ 1.71); verified with a
  throwaway SearchField probe that the undeclared→declared transition flips
  exit 1→0. Deeper path segments (`item/oParent`) are runtime object fields,
  not metadata, and stay unchecked by design.
- [ ] pattern-lint stays regex-based **by decision** (2026-07-18): the rule
  set is green and each rule is small; a rewrite on the abaplint AST API only
  pays once regex rules start producing false positives/negatives in
  practice. Revisit when a rule needs real syntax awareness (first candidate:
  anything that must distinguish strings from code).
- [x] ~~render-smoke: app 049 is SKIPped (view built via `render_item` helper
  methods — not statically reconstructable). Either teach the reconstructor
  simple single-level helper inlining, or accept the skip; never let skips
  grow silently~~ — resolved 2026-07-20 by making the skip an explicit,
  CI-enforced decision (the second option). Single-level inlining does not
  actually suffice: the builder is handle-based (`open`/`shut` navigate a
  tree via held node refs, not one global stack), so app 049's `render_item`
  passes the List handle in and chains a returned handle out — faithfully
  rebuilding it needs a handle-tracking interpreter, and a wrong-but-rendering
  reconstruction would be a *false pass*, strictly worse than a visible skip.
  So: a port may declare `"render_smoke": { "skip": true, "reason": "…" }` in
  its sidecar (validated by validate-meta); render-smoke SKIPs a declared
  port but now **FAILS** an undeclared non-reconstructable one (helper-method
  builder calls with no declaration) *and* FAILS a stale declaration (a port
  that reconstructs but still declares skip). Skips can no longer grow
  silently — a new helper-built port fails CI until a human consciously
  declares or reconstructs it.
  **Update 2026-07-22 — the handle-tracking interpreter was actually built**
  (`extractDocsWithHelpers` in render-smoke.mjs). A builder handle is now a
  stack snapshot (root..cursor); `DATA(list) = view->…->open( List )` saves it,
  a builder-returning helper (`METHODS … RETURNING VALUE(result) TYPE REF TO
  z2ui5_cl_ui5_view_builder`) is parsed once into a relative op-chain, and every
  `render_item( list = list … )->leaf( … )` call is inlined re-anchored to its
  argument handle with the non-entry params (`label`) substituted string-aware.
  app 049 reconstructs faithfully (14 CustomListItems, each `HBox` → label
  VBox + StepInput VBox) and renders for real — **not** a wrong-but-rendering
  false pass: the tree is byte-correct. The declared-skip mechanism stays as the
  safety net for a future idiom the interpreter still can't rebuild. Its own
  skip declaration was removed; run is now **0 failing / 0 skipped**.
- [x] ~~render-smoke harness gaps found by the 2026-07-19 hold-out probe~~ —
  fixed same day: (a) the inline formatter mirror had only `weightState`
  while upstream `model/formatter.js` had grown the date helpers + demo kit
  pack — now mirrors the full curated contract; (b) `resolveExpr` treated a
  value starting with `|` as ONE template, so a template continued with `&&`
  leaked literal `| &&` into the attribute — now the (template-aware) `&&`
  split runs first and each piece resolves independently. Existing 34 ports
  unaffected (0 failing / 1 skipped before and after).
- [x] ~~TRAINING.md stage 2: generate the header block from `meta/`
  (inversion)~~ — done 2026-07-16, stricter than planned: port classes carry
  no header at all; `meta/` is the source of truth (validate-meta in CI,
  pattern-lint blocks `"!` in ports).
- [x] ~~Run `structural-diff.mjs --strict` in CI~~ — done 2026-07-16: the
  `checks` workflow runs pattern-lint, structural-diff --strict and a
  generated-artifacts sync check on every PR.
- [x] ~~AGENTS.md §5 "Worked references" points at nonexistent
  `src/04/z2ui5_cl_smpc_app_416`; §8 names the wrong builder classes~~ — fixed
  2026-07-16 (416 row replaced by app 007, §8 corrected to the view builder).
