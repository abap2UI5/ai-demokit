#!/usr/bin/env node
/*
 * pattern-lint — deterministic gate against re-learning old mistakes.
 *
 * Every rule here encodes a lesson that already bit us once (AGENTS.md §10 /
 * CAPABILITIES.md): once a mistake is understood, it becomes a rule so it can
 * never be merged again — regardless of whether the generator repeats it.
 *
 * Levels: 'error' rules fail the run (exit 1) unless the exact file is listed
 * in BASELINE (a known, still-open backlog finding — see STATUS.md); 'warn'
 * rules are reported but never fail. When a baselined finding is fixed, its
 * BASELINE entry must be removed in the same change (stale entries are
 * reported).
 *
 * Run:  node scripts/pattern-lint.mjs
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const SRC = path.join(ROOT, 'src');

// known, still-open findings (tracked in STATUS.md) — 'rule-id|repo-relative-file'
// empty since 2026-07-28: the six dead-event-wire entries of the review sweep
// (138/143/145/146/148/150) were reworked, so the rule now stands on its own
const BASELINE = new Set([]);

// return the content of the parenthesized region starting at content[open] === '('
function parenRegion(content, open) {
  let depth = 0;
  for (let i = open; i < content.length; i++) {
    if (content[i] === '(') depth++;
    else if (content[i] === ')' && --depth === 0) return content.slice(open + 1, i);
  }
  return content.slice(open + 1);
}

const lineOf = (content, idx) => content.slice(0, idx).split('\n').length;

const RULES = [
  {
    id: 'popover-display-val',
    level: 'error',
    doc: 'popover_display imports `xml` (not `val`, unlike popup_display) — guessed-by-analogy `val =` does not compile; hold-out probe apps 607/613/617, 2026-07-19',
    find(content) {
      const out = [];
      for (const m of content.matchAll(/popover_display\(\s*val\s*=/g)) {
        out.push({ line: lineOf(content, m.index), text: m[0] });
      }
      return out;
    },
  },
  {
    id: 'control-by-id-empty-view-slot',
    level: 'error',
    doc: 'control_by_id t_arg carries an obsolete empty view slot as its 2nd element — the view now goes via the `view` parameter (get_event_client inserts it at index 2). Drop the ( `` ): otherwise it shifts the method into the wrong slot and the frontend logs "CONTROL_BY_ID: method \'\' not allowed". Correct form: ( `id` ) ( `method` ) ( params… ).',
    find(content) {
      const out = [];
      const re = /control_by_id/g;
      let m;
      while ((m = re.exec(content))) {
        const vi = content.indexOf('VALUE', re.lastIndex);
        // only look inside the same call: bail if another statement starts first
        if (vi === -1 || vi - re.lastIndex > 200) continue;
        const open = content.indexOf('(', vi);
        if (open === -1) continue;
        const region = parenRegion(content, open);
        const elems = [...region.matchAll(/\(\s*`([^`]*)`\s*\)/g)];
        if (elems.length >= 2 && elems[1][1] === '') {
          out.push({ line: lineOf(content, open), text: '( `' + elems[0][1] + '` ) ( `` ) …' });
        }
      }
      return out;
    },
  },
  {
    id: 'event-arg-bare-brace',
    level: 'error',
    doc: 'event t_arg uses a bare `{COL}` — not resolved by get_event_arg; use the $-prefixed form (${COL}) — AGENTS §5, bit us in app 005',
    find(content) {
      const out = [];
      const re = /t_arg\s*=/g;
      let m;
      while ((m = re.exec(content))) {
        const open = content.indexOf('(', re.lastIndex);
        if (open === -1) continue;
        const region = parenRegion(content, open);
        for (const lit of region.matchAll(/`([^`]*)`/g)) {
          // a bare leading `{COL}` is the bug (unresolved binding); a pure
          // positional placeholder `{0}` / conditional `{0?a:b}` is legitimate —
          // it is the client-composed MessageToast/MessageBox template arg,
          // filled from the following client-resolved values (a field name is
          // never digits).
          if (/^\{/.test(lit[1]) && !/^\{\d+[?}]/.test(lit[1])) {
            out.push({ line: lineOf(content, open + lit.index), text: '`' + lit[1] + '`' });
          }
        }
      }
      return out;
    },
  },
  {
    id: 'private-mproperties',
    level: 'error',
    doc: 'reads private UI5 internals via mProperties — fragile across UI5 patches; restructure to a two-way binding or a public parameter — CAPABILITIES.md "Events"',
    find: grepLines(/mProperties/),
  },
  {
    id: 'obsolete-bind-edit',
    level: 'error',
    doc: 'client->_bind_edit( is obsolete — always use _bind (two-way) — AGENTS §5',
    find: grepLines(/->_bind_edit\(/),
  },
  {
    id: 'hardcoded-binding-path',
    level: 'error',
    portsOnly: true,
    doc: "an absolute binding path is hard-coded as text (`{/PATH}` or `path: '/PATH'`) — derive it from client->_bind( var ) (raw path: _bind( val = var path = abap_true )) so it moves with a variable rename; relative field bindings (`{FIELD}`) are the allowed exception (AGENTS §5 'Data binding & events'). An OData ENTITY path with a key predicate (`{/Products('4711')}`) in a port that switches its default model to an OData service is exempt: that path addresses the service, not an ABAP variable, so there is nothing to derive it from",
    find(content) {
      const out = [];
      // a port whose default model IS an OData service (switch_default_model_path)
      // binds elements by entity path — `{/EntitySet('key')}`. No ABAP member backs
      // such a path, and a model path can never carry a key predicate, so the
      // exemption stays tight to that one shape.
      const odata = /switch_default_model_path/.test(content);
      content.split('\n').forEach((l, i) => {
        const t = l.trimStart();
        if (t.startsWith('"') || t.startsWith('*')) return; // ABAP comment line
        if (odata && /\{\/\w+\([^)]*\)\}/.test(l)) return;  // OData entity path
        if (/\{\//.test(l) || /\bpath\s*:\s*'\//.test(l)) {
          out.push({ line: i + 1, text: l.trim().slice(0, 90) });
        }
      });
      return out;
    },
  },
  {
    id: 'event-arg-default-index',
    level: 'error',
    doc: 'get_event_arg( 1 ) spells out the default — simplest notation is get_event_arg( ); only pass an index for position 2+ (AGENTS §8)',
    find: grepLines(/get_event_arg\(\s*1\s*\)/),
  },
  {
    id: 'main-not-first',
    level: 'error',
    doc: 'z2ui5_if_app~main must be the FIRST method in the implementation; the rest follow in call order from main (AGENTS §5)',
    portsOnly: true,
    find(content) {
      const impl = content.split(/^CLASS \w+ IMPLEMENTATION\.$/m)[1] || '';
      const first = impl.match(/^  METHOD (\S+)\./m);
      if (first && first[1] !== 'z2ui5_if_app~main') {
        return [{ line: lineOf(content, content.indexOf(first[0])), text: `first method is ${first[1]}` }];
      }
      return [];
    },
  },
  {
    id: 'model-init-last',
    level: 'error',
    doc: 'model_init holds the mock-data VALUE #( ) block and must be the LAST method in the implementation so it never interrupts the reading flow of the dispatcher/view/event methods above it (AGENTS §5)',
    portsOnly: true,
    find(content) {
      const impl = content.split(/^CLASS \w+ IMPLEMENTATION\.$/m)[1] || '';
      const names = [...impl.matchAll(/^  METHOD (\S+)\./gm)].map((x) => x[1]);
      const mi = names.indexOf('model_init');
      if (mi !== -1 && mi !== names.length - 1) {
        return [{ line: lineOf(content, content.indexOf('  METHOD model_init.')),
                  text: `model_init is followed by ${names.slice(mi + 1).join(', ')}` }];
      }
      return [];
    },
  },
  {
    id: 'commercial-ui5-host',
    level: 'error',
    doc: 'URL points at the commercial SAPUI5 host — always use sdk.openui5.org — AGENTS §5',
    find: grepLines(/ui5\.sap\.com|hana\.ondemand\.com/),
  },
  {
    id: 'abapdoc-html-tag',
    level: 'error',
    doc: 'raw <tag> inside ABAP Doc ("!) — ABAP Doc is parsed as HTML; write it plain — AGENTS §8/§10',
    find: grepLines(/^"!.*<[a-zA-Z][^ >]*>/),
  },
  {
    id: 'header-in-port',
    level: 'error',
    doc: 'port classes carry no ABAP Doc header — sample/entity/status/checked/deviations live in meta/<class>.json (AGENTS §5)',
    portsOnly: true,
    find: grepLines(/^"!/),
  },
  {
    id: 'client-handle-capture',
    level: 'error',
    doc: 'client handle strings (_event, _bind, _event_client, ...) are written inline at each control, never captured in a variable - even when repeated, even in expression bindings (human decision 2026-07-17, apps 005/053/007)',
    find: grepLines(/DATA\(\w+\)\s*=\s*client->_\w+\(/),
  },
  {
    id: 'default-key-table',
    level: 'error',
    doc: 'bare `TYPE TABLE OF` gives an implicit default key — declare it explicitly as `TYPE STANDARD TABLE OF ... WITH EMPTY KEY` (AGENTS §8; slipped the abaplint defaultKey gate, which only catches explicit DEFAULT KEY, in app 034)',
    find: grepLines(/\bTYPE\s+TABLE\s+OF\b/),
  },
  {
    id: 'numeric-bound-as-string',
    level: 'error',
    doc: 'a model field that is bound to a control and only ever assigned numeric literals is TYPE string — UI5 2.x strict-type validation rejects a string on a numeric property (Slider/RangeSlider/StepInput value); type it numerically (TYPE i / p / decfloat) — AGENTS §10, apps 053/045',
    find(content) {
      const out = [];
      const decl = /^\s*DATA\s+(\w+)\s+TYPE\s+string\s*\.\s*$/gm;
      let m;
      while ((m = decl.exec(content))) {
        const name = m[1];
        if (!new RegExp(`_bind(?:_edit)?\\(\\s*${name}\\s*\\)`).test(content)) continue;
        const asn = new RegExp(`\\b${name}\\s*=\\s*\`([^\`]*)\``, 'g');
        let a, any = false, allNumeric = true;
        while ((a = asn.exec(content))) {
          any = true;
          if (!/^-?\d+(\.\d+)?$/.test(a[1].trim())) { allNumeric = false; break; }
        }
        // string evidence beyond ABAP assignments: a non-numeric comparison in a
        // UI5 { = } expression over the field (e.g. a selectedKey field compared
        // `${ _bind( key ) } === 'px'`) proves it is genuinely a string, not a
        // numeric property bound to a string. Without this the rule false-positives
        // on a Select selectedKey whose only ABAP seed happens to be numeric.
        const cmp = new RegExp(`_bind(?:_edit)?\\(\\s*${name}\\s*\\)[^|]*?===\\s*'([^']*)'`);
        const cm = cmp.exec(content);
        if (cm && !/^-?\d+(\.\d+)?$/.test(cm[1].trim())) allNumeric = false;
        // …and the decisive one: the bind must actually reach a NUMERIC
        // control property. `value` is a float on a Slider and a string on an
        // Input, so the attribute name alone says nothing — the enclosing
        // control decides (2026-08-01: apps 142/175 bind a ZIP code and a
        // house number, both genuinely strings, to `Input value`; apps
        // 206/209 format decimals into a text template). Only a hit in
        // NUMERIC_PROPS is a defect.
        if (!boundToNumericProp(content, name)) allNumeric = false;
        if (any && allNumeric) {
          out.push({ line: lineOf(content, m.index), text: `${name} TYPE string, bound, only numeric literals assigned` });
        }
      }
      return out;
    },
  },
  {
    id: 'relative-bind-on-root-field',
    level: 'error',
    doc: 'a `{FIELD}` binding whose FIELD is a root-level DATA scalar of the class (and no row column) is RELATIVE and resolves against nothing / against the row — it renders empty in the running app. Bind the root field absolutely with client->_bind( field ) — AGENTS §5, apps 207 and 142/175/195/206/209/229/243 (2026-08-01)',
    find(content) {
      const out = [];
      const scalars = new Map();
      for (const m of content.matchAll(/^ {4}DATA\s+(\w+)\s+TYPE\s+(?![^.\n]*\bTABLE\b)[^.\n]+\.$/gm)) {
        scalars.set(m[1].toUpperCase(), m[1]);
      }
      if (!scalars.size) return out;
      // names that are columns of a row structure declared in the class — a
      // relative binding on those is the correct form inside a template
      const rowFields = new Set();
      for (const blk of content.matchAll(/BEGIN OF[\s\S]*?END OF/g)) {
        for (const c of blk[0].matchAll(/^\s+(\w+)\s+TYPE\b/gm)) rowFields.add(c[1].toUpperCase());
      }
      content.split('\n').forEach((l, i) => {
        if (/^\s*"/.test(l)) return;
        for (const lit of l.matchAll(/`([^`]*)`/g)) {
          for (const b of lit[1].matchAll(/\{([A-Z][A-Z0-9_]*)\}/g)) {
            const up = b[1];
            if (!scalars.has(up) || rowFields.has(up)) continue;
            out.push({ line: i + 1, text: `{${up}} is relative, but ${scalars.get(up)} is a root field — use client->_bind( ${scalars.get(up)} )` });
          }
        }
      });
      return out;
    },
  },
  {
    id: 'unescaped-brace-in-style-content',
    level: 'error',
    doc: 'literal { } inside a <style> content literal must be escaped as \\{ \\} — the XMLView binding parser reads unescaped braces in attribute values as a binding and crashes (render-smoke caught app 028; apps 026/031 were the same class)',
    find(content) {
      const out = [];
      content.split('\n').forEach((l, i) => {
        for (const m of l.matchAll(/`((?:[^`]|``)*)`/g)) {
          if (!m[1].includes('<style>')) continue;
          if (/(?<!\\)[{}]/.test(m[1])) out.push({ line: i + 1, text: m[1].slice(0, 80) });
        }
      });
      return out;
    },
  },
  {
    id: 'param-continuation-align',
    level: 'warn',
    doc: 'a t_arg continuation line must start in the same column as the val parameter above it — human-taught alignment fix, 2026-07-16 (apps 007/008)',
    find(content) {
      const out = [];
      const lines = content.split('\n');
      lines.forEach((l, i) => {
        const m = l.match(/^(\s+)t_arg =/);
        if (!m || i === 0) return;
        const vm = lines[i - 1].match(/^(.*?)\bval\s+=/);
        if (vm && m[1].length !== vm[1].length) {
          out.push({ line: i + 1, text: `t_arg at col ${m[1].length + 1}, val at col ${vm[1].length + 1}` });
        }
      });
      return out;
    },
  },
  {
    id: 'blank-between-shuts',
    level: 'warn',
    doc: 'blank line between two )->shut( lines — §5 formatting: none after a shut or between shuts (a blank before the next open/leaf sibling block is fine)',
    find(content) {
      const out = [];
      for (const m of content.matchAll(/->shut\(\s*\n[ \t]*\n[ \t]*\)->shut\(/g)) {
        out.push({ line: lineOf(content, m.index), text: 'blank line separating two shuts' });
      }
      return out;
    },
  },
  {
    id: 'no-blank-before-shut',
    level: 'warn',
    doc: 'a )->shut( must be preceded by a blank line (or another shut) — §5 formatting: a blank before every shut',
    find(content) {
      const out = [];
      const lines = content.split('\n');
      lines.forEach((l, i) => {
        if (!/->shut\(\s*\)?\.?\s*$/.test(l)) return;
        const prev = lines[i - 1] ?? '';
        if (prev.trim() !== '' && !/->shut\(/.test(prev)) {
          out.push({ line: i + 1, text: `preceded by: ${prev.trim().slice(0, 60)}` });
        }
      });
      return out;
    },
  },
  {
    id: 'dead-event-wire',
    level: 'error',
    doc: 'client->_event( … ) wired in the view but the class has no on_event/check_on_event dispatcher — the event fires a round-trip that no branch handles (dead wire; the 2026-07-27 review sweep found 8 such ports in the b05-b07 stress batches). Either dispatch it or drop the wire for a bindable property.',
    find(content) {
      const out = [];
      if (!/INTERFACES\s+z2ui5_if_app/i.test(content)) return out; // ports only
      if (!/->_event\(/.test(content)) return out;
      if (/on_event/.test(content)) return out; // matches check_on_event too
      const m = content.match(/->_event\(/);
      out.push({ line: lineOf(content, m.index), text: '_event( ) wired but no on_event/check_on_event in the class' });
      return out;
    },
  },
  {
    id: 'unguarded-date-formatter',
    level: 'error',
    doc: "a { path: 'X', formatter: 'Formatter.DateCreateObject' } binding over a field the SAME class seeds empty somewhere — Formatter.DateCreateObject('') is new Date('') = Invalid Date, and an Invalid Date is TRUTHY, so a consumer that branches on the property (sap.ui.unified Month._checkDateEnabled -> CalendarDate.fromLocalJSDate) throws and the view dies. One bound template cannot omit an attribute per row, so guard the conversion in the binding instead: `{= ${X} ? Formatter.DateCreateObject(${X}) : null }` in a BACKTICK literal. App 220, probe-verified 2026-07-28 (scripts/probes/calendar-empty-enddate-probe.mjs)",
    find(content) {
      const out = [];
      for (const m of content.matchAll(/path:\s*'(\w+)'\s*,\s*formatter:\s*'Formatter\.DateCreateObject'/g)) {
        const field = m[1];
        // the same class seeds that field with an empty literal in a VALUE block
        const seeded = new RegExp('\\b' + field + '\\s*=\\s*(``|\\|\\||\'\')(?![^\\n]*[`\'|])', 'i');
        if (seeded.test(content)) {
          out.push({ line: lineOf(content, m.index), text: `${field} is converted with Formatter.DateCreateObject but seeded empty — guard it with an expression binding` });
        }
      }
      return out;
    },
  },
  {
    id: 'uncurated-formatter',
    level: 'error',
    doc: "a `formatter: 'Formatter.<fn>'` / `z2ui5.Formatter.<fn>` binding naming a function the framework's curated module does not export. UI5 resolves the string at binding time: an unknown name silently yields no value, so the property is simply never set and the cell renders blank - no error, nothing red in CI. The curated set is deliberately tiny and shrinks when a function turns out to be business logic (the demo kit pack - round2DP, dimensions, stockStatusState, stockStatusIcon, deliveryStatusState - and weightState/weightStateByValue before it were all REMOVED, which broke two samples exactly this way). If the value the port needs is not in the list below, it is not a formatting problem: compute it in model_init and bind the finished field (state=\"{MY_STATE}\"). Source of truth: abap2UI5 app/webapp/model/formatter.js, gated there by .github/scripts/formatter-scope-gate.mjs",
    find(content) {
      // the complete curated export surface; keep in sync with
      // abap2UI5 app/webapp/model/formatter.js (its own gate guards that end)
      const CURATED = new Set([
        'DateCreateObject',
        'DateAbapDateToDateObject',
        'DateAbapDateTimeToDateObject',
        'expandInlineIcons',
      ]);
      const out = [];
      // both wirings: the core:require alias and the published global, in
      // both forms - the `formatter:` binding-info key and a call inside an
      // expression binding. The call form allows NO space before the paren,
      // which is what keeps prose like "its frontend Formatter.js (weightState:
      // ...)" in a deviation note from matching.
      for (const m of content.matchAll(/(?:z2ui5\.)?Formatter\.(\w+)\(|formatter:\s*'(?:z2ui5\.)?Formatter\.(\w+)'/g)) {
        const fn = m[1] || m[2];
        if (!CURATED.has(fn)) {
          out.push({ line: lineOf(content, m.index), text: `Formatter.${fn} is not in the curated module - compute it in ABAP and bind the finished field` });
        }
      }
      return out;
    },
  },
  {
    id: 'duplicate-for-iterator',
    level: 'error',
    doc: 'the same `FOR <n> = …` iterator name used twice in ONE method — the 702 downport materializes each as `DATA <n> TYPE i`, so the downported class (and the e2e transpiler) fails with "Variable name already defined". Use distinct names (i, j, k) per VALUE block; app 234, 2026-07-26',
    find(content) {
      const out = [];
      for (const mm of content.matchAll(/\bMETHOD\b[\s\S]*?\bENDMETHOD\b/g)) {
        const seen = new Map(); // name -> first index (relative to method)
        for (const m of mm[0].matchAll(/\bFOR\s+(\w+)\s*=/g)) {
          if (seen.has(m[1])) {
            out.push({ line: lineOf(content, mm.index + m.index), text: `iterator "${m[1]}" reused (first at line ${lineOf(content, mm.index + seen.get(m[1]))})` });
          } else {
            seen.set(m[1], m.index);
          }
        }
      }
      return out;
    },
  },
];

// control properties that really are numeric in UI5 (a string bound to one of
// them is what UI5 2.x strict-type validation rejects). Keyed by control name
// as written in the view builder; anything not listed is treated as a string
// property, so the rule stays silent rather than guessing.
const NUMERIC_PROPS = {
  Slider: ['value', 'min', 'max', 'step'],
  RangeSlider: ['value', 'value2', 'min', 'max', 'step'],
  StepInput: ['value', 'min', 'max', 'step'],
  ProgressIndicator: ['percentValue'],
  RatingIndicator: ['value', 'maxValue', 'iconSize'],
};

// true when some `_bind( name )` of the field lands on a numeric property of
// its enclosing control (the nearest `leaf(`/`open(` above it)
function boundToNumericProp(content, name) {
  for (const b of content.matchAll(new RegExp(`_bind(?:_edit)?\\(\\s*${name}\\s*\\)`, 'g'))) {
    const from = content.lastIndexOf('\n', b.index) + 1;
    const to = content.indexOf('\n', b.index);
    const line = content.slice(from, to < 0 ? content.length : to);
    const attr = /n\s*=\s*`(\w+)`/.exec(line);
    if (!attr) continue;
    const before = content.slice(0, from);
    const ctrl = [...before.matchAll(/->(?:leaf|open)\(\s*(?:n\s*=\s*)?`(\w+)`/g)].pop();
    if (!ctrl) continue;
    if ((NUMERIC_PROPS[ctrl[1]] || []).includes(attr[1])) return true;
  }
  return false;
}

function grepLines(re) {
  return (content) => {
    const out = [];
    content.split('\n').forEach((l, i) => {
      if (re.test(l)) out.push({ line: i + 1, text: l.trim().slice(0, 90) });
    });
    return out;
  };
}

function walk(dir, ext = '.clas.abap', out = []) {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) walk(full, ext, out);
    else if (full.endsWith(ext)) out.push(full);
  }
  return out;
}

let errors = 0;
let warns = 0;
const seenBaseline = new Set();

// abapGit XML files MUST start with the UTF-8 BOM — abapGit serializes them
// that way, and BOM-less files break the format on the system pull (four
// crept in via agent-written files; human fix PR #38, 2026-07-27). The
// scaffolder and generate-overview both emit the BOM; this gates hand-written
// ones. Checked bytewise, outside the .clas.abap rule loop.
for (const f of walk(SRC, '.xml').sort()) {
  const rel = path.relative(ROOT, f).split(path.sep).join('/');
  const b = fs.readFileSync(f);
  if (!(b[0] === 0xEF && b[1] === 0xBB && b[2] === 0xBF)) {
    console.log(`ERROR ${rel}:1 [abapgit-xml-bom] file does not start with the UTF-8 BOM`);
    console.log('      abapGit XML must begin with EF BB BF — copy a reference clas.xml byte-exactly (PR #38 lesson, 2026-07-27)');
    errors++;
  }
}

for (const f of walk(SRC).sort()) {
  const rel = path.relative(ROOT, f).split(path.sep).join('/');
  const isPort = /^src\/[^/]+\/b\d+\//.test(rel);
  const content = fs.readFileSync(f, 'utf8');
  for (const rule of RULES) {
    if (rule.portsOnly && !isPort) continue;
    const hits = rule.find(content);
    if (!hits.length) continue;
    const key = `${rule.id}|${rel}`;
    if (rule.level === 'error' && BASELINE.has(key)) {
      seenBaseline.add(key);
      console.log(`BASELINE ${rel} [${rule.id}] ${hits.length} known finding(s), tracked in STATUS.md`);
      continue;
    }
    for (const h of hits) {
      console.log(`${rule.level.toUpperCase()} ${rel}:${h.line} [${rule.id}] ${h.text}`);
      console.log(`      ${rule.doc}`);
      if (rule.level === 'error') errors++; else warns++;
    }
  }
}

for (const key of BASELINE) {
  if (!seenBaseline.has(key)) {
    console.log(`STALE baseline entry no longer matches — remove it: ${key}`);
  }
}

console.log(`\npattern-lint: ${errors} error(s), ${warns} warning(s), ` +
  `${seenBaseline.size}/${BASELINE.size} baseline entries matched.`);
process.exit(errors ? 1 : 0);
