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

export function inferFields(rows) {
  const keys = [];
  const seen = new Set();
  for (const row of rows) {
    for (const k of Object.keys(row || {})) if (!seen.has(k)) { seen.add(k); keys.push(k); }
  }
  // Infer the type from ALL values of a key, not just the first — a numeric
  // column whose first row is integer-valued (956) but later rows carry
  // decimals (1650.99) must NOT infer 'i' (which truncates via Math.trunc).
  // Any non-integer number → 'string' so the value is emitted as a backtick
  // literal (no truncation); declare that field TYPE p … DECIMALS n in ABAP,
  // where a backtick literal converts to packed (app 171/174 pattern).
  const decimalCols = [];
  const fields = keys.map((json) => {
    const values = rows.map((r) => (r ? r[json] : null)).filter((v) => v != null);
    let type;
    if (values.length === 0) type = 'string';
    else if (values.every((v) => typeof v === 'boolean')) type = 'abap_bool';
    else if (values.every((v) => typeof v === 'number')) {
      type = values.every((v) => Number.isInteger(v)) ? 'i' : 'string';
      if (type === 'string') decimalCols.push(json);
    } else type = 'string';
    return { json, abap: abapName(json), type };
  });
  if (decimalCols.length) {
    process.stderr.write(
      `json-to-abap: WARNING — decimal column(s) [${decimalCols.join(', ')}] emitted as ` +
      `string literals to avoid integer truncation; declare each TYPE p LENGTH n DECIMALS m ` +
      `in ABAP (a backtick literal converts to packed).\n`);
  }
  return fields;
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
  // clamped like the closing line below: String.repeat throws on a negative
  // count, and an importing caller deserves odd indentation rather than a
  // RangeError out of a formatting helper
  const pad = ' '.repeat(Math.max(0, indent));
  // Spalten ausrichten: jede Zelle wird auf die breiteste ihrer Spalte
  // aufgefuellt, damit die Tabelle als Tabelle lesbar ist. Die LETZTE Spalte
  // bleibt ungepolstert - sonst stuenden Leerzeichen vor dem schliessenden ")".
  // Reisst eine Zeile damit das 255-Zeichen-Limit (AGENTS 6), wird ohne
  // Polsterung ausgegeben und der Aufrufer bricht die Zeile von Hand um.
  const grid = rows.map((row) => fields.map((f) => `${f.abap} = ${cell(row?.[f.json], f.type)}`));
  const width = fields.map((_, j) => Math.max(...grid.map((r) => r[j].length)));
  const line = (cells) => `${pad}( ${cells.join(' ')} )`;
  const padded = grid.map((r) => line(r.map((c, j) => (j === r.length - 1 ? c : c.padEnd(width[j])))));
  const body = (padded.some((l) => l.length > 255) ? grid.map(line) : padded).join('\n');
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

// all-rows type inference for a single key (same rule as inferFields) — never
// infer 'i' from the first row when a later row carries a decimal.
function inferTypeForKey(rows, json) {
  const values = rows.map((r) => (r ? r[json] : null)).filter((v) => v != null);
  if (values.length === 0) return 'string';
  if (values.every((v) => typeof v === 'boolean')) return 'abap_bool';
  if (values.every((v) => typeof v === 'number')) {
    return values.every((v) => Number.isInteger(v)) ? 'i' : 'string';
  }
  return 'string';
}

function parseFieldsSpec(spec, rows) {
  if (!spec) return inferFields(rows);
  return spec.split(',').map((token) => {
    const [json, name, type] = token.split(':');
    const inferred = type || inferTypeForKey(rows, json);
    if (!type && inferred === 'string'
      && rows.some((r) => typeof (r && r[json]) === 'number' && !Number.isInteger(r[json]))) {
      process.stderr.write(`json-to-abap: WARNING — column '${json}' has decimal value(s), emitted as string literals to avoid truncation; declare it TYPE p LENGTH n DECIMALS m.\n`);
    }
    return { json, abap: name ? abapName(name) : abapName(json), type: inferred };
  });
}

function main() {
  const opts = parseArgs(process.argv.slice(2));
  /* Both counts have to be non-negative integers, not merely finite. A
   * negative --indent reached String.repeat and killed the run with a
   * RangeError stack trace instead of this usage line; a negative --limit is
   * worse because it does not fail at all - `rows.slice(0, -1)` silently drops
   * the LAST row where the flag promises the first n. */
  const count = (n) => Number.isInteger(n) && n >= 0;
  if (!opts.file || !count(opts.indent) || (opts.limit !== undefined && !count(opts.limit))) {
    console.error('usage: node scripts/json-to-abap.mjs <file.json> [--path p] [--fields spec] [--var name] [--limit n] [--indent n]');
    console.error('       --limit and --indent take a non-negative whole number');
    process.exit(2);
  }
  const data = JSON.parse(fs.readFileSync(opts.file, 'utf8'));
  let rows = drill(data, opts.path);
  if (!Array.isArray(rows)) {
    console.error(`error: ${opts.path ? `--path ${opts.path}` : 'the JSON root'} is not an array`);
    process.exit(1);
  }
  // `!== undefined`, not truthiness: --limit 0 means zero rows, and reading it
  // as "no limit given" would hand back the whole file instead
  if (opts.limit !== undefined) rows = rows.slice(0, opts.limit);
  const fields = parseFieldsSpec(opts.fields, rows);
  process.stdout.write(rowsToAbapValue(rows, fields, { indent: opts.indent, var: opts.var }) + '\n');
}

if (process.argv[1] === fileURLToPath(import.meta.url)) main();
