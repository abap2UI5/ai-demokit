#!/usr/bin/env node
/*
 * JSON -> ABAP VALUE #( … ) generator.
 *
 * Turns a JSON array (e.g. a UI5 demo mock's ProductCollection) into an ABAP
 * internal-table literal, so inlining real demo data into a port's model_init
 * is a one-liner instead of a throwaway script (as app 164's 123 rows were).
 *
 * Importable:
 *   import { rowsToAbapValue, inferFields } from './json-to-abap.mjs';
 *   const fields = inferFields(rows);               // [{ json, abap, type }]
 *   const abap = rowsToAbapValue(rows, fields);     // "VALUE #( ( … ) … )"
 *
 * CLI:
 *   node scripts/json-to-abap.mjs <file.json> [options]
 *     --path <dotpath>     drill into the JSON (e.g. ProductCollection)
 *     --fields <spec>      comma list jsonKey[:abapName[:type]] (default: all
 *                          keys of the first row, type inferred). type ∈
 *                          {string,i,abap_bool}
 *     --var <name>         wrap as "<name> = VALUE #( … ).", else bare VALUE
 *     --limit <n>          only the first n rows
 *     --indent <n>         leading spaces for each row (default 6)
 *
 *   node scripts/json-to-abap.mjs mock/products.json --path ProductCollection \
 *     --fields Name:name,Category:category,ProductPicUrl:productpicurl,Quantity:quantity:i
 */

import fs from 'fs';
import { fileURLToPath } from 'url';

// a single-token ABAP field name derived from a JSON key: lowercased, non
// [a-z0-9_] stripped, capped at 30 chars (ABAP identifier limit). Lowercasing
// matches structural-diff's last-segment comparison ({ProductPicUrl}~{PRODUCTPICURL}).
export const abapName = (key) =>
  String(key).replace(/[^A-Za-z0-9_]/g, '').toLowerCase().slice(0, 30);

// infer an ABAP scalar type from the first non-null value seen for each key
const inferType = (v) =>
  typeof v === 'boolean' ? 'abap_bool'
    : typeof v === 'number' && Number.isInteger(v) ? 'i'
      : 'string';

export function inferFields(rows) {
  const keys = [];
  const seen = new Set();
  for (const row of rows) {
    for (const k of Object.keys(row || {})) if (!seen.has(k)) { seen.add(k); keys.push(k); }
  }
  return keys.map((json) => {
    const sample = rows.find((r) => r && r[json] != null)?.[json];
    return { json, abap: abapName(json), type: inferType(sample) };
  });
}

// a backtick ABAP string literal: content is passed verbatim, so an embedded
// backtick is doubled (ABAP's escape) and newlines are flattened to spaces
// (backtick literals cannot span lines).
const abapStr = (s) => '`' + String(s ?? '').replace(/`/g, '``').replace(/[\r\n]+/g, ' ') + '`';

const cell = (v, type) =>
  type === 'i' ? String(Math.trunc(Number(v) || 0))
    : type === 'abap_bool' ? (v === true || v === 'true' || v === 'X' || v === 1 ? 'abap_true' : 'abap_false')
      : abapStr(v);

export function rowsToAbapValue(rows, fields = inferFields(rows), { indent = 6, var: varName } = {}) {
  const pad = ' '.repeat(indent);
  const body = rows.map((row) => {
    const cells = fields.map((f) => `${f.abap} = ${cell(row?.[f.json], f.type)}`).join(' ');
    return `${pad}( ${cells} )`;
  }).join('\n');
  const value = `VALUE #(\n${body}\n${' '.repeat(Math.max(0, indent - 2))})`;
  return varName ? `${varName} = ${value}.` : value;
}

// TYPES BEGIN OF … block matching the fields (handy for the scaffolder / a
// port's DATA section)
export function rowsToAbapType(fields, structName = 'ty_row', tableName = null) {
  const w = Math.max(...fields.map((f) => f.abap.length));
  const lines = fields.map((f) => `        ${f.abap.padEnd(w)} TYPE ${f.type},`);
  let out = `      BEGIN OF ${structName},\n${lines.join('\n')}\n      END OF ${structName},`;
  if (tableName) out += `\n      ${tableName} TYPE STANDARD TABLE OF ${structName} WITH EMPTY KEY,`;
  return out;
}

// ---------- CLI ----------
function parseArgs(argv) {
  const opts = { indent: 6 };
  const rest = [];
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--path') opts.path = argv[++i];
    else if (a === '--fields') opts.fields = argv[++i];
    else if (a === '--var') opts.var = argv[++i];
    else if (a === '--limit') opts.limit = Number(argv[++i]);
    else if (a === '--indent') opts.indent = Number(argv[++i]);
    else rest.push(a);
  }
  opts.file = rest[0];
  return opts;
}

function drill(data, dotpath) {
  if (!dotpath) return data;
  return dotpath.split('.').reduce((o, k) => (o == null ? o : o[k]), data);
}

function parseFieldsSpec(spec, rows) {
  if (!spec) return inferFields(rows);
  return spec.split(',').map((token) => {
    const [json, name, type] = token.split(':');
    const sample = rows.find((r) => r && r[json] != null)?.[json];
    return { json, abap: name ? abapName(name) : abapName(json), type: type || inferType(sample) };
  });
}

function main() {
  const opts = parseArgs(process.argv.slice(2));
  if (!opts.file) {
    console.error('usage: node scripts/json-to-abap.mjs <file.json> [--path p] [--fields spec] [--var name] [--limit n] [--indent n]');
    process.exit(2);
  }
  const data = JSON.parse(fs.readFileSync(opts.file, 'utf8'));
  let rows = drill(data, opts.path);
  if (!Array.isArray(rows)) {
    console.error(`error: ${opts.path ? `--path ${opts.path}` : 'the JSON root'} is not an array`);
    process.exit(1);
  }
  if (opts.limit) rows = rows.slice(0, opts.limit);
  const fields = parseFieldsSpec(opts.fields, rows);
  process.stdout.write(rowsToAbapValue(rows, fields, { indent: opts.indent, var: opts.var }) + '\n');
}

if (process.argv[1] === fileURLToPath(import.meta.url)) main();
