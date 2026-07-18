#!/usr/bin/env node
/*
 * render-smoke — headless rendering gate for every port, no ABAP system needed.
 *
 * abaplint proves syntax, the structural diff proves view structure — neither
 * proves the view actually RENDERS. This script closes that gap for the view
 * layer: it reconstructs each port's XML view(s) from the z2ui5_cl_ai_xml
 * builder calls, derives a typed mock JSON model from the port's TYPES/DATA
 * declarations and model_init seeds, and loads the result with a real
 * XMLView.create in headless Chromium against the OpenUI5 runtime served
 * locally from the @openui5/* npm packages (no network needed at run time).
 *
 * What it catches: invalid XML, unknown controls/aggregations/properties,
 * strict property-type violations (a string model value on a numeric
 * property — the app-472/486 bug class), broken expression-binding syntax,
 * renderer crashes. What it cannot catch: event round-trips, visual/UX
 * fidelity — those stay with the human live check.
 *
 * Substitutions while reconstructing (the harness controls both sides, so
 * exact framework path names do not matter):
 *   client->_bind_edit( var )                        -> {/VAR}
 *   client->_bind_edit( val = var path = abap_true ) -> /VAR   (bare path)
 *   client->_event*( ... )                           -> attribute dropped
 *   z2ui5_cl_ai_xml=>as_bool( ... )                  -> true
 *   |...{ expr }...| templates, `lit` && var chains  -> resolved statically
 * The device> model is provided (JSONModel over sap.ui.Device), like the
 * framework does on every view slot.
 *
 * Run:  node scripts/render-smoke.mjs             advisory report
 *       node scripts/render-smoke.mjs --strict    exit 1 on any failing port
 *       node scripts/render-smoke.mjs --only 421  single port (debugging)
 */

import fs from 'fs';
import http from 'http';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const META = path.join(ROOT, 'meta');
const STRICT = process.argv.includes('--strict');
const ONLY = process.argv.includes('--only')
  ? process.argv[process.argv.indexOf('--only') + 1]
  : null;

// UI5 log messages that are environment noise, not port defects
const BENIGN = [
  /library-preload/i,                 // preload bundles don't exist in the source packages
  /messagebundle/i,                   // missing i18n bundles
  /themes?\/|library(\.css|-parameters)/i, // theme CSS is not compiled in source packages
  /theming\.Parameters/i,             // parameters need the compiled theme too
  /failed to load JavaScript resource/i,   // follow-up of the two above
  /Core\.applyTheme|sap\.ui\.getCore/i,
];

// ---------------------------------------------------------------------------
// 1. ABAP scrubbing — remove comments so tokens in comments are never parsed
// ---------------------------------------------------------------------------
function scrub(abap) {
  return abap.split('\n').map((line) => {
    if (/^\*/.test(line)) return '';
    let out = '';
    let str = null; // '`' | '|' when inside a literal/template
    for (let i = 0; i < line.length; i++) {
      const c = line[i];
      if (str === '`') {
        out += c;
        if (c === '`') str = null; // doubled backticks re-enter immediately — harmless
        continue;
      }
      if (str === '|') {
        out += c;
        if (c === '\\') { out += line[++i] ?? ''; continue; }
        if (c === '|') str = null;
        continue;
      }
      if (c === '`' || c === '|') { str = c; out += c; continue; }
      if (c === '"') break; // comment till end of line
      out += c;
    }
    return out;
  }).join('\n');
}

// balanced-paren region starting at content[open] === '(' — string-aware
function parenRegion(content, open) {
  let depth = 0;
  let str = null;
  for (let i = open; i < content.length; i++) {
    const c = content[i];
    if (str === '`') { if (c === '`') str = null; continue; }
    if (str === '|') {
      if (c === '\\') { i++; continue; }
      if (c === '|') str = null;
      continue;
    }
    if (c === '`' || c === '|') { str = c; continue; }
    if (c === '(') depth++;
    else if (c === ')' && --depth === 0) return { body: content.slice(open + 1, i), end: i };
  }
  return { body: content.slice(open + 1), end: content.length };
}

// split a region on a top-level separator (paren- and string-aware)
function topSplit(region, sep) {
  const parts = [];
  let depth = 0;
  let str = null;
  let start = 0;
  for (let i = 0; i < region.length; i++) {
    const c = region[i];
    if (str === '`') { if (c === '`') str = null; continue; }
    if (str === '|') {
      if (c === '\\') { i++; continue; }
      if (c === '|') str = null;
      continue;
    }
    if (c === '`' || c === '|') { str = c; continue; }
    if (c === '(') depth++;
    else if (c === ')') depth--;
    else if (depth === 0 && region.startsWith(sep, i)) {
      parts.push(region.slice(start, i));
      start = i + sep.length;
      i += sep.length - 1;
    }
  }
  parts.push(region.slice(start));
  return parts;
}

