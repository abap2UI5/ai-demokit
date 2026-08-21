# AGENTS.md — samples-controls

Single source of truth for agents working on **abap2UI5 samples-controls** (formerly ai-demokit).

> These instructions OVERRIDE any default behavior and must be followed exactly.
> This entire project is in **English** — code, comments, commit messages, PRs.

> **Core principle — abap2UI5 is a THIN FRONTEND.** As much logic as possible
> lives in the **ABAP backend**; the frontend only renders and forwards events.
> **Never put business logic in the frontend** — no computation, unit
> conversion, thresholds, classification or validation in a frontend formatter,
> expression binding or custom JS. Compute the result in ABAP and bind the
> finished value. When a UI5 sample does such logic in its `Formatter.js`, the
> faithful abap2UI5 port moves it to `model_init` and declares the difference —
> a *more* correct architecture, not a deviation from intent (apps
> 009/010/022/092).
>
> **The curated formatter module is not the escape hatch.** It exports exactly
> four functions — `DateCreateObject`, `DateAbapDateToDateObject`,
> `DateAbapDateTimeToDateObject`, `expandInlineIcons` — because those are the
> only two things the backend physically cannot produce: a JS `Date` for an
> object-typed property, and an icon-font glyph of the loaded theme. Everything
> else, *including* rounding a number, joining fields into a string and mapping
> a business status to a `ValueState`/icon, is computed in ABAP and bound
> (`state="{WEIGHT_STATE}"`). Those five were shipped once and removed again;
> the linter rule `uncurated-formatter` (moved from pattern-lint 2026-08-04,
> gated here via `view_gates`) fails any binding naming a function outside
> the four, because UI5 resolves an unknown name to nothing and the cell just
> renders blank.

---

## Task guides — read on demand

The step-by-step procedure for each recurring task lives in a guide under
`.claude/skills/` — Claude Code auto-loads them as skills; every other agent
reads the files directly. **Read the matching guide BEFORE starting the task**
— this file keeps only what every session must know up front:

| Task | Guide |
|---|---|
| Write, change or review a port (recipe, binding, events, deviations) | `.claude/skills/port-a-sample/SKILL.md` |
| A construct the recipe doesn't cover 1:1 (named model, typed binding, popup, fragment, …) | `.claude/skills/idiom-lookup/SKILL.md` |
| A gate failed / declare a skip or deviation for a gate | `.claude/skills/run-the-gates/SKILL.md` |
| Plan the next batch / scaffold a new port | `.claude/skills/scaffold-a-port/SKILL.md` |
| Touch a generator, a generated artefact, or the meta/ shape they read | `.claude/skills/regenerate-artefacts/SKILL.md` |
| Run or debug the e2e smoke (Playwright) | `.claude/skills/e2e-debugging/SKILL.md` |
| Settle a claim by MEASURING it, or sweep the corpus for a defect no gate sees | `scripts/probes/README.md` |

**Large files — grep them, never read them whole:** `api.md` (~316 KB
generated table), `docs/history.md` (~330 KB journal), `CAPABILITIES.md`
(~45 KB — grep for the feature row),
`scripts/generate-overview.mjs` (~58 KB),
`src/z2ui5_cl_smpc_app_000.clas.abap` (generated). (The e2e
interactions live as one module per port under `meta/interactions/` —
read only the port you work on.)

---

## 1. Mission — an automated repository

This repo exists to **clone every official UI5 demo kit sample and independently
rebuild it as an abap2UI5 sample**. Doing that systematically reveals the gaps
between what UI5 ships and what abap2UI5 can already express — and those gaps
become the backlog to close.

**Porting scope**: a sample is in scope when its **control exists since UI5
1.71** and is **not deprecated** in the current release (legacy-free ready) —
computed per sample from `ui5/universe.json` by `generate-coverage.mjs`
(`scopeOf`). Out-of-scope samples stay listed in `api.md` (marked `✗`) but are
**never ported**; `node scripts/generate-coverage.mjs --backlog` prints the
in-scope, unported samples for batch planning.

**Second scope rule — the sample must be an app view** (maintainer decision).
A control can be perfectly 1.71-clean while the sample is not a UI at all:
UI5's own **test infrastructure** (`sap.ui.test.*` — OPA5, gherkin, matcher
demos are QUnit pages), **Component routing** across several views/targets
(`sap.ui.core.routing.*` — an abap2UI5 app serves one view per round-trip),
the **view-type / XML-templating / XMLComposite authoring** demos (`View.*`,
`ViewTemplate.*`, `XMLComposite.*` — they demonstrate how a view is produced,
not a UI to rebuild), and `sap.ui.core.mvc.ControllerExtension` (abap2UI5 has
no frontend controller to extend). These families are listed in
`ui5/scope-nonapp.json` with a per-family reason and are **out of scope**:
`scopeOf` returns `nonapp`, `--backlog` never offers them, `api.md` marks them
`✗`, and `scripts/scope-of.mjs --sample <Name>` reports them
`OUT_OF_SCOPE (not an app view — …)`. The two verdicts must stay identical:
`scope-of.mjs` applies `ui5/entity-overrides.json` and evaluates the non-app
family **before** the control has to resolve in the fork checkout
(`ControllerExtension` carries `entity: null` in the universe and would
otherwise report `UNRESOLVED`). Adding a family is a maintainer decision —
write the reason into the file; a ported sample that matches hits the same
hard scope gate as a deprecated/newer one.

> **⚠️ Verify scope from source before porting.** The gate is not blind:
> `ui5/properties.json` carries each control's class-level
> `@since`/`@deprecated` (parsed from the OpenUI5 sources by the **linter's**
> `generate-metadata.mjs`, run from `generate-result`), and `scopeOf` in
> `generate-coverage.mjs` falls
> back to it when `ui5/universe.json` carries null — so out-of-scope samples
> surface offline in coverage/backlog. The check is a **hard gate**:
> `generate-coverage.mjs` exits 1 on any ported out-of-scope sample without a
> maintainer-decided entry in `ui5/scope-exceptions.json`. Each exception
> entry **pins the scope facts the decision was made on** (`decided`: scope
> verdict, control `@since`, deprecation `@since`); stale entries fail, and so
> does an entry whose pinned facts a metadata refresh has changed — the list
> can only shrink honestly, and a decision cannot silently outlive its
> rationale. **Still run `node scripts/scope-of.mjs <entity>` (or
> `--sample <Name>`) before porting** — it is the authoritative per-entity
> pre-check straight from the source JSDoc and also covers controls a stale
> `properties.json` might miss. A neighbour port existing is **not** proof of
> scope (see the UploadSet/SidePanel debt in STATUS.md).


**Batch planning is breadth-first, then idiom-first depth** — one sample per
uncovered control first; depth only once every in-scope control has a port,
picked for a new idiom, never a near-duplicate. The full planning rules
(`--backlog` sorting, HOLDOUT rows, GROUP-nested samples) are in the
`scaffold-a-port` guide — read it before planning or starting a batch.

The pipeline (run by a coding agent):

