# TRAINING.md — using this repo to train the porting agent

**Status: implemented** — the metadata sidecars (`meta/`, validated by
`scripts/validate-meta.mjs`) are the source of truth, the port classes carry
no ABAP Doc header at all (stage-2 inversion done 2026-07-16, enforced by
pattern-lint), and the structural view diff (`scripts/structural-diff.mjs`)
runs clean. This file
describes how the repo is meant to make the generating agent better over time. "Training" here means improving the system
around the agent — rules, golden examples, verification loops — not (yet)
fine-tuning model weights.

## The flywheel

The agent improves through three artifacts, all versioned in this repo:

1. **Rules** — `AGENTS.md` (conventions, gotchas) and `CAPABILITIES.md` (what
   abap2UI5 can express, with proving ports). These are the agent's memory.
2. **Golden examples** — verified sample↔port pairs the generation prompt
   receives as references. One good example outweighs ten rules.
3. **Verification loops** — everything that catches an error before a human
   has to: abaplint ×3, validate-meta, the structural view diff, pattern-lint,
   the AI review pass, the in-system live check.

The cycle per batch:

```
generate  →  verify (CI + structural diff)  →  AI review  →  live check (human)
    ↑                                                             │
    └──── distill: every fix becomes a rule (AGENTS/CAPABILITIES) ┘
                   + the corrected port stays as a golden example
```

**Distillation is a mandatory step, not a habit.** A manual correction that does
not flow back as (a) a rule and (b) a golden example is wasted training signal.

## The batch process

Work happens in batches of ~10 related samples (one control family), each in
its own subpackage `src/01/b<nn>` (= one ABAP package in the system) and one
PR. Per batch:

1. **Generate** — the agent picks ~10 related samples from the in-scope
   backlog (`node scripts/generate-coverage.mjs --backlog` — only controls that
   exist since UI5 1.71 and are not deprecated, see AGENTS §1) and ports them
   into a new `b<nn>` folder, prompt fed with AGENTS.md, CAPABILITIES.md and
   the 2–3 nearest `golden` ports.
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
   CAPABILITIES row. Corrected ports become `checked`/`golden`; STATUS.md is
   updated in the same change.
5. **Regression probe** (every few batches) — re-generate a handful of
   `golden` ports plus the hold-out set from scratch with the current setup
   and diff: a re-appearing old mistake means the rule was too weak.
   Corrections-per-batch is the improvement curve; it must trend down.

A batch folder is closed once merged — follow-ups amend the port in place, new
ports go into the next `b<nn>`.

## Reference repositories

Two read-only reference clones feed the loop (policy since 2026-07-16; clone
them into the session when generating or reviewing):

- **`abap2UI5/abap2UI5`** (framework, main) — the truth about what is
  *possible*. Capability questions are answered by reading the source
  (public API surface only: `z2ui5_if_client` and what it reaches — never
  build on internals) and recorded in CAPABILITIES.md as **source-verified**.
  A live check remains the final confirmation for rendering/UX.
- **`abap2UI5/samples` (branch `cloud`)** — the truth about what is
  *idiomatic*. Its `src/01/08/*` tree is the direct analogue of our ports
  (all ABAP-Cloud-ready, 1.71+, non-deprecated). Golden external references
  for generation prompts:
  `src/01/08/00/z2ui5_cl_demo_app_022` (lifecycle + scalar state),
  `…_app_038` (popup/popover), `…_app_375` (full dispatcher + event args).
  **Do NOT imitate** where samples conflict with this repo's rules: samples
  put `main` last (we: first, call-order), still use one-way `_bind`
  (we: always `_bind_edit`), require an ABAP Doc header (we: forbidden —
  sidecar instead), use inline `check_on_event( 'X' )` for few events
  (we: always CASE in `on_event`), and their view builder is the typed
  `z2ui5_cl_xml_view` (we: generic `z2ui5_cl_api_xml`) — view-building idiom
  does not transfer. Where the two conflict, THIS repo's AGENTS.md wins.
