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
 * This repository resolves abap2UI5 THREE times, and that is deliberate — each
 * answers a different question, so one value could not serve all three:
 *
 *   A2UI5_PIN (a commit SHA)   what the transpiled backend and the e2e smoke
 *                              run against. Moved weekly by bump-a2ui5.
 *   the abaplint configs       a RELEASE TAG: does the corpus compile against
 *                              the framework its readers have installed.
 *   e2e-nightly                main tip, unpinned, as the upstream canary.
 *
 * The middle one used to be absent, and its absence looked like the policy:
 * with no `"branch"` key abaplint clones the DEFAULT branch, so the corpus was
 * checked against the development tip while every reader of it has a release.
 * Two silent failures — a port using API that only exists on main stays green
 * here and breaks for the reader, and a framework change on main reddens three
 * workflows here overnight with no commit to explain it. abaplint cannot be
 * given the SHA instead: `"branch"` feeds `git clone --branch`, which takes a
 * branch or a tag and never a commit.
 *
 * Policy:
 *   1. A2UI5_PIN must be a single well-formed 40-hex commit SHA (the
 *      ancestor-of-main check needs the network and stays with the bump
 *      workflow — not verified here).
 *   2. An abaplint config's abap2UI5 dependency entry carries a `"branch"` key
 *      naming a RELEASE TAG (x.y.z), and all of them name the SAME one, so a
 *      bump cannot leave one config behind. ONE allowlisted exception:
 *      `.github/abaplint/abap_702.jsonc` needs `"branch": "702"`, because the
 *      702 build must resolve the framework against its downported branch
 *      (the framework's own auto_downport rebuilds it from main; main itself
 *      is not v702-parseable).
 *   3. Never two `"branch"` keys in one dependency entry — duplicate keys
 *      are exactly the silent-shadowing trap above.
 *   4. Neither ui5/properties.json nor ui5/descriptions.json is OLDER than
 *      ui5/universe.json — the second version pairing in this repository, and
 *      the one generate-result.yaml warns about in prose without anything
 *      checking it. All three come from ONE OpenUI5 checkout and answer three
 *      questions about the same release: the universe says which release the
 *      sample set was harvested from, the property snapshot answers `@since`,
 *      the description snapshot answers what a sample demonstrates.
 *      A property snapshot behind the universe has no `@since` for the
 *      controls introduced in between, so scopeOf reads them as in scope and a
 *      port gets scaffolded for a control the 1.71 floor could never render
 *      (sap.f.HeroBanner, @1.152, is the case that named this). A DESCRIPTION
 *      snapshot behind the universe is worse-natured: `check:summary` fails
 *      HARD on a port that matches no source (deliberately — the point is that
 *      a new undescribed sample gets noticed), so the corpus can reach a state
 *      only a manual refresh repairs. It was six weeks and one minor release
 *      behind when this rule was extended, and generate-result.yaml refreshed
 *      the other two weekly without ever touching it.
 *      Compared on major.minor: both snapshots are built from an OpenUI5
 *      master checkout and call themselves `-SNAPSHOT`, the same release line.
 *   5. Prose AGREES with the pin. A sentence that asserts a commit SHA IS the
 *      pin — in a markdown document or in a `meta/` sidecar's long-form text —
 *      must name A2UI5_PIN's actual value. Nothing checked this, and
 *      `bump-a2ui5.yaml` moves the pin on a schedule: the 2026-08-28 bump to
 *      `2567ee10` left SEVEN documents saying the pin was still `bf92a79c`,
 *      six of them the sidecars of ports that were "blocked on the pin" and
 *      had not been for hours. That is the same failure mode
 *      `check-prose-names.mjs` exists for one noun over, so it reads the same
 *      two scopes: the prose files, and every sidecar's `deviations[].what` /
 *      `audit.note` / `checked.note` / skip `reason`.
 *      Only an ASSERTION is judged — "A2UI5_PIN is <sha>", "the pin moved to
 *      <sha>", "the pin caught up (<sha>)". A past-tense sentence is HISTORY
 *      and is left alone ("A2UI5_PIN sat at bf92a79c while main moved 61
 *      commits" is a true record of a run that happened), exactly as the
 *      journal is: `docs/history.md` is out of scope for the same reason
 *      check-prose-names leaves it out.
 *
 * A deliberate, temporary feature-branch re-point (the documented re-pin
 * flow) must therefore edit ALLOWED_BRANCHES below in the same change — the
 * temporary state then shows in the diff and cannot survive a merge unseen.
 *
 * Run:  node scripts/check-pins.mjs               (offline, exit 1)
 *       node scripts/check-pins.mjs --set 1.144.0 (move the release pin)
 *
 * `--set` lives here rather than in bump-a2ui5.yaml so the policy has ONE
 * implementation: which configs carry the release and which carry an
 * allowlisted branch are the same two answers whether they are being checked
 * or written.
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');

// config path (repo-relative) -> Set of branch values its abap2UI5 dependency
// may carry INSTEAD of the release tag. Absent entry = must carry the tag.
const ALLOWED_BRANCHES = new Map([
  ['.github/abaplint/abap_702.jsonc', new Set(['702'])],
]);

const A2UI5_URL_RE = /github\.com\/abap2UI5\/abap2UI5/i;
const RELEASE_RE = /^\d+\.\d+\.\d+$/;
const releases = new Map();   // config -> release tag it names

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

const SET = (() => {
  const i = process.argv.indexOf('--set');
  return i !== -1 ? process.argv[i + 1] : null;
})();

if (SET !== null) {
  if (!RELEASE_RE.test(SET || '')) {
    console.log(`ERROR --set wants a release tag (x.y.z), got ${JSON.stringify(SET)}`);
    process.exit(1);
  }
  let written = 0;
  for (const rel of configFiles()) {
    if (ALLOWED_BRANCHES.has(rel)) continue;
    const full = path.join(ROOT, rel);
    const raw = fs.readFileSync(full, 'utf8');
    /* Rewritten in the RAW text: these are .jsonc files whose comments carry
     * the reasoning, and a parse/serialise round trip would drop every one.
     * Anchored on the abap2UI5 url line so a `branch` belonging to another
     * dependency is left alone. */
    const next = raw.replace(
      /("url"\s*:\s*"https:\/\/github\.com\/abap2UI5\/abap2UI5"\s*,\s*\n\s*"branch"\s*:\s*")[^"]*(")/,
      `$1${SET}$2`,
    );
    if (next !== raw) { fs.writeFileSync(full, next); written++; }
  }
  console.log(`check-pins: set ${written} config(s) to ${SET}`);
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
    const allowed = ALLOWED_BRANCHES.get(rel);
    if (branches.length > 1) {
      err(`${rel}: abap2UI5 dependency carries ${branches.length} "branch" keys (${branches.map((b) => JSON.stringify(b)).join(', ')}) — duplicate keys silently shadow each other; keep exactly one`);
      continue;
    }
    if (branches.length === 0) {
      err(`${rel}: abap2UI5 dependency carries no "branch" key — abaplint then clones the DEFAULT branch, so this config lints the corpus against the framework's development tip instead of a release${allowed ? `; this config wants "branch": ${JSON.stringify([...allowed][0])}` : ''}`);
      continue;
    }
    const [branch] = branches;
    if (allowed) {
      if (!allowed.has(branch)) {
        err(`${rel}: abap2UI5 dependency carries "branch": ${JSON.stringify(branch)}, but this config is allowlisted for ${[...allowed].map((b) => JSON.stringify(b)).join(' / ')} — a deliberate re-point must edit ALLOWED_BRANCHES in scripts/check-pins.mjs in the same change`);
      }
      continue;
    }
    if (!RELEASE_RE.test(branch)) {
      err(`${rel}: abap2UI5 dependency is pinned to ${JSON.stringify(branch)}, which is not a release tag (x.y.z) — only the allowlisted configs may name a branch`);
      continue;
    }
    releases.set(rel, branch);
  }
}

// --- 2b. one release across the repository ----------------------------------
const distinct = [...new Set(releases.values())];
if (distinct.length > 1) {
  err(`the abaplint configs name ${distinct.length} different releases (${distinct.join(', ')}) — a bump has to move all of them:\n`
    + [...releases].map(([f, v]) => `        ${v}  ${f}`).join('\n'));
}
if (!checked) err('no abap2UI5 dependency entry found in any abaplint config — did the dependency URL change? (this check would go blind)');

// --- 4. the property snapshot covers the sample universe --------------------
const line = (v) => {
  const m = /^(\d+)\.(\d+)/.exec(String(v || ''));
  return m ? [Number(m[1]), Number(m[2])] : null;
};
let snapshotNote = 'snapshot/universe unread';
{
  const universeFile = path.join(ROOT, 'ui5', 'universe.json');
  /* Both snapshots taken from the same checkout, each with the field it
   * carries its version in and the sentence that says what going stale costs.
   * A snapshot with NO version field is a bug in the snapshot, not a pass. */
  const SNAPSHOTS = [
    {
      file: 'ui5/properties.json',
      version: (d) => d.ui5Version,
      costs: 'the @since of everything added in between is missing and scopeOf lets those controls through',
    },
    {
      file: 'ui5/descriptions.json',
      version: (d) => d.source?.version,
      costs: 'a sample the universe gained is described nowhere, and check:summary fails HARD on a port that matches no source',
    },
  ];
  if (!fs.existsSync(universeFile)) {
    err('ui5/universe.json missing — the snapshot pairing cannot be judged');
  } else {
    const uni = JSON.parse(fs.readFileSync(universeFile, 'utf8')).release;
    const b = line(uni);
    const ok = [];
    for (const s of SNAPSHOTS) {
      const at = path.join(ROOT, s.file);
      if (!fs.existsSync(at)) { err(`${s.file} missing — the snapshot pairing cannot be judged`); continue; }
      const snap = s.version(JSON.parse(fs.readFileSync(at, 'utf8')));
      const a = line(snap);
      if (!a || !b) {
        err(`ui5 snapshot pairing unreadable — ${s.file} version ${JSON.stringify(snap)}, universe.json release ${JSON.stringify(uni)}`);
      } else if (a[0] < b[0] || (a[0] === b[0] && a[1] < b[1])) {
        err(`${s.file} is ${snap}, older than the universe it must cover (${uni}) — regenerate it against the same OpenUI5 checkout (generate-result.yaml does this), or ${s.costs}`);
      } else {
        ok.push(`${s.file.replace('ui5/', '').replace('.json', '')} ${snap}`);
      }
    }
    if (ok.length === SNAPSHOTS.length) snapshotNote = `${ok.join(' + ')} cover universe ${uni}`;
  }
}

// --- 5. prose agrees with the pin -------------------------------------------
/* The markdown a reader arrives at. `docs/history.md` is deliberately absent:
 * a journal records what was true when the entry was written, which is history
 * and not drift — the same cut check-prose-names.mjs makes. */
const PROSE = [
  'README.md', 'AGENTS.md', 'CLAUDE.md', 'CONTRIBUTING.md', 'TRAINING.md',
  'STATUS.md', 'CAPABILITIES.md', 'E2E.md', 'docs/upstream-requests.md',
];

/* The other half of the prose, and in a sample repository the bigger half —
 * the shape check-prose-names.mjs reads, plus the skip reasons, which are
 * prose about a gate and cite the pin exactly as a deviation does. */
function sidecarProse(file) {
  const out = [];
  let doc;
  try { doc = JSON.parse(fs.readFileSync(file, 'utf8')); } catch { return out; }
  const at = path.relative(ROOT, file).split(path.sep).join('/');
  (doc.deviations ?? []).forEach((d, i) => {
    if (typeof d?.what === 'string') out.push({ label: `${at} deviations[${i}].what`, text: d.what });
  });
  for (const [key, holder] of [['audit', doc.audit], ['checked', doc.checked]]) {
    if (typeof holder?.note === 'string') out.push({ label: `${at} ${key}.note`, text: holder.note });
  }
  for (const key of ['render_smoke', 'structural_diff', 'data_fidelity', 'property_gate']) {
    if (typeof doc[key]?.reason === 'string') out.push({ label: `${at} ${key}.reason`, text: doc[key].reason });
  }
  return out;
}

/* An ASSERTION that some SHA is the pin, in either word order. Present tense
 * and completed moves count ("is", "moved to", "caught up … (<sha>)"); a past
 * state does not ("was", "sat at", "used to be", "predated") — that is a
 * record of a run, and rewriting it would falsify the history instead. */
const PIN_SUBJECT = '(?:`?\\bA2UI5_PIN\\b`?|\\bthe pin\\b)';
const PIN_VERB = '(?:is|are|reads|now reads|stands|remains|sits|points|moved|advanced|bumped|caught up|now)';
let pinProseNote = 'prose unread';
const PIN_CLAIMS = [
  // "A2UI5_PIN is `2567ee10`", "the pin is still at `bf92a79c`",
  // "the pin caught up on 2026-08-28 (`2567ee10`)"
  new RegExp(`${PIN_SUBJECT}[^.\\n]{0,20}?\\b${PIN_VERB}\\b[^.\\n]{0,45}?\`?\\b([0-9a-f]{7,40})\\b`, 'gi'),
  // "bump-a2ui5 advanced `A2UI5_PIN` to `2567ee10`"
  new RegExp(`\\b(?:moved|advanced|bumped|set)\\s+${PIN_SUBJECT}\\s+to\\s+\`?\\b([0-9a-f]{7,40})\\b`, 'gi'),
];

{
  const pin = fs.existsSync(pinFile) ? fs.readFileSync(pinFile, 'utf8').trim().toLowerCase() : '';
  const sources = [];
  for (const rel of PROSE) {
    const at = path.join(ROOT, rel);
    if (fs.existsSync(at)) sources.push({ label: rel, text: fs.readFileSync(at, 'utf8') });
  }
  const metaDir = path.join(ROOT, 'meta');
  if (fs.existsSync(metaDir)) {
    for (const name of fs.readdirSync(metaDir).sort()) {
      if (name.endsWith('.json')) sources.push(...sidecarProse(path.join(metaDir, name)));
    }
  }
  let claims = 0;
  for (const { label, text } of sources) {
    const seen = new Set();
    for (const re of PIN_CLAIMS) {
      re.lastIndex = 0;
      for (const m of text.matchAll(re)) {
        const sha = m[1].toLowerCase();
        if (seen.has(sha)) continue;
        seen.add(sha);
        claims++;
        if (pin && !pin.startsWith(sha)) {
          err(`${label}: says the pin is \`${sha}\`, but A2UI5_PIN is \`${pin.slice(0, sha.length)}\` `
            + `(${pin})\n        …${m[0].replace(/\s+/g, ' ').slice(-110)}\n`
            + '        the bump moved the pin and this sentence did not follow — correct it, or, if the '
            + 'sentence is about a state that has PASSED, write it in the past tense so it reads as history');
        }
      }
    }
  }
  pinProseNote = `${claims} pin citation(s) in ${sources.length} prose source(s)`;
}

if (errors) {
  console.log(`check-pins: ${errors} error(s).`);
  process.exit(1);
}
console.log(`check-pins: ok (A2UI5_PIN well-formed, ${checked} abap2UI5 dependency entr${checked === 1 ? 'y' : 'ies'} on release ${distinct[0] ?? 'none'}, ${snapshotNote}, ${pinProseNote})`);
