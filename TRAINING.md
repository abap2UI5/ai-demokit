# TRAINING.md — using this repo to train the porting agent

**Status: concept, agreed direction — the metadata format below is a draft, not
yet implemented.** This file describes how the repo is meant to make the
generating agent better over time. "Training" here means improving the system
around the agent — rules, golden examples, verification loops — not (yet)
fine-tuning model weights.

## The flywheel

The agent improves through three artifacts, all versioned in this repo:

1. **Rules** — `AGENTS.md` (conventions, gotchas) and `CAPABILITIES.md` (what
   abap2UI5 can express, with proving ports). These are the agent's memory.
2. **Golden examples** — verified sample↔port pairs the generation prompt
   receives as references. One good example outweighs ten rules.
3. **Verification loops** — everything that catches an error before a human
   has to: abaplint ×3 (exists), the structural view diff (planned, below),
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

## Quality ladder

Every port sits on exactly one rung; only `golden` ports may be used as prompt
references and only they graduate to the curated samples repo.

| Status | Meaning | Gate |
|---|---|---|
| `generated` | fresh from the pipeline | abaplint ×3 green |
| `reviewed` | AI review found nothing undeclared | review pass with zero open findings |
| `checked` | manually verified in a running system | today's `"! CHECKED (date):` marker |
| `golden` | checked + exemplary style, safe to imitate | human judgement |

## Per-port metadata (draft format)

Today status and caveats live in regex-parsed ABAP Doc headers — fragile, and
the deviations are prose, not data. Proposal: one sidecar file per port,
`src/01/z2ui5_cl_api_app_<n>.meta.json`, as the single source of truth from
which the header block, the overview app and the coverage tables are
*generated*:

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
`SUBSET_DATA`, `LIVE_TEST`, …) so they can be counted: "how often does the
agent improvise unnecessarily" becomes a query, not an impression. Migration
path: script converts existing headers → meta.json once, then headers become
generated output.

## Verification: structural view diff (planned)

abaplint proves syntax, not fidelity — a port can be CI-green and render an
empty control (it happened: app 454 lost its pre-set tokens). Both sides are
XML, so a script can compare the original `view.xml` against the XML the ABAP
builder emits, as control trees (controls, properties, bindings), and match
every difference against the port's declared `deviations`:

> deviation found in the tree diff but not declared in meta.json → **fail**.

That turns the "declare every caveat" convention from a plea into a checked
invariant, and it is the single check most likely to catch the bugs the CI
cannot.

## Measuring progress

- **Hold-out set:** ~20–30 samples that are never used as prompt references.
  Regenerate them periodically with the current rules/references and score:
  CI green on first try, structural-diff violations, review findings per app.
  Improvement becomes a number per generation run.
- **Regeneration diff:** re-run old ports with the improved setup and diff
  against their golden version.

## Preconditions on data quality

Training signal is only as good as the stored pairs:

- `ui5/<class>/` must archive **everything** `manifest.json` lists under
  `sample.files` (app 401 is missing its controller and the embedded Table
  files) **plus** any mock data used (`products.json`, `img.json`), so ports
  stop silently truncating rows and fidelity stays verifiable offline.
- The header/metadata pipeline must never lose labels silently
  (the 2026-07-16 `generate-overview.mjs` parser rewrite fixed two such cases).

## Fine-tuning (later)

The pair structure (sample files + capability context → ABAP + typed
deviations) is exactly the JSONL shape a supervised fine-tune would need. With
~34 pairs this is far below any useful volume — revisit at a few hundred
`golden` pairs; until then the flywheel above is where the gains are.
