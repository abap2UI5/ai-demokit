[![ABAP_STANDARD](https://github.com/abap2UI5/api/actions/workflows/ABAP_STANDARD.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_STANDARD.yaml)
[![ABAP_CLOUD](https://github.com/abap2UI5/api/actions/workflows/ABAP_CLOUD.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_CLOUD.yaml)
[![ABAP_702](https://github.com/abap2UI5/api/actions/workflows/ABAP_702.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/ABAP_702.yaml)
<br>
[![auto_cloud](https://github.com/abap2UI5/api/actions/workflows/auto_cloud.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/auto_cloud.yaml)
[![auto_downport](https://github.com/abap2UI5/api/actions/workflows/auto_downport.yaml/badge.svg)](https://github.com/abap2UI5/api/actions/workflows/auto_downport.yaml)

# abap2UI5-api

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

#### Dependencies
* [abap2UI5](https://github.com/abap2UI5/abap2UI5)

#### Issues

For bug reports or feature requests, please open an issue in the [abap2UI5 repository.](https://github.com/abap2UI5/abap2UI5/issues)
