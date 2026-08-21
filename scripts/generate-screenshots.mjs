#!/usr/bin/env node
/*
 * generate-screenshots - a thumbnail per port for the web/search catalogue.
 *
 * Ported from abap2UI5/samples scripts/generate-screenshots.mjs, which proved
 * the pattern: the abap2UI5-linter's render gate reconstructs each view from
 * its z2ui5_cl_ui5_view_builder calls, seeds it with a model derived from the
 * class's own TYPES/DATA and renders it headless - and `screenshotFiles` is
 * that same harness kept standing long enough to photograph it. A thumbnail
 * is therefore the render gate's view of the port, not a staged picture.
 *
 * GENERATED AT DEPLOY, NEVER COMMITTED - the same decision as apps.json in
 * the same folder, for the same reason: deploy-web writes web/search/thumbs/
 * fresh on every deploy, so the pictures are never staler than the classes,
 * and a port pull request carries no binary diff. The card treats a missing
 * picture as "no picture" (the <img> removes itself onerror), so this script
 * is allowed to skip what it cannot photograph:
 *
 *   - the src/03 collection is skipped UP FRONT: those classes build SAPUI5
 *     controls (sap.viz, sap.gantt, ...) the harness's OpenUI5 runtime does
 *     not ship, so every render could only fail - the render gate does not
 *     see them either (no sidecar, AGENTS.md section 3);
 *   - the overview app z2ui5_cl_smpc_app_000 is skipped like everywhere else
 *     on this page - it is the catalogue, not a port in it;
 *   - a port whose view does not survive the headless render (external card
 *     manifest, declared render_smoke skips, ...) is reported and skipped -
 *     its card simply has no thumbnail;
 *   - only when NOTHING could be photographed does the run fail, because
 *     that is a harness problem (no browser, broken runtime), not a port
 *     one, and a deploy that silently dropped every picture would look like
 *     a design change.
 *
 * COST, MEASURED (2026-08-21, dev container, chromium preinstalled): the
 * full 416-port corpus in 3 m 50 s - ~0.55 s per port - writing 412 PNGs,
 * 15 MB; the 4 misses each carried a real per-port reason (an external card
 * manifest, two strict-type enum seeds, a font collection), which is the
 * skip path working, not a harness failure. Even doubled for a Pages runner
 * that is well inside deploy-web's budget, and the workflow's timeout
 * comment carries the same number. `--limit` exists for a local smoke,
 * `--only` for one port.
 *
 * Needs the devDependencies (the linter and its render runtime) plus the
 * playwright chromium the render gate drives.
 *
 *   node scripts/generate-screenshots.mjs                write web/search/thumbs/
 *   node scripts/generate-screenshots.mjs --limit 10     a quick local smoke
 *   node scripts/generate-screenshots.mjs --only z2ui5_cl_smpc_app_005
 *   node scripts/generate-screenshots.mjs --out DIR      write elsewhere
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { screenshotFiles } from '@abap2ui5/linter';
import { isSkippedDir } from './lib/src-tree.mjs';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const argOut = process.argv.indexOf('--out');
const OUT = argOut === -1
  ? path.join(ROOT, 'web', 'search', 'thumbs')
  : path.resolve(process.argv[argOut + 1]);
const argLimit = process.argv.indexOf('--limit');
const LIMIT = argLimit === -1 ? Infinity : Number(process.argv[argLimit + 1]);
const argOnly = process.argv.indexOf('--only');
const ONLY = argOnly === -1 ? null : process.argv[argOnly + 1];

/* The card thumbnail's viewport - same frame as the samples page: 4:3 at a
 * laptop-ish width, viewport only, because the first screen is what a reader
 * recognises a port by and a full-page shot of a long table would shrink to
 * an unreadable strip. The CSS crops to the same ratio. */
const SIZE = { width: 800, height: 600 };

/* One browser session per chunk - bigger chunks amortise the browser start,
 * a whole corpus in one call holds every PNG in memory at once and one crash
 * would take all pictures with it. */
const CHUNK = 25;

const walk = (dir, out = []) => {
  for (const name of fs.readdirSync(dir).sort()) {
    const full = path.join(dir, name);
    if (isSkippedDir(name)) continue;
    if (fs.statSync(full).isDirectory()) walk(full, out);
    else if (full.endsWith('.clas.abap')) out.push(full);
  }
  return out;
};

const ports = [];
for (const file of walk(path.join(ROOT, 'src'))) {
  const cls = path.basename(file, '.clas.abap');
  if (cls === 'z2ui5_cl_smpc_app_000') continue;          // the overview app
  if (file.split(path.sep).includes('03')
    && cls.includes('_sapui5_')) continue;                // src/03 collection
  if (ONLY && cls !== ONLY) continue;
  if (!/INTERFACES\s+z2ui5_if_app\s*\./i.test(fs.readFileSync(file, 'utf8'))) continue;
  ports.push({ cls, file });
}
const tiles = ports.slice(0, LIMIT);
fs.mkdirSync(OUT, { recursive: true });

let written = 0;
const skipped = [];
for (let i = 0; i < tiles.length; i += CHUNK) {
  const chunk = tiles.slice(i, i + CHUNK);
  const byFile = new Map(chunk.map((t) => [t.file, t]));
  const shots = await screenshotFiles([...byFile.keys()], { ...SIZE, fullPage: false });
  for (const shot of shots) {
    /* A class can build several documents - the main view first, then popup
     * fragments. The thumbnail is the main view; index 0 is what the app
     * opens with. */
    if (shot.index !== 0) continue;
    const tile = byFile.get(shot.file);
    if (!tile) continue;
    if (!shot.png || shot.errors.length) {
      skipped.push(`${tile.cls}: ${shot.errors[0] || 'no picture'}`);
      continue;
    }
    fs.writeFileSync(path.join(OUT, `${tile.cls}.png`), shot.png);
    written++;
  }
  console.log(`generate-screenshots: ${Math.min(i + CHUNK, tiles.length)}/${tiles.length} rendered, ${written} written`);
}

for (const line of skipped) console.warn(`no thumbnail for ${line}`);
console.log(`${path.relative(ROOT, OUT)}: ${written} of ${tiles.length} ports photographed`
  + (skipped.length ? `, ${skipped.length} skipped (their cards show no picture)` : ''));

if (written === 0 && tiles.length > 0) {
  console.error('nothing could be photographed - that is a harness problem (browser, render runtime), not a port one');
  process.exit(1);
}
