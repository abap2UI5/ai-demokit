# todo/ — the import is triaged, the staging area is empty

**0 classes left.** This file is the closed record of the triage, kept because
AGENTS §2 points here for *why* a sample was or was not taken over — deleting it
would invite the same 53 classes to be re-imported and re-analysed.

53 classes were imported on 2026-08-12 from
[abap2UI5/samples](https://github.com/abap2UI5/samples) (21 from `src/00/02`
"restricted - release/version", 32 from `src/01/03` "Control Library") and
parked here to be triaged into ports — or dropped. On 2026-08-12 every one of
them got its decision: **1 rebuilt as a port, 52 dropped.** The samples repo
keeps its copies; this was an import for triage, not a move.

> The imported classes are built on the framework's own `z2ui5_cl_xml_view`
> builder. ai-demokit ports use `z2ui5_cl_ai_xml` exclusively (AGENTS §5), so
> taking one over was always a rewrite against the demo kit original, never a
> copy of the file.

---

## Rebuilt as a port (1)

| Sample class | Demo kit sample | ai-demokit port |
|---|---|---|
| `z2ui5_cl_smp_app_243` | `sap.m.sample.StandardNegativeMarginsTwoSided` | `z2ui5_cl_dmo_app_403` |

Its ABAP Doc URL names only `sap.m.Text`, so the first pass filed it under "URL
names only the entity — entity covered". The `<DESCRIPT>` told the real story —
`sap.m.Text - with class -Standard Margins - Negative Margins` — and the class
body is the demo kit sample line for line: `Page showHeader=false` + `Info`
sub-header toolbar, then four `Panel`s carrying
`sapUi{Tiny,Small,Medium,Large}NegativeMarginBeginEnd`. The sample had no port
(entity `sap.ui.core.StandardMargins`, 1 of 7 samples ported, not a hold-out),
so it was rebuilt as `z2ui5_cl_dmo_app_403` (`src/01/01`, batch b29) —
structural-diff 0 differences, no deviations.

**The lesson that produced it:** the entity in `<DESCRIPT>` is the control the
sample class was *filed under*, not necessarily the sample it *rebuilds*. Read
the class body before trusting an "entity covered" verdict; a join on the ABAP
Doc URL alone misses exactly this case.

---

## Dropped — control-library (31 of 32)

### The demo kit sample is already ported (14)

Same demo kit sample, already rebuilt here from the original. Nothing to take
over.

| Sample class | Demo kit sample | ai-demokit port |
|---|---|---|
| `z2ui5_cl_smp_app_292` | `sap.m.sample.BreadcrumbsWithCurrentPageLink` | `z2ui5_cl_dmo_app_286` |
| `z2ui5_cl_smp_app_239` | `sap.m.sample.CheckBox` | `z2ui5_cl_dmo_app_155` |
| `z2ui5_cl_smp_app_283` | `sap.m.sample.FeedInput` | `z2ui5_cl_dmo_app_236` |
| `z2ui5_cl_smp_app_257` | `sap.m.sample.GenericTag` | `z2ui5_cl_dmo_app_027` |
| `z2ui5_cl_smp_app_293` | `sap.m.sample.Link` | `z2ui5_cl_dmo_app_160` |
| `z2ui5_cl_smp_app_110` | `sap.m.sample.MaskInput` | `z2ui5_cl_dmo_app_153` |
| `z2ui5_cl_smp_app_372` | `sap.m.sample.MenuButton` | `z2ui5_cl_dmo_app_061` |
| `z2ui5_cl_smp_app_291` | `sap.m.sample.MessageStripWithEnableFormattedText` | `z2ui5_cl_dmo_app_062` |
| `z2ui5_cl_smp_app_375` | `sap.m.sample.NotificationListItem` | `z2ui5_cl_dmo_app_076` |
| `z2ui5_cl_smp_app_300` | `sap.m.sample.ObjectStatus` | `z2ui5_cl_dmo_app_042` |
| `z2ui5_cl_smp_app_022` | `sap.m.sample.ProgressIndicator` | `z2ui5_cl_dmo_app_070` |
| `z2ui5_cl_smp_app_207` | `sap.m.sample.RadioButton` | `z2ui5_cl_dmo_app_069` |
| `z2ui5_cl_smp_app_209` | `sap.tnt.sample.InfoLabel` | `z2ui5_cl_dmo_app_113` |
| `z2ui5_cl_smp_app_330` | `sap.uxap.sample.ObjectPageSectionShowTitle` | `z2ui5_cl_dmo_app_200` |

### The demo kit sample is a HOLDOUT (6)

These read like the strongest candidates — six of them name a real demo kit
sample, three of them on a control with **no** port at all. They are exactly the
ones that must **not** be ported: the hold-out set (`ui5/holdout.json`,
TRAINING.md) is regenerated from scratch with the current rules to measure the
generator, so a port built with a sample class in view would destroy the
measurement. `scaffold.mjs` refuses them.

