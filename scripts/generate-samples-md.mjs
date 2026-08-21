#!/usr/bin/env node
/*
 * generate-samples-md — SAMPLES.md, the catalogue you can read without an SAP
 * system.
 *
 * This repository had two documents about its ports and neither answered the
 * question somebody arrives with. `api.md` is a COVERAGE table: one row per
 * demo kit sample including the 300 that are not ported, keyed by control and
 * built to show what is missing. The in-system overview app is the catalogue,
 * and reaching it costs an installed framework, an abapGit pull and an HTTP
 * handler. Until then a visitor sees 431 classes called
 * `z2ui5_cl_smpc_app_<number>`, and "is there a port that shows X" has no
 * answer on GitHub.
 *
 * Since the ports carry `" @keywords` and `" @summary`, the catalogue can be
 * written from the classes themselves - which is the point: the same two lines
 * feed this page, the overview app's search box and abap2UI5/mcp-server, so none
 * of the three can say something the class does not.
 *
 * The row shape is deliberately IDENTICAL to abap2UI5/samples and
 * abap2UI5/samples-stack:
 *
 *   | **<title>**                      | [`CLASS`](path) |
 *     <br>the summary sentence
 *     <br><sub>the search terms</sub>
 *
 * One parser reads all three catalogues (mcp-server's `examples` tool), and a
 * reader who has seen one page can read the other two. A change to the shape
 * here is a change to a contract, not to a layout.
 *
 * The one addition this repository makes to that shape is a TRAILING block per
 * row — `<br><sub>✓ checked · 2 deviations</sub>` — carrying the sidecar's
 * verification status, which used to live only in meta/<class>.json and
 * STATUS.md, invisible to anybody browsing the catalogue. It is safe against
 * the shared parser BY ITS DESIGN, not by luck: mcp-server matches the blocks
 * after a row title as one group and reads the FIRST `<sub>` that does not
 * start `docs:` as the keywords, ignoring blocks it does not know — exactly so
 * that a catalogue can grow a block without breaking the other two. The marker
 * therefore comes AFTER the keywords block and is only emitted when a keywords
 * block exists, or it would be mistaken for one.
 *
 *   node scripts/generate-samples-md.mjs          write it
 *   node scripts/generate-samples-md.mjs --check  fail if it is stale (CI)
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { readDescript } from './lib/descript.mjs';
import { isSkippedDir } from './lib/src-tree.mjs';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const OUT = path.join(ROOT, 'SAMPLES.md');
const CHECK = process.argv.includes('--check');

/* `|` ends a table cell, and `<` opens a tag: the DESCRIPT is read unescaped
 * now (scripts/lib/descript.mjs), so a description containing `<` would reach
 * the page as markup rather than as text. No port's text contains one today —
 * this costs nothing and stops the next one being a rendering bug. */
const cell = (s) => String(s || '')
  .replace(/\|/g, '\\|')
  .replace(/</g, '&lt;')
  .replace(/>/g, '&gt;')
  .trim();

const walk = (dir, out = []) => {
  for (const name of fs.readdirSync(dir).sort()) {
    const full = path.join(dir, name);
    if (isSkippedDir(name)) continue;
    if (fs.statSync(full).isDirectory()) walk(full, out);
    else if (full.endsWith('.clas.abap')) out.push(full);
  }
  return out;
};

