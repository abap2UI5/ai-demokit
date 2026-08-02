# AGENTS.md — ai-demokit

Single source of truth for agents working on **abap2UI5 ai-demokit**.

> These instructions OVERRIDE any default behavior and must be followed exactly.
> This entire project is in **English** — code, comments, commit messages, PRs.

> **Core principle — abap2UI5 is a THIN FRONTEND.** As much logic as possible
> lives in the **ABAP backend**; the frontend only renders and forwards events.
> **Never put business logic in the frontend** — no computation, unit
> conversion, thresholds, classification or validation in a frontend formatter,
> expression binding or custom JS. Compute the result in ABAP and bind the
> finished value. A *formatter* is presentation-only (a date/number format, an
> icon glyph); a value like an `ObjectNumber` `state` derived from a measure +
> thresholds **is business logic** and must be computed server-side into a model
> field, then bound directly (`state="{WEIGHT_STATE}"`). When a UI5 sample does
> such logic in its `Formatter.js`, the faithful abap2UI5 port moves it to
> `model_init` and declares the difference — a *more* correct architecture, not
> a deviation from intent (apps 009/010/022/092).

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

**Large files — grep them, never read them whole:** `api.md` (~316 KB
generated table), `STATUS-history.md` (~198 KB journal), `CAPABILITIES.md`
(~45 KB — grep for the feature row), `scripts/e2e-smoke.mjs` (~80 KB),
`scripts/generate-overview.mjs` (~54 KB),
`src/z2ui5_cl_ai_app_overview.clas.abap` (generated).

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
> `generate-metadata.mjs`, run from `generate_result`), and `scopeOf` in
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
   kit sample at `src/<library>/test/<library>/demokit/sample/<Name>/`.
2. **Generate** — rebuild each sample 1:1 as an abap2UI5 app (a class
   implementing `z2ui5_if_app`), filed by library under `src/`.
3. **Store templates** — keep the untouched original UI5 JS/XML templates in the
   `ui5/` folder.
4. **Report** — regenerate the coverage (`README.md` summary + `api.md`) and the
   in-system overview app: every sample marked ✅ ported / ❌ missing, with a
   coverage figure per module.

