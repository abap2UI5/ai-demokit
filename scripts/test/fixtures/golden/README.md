# fixture repo

A minimal corpus for the tooling tests (scripts/test/): two ported samples,
one open backlog row and one reserved hold-out row — so the coverage golden
covers both unported states.

## Coverage

<!-- coverage:start -->

Overall **2 / 3** portable demo kit samples ported (66.7 %).
**In scope**: samples whose control exists since **UI5 1.71** and is **not deprecated** (legacy-free ready).
Out of scope: 0 of 4 samples — 0 on deprecated controls, 0 on controls newer than 1.71, 0 that are not app views (UI5 test infrastructure, Component routing, view-templating demos — see `ui5/scope-nonapp.json`), 0 demo apps without an owning control.
Control metadata from OpenUI5 **1.152.0**.

| Module | Samples | In scope | Reserved | To port | Ported | Coverage | |
|--------|--------:|---------:|---------:|--------:|-------:|---------:|---|
| `sap.m` | 4 | 4 | 1 | 3 | 2 | 66.7 % | ███████░░░ |
| **Total** | **4** | **4** | **1** | **3** | **2** | **66.7 %** | ███████░░░ |

**Reserved** — 1 in-scope sample is deliberately *not* ported. It belongs to the hold-out set (`ui5/holdout.json`, see [TRAINING.md](TRAINING.md#measuring-progress)): never used as prompt references, kept out of batch planning, and regenerated from scratch to measure the generator itself — CI-green on the first try, structural-diff violations, review findings per app. Spending one as a measurement is what ports it, so they leave this column by being used, not by being worked off. They are excluded from the coverage denominator because they are not backlog.

<!-- coverage:end -->
