#!/usr/bin/env node
/*
 * pattern-lint — deterministic gate against re-learning old mistakes.
 *
 * Every rule here encodes a lesson that already bit us once (AGENTS.md §10 /
 * CAPABILITIES.md): once a mistake is understood, it becomes a rule so it can
 * never be merged again — regardless of whether the generator repeats it.
 *
 * SCOPE (since 2026-08-04): only CORPUS-POLICY rules live here — method
 * order, formatting, sidecar conventions, and lessons no generic linter can
 * know. Everything generic moved into @abap2ui5/linter, where every consumer
 * sees it and view-gates gates it for this corpus: popover-display-val,
 * uncurated-formatter, hardcoded-binding-path, obsolete-binder
 * (obsolete-bind-edit), event-arg-unresolved (event-arg-bare-brace),
 * unescaped/collapsed-brace-in-style, invalid-frontend-action
 * (control-by-id-empty-view-slot), binding-type-mismatch
 * (numeric-bound-as-string), relative-binding-without-context
 * (relative-bind-on-root-field), duplicate-for-iterator, ui5-internal-access
 * (private-mproperties) and commercial-ui5-host. Do NOT re-add a
 * rule here that the linter can express — one rule set, two enforcement
 * points was exactly how the editor and CI drifted apart before.
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

const lineOf = (content, idx) => content.slice(0, idx).split('\n').length;

const RULES = [
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
    id: 'blank-between-ends',
    level: 'warn',
    doc: 'blank line between two )->end( lines — §5 formatting: none after an end or between ends (a blank before the next ele/tag sibling block is fine)',
    find(content) {
      const out = [];
      for (const m of content.matchAll(/->end\(\s*\n[ \t]*\n[ \t]*\)->end\(/g)) {
        out.push({ line: lineOf(content, m.index), text: 'blank line separating two ends' });
      }
      return out;
    },
  },
  {
    id: 'no-blank-before-end',
    level: 'warn',
    doc: 'a )->end( must be preceded by a blank line (or another end) — §5 formatting: a blank before every end',
    find(content) {
      const out = [];
      const lines = content.split('\n');
      lines.forEach((l, i) => {
        if (!/->end\(\s*\)?\.?\s*$/.test(l)) return;
        const prev = lines[i - 1] ?? '';
        if (prev.trim() !== '' && !/->end\(/.test(prev)) {
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
      /* A class may also dispatch inline, straight off the event name — the
       * samples style, which the src/03 SAPUI5 collection is written in
       * (AGENTS §3). `CASE client->get( )-event.` with a WHEN branch IS a
       * dispatcher, so the wire is not dead; ports still have to use on_event,
       * which the method-order rules below enforce for them. */
      if (/get\(\s*\)-event/.test(content) && /\bWHEN\b/.test(content)) return out;
      const m = content.match(/->_event\(/);
      out.push({ line: lineOf(content, m.index), text: '_event( ) wired but no on_event/check_on_event dispatcher and no CASE on get( )-event' });
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
];

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
  const isPort = /^src\/\d+\/\d+\/[^/]+$/.test(rel);
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