// ---------------------------------------------------------------------------
// 2. Value expressions -> static strings
// ---------------------------------------------------------------------------
const SKIP = Symbol('skip');
const up = (s) => s.toUpperCase();

function makeResolver(content, boundVars, notes) {
  // literal scalar assignments anywhere in the class, incl. multi-line
  // concatenations of pure literals: var = `a` && `b` && ... .
  const literals = new Map();
  for (const m of content.matchAll(/(?:^|\s)(?:DATA\()?(\w+)\)?\s*=\s*(`(?:[^`]|``)*`(?:\s*&&\s*`(?:[^`]|``)*`)*)\s*\.(?=\s|$)/g)) {
    const joined = [...m[2].matchAll(/`((?:[^`]|``)*)`/g)]
      .map((p) => p[1].replace(/``/g, '`')).join('');
    literals.set(m[1], joined);
  }

  const resolvePiece = (piece) => {
    const p = piece.trim();
    let m;
    if ((m = p.match(/^`((?:[^`]|``)*)`$/s))) return m[1].replace(/``/g, '`');
    if (/^cl_abap_char_utilities=>newline$/.test(p)) return '\n';
    if (/^cl_abap_char_utilities=>horizontal_tab$/.test(p)) return '\t';
    if ((m = p.match(/^cl_abap_char_utilities=>cr_lf\(1\)$/))) return '\r';
    if ((m = p.match(/^(\w+)$/))) {
      if (literals.has(m[1])) return literals.get(m[1]);
      return null;
    }
    return null;
  };

  const resolveSub = (sub) => {
    const s = sub.trim();
    let m;
    if ((m = s.match(/^client->_bind_edit\(\s*val\s*=\s*(\w+)\s+path\s*=\s*abap_true\s*\)$/))) {
      boundVars.add(m[1]);
      return `/${up(m[1])}`;
    }
    if ((m = s.match(/^client->_bind_edit\(\s*(\w+)\s*\)$/))) {
      boundVars.add(m[1]);
      return `{/${up(m[1])}}`;
    }
    if (/^-?\d+(\.\d+)?$/.test(s)) return s;
    const lit = resolvePiece(s);
    if (lit !== null) return lit;
    notes.push(`unresolved template expression: { ${s.slice(0, 60)} }`);
    return '';
  };

  const resolveTemplate = (tpl) => {
    // tpl includes the surrounding pipes
    let out = '';
    for (let i = 1; i < tpl.length - 1; i++) {
      const c = tpl[i];
      if (c === '\\') { out += tpl[++i] ?? ''; continue; }
      if (c === '{') {
        let depth = 1;
        let j = i + 1;
        for (; j < tpl.length && depth; j++) {
          if (tpl[j] === '{') depth++;
          else if (tpl[j] === '}') depth--;
        }
        out += resolveSub(tpl.slice(i + 1, j - 1));
        i = j - 1;
        continue;
      }
      out += c;
    }
    return out;
  };

  return function resolveExpr(expr) {
    const e = expr.trim().replace(/\)\s*\.?\s*$/, (t) => t); // keep as-is; trailing parens belong to the region
    if (/client->_event\b|client->_event_client\b/.test(e)) return SKIP;
    if (/^\|/.test(e)) return resolveTemplate(e);
    let m;
    if ((m = e.match(/^client->_bind_edit\(\s*(\w+)\s*\)$/))) {
      boundVars.add(m[1]);
      return `{/${up(m[1])}}`;
    }
    if ((m = e.match(/^client->_bind_edit\(\s*val\s*=\s*(\w+)\s+path\s*=\s*abap_true\s*\)$/))) {
      boundVars.add(m[1]);
      return `/${up(m[1])}`;
    }
    if (/^z2ui5_cl_ai_xml=>as_bool\(/.test(e)) return 'true';
    // concatenation chain of literals / literal-assigned vars / char utilities
    const pieces = topSplit(e, '&&').map(resolvePiece);
    if (pieces.length && pieces.every((p) => p !== null)) return pieces.join('');
    notes.push(`unresolved value expression dropped: ${e.slice(0, 70)}`);
    return SKIP;
  };
}

