---
name: scaffold-a-port
description: Batch planning rules (breadth-first then idiom-first depth, HOLDOUT rows, GROUP-nested samples) and the port scaffolding tooling - npm run scaffold, npm run json-to-abap, the OPENUI5_SRC sparse-clone recipe, scope-of pre-checks. Use when planning the next porting batch or creating a new port skeleton.
---

# Planning & scaffolding a port

Part of the ai-demokit rulebook — the scope gate itself (1.71, deprecation,
non-app families, exceptions) is defined in `AGENTS.md` §1 and is a hard CI
gate; this guide covers picking the next samples and generating the skeleton.

## Batch planning

**Batch planning is breadth-first, then idiom-first depth.** The mission is
gap discovery, and the gap yield of a port drops sharply once its control is
covered — many samples are near-duplicates on the same control. So: port
**one sample per uncovered control first**; only when every in-scope control
has at least one port does depth (more samples per control) pay. `--backlog`
encodes both phases: rows sort `NEW-CONTROL` first (control has no port at
all), then `covered-control(n)` **ascending by n** — a control with one port
still yields more new idioms than one with five. **Within equal n, pick by
idiom, not by name**: prefer the sample whose title/files show a feature no
existing port of that control exercises (a different aggregation, binding
form, event wiring, popup path — skim the sample's view/controller against
the control's existing ports), and skip true near-duplicates entirely — a
depth port that exercises nothing new is corpus weight without training
signal. Rows marked `HOLDOUT` belong to the hold-out set
(`ui5/holdout.json`, TRAINING.md) and stay out of regular batch planning.
**GROUP-nested samples** (the demo kit's group folders: `TreeTable.…`,
`p13n.…`, `UploadSetwithTablePlugin.…`, `View.…`, …) are part of the
universe — named `<Group>.<Child>`, source at `sample/<Group>/<Child>`,
archived flat as `ui5/<lib>/<Group>.<Child>/` (the scaffolder handles the
mapping); only children the docuindex lists as official samples count.


### Developer tooling — starting a port

Two helpers remove the mechanical boilerplate (they do **not** write the view —
that is the actual porting work):

- **`npm run scaffold <sample>`** (`scripts/scaffold.mjs`) — from an OpenUI5
  demo-kit sample id/name it archives the template into `ui5/<lib>/<Name>/`,
  picks the next app number, files the port into
  `src/<category>/<library>/` (AGENTS §3 — a fresh port starts in the `<= 1.71`
  half of its flavour, i.e. `src/01/<lib>/` for an OpenUI5 sample; declaring the
  first `POST_171` deviation later moves it to `src/02/<lib>/`, and
  `validate-meta` names the target folder) and stamps the batch id into the
  sidecar (`--new-batch` / `--batch bNN` — batches are meta, not folders), and
  writes the class stub, `clas.xml`, both `package.devc.xml` levels and a valid
  `meta/` sidecar. Since 2026-08-04 it **enforces the two pre-checks
  that used to be manual**: a HOLDOUT sample (`ui5/holdout.json`) and an
  out-of-scope sample (same verdict as `generate-coverage.mjs` `scopeOf`:
  1.71 floor, deprecation, non-app family — facts from the universe enriched
  with `ui5/properties.json`) are refused with the facts printed;
  `ui5/scope-exceptions.json` entries pass with a note, `--force` overrides
  as a recorded maintainer decision. The stub is a TODO placeholder view: it passes
  abaplint / pattern-lint / view-gates immediately, and
  `structural_diff` (correctly) fails until you rebuild the view 1:1. Needs an
  OpenUI5 checkout (`OPENUI5_SRC`, default `../fork-openui5`). `--dry-run` to
  preview. **`/home/user/fork-openui5` carries only `src/<lib>/src` — no
  `test/…/demokit/sample`**, so the scaffolder finds nothing there. A blobless
  sparse clone gets just the sample trees in ~350 MB:
  `git clone --filter=blob:none --sparse https://github.com/SAP/openui5.git …`
  then `git sparse-checkout set src/<lib>/test/<lib path>/demokit/sample …`,
  and point `OPENUI5_SRC` at it. **Add `src/<lib>/src` to that same sparse set**
  — `scope-of.mjs` reads the control JSDoc from there and answers
  `UNRESOLVED (no source .js found)` for *every* entity when the checkout has
  only the sample trees. That reads like "unknown control" but means "wrong
  checkout": one sparse clone must carry both halves (~170 MB for the ported
  libraries), or the scope pre-check silently stops gating.
- **`npm run json-to-abap -- <file.json> [--path k] [--fields spec] [--var v]`**
  (`scripts/json-to-abap.mjs`) — turns a JSON array (a demo mock's
  `ProductCollection` …) into an ABAP `VALUE #( … )` literal for `model_init`
  (backtick-escaping and type inference handled; also exports `rowsToAbapValue`
  / `rowsToAbapType` for reuse). The scaffolder prints the exact command when
  the sample's controller loads a JSON mock. **Type inference scans all rows**
  (not just the first): a numeric column with any decimal value is emitted as a
  **backtick string literal** (never truncated to `i`) and the tool warns on
  stderr — declare that field `TYPE p LENGTH n DECIMALS m` for a numeric control
  property (a backtick literal converts to packed), or `TYPE string` when it is
  a display-only value bound into a text template (keeps the exact decimals,
  e.g. dimensions `40.8`). Do **not** leave a decimal column as `TYPE i`.

- **`npm run form-family -- <ui5/sap.ui.layout/Sample> <class> <sample id> <out.clas.abap>`**
  (`scripts/form-family-to-abap.mjs`) — rebuilds one sample of the
  **sap.ui.layout Form/SimpleForm display-vs-change family** (apps 312..337).
  All 26 share one `Page.controller.js` (Page content swapped between
  `Display.fragment.xml` and `Change.fragment.xml`, three header Buttons,
  `bindElement('/SupplierCollection/0')`), so the port shape is fixed and only
  the fragment bodies differ: both fragments inlined and switched by the
  two-way bound `edit_mode` flag, the row-0 fields seeded at the model root and
  bound **absolutely**, Edit/Save/Cancel with a server-side clone. Deliberately
  **narrow** — it knows this family's controller, its supplier fields and its
  event names, and **throws** on an unknown `{Field}`, a missing header Button
  or a missing `Page id="page"` instead of guessing. Output is reviewed and its
  sidecar written by hand like any port; regenerating 312..337 is
  byte-identical and `structural-diff` reports 0 differences for all of them.
  Do **not** grow it into a general XML->builder converter — the porting work
  is the judgement it refuses to make.

Artefact regeneration is automated by the tracked **`.githooks/pre-commit`**
hook: on every commit it regenerates the overview app, the coverage docs and
the STATUS.md state block and stages them, so they never drift from `meta/`
(which the `meta_valid` CI job enforces on PRs). It is enabled with `git config core.hooksPath .githooks`, which
`npm ci` / `npm install` runs automatically via the `prepare` script.
