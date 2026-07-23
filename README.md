[![ABAP_STANDARD](https://github.com/abap2UI5/api/actions/workflows/ABAP_STANDARD.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_STANDARD.yaml)
[![ABAP_CLOUD](https://github.com/abap2UI5/api/actions/workflows/ABAP_CLOUD.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_CLOUD.yaml)
[![ABAP_702](https://github.com/abap2UI5/api/actions/workflows/ABAP_702.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_702.yaml)
<br>
[![auto_downport](https://github.com/abap2UI5/api/actions/workflows/auto_downport.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/auto_downport.yaml)
<br>
[![generate_result](https://github.com/abap2UI5/api/actions/workflows/generate_result.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/generate_result.yaml)

# abap2UI5-api

_Last generated: <!-- last-run -->2026-07-20 06:21 UTC<!-- /last-run -->_

> **This repository is AI-generated.** From every official **`sap.m`** UI5 demo
> kit sample whose control **exists since UI5 1.71** and is **not deprecated**
> (legacy-free ready) it automatically builds an abap2UI5 app, exposing the
> **functional gaps** between what UI5 offers and what abap2UI5 can already
> express — so they can be closed. Deprecated or newer controls are listed as
> out of scope; other UI5 libraries follow later.
>
> See the result in **[api.md](api.md)**, or try it live — two ways:
> - **In your browser (no backend):** open the GitHub Pages demo at
>   **https://abap2ui5.github.io/ai-demokit/** — the framework and all ports
>   run fully client-side (transpiled ABAP + sql.js WASM). Built from
>   [`web/`](web) into [`docs/`](docs); see [`web/README.md`](web/README.md).
> - **In your ABAP system:** pull this repo and start
>   **`z2ui5_cl_ai_app_overview`**, which lists every generated sample and
>   launches it right in your system.

## Pipeline

A coding agent runs the pipeline:

1. **Read** — clone [OpenUI5](https://github.com/SAP/openui5) and scan every
   `sap.m` demo kit sample (`src/sap.m/test/sap/m/demokit/sample/<Name>/`).
2. **Generate** — rebuild each sample 1:1 as an abap2UI5 app (`z2ui5_if_app`),
   filed under `src/01` in batch subpackages (`b01`, `b02`, …) — one batch of
   related samples per package.
3. **Store templates** — keep the original UI5 JS/XML templates in
   [`ui5/`](ui5), one folder per sample — only ported samples are archived;
   each batch copies its samples over from the OpenUI5 checkout.
4. **Report** — regenerate the [coverage](#coverage) tables and the in-system
   overview app. In api.md, `—` marks an in-scope sample not yet ported (the
   backlog) and `✗` an out-of-scope one (deprecated / newer than UI5 1.71).

Reviewed, curated samples graduate to the hand-maintained
[abap2UI5/samples](https://github.com/abap2UI5/samples) repository.

<details>
<summary><b>Generation prompt</b> (UI5 sample → abap2UI5 app)</summary>

<!-- prompt:start -->
```
You are porting one official UI5 demo kit sample to abap2UI5.

Input:  the sample's original files (Component.js, *.view.xml, controller,
        manifest.json) from the OpenUI5 checkout.
Output: one ABAP class z2ui5_cl_ai_app_<n> implementing z2ui5_if_app, that
        rebuilds the sample's UI and behaviour 1:1.

Rules:
- Build the view with the generic builder z2ui5_cl_ai_xml, translating the
  sample's XML 1:1 (open = descend into a container, leaf = childless
  control/stay, shut = ascend). Attributes are added with
  a( n = `key` v = `value` ) chained right after the control's open/leaf;
  a targets that control, and v is any string expression (literal, a
  client->_bind/_event result, a |...| string template). factory( )
  returns an empty root: open the mvc:View and declare its xmlns namespaces
  yourself. Blank line between controls whose verb differs (open<->leaf,
  before shut); none between same-verb controls, none right after a shut,
  none between a control and its attrs; the whole view ends in a single ).
  Booleans: literal v = `true`/`false`, or v = z2ui5_cl_ai_xml=>as_bool( flag )
  when fed from an ABAP boolean variable.
- BEFORE declaring any sample feature inexpressible, check CAPABILITIES.md -
  the map of what abap2UI5 can express, each entry backed by a proving port.
  Never improvise around a feature it marks expressible.
- Structure z2ui5_if_app~main as a dispatcher:
    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.
  Add model_init / on_event only when the app actually has data / events.
  z2ui5_if_app~main is always the FIRST method in the implementation; the
  remaining methods follow in the order they are called from main, EXCEPT
  model_init which always goes LAST (after every other method, and declared
  last in the DEFINITION too) - its large mock-data VALUE #( ) block must not
  interrupt the reading flow of the dispatcher/view/event methods.
- Always the simplest possible notation: omit parameters that equal the
  default - get_event_arg( ) not get_event_arg( 1 ) (index only for 2+).
- Move the sample's JSON model data into ABAP (VALUE #( ... )) and bind it
  with client->_bind (two-way; the former _bind_edit is obsolete - always use
  _bind). Absent JSON properties must not serialize as empty strings: `""`
  crashes enum-typed properties and overrides property defaults where the
  original's undefined picked the default - fill the UI5 default explicitly
  or split the aggregation into per-shape templates.
- Frontend actions: a whitelisted control method (CONTROL_METHODS in
  FrontendAction.js) silently drops every argument beyond its declared arg
  kinds - verify the kinds in the framework source before wiring a
  parametrized call; a needed-but-unlisted argument is a declared deviation
  plus a pr/ request, never a LIVE_TEST hope. popover_display imports
  xml + by_id (the XML parameter is `xml`, not `val`).
- Map controller event handlers to check_on_event( ) branches. To pass a value
  into an event, use the `$`-prefixed form in t_arg (a model column as
  `${COL}`, the event object as `$event.oSource.sId` / `${$source>/text}`) and
  read it back with get_event_arg( ) - a bare `{COL}` (the attribute
  property-binding form) is NOT resolved there. Transport real event/source
  values this way instead of faking a static placeholder.
- The sample's CONTROL must exist since UI5 1.71 and not be deprecated
  (out-of-scope samples are never ported). Members newer than 1.71 are KEPT
  1:1 when the original uses them - declare each in the sidecar as a
  POST_171 deviation naming the member (the property gate checks this).
- Must pass abaplint for ABAP_STANDARD, ABAP_CLOUD and ABAP_702 (downport).
- The class carries NO ABAP Doc header. Write the port's sidecar
  meta/z2ui5_cl_ai_app_<n>.json instead (sample, entity, file, batch, audit,
  status, deviations) - see AGENTS.md section 5; validate with
  node scripts/validate-meta.mjs.
- Any runtime asset URLs the sample uses (test-resources / resources images)
  also point at the OpenUI5 host (sdk.openui5.org), never SAPUI5.
- Set the abapGit <DESCRIPT> to `<entity> - <demo kit description>`.
- Follow all ABAP conventions in AGENTS.md.
```
<!-- prompt:end -->

</details>

The focus is currently on **`sap.m`** — all ports live under `src/01`, grouped
into batch subpackages `src/01/b<nn>` (one generation/review batch = one ABAP
package). Other UI5 libraries are brought back in later.

## Compatibility

Every app is ABAP Cloud ready and downportable to 7.02. In detail, every app:

* uses only **controls** available since **UI5 1.71** (16 Jan 2020), none of
  them deprecated (legacy-free ready). Individual *members* newer than 1.71
  are kept where the original sample uses them — declared per port
  (`POST_171`), so those apps need a correspondingly recent UI5;
* runs on **SAPUI5** and **OpenUI5**, including the **legacy-free** runtime;
* runs on **ABAP Cloud** and **ABAP Standard**, and downports to **7.02**.

CI enforces this on every change:

| Build            | What it does                                                    |
|------------------|----------------------------------------------------------------|
| `ABAP_STANDARD`  | `abaplint ./abaplint.jsonc` (syntax `v750`)                    |
| `ABAP_CLOUD`     | `abaplint .github/abaplint/abap_cloud.jsonc` (syntax `Cloud`)  |
| `ABAP_702`       | `npm run downport` → `abaplint .github/abaplint/abap_702.jsonc` |
| `checks`         | `pattern-lint` (distilled lessons), `structural-diff --strict` (port vs original view incl. binding values, undeclared deviations fail), `render-smoke` (headless `XMLView.create` per port), `validate-meta` + overview/coverage sync |

Every port also carries a machine-readable sidecar `meta/<class>.json`
(sample, status, declared deviations) — the source of truth the overview app,
the coverage and the structural diff read from.

## Repo map

| File | What it is |
|------|------------|
| [`AGENTS.md`](AGENTS.md) | The complete generation rulebook (conventions, skeleton, gates) |
| [`CAPABILITIES.md`](CAPABILITIES.md) | What abap2UI5 can express — each entry backed by a proving port or a source-verified trace |
| [`TRAINING.md`](TRAINING.md) | The improvement loop: batches, quality ladder, reference repositories |
| [`STATUS.md`](STATUS.md) | Point-in-time state + the open findings backlog |
| [`api.md`](api.md) | One row per demo kit sample: ported, backlog or out of scope |
| [`meta/`](meta) | One sidecar per port — status, checked, typed deviations |
| [`pr/`](pr) | Forwardable improvement requests for the abap2UI5 framework, distilled from porting gaps |

## Coverage

Coverage per UI5 library — the share of official demo kit samples that already
have an abap2UI5 port.

<!-- coverage:start -->

Overall **160 / 641** in-scope demo kit samples ported (25.0 %).
**In scope**: samples whose control exists since **UI5 1.71** and is **not deprecated** (legacy-free ready).
Out of scope: 66 of 707 samples — 16 on deprecated controls, 21 on controls newer than 1.71, 29 without control metadata.
Control metadata from OpenUI5 **1.151.0**.

| Module | Samples | In scope | Ported | Coverage | |
|--------|--------:|---------:|-------:|---------:|---|
| `sap.ui.codeeditor` | 2 | 2 | 2 | 100.0 % | ██████████ |
| `sap.ui.integration` | 4 | 4 | 2 | 50.0 % | █████░░░░░ |
| `sap.tnt` | 17 | 17 | 6 | 35.3 % | ████░░░░░░ |
| `sap.m` | 446 | 403 | 118 | 29.3 % | ███░░░░░░░ |
| `sap.ui.core` | 48 | 36 | 10 | 27.8 % | ███░░░░░░░ |
| `sap.f` | 42 | 41 | 8 | 19.5 % | ██░░░░░░░░ |
| `sap.ui.unified` | 21 | 21 | 4 | 19.0 % | ██░░░░░░░░ |
| `sap.ui.layout` | 62 | 59 | 7 | 11.9 % | █░░░░░░░░░ |
| `sap.ui.table` | 18 | 17 | 2 | 11.8 % | █░░░░░░░░░ |
| `sap.uxap` | 47 | 41 | 1 | 2.4 % | ░░░░░░░░░░ |
| **Total** | **707** | **641** | **160** | **25.0 %** | ██░░░░░░░░ |

<!-- coverage:end -->

For the full **control-level** view — one row per sample (Module · Control ·
Since · Deprecated · Sample · ABAP), every link pointing at OpenUI5 — see
**[api.md](api.md)**, or the in-system overview app `z2ui5_cl_ai_app_overview`,
where the **Sample** column links the OpenUI5 source (its ↗ opens the live
sample) and the **abap2UI5** column links the generated class (its ↗ starts the
app in the system).

The coverage summary and `api.md` are generated by the `generate_result`
workflow (`scripts/generate-coverage.mjs`), and the overview app by
`scripts/generate-overview.mjs`, both from the latest OpenUI5 demo kit
samples — do not edit them by hand.

#### Dependencies
* [abap2UI5](https://github.com/abap2UI5/abap2UI5)

#### Issues

For bug reports or feature requests, please open an issue in the [abap2UI5 repository.](https://github.com/abap2UI5/abap2UI5/issues)