- **`UI5/openui5`** (upstream, on demand) — the truth about what **UI5**
  does. Do NOT keep a standing full clone; use a sparse, blob-filtered
  checkout of what a question needs (`git clone --depth 1 --filter=blob:none
  --sparse …`, then `git sparse-checkout set src/sap.m/src/sap/m …`).
  Three uses: (a) copy each new batch's sample originals into
  `ui5/<lib>/<Name>/`, (b) verify UI5-side behavior claims in the control
  sources (e.g. the default group header in `ComboBoxBase`, the
  `EventHandlerResolver` for `$`-args — both verified 2026-07-16),
  (c) property-level `@since` metadata for a future 1.71 property check.

## Quality ladder

Every port sits on exactly one rung; only `golden` ports may be used as prompt
references and only they graduate to the curated samples repo.

| Status | Meaning | Gate |
|---|---|---|
| `generated` | fresh from the pipeline | abaplint ×3 green |
| `reviewed` | AI review found nothing undeclared | review pass with zero open findings |
| `checked` | manually verified in a running system | `checked {date, note}` set in the sidecar |
| `golden` | checked + exemplary style, safe to imitate | human judgement |

## Per-port metadata

**Implemented (stage 2):** `meta/<class>.json` is the source of truth — the
generator writes it together with the class, the port classes carry **no**
ABAP Doc header (pattern-lint blocks `"!` lines in ports), and the overview
app + coverage tables are generated from the sidecars.
`scripts/validate-meta.mjs` guards schema and referential integrity in CI.
Status promotions (`checked` after a live check, `reviewed`/`golden`) are
edited directly in the sidecar. The shape:

```jsonc
{
  "sample":  "sap.m.sample.MultiInput",
  "entity":  "sap.m.MultiInput",
  "status":  "generated",              // generated | reviewed | checked | golden
  "checked": { "date": "2026-07-15", "note": "verified in a running system - ..." },
  "deviations": [
    { "type": "DROPPED_171",  "what": "showClearIcon", "since": "1.94" },
    { "type": "IMPROVISED",   "what": "validator",     "why": "no client-side validator hook" },
    { "type": "SUBSET_DATA",  "what": "ProductCollection", "rows": "16 of 20" },
    { "type": "LIVE_TEST",    "what": "tree binding over nested tables" }
  ],
  "lessons": ["event-arg-dollar-prefix"]   // AGENTS/CAPABILITIES anchors this port taught
}
```

Deviation types are closed vocabulary (`DROPPED_171`, `IMPROVISED`,
`SUBSET_DATA`, `LIVE_TEST`, `NOTE`) so they can be counted: "how often does
the agent improvise unnecessarily" becomes a query, not an impression.

## Verification: structural view diff

abaplint proves syntax, not fidelity — a port can be CI-green and render an
empty control (it happened: app 454 lost its pre-set tokens).
**Implemented:** `scripts/structural-diff.mjs` compares the original
`view.xml` control structure (control multiset + attribute-name sets) against
the builder calls parsed from the ABAP port, and matches every difference
against the port's declared deviations in `meta/`:

> difference found in the diff but not declared → **fail** (`--strict`).

As of 2026-07-16 all 34 ports run at 0 undeclared differences. Known limits:
controller-created UI is invisible on the view.xml side (it shows as EXTRA in
the port), and loop-built view parts (`[dynamic]`) exempt count checks for the
looped controls. Values are not compared — that stays with review/live checks.

## Measuring progress

- **Hold-out set:** ~20–30 samples that are never used as prompt references.
  Regenerate them periodically with the current rules/references and score:
  CI green on first try, structural-diff violations, review findings per app.
  Improvement becomes a number per generation run.
- **Regeneration diff:** re-run old ports with the improved setup and diff
  against their golden version.

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
deviations) is exactly the JSONL shape a supervised fine-tune would need. With
~34 pairs this is far below any useful volume — revisit at a few hundred
`golden` pairs; until then the flywheel above is where the gains are.
