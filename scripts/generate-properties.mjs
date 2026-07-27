#!/usr/bin/env node
/*
 * Builds ui5/properties.json — per control: the parent class, the CONTROL's
 * own class-level @since / @deprecated, and every member (property/
 * aggregation/association/event) that carries a JSDoc @since, parsed from
 * the OpenUI5 control sources.
 *
 * This is the data source for scripts/property-check.mjs (the 1.71 property
 * gate): a port may only use members that existed by UI5 1.71, so the check
 * needs to know when each member was introduced. Members without @since are
 * older than version tracking and count as always-available.
 *
 * The control-level since/deprecated additionally feed the scope gate:
 * generate-coverage.mjs's scopeOf falls back to them when ui5/universe.json
 * carries null (the fork checkout has no generated api.json), so the
 * out-of-scope check is authoritative offline (pr/scope-since-from-source).
 *
 * Source: an OpenUI5 checkout (env OPENUI5_DIR, default ./openui5) — the
 * generate_result CI step clones the full repo, so every ported library's
 * src/ is present (see LIBS below); each is scanned recursively (nested
 * controls incl.). A lib dir absent from a partial local checkout is skipped
 * with a warning. Controls outside the checkout are simply absent from the
 * snapshot; the checker skips unknown controls.
 *
 * Run:  OPENUI5_DIR=/workspace/openui5 node scripts/generate-properties.mjs
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const OPENUI5_DIR = process.env.OPENUI5_DIR || path.join(ROOT, 'openui5');
const OUT = path.join(ROOT, 'ui5', 'properties.json');

// every library the repo ports (src/01..05) — the property gate must see them
// all, not just sap.m. The generate_result CI step clones the FULL OpenUI5 repo
// (git clone --depth 1), so every lib's src/ is present; a lib dir that is
// absent (a partial local checkout) is skipped with a warning, not fatal.
const LIBS = [
  'sap.m', 'sap.f', 'sap.ui.core', 'sap.ui.layout', 'sap.ui.table',
  'sap.ui.unified', 'sap.uxap', 'sap.tnt', 'sap.ui.codeeditor', 'sap.ui.integration',
];
const LIB_DIRS = LIBS.map((lib) => {
  const libPath = lib.replace(/\./g, '/'); // sap.ui.layout -> sap/ui/layout
  return [libPath, path.join(OPENUI5_DIR, 'src', lib, 'src', ...libPath.split('/'))];
});

// recursively collect [file, moduleBaseOfItsDir] — controls live in nested
// subdirs too (sap.ui.layout/form/SimpleForm, sap.f/cards/NumericHeader,
// sap.m/semantic/*). moduleBase is the file's DIRECTORY module path so a
// relative `./X` dep resolves correctly in parseControl.
function collect(dir, moduleBase, acc) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) collect(p, `${moduleBase}/${e.name}`, acc);
    else if (e.name.endsWith('.js') && !e.name.endsWith('Renderer.js')) acc.push([p, moduleBase]);
  }
}

// module path (sap/m/Button, or ./Input relative to the lib base) -> dotted name
const dotted = (p, base) => {
  const abs = p.startsWith('.') ? path.posix.join(base, p) : p;
  return abs.replace(/\//g, '.');
};

// class-level JSDoc @since / @deprecated ONLY — they live in the class-doc
// block PRECEDING the `X.extend("<entity>", …)` call; member blocks (with
// their own @since) come after it and must not be read. Same rule as
// scripts/scope-of.mjs: no class-level @since ⇒ base version (<= 1.71).
function classMeta(src, name) {
  const em = src.match(new RegExp(`\\.extend\\(\\s*["']${name.replace(/\./g, '\\.')}["']`));
  const header = em ? src.slice(0, em.index) : src.slice(0, 4000);
  // @ui5-experimental-since counts too (app 203 lesson — experimental
  // controls carry no plain @since and read as base-version otherwise)
  const sinceM = header.match(/@(?:ui5-experimental-)?since\s+(?:version\s+)?([\d.]+)/i);
  const depM = header.match(/@deprecated(?:\s+As of(?:\s+version)?\s+([\d.]+))?([^\n]*)/i);
  return {
    since: sinceM ? sinceM[1] : null,
    deprecated: depM
      ? { since: depM[1] || null, text: (depM[2] || '').replace(/^[\s.,;:—-]+/, '').replace(/\s+/g, ' ').trim() }
      : null,
  };
}

function parseControl(file, base) {
  const src = fs.readFileSync(file, 'utf8');
  // the class this file defines: SomeBase.extend("sap.m.Button", ...)
  const ext = src.match(/\.extend\(\s*["']([\w.]+)["']/);
  if (!ext) return null;
  const name = ext[1];

  // parent: the identifier before .extend, resolved via the sap.ui.define deps
  const extId = src.match(/(\w+)\.extend\(\s*["'][\w.]+["']/)?.[1] ?? null;
  let parent = null;
  const defineDeps = src.match(/sap\.ui\.define\(\s*\[([^\]]*)\]/);
  const factory = src.match(/function\s*\(([^)]*)\)/);
  if (extId && defineDeps && factory) {
    const deps = [...defineDeps[1].matchAll(/["']([^"']+)["']/g)].map((m) => m[1]);
    const params = factory[1].split(',').map((p) => p.trim());
    const i = params.indexOf(extId);
    if (i >= 0 && deps[i]) parent = dotted(deps[i], base);
  }

  // every JSDoc block immediately followed by `name : {` — inside the metadata
  // literal these are the property/aggregation/association/event declarations.
  // We only record members that carry a @since; everything else counts as old.
  // duplicate names across sections (e.g. a property and a same-named event
  // PARAMETER added later) keep the MINIMUM since — an attribute is available
  // as soon as any member of that name exists
  const members = {};
  const num = (v) => v.split('.').slice(0, 2).map(Number);
  for (const m of src.matchAll(/\/\*\*((?:[^*]|\*(?!\/))*?)\*\/\s*(\w+)\s*:\s*\{/g)) {
    const since = m[1].match(/@since\s+([\d.]+)/)?.[1];
    if (!since) { members[m[2]] = members[m[2]] ?? null; continue; }
    const cur = members[m[2]];
    if (cur === undefined) members[m[2]] = since;
    else if (cur === null) { /* already available since ever */ }
    else {
      const [a1, a2] = num(cur); const [b1, b2] = num(since);
      if (b1 < a1 || (b1 === a1 && b2 < a2)) members[m[2]] = since;
    }
  }
  for (const k of Object.keys(members)) if (members[k] === null) delete members[k];
  return { name, parent, members, ...classMeta(src, name) };
}

