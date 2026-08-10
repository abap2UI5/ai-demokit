#!/usr/bin/env node
/*
 * scope-of.mjs — authoritative in/out-of-scope verdict for a control entity.
 *
 * WHY: the offline `ui5/universe.json` snapshot carries `since: null` for most
 * controls (the shallow OpenUI5 fork has no generated `designtime/api.json`), so
 * both the porting pre-check and `generate-coverage.mjs`'s `scopeOf` are BLIND to
 * controls newer than 1.71 — that is how `sap.f.AvatarGroup` (@since 1.73) and
 * `sap.f.SidePanel` (@since 1.107, app 136) slipped in. This helper reads the
 * control-level `@since` / `@deprecated` straight from the OpenUI5 source JSDoc,
 * the authoritative record, and prints a verdict.
 *
 * A control is IN SCOPE when it exists since UI5 <= 1.71 AND is not deprecated in
 * the current release (AGENTS.md §1). This is a STANDALONE reporter — it does not
 * alter any gate; `scopeOf` (generate-coverage.mjs) reads the same facts from
 * the committed `ui5/properties.json` snapshot, so the two verdicts agree.
 *
 * Usage:
 *   node scripts/scope-of.mjs sap.f.AvatarGroup              # one entity
 *   node scripts/scope-of.mjs sap.f.AvatarGroup sap.m.Menu   # several
 *   node scripts/scope-of.mjs --sample FlexibleColumnLayoutSimple  # resolve via universe.json
 * Exit code: 0 if every queried entity is IN scope, 1 if any is OUT (or unresolved).
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import {
  loadUniverseSnapshot, loadEntityOverrides, loadNonAppFamilies, nonAppFamilyFor,
} from './lib-universe.mjs';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const OPENUI5_DIR = process.env.OPENUI5_SRC
  ? path.resolve(process.env.OPENUI5_SRC)
  : path.resolve(ROOT, '..', 'fork-openui5');
const SRC = path.join(OPENUI5_DIR, 'src');
const THRESHOLD = [1, 71]; // controls first available after 1.71 are out of scope

// "1.73" / "1.109.0" -> [1,73] / [1,109,0]; loose text after the number is ignored
function parseVer(s) {
  if (!s) return null;
  const m = String(s).match(/(\d+)\.(\d+)(?:\.(\d+))?/);
  return m ? [Number(m[1]), Number(m[2]), Number(m[3] || 0)] : null;
}
function gt(a, b) {
  for (let i = 0; i < Math.max(a.length, b.length); i++) {
    const x = a[i] || 0, y = b[i] || 0;
    if (x !== y) return x > y;
  }
  return false;
}

// entity "sap.f.AvatarGroup" -> the source .js whose path ends in "sap/f/AvatarGroup.js"
function sourceFor(entity) {
  const suffix = path.sep + entity.replace(/\./g, path.sep) + '.js';
  const hits = [];
  (function walk(dir) {
    let ents;
    try { ents = fs.readdirSync(dir, { withFileTypes: true }); } catch { return; }
    for (const e of ents) {
      const p = path.join(dir, e.name);
      if (e.isDirectory()) {
        // skip test/demokit trees — the control source lives under <lib>/src
        if (e.name === 'test' || e.name === 'node_modules') continue;
        walk(p);
      } else if (p.endsWith(suffix)) {
        hits.push(p);
      }
    }
  })(SRC);
  // prefer the canonical "<lib>/src/..." location if several match
  hits.sort((a, b) => (a.includes(`${path.sep}src${path.sep}`) ? -1 : 1) - (b.includes(`${path.sep}src${path.sep}`) ? -1 : 1));
  return hits[0] || null;
}

// class-level JSDoc @since / @deprecated ONLY. These live in the class-doc block,
// which precedes the `X.extend("<entity>", { … })` call; member/aggregation blocks
// (which carry their OWN @since, e.g. sap.m.Menu.js has no class @since but a
// member @since 1.146) come AFTER it and must NOT be read. So slice the source at
// the extend call and search only the class header. No class-level @since ⇒ base
// version (<= 1.71), exactly like the property gate's "no @since tag" rule.
function metaFromSource(file, entity) {
  const txt = fs.readFileSync(file, 'utf8');
  const extendRe = new RegExp(`\\.extend\\(\\s*["']${entity.replace(/\./g, '\\.')}["']`);
  const em = txt.match(extendRe);
  const header = em ? txt.slice(0, em.index) : txt.slice(0, 4000);
  // @ui5-experimental-since counts as the control's since too — an
  // experimental control has no plain @since, which made the 1.139
  // OverflowToolbarTokenizer read as base-version (review sweep, app 203)
  const sinceM = header.match(/@(?:ui5-experimental-)?since\s+(?:version\s+)?([\d.]+)/i);
  const depM = header.match(/@deprecated(?:\s+As of(?:\s+version)?\s+([\d.]+))?([^\n]*)/i);
  return {
    since: sinceM ? sinceM[1] : null,
    deprecated: depM ? { since: depM[1] || null, text: (depM[2] || '').replace(/^[\s.,;:—-]+/, '').trim() } : null,
  };
}

// --- non-app families (ui5/scope-nonapp.json, maintainer decision 2026-07-31)
// A control can be perfectly 1.71-clean and the sample still be out of scope
// because it is not an app view (OPA5/gherkin test pages, Component routing,
// view-templating / XMLComposite authoring demos). generate-coverage.mjs
// applies the same list through the same lib-universe matcher; the two
// verdicts stay identical by construction.
const nonAppFamilies = loadNonAppFamilies();
const nonAppFor = (info) => nonAppFamilyFor(nonAppFamilies, info);
// ui5/entity-overrides.json supplies the owning entity where the upstream
// docuindex has none (universe.json then carries entity:null) — apply it here
// too, or a non-app family matched by entityPrefix would never fire.
const entityOverrides = loadEntityOverrides();
function sampleInfo(sample) {
  const d = loadUniverseSnapshot();
  if (!d) return null;
  for (const l of d.libs || []) for (const s of l.samples || []) {
    if (s.name !== sample) continue;
    const entity = entityOverrides[`${l.lib}.sample.${s.name}`] || s.entity;
    return { lib: l.lib, name: s.name, entity };
  }
  return null;
}

function verdict(entity) {
  const file = sourceFor(entity);
  if (!file) return { entity, ok: false, reason: 'UNRESOLVED (no source .js found — check the entity name / fork checkout)' };
  const { since, deprecated } = metaFromSource(file, entity);
  if (deprecated) {
    return { entity, ok: false, since, reason: `OUT_OF_SCOPE (deprecated${deprecated.since ? ` since ${deprecated.since}` : ''}${deprecated.text ? ` — ${deprecated.text.replace(/\s+/g, ' ').slice(0, 80)}` : ''})` };
  }
  const v = parseVer(since);
  if (v && gt(v, THRESHOLD)) {
    return { entity, ok: false, since, reason: `OUT_OF_SCOPE (control @since ${since} > 1.71)` };
  }
  return { entity, ok: true, since, reason: `IN_SCOPE (@since ${since || '<=1.71 (no @since header)'})` };
}

const argv = process.argv.slice(2);
if (!argv.length) {
  console.error('usage: node scripts/scope-of.mjs <entity...> | --sample <SampleName...>');
  process.exit(2);
}
let entities = [];
let notOk = false;
if (argv[0] === '--sample') {
  for (const s of argv.slice(1)) {
    const info = sampleInfo(s);
    // the non-app verdict comes first: it holds regardless of whether the
    // control resolves in the fork checkout
    const fam = info && nonAppFor(info);
    if (fam) {
      notOk = true;
      console.log(`${s.padEnd(34)} OUT_OF_SCOPE (not an app view — ${fam.reason}; ui5/scope-nonapp.json)`);
      continue;
    }
    const e = info ? info.entity : null;
    if (!e) {
      // an unresolved sample must fail too — exit 0 on a typo'd name would
      // read as a green scope pre-check
      notOk = true;
      console.log(`${s.padEnd(34)} UNRESOLVED (sample not in universe.json)`);
      continue;
    }
    entities.push(e);
  }
} else {
  entities = argv;
}

let allOk = !notOk;
for (const e of entities) {
  const r = verdict(e);
  if (!r.ok) allOk = false;
  console.log(`${(r.entity || '').padEnd(34)} ${r.reason}`);
}
process.exit(allOk ? 0 : 1);
