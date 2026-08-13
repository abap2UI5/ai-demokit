---
name: regenerate-artefacts
description: Full spec of the generated artefacts (README coverage block, STATUS.md state block, api.md, the in-system overview app) and their generators: universe and openui5-entities snapshots, api.md link targets, the generate_result workflow, gap-free renumbering, plus the generator gotchas. Use when changing a generate-*.mjs script, when the meta_valid gate fails, or when touching anything between generated markers.
---

# Coverage & overview — the generated artefacts

Part of the ai-demokit rulebook — AGENTS.md §7 states the rule (four generated
artefacts, never hand-edit, `git diff` must stay clean); this guide is the full
spec.

Four generated, never hand-edited artefacts. **Never hand-edit them — edit the
scripts.**

- **`README.md`** (between the `<!-- coverage:start/end -->` markers) — the
  per-module coverage summary.
- **`STATUS.md`** (between the `<!-- state:start/end -->` markers) — the
  point-in-time state table (port/status/deviation counts, open LIVE_TESTs,
  out-of-scope ported samples), regenerated from `meta/` by
  `scripts/generate-status.mjs` so it can never drift from the corpus. The
  open-findings backlog below the block stays hand-maintained; the
  chronological journal lives in `STATUS-history.md`.
- **`api.md`** — ONE flat table, one row per UI5 demo kit sample, sorted
  module → control → sample. Columns: **Module** · **Control** (→ OpenUI5 API,
  ~~struck~~ when deprecated) · **Since** · **Deprecated** (deprecation version
  + replacement hint from the release's `api.json`, empty = not deprecated) ·
  **Sample** (→ OpenUI5 repo source, ↗ → live fullscreen sample) · **ABAP**
  (→ generated class, `—` = not ported; those rows are the backlog). There is
  no separate deprecated-controls section — everything sits in this table.
- **`src/z2ui5_cl_smpc_app_overview.clas.*`** — the in-system overview **app**:
  an abap2UI5 app that lists every ported app as one row of a `sap.m.Table`,
  sorted by module → control → sample. Columns (all plain text — links moved to
  the trailing **Open** column): **Module** · **Control** · **Since** (the UI5
  release the control appeared in) · **Sample** · **abap2UI5** (class name) ·
  **Rating** · **Open** (three buttons — the LINKS popover with the four
  reference targets, a direct app start in a new tab, and the trailing INFO
  popover with the port's generation notes). The **Control** name and the
  **Since** value come from `ui5/universe.json`, with nulls filled from the
  control-level source scan in `ui5/properties.json` (built by the linter's
  `generate-metadata.mjs`; same scope fallback as
  `generate-coverage.mjs`). **Text is never coloured**; a deprecated control's
  name is struck through (via a `sap.m.FormattedText` `htmlText`, so the
  strikethrough can vary per row — a bound `class` would not, being applied
  once at parse time) — today that strikes the known out-of-scope debt ports
  (STATUS.md open findings). The table is the only view — do not reintroduce a
  second view of the same catalog (the module→control→sample `sap.m.Tree`
  alternative was removed). The **search field** filters the table on the
  client (`binding_call` `Contains` over a per-row `filter` blob via
  `follow_up_action` — no round-trip). Each column header also carries
  client-side ascending/descending **sort** icons via the same `binding_call`
  mechanism. **Every link opens in a new browser tab** (`target="_blank"`).
  All source links point at OpenUI5; only the class + start links are local.
  The per-row URLs are built in `view_display` (the start URL needs the
  runtime system origin), the static facts come from `get_catalog`. Ports are
  numbered gap-free `z2ui5_cl_smpc_app_001..NNN` in this same overview order; a
  renumber is a repo-wide rename (class token, sidecar `class`/`file`, and
  every `app NNN` doc reference) followed by a regenerate.

```bash
node scripts/generate-coverage.mjs          # README + api.md (offline, from ui5/universe.json)
node scripts/generate-overview.mjs          # the overview app (src only, from meta/)
node scripts/generate-status.mjs            # STATUS.md state block (from meta/)
node scripts/validate-meta.mjs              # sidecar schema + referential integrity
node scripts/structural-diff.mjs [--strict] # port vs original view check
node scripts/pattern-lint.mjs               # distilled-lesson gate
```

- **`validate-meta.mjs`** checks the `meta/<class>.json` sidecars — the source
  of truth for sample/entity/status/checked/deviations (§5); `meta/` sits
  outside `src/` so abapGit ignores it. See TRAINING.md.
- **`structural-diff.mjs`** compares each port's builder-emitted view structure
  (controls + attribute names) against its archived original view.xml and fails
  (`--strict`) on any difference not covered by a declared deviation — run it
  before committing a new or changed port; every hit means: fix the port or
  declare the deviation in the sidecar.

- **Universe of samples** — `ui5/universe.json`, a committed snapshot of every
  `demokit/sample/<Name>` of the focused libraries (`FOCUS_LIBS` in
  `generate-coverage.mjs`) with entity/Since/deprecation from the release's
  `api.json`. When an OpenUI5 checkout is present (`$OPENUI5_DIR`),
  `generate-coverage.mjs` REBUILDS the snapshot from it (the weekly
  `generate_result` workflow does exactly that); offline it reads the
  snapshot, so coverage regenerates without a checkout.
- **Ported set** — the `meta/<class>.json` sidecars; a port matches a sample on
  `(library, Name)` from `meta.sample`. Ports matching no universe sample are
  reported as orphans (rename/removal upstream, or outside `FOCUS_LIBS`).
- **api.md links are external** (absolute URLs, overridable via env) and point
  at **OpenUI5** — only the ABAP column links back to this repo:
  Control → the control's OpenUI5 API reference
  (`DEMOKIT`=`https://sdk.openui5.org`/api/`<entity>`),
  Sample → the sample's source folder in the OpenUI5 repository
  (`OPENUI5`=`https://github.com/SAP/openui5`/tree/`OPENUI5_REF`/src/…/demokit/sample/`<Name>`),
  Sample ↗ → the live OpenUI5 fullscreen sample runner
  (`DEMOKIT`/resources/…/index.html?sap-ui-xx-sample-id=…&sap-ui-xx-sample-lib=…),
  ABAP → the generated `.clas.abap` (`REPO`/`REF`).

The `generate_result` workflow (`workflow_dispatch` + weekly) shallow-clones
OpenUI5, refreshes `ui5/universe.json`, regenerates coverage + overview, stamps
the `<!-- last-run -->` timestamp into `README.md`, and opens a pull request.
The overview app must stay abaplint-clean (§6) — it lives in `src/` and is part
of every CI build.


## Generator gotchas (distilled lessons — same discipline as AGENTS.md §10)

- **A sidecar text ends up inside generated ABAP — keep raw braces out of
  it.** `generate-overview.mjs` inlines every deviation `what` into the
  overview app's literals, so a NOTE quoting a CSS rule with `{ … }` next to
  the word `<style>` makes pattern-lint fire on the *generated* file, not on
  any port (app 275). Describe such things in words ("one rule: .tileLayout
  floats left").
- **A single giant `VALUE #( … )` can exceed ABAP's maximum statement
  length** — the overview's catalog hit the limit in a real system, and
  splitting it **in halves was not enough**. Split by emitted **size**, not by
  a fixed number of parts — the catalog keeps growing and every fixed part
  grows with it. `generate-overview.mjs` caps each statement at `CHUNK_CHARS`
  3000 / `CHUNK_ROWS` 6 and appends with `VALUE #( BASE result … )`, and
  hoists any single text longer than `HOIST_CHARS` into preceding
  `lv_textN = lv_textN && \`…\`` assignments (each ≤ `ASSIGN_CHARS`), so one
  oversized row cannot blow the budget on its own. Data points for the
  (undocumented) threshold: a ~226 kB statement failed, the biggest inlined
  port mock table (app 012, ~74 kB) passes — port-sized mock tables are below
  the limit, but split by size rather than trusting a margin when a block
  grows to many hundreds of long rows.
- **Coverage is measured over the IN-SCOPE backlog only.** The README's
  `Ported` column counts ports whose sample is in scope; a documented
  out-of-scope port (`ui5/scope-exceptions.json`) is listed separately, not as
  coverage — counting it made `sap.ui.core` read 19/20 while only 18 of its
  ports were in scope, and produced a **ratio > 1** the moment the batch
  closed the last real gap. That crashed the whole gate chain in
  `String.repeat` (`RangeError: Invalid count value: -1`) inside the coverage
  `bar( )`, which reads like a broken generator rather than the miscount it
  was. `bar( )` now clamps to `[0,1]`, so a future mismatch shows as a full
  bar and a wrong number instead of a stack trace — but the number is what to
  fix. Any new "n of m" figure in a generator gets the same treatment: derive
  numerator and denominator from the **same** filter.
