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

// ...and neither do the DEMO KIT SHELL classes. These live in a style.css one
// level ABOVE the samples (e.g. sap.ui.unified/.../demokit/sample/style.css)
// and no sample's own manifest lists them — the demo kit page supplies them to
// every sample in the library. A port carrying one is faithful to the sample's
// view; there is no sample stylesheet to archive, so this is not a gap.
// Verified 2026-08-21 against the OpenUI5 checkout.
const SHELL_CLASSES = new Set(['viewPadding', 'labelMarginLeft', 'fullHeight']);

const isUi5Class = (c) => KNOWN_PREFIXES.some((p) => c.startsWith(p)) || SHELL_CLASSES.has(c);

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

  for (const c of [...used].sort()) {
    const inPort = injected.includes(`.${c}`);
    const inArchive = archived.includes(`.${c}`);
    if (inPort) {
      if (VERBOSE) console.log(`ok         ${m.class}  .${c} — injected by the port`);
      continue;
    }
    // A class the ORIGINAL VIEW also carries with no rule anywhere is not a
    // port defect: the sample is bare too, and reproducing that is fidelity.
    // Checked before reporting, because it is most of the hits — measured
    // 2026-08-21, only 2 of 13 survived this test.
    if (!inArchive && originalUses(dir, c)) {
      if (VERBOSE) console.log(`faithful   ${m.class}  .${c} — the original view carries it bare too`);
      continue;
    }
    orphans++;
    const where = inArchive
      ? 'the sample\'s CSS is archived but the port never injects it'
      : 'no rule anywhere, and the ORIGINAL view does not carry this class — the port invented it';
    console.log(`ORPHAN     ${m.class}  .${c} — ${where} (${m.sample})`);
  }
}

console.log(`\norphan-style-class: ${metas.length} ports scanned, ${orphans} custom class(es) with no rule behind them.`);
if (orphans) {
  console.log('Archive the sample stylesheet under ui5/ and inject it through a core:HTML <style> leaf,');
  console.log('or declare in the sidecar that the class is decorative and carries nothing.');
}
