#!/usr/bin/env node
/*
 * Structural view diff — compares every port's emitted view structure against
 * the original demo kit view.xml files, and matches each difference against
 * the deviations declared in the port's meta/<class>.json sidecar
 * (the meta/ sidecars are the source of truth — see scripts/validate-meta.mjs).
 *
 *   node scripts/structural-diff.mjs            advisory report
 *   node scripts/structural-diff.mjs --strict   exit 1 on undeclared diffs
 *
 * What it compares (name-level, not values):
 *  - the multiset of CONTROLS used (UpperCamelCase elements; lowercase
 *    aggregation elements are ignored on both sides, they are optional in XML)
 *  - per control, the set of attribute/property NAMES used
 * A difference is "declared" when the control/attribute name appears in one
 * of the port's deviation texts or its CHECKED note.
 *
 * Known limits (advisory by design):
 *  - controller-created UI (setTokens, controller-built dialogs) is invisible
 *    to the original view.xml side — those show up as EXTRA in the port
 *  - ports with LOOP/DO-built view parts are flagged "dynamic": counts of a
 *    control created in a loop cannot match statically
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const UI5 = path.join(ROOT, 'ui5', 'sap.m');
const STRICT = process.argv.includes('--strict');

// attribute names that never carry over 1:1
const IGNORED_ATTRS = new Set(['controllerName', 'id']);
const isControl = (qname) => /^([a-z]+:)?[A-Z]/.test(qname);
const simpleName = (qname) => qname.split(':').pop();

// ---------- original side: parse view.xml ----------
function parseXml(xml) {
  const controls = new Map();          // qname -> count
  const attrs = new Map();             // simple control name -> Set(attr names)
  const clean = xml.replace(/<!--[\s\S]*?-->/g, '');
  const tagRe = /<([A-Za-z_][\w.:-]*)((?:[^>"]|"[^"]*")*?)\/?>/g;
  let m;
  while ((m = tagRe.exec(clean)) !== null) {
    const qname = m[1];
    if (!isControl(qname)) continue;
    controls.set(qname, (controls.get(qname) || 0) + 1);
    const set = attrs.get(simpleName(qname)) || new Set();
    const attrRe = /([\w.:-]+)\s*=\s*"[^"]*"/g;
    let a;
    while ((a = attrRe.exec(m[2])) !== null) {
      if (a[1].startsWith('xmlns') || IGNORED_ATTRS.has(a[1])) continue;
      set.add(a[1]);
    }
    attrs.set(simpleName(qname), set);
  }
  return { controls, attrs };
}

// ---------- port side: parse the builder calls out of the ABAP ----------
function parseAbap(abap) {
  const controls = new Map();
  const attrs = new Map();
  // one pass over element creations; attributes are associated with the
  // element created last (that is exactly the builder's a() contract)
  const elemRe = /->\s*(open|leaf)\(\s*(?:n\s*=\s*)?`([\w:.-]+)`(?:\s+ns\s*=\s*`(\w+)`)?/g;
  const marks = [];
  let m;
  while ((m = elemRe.exec(abap)) !== null) {
    const qname = m[3] ? `${m[3]}:${m[2]}` : m[2];
    marks.push({ at: m.index, qname });
  }
  for (let i = 0; i < marks.length; i++) {
    const { qname } = marks[i];
    if (!isControl(qname)) continue;
    controls.set(qname, (controls.get(qname) || 0) + 1);
    const slice = abap.slice(marks[i].at, i + 1 < marks.length ? marks[i + 1].at : undefined);
    const set = attrs.get(simpleName(qname)) || new Set();
    // chained form: )->a( n = `key` v = ... )
    for (const a of slice.matchAll(/->\s*a\(\s*n\s*=\s*`([\w.:-]+)`/g)) {
      if (!a[1].startsWith('xmlns') && !IGNORED_ATTRS.has(a[1])) set.add(a[1]);
    }
    // up-front table form: a = VALUE #( ( `key=value` ) ... )
    for (const a of slice.matchAll(/\(\s*`([\w.:-]+)=/g)) {
      if (!a[1].startsWith('xmlns') && !IGNORED_ATTRS.has(a[1])) set.add(a[1]);
    }
    attrs.set(simpleName(qname), set);
  }
  // dynamic only when a loop actually builds view elements — a LOOP in event
  // handling must not exempt the whole app from count checks
  let dynamic = false;
  for (const block of abap.matchAll(/\b(?:LOOP AT|DO\b|WHILE\b)[\s\S]*?\b(?:ENDLOOP|ENDDO|ENDWHILE)\b/g)) {
    if (/->\s*(?:open|leaf)\(/.test(block[0])) { dynamic = true; break; }
  }
  return { controls, attrs, dynamic };
}

// ---------- per-port original views: everything the manifest lists ----------
// join key: the sample name (ui5/sap.m/<SampleName>/), derived from meta.sample
function originalViews(sampleName) {
  const dir = path.join(UI5, sampleName);
  if (!fs.existsSync(dir)) return [];
  const files = [];
  const walk = (d) => {
    for (const name of fs.readdirSync(d)) {
      const full = path.join(d, name);
      if (fs.statSync(full).isDirectory()) walk(full);
      else if (name.endsWith('.view.xml') || name.endsWith('.fragment.xml')) files.push(full);
    }
  };
  walk(dir);
  const manifest = path.join(dir, 'manifest.json');
  if (fs.existsSync(manifest)) {
    try {
      const listed = JSON.parse(fs.readFileSync(manifest, 'utf8'))['sap.ui5']?.config?.sample?.files || [];
      for (const f of listed) {
        if (!f.endsWith('.view.xml') && !f.endsWith('.fragment.xml')) continue;
        const full = path.normalize(path.join(dir, f));
        if (fs.existsSync(full) && !files.includes(full)) files.push(full);
      }
    } catch { /* unreadable manifest — directory scan already done */ }
  }
  return files;
}

