# todo/ — imported samples awaiting a decision

A **staging area, not a package.** These are copies of abap2UI5 samples from
[abap2UI5/samples](https://github.com/abap2UI5/samples), parked here to be
triaged into ai-demokit ports — or dropped. Nothing in this folder is a port
yet: no `meta/` sidecar, no `ui5/` template, no gate runs over it.

It sits **outside `src/`** on purpose. `src/` is the abapGit / abaplint scope
(`STARTING_FOLDER=/src/`), so nothing here reaches a system, the linter or any
gate. A file leaves this folder by being **rebuilt** as a `z2ui5_cl_dmo_app_<n>`
port under `src/<category>/<library>/` — not by being moved.

> The classes are built on the framework's own `z2ui5_cl_xml_view` builder.
> ai-demokit ports use `z2ui5_cl_ai_xml` exclusively (AGENTS §5), so taking one
> over is a rewrite against the demo kit original, never a copy of the file.

Imported 53 classes on 2026-08-12: 21 from `src/00/02` ("restricted -
release/version") and 32 from `src/01/03` ("Control Library"). **52 left** — one
was taken over as a port and its file deleted (see the taken-over row below).

---

## control-library/ — 31 classes from samples `src/01/03`

1:1 rebuilds of UI5 demo kit samples, i.e. exactly what ai-demokit does — so
these are the direct-overlap candidates. The demo kit sample id comes from the
class' own ABAP Doc URL; where the URL points at an entity rather than a sample,
there is nothing to join on and the row says so.

### Taken over as a port (1)

| Sample class | Demo kit sample | ai-demokit port |
|---|---|---|
| `z2ui5_cl_smp_app_243` (deleted) | `sap.m.sample.StandardNegativeMarginsTwoSided` | `z2ui5_cl_dmo_app_403` |

Its ABAP Doc URL names only `sap.m.Text`, so the first triage filed it under
"URL names only the entity" and joined it to the (covered) `sap.m.Text` rows.
The **`<DESCRIPT>`** told the real story — `sap.m.Text - with class -Standard
Margins - Negative Margins` — and the class body is the demo kit sample
`sap.m.sample.StandardNegativeMarginsTwoSided` line for line: `Page
showHeader=false` + `Info` sub-header toolbar, then four `Panel`s carrying
`sapUi{Tiny,Small,Medium,Large}NegativeMarginBeginEnd`. That sample had no port
(entity `sap.ui.core.StandardMargins`, 1 of 7 samples ported), so it was
rebuilt against the demo kit original as `z2ui5_cl_dmo_app_403` and the file
here deleted. **Lesson for the remaining rows: the entity in `<DESCRIPT>` is
the control the class was filed under, not necessarily the sample it rebuilds —
read the class body before trusting an "entity covered" verdict.**

### Already covered by an ai-demokit port (14)

Same demo kit sample, already rebuilt here. Nothing to take over — the rows are
kept so the overlap is documented rather than rediscovered.

| Sample class | Demo kit sample | ai-demokit port |
|---|---|---|
| [`z2ui5_cl_smp_app_292`](control-library/z2ui5_cl_smp_app_292.clas.abap) | `sap.m.sample.BreadcrumbsWithCurrentPageLink` | `z2ui5_cl_dmo_app_286` |
| [`z2ui5_cl_smp_app_239`](control-library/z2ui5_cl_smp_app_239.clas.abap) | `sap.m.sample.CheckBox` | `z2ui5_cl_dmo_app_155` |
| [`z2ui5_cl_smp_app_283`](control-library/z2ui5_cl_smp_app_283.clas.abap) | `sap.m.sample.FeedInput` | `z2ui5_cl_dmo_app_236` |
| [`z2ui5_cl_smp_app_257`](control-library/z2ui5_cl_smp_app_257.clas.abap) | `sap.m.sample.GenericTag` | `z2ui5_cl_dmo_app_027` |
| [`z2ui5_cl_smp_app_293`](control-library/z2ui5_cl_smp_app_293.clas.abap) | `sap.m.sample.Link` | `z2ui5_cl_dmo_app_160` |
| [`z2ui5_cl_smp_app_110`](control-library/z2ui5_cl_smp_app_110.clas.abap) | `sap.m.sample.MaskInput` | `z2ui5_cl_dmo_app_153` |
| [`z2ui5_cl_smp_app_372`](control-library/z2ui5_cl_smp_app_372.clas.abap) | `sap.m.sample.MenuButton` | `z2ui5_cl_dmo_app_061` |
| [`z2ui5_cl_smp_app_291`](control-library/z2ui5_cl_smp_app_291.clas.abap) | `sap.m.sample.MessageStripWithEnableFormattedText` | `z2ui5_cl_dmo_app_062` |
| [`z2ui5_cl_smp_app_375`](control-library/z2ui5_cl_smp_app_375.clas.abap) | `sap.m.sample.NotificationListItem` | `z2ui5_cl_dmo_app_076` |
| [`z2ui5_cl_smp_app_300`](control-library/z2ui5_cl_smp_app_300.clas.abap) | `sap.m.sample.ObjectStatus` | `z2ui5_cl_dmo_app_042` |
| [`z2ui5_cl_smp_app_022`](control-library/z2ui5_cl_smp_app_022.clas.abap) | `sap.m.sample.ProgressIndicator` | `z2ui5_cl_dmo_app_070` |
| [`z2ui5_cl_smp_app_207`](control-library/z2ui5_cl_smp_app_207.clas.abap) | `sap.m.sample.RadioButton` | `z2ui5_cl_dmo_app_069` |
| [`z2ui5_cl_smp_app_209`](control-library/z2ui5_cl_smp_app_209.clas.abap) | `sap.tnt.sample.InfoLabel` | `z2ui5_cl_dmo_app_113` |
| [`z2ui5_cl_smp_app_330`](control-library/z2ui5_cl_smp_app_330.clas.abap) | `sap.uxap.sample.ObjectPageSectionShowTitle` | `z2ui5_cl_dmo_app_200` |

### Open — no ai-demokit port for this sample (17)

"Entity covered" = ai-demokit already has a port of the same control from a
*different* demo kit sample. That is the near-duplicate check the batch planning
rules ask for (AGENTS §1: breadth first, depth only for a new idiom) — a covered
entity means the row needs a reason beyond "not ported yet".

The entity column is read off the `<DESCRIPT>` convention `<entity> - <text>`, so
it is a hint, not a verified fact — confirm with `node scripts/scope-of.mjs <entity>`
before acting on a row.

**Every named sample in this table is a HOLDOUT** (`ui5/holdout.json`): `Label`,
`RadioButtonGroup`, `BusyIndicator`, `RatingIndicator`, `MessageStrip`,
`SearchField`. So the three rows the table marks "entity covered: **no**" — the
ones that read like the strongest candidates — are exactly the ones that must
**not** be ported: the hold-out set is regenerated from scratch to measure the
generator (TRAINING.md), and `scaffold.mjs` refuses them. The rows worth a
second look are the *unnamed* ones: their URL names only the entity, so — as
`z2ui5_cl_smp_app_243` showed — the class may still rebuild a specific, unported
demo kit sample that no join could find.

| Sample class | Demo kit sample | Entity (from DESCRIPT) | Entity covered here |
|---|---|---|---|
| [`z2ui5_cl_smp_app_005`](control-library/z2ui5_cl_smp_app_005.clas.abap) | — (URL names only the entity) | `sap.m.RangeSlider` | yes — 1 port(s): `z2ui5_cl_dmo_app_045` |
| [`z2ui5_cl_smp_app_051`](control-library/z2ui5_cl_smp_app_051.clas.abap) | `sap.m.sample.Label` | `sap.m.Label` | yes — 1 port(s): `z2ui5_cl_dmo_app_058` |
| [`z2ui5_cl_smp_app_114`](control-library/z2ui5_cl_smp_app_114.clas.abap) | — (URL names only the entity) | `sap.m.FeedInput` | yes — 2 port(s): `z2ui5_cl_dmo_app_024`, `z2ui5_cl_dmo_app_236` |
| [`z2ui5_cl_smp_app_140`](control-library/z2ui5_cl_smp_app_140.clas.abap) | — (URL names only the entity) | `sap.m.MultiComboBox` | yes — 3 port(s): `z2ui5_cl_dmo_app_039`, `z2ui5_cl_dmo_app_281`, `z2ui5_cl_dmo_app_385` |
| [`z2ui5_cl_smp_app_208`](control-library/z2ui5_cl_smp_app_208.clas.abap) | `sap.m.sample.RadioButtonGroup` | `sap.m.RadioButtonGroup` | **no** |
| [`z2ui5_cl_smp_app_215`](control-library/z2ui5_cl_smp_app_215.clas.abap) | `sap.m.sample.BusyIndicator` | `sap.m.BusyIndicator` | **no** |
| [`z2ui5_cl_smp_app_220`](control-library/z2ui5_cl_smp_app_220.clas.abap) | `sap.m.sample.RatingIndicator` | `sap.m.RatingIndicator` | **no** |
| [`z2ui5_cl_smp_app_238`](control-library/z2ui5_cl_smp_app_238.clas.abap) | `sap.m.sample.MessageStrip` | `sap.m.MessageStrip` | yes — 2 port(s): `z2ui5_cl_dmo_app_062`, `z2ui5_cl_dmo_app_289` |
| [`z2ui5_cl_smp_app_296`](control-library/z2ui5_cl_smp_app_296.clas.abap) | `sap.m.sample.SearchField` | `sap.m.SearchField` | yes — 1 port(s): `z2ui5_cl_dmo_app_090` |
| [`z2ui5_cl_smp_app_366`](control-library/z2ui5_cl_smp_app_366.clas.abap) | — (URL names only the entity) | `sap.m.Page` | yes — 1 port(s): `z2ui5_cl_dmo_app_089` |
| [`z2ui5_cl_smp_app_369`](control-library/z2ui5_cl_smp_app_369.clas.abap) | — (URL names only the entity) | `sap.m.ObjectNumber` | yes — 1 port(s): `z2ui5_cl_dmo_app_072` |
| [`z2ui5_cl_smp_app_374`](control-library/z2ui5_cl_smp_app_374.clas.abap) | — (URL names only the entity) | `sap.m.SplitContainer` | yes — 1 port(s): `z2ui5_cl_dmo_app_096` |
| [`z2ui5_cl_smp_app_376`](control-library/z2ui5_cl_smp_app_376.clas.abap) | — (URL names only the entity) | `sap.m.TimePicker` | yes — 1 port(s): `z2ui5_cl_dmo_app_091` |
| [`z2ui5_cl_smp_app_377`](control-library/z2ui5_cl_smp_app_377.clas.abap) | — (URL names only the entity) | `sap.m.DateTimePicker` | yes — 3 port(s): `z2ui5_cl_dmo_app_018`, `z2ui5_cl_dmo_app_255`, `z2ui5_cl_dmo_app_257` |
| [`z2ui5_cl_smp_app_367`](control-library/z2ui5_cl_smp_app_367.clas.abap) | — (URL names only the entity) | `sap.ui.Grid` | **no** |
| [`z2ui5_cl_smp_app_258`](control-library/z2ui5_cl_smp_app_258.clas.abap) | — (URL names only the entity) | `sap.tnt.NavigationList` | yes — 1 port(s): `z2ui5_cl_dmo_app_123` |
| [`z2ui5_cl_smp_app_270`](control-library/z2ui5_cl_smp_app_270.clas.abap) | — (URL names only the entity) | `sap.ui.unified.ColorPicker` | yes — 3 port(s): `z2ui5_cl_dmo_app_112`, `z2ui5_cl_dmo_app_309`, `z2ui5_cl_dmo_app_310` |

---

## restricted/ — 21 classes from samples `src/00/02`

"restricted - release/version" in the samples repo: needs a UI5 release newer
than 1.71, a control outside OpenUI5, or a runtime the sample cannot ship. Three
groups, and only the first is a candidate for this repo.

**SAPUI5-only controls** — would belong in `src/03` / `src/04`, which are not open
(AGENTS §3 names the three gaps). The `@since` column is the class-level tag read
from the pinned `@sapui5/*` packages, so it is the real release fact, and it puts
every one of them in the `<= 1.71` half.

| Sample class | Library | Control | class `@since` |
|---|---|---|---|
| [`z2ui5_cl_smp_app_013`](restricted/z2ui5_cl_smp_app_013.clas.abap) | `sap.suite.ui.microchart` | `InteractiveDonutChart` | 1.42 |
| [`z2ui5_cl_smp_app_014`](restricted/z2ui5_cl_smp_app_014.clas.abap) | `sap.suite.ui.microchart` | `InteractiveLineChart` | 1.42 |
| [`z2ui5_cl_smp_app_016`](restricted/z2ui5_cl_smp_app_016.clas.abap) | `sap.suite.ui.microchart` | `InteractiveBarChart` | 1.42 |
| [`z2ui5_cl_smp_app_029`](restricted/z2ui5_cl_smp_app_029.clas.abap) | `sap.suite.ui.microchart` | `RadialMicroChart` | 1.36 |
| [`z2ui5_cl_smp_app_076`](restricted/z2ui5_cl_smp_app_076.clas.abap) | `sap.gantt` | `GanttChartWithTable` | **DEPRECATED 1.64** |
| [`z2ui5_cl_smp_app_091`](restricted/z2ui5_cl_smp_app_091.clas.abap) | `sap.suite.ui.commons` | `ProcessFlow` | base (no tag) |
| [`z2ui5_cl_smp_app_113`](restricted/z2ui5_cl_smp_app_113.clas.abap) | `sap.suite.ui.commons` | `Timeline` | base (no tag) |
| [`z2ui5_cl_smp_app_123`](restricted/z2ui5_cl_smp_app_123.clas.abap) | `sap.ui.vbm / sap.ui.vk` | `AnalyticMap` | base (no tag) |
| [`z2ui5_cl_smp_app_124`](restricted/z2ui5_cl_smp_app_124.clas.abap) | `sap.ndc` | `BarcodeScannerButton` | base (no tag) |
| [`z2ui5_cl_smp_app_179`](restricted/z2ui5_cl_smp_app_179.clas.abap) | `sap.gantt` | `GanttChartContainer` | **DEPRECATED 1.64** |
| [`z2ui5_cl_smp_app_182`](restricted/z2ui5_cl_smp_app_182.clas.abap) | `sap.suite.ui.commons` | `networkgraph.Graph` | 1.50 |
| [`z2ui5_cl_smp_app_196`](restricted/z2ui5_cl_smp_app_196.clas.abap) | `sap.suite.ui.commons` | `statusindicator.StatusIndicator` | 1.50 |
| [`z2ui5_cl_smp_app_308`](restricted/z2ui5_cl_smp_app_308.clas.abap) | `sap.suite.ui.microchart` | `HarveyBallMicroChart` | 1.34 |
| [`z2ui5_cl_smp_app_312`](restricted/z2ui5_cl_smp_app_312.clas.abap) | `sap.viz + sap.ui.comp` | `VizFrame + filterbar.FilterBar` | 1.22 / base |

The two `sap.gantt` rows are **out of scope by the normal rule**, not by the
SAPUI5 question: both controls are class-deprecated since 1.64 in favour of
`sap.gantt.simple.*`, and ai-demokit never ports a deprecated control (AGENTS §1).
Taking them over means rebuilding on the successor, which is a different sample.

**OpenUI5, restricted for other reasons** — no demo kit original to rebuild, so
out of scope here whatever happens to `src/03`/`src/04`:

| Sample class | What |
|---|---|
| [`z2ui5_cl_smp_app_002`](restricted/z2ui5_cl_smp_app_002.clas.abap) | Demo App - Selection Screen — own demo app, no demo kit original |
| [`z2ui5_cl_smp_app_085`](restricted/z2ui5_cl_smp_app_085.clas.abap) | Demo App - Main-Detail Overview — own demo app, no demo kit original |
| [`z2ui5_cl_smp_app_099`](restricted/z2ui5_cl_smp_app_099.clas.abap) | ViewSettingsDialog - sort, group and filter a table — ViewSettingsDialog, no demo kit original |

`z2ui5_cl_smp_app_099` is the clearest of these: ai-demokit already covers
`sap.m.ViewSettingsDialog` with five ports (`z2ui5_cl_dmo_app_098`, `_295`, `_296`,
`_297`, `_298`), all rebuilt from the demo kit originals.

**Launchpad runtime** — run inside a real Fiori Launchpad; there is no demo kit
sample behind them at all:

| Sample class | What |
|---|---|
| [`z2ui5_cl_smp_app_481`](restricted/z2ui5_cl_smp_app_481.clas.abap) | Launchpad - Read Startup Parameters |
| [`z2ui5_cl_smp_app_482`](restricted/z2ui5_cl_smp_app_482.clas.abap) | Launchpad - Set Shell Title (A) |
| [`z2ui5_cl_smp_app_483`](restricted/z2ui5_cl_smp_app_483.clas.abap) | Launchpad - Cross-App Navigation - Sender (A) |
| [`z2ui5_cl_smp_app_484`](restricted/z2ui5_cl_smp_app_484.clas.abap) | Launchpad - Cross-App Navigation - Receiver (A) |

---

## Provenance

| This folder | Came from | samples CTEXT |
|---|---|---|
| `todo/restricted/` | `samples/src/00/02` (21) | restricted - release/version |
| `todo/control-library/` | `samples/src/01/03/01` (27) | controls - sap.m |
| `todo/control-library/` | `samples/src/01/03/02` (1) | controls - sap.uxap |
| `todo/control-library/` | `samples/src/01/03/05` (1) | controls - sap.ui.layout |
| `todo/control-library/` | `samples/src/01/03/06` (2) | controls - sap.tnt |
| `todo/control-library/` | `samples/src/01/03/08` (1) | controls - sap.ui.unified |

The samples repo keeps its copies — this is an import for triage, not a move.
Delete a file here once its decision is made: rebuilt as a port, or dropped with
the reason recorded in the table above.