Curated, hand-reviewed samples ultimately graduate to the
[abap2UI5/samples](https://github.com/abap2UI5/samples) repo. Everything here is
machine-generated and carries the "not yet manually reviewed" marker (§5).

---

## 2. Layout — two trees in one branch

Everything lives on the working branch, in two separate top-level trees:

| Path    | Content |
|---------|---------|
| `src/`  | The generated abap2UI5 ports (`*.clas.abap`) — the abapGit project (§3). |
| `ui5/`  | The original UI5 demo kit templates (JS/XML/manifest), one folder per ported sample (§4). |

Keep them separate: only `src/` is the abapGit / abaplint scope; `ui5/` is
plain JS/XML held for reference and to feed the generator.

---

## 3. Repository layout — the ABAP ports

abapGit project, `FOLDER_LOGIC=PREFIX`, `STARTING_FOLDER=/src/`. Ports are split
by the UI5 **library** of the demo kit sample they rebuild:

| Folder   | CTEXT (`package.devc.xml`) | Library namespace | Status |
|----------|----------------------------|-------------------|--------|
| `src/01` | `sap.m`    | `sap.m`    | exists |
| `src/02` | `sap.ui`   | `sap.ui.*` (core, layout, unified, table, integration, codeeditor, model.type) | exists |
| `src/03` | `sap.uxap` | `sap.uxap` | exists |
| `src/04` | `sap.f`    | `sap.f`    | exists |
| `src/05` | `sap.tnt`  | `sap.tnt`  | exists |

The split key is the **second-level namespace** of the sample's entity. New
libraries get the next free `src/NN` folder with a matching `package.devc.xml`.

Inside a library folder, ports are grouped into **batch subpackages**
`src/<NN>/b<nn>/` — one folder per generation/review batch (~10 related
samples, e.g. `b01` display & navigation), each with its own
`package.devc.xml`, so every batch is a separate ABAP package in the system
and one PR in git. A port's batch is recorded in its `meta/<class>.json`
(derived from the path). New ports always go into a new batch folder, never
into a closed one — see TRAINING.md for the batch process.

Because `FOLDER_LOGIC=PREFIX`, class names never encode the folder — moving a
class between folders needs no rename.

### OpenUI5 only — no SAPUI5-only library in this repo

**Every port in this repo rebuilds an OpenUI5 demo kit sample, and every control
it uses must be part of OpenUI5.** A library that ships with SAPUI5 only
(`sap.ui.comp` smart controls, `sap.suite.*`, `sap.viz.*`, `sap.gantt.*`, …) is
out of scope here — full stop. It has no `src/NN` folder, no `ui5/<lib>/`
template folder, and no entry in the coverage tables.

The reason is not taste, it is that the whole machinery is built on an OpenUI5
checkout: `ui5/universe.json` (the sample universe), `ui5/properties.json` (the
property gate) and `render_smoke` (which serves the `@openui5/*` packages) can
none of them see a control that OpenUI5 does not ship. A SAPUI5-only port
therefore sits outside all three checks and is unverifiable here —
`generate-coverage.mjs` reports it as an **orphan port**, which is the correct
answer, not a false alarm to suppress.

Curated SAPUI5-only demos belong in [abap2UI5/samples](https://github.com/abap2UI5/samples)
instead, under `src/00/` (*extended*), where the build strips them before the
cloud and 702 checks — the former `src/06` smart control ports live there now
(`z2ui5_cl_demo_app_475`–`_479`), rebuilt on the framework's own
`z2ui5_cl_xml_view` builder.

### Class naming

Ports are named `z2ui5_cl_ai_app_<n>` (lowercase). `<n>` is a stable, unique
number; it is the app's identity linking a port to its template (see §4).

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
  "class":   "z2ui5_cl_ai_app_007",
  "sample":  "sap.m.sample.CheckBoxTriState",   // join key to ui5/<lib>/<Name>/
  "entity":  "sap.m.CheckBox",
  "file":    "src/01/b02/z2ui5_cl_ai_app_007.clas.abap",
  "batch":   "b02",
  "audit":   { "frontend_action": false,        // uses _event_client? (note: which)
               "event_t_arg": true },           // passes event args via t_arg?
  "status":  "generated",                       // generated|reviewed|checked
  "checked": { "date": "2026-07-15", "note": "verified in a running system - ..." },
                                                // ^ omit "checked" entirely while status is generated/reviewed
  "deviations": [ { "type": "IMPROVISED", "what": "..." } ]
}
```

- The generator writes the sidecar **together with** the class; overview app
  and coverage read only `meta/` (§7). `node scripts/validate-meta.mjs` checks
  schema + referential integrity (file/batch/template exist) and runs in CI.
- A human live check promotes `status` to `checked` and fills `checked`
  directly in the sidecar; `reviewed` is a manual promotion too. (There is no
  `golden` status — the category was retired; former golden ports are plain
  `checked`, and any port may be refactored to the current conventions.)
- The abapGit `<DESCRIPT>` follows `<library> - <short description>`, truncated
  to 60 chars — the form `scaffold.mjs` emits (e.g. `sap.ui.unified - CurrencyInTable`).
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
  member in any library is caught automatically (the `generate_result` CI step
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
- **Every improvement idea for the abap2UI5 framework goes into `pr/`** — one
  folder per request with a self-contained, forwardable README (motivation
  with the sample/port that hit it, current behavior with source references,
  proposed change, example). Add it in the same change that discovers the
  gap; see `pr/README.md`. **`pr/` is a pure backlog folder — it holds OPEN
  requests only:** once a request is live (merged upstream, or landed in this
  repo's tooling) delete its folder in that same change and leave only a row in
  the `pr/README.md` "Implemented" table; the details then live upstream and in
  `CAPABILITIES.md`/`STATUS.md`. Never mark a folder "implemented, kept until
  merged" — that is what the table is for.
- Every port must pass all three CI checks (§6).


### The porting recipe — on-demand guides

The complete step-by-step recipe (class layout, dispatcher, `model_init`,
`view_display` with `z2ui5_cl_ai_xml`, formatting rules, data binding & events,
booleans, the 1.71 rule in practice, deviation types, porting gotchas) lives in
**`.claude/skills/port-a-sample/SKILL.md`** — read it in full before writing or
reviewing any port; it is the authoritative long form of the generation rules.

The recurring hard idioms (named models, typed bindings, expression bindings,
`_event_client`, popups, fragments, …) and the worked reference ports are in
**`.claude/skills/idiom-lookup/SKILL.md`** — scan it before porting, and
consult it whenever the original does something the recipe does not cover 1:1.

### Generation prompt

A condensed version of the porting recipe, phrased as a porting task, lives in
**`scripts/generation-prompt.txt`** — the single source; `generate-coverage.mjs`
splices it into `README.md` between the `<!-- prompt:start/end -->` markers
(never edit the README block by hand). When the recipe changes in substance
(the `port-a-sample` guide), update the prompt file in the same change — that
guide is the authoritative long form.

---

## 6. CI checks & downport

Three abaplint checks run on every pull request; all must report **0 issues**:

| Build           | Command | abaplint syntax |
|-----------------|---------|-----------------|
| `ABAP_STANDARD` | `abaplint ./abaplint.jsonc`                     | `v750` |
| `ABAP_CLOUD`    | `abaplint .github/abaplint/abap_cloud.jsonc`    | `Cloud` |
| `ABAP_702`      | `npm run downport` → `abaplint .github/abaplint/abap_702.jsonc` | `v702` |

The **root** `abaplint.jsonc` carries the full curated rule set (correctness +
style aligned with §8: `keyword_case`, `types_naming ^TY_`,
`object_naming ^Z2UI5_CL_AI_`, `unused_*`, `obsolete_statement`,
`avoid_use` incl. `defaultKey` — always `WITH EMPTY KEY`, `commented_code`,
`definitions_top`, `whitespace_end`, …). The cloud/702 configs stay on the
correctness core, because the 702 config also drives `abaplint --fix` in the
downport. When adding a rule, run all three builds — a rule that fights the
generated view-chain style (e.g. `empty_line_in_statement`, `double_space`)
stays off deliberately.

Every sample must be **ABAP Cloud ready** *and* **downportable to 7.02** — there
is no `src/00` "restricted" area here (unlike abap2UI5/samples); everything must
survive all three builds. The self-contained `auto_downport.yaml` workflow
rebuilds the `702` branch on every push to `main`.

The `checks` workflow runs the deterministic gates on every PR; the heavy
`e2e_smoke` runs in `e2e_nightly.yaml` (scheduled + on demand). The gate set:
`pattern_lint`, `structural_diff`, `view_gates` (properties + structure +
headless render — the three former view gates, now run from
[abap2UI5-linter](https://github.com/abap2UI5/linter) with only the
corpus policy kept here in `scripts/view-gates.mjs`), `data_fidelity`,
`meta_valid`, plus `e2e_smoke`. What each gate checks, what a failure means
and every legitimate escape hatch is in
**`.claude/skills/run-the-gates/SKILL.md`** — read it the moment a gate fails,
and before declaring any skip or deviation to satisfy one.

**When a distilled lesson is greppable, add it as a pattern-lint rule in the
same change** — that is what makes a lesson unrepeatable rather than advisory.

**Run before every commit:**
```bash
npm run gates        # full offline gate set, fail-fast; needs NO node_modules and no network
```
It chains: pattern-lint → validate-meta → structural-diff → data-fidelity →
regenerate overview/coverage/status →
`git diff --exit-code -- src README.md api.md STATUS.md` (regenerated
artefacts must leave the tree clean, exactly as the `meta_valid` CI job checks).

**Before every PR, additionally:**
```bash
npm ci               # once - installs abaplint, @abap2ui5/linter + the OpenUI5 runtime
npm run gates:full   # gates + `npx abaplint ./abaplint.jsonc` (0 issues)
                     #       + view-gates --strict (properties/structure/headless render)
```


### Developer tooling — starting a port

`npm run scaffold <sample>` archives the template, picks the app number/batch
and writes the class stub + sidecar; `npm run json-to-abap` turns a JSON mock
array into a typed ABAP `VALUE #( )` literal. Usage, flags, the `OPENUI5_SRC`
sparse-clone recipe and the type-inference rules are in
**`.claude/skills/scaffold-a-port/SKILL.md`**.

Artefact regeneration is automated by the tracked **`.githooks/pre-commit`**
hook: on every commit it regenerates the overview app + coverage docs and
stages them, so they never drift from `meta/` (which the `meta_valid` CI job
enforces on PRs). It is enabled with `git config core.hooksPath .githooks`,
which `npm ci` / `npm install` runs automatically via the `prepare` script.

### abapGit file format (all serialized files)

- Encoding UTF-8 (BOM allowed); line endings **LF only**; **final newline**.
- Indentation 2 spaces. Max **255 characters** per `.abap` line (split long
  literals with `&&`).


---

## 7. Coverage & overview — always (re)generated

Four artefacts are generated, never hand-edited — edit the scripts instead:
the `README.md` coverage block, the `STATUS.md` state block, `api.md`, and the
in-system overview app `src/z2ui5_cl_ai_app_overview.clas.*`. They regenerate
as part of `npm run gates` (or via the individual `generate-*.mjs` scripts)
and must leave `git diff` clean before every commit — the `meta_valid` CI job
enforces exactly that. The full spec (overview app columns and behaviour, the
`ui5/universe.json` + `ui5/openui5-entities.json` snapshots, api.md link
targets, the weekly `generate_result` workflow, gap-free renumbering) is in
**`.claude/skills/regenerate-artefacts/SKILL.md`** — read it before touching a
generator, a generated file, or the sidecar shape they read.

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
  `xsdbool( )`, feed a bound view attribute through `z2ui5_cl_ai_xml=>as_bool( )`.
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
  `follow_up_action` / `_event_client` (no longer a positional `t_arg` slot):
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
- Build views with `z2ui5_cl_ai_xml` (see the `port-a-sample` guide — the only
  view builder used in this repo; the class itself lives in the **abap2UI5 core
  repo** under *its* `src/02/` — not this repo's `src/02/`, which is the
  `sap.ui` port package); `client->view_display( view->stringify( ) )` as a
  standalone final statement.
- **ABAP Doc (`"!`) is parsed as HTML.** A raw `<…>` is read as an HTML tag, so
  never put a literal UI5 element (`<mvc:View>`) or any other `<tag>` in a `"!`
  comment — write it plain (`mvc:View element`) or escape it as `&lt;tag&gt;`.
  A `<tag>` there is flagged as an unsupported *and* unclosed HTML tag (was a
  warning on `z2ui5_cl_ai_xml`, and again on `z2ui5_cl_ai_frontend_simulator`
  where a placeholder `<class name>` had to become `&lt;class name&gt;`).

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
  The full story, if worth keeping, goes in the `STATUS-history.md` journal.
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
  pattern-lint rule `unescaped-brace-in-style-content` gates the `<style>` case).
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
  names (`i`, `j`, `k`) per `VALUE` block (app 234; pattern-lint rule
  `duplicate-for-iterator`).
- **After a repo rename, grep for the old `owner/name` — a
  `github.repository` guard fails SILENTLY.** The rename to `ai-demokit` left
  `abap2UI5/api` in the `auto_downport.yaml` `if:` guard (the workflow was
  *skipped*, not red, so the 702 branch silently stopped rebuilding), in the
  README badge URLs, in `package.json`, and in the repo URLs baked into
  `generate-coverage.mjs`/`generate-overview.mjs`. A skipped workflow shows no
  failure anywhere — only a grep for the old name finds this class.
- **A blocked protocol is not a blocked network** — this environment refuses
  `curl https://raw.githubusercontent.com/…` at the proxy, which reads like "no
  OpenUI5 source reachable". **`git clone https://github.com/SAP/openui5.git`
  works**, and that is the transport the pipeline (`generate_result`,
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
  model (~578 kB draft, ~30 s clicks in the in-browser demo) just to fill two
  popovers; now only bound columns are public, the full catalog stays in a
  local (`get_catalog( )` is a METHOD) and `row_of( val )` fetches the pressed
  row (draft 199 kB, clicks ~4 s). This is **not** a licence to subset a
  port's mock data — the porting recipe (`port-a-sample`) still requires the
  full row set; it is about text that is never rendered from the model.
