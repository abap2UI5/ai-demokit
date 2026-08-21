#!/usr/bin/env node
/*
 * orphan-style-class-probe — find a port that carries a CUSTOM style class
 * with no rule behind it.
 *
 * The sample's own stylesheet is part of the sample. When a port keeps
 * `class="demoBox"` but the rule that makes a demoBox a blue rounded box never
 * came along, the port renders bare text where the sample is a picture of
 * boxes — and NOTHING catches it: `structural_diff` compares the class
 * ATTRIBUTE (which matches, that is the problem), `data_fidelity` compares
 * seeded values, and the render gate only asks whether the view loads.
 *
 * CAPABILITIES marks the fix 🔶 — inject the rules through a `core:HTML`
 * `<style>` leaf — and states the rule this probe enforces: "a sample whose
 * stylesheet is not in `ui5/` is an archive gap to close, not a reason to drop
 * the CSS". Apps 122/124 closed it once, and the review sweep of 2026-08-21
 * still found it open in 133, 138 and 145, which is why it is a probe now
 * rather than a lesson.
 *
 * A hit means one of three things, in order of likelihood:
 *   the sample's stylesheet was never archived  -> archive it under ui5/, inject it
 *   it was archived but never injected          -> inject it
 *   the class is decorative and carries nothing -> say so in a deviation
 *
 * This is a PROBE, not a gate: the third case is a judgement a gate cannot
 * make. Add a prefix to KNOWN_PREFIXES when a new UI5-supplied family shows up.
 *
 *   node scripts/probes/orphan-style-class-probe.mjs
 *   node scripts/probes/orphan-style-class-probe.mjs --verbose   also list ports whose CSS is present
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
const META = path.join(ROOT, 'meta');
const UI5 = path.join(ROOT, 'ui5');
const VERBOSE = process.argv.includes('--verbose');

// Classes UI5 itself ships need no rule from us.
const KNOWN_PREFIXES = ['sapUi', 'sapM', 'sapF', 'sapTnt', 'sapUxAP', 'sapCa', 'sapContrast'];

const isUi5Class = (c) => KNOWN_PREFIXES.some((p) => c.startsWith(p));

// What the SAMPLE ITSELF declares is the evidence, never a guess about which
// class names look like demo-kit furniture. A first version of this probe
// exempted viewPadding / labelMarginLeft as "shell classes supplied by the
// demo kit page", on the strength of one sample whose manifest does not list
// them — and that was wrong: it varies PER SAMPLE. CalendarMultipleMonth
// declares no stylesheet, while CalendarMinMax's manifest carries
// `"css": [{ "uri": "../style.css" }]` and therefore genuinely owns the rule.
// So the manifest decides, and a `../` uri is resolved as written.
function declaredCss(dir) {
  const mf = path.join(dir, 'manifest.json');
  if (!fs.existsSync(mf)) return [];
  try {
    const j = JSON.parse(fs.readFileSync(mf, 'utf8'));
    const css = j?.['sap.ui5']?.resources?.css || [];
    return css.map((e) => e.uri).filter(Boolean);
  } catch { return []; }
}

const CLASS_RE = /\)->a\(\s*n\s*=\s*`class`\s*v\s*=\s*`([^`]+)`/g;


// Does the archived original view carry this class itself? A sample that ships
// no rule for a class it uses is bare by design; a port copying it is faithful.
function originalUses(dir, cls) {
  if (!fs.existsSync(dir)) return false;
  const re = new RegExp(`class="[^"]*\\b${cls}\\b`);
  const walk = (d) => {
    for (const e of fs.readdirSync(d, { withFileTypes: true })) {
      const full = path.join(d, e.name);
      if (e.isDirectory()) { if (walk(full)) return true; }
      else if (/\.(xml|js|json)$/.test(e.name) && re.test(fs.readFileSync(full, 'utf8'))) return true;
    }
    return false;
  };
  return walk(dir);
}

const metas = fs.readdirSync(META).filter((f) => f.endsWith('.json'))
  .map((f) => JSON.parse(fs.readFileSync(path.join(META, f), 'utf8')))
  .filter((m) => /^z2ui5_cl_smpc_app_\d+$/.test(m.class || ''));

let orphans = 0;
for (const m of metas) {
  const file = path.join(ROOT, m.file);
  if (!fs.existsSync(file)) continue;
  const src = fs.readFileSync(file, 'utf8');

  const used = new Set();
  for (const hit of src.matchAll(CLASS_RE)) {
    for (const c of hit[1].split(/\s+/)) if (c && !isUi5Class(c)) used.add(c);
  }
  if (!used.size) continue;

  // what the port itself injects, in any <style> leaf (braces are escaped there)
  const injected = src.replace(/\\([{}])/g, '$1');

  // and what the sample shipped, if it was archived at all
  const lib = (m.sample || '').split('.').slice(0, -2).join('.');
  const name = (m.sample || '').split('.').pop();
  const dir = path.join(UI5, lib, name);
  let archived = '';
  if (fs.existsSync(dir)) {
    const walk = (d) => {
      for (const e of fs.readdirSync(d, { withFileTypes: true })) {
        const full = path.join(d, e.name);
        if (e.isDirectory()) walk(full);
        else if (e.name.endsWith('.css')) archived += fs.readFileSync(full, 'utf8');
      }
    };
    walk(dir);
  }
  // ...including a stylesheet the manifest points at OUTSIDE the sample folder.
  // The shared `../style.css` of the sap.ui.unified samples is exactly that:
  // walking the sample directory alone would report its classes as bare and
  // quietly excuse ten ports that render unpadded where the sample is padded.
  for (const uri of declaredCss(dir)) {
    const target = path.resolve(dir, uri);
    if (!target.startsWith(dir) && fs.existsSync(target)) archived += fs.readFileSync(target, 'utf8');
  }

  // (1) the archive gap: the sample DECLARES a stylesheet that never came along
  for (const uri of declaredCss(dir)) {
    const target = path.resolve(dir, uri);
    if (!fs.existsSync(target)) {
      orphans++;
      const rel = path.relative(ROOT, target);
      console.log(`ARCHIVE-GAP ${m.class}  manifest declares "${uri}" — not archived (expected ${rel}) (${m.sample})`);
    }
  }

  // (2) the injection gap: a class the port carries with no rule reaching the
  // view. Four outcomes, and the message has to name the right one — a wrong
  // diagnosis here sends the next reader after the wrong file.
  const declared = declaredCss(dir);
  const missingCss = declared.filter((u) => !fs.existsSync(path.resolve(dir, u)));
  for (const c of [...used].sort()) {
    if (injected.includes(`.${c}`)) {
      if (VERBOSE) console.log(`ok          ${m.class}  .${c} — injected by the port`);
      continue;
    }
    if (archived.includes(`.${c}`)) {
      orphans++;
      console.log(`ORPHAN      ${m.class}  .${c} — the rule IS archived, the port just never injects it (${m.sample})`);
      continue;
    }
    if (missingCss.length) {
      orphans++;
      console.log(`ORPHAN      ${m.class}  .${c} — its rule is most likely in the unarchived ${missingCss[0]}; archive that first (${m.sample})`);
      continue;
    }
    if (originalUses(dir, c)) {
      // The sample carries the class bare too. Reproducing that is fidelity,
      // not a defect — this is most of what a naive class scan turns up.
      if (VERBOSE) console.log(`faithful    ${m.class}  .${c} — the original view carries it bare too`);
      continue;
    }
    orphans++;
    console.log(`ORPHAN      ${m.class}  .${c} — no rule anywhere and the ORIGINAL view never carries it: the port invented it (${m.sample})`);
  }
}

console.log(`\norphan-style-class: ${metas.length} ports scanned, ${orphans} custom class(es) with no rule behind them.`);
if (orphans) {
  console.log('Archive the sample stylesheet under ui5/ and inject it through a core:HTML <style> leaf,');
  console.log('or declare in the sidecar that the class is decorative and carries nothing.');
}
