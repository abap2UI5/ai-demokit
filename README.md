![ABAP NW 7.02 to ABAP Cloud](https://img.shields.io/badge/ABAP-NW%207.02%20%E2%86%92%20Cloud-blue)
[![namespace](https://img.shields.io/badge/namespace-z2ui5__cl__smpc-blue)](abaplint.jsonc)
[![dependency](https://img.shields.io/badge/dependency-abap2UI5-blue)](https://github.com/abap2UI5/abap2UI5)
[![abap2UI5](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fabap2UI5%2Fsamples-controls%2Fmain%2F.github%2Fbadges%2Fabap2ui5.json)](#coverage)
<br>
<br>
[![abap-standard](https://github.com/abap2UI5/samples-controls/actions/workflows/abap-standard.yaml/badge.svg)](https://github.com/abap2UI5/samples-controls/actions/workflows/abap-standard.yaml)
[![abap-cloud](https://github.com/abap2UI5/samples-controls/actions/workflows/abap-cloud.yaml/badge.svg)](https://github.com/abap2UI5/samples-controls/actions/workflows/abap-cloud.yaml)
[![abap-702](https://github.com/abap2UI5/samples-controls/actions/workflows/abap-702.yaml/badge.svg)](https://github.com/abap2UI5/samples-controls/actions/workflows/abap-702.yaml)
<br>
[![check-abap2UI5](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fabap2UI5%2Fsamples-controls%2Fmain%2F.github%2Fbadges%2Fcheck-abap2ui5.json)](https://github.com/abap2UI5/samples-controls/actions/workflows/view-gates.yaml)
[![structural-diff](https://github.com/abap2UI5/samples-controls/actions/workflows/structural-diff.yaml/badge.svg)](https://github.com/abap2UI5/samples-controls/actions/workflows/structural-diff.yaml)
[![e2e-nightly](https://github.com/abap2UI5/samples-controls/actions/workflows/e2e-nightly.yaml/badge.svg)](https://github.com/abap2UI5/samples-controls/actions/workflows/e2e-nightly.yaml)

# abap2UI5 — samples-controls

**Learn how to use every UI5 control in ABAP — the UI5 Demo Kit rebuilt with
abap2UI5.**

You know the drill from the [UI5 Demo Kit](https://sdk.openui5.org): pick a
control, open its sample, copy the pattern. This repository brings that
experience to ABAP — the official demo kit samples of ten UI5 libraries
(`sap.m`, `sap.f`, `sap.ui.core`, `sap.ui.layout`, `sap.ui.table`,
`sap.ui.unified`, `sap.uxap`, `sap.tnt`, `sap.ui.codeeditor`,
`sap.ui.integration`), rebuilt 1:1 as ready-to-run abap2UI5 apps. Wondering
how to express a control in ABAP? Its sample is already here — or on its way.

#### Try it in 60 seconds

1. Install [abap2UI5](https://github.com/abap2UI5/abap2UI5).
2. Pull this repository with [abapGit](https://abapgit.org).
3. Start **`z2ui5_cl_smpc_app_000`** — every sample in one searchable
   table: each row links the original UI5 sample and its ABAP rebuild, and
   one click starts the app right in your system.

No ABAP system at hand? Open the
[searchable catalogue](https://abap2ui5.github.io/samples-controls/) — every port,
filtered by control or by the UI5 release your system runs, each one a click from
its source and from running in the browser playground.

#### The learning path

This repository is step 2 of 3 — the control reference of the abap2UI5 sample
family:

|      | Repository | What you learn | Where to start |
|------|------------|----------------|----------------|
| 1️⃣ | [**samples**](https://github.com/abap2UI5/samples) | **the abap2UI5 basics** — bindings, events, popups, navigation, complete apps | run `Z2UI5_CL_SMP_APP_000` |
| 2️⃣ | **samples-controls** — 📍 *you are here* | **how to use every UI5 control** — the UI5 Demo Kit rebuilt with abap2UI5 | run `z2ui5_cl_smpc_app_000` |
| 3️⃣ | [**samples-stack**](https://github.com/abap2UI5/samples-stack) | **how abap2UI5 plays with your stack** — OData, RAP, WebSockets, the Fiori Launchpad and more | pick your technology in its package table |

#### Learn by comparing

Every port keeps the structure of its original, so the two read side by side:
the UI5 original (JS/XML) in [`ui5/`](ui5), the ABAP rebuild in [`src/`](src),
and [api.md](api.md) as the full index — one row per demo kit sample, with
links to both. The most effective way to learn a control: open its demo kit
sample and its ABAP class next to each other and compare line by line.

<details>
<summary><b>How this repository is built</b> — the generation pipeline</summary>
<br>

This repository is generated and gated by an AI coding agent: from every
official demo kit sample of the covered libraries whose control **exists
since UI5 1.71** and is **not deprecated** (legacy-free ready), it builds an
abap2UI5 app — exposing the **functional gaps** between what UI5 offers and
what abap2UI5 can already express, so they can be closed. Deprecated or newer
controls are listed as out of scope. The pipeline:

1. **Read** — clone [OpenUI5](https://github.com/SAP/openui5) and scan every
   demo kit sample of the covered libraries
   (`src/<library>/test/<library path>/demokit/sample/<Name>/`, second segment
   with dots as slashes, e.g. `src/sap.tnt/test/sap/tnt/…`).
2. **Generate** — rebuild each sample 1:1 as an abap2UI5 app (`z2ui5_if_app`),
   filed under `src/<category>/<library>` (`src/01/01` = OpenUI5 ≤ 1.71, `sap.m`
   — see AGENTS §3); both levels are derived from the port's `meta/` sidecar.
3. **Store templates** — keep the original UI5 JS/XML templates in
   [`ui5/`](ui5), one folder per sample — only ported samples are archived;
   each batch copies its samples over from the OpenUI5 checkout.
4. **Report** — regenerate the [coverage](#coverage) tables and the in-system
   overview app. In api.md, `—` marks an in-scope sample not yet ported (the
   backlog) and `✗` an out-of-scope one (deprecated / newer than UI5 1.71).

Reviewed, curated samples graduate to the hand-maintained
[abap2UI5/samples](https://github.com/abap2UI5/samples) repository.

The **generation prompt** the porting agent is given — the condensed form of
the porting recipe — is `scripts/generation-prompt.txt`. It is the single
source: AGENTS.md §5 says when to change it, the `port-a-sample` guide is its
authoritative long form, and abap2UI5's
[mcp-server](https://github.com/abap2UI5/mcp-server) serves that same file as
its `generation_rules` rulebook.

Ports are filed by **what a system needs to run them**, then by library:
`src/01` (OpenUI5 ≤ 1.71 — the portable half), `src/02` (needs a UI5 runtime
newer than 1.71) and, under each, one package per library (`01` = `sap.m`,
`02` = `sap.ui.*`, `03` = `sap.uxap`, `04` = `sap.f`, `05` = `sap.tnt`).
`src/03` is flat and is not ports at all: it collects hand-written samples for
SAPUI5-only controls, which have no OpenUI5 original to rebuild against. Both
levels are derived from the port's `meta/` sidecar, never chosen — see AGENTS
§3 for the folder tables. The generation/review batch a port came from is
recorded in its `meta/<class>.json`, not in the tree. The browser demo is
built from [`web/`](web) and published by `deploy-web`; see
[`web/README.md`](web/README.md).

#### Repo map

| File | What it is |
|------|------------|
| [`AGENTS.md`](AGENTS.md) | The complete generation rulebook (conventions, skeleton, gates) — [`CLAUDE.md`](CLAUDE.md) points here |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | How to change a generated repository: what not to hand-edit, and the commands CI runs |
| [`CAPABILITIES.md`](CAPABILITIES.md) | What abap2UI5 can express — each entry backed by a proving port or a source-verified trace |
| [`TRAINING.md`](TRAINING.md) | The improvement loop: batches, quality ladder, reference repositories |
| [`STATUS.md`](STATUS.md) | Generated point-in-time state + the open findings backlog |
| [`E2E.md`](E2E.md) | How to run and debug the Playwright e2e smoke against the real transpiled backend |
| [`SAMPLES.md`](SAMPLES.md) | The catalogue: every port with what it shows, grouped by UI5 library — the same page shape as [samples](https://github.com/abap2UI5/samples/blob/main/SAMPLES.md) and [samples-stack](https://github.com/abap2UI5/samples-stack/blob/main/SAMPLES.md) |
| [`api.md`](api.md) | One row per demo kit sample: ported, backlog or out of scope |
| [`meta/`](meta) | One sidecar per port — status, checked, typed deviations |
| [`ui5/`](ui5) | The archived original demo kit template of every ported sample, plus the scope/universe snapshots the coverage is computed from |
| [`scripts/`](scripts) | The generators and the gates — one script per CI job, plus `generation-prompt.txt`, the porting agent's prompt |
| [`web/`](web) | The GitHub Pages site: the searchable catalogue of every port |
| [`docs/history.md`](docs/history.md) | The chronological journal — batches, probes, audits, one section per event |
| [`docs/upstream-requests.md`](docs/upstream-requests.md) | The record of what porting asked the framework for — implemented and declined. Open requests live in [`backlog/`](https://github.com/abap2UI5/abap2UI5/tree/main/backlog) in abap2UI5, where the whole ecosystem's upstream backlog is |
| [mcp-server](https://github.com/abap2UI5/mcp-server) | MCP server for AI coding agents — capability queries, view validation, deploy, headless run + screenshot on this repo's infrastructure (separate repository) |
| [abap2UI5-linter](https://github.com/abap2UI5/linter) | The view gates as standalone CLI, library and GitHub Action — extracted from this repo and now used BY it (`scripts/view-gates.mjs`) |

</details>

## Compatibility

Every app is ABAP Cloud ready and downportable to 7.02. In detail, every app:

* uses only **controls** available since **UI5 1.71** (16 Jan 2020), none of
  them deprecated (legacy-free ready). Individual *members* newer than 1.71
  are kept where the original sample uses them — declared per port
  (`POST_171`), so those apps need a correspondingly recent UI5;
* runs on **SAPUI5** and **OpenUI5**, including the **legacy-free** runtime;
* runs on **ABAP Cloud** and **ABAP Standard**, and downports to **7.02**.

CI enforces this on every change:

Each check is a workflow of its own, so a red badge names the thing that is
actually broken:

| Workflow | What it does |
|----------|--------------|
| `abap-standard` | `abaplint ./abaplint.jsonc` (syntax `v750`) |
| `abap-cloud` | `abaplint .github/abaplint/abap_cloud.jsonc` (syntax `Cloud`) |
| `abap-702` | `npm run downport` → `abaplint .github/abaplint/abap_702.jsonc` |
| `view-gates` | abap2UI5-linter per port: UI5 metadata, builder structure, headless `XMLView.create` — plus `check:collection` for the SAPUI5-only classes |
| `structural-diff` | port vs. original view incl. binding values; an undeclared deviation fails |
| `data-fidelity` | seeded values vs. the archived sample mocks |
| `pattern-lint` | the corpus-policy rules distilled from review findings |
| `chain-format` | the view-chain layout (`npm run fmt:chains` fixes it) |
| `meta-valid` | sidecar schema + referential integrity, and every generated artefact in sync |
| `check-pins` | the abap2UI5 pin policy (`A2UI5_PIN`, no stray dependency branch) |
| `check-app-rules`, `check-keywords`, `check-summary`, `check-prose-names` | the shared abaplint app rules, the `@keywords`/`@summary` lines, and every class name written in prose |
| `tooling-tests` | the gate/generator tooling's own fixture tests |
| `e2e-nightly` | every port booted as the real app in headless Chromium (scheduled) |

Every port also carries a machine-readable sidecar `meta/<class>.json`
(sample, status, declared deviations) — the source of truth the overview app,
the coverage and the structural diff read from.

## Coverage

Coverage per UI5 library — the share of official demo kit samples that already
have an abap2UI5 port.

<!-- coverage:start -->

Overall **432 / 629** in-scope demo kit samples ported (68.7 %).
**In scope**: samples whose control exists since **UI5 1.71** and is **not deprecated** (legacy-free ready).
Out of scope: 113 of 742 samples — 21 on deprecated controls, 52 on controls newer than 1.71, 37 that are not app views (UI5 test infrastructure, Component routing, view-templating demos — see `ui5/scope-nonapp.json`), 3 demo apps without an owning control.
Plus **5** ported samples outside that scope — maintainer-decided exceptions (`ui5/scope-exceptions.json`, listed in [STATUS.md](STATUS.md)); they are not counted as coverage of the in-scope backlog.
Control metadata from OpenUI5 **1.152.0**.

| Module | Samples | In scope | Ported | Coverage | |
|--------|--------:|---------:|-------:|---------:|---|
| `sap.tnt` | 17 | 17 | 17 | 100.0 % | ██████████ |
| `sap.ui.codeeditor` | 2 | 2 | 2 | 100.0 % | ██████████ |
| `sap.ui.core` | 63 | 20 | 20 | 100.0 % | ██████████ |
| `sap.ui.integration` | 4 | 4 | 4 | 100.0 % | ██████████ |
| `sap.ui.layout` | 61 | 61 | 61 | 100.0 % | ██████████ |
| `sap.ui.table` | 21 | 21 | 21 | 100.0 % | ██████████ |
| `sap.ui.unified` | 22 | 22 | 21 | 95.5 % | ██████████ |
| `sap.uxap` | 45 | 45 | 31 | 68.9 % | ███████░░░ |
| `sap.m` | 461 | 403 | 238 | 59.1 % | ██████░░░░ |
| `sap.f` | 46 | 34 | 17 | 50.0 % | █████░░░░░ |
| **Total** | **742** | **629** | **432** | **68.7 %** | ███████░░░ |

<!-- coverage:end -->

For the full **control-level** view — one row per sample (Module · Control ·
Since · Deprecated · Sample · ABAP), every link pointing at OpenUI5 — see
**[api.md](api.md)**, or the in-system overview app `z2ui5_cl_smpc_app_000`,
where the **Sample** column links the OpenUI5 source (its ↗ opens the live
sample) and the **abap2UI5** column links the generated class (its ↗ starts the
app in the system).

The coverage summary and `api.md` are generated by the `generate-result`
workflow (`scripts/generate-coverage.mjs`), and the overview app by
`scripts/generate-overview.mjs`, both from the latest OpenUI5 demo kit
samples — do not edit them by hand.

#### Dependencies
* [abap2UI5](https://github.com/abap2UI5/abap2UI5)

#### Issues

For bug reports or feature requests, please open an issue in the [abap2UI5 repository.](https://github.com/abap2UI5/abap2UI5/issues)

---

_Last generated: <!-- last-run -->2026-08-17 03:53 UTC<!-- /last-run -->_