/** Everything the catalogue says about a port, read off the class. */
function scan() {
  const out = [];
  for (const file of walk(path.join(ROOT, 'src'))) {
    const cls = path.basename(file, '.clas.abap');
    const source = fs.readFileSync(file, 'utf8');
    if (!/INTERFACES\s+z2ui5_if_app\s*\./i.test(source)) continue;

    const descript = readDescript(file);
    const cut = descript.indexOf(' - ');
    const rel = path.relative(ROOT, file).split(path.sep).join('/');
    const metaPath = path.join(ROOT, 'meta', `${cls}.json`);
    const meta = fs.existsSync(metaPath) ? JSON.parse(fs.readFileSync(metaPath, 'utf8')) : null;

    out.push({
      cls,
      rel,
      header: cut === -1 ? descript : descript.slice(0, cut),
      sub: cut === -1 ? '' : descript.slice(cut + 3),
      summary: (source.match(/^" @summary (.+?)\r?$/m) || [, ''])[1].trim(),
      keywords: (source.match(/^" @keywords (.+?)\r?$/m) || [, ''])[1].trim(),
      sample: meta?.sample || '',
            // the UI5 library this port is about - the section it is filed under.
      // From the sidecar's `entity` where there is one; src/03 has none (those
      // controls ship with SAPUI5, not OpenUI5) and names the library in its
      // DESCRIPT instead.
      lib: meta?.entity
        ? meta.entity.split('.').slice(0, -1).join('.')
        : (cut === -1 ? descript : descript.slice(0, cut)),
      sapui5: !meta && cls.includes('_sapui5_'),
      overview: cls === 'z2ui5_cl_smpc_app_000',
      status: meta?.status || '',
      devCount: (meta?.deviations || []).length,
    });
  }
  return out;
}

const all = scan();
const overview = all.find((s) => s.overview);
const ports = all.filter((s) => !s.overview && !s.sapui5);
const sapui5 = all.filter((s) => s.sapui5);

/* The DESCRIPT's second half is NOT rendered here, unlike in the two sibling
 * catalogues, and the difference is a fact about this repository: a port's
 * short text is the demo kit's sentence cut at 60 characters ("An
 * ActionListItem can be used like a"), and the untruncated sentence is the
 * `@summary` directly below it. Printing both would print the same words
 * twice, the first time broken off mid-word. */
/* The verification marker — the sidecar's status ladder, one symbol each,
 * defined in the legend at the top of the page. The SAPUI5 collection carries
 * none: those classes have no sidecar because they are not ports. */
const MARK = { checked: '✓ checked', reviewed: '◐ reviewed', generated: '○ generated' };

const row = (s) => {
  const head = `**${cell(s.header)}**`;
  const summary = s.summary ? `<br>${cell(s.summary)}` : `<br>${cell(s.sub)}`;
  const keywords = s.keywords ? `<br><sub>${cell(s.keywords)}</sub>` : '';
  /* Only ever AFTER a keywords block — the shared parser reads the first
   * <sub> block as the keywords (see the header comment). */
  const mark = keywords && MARK[s.status]
    ? `<br><sub>${MARK[s.status]}${s.devCount ? ` · ${s.devCount} deviation${s.devCount === 1 ? '' : 's'}` : ''}</sub>`
    : '';
  return `| ${head}${summary}${keywords}${mark} | [\`${s.cls.toUpperCase()}\`](${s.rel}) |`;
};

const table = (items) => [
  '| Sample | Class |',
  '|---|---|',
  ...items.map(row),
].join('\n');

/* One section per UI5 library, biggest first - somebody looking for a control
 * knows its library (`sap.m.Wizard`), and nothing else about a port groups it
 * as usefully. The class NUMBER groups by porting batch, which is a fact about
 * this repository's history rather than about the ports. */
const byLib = new Map();
for (const s of ports) {
  if (!byLib.has(s.lib)) byLib.set(s.lib, []);
  byLib.get(s.lib).push(s);
}
const libs = [...byLib].sort((a, b) => b[1].length - a[1].length || a[0].localeCompare(b[0]));

const anchor = (t) => t.toLowerCase().replace(/[^\w\- ]/g, '').replace(/ /g, '-');
const jump = libs.map(([lib]) => `[${lib}](#${anchor(lib)})`).join(' · ');

const body = libs
  .map(([lib, items]) => `### ${lib}\n\n${items.length} port(s).\n\n${table(items)}`)
  .join('\n\n');

const page = `<!-- Generated by scripts/generate-samples-md.mjs. Do not edit by hand:
     run \`npm run samples:md\` and commit the result (AGENTS.md section 7). -->

# The sample catalogue

Every port in this repository — ${ports.length + sapui5.length} of them — with what it shows and a
link to its source. This is the [overview app](${overview ? overview.rel : ''})
as a page you can read here, before installing anything.

**What this repository is:** the UI5 demo kit, rebuilt in ABAP. Each port
answers "how is this control expressed in abap2UI5", and its sentence below is
the demo kit's own description of the sample it was rebuilt from. For the
neighbouring question — *has somebody already built an app that does X* — see
[abap2UI5/samples](https://github.com/abap2UI5/samples/blob/main/SAMPLES.md);
for apps that need something from your stack (OData, RAP, APC, the launchpad),
[abap2UI5/samples-stack](https://github.com/abap2UI5/samples-stack/blob/main/SAMPLES.md).
All three pages have the same shape on purpose.

**To run one:** install [abap2UI5](https://github.com/abap2UI5/abap2UI5), pull
this repository with [abapGit](https://abapgit.org), then open
\`<your endpoint>?app_start=<the class in the right-hand column>\`. Or start
\`${overview ? overview.cls.toUpperCase() : ''}\` and click through them there.

**To read one:** click the class. Every port is a single class, so the link is
the whole sample.

**How far each one is verified** — the small marker closing a row:
✓ \`checked\`, a human watched this port run in a real system ·
◐ \`reviewed\`, read against its original, not yet run ·
○ \`generated\`, machine-written and not yet reviewed.
\`· n deviations\` counts the declared, typed differences from the original —
what each one is lives in the port's \`meta/<class>.json\`, and
[STATUS.md](STATUS.md) carries the corpus-wide tallies. The SAPUI5 collection
at the end carries no marker: those are hand-written samples, not ports.

For what is NOT here — which demo kit samples are still unported and why — see
[api.md](api.md), the coverage table.

---

## The ports — by UI5 library

${jump}

${body}

---

## SAPUI5-only controls — \`src/03\`

${sapui5.length} controls that ship with SAPUI5 and not with OpenUI5, so there is no demo
kit original in this repository's sample universe and no 1:1 port. They are
collected as orientation — how the control is expressed in abap2UI5 — and are
held to a lower bar than the ports above.

${table(sapui5)}

---

_Generated from the classes themselves: the title is the abapGit short text, the
sentence is \`" @summary\` and the small type is \`" @keywords\`; the
verification marker is the \`status\` in \`meta/<class>.json\`. Change one of
those and this page moves with it — \`npm run samples:md\`._
`;

if (CHECK) {
  const current = fs.existsSync(OUT) ? fs.readFileSync(OUT, 'utf8') : '';
  if (current !== page) {
    console.error('SAMPLES.md is stale — run `npm run samples:md` and commit the result.');
    process.exit(1);
  }
  console.log(`SAMPLES.md: current (${ports.length} ports, ${sapui5.length} SAPUI5-only)`);
} else {
  fs.writeFileSync(OUT, page);
  console.log(`SAMPLES.md: ${ports.length} ports in ${libs.length} librarie(s), ${sapui5.length} SAPUI5-only`);
}
