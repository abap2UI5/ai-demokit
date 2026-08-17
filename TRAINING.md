# TRAINING.md — using this repo to train the porting agent

**Status: implemented** — the metadata sidecars (`meta/`, validated by
`scripts/validate-meta.mjs`) are the source of truth, the port classes carry
no ABAP Doc header at all (stage-2 inversion done 2026-07-16, enforced by
pattern-lint), and the structural view diff (`scripts/structural-diff.mjs`)
runs clean. This file describes how the repo is meant to make the generating
agent better over time. "Training" here means improving the system around the
agent — rules, reference examples, verification loops — not (yet) fine-tuning
model weights.

## The flywheel

The agent improves through three artifacts, all versioned in this repo:

1. **Rules** — `AGENTS.md` (conventions, gotchas) and `CAPABILITIES.md` (what
   abap2UI5 can express, with proving ports). These are the agent's memory.
2. **Reference examples** — verified sample↔port pairs the generation prompt
   receives as references. One good example outweighs ten rules.
3. **Verification loops** — everything that catches an error before a human
   has to: abaplint ×3, validate-meta, the structural view diff, pattern-lint,
   the AI review pass, the in-system live check.

The cycle per batch:

```
generate  →  verify (CI + structural diff)  →  AI review  →  live check (human)
    ↑                                                             │
    └──── distill: every fix becomes a rule (AGENTS/CAPABILITIES) ┘
                   + the corrected port stays as a reference example
```

**Distillation is a mandatory step, not a habit.** A manual correction that does
not flow back as (a) a rule and (b) a reference example is wasted training signal.

## The batch process

Work happens in batches of ~10 related samples (one control family), each one
PR. A batch is **not** a package: ports go straight into their library package
`src/<NN>/` (flat, AGENTS §3), and the batch id lives in the `batch` field of
each port's `meta/<class>.json`. Per batch:

1. **Generate** — the agent picks ~10 related samples from the in-scope
   backlog (`node scripts/generate-coverage.mjs --backlog` — only controls that
   exist since UI5 1.71 and are not deprecated, see AGENTS §1) and ports them
   under a new `b<nn>` batch id (`npm run scaffold … --new-batch`), prompt fed
   with AGENTS.md, CAPABILITIES.md and
   the 2–3 nearest `checked` ports. Pick **breadth-first**: `NEW-CONTROL` rows
   (control not covered by any port yet) before further samples of covered
   controls, and never rows marked `HOLDOUT` (see below) — one port per
   control maximizes gap discovery per port. Once breadth is exhausted, pick
   **idiom-first depth**: lowest `covered-control(n)` first, and within equal
   n only samples that exercise something no existing port of that control
   does — skip true near-duplicates (AGENTS §1).
2. **Machine-verify until green** — abaplint ×3, `validate-meta`,
   `structural-diff --strict`, `pattern-lint`, plus an adversarial AI review
   pass. The agent
   fixes its own findings. Human time is the scarcest resource in this loop —
   it must only be spent on what machines cannot see.
3. **Human live check** — pull the batch package via abapGit, start every app,
   correct in the system, push corrections back as their own commits
   (separate from generation, so the diff *is* the training signal); promote
   the port in its sidecar (`status: "checked"` + `checked {date, note}`).
4. **Distill** — the agent classifies every human correction: fidelity bug →
   rule in AGENTS/CAPABILITIES **and, where greppable, a deterministic check**
   (structural diff / pattern lint), style → convention update, new technique →
   CAPABILITIES row, framework limitation → an item in the stock
   (`backlog/items/<id>.md` in `abap2UI5/abap2UI5`, one file per request). Corrected ports become `checked`; the journal
   entry goes into STATUS-history.md in the same change (the STATUS.md state
   block regenerates itself via generate-status.mjs).
5. **Regression probe** (every few batches) — re-generate a handful of
   `checked` reference ports plus the hold-out set from scratch with the current setup
   and diff: a re-appearing old mistake means the rule was too weak.
   Corrections-per-batch is the improvement curve; it must trend down.

A batch is closed once merged — follow-ups amend the port in place, new ports
get the next `b<nn>` batch id.

## Reference repositories

Three read-only reference sources feed the loop (policy since 2026-07-16; two
standing clones plus OpenUI5 on demand — clone them into the session when
generating or reviewing):

- **`abap2UI5/abap2UI5`** (framework, main) — the truth about what is
  *possible*. Capability questions are answered by reading the source
  (public API surface only: `z2ui5_if_client` and what it reaches — never
  build on internals) and recorded in CAPABILITIES.md as **source-verified**.
  A live check remains the final confirmation for rendering/UX.
