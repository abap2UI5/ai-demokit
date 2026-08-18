# fixture repo

A minimal corpus for the tooling tests (scripts/test/): two ported samples,
one open backlog row.

## Coverage

<!-- coverage:start -->

Overall **2 / 3** in-scope demo kit samples ported (66.7 %).
**In scope**: samples whose control exists since **UI5 1.71** and is **not deprecated** (legacy-free ready).
Out of scope: 0 of 3 samples — 0 on deprecated controls, 0 on controls newer than 1.71, 0 that are not app views (UI5 test infrastructure, Component routing, view-templating demos — see `ui5/scope-nonapp.json`), 0 demo apps without an owning control.
Control metadata from OpenUI5 **1.152.0**.

| Module | Samples | In scope | Ported | Coverage | |
|--------|--------:|---------:|-------:|---------:|---|
| `sap.m` | 3 | 3 | 2 | 66.7 % | ███████░░░ |
| **Total** | **3** | **3** | **2** | **66.7 %** | ███████░░░ |

<!-- coverage:end -->
