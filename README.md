[![ABAP_STANDARD](https://github.com/abap2UI5/api/actions/workflows/ABAP_STANDARD.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_STANDARD.yaml)
[![ABAP_CLOUD](https://github.com/abap2UI5/api/actions/workflows/ABAP_CLOUD.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_CLOUD.yaml)
[![ABAP_702](https://github.com/abap2UI5/api/actions/workflows/ABAP_702.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_702.yaml)
<br>
[![auto_downport](https://github.com/abap2UI5/api/actions/workflows/auto_downport.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/auto_downport.yaml)
<br>
[![generate_coverage](https://github.com/abap2UI5/api/actions/workflows/generate_coverage.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/generate_coverage.yaml)

# abap2UI5-api

_Last generated: <!-- last-run -->2026-07-14 09:00 UTC<!-- /last-run -->_

> **This repository is AI-generated.** From *every* official UI5 demo kit sample
> it automatically builds an abap2UI5 app — so **functional gaps** between what
> UI5 offers and what abap2UI5 can already express are revealed and can be closed.
>
> See the result in **[api.md](api.md)**. To try it live, **pull this repo into
> your ABAP system and start the app `z2ui5_cl_api_app_overview`** — it lists
> every generated sample and launches it right in your system.

A coding agent runs the pipeline:

1. **Read** — clone [OpenUI5](https://github.com/SAP/openui5) and scan every
   demo kit sample (`src/<library>/test/<library>/demokit/sample/<Name>/`).
2. **Generate** — rebuild each sample 1:1 as an abap2UI5 app (`z2ui5_if_app`),
   filed by library under `src/01`…`src/05`.
3. **Store templates** — keep the original UI5 JS/XML templates in the
   [`ui5/`](ui5) folder, one folder per port (named after the port class).
4. **Report** — regenerate the [coverage](#coverage) (README + [api.md](api.md))
   and the in-system overview app: every sample marked ✅ ported / ❌ missing,
   with a coverage figure per module. The ❌ rows are the backlog.

Reviewed, curated samples graduate to the hand-maintained
[abap2UI5/samples](https://github.com/abap2UI5/samples) repository.

<details>
<summary><b>Generation prompt</b> (UI5 sample → abap2UI5 app)</summary>

```
You are porting one official UI5 demo kit sample to abap2UI5.

Input:  the sample's original files (Component.js, *.view.xml, controller,
        manifest.json) from the OpenUI5 checkout.
Output: one ABAP class z2ui5_cl_api_app_<n> implementing z2ui5_if_app, that
        rebuilds the sample's UI and behaviour 1:1.

Rules:
- Build the view with the generic builder z2ui5_cl_api_xml, translating the
  sample's XML 1:1 (open = descend into a container, leaf = childless
  control/stay, shut = ascend). Attributes are added with
  attr( n = `key` v = `value` ) chained right after the control's open/leaf;
  attr targets that control, and v is any string expression (literal, a
  client->_bind/_event result, a || template). factory( ) returns an empty root
  - open the <mvc:View> and declare its xmlns namespaces yourself. Blank line
  between controls whose verb differs (open<->leaf, before shut); none between
  same-verb controls, none right after a shut, none between a control and its
  attrs; the whole view ends in a single ). Booleans: literal
  v = `true`/`false`, or v = z2ui5_cl_api_xml=>as_bool( flag ) when fed from an
  ABAP boolean variable.
- Structure z2ui5_if_app~main as a dispatcher:
    me->client = client.
    IF client->check_on_init( ).
      data_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.
  Add data_init / on_event only when the app actually has data / events.
- Move the sample's JSON model data into ABAP (VALUE #( ... )) and bind it
  with client->_bind / _bind_edit.
- Map controller event handlers to check_on_event( ) branches.
- Use ONLY controls and properties available since UI5 1.71; never use a
  deprecated control/property. If the sample needs anything newer or
  deprecated, stop and report the gap instead of porting.
- Must pass abaplint for ABAP_STANDARD, ABAP_CLOUD and ABAP_702 (downport).
- Add ABAP Doc above the class (the demo kit url is the OpenUI5 one on
  sdk.openui5.org, never the commercial SAPUI5 host):
    "! Generated port of a UI5 demo kit sample - not yet manually reviewed
    "! Rebuild of the UI5 demo kit sample: https://sdk.openui5.org/entity/<entity>/sample/<lib>.sample.<Name>
    "! <full sample description>
- Any runtime asset URLs the sample uses (test-resources / resources images)
  also point at the OpenUI5 host (sdk.openui5.org), never SAPUI5.
- Set the abapGit <DESCRIPT> to `<entity> - <demo kit description>`.
- Follow all ABAP conventions in AGENTS.md.
```

</details>

Generated abap2UI5 ports of the official UI5 demo kit samples, split by library:

| Folder    | Library    |
|-----------|------------|
| `src/01`  | `sap.m`    |
| `src/02`  | `sap.ui`   |
| `src/03`  | `sap.uxap` |
| `src/04`  | `sap.f`    |
| `src/05`  | `sap.tnt`  |

Every app is ABAP Cloud ready and downportable to 7.02 — validated by the three
CI checks below.

#### Compatibility

* Every control and property used is available since **UI5 1.71** (16 Jan 2020),
  so the samples run on old UI5 versions too.
* No sample uses an obsolete (deprecated) control or property.
* All samples run on both **SAPUI5** and **OpenUI5**.
* All samples can be booted with the UI5 **legacy-free** runtime.
* All samples run on both **ABAP Cloud** and **ABAP Standard**.
* All samples can be **downported** with abaplint (down to 7.02).

#### Checks

| Build            | What it does                                                    |
|------------------|----------------------------------------------------------------|
| `ABAP_STANDARD`  | `abaplint ./abaplint.jsonc` (syntax `v750`)                    |
| `ABAP_CLOUD`     | `abaplint .github/abaplint/abap_cloud.jsonc` (syntax `Cloud`)  |
| `ABAP_702`       | `npm run downport` → `abaplint .github/abaplint/abap_702.jsonc` |

## Coverage

Coverage per UI5 library — the share of official demo kit samples that already
have an abap2UI5 port.

<!-- coverage:start -->

Overall **132 / 720** demo kit samples ported (18.3 %).

| Module | Samples | Ported | Coverage | |
|--------|--------:|-------:|---------:|---|
| `sap.uxap` | 47 | 14 | 29.8 % | ███░░░░░░░ |
| `sap.ui.integration` | 4 | 1 | 25.0 % | ███░░░░░░░ |
| `sap.ui.layout` | 62 | 15 | 24.2 % | ██░░░░░░░░ |
| `sap.ui.core` | 48 | 9 | 18.8 % | ██░░░░░░░░ |
| `sap.m` | 446 | 83 | 18.6 % | ██░░░░░░░░ |
| `sap.tnt` | 17 | 3 | 17.6 % | ██░░░░░░░░ |
| `sap.f` | 42 | 4 | 9.5 % | █░░░░░░░░░ |
| `sap.ui.unified` | 21 | 2 | 9.5 % | █░░░░░░░░░ |
| `sap.ui.table` | 18 | 1 | 5.6 % | █░░░░░░░░░ |
| `sap.ui.codeeditor` | 2 | 0 | 0.0 % | ░░░░░░░░░░ |
| `sap.ui.mdc` | 13 | 0 | 0.0 % | ░░░░░░░░░░ |
| **Total** | **720** | **132** | **18.3 %** | ██░░░░░░░░ |

<!-- coverage:end -->

Detailed, **control-level** view — one table per module, one row per sample:

* [**api.md**](api.md) — one flat table mirroring the overview app: Module ·
  Control (→ OpenUI5 API) · Sample · JavaScript (→ OpenUI5 repo source) · UI5 App
  (→ live OpenUI5 fullscreen sample) · ABAP (→ generated class). All source links
  point at OpenUI5; only the "start the app" column is dropped (static page).
* **Overview app** (`z2ui5_cl_api_app_overview`) — an abap2UI5 app in `src/`
  that lists every ported app as a table (Module · Control · Sample ·
  JavaScript · UI5 App · ABAP · abap2UI5 App), each link opening in a new tab
  and the last one **starting the app in the system**
  (generated by `scripts/generate-overview.mjs`).

The coverage summary and `api.md` are regenerated by the `generate_coverage`
workflow (`scripts/generate-coverage.mjs`) from the latest OpenUI5 demo kit
samples — do not edit them by hand.

#### Dependencies
* [abap2UI5](https://github.com/abap2UI5/abap2UI5)

#### Issues

For bug reports or feature requests, please open an issue in the [abap2UI5 repository.](https://github.com/abap2UI5/abap2UI5/issues)