1. **Read** — clone [OpenUI5](https://github.com/SAP/openui5), scan every demo
   kit sample at `src/<library>/test/<library path>/demokit/sample/<Name>/`
   (second segment with dots as slashes, e.g. `src/sap.tnt/test/sap/tnt/…`).
2. **Generate** — rebuild each sample 1:1 as an abap2UI5 app (a class
   implementing `z2ui5_if_app`), filed by library under `src/`.
3. **Store templates** — keep the untouched original UI5 JS/XML templates in the
   `ui5/` folder.
4. **Report** — regenerate the coverage (`README.md` summary + `api.md`) and the
   in-system overview app: every sample marked ✅ ported / ❌ missing, with a
   coverage figure per module.

Everything here is machine-generated and carries the "not yet manually
reviewed" marker (§5).

**This repository is the home of the pure control samples** (maintainer
decision, 2026-08-12). The curated
[abap2UI5/samples](https://github.com/abap2UI5/samples) repo used to keep its
own 1:1 demo kit rebuilds under `src/01/03`; 78 of those were the same
originals this repo covers, and that redundancy was removed by porting the
missing half here (apps 367–402) and dropping all 78 there. So the flow is no
longer "curated samples graduate out of this repo" for demo kit rebuilds —
those stay here, and only three kinds remain in the samples repo: a **1.71-safe
variant** of a sample whose port here declares `POST_171` (that repo is
downported to 702), a sample in our **hold-out set** (`ui5/holdout.json`), and
a **free-style control demo** with no single demo kit original. A `checked`
port here is still the reviewed artifact; it just no longer moves.

---

## 2. Layout — two trees in one branch

Everything lives on the working branch, in separate top-level trees:

| Path    | Content |
|---------|---------|
| `src/`  | The generated abap2UI5 ports (`*.clas.abap`) — the abapGit project (§3). |
| `ui5/`  | The original UI5 demo kit templates (JS/XML/manifest), one folder per ported sample (§4). |

Keep them separate: only `src/` is the abapGit / abaplint scope; `ui5/` is
plain JS/XML held for reference and to feed the generator. Everything else at
the root is documentation or tooling, not a tree the pipeline reads: `meta/`
(one sidecar per port, plus the e2e interaction modules), `scripts/` (the
generators and gates), `web/` (the GitHub Pages site - `web/search/` IS the
published catalogue, three static files plus a generated index; the transpiled
in-browser demo that used to live here was removed 2026-08-19, and `web/ci/`
keeps the two patch scripts `scripts/e2e-build.mjs` and abap2UI5/mcp-server
still execute) and `docs/` (the journal and the upstream-request record).

**There is no `todo/` staging tree any more** — deleted 2026-08-12
(`f9afe94`), so `git ls-files` shows nothing under it. It was the staging area
for samples imported from
[abap2UI5/samples](https://github.com/abap2UI5/samples): 53 of them arrived on
2026-08-12 (the `src/00/02` "restricted" set and the `src/01/03` "Control
Library" set) and were all triaged the same day — 1 rebuilt as a port
(`z2ui5_cl_smpc_app_403`), 14 collected in `src/03` (the SAPUI5-only ones), 38
dropped. Its per-sample decision table survives in the **git history**
(`todo/README.md` at commit `37e77b6`); read it there before re-importing, so
the same 53 classes are not re-analysed. The summary of it is in the journal
([docs/history.md](docs/history.md), 2026-08-12). Nothing there was ever a
port: no `meta/` sidecar, no `ui5/` template, and no gate walked it
(`STARTING_FOLDER=/src/`, abaplint globs `/src/**`), so nothing there could
reach a system.

Should samples be imported again, stage them wherever is convenient outside
`src/` and apply the same rules. A file leaves staging by being **rebuilt** as
a `z2ui5_cl_smpc_app_<n>` port under
`src/<category>/<library>/`, never by being moved: the samples are built on the
framework's `z2ui5_cl_xml_view`, ports use `z2ui5_cl_ui5_view_builder` (§5), and a port is
a 1:1 rebuild of the *demo kit original*, not of another repo's interpretation of
it. Delete a file there once its decision is made — ported, or dropped with the
reason recorded in the journal. Three traps that decided rows last time: the
entity in `<DESCRIPT>` is the control the class was *filed under*, not
necessarily the sample it *rebuilds* (read the body of every class whose URL
names only an entity — that is where the one take-over was hiding); a
hold-out sample (`ui5/holdout.json`) must never be ported however uncovered its
control looks; and an unported sample that differs from a ported one by a single
attribute is a near-duplicate to skip (§1), not a take-over.

---

## 3. Repository layout — the ABAP ports

abapGit project, `FOLDER_LOGIC=PREFIX`, `STARTING_FOLDER=/src/`. A port's path is

```
src/<category>/<library>/<class>.clas.abap
```

**Level 1 — the category: what a system needs to run the port** (UI5 flavour x
release). This is the level an installer cares about: everything in `src/01`
runs on the oldest supported stack, and each further folder raises exactly one
requirement.

| Folder   | CTEXT (`package.devc.xml`) | Runs on | Status |
|----------|----------------------------|---------|--------|
| `src/01` | `OpenUI5 <= 1.71` | any OpenUI5/SAPUI5 from 1.71 on — the portable half | ports |
| `src/02` | `OpenUI5 > 1.71`  | needs a UI5 runtime newer than 1.71 | ports |
| `src/03` | `SAPUI5-only controls - collection` | needs SAPUI5 (a library OpenUI5 does not ship) | samples, **not** ports — see below |

The per-folder counts are **not** written here: they change with every batch,
and [`STATUS.md`](STATUS.md) carries the generated live ones (`Ports` row) with
the per-library split beside them.

**Level 2 — the library** of the demo kit sample, numbered once and globally: a
library keeps the same number in every category folder, so `src/01/01` and
`src/02/01` are both `sap.m`. It applies to the two **port** folders only;
`src/03` is flat, because a collection has nothing to derive a path from.

| Folder | CTEXT | Library namespace |
|--------|-------|-------------------|
| `01` | `sap.m`     | `sap.m` |
| `02` | `sap.ui`    | `sap.ui.*` (core, layout, unified, table, integration, codeeditor, model.type) |
| `03` | `sap.uxap`  | `sap.uxap` |
| `04` | `sap.f`     | `sap.f` |
| `05` | `sap.tnt`   | `sap.tnt` |
| `06` | `sap.suite` | `sap.suite.*` — SAPUI5 only, unused (the collection is flat) |
| `07` | `sap.viz`   | `sap.viz` — SAPUI5 only, unused |
| `08` | `sap.gantt` | `sap.gantt` — SAPUI5 only, unused |
| `09` | `sap.ndc`   | `sap.ndc` — SAPUI5 only, unused |

The library split key is the **second-level namespace of the sample**
(`sap.m.sample.ContainerNoPadding` → `sap.m`), the same key
`generate-overview.mjs` / `generate-coverage.mjs` group by. It is deliberately
*not* the entity's namespace: that sample documents a `sap.ui.core` CSS-class
entity and still belongs to sap.m. New libraries get the next free number in
`scripts/lib-packages.mjs` plus a `package.devc.xml` with the matching CTEXT;
06–09 are pre-assigned but only created once a port lands in them.

**Both levels are derived, not chosen.** `scripts/lib-packages.mjs` computes the
whole path — the library from the sidecar's `sample`, the flavour from the
libraries the port touches, the release from whether the port needs a runtime
newer than 1.71 — and `validate-meta` fails when a file sits anywhere else,
naming the folder it belongs in. A port needs a newer runtime in two ways, and
both are committed facts, so the verdict is offline and deterministic:

- it **keeps a post-1.71 member** — always a `POST_171` deviation in the sidecar;
- its **control itself is post-1.71** — which needs no deviation (the sample uses
  the control as the original does) and can only exist as a maintainer-decided
  entry in `ui5/scope-exceptions.json`, since the scope gate blocks every other
  post-1.71 control. That entry pins the control's `@since`, which is what
  `lib-packages.mjs` reads (app 141, `sap.ui.core.InvisibleMessage` @1.78, is
  the case with no deviation at all).

So **declaring the first `POST_171` deviation on a port moves it from
`src/01/<lib>/` to `src/02/<lib>/`** (and dropping the last one moves it back);
`scaffold.mjs` starts every fresh port in the `<= 1.71` half of its flavour,
which is where a port with no deviations belongs.

Below the library there is **no further level**: the former batch subpackages
`src/<NN>/b<nn>/` were flattened away (2026-08-12): 67 packages for 365 ports,
20 of them holding a single class, most of them carrying the CTEXT
`faithful ports`. A batch is a property of the generation run, not of the port,
so it stays where it belongs — in the port's `meta/<class>.json` as the `batch`
field. It is **not derivable from the path**; `scaffold.mjs` reads the next
batch number back from the sidecars of the library, across both of that
library's category folders. One batch is still one PR — see TRAINING.md for the
batch process — it is just not one package.

Because `FOLDER_LOGIC=PREFIX`, class names never encode the folder — moving a
class between folders needs no rename.

### SAPUI5 — `src/03` collects, it does not port

**1:1 porting is for OpenUI5 only.** Every port in this repo rebuilds an
OpenUI5 demo kit sample against its archived original, and that is what the two
port folders (`src/01`, `src/02`) hold. A control that ships with SAPUI5 only
(`sap.suite.*`, `sap.viz.*`, `sap.gantt.*`, `sap.ndc`, `sap.ui.comp`,
`sap.ui.vbm`/`.vk`) cannot be ported that way, for one blunt reason: **there is
no original to rebuild against**. SAPUI5 is not on GitHub, and the public
`@sapui5/*` npm packages ship `src/` and nothing else — no `demokit/sample`
tree — so `ui5/<lib>/<Name>/` cannot be filled and `structural_diff` has
nothing to compare. (Trying to close that gap was reverted with this section:
the templates would have to come from the SDK web app, which no offline,
reproducible pipeline can rely on.)

**`src/03` is the answer instead: a collection, not a package of ports.** It
holds hand-written abap2UI5 samples for SAPUI5-only controls — how the control
is expressed with the framework, as orientation.

> **Which repository a SAPUI5-only control belongs in.** Being SAPUI5-only
> puts a control here *or* in
> [samples-stack](https://github.com/abap2UI5/samples-stack), and the question
> that decides it is **what the sample needs besides the runtime**:
>
> - it renders from a **bound ABAP table and nothing else** — a chart, a micro
>   chart, a network graph, a map, a barcode button — so the class is
>   self-contained and installable anywhere → **here, `src/03`**;
> - it needs a **system artefact**: OData metadata, an annotation, a CDS view,
>   a service binding, an RAP object, a launchpad → **samples-stack**, where a
>   sample may assume a backend and ships those artefacts with it.
>
> That is why every `sap.ui.comp` sample lives in `samples-stack/src/02`
> ("Smart Controls") and none here: a SmartTable / SmartFilterBar / SmartField
> reads its columns, its filters and its value help **from the service's
> metadata**, so with no OData service it has nothing to render. A
> `sap.ui.comp` XML namespace declared in a class here (app 012 declares
> `xmlns:fb`) is not a counter-example — a declared prefix is not a used
> control. `abap2ui5lint-collection.jsonc` named `sap.ui.comp` as part of this
> folder's scope until 2026-08-18; it was never true.

A knowledge store, so:

- **flat** (`src/03/<class>.clas.abap`), because there is no path to derive:
  no library level, and no `<= 1.71` / `> 1.71` split — that split is a porting
  concern about which runtime a *rebuild* needs. `src/04` was deleted with it;
- **no `meta/<class>.json` sidecar, no `ui5/` template, no coverage row.** The
  AI machinery does not touch it and must not: `validate-meta`'s port detector
  matches `src/<cc>/<ll>/` (two numeric levels), and `structural_diff`,
  `data_fidelity`, `view_gates`, the overview app and the coverage tables are
  all sidecar-driven. A class here is invisible to every one of them **by
  construction**, not by an exclusion list that could rot;
- **the VIEW check is not part of that**, and `npm run check:collection` is it
  (`abap2ui5lint-collection.jsonc`, run in `view-gates.yaml` and in `gates:full`).
  Being outside the *port* machinery is a decision about `structural_diff` and
  friends; whether the view a class builds is one UI5 can load is a question
  that applies to every abap2UI5 class in the repository, exactly as `abaplint`
  and `pattern-lint` do. Property gate only — the render gate serves the
  OpenUI5 runtime and these controls ship with SAPUI5 alone, so there is no
  build that could load them. The 1.71 rules run as **hints** here (a
  collection sample is not a port and the §3 split does not apply) and the
  demo-kit hyperlink is exempt from `commercial-ui5-host` for the same reason
  the assets are exempt from `data_fidelity`;
- **classes are `z2ui5_cl_smpc_sapui5_<nnn>`**, in the samples style (dispatch
  inline on `CASE client->get_event( ).`). They were written on the framework's
  own `z2ui5_cl_xml_view` and were **migrated to `z2ui5_cl_ui5_view_builder` on
  2026-08-15**: `z2ui5_cl_xml_view` is frozen legacy in `src/99` that abap2UI5's
  own removal plan wants gone, these 14 were the last classes anywhere in the
  ecosystem still using it, and — the reason that decided it — *no view check
  can read it*. The linter reconstructs the current builder and answered
  "no checkable app classes under src/03"; the collection was the only ABAP in
  this repository nothing looked at;
- **ABAP hygiene still applies.** `abaplint` and `pattern-lint` walk all of
  `src/`, and the collection is held to them like any other ABAP in this repo:
  no commented-out code, `ty_`/`ty_s_`/`ty_t_` types, explicit `EMPTY KEY`, no
  dead event wires. The samples came in with 52 such findings; they were fixed,
  not suppressed;
- **each class carries an ABAP Doc header** naming the control, why it is
  collected rather than ported, and its SAPUI5 demo kit link. A **deprecated**
  control says so there — it is collected as a record of the control, never as
  a recommendation (`RadialMicroChart` @1.135, both `sap.gantt` @1.64).

Assets are the one place the collection diverges from a repo rule on purpose:
`data_fidelity` forbids a non-OpenUI5 host for a *port*'s assets (§6), and the
SAPUI5 samples legitimately load their images from `ui5.sap.com/test-resources`
— there is no OpenUI5 equivalent. The gate never sees them (no sidecar), which
is the correct outcome, not a loophole.

`scripts/scope-of.mjs` reports a SAPUI5-only control as
`OUT_OF_SCOPE (SAPUI5-only library — no 1:1 port, collect it in src/03 instead)`
plus its release facts, and reads them from the pinned `@sapui5/*` packages
(eight of them, at 1.151.0) — so a control's `@since` / `@deprecated` is still
answerable offline and reproducibly, which is what decides whether collecting it
is worth it at all.

---

## 4. The `ui5/` folder — original templates

Every port's source template is collected under `ui5/`. **The template folder is
named after the sample**, filed by source library:

```
ui5/<library>/<SampleName>/   ← original Component.js, *.view.xml,
                                  manifest.json, controllers, resources
```

The join key between a port (`src/`) and its template is `meta/<class>.json` →
`sample`. Only **ported** samples are archived: each generation batch copies
its samples over from the OpenUI5 checkout when the batch is generated — the
full sample universe is not mirrored here. Templates are held verbatim — never
edited to fit ABAP; that is the generator's job. `ui5/` is the generator's
local input store; the `api.md` **Sample** column links to the sample's
source in the upstream
[OpenUI5 repository](https://github.com/SAP/openui5), not to this copy (§7).

Archive **everything** the sample's `manifest.json` lists under `sap.ui5 >
config > sample > files` (resolving `../<OtherSample>/` references), or fidelity
cannot be verified offline — app 022 was missing its controller and table for a
while. Shared demo kit mock data (`sap/ui/demo/mock/*.json`) is snapshotted once
under `ui5/mock/` (see its README for provenance); upstream it lives in the
[UI5/openui5](https://github.com/UI5/openui5) repository (the SAP/openui5 URLs
redirect) at `src/sap.ui.documentation/test/sap/ui/documentation/sdk/`.

**Exception — the `sap.uxap` `SharedBlocks` templates stay unarchived.** The
uxap manifests **over-list**: they name the whole `../SharedBlocks/` set
regardless of what the view actually instantiates. `structural-diff` resolves
manifest-listed `../<OtherSample>/*.view.xml` paths, so archiving
`ui5/sap.uxap/SharedBlocks/` feeds it block views the sample never renders and
it then demands phantom controls (`layout:Grid`/`GridData`/`VerticalLayout`)
from correct ports. So uxap block templates stay out of `ui5/`, and the
BlockBase inlining is declared in each sidecar instead
(apps 161/187/188/217/258–263).

---

## 5. Generation rules

**Port classes carry no ABAP Doc header** — the class starts directly with
`CLASS ... DEFINITION` (pattern-lint enforces this). Everything that identifies
and annotates a port lives in its sidecar **`meta/<class>.json`**, the single
source of truth:

```jsonc
{
  "class":   "z2ui5_cl_smpc_app_007",
  "sample":  "sap.m.sample.CheckBoxTriState",   // join key to ui5/<lib>/<Name>/
  "entity":  "sap.m.CheckBox",
  "file":    "src/01/01/z2ui5_cl_smpc_app_007.clas.abap",  // DERIVED - see §3
  "batch":   "b02",           // generation/PR bookkeeping - NOT a folder
  "audit":   { "frontend_action": false,        // uses follow_up_action? (note: which)
               "event_t_arg": true },           // passes t_arg in ANY event wire?
                                                // both flags are DERIVED-checked
                                                // against the class by validate-meta
  "status":  "generated",                       // generated|reviewed|checked
  "checked": { "date": "2026-07-15", "note": "verified in a running system - ..." },
                                                // ^ "checked": null while status is generated/reviewed
  "deviations": [ { "type": "IMPROVISED", "what": "..." } ]
}
```

- The generator writes the sidecar **together with** the class; overview app
  and coverage read only `meta/` (§7). `node scripts/validate-meta.mjs` checks
  schema + referential integrity (file/template exist, file sits in a
  library package) and runs in CI.
- A human live check promotes `status` to `checked` and fills `checked`
  directly in the sidecar; `reviewed` is a manual promotion too. (There is no
  `golden` status — the category was retired; former golden ports are plain
  `checked`, and any port may be refactored to the current conventions.)
- The abapGit `<DESCRIPT>` follows `<library> - <short description>`, kept
  within ABAP's 60-char limit — the form `scaffold.mjs` emits (e.g.
  `sap.ui.unified - CurrencyInTable`).
  There is **no canonical description string offline** (`universe.json` carries
  none), so the scaffolder's `<library> - <sample name>` default is acceptable
  as-is; only improve the trailing text to a human phrase when you know one
  (e.g. `sap.m.Switch - Some say it is only a switch...`). Do not agonize over
  entity-vs-library — existing ports use both; keep the scaffolder default.
- The **control** must exist since UI5 1.71 and not be deprecated — samples
  whose control is newer or deprecated are **out of scope** (§1) and never
  enter a batch. **Members (properties/aggregations/associations/events)
  newer than 1.71 ARE kept when the original uses them — 1:1 fidelity wins**
  (policy decision). Every such member must be declared with a `POST_171`
  deviation naming it (the `property_gate` enforces this via
  `ui5/properties.json`); the app then needs a UI5 release ≥ that member's
  version to render it. `DROPPED_171` remains only for the rare member that
  genuinely cannot be expressed.
  **Gate coverage — the property gate covers ALL ported libraries.**
  The linter's `generate-metadata.mjs` scans every lib's source **recursively**
  (nested controls too — `form/SimpleForm`, `cards/NumericHeader`); the same
  generator fills `ui5/properties.json` for the coverage docs here and the
  linter's own snapshot for the gate — the difference is only the OpenUI5
  version each is run against. Either way each control is resolved via the port's own
  `xmlns` declarations and the parent chain is walked — so a post-1.71
  member in any library is caught automatically (the `generate-result` CI step
  clones the full OpenUI5 repo, so this holds in CI). Two facts about how the
  generator reads `@since` matter when verifying a flag: **(a)** an inherited
  member's `@since` lives in the **parent class file** (the gate walks
  `X.extend(...)` up, e.g. `CalendarDateInterval` → `Calendar.js`); **(b)** a
  member with **no `@since` tag** is base-version (≤ 1.71). Residual limits:
  enum *values* newer than 1.71 (e.g. `ObjectStatus` `Indication06`) are
  invisible at the attribute-name level; a member **relocated to a newer base
  class** reads as that base's version (e.g. `NavigationListItem.expanded`
  shows 1.121 though the property predates 1.71 — declare it with that note);
  a **binding-info parameter** (`boundFilters` @1.146, `templateShareable`, …)
  carries its own `@since` in the `ManagedObject` JSDoc and is **not a control
  member at all**, so no gate can ever see it — declare it `POST_171` by
  policy (apps 264/265); and a member/control **not present in
  `properties.json` at all** is silently passed (`IllustratedMessage` @1.98,
  `Input.autocomplete` @1.108, `sap.ui.core.CommandExecution` — apps 232/233).
  **So the property gate is a backstop, not a guarantee** — when a control
  feels new, still confirm with `node scripts/scope-of.mjs <entity>`
  (control-level) and declare `POST_171` **by policy** even if no gate forces
  it. A green property gate does **not** prove a port is ≤ 1.71-clean — though
  it now does check the **control** itself, not only its members.
- **Before declaring any sample feature inexpressible, check `CAPABILITIES.md`**
  — the map of what abap2UI5 can express, each entry backed by a port that
  proves it. Never improvise around a feature it marks ✅/🔶 (app 042 replaced a
  Dialog with a toast although app 044 shows Dialogs work 1:1 via
  `popup_display`). When a port proves a new technique or disproves a ❌,
  update `CAPABILITIES.md` in the same change.
- **Every improvement idea for the abap2UI5 framework goes into the stock in
  `abap2UI5/abap2UI5`** — `backlog/items/<id>.md`, self-contained and
  forwardable (motivation with the sample/port that hit it, current behavior
  with source references, proposed change, example, and at least one
  `evidence:` entry). Add it in the same change that discovers the gap. Which
  of the four backlogs it lands in follows from its `target:` — the framework,
  the linter, abaplint, or the open-abap compiler stack — and a request whose
  change is live is **deleted** there rather than marked implemented.
  This used to be a `pr/` folder here; the open requests moved on 2026-08-17
  because a request about the framework belongs in the framework's repository,
  and because the same folder was holding requests for three different
  upstreams with nothing distinguishing them. What was left of it is this
  repository's own record of what was shipped and what was declined — the two
  tables `CAPABILITIES.md` cites by request id (`pr/<id>`). They live in
  **`docs/upstream-requests.md`** since 2026-08-18; the empty directory named
  `pr/` was deleted, because to anyone arriving at the repository root it read
  as "pull requests".
- Every port must pass all three CI checks (§6).


### The porting recipe — on-demand guides

The complete step-by-step recipe (class layout, dispatcher, `model_init`,
`view_display` with `z2ui5_cl_ui5_view_builder`, formatting rules, data binding & events,
booleans, the 1.71 rule in practice, deviation types, porting gotchas) lives in
**`.claude/skills/port-a-sample/SKILL.md`** — read it in full before writing or
reviewing any port; it is the authoritative long form of the generation rules.

The recurring hard idioms (named models, typed bindings, expression bindings,
`follow_up_action`, popups, fragments, …) and the worked reference ports are in
**`.claude/skills/idiom-lookup/SKILL.md`** — scan it before porting, and
consult it whenever the original does something the recipe does not cover 1:1.

### Generation prompt

A condensed version of the porting recipe, phrased as a porting task, lives in
**`scripts/generation-prompt.txt`** — the single source, and the only place it
is written out. `generate-coverage.mjs` used to splice it into `README.md`
between `<!-- prompt:start/end -->` markers; that block was removed on
2026-08-18, because ~120 lines of agent instructions under a fold is not what
a reader opens a learning repository's README for. The README links the file
instead.

**The file itself must not go away.** abap2UI5/mcp-server serves it verbatim as its
`generation_rules` rulebook (`lib/guide.mjs` reads
`scripts/generation-prompt.txt`, and `scripts/check-mcp-contract.mjs` gates
that it is there), so deleting or renaming it breaks a consumer outside this
repository. When the recipe changes in substance (the `port-a-sample` guide),
update the prompt file in the same change — that guide is the authoritative
long form.

---

## 6. CI checks & downport

Three abaplint checks run on every pull request; all must report **0 issues**:

| Build           | Command | abaplint syntax |
|-----------------|---------|-----------------|
| `abap-standard` | `abaplint ./abaplint.jsonc`                     | `v750` |
| `abap-cloud`    | `abaplint .github/abaplint/abap_cloud.jsonc`    | `Cloud` |
| `abap-702`      | `npm run downport` → `abaplint .github/abaplint/abap_702.jsonc` | `v702` |

**The rule block below the marker in the root `abaplint.jsonc` is a CHECKED
COPY of the shared app rule set, and its source is
[abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5)
`.github/abaplint/app-rules.json`** — the repository where the rest of "how to
write an abap2UI5 app" already lives (the `build-an-app` and
`view-chain-layout` skills, `docs/agents/building-apps.md`, `abap-check`,
`ui5-check`), because a shared thing needs one owner. **Change it THERE first,
then copy it here**; this repository,
[samples](https://github.com/abap2UI5/samples) and
[samples-stack](https://github.com/abap2UI5/samples-stack) are consumers of
that file, not peers of each other. abaplint has no `extends`, so the checked
copy is the mechanism, and the block carries a header saying so.

**The gate is `scripts/check-app-rules.mjs`** (`npm run check:app-rules`, and
the `check-app-rules` workflow on every pull request and push to `main` — it
is not part of `npm run gates`, which is offline). It compares PARSED SETTINGS
against the source, preferring an `abap2UI5` checkout next to this one and
otherwise fetching it, and it is the one gate here that needs the network: an
unreachable source SAYS SO and passes, rather than turning this repository red
because github.com is. It replaced a three-way peer comparison for three
reasons — three peers have no answer to which of them is right; a repository
without its own copy of the checker turned the *other* repositories' CI red
when it drifted; and the peer checker compared rule NAMES only, so flipping a
rule to `false` to get a pull request through, the exact drift it existed to
catch, read to it as no change at all. abap2UI5 checks the same thing from its
side (`shared-file-gate.mjs`).

Only `global`, `dependencies` and `syntax` are per repository — plus exactly
**one** rule: `object_naming`, which carries the `SMPC` token and is the only
rule `check-app-rules` excludes from the comparison. It sits last in the file
behind a marker that says so; everything above that marker must match the
source. All 188 rules abaplint ships are named: 171 on, 17 off, each with
its reason in a comment. **A rule is never left out of the file** — when an
upgrade adds one, add the key to `app-rules.json` and copy the block into all
three consumers: on if all three corpora pass, off with the reason if they do
not.

The cloud/702 configs stay on the correctness core, because the 702 config
also drives `abaplint --fix` in the downport — they are NOT part of the shared
block. A change to the shared block starts in `app-rules.json`; after copying
it here, run all three builds here *and* the other two repositories' gates —
what is checked is still a joint decision of the three corpora, the source
just says where that decision is written down.

Two things this corpus contributes to the shared decisions, both of which look
like over-permissiveness until you know why:

- **`7bit_ascii` excludes 22 ports.** Their DATA is non-ASCII — product
  descriptions, supplier names, i18n strings — because it is the original demo
  kit sample's data, and `scripts/data-fidelity.mjs` compares it against that
  original. Rewriting it to ASCII would fail that gate. The rule is otherwise
  on, and it found 22 em-dashes and ellipses in *comments*, which are now
  ASCII. **A new port whose data is non-ASCII extends that list, and says so.**
- **`line_only_punc` and `double_space`'s `endParen` are off.** Both read
  deliberate alignment as a defect: a chain and a `VALUE #( )` data table close
  with `).` on its own line (70 of those, in 61 files), and a literal data
  table aligns its rows before the closing paren (676). Same layout question
  the five chain rules already answer — `npm run check:chains` is the gate for
  that shape.

> **Write a configured rule's flags out in full.** abaplint replaces the whole
> options object, so a partial one silently turns every flag it omits *off* —
> `"check_subrc": { "selectTable": false }` disables the rule entirely instead
> of narrowing it.

`short_case` forbids a single-branch `CASE`, so a class that dispatches one
event inline writes `IF client->get_event( ) = \`X\`.` — `pattern-lint`'s
`dead-event-wire` rule knows that shape as a dispatcher alongside the `CASE`
form. Realigning a `TYPE` block in the **generated** overview app belongs in
`scripts/generate-overview.mjs`, not in the generated class, or the next
generator run undoes it.

Every sample must be **ABAP Cloud ready** *and* **downportable to 7.02** — there
is no `src/00` "restricted" area here (unlike abap2UI5/samples); everything must
survive all three builds. The self-contained `auto-downport.yaml` workflow
rebuilds the `702` branch on every push to `main`.

**The downport runs only when the change reaches the ABAP.** `npm run downport`
is the longest thing this repository does by an order of magnitude — half an
hour of `abaplint --fix` iterated to a fixpoint, against every other gate's
minute — and it used to run on every pull request, so a change to the Pages
site, a README or a sidecar waited it out to relint ABAP that is byte for byte
the ABAP on main. `abap-702` and `auto-downport` now ask
`scripts/abap-scope.mjs` first, which answers from the changed files alone:

- it carries **two** lists — what the 702 verdict is computed from (`src/`, the
  abaplint configs, `package*.json`, `A2UI5_PIN`, the two workflows) and what
  provably cannot move it (`web/`, `meta/`, `ui5/`, `scripts/`, prose);
- **a path in neither list runs the downport.** A new folder, a new config, a
  file nobody classified is unknown, and unknown means run — so this goes stale
  as a slow pull request, never as a gate that quietly stopped gating. Adding a
  path to the inert list is a claim that the 702 lint cannot see it; the
  fixture tests hold the shape of both lists;
- the **job always runs and always reports**, only its expensive steps are
  skipped. Branch protection tracks the job name, and a required check that
  never reports blocks the merge — which is why this is a guard inside the job
  rather than a `paths:` filter on the trigger.

**Workflow files are `lower-kebab-case.yaml`, and the file name and the `name:`
are the same string.** The repository mixed three styles
(`ABAP_702.yaml`, `auto_downport.yaml`, `check-app-rules.yaml`) until
2026-08-18; a badge URL spells the file name, so a second style is a second
thing to get wrong. The **job id** is the file name too — *except* where the
job is a named gate: `structural_diff`, `data_fidelity` and friends are also
`meta/<class>.json` field names and the vocabulary the whole corpus is written
in, so those job ids keep their established snake_case spelling. A required
check tracks the JOB name, which is what makes moving a gate between workflow
files invisible to branch protection and renaming a workflow *not*.

**One concern, one workflow, one badge.** Every gate runs in a workflow of its
own, so a red badge names the thing that is actually broken. Seven of them
shared `checks.yaml` until 2026-08-18, which meant the `check-abap2UI5` badge
went red when `check_pins` failed — a reader could not tell a stale pin from a
broken view. Splitting cost nothing: the jobs never shared a setup step (each
one checks out and installs node for itself, and only `view_gates` runs
`npm ci`), so they were already seven runners in parallel and still are.

The deterministic gates run on every PR, one workflow each; the heavy
`e2e_smoke` runs in `e2e-nightly.yaml` (scheduled + on demand):

| Workflow | Job | What it gates |
|----------|-----|---------------|
| `pattern-lint.yaml` | `pattern_lint` | the distilled corpus-policy rules |
| `check-pins.yaml` | `check_pins` | A2UI5_PIN well-formed, no stray/duplicate `"branch"` on the abap2UI5 dependency in any abaplint config |
| `chain-format.yaml` | `chain_format` | the view-chain layout (`npm run fmt:chains` fixes it) |
| `structural-diff.yaml` | `structural_diff` | port vs. archived original, binding values included |
| `data-fidelity.yaml` | `data_fidelity` | seeded values vs. the archived sample mocks |
| `view-gates.yaml` | `view_gates` | properties + structure + headless render — the three former view gates, now run from [abap2UI5-linter](https://github.com/abap2UI5/linter) with only the corpus policy kept here in `scripts/view-gates.mjs`; also `npm run check:collection` for `src/03`, and it publishes the two README badges |
| `meta-valid.yaml` | `meta_valid` | sidecar schema + referential integrity, and that every generated artefact (overview app, `README.md`, `api.md`, `STATUS.md`, `SAMPLES.md`) is in sync |
| `tooling-tests.yaml` | `tooling_tests` | the gate/generator tooling's own fixture tests |
| `check-prose-names.yaml` | `prose_names` | every `z2ui5_cl_*` class named in prose exists, here or in the repository that owns it |
| `check-app-rules.yaml`, `check-keywords.yaml`, `check-summary.yaml` | same | the shared abaplint app rules, the `@keywords` and the `@summary` lines |

What each gate checks, what a failure means and every legitimate escape hatch
is in **`.claude/skills/run-the-gates/SKILL.md`** — read it the moment a gate
fails, and before declaring any skip or deviation to satisfy one.

**When a distilled lesson is greppable, encode it as a rule in the same
change** — that is what makes a lesson unrepeatable rather than advisory.
Where it lives depends on what it is about (split enforced 2026-08-04):
a lesson about **abap2UI5 views/apps in general** becomes a rule in
[abap2UI5-linter](https://github.com/abap2UI5/linter) (every consumer sees it;
`view_gates` gates it here once a release carrying it reaches
`package-lock.json`); only a **corpus-policy** lesson
(method order, formatting, sidecar conventions) stays a pattern-lint rule.
Never both — one rule set, two enforcement points is how the editor and CI
drifted apart before. `view_gates` also carries the **advisory ratchet**
(`ADVISORY_BUDGET` in `scripts/view-gates.mjs`): advisory findings never gate
per finding, but their per-type count must not grow — a batch that adds one
fails strict, and a linter bump that introduces a new advisory type surfaces
at the bump PR, where the debt decision belongs.

**Run before every commit:**
```bash
npm run gates        # full offline gate set, fail-fast; needs NO node_modules and no network
```
It chains: chain-format → check-prose-names → pattern-lint → check-pins →
validate-meta → structural-diff → data-fidelity → check-mcp-contract →
regenerate overview/coverage/status/SAMPLES.md/catalogue.json →
`git diff --exit-code -- src README.md api.md STATUS.md SAMPLES.md catalogue.json`
(regenerated artefacts must leave the tree clean, exactly as the `meta_valid`
CI job checks). **Every step here has a CI job with the same name** — the
chain and the workflows are one list, and a step that runs only locally is a
gate nobody enforces (chain-format was exactly that until 2026-08-18).

**Before every PR:**
```bash
npm run check        # every CI job that runs offline, without a browser
```
It is `gates` plus the three that are CI jobs but were in no local command
until 2026-08-18 — `check:app-rules`, `check:keywords`, `check:summary` — plus
`npm test` (the golden-file fixture tests for the gate and generator tooling
in `scripts/test/`, also a CI job). `check` is the ecosystem-wide name for
"what CI will say about this tree", and it means the same thing in every
repository.

It stops short of two CI layers on purpose, because both need more than a
checkout:
```bash
npm ci               # once - installs abaplint, @abap2ui5/linter + the OpenUI5 runtime
npm run gates:full   # gates + `npx abaplint ./abaplint.jsonc` (0 issues)
                     #       + view-gates --strict (properties/structure/headless render)
```
plus `abap-cloud` / `abap-702`, which lint the downported tree against two more
abaplint configs. Run `gates:full` before a PR that touches views or ABAP; the
702 job is a full downport and is left to CI.


### Developer tooling — starting a port

`npm run scaffold <sample>` archives the template, picks the app number/batch
and writes the class stub + sidecar; `npm run json-to-abap` turns a JSON mock
array into a typed ABAP `VALUE #( )` literal. Usage, flags, the `OPENUI5_SRC`
sparse-clone recipe and the type-inference rules are in
**`.claude/skills/scaffold-a-port/SKILL.md`**.

`npm run form-family <dir> <class> <sample> <out>`
(`scripts/form-family-to-abap.mjs`) rebuilds ONE sample of the sap.ui.layout
Form/SimpleForm display-vs-change family (apps 312..337). Those 26 samples
share one `Page.controller.js`, so the port shape is fixed and only the
fragment bodies differ. It is deliberately narrow — it knows that controller,
its supplier fields and its event names, and throws on anything else rather
than guessing; the output is reviewed and its sidecar written by hand, exactly
like a hand-written port. Regenerating 312..337 with it is byte-identical
below the two generated header lines (`npm run keywords` / `npm run summary`
write those) — **re-verify that after any corpus-wide sweep**, because the
emitter does not move with one: between 2026-08-16 and 2026-08-21 it had
silently rotted through four of them and emitted `open( )`/`leaf( )`, builder
methods that no longer exist, so this sentence was pointing at a class that
could not activate.

Artefact regeneration is automated by the tracked **`.githooks/pre-commit`**
hook: on every commit it regenerates the overview app, the coverage docs and
the STATUS.md state block and stages them, so they never drift from `meta/`
(which the `meta_valid` CI job enforces on PRs). It is enabled with `git config core.hooksPath .githooks`,
which `npm ci` / `npm install` runs automatically via the `prepare` script.

### abapGit file format (all serialized files)

- Encoding UTF-8 (BOM allowed); line endings **LF only**; **final newline**.
- Indentation 2 spaces. Max **255 characters** per `.abap` line (split long
  literals with `&&`).


---

## 7. Coverage & overview — always (re)generated

Six artefacts are generated, never hand-edited — edit the scripts instead:
the `README.md` coverage block, the `STATUS.md` state block, `api.md`,
`SAMPLES.md`, `catalogue.json`, and the
in-system overview app `src/z2ui5_cl_smpc_app_000.clas.*`. They regenerate
as part of `npm run gates` (or via the individual `generate-*.mjs` scripts)
and must leave `git diff` clean before every commit — the `meta_valid` CI job
enforces exactly that. The full spec (overview app columns and behaviour, the
`ui5/universe.json` + `ui5/openui5-entities.json` snapshots, api.md link
targets, the weekly `generate-result` workflow, gap-free renumbering) is in
**`.claude/skills/regenerate-artefacts/SKILL.md`** — read it before touching a
generator, a generated file, or the sidecar shape they read.

`api.md` and `SAMPLES.md` answer different questions and both are needed.
`api.md` is COVERAGE — one row per demo kit sample including the ~300 that are
not ported, keyed by control, built to show what is missing. `SAMPLES.md` is
the CATALOGUE — one row per port with the sentence that says what it shows,
grouped by UI5 library, for somebody asking "is there a port for X".

**`catalogue.json`** is the same catalogue for a MACHINE
(`scripts/generate-catalogue.mjs`): one JSON entry per port — class, path,
category, library, demo kit sample id, entity, status, deviation types,
summary, keywords — joined from the sidecars and the class scan, plus a
top-level block saying what this repository is and naming the
`Z2UI5_CL_SMPC_*` vs `Z2UI5_CL_SMP_*` class-name trap for a tool that has
seen abap2UI5/samples. Committed (unlike the Pages `apps.json` below) because
it carries only committed facts — no linter pass, so it is offline,
deterministic and gated by the same regenerate-and-diff as the other five;
the derived view facts (controls built, minimum UI5 release) stay in
`apps.json`, which serves them fresher than a commit could.

One more artefact is generated and deliberately NOT committed:
`web/search/apps.json`, the data behind the searchable catalogue on GitHub
Pages (`scripts/generate-search-index.mjs`, spec in `web/README.md`). It is
derived twice over — from the sidecars and from an `@abap2UI5/linter` run that
reconstructs each port's view — and it is ~360 KB. Committing it would put
that diff on every port PR and add a gate that can only ever restate what the
linter already says; `deploy-web` regenerates it on every deploy instead, so
it cannot be staler than the site serving it. Do not add it to `npm run
gates`, and do not commit it.

`SAMPLES.md` is written from the classes (`DESCRIPT`, `" @summary`,
`" @keywords`), and its **row shape is a contract, not a layout**:
`abap2UI5/samples` and `abap2UI5/samples-stack` render the identical shape and
one parser reads all three (`abap2UI5/mcp-server`, the `examples` tool). Change it
here and you change it for them. The one extension this repository makes is the
trailing verification-marker block per row (`<br><sub>✓ checked · n
deviations</sub>`, from the sidecar's `status`) — safe because that parser
reads the blocks as a group, takes the FIRST `<sub>` as the keywords and
ignores blocks it does not know; the marker therefore always sits AFTER the
keywords block (the generator enforces that ordering — keep it).

---

## 8. ABAP code conventions

The two authoritative ABAP style references for this repo are:

- **[SAP Clean ABAP](https://github.com/SAP/styleguides/tree/main/clean-abap)**
  (`clean-abap/CleanABAP.md`) — SAP's official style guide.
- **[DSAG ABAP-Leitfaden](https://github.com/1DSAG/ABAP-Leitfaden)** (1DSAG) —
  the German-community ABAP best-practice guide.

Plus the detailed conventions in the
[abap2UI5/samples AGENTS.md](https://github.com/abap2UI5/samples/blob/main/AGENTS.md)
(§7 code conventions, §9 app lifecycle, §10 view building, §11 app structure) —
the ports share that style. When these disagree, prefer Clean ABAP, then the
DSAG Leitfaden, then the samples style. Essentials:

- **Booleans use `abap_true` / `abap_false`, never the character literals `'X'` /
  `' '`** (Clean ABAP "Use abap_true and abap_false"); build them with
  `xsdbool( )`, feed a bound view attribute through the builder's `a( b = … )`.
  The **one deliberate exception is a positional `t_arg` element** (`t_arg TYPE
  string_table`): those are wire-protocol string tokens, so the descending flag of
  a `binding_call` sort etc. may be written as the plain string `` `X` `` — though
  `( abap_true )` (implicitly `c → string` = `'X'`) is preferred where it reads as
  the boolean it is (the framework defines that arg as "abap_bool as `X`/space").
- **Always the simplest possible notation**: omit parameters that equal the
  default (`get_event_arg( )`, not `get_event_arg( 1 )`), no pass-through
  methods, no explicit forms where the implicit one reads the same.
- **Derive values from the data when the original does** — `selected =
  t_items[ 1 ]-text.` like the sample's `oMData[0].text`, never the resolved
  literal (app 003).
- **`VALUE #( )` alignment is all-or-nothing**: one field per line with every
  `=` in the same column — and after renaming a field, re-align the WHOLE
  block including the TYPES definition (app 033).
- **Inline comments stay minimal**: one line at the exact spot of a deviation;
  multi-line rationale belongs in the sidecar, not the code (app 039).
- **Named view slots go through the `cs_view-*` constants, never a literal.**
  For a `control_by_id` action the view is its own `view` parameter on
  `follow_up_action` (no longer a positional `t_arg` slot):
  it defaults to `cs_view-main` (omit it for a main-view control — the id then
  resolves across all open slots), and for a popup/popover control pass
  `view = client->cs_view-popup` (`-popover` / `-nested` / `-nested2`), not the
  plain string `` `POPUP` `` (apps 004/013). The `t_arg` is now just
  `id, method, params`.
- Class names **lowercase** in `DEFINITION` and `IMPLEMENTATION`; not `FINAL`;
  `DEFINITION PUBLIC.` (never `CREATE PUBLIC`).
- Always include `PROTECTED SECTION.` and `PRIVATE SECTION.` (keep `PRIVATE`
  empty). Order per section: `TYPES`, then `DATA`, then `METHODS`.
- Backticks for string literals; string templates (`|...{ }...|`) for
  concatenation; `VALUE #( )` to reset, never `CLEAR`.
- Prefix only tables (`t_`) and structures (`s_`); local types `ty_s_` / `ty_t_`.
- Lifecycle: chain `check_on_init( )` / `check_on_navigated( )` /
  `check_on_event( )` with `ELSEIF`. Re-display the view in the
  `check_on_navigated( )` branch.
- Build views with `z2ui5_cl_ui5_view_builder` (see the `port-a-sample` guide — the only
  view builder used in this repo; the class itself lives in the **abap2UI5 core
  repo** under *its* `src/02/` — not this repo's `src/02/`, which is the
  `sap.ui` port package); `client->view_display( view->stringify( ) )` as a
  standalone final statement.
- **ABAP Doc (`"!`) is parsed as HTML.** A raw `<…>` is read as an HTML tag, so
  never put a literal UI5 element (`<mvc:View>`) or any other `<tag>` in a `"!`
  comment — write it plain (`mvc:View element`) or escape it as `&lt;tag&gt;`.
  A `<tag>` there is flagged as an unsupported *and* unclosed HTML tag (was a
  warning on `z2ui5_cl_ui5_view_builder`, and again on the headless frontend simulator —
  since moved to [abap2UI5/test](https://github.com/abap2UI5/test) — where a
  placeholder `<class name>` had to become `&lt;class name&gt;`).

**Run `abaplint` after every change — 0 issues before committing.**


---

## 9. Dependencies

* [abap2UI5](https://github.com/abap2UI5/abap2UI5) — the framework the ports run on.
* [OpenUI5](https://github.com/SAP/openui5) — the source of the demo kit samples.


---

## 10. Lessons learned — capture them, never repeat them

**This file is the project's memory. Whenever you discover and fix a non-obvious
mistake, write the rule back here in the same change — before you finish.** That
is the only mechanism that stops the next agent (or you, next session) from
making it again: every agent reads this file first, nothing else is guaranteed to
be read. No automation can judge what is worth recording, so this is a manual
discipline, not a background job.

What counts as worth capturing: a CI/linter rule you did not know, a framework
quirk, a wrong assumption you had to unlearn, a tool that behaved destructively.
What does not: a one-off typo, anything already stated above.

How to record it:

- Put the rule where an agent will hit it — a **step-specific** lesson goes in
  that step's guide under `.claude/skills/` (an event-arg rule in
  `port-a-sample` "Data binding & events", an e2e trick in `e2e-debugging`, a
  generator quirk in `regenerate-artefacts`); a **cross-cutting** one goes in
  the list below or §8. **Never grow this file with step-specific material** —
  keeping it lean is what keeps it loadable in every session.
- Write the **rule**, not the war story: one line on what to do / avoid, and a
  short why. Reference the app or class where it bit us, so it can be checked.
  The full story, if worth keeping, goes in the `docs/history.md` journal.
- Keep it deduplicated — extend the existing bullet rather than adding a second.


### Known gotchas (cross-cutting)

Cross-cutting rules only — a task-specific gotcha lives at the end of the
matching guide under `.claude/skills/` (porting gotchas in `port-a-sample`,
e2e gotchas in `e2e-debugging`, generator gotchas in `regenerate-artefacts`).

- **`npm run downport` rewrites the working tree in place** — it runs
  `abaplint --fix` over every `src/**` file *and overwrites `abaplint.jsonc`* with
  the 702 config. Never run it on the tree you intend to commit; run it in a
  throwaway `git worktree` (or copy) and check `abap_702.jsonc` there. If you did
  run it in place, `git checkout -- .` to restore before committing.
  **A file with a parser error poisons the whole run**: the `--fix` `&&`-chain
  exits non-zero, later steps never run, and the copy is left half-rewritten —
  every file then reports downport errors, including clean ones. Fix (or drop)
  parser-broken classes BEFORE downporting.
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
- **ABAP Doc (`"!`) is HTML** — no raw `<tag>` (e.g. `<mvc:View>`); see §8.
- **Literal braces in attribute values are read as a BINDING by the XMLView
  parser** — CSS/JS braces inside a `core:HTML` `content` (or any literal
  attribute value) must be escaped `\{ … \}` or view creation crashes (app 028;
  the linter rules `unescaped-brace-in-style` / `collapsed-brace-in-style`
  gate the `<style>` case via `view_gates`).
- **A deviation text is also a gate escape — rewriting it can un-declare a
  diff.** `structural-diff` (and `data-fidelity`) accept a difference only
  while some sidecar deviation *names* it. Converting a `LIVE_TEST` to a
  `NOTE` and rewriting the prose therefore silently re-opens every diff that
  sentence covered (apps 176/213/214: three undeclared
  `attr missing Slider.liveChange` findings the moment the verified text
  replaced the one naming the dropped attribute). When you rewrite a
  deviation, keep the naming clause and run `structural-diff --strict` in the
  same change.
- **abapGit pushes from a system can carry stale generated files** — a human
  who pulled before the latest repo change and pushes back from the system
  silently reverts it. After every human push: regenerate the overview
  (`node scripts/generate-overview.mjs`) and diff; the `meta_valid` CI job
  catches it on PRs, direct pushes need the manual regen.
- **Port classes carry no ABAP Doc header** — everything (sample, entity,
  status, checked, deviations, audit) lives in `meta/<class>.json`; edit the
  sidecar, never write `"!` lines into a port (pattern-lint blocks them, and
  `validate-meta.mjs` checks the sidecars).
- **abapGit XML files must start with the UTF-8 BOM** (`EF BB BF` before
  `<?xml …>`). abapGit serializes them that way; BOM-less files break the
  abapGit format on the system pull. The scaffolder and generate-overview emit
  the BOM; when writing a `.clas.xml`/`package.devc.xml` by hand, copy a
  reference byte-exactly — pattern-lint rule `abapgit-xml-bom` gates every
  `src/**/*.xml`.
- **Never reuse a `FOR <n> = …` iterator name within one method** — the 702
  downport materializes each numeric iterator as `DATA <n> TYPE i`, so a
  second `FOR i = …` in the same method makes the downported class (and the
  e2e transpiler) fail with "Variable name already defined". Use distinct
  names (`i`, `j`, `k`) per `VALUE` block (app 234; linter rule
  `duplicate-for-iterator`, gated via `view_gates`).
- **After a repo rename, grep for the old `owner/name` — a
  `github.repository` guard fails SILENTLY.** The rename to `ai-demokit` left
  `abap2UI5/api` in the `auto-downport.yaml` `if:` guard (the workflow was
  *skipped*, not red, so the 702 branch silently stopped rebuilding), in the
  README badge URLs, in `package.json`, and in the repo URLs baked into
  `generate-coverage.mjs`/`generate-overview.mjs`. A skipped workflow shows no
  failure anywhere — only a grep for the old name finds this class.
- **A blocked protocol is not a blocked network** — this environment refuses
  `curl https://raw.githubusercontent.com/…` at the proxy, which reads like "no
  OpenUI5 source reachable". **`git clone https://github.com/SAP/openui5.git`
  works**, and that is the transport the pipeline (`generate-result`,
  `scaffold`, the metadata refresh) uses anyway. Before declaring a task
  blocked on network access, try the transport the tooling itself uses.
- **A code change to a `checked` port invalidates the check** — `checked`
  certifies the code that was live-verified, not the class name. Any
  behavioral rework of a `checked` port resets `status` to `generated`
  (keep the historical check as context inside a `LIVE_TEST` deviation) or
  restamps `checked` after a fresh live run (app 003 once showed green in the
  overview while its central interaction path was unverified).
- **Every PUBLIC attribute is persisted app state** — the framework serializes
  it into the draft on every round-trip and parses it back on the next one, and
  the whole model also travels to the browser on every render. So data that
  exists **only** to be handed back as an event argument does not belong in the
  model: pass the row **key** in the `t_arg` and look the payload up
  server-side (the catalog/DB read is cheap, the transport is not). The
  overview app once shipped every row's generation notes + four URLs in the
  model (~578 kB draft, ~30 s clicks in a transpiled runtime) just to fill two
  popovers; now only bound columns are public, the full catalog stays in a
  local (`get_catalog( )` is a METHOD) and `row_of( val )` fetches the pressed
  row (draft 199 kB, clicks ~4 s). This is **not** a licence to subset a
  port's mock data — the porting recipe (`port-a-sample`) still requires the
  full row set; it is about text that is never rendered from the model.

<!-- The section below is SHARED. Its source is
     abap2UI5/abap2UI5 .github/shared/agents-metadata.md - change it THERE
     first, or the change is drift. abap2UI5's `npm run check:shared`
     compares this section against the source, from the heading down to the
     next `##`; anything above this comment is this repository's own.

     This repository adds one subsection the others do not have,
     `### In this repository`, declared in the gate's METADATA_EXTENSIONS.
     It is cut out before the comparison, so it may say anything - but its
     heading text must stay exactly that, or the gate fails by name. -->
## Metadata: what goes on the class, and what goes beside it

Shared across `abap2UI5/samples`, `abap2UI5/samples-controls` and
`abap2UI5/samples-stack`. Decided once, so nobody has to decide it again per
repository.

**A class says what it IS. A sidecar records what HAPPENED to it.**

| | where | why |
|---|---|---|
| `DESCRIPT` — `Titel - Kurzbeschreibung` | `.clas.xml` | 60 characters, hard. What ADT's object list shows |
| `" @summary` — one sentence | first lines of `.clas.abap` | no limit. The line a catalogue puts under the title |
| `" @keywords` — search terms | first lines of `.clas.abap` | what somebody would type who does not know the sample exists |
| upstream sample, port batch, audit findings, verification date, deviations | a sidecar (`meta/<class>.json`) | not properties of the class; written by machinery; long-form; changes on a different schedule |

### Why the first three are not in a sidecar

**A sidecar does not travel.** abapGit pulls `src/`; a `meta/` folder never
reaches the SAP system. Three places that costs:

1. **In the system it is simply absent** — which is why an overview app that
   needs the data has to have it *baked in* by a generator.
2. **A search engine drops somebody into the `.clas.abap` on GitHub** and the
   code is all they get. This is the same argument `@docs` is a full URL for.
3. **An AI reading the class file gets no metadata** unless its tooling happens
   to know about `meta/`.

A `"` comment costs the ABAP nothing — it is not `"!`, so SLIN/ATC does not
report an unknown tag — and it cannot desync from the class, because it is in
the class.

### Why the rest is not on the class

A deviation note with three paragraphs and a verification date is not a
property of the class; it is a log entry about a process, usually written by a
test run rather than by an author. Putting it in a `"` comment would bloat the
source and would still be worse structured than JSON. That belongs beside the
class, and the sidecar is right for it.

### In this repository

`" @keywords` is **generated**, not written: `npm run keywords` derives it from
`meta/<class>.json`'s `entity`, the class `DESCRIPT` and the controls the port
actually builds, and `npm run check:keywords` holds it to those sources.

`" @summary` is **fetched**, not written. The sentence the demo kit prints
under a sample title says what the sample demonstrates, and it was never in
this repository: it lives in the OpenUI5 sources in
`src/<lib>/test/**/demokit/docuindex.json`, not in the per-sample
`manifest.json` that [`ui5/`](ui5/) archives. So:

| | |
|---|---|
| `npm run descriptions -- --openui5 <checkout>` | snapshots all 793 demo kit descriptions into [`ui5/descriptions.json`](ui5/descriptions.json), with the OpenUI5 commit they came from |
| `npm run summary` | writes them onto the classes — 413 ports from the demo kit, 3 from the snapshot's `written` block, 14 derived (the SAPUI5-only collection in `src/03` has no upstream sample) |
| `npm run check:summary` | holds every line to the snapshot |

A snapshot rather than a live read, for the same reason `ui5/` archives the
sample sources: a port batch and a CI run both have to work without a 43k-file
OpenUI5 checkout, and an upstream edit must show up as a diff somebody reads
rather than silently rewrite 400 class files.

Three samples the demo kit does not describe — two shared "base" pages that are
not samples of their own, one whose upstream description is empty — sit in the
snapshot's `written` block, each with a `why`. A port that matches none of the
sources **fails** `check:summary` instead of being skipped: the point is that a
new undescribed sample gets noticed.

The generated overview app is the exception to both generators: it writes its
own `@keywords` / `@summary` (in `scripts/generate-overview.mjs`), and the two
generators skip it by name — two generators writing one file would fight, and
whichever ran last would turn the other's drift gate red.

### The test, when a new field turns up

Ask: *would this still be true if nobody ever ran a check again?* If yes it
describes the sample and belongs on the class. If it only became true because
somebody did something, it belongs in the sidecar.
