#!/usr/bin/env node
/*
 * Structure lint — a fast, static check of the builder call tree in every port,
 * run BEFORE render-smoke so a malformed view is caught in milliseconds with a
 * precise message instead of a cryptic UI5 load error at the expensive gate.
 *
 *   node scripts/structure-lint.mjs            advisory report
 *   node scripts/structure-lint.mjs --strict   exit 1 on any structure error
 *
 * The one rule that matters: an AGGREGATION element (a lowercase-first tag such
 * as `content`, `columns`, `template`, `footer`, `items`) must sit directly
 * inside a CONTROL (an UpperCamelCase tag such as `Table`, `Column`). An
 * aggregation nested directly inside another aggregation is always invalid XML
 * and is the signature of a missing `)->shut(` — exactly the bug that made
 * app 164's `<footer>` land inside `<columns>` and only surfaced as
 * "failed to load sap/ui/table/footer.js" in render-smoke. We also flag a
 * `shut` with no open to close (stack underflow). Leftover open elements at the
 * end are fine — the builder's closing `).` auto-closes them.
 *
 * Ports that assemble the view across builder-helper methods (RETURNING a
 * z2ui5_cl_ai_xml handle) are skipped: their open/shut pairs span methods, so a
 * single linear stack cannot model them (render-smoke has a matching carve-out).
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const STRICT = process.argv.includes('--strict');

// element/agg classification is on the LOCAL name (ns is carried separately):
// {img>…} controls are UpperCamelCase, aggregations are lowercase-first.
const isControl = (localName) => /^[A-Z]/.test(localName);

// open/leaf/shut tokens in document order; a()/other calls are ignored
const TOKEN_RE = /->\s*(open|leaf|shut)\(\s*(?:n\s*=\s*)?(?:`([\w:.-]+)`(?:\s+ns\s*=\s*`(\w+)`)?)?/g;
const HAS_HELPER = /RETURNING\s+VALUE\(\w+\)\s+TYPE REF TO z2ui5_cl_ai_xml/;

function lintTree(abap) {
  const errs = [];
  const stack = []; // { qname, ctrl }
  for (const m of abap.matchAll(TOKEN_RE)) {
    const kind = m[1];
    if (kind === 'shut') {
      if (!stack.length) {
        errs.push('a )->shut( with no open element to close (stack underflow — one shut too many)');
        break; // tree is desynchronised; further findings would be noise
      }
      stack.pop();
      continue;
    }
    const name = m[2];
    if (!name) continue; // defensive: malformed token
    const qname = m[3] ? `${m[3]}:${name}` : name;
    const ctrl = isControl(name);
    if (!ctrl) {
      const parent = stack[stack.length - 1];
      if (!parent) {
        errs.push(`aggregation <${qname}> at the view root — expected a control`);
      } else if (!parent.ctrl) {
        errs.push(`aggregation <${qname}> nested directly inside aggregation <${parent.qname}> — a missing )->shut( ? (an aggregation must sit inside a control)`);
      }
    }
    if (kind === 'open') stack.push({ qname, ctrl });
  }
  return errs;
}

let apps = 0, skipped = 0, bad = 0, findings = 0;
const lines = [];
for (const metaFile of fs.readdirSync(META).sort()) {
  if (!metaFile.endsWith('.json')) continue;
  const meta = JSON.parse(fs.readFileSync(path.join(META, metaFile), 'utf8'));
  const abapPath = path.join(ROOT, meta.file);
  if (!fs.existsSync(abapPath)) continue;
  apps++;
  const abap = fs.readFileSync(abapPath, 'utf8');
  if (HAS_HELPER.test(abap)) { skipped++; continue; }
  const errs = lintTree(abap);
  if (errs.length) {
    bad++; findings += errs.length;
    lines.push(`${meta.class} (${meta.file}):`);
    for (const e of errs) lines.push(`  ! ${e}`);
  }
}

if (lines.length) console.log(lines.join('\n'));
console.log(`structure-lint: ${apps} ports checked, ${skipped} helper-built skipped, ${bad} with structure error(s), ${findings} finding(s).`);
if (STRICT && findings) process.exit(1);