// ---------- run ----------
let apps = 0, appsWithDiffs = 0, undeclaredTotal = 0;
const lines = [];
for (const metaFile of fs.readdirSync(META).sort()) {
  if (!metaFile.endsWith('.json')) continue;
  const meta = JSON.parse(fs.readFileSync(path.join(META, metaFile), 'utf8'));
  const abapPath = path.join(ROOT, meta.file);
  if (!fs.existsSync(abapPath)) continue;
  apps++;

  const views = originalViews(meta.sample.split('.sample.')[1] ?? meta.sample);
  if (!views.length) {
    lines.push(`${meta.class} (${meta.sample}): no original view.xml archived — SKIPPED`);
    continue;
  }
  const orig = { controls: new Map(), attrs: new Map() };
  for (const v of views) {
    const p = parseXml(fs.readFileSync(v, 'utf8'));
    for (const [k, n] of p.controls) orig.controls.set(k, (orig.controls.get(k) || 0) + n);
    for (const [k, s] of p.attrs) {
      const set = orig.attrs.get(k) || new Set();
      for (const a of s) set.add(a);
      orig.attrs.set(k, set);
    }
  }
  const port = parseAbap(fs.readFileSync(abapPath, 'utf8'));

  const declaredText = (meta.deviations.map((d) => d.what).join(' ') + ' ' + (meta.checked?.note || '')).toLowerCase();
  const declared = (name) => declaredText.includes(name.toLowerCase());

  const diffs = [];
  const names = new Set([...orig.controls.keys(), ...port.controls.keys()]);
  for (const qname of names) {
    if (qname === 'mvc:View' || qname === 'core:FragmentDefinition') continue;
    const o = orig.controls.get(qname) || 0;
    const p = port.controls.get(qname) || 0;
    if (o === p) continue;
    if (port.dynamic && p > 0) continue; // loop-built counts cannot match statically
    diffs.push({ kind: o > p ? 'control missing' : 'control extra', name: simpleName(qname), detail: `${qname}: original ${o} vs port ${p}` });
  }
  for (const [ctrl, oSet] of orig.attrs) {
    const pSet = port.attrs.get(ctrl);
    if (!pSet) continue; // control diff already reported
    for (const a of oSet) if (!pSet.has(a)) diffs.push({ kind: 'attr missing', name: a, detail: `${ctrl}.${a}` });
  }

  if (diffs.length) {
    appsWithDiffs++;
    lines.push(`${meta.class} (${meta.sample})${port.dynamic ? ' [dynamic]' : ''}:`);
    for (const d of diffs) {
      const ok = declared(d.name);
      if (!ok) undeclaredTotal++;
      lines.push(`  ${ok ? '  declared' : '! UNDECLARED'}  ${d.kind}  ${d.detail}`);
    }
  }
}

console.log(lines.join('\n'));
console.log(`\n${apps} ports checked, ${appsWithDiffs} with structural diffs, ${undeclaredTotal} undeclared differences.`);
if (STRICT && undeclaredTotal > 0) process.exit(1);