const controls = {};
let files = 0;
let libsSeen = 0;
for (const [base, dir] of LIB_DIRS) {
  if (!fs.existsSync(dir)) {
    console.error(`WARNING: control source dir not found, skipping: ${dir}`);
    continue;
  }
  libsSeen++;
  const acc = [];
  collect(dir, base, acc);
  for (const [file, fileBase] of acc) {
    const c = parseControl(file, fileBase);
    if (!c) continue;
    controls[c.name] = { parent: c.parent, members: c.members };
    if (c.since) controls[c.name].since = c.since;
    if (c.deprecated) controls[c.name].deprecated = c.deprecated;
    files++;
  }
}
if (!libsSeen) {
  console.error(`no control source dirs found under ${OPENUI5_DIR} (set OPENUI5_DIR to an OpenUI5 checkout)`);
  process.exit(1);
}

fs.writeFileSync(OUT, JSON.stringify({
  note: 'per control: class-level @since/@deprecated + member @since, parsed from the OpenUI5 sources - input for scripts/property-check.mjs and the generate-coverage.mjs scope fallback',
  controls,
}, null, 1) + '\n');
const withSince = Object.values(controls).filter((c) => Object.keys(c.members).length).length;
const withOwn = Object.values(controls).filter((c) => c.since).length;
console.log(`properties.json: ${files} controls parsed, ${withSince} with @since members, ${withOwn} with a class-level @since`);
