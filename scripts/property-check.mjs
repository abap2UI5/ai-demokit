#!/usr/bin/env node
/*
 * property-check — the 1.71 PROPERTY gate.
 *
 * The porting scope guarantees the CONTROL exists by UI5 1.71 (universe
 * snapshot). Members newer than 1.71 ARE allowed when the original sample
 * uses them (1:1 fidelity wins — policy decision 2026-07-16), but every such
 * member must be DECLARED in the port's sidecar with a POST_171 deviation
 * that names the member: this check resolves each attribute written via
 * a( n = `...` ) on a sap.m control — plus every event parameter read via
 * `${$parameters>/<name>}` inside a t_arg — against ui5/properties.json
 * (member @since, walking the parent chain) and fails on any post-1.71
 * member that no deviation mentions — see AGENTS §5. Both live in one flat
 * member namespace in the snapshot, so a post-1.71 event parameter (e.g.
 * SearchField `searchButtonPressed`, since 1.114) is caught the same way a
 * post-1.71 property is; the `$parameters>/<name>` ref is attributed to the
 * control that fired it (the one carrying the event a(), = last opened).
 *
 * Known limits: enum VALUES newer than 1.71 (e.g. ObjectStatus Indication06+)
 * are invisible at the attribute-name level; controls outside sap.m or absent
 * from the snapshot are skipped (members without @since count as old). Only
 * the first path segment after `$parameters>/` is checked (`item/oParent`
 * → `item`) — deeper segments are runtime object fields, not metadata.
 *
 * Run:  node scripts/property-check.mjs     (exit 1 on any violation)
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const DATA = JSON.parse(fs.readFileSync(path.join(ROOT, 'ui5', 'properties.json'), 'utf8')).controls;

const leq171 = (since) => {
  const m = String(since).match(/^(\d+)\.(\d+)/);
  return m ? (+m[1] < 1 || (+m[1] === 1 && +m[2] <= 71)) : true;
};

// member since via the parent chain; null = unknown/old
function sinceOf(control, member) {
  let c = control;
  for (let depth = 0; c && DATA[c] && depth < 15; depth++) {
    if (DATA[c].members[member] !== undefined) return DATA[c].members[member];
    c = DATA[c].parent;
  }
  return null;
}

// controls + their attribute names out of the builder calls (same contract as
// structural-diff: a() targets the element created last). `kind` distinguishes
// a plain attribute from an event parameter (`${$parameters>/<name>}`) so the
// error message can name what slipped through.
function usedMembers(abap) {
  const out = []; // { control, attr, line, kind }
  const elemRe = /->\s*(open|leaf)\(\s*(?:n\s*=\s*)?`([\w:.-]+)`(?:\s+ns\s*=\s*`(\w+)`)?/g;
  const marks = [];
  let m;
  while ((m = elemRe.exec(abap)) !== null) {
    marks.push({ at: m.index, name: m[2], ns: m[3] || (m[2].includes(':') ? m[2].split(':')[0] : null) });
  }
  for (let i = 0; i < marks.length; i++) {
    const { at, name, ns } = marks[i];
    const simple = name.split(':').pop();
    if (!/^[A-Z]/.test(simple)) continue;              // aggregations: lowercase
    if (ns && ns !== 'sap.m') continue;                // only sap.m is in the snapshot
    const control = `sap.m.${simple}`;
    if (!DATA[control]) continue;
    const slice = abap.slice(at, i + 1 < marks.length ? marks[i + 1].at : undefined);
    for (const a of slice.matchAll(/->\s*a\(\s*n\s*=\s*`([\w.:-]+)`/g)) {
      if (a[1].startsWith('xmlns')) continue;
      out.push({ control, attr: a[1], kind: 'attr', line: abap.slice(0, at + a.index).split('\n').length });
    }
    for (const a of slice.matchAll(/\(\s*`([\w.:-]+)=/g)) {
      if (a[1].startsWith('xmlns')) continue;
      out.push({ control, attr: a[1], kind: 'attr', line: abap.slice(0, at + a.index).split('\n').length });
    }
    // event parameters consumed in a t_arg: `${$parameters>/<name>}` — only the
    // first path segment is a metadata member (deeper parts are object fields)
    for (const a of slice.matchAll(/\$parameters>\/(\w+)/g)) {
      out.push({ control, attr: a[1], kind: 'param', line: abap.slice(0, at + a.index).split('\n').length });
    }
  }
  return out;
}

let errors = 0;
let checked = 0;
for (const mf of fs.readdirSync(META).sort()) {
  if (!mf.endsWith('.json')) continue;
  const meta = JSON.parse(fs.readFileSync(path.join(META, mf), 'utf8'));
  const abapPath = path.join(ROOT, meta.file);
  if (!fs.existsSync(abapPath)) continue;
  checked++;
  const abap = fs.readFileSync(abapPath, 'utf8');
  const declared = (meta.deviations || []).map((d) => d.what).join(' ').toLowerCase();
  const reported = new Set();
  for (const { control, attr, line, kind } of usedMembers(abap)) {
    const since = sinceOf(control, attr);
    if (since && !leq171(since) && !declared.includes(attr.toLowerCase())) {
      const key = `${control}.${kind}.${attr}`;
      if (reported.has(key)) continue;
      reported.add(key);
      const what = kind === 'param'
        ? `event parameter ${control} $parameters>/${attr}`
        : `${control}.${attr}`;
      console.log(`ERROR ${meta.file}:${line} — ${what} exists only since UI5 ${since} (> 1.71) and is not declared: add a POST_171 deviation naming it`);
      errors++;
    }
  }
}

console.log(`property-check: ${checked} ports, ${errors} undeclared post-1.71 member(s).`);
process.exit(errors ? 1 : 0);
