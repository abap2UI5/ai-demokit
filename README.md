[![ABAP_STANDARD](https://github.com/abap2UI5/api/actions/workflows/ABAP_STANDARD.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_STANDARD.yaml)
[![ABAP_CLOUD](https://github.com/abap2UI5/api/actions/workflows/ABAP_CLOUD.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_CLOUD.yaml)
[![ABAP_702](https://github.com/abap2UI5/api/actions/workflows/ABAP_702.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_702.yaml)
<br>
[![auto_cloud](https://github.com/abap2UI5/api/actions/workflows/auto_cloud.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/auto_cloud.yaml)
[![auto_downport](https://github.com/abap2UI5/api/actions/workflows/auto_downport.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/auto_downport.yaml)
<br>
[![generate_coverage](https://github.com/abap2UI5/api/actions/workflows/generate_coverage.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/generate_coverage.yaml)

# abap2UI5-api

_Last generated: <!-- last-run -->2026-07-14 09:00 UTC<!-- /last-run -->_

## What this repo does

This is an **automated repository**. Its mission: clone *every* official UI5
demo kit sample and independently rebuild it as an abap2UI5 sample — so gaps
between what UI5 offers and what abap2UI5 covers are revealed and can be closed.

A coding agent runs the pipeline:

1. **Read** — clone [OpenUI5](https://github.com/SAP/openui5) and scan every
   demo kit sample (`src/<library>/test/<library>/demokit/sample/<Name>/`).
2. **Generate** — rebuild each sample 1:1 as an abap2UI5 app (`z2ui5_if_app`),
   filed by library under `src/01`…`src/05`.
3. **Store templates** — keep the original UI5 JS/XML templates in the
   [`ui5/`](ui5) folder, one folder per port (named after the port class).
4. **Report** — regenerate [api.md](api.md) / [OVERVIEW.md](OVERVIEW.md): every
   sample marked ✅ ported / ❌ missing, with a coverage figure per module. The
   ❌ rows are the backlog.

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
- Translate the XML view control-for-control; use z2ui5_cl_xml_view for
  standard controls and z2ui5_cl_util_xml for anything not wrapped.
- Move the sample's JSON model data into ABAP (VALUE #( ... )) and bind it
  with client->_bind / _bind_edit.
- Map controller event handlers to check_on_event( ) branches.
- Use ONLY controls and properties available since UI5 1.71; never use a
  deprecated control/property. If the sample needs anything newer or
  deprecated, stop and report the gap instead of porting.
- Must pass abaplint for ABAP_STANDARD, ABAP_CLOUD and ABAP_702 (downport).
- Add ABAP Doc above the class:
    "! Generated port of a UI5 demo kit sample - not yet manually reviewed
    "! Rebuild of the UI5 demo kit sample: <demo kit url>
    "! <full sample description>
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

## Coverage & Overview

* [**api.md**](api.md) — coverage report: every UI5 demo kit sample per library,
  marked ✅ ported / ❌ missing, with a coverage figure per module. Columns link
  to the UI5 template (Javascript), the generated class (ABAP), and the live
  demo kit sample app (Link).
* [**OVERVIEW.md**](OVERVIEW.md) — the same tables plus a **System** column that
  launches each ported app in the abap2UI5 system.

Both are regenerated by the `generate_coverage` workflow
(`scripts/generate-coverage.mjs`) from the latest OpenUI5 demo kit samples — do
not edit them by hand.

#### Dependencies
* [abap2UI5](https://github.com/abap2UI5/abap2UI5)

#### Issues

For bug reports or feature requests, please open an issue in the [abap2UI5 repository.](https://github.com/abap2UI5/abap2UI5/issues)