| Sample class | Demo kit sample | Entity ported otherwise? |
|---|---|---|
| `z2ui5_cl_smp_app_051` | `sap.m.sample.Label` | yes — `z2ui5_cl_dmo_app_058` |
| `z2ui5_cl_smp_app_208` | `sap.m.sample.RadioButtonGroup` | **no** |
| `z2ui5_cl_smp_app_215` | `sap.m.sample.BusyIndicator` | **no** |
| `z2ui5_cl_smp_app_220` | `sap.m.sample.RatingIndicator` | **no** |
| `z2ui5_cl_smp_app_238` | `sap.m.sample.MessageStrip` | yes — `_062`, `_289` |
| `z2ui5_cl_smp_app_296` | `sap.m.sample.SearchField` | yes — `z2ui5_cl_dmo_app_090` |

### No demo kit sample behind the class (11)

Their ABAP Doc URL names only an entity, so there was nothing to join on. Each
class body was read against every demo kit sample of its entity — the check that
found `_243`. None of these rebuilds an unported, non-hold-out sample: they are
abap2UI5's own compositions of a control (placeholder `button`/`text`/`link`
content, a "Hello World" form, an own side-navigation layout), not rebuilds of a
demo kit original.

| Sample class | Entity | Verdict |
|---|---|---|
| `z2ui5_cl_smp_app_005` | `sap.m.RangeSlider` | own form demo; the entity's single sample is ported (`_045`) |
| `z2ui5_cl_smp_app_114` | `sap.m.FeedInput` | own FlexBox+TextArea imitation, no `FeedInput` control at all; `Feed`/`FeedInput`/`FeedListItem` all ported (`_024`, `_236`, `_025`) |
| `z2ui5_cl_smp_app_140` | `sap.m.MultiComboBox` | see the near-duplicate note below |
| `z2ui5_cl_smp_app_258` | `sap.tnt.NavigationList` | own side-navigation layout (custom CSS, fixed items, toasts); 8 of 9 `SideNavigation`/`NavigationList` samples ported, the 9th (`SideNavigationSearch`) is a different sample and stays in the normal backlog |
| `z2ui5_cl_smp_app_270` | `sap.ui.unified.ColorPicker` | "Hello World" ColorPicker+Input form; all 4 samples ported (`_112`, `_268`, `_309`, `_310`) |
| `z2ui5_cl_smp_app_366` | `sap.m.Page` | own header/sub-header/footer composition with placeholder content; `sap.m.sample.Page` and `PageStandardClasses` ported (`_089`) |
| `z2ui5_cl_smp_app_367` | `sap.ui.layout.Grid` | own 12-column demo; **all 4** Grid samples ported (`_169`, `_194`, `_226`, `_345`). The first pass read the DESCRIPT's `sap.ui.Grid` literally, found no such entity and reported "entity covered: no" — a wrong verdict from a typo in the source data |
| `z2ui5_cl_smp_app_369` | `sap.m.ObjectNumber` | own table demo; the entity's single sample is ported (`_072`) and is a VerticalLayout, not a table |
| `z2ui5_cl_smp_app_374` | `sap.m.SplitContainer` | own master/detail demo; the entity's single sample is ported (`_096`) |
| `z2ui5_cl_smp_app_376` | `sap.m.TimePicker` | "Formats & Steps" — that is the base `sap.m.sample.TimePicker`, a **HOLDOUT**; `TimePickerHidden` ported (`_091`) |
| `z2ui5_cl_smp_app_377` | `sap.m.DateTimePicker` | "Value States" — `DateTimePickerValueState` is ported (`_255`), as are the other two |

**`_140` — the one open sample in this group, dropped on the near-duplicate
rule.** `sap.m.sample.MultiComboBox` is genuinely unported and not a hold-out,
but its view differs from the already-ported `sap.m.sample.MultiComboBoxSelectAll`
(`z2ui5_cl_dmo_app_281`) by **exactly one attribute** — `showSelectAll="true"` —
with the same two controller handlers and the same `/ProductCollection` binding.
AGENTS §1: skip true near-duplicates, a depth port that exercises nothing new is
corpus weight without training signal. It stays a normal backlog row, ranked by
the breadth-first rule like any other sample; it does not need a staged copy of
someone else's interpretation to be ported one day.

---

## Dropped — restricted (21 of 21)

"restricted - release/version" in the samples repo: needs a UI5 release newer
than 1.71, a control outside OpenUI5, or a runtime the sample cannot ship. None
of the three groups is portable here.

**SAPUI5-only controls (14)** — they belong in `src/03` / `src/04`, which are
declared but **closed** (AGENTS §3), and their libraries are not in the universe
snapshot at all (`ui5/universe.json` covers the ten OpenUI5 libraries). The
`@since` column is the class-level tag from the pinned `@sapui5/*` packages, so
it is the real release fact — and it puts every one of them in the `<= 1.71`
half, i.e. the release is never what blocks them.

