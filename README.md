[![ABAP_STANDARD](https://github.com/abap2UI5/api/actions/workflows/ABAP_STANDARD.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_STANDARD.yaml)
[![ABAP_CLOUD](https://github.com/abap2UI5/api/actions/workflows/ABAP_CLOUD.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_CLOUD.yaml)
[![ABAP_702](https://github.com/abap2UI5/api/actions/workflows/ABAP_702.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_702.yaml)
<br>
[![auto_downport](https://github.com/abap2UI5/api/actions/workflows/auto_downport.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/auto_downport.yaml)
<br>
[![generate_result](https://github.com/abap2UI5/api/actions/workflows/generate_result.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/generate_result.yaml)

# abap2UI5-api

_Last generated: <!-- last-run -->2026-07-14 09:00 UTC<!-- /last-run -->_

> **This repository is AI-generated.** From *every* official UI5 demo kit sample
> it automatically builds an abap2UI5 app, exposing the **functional gaps**
> between what UI5 offers and what abap2UI5 can already express — so they can be
> closed.
>
> See the result in **[api.md](api.md)**, or try it live: pull this repo into
> your ABAP system and start **`z2ui5_cl_api_app_overview`**, which lists every
> generated sample and launches it right in your system.

## Pipeline

A coding agent runs the pipeline:

1. **Read** — clone [OpenUI5](https://github.com/SAP/openui5) and scan every
   demo kit sample (`src/<library>/test/<library>/demokit/sample/<Name>/`).
2. **Generate** — rebuild each sample 1:1 as an abap2UI5 app (`z2ui5_if_app`),
   filed by library under `src/01`…`src/05`.
3. **Store templates** — keep the original UI5 JS/XML templates in
   [`ui5/`](ui5), one folder per port (named after the port class).
4. **Report** — regenerate the [coverage](#coverage) tables and the in-system
   overview app, marking every sample ✅ ported or ❌ missing. The ❌ rows are
   the backlog.

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
- Add ABAP Doc above the class (line 1 fixed; line 2 `<entity> - <SampleName>`;
  line 3 the OpenUI5 demo kit url on sdk.openui5.org, never the commercial
  SAPUI5 host):
    "! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
    "! <entity> - <SampleName>
    "! https://sdk.openui5.org/entity/<entity>/sample/<lib>.sample.<Name>
- Any runtime asset URLs the sample uses (test-resources / resources images)
  also point at the OpenUI5 host (sdk.openui5.org), never SAPUI5.
- Set the abapGit <DESCRIPT> to `<entity> - <demo kit description>`.
- Follow all ABAP conventions in AGENTS.md.
```

</details>

Ports are split by library:

| Folder    | Library    |
|-----------|------------|
| `src/01`  | `sap.m`    |
| `src/02`  | `sap.ui`   |
| `src/03`  | `sap.uxap` |
| `src/04`  | `sap.f`    |
| `src/05`  | `sap.tnt`  |

## Compatibility

Every app is ABAP Cloud ready and downportable to 7.02. In detail, every app:

* uses only controls and properties available since **UI5 1.71** (16 Jan 2020),
  none of them deprecated — so it runs on old UI5 versions too;
* runs on **SAPUI5** and **OpenUI5**, including the **legacy-free** runtime;
* runs on **ABAP Cloud** and **ABAP Standard**, and downports to **7.02**.

CI enforces this on every change:

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

For the full **control-level** view — one row per sample (Module · Control ·
Sample · JavaScript · UI5 App · ABAP), every link pointing at OpenUI5 — see
**[api.md](api.md)**, or the in-system overview app `z2ui5_cl_api_app_overview`,
where the **Sample** column opens the live OpenUI5 sample and the **abap2UI5 App**
column (the app's class name) starts each app in the system.

The coverage summary and `api.md` are generated by the `generate_result`
workflow (`scripts/generate-coverage.mjs`), and the overview app by
`scripts/generate-overview.mjs`, both from the latest OpenUI5 demo kit
samples — do not edit them by hand.

#### Dependencies
* [abap2UI5](https://github.com/abap2UI5/abap2UI5)

#### Issues

For bug reports or feature requests, please open an issue in the [abap2UI5 repository.](https://github.com/abap2UI5/abap2UI5/issues)
