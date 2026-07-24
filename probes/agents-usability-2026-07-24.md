# Agents-usability probe (2026-07-24)

Goal of this pass: make the agent files (`AGENTS.md`, `CAPABILITIES.md`,
`scripts/generation-prompt.txt`) help an AI build a port **first-try** with as
little friction as possible. Method: pick one port from a weakly-covered library,
read the agent files as the *only* guide, and check whether they hand an AI the
exact instruction it needs — or whether the instruction is buried and has to be
re-derived. Every place it had to be re-derived is a usability gap and was fixed
in the same change.

## Setup / constraints

- **Offline gate baseline** (all green, node-stdlib only, no OpenUI5 needed):
  `validate-meta` (168/168, 0 err), `pattern-lint` (0/0), `structural-diff
  --strict` (168 checked, 44 declared diffs, **0 undeclared**), `structure-lint`
  (0 errors). The self-check loop in AGENTS §6 works as documented.
- **OpenUI5 is not reachable** in this environment (raw.githubusercontent blocked
  at the proxy) and no un-ported sample is archived under `ui5/`, so a *new*
  faithful port could not be produced without inventing the source — which would
  break the 1:1 rule. The probe therefore runs as a **cold-read analysis** of an
  already-archived port against its ground truth, not a from-scratch regeneration.
  A real regeneration probe per weak library is still owed once OpenUI5 is
  reachable (see Recommendation).

## Probe subject — app 164, `sap.ui.table.sample.RowModes`

Chosen because `sap.ui.table` is weakly covered (3/17) and the sample stacks
three of the highest-friction idioms in one view. Cold-reading the agent files,
these are the points where the needed instruction existed but was **hard to
extract**:

1. **Named-model folding** (`{ui>/rowMode}` → one default model). The rule was
   correct but lived inside a ~200-word `CAPABILITIES.md` paragraph — an AI has
   to parse the whole thing to recover the one-line action (`_bind( rowmode )`,
   last-segment match).
2. **Typed/complex bindings** (`{path:'Quantity', type:'sap.ui.model.type.Integer'}`).
   Written 1:1 as a raw binding-info string with **escaped braces** `\{ … \}`.
   The escaping rule was documented only against the *CSS* case (app 028), not
   generalised to every `|…|` template — yet it applies here identically.
3. **Aggregation namespace.** `<m:content>` becomes `open( n='content' ns='m' )`
   but `<columns>` (default `sap.ui.table` namespace) becomes `open( 'columns' )`.
   The prose said an aggregation is "a nameless-namespace `open`", which is only
   true for a default-namespace aggregation — a genuine gap, and a wrong `ns`
   here produces an unknown-aggregation node that `render_smoke` rejects.
4. **The ❌ boundaries** (control-returning factories, app-authored JS
   formatters) were scattered across `CAPABILITIES.md` rows rather than stated
   once as "don't improvise, declare".

## Actions taken (same change)

- **`AGENTS.md` §5 — new "Idiom cheat-sheet"**: the ~12 recurring hard idioms as
  copy-paste one-liners (`In the original you see… → Write in the port → Detail`),
  each pointing at the long-form rule / proving app. Indexes the buried prose;
  does not duplicate it. Includes the two ❌ boundaries stated once.
- **`AGENTS.md` §5 — aggregation-namespace rule** made explicit (an aggregation
  carries its XML tag's namespace = its parent control's), with app 164 as the
  worked example.
- **`scripts/generation-prompt.txt`** — three lines added to the *first-read*
  prompt: aggregation namespace, always-escape-braces-in-`|…|`, and the
  one-default-model / typed-binding rule. Re-spliced into `README.md` via
  `generate-coverage.mjs`.
- **`src/z2ui5_cl_ai_app_overview.clas.abap`** — regenerated; the committed copy
  was stale (missing the `ui5_only` field), the known "system push carries stale
  generated files" gotcha. Deterministic/idempotent regen from `meta/`.

## Recommendation

- The cheat-sheet is now the canonical quick index — keep new distilled idioms
  flowing into it (one row), not only into prose.
- Run a **real regeneration probe per newly-started library** (uxap, layout,
  table, unified are the thin ones) once OpenUI5 is reachable — the cold-read
  here catches doc-extraction friction, but only a from-scratch port surfaces
  idioms the docs don't cover *at all*. That is where the next genuine AGENTS
  additions will come from.