- **`abap2UI5/samples`** (branch `main`) — the truth about what is *idiomatic*.
  Its samples live **flat in `src/01`**: the `01/01` "Basic I" / `01/02`
  "Basic II" / `01/03` "Control Library" split was flattened away on
  2026-08-12, and `01/03` is gone altogether — its demo kit rebuilds are
  collected HERE (AGENTS.md §1), so no tree there is a coverage reference any
  more. What that repository holds back by maturity or purpose sits in
  `src/00/97` and `src/00/98`. Canonical external references for generation
  prompts: `src/01/z2ui5_cl_smp_app_027` (expression binding),
  `src/01/z2ui5_cl_smp_app_012` (popup/popover paths),
  `src/01/z2ui5_cl_smp_app_167` (event args via `t_arg`).

  **The view-building idiom DOES transfer — imitate it.** All three
  repositories build views with the same generic `z2ui5_cl_ui5_view_builder`:
  every class in samples that builds a view builds it with that builder, and
  the handful that do not name it build no view at all (two shared helper
  classes in `src/00/01`, three `ZZZ` data containers). Not one class there
  still uses the frozen typed `z2ui5_cl_xml_view` — a `grep -rl
  z2ui5_cl_xml_view src` over that repository returns nothing, and the last
  classes anywhere in the ecosystem that used it, the `src/03` SAPUI5
  collection HERE, were migrated on 2026-08-15 (AGENTS.md §3). Until 2026-08-17
  this file claimed the opposite and concluded "view-building idiom does not
  transfer" — the most expensive sentence it ever carried, because it aimed the
  agent away from ~150 correct worked examples of the builder this repo uses.

  The class metadata transferred too: samples' `" @keywords` / `" @summary`
  are plain `"` comments, deliberately **not** ABAP Doc, and every port here
  carries the same two lines (generated by `npm run keywords` /
  `npm run summary`, AGENTS.md "Metadata"). The rule that a port carries no
  ABAP Doc header is about `"!`, not about those lines.

  **What genuinely does not transfer**, because this repo's rules say
  otherwise:
  - **Method order** — a port puts `z2ui5_if_app~main` FIRST and the rest in
    call order from it (pattern-lint `main-not-first`, `model-init-last`).
    samples does not gate method order and is mixed.
  - **Dispatch** — samples dispatches 2–3 events inline in the lifecycle chain
    (``ELSEIF client->check_on_event( `SAVE` )``, its AGENTS.md §9); a port
    dispatches in `on_event`, as a `CASE client->get_event( )` or — for a
    single event — an ``IF client->get_event( ) = `X`.``, since abaplint's
    `short_case` forbids a one-branch `CASE` (AGENTS.md §6).

  Where the two conflict, THIS repo's AGENTS.md wins.
