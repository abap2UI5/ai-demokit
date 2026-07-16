#!/usr/bin/env node
/*
 * Generates one typed metadata sidecar per port: meta/<class>.json
 * (outside src/ so abapGit never sees them), derived from the port's
 * ABAP Doc header — see TRAINING.md "Per-port metadata".
 *
 * The headers stay the source of truth for now; regenerate the sidecars
 * with  node scripts/generate-meta.mjs  after changing any header.
 *
 * status ladder: generated -> reviewed -> checked -> golden
 *  - checked comes from the "! CHECKED (date): marker
 *  - reviewed/golden have no header marker yet; they are preserved from an
 *    existing sidecar if it carries them (manual promotion)
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const SRC = path.join(ROOT, 'src');
const OUT = path.join(ROOT, 'meta');

function walk(dir, out = []) {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) walk(full, out);
    else out.push(full);
  }
  return out;
}

// same line-based header parsing as generate-overview.mjs, but keeping the
// bullets separate and typed instead of flattening them to one string
function parseHeader(content) {
  const classAt = content.search(/^CLASS /m);
  const header = classAt === -1 ? '' : content.slice(0, classAt);
  const m = header.match(/^"! https:\/\/sdk\.openui5\.org\/entity\/([\w.]+)\/sample\/([\w.]+)/m);
  if (!m) return null;
  const out = { entity: m[1], sample: m[2], checked: null, bullets: [] };
  let section = null;
  for (const raw of header.split('\n')) {
    if (!raw.startsWith('"!')) continue;
    const t = raw.replace(/^"!\s?/, '').replace(/\s+$/, '');
    const cm = t.match(/^CHECKED \((\d{4}-\d{2}-\d{2})\):\s*(.*)$/);
    if (cm) {
      section = 'checked';
      out.checked = { date: cm[1], note: cm[2] };
    } else if (/^NOTES \(generation\):$/.test(t)) {
      section = 'notes';
    } else if (/^[A-Z][A-Z0-9 ()/_-]*:/.test(t) && !t.startsWith('- ')) {
      section = null;
    } else if (section === 'checked') {
      out.checked.note += ' ' + t.trim();
    } else if (section === 'notes') {
      if (t.startsWith('- ')) out.bullets.push(t.slice(2));
      else if (out.bullets.length) out.bullets[out.bullets.length - 1] += ' ' + t.trim();
    }
  }
  return out;
}

// closed vocabulary — see TRAINING.md. Bullets without a tag become NOTE.
function typeOf(bullet) {
  if (bullet.startsWith('IMPROVISED:')) return ['IMPROVISED', bullet.slice('IMPROVISED:'.length).trim()];
  if (bullet.startsWith('LIVE-TEST:')) return ['LIVE_TEST', bullet.slice('LIVE-TEST:'.length).trim()];
  if (bullet.startsWith('1.71:')) return ['DROPPED_171', bullet.slice('1.71:'.length).trim()];
  return ['NOTE', bullet];
}

fs.mkdirSync(OUT, { recursive: true });
let count = 0;
const seen = new Set();
for (const f of walk(SRC)) {
  if (!f.endsWith('.clas.abap')) continue;
  const cls = path.basename(f, '.clas.abap');
  const parsed = parseHeader(fs.readFileSync(f, 'utf8'));
  if (!parsed) continue;

  const outFile = path.join(OUT, `${cls}.json`);
  let previous = {};
  if (fs.existsSync(outFile)) {
    try { previous = JSON.parse(fs.readFileSync(outFile, 'utf8')); } catch { /* regenerate */ }
  }
  // manual promotions survive regeneration; the checked marker always wins
  let status = parsed.checked ? 'checked' : 'generated';
  if (['reviewed', 'golden'].includes(previous.status) && !parsed.checked) status = previous.status;
  if (previous.status === 'golden' && parsed.checked) status = 'golden';

  const file = path.relative(ROOT, f).split(path.sep).join('/');
  // batch = the b<nn> subpackage the port lives in (src/<lib>/b<nn>/...)
  const batch = file.match(/^src\/[^/]+\/(b\d+)\//)?.[1] ?? null;
  const meta = {
    class: cls,
    sample: parsed.sample,
    entity: parsed.entity,
    file,
    batch,
    status,
    checked: parsed.checked,
    deviations: parsed.bullets.map((b) => {
      const [type, what] = typeOf(b);
      return { type, what };
    }),
  };
  fs.writeFileSync(outFile, JSON.stringify(meta, null, 2) + '\n');
  seen.add(`${cls}.json`);
  count++;
}

// drop sidecars whose port is gone
for (const f of fs.readdirSync(OUT)) {
  if (f.endsWith('.json') && !seen.has(f)) {
    fs.unlinkSync(path.join(OUT, f));
    console.log(`removed orphan ${f}`);
  }
}
console.log(`meta: ${count} sidecars written to meta/`);
