# abap2UI5 — sample coverage

One row per UI5 demo kit sample. **Control** links to the OpenUI5 API,
**Since** is the version the control was introduced, **Deprecated**
carries the deprecation version and the replacement hint from the
release's `api.json` (empty = not deprecated), **Sample** links the
source in the [OpenUI5 repository](https://github.com/SAP/openui5) and
its ↗ opens the live fullscreen sample, **ABAP** is the generated class.
`—` = in scope, not ported yet — those rows are the backlog.
`✗` = **out of scope**: the control is deprecated or newer than UI5 1.71
(not legacy-free ready / not 1.71-compatible), or the sample is not an app
view at all (UI5 test infrastructure, Component routing, view-templating and
XMLComposite authoring demos — `ui5/scope-nonapp.json`) — these samples are
listed for completeness but are not ported. A **⁺** after the class marks ports
that keep members newer than UI5 1.71 for 1:1 fidelity (declared as
POST_171 in the sidecar) — they need a correspondingly recent UI5.
See the [README](README.md#coverage) for the per-module coverage summary.

_Control metadata (Since, deprecation) from the OpenUI5 **1.152.0** `api.json`._

| Module | Control | Since | Deprecated | Sample | ABAP |
|--------|---------|:-----:|------------|--------|:----:|
| sap.m | [Button](https://sdk.openui5.org/api/sap.m.Button) |  |  | [FixtureOpen](https://github.com/SAP/openui5/tree/master/src/sap.m/test/sap/m/demokit/sample/FixtureOpen) [↗](https://sdk.openui5.org/resources/sap/ui/documentation/sdk/index.html?sap-ui-xx-sample-id=sap.m.sample.FixtureOpen&sap-ui-xx-sample-lib=sap.m) | — |
| sap.m | [List](https://sdk.openui5.org/api/sap.m.List) | 1.16 |  | [FixtureBad](https://github.com/SAP/openui5/tree/master/src/sap.m/test/sap/m/demokit/sample/FixtureBad) [↗](https://sdk.openui5.org/resources/sap/ui/documentation/sdk/index.html?sap-ui-xx-sample-id=sap.m.sample.FixtureBad&sap-ui-xx-sample-lib=sap.m) | [z2ui5_cl_dmo_app_002](https://github.com/abap2UI5/ai-demokit/blob/main/src/01/z2ui5_cl_dmo_app_002.clas.abap) |
| sap.m | [Page](https://sdk.openui5.org/api/sap.m.Page) | 1.12 |  | [FixtureGood](https://github.com/SAP/openui5/tree/master/src/sap.m/test/sap/m/demokit/sample/FixtureGood) [↗](https://sdk.openui5.org/resources/sap/ui/documentation/sdk/index.html?sap-ui-xx-sample-id=sap.m.sample.FixtureGood&sap-ui-xx-sample-lib=sap.m) | [z2ui5_cl_dmo_app_001](https://github.com/abap2UI5/ai-demokit/blob/main/src/01/z2ui5_cl_dmo_app_001.clas.abap) |