| Sample class | Library | Control | class `@since` |
|---|---|---|---|
| `z2ui5_cl_smp_app_013` | `sap.suite.ui.microchart` | `InteractiveDonutChart` | 1.42 |
| `z2ui5_cl_smp_app_014` | `sap.suite.ui.microchart` | `InteractiveLineChart` | 1.42 |
| `z2ui5_cl_smp_app_016` | `sap.suite.ui.microchart` | `InteractiveBarChart` | 1.42 |
| `z2ui5_cl_smp_app_029` | `sap.suite.ui.microchart` | `RadialMicroChart` | 1.36 |
| `z2ui5_cl_smp_app_076` | `sap.gantt` | `GanttChartWithTable` | **DEPRECATED 1.64** |
| `z2ui5_cl_smp_app_091` | `sap.suite.ui.commons` | `ProcessFlow` | base (no tag) |
| `z2ui5_cl_smp_app_113` | `sap.suite.ui.commons` | `Timeline` | base (no tag) |
| `z2ui5_cl_smp_app_123` | `sap.ui.vbm / sap.ui.vk` | `AnalyticMap` | base (no tag) |
| `z2ui5_cl_smp_app_124` | `sap.ndc` | `BarcodeScannerButton` | base (no tag) |
| `z2ui5_cl_smp_app_179` | `sap.gantt` | `GanttChartContainer` | **DEPRECATED 1.64** |
| `z2ui5_cl_smp_app_182` | `sap.suite.ui.commons` | `networkgraph.Graph` | 1.50 |
| `z2ui5_cl_smp_app_196` | `sap.suite.ui.commons` | `statusindicator.StatusIndicator` | 1.50 |
| `z2ui5_cl_smp_app_308` | `sap.suite.ui.microchart` | `HarveyBallMicroChart` | 1.34 |
| `z2ui5_cl_smp_app_312` | `sap.viz + sap.ui.comp` | `VizFrame + filterbar.FilterBar` | 1.22 / base |

The two `sap.gantt` rows are out of scope by the **normal** rule, not by the
SAPUI5 question: both controls are class-deprecated since 1.64 in favour of
`sap.gantt.simple.*`, and ai-demokit never ports a deprecated control (AGENTS
§1). Taking them over would mean rebuilding on the successor — a different
sample.

**OpenUI5, restricted for other reasons (3)** — no demo kit original to rebuild,
so out of scope here whatever happens to `src/03`/`src/04`:

| Sample class | What |
|---|---|
| `z2ui5_cl_smp_app_002` | Demo App - Selection Screen — own demo app, no demo kit original |
| `z2ui5_cl_smp_app_085` | Demo App - Main-Detail Overview — own demo app, no demo kit original |
| `z2ui5_cl_smp_app_099` | ViewSettingsDialog - sort, group and filter a table — no demo kit original; ai-demokit covers `sap.m.ViewSettingsDialog` with five ports rebuilt from the originals (`_098`, `_295`, `_296`, `_297`, `_298`) |

**Launchpad runtime (4)** — they run inside a real Fiori Launchpad; there is no
demo kit sample behind them at all:

| Sample class | What |
|---|---|
| `z2ui5_cl_smp_app_481` | Launchpad - Read Startup Parameters |
| `z2ui5_cl_smp_app_482` | Launchpad - Set Shell Title (A) |
| `z2ui5_cl_smp_app_483` | Launchpad - Cross-App Navigation - Sender (A) |
| `z2ui5_cl_smp_app_484` | Launchpad - Cross-App Navigation - Receiver (A) |

---

## Provenance

| This folder held | Came from | samples CTEXT |
|---|---|---|
| `todo/restricted/` (21) | `samples/src/00/02` | restricted - release/version |
| `todo/control-library/` (27) | `samples/src/01/03/01` | controls - sap.m |
| `todo/control-library/` (1) | `samples/src/01/03/02` | controls - sap.uxap |
| `todo/control-library/` (1) | `samples/src/01/03/05` | controls - sap.ui.layout |
| `todo/control-library/` (2) | `samples/src/01/03/06` | controls - sap.tnt |
| `todo/control-library/` (1) | `samples/src/01/03/08` | controls - sap.ui.unified |

## If samples are imported again

The triage that worked, in order — the first two steps decide most rows on
facts, the third is where the one real find came from:

1. **Join the class' ABAP Doc URL on `<lib>.sample.<Name>`** against
   `meta/*.json` (ported) and `ui5/holdout.json` (never portable). Named +
   ported → drop; named + hold-out → drop.
2. **Check the entity's whole sample list** in `ui5/universe.json`, not just the
   one row: "entity covered" is not the question, "is *this* sample ported" is.
3. **Read the body of every class whose URL names only an entity.** That is
   where `_243` was hiding, and it is the only step a script cannot do for you.
   Compare against the demo kit originals of that entity — a match against an
   unported, non-hold-out, in-scope sample is a take-over; anything else is one
   of abap2UI5's own compositions and is dropped.
