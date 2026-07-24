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
 * Reconstructability: most ports use the linear factory-chain idiom (one
 * descend/ascend stack, extractDocs). A port that builds view parts in HELPER
 * methods — capturing a node handle (`DATA(list) = view->…->open( List )`),
 * passing it into a builder-returning helper and chaining the returned handle
 * out (`render_item( list = list … )->leaf( StepInput )`, app 049) — is
 * reconstructed by the handle-aware path (extractDocsWithHelpers): a handle is
 * a stack snapshot, a capture saves it, and each helper call is inlined
 * re-anchored to its argument handle. A port that still cannot be reconstructed
 * (a new idiom the handle path does not cover) must DECLARE the skip in its
 * sidecar (`"render_smoke": { "skip": true, "reason": "…" }`); an UNDECLARED
 * non-reconstructable port is a FAILURE, not a silent skip.
 *
 * A declared skip is also honoured for a RECONSTRUCTABLE port whose view
 * genuinely does not render in this static headless harness — a control whose
 * runtime layout/resource behaviour the reconstruction cannot satisfy
 * (sap.f.AvatarGroup's overflow measurement loops with no real layout box; an
 * sap.ui.integration Card needs an external manifest). Such a skip is VERIFIED
 * against the actual render each run: it is honoured only while the view still
 * errors, and the moment it renders clean the skip is stale and FAILS. So every
 * skip — non-reconstructable or render-hostile — is drift-proof: it fails the
 * instant the reason it was granted for no longer holds.
 *
 * Substitutions while reconstructing (the harness controls both sides, so
 * exact framework path names do not matter):
 *   client->_bind( var )                        -> {/VAR}
 *   client->_bind( val = var path = abap_true ) -> /VAR   (bare path)
 *   client->_event*( ... )                           -> .eB()  (stub handler)
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
  // nested bound aggregation whose template is itself a bound-aggregation
  // template (e.g. sap.tnt NavigationListItem with a sub items binding): UI5
  // logs a template-lifecycle caution about not destroying the shared template.
  // It is a warning, not a load failure — an actual duplicate-ID collision
  // would surface as its own (unfiltered) error, so this only hides the caution.
  /clone operation.*template|templateShareable/i,
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
    if ((m = s.match(/^client->_bind\(\s*val\s*=\s*(\w+)\s+path\s*=\s*abap_true\s*\)$/))) {
      boundVars.add(m[1]);
      return `/${up(m[1])}`;
    }
    if ((m = s.match(/^client->_bind\(\s*(\w+)\s*\)$/))) {
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

  // one chain piece: a template, a _bind form, as_bool, or a plain literal.
  // Returns null when the piece cannot be resolved statically.
  const resolveOne = (piece) => {
    const s = piece.trim();
    let m;
    if (/^\|/.test(s)) return resolveTemplate(s);
    if ((m = s.match(/^client->_bind\(\s*(\w+)\s*\)$/))) {
      boundVars.add(m[1]);
      return `{/${up(m[1])}}`;
    }
    if ((m = s.match(/^client->_bind\(\s*val\s*=\s*(\w+)\s+path\s*=\s*abap_true\s*\)$/))) {
      boundVars.add(m[1]);
      return `/${up(m[1])}`;
    }
    if (/^z2ui5_cl_ai_xml=>as_bool\(/.test(s)) return 'true';
    return resolvePiece(s);
  };

  return function resolveExpr(expr) {
    const e = expr.trim().replace(/\)\s*\.?\s*$/, (t) => t); // keep as-is; trailing parens belong to the region
    // Keep event handlers as a resolvable stub reference (.eB() resolves
    // against the smoke's stub controller) instead of dropping them, so UI5
    // future mode still validates the event NAME against the control - this is
    // what catches an event declared on the wrong control (e.g.
    // activeTitlePress on MessageItem instead of MessagePopover).
    if (/client->_event\b|client->_event_client\b/.test(e)) return '.eB()';
    // split any && chain FIRST (topSplit is template-aware, so a && inside a
    // |...| template - e.g. an expression binding - never splits); a template
    // that continues over && pieces was previously mis-read as ONE template
    // and leaked literal `| &&` into the value (probe app 602, 2026-07-19).
    const pieces = topSplit(e, '&&').map(resolveOne);
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

// ---------------------------------------------------------------------------
// 3b. Handle-aware reconstruction — the helper-method / node-handle idiom
//     (app 049). The builder is really node-handle based: `DATA(list) = view->
//     …->open( List )` captures a handle to the List node; a helper method
//     `render_item( list = list … )` re-descends from that node and RETURNS a
//     handle the caller keeps chaining on (`…->leaf( StepInput )`). A single
//     descend/ascend stack can't model that (the helper body lives in another
//     method, and each call re-anchors to `list`, not to the previous cursor).
//     Here a handle IS a stack snapshot (root..cursor); a capture saves it, a
//     builder-returning helper is inlined at the call site re-anchored to its
//     argument handle. Only ports that declare such a helper take this path;
//     the 90-odd linear ports keep extractDocs untouched.
// ---------------------------------------------------------------------------

// split an ABAP method body into statements, string- and paren-aware (the
// terminator '.' inside `…`/|…| strings or ( ) is not a split point)
function splitStatements(src) {
  const out = [];
  let depth = 0, str = null, start = 0;
  for (let i = 0; i < src.length; i++) {
    const c = src[i];
    if (str === '`') { if (c === '`') str = null; continue; }
    if (str === '|') { if (c === '\\') { i++; continue; } if (c === '|') str = null; continue; }
    if (c === '`' || c === '|') { str = c; continue; }
    else if (c === '(') depth++;
    else if (c === ')') depth--;
    else if (c === '.' && depth === 0) { out.push(src.slice(start, i)); start = i + 1; }
  }
  if (src.slice(start).trim()) out.push(src.slice(start));
  return out;
}

// apply one ->open/leaf/a/shut( ) token to a live stack (mutates the tree).
// Same node/attr semantics as extractDocs, factored for the handle path.
function applyToken(verb, body, stack, resolveExpr, notes) {
  if (verb === 'shut') { if (stack.length > 1) stack.pop(); return; }
  if (verb === 'a') {
    const nm = body.match(/(?:^|\s)n\s*=\s*`([^`]*)`/);
    const vm = body.match(/(?:^|\s)v\s*=\s*([\s\S]+)$/);
    if (!nm || !vm) { notes.push(`unparsed a( ) call: ${body.slice(0, 60)}`); return; }
    const val = resolveExpr(vm[1]);
    if (val === SKIP) return;
    const cur = stack[stack.length - 1];
    const target = cur.children.length ? cur.children[cur.children.length - 1] : cur;
    target.attrs.push([nm[1], val]);
    return;
  }
  const nm = body.match(/(?:^|\s)n\s*=\s*`([^`]*)`/) || body.match(/^\s*`([^`]*)`/);
  if (!nm) { notes.push(`unparsed ${verb}( ) call: ${body.slice(0, 60)}`); return; }
  const nsm = body.match(/(?:^|\s)ns\s*=\s*`([^`]*)`/);
  const node = { name: nm[1], ns: nsm ? nsm[1] : null, attrs: [], children: [] };
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

// process a chain of ->open/leaf/a/shut( ) calls against `stack` (mutates it)
function processChain(chain, stack, resolveExpr, notes) {
  const tokenRe = /->\s*(open|leaf|a|shut|stringify)\s*\(/g;
  let m;
  while ((m = tokenRe.exec(chain)) !== null) {
    const verb = m[1];
    if (verb === 'stringify') continue;
    if (verb === 'shut') { applyToken('shut', '', stack, resolveExpr, notes); continue; }
    const open = chain.indexOf('(', m.index + m[0].length - 1);
    const { body, end } = parenRegion(chain, open);
    if (verb === 'a') tokenRe.lastIndex = end;
    applyToken(verb, body, stack, resolveExpr, notes);
  }
}

// parse `name = value  name2 = value2` into { name: value }, string- and
// paren-aware so a `=` inside a `…` value (e.g. label = `Step = 1 …`) is not a
// boundary
function parseNamedArgs(argBody) {
  const marks = [];
  let depth = 0, str = null, i = 0;
  while (i < argBody.length) {
    const c = argBody[i];
    if (str) {
      if (str === '`' && c === '`') str = null;
      else if (str === '|') { if (c === '\\') { i += 2; continue; } if (c === '|') str = null; }
      i++; continue;
    }
    if (c === '`' || c === '|') { str = c; i++; continue; }
    if (c === '(') { depth++; i++; continue; }
    if (c === ')') { depth--; i++; continue; }
    if (depth === 0 && (i === 0 || /\s/.test(argBody[i - 1]))) {
      const mm = argBody.slice(i).match(/^(\w+)\s*=\s*/);
      if (mm) { marks.push({ name: mm[1], nameStart: i, vstart: i + mm[0].length }); i += mm[0].length; continue; }
    }
    i++;
  }
  const args = {};
  for (let k = 0; k < marks.length; k++) {
    const end = k + 1 < marks.length ? marks[k + 1].nameStart : argBody.length;
    args[marks[k].name] = argBody.slice(marks[k].vstart, end).trim();
  }
  return args;
}

// helper methods that take a handle and RETURN one: { name -> {entryParam,
// bodyChain, params} }, where bodyChain is the ->…-chain of `result = entry->…`
function parseHelpers(content) {
  const helpers = new Map();
  const defRe = /METHODS\s+(\w+)\s+IMPORTING([\s\S]*?)RETURNING\s+VALUE\(\w+\)\s+TYPE REF TO z2ui5_cl_ai_xml\s*\./g;
  let d;
  while ((d = defRe.exec(content)) !== null) {
    const name = d[1];
    const params = [...d[2].matchAll(/(\w+)\s+TYPE\b/g)].map((x) => x[1]);
    const implM = content.match(new RegExp('METHOD\\s+' + name + '\\s*\\.([\\s\\S]*?)\\bENDMETHOD\\b'));
    if (!implM) continue;
    const resStmt = splitStatements(implM[1]).find((s) => /^\s*result\s*=/.test(s));
    if (!resStmt) continue;
    const rm = resStmt.match(/^\s*result\s*=\s*(\w+)\s*(->[\s\S]*)$/);
    if (!rm) continue;
    helpers.set(name, { entryParam: rm[1], bodyChain: rm[2], params });
  }
  return helpers;
}

function extractDocsWithHelpers(content, resolveExpr, notes) {
  const helpers = parseHelpers(content);
  const vdM = content.match(/METHOD\s+\w+\s*\.([\s\S]*?z2ui5_cl_ai_xml=>factory[\s\S]*?)\bENDMETHOD\b/);
  if (!vdM) return { docs: [], helperTokens: 1 };
  const handles = new Map(); // var -> stack (array of node refs, root..cursor)
  const docs = [];
  let helperTokens = 0;
  for (const raw of splitStatements(vdM[1])) {
    const s = raw.trim();
    if (!s) continue;
    let m;
    // DATA(v) = z2ui5_cl_ai_xml=>factory( ) [ ->chain ]
    if ((m = s.match(/^(?:DATA\()?(\w+)\)?\s*=\s*z2ui5_cl_ai_xml=>factory\(\s*\)\s*(->[\s\S]*)?$/))) {
      const stack = [{ name: null, ns: null, attrs: [], children: [] }];
      if (m[2]) processChain(m[2], stack, resolveExpr, notes);
      handles.set(m[1], stack);
      continue;
    }
    // DATA(v) = <handleVar>->chain   (capture a handle mid-chain)
    if ((m = s.match(/^(?:DATA\()?(\w+)\)?\s*=\s*(\w+)\s*(->[\s\S]*)$/)) && handles.has(m[2])) {
      const stack = handles.get(m[2]).slice();
      processChain(m[3], stack, resolveExpr, notes);
      handles.set(m[1], stack);
      continue;
    }
    // client->view_display( <var>->stringify( ) )   -> emit the doc
    if ((m = s.match(/view_display\(\s*(\w+)\s*->\s*stringify/)) && handles.has(m[1])) {
      docs.push(handles.get(m[1])[0]);
      continue;
    }
    // <helper>( args )->chain   (inline the helper, re-anchored to its arg handle)
    if ((m = s.match(/^(\w+)\s*\(/)) && helpers.has(m[1])) {
      const h = helpers.get(m[1]);
      const open = s.indexOf('(', m[1].length);
      const { body: argBody, end } = parenRegion(s, open);
      const args = parseNamedArgs(argBody);
      const entryVar = (args[h.entryParam] || '').trim();
      if (!handles.has(entryVar)) { helperTokens++; continue; }
      const stack = handles.get(entryVar).slice();
      let hchain = h.bodyChain;
      for (const p of h.params) {
        if (p === h.entryParam || args[p] === undefined) continue;
        hchain = hchain.replace(new RegExp('\\b' + p + '\\b', 'g'), () => args[p]);
      }
      processChain(hchain, stack, resolveExpr, notes);
      const cont = s.slice(end + 1);
      if (cont.trim()) processChain(cont, stack, resolveExpr, notes);
      continue;
    }
    // any other statement (local DATA, model calls) is not builder-relevant
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
  const vars = new Map(); // var -> { kind: 'scalar'|'table'|'struct', type, value? }
  // the trailing (?:VALUE …)? captures an inline initial value on the same
  // declaration (DATA n TYPE i VALUE 5. / … TYPE abap_bool VALUE abap_true.),
  // so a VALUE-seeded field mocks with the right type instead of falling back
  // to an empty string. The scalar type is a single token (\w+) so the VALUE
  // clause cannot bleed into it (was `i VALUE 5` under the old `[\w ]+?`).
  for (const m of content.matchAll(/^\s*DATA\s+(\w+)\s+TYPE\s+(?:(STANDARD TABLE OF\s+(\w+))|REF TO\s+\w+|(\w+))\s*(?:LENGTH\s+\d+)?\s*(?:DECIMALS\s+\d+)?\s*(?:WITH EMPTY KEY\s*)?(?:VALUE\s+(`(?:[^`]|``)*`|abap_true|abap_false|-?\d+(?:\.\d+)?))?\s*\.\s*$/gm)) {
    if (m[3]) vars.set(m[1], { kind: 'table', type: m[3] });
    else if (m[4]) vars.set(m[1], { kind: 'scalar', type: m[4].trim(), value: m[5] });
  }
  return vars;
}

const scalarDefault = (type) =>
  type === 'abap_bool' ? false : NUMERIC.test(type) ? 0 : '';

// coerce an ABAP scalar literal (backtick string / abap_true|false / number)
// to its typed JS value — shared by VALUE clauses, model_init assignments and
// row fields so the three paths agree.
const coerceScalar = (raw, type) =>
  raw === 'abap_true' ? true
    : raw === 'abap_false' ? false
      : raw.startsWith('`') ? (NUMERIC.test(type) ? Number(raw.slice(1, -1)) || 0 : raw.slice(1, -1).replace(/``/g, '`'))
        : NUMERIC.test(type) ? Number(raw) : raw;

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
        : types.structs.has(rowType)
          ? [Object.fromEntries(types.structs.get(rowType).map((f) => [up(f.name), scalarDefault(f.type)]))]
          // scalar-row table (TYPE STANDARD TABLE OF string, bound to an
          // array property like Table.sticky): an empty array — a {} row
          // would fail strict property validation (b05 app 009)
          : [];
    } else {
      const t = decl.type;
      if (scalarSeed.has(v)) {
        // explicit assignment in model_init wins over an inline VALUE
        model[up(v)] = coerceScalar(scalarSeed.get(v), t);
      } else if (decl.value != null) {
        // inline DATA … VALUE … seeds the field with its declared literal
        model[up(v)] = coerceScalar(decl.value, t);
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
  // a port that builds view parts in a handle-returning helper method needs the
  // handle-aware reconstruction; the linear ports keep the single-stack path.
  const hasBuilderHelper = /RETURNING\s+VALUE\(\w+\)\s+TYPE REF TO z2ui5_cl_ai_xml/.test(content);
  const { docs: nodes, helperTokens } = hasBuilderHelper
    ? extractDocsWithHelpers(content, resolveExpr, notes)
    : extractDocs(content, resolveExpr, notes);
  const types = parseTypes(content);
  const vars = parseData(content);
  const docs = nodes.map(toXml).filter(Boolean);
  const model = buildModel(content, boundVars, types, vars, notes);
  return { cls: meta.class, docs, model, notes, helperTokens };
}

// ---------------------------------------------------------------------------
// 6. Local OpenUI5 server (from the @openui5/* npm source packages)
// ---------------------------------------------------------------------------
const LIB_ROOTS = ['sap.ui.core', 'sap.m', 'sap.ui.layout', 'sap.ui.unified', 'sap.f', 'sap.ui.table', 'sap.uxap', 'sap.tnt', 'sap.ui.codeeditor', 'sap.ui.integration', 'themelib_sap_horizon']
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
  // Mirror of the framework's curated formatter module (standard app layout
  // model/formatter.js; served as a real script upstream, CSP-clean). The
  // functions are a fixed public contract, so mirroring them faithfully here
  // is legitimate - like the device model the harness also provides. Keep in
  // sync with abap2UI5 app/webapp/model/formatter.js. Registered as the
  // named module z2ui5/model/formatter in boot() below (for core:require)
  // and published as the z2ui5.Formatter global (the pre-1.74 reference).
  window.z2ui5 = window.z2ui5 || {};
  (function () {
    function parseYmd(d) {
      return [Number(d.slice(0, 4)), Number(d.slice(4, 6)) - 1, Number(d.slice(6, 8))];
    }
    var STOCK_STATUS = {
      'Available': { state: 'Success', icon: 'sap-icon://accept' },
      'Out of Stock': { state: 'Warning', icon: 'sap-icon://alert' },
      'Discontinued': { state: 'Error', icon: 'sap-icon://decline' },
    };
    window.z2ui5.Formatter = {
      DateCreateObject: function (s) { return new Date(s); },
      DateAbapDateToDateObject: function (d) {
        var p = parseYmd(d); return new Date(p[0], p[1], p[2]);
      },
      DateAbapDateTimeToDateObject: function (d, t) {
        t = t || '000000';
        var p = parseYmd(d);
        return new Date(p[0], p[1], p[2], Number(t.slice(0, 2)), Number(t.slice(2, 4)), Number(t.slice(4, 6)));
      },
      // weightState/weightStateByValue removed: deriving a state from a raw
      // measure (thresholds + unit conversion) is business logic and now lives
      // in the ABAP backend (thin-frontend principle) — no port binds it.
      stockStatusState: function (status) {
        return (STOCK_STATUS[status] || {}).state || 'None';
      },
      stockStatusIcon: function (status) {
        return (STOCK_STATUS[status] || {}).icon || null;
      },
      round2DP: function (value) {
        var n = parseFloat(value);
        if (isNaN(n)) return '';
        return (Math.round(n * 100) / 100).toFixed(2);
      },
      dimensions: function (width, depth, height, unit) {
        var display = [width, depth, height]
          .filter(function (c) { return c != null && c !== ''; })
          .join(' x ');
        if (display && unit != null && unit !== '') display += ' ' + unit;
        return display;
      },
      deliveryStatusState: function (status) {
        if (status === 'Shipped') return 'Success';
        if (status === 'Failed Shipping') return 'Error';
        return 'None';
      },
      expandInlineIcons: function (text) {
        if (!text) return '';
        var IconPool = sap.ui.require('sap/ui/core/IconPool');
        var re = new RegExp('%%icon:(sap-icon://[^%]+)%%', 'g');
        return String(text).replace(re, function (m, uri) {
          var info = IconPool && IconPool.getIconInfo(uri);
          if (!info) return '';
          return '<span class="sapMMsgStripInlineIcon" style="font-family:' + info.fontFamily + '">' + info.content + '</span>';
        });
      },
    };
  })();
</script>
<script id="sap-ui-bootstrap" src="/resources/sap-ui-core.js"
  data-sap-ui-libs="sap.m,sap.ui.layout,sap.f,sap.ui.table,sap.uxap,sap.tnt"
  data-sap-ui-theme="sap_hcb"
  data-sap-ui-async="true"
  data-sap-ui-compatversion="edge"></script>
<script>
  window.uiReady = new Promise(function (resolve) {
    function boot() {
      // core:require="{Formatter: 'z2ui5/model/formatter'}" must resolve
      // without the framework being served - register the mirror above as
      // the named module before any view is created.
      sap.ui.define('z2ui5/model/formatter', [], function () { return window.z2ui5.Formatter; });
      // Metadata-only mirror of the bundled custom control
      // z2ui5.cc.MultiInputExt (invisible companion installing the
      // free-text->token validator on the MultiInput it references). The
      // harness only validates view creation, so properties/renderer
      // suffice - no behavior. Keep the metadata in sync with abap2UI5
      // app/webapp/cc/MultiInputExt.js.
      sap.ui.define('z2ui5/cc/MultiInputExt', ['sap/ui/core/Control'], function (Control) {
        return Control.extend('z2ui5.cc.MultiInputExt', {
          metadata: {
            properties: {
              MultiInputId: { type: 'string' },
              MultiInputName: { type: 'string' },
              addedTokens: { type: 'object' },
              checkInit: { type: 'boolean', defaultValue: false },
              removedTokens: { type: 'object' },
            },
            events: { change: { allowPreventDefault: true, parameters: {} } },
          },
          renderer: { apiVersion: 2, render: function () {} },
        });
      });
      // Metadata-only mirror of z2ui5.cc.MessageManager (invisible companion
      // that bridges the UI5 message manager to a two-way bound items table).
      // The harness only validates view creation. Keep in sync with abap2UI5
      // app/webapp/cc/MessageManager.js.
      sap.ui.define('z2ui5/cc/MessageManager', ['sap/ui/core/Control'], function (Control) {
        return Control.extend('z2ui5.cc.MessageManager', {
          metadata: {
            properties: {
              items: { type: 'object' },
              checkInit: { type: 'boolean', defaultValue: false },
            },
            events: { change: { allowPreventDefault: true, parameters: {} } },
          },
          renderer: { apiVersion: 2, render: function () {} },
        });
      });
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
          'sap/ui/model/json/JSONModel', 'sap/ui/Device',
          'sap/ui/core/mvc/Controller', 'sap/base/future'], function () { res(arguments); }, rej);
      });
      var XMLView = mods[0], Fragment = mods[1], JSONModel = mods[2], Device = mods[3];
      var Controller = mods[4], future = mods[5];
      // A stub controller carrying the two abap2UI5 event entry points (eB/eF)
      // so declarative event handlers resolve. With that in place we can turn
      // on UI5 'future' mode around view creation, which upgrades otherwise
      // silent "[FUTURE FATAL] unknown setting" warnings (a property/event put
      // on the wrong control - e.g. activeTitlePress on MessageItem) into a
      // thrown error the smoke reports. Without the stub, future mode would
      // also throw on the unresolvable eB/eF handlers themselves.
      window._smokeCtl = window._smokeCtl ||
        Controller.extend('z2ui5.smoke.StubController', { eB: function () {}, eF: function () {} });
      var model = new JSONModel(input.model);
      var device = new JSONModel(Device); device.setDefaultBindingMode('OneWay');
      var prevFuture = future.active;
      future.active = true;
      try {
        if (input.kind === 'fragment') {
          var res = await Fragment.load({ definition: input.xml, controller: new window._smokeCtl() });
          (Array.isArray(res) ? res : [res]).forEach(function (c) {
            if (c.setModel) { c.setModel(model); c.setModel(device, 'device'); }
            c.destroy();
          });
        } else {
          var view = await XMLView.create({ definition: input.xml, controller: new window._smokeCtl() });
          view.setModel(model); view.setModel(device, 'device');
          // empty message model so {message>/} bindings (MessagePopover /
          // z2ui5.cc.MessageManager ports) resolve like the framework's slot
          view.setModel(new JSONModel([]), 'message');
          view.placeAt('content');
          await new Promise(function (r) { setTimeout(r, 120); });
          view.destroy();
        }
      } finally {
        future.active = prevFuture;
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
  const declaredSkip = meta.render_smoke?.skip === true;
  if (helperTokens > 0) {
    // view parts built in helper methods are not statically attributable (the
    // reconstructor models one descend/ascend stack, not held node-handle
    // re-entry across method calls). A skip is legitimate ONLY when the
    // sidecar declares it — otherwise it is a FAILURE, so skips can never
    // grow silently: a new helper-built port fails CI until a human either
    // reconstructs it or consciously declares render_smoke.skip with a reason.
    if (declaredSkip) {
      skipped++;
      console.log(`SKIP  ${cls}  (declared render_smoke.skip: ${helperTokens} builder call(s) in helper methods)`);
    } else {
      failed++;
      console.log(`FAIL  ${cls}  (${helperTokens} builder call(s) in helper methods — not statically reconstructable and no render_smoke.skip declared in meta)`);
    }
    continue;
  }
  // linear port: reconstruct and render, THEN decide the outcome (a declared
  // skip is verified against the actual render, so it can never go stale)
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
  if (declaredSkip) {
    // a declared skip on a reconstructable port is honoured ONLY while the view
    // genuinely fails to render in the static harness — a control whose runtime
    // layout/resource behaviour the headless reconstruction cannot satisfy
    // (e.g. sap.f.AvatarGroup's overflow measurement loops with no real layout
    // box; an integration Card needs an external manifest). The moment it
    // renders clean the skip is stale and FAILS, so a render-hostile skip can
    // never silently outlive the reason it was granted for.
    if (errs.length) {
      skipped++;
      console.log(`SKIP  ${cls}  (declared render_smoke.skip — does not render in the static harness: ${errs[0].slice(0, 100)})`);
    } else {
      failed++;
      console.log(`FAIL  ${cls}  (declares render_smoke.skip but the view now renders clean — remove the stale declaration)`);
    }
    continue;
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