// ---------------------------------------------------------------------------
// 3. Builder calls -> XML documents
// ---------------------------------------------------------------------------
function extractDocs(content, resolveExpr, notes) {
  const docs = [];
  let helperTokens = 0; // builder calls outside any factory chain: view parts
  let stack = null;     // built in helper methods, not statically attributable
  const tokenRe = /z2ui5_cl_ai_xml=>factory\(\s*\)|->\s*(open|leaf|a|shut|stringify)\s*\(/g;
  let m;
  while ((m = tokenRe.exec(content)) !== null) {
    if (m[0].startsWith('z2ui5_cl_ai_xml=>factory')) {
      stack = [{ name: null, ns: null, attrs: [], children: [] }];
      continue;
    }
    if (!stack) { helperTokens++; continue; }
    const verb = m[1];
    if (verb === 'shut') {
      if (stack.length > 1) stack.pop();
      continue;
    }
    if (verb === 'stringify') {
      docs.push(stack[0]);
      stack = null;
      continue;
    }
    const open = content.indexOf('(', m.index + m[0].length - 1);
    const { body, end } = parenRegion(content, open);
    tokenRe.lastIndex = verb === 'a' ? end : tokenRe.lastIndex;
    if (verb === 'a') {
      const nm = body.match(/(?:^|\s)n\s*=\s*`([^`]*)`/);
      const vm = body.match(/(?:^|\s)v\s*=\s*([\s\S]+)$/);
      if (!nm || !vm) { notes.push(`unparsed a( ) call: ${body.slice(0, 60)}`); continue; }
      const val = resolveExpr(vm[1]);
      if (val === SKIP) continue;
      const cur = stack[stack.length - 1];
      const target = cur.children.length ? cur.children[cur.children.length - 1] : cur;
      target.attrs.push([nm[1], val]);
      continue;
    }
    // open / leaf
    const nm = body.match(/(?:^|\s)n\s*=\s*`([^`]*)`/) || body.match(/^\s*`([^`]*)`/);
    if (!nm) { notes.push(`unparsed ${verb}( ) call: ${body.slice(0, 60)}`); continue; }
    const nsm = body.match(/(?:^|\s)ns\s*=\s*`([^`]*)`/);
    const node = { name: nm[1], ns: nsm ? nsm[1] : null, attrs: [], children: [] };
    // up-front attribute table: a = VALUE #( ( `k=v` ) ... )
    const am = body.match(/(?:^|\s)a\s*=\s*VALUE #\s*\(/);
    if (am) {
      const region = parenRegion(body, body.indexOf('(', am.index + am[0].length - 1)).body;
      for (const kv of region.matchAll(/`((?:[^`]|``)*)`/g)) {
        const s = kv[1].replace(/``/g, '`');
        const eq = s.indexOf('=');
        if (eq > 0) node.attrs.push([s.slice(0, eq).trim(), s.slice(eq + 1)]);
      }
    }
    const cur = stack[stack.length - 1];
    cur.children.push(node);
    if (verb === 'open') stack.push(node);
  }
  return { docs, helperTokens };
}

const XML_ESC = (v) => String(v)
  .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')
  .replace(/\n/g, '&#xA;').replace(/\r/g, '&#xD;').replace(/\t/g, '&#x9;');

function toXml(node) {
  if (node.name === null) return node.children.map(toXml).join('');
  const q = node.ns ? `${node.ns}:${node.name}` : node.name;
  const attrs = node.attrs.map(([n, v]) => ` ${n}="${XML_ESC(v)}"`).join('');
  return node.children.length
    ? `<${q}${attrs}>${node.children.map(toXml).join('')}</${q}>`
    : `<${q}${attrs}/>`;
}

// ---------------------------------------------------------------------------
// 4. Mock model from TYPES / DATA / model_init seeds
// ---------------------------------------------------------------------------
const NUMERIC = /^(i|int1|int2|int8|f|p|decfloat16|decfloat34)\b/;

function parseTypes(content) {
  const structs = new Map(); // ty_s_x -> [{name, type}]
  for (const m of content.matchAll(/BEGIN OF (\w+)\s*,([\s\S]*?)END OF \1/g)) {
    const fields = [];
    for (const f of m[2].matchAll(/(\w+)\s+TYPE\s+([\w ]+?)\s*(?:LENGTH\s+\d+)?\s*(?:DECIMALS\s+\d+)?\s*[,.]/g)) {
      fields.push({ name: f[1], type: f[2].trim() });
    }
    structs.set(m[1], fields);
  }
  const tables = new Map(); // ty_t_x -> row type name
  for (const m of content.matchAll(/TYPES\s+(\w+)\s+TYPE\s+STANDARD TABLE OF (\w+)/g)) {
    tables.set(m[1], m[2]);
  }
  return { structs, tables };
}

function parseData(content) {
  const vars = new Map(); // var -> { kind: 'scalar'|'table'|'struct', type }
  for (const m of content.matchAll(/^\s*DATA\s+(\w+)\s+TYPE\s+(?:(STANDARD TABLE OF\s+(\w+))|REF TO\s+\w+|([\w ]+?))\s*(?:LENGTH\s+\d+)?\s*(?:DECIMALS\s+\d+)?\s*(?:WITH EMPTY KEY\s*)?\.\s*$/gm)) {
    if (m[3]) vars.set(m[1], { kind: 'table', type: m[3] });
    else if (m[4]) vars.set(m[1], { kind: 'scalar', type: m[4].trim() });
  }
  return vars;
}

const scalarDefault = (type) =>
  type === 'abap_bool' ? false : NUMERIC.test(type) ? 0 : '';

// parse one VALUE #( ... ) region into JS rows, typed by the row's fields
function parseRows(region, rowType, types) {
  const fields = types.structs.get(rowType) || [];
  const fType = (n) => fields.find((f) => f.name.toLowerCase() === n.toLowerCase())?.type || 'string';
  const rows = [];
  let depth = 0;
  let str = null;
  let start = -1;
  for (let i = 0; i < region.length; i++) {
    const c = region[i];
    if (str === '`') { if (c === '`') str = null; continue; }
    if (c === '`') { str = c; continue; }
    if (c === '(') { if (depth === 0) start = i + 1; depth++; }
    else if (c === ')') {
      depth--;
      if (depth === 0 && start >= 0) {
        rows.push(region.slice(start, i));
        start = -1;
      }
    }
  }
  return rows.map((rowSrc) => {
    const row = {};
    const pairRe = /(\w+)\s*=\s*(`(?:[^`]|``)*`|VALUE #\s*\(|abap_true|abap_false|-?\d+(?:\.\d+)?|\w+)/g;
    let p;
    while ((p = pairRe.exec(rowSrc)) !== null) {
      const [_, name, raw] = p;
      const t = fType(name);
      if (raw.startsWith('VALUE #')) {
        const open = rowSrc.indexOf('(', p.index + p[0].length - 1);
        const sub = parenRegion(rowSrc, open);
        const subRow = types.tables.get(t) || t;
        row[up(name)] = parseRows(sub.body, subRow, types);
        pairRe.lastIndex = sub.end + 1;
      } else if (raw.startsWith('`')) {
        const text = raw.slice(1, -1).replace(/``/g, '`');
        row[up(name)] = NUMERIC.test(t) ? Number(text) || 0 : text;
      } else if (raw === 'abap_true') row[up(name)] = true;
      else if (raw === 'abap_false') row[up(name)] = false;
      else if (/^-?\d/.test(raw)) row[up(name)] = NUMERIC.test(t) ? Number(raw) : raw;
      // bare identifiers (derived values) keep the field default:
      else row[up(name)] = scalarDefault(t);
    }
    return row;
  });
}

