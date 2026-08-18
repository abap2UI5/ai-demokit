#!/usr/bin/env node
/*
 * check-pins — the abap2UI5 pin policy, gated.
 *
 * WHY: the framework version the corpus builds against is pinned in exactly
 * one place — A2UI5_PIN (a commit SHA, moved via bump-a2ui5.yaml). The
 * abaplint configs resolve the same dependency by URL, and abaplint accepts
 * an optional `"branch"` key there. That key is a second, silent pin: a
 * feature-branch re-point that survives a merge keeps CI linting against a
 * branch that will be deleted, and JSON parsing takes the LAST of duplicate
 * keys, so a stale `"branch"` left NEXT to the intended one is invisible to
 * every consumer that just parses the file. Both actually happened: on
 * 2026-08-10 the 702 config carried the branch of the already-merged-and-
 * deleted `ai-demokit-next-steps` branch next to its own `"branch": "702"`
 * (docs/history.md). This check makes that class of drift fail offline, in
 * `npm run gates`, where the edit happens.
 *
 * Policy:
 *   1. A2UI5_PIN must be a single well-formed 40-hex commit SHA (the
 *      ancestor-of-main check needs the network and stays with the bump
 *      workflow — not verified here).
 *   2. An abaplint config's abap2UI5 dependency entry carries NO `"branch"`
 *      key — the pin governs — with ONE allowlisted exception:
 *      `.github/abaplint/abap_702.jsonc` needs `"branch": "702"`, because the
 *      702 build must resolve the framework against its downported branch
 *      (the framework's own auto_downport rebuilds it from main; main itself
 *      is not v702-parseable).
 *   3. Never two `"branch"` keys in one dependency entry — duplicate keys
 *      are exactly the silent-shadowing trap above.
 *
 * A deliberate, temporary feature-branch re-point (the documented re-pin
 * flow) must therefore edit ALLOWED_BRANCHES below in the same change — the
 * temporary state then shows in the diff and cannot survive a merge unseen.
 *
 * Run:  node scripts/check-pins.mjs     (offline, exit 1 on any violation)
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');

// config path (repo-relative) -> Set of branch values its abap2UI5 dependency
// may carry. Absent entry = no branch key allowed at all.
const ALLOWED_BRANCHES = new Map([
  ['.github/abaplint/abap_702.jsonc', new Set(['702'])],
]);

const A2UI5_URL_RE = /github\.com\/abap2UI5\/abap2UI5/i;

let errors = 0;
const err = (m) => { console.log(`ERROR ${m}`); errors++; };

// --- 1. A2UI5_PIN is a single well-formed commit SHA -------------------------
const pinFile = path.join(ROOT, 'A2UI5_PIN');
if (!fs.existsSync(pinFile)) {
  err('A2UI5_PIN missing — the framework pin file must exist at the repo root');
} else {
  const raw = fs.readFileSync(pinFile, 'utf8');
  const sha = raw.trim();
  if (!/^[0-9a-f]{40}$/.test(sha)) {
    err(`A2UI5_PIN is not a well-formed 40-hex commit SHA: ${JSON.stringify(sha.slice(0, 60))}`);
  }
  if (raw.split('\n').filter((l) => l.trim()).length > 1) {
    err('A2UI5_PIN carries more than one non-empty line — exactly one commit SHA');
  }
}

// --- 2. the abaplint configs: no branch key on the abap2UI5 dependency -------
// The configs are JSONC (comments), and the whole point is catching DUPLICATE
// keys — which JSON.parse silently collapses — so this works on the raw text:
// strip comments, split the dependencies array into balanced {...} entries,
// and inspect every "branch" occurrence inside the abap2UI5 entry.
const stripComments = (t) => t
  .replace(/\/\*[\s\S]*?\*\//g, '')
  .replace(/^\s*\/\/.*$/gm, '')
  .replace(/([,{[\s])\/\/.*$/gm, '$1');

// balanced top-level {...} slices of an array body (strings are quote-aware)
function objectSlices(body) {
  const out = [];
  let depth = 0;
  let start = -1;
  let inStr = false;
  for (let i = 0; i < body.length; i++) {
    const c = body[i];
    if (inStr) {
      if (c === '\\') i++;
      else if (c === '"') inStr = false;
      continue;
    }
    if (c === '"') { inStr = true; continue; }
    if (c === '{') { if (depth === 0) start = i; depth++; }
    else if (c === '}') { depth--; if (depth === 0 && start >= 0) { out.push(body.slice(start, i + 1)); start = -1; } }
  }
  return out;
}

function configFiles() {
  const files = ['abaplint.jsonc'];
  const dir = path.join(ROOT, '.github', 'abaplint');
  if (fs.existsSync(dir)) {
    for (const f of fs.readdirSync(dir).sort()) {
      if (f.endsWith('.jsonc') || f.endsWith('.json')) files.push(path.posix.join('.github/abaplint', f));
    }
  }
  return files.filter((f) => fs.existsSync(path.join(ROOT, f)));
}

let checked = 0;
for (const rel of configFiles()) {
  const txt = stripComments(fs.readFileSync(path.join(ROOT, rel), 'utf8'));
  const depsM = txt.match(/"dependencies"\s*:\s*\[([\s\S]*?)\]/);
  if (!depsM) continue;
  for (const entry of objectSlices(depsM[1])) {
    if (!A2UI5_URL_RE.test(entry)) continue;
    checked++;
    const branches = [...entry.matchAll(/"branch"\s*:\s*"([^"]*)"/g)].map((m) => m[1]);
    const allowed = ALLOWED_BRANCHES.get(rel) || new Set();
    if (branches.length > 1) {
      err(`${rel}: abap2UI5 dependency carries ${branches.length} "branch" keys (${branches.map((b) => JSON.stringify(b)).join(', ')}) — duplicate keys silently shadow each other; keep at most one`);
    }
    for (const b of branches) {
      if (!allowed.has(b)) {
        err(`${rel}: abap2UI5 dependency carries "branch": ${JSON.stringify(b)} — pin policy: only A2UI5_PIN governs the framework version${allowed.size ? ` (allowed here: ${[...allowed].join(', ')})` : ' (no branch key allowed in this config)'}; a deliberate temporary re-point must edit ALLOWED_BRANCHES in scripts/check-pins.mjs in the same change`);
      }
    }
  }
}
if (!checked) err('no abap2UI5 dependency entry found in any abaplint config — did the dependency URL change? (this check would go blind)');

if (errors) {
  console.log(`check-pins: ${errors} error(s).`);
  process.exit(1);
}
console.log(`check-pins: ok (A2UI5_PIN well-formed, ${checked} abap2UI5 dependency entr${checked === 1 ? 'y' : 'ies'} clean)`);