- **`UI5/openui5`** (upstream, on demand) — the truth about what **UI5**
  does. Do NOT keep a standing full clone; use a sparse, blob-filtered
  checkout of what a question needs (`git clone --depth 1 --filter=blob:none
  --sparse …`, then `git sparse-checkout set src/sap.m/src/sap/m …`).
  Three uses: (a) copy each new batch's sample originals into
  `ui5/<lib>/<Name>/`, (b) verify UI5-side behavior claims in the control
  sources (e.g. the default group header in `ComboBoxBase`, the
  `EventHandlerResolver` for `$`-args — both verified 2026-07-16),
  (c) property-level `@since` metadata for the 1.71 property gate
  (the linter's `generate-metadata.mjs` → `ui5/properties.json`).

## Quality ladder

Every port sits on exactly one rung; `checked` ports may be used as prompt
references. They no longer graduate out to the curated samples repo — since
2026-08-12 the demo kit rebuilds stay here (AGENTS.md §1), so `checked` is the
top rung rather than a hand-off.

| Status | Meaning | Gate |
|---|---|---|
| `generated` | fresh from the pipeline | abaplint ×3 green |
| `reviewed` | AI review found nothing undeclared | review pass with zero open findings |
| `checked` | manually verified in a running system | `checked {date, note}` set in the sidecar |

> The `golden` rung (checked + exemplary, human-picked) was **retired
> 2026-07-22** — there is no separate golden category for now; former golden
> ports are plain `checked` and, like any port, may be refactored to the current
> conventions. A `checked` port that reads as an exemplar just stays `checked`.

A promotion certifies the **code at check time**: any behavioral rework of a
`checked` port drops it back to `generated` (keep the old check as
context in a `LIVE_TEST` deviation) until a fresh live run restamps it —
see the AGENTS §10 gotcha (app 003, 2026-07-19).

## Per-port metadata

**Implemented (stage 2):** `meta/<class>.json` is the source of truth — the
generator writes it together with the class, the port classes carry **no**
ABAP Doc header (pattern-lint blocks `"!` lines in ports), and the overview
app + coverage tables are generated from the sidecars.
`scripts/validate-meta.mjs` guards schema and referential integrity in CI.
Status promotions (`checked` after a live check, or `reviewed`) are
edited directly in the sidecar. The shape:

```jsonc
{
  "class":   "z2ui5_cl_smpc_app_040",
  "sample":  "sap.m.sample.MultiInput",
  "entity":  "sap.m.MultiInput",
  "file":    "src/01/01/z2ui5_cl_smpc_app_040.clas.abap",
  "batch":   "b02",
  "audit":   { "frontend_action": false, "event_t_arg": false },
  "status":  "generated",              // generated | reviewed | checked
  "checked": { "date": "2026-07-15", "note": "verified in a running system - ..." },
  "deviations": [
    { "type": "POST_171",    "what": "showClearIcon (since UI5 1.94) kept for the 1:1 port ..." },
    { "type": "IMPROVISED",  "what": "the controller's addValidator is dropped ..." },
    { "type": "LIVE_TEST",   "what": "confirm ... in a running system" }
  ]
}
```

Deviation types are closed vocabulary (`IMPROVISED`, `POST_171` — a kept
member newer than UI5 1.71, `DROPPED_171` — a member that could not be
expressed, `LIVE_TEST`, `NOTE`; `SUBSET_DATA` is retired — `validate-meta`
rejects it, full mock data is required) so they can be counted: "how often
does the agent improvise unnecessarily" becomes a query, not an impression.

## Verification: structural view diff

abaplint proves syntax, not fidelity — a port can be CI-green and render an
empty control (it happened: app 040 lost its pre-set tokens).
**Implemented:** `scripts/structural-diff.mjs` compares the original
`view.xml` control structure (control multiset + attribute-name sets) against
the builder calls parsed from the ABAP port, and matches every difference
against the port's declared deviations in `meta/`:

> difference found in the diff but not declared → **fail** (`--strict`).

All ports run at 0 undeclared differences (`structural-diff --strict` is part
of `npm run gates`). Known limits:
controller-created UI is invisible on the view.xml side (it shows as EXTRA in
the port), and loop-built view parts (`[dynamic]`) exempt count checks for the
looped controls. Values are not compared — that stays with review/live checks.

## Measuring progress

- **Hold-out set — defined in [`ui5/holdout.json`](ui5/holdout.json):**
  24 samples spread across control families and complexity (display, input,
  lists/tables, popups, navigation). Rules: they are **never used as prompt
  references**, they stay **out of regular batch planning** (`--backlog`
  marks them `HOLDOUT`), and a hold-out port is never promoted to `checked`.
  A regeneration probe = generate them from scratch with the current
  rules/references and score: CI green on first try, structural-diff
  violations, view-gate failures, review findings per app. Improvement
  becomes a number per generation run. ~~Run the first probe before batch
  b05 lands~~ — **probe #1 ran 2026-07-19**; the baseline (protocol + all
  numbers: 21/25 CI-green first try, 4 undeclared structural diffs,
  0 genuine render failures, 6 MAJOR / 5 MINOR review findings across
  3 root causes) lives in
  [`probes/holdout-2026-07-19.md`](probes/holdout-2026-07-19.md). Repeat
  the protocol identically for every future probe and compare against that
  file — probe #2 (2026-07-26) is in
  [`probes/holdout-2026-07-26.md`](probes/holdout-2026-07-26.md).
- **Regeneration diff:** re-run old ports with the improved setup and diff
  against their checked version.

## Preconditions on data quality

Training signal is only as good as the stored pairs:

- `ui5/<library>/<SampleName>/` must archive **everything** `manifest.json` lists under
  `sample.files` **plus** any mock data used — done since 2026-07-16: the
  missing `Table.view.xml` was fetched and the shared demo kit mock data
  (`products.json`, `img.json`, `countriesExtendedCollection.json`) is
  snapshotted under `ui5/mock/` (provenance + verification in its README).
  Keep it that way for every new port, so ports stop silently truncating rows
  and fidelity stays verifiable offline.
- The header/metadata pipeline must never lose labels silently
  (the 2026-07-16 `generate-overview.mjs` parser rewrite fixed two such cases).

## Fine-tuning (later)

The pair structure (sample files + capability context → ABAP + typed
deviations) is exactly the JSONL shape a supervised fine-tune would need —
and since 2026-07-26 it is a command, not a plan:
`node scripts/export-training-pairs.mjs` emits one JSON line per `checked`
port (input = the archived originals + referenced mocks, output = the ABAP
class + typed deviations; hold-out samples always excluded, `--all` for
every status). Still far below useful fine-tuning volume — revisit at a few
hundred `checked` reference pairs; until then the flywheel above is where
the gains are.