function buildModel(content, boundVars, types, vars, notes) {
  const model = {};
  // seeds: scalar literal assignments + table VALUE #( ... ) fills
  const scalarSeed = new Map();
  for (const m of content.matchAll(/^\s*(\w+)\s*=\s*(`(?:[^`]|``)*`|abap_true|abap_false|-?\d+(?:\.\d+)?)\s*\.\s*$/gm)) {
    scalarSeed.set(m[1], m[2]);
  }
  const tableSeed = new Map();
  for (const m of content.matchAll(/^\s*(\w+)\s*=\s*VALUE #\s*\(/gm)) {
    const open = content.indexOf('(', m.index + m[0].length - 1);
    tableSeed.set(m[1], parenRegion(content, open).body);
  }
  // derived seeds like `selected = t_items[ 1 ]-text.` — resolve from the
  // already-parsed table rows (values derived from data, AGENTS §8)
  const derivedSeed = [...content.matchAll(/^\s*(\w+)\s*=\s*(\w+)\[\s*(\d+)\s*\]-(\w+)\s*\.\s*$/gm)]
    .map((m) => ({ target: m[1], table: m[2], index: +m[3], field: m[4] }));
  for (const v of boundVars) {
    const decl = vars.get(v);
    if (!decl) { notes.push(`bound variable ${v} has no DATA declaration — mocked as string`); model[up(v)] = ''; continue; }
    if (decl.kind === 'table') {
      const rowType = decl.type.startsWith('ty_') && types.structs.has(decl.type)
        ? decl.type : (types.tables.get(decl.type) || decl.type);
      model[up(v)] = tableSeed.has(v)
        ? parseRows(tableSeed.get(v), rowType, types)
        : [Object.fromEntries((types.structs.get(rowType) || []).map((f) => [up(f.name), scalarDefault(f.type)]))];
    } else {
      const t = decl.type;
      if (scalarSeed.has(v)) {
        const raw = scalarSeed.get(v);
        model[up(v)] = raw === 'abap_true' ? true
          : raw === 'abap_false' ? false
            : raw.startsWith('`') ? (NUMERIC.test(t) ? Number(raw.slice(1, -1)) || 0 : raw.slice(1, -1).replace(/``/g, '`'))
              : NUMERIC.test(t) ? Number(raw) : raw;
      } else {
        const d = derivedSeed.find((s) => s.target === v);
        const rows = d && tableSeed.has(d.table)
          ? parseRows(tableSeed.get(d.table),
            (vars.get(d.table)?.kind === 'table' && (types.structs.has(vars.get(d.table).type)
              ? vars.get(d.table).type : types.tables.get(vars.get(d.table).type))) || '', types)
          : null;
        model[up(v)] = rows?.[d.index - 1]?.[up(d.field)] ?? scalarDefault(t);
      }
    }
  }
  return model;
}

// ---------------------------------------------------------------------------
// 5. Port -> { class, docs: [xml], model }
// ---------------------------------------------------------------------------
function preparePort(meta) {
  const abap = fs.readFileSync(path.join(ROOT, meta.file), 'utf8');
  const content = scrub(abap);
  const notes = [];
  const boundVars = new Set();
  const resolveExpr = makeResolver(content, boundVars, notes);
  const { docs: nodes, helperTokens } = extractDocs(content, resolveExpr, notes);
  const types = parseTypes(content);
  const vars = parseData(content);
  const docs = nodes.map(toXml).filter(Boolean);
  const model = buildModel(content, boundVars, types, vars, notes);
  return { cls: meta.class, docs, model, notes, helperTokens };
}

// ---------------------------------------------------------------------------
// 6. Local OpenUI5 server (from the @openui5/* npm source packages)
// ---------------------------------------------------------------------------
const LIB_ROOTS = ['sap.ui.core', 'sap.m', 'sap.ui.layout', 'sap.ui.unified', 'themelib_sap_horizon']
  .map((p) => path.join(ROOT, 'node_modules', '@openui5', p, 'src'))
  .filter((p) => fs.existsSync(p));

const MIME = {
  '.js': 'text/javascript', '.css': 'text/css', '.json': 'application/json',
  '.xml': 'application/xml', '.properties': 'text/plain', '.html': 'text/html',
  '.png': 'image/png', '.gif': 'image/gif', '.svg': 'image/svg+xml', '.ttf': 'font/ttf',
};

const HARNESS = `<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>render-smoke</title>
<script>
  window.uiErrors = [];
  window.addEventListener('error', function (e) { window.uiErrors.push('PAGEERROR: ' + e.message); });
</script>
<script id="sap-ui-bootstrap" src="/resources/sap-ui-core.js"
  data-sap-ui-libs="sap.m,sap.ui.layout"
  data-sap-ui-theme="sap_hcb"
  data-sap-ui-async="true"
  data-sap-ui-compatversion="edge"></script>
<script>
  window.uiReady = new Promise(function (resolve) {
    function boot() {
      sap.ui.require(['sap/ui/core/Core', 'sap/base/Log'], function (Core, Log) {
        Log.addLogListener({ onLogEntry: function (e) {
          if (e.level <= Log.Level.ERROR) window.uiErrors.push('LOG: ' + e.message);
        } });
        Core.ready(resolve);
      });
    }
    if (window.sap && sap.ui) boot(); else window.addEventListener('load', boot);
  });
  window.renderDoc = async function (input) {
    await window.uiReady;
    var from = window.uiErrors.length;
    var errs = [];
    try {
      var mods = await new Promise(function (res, rej) {
        sap.ui.require(['sap/ui/core/mvc/XMLView', 'sap/ui/core/Fragment',
          'sap/ui/model/json/JSONModel', 'sap/ui/Device'], function () { res(arguments); }, rej);
      });
      var XMLView = mods[0], Fragment = mods[1], JSONModel = mods[2], Device = mods[3];
      var model = new JSONModel(input.model);
      var device = new JSONModel(Device); device.setDefaultBindingMode('OneWay');
      if (input.kind === 'fragment') {
        var res = await Fragment.load({ definition: input.xml });
        (Array.isArray(res) ? res : [res]).forEach(function (c) {
          if (c.setModel) { c.setModel(model); c.setModel(device, 'device'); }
          c.destroy();
        });
      } else {
        var view = await XMLView.create({ definition: input.xml });
        view.setModel(model); view.setModel(device, 'device');
        view.placeAt('content');
        await new Promise(function (r) { setTimeout(r, 120); });
        view.destroy();
      }
    } catch (e) {
      errs.push('CREATE: ' + (e && e.message ? e.message : String(e)));
    }
    return errs.concat(window.uiErrors.slice(from));
  };
</script>
</head><body><div id="content"></div></body></html>`;

function startServer() {
  const server = http.createServer((req, res) => {
    const u = new URL(req.url, 'http://x');
    if (u.pathname === '/harness.html') {
      res.writeHead(200, { 'content-type': 'text/html' });
      res.end(HARNESS);
      return;
    }
    if (u.pathname.startsWith('/resources/')) {
      const rel = u.pathname.slice('/resources/'.length);
      for (const root of LIB_ROOTS) {
        const full = path.join(root, rel);
        if (full.startsWith(root) && fs.existsSync(full) && fs.statSync(full).isFile()) {
          res.writeHead(200, { 'content-type': MIME[path.extname(full)] || 'application/octet-stream' });
          res.end(fs.readFileSync(full));
          return;
        }
      }
    }
    res.writeHead(404);
    res.end();
  });
  return new Promise((resolve) => server.listen(0, '127.0.0.1', () => resolve(server)));
}

// ---------------------------------------------------------------------------
// 7. Run
// ---------------------------------------------------------------------------
async function launchBrowser() {
  const { chromium } = await import('playwright');
  try {
    return await chromium.launch();
  } catch (e) {
    for (const exe of [process.env.CHROMIUM_BIN, '/opt/pw-browsers/chromium']) {
      if (exe && fs.existsSync(exe)) return chromium.launch({ executablePath: exe });
    }
    throw e;
  }
}

const metas = fs.readdirSync(META).filter((f) => f.endsWith('.json')).sort()
  .map((f) => JSON.parse(fs.readFileSync(path.join(META, f), 'utf8')))
  .filter((m) => !ONLY || m.class.endsWith(`_${ONLY}`));

const server = await startServer();
const base = `http://127.0.0.1:${server.address().port}`;
const browser = await launchBrowser();
const page = await browser.newPage();
await page.goto(`${base}/harness.html`);

let failed = 0;
let skipped = 0;
for (const meta of metas) {
  const { cls, docs, model, notes, helperTokens } = preparePort(meta);
  if (helperTokens > 0) {
    // view parts built in helper methods are not statically attributable —
    // report loudly instead of rendering a wrong reconstruction
    skipped++;
    console.log(`SKIP  ${cls}  (${helperTokens} builder call(s) in helper methods — not statically reconstructable)`);
    continue;
  }
  const errs = [];
  if (!docs.length) errs.push('no view reconstructed from builder calls');
  for (const xml of docs) {
    const kind = /^<core:FragmentDefinition/.test(xml) ? 'fragment' : 'view';
    let raw;
    try {
      raw = await page.evaluate((input) => window.renderDoc(input), { xml, model, kind });
    } catch (e) {
      raw = [`HARNESS: ${e.message}`];
    }
    errs.push(...raw.filter((e) => !BENIGN.some((re) => re.test(e))));
  }
  const status = errs.length ? 'FAIL' : 'pass';
  if (errs.length) failed++;
  console.log(`${status}  ${cls}  (${docs.length} doc(s))`);
  for (const e of errs) console.log(`      ${e.slice(0, 220)}`);
  if (process.env.SMOKE_VERBOSE) for (const n of notes) console.log(`      note: ${n}`);
}

await browser.close();
server.close();
console.log(`\nrender-smoke: ${metas.length} ports, ${failed} failing, ${skipped} skipped.`);
if (STRICT && failed > 0) process.exit(1);
