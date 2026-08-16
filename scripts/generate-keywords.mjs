#!/usr/bin/env node
/*
 * generate-keywords — give every port a `" @keywords` line, derived.
 *
 * These 431 classes carried nothing: no keyword line, no summary, and (bar 15
 * of them) no ABAP Doc either. A port was reachable by its class name -
 * z2ui5_cl_smpc_app_003 - and by nothing else. Somebody looking for "how do I
 * do breadcrumbs" found it only by knowing the number, and so did an agent.
 *
 * Nothing here is invented, and that is the point. Every term comes from data
 * already in the repository, out of three places that describe the same port
 * from different angles:
 *
 *   meta/<class>.json `entity`   sap.m.Breadcrumbs -> `breadcrumbs`, `sap.m`
 *                                the UI5 control this port is ABOUT, and its
 *                                library. The single most likely search term.
 *   the class DESCRIPT           "sap.m.Breadcrumbs - breadcrumb trail with
 *                                separator" -> `breadcrumb trail separator`.
 *                                The demo kit's own words for what it shows,
 *                                truncated at 60 characters but real.
 *   the ele( ) / tag( ) chain    Breadcrumbs, HBox, Label, Link, Select -
 *                                what the port actually BUILDS, which is what
 *                                somebody searching for "link inside a select"
 *                                is looking for.
 *
 * Written as generated-and-committed rather than resolved at read time: the
 * line has to be IN the class, because a class file is what a search engine
 * serves, what abapGit pulls into the system and what an agent reads. That is
 * the whole argument for the class over the sidecar, and it would be undone by
 * keeping the terms in a sidecar and computing them on demand.
 *
 *   node scripts/generate-keywords.mjs          write the lines
 *   node scripts/generate-keywords.mjs --check  fail if a line is missing or
 *                                               out of date (CI runs this)
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const CHECK = process.argv.includes('--check');

/* Words that describe every port equally and therefore separate none of them.
 * The same reasoning as the scaffolding left out of samples-stack's keywords:
 * a term in all 431 lines costs a search nothing and costs a reader a line. */
const NOISE = new Set([
  'a', 'an', 'the', 'and', 'or', 'of', 'in', 'on', 'to', 'for', 'with', 'from',
  'by', 'as', 'at', 'is', 'are', 'be', 'can', 'used', 'use', 'using', 'this',
  'that', 'it', 'its', 'sample', 'samples', 'demo', 'example', 'view', 'page',
  'control', 'controls', 'ui5', 'sapui5', 'openui5', 'abap2ui5',
  // left over when a 60-character DESCRIPT is cut mid-sentence: "An
  // ActionListItem can be used like a" contributed `like` to that port's line
  'like', 'when', 'how', 'you', 'your', 'has', 'have', 'will', 'if', 'so',
  'also', 'other', 'some', 'more', 'one', 'two', 'their', 'them', 'which',
]);

const walk = (dir, out = []) => {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) walk(full, out);
    else if (full.endsWith('.clas.abap')) out.push(full);
  }
  return out;
};

/** camelCase and dotted names split into the words somebody would type. */
function terms(entity) {
  if (!entity) return [];
  const parts = entity.split('.');
  const name = parts.pop();
  const lib = parts.join('.');            // sap.m, sap.ui.table
  const words = name.replace(/([a-z0-9])([A-Z])/g, '$1 $2').toLowerCase().split(/\s+/);
  return [name.toLowerCase(), ...words, lib].filter(Boolean);
}

const problems = [];
let written = 0;
let already = 0;

/* The overview app is itself generated, header and all, by
 * generate-overview.mjs - which writes its @keywords and @summary lines. Two
 * generators writing the same file would fight: whichever ran last would win
 * and the other's drift gate would go red. It is also the one app here with no
 * `entity` and no DESCRIPT to derive from, so there is nothing to derive. */
const GENERATED = 'z2ui5_cl_smpc_app_overview';

for (const file of walk(path.join(ROOT, 'src'))) {
  const cls = path.basename(file, '.clas.abap');
  if (cls === GENERATED) continue;
  const source = fs.readFileSync(file, 'utf8');
  if (!/INTERFACES\s+z2ui5_if_app\s*\./i.test(source)) continue;

  const metaPath = path.join(ROOT, 'meta', `${cls}.json`);
  const meta = fs.existsSync(metaPath) ? JSON.parse(fs.readFileSync(metaPath, 'utf8')) : {};

  const xmlPath = file.replace(/\.clas\.abap$/, '.clas.xml');
  const descript = fs.existsSync(xmlPath)
    ? (fs.readFileSync(xmlPath, 'utf8').match(/<DESCRIPT>([^<]*)<\/DESCRIPT>/) || [, ''])[1]
    : '';
  // the half after the ` - `: the demo kit's own words, not the entity again
  const said = descript.includes(' - ') ? descript.slice(descript.indexOf(' - ') + 3) : '';

  /* Controls only. In a builder chain a control is CamelCase (`Button`,
   * `VBox`) and an aggregation is lowercase (`content`, `items`, `cells`) -
   * so the case is the discriminator, and it is exact rather than a list to
   * maintain. An aggregation name is not what anybody searches for: `content`
   * appeared in 93 of the 431 lines and told a reader nothing. */
  const built = [...source.matchAll(/\)->(?:ele|tag)\(\s*`([A-Z][A-Za-z]*)`/g)].map((m) => m[1]);

  const seen = new Set();
  const out = [];
  const add = (w) => {
    const t = String(w).toLowerCase().replace(/[^a-z0-9.:_-]/g, '');
    if (!t || t.length < 2 || NOISE.has(t) || seen.has(t)) return;
    seen.add(t);
    out.push(t);
  };

  terms(meta.entity).forEach(add);
  said.split(/[\s,/()]+/).forEach(add);
  built.forEach((c) => add(c));

  const line = `" @keywords ${out.slice(0, 12).join(' ')}`;
  const have = (source.match(/^" @keywords .*$/m) || [null])[0];

  if (have === line) { already += 1; continue; }
  if (CHECK) {
    problems.push(have
      ? `${cls}: the @keywords line is out of date — run \`npm run keywords\``
      : `${cls}: no \`" @keywords\` line — run \`npm run keywords\``);
    continue;
  }
  fs.writeFileSync(file, have
    ? source.replace(/^" @keywords .*$/m, line)
    : `${line}\n${source}`);
  written += 1;
}

console.log(CHECK
  ? `keywords: ${already} port(s) carry the line the sources imply`
  : `keywords: ${written} written, ${already} already current`);

if (problems.length) {
  console.error(`\n${problems.length} problem(s):`);
  for (const p of problems.slice(0, 10)) console.error(`  ${p}`);
  if (problems.length > 10) console.error(`  … and ${problems.length - 10} more`);
  console.error('\nThe line is derived from meta/<class>.json, the class DESCRIPT and the');
  console.error('controls the port builds. Change one of those and the line moves with it.');
  process.exit(1);
}
